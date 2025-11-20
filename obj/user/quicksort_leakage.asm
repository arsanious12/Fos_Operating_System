
obj/user/quicksort_leakage:     file format elf32-i386


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
  800031:	e8 c8 05 00 00       	call   8005fe <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
void QuickSort(int *Elements, int NumOfElements);
void QSort(int *Elements,int NumOfElements, int startIndex, int finalIndex);
uint32 CheckSorted(int *Elements, int NumOfElements);

void _main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	81 ec 18 01 00 00    	sub    $0x118,%esp
		//2012: lock the interrupt
		//sys_lock_cons();
		//2024: lock the console only using a sleepLock
		int NumOfElements;
		int *Elements;
		sys_lock_cons();
  800041:	e8 5e 1d 00 00       	call   801da4 <sys_lock_cons>
		{
			cprintf("\n");
  800046:	83 ec 0c             	sub    $0xc,%esp
  800049:	68 00 30 80 00       	push   $0x803000
  80004e:	e8 3e 0a 00 00       	call   800a91 <cprintf>
  800053:	83 c4 10             	add    $0x10,%esp
			cprintf("!!!!!!!!!!!!!!!!!!!!!!!\n");
  800056:	83 ec 0c             	sub    $0xc,%esp
  800059:	68 02 30 80 00       	push   $0x803002
  80005e:	e8 2e 0a 00 00       	call   800a91 <cprintf>
  800063:	83 c4 10             	add    $0x10,%esp
			cprintf("!!!   QUICK SORT    !!!\n");
  800066:	83 ec 0c             	sub    $0xc,%esp
  800069:	68 1b 30 80 00       	push   $0x80301b
  80006e:	e8 1e 0a 00 00       	call   800a91 <cprintf>
  800073:	83 c4 10             	add    $0x10,%esp
			cprintf("!!!!!!!!!!!!!!!!!!!!!!!\n");
  800076:	83 ec 0c             	sub    $0xc,%esp
  800079:	68 02 30 80 00       	push   $0x803002
  80007e:	e8 0e 0a 00 00       	call   800a91 <cprintf>
  800083:	83 c4 10             	add    $0x10,%esp
			cprintf("\n");
  800086:	83 ec 0c             	sub    $0xc,%esp
  800089:	68 00 30 80 00       	push   $0x803000
  80008e:	e8 fe 09 00 00       	call   800a91 <cprintf>
  800093:	83 c4 10             	add    $0x10,%esp

			readline("Enter the number of elements: ", Line);
  800096:	83 ec 08             	sub    $0x8,%esp
  800099:	8d 85 e9 fe ff ff    	lea    -0x117(%ebp),%eax
  80009f:	50                   	push   %eax
  8000a0:	68 34 30 80 00       	push   $0x803034
  8000a5:	e8 c0 10 00 00       	call   80116a <readline>
  8000aa:	83 c4 10             	add    $0x10,%esp
			NumOfElements = strtol(Line, NULL, 10) ;
  8000ad:	83 ec 04             	sub    $0x4,%esp
  8000b0:	6a 0a                	push   $0xa
  8000b2:	6a 00                	push   $0x0
  8000b4:	8d 85 e9 fe ff ff    	lea    -0x117(%ebp),%eax
  8000ba:	50                   	push   %eax
  8000bb:	e8 c1 16 00 00       	call   801781 <strtol>
  8000c0:	83 c4 10             	add    $0x10,%esp
  8000c3:	89 45 f0             	mov    %eax,-0x10(%ebp)
			cprintf("Chose the initialization method:\n") ;
  8000c6:	83 ec 0c             	sub    $0xc,%esp
  8000c9:	68 54 30 80 00       	push   $0x803054
  8000ce:	e8 be 09 00 00       	call   800a91 <cprintf>
  8000d3:	83 c4 10             	add    $0x10,%esp
			cprintf("a) Ascending\n") ;
  8000d6:	83 ec 0c             	sub    $0xc,%esp
  8000d9:	68 76 30 80 00       	push   $0x803076
  8000de:	e8 ae 09 00 00       	call   800a91 <cprintf>
  8000e3:	83 c4 10             	add    $0x10,%esp
			cprintf("b) Descending\n") ;
  8000e6:	83 ec 0c             	sub    $0xc,%esp
  8000e9:	68 84 30 80 00       	push   $0x803084
  8000ee:	e8 9e 09 00 00       	call   800a91 <cprintf>
  8000f3:	83 c4 10             	add    $0x10,%esp
			cprintf("c) Semi random\n");
  8000f6:	83 ec 0c             	sub    $0xc,%esp
  8000f9:	68 93 30 80 00       	push   $0x803093
  8000fe:	e8 8e 09 00 00       	call   800a91 <cprintf>
  800103:	83 c4 10             	add    $0x10,%esp
			do
			{
				cprintf("Select: ") ;
  800106:	83 ec 0c             	sub    $0xc,%esp
  800109:	68 a3 30 80 00       	push   $0x8030a3
  80010e:	e8 7e 09 00 00       	call   800a91 <cprintf>
  800113:	83 c4 10             	add    $0x10,%esp
				Chose = getchar() ;
  800116:	e8 c6 04 00 00       	call   8005e1 <getchar>
  80011b:	88 45 f7             	mov    %al,-0x9(%ebp)
				cputchar(Chose);
  80011e:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  800122:	83 ec 0c             	sub    $0xc,%esp
  800125:	50                   	push   %eax
  800126:	e8 97 04 00 00       	call   8005c2 <cputchar>
  80012b:	83 c4 10             	add    $0x10,%esp
				cputchar('\n');
  80012e:	83 ec 0c             	sub    $0xc,%esp
  800131:	6a 0a                	push   $0xa
  800133:	e8 8a 04 00 00       	call   8005c2 <cputchar>
  800138:	83 c4 10             	add    $0x10,%esp
			} while (Chose != 'a' && Chose != 'b' && Chose != 'c');
  80013b:	80 7d f7 61          	cmpb   $0x61,-0x9(%ebp)
  80013f:	74 0c                	je     80014d <_main+0x115>
  800141:	80 7d f7 62          	cmpb   $0x62,-0x9(%ebp)
  800145:	74 06                	je     80014d <_main+0x115>
  800147:	80 7d f7 63          	cmpb   $0x63,-0x9(%ebp)
  80014b:	75 b9                	jne    800106 <_main+0xce>
		}
		//2012: unlock
		sys_unlock_cons();
  80014d:	e8 6c 1c 00 00       	call   801dbe <sys_unlock_cons>

		Elements = malloc(sizeof(int) * NumOfElements) ;
  800152:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800155:	c1 e0 02             	shl    $0x2,%eax
  800158:	83 ec 0c             	sub    $0xc,%esp
  80015b:	50                   	push   %eax
  80015c:	e8 fa 1a 00 00       	call   801c5b <malloc>
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
  800183:	e8 f5 02 00 00       	call   80047d <InitializeAscending>
  800188:	83 c4 10             	add    $0x10,%esp
			break ;
  80018b:	eb 37                	jmp    8001c4 <_main+0x18c>
		case 'b':
			InitializeDescending(Elements, NumOfElements);
  80018d:	83 ec 08             	sub    $0x8,%esp
  800190:	ff 75 f0             	pushl  -0x10(%ebp)
  800193:	ff 75 ec             	pushl  -0x14(%ebp)
  800196:	e8 13 03 00 00       	call   8004ae <InitializeDescending>
  80019b:	83 c4 10             	add    $0x10,%esp
			break ;
  80019e:	eb 24                	jmp    8001c4 <_main+0x18c>
		case 'c':
			InitializeSemiRandom(Elements, NumOfElements);
  8001a0:	83 ec 08             	sub    $0x8,%esp
  8001a3:	ff 75 f0             	pushl  -0x10(%ebp)
  8001a6:	ff 75 ec             	pushl  -0x14(%ebp)
  8001a9:	e8 35 03 00 00       	call   8004e3 <InitializeSemiRandom>
  8001ae:	83 c4 10             	add    $0x10,%esp
			break ;
  8001b1:	eb 11                	jmp    8001c4 <_main+0x18c>
		default:
			InitializeSemiRandom(Elements, NumOfElements);
  8001b3:	83 ec 08             	sub    $0x8,%esp
  8001b6:	ff 75 f0             	pushl  -0x10(%ebp)
  8001b9:	ff 75 ec             	pushl  -0x14(%ebp)
  8001bc:	e8 22 03 00 00       	call   8004e3 <InitializeSemiRandom>
  8001c1:	83 c4 10             	add    $0x10,%esp
		}

		QuickSort(Elements, NumOfElements);
  8001c4:	83 ec 08             	sub    $0x8,%esp
  8001c7:	ff 75 f0             	pushl  -0x10(%ebp)
  8001ca:	ff 75 ec             	pushl  -0x14(%ebp)
  8001cd:	e8 f0 00 00 00       	call   8002c2 <QuickSort>
  8001d2:	83 c4 10             	add    $0x10,%esp

		sys_lock_cons();
  8001d5:	e8 ca 1b 00 00       	call   801da4 <sys_lock_cons>
		{
			cprintf("Sorting is Finished!!!!it'll be checked now....\n") ;
  8001da:	83 ec 0c             	sub    $0xc,%esp
  8001dd:	68 ac 30 80 00       	push   $0x8030ac
  8001e2:	e8 aa 08 00 00       	call   800a91 <cprintf>
  8001e7:	83 c4 10             	add    $0x10,%esp
			//		PrintElements(Elements, NumOfElements);
		}
		sys_unlock_cons();
  8001ea:	e8 cf 1b 00 00       	call   801dbe <sys_unlock_cons>

		uint32 Sorted = CheckSorted(Elements, NumOfElements);
  8001ef:	83 ec 08             	sub    $0x8,%esp
  8001f2:	ff 75 f0             	pushl  -0x10(%ebp)
  8001f5:	ff 75 ec             	pushl  -0x14(%ebp)
  8001f8:	e8 d6 01 00 00       	call   8003d3 <CheckSorted>
  8001fd:	83 c4 10             	add    $0x10,%esp
  800200:	89 45 e8             	mov    %eax,-0x18(%ebp)

		if(Sorted == 0) panic("The array is NOT sorted correctly") ;
  800203:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  800207:	75 14                	jne    80021d <_main+0x1e5>
  800209:	83 ec 04             	sub    $0x4,%esp
  80020c:	68 e0 30 80 00       	push   $0x8030e0
  800211:	6a 51                	push   $0x51
  800213:	68 02 31 80 00       	push   $0x803102
  800218:	e8 a6 05 00 00       	call   8007c3 <_panic>
		else
		{
			sys_lock_cons();
  80021d:	e8 82 1b 00 00       	call   801da4 <sys_lock_cons>
			{
				cprintf("===============================================\n") ;
  800222:	83 ec 0c             	sub    $0xc,%esp
  800225:	68 1c 31 80 00       	push   $0x80311c
  80022a:	e8 62 08 00 00       	call   800a91 <cprintf>
  80022f:	83 c4 10             	add    $0x10,%esp
				cprintf("Congratulations!! The array is sorted correctly\n") ;
  800232:	83 ec 0c             	sub    $0xc,%esp
  800235:	68 50 31 80 00       	push   $0x803150
  80023a:	e8 52 08 00 00       	call   800a91 <cprintf>
  80023f:	83 c4 10             	add    $0x10,%esp
				cprintf("===============================================\n\n") ;
  800242:	83 ec 0c             	sub    $0xc,%esp
  800245:	68 84 31 80 00       	push   $0x803184
  80024a:	e8 42 08 00 00       	call   800a91 <cprintf>
  80024f:	83 c4 10             	add    $0x10,%esp
			}
			sys_unlock_cons();
  800252:	e8 67 1b 00 00       	call   801dbe <sys_unlock_cons>
		}

		sys_lock_cons();
  800257:	e8 48 1b 00 00       	call   801da4 <sys_lock_cons>
		{
			Chose = 0 ;
  80025c:	c6 45 f7 00          	movb   $0x0,-0x9(%ebp)
			while (Chose != 'y' && Chose != 'n')
  800260:	eb 42                	jmp    8002a4 <_main+0x26c>
			{
				cprintf("Do you want to repeat (y/n): ") ;
  800262:	83 ec 0c             	sub    $0xc,%esp
  800265:	68 b6 31 80 00       	push   $0x8031b6
  80026a:	e8 22 08 00 00       	call   800a91 <cprintf>
  80026f:	83 c4 10             	add    $0x10,%esp
				Chose = getchar() ;
  800272:	e8 6a 03 00 00       	call   8005e1 <getchar>
  800277:	88 45 f7             	mov    %al,-0x9(%ebp)
				cputchar(Chose);
  80027a:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  80027e:	83 ec 0c             	sub    $0xc,%esp
  800281:	50                   	push   %eax
  800282:	e8 3b 03 00 00       	call   8005c2 <cputchar>
  800287:	83 c4 10             	add    $0x10,%esp
				cputchar('\n');
  80028a:	83 ec 0c             	sub    $0xc,%esp
  80028d:	6a 0a                	push   $0xa
  80028f:	e8 2e 03 00 00       	call   8005c2 <cputchar>
  800294:	83 c4 10             	add    $0x10,%esp
				cputchar('\n');
  800297:	83 ec 0c             	sub    $0xc,%esp
  80029a:	6a 0a                	push   $0xa
  80029c:	e8 21 03 00 00       	call   8005c2 <cputchar>
  8002a1:	83 c4 10             	add    $0x10,%esp
		}

		sys_lock_cons();
		{
			Chose = 0 ;
			while (Chose != 'y' && Chose != 'n')
  8002a4:	80 7d f7 79          	cmpb   $0x79,-0x9(%ebp)
  8002a8:	74 06                	je     8002b0 <_main+0x278>
  8002aa:	80 7d f7 6e          	cmpb   $0x6e,-0x9(%ebp)
  8002ae:	75 b2                	jne    800262 <_main+0x22a>
				cputchar(Chose);
				cputchar('\n');
				cputchar('\n');
			}
		}
		sys_unlock_cons();
  8002b0:	e8 09 1b 00 00       	call   801dbe <sys_unlock_cons>

	} while (Chose == 'y');
  8002b5:	80 7d f7 79          	cmpb   $0x79,-0x9(%ebp)
  8002b9:	0f 84 82 fd ff ff    	je     800041 <_main+0x9>

}
  8002bf:	90                   	nop
  8002c0:	c9                   	leave  
  8002c1:	c3                   	ret    

008002c2 <QuickSort>:

///Quick sort
void QuickSort(int *Elements, int NumOfElements)
{
  8002c2:	55                   	push   %ebp
  8002c3:	89 e5                	mov    %esp,%ebp
  8002c5:	83 ec 08             	sub    $0x8,%esp
	QSort(Elements, NumOfElements, 0, NumOfElements-1) ;
  8002c8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8002cb:	48                   	dec    %eax
  8002cc:	50                   	push   %eax
  8002cd:	6a 00                	push   $0x0
  8002cf:	ff 75 0c             	pushl  0xc(%ebp)
  8002d2:	ff 75 08             	pushl  0x8(%ebp)
  8002d5:	e8 06 00 00 00       	call   8002e0 <QSort>
  8002da:	83 c4 10             	add    $0x10,%esp
}
  8002dd:	90                   	nop
  8002de:	c9                   	leave  
  8002df:	c3                   	ret    

008002e0 <QSort>:


void QSort(int *Elements,int NumOfElements, int startIndex, int finalIndex)
{
  8002e0:	55                   	push   %ebp
  8002e1:	89 e5                	mov    %esp,%ebp
  8002e3:	83 ec 18             	sub    $0x18,%esp
	if (startIndex >= finalIndex) return;
  8002e6:	8b 45 10             	mov    0x10(%ebp),%eax
  8002e9:	3b 45 14             	cmp    0x14(%ebp),%eax
  8002ec:	0f 8d de 00 00 00    	jge    8003d0 <QSort+0xf0>

	int i = startIndex+1, j = finalIndex;
  8002f2:	8b 45 10             	mov    0x10(%ebp),%eax
  8002f5:	40                   	inc    %eax
  8002f6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8002f9:	8b 45 14             	mov    0x14(%ebp),%eax
  8002fc:	89 45 f0             	mov    %eax,-0x10(%ebp)

	while (i <= j)
  8002ff:	e9 80 00 00 00       	jmp    800384 <QSort+0xa4>
	{
		while (i <= finalIndex && Elements[startIndex] >= Elements[i]) i++;
  800304:	ff 45 f4             	incl   -0xc(%ebp)
  800307:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80030a:	3b 45 14             	cmp    0x14(%ebp),%eax
  80030d:	7f 2b                	jg     80033a <QSort+0x5a>
  80030f:	8b 45 10             	mov    0x10(%ebp),%eax
  800312:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800319:	8b 45 08             	mov    0x8(%ebp),%eax
  80031c:	01 d0                	add    %edx,%eax
  80031e:	8b 10                	mov    (%eax),%edx
  800320:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800323:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  80032a:	8b 45 08             	mov    0x8(%ebp),%eax
  80032d:	01 c8                	add    %ecx,%eax
  80032f:	8b 00                	mov    (%eax),%eax
  800331:	39 c2                	cmp    %eax,%edx
  800333:	7d cf                	jge    800304 <QSort+0x24>
		while (j > startIndex && Elements[startIndex] <= Elements[j]) j--;
  800335:	eb 03                	jmp    80033a <QSort+0x5a>
  800337:	ff 4d f0             	decl   -0x10(%ebp)
  80033a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80033d:	3b 45 10             	cmp    0x10(%ebp),%eax
  800340:	7e 26                	jle    800368 <QSort+0x88>
  800342:	8b 45 10             	mov    0x10(%ebp),%eax
  800345:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80034c:	8b 45 08             	mov    0x8(%ebp),%eax
  80034f:	01 d0                	add    %edx,%eax
  800351:	8b 10                	mov    (%eax),%edx
  800353:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800356:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  80035d:	8b 45 08             	mov    0x8(%ebp),%eax
  800360:	01 c8                	add    %ecx,%eax
  800362:	8b 00                	mov    (%eax),%eax
  800364:	39 c2                	cmp    %eax,%edx
  800366:	7e cf                	jle    800337 <QSort+0x57>

		if (i <= j)
  800368:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80036b:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80036e:	7f 14                	jg     800384 <QSort+0xa4>
		{
			Swap(Elements, i, j);
  800370:	83 ec 04             	sub    $0x4,%esp
  800373:	ff 75 f0             	pushl  -0x10(%ebp)
  800376:	ff 75 f4             	pushl  -0xc(%ebp)
  800379:	ff 75 08             	pushl  0x8(%ebp)
  80037c:	e8 a9 00 00 00       	call   80042a <Swap>
  800381:	83 c4 10             	add    $0x10,%esp
{
	if (startIndex >= finalIndex) return;

	int i = startIndex+1, j = finalIndex;

	while (i <= j)
  800384:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800387:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80038a:	0f 8e 77 ff ff ff    	jle    800307 <QSort+0x27>
		{
			Swap(Elements, i, j);
		}
	}

	Swap( Elements, startIndex, j);
  800390:	83 ec 04             	sub    $0x4,%esp
  800393:	ff 75 f0             	pushl  -0x10(%ebp)
  800396:	ff 75 10             	pushl  0x10(%ebp)
  800399:	ff 75 08             	pushl  0x8(%ebp)
  80039c:	e8 89 00 00 00       	call   80042a <Swap>
  8003a1:	83 c4 10             	add    $0x10,%esp

	QSort(Elements, NumOfElements, startIndex, j - 1);
  8003a4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8003a7:	48                   	dec    %eax
  8003a8:	50                   	push   %eax
  8003a9:	ff 75 10             	pushl  0x10(%ebp)
  8003ac:	ff 75 0c             	pushl  0xc(%ebp)
  8003af:	ff 75 08             	pushl  0x8(%ebp)
  8003b2:	e8 29 ff ff ff       	call   8002e0 <QSort>
  8003b7:	83 c4 10             	add    $0x10,%esp
	QSort(Elements, NumOfElements, i, finalIndex);
  8003ba:	ff 75 14             	pushl  0x14(%ebp)
  8003bd:	ff 75 f4             	pushl  -0xc(%ebp)
  8003c0:	ff 75 0c             	pushl  0xc(%ebp)
  8003c3:	ff 75 08             	pushl  0x8(%ebp)
  8003c6:	e8 15 ff ff ff       	call   8002e0 <QSort>
  8003cb:	83 c4 10             	add    $0x10,%esp
  8003ce:	eb 01                	jmp    8003d1 <QSort+0xf1>
}


void QSort(int *Elements,int NumOfElements, int startIndex, int finalIndex)
{
	if (startIndex >= finalIndex) return;
  8003d0:	90                   	nop
	QSort(Elements, NumOfElements, startIndex, j - 1);
	QSort(Elements, NumOfElements, i, finalIndex);

	//cprintf("qs,after sorting: start = %d, end = %d\n", startIndex, finalIndex);

}
  8003d1:	c9                   	leave  
  8003d2:	c3                   	ret    

008003d3 <CheckSorted>:

uint32 CheckSorted(int *Elements, int NumOfElements)
{
  8003d3:	55                   	push   %ebp
  8003d4:	89 e5                	mov    %esp,%ebp
  8003d6:	83 ec 10             	sub    $0x10,%esp
	uint32 Sorted = 1 ;
  8003d9:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
	int i ;
	for (i = 0 ; i < NumOfElements - 1; i++)
  8003e0:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8003e7:	eb 33                	jmp    80041c <CheckSorted+0x49>
	{
		if (Elements[i] > Elements[i+1])
  8003e9:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8003ec:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8003f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8003f6:	01 d0                	add    %edx,%eax
  8003f8:	8b 10                	mov    (%eax),%edx
  8003fa:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8003fd:	40                   	inc    %eax
  8003fe:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800405:	8b 45 08             	mov    0x8(%ebp),%eax
  800408:	01 c8                	add    %ecx,%eax
  80040a:	8b 00                	mov    (%eax),%eax
  80040c:	39 c2                	cmp    %eax,%edx
  80040e:	7e 09                	jle    800419 <CheckSorted+0x46>
		{
			Sorted = 0 ;
  800410:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
			break;
  800417:	eb 0c                	jmp    800425 <CheckSorted+0x52>

uint32 CheckSorted(int *Elements, int NumOfElements)
{
	uint32 Sorted = 1 ;
	int i ;
	for (i = 0 ; i < NumOfElements - 1; i++)
  800419:	ff 45 f8             	incl   -0x8(%ebp)
  80041c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80041f:	48                   	dec    %eax
  800420:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800423:	7f c4                	jg     8003e9 <CheckSorted+0x16>
		{
			Sorted = 0 ;
			break;
		}
	}
	return Sorted ;
  800425:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800428:	c9                   	leave  
  800429:	c3                   	ret    

0080042a <Swap>:

///Private Functions


void Swap(int *Elements, int First, int Second)
{
  80042a:	55                   	push   %ebp
  80042b:	89 e5                	mov    %esp,%ebp
  80042d:	83 ec 10             	sub    $0x10,%esp
	int Tmp = Elements[First] ;
  800430:	8b 45 0c             	mov    0xc(%ebp),%eax
  800433:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80043a:	8b 45 08             	mov    0x8(%ebp),%eax
  80043d:	01 d0                	add    %edx,%eax
  80043f:	8b 00                	mov    (%eax),%eax
  800441:	89 45 fc             	mov    %eax,-0x4(%ebp)
	Elements[First] = Elements[Second] ;
  800444:	8b 45 0c             	mov    0xc(%ebp),%eax
  800447:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80044e:	8b 45 08             	mov    0x8(%ebp),%eax
  800451:	01 c2                	add    %eax,%edx
  800453:	8b 45 10             	mov    0x10(%ebp),%eax
  800456:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  80045d:	8b 45 08             	mov    0x8(%ebp),%eax
  800460:	01 c8                	add    %ecx,%eax
  800462:	8b 00                	mov    (%eax),%eax
  800464:	89 02                	mov    %eax,(%edx)
	Elements[Second] = Tmp ;
  800466:	8b 45 10             	mov    0x10(%ebp),%eax
  800469:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800470:	8b 45 08             	mov    0x8(%ebp),%eax
  800473:	01 c2                	add    %eax,%edx
  800475:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800478:	89 02                	mov    %eax,(%edx)
}
  80047a:	90                   	nop
  80047b:	c9                   	leave  
  80047c:	c3                   	ret    

0080047d <InitializeAscending>:

void InitializeAscending(int *Elements, int NumOfElements)
{
  80047d:	55                   	push   %ebp
  80047e:	89 e5                	mov    %esp,%ebp
  800480:	83 ec 10             	sub    $0x10,%esp
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  800483:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80048a:	eb 17                	jmp    8004a3 <InitializeAscending+0x26>
	{
		(Elements)[i] = i ;
  80048c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80048f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800496:	8b 45 08             	mov    0x8(%ebp),%eax
  800499:	01 c2                	add    %eax,%edx
  80049b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80049e:	89 02                	mov    %eax,(%edx)
}

void InitializeAscending(int *Elements, int NumOfElements)
{
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  8004a0:	ff 45 fc             	incl   -0x4(%ebp)
  8004a3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8004a6:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8004a9:	7c e1                	jl     80048c <InitializeAscending+0xf>
	{
		(Elements)[i] = i ;
	}

}
  8004ab:	90                   	nop
  8004ac:	c9                   	leave  
  8004ad:	c3                   	ret    

008004ae <InitializeDescending>:

void InitializeDescending(int *Elements, int NumOfElements)
{
  8004ae:	55                   	push   %ebp
  8004af:	89 e5                	mov    %esp,%ebp
  8004b1:	83 ec 10             	sub    $0x10,%esp
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  8004b4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8004bb:	eb 1b                	jmp    8004d8 <InitializeDescending+0x2a>
	{
		Elements[i] = NumOfElements - i - 1 ;
  8004bd:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8004c0:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8004c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8004ca:	01 c2                	add    %eax,%edx
  8004cc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004cf:	2b 45 fc             	sub    -0x4(%ebp),%eax
  8004d2:	48                   	dec    %eax
  8004d3:	89 02                	mov    %eax,(%edx)
}

void InitializeDescending(int *Elements, int NumOfElements)
{
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  8004d5:	ff 45 fc             	incl   -0x4(%ebp)
  8004d8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8004db:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8004de:	7c dd                	jl     8004bd <InitializeDescending+0xf>
	{
		Elements[i] = NumOfElements - i - 1 ;
	}

}
  8004e0:	90                   	nop
  8004e1:	c9                   	leave  
  8004e2:	c3                   	ret    

008004e3 <InitializeSemiRandom>:

void InitializeSemiRandom(int *Elements, int NumOfElements)
{
  8004e3:	55                   	push   %ebp
  8004e4:	89 e5                	mov    %esp,%ebp
  8004e6:	83 ec 10             	sub    $0x10,%esp
	int i ;
	int Repetition = NumOfElements / 3 ;
  8004e9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8004ec:	b8 56 55 55 55       	mov    $0x55555556,%eax
  8004f1:	f7 e9                	imul   %ecx
  8004f3:	c1 f9 1f             	sar    $0x1f,%ecx
  8004f6:	89 d0                	mov    %edx,%eax
  8004f8:	29 c8                	sub    %ecx,%eax
  8004fa:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (Repetition == 0)
  8004fd:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800501:	75 07                	jne    80050a <InitializeSemiRandom+0x27>
			Repetition = 3;
  800503:	c7 45 f8 03 00 00 00 	movl   $0x3,-0x8(%ebp)
	for (i = 0 ; i < NumOfElements ; i++)
  80050a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800511:	eb 1e                	jmp    800531 <InitializeSemiRandom+0x4e>
	{
		Elements[i] = i % Repetition ;
  800513:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800516:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80051d:	8b 45 08             	mov    0x8(%ebp),%eax
  800520:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  800523:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800526:	99                   	cltd   
  800527:	f7 7d f8             	idivl  -0x8(%ebp)
  80052a:	89 d0                	mov    %edx,%eax
  80052c:	89 01                	mov    %eax,(%ecx)
{
	int i ;
	int Repetition = NumOfElements / 3 ;
	if (Repetition == 0)
			Repetition = 3;
	for (i = 0 ; i < NumOfElements ; i++)
  80052e:	ff 45 fc             	incl   -0x4(%ebp)
  800531:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800534:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800537:	7c da                	jl     800513 <InitializeSemiRandom+0x30>
	{
		Elements[i] = i % Repetition ;
		//	cprintf("i=%d\n",i);
	}

}
  800539:	90                   	nop
  80053a:	c9                   	leave  
  80053b:	c3                   	ret    

0080053c <PrintElements>:

void PrintElements(int *Elements, int NumOfElements)
{
  80053c:	55                   	push   %ebp
  80053d:	89 e5                	mov    %esp,%ebp
  80053f:	83 ec 18             	sub    $0x18,%esp
	int i ;
	int NumsPerLine = 20 ;
  800542:	c7 45 f0 14 00 00 00 	movl   $0x14,-0x10(%ebp)
	for (i = 0 ; i < NumOfElements-1 ; i++)
  800549:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  800550:	eb 42                	jmp    800594 <PrintElements+0x58>
	{
		if (i%NumsPerLine == 0)
  800552:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800555:	99                   	cltd   
  800556:	f7 7d f0             	idivl  -0x10(%ebp)
  800559:	89 d0                	mov    %edx,%eax
  80055b:	85 c0                	test   %eax,%eax
  80055d:	75 10                	jne    80056f <PrintElements+0x33>
			cprintf("\n");
  80055f:	83 ec 0c             	sub    $0xc,%esp
  800562:	68 00 30 80 00       	push   $0x803000
  800567:	e8 25 05 00 00       	call   800a91 <cprintf>
  80056c:	83 c4 10             	add    $0x10,%esp
		cprintf("%d, ",Elements[i]);
  80056f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800572:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800579:	8b 45 08             	mov    0x8(%ebp),%eax
  80057c:	01 d0                	add    %edx,%eax
  80057e:	8b 00                	mov    (%eax),%eax
  800580:	83 ec 08             	sub    $0x8,%esp
  800583:	50                   	push   %eax
  800584:	68 d4 31 80 00       	push   $0x8031d4
  800589:	e8 03 05 00 00       	call   800a91 <cprintf>
  80058e:	83 c4 10             	add    $0x10,%esp

void PrintElements(int *Elements, int NumOfElements)
{
	int i ;
	int NumsPerLine = 20 ;
	for (i = 0 ; i < NumOfElements-1 ; i++)
  800591:	ff 45 f4             	incl   -0xc(%ebp)
  800594:	8b 45 0c             	mov    0xc(%ebp),%eax
  800597:	48                   	dec    %eax
  800598:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  80059b:	7f b5                	jg     800552 <PrintElements+0x16>
	{
		if (i%NumsPerLine == 0)
			cprintf("\n");
		cprintf("%d, ",Elements[i]);
	}
	cprintf("%d\n",Elements[i]);
  80059d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8005a0:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8005a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8005aa:	01 d0                	add    %edx,%eax
  8005ac:	8b 00                	mov    (%eax),%eax
  8005ae:	83 ec 08             	sub    $0x8,%esp
  8005b1:	50                   	push   %eax
  8005b2:	68 d9 31 80 00       	push   $0x8031d9
  8005b7:	e8 d5 04 00 00       	call   800a91 <cprintf>
  8005bc:	83 c4 10             	add    $0x10,%esp

}
  8005bf:	90                   	nop
  8005c0:	c9                   	leave  
  8005c1:	c3                   	ret    

008005c2 <cputchar>:
#include <inc/lib.h>


void
cputchar(int ch)
{
  8005c2:	55                   	push   %ebp
  8005c3:	89 e5                	mov    %esp,%ebp
  8005c5:	83 ec 18             	sub    $0x18,%esp
	char c = ch;
  8005c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8005cb:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	//sys_cputs(&c, 1);

	sys_cputc(c);
  8005ce:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  8005d2:	83 ec 0c             	sub    $0xc,%esp
  8005d5:	50                   	push   %eax
  8005d6:	e8 11 19 00 00       	call   801eec <sys_cputc>
  8005db:	83 c4 10             	add    $0x10,%esp
}
  8005de:	90                   	nop
  8005df:	c9                   	leave  
  8005e0:	c3                   	ret    

008005e1 <getchar>:


int
getchar(void)
{
  8005e1:	55                   	push   %ebp
  8005e2:	89 e5                	mov    %esp,%ebp
  8005e4:	83 ec 18             	sub    $0x18,%esp
	int c =sys_cgetc();
  8005e7:	e8 9f 17 00 00       	call   801d8b <sys_cgetc>
  8005ec:	89 45 f4             	mov    %eax,-0xc(%ebp)
	return c;
  8005ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  8005f2:	c9                   	leave  
  8005f3:	c3                   	ret    

008005f4 <iscons>:

int iscons(int fdnum)
{
  8005f4:	55                   	push   %ebp
  8005f5:	89 e5                	mov    %esp,%ebp
	// used by readline
	return 1;
  8005f7:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8005fc:	5d                   	pop    %ebp
  8005fd:	c3                   	ret    

008005fe <libmain>:
volatile bool printStats = 1;

volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";
void
libmain(int argc, char **argv)
{
  8005fe:	55                   	push   %ebp
  8005ff:	89 e5                	mov    %esp,%ebp
  800601:	57                   	push   %edi
  800602:	56                   	push   %esi
  800603:	53                   	push   %ebx
  800604:	83 ec 7c             	sub    $0x7c,%esp
	//printStats = 1;
	int envIndex = sys_getenvindex();
  800607:	e8 11 1a 00 00       	call   80201d <sys_getenvindex>
  80060c:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	myEnv = &(envs[envIndex]);
  80060f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800612:	89 d0                	mov    %edx,%eax
  800614:	c1 e0 06             	shl    $0x6,%eax
  800617:	29 d0                	sub    %edx,%eax
  800619:	c1 e0 02             	shl    $0x2,%eax
  80061c:	01 d0                	add    %edx,%eax
  80061e:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800625:	01 c8                	add    %ecx,%eax
  800627:	c1 e0 03             	shl    $0x3,%eax
  80062a:	01 d0                	add    %edx,%eax
  80062c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800633:	29 c2                	sub    %eax,%edx
  800635:	8d 04 95 00 00 00 00 	lea    0x0(,%edx,4),%eax
  80063c:	89 c2                	mov    %eax,%edx
  80063e:	8d 82 00 00 c0 ee    	lea    -0x11400000(%edx),%eax
  800644:	a3 24 40 80 00       	mov    %eax,0x804024

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800649:	a1 24 40 80 00       	mov    0x804024,%eax
  80064e:	8a 40 20             	mov    0x20(%eax),%al
  800651:	84 c0                	test   %al,%al
  800653:	74 0d                	je     800662 <libmain+0x64>
		binaryname = myEnv->prog_name;
  800655:	a1 24 40 80 00       	mov    0x804024,%eax
  80065a:	83 c0 20             	add    $0x20,%eax
  80065d:	a3 04 40 80 00       	mov    %eax,0x804004

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800662:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800666:	7e 0a                	jle    800672 <libmain+0x74>
		binaryname = argv[0];
  800668:	8b 45 0c             	mov    0xc(%ebp),%eax
  80066b:	8b 00                	mov    (%eax),%eax
  80066d:	a3 04 40 80 00       	mov    %eax,0x804004

	// call user main routine
	_main(argc, argv);
  800672:	83 ec 08             	sub    $0x8,%esp
  800675:	ff 75 0c             	pushl  0xc(%ebp)
  800678:	ff 75 08             	pushl  0x8(%ebp)
  80067b:	e8 b8 f9 ff ff       	call   800038 <_main>
  800680:	83 c4 10             	add    $0x10,%esp

	if (printStats)
  800683:	a1 00 40 80 00       	mov    0x804000,%eax
  800688:	85 c0                	test   %eax,%eax
  80068a:	0f 84 01 01 00 00    	je     800791 <libmain+0x193>
	{
		char isOPTReplCmd[100] = "__IsOPTRepl__" ;
  800690:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  800696:	bb d8 32 80 00       	mov    $0x8032d8,%ebx
  80069b:	ba 0e 00 00 00       	mov    $0xe,%edx
  8006a0:	89 c7                	mov    %eax,%edi
  8006a2:	89 de                	mov    %ebx,%esi
  8006a4:	89 d1                	mov    %edx,%ecx
  8006a6:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  8006a8:	8d 55 8a             	lea    -0x76(%ebp),%edx
  8006ab:	b9 56 00 00 00       	mov    $0x56,%ecx
  8006b0:	b0 00                	mov    $0x0,%al
  8006b2:	89 d7                	mov    %edx,%edi
  8006b4:	f3 aa                	rep stos %al,%es:(%edi)
		int isOPTRepl = 0;
  8006b6:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
		sys_utilities(isOPTReplCmd, (uint32)(&isOPTRepl));
  8006bd:	8d 45 e0             	lea    -0x20(%ebp),%eax
  8006c0:	83 ec 08             	sub    $0x8,%esp
  8006c3:	50                   	push   %eax
  8006c4:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  8006ca:	50                   	push   %eax
  8006cb:	e8 83 1b 00 00       	call   802253 <sys_utilities>
  8006d0:	83 c4 10             	add    $0x10,%esp

		sys_lock_cons();
  8006d3:	e8 cc 16 00 00       	call   801da4 <sys_lock_cons>
		{
			cprintf("**************************************\n");
  8006d8:	83 ec 0c             	sub    $0xc,%esp
  8006db:	68 f8 31 80 00       	push   $0x8031f8
  8006e0:	e8 ac 03 00 00       	call   800a91 <cprintf>
  8006e5:	83 c4 10             	add    $0x10,%esp
			if (isOPTRepl)
  8006e8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8006eb:	85 c0                	test   %eax,%eax
  8006ed:	74 18                	je     800707 <libmain+0x109>
			{
				cprintf("OPTIMAL number of page faults = %d\n", sys_get_optimal_num_faults());
  8006ef:	e8 7d 1b 00 00       	call   802271 <sys_get_optimal_num_faults>
  8006f4:	83 ec 08             	sub    $0x8,%esp
  8006f7:	50                   	push   %eax
  8006f8:	68 20 32 80 00       	push   $0x803220
  8006fd:	e8 8f 03 00 00       	call   800a91 <cprintf>
  800702:	83 c4 10             	add    $0x10,%esp
  800705:	eb 59                	jmp    800760 <libmain+0x162>
			}
			else
			{
				cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  800707:	a1 24 40 80 00       	mov    0x804024,%eax
  80070c:	8b 90 50 da 01 00    	mov    0x1da50(%eax),%edx
  800712:	a1 24 40 80 00       	mov    0x804024,%eax
  800717:	8b 80 40 da 01 00    	mov    0x1da40(%eax),%eax
  80071d:	83 ec 04             	sub    $0x4,%esp
  800720:	52                   	push   %edx
  800721:	50                   	push   %eax
  800722:	68 44 32 80 00       	push   $0x803244
  800727:	e8 65 03 00 00       	call   800a91 <cprintf>
  80072c:	83 c4 10             	add    $0x10,%esp
				cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  80072f:	a1 24 40 80 00       	mov    0x804024,%eax
  800734:	8b 88 64 da 01 00    	mov    0x1da64(%eax),%ecx
  80073a:	a1 24 40 80 00       	mov    0x804024,%eax
  80073f:	8b 90 60 da 01 00    	mov    0x1da60(%eax),%edx
  800745:	a1 24 40 80 00       	mov    0x804024,%eax
  80074a:	8b 80 5c da 01 00    	mov    0x1da5c(%eax),%eax
  800750:	51                   	push   %ecx
  800751:	52                   	push   %edx
  800752:	50                   	push   %eax
  800753:	68 6c 32 80 00       	push   $0x80326c
  800758:	e8 34 03 00 00       	call   800a91 <cprintf>
  80075d:	83 c4 10             	add    $0x10,%esp
			}
			//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
			cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800760:	a1 24 40 80 00       	mov    0x804024,%eax
  800765:	8b 80 68 da 01 00    	mov    0x1da68(%eax),%eax
  80076b:	83 ec 08             	sub    $0x8,%esp
  80076e:	50                   	push   %eax
  80076f:	68 c4 32 80 00       	push   $0x8032c4
  800774:	e8 18 03 00 00       	call   800a91 <cprintf>
  800779:	83 c4 10             	add    $0x10,%esp
			cprintf("**************************************\n");
  80077c:	83 ec 0c             	sub    $0xc,%esp
  80077f:	68 f8 31 80 00       	push   $0x8031f8
  800784:	e8 08 03 00 00       	call   800a91 <cprintf>
  800789:	83 c4 10             	add    $0x10,%esp
		}
		sys_unlock_cons();
  80078c:	e8 2d 16 00 00       	call   801dbe <sys_unlock_cons>
	}

	// exit gracefully
	exit();
  800791:	e8 1f 00 00 00       	call   8007b5 <exit>
}
  800796:	90                   	nop
  800797:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80079a:	5b                   	pop    %ebx
  80079b:	5e                   	pop    %esi
  80079c:	5f                   	pop    %edi
  80079d:	5d                   	pop    %ebp
  80079e:	c3                   	ret    

0080079f <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  80079f:	55                   	push   %ebp
  8007a0:	89 e5                	mov    %esp,%ebp
  8007a2:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  8007a5:	83 ec 0c             	sub    $0xc,%esp
  8007a8:	6a 00                	push   $0x0
  8007aa:	e8 3a 18 00 00       	call   801fe9 <sys_destroy_env>
  8007af:	83 c4 10             	add    $0x10,%esp
}
  8007b2:	90                   	nop
  8007b3:	c9                   	leave  
  8007b4:	c3                   	ret    

008007b5 <exit>:

void
exit(void)
{
  8007b5:	55                   	push   %ebp
  8007b6:	89 e5                	mov    %esp,%ebp
  8007b8:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  8007bb:	e8 8f 18 00 00       	call   80204f <sys_exit_env>
}
  8007c0:	90                   	nop
  8007c1:	c9                   	leave  
  8007c2:	c3                   	ret    

008007c3 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  8007c3:	55                   	push   %ebp
  8007c4:	89 e5                	mov    %esp,%ebp
  8007c6:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  8007c9:	8d 45 10             	lea    0x10(%ebp),%eax
  8007cc:	83 c0 04             	add    $0x4,%eax
  8007cf:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  8007d2:	a1 18 c1 81 00       	mov    0x81c118,%eax
  8007d7:	85 c0                	test   %eax,%eax
  8007d9:	74 16                	je     8007f1 <_panic+0x2e>
		cprintf("%s: ", argv0);
  8007db:	a1 18 c1 81 00       	mov    0x81c118,%eax
  8007e0:	83 ec 08             	sub    $0x8,%esp
  8007e3:	50                   	push   %eax
  8007e4:	68 3c 33 80 00       	push   $0x80333c
  8007e9:	e8 a3 02 00 00       	call   800a91 <cprintf>
  8007ee:	83 c4 10             	add    $0x10,%esp
	cprintf_colored(TEXT_PANIC_CLR, "user [EVAL_FINAL]panic in %s at %s:%d: ", binaryname, file, line);
  8007f1:	a1 04 40 80 00       	mov    0x804004,%eax
  8007f6:	83 ec 0c             	sub    $0xc,%esp
  8007f9:	ff 75 0c             	pushl  0xc(%ebp)
  8007fc:	ff 75 08             	pushl  0x8(%ebp)
  8007ff:	50                   	push   %eax
  800800:	68 44 33 80 00       	push   $0x803344
  800805:	6a 74                	push   $0x74
  800807:	e8 b2 02 00 00       	call   800abe <cprintf_colored>
  80080c:	83 c4 20             	add    $0x20,%esp
	vcprintf(fmt, ap);
  80080f:	8b 45 10             	mov    0x10(%ebp),%eax
  800812:	83 ec 08             	sub    $0x8,%esp
  800815:	ff 75 f4             	pushl  -0xc(%ebp)
  800818:	50                   	push   %eax
  800819:	e8 04 02 00 00       	call   800a22 <vcprintf>
  80081e:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  800821:	83 ec 08             	sub    $0x8,%esp
  800824:	6a 00                	push   $0x0
  800826:	68 6c 33 80 00       	push   $0x80336c
  80082b:	e8 f2 01 00 00       	call   800a22 <vcprintf>
  800830:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  800833:	e8 7d ff ff ff       	call   8007b5 <exit>

	// should not return here
	while (1) ;
  800838:	eb fe                	jmp    800838 <_panic+0x75>

0080083a <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  80083a:	55                   	push   %ebp
  80083b:	89 e5                	mov    %esp,%ebp
  80083d:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  800840:	a1 24 40 80 00       	mov    0x804024,%eax
  800845:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  80084b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80084e:	39 c2                	cmp    %eax,%edx
  800850:	74 14                	je     800866 <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  800852:	83 ec 04             	sub    $0x4,%esp
  800855:	68 70 33 80 00       	push   $0x803370
  80085a:	6a 26                	push   $0x26
  80085c:	68 bc 33 80 00       	push   $0x8033bc
  800861:	e8 5d ff ff ff       	call   8007c3 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  800866:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  80086d:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800874:	e9 c5 00 00 00       	jmp    80093e <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  800879:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80087c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800883:	8b 45 08             	mov    0x8(%ebp),%eax
  800886:	01 d0                	add    %edx,%eax
  800888:	8b 00                	mov    (%eax),%eax
  80088a:	85 c0                	test   %eax,%eax
  80088c:	75 08                	jne    800896 <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  80088e:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  800891:	e9 a5 00 00 00       	jmp    80093b <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  800896:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80089d:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  8008a4:	eb 69                	jmp    80090f <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  8008a6:	a1 24 40 80 00       	mov    0x804024,%eax
  8008ab:	8b 88 38 da 01 00    	mov    0x1da38(%eax),%ecx
  8008b1:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8008b4:	89 d0                	mov    %edx,%eax
  8008b6:	01 c0                	add    %eax,%eax
  8008b8:	01 d0                	add    %edx,%eax
  8008ba:	c1 e0 03             	shl    $0x3,%eax
  8008bd:	01 c8                	add    %ecx,%eax
  8008bf:	8a 40 04             	mov    0x4(%eax),%al
  8008c2:	84 c0                	test   %al,%al
  8008c4:	75 46                	jne    80090c <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8008c6:	a1 24 40 80 00       	mov    0x804024,%eax
  8008cb:	8b 88 38 da 01 00    	mov    0x1da38(%eax),%ecx
  8008d1:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8008d4:	89 d0                	mov    %edx,%eax
  8008d6:	01 c0                	add    %eax,%eax
  8008d8:	01 d0                	add    %edx,%eax
  8008da:	c1 e0 03             	shl    $0x3,%eax
  8008dd:	01 c8                	add    %ecx,%eax
  8008df:	8b 00                	mov    (%eax),%eax
  8008e1:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8008e4:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8008e7:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8008ec:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  8008ee:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8008f1:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8008f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8008fb:	01 c8                	add    %ecx,%eax
  8008fd:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8008ff:	39 c2                	cmp    %eax,%edx
  800901:	75 09                	jne    80090c <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  800903:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  80090a:	eb 15                	jmp    800921 <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80090c:	ff 45 e8             	incl   -0x18(%ebp)
  80090f:	a1 24 40 80 00       	mov    0x804024,%eax
  800914:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  80091a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80091d:	39 c2                	cmp    %eax,%edx
  80091f:	77 85                	ja     8008a6 <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  800921:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800925:	75 14                	jne    80093b <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  800927:	83 ec 04             	sub    $0x4,%esp
  80092a:	68 c8 33 80 00       	push   $0x8033c8
  80092f:	6a 3a                	push   $0x3a
  800931:	68 bc 33 80 00       	push   $0x8033bc
  800936:	e8 88 fe ff ff       	call   8007c3 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  80093b:	ff 45 f0             	incl   -0x10(%ebp)
  80093e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800941:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800944:	0f 8c 2f ff ff ff    	jl     800879 <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  80094a:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800951:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800958:	eb 26                	jmp    800980 <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  80095a:	a1 24 40 80 00       	mov    0x804024,%eax
  80095f:	8b 88 38 da 01 00    	mov    0x1da38(%eax),%ecx
  800965:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800968:	89 d0                	mov    %edx,%eax
  80096a:	01 c0                	add    %eax,%eax
  80096c:	01 d0                	add    %edx,%eax
  80096e:	c1 e0 03             	shl    $0x3,%eax
  800971:	01 c8                	add    %ecx,%eax
  800973:	8a 40 04             	mov    0x4(%eax),%al
  800976:	3c 01                	cmp    $0x1,%al
  800978:	75 03                	jne    80097d <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  80097a:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80097d:	ff 45 e0             	incl   -0x20(%ebp)
  800980:	a1 24 40 80 00       	mov    0x804024,%eax
  800985:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  80098b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80098e:	39 c2                	cmp    %eax,%edx
  800990:	77 c8                	ja     80095a <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  800992:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800995:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800998:	74 14                	je     8009ae <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  80099a:	83 ec 04             	sub    $0x4,%esp
  80099d:	68 1c 34 80 00       	push   $0x80341c
  8009a2:	6a 44                	push   $0x44
  8009a4:	68 bc 33 80 00       	push   $0x8033bc
  8009a9:	e8 15 fe ff ff       	call   8007c3 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  8009ae:	90                   	nop
  8009af:	c9                   	leave  
  8009b0:	c3                   	ret    

008009b1 <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  8009b1:	55                   	push   %ebp
  8009b2:	89 e5                	mov    %esp,%ebp
  8009b4:	53                   	push   %ebx
  8009b5:	83 ec 04             	sub    $0x4,%esp
	b->buf[b->idx++] = ch;
  8009b8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009bb:	8b 00                	mov    (%eax),%eax
  8009bd:	8d 48 01             	lea    0x1(%eax),%ecx
  8009c0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8009c3:	89 0a                	mov    %ecx,(%edx)
  8009c5:	8b 55 08             	mov    0x8(%ebp),%edx
  8009c8:	88 d1                	mov    %dl,%cl
  8009ca:	8b 55 0c             	mov    0xc(%ebp),%edx
  8009cd:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  8009d1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009d4:	8b 00                	mov    (%eax),%eax
  8009d6:	3d ff 00 00 00       	cmp    $0xff,%eax
  8009db:	75 30                	jne    800a0d <putch+0x5c>
		sys_cputs(b->buf, b->idx, printProgName, curTextClr);
  8009dd:	8b 15 1c c1 81 00    	mov    0x81c11c,%edx
  8009e3:	a0 44 40 80 00       	mov    0x804044,%al
  8009e8:	0f b6 c0             	movzbl %al,%eax
  8009eb:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8009ee:	8b 09                	mov    (%ecx),%ecx
  8009f0:	89 cb                	mov    %ecx,%ebx
  8009f2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8009f5:	83 c1 08             	add    $0x8,%ecx
  8009f8:	52                   	push   %edx
  8009f9:	50                   	push   %eax
  8009fa:	53                   	push   %ebx
  8009fb:	51                   	push   %ecx
  8009fc:	e8 5f 13 00 00       	call   801d60 <sys_cputs>
  800a01:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800a04:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a07:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800a0d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a10:	8b 40 04             	mov    0x4(%eax),%eax
  800a13:	8d 50 01             	lea    0x1(%eax),%edx
  800a16:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a19:	89 50 04             	mov    %edx,0x4(%eax)
}
  800a1c:	90                   	nop
  800a1d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800a20:	c9                   	leave  
  800a21:	c3                   	ret    

00800a22 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800a22:	55                   	push   %ebp
  800a23:	89 e5                	mov    %esp,%ebp
  800a25:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800a2b:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800a32:	00 00 00 
	b.cnt = 0;
  800a35:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800a3c:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800a3f:	ff 75 0c             	pushl  0xc(%ebp)
  800a42:	ff 75 08             	pushl  0x8(%ebp)
  800a45:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800a4b:	50                   	push   %eax
  800a4c:	68 b1 09 80 00       	push   $0x8009b1
  800a51:	e8 5a 02 00 00       	call   800cb0 <vprintfmt>
  800a56:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName, curTextClr);
  800a59:	8b 15 1c c1 81 00    	mov    0x81c11c,%edx
  800a5f:	a0 44 40 80 00       	mov    0x804044,%al
  800a64:	0f b6 c0             	movzbl %al,%eax
  800a67:	8b 8d f0 fe ff ff    	mov    -0x110(%ebp),%ecx
  800a6d:	52                   	push   %edx
  800a6e:	50                   	push   %eax
  800a6f:	51                   	push   %ecx
  800a70:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800a76:	83 c0 08             	add    $0x8,%eax
  800a79:	50                   	push   %eax
  800a7a:	e8 e1 12 00 00       	call   801d60 <sys_cputs>
  800a7f:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800a82:	c6 05 44 40 80 00 00 	movb   $0x0,0x804044
	return b.cnt;
  800a89:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800a8f:	c9                   	leave  
  800a90:	c3                   	ret    

00800a91 <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  800a91:	55                   	push   %ebp
  800a92:	89 e5                	mov    %esp,%ebp
  800a94:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800a97:	c6 05 44 40 80 00 01 	movb   $0x1,0x804044
	va_start(ap, fmt);
  800a9e:	8d 45 0c             	lea    0xc(%ebp),%eax
  800aa1:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800aa4:	8b 45 08             	mov    0x8(%ebp),%eax
  800aa7:	83 ec 08             	sub    $0x8,%esp
  800aaa:	ff 75 f4             	pushl  -0xc(%ebp)
  800aad:	50                   	push   %eax
  800aae:	e8 6f ff ff ff       	call   800a22 <vcprintf>
  800ab3:	83 c4 10             	add    $0x10,%esp
  800ab6:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800ab9:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800abc:	c9                   	leave  
  800abd:	c3                   	ret    

00800abe <cprintf_colored>:

// *************** This text coloring feature is implemented by *************
// ********** Abd-Alrahman Zedan From Team Frozen-Bytes - FCIS'24-25 ********
int cprintf_colored(int textClr, const char *fmt, ...) {
  800abe:	55                   	push   %ebp
  800abf:	89 e5                	mov    %esp,%ebp
  800ac1:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800ac4:	c6 05 44 40 80 00 01 	movb   $0x1,0x804044
	curTextClr = (textClr << 8) ; //set text color by the given value
  800acb:	8b 45 08             	mov    0x8(%ebp),%eax
  800ace:	c1 e0 08             	shl    $0x8,%eax
  800ad1:	a3 1c c1 81 00       	mov    %eax,0x81c11c
	va_start(ap, fmt);
  800ad6:	8d 45 0c             	lea    0xc(%ebp),%eax
  800ad9:	83 c0 04             	add    $0x4,%eax
  800adc:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800adf:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ae2:	83 ec 08             	sub    $0x8,%esp
  800ae5:	ff 75 f4             	pushl  -0xc(%ebp)
  800ae8:	50                   	push   %eax
  800ae9:	e8 34 ff ff ff       	call   800a22 <vcprintf>
  800aee:	83 c4 10             	add    $0x10,%esp
  800af1:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);
	curTextClr = TEXT_DEFAULT_CLR; //restore default color
  800af4:	c7 05 1c c1 81 00 00 	movl   $0x700,0x81c11c
  800afb:	07 00 00 

	return cnt;
  800afe:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800b01:	c9                   	leave  
  800b02:	c3                   	ret    

00800b03 <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  800b03:	55                   	push   %ebp
  800b04:	89 e5                	mov    %esp,%ebp
  800b06:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  800b09:	e8 96 12 00 00       	call   801da4 <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  800b0e:	8d 45 0c             	lea    0xc(%ebp),%eax
  800b11:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  800b14:	8b 45 08             	mov    0x8(%ebp),%eax
  800b17:	83 ec 08             	sub    $0x8,%esp
  800b1a:	ff 75 f4             	pushl  -0xc(%ebp)
  800b1d:	50                   	push   %eax
  800b1e:	e8 ff fe ff ff       	call   800a22 <vcprintf>
  800b23:	83 c4 10             	add    $0x10,%esp
  800b26:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  800b29:	e8 90 12 00 00       	call   801dbe <sys_unlock_cons>
	return cnt;
  800b2e:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800b31:	c9                   	leave  
  800b32:	c3                   	ret    

00800b33 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800b33:	55                   	push   %ebp
  800b34:	89 e5                	mov    %esp,%ebp
  800b36:	53                   	push   %ebx
  800b37:	83 ec 14             	sub    $0x14,%esp
  800b3a:	8b 45 10             	mov    0x10(%ebp),%eax
  800b3d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b40:	8b 45 14             	mov    0x14(%ebp),%eax
  800b43:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800b46:	8b 45 18             	mov    0x18(%ebp),%eax
  800b49:	ba 00 00 00 00       	mov    $0x0,%edx
  800b4e:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800b51:	77 55                	ja     800ba8 <printnum+0x75>
  800b53:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800b56:	72 05                	jb     800b5d <printnum+0x2a>
  800b58:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800b5b:	77 4b                	ja     800ba8 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800b5d:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800b60:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800b63:	8b 45 18             	mov    0x18(%ebp),%eax
  800b66:	ba 00 00 00 00       	mov    $0x0,%edx
  800b6b:	52                   	push   %edx
  800b6c:	50                   	push   %eax
  800b6d:	ff 75 f4             	pushl  -0xc(%ebp)
  800b70:	ff 75 f0             	pushl  -0x10(%ebp)
  800b73:	e8 10 22 00 00       	call   802d88 <__udivdi3>
  800b78:	83 c4 10             	add    $0x10,%esp
  800b7b:	83 ec 04             	sub    $0x4,%esp
  800b7e:	ff 75 20             	pushl  0x20(%ebp)
  800b81:	53                   	push   %ebx
  800b82:	ff 75 18             	pushl  0x18(%ebp)
  800b85:	52                   	push   %edx
  800b86:	50                   	push   %eax
  800b87:	ff 75 0c             	pushl  0xc(%ebp)
  800b8a:	ff 75 08             	pushl  0x8(%ebp)
  800b8d:	e8 a1 ff ff ff       	call   800b33 <printnum>
  800b92:	83 c4 20             	add    $0x20,%esp
  800b95:	eb 1a                	jmp    800bb1 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800b97:	83 ec 08             	sub    $0x8,%esp
  800b9a:	ff 75 0c             	pushl  0xc(%ebp)
  800b9d:	ff 75 20             	pushl  0x20(%ebp)
  800ba0:	8b 45 08             	mov    0x8(%ebp),%eax
  800ba3:	ff d0                	call   *%eax
  800ba5:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800ba8:	ff 4d 1c             	decl   0x1c(%ebp)
  800bab:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800baf:	7f e6                	jg     800b97 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800bb1:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800bb4:	bb 00 00 00 00       	mov    $0x0,%ebx
  800bb9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800bbc:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800bbf:	53                   	push   %ebx
  800bc0:	51                   	push   %ecx
  800bc1:	52                   	push   %edx
  800bc2:	50                   	push   %eax
  800bc3:	e8 d0 22 00 00       	call   802e98 <__umoddi3>
  800bc8:	83 c4 10             	add    $0x10,%esp
  800bcb:	05 94 36 80 00       	add    $0x803694,%eax
  800bd0:	8a 00                	mov    (%eax),%al
  800bd2:	0f be c0             	movsbl %al,%eax
  800bd5:	83 ec 08             	sub    $0x8,%esp
  800bd8:	ff 75 0c             	pushl  0xc(%ebp)
  800bdb:	50                   	push   %eax
  800bdc:	8b 45 08             	mov    0x8(%ebp),%eax
  800bdf:	ff d0                	call   *%eax
  800be1:	83 c4 10             	add    $0x10,%esp
}
  800be4:	90                   	nop
  800be5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800be8:	c9                   	leave  
  800be9:	c3                   	ret    

00800bea <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800bea:	55                   	push   %ebp
  800beb:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800bed:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800bf1:	7e 1c                	jle    800c0f <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800bf3:	8b 45 08             	mov    0x8(%ebp),%eax
  800bf6:	8b 00                	mov    (%eax),%eax
  800bf8:	8d 50 08             	lea    0x8(%eax),%edx
  800bfb:	8b 45 08             	mov    0x8(%ebp),%eax
  800bfe:	89 10                	mov    %edx,(%eax)
  800c00:	8b 45 08             	mov    0x8(%ebp),%eax
  800c03:	8b 00                	mov    (%eax),%eax
  800c05:	83 e8 08             	sub    $0x8,%eax
  800c08:	8b 50 04             	mov    0x4(%eax),%edx
  800c0b:	8b 00                	mov    (%eax),%eax
  800c0d:	eb 40                	jmp    800c4f <getuint+0x65>
	else if (lflag)
  800c0f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c13:	74 1e                	je     800c33 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800c15:	8b 45 08             	mov    0x8(%ebp),%eax
  800c18:	8b 00                	mov    (%eax),%eax
  800c1a:	8d 50 04             	lea    0x4(%eax),%edx
  800c1d:	8b 45 08             	mov    0x8(%ebp),%eax
  800c20:	89 10                	mov    %edx,(%eax)
  800c22:	8b 45 08             	mov    0x8(%ebp),%eax
  800c25:	8b 00                	mov    (%eax),%eax
  800c27:	83 e8 04             	sub    $0x4,%eax
  800c2a:	8b 00                	mov    (%eax),%eax
  800c2c:	ba 00 00 00 00       	mov    $0x0,%edx
  800c31:	eb 1c                	jmp    800c4f <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800c33:	8b 45 08             	mov    0x8(%ebp),%eax
  800c36:	8b 00                	mov    (%eax),%eax
  800c38:	8d 50 04             	lea    0x4(%eax),%edx
  800c3b:	8b 45 08             	mov    0x8(%ebp),%eax
  800c3e:	89 10                	mov    %edx,(%eax)
  800c40:	8b 45 08             	mov    0x8(%ebp),%eax
  800c43:	8b 00                	mov    (%eax),%eax
  800c45:	83 e8 04             	sub    $0x4,%eax
  800c48:	8b 00                	mov    (%eax),%eax
  800c4a:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800c4f:	5d                   	pop    %ebp
  800c50:	c3                   	ret    

00800c51 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800c51:	55                   	push   %ebp
  800c52:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800c54:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800c58:	7e 1c                	jle    800c76 <getint+0x25>
		return va_arg(*ap, long long);
  800c5a:	8b 45 08             	mov    0x8(%ebp),%eax
  800c5d:	8b 00                	mov    (%eax),%eax
  800c5f:	8d 50 08             	lea    0x8(%eax),%edx
  800c62:	8b 45 08             	mov    0x8(%ebp),%eax
  800c65:	89 10                	mov    %edx,(%eax)
  800c67:	8b 45 08             	mov    0x8(%ebp),%eax
  800c6a:	8b 00                	mov    (%eax),%eax
  800c6c:	83 e8 08             	sub    $0x8,%eax
  800c6f:	8b 50 04             	mov    0x4(%eax),%edx
  800c72:	8b 00                	mov    (%eax),%eax
  800c74:	eb 38                	jmp    800cae <getint+0x5d>
	else if (lflag)
  800c76:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c7a:	74 1a                	je     800c96 <getint+0x45>
		return va_arg(*ap, long);
  800c7c:	8b 45 08             	mov    0x8(%ebp),%eax
  800c7f:	8b 00                	mov    (%eax),%eax
  800c81:	8d 50 04             	lea    0x4(%eax),%edx
  800c84:	8b 45 08             	mov    0x8(%ebp),%eax
  800c87:	89 10                	mov    %edx,(%eax)
  800c89:	8b 45 08             	mov    0x8(%ebp),%eax
  800c8c:	8b 00                	mov    (%eax),%eax
  800c8e:	83 e8 04             	sub    $0x4,%eax
  800c91:	8b 00                	mov    (%eax),%eax
  800c93:	99                   	cltd   
  800c94:	eb 18                	jmp    800cae <getint+0x5d>
	else
		return va_arg(*ap, int);
  800c96:	8b 45 08             	mov    0x8(%ebp),%eax
  800c99:	8b 00                	mov    (%eax),%eax
  800c9b:	8d 50 04             	lea    0x4(%eax),%edx
  800c9e:	8b 45 08             	mov    0x8(%ebp),%eax
  800ca1:	89 10                	mov    %edx,(%eax)
  800ca3:	8b 45 08             	mov    0x8(%ebp),%eax
  800ca6:	8b 00                	mov    (%eax),%eax
  800ca8:	83 e8 04             	sub    $0x4,%eax
  800cab:	8b 00                	mov    (%eax),%eax
  800cad:	99                   	cltd   
}
  800cae:	5d                   	pop    %ebp
  800caf:	c3                   	ret    

00800cb0 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800cb0:	55                   	push   %ebp
  800cb1:	89 e5                	mov    %esp,%ebp
  800cb3:	56                   	push   %esi
  800cb4:	53                   	push   %ebx
  800cb5:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800cb8:	eb 17                	jmp    800cd1 <vprintfmt+0x21>
			if (ch == '\0')
  800cba:	85 db                	test   %ebx,%ebx
  800cbc:	0f 84 c1 03 00 00    	je     801083 <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  800cc2:	83 ec 08             	sub    $0x8,%esp
  800cc5:	ff 75 0c             	pushl  0xc(%ebp)
  800cc8:	53                   	push   %ebx
  800cc9:	8b 45 08             	mov    0x8(%ebp),%eax
  800ccc:	ff d0                	call   *%eax
  800cce:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800cd1:	8b 45 10             	mov    0x10(%ebp),%eax
  800cd4:	8d 50 01             	lea    0x1(%eax),%edx
  800cd7:	89 55 10             	mov    %edx,0x10(%ebp)
  800cda:	8a 00                	mov    (%eax),%al
  800cdc:	0f b6 d8             	movzbl %al,%ebx
  800cdf:	83 fb 25             	cmp    $0x25,%ebx
  800ce2:	75 d6                	jne    800cba <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800ce4:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800ce8:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800cef:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800cf6:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800cfd:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800d04:	8b 45 10             	mov    0x10(%ebp),%eax
  800d07:	8d 50 01             	lea    0x1(%eax),%edx
  800d0a:	89 55 10             	mov    %edx,0x10(%ebp)
  800d0d:	8a 00                	mov    (%eax),%al
  800d0f:	0f b6 d8             	movzbl %al,%ebx
  800d12:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800d15:	83 f8 5b             	cmp    $0x5b,%eax
  800d18:	0f 87 3d 03 00 00    	ja     80105b <vprintfmt+0x3ab>
  800d1e:	8b 04 85 b8 36 80 00 	mov    0x8036b8(,%eax,4),%eax
  800d25:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800d27:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800d2b:	eb d7                	jmp    800d04 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800d2d:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800d31:	eb d1                	jmp    800d04 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800d33:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800d3a:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800d3d:	89 d0                	mov    %edx,%eax
  800d3f:	c1 e0 02             	shl    $0x2,%eax
  800d42:	01 d0                	add    %edx,%eax
  800d44:	01 c0                	add    %eax,%eax
  800d46:	01 d8                	add    %ebx,%eax
  800d48:	83 e8 30             	sub    $0x30,%eax
  800d4b:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800d4e:	8b 45 10             	mov    0x10(%ebp),%eax
  800d51:	8a 00                	mov    (%eax),%al
  800d53:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800d56:	83 fb 2f             	cmp    $0x2f,%ebx
  800d59:	7e 3e                	jle    800d99 <vprintfmt+0xe9>
  800d5b:	83 fb 39             	cmp    $0x39,%ebx
  800d5e:	7f 39                	jg     800d99 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800d60:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800d63:	eb d5                	jmp    800d3a <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800d65:	8b 45 14             	mov    0x14(%ebp),%eax
  800d68:	83 c0 04             	add    $0x4,%eax
  800d6b:	89 45 14             	mov    %eax,0x14(%ebp)
  800d6e:	8b 45 14             	mov    0x14(%ebp),%eax
  800d71:	83 e8 04             	sub    $0x4,%eax
  800d74:	8b 00                	mov    (%eax),%eax
  800d76:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800d79:	eb 1f                	jmp    800d9a <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800d7b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800d7f:	79 83                	jns    800d04 <vprintfmt+0x54>
				width = 0;
  800d81:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800d88:	e9 77 ff ff ff       	jmp    800d04 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800d8d:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800d94:	e9 6b ff ff ff       	jmp    800d04 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800d99:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800d9a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800d9e:	0f 89 60 ff ff ff    	jns    800d04 <vprintfmt+0x54>
				width = precision, precision = -1;
  800da4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800da7:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800daa:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800db1:	e9 4e ff ff ff       	jmp    800d04 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800db6:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800db9:	e9 46 ff ff ff       	jmp    800d04 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800dbe:	8b 45 14             	mov    0x14(%ebp),%eax
  800dc1:	83 c0 04             	add    $0x4,%eax
  800dc4:	89 45 14             	mov    %eax,0x14(%ebp)
  800dc7:	8b 45 14             	mov    0x14(%ebp),%eax
  800dca:	83 e8 04             	sub    $0x4,%eax
  800dcd:	8b 00                	mov    (%eax),%eax
  800dcf:	83 ec 08             	sub    $0x8,%esp
  800dd2:	ff 75 0c             	pushl  0xc(%ebp)
  800dd5:	50                   	push   %eax
  800dd6:	8b 45 08             	mov    0x8(%ebp),%eax
  800dd9:	ff d0                	call   *%eax
  800ddb:	83 c4 10             	add    $0x10,%esp
			break;
  800dde:	e9 9b 02 00 00       	jmp    80107e <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800de3:	8b 45 14             	mov    0x14(%ebp),%eax
  800de6:	83 c0 04             	add    $0x4,%eax
  800de9:	89 45 14             	mov    %eax,0x14(%ebp)
  800dec:	8b 45 14             	mov    0x14(%ebp),%eax
  800def:	83 e8 04             	sub    $0x4,%eax
  800df2:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800df4:	85 db                	test   %ebx,%ebx
  800df6:	79 02                	jns    800dfa <vprintfmt+0x14a>
				err = -err;
  800df8:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800dfa:	83 fb 64             	cmp    $0x64,%ebx
  800dfd:	7f 0b                	jg     800e0a <vprintfmt+0x15a>
  800dff:	8b 34 9d 00 35 80 00 	mov    0x803500(,%ebx,4),%esi
  800e06:	85 f6                	test   %esi,%esi
  800e08:	75 19                	jne    800e23 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800e0a:	53                   	push   %ebx
  800e0b:	68 a5 36 80 00       	push   $0x8036a5
  800e10:	ff 75 0c             	pushl  0xc(%ebp)
  800e13:	ff 75 08             	pushl  0x8(%ebp)
  800e16:	e8 70 02 00 00       	call   80108b <printfmt>
  800e1b:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800e1e:	e9 5b 02 00 00       	jmp    80107e <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800e23:	56                   	push   %esi
  800e24:	68 ae 36 80 00       	push   $0x8036ae
  800e29:	ff 75 0c             	pushl  0xc(%ebp)
  800e2c:	ff 75 08             	pushl  0x8(%ebp)
  800e2f:	e8 57 02 00 00       	call   80108b <printfmt>
  800e34:	83 c4 10             	add    $0x10,%esp
			break;
  800e37:	e9 42 02 00 00       	jmp    80107e <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800e3c:	8b 45 14             	mov    0x14(%ebp),%eax
  800e3f:	83 c0 04             	add    $0x4,%eax
  800e42:	89 45 14             	mov    %eax,0x14(%ebp)
  800e45:	8b 45 14             	mov    0x14(%ebp),%eax
  800e48:	83 e8 04             	sub    $0x4,%eax
  800e4b:	8b 30                	mov    (%eax),%esi
  800e4d:	85 f6                	test   %esi,%esi
  800e4f:	75 05                	jne    800e56 <vprintfmt+0x1a6>
				p = "(null)";
  800e51:	be b1 36 80 00       	mov    $0x8036b1,%esi
			if (width > 0 && padc != '-')
  800e56:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800e5a:	7e 6d                	jle    800ec9 <vprintfmt+0x219>
  800e5c:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800e60:	74 67                	je     800ec9 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800e62:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800e65:	83 ec 08             	sub    $0x8,%esp
  800e68:	50                   	push   %eax
  800e69:	56                   	push   %esi
  800e6a:	e8 26 05 00 00       	call   801395 <strnlen>
  800e6f:	83 c4 10             	add    $0x10,%esp
  800e72:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800e75:	eb 16                	jmp    800e8d <vprintfmt+0x1dd>
					putch(padc, putdat);
  800e77:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800e7b:	83 ec 08             	sub    $0x8,%esp
  800e7e:	ff 75 0c             	pushl  0xc(%ebp)
  800e81:	50                   	push   %eax
  800e82:	8b 45 08             	mov    0x8(%ebp),%eax
  800e85:	ff d0                	call   *%eax
  800e87:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800e8a:	ff 4d e4             	decl   -0x1c(%ebp)
  800e8d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800e91:	7f e4                	jg     800e77 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800e93:	eb 34                	jmp    800ec9 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800e95:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800e99:	74 1c                	je     800eb7 <vprintfmt+0x207>
  800e9b:	83 fb 1f             	cmp    $0x1f,%ebx
  800e9e:	7e 05                	jle    800ea5 <vprintfmt+0x1f5>
  800ea0:	83 fb 7e             	cmp    $0x7e,%ebx
  800ea3:	7e 12                	jle    800eb7 <vprintfmt+0x207>
					putch('?', putdat);
  800ea5:	83 ec 08             	sub    $0x8,%esp
  800ea8:	ff 75 0c             	pushl  0xc(%ebp)
  800eab:	6a 3f                	push   $0x3f
  800ead:	8b 45 08             	mov    0x8(%ebp),%eax
  800eb0:	ff d0                	call   *%eax
  800eb2:	83 c4 10             	add    $0x10,%esp
  800eb5:	eb 0f                	jmp    800ec6 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800eb7:	83 ec 08             	sub    $0x8,%esp
  800eba:	ff 75 0c             	pushl  0xc(%ebp)
  800ebd:	53                   	push   %ebx
  800ebe:	8b 45 08             	mov    0x8(%ebp),%eax
  800ec1:	ff d0                	call   *%eax
  800ec3:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800ec6:	ff 4d e4             	decl   -0x1c(%ebp)
  800ec9:	89 f0                	mov    %esi,%eax
  800ecb:	8d 70 01             	lea    0x1(%eax),%esi
  800ece:	8a 00                	mov    (%eax),%al
  800ed0:	0f be d8             	movsbl %al,%ebx
  800ed3:	85 db                	test   %ebx,%ebx
  800ed5:	74 24                	je     800efb <vprintfmt+0x24b>
  800ed7:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800edb:	78 b8                	js     800e95 <vprintfmt+0x1e5>
  800edd:	ff 4d e0             	decl   -0x20(%ebp)
  800ee0:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800ee4:	79 af                	jns    800e95 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800ee6:	eb 13                	jmp    800efb <vprintfmt+0x24b>
				putch(' ', putdat);
  800ee8:	83 ec 08             	sub    $0x8,%esp
  800eeb:	ff 75 0c             	pushl  0xc(%ebp)
  800eee:	6a 20                	push   $0x20
  800ef0:	8b 45 08             	mov    0x8(%ebp),%eax
  800ef3:	ff d0                	call   *%eax
  800ef5:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800ef8:	ff 4d e4             	decl   -0x1c(%ebp)
  800efb:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800eff:	7f e7                	jg     800ee8 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800f01:	e9 78 01 00 00       	jmp    80107e <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800f06:	83 ec 08             	sub    $0x8,%esp
  800f09:	ff 75 e8             	pushl  -0x18(%ebp)
  800f0c:	8d 45 14             	lea    0x14(%ebp),%eax
  800f0f:	50                   	push   %eax
  800f10:	e8 3c fd ff ff       	call   800c51 <getint>
  800f15:	83 c4 10             	add    $0x10,%esp
  800f18:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800f1b:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800f1e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800f21:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800f24:	85 d2                	test   %edx,%edx
  800f26:	79 23                	jns    800f4b <vprintfmt+0x29b>
				putch('-', putdat);
  800f28:	83 ec 08             	sub    $0x8,%esp
  800f2b:	ff 75 0c             	pushl  0xc(%ebp)
  800f2e:	6a 2d                	push   $0x2d
  800f30:	8b 45 08             	mov    0x8(%ebp),%eax
  800f33:	ff d0                	call   *%eax
  800f35:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800f38:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800f3b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800f3e:	f7 d8                	neg    %eax
  800f40:	83 d2 00             	adc    $0x0,%edx
  800f43:	f7 da                	neg    %edx
  800f45:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800f48:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800f4b:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800f52:	e9 bc 00 00 00       	jmp    801013 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800f57:	83 ec 08             	sub    $0x8,%esp
  800f5a:	ff 75 e8             	pushl  -0x18(%ebp)
  800f5d:	8d 45 14             	lea    0x14(%ebp),%eax
  800f60:	50                   	push   %eax
  800f61:	e8 84 fc ff ff       	call   800bea <getuint>
  800f66:	83 c4 10             	add    $0x10,%esp
  800f69:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800f6c:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800f6f:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800f76:	e9 98 00 00 00       	jmp    801013 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800f7b:	83 ec 08             	sub    $0x8,%esp
  800f7e:	ff 75 0c             	pushl  0xc(%ebp)
  800f81:	6a 58                	push   $0x58
  800f83:	8b 45 08             	mov    0x8(%ebp),%eax
  800f86:	ff d0                	call   *%eax
  800f88:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800f8b:	83 ec 08             	sub    $0x8,%esp
  800f8e:	ff 75 0c             	pushl  0xc(%ebp)
  800f91:	6a 58                	push   $0x58
  800f93:	8b 45 08             	mov    0x8(%ebp),%eax
  800f96:	ff d0                	call   *%eax
  800f98:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800f9b:	83 ec 08             	sub    $0x8,%esp
  800f9e:	ff 75 0c             	pushl  0xc(%ebp)
  800fa1:	6a 58                	push   $0x58
  800fa3:	8b 45 08             	mov    0x8(%ebp),%eax
  800fa6:	ff d0                	call   *%eax
  800fa8:	83 c4 10             	add    $0x10,%esp
			break;
  800fab:	e9 ce 00 00 00       	jmp    80107e <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  800fb0:	83 ec 08             	sub    $0x8,%esp
  800fb3:	ff 75 0c             	pushl  0xc(%ebp)
  800fb6:	6a 30                	push   $0x30
  800fb8:	8b 45 08             	mov    0x8(%ebp),%eax
  800fbb:	ff d0                	call   *%eax
  800fbd:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800fc0:	83 ec 08             	sub    $0x8,%esp
  800fc3:	ff 75 0c             	pushl  0xc(%ebp)
  800fc6:	6a 78                	push   $0x78
  800fc8:	8b 45 08             	mov    0x8(%ebp),%eax
  800fcb:	ff d0                	call   *%eax
  800fcd:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800fd0:	8b 45 14             	mov    0x14(%ebp),%eax
  800fd3:	83 c0 04             	add    $0x4,%eax
  800fd6:	89 45 14             	mov    %eax,0x14(%ebp)
  800fd9:	8b 45 14             	mov    0x14(%ebp),%eax
  800fdc:	83 e8 04             	sub    $0x4,%eax
  800fdf:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800fe1:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800fe4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800feb:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800ff2:	eb 1f                	jmp    801013 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800ff4:	83 ec 08             	sub    $0x8,%esp
  800ff7:	ff 75 e8             	pushl  -0x18(%ebp)
  800ffa:	8d 45 14             	lea    0x14(%ebp),%eax
  800ffd:	50                   	push   %eax
  800ffe:	e8 e7 fb ff ff       	call   800bea <getuint>
  801003:	83 c4 10             	add    $0x10,%esp
  801006:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801009:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  80100c:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  801013:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  801017:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80101a:	83 ec 04             	sub    $0x4,%esp
  80101d:	52                   	push   %edx
  80101e:	ff 75 e4             	pushl  -0x1c(%ebp)
  801021:	50                   	push   %eax
  801022:	ff 75 f4             	pushl  -0xc(%ebp)
  801025:	ff 75 f0             	pushl  -0x10(%ebp)
  801028:	ff 75 0c             	pushl  0xc(%ebp)
  80102b:	ff 75 08             	pushl  0x8(%ebp)
  80102e:	e8 00 fb ff ff       	call   800b33 <printnum>
  801033:	83 c4 20             	add    $0x20,%esp
			break;
  801036:	eb 46                	jmp    80107e <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  801038:	83 ec 08             	sub    $0x8,%esp
  80103b:	ff 75 0c             	pushl  0xc(%ebp)
  80103e:	53                   	push   %ebx
  80103f:	8b 45 08             	mov    0x8(%ebp),%eax
  801042:	ff d0                	call   *%eax
  801044:	83 c4 10             	add    $0x10,%esp
			break;
  801047:	eb 35                	jmp    80107e <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  801049:	c6 05 44 40 80 00 00 	movb   $0x0,0x804044
			break;
  801050:	eb 2c                	jmp    80107e <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  801052:	c6 05 44 40 80 00 01 	movb   $0x1,0x804044
			break;
  801059:	eb 23                	jmp    80107e <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  80105b:	83 ec 08             	sub    $0x8,%esp
  80105e:	ff 75 0c             	pushl  0xc(%ebp)
  801061:	6a 25                	push   $0x25
  801063:	8b 45 08             	mov    0x8(%ebp),%eax
  801066:	ff d0                	call   *%eax
  801068:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  80106b:	ff 4d 10             	decl   0x10(%ebp)
  80106e:	eb 03                	jmp    801073 <vprintfmt+0x3c3>
  801070:	ff 4d 10             	decl   0x10(%ebp)
  801073:	8b 45 10             	mov    0x10(%ebp),%eax
  801076:	48                   	dec    %eax
  801077:	8a 00                	mov    (%eax),%al
  801079:	3c 25                	cmp    $0x25,%al
  80107b:	75 f3                	jne    801070 <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  80107d:	90                   	nop
		}
	}
  80107e:	e9 35 fc ff ff       	jmp    800cb8 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  801083:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  801084:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801087:	5b                   	pop    %ebx
  801088:	5e                   	pop    %esi
  801089:	5d                   	pop    %ebp
  80108a:	c3                   	ret    

0080108b <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  80108b:	55                   	push   %ebp
  80108c:	89 e5                	mov    %esp,%ebp
  80108e:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  801091:	8d 45 10             	lea    0x10(%ebp),%eax
  801094:	83 c0 04             	add    $0x4,%eax
  801097:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  80109a:	8b 45 10             	mov    0x10(%ebp),%eax
  80109d:	ff 75 f4             	pushl  -0xc(%ebp)
  8010a0:	50                   	push   %eax
  8010a1:	ff 75 0c             	pushl  0xc(%ebp)
  8010a4:	ff 75 08             	pushl  0x8(%ebp)
  8010a7:	e8 04 fc ff ff       	call   800cb0 <vprintfmt>
  8010ac:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  8010af:	90                   	nop
  8010b0:	c9                   	leave  
  8010b1:	c3                   	ret    

008010b2 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8010b2:	55                   	push   %ebp
  8010b3:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  8010b5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010b8:	8b 40 08             	mov    0x8(%eax),%eax
  8010bb:	8d 50 01             	lea    0x1(%eax),%edx
  8010be:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010c1:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  8010c4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010c7:	8b 10                	mov    (%eax),%edx
  8010c9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010cc:	8b 40 04             	mov    0x4(%eax),%eax
  8010cf:	39 c2                	cmp    %eax,%edx
  8010d1:	73 12                	jae    8010e5 <sprintputch+0x33>
		*b->buf++ = ch;
  8010d3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010d6:	8b 00                	mov    (%eax),%eax
  8010d8:	8d 48 01             	lea    0x1(%eax),%ecx
  8010db:	8b 55 0c             	mov    0xc(%ebp),%edx
  8010de:	89 0a                	mov    %ecx,(%edx)
  8010e0:	8b 55 08             	mov    0x8(%ebp),%edx
  8010e3:	88 10                	mov    %dl,(%eax)
}
  8010e5:	90                   	nop
  8010e6:	5d                   	pop    %ebp
  8010e7:	c3                   	ret    

008010e8 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8010e8:	55                   	push   %ebp
  8010e9:	89 e5                	mov    %esp,%ebp
  8010eb:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  8010ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8010f1:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8010f4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010f7:	8d 50 ff             	lea    -0x1(%eax),%edx
  8010fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8010fd:	01 d0                	add    %edx,%eax
  8010ff:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801102:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  801109:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80110d:	74 06                	je     801115 <vsnprintf+0x2d>
  80110f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801113:	7f 07                	jg     80111c <vsnprintf+0x34>
		return -E_INVAL;
  801115:	b8 03 00 00 00       	mov    $0x3,%eax
  80111a:	eb 20                	jmp    80113c <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  80111c:	ff 75 14             	pushl  0x14(%ebp)
  80111f:	ff 75 10             	pushl  0x10(%ebp)
  801122:	8d 45 ec             	lea    -0x14(%ebp),%eax
  801125:	50                   	push   %eax
  801126:	68 b2 10 80 00       	push   $0x8010b2
  80112b:	e8 80 fb ff ff       	call   800cb0 <vprintfmt>
  801130:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  801133:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801136:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  801139:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  80113c:	c9                   	leave  
  80113d:	c3                   	ret    

0080113e <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  80113e:	55                   	push   %ebp
  80113f:	89 e5                	mov    %esp,%ebp
  801141:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  801144:	8d 45 10             	lea    0x10(%ebp),%eax
  801147:	83 c0 04             	add    $0x4,%eax
  80114a:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  80114d:	8b 45 10             	mov    0x10(%ebp),%eax
  801150:	ff 75 f4             	pushl  -0xc(%ebp)
  801153:	50                   	push   %eax
  801154:	ff 75 0c             	pushl  0xc(%ebp)
  801157:	ff 75 08             	pushl  0x8(%ebp)
  80115a:	e8 89 ff ff ff       	call   8010e8 <vsnprintf>
  80115f:	83 c4 10             	add    $0x10,%esp
  801162:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  801165:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801168:	c9                   	leave  
  801169:	c3                   	ret    

0080116a <readline>:
#include <inc/lib.h>

//static char buf[BUFLEN];

void readline(const char *prompt, char* buf)
{
  80116a:	55                   	push   %ebp
  80116b:	89 e5                	mov    %esp,%ebp
  80116d:	83 ec 18             	sub    $0x18,%esp
	int i, c, echoing;

	if (prompt != NULL)
  801170:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801174:	74 13                	je     801189 <readline+0x1f>
		cprintf("%s", prompt);
  801176:	83 ec 08             	sub    $0x8,%esp
  801179:	ff 75 08             	pushl  0x8(%ebp)
  80117c:	68 28 38 80 00       	push   $0x803828
  801181:	e8 0b f9 ff ff       	call   800a91 <cprintf>
  801186:	83 c4 10             	add    $0x10,%esp

	i = 0;
  801189:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	echoing = iscons(0);
  801190:	83 ec 0c             	sub    $0xc,%esp
  801193:	6a 00                	push   $0x0
  801195:	e8 5a f4 ff ff       	call   8005f4 <iscons>
  80119a:	83 c4 10             	add    $0x10,%esp
  80119d:	89 45 f0             	mov    %eax,-0x10(%ebp)
	while (1) {
		c = getchar();
  8011a0:	e8 3c f4 ff ff       	call   8005e1 <getchar>
  8011a5:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if (c < 0) {
  8011a8:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8011ac:	79 22                	jns    8011d0 <readline+0x66>
			if (c != -E_EOF)
  8011ae:	83 7d ec 07          	cmpl   $0x7,-0x14(%ebp)
  8011b2:	0f 84 ad 00 00 00    	je     801265 <readline+0xfb>
				cprintf("read error: %e\n", c);
  8011b8:	83 ec 08             	sub    $0x8,%esp
  8011bb:	ff 75 ec             	pushl  -0x14(%ebp)
  8011be:	68 2b 38 80 00       	push   $0x80382b
  8011c3:	e8 c9 f8 ff ff       	call   800a91 <cprintf>
  8011c8:	83 c4 10             	add    $0x10,%esp
			break;
  8011cb:	e9 95 00 00 00       	jmp    801265 <readline+0xfb>
		} else if (c >= ' ' && i < BUFLEN-1) {
  8011d0:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%ebp)
  8011d4:	7e 34                	jle    80120a <readline+0xa0>
  8011d6:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  8011dd:	7f 2b                	jg     80120a <readline+0xa0>
			if (echoing)
  8011df:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8011e3:	74 0e                	je     8011f3 <readline+0x89>
				cputchar(c);
  8011e5:	83 ec 0c             	sub    $0xc,%esp
  8011e8:	ff 75 ec             	pushl  -0x14(%ebp)
  8011eb:	e8 d2 f3 ff ff       	call   8005c2 <cputchar>
  8011f0:	83 c4 10             	add    $0x10,%esp
			buf[i++] = c;
  8011f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8011f6:	8d 50 01             	lea    0x1(%eax),%edx
  8011f9:	89 55 f4             	mov    %edx,-0xc(%ebp)
  8011fc:	89 c2                	mov    %eax,%edx
  8011fe:	8b 45 0c             	mov    0xc(%ebp),%eax
  801201:	01 d0                	add    %edx,%eax
  801203:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801206:	88 10                	mov    %dl,(%eax)
  801208:	eb 56                	jmp    801260 <readline+0xf6>
		} else if (c == '\b' && i > 0) {
  80120a:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  80120e:	75 1f                	jne    80122f <readline+0xc5>
  801210:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801214:	7e 19                	jle    80122f <readline+0xc5>
			if (echoing)
  801216:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80121a:	74 0e                	je     80122a <readline+0xc0>
				cputchar(c);
  80121c:	83 ec 0c             	sub    $0xc,%esp
  80121f:	ff 75 ec             	pushl  -0x14(%ebp)
  801222:	e8 9b f3 ff ff       	call   8005c2 <cputchar>
  801227:	83 c4 10             	add    $0x10,%esp

			i--;
  80122a:	ff 4d f4             	decl   -0xc(%ebp)
  80122d:	eb 31                	jmp    801260 <readline+0xf6>
		} else if (c == '\n' || c == '\r') {
  80122f:	83 7d ec 0a          	cmpl   $0xa,-0x14(%ebp)
  801233:	74 0a                	je     80123f <readline+0xd5>
  801235:	83 7d ec 0d          	cmpl   $0xd,-0x14(%ebp)
  801239:	0f 85 61 ff ff ff    	jne    8011a0 <readline+0x36>
			if (echoing)
  80123f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801243:	74 0e                	je     801253 <readline+0xe9>
				cputchar(c);
  801245:	83 ec 0c             	sub    $0xc,%esp
  801248:	ff 75 ec             	pushl  -0x14(%ebp)
  80124b:	e8 72 f3 ff ff       	call   8005c2 <cputchar>
  801250:	83 c4 10             	add    $0x10,%esp

			buf[i] = 0;
  801253:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801256:	8b 45 0c             	mov    0xc(%ebp),%eax
  801259:	01 d0                	add    %edx,%eax
  80125b:	c6 00 00             	movb   $0x0,(%eax)
			break;
  80125e:	eb 06                	jmp    801266 <readline+0xfc>
		}
	}
  801260:	e9 3b ff ff ff       	jmp    8011a0 <readline+0x36>
	while (1) {
		c = getchar();
		if (c < 0) {
			if (c != -E_EOF)
				cprintf("read error: %e\n", c);
			break;
  801265:	90                   	nop

			buf[i] = 0;
			break;
		}
	}
}
  801266:	90                   	nop
  801267:	c9                   	leave  
  801268:	c3                   	ret    

00801269 <atomic_readline>:

void atomic_readline(const char *prompt, char* buf)
{
  801269:	55                   	push   %ebp
  80126a:	89 e5                	mov    %esp,%ebp
  80126c:	83 ec 18             	sub    $0x18,%esp
	sys_lock_cons();
  80126f:	e8 30 0b 00 00       	call   801da4 <sys_lock_cons>
	{
		int i, c, echoing;

		if (prompt != NULL)
  801274:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801278:	74 13                	je     80128d <atomic_readline+0x24>
			cprintf("%s", prompt);
  80127a:	83 ec 08             	sub    $0x8,%esp
  80127d:	ff 75 08             	pushl  0x8(%ebp)
  801280:	68 28 38 80 00       	push   $0x803828
  801285:	e8 07 f8 ff ff       	call   800a91 <cprintf>
  80128a:	83 c4 10             	add    $0x10,%esp

		i = 0;
  80128d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
		echoing = iscons(0);
  801294:	83 ec 0c             	sub    $0xc,%esp
  801297:	6a 00                	push   $0x0
  801299:	e8 56 f3 ff ff       	call   8005f4 <iscons>
  80129e:	83 c4 10             	add    $0x10,%esp
  8012a1:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (1) {
			c = getchar();
  8012a4:	e8 38 f3 ff ff       	call   8005e1 <getchar>
  8012a9:	89 45 ec             	mov    %eax,-0x14(%ebp)
			if (c < 0) {
  8012ac:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8012b0:	79 22                	jns    8012d4 <atomic_readline+0x6b>
				if (c != -E_EOF)
  8012b2:	83 7d ec 07          	cmpl   $0x7,-0x14(%ebp)
  8012b6:	0f 84 ad 00 00 00    	je     801369 <atomic_readline+0x100>
					cprintf("read error: %e\n", c);
  8012bc:	83 ec 08             	sub    $0x8,%esp
  8012bf:	ff 75 ec             	pushl  -0x14(%ebp)
  8012c2:	68 2b 38 80 00       	push   $0x80382b
  8012c7:	e8 c5 f7 ff ff       	call   800a91 <cprintf>
  8012cc:	83 c4 10             	add    $0x10,%esp
				break;
  8012cf:	e9 95 00 00 00       	jmp    801369 <atomic_readline+0x100>
			} else if (c >= ' ' && i < BUFLEN-1) {
  8012d4:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%ebp)
  8012d8:	7e 34                	jle    80130e <atomic_readline+0xa5>
  8012da:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  8012e1:	7f 2b                	jg     80130e <atomic_readline+0xa5>
				if (echoing)
  8012e3:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8012e7:	74 0e                	je     8012f7 <atomic_readline+0x8e>
					cputchar(c);
  8012e9:	83 ec 0c             	sub    $0xc,%esp
  8012ec:	ff 75 ec             	pushl  -0x14(%ebp)
  8012ef:	e8 ce f2 ff ff       	call   8005c2 <cputchar>
  8012f4:	83 c4 10             	add    $0x10,%esp
				buf[i++] = c;
  8012f7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8012fa:	8d 50 01             	lea    0x1(%eax),%edx
  8012fd:	89 55 f4             	mov    %edx,-0xc(%ebp)
  801300:	89 c2                	mov    %eax,%edx
  801302:	8b 45 0c             	mov    0xc(%ebp),%eax
  801305:	01 d0                	add    %edx,%eax
  801307:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80130a:	88 10                	mov    %dl,(%eax)
  80130c:	eb 56                	jmp    801364 <atomic_readline+0xfb>
			} else if (c == '\b' && i > 0) {
  80130e:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  801312:	75 1f                	jne    801333 <atomic_readline+0xca>
  801314:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801318:	7e 19                	jle    801333 <atomic_readline+0xca>
				if (echoing)
  80131a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80131e:	74 0e                	je     80132e <atomic_readline+0xc5>
					cputchar(c);
  801320:	83 ec 0c             	sub    $0xc,%esp
  801323:	ff 75 ec             	pushl  -0x14(%ebp)
  801326:	e8 97 f2 ff ff       	call   8005c2 <cputchar>
  80132b:	83 c4 10             	add    $0x10,%esp
				i--;
  80132e:	ff 4d f4             	decl   -0xc(%ebp)
  801331:	eb 31                	jmp    801364 <atomic_readline+0xfb>
			} else if (c == '\n' || c == '\r') {
  801333:	83 7d ec 0a          	cmpl   $0xa,-0x14(%ebp)
  801337:	74 0a                	je     801343 <atomic_readline+0xda>
  801339:	83 7d ec 0d          	cmpl   $0xd,-0x14(%ebp)
  80133d:	0f 85 61 ff ff ff    	jne    8012a4 <atomic_readline+0x3b>
				if (echoing)
  801343:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801347:	74 0e                	je     801357 <atomic_readline+0xee>
					cputchar(c);
  801349:	83 ec 0c             	sub    $0xc,%esp
  80134c:	ff 75 ec             	pushl  -0x14(%ebp)
  80134f:	e8 6e f2 ff ff       	call   8005c2 <cputchar>
  801354:	83 c4 10             	add    $0x10,%esp
				buf[i] = 0;
  801357:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80135a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80135d:	01 d0                	add    %edx,%eax
  80135f:	c6 00 00             	movb   $0x0,(%eax)
				break;
  801362:	eb 06                	jmp    80136a <atomic_readline+0x101>
			}
		}
  801364:	e9 3b ff ff ff       	jmp    8012a4 <atomic_readline+0x3b>
		while (1) {
			c = getchar();
			if (c < 0) {
				if (c != -E_EOF)
					cprintf("read error: %e\n", c);
				break;
  801369:	90                   	nop
				buf[i] = 0;
				break;
			}
		}
	}
	sys_unlock_cons();
  80136a:	e8 4f 0a 00 00       	call   801dbe <sys_unlock_cons>
}
  80136f:	90                   	nop
  801370:	c9                   	leave  
  801371:	c3                   	ret    

00801372 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  801372:	55                   	push   %ebp
  801373:	89 e5                	mov    %esp,%ebp
  801375:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  801378:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80137f:	eb 06                	jmp    801387 <strlen+0x15>
		n++;
  801381:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  801384:	ff 45 08             	incl   0x8(%ebp)
  801387:	8b 45 08             	mov    0x8(%ebp),%eax
  80138a:	8a 00                	mov    (%eax),%al
  80138c:	84 c0                	test   %al,%al
  80138e:	75 f1                	jne    801381 <strlen+0xf>
		n++;
	return n;
  801390:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801393:	c9                   	leave  
  801394:	c3                   	ret    

00801395 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  801395:	55                   	push   %ebp
  801396:	89 e5                	mov    %esp,%ebp
  801398:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80139b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8013a2:	eb 09                	jmp    8013ad <strnlen+0x18>
		n++;
  8013a4:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8013a7:	ff 45 08             	incl   0x8(%ebp)
  8013aa:	ff 4d 0c             	decl   0xc(%ebp)
  8013ad:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8013b1:	74 09                	je     8013bc <strnlen+0x27>
  8013b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8013b6:	8a 00                	mov    (%eax),%al
  8013b8:	84 c0                	test   %al,%al
  8013ba:	75 e8                	jne    8013a4 <strnlen+0xf>
		n++;
	return n;
  8013bc:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8013bf:	c9                   	leave  
  8013c0:	c3                   	ret    

008013c1 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8013c1:	55                   	push   %ebp
  8013c2:	89 e5                	mov    %esp,%ebp
  8013c4:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  8013c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8013ca:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  8013cd:	90                   	nop
  8013ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8013d1:	8d 50 01             	lea    0x1(%eax),%edx
  8013d4:	89 55 08             	mov    %edx,0x8(%ebp)
  8013d7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8013da:	8d 4a 01             	lea    0x1(%edx),%ecx
  8013dd:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  8013e0:	8a 12                	mov    (%edx),%dl
  8013e2:	88 10                	mov    %dl,(%eax)
  8013e4:	8a 00                	mov    (%eax),%al
  8013e6:	84 c0                	test   %al,%al
  8013e8:	75 e4                	jne    8013ce <strcpy+0xd>
		/* do nothing */;
	return ret;
  8013ea:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8013ed:	c9                   	leave  
  8013ee:	c3                   	ret    

008013ef <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  8013ef:	55                   	push   %ebp
  8013f0:	89 e5                	mov    %esp,%ebp
  8013f2:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  8013f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8013f8:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  8013fb:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801402:	eb 1f                	jmp    801423 <strncpy+0x34>
		*dst++ = *src;
  801404:	8b 45 08             	mov    0x8(%ebp),%eax
  801407:	8d 50 01             	lea    0x1(%eax),%edx
  80140a:	89 55 08             	mov    %edx,0x8(%ebp)
  80140d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801410:	8a 12                	mov    (%edx),%dl
  801412:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  801414:	8b 45 0c             	mov    0xc(%ebp),%eax
  801417:	8a 00                	mov    (%eax),%al
  801419:	84 c0                	test   %al,%al
  80141b:	74 03                	je     801420 <strncpy+0x31>
			src++;
  80141d:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  801420:	ff 45 fc             	incl   -0x4(%ebp)
  801423:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801426:	3b 45 10             	cmp    0x10(%ebp),%eax
  801429:	72 d9                	jb     801404 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  80142b:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  80142e:	c9                   	leave  
  80142f:	c3                   	ret    

00801430 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  801430:	55                   	push   %ebp
  801431:	89 e5                	mov    %esp,%ebp
  801433:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  801436:	8b 45 08             	mov    0x8(%ebp),%eax
  801439:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  80143c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801440:	74 30                	je     801472 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  801442:	eb 16                	jmp    80145a <strlcpy+0x2a>
			*dst++ = *src++;
  801444:	8b 45 08             	mov    0x8(%ebp),%eax
  801447:	8d 50 01             	lea    0x1(%eax),%edx
  80144a:	89 55 08             	mov    %edx,0x8(%ebp)
  80144d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801450:	8d 4a 01             	lea    0x1(%edx),%ecx
  801453:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  801456:	8a 12                	mov    (%edx),%dl
  801458:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  80145a:	ff 4d 10             	decl   0x10(%ebp)
  80145d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801461:	74 09                	je     80146c <strlcpy+0x3c>
  801463:	8b 45 0c             	mov    0xc(%ebp),%eax
  801466:	8a 00                	mov    (%eax),%al
  801468:	84 c0                	test   %al,%al
  80146a:	75 d8                	jne    801444 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  80146c:	8b 45 08             	mov    0x8(%ebp),%eax
  80146f:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  801472:	8b 55 08             	mov    0x8(%ebp),%edx
  801475:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801478:	29 c2                	sub    %eax,%edx
  80147a:	89 d0                	mov    %edx,%eax
}
  80147c:	c9                   	leave  
  80147d:	c3                   	ret    

0080147e <strcmp>:

int
strcmp(const char *p, const char *q)
{
  80147e:	55                   	push   %ebp
  80147f:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  801481:	eb 06                	jmp    801489 <strcmp+0xb>
		p++, q++;
  801483:	ff 45 08             	incl   0x8(%ebp)
  801486:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  801489:	8b 45 08             	mov    0x8(%ebp),%eax
  80148c:	8a 00                	mov    (%eax),%al
  80148e:	84 c0                	test   %al,%al
  801490:	74 0e                	je     8014a0 <strcmp+0x22>
  801492:	8b 45 08             	mov    0x8(%ebp),%eax
  801495:	8a 10                	mov    (%eax),%dl
  801497:	8b 45 0c             	mov    0xc(%ebp),%eax
  80149a:	8a 00                	mov    (%eax),%al
  80149c:	38 c2                	cmp    %al,%dl
  80149e:	74 e3                	je     801483 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8014a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8014a3:	8a 00                	mov    (%eax),%al
  8014a5:	0f b6 d0             	movzbl %al,%edx
  8014a8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014ab:	8a 00                	mov    (%eax),%al
  8014ad:	0f b6 c0             	movzbl %al,%eax
  8014b0:	29 c2                	sub    %eax,%edx
  8014b2:	89 d0                	mov    %edx,%eax
}
  8014b4:	5d                   	pop    %ebp
  8014b5:	c3                   	ret    

008014b6 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  8014b6:	55                   	push   %ebp
  8014b7:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  8014b9:	eb 09                	jmp    8014c4 <strncmp+0xe>
		n--, p++, q++;
  8014bb:	ff 4d 10             	decl   0x10(%ebp)
  8014be:	ff 45 08             	incl   0x8(%ebp)
  8014c1:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  8014c4:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8014c8:	74 17                	je     8014e1 <strncmp+0x2b>
  8014ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8014cd:	8a 00                	mov    (%eax),%al
  8014cf:	84 c0                	test   %al,%al
  8014d1:	74 0e                	je     8014e1 <strncmp+0x2b>
  8014d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8014d6:	8a 10                	mov    (%eax),%dl
  8014d8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014db:	8a 00                	mov    (%eax),%al
  8014dd:	38 c2                	cmp    %al,%dl
  8014df:	74 da                	je     8014bb <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  8014e1:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8014e5:	75 07                	jne    8014ee <strncmp+0x38>
		return 0;
  8014e7:	b8 00 00 00 00       	mov    $0x0,%eax
  8014ec:	eb 14                	jmp    801502 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8014ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8014f1:	8a 00                	mov    (%eax),%al
  8014f3:	0f b6 d0             	movzbl %al,%edx
  8014f6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014f9:	8a 00                	mov    (%eax),%al
  8014fb:	0f b6 c0             	movzbl %al,%eax
  8014fe:	29 c2                	sub    %eax,%edx
  801500:	89 d0                	mov    %edx,%eax
}
  801502:	5d                   	pop    %ebp
  801503:	c3                   	ret    

00801504 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  801504:	55                   	push   %ebp
  801505:	89 e5                	mov    %esp,%ebp
  801507:	83 ec 04             	sub    $0x4,%esp
  80150a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80150d:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  801510:	eb 12                	jmp    801524 <strchr+0x20>
		if (*s == c)
  801512:	8b 45 08             	mov    0x8(%ebp),%eax
  801515:	8a 00                	mov    (%eax),%al
  801517:	3a 45 fc             	cmp    -0x4(%ebp),%al
  80151a:	75 05                	jne    801521 <strchr+0x1d>
			return (char *) s;
  80151c:	8b 45 08             	mov    0x8(%ebp),%eax
  80151f:	eb 11                	jmp    801532 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  801521:	ff 45 08             	incl   0x8(%ebp)
  801524:	8b 45 08             	mov    0x8(%ebp),%eax
  801527:	8a 00                	mov    (%eax),%al
  801529:	84 c0                	test   %al,%al
  80152b:	75 e5                	jne    801512 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  80152d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801532:	c9                   	leave  
  801533:	c3                   	ret    

00801534 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  801534:	55                   	push   %ebp
  801535:	89 e5                	mov    %esp,%ebp
  801537:	83 ec 04             	sub    $0x4,%esp
  80153a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80153d:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  801540:	eb 0d                	jmp    80154f <strfind+0x1b>
		if (*s == c)
  801542:	8b 45 08             	mov    0x8(%ebp),%eax
  801545:	8a 00                	mov    (%eax),%al
  801547:	3a 45 fc             	cmp    -0x4(%ebp),%al
  80154a:	74 0e                	je     80155a <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  80154c:	ff 45 08             	incl   0x8(%ebp)
  80154f:	8b 45 08             	mov    0x8(%ebp),%eax
  801552:	8a 00                	mov    (%eax),%al
  801554:	84 c0                	test   %al,%al
  801556:	75 ea                	jne    801542 <strfind+0xe>
  801558:	eb 01                	jmp    80155b <strfind+0x27>
		if (*s == c)
			break;
  80155a:	90                   	nop
	return (char *) s;
  80155b:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80155e:	c9                   	leave  
  80155f:	c3                   	ret    

00801560 <memset>:

// *************** The faster implementation of memset & memcpy is implemented by *************
// ****************** Team80 (Yahia Khaled, Malek Ahmed et al) - FCIS'24-25 *******************
void *
memset(void *v, int c, uint32 n)
{
  801560:	55                   	push   %ebp
  801561:	89 e5                	mov    %esp,%ebp
  801563:	83 ec 10             	sub    $0x10,%esp
//	m = n;
//	while (--m >= 0)
//		*p++ = c;

	/*Faster Implementation*/
	uint64* p64 = (uint64*)v;
  801566:	8b 45 08             	mov    0x8(%ebp),%eax
  801569:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if(n >= 8){
  80156c:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  801570:	76 63                	jbe    8015d5 <memset+0x75>
		uint64 data_block = c;
  801572:	8b 45 0c             	mov    0xc(%ebp),%eax
  801575:	99                   	cltd   
  801576:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801579:	89 55 f4             	mov    %edx,-0xc(%ebp)
		data_block |= data_block << 8;
  80157c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80157f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801582:	0f a4 c2 08          	shld   $0x8,%eax,%edx
  801586:	c1 e0 08             	shl    $0x8,%eax
  801589:	09 45 f0             	or     %eax,-0x10(%ebp)
  80158c:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 16;
  80158f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801592:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801595:	0f a4 c2 10          	shld   $0x10,%eax,%edx
  801599:	c1 e0 10             	shl    $0x10,%eax
  80159c:	09 45 f0             	or     %eax,-0x10(%ebp)
  80159f:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 32;
  8015a2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015a5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8015a8:	89 c2                	mov    %eax,%edx
  8015aa:	b8 00 00 00 00       	mov    $0x0,%eax
  8015af:	09 45 f0             	or     %eax,-0x10(%ebp)
  8015b2:	09 55 f4             	or     %edx,-0xc(%ebp)

		while(n >= 8)
  8015b5:	eb 18                	jmp    8015cf <memset+0x6f>
			*p64++ = data_block, n -= 8;
  8015b7:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8015ba:	8d 41 08             	lea    0x8(%ecx),%eax
  8015bd:	89 45 fc             	mov    %eax,-0x4(%ebp)
  8015c0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015c3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8015c6:	89 01                	mov    %eax,(%ecx)
  8015c8:	89 51 04             	mov    %edx,0x4(%ecx)
  8015cb:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
		uint64 data_block = c;
		data_block |= data_block << 8;
		data_block |= data_block << 16;
		data_block |= data_block << 32;

		while(n >= 8)
  8015cf:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  8015d3:	77 e2                	ja     8015b7 <memset+0x57>
			*p64++ = data_block, n -= 8;
	}

	if(n){
  8015d5:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8015d9:	74 23                	je     8015fe <memset+0x9e>
		uint8* p8 = (uint8*)p64;
  8015db:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8015de:	89 45 f8             	mov    %eax,-0x8(%ebp)
		while (n-- > 0)
  8015e1:	eb 0e                	jmp    8015f1 <memset+0x91>
			*p8++ = (uint8)c;
  8015e3:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8015e6:	8d 50 01             	lea    0x1(%eax),%edx
  8015e9:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8015ec:	8b 55 0c             	mov    0xc(%ebp),%edx
  8015ef:	88 10                	mov    %dl,(%eax)
			*p64++ = data_block, n -= 8;
	}

	if(n){
		uint8* p8 = (uint8*)p64;
		while (n-- > 0)
  8015f1:	8b 45 10             	mov    0x10(%ebp),%eax
  8015f4:	8d 50 ff             	lea    -0x1(%eax),%edx
  8015f7:	89 55 10             	mov    %edx,0x10(%ebp)
  8015fa:	85 c0                	test   %eax,%eax
  8015fc:	75 e5                	jne    8015e3 <memset+0x83>
			*p8++ = (uint8)c;
	}

	return v;
  8015fe:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801601:	c9                   	leave  
  801602:	c3                   	ret    

00801603 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  801603:	55                   	push   %ebp
  801604:	89 e5                	mov    %esp,%ebp
  801606:	83 ec 10             	sub    $0x10,%esp
	//	s = src;
	//	d = dst;
	//	while (n-- > 0)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
  801609:	8b 45 0c             	mov    0xc(%ebp),%eax
  80160c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	uint64* d64 = (uint64*)dst;
  80160f:	8b 45 08             	mov    0x8(%ebp),%eax
  801612:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if(n >= 8){
  801615:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  801619:	76 24                	jbe    80163f <memcpy+0x3c>
		while(n >= 8){
  80161b:	eb 1c                	jmp    801639 <memcpy+0x36>
			*d64 = *s64;
  80161d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801620:	8b 50 04             	mov    0x4(%eax),%edx
  801623:	8b 00                	mov    (%eax),%eax
  801625:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801628:	89 01                	mov    %eax,(%ecx)
  80162a:	89 51 04             	mov    %edx,0x4(%ecx)
			n -= 8;
  80162d:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
			++s64;
  801631:	83 45 fc 08          	addl   $0x8,-0x4(%ebp)
			++d64;
  801635:	83 45 f8 08          	addl   $0x8,-0x8(%ebp)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
	uint64* d64 = (uint64*)dst;
	if(n >= 8){
		while(n >= 8){
  801639:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  80163d:	77 de                	ja     80161d <memcpy+0x1a>
			++s64;
			++d64;
		}
	}

	if(n){
  80163f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801643:	74 31                	je     801676 <memcpy+0x73>
		uint8* s8 = (uint8*)s64;
  801645:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801648:	89 45 f4             	mov    %eax,-0xc(%ebp)
		uint8* d8 = (uint8*)d64;
  80164b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80164e:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (n-- > 0)
  801651:	eb 16                	jmp    801669 <memcpy+0x66>
			*d8++ = *s8++;
  801653:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801656:	8d 50 01             	lea    0x1(%eax),%edx
  801659:	89 55 f0             	mov    %edx,-0x10(%ebp)
  80165c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80165f:	8d 4a 01             	lea    0x1(%edx),%ecx
  801662:	89 4d f4             	mov    %ecx,-0xc(%ebp)
  801665:	8a 12                	mov    (%edx),%dl
  801667:	88 10                	mov    %dl,(%eax)
	}

	if(n){
		uint8* s8 = (uint8*)s64;
		uint8* d8 = (uint8*)d64;
		while (n-- > 0)
  801669:	8b 45 10             	mov    0x10(%ebp),%eax
  80166c:	8d 50 ff             	lea    -0x1(%eax),%edx
  80166f:	89 55 10             	mov    %edx,0x10(%ebp)
  801672:	85 c0                	test   %eax,%eax
  801674:	75 dd                	jne    801653 <memcpy+0x50>
			*d8++ = *s8++;
	}
	return dst;
  801676:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801679:	c9                   	leave  
  80167a:	c3                   	ret    

0080167b <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  80167b:	55                   	push   %ebp
  80167c:	89 e5                	mov    %esp,%ebp
  80167e:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801681:	8b 45 0c             	mov    0xc(%ebp),%eax
  801684:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801687:	8b 45 08             	mov    0x8(%ebp),%eax
  80168a:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  80168d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801690:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801693:	73 50                	jae    8016e5 <memmove+0x6a>
  801695:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801698:	8b 45 10             	mov    0x10(%ebp),%eax
  80169b:	01 d0                	add    %edx,%eax
  80169d:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8016a0:	76 43                	jbe    8016e5 <memmove+0x6a>
		s += n;
  8016a2:	8b 45 10             	mov    0x10(%ebp),%eax
  8016a5:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  8016a8:	8b 45 10             	mov    0x10(%ebp),%eax
  8016ab:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  8016ae:	eb 10                	jmp    8016c0 <memmove+0x45>
			*--d = *--s;
  8016b0:	ff 4d f8             	decl   -0x8(%ebp)
  8016b3:	ff 4d fc             	decl   -0x4(%ebp)
  8016b6:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8016b9:	8a 10                	mov    (%eax),%dl
  8016bb:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8016be:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  8016c0:	8b 45 10             	mov    0x10(%ebp),%eax
  8016c3:	8d 50 ff             	lea    -0x1(%eax),%edx
  8016c6:	89 55 10             	mov    %edx,0x10(%ebp)
  8016c9:	85 c0                	test   %eax,%eax
  8016cb:	75 e3                	jne    8016b0 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  8016cd:	eb 23                	jmp    8016f2 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  8016cf:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8016d2:	8d 50 01             	lea    0x1(%eax),%edx
  8016d5:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8016d8:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8016db:	8d 4a 01             	lea    0x1(%edx),%ecx
  8016de:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  8016e1:	8a 12                	mov    (%edx),%dl
  8016e3:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  8016e5:	8b 45 10             	mov    0x10(%ebp),%eax
  8016e8:	8d 50 ff             	lea    -0x1(%eax),%edx
  8016eb:	89 55 10             	mov    %edx,0x10(%ebp)
  8016ee:	85 c0                	test   %eax,%eax
  8016f0:	75 dd                	jne    8016cf <memmove+0x54>
			*d++ = *s++;

	return dst;
  8016f2:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8016f5:	c9                   	leave  
  8016f6:	c3                   	ret    

008016f7 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  8016f7:	55                   	push   %ebp
  8016f8:	89 e5                	mov    %esp,%ebp
  8016fa:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  8016fd:	8b 45 08             	mov    0x8(%ebp),%eax
  801700:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  801703:	8b 45 0c             	mov    0xc(%ebp),%eax
  801706:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  801709:	eb 2a                	jmp    801735 <memcmp+0x3e>
		if (*s1 != *s2)
  80170b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80170e:	8a 10                	mov    (%eax),%dl
  801710:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801713:	8a 00                	mov    (%eax),%al
  801715:	38 c2                	cmp    %al,%dl
  801717:	74 16                	je     80172f <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  801719:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80171c:	8a 00                	mov    (%eax),%al
  80171e:	0f b6 d0             	movzbl %al,%edx
  801721:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801724:	8a 00                	mov    (%eax),%al
  801726:	0f b6 c0             	movzbl %al,%eax
  801729:	29 c2                	sub    %eax,%edx
  80172b:	89 d0                	mov    %edx,%eax
  80172d:	eb 18                	jmp    801747 <memcmp+0x50>
		s1++, s2++;
  80172f:	ff 45 fc             	incl   -0x4(%ebp)
  801732:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  801735:	8b 45 10             	mov    0x10(%ebp),%eax
  801738:	8d 50 ff             	lea    -0x1(%eax),%edx
  80173b:	89 55 10             	mov    %edx,0x10(%ebp)
  80173e:	85 c0                	test   %eax,%eax
  801740:	75 c9                	jne    80170b <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801742:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801747:	c9                   	leave  
  801748:	c3                   	ret    

00801749 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  801749:	55                   	push   %ebp
  80174a:	89 e5                	mov    %esp,%ebp
  80174c:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  80174f:	8b 55 08             	mov    0x8(%ebp),%edx
  801752:	8b 45 10             	mov    0x10(%ebp),%eax
  801755:	01 d0                	add    %edx,%eax
  801757:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  80175a:	eb 15                	jmp    801771 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  80175c:	8b 45 08             	mov    0x8(%ebp),%eax
  80175f:	8a 00                	mov    (%eax),%al
  801761:	0f b6 d0             	movzbl %al,%edx
  801764:	8b 45 0c             	mov    0xc(%ebp),%eax
  801767:	0f b6 c0             	movzbl %al,%eax
  80176a:	39 c2                	cmp    %eax,%edx
  80176c:	74 0d                	je     80177b <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  80176e:	ff 45 08             	incl   0x8(%ebp)
  801771:	8b 45 08             	mov    0x8(%ebp),%eax
  801774:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801777:	72 e3                	jb     80175c <memfind+0x13>
  801779:	eb 01                	jmp    80177c <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  80177b:	90                   	nop
	return (void *) s;
  80177c:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80177f:	c9                   	leave  
  801780:	c3                   	ret    

00801781 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801781:	55                   	push   %ebp
  801782:	89 e5                	mov    %esp,%ebp
  801784:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  801787:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  80178e:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801795:	eb 03                	jmp    80179a <strtol+0x19>
		s++;
  801797:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80179a:	8b 45 08             	mov    0x8(%ebp),%eax
  80179d:	8a 00                	mov    (%eax),%al
  80179f:	3c 20                	cmp    $0x20,%al
  8017a1:	74 f4                	je     801797 <strtol+0x16>
  8017a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8017a6:	8a 00                	mov    (%eax),%al
  8017a8:	3c 09                	cmp    $0x9,%al
  8017aa:	74 eb                	je     801797 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  8017ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8017af:	8a 00                	mov    (%eax),%al
  8017b1:	3c 2b                	cmp    $0x2b,%al
  8017b3:	75 05                	jne    8017ba <strtol+0x39>
		s++;
  8017b5:	ff 45 08             	incl   0x8(%ebp)
  8017b8:	eb 13                	jmp    8017cd <strtol+0x4c>
	else if (*s == '-')
  8017ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8017bd:	8a 00                	mov    (%eax),%al
  8017bf:	3c 2d                	cmp    $0x2d,%al
  8017c1:	75 0a                	jne    8017cd <strtol+0x4c>
		s++, neg = 1;
  8017c3:	ff 45 08             	incl   0x8(%ebp)
  8017c6:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8017cd:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8017d1:	74 06                	je     8017d9 <strtol+0x58>
  8017d3:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  8017d7:	75 20                	jne    8017f9 <strtol+0x78>
  8017d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8017dc:	8a 00                	mov    (%eax),%al
  8017de:	3c 30                	cmp    $0x30,%al
  8017e0:	75 17                	jne    8017f9 <strtol+0x78>
  8017e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8017e5:	40                   	inc    %eax
  8017e6:	8a 00                	mov    (%eax),%al
  8017e8:	3c 78                	cmp    $0x78,%al
  8017ea:	75 0d                	jne    8017f9 <strtol+0x78>
		s += 2, base = 16;
  8017ec:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  8017f0:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  8017f7:	eb 28                	jmp    801821 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  8017f9:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8017fd:	75 15                	jne    801814 <strtol+0x93>
  8017ff:	8b 45 08             	mov    0x8(%ebp),%eax
  801802:	8a 00                	mov    (%eax),%al
  801804:	3c 30                	cmp    $0x30,%al
  801806:	75 0c                	jne    801814 <strtol+0x93>
		s++, base = 8;
  801808:	ff 45 08             	incl   0x8(%ebp)
  80180b:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  801812:	eb 0d                	jmp    801821 <strtol+0xa0>
	else if (base == 0)
  801814:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801818:	75 07                	jne    801821 <strtol+0xa0>
		base = 10;
  80181a:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801821:	8b 45 08             	mov    0x8(%ebp),%eax
  801824:	8a 00                	mov    (%eax),%al
  801826:	3c 2f                	cmp    $0x2f,%al
  801828:	7e 19                	jle    801843 <strtol+0xc2>
  80182a:	8b 45 08             	mov    0x8(%ebp),%eax
  80182d:	8a 00                	mov    (%eax),%al
  80182f:	3c 39                	cmp    $0x39,%al
  801831:	7f 10                	jg     801843 <strtol+0xc2>
			dig = *s - '0';
  801833:	8b 45 08             	mov    0x8(%ebp),%eax
  801836:	8a 00                	mov    (%eax),%al
  801838:	0f be c0             	movsbl %al,%eax
  80183b:	83 e8 30             	sub    $0x30,%eax
  80183e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801841:	eb 42                	jmp    801885 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  801843:	8b 45 08             	mov    0x8(%ebp),%eax
  801846:	8a 00                	mov    (%eax),%al
  801848:	3c 60                	cmp    $0x60,%al
  80184a:	7e 19                	jle    801865 <strtol+0xe4>
  80184c:	8b 45 08             	mov    0x8(%ebp),%eax
  80184f:	8a 00                	mov    (%eax),%al
  801851:	3c 7a                	cmp    $0x7a,%al
  801853:	7f 10                	jg     801865 <strtol+0xe4>
			dig = *s - 'a' + 10;
  801855:	8b 45 08             	mov    0x8(%ebp),%eax
  801858:	8a 00                	mov    (%eax),%al
  80185a:	0f be c0             	movsbl %al,%eax
  80185d:	83 e8 57             	sub    $0x57,%eax
  801860:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801863:	eb 20                	jmp    801885 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  801865:	8b 45 08             	mov    0x8(%ebp),%eax
  801868:	8a 00                	mov    (%eax),%al
  80186a:	3c 40                	cmp    $0x40,%al
  80186c:	7e 39                	jle    8018a7 <strtol+0x126>
  80186e:	8b 45 08             	mov    0x8(%ebp),%eax
  801871:	8a 00                	mov    (%eax),%al
  801873:	3c 5a                	cmp    $0x5a,%al
  801875:	7f 30                	jg     8018a7 <strtol+0x126>
			dig = *s - 'A' + 10;
  801877:	8b 45 08             	mov    0x8(%ebp),%eax
  80187a:	8a 00                	mov    (%eax),%al
  80187c:	0f be c0             	movsbl %al,%eax
  80187f:	83 e8 37             	sub    $0x37,%eax
  801882:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  801885:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801888:	3b 45 10             	cmp    0x10(%ebp),%eax
  80188b:	7d 19                	jge    8018a6 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  80188d:	ff 45 08             	incl   0x8(%ebp)
  801890:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801893:	0f af 45 10          	imul   0x10(%ebp),%eax
  801897:	89 c2                	mov    %eax,%edx
  801899:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80189c:	01 d0                	add    %edx,%eax
  80189e:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  8018a1:	e9 7b ff ff ff       	jmp    801821 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  8018a6:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  8018a7:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8018ab:	74 08                	je     8018b5 <strtol+0x134>
		*endptr = (char *) s;
  8018ad:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018b0:	8b 55 08             	mov    0x8(%ebp),%edx
  8018b3:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  8018b5:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8018b9:	74 07                	je     8018c2 <strtol+0x141>
  8018bb:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8018be:	f7 d8                	neg    %eax
  8018c0:	eb 03                	jmp    8018c5 <strtol+0x144>
  8018c2:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8018c5:	c9                   	leave  
  8018c6:	c3                   	ret    

008018c7 <ltostr>:

void
ltostr(long value, char *str)
{
  8018c7:	55                   	push   %ebp
  8018c8:	89 e5                	mov    %esp,%ebp
  8018ca:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  8018cd:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  8018d4:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  8018db:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8018df:	79 13                	jns    8018f4 <ltostr+0x2d>
	{
		neg = 1;
  8018e1:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  8018e8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018eb:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  8018ee:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  8018f1:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  8018f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8018f7:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8018fc:	99                   	cltd   
  8018fd:	f7 f9                	idiv   %ecx
  8018ff:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  801902:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801905:	8d 50 01             	lea    0x1(%eax),%edx
  801908:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80190b:	89 c2                	mov    %eax,%edx
  80190d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801910:	01 d0                	add    %edx,%eax
  801912:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801915:	83 c2 30             	add    $0x30,%edx
  801918:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  80191a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80191d:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801922:	f7 e9                	imul   %ecx
  801924:	c1 fa 02             	sar    $0x2,%edx
  801927:	89 c8                	mov    %ecx,%eax
  801929:	c1 f8 1f             	sar    $0x1f,%eax
  80192c:	29 c2                	sub    %eax,%edx
  80192e:	89 d0                	mov    %edx,%eax
  801930:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  801933:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801937:	75 bb                	jne    8018f4 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801939:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801940:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801943:	48                   	dec    %eax
  801944:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801947:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80194b:	74 3d                	je     80198a <ltostr+0xc3>
		start = 1 ;
  80194d:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  801954:	eb 34                	jmp    80198a <ltostr+0xc3>
	{
		char tmp = str[start] ;
  801956:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801959:	8b 45 0c             	mov    0xc(%ebp),%eax
  80195c:	01 d0                	add    %edx,%eax
  80195e:	8a 00                	mov    (%eax),%al
  801960:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801963:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801966:	8b 45 0c             	mov    0xc(%ebp),%eax
  801969:	01 c2                	add    %eax,%edx
  80196b:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  80196e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801971:	01 c8                	add    %ecx,%eax
  801973:	8a 00                	mov    (%eax),%al
  801975:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801977:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80197a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80197d:	01 c2                	add    %eax,%edx
  80197f:	8a 45 eb             	mov    -0x15(%ebp),%al
  801982:	88 02                	mov    %al,(%edx)
		start++ ;
  801984:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801987:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  80198a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80198d:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801990:	7c c4                	jl     801956 <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801992:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801995:	8b 45 0c             	mov    0xc(%ebp),%eax
  801998:	01 d0                	add    %edx,%eax
  80199a:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  80199d:	90                   	nop
  80199e:	c9                   	leave  
  80199f:	c3                   	ret    

008019a0 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  8019a0:	55                   	push   %ebp
  8019a1:	89 e5                	mov    %esp,%ebp
  8019a3:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  8019a6:	ff 75 08             	pushl  0x8(%ebp)
  8019a9:	e8 c4 f9 ff ff       	call   801372 <strlen>
  8019ae:	83 c4 04             	add    $0x4,%esp
  8019b1:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  8019b4:	ff 75 0c             	pushl  0xc(%ebp)
  8019b7:	e8 b6 f9 ff ff       	call   801372 <strlen>
  8019bc:	83 c4 04             	add    $0x4,%esp
  8019bf:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  8019c2:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  8019c9:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8019d0:	eb 17                	jmp    8019e9 <strcconcat+0x49>
		final[s] = str1[s] ;
  8019d2:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8019d5:	8b 45 10             	mov    0x10(%ebp),%eax
  8019d8:	01 c2                	add    %eax,%edx
  8019da:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8019dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8019e0:	01 c8                	add    %ecx,%eax
  8019e2:	8a 00                	mov    (%eax),%al
  8019e4:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  8019e6:	ff 45 fc             	incl   -0x4(%ebp)
  8019e9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8019ec:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8019ef:	7c e1                	jl     8019d2 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  8019f1:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  8019f8:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8019ff:	eb 1f                	jmp    801a20 <strcconcat+0x80>
		final[s++] = str2[i] ;
  801a01:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801a04:	8d 50 01             	lea    0x1(%eax),%edx
  801a07:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801a0a:	89 c2                	mov    %eax,%edx
  801a0c:	8b 45 10             	mov    0x10(%ebp),%eax
  801a0f:	01 c2                	add    %eax,%edx
  801a11:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801a14:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a17:	01 c8                	add    %ecx,%eax
  801a19:	8a 00                	mov    (%eax),%al
  801a1b:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801a1d:	ff 45 f8             	incl   -0x8(%ebp)
  801a20:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801a23:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801a26:	7c d9                	jl     801a01 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801a28:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801a2b:	8b 45 10             	mov    0x10(%ebp),%eax
  801a2e:	01 d0                	add    %edx,%eax
  801a30:	c6 00 00             	movb   $0x0,(%eax)
}
  801a33:	90                   	nop
  801a34:	c9                   	leave  
  801a35:	c3                   	ret    

00801a36 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801a36:	55                   	push   %ebp
  801a37:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801a39:	8b 45 14             	mov    0x14(%ebp),%eax
  801a3c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801a42:	8b 45 14             	mov    0x14(%ebp),%eax
  801a45:	8b 00                	mov    (%eax),%eax
  801a47:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801a4e:	8b 45 10             	mov    0x10(%ebp),%eax
  801a51:	01 d0                	add    %edx,%eax
  801a53:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801a59:	eb 0c                	jmp    801a67 <strsplit+0x31>
			*string++ = 0;
  801a5b:	8b 45 08             	mov    0x8(%ebp),%eax
  801a5e:	8d 50 01             	lea    0x1(%eax),%edx
  801a61:	89 55 08             	mov    %edx,0x8(%ebp)
  801a64:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801a67:	8b 45 08             	mov    0x8(%ebp),%eax
  801a6a:	8a 00                	mov    (%eax),%al
  801a6c:	84 c0                	test   %al,%al
  801a6e:	74 18                	je     801a88 <strsplit+0x52>
  801a70:	8b 45 08             	mov    0x8(%ebp),%eax
  801a73:	8a 00                	mov    (%eax),%al
  801a75:	0f be c0             	movsbl %al,%eax
  801a78:	50                   	push   %eax
  801a79:	ff 75 0c             	pushl  0xc(%ebp)
  801a7c:	e8 83 fa ff ff       	call   801504 <strchr>
  801a81:	83 c4 08             	add    $0x8,%esp
  801a84:	85 c0                	test   %eax,%eax
  801a86:	75 d3                	jne    801a5b <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801a88:	8b 45 08             	mov    0x8(%ebp),%eax
  801a8b:	8a 00                	mov    (%eax),%al
  801a8d:	84 c0                	test   %al,%al
  801a8f:	74 5a                	je     801aeb <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801a91:	8b 45 14             	mov    0x14(%ebp),%eax
  801a94:	8b 00                	mov    (%eax),%eax
  801a96:	83 f8 0f             	cmp    $0xf,%eax
  801a99:	75 07                	jne    801aa2 <strsplit+0x6c>
		{
			return 0;
  801a9b:	b8 00 00 00 00       	mov    $0x0,%eax
  801aa0:	eb 66                	jmp    801b08 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801aa2:	8b 45 14             	mov    0x14(%ebp),%eax
  801aa5:	8b 00                	mov    (%eax),%eax
  801aa7:	8d 48 01             	lea    0x1(%eax),%ecx
  801aaa:	8b 55 14             	mov    0x14(%ebp),%edx
  801aad:	89 0a                	mov    %ecx,(%edx)
  801aaf:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801ab6:	8b 45 10             	mov    0x10(%ebp),%eax
  801ab9:	01 c2                	add    %eax,%edx
  801abb:	8b 45 08             	mov    0x8(%ebp),%eax
  801abe:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801ac0:	eb 03                	jmp    801ac5 <strsplit+0x8f>
			string++;
  801ac2:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801ac5:	8b 45 08             	mov    0x8(%ebp),%eax
  801ac8:	8a 00                	mov    (%eax),%al
  801aca:	84 c0                	test   %al,%al
  801acc:	74 8b                	je     801a59 <strsplit+0x23>
  801ace:	8b 45 08             	mov    0x8(%ebp),%eax
  801ad1:	8a 00                	mov    (%eax),%al
  801ad3:	0f be c0             	movsbl %al,%eax
  801ad6:	50                   	push   %eax
  801ad7:	ff 75 0c             	pushl  0xc(%ebp)
  801ada:	e8 25 fa ff ff       	call   801504 <strchr>
  801adf:	83 c4 08             	add    $0x8,%esp
  801ae2:	85 c0                	test   %eax,%eax
  801ae4:	74 dc                	je     801ac2 <strsplit+0x8c>
			string++;
	}
  801ae6:	e9 6e ff ff ff       	jmp    801a59 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801aeb:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801aec:	8b 45 14             	mov    0x14(%ebp),%eax
  801aef:	8b 00                	mov    (%eax),%eax
  801af1:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801af8:	8b 45 10             	mov    0x10(%ebp),%eax
  801afb:	01 d0                	add    %edx,%eax
  801afd:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801b03:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801b08:	c9                   	leave  
  801b09:	c3                   	ret    

00801b0a <str2lower>:


char* str2lower(char *dst, const char *src)
{
  801b0a:	55                   	push   %ebp
  801b0b:	89 e5                	mov    %esp,%ebp
  801b0d:	83 ec 10             	sub    $0x10,%esp
	char* ret = dst;
  801b10:	8b 45 08             	mov    0x8(%ebp),%eax
  801b13:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (int i = 0; i < strlen(src); ++i)
  801b16:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801b1d:	eb 4a                	jmp    801b69 <str2lower+0x5f>
	{
		dst[i] = src[i] ;
  801b1f:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801b22:	8b 45 08             	mov    0x8(%ebp),%eax
  801b25:	01 c2                	add    %eax,%edx
  801b27:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801b2a:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b2d:	01 c8                	add    %ecx,%eax
  801b2f:	8a 00                	mov    (%eax),%al
  801b31:	88 02                	mov    %al,(%edx)
		if (src[i] >= 'A' && src[i] <= 'Z')
  801b33:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801b36:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b39:	01 d0                	add    %edx,%eax
  801b3b:	8a 00                	mov    (%eax),%al
  801b3d:	3c 40                	cmp    $0x40,%al
  801b3f:	7e 25                	jle    801b66 <str2lower+0x5c>
  801b41:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801b44:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b47:	01 d0                	add    %edx,%eax
  801b49:	8a 00                	mov    (%eax),%al
  801b4b:	3c 5a                	cmp    $0x5a,%al
  801b4d:	7f 17                	jg     801b66 <str2lower+0x5c>
		{
			dst[i] += 32 ;
  801b4f:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801b52:	8b 45 08             	mov    0x8(%ebp),%eax
  801b55:	01 d0                	add    %edx,%eax
  801b57:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801b5a:	8b 55 08             	mov    0x8(%ebp),%edx
  801b5d:	01 ca                	add    %ecx,%edx
  801b5f:	8a 12                	mov    (%edx),%dl
  801b61:	83 c2 20             	add    $0x20,%edx
  801b64:	88 10                	mov    %dl,(%eax)


char* str2lower(char *dst, const char *src)
{
	char* ret = dst;
	for (int i = 0; i < strlen(src); ++i)
  801b66:	ff 45 fc             	incl   -0x4(%ebp)
  801b69:	ff 75 0c             	pushl  0xc(%ebp)
  801b6c:	e8 01 f8 ff ff       	call   801372 <strlen>
  801b71:	83 c4 04             	add    $0x4,%esp
  801b74:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801b77:	7f a6                	jg     801b1f <str2lower+0x15>
		if (src[i] >= 'A' && src[i] <= 'Z')
		{
			dst[i] += 32 ;
		}
	}
	return ret;
  801b79:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801b7c:	c9                   	leave  
  801b7d:	c3                   	ret    

00801b7e <uheap_init>:
//==============================================
// [1] INITIALIZE USER HEAP:
//==============================================
int __firstTimeFlag = 1;
void uheap_init()
{
  801b7e:	55                   	push   %ebp
  801b7f:	89 e5                	mov    %esp,%ebp
  801b81:	83 ec 08             	sub    $0x8,%esp
	if(__firstTimeFlag)
  801b84:	a1 08 40 80 00       	mov    0x804008,%eax
  801b89:	85 c0                	test   %eax,%eax
  801b8b:	74 42                	je     801bcf <uheap_init+0x51>
	{
		initialize_dynamic_allocator(USER_HEAP_START, USER_HEAP_START + DYN_ALLOC_MAX_SIZE);
  801b8d:	83 ec 08             	sub    $0x8,%esp
  801b90:	68 00 00 00 82       	push   $0x82000000
  801b95:	68 00 00 00 80       	push   $0x80000000
  801b9a:	e8 00 08 00 00       	call   80239f <initialize_dynamic_allocator>
  801b9f:	83 c4 10             	add    $0x10,%esp
		uheapPlaceStrategy = sys_get_uheap_strategy();
  801ba2:	e8 e7 05 00 00       	call   80218e <sys_get_uheap_strategy>
  801ba7:	a3 60 c0 81 00       	mov    %eax,0x81c060
		uheapPageAllocStart = dynAllocEnd + PAGE_SIZE;
  801bac:	a1 40 40 80 00       	mov    0x804040,%eax
  801bb1:	05 00 10 00 00       	add    $0x1000,%eax
  801bb6:	a3 10 c1 81 00       	mov    %eax,0x81c110
		uheapPageAllocBreak = uheapPageAllocStart;
  801bbb:	a1 10 c1 81 00       	mov    0x81c110,%eax
  801bc0:	a3 68 c0 81 00       	mov    %eax,0x81c068

		__firstTimeFlag = 0;
  801bc5:	c7 05 08 40 80 00 00 	movl   $0x0,0x804008
  801bcc:	00 00 00 
	}
}
  801bcf:	90                   	nop
  801bd0:	c9                   	leave  
  801bd1:	c3                   	ret    

00801bd2 <get_page>:

//==============================================
// [2] GET A PAGE FROM THE KERNEL FOR DA:
//==============================================
int get_page(void* va)
{
  801bd2:	55                   	push   %ebp
  801bd3:	89 e5                	mov    %esp,%ebp
  801bd5:	83 ec 18             	sub    $0x18,%esp
	int ret = __sys_allocate_page(ROUNDDOWN(va, PAGE_SIZE), PERM_USER|PERM_WRITEABLE|PERM_UHPAGE);
  801bd8:	8b 45 08             	mov    0x8(%ebp),%eax
  801bdb:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801bde:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801be1:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801be6:	83 ec 08             	sub    $0x8,%esp
  801be9:	68 06 04 00 00       	push   $0x406
  801bee:	50                   	push   %eax
  801bef:	e8 e4 01 00 00       	call   801dd8 <__sys_allocate_page>
  801bf4:	83 c4 10             	add    $0x10,%esp
  801bf7:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (ret < 0)
  801bfa:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801bfe:	79 14                	jns    801c14 <get_page+0x42>
		panic("get_page() in user: failed to allocate page from the kernel");
  801c00:	83 ec 04             	sub    $0x4,%esp
  801c03:	68 3c 38 80 00       	push   $0x80383c
  801c08:	6a 1f                	push   $0x1f
  801c0a:	68 78 38 80 00       	push   $0x803878
  801c0f:	e8 af eb ff ff       	call   8007c3 <_panic>
	return 0;
  801c14:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801c19:	c9                   	leave  
  801c1a:	c3                   	ret    

00801c1b <return_page>:

//==============================================
// [3] RETURN A PAGE FROM THE DA TO KERNEL:
//==============================================
void return_page(void* va)
{
  801c1b:	55                   	push   %ebp
  801c1c:	89 e5                	mov    %esp,%ebp
  801c1e:	83 ec 18             	sub    $0x18,%esp
	int ret = __sys_unmap_frame(ROUNDDOWN((uint32)va, PAGE_SIZE));
  801c21:	8b 45 08             	mov    0x8(%ebp),%eax
  801c24:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801c27:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c2a:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801c2f:	83 ec 0c             	sub    $0xc,%esp
  801c32:	50                   	push   %eax
  801c33:	e8 e7 01 00 00       	call   801e1f <__sys_unmap_frame>
  801c38:	83 c4 10             	add    $0x10,%esp
  801c3b:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (ret < 0)
  801c3e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801c42:	79 14                	jns    801c58 <return_page+0x3d>
		panic("return_page() in user: failed to return a page to the kernel");
  801c44:	83 ec 04             	sub    $0x4,%esp
  801c47:	68 84 38 80 00       	push   $0x803884
  801c4c:	6a 2a                	push   $0x2a
  801c4e:	68 78 38 80 00       	push   $0x803878
  801c53:	e8 6b eb ff ff       	call   8007c3 <_panic>
}
  801c58:	90                   	nop
  801c59:	c9                   	leave  
  801c5a:	c3                   	ret    

00801c5b <malloc>:

//=================================
// [1] ALLOCATE SPACE IN USER HEAP:
//=================================
void* malloc(uint32 size)
{
  801c5b:	55                   	push   %ebp
  801c5c:	89 e5                	mov    %esp,%ebp
  801c5e:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  801c61:	e8 18 ff ff ff       	call   801b7e <uheap_init>
	if (size == 0) return NULL ;
  801c66:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801c6a:	75 07                	jne    801c73 <malloc+0x18>
  801c6c:	b8 00 00 00 00       	mov    $0x0,%eax
  801c71:	eb 14                	jmp    801c87 <malloc+0x2c>
	//==============================================================
	//TODO: [PROJECT'25.IM#2] USER HEAP - #1 malloc
	//Your code is here
	//Comment the following line
	panic("malloc() is not implemented yet...!!");
  801c73:	83 ec 04             	sub    $0x4,%esp
  801c76:	68 c4 38 80 00       	push   $0x8038c4
  801c7b:	6a 3e                	push   $0x3e
  801c7d:	68 78 38 80 00       	push   $0x803878
  801c82:	e8 3c eb ff ff       	call   8007c3 <_panic>
}
  801c87:	c9                   	leave  
  801c88:	c3                   	ret    

00801c89 <free>:

//=================================
// [2] FREE SPACE FROM USER HEAP:
//=================================
void free(void* virtual_address)
{
  801c89:	55                   	push   %ebp
  801c8a:	89 e5                	mov    %esp,%ebp
  801c8c:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.IM#2] USER HEAP - #3 free
	//Your code is here
	//Comment the following line
	panic("free() is not implemented yet...!!");
  801c8f:	83 ec 04             	sub    $0x4,%esp
  801c92:	68 ec 38 80 00       	push   $0x8038ec
  801c97:	6a 49                	push   $0x49
  801c99:	68 78 38 80 00       	push   $0x803878
  801c9e:	e8 20 eb ff ff       	call   8007c3 <_panic>

00801ca3 <smalloc>:

//=================================
// [3] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  801ca3:	55                   	push   %ebp
  801ca4:	89 e5                	mov    %esp,%ebp
  801ca6:	83 ec 18             	sub    $0x18,%esp
  801ca9:	8b 45 10             	mov    0x10(%ebp),%eax
  801cac:	88 45 f4             	mov    %al,-0xc(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  801caf:	e8 ca fe ff ff       	call   801b7e <uheap_init>
	if (size == 0) return NULL ;
  801cb4:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801cb8:	75 07                	jne    801cc1 <smalloc+0x1e>
  801cba:	b8 00 00 00 00       	mov    $0x0,%eax
  801cbf:	eb 14                	jmp    801cd5 <smalloc+0x32>
	//==============================================================

	//TODO: [PROJECT'25.IM#3] SHARED MEMORY - #2 smalloc
	//Your code is here
	//Comment the following line
	panic("smalloc() is not implemented yet...!!");
  801cc1:	83 ec 04             	sub    $0x4,%esp
  801cc4:	68 10 39 80 00       	push   $0x803910
  801cc9:	6a 5a                	push   $0x5a
  801ccb:	68 78 38 80 00       	push   $0x803878
  801cd0:	e8 ee ea ff ff       	call   8007c3 <_panic>
}
  801cd5:	c9                   	leave  
  801cd6:	c3                   	ret    

00801cd7 <sget>:

//========================================
// [4] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801cd7:	55                   	push   %ebp
  801cd8:	89 e5                	mov    %esp,%ebp
  801cda:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  801cdd:	e8 9c fe ff ff       	call   801b7e <uheap_init>
	//==============================================================

	//TODO: [PROJECT'25.IM#3] SHARED MEMORY - #4 sget
	//Your code is here
	//Comment the following line
	panic("sget() is not implemented yet...!!");
  801ce2:	83 ec 04             	sub    $0x4,%esp
  801ce5:	68 38 39 80 00       	push   $0x803938
  801cea:	6a 6a                	push   $0x6a
  801cec:	68 78 38 80 00       	push   $0x803878
  801cf1:	e8 cd ea ff ff       	call   8007c3 <_panic>

00801cf6 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801cf6:	55                   	push   %ebp
  801cf7:	89 e5                	mov    %esp,%ebp
  801cf9:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  801cfc:	e8 7d fe ff ff       	call   801b7e <uheap_init>
	//==============================================================
	panic("realloc() is not implemented yet...!!");
  801d01:	83 ec 04             	sub    $0x4,%esp
  801d04:	68 5c 39 80 00       	push   $0x80395c
  801d09:	68 88 00 00 00       	push   $0x88
  801d0e:	68 78 38 80 00       	push   $0x803878
  801d13:	e8 ab ea ff ff       	call   8007c3 <_panic>

00801d18 <sfree>:
//
//	use sys_delete_shared_object(...); which switches to the kernel mode,
//	calls delete_shared_object(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the delete_shared_object() function is empty, make sure to implement it.
void sfree(void* virtual_address)
{
  801d18:	55                   	push   %ebp
  801d19:	89 e5                	mov    %esp,%ebp
  801d1b:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.BONUS#5] EXIT #2 - sfree
	//Your code is here
	//Comment the following line
	panic("sfree() is not implemented yet...!!");
  801d1e:	83 ec 04             	sub    $0x4,%esp
  801d21:	68 84 39 80 00       	push   $0x803984
  801d26:	68 9b 00 00 00       	push   $0x9b
  801d2b:	68 78 38 80 00       	push   $0x803878
  801d30:	e8 8e ea ff ff       	call   8007c3 <_panic>

00801d35 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801d35:	55                   	push   %ebp
  801d36:	89 e5                	mov    %esp,%ebp
  801d38:	57                   	push   %edi
  801d39:	56                   	push   %esi
  801d3a:	53                   	push   %ebx
  801d3b:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801d3e:	8b 45 08             	mov    0x8(%ebp),%eax
  801d41:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d44:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801d47:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801d4a:	8b 7d 18             	mov    0x18(%ebp),%edi
  801d4d:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801d50:	cd 30                	int    $0x30
  801d52:	89 45 f0             	mov    %eax,-0x10(%ebp)
				"b" (a3),
				"D" (a4),
				"S" (a5)
				: "cc", "memory");

	return ret;
  801d55:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801d58:	83 c4 10             	add    $0x10,%esp
  801d5b:	5b                   	pop    %ebx
  801d5c:	5e                   	pop    %esi
  801d5d:	5f                   	pop    %edi
  801d5e:	5d                   	pop    %ebp
  801d5f:	c3                   	ret    

00801d60 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName, int color)
{
  801d60:	55                   	push   %ebp
  801d61:	89 e5                	mov    %esp,%ebp
  801d63:	83 ec 04             	sub    $0x4,%esp
  801d66:	8b 45 10             	mov    0x10(%ebp),%eax
  801d69:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, color, 0);
  801d6c:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801d6f:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801d73:	8b 45 08             	mov    0x8(%ebp),%eax
  801d76:	6a 00                	push   $0x0
  801d78:	51                   	push   %ecx
  801d79:	52                   	push   %edx
  801d7a:	ff 75 0c             	pushl  0xc(%ebp)
  801d7d:	50                   	push   %eax
  801d7e:	6a 00                	push   $0x0
  801d80:	e8 b0 ff ff ff       	call   801d35 <syscall>
  801d85:	83 c4 18             	add    $0x18,%esp
}
  801d88:	90                   	nop
  801d89:	c9                   	leave  
  801d8a:	c3                   	ret    

00801d8b <sys_cgetc>:

int
sys_cgetc(void)
{
  801d8b:	55                   	push   %ebp
  801d8c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801d8e:	6a 00                	push   $0x0
  801d90:	6a 00                	push   $0x0
  801d92:	6a 00                	push   $0x0
  801d94:	6a 00                	push   $0x0
  801d96:	6a 00                	push   $0x0
  801d98:	6a 02                	push   $0x2
  801d9a:	e8 96 ff ff ff       	call   801d35 <syscall>
  801d9f:	83 c4 18             	add    $0x18,%esp
}
  801da2:	c9                   	leave  
  801da3:	c3                   	ret    

00801da4 <sys_lock_cons>:

void sys_lock_cons(void)
{
  801da4:	55                   	push   %ebp
  801da5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  801da7:	6a 00                	push   $0x0
  801da9:	6a 00                	push   $0x0
  801dab:	6a 00                	push   $0x0
  801dad:	6a 00                	push   $0x0
  801daf:	6a 00                	push   $0x0
  801db1:	6a 03                	push   $0x3
  801db3:	e8 7d ff ff ff       	call   801d35 <syscall>
  801db8:	83 c4 18             	add    $0x18,%esp
}
  801dbb:	90                   	nop
  801dbc:	c9                   	leave  
  801dbd:	c3                   	ret    

00801dbe <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  801dbe:	55                   	push   %ebp
  801dbf:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  801dc1:	6a 00                	push   $0x0
  801dc3:	6a 00                	push   $0x0
  801dc5:	6a 00                	push   $0x0
  801dc7:	6a 00                	push   $0x0
  801dc9:	6a 00                	push   $0x0
  801dcb:	6a 04                	push   $0x4
  801dcd:	e8 63 ff ff ff       	call   801d35 <syscall>
  801dd2:	83 c4 18             	add    $0x18,%esp
}
  801dd5:	90                   	nop
  801dd6:	c9                   	leave  
  801dd7:	c3                   	ret    

00801dd8 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801dd8:	55                   	push   %ebp
  801dd9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801ddb:	8b 55 0c             	mov    0xc(%ebp),%edx
  801dde:	8b 45 08             	mov    0x8(%ebp),%eax
  801de1:	6a 00                	push   $0x0
  801de3:	6a 00                	push   $0x0
  801de5:	6a 00                	push   $0x0
  801de7:	52                   	push   %edx
  801de8:	50                   	push   %eax
  801de9:	6a 08                	push   $0x8
  801deb:	e8 45 ff ff ff       	call   801d35 <syscall>
  801df0:	83 c4 18             	add    $0x18,%esp
}
  801df3:	c9                   	leave  
  801df4:	c3                   	ret    

00801df5 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801df5:	55                   	push   %ebp
  801df6:	89 e5                	mov    %esp,%ebp
  801df8:	56                   	push   %esi
  801df9:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801dfa:	8b 75 18             	mov    0x18(%ebp),%esi
  801dfd:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801e00:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801e03:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e06:	8b 45 08             	mov    0x8(%ebp),%eax
  801e09:	56                   	push   %esi
  801e0a:	53                   	push   %ebx
  801e0b:	51                   	push   %ecx
  801e0c:	52                   	push   %edx
  801e0d:	50                   	push   %eax
  801e0e:	6a 09                	push   $0x9
  801e10:	e8 20 ff ff ff       	call   801d35 <syscall>
  801e15:	83 c4 18             	add    $0x18,%esp
}
  801e18:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801e1b:	5b                   	pop    %ebx
  801e1c:	5e                   	pop    %esi
  801e1d:	5d                   	pop    %ebp
  801e1e:	c3                   	ret    

00801e1f <__sys_unmap_frame>:

int __sys_unmap_frame(uint32 va)
{
  801e1f:	55                   	push   %ebp
  801e20:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, va, 0, 0, 0, 0);
  801e22:	6a 00                	push   $0x0
  801e24:	6a 00                	push   $0x0
  801e26:	6a 00                	push   $0x0
  801e28:	6a 00                	push   $0x0
  801e2a:	ff 75 08             	pushl  0x8(%ebp)
  801e2d:	6a 0a                	push   $0xa
  801e2f:	e8 01 ff ff ff       	call   801d35 <syscall>
  801e34:	83 c4 18             	add    $0x18,%esp
}
  801e37:	c9                   	leave  
  801e38:	c3                   	ret    

00801e39 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801e39:	55                   	push   %ebp
  801e3a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801e3c:	6a 00                	push   $0x0
  801e3e:	6a 00                	push   $0x0
  801e40:	6a 00                	push   $0x0
  801e42:	ff 75 0c             	pushl  0xc(%ebp)
  801e45:	ff 75 08             	pushl  0x8(%ebp)
  801e48:	6a 0b                	push   $0xb
  801e4a:	e8 e6 fe ff ff       	call   801d35 <syscall>
  801e4f:	83 c4 18             	add    $0x18,%esp
}
  801e52:	c9                   	leave  
  801e53:	c3                   	ret    

00801e54 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801e54:	55                   	push   %ebp
  801e55:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801e57:	6a 00                	push   $0x0
  801e59:	6a 00                	push   $0x0
  801e5b:	6a 00                	push   $0x0
  801e5d:	6a 00                	push   $0x0
  801e5f:	6a 00                	push   $0x0
  801e61:	6a 0c                	push   $0xc
  801e63:	e8 cd fe ff ff       	call   801d35 <syscall>
  801e68:	83 c4 18             	add    $0x18,%esp
}
  801e6b:	c9                   	leave  
  801e6c:	c3                   	ret    

00801e6d <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801e6d:	55                   	push   %ebp
  801e6e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801e70:	6a 00                	push   $0x0
  801e72:	6a 00                	push   $0x0
  801e74:	6a 00                	push   $0x0
  801e76:	6a 00                	push   $0x0
  801e78:	6a 00                	push   $0x0
  801e7a:	6a 0d                	push   $0xd
  801e7c:	e8 b4 fe ff ff       	call   801d35 <syscall>
  801e81:	83 c4 18             	add    $0x18,%esp
}
  801e84:	c9                   	leave  
  801e85:	c3                   	ret    

00801e86 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801e86:	55                   	push   %ebp
  801e87:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801e89:	6a 00                	push   $0x0
  801e8b:	6a 00                	push   $0x0
  801e8d:	6a 00                	push   $0x0
  801e8f:	6a 00                	push   $0x0
  801e91:	6a 00                	push   $0x0
  801e93:	6a 0e                	push   $0xe
  801e95:	e8 9b fe ff ff       	call   801d35 <syscall>
  801e9a:	83 c4 18             	add    $0x18,%esp
}
  801e9d:	c9                   	leave  
  801e9e:	c3                   	ret    

00801e9f <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801e9f:	55                   	push   %ebp
  801ea0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801ea2:	6a 00                	push   $0x0
  801ea4:	6a 00                	push   $0x0
  801ea6:	6a 00                	push   $0x0
  801ea8:	6a 00                	push   $0x0
  801eaa:	6a 00                	push   $0x0
  801eac:	6a 0f                	push   $0xf
  801eae:	e8 82 fe ff ff       	call   801d35 <syscall>
  801eb3:	83 c4 18             	add    $0x18,%esp
}
  801eb6:	c9                   	leave  
  801eb7:	c3                   	ret    

