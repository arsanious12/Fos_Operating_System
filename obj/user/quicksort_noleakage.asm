
obj/user/quicksort_noleakage:     file format elf32-i386


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
  800031:	e8 d6 05 00 00       	call   80060c <libmain>
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
  800041:	e8 6c 1d 00 00       	call   801db2 <sys_lock_cons>
		{
			cprintf("\n");
  800046:	83 ec 0c             	sub    $0xc,%esp
  800049:	68 00 30 80 00       	push   $0x803000
  80004e:	e8 4c 0a 00 00       	call   800a9f <cprintf>
  800053:	83 c4 10             	add    $0x10,%esp
			cprintf("!!!!!!!!!!!!!!!!!!!!!!!\n");
  800056:	83 ec 0c             	sub    $0xc,%esp
  800059:	68 02 30 80 00       	push   $0x803002
  80005e:	e8 3c 0a 00 00       	call   800a9f <cprintf>
  800063:	83 c4 10             	add    $0x10,%esp
			cprintf("!!!   QUICK SORT    !!!\n");
  800066:	83 ec 0c             	sub    $0xc,%esp
  800069:	68 1b 30 80 00       	push   $0x80301b
  80006e:	e8 2c 0a 00 00       	call   800a9f <cprintf>
  800073:	83 c4 10             	add    $0x10,%esp
			cprintf("!!!!!!!!!!!!!!!!!!!!!!!\n");
  800076:	83 ec 0c             	sub    $0xc,%esp
  800079:	68 02 30 80 00       	push   $0x803002
  80007e:	e8 1c 0a 00 00       	call   800a9f <cprintf>
  800083:	83 c4 10             	add    $0x10,%esp
			cprintf("\n");
  800086:	83 ec 0c             	sub    $0xc,%esp
  800089:	68 00 30 80 00       	push   $0x803000
  80008e:	e8 0c 0a 00 00       	call   800a9f <cprintf>
  800093:	83 c4 10             	add    $0x10,%esp

			readline("Enter the number of elements: ", Line);
  800096:	83 ec 08             	sub    $0x8,%esp
  800099:	8d 85 e9 fe ff ff    	lea    -0x117(%ebp),%eax
  80009f:	50                   	push   %eax
  8000a0:	68 34 30 80 00       	push   $0x803034
  8000a5:	e8 ce 10 00 00       	call   801178 <readline>
  8000aa:	83 c4 10             	add    $0x10,%esp
			NumOfElements = strtol(Line, NULL, 10) ;
  8000ad:	83 ec 04             	sub    $0x4,%esp
  8000b0:	6a 0a                	push   $0xa
  8000b2:	6a 00                	push   $0x0
  8000b4:	8d 85 e9 fe ff ff    	lea    -0x117(%ebp),%eax
  8000ba:	50                   	push   %eax
  8000bb:	e8 cf 16 00 00       	call   80178f <strtol>
  8000c0:	83 c4 10             	add    $0x10,%esp
  8000c3:	89 45 f0             	mov    %eax,-0x10(%ebp)
			cprintf("Chose the initialization method:\n") ;
  8000c6:	83 ec 0c             	sub    $0xc,%esp
  8000c9:	68 54 30 80 00       	push   $0x803054
  8000ce:	e8 cc 09 00 00       	call   800a9f <cprintf>
  8000d3:	83 c4 10             	add    $0x10,%esp
			cprintf("a) Ascending\n") ;
  8000d6:	83 ec 0c             	sub    $0xc,%esp
  8000d9:	68 76 30 80 00       	push   $0x803076
  8000de:	e8 bc 09 00 00       	call   800a9f <cprintf>
  8000e3:	83 c4 10             	add    $0x10,%esp
			cprintf("b) Descending\n") ;
  8000e6:	83 ec 0c             	sub    $0xc,%esp
  8000e9:	68 84 30 80 00       	push   $0x803084
  8000ee:	e8 ac 09 00 00       	call   800a9f <cprintf>
  8000f3:	83 c4 10             	add    $0x10,%esp
			cprintf("c) Semi random\n");
  8000f6:	83 ec 0c             	sub    $0xc,%esp
  8000f9:	68 93 30 80 00       	push   $0x803093
  8000fe:	e8 9c 09 00 00       	call   800a9f <cprintf>
  800103:	83 c4 10             	add    $0x10,%esp
			do
			{
				cprintf("Select: ") ;
  800106:	83 ec 0c             	sub    $0xc,%esp
  800109:	68 a3 30 80 00       	push   $0x8030a3
  80010e:	e8 8c 09 00 00       	call   800a9f <cprintf>
  800113:	83 c4 10             	add    $0x10,%esp
				Chose = getchar() ;
  800116:	e8 d4 04 00 00       	call   8005ef <getchar>
  80011b:	88 45 f7             	mov    %al,-0x9(%ebp)
				cputchar(Chose);
  80011e:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  800122:	83 ec 0c             	sub    $0xc,%esp
  800125:	50                   	push   %eax
  800126:	e8 a5 04 00 00       	call   8005d0 <cputchar>
  80012b:	83 c4 10             	add    $0x10,%esp
				cputchar('\n');
  80012e:	83 ec 0c             	sub    $0xc,%esp
  800131:	6a 0a                	push   $0xa
  800133:	e8 98 04 00 00       	call   8005d0 <cputchar>
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
  80014d:	e8 7a 1c 00 00       	call   801dcc <sys_unlock_cons>
		//sys_unlock_cons();

		Elements = malloc(sizeof(int) * NumOfElements) ;
  800152:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800155:	c1 e0 02             	shl    $0x2,%eax
  800158:	83 ec 0c             	sub    $0xc,%esp
  80015b:	50                   	push   %eax
  80015c:	e8 08 1b 00 00       	call   801c69 <malloc>
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
  800183:	e8 03 03 00 00       	call   80048b <InitializeAscending>
  800188:	83 c4 10             	add    $0x10,%esp
			break ;
  80018b:	eb 37                	jmp    8001c4 <_main+0x18c>
		case 'b':
			InitializeDescending(Elements, NumOfElements);
  80018d:	83 ec 08             	sub    $0x8,%esp
  800190:	ff 75 f0             	pushl  -0x10(%ebp)
  800193:	ff 75 ec             	pushl  -0x14(%ebp)
  800196:	e8 21 03 00 00       	call   8004bc <InitializeDescending>
  80019b:	83 c4 10             	add    $0x10,%esp
			break ;
  80019e:	eb 24                	jmp    8001c4 <_main+0x18c>
		case 'c':
			InitializeSemiRandom(Elements, NumOfElements);
  8001a0:	83 ec 08             	sub    $0x8,%esp
  8001a3:	ff 75 f0             	pushl  -0x10(%ebp)
  8001a6:	ff 75 ec             	pushl  -0x14(%ebp)
  8001a9:	e8 43 03 00 00       	call   8004f1 <InitializeSemiRandom>
  8001ae:	83 c4 10             	add    $0x10,%esp
			break ;
  8001b1:	eb 11                	jmp    8001c4 <_main+0x18c>
		default:
			InitializeSemiRandom(Elements, NumOfElements);
  8001b3:	83 ec 08             	sub    $0x8,%esp
  8001b6:	ff 75 f0             	pushl  -0x10(%ebp)
  8001b9:	ff 75 ec             	pushl  -0x14(%ebp)
  8001bc:	e8 30 03 00 00       	call   8004f1 <InitializeSemiRandom>
  8001c1:	83 c4 10             	add    $0x10,%esp
		}

		QuickSort(Elements, NumOfElements);
  8001c4:	83 ec 08             	sub    $0x8,%esp
  8001c7:	ff 75 f0             	pushl  -0x10(%ebp)
  8001ca:	ff 75 ec             	pushl  -0x14(%ebp)
  8001cd:	e8 fe 00 00 00       	call   8002d0 <QuickSort>
  8001d2:	83 c4 10             	add    $0x10,%esp

		//sys_lock_cons();
		sys_lock_cons();
  8001d5:	e8 d8 1b 00 00       	call   801db2 <sys_lock_cons>
		{
			cprintf("Sorting is Finished!!!!it'll be checked now....\n") ;
  8001da:	83 ec 0c             	sub    $0xc,%esp
  8001dd:	68 ac 30 80 00       	push   $0x8030ac
  8001e2:	e8 b8 08 00 00       	call   800a9f <cprintf>
  8001e7:	83 c4 10             	add    $0x10,%esp
			//		PrintElements(Elements, NumOfElements);
		}
		sys_unlock_cons();
  8001ea:	e8 dd 1b 00 00       	call   801dcc <sys_unlock_cons>
		//sys_unlock_cons();

		uint32 Sorted = CheckSorted(Elements, NumOfElements);
  8001ef:	83 ec 08             	sub    $0x8,%esp
  8001f2:	ff 75 f0             	pushl  -0x10(%ebp)
  8001f5:	ff 75 ec             	pushl  -0x14(%ebp)
  8001f8:	e8 e4 01 00 00       	call   8003e1 <CheckSorted>
  8001fd:	83 c4 10             	add    $0x10,%esp
  800200:	89 45 e8             	mov    %eax,-0x18(%ebp)

		if(Sorted == 0) panic("The array is NOT sorted correctly") ;
  800203:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  800207:	75 14                	jne    80021d <_main+0x1e5>
  800209:	83 ec 04             	sub    $0x4,%esp
  80020c:	68 e0 30 80 00       	push   $0x8030e0
  800211:	6a 54                	push   $0x54
  800213:	68 02 31 80 00       	push   $0x803102
  800218:	e8 b4 05 00 00       	call   8007d1 <_panic>
		else
		{
			//			sys_lock_cons();
			sys_lock_cons();
  80021d:	e8 90 1b 00 00       	call   801db2 <sys_lock_cons>
			{
				cprintf("===============================================\n") ;
  800222:	83 ec 0c             	sub    $0xc,%esp
  800225:	68 20 31 80 00       	push   $0x803120
  80022a:	e8 70 08 00 00       	call   800a9f <cprintf>
  80022f:	83 c4 10             	add    $0x10,%esp
				cprintf("Congratulations!! The array is sorted correctly\n") ;
  800232:	83 ec 0c             	sub    $0xc,%esp
  800235:	68 54 31 80 00       	push   $0x803154
  80023a:	e8 60 08 00 00       	call   800a9f <cprintf>
  80023f:	83 c4 10             	add    $0x10,%esp
				cprintf("===============================================\n\n") ;
  800242:	83 ec 0c             	sub    $0xc,%esp
  800245:	68 88 31 80 00       	push   $0x803188
  80024a:	e8 50 08 00 00       	call   800a9f <cprintf>
  80024f:	83 c4 10             	add    $0x10,%esp
			}
			sys_unlock_cons();
  800252:	e8 75 1b 00 00       	call   801dcc <sys_unlock_cons>
			//			sys_unlock_cons();


		}

		free(Elements) ;
  800257:	83 ec 0c             	sub    $0xc,%esp
  80025a:	ff 75 ec             	pushl  -0x14(%ebp)
  80025d:	e8 35 1a 00 00       	call   801c97 <free>
  800262:	83 c4 10             	add    $0x10,%esp

		//		sys_lock_cons();
		sys_lock_cons();
  800265:	e8 48 1b 00 00       	call   801db2 <sys_lock_cons>
		{
			Chose = 0 ;
  80026a:	c6 45 f7 00          	movb   $0x0,-0x9(%ebp)
			while (Chose != 'y' && Chose != 'n')
  80026e:	eb 42                	jmp    8002b2 <_main+0x27a>
			{
				cprintf("Do you want to repeat (y/n): ") ;
  800270:	83 ec 0c             	sub    $0xc,%esp
  800273:	68 ba 31 80 00       	push   $0x8031ba
  800278:	e8 22 08 00 00       	call   800a9f <cprintf>
  80027d:	83 c4 10             	add    $0x10,%esp
				Chose = getchar() ;
  800280:	e8 6a 03 00 00       	call   8005ef <getchar>
  800285:	88 45 f7             	mov    %al,-0x9(%ebp)
				cputchar(Chose);
  800288:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  80028c:	83 ec 0c             	sub    $0xc,%esp
  80028f:	50                   	push   %eax
  800290:	e8 3b 03 00 00       	call   8005d0 <cputchar>
  800295:	83 c4 10             	add    $0x10,%esp
				cputchar('\n');
  800298:	83 ec 0c             	sub    $0xc,%esp
  80029b:	6a 0a                	push   $0xa
  80029d:	e8 2e 03 00 00       	call   8005d0 <cputchar>
  8002a2:	83 c4 10             	add    $0x10,%esp
				cputchar('\n');
  8002a5:	83 ec 0c             	sub    $0xc,%esp
  8002a8:	6a 0a                	push   $0xa
  8002aa:	e8 21 03 00 00       	call   8005d0 <cputchar>
  8002af:	83 c4 10             	add    $0x10,%esp

		//		sys_lock_cons();
		sys_lock_cons();
		{
			Chose = 0 ;
			while (Chose != 'y' && Chose != 'n')
  8002b2:	80 7d f7 79          	cmpb   $0x79,-0x9(%ebp)
  8002b6:	74 06                	je     8002be <_main+0x286>
  8002b8:	80 7d f7 6e          	cmpb   $0x6e,-0x9(%ebp)
  8002bc:	75 b2                	jne    800270 <_main+0x238>
				cputchar(Chose);
				cputchar('\n');
				cputchar('\n');
			}
		}
		sys_unlock_cons();
  8002be:	e8 09 1b 00 00       	call   801dcc <sys_unlock_cons>
		//		sys_unlock_cons();

	} while (Chose == 'y');
  8002c3:	80 7d f7 79          	cmpb   $0x79,-0x9(%ebp)
  8002c7:	0f 84 74 fd ff ff    	je     800041 <_main+0x9>

}
  8002cd:	90                   	nop
  8002ce:	c9                   	leave  
  8002cf:	c3                   	ret    

008002d0 <QuickSort>:

///Quick sort
void QuickSort(int *Elements, int NumOfElements)
{
  8002d0:	55                   	push   %ebp
  8002d1:	89 e5                	mov    %esp,%ebp
  8002d3:	83 ec 08             	sub    $0x8,%esp
	QSort(Elements, NumOfElements, 0, NumOfElements-1) ;
  8002d6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8002d9:	48                   	dec    %eax
  8002da:	50                   	push   %eax
  8002db:	6a 00                	push   $0x0
  8002dd:	ff 75 0c             	pushl  0xc(%ebp)
  8002e0:	ff 75 08             	pushl  0x8(%ebp)
  8002e3:	e8 06 00 00 00       	call   8002ee <QSort>
  8002e8:	83 c4 10             	add    $0x10,%esp
}
  8002eb:	90                   	nop
  8002ec:	c9                   	leave  
  8002ed:	c3                   	ret    

008002ee <QSort>:


