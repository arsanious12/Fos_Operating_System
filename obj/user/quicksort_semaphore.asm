
obj/user/quicksort_semaphore:     file format elf32-i386


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
  800031:	e8 3b 06 00 00       	call   800671 <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
void QuickSort(int *Elements, int NumOfElements);
void QSort(int *Elements,int NumOfElements, int startIndex, int finalIndex);
uint32 CheckSorted(int *Elements, int NumOfElements);
struct semaphore IO_CS ;
void _main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	53                   	push   %ebx
  80003c:	81 ec 34 01 00 00    	sub    $0x134,%esp
	int envID = sys_getenvid();
  800042:	e8 30 20 00 00       	call   802077 <sys_getenvid>
  800047:	89 45 f0             	mov    %eax,-0x10(%ebp)
	char Chose ;
	char Line[255] ;
	int Iteration = 0 ;
  80004a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	IO_CS = create_semaphore("IO.CS", 1);
  800051:	8d 85 d4 fe ff ff    	lea    -0x12c(%ebp),%eax
  800057:	83 ec 04             	sub    $0x4,%esp
  80005a:	6a 01                	push   $0x1
  80005c:	68 e0 30 80 00       	push   $0x8030e0
  800061:	50                   	push   %eax
  800062:	e8 92 2d 00 00       	call   802df9 <create_semaphore>
  800067:	83 c4 0c             	add    $0xc,%esp
  80006a:	8b 85 d4 fe ff ff    	mov    -0x12c(%ebp),%eax
  800070:	a3 60 c0 81 00       	mov    %eax,0x81c060
	do
	{
		int InitFreeFrames = sys_calculate_free_frames() + sys_calculate_modified_frames();
  800075:	e8 4d 1e 00 00       	call   801ec7 <sys_calculate_free_frames>
  80007a:	89 c3                	mov    %eax,%ebx
  80007c:	e8 5f 1e 00 00       	call   801ee0 <sys_calculate_modified_frames>
  800081:	01 d8                	add    %ebx,%eax
  800083:	89 45 ec             	mov    %eax,-0x14(%ebp)

		Iteration++ ;
  800086:	ff 45 f4             	incl   -0xc(%ebp)
		//		cprintf("Free Frames Before Allocation = %d\n", sys_calculate_free_frames()) ;

//	sys_lock_cons();
		int NumOfElements, *Elements;
		wait_semaphore(IO_CS);
  800089:	83 ec 0c             	sub    $0xc,%esp
  80008c:	ff 35 60 c0 81 00    	pushl  0x81c060
  800092:	e8 96 2d 00 00       	call   802e2d <wait_semaphore>
  800097:	83 c4 10             	add    $0x10,%esp
		{
			readline("Enter the number of elements: ", Line);
  80009a:	83 ec 08             	sub    $0x8,%esp
  80009d:	8d 85 dd fe ff ff    	lea    -0x123(%ebp),%eax
  8000a3:	50                   	push   %eax
  8000a4:	68 e8 30 80 00       	push   $0x8030e8
  8000a9:	e8 2f 11 00 00       	call   8011dd <readline>
  8000ae:	83 c4 10             	add    $0x10,%esp
			NumOfElements = strtol(Line, NULL, 10) ;
  8000b1:	83 ec 04             	sub    $0x4,%esp
  8000b4:	6a 0a                	push   $0xa
  8000b6:	6a 00                	push   $0x0
  8000b8:	8d 85 dd fe ff ff    	lea    -0x123(%ebp),%eax
  8000be:	50                   	push   %eax
  8000bf:	e8 30 17 00 00       	call   8017f4 <strtol>
  8000c4:	83 c4 10             	add    $0x10,%esp
  8000c7:	89 45 e8             	mov    %eax,-0x18(%ebp)
			Elements = malloc(sizeof(int) * NumOfElements) ;
  8000ca:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8000cd:	c1 e0 02             	shl    $0x2,%eax
  8000d0:	83 ec 0c             	sub    $0xc,%esp
  8000d3:	50                   	push   %eax
  8000d4:	e8 f5 1b 00 00       	call   801cce <malloc>
  8000d9:	83 c4 10             	add    $0x10,%esp
  8000dc:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			cprintf("Choose the initialization method:\n") ;
  8000df:	83 ec 0c             	sub    $0xc,%esp
  8000e2:	68 08 31 80 00       	push   $0x803108
  8000e7:	e8 18 0a 00 00       	call   800b04 <cprintf>
  8000ec:	83 c4 10             	add    $0x10,%esp
			cprintf("a) Ascending\n") ;
  8000ef:	83 ec 0c             	sub    $0xc,%esp
  8000f2:	68 2b 31 80 00       	push   $0x80312b
  8000f7:	e8 08 0a 00 00       	call   800b04 <cprintf>
  8000fc:	83 c4 10             	add    $0x10,%esp
			cprintf("b) Descending\n") ;
  8000ff:	83 ec 0c             	sub    $0xc,%esp
  800102:	68 39 31 80 00       	push   $0x803139
  800107:	e8 f8 09 00 00       	call   800b04 <cprintf>
  80010c:	83 c4 10             	add    $0x10,%esp
			cprintf("c) Semi random\n");
  80010f:	83 ec 0c             	sub    $0xc,%esp
  800112:	68 48 31 80 00       	push   $0x803148
  800117:	e8 e8 09 00 00       	call   800b04 <cprintf>
  80011c:	83 c4 10             	add    $0x10,%esp
			do
			{
				cprintf("Select: ") ;
  80011f:	83 ec 0c             	sub    $0xc,%esp
  800122:	68 58 31 80 00       	push   $0x803158
  800127:	e8 d8 09 00 00       	call   800b04 <cprintf>
  80012c:	83 c4 10             	add    $0x10,%esp
				Chose = getchar() ;
  80012f:	e8 20 05 00 00       	call   800654 <getchar>
  800134:	88 45 e3             	mov    %al,-0x1d(%ebp)
				cputchar(Chose);
  800137:	0f be 45 e3          	movsbl -0x1d(%ebp),%eax
  80013b:	83 ec 0c             	sub    $0xc,%esp
  80013e:	50                   	push   %eax
  80013f:	e8 f1 04 00 00       	call   800635 <cputchar>
  800144:	83 c4 10             	add    $0x10,%esp
				cputchar('\n');
  800147:	83 ec 0c             	sub    $0xc,%esp
  80014a:	6a 0a                	push   $0xa
  80014c:	e8 e4 04 00 00       	call   800635 <cputchar>
  800151:	83 c4 10             	add    $0x10,%esp
			} while (Chose != 'a' && Chose != 'b' && Chose != 'c');
  800154:	80 7d e3 61          	cmpb   $0x61,-0x1d(%ebp)
  800158:	74 0c                	je     800166 <_main+0x12e>
  80015a:	80 7d e3 62          	cmpb   $0x62,-0x1d(%ebp)
  80015e:	74 06                	je     800166 <_main+0x12e>
  800160:	80 7d e3 63          	cmpb   $0x63,-0x1d(%ebp)
  800164:	75 b9                	jne    80011f <_main+0xe7>

		}
		signal_semaphore(IO_CS);
  800166:	83 ec 0c             	sub    $0xc,%esp
  800169:	ff 35 60 c0 81 00    	pushl  0x81c060
  80016f:	e8 d3 2c 00 00       	call   802e47 <signal_semaphore>
  800174:	83 c4 10             	add    $0x10,%esp

		//sys_unlock_cons();
		int  i ;
		switch (Chose)
  800177:	0f be 45 e3          	movsbl -0x1d(%ebp),%eax
  80017b:	83 f8 62             	cmp    $0x62,%eax
  80017e:	74 1d                	je     80019d <_main+0x165>
  800180:	83 f8 63             	cmp    $0x63,%eax
  800183:	74 2b                	je     8001b0 <_main+0x178>
  800185:	83 f8 61             	cmp    $0x61,%eax
  800188:	75 39                	jne    8001c3 <_main+0x18b>
		{
		case 'a':
			InitializeAscending(Elements, NumOfElements);
  80018a:	83 ec 08             	sub    $0x8,%esp
  80018d:	ff 75 e8             	pushl  -0x18(%ebp)
  800190:	ff 75 e4             	pushl  -0x1c(%ebp)
  800193:	e8 2e 03 00 00       	call   8004c6 <InitializeAscending>
  800198:	83 c4 10             	add    $0x10,%esp
			break ;
  80019b:	eb 37                	jmp    8001d4 <_main+0x19c>
		case 'b':
			InitializeIdentical(Elements, NumOfElements);
  80019d:	83 ec 08             	sub    $0x8,%esp
  8001a0:	ff 75 e8             	pushl  -0x18(%ebp)
  8001a3:	ff 75 e4             	pushl  -0x1c(%ebp)
  8001a6:	e8 4c 03 00 00       	call   8004f7 <InitializeIdentical>
  8001ab:	83 c4 10             	add    $0x10,%esp
			break ;
  8001ae:	eb 24                	jmp    8001d4 <_main+0x19c>
		case 'c':
			InitializeSemiRandom(Elements, NumOfElements);
  8001b0:	83 ec 08             	sub    $0x8,%esp
  8001b3:	ff 75 e8             	pushl  -0x18(%ebp)
  8001b6:	ff 75 e4             	pushl  -0x1c(%ebp)
  8001b9:	e8 6e 03 00 00       	call   80052c <InitializeSemiRandom>
  8001be:	83 c4 10             	add    $0x10,%esp
			break ;
  8001c1:	eb 11                	jmp    8001d4 <_main+0x19c>
		default:
			InitializeSemiRandom(Elements, NumOfElements);
  8001c3:	83 ec 08             	sub    $0x8,%esp
  8001c6:	ff 75 e8             	pushl  -0x18(%ebp)
  8001c9:	ff 75 e4             	pushl  -0x1c(%ebp)
  8001cc:	e8 5b 03 00 00       	call   80052c <InitializeSemiRandom>
  8001d1:	83 c4 10             	add    $0x10,%esp
		}

		QuickSort(Elements, NumOfElements);
  8001d4:	83 ec 08             	sub    $0x8,%esp
  8001d7:	ff 75 e8             	pushl  -0x18(%ebp)
  8001da:	ff 75 e4             	pushl  -0x1c(%ebp)
  8001dd:	e8 29 01 00 00       	call   80030b <QuickSort>
  8001e2:	83 c4 10             	add    $0x10,%esp

		//		PrintElements(Elements, NumOfElements);

		uint32 Sorted = CheckSorted(Elements, NumOfElements);
  8001e5:	83 ec 08             	sub    $0x8,%esp
  8001e8:	ff 75 e8             	pushl  -0x18(%ebp)
  8001eb:	ff 75 e4             	pushl  -0x1c(%ebp)
  8001ee:	e8 29 02 00 00       	call   80041c <CheckSorted>
  8001f3:	83 c4 10             	add    $0x10,%esp
  8001f6:	89 45 dc             	mov    %eax,-0x24(%ebp)

		if(Sorted == 0) panic("The array is NOT sorted correctly") ;
  8001f9:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8001fd:	75 14                	jne    800213 <_main+0x1db>
  8001ff:	83 ec 04             	sub    $0x4,%esp
  800202:	68 64 31 80 00       	push   $0x803164
  800207:	6a 4d                	push   $0x4d
  800209:	68 86 31 80 00       	push   $0x803186
  80020e:	e8 23 06 00 00       	call   800836 <_panic>
		else
		{
			wait_semaphore(IO_CS);
  800213:	83 ec 0c             	sub    $0xc,%esp
  800216:	ff 35 60 c0 81 00    	pushl  0x81c060
  80021c:	e8 0c 2c 00 00       	call   802e2d <wait_semaphore>
  800221:	83 c4 10             	add    $0x10,%esp
				cprintf("\n===============================================\n") ;
  800224:	83 ec 0c             	sub    $0xc,%esp
  800227:	68 a4 31 80 00       	push   $0x8031a4
  80022c:	e8 d3 08 00 00       	call   800b04 <cprintf>
  800231:	83 c4 10             	add    $0x10,%esp
				cprintf("Congratulations!! The array is sorted correctly\n") ;
  800234:	83 ec 0c             	sub    $0xc,%esp
  800237:	68 d8 31 80 00       	push   $0x8031d8
  80023c:	e8 c3 08 00 00       	call   800b04 <cprintf>
  800241:	83 c4 10             	add    $0x10,%esp
				cprintf("===============================================\n\n") ;
  800244:	83 ec 0c             	sub    $0xc,%esp
  800247:	68 0c 32 80 00       	push   $0x80320c
  80024c:	e8 b3 08 00 00       	call   800b04 <cprintf>
  800251:	83 c4 10             	add    $0x10,%esp
			signal_semaphore(IO_CS);
  800254:	83 ec 0c             	sub    $0xc,%esp
  800257:	ff 35 60 c0 81 00    	pushl  0x81c060
  80025d:	e8 e5 2b 00 00       	call   802e47 <signal_semaphore>
  800262:	83 c4 10             	add    $0x10,%esp
		}

		//		cprintf("Free Frames After Calculation = %d\n", sys_calculate_free_frames()) ;

		wait_semaphore(IO_CS);
  800265:	83 ec 0c             	sub    $0xc,%esp
  800268:	ff 35 60 c0 81 00    	pushl  0x81c060
  80026e:	e8 ba 2b 00 00       	call   802e2d <wait_semaphore>
  800273:	83 c4 10             	add    $0x10,%esp
			cprintf("Freeing the Heap...\n\n") ;
  800276:	83 ec 0c             	sub    $0xc,%esp
  800279:	68 3e 32 80 00       	push   $0x80323e
  80027e:	e8 81 08 00 00       	call   800b04 <cprintf>
  800283:	83 c4 10             	add    $0x10,%esp
		signal_semaphore(IO_CS);
  800286:	83 ec 0c             	sub    $0xc,%esp
  800289:	ff 35 60 c0 81 00    	pushl  0x81c060
  80028f:	e8 b3 2b 00 00       	call   802e47 <signal_semaphore>
  800294:	83 c4 10             	add    $0x10,%esp

		//freeHeap() ;

		///========================================================================
	//sys_lock_cons();
		wait_semaphore(IO_CS);
  800297:	83 ec 0c             	sub    $0xc,%esp
  80029a:	ff 35 60 c0 81 00    	pushl  0x81c060
  8002a0:	e8 88 2b 00 00       	call   802e2d <wait_semaphore>
  8002a5:	83 c4 10             	add    $0x10,%esp
			cprintf("Do you want to repeat (y/n): ") ;
  8002a8:	83 ec 0c             	sub    $0xc,%esp
  8002ab:	68 54 32 80 00       	push   $0x803254
  8002b0:	e8 4f 08 00 00       	call   800b04 <cprintf>
  8002b5:	83 c4 10             	add    $0x10,%esp
			Chose = getchar() ;
  8002b8:	e8 97 03 00 00       	call   800654 <getchar>
  8002bd:	88 45 e3             	mov    %al,-0x1d(%ebp)
			cputchar(Chose);
  8002c0:	0f be 45 e3          	movsbl -0x1d(%ebp),%eax
  8002c4:	83 ec 0c             	sub    $0xc,%esp
  8002c7:	50                   	push   %eax
  8002c8:	e8 68 03 00 00       	call   800635 <cputchar>
  8002cd:	83 c4 10             	add    $0x10,%esp
			cputchar('\n');
  8002d0:	83 ec 0c             	sub    $0xc,%esp
  8002d3:	6a 0a                	push   $0xa
  8002d5:	e8 5b 03 00 00       	call   800635 <cputchar>
  8002da:	83 c4 10             	add    $0x10,%esp
			cputchar('\n');
  8002dd:	83 ec 0c             	sub    $0xc,%esp
  8002e0:	6a 0a                	push   $0xa
  8002e2:	e8 4e 03 00 00       	call   800635 <cputchar>
  8002e7:	83 c4 10             	add    $0x10,%esp
	//sys_unlock_cons();
		signal_semaphore(IO_CS);
  8002ea:	83 ec 0c             	sub    $0xc,%esp
  8002ed:	ff 35 60 c0 81 00    	pushl  0x81c060
  8002f3:	e8 4f 2b 00 00       	call   802e47 <signal_semaphore>
  8002f8:	83 c4 10             	add    $0x10,%esp

	} while (Chose == 'y');
  8002fb:	80 7d e3 79          	cmpb   $0x79,-0x1d(%ebp)
  8002ff:	0f 84 70 fd ff ff    	je     800075 <_main+0x3d>

}
  800305:	90                   	nop
  800306:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800309:	c9                   	leave  
  80030a:	c3                   	ret    

0080030b <QuickSort>:

///Quick sort
void QuickSort(int *Elements, int NumOfElements)
{
  80030b:	55                   	push   %ebp
  80030c:	89 e5                	mov    %esp,%ebp
  80030e:	83 ec 08             	sub    $0x8,%esp
	QSort(Elements, NumOfElements, 0, NumOfElements-1) ;
  800311:	8b 45 0c             	mov    0xc(%ebp),%eax
  800314:	48                   	dec    %eax
  800315:	50                   	push   %eax
  800316:	6a 00                	push   $0x0
  800318:	ff 75 0c             	pushl  0xc(%ebp)
  80031b:	ff 75 08             	pushl  0x8(%ebp)
  80031e:	e8 06 00 00 00       	call   800329 <QSort>
  800323:	83 c4 10             	add    $0x10,%esp
}
  800326:	90                   	nop
  800327:	c9                   	leave  
  800328:	c3                   	ret    

00800329 <QSort>:


void QSort(int *Elements,int NumOfElements, int startIndex, int finalIndex)
{
  800329:	55                   	push   %ebp
  80032a:	89 e5                	mov    %esp,%ebp
  80032c:	83 ec 18             	sub    $0x18,%esp
	if (startIndex >= finalIndex) return;
  80032f:	8b 45 10             	mov    0x10(%ebp),%eax
  800332:	3b 45 14             	cmp    0x14(%ebp),%eax
  800335:	0f 8d de 00 00 00    	jge    800419 <QSort+0xf0>

	int i = startIndex+1, j = finalIndex;
  80033b:	8b 45 10             	mov    0x10(%ebp),%eax
  80033e:	40                   	inc    %eax
  80033f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800342:	8b 45 14             	mov    0x14(%ebp),%eax
  800345:	89 45 f0             	mov    %eax,-0x10(%ebp)

	while (i <= j)
  800348:	e9 80 00 00 00       	jmp    8003cd <QSort+0xa4>
	{
		while (i <= finalIndex && Elements[startIndex] >= Elements[i]) i++;
  80034d:	ff 45 f4             	incl   -0xc(%ebp)
  800350:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800353:	3b 45 14             	cmp    0x14(%ebp),%eax
  800356:	7f 2b                	jg     800383 <QSort+0x5a>
  800358:	8b 45 10             	mov    0x10(%ebp),%eax
  80035b:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800362:	8b 45 08             	mov    0x8(%ebp),%eax
  800365:	01 d0                	add    %edx,%eax
  800367:	8b 10                	mov    (%eax),%edx
  800369:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80036c:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800373:	8b 45 08             	mov    0x8(%ebp),%eax
  800376:	01 c8                	add    %ecx,%eax
  800378:	8b 00                	mov    (%eax),%eax
  80037a:	39 c2                	cmp    %eax,%edx
  80037c:	7d cf                	jge    80034d <QSort+0x24>
		while (j > startIndex && Elements[startIndex] <= Elements[j]) j--;
  80037e:	eb 03                	jmp    800383 <QSort+0x5a>
  800380:	ff 4d f0             	decl   -0x10(%ebp)
  800383:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800386:	3b 45 10             	cmp    0x10(%ebp),%eax
  800389:	7e 26                	jle    8003b1 <QSort+0x88>
  80038b:	8b 45 10             	mov    0x10(%ebp),%eax
  80038e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800395:	8b 45 08             	mov    0x8(%ebp),%eax
  800398:	01 d0                	add    %edx,%eax
  80039a:	8b 10                	mov    (%eax),%edx
  80039c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80039f:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8003a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8003a9:	01 c8                	add    %ecx,%eax
  8003ab:	8b 00                	mov    (%eax),%eax
  8003ad:	39 c2                	cmp    %eax,%edx
  8003af:	7e cf                	jle    800380 <QSort+0x57>

		if (i <= j)
  8003b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8003b4:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8003b7:	7f 14                	jg     8003cd <QSort+0xa4>
		{
			Swap(Elements, i, j);
  8003b9:	83 ec 04             	sub    $0x4,%esp
  8003bc:	ff 75 f0             	pushl  -0x10(%ebp)
  8003bf:	ff 75 f4             	pushl  -0xc(%ebp)
  8003c2:	ff 75 08             	pushl  0x8(%ebp)
  8003c5:	e8 a9 00 00 00       	call   800473 <Swap>
  8003ca:	83 c4 10             	add    $0x10,%esp
{
	if (startIndex >= finalIndex) return;

	int i = startIndex+1, j = finalIndex;

	while (i <= j)
  8003cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8003d0:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8003d3:	0f 8e 77 ff ff ff    	jle    800350 <QSort+0x27>
		{
			Swap(Elements, i, j);
		}
	}

	Swap( Elements, startIndex, j);
  8003d9:	83 ec 04             	sub    $0x4,%esp
  8003dc:	ff 75 f0             	pushl  -0x10(%ebp)
  8003df:	ff 75 10             	pushl  0x10(%ebp)
  8003e2:	ff 75 08             	pushl  0x8(%ebp)
  8003e5:	e8 89 00 00 00       	call   800473 <Swap>
  8003ea:	83 c4 10             	add    $0x10,%esp

	QSort(Elements, NumOfElements, startIndex, j - 1);
  8003ed:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8003f0:	48                   	dec    %eax
  8003f1:	50                   	push   %eax
  8003f2:	ff 75 10             	pushl  0x10(%ebp)
  8003f5:	ff 75 0c             	pushl  0xc(%ebp)
  8003f8:	ff 75 08             	pushl  0x8(%ebp)
  8003fb:	e8 29 ff ff ff       	call   800329 <QSort>
  800400:	83 c4 10             	add    $0x10,%esp
	QSort(Elements, NumOfElements, i, finalIndex);
  800403:	ff 75 14             	pushl  0x14(%ebp)
  800406:	ff 75 f4             	pushl  -0xc(%ebp)
  800409:	ff 75 0c             	pushl  0xc(%ebp)
  80040c:	ff 75 08             	pushl  0x8(%ebp)
  80040f:	e8 15 ff ff ff       	call   800329 <QSort>
  800414:	83 c4 10             	add    $0x10,%esp
  800417:	eb 01                	jmp    80041a <QSort+0xf1>
}


void QSort(int *Elements,int NumOfElements, int startIndex, int finalIndex)
{
	if (startIndex >= finalIndex) return;
  800419:	90                   	nop

	Swap( Elements, startIndex, j);

	QSort(Elements, NumOfElements, startIndex, j - 1);
	QSort(Elements, NumOfElements, i, finalIndex);
}
  80041a:	c9                   	leave  
  80041b:	c3                   	ret    

0080041c <CheckSorted>:

uint32 CheckSorted(int *Elements, int NumOfElements)
{
  80041c:	55                   	push   %ebp
  80041d:	89 e5                	mov    %esp,%ebp
  80041f:	83 ec 10             	sub    $0x10,%esp
	uint32 Sorted = 1 ;
  800422:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
	int i ;
	for (i = 0 ; i < NumOfElements - 1; i++)
  800429:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  800430:	eb 33                	jmp    800465 <CheckSorted+0x49>
	{
		if (Elements[i] > Elements[i+1])
  800432:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800435:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80043c:	8b 45 08             	mov    0x8(%ebp),%eax
  80043f:	01 d0                	add    %edx,%eax
  800441:	8b 10                	mov    (%eax),%edx
  800443:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800446:	40                   	inc    %eax
  800447:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  80044e:	8b 45 08             	mov    0x8(%ebp),%eax
  800451:	01 c8                	add    %ecx,%eax
  800453:	8b 00                	mov    (%eax),%eax
  800455:	39 c2                	cmp    %eax,%edx
  800457:	7e 09                	jle    800462 <CheckSorted+0x46>
		{
			Sorted = 0 ;
  800459:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
			break;
  800460:	eb 0c                	jmp    80046e <CheckSorted+0x52>

uint32 CheckSorted(int *Elements, int NumOfElements)
{
	uint32 Sorted = 1 ;
	int i ;
	for (i = 0 ; i < NumOfElements - 1; i++)
  800462:	ff 45 f8             	incl   -0x8(%ebp)
  800465:	8b 45 0c             	mov    0xc(%ebp),%eax
  800468:	48                   	dec    %eax
  800469:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  80046c:	7f c4                	jg     800432 <CheckSorted+0x16>
		{
			Sorted = 0 ;
			break;
		}
	}
	return Sorted ;
  80046e:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800471:	c9                   	leave  
  800472:	c3                   	ret    

00800473 <Swap>:

///Private Functions


void Swap(int *Elements, int First, int Second)
{
  800473:	55                   	push   %ebp
  800474:	89 e5                	mov    %esp,%ebp
  800476:	83 ec 10             	sub    $0x10,%esp
	int Tmp = Elements[First] ;
  800479:	8b 45 0c             	mov    0xc(%ebp),%eax
  80047c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800483:	8b 45 08             	mov    0x8(%ebp),%eax
  800486:	01 d0                	add    %edx,%eax
  800488:	8b 00                	mov    (%eax),%eax
  80048a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	Elements[First] = Elements[Second] ;
  80048d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800490:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800497:	8b 45 08             	mov    0x8(%ebp),%eax
  80049a:	01 c2                	add    %eax,%edx
  80049c:	8b 45 10             	mov    0x10(%ebp),%eax
  80049f:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8004a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8004a9:	01 c8                	add    %ecx,%eax
  8004ab:	8b 00                	mov    (%eax),%eax
  8004ad:	89 02                	mov    %eax,(%edx)
	Elements[Second] = Tmp ;
  8004af:	8b 45 10             	mov    0x10(%ebp),%eax
  8004b2:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8004b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8004bc:	01 c2                	add    %eax,%edx
  8004be:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8004c1:	89 02                	mov    %eax,(%edx)
}
  8004c3:	90                   	nop
  8004c4:	c9                   	leave  
  8004c5:	c3                   	ret    

008004c6 <InitializeAscending>:

void InitializeAscending(int *Elements, int NumOfElements)
{
  8004c6:	55                   	push   %ebp
  8004c7:	89 e5                	mov    %esp,%ebp
  8004c9:	83 ec 10             	sub    $0x10,%esp
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  8004cc:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8004d3:	eb 17                	jmp    8004ec <InitializeAscending+0x26>
	{
		(Elements)[i] = i ;
  8004d5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8004d8:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8004df:	8b 45 08             	mov    0x8(%ebp),%eax
  8004e2:	01 c2                	add    %eax,%edx
  8004e4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8004e7:	89 02                	mov    %eax,(%edx)
}

void InitializeAscending(int *Elements, int NumOfElements)
{
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  8004e9:	ff 45 fc             	incl   -0x4(%ebp)
  8004ec:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8004ef:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8004f2:	7c e1                	jl     8004d5 <InitializeAscending+0xf>
	{
		(Elements)[i] = i ;
	}

}
  8004f4:	90                   	nop
  8004f5:	c9                   	leave  
  8004f6:	c3                   	ret    

008004f7 <InitializeIdentical>:

void InitializeIdentical(int *Elements, int NumOfElements)
{
  8004f7:	55                   	push   %ebp
  8004f8:	89 e5                	mov    %esp,%ebp
  8004fa:	83 ec 10             	sub    $0x10,%esp
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  8004fd:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800504:	eb 1b                	jmp    800521 <InitializeIdentical+0x2a>
	{
		Elements[i] = NumOfElements - i - 1 ;
  800506:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800509:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800510:	8b 45 08             	mov    0x8(%ebp),%eax
  800513:	01 c2                	add    %eax,%edx
  800515:	8b 45 0c             	mov    0xc(%ebp),%eax
  800518:	2b 45 fc             	sub    -0x4(%ebp),%eax
  80051b:	48                   	dec    %eax
  80051c:	89 02                	mov    %eax,(%edx)
}

void InitializeIdentical(int *Elements, int NumOfElements)
{
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  80051e:	ff 45 fc             	incl   -0x4(%ebp)
  800521:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800524:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800527:	7c dd                	jl     800506 <InitializeIdentical+0xf>
	{
		Elements[i] = NumOfElements - i - 1 ;
	}

}
  800529:	90                   	nop
  80052a:	c9                   	leave  
  80052b:	c3                   	ret    

0080052c <InitializeSemiRandom>:

void InitializeSemiRandom(int *Elements, int NumOfElements)
{
  80052c:	55                   	push   %ebp
  80052d:	89 e5                	mov    %esp,%ebp
  80052f:	83 ec 10             	sub    $0x10,%esp
	int i ;
	int Repetition = NumOfElements / 3 ;
  800532:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800535:	b8 56 55 55 55       	mov    $0x55555556,%eax
  80053a:	f7 e9                	imul   %ecx
  80053c:	c1 f9 1f             	sar    $0x1f,%ecx
  80053f:	89 d0                	mov    %edx,%eax
  800541:	29 c8                	sub    %ecx,%eax
  800543:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (Repetition == 0)
  800546:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  80054a:	75 07                	jne    800553 <InitializeSemiRandom+0x27>
			Repetition = 3;
  80054c:	c7 45 f8 03 00 00 00 	movl   $0x3,-0x8(%ebp)
	for (i = 0 ; i < NumOfElements ; i++)
  800553:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80055a:	eb 1e                	jmp    80057a <InitializeSemiRandom+0x4e>
	{
		Elements[i] = i % Repetition ;
  80055c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80055f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800566:	8b 45 08             	mov    0x8(%ebp),%eax
  800569:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  80056c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80056f:	99                   	cltd   
  800570:	f7 7d f8             	idivl  -0x8(%ebp)
  800573:	89 d0                	mov    %edx,%eax
  800575:	89 01                	mov    %eax,(%ecx)
{
	int i ;
	int Repetition = NumOfElements / 3 ;
	if (Repetition == 0)
			Repetition = 3;
	for (i = 0 ; i < NumOfElements ; i++)
  800577:	ff 45 fc             	incl   -0x4(%ebp)
  80057a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80057d:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800580:	7c da                	jl     80055c <InitializeSemiRandom+0x30>
	{
		Elements[i] = i % Repetition ;
	}

}
  800582:	90                   	nop
  800583:	c9                   	leave  
  800584:	c3                   	ret    

00800585 <PrintElements>:

void PrintElements(int *Elements, int NumOfElements)
{
  800585:	55                   	push   %ebp
  800586:	89 e5                	mov    %esp,%ebp
  800588:	83 ec 18             	sub    $0x18,%esp
	int envID = sys_getenvid();
  80058b:	e8 e7 1a 00 00       	call   802077 <sys_getenvid>
  800590:	89 45 f0             	mov    %eax,-0x10(%ebp)
	wait_semaphore(IO_CS);
  800593:	83 ec 0c             	sub    $0xc,%esp
  800596:	ff 35 60 c0 81 00    	pushl  0x81c060
  80059c:	e8 8c 28 00 00       	call   802e2d <wait_semaphore>
  8005a1:	83 c4 10             	add    $0x10,%esp
		int i ;
		int NumsPerLine = 20 ;
  8005a4:	c7 45 ec 14 00 00 00 	movl   $0x14,-0x14(%ebp)
		for (i = 0 ; i < NumOfElements-1 ; i++)
  8005ab:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  8005b2:	eb 42                	jmp    8005f6 <PrintElements+0x71>
		{
			if (i%NumsPerLine == 0)
  8005b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8005b7:	99                   	cltd   
  8005b8:	f7 7d ec             	idivl  -0x14(%ebp)
  8005bb:	89 d0                	mov    %edx,%eax
  8005bd:	85 c0                	test   %eax,%eax
  8005bf:	75 10                	jne    8005d1 <PrintElements+0x4c>
				cprintf("\n");
  8005c1:	83 ec 0c             	sub    $0xc,%esp
  8005c4:	68 72 32 80 00       	push   $0x803272
  8005c9:	e8 36 05 00 00       	call   800b04 <cprintf>
  8005ce:	83 c4 10             	add    $0x10,%esp
			cprintf("%d, ",Elements[i]);
  8005d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8005d4:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8005db:	8b 45 08             	mov    0x8(%ebp),%eax
  8005de:	01 d0                	add    %edx,%eax
  8005e0:	8b 00                	mov    (%eax),%eax
  8005e2:	83 ec 08             	sub    $0x8,%esp
  8005e5:	50                   	push   %eax
  8005e6:	68 74 32 80 00       	push   $0x803274
  8005eb:	e8 14 05 00 00       	call   800b04 <cprintf>
  8005f0:	83 c4 10             	add    $0x10,%esp
{
	int envID = sys_getenvid();
	wait_semaphore(IO_CS);
		int i ;
		int NumsPerLine = 20 ;
		for (i = 0 ; i < NumOfElements-1 ; i++)
  8005f3:	ff 45 f4             	incl   -0xc(%ebp)
  8005f6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8005f9:	48                   	dec    %eax
  8005fa:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8005fd:	7f b5                	jg     8005b4 <PrintElements+0x2f>
		{
			if (i%NumsPerLine == 0)
				cprintf("\n");
			cprintf("%d, ",Elements[i]);
		}
		cprintf("%d\n",Elements[i]);
  8005ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800602:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800609:	8b 45 08             	mov    0x8(%ebp),%eax
  80060c:	01 d0                	add    %edx,%eax
  80060e:	8b 00                	mov    (%eax),%eax
  800610:	83 ec 08             	sub    $0x8,%esp
  800613:	50                   	push   %eax
  800614:	68 79 32 80 00       	push   $0x803279
  800619:	e8 e6 04 00 00       	call   800b04 <cprintf>
  80061e:	83 c4 10             	add    $0x10,%esp
	signal_semaphore(IO_CS);
  800621:	83 ec 0c             	sub    $0xc,%esp
  800624:	ff 35 60 c0 81 00    	pushl  0x81c060
  80062a:	e8 18 28 00 00       	call   802e47 <signal_semaphore>
  80062f:	83 c4 10             	add    $0x10,%esp
}
  800632:	90                   	nop
  800633:	c9                   	leave  
  800634:	c3                   	ret    

00800635 <cputchar>:
#include <inc/lib.h>


void
cputchar(int ch)
{
  800635:	55                   	push   %ebp
  800636:	89 e5                	mov    %esp,%ebp
  800638:	83 ec 18             	sub    $0x18,%esp
	char c = ch;
  80063b:	8b 45 08             	mov    0x8(%ebp),%eax
  80063e:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	//sys_cputs(&c, 1);

	sys_cputc(c);
  800641:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  800645:	83 ec 0c             	sub    $0xc,%esp
  800648:	50                   	push   %eax
  800649:	e8 11 19 00 00       	call   801f5f <sys_cputc>
  80064e:	83 c4 10             	add    $0x10,%esp
}
  800651:	90                   	nop
  800652:	c9                   	leave  
  800653:	c3                   	ret    

00800654 <getchar>:


int
getchar(void)
{
  800654:	55                   	push   %ebp
  800655:	89 e5                	mov    %esp,%ebp
  800657:	83 ec 18             	sub    $0x18,%esp
	int c =sys_cgetc();
  80065a:	e8 9f 17 00 00       	call   801dfe <sys_cgetc>
  80065f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	return c;
  800662:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800665:	c9                   	leave  
  800666:	c3                   	ret    

00800667 <iscons>:

int iscons(int fdnum)
{
  800667:	55                   	push   %ebp
  800668:	89 e5                	mov    %esp,%ebp
	// used by readline
	return 1;
  80066a:	b8 01 00 00 00       	mov    $0x1,%eax
}
  80066f:	5d                   	pop    %ebp
  800670:	c3                   	ret    

00800671 <libmain>:
volatile bool printStats = 1;

volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";
void
libmain(int argc, char **argv)
{
  800671:	55                   	push   %ebp
  800672:	89 e5                	mov    %esp,%ebp
  800674:	57                   	push   %edi
  800675:	56                   	push   %esi
  800676:	53                   	push   %ebx
  800677:	83 ec 7c             	sub    $0x7c,%esp
	//printStats = 1;
	int envIndex = sys_getenvindex();
  80067a:	e8 11 1a 00 00       	call   802090 <sys_getenvindex>
  80067f:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	myEnv = &(envs[envIndex]);
  800682:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800685:	89 d0                	mov    %edx,%eax
  800687:	c1 e0 06             	shl    $0x6,%eax
  80068a:	29 d0                	sub    %edx,%eax
  80068c:	c1 e0 02             	shl    $0x2,%eax
  80068f:	01 d0                	add    %edx,%eax
  800691:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800698:	01 c8                	add    %ecx,%eax
  80069a:	c1 e0 03             	shl    $0x3,%eax
  80069d:	01 d0                	add    %edx,%eax
  80069f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8006a6:	29 c2                	sub    %eax,%edx
  8006a8:	8d 04 95 00 00 00 00 	lea    0x0(,%edx,4),%eax
  8006af:	89 c2                	mov    %eax,%edx
  8006b1:	8d 82 00 00 c0 ee    	lea    -0x11400000(%edx),%eax
  8006b7:	a3 24 40 80 00       	mov    %eax,0x804024

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  8006bc:	a1 24 40 80 00       	mov    0x804024,%eax
  8006c1:	8a 40 20             	mov    0x20(%eax),%al
  8006c4:	84 c0                	test   %al,%al
  8006c6:	74 0d                	je     8006d5 <libmain+0x64>
		binaryname = myEnv->prog_name;
  8006c8:	a1 24 40 80 00       	mov    0x804024,%eax
  8006cd:	83 c0 20             	add    $0x20,%eax
  8006d0:	a3 04 40 80 00       	mov    %eax,0x804004

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8006d5:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8006d9:	7e 0a                	jle    8006e5 <libmain+0x74>
		binaryname = argv[0];
  8006db:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006de:	8b 00                	mov    (%eax),%eax
  8006e0:	a3 04 40 80 00       	mov    %eax,0x804004

	// call user main routine
	_main(argc, argv);
  8006e5:	83 ec 08             	sub    $0x8,%esp
  8006e8:	ff 75 0c             	pushl  0xc(%ebp)
  8006eb:	ff 75 08             	pushl  0x8(%ebp)
  8006ee:	e8 45 f9 ff ff       	call   800038 <_main>
  8006f3:	83 c4 10             	add    $0x10,%esp

	if (printStats)
  8006f6:	a1 00 40 80 00       	mov    0x804000,%eax
  8006fb:	85 c0                	test   %eax,%eax
  8006fd:	0f 84 01 01 00 00    	je     800804 <libmain+0x193>
	{
		char isOPTReplCmd[100] = "__IsOPTRepl__" ;
  800703:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  800709:	bb 78 33 80 00       	mov    $0x803378,%ebx
  80070e:	ba 0e 00 00 00       	mov    $0xe,%edx
  800713:	89 c7                	mov    %eax,%edi
  800715:	89 de                	mov    %ebx,%esi
  800717:	89 d1                	mov    %edx,%ecx
  800719:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  80071b:	8d 55 8a             	lea    -0x76(%ebp),%edx
  80071e:	b9 56 00 00 00       	mov    $0x56,%ecx
  800723:	b0 00                	mov    $0x0,%al
  800725:	89 d7                	mov    %edx,%edi
  800727:	f3 aa                	rep stos %al,%es:(%edi)
		int isOPTRepl = 0;
  800729:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
		sys_utilities(isOPTReplCmd, (uint32)(&isOPTRepl));
  800730:	8d 45 e0             	lea    -0x20(%ebp),%eax
  800733:	83 ec 08             	sub    $0x8,%esp
  800736:	50                   	push   %eax
  800737:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  80073d:	50                   	push   %eax
  80073e:	e8 83 1b 00 00       	call   8022c6 <sys_utilities>
  800743:	83 c4 10             	add    $0x10,%esp

		sys_lock_cons();
  800746:	e8 cc 16 00 00       	call   801e17 <sys_lock_cons>
		{
			cprintf("**************************************\n");
  80074b:	83 ec 0c             	sub    $0xc,%esp
  80074e:	68 98 32 80 00       	push   $0x803298
  800753:	e8 ac 03 00 00       	call   800b04 <cprintf>
  800758:	83 c4 10             	add    $0x10,%esp
			if (isOPTRepl)
  80075b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80075e:	85 c0                	test   %eax,%eax
  800760:	74 18                	je     80077a <libmain+0x109>
			{
				cprintf("OPTIMAL number of page faults = %d\n", sys_get_optimal_num_faults());
  800762:	e8 7d 1b 00 00       	call   8022e4 <sys_get_optimal_num_faults>
  800767:	83 ec 08             	sub    $0x8,%esp
  80076a:	50                   	push   %eax
  80076b:	68 c0 32 80 00       	push   $0x8032c0
  800770:	e8 8f 03 00 00       	call   800b04 <cprintf>
  800775:	83 c4 10             	add    $0x10,%esp
  800778:	eb 59                	jmp    8007d3 <libmain+0x162>
			}
			else
			{
				cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  80077a:	a1 24 40 80 00       	mov    0x804024,%eax
  80077f:	8b 90 50 da 01 00    	mov    0x1da50(%eax),%edx
  800785:	a1 24 40 80 00       	mov    0x804024,%eax
  80078a:	8b 80 40 da 01 00    	mov    0x1da40(%eax),%eax
  800790:	83 ec 04             	sub    $0x4,%esp
  800793:	52                   	push   %edx
  800794:	50                   	push   %eax
  800795:	68 e4 32 80 00       	push   $0x8032e4
  80079a:	e8 65 03 00 00       	call   800b04 <cprintf>
  80079f:	83 c4 10             	add    $0x10,%esp
				cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  8007a2:	a1 24 40 80 00       	mov    0x804024,%eax
  8007a7:	8b 88 64 da 01 00    	mov    0x1da64(%eax),%ecx
  8007ad:	a1 24 40 80 00       	mov    0x804024,%eax
  8007b2:	8b 90 60 da 01 00    	mov    0x1da60(%eax),%edx
  8007b8:	a1 24 40 80 00       	mov    0x804024,%eax
  8007bd:	8b 80 5c da 01 00    	mov    0x1da5c(%eax),%eax
  8007c3:	51                   	push   %ecx
  8007c4:	52                   	push   %edx
  8007c5:	50                   	push   %eax
  8007c6:	68 0c 33 80 00       	push   $0x80330c
  8007cb:	e8 34 03 00 00       	call   800b04 <cprintf>
  8007d0:	83 c4 10             	add    $0x10,%esp
			}
			//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
			cprintf("Num of clocks = %d\n", myEnv->nClocks);
  8007d3:	a1 24 40 80 00       	mov    0x804024,%eax
  8007d8:	8b 80 68 da 01 00    	mov    0x1da68(%eax),%eax
  8007de:	83 ec 08             	sub    $0x8,%esp
  8007e1:	50                   	push   %eax
  8007e2:	68 64 33 80 00       	push   $0x803364
  8007e7:	e8 18 03 00 00       	call   800b04 <cprintf>
  8007ec:	83 c4 10             	add    $0x10,%esp
			cprintf("**************************************\n");
  8007ef:	83 ec 0c             	sub    $0xc,%esp
  8007f2:	68 98 32 80 00       	push   $0x803298
  8007f7:	e8 08 03 00 00       	call   800b04 <cprintf>
  8007fc:	83 c4 10             	add    $0x10,%esp
		}
		sys_unlock_cons();
  8007ff:	e8 2d 16 00 00       	call   801e31 <sys_unlock_cons>
	}

	// exit gracefully
	exit();
  800804:	e8 1f 00 00 00       	call   800828 <exit>
}
  800809:	90                   	nop
  80080a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80080d:	5b                   	pop    %ebx
  80080e:	5e                   	pop    %esi
  80080f:	5f                   	pop    %edi
  800810:	5d                   	pop    %ebp
  800811:	c3                   	ret    

00800812 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800812:	55                   	push   %ebp
  800813:	89 e5                	mov    %esp,%ebp
  800815:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800818:	83 ec 0c             	sub    $0xc,%esp
  80081b:	6a 00                	push   $0x0
  80081d:	e8 3a 18 00 00       	call   80205c <sys_destroy_env>
  800822:	83 c4 10             	add    $0x10,%esp
}
  800825:	90                   	nop
  800826:	c9                   	leave  
  800827:	c3                   	ret    

00800828 <exit>:

void
exit(void)
{
  800828:	55                   	push   %ebp
  800829:	89 e5                	mov    %esp,%ebp
  80082b:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  80082e:	e8 8f 18 00 00       	call   8020c2 <sys_exit_env>
}
  800833:	90                   	nop
  800834:	c9                   	leave  
  800835:	c3                   	ret    

00800836 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  800836:	55                   	push   %ebp
  800837:	89 e5                	mov    %esp,%ebp
  800839:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  80083c:	8d 45 10             	lea    0x10(%ebp),%eax
  80083f:	83 c0 04             	add    $0x4,%eax
  800842:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  800845:	a1 18 c1 81 00       	mov    0x81c118,%eax
  80084a:	85 c0                	test   %eax,%eax
  80084c:	74 16                	je     800864 <_panic+0x2e>
		cprintf("%s: ", argv0);
  80084e:	a1 18 c1 81 00       	mov    0x81c118,%eax
  800853:	83 ec 08             	sub    $0x8,%esp
  800856:	50                   	push   %eax
  800857:	68 dc 33 80 00       	push   $0x8033dc
  80085c:	e8 a3 02 00 00       	call   800b04 <cprintf>
  800861:	83 c4 10             	add    $0x10,%esp
	cprintf_colored(TEXT_PANIC_CLR, "user [EVAL_FINAL]panic in %s at %s:%d: ", binaryname, file, line);
  800864:	a1 04 40 80 00       	mov    0x804004,%eax
  800869:	83 ec 0c             	sub    $0xc,%esp
  80086c:	ff 75 0c             	pushl  0xc(%ebp)
  80086f:	ff 75 08             	pushl  0x8(%ebp)
  800872:	50                   	push   %eax
  800873:	68 e4 33 80 00       	push   $0x8033e4
  800878:	6a 74                	push   $0x74
  80087a:	e8 b2 02 00 00       	call   800b31 <cprintf_colored>
  80087f:	83 c4 20             	add    $0x20,%esp
	vcprintf(fmt, ap);
  800882:	8b 45 10             	mov    0x10(%ebp),%eax
  800885:	83 ec 08             	sub    $0x8,%esp
  800888:	ff 75 f4             	pushl  -0xc(%ebp)
  80088b:	50                   	push   %eax
  80088c:	e8 04 02 00 00       	call   800a95 <vcprintf>
  800891:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  800894:	83 ec 08             	sub    $0x8,%esp
  800897:	6a 00                	push   $0x0
  800899:	68 0c 34 80 00       	push   $0x80340c
  80089e:	e8 f2 01 00 00       	call   800a95 <vcprintf>
  8008a3:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  8008a6:	e8 7d ff ff ff       	call   800828 <exit>

	// should not return here
	while (1) ;
  8008ab:	eb fe                	jmp    8008ab <_panic+0x75>

008008ad <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  8008ad:	55                   	push   %ebp
  8008ae:	89 e5                	mov    %esp,%ebp
  8008b0:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  8008b3:	a1 24 40 80 00       	mov    0x804024,%eax
  8008b8:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  8008be:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008c1:	39 c2                	cmp    %eax,%edx
  8008c3:	74 14                	je     8008d9 <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  8008c5:	83 ec 04             	sub    $0x4,%esp
  8008c8:	68 10 34 80 00       	push   $0x803410
  8008cd:	6a 26                	push   $0x26
  8008cf:	68 5c 34 80 00       	push   $0x80345c
  8008d4:	e8 5d ff ff ff       	call   800836 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  8008d9:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  8008e0:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8008e7:	e9 c5 00 00 00       	jmp    8009b1 <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  8008ec:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8008ef:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8008f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8008f9:	01 d0                	add    %edx,%eax
  8008fb:	8b 00                	mov    (%eax),%eax
  8008fd:	85 c0                	test   %eax,%eax
  8008ff:	75 08                	jne    800909 <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  800901:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  800904:	e9 a5 00 00 00       	jmp    8009ae <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  800909:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800910:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  800917:	eb 69                	jmp    800982 <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  800919:	a1 24 40 80 00       	mov    0x804024,%eax
  80091e:	8b 88 38 da 01 00    	mov    0x1da38(%eax),%ecx
  800924:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800927:	89 d0                	mov    %edx,%eax
  800929:	01 c0                	add    %eax,%eax
  80092b:	01 d0                	add    %edx,%eax
  80092d:	c1 e0 03             	shl    $0x3,%eax
  800930:	01 c8                	add    %ecx,%eax
  800932:	8a 40 04             	mov    0x4(%eax),%al
  800935:	84 c0                	test   %al,%al
  800937:	75 46                	jne    80097f <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800939:	a1 24 40 80 00       	mov    0x804024,%eax
  80093e:	8b 88 38 da 01 00    	mov    0x1da38(%eax),%ecx
  800944:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800947:	89 d0                	mov    %edx,%eax
  800949:	01 c0                	add    %eax,%eax
  80094b:	01 d0                	add    %edx,%eax
  80094d:	c1 e0 03             	shl    $0x3,%eax
  800950:	01 c8                	add    %ecx,%eax
  800952:	8b 00                	mov    (%eax),%eax
  800954:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800957:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80095a:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80095f:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  800961:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800964:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  80096b:	8b 45 08             	mov    0x8(%ebp),%eax
  80096e:	01 c8                	add    %ecx,%eax
  800970:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800972:	39 c2                	cmp    %eax,%edx
  800974:	75 09                	jne    80097f <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  800976:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  80097d:	eb 15                	jmp    800994 <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80097f:	ff 45 e8             	incl   -0x18(%ebp)
  800982:	a1 24 40 80 00       	mov    0x804024,%eax
  800987:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  80098d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800990:	39 c2                	cmp    %eax,%edx
  800992:	77 85                	ja     800919 <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  800994:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800998:	75 14                	jne    8009ae <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  80099a:	83 ec 04             	sub    $0x4,%esp
  80099d:	68 68 34 80 00       	push   $0x803468
  8009a2:	6a 3a                	push   $0x3a
  8009a4:	68 5c 34 80 00       	push   $0x80345c
  8009a9:	e8 88 fe ff ff       	call   800836 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  8009ae:	ff 45 f0             	incl   -0x10(%ebp)
  8009b1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8009b4:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8009b7:	0f 8c 2f ff ff ff    	jl     8008ec <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  8009bd:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8009c4:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  8009cb:	eb 26                	jmp    8009f3 <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  8009cd:	a1 24 40 80 00       	mov    0x804024,%eax
  8009d2:	8b 88 38 da 01 00    	mov    0x1da38(%eax),%ecx
  8009d8:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8009db:	89 d0                	mov    %edx,%eax
  8009dd:	01 c0                	add    %eax,%eax
  8009df:	01 d0                	add    %edx,%eax
  8009e1:	c1 e0 03             	shl    $0x3,%eax
  8009e4:	01 c8                	add    %ecx,%eax
  8009e6:	8a 40 04             	mov    0x4(%eax),%al
  8009e9:	3c 01                	cmp    $0x1,%al
  8009eb:	75 03                	jne    8009f0 <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  8009ed:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8009f0:	ff 45 e0             	incl   -0x20(%ebp)
  8009f3:	a1 24 40 80 00       	mov    0x804024,%eax
  8009f8:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  8009fe:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800a01:	39 c2                	cmp    %eax,%edx
  800a03:	77 c8                	ja     8009cd <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  800a05:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800a08:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800a0b:	74 14                	je     800a21 <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  800a0d:	83 ec 04             	sub    $0x4,%esp
  800a10:	68 bc 34 80 00       	push   $0x8034bc
  800a15:	6a 44                	push   $0x44
  800a17:	68 5c 34 80 00       	push   $0x80345c
  800a1c:	e8 15 fe ff ff       	call   800836 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  800a21:	90                   	nop
  800a22:	c9                   	leave  
  800a23:	c3                   	ret    

00800a24 <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  800a24:	55                   	push   %ebp
  800a25:	89 e5                	mov    %esp,%ebp
  800a27:	53                   	push   %ebx
  800a28:	83 ec 04             	sub    $0x4,%esp
	b->buf[b->idx++] = ch;
  800a2b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a2e:	8b 00                	mov    (%eax),%eax
  800a30:	8d 48 01             	lea    0x1(%eax),%ecx
  800a33:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a36:	89 0a                	mov    %ecx,(%edx)
  800a38:	8b 55 08             	mov    0x8(%ebp),%edx
  800a3b:	88 d1                	mov    %dl,%cl
  800a3d:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a40:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800a44:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a47:	8b 00                	mov    (%eax),%eax
  800a49:	3d ff 00 00 00       	cmp    $0xff,%eax
  800a4e:	75 30                	jne    800a80 <putch+0x5c>
		sys_cputs(b->buf, b->idx, printProgName, curTextClr);
  800a50:	8b 15 1c c1 81 00    	mov    0x81c11c,%edx
  800a56:	a0 44 40 80 00       	mov    0x804044,%al
  800a5b:	0f b6 c0             	movzbl %al,%eax
  800a5e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800a61:	8b 09                	mov    (%ecx),%ecx
  800a63:	89 cb                	mov    %ecx,%ebx
  800a65:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800a68:	83 c1 08             	add    $0x8,%ecx
  800a6b:	52                   	push   %edx
  800a6c:	50                   	push   %eax
  800a6d:	53                   	push   %ebx
  800a6e:	51                   	push   %ecx
  800a6f:	e8 5f 13 00 00       	call   801dd3 <sys_cputs>
  800a74:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800a77:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a7a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800a80:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a83:	8b 40 04             	mov    0x4(%eax),%eax
  800a86:	8d 50 01             	lea    0x1(%eax),%edx
  800a89:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a8c:	89 50 04             	mov    %edx,0x4(%eax)
}
  800a8f:	90                   	nop
  800a90:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800a93:	c9                   	leave  
  800a94:	c3                   	ret    

00800a95 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800a95:	55                   	push   %ebp
  800a96:	89 e5                	mov    %esp,%ebp
  800a98:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800a9e:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800aa5:	00 00 00 
	b.cnt = 0;
  800aa8:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800aaf:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800ab2:	ff 75 0c             	pushl  0xc(%ebp)
  800ab5:	ff 75 08             	pushl  0x8(%ebp)
  800ab8:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800abe:	50                   	push   %eax
  800abf:	68 24 0a 80 00       	push   $0x800a24
  800ac4:	e8 5a 02 00 00       	call   800d23 <vprintfmt>
  800ac9:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName, curTextClr);
  800acc:	8b 15 1c c1 81 00    	mov    0x81c11c,%edx
  800ad2:	a0 44 40 80 00       	mov    0x804044,%al
  800ad7:	0f b6 c0             	movzbl %al,%eax
  800ada:	8b 8d f0 fe ff ff    	mov    -0x110(%ebp),%ecx
  800ae0:	52                   	push   %edx
  800ae1:	50                   	push   %eax
  800ae2:	51                   	push   %ecx
  800ae3:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800ae9:	83 c0 08             	add    $0x8,%eax
  800aec:	50                   	push   %eax
  800aed:	e8 e1 12 00 00       	call   801dd3 <sys_cputs>
  800af2:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800af5:	c6 05 44 40 80 00 00 	movb   $0x0,0x804044
	return b.cnt;
  800afc:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800b02:	c9                   	leave  
  800b03:	c3                   	ret    

00800b04 <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  800b04:	55                   	push   %ebp
  800b05:	89 e5                	mov    %esp,%ebp
  800b07:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800b0a:	c6 05 44 40 80 00 01 	movb   $0x1,0x804044
	va_start(ap, fmt);
  800b11:	8d 45 0c             	lea    0xc(%ebp),%eax
  800b14:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800b17:	8b 45 08             	mov    0x8(%ebp),%eax
  800b1a:	83 ec 08             	sub    $0x8,%esp
  800b1d:	ff 75 f4             	pushl  -0xc(%ebp)
  800b20:	50                   	push   %eax
  800b21:	e8 6f ff ff ff       	call   800a95 <vcprintf>
  800b26:	83 c4 10             	add    $0x10,%esp
  800b29:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800b2c:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800b2f:	c9                   	leave  
  800b30:	c3                   	ret    

00800b31 <cprintf_colored>:

// *************** This text coloring feature is implemented by *************
// ********** Abd-Alrahman Zedan From Team Frozen-Bytes - FCIS'24-25 ********
int cprintf_colored(int textClr, const char *fmt, ...) {
  800b31:	55                   	push   %ebp
  800b32:	89 e5                	mov    %esp,%ebp
  800b34:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800b37:	c6 05 44 40 80 00 01 	movb   $0x1,0x804044
	curTextClr = (textClr << 8) ; //set text color by the given value
  800b3e:	8b 45 08             	mov    0x8(%ebp),%eax
  800b41:	c1 e0 08             	shl    $0x8,%eax
  800b44:	a3 1c c1 81 00       	mov    %eax,0x81c11c
	va_start(ap, fmt);
  800b49:	8d 45 0c             	lea    0xc(%ebp),%eax
  800b4c:	83 c0 04             	add    $0x4,%eax
  800b4f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800b52:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b55:	83 ec 08             	sub    $0x8,%esp
  800b58:	ff 75 f4             	pushl  -0xc(%ebp)
  800b5b:	50                   	push   %eax
  800b5c:	e8 34 ff ff ff       	call   800a95 <vcprintf>
  800b61:	83 c4 10             	add    $0x10,%esp
  800b64:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);
	curTextClr = TEXT_DEFAULT_CLR; //restore default color
  800b67:	c7 05 1c c1 81 00 00 	movl   $0x700,0x81c11c
  800b6e:	07 00 00 

	return cnt;
  800b71:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800b74:	c9                   	leave  
  800b75:	c3                   	ret    

00800b76 <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  800b76:	55                   	push   %ebp
  800b77:	89 e5                	mov    %esp,%ebp
  800b79:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  800b7c:	e8 96 12 00 00       	call   801e17 <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  800b81:	8d 45 0c             	lea    0xc(%ebp),%eax
  800b84:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  800b87:	8b 45 08             	mov    0x8(%ebp),%eax
  800b8a:	83 ec 08             	sub    $0x8,%esp
  800b8d:	ff 75 f4             	pushl  -0xc(%ebp)
  800b90:	50                   	push   %eax
  800b91:	e8 ff fe ff ff       	call   800a95 <vcprintf>
  800b96:	83 c4 10             	add    $0x10,%esp
  800b99:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  800b9c:	e8 90 12 00 00       	call   801e31 <sys_unlock_cons>
	return cnt;
  800ba1:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800ba4:	c9                   	leave  
  800ba5:	c3                   	ret    

00800ba6 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800ba6:	55                   	push   %ebp
  800ba7:	89 e5                	mov    %esp,%ebp
  800ba9:	53                   	push   %ebx
  800baa:	83 ec 14             	sub    $0x14,%esp
  800bad:	8b 45 10             	mov    0x10(%ebp),%eax
  800bb0:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800bb3:	8b 45 14             	mov    0x14(%ebp),%eax
  800bb6:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800bb9:	8b 45 18             	mov    0x18(%ebp),%eax
  800bbc:	ba 00 00 00 00       	mov    $0x0,%edx
  800bc1:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800bc4:	77 55                	ja     800c1b <printnum+0x75>
  800bc6:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800bc9:	72 05                	jb     800bd0 <printnum+0x2a>
  800bcb:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800bce:	77 4b                	ja     800c1b <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800bd0:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800bd3:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800bd6:	8b 45 18             	mov    0x18(%ebp),%eax
  800bd9:	ba 00 00 00 00       	mov    $0x0,%edx
  800bde:	52                   	push   %edx
  800bdf:	50                   	push   %eax
  800be0:	ff 75 f4             	pushl  -0xc(%ebp)
  800be3:	ff 75 f0             	pushl  -0x10(%ebp)
  800be6:	e8 81 22 00 00       	call   802e6c <__udivdi3>
  800beb:	83 c4 10             	add    $0x10,%esp
  800bee:	83 ec 04             	sub    $0x4,%esp
  800bf1:	ff 75 20             	pushl  0x20(%ebp)
  800bf4:	53                   	push   %ebx
  800bf5:	ff 75 18             	pushl  0x18(%ebp)
  800bf8:	52                   	push   %edx
  800bf9:	50                   	push   %eax
  800bfa:	ff 75 0c             	pushl  0xc(%ebp)
  800bfd:	ff 75 08             	pushl  0x8(%ebp)
  800c00:	e8 a1 ff ff ff       	call   800ba6 <printnum>
  800c05:	83 c4 20             	add    $0x20,%esp
  800c08:	eb 1a                	jmp    800c24 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800c0a:	83 ec 08             	sub    $0x8,%esp
  800c0d:	ff 75 0c             	pushl  0xc(%ebp)
  800c10:	ff 75 20             	pushl  0x20(%ebp)
  800c13:	8b 45 08             	mov    0x8(%ebp),%eax
  800c16:	ff d0                	call   *%eax
  800c18:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800c1b:	ff 4d 1c             	decl   0x1c(%ebp)
  800c1e:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800c22:	7f e6                	jg     800c0a <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800c24:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800c27:	bb 00 00 00 00       	mov    $0x0,%ebx
  800c2c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800c2f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800c32:	53                   	push   %ebx
  800c33:	51                   	push   %ecx
  800c34:	52                   	push   %edx
  800c35:	50                   	push   %eax
  800c36:	e8 41 23 00 00       	call   802f7c <__umoddi3>
  800c3b:	83 c4 10             	add    $0x10,%esp
  800c3e:	05 34 37 80 00       	add    $0x803734,%eax
  800c43:	8a 00                	mov    (%eax),%al
  800c45:	0f be c0             	movsbl %al,%eax
  800c48:	83 ec 08             	sub    $0x8,%esp
  800c4b:	ff 75 0c             	pushl  0xc(%ebp)
  800c4e:	50                   	push   %eax
  800c4f:	8b 45 08             	mov    0x8(%ebp),%eax
  800c52:	ff d0                	call   *%eax
  800c54:	83 c4 10             	add    $0x10,%esp
}
  800c57:	90                   	nop
  800c58:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800c5b:	c9                   	leave  
  800c5c:	c3                   	ret    

00800c5d <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800c5d:	55                   	push   %ebp
  800c5e:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800c60:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800c64:	7e 1c                	jle    800c82 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800c66:	8b 45 08             	mov    0x8(%ebp),%eax
  800c69:	8b 00                	mov    (%eax),%eax
  800c6b:	8d 50 08             	lea    0x8(%eax),%edx
  800c6e:	8b 45 08             	mov    0x8(%ebp),%eax
  800c71:	89 10                	mov    %edx,(%eax)
  800c73:	8b 45 08             	mov    0x8(%ebp),%eax
  800c76:	8b 00                	mov    (%eax),%eax
  800c78:	83 e8 08             	sub    $0x8,%eax
  800c7b:	8b 50 04             	mov    0x4(%eax),%edx
  800c7e:	8b 00                	mov    (%eax),%eax
  800c80:	eb 40                	jmp    800cc2 <getuint+0x65>
	else if (lflag)
  800c82:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c86:	74 1e                	je     800ca6 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800c88:	8b 45 08             	mov    0x8(%ebp),%eax
  800c8b:	8b 00                	mov    (%eax),%eax
  800c8d:	8d 50 04             	lea    0x4(%eax),%edx
  800c90:	8b 45 08             	mov    0x8(%ebp),%eax
  800c93:	89 10                	mov    %edx,(%eax)
  800c95:	8b 45 08             	mov    0x8(%ebp),%eax
  800c98:	8b 00                	mov    (%eax),%eax
  800c9a:	83 e8 04             	sub    $0x4,%eax
  800c9d:	8b 00                	mov    (%eax),%eax
  800c9f:	ba 00 00 00 00       	mov    $0x0,%edx
  800ca4:	eb 1c                	jmp    800cc2 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800ca6:	8b 45 08             	mov    0x8(%ebp),%eax
  800ca9:	8b 00                	mov    (%eax),%eax
  800cab:	8d 50 04             	lea    0x4(%eax),%edx
  800cae:	8b 45 08             	mov    0x8(%ebp),%eax
  800cb1:	89 10                	mov    %edx,(%eax)
  800cb3:	8b 45 08             	mov    0x8(%ebp),%eax
  800cb6:	8b 00                	mov    (%eax),%eax
  800cb8:	83 e8 04             	sub    $0x4,%eax
  800cbb:	8b 00                	mov    (%eax),%eax
  800cbd:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800cc2:	5d                   	pop    %ebp
  800cc3:	c3                   	ret    

00800cc4 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800cc4:	55                   	push   %ebp
  800cc5:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800cc7:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800ccb:	7e 1c                	jle    800ce9 <getint+0x25>
		return va_arg(*ap, long long);
  800ccd:	8b 45 08             	mov    0x8(%ebp),%eax
  800cd0:	8b 00                	mov    (%eax),%eax
  800cd2:	8d 50 08             	lea    0x8(%eax),%edx
  800cd5:	8b 45 08             	mov    0x8(%ebp),%eax
  800cd8:	89 10                	mov    %edx,(%eax)
  800cda:	8b 45 08             	mov    0x8(%ebp),%eax
  800cdd:	8b 00                	mov    (%eax),%eax
  800cdf:	83 e8 08             	sub    $0x8,%eax
  800ce2:	8b 50 04             	mov    0x4(%eax),%edx
  800ce5:	8b 00                	mov    (%eax),%eax
  800ce7:	eb 38                	jmp    800d21 <getint+0x5d>
	else if (lflag)
  800ce9:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800ced:	74 1a                	je     800d09 <getint+0x45>
		return va_arg(*ap, long);
  800cef:	8b 45 08             	mov    0x8(%ebp),%eax
  800cf2:	8b 00                	mov    (%eax),%eax
  800cf4:	8d 50 04             	lea    0x4(%eax),%edx
  800cf7:	8b 45 08             	mov    0x8(%ebp),%eax
  800cfa:	89 10                	mov    %edx,(%eax)
  800cfc:	8b 45 08             	mov    0x8(%ebp),%eax
  800cff:	8b 00                	mov    (%eax),%eax
  800d01:	83 e8 04             	sub    $0x4,%eax
  800d04:	8b 00                	mov    (%eax),%eax
  800d06:	99                   	cltd   
  800d07:	eb 18                	jmp    800d21 <getint+0x5d>
	else
		return va_arg(*ap, int);
  800d09:	8b 45 08             	mov    0x8(%ebp),%eax
  800d0c:	8b 00                	mov    (%eax),%eax
  800d0e:	8d 50 04             	lea    0x4(%eax),%edx
  800d11:	8b 45 08             	mov    0x8(%ebp),%eax
  800d14:	89 10                	mov    %edx,(%eax)
  800d16:	8b 45 08             	mov    0x8(%ebp),%eax
  800d19:	8b 00                	mov    (%eax),%eax
  800d1b:	83 e8 04             	sub    $0x4,%eax
  800d1e:	8b 00                	mov    (%eax),%eax
  800d20:	99                   	cltd   
}
  800d21:	5d                   	pop    %ebp
  800d22:	c3                   	ret    

00800d23 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800d23:	55                   	push   %ebp
  800d24:	89 e5                	mov    %esp,%ebp
  800d26:	56                   	push   %esi
  800d27:	53                   	push   %ebx
  800d28:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800d2b:	eb 17                	jmp    800d44 <vprintfmt+0x21>
			if (ch == '\0')
  800d2d:	85 db                	test   %ebx,%ebx
  800d2f:	0f 84 c1 03 00 00    	je     8010f6 <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  800d35:	83 ec 08             	sub    $0x8,%esp
  800d38:	ff 75 0c             	pushl  0xc(%ebp)
  800d3b:	53                   	push   %ebx
  800d3c:	8b 45 08             	mov    0x8(%ebp),%eax
  800d3f:	ff d0                	call   *%eax
  800d41:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800d44:	8b 45 10             	mov    0x10(%ebp),%eax
  800d47:	8d 50 01             	lea    0x1(%eax),%edx
  800d4a:	89 55 10             	mov    %edx,0x10(%ebp)
  800d4d:	8a 00                	mov    (%eax),%al
  800d4f:	0f b6 d8             	movzbl %al,%ebx
  800d52:	83 fb 25             	cmp    $0x25,%ebx
  800d55:	75 d6                	jne    800d2d <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800d57:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800d5b:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800d62:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800d69:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800d70:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800d77:	8b 45 10             	mov    0x10(%ebp),%eax
  800d7a:	8d 50 01             	lea    0x1(%eax),%edx
  800d7d:	89 55 10             	mov    %edx,0x10(%ebp)
  800d80:	8a 00                	mov    (%eax),%al
  800d82:	0f b6 d8             	movzbl %al,%ebx
  800d85:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800d88:	83 f8 5b             	cmp    $0x5b,%eax
  800d8b:	0f 87 3d 03 00 00    	ja     8010ce <vprintfmt+0x3ab>
  800d91:	8b 04 85 58 37 80 00 	mov    0x803758(,%eax,4),%eax
  800d98:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800d9a:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800d9e:	eb d7                	jmp    800d77 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800da0:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800da4:	eb d1                	jmp    800d77 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800da6:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800dad:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800db0:	89 d0                	mov    %edx,%eax
  800db2:	c1 e0 02             	shl    $0x2,%eax
  800db5:	01 d0                	add    %edx,%eax
  800db7:	01 c0                	add    %eax,%eax
  800db9:	01 d8                	add    %ebx,%eax
  800dbb:	83 e8 30             	sub    $0x30,%eax
  800dbe:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800dc1:	8b 45 10             	mov    0x10(%ebp),%eax
  800dc4:	8a 00                	mov    (%eax),%al
  800dc6:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800dc9:	83 fb 2f             	cmp    $0x2f,%ebx
  800dcc:	7e 3e                	jle    800e0c <vprintfmt+0xe9>
  800dce:	83 fb 39             	cmp    $0x39,%ebx
  800dd1:	7f 39                	jg     800e0c <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800dd3:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800dd6:	eb d5                	jmp    800dad <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800dd8:	8b 45 14             	mov    0x14(%ebp),%eax
  800ddb:	83 c0 04             	add    $0x4,%eax
  800dde:	89 45 14             	mov    %eax,0x14(%ebp)
  800de1:	8b 45 14             	mov    0x14(%ebp),%eax
  800de4:	83 e8 04             	sub    $0x4,%eax
  800de7:	8b 00                	mov    (%eax),%eax
  800de9:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800dec:	eb 1f                	jmp    800e0d <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800dee:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800df2:	79 83                	jns    800d77 <vprintfmt+0x54>
				width = 0;
  800df4:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800dfb:	e9 77 ff ff ff       	jmp    800d77 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800e00:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800e07:	e9 6b ff ff ff       	jmp    800d77 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800e0c:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800e0d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800e11:	0f 89 60 ff ff ff    	jns    800d77 <vprintfmt+0x54>
				width = precision, precision = -1;
  800e17:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800e1a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800e1d:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800e24:	e9 4e ff ff ff       	jmp    800d77 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800e29:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800e2c:	e9 46 ff ff ff       	jmp    800d77 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800e31:	8b 45 14             	mov    0x14(%ebp),%eax
  800e34:	83 c0 04             	add    $0x4,%eax
  800e37:	89 45 14             	mov    %eax,0x14(%ebp)
  800e3a:	8b 45 14             	mov    0x14(%ebp),%eax
  800e3d:	83 e8 04             	sub    $0x4,%eax
  800e40:	8b 00                	mov    (%eax),%eax
  800e42:	83 ec 08             	sub    $0x8,%esp
  800e45:	ff 75 0c             	pushl  0xc(%ebp)
  800e48:	50                   	push   %eax
  800e49:	8b 45 08             	mov    0x8(%ebp),%eax
  800e4c:	ff d0                	call   *%eax
  800e4e:	83 c4 10             	add    $0x10,%esp
			break;
  800e51:	e9 9b 02 00 00       	jmp    8010f1 <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800e56:	8b 45 14             	mov    0x14(%ebp),%eax
  800e59:	83 c0 04             	add    $0x4,%eax
  800e5c:	89 45 14             	mov    %eax,0x14(%ebp)
  800e5f:	8b 45 14             	mov    0x14(%ebp),%eax
  800e62:	83 e8 04             	sub    $0x4,%eax
  800e65:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800e67:	85 db                	test   %ebx,%ebx
  800e69:	79 02                	jns    800e6d <vprintfmt+0x14a>
				err = -err;
  800e6b:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800e6d:	83 fb 64             	cmp    $0x64,%ebx
  800e70:	7f 0b                	jg     800e7d <vprintfmt+0x15a>
  800e72:	8b 34 9d a0 35 80 00 	mov    0x8035a0(,%ebx,4),%esi
  800e79:	85 f6                	test   %esi,%esi
  800e7b:	75 19                	jne    800e96 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800e7d:	53                   	push   %ebx
  800e7e:	68 45 37 80 00       	push   $0x803745
  800e83:	ff 75 0c             	pushl  0xc(%ebp)
  800e86:	ff 75 08             	pushl  0x8(%ebp)
  800e89:	e8 70 02 00 00       	call   8010fe <printfmt>
  800e8e:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800e91:	e9 5b 02 00 00       	jmp    8010f1 <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800e96:	56                   	push   %esi
  800e97:	68 4e 37 80 00       	push   $0x80374e
  800e9c:	ff 75 0c             	pushl  0xc(%ebp)
  800e9f:	ff 75 08             	pushl  0x8(%ebp)
  800ea2:	e8 57 02 00 00       	call   8010fe <printfmt>
  800ea7:	83 c4 10             	add    $0x10,%esp
			break;
  800eaa:	e9 42 02 00 00       	jmp    8010f1 <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800eaf:	8b 45 14             	mov    0x14(%ebp),%eax
  800eb2:	83 c0 04             	add    $0x4,%eax
  800eb5:	89 45 14             	mov    %eax,0x14(%ebp)
  800eb8:	8b 45 14             	mov    0x14(%ebp),%eax
  800ebb:	83 e8 04             	sub    $0x4,%eax
  800ebe:	8b 30                	mov    (%eax),%esi
  800ec0:	85 f6                	test   %esi,%esi
  800ec2:	75 05                	jne    800ec9 <vprintfmt+0x1a6>
				p = "(null)";
  800ec4:	be 51 37 80 00       	mov    $0x803751,%esi
			if (width > 0 && padc != '-')
  800ec9:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800ecd:	7e 6d                	jle    800f3c <vprintfmt+0x219>
  800ecf:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800ed3:	74 67                	je     800f3c <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800ed5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800ed8:	83 ec 08             	sub    $0x8,%esp
  800edb:	50                   	push   %eax
  800edc:	56                   	push   %esi
  800edd:	e8 26 05 00 00       	call   801408 <strnlen>
  800ee2:	83 c4 10             	add    $0x10,%esp
  800ee5:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800ee8:	eb 16                	jmp    800f00 <vprintfmt+0x1dd>
					putch(padc, putdat);
  800eea:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800eee:	83 ec 08             	sub    $0x8,%esp
  800ef1:	ff 75 0c             	pushl  0xc(%ebp)
  800ef4:	50                   	push   %eax
  800ef5:	8b 45 08             	mov    0x8(%ebp),%eax
  800ef8:	ff d0                	call   *%eax
  800efa:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800efd:	ff 4d e4             	decl   -0x1c(%ebp)
  800f00:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800f04:	7f e4                	jg     800eea <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800f06:	eb 34                	jmp    800f3c <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800f08:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800f0c:	74 1c                	je     800f2a <vprintfmt+0x207>
  800f0e:	83 fb 1f             	cmp    $0x1f,%ebx
  800f11:	7e 05                	jle    800f18 <vprintfmt+0x1f5>
  800f13:	83 fb 7e             	cmp    $0x7e,%ebx
  800f16:	7e 12                	jle    800f2a <vprintfmt+0x207>
					putch('?', putdat);
  800f18:	83 ec 08             	sub    $0x8,%esp
  800f1b:	ff 75 0c             	pushl  0xc(%ebp)
  800f1e:	6a 3f                	push   $0x3f
  800f20:	8b 45 08             	mov    0x8(%ebp),%eax
  800f23:	ff d0                	call   *%eax
  800f25:	83 c4 10             	add    $0x10,%esp
  800f28:	eb 0f                	jmp    800f39 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800f2a:	83 ec 08             	sub    $0x8,%esp
  800f2d:	ff 75 0c             	pushl  0xc(%ebp)
  800f30:	53                   	push   %ebx
  800f31:	8b 45 08             	mov    0x8(%ebp),%eax
  800f34:	ff d0                	call   *%eax
  800f36:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800f39:	ff 4d e4             	decl   -0x1c(%ebp)
  800f3c:	89 f0                	mov    %esi,%eax
  800f3e:	8d 70 01             	lea    0x1(%eax),%esi
  800f41:	8a 00                	mov    (%eax),%al
  800f43:	0f be d8             	movsbl %al,%ebx
  800f46:	85 db                	test   %ebx,%ebx
  800f48:	74 24                	je     800f6e <vprintfmt+0x24b>
  800f4a:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800f4e:	78 b8                	js     800f08 <vprintfmt+0x1e5>
  800f50:	ff 4d e0             	decl   -0x20(%ebp)
  800f53:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800f57:	79 af                	jns    800f08 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800f59:	eb 13                	jmp    800f6e <vprintfmt+0x24b>
				putch(' ', putdat);
  800f5b:	83 ec 08             	sub    $0x8,%esp
  800f5e:	ff 75 0c             	pushl  0xc(%ebp)
  800f61:	6a 20                	push   $0x20
  800f63:	8b 45 08             	mov    0x8(%ebp),%eax
  800f66:	ff d0                	call   *%eax
  800f68:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800f6b:	ff 4d e4             	decl   -0x1c(%ebp)
  800f6e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800f72:	7f e7                	jg     800f5b <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800f74:	e9 78 01 00 00       	jmp    8010f1 <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800f79:	83 ec 08             	sub    $0x8,%esp
  800f7c:	ff 75 e8             	pushl  -0x18(%ebp)
  800f7f:	8d 45 14             	lea    0x14(%ebp),%eax
  800f82:	50                   	push   %eax
  800f83:	e8 3c fd ff ff       	call   800cc4 <getint>
  800f88:	83 c4 10             	add    $0x10,%esp
  800f8b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800f8e:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800f91:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800f94:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800f97:	85 d2                	test   %edx,%edx
  800f99:	79 23                	jns    800fbe <vprintfmt+0x29b>
				putch('-', putdat);
  800f9b:	83 ec 08             	sub    $0x8,%esp
  800f9e:	ff 75 0c             	pushl  0xc(%ebp)
  800fa1:	6a 2d                	push   $0x2d
  800fa3:	8b 45 08             	mov    0x8(%ebp),%eax
  800fa6:	ff d0                	call   *%eax
  800fa8:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800fab:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800fae:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800fb1:	f7 d8                	neg    %eax
  800fb3:	83 d2 00             	adc    $0x0,%edx
  800fb6:	f7 da                	neg    %edx
  800fb8:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800fbb:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800fbe:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800fc5:	e9 bc 00 00 00       	jmp    801086 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800fca:	83 ec 08             	sub    $0x8,%esp
  800fcd:	ff 75 e8             	pushl  -0x18(%ebp)
  800fd0:	8d 45 14             	lea    0x14(%ebp),%eax
  800fd3:	50                   	push   %eax
  800fd4:	e8 84 fc ff ff       	call   800c5d <getuint>
  800fd9:	83 c4 10             	add    $0x10,%esp
  800fdc:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800fdf:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800fe2:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800fe9:	e9 98 00 00 00       	jmp    801086 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800fee:	83 ec 08             	sub    $0x8,%esp
  800ff1:	ff 75 0c             	pushl  0xc(%ebp)
  800ff4:	6a 58                	push   $0x58
  800ff6:	8b 45 08             	mov    0x8(%ebp),%eax
  800ff9:	ff d0                	call   *%eax
  800ffb:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800ffe:	83 ec 08             	sub    $0x8,%esp
  801001:	ff 75 0c             	pushl  0xc(%ebp)
  801004:	6a 58                	push   $0x58
  801006:	8b 45 08             	mov    0x8(%ebp),%eax
  801009:	ff d0                	call   *%eax
  80100b:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  80100e:	83 ec 08             	sub    $0x8,%esp
  801011:	ff 75 0c             	pushl  0xc(%ebp)
  801014:	6a 58                	push   $0x58
  801016:	8b 45 08             	mov    0x8(%ebp),%eax
  801019:	ff d0                	call   *%eax
  80101b:	83 c4 10             	add    $0x10,%esp
			break;
  80101e:	e9 ce 00 00 00       	jmp    8010f1 <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  801023:	83 ec 08             	sub    $0x8,%esp
  801026:	ff 75 0c             	pushl  0xc(%ebp)
  801029:	6a 30                	push   $0x30
  80102b:	8b 45 08             	mov    0x8(%ebp),%eax
  80102e:	ff d0                	call   *%eax
  801030:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  801033:	83 ec 08             	sub    $0x8,%esp
  801036:	ff 75 0c             	pushl  0xc(%ebp)
  801039:	6a 78                	push   $0x78
  80103b:	8b 45 08             	mov    0x8(%ebp),%eax
  80103e:	ff d0                	call   *%eax
  801040:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  801043:	8b 45 14             	mov    0x14(%ebp),%eax
  801046:	83 c0 04             	add    $0x4,%eax
  801049:	89 45 14             	mov    %eax,0x14(%ebp)
  80104c:	8b 45 14             	mov    0x14(%ebp),%eax
  80104f:	83 e8 04             	sub    $0x4,%eax
  801052:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  801054:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801057:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  80105e:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  801065:	eb 1f                	jmp    801086 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  801067:	83 ec 08             	sub    $0x8,%esp
  80106a:	ff 75 e8             	pushl  -0x18(%ebp)
  80106d:	8d 45 14             	lea    0x14(%ebp),%eax
  801070:	50                   	push   %eax
  801071:	e8 e7 fb ff ff       	call   800c5d <getuint>
  801076:	83 c4 10             	add    $0x10,%esp
  801079:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80107c:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  80107f:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  801086:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  80108a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80108d:	83 ec 04             	sub    $0x4,%esp
  801090:	52                   	push   %edx
  801091:	ff 75 e4             	pushl  -0x1c(%ebp)
  801094:	50                   	push   %eax
  801095:	ff 75 f4             	pushl  -0xc(%ebp)
  801098:	ff 75 f0             	pushl  -0x10(%ebp)
  80109b:	ff 75 0c             	pushl  0xc(%ebp)
  80109e:	ff 75 08             	pushl  0x8(%ebp)
  8010a1:	e8 00 fb ff ff       	call   800ba6 <printnum>
  8010a6:	83 c4 20             	add    $0x20,%esp
			break;
  8010a9:	eb 46                	jmp    8010f1 <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  8010ab:	83 ec 08             	sub    $0x8,%esp
  8010ae:	ff 75 0c             	pushl  0xc(%ebp)
  8010b1:	53                   	push   %ebx
  8010b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8010b5:	ff d0                	call   *%eax
  8010b7:	83 c4 10             	add    $0x10,%esp
			break;
  8010ba:	eb 35                	jmp    8010f1 <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  8010bc:	c6 05 44 40 80 00 00 	movb   $0x0,0x804044
			break;
  8010c3:	eb 2c                	jmp    8010f1 <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  8010c5:	c6 05 44 40 80 00 01 	movb   $0x1,0x804044
			break;
  8010cc:	eb 23                	jmp    8010f1 <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  8010ce:	83 ec 08             	sub    $0x8,%esp
  8010d1:	ff 75 0c             	pushl  0xc(%ebp)
  8010d4:	6a 25                	push   $0x25
  8010d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8010d9:	ff d0                	call   *%eax
  8010db:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  8010de:	ff 4d 10             	decl   0x10(%ebp)
  8010e1:	eb 03                	jmp    8010e6 <vprintfmt+0x3c3>
  8010e3:	ff 4d 10             	decl   0x10(%ebp)
  8010e6:	8b 45 10             	mov    0x10(%ebp),%eax
  8010e9:	48                   	dec    %eax
  8010ea:	8a 00                	mov    (%eax),%al
  8010ec:	3c 25                	cmp    $0x25,%al
  8010ee:	75 f3                	jne    8010e3 <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  8010f0:	90                   	nop
		}
	}
  8010f1:	e9 35 fc ff ff       	jmp    800d2b <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  8010f6:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  8010f7:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8010fa:	5b                   	pop    %ebx
  8010fb:	5e                   	pop    %esi
  8010fc:	5d                   	pop    %ebp
  8010fd:	c3                   	ret    

008010fe <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  8010fe:	55                   	push   %ebp
  8010ff:	89 e5                	mov    %esp,%ebp
  801101:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  801104:	8d 45 10             	lea    0x10(%ebp),%eax
  801107:	83 c0 04             	add    $0x4,%eax
  80110a:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  80110d:	8b 45 10             	mov    0x10(%ebp),%eax
  801110:	ff 75 f4             	pushl  -0xc(%ebp)
  801113:	50                   	push   %eax
  801114:	ff 75 0c             	pushl  0xc(%ebp)
  801117:	ff 75 08             	pushl  0x8(%ebp)
  80111a:	e8 04 fc ff ff       	call   800d23 <vprintfmt>
  80111f:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  801122:	90                   	nop
  801123:	c9                   	leave  
  801124:	c3                   	ret    

00801125 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  801125:	55                   	push   %ebp
  801126:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  801128:	8b 45 0c             	mov    0xc(%ebp),%eax
  80112b:	8b 40 08             	mov    0x8(%eax),%eax
  80112e:	8d 50 01             	lea    0x1(%eax),%edx
  801131:	8b 45 0c             	mov    0xc(%ebp),%eax
  801134:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  801137:	8b 45 0c             	mov    0xc(%ebp),%eax
  80113a:	8b 10                	mov    (%eax),%edx
  80113c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80113f:	8b 40 04             	mov    0x4(%eax),%eax
  801142:	39 c2                	cmp    %eax,%edx
  801144:	73 12                	jae    801158 <sprintputch+0x33>
		*b->buf++ = ch;
  801146:	8b 45 0c             	mov    0xc(%ebp),%eax
  801149:	8b 00                	mov    (%eax),%eax
  80114b:	8d 48 01             	lea    0x1(%eax),%ecx
  80114e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801151:	89 0a                	mov    %ecx,(%edx)
  801153:	8b 55 08             	mov    0x8(%ebp),%edx
  801156:	88 10                	mov    %dl,(%eax)
}
  801158:	90                   	nop
  801159:	5d                   	pop    %ebp
  80115a:	c3                   	ret    

0080115b <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  80115b:	55                   	push   %ebp
  80115c:	89 e5                	mov    %esp,%ebp
  80115e:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  801161:	8b 45 08             	mov    0x8(%ebp),%eax
  801164:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801167:	8b 45 0c             	mov    0xc(%ebp),%eax
  80116a:	8d 50 ff             	lea    -0x1(%eax),%edx
  80116d:	8b 45 08             	mov    0x8(%ebp),%eax
  801170:	01 d0                	add    %edx,%eax
  801172:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801175:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  80117c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801180:	74 06                	je     801188 <vsnprintf+0x2d>
  801182:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801186:	7f 07                	jg     80118f <vsnprintf+0x34>
		return -E_INVAL;
  801188:	b8 03 00 00 00       	mov    $0x3,%eax
  80118d:	eb 20                	jmp    8011af <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  80118f:	ff 75 14             	pushl  0x14(%ebp)
  801192:	ff 75 10             	pushl  0x10(%ebp)
  801195:	8d 45 ec             	lea    -0x14(%ebp),%eax
  801198:	50                   	push   %eax
  801199:	68 25 11 80 00       	push   $0x801125
  80119e:	e8 80 fb ff ff       	call   800d23 <vprintfmt>
  8011a3:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  8011a6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8011a9:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8011ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  8011af:	c9                   	leave  
  8011b0:	c3                   	ret    

008011b1 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8011b1:	55                   	push   %ebp
  8011b2:	89 e5                	mov    %esp,%ebp
  8011b4:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8011b7:	8d 45 10             	lea    0x10(%ebp),%eax
  8011ba:	83 c0 04             	add    $0x4,%eax
  8011bd:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  8011c0:	8b 45 10             	mov    0x10(%ebp),%eax
  8011c3:	ff 75 f4             	pushl  -0xc(%ebp)
  8011c6:	50                   	push   %eax
  8011c7:	ff 75 0c             	pushl  0xc(%ebp)
  8011ca:	ff 75 08             	pushl  0x8(%ebp)
  8011cd:	e8 89 ff ff ff       	call   80115b <vsnprintf>
  8011d2:	83 c4 10             	add    $0x10,%esp
  8011d5:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  8011d8:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8011db:	c9                   	leave  
  8011dc:	c3                   	ret    

008011dd <readline>:
#include <inc/lib.h>

//static char buf[BUFLEN];

void readline(const char *prompt, char* buf)
{
  8011dd:	55                   	push   %ebp
  8011de:	89 e5                	mov    %esp,%ebp
  8011e0:	83 ec 18             	sub    $0x18,%esp
	int i, c, echoing;

	if (prompt != NULL)
  8011e3:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8011e7:	74 13                	je     8011fc <readline+0x1f>
		cprintf("%s", prompt);
  8011e9:	83 ec 08             	sub    $0x8,%esp
  8011ec:	ff 75 08             	pushl  0x8(%ebp)
  8011ef:	68 c8 38 80 00       	push   $0x8038c8
  8011f4:	e8 0b f9 ff ff       	call   800b04 <cprintf>
  8011f9:	83 c4 10             	add    $0x10,%esp

	i = 0;
  8011fc:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	echoing = iscons(0);
  801203:	83 ec 0c             	sub    $0xc,%esp
  801206:	6a 00                	push   $0x0
  801208:	e8 5a f4 ff ff       	call   800667 <iscons>
  80120d:	83 c4 10             	add    $0x10,%esp
  801210:	89 45 f0             	mov    %eax,-0x10(%ebp)
	while (1) {
		c = getchar();
  801213:	e8 3c f4 ff ff       	call   800654 <getchar>
  801218:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if (c < 0) {
  80121b:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80121f:	79 22                	jns    801243 <readline+0x66>
			if (c != -E_EOF)
  801221:	83 7d ec 07          	cmpl   $0x7,-0x14(%ebp)
  801225:	0f 84 ad 00 00 00    	je     8012d8 <readline+0xfb>
				cprintf("read error: %e\n", c);
  80122b:	83 ec 08             	sub    $0x8,%esp
  80122e:	ff 75 ec             	pushl  -0x14(%ebp)
  801231:	68 cb 38 80 00       	push   $0x8038cb
  801236:	e8 c9 f8 ff ff       	call   800b04 <cprintf>
  80123b:	83 c4 10             	add    $0x10,%esp
			break;
  80123e:	e9 95 00 00 00       	jmp    8012d8 <readline+0xfb>
		} else if (c >= ' ' && i < BUFLEN-1) {
  801243:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%ebp)
  801247:	7e 34                	jle    80127d <readline+0xa0>
  801249:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  801250:	7f 2b                	jg     80127d <readline+0xa0>
			if (echoing)
  801252:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801256:	74 0e                	je     801266 <readline+0x89>
				cputchar(c);
  801258:	83 ec 0c             	sub    $0xc,%esp
  80125b:	ff 75 ec             	pushl  -0x14(%ebp)
  80125e:	e8 d2 f3 ff ff       	call   800635 <cputchar>
  801263:	83 c4 10             	add    $0x10,%esp
			buf[i++] = c;
  801266:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801269:	8d 50 01             	lea    0x1(%eax),%edx
  80126c:	89 55 f4             	mov    %edx,-0xc(%ebp)
  80126f:	89 c2                	mov    %eax,%edx
  801271:	8b 45 0c             	mov    0xc(%ebp),%eax
  801274:	01 d0                	add    %edx,%eax
  801276:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801279:	88 10                	mov    %dl,(%eax)
  80127b:	eb 56                	jmp    8012d3 <readline+0xf6>
		} else if (c == '\b' && i > 0) {
  80127d:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  801281:	75 1f                	jne    8012a2 <readline+0xc5>
  801283:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801287:	7e 19                	jle    8012a2 <readline+0xc5>
			if (echoing)
  801289:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80128d:	74 0e                	je     80129d <readline+0xc0>
				cputchar(c);
  80128f:	83 ec 0c             	sub    $0xc,%esp
  801292:	ff 75 ec             	pushl  -0x14(%ebp)
  801295:	e8 9b f3 ff ff       	call   800635 <cputchar>
  80129a:	83 c4 10             	add    $0x10,%esp

			i--;
  80129d:	ff 4d f4             	decl   -0xc(%ebp)
  8012a0:	eb 31                	jmp    8012d3 <readline+0xf6>
		} else if (c == '\n' || c == '\r') {
  8012a2:	83 7d ec 0a          	cmpl   $0xa,-0x14(%ebp)
  8012a6:	74 0a                	je     8012b2 <readline+0xd5>
  8012a8:	83 7d ec 0d          	cmpl   $0xd,-0x14(%ebp)
  8012ac:	0f 85 61 ff ff ff    	jne    801213 <readline+0x36>
			if (echoing)
  8012b2:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8012b6:	74 0e                	je     8012c6 <readline+0xe9>
				cputchar(c);
  8012b8:	83 ec 0c             	sub    $0xc,%esp
  8012bb:	ff 75 ec             	pushl  -0x14(%ebp)
  8012be:	e8 72 f3 ff ff       	call   800635 <cputchar>
  8012c3:	83 c4 10             	add    $0x10,%esp

			buf[i] = 0;
  8012c6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8012c9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012cc:	01 d0                	add    %edx,%eax
  8012ce:	c6 00 00             	movb   $0x0,(%eax)
			break;
  8012d1:	eb 06                	jmp    8012d9 <readline+0xfc>
		}
	}
  8012d3:	e9 3b ff ff ff       	jmp    801213 <readline+0x36>
	while (1) {
		c = getchar();
		if (c < 0) {
			if (c != -E_EOF)
				cprintf("read error: %e\n", c);
			break;
  8012d8:	90                   	nop

			buf[i] = 0;
			break;
		}
	}
}
  8012d9:	90                   	nop
  8012da:	c9                   	leave  
  8012db:	c3                   	ret    

008012dc <atomic_readline>:

void atomic_readline(const char *prompt, char* buf)
{
  8012dc:	55                   	push   %ebp
  8012dd:	89 e5                	mov    %esp,%ebp
  8012df:	83 ec 18             	sub    $0x18,%esp
	sys_lock_cons();
  8012e2:	e8 30 0b 00 00       	call   801e17 <sys_lock_cons>
	{
		int i, c, echoing;

		if (prompt != NULL)
  8012e7:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8012eb:	74 13                	je     801300 <atomic_readline+0x24>
			cprintf("%s", prompt);
  8012ed:	83 ec 08             	sub    $0x8,%esp
  8012f0:	ff 75 08             	pushl  0x8(%ebp)
  8012f3:	68 c8 38 80 00       	push   $0x8038c8
  8012f8:	e8 07 f8 ff ff       	call   800b04 <cprintf>
  8012fd:	83 c4 10             	add    $0x10,%esp

		i = 0;
  801300:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
		echoing = iscons(0);
  801307:	83 ec 0c             	sub    $0xc,%esp
  80130a:	6a 00                	push   $0x0
  80130c:	e8 56 f3 ff ff       	call   800667 <iscons>
  801311:	83 c4 10             	add    $0x10,%esp
  801314:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (1) {
			c = getchar();
  801317:	e8 38 f3 ff ff       	call   800654 <getchar>
  80131c:	89 45 ec             	mov    %eax,-0x14(%ebp)
			if (c < 0) {
  80131f:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801323:	79 22                	jns    801347 <atomic_readline+0x6b>
				if (c != -E_EOF)
  801325:	83 7d ec 07          	cmpl   $0x7,-0x14(%ebp)
  801329:	0f 84 ad 00 00 00    	je     8013dc <atomic_readline+0x100>
					cprintf("read error: %e\n", c);
  80132f:	83 ec 08             	sub    $0x8,%esp
  801332:	ff 75 ec             	pushl  -0x14(%ebp)
  801335:	68 cb 38 80 00       	push   $0x8038cb
  80133a:	e8 c5 f7 ff ff       	call   800b04 <cprintf>
  80133f:	83 c4 10             	add    $0x10,%esp
				break;
  801342:	e9 95 00 00 00       	jmp    8013dc <atomic_readline+0x100>
			} else if (c >= ' ' && i < BUFLEN-1) {
  801347:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%ebp)
  80134b:	7e 34                	jle    801381 <atomic_readline+0xa5>
  80134d:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  801354:	7f 2b                	jg     801381 <atomic_readline+0xa5>
				if (echoing)
  801356:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80135a:	74 0e                	je     80136a <atomic_readline+0x8e>
					cputchar(c);
  80135c:	83 ec 0c             	sub    $0xc,%esp
  80135f:	ff 75 ec             	pushl  -0x14(%ebp)
  801362:	e8 ce f2 ff ff       	call   800635 <cputchar>
  801367:	83 c4 10             	add    $0x10,%esp
				buf[i++] = c;
  80136a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80136d:	8d 50 01             	lea    0x1(%eax),%edx
  801370:	89 55 f4             	mov    %edx,-0xc(%ebp)
  801373:	89 c2                	mov    %eax,%edx
  801375:	8b 45 0c             	mov    0xc(%ebp),%eax
  801378:	01 d0                	add    %edx,%eax
  80137a:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80137d:	88 10                	mov    %dl,(%eax)
  80137f:	eb 56                	jmp    8013d7 <atomic_readline+0xfb>
			} else if (c == '\b' && i > 0) {
  801381:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  801385:	75 1f                	jne    8013a6 <atomic_readline+0xca>
  801387:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80138b:	7e 19                	jle    8013a6 <atomic_readline+0xca>
				if (echoing)
  80138d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801391:	74 0e                	je     8013a1 <atomic_readline+0xc5>
					cputchar(c);
  801393:	83 ec 0c             	sub    $0xc,%esp
  801396:	ff 75 ec             	pushl  -0x14(%ebp)
  801399:	e8 97 f2 ff ff       	call   800635 <cputchar>
  80139e:	83 c4 10             	add    $0x10,%esp
				i--;
  8013a1:	ff 4d f4             	decl   -0xc(%ebp)
  8013a4:	eb 31                	jmp    8013d7 <atomic_readline+0xfb>
			} else if (c == '\n' || c == '\r') {
  8013a6:	83 7d ec 0a          	cmpl   $0xa,-0x14(%ebp)
  8013aa:	74 0a                	je     8013b6 <atomic_readline+0xda>
  8013ac:	83 7d ec 0d          	cmpl   $0xd,-0x14(%ebp)
  8013b0:	0f 85 61 ff ff ff    	jne    801317 <atomic_readline+0x3b>
				if (echoing)
  8013b6:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8013ba:	74 0e                	je     8013ca <atomic_readline+0xee>
					cputchar(c);
  8013bc:	83 ec 0c             	sub    $0xc,%esp
  8013bf:	ff 75 ec             	pushl  -0x14(%ebp)
  8013c2:	e8 6e f2 ff ff       	call   800635 <cputchar>
  8013c7:	83 c4 10             	add    $0x10,%esp
				buf[i] = 0;
  8013ca:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8013cd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013d0:	01 d0                	add    %edx,%eax
  8013d2:	c6 00 00             	movb   $0x0,(%eax)
				break;
  8013d5:	eb 06                	jmp    8013dd <atomic_readline+0x101>
			}
		}
  8013d7:	e9 3b ff ff ff       	jmp    801317 <atomic_readline+0x3b>
		while (1) {
			c = getchar();
			if (c < 0) {
				if (c != -E_EOF)
					cprintf("read error: %e\n", c);
				break;
  8013dc:	90                   	nop
				buf[i] = 0;
				break;
			}
		}
	}
	sys_unlock_cons();
  8013dd:	e8 4f 0a 00 00       	call   801e31 <sys_unlock_cons>
}
  8013e2:	90                   	nop
  8013e3:	c9                   	leave  
  8013e4:	c3                   	ret    

008013e5 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  8013e5:	55                   	push   %ebp
  8013e6:	89 e5                	mov    %esp,%ebp
  8013e8:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  8013eb:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8013f2:	eb 06                	jmp    8013fa <strlen+0x15>
		n++;
  8013f4:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  8013f7:	ff 45 08             	incl   0x8(%ebp)
  8013fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8013fd:	8a 00                	mov    (%eax),%al
  8013ff:	84 c0                	test   %al,%al
  801401:	75 f1                	jne    8013f4 <strlen+0xf>
		n++;
	return n;
  801403:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801406:	c9                   	leave  
  801407:	c3                   	ret    

00801408 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  801408:	55                   	push   %ebp
  801409:	89 e5                	mov    %esp,%ebp
  80140b:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80140e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801415:	eb 09                	jmp    801420 <strnlen+0x18>
		n++;
  801417:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80141a:	ff 45 08             	incl   0x8(%ebp)
  80141d:	ff 4d 0c             	decl   0xc(%ebp)
  801420:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801424:	74 09                	je     80142f <strnlen+0x27>
  801426:	8b 45 08             	mov    0x8(%ebp),%eax
  801429:	8a 00                	mov    (%eax),%al
  80142b:	84 c0                	test   %al,%al
  80142d:	75 e8                	jne    801417 <strnlen+0xf>
		n++;
	return n;
  80142f:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801432:	c9                   	leave  
  801433:	c3                   	ret    

00801434 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  801434:	55                   	push   %ebp
  801435:	89 e5                	mov    %esp,%ebp
  801437:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  80143a:	8b 45 08             	mov    0x8(%ebp),%eax
  80143d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  801440:	90                   	nop
  801441:	8b 45 08             	mov    0x8(%ebp),%eax
  801444:	8d 50 01             	lea    0x1(%eax),%edx
  801447:	89 55 08             	mov    %edx,0x8(%ebp)
  80144a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80144d:	8d 4a 01             	lea    0x1(%edx),%ecx
  801450:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  801453:	8a 12                	mov    (%edx),%dl
  801455:	88 10                	mov    %dl,(%eax)
  801457:	8a 00                	mov    (%eax),%al
  801459:	84 c0                	test   %al,%al
  80145b:	75 e4                	jne    801441 <strcpy+0xd>
		/* do nothing */;
	return ret;
  80145d:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801460:	c9                   	leave  
  801461:	c3                   	ret    

00801462 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  801462:	55                   	push   %ebp
  801463:	89 e5                	mov    %esp,%ebp
  801465:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  801468:	8b 45 08             	mov    0x8(%ebp),%eax
  80146b:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  80146e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801475:	eb 1f                	jmp    801496 <strncpy+0x34>
		*dst++ = *src;
  801477:	8b 45 08             	mov    0x8(%ebp),%eax
  80147a:	8d 50 01             	lea    0x1(%eax),%edx
  80147d:	89 55 08             	mov    %edx,0x8(%ebp)
  801480:	8b 55 0c             	mov    0xc(%ebp),%edx
  801483:	8a 12                	mov    (%edx),%dl
  801485:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  801487:	8b 45 0c             	mov    0xc(%ebp),%eax
  80148a:	8a 00                	mov    (%eax),%al
  80148c:	84 c0                	test   %al,%al
  80148e:	74 03                	je     801493 <strncpy+0x31>
			src++;
  801490:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  801493:	ff 45 fc             	incl   -0x4(%ebp)
  801496:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801499:	3b 45 10             	cmp    0x10(%ebp),%eax
  80149c:	72 d9                	jb     801477 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  80149e:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8014a1:	c9                   	leave  
  8014a2:	c3                   	ret    

008014a3 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  8014a3:	55                   	push   %ebp
  8014a4:	89 e5                	mov    %esp,%ebp
  8014a6:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  8014a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8014ac:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  8014af:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8014b3:	74 30                	je     8014e5 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  8014b5:	eb 16                	jmp    8014cd <strlcpy+0x2a>
			*dst++ = *src++;
  8014b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8014ba:	8d 50 01             	lea    0x1(%eax),%edx
  8014bd:	89 55 08             	mov    %edx,0x8(%ebp)
  8014c0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8014c3:	8d 4a 01             	lea    0x1(%edx),%ecx
  8014c6:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  8014c9:	8a 12                	mov    (%edx),%dl
  8014cb:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  8014cd:	ff 4d 10             	decl   0x10(%ebp)
  8014d0:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8014d4:	74 09                	je     8014df <strlcpy+0x3c>
  8014d6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014d9:	8a 00                	mov    (%eax),%al
  8014db:	84 c0                	test   %al,%al
  8014dd:	75 d8                	jne    8014b7 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  8014df:	8b 45 08             	mov    0x8(%ebp),%eax
  8014e2:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  8014e5:	8b 55 08             	mov    0x8(%ebp),%edx
  8014e8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8014eb:	29 c2                	sub    %eax,%edx
  8014ed:	89 d0                	mov    %edx,%eax
}
  8014ef:	c9                   	leave  
  8014f0:	c3                   	ret    

008014f1 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8014f1:	55                   	push   %ebp
  8014f2:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  8014f4:	eb 06                	jmp    8014fc <strcmp+0xb>
		p++, q++;
  8014f6:	ff 45 08             	incl   0x8(%ebp)
  8014f9:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  8014fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8014ff:	8a 00                	mov    (%eax),%al
  801501:	84 c0                	test   %al,%al
  801503:	74 0e                	je     801513 <strcmp+0x22>
  801505:	8b 45 08             	mov    0x8(%ebp),%eax
  801508:	8a 10                	mov    (%eax),%dl
  80150a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80150d:	8a 00                	mov    (%eax),%al
  80150f:	38 c2                	cmp    %al,%dl
  801511:	74 e3                	je     8014f6 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  801513:	8b 45 08             	mov    0x8(%ebp),%eax
  801516:	8a 00                	mov    (%eax),%al
  801518:	0f b6 d0             	movzbl %al,%edx
  80151b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80151e:	8a 00                	mov    (%eax),%al
  801520:	0f b6 c0             	movzbl %al,%eax
  801523:	29 c2                	sub    %eax,%edx
  801525:	89 d0                	mov    %edx,%eax
}
  801527:	5d                   	pop    %ebp
  801528:	c3                   	ret    