00801eb8 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801eb8:	55                   	push   %ebp
  801eb9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801ebb:	6a 00                	push   $0x0
  801ebd:	6a 00                	push   $0x0
  801ebf:	6a 00                	push   $0x0
  801ec1:	6a 00                	push   $0x0
  801ec3:	ff 75 08             	pushl  0x8(%ebp)
  801ec6:	6a 10                	push   $0x10
  801ec8:	e8 68 fe ff ff       	call   801d35 <syscall>
  801ecd:	83 c4 18             	add    $0x18,%esp
}
  801ed0:	c9                   	leave  
  801ed1:	c3                   	ret    

00801ed2 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801ed2:	55                   	push   %ebp
  801ed3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801ed5:	6a 00                	push   $0x0
  801ed7:	6a 00                	push   $0x0
  801ed9:	6a 00                	push   $0x0
  801edb:	6a 00                	push   $0x0
  801edd:	6a 00                	push   $0x0
  801edf:	6a 11                	push   $0x11
  801ee1:	e8 4f fe ff ff       	call   801d35 <syscall>
  801ee6:	83 c4 18             	add    $0x18,%esp
}
  801ee9:	90                   	nop
  801eea:	c9                   	leave  
  801eeb:	c3                   	ret    

00801eec <sys_cputc>:

void
sys_cputc(const char c)
{
  801eec:	55                   	push   %ebp
  801eed:	89 e5                	mov    %esp,%ebp
  801eef:	83 ec 04             	sub    $0x4,%esp
  801ef2:	8b 45 08             	mov    0x8(%ebp),%eax
  801ef5:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801ef8:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801efc:	6a 00                	push   $0x0
  801efe:	6a 00                	push   $0x0
  801f00:	6a 00                	push   $0x0
  801f02:	6a 00                	push   $0x0
  801f04:	50                   	push   %eax
  801f05:	6a 01                	push   $0x1
  801f07:	e8 29 fe ff ff       	call   801d35 <syscall>
  801f0c:	83 c4 18             	add    $0x18,%esp
}
  801f0f:	90                   	nop
  801f10:	c9                   	leave  
  801f11:	c3                   	ret    

00801f12 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801f12:	55                   	push   %ebp
  801f13:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801f15:	6a 00                	push   $0x0
  801f17:	6a 00                	push   $0x0
  801f19:	6a 00                	push   $0x0
  801f1b:	6a 00                	push   $0x0
  801f1d:	6a 00                	push   $0x0
  801f1f:	6a 14                	push   $0x14
  801f21:	e8 0f fe ff ff       	call   801d35 <syscall>
  801f26:	83 c4 18             	add    $0x18,%esp
}
  801f29:	90                   	nop
  801f2a:	c9                   	leave  
  801f2b:	c3                   	ret    