void QSort(int *Elements,int NumOfElements, int startIndex, int finalIndex)
{
  8002ee:	55                   	push   %ebp
  8002ef:	89 e5                	mov    %esp,%ebp
  8002f1:	83 ec 18             	sub    $0x18,%esp
	if (startIndex >= finalIndex) return;
  8002f4:	8b 45 10             	mov    0x10(%ebp),%eax
  8002f7:	3b 45 14             	cmp    0x14(%ebp),%eax
  8002fa:	0f 8d de 00 00 00    	jge    8003de <QSort+0xf0>

	int i = startIndex+1, j = finalIndex;
  800300:	8b 45 10             	mov    0x10(%ebp),%eax
  800303:	40                   	inc    %eax
  800304:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800307:	8b 45 14             	mov    0x14(%ebp),%eax
  80030a:	89 45 f0             	mov    %eax,-0x10(%ebp)

	while (i <= j)
  80030d:	e9 80 00 00 00       	jmp    800392 <QSort+0xa4>
	{
		while (i <= finalIndex && Elements[startIndex] >= Elements[i]) i++;
  800312:	ff 45 f4             	incl   -0xc(%ebp)
  800315:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800318:	3b 45 14             	cmp    0x14(%ebp),%eax
  80031b:	7f 2b                	jg     800348 <QSort+0x5a>
  80031d:	8b 45 10             	mov    0x10(%ebp),%eax
  800320:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800327:	8b 45 08             	mov    0x8(%ebp),%eax
  80032a:	01 d0                	add    %edx,%eax
  80032c:	8b 10                	mov    (%eax),%edx
  80032e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800331:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800338:	8b 45 08             	mov    0x8(%ebp),%eax
  80033b:	01 c8                	add    %ecx,%eax
  80033d:	8b 00                	mov    (%eax),%eax
  80033f:	39 c2                	cmp    %eax,%edx
  800341:	7d cf                	jge    800312 <QSort+0x24>
		while (j > startIndex && Elements[startIndex] <= Elements[j]) j--;
  800343:	eb 03                	jmp    800348 <QSort+0x5a>
  800345:	ff 4d f0             	decl   -0x10(%ebp)
  800348:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80034b:	3b 45 10             	cmp    0x10(%ebp),%eax
  80034e:	7e 26                	jle    800376 <QSort+0x88>
  800350:	8b 45 10             	mov    0x10(%ebp),%eax
  800353:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80035a:	8b 45 08             	mov    0x8(%ebp),%eax
  80035d:	01 d0                	add    %edx,%eax
  80035f:	8b 10                	mov    (%eax),%edx
  800361:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800364:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  80036b:	8b 45 08             	mov    0x8(%ebp),%eax
  80036e:	01 c8                	add    %ecx,%eax
  800370:	8b 00                	mov    (%eax),%eax
  800372:	39 c2                	cmp    %eax,%edx
  800374:	7e cf                	jle    800345 <QSort+0x57>

		if (i <= j)
  800376:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800379:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80037c:	7f 14                	jg     800392 <QSort+0xa4>
		{
			Swap(Elements, i, j);
  80037e:	83 ec 04             	sub    $0x4,%esp
  800381:	ff 75 f0             	pushl  -0x10(%ebp)
  800384:	ff 75 f4             	pushl  -0xc(%ebp)
  800387:	ff 75 08             	pushl  0x8(%ebp)
  80038a:	e8 a9 00 00 00       	call   800438 <Swap>
  80038f:	83 c4 10             	add    $0x10,%esp
{
	if (startIndex >= finalIndex) return;

	int i = startIndex+1, j = finalIndex;

	while (i <= j)
  800392:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800395:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800398:	0f 8e 77 ff ff ff    	jle    800315 <QSort+0x27>
		{
			Swap(Elements, i, j);
		}
	}

	Swap( Elements, startIndex, j);
  80039e:	83 ec 04             	sub    $0x4,%esp
  8003a1:	ff 75 f0             	pushl  -0x10(%ebp)
  8003a4:	ff 75 10             	pushl  0x10(%ebp)
  8003a7:	ff 75 08             	pushl  0x8(%ebp)
  8003aa:	e8 89 00 00 00       	call   800438 <Swap>
  8003af:	83 c4 10             	add    $0x10,%esp

	QSort(Elements, NumOfElements, startIndex, j - 1);
  8003b2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8003b5:	48                   	dec    %eax
  8003b6:	50                   	push   %eax
  8003b7:	ff 75 10             	pushl  0x10(%ebp)
  8003ba:	ff 75 0c             	pushl  0xc(%ebp)
  8003bd:	ff 75 08             	pushl  0x8(%ebp)
  8003c0:	e8 29 ff ff ff       	call   8002ee <QSort>
  8003c5:	83 c4 10             	add    $0x10,%esp
	QSort(Elements, NumOfElements, i, finalIndex);
  8003c8:	ff 75 14             	pushl  0x14(%ebp)
  8003cb:	ff 75 f4             	pushl  -0xc(%ebp)
  8003ce:	ff 75 0c             	pushl  0xc(%ebp)
  8003d1:	ff 75 08             	pushl  0x8(%ebp)
  8003d4:	e8 15 ff ff ff       	call   8002ee <QSort>
  8003d9:	83 c4 10             	add    $0x10,%esp
  8003dc:	eb 01                	jmp    8003df <QSort+0xf1>
}


void QSort(int *Elements,int NumOfElements, int startIndex, int finalIndex)
{
	if (startIndex >= finalIndex) return;
  8003de:	90                   	nop
	QSort(Elements, NumOfElements, startIndex, j - 1);
	QSort(Elements, NumOfElements, i, finalIndex);

	//cprintf("qs,after sorting: start = %d, end = %d\n", startIndex, finalIndex);

}
  8003df:	c9                   	leave  
  8003e0:	c3                   	ret    

008003e1 <CheckSorted>:

uint32 CheckSorted(int *Elements, int NumOfElements)
{
  8003e1:	55                   	push   %ebp
  8003e2:	89 e5                	mov    %esp,%ebp
  8003e4:	83 ec 10             	sub    $0x10,%esp
	uint32 Sorted = 1 ;
  8003e7:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
	int i ;
	for (i = 0 ; i < NumOfElements - 1; i++)
  8003ee:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8003f5:	eb 33                	jmp    80042a <CheckSorted+0x49>
	{
		if (Elements[i] > Elements[i+1])
  8003f7:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8003fa:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800401:	8b 45 08             	mov    0x8(%ebp),%eax
  800404:	01 d0                	add    %edx,%eax
  800406:	8b 10                	mov    (%eax),%edx
  800408:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80040b:	40                   	inc    %eax
  80040c:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800413:	8b 45 08             	mov    0x8(%ebp),%eax
  800416:	01 c8                	add    %ecx,%eax
  800418:	8b 00                	mov    (%eax),%eax
  80041a:	39 c2                	cmp    %eax,%edx
  80041c:	7e 09                	jle    800427 <CheckSorted+0x46>
		{
			Sorted = 0 ;
  80041e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
			break;
  800425:	eb 0c                	jmp    800433 <CheckSorted+0x52>

uint32 CheckSorted(int *Elements, int NumOfElements)
{
	uint32 Sorted = 1 ;
	int i ;
	for (i = 0 ; i < NumOfElements - 1; i++)
  800427:	ff 45 f8             	incl   -0x8(%ebp)
  80042a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80042d:	48                   	dec    %eax
  80042e:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800431:	7f c4                	jg     8003f7 <CheckSorted+0x16>
		{
			Sorted = 0 ;
			break;
		}
	}
	return Sorted ;
  800433:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800436:	c9                   	leave  
  800437:	c3                   	ret    

00800438 <Swap>:

///Private Functions


void Swap(int *Elements, int First, int Second)
{
  800438:	55                   	push   %ebp
  800439:	89 e5                	mov    %esp,%ebp
  80043b:	83 ec 10             	sub    $0x10,%esp
	int Tmp = Elements[First] ;
  80043e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800441:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800448:	8b 45 08             	mov    0x8(%ebp),%eax
  80044b:	01 d0                	add    %edx,%eax
  80044d:	8b 00                	mov    (%eax),%eax
  80044f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	Elements[First] = Elements[Second] ;
  800452:	8b 45 0c             	mov    0xc(%ebp),%eax
  800455:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80045c:	8b 45 08             	mov    0x8(%ebp),%eax
  80045f:	01 c2                	add    %eax,%edx
  800461:	8b 45 10             	mov    0x10(%ebp),%eax
  800464:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  80046b:	8b 45 08             	mov    0x8(%ebp),%eax
  80046e:	01 c8                	add    %ecx,%eax
  800470:	8b 00                	mov    (%eax),%eax
  800472:	89 02                	mov    %eax,(%edx)
	Elements[Second] = Tmp ;
  800474:	8b 45 10             	mov    0x10(%ebp),%eax
  800477:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80047e:	8b 45 08             	mov    0x8(%ebp),%eax
  800481:	01 c2                	add    %eax,%edx
  800483:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800486:	89 02                	mov    %eax,(%edx)
}
  800488:	90                   	nop
  800489:	c9                   	leave  
  80048a:	c3                   	ret    

0080048b <InitializeAscending>:

void InitializeAscending(int *Elements, int NumOfElements)
{
  80048b:	55                   	push   %ebp
  80048c:	89 e5                	mov    %esp,%ebp
  80048e:	83 ec 10             	sub    $0x10,%esp
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  800491:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800498:	eb 17                	jmp    8004b1 <InitializeAscending+0x26>
	{
		(Elements)[i] = i ;
  80049a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80049d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8004a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8004a7:	01 c2                	add    %eax,%edx
  8004a9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8004ac:	89 02                	mov    %eax,(%edx)
}

void InitializeAscending(int *Elements, int NumOfElements)
{
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  8004ae:	ff 45 fc             	incl   -0x4(%ebp)
  8004b1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8004b4:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8004b7:	7c e1                	jl     80049a <InitializeAscending+0xf>
	{
		(Elements)[i] = i ;
	}

}
  8004b9:	90                   	nop
  8004ba:	c9                   	leave  
  8004bb:	c3                   	ret    

008004bc <InitializeDescending>:

void InitializeDescending(int *Elements, int NumOfElements)
{
  8004bc:	55                   	push   %ebp
  8004bd:	89 e5                	mov    %esp,%ebp
  8004bf:	83 ec 10             	sub    $0x10,%esp
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  8004c2:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8004c9:	eb 1b                	jmp    8004e6 <InitializeDescending+0x2a>
	{
		Elements[i] = NumOfElements - i - 1 ;
  8004cb:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8004ce:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8004d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8004d8:	01 c2                	add    %eax,%edx
  8004da:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004dd:	2b 45 fc             	sub    -0x4(%ebp),%eax
  8004e0:	48                   	dec    %eax
  8004e1:	89 02                	mov    %eax,(%edx)
}

void InitializeDescending(int *Elements, int NumOfElements)
{
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  8004e3:	ff 45 fc             	incl   -0x4(%ebp)
  8004e6:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8004e9:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8004ec:	7c dd                	jl     8004cb <InitializeDescending+0xf>
	{
		Elements[i] = NumOfElements - i - 1 ;
	}

}
  8004ee:	90                   	nop
  8004ef:	c9                   	leave  
  8004f0:	c3                   	ret    

008004f1 <InitializeSemiRandom>:

void InitializeSemiRandom(int *Elements, int NumOfElements)
{
  8004f1:	55                   	push   %ebp
  8004f2:	89 e5                	mov    %esp,%ebp
  8004f4:	83 ec 10             	sub    $0x10,%esp
	int i ;
	int Repetition = NumOfElements / 3 ;
  8004f7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8004fa:	b8 56 55 55 55       	mov    $0x55555556,%eax
  8004ff:	f7 e9                	imul   %ecx
  800501:	c1 f9 1f             	sar    $0x1f,%ecx
  800504:	89 d0                	mov    %edx,%eax
  800506:	29 c8                	sub    %ecx,%eax
  800508:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (Repetition == 0)
  80050b:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  80050f:	75 07                	jne    800518 <InitializeSemiRandom+0x27>
		Repetition = 3;
  800511:	c7 45 f8 03 00 00 00 	movl   $0x3,-0x8(%ebp)
	for (i = 0 ; i < NumOfElements ; i++)
  800518:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80051f:	eb 1e                	jmp    80053f <InitializeSemiRandom+0x4e>
	{
		Elements[i] = i % Repetition ;
  800521:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800524:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80052b:	8b 45 08             	mov    0x8(%ebp),%eax
  80052e:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  800531:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800534:	99                   	cltd   
  800535:	f7 7d f8             	idivl  -0x8(%ebp)
  800538:	89 d0                	mov    %edx,%eax
  80053a:	89 01                	mov    %eax,(%ecx)
{
	int i ;
	int Repetition = NumOfElements / 3 ;
	if (Repetition == 0)
		Repetition = 3;
	for (i = 0 ; i < NumOfElements ; i++)
  80053c:	ff 45 fc             	incl   -0x4(%ebp)
  80053f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800542:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800545:	7c da                	jl     800521 <InitializeSemiRandom+0x30>
	{
		Elements[i] = i % Repetition ;
		//	cprintf("i=%d\n",i);
	}

}
  800547:	90                   	nop
  800548:	c9                   	leave  
  800549:	c3                   	ret    

0080054a <PrintElements>:

void PrintElements(int *Elements, int NumOfElements)
{
  80054a:	55                   	push   %ebp
  80054b:	89 e5                	mov    %esp,%ebp
  80054d:	83 ec 18             	sub    $0x18,%esp
	int i ;
	int NumsPerLine = 20 ;
  800550:	c7 45 f0 14 00 00 00 	movl   $0x14,-0x10(%ebp)
	for (i = 0 ; i < NumOfElements-1 ; i++)
  800557:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  80055e:	eb 42                	jmp    8005a2 <PrintElements+0x58>
	{
		if (i%NumsPerLine == 0)
  800560:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800563:	99                   	cltd   
  800564:	f7 7d f0             	idivl  -0x10(%ebp)
  800567:	89 d0                	mov    %edx,%eax
  800569:	85 c0                	test   %eax,%eax
  80056b:	75 10                	jne    80057d <PrintElements+0x33>
			cprintf("\n");
  80056d:	83 ec 0c             	sub    $0xc,%esp
  800570:	68 00 30 80 00       	push   $0x803000
  800575:	e8 25 05 00 00       	call   800a9f <cprintf>
  80057a:	83 c4 10             	add    $0x10,%esp
		cprintf("%d, ",Elements[i]);
  80057d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800580:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800587:	8b 45 08             	mov    0x8(%ebp),%eax
  80058a:	01 d0                	add    %edx,%eax
  80058c:	8b 00                	mov    (%eax),%eax
  80058e:	83 ec 08             	sub    $0x8,%esp
  800591:	50                   	push   %eax
  800592:	68 d8 31 80 00       	push   $0x8031d8
  800597:	e8 03 05 00 00       	call   800a9f <cprintf>
  80059c:	83 c4 10             	add    $0x10,%esp

void PrintElements(int *Elements, int NumOfElements)
{
	int i ;
	int NumsPerLine = 20 ;
	for (i = 0 ; i < NumOfElements-1 ; i++)
  80059f:	ff 45 f4             	incl   -0xc(%ebp)
  8005a2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8005a5:	48                   	dec    %eax
  8005a6:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8005a9:	7f b5                	jg     800560 <PrintElements+0x16>
	{
		if (i%NumsPerLine == 0)
			cprintf("\n");
		cprintf("%d, ",Elements[i]);
	}
	cprintf("%d\n",Elements[i]);
  8005ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8005ae:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8005b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8005b8:	01 d0                	add    %edx,%eax
  8005ba:	8b 00                	mov    (%eax),%eax
  8005bc:	83 ec 08             	sub    $0x8,%esp
  8005bf:	50                   	push   %eax
  8005c0:	68 dd 31 80 00       	push   $0x8031dd
  8005c5:	e8 d5 04 00 00       	call   800a9f <cprintf>
  8005ca:	83 c4 10             	add    $0x10,%esp

}
  8005cd:	90                   	nop
  8005ce:	c9                   	leave  
  8005cf:	c3                   	ret    

008005d0 <cputchar>:
#include <inc/lib.h>


void
cputchar(int ch)
{
  8005d0:	55                   	push   %ebp
  8005d1:	89 e5                	mov    %esp,%ebp
  8005d3:	83 ec 18             	sub    $0x18,%esp
	char c = ch;
  8005d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8005d9:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	//sys_cputs(&c, 1);

	sys_cputc(c);
  8005dc:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  8005e0:	83 ec 0c             	sub    $0xc,%esp
  8005e3:	50                   	push   %eax
  8005e4:	e8 11 19 00 00       	call   801efa <sys_cputc>
  8005e9:	83 c4 10             	add    $0x10,%esp
}
  8005ec:	90                   	nop
  8005ed:	c9                   	leave  
  8005ee:	c3                   	ret    

008005ef <getchar>:


int
getchar(void)
{
  8005ef:	55                   	push   %ebp
  8005f0:	89 e5                	mov    %esp,%ebp
  8005f2:	83 ec 18             	sub    $0x18,%esp
	int c =sys_cgetc();
  8005f5:	e8 9f 17 00 00       	call   801d99 <sys_cgetc>
  8005fa:	89 45 f4             	mov    %eax,-0xc(%ebp)
	return c;
  8005fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800600:	c9                   	leave  
  800601:	c3                   	ret    

00800602 <iscons>:

int iscons(int fdnum)
{
  800602:	55                   	push   %ebp
  800603:	89 e5                	mov    %esp,%ebp
	// used by readline
	return 1;
  800605:	b8 01 00 00 00       	mov    $0x1,%eax
}
  80060a:	5d                   	pop    %ebp
  80060b:	c3                   	ret    

0080060c <libmain>:
volatile bool printStats = 1;

volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";
void
libmain(int argc, char **argv)
{
  80060c:	55                   	push   %ebp
  80060d:	89 e5                	mov    %esp,%ebp
  80060f:	57                   	push   %edi
  800610:	56                   	push   %esi
  800611:	53                   	push   %ebx
  800612:	83 ec 7c             	sub    $0x7c,%esp
	//printStats = 1;
	int envIndex = sys_getenvindex();
  800615:	e8 11 1a 00 00       	call   80202b <sys_getenvindex>
  80061a:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	myEnv = &(envs[envIndex]);
  80061d:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800620:	89 d0                	mov    %edx,%eax
  800622:	c1 e0 06             	shl    $0x6,%eax
  800625:	29 d0                	sub    %edx,%eax
  800627:	c1 e0 02             	shl    $0x2,%eax
  80062a:	01 d0                	add    %edx,%eax
  80062c:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800633:	01 c8                	add    %ecx,%eax
  800635:	c1 e0 03             	shl    $0x3,%eax
  800638:	01 d0                	add    %edx,%eax
  80063a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800641:	29 c2                	sub    %eax,%edx
  800643:	8d 04 95 00 00 00 00 	lea    0x0(,%edx,4),%eax
  80064a:	89 c2                	mov    %eax,%edx
  80064c:	8d 82 00 00 c0 ee    	lea    -0x11400000(%edx),%eax
  800652:	a3 24 40 80 00       	mov    %eax,0x804024

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800657:	a1 24 40 80 00       	mov    0x804024,%eax
  80065c:	8a 40 20             	mov    0x20(%eax),%al
  80065f:	84 c0                	test   %al,%al
  800661:	74 0d                	je     800670 <libmain+0x64>
		binaryname = myEnv->prog_name;
  800663:	a1 24 40 80 00       	mov    0x804024,%eax
  800668:	83 c0 20             	add    $0x20,%eax
  80066b:	a3 04 40 80 00       	mov    %eax,0x804004

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800670:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800674:	7e 0a                	jle    800680 <libmain+0x74>
		binaryname = argv[0];
  800676:	8b 45 0c             	mov    0xc(%ebp),%eax
  800679:	8b 00                	mov    (%eax),%eax
  80067b:	a3 04 40 80 00       	mov    %eax,0x804004

	// call user main routine
	_main(argc, argv);
  800680:	83 ec 08             	sub    $0x8,%esp
  800683:	ff 75 0c             	pushl  0xc(%ebp)
  800686:	ff 75 08             	pushl  0x8(%ebp)
  800689:	e8 aa f9 ff ff       	call   800038 <_main>
  80068e:	83 c4 10             	add    $0x10,%esp

	if (printStats)
  800691:	a1 00 40 80 00       	mov    0x804000,%eax
  800696:	85 c0                	test   %eax,%eax
  800698:	0f 84 01 01 00 00    	je     80079f <libmain+0x193>
	{
		char isOPTReplCmd[100] = "__IsOPTRepl__" ;
  80069e:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  8006a4:	bb dc 32 80 00       	mov    $0x8032dc,%ebx
  8006a9:	ba 0e 00 00 00       	mov    $0xe,%edx
  8006ae:	89 c7                	mov    %eax,%edi
  8006b0:	89 de                	mov    %ebx,%esi
  8006b2:	89 d1                	mov    %edx,%ecx
  8006b4:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  8006b6:	8d 55 8a             	lea    -0x76(%ebp),%edx
  8006b9:	b9 56 00 00 00       	mov    $0x56,%ecx
  8006be:	b0 00                	mov    $0x0,%al
  8006c0:	89 d7                	mov    %edx,%edi
  8006c2:	f3 aa                	rep stos %al,%es:(%edi)
		int isOPTRepl = 0;
  8006c4:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
		sys_utilities(isOPTReplCmd, (uint32)(&isOPTRepl));
  8006cb:	8d 45 e0             	lea    -0x20(%ebp),%eax
  8006ce:	83 ec 08             	sub    $0x8,%esp
  8006d1:	50                   	push   %eax
  8006d2:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  8006d8:	50                   	push   %eax
  8006d9:	e8 83 1b 00 00       	call   802261 <sys_utilities>
  8006de:	83 c4 10             	add    $0x10,%esp

		sys_lock_cons();
  8006e1:	e8 cc 16 00 00       	call   801db2 <sys_lock_cons>
		{
			cprintf("**************************************\n");
  8006e6:	83 ec 0c             	sub    $0xc,%esp
  8006e9:	68 fc 31 80 00       	push   $0x8031fc
  8006ee:	e8 ac 03 00 00       	call   800a9f <cprintf>
  8006f3:	83 c4 10             	add    $0x10,%esp
			if (isOPTRepl)
  8006f6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8006f9:	85 c0                	test   %eax,%eax
  8006fb:	74 18                	je     800715 <libmain+0x109>
			{
				cprintf("OPTIMAL number of page faults = %d\n", sys_get_optimal_num_faults());
  8006fd:	e8 7d 1b 00 00       	call   80227f <sys_get_optimal_num_faults>
  800702:	83 ec 08             	sub    $0x8,%esp
  800705:	50                   	push   %eax
  800706:	68 24 32 80 00       	push   $0x803224
  80070b:	e8 8f 03 00 00       	call   800a9f <cprintf>
  800710:	83 c4 10             	add    $0x10,%esp
  800713:	eb 59                	jmp    80076e <libmain+0x162>
			}
			else
			{
				cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  800715:	a1 24 40 80 00       	mov    0x804024,%eax
  80071a:	8b 90 50 da 01 00    	mov    0x1da50(%eax),%edx
  800720:	a1 24 40 80 00       	mov    0x804024,%eax
  800725:	8b 80 40 da 01 00    	mov    0x1da40(%eax),%eax
  80072b:	83 ec 04             	sub    $0x4,%esp
  80072e:	52                   	push   %edx
  80072f:	50                   	push   %eax
  800730:	68 48 32 80 00       	push   $0x803248
  800735:	e8 65 03 00 00       	call   800a9f <cprintf>
  80073a:	83 c4 10             	add    $0x10,%esp
				cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  80073d:	a1 24 40 80 00       	mov    0x804024,%eax
  800742:	8b 88 64 da 01 00    	mov    0x1da64(%eax),%ecx
  800748:	a1 24 40 80 00       	mov    0x804024,%eax
  80074d:	8b 90 60 da 01 00    	mov    0x1da60(%eax),%edx
  800753:	a1 24 40 80 00       	mov    0x804024,%eax
  800758:	8b 80 5c da 01 00    	mov    0x1da5c(%eax),%eax
  80075e:	51                   	push   %ecx
  80075f:	52                   	push   %edx
  800760:	50                   	push   %eax
  800761:	68 70 32 80 00       	push   $0x803270
  800766:	e8 34 03 00 00       	call   800a9f <cprintf>
  80076b:	83 c4 10             	add    $0x10,%esp
			}
			//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
			cprintf("Num of clocks = %d\n", myEnv->nClocks);
  80076e:	a1 24 40 80 00       	mov    0x804024,%eax
  800773:	8b 80 68 da 01 00    	mov    0x1da68(%eax),%eax
  800779:	83 ec 08             	sub    $0x8,%esp
  80077c:	50                   	push   %eax
  80077d:	68 c8 32 80 00       	push   $0x8032c8
  800782:	e8 18 03 00 00       	call   800a9f <cprintf>
  800787:	83 c4 10             	add    $0x10,%esp
			cprintf("**************************************\n");
  80078a:	83 ec 0c             	sub    $0xc,%esp
  80078d:	68 fc 31 80 00       	push   $0x8031fc
  800792:	e8 08 03 00 00       	call   800a9f <cprintf>
  800797:	83 c4 10             	add    $0x10,%esp
		}
		sys_unlock_cons();
  80079a:	e8 2d 16 00 00       	call   801dcc <sys_unlock_cons>
	}

	// exit gracefully
	exit();
  80079f:	e8 1f 00 00 00       	call   8007c3 <exit>
}
  8007a4:	90                   	nop
  8007a5:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8007a8:	5b                   	pop    %ebx
  8007a9:	5e                   	pop    %esi
  8007aa:	5f                   	pop    %edi
  8007ab:	5d                   	pop    %ebp
  8007ac:	c3                   	ret    

008007ad <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  8007ad:	55                   	push   %ebp
  8007ae:	89 e5                	mov    %esp,%ebp
  8007b0:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  8007b3:	83 ec 0c             	sub    $0xc,%esp
  8007b6:	6a 00                	push   $0x0
  8007b8:	e8 3a 18 00 00       	call   801ff7 <sys_destroy_env>
  8007bd:	83 c4 10             	add    $0x10,%esp
}
  8007c0:	90                   	nop
  8007c1:	c9                   	leave  
  8007c2:	c3                   	ret    

008007c3 <exit>:

void
exit(void)
{
  8007c3:	55                   	push   %ebp
  8007c4:	89 e5                	mov    %esp,%ebp
  8007c6:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  8007c9:	e8 8f 18 00 00       	call   80205d <sys_exit_env>
}
  8007ce:	90                   	nop
  8007cf:	c9                   	leave  
  8007d0:	c3                   	ret    

008007d1 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  8007d1:	55                   	push   %ebp
  8007d2:	89 e5                	mov    %esp,%ebp
  8007d4:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  8007d7:	8d 45 10             	lea    0x10(%ebp),%eax
  8007da:	83 c0 04             	add    $0x4,%eax
  8007dd:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  8007e0:	a1 18 c1 81 00       	mov    0x81c118,%eax
  8007e5:	85 c0                	test   %eax,%eax
  8007e7:	74 16                	je     8007ff <_panic+0x2e>
		cprintf("%s: ", argv0);
  8007e9:	a1 18 c1 81 00       	mov    0x81c118,%eax
  8007ee:	83 ec 08             	sub    $0x8,%esp
  8007f1:	50                   	push   %eax
  8007f2:	68 40 33 80 00       	push   $0x803340
  8007f7:	e8 a3 02 00 00       	call   800a9f <cprintf>
  8007fc:	83 c4 10             	add    $0x10,%esp
	cprintf_colored(TEXT_PANIC_CLR, "user [EVAL_FINAL]panic in %s at %s:%d: ", binaryname, file, line);
  8007ff:	a1 04 40 80 00       	mov    0x804004,%eax
  800804:	83 ec 0c             	sub    $0xc,%esp
  800807:	ff 75 0c             	pushl  0xc(%ebp)
  80080a:	ff 75 08             	pushl  0x8(%ebp)
  80080d:	50                   	push   %eax
  80080e:	68 48 33 80 00       	push   $0x803348
  800813:	6a 74                	push   $0x74
  800815:	e8 b2 02 00 00       	call   800acc <cprintf_colored>
  80081a:	83 c4 20             	add    $0x20,%esp
	vcprintf(fmt, ap);
  80081d:	8b 45 10             	mov    0x10(%ebp),%eax
  800820:	83 ec 08             	sub    $0x8,%esp
  800823:	ff 75 f4             	pushl  -0xc(%ebp)
  800826:	50                   	push   %eax
  800827:	e8 04 02 00 00       	call   800a30 <vcprintf>
  80082c:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  80082f:	83 ec 08             	sub    $0x8,%esp
  800832:	6a 00                	push   $0x0
  800834:	68 70 33 80 00       	push   $0x803370
  800839:	e8 f2 01 00 00       	call   800a30 <vcprintf>
  80083e:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  800841:	e8 7d ff ff ff       	call   8007c3 <exit>

	// should not return here
	while (1) ;
  800846:	eb fe                	jmp    800846 <_panic+0x75>

00800848 <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  800848:	55                   	push   %ebp
  800849:	89 e5                	mov    %esp,%ebp
  80084b:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  80084e:	a1 24 40 80 00       	mov    0x804024,%eax
  800853:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  800859:	8b 45 0c             	mov    0xc(%ebp),%eax
  80085c:	39 c2                	cmp    %eax,%edx
  80085e:	74 14                	je     800874 <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  800860:	83 ec 04             	sub    $0x4,%esp
  800863:	68 74 33 80 00       	push   $0x803374
  800868:	6a 26                	push   $0x26
  80086a:	68 c0 33 80 00       	push   $0x8033c0
  80086f:	e8 5d ff ff ff       	call   8007d1 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  800874:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  80087b:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800882:	e9 c5 00 00 00       	jmp    80094c <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  800887:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80088a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800891:	8b 45 08             	mov    0x8(%ebp),%eax
  800894:	01 d0                	add    %edx,%eax
  800896:	8b 00                	mov    (%eax),%eax
  800898:	85 c0                	test   %eax,%eax
  80089a:	75 08                	jne    8008a4 <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  80089c:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  80089f:	e9 a5 00 00 00       	jmp    800949 <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  8008a4:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8008ab:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  8008b2:	eb 69                	jmp    80091d <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  8008b4:	a1 24 40 80 00       	mov    0x804024,%eax
  8008b9:	8b 88 38 da 01 00    	mov    0x1da38(%eax),%ecx
  8008bf:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8008c2:	89 d0                	mov    %edx,%eax
  8008c4:	01 c0                	add    %eax,%eax
  8008c6:	01 d0                	add    %edx,%eax
  8008c8:	c1 e0 03             	shl    $0x3,%eax
  8008cb:	01 c8                	add    %ecx,%eax
  8008cd:	8a 40 04             	mov    0x4(%eax),%al
  8008d0:	84 c0                	test   %al,%al
  8008d2:	75 46                	jne    80091a <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8008d4:	a1 24 40 80 00       	mov    0x804024,%eax
  8008d9:	8b 88 38 da 01 00    	mov    0x1da38(%eax),%ecx
  8008df:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8008e2:	89 d0                	mov    %edx,%eax
  8008e4:	01 c0                	add    %eax,%eax
  8008e6:	01 d0                	add    %edx,%eax
  8008e8:	c1 e0 03             	shl    $0x3,%eax
  8008eb:	01 c8                	add    %ecx,%eax
  8008ed:	8b 00                	mov    (%eax),%eax
  8008ef:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8008f2:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8008f5:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8008fa:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  8008fc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8008ff:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800906:	8b 45 08             	mov    0x8(%ebp),%eax
  800909:	01 c8                	add    %ecx,%eax
  80090b:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  80090d:	39 c2                	cmp    %eax,%edx
  80090f:	75 09                	jne    80091a <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  800911:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  800918:	eb 15                	jmp    80092f <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80091a:	ff 45 e8             	incl   -0x18(%ebp)
  80091d:	a1 24 40 80 00       	mov    0x804024,%eax
  800922:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  800928:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80092b:	39 c2                	cmp    %eax,%edx
  80092d:	77 85                	ja     8008b4 <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  80092f:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800933:	75 14                	jne    800949 <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  800935:	83 ec 04             	sub    $0x4,%esp
  800938:	68 cc 33 80 00       	push   $0x8033cc
  80093d:	6a 3a                	push   $0x3a
  80093f:	68 c0 33 80 00       	push   $0x8033c0
  800944:	e8 88 fe ff ff       	call   8007d1 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  800949:	ff 45 f0             	incl   -0x10(%ebp)
  80094c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80094f:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800952:	0f 8c 2f ff ff ff    	jl     800887 <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  800958:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80095f:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800966:	eb 26                	jmp    80098e <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  800968:	a1 24 40 80 00       	mov    0x804024,%eax
  80096d:	8b 88 38 da 01 00    	mov    0x1da38(%eax),%ecx
  800973:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800976:	89 d0                	mov    %edx,%eax
  800978:	01 c0                	add    %eax,%eax
  80097a:	01 d0                	add    %edx,%eax
  80097c:	c1 e0 03             	shl    $0x3,%eax
  80097f:	01 c8                	add    %ecx,%eax
  800981:	8a 40 04             	mov    0x4(%eax),%al
  800984:	3c 01                	cmp    $0x1,%al
  800986:	75 03                	jne    80098b <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  800988:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80098b:	ff 45 e0             	incl   -0x20(%ebp)
  80098e:	a1 24 40 80 00       	mov    0x804024,%eax
  800993:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  800999:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80099c:	39 c2                	cmp    %eax,%edx
  80099e:	77 c8                	ja     800968 <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  8009a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8009a3:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8009a6:	74 14                	je     8009bc <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  8009a8:	83 ec 04             	sub    $0x4,%esp
  8009ab:	68 20 34 80 00       	push   $0x803420
  8009b0:	6a 44                	push   $0x44
  8009b2:	68 c0 33 80 00       	push   $0x8033c0
  8009b7:	e8 15 fe ff ff       	call   8007d1 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  8009bc:	90                   	nop
  8009bd:	c9                   	leave  
  8009be:	c3                   	ret    

008009bf <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  8009bf:	55                   	push   %ebp
  8009c0:	89 e5                	mov    %esp,%ebp
  8009c2:	53                   	push   %ebx
  8009c3:	83 ec 04             	sub    $0x4,%esp
	b->buf[b->idx++] = ch;
  8009c6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009c9:	8b 00                	mov    (%eax),%eax
  8009cb:	8d 48 01             	lea    0x1(%eax),%ecx
  8009ce:	8b 55 0c             	mov    0xc(%ebp),%edx
  8009d1:	89 0a                	mov    %ecx,(%edx)
  8009d3:	8b 55 08             	mov    0x8(%ebp),%edx
  8009d6:	88 d1                	mov    %dl,%cl
  8009d8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8009db:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  8009df:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009e2:	8b 00                	mov    (%eax),%eax
  8009e4:	3d ff 00 00 00       	cmp    $0xff,%eax
  8009e9:	75 30                	jne    800a1b <putch+0x5c>
		sys_cputs(b->buf, b->idx, printProgName, curTextClr);
  8009eb:	8b 15 1c c1 81 00    	mov    0x81c11c,%edx
  8009f1:	a0 44 40 80 00       	mov    0x804044,%al
  8009f6:	0f b6 c0             	movzbl %al,%eax
  8009f9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8009fc:	8b 09                	mov    (%ecx),%ecx
  8009fe:	89 cb                	mov    %ecx,%ebx
  800a00:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800a03:	83 c1 08             	add    $0x8,%ecx
  800a06:	52                   	push   %edx
  800a07:	50                   	push   %eax
  800a08:	53                   	push   %ebx
  800a09:	51                   	push   %ecx
  800a0a:	e8 5f 13 00 00       	call   801d6e <sys_cputs>
  800a0f:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800a12:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a15:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800a1b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a1e:	8b 40 04             	mov    0x4(%eax),%eax
  800a21:	8d 50 01             	lea    0x1(%eax),%edx
  800a24:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a27:	89 50 04             	mov    %edx,0x4(%eax)
}
  800a2a:	90                   	nop
  800a2b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800a2e:	c9                   	leave  
  800a2f:	c3                   	ret    

00800a30 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800a30:	55                   	push   %ebp
  800a31:	89 e5                	mov    %esp,%ebp
  800a33:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800a39:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800a40:	00 00 00 
	b.cnt = 0;
  800a43:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800a4a:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800a4d:	ff 75 0c             	pushl  0xc(%ebp)
  800a50:	ff 75 08             	pushl  0x8(%ebp)
  800a53:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800a59:	50                   	push   %eax
  800a5a:	68 bf 09 80 00       	push   $0x8009bf
  800a5f:	e8 5a 02 00 00       	call   800cbe <vprintfmt>
  800a64:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName, curTextClr);
  800a67:	8b 15 1c c1 81 00    	mov    0x81c11c,%edx
  800a6d:	a0 44 40 80 00       	mov    0x804044,%al
  800a72:	0f b6 c0             	movzbl %al,%eax
  800a75:	8b 8d f0 fe ff ff    	mov    -0x110(%ebp),%ecx
  800a7b:	52                   	push   %edx
  800a7c:	50                   	push   %eax
  800a7d:	51                   	push   %ecx
  800a7e:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800a84:	83 c0 08             	add    $0x8,%eax
  800a87:	50                   	push   %eax
  800a88:	e8 e1 12 00 00       	call   801d6e <sys_cputs>
  800a8d:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800a90:	c6 05 44 40 80 00 00 	movb   $0x0,0x804044
	return b.cnt;
  800a97:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800a9d:	c9                   	leave  
  800a9e:	c3                   	ret    

00800a9f <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  800a9f:	55                   	push   %ebp
  800aa0:	89 e5                	mov    %esp,%ebp
  800aa2:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800aa5:	c6 05 44 40 80 00 01 	movb   $0x1,0x804044
	va_start(ap, fmt);
  800aac:	8d 45 0c             	lea    0xc(%ebp),%eax
  800aaf:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800ab2:	8b 45 08             	mov    0x8(%ebp),%eax
  800ab5:	83 ec 08             	sub    $0x8,%esp
  800ab8:	ff 75 f4             	pushl  -0xc(%ebp)
  800abb:	50                   	push   %eax
  800abc:	e8 6f ff ff ff       	call   800a30 <vcprintf>
  800ac1:	83 c4 10             	add    $0x10,%esp
  800ac4:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800ac7:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800aca:	c9                   	leave  
  800acb:	c3                   	ret    

00800acc <cprintf_colored>:

// *************** This text coloring feature is implemented by *************
// ********** Abd-Alrahman Zedan From Team Frozen-Bytes - FCIS'24-25 ********
int cprintf_colored(int textClr, const char *fmt, ...) {
  800acc:	55                   	push   %ebp
  800acd:	89 e5                	mov    %esp,%ebp
  800acf:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800ad2:	c6 05 44 40 80 00 01 	movb   $0x1,0x804044
	curTextClr = (textClr << 8) ; //set text color by the given value
  800ad9:	8b 45 08             	mov    0x8(%ebp),%eax
  800adc:	c1 e0 08             	shl    $0x8,%eax
  800adf:	a3 1c c1 81 00       	mov    %eax,0x81c11c
	va_start(ap, fmt);
  800ae4:	8d 45 0c             	lea    0xc(%ebp),%eax
  800ae7:	83 c0 04             	add    $0x4,%eax
  800aea:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800aed:	8b 45 0c             	mov    0xc(%ebp),%eax
  800af0:	83 ec 08             	sub    $0x8,%esp
  800af3:	ff 75 f4             	pushl  -0xc(%ebp)
  800af6:	50                   	push   %eax
  800af7:	e8 34 ff ff ff       	call   800a30 <vcprintf>
  800afc:	83 c4 10             	add    $0x10,%esp
  800aff:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);
	curTextClr = TEXT_DEFAULT_CLR; //restore default color
  800b02:	c7 05 1c c1 81 00 00 	movl   $0x700,0x81c11c
  800b09:	07 00 00 

	return cnt;
  800b0c:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800b0f:	c9                   	leave  
  800b10:	c3                   	ret    

00800b11 <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  800b11:	55                   	push   %ebp
  800b12:	89 e5                	mov    %esp,%ebp
  800b14:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  800b17:	e8 96 12 00 00       	call   801db2 <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  800b1c:	8d 45 0c             	lea    0xc(%ebp),%eax
  800b1f:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  800b22:	8b 45 08             	mov    0x8(%ebp),%eax
  800b25:	83 ec 08             	sub    $0x8,%esp
  800b28:	ff 75 f4             	pushl  -0xc(%ebp)
  800b2b:	50                   	push   %eax
  800b2c:	e8 ff fe ff ff       	call   800a30 <vcprintf>
  800b31:	83 c4 10             	add    $0x10,%esp
  800b34:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  800b37:	e8 90 12 00 00       	call   801dcc <sys_unlock_cons>
	return cnt;
  800b3c:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800b3f:	c9                   	leave  
  800b40:	c3                   	ret    

00800b41 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800b41:	55                   	push   %ebp
  800b42:	89 e5                	mov    %esp,%ebp
  800b44:	53                   	push   %ebx
  800b45:	83 ec 14             	sub    $0x14,%esp
  800b48:	8b 45 10             	mov    0x10(%ebp),%eax
  800b4b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b4e:	8b 45 14             	mov    0x14(%ebp),%eax
  800b51:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800b54:	8b 45 18             	mov    0x18(%ebp),%eax
  800b57:	ba 00 00 00 00       	mov    $0x0,%edx
  800b5c:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800b5f:	77 55                	ja     800bb6 <printnum+0x75>
  800b61:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800b64:	72 05                	jb     800b6b <printnum+0x2a>
  800b66:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800b69:	77 4b                	ja     800bb6 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800b6b:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800b6e:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800b71:	8b 45 18             	mov    0x18(%ebp),%eax
  800b74:	ba 00 00 00 00       	mov    $0x0,%edx
  800b79:	52                   	push   %edx
  800b7a:	50                   	push   %eax
  800b7b:	ff 75 f4             	pushl  -0xc(%ebp)
  800b7e:	ff 75 f0             	pushl  -0x10(%ebp)
  800b81:	e8 0e 22 00 00       	call   802d94 <__udivdi3>
  800b86:	83 c4 10             	add    $0x10,%esp
  800b89:	83 ec 04             	sub    $0x4,%esp
  800b8c:	ff 75 20             	pushl  0x20(%ebp)
  800b8f:	53                   	push   %ebx
  800b90:	ff 75 18             	pushl  0x18(%ebp)
  800b93:	52                   	push   %edx
  800b94:	50                   	push   %eax
  800b95:	ff 75 0c             	pushl  0xc(%ebp)
  800b98:	ff 75 08             	pushl  0x8(%ebp)
  800b9b:	e8 a1 ff ff ff       	call   800b41 <printnum>
  800ba0:	83 c4 20             	add    $0x20,%esp
  800ba3:	eb 1a                	jmp    800bbf <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800ba5:	83 ec 08             	sub    $0x8,%esp
  800ba8:	ff 75 0c             	pushl  0xc(%ebp)
  800bab:	ff 75 20             	pushl  0x20(%ebp)
  800bae:	8b 45 08             	mov    0x8(%ebp),%eax
  800bb1:	ff d0                	call   *%eax
  800bb3:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800bb6:	ff 4d 1c             	decl   0x1c(%ebp)
  800bb9:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800bbd:	7f e6                	jg     800ba5 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800bbf:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800bc2:	bb 00 00 00 00       	mov    $0x0,%ebx
  800bc7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800bca:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800bcd:	53                   	push   %ebx
  800bce:	51                   	push   %ecx
  800bcf:	52                   	push   %edx
  800bd0:	50                   	push   %eax
  800bd1:	e8 ce 22 00 00       	call   802ea4 <__umoddi3>
  800bd6:	83 c4 10             	add    $0x10,%esp
  800bd9:	05 94 36 80 00       	add    $0x803694,%eax
  800bde:	8a 00                	mov    (%eax),%al
  800be0:	0f be c0             	movsbl %al,%eax
  800be3:	83 ec 08             	sub    $0x8,%esp
  800be6:	ff 75 0c             	pushl  0xc(%ebp)
  800be9:	50                   	push   %eax
  800bea:	8b 45 08             	mov    0x8(%ebp),%eax
  800bed:	ff d0                	call   *%eax
  800bef:	83 c4 10             	add    $0x10,%esp
}
  800bf2:	90                   	nop
  800bf3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800bf6:	c9                   	leave  
  800bf7:	c3                   	ret    

00800bf8 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800bf8:	55                   	push   %ebp
  800bf9:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800bfb:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800bff:	7e 1c                	jle    800c1d <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800c01:	8b 45 08             	mov    0x8(%ebp),%eax
  800c04:	8b 00                	mov    (%eax),%eax
  800c06:	8d 50 08             	lea    0x8(%eax),%edx
  800c09:	8b 45 08             	mov    0x8(%ebp),%eax
  800c0c:	89 10                	mov    %edx,(%eax)
  800c0e:	8b 45 08             	mov    0x8(%ebp),%eax
  800c11:	8b 00                	mov    (%eax),%eax
  800c13:	83 e8 08             	sub    $0x8,%eax
  800c16:	8b 50 04             	mov    0x4(%eax),%edx
  800c19:	8b 00                	mov    (%eax),%eax
  800c1b:	eb 40                	jmp    800c5d <getuint+0x65>
	else if (lflag)
  800c1d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c21:	74 1e                	je     800c41 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800c23:	8b 45 08             	mov    0x8(%ebp),%eax
  800c26:	8b 00                	mov    (%eax),%eax
  800c28:	8d 50 04             	lea    0x4(%eax),%edx
  800c2b:	8b 45 08             	mov    0x8(%ebp),%eax
  800c2e:	89 10                	mov    %edx,(%eax)
  800c30:	8b 45 08             	mov    0x8(%ebp),%eax
  800c33:	8b 00                	mov    (%eax),%eax
  800c35:	83 e8 04             	sub    $0x4,%eax
  800c38:	8b 00                	mov    (%eax),%eax
  800c3a:	ba 00 00 00 00       	mov    $0x0,%edx
  800c3f:	eb 1c                	jmp    800c5d <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800c41:	8b 45 08             	mov    0x8(%ebp),%eax
  800c44:	8b 00                	mov    (%eax),%eax
  800c46:	8d 50 04             	lea    0x4(%eax),%edx
  800c49:	8b 45 08             	mov    0x8(%ebp),%eax
  800c4c:	89 10                	mov    %edx,(%eax)
  800c4e:	8b 45 08             	mov    0x8(%ebp),%eax
  800c51:	8b 00                	mov    (%eax),%eax
  800c53:	83 e8 04             	sub    $0x4,%eax
  800c56:	8b 00                	mov    (%eax),%eax
  800c58:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800c5d:	5d                   	pop    %ebp
  800c5e:	c3                   	ret    

00800c5f <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800c5f:	55                   	push   %ebp
  800c60:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800c62:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800c66:	7e 1c                	jle    800c84 <getint+0x25>
		return va_arg(*ap, long long);
  800c68:	8b 45 08             	mov    0x8(%ebp),%eax
  800c6b:	8b 00                	mov    (%eax),%eax
  800c6d:	8d 50 08             	lea    0x8(%eax),%edx
  800c70:	8b 45 08             	mov    0x8(%ebp),%eax
  800c73:	89 10                	mov    %edx,(%eax)
  800c75:	8b 45 08             	mov    0x8(%ebp),%eax
  800c78:	8b 00                	mov    (%eax),%eax
  800c7a:	83 e8 08             	sub    $0x8,%eax
  800c7d:	8b 50 04             	mov    0x4(%eax),%edx
  800c80:	8b 00                	mov    (%eax),%eax
  800c82:	eb 38                	jmp    800cbc <getint+0x5d>
	else if (lflag)
  800c84:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c88:	74 1a                	je     800ca4 <getint+0x45>
		return va_arg(*ap, long);
  800c8a:	8b 45 08             	mov    0x8(%ebp),%eax
  800c8d:	8b 00                	mov    (%eax),%eax
  800c8f:	8d 50 04             	lea    0x4(%eax),%edx
  800c92:	8b 45 08             	mov    0x8(%ebp),%eax
  800c95:	89 10                	mov    %edx,(%eax)
  800c97:	8b 45 08             	mov    0x8(%ebp),%eax
  800c9a:	8b 00                	mov    (%eax),%eax
  800c9c:	83 e8 04             	sub    $0x4,%eax
  800c9f:	8b 00                	mov    (%eax),%eax
  800ca1:	99                   	cltd   
  800ca2:	eb 18                	jmp    800cbc <getint+0x5d>
	else
		return va_arg(*ap, int);
  800ca4:	8b 45 08             	mov    0x8(%ebp),%eax
  800ca7:	8b 00                	mov    (%eax),%eax
  800ca9:	8d 50 04             	lea    0x4(%eax),%edx
  800cac:	8b 45 08             	mov    0x8(%ebp),%eax
  800caf:	89 10                	mov    %edx,(%eax)
  800cb1:	8b 45 08             	mov    0x8(%ebp),%eax
  800cb4:	8b 00                	mov    (%eax),%eax
  800cb6:	83 e8 04             	sub    $0x4,%eax
  800cb9:	8b 00                	mov    (%eax),%eax
  800cbb:	99                   	cltd   
}
  800cbc:	5d                   	pop    %ebp
  800cbd:	c3                   	ret    

00800cbe <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800cbe:	55                   	push   %ebp
  800cbf:	89 e5                	mov    %esp,%ebp
  800cc1:	56                   	push   %esi
  800cc2:	53                   	push   %ebx
  800cc3:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800cc6:	eb 17                	jmp    800cdf <vprintfmt+0x21>
			if (ch == '\0')
  800cc8:	85 db                	test   %ebx,%ebx
  800cca:	0f 84 c1 03 00 00    	je     801091 <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  800cd0:	83 ec 08             	sub    $0x8,%esp
  800cd3:	ff 75 0c             	pushl  0xc(%ebp)
  800cd6:	53                   	push   %ebx
  800cd7:	8b 45 08             	mov    0x8(%ebp),%eax
  800cda:	ff d0                	call   *%eax
  800cdc:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800cdf:	8b 45 10             	mov    0x10(%ebp),%eax
  800ce2:	8d 50 01             	lea    0x1(%eax),%edx
  800ce5:	89 55 10             	mov    %edx,0x10(%ebp)
  800ce8:	8a 00                	mov    (%eax),%al
  800cea:	0f b6 d8             	movzbl %al,%ebx
  800ced:	83 fb 25             	cmp    $0x25,%ebx
  800cf0:	75 d6                	jne    800cc8 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800cf2:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800cf6:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800cfd:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800d04:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800d0b:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800d12:	8b 45 10             	mov    0x10(%ebp),%eax
  800d15:	8d 50 01             	lea    0x1(%eax),%edx
  800d18:	89 55 10             	mov    %edx,0x10(%ebp)
  800d1b:	8a 00                	mov    (%eax),%al
  800d1d:	0f b6 d8             	movzbl %al,%ebx
  800d20:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800d23:	83 f8 5b             	cmp    $0x5b,%eax
  800d26:	0f 87 3d 03 00 00    	ja     801069 <vprintfmt+0x3ab>
  800d2c:	8b 04 85 b8 36 80 00 	mov    0x8036b8(,%eax,4),%eax
  800d33:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800d35:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800d39:	eb d7                	jmp    800d12 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800d3b:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800d3f:	eb d1                	jmp    800d12 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800d41:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800d48:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800d4b:	89 d0                	mov    %edx,%eax
  800d4d:	c1 e0 02             	shl    $0x2,%eax
  800d50:	01 d0                	add    %edx,%eax
  800d52:	01 c0                	add    %eax,%eax
  800d54:	01 d8                	add    %ebx,%eax
  800d56:	83 e8 30             	sub    $0x30,%eax
  800d59:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800d5c:	8b 45 10             	mov    0x10(%ebp),%eax
  800d5f:	8a 00                	mov    (%eax),%al
  800d61:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800d64:	83 fb 2f             	cmp    $0x2f,%ebx
  800d67:	7e 3e                	jle    800da7 <vprintfmt+0xe9>
  800d69:	83 fb 39             	cmp    $0x39,%ebx
  800d6c:	7f 39                	jg     800da7 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800d6e:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800d71:	eb d5                	jmp    800d48 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800d73:	8b 45 14             	mov    0x14(%ebp),%eax
  800d76:	83 c0 04             	add    $0x4,%eax
  800d79:	89 45 14             	mov    %eax,0x14(%ebp)
  800d7c:	8b 45 14             	mov    0x14(%ebp),%eax
  800d7f:	83 e8 04             	sub    $0x4,%eax
  800d82:	8b 00                	mov    (%eax),%eax
  800d84:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800d87:	eb 1f                	jmp    800da8 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800d89:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800d8d:	79 83                	jns    800d12 <vprintfmt+0x54>
				width = 0;
  800d8f:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800d96:	e9 77 ff ff ff       	jmp    800d12 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800d9b:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800da2:	e9 6b ff ff ff       	jmp    800d12 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800da7:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800da8:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800dac:	0f 89 60 ff ff ff    	jns    800d12 <vprintfmt+0x54>
				width = precision, precision = -1;
  800db2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800db5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800db8:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800dbf:	e9 4e ff ff ff       	jmp    800d12 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800dc4:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800dc7:	e9 46 ff ff ff       	jmp    800d12 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800dcc:	8b 45 14             	mov    0x14(%ebp),%eax
  800dcf:	83 c0 04             	add    $0x4,%eax
  800dd2:	89 45 14             	mov    %eax,0x14(%ebp)
  800dd5:	8b 45 14             	mov    0x14(%ebp),%eax
  800dd8:	83 e8 04             	sub    $0x4,%eax
  800ddb:	8b 00                	mov    (%eax),%eax
  800ddd:	83 ec 08             	sub    $0x8,%esp
  800de0:	ff 75 0c             	pushl  0xc(%ebp)
  800de3:	50                   	push   %eax
  800de4:	8b 45 08             	mov    0x8(%ebp),%eax
  800de7:	ff d0                	call   *%eax
  800de9:	83 c4 10             	add    $0x10,%esp
			break;
  800dec:	e9 9b 02 00 00       	jmp    80108c <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800df1:	8b 45 14             	mov    0x14(%ebp),%eax
  800df4:	83 c0 04             	add    $0x4,%eax
  800df7:	89 45 14             	mov    %eax,0x14(%ebp)
  800dfa:	8b 45 14             	mov    0x14(%ebp),%eax
  800dfd:	83 e8 04             	sub    $0x4,%eax
  800e00:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800e02:	85 db                	test   %ebx,%ebx
  800e04:	79 02                	jns    800e08 <vprintfmt+0x14a>
				err = -err;
  800e06:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800e08:	83 fb 64             	cmp    $0x64,%ebx
  800e0b:	7f 0b                	jg     800e18 <vprintfmt+0x15a>
  800e0d:	8b 34 9d 00 35 80 00 	mov    0x803500(,%ebx,4),%esi
  800e14:	85 f6                	test   %esi,%esi
  800e16:	75 19                	jne    800e31 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800e18:	53                   	push   %ebx
  800e19:	68 a5 36 80 00       	push   $0x8036a5
  800e1e:	ff 75 0c             	pushl  0xc(%ebp)
  800e21:	ff 75 08             	pushl  0x8(%ebp)
  800e24:	e8 70 02 00 00       	call   801099 <printfmt>
  800e29:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800e2c:	e9 5b 02 00 00       	jmp    80108c <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800e31:	56                   	push   %esi
  800e32:	68 ae 36 80 00       	push   $0x8036ae
  800e37:	ff 75 0c             	pushl  0xc(%ebp)
  800e3a:	ff 75 08             	pushl  0x8(%ebp)
  800e3d:	e8 57 02 00 00       	call   801099 <printfmt>
  800e42:	83 c4 10             	add    $0x10,%esp
			break;
  800e45:	e9 42 02 00 00       	jmp    80108c <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800e4a:	8b 45 14             	mov    0x14(%ebp),%eax
  800e4d:	83 c0 04             	add    $0x4,%eax
  800e50:	89 45 14             	mov    %eax,0x14(%ebp)
  800e53:	8b 45 14             	mov    0x14(%ebp),%eax
  800e56:	83 e8 04             	sub    $0x4,%eax
  800e59:	8b 30                	mov    (%eax),%esi
  800e5b:	85 f6                	test   %esi,%esi
  800e5d:	75 05                	jne    800e64 <vprintfmt+0x1a6>
				p = "(null)";
  800e5f:	be b1 36 80 00       	mov    $0x8036b1,%esi
			if (width > 0 && padc != '-')
  800e64:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800e68:	7e 6d                	jle    800ed7 <vprintfmt+0x219>
  800e6a:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800e6e:	74 67                	je     800ed7 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800e70:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800e73:	83 ec 08             	sub    $0x8,%esp
  800e76:	50                   	push   %eax
  800e77:	56                   	push   %esi
  800e78:	e8 26 05 00 00       	call   8013a3 <strnlen>
  800e7d:	83 c4 10             	add    $0x10,%esp
  800e80:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800e83:	eb 16                	jmp    800e9b <vprintfmt+0x1dd>
					putch(padc, putdat);
  800e85:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800e89:	83 ec 08             	sub    $0x8,%esp
  800e8c:	ff 75 0c             	pushl  0xc(%ebp)
  800e8f:	50                   	push   %eax
  800e90:	8b 45 08             	mov    0x8(%ebp),%eax
  800e93:	ff d0                	call   *%eax
  800e95:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800e98:	ff 4d e4             	decl   -0x1c(%ebp)
  800e9b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800e9f:	7f e4                	jg     800e85 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800ea1:	eb 34                	jmp    800ed7 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800ea3:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800ea7:	74 1c                	je     800ec5 <vprintfmt+0x207>
  800ea9:	83 fb 1f             	cmp    $0x1f,%ebx
  800eac:	7e 05                	jle    800eb3 <vprintfmt+0x1f5>
  800eae:	83 fb 7e             	cmp    $0x7e,%ebx
  800eb1:	7e 12                	jle    800ec5 <vprintfmt+0x207>
					putch('?', putdat);
  800eb3:	83 ec 08             	sub    $0x8,%esp
  800eb6:	ff 75 0c             	pushl  0xc(%ebp)
  800eb9:	6a 3f                	push   $0x3f
  800ebb:	8b 45 08             	mov    0x8(%ebp),%eax
  800ebe:	ff d0                	call   *%eax
  800ec0:	83 c4 10             	add    $0x10,%esp
  800ec3:	eb 0f                	jmp    800ed4 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800ec5:	83 ec 08             	sub    $0x8,%esp
  800ec8:	ff 75 0c             	pushl  0xc(%ebp)
  800ecb:	53                   	push   %ebx
  800ecc:	8b 45 08             	mov    0x8(%ebp),%eax
  800ecf:	ff d0                	call   *%eax
  800ed1:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800ed4:	ff 4d e4             	decl   -0x1c(%ebp)
  800ed7:	89 f0                	mov    %esi,%eax
  800ed9:	8d 70 01             	lea    0x1(%eax),%esi
  800edc:	8a 00                	mov    (%eax),%al
  800ede:	0f be d8             	movsbl %al,%ebx
  800ee1:	85 db                	test   %ebx,%ebx
  800ee3:	74 24                	je     800f09 <vprintfmt+0x24b>
  800ee5:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800ee9:	78 b8                	js     800ea3 <vprintfmt+0x1e5>
  800eeb:	ff 4d e0             	decl   -0x20(%ebp)
  800eee:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800ef2:	79 af                	jns    800ea3 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800ef4:	eb 13                	jmp    800f09 <vprintfmt+0x24b>
				putch(' ', putdat);
  800ef6:	83 ec 08             	sub    $0x8,%esp
  800ef9:	ff 75 0c             	pushl  0xc(%ebp)
  800efc:	6a 20                	push   $0x20
  800efe:	8b 45 08             	mov    0x8(%ebp),%eax
  800f01:	ff d0                	call   *%eax
  800f03:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800f06:	ff 4d e4             	decl   -0x1c(%ebp)
  800f09:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800f0d:	7f e7                	jg     800ef6 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800f0f:	e9 78 01 00 00       	jmp    80108c <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800f14:	83 ec 08             	sub    $0x8,%esp
  800f17:	ff 75 e8             	pushl  -0x18(%ebp)
  800f1a:	8d 45 14             	lea    0x14(%ebp),%eax
  800f1d:	50                   	push   %eax
  800f1e:	e8 3c fd ff ff       	call   800c5f <getint>
  800f23:	83 c4 10             	add    $0x10,%esp
  800f26:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800f29:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800f2c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800f2f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800f32:	85 d2                	test   %edx,%edx
  800f34:	79 23                	jns    800f59 <vprintfmt+0x29b>
				putch('-', putdat);
  800f36:	83 ec 08             	sub    $0x8,%esp
  800f39:	ff 75 0c             	pushl  0xc(%ebp)
  800f3c:	6a 2d                	push   $0x2d
  800f3e:	8b 45 08             	mov    0x8(%ebp),%eax
  800f41:	ff d0                	call   *%eax
  800f43:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800f46:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800f49:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800f4c:	f7 d8                	neg    %eax
  800f4e:	83 d2 00             	adc    $0x0,%edx
  800f51:	f7 da                	neg    %edx
  800f53:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800f56:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800f59:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800f60:	e9 bc 00 00 00       	jmp    801021 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800f65:	83 ec 08             	sub    $0x8,%esp
  800f68:	ff 75 e8             	pushl  -0x18(%ebp)
  800f6b:	8d 45 14             	lea    0x14(%ebp),%eax
  800f6e:	50                   	push   %eax
  800f6f:	e8 84 fc ff ff       	call   800bf8 <getuint>
  800f74:	83 c4 10             	add    $0x10,%esp
  800f77:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800f7a:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800f7d:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800f84:	e9 98 00 00 00       	jmp    801021 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800f89:	83 ec 08             	sub    $0x8,%esp
  800f8c:	ff 75 0c             	pushl  0xc(%ebp)
  800f8f:	6a 58                	push   $0x58
  800f91:	8b 45 08             	mov    0x8(%ebp),%eax
  800f94:	ff d0                	call   *%eax
  800f96:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800f99:	83 ec 08             	sub    $0x8,%esp
  800f9c:	ff 75 0c             	pushl  0xc(%ebp)
  800f9f:	6a 58                	push   $0x58
  800fa1:	8b 45 08             	mov    0x8(%ebp),%eax
  800fa4:	ff d0                	call   *%eax
  800fa6:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800fa9:	83 ec 08             	sub    $0x8,%esp
  800fac:	ff 75 0c             	pushl  0xc(%ebp)
  800faf:	6a 58                	push   $0x58
  800fb1:	8b 45 08             	mov    0x8(%ebp),%eax
  800fb4:	ff d0                	call   *%eax
  800fb6:	83 c4 10             	add    $0x10,%esp
			break;
  800fb9:	e9 ce 00 00 00       	jmp    80108c <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  800fbe:	83 ec 08             	sub    $0x8,%esp
  800fc1:	ff 75 0c             	pushl  0xc(%ebp)
  800fc4:	6a 30                	push   $0x30
  800fc6:	8b 45 08             	mov    0x8(%ebp),%eax
  800fc9:	ff d0                	call   *%eax
  800fcb:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800fce:	83 ec 08             	sub    $0x8,%esp
  800fd1:	ff 75 0c             	pushl  0xc(%ebp)
  800fd4:	6a 78                	push   $0x78
  800fd6:	8b 45 08             	mov    0x8(%ebp),%eax
  800fd9:	ff d0                	call   *%eax
  800fdb:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800fde:	8b 45 14             	mov    0x14(%ebp),%eax
  800fe1:	83 c0 04             	add    $0x4,%eax
  800fe4:	89 45 14             	mov    %eax,0x14(%ebp)
  800fe7:	8b 45 14             	mov    0x14(%ebp),%eax
  800fea:	83 e8 04             	sub    $0x4,%eax
  800fed:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800fef:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800ff2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800ff9:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  801000:	eb 1f                	jmp    801021 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  801002:	83 ec 08             	sub    $0x8,%esp
  801005:	ff 75 e8             	pushl  -0x18(%ebp)
  801008:	8d 45 14             	lea    0x14(%ebp),%eax
  80100b:	50                   	push   %eax
  80100c:	e8 e7 fb ff ff       	call   800bf8 <getuint>
  801011:	83 c4 10             	add    $0x10,%esp
  801014:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801017:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  80101a:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  801021:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  801025:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801028:	83 ec 04             	sub    $0x4,%esp
  80102b:	52                   	push   %edx
  80102c:	ff 75 e4             	pushl  -0x1c(%ebp)
  80102f:	50                   	push   %eax
  801030:	ff 75 f4             	pushl  -0xc(%ebp)
  801033:	ff 75 f0             	pushl  -0x10(%ebp)
  801036:	ff 75 0c             	pushl  0xc(%ebp)
  801039:	ff 75 08             	pushl  0x8(%ebp)
  80103c:	e8 00 fb ff ff       	call   800b41 <printnum>
  801041:	83 c4 20             	add    $0x20,%esp
			break;
  801044:	eb 46                	jmp    80108c <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  801046:	83 ec 08             	sub    $0x8,%esp
  801049:	ff 75 0c             	pushl  0xc(%ebp)
  80104c:	53                   	push   %ebx
  80104d:	8b 45 08             	mov    0x8(%ebp),%eax
  801050:	ff d0                	call   *%eax
  801052:	83 c4 10             	add    $0x10,%esp
			break;
  801055:	eb 35                	jmp    80108c <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  801057:	c6 05 44 40 80 00 00 	movb   $0x0,0x804044
			break;
  80105e:	eb 2c                	jmp    80108c <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  801060:	c6 05 44 40 80 00 01 	movb   $0x1,0x804044
			break;
  801067:	eb 23                	jmp    80108c <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  801069:	83 ec 08             	sub    $0x8,%esp
  80106c:	ff 75 0c             	pushl  0xc(%ebp)
  80106f:	6a 25                	push   $0x25
  801071:	8b 45 08             	mov    0x8(%ebp),%eax
  801074:	ff d0                	call   *%eax
  801076:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  801079:	ff 4d 10             	decl   0x10(%ebp)
  80107c:	eb 03                	jmp    801081 <vprintfmt+0x3c3>
  80107e:	ff 4d 10             	decl   0x10(%ebp)
  801081:	8b 45 10             	mov    0x10(%ebp),%eax
  801084:	48                   	dec    %eax
  801085:	8a 00                	mov    (%eax),%al
  801087:	3c 25                	cmp    $0x25,%al
  801089:	75 f3                	jne    80107e <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  80108b:	90                   	nop
		}
	}
  80108c:	e9 35 fc ff ff       	jmp    800cc6 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  801091:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  801092:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801095:	5b                   	pop    %ebx
  801096:	5e                   	pop    %esi
  801097:	5d                   	pop    %ebp
  801098:	c3                   	ret    

00801099 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  801099:	55                   	push   %ebp
  80109a:	89 e5                	mov    %esp,%ebp
  80109c:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  80109f:	8d 45 10             	lea    0x10(%ebp),%eax
  8010a2:	83 c0 04             	add    $0x4,%eax
  8010a5:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  8010a8:	8b 45 10             	mov    0x10(%ebp),%eax
  8010ab:	ff 75 f4             	pushl  -0xc(%ebp)
  8010ae:	50                   	push   %eax
  8010af:	ff 75 0c             	pushl  0xc(%ebp)
  8010b2:	ff 75 08             	pushl  0x8(%ebp)
  8010b5:	e8 04 fc ff ff       	call   800cbe <vprintfmt>
  8010ba:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  8010bd:	90                   	nop
  8010be:	c9                   	leave  
  8010bf:	c3                   	ret    

008010c0 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8010c0:	55                   	push   %ebp
  8010c1:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  8010c3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010c6:	8b 40 08             	mov    0x8(%eax),%eax
  8010c9:	8d 50 01             	lea    0x1(%eax),%edx
  8010cc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010cf:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  8010d2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010d5:	8b 10                	mov    (%eax),%edx
  8010d7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010da:	8b 40 04             	mov    0x4(%eax),%eax
  8010dd:	39 c2                	cmp    %eax,%edx
  8010df:	73 12                	jae    8010f3 <sprintputch+0x33>
		*b->buf++ = ch;
  8010e1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010e4:	8b 00                	mov    (%eax),%eax
  8010e6:	8d 48 01             	lea    0x1(%eax),%ecx
  8010e9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8010ec:	89 0a                	mov    %ecx,(%edx)
  8010ee:	8b 55 08             	mov    0x8(%ebp),%edx
  8010f1:	88 10                	mov    %dl,(%eax)
}
  8010f3:	90                   	nop
  8010f4:	5d                   	pop    %ebp
  8010f5:	c3                   	ret    

008010f6 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8010f6:	55                   	push   %ebp
  8010f7:	89 e5                	mov    %esp,%ebp
  8010f9:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  8010fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8010ff:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801102:	8b 45 0c             	mov    0xc(%ebp),%eax
  801105:	8d 50 ff             	lea    -0x1(%eax),%edx
  801108:	8b 45 08             	mov    0x8(%ebp),%eax
  80110b:	01 d0                	add    %edx,%eax
  80110d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801110:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  801117:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80111b:	74 06                	je     801123 <vsnprintf+0x2d>
  80111d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801121:	7f 07                	jg     80112a <vsnprintf+0x34>
		return -E_INVAL;
  801123:	b8 03 00 00 00       	mov    $0x3,%eax
  801128:	eb 20                	jmp    80114a <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  80112a:	ff 75 14             	pushl  0x14(%ebp)
  80112d:	ff 75 10             	pushl  0x10(%ebp)
  801130:	8d 45 ec             	lea    -0x14(%ebp),%eax
  801133:	50                   	push   %eax
  801134:	68 c0 10 80 00       	push   $0x8010c0
  801139:	e8 80 fb ff ff       	call   800cbe <vprintfmt>
  80113e:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  801141:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801144:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  801147:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  80114a:	c9                   	leave  
  80114b:	c3                   	ret    

0080114c <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  80114c:	55                   	push   %ebp
  80114d:	89 e5                	mov    %esp,%ebp
  80114f:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  801152:	8d 45 10             	lea    0x10(%ebp),%eax
  801155:	83 c0 04             	add    $0x4,%eax
  801158:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  80115b:	8b 45 10             	mov    0x10(%ebp),%eax
  80115e:	ff 75 f4             	pushl  -0xc(%ebp)
  801161:	50                   	push   %eax
  801162:	ff 75 0c             	pushl  0xc(%ebp)
  801165:	ff 75 08             	pushl  0x8(%ebp)
  801168:	e8 89 ff ff ff       	call   8010f6 <vsnprintf>
  80116d:	83 c4 10             	add    $0x10,%esp
  801170:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  801173:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801176:	c9                   	leave  
  801177:	c3                   	ret    

00801178 <readline>:
#include <inc/lib.h>

//static char buf[BUFLEN];

void readline(const char *prompt, char* buf)
{
  801178:	55                   	push   %ebp
  801179:	89 e5                	mov    %esp,%ebp
  80117b:	83 ec 18             	sub    $0x18,%esp
	int i, c, echoing;

	if (prompt != NULL)
  80117e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801182:	74 13                	je     801197 <readline+0x1f>
		cprintf("%s", prompt);
  801184:	83 ec 08             	sub    $0x8,%esp
  801187:	ff 75 08             	pushl  0x8(%ebp)
  80118a:	68 28 38 80 00       	push   $0x803828
  80118f:	e8 0b f9 ff ff       	call   800a9f <cprintf>
  801194:	83 c4 10             	add    $0x10,%esp

	i = 0;
  801197:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	echoing = iscons(0);
  80119e:	83 ec 0c             	sub    $0xc,%esp
  8011a1:	6a 00                	push   $0x0
  8011a3:	e8 5a f4 ff ff       	call   800602 <iscons>
  8011a8:	83 c4 10             	add    $0x10,%esp
  8011ab:	89 45 f0             	mov    %eax,-0x10(%ebp)
	while (1) {
		c = getchar();
  8011ae:	e8 3c f4 ff ff       	call   8005ef <getchar>
  8011b3:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if (c < 0) {
  8011b6:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8011ba:	79 22                	jns    8011de <readline+0x66>
			if (c != -E_EOF)
  8011bc:	83 7d ec 07          	cmpl   $0x7,-0x14(%ebp)
  8011c0:	0f 84 ad 00 00 00    	je     801273 <readline+0xfb>
				cprintf("read error: %e\n", c);
  8011c6:	83 ec 08             	sub    $0x8,%esp
  8011c9:	ff 75 ec             	pushl  -0x14(%ebp)
  8011cc:	68 2b 38 80 00       	push   $0x80382b
  8011d1:	e8 c9 f8 ff ff       	call   800a9f <cprintf>
  8011d6:	83 c4 10             	add    $0x10,%esp
			break;
  8011d9:	e9 95 00 00 00       	jmp    801273 <readline+0xfb>
		} else if (c >= ' ' && i < BUFLEN-1) {
  8011de:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%ebp)
  8011e2:	7e 34                	jle    801218 <readline+0xa0>
  8011e4:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  8011eb:	7f 2b                	jg     801218 <readline+0xa0>
			if (echoing)
  8011ed:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8011f1:	74 0e                	je     801201 <readline+0x89>
				cputchar(c);
  8011f3:	83 ec 0c             	sub    $0xc,%esp
  8011f6:	ff 75 ec             	pushl  -0x14(%ebp)
  8011f9:	e8 d2 f3 ff ff       	call   8005d0 <cputchar>
  8011fe:	83 c4 10             	add    $0x10,%esp
			buf[i++] = c;
  801201:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801204:	8d 50 01             	lea    0x1(%eax),%edx
  801207:	89 55 f4             	mov    %edx,-0xc(%ebp)
  80120a:	89 c2                	mov    %eax,%edx
  80120c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80120f:	01 d0                	add    %edx,%eax
  801211:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801214:	88 10                	mov    %dl,(%eax)
  801216:	eb 56                	jmp    80126e <readline+0xf6>
		} else if (c == '\b' && i > 0) {
  801218:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  80121c:	75 1f                	jne    80123d <readline+0xc5>
  80121e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801222:	7e 19                	jle    80123d <readline+0xc5>
			if (echoing)
  801224:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801228:	74 0e                	je     801238 <readline+0xc0>
				cputchar(c);
  80122a:	83 ec 0c             	sub    $0xc,%esp
  80122d:	ff 75 ec             	pushl  -0x14(%ebp)
  801230:	e8 9b f3 ff ff       	call   8005d0 <cputchar>
  801235:	83 c4 10             	add    $0x10,%esp

			i--;
  801238:	ff 4d f4             	decl   -0xc(%ebp)
  80123b:	eb 31                	jmp    80126e <readline+0xf6>
		} else if (c == '\n' || c == '\r') {
  80123d:	83 7d ec 0a          	cmpl   $0xa,-0x14(%ebp)
  801241:	74 0a                	je     80124d <readline+0xd5>
  801243:	83 7d ec 0d          	cmpl   $0xd,-0x14(%ebp)
  801247:	0f 85 61 ff ff ff    	jne    8011ae <readline+0x36>
			if (echoing)
  80124d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801251:	74 0e                	je     801261 <readline+0xe9>
				cputchar(c);
  801253:	83 ec 0c             	sub    $0xc,%esp
  801256:	ff 75 ec             	pushl  -0x14(%ebp)
  801259:	e8 72 f3 ff ff       	call   8005d0 <cputchar>
  80125e:	83 c4 10             	add    $0x10,%esp

			buf[i] = 0;
  801261:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801264:	8b 45 0c             	mov    0xc(%ebp),%eax
  801267:	01 d0                	add    %edx,%eax
  801269:	c6 00 00             	movb   $0x0,(%eax)
			break;
  80126c:	eb 06                	jmp    801274 <readline+0xfc>
		}
	}
  80126e:	e9 3b ff ff ff       	jmp    8011ae <readline+0x36>
	while (1) {
		c = getchar();
		if (c < 0) {
			if (c != -E_EOF)
				cprintf("read error: %e\n", c);
			break;
  801273:	90                   	nop

			buf[i] = 0;
			break;
		}
	}
}
  801274:	90                   	nop
  801275:	c9                   	leave  
  801276:	c3                   	ret    

00801277 <atomic_readline>:

void atomic_readline(const char *prompt, char* buf)
{
  801277:	55                   	push   %ebp
  801278:	89 e5                	mov    %esp,%ebp
  80127a:	83 ec 18             	sub    $0x18,%esp
	sys_lock_cons();
  80127d:	e8 30 0b 00 00       	call   801db2 <sys_lock_cons>
	{
		int i, c, echoing;

		if (prompt != NULL)
  801282:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801286:	74 13                	je     80129b <atomic_readline+0x24>
			cprintf("%s", prompt);
  801288:	83 ec 08             	sub    $0x8,%esp
  80128b:	ff 75 08             	pushl  0x8(%ebp)
  80128e:	68 28 38 80 00       	push   $0x803828
  801293:	e8 07 f8 ff ff       	call   800a9f <cprintf>
  801298:	83 c4 10             	add    $0x10,%esp

		i = 0;
  80129b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
		echoing = iscons(0);
  8012a2:	83 ec 0c             	sub    $0xc,%esp
  8012a5:	6a 00                	push   $0x0
  8012a7:	e8 56 f3 ff ff       	call   800602 <iscons>
  8012ac:	83 c4 10             	add    $0x10,%esp
  8012af:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (1) {
			c = getchar();
  8012b2:	e8 38 f3 ff ff       	call   8005ef <getchar>
  8012b7:	89 45 ec             	mov    %eax,-0x14(%ebp)
			if (c < 0) {
  8012ba:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8012be:	79 22                	jns    8012e2 <atomic_readline+0x6b>
				if (c != -E_EOF)
  8012c0:	83 7d ec 07          	cmpl   $0x7,-0x14(%ebp)
  8012c4:	0f 84 ad 00 00 00    	je     801377 <atomic_readline+0x100>
					cprintf("read error: %e\n", c);
  8012ca:	83 ec 08             	sub    $0x8,%esp
  8012cd:	ff 75 ec             	pushl  -0x14(%ebp)
  8012d0:	68 2b 38 80 00       	push   $0x80382b
  8012d5:	e8 c5 f7 ff ff       	call   800a9f <cprintf>
  8012da:	83 c4 10             	add    $0x10,%esp
				break;
  8012dd:	e9 95 00 00 00       	jmp    801377 <atomic_readline+0x100>
			} else if (c >= ' ' && i < BUFLEN-1) {
  8012e2:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%ebp)
  8012e6:	7e 34                	jle    80131c <atomic_readline+0xa5>
  8012e8:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  8012ef:	7f 2b                	jg     80131c <atomic_readline+0xa5>
				if (echoing)
  8012f1:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8012f5:	74 0e                	je     801305 <atomic_readline+0x8e>
					cputchar(c);
  8012f7:	83 ec 0c             	sub    $0xc,%esp
  8012fa:	ff 75 ec             	pushl  -0x14(%ebp)
  8012fd:	e8 ce f2 ff ff       	call   8005d0 <cputchar>
  801302:	83 c4 10             	add    $0x10,%esp
				buf[i++] = c;
  801305:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801308:	8d 50 01             	lea    0x1(%eax),%edx
  80130b:	89 55 f4             	mov    %edx,-0xc(%ebp)
  80130e:	89 c2                	mov    %eax,%edx
  801310:	8b 45 0c             	mov    0xc(%ebp),%eax
  801313:	01 d0                	add    %edx,%eax
  801315:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801318:	88 10                	mov    %dl,(%eax)
  80131a:	eb 56                	jmp    801372 <atomic_readline+0xfb>
			} else if (c == '\b' && i > 0) {
  80131c:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  801320:	75 1f                	jne    801341 <atomic_readline+0xca>
  801322:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801326:	7e 19                	jle    801341 <atomic_readline+0xca>
				if (echoing)
  801328:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80132c:	74 0e                	je     80133c <atomic_readline+0xc5>
					cputchar(c);
  80132e:	83 ec 0c             	sub    $0xc,%esp
  801331:	ff 75 ec             	pushl  -0x14(%ebp)
  801334:	e8 97 f2 ff ff       	call   8005d0 <cputchar>
  801339:	83 c4 10             	add    $0x10,%esp
				i--;
  80133c:	ff 4d f4             	decl   -0xc(%ebp)
  80133f:	eb 31                	jmp    801372 <atomic_readline+0xfb>
			} else if (c == '\n' || c == '\r') {
  801341:	83 7d ec 0a          	cmpl   $0xa,-0x14(%ebp)
  801345:	74 0a                	je     801351 <atomic_readline+0xda>
  801347:	83 7d ec 0d          	cmpl   $0xd,-0x14(%ebp)
  80134b:	0f 85 61 ff ff ff    	jne    8012b2 <atomic_readline+0x3b>
				if (echoing)
  801351:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801355:	74 0e                	je     801365 <atomic_readline+0xee>
					cputchar(c);
  801357:	83 ec 0c             	sub    $0xc,%esp
  80135a:	ff 75 ec             	pushl  -0x14(%ebp)
  80135d:	e8 6e f2 ff ff       	call   8005d0 <cputchar>
  801362:	83 c4 10             	add    $0x10,%esp
				buf[i] = 0;
  801365:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801368:	8b 45 0c             	mov    0xc(%ebp),%eax
  80136b:	01 d0                	add    %edx,%eax
  80136d:	c6 00 00             	movb   $0x0,(%eax)
				break;
  801370:	eb 06                	jmp    801378 <atomic_readline+0x101>
			}
		}
  801372:	e9 3b ff ff ff       	jmp    8012b2 <atomic_readline+0x3b>
		while (1) {
			c = getchar();
			if (c < 0) {
				if (c != -E_EOF)
					cprintf("read error: %e\n", c);
				break;
  801377:	90                   	nop
				buf[i] = 0;
				break;
			}
		}
	}
	sys_unlock_cons();
  801378:	e8 4f 0a 00 00       	call   801dcc <sys_unlock_cons>
}
  80137d:	90                   	nop
  80137e:	c9                   	leave  
  80137f:	c3                   	ret    

00801380 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  801380:	55                   	push   %ebp
  801381:	89 e5                	mov    %esp,%ebp
  801383:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  801386:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80138d:	eb 06                	jmp    801395 <strlen+0x15>
		n++;
  80138f:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  801392:	ff 45 08             	incl   0x8(%ebp)
  801395:	8b 45 08             	mov    0x8(%ebp),%eax
  801398:	8a 00                	mov    (%eax),%al
  80139a:	84 c0                	test   %al,%al
  80139c:	75 f1                	jne    80138f <strlen+0xf>
		n++;
	return n;
  80139e:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8013a1:	c9                   	leave  
  8013a2:	c3                   	ret    

008013a3 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  8013a3:	55                   	push   %ebp
  8013a4:	89 e5                	mov    %esp,%ebp
  8013a6:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8013a9:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8013b0:	eb 09                	jmp    8013bb <strnlen+0x18>
		n++;
  8013b2:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8013b5:	ff 45 08             	incl   0x8(%ebp)
  8013b8:	ff 4d 0c             	decl   0xc(%ebp)
  8013bb:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8013bf:	74 09                	je     8013ca <strnlen+0x27>
  8013c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8013c4:	8a 00                	mov    (%eax),%al
  8013c6:	84 c0                	test   %al,%al
  8013c8:	75 e8                	jne    8013b2 <strnlen+0xf>
		n++;
	return n;
  8013ca:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8013cd:	c9                   	leave  
  8013ce:	c3                   	ret    

008013cf <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8013cf:	55                   	push   %ebp
  8013d0:	89 e5                	mov    %esp,%ebp
  8013d2:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  8013d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8013d8:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  8013db:	90                   	nop
  8013dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8013df:	8d 50 01             	lea    0x1(%eax),%edx
  8013e2:	89 55 08             	mov    %edx,0x8(%ebp)
  8013e5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8013e8:	8d 4a 01             	lea    0x1(%edx),%ecx
  8013eb:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  8013ee:	8a 12                	mov    (%edx),%dl
  8013f0:	88 10                	mov    %dl,(%eax)
  8013f2:	8a 00                	mov    (%eax),%al
  8013f4:	84 c0                	test   %al,%al
  8013f6:	75 e4                	jne    8013dc <strcpy+0xd>
		/* do nothing */;
	return ret;
  8013f8:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8013fb:	c9                   	leave  
  8013fc:	c3                   	ret    

008013fd <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  8013fd:	55                   	push   %ebp
  8013fe:	89 e5                	mov    %esp,%ebp
  801400:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  801403:	8b 45 08             	mov    0x8(%ebp),%eax
  801406:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  801409:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801410:	eb 1f                	jmp    801431 <strncpy+0x34>
		*dst++ = *src;
  801412:	8b 45 08             	mov    0x8(%ebp),%eax
  801415:	8d 50 01             	lea    0x1(%eax),%edx
  801418:	89 55 08             	mov    %edx,0x8(%ebp)
  80141b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80141e:	8a 12                	mov    (%edx),%dl
  801420:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  801422:	8b 45 0c             	mov    0xc(%ebp),%eax
  801425:	8a 00                	mov    (%eax),%al
  801427:	84 c0                	test   %al,%al
  801429:	74 03                	je     80142e <strncpy+0x31>
			src++;
  80142b:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  80142e:	ff 45 fc             	incl   -0x4(%ebp)
  801431:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801434:	3b 45 10             	cmp    0x10(%ebp),%eax
  801437:	72 d9                	jb     801412 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  801439:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  80143c:	c9                   	leave  
  80143d:	c3                   	ret    

0080143e <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  80143e:	55                   	push   %ebp
  80143f:	89 e5                	mov    %esp,%ebp
  801441:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  801444:	8b 45 08             	mov    0x8(%ebp),%eax
  801447:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  80144a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80144e:	74 30                	je     801480 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  801450:	eb 16                	jmp    801468 <strlcpy+0x2a>
			*dst++ = *src++;
  801452:	8b 45 08             	mov    0x8(%ebp),%eax
  801455:	8d 50 01             	lea    0x1(%eax),%edx
  801458:	89 55 08             	mov    %edx,0x8(%ebp)
  80145b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80145e:	8d 4a 01             	lea    0x1(%edx),%ecx
  801461:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  801464:	8a 12                	mov    (%edx),%dl
  801466:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  801468:	ff 4d 10             	decl   0x10(%ebp)
  80146b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80146f:	74 09                	je     80147a <strlcpy+0x3c>
  801471:	8b 45 0c             	mov    0xc(%ebp),%eax
  801474:	8a 00                	mov    (%eax),%al
  801476:	84 c0                	test   %al,%al
  801478:	75 d8                	jne    801452 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  80147a:	8b 45 08             	mov    0x8(%ebp),%eax
  80147d:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  801480:	8b 55 08             	mov    0x8(%ebp),%edx
  801483:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801486:	29 c2                	sub    %eax,%edx
  801488:	89 d0                	mov    %edx,%eax
}
  80148a:	c9                   	leave  
  80148b:	c3                   	ret    

0080148c <strcmp>:

int
strcmp(const char *p, const char *q)
{
  80148c:	55                   	push   %ebp
  80148d:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  80148f:	eb 06                	jmp    801497 <strcmp+0xb>
		p++, q++;
  801491:	ff 45 08             	incl   0x8(%ebp)
  801494:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  801497:	8b 45 08             	mov    0x8(%ebp),%eax
  80149a:	8a 00                	mov    (%eax),%al
  80149c:	84 c0                	test   %al,%al
  80149e:	74 0e                	je     8014ae <strcmp+0x22>
  8014a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8014a3:	8a 10                	mov    (%eax),%dl
  8014a5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014a8:	8a 00                	mov    (%eax),%al
  8014aa:	38 c2                	cmp    %al,%dl
  8014ac:	74 e3                	je     801491 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8014ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8014b1:	8a 00                	mov    (%eax),%al
  8014b3:	0f b6 d0             	movzbl %al,%edx
  8014b6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014b9:	8a 00                	mov    (%eax),%al
  8014bb:	0f b6 c0             	movzbl %al,%eax
  8014be:	29 c2                	sub    %eax,%edx
  8014c0:	89 d0                	mov    %edx,%eax
}
  8014c2:	5d                   	pop    %ebp
  8014c3:	c3                   	ret    

008014c4 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  8014c4:	55                   	push   %ebp
  8014c5:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  8014c7:	eb 09                	jmp    8014d2 <strncmp+0xe>
		n--, p++, q++;
  8014c9:	ff 4d 10             	decl   0x10(%ebp)
  8014cc:	ff 45 08             	incl   0x8(%ebp)
  8014cf:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  8014d2:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8014d6:	74 17                	je     8014ef <strncmp+0x2b>
  8014d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8014db:	8a 00                	mov    (%eax),%al
  8014dd:	84 c0                	test   %al,%al
  8014df:	74 0e                	je     8014ef <strncmp+0x2b>
  8014e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8014e4:	8a 10                	mov    (%eax),%dl
  8014e6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014e9:	8a 00                	mov    (%eax),%al
  8014eb:	38 c2                	cmp    %al,%dl
  8014ed:	74 da                	je     8014c9 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  8014ef:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8014f3:	75 07                	jne    8014fc <strncmp+0x38>
		return 0;
  8014f5:	b8 00 00 00 00       	mov    $0x0,%eax
  8014fa:	eb 14                	jmp    801510 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8014fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8014ff:	8a 00                	mov    (%eax),%al
  801501:	0f b6 d0             	movzbl %al,%edx
  801504:	8b 45 0c             	mov    0xc(%ebp),%eax
  801507:	8a 00                	mov    (%eax),%al
  801509:	0f b6 c0             	movzbl %al,%eax
  80150c:	29 c2                	sub    %eax,%edx
  80150e:	89 d0                	mov    %edx,%eax
}
  801510:	5d                   	pop    %ebp
  801511:	c3                   	ret    