00801529 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  801529:	55                   	push   %ebp
  80152a:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  80152c:	eb 09                	jmp    801537 <strncmp+0xe>
		n--, p++, q++;
  80152e:	ff 4d 10             	decl   0x10(%ebp)
  801531:	ff 45 08             	incl   0x8(%ebp)
  801534:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  801537:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80153b:	74 17                	je     801554 <strncmp+0x2b>
  80153d:	8b 45 08             	mov    0x8(%ebp),%eax
  801540:	8a 00                	mov    (%eax),%al
  801542:	84 c0                	test   %al,%al
  801544:	74 0e                	je     801554 <strncmp+0x2b>
  801546:	8b 45 08             	mov    0x8(%ebp),%eax
  801549:	8a 10                	mov    (%eax),%dl
  80154b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80154e:	8a 00                	mov    (%eax),%al
  801550:	38 c2                	cmp    %al,%dl
  801552:	74 da                	je     80152e <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  801554:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801558:	75 07                	jne    801561 <strncmp+0x38>
		return 0;
  80155a:	b8 00 00 00 00       	mov    $0x0,%eax
  80155f:	eb 14                	jmp    801575 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  801561:	8b 45 08             	mov    0x8(%ebp),%eax
  801564:	8a 00                	mov    (%eax),%al
  801566:	0f b6 d0             	movzbl %al,%edx
  801569:	8b 45 0c             	mov    0xc(%ebp),%eax
  80156c:	8a 00                	mov    (%eax),%al
  80156e:	0f b6 c0             	movzbl %al,%eax
  801571:	29 c2                	sub    %eax,%edx
  801573:	89 d0                	mov    %edx,%eax
}
  801575:	5d                   	pop    %ebp
  801576:	c3                   	ret    