00801f2c <sys_create_shared_object>:

int sys_create_shared_object(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801f2c:	55                   	push   %ebp
  801f2d:	89 e5                	mov    %esp,%ebp
  801f2f:	83 ec 04             	sub    $0x4,%esp
  801f32:	8b 45 10             	mov    0x10(%ebp),%eax
  801f35:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801f38:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801f3b:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801f3f:	8b 45 08             	mov    0x8(%ebp),%eax
  801f42:	6a 00                	push   $0x0
  801f44:	51                   	push   %ecx
  801f45:	52                   	push   %edx
  801f46:	ff 75 0c             	pushl  0xc(%ebp)
  801f49:	50                   	push   %eax
  801f4a:	6a 15                	push   $0x15
  801f4c:	e8 e4 fd ff ff       	call   801d35 <syscall>
  801f51:	83 c4 18             	add    $0x18,%esp
}
  801f54:	c9                   	leave  
  801f55:	c3                   	ret    

00801f56 <sys_size_of_shared_object>:

//2017:
int sys_size_of_shared_object(int32 ownerID, char* shareName)
{
  801f56:	55                   	push   %ebp
  801f57:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801f59:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f5c:	8b 45 08             	mov    0x8(%ebp),%eax
  801f5f:	6a 00                	push   $0x0
  801f61:	6a 00                	push   $0x0
  801f63:	6a 00                	push   $0x0
  801f65:	52                   	push   %edx
  801f66:	50                   	push   %eax
  801f67:	6a 16                	push   $0x16
  801f69:	e8 c7 fd ff ff       	call   801d35 <syscall>
  801f6e:	83 c4 18             	add    $0x18,%esp
}
  801f71:	c9                   	leave  
  801f72:	c3                   	ret    