00801512 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  801512:	55                   	push   %ebp
  801513:	89 e5                	mov    %esp,%ebp
  801515:	83 ec 04             	sub    $0x4,%esp
  801518:	8b 45 0c             	mov    0xc(%ebp),%eax
  80151b:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  80151e:	eb 12                	jmp    801532 <strchr+0x20>
		if (*s == c)
  801520:	8b 45 08             	mov    0x8(%ebp),%eax
  801523:	8a 00                	mov    (%eax),%al
  801525:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801528:	75 05                	jne    80152f <strchr+0x1d>
			return (char *) s;
  80152a:	8b 45 08             	mov    0x8(%ebp),%eax
  80152d:	eb 11                	jmp    801540 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  80152f:	ff 45 08             	incl   0x8(%ebp)
  801532:	8b 45 08             	mov    0x8(%ebp),%eax
  801535:	8a 00                	mov    (%eax),%al
  801537:	84 c0                	test   %al,%al
  801539:	75 e5                	jne    801520 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  80153b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801540:	c9                   	leave  
  801541:	c3                   	ret    

00801542 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  801542:	55                   	push   %ebp
  801543:	89 e5                	mov    %esp,%ebp
  801545:	83 ec 04             	sub    $0x4,%esp
  801548:	8b 45 0c             	mov    0xc(%ebp),%eax
  80154b:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  80154e:	eb 0d                	jmp    80155d <strfind+0x1b>
		if (*s == c)
  801550:	8b 45 08             	mov    0x8(%ebp),%eax
  801553:	8a 00                	mov    (%eax),%al
  801555:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801558:	74 0e                	je     801568 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  80155a:	ff 45 08             	incl   0x8(%ebp)
  80155d:	8b 45 08             	mov    0x8(%ebp),%eax
  801560:	8a 00                	mov    (%eax),%al
  801562:	84 c0                	test   %al,%al
  801564:	75 ea                	jne    801550 <strfind+0xe>
  801566:	eb 01                	jmp    801569 <strfind+0x27>
		if (*s == c)
			break;
  801568:	90                   	nop
	return (char *) s;
  801569:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80156c:	c9                   	leave  
  80156d:	c3                   	ret    