00801577 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  801577:	55                   	push   %ebp
  801578:	89 e5                	mov    %esp,%ebp
  80157a:	83 ec 04             	sub    $0x4,%esp
  80157d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801580:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  801583:	eb 12                	jmp    801597 <strchr+0x20>
		if (*s == c)
  801585:	8b 45 08             	mov    0x8(%ebp),%eax
  801588:	8a 00                	mov    (%eax),%al
  80158a:	3a 45 fc             	cmp    -0x4(%ebp),%al
  80158d:	75 05                	jne    801594 <strchr+0x1d>
			return (char *) s;
  80158f:	8b 45 08             	mov    0x8(%ebp),%eax
  801592:	eb 11                	jmp    8015a5 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  801594:	ff 45 08             	incl   0x8(%ebp)
  801597:	8b 45 08             	mov    0x8(%ebp),%eax
  80159a:	8a 00                	mov    (%eax),%al
  80159c:	84 c0                	test   %al,%al
  80159e:	75 e5                	jne    801585 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  8015a0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8015a5:	c9                   	leave  
  8015a6:	c3                   	ret    

008015a7 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8015a7:	55                   	push   %ebp
  8015a8:	89 e5                	mov    %esp,%ebp
  8015aa:	83 ec 04             	sub    $0x4,%esp
  8015ad:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015b0:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  8015b3:	eb 0d                	jmp    8015c2 <strfind+0x1b>
		if (*s == c)
  8015b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8015b8:	8a 00                	mov    (%eax),%al
  8015ba:	3a 45 fc             	cmp    -0x4(%ebp),%al
  8015bd:	74 0e                	je     8015cd <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  8015bf:	ff 45 08             	incl   0x8(%ebp)
  8015c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8015c5:	8a 00                	mov    (%eax),%al
  8015c7:	84 c0                	test   %al,%al
  8015c9:	75 ea                	jne    8015b5 <strfind+0xe>
  8015cb:	eb 01                	jmp    8015ce <strfind+0x27>
		if (*s == c)
			break;
  8015cd:	90                   	nop
	return (char *) s;
  8015ce:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8015d1:	c9                   	leave  
  8015d2:	c3                   	ret    

008015d3 <memset>:

// *************** The faster implementation of memset & memcpy is implemented by *************
// ****************** Team80 (Yahia Khaled, Malek Ahmed et al) - FCIS'24-25 *******************
void *
memset(void *v, int c, uint32 n)
{
  8015d3:	55                   	push   %ebp
  8015d4:	89 e5                	mov    %esp,%ebp
  8015d6:	83 ec 10             	sub    $0x10,%esp
//	m = n;
//	while (--m >= 0)
//		*p++ = c;

	/*Faster Implementation*/
	uint64* p64 = (uint64*)v;
  8015d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8015dc:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if(n >= 8){
  8015df:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  8015e3:	76 63                	jbe    801648 <memset+0x75>
		uint64 data_block = c;
  8015e5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015e8:	99                   	cltd   
  8015e9:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8015ec:	89 55 f4             	mov    %edx,-0xc(%ebp)
		data_block |= data_block << 8;
  8015ef:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015f2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8015f5:	0f a4 c2 08          	shld   $0x8,%eax,%edx
  8015f9:	c1 e0 08             	shl    $0x8,%eax
  8015fc:	09 45 f0             	or     %eax,-0x10(%ebp)
  8015ff:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 16;
  801602:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801605:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801608:	0f a4 c2 10          	shld   $0x10,%eax,%edx
  80160c:	c1 e0 10             	shl    $0x10,%eax
  80160f:	09 45 f0             	or     %eax,-0x10(%ebp)
  801612:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 32;
  801615:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801618:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80161b:	89 c2                	mov    %eax,%edx
  80161d:	b8 00 00 00 00       	mov    $0x0,%eax
  801622:	09 45 f0             	or     %eax,-0x10(%ebp)
  801625:	09 55 f4             	or     %edx,-0xc(%ebp)

		while(n >= 8)
  801628:	eb 18                	jmp    801642 <memset+0x6f>
			*p64++ = data_block, n -= 8;
  80162a:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  80162d:	8d 41 08             	lea    0x8(%ecx),%eax
  801630:	89 45 fc             	mov    %eax,-0x4(%ebp)
  801633:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801636:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801639:	89 01                	mov    %eax,(%ecx)
  80163b:	89 51 04             	mov    %edx,0x4(%ecx)
  80163e:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
		uint64 data_block = c;
		data_block |= data_block << 8;
		data_block |= data_block << 16;
		data_block |= data_block << 32;

		while(n >= 8)
  801642:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  801646:	77 e2                	ja     80162a <memset+0x57>
			*p64++ = data_block, n -= 8;
	}

	if(n){
  801648:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80164c:	74 23                	je     801671 <memset+0x9e>
		uint8* p8 = (uint8*)p64;
  80164e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801651:	89 45 f8             	mov    %eax,-0x8(%ebp)
		while (n-- > 0)
  801654:	eb 0e                	jmp    801664 <memset+0x91>
			*p8++ = (uint8)c;
  801656:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801659:	8d 50 01             	lea    0x1(%eax),%edx
  80165c:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80165f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801662:	88 10                	mov    %dl,(%eax)
			*p64++ = data_block, n -= 8;
	}

	if(n){
		uint8* p8 = (uint8*)p64;
		while (n-- > 0)
  801664:	8b 45 10             	mov    0x10(%ebp),%eax
  801667:	8d 50 ff             	lea    -0x1(%eax),%edx
  80166a:	89 55 10             	mov    %edx,0x10(%ebp)
  80166d:	85 c0                	test   %eax,%eax
  80166f:	75 e5                	jne    801656 <memset+0x83>
			*p8++ = (uint8)c;
	}

	return v;
  801671:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801674:	c9                   	leave  
  801675:	c3                   	ret    

00801676 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  801676:	55                   	push   %ebp
  801677:	89 e5                	mov    %esp,%ebp
  801679:	83 ec 10             	sub    $0x10,%esp
	//	s = src;
	//	d = dst;
	//	while (n-- > 0)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
  80167c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80167f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	uint64* d64 = (uint64*)dst;
  801682:	8b 45 08             	mov    0x8(%ebp),%eax
  801685:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if(n >= 8){
  801688:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  80168c:	76 24                	jbe    8016b2 <memcpy+0x3c>
		while(n >= 8){
  80168e:	eb 1c                	jmp    8016ac <memcpy+0x36>
			*d64 = *s64;
  801690:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801693:	8b 50 04             	mov    0x4(%eax),%edx
  801696:	8b 00                	mov    (%eax),%eax
  801698:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  80169b:	89 01                	mov    %eax,(%ecx)
  80169d:	89 51 04             	mov    %edx,0x4(%ecx)
			n -= 8;
  8016a0:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
			++s64;
  8016a4:	83 45 fc 08          	addl   $0x8,-0x4(%ebp)
			++d64;
  8016a8:	83 45 f8 08          	addl   $0x8,-0x8(%ebp)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
	uint64* d64 = (uint64*)dst;
	if(n >= 8){
		while(n >= 8){
  8016ac:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  8016b0:	77 de                	ja     801690 <memcpy+0x1a>
			++s64;
			++d64;
		}
	}

	if(n){
  8016b2:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8016b6:	74 31                	je     8016e9 <memcpy+0x73>
		uint8* s8 = (uint8*)s64;
  8016b8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8016bb:	89 45 f4             	mov    %eax,-0xc(%ebp)
		uint8* d8 = (uint8*)d64;
  8016be:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8016c1:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (n-- > 0)
  8016c4:	eb 16                	jmp    8016dc <memcpy+0x66>
			*d8++ = *s8++;
  8016c6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016c9:	8d 50 01             	lea    0x1(%eax),%edx
  8016cc:	89 55 f0             	mov    %edx,-0x10(%ebp)
  8016cf:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8016d2:	8d 4a 01             	lea    0x1(%edx),%ecx
  8016d5:	89 4d f4             	mov    %ecx,-0xc(%ebp)
  8016d8:	8a 12                	mov    (%edx),%dl
  8016da:	88 10                	mov    %dl,(%eax)
	}

	if(n){
		uint8* s8 = (uint8*)s64;
		uint8* d8 = (uint8*)d64;
		while (n-- > 0)
  8016dc:	8b 45 10             	mov    0x10(%ebp),%eax
  8016df:	8d 50 ff             	lea    -0x1(%eax),%edx
  8016e2:	89 55 10             	mov    %edx,0x10(%ebp)
  8016e5:	85 c0                	test   %eax,%eax
  8016e7:	75 dd                	jne    8016c6 <memcpy+0x50>
			*d8++ = *s8++;
	}
	return dst;
  8016e9:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8016ec:	c9                   	leave  
  8016ed:	c3                   	ret    

008016ee <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  8016ee:	55                   	push   %ebp
  8016ef:	89 e5                	mov    %esp,%ebp
  8016f1:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  8016f4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016f7:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  8016fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8016fd:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  801700:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801703:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801706:	73 50                	jae    801758 <memmove+0x6a>
  801708:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80170b:	8b 45 10             	mov    0x10(%ebp),%eax
  80170e:	01 d0                	add    %edx,%eax
  801710:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801713:	76 43                	jbe    801758 <memmove+0x6a>
		s += n;
  801715:	8b 45 10             	mov    0x10(%ebp),%eax
  801718:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  80171b:	8b 45 10             	mov    0x10(%ebp),%eax
  80171e:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  801721:	eb 10                	jmp    801733 <memmove+0x45>
			*--d = *--s;
  801723:	ff 4d f8             	decl   -0x8(%ebp)
  801726:	ff 4d fc             	decl   -0x4(%ebp)
  801729:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80172c:	8a 10                	mov    (%eax),%dl
  80172e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801731:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  801733:	8b 45 10             	mov    0x10(%ebp),%eax
  801736:	8d 50 ff             	lea    -0x1(%eax),%edx
  801739:	89 55 10             	mov    %edx,0x10(%ebp)
  80173c:	85 c0                	test   %eax,%eax
  80173e:	75 e3                	jne    801723 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  801740:	eb 23                	jmp    801765 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  801742:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801745:	8d 50 01             	lea    0x1(%eax),%edx
  801748:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80174b:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80174e:	8d 4a 01             	lea    0x1(%edx),%ecx
  801751:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801754:	8a 12                	mov    (%edx),%dl
  801756:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  801758:	8b 45 10             	mov    0x10(%ebp),%eax
  80175b:	8d 50 ff             	lea    -0x1(%eax),%edx
  80175e:	89 55 10             	mov    %edx,0x10(%ebp)
  801761:	85 c0                	test   %eax,%eax
  801763:	75 dd                	jne    801742 <memmove+0x54>
			*d++ = *s++;

	return dst;
  801765:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801768:	c9                   	leave  
  801769:	c3                   	ret    

0080176a <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  80176a:	55                   	push   %ebp
  80176b:	89 e5                	mov    %esp,%ebp
  80176d:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  801770:	8b 45 08             	mov    0x8(%ebp),%eax
  801773:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  801776:	8b 45 0c             	mov    0xc(%ebp),%eax
  801779:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  80177c:	eb 2a                	jmp    8017a8 <memcmp+0x3e>
		if (*s1 != *s2)
  80177e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801781:	8a 10                	mov    (%eax),%dl
  801783:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801786:	8a 00                	mov    (%eax),%al
  801788:	38 c2                	cmp    %al,%dl
  80178a:	74 16                	je     8017a2 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  80178c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80178f:	8a 00                	mov    (%eax),%al
  801791:	0f b6 d0             	movzbl %al,%edx
  801794:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801797:	8a 00                	mov    (%eax),%al
  801799:	0f b6 c0             	movzbl %al,%eax
  80179c:	29 c2                	sub    %eax,%edx
  80179e:	89 d0                	mov    %edx,%eax
  8017a0:	eb 18                	jmp    8017ba <memcmp+0x50>
		s1++, s2++;
  8017a2:	ff 45 fc             	incl   -0x4(%ebp)
  8017a5:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  8017a8:	8b 45 10             	mov    0x10(%ebp),%eax
  8017ab:	8d 50 ff             	lea    -0x1(%eax),%edx
  8017ae:	89 55 10             	mov    %edx,0x10(%ebp)
  8017b1:	85 c0                	test   %eax,%eax
  8017b3:	75 c9                	jne    80177e <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  8017b5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8017ba:	c9                   	leave  
  8017bb:	c3                   	ret    

008017bc <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  8017bc:	55                   	push   %ebp
  8017bd:	89 e5                	mov    %esp,%ebp
  8017bf:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  8017c2:	8b 55 08             	mov    0x8(%ebp),%edx
  8017c5:	8b 45 10             	mov    0x10(%ebp),%eax
  8017c8:	01 d0                	add    %edx,%eax
  8017ca:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  8017cd:	eb 15                	jmp    8017e4 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  8017cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8017d2:	8a 00                	mov    (%eax),%al
  8017d4:	0f b6 d0             	movzbl %al,%edx
  8017d7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017da:	0f b6 c0             	movzbl %al,%eax
  8017dd:	39 c2                	cmp    %eax,%edx
  8017df:	74 0d                	je     8017ee <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  8017e1:	ff 45 08             	incl   0x8(%ebp)
  8017e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8017e7:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  8017ea:	72 e3                	jb     8017cf <memfind+0x13>
  8017ec:	eb 01                	jmp    8017ef <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  8017ee:	90                   	nop
	return (void *) s;
  8017ef:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8017f2:	c9                   	leave  
  8017f3:	c3                   	ret    

008017f4 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  8017f4:	55                   	push   %ebp
  8017f5:	89 e5                	mov    %esp,%ebp
  8017f7:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  8017fa:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  801801:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801808:	eb 03                	jmp    80180d <strtol+0x19>
		s++;
  80180a:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80180d:	8b 45 08             	mov    0x8(%ebp),%eax
  801810:	8a 00                	mov    (%eax),%al
  801812:	3c 20                	cmp    $0x20,%al
  801814:	74 f4                	je     80180a <strtol+0x16>
  801816:	8b 45 08             	mov    0x8(%ebp),%eax
  801819:	8a 00                	mov    (%eax),%al
  80181b:	3c 09                	cmp    $0x9,%al
  80181d:	74 eb                	je     80180a <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  80181f:	8b 45 08             	mov    0x8(%ebp),%eax
  801822:	8a 00                	mov    (%eax),%al
  801824:	3c 2b                	cmp    $0x2b,%al
  801826:	75 05                	jne    80182d <strtol+0x39>
		s++;
  801828:	ff 45 08             	incl   0x8(%ebp)
  80182b:	eb 13                	jmp    801840 <strtol+0x4c>
	else if (*s == '-')
  80182d:	8b 45 08             	mov    0x8(%ebp),%eax
  801830:	8a 00                	mov    (%eax),%al
  801832:	3c 2d                	cmp    $0x2d,%al
  801834:	75 0a                	jne    801840 <strtol+0x4c>
		s++, neg = 1;
  801836:	ff 45 08             	incl   0x8(%ebp)
  801839:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801840:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801844:	74 06                	je     80184c <strtol+0x58>
  801846:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  80184a:	75 20                	jne    80186c <strtol+0x78>
  80184c:	8b 45 08             	mov    0x8(%ebp),%eax
  80184f:	8a 00                	mov    (%eax),%al
  801851:	3c 30                	cmp    $0x30,%al
  801853:	75 17                	jne    80186c <strtol+0x78>
  801855:	8b 45 08             	mov    0x8(%ebp),%eax
  801858:	40                   	inc    %eax
  801859:	8a 00                	mov    (%eax),%al
  80185b:	3c 78                	cmp    $0x78,%al
  80185d:	75 0d                	jne    80186c <strtol+0x78>
		s += 2, base = 16;
  80185f:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  801863:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  80186a:	eb 28                	jmp    801894 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  80186c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801870:	75 15                	jne    801887 <strtol+0x93>
  801872:	8b 45 08             	mov    0x8(%ebp),%eax
  801875:	8a 00                	mov    (%eax),%al
  801877:	3c 30                	cmp    $0x30,%al
  801879:	75 0c                	jne    801887 <strtol+0x93>
		s++, base = 8;
  80187b:	ff 45 08             	incl   0x8(%ebp)
  80187e:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  801885:	eb 0d                	jmp    801894 <strtol+0xa0>
	else if (base == 0)
  801887:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80188b:	75 07                	jne    801894 <strtol+0xa0>
		base = 10;
  80188d:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801894:	8b 45 08             	mov    0x8(%ebp),%eax
  801897:	8a 00                	mov    (%eax),%al
  801899:	3c 2f                	cmp    $0x2f,%al
  80189b:	7e 19                	jle    8018b6 <strtol+0xc2>
  80189d:	8b 45 08             	mov    0x8(%ebp),%eax
  8018a0:	8a 00                	mov    (%eax),%al
  8018a2:	3c 39                	cmp    $0x39,%al
  8018a4:	7f 10                	jg     8018b6 <strtol+0xc2>
			dig = *s - '0';
  8018a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8018a9:	8a 00                	mov    (%eax),%al
  8018ab:	0f be c0             	movsbl %al,%eax
  8018ae:	83 e8 30             	sub    $0x30,%eax
  8018b1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8018b4:	eb 42                	jmp    8018f8 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  8018b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8018b9:	8a 00                	mov    (%eax),%al
  8018bb:	3c 60                	cmp    $0x60,%al
  8018bd:	7e 19                	jle    8018d8 <strtol+0xe4>
  8018bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8018c2:	8a 00                	mov    (%eax),%al
  8018c4:	3c 7a                	cmp    $0x7a,%al
  8018c6:	7f 10                	jg     8018d8 <strtol+0xe4>
			dig = *s - 'a' + 10;
  8018c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8018cb:	8a 00                	mov    (%eax),%al
  8018cd:	0f be c0             	movsbl %al,%eax
  8018d0:	83 e8 57             	sub    $0x57,%eax
  8018d3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8018d6:	eb 20                	jmp    8018f8 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  8018d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8018db:	8a 00                	mov    (%eax),%al
  8018dd:	3c 40                	cmp    $0x40,%al
  8018df:	7e 39                	jle    80191a <strtol+0x126>
  8018e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8018e4:	8a 00                	mov    (%eax),%al
  8018e6:	3c 5a                	cmp    $0x5a,%al
  8018e8:	7f 30                	jg     80191a <strtol+0x126>
			dig = *s - 'A' + 10;
  8018ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8018ed:	8a 00                	mov    (%eax),%al
  8018ef:	0f be c0             	movsbl %al,%eax
  8018f2:	83 e8 37             	sub    $0x37,%eax
  8018f5:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  8018f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8018fb:	3b 45 10             	cmp    0x10(%ebp),%eax
  8018fe:	7d 19                	jge    801919 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801900:	ff 45 08             	incl   0x8(%ebp)
  801903:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801906:	0f af 45 10          	imul   0x10(%ebp),%eax
  80190a:	89 c2                	mov    %eax,%edx
  80190c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80190f:	01 d0                	add    %edx,%eax
  801911:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  801914:	e9 7b ff ff ff       	jmp    801894 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801919:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  80191a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80191e:	74 08                	je     801928 <strtol+0x134>
		*endptr = (char *) s;
  801920:	8b 45 0c             	mov    0xc(%ebp),%eax
  801923:	8b 55 08             	mov    0x8(%ebp),%edx
  801926:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  801928:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80192c:	74 07                	je     801935 <strtol+0x141>
  80192e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801931:	f7 d8                	neg    %eax
  801933:	eb 03                	jmp    801938 <strtol+0x144>
  801935:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801938:	c9                   	leave  
  801939:	c3                   	ret    

0080193a <ltostr>:

void
ltostr(long value, char *str)
{
  80193a:	55                   	push   %ebp
  80193b:	89 e5                	mov    %esp,%ebp
  80193d:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  801940:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  801947:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  80194e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801952:	79 13                	jns    801967 <ltostr+0x2d>
	{
		neg = 1;
  801954:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  80195b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80195e:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  801961:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  801964:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  801967:	8b 45 08             	mov    0x8(%ebp),%eax
  80196a:	b9 0a 00 00 00       	mov    $0xa,%ecx
  80196f:	99                   	cltd   
  801970:	f7 f9                	idiv   %ecx
  801972:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  801975:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801978:	8d 50 01             	lea    0x1(%eax),%edx
  80197b:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80197e:	89 c2                	mov    %eax,%edx
  801980:	8b 45 0c             	mov    0xc(%ebp),%eax
  801983:	01 d0                	add    %edx,%eax
  801985:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801988:	83 c2 30             	add    $0x30,%edx
  80198b:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  80198d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801990:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801995:	f7 e9                	imul   %ecx
  801997:	c1 fa 02             	sar    $0x2,%edx
  80199a:	89 c8                	mov    %ecx,%eax
  80199c:	c1 f8 1f             	sar    $0x1f,%eax
  80199f:	29 c2                	sub    %eax,%edx
  8019a1:	89 d0                	mov    %edx,%eax
  8019a3:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  8019a6:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8019aa:	75 bb                	jne    801967 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  8019ac:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  8019b3:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8019b6:	48                   	dec    %eax
  8019b7:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  8019ba:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8019be:	74 3d                	je     8019fd <ltostr+0xc3>
		start = 1 ;
  8019c0:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  8019c7:	eb 34                	jmp    8019fd <ltostr+0xc3>
	{
		char tmp = str[start] ;
  8019c9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8019cc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8019cf:	01 d0                	add    %edx,%eax
  8019d1:	8a 00                	mov    (%eax),%al
  8019d3:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  8019d6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8019d9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8019dc:	01 c2                	add    %eax,%edx
  8019de:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  8019e1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8019e4:	01 c8                	add    %ecx,%eax
  8019e6:	8a 00                	mov    (%eax),%al
  8019e8:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  8019ea:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8019ed:	8b 45 0c             	mov    0xc(%ebp),%eax
  8019f0:	01 c2                	add    %eax,%edx
  8019f2:	8a 45 eb             	mov    -0x15(%ebp),%al
  8019f5:	88 02                	mov    %al,(%edx)
		start++ ;
  8019f7:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  8019fa:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  8019fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a00:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801a03:	7c c4                	jl     8019c9 <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801a05:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801a08:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a0b:	01 d0                	add    %edx,%eax
  801a0d:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801a10:	90                   	nop
  801a11:	c9                   	leave  
  801a12:	c3                   	ret    

00801a13 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  801a13:	55                   	push   %ebp
  801a14:	89 e5                	mov    %esp,%ebp
  801a16:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801a19:	ff 75 08             	pushl  0x8(%ebp)
  801a1c:	e8 c4 f9 ff ff       	call   8013e5 <strlen>
  801a21:	83 c4 04             	add    $0x4,%esp
  801a24:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  801a27:	ff 75 0c             	pushl  0xc(%ebp)
  801a2a:	e8 b6 f9 ff ff       	call   8013e5 <strlen>
  801a2f:	83 c4 04             	add    $0x4,%esp
  801a32:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  801a35:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  801a3c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801a43:	eb 17                	jmp    801a5c <strcconcat+0x49>
		final[s] = str1[s] ;
  801a45:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801a48:	8b 45 10             	mov    0x10(%ebp),%eax
  801a4b:	01 c2                	add    %eax,%edx
  801a4d:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801a50:	8b 45 08             	mov    0x8(%ebp),%eax
  801a53:	01 c8                	add    %ecx,%eax
  801a55:	8a 00                	mov    (%eax),%al
  801a57:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  801a59:	ff 45 fc             	incl   -0x4(%ebp)
  801a5c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801a5f:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801a62:	7c e1                	jl     801a45 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  801a64:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  801a6b:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  801a72:	eb 1f                	jmp    801a93 <strcconcat+0x80>
		final[s++] = str2[i] ;
  801a74:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801a77:	8d 50 01             	lea    0x1(%eax),%edx
  801a7a:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801a7d:	89 c2                	mov    %eax,%edx
  801a7f:	8b 45 10             	mov    0x10(%ebp),%eax
  801a82:	01 c2                	add    %eax,%edx
  801a84:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801a87:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a8a:	01 c8                	add    %ecx,%eax
  801a8c:	8a 00                	mov    (%eax),%al
  801a8e:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801a90:	ff 45 f8             	incl   -0x8(%ebp)
  801a93:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801a96:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801a99:	7c d9                	jl     801a74 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801a9b:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801a9e:	8b 45 10             	mov    0x10(%ebp),%eax
  801aa1:	01 d0                	add    %edx,%eax
  801aa3:	c6 00 00             	movb   $0x0,(%eax)
}
  801aa6:	90                   	nop
  801aa7:	c9                   	leave  
  801aa8:	c3                   	ret    

00801aa9 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801aa9:	55                   	push   %ebp
  801aaa:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801aac:	8b 45 14             	mov    0x14(%ebp),%eax
  801aaf:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801ab5:	8b 45 14             	mov    0x14(%ebp),%eax
  801ab8:	8b 00                	mov    (%eax),%eax
  801aba:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801ac1:	8b 45 10             	mov    0x10(%ebp),%eax
  801ac4:	01 d0                	add    %edx,%eax
  801ac6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801acc:	eb 0c                	jmp    801ada <strsplit+0x31>
			*string++ = 0;
  801ace:	8b 45 08             	mov    0x8(%ebp),%eax
  801ad1:	8d 50 01             	lea    0x1(%eax),%edx
  801ad4:	89 55 08             	mov    %edx,0x8(%ebp)
  801ad7:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801ada:	8b 45 08             	mov    0x8(%ebp),%eax
  801add:	8a 00                	mov    (%eax),%al
  801adf:	84 c0                	test   %al,%al
  801ae1:	74 18                	je     801afb <strsplit+0x52>
  801ae3:	8b 45 08             	mov    0x8(%ebp),%eax
  801ae6:	8a 00                	mov    (%eax),%al
  801ae8:	0f be c0             	movsbl %al,%eax
  801aeb:	50                   	push   %eax
  801aec:	ff 75 0c             	pushl  0xc(%ebp)
  801aef:	e8 83 fa ff ff       	call   801577 <strchr>
  801af4:	83 c4 08             	add    $0x8,%esp
  801af7:	85 c0                	test   %eax,%eax
  801af9:	75 d3                	jne    801ace <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801afb:	8b 45 08             	mov    0x8(%ebp),%eax
  801afe:	8a 00                	mov    (%eax),%al
  801b00:	84 c0                	test   %al,%al
  801b02:	74 5a                	je     801b5e <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801b04:	8b 45 14             	mov    0x14(%ebp),%eax
  801b07:	8b 00                	mov    (%eax),%eax
  801b09:	83 f8 0f             	cmp    $0xf,%eax
  801b0c:	75 07                	jne    801b15 <strsplit+0x6c>
		{
			return 0;
  801b0e:	b8 00 00 00 00       	mov    $0x0,%eax
  801b13:	eb 66                	jmp    801b7b <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801b15:	8b 45 14             	mov    0x14(%ebp),%eax
  801b18:	8b 00                	mov    (%eax),%eax
  801b1a:	8d 48 01             	lea    0x1(%eax),%ecx
  801b1d:	8b 55 14             	mov    0x14(%ebp),%edx
  801b20:	89 0a                	mov    %ecx,(%edx)
  801b22:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801b29:	8b 45 10             	mov    0x10(%ebp),%eax
  801b2c:	01 c2                	add    %eax,%edx
  801b2e:	8b 45 08             	mov    0x8(%ebp),%eax
  801b31:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801b33:	eb 03                	jmp    801b38 <strsplit+0x8f>
			string++;
  801b35:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801b38:	8b 45 08             	mov    0x8(%ebp),%eax
  801b3b:	8a 00                	mov    (%eax),%al
  801b3d:	84 c0                	test   %al,%al
  801b3f:	74 8b                	je     801acc <strsplit+0x23>
  801b41:	8b 45 08             	mov    0x8(%ebp),%eax
  801b44:	8a 00                	mov    (%eax),%al
  801b46:	0f be c0             	movsbl %al,%eax
  801b49:	50                   	push   %eax
  801b4a:	ff 75 0c             	pushl  0xc(%ebp)
  801b4d:	e8 25 fa ff ff       	call   801577 <strchr>
  801b52:	83 c4 08             	add    $0x8,%esp
  801b55:	85 c0                	test   %eax,%eax
  801b57:	74 dc                	je     801b35 <strsplit+0x8c>
			string++;
	}
  801b59:	e9 6e ff ff ff       	jmp    801acc <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801b5e:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801b5f:	8b 45 14             	mov    0x14(%ebp),%eax
  801b62:	8b 00                	mov    (%eax),%eax
  801b64:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801b6b:	8b 45 10             	mov    0x10(%ebp),%eax
  801b6e:	01 d0                	add    %edx,%eax
  801b70:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801b76:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801b7b:	c9                   	leave  
  801b7c:	c3                   	ret    

00801b7d <str2lower>:


char* str2lower(char *dst, const char *src)
{
  801b7d:	55                   	push   %ebp
  801b7e:	89 e5                	mov    %esp,%ebp
  801b80:	83 ec 10             	sub    $0x10,%esp
	char* ret = dst;
  801b83:	8b 45 08             	mov    0x8(%ebp),%eax
  801b86:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (int i = 0; i < strlen(src); ++i)
  801b89:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801b90:	eb 4a                	jmp    801bdc <str2lower+0x5f>
	{
		dst[i] = src[i] ;
  801b92:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801b95:	8b 45 08             	mov    0x8(%ebp),%eax
  801b98:	01 c2                	add    %eax,%edx
  801b9a:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801b9d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ba0:	01 c8                	add    %ecx,%eax
  801ba2:	8a 00                	mov    (%eax),%al
  801ba4:	88 02                	mov    %al,(%edx)
		if (src[i] >= 'A' && src[i] <= 'Z')
  801ba6:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801ba9:	8b 45 0c             	mov    0xc(%ebp),%eax
  801bac:	01 d0                	add    %edx,%eax
  801bae:	8a 00                	mov    (%eax),%al
  801bb0:	3c 40                	cmp    $0x40,%al
  801bb2:	7e 25                	jle    801bd9 <str2lower+0x5c>
  801bb4:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801bb7:	8b 45 0c             	mov    0xc(%ebp),%eax
  801bba:	01 d0                	add    %edx,%eax
  801bbc:	8a 00                	mov    (%eax),%al
  801bbe:	3c 5a                	cmp    $0x5a,%al
  801bc0:	7f 17                	jg     801bd9 <str2lower+0x5c>
		{
			dst[i] += 32 ;
  801bc2:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801bc5:	8b 45 08             	mov    0x8(%ebp),%eax
  801bc8:	01 d0                	add    %edx,%eax
  801bca:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801bcd:	8b 55 08             	mov    0x8(%ebp),%edx
  801bd0:	01 ca                	add    %ecx,%edx
  801bd2:	8a 12                	mov    (%edx),%dl
  801bd4:	83 c2 20             	add    $0x20,%edx
  801bd7:	88 10                	mov    %dl,(%eax)


char* str2lower(char *dst, const char *src)
{
	char* ret = dst;
	for (int i = 0; i < strlen(src); ++i)
  801bd9:	ff 45 fc             	incl   -0x4(%ebp)
  801bdc:	ff 75 0c             	pushl  0xc(%ebp)
  801bdf:	e8 01 f8 ff ff       	call   8013e5 <strlen>
  801be4:	83 c4 04             	add    $0x4,%esp
  801be7:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801bea:	7f a6                	jg     801b92 <str2lower+0x15>
		if (src[i] >= 'A' && src[i] <= 'Z')
		{
			dst[i] += 32 ;
		}
	}
	return ret;
  801bec:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801bef:	c9                   	leave  
  801bf0:	c3                   	ret    

00801bf1 <uheap_init>:
//==============================================
// [1] INITIALIZE USER HEAP:
//==============================================
int __firstTimeFlag = 1;
void uheap_init()
{
  801bf1:	55                   	push   %ebp
  801bf2:	89 e5                	mov    %esp,%ebp
  801bf4:	83 ec 08             	sub    $0x8,%esp
	if(__firstTimeFlag)
  801bf7:	a1 08 40 80 00       	mov    0x804008,%eax
  801bfc:	85 c0                	test   %eax,%eax
  801bfe:	74 42                	je     801c42 <uheap_init+0x51>
	{
		initialize_dynamic_allocator(USER_HEAP_START, USER_HEAP_START + DYN_ALLOC_MAX_SIZE);
  801c00:	83 ec 08             	sub    $0x8,%esp
  801c03:	68 00 00 00 82       	push   $0x82000000
  801c08:	68 00 00 00 80       	push   $0x80000000
  801c0d:	e8 00 08 00 00       	call   802412 <initialize_dynamic_allocator>
  801c12:	83 c4 10             	add    $0x10,%esp
		uheapPlaceStrategy = sys_get_uheap_strategy();
  801c15:	e8 e7 05 00 00       	call   802201 <sys_get_uheap_strategy>
  801c1a:	a3 64 c0 81 00       	mov    %eax,0x81c064
		uheapPageAllocStart = dynAllocEnd + PAGE_SIZE;
  801c1f:	a1 40 40 80 00       	mov    0x804040,%eax
  801c24:	05 00 10 00 00       	add    $0x1000,%eax
  801c29:	a3 10 c1 81 00       	mov    %eax,0x81c110
		uheapPageAllocBreak = uheapPageAllocStart;
  801c2e:	a1 10 c1 81 00       	mov    0x81c110,%eax
  801c33:	a3 6c c0 81 00       	mov    %eax,0x81c06c

		__firstTimeFlag = 0;
  801c38:	c7 05 08 40 80 00 00 	movl   $0x0,0x804008
  801c3f:	00 00 00 
	}
}
  801c42:	90                   	nop
  801c43:	c9                   	leave  
  801c44:	c3                   	ret    

00801c45 <get_page>:

//==============================================
// [2] GET A PAGE FROM THE KERNEL FOR DA:
//==============================================
int get_page(void* va)
{
  801c45:	55                   	push   %ebp
  801c46:	89 e5                	mov    %esp,%ebp
  801c48:	83 ec 18             	sub    $0x18,%esp
	int ret = __sys_allocate_page(ROUNDDOWN(va, PAGE_SIZE), PERM_USER|PERM_WRITEABLE|PERM_UHPAGE);
  801c4b:	8b 45 08             	mov    0x8(%ebp),%eax
  801c4e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801c51:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c54:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801c59:	83 ec 08             	sub    $0x8,%esp
  801c5c:	68 06 04 00 00       	push   $0x406
  801c61:	50                   	push   %eax
  801c62:	e8 e4 01 00 00       	call   801e4b <__sys_allocate_page>
  801c67:	83 c4 10             	add    $0x10,%esp
  801c6a:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (ret < 0)
  801c6d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801c71:	79 14                	jns    801c87 <get_page+0x42>
		panic("get_page() in user: failed to allocate page from the kernel");
  801c73:	83 ec 04             	sub    $0x4,%esp
  801c76:	68 dc 38 80 00       	push   $0x8038dc
  801c7b:	6a 1f                	push   $0x1f
  801c7d:	68 18 39 80 00       	push   $0x803918
  801c82:	e8 af eb ff ff       	call   800836 <_panic>
	return 0;
  801c87:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801c8c:	c9                   	leave  
  801c8d:	c3                   	ret    

00801c8e <return_page>:

//==============================================
// [3] RETURN A PAGE FROM THE DA TO KERNEL:
//==============================================
void return_page(void* va)
{
  801c8e:	55                   	push   %ebp
  801c8f:	89 e5                	mov    %esp,%ebp
  801c91:	83 ec 18             	sub    $0x18,%esp
	int ret = __sys_unmap_frame(ROUNDDOWN((uint32)va, PAGE_SIZE));
  801c94:	8b 45 08             	mov    0x8(%ebp),%eax
  801c97:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801c9a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c9d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801ca2:	83 ec 0c             	sub    $0xc,%esp
  801ca5:	50                   	push   %eax
  801ca6:	e8 e7 01 00 00       	call   801e92 <__sys_unmap_frame>
  801cab:	83 c4 10             	add    $0x10,%esp
  801cae:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (ret < 0)
  801cb1:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801cb5:	79 14                	jns    801ccb <return_page+0x3d>
		panic("return_page() in user: failed to return a page to the kernel");
  801cb7:	83 ec 04             	sub    $0x4,%esp
  801cba:	68 24 39 80 00       	push   $0x803924
  801cbf:	6a 2a                	push   $0x2a
  801cc1:	68 18 39 80 00       	push   $0x803918
  801cc6:	e8 6b eb ff ff       	call   800836 <_panic>
}
  801ccb:	90                   	nop
  801ccc:	c9                   	leave  
  801ccd:	c3                   	ret    

00801cce <malloc>:

//=================================
// [1] ALLOCATE SPACE IN USER HEAP:
//=================================
void* malloc(uint32 size)
{
  801cce:	55                   	push   %ebp
  801ccf:	89 e5                	mov    %esp,%ebp
  801cd1:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  801cd4:	e8 18 ff ff ff       	call   801bf1 <uheap_init>
	if (size == 0) return NULL ;
  801cd9:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801cdd:	75 07                	jne    801ce6 <malloc+0x18>
  801cdf:	b8 00 00 00 00       	mov    $0x0,%eax
  801ce4:	eb 14                	jmp    801cfa <malloc+0x2c>
	//==============================================================
	//TODO: [PROJECT'25.IM#2] USER HEAP - #1 malloc
	//Your code is here
	//Comment the following line
	panic("malloc() is not implemented yet...!!");
  801ce6:	83 ec 04             	sub    $0x4,%esp
  801ce9:	68 64 39 80 00       	push   $0x803964
  801cee:	6a 3e                	push   $0x3e
  801cf0:	68 18 39 80 00       	push   $0x803918
  801cf5:	e8 3c eb ff ff       	call   800836 <_panic>
}
  801cfa:	c9                   	leave  
  801cfb:	c3                   	ret    

00801cfc <free>:

//=================================
// [2] FREE SPACE FROM USER HEAP:
//=================================
void free(void* virtual_address)
{
  801cfc:	55                   	push   %ebp
  801cfd:	89 e5                	mov    %esp,%ebp
  801cff:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.IM#2] USER HEAP - #3 free
	//Your code is here
	//Comment the following line
	panic("free() is not implemented yet...!!");
  801d02:	83 ec 04             	sub    $0x4,%esp
  801d05:	68 8c 39 80 00       	push   $0x80398c
  801d0a:	6a 49                	push   $0x49
  801d0c:	68 18 39 80 00       	push   $0x803918
  801d11:	e8 20 eb ff ff       	call   800836 <_panic>

00801d16 <smalloc>:

//=================================
// [3] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  801d16:	55                   	push   %ebp
  801d17:	89 e5                	mov    %esp,%ebp
  801d19:	83 ec 18             	sub    $0x18,%esp
  801d1c:	8b 45 10             	mov    0x10(%ebp),%eax
  801d1f:	88 45 f4             	mov    %al,-0xc(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  801d22:	e8 ca fe ff ff       	call   801bf1 <uheap_init>
	if (size == 0) return NULL ;
  801d27:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801d2b:	75 07                	jne    801d34 <smalloc+0x1e>
  801d2d:	b8 00 00 00 00       	mov    $0x0,%eax
  801d32:	eb 14                	jmp    801d48 <smalloc+0x32>
	//==============================================================

	//TODO: [PROJECT'25.IM#3] SHARED MEMORY - #2 smalloc
	//Your code is here
	//Comment the following line
	panic("smalloc() is not implemented yet...!!");
  801d34:	83 ec 04             	sub    $0x4,%esp
  801d37:	68 b0 39 80 00       	push   $0x8039b0
  801d3c:	6a 5a                	push   $0x5a
  801d3e:	68 18 39 80 00       	push   $0x803918
  801d43:	e8 ee ea ff ff       	call   800836 <_panic>
}
  801d48:	c9                   	leave  
  801d49:	c3                   	ret    

00801d4a <sget>:

//========================================
// [4] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801d4a:	55                   	push   %ebp
  801d4b:	89 e5                	mov    %esp,%ebp
  801d4d:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  801d50:	e8 9c fe ff ff       	call   801bf1 <uheap_init>
	//==============================================================

	//TODO: [PROJECT'25.IM#3] SHARED MEMORY - #4 sget
	//Your code is here
	//Comment the following line
	panic("sget() is not implemented yet...!!");
  801d55:	83 ec 04             	sub    $0x4,%esp
  801d58:	68 d8 39 80 00       	push   $0x8039d8
  801d5d:	6a 6a                	push   $0x6a
  801d5f:	68 18 39 80 00       	push   $0x803918
  801d64:	e8 cd ea ff ff       	call   800836 <_panic>

00801d69 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801d69:	55                   	push   %ebp
  801d6a:	89 e5                	mov    %esp,%ebp
  801d6c:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  801d6f:	e8 7d fe ff ff       	call   801bf1 <uheap_init>
	//==============================================================
	panic("realloc() is not implemented yet...!!");
  801d74:	83 ec 04             	sub    $0x4,%esp
  801d77:	68 fc 39 80 00       	push   $0x8039fc
  801d7c:	68 88 00 00 00       	push   $0x88
  801d81:	68 18 39 80 00       	push   $0x803918
  801d86:	e8 ab ea ff ff       	call   800836 <_panic>

00801d8b <sfree>:
//
//	use sys_delete_shared_object(...); which switches to the kernel mode,
//	calls delete_shared_object(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the delete_shared_object() function is empty, make sure to implement it.
void sfree(void* virtual_address)
{
  801d8b:	55                   	push   %ebp
  801d8c:	89 e5                	mov    %esp,%ebp
  801d8e:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.BONUS#5] EXIT #2 - sfree
	//Your code is here
	//Comment the following line
	panic("sfree() is not implemented yet...!!");
  801d91:	83 ec 04             	sub    $0x4,%esp
  801d94:	68 24 3a 80 00       	push   $0x803a24
  801d99:	68 9b 00 00 00       	push   $0x9b
  801d9e:	68 18 39 80 00       	push   $0x803918
  801da3:	e8 8e ea ff ff       	call   800836 <_panic>

00801da8 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801da8:	55                   	push   %ebp
  801da9:	89 e5                	mov    %esp,%ebp
  801dab:	57                   	push   %edi
  801dac:	56                   	push   %esi
  801dad:	53                   	push   %ebx
  801dae:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801db1:	8b 45 08             	mov    0x8(%ebp),%eax
  801db4:	8b 55 0c             	mov    0xc(%ebp),%edx
  801db7:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801dba:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801dbd:	8b 7d 18             	mov    0x18(%ebp),%edi
  801dc0:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801dc3:	cd 30                	int    $0x30
  801dc5:	89 45 f0             	mov    %eax,-0x10(%ebp)
				"b" (a3),
				"D" (a4),
				"S" (a5)
				: "cc", "memory");

	return ret;
  801dc8:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801dcb:	83 c4 10             	add    $0x10,%esp
  801dce:	5b                   	pop    %ebx
  801dcf:	5e                   	pop    %esi
  801dd0:	5f                   	pop    %edi
  801dd1:	5d                   	pop    %ebp
  801dd2:	c3                   	ret    

00801dd3 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName, int color)
{
  801dd3:	55                   	push   %ebp
  801dd4:	89 e5                	mov    %esp,%ebp
  801dd6:	83 ec 04             	sub    $0x4,%esp
  801dd9:	8b 45 10             	mov    0x10(%ebp),%eax
  801ddc:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, color, 0);
  801ddf:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801de2:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801de6:	8b 45 08             	mov    0x8(%ebp),%eax
  801de9:	6a 00                	push   $0x0
  801deb:	51                   	push   %ecx
  801dec:	52                   	push   %edx
  801ded:	ff 75 0c             	pushl  0xc(%ebp)
  801df0:	50                   	push   %eax
  801df1:	6a 00                	push   $0x0
  801df3:	e8 b0 ff ff ff       	call   801da8 <syscall>
  801df8:	83 c4 18             	add    $0x18,%esp
}
  801dfb:	90                   	nop
  801dfc:	c9                   	leave  
  801dfd:	c3                   	ret    

00801dfe <sys_cgetc>:

int
sys_cgetc(void)
{
  801dfe:	55                   	push   %ebp
  801dff:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801e01:	6a 00                	push   $0x0
  801e03:	6a 00                	push   $0x0
  801e05:	6a 00                	push   $0x0
  801e07:	6a 00                	push   $0x0
  801e09:	6a 00                	push   $0x0
  801e0b:	6a 02                	push   $0x2
  801e0d:	e8 96 ff ff ff       	call   801da8 <syscall>
  801e12:	83 c4 18             	add    $0x18,%esp
}
  801e15:	c9                   	leave  
  801e16:	c3                   	ret    

00801e17 <sys_lock_cons>:

void sys_lock_cons(void)
{
  801e17:	55                   	push   %ebp
  801e18:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  801e1a:	6a 00                	push   $0x0
  801e1c:	6a 00                	push   $0x0
  801e1e:	6a 00                	push   $0x0
  801e20:	6a 00                	push   $0x0
  801e22:	6a 00                	push   $0x0
  801e24:	6a 03                	push   $0x3
  801e26:	e8 7d ff ff ff       	call   801da8 <syscall>
  801e2b:	83 c4 18             	add    $0x18,%esp
}
  801e2e:	90                   	nop
  801e2f:	c9                   	leave  
  801e30:	c3                   	ret    

00801e31 <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  801e31:	55                   	push   %ebp
  801e32:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  801e34:	6a 00                	push   $0x0
  801e36:	6a 00                	push   $0x0
  801e38:	6a 00                	push   $0x0
  801e3a:	6a 00                	push   $0x0
  801e3c:	6a 00                	push   $0x0
  801e3e:	6a 04                	push   $0x4
  801e40:	e8 63 ff ff ff       	call   801da8 <syscall>
  801e45:	83 c4 18             	add    $0x18,%esp
}
  801e48:	90                   	nop
  801e49:	c9                   	leave  
  801e4a:	c3                   	ret    

00801e4b <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801e4b:	55                   	push   %ebp
  801e4c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801e4e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e51:	8b 45 08             	mov    0x8(%ebp),%eax
  801e54:	6a 00                	push   $0x0
  801e56:	6a 00                	push   $0x0
  801e58:	6a 00                	push   $0x0
  801e5a:	52                   	push   %edx
  801e5b:	50                   	push   %eax
  801e5c:	6a 08                	push   $0x8
  801e5e:	e8 45 ff ff ff       	call   801da8 <syscall>
  801e63:	83 c4 18             	add    $0x18,%esp
}
  801e66:	c9                   	leave  
  801e67:	c3                   	ret    

00801e68 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801e68:	55                   	push   %ebp
  801e69:	89 e5                	mov    %esp,%ebp
  801e6b:	56                   	push   %esi
  801e6c:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801e6d:	8b 75 18             	mov    0x18(%ebp),%esi
  801e70:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801e73:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801e76:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e79:	8b 45 08             	mov    0x8(%ebp),%eax
  801e7c:	56                   	push   %esi
  801e7d:	53                   	push   %ebx
  801e7e:	51                   	push   %ecx
  801e7f:	52                   	push   %edx
  801e80:	50                   	push   %eax
  801e81:	6a 09                	push   $0x9
  801e83:	e8 20 ff ff ff       	call   801da8 <syscall>
  801e88:	83 c4 18             	add    $0x18,%esp
}
  801e8b:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801e8e:	5b                   	pop    %ebx
  801e8f:	5e                   	pop    %esi
  801e90:	5d                   	pop    %ebp
  801e91:	c3                   	ret    

00801e92 <__sys_unmap_frame>:

int __sys_unmap_frame(uint32 va)
{
  801e92:	55                   	push   %ebp
  801e93:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, va, 0, 0, 0, 0);
  801e95:	6a 00                	push   $0x0
  801e97:	6a 00                	push   $0x0
  801e99:	6a 00                	push   $0x0
  801e9b:	6a 00                	push   $0x0
  801e9d:	ff 75 08             	pushl  0x8(%ebp)
  801ea0:	6a 0a                	push   $0xa
  801ea2:	e8 01 ff ff ff       	call   801da8 <syscall>
  801ea7:	83 c4 18             	add    $0x18,%esp
}
  801eaa:	c9                   	leave  
  801eab:	c3                   	ret    

00801eac <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801eac:	55                   	push   %ebp
  801ead:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801eaf:	6a 00                	push   $0x0
  801eb1:	6a 00                	push   $0x0
  801eb3:	6a 00                	push   $0x0
  801eb5:	ff 75 0c             	pushl  0xc(%ebp)
  801eb8:	ff 75 08             	pushl  0x8(%ebp)
  801ebb:	6a 0b                	push   $0xb
  801ebd:	e8 e6 fe ff ff       	call   801da8 <syscall>
  801ec2:	83 c4 18             	add    $0x18,%esp
}
  801ec5:	c9                   	leave  
  801ec6:	c3                   	ret    

00801ec7 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801ec7:	55                   	push   %ebp
  801ec8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801eca:	6a 00                	push   $0x0
  801ecc:	6a 00                	push   $0x0
  801ece:	6a 00                	push   $0x0
  801ed0:	6a 00                	push   $0x0
  801ed2:	6a 00                	push   $0x0
  801ed4:	6a 0c                	push   $0xc
  801ed6:	e8 cd fe ff ff       	call   801da8 <syscall>
  801edb:	83 c4 18             	add    $0x18,%esp
}
  801ede:	c9                   	leave  
  801edf:	c3                   	ret    

00801ee0 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801ee0:	55                   	push   %ebp
  801ee1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801ee3:	6a 00                	push   $0x0
  801ee5:	6a 00                	push   $0x0
  801ee7:	6a 00                	push   $0x0
  801ee9:	6a 00                	push   $0x0
  801eeb:	6a 00                	push   $0x0
  801eed:	6a 0d                	push   $0xd
  801eef:	e8 b4 fe ff ff       	call   801da8 <syscall>
  801ef4:	83 c4 18             	add    $0x18,%esp
}
  801ef7:	c9                   	leave  
  801ef8:	c3                   	ret    

00801ef9 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801ef9:	55                   	push   %ebp
  801efa:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801efc:	6a 00                	push   $0x0
  801efe:	6a 00                	push   $0x0
  801f00:	6a 00                	push   $0x0
  801f02:	6a 00                	push   $0x0
  801f04:	6a 00                	push   $0x0
  801f06:	6a 0e                	push   $0xe
  801f08:	e8 9b fe ff ff       	call   801da8 <syscall>
  801f0d:	83 c4 18             	add    $0x18,%esp
}
  801f10:	c9                   	leave  
  801f11:	c3                   	ret    

00801f12 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801f12:	55                   	push   %ebp
  801f13:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801f15:	6a 00                	push   $0x0
  801f17:	6a 00                	push   $0x0
  801f19:	6a 00                	push   $0x0
  801f1b:	6a 00                	push   $0x0
  801f1d:	6a 00                	push   $0x0
  801f1f:	6a 0f                	push   $0xf
  801f21:	e8 82 fe ff ff       	call   801da8 <syscall>
  801f26:	83 c4 18             	add    $0x18,%esp
}
  801f29:	c9                   	leave  
  801f2a:	c3                   	ret    

00801f2b <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801f2b:	55                   	push   %ebp
  801f2c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801f2e:	6a 00                	push   $0x0
  801f30:	6a 00                	push   $0x0
  801f32:	6a 00                	push   $0x0
  801f34:	6a 00                	push   $0x0
  801f36:	ff 75 08             	pushl  0x8(%ebp)
  801f39:	6a 10                	push   $0x10
  801f3b:	e8 68 fe ff ff       	call   801da8 <syscall>
  801f40:	83 c4 18             	add    $0x18,%esp
}
  801f43:	c9                   	leave  
  801f44:	c3                   	ret    

00801f45 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801f45:	55                   	push   %ebp
  801f46:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801f48:	6a 00                	push   $0x0
  801f4a:	6a 00                	push   $0x0
  801f4c:	6a 00                	push   $0x0
  801f4e:	6a 00                	push   $0x0
  801f50:	6a 00                	push   $0x0
  801f52:	6a 11                	push   $0x11
  801f54:	e8 4f fe ff ff       	call   801da8 <syscall>
  801f59:	83 c4 18             	add    $0x18,%esp
}
  801f5c:	90                   	nop
  801f5d:	c9                   	leave  
  801f5e:	c3                   	ret    

00801f5f <sys_cputc>:

void
sys_cputc(const char c)
{
  801f5f:	55                   	push   %ebp
  801f60:	89 e5                	mov    %esp,%ebp
  801f62:	83 ec 04             	sub    $0x4,%esp
  801f65:	8b 45 08             	mov    0x8(%ebp),%eax
  801f68:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801f6b:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801f6f:	6a 00                	push   $0x0
  801f71:	6a 00                	push   $0x0
  801f73:	6a 00                	push   $0x0
  801f75:	6a 00                	push   $0x0
  801f77:	50                   	push   %eax
  801f78:	6a 01                	push   $0x1
  801f7a:	e8 29 fe ff ff       	call   801da8 <syscall>
  801f7f:	83 c4 18             	add    $0x18,%esp
}
  801f82:	90                   	nop
  801f83:	c9                   	leave  
  801f84:	c3                   	ret    

00801f85 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801f85:	55                   	push   %ebp
  801f86:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801f88:	6a 00                	push   $0x0
  801f8a:	6a 00                	push   $0x0
  801f8c:	6a 00                	push   $0x0
  801f8e:	6a 00                	push   $0x0
  801f90:	6a 00                	push   $0x0
  801f92:	6a 14                	push   $0x14
  801f94:	e8 0f fe ff ff       	call   801da8 <syscall>
  801f99:	83 c4 18             	add    $0x18,%esp
}
  801f9c:	90                   	nop
  801f9d:	c9                   	leave  
  801f9e:	c3                   	ret    

00801f9f <sys_create_shared_object>:

int sys_create_shared_object(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801f9f:	55                   	push   %ebp
  801fa0:	89 e5                	mov    %esp,%ebp
  801fa2:	83 ec 04             	sub    $0x4,%esp
  801fa5:	8b 45 10             	mov    0x10(%ebp),%eax
  801fa8:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801fab:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801fae:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801fb2:	8b 45 08             	mov    0x8(%ebp),%eax
  801fb5:	6a 00                	push   $0x0
  801fb7:	51                   	push   %ecx
  801fb8:	52                   	push   %edx
  801fb9:	ff 75 0c             	pushl  0xc(%ebp)
  801fbc:	50                   	push   %eax
  801fbd:	6a 15                	push   $0x15
  801fbf:	e8 e4 fd ff ff       	call   801da8 <syscall>
  801fc4:	83 c4 18             	add    $0x18,%esp
}
  801fc7:	c9                   	leave  
  801fc8:	c3                   	ret    

00801fc9 <sys_size_of_shared_object>:

//2017:
int sys_size_of_shared_object(int32 ownerID, char* shareName)
{
  801fc9:	55                   	push   %ebp
  801fca:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801fcc:	8b 55 0c             	mov    0xc(%ebp),%edx
  801fcf:	8b 45 08             	mov    0x8(%ebp),%eax
  801fd2:	6a 00                	push   $0x0
  801fd4:	6a 00                	push   $0x0
  801fd6:	6a 00                	push   $0x0
  801fd8:	52                   	push   %edx
  801fd9:	50                   	push   %eax
  801fda:	6a 16                	push   $0x16
  801fdc:	e8 c7 fd ff ff       	call   801da8 <syscall>
  801fe1:	83 c4 18             	add    $0x18,%esp
}
  801fe4:	c9                   	leave  
  801fe5:	c3                   	ret    

00801fe6 <sys_get_shared_object>:
//==========

int sys_get_shared_object(int32 ownerID, char* shareName, void* virtual_address)
{
  801fe6:	55                   	push   %ebp
  801fe7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801fe9:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801fec:	8b 55 0c             	mov    0xc(%ebp),%edx
  801fef:	8b 45 08             	mov    0x8(%ebp),%eax
  801ff2:	6a 00                	push   $0x0
  801ff4:	6a 00                	push   $0x0
  801ff6:	51                   	push   %ecx
  801ff7:	52                   	push   %edx
  801ff8:	50                   	push   %eax
  801ff9:	6a 17                	push   $0x17
  801ffb:	e8 a8 fd ff ff       	call   801da8 <syscall>
  802000:	83 c4 18             	add    $0x18,%esp
}
  802003:	c9                   	leave  
  802004:	c3                   	ret    

00802005 <sys_delete_shared_object>:

int sys_delete_shared_object(int32 sharedObjectID, void *startVA)
{
  802005:	55                   	push   %ebp
  802006:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  802008:	8b 55 0c             	mov    0xc(%ebp),%edx
  80200b:	8b 45 08             	mov    0x8(%ebp),%eax
  80200e:	6a 00                	push   $0x0
  802010:	6a 00                	push   $0x0
  802012:	6a 00                	push   $0x0
  802014:	52                   	push   %edx
  802015:	50                   	push   %eax
  802016:	6a 18                	push   $0x18
  802018:	e8 8b fd ff ff       	call   801da8 <syscall>
  80201d:	83 c4 18             	add    $0x18,%esp
}
  802020:	c9                   	leave  
  802021:	c3                   	ret    

00802022 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  802022:	55                   	push   %ebp
  802023:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  802025:	8b 45 08             	mov    0x8(%ebp),%eax
  802028:	6a 00                	push   $0x0
  80202a:	ff 75 14             	pushl  0x14(%ebp)
  80202d:	ff 75 10             	pushl  0x10(%ebp)
  802030:	ff 75 0c             	pushl  0xc(%ebp)
  802033:	50                   	push   %eax
  802034:	6a 19                	push   $0x19
  802036:	e8 6d fd ff ff       	call   801da8 <syscall>
  80203b:	83 c4 18             	add    $0x18,%esp
}
  80203e:	c9                   	leave  
  80203f:	c3                   	ret    

00802040 <sys_run_env>:

void sys_run_env(int32 envId)
{
  802040:	55                   	push   %ebp
  802041:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  802043:	8b 45 08             	mov    0x8(%ebp),%eax
  802046:	6a 00                	push   $0x0
  802048:	6a 00                	push   $0x0
  80204a:	6a 00                	push   $0x0
  80204c:	6a 00                	push   $0x0
  80204e:	50                   	push   %eax
  80204f:	6a 1a                	push   $0x1a
  802051:	e8 52 fd ff ff       	call   801da8 <syscall>
  802056:	83 c4 18             	add    $0x18,%esp
}
  802059:	90                   	nop
  80205a:	c9                   	leave  
  80205b:	c3                   	ret    

0080205c <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  80205c:	55                   	push   %ebp
  80205d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  80205f:	8b 45 08             	mov    0x8(%ebp),%eax
  802062:	6a 00                	push   $0x0
  802064:	6a 00                	push   $0x0
  802066:	6a 00                	push   $0x0
  802068:	6a 00                	push   $0x0
  80206a:	50                   	push   %eax
  80206b:	6a 1b                	push   $0x1b
  80206d:	e8 36 fd ff ff       	call   801da8 <syscall>
  802072:	83 c4 18             	add    $0x18,%esp
}
  802075:	c9                   	leave  
  802076:	c3                   	ret    

00802077 <sys_getenvid>:

int32 sys_getenvid(void)
{
  802077:	55                   	push   %ebp
  802078:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  80207a:	6a 00                	push   $0x0
  80207c:	6a 00                	push   $0x0
  80207e:	6a 00                	push   $0x0
  802080:	6a 00                	push   $0x0
  802082:	6a 00                	push   $0x0
  802084:	6a 05                	push   $0x5
  802086:	e8 1d fd ff ff       	call   801da8 <syscall>
  80208b:	83 c4 18             	add    $0x18,%esp
}
  80208e:	c9                   	leave  
  80208f:	c3                   	ret    

00802090 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  802090:	55                   	push   %ebp
  802091:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  802093:	6a 00                	push   $0x0
  802095:	6a 00                	push   $0x0
  802097:	6a 00                	push   $0x0
  802099:	6a 00                	push   $0x0
  80209b:	6a 00                	push   $0x0
  80209d:	6a 06                	push   $0x6
  80209f:	e8 04 fd ff ff       	call   801da8 <syscall>
  8020a4:	83 c4 18             	add    $0x18,%esp
}
  8020a7:	c9                   	leave  
  8020a8:	c3                   	ret    

008020a9 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  8020a9:	55                   	push   %ebp
  8020aa:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  8020ac:	6a 00                	push   $0x0
  8020ae:	6a 00                	push   $0x0
  8020b0:	6a 00                	push   $0x0
  8020b2:	6a 00                	push   $0x0
  8020b4:	6a 00                	push   $0x0
  8020b6:	6a 07                	push   $0x7
  8020b8:	e8 eb fc ff ff       	call   801da8 <syscall>
  8020bd:	83 c4 18             	add    $0x18,%esp
}
  8020c0:	c9                   	leave  
  8020c1:	c3                   	ret    

008020c2 <sys_exit_env>:


void sys_exit_env(void)
{
  8020c2:	55                   	push   %ebp
  8020c3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  8020c5:	6a 00                	push   $0x0
  8020c7:	6a 00                	push   $0x0
  8020c9:	6a 00                	push   $0x0
  8020cb:	6a 00                	push   $0x0
  8020cd:	6a 00                	push   $0x0
  8020cf:	6a 1c                	push   $0x1c
  8020d1:	e8 d2 fc ff ff       	call   801da8 <syscall>
  8020d6:	83 c4 18             	add    $0x18,%esp
}
  8020d9:	90                   	nop
  8020da:	c9                   	leave  
  8020db:	c3                   	ret    

008020dc <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  8020dc:	55                   	push   %ebp
  8020dd:	89 e5                	mov    %esp,%ebp
  8020df:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  8020e2:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8020e5:	8d 50 04             	lea    0x4(%eax),%edx
  8020e8:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8020eb:	6a 00                	push   $0x0
  8020ed:	6a 00                	push   $0x0
  8020ef:	6a 00                	push   $0x0
  8020f1:	52                   	push   %edx
  8020f2:	50                   	push   %eax
  8020f3:	6a 1d                	push   $0x1d
  8020f5:	e8 ae fc ff ff       	call   801da8 <syscall>
  8020fa:	83 c4 18             	add    $0x18,%esp
	return result;
  8020fd:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802100:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802103:	8b 55 fc             	mov    -0x4(%ebp),%edx
  802106:	89 01                	mov    %eax,(%ecx)
  802108:	89 51 04             	mov    %edx,0x4(%ecx)
}
  80210b:	8b 45 08             	mov    0x8(%ebp),%eax
  80210e:	c9                   	leave  
  80210f:	c2 04 00             	ret    $0x4

00802112 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  802112:	55                   	push   %ebp
  802113:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  802115:	6a 00                	push   $0x0
  802117:	6a 00                	push   $0x0
  802119:	ff 75 10             	pushl  0x10(%ebp)
  80211c:	ff 75 0c             	pushl  0xc(%ebp)
  80211f:	ff 75 08             	pushl  0x8(%ebp)
  802122:	6a 13                	push   $0x13
  802124:	e8 7f fc ff ff       	call   801da8 <syscall>
  802129:	83 c4 18             	add    $0x18,%esp
	return ;
  80212c:	90                   	nop
}
  80212d:	c9                   	leave  
  80212e:	c3                   	ret    

0080212f <sys_rcr2>:
uint32 sys_rcr2()
{
  80212f:	55                   	push   %ebp
  802130:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  802132:	6a 00                	push   $0x0
  802134:	6a 00                	push   $0x0
  802136:	6a 00                	push   $0x0
  802138:	6a 00                	push   $0x0
  80213a:	6a 00                	push   $0x0
  80213c:	6a 1e                	push   $0x1e
  80213e:	e8 65 fc ff ff       	call   801da8 <syscall>
  802143:	83 c4 18             	add    $0x18,%esp
}
  802146:	c9                   	leave  
  802147:	c3                   	ret    

00802148 <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  802148:	55                   	push   %ebp
  802149:	89 e5                	mov    %esp,%ebp
  80214b:	83 ec 04             	sub    $0x4,%esp
  80214e:	8b 45 08             	mov    0x8(%ebp),%eax
  802151:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  802154:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  802158:	6a 00                	push   $0x0
  80215a:	6a 00                	push   $0x0
  80215c:	6a 00                	push   $0x0
  80215e:	6a 00                	push   $0x0
  802160:	50                   	push   %eax
  802161:	6a 1f                	push   $0x1f
  802163:	e8 40 fc ff ff       	call   801da8 <syscall>
  802168:	83 c4 18             	add    $0x18,%esp
	return ;
  80216b:	90                   	nop
}
  80216c:	c9                   	leave  
  80216d:	c3                   	ret    

0080216e <rsttst>:
void rsttst()
{
  80216e:	55                   	push   %ebp
  80216f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  802171:	6a 00                	push   $0x0
  802173:	6a 00                	push   $0x0
  802175:	6a 00                	push   $0x0
  802177:	6a 00                	push   $0x0
  802179:	6a 00                	push   $0x0
  80217b:	6a 21                	push   $0x21
  80217d:	e8 26 fc ff ff       	call   801da8 <syscall>
  802182:	83 c4 18             	add    $0x18,%esp
	return ;
  802185:	90                   	nop
}
  802186:	c9                   	leave  
  802187:	c3                   	ret    

00802188 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  802188:	55                   	push   %ebp
  802189:	89 e5                	mov    %esp,%ebp
  80218b:	83 ec 04             	sub    $0x4,%esp
  80218e:	8b 45 14             	mov    0x14(%ebp),%eax
  802191:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  802194:	8b 55 18             	mov    0x18(%ebp),%edx
  802197:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  80219b:	52                   	push   %edx
  80219c:	50                   	push   %eax
  80219d:	ff 75 10             	pushl  0x10(%ebp)
  8021a0:	ff 75 0c             	pushl  0xc(%ebp)
  8021a3:	ff 75 08             	pushl  0x8(%ebp)
  8021a6:	6a 20                	push   $0x20
  8021a8:	e8 fb fb ff ff       	call   801da8 <syscall>
  8021ad:	83 c4 18             	add    $0x18,%esp
	return ;
  8021b0:	90                   	nop
}
  8021b1:	c9                   	leave  
  8021b2:	c3                   	ret    

008021b3 <chktst>:
void chktst(uint32 n)
{
  8021b3:	55                   	push   %ebp
  8021b4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  8021b6:	6a 00                	push   $0x0
  8021b8:	6a 00                	push   $0x0
  8021ba:	6a 00                	push   $0x0
  8021bc:	6a 00                	push   $0x0
  8021be:	ff 75 08             	pushl  0x8(%ebp)
  8021c1:	6a 22                	push   $0x22
  8021c3:	e8 e0 fb ff ff       	call   801da8 <syscall>
  8021c8:	83 c4 18             	add    $0x18,%esp
	return ;
  8021cb:	90                   	nop
}
  8021cc:	c9                   	leave  
  8021cd:	c3                   	ret    

008021ce <inctst>:

void inctst()
{
  8021ce:	55                   	push   %ebp
  8021cf:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  8021d1:	6a 00                	push   $0x0
  8021d3:	6a 00                	push   $0x0
  8021d5:	6a 00                	push   $0x0
  8021d7:	6a 00                	push   $0x0
  8021d9:	6a 00                	push   $0x0
  8021db:	6a 23                	push   $0x23
  8021dd:	e8 c6 fb ff ff       	call   801da8 <syscall>
  8021e2:	83 c4 18             	add    $0x18,%esp
	return ;
  8021e5:	90                   	nop
}
  8021e6:	c9                   	leave  
  8021e7:	c3                   	ret    

008021e8 <gettst>:
uint32 gettst()
{
  8021e8:	55                   	push   %ebp
  8021e9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  8021eb:	6a 00                	push   $0x0
  8021ed:	6a 00                	push   $0x0
  8021ef:	6a 00                	push   $0x0
  8021f1:	6a 00                	push   $0x0
  8021f3:	6a 00                	push   $0x0
  8021f5:	6a 24                	push   $0x24
  8021f7:	e8 ac fb ff ff       	call   801da8 <syscall>
  8021fc:	83 c4 18             	add    $0x18,%esp
}
  8021ff:	c9                   	leave  
  802200:	c3                   	ret    

00802201 <sys_get_uheap_strategy>:

/*2025*/
uint32 sys_get_uheap_strategy()
{
  802201:	55                   	push   %ebp
  802202:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802204:	6a 00                	push   $0x0
  802206:	6a 00                	push   $0x0
  802208:	6a 00                	push   $0x0
  80220a:	6a 00                	push   $0x0
  80220c:	6a 00                	push   $0x0
  80220e:	6a 25                	push   $0x25
  802210:	e8 93 fb ff ff       	call   801da8 <syscall>
  802215:	83 c4 18             	add    $0x18,%esp
  802218:	a3 64 c0 81 00       	mov    %eax,0x81c064
	return uheapPlaceStrategy ;
  80221d:	a1 64 c0 81 00       	mov    0x81c064,%eax
}
  802222:	c9                   	leave  
  802223:	c3                   	ret    

00802224 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  802224:	55                   	push   %ebp
  802225:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = heapStrategy;
  802227:	8b 45 08             	mov    0x8(%ebp),%eax
  80222a:	a3 64 c0 81 00       	mov    %eax,0x81c064
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  80222f:	6a 00                	push   $0x0
  802231:	6a 00                	push   $0x0
  802233:	6a 00                	push   $0x0
  802235:	6a 00                	push   $0x0
  802237:	ff 75 08             	pushl  0x8(%ebp)
  80223a:	6a 26                	push   $0x26
  80223c:	e8 67 fb ff ff       	call   801da8 <syscall>
  802241:	83 c4 18             	add    $0x18,%esp
	return ;
  802244:	90                   	nop
}
  802245:	c9                   	leave  
  802246:	c3                   	ret    

00802247 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  802247:	55                   	push   %ebp
  802248:	89 e5                	mov    %esp,%ebp
  80224a:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  80224b:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80224e:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802251:	8b 55 0c             	mov    0xc(%ebp),%edx
  802254:	8b 45 08             	mov    0x8(%ebp),%eax
  802257:	6a 00                	push   $0x0
  802259:	53                   	push   %ebx
  80225a:	51                   	push   %ecx
  80225b:	52                   	push   %edx
  80225c:	50                   	push   %eax
  80225d:	6a 27                	push   $0x27
  80225f:	e8 44 fb ff ff       	call   801da8 <syscall>
  802264:	83 c4 18             	add    $0x18,%esp
}
  802267:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80226a:	c9                   	leave  
  80226b:	c3                   	ret    

0080226c <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  80226c:	55                   	push   %ebp
  80226d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  80226f:	8b 55 0c             	mov    0xc(%ebp),%edx
  802272:	8b 45 08             	mov    0x8(%ebp),%eax
  802275:	6a 00                	push   $0x0
  802277:	6a 00                	push   $0x0
  802279:	6a 00                	push   $0x0
  80227b:	52                   	push   %edx
  80227c:	50                   	push   %eax
  80227d:	6a 28                	push   $0x28
  80227f:	e8 24 fb ff ff       	call   801da8 <syscall>
  802284:	83 c4 18             	add    $0x18,%esp
}
  802287:	c9                   	leave  
  802288:	c3                   	ret    

00802289 <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  802289:	55                   	push   %ebp
  80228a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  80228c:	8b 4d 14             	mov    0x14(%ebp),%ecx
  80228f:	8b 55 0c             	mov    0xc(%ebp),%edx
  802292:	8b 45 08             	mov    0x8(%ebp),%eax
  802295:	6a 00                	push   $0x0
  802297:	51                   	push   %ecx
  802298:	ff 75 10             	pushl  0x10(%ebp)
  80229b:	52                   	push   %edx
  80229c:	50                   	push   %eax
  80229d:	6a 29                	push   $0x29
  80229f:	e8 04 fb ff ff       	call   801da8 <syscall>
  8022a4:	83 c4 18             	add    $0x18,%esp
}
  8022a7:	c9                   	leave  
  8022a8:	c3                   	ret    

008022a9 <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  8022a9:	55                   	push   %ebp
  8022aa:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  8022ac:	6a 00                	push   $0x0
  8022ae:	6a 00                	push   $0x0
  8022b0:	ff 75 10             	pushl  0x10(%ebp)
  8022b3:	ff 75 0c             	pushl  0xc(%ebp)
  8022b6:	ff 75 08             	pushl  0x8(%ebp)
  8022b9:	6a 12                	push   $0x12
  8022bb:	e8 e8 fa ff ff       	call   801da8 <syscall>
  8022c0:	83 c4 18             	add    $0x18,%esp
	return ;
  8022c3:	90                   	nop
}
  8022c4:	c9                   	leave  
  8022c5:	c3                   	ret    

008022c6 <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  8022c6:	55                   	push   %ebp
  8022c7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  8022c9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8022cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8022cf:	6a 00                	push   $0x0
  8022d1:	6a 00                	push   $0x0
  8022d3:	6a 00                	push   $0x0
  8022d5:	52                   	push   %edx
  8022d6:	50                   	push   %eax
  8022d7:	6a 2a                	push   $0x2a
  8022d9:	e8 ca fa ff ff       	call   801da8 <syscall>
  8022de:	83 c4 18             	add    $0x18,%esp
	return;
  8022e1:	90                   	nop
}
  8022e2:	c9                   	leave  
  8022e3:	c3                   	ret    

008022e4 <sys_get_optimal_num_faults>:
/*2025*/
int sys_get_optimal_num_faults()
{
  8022e4:	55                   	push   %ebp
  8022e5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_optimal_num_faults, 0, 0, 0, 0, 0);
  8022e7:	6a 00                	push   $0x0
  8022e9:	6a 00                	push   $0x0
  8022eb:	6a 00                	push   $0x0
  8022ed:	6a 00                	push   $0x0
  8022ef:	6a 00                	push   $0x0
  8022f1:	6a 2b                	push   $0x2b
  8022f3:	e8 b0 fa ff ff       	call   801da8 <syscall>
  8022f8:	83 c4 18             	add    $0x18,%esp
}
  8022fb:	c9                   	leave  
  8022fc:	c3                   	ret    

008022fd <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  8022fd:	55                   	push   %ebp
  8022fe:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  802300:	6a 00                	push   $0x0
  802302:	6a 00                	push   $0x0
  802304:	6a 00                	push   $0x0
  802306:	ff 75 0c             	pushl  0xc(%ebp)
  802309:	ff 75 08             	pushl  0x8(%ebp)
  80230c:	6a 2d                	push   $0x2d
  80230e:	e8 95 fa ff ff       	call   801da8 <syscall>
  802313:	83 c4 18             	add    $0x18,%esp
	return;
  802316:	90                   	nop
}
  802317:	c9                   	leave  
  802318:	c3                   	ret    

00802319 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  802319:	55                   	push   %ebp
  80231a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  80231c:	6a 00                	push   $0x0
  80231e:	6a 00                	push   $0x0
  802320:	6a 00                	push   $0x0
  802322:	ff 75 0c             	pushl  0xc(%ebp)
  802325:	ff 75 08             	pushl  0x8(%ebp)
  802328:	6a 2c                	push   $0x2c
  80232a:	e8 79 fa ff ff       	call   801da8 <syscall>
  80232f:	83 c4 18             	add    $0x18,%esp
	return ;
  802332:	90                   	nop
}
  802333:	c9                   	leave  
  802334:	c3                   	ret    

00802335 <sys_env_set_priority>:


void sys_env_set_priority(int32 envID, int priority)
{
  802335:	55                   	push   %ebp
  802336:	89 e5                	mov    %esp,%ebp
  802338:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.IM#4] CPU SCHEDULING - #1 System Calls - Add suitable code here
	//Your code is here
	//Comment the following line
	panic("sys_env_set_priority() is not implemented yet...!!");
  80233b:	83 ec 04             	sub    $0x4,%esp
  80233e:	68 48 3a 80 00       	push   $0x803a48
  802343:	68 25 01 00 00       	push   $0x125
  802348:	68 7b 3a 80 00       	push   $0x803a7b
  80234d:	e8 e4 e4 ff ff       	call   800836 <_panic>

00802352 <to_page_va>:
//==================================
//==================================
// [1] GET PAGE VA:
//==================================
__inline__ uint32 to_page_va(struct PageInfoElement *ptrPageInfo)
{
  802352:	55                   	push   %ebp
  802353:	89 e5                	mov    %esp,%ebp
  802355:	83 ec 18             	sub    $0x18,%esp
	if (ptrPageInfo < &pageBlockInfoArr[0] || ptrPageInfo >= &pageBlockInfoArr[DYN_ALLOC_MAX_SIZE/PAGE_SIZE])
  802358:	81 7d 08 60 40 80 00 	cmpl   $0x804060,0x8(%ebp)
  80235f:	72 09                	jb     80236a <to_page_va+0x18>
  802361:	81 7d 08 60 c0 81 00 	cmpl   $0x81c060,0x8(%ebp)
  802368:	72 14                	jb     80237e <to_page_va+0x2c>
			panic("to_page_va called with invalid pageInfoPtr");
  80236a:	83 ec 04             	sub    $0x4,%esp
  80236d:	68 8c 3a 80 00       	push   $0x803a8c
  802372:	6a 15                	push   $0x15
  802374:	68 b7 3a 80 00       	push   $0x803ab7
  802379:	e8 b8 e4 ff ff       	call   800836 <_panic>
	//Get start VA of the page from the corresponding Page Info pointer
	int idxInPageInfoArr = (ptrPageInfo - pageBlockInfoArr);
  80237e:	8b 45 08             	mov    0x8(%ebp),%eax
  802381:	ba 60 40 80 00       	mov    $0x804060,%edx
  802386:	29 d0                	sub    %edx,%eax
  802388:	c1 f8 02             	sar    $0x2,%eax
  80238b:	89 c2                	mov    %eax,%edx
  80238d:	89 d0                	mov    %edx,%eax
  80238f:	c1 e0 02             	shl    $0x2,%eax
  802392:	01 d0                	add    %edx,%eax
  802394:	c1 e0 02             	shl    $0x2,%eax
  802397:	01 d0                	add    %edx,%eax
  802399:	c1 e0 02             	shl    $0x2,%eax
  80239c:	01 d0                	add    %edx,%eax
  80239e:	89 c1                	mov    %eax,%ecx
  8023a0:	c1 e1 08             	shl    $0x8,%ecx
  8023a3:	01 c8                	add    %ecx,%eax
  8023a5:	89 c1                	mov    %eax,%ecx
  8023a7:	c1 e1 10             	shl    $0x10,%ecx
  8023aa:	01 c8                	add    %ecx,%eax
  8023ac:	01 c0                	add    %eax,%eax
  8023ae:	01 d0                	add    %edx,%eax
  8023b0:	89 45 f4             	mov    %eax,-0xc(%ebp)
	return dynAllocStart + (idxInPageInfoArr << PGSHIFT);
  8023b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023b6:	c1 e0 0c             	shl    $0xc,%eax
  8023b9:	89 c2                	mov    %eax,%edx
  8023bb:	a1 68 c0 81 00       	mov    0x81c068,%eax
  8023c0:	01 d0                	add    %edx,%eax
}
  8023c2:	c9                   	leave  
  8023c3:	c3                   	ret    

008023c4 <to_page_info>:

//==================================
// [2] GET PAGE INFO OF PAGE VA:
//==================================
__inline__ struct PageInfoElement * to_page_info(uint32 va)
{
  8023c4:	55                   	push   %ebp
  8023c5:	89 e5                	mov    %esp,%ebp
  8023c7:	83 ec 18             	sub    $0x18,%esp
	int idxInPageInfoArr = (va - dynAllocStart) >> PGSHIFT;
  8023ca:	a1 68 c0 81 00       	mov    0x81c068,%eax
  8023cf:	8b 55 08             	mov    0x8(%ebp),%edx
  8023d2:	29 c2                	sub    %eax,%edx
  8023d4:	89 d0                	mov    %edx,%eax
  8023d6:	c1 e8 0c             	shr    $0xc,%eax
  8023d9:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if (idxInPageInfoArr < 0 || idxInPageInfoArr >= DYN_ALLOC_MAX_SIZE/PAGE_SIZE)
  8023dc:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8023e0:	78 09                	js     8023eb <to_page_info+0x27>
  8023e2:	81 7d f4 ff 1f 00 00 	cmpl   $0x1fff,-0xc(%ebp)
  8023e9:	7e 14                	jle    8023ff <to_page_info+0x3b>
		panic("to_page_info called with invalid pa");
  8023eb:	83 ec 04             	sub    $0x4,%esp
  8023ee:	68 d0 3a 80 00       	push   $0x803ad0
  8023f3:	6a 22                	push   $0x22
  8023f5:	68 b7 3a 80 00       	push   $0x803ab7
  8023fa:	e8 37 e4 ff ff       	call   800836 <_panic>
	return &pageBlockInfoArr[idxInPageInfoArr];
  8023ff:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802402:	89 d0                	mov    %edx,%eax
  802404:	01 c0                	add    %eax,%eax
  802406:	01 d0                	add    %edx,%eax
  802408:	c1 e0 02             	shl    $0x2,%eax
  80240b:	05 60 40 80 00       	add    $0x804060,%eax
}
  802410:	c9                   	leave  
  802411:	c3                   	ret    

00802412 <initialize_dynamic_allocator>:
//==================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================
bool is_initialized = 0;
void initialize_dynamic_allocator(uint32 daStart, uint32 daEnd)
{
  802412:	55                   	push   %ebp
  802413:	89 e5                	mov    %esp,%ebp
  802415:	83 ec 18             	sub    $0x18,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		assert(daEnd <= daStart + DYN_ALLOC_MAX_SIZE);
  802418:	8b 45 08             	mov    0x8(%ebp),%eax
  80241b:	05 00 00 00 02       	add    $0x2000000,%eax
  802420:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802423:	73 16                	jae    80243b <initialize_dynamic_allocator+0x29>
  802425:	68 f4 3a 80 00       	push   $0x803af4
  80242a:	68 1a 3b 80 00       	push   $0x803b1a
  80242f:	6a 34                	push   $0x34
  802431:	68 b7 3a 80 00       	push   $0x803ab7
  802436:	e8 fb e3 ff ff       	call   800836 <_panic>
		is_initialized = 1;
  80243b:	c7 05 28 40 80 00 01 	movl   $0x1,0x804028
  802442:	00 00 00 
	//==================================================================================
	//==================================================================================
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #1 initialize_dynamic_allocator
	//Your code is here
	// init bounds of the dynalloc
	dynAllocStart = daStart;
  802445:	8b 45 08             	mov    0x8(%ebp),%eax
  802448:	a3 68 c0 81 00       	mov    %eax,0x81c068
	dynAllocEnd = daEnd;
  80244d:	8b 45 0c             	mov    0xc(%ebp),%eax
  802450:	a3 40 40 80 00       	mov    %eax,0x804040
	// init the list that keep track of all free pageBlockInfoArr instances.
	LIST_INIT(&freePagesList);
  802455:	c7 05 48 40 80 00 00 	movl   $0x0,0x804048
  80245c:	00 00 00 
  80245f:	c7 05 4c 40 80 00 00 	movl   $0x0,0x80404c
  802466:	00 00 00 
  802469:	c7 05 54 40 80 00 00 	movl   $0x0,0x804054
  802470:	00 00 00 

	// no.of pages in the dynamic allocator.
	int pCount = (daEnd - daStart) / PAGE_SIZE;
  802473:	8b 45 0c             	mov    0xc(%ebp),%eax
  802476:	2b 45 08             	sub    0x8(%ebp),%eax
  802479:	c1 e8 0c             	shr    $0xc,%eax
  80247c:	89 45 ec             	mov    %eax,-0x14(%ebp)
	// iterate over each page and init its data in pageBlockInfoArr and reset it.
	for (int i = 0; i < pCount; ++i) {
  80247f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  802486:	e9 c8 00 00 00       	jmp    802553 <initialize_dynamic_allocator+0x141>
	    pageBlockInfoArr[i].block_size = 0;
  80248b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80248e:	89 d0                	mov    %edx,%eax
  802490:	01 c0                	add    %eax,%eax
  802492:	01 d0                	add    %edx,%eax
  802494:	c1 e0 02             	shl    $0x2,%eax
  802497:	05 68 40 80 00       	add    $0x804068,%eax
  80249c:	66 c7 00 00 00       	movw   $0x0,(%eax)
	    pageBlockInfoArr[i].num_of_free_blocks = 0;
  8024a1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8024a4:	89 d0                	mov    %edx,%eax
  8024a6:	01 c0                	add    %eax,%eax
  8024a8:	01 d0                	add    %edx,%eax
  8024aa:	c1 e0 02             	shl    $0x2,%eax
  8024ad:	05 6a 40 80 00       	add    $0x80406a,%eax
  8024b2:	66 c7 00 00 00       	movw   $0x0,(%eax)
	    LIST_INSERT_TAIL(&freePagesList, &pageBlockInfoArr[i]);
  8024b7:	8b 15 4c 40 80 00    	mov    0x80404c,%edx
  8024bd:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  8024c0:	89 c8                	mov    %ecx,%eax
  8024c2:	01 c0                	add    %eax,%eax
  8024c4:	01 c8                	add    %ecx,%eax
  8024c6:	c1 e0 02             	shl    $0x2,%eax
  8024c9:	05 64 40 80 00       	add    $0x804064,%eax
  8024ce:	89 10                	mov    %edx,(%eax)
  8024d0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8024d3:	89 d0                	mov    %edx,%eax
  8024d5:	01 c0                	add    %eax,%eax
  8024d7:	01 d0                	add    %edx,%eax
  8024d9:	c1 e0 02             	shl    $0x2,%eax
  8024dc:	05 64 40 80 00       	add    $0x804064,%eax
  8024e1:	8b 00                	mov    (%eax),%eax
  8024e3:	85 c0                	test   %eax,%eax
  8024e5:	74 1b                	je     802502 <initialize_dynamic_allocator+0xf0>
  8024e7:	8b 15 4c 40 80 00    	mov    0x80404c,%edx
  8024ed:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  8024f0:	89 c8                	mov    %ecx,%eax
  8024f2:	01 c0                	add    %eax,%eax
  8024f4:	01 c8                	add    %ecx,%eax
  8024f6:	c1 e0 02             	shl    $0x2,%eax
  8024f9:	05 60 40 80 00       	add    $0x804060,%eax
  8024fe:	89 02                	mov    %eax,(%edx)
  802500:	eb 16                	jmp    802518 <initialize_dynamic_allocator+0x106>
  802502:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802505:	89 d0                	mov    %edx,%eax
  802507:	01 c0                	add    %eax,%eax
  802509:	01 d0                	add    %edx,%eax
  80250b:	c1 e0 02             	shl    $0x2,%eax
  80250e:	05 60 40 80 00       	add    $0x804060,%eax
  802513:	a3 48 40 80 00       	mov    %eax,0x804048
  802518:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80251b:	89 d0                	mov    %edx,%eax
  80251d:	01 c0                	add    %eax,%eax
  80251f:	01 d0                	add    %edx,%eax
  802521:	c1 e0 02             	shl    $0x2,%eax
  802524:	05 60 40 80 00       	add    $0x804060,%eax
  802529:	a3 4c 40 80 00       	mov    %eax,0x80404c
  80252e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802531:	89 d0                	mov    %edx,%eax
  802533:	01 c0                	add    %eax,%eax
  802535:	01 d0                	add    %edx,%eax
  802537:	c1 e0 02             	shl    $0x2,%eax
  80253a:	05 60 40 80 00       	add    $0x804060,%eax
  80253f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802545:	a1 54 40 80 00       	mov    0x804054,%eax
  80254a:	40                   	inc    %eax
  80254b:	a3 54 40 80 00       	mov    %eax,0x804054
	LIST_INIT(&freePagesList);

	// no.of pages in the dynamic allocator.
	int pCount = (daEnd - daStart) / PAGE_SIZE;
	// iterate over each page and init its data in pageBlockInfoArr and reset it.
	for (int i = 0; i < pCount; ++i) {
  802550:	ff 45 f4             	incl   -0xc(%ebp)
  802553:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802556:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  802559:	0f 8c 2c ff ff ff    	jl     80248b <initialize_dynamic_allocator+0x79>
	    LIST_INSERT_TAIL(&freePagesList, &pageBlockInfoArr[i]);
	}
	// init the array of lists of each size..
	// 8 16 32 64 128 256 512 1024 2056
	// 0 1  2  3   4  5    6   7    8
	for (int i = 0; i <= (LOG2_MAX_SIZE - LOG2_MIN_SIZE); ++i){
  80255f:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  802566:	eb 36                	jmp    80259e <initialize_dynamic_allocator+0x18c>
		LIST_INIT(&freeBlockLists[i]);
  802568:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80256b:	c1 e0 04             	shl    $0x4,%eax
  80256e:	05 80 c0 81 00       	add    $0x81c080,%eax
  802573:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802579:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80257c:	c1 e0 04             	shl    $0x4,%eax
  80257f:	05 84 c0 81 00       	add    $0x81c084,%eax
  802584:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80258a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80258d:	c1 e0 04             	shl    $0x4,%eax
  802590:	05 8c c0 81 00       	add    $0x81c08c,%eax
  802595:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	    LIST_INSERT_TAIL(&freePagesList, &pageBlockInfoArr[i]);
	}
	// init the array of lists of each size..
	// 8 16 32 64 128 256 512 1024 2056
	// 0 1  2  3   4  5    6   7    8
	for (int i = 0; i <= (LOG2_MAX_SIZE - LOG2_MIN_SIZE); ++i){
  80259b:	ff 45 f0             	incl   -0x10(%ebp)
  80259e:	83 7d f0 08          	cmpl   $0x8,-0x10(%ebp)
  8025a2:	7e c4                	jle    802568 <initialize_dynamic_allocator+0x156>
		LIST_INIT(&freeBlockLists[i]);
	}
	//Comment the following line
	//panic("initialize_dynamic_allocator() Not implemented yet");

}
  8025a4:	90                   	nop
  8025a5:	c9                   	leave  
  8025a6:	c3                   	ret    

008025a7 <get_block_size>:

//===========================
// [2] GET BLOCK SIZE:
//===========================
__inline__ uint32 get_block_size(void *va)
{
  8025a7:	55                   	push   %ebp
  8025a8:	89 e5                	mov    %esp,%ebp
  8025aa:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #2 get_block_size
	//Your code is here
	// get the page that saves this va
	struct PageInfoElement* ptr = to_page_info((uint32)va);
  8025ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8025b0:	83 ec 0c             	sub    $0xc,%esp
  8025b3:	50                   	push   %eax
  8025b4:	e8 0b fe ff ff       	call   8023c4 <to_page_info>
  8025b9:	83 c4 10             	add    $0x10,%esp
  8025bc:	89 45 f4             	mov    %eax,-0xc(%ebp)
	return ptr->block_size;
  8025bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025c2:	8b 40 08             	mov    0x8(%eax),%eax
  8025c5:	0f b7 c0             	movzwl %ax,%eax
	//Comment the following line
	//panic("get_block_size() Not implemented yet");
}
  8025c8:	c9                   	leave  
  8025c9:	c3                   	ret    

008025ca <split_page_to_blocks>:
// =====================
// h) split page to blocks and add them in freeBlockLists
// =====================
// function that split the page provided into same sized blocks
//and putem in suitable freeblockList index according to size.
 void split_page_to_blocks(uint32 blk_size, struct PageInfoElement *pageInfo) {
  8025ca:	55                   	push   %ebp
  8025cb:	89 e5                	mov    %esp,%ebp
  8025cd:	83 ec 28             	sub    $0x28,%esp
	 // cur page virtual address by the pageInfo.
	 uint32 page_va = (uint32)to_page_va(pageInfo);
  8025d0:	83 ec 0c             	sub    $0xc,%esp
  8025d3:	ff 75 0c             	pushl  0xc(%ebp)
  8025d6:	e8 77 fd ff ff       	call   802352 <to_page_va>
  8025db:	83 c4 10             	add    $0x10,%esp
  8025de:	89 45 e8             	mov    %eax,-0x18(%ebp)
	 // no. of blks to save in freeblockList.
	 int blk_count = PAGE_SIZE / blk_size;
  8025e1:	b8 00 10 00 00       	mov    $0x1000,%eax
  8025e6:	ba 00 00 00 00       	mov    $0x0,%edx
  8025eb:	f7 75 08             	divl   0x8(%ebp)
  8025ee:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	 // save page in memory.
	 get_page((uint32*)page_va);
  8025f1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8025f4:	83 ec 0c             	sub    $0xc,%esp
  8025f7:	50                   	push   %eax
  8025f8:	e8 48 f6 ff ff       	call   801c45 <get_page>
  8025fd:	83 c4 10             	add    $0x10,%esp
	 // assigning the pageInfo data block size, free block which is whole block count.
	 pageInfo->num_of_free_blocks = blk_count;
  802600:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802603:	8b 55 0c             	mov    0xc(%ebp),%edx
  802606:	66 89 42 0a          	mov    %ax,0xa(%edx)
	 pageInfo->block_size = blk_size;
  80260a:	8b 45 08             	mov    0x8(%ebp),%eax
  80260d:	8b 55 0c             	mov    0xc(%ebp),%edx
  802610:	66 89 42 08          	mov    %ax,0x8(%edx)
	 // get index by size block in freeblocklist.
	 int idx = 0;
  802614:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	 for (int i = LOG2_MIN_SIZE; i <= LOG2_MAX_SIZE; i++) {
  80261b:	c7 45 f0 03 00 00 00 	movl   $0x3,-0x10(%ebp)
  802622:	eb 19                	jmp    80263d <split_page_to_blocks+0x73>
	     if ((1 << i) == blk_size)
  802624:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802627:	ba 01 00 00 00       	mov    $0x1,%edx
  80262c:	88 c1                	mov    %al,%cl
  80262e:	d3 e2                	shl    %cl,%edx
  802630:	89 d0                	mov    %edx,%eax
  802632:	3b 45 08             	cmp    0x8(%ebp),%eax
  802635:	74 0e                	je     802645 <split_page_to_blocks+0x7b>
	         break;
	     idx++;
  802637:	ff 45 f4             	incl   -0xc(%ebp)
	 // assigning the pageInfo data block size, free block which is whole block count.
	 pageInfo->num_of_free_blocks = blk_count;
	 pageInfo->block_size = blk_size;
	 // get index by size block in freeblocklist.
	 int idx = 0;
	 for (int i = LOG2_MIN_SIZE; i <= LOG2_MAX_SIZE; i++) {
  80263a:	ff 45 f0             	incl   -0x10(%ebp)
  80263d:	83 7d f0 0b          	cmpl   $0xb,-0x10(%ebp)
  802641:	7e e1                	jle    802624 <split_page_to_blocks+0x5a>
  802643:	eb 01                	jmp    802646 <split_page_to_blocks+0x7c>
	     if ((1 << i) == blk_size)
	         break;
  802645:	90                   	nop
	     idx++;
	 }
	 // iterate over each blk and make and element of it by passing its address in blockElement pointer and save those in the list.
	 // starting from the page_va.
	 for (uint32 i = 0; i < blk_count; ++i) {
  802646:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  80264d:	e9 a7 00 00 00       	jmp    8026f9 <split_page_to_blocks+0x12f>
	     struct BlockElement *blk =(struct BlockElement*)(page_va + i * blk_size);
  802652:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802655:	0f af 45 08          	imul   0x8(%ebp),%eax
  802659:	89 c2                	mov    %eax,%edx
  80265b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80265e:	01 d0                	add    %edx,%eax
  802660:	89 45 e0             	mov    %eax,-0x20(%ebp)
	     LIST_INSERT_TAIL(&freeBlockLists[idx],blk);
  802663:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  802667:	75 14                	jne    80267d <split_page_to_blocks+0xb3>
  802669:	83 ec 04             	sub    $0x4,%esp
  80266c:	68 30 3b 80 00       	push   $0x803b30
  802671:	6a 7c                	push   $0x7c
  802673:	68 b7 3a 80 00       	push   $0x803ab7
  802678:	e8 b9 e1 ff ff       	call   800836 <_panic>
  80267d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802680:	c1 e0 04             	shl    $0x4,%eax
  802683:	05 84 c0 81 00       	add    $0x81c084,%eax
  802688:	8b 10                	mov    (%eax),%edx
  80268a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80268d:	89 50 04             	mov    %edx,0x4(%eax)
  802690:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802693:	8b 40 04             	mov    0x4(%eax),%eax
  802696:	85 c0                	test   %eax,%eax
  802698:	74 14                	je     8026ae <split_page_to_blocks+0xe4>
  80269a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80269d:	c1 e0 04             	shl    $0x4,%eax
  8026a0:	05 84 c0 81 00       	add    $0x81c084,%eax
  8026a5:	8b 00                	mov    (%eax),%eax
  8026a7:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8026aa:	89 10                	mov    %edx,(%eax)
  8026ac:	eb 11                	jmp    8026bf <split_page_to_blocks+0xf5>
  8026ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026b1:	c1 e0 04             	shl    $0x4,%eax
  8026b4:	8d 90 80 c0 81 00    	lea    0x81c080(%eax),%edx
  8026ba:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8026bd:	89 02                	mov    %eax,(%edx)
  8026bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026c2:	c1 e0 04             	shl    $0x4,%eax
  8026c5:	8d 90 84 c0 81 00    	lea    0x81c084(%eax),%edx
  8026cb:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8026ce:	89 02                	mov    %eax,(%edx)
  8026d0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8026d3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8026d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026dc:	c1 e0 04             	shl    $0x4,%eax
  8026df:	05 8c c0 81 00       	add    $0x81c08c,%eax
  8026e4:	8b 00                	mov    (%eax),%eax
  8026e6:	8d 50 01             	lea    0x1(%eax),%edx
  8026e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026ec:	c1 e0 04             	shl    $0x4,%eax
  8026ef:	05 8c c0 81 00       	add    $0x81c08c,%eax
  8026f4:	89 10                	mov    %edx,(%eax)
	         break;
	     idx++;
	 }
	 // iterate over each blk and make and element of it by passing its address in blockElement pointer and save those in the list.
	 // starting from the page_va.
	 for (uint32 i = 0; i < blk_count; ++i) {
  8026f6:	ff 45 ec             	incl   -0x14(%ebp)
  8026f9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8026fc:	39 45 ec             	cmp    %eax,-0x14(%ebp)
  8026ff:	0f 82 4d ff ff ff    	jb     802652 <split_page_to_blocks+0x88>
	     struct BlockElement *blk =(struct BlockElement*)(page_va + i * blk_size);
	     LIST_INSERT_TAIL(&freeBlockLists[idx],blk);
	 }
 }
  802705:	90                   	nop
  802706:	c9                   	leave  
  802707:	c3                   	ret    

00802708 <alloc_block>:

//===========================
// 3) ALLOCATE BLOCK:
//===========================
void *alloc_block(uint32 size)
{
  802708:	55                   	push   %ebp
  802709:	89 e5                	mov    %esp,%ebp
  80270b:	83 ec 38             	sub    $0x38,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		assert(size <= DYN_ALLOC_MAX_BLOCK_SIZE);
  80270e:	81 7d 08 00 08 00 00 	cmpl   $0x800,0x8(%ebp)
  802715:	76 19                	jbe    802730 <alloc_block+0x28>
  802717:	68 54 3b 80 00       	push   $0x803b54
  80271c:	68 1a 3b 80 00       	push   $0x803b1a
  802721:	68 8a 00 00 00       	push   $0x8a
  802726:	68 b7 3a 80 00       	push   $0x803ab7
  80272b:	e8 06 e1 ff ff       	call   800836 <_panic>
	//==================================================================================
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #3 alloc_block
	//Your code is here
	//Comment the following line
	// get index in freeBlockList by size.
	uint32 idx = 0;
  802730:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int i = LOG2_MIN_SIZE; i <= LOG2_MAX_SIZE; ++i){
  802737:	c7 45 f0 03 00 00 00 	movl   $0x3,-0x10(%ebp)
  80273e:	eb 19                	jmp    802759 <alloc_block+0x51>
		if((1 << i) >= size) break;
  802740:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802743:	ba 01 00 00 00       	mov    $0x1,%edx
  802748:	88 c1                	mov    %al,%cl
  80274a:	d3 e2                	shl    %cl,%edx
  80274c:	89 d0                	mov    %edx,%eax
  80274e:	3b 45 08             	cmp    0x8(%ebp),%eax
  802751:	73 0e                	jae    802761 <alloc_block+0x59>
		idx++;
  802753:	ff 45 f4             	incl   -0xc(%ebp)
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #3 alloc_block
	//Your code is here
	//Comment the following line
	// get index in freeBlockList by size.
	uint32 idx = 0;
	for (int i = LOG2_MIN_SIZE; i <= LOG2_MAX_SIZE; ++i){
  802756:	ff 45 f0             	incl   -0x10(%ebp)
  802759:	83 7d f0 0b          	cmpl   $0xb,-0x10(%ebp)
  80275d:	7e e1                	jle    802740 <alloc_block+0x38>
  80275f:	eb 01                	jmp    802762 <alloc_block+0x5a>
		if((1 << i) >= size) break;
  802761:	90                   	nop
		idx++;
	}

	//case 1: the free block of the cur size is available.
	if (freeBlockLists[idx].size > 0) {
  802762:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802765:	c1 e0 04             	shl    $0x4,%eax
  802768:	05 8c c0 81 00       	add    $0x81c08c,%eax
  80276d:	8b 00                	mov    (%eax),%eax
  80276f:	85 c0                	test   %eax,%eax
  802771:	0f 84 df 00 00 00    	je     802856 <alloc_block+0x14e>

		// remove from the list and updat the pageInfoArr free blocks.
		// pop from the freeBlockList.
		struct BlockElement *blk = LIST_FIRST(&freeBlockLists[idx]);
  802777:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80277a:	c1 e0 04             	shl    $0x4,%eax
  80277d:	05 80 c0 81 00       	add    $0x81c080,%eax
  802782:	8b 00                	mov    (%eax),%eax
  802784:	89 45 ec             	mov    %eax,-0x14(%ebp)
	    LIST_REMOVE(&freeBlockLists[idx], blk);
  802787:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80278b:	75 17                	jne    8027a4 <alloc_block+0x9c>
  80278d:	83 ec 04             	sub    $0x4,%esp
  802790:	68 75 3b 80 00       	push   $0x803b75
  802795:	68 9e 00 00 00       	push   $0x9e
  80279a:	68 b7 3a 80 00       	push   $0x803ab7
  80279f:	e8 92 e0 ff ff       	call   800836 <_panic>
  8027a4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8027a7:	8b 00                	mov    (%eax),%eax
  8027a9:	85 c0                	test   %eax,%eax
  8027ab:	74 10                	je     8027bd <alloc_block+0xb5>
  8027ad:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8027b0:	8b 00                	mov    (%eax),%eax
  8027b2:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8027b5:	8b 52 04             	mov    0x4(%edx),%edx
  8027b8:	89 50 04             	mov    %edx,0x4(%eax)
  8027bb:	eb 14                	jmp    8027d1 <alloc_block+0xc9>
  8027bd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8027c0:	8b 40 04             	mov    0x4(%eax),%eax
  8027c3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8027c6:	c1 e2 04             	shl    $0x4,%edx
  8027c9:	81 c2 84 c0 81 00    	add    $0x81c084,%edx
  8027cf:	89 02                	mov    %eax,(%edx)
  8027d1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8027d4:	8b 40 04             	mov    0x4(%eax),%eax
  8027d7:	85 c0                	test   %eax,%eax
  8027d9:	74 0f                	je     8027ea <alloc_block+0xe2>
  8027db:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8027de:	8b 40 04             	mov    0x4(%eax),%eax
  8027e1:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8027e4:	8b 12                	mov    (%edx),%edx
  8027e6:	89 10                	mov    %edx,(%eax)
  8027e8:	eb 13                	jmp    8027fd <alloc_block+0xf5>
  8027ea:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8027ed:	8b 00                	mov    (%eax),%eax
  8027ef:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8027f2:	c1 e2 04             	shl    $0x4,%edx
  8027f5:	81 c2 80 c0 81 00    	add    $0x81c080,%edx
  8027fb:	89 02                	mov    %eax,(%edx)
  8027fd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802800:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802806:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802809:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802810:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802813:	c1 e0 04             	shl    $0x4,%eax
  802816:	05 8c c0 81 00       	add    $0x81c08c,%eax
  80281b:	8b 00                	mov    (%eax),%eax
  80281d:	8d 50 ff             	lea    -0x1(%eax),%edx
  802820:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802823:	c1 e0 04             	shl    $0x4,%eax
  802826:	05 8c c0 81 00       	add    $0x81c08c,%eax
  80282b:	89 10                	mov    %edx,(%eax)
	    // update pageBlockInfoArr
	    struct PageInfoElement *pageInfo = to_page_info((uint32)blk);
  80282d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802830:	83 ec 0c             	sub    $0xc,%esp
  802833:	50                   	push   %eax
  802834:	e8 8b fb ff ff       	call   8023c4 <to_page_info>
  802839:	83 c4 10             	add    $0x10,%esp
  80283c:	89 45 e8             	mov    %eax,-0x18(%ebp)
	    pageInfo->num_of_free_blocks--;
  80283f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802842:	66 8b 40 0a          	mov    0xa(%eax),%ax
  802846:	48                   	dec    %eax
  802847:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80284a:	66 89 42 0a          	mov    %ax,0xa(%edx)
	    return blk;
  80284e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802851:	e9 bc 02 00 00       	jmp    802b12 <alloc_block+0x40a>
	}else{ //case(2, 3): 2. no free blocks available in the freeblocklist but there is free pages.
				//3. no free blocks and no available freepages so search in higher block sizes.
		// case 2:
		if(freePagesList.size > 0){ //have free pages.
  802856:	a1 54 40 80 00       	mov    0x804054,%eax
  80285b:	85 c0                	test   %eax,%eax
  80285d:	0f 84 7d 02 00 00    	je     802ae0 <alloc_block+0x3d8>
			// get page to split and use from freepagesList.
			struct PageInfoElement *ptr_new_page = LIST_FIRST(&freePagesList);
  802863:	a1 48 40 80 00       	mov    0x804048,%eax
  802868:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			LIST_REMOVE(&freePagesList, ptr_new_page);
  80286b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80286f:	75 17                	jne    802888 <alloc_block+0x180>
  802871:	83 ec 04             	sub    $0x4,%esp
  802874:	68 75 3b 80 00       	push   $0x803b75
  802879:	68 a9 00 00 00       	push   $0xa9
  80287e:	68 b7 3a 80 00       	push   $0x803ab7
  802883:	e8 ae df ff ff       	call   800836 <_panic>
  802888:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80288b:	8b 00                	mov    (%eax),%eax
  80288d:	85 c0                	test   %eax,%eax
  80288f:	74 10                	je     8028a1 <alloc_block+0x199>
  802891:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802894:	8b 00                	mov    (%eax),%eax
  802896:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802899:	8b 52 04             	mov    0x4(%edx),%edx
  80289c:	89 50 04             	mov    %edx,0x4(%eax)
  80289f:	eb 0b                	jmp    8028ac <alloc_block+0x1a4>
  8028a1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8028a4:	8b 40 04             	mov    0x4(%eax),%eax
  8028a7:	a3 4c 40 80 00       	mov    %eax,0x80404c
  8028ac:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8028af:	8b 40 04             	mov    0x4(%eax),%eax
  8028b2:	85 c0                	test   %eax,%eax
  8028b4:	74 0f                	je     8028c5 <alloc_block+0x1bd>
  8028b6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8028b9:	8b 40 04             	mov    0x4(%eax),%eax
  8028bc:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8028bf:	8b 12                	mov    (%edx),%edx
  8028c1:	89 10                	mov    %edx,(%eax)
  8028c3:	eb 0a                	jmp    8028cf <alloc_block+0x1c7>
  8028c5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8028c8:	8b 00                	mov    (%eax),%eax
  8028ca:	a3 48 40 80 00       	mov    %eax,0x804048
  8028cf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8028d2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8028d8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8028db:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8028e2:	a1 54 40 80 00       	mov    0x804054,%eax
  8028e7:	48                   	dec    %eax
  8028e8:	a3 54 40 80 00       	mov    %eax,0x804054
			// from page to freeblockList by the pageInfo and the block size.
			split_page_to_blocks(1 << (idx + LOG2_MIN_SIZE), ptr_new_page);
  8028ed:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028f0:	83 c0 03             	add    $0x3,%eax
  8028f3:	ba 01 00 00 00       	mov    $0x1,%edx
  8028f8:	88 c1                	mov    %al,%cl
  8028fa:	d3 e2                	shl    %cl,%edx
  8028fc:	89 d0                	mov    %edx,%eax
  8028fe:	83 ec 08             	sub    $0x8,%esp
  802901:	ff 75 e4             	pushl  -0x1c(%ebp)
  802904:	50                   	push   %eax
  802905:	e8 c0 fc ff ff       	call   8025ca <split_page_to_blocks>
  80290a:	83 c4 10             	add    $0x10,%esp

			// remove from the list and updat the pageInfoArr free blocks.
			// pop from the freeBlockList.
			struct BlockElement *blk = LIST_FIRST(&freeBlockLists[idx]);
  80290d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802910:	c1 e0 04             	shl    $0x4,%eax
  802913:	05 80 c0 81 00       	add    $0x81c080,%eax
  802918:	8b 00                	mov    (%eax),%eax
  80291a:	89 45 e0             	mov    %eax,-0x20(%ebp)
		    LIST_REMOVE(&freeBlockLists[idx], blk);
  80291d:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  802921:	75 17                	jne    80293a <alloc_block+0x232>
  802923:	83 ec 04             	sub    $0x4,%esp
  802926:	68 75 3b 80 00       	push   $0x803b75
  80292b:	68 b0 00 00 00       	push   $0xb0
  802930:	68 b7 3a 80 00       	push   $0x803ab7
  802935:	e8 fc de ff ff       	call   800836 <_panic>
  80293a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80293d:	8b 00                	mov    (%eax),%eax
  80293f:	85 c0                	test   %eax,%eax
  802941:	74 10                	je     802953 <alloc_block+0x24b>
  802943:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802946:	8b 00                	mov    (%eax),%eax
  802948:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80294b:	8b 52 04             	mov    0x4(%edx),%edx
  80294e:	89 50 04             	mov    %edx,0x4(%eax)
  802951:	eb 14                	jmp    802967 <alloc_block+0x25f>
  802953:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802956:	8b 40 04             	mov    0x4(%eax),%eax
  802959:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80295c:	c1 e2 04             	shl    $0x4,%edx
  80295f:	81 c2 84 c0 81 00    	add    $0x81c084,%edx
  802965:	89 02                	mov    %eax,(%edx)
  802967:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80296a:	8b 40 04             	mov    0x4(%eax),%eax
  80296d:	85 c0                	test   %eax,%eax
  80296f:	74 0f                	je     802980 <alloc_block+0x278>
  802971:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802974:	8b 40 04             	mov    0x4(%eax),%eax
  802977:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80297a:	8b 12                	mov    (%edx),%edx
  80297c:	89 10                	mov    %edx,(%eax)
  80297e:	eb 13                	jmp    802993 <alloc_block+0x28b>
  802980:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802983:	8b 00                	mov    (%eax),%eax
  802985:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802988:	c1 e2 04             	shl    $0x4,%edx
  80298b:	81 c2 80 c0 81 00    	add    $0x81c080,%edx
  802991:	89 02                	mov    %eax,(%edx)
  802993:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802996:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80299c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80299f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8029a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029a9:	c1 e0 04             	shl    $0x4,%eax
  8029ac:	05 8c c0 81 00       	add    $0x81c08c,%eax
  8029b1:	8b 00                	mov    (%eax),%eax
  8029b3:	8d 50 ff             	lea    -0x1(%eax),%edx
  8029b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029b9:	c1 e0 04             	shl    $0x4,%eax
  8029bc:	05 8c c0 81 00       	add    $0x81c08c,%eax
  8029c1:	89 10                	mov    %edx,(%eax)
		    // update pageBlockInfoArr
		    struct PageInfoElement *pageInfo = to_page_info((uint32)blk);
  8029c3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8029c6:	83 ec 0c             	sub    $0xc,%esp
  8029c9:	50                   	push   %eax
  8029ca:	e8 f5 f9 ff ff       	call   8023c4 <to_page_info>
  8029cf:	83 c4 10             	add    $0x10,%esp
  8029d2:	89 45 dc             	mov    %eax,-0x24(%ebp)
		    pageInfo->num_of_free_blocks--;
  8029d5:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8029d8:	66 8b 40 0a          	mov    0xa(%eax),%ax
  8029dc:	48                   	dec    %eax
  8029dd:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8029e0:	66 89 42 0a          	mov    %ax,0xa(%edx)
		    return blk;
  8029e4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8029e7:	e9 26 01 00 00       	jmp    802b12 <alloc_block+0x40a>
		}else{//case 3: no free block and no free page so iterate and try to find bigger size.
			// iterate over the list until finding available block
			while (idx <= (LOG2_MAX_SIZE - LOG2_MIN_SIZE) && freeBlockLists[idx].size == 0) {
				idx++;
  8029ec:	ff 45 f4             	incl   -0xc(%ebp)
				// found free block
				if(freeBlockLists[idx].size > 0){
  8029ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029f2:	c1 e0 04             	shl    $0x4,%eax
  8029f5:	05 8c c0 81 00       	add    $0x81c08c,%eax
  8029fa:	8b 00                	mov    (%eax),%eax
  8029fc:	85 c0                	test   %eax,%eax
  8029fe:	0f 84 dc 00 00 00    	je     802ae0 <alloc_block+0x3d8>
					// remove from the list and updat the pageInfoArr free blocks.
					// pop from the freeBlockList.
					struct BlockElement *blk = LIST_FIRST(&freeBlockLists[idx]);
  802a04:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a07:	c1 e0 04             	shl    $0x4,%eax
  802a0a:	05 80 c0 81 00       	add    $0x81c080,%eax
  802a0f:	8b 00                	mov    (%eax),%eax
  802a11:	89 45 d8             	mov    %eax,-0x28(%ebp)
				    LIST_REMOVE(&freeBlockLists[idx], blk);
  802a14:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  802a18:	75 17                	jne    802a31 <alloc_block+0x329>
  802a1a:	83 ec 04             	sub    $0x4,%esp
  802a1d:	68 75 3b 80 00       	push   $0x803b75
  802a22:	68 be 00 00 00       	push   $0xbe
  802a27:	68 b7 3a 80 00       	push   $0x803ab7
  802a2c:	e8 05 de ff ff       	call   800836 <_panic>
  802a31:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802a34:	8b 00                	mov    (%eax),%eax
  802a36:	85 c0                	test   %eax,%eax
  802a38:	74 10                	je     802a4a <alloc_block+0x342>
  802a3a:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802a3d:	8b 00                	mov    (%eax),%eax
  802a3f:	8b 55 d8             	mov    -0x28(%ebp),%edx
  802a42:	8b 52 04             	mov    0x4(%edx),%edx
  802a45:	89 50 04             	mov    %edx,0x4(%eax)
  802a48:	eb 14                	jmp    802a5e <alloc_block+0x356>
  802a4a:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802a4d:	8b 40 04             	mov    0x4(%eax),%eax
  802a50:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802a53:	c1 e2 04             	shl    $0x4,%edx
  802a56:	81 c2 84 c0 81 00    	add    $0x81c084,%edx
  802a5c:	89 02                	mov    %eax,(%edx)
  802a5e:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802a61:	8b 40 04             	mov    0x4(%eax),%eax
  802a64:	85 c0                	test   %eax,%eax
  802a66:	74 0f                	je     802a77 <alloc_block+0x36f>
  802a68:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802a6b:	8b 40 04             	mov    0x4(%eax),%eax
  802a6e:	8b 55 d8             	mov    -0x28(%ebp),%edx
  802a71:	8b 12                	mov    (%edx),%edx
  802a73:	89 10                	mov    %edx,(%eax)
  802a75:	eb 13                	jmp    802a8a <alloc_block+0x382>
  802a77:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802a7a:	8b 00                	mov    (%eax),%eax
  802a7c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802a7f:	c1 e2 04             	shl    $0x4,%edx
  802a82:	81 c2 80 c0 81 00    	add    $0x81c080,%edx
  802a88:	89 02                	mov    %eax,(%edx)
  802a8a:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802a8d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802a93:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802a96:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802a9d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802aa0:	c1 e0 04             	shl    $0x4,%eax
  802aa3:	05 8c c0 81 00       	add    $0x81c08c,%eax
  802aa8:	8b 00                	mov    (%eax),%eax
  802aaa:	8d 50 ff             	lea    -0x1(%eax),%edx
  802aad:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ab0:	c1 e0 04             	shl    $0x4,%eax
  802ab3:	05 8c c0 81 00       	add    $0x81c08c,%eax
  802ab8:	89 10                	mov    %edx,(%eax)
				    // update pageBlockInfoArr
				    struct PageInfoElement *pageInfo = to_page_info((uint32)blk);
  802aba:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802abd:	83 ec 0c             	sub    $0xc,%esp
  802ac0:	50                   	push   %eax
  802ac1:	e8 fe f8 ff ff       	call   8023c4 <to_page_info>
  802ac6:	83 c4 10             	add    $0x10,%esp
  802ac9:	89 45 d4             	mov    %eax,-0x2c(%ebp)
				    pageInfo->num_of_free_blocks--;
  802acc:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802acf:	66 8b 40 0a          	mov    0xa(%eax),%ax
  802ad3:	48                   	dec    %eax
  802ad4:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  802ad7:	66 89 42 0a          	mov    %ax,0xa(%edx)
				    return blk;
  802adb:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802ade:	eb 32                	jmp    802b12 <alloc_block+0x40a>
		    struct PageInfoElement *pageInfo = to_page_info((uint32)blk);
		    pageInfo->num_of_free_blocks--;
		    return blk;
		}else{//case 3: no free block and no free page so iterate and try to find bigger size.
			// iterate over the list until finding available block
			while (idx <= (LOG2_MAX_SIZE - LOG2_MIN_SIZE) && freeBlockLists[idx].size == 0) {
  802ae0:	83 7d f4 08          	cmpl   $0x8,-0xc(%ebp)
  802ae4:	77 15                	ja     802afb <alloc_block+0x3f3>
  802ae6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ae9:	c1 e0 04             	shl    $0x4,%eax
  802aec:	05 8c c0 81 00       	add    $0x81c08c,%eax
  802af1:	8b 00                	mov    (%eax),%eax
  802af3:	85 c0                	test   %eax,%eax
  802af5:	0f 84 f1 fe ff ff    	je     8029ec <alloc_block+0x2e4>
				}
			}
		}
	}
	//case4: no free blocks or pages.
	panic("no free blocks!");
  802afb:	83 ec 04             	sub    $0x4,%esp
  802afe:	68 93 3b 80 00       	push   $0x803b93
  802b03:	68 c8 00 00 00       	push   $0xc8
  802b08:	68 b7 3a 80 00       	push   $0x803ab7
  802b0d:	e8 24 dd ff ff       	call   800836 <_panic>
	//panic("alloc_block() Not implemented yet");
	//TODO: [PROJECT'25.BONUS#1] DYNAMIC ALLOCATOR - block if no free block
	return NULL;
}
  802b12:	c9                   	leave  
  802b13:	c3                   	ret    

00802b14 <free_block>:

//===========================
// [4] FREE BLOCK:
//===========================
void free_block(void *va)
{
  802b14:	55                   	push   %ebp
  802b15:	89 e5                	mov    %esp,%ebp
  802b17:	83 ec 38             	sub    $0x38,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		assert((uint32)va >= dynAllocStart && (uint32)va < dynAllocEnd);
  802b1a:	8b 55 08             	mov    0x8(%ebp),%edx
  802b1d:	a1 68 c0 81 00       	mov    0x81c068,%eax
  802b22:	39 c2                	cmp    %eax,%edx
  802b24:	72 0c                	jb     802b32 <free_block+0x1e>
  802b26:	8b 55 08             	mov    0x8(%ebp),%edx
  802b29:	a1 40 40 80 00       	mov    0x804040,%eax
  802b2e:	39 c2                	cmp    %eax,%edx
  802b30:	72 19                	jb     802b4b <free_block+0x37>
  802b32:	68 a4 3b 80 00       	push   $0x803ba4
  802b37:	68 1a 3b 80 00       	push   $0x803b1a
  802b3c:	68 d7 00 00 00       	push   $0xd7
  802b41:	68 b7 3a 80 00       	push   $0x803ab7
  802b46:	e8 eb dc ff ff       	call   800836 <_panic>
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #4 free_block
	//Your code is here
	//Comment the following line
	// va of a piece in memory to free so:
	// 1. get its page, and make blk with this address to be put in the freeBlockList.
	struct BlockElement* blk_to_free = (struct BlockElement*)va;
  802b4b:	8b 45 08             	mov    0x8(%ebp),%eax
  802b4e:	89 45 e8             	mov    %eax,-0x18(%ebp)
	struct PageInfoElement *pageInfo = to_page_info((uint32)va);
  802b51:	8b 45 08             	mov    0x8(%ebp),%eax
  802b54:	83 ec 0c             	sub    $0xc,%esp
  802b57:	50                   	push   %eax
  802b58:	e8 67 f8 ff ff       	call   8023c4 <to_page_info>
  802b5d:	83 c4 10             	add    $0x10,%esp
  802b60:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	uint32 blk_size = pageInfo->block_size;
  802b63:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802b66:	8b 40 08             	mov    0x8(%eax),%eax
  802b69:	0f b7 c0             	movzwl %ax,%eax
  802b6c:	89 45 e0             	mov    %eax,-0x20(%ebp)

	// its index in the freeBlocklist.
	int idx = 0;
  802b6f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int i = LOG2_MIN_SIZE; i <= LOG2_MAX_SIZE; i++) {
  802b76:	c7 45 f0 03 00 00 00 	movl   $0x3,-0x10(%ebp)
  802b7d:	eb 19                	jmp    802b98 <free_block+0x84>
	    if ((1 << i) == blk_size)
  802b7f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b82:	ba 01 00 00 00       	mov    $0x1,%edx
  802b87:	88 c1                	mov    %al,%cl
  802b89:	d3 e2                	shl    %cl,%edx
  802b8b:	89 d0                	mov    %edx,%eax
  802b8d:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  802b90:	74 0e                	je     802ba0 <free_block+0x8c>
	        break;
	    idx++;
  802b92:	ff 45 f4             	incl   -0xc(%ebp)
	struct PageInfoElement *pageInfo = to_page_info((uint32)va);
	uint32 blk_size = pageInfo->block_size;

	// its index in the freeBlocklist.
	int idx = 0;
	for (int i = LOG2_MIN_SIZE; i <= LOG2_MAX_SIZE; i++) {
  802b95:	ff 45 f0             	incl   -0x10(%ebp)
  802b98:	83 7d f0 0b          	cmpl   $0xb,-0x10(%ebp)
  802b9c:	7e e1                	jle    802b7f <free_block+0x6b>
  802b9e:	eb 01                	jmp    802ba1 <free_block+0x8d>
	    if ((1 << i) == blk_size)
	        break;
  802ba0:	90                   	nop
	    idx++;
	}

	pageInfo->num_of_free_blocks++;
  802ba1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802ba4:	66 8b 40 0a          	mov    0xa(%eax),%ax
  802ba8:	40                   	inc    %eax
  802ba9:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802bac:	66 89 42 0a          	mov    %ax,0xa(%edx)
	LIST_INSERT_TAIL(&freeBlockLists[idx], blk_to_free);
  802bb0:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802bb4:	75 17                	jne    802bcd <free_block+0xb9>
  802bb6:	83 ec 04             	sub    $0x4,%esp
  802bb9:	68 30 3b 80 00       	push   $0x803b30
  802bbe:	68 ee 00 00 00       	push   $0xee
  802bc3:	68 b7 3a 80 00       	push   $0x803ab7
  802bc8:	e8 69 dc ff ff       	call   800836 <_panic>
  802bcd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bd0:	c1 e0 04             	shl    $0x4,%eax
  802bd3:	05 84 c0 81 00       	add    $0x81c084,%eax
  802bd8:	8b 10                	mov    (%eax),%edx
  802bda:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802bdd:	89 50 04             	mov    %edx,0x4(%eax)
  802be0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802be3:	8b 40 04             	mov    0x4(%eax),%eax
  802be6:	85 c0                	test   %eax,%eax
  802be8:	74 14                	je     802bfe <free_block+0xea>
  802bea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bed:	c1 e0 04             	shl    $0x4,%eax
  802bf0:	05 84 c0 81 00       	add    $0x81c084,%eax
  802bf5:	8b 00                	mov    (%eax),%eax
  802bf7:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802bfa:	89 10                	mov    %edx,(%eax)
  802bfc:	eb 11                	jmp    802c0f <free_block+0xfb>
  802bfe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c01:	c1 e0 04             	shl    $0x4,%eax
  802c04:	8d 90 80 c0 81 00    	lea    0x81c080(%eax),%edx
  802c0a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802c0d:	89 02                	mov    %eax,(%edx)
  802c0f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c12:	c1 e0 04             	shl    $0x4,%eax
  802c15:	8d 90 84 c0 81 00    	lea    0x81c084(%eax),%edx
  802c1b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802c1e:	89 02                	mov    %eax,(%edx)
  802c20:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802c23:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802c29:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c2c:	c1 e0 04             	shl    $0x4,%eax
  802c2f:	05 8c c0 81 00       	add    $0x81c08c,%eax
  802c34:	8b 00                	mov    (%eax),%eax
  802c36:	8d 50 01             	lea    0x1(%eax),%edx
  802c39:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c3c:	c1 e0 04             	shl    $0x4,%eax
  802c3f:	05 8c c0 81 00       	add    $0x81c08c,%eax
  802c44:	89 10                	mov    %edx,(%eax)

	// now, case 1: the page all blocks are freed so you free the page.
	int blk_count = PAGE_SIZE / blk_size;
  802c46:	b8 00 10 00 00       	mov    $0x1000,%eax
  802c4b:	ba 00 00 00 00       	mov    $0x0,%edx
  802c50:	f7 75 e0             	divl   -0x20(%ebp)
  802c53:	89 45 dc             	mov    %eax,-0x24(%ebp)
	// the blk count in the page is same as number fo free blocks free up the page.
	if (pageInfo->num_of_free_blocks == blk_count) {
  802c56:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802c59:	66 8b 40 0a          	mov    0xa(%eax),%ax
  802c5d:	0f b7 c0             	movzwl %ax,%eax
  802c60:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  802c63:	0f 85 70 01 00 00    	jne    802dd9 <free_block+0x2c5>
		uint32 page_va = to_page_va(pageInfo);
  802c69:	83 ec 0c             	sub    $0xc,%esp
  802c6c:	ff 75 e4             	pushl  -0x1c(%ebp)
  802c6f:	e8 de f6 ff ff       	call   802352 <to_page_va>
  802c74:	83 c4 10             	add    $0x10,%esp
  802c77:	89 45 d8             	mov    %eax,-0x28(%ebp)
		// remove all blk in the freeBlockList.
		for (uint32 off = 0; off < PAGE_SIZE; off += blk_size) {
  802c7a:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  802c81:	e9 b7 00 00 00       	jmp    802d3d <free_block+0x229>
			struct BlockElement *blk = (struct BlockElement*)(page_va + off);
  802c86:	8b 55 d8             	mov    -0x28(%ebp),%edx
  802c89:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c8c:	01 d0                	add    %edx,%eax
  802c8e:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			LIST_REMOVE(&freeBlockLists[idx], blk);
  802c91:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  802c95:	75 17                	jne    802cae <free_block+0x19a>
  802c97:	83 ec 04             	sub    $0x4,%esp
  802c9a:	68 75 3b 80 00       	push   $0x803b75
  802c9f:	68 f8 00 00 00       	push   $0xf8
  802ca4:	68 b7 3a 80 00       	push   $0x803ab7
  802ca9:	e8 88 db ff ff       	call   800836 <_panic>
  802cae:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802cb1:	8b 00                	mov    (%eax),%eax
  802cb3:	85 c0                	test   %eax,%eax
  802cb5:	74 10                	je     802cc7 <free_block+0x1b3>
  802cb7:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802cba:	8b 00                	mov    (%eax),%eax
  802cbc:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  802cbf:	8b 52 04             	mov    0x4(%edx),%edx
  802cc2:	89 50 04             	mov    %edx,0x4(%eax)
  802cc5:	eb 14                	jmp    802cdb <free_block+0x1c7>
  802cc7:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802cca:	8b 40 04             	mov    0x4(%eax),%eax
  802ccd:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802cd0:	c1 e2 04             	shl    $0x4,%edx
  802cd3:	81 c2 84 c0 81 00    	add    $0x81c084,%edx
  802cd9:	89 02                	mov    %eax,(%edx)
  802cdb:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802cde:	8b 40 04             	mov    0x4(%eax),%eax
  802ce1:	85 c0                	test   %eax,%eax
  802ce3:	74 0f                	je     802cf4 <free_block+0x1e0>
  802ce5:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802ce8:	8b 40 04             	mov    0x4(%eax),%eax
  802ceb:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  802cee:	8b 12                	mov    (%edx),%edx
  802cf0:	89 10                	mov    %edx,(%eax)
  802cf2:	eb 13                	jmp    802d07 <free_block+0x1f3>
  802cf4:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802cf7:	8b 00                	mov    (%eax),%eax
  802cf9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802cfc:	c1 e2 04             	shl    $0x4,%edx
  802cff:	81 c2 80 c0 81 00    	add    $0x81c080,%edx
  802d05:	89 02                	mov    %eax,(%edx)
  802d07:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802d0a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802d10:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802d13:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d1a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d1d:	c1 e0 04             	shl    $0x4,%eax
  802d20:	05 8c c0 81 00       	add    $0x81c08c,%eax
  802d25:	8b 00                	mov    (%eax),%eax
  802d27:	8d 50 ff             	lea    -0x1(%eax),%edx
  802d2a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d2d:	c1 e0 04             	shl    $0x4,%eax
  802d30:	05 8c c0 81 00       	add    $0x81c08c,%eax
  802d35:	89 10                	mov    %edx,(%eax)
	int blk_count = PAGE_SIZE / blk_size;
	// the blk count in the page is same as number fo free blocks free up the page.
	if (pageInfo->num_of_free_blocks == blk_count) {
		uint32 page_va = to_page_va(pageInfo);
		// remove all blk in the freeBlockList.
		for (uint32 off = 0; off < PAGE_SIZE; off += blk_size) {
  802d37:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802d3a:	01 45 ec             	add    %eax,-0x14(%ebp)
  802d3d:	81 7d ec ff 0f 00 00 	cmpl   $0xfff,-0x14(%ebp)
  802d44:	0f 86 3c ff ff ff    	jbe    802c86 <free_block+0x172>
			struct BlockElement *blk = (struct BlockElement*)(page_va + off);
			LIST_REMOVE(&freeBlockLists[idx], blk);
		}
		// reset page info.
		pageInfo->block_size = 0;
  802d4a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802d4d:	66 c7 40 08 00 00    	movw   $0x0,0x8(%eax)
		pageInfo->num_of_free_blocks = 0;
  802d53:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802d56:	66 c7 40 0a 00 00    	movw   $0x0,0xa(%eax)
		// add it to the available pages.
		LIST_INSERT_TAIL(&freePagesList, pageInfo);
  802d5c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  802d60:	75 17                	jne    802d79 <free_block+0x265>
  802d62:	83 ec 04             	sub    $0x4,%esp
  802d65:	68 30 3b 80 00       	push   $0x803b30
  802d6a:	68 fe 00 00 00       	push   $0xfe
  802d6f:	68 b7 3a 80 00       	push   $0x803ab7
  802d74:	e8 bd da ff ff       	call   800836 <_panic>
  802d79:	8b 15 4c 40 80 00    	mov    0x80404c,%edx
  802d7f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802d82:	89 50 04             	mov    %edx,0x4(%eax)
  802d85:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802d88:	8b 40 04             	mov    0x4(%eax),%eax
  802d8b:	85 c0                	test   %eax,%eax
  802d8d:	74 0c                	je     802d9b <free_block+0x287>
  802d8f:	a1 4c 40 80 00       	mov    0x80404c,%eax
  802d94:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802d97:	89 10                	mov    %edx,(%eax)
  802d99:	eb 08                	jmp    802da3 <free_block+0x28f>
  802d9b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802d9e:	a3 48 40 80 00       	mov    %eax,0x804048
  802da3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802da6:	a3 4c 40 80 00       	mov    %eax,0x80404c
  802dab:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802dae:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802db4:	a1 54 40 80 00       	mov    0x804054,%eax
  802db9:	40                   	inc    %eax
  802dba:	a3 54 40 80 00       	mov    %eax,0x804054
		// make it available in memory.
		return_page((uint32 *)to_page_va(pageInfo));
  802dbf:	83 ec 0c             	sub    $0xc,%esp
  802dc2:	ff 75 e4             	pushl  -0x1c(%ebp)
  802dc5:	e8 88 f5 ff ff       	call   802352 <to_page_va>
  802dca:	83 c4 10             	add    $0x10,%esp
  802dcd:	83 ec 0c             	sub    $0xc,%esp
  802dd0:	50                   	push   %eax
  802dd1:	e8 b8 ee ff ff       	call   801c8e <return_page>
  802dd6:	83 c4 10             	add    $0x10,%esp
	}
	//panic("free_block() Not implemented yet");
}
  802dd9:	90                   	nop
  802dda:	c9                   	leave  
  802ddb:	c3                   	ret    

00802ddc <realloc_block>:

//===========================
// [1] REALLOCATE BLOCK:
//===========================
void *realloc_block(void* va, uint32 new_size)
{
  802ddc:	55                   	push   %ebp
  802ddd:	89 e5                	mov    %esp,%ebp
  802ddf:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.BONUS#2] KERNEL REALLOC - realloc_block
	//Your code is here
	//Comment the following line
	panic("realloc_block() Not implemented yet");
  802de2:	83 ec 04             	sub    $0x4,%esp
  802de5:	68 dc 3b 80 00       	push   $0x803bdc
  802dea:	68 11 01 00 00       	push   $0x111
  802def:	68 b7 3a 80 00       	push   $0x803ab7
  802df4:	e8 3d da ff ff       	call   800836 <_panic>

00802df9 <create_semaphore>:
// User-level Semaphore

#include "inc/lib.h"

struct semaphore create_semaphore(char *semaphoreName, uint32 value)
{
  802df9:	55                   	push   %ebp
  802dfa:	89 e5                	mov    %esp,%ebp
  802dfc:	83 ec 08             	sub    $0x8,%esp
	panic("create_semaphore() is not implemented yet...!!");
  802dff:	83 ec 04             	sub    $0x4,%esp
  802e02:	68 00 3c 80 00       	push   $0x803c00
  802e07:	6a 07                	push   $0x7
  802e09:	68 2f 3c 80 00       	push   $0x803c2f
  802e0e:	e8 23 da ff ff       	call   800836 <_panic>

00802e13 <get_semaphore>:
}
struct semaphore get_semaphore(int32 ownerEnvID, char* semaphoreName)
{
  802e13:	55                   	push   %ebp
  802e14:	89 e5                	mov    %esp,%ebp
  802e16:	83 ec 08             	sub    $0x8,%esp
	panic("get_semaphore() is not implemented yet...!!");
  802e19:	83 ec 04             	sub    $0x4,%esp
  802e1c:	68 40 3c 80 00       	push   $0x803c40
  802e21:	6a 0b                	push   $0xb
  802e23:	68 2f 3c 80 00       	push   $0x803c2f
  802e28:	e8 09 da ff ff       	call   800836 <_panic>

00802e2d <wait_semaphore>:
}

void wait_semaphore(struct semaphore sem)
{
  802e2d:	55                   	push   %ebp
  802e2e:	89 e5                	mov    %esp,%ebp
  802e30:	83 ec 08             	sub    $0x8,%esp
	panic("wait_semaphore() is not implemented yet...!!");
  802e33:	83 ec 04             	sub    $0x4,%esp
  802e36:	68 6c 3c 80 00       	push   $0x803c6c
  802e3b:	6a 10                	push   $0x10
  802e3d:	68 2f 3c 80 00       	push   $0x803c2f
  802e42:	e8 ef d9 ff ff       	call   800836 <_panic>

00802e47 <signal_semaphore>:
}

void signal_semaphore(struct semaphore sem)
{
  802e47:	55                   	push   %ebp
  802e48:	89 e5                	mov    %esp,%ebp
  802e4a:	83 ec 08             	sub    $0x8,%esp
	panic("signal_semaphore() is not implemented yet...!!");
  802e4d:	83 ec 04             	sub    $0x4,%esp
  802e50:	68 9c 3c 80 00       	push   $0x803c9c
  802e55:	6a 15                	push   $0x15
  802e57:	68 2f 3c 80 00       	push   $0x803c2f
  802e5c:	e8 d5 d9 ff ff       	call   800836 <_panic>

00802e61 <semaphore_count>:
}

int semaphore_count(struct semaphore sem)
{
  802e61:	55                   	push   %ebp
  802e62:	89 e5                	mov    %esp,%ebp
	return sem.semdata->count;
  802e64:	8b 45 08             	mov    0x8(%ebp),%eax
  802e67:	8b 40 10             	mov    0x10(%eax),%eax
}
  802e6a:	5d                   	pop    %ebp
  802e6b:	c3                   	ret    

00802e6c <__udivdi3>:
  802e6c:	55                   	push   %ebp
  802e6d:	57                   	push   %edi
  802e6e:	56                   	push   %esi
  802e6f:	53                   	push   %ebx
  802e70:	83 ec 1c             	sub    $0x1c,%esp
  802e73:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  802e77:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  802e7b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  802e7f:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802e83:	89 ca                	mov    %ecx,%edx
  802e85:	89 f8                	mov    %edi,%eax
  802e87:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  802e8b:	85 f6                	test   %esi,%esi
  802e8d:	75 2d                	jne    802ebc <__udivdi3+0x50>
  802e8f:	39 cf                	cmp    %ecx,%edi
  802e91:	77 65                	ja     802ef8 <__udivdi3+0x8c>
  802e93:	89 fd                	mov    %edi,%ebp
  802e95:	85 ff                	test   %edi,%edi
  802e97:	75 0b                	jne    802ea4 <__udivdi3+0x38>
  802e99:	b8 01 00 00 00       	mov    $0x1,%eax
  802e9e:	31 d2                	xor    %edx,%edx
  802ea0:	f7 f7                	div    %edi
  802ea2:	89 c5                	mov    %eax,%ebp
  802ea4:	31 d2                	xor    %edx,%edx
  802ea6:	89 c8                	mov    %ecx,%eax
  802ea8:	f7 f5                	div    %ebp
  802eaa:	89 c1                	mov    %eax,%ecx
  802eac:	89 d8                	mov    %ebx,%eax
  802eae:	f7 f5                	div    %ebp
  802eb0:	89 cf                	mov    %ecx,%edi
  802eb2:	89 fa                	mov    %edi,%edx
  802eb4:	83 c4 1c             	add    $0x1c,%esp
  802eb7:	5b                   	pop    %ebx
  802eb8:	5e                   	pop    %esi
  802eb9:	5f                   	pop    %edi
  802eba:	5d                   	pop    %ebp
  802ebb:	c3                   	ret    
  802ebc:	39 ce                	cmp    %ecx,%esi
  802ebe:	77 28                	ja     802ee8 <__udivdi3+0x7c>
  802ec0:	0f bd fe             	bsr    %esi,%edi
  802ec3:	83 f7 1f             	xor    $0x1f,%edi
  802ec6:	75 40                	jne    802f08 <__udivdi3+0x9c>
  802ec8:	39 ce                	cmp    %ecx,%esi
  802eca:	72 0a                	jb     802ed6 <__udivdi3+0x6a>
  802ecc:	3b 44 24 08          	cmp    0x8(%esp),%eax
  802ed0:	0f 87 9e 00 00 00    	ja     802f74 <__udivdi3+0x108>
  802ed6:	b8 01 00 00 00       	mov    $0x1,%eax
  802edb:	89 fa                	mov    %edi,%edx
  802edd:	83 c4 1c             	add    $0x1c,%esp
  802ee0:	5b                   	pop    %ebx
  802ee1:	5e                   	pop    %esi
  802ee2:	5f                   	pop    %edi
  802ee3:	5d                   	pop    %ebp
  802ee4:	c3                   	ret    
  802ee5:	8d 76 00             	lea    0x0(%esi),%esi
  802ee8:	31 ff                	xor    %edi,%edi
  802eea:	31 c0                	xor    %eax,%eax
  802eec:	89 fa                	mov    %edi,%edx
  802eee:	83 c4 1c             	add    $0x1c,%esp
  802ef1:	5b                   	pop    %ebx
  802ef2:	5e                   	pop    %esi
  802ef3:	5f                   	pop    %edi
  802ef4:	5d                   	pop    %ebp
  802ef5:	c3                   	ret    
  802ef6:	66 90                	xchg   %ax,%ax
  802ef8:	89 d8                	mov    %ebx,%eax
  802efa:	f7 f7                	div    %edi
  802efc:	31 ff                	xor    %edi,%edi
  802efe:	89 fa                	mov    %edi,%edx
  802f00:	83 c4 1c             	add    $0x1c,%esp
  802f03:	5b                   	pop    %ebx
  802f04:	5e                   	pop    %esi
  802f05:	5f                   	pop    %edi
  802f06:	5d                   	pop    %ebp
  802f07:	c3                   	ret    
  802f08:	bd 20 00 00 00       	mov    $0x20,%ebp
  802f0d:	89 eb                	mov    %ebp,%ebx
  802f0f:	29 fb                	sub    %edi,%ebx
  802f11:	89 f9                	mov    %edi,%ecx
  802f13:	d3 e6                	shl    %cl,%esi
  802f15:	89 c5                	mov    %eax,%ebp
  802f17:	88 d9                	mov    %bl,%cl
  802f19:	d3 ed                	shr    %cl,%ebp
  802f1b:	89 e9                	mov    %ebp,%ecx
  802f1d:	09 f1                	or     %esi,%ecx
  802f1f:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  802f23:	89 f9                	mov    %edi,%ecx
  802f25:	d3 e0                	shl    %cl,%eax
  802f27:	89 c5                	mov    %eax,%ebp
  802f29:	89 d6                	mov    %edx,%esi
  802f2b:	88 d9                	mov    %bl,%cl
  802f2d:	d3 ee                	shr    %cl,%esi
  802f2f:	89 f9                	mov    %edi,%ecx
  802f31:	d3 e2                	shl    %cl,%edx
  802f33:	8b 44 24 08          	mov    0x8(%esp),%eax
  802f37:	88 d9                	mov    %bl,%cl
  802f39:	d3 e8                	shr    %cl,%eax
  802f3b:	09 c2                	or     %eax,%edx
  802f3d:	89 d0                	mov    %edx,%eax
  802f3f:	89 f2                	mov    %esi,%edx
  802f41:	f7 74 24 0c          	divl   0xc(%esp)
  802f45:	89 d6                	mov    %edx,%esi
  802f47:	89 c3                	mov    %eax,%ebx
  802f49:	f7 e5                	mul    %ebp
  802f4b:	39 d6                	cmp    %edx,%esi
  802f4d:	72 19                	jb     802f68 <__udivdi3+0xfc>
  802f4f:	74 0b                	je     802f5c <__udivdi3+0xf0>
  802f51:	89 d8                	mov    %ebx,%eax
  802f53:	31 ff                	xor    %edi,%edi
  802f55:	e9 58 ff ff ff       	jmp    802eb2 <__udivdi3+0x46>
  802f5a:	66 90                	xchg   %ax,%ax
  802f5c:	8b 54 24 08          	mov    0x8(%esp),%edx
  802f60:	89 f9                	mov    %edi,%ecx
  802f62:	d3 e2                	shl    %cl,%edx
  802f64:	39 c2                	cmp    %eax,%edx
  802f66:	73 e9                	jae    802f51 <__udivdi3+0xe5>
  802f68:	8d 43 ff             	lea    -0x1(%ebx),%eax
  802f6b:	31 ff                	xor    %edi,%edi
  802f6d:	e9 40 ff ff ff       	jmp    802eb2 <__udivdi3+0x46>
  802f72:	66 90                	xchg   %ax,%ax
  802f74:	31 c0                	xor    %eax,%eax
  802f76:	e9 37 ff ff ff       	jmp    802eb2 <__udivdi3+0x46>
  802f7b:	90                   	nop

00802f7c <__umoddi3>:
  802f7c:	55                   	push   %ebp
  802f7d:	57                   	push   %edi
  802f7e:	56                   	push   %esi
  802f7f:	53                   	push   %ebx
  802f80:	83 ec 1c             	sub    $0x1c,%esp
  802f83:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  802f87:	8b 74 24 34          	mov    0x34(%esp),%esi
  802f8b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  802f8f:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  802f93:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802f97:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802f9b:	89 f3                	mov    %esi,%ebx
  802f9d:	89 fa                	mov    %edi,%edx
  802f9f:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  802fa3:	89 34 24             	mov    %esi,(%esp)
  802fa6:	85 c0                	test   %eax,%eax
  802fa8:	75 1a                	jne    802fc4 <__umoddi3+0x48>
  802faa:	39 f7                	cmp    %esi,%edi
  802fac:	0f 86 a2 00 00 00    	jbe    803054 <__umoddi3+0xd8>
  802fb2:	89 c8                	mov    %ecx,%eax
  802fb4:	89 f2                	mov    %esi,%edx
  802fb6:	f7 f7                	div    %edi
  802fb8:	89 d0                	mov    %edx,%eax
  802fba:	31 d2                	xor    %edx,%edx
  802fbc:	83 c4 1c             	add    $0x1c,%esp
  802fbf:	5b                   	pop    %ebx
  802fc0:	5e                   	pop    %esi
  802fc1:	5f                   	pop    %edi
  802fc2:	5d                   	pop    %ebp
  802fc3:	c3                   	ret    
  802fc4:	39 f0                	cmp    %esi,%eax
  802fc6:	0f 87 ac 00 00 00    	ja     803078 <__umoddi3+0xfc>
  802fcc:	0f bd e8             	bsr    %eax,%ebp
  802fcf:	83 f5 1f             	xor    $0x1f,%ebp
  802fd2:	0f 84 ac 00 00 00    	je     803084 <__umoddi3+0x108>
  802fd8:	bf 20 00 00 00       	mov    $0x20,%edi
  802fdd:	29 ef                	sub    %ebp,%edi
  802fdf:	89 fe                	mov    %edi,%esi
  802fe1:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802fe5:	89 e9                	mov    %ebp,%ecx
  802fe7:	d3 e0                	shl    %cl,%eax
  802fe9:	89 d7                	mov    %edx,%edi
  802feb:	89 f1                	mov    %esi,%ecx
  802fed:	d3 ef                	shr    %cl,%edi
  802fef:	09 c7                	or     %eax,%edi
  802ff1:	89 e9                	mov    %ebp,%ecx
  802ff3:	d3 e2                	shl    %cl,%edx
  802ff5:	89 14 24             	mov    %edx,(%esp)
  802ff8:	89 d8                	mov    %ebx,%eax
  802ffa:	d3 e0                	shl    %cl,%eax
  802ffc:	89 c2                	mov    %eax,%edx
  802ffe:	8b 44 24 08          	mov    0x8(%esp),%eax
  803002:	d3 e0                	shl    %cl,%eax
  803004:	89 44 24 04          	mov    %eax,0x4(%esp)
  803008:	8b 44 24 08          	mov    0x8(%esp),%eax
  80300c:	89 f1                	mov    %esi,%ecx
  80300e:	d3 e8                	shr    %cl,%eax
  803010:	09 d0                	or     %edx,%eax
  803012:	d3 eb                	shr    %cl,%ebx
  803014:	89 da                	mov    %ebx,%edx
  803016:	f7 f7                	div    %edi
  803018:	89 d3                	mov    %edx,%ebx
  80301a:	f7 24 24             	mull   (%esp)
  80301d:	89 c6                	mov    %eax,%esi
  80301f:	89 d1                	mov    %edx,%ecx
  803021:	39 d3                	cmp    %edx,%ebx
  803023:	0f 82 87 00 00 00    	jb     8030b0 <__umoddi3+0x134>
  803029:	0f 84 91 00 00 00    	je     8030c0 <__umoddi3+0x144>
  80302f:	8b 54 24 04          	mov    0x4(%esp),%edx
  803033:	29 f2                	sub    %esi,%edx
  803035:	19 cb                	sbb    %ecx,%ebx
  803037:	89 d8                	mov    %ebx,%eax
  803039:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  80303d:	d3 e0                	shl    %cl,%eax
  80303f:	89 e9                	mov    %ebp,%ecx
  803041:	d3 ea                	shr    %cl,%edx
  803043:	09 d0                	or     %edx,%eax
  803045:	89 e9                	mov    %ebp,%ecx
  803047:	d3 eb                	shr    %cl,%ebx
  803049:	89 da                	mov    %ebx,%edx
  80304b:	83 c4 1c             	add    $0x1c,%esp
  80304e:	5b                   	pop    %ebx
  80304f:	5e                   	pop    %esi
  803050:	5f                   	pop    %edi
  803051:	5d                   	pop    %ebp
  803052:	c3                   	ret    
  803053:	90                   	nop
  803054:	89 fd                	mov    %edi,%ebp
  803056:	85 ff                	test   %edi,%edi
  803058:	75 0b                	jne    803065 <__umoddi3+0xe9>
  80305a:	b8 01 00 00 00       	mov    $0x1,%eax
  80305f:	31 d2                	xor    %edx,%edx
  803061:	f7 f7                	div    %edi
  803063:	89 c5                	mov    %eax,%ebp
  803065:	89 f0                	mov    %esi,%eax
  803067:	31 d2                	xor    %edx,%edx
  803069:	f7 f5                	div    %ebp
  80306b:	89 c8                	mov    %ecx,%eax
  80306d:	f7 f5                	div    %ebp
  80306f:	89 d0                	mov    %edx,%eax
  803071:	e9 44 ff ff ff       	jmp    802fba <__umoddi3+0x3e>
  803076:	66 90                	xchg   %ax,%ax
  803078:	89 c8                	mov    %ecx,%eax
  80307a:	89 f2                	mov    %esi,%edx
  80307c:	83 c4 1c             	add    $0x1c,%esp
  80307f:	5b                   	pop    %ebx
  803080:	5e                   	pop    %esi
  803081:	5f                   	pop    %edi
  803082:	5d                   	pop    %ebp
  803083:	c3                   	ret    
  803084:	3b 04 24             	cmp    (%esp),%eax
  803087:	72 06                	jb     80308f <__umoddi3+0x113>
  803089:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  80308d:	77 0f                	ja     80309e <__umoddi3+0x122>
  80308f:	89 f2                	mov    %esi,%edx
  803091:	29 f9                	sub    %edi,%ecx
  803093:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  803097:	89 14 24             	mov    %edx,(%esp)
  80309a:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80309e:	8b 44 24 04          	mov    0x4(%esp),%eax
  8030a2:	8b 14 24             	mov    (%esp),%edx
  8030a5:	83 c4 1c             	add    $0x1c,%esp
  8030a8:	5b                   	pop    %ebx
  8030a9:	5e                   	pop    %esi
  8030aa:	5f                   	pop    %edi
  8030ab:	5d                   	pop    %ebp
  8030ac:	c3                   	ret    
  8030ad:	8d 76 00             	lea    0x0(%esi),%esi
  8030b0:	2b 04 24             	sub    (%esp),%eax
  8030b3:	19 fa                	sbb    %edi,%edx
  8030b5:	89 d1                	mov    %edx,%ecx
  8030b7:	89 c6                	mov    %eax,%esi
  8030b9:	e9 71 ff ff ff       	jmp    80302f <__umoddi3+0xb3>
  8030be:	66 90                	xchg   %ax,%ax
  8030c0:	39 44 24 04          	cmp    %eax,0x4(%esp)
  8030c4:	72 ea                	jb     8030b0 <__umoddi3+0x134>
  8030c6:	89 d9                	mov    %ebx,%ecx
  8030c8:	e9 62 ff ff ff       	jmp    80302f <__umoddi3+0xb3>