00801f73 <sys_get_shared_object>:
//==========

int sys_get_shared_object(int32 ownerID, char* shareName, void* virtual_address)
{
  801f73:	55                   	push   %ebp
  801f74:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801f76:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801f79:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f7c:	8b 45 08             	mov    0x8(%ebp),%eax
  801f7f:	6a 00                	push   $0x0
  801f81:	6a 00                	push   $0x0
  801f83:	51                   	push   %ecx
  801f84:	52                   	push   %edx
  801f85:	50                   	push   %eax
  801f86:	6a 17                	push   $0x17
  801f88:	e8 a8 fd ff ff       	call   801d35 <syscall>
  801f8d:	83 c4 18             	add    $0x18,%esp
}
  801f90:	c9                   	leave  
  801f91:	c3                   	ret    

00801f92 <sys_delete_shared_object>:

int sys_delete_shared_object(int32 sharedObjectID, void *startVA)
{
  801f92:	55                   	push   %ebp
  801f93:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801f95:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f98:	8b 45 08             	mov    0x8(%ebp),%eax
  801f9b:	6a 00                	push   $0x0
  801f9d:	6a 00                	push   $0x0
  801f9f:	6a 00                	push   $0x0
  801fa1:	52                   	push   %edx
  801fa2:	50                   	push   %eax
  801fa3:	6a 18                	push   $0x18
  801fa5:	e8 8b fd ff ff       	call   801d35 <syscall>
  801faa:	83 c4 18             	add    $0x18,%esp
}
  801fad:	c9                   	leave  
  801fae:	c3                   	ret    

00801faf <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801faf:	55                   	push   %ebp
  801fb0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801fb2:	8b 45 08             	mov    0x8(%ebp),%eax
  801fb5:	6a 00                	push   $0x0
  801fb7:	ff 75 14             	pushl  0x14(%ebp)
  801fba:	ff 75 10             	pushl  0x10(%ebp)
  801fbd:	ff 75 0c             	pushl  0xc(%ebp)
  801fc0:	50                   	push   %eax
  801fc1:	6a 19                	push   $0x19
  801fc3:	e8 6d fd ff ff       	call   801d35 <syscall>
  801fc8:	83 c4 18             	add    $0x18,%esp
}
  801fcb:	c9                   	leave  
  801fcc:	c3                   	ret    

00801fcd <sys_run_env>:

void sys_run_env(int32 envId)
{
  801fcd:	55                   	push   %ebp
  801fce:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801fd0:	8b 45 08             	mov    0x8(%ebp),%eax
  801fd3:	6a 00                	push   $0x0
  801fd5:	6a 00                	push   $0x0
  801fd7:	6a 00                	push   $0x0
  801fd9:	6a 00                	push   $0x0
  801fdb:	50                   	push   %eax
  801fdc:	6a 1a                	push   $0x1a
  801fde:	e8 52 fd ff ff       	call   801d35 <syscall>
  801fe3:	83 c4 18             	add    $0x18,%esp
}
  801fe6:	90                   	nop
  801fe7:	c9                   	leave  
  801fe8:	c3                   	ret    

00801fe9 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801fe9:	55                   	push   %ebp
  801fea:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801fec:	8b 45 08             	mov    0x8(%ebp),%eax
  801fef:	6a 00                	push   $0x0
  801ff1:	6a 00                	push   $0x0
  801ff3:	6a 00                	push   $0x0
  801ff5:	6a 00                	push   $0x0
  801ff7:	50                   	push   %eax
  801ff8:	6a 1b                	push   $0x1b
  801ffa:	e8 36 fd ff ff       	call   801d35 <syscall>
  801fff:	83 c4 18             	add    $0x18,%esp
}
  802002:	c9                   	leave  
  802003:	c3                   	ret    

00802004 <sys_getenvid>:

int32 sys_getenvid(void)
{
  802004:	55                   	push   %ebp
  802005:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  802007:	6a 00                	push   $0x0
  802009:	6a 00                	push   $0x0
  80200b:	6a 00                	push   $0x0
  80200d:	6a 00                	push   $0x0
  80200f:	6a 00                	push   $0x0
  802011:	6a 05                	push   $0x5
  802013:	e8 1d fd ff ff       	call   801d35 <syscall>
  802018:	83 c4 18             	add    $0x18,%esp
}
  80201b:	c9                   	leave  
  80201c:	c3                   	ret    

0080201d <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  80201d:	55                   	push   %ebp
  80201e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  802020:	6a 00                	push   $0x0
  802022:	6a 00                	push   $0x0
  802024:	6a 00                	push   $0x0
  802026:	6a 00                	push   $0x0
  802028:	6a 00                	push   $0x0
  80202a:	6a 06                	push   $0x6
  80202c:	e8 04 fd ff ff       	call   801d35 <syscall>
  802031:	83 c4 18             	add    $0x18,%esp
}
  802034:	c9                   	leave  
  802035:	c3                   	ret    

00802036 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  802036:	55                   	push   %ebp
  802037:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  802039:	6a 00                	push   $0x0
  80203b:	6a 00                	push   $0x0
  80203d:	6a 00                	push   $0x0
  80203f:	6a 00                	push   $0x0
  802041:	6a 00                	push   $0x0
  802043:	6a 07                	push   $0x7
  802045:	e8 eb fc ff ff       	call   801d35 <syscall>
  80204a:	83 c4 18             	add    $0x18,%esp
}
  80204d:	c9                   	leave  
  80204e:	c3                   	ret    

0080204f <sys_exit_env>:


void sys_exit_env(void)
{
  80204f:	55                   	push   %ebp
  802050:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  802052:	6a 00                	push   $0x0
  802054:	6a 00                	push   $0x0
  802056:	6a 00                	push   $0x0
  802058:	6a 00                	push   $0x0
  80205a:	6a 00                	push   $0x0
  80205c:	6a 1c                	push   $0x1c
  80205e:	e8 d2 fc ff ff       	call   801d35 <syscall>
  802063:	83 c4 18             	add    $0x18,%esp
}
  802066:	90                   	nop
  802067:	c9                   	leave  
  802068:	c3                   	ret    

00802069 <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  802069:	55                   	push   %ebp
  80206a:	89 e5                	mov    %esp,%ebp
  80206c:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  80206f:	8d 45 f8             	lea    -0x8(%ebp),%eax
  802072:	8d 50 04             	lea    0x4(%eax),%edx
  802075:	8d 45 f8             	lea    -0x8(%ebp),%eax
  802078:	6a 00                	push   $0x0
  80207a:	6a 00                	push   $0x0
  80207c:	6a 00                	push   $0x0
  80207e:	52                   	push   %edx
  80207f:	50                   	push   %eax
  802080:	6a 1d                	push   $0x1d
  802082:	e8 ae fc ff ff       	call   801d35 <syscall>
  802087:	83 c4 18             	add    $0x18,%esp
	return result;
  80208a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80208d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802090:	8b 55 fc             	mov    -0x4(%ebp),%edx
  802093:	89 01                	mov    %eax,(%ecx)
  802095:	89 51 04             	mov    %edx,0x4(%ecx)
}
  802098:	8b 45 08             	mov    0x8(%ebp),%eax
  80209b:	c9                   	leave  
  80209c:	c2 04 00             	ret    $0x4

0080209f <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  80209f:	55                   	push   %ebp
  8020a0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  8020a2:	6a 00                	push   $0x0
  8020a4:	6a 00                	push   $0x0
  8020a6:	ff 75 10             	pushl  0x10(%ebp)
  8020a9:	ff 75 0c             	pushl  0xc(%ebp)
  8020ac:	ff 75 08             	pushl  0x8(%ebp)
  8020af:	6a 13                	push   $0x13
  8020b1:	e8 7f fc ff ff       	call   801d35 <syscall>
  8020b6:	83 c4 18             	add    $0x18,%esp
	return ;
  8020b9:	90                   	nop
}
  8020ba:	c9                   	leave  
  8020bb:	c3                   	ret    

008020bc <sys_rcr2>:
uint32 sys_rcr2()
{
  8020bc:	55                   	push   %ebp
  8020bd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  8020bf:	6a 00                	push   $0x0
  8020c1:	6a 00                	push   $0x0
  8020c3:	6a 00                	push   $0x0
  8020c5:	6a 00                	push   $0x0
  8020c7:	6a 00                	push   $0x0
  8020c9:	6a 1e                	push   $0x1e
  8020cb:	e8 65 fc ff ff       	call   801d35 <syscall>
  8020d0:	83 c4 18             	add    $0x18,%esp
}
  8020d3:	c9                   	leave  
  8020d4:	c3                   	ret    

008020d5 <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  8020d5:	55                   	push   %ebp
  8020d6:	89 e5                	mov    %esp,%ebp
  8020d8:	83 ec 04             	sub    $0x4,%esp
  8020db:	8b 45 08             	mov    0x8(%ebp),%eax
  8020de:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  8020e1:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  8020e5:	6a 00                	push   $0x0
  8020e7:	6a 00                	push   $0x0
  8020e9:	6a 00                	push   $0x0
  8020eb:	6a 00                	push   $0x0
  8020ed:	50                   	push   %eax
  8020ee:	6a 1f                	push   $0x1f
  8020f0:	e8 40 fc ff ff       	call   801d35 <syscall>
  8020f5:	83 c4 18             	add    $0x18,%esp
	return ;
  8020f8:	90                   	nop
}
  8020f9:	c9                   	leave  
  8020fa:	c3                   	ret    

008020fb <rsttst>:
void rsttst()
{
  8020fb:	55                   	push   %ebp
  8020fc:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  8020fe:	6a 00                	push   $0x0
  802100:	6a 00                	push   $0x0
  802102:	6a 00                	push   $0x0
  802104:	6a 00                	push   $0x0
  802106:	6a 00                	push   $0x0
  802108:	6a 21                	push   $0x21
  80210a:	e8 26 fc ff ff       	call   801d35 <syscall>
  80210f:	83 c4 18             	add    $0x18,%esp
	return ;
  802112:	90                   	nop
}
  802113:	c9                   	leave  
  802114:	c3                   	ret    

00802115 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  802115:	55                   	push   %ebp
  802116:	89 e5                	mov    %esp,%ebp
  802118:	83 ec 04             	sub    $0x4,%esp
  80211b:	8b 45 14             	mov    0x14(%ebp),%eax
  80211e:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  802121:	8b 55 18             	mov    0x18(%ebp),%edx
  802124:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  802128:	52                   	push   %edx
  802129:	50                   	push   %eax
  80212a:	ff 75 10             	pushl  0x10(%ebp)
  80212d:	ff 75 0c             	pushl  0xc(%ebp)
  802130:	ff 75 08             	pushl  0x8(%ebp)
  802133:	6a 20                	push   $0x20
  802135:	e8 fb fb ff ff       	call   801d35 <syscall>
  80213a:	83 c4 18             	add    $0x18,%esp
	return ;
  80213d:	90                   	nop
}
  80213e:	c9                   	leave  
  80213f:	c3                   	ret    

00802140 <chktst>:
void chktst(uint32 n)
{
  802140:	55                   	push   %ebp
  802141:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  802143:	6a 00                	push   $0x0
  802145:	6a 00                	push   $0x0
  802147:	6a 00                	push   $0x0
  802149:	6a 00                	push   $0x0
  80214b:	ff 75 08             	pushl  0x8(%ebp)
  80214e:	6a 22                	push   $0x22
  802150:	e8 e0 fb ff ff       	call   801d35 <syscall>
  802155:	83 c4 18             	add    $0x18,%esp
	return ;
  802158:	90                   	nop
}
  802159:	c9                   	leave  
  80215a:	c3                   	ret    

0080215b <inctst>:

void inctst()
{
  80215b:	55                   	push   %ebp
  80215c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  80215e:	6a 00                	push   $0x0
  802160:	6a 00                	push   $0x0
  802162:	6a 00                	push   $0x0
  802164:	6a 00                	push   $0x0
  802166:	6a 00                	push   $0x0
  802168:	6a 23                	push   $0x23
  80216a:	e8 c6 fb ff ff       	call   801d35 <syscall>
  80216f:	83 c4 18             	add    $0x18,%esp
	return ;
  802172:	90                   	nop
}
  802173:	c9                   	leave  
  802174:	c3                   	ret    

00802175 <gettst>:
uint32 gettst()
{
  802175:	55                   	push   %ebp
  802176:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  802178:	6a 00                	push   $0x0
  80217a:	6a 00                	push   $0x0
  80217c:	6a 00                	push   $0x0
  80217e:	6a 00                	push   $0x0
  802180:	6a 00                	push   $0x0
  802182:	6a 24                	push   $0x24
  802184:	e8 ac fb ff ff       	call   801d35 <syscall>
  802189:	83 c4 18             	add    $0x18,%esp
}
  80218c:	c9                   	leave  
  80218d:	c3                   	ret    

0080218e <sys_get_uheap_strategy>:

/*2025*/
uint32 sys_get_uheap_strategy()
{
  80218e:	55                   	push   %ebp
  80218f:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802191:	6a 00                	push   $0x0
  802193:	6a 00                	push   $0x0
  802195:	6a 00                	push   $0x0
  802197:	6a 00                	push   $0x0
  802199:	6a 00                	push   $0x0
  80219b:	6a 25                	push   $0x25
  80219d:	e8 93 fb ff ff       	call   801d35 <syscall>
  8021a2:	83 c4 18             	add    $0x18,%esp
  8021a5:	a3 60 c0 81 00       	mov    %eax,0x81c060
	return uheapPlaceStrategy ;
  8021aa:	a1 60 c0 81 00       	mov    0x81c060,%eax
}
  8021af:	c9                   	leave  
  8021b0:	c3                   	ret    

008021b1 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  8021b1:	55                   	push   %ebp
  8021b2:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = heapStrategy;
  8021b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8021b7:	a3 60 c0 81 00       	mov    %eax,0x81c060
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  8021bc:	6a 00                	push   $0x0
  8021be:	6a 00                	push   $0x0
  8021c0:	6a 00                	push   $0x0
  8021c2:	6a 00                	push   $0x0
  8021c4:	ff 75 08             	pushl  0x8(%ebp)
  8021c7:	6a 26                	push   $0x26
  8021c9:	e8 67 fb ff ff       	call   801d35 <syscall>
  8021ce:	83 c4 18             	add    $0x18,%esp
	return ;
  8021d1:	90                   	nop
}
  8021d2:	c9                   	leave  
  8021d3:	c3                   	ret    

008021d4 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  8021d4:	55                   	push   %ebp
  8021d5:	89 e5                	mov    %esp,%ebp
  8021d7:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  8021d8:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8021db:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8021de:	8b 55 0c             	mov    0xc(%ebp),%edx
  8021e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8021e4:	6a 00                	push   $0x0
  8021e6:	53                   	push   %ebx
  8021e7:	51                   	push   %ecx
  8021e8:	52                   	push   %edx
  8021e9:	50                   	push   %eax
  8021ea:	6a 27                	push   $0x27
  8021ec:	e8 44 fb ff ff       	call   801d35 <syscall>
  8021f1:	83 c4 18             	add    $0x18,%esp
}
  8021f4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8021f7:	c9                   	leave  
  8021f8:	c3                   	ret    

008021f9 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  8021f9:	55                   	push   %ebp
  8021fa:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  8021fc:	8b 55 0c             	mov    0xc(%ebp),%edx
  8021ff:	8b 45 08             	mov    0x8(%ebp),%eax
  802202:	6a 00                	push   $0x0
  802204:	6a 00                	push   $0x0
  802206:	6a 00                	push   $0x0
  802208:	52                   	push   %edx
  802209:	50                   	push   %eax
  80220a:	6a 28                	push   $0x28
  80220c:	e8 24 fb ff ff       	call   801d35 <syscall>
  802211:	83 c4 18             	add    $0x18,%esp
}
  802214:	c9                   	leave  
  802215:	c3                   	ret    

00802216 <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  802216:	55                   	push   %ebp
  802217:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  802219:	8b 4d 14             	mov    0x14(%ebp),%ecx
  80221c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80221f:	8b 45 08             	mov    0x8(%ebp),%eax
  802222:	6a 00                	push   $0x0
  802224:	51                   	push   %ecx
  802225:	ff 75 10             	pushl  0x10(%ebp)
  802228:	52                   	push   %edx
  802229:	50                   	push   %eax
  80222a:	6a 29                	push   $0x29
  80222c:	e8 04 fb ff ff       	call   801d35 <syscall>
  802231:	83 c4 18             	add    $0x18,%esp
}
  802234:	c9                   	leave  
  802235:	c3                   	ret    

00802236 <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  802236:	55                   	push   %ebp
  802237:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  802239:	6a 00                	push   $0x0
  80223b:	6a 00                	push   $0x0
  80223d:	ff 75 10             	pushl  0x10(%ebp)
  802240:	ff 75 0c             	pushl  0xc(%ebp)
  802243:	ff 75 08             	pushl  0x8(%ebp)
  802246:	6a 12                	push   $0x12
  802248:	e8 e8 fa ff ff       	call   801d35 <syscall>
  80224d:	83 c4 18             	add    $0x18,%esp
	return ;
  802250:	90                   	nop
}
  802251:	c9                   	leave  
  802252:	c3                   	ret    

00802253 <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  802253:	55                   	push   %ebp
  802254:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  802256:	8b 55 0c             	mov    0xc(%ebp),%edx
  802259:	8b 45 08             	mov    0x8(%ebp),%eax
  80225c:	6a 00                	push   $0x0
  80225e:	6a 00                	push   $0x0
  802260:	6a 00                	push   $0x0
  802262:	52                   	push   %edx
  802263:	50                   	push   %eax
  802264:	6a 2a                	push   $0x2a
  802266:	e8 ca fa ff ff       	call   801d35 <syscall>
  80226b:	83 c4 18             	add    $0x18,%esp
	return;
  80226e:	90                   	nop
}
  80226f:	c9                   	leave  
  802270:	c3                   	ret    

00802271 <sys_get_optimal_num_faults>:
/*2025*/
int sys_get_optimal_num_faults()
{
  802271:	55                   	push   %ebp
  802272:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_optimal_num_faults, 0, 0, 0, 0, 0);
  802274:	6a 00                	push   $0x0
  802276:	6a 00                	push   $0x0
  802278:	6a 00                	push   $0x0
  80227a:	6a 00                	push   $0x0
  80227c:	6a 00                	push   $0x0
  80227e:	6a 2b                	push   $0x2b
  802280:	e8 b0 fa ff ff       	call   801d35 <syscall>
  802285:	83 c4 18             	add    $0x18,%esp
}
  802288:	c9                   	leave  
  802289:	c3                   	ret    

0080228a <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  80228a:	55                   	push   %ebp
  80228b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  80228d:	6a 00                	push   $0x0
  80228f:	6a 00                	push   $0x0
  802291:	6a 00                	push   $0x0
  802293:	ff 75 0c             	pushl  0xc(%ebp)
  802296:	ff 75 08             	pushl  0x8(%ebp)
  802299:	6a 2d                	push   $0x2d
  80229b:	e8 95 fa ff ff       	call   801d35 <syscall>
  8022a0:	83 c4 18             	add    $0x18,%esp
	return;
  8022a3:	90                   	nop
}
  8022a4:	c9                   	leave  
  8022a5:	c3                   	ret    

008022a6 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  8022a6:	55                   	push   %ebp
  8022a7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  8022a9:	6a 00                	push   $0x0
  8022ab:	6a 00                	push   $0x0
  8022ad:	6a 00                	push   $0x0
  8022af:	ff 75 0c             	pushl  0xc(%ebp)
  8022b2:	ff 75 08             	pushl  0x8(%ebp)
  8022b5:	6a 2c                	push   $0x2c
  8022b7:	e8 79 fa ff ff       	call   801d35 <syscall>
  8022bc:	83 c4 18             	add    $0x18,%esp
	return ;
  8022bf:	90                   	nop
}
  8022c0:	c9                   	leave  
  8022c1:	c3                   	ret    

008022c2 <sys_env_set_priority>:


void sys_env_set_priority(int32 envID, int priority)
{
  8022c2:	55                   	push   %ebp
  8022c3:	89 e5                	mov    %esp,%ebp
  8022c5:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.IM#4] CPU SCHEDULING - #1 System Calls - Add suitable code here
	//Your code is here
	//Comment the following line
	panic("sys_env_set_priority() is not implemented yet...!!");
  8022c8:	83 ec 04             	sub    $0x4,%esp
  8022cb:	68 a8 39 80 00       	push   $0x8039a8
  8022d0:	68 25 01 00 00       	push   $0x125
  8022d5:	68 db 39 80 00       	push   $0x8039db
  8022da:	e8 e4 e4 ff ff       	call   8007c3 <_panic>

008022df <to_page_va>:
//==================================
//==================================
// [1] GET PAGE VA:
//==================================
__inline__ uint32 to_page_va(struct PageInfoElement *ptrPageInfo)
{
  8022df:	55                   	push   %ebp
  8022e0:	89 e5                	mov    %esp,%ebp
  8022e2:	83 ec 18             	sub    $0x18,%esp
	if (ptrPageInfo < &pageBlockInfoArr[0] || ptrPageInfo >= &pageBlockInfoArr[DYN_ALLOC_MAX_SIZE/PAGE_SIZE])
  8022e5:	81 7d 08 60 40 80 00 	cmpl   $0x804060,0x8(%ebp)
  8022ec:	72 09                	jb     8022f7 <to_page_va+0x18>
  8022ee:	81 7d 08 60 c0 81 00 	cmpl   $0x81c060,0x8(%ebp)
  8022f5:	72 14                	jb     80230b <to_page_va+0x2c>
			panic("to_page_va called with invalid pageInfoPtr");
  8022f7:	83 ec 04             	sub    $0x4,%esp
  8022fa:	68 ec 39 80 00       	push   $0x8039ec
  8022ff:	6a 15                	push   $0x15
  802301:	68 17 3a 80 00       	push   $0x803a17
  802306:	e8 b8 e4 ff ff       	call   8007c3 <_panic>
	//Get start VA of the page from the corresponding Page Info pointer
	int idxInPageInfoArr = (ptrPageInfo - pageBlockInfoArr);
  80230b:	8b 45 08             	mov    0x8(%ebp),%eax
  80230e:	ba 60 40 80 00       	mov    $0x804060,%edx
  802313:	29 d0                	sub    %edx,%eax
  802315:	c1 f8 02             	sar    $0x2,%eax
  802318:	89 c2                	mov    %eax,%edx
  80231a:	89 d0                	mov    %edx,%eax
  80231c:	c1 e0 02             	shl    $0x2,%eax
  80231f:	01 d0                	add    %edx,%eax
  802321:	c1 e0 02             	shl    $0x2,%eax
  802324:	01 d0                	add    %edx,%eax
  802326:	c1 e0 02             	shl    $0x2,%eax
  802329:	01 d0                	add    %edx,%eax
  80232b:	89 c1                	mov    %eax,%ecx
  80232d:	c1 e1 08             	shl    $0x8,%ecx
  802330:	01 c8                	add    %ecx,%eax
  802332:	89 c1                	mov    %eax,%ecx
  802334:	c1 e1 10             	shl    $0x10,%ecx
  802337:	01 c8                	add    %ecx,%eax
  802339:	01 c0                	add    %eax,%eax
  80233b:	01 d0                	add    %edx,%eax
  80233d:	89 45 f4             	mov    %eax,-0xc(%ebp)
	return dynAllocStart + (idxInPageInfoArr << PGSHIFT);
  802340:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802343:	c1 e0 0c             	shl    $0xc,%eax
  802346:	89 c2                	mov    %eax,%edx
  802348:	a1 64 c0 81 00       	mov    0x81c064,%eax
  80234d:	01 d0                	add    %edx,%eax
}
  80234f:	c9                   	leave  
  802350:	c3                   	ret    

00802351 <to_page_info>:

//==================================
// [2] GET PAGE INFO OF PAGE VA:
//==================================
__inline__ struct PageInfoElement * to_page_info(uint32 va)
{
  802351:	55                   	push   %ebp
  802352:	89 e5                	mov    %esp,%ebp
  802354:	83 ec 18             	sub    $0x18,%esp
	int idxInPageInfoArr = (va - dynAllocStart) >> PGSHIFT;
  802357:	a1 64 c0 81 00       	mov    0x81c064,%eax
  80235c:	8b 55 08             	mov    0x8(%ebp),%edx
  80235f:	29 c2                	sub    %eax,%edx
  802361:	89 d0                	mov    %edx,%eax
  802363:	c1 e8 0c             	shr    $0xc,%eax
  802366:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if (idxInPageInfoArr < 0 || idxInPageInfoArr >= DYN_ALLOC_MAX_SIZE/PAGE_SIZE)
  802369:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80236d:	78 09                	js     802378 <to_page_info+0x27>
  80236f:	81 7d f4 ff 1f 00 00 	cmpl   $0x1fff,-0xc(%ebp)
  802376:	7e 14                	jle    80238c <to_page_info+0x3b>
		panic("to_page_info called with invalid pa");
  802378:	83 ec 04             	sub    $0x4,%esp
  80237b:	68 30 3a 80 00       	push   $0x803a30
  802380:	6a 22                	push   $0x22
  802382:	68 17 3a 80 00       	push   $0x803a17
  802387:	e8 37 e4 ff ff       	call   8007c3 <_panic>
	return &pageBlockInfoArr[idxInPageInfoArr];
  80238c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80238f:	89 d0                	mov    %edx,%eax
  802391:	01 c0                	add    %eax,%eax
  802393:	01 d0                	add    %edx,%eax
  802395:	c1 e0 02             	shl    $0x2,%eax
  802398:	05 60 40 80 00       	add    $0x804060,%eax
}
  80239d:	c9                   	leave  
  80239e:	c3                   	ret    

0080239f <initialize_dynamic_allocator>:
//==================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================
bool is_initialized = 0;
void initialize_dynamic_allocator(uint32 daStart, uint32 daEnd)
{
  80239f:	55                   	push   %ebp
  8023a0:	89 e5                	mov    %esp,%ebp
  8023a2:	83 ec 18             	sub    $0x18,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		assert(daEnd <= daStart + DYN_ALLOC_MAX_SIZE);
  8023a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8023a8:	05 00 00 00 02       	add    $0x2000000,%eax
  8023ad:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8023b0:	73 16                	jae    8023c8 <initialize_dynamic_allocator+0x29>
  8023b2:	68 54 3a 80 00       	push   $0x803a54
  8023b7:	68 7a 3a 80 00       	push   $0x803a7a
  8023bc:	6a 34                	push   $0x34
  8023be:	68 17 3a 80 00       	push   $0x803a17
  8023c3:	e8 fb e3 ff ff       	call   8007c3 <_panic>
		is_initialized = 1;
  8023c8:	c7 05 28 40 80 00 01 	movl   $0x1,0x804028
  8023cf:	00 00 00 
	//==================================================================================
	//==================================================================================
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #1 initialize_dynamic_allocator
	//Your code is here
	// init bounds of the dynalloc
	dynAllocStart = daStart;
  8023d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8023d5:	a3 64 c0 81 00       	mov    %eax,0x81c064
	dynAllocEnd = daEnd;
  8023da:	8b 45 0c             	mov    0xc(%ebp),%eax
  8023dd:	a3 40 40 80 00       	mov    %eax,0x804040
	// init the list that keep track of all free pageBlockInfoArr instances.
	LIST_INIT(&freePagesList);
  8023e2:	c7 05 48 40 80 00 00 	movl   $0x0,0x804048
  8023e9:	00 00 00 
  8023ec:	c7 05 4c 40 80 00 00 	movl   $0x0,0x80404c
  8023f3:	00 00 00 
  8023f6:	c7 05 54 40 80 00 00 	movl   $0x0,0x804054
  8023fd:	00 00 00 

	// no.of pages in the dynamic allocator.
	int pCount = (daEnd - daStart) / PAGE_SIZE;
  802400:	8b 45 0c             	mov    0xc(%ebp),%eax
  802403:	2b 45 08             	sub    0x8(%ebp),%eax
  802406:	c1 e8 0c             	shr    $0xc,%eax
  802409:	89 45 ec             	mov    %eax,-0x14(%ebp)
	// iterate over each page and init its data in pageBlockInfoArr and reset it.
	for (int i = 0; i < pCount; ++i) {
  80240c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  802413:	e9 c8 00 00 00       	jmp    8024e0 <initialize_dynamic_allocator+0x141>
	    pageBlockInfoArr[i].block_size = 0;
  802418:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80241b:	89 d0                	mov    %edx,%eax
  80241d:	01 c0                	add    %eax,%eax
  80241f:	01 d0                	add    %edx,%eax
  802421:	c1 e0 02             	shl    $0x2,%eax
  802424:	05 68 40 80 00       	add    $0x804068,%eax
  802429:	66 c7 00 00 00       	movw   $0x0,(%eax)
	    pageBlockInfoArr[i].num_of_free_blocks = 0;
  80242e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802431:	89 d0                	mov    %edx,%eax
  802433:	01 c0                	add    %eax,%eax
  802435:	01 d0                	add    %edx,%eax
  802437:	c1 e0 02             	shl    $0x2,%eax
  80243a:	05 6a 40 80 00       	add    $0x80406a,%eax
  80243f:	66 c7 00 00 00       	movw   $0x0,(%eax)
	    LIST_INSERT_TAIL(&freePagesList, &pageBlockInfoArr[i]);
  802444:	8b 15 4c 40 80 00    	mov    0x80404c,%edx
  80244a:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  80244d:	89 c8                	mov    %ecx,%eax
  80244f:	01 c0                	add    %eax,%eax
  802451:	01 c8                	add    %ecx,%eax
  802453:	c1 e0 02             	shl    $0x2,%eax
  802456:	05 64 40 80 00       	add    $0x804064,%eax
  80245b:	89 10                	mov    %edx,(%eax)
  80245d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802460:	89 d0                	mov    %edx,%eax
  802462:	01 c0                	add    %eax,%eax
  802464:	01 d0                	add    %edx,%eax
  802466:	c1 e0 02             	shl    $0x2,%eax
  802469:	05 64 40 80 00       	add    $0x804064,%eax
  80246e:	8b 00                	mov    (%eax),%eax
  802470:	85 c0                	test   %eax,%eax
  802472:	74 1b                	je     80248f <initialize_dynamic_allocator+0xf0>
  802474:	8b 15 4c 40 80 00    	mov    0x80404c,%edx
  80247a:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  80247d:	89 c8                	mov    %ecx,%eax
  80247f:	01 c0                	add    %eax,%eax
  802481:	01 c8                	add    %ecx,%eax
  802483:	c1 e0 02             	shl    $0x2,%eax
  802486:	05 60 40 80 00       	add    $0x804060,%eax
  80248b:	89 02                	mov    %eax,(%edx)
  80248d:	eb 16                	jmp    8024a5 <initialize_dynamic_allocator+0x106>
  80248f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802492:	89 d0                	mov    %edx,%eax
  802494:	01 c0                	add    %eax,%eax
  802496:	01 d0                	add    %edx,%eax
  802498:	c1 e0 02             	shl    $0x2,%eax
  80249b:	05 60 40 80 00       	add    $0x804060,%eax
  8024a0:	a3 48 40 80 00       	mov    %eax,0x804048
  8024a5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8024a8:	89 d0                	mov    %edx,%eax
  8024aa:	01 c0                	add    %eax,%eax
  8024ac:	01 d0                	add    %edx,%eax
  8024ae:	c1 e0 02             	shl    $0x2,%eax
  8024b1:	05 60 40 80 00       	add    $0x804060,%eax
  8024b6:	a3 4c 40 80 00       	mov    %eax,0x80404c
  8024bb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8024be:	89 d0                	mov    %edx,%eax
  8024c0:	01 c0                	add    %eax,%eax
  8024c2:	01 d0                	add    %edx,%eax
  8024c4:	c1 e0 02             	shl    $0x2,%eax
  8024c7:	05 60 40 80 00       	add    $0x804060,%eax
  8024cc:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8024d2:	a1 54 40 80 00       	mov    0x804054,%eax
  8024d7:	40                   	inc    %eax
  8024d8:	a3 54 40 80 00       	mov    %eax,0x804054
	LIST_INIT(&freePagesList);

	// no.of pages in the dynamic allocator.
	int pCount = (daEnd - daStart) / PAGE_SIZE;
	// iterate over each page and init its data in pageBlockInfoArr and reset it.
	for (int i = 0; i < pCount; ++i) {
  8024dd:	ff 45 f4             	incl   -0xc(%ebp)
  8024e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024e3:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  8024e6:	0f 8c 2c ff ff ff    	jl     802418 <initialize_dynamic_allocator+0x79>
	    LIST_INSERT_TAIL(&freePagesList, &pageBlockInfoArr[i]);
	}
	// init the array of lists of each size..
	// 8 16 32 64 128 256 512 1024 2056
	// 0 1  2  3   4  5    6   7    8
	for (int i = 0; i <= (LOG2_MAX_SIZE - LOG2_MIN_SIZE); ++i){
  8024ec:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8024f3:	eb 36                	jmp    80252b <initialize_dynamic_allocator+0x18c>
		LIST_INIT(&freeBlockLists[i]);
  8024f5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024f8:	c1 e0 04             	shl    $0x4,%eax
  8024fb:	05 80 c0 81 00       	add    $0x81c080,%eax
  802500:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802506:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802509:	c1 e0 04             	shl    $0x4,%eax
  80250c:	05 84 c0 81 00       	add    $0x81c084,%eax
  802511:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802517:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80251a:	c1 e0 04             	shl    $0x4,%eax
  80251d:	05 8c c0 81 00       	add    $0x81c08c,%eax
  802522:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	    LIST_INSERT_TAIL(&freePagesList, &pageBlockInfoArr[i]);
	}
	// init the array of lists of each size..
	// 8 16 32 64 128 256 512 1024 2056
	// 0 1  2  3   4  5    6   7    8
	for (int i = 0; i <= (LOG2_MAX_SIZE - LOG2_MIN_SIZE); ++i){
  802528:	ff 45 f0             	incl   -0x10(%ebp)
  80252b:	83 7d f0 08          	cmpl   $0x8,-0x10(%ebp)
  80252f:	7e c4                	jle    8024f5 <initialize_dynamic_allocator+0x156>
		LIST_INIT(&freeBlockLists[i]);
	}
	//Comment the following line
	//panic("initialize_dynamic_allocator() Not implemented yet");

}
  802531:	90                   	nop
  802532:	c9                   	leave  
  802533:	c3                   	ret    

00802534 <get_block_size>:

//===========================
// [2] GET BLOCK SIZE:
//===========================
__inline__ uint32 get_block_size(void *va)
{
  802534:	55                   	push   %ebp
  802535:	89 e5                	mov    %esp,%ebp
  802537:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #2 get_block_size
	//Your code is here
	// get the page that saves this va
	struct PageInfoElement* ptr = to_page_info((uint32)va);
  80253a:	8b 45 08             	mov    0x8(%ebp),%eax
  80253d:	83 ec 0c             	sub    $0xc,%esp
  802540:	50                   	push   %eax
  802541:	e8 0b fe ff ff       	call   802351 <to_page_info>
  802546:	83 c4 10             	add    $0x10,%esp
  802549:	89 45 f4             	mov    %eax,-0xc(%ebp)
	return ptr->block_size;
  80254c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80254f:	8b 40 08             	mov    0x8(%eax),%eax
  802552:	0f b7 c0             	movzwl %ax,%eax
	//Comment the following line
	//panic("get_block_size() Not implemented yet");
}
  802555:	c9                   	leave  
  802556:	c3                   	ret    

00802557 <split_page_to_blocks>:
// =====================
// h) split page to blocks and add them in freeBlockLists
// =====================
// function that split the page provided into same sized blocks
//and putem in suitable freeblockList index according to size.
 void split_page_to_blocks(uint32 blk_size, struct PageInfoElement *pageInfo) {
  802557:	55                   	push   %ebp
  802558:	89 e5                	mov    %esp,%ebp
  80255a:	83 ec 28             	sub    $0x28,%esp
	 // cur page virtual address by the pageInfo.
	 uint32 page_va = (uint32)to_page_va(pageInfo);
  80255d:	83 ec 0c             	sub    $0xc,%esp
  802560:	ff 75 0c             	pushl  0xc(%ebp)
  802563:	e8 77 fd ff ff       	call   8022df <to_page_va>
  802568:	83 c4 10             	add    $0x10,%esp
  80256b:	89 45 e8             	mov    %eax,-0x18(%ebp)
	 // no. of blks to save in freeblockList.
	 int blk_count = PAGE_SIZE / blk_size;
  80256e:	b8 00 10 00 00       	mov    $0x1000,%eax
  802573:	ba 00 00 00 00       	mov    $0x0,%edx
  802578:	f7 75 08             	divl   0x8(%ebp)
  80257b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	 // save page in memory.
	 get_page((uint32*)page_va);
  80257e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802581:	83 ec 0c             	sub    $0xc,%esp
  802584:	50                   	push   %eax
  802585:	e8 48 f6 ff ff       	call   801bd2 <get_page>
  80258a:	83 c4 10             	add    $0x10,%esp
	 // assigning the pageInfo data block size, free block which is whole block count.
	 pageInfo->num_of_free_blocks = blk_count;
  80258d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802590:	8b 55 0c             	mov    0xc(%ebp),%edx
  802593:	66 89 42 0a          	mov    %ax,0xa(%edx)
	 pageInfo->block_size = blk_size;
  802597:	8b 45 08             	mov    0x8(%ebp),%eax
  80259a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80259d:	66 89 42 08          	mov    %ax,0x8(%edx)
	 // get index by size block in freeblocklist.
	 int idx = 0;
  8025a1:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	 for (int i = LOG2_MIN_SIZE; i <= LOG2_MAX_SIZE; i++) {
  8025a8:	c7 45 f0 03 00 00 00 	movl   $0x3,-0x10(%ebp)
  8025af:	eb 19                	jmp    8025ca <split_page_to_blocks+0x73>
	     if ((1 << i) == blk_size)
  8025b1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025b4:	ba 01 00 00 00       	mov    $0x1,%edx
  8025b9:	88 c1                	mov    %al,%cl
  8025bb:	d3 e2                	shl    %cl,%edx
  8025bd:	89 d0                	mov    %edx,%eax
  8025bf:	3b 45 08             	cmp    0x8(%ebp),%eax
  8025c2:	74 0e                	je     8025d2 <split_page_to_blocks+0x7b>
	         break;
	     idx++;
  8025c4:	ff 45 f4             	incl   -0xc(%ebp)
	 // assigning the pageInfo data block size, free block which is whole block count.
	 pageInfo->num_of_free_blocks = blk_count;
	 pageInfo->block_size = blk_size;
	 // get index by size block in freeblocklist.
	 int idx = 0;
	 for (int i = LOG2_MIN_SIZE; i <= LOG2_MAX_SIZE; i++) {
  8025c7:	ff 45 f0             	incl   -0x10(%ebp)
  8025ca:	83 7d f0 0b          	cmpl   $0xb,-0x10(%ebp)
  8025ce:	7e e1                	jle    8025b1 <split_page_to_blocks+0x5a>
  8025d0:	eb 01                	jmp    8025d3 <split_page_to_blocks+0x7c>
	     if ((1 << i) == blk_size)
	         break;
  8025d2:	90                   	nop
	     idx++;
	 }
	 // iterate over each blk and make and element of it by passing its address in blockElement pointer and save those in the list.
	 // starting from the page_va.
	 for (uint32 i = 0; i < blk_count; ++i) {
  8025d3:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  8025da:	e9 a7 00 00 00       	jmp    802686 <split_page_to_blocks+0x12f>
	     struct BlockElement *blk =(struct BlockElement*)(page_va + i * blk_size);
  8025df:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8025e2:	0f af 45 08          	imul   0x8(%ebp),%eax
  8025e6:	89 c2                	mov    %eax,%edx
  8025e8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8025eb:	01 d0                	add    %edx,%eax
  8025ed:	89 45 e0             	mov    %eax,-0x20(%ebp)
	     LIST_INSERT_TAIL(&freeBlockLists[idx],blk);
  8025f0:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8025f4:	75 14                	jne    80260a <split_page_to_blocks+0xb3>
  8025f6:	83 ec 04             	sub    $0x4,%esp
  8025f9:	68 90 3a 80 00       	push   $0x803a90
  8025fe:	6a 7c                	push   $0x7c
  802600:	68 17 3a 80 00       	push   $0x803a17
  802605:	e8 b9 e1 ff ff       	call   8007c3 <_panic>
  80260a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80260d:	c1 e0 04             	shl    $0x4,%eax
  802610:	05 84 c0 81 00       	add    $0x81c084,%eax
  802615:	8b 10                	mov    (%eax),%edx
  802617:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80261a:	89 50 04             	mov    %edx,0x4(%eax)
  80261d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802620:	8b 40 04             	mov    0x4(%eax),%eax
  802623:	85 c0                	test   %eax,%eax
  802625:	74 14                	je     80263b <split_page_to_blocks+0xe4>
  802627:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80262a:	c1 e0 04             	shl    $0x4,%eax
  80262d:	05 84 c0 81 00       	add    $0x81c084,%eax
  802632:	8b 00                	mov    (%eax),%eax
  802634:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802637:	89 10                	mov    %edx,(%eax)
  802639:	eb 11                	jmp    80264c <split_page_to_blocks+0xf5>
  80263b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80263e:	c1 e0 04             	shl    $0x4,%eax
  802641:	8d 90 80 c0 81 00    	lea    0x81c080(%eax),%edx
  802647:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80264a:	89 02                	mov    %eax,(%edx)
  80264c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80264f:	c1 e0 04             	shl    $0x4,%eax
  802652:	8d 90 84 c0 81 00    	lea    0x81c084(%eax),%edx
  802658:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80265b:	89 02                	mov    %eax,(%edx)
  80265d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802660:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802666:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802669:	c1 e0 04             	shl    $0x4,%eax
  80266c:	05 8c c0 81 00       	add    $0x81c08c,%eax
  802671:	8b 00                	mov    (%eax),%eax
  802673:	8d 50 01             	lea    0x1(%eax),%edx
  802676:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802679:	c1 e0 04             	shl    $0x4,%eax
  80267c:	05 8c c0 81 00       	add    $0x81c08c,%eax
  802681:	89 10                	mov    %edx,(%eax)
	         break;
	     idx++;
	 }
	 // iterate over each blk and make and element of it by passing its address in blockElement pointer and save those in the list.
	 // starting from the page_va.
	 for (uint32 i = 0; i < blk_count; ++i) {
  802683:	ff 45 ec             	incl   -0x14(%ebp)
  802686:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802689:	39 45 ec             	cmp    %eax,-0x14(%ebp)
  80268c:	0f 82 4d ff ff ff    	jb     8025df <split_page_to_blocks+0x88>
	     struct BlockElement *blk =(struct BlockElement*)(page_va + i * blk_size);
	     LIST_INSERT_TAIL(&freeBlockLists[idx],blk);
	 }
 }
  802692:	90                   	nop
  802693:	c9                   	leave  
  802694:	c3                   	ret    

00802695 <alloc_block>:

//===========================
// 3) ALLOCATE BLOCK:
//===========================
void *alloc_block(uint32 size)
{
  802695:	55                   	push   %ebp
  802696:	89 e5                	mov    %esp,%ebp
  802698:	83 ec 38             	sub    $0x38,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		assert(size <= DYN_ALLOC_MAX_BLOCK_SIZE);
  80269b:	81 7d 08 00 08 00 00 	cmpl   $0x800,0x8(%ebp)
  8026a2:	76 19                	jbe    8026bd <alloc_block+0x28>
  8026a4:	68 b4 3a 80 00       	push   $0x803ab4
  8026a9:	68 7a 3a 80 00       	push   $0x803a7a
  8026ae:	68 8a 00 00 00       	push   $0x8a
  8026b3:	68 17 3a 80 00       	push   $0x803a17
  8026b8:	e8 06 e1 ff ff       	call   8007c3 <_panic>
	//==================================================================================
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #3 alloc_block
	//Your code is here
	//Comment the following line
	// get index in freeBlockList by size.
	uint32 idx = 0;
  8026bd:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int i = LOG2_MIN_SIZE; i <= LOG2_MAX_SIZE; ++i){
  8026c4:	c7 45 f0 03 00 00 00 	movl   $0x3,-0x10(%ebp)
  8026cb:	eb 19                	jmp    8026e6 <alloc_block+0x51>
		if((1 << i) >= size) break;
  8026cd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8026d0:	ba 01 00 00 00       	mov    $0x1,%edx
  8026d5:	88 c1                	mov    %al,%cl
  8026d7:	d3 e2                	shl    %cl,%edx
  8026d9:	89 d0                	mov    %edx,%eax
  8026db:	3b 45 08             	cmp    0x8(%ebp),%eax
  8026de:	73 0e                	jae    8026ee <alloc_block+0x59>
		idx++;
  8026e0:	ff 45 f4             	incl   -0xc(%ebp)
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #3 alloc_block
	//Your code is here
	//Comment the following line
	// get index in freeBlockList by size.
	uint32 idx = 0;
	for (int i = LOG2_MIN_SIZE; i <= LOG2_MAX_SIZE; ++i){
  8026e3:	ff 45 f0             	incl   -0x10(%ebp)
  8026e6:	83 7d f0 0b          	cmpl   $0xb,-0x10(%ebp)
  8026ea:	7e e1                	jle    8026cd <alloc_block+0x38>
  8026ec:	eb 01                	jmp    8026ef <alloc_block+0x5a>
		if((1 << i) >= size) break;
  8026ee:	90                   	nop
		idx++;
	}

	//case 1: the free block of the cur size is available.
	if (freeBlockLists[idx].size > 0) {
  8026ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026f2:	c1 e0 04             	shl    $0x4,%eax
  8026f5:	05 8c c0 81 00       	add    $0x81c08c,%eax
  8026fa:	8b 00                	mov    (%eax),%eax
  8026fc:	85 c0                	test   %eax,%eax
  8026fe:	0f 84 df 00 00 00    	je     8027e3 <alloc_block+0x14e>

		// remove from the list and updat the pageInfoArr free blocks.
		// pop from the freeBlockList.
		struct BlockElement *blk = LIST_FIRST(&freeBlockLists[idx]);
  802704:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802707:	c1 e0 04             	shl    $0x4,%eax
  80270a:	05 80 c0 81 00       	add    $0x81c080,%eax
  80270f:	8b 00                	mov    (%eax),%eax
  802711:	89 45 ec             	mov    %eax,-0x14(%ebp)
	    LIST_REMOVE(&freeBlockLists[idx], blk);
  802714:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802718:	75 17                	jne    802731 <alloc_block+0x9c>
  80271a:	83 ec 04             	sub    $0x4,%esp
  80271d:	68 d5 3a 80 00       	push   $0x803ad5
  802722:	68 9e 00 00 00       	push   $0x9e
  802727:	68 17 3a 80 00       	push   $0x803a17
  80272c:	e8 92 e0 ff ff       	call   8007c3 <_panic>
  802731:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802734:	8b 00                	mov    (%eax),%eax
  802736:	85 c0                	test   %eax,%eax
  802738:	74 10                	je     80274a <alloc_block+0xb5>
  80273a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80273d:	8b 00                	mov    (%eax),%eax
  80273f:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802742:	8b 52 04             	mov    0x4(%edx),%edx
  802745:	89 50 04             	mov    %edx,0x4(%eax)
  802748:	eb 14                	jmp    80275e <alloc_block+0xc9>
  80274a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80274d:	8b 40 04             	mov    0x4(%eax),%eax
  802750:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802753:	c1 e2 04             	shl    $0x4,%edx
  802756:	81 c2 84 c0 81 00    	add    $0x81c084,%edx
  80275c:	89 02                	mov    %eax,(%edx)
  80275e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802761:	8b 40 04             	mov    0x4(%eax),%eax
  802764:	85 c0                	test   %eax,%eax
  802766:	74 0f                	je     802777 <alloc_block+0xe2>
  802768:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80276b:	8b 40 04             	mov    0x4(%eax),%eax
  80276e:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802771:	8b 12                	mov    (%edx),%edx
  802773:	89 10                	mov    %edx,(%eax)
  802775:	eb 13                	jmp    80278a <alloc_block+0xf5>
  802777:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80277a:	8b 00                	mov    (%eax),%eax
  80277c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80277f:	c1 e2 04             	shl    $0x4,%edx
  802782:	81 c2 80 c0 81 00    	add    $0x81c080,%edx
  802788:	89 02                	mov    %eax,(%edx)
  80278a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80278d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802793:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802796:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80279d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027a0:	c1 e0 04             	shl    $0x4,%eax
  8027a3:	05 8c c0 81 00       	add    $0x81c08c,%eax
  8027a8:	8b 00                	mov    (%eax),%eax
  8027aa:	8d 50 ff             	lea    -0x1(%eax),%edx
  8027ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027b0:	c1 e0 04             	shl    $0x4,%eax
  8027b3:	05 8c c0 81 00       	add    $0x81c08c,%eax
  8027b8:	89 10                	mov    %edx,(%eax)
	    // update pageBlockInfoArr
	    struct PageInfoElement *pageInfo = to_page_info((uint32)blk);
  8027ba:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8027bd:	83 ec 0c             	sub    $0xc,%esp
  8027c0:	50                   	push   %eax
  8027c1:	e8 8b fb ff ff       	call   802351 <to_page_info>
  8027c6:	83 c4 10             	add    $0x10,%esp
  8027c9:	89 45 e8             	mov    %eax,-0x18(%ebp)
	    pageInfo->num_of_free_blocks--;
  8027cc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8027cf:	66 8b 40 0a          	mov    0xa(%eax),%ax
  8027d3:	48                   	dec    %eax
  8027d4:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8027d7:	66 89 42 0a          	mov    %ax,0xa(%edx)
	    return blk;
  8027db:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8027de:	e9 bc 02 00 00       	jmp    802a9f <alloc_block+0x40a>
	}else{ //case(2, 3): 2. no free blocks available in the freeblocklist but there is free pages.
				//3. no free blocks and no available freepages so search in higher block sizes.
		// case 2:
		if(freePagesList.size > 0){ //have free pages.
  8027e3:	a1 54 40 80 00       	mov    0x804054,%eax
  8027e8:	85 c0                	test   %eax,%eax
  8027ea:	0f 84 7d 02 00 00    	je     802a6d <alloc_block+0x3d8>
			// get page to split and use from freepagesList.
			struct PageInfoElement *ptr_new_page = LIST_FIRST(&freePagesList);
  8027f0:	a1 48 40 80 00       	mov    0x804048,%eax
  8027f5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			LIST_REMOVE(&freePagesList, ptr_new_page);
  8027f8:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8027fc:	75 17                	jne    802815 <alloc_block+0x180>
  8027fe:	83 ec 04             	sub    $0x4,%esp
  802801:	68 d5 3a 80 00       	push   $0x803ad5
  802806:	68 a9 00 00 00       	push   $0xa9
  80280b:	68 17 3a 80 00       	push   $0x803a17
  802810:	e8 ae df ff ff       	call   8007c3 <_panic>
  802815:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802818:	8b 00                	mov    (%eax),%eax
  80281a:	85 c0                	test   %eax,%eax
  80281c:	74 10                	je     80282e <alloc_block+0x199>
  80281e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802821:	8b 00                	mov    (%eax),%eax
  802823:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802826:	8b 52 04             	mov    0x4(%edx),%edx
  802829:	89 50 04             	mov    %edx,0x4(%eax)
  80282c:	eb 0b                	jmp    802839 <alloc_block+0x1a4>
  80282e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802831:	8b 40 04             	mov    0x4(%eax),%eax
  802834:	a3 4c 40 80 00       	mov    %eax,0x80404c
  802839:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80283c:	8b 40 04             	mov    0x4(%eax),%eax
  80283f:	85 c0                	test   %eax,%eax
  802841:	74 0f                	je     802852 <alloc_block+0x1bd>
  802843:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802846:	8b 40 04             	mov    0x4(%eax),%eax
  802849:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80284c:	8b 12                	mov    (%edx),%edx
  80284e:	89 10                	mov    %edx,(%eax)
  802850:	eb 0a                	jmp    80285c <alloc_block+0x1c7>
  802852:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802855:	8b 00                	mov    (%eax),%eax
  802857:	a3 48 40 80 00       	mov    %eax,0x804048
  80285c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80285f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802865:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802868:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80286f:	a1 54 40 80 00       	mov    0x804054,%eax
  802874:	48                   	dec    %eax
  802875:	a3 54 40 80 00       	mov    %eax,0x804054
			// from page to freeblockList by the pageInfo and the block size.
			split_page_to_blocks(1 << (idx + LOG2_MIN_SIZE), ptr_new_page);
  80287a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80287d:	83 c0 03             	add    $0x3,%eax
  802880:	ba 01 00 00 00       	mov    $0x1,%edx
  802885:	88 c1                	mov    %al,%cl
  802887:	d3 e2                	shl    %cl,%edx
  802889:	89 d0                	mov    %edx,%eax
  80288b:	83 ec 08             	sub    $0x8,%esp
  80288e:	ff 75 e4             	pushl  -0x1c(%ebp)
  802891:	50                   	push   %eax
  802892:	e8 c0 fc ff ff       	call   802557 <split_page_to_blocks>
  802897:	83 c4 10             	add    $0x10,%esp

			// remove from the list and updat the pageInfoArr free blocks.
			// pop from the freeBlockList.
			struct BlockElement *blk = LIST_FIRST(&freeBlockLists[idx]);
  80289a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80289d:	c1 e0 04             	shl    $0x4,%eax
  8028a0:	05 80 c0 81 00       	add    $0x81c080,%eax
  8028a5:	8b 00                	mov    (%eax),%eax
  8028a7:	89 45 e0             	mov    %eax,-0x20(%ebp)
		    LIST_REMOVE(&freeBlockLists[idx], blk);
  8028aa:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8028ae:	75 17                	jne    8028c7 <alloc_block+0x232>
  8028b0:	83 ec 04             	sub    $0x4,%esp
  8028b3:	68 d5 3a 80 00       	push   $0x803ad5
  8028b8:	68 b0 00 00 00       	push   $0xb0
  8028bd:	68 17 3a 80 00       	push   $0x803a17
  8028c2:	e8 fc de ff ff       	call   8007c3 <_panic>
  8028c7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8028ca:	8b 00                	mov    (%eax),%eax
  8028cc:	85 c0                	test   %eax,%eax
  8028ce:	74 10                	je     8028e0 <alloc_block+0x24b>
  8028d0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8028d3:	8b 00                	mov    (%eax),%eax
  8028d5:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8028d8:	8b 52 04             	mov    0x4(%edx),%edx
  8028db:	89 50 04             	mov    %edx,0x4(%eax)
  8028de:	eb 14                	jmp    8028f4 <alloc_block+0x25f>
  8028e0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8028e3:	8b 40 04             	mov    0x4(%eax),%eax
  8028e6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8028e9:	c1 e2 04             	shl    $0x4,%edx
  8028ec:	81 c2 84 c0 81 00    	add    $0x81c084,%edx
  8028f2:	89 02                	mov    %eax,(%edx)
  8028f4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8028f7:	8b 40 04             	mov    0x4(%eax),%eax
  8028fa:	85 c0                	test   %eax,%eax
  8028fc:	74 0f                	je     80290d <alloc_block+0x278>
  8028fe:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802901:	8b 40 04             	mov    0x4(%eax),%eax
  802904:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802907:	8b 12                	mov    (%edx),%edx
  802909:	89 10                	mov    %edx,(%eax)
  80290b:	eb 13                	jmp    802920 <alloc_block+0x28b>
  80290d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802910:	8b 00                	mov    (%eax),%eax
  802912:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802915:	c1 e2 04             	shl    $0x4,%edx
  802918:	81 c2 80 c0 81 00    	add    $0x81c080,%edx
  80291e:	89 02                	mov    %eax,(%edx)
  802920:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802923:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802929:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80292c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802933:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802936:	c1 e0 04             	shl    $0x4,%eax
  802939:	05 8c c0 81 00       	add    $0x81c08c,%eax
  80293e:	8b 00                	mov    (%eax),%eax
  802940:	8d 50 ff             	lea    -0x1(%eax),%edx
  802943:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802946:	c1 e0 04             	shl    $0x4,%eax
  802949:	05 8c c0 81 00       	add    $0x81c08c,%eax
  80294e:	89 10                	mov    %edx,(%eax)
		    // update pageBlockInfoArr
		    struct PageInfoElement *pageInfo = to_page_info((uint32)blk);
  802950:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802953:	83 ec 0c             	sub    $0xc,%esp
  802956:	50                   	push   %eax
  802957:	e8 f5 f9 ff ff       	call   802351 <to_page_info>
  80295c:	83 c4 10             	add    $0x10,%esp
  80295f:	89 45 dc             	mov    %eax,-0x24(%ebp)
		    pageInfo->num_of_free_blocks--;
  802962:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802965:	66 8b 40 0a          	mov    0xa(%eax),%ax
  802969:	48                   	dec    %eax
  80296a:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80296d:	66 89 42 0a          	mov    %ax,0xa(%edx)
		    return blk;
  802971:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802974:	e9 26 01 00 00       	jmp    802a9f <alloc_block+0x40a>
		}else{//case 3: no free block and no free page so iterate and try to find bigger size.
			// iterate over the list until finding available block
			while (idx <= (LOG2_MAX_SIZE - LOG2_MIN_SIZE) && freeBlockLists[idx].size == 0) {
				idx++;
  802979:	ff 45 f4             	incl   -0xc(%ebp)
				// found free block
				if(freeBlockLists[idx].size > 0){
  80297c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80297f:	c1 e0 04             	shl    $0x4,%eax
  802982:	05 8c c0 81 00       	add    $0x81c08c,%eax
  802987:	8b 00                	mov    (%eax),%eax
  802989:	85 c0                	test   %eax,%eax
  80298b:	0f 84 dc 00 00 00    	je     802a6d <alloc_block+0x3d8>
					// remove from the list and updat the pageInfoArr free blocks.
					// pop from the freeBlockList.
					struct BlockElement *blk = LIST_FIRST(&freeBlockLists[idx]);
  802991:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802994:	c1 e0 04             	shl    $0x4,%eax
  802997:	05 80 c0 81 00       	add    $0x81c080,%eax
  80299c:	8b 00                	mov    (%eax),%eax
  80299e:	89 45 d8             	mov    %eax,-0x28(%ebp)
				    LIST_REMOVE(&freeBlockLists[idx], blk);
  8029a1:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8029a5:	75 17                	jne    8029be <alloc_block+0x329>
  8029a7:	83 ec 04             	sub    $0x4,%esp
  8029aa:	68 d5 3a 80 00       	push   $0x803ad5
  8029af:	68 be 00 00 00       	push   $0xbe
  8029b4:	68 17 3a 80 00       	push   $0x803a17
  8029b9:	e8 05 de ff ff       	call   8007c3 <_panic>
  8029be:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8029c1:	8b 00                	mov    (%eax),%eax
  8029c3:	85 c0                	test   %eax,%eax
  8029c5:	74 10                	je     8029d7 <alloc_block+0x342>
  8029c7:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8029ca:	8b 00                	mov    (%eax),%eax
  8029cc:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8029cf:	8b 52 04             	mov    0x4(%edx),%edx
  8029d2:	89 50 04             	mov    %edx,0x4(%eax)
  8029d5:	eb 14                	jmp    8029eb <alloc_block+0x356>
  8029d7:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8029da:	8b 40 04             	mov    0x4(%eax),%eax
  8029dd:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8029e0:	c1 e2 04             	shl    $0x4,%edx
  8029e3:	81 c2 84 c0 81 00    	add    $0x81c084,%edx
  8029e9:	89 02                	mov    %eax,(%edx)
  8029eb:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8029ee:	8b 40 04             	mov    0x4(%eax),%eax
  8029f1:	85 c0                	test   %eax,%eax
  8029f3:	74 0f                	je     802a04 <alloc_block+0x36f>
  8029f5:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8029f8:	8b 40 04             	mov    0x4(%eax),%eax
  8029fb:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8029fe:	8b 12                	mov    (%edx),%edx
  802a00:	89 10                	mov    %edx,(%eax)
  802a02:	eb 13                	jmp    802a17 <alloc_block+0x382>
  802a04:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802a07:	8b 00                	mov    (%eax),%eax
  802a09:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802a0c:	c1 e2 04             	shl    $0x4,%edx
  802a0f:	81 c2 80 c0 81 00    	add    $0x81c080,%edx
  802a15:	89 02                	mov    %eax,(%edx)
  802a17:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802a1a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802a20:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802a23:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802a2a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a2d:	c1 e0 04             	shl    $0x4,%eax
  802a30:	05 8c c0 81 00       	add    $0x81c08c,%eax
  802a35:	8b 00                	mov    (%eax),%eax
  802a37:	8d 50 ff             	lea    -0x1(%eax),%edx
  802a3a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a3d:	c1 e0 04             	shl    $0x4,%eax
  802a40:	05 8c c0 81 00       	add    $0x81c08c,%eax
  802a45:	89 10                	mov    %edx,(%eax)
				    // update pageBlockInfoArr
				    struct PageInfoElement *pageInfo = to_page_info((uint32)blk);
  802a47:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802a4a:	83 ec 0c             	sub    $0xc,%esp
  802a4d:	50                   	push   %eax
  802a4e:	e8 fe f8 ff ff       	call   802351 <to_page_info>
  802a53:	83 c4 10             	add    $0x10,%esp
  802a56:	89 45 d4             	mov    %eax,-0x2c(%ebp)
				    pageInfo->num_of_free_blocks--;
  802a59:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802a5c:	66 8b 40 0a          	mov    0xa(%eax),%ax
  802a60:	48                   	dec    %eax
  802a61:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  802a64:	66 89 42 0a          	mov    %ax,0xa(%edx)
				    return blk;
  802a68:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802a6b:	eb 32                	jmp    802a9f <alloc_block+0x40a>
		    struct PageInfoElement *pageInfo = to_page_info((uint32)blk);
		    pageInfo->num_of_free_blocks--;
		    return blk;
		}else{//case 3: no free block and no free page so iterate and try to find bigger size.
			// iterate over the list until finding available block
			while (idx <= (LOG2_MAX_SIZE - LOG2_MIN_SIZE) && freeBlockLists[idx].size == 0) {
  802a6d:	83 7d f4 08          	cmpl   $0x8,-0xc(%ebp)
  802a71:	77 15                	ja     802a88 <alloc_block+0x3f3>
  802a73:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a76:	c1 e0 04             	shl    $0x4,%eax
  802a79:	05 8c c0 81 00       	add    $0x81c08c,%eax
  802a7e:	8b 00                	mov    (%eax),%eax
  802a80:	85 c0                	test   %eax,%eax
  802a82:	0f 84 f1 fe ff ff    	je     802979 <alloc_block+0x2e4>
				}
			}
		}
	}
	//case4: no free blocks or pages.
	panic("no free blocks!");
  802a88:	83 ec 04             	sub    $0x4,%esp
  802a8b:	68 f3 3a 80 00       	push   $0x803af3
  802a90:	68 c8 00 00 00       	push   $0xc8
  802a95:	68 17 3a 80 00       	push   $0x803a17
  802a9a:	e8 24 dd ff ff       	call   8007c3 <_panic>
	//panic("alloc_block() Not implemented yet");
	//TODO: [PROJECT'25.BONUS#1] DYNAMIC ALLOCATOR - block if no free block
	return NULL;
}
  802a9f:	c9                   	leave  
  802aa0:	c3                   	ret    

00802aa1 <free_block>:

//===========================
// [4] FREE BLOCK:
//===========================
void free_block(void *va)
{
  802aa1:	55                   	push   %ebp
  802aa2:	89 e5                	mov    %esp,%ebp
  802aa4:	83 ec 38             	sub    $0x38,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		assert((uint32)va >= dynAllocStart && (uint32)va < dynAllocEnd);
  802aa7:	8b 55 08             	mov    0x8(%ebp),%edx
  802aaa:	a1 64 c0 81 00       	mov    0x81c064,%eax
  802aaf:	39 c2                	cmp    %eax,%edx
  802ab1:	72 0c                	jb     802abf <free_block+0x1e>
  802ab3:	8b 55 08             	mov    0x8(%ebp),%edx
  802ab6:	a1 40 40 80 00       	mov    0x804040,%eax
  802abb:	39 c2                	cmp    %eax,%edx
  802abd:	72 19                	jb     802ad8 <free_block+0x37>
  802abf:	68 04 3b 80 00       	push   $0x803b04
  802ac4:	68 7a 3a 80 00       	push   $0x803a7a
  802ac9:	68 d7 00 00 00       	push   $0xd7
  802ace:	68 17 3a 80 00       	push   $0x803a17
  802ad3:	e8 eb dc ff ff       	call   8007c3 <_panic>
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #4 free_block
	//Your code is here
	//Comment the following line
	// va of a piece in memory to free so:
	// 1. get its page, and make blk with this address to be put in the freeBlockList.
	struct BlockElement* blk_to_free = (struct BlockElement*)va;
  802ad8:	8b 45 08             	mov    0x8(%ebp),%eax
  802adb:	89 45 e8             	mov    %eax,-0x18(%ebp)
	struct PageInfoElement *pageInfo = to_page_info((uint32)va);
  802ade:	8b 45 08             	mov    0x8(%ebp),%eax
  802ae1:	83 ec 0c             	sub    $0xc,%esp
  802ae4:	50                   	push   %eax
  802ae5:	e8 67 f8 ff ff       	call   802351 <to_page_info>
  802aea:	83 c4 10             	add    $0x10,%esp
  802aed:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	uint32 blk_size = pageInfo->block_size;
  802af0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802af3:	8b 40 08             	mov    0x8(%eax),%eax
  802af6:	0f b7 c0             	movzwl %ax,%eax
  802af9:	89 45 e0             	mov    %eax,-0x20(%ebp)

	// its index in the freeBlocklist.
	int idx = 0;
  802afc:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int i = LOG2_MIN_SIZE; i <= LOG2_MAX_SIZE; i++) {
  802b03:	c7 45 f0 03 00 00 00 	movl   $0x3,-0x10(%ebp)
  802b0a:	eb 19                	jmp    802b25 <free_block+0x84>
	    if ((1 << i) == blk_size)
  802b0c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b0f:	ba 01 00 00 00       	mov    $0x1,%edx
  802b14:	88 c1                	mov    %al,%cl
  802b16:	d3 e2                	shl    %cl,%edx
  802b18:	89 d0                	mov    %edx,%eax
  802b1a:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  802b1d:	74 0e                	je     802b2d <free_block+0x8c>
	        break;
	    idx++;
  802b1f:	ff 45 f4             	incl   -0xc(%ebp)
	struct PageInfoElement *pageInfo = to_page_info((uint32)va);
	uint32 blk_size = pageInfo->block_size;

	// its index in the freeBlocklist.
	int idx = 0;
	for (int i = LOG2_MIN_SIZE; i <= LOG2_MAX_SIZE; i++) {
  802b22:	ff 45 f0             	incl   -0x10(%ebp)
  802b25:	83 7d f0 0b          	cmpl   $0xb,-0x10(%ebp)
  802b29:	7e e1                	jle    802b0c <free_block+0x6b>
  802b2b:	eb 01                	jmp    802b2e <free_block+0x8d>
	    if ((1 << i) == blk_size)
	        break;
  802b2d:	90                   	nop
	    idx++;
	}

	pageInfo->num_of_free_blocks++;
  802b2e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802b31:	66 8b 40 0a          	mov    0xa(%eax),%ax
  802b35:	40                   	inc    %eax
  802b36:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802b39:	66 89 42 0a          	mov    %ax,0xa(%edx)
	LIST_INSERT_TAIL(&freeBlockLists[idx], blk_to_free);
  802b3d:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802b41:	75 17                	jne    802b5a <free_block+0xb9>
  802b43:	83 ec 04             	sub    $0x4,%esp
  802b46:	68 90 3a 80 00       	push   $0x803a90
  802b4b:	68 ee 00 00 00       	push   $0xee
  802b50:	68 17 3a 80 00       	push   $0x803a17
  802b55:	e8 69 dc ff ff       	call   8007c3 <_panic>
  802b5a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b5d:	c1 e0 04             	shl    $0x4,%eax
  802b60:	05 84 c0 81 00       	add    $0x81c084,%eax
  802b65:	8b 10                	mov    (%eax),%edx
  802b67:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802b6a:	89 50 04             	mov    %edx,0x4(%eax)
  802b6d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802b70:	8b 40 04             	mov    0x4(%eax),%eax
  802b73:	85 c0                	test   %eax,%eax
  802b75:	74 14                	je     802b8b <free_block+0xea>
  802b77:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b7a:	c1 e0 04             	shl    $0x4,%eax
  802b7d:	05 84 c0 81 00       	add    $0x81c084,%eax
  802b82:	8b 00                	mov    (%eax),%eax
  802b84:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802b87:	89 10                	mov    %edx,(%eax)
  802b89:	eb 11                	jmp    802b9c <free_block+0xfb>
  802b8b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b8e:	c1 e0 04             	shl    $0x4,%eax
  802b91:	8d 90 80 c0 81 00    	lea    0x81c080(%eax),%edx
  802b97:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802b9a:	89 02                	mov    %eax,(%edx)
  802b9c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b9f:	c1 e0 04             	shl    $0x4,%eax
  802ba2:	8d 90 84 c0 81 00    	lea    0x81c084(%eax),%edx
  802ba8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802bab:	89 02                	mov    %eax,(%edx)
  802bad:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802bb0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802bb6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bb9:	c1 e0 04             	shl    $0x4,%eax
  802bbc:	05 8c c0 81 00       	add    $0x81c08c,%eax
  802bc1:	8b 00                	mov    (%eax),%eax
  802bc3:	8d 50 01             	lea    0x1(%eax),%edx
  802bc6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bc9:	c1 e0 04             	shl    $0x4,%eax
  802bcc:	05 8c c0 81 00       	add    $0x81c08c,%eax
  802bd1:	89 10                	mov    %edx,(%eax)

	// now, case 1: the page all blocks are freed so you free the page.
	int blk_count = PAGE_SIZE / blk_size;
  802bd3:	b8 00 10 00 00       	mov    $0x1000,%eax
  802bd8:	ba 00 00 00 00       	mov    $0x0,%edx
  802bdd:	f7 75 e0             	divl   -0x20(%ebp)
  802be0:	89 45 dc             	mov    %eax,-0x24(%ebp)
	// the blk count in the page is same as number fo free blocks free up the page.
	if (pageInfo->num_of_free_blocks == blk_count) {
  802be3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802be6:	66 8b 40 0a          	mov    0xa(%eax),%ax
  802bea:	0f b7 c0             	movzwl %ax,%eax
  802bed:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  802bf0:	0f 85 70 01 00 00    	jne    802d66 <free_block+0x2c5>
		uint32 page_va = to_page_va(pageInfo);
  802bf6:	83 ec 0c             	sub    $0xc,%esp
  802bf9:	ff 75 e4             	pushl  -0x1c(%ebp)
  802bfc:	e8 de f6 ff ff       	call   8022df <to_page_va>
  802c01:	83 c4 10             	add    $0x10,%esp
  802c04:	89 45 d8             	mov    %eax,-0x28(%ebp)
		// remove all blk in the freeBlockList.
		for (uint32 off = 0; off < PAGE_SIZE; off += blk_size) {
  802c07:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  802c0e:	e9 b7 00 00 00       	jmp    802cca <free_block+0x229>
			struct BlockElement *blk = (struct BlockElement*)(page_va + off);
  802c13:	8b 55 d8             	mov    -0x28(%ebp),%edx
  802c16:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c19:	01 d0                	add    %edx,%eax
  802c1b:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			LIST_REMOVE(&freeBlockLists[idx], blk);
  802c1e:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  802c22:	75 17                	jne    802c3b <free_block+0x19a>
  802c24:	83 ec 04             	sub    $0x4,%esp
  802c27:	68 d5 3a 80 00       	push   $0x803ad5
  802c2c:	68 f8 00 00 00       	push   $0xf8
  802c31:	68 17 3a 80 00       	push   $0x803a17
  802c36:	e8 88 db ff ff       	call   8007c3 <_panic>
  802c3b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802c3e:	8b 00                	mov    (%eax),%eax
  802c40:	85 c0                	test   %eax,%eax
  802c42:	74 10                	je     802c54 <free_block+0x1b3>
  802c44:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802c47:	8b 00                	mov    (%eax),%eax
  802c49:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  802c4c:	8b 52 04             	mov    0x4(%edx),%edx
  802c4f:	89 50 04             	mov    %edx,0x4(%eax)
  802c52:	eb 14                	jmp    802c68 <free_block+0x1c7>
  802c54:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802c57:	8b 40 04             	mov    0x4(%eax),%eax
  802c5a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802c5d:	c1 e2 04             	shl    $0x4,%edx
  802c60:	81 c2 84 c0 81 00    	add    $0x81c084,%edx
  802c66:	89 02                	mov    %eax,(%edx)
  802c68:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802c6b:	8b 40 04             	mov    0x4(%eax),%eax
  802c6e:	85 c0                	test   %eax,%eax
  802c70:	74 0f                	je     802c81 <free_block+0x1e0>
  802c72:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802c75:	8b 40 04             	mov    0x4(%eax),%eax
  802c78:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  802c7b:	8b 12                	mov    (%edx),%edx
  802c7d:	89 10                	mov    %edx,(%eax)
  802c7f:	eb 13                	jmp    802c94 <free_block+0x1f3>
  802c81:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802c84:	8b 00                	mov    (%eax),%eax
  802c86:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802c89:	c1 e2 04             	shl    $0x4,%edx
  802c8c:	81 c2 80 c0 81 00    	add    $0x81c080,%edx
  802c92:	89 02                	mov    %eax,(%edx)
  802c94:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802c97:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802c9d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802ca0:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802ca7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802caa:	c1 e0 04             	shl    $0x4,%eax
  802cad:	05 8c c0 81 00       	add    $0x81c08c,%eax
  802cb2:	8b 00                	mov    (%eax),%eax
  802cb4:	8d 50 ff             	lea    -0x1(%eax),%edx
  802cb7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cba:	c1 e0 04             	shl    $0x4,%eax
  802cbd:	05 8c c0 81 00       	add    $0x81c08c,%eax
  802cc2:	89 10                	mov    %edx,(%eax)
	int blk_count = PAGE_SIZE / blk_size;
	// the blk count in the page is same as number fo free blocks free up the page.
	if (pageInfo->num_of_free_blocks == blk_count) {
		uint32 page_va = to_page_va(pageInfo);
		// remove all blk in the freeBlockList.
		for (uint32 off = 0; off < PAGE_SIZE; off += blk_size) {
  802cc4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802cc7:	01 45 ec             	add    %eax,-0x14(%ebp)
  802cca:	81 7d ec ff 0f 00 00 	cmpl   $0xfff,-0x14(%ebp)
  802cd1:	0f 86 3c ff ff ff    	jbe    802c13 <free_block+0x172>
			struct BlockElement *blk = (struct BlockElement*)(page_va + off);
			LIST_REMOVE(&freeBlockLists[idx], blk);
		}
		// reset page info.
		pageInfo->block_size = 0;
  802cd7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802cda:	66 c7 40 08 00 00    	movw   $0x0,0x8(%eax)
		pageInfo->num_of_free_blocks = 0;
  802ce0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802ce3:	66 c7 40 0a 00 00    	movw   $0x0,0xa(%eax)
		// add it to the available pages.
		LIST_INSERT_TAIL(&freePagesList, pageInfo);
  802ce9:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  802ced:	75 17                	jne    802d06 <free_block+0x265>
  802cef:	83 ec 04             	sub    $0x4,%esp
  802cf2:	68 90 3a 80 00       	push   $0x803a90
  802cf7:	68 fe 00 00 00       	push   $0xfe
  802cfc:	68 17 3a 80 00       	push   $0x803a17
  802d01:	e8 bd da ff ff       	call   8007c3 <_panic>
  802d06:	8b 15 4c 40 80 00    	mov    0x80404c,%edx
  802d0c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802d0f:	89 50 04             	mov    %edx,0x4(%eax)
  802d12:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802d15:	8b 40 04             	mov    0x4(%eax),%eax
  802d18:	85 c0                	test   %eax,%eax
  802d1a:	74 0c                	je     802d28 <free_block+0x287>
  802d1c:	a1 4c 40 80 00       	mov    0x80404c,%eax
  802d21:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802d24:	89 10                	mov    %edx,(%eax)
  802d26:	eb 08                	jmp    802d30 <free_block+0x28f>
  802d28:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802d2b:	a3 48 40 80 00       	mov    %eax,0x804048
  802d30:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802d33:	a3 4c 40 80 00       	mov    %eax,0x80404c
  802d38:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802d3b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802d41:	a1 54 40 80 00       	mov    0x804054,%eax
  802d46:	40                   	inc    %eax
  802d47:	a3 54 40 80 00       	mov    %eax,0x804054
		// make it available in memory.
		return_page((uint32 *)to_page_va(pageInfo));
  802d4c:	83 ec 0c             	sub    $0xc,%esp
  802d4f:	ff 75 e4             	pushl  -0x1c(%ebp)
  802d52:	e8 88 f5 ff ff       	call   8022df <to_page_va>
  802d57:	83 c4 10             	add    $0x10,%esp
  802d5a:	83 ec 0c             	sub    $0xc,%esp
  802d5d:	50                   	push   %eax
  802d5e:	e8 b8 ee ff ff       	call   801c1b <return_page>
  802d63:	83 c4 10             	add    $0x10,%esp
	}
	//panic("free_block() Not implemented yet");
}
  802d66:	90                   	nop
  802d67:	c9                   	leave  
  802d68:	c3                   	ret    

00802d69 <realloc_block>:

//===========================
// [1] REALLOCATE BLOCK:
//===========================
void *realloc_block(void* va, uint32 new_size)
{
  802d69:	55                   	push   %ebp
  802d6a:	89 e5                	mov    %esp,%ebp
  802d6c:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.BONUS#2] KERNEL REALLOC - realloc_block
	//Your code is here
	//Comment the following line
	panic("realloc_block() Not implemented yet");
  802d6f:	83 ec 04             	sub    $0x4,%esp
  802d72:	68 3c 3b 80 00       	push   $0x803b3c
  802d77:	68 11 01 00 00       	push   $0x111
  802d7c:	68 17 3a 80 00       	push   $0x803a17
  802d81:	e8 3d da ff ff       	call   8007c3 <_panic>
  802d86:	66 90                	xchg   %ax,%ax

00802d88 <__udivdi3>:
  802d88:	55                   	push   %ebp
  802d89:	57                   	push   %edi
  802d8a:	56                   	push   %esi
  802d8b:	53                   	push   %ebx
  802d8c:	83 ec 1c             	sub    $0x1c,%esp
  802d8f:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  802d93:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  802d97:	8b 7c 24 38          	mov    0x38(%esp),%edi
  802d9b:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802d9f:	89 ca                	mov    %ecx,%edx
  802da1:	89 f8                	mov    %edi,%eax
  802da3:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  802da7:	85 f6                	test   %esi,%esi
  802da9:	75 2d                	jne    802dd8 <__udivdi3+0x50>
  802dab:	39 cf                	cmp    %ecx,%edi
  802dad:	77 65                	ja     802e14 <__udivdi3+0x8c>
  802daf:	89 fd                	mov    %edi,%ebp
  802db1:	85 ff                	test   %edi,%edi
  802db3:	75 0b                	jne    802dc0 <__udivdi3+0x38>
  802db5:	b8 01 00 00 00       	mov    $0x1,%eax
  802dba:	31 d2                	xor    %edx,%edx
  802dbc:	f7 f7                	div    %edi
  802dbe:	89 c5                	mov    %eax,%ebp
  802dc0:	31 d2                	xor    %edx,%edx
  802dc2:	89 c8                	mov    %ecx,%eax
  802dc4:	f7 f5                	div    %ebp
  802dc6:	89 c1                	mov    %eax,%ecx
  802dc8:	89 d8                	mov    %ebx,%eax
  802dca:	f7 f5                	div    %ebp
  802dcc:	89 cf                	mov    %ecx,%edi
  802dce:	89 fa                	mov    %edi,%edx
  802dd0:	83 c4 1c             	add    $0x1c,%esp
  802dd3:	5b                   	pop    %ebx
  802dd4:	5e                   	pop    %esi
  802dd5:	5f                   	pop    %edi
  802dd6:	5d                   	pop    %ebp
  802dd7:	c3                   	ret    
  802dd8:	39 ce                	cmp    %ecx,%esi
  802dda:	77 28                	ja     802e04 <__udivdi3+0x7c>
  802ddc:	0f bd fe             	bsr    %esi,%edi
  802ddf:	83 f7 1f             	xor    $0x1f,%edi
  802de2:	75 40                	jne    802e24 <__udivdi3+0x9c>
  802de4:	39 ce                	cmp    %ecx,%esi
  802de6:	72 0a                	jb     802df2 <__udivdi3+0x6a>
  802de8:	3b 44 24 08          	cmp    0x8(%esp),%eax
  802dec:	0f 87 9e 00 00 00    	ja     802e90 <__udivdi3+0x108>
  802df2:	b8 01 00 00 00       	mov    $0x1,%eax
  802df7:	89 fa                	mov    %edi,%edx
  802df9:	83 c4 1c             	add    $0x1c,%esp
  802dfc:	5b                   	pop    %ebx
  802dfd:	5e                   	pop    %esi
  802dfe:	5f                   	pop    %edi
  802dff:	5d                   	pop    %ebp
  802e00:	c3                   	ret    
  802e01:	8d 76 00             	lea    0x0(%esi),%esi
  802e04:	31 ff                	xor    %edi,%edi
  802e06:	31 c0                	xor    %eax,%eax
  802e08:	89 fa                	mov    %edi,%edx
  802e0a:	83 c4 1c             	add    $0x1c,%esp
  802e0d:	5b                   	pop    %ebx
  802e0e:	5e                   	pop    %esi
  802e0f:	5f                   	pop    %edi
  802e10:	5d                   	pop    %ebp
  802e11:	c3                   	ret    
  802e12:	66 90                	xchg   %ax,%ax
  802e14:	89 d8                	mov    %ebx,%eax
  802e16:	f7 f7                	div    %edi
  802e18:	31 ff                	xor    %edi,%edi
  802e1a:	89 fa                	mov    %edi,%edx
  802e1c:	83 c4 1c             	add    $0x1c,%esp
  802e1f:	5b                   	pop    %ebx
  802e20:	5e                   	pop    %esi
  802e21:	5f                   	pop    %edi
  802e22:	5d                   	pop    %ebp
  802e23:	c3                   	ret    
  802e24:	bd 20 00 00 00       	mov    $0x20,%ebp
  802e29:	89 eb                	mov    %ebp,%ebx
  802e2b:	29 fb                	sub    %edi,%ebx
  802e2d:	89 f9                	mov    %edi,%ecx
  802e2f:	d3 e6                	shl    %cl,%esi
  802e31:	89 c5                	mov    %eax,%ebp
  802e33:	88 d9                	mov    %bl,%cl
  802e35:	d3 ed                	shr    %cl,%ebp
  802e37:	89 e9                	mov    %ebp,%ecx
  802e39:	09 f1                	or     %esi,%ecx
  802e3b:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  802e3f:	89 f9                	mov    %edi,%ecx
  802e41:	d3 e0                	shl    %cl,%eax
  802e43:	89 c5                	mov    %eax,%ebp
  802e45:	89 d6                	mov    %edx,%esi
  802e47:	88 d9                	mov    %bl,%cl
  802e49:	d3 ee                	shr    %cl,%esi
  802e4b:	89 f9                	mov    %edi,%ecx
  802e4d:	d3 e2                	shl    %cl,%edx
  802e4f:	8b 44 24 08          	mov    0x8(%esp),%eax
  802e53:	88 d9                	mov    %bl,%cl
  802e55:	d3 e8                	shr    %cl,%eax
  802e57:	09 c2                	or     %eax,%edx
  802e59:	89 d0                	mov    %edx,%eax
  802e5b:	89 f2                	mov    %esi,%edx
  802e5d:	f7 74 24 0c          	divl   0xc(%esp)
  802e61:	89 d6                	mov    %edx,%esi
  802e63:	89 c3                	mov    %eax,%ebx
  802e65:	f7 e5                	mul    %ebp
  802e67:	39 d6                	cmp    %edx,%esi
  802e69:	72 19                	jb     802e84 <__udivdi3+0xfc>
  802e6b:	74 0b                	je     802e78 <__udivdi3+0xf0>
  802e6d:	89 d8                	mov    %ebx,%eax
  802e6f:	31 ff                	xor    %edi,%edi
  802e71:	e9 58 ff ff ff       	jmp    802dce <__udivdi3+0x46>
  802e76:	66 90                	xchg   %ax,%ax
  802e78:	8b 54 24 08          	mov    0x8(%esp),%edx
  802e7c:	89 f9                	mov    %edi,%ecx
  802e7e:	d3 e2                	shl    %cl,%edx
  802e80:	39 c2                	cmp    %eax,%edx
  802e82:	73 e9                	jae    802e6d <__udivdi3+0xe5>
  802e84:	8d 43 ff             	lea    -0x1(%ebx),%eax
  802e87:	31 ff                	xor    %edi,%edi
  802e89:	e9 40 ff ff ff       	jmp    802dce <__udivdi3+0x46>
  802e8e:	66 90                	xchg   %ax,%ax
  802e90:	31 c0                	xor    %eax,%eax
  802e92:	e9 37 ff ff ff       	jmp    802dce <__udivdi3+0x46>
  802e97:	90                   	nop

00802e98 <__umoddi3>:
  802e98:	55                   	push   %ebp
  802e99:	57                   	push   %edi
  802e9a:	56                   	push   %esi
  802e9b:	53                   	push   %ebx
  802e9c:	83 ec 1c             	sub    $0x1c,%esp
  802e9f:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  802ea3:	8b 74 24 34          	mov    0x34(%esp),%esi
  802ea7:	8b 7c 24 38          	mov    0x38(%esp),%edi
  802eab:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  802eaf:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802eb3:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802eb7:	89 f3                	mov    %esi,%ebx
  802eb9:	89 fa                	mov    %edi,%edx
  802ebb:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  802ebf:	89 34 24             	mov    %esi,(%esp)
  802ec2:	85 c0                	test   %eax,%eax
  802ec4:	75 1a                	jne    802ee0 <__umoddi3+0x48>
  802ec6:	39 f7                	cmp    %esi,%edi
  802ec8:	0f 86 a2 00 00 00    	jbe    802f70 <__umoddi3+0xd8>
  802ece:	89 c8                	mov    %ecx,%eax
  802ed0:	89 f2                	mov    %esi,%edx
  802ed2:	f7 f7                	div    %edi
  802ed4:	89 d0                	mov    %edx,%eax
  802ed6:	31 d2                	xor    %edx,%edx
  802ed8:	83 c4 1c             	add    $0x1c,%esp
  802edb:	5b                   	pop    %ebx
  802edc:	5e                   	pop    %esi
  802edd:	5f                   	pop    %edi
  802ede:	5d                   	pop    %ebp
  802edf:	c3                   	ret    
  802ee0:	39 f0                	cmp    %esi,%eax
  802ee2:	0f 87 ac 00 00 00    	ja     802f94 <__umoddi3+0xfc>
  802ee8:	0f bd e8             	bsr    %eax,%ebp
  802eeb:	83 f5 1f             	xor    $0x1f,%ebp
  802eee:	0f 84 ac 00 00 00    	je     802fa0 <__umoddi3+0x108>
  802ef4:	bf 20 00 00 00       	mov    $0x20,%edi
  802ef9:	29 ef                	sub    %ebp,%edi
  802efb:	89 fe                	mov    %edi,%esi
  802efd:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802f01:	89 e9                	mov    %ebp,%ecx
  802f03:	d3 e0                	shl    %cl,%eax
  802f05:	89 d7                	mov    %edx,%edi
  802f07:	89 f1                	mov    %esi,%ecx
  802f09:	d3 ef                	shr    %cl,%edi
  802f0b:	09 c7                	or     %eax,%edi
  802f0d:	89 e9                	mov    %ebp,%ecx
  802f0f:	d3 e2                	shl    %cl,%edx
  802f11:	89 14 24             	mov    %edx,(%esp)
  802f14:	89 d8                	mov    %ebx,%eax
  802f16:	d3 e0                	shl    %cl,%eax
  802f18:	89 c2                	mov    %eax,%edx
  802f1a:	8b 44 24 08          	mov    0x8(%esp),%eax
  802f1e:	d3 e0                	shl    %cl,%eax
  802f20:	89 44 24 04          	mov    %eax,0x4(%esp)
  802f24:	8b 44 24 08          	mov    0x8(%esp),%eax
  802f28:	89 f1                	mov    %esi,%ecx
  802f2a:	d3 e8                	shr    %cl,%eax
  802f2c:	09 d0                	or     %edx,%eax
  802f2e:	d3 eb                	shr    %cl,%ebx
  802f30:	89 da                	mov    %ebx,%edx
  802f32:	f7 f7                	div    %edi
  802f34:	89 d3                	mov    %edx,%ebx
  802f36:	f7 24 24             	mull   (%esp)
  802f39:	89 c6                	mov    %eax,%esi
  802f3b:	89 d1                	mov    %edx,%ecx
  802f3d:	39 d3                	cmp    %edx,%ebx
  802f3f:	0f 82 87 00 00 00    	jb     802fcc <__umoddi3+0x134>
  802f45:	0f 84 91 00 00 00    	je     802fdc <__umoddi3+0x144>
  802f4b:	8b 54 24 04          	mov    0x4(%esp),%edx
  802f4f:	29 f2                	sub    %esi,%edx
  802f51:	19 cb                	sbb    %ecx,%ebx
  802f53:	89 d8                	mov    %ebx,%eax
  802f55:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  802f59:	d3 e0                	shl    %cl,%eax
  802f5b:	89 e9                	mov    %ebp,%ecx
  802f5d:	d3 ea                	shr    %cl,%edx
  802f5f:	09 d0                	or     %edx,%eax
  802f61:	89 e9                	mov    %ebp,%ecx
  802f63:	d3 eb                	shr    %cl,%ebx
  802f65:	89 da                	mov    %ebx,%edx
  802f67:	83 c4 1c             	add    $0x1c,%esp
  802f6a:	5b                   	pop    %ebx
  802f6b:	5e                   	pop    %esi
  802f6c:	5f                   	pop    %edi
  802f6d:	5d                   	pop    %ebp
  802f6e:	c3                   	ret    
  802f6f:	90                   	nop
  802f70:	89 fd                	mov    %edi,%ebp
  802f72:	85 ff                	test   %edi,%edi
  802f74:	75 0b                	jne    802f81 <__umoddi3+0xe9>
  802f76:	b8 01 00 00 00       	mov    $0x1,%eax
  802f7b:	31 d2                	xor    %edx,%edx
  802f7d:	f7 f7                	div    %edi
  802f7f:	89 c5                	mov    %eax,%ebp
  802f81:	89 f0                	mov    %esi,%eax
  802f83:	31 d2                	xor    %edx,%edx
  802f85:	f7 f5                	div    %ebp
  802f87:	89 c8                	mov    %ecx,%eax
  802f89:	f7 f5                	div    %ebp
  802f8b:	89 d0                	mov    %edx,%eax
  802f8d:	e9 44 ff ff ff       	jmp    802ed6 <__umoddi3+0x3e>
  802f92:	66 90                	xchg   %ax,%ax
  802f94:	89 c8                	mov    %ecx,%eax
  802f96:	89 f2                	mov    %esi,%edx
  802f98:	83 c4 1c             	add    $0x1c,%esp
  802f9b:	5b                   	pop    %ebx
  802f9c:	5e                   	pop    %esi
  802f9d:	5f                   	pop    %edi
  802f9e:	5d                   	pop    %ebp
  802f9f:	c3                   	ret    
  802fa0:	3b 04 24             	cmp    (%esp),%eax
  802fa3:	72 06                	jb     802fab <__umoddi3+0x113>
  802fa5:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  802fa9:	77 0f                	ja     802fba <__umoddi3+0x122>
  802fab:	89 f2                	mov    %esi,%edx
  802fad:	29 f9                	sub    %edi,%ecx
  802faf:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  802fb3:	89 14 24             	mov    %edx,(%esp)
  802fb6:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  802fba:	8b 44 24 04          	mov    0x4(%esp),%eax
  802fbe:	8b 14 24             	mov    (%esp),%edx
  802fc1:	83 c4 1c             	add    $0x1c,%esp
  802fc4:	5b                   	pop    %ebx
  802fc5:	5e                   	pop    %esi
  802fc6:	5f                   	pop    %edi
  802fc7:	5d                   	pop    %ebp
  802fc8:	c3                   	ret    
  802fc9:	8d 76 00             	lea    0x0(%esi),%esi
  802fcc:	2b 04 24             	sub    (%esp),%eax
  802fcf:	19 fa                	sbb    %edi,%edx
  802fd1:	89 d1                	mov    %edx,%ecx
  802fd3:	89 c6                	mov    %eax,%esi
  802fd5:	e9 71 ff ff ff       	jmp    802f4b <__umoddi3+0xb3>
  802fda:	66 90                	xchg   %ax,%ax
  802fdc:	39 44 24 04          	cmp    %eax,0x4(%esp)
  802fe0:	72 ea                	jb     802fcc <__umoddi3+0x134>
  802fe2:	89 d9                	mov    %ebx,%ecx
  802fe4:	e9 62 ff ff ff       	jmp    802f4b <__umoddi3+0xb3>