0080156e <memset>:

// *************** The faster implementation of memset & memcpy is implemented by *************
// ****************** Team80 (Yahia Khaled, Malek Ahmed et al) - FCIS'24-25 *******************
void *
memset(void *v, int c, uint32 n)
{
  80156e:	55                   	push   %ebp
  80156f:	89 e5                	mov    %esp,%ebp
  801571:	83 ec 10             	sub    $0x10,%esp
//	m = n;
//	while (--m >= 0)
//		*p++ = c;

	/*Faster Implementation*/
	uint64* p64 = (uint64*)v;
  801574:	8b 45 08             	mov    0x8(%ebp),%eax
  801577:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if(n >= 8){
  80157a:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  80157e:	76 63                	jbe    8015e3 <memset+0x75>
		uint64 data_block = c;
  801580:	8b 45 0c             	mov    0xc(%ebp),%eax
  801583:	99                   	cltd   
  801584:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801587:	89 55 f4             	mov    %edx,-0xc(%ebp)
		data_block |= data_block << 8;
  80158a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80158d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801590:	0f a4 c2 08          	shld   $0x8,%eax,%edx
  801594:	c1 e0 08             	shl    $0x8,%eax
  801597:	09 45 f0             	or     %eax,-0x10(%ebp)
  80159a:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 16;
  80159d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015a0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8015a3:	0f a4 c2 10          	shld   $0x10,%eax,%edx
  8015a7:	c1 e0 10             	shl    $0x10,%eax
  8015aa:	09 45 f0             	or     %eax,-0x10(%ebp)
  8015ad:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 32;
  8015b0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015b3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8015b6:	89 c2                	mov    %eax,%edx
  8015b8:	b8 00 00 00 00       	mov    $0x0,%eax
  8015bd:	09 45 f0             	or     %eax,-0x10(%ebp)
  8015c0:	09 55 f4             	or     %edx,-0xc(%ebp)

		while(n >= 8)
  8015c3:	eb 18                	jmp    8015dd <memset+0x6f>
			*p64++ = data_block, n -= 8;
  8015c5:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8015c8:	8d 41 08             	lea    0x8(%ecx),%eax
  8015cb:	89 45 fc             	mov    %eax,-0x4(%ebp)
  8015ce:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015d1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8015d4:	89 01                	mov    %eax,(%ecx)
  8015d6:	89 51 04             	mov    %edx,0x4(%ecx)
  8015d9:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
		uint64 data_block = c;
		data_block |= data_block << 8;
		data_block |= data_block << 16;
		data_block |= data_block << 32;

		while(n >= 8)
  8015dd:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  8015e1:	77 e2                	ja     8015c5 <memset+0x57>
			*p64++ = data_block, n -= 8;
	}

	if(n){
  8015e3:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8015e7:	74 23                	je     80160c <memset+0x9e>
		uint8* p8 = (uint8*)p64;
  8015e9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8015ec:	89 45 f8             	mov    %eax,-0x8(%ebp)
		while (n-- > 0)
  8015ef:	eb 0e                	jmp    8015ff <memset+0x91>
			*p8++ = (uint8)c;
  8015f1:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8015f4:	8d 50 01             	lea    0x1(%eax),%edx
  8015f7:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8015fa:	8b 55 0c             	mov    0xc(%ebp),%edx
  8015fd:	88 10                	mov    %dl,(%eax)
			*p64++ = data_block, n -= 8;
	}

	if(n){
		uint8* p8 = (uint8*)p64;
		while (n-- > 0)
  8015ff:	8b 45 10             	mov    0x10(%ebp),%eax
  801602:	8d 50 ff             	lea    -0x1(%eax),%edx
  801605:	89 55 10             	mov    %edx,0x10(%ebp)
  801608:	85 c0                	test   %eax,%eax
  80160a:	75 e5                	jne    8015f1 <memset+0x83>
			*p8++ = (uint8)c;
	}

	return v;
  80160c:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80160f:	c9                   	leave  
  801610:	c3                   	ret    

00801611 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  801611:	55                   	push   %ebp
  801612:	89 e5                	mov    %esp,%ebp
  801614:	83 ec 10             	sub    $0x10,%esp
	//	s = src;
	//	d = dst;
	//	while (n-- > 0)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
  801617:	8b 45 0c             	mov    0xc(%ebp),%eax
  80161a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	uint64* d64 = (uint64*)dst;
  80161d:	8b 45 08             	mov    0x8(%ebp),%eax
  801620:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if(n >= 8){
  801623:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  801627:	76 24                	jbe    80164d <memcpy+0x3c>
		while(n >= 8){
  801629:	eb 1c                	jmp    801647 <memcpy+0x36>
			*d64 = *s64;
  80162b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80162e:	8b 50 04             	mov    0x4(%eax),%edx
  801631:	8b 00                	mov    (%eax),%eax
  801633:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801636:	89 01                	mov    %eax,(%ecx)
  801638:	89 51 04             	mov    %edx,0x4(%ecx)
			n -= 8;
  80163b:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
			++s64;
  80163f:	83 45 fc 08          	addl   $0x8,-0x4(%ebp)
			++d64;
  801643:	83 45 f8 08          	addl   $0x8,-0x8(%ebp)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
	uint64* d64 = (uint64*)dst;
	if(n >= 8){
		while(n >= 8){
  801647:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  80164b:	77 de                	ja     80162b <memcpy+0x1a>
			++s64;
			++d64;
		}
	}

	if(n){
  80164d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801651:	74 31                	je     801684 <memcpy+0x73>
		uint8* s8 = (uint8*)s64;
  801653:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801656:	89 45 f4             	mov    %eax,-0xc(%ebp)
		uint8* d8 = (uint8*)d64;
  801659:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80165c:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (n-- > 0)
  80165f:	eb 16                	jmp    801677 <memcpy+0x66>
			*d8++ = *s8++;
  801661:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801664:	8d 50 01             	lea    0x1(%eax),%edx
  801667:	89 55 f0             	mov    %edx,-0x10(%ebp)
  80166a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80166d:	8d 4a 01             	lea    0x1(%edx),%ecx
  801670:	89 4d f4             	mov    %ecx,-0xc(%ebp)
  801673:	8a 12                	mov    (%edx),%dl
  801675:	88 10                	mov    %dl,(%eax)
	}

	if(n){
		uint8* s8 = (uint8*)s64;
		uint8* d8 = (uint8*)d64;
		while (n-- > 0)
  801677:	8b 45 10             	mov    0x10(%ebp),%eax
  80167a:	8d 50 ff             	lea    -0x1(%eax),%edx
  80167d:	89 55 10             	mov    %edx,0x10(%ebp)
  801680:	85 c0                	test   %eax,%eax
  801682:	75 dd                	jne    801661 <memcpy+0x50>
			*d8++ = *s8++;
	}
	return dst;
  801684:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801687:	c9                   	leave  
  801688:	c3                   	ret    

00801689 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  801689:	55                   	push   %ebp
  80168a:	89 e5                	mov    %esp,%ebp
  80168c:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  80168f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801692:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801695:	8b 45 08             	mov    0x8(%ebp),%eax
  801698:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  80169b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80169e:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8016a1:	73 50                	jae    8016f3 <memmove+0x6a>
  8016a3:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8016a6:	8b 45 10             	mov    0x10(%ebp),%eax
  8016a9:	01 d0                	add    %edx,%eax
  8016ab:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8016ae:	76 43                	jbe    8016f3 <memmove+0x6a>
		s += n;
  8016b0:	8b 45 10             	mov    0x10(%ebp),%eax
  8016b3:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  8016b6:	8b 45 10             	mov    0x10(%ebp),%eax
  8016b9:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  8016bc:	eb 10                	jmp    8016ce <memmove+0x45>
			*--d = *--s;
  8016be:	ff 4d f8             	decl   -0x8(%ebp)
  8016c1:	ff 4d fc             	decl   -0x4(%ebp)
  8016c4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8016c7:	8a 10                	mov    (%eax),%dl
  8016c9:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8016cc:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  8016ce:	8b 45 10             	mov    0x10(%ebp),%eax
  8016d1:	8d 50 ff             	lea    -0x1(%eax),%edx
  8016d4:	89 55 10             	mov    %edx,0x10(%ebp)
  8016d7:	85 c0                	test   %eax,%eax
  8016d9:	75 e3                	jne    8016be <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  8016db:	eb 23                	jmp    801700 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  8016dd:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8016e0:	8d 50 01             	lea    0x1(%eax),%edx
  8016e3:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8016e6:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8016e9:	8d 4a 01             	lea    0x1(%edx),%ecx
  8016ec:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  8016ef:	8a 12                	mov    (%edx),%dl
  8016f1:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  8016f3:	8b 45 10             	mov    0x10(%ebp),%eax
  8016f6:	8d 50 ff             	lea    -0x1(%eax),%edx
  8016f9:	89 55 10             	mov    %edx,0x10(%ebp)
  8016fc:	85 c0                	test   %eax,%eax
  8016fe:	75 dd                	jne    8016dd <memmove+0x54>
			*d++ = *s++;

	return dst;
  801700:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801703:	c9                   	leave  
  801704:	c3                   	ret    

00801705 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  801705:	55                   	push   %ebp
  801706:	89 e5                	mov    %esp,%ebp
  801708:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  80170b:	8b 45 08             	mov    0x8(%ebp),%eax
  80170e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  801711:	8b 45 0c             	mov    0xc(%ebp),%eax
  801714:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  801717:	eb 2a                	jmp    801743 <memcmp+0x3e>
		if (*s1 != *s2)
  801719:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80171c:	8a 10                	mov    (%eax),%dl
  80171e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801721:	8a 00                	mov    (%eax),%al
  801723:	38 c2                	cmp    %al,%dl
  801725:	74 16                	je     80173d <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  801727:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80172a:	8a 00                	mov    (%eax),%al
  80172c:	0f b6 d0             	movzbl %al,%edx
  80172f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801732:	8a 00                	mov    (%eax),%al
  801734:	0f b6 c0             	movzbl %al,%eax
  801737:	29 c2                	sub    %eax,%edx
  801739:	89 d0                	mov    %edx,%eax
  80173b:	eb 18                	jmp    801755 <memcmp+0x50>
		s1++, s2++;
  80173d:	ff 45 fc             	incl   -0x4(%ebp)
  801740:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  801743:	8b 45 10             	mov    0x10(%ebp),%eax
  801746:	8d 50 ff             	lea    -0x1(%eax),%edx
  801749:	89 55 10             	mov    %edx,0x10(%ebp)
  80174c:	85 c0                	test   %eax,%eax
  80174e:	75 c9                	jne    801719 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801750:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801755:	c9                   	leave  
  801756:	c3                   	ret    

00801757 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  801757:	55                   	push   %ebp
  801758:	89 e5                	mov    %esp,%ebp
  80175a:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  80175d:	8b 55 08             	mov    0x8(%ebp),%edx
  801760:	8b 45 10             	mov    0x10(%ebp),%eax
  801763:	01 d0                	add    %edx,%eax
  801765:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  801768:	eb 15                	jmp    80177f <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  80176a:	8b 45 08             	mov    0x8(%ebp),%eax
  80176d:	8a 00                	mov    (%eax),%al
  80176f:	0f b6 d0             	movzbl %al,%edx
  801772:	8b 45 0c             	mov    0xc(%ebp),%eax
  801775:	0f b6 c0             	movzbl %al,%eax
  801778:	39 c2                	cmp    %eax,%edx
  80177a:	74 0d                	je     801789 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  80177c:	ff 45 08             	incl   0x8(%ebp)
  80177f:	8b 45 08             	mov    0x8(%ebp),%eax
  801782:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801785:	72 e3                	jb     80176a <memfind+0x13>
  801787:	eb 01                	jmp    80178a <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  801789:	90                   	nop
	return (void *) s;
  80178a:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80178d:	c9                   	leave  
  80178e:	c3                   	ret    

0080178f <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  80178f:	55                   	push   %ebp
  801790:	89 e5                	mov    %esp,%ebp
  801792:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  801795:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  80179c:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8017a3:	eb 03                	jmp    8017a8 <strtol+0x19>
		s++;
  8017a5:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8017a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8017ab:	8a 00                	mov    (%eax),%al
  8017ad:	3c 20                	cmp    $0x20,%al
  8017af:	74 f4                	je     8017a5 <strtol+0x16>
  8017b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8017b4:	8a 00                	mov    (%eax),%al
  8017b6:	3c 09                	cmp    $0x9,%al
  8017b8:	74 eb                	je     8017a5 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  8017ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8017bd:	8a 00                	mov    (%eax),%al
  8017bf:	3c 2b                	cmp    $0x2b,%al
  8017c1:	75 05                	jne    8017c8 <strtol+0x39>
		s++;
  8017c3:	ff 45 08             	incl   0x8(%ebp)
  8017c6:	eb 13                	jmp    8017db <strtol+0x4c>
	else if (*s == '-')
  8017c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8017cb:	8a 00                	mov    (%eax),%al
  8017cd:	3c 2d                	cmp    $0x2d,%al
  8017cf:	75 0a                	jne    8017db <strtol+0x4c>
		s++, neg = 1;
  8017d1:	ff 45 08             	incl   0x8(%ebp)
  8017d4:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8017db:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8017df:	74 06                	je     8017e7 <strtol+0x58>
  8017e1:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  8017e5:	75 20                	jne    801807 <strtol+0x78>
  8017e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8017ea:	8a 00                	mov    (%eax),%al
  8017ec:	3c 30                	cmp    $0x30,%al
  8017ee:	75 17                	jne    801807 <strtol+0x78>
  8017f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8017f3:	40                   	inc    %eax
  8017f4:	8a 00                	mov    (%eax),%al
  8017f6:	3c 78                	cmp    $0x78,%al
  8017f8:	75 0d                	jne    801807 <strtol+0x78>
		s += 2, base = 16;
  8017fa:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  8017fe:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  801805:	eb 28                	jmp    80182f <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  801807:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80180b:	75 15                	jne    801822 <strtol+0x93>
  80180d:	8b 45 08             	mov    0x8(%ebp),%eax
  801810:	8a 00                	mov    (%eax),%al
  801812:	3c 30                	cmp    $0x30,%al
  801814:	75 0c                	jne    801822 <strtol+0x93>
		s++, base = 8;
  801816:	ff 45 08             	incl   0x8(%ebp)
  801819:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  801820:	eb 0d                	jmp    80182f <strtol+0xa0>
	else if (base == 0)
  801822:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801826:	75 07                	jne    80182f <strtol+0xa0>
		base = 10;
  801828:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  80182f:	8b 45 08             	mov    0x8(%ebp),%eax
  801832:	8a 00                	mov    (%eax),%al
  801834:	3c 2f                	cmp    $0x2f,%al
  801836:	7e 19                	jle    801851 <strtol+0xc2>
  801838:	8b 45 08             	mov    0x8(%ebp),%eax
  80183b:	8a 00                	mov    (%eax),%al
  80183d:	3c 39                	cmp    $0x39,%al
  80183f:	7f 10                	jg     801851 <strtol+0xc2>
			dig = *s - '0';
  801841:	8b 45 08             	mov    0x8(%ebp),%eax
  801844:	8a 00                	mov    (%eax),%al
  801846:	0f be c0             	movsbl %al,%eax
  801849:	83 e8 30             	sub    $0x30,%eax
  80184c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80184f:	eb 42                	jmp    801893 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  801851:	8b 45 08             	mov    0x8(%ebp),%eax
  801854:	8a 00                	mov    (%eax),%al
  801856:	3c 60                	cmp    $0x60,%al
  801858:	7e 19                	jle    801873 <strtol+0xe4>
  80185a:	8b 45 08             	mov    0x8(%ebp),%eax
  80185d:	8a 00                	mov    (%eax),%al
  80185f:	3c 7a                	cmp    $0x7a,%al
  801861:	7f 10                	jg     801873 <strtol+0xe4>
			dig = *s - 'a' + 10;
  801863:	8b 45 08             	mov    0x8(%ebp),%eax
  801866:	8a 00                	mov    (%eax),%al
  801868:	0f be c0             	movsbl %al,%eax
  80186b:	83 e8 57             	sub    $0x57,%eax
  80186e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801871:	eb 20                	jmp    801893 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  801873:	8b 45 08             	mov    0x8(%ebp),%eax
  801876:	8a 00                	mov    (%eax),%al
  801878:	3c 40                	cmp    $0x40,%al
  80187a:	7e 39                	jle    8018b5 <strtol+0x126>
  80187c:	8b 45 08             	mov    0x8(%ebp),%eax
  80187f:	8a 00                	mov    (%eax),%al
  801881:	3c 5a                	cmp    $0x5a,%al
  801883:	7f 30                	jg     8018b5 <strtol+0x126>
			dig = *s - 'A' + 10;
  801885:	8b 45 08             	mov    0x8(%ebp),%eax
  801888:	8a 00                	mov    (%eax),%al
  80188a:	0f be c0             	movsbl %al,%eax
  80188d:	83 e8 37             	sub    $0x37,%eax
  801890:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  801893:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801896:	3b 45 10             	cmp    0x10(%ebp),%eax
  801899:	7d 19                	jge    8018b4 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  80189b:	ff 45 08             	incl   0x8(%ebp)
  80189e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8018a1:	0f af 45 10          	imul   0x10(%ebp),%eax
  8018a5:	89 c2                	mov    %eax,%edx
  8018a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8018aa:	01 d0                	add    %edx,%eax
  8018ac:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  8018af:	e9 7b ff ff ff       	jmp    80182f <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  8018b4:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  8018b5:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8018b9:	74 08                	je     8018c3 <strtol+0x134>
		*endptr = (char *) s;
  8018bb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018be:	8b 55 08             	mov    0x8(%ebp),%edx
  8018c1:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  8018c3:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8018c7:	74 07                	je     8018d0 <strtol+0x141>
  8018c9:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8018cc:	f7 d8                	neg    %eax
  8018ce:	eb 03                	jmp    8018d3 <strtol+0x144>
  8018d0:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8018d3:	c9                   	leave  
  8018d4:	c3                   	ret    

008018d5 <ltostr>:

void
ltostr(long value, char *str)
{
  8018d5:	55                   	push   %ebp
  8018d6:	89 e5                	mov    %esp,%ebp
  8018d8:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  8018db:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  8018e2:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  8018e9:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8018ed:	79 13                	jns    801902 <ltostr+0x2d>
	{
		neg = 1;
  8018ef:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  8018f6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018f9:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  8018fc:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  8018ff:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  801902:	8b 45 08             	mov    0x8(%ebp),%eax
  801905:	b9 0a 00 00 00       	mov    $0xa,%ecx
  80190a:	99                   	cltd   
  80190b:	f7 f9                	idiv   %ecx
  80190d:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  801910:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801913:	8d 50 01             	lea    0x1(%eax),%edx
  801916:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801919:	89 c2                	mov    %eax,%edx
  80191b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80191e:	01 d0                	add    %edx,%eax
  801920:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801923:	83 c2 30             	add    $0x30,%edx
  801926:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  801928:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80192b:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801930:	f7 e9                	imul   %ecx
  801932:	c1 fa 02             	sar    $0x2,%edx
  801935:	89 c8                	mov    %ecx,%eax
  801937:	c1 f8 1f             	sar    $0x1f,%eax
  80193a:	29 c2                	sub    %eax,%edx
  80193c:	89 d0                	mov    %edx,%eax
  80193e:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  801941:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801945:	75 bb                	jne    801902 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801947:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  80194e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801951:	48                   	dec    %eax
  801952:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801955:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801959:	74 3d                	je     801998 <ltostr+0xc3>
		start = 1 ;
  80195b:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  801962:	eb 34                	jmp    801998 <ltostr+0xc3>
	{
		char tmp = str[start] ;
  801964:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801967:	8b 45 0c             	mov    0xc(%ebp),%eax
  80196a:	01 d0                	add    %edx,%eax
  80196c:	8a 00                	mov    (%eax),%al
  80196e:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801971:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801974:	8b 45 0c             	mov    0xc(%ebp),%eax
  801977:	01 c2                	add    %eax,%edx
  801979:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  80197c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80197f:	01 c8                	add    %ecx,%eax
  801981:	8a 00                	mov    (%eax),%al
  801983:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801985:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801988:	8b 45 0c             	mov    0xc(%ebp),%eax
  80198b:	01 c2                	add    %eax,%edx
  80198d:	8a 45 eb             	mov    -0x15(%ebp),%al
  801990:	88 02                	mov    %al,(%edx)
		start++ ;
  801992:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801995:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801998:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80199b:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80199e:	7c c4                	jl     801964 <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  8019a0:	8b 55 f8             	mov    -0x8(%ebp),%edx
  8019a3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8019a6:	01 d0                	add    %edx,%eax
  8019a8:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  8019ab:	90                   	nop
  8019ac:	c9                   	leave  
  8019ad:	c3                   	ret    

008019ae <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  8019ae:	55                   	push   %ebp
  8019af:	89 e5                	mov    %esp,%ebp
  8019b1:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  8019b4:	ff 75 08             	pushl  0x8(%ebp)
  8019b7:	e8 c4 f9 ff ff       	call   801380 <strlen>
  8019bc:	83 c4 04             	add    $0x4,%esp
  8019bf:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  8019c2:	ff 75 0c             	pushl  0xc(%ebp)
  8019c5:	e8 b6 f9 ff ff       	call   801380 <strlen>
  8019ca:	83 c4 04             	add    $0x4,%esp
  8019cd:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  8019d0:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  8019d7:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8019de:	eb 17                	jmp    8019f7 <strcconcat+0x49>
		final[s] = str1[s] ;
  8019e0:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8019e3:	8b 45 10             	mov    0x10(%ebp),%eax
  8019e6:	01 c2                	add    %eax,%edx
  8019e8:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8019eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8019ee:	01 c8                	add    %ecx,%eax
  8019f0:	8a 00                	mov    (%eax),%al
  8019f2:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  8019f4:	ff 45 fc             	incl   -0x4(%ebp)
  8019f7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8019fa:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8019fd:	7c e1                	jl     8019e0 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  8019ff:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  801a06:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  801a0d:	eb 1f                	jmp    801a2e <strcconcat+0x80>
		final[s++] = str2[i] ;
  801a0f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801a12:	8d 50 01             	lea    0x1(%eax),%edx
  801a15:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801a18:	89 c2                	mov    %eax,%edx
  801a1a:	8b 45 10             	mov    0x10(%ebp),%eax
  801a1d:	01 c2                	add    %eax,%edx
  801a1f:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801a22:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a25:	01 c8                	add    %ecx,%eax
  801a27:	8a 00                	mov    (%eax),%al
  801a29:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801a2b:	ff 45 f8             	incl   -0x8(%ebp)
  801a2e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801a31:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801a34:	7c d9                	jl     801a0f <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801a36:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801a39:	8b 45 10             	mov    0x10(%ebp),%eax
  801a3c:	01 d0                	add    %edx,%eax
  801a3e:	c6 00 00             	movb   $0x0,(%eax)
}
  801a41:	90                   	nop
  801a42:	c9                   	leave  
  801a43:	c3                   	ret    

00801a44 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801a44:	55                   	push   %ebp
  801a45:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801a47:	8b 45 14             	mov    0x14(%ebp),%eax
  801a4a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801a50:	8b 45 14             	mov    0x14(%ebp),%eax
  801a53:	8b 00                	mov    (%eax),%eax
  801a55:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801a5c:	8b 45 10             	mov    0x10(%ebp),%eax
  801a5f:	01 d0                	add    %edx,%eax
  801a61:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801a67:	eb 0c                	jmp    801a75 <strsplit+0x31>
			*string++ = 0;
  801a69:	8b 45 08             	mov    0x8(%ebp),%eax
  801a6c:	8d 50 01             	lea    0x1(%eax),%edx
  801a6f:	89 55 08             	mov    %edx,0x8(%ebp)
  801a72:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801a75:	8b 45 08             	mov    0x8(%ebp),%eax
  801a78:	8a 00                	mov    (%eax),%al
  801a7a:	84 c0                	test   %al,%al
  801a7c:	74 18                	je     801a96 <strsplit+0x52>
  801a7e:	8b 45 08             	mov    0x8(%ebp),%eax
  801a81:	8a 00                	mov    (%eax),%al
  801a83:	0f be c0             	movsbl %al,%eax
  801a86:	50                   	push   %eax
  801a87:	ff 75 0c             	pushl  0xc(%ebp)
  801a8a:	e8 83 fa ff ff       	call   801512 <strchr>
  801a8f:	83 c4 08             	add    $0x8,%esp
  801a92:	85 c0                	test   %eax,%eax
  801a94:	75 d3                	jne    801a69 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801a96:	8b 45 08             	mov    0x8(%ebp),%eax
  801a99:	8a 00                	mov    (%eax),%al
  801a9b:	84 c0                	test   %al,%al
  801a9d:	74 5a                	je     801af9 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801a9f:	8b 45 14             	mov    0x14(%ebp),%eax
  801aa2:	8b 00                	mov    (%eax),%eax
  801aa4:	83 f8 0f             	cmp    $0xf,%eax
  801aa7:	75 07                	jne    801ab0 <strsplit+0x6c>
		{
			return 0;
  801aa9:	b8 00 00 00 00       	mov    $0x0,%eax
  801aae:	eb 66                	jmp    801b16 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801ab0:	8b 45 14             	mov    0x14(%ebp),%eax
  801ab3:	8b 00                	mov    (%eax),%eax
  801ab5:	8d 48 01             	lea    0x1(%eax),%ecx
  801ab8:	8b 55 14             	mov    0x14(%ebp),%edx
  801abb:	89 0a                	mov    %ecx,(%edx)
  801abd:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801ac4:	8b 45 10             	mov    0x10(%ebp),%eax
  801ac7:	01 c2                	add    %eax,%edx
  801ac9:	8b 45 08             	mov    0x8(%ebp),%eax
  801acc:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801ace:	eb 03                	jmp    801ad3 <strsplit+0x8f>
			string++;
  801ad0:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801ad3:	8b 45 08             	mov    0x8(%ebp),%eax
  801ad6:	8a 00                	mov    (%eax),%al
  801ad8:	84 c0                	test   %al,%al
  801ada:	74 8b                	je     801a67 <strsplit+0x23>
  801adc:	8b 45 08             	mov    0x8(%ebp),%eax
  801adf:	8a 00                	mov    (%eax),%al
  801ae1:	0f be c0             	movsbl %al,%eax
  801ae4:	50                   	push   %eax
  801ae5:	ff 75 0c             	pushl  0xc(%ebp)
  801ae8:	e8 25 fa ff ff       	call   801512 <strchr>
  801aed:	83 c4 08             	add    $0x8,%esp
  801af0:	85 c0                	test   %eax,%eax
  801af2:	74 dc                	je     801ad0 <strsplit+0x8c>
			string++;
	}
  801af4:	e9 6e ff ff ff       	jmp    801a67 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801af9:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801afa:	8b 45 14             	mov    0x14(%ebp),%eax
  801afd:	8b 00                	mov    (%eax),%eax
  801aff:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801b06:	8b 45 10             	mov    0x10(%ebp),%eax
  801b09:	01 d0                	add    %edx,%eax
  801b0b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801b11:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801b16:	c9                   	leave  
  801b17:	c3                   	ret    

00801b18 <str2lower>:


char* str2lower(char *dst, const char *src)
{
  801b18:	55                   	push   %ebp
  801b19:	89 e5                	mov    %esp,%ebp
  801b1b:	83 ec 10             	sub    $0x10,%esp
	char* ret = dst;
  801b1e:	8b 45 08             	mov    0x8(%ebp),%eax
  801b21:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (int i = 0; i < strlen(src); ++i)
  801b24:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801b2b:	eb 4a                	jmp    801b77 <str2lower+0x5f>
	{
		dst[i] = src[i] ;
  801b2d:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801b30:	8b 45 08             	mov    0x8(%ebp),%eax
  801b33:	01 c2                	add    %eax,%edx
  801b35:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801b38:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b3b:	01 c8                	add    %ecx,%eax
  801b3d:	8a 00                	mov    (%eax),%al
  801b3f:	88 02                	mov    %al,(%edx)
		if (src[i] >= 'A' && src[i] <= 'Z')
  801b41:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801b44:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b47:	01 d0                	add    %edx,%eax
  801b49:	8a 00                	mov    (%eax),%al
  801b4b:	3c 40                	cmp    $0x40,%al
  801b4d:	7e 25                	jle    801b74 <str2lower+0x5c>
  801b4f:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801b52:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b55:	01 d0                	add    %edx,%eax
  801b57:	8a 00                	mov    (%eax),%al
  801b59:	3c 5a                	cmp    $0x5a,%al
  801b5b:	7f 17                	jg     801b74 <str2lower+0x5c>
		{
			dst[i] += 32 ;
  801b5d:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801b60:	8b 45 08             	mov    0x8(%ebp),%eax
  801b63:	01 d0                	add    %edx,%eax
  801b65:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801b68:	8b 55 08             	mov    0x8(%ebp),%edx
  801b6b:	01 ca                	add    %ecx,%edx
  801b6d:	8a 12                	mov    (%edx),%dl
  801b6f:	83 c2 20             	add    $0x20,%edx
  801b72:	88 10                	mov    %dl,(%eax)


char* str2lower(char *dst, const char *src)
{
	char* ret = dst;
	for (int i = 0; i < strlen(src); ++i)
  801b74:	ff 45 fc             	incl   -0x4(%ebp)
  801b77:	ff 75 0c             	pushl  0xc(%ebp)
  801b7a:	e8 01 f8 ff ff       	call   801380 <strlen>
  801b7f:	83 c4 04             	add    $0x4,%esp
  801b82:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801b85:	7f a6                	jg     801b2d <str2lower+0x15>
		if (src[i] >= 'A' && src[i] <= 'Z')
		{
			dst[i] += 32 ;
		}
	}
	return ret;
  801b87:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801b8a:	c9                   	leave  
  801b8b:	c3                   	ret    

00801b8c <uheap_init>:
//==============================================
// [1] INITIALIZE USER HEAP:
//==============================================
int __firstTimeFlag = 1;
void uheap_init()
{
  801b8c:	55                   	push   %ebp
  801b8d:	89 e5                	mov    %esp,%ebp
  801b8f:	83 ec 08             	sub    $0x8,%esp
	if(__firstTimeFlag)
  801b92:	a1 08 40 80 00       	mov    0x804008,%eax
  801b97:	85 c0                	test   %eax,%eax
  801b99:	74 42                	je     801bdd <uheap_init+0x51>
	{
		initialize_dynamic_allocator(USER_HEAP_START, USER_HEAP_START + DYN_ALLOC_MAX_SIZE);
  801b9b:	83 ec 08             	sub    $0x8,%esp
  801b9e:	68 00 00 00 82       	push   $0x82000000
  801ba3:	68 00 00 00 80       	push   $0x80000000
  801ba8:	e8 00 08 00 00       	call   8023ad <initialize_dynamic_allocator>
  801bad:	83 c4 10             	add    $0x10,%esp
		uheapPlaceStrategy = sys_get_uheap_strategy();
  801bb0:	e8 e7 05 00 00       	call   80219c <sys_get_uheap_strategy>
  801bb5:	a3 60 c0 81 00       	mov    %eax,0x81c060
		uheapPageAllocStart = dynAllocEnd + PAGE_SIZE;
  801bba:	a1 40 40 80 00       	mov    0x804040,%eax
  801bbf:	05 00 10 00 00       	add    $0x1000,%eax
  801bc4:	a3 10 c1 81 00       	mov    %eax,0x81c110
		uheapPageAllocBreak = uheapPageAllocStart;
  801bc9:	a1 10 c1 81 00       	mov    0x81c110,%eax
  801bce:	a3 68 c0 81 00       	mov    %eax,0x81c068

		__firstTimeFlag = 0;
  801bd3:	c7 05 08 40 80 00 00 	movl   $0x0,0x804008
  801bda:	00 00 00 
	}
}
  801bdd:	90                   	nop
  801bde:	c9                   	leave  
  801bdf:	c3                   	ret    

00801be0 <get_page>:

//==============================================
// [2] GET A PAGE FROM THE KERNEL FOR DA:
//==============================================
int get_page(void* va)
{
  801be0:	55                   	push   %ebp
  801be1:	89 e5                	mov    %esp,%ebp
  801be3:	83 ec 18             	sub    $0x18,%esp
	int ret = __sys_allocate_page(ROUNDDOWN(va, PAGE_SIZE), PERM_USER|PERM_WRITEABLE|PERM_UHPAGE);
  801be6:	8b 45 08             	mov    0x8(%ebp),%eax
  801be9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801bec:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801bef:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801bf4:	83 ec 08             	sub    $0x8,%esp
  801bf7:	68 06 04 00 00       	push   $0x406
  801bfc:	50                   	push   %eax
  801bfd:	e8 e4 01 00 00       	call   801de6 <__sys_allocate_page>
  801c02:	83 c4 10             	add    $0x10,%esp
  801c05:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (ret < 0)
  801c08:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801c0c:	79 14                	jns    801c22 <get_page+0x42>
		panic("get_page() in user: failed to allocate page from the kernel");
  801c0e:	83 ec 04             	sub    $0x4,%esp
  801c11:	68 3c 38 80 00       	push   $0x80383c
  801c16:	6a 1f                	push   $0x1f
  801c18:	68 78 38 80 00       	push   $0x803878
  801c1d:	e8 af eb ff ff       	call   8007d1 <_panic>
	return 0;
  801c22:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801c27:	c9                   	leave  
  801c28:	c3                   	ret    

00801c29 <return_page>:

//==============================================
// [3] RETURN A PAGE FROM THE DA TO KERNEL:
//==============================================
void return_page(void* va)
{
  801c29:	55                   	push   %ebp
  801c2a:	89 e5                	mov    %esp,%ebp
  801c2c:	83 ec 18             	sub    $0x18,%esp
	int ret = __sys_unmap_frame(ROUNDDOWN((uint32)va, PAGE_SIZE));
  801c2f:	8b 45 08             	mov    0x8(%ebp),%eax
  801c32:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801c35:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c38:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801c3d:	83 ec 0c             	sub    $0xc,%esp
  801c40:	50                   	push   %eax
  801c41:	e8 e7 01 00 00       	call   801e2d <__sys_unmap_frame>
  801c46:	83 c4 10             	add    $0x10,%esp
  801c49:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (ret < 0)
  801c4c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801c50:	79 14                	jns    801c66 <return_page+0x3d>
		panic("return_page() in user: failed to return a page to the kernel");
  801c52:	83 ec 04             	sub    $0x4,%esp
  801c55:	68 84 38 80 00       	push   $0x803884
  801c5a:	6a 2a                	push   $0x2a
  801c5c:	68 78 38 80 00       	push   $0x803878
  801c61:	e8 6b eb ff ff       	call   8007d1 <_panic>
}
  801c66:	90                   	nop
  801c67:	c9                   	leave  
  801c68:	c3                   	ret    

00801c69 <malloc>:

//=================================
// [1] ALLOCATE SPACE IN USER HEAP:
//=================================
void* malloc(uint32 size)
{
  801c69:	55                   	push   %ebp
  801c6a:	89 e5                	mov    %esp,%ebp
  801c6c:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  801c6f:	e8 18 ff ff ff       	call   801b8c <uheap_init>
	if (size == 0) return NULL ;
  801c74:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801c78:	75 07                	jne    801c81 <malloc+0x18>
  801c7a:	b8 00 00 00 00       	mov    $0x0,%eax
  801c7f:	eb 14                	jmp    801c95 <malloc+0x2c>
	//==============================================================
	//TODO: [PROJECT'25.IM#2] USER HEAP - #1 malloc
	//Your code is here
	//Comment the following line
	panic("malloc() is not implemented yet...!!");
  801c81:	83 ec 04             	sub    $0x4,%esp
  801c84:	68 c4 38 80 00       	push   $0x8038c4
  801c89:	6a 3e                	push   $0x3e
  801c8b:	68 78 38 80 00       	push   $0x803878
  801c90:	e8 3c eb ff ff       	call   8007d1 <_panic>
}
  801c95:	c9                   	leave  
  801c96:	c3                   	ret    

00801c97 <free>:

//=================================
// [2] FREE SPACE FROM USER HEAP:
//=================================
void free(void* virtual_address)
{
  801c97:	55                   	push   %ebp
  801c98:	89 e5                	mov    %esp,%ebp
  801c9a:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.IM#2] USER HEAP - #3 free
	//Your code is here
	//Comment the following line
	panic("free() is not implemented yet...!!");
  801c9d:	83 ec 04             	sub    $0x4,%esp
  801ca0:	68 ec 38 80 00       	push   $0x8038ec
  801ca5:	6a 49                	push   $0x49
  801ca7:	68 78 38 80 00       	push   $0x803878
  801cac:	e8 20 eb ff ff       	call   8007d1 <_panic>

00801cb1 <smalloc>:

//=================================
// [3] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  801cb1:	55                   	push   %ebp
  801cb2:	89 e5                	mov    %esp,%ebp
  801cb4:	83 ec 18             	sub    $0x18,%esp
  801cb7:	8b 45 10             	mov    0x10(%ebp),%eax
  801cba:	88 45 f4             	mov    %al,-0xc(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  801cbd:	e8 ca fe ff ff       	call   801b8c <uheap_init>
	if (size == 0) return NULL ;
  801cc2:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801cc6:	75 07                	jne    801ccf <smalloc+0x1e>
  801cc8:	b8 00 00 00 00       	mov    $0x0,%eax
  801ccd:	eb 14                	jmp    801ce3 <smalloc+0x32>
	//==============================================================

	//TODO: [PROJECT'25.IM#3] SHARED MEMORY - #2 smalloc
	//Your code is here
	//Comment the following line
	panic("smalloc() is not implemented yet...!!");
  801ccf:	83 ec 04             	sub    $0x4,%esp
  801cd2:	68 10 39 80 00       	push   $0x803910
  801cd7:	6a 5a                	push   $0x5a
  801cd9:	68 78 38 80 00       	push   $0x803878
  801cde:	e8 ee ea ff ff       	call   8007d1 <_panic>
}
  801ce3:	c9                   	leave  
  801ce4:	c3                   	ret    

00801ce5 <sget>:

//========================================
// [4] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801ce5:	55                   	push   %ebp
  801ce6:	89 e5                	mov    %esp,%ebp
  801ce8:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  801ceb:	e8 9c fe ff ff       	call   801b8c <uheap_init>
	//==============================================================

	//TODO: [PROJECT'25.IM#3] SHARED MEMORY - #4 sget
	//Your code is here
	//Comment the following line
	panic("sget() is not implemented yet...!!");
  801cf0:	83 ec 04             	sub    $0x4,%esp
  801cf3:	68 38 39 80 00       	push   $0x803938
  801cf8:	6a 6a                	push   $0x6a
  801cfa:	68 78 38 80 00       	push   $0x803878
  801cff:	e8 cd ea ff ff       	call   8007d1 <_panic>

00801d04 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801d04:	55                   	push   %ebp
  801d05:	89 e5                	mov    %esp,%ebp
  801d07:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  801d0a:	e8 7d fe ff ff       	call   801b8c <uheap_init>
	//==============================================================
	panic("realloc() is not implemented yet...!!");
  801d0f:	83 ec 04             	sub    $0x4,%esp
  801d12:	68 5c 39 80 00       	push   $0x80395c
  801d17:	68 88 00 00 00       	push   $0x88
  801d1c:	68 78 38 80 00       	push   $0x803878
  801d21:	e8 ab ea ff ff       	call   8007d1 <_panic>

00801d26 <sfree>:
//
//	use sys_delete_shared_object(...); which switches to the kernel mode,
//	calls delete_shared_object(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the delete_shared_object() function is empty, make sure to implement it.
void sfree(void* virtual_address)
{
  801d26:	55                   	push   %ebp
  801d27:	89 e5                	mov    %esp,%ebp
  801d29:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.BONUS#5] EXIT #2 - sfree
	//Your code is here
	//Comment the following line
	panic("sfree() is not implemented yet...!!");
  801d2c:	83 ec 04             	sub    $0x4,%esp
  801d2f:	68 84 39 80 00       	push   $0x803984
  801d34:	68 9b 00 00 00       	push   $0x9b
  801d39:	68 78 38 80 00       	push   $0x803878
  801d3e:	e8 8e ea ff ff       	call   8007d1 <_panic>

00801d43 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801d43:	55                   	push   %ebp
  801d44:	89 e5                	mov    %esp,%ebp
  801d46:	57                   	push   %edi
  801d47:	56                   	push   %esi
  801d48:	53                   	push   %ebx
  801d49:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801d4c:	8b 45 08             	mov    0x8(%ebp),%eax
  801d4f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d52:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801d55:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801d58:	8b 7d 18             	mov    0x18(%ebp),%edi
  801d5b:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801d5e:	cd 30                	int    $0x30
  801d60:	89 45 f0             	mov    %eax,-0x10(%ebp)
				"b" (a3),
				"D" (a4),
				"S" (a5)
				: "cc", "memory");

	return ret;
  801d63:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801d66:	83 c4 10             	add    $0x10,%esp
  801d69:	5b                   	pop    %ebx
  801d6a:	5e                   	pop    %esi
  801d6b:	5f                   	pop    %edi
  801d6c:	5d                   	pop    %ebp
  801d6d:	c3                   	ret    

00801d6e <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName, int color)
{
  801d6e:	55                   	push   %ebp
  801d6f:	89 e5                	mov    %esp,%ebp
  801d71:	83 ec 04             	sub    $0x4,%esp
  801d74:	8b 45 10             	mov    0x10(%ebp),%eax
  801d77:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, color, 0);
  801d7a:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801d7d:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801d81:	8b 45 08             	mov    0x8(%ebp),%eax
  801d84:	6a 00                	push   $0x0
  801d86:	51                   	push   %ecx
  801d87:	52                   	push   %edx
  801d88:	ff 75 0c             	pushl  0xc(%ebp)
  801d8b:	50                   	push   %eax
  801d8c:	6a 00                	push   $0x0
  801d8e:	e8 b0 ff ff ff       	call   801d43 <syscall>
  801d93:	83 c4 18             	add    $0x18,%esp
}
  801d96:	90                   	nop
  801d97:	c9                   	leave  
  801d98:	c3                   	ret    

00801d99 <sys_cgetc>:

int
sys_cgetc(void)
{
  801d99:	55                   	push   %ebp
  801d9a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801d9c:	6a 00                	push   $0x0
  801d9e:	6a 00                	push   $0x0
  801da0:	6a 00                	push   $0x0
  801da2:	6a 00                	push   $0x0
  801da4:	6a 00                	push   $0x0
  801da6:	6a 02                	push   $0x2
  801da8:	e8 96 ff ff ff       	call   801d43 <syscall>
  801dad:	83 c4 18             	add    $0x18,%esp
}
  801db0:	c9                   	leave  
  801db1:	c3                   	ret    

00801db2 <sys_lock_cons>:

void sys_lock_cons(void)
{
  801db2:	55                   	push   %ebp
  801db3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  801db5:	6a 00                	push   $0x0
  801db7:	6a 00                	push   $0x0
  801db9:	6a 00                	push   $0x0
  801dbb:	6a 00                	push   $0x0
  801dbd:	6a 00                	push   $0x0
  801dbf:	6a 03                	push   $0x3
  801dc1:	e8 7d ff ff ff       	call   801d43 <syscall>
  801dc6:	83 c4 18             	add    $0x18,%esp
}
  801dc9:	90                   	nop
  801dca:	c9                   	leave  
  801dcb:	c3                   	ret    

00801dcc <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  801dcc:	55                   	push   %ebp
  801dcd:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  801dcf:	6a 00                	push   $0x0
  801dd1:	6a 00                	push   $0x0
  801dd3:	6a 00                	push   $0x0
  801dd5:	6a 00                	push   $0x0
  801dd7:	6a 00                	push   $0x0
  801dd9:	6a 04                	push   $0x4
  801ddb:	e8 63 ff ff ff       	call   801d43 <syscall>
  801de0:	83 c4 18             	add    $0x18,%esp
}
  801de3:	90                   	nop
  801de4:	c9                   	leave  
  801de5:	c3                   	ret    

00801de6 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801de6:	55                   	push   %ebp
  801de7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801de9:	8b 55 0c             	mov    0xc(%ebp),%edx
  801dec:	8b 45 08             	mov    0x8(%ebp),%eax
  801def:	6a 00                	push   $0x0
  801df1:	6a 00                	push   $0x0
  801df3:	6a 00                	push   $0x0
  801df5:	52                   	push   %edx
  801df6:	50                   	push   %eax
  801df7:	6a 08                	push   $0x8
  801df9:	e8 45 ff ff ff       	call   801d43 <syscall>
  801dfe:	83 c4 18             	add    $0x18,%esp
}
  801e01:	c9                   	leave  
  801e02:	c3                   	ret    

00801e03 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801e03:	55                   	push   %ebp
  801e04:	89 e5                	mov    %esp,%ebp
  801e06:	56                   	push   %esi
  801e07:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801e08:	8b 75 18             	mov    0x18(%ebp),%esi
  801e0b:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801e0e:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801e11:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e14:	8b 45 08             	mov    0x8(%ebp),%eax
  801e17:	56                   	push   %esi
  801e18:	53                   	push   %ebx
  801e19:	51                   	push   %ecx
  801e1a:	52                   	push   %edx
  801e1b:	50                   	push   %eax
  801e1c:	6a 09                	push   $0x9
  801e1e:	e8 20 ff ff ff       	call   801d43 <syscall>
  801e23:	83 c4 18             	add    $0x18,%esp
}
  801e26:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801e29:	5b                   	pop    %ebx
  801e2a:	5e                   	pop    %esi
  801e2b:	5d                   	pop    %ebp
  801e2c:	c3                   	ret    

00801e2d <__sys_unmap_frame>:

int __sys_unmap_frame(uint32 va)
{
  801e2d:	55                   	push   %ebp
  801e2e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, va, 0, 0, 0, 0);
  801e30:	6a 00                	push   $0x0
  801e32:	6a 00                	push   $0x0
  801e34:	6a 00                	push   $0x0
  801e36:	6a 00                	push   $0x0
  801e38:	ff 75 08             	pushl  0x8(%ebp)
  801e3b:	6a 0a                	push   $0xa
  801e3d:	e8 01 ff ff ff       	call   801d43 <syscall>
  801e42:	83 c4 18             	add    $0x18,%esp
}
  801e45:	c9                   	leave  
  801e46:	c3                   	ret    

00801e47 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801e47:	55                   	push   %ebp
  801e48:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801e4a:	6a 00                	push   $0x0
  801e4c:	6a 00                	push   $0x0
  801e4e:	6a 00                	push   $0x0
  801e50:	ff 75 0c             	pushl  0xc(%ebp)
  801e53:	ff 75 08             	pushl  0x8(%ebp)
  801e56:	6a 0b                	push   $0xb
  801e58:	e8 e6 fe ff ff       	call   801d43 <syscall>
  801e5d:	83 c4 18             	add    $0x18,%esp
}
  801e60:	c9                   	leave  
  801e61:	c3                   	ret    

00801e62 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801e62:	55                   	push   %ebp
  801e63:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801e65:	6a 00                	push   $0x0
  801e67:	6a 00                	push   $0x0
  801e69:	6a 00                	push   $0x0
  801e6b:	6a 00                	push   $0x0
  801e6d:	6a 00                	push   $0x0
  801e6f:	6a 0c                	push   $0xc
  801e71:	e8 cd fe ff ff       	call   801d43 <syscall>
  801e76:	83 c4 18             	add    $0x18,%esp
}
  801e79:	c9                   	leave  
  801e7a:	c3                   	ret    

00801e7b <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801e7b:	55                   	push   %ebp
  801e7c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801e7e:	6a 00                	push   $0x0
  801e80:	6a 00                	push   $0x0
  801e82:	6a 00                	push   $0x0
  801e84:	6a 00                	push   $0x0
  801e86:	6a 00                	push   $0x0
  801e88:	6a 0d                	push   $0xd
  801e8a:	e8 b4 fe ff ff       	call   801d43 <syscall>
  801e8f:	83 c4 18             	add    $0x18,%esp
}
  801e92:	c9                   	leave  
  801e93:	c3                   	ret    

00801e94 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801e94:	55                   	push   %ebp
  801e95:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801e97:	6a 00                	push   $0x0
  801e99:	6a 00                	push   $0x0
  801e9b:	6a 00                	push   $0x0
  801e9d:	6a 00                	push   $0x0
  801e9f:	6a 00                	push   $0x0
  801ea1:	6a 0e                	push   $0xe
  801ea3:	e8 9b fe ff ff       	call   801d43 <syscall>
  801ea8:	83 c4 18             	add    $0x18,%esp
}
  801eab:	c9                   	leave  
  801eac:	c3                   	ret    

00801ead <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801ead:	55                   	push   %ebp
  801eae:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801eb0:	6a 00                	push   $0x0
  801eb2:	6a 00                	push   $0x0
  801eb4:	6a 00                	push   $0x0
  801eb6:	6a 00                	push   $0x0
  801eb8:	6a 00                	push   $0x0
  801eba:	6a 0f                	push   $0xf
  801ebc:	e8 82 fe ff ff       	call   801d43 <syscall>
  801ec1:	83 c4 18             	add    $0x18,%esp
}
  801ec4:	c9                   	leave  
  801ec5:	c3                   	ret    

00801ec6 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801ec6:	55                   	push   %ebp
  801ec7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801ec9:	6a 00                	push   $0x0
  801ecb:	6a 00                	push   $0x0
  801ecd:	6a 00                	push   $0x0
  801ecf:	6a 00                	push   $0x0
  801ed1:	ff 75 08             	pushl  0x8(%ebp)
  801ed4:	6a 10                	push   $0x10
  801ed6:	e8 68 fe ff ff       	call   801d43 <syscall>
  801edb:	83 c4 18             	add    $0x18,%esp
}
  801ede:	c9                   	leave  
  801edf:	c3                   	ret    

00801ee0 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801ee0:	55                   	push   %ebp
  801ee1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801ee3:	6a 00                	push   $0x0
  801ee5:	6a 00                	push   $0x0
  801ee7:	6a 00                	push   $0x0
  801ee9:	6a 00                	push   $0x0
  801eeb:	6a 00                	push   $0x0
  801eed:	6a 11                	push   $0x11
  801eef:	e8 4f fe ff ff       	call   801d43 <syscall>
  801ef4:	83 c4 18             	add    $0x18,%esp
}
  801ef7:	90                   	nop
  801ef8:	c9                   	leave  
  801ef9:	c3                   	ret    

00801efa <sys_cputc>:

void
sys_cputc(const char c)
{
  801efa:	55                   	push   %ebp
  801efb:	89 e5                	mov    %esp,%ebp
  801efd:	83 ec 04             	sub    $0x4,%esp
  801f00:	8b 45 08             	mov    0x8(%ebp),%eax
  801f03:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801f06:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801f0a:	6a 00                	push   $0x0
  801f0c:	6a 00                	push   $0x0
  801f0e:	6a 00                	push   $0x0
  801f10:	6a 00                	push   $0x0
  801f12:	50                   	push   %eax
  801f13:	6a 01                	push   $0x1
  801f15:	e8 29 fe ff ff       	call   801d43 <syscall>
  801f1a:	83 c4 18             	add    $0x18,%esp
}
  801f1d:	90                   	nop
  801f1e:	c9                   	leave  
  801f1f:	c3                   	ret    

00801f20 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801f20:	55                   	push   %ebp
  801f21:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801f23:	6a 00                	push   $0x0
  801f25:	6a 00                	push   $0x0
  801f27:	6a 00                	push   $0x0
  801f29:	6a 00                	push   $0x0
  801f2b:	6a 00                	push   $0x0
  801f2d:	6a 14                	push   $0x14
  801f2f:	e8 0f fe ff ff       	call   801d43 <syscall>
  801f34:	83 c4 18             	add    $0x18,%esp
}
  801f37:	90                   	nop
  801f38:	c9                   	leave  
  801f39:	c3                   	ret    

00801f3a <sys_create_shared_object>:

int sys_create_shared_object(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801f3a:	55                   	push   %ebp
  801f3b:	89 e5                	mov    %esp,%ebp
  801f3d:	83 ec 04             	sub    $0x4,%esp
  801f40:	8b 45 10             	mov    0x10(%ebp),%eax
  801f43:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801f46:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801f49:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801f4d:	8b 45 08             	mov    0x8(%ebp),%eax
  801f50:	6a 00                	push   $0x0
  801f52:	51                   	push   %ecx
  801f53:	52                   	push   %edx
  801f54:	ff 75 0c             	pushl  0xc(%ebp)
  801f57:	50                   	push   %eax
  801f58:	6a 15                	push   $0x15
  801f5a:	e8 e4 fd ff ff       	call   801d43 <syscall>
  801f5f:	83 c4 18             	add    $0x18,%esp
}
  801f62:	c9                   	leave  
  801f63:	c3                   	ret    

00801f64 <sys_size_of_shared_object>:

//2017:
int sys_size_of_shared_object(int32 ownerID, char* shareName)
{
  801f64:	55                   	push   %ebp
  801f65:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801f67:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f6a:	8b 45 08             	mov    0x8(%ebp),%eax
  801f6d:	6a 00                	push   $0x0
  801f6f:	6a 00                	push   $0x0
  801f71:	6a 00                	push   $0x0
  801f73:	52                   	push   %edx
  801f74:	50                   	push   %eax
  801f75:	6a 16                	push   $0x16
  801f77:	e8 c7 fd ff ff       	call   801d43 <syscall>
  801f7c:	83 c4 18             	add    $0x18,%esp
}
  801f7f:	c9                   	leave  
  801f80:	c3                   	ret    

00801f81 <sys_get_shared_object>:
//==========

int sys_get_shared_object(int32 ownerID, char* shareName, void* virtual_address)
{
  801f81:	55                   	push   %ebp
  801f82:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801f84:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801f87:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f8a:	8b 45 08             	mov    0x8(%ebp),%eax
  801f8d:	6a 00                	push   $0x0
  801f8f:	6a 00                	push   $0x0
  801f91:	51                   	push   %ecx
  801f92:	52                   	push   %edx
  801f93:	50                   	push   %eax
  801f94:	6a 17                	push   $0x17
  801f96:	e8 a8 fd ff ff       	call   801d43 <syscall>
  801f9b:	83 c4 18             	add    $0x18,%esp
}
  801f9e:	c9                   	leave  
  801f9f:	c3                   	ret    

00801fa0 <sys_delete_shared_object>:

int sys_delete_shared_object(int32 sharedObjectID, void *startVA)
{
  801fa0:	55                   	push   %ebp
  801fa1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801fa3:	8b 55 0c             	mov    0xc(%ebp),%edx
  801fa6:	8b 45 08             	mov    0x8(%ebp),%eax
  801fa9:	6a 00                	push   $0x0
  801fab:	6a 00                	push   $0x0
  801fad:	6a 00                	push   $0x0
  801faf:	52                   	push   %edx
  801fb0:	50                   	push   %eax
  801fb1:	6a 18                	push   $0x18
  801fb3:	e8 8b fd ff ff       	call   801d43 <syscall>
  801fb8:	83 c4 18             	add    $0x18,%esp
}
  801fbb:	c9                   	leave  
  801fbc:	c3                   	ret    

00801fbd <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801fbd:	55                   	push   %ebp
  801fbe:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801fc0:	8b 45 08             	mov    0x8(%ebp),%eax
  801fc3:	6a 00                	push   $0x0
  801fc5:	ff 75 14             	pushl  0x14(%ebp)
  801fc8:	ff 75 10             	pushl  0x10(%ebp)
  801fcb:	ff 75 0c             	pushl  0xc(%ebp)
  801fce:	50                   	push   %eax
  801fcf:	6a 19                	push   $0x19
  801fd1:	e8 6d fd ff ff       	call   801d43 <syscall>
  801fd6:	83 c4 18             	add    $0x18,%esp
}
  801fd9:	c9                   	leave  
  801fda:	c3                   	ret    

00801fdb <sys_run_env>:

void sys_run_env(int32 envId)
{
  801fdb:	55                   	push   %ebp
  801fdc:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801fde:	8b 45 08             	mov    0x8(%ebp),%eax
  801fe1:	6a 00                	push   $0x0
  801fe3:	6a 00                	push   $0x0
  801fe5:	6a 00                	push   $0x0
  801fe7:	6a 00                	push   $0x0
  801fe9:	50                   	push   %eax
  801fea:	6a 1a                	push   $0x1a
  801fec:	e8 52 fd ff ff       	call   801d43 <syscall>
  801ff1:	83 c4 18             	add    $0x18,%esp
}
  801ff4:	90                   	nop
  801ff5:	c9                   	leave  
  801ff6:	c3                   	ret    

00801ff7 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801ff7:	55                   	push   %ebp
  801ff8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801ffa:	8b 45 08             	mov    0x8(%ebp),%eax
  801ffd:	6a 00                	push   $0x0
  801fff:	6a 00                	push   $0x0
  802001:	6a 00                	push   $0x0
  802003:	6a 00                	push   $0x0
  802005:	50                   	push   %eax
  802006:	6a 1b                	push   $0x1b
  802008:	e8 36 fd ff ff       	call   801d43 <syscall>
  80200d:	83 c4 18             	add    $0x18,%esp
}
  802010:	c9                   	leave  
  802011:	c3                   	ret    

00802012 <sys_getenvid>:

int32 sys_getenvid(void)
{
  802012:	55                   	push   %ebp
  802013:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  802015:	6a 00                	push   $0x0
  802017:	6a 00                	push   $0x0
  802019:	6a 00                	push   $0x0
  80201b:	6a 00                	push   $0x0
  80201d:	6a 00                	push   $0x0
  80201f:	6a 05                	push   $0x5
  802021:	e8 1d fd ff ff       	call   801d43 <syscall>
  802026:	83 c4 18             	add    $0x18,%esp
}
  802029:	c9                   	leave  
  80202a:	c3                   	ret    

0080202b <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  80202b:	55                   	push   %ebp
  80202c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  80202e:	6a 00                	push   $0x0
  802030:	6a 00                	push   $0x0
  802032:	6a 00                	push   $0x0
  802034:	6a 00                	push   $0x0
  802036:	6a 00                	push   $0x0
  802038:	6a 06                	push   $0x6
  80203a:	e8 04 fd ff ff       	call   801d43 <syscall>
  80203f:	83 c4 18             	add    $0x18,%esp
}
  802042:	c9                   	leave  
  802043:	c3                   	ret    

00802044 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  802044:	55                   	push   %ebp
  802045:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  802047:	6a 00                	push   $0x0
  802049:	6a 00                	push   $0x0
  80204b:	6a 00                	push   $0x0
  80204d:	6a 00                	push   $0x0
  80204f:	6a 00                	push   $0x0
  802051:	6a 07                	push   $0x7
  802053:	e8 eb fc ff ff       	call   801d43 <syscall>
  802058:	83 c4 18             	add    $0x18,%esp
}
  80205b:	c9                   	leave  
  80205c:	c3                   	ret    

0080205d <sys_exit_env>:


void sys_exit_env(void)
{
  80205d:	55                   	push   %ebp
  80205e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  802060:	6a 00                	push   $0x0
  802062:	6a 00                	push   $0x0
  802064:	6a 00                	push   $0x0
  802066:	6a 00                	push   $0x0
  802068:	6a 00                	push   $0x0
  80206a:	6a 1c                	push   $0x1c
  80206c:	e8 d2 fc ff ff       	call   801d43 <syscall>
  802071:	83 c4 18             	add    $0x18,%esp
}
  802074:	90                   	nop
  802075:	c9                   	leave  
  802076:	c3                   	ret    

00802077 <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  802077:	55                   	push   %ebp
  802078:	89 e5                	mov    %esp,%ebp
  80207a:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  80207d:	8d 45 f8             	lea    -0x8(%ebp),%eax
  802080:	8d 50 04             	lea    0x4(%eax),%edx
  802083:	8d 45 f8             	lea    -0x8(%ebp),%eax
  802086:	6a 00                	push   $0x0
  802088:	6a 00                	push   $0x0
  80208a:	6a 00                	push   $0x0
  80208c:	52                   	push   %edx
  80208d:	50                   	push   %eax
  80208e:	6a 1d                	push   $0x1d
  802090:	e8 ae fc ff ff       	call   801d43 <syscall>
  802095:	83 c4 18             	add    $0x18,%esp
	return result;
  802098:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80209b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80209e:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8020a1:	89 01                	mov    %eax,(%ecx)
  8020a3:	89 51 04             	mov    %edx,0x4(%ecx)
}
  8020a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8020a9:	c9                   	leave  
  8020aa:	c2 04 00             	ret    $0x4

008020ad <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  8020ad:	55                   	push   %ebp
  8020ae:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  8020b0:	6a 00                	push   $0x0
  8020b2:	6a 00                	push   $0x0
  8020b4:	ff 75 10             	pushl  0x10(%ebp)
  8020b7:	ff 75 0c             	pushl  0xc(%ebp)
  8020ba:	ff 75 08             	pushl  0x8(%ebp)
  8020bd:	6a 13                	push   $0x13
  8020bf:	e8 7f fc ff ff       	call   801d43 <syscall>
  8020c4:	83 c4 18             	add    $0x18,%esp
	return ;
  8020c7:	90                   	nop
}
  8020c8:	c9                   	leave  
  8020c9:	c3                   	ret    

008020ca <sys_rcr2>:
uint32 sys_rcr2()
{
  8020ca:	55                   	push   %ebp
  8020cb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  8020cd:	6a 00                	push   $0x0
  8020cf:	6a 00                	push   $0x0
  8020d1:	6a 00                	push   $0x0
  8020d3:	6a 00                	push   $0x0
  8020d5:	6a 00                	push   $0x0
  8020d7:	6a 1e                	push   $0x1e
  8020d9:	e8 65 fc ff ff       	call   801d43 <syscall>
  8020de:	83 c4 18             	add    $0x18,%esp
}
  8020e1:	c9                   	leave  
  8020e2:	c3                   	ret    

008020e3 <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  8020e3:	55                   	push   %ebp
  8020e4:	89 e5                	mov    %esp,%ebp
  8020e6:	83 ec 04             	sub    $0x4,%esp
  8020e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8020ec:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  8020ef:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  8020f3:	6a 00                	push   $0x0
  8020f5:	6a 00                	push   $0x0
  8020f7:	6a 00                	push   $0x0
  8020f9:	6a 00                	push   $0x0
  8020fb:	50                   	push   %eax
  8020fc:	6a 1f                	push   $0x1f
  8020fe:	e8 40 fc ff ff       	call   801d43 <syscall>
  802103:	83 c4 18             	add    $0x18,%esp
	return ;
  802106:	90                   	nop
}
  802107:	c9                   	leave  
  802108:	c3                   	ret    

00802109 <rsttst>:
void rsttst()
{
  802109:	55                   	push   %ebp
  80210a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  80210c:	6a 00                	push   $0x0
  80210e:	6a 00                	push   $0x0
  802110:	6a 00                	push   $0x0
  802112:	6a 00                	push   $0x0
  802114:	6a 00                	push   $0x0
  802116:	6a 21                	push   $0x21
  802118:	e8 26 fc ff ff       	call   801d43 <syscall>
  80211d:	83 c4 18             	add    $0x18,%esp
	return ;
  802120:	90                   	nop
}
  802121:	c9                   	leave  
  802122:	c3                   	ret    

00802123 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  802123:	55                   	push   %ebp
  802124:	89 e5                	mov    %esp,%ebp
  802126:	83 ec 04             	sub    $0x4,%esp
  802129:	8b 45 14             	mov    0x14(%ebp),%eax
  80212c:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  80212f:	8b 55 18             	mov    0x18(%ebp),%edx
  802132:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  802136:	52                   	push   %edx
  802137:	50                   	push   %eax
  802138:	ff 75 10             	pushl  0x10(%ebp)
  80213b:	ff 75 0c             	pushl  0xc(%ebp)
  80213e:	ff 75 08             	pushl  0x8(%ebp)
  802141:	6a 20                	push   $0x20
  802143:	e8 fb fb ff ff       	call   801d43 <syscall>
  802148:	83 c4 18             	add    $0x18,%esp
	return ;
  80214b:	90                   	nop
}
  80214c:	c9                   	leave  
  80214d:	c3                   	ret    

0080214e <chktst>:
void chktst(uint32 n)
{
  80214e:	55                   	push   %ebp
  80214f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  802151:	6a 00                	push   $0x0
  802153:	6a 00                	push   $0x0
  802155:	6a 00                	push   $0x0
  802157:	6a 00                	push   $0x0
  802159:	ff 75 08             	pushl  0x8(%ebp)
  80215c:	6a 22                	push   $0x22
  80215e:	e8 e0 fb ff ff       	call   801d43 <syscall>
  802163:	83 c4 18             	add    $0x18,%esp
	return ;
  802166:	90                   	nop
}
  802167:	c9                   	leave  
  802168:	c3                   	ret    

00802169 <inctst>:

void inctst()
{
  802169:	55                   	push   %ebp
  80216a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  80216c:	6a 00                	push   $0x0
  80216e:	6a 00                	push   $0x0
  802170:	6a 00                	push   $0x0
  802172:	6a 00                	push   $0x0
  802174:	6a 00                	push   $0x0
  802176:	6a 23                	push   $0x23
  802178:	e8 c6 fb ff ff       	call   801d43 <syscall>
  80217d:	83 c4 18             	add    $0x18,%esp
	return ;
  802180:	90                   	nop
}
  802181:	c9                   	leave  
  802182:	c3                   	ret    

00802183 <gettst>:
uint32 gettst()
{
  802183:	55                   	push   %ebp
  802184:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  802186:	6a 00                	push   $0x0
  802188:	6a 00                	push   $0x0
  80218a:	6a 00                	push   $0x0
  80218c:	6a 00                	push   $0x0
  80218e:	6a 00                	push   $0x0
  802190:	6a 24                	push   $0x24
  802192:	e8 ac fb ff ff       	call   801d43 <syscall>
  802197:	83 c4 18             	add    $0x18,%esp
}
  80219a:	c9                   	leave  
  80219b:	c3                   	ret    

0080219c <sys_get_uheap_strategy>:

/*2025*/
uint32 sys_get_uheap_strategy()
{
  80219c:	55                   	push   %ebp
  80219d:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80219f:	6a 00                	push   $0x0
  8021a1:	6a 00                	push   $0x0
  8021a3:	6a 00                	push   $0x0
  8021a5:	6a 00                	push   $0x0
  8021a7:	6a 00                	push   $0x0
  8021a9:	6a 25                	push   $0x25
  8021ab:	e8 93 fb ff ff       	call   801d43 <syscall>
  8021b0:	83 c4 18             	add    $0x18,%esp
  8021b3:	a3 60 c0 81 00       	mov    %eax,0x81c060
	return uheapPlaceStrategy ;
  8021b8:	a1 60 c0 81 00       	mov    0x81c060,%eax
}
  8021bd:	c9                   	leave  
  8021be:	c3                   	ret    

008021bf <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  8021bf:	55                   	push   %ebp
  8021c0:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = heapStrategy;
  8021c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8021c5:	a3 60 c0 81 00       	mov    %eax,0x81c060
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  8021ca:	6a 00                	push   $0x0
  8021cc:	6a 00                	push   $0x0
  8021ce:	6a 00                	push   $0x0
  8021d0:	6a 00                	push   $0x0
  8021d2:	ff 75 08             	pushl  0x8(%ebp)
  8021d5:	6a 26                	push   $0x26
  8021d7:	e8 67 fb ff ff       	call   801d43 <syscall>
  8021dc:	83 c4 18             	add    $0x18,%esp
	return ;
  8021df:	90                   	nop
}
  8021e0:	c9                   	leave  
  8021e1:	c3                   	ret    

008021e2 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  8021e2:	55                   	push   %ebp
  8021e3:	89 e5                	mov    %esp,%ebp
  8021e5:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  8021e6:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8021e9:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8021ec:	8b 55 0c             	mov    0xc(%ebp),%edx
  8021ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8021f2:	6a 00                	push   $0x0
  8021f4:	53                   	push   %ebx
  8021f5:	51                   	push   %ecx
  8021f6:	52                   	push   %edx
  8021f7:	50                   	push   %eax
  8021f8:	6a 27                	push   $0x27
  8021fa:	e8 44 fb ff ff       	call   801d43 <syscall>
  8021ff:	83 c4 18             	add    $0x18,%esp
}
  802202:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802205:	c9                   	leave  
  802206:	c3                   	ret    

00802207 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  802207:	55                   	push   %ebp
  802208:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  80220a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80220d:	8b 45 08             	mov    0x8(%ebp),%eax
  802210:	6a 00                	push   $0x0
  802212:	6a 00                	push   $0x0
  802214:	6a 00                	push   $0x0
  802216:	52                   	push   %edx
  802217:	50                   	push   %eax
  802218:	6a 28                	push   $0x28
  80221a:	e8 24 fb ff ff       	call   801d43 <syscall>
  80221f:	83 c4 18             	add    $0x18,%esp
}
  802222:	c9                   	leave  
  802223:	c3                   	ret    

00802224 <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  802224:	55                   	push   %ebp
  802225:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  802227:	8b 4d 14             	mov    0x14(%ebp),%ecx
  80222a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80222d:	8b 45 08             	mov    0x8(%ebp),%eax
  802230:	6a 00                	push   $0x0
  802232:	51                   	push   %ecx
  802233:	ff 75 10             	pushl  0x10(%ebp)
  802236:	52                   	push   %edx
  802237:	50                   	push   %eax
  802238:	6a 29                	push   $0x29
  80223a:	e8 04 fb ff ff       	call   801d43 <syscall>
  80223f:	83 c4 18             	add    $0x18,%esp
}
  802242:	c9                   	leave  
  802243:	c3                   	ret    

00802244 <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  802244:	55                   	push   %ebp
  802245:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  802247:	6a 00                	push   $0x0
  802249:	6a 00                	push   $0x0
  80224b:	ff 75 10             	pushl  0x10(%ebp)
  80224e:	ff 75 0c             	pushl  0xc(%ebp)
  802251:	ff 75 08             	pushl  0x8(%ebp)
  802254:	6a 12                	push   $0x12
  802256:	e8 e8 fa ff ff       	call   801d43 <syscall>
  80225b:	83 c4 18             	add    $0x18,%esp
	return ;
  80225e:	90                   	nop
}
  80225f:	c9                   	leave  
  802260:	c3                   	ret    

00802261 <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  802261:	55                   	push   %ebp
  802262:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  802264:	8b 55 0c             	mov    0xc(%ebp),%edx
  802267:	8b 45 08             	mov    0x8(%ebp),%eax
  80226a:	6a 00                	push   $0x0
  80226c:	6a 00                	push   $0x0
  80226e:	6a 00                	push   $0x0
  802270:	52                   	push   %edx
  802271:	50                   	push   %eax
  802272:	6a 2a                	push   $0x2a
  802274:	e8 ca fa ff ff       	call   801d43 <syscall>
  802279:	83 c4 18             	add    $0x18,%esp
	return;
  80227c:	90                   	nop
}
  80227d:	c9                   	leave  
  80227e:	c3                   	ret    

0080227f <sys_get_optimal_num_faults>:
/*2025*/
int sys_get_optimal_num_faults()
{
  80227f:	55                   	push   %ebp
  802280:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_optimal_num_faults, 0, 0, 0, 0, 0);
  802282:	6a 00                	push   $0x0
  802284:	6a 00                	push   $0x0
  802286:	6a 00                	push   $0x0
  802288:	6a 00                	push   $0x0
  80228a:	6a 00                	push   $0x0
  80228c:	6a 2b                	push   $0x2b
  80228e:	e8 b0 fa ff ff       	call   801d43 <syscall>
  802293:	83 c4 18             	add    $0x18,%esp
}
  802296:	c9                   	leave  
  802297:	c3                   	ret    

00802298 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  802298:	55                   	push   %ebp
  802299:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  80229b:	6a 00                	push   $0x0
  80229d:	6a 00                	push   $0x0
  80229f:	6a 00                	push   $0x0
  8022a1:	ff 75 0c             	pushl  0xc(%ebp)
  8022a4:	ff 75 08             	pushl  0x8(%ebp)
  8022a7:	6a 2d                	push   $0x2d
  8022a9:	e8 95 fa ff ff       	call   801d43 <syscall>
  8022ae:	83 c4 18             	add    $0x18,%esp
	return;
  8022b1:	90                   	nop
}
  8022b2:	c9                   	leave  
  8022b3:	c3                   	ret    

008022b4 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  8022b4:	55                   	push   %ebp
  8022b5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  8022b7:	6a 00                	push   $0x0
  8022b9:	6a 00                	push   $0x0
  8022bb:	6a 00                	push   $0x0
  8022bd:	ff 75 0c             	pushl  0xc(%ebp)
  8022c0:	ff 75 08             	pushl  0x8(%ebp)
  8022c3:	6a 2c                	push   $0x2c
  8022c5:	e8 79 fa ff ff       	call   801d43 <syscall>
  8022ca:	83 c4 18             	add    $0x18,%esp
	return ;
  8022cd:	90                   	nop
}
  8022ce:	c9                   	leave  
  8022cf:	c3                   	ret    

008022d0 <sys_env_set_priority>:


void sys_env_set_priority(int32 envID, int priority)
{
  8022d0:	55                   	push   %ebp
  8022d1:	89 e5                	mov    %esp,%ebp
  8022d3:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.IM#4] CPU SCHEDULING - #1 System Calls - Add suitable code here
	//Your code is here
	//Comment the following line
	panic("sys_env_set_priority() is not implemented yet...!!");
  8022d6:	83 ec 04             	sub    $0x4,%esp
  8022d9:	68 a8 39 80 00       	push   $0x8039a8
  8022de:	68 25 01 00 00       	push   $0x125
  8022e3:	68 db 39 80 00       	push   $0x8039db
  8022e8:	e8 e4 e4 ff ff       	call   8007d1 <_panic>

008022ed <to_page_va>:
//==================================
//==================================
// [1] GET PAGE VA:
//==================================
__inline__ uint32 to_page_va(struct PageInfoElement *ptrPageInfo)
{
  8022ed:	55                   	push   %ebp
  8022ee:	89 e5                	mov    %esp,%ebp
  8022f0:	83 ec 18             	sub    $0x18,%esp
	if (ptrPageInfo < &pageBlockInfoArr[0] || ptrPageInfo >= &pageBlockInfoArr[DYN_ALLOC_MAX_SIZE/PAGE_SIZE])
  8022f3:	81 7d 08 60 40 80 00 	cmpl   $0x804060,0x8(%ebp)
  8022fa:	72 09                	jb     802305 <to_page_va+0x18>
  8022fc:	81 7d 08 60 c0 81 00 	cmpl   $0x81c060,0x8(%ebp)
  802303:	72 14                	jb     802319 <to_page_va+0x2c>
			panic("to_page_va called with invalid pageInfoPtr");
  802305:	83 ec 04             	sub    $0x4,%esp
  802308:	68 ec 39 80 00       	push   $0x8039ec
  80230d:	6a 15                	push   $0x15
  80230f:	68 17 3a 80 00       	push   $0x803a17
  802314:	e8 b8 e4 ff ff       	call   8007d1 <_panic>
	//Get start VA of the page from the corresponding Page Info pointer
	int idxInPageInfoArr = (ptrPageInfo - pageBlockInfoArr);
  802319:	8b 45 08             	mov    0x8(%ebp),%eax
  80231c:	ba 60 40 80 00       	mov    $0x804060,%edx
  802321:	29 d0                	sub    %edx,%eax
  802323:	c1 f8 02             	sar    $0x2,%eax
  802326:	89 c2                	mov    %eax,%edx
  802328:	89 d0                	mov    %edx,%eax
  80232a:	c1 e0 02             	shl    $0x2,%eax
  80232d:	01 d0                	add    %edx,%eax
  80232f:	c1 e0 02             	shl    $0x2,%eax
  802332:	01 d0                	add    %edx,%eax
  802334:	c1 e0 02             	shl    $0x2,%eax
  802337:	01 d0                	add    %edx,%eax
  802339:	89 c1                	mov    %eax,%ecx
  80233b:	c1 e1 08             	shl    $0x8,%ecx
  80233e:	01 c8                	add    %ecx,%eax
  802340:	89 c1                	mov    %eax,%ecx
  802342:	c1 e1 10             	shl    $0x10,%ecx
  802345:	01 c8                	add    %ecx,%eax
  802347:	01 c0                	add    %eax,%eax
  802349:	01 d0                	add    %edx,%eax
  80234b:	89 45 f4             	mov    %eax,-0xc(%ebp)
	return dynAllocStart + (idxInPageInfoArr << PGSHIFT);
  80234e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802351:	c1 e0 0c             	shl    $0xc,%eax
  802354:	89 c2                	mov    %eax,%edx
  802356:	a1 64 c0 81 00       	mov    0x81c064,%eax
  80235b:	01 d0                	add    %edx,%eax
}
  80235d:	c9                   	leave  
  80235e:	c3                   	ret    

0080235f <to_page_info>:

//==================================
// [2] GET PAGE INFO OF PAGE VA:
//==================================
__inline__ struct PageInfoElement * to_page_info(uint32 va)
{
  80235f:	55                   	push   %ebp
  802360:	89 e5                	mov    %esp,%ebp
  802362:	83 ec 18             	sub    $0x18,%esp
	int idxInPageInfoArr = (va - dynAllocStart) >> PGSHIFT;
  802365:	a1 64 c0 81 00       	mov    0x81c064,%eax
  80236a:	8b 55 08             	mov    0x8(%ebp),%edx
  80236d:	29 c2                	sub    %eax,%edx
  80236f:	89 d0                	mov    %edx,%eax
  802371:	c1 e8 0c             	shr    $0xc,%eax
  802374:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if (idxInPageInfoArr < 0 || idxInPageInfoArr >= DYN_ALLOC_MAX_SIZE/PAGE_SIZE)
  802377:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80237b:	78 09                	js     802386 <to_page_info+0x27>
  80237d:	81 7d f4 ff 1f 00 00 	cmpl   $0x1fff,-0xc(%ebp)
  802384:	7e 14                	jle    80239a <to_page_info+0x3b>
		panic("to_page_info called with invalid pa");
  802386:	83 ec 04             	sub    $0x4,%esp
  802389:	68 30 3a 80 00       	push   $0x803a30
  80238e:	6a 22                	push   $0x22
  802390:	68 17 3a 80 00       	push   $0x803a17
  802395:	e8 37 e4 ff ff       	call   8007d1 <_panic>
	return &pageBlockInfoArr[idxInPageInfoArr];
  80239a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80239d:	89 d0                	mov    %edx,%eax
  80239f:	01 c0                	add    %eax,%eax
  8023a1:	01 d0                	add    %edx,%eax
  8023a3:	c1 e0 02             	shl    $0x2,%eax
  8023a6:	05 60 40 80 00       	add    $0x804060,%eax
}
  8023ab:	c9                   	leave  
  8023ac:	c3                   	ret    

008023ad <initialize_dynamic_allocator>:
//==================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================
bool is_initialized = 0;
void initialize_dynamic_allocator(uint32 daStart, uint32 daEnd)
{
  8023ad:	55                   	push   %ebp
  8023ae:	89 e5                	mov    %esp,%ebp
  8023b0:	83 ec 18             	sub    $0x18,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		assert(daEnd <= daStart + DYN_ALLOC_MAX_SIZE);
  8023b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8023b6:	05 00 00 00 02       	add    $0x2000000,%eax
  8023bb:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8023be:	73 16                	jae    8023d6 <initialize_dynamic_allocator+0x29>
  8023c0:	68 54 3a 80 00       	push   $0x803a54
  8023c5:	68 7a 3a 80 00       	push   $0x803a7a
  8023ca:	6a 34                	push   $0x34
  8023cc:	68 17 3a 80 00       	push   $0x803a17
  8023d1:	e8 fb e3 ff ff       	call   8007d1 <_panic>
		is_initialized = 1;
  8023d6:	c7 05 28 40 80 00 01 	movl   $0x1,0x804028
  8023dd:	00 00 00 
	//==================================================================================
	//==================================================================================
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #1 initialize_dynamic_allocator
	//Your code is here
	// init bounds of the dynalloc
	dynAllocStart = daStart;
  8023e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8023e3:	a3 64 c0 81 00       	mov    %eax,0x81c064
	dynAllocEnd = daEnd;
  8023e8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8023eb:	a3 40 40 80 00       	mov    %eax,0x804040
	// init the list that keep track of all free pageBlockInfoArr instances.
	LIST_INIT(&freePagesList);
  8023f0:	c7 05 48 40 80 00 00 	movl   $0x0,0x804048
  8023f7:	00 00 00 
  8023fa:	c7 05 4c 40 80 00 00 	movl   $0x0,0x80404c
  802401:	00 00 00 
  802404:	c7 05 54 40 80 00 00 	movl   $0x0,0x804054
  80240b:	00 00 00 

	// no.of pages in the dynamic allocator.
	int pCount = (daEnd - daStart) / PAGE_SIZE;
  80240e:	8b 45 0c             	mov    0xc(%ebp),%eax
  802411:	2b 45 08             	sub    0x8(%ebp),%eax
  802414:	c1 e8 0c             	shr    $0xc,%eax
  802417:	89 45 ec             	mov    %eax,-0x14(%ebp)
	// iterate over each page and init its data in pageBlockInfoArr and reset it.
	for (int i = 0; i < pCount; ++i) {
  80241a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  802421:	e9 c8 00 00 00       	jmp    8024ee <initialize_dynamic_allocator+0x141>
	    pageBlockInfoArr[i].block_size = 0;
  802426:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802429:	89 d0                	mov    %edx,%eax
  80242b:	01 c0                	add    %eax,%eax
  80242d:	01 d0                	add    %edx,%eax
  80242f:	c1 e0 02             	shl    $0x2,%eax
  802432:	05 68 40 80 00       	add    $0x804068,%eax
  802437:	66 c7 00 00 00       	movw   $0x0,(%eax)
	    pageBlockInfoArr[i].num_of_free_blocks = 0;
  80243c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80243f:	89 d0                	mov    %edx,%eax
  802441:	01 c0                	add    %eax,%eax
  802443:	01 d0                	add    %edx,%eax
  802445:	c1 e0 02             	shl    $0x2,%eax
  802448:	05 6a 40 80 00       	add    $0x80406a,%eax
  80244d:	66 c7 00 00 00       	movw   $0x0,(%eax)
	    LIST_INSERT_TAIL(&freePagesList, &pageBlockInfoArr[i]);
  802452:	8b 15 4c 40 80 00    	mov    0x80404c,%edx
  802458:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  80245b:	89 c8                	mov    %ecx,%eax
  80245d:	01 c0                	add    %eax,%eax
  80245f:	01 c8                	add    %ecx,%eax
  802461:	c1 e0 02             	shl    $0x2,%eax
  802464:	05 64 40 80 00       	add    $0x804064,%eax
  802469:	89 10                	mov    %edx,(%eax)
  80246b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80246e:	89 d0                	mov    %edx,%eax
  802470:	01 c0                	add    %eax,%eax
  802472:	01 d0                	add    %edx,%eax
  802474:	c1 e0 02             	shl    $0x2,%eax
  802477:	05 64 40 80 00       	add    $0x804064,%eax
  80247c:	8b 00                	mov    (%eax),%eax
  80247e:	85 c0                	test   %eax,%eax
  802480:	74 1b                	je     80249d <initialize_dynamic_allocator+0xf0>
  802482:	8b 15 4c 40 80 00    	mov    0x80404c,%edx
  802488:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  80248b:	89 c8                	mov    %ecx,%eax
  80248d:	01 c0                	add    %eax,%eax
  80248f:	01 c8                	add    %ecx,%eax
  802491:	c1 e0 02             	shl    $0x2,%eax
  802494:	05 60 40 80 00       	add    $0x804060,%eax
  802499:	89 02                	mov    %eax,(%edx)
  80249b:	eb 16                	jmp    8024b3 <initialize_dynamic_allocator+0x106>
  80249d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8024a0:	89 d0                	mov    %edx,%eax
  8024a2:	01 c0                	add    %eax,%eax
  8024a4:	01 d0                	add    %edx,%eax
  8024a6:	c1 e0 02             	shl    $0x2,%eax
  8024a9:	05 60 40 80 00       	add    $0x804060,%eax
  8024ae:	a3 48 40 80 00       	mov    %eax,0x804048
  8024b3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8024b6:	89 d0                	mov    %edx,%eax
  8024b8:	01 c0                	add    %eax,%eax
  8024ba:	01 d0                	add    %edx,%eax
  8024bc:	c1 e0 02             	shl    $0x2,%eax
  8024bf:	05 60 40 80 00       	add    $0x804060,%eax
  8024c4:	a3 4c 40 80 00       	mov    %eax,0x80404c
  8024c9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8024cc:	89 d0                	mov    %edx,%eax
  8024ce:	01 c0                	add    %eax,%eax
  8024d0:	01 d0                	add    %edx,%eax
  8024d2:	c1 e0 02             	shl    $0x2,%eax
  8024d5:	05 60 40 80 00       	add    $0x804060,%eax
  8024da:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8024e0:	a1 54 40 80 00       	mov    0x804054,%eax
  8024e5:	40                   	inc    %eax
  8024e6:	a3 54 40 80 00       	mov    %eax,0x804054
	LIST_INIT(&freePagesList);

	// no.of pages in the dynamic allocator.
	int pCount = (daEnd - daStart) / PAGE_SIZE;
	// iterate over each page and init its data in pageBlockInfoArr and reset it.
	for (int i = 0; i < pCount; ++i) {
  8024eb:	ff 45 f4             	incl   -0xc(%ebp)
  8024ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024f1:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  8024f4:	0f 8c 2c ff ff ff    	jl     802426 <initialize_dynamic_allocator+0x79>
	    LIST_INSERT_TAIL(&freePagesList, &pageBlockInfoArr[i]);
	}
	// init the array of lists of each size..
	// 8 16 32 64 128 256 512 1024 2056
	// 0 1  2  3   4  5    6   7    8
	for (int i = 0; i <= (LOG2_MAX_SIZE - LOG2_MIN_SIZE); ++i){
  8024fa:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  802501:	eb 36                	jmp    802539 <initialize_dynamic_allocator+0x18c>
		LIST_INIT(&freeBlockLists[i]);
  802503:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802506:	c1 e0 04             	shl    $0x4,%eax
  802509:	05 80 c0 81 00       	add    $0x81c080,%eax
  80250e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802514:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802517:	c1 e0 04             	shl    $0x4,%eax
  80251a:	05 84 c0 81 00       	add    $0x81c084,%eax
  80251f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802525:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802528:	c1 e0 04             	shl    $0x4,%eax
  80252b:	05 8c c0 81 00       	add    $0x81c08c,%eax
  802530:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	    LIST_INSERT_TAIL(&freePagesList, &pageBlockInfoArr[i]);
	}
	// init the array of lists of each size..
	// 8 16 32 64 128 256 512 1024 2056
	// 0 1  2  3   4  5    6   7    8
	for (int i = 0; i <= (LOG2_MAX_SIZE - LOG2_MIN_SIZE); ++i){
  802536:	ff 45 f0             	incl   -0x10(%ebp)
  802539:	83 7d f0 08          	cmpl   $0x8,-0x10(%ebp)
  80253d:	7e c4                	jle    802503 <initialize_dynamic_allocator+0x156>
		LIST_INIT(&freeBlockLists[i]);
	}
	//Comment the following line
	//panic("initialize_dynamic_allocator() Not implemented yet");

}
  80253f:	90                   	nop
  802540:	c9                   	leave  
  802541:	c3                   	ret    

00802542 <get_block_size>:

//===========================
// [2] GET BLOCK SIZE:
//===========================
__inline__ uint32 get_block_size(void *va)
{
  802542:	55                   	push   %ebp
  802543:	89 e5                	mov    %esp,%ebp
  802545:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #2 get_block_size
	//Your code is here
	// get the page that saves this va
	struct PageInfoElement* ptr = to_page_info((uint32)va);
  802548:	8b 45 08             	mov    0x8(%ebp),%eax
  80254b:	83 ec 0c             	sub    $0xc,%esp
  80254e:	50                   	push   %eax
  80254f:	e8 0b fe ff ff       	call   80235f <to_page_info>
  802554:	83 c4 10             	add    $0x10,%esp
  802557:	89 45 f4             	mov    %eax,-0xc(%ebp)
	return ptr->block_size;
  80255a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80255d:	8b 40 08             	mov    0x8(%eax),%eax
  802560:	0f b7 c0             	movzwl %ax,%eax
	//Comment the following line
	//panic("get_block_size() Not implemented yet");
}
  802563:	c9                   	leave  
  802564:	c3                   	ret    

00802565 <split_page_to_blocks>:
// =====================
// h) split page to blocks and add them in freeBlockLists
// =====================
// function that split the page provided into same sized blocks
//and putem in suitable freeblockList index according to size.
 void split_page_to_blocks(uint32 blk_size, struct PageInfoElement *pageInfo) {
  802565:	55                   	push   %ebp
  802566:	89 e5                	mov    %esp,%ebp
  802568:	83 ec 28             	sub    $0x28,%esp
	 // cur page virtual address by the pageInfo.
	 uint32 page_va = (uint32)to_page_va(pageInfo);
  80256b:	83 ec 0c             	sub    $0xc,%esp
  80256e:	ff 75 0c             	pushl  0xc(%ebp)
  802571:	e8 77 fd ff ff       	call   8022ed <to_page_va>
  802576:	83 c4 10             	add    $0x10,%esp
  802579:	89 45 e8             	mov    %eax,-0x18(%ebp)
	 // no. of blks to save in freeblockList.
	 int blk_count = PAGE_SIZE / blk_size;
  80257c:	b8 00 10 00 00       	mov    $0x1000,%eax
  802581:	ba 00 00 00 00       	mov    $0x0,%edx
  802586:	f7 75 08             	divl   0x8(%ebp)
  802589:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	 // save page in memory.
	 get_page((uint32*)page_va);
  80258c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80258f:	83 ec 0c             	sub    $0xc,%esp
  802592:	50                   	push   %eax
  802593:	e8 48 f6 ff ff       	call   801be0 <get_page>
  802598:	83 c4 10             	add    $0x10,%esp
	 // assigning the pageInfo data block size, free block which is whole block count.
	 pageInfo->num_of_free_blocks = blk_count;
  80259b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80259e:	8b 55 0c             	mov    0xc(%ebp),%edx
  8025a1:	66 89 42 0a          	mov    %ax,0xa(%edx)
	 pageInfo->block_size = blk_size;
  8025a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8025a8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8025ab:	66 89 42 08          	mov    %ax,0x8(%edx)
	 // get index by size block in freeblocklist.
	 int idx = 0;
  8025af:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	 for (int i = LOG2_MIN_SIZE; i <= LOG2_MAX_SIZE; i++) {
  8025b6:	c7 45 f0 03 00 00 00 	movl   $0x3,-0x10(%ebp)
  8025bd:	eb 19                	jmp    8025d8 <split_page_to_blocks+0x73>
	     if ((1 << i) == blk_size)
  8025bf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025c2:	ba 01 00 00 00       	mov    $0x1,%edx
  8025c7:	88 c1                	mov    %al,%cl
  8025c9:	d3 e2                	shl    %cl,%edx
  8025cb:	89 d0                	mov    %edx,%eax
  8025cd:	3b 45 08             	cmp    0x8(%ebp),%eax
  8025d0:	74 0e                	je     8025e0 <split_page_to_blocks+0x7b>
	         break;
	     idx++;
  8025d2:	ff 45 f4             	incl   -0xc(%ebp)
	 // assigning the pageInfo data block size, free block which is whole block count.
	 pageInfo->num_of_free_blocks = blk_count;
	 pageInfo->block_size = blk_size;
	 // get index by size block in freeblocklist.
	 int idx = 0;
	 for (int i = LOG2_MIN_SIZE; i <= LOG2_MAX_SIZE; i++) {
  8025d5:	ff 45 f0             	incl   -0x10(%ebp)
  8025d8:	83 7d f0 0b          	cmpl   $0xb,-0x10(%ebp)
  8025dc:	7e e1                	jle    8025bf <split_page_to_blocks+0x5a>
  8025de:	eb 01                	jmp    8025e1 <split_page_to_blocks+0x7c>
	     if ((1 << i) == blk_size)
	         break;
  8025e0:	90                   	nop
	     idx++;
	 }
	 // iterate over each blk and make and element of it by passing its address in blockElement pointer and save those in the list.
	 // starting from the page_va.
	 for (uint32 i = 0; i < blk_count; ++i) {
  8025e1:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  8025e8:	e9 a7 00 00 00       	jmp    802694 <split_page_to_blocks+0x12f>
	     struct BlockElement *blk =(struct BlockElement*)(page_va + i * blk_size);
  8025ed:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8025f0:	0f af 45 08          	imul   0x8(%ebp),%eax
  8025f4:	89 c2                	mov    %eax,%edx
  8025f6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8025f9:	01 d0                	add    %edx,%eax
  8025fb:	89 45 e0             	mov    %eax,-0x20(%ebp)
	     LIST_INSERT_TAIL(&freeBlockLists[idx],blk);
  8025fe:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  802602:	75 14                	jne    802618 <split_page_to_blocks+0xb3>
  802604:	83 ec 04             	sub    $0x4,%esp
  802607:	68 90 3a 80 00       	push   $0x803a90
  80260c:	6a 7c                	push   $0x7c
  80260e:	68 17 3a 80 00       	push   $0x803a17
  802613:	e8 b9 e1 ff ff       	call   8007d1 <_panic>
  802618:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80261b:	c1 e0 04             	shl    $0x4,%eax
  80261e:	05 84 c0 81 00       	add    $0x81c084,%eax
  802623:	8b 10                	mov    (%eax),%edx
  802625:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802628:	89 50 04             	mov    %edx,0x4(%eax)
  80262b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80262e:	8b 40 04             	mov    0x4(%eax),%eax
  802631:	85 c0                	test   %eax,%eax
  802633:	74 14                	je     802649 <split_page_to_blocks+0xe4>
  802635:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802638:	c1 e0 04             	shl    $0x4,%eax
  80263b:	05 84 c0 81 00       	add    $0x81c084,%eax
  802640:	8b 00                	mov    (%eax),%eax
  802642:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802645:	89 10                	mov    %edx,(%eax)
  802647:	eb 11                	jmp    80265a <split_page_to_blocks+0xf5>
  802649:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80264c:	c1 e0 04             	shl    $0x4,%eax
  80264f:	8d 90 80 c0 81 00    	lea    0x81c080(%eax),%edx
  802655:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802658:	89 02                	mov    %eax,(%edx)
  80265a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80265d:	c1 e0 04             	shl    $0x4,%eax
  802660:	8d 90 84 c0 81 00    	lea    0x81c084(%eax),%edx
  802666:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802669:	89 02                	mov    %eax,(%edx)
  80266b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80266e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802674:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802677:	c1 e0 04             	shl    $0x4,%eax
  80267a:	05 8c c0 81 00       	add    $0x81c08c,%eax
  80267f:	8b 00                	mov    (%eax),%eax
  802681:	8d 50 01             	lea    0x1(%eax),%edx
  802684:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802687:	c1 e0 04             	shl    $0x4,%eax
  80268a:	05 8c c0 81 00       	add    $0x81c08c,%eax
  80268f:	89 10                	mov    %edx,(%eax)
	         break;
	     idx++;
	 }
	 // iterate over each blk and make and element of it by passing its address in blockElement pointer and save those in the list.
	 // starting from the page_va.
	 for (uint32 i = 0; i < blk_count; ++i) {
  802691:	ff 45 ec             	incl   -0x14(%ebp)
  802694:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802697:	39 45 ec             	cmp    %eax,-0x14(%ebp)
  80269a:	0f 82 4d ff ff ff    	jb     8025ed <split_page_to_blocks+0x88>
	     struct BlockElement *blk =(struct BlockElement*)(page_va + i * blk_size);
	     LIST_INSERT_TAIL(&freeBlockLists[idx],blk);
	 }
 }
  8026a0:	90                   	nop
  8026a1:	c9                   	leave  
  8026a2:	c3                   	ret    

008026a3 <alloc_block>:

//===========================
// 3) ALLOCATE BLOCK:
//===========================
void *alloc_block(uint32 size)
{
  8026a3:	55                   	push   %ebp
  8026a4:	89 e5                	mov    %esp,%ebp
  8026a6:	83 ec 38             	sub    $0x38,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		assert(size <= DYN_ALLOC_MAX_BLOCK_SIZE);
  8026a9:	81 7d 08 00 08 00 00 	cmpl   $0x800,0x8(%ebp)
  8026b0:	76 19                	jbe    8026cb <alloc_block+0x28>
  8026b2:	68 b4 3a 80 00       	push   $0x803ab4
  8026b7:	68 7a 3a 80 00       	push   $0x803a7a
  8026bc:	68 8a 00 00 00       	push   $0x8a
  8026c1:	68 17 3a 80 00       	push   $0x803a17
  8026c6:	e8 06 e1 ff ff       	call   8007d1 <_panic>
	//==================================================================================
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #3 alloc_block
	//Your code is here
	//Comment the following line
	// get index in freeBlockList by size.
	uint32 idx = 0;
  8026cb:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int i = LOG2_MIN_SIZE; i <= LOG2_MAX_SIZE; ++i){
  8026d2:	c7 45 f0 03 00 00 00 	movl   $0x3,-0x10(%ebp)
  8026d9:	eb 19                	jmp    8026f4 <alloc_block+0x51>
		if((1 << i) >= size) break;
  8026db:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8026de:	ba 01 00 00 00       	mov    $0x1,%edx
  8026e3:	88 c1                	mov    %al,%cl
  8026e5:	d3 e2                	shl    %cl,%edx
  8026e7:	89 d0                	mov    %edx,%eax
  8026e9:	3b 45 08             	cmp    0x8(%ebp),%eax
  8026ec:	73 0e                	jae    8026fc <alloc_block+0x59>
		idx++;
  8026ee:	ff 45 f4             	incl   -0xc(%ebp)
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #3 alloc_block
	//Your code is here
	//Comment the following line
	// get index in freeBlockList by size.
	uint32 idx = 0;
	for (int i = LOG2_MIN_SIZE; i <= LOG2_MAX_SIZE; ++i){
  8026f1:	ff 45 f0             	incl   -0x10(%ebp)
  8026f4:	83 7d f0 0b          	cmpl   $0xb,-0x10(%ebp)
  8026f8:	7e e1                	jle    8026db <alloc_block+0x38>
  8026fa:	eb 01                	jmp    8026fd <alloc_block+0x5a>
		if((1 << i) >= size) break;
  8026fc:	90                   	nop
		idx++;
	}

	//case 1: the free block of the cur size is available.
	if (freeBlockLists[idx].size > 0) {
  8026fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802700:	c1 e0 04             	shl    $0x4,%eax
  802703:	05 8c c0 81 00       	add    $0x81c08c,%eax
  802708:	8b 00                	mov    (%eax),%eax
  80270a:	85 c0                	test   %eax,%eax
  80270c:	0f 84 df 00 00 00    	je     8027f1 <alloc_block+0x14e>

		// remove from the list and updat the pageInfoArr free blocks.
		// pop from the freeBlockList.
		struct BlockElement *blk = LIST_FIRST(&freeBlockLists[idx]);
  802712:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802715:	c1 e0 04             	shl    $0x4,%eax
  802718:	05 80 c0 81 00       	add    $0x81c080,%eax
  80271d:	8b 00                	mov    (%eax),%eax
  80271f:	89 45 ec             	mov    %eax,-0x14(%ebp)
	    LIST_REMOVE(&freeBlockLists[idx], blk);
  802722:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802726:	75 17                	jne    80273f <alloc_block+0x9c>
  802728:	83 ec 04             	sub    $0x4,%esp
  80272b:	68 d5 3a 80 00       	push   $0x803ad5
  802730:	68 9e 00 00 00       	push   $0x9e
  802735:	68 17 3a 80 00       	push   $0x803a17
  80273a:	e8 92 e0 ff ff       	call   8007d1 <_panic>
  80273f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802742:	8b 00                	mov    (%eax),%eax
  802744:	85 c0                	test   %eax,%eax
  802746:	74 10                	je     802758 <alloc_block+0xb5>
  802748:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80274b:	8b 00                	mov    (%eax),%eax
  80274d:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802750:	8b 52 04             	mov    0x4(%edx),%edx
  802753:	89 50 04             	mov    %edx,0x4(%eax)
  802756:	eb 14                	jmp    80276c <alloc_block+0xc9>
  802758:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80275b:	8b 40 04             	mov    0x4(%eax),%eax
  80275e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802761:	c1 e2 04             	shl    $0x4,%edx
  802764:	81 c2 84 c0 81 00    	add    $0x81c084,%edx
  80276a:	89 02                	mov    %eax,(%edx)
  80276c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80276f:	8b 40 04             	mov    0x4(%eax),%eax
  802772:	85 c0                	test   %eax,%eax
  802774:	74 0f                	je     802785 <alloc_block+0xe2>
  802776:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802779:	8b 40 04             	mov    0x4(%eax),%eax
  80277c:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80277f:	8b 12                	mov    (%edx),%edx
  802781:	89 10                	mov    %edx,(%eax)
  802783:	eb 13                	jmp    802798 <alloc_block+0xf5>
  802785:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802788:	8b 00                	mov    (%eax),%eax
  80278a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80278d:	c1 e2 04             	shl    $0x4,%edx
  802790:	81 c2 80 c0 81 00    	add    $0x81c080,%edx
  802796:	89 02                	mov    %eax,(%edx)
  802798:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80279b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8027a1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8027a4:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8027ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027ae:	c1 e0 04             	shl    $0x4,%eax
  8027b1:	05 8c c0 81 00       	add    $0x81c08c,%eax
  8027b6:	8b 00                	mov    (%eax),%eax
  8027b8:	8d 50 ff             	lea    -0x1(%eax),%edx
  8027bb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027be:	c1 e0 04             	shl    $0x4,%eax
  8027c1:	05 8c c0 81 00       	add    $0x81c08c,%eax
  8027c6:	89 10                	mov    %edx,(%eax)
	    // update pageBlockInfoArr
	    struct PageInfoElement *pageInfo = to_page_info((uint32)blk);
  8027c8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8027cb:	83 ec 0c             	sub    $0xc,%esp
  8027ce:	50                   	push   %eax
  8027cf:	e8 8b fb ff ff       	call   80235f <to_page_info>
  8027d4:	83 c4 10             	add    $0x10,%esp
  8027d7:	89 45 e8             	mov    %eax,-0x18(%ebp)
	    pageInfo->num_of_free_blocks--;
  8027da:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8027dd:	66 8b 40 0a          	mov    0xa(%eax),%ax
  8027e1:	48                   	dec    %eax
  8027e2:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8027e5:	66 89 42 0a          	mov    %ax,0xa(%edx)
	    return blk;
  8027e9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8027ec:	e9 bc 02 00 00       	jmp    802aad <alloc_block+0x40a>
	}else{ //case(2, 3): 2. no free blocks available in the freeblocklist but there is free pages.
				//3. no free blocks and no available freepages so search in higher block sizes.
		// case 2:
		if(freePagesList.size > 0){ //have free pages.
  8027f1:	a1 54 40 80 00       	mov    0x804054,%eax
  8027f6:	85 c0                	test   %eax,%eax
  8027f8:	0f 84 7d 02 00 00    	je     802a7b <alloc_block+0x3d8>
			// get page to split and use from freepagesList.
			struct PageInfoElement *ptr_new_page = LIST_FIRST(&freePagesList);
  8027fe:	a1 48 40 80 00       	mov    0x804048,%eax
  802803:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			LIST_REMOVE(&freePagesList, ptr_new_page);
  802806:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80280a:	75 17                	jne    802823 <alloc_block+0x180>
  80280c:	83 ec 04             	sub    $0x4,%esp
  80280f:	68 d5 3a 80 00       	push   $0x803ad5
  802814:	68 a9 00 00 00       	push   $0xa9
  802819:	68 17 3a 80 00       	push   $0x803a17
  80281e:	e8 ae df ff ff       	call   8007d1 <_panic>
  802823:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802826:	8b 00                	mov    (%eax),%eax
  802828:	85 c0                	test   %eax,%eax
  80282a:	74 10                	je     80283c <alloc_block+0x199>
  80282c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80282f:	8b 00                	mov    (%eax),%eax
  802831:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802834:	8b 52 04             	mov    0x4(%edx),%edx
  802837:	89 50 04             	mov    %edx,0x4(%eax)
  80283a:	eb 0b                	jmp    802847 <alloc_block+0x1a4>
  80283c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80283f:	8b 40 04             	mov    0x4(%eax),%eax
  802842:	a3 4c 40 80 00       	mov    %eax,0x80404c
  802847:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80284a:	8b 40 04             	mov    0x4(%eax),%eax
  80284d:	85 c0                	test   %eax,%eax
  80284f:	74 0f                	je     802860 <alloc_block+0x1bd>
  802851:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802854:	8b 40 04             	mov    0x4(%eax),%eax
  802857:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80285a:	8b 12                	mov    (%edx),%edx
  80285c:	89 10                	mov    %edx,(%eax)
  80285e:	eb 0a                	jmp    80286a <alloc_block+0x1c7>
  802860:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802863:	8b 00                	mov    (%eax),%eax
  802865:	a3 48 40 80 00       	mov    %eax,0x804048
  80286a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80286d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802873:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802876:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80287d:	a1 54 40 80 00       	mov    0x804054,%eax
  802882:	48                   	dec    %eax
  802883:	a3 54 40 80 00       	mov    %eax,0x804054
			// from page to freeblockList by the pageInfo and the block size.
			split_page_to_blocks(1 << (idx + LOG2_MIN_SIZE), ptr_new_page);
  802888:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80288b:	83 c0 03             	add    $0x3,%eax
  80288e:	ba 01 00 00 00       	mov    $0x1,%edx
  802893:	88 c1                	mov    %al,%cl
  802895:	d3 e2                	shl    %cl,%edx
  802897:	89 d0                	mov    %edx,%eax
  802899:	83 ec 08             	sub    $0x8,%esp
  80289c:	ff 75 e4             	pushl  -0x1c(%ebp)
  80289f:	50                   	push   %eax
  8028a0:	e8 c0 fc ff ff       	call   802565 <split_page_to_blocks>
  8028a5:	83 c4 10             	add    $0x10,%esp

			// remove from the list and updat the pageInfoArr free blocks.
			// pop from the freeBlockList.
			struct BlockElement *blk = LIST_FIRST(&freeBlockLists[idx]);
  8028a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028ab:	c1 e0 04             	shl    $0x4,%eax
  8028ae:	05 80 c0 81 00       	add    $0x81c080,%eax
  8028b3:	8b 00                	mov    (%eax),%eax
  8028b5:	89 45 e0             	mov    %eax,-0x20(%ebp)
		    LIST_REMOVE(&freeBlockLists[idx], blk);
  8028b8:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8028bc:	75 17                	jne    8028d5 <alloc_block+0x232>
  8028be:	83 ec 04             	sub    $0x4,%esp
  8028c1:	68 d5 3a 80 00       	push   $0x803ad5
  8028c6:	68 b0 00 00 00       	push   $0xb0
  8028cb:	68 17 3a 80 00       	push   $0x803a17
  8028d0:	e8 fc de ff ff       	call   8007d1 <_panic>
  8028d5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8028d8:	8b 00                	mov    (%eax),%eax
  8028da:	85 c0                	test   %eax,%eax
  8028dc:	74 10                	je     8028ee <alloc_block+0x24b>
  8028de:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8028e1:	8b 00                	mov    (%eax),%eax
  8028e3:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8028e6:	8b 52 04             	mov    0x4(%edx),%edx
  8028e9:	89 50 04             	mov    %edx,0x4(%eax)
  8028ec:	eb 14                	jmp    802902 <alloc_block+0x25f>
  8028ee:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8028f1:	8b 40 04             	mov    0x4(%eax),%eax
  8028f4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8028f7:	c1 e2 04             	shl    $0x4,%edx
  8028fa:	81 c2 84 c0 81 00    	add    $0x81c084,%edx
  802900:	89 02                	mov    %eax,(%edx)
  802902:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802905:	8b 40 04             	mov    0x4(%eax),%eax
  802908:	85 c0                	test   %eax,%eax
  80290a:	74 0f                	je     80291b <alloc_block+0x278>
  80290c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80290f:	8b 40 04             	mov    0x4(%eax),%eax
  802912:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802915:	8b 12                	mov    (%edx),%edx
  802917:	89 10                	mov    %edx,(%eax)
  802919:	eb 13                	jmp    80292e <alloc_block+0x28b>
  80291b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80291e:	8b 00                	mov    (%eax),%eax
  802920:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802923:	c1 e2 04             	shl    $0x4,%edx
  802926:	81 c2 80 c0 81 00    	add    $0x81c080,%edx
  80292c:	89 02                	mov    %eax,(%edx)
  80292e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802931:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802937:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80293a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802941:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802944:	c1 e0 04             	shl    $0x4,%eax
  802947:	05 8c c0 81 00       	add    $0x81c08c,%eax
  80294c:	8b 00                	mov    (%eax),%eax
  80294e:	8d 50 ff             	lea    -0x1(%eax),%edx
  802951:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802954:	c1 e0 04             	shl    $0x4,%eax
  802957:	05 8c c0 81 00       	add    $0x81c08c,%eax
  80295c:	89 10                	mov    %edx,(%eax)
		    // update pageBlockInfoArr
		    struct PageInfoElement *pageInfo = to_page_info((uint32)blk);
  80295e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802961:	83 ec 0c             	sub    $0xc,%esp
  802964:	50                   	push   %eax
  802965:	e8 f5 f9 ff ff       	call   80235f <to_page_info>
  80296a:	83 c4 10             	add    $0x10,%esp
  80296d:	89 45 dc             	mov    %eax,-0x24(%ebp)
		    pageInfo->num_of_free_blocks--;
  802970:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802973:	66 8b 40 0a          	mov    0xa(%eax),%ax
  802977:	48                   	dec    %eax
  802978:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80297b:	66 89 42 0a          	mov    %ax,0xa(%edx)
		    return blk;
  80297f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802982:	e9 26 01 00 00       	jmp    802aad <alloc_block+0x40a>
		}else{//case 3: no free block and no free page so iterate and try to find bigger size.
			// iterate over the list until finding available block
			while (idx <= (LOG2_MAX_SIZE - LOG2_MIN_SIZE) && freeBlockLists[idx].size == 0) {
				idx++;
  802987:	ff 45 f4             	incl   -0xc(%ebp)
				// found free block
				if(freeBlockLists[idx].size > 0){
  80298a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80298d:	c1 e0 04             	shl    $0x4,%eax
  802990:	05 8c c0 81 00       	add    $0x81c08c,%eax
  802995:	8b 00                	mov    (%eax),%eax
  802997:	85 c0                	test   %eax,%eax
  802999:	0f 84 dc 00 00 00    	je     802a7b <alloc_block+0x3d8>
					// remove from the list and updat the pageInfoArr free blocks.
					// pop from the freeBlockList.
					struct BlockElement *blk = LIST_FIRST(&freeBlockLists[idx]);
  80299f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029a2:	c1 e0 04             	shl    $0x4,%eax
  8029a5:	05 80 c0 81 00       	add    $0x81c080,%eax
  8029aa:	8b 00                	mov    (%eax),%eax
  8029ac:	89 45 d8             	mov    %eax,-0x28(%ebp)
				    LIST_REMOVE(&freeBlockLists[idx], blk);
  8029af:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8029b3:	75 17                	jne    8029cc <alloc_block+0x329>
  8029b5:	83 ec 04             	sub    $0x4,%esp
  8029b8:	68 d5 3a 80 00       	push   $0x803ad5
  8029bd:	68 be 00 00 00       	push   $0xbe
  8029c2:	68 17 3a 80 00       	push   $0x803a17
  8029c7:	e8 05 de ff ff       	call   8007d1 <_panic>
  8029cc:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8029cf:	8b 00                	mov    (%eax),%eax
  8029d1:	85 c0                	test   %eax,%eax
  8029d3:	74 10                	je     8029e5 <alloc_block+0x342>
  8029d5:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8029d8:	8b 00                	mov    (%eax),%eax
  8029da:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8029dd:	8b 52 04             	mov    0x4(%edx),%edx
  8029e0:	89 50 04             	mov    %edx,0x4(%eax)
  8029e3:	eb 14                	jmp    8029f9 <alloc_block+0x356>
  8029e5:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8029e8:	8b 40 04             	mov    0x4(%eax),%eax
  8029eb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8029ee:	c1 e2 04             	shl    $0x4,%edx
  8029f1:	81 c2 84 c0 81 00    	add    $0x81c084,%edx
  8029f7:	89 02                	mov    %eax,(%edx)
  8029f9:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8029fc:	8b 40 04             	mov    0x4(%eax),%eax
  8029ff:	85 c0                	test   %eax,%eax
  802a01:	74 0f                	je     802a12 <alloc_block+0x36f>
  802a03:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802a06:	8b 40 04             	mov    0x4(%eax),%eax
  802a09:	8b 55 d8             	mov    -0x28(%ebp),%edx
  802a0c:	8b 12                	mov    (%edx),%edx
  802a0e:	89 10                	mov    %edx,(%eax)
  802a10:	eb 13                	jmp    802a25 <alloc_block+0x382>
  802a12:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802a15:	8b 00                	mov    (%eax),%eax
  802a17:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802a1a:	c1 e2 04             	shl    $0x4,%edx
  802a1d:	81 c2 80 c0 81 00    	add    $0x81c080,%edx
  802a23:	89 02                	mov    %eax,(%edx)
  802a25:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802a28:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802a2e:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802a31:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802a38:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a3b:	c1 e0 04             	shl    $0x4,%eax
  802a3e:	05 8c c0 81 00       	add    $0x81c08c,%eax
  802a43:	8b 00                	mov    (%eax),%eax
  802a45:	8d 50 ff             	lea    -0x1(%eax),%edx
  802a48:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a4b:	c1 e0 04             	shl    $0x4,%eax
  802a4e:	05 8c c0 81 00       	add    $0x81c08c,%eax
  802a53:	89 10                	mov    %edx,(%eax)
				    // update pageBlockInfoArr
				    struct PageInfoElement *pageInfo = to_page_info((uint32)blk);
  802a55:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802a58:	83 ec 0c             	sub    $0xc,%esp
  802a5b:	50                   	push   %eax
  802a5c:	e8 fe f8 ff ff       	call   80235f <to_page_info>
  802a61:	83 c4 10             	add    $0x10,%esp
  802a64:	89 45 d4             	mov    %eax,-0x2c(%ebp)
				    pageInfo->num_of_free_blocks--;
  802a67:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802a6a:	66 8b 40 0a          	mov    0xa(%eax),%ax
  802a6e:	48                   	dec    %eax
  802a6f:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  802a72:	66 89 42 0a          	mov    %ax,0xa(%edx)
				    return blk;
  802a76:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802a79:	eb 32                	jmp    802aad <alloc_block+0x40a>
		    struct PageInfoElement *pageInfo = to_page_info((uint32)blk);
		    pageInfo->num_of_free_blocks--;
		    return blk;
		}else{//case 3: no free block and no free page so iterate and try to find bigger size.
			// iterate over the list until finding available block
			while (idx <= (LOG2_MAX_SIZE - LOG2_MIN_SIZE) && freeBlockLists[idx].size == 0) {
  802a7b:	83 7d f4 08          	cmpl   $0x8,-0xc(%ebp)
  802a7f:	77 15                	ja     802a96 <alloc_block+0x3f3>
  802a81:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a84:	c1 e0 04             	shl    $0x4,%eax
  802a87:	05 8c c0 81 00       	add    $0x81c08c,%eax
  802a8c:	8b 00                	mov    (%eax),%eax
  802a8e:	85 c0                	test   %eax,%eax
  802a90:	0f 84 f1 fe ff ff    	je     802987 <alloc_block+0x2e4>
				}
			}
		}
	}
	//case4: no free blocks or pages.
	panic("no free blocks!");
  802a96:	83 ec 04             	sub    $0x4,%esp
  802a99:	68 f3 3a 80 00       	push   $0x803af3
  802a9e:	68 c8 00 00 00       	push   $0xc8
  802aa3:	68 17 3a 80 00       	push   $0x803a17
  802aa8:	e8 24 dd ff ff       	call   8007d1 <_panic>
	//panic("alloc_block() Not implemented yet");
	//TODO: [PROJECT'25.BONUS#1] DYNAMIC ALLOCATOR - block if no free block
	return NULL;
}
  802aad:	c9                   	leave  
  802aae:	c3                   	ret    

00802aaf <free_block>:

//===========================
// [4] FREE BLOCK:
//===========================
void free_block(void *va)
{
  802aaf:	55                   	push   %ebp
  802ab0:	89 e5                	mov    %esp,%ebp
  802ab2:	83 ec 38             	sub    $0x38,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		assert((uint32)va >= dynAllocStart && (uint32)va < dynAllocEnd);
  802ab5:	8b 55 08             	mov    0x8(%ebp),%edx
  802ab8:	a1 64 c0 81 00       	mov    0x81c064,%eax
  802abd:	39 c2                	cmp    %eax,%edx
  802abf:	72 0c                	jb     802acd <free_block+0x1e>
  802ac1:	8b 55 08             	mov    0x8(%ebp),%edx
  802ac4:	a1 40 40 80 00       	mov    0x804040,%eax
  802ac9:	39 c2                	cmp    %eax,%edx
  802acb:	72 19                	jb     802ae6 <free_block+0x37>
  802acd:	68 04 3b 80 00       	push   $0x803b04
  802ad2:	68 7a 3a 80 00       	push   $0x803a7a
  802ad7:	68 d7 00 00 00       	push   $0xd7
  802adc:	68 17 3a 80 00       	push   $0x803a17
  802ae1:	e8 eb dc ff ff       	call   8007d1 <_panic>
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #4 free_block
	//Your code is here
	//Comment the following line
	// va of a piece in memory to free so:
	// 1. get its page, and make blk with this address to be put in the freeBlockList.
	struct BlockElement* blk_to_free = (struct BlockElement*)va;
  802ae6:	8b 45 08             	mov    0x8(%ebp),%eax
  802ae9:	89 45 e8             	mov    %eax,-0x18(%ebp)
	struct PageInfoElement *pageInfo = to_page_info((uint32)va);
  802aec:	8b 45 08             	mov    0x8(%ebp),%eax
  802aef:	83 ec 0c             	sub    $0xc,%esp
  802af2:	50                   	push   %eax
  802af3:	e8 67 f8 ff ff       	call   80235f <to_page_info>
  802af8:	83 c4 10             	add    $0x10,%esp
  802afb:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	uint32 blk_size = pageInfo->block_size;
  802afe:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802b01:	8b 40 08             	mov    0x8(%eax),%eax
  802b04:	0f b7 c0             	movzwl %ax,%eax
  802b07:	89 45 e0             	mov    %eax,-0x20(%ebp)

	// its index in the freeBlocklist.
	int idx = 0;
  802b0a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int i = LOG2_MIN_SIZE; i <= LOG2_MAX_SIZE; i++) {
  802b11:	c7 45 f0 03 00 00 00 	movl   $0x3,-0x10(%ebp)
  802b18:	eb 19                	jmp    802b33 <free_block+0x84>
	    if ((1 << i) == blk_size)
  802b1a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b1d:	ba 01 00 00 00       	mov    $0x1,%edx
  802b22:	88 c1                	mov    %al,%cl
  802b24:	d3 e2                	shl    %cl,%edx
  802b26:	89 d0                	mov    %edx,%eax
  802b28:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  802b2b:	74 0e                	je     802b3b <free_block+0x8c>
	        break;
	    idx++;
  802b2d:	ff 45 f4             	incl   -0xc(%ebp)
	struct PageInfoElement *pageInfo = to_page_info((uint32)va);
	uint32 blk_size = pageInfo->block_size;

	// its index in the freeBlocklist.
	int idx = 0;
	for (int i = LOG2_MIN_SIZE; i <= LOG2_MAX_SIZE; i++) {
  802b30:	ff 45 f0             	incl   -0x10(%ebp)
  802b33:	83 7d f0 0b          	cmpl   $0xb,-0x10(%ebp)
  802b37:	7e e1                	jle    802b1a <free_block+0x6b>
  802b39:	eb 01                	jmp    802b3c <free_block+0x8d>
	    if ((1 << i) == blk_size)
	        break;
  802b3b:	90                   	nop
	    idx++;
	}

	pageInfo->num_of_free_blocks++;
  802b3c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802b3f:	66 8b 40 0a          	mov    0xa(%eax),%ax
  802b43:	40                   	inc    %eax
  802b44:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802b47:	66 89 42 0a          	mov    %ax,0xa(%edx)
	LIST_INSERT_TAIL(&freeBlockLists[idx], blk_to_free);
  802b4b:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802b4f:	75 17                	jne    802b68 <free_block+0xb9>
  802b51:	83 ec 04             	sub    $0x4,%esp
  802b54:	68 90 3a 80 00       	push   $0x803a90
  802b59:	68 ee 00 00 00       	push   $0xee
  802b5e:	68 17 3a 80 00       	push   $0x803a17
  802b63:	e8 69 dc ff ff       	call   8007d1 <_panic>
  802b68:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b6b:	c1 e0 04             	shl    $0x4,%eax
  802b6e:	05 84 c0 81 00       	add    $0x81c084,%eax
  802b73:	8b 10                	mov    (%eax),%edx
  802b75:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802b78:	89 50 04             	mov    %edx,0x4(%eax)
  802b7b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802b7e:	8b 40 04             	mov    0x4(%eax),%eax
  802b81:	85 c0                	test   %eax,%eax
  802b83:	74 14                	je     802b99 <free_block+0xea>
  802b85:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b88:	c1 e0 04             	shl    $0x4,%eax
  802b8b:	05 84 c0 81 00       	add    $0x81c084,%eax
  802b90:	8b 00                	mov    (%eax),%eax
  802b92:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802b95:	89 10                	mov    %edx,(%eax)
  802b97:	eb 11                	jmp    802baa <free_block+0xfb>
  802b99:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b9c:	c1 e0 04             	shl    $0x4,%eax
  802b9f:	8d 90 80 c0 81 00    	lea    0x81c080(%eax),%edx
  802ba5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ba8:	89 02                	mov    %eax,(%edx)
  802baa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bad:	c1 e0 04             	shl    $0x4,%eax
  802bb0:	8d 90 84 c0 81 00    	lea    0x81c084(%eax),%edx
  802bb6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802bb9:	89 02                	mov    %eax,(%edx)
  802bbb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802bbe:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802bc4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bc7:	c1 e0 04             	shl    $0x4,%eax
  802bca:	05 8c c0 81 00       	add    $0x81c08c,%eax
  802bcf:	8b 00                	mov    (%eax),%eax
  802bd1:	8d 50 01             	lea    0x1(%eax),%edx
  802bd4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bd7:	c1 e0 04             	shl    $0x4,%eax
  802bda:	05 8c c0 81 00       	add    $0x81c08c,%eax
  802bdf:	89 10                	mov    %edx,(%eax)

	// now, case 1: the page all blocks are freed so you free the page.
	int blk_count = PAGE_SIZE / blk_size;
  802be1:	b8 00 10 00 00       	mov    $0x1000,%eax
  802be6:	ba 00 00 00 00       	mov    $0x0,%edx
  802beb:	f7 75 e0             	divl   -0x20(%ebp)
  802bee:	89 45 dc             	mov    %eax,-0x24(%ebp)
	// the blk count in the page is same as number fo free blocks free up the page.
	if (pageInfo->num_of_free_blocks == blk_count) {
  802bf1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802bf4:	66 8b 40 0a          	mov    0xa(%eax),%ax
  802bf8:	0f b7 c0             	movzwl %ax,%eax
  802bfb:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  802bfe:	0f 85 70 01 00 00    	jne    802d74 <free_block+0x2c5>
		uint32 page_va = to_page_va(pageInfo);
  802c04:	83 ec 0c             	sub    $0xc,%esp
  802c07:	ff 75 e4             	pushl  -0x1c(%ebp)
  802c0a:	e8 de f6 ff ff       	call   8022ed <to_page_va>
  802c0f:	83 c4 10             	add    $0x10,%esp
  802c12:	89 45 d8             	mov    %eax,-0x28(%ebp)
		// remove all blk in the freeBlockList.
		for (uint32 off = 0; off < PAGE_SIZE; off += blk_size) {
  802c15:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  802c1c:	e9 b7 00 00 00       	jmp    802cd8 <free_block+0x229>
			struct BlockElement *blk = (struct BlockElement*)(page_va + off);
  802c21:	8b 55 d8             	mov    -0x28(%ebp),%edx
  802c24:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c27:	01 d0                	add    %edx,%eax
  802c29:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			LIST_REMOVE(&freeBlockLists[idx], blk);
  802c2c:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  802c30:	75 17                	jne    802c49 <free_block+0x19a>
  802c32:	83 ec 04             	sub    $0x4,%esp
  802c35:	68 d5 3a 80 00       	push   $0x803ad5
  802c3a:	68 f8 00 00 00       	push   $0xf8
  802c3f:	68 17 3a 80 00       	push   $0x803a17
  802c44:	e8 88 db ff ff       	call   8007d1 <_panic>
  802c49:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802c4c:	8b 00                	mov    (%eax),%eax
  802c4e:	85 c0                	test   %eax,%eax
  802c50:	74 10                	je     802c62 <free_block+0x1b3>
  802c52:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802c55:	8b 00                	mov    (%eax),%eax
  802c57:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  802c5a:	8b 52 04             	mov    0x4(%edx),%edx
  802c5d:	89 50 04             	mov    %edx,0x4(%eax)
  802c60:	eb 14                	jmp    802c76 <free_block+0x1c7>
  802c62:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802c65:	8b 40 04             	mov    0x4(%eax),%eax
  802c68:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802c6b:	c1 e2 04             	shl    $0x4,%edx
  802c6e:	81 c2 84 c0 81 00    	add    $0x81c084,%edx
  802c74:	89 02                	mov    %eax,(%edx)
  802c76:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802c79:	8b 40 04             	mov    0x4(%eax),%eax
  802c7c:	85 c0                	test   %eax,%eax
  802c7e:	74 0f                	je     802c8f <free_block+0x1e0>
  802c80:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802c83:	8b 40 04             	mov    0x4(%eax),%eax
  802c86:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  802c89:	8b 12                	mov    (%edx),%edx
  802c8b:	89 10                	mov    %edx,(%eax)
  802c8d:	eb 13                	jmp    802ca2 <free_block+0x1f3>
  802c8f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802c92:	8b 00                	mov    (%eax),%eax
  802c94:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802c97:	c1 e2 04             	shl    $0x4,%edx
  802c9a:	81 c2 80 c0 81 00    	add    $0x81c080,%edx
  802ca0:	89 02                	mov    %eax,(%edx)
  802ca2:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802ca5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802cab:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802cae:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802cb5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cb8:	c1 e0 04             	shl    $0x4,%eax
  802cbb:	05 8c c0 81 00       	add    $0x81c08c,%eax
  802cc0:	8b 00                	mov    (%eax),%eax
  802cc2:	8d 50 ff             	lea    -0x1(%eax),%edx
  802cc5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cc8:	c1 e0 04             	shl    $0x4,%eax
  802ccb:	05 8c c0 81 00       	add    $0x81c08c,%eax
  802cd0:	89 10                	mov    %edx,(%eax)
	int blk_count = PAGE_SIZE / blk_size;
	// the blk count in the page is same as number fo free blocks free up the page.
	if (pageInfo->num_of_free_blocks == blk_count) {
		uint32 page_va = to_page_va(pageInfo);
		// remove all blk in the freeBlockList.
		for (uint32 off = 0; off < PAGE_SIZE; off += blk_size) {
  802cd2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802cd5:	01 45 ec             	add    %eax,-0x14(%ebp)
  802cd8:	81 7d ec ff 0f 00 00 	cmpl   $0xfff,-0x14(%ebp)
  802cdf:	0f 86 3c ff ff ff    	jbe    802c21 <free_block+0x172>
			struct BlockElement *blk = (struct BlockElement*)(page_va + off);
			LIST_REMOVE(&freeBlockLists[idx], blk);
		}
		// reset page info.
		pageInfo->block_size = 0;
  802ce5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802ce8:	66 c7 40 08 00 00    	movw   $0x0,0x8(%eax)
		pageInfo->num_of_free_blocks = 0;
  802cee:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802cf1:	66 c7 40 0a 00 00    	movw   $0x0,0xa(%eax)
		// add it to the available pages.
		LIST_INSERT_TAIL(&freePagesList, pageInfo);
  802cf7:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  802cfb:	75 17                	jne    802d14 <free_block+0x265>
  802cfd:	83 ec 04             	sub    $0x4,%esp
  802d00:	68 90 3a 80 00       	push   $0x803a90
  802d05:	68 fe 00 00 00       	push   $0xfe
  802d0a:	68 17 3a 80 00       	push   $0x803a17
  802d0f:	e8 bd da ff ff       	call   8007d1 <_panic>
  802d14:	8b 15 4c 40 80 00    	mov    0x80404c,%edx
  802d1a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802d1d:	89 50 04             	mov    %edx,0x4(%eax)
  802d20:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802d23:	8b 40 04             	mov    0x4(%eax),%eax
  802d26:	85 c0                	test   %eax,%eax
  802d28:	74 0c                	je     802d36 <free_block+0x287>
  802d2a:	a1 4c 40 80 00       	mov    0x80404c,%eax
  802d2f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802d32:	89 10                	mov    %edx,(%eax)
  802d34:	eb 08                	jmp    802d3e <free_block+0x28f>
  802d36:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802d39:	a3 48 40 80 00       	mov    %eax,0x804048
  802d3e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802d41:	a3 4c 40 80 00       	mov    %eax,0x80404c
  802d46:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802d49:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802d4f:	a1 54 40 80 00       	mov    0x804054,%eax
  802d54:	40                   	inc    %eax
  802d55:	a3 54 40 80 00       	mov    %eax,0x804054
		// make it available in memory.
		return_page((uint32 *)to_page_va(pageInfo));
  802d5a:	83 ec 0c             	sub    $0xc,%esp
  802d5d:	ff 75 e4             	pushl  -0x1c(%ebp)
  802d60:	e8 88 f5 ff ff       	call   8022ed <to_page_va>
  802d65:	83 c4 10             	add    $0x10,%esp
  802d68:	83 ec 0c             	sub    $0xc,%esp
  802d6b:	50                   	push   %eax
  802d6c:	e8 b8 ee ff ff       	call   801c29 <return_page>
  802d71:	83 c4 10             	add    $0x10,%esp
	}
	//panic("free_block() Not implemented yet");
}
  802d74:	90                   	nop
  802d75:	c9                   	leave  
  802d76:	c3                   	ret    

00802d77 <realloc_block>:

//===========================
// [1] REALLOCATE BLOCK:
//===========================
void *realloc_block(void* va, uint32 new_size)
{
  802d77:	55                   	push   %ebp
  802d78:	89 e5                	mov    %esp,%ebp
  802d7a:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.BONUS#2] KERNEL REALLOC - realloc_block
	//Your code is here
	//Comment the following line
	panic("realloc_block() Not implemented yet");
  802d7d:	83 ec 04             	sub    $0x4,%esp
  802d80:	68 3c 3b 80 00       	push   $0x803b3c
  802d85:	68 11 01 00 00       	push   $0x111
  802d8a:	68 17 3a 80 00       	push   $0x803a17
  802d8f:	e8 3d da ff ff       	call   8007d1 <_panic>

00802d94 <__udivdi3>:
  802d94:	55                   	push   %ebp
  802d95:	57                   	push   %edi
  802d96:	56                   	push   %esi
  802d97:	53                   	push   %ebx
  802d98:	83 ec 1c             	sub    $0x1c,%esp
  802d9b:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  802d9f:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  802da3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  802da7:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802dab:	89 ca                	mov    %ecx,%edx
  802dad:	89 f8                	mov    %edi,%eax
  802daf:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  802db3:	85 f6                	test   %esi,%esi
  802db5:	75 2d                	jne    802de4 <__udivdi3+0x50>
  802db7:	39 cf                	cmp    %ecx,%edi
  802db9:	77 65                	ja     802e20 <__udivdi3+0x8c>
  802dbb:	89 fd                	mov    %edi,%ebp
  802dbd:	85 ff                	test   %edi,%edi
  802dbf:	75 0b                	jne    802dcc <__udivdi3+0x38>
  802dc1:	b8 01 00 00 00       	mov    $0x1,%eax
  802dc6:	31 d2                	xor    %edx,%edx
  802dc8:	f7 f7                	div    %edi
  802dca:	89 c5                	mov    %eax,%ebp
  802dcc:	31 d2                	xor    %edx,%edx
  802dce:	89 c8                	mov    %ecx,%eax
  802dd0:	f7 f5                	div    %ebp
  802dd2:	89 c1                	mov    %eax,%ecx
  802dd4:	89 d8                	mov    %ebx,%eax
  802dd6:	f7 f5                	div    %ebp
  802dd8:	89 cf                	mov    %ecx,%edi
  802dda:	89 fa                	mov    %edi,%edx
  802ddc:	83 c4 1c             	add    $0x1c,%esp
  802ddf:	5b                   	pop    %ebx
  802de0:	5e                   	pop    %esi
  802de1:	5f                   	pop    %edi
  802de2:	5d                   	pop    %ebp
  802de3:	c3                   	ret    
  802de4:	39 ce                	cmp    %ecx,%esi
  802de6:	77 28                	ja     802e10 <__udivdi3+0x7c>
  802de8:	0f bd fe             	bsr    %esi,%edi
  802deb:	83 f7 1f             	xor    $0x1f,%edi
  802dee:	75 40                	jne    802e30 <__udivdi3+0x9c>
  802df0:	39 ce                	cmp    %ecx,%esi
  802df2:	72 0a                	jb     802dfe <__udivdi3+0x6a>
  802df4:	3b 44 24 08          	cmp    0x8(%esp),%eax
  802df8:	0f 87 9e 00 00 00    	ja     802e9c <__udivdi3+0x108>
  802dfe:	b8 01 00 00 00       	mov    $0x1,%eax
  802e03:	89 fa                	mov    %edi,%edx
  802e05:	83 c4 1c             	add    $0x1c,%esp
  802e08:	5b                   	pop    %ebx
  802e09:	5e                   	pop    %esi
  802e0a:	5f                   	pop    %edi
  802e0b:	5d                   	pop    %ebp
  802e0c:	c3                   	ret    
  802e0d:	8d 76 00             	lea    0x0(%esi),%esi
  802e10:	31 ff                	xor    %edi,%edi
  802e12:	31 c0                	xor    %eax,%eax
  802e14:	89 fa                	mov    %edi,%edx
  802e16:	83 c4 1c             	add    $0x1c,%esp
  802e19:	5b                   	pop    %ebx
  802e1a:	5e                   	pop    %esi
  802e1b:	5f                   	pop    %edi
  802e1c:	5d                   	pop    %ebp
  802e1d:	c3                   	ret    
  802e1e:	66 90                	xchg   %ax,%ax
  802e20:	89 d8                	mov    %ebx,%eax
  802e22:	f7 f7                	div    %edi
  802e24:	31 ff                	xor    %edi,%edi
  802e26:	89 fa                	mov    %edi,%edx
  802e28:	83 c4 1c             	add    $0x1c,%esp
  802e2b:	5b                   	pop    %ebx
  802e2c:	5e                   	pop    %esi
  802e2d:	5f                   	pop    %edi
  802e2e:	5d                   	pop    %ebp
  802e2f:	c3                   	ret    
  802e30:	bd 20 00 00 00       	mov    $0x20,%ebp
  802e35:	89 eb                	mov    %ebp,%ebx
  802e37:	29 fb                	sub    %edi,%ebx
  802e39:	89 f9                	mov    %edi,%ecx
  802e3b:	d3 e6                	shl    %cl,%esi
  802e3d:	89 c5                	mov    %eax,%ebp
  802e3f:	88 d9                	mov    %bl,%cl
  802e41:	d3 ed                	shr    %cl,%ebp
  802e43:	89 e9                	mov    %ebp,%ecx
  802e45:	09 f1                	or     %esi,%ecx
  802e47:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  802e4b:	89 f9                	mov    %edi,%ecx
  802e4d:	d3 e0                	shl    %cl,%eax
  802e4f:	89 c5                	mov    %eax,%ebp
  802e51:	89 d6                	mov    %edx,%esi
  802e53:	88 d9                	mov    %bl,%cl
  802e55:	d3 ee                	shr    %cl,%esi
  802e57:	89 f9                	mov    %edi,%ecx
  802e59:	d3 e2                	shl    %cl,%edx
  802e5b:	8b 44 24 08          	mov    0x8(%esp),%eax
  802e5f:	88 d9                	mov    %bl,%cl
  802e61:	d3 e8                	shr    %cl,%eax
  802e63:	09 c2                	or     %eax,%edx
  802e65:	89 d0                	mov    %edx,%eax
  802e67:	89 f2                	mov    %esi,%edx
  802e69:	f7 74 24 0c          	divl   0xc(%esp)
  802e6d:	89 d6                	mov    %edx,%esi
  802e6f:	89 c3                	mov    %eax,%ebx
  802e71:	f7 e5                	mul    %ebp
  802e73:	39 d6                	cmp    %edx,%esi
  802e75:	72 19                	jb     802e90 <__udivdi3+0xfc>
  802e77:	74 0b                	je     802e84 <__udivdi3+0xf0>
  802e79:	89 d8                	mov    %ebx,%eax
  802e7b:	31 ff                	xor    %edi,%edi
  802e7d:	e9 58 ff ff ff       	jmp    802dda <__udivdi3+0x46>
  802e82:	66 90                	xchg   %ax,%ax
  802e84:	8b 54 24 08          	mov    0x8(%esp),%edx
  802e88:	89 f9                	mov    %edi,%ecx
  802e8a:	d3 e2                	shl    %cl,%edx
  802e8c:	39 c2                	cmp    %eax,%edx
  802e8e:	73 e9                	jae    802e79 <__udivdi3+0xe5>
  802e90:	8d 43 ff             	lea    -0x1(%ebx),%eax
  802e93:	31 ff                	xor    %edi,%edi
  802e95:	e9 40 ff ff ff       	jmp    802dda <__udivdi3+0x46>
  802e9a:	66 90                	xchg   %ax,%ax
  802e9c:	31 c0                	xor    %eax,%eax
  802e9e:	e9 37 ff ff ff       	jmp    802dda <__udivdi3+0x46>
  802ea3:	90                   	nop

00802ea4 <__umoddi3>:
  802ea4:	55                   	push   %ebp
  802ea5:	57                   	push   %edi
  802ea6:	56                   	push   %esi
  802ea7:	53                   	push   %ebx
  802ea8:	83 ec 1c             	sub    $0x1c,%esp
  802eab:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  802eaf:	8b 74 24 34          	mov    0x34(%esp),%esi
  802eb3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  802eb7:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  802ebb:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802ebf:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802ec3:	89 f3                	mov    %esi,%ebx
  802ec5:	89 fa                	mov    %edi,%edx
  802ec7:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  802ecb:	89 34 24             	mov    %esi,(%esp)
  802ece:	85 c0                	test   %eax,%eax
  802ed0:	75 1a                	jne    802eec <__umoddi3+0x48>
  802ed2:	39 f7                	cmp    %esi,%edi
  802ed4:	0f 86 a2 00 00 00    	jbe    802f7c <__umoddi3+0xd8>
  802eda:	89 c8                	mov    %ecx,%eax
  802edc:	89 f2                	mov    %esi,%edx
  802ede:	f7 f7                	div    %edi
  802ee0:	89 d0                	mov    %edx,%eax
  802ee2:	31 d2                	xor    %edx,%edx
  802ee4:	83 c4 1c             	add    $0x1c,%esp
  802ee7:	5b                   	pop    %ebx
  802ee8:	5e                   	pop    %esi
  802ee9:	5f                   	pop    %edi
  802eea:	5d                   	pop    %ebp
  802eeb:	c3                   	ret    
  802eec:	39 f0                	cmp    %esi,%eax
  802eee:	0f 87 ac 00 00 00    	ja     802fa0 <__umoddi3+0xfc>
  802ef4:	0f bd e8             	bsr    %eax,%ebp
  802ef7:	83 f5 1f             	xor    $0x1f,%ebp
  802efa:	0f 84 ac 00 00 00    	je     802fac <__umoddi3+0x108>
  802f00:	bf 20 00 00 00       	mov    $0x20,%edi
  802f05:	29 ef                	sub    %ebp,%edi
  802f07:	89 fe                	mov    %edi,%esi
  802f09:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802f0d:	89 e9                	mov    %ebp,%ecx
  802f0f:	d3 e0                	shl    %cl,%eax
  802f11:	89 d7                	mov    %edx,%edi
  802f13:	89 f1                	mov    %esi,%ecx
  802f15:	d3 ef                	shr    %cl,%edi
  802f17:	09 c7                	or     %eax,%edi
  802f19:	89 e9                	mov    %ebp,%ecx
  802f1b:	d3 e2                	shl    %cl,%edx
  802f1d:	89 14 24             	mov    %edx,(%esp)
  802f20:	89 d8                	mov    %ebx,%eax
  802f22:	d3 e0                	shl    %cl,%eax
  802f24:	89 c2                	mov    %eax,%edx
  802f26:	8b 44 24 08          	mov    0x8(%esp),%eax
  802f2a:	d3 e0                	shl    %cl,%eax
  802f2c:	89 44 24 04          	mov    %eax,0x4(%esp)
  802f30:	8b 44 24 08          	mov    0x8(%esp),%eax
  802f34:	89 f1                	mov    %esi,%ecx
  802f36:	d3 e8                	shr    %cl,%eax
  802f38:	09 d0                	or     %edx,%eax
  802f3a:	d3 eb                	shr    %cl,%ebx
  802f3c:	89 da                	mov    %ebx,%edx
  802f3e:	f7 f7                	div    %edi
  802f40:	89 d3                	mov    %edx,%ebx
  802f42:	f7 24 24             	mull   (%esp)
  802f45:	89 c6                	mov    %eax,%esi
  802f47:	89 d1                	mov    %edx,%ecx
  802f49:	39 d3                	cmp    %edx,%ebx
  802f4b:	0f 82 87 00 00 00    	jb     802fd8 <__umoddi3+0x134>
  802f51:	0f 84 91 00 00 00    	je     802fe8 <__umoddi3+0x144>
  802f57:	8b 54 24 04          	mov    0x4(%esp),%edx
  802f5b:	29 f2                	sub    %esi,%edx
  802f5d:	19 cb                	sbb    %ecx,%ebx
  802f5f:	89 d8                	mov    %ebx,%eax
  802f61:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  802f65:	d3 e0                	shl    %cl,%eax
  802f67:	89 e9                	mov    %ebp,%ecx
  802f69:	d3 ea                	shr    %cl,%edx
  802f6b:	09 d0                	or     %edx,%eax
  802f6d:	89 e9                	mov    %ebp,%ecx
  802f6f:	d3 eb                	shr    %cl,%ebx
  802f71:	89 da                	mov    %ebx,%edx
  802f73:	83 c4 1c             	add    $0x1c,%esp
  802f76:	5b                   	pop    %ebx
  802f77:	5e                   	pop    %esi
  802f78:	5f                   	pop    %edi
  802f79:	5d                   	pop    %ebp
  802f7a:	c3                   	ret    
  802f7b:	90                   	nop
  802f7c:	89 fd                	mov    %edi,%ebp
  802f7e:	85 ff                	test   %edi,%edi
  802f80:	75 0b                	jne    802f8d <__umoddi3+0xe9>
  802f82:	b8 01 00 00 00       	mov    $0x1,%eax
  802f87:	31 d2                	xor    %edx,%edx
  802f89:	f7 f7                	div    %edi
  802f8b:	89 c5                	mov    %eax,%ebp
  802f8d:	89 f0                	mov    %esi,%eax
  802f8f:	31 d2                	xor    %edx,%edx
  802f91:	f7 f5                	div    %ebp
  802f93:	89 c8                	mov    %ecx,%eax
  802f95:	f7 f5                	div    %ebp
  802f97:	89 d0                	mov    %edx,%eax
  802f99:	e9 44 ff ff ff       	jmp    802ee2 <__umoddi3+0x3e>
  802f9e:	66 90                	xchg   %ax,%ax
  802fa0:	89 c8                	mov    %ecx,%eax
  802fa2:	89 f2                	mov    %esi,%edx
  802fa4:	83 c4 1c             	add    $0x1c,%esp
  802fa7:	5b                   	pop    %ebx
  802fa8:	5e                   	pop    %esi
  802fa9:	5f                   	pop    %edi
  802faa:	5d                   	pop    %ebp
  802fab:	c3                   	ret    
  802fac:	3b 04 24             	cmp    (%esp),%eax
  802faf:	72 06                	jb     802fb7 <__umoddi3+0x113>
  802fb1:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  802fb5:	77 0f                	ja     802fc6 <__umoddi3+0x122>
  802fb7:	89 f2                	mov    %esi,%edx
  802fb9:	29 f9                	sub    %edi,%ecx
  802fbb:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  802fbf:	89 14 24             	mov    %edx,(%esp)
  802fc2:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  802fc6:	8b 44 24 04          	mov    0x4(%esp),%eax
  802fca:	8b 14 24             	mov    (%esp),%edx
  802fcd:	83 c4 1c             	add    $0x1c,%esp
  802fd0:	5b                   	pop    %ebx
  802fd1:	5e                   	pop    %esi
  802fd2:	5f                   	pop    %edi
  802fd3:	5d                   	pop    %ebp
  802fd4:	c3                   	ret    
  802fd5:	8d 76 00             	lea    0x0(%esi),%esi
  802fd8:	2b 04 24             	sub    (%esp),%eax
  802fdb:	19 fa                	sbb    %edi,%edx
  802fdd:	89 d1                	mov    %edx,%ecx
  802fdf:	89 c6                	mov    %eax,%esi
  802fe1:	e9 71 ff ff ff       	jmp    802f57 <__umoddi3+0xb3>
  802fe6:	66 90                	xchg   %ax,%ax
  802fe8:	39 44 24 04          	cmp    %eax,0x4(%esp)
  802fec:	72 ea                	jb     802fd8 <__umoddi3+0x134>
  802fee:	89 d9                	mov    %ebx,%ecx
  802ff0:	e9 62 ff ff ff       	jmp    802f57 <__umoddi3+0xb3>
