
obj/user/quicksort_interrupt:     file format elf32-i386


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
  800031:	e8 8f 05 00 00       	call   8005c5 <libmain>
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
  80003b:	53                   	push   %ebx
  80003c:	81 ec 24 01 00 00    	sub    $0x124,%esp
	char Chose ;
	char Line[255] ;
	int Iteration = 0 ;
  800042:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	do
	{
		int InitFreeFrames = sys_calculate_free_frames() + sys_calculate_modified_frames();
  800049:	e8 cd 1d 00 00       	call   801e1b <sys_calculate_free_frames>
  80004e:	89 c3                	mov    %eax,%ebx
  800050:	e8 df 1d 00 00       	call   801e34 <sys_calculate_modified_frames>
  800055:	01 d8                	add    %ebx,%eax
  800057:	89 45 f0             	mov    %eax,-0x10(%ebp)

		Iteration++ ;
  80005a:	ff 45 f4             	incl   -0xc(%ebp)
		//		cprintf("Free Frames Before Allocation = %d\n", sys_calculate_free_frames()) ;

//	sys_lock_cons();

		sys_lock_cons();
  80005d:	e8 09 1d 00 00       	call   801d6b <sys_lock_cons>
			readline("Enter the number of elements: ", Line);
  800062:	83 ec 08             	sub    $0x8,%esp
  800065:	8d 85 e1 fe ff ff    	lea    -0x11f(%ebp),%eax
  80006b:	50                   	push   %eax
  80006c:	68 c0 2f 80 00       	push   $0x802fc0
  800071:	e8 bb 10 00 00       	call   801131 <readline>
  800076:	83 c4 10             	add    $0x10,%esp
			int NumOfElements = strtol(Line, NULL, 10) ;
  800079:	83 ec 04             	sub    $0x4,%esp
  80007c:	6a 0a                	push   $0xa
  80007e:	6a 00                	push   $0x0
  800080:	8d 85 e1 fe ff ff    	lea    -0x11f(%ebp),%eax
  800086:	50                   	push   %eax
  800087:	e8 bc 16 00 00       	call   801748 <strtol>
  80008c:	83 c4 10             	add    $0x10,%esp
  80008f:	89 45 ec             	mov    %eax,-0x14(%ebp)
			int *Elements = malloc(sizeof(int) * NumOfElements) ;
  800092:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800095:	c1 e0 02             	shl    $0x2,%eax
  800098:	83 ec 0c             	sub    $0xc,%esp
  80009b:	50                   	push   %eax
  80009c:	e8 81 1b 00 00       	call   801c22 <malloc>
  8000a1:	83 c4 10             	add    $0x10,%esp
  8000a4:	89 45 e8             	mov    %eax,-0x18(%ebp)
			cprintf("Choose the initialization method:\n") ;
  8000a7:	83 ec 0c             	sub    $0xc,%esp
  8000aa:	68 e0 2f 80 00       	push   $0x802fe0
  8000af:	e8 a4 09 00 00       	call   800a58 <cprintf>
  8000b4:	83 c4 10             	add    $0x10,%esp
			cprintf("a) Ascending\n") ;
  8000b7:	83 ec 0c             	sub    $0xc,%esp
  8000ba:	68 03 30 80 00       	push   $0x803003
  8000bf:	e8 94 09 00 00       	call   800a58 <cprintf>
  8000c4:	83 c4 10             	add    $0x10,%esp
			cprintf("b) Descending\n") ;
  8000c7:	83 ec 0c             	sub    $0xc,%esp
  8000ca:	68 11 30 80 00       	push   $0x803011
  8000cf:	e8 84 09 00 00       	call   800a58 <cprintf>
  8000d4:	83 c4 10             	add    $0x10,%esp
			cprintf("c) Semi random\n");
  8000d7:	83 ec 0c             	sub    $0xc,%esp
  8000da:	68 20 30 80 00       	push   $0x803020
  8000df:	e8 74 09 00 00       	call   800a58 <cprintf>
  8000e4:	83 c4 10             	add    $0x10,%esp
			do
			{
				cprintf("Select: ") ;
  8000e7:	83 ec 0c             	sub    $0xc,%esp
  8000ea:	68 30 30 80 00       	push   $0x803030
  8000ef:	e8 64 09 00 00       	call   800a58 <cprintf>
  8000f4:	83 c4 10             	add    $0x10,%esp
				Chose = getchar() ;
  8000f7:	e8 ac 04 00 00       	call   8005a8 <getchar>
  8000fc:	88 45 e7             	mov    %al,-0x19(%ebp)
				cputchar(Chose);
  8000ff:	0f be 45 e7          	movsbl -0x19(%ebp),%eax
  800103:	83 ec 0c             	sub    $0xc,%esp
  800106:	50                   	push   %eax
  800107:	e8 7d 04 00 00       	call   800589 <cputchar>
  80010c:	83 c4 10             	add    $0x10,%esp
				cputchar('\n');
  80010f:	83 ec 0c             	sub    $0xc,%esp
  800112:	6a 0a                	push   $0xa
  800114:	e8 70 04 00 00       	call   800589 <cputchar>
  800119:	83 c4 10             	add    $0x10,%esp
			} while (Chose != 'a' && Chose != 'b' && Chose != 'c');
  80011c:	80 7d e7 61          	cmpb   $0x61,-0x19(%ebp)
  800120:	74 0c                	je     80012e <_main+0xf6>
  800122:	80 7d e7 62          	cmpb   $0x62,-0x19(%ebp)
  800126:	74 06                	je     80012e <_main+0xf6>
  800128:	80 7d e7 63          	cmpb   $0x63,-0x19(%ebp)
  80012c:	75 b9                	jne    8000e7 <_main+0xaf>
		sys_unlock_cons();
  80012e:	e8 52 1c 00 00       	call   801d85 <sys_unlock_cons>
			//sys_unlock_cons();
			int  i ;
		switch (Chose)
  800133:	0f be 45 e7          	movsbl -0x19(%ebp),%eax
  800137:	83 f8 62             	cmp    $0x62,%eax
  80013a:	74 1d                	je     800159 <_main+0x121>
  80013c:	83 f8 63             	cmp    $0x63,%eax
  80013f:	74 2b                	je     80016c <_main+0x134>
  800141:	83 f8 61             	cmp    $0x61,%eax
  800144:	75 39                	jne    80017f <_main+0x147>
		{
		case 'a':
			InitializeAscending(Elements, NumOfElements);
  800146:	83 ec 08             	sub    $0x8,%esp
  800149:	ff 75 ec             	pushl  -0x14(%ebp)
  80014c:	ff 75 e8             	pushl  -0x18(%ebp)
  80014f:	e8 e6 02 00 00       	call   80043a <InitializeAscending>
  800154:	83 c4 10             	add    $0x10,%esp
			break ;
  800157:	eb 37                	jmp    800190 <_main+0x158>
		case 'b':
			InitializeIdentical(Elements, NumOfElements);
  800159:	83 ec 08             	sub    $0x8,%esp
  80015c:	ff 75 ec             	pushl  -0x14(%ebp)
  80015f:	ff 75 e8             	pushl  -0x18(%ebp)
  800162:	e8 04 03 00 00       	call   80046b <InitializeIdentical>
  800167:	83 c4 10             	add    $0x10,%esp
			break ;
  80016a:	eb 24                	jmp    800190 <_main+0x158>
		case 'c':
			InitializeSemiRandom(Elements, NumOfElements);
  80016c:	83 ec 08             	sub    $0x8,%esp
  80016f:	ff 75 ec             	pushl  -0x14(%ebp)
  800172:	ff 75 e8             	pushl  -0x18(%ebp)
  800175:	e8 26 03 00 00       	call   8004a0 <InitializeSemiRandom>
  80017a:	83 c4 10             	add    $0x10,%esp
			break ;
  80017d:	eb 11                	jmp    800190 <_main+0x158>
		default:
			InitializeSemiRandom(Elements, NumOfElements);
  80017f:	83 ec 08             	sub    $0x8,%esp
  800182:	ff 75 ec             	pushl  -0x14(%ebp)
  800185:	ff 75 e8             	pushl  -0x18(%ebp)
  800188:	e8 13 03 00 00       	call   8004a0 <InitializeSemiRandom>
  80018d:	83 c4 10             	add    $0x10,%esp
		}

		QuickSort(Elements, NumOfElements);
  800190:	83 ec 08             	sub    $0x8,%esp
  800193:	ff 75 ec             	pushl  -0x14(%ebp)
  800196:	ff 75 e8             	pushl  -0x18(%ebp)
  800199:	e8 e1 00 00 00       	call   80027f <QuickSort>
  80019e:	83 c4 10             	add    $0x10,%esp

		//		PrintElements(Elements, NumOfElements);

		uint32 Sorted = CheckSorted(Elements, NumOfElements);
  8001a1:	83 ec 08             	sub    $0x8,%esp
  8001a4:	ff 75 ec             	pushl  -0x14(%ebp)
  8001a7:	ff 75 e8             	pushl  -0x18(%ebp)
  8001aa:	e8 e1 01 00 00       	call   800390 <CheckSorted>
  8001af:	83 c4 10             	add    $0x10,%esp
  8001b2:	89 45 e0             	mov    %eax,-0x20(%ebp)

		if(Sorted == 0) panic("The array is NOT sorted correctly") ;
  8001b5:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8001b9:	75 14                	jne    8001cf <_main+0x197>
  8001bb:	83 ec 04             	sub    $0x4,%esp
  8001be:	68 3c 30 80 00       	push   $0x80303c
  8001c3:	6a 46                	push   $0x46
  8001c5:	68 5e 30 80 00       	push   $0x80305e
  8001ca:	e8 bb 05 00 00       	call   80078a <_panic>
		else
		{
			sys_lock_cons();
  8001cf:	e8 97 1b 00 00       	call   801d6b <sys_lock_cons>
				cprintf("\n===============================================\n") ;
  8001d4:	83 ec 0c             	sub    $0xc,%esp
  8001d7:	68 7c 30 80 00       	push   $0x80307c
  8001dc:	e8 77 08 00 00       	call   800a58 <cprintf>
  8001e1:	83 c4 10             	add    $0x10,%esp
				cprintf("Congratulations!! The array is sorted correctly\n") ;
  8001e4:	83 ec 0c             	sub    $0xc,%esp
  8001e7:	68 b0 30 80 00       	push   $0x8030b0
  8001ec:	e8 67 08 00 00       	call   800a58 <cprintf>
  8001f1:	83 c4 10             	add    $0x10,%esp
				cprintf("===============================================\n\n") ;
  8001f4:	83 ec 0c             	sub    $0xc,%esp
  8001f7:	68 e4 30 80 00       	push   $0x8030e4
  8001fc:	e8 57 08 00 00       	call   800a58 <cprintf>
  800201:	83 c4 10             	add    $0x10,%esp
			sys_unlock_cons();
  800204:	e8 7c 1b 00 00       	call   801d85 <sys_unlock_cons>
		}

		//		cprintf("Free Frames After Calculation = %d\n", sys_calculate_free_frames()) ;

		sys_lock_cons();
  800209:	e8 5d 1b 00 00       	call   801d6b <sys_lock_cons>
			cprintf("Freeing the Heap...\n\n") ;
  80020e:	83 ec 0c             	sub    $0xc,%esp
  800211:	68 16 31 80 00       	push   $0x803116
  800216:	e8 3d 08 00 00       	call   800a58 <cprintf>
  80021b:	83 c4 10             	add    $0x10,%esp
		sys_unlock_cons();
  80021e:	e8 62 1b 00 00       	call   801d85 <sys_unlock_cons>

		//freeHeap() ;

		///========================================================================
	//sys_lock_cons();
		sys_lock_cons();
  800223:	e8 43 1b 00 00       	call   801d6b <sys_lock_cons>
			cprintf("Do you want to repeat (y/n): ") ;
  800228:	83 ec 0c             	sub    $0xc,%esp
  80022b:	68 2c 31 80 00       	push   $0x80312c
  800230:	e8 23 08 00 00       	call   800a58 <cprintf>
  800235:	83 c4 10             	add    $0x10,%esp
			Chose = getchar() ;
  800238:	e8 6b 03 00 00       	call   8005a8 <getchar>
  80023d:	88 45 e7             	mov    %al,-0x19(%ebp)
			cputchar(Chose);
  800240:	0f be 45 e7          	movsbl -0x19(%ebp),%eax
  800244:	83 ec 0c             	sub    $0xc,%esp
  800247:	50                   	push   %eax
  800248:	e8 3c 03 00 00       	call   800589 <cputchar>
  80024d:	83 c4 10             	add    $0x10,%esp
			cputchar('\n');
  800250:	83 ec 0c             	sub    $0xc,%esp
  800253:	6a 0a                	push   $0xa
  800255:	e8 2f 03 00 00       	call   800589 <cputchar>
  80025a:	83 c4 10             	add    $0x10,%esp
			cputchar('\n');
  80025d:	83 ec 0c             	sub    $0xc,%esp
  800260:	6a 0a                	push   $0xa
  800262:	e8 22 03 00 00       	call   800589 <cputchar>
  800267:	83 c4 10             	add    $0x10,%esp
	//sys_unlock_cons();
		sys_unlock_cons();
  80026a:	e8 16 1b 00 00       	call   801d85 <sys_unlock_cons>

	} while (Chose == 'y');
  80026f:	80 7d e7 79          	cmpb   $0x79,-0x19(%ebp)
  800273:	0f 84 d0 fd ff ff    	je     800049 <_main+0x11>

}
  800279:	90                   	nop
  80027a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80027d:	c9                   	leave  
  80027e:	c3                   	ret    

0080027f <QuickSort>:

///Quick sort
void QuickSort(int *Elements, int NumOfElements)
{
  80027f:	55                   	push   %ebp
  800280:	89 e5                	mov    %esp,%ebp
  800282:	83 ec 08             	sub    $0x8,%esp
	QSort(Elements, NumOfElements, 0, NumOfElements-1) ;
  800285:	8b 45 0c             	mov    0xc(%ebp),%eax
  800288:	48                   	dec    %eax
  800289:	50                   	push   %eax
  80028a:	6a 00                	push   $0x0
  80028c:	ff 75 0c             	pushl  0xc(%ebp)
  80028f:	ff 75 08             	pushl  0x8(%ebp)
  800292:	e8 06 00 00 00       	call   80029d <QSort>
  800297:	83 c4 10             	add    $0x10,%esp
}
  80029a:	90                   	nop
  80029b:	c9                   	leave  
  80029c:	c3                   	ret    

0080029d <QSort>:


void QSort(int *Elements,int NumOfElements, int startIndex, int finalIndex)
{
  80029d:	55                   	push   %ebp
  80029e:	89 e5                	mov    %esp,%ebp
  8002a0:	83 ec 18             	sub    $0x18,%esp
	if (startIndex >= finalIndex) return;
  8002a3:	8b 45 10             	mov    0x10(%ebp),%eax
  8002a6:	3b 45 14             	cmp    0x14(%ebp),%eax
  8002a9:	0f 8d de 00 00 00    	jge    80038d <QSort+0xf0>

	int i = startIndex+1, j = finalIndex;
  8002af:	8b 45 10             	mov    0x10(%ebp),%eax
  8002b2:	40                   	inc    %eax
  8002b3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8002b6:	8b 45 14             	mov    0x14(%ebp),%eax
  8002b9:	89 45 f0             	mov    %eax,-0x10(%ebp)

	while (i <= j)
  8002bc:	e9 80 00 00 00       	jmp    800341 <QSort+0xa4>
	{
		while (i <= finalIndex && Elements[startIndex] >= Elements[i]) i++;
  8002c1:	ff 45 f4             	incl   -0xc(%ebp)
  8002c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8002c7:	3b 45 14             	cmp    0x14(%ebp),%eax
  8002ca:	7f 2b                	jg     8002f7 <QSort+0x5a>
  8002cc:	8b 45 10             	mov    0x10(%ebp),%eax
  8002cf:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8002d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8002d9:	01 d0                	add    %edx,%eax
  8002db:	8b 10                	mov    (%eax),%edx
  8002dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8002e0:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8002e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8002ea:	01 c8                	add    %ecx,%eax
  8002ec:	8b 00                	mov    (%eax),%eax
  8002ee:	39 c2                	cmp    %eax,%edx
  8002f0:	7d cf                	jge    8002c1 <QSort+0x24>
		while (j > startIndex && Elements[startIndex] <= Elements[j]) j--;
  8002f2:	eb 03                	jmp    8002f7 <QSort+0x5a>
  8002f4:	ff 4d f0             	decl   -0x10(%ebp)
  8002f7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8002fa:	3b 45 10             	cmp    0x10(%ebp),%eax
  8002fd:	7e 26                	jle    800325 <QSort+0x88>
  8002ff:	8b 45 10             	mov    0x10(%ebp),%eax
  800302:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800309:	8b 45 08             	mov    0x8(%ebp),%eax
  80030c:	01 d0                	add    %edx,%eax
  80030e:	8b 10                	mov    (%eax),%edx
  800310:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800313:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  80031a:	8b 45 08             	mov    0x8(%ebp),%eax
  80031d:	01 c8                	add    %ecx,%eax
  80031f:	8b 00                	mov    (%eax),%eax
  800321:	39 c2                	cmp    %eax,%edx
  800323:	7e cf                	jle    8002f4 <QSort+0x57>

		if (i <= j)
  800325:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800328:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80032b:	7f 14                	jg     800341 <QSort+0xa4>
		{
			Swap(Elements, i, j);
  80032d:	83 ec 04             	sub    $0x4,%esp
  800330:	ff 75 f0             	pushl  -0x10(%ebp)
  800333:	ff 75 f4             	pushl  -0xc(%ebp)
  800336:	ff 75 08             	pushl  0x8(%ebp)
  800339:	e8 a9 00 00 00       	call   8003e7 <Swap>
  80033e:	83 c4 10             	add    $0x10,%esp
{
	if (startIndex >= finalIndex) return;

	int i = startIndex+1, j = finalIndex;

	while (i <= j)
  800341:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800344:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800347:	0f 8e 77 ff ff ff    	jle    8002c4 <QSort+0x27>
		{
			Swap(Elements, i, j);
		}
	}

	Swap( Elements, startIndex, j);
  80034d:	83 ec 04             	sub    $0x4,%esp
  800350:	ff 75 f0             	pushl  -0x10(%ebp)
  800353:	ff 75 10             	pushl  0x10(%ebp)
  800356:	ff 75 08             	pushl  0x8(%ebp)
  800359:	e8 89 00 00 00       	call   8003e7 <Swap>
  80035e:	83 c4 10             	add    $0x10,%esp

	QSort(Elements, NumOfElements, startIndex, j - 1);
  800361:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800364:	48                   	dec    %eax
  800365:	50                   	push   %eax
  800366:	ff 75 10             	pushl  0x10(%ebp)
  800369:	ff 75 0c             	pushl  0xc(%ebp)
  80036c:	ff 75 08             	pushl  0x8(%ebp)
  80036f:	e8 29 ff ff ff       	call   80029d <QSort>
  800374:	83 c4 10             	add    $0x10,%esp
	QSort(Elements, NumOfElements, i, finalIndex);
  800377:	ff 75 14             	pushl  0x14(%ebp)
  80037a:	ff 75 f4             	pushl  -0xc(%ebp)
  80037d:	ff 75 0c             	pushl  0xc(%ebp)
  800380:	ff 75 08             	pushl  0x8(%ebp)
  800383:	e8 15 ff ff ff       	call   80029d <QSort>
  800388:	83 c4 10             	add    $0x10,%esp
  80038b:	eb 01                	jmp    80038e <QSort+0xf1>
}


void QSort(int *Elements,int NumOfElements, int startIndex, int finalIndex)
{
	if (startIndex >= finalIndex) return;
  80038d:	90                   	nop

	Swap( Elements, startIndex, j);

	QSort(Elements, NumOfElements, startIndex, j - 1);
	QSort(Elements, NumOfElements, i, finalIndex);
}
  80038e:	c9                   	leave  
  80038f:	c3                   	ret    

00800390 <CheckSorted>:

uint32 CheckSorted(int *Elements, int NumOfElements)
{
  800390:	55                   	push   %ebp
  800391:	89 e5                	mov    %esp,%ebp
  800393:	83 ec 10             	sub    $0x10,%esp
	uint32 Sorted = 1 ;
  800396:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
	int i ;
	for (i = 0 ; i < NumOfElements - 1; i++)
  80039d:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8003a4:	eb 33                	jmp    8003d9 <CheckSorted+0x49>
	{
		if (Elements[i] > Elements[i+1])
  8003a6:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8003a9:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8003b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8003b3:	01 d0                	add    %edx,%eax
  8003b5:	8b 10                	mov    (%eax),%edx
  8003b7:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8003ba:	40                   	inc    %eax
  8003bb:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8003c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8003c5:	01 c8                	add    %ecx,%eax
  8003c7:	8b 00                	mov    (%eax),%eax
  8003c9:	39 c2                	cmp    %eax,%edx
  8003cb:	7e 09                	jle    8003d6 <CheckSorted+0x46>
		{
			Sorted = 0 ;
  8003cd:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
			break;
  8003d4:	eb 0c                	jmp    8003e2 <CheckSorted+0x52>

uint32 CheckSorted(int *Elements, int NumOfElements)
{
	uint32 Sorted = 1 ;
	int i ;
	for (i = 0 ; i < NumOfElements - 1; i++)
  8003d6:	ff 45 f8             	incl   -0x8(%ebp)
  8003d9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003dc:	48                   	dec    %eax
  8003dd:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8003e0:	7f c4                	jg     8003a6 <CheckSorted+0x16>
		{
			Sorted = 0 ;
			break;
		}
	}
	return Sorted ;
  8003e2:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8003e5:	c9                   	leave  
  8003e6:	c3                   	ret    

008003e7 <Swap>:

///Private Functions


void Swap(int *Elements, int First, int Second)
{
  8003e7:	55                   	push   %ebp
  8003e8:	89 e5                	mov    %esp,%ebp
  8003ea:	83 ec 10             	sub    $0x10,%esp
	int Tmp = Elements[First] ;
  8003ed:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003f0:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8003f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8003fa:	01 d0                	add    %edx,%eax
  8003fc:	8b 00                	mov    (%eax),%eax
  8003fe:	89 45 fc             	mov    %eax,-0x4(%ebp)
	Elements[First] = Elements[Second] ;
  800401:	8b 45 0c             	mov    0xc(%ebp),%eax
  800404:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80040b:	8b 45 08             	mov    0x8(%ebp),%eax
  80040e:	01 c2                	add    %eax,%edx
  800410:	8b 45 10             	mov    0x10(%ebp),%eax
  800413:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  80041a:	8b 45 08             	mov    0x8(%ebp),%eax
  80041d:	01 c8                	add    %ecx,%eax
  80041f:	8b 00                	mov    (%eax),%eax
  800421:	89 02                	mov    %eax,(%edx)
	Elements[Second] = Tmp ;
  800423:	8b 45 10             	mov    0x10(%ebp),%eax
  800426:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80042d:	8b 45 08             	mov    0x8(%ebp),%eax
  800430:	01 c2                	add    %eax,%edx
  800432:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800435:	89 02                	mov    %eax,(%edx)
}
  800437:	90                   	nop
  800438:	c9                   	leave  
  800439:	c3                   	ret    

0080043a <InitializeAscending>:

void InitializeAscending(int *Elements, int NumOfElements)
{
  80043a:	55                   	push   %ebp
  80043b:	89 e5                	mov    %esp,%ebp
  80043d:	83 ec 10             	sub    $0x10,%esp
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  800440:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800447:	eb 17                	jmp    800460 <InitializeAscending+0x26>
	{
		(Elements)[i] = i ;
  800449:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80044c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800453:	8b 45 08             	mov    0x8(%ebp),%eax
  800456:	01 c2                	add    %eax,%edx
  800458:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80045b:	89 02                	mov    %eax,(%edx)
}

void InitializeAscending(int *Elements, int NumOfElements)
{
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  80045d:	ff 45 fc             	incl   -0x4(%ebp)
  800460:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800463:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800466:	7c e1                	jl     800449 <InitializeAscending+0xf>
	{
		(Elements)[i] = i ;
	}

}
  800468:	90                   	nop
  800469:	c9                   	leave  
  80046a:	c3                   	ret    

0080046b <InitializeIdentical>:

void InitializeIdentical(int *Elements, int NumOfElements)
{
  80046b:	55                   	push   %ebp
  80046c:	89 e5                	mov    %esp,%ebp
  80046e:	83 ec 10             	sub    $0x10,%esp
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  800471:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800478:	eb 1b                	jmp    800495 <InitializeIdentical+0x2a>
	{
		Elements[i] = NumOfElements - i - 1 ;
  80047a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80047d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800484:	8b 45 08             	mov    0x8(%ebp),%eax
  800487:	01 c2                	add    %eax,%edx
  800489:	8b 45 0c             	mov    0xc(%ebp),%eax
  80048c:	2b 45 fc             	sub    -0x4(%ebp),%eax
  80048f:	48                   	dec    %eax
  800490:	89 02                	mov    %eax,(%edx)
}

void InitializeIdentical(int *Elements, int NumOfElements)
{
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  800492:	ff 45 fc             	incl   -0x4(%ebp)
  800495:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800498:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80049b:	7c dd                	jl     80047a <InitializeIdentical+0xf>
	{
		Elements[i] = NumOfElements - i - 1 ;
	}

}
  80049d:	90                   	nop
  80049e:	c9                   	leave  
  80049f:	c3                   	ret    

008004a0 <InitializeSemiRandom>:

void InitializeSemiRandom(int *Elements, int NumOfElements)
{
  8004a0:	55                   	push   %ebp
  8004a1:	89 e5                	mov    %esp,%ebp
  8004a3:	83 ec 10             	sub    $0x10,%esp
	int i ;
	int Repetition = NumOfElements / 3 ;
  8004a6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8004a9:	b8 56 55 55 55       	mov    $0x55555556,%eax
  8004ae:	f7 e9                	imul   %ecx
  8004b0:	c1 f9 1f             	sar    $0x1f,%ecx
  8004b3:	89 d0                	mov    %edx,%eax
  8004b5:	29 c8                	sub    %ecx,%eax
  8004b7:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (Repetition == 0)
  8004ba:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  8004be:	75 07                	jne    8004c7 <InitializeSemiRandom+0x27>
			Repetition = 3;
  8004c0:	c7 45 f8 03 00 00 00 	movl   $0x3,-0x8(%ebp)
	for (i = 0 ; i < NumOfElements ; i++)
  8004c7:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8004ce:	eb 1e                	jmp    8004ee <InitializeSemiRandom+0x4e>
	{
		Elements[i] = i % Repetition ;
  8004d0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8004d3:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8004da:	8b 45 08             	mov    0x8(%ebp),%eax
  8004dd:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  8004e0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8004e3:	99                   	cltd   
  8004e4:	f7 7d f8             	idivl  -0x8(%ebp)
  8004e7:	89 d0                	mov    %edx,%eax
  8004e9:	89 01                	mov    %eax,(%ecx)
{
	int i ;
	int Repetition = NumOfElements / 3 ;
	if (Repetition == 0)
			Repetition = 3;
	for (i = 0 ; i < NumOfElements ; i++)
  8004eb:	ff 45 fc             	incl   -0x4(%ebp)
  8004ee:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8004f1:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8004f4:	7c da                	jl     8004d0 <InitializeSemiRandom+0x30>
	{
		Elements[i] = i % Repetition ;
	}

}
  8004f6:	90                   	nop
  8004f7:	c9                   	leave  
  8004f8:	c3                   	ret    

008004f9 <PrintElements>:

void PrintElements(int *Elements, int NumOfElements)
{
  8004f9:	55                   	push   %ebp
  8004fa:	89 e5                	mov    %esp,%ebp
  8004fc:	83 ec 18             	sub    $0x18,%esp
	sys_lock_cons();
  8004ff:	e8 67 18 00 00       	call   801d6b <sys_lock_cons>
		int i ;
		int NumsPerLine = 20 ;
  800504:	c7 45 f0 14 00 00 00 	movl   $0x14,-0x10(%ebp)
		for (i = 0 ; i < NumOfElements-1 ; i++)
  80050b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  800512:	eb 42                	jmp    800556 <PrintElements+0x5d>
		{
			if (i%NumsPerLine == 0)
  800514:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800517:	99                   	cltd   
  800518:	f7 7d f0             	idivl  -0x10(%ebp)
  80051b:	89 d0                	mov    %edx,%eax
  80051d:	85 c0                	test   %eax,%eax
  80051f:	75 10                	jne    800531 <PrintElements+0x38>
				cprintf("\n");
  800521:	83 ec 0c             	sub    $0xc,%esp
  800524:	68 4a 31 80 00       	push   $0x80314a
  800529:	e8 2a 05 00 00       	call   800a58 <cprintf>
  80052e:	83 c4 10             	add    $0x10,%esp
			cprintf("%d, ",Elements[i]);
  800531:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800534:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80053b:	8b 45 08             	mov    0x8(%ebp),%eax
  80053e:	01 d0                	add    %edx,%eax
  800540:	8b 00                	mov    (%eax),%eax
  800542:	83 ec 08             	sub    $0x8,%esp
  800545:	50                   	push   %eax
  800546:	68 4c 31 80 00       	push   $0x80314c
  80054b:	e8 08 05 00 00       	call   800a58 <cprintf>
  800550:	83 c4 10             	add    $0x10,%esp
void PrintElements(int *Elements, int NumOfElements)
{
	sys_lock_cons();
		int i ;
		int NumsPerLine = 20 ;
		for (i = 0 ; i < NumOfElements-1 ; i++)
  800553:	ff 45 f4             	incl   -0xc(%ebp)
  800556:	8b 45 0c             	mov    0xc(%ebp),%eax
  800559:	48                   	dec    %eax
  80055a:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  80055d:	7f b5                	jg     800514 <PrintElements+0x1b>
		{
			if (i%NumsPerLine == 0)
				cprintf("\n");
			cprintf("%d, ",Elements[i]);
		}
		cprintf("%d\n",Elements[i]);
  80055f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800562:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800569:	8b 45 08             	mov    0x8(%ebp),%eax
  80056c:	01 d0                	add    %edx,%eax
  80056e:	8b 00                	mov    (%eax),%eax
  800570:	83 ec 08             	sub    $0x8,%esp
  800573:	50                   	push   %eax
  800574:	68 51 31 80 00       	push   $0x803151
  800579:	e8 da 04 00 00       	call   800a58 <cprintf>
  80057e:	83 c4 10             	add    $0x10,%esp
	sys_unlock_cons();
  800581:	e8 ff 17 00 00       	call   801d85 <sys_unlock_cons>
}
  800586:	90                   	nop
  800587:	c9                   	leave  
  800588:	c3                   	ret    

00800589 <cputchar>:
#include <inc/lib.h>


void
cputchar(int ch)
{
  800589:	55                   	push   %ebp
  80058a:	89 e5                	mov    %esp,%ebp
  80058c:	83 ec 18             	sub    $0x18,%esp
	char c = ch;
  80058f:	8b 45 08             	mov    0x8(%ebp),%eax
  800592:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	//sys_cputs(&c, 1);

	sys_cputc(c);
  800595:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  800599:	83 ec 0c             	sub    $0xc,%esp
  80059c:	50                   	push   %eax
  80059d:	e8 11 19 00 00       	call   801eb3 <sys_cputc>
  8005a2:	83 c4 10             	add    $0x10,%esp
}
  8005a5:	90                   	nop
  8005a6:	c9                   	leave  
  8005a7:	c3                   	ret    

008005a8 <getchar>:


int
getchar(void)
{
  8005a8:	55                   	push   %ebp
  8005a9:	89 e5                	mov    %esp,%ebp
  8005ab:	83 ec 18             	sub    $0x18,%esp
	int c =sys_cgetc();
  8005ae:	e8 9f 17 00 00       	call   801d52 <sys_cgetc>
  8005b3:	89 45 f4             	mov    %eax,-0xc(%ebp)
	return c;
  8005b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  8005b9:	c9                   	leave  
  8005ba:	c3                   	ret    

008005bb <iscons>:

int iscons(int fdnum)
{
  8005bb:	55                   	push   %ebp
  8005bc:	89 e5                	mov    %esp,%ebp
	// used by readline
	return 1;
  8005be:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8005c3:	5d                   	pop    %ebp
  8005c4:	c3                   	ret    

008005c5 <libmain>:
volatile bool printStats = 1;

volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";
void
libmain(int argc, char **argv)
{
  8005c5:	55                   	push   %ebp
  8005c6:	89 e5                	mov    %esp,%ebp
  8005c8:	57                   	push   %edi
  8005c9:	56                   	push   %esi
  8005ca:	53                   	push   %ebx
  8005cb:	83 ec 7c             	sub    $0x7c,%esp
	//printStats = 1;
	int envIndex = sys_getenvindex();
  8005ce:	e8 11 1a 00 00       	call   801fe4 <sys_getenvindex>
  8005d3:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	myEnv = &(envs[envIndex]);
  8005d6:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8005d9:	89 d0                	mov    %edx,%eax
  8005db:	c1 e0 06             	shl    $0x6,%eax
  8005de:	29 d0                	sub    %edx,%eax
  8005e0:	c1 e0 02             	shl    $0x2,%eax
  8005e3:	01 d0                	add    %edx,%eax
  8005e5:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8005ec:	01 c8                	add    %ecx,%eax
  8005ee:	c1 e0 03             	shl    $0x3,%eax
  8005f1:	01 d0                	add    %edx,%eax
  8005f3:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8005fa:	29 c2                	sub    %eax,%edx
  8005fc:	8d 04 95 00 00 00 00 	lea    0x0(,%edx,4),%eax
  800603:	89 c2                	mov    %eax,%edx
  800605:	8d 82 00 00 c0 ee    	lea    -0x11400000(%edx),%eax
  80060b:	a3 24 40 80 00       	mov    %eax,0x804024

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800610:	a1 24 40 80 00       	mov    0x804024,%eax
  800615:	8a 40 20             	mov    0x20(%eax),%al
  800618:	84 c0                	test   %al,%al
  80061a:	74 0d                	je     800629 <libmain+0x64>
		binaryname = myEnv->prog_name;
  80061c:	a1 24 40 80 00       	mov    0x804024,%eax
  800621:	83 c0 20             	add    $0x20,%eax
  800624:	a3 04 40 80 00       	mov    %eax,0x804004

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800629:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80062d:	7e 0a                	jle    800639 <libmain+0x74>
		binaryname = argv[0];
  80062f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800632:	8b 00                	mov    (%eax),%eax
  800634:	a3 04 40 80 00       	mov    %eax,0x804004

	// call user main routine
	_main(argc, argv);
  800639:	83 ec 08             	sub    $0x8,%esp
  80063c:	ff 75 0c             	pushl  0xc(%ebp)
  80063f:	ff 75 08             	pushl  0x8(%ebp)
  800642:	e8 f1 f9 ff ff       	call   800038 <_main>
  800647:	83 c4 10             	add    $0x10,%esp

	if (printStats)
  80064a:	a1 00 40 80 00       	mov    0x804000,%eax
  80064f:	85 c0                	test   %eax,%eax
  800651:	0f 84 01 01 00 00    	je     800758 <libmain+0x193>
	{
		char isOPTReplCmd[100] = "__IsOPTRepl__" ;
  800657:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  80065d:	bb 50 32 80 00       	mov    $0x803250,%ebx
  800662:	ba 0e 00 00 00       	mov    $0xe,%edx
  800667:	89 c7                	mov    %eax,%edi
  800669:	89 de                	mov    %ebx,%esi
  80066b:	89 d1                	mov    %edx,%ecx
  80066d:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  80066f:	8d 55 8a             	lea    -0x76(%ebp),%edx
  800672:	b9 56 00 00 00       	mov    $0x56,%ecx
  800677:	b0 00                	mov    $0x0,%al
  800679:	89 d7                	mov    %edx,%edi
  80067b:	f3 aa                	rep stos %al,%es:(%edi)
		int isOPTRepl = 0;
  80067d:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
		sys_utilities(isOPTReplCmd, (uint32)(&isOPTRepl));
  800684:	8d 45 e0             	lea    -0x20(%ebp),%eax
  800687:	83 ec 08             	sub    $0x8,%esp
  80068a:	50                   	push   %eax
  80068b:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  800691:	50                   	push   %eax
  800692:	e8 83 1b 00 00       	call   80221a <sys_utilities>
  800697:	83 c4 10             	add    $0x10,%esp

		sys_lock_cons();
  80069a:	e8 cc 16 00 00       	call   801d6b <sys_lock_cons>
		{
			cprintf("**************************************\n");
  80069f:	83 ec 0c             	sub    $0xc,%esp
  8006a2:	68 70 31 80 00       	push   $0x803170
  8006a7:	e8 ac 03 00 00       	call   800a58 <cprintf>
  8006ac:	83 c4 10             	add    $0x10,%esp
			if (isOPTRepl)
  8006af:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8006b2:	85 c0                	test   %eax,%eax
  8006b4:	74 18                	je     8006ce <libmain+0x109>
			{
				cprintf("OPTIMAL number of page faults = %d\n", sys_get_optimal_num_faults());
  8006b6:	e8 7d 1b 00 00       	call   802238 <sys_get_optimal_num_faults>
  8006bb:	83 ec 08             	sub    $0x8,%esp
  8006be:	50                   	push   %eax
  8006bf:	68 98 31 80 00       	push   $0x803198
  8006c4:	e8 8f 03 00 00       	call   800a58 <cprintf>
  8006c9:	83 c4 10             	add    $0x10,%esp
  8006cc:	eb 59                	jmp    800727 <libmain+0x162>
			}
			else
			{
				cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8006ce:	a1 24 40 80 00       	mov    0x804024,%eax
  8006d3:	8b 90 50 da 01 00    	mov    0x1da50(%eax),%edx
  8006d9:	a1 24 40 80 00       	mov    0x804024,%eax
  8006de:	8b 80 40 da 01 00    	mov    0x1da40(%eax),%eax
  8006e4:	83 ec 04             	sub    $0x4,%esp
  8006e7:	52                   	push   %edx
  8006e8:	50                   	push   %eax
  8006e9:	68 bc 31 80 00       	push   $0x8031bc
  8006ee:	e8 65 03 00 00       	call   800a58 <cprintf>
  8006f3:	83 c4 10             	add    $0x10,%esp
				cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  8006f6:	a1 24 40 80 00       	mov    0x804024,%eax
  8006fb:	8b 88 64 da 01 00    	mov    0x1da64(%eax),%ecx
  800701:	a1 24 40 80 00       	mov    0x804024,%eax
  800706:	8b 90 60 da 01 00    	mov    0x1da60(%eax),%edx
  80070c:	a1 24 40 80 00       	mov    0x804024,%eax
  800711:	8b 80 5c da 01 00    	mov    0x1da5c(%eax),%eax
  800717:	51                   	push   %ecx
  800718:	52                   	push   %edx
  800719:	50                   	push   %eax
  80071a:	68 e4 31 80 00       	push   $0x8031e4
  80071f:	e8 34 03 00 00       	call   800a58 <cprintf>
  800724:	83 c4 10             	add    $0x10,%esp
			}
			//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
			cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800727:	a1 24 40 80 00       	mov    0x804024,%eax
  80072c:	8b 80 68 da 01 00    	mov    0x1da68(%eax),%eax
  800732:	83 ec 08             	sub    $0x8,%esp
  800735:	50                   	push   %eax
  800736:	68 3c 32 80 00       	push   $0x80323c
  80073b:	e8 18 03 00 00       	call   800a58 <cprintf>
  800740:	83 c4 10             	add    $0x10,%esp
			cprintf("**************************************\n");
  800743:	83 ec 0c             	sub    $0xc,%esp
  800746:	68 70 31 80 00       	push   $0x803170
  80074b:	e8 08 03 00 00       	call   800a58 <cprintf>
  800750:	83 c4 10             	add    $0x10,%esp
		}
		sys_unlock_cons();
  800753:	e8 2d 16 00 00       	call   801d85 <sys_unlock_cons>
	}

	// exit gracefully
	exit();
  800758:	e8 1f 00 00 00       	call   80077c <exit>
}
  80075d:	90                   	nop
  80075e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800761:	5b                   	pop    %ebx
  800762:	5e                   	pop    %esi
  800763:	5f                   	pop    %edi
  800764:	5d                   	pop    %ebp
  800765:	c3                   	ret    

00800766 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800766:	55                   	push   %ebp
  800767:	89 e5                	mov    %esp,%ebp
  800769:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  80076c:	83 ec 0c             	sub    $0xc,%esp
  80076f:	6a 00                	push   $0x0
  800771:	e8 3a 18 00 00       	call   801fb0 <sys_destroy_env>
  800776:	83 c4 10             	add    $0x10,%esp
}
  800779:	90                   	nop
  80077a:	c9                   	leave  
  80077b:	c3                   	ret    

0080077c <exit>:

void
exit(void)
{
  80077c:	55                   	push   %ebp
  80077d:	89 e5                	mov    %esp,%ebp
  80077f:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  800782:	e8 8f 18 00 00       	call   802016 <sys_exit_env>
}
  800787:	90                   	nop
  800788:	c9                   	leave  
  800789:	c3                   	ret    

0080078a <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  80078a:	55                   	push   %ebp
  80078b:	89 e5                	mov    %esp,%ebp
  80078d:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  800790:	8d 45 10             	lea    0x10(%ebp),%eax
  800793:	83 c0 04             	add    $0x4,%eax
  800796:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  800799:	a1 18 c1 81 00       	mov    0x81c118,%eax
  80079e:	85 c0                	test   %eax,%eax
  8007a0:	74 16                	je     8007b8 <_panic+0x2e>
		cprintf("%s: ", argv0);
  8007a2:	a1 18 c1 81 00       	mov    0x81c118,%eax
  8007a7:	83 ec 08             	sub    $0x8,%esp
  8007aa:	50                   	push   %eax
  8007ab:	68 b4 32 80 00       	push   $0x8032b4
  8007b0:	e8 a3 02 00 00       	call   800a58 <cprintf>
  8007b5:	83 c4 10             	add    $0x10,%esp
	cprintf_colored(TEXT_PANIC_CLR, "user [EVAL_FINAL]panic in %s at %s:%d: ", binaryname, file, line);
  8007b8:	a1 04 40 80 00       	mov    0x804004,%eax
  8007bd:	83 ec 0c             	sub    $0xc,%esp
  8007c0:	ff 75 0c             	pushl  0xc(%ebp)
  8007c3:	ff 75 08             	pushl  0x8(%ebp)
  8007c6:	50                   	push   %eax
  8007c7:	68 bc 32 80 00       	push   $0x8032bc
  8007cc:	6a 74                	push   $0x74
  8007ce:	e8 b2 02 00 00       	call   800a85 <cprintf_colored>
  8007d3:	83 c4 20             	add    $0x20,%esp
	vcprintf(fmt, ap);
  8007d6:	8b 45 10             	mov    0x10(%ebp),%eax
  8007d9:	83 ec 08             	sub    $0x8,%esp
  8007dc:	ff 75 f4             	pushl  -0xc(%ebp)
  8007df:	50                   	push   %eax
  8007e0:	e8 04 02 00 00       	call   8009e9 <vcprintf>
  8007e5:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  8007e8:	83 ec 08             	sub    $0x8,%esp
  8007eb:	6a 00                	push   $0x0
  8007ed:	68 e4 32 80 00       	push   $0x8032e4
  8007f2:	e8 f2 01 00 00       	call   8009e9 <vcprintf>
  8007f7:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  8007fa:	e8 7d ff ff ff       	call   80077c <exit>

	// should not return here
	while (1) ;
  8007ff:	eb fe                	jmp    8007ff <_panic+0x75>

00800801 <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  800801:	55                   	push   %ebp
  800802:	89 e5                	mov    %esp,%ebp
  800804:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  800807:	a1 24 40 80 00       	mov    0x804024,%eax
  80080c:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  800812:	8b 45 0c             	mov    0xc(%ebp),%eax
  800815:	39 c2                	cmp    %eax,%edx
  800817:	74 14                	je     80082d <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  800819:	83 ec 04             	sub    $0x4,%esp
  80081c:	68 e8 32 80 00       	push   $0x8032e8
  800821:	6a 26                	push   $0x26
  800823:	68 34 33 80 00       	push   $0x803334
  800828:	e8 5d ff ff ff       	call   80078a <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  80082d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  800834:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80083b:	e9 c5 00 00 00       	jmp    800905 <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  800840:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800843:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80084a:	8b 45 08             	mov    0x8(%ebp),%eax
  80084d:	01 d0                	add    %edx,%eax
  80084f:	8b 00                	mov    (%eax),%eax
  800851:	85 c0                	test   %eax,%eax
  800853:	75 08                	jne    80085d <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  800855:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  800858:	e9 a5 00 00 00       	jmp    800902 <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  80085d:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800864:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  80086b:	eb 69                	jmp    8008d6 <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  80086d:	a1 24 40 80 00       	mov    0x804024,%eax
  800872:	8b 88 38 da 01 00    	mov    0x1da38(%eax),%ecx
  800878:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80087b:	89 d0                	mov    %edx,%eax
  80087d:	01 c0                	add    %eax,%eax
  80087f:	01 d0                	add    %edx,%eax
  800881:	c1 e0 03             	shl    $0x3,%eax
  800884:	01 c8                	add    %ecx,%eax
  800886:	8a 40 04             	mov    0x4(%eax),%al
  800889:	84 c0                	test   %al,%al
  80088b:	75 46                	jne    8008d3 <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  80088d:	a1 24 40 80 00       	mov    0x804024,%eax
  800892:	8b 88 38 da 01 00    	mov    0x1da38(%eax),%ecx
  800898:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80089b:	89 d0                	mov    %edx,%eax
  80089d:	01 c0                	add    %eax,%eax
  80089f:	01 d0                	add    %edx,%eax
  8008a1:	c1 e0 03             	shl    $0x3,%eax
  8008a4:	01 c8                	add    %ecx,%eax
  8008a6:	8b 00                	mov    (%eax),%eax
  8008a8:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8008ab:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8008ae:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8008b3:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  8008b5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8008b8:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8008bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8008c2:	01 c8                	add    %ecx,%eax
  8008c4:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8008c6:	39 c2                	cmp    %eax,%edx
  8008c8:	75 09                	jne    8008d3 <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  8008ca:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  8008d1:	eb 15                	jmp    8008e8 <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8008d3:	ff 45 e8             	incl   -0x18(%ebp)
  8008d6:	a1 24 40 80 00       	mov    0x804024,%eax
  8008db:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  8008e1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8008e4:	39 c2                	cmp    %eax,%edx
  8008e6:	77 85                	ja     80086d <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  8008e8:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8008ec:	75 14                	jne    800902 <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  8008ee:	83 ec 04             	sub    $0x4,%esp
  8008f1:	68 40 33 80 00       	push   $0x803340
  8008f6:	6a 3a                	push   $0x3a
  8008f8:	68 34 33 80 00       	push   $0x803334
  8008fd:	e8 88 fe ff ff       	call   80078a <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  800902:	ff 45 f0             	incl   -0x10(%ebp)
  800905:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800908:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80090b:	0f 8c 2f ff ff ff    	jl     800840 <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  800911:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800918:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  80091f:	eb 26                	jmp    800947 <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  800921:	a1 24 40 80 00       	mov    0x804024,%eax
  800926:	8b 88 38 da 01 00    	mov    0x1da38(%eax),%ecx
  80092c:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80092f:	89 d0                	mov    %edx,%eax
  800931:	01 c0                	add    %eax,%eax
  800933:	01 d0                	add    %edx,%eax
  800935:	c1 e0 03             	shl    $0x3,%eax
  800938:	01 c8                	add    %ecx,%eax
  80093a:	8a 40 04             	mov    0x4(%eax),%al
  80093d:	3c 01                	cmp    $0x1,%al
  80093f:	75 03                	jne    800944 <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  800941:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800944:	ff 45 e0             	incl   -0x20(%ebp)
  800947:	a1 24 40 80 00       	mov    0x804024,%eax
  80094c:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  800952:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800955:	39 c2                	cmp    %eax,%edx
  800957:	77 c8                	ja     800921 <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  800959:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80095c:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  80095f:	74 14                	je     800975 <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  800961:	83 ec 04             	sub    $0x4,%esp
  800964:	68 94 33 80 00       	push   $0x803394
  800969:	6a 44                	push   $0x44
  80096b:	68 34 33 80 00       	push   $0x803334
  800970:	e8 15 fe ff ff       	call   80078a <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  800975:	90                   	nop
  800976:	c9                   	leave  
  800977:	c3                   	ret    

00800978 <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  800978:	55                   	push   %ebp
  800979:	89 e5                	mov    %esp,%ebp
  80097b:	53                   	push   %ebx
  80097c:	83 ec 04             	sub    $0x4,%esp
	b->buf[b->idx++] = ch;
  80097f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800982:	8b 00                	mov    (%eax),%eax
  800984:	8d 48 01             	lea    0x1(%eax),%ecx
  800987:	8b 55 0c             	mov    0xc(%ebp),%edx
  80098a:	89 0a                	mov    %ecx,(%edx)
  80098c:	8b 55 08             	mov    0x8(%ebp),%edx
  80098f:	88 d1                	mov    %dl,%cl
  800991:	8b 55 0c             	mov    0xc(%ebp),%edx
  800994:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800998:	8b 45 0c             	mov    0xc(%ebp),%eax
  80099b:	8b 00                	mov    (%eax),%eax
  80099d:	3d ff 00 00 00       	cmp    $0xff,%eax
  8009a2:	75 30                	jne    8009d4 <putch+0x5c>
		sys_cputs(b->buf, b->idx, printProgName, curTextClr);
  8009a4:	8b 15 1c c1 81 00    	mov    0x81c11c,%edx
  8009aa:	a0 44 40 80 00       	mov    0x804044,%al
  8009af:	0f b6 c0             	movzbl %al,%eax
  8009b2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8009b5:	8b 09                	mov    (%ecx),%ecx
  8009b7:	89 cb                	mov    %ecx,%ebx
  8009b9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8009bc:	83 c1 08             	add    $0x8,%ecx
  8009bf:	52                   	push   %edx
  8009c0:	50                   	push   %eax
  8009c1:	53                   	push   %ebx
  8009c2:	51                   	push   %ecx
  8009c3:	e8 5f 13 00 00       	call   801d27 <sys_cputs>
  8009c8:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8009cb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009ce:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8009d4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009d7:	8b 40 04             	mov    0x4(%eax),%eax
  8009da:	8d 50 01             	lea    0x1(%eax),%edx
  8009dd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009e0:	89 50 04             	mov    %edx,0x4(%eax)
}
  8009e3:	90                   	nop
  8009e4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8009e7:	c9                   	leave  
  8009e8:	c3                   	ret    

008009e9 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  8009e9:	55                   	push   %ebp
  8009ea:	89 e5                	mov    %esp,%ebp
  8009ec:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8009f2:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8009f9:	00 00 00 
	b.cnt = 0;
  8009fc:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800a03:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800a06:	ff 75 0c             	pushl  0xc(%ebp)
  800a09:	ff 75 08             	pushl  0x8(%ebp)
  800a0c:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800a12:	50                   	push   %eax
  800a13:	68 78 09 80 00       	push   $0x800978
  800a18:	e8 5a 02 00 00       	call   800c77 <vprintfmt>
  800a1d:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName, curTextClr);
  800a20:	8b 15 1c c1 81 00    	mov    0x81c11c,%edx
  800a26:	a0 44 40 80 00       	mov    0x804044,%al
  800a2b:	0f b6 c0             	movzbl %al,%eax
  800a2e:	8b 8d f0 fe ff ff    	mov    -0x110(%ebp),%ecx
  800a34:	52                   	push   %edx
  800a35:	50                   	push   %eax
  800a36:	51                   	push   %ecx
  800a37:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800a3d:	83 c0 08             	add    $0x8,%eax
  800a40:	50                   	push   %eax
  800a41:	e8 e1 12 00 00       	call   801d27 <sys_cputs>
  800a46:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800a49:	c6 05 44 40 80 00 00 	movb   $0x0,0x804044
	return b.cnt;
  800a50:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800a56:	c9                   	leave  
  800a57:	c3                   	ret    

00800a58 <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  800a58:	55                   	push   %ebp
  800a59:	89 e5                	mov    %esp,%ebp
  800a5b:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800a5e:	c6 05 44 40 80 00 01 	movb   $0x1,0x804044
	va_start(ap, fmt);
  800a65:	8d 45 0c             	lea    0xc(%ebp),%eax
  800a68:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800a6b:	8b 45 08             	mov    0x8(%ebp),%eax
  800a6e:	83 ec 08             	sub    $0x8,%esp
  800a71:	ff 75 f4             	pushl  -0xc(%ebp)
  800a74:	50                   	push   %eax
  800a75:	e8 6f ff ff ff       	call   8009e9 <vcprintf>
  800a7a:	83 c4 10             	add    $0x10,%esp
  800a7d:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800a80:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800a83:	c9                   	leave  
  800a84:	c3                   	ret    

00800a85 <cprintf_colored>:

// *************** This text coloring feature is implemented by *************
// ********** Abd-Alrahman Zedan From Team Frozen-Bytes - FCIS'24-25 ********
int cprintf_colored(int textClr, const char *fmt, ...) {
  800a85:	55                   	push   %ebp
  800a86:	89 e5                	mov    %esp,%ebp
  800a88:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800a8b:	c6 05 44 40 80 00 01 	movb   $0x1,0x804044
	curTextClr = (textClr << 8) ; //set text color by the given value
  800a92:	8b 45 08             	mov    0x8(%ebp),%eax
  800a95:	c1 e0 08             	shl    $0x8,%eax
  800a98:	a3 1c c1 81 00       	mov    %eax,0x81c11c
	va_start(ap, fmt);
  800a9d:	8d 45 0c             	lea    0xc(%ebp),%eax
  800aa0:	83 c0 04             	add    $0x4,%eax
  800aa3:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800aa6:	8b 45 0c             	mov    0xc(%ebp),%eax
  800aa9:	83 ec 08             	sub    $0x8,%esp
  800aac:	ff 75 f4             	pushl  -0xc(%ebp)
  800aaf:	50                   	push   %eax
  800ab0:	e8 34 ff ff ff       	call   8009e9 <vcprintf>
  800ab5:	83 c4 10             	add    $0x10,%esp
  800ab8:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);
	curTextClr = TEXT_DEFAULT_CLR; //restore default color
  800abb:	c7 05 1c c1 81 00 00 	movl   $0x700,0x81c11c
  800ac2:	07 00 00 

	return cnt;
  800ac5:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800ac8:	c9                   	leave  
  800ac9:	c3                   	ret    

00800aca <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  800aca:	55                   	push   %ebp
  800acb:	89 e5                	mov    %esp,%ebp
  800acd:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  800ad0:	e8 96 12 00 00       	call   801d6b <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  800ad5:	8d 45 0c             	lea    0xc(%ebp),%eax
  800ad8:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  800adb:	8b 45 08             	mov    0x8(%ebp),%eax
  800ade:	83 ec 08             	sub    $0x8,%esp
  800ae1:	ff 75 f4             	pushl  -0xc(%ebp)
  800ae4:	50                   	push   %eax
  800ae5:	e8 ff fe ff ff       	call   8009e9 <vcprintf>
  800aea:	83 c4 10             	add    $0x10,%esp
  800aed:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  800af0:	e8 90 12 00 00       	call   801d85 <sys_unlock_cons>
	return cnt;
  800af5:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800af8:	c9                   	leave  
  800af9:	c3                   	ret    

00800afa <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800afa:	55                   	push   %ebp
  800afb:	89 e5                	mov    %esp,%ebp
  800afd:	53                   	push   %ebx
  800afe:	83 ec 14             	sub    $0x14,%esp
  800b01:	8b 45 10             	mov    0x10(%ebp),%eax
  800b04:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b07:	8b 45 14             	mov    0x14(%ebp),%eax
  800b0a:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800b0d:	8b 45 18             	mov    0x18(%ebp),%eax
  800b10:	ba 00 00 00 00       	mov    $0x0,%edx
  800b15:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800b18:	77 55                	ja     800b6f <printnum+0x75>
  800b1a:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800b1d:	72 05                	jb     800b24 <printnum+0x2a>
  800b1f:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800b22:	77 4b                	ja     800b6f <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800b24:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800b27:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800b2a:	8b 45 18             	mov    0x18(%ebp),%eax
  800b2d:	ba 00 00 00 00       	mov    $0x0,%edx
  800b32:	52                   	push   %edx
  800b33:	50                   	push   %eax
  800b34:	ff 75 f4             	pushl  -0xc(%ebp)
  800b37:	ff 75 f0             	pushl  -0x10(%ebp)
  800b3a:	e8 11 22 00 00       	call   802d50 <__udivdi3>
  800b3f:	83 c4 10             	add    $0x10,%esp
  800b42:	83 ec 04             	sub    $0x4,%esp
  800b45:	ff 75 20             	pushl  0x20(%ebp)
  800b48:	53                   	push   %ebx
  800b49:	ff 75 18             	pushl  0x18(%ebp)
  800b4c:	52                   	push   %edx
  800b4d:	50                   	push   %eax
  800b4e:	ff 75 0c             	pushl  0xc(%ebp)
  800b51:	ff 75 08             	pushl  0x8(%ebp)
  800b54:	e8 a1 ff ff ff       	call   800afa <printnum>
  800b59:	83 c4 20             	add    $0x20,%esp
  800b5c:	eb 1a                	jmp    800b78 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800b5e:	83 ec 08             	sub    $0x8,%esp
  800b61:	ff 75 0c             	pushl  0xc(%ebp)
  800b64:	ff 75 20             	pushl  0x20(%ebp)
  800b67:	8b 45 08             	mov    0x8(%ebp),%eax
  800b6a:	ff d0                	call   *%eax
  800b6c:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800b6f:	ff 4d 1c             	decl   0x1c(%ebp)
  800b72:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800b76:	7f e6                	jg     800b5e <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800b78:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800b7b:	bb 00 00 00 00       	mov    $0x0,%ebx
  800b80:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800b83:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800b86:	53                   	push   %ebx
  800b87:	51                   	push   %ecx
  800b88:	52                   	push   %edx
  800b89:	50                   	push   %eax
  800b8a:	e8 d1 22 00 00       	call   802e60 <__umoddi3>
  800b8f:	83 c4 10             	add    $0x10,%esp
  800b92:	05 f4 35 80 00       	add    $0x8035f4,%eax
  800b97:	8a 00                	mov    (%eax),%al
  800b99:	0f be c0             	movsbl %al,%eax
  800b9c:	83 ec 08             	sub    $0x8,%esp
  800b9f:	ff 75 0c             	pushl  0xc(%ebp)
  800ba2:	50                   	push   %eax
  800ba3:	8b 45 08             	mov    0x8(%ebp),%eax
  800ba6:	ff d0                	call   *%eax
  800ba8:	83 c4 10             	add    $0x10,%esp
}
  800bab:	90                   	nop
  800bac:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800baf:	c9                   	leave  
  800bb0:	c3                   	ret    

00800bb1 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800bb1:	55                   	push   %ebp
  800bb2:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800bb4:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800bb8:	7e 1c                	jle    800bd6 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800bba:	8b 45 08             	mov    0x8(%ebp),%eax
  800bbd:	8b 00                	mov    (%eax),%eax
  800bbf:	8d 50 08             	lea    0x8(%eax),%edx
  800bc2:	8b 45 08             	mov    0x8(%ebp),%eax
  800bc5:	89 10                	mov    %edx,(%eax)
  800bc7:	8b 45 08             	mov    0x8(%ebp),%eax
  800bca:	8b 00                	mov    (%eax),%eax
  800bcc:	83 e8 08             	sub    $0x8,%eax
  800bcf:	8b 50 04             	mov    0x4(%eax),%edx
  800bd2:	8b 00                	mov    (%eax),%eax
  800bd4:	eb 40                	jmp    800c16 <getuint+0x65>
	else if (lflag)
  800bd6:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800bda:	74 1e                	je     800bfa <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800bdc:	8b 45 08             	mov    0x8(%ebp),%eax
  800bdf:	8b 00                	mov    (%eax),%eax
  800be1:	8d 50 04             	lea    0x4(%eax),%edx
  800be4:	8b 45 08             	mov    0x8(%ebp),%eax
  800be7:	89 10                	mov    %edx,(%eax)
  800be9:	8b 45 08             	mov    0x8(%ebp),%eax
  800bec:	8b 00                	mov    (%eax),%eax
  800bee:	83 e8 04             	sub    $0x4,%eax
  800bf1:	8b 00                	mov    (%eax),%eax
  800bf3:	ba 00 00 00 00       	mov    $0x0,%edx
  800bf8:	eb 1c                	jmp    800c16 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800bfa:	8b 45 08             	mov    0x8(%ebp),%eax
  800bfd:	8b 00                	mov    (%eax),%eax
  800bff:	8d 50 04             	lea    0x4(%eax),%edx
  800c02:	8b 45 08             	mov    0x8(%ebp),%eax
  800c05:	89 10                	mov    %edx,(%eax)
  800c07:	8b 45 08             	mov    0x8(%ebp),%eax
  800c0a:	8b 00                	mov    (%eax),%eax
  800c0c:	83 e8 04             	sub    $0x4,%eax
  800c0f:	8b 00                	mov    (%eax),%eax
  800c11:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800c16:	5d                   	pop    %ebp
  800c17:	c3                   	ret    

00800c18 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800c18:	55                   	push   %ebp
  800c19:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800c1b:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800c1f:	7e 1c                	jle    800c3d <getint+0x25>
		return va_arg(*ap, long long);
  800c21:	8b 45 08             	mov    0x8(%ebp),%eax
  800c24:	8b 00                	mov    (%eax),%eax
  800c26:	8d 50 08             	lea    0x8(%eax),%edx
  800c29:	8b 45 08             	mov    0x8(%ebp),%eax
  800c2c:	89 10                	mov    %edx,(%eax)
  800c2e:	8b 45 08             	mov    0x8(%ebp),%eax
  800c31:	8b 00                	mov    (%eax),%eax
  800c33:	83 e8 08             	sub    $0x8,%eax
  800c36:	8b 50 04             	mov    0x4(%eax),%edx
  800c39:	8b 00                	mov    (%eax),%eax
  800c3b:	eb 38                	jmp    800c75 <getint+0x5d>
	else if (lflag)
  800c3d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c41:	74 1a                	je     800c5d <getint+0x45>
		return va_arg(*ap, long);
  800c43:	8b 45 08             	mov    0x8(%ebp),%eax
  800c46:	8b 00                	mov    (%eax),%eax
  800c48:	8d 50 04             	lea    0x4(%eax),%edx
  800c4b:	8b 45 08             	mov    0x8(%ebp),%eax
  800c4e:	89 10                	mov    %edx,(%eax)
  800c50:	8b 45 08             	mov    0x8(%ebp),%eax
  800c53:	8b 00                	mov    (%eax),%eax
  800c55:	83 e8 04             	sub    $0x4,%eax
  800c58:	8b 00                	mov    (%eax),%eax
  800c5a:	99                   	cltd   
  800c5b:	eb 18                	jmp    800c75 <getint+0x5d>
	else
		return va_arg(*ap, int);
  800c5d:	8b 45 08             	mov    0x8(%ebp),%eax
  800c60:	8b 00                	mov    (%eax),%eax
  800c62:	8d 50 04             	lea    0x4(%eax),%edx
  800c65:	8b 45 08             	mov    0x8(%ebp),%eax
  800c68:	89 10                	mov    %edx,(%eax)
  800c6a:	8b 45 08             	mov    0x8(%ebp),%eax
  800c6d:	8b 00                	mov    (%eax),%eax
  800c6f:	83 e8 04             	sub    $0x4,%eax
  800c72:	8b 00                	mov    (%eax),%eax
  800c74:	99                   	cltd   
}
  800c75:	5d                   	pop    %ebp
  800c76:	c3                   	ret    

00800c77 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800c77:	55                   	push   %ebp
  800c78:	89 e5                	mov    %esp,%ebp
  800c7a:	56                   	push   %esi
  800c7b:	53                   	push   %ebx
  800c7c:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800c7f:	eb 17                	jmp    800c98 <vprintfmt+0x21>
			if (ch == '\0')
  800c81:	85 db                	test   %ebx,%ebx
  800c83:	0f 84 c1 03 00 00    	je     80104a <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  800c89:	83 ec 08             	sub    $0x8,%esp
  800c8c:	ff 75 0c             	pushl  0xc(%ebp)
  800c8f:	53                   	push   %ebx
  800c90:	8b 45 08             	mov    0x8(%ebp),%eax
  800c93:	ff d0                	call   *%eax
  800c95:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800c98:	8b 45 10             	mov    0x10(%ebp),%eax
  800c9b:	8d 50 01             	lea    0x1(%eax),%edx
  800c9e:	89 55 10             	mov    %edx,0x10(%ebp)
  800ca1:	8a 00                	mov    (%eax),%al
  800ca3:	0f b6 d8             	movzbl %al,%ebx
  800ca6:	83 fb 25             	cmp    $0x25,%ebx
  800ca9:	75 d6                	jne    800c81 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800cab:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800caf:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800cb6:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800cbd:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800cc4:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800ccb:	8b 45 10             	mov    0x10(%ebp),%eax
  800cce:	8d 50 01             	lea    0x1(%eax),%edx
  800cd1:	89 55 10             	mov    %edx,0x10(%ebp)
  800cd4:	8a 00                	mov    (%eax),%al
  800cd6:	0f b6 d8             	movzbl %al,%ebx
  800cd9:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800cdc:	83 f8 5b             	cmp    $0x5b,%eax
  800cdf:	0f 87 3d 03 00 00    	ja     801022 <vprintfmt+0x3ab>
  800ce5:	8b 04 85 18 36 80 00 	mov    0x803618(,%eax,4),%eax
  800cec:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800cee:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800cf2:	eb d7                	jmp    800ccb <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800cf4:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800cf8:	eb d1                	jmp    800ccb <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800cfa:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800d01:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800d04:	89 d0                	mov    %edx,%eax
  800d06:	c1 e0 02             	shl    $0x2,%eax
  800d09:	01 d0                	add    %edx,%eax
  800d0b:	01 c0                	add    %eax,%eax
  800d0d:	01 d8                	add    %ebx,%eax
  800d0f:	83 e8 30             	sub    $0x30,%eax
  800d12:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800d15:	8b 45 10             	mov    0x10(%ebp),%eax
  800d18:	8a 00                	mov    (%eax),%al
  800d1a:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800d1d:	83 fb 2f             	cmp    $0x2f,%ebx
  800d20:	7e 3e                	jle    800d60 <vprintfmt+0xe9>
  800d22:	83 fb 39             	cmp    $0x39,%ebx
  800d25:	7f 39                	jg     800d60 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800d27:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800d2a:	eb d5                	jmp    800d01 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800d2c:	8b 45 14             	mov    0x14(%ebp),%eax
  800d2f:	83 c0 04             	add    $0x4,%eax
  800d32:	89 45 14             	mov    %eax,0x14(%ebp)
  800d35:	8b 45 14             	mov    0x14(%ebp),%eax
  800d38:	83 e8 04             	sub    $0x4,%eax
  800d3b:	8b 00                	mov    (%eax),%eax
  800d3d:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800d40:	eb 1f                	jmp    800d61 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800d42:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800d46:	79 83                	jns    800ccb <vprintfmt+0x54>
				width = 0;
  800d48:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800d4f:	e9 77 ff ff ff       	jmp    800ccb <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800d54:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800d5b:	e9 6b ff ff ff       	jmp    800ccb <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800d60:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800d61:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800d65:	0f 89 60 ff ff ff    	jns    800ccb <vprintfmt+0x54>
				width = precision, precision = -1;
  800d6b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800d6e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800d71:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800d78:	e9 4e ff ff ff       	jmp    800ccb <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800d7d:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800d80:	e9 46 ff ff ff       	jmp    800ccb <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800d85:	8b 45 14             	mov    0x14(%ebp),%eax
  800d88:	83 c0 04             	add    $0x4,%eax
  800d8b:	89 45 14             	mov    %eax,0x14(%ebp)
  800d8e:	8b 45 14             	mov    0x14(%ebp),%eax
  800d91:	83 e8 04             	sub    $0x4,%eax
  800d94:	8b 00                	mov    (%eax),%eax
  800d96:	83 ec 08             	sub    $0x8,%esp
  800d99:	ff 75 0c             	pushl  0xc(%ebp)
  800d9c:	50                   	push   %eax
  800d9d:	8b 45 08             	mov    0x8(%ebp),%eax
  800da0:	ff d0                	call   *%eax
  800da2:	83 c4 10             	add    $0x10,%esp
			break;
  800da5:	e9 9b 02 00 00       	jmp    801045 <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800daa:	8b 45 14             	mov    0x14(%ebp),%eax
  800dad:	83 c0 04             	add    $0x4,%eax
  800db0:	89 45 14             	mov    %eax,0x14(%ebp)
  800db3:	8b 45 14             	mov    0x14(%ebp),%eax
  800db6:	83 e8 04             	sub    $0x4,%eax
  800db9:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800dbb:	85 db                	test   %ebx,%ebx
  800dbd:	79 02                	jns    800dc1 <vprintfmt+0x14a>
				err = -err;
  800dbf:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800dc1:	83 fb 64             	cmp    $0x64,%ebx
  800dc4:	7f 0b                	jg     800dd1 <vprintfmt+0x15a>
  800dc6:	8b 34 9d 60 34 80 00 	mov    0x803460(,%ebx,4),%esi
  800dcd:	85 f6                	test   %esi,%esi
  800dcf:	75 19                	jne    800dea <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800dd1:	53                   	push   %ebx
  800dd2:	68 05 36 80 00       	push   $0x803605
  800dd7:	ff 75 0c             	pushl  0xc(%ebp)
  800dda:	ff 75 08             	pushl  0x8(%ebp)
  800ddd:	e8 70 02 00 00       	call   801052 <printfmt>
  800de2:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800de5:	e9 5b 02 00 00       	jmp    801045 <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800dea:	56                   	push   %esi
  800deb:	68 0e 36 80 00       	push   $0x80360e
  800df0:	ff 75 0c             	pushl  0xc(%ebp)
  800df3:	ff 75 08             	pushl  0x8(%ebp)
  800df6:	e8 57 02 00 00       	call   801052 <printfmt>
  800dfb:	83 c4 10             	add    $0x10,%esp
			break;
  800dfe:	e9 42 02 00 00       	jmp    801045 <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800e03:	8b 45 14             	mov    0x14(%ebp),%eax
  800e06:	83 c0 04             	add    $0x4,%eax
  800e09:	89 45 14             	mov    %eax,0x14(%ebp)
  800e0c:	8b 45 14             	mov    0x14(%ebp),%eax
  800e0f:	83 e8 04             	sub    $0x4,%eax
  800e12:	8b 30                	mov    (%eax),%esi
  800e14:	85 f6                	test   %esi,%esi
  800e16:	75 05                	jne    800e1d <vprintfmt+0x1a6>
				p = "(null)";
  800e18:	be 11 36 80 00       	mov    $0x803611,%esi
			if (width > 0 && padc != '-')
  800e1d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800e21:	7e 6d                	jle    800e90 <vprintfmt+0x219>
  800e23:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800e27:	74 67                	je     800e90 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800e29:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800e2c:	83 ec 08             	sub    $0x8,%esp
  800e2f:	50                   	push   %eax
  800e30:	56                   	push   %esi
  800e31:	e8 26 05 00 00       	call   80135c <strnlen>
  800e36:	83 c4 10             	add    $0x10,%esp
  800e39:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800e3c:	eb 16                	jmp    800e54 <vprintfmt+0x1dd>
					putch(padc, putdat);
  800e3e:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800e42:	83 ec 08             	sub    $0x8,%esp
  800e45:	ff 75 0c             	pushl  0xc(%ebp)
  800e48:	50                   	push   %eax
  800e49:	8b 45 08             	mov    0x8(%ebp),%eax
  800e4c:	ff d0                	call   *%eax
  800e4e:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800e51:	ff 4d e4             	decl   -0x1c(%ebp)
  800e54:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800e58:	7f e4                	jg     800e3e <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800e5a:	eb 34                	jmp    800e90 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800e5c:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800e60:	74 1c                	je     800e7e <vprintfmt+0x207>
  800e62:	83 fb 1f             	cmp    $0x1f,%ebx
  800e65:	7e 05                	jle    800e6c <vprintfmt+0x1f5>
  800e67:	83 fb 7e             	cmp    $0x7e,%ebx
  800e6a:	7e 12                	jle    800e7e <vprintfmt+0x207>
					putch('?', putdat);
  800e6c:	83 ec 08             	sub    $0x8,%esp
  800e6f:	ff 75 0c             	pushl  0xc(%ebp)
  800e72:	6a 3f                	push   $0x3f
  800e74:	8b 45 08             	mov    0x8(%ebp),%eax
  800e77:	ff d0                	call   *%eax
  800e79:	83 c4 10             	add    $0x10,%esp
  800e7c:	eb 0f                	jmp    800e8d <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800e7e:	83 ec 08             	sub    $0x8,%esp
  800e81:	ff 75 0c             	pushl  0xc(%ebp)
  800e84:	53                   	push   %ebx
  800e85:	8b 45 08             	mov    0x8(%ebp),%eax
  800e88:	ff d0                	call   *%eax
  800e8a:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800e8d:	ff 4d e4             	decl   -0x1c(%ebp)
  800e90:	89 f0                	mov    %esi,%eax
  800e92:	8d 70 01             	lea    0x1(%eax),%esi
  800e95:	8a 00                	mov    (%eax),%al
  800e97:	0f be d8             	movsbl %al,%ebx
  800e9a:	85 db                	test   %ebx,%ebx
  800e9c:	74 24                	je     800ec2 <vprintfmt+0x24b>
  800e9e:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800ea2:	78 b8                	js     800e5c <vprintfmt+0x1e5>
  800ea4:	ff 4d e0             	decl   -0x20(%ebp)
  800ea7:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800eab:	79 af                	jns    800e5c <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800ead:	eb 13                	jmp    800ec2 <vprintfmt+0x24b>
				putch(' ', putdat);
  800eaf:	83 ec 08             	sub    $0x8,%esp
  800eb2:	ff 75 0c             	pushl  0xc(%ebp)
  800eb5:	6a 20                	push   $0x20
  800eb7:	8b 45 08             	mov    0x8(%ebp),%eax
  800eba:	ff d0                	call   *%eax
  800ebc:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800ebf:	ff 4d e4             	decl   -0x1c(%ebp)
  800ec2:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800ec6:	7f e7                	jg     800eaf <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800ec8:	e9 78 01 00 00       	jmp    801045 <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800ecd:	83 ec 08             	sub    $0x8,%esp
  800ed0:	ff 75 e8             	pushl  -0x18(%ebp)
  800ed3:	8d 45 14             	lea    0x14(%ebp),%eax
  800ed6:	50                   	push   %eax
  800ed7:	e8 3c fd ff ff       	call   800c18 <getint>
  800edc:	83 c4 10             	add    $0x10,%esp
  800edf:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800ee2:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800ee5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800ee8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800eeb:	85 d2                	test   %edx,%edx
  800eed:	79 23                	jns    800f12 <vprintfmt+0x29b>
				putch('-', putdat);
  800eef:	83 ec 08             	sub    $0x8,%esp
  800ef2:	ff 75 0c             	pushl  0xc(%ebp)
  800ef5:	6a 2d                	push   $0x2d
  800ef7:	8b 45 08             	mov    0x8(%ebp),%eax
  800efa:	ff d0                	call   *%eax
  800efc:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800eff:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800f02:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800f05:	f7 d8                	neg    %eax
  800f07:	83 d2 00             	adc    $0x0,%edx
  800f0a:	f7 da                	neg    %edx
  800f0c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800f0f:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800f12:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800f19:	e9 bc 00 00 00       	jmp    800fda <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800f1e:	83 ec 08             	sub    $0x8,%esp
  800f21:	ff 75 e8             	pushl  -0x18(%ebp)
  800f24:	8d 45 14             	lea    0x14(%ebp),%eax
  800f27:	50                   	push   %eax
  800f28:	e8 84 fc ff ff       	call   800bb1 <getuint>
  800f2d:	83 c4 10             	add    $0x10,%esp
  800f30:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800f33:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800f36:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800f3d:	e9 98 00 00 00       	jmp    800fda <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800f42:	83 ec 08             	sub    $0x8,%esp
  800f45:	ff 75 0c             	pushl  0xc(%ebp)
  800f48:	6a 58                	push   $0x58
  800f4a:	8b 45 08             	mov    0x8(%ebp),%eax
  800f4d:	ff d0                	call   *%eax
  800f4f:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800f52:	83 ec 08             	sub    $0x8,%esp
  800f55:	ff 75 0c             	pushl  0xc(%ebp)
  800f58:	6a 58                	push   $0x58
  800f5a:	8b 45 08             	mov    0x8(%ebp),%eax
  800f5d:	ff d0                	call   *%eax
  800f5f:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800f62:	83 ec 08             	sub    $0x8,%esp
  800f65:	ff 75 0c             	pushl  0xc(%ebp)
  800f68:	6a 58                	push   $0x58
  800f6a:	8b 45 08             	mov    0x8(%ebp),%eax
  800f6d:	ff d0                	call   *%eax
  800f6f:	83 c4 10             	add    $0x10,%esp
			break;
  800f72:	e9 ce 00 00 00       	jmp    801045 <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  800f77:	83 ec 08             	sub    $0x8,%esp
  800f7a:	ff 75 0c             	pushl  0xc(%ebp)
  800f7d:	6a 30                	push   $0x30
  800f7f:	8b 45 08             	mov    0x8(%ebp),%eax
  800f82:	ff d0                	call   *%eax
  800f84:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800f87:	83 ec 08             	sub    $0x8,%esp
  800f8a:	ff 75 0c             	pushl  0xc(%ebp)
  800f8d:	6a 78                	push   $0x78
  800f8f:	8b 45 08             	mov    0x8(%ebp),%eax
  800f92:	ff d0                	call   *%eax
  800f94:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800f97:	8b 45 14             	mov    0x14(%ebp),%eax
  800f9a:	83 c0 04             	add    $0x4,%eax
  800f9d:	89 45 14             	mov    %eax,0x14(%ebp)
  800fa0:	8b 45 14             	mov    0x14(%ebp),%eax
  800fa3:	83 e8 04             	sub    $0x4,%eax
  800fa6:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800fa8:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800fab:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800fb2:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800fb9:	eb 1f                	jmp    800fda <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800fbb:	83 ec 08             	sub    $0x8,%esp
  800fbe:	ff 75 e8             	pushl  -0x18(%ebp)
  800fc1:	8d 45 14             	lea    0x14(%ebp),%eax
  800fc4:	50                   	push   %eax
  800fc5:	e8 e7 fb ff ff       	call   800bb1 <getuint>
  800fca:	83 c4 10             	add    $0x10,%esp
  800fcd:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800fd0:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800fd3:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800fda:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800fde:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800fe1:	83 ec 04             	sub    $0x4,%esp
  800fe4:	52                   	push   %edx
  800fe5:	ff 75 e4             	pushl  -0x1c(%ebp)
  800fe8:	50                   	push   %eax
  800fe9:	ff 75 f4             	pushl  -0xc(%ebp)
  800fec:	ff 75 f0             	pushl  -0x10(%ebp)
  800fef:	ff 75 0c             	pushl  0xc(%ebp)
  800ff2:	ff 75 08             	pushl  0x8(%ebp)
  800ff5:	e8 00 fb ff ff       	call   800afa <printnum>
  800ffa:	83 c4 20             	add    $0x20,%esp
			break;
  800ffd:	eb 46                	jmp    801045 <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800fff:	83 ec 08             	sub    $0x8,%esp
  801002:	ff 75 0c             	pushl  0xc(%ebp)
  801005:	53                   	push   %ebx
  801006:	8b 45 08             	mov    0x8(%ebp),%eax
  801009:	ff d0                	call   *%eax
  80100b:	83 c4 10             	add    $0x10,%esp
			break;
  80100e:	eb 35                	jmp    801045 <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  801010:	c6 05 44 40 80 00 00 	movb   $0x0,0x804044
			break;
  801017:	eb 2c                	jmp    801045 <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  801019:	c6 05 44 40 80 00 01 	movb   $0x1,0x804044
			break;
  801020:	eb 23                	jmp    801045 <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  801022:	83 ec 08             	sub    $0x8,%esp
  801025:	ff 75 0c             	pushl  0xc(%ebp)
  801028:	6a 25                	push   $0x25
  80102a:	8b 45 08             	mov    0x8(%ebp),%eax
  80102d:	ff d0                	call   *%eax
  80102f:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  801032:	ff 4d 10             	decl   0x10(%ebp)
  801035:	eb 03                	jmp    80103a <vprintfmt+0x3c3>
  801037:	ff 4d 10             	decl   0x10(%ebp)
  80103a:	8b 45 10             	mov    0x10(%ebp),%eax
  80103d:	48                   	dec    %eax
  80103e:	8a 00                	mov    (%eax),%al
  801040:	3c 25                	cmp    $0x25,%al
  801042:	75 f3                	jne    801037 <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  801044:	90                   	nop
		}
	}
  801045:	e9 35 fc ff ff       	jmp    800c7f <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  80104a:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  80104b:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80104e:	5b                   	pop    %ebx
  80104f:	5e                   	pop    %esi
  801050:	5d                   	pop    %ebp
  801051:	c3                   	ret    

00801052 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  801052:	55                   	push   %ebp
  801053:	89 e5                	mov    %esp,%ebp
  801055:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  801058:	8d 45 10             	lea    0x10(%ebp),%eax
  80105b:	83 c0 04             	add    $0x4,%eax
  80105e:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  801061:	8b 45 10             	mov    0x10(%ebp),%eax
  801064:	ff 75 f4             	pushl  -0xc(%ebp)
  801067:	50                   	push   %eax
  801068:	ff 75 0c             	pushl  0xc(%ebp)
  80106b:	ff 75 08             	pushl  0x8(%ebp)
  80106e:	e8 04 fc ff ff       	call   800c77 <vprintfmt>
  801073:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  801076:	90                   	nop
  801077:	c9                   	leave  
  801078:	c3                   	ret    

00801079 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  801079:	55                   	push   %ebp
  80107a:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  80107c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80107f:	8b 40 08             	mov    0x8(%eax),%eax
  801082:	8d 50 01             	lea    0x1(%eax),%edx
  801085:	8b 45 0c             	mov    0xc(%ebp),%eax
  801088:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  80108b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80108e:	8b 10                	mov    (%eax),%edx
  801090:	8b 45 0c             	mov    0xc(%ebp),%eax
  801093:	8b 40 04             	mov    0x4(%eax),%eax
  801096:	39 c2                	cmp    %eax,%edx
  801098:	73 12                	jae    8010ac <sprintputch+0x33>
		*b->buf++ = ch;
  80109a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80109d:	8b 00                	mov    (%eax),%eax
  80109f:	8d 48 01             	lea    0x1(%eax),%ecx
  8010a2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8010a5:	89 0a                	mov    %ecx,(%edx)
  8010a7:	8b 55 08             	mov    0x8(%ebp),%edx
  8010aa:	88 10                	mov    %dl,(%eax)
}
  8010ac:	90                   	nop
  8010ad:	5d                   	pop    %ebp
  8010ae:	c3                   	ret    

008010af <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8010af:	55                   	push   %ebp
  8010b0:	89 e5                	mov    %esp,%ebp
  8010b2:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  8010b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8010b8:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8010bb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010be:	8d 50 ff             	lea    -0x1(%eax),%edx
  8010c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8010c4:	01 d0                	add    %edx,%eax
  8010c6:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8010c9:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  8010d0:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8010d4:	74 06                	je     8010dc <vsnprintf+0x2d>
  8010d6:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8010da:	7f 07                	jg     8010e3 <vsnprintf+0x34>
		return -E_INVAL;
  8010dc:	b8 03 00 00 00       	mov    $0x3,%eax
  8010e1:	eb 20                	jmp    801103 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8010e3:	ff 75 14             	pushl  0x14(%ebp)
  8010e6:	ff 75 10             	pushl  0x10(%ebp)
  8010e9:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8010ec:	50                   	push   %eax
  8010ed:	68 79 10 80 00       	push   $0x801079
  8010f2:	e8 80 fb ff ff       	call   800c77 <vprintfmt>
  8010f7:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  8010fa:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8010fd:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  801100:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  801103:	c9                   	leave  
  801104:	c3                   	ret    

00801105 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  801105:	55                   	push   %ebp
  801106:	89 e5                	mov    %esp,%ebp
  801108:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  80110b:	8d 45 10             	lea    0x10(%ebp),%eax
  80110e:	83 c0 04             	add    $0x4,%eax
  801111:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  801114:	8b 45 10             	mov    0x10(%ebp),%eax
  801117:	ff 75 f4             	pushl  -0xc(%ebp)
  80111a:	50                   	push   %eax
  80111b:	ff 75 0c             	pushl  0xc(%ebp)
  80111e:	ff 75 08             	pushl  0x8(%ebp)
  801121:	e8 89 ff ff ff       	call   8010af <vsnprintf>
  801126:	83 c4 10             	add    $0x10,%esp
  801129:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  80112c:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80112f:	c9                   	leave  
  801130:	c3                   	ret    

00801131 <readline>:
#include <inc/lib.h>

//static char buf[BUFLEN];

void readline(const char *prompt, char* buf)
{
  801131:	55                   	push   %ebp
  801132:	89 e5                	mov    %esp,%ebp
  801134:	83 ec 18             	sub    $0x18,%esp
	int i, c, echoing;

	if (prompt != NULL)
  801137:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80113b:	74 13                	je     801150 <readline+0x1f>
		cprintf("%s", prompt);
  80113d:	83 ec 08             	sub    $0x8,%esp
  801140:	ff 75 08             	pushl  0x8(%ebp)
  801143:	68 88 37 80 00       	push   $0x803788
  801148:	e8 0b f9 ff ff       	call   800a58 <cprintf>
  80114d:	83 c4 10             	add    $0x10,%esp

	i = 0;
  801150:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	echoing = iscons(0);
  801157:	83 ec 0c             	sub    $0xc,%esp
  80115a:	6a 00                	push   $0x0
  80115c:	e8 5a f4 ff ff       	call   8005bb <iscons>
  801161:	83 c4 10             	add    $0x10,%esp
  801164:	89 45 f0             	mov    %eax,-0x10(%ebp)
	while (1) {
		c = getchar();
  801167:	e8 3c f4 ff ff       	call   8005a8 <getchar>
  80116c:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if (c < 0) {
  80116f:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801173:	79 22                	jns    801197 <readline+0x66>
			if (c != -E_EOF)
  801175:	83 7d ec 07          	cmpl   $0x7,-0x14(%ebp)
  801179:	0f 84 ad 00 00 00    	je     80122c <readline+0xfb>
				cprintf("read error: %e\n", c);
  80117f:	83 ec 08             	sub    $0x8,%esp
  801182:	ff 75 ec             	pushl  -0x14(%ebp)
  801185:	68 8b 37 80 00       	push   $0x80378b
  80118a:	e8 c9 f8 ff ff       	call   800a58 <cprintf>
  80118f:	83 c4 10             	add    $0x10,%esp
			break;
  801192:	e9 95 00 00 00       	jmp    80122c <readline+0xfb>
		} else if (c >= ' ' && i < BUFLEN-1) {
  801197:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%ebp)
  80119b:	7e 34                	jle    8011d1 <readline+0xa0>
  80119d:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  8011a4:	7f 2b                	jg     8011d1 <readline+0xa0>
			if (echoing)
  8011a6:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8011aa:	74 0e                	je     8011ba <readline+0x89>
				cputchar(c);
  8011ac:	83 ec 0c             	sub    $0xc,%esp
  8011af:	ff 75 ec             	pushl  -0x14(%ebp)
  8011b2:	e8 d2 f3 ff ff       	call   800589 <cputchar>
  8011b7:	83 c4 10             	add    $0x10,%esp
			buf[i++] = c;
  8011ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8011bd:	8d 50 01             	lea    0x1(%eax),%edx
  8011c0:	89 55 f4             	mov    %edx,-0xc(%ebp)
  8011c3:	89 c2                	mov    %eax,%edx
  8011c5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011c8:	01 d0                	add    %edx,%eax
  8011ca:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8011cd:	88 10                	mov    %dl,(%eax)
  8011cf:	eb 56                	jmp    801227 <readline+0xf6>
		} else if (c == '\b' && i > 0) {
  8011d1:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  8011d5:	75 1f                	jne    8011f6 <readline+0xc5>
  8011d7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8011db:	7e 19                	jle    8011f6 <readline+0xc5>
			if (echoing)
  8011dd:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8011e1:	74 0e                	je     8011f1 <readline+0xc0>
				cputchar(c);
  8011e3:	83 ec 0c             	sub    $0xc,%esp
  8011e6:	ff 75 ec             	pushl  -0x14(%ebp)
  8011e9:	e8 9b f3 ff ff       	call   800589 <cputchar>
  8011ee:	83 c4 10             	add    $0x10,%esp

			i--;
  8011f1:	ff 4d f4             	decl   -0xc(%ebp)
  8011f4:	eb 31                	jmp    801227 <readline+0xf6>
		} else if (c == '\n' || c == '\r') {
  8011f6:	83 7d ec 0a          	cmpl   $0xa,-0x14(%ebp)
  8011fa:	74 0a                	je     801206 <readline+0xd5>
  8011fc:	83 7d ec 0d          	cmpl   $0xd,-0x14(%ebp)
  801200:	0f 85 61 ff ff ff    	jne    801167 <readline+0x36>
			if (echoing)
  801206:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80120a:	74 0e                	je     80121a <readline+0xe9>
				cputchar(c);
  80120c:	83 ec 0c             	sub    $0xc,%esp
  80120f:	ff 75 ec             	pushl  -0x14(%ebp)
  801212:	e8 72 f3 ff ff       	call   800589 <cputchar>
  801217:	83 c4 10             	add    $0x10,%esp

			buf[i] = 0;
  80121a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80121d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801220:	01 d0                	add    %edx,%eax
  801222:	c6 00 00             	movb   $0x0,(%eax)
			break;
  801225:	eb 06                	jmp    80122d <readline+0xfc>
		}
	}
  801227:	e9 3b ff ff ff       	jmp    801167 <readline+0x36>
	while (1) {
		c = getchar();
		if (c < 0) {
			if (c != -E_EOF)
				cprintf("read error: %e\n", c);
			break;
  80122c:	90                   	nop

			buf[i] = 0;
			break;
		}
	}
}
  80122d:	90                   	nop
  80122e:	c9                   	leave  
  80122f:	c3                   	ret    

00801230 <atomic_readline>:

void atomic_readline(const char *prompt, char* buf)
{
  801230:	55                   	push   %ebp
  801231:	89 e5                	mov    %esp,%ebp
  801233:	83 ec 18             	sub    $0x18,%esp
	sys_lock_cons();
  801236:	e8 30 0b 00 00       	call   801d6b <sys_lock_cons>
	{
		int i, c, echoing;

		if (prompt != NULL)
  80123b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80123f:	74 13                	je     801254 <atomic_readline+0x24>
			cprintf("%s", prompt);
  801241:	83 ec 08             	sub    $0x8,%esp
  801244:	ff 75 08             	pushl  0x8(%ebp)
  801247:	68 88 37 80 00       	push   $0x803788
  80124c:	e8 07 f8 ff ff       	call   800a58 <cprintf>
  801251:	83 c4 10             	add    $0x10,%esp

		i = 0;
  801254:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
		echoing = iscons(0);
  80125b:	83 ec 0c             	sub    $0xc,%esp
  80125e:	6a 00                	push   $0x0
  801260:	e8 56 f3 ff ff       	call   8005bb <iscons>
  801265:	83 c4 10             	add    $0x10,%esp
  801268:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (1) {
			c = getchar();
  80126b:	e8 38 f3 ff ff       	call   8005a8 <getchar>
  801270:	89 45 ec             	mov    %eax,-0x14(%ebp)
			if (c < 0) {
  801273:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801277:	79 22                	jns    80129b <atomic_readline+0x6b>
				if (c != -E_EOF)
  801279:	83 7d ec 07          	cmpl   $0x7,-0x14(%ebp)
  80127d:	0f 84 ad 00 00 00    	je     801330 <atomic_readline+0x100>
					cprintf("read error: %e\n", c);
  801283:	83 ec 08             	sub    $0x8,%esp
  801286:	ff 75 ec             	pushl  -0x14(%ebp)
  801289:	68 8b 37 80 00       	push   $0x80378b
  80128e:	e8 c5 f7 ff ff       	call   800a58 <cprintf>
  801293:	83 c4 10             	add    $0x10,%esp
				break;
  801296:	e9 95 00 00 00       	jmp    801330 <atomic_readline+0x100>
			} else if (c >= ' ' && i < BUFLEN-1) {
  80129b:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%ebp)
  80129f:	7e 34                	jle    8012d5 <atomic_readline+0xa5>
  8012a1:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  8012a8:	7f 2b                	jg     8012d5 <atomic_readline+0xa5>
				if (echoing)
  8012aa:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8012ae:	74 0e                	je     8012be <atomic_readline+0x8e>
					cputchar(c);
  8012b0:	83 ec 0c             	sub    $0xc,%esp
  8012b3:	ff 75 ec             	pushl  -0x14(%ebp)
  8012b6:	e8 ce f2 ff ff       	call   800589 <cputchar>
  8012bb:	83 c4 10             	add    $0x10,%esp
				buf[i++] = c;
  8012be:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8012c1:	8d 50 01             	lea    0x1(%eax),%edx
  8012c4:	89 55 f4             	mov    %edx,-0xc(%ebp)
  8012c7:	89 c2                	mov    %eax,%edx
  8012c9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012cc:	01 d0                	add    %edx,%eax
  8012ce:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8012d1:	88 10                	mov    %dl,(%eax)
  8012d3:	eb 56                	jmp    80132b <atomic_readline+0xfb>
			} else if (c == '\b' && i > 0) {
  8012d5:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  8012d9:	75 1f                	jne    8012fa <atomic_readline+0xca>
  8012db:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8012df:	7e 19                	jle    8012fa <atomic_readline+0xca>
				if (echoing)
  8012e1:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8012e5:	74 0e                	je     8012f5 <atomic_readline+0xc5>
					cputchar(c);
  8012e7:	83 ec 0c             	sub    $0xc,%esp
  8012ea:	ff 75 ec             	pushl  -0x14(%ebp)
  8012ed:	e8 97 f2 ff ff       	call   800589 <cputchar>
  8012f2:	83 c4 10             	add    $0x10,%esp
				i--;
  8012f5:	ff 4d f4             	decl   -0xc(%ebp)
  8012f8:	eb 31                	jmp    80132b <atomic_readline+0xfb>
			} else if (c == '\n' || c == '\r') {
  8012fa:	83 7d ec 0a          	cmpl   $0xa,-0x14(%ebp)
  8012fe:	74 0a                	je     80130a <atomic_readline+0xda>
  801300:	83 7d ec 0d          	cmpl   $0xd,-0x14(%ebp)
  801304:	0f 85 61 ff ff ff    	jne    80126b <atomic_readline+0x3b>
				if (echoing)
  80130a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80130e:	74 0e                	je     80131e <atomic_readline+0xee>
					cputchar(c);
  801310:	83 ec 0c             	sub    $0xc,%esp
  801313:	ff 75 ec             	pushl  -0x14(%ebp)
  801316:	e8 6e f2 ff ff       	call   800589 <cputchar>
  80131b:	83 c4 10             	add    $0x10,%esp
				buf[i] = 0;
  80131e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801321:	8b 45 0c             	mov    0xc(%ebp),%eax
  801324:	01 d0                	add    %edx,%eax
  801326:	c6 00 00             	movb   $0x0,(%eax)
				break;
  801329:	eb 06                	jmp    801331 <atomic_readline+0x101>
			}
		}
  80132b:	e9 3b ff ff ff       	jmp    80126b <atomic_readline+0x3b>
		while (1) {
			c = getchar();
			if (c < 0) {
				if (c != -E_EOF)
					cprintf("read error: %e\n", c);
				break;
  801330:	90                   	nop
				buf[i] = 0;
				break;
			}
		}
	}
	sys_unlock_cons();
  801331:	e8 4f 0a 00 00       	call   801d85 <sys_unlock_cons>
}
  801336:	90                   	nop
  801337:	c9                   	leave  
  801338:	c3                   	ret    

00801339 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  801339:	55                   	push   %ebp
  80133a:	89 e5                	mov    %esp,%ebp
  80133c:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  80133f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801346:	eb 06                	jmp    80134e <strlen+0x15>
		n++;
  801348:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  80134b:	ff 45 08             	incl   0x8(%ebp)
  80134e:	8b 45 08             	mov    0x8(%ebp),%eax
  801351:	8a 00                	mov    (%eax),%al
  801353:	84 c0                	test   %al,%al
  801355:	75 f1                	jne    801348 <strlen+0xf>
		n++;
	return n;
  801357:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  80135a:	c9                   	leave  
  80135b:	c3                   	ret    

0080135c <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  80135c:	55                   	push   %ebp
  80135d:	89 e5                	mov    %esp,%ebp
  80135f:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801362:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801369:	eb 09                	jmp    801374 <strnlen+0x18>
		n++;
  80136b:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80136e:	ff 45 08             	incl   0x8(%ebp)
  801371:	ff 4d 0c             	decl   0xc(%ebp)
  801374:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801378:	74 09                	je     801383 <strnlen+0x27>
  80137a:	8b 45 08             	mov    0x8(%ebp),%eax
  80137d:	8a 00                	mov    (%eax),%al
  80137f:	84 c0                	test   %al,%al
  801381:	75 e8                	jne    80136b <strnlen+0xf>
		n++;
	return n;
  801383:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801386:	c9                   	leave  
  801387:	c3                   	ret    

00801388 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  801388:	55                   	push   %ebp
  801389:	89 e5                	mov    %esp,%ebp
  80138b:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  80138e:	8b 45 08             	mov    0x8(%ebp),%eax
  801391:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  801394:	90                   	nop
  801395:	8b 45 08             	mov    0x8(%ebp),%eax
  801398:	8d 50 01             	lea    0x1(%eax),%edx
  80139b:	89 55 08             	mov    %edx,0x8(%ebp)
  80139e:	8b 55 0c             	mov    0xc(%ebp),%edx
  8013a1:	8d 4a 01             	lea    0x1(%edx),%ecx
  8013a4:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  8013a7:	8a 12                	mov    (%edx),%dl
  8013a9:	88 10                	mov    %dl,(%eax)
  8013ab:	8a 00                	mov    (%eax),%al
  8013ad:	84 c0                	test   %al,%al
  8013af:	75 e4                	jne    801395 <strcpy+0xd>
		/* do nothing */;
	return ret;
  8013b1:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8013b4:	c9                   	leave  
  8013b5:	c3                   	ret    

008013b6 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  8013b6:	55                   	push   %ebp
  8013b7:	89 e5                	mov    %esp,%ebp
  8013b9:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  8013bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8013bf:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  8013c2:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8013c9:	eb 1f                	jmp    8013ea <strncpy+0x34>
		*dst++ = *src;
  8013cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8013ce:	8d 50 01             	lea    0x1(%eax),%edx
  8013d1:	89 55 08             	mov    %edx,0x8(%ebp)
  8013d4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8013d7:	8a 12                	mov    (%edx),%dl
  8013d9:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  8013db:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013de:	8a 00                	mov    (%eax),%al
  8013e0:	84 c0                	test   %al,%al
  8013e2:	74 03                	je     8013e7 <strncpy+0x31>
			src++;
  8013e4:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8013e7:	ff 45 fc             	incl   -0x4(%ebp)
  8013ea:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8013ed:	3b 45 10             	cmp    0x10(%ebp),%eax
  8013f0:	72 d9                	jb     8013cb <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  8013f2:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8013f5:	c9                   	leave  
  8013f6:	c3                   	ret    

008013f7 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  8013f7:	55                   	push   %ebp
  8013f8:	89 e5                	mov    %esp,%ebp
  8013fa:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  8013fd:	8b 45 08             	mov    0x8(%ebp),%eax
  801400:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  801403:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801407:	74 30                	je     801439 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  801409:	eb 16                	jmp    801421 <strlcpy+0x2a>
			*dst++ = *src++;
  80140b:	8b 45 08             	mov    0x8(%ebp),%eax
  80140e:	8d 50 01             	lea    0x1(%eax),%edx
  801411:	89 55 08             	mov    %edx,0x8(%ebp)
  801414:	8b 55 0c             	mov    0xc(%ebp),%edx
  801417:	8d 4a 01             	lea    0x1(%edx),%ecx
  80141a:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  80141d:	8a 12                	mov    (%edx),%dl
  80141f:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  801421:	ff 4d 10             	decl   0x10(%ebp)
  801424:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801428:	74 09                	je     801433 <strlcpy+0x3c>
  80142a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80142d:	8a 00                	mov    (%eax),%al
  80142f:	84 c0                	test   %al,%al
  801431:	75 d8                	jne    80140b <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  801433:	8b 45 08             	mov    0x8(%ebp),%eax
  801436:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  801439:	8b 55 08             	mov    0x8(%ebp),%edx
  80143c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80143f:	29 c2                	sub    %eax,%edx
  801441:	89 d0                	mov    %edx,%eax
}
  801443:	c9                   	leave  
  801444:	c3                   	ret    

00801445 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  801445:	55                   	push   %ebp
  801446:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  801448:	eb 06                	jmp    801450 <strcmp+0xb>
		p++, q++;
  80144a:	ff 45 08             	incl   0x8(%ebp)
  80144d:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  801450:	8b 45 08             	mov    0x8(%ebp),%eax
  801453:	8a 00                	mov    (%eax),%al
  801455:	84 c0                	test   %al,%al
  801457:	74 0e                	je     801467 <strcmp+0x22>
  801459:	8b 45 08             	mov    0x8(%ebp),%eax
  80145c:	8a 10                	mov    (%eax),%dl
  80145e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801461:	8a 00                	mov    (%eax),%al
  801463:	38 c2                	cmp    %al,%dl
  801465:	74 e3                	je     80144a <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  801467:	8b 45 08             	mov    0x8(%ebp),%eax
  80146a:	8a 00                	mov    (%eax),%al
  80146c:	0f b6 d0             	movzbl %al,%edx
  80146f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801472:	8a 00                	mov    (%eax),%al
  801474:	0f b6 c0             	movzbl %al,%eax
  801477:	29 c2                	sub    %eax,%edx
  801479:	89 d0                	mov    %edx,%eax
}
  80147b:	5d                   	pop    %ebp
  80147c:	c3                   	ret    

0080147d <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  80147d:	55                   	push   %ebp
  80147e:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  801480:	eb 09                	jmp    80148b <strncmp+0xe>
		n--, p++, q++;
  801482:	ff 4d 10             	decl   0x10(%ebp)
  801485:	ff 45 08             	incl   0x8(%ebp)
  801488:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  80148b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80148f:	74 17                	je     8014a8 <strncmp+0x2b>
  801491:	8b 45 08             	mov    0x8(%ebp),%eax
  801494:	8a 00                	mov    (%eax),%al
  801496:	84 c0                	test   %al,%al
  801498:	74 0e                	je     8014a8 <strncmp+0x2b>
  80149a:	8b 45 08             	mov    0x8(%ebp),%eax
  80149d:	8a 10                	mov    (%eax),%dl
  80149f:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014a2:	8a 00                	mov    (%eax),%al
  8014a4:	38 c2                	cmp    %al,%dl
  8014a6:	74 da                	je     801482 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  8014a8:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8014ac:	75 07                	jne    8014b5 <strncmp+0x38>
		return 0;
  8014ae:	b8 00 00 00 00       	mov    $0x0,%eax
  8014b3:	eb 14                	jmp    8014c9 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8014b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8014b8:	8a 00                	mov    (%eax),%al
  8014ba:	0f b6 d0             	movzbl %al,%edx
  8014bd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014c0:	8a 00                	mov    (%eax),%al
  8014c2:	0f b6 c0             	movzbl %al,%eax
  8014c5:	29 c2                	sub    %eax,%edx
  8014c7:	89 d0                	mov    %edx,%eax
}
  8014c9:	5d                   	pop    %ebp
  8014ca:	c3                   	ret    

008014cb <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8014cb:	55                   	push   %ebp
  8014cc:	89 e5                	mov    %esp,%ebp
  8014ce:	83 ec 04             	sub    $0x4,%esp
  8014d1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014d4:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  8014d7:	eb 12                	jmp    8014eb <strchr+0x20>
		if (*s == c)
  8014d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8014dc:	8a 00                	mov    (%eax),%al
  8014de:	3a 45 fc             	cmp    -0x4(%ebp),%al
  8014e1:	75 05                	jne    8014e8 <strchr+0x1d>
			return (char *) s;
  8014e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8014e6:	eb 11                	jmp    8014f9 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  8014e8:	ff 45 08             	incl   0x8(%ebp)
  8014eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8014ee:	8a 00                	mov    (%eax),%al
  8014f0:	84 c0                	test   %al,%al
  8014f2:	75 e5                	jne    8014d9 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  8014f4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8014f9:	c9                   	leave  
  8014fa:	c3                   	ret    

008014fb <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8014fb:	55                   	push   %ebp
  8014fc:	89 e5                	mov    %esp,%ebp
  8014fe:	83 ec 04             	sub    $0x4,%esp
  801501:	8b 45 0c             	mov    0xc(%ebp),%eax
  801504:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  801507:	eb 0d                	jmp    801516 <strfind+0x1b>
		if (*s == c)
  801509:	8b 45 08             	mov    0x8(%ebp),%eax
  80150c:	8a 00                	mov    (%eax),%al
  80150e:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801511:	74 0e                	je     801521 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  801513:	ff 45 08             	incl   0x8(%ebp)
  801516:	8b 45 08             	mov    0x8(%ebp),%eax
  801519:	8a 00                	mov    (%eax),%al
  80151b:	84 c0                	test   %al,%al
  80151d:	75 ea                	jne    801509 <strfind+0xe>
  80151f:	eb 01                	jmp    801522 <strfind+0x27>
		if (*s == c)
			break;
  801521:	90                   	nop
	return (char *) s;
  801522:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801525:	c9                   	leave  
  801526:	c3                   	ret    

00801527 <memset>:

// *************** The faster implementation of memset & memcpy is implemented by *************
// ****************** Team80 (Yahia Khaled, Malek Ahmed et al) - FCIS'24-25 *******************
void *
memset(void *v, int c, uint32 n)
{
  801527:	55                   	push   %ebp
  801528:	89 e5                	mov    %esp,%ebp
  80152a:	83 ec 10             	sub    $0x10,%esp
//	m = n;
//	while (--m >= 0)
//		*p++ = c;

	/*Faster Implementation*/
	uint64* p64 = (uint64*)v;
  80152d:	8b 45 08             	mov    0x8(%ebp),%eax
  801530:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if(n >= 8){
  801533:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  801537:	76 63                	jbe    80159c <memset+0x75>
		uint64 data_block = c;
  801539:	8b 45 0c             	mov    0xc(%ebp),%eax
  80153c:	99                   	cltd   
  80153d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801540:	89 55 f4             	mov    %edx,-0xc(%ebp)
		data_block |= data_block << 8;
  801543:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801546:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801549:	0f a4 c2 08          	shld   $0x8,%eax,%edx
  80154d:	c1 e0 08             	shl    $0x8,%eax
  801550:	09 45 f0             	or     %eax,-0x10(%ebp)
  801553:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 16;
  801556:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801559:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80155c:	0f a4 c2 10          	shld   $0x10,%eax,%edx
  801560:	c1 e0 10             	shl    $0x10,%eax
  801563:	09 45 f0             	or     %eax,-0x10(%ebp)
  801566:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 32;
  801569:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80156c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80156f:	89 c2                	mov    %eax,%edx
  801571:	b8 00 00 00 00       	mov    $0x0,%eax
  801576:	09 45 f0             	or     %eax,-0x10(%ebp)
  801579:	09 55 f4             	or     %edx,-0xc(%ebp)

		while(n >= 8)
  80157c:	eb 18                	jmp    801596 <memset+0x6f>
			*p64++ = data_block, n -= 8;
  80157e:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801581:	8d 41 08             	lea    0x8(%ecx),%eax
  801584:	89 45 fc             	mov    %eax,-0x4(%ebp)
  801587:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80158a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80158d:	89 01                	mov    %eax,(%ecx)
  80158f:	89 51 04             	mov    %edx,0x4(%ecx)
  801592:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
		uint64 data_block = c;
		data_block |= data_block << 8;
		data_block |= data_block << 16;
		data_block |= data_block << 32;

		while(n >= 8)
  801596:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  80159a:	77 e2                	ja     80157e <memset+0x57>
			*p64++ = data_block, n -= 8;
	}

	if(n){
  80159c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8015a0:	74 23                	je     8015c5 <memset+0x9e>
		uint8* p8 = (uint8*)p64;
  8015a2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8015a5:	89 45 f8             	mov    %eax,-0x8(%ebp)
		while (n-- > 0)
  8015a8:	eb 0e                	jmp    8015b8 <memset+0x91>
			*p8++ = (uint8)c;
  8015aa:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8015ad:	8d 50 01             	lea    0x1(%eax),%edx
  8015b0:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8015b3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8015b6:	88 10                	mov    %dl,(%eax)
			*p64++ = data_block, n -= 8;
	}

	if(n){
		uint8* p8 = (uint8*)p64;
		while (n-- > 0)
  8015b8:	8b 45 10             	mov    0x10(%ebp),%eax
  8015bb:	8d 50 ff             	lea    -0x1(%eax),%edx
  8015be:	89 55 10             	mov    %edx,0x10(%ebp)
  8015c1:	85 c0                	test   %eax,%eax
  8015c3:	75 e5                	jne    8015aa <memset+0x83>
			*p8++ = (uint8)c;
	}

	return v;
  8015c5:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8015c8:	c9                   	leave  
  8015c9:	c3                   	ret    

008015ca <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  8015ca:	55                   	push   %ebp
  8015cb:	89 e5                	mov    %esp,%ebp
  8015cd:	83 ec 10             	sub    $0x10,%esp
	//	s = src;
	//	d = dst;
	//	while (n-- > 0)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
  8015d0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015d3:	89 45 fc             	mov    %eax,-0x4(%ebp)
	uint64* d64 = (uint64*)dst;
  8015d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8015d9:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if(n >= 8){
  8015dc:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  8015e0:	76 24                	jbe    801606 <memcpy+0x3c>
		while(n >= 8){
  8015e2:	eb 1c                	jmp    801600 <memcpy+0x36>
			*d64 = *s64;
  8015e4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8015e7:	8b 50 04             	mov    0x4(%eax),%edx
  8015ea:	8b 00                	mov    (%eax),%eax
  8015ec:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8015ef:	89 01                	mov    %eax,(%ecx)
  8015f1:	89 51 04             	mov    %edx,0x4(%ecx)
			n -= 8;
  8015f4:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
			++s64;
  8015f8:	83 45 fc 08          	addl   $0x8,-0x4(%ebp)
			++d64;
  8015fc:	83 45 f8 08          	addl   $0x8,-0x8(%ebp)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
	uint64* d64 = (uint64*)dst;
	if(n >= 8){
		while(n >= 8){
  801600:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  801604:	77 de                	ja     8015e4 <memcpy+0x1a>
			++s64;
			++d64;
		}
	}

	if(n){
  801606:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80160a:	74 31                	je     80163d <memcpy+0x73>
		uint8* s8 = (uint8*)s64;
  80160c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80160f:	89 45 f4             	mov    %eax,-0xc(%ebp)
		uint8* d8 = (uint8*)d64;
  801612:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801615:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (n-- > 0)
  801618:	eb 16                	jmp    801630 <memcpy+0x66>
			*d8++ = *s8++;
  80161a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80161d:	8d 50 01             	lea    0x1(%eax),%edx
  801620:	89 55 f0             	mov    %edx,-0x10(%ebp)
  801623:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801626:	8d 4a 01             	lea    0x1(%edx),%ecx
  801629:	89 4d f4             	mov    %ecx,-0xc(%ebp)
  80162c:	8a 12                	mov    (%edx),%dl
  80162e:	88 10                	mov    %dl,(%eax)
	}

	if(n){
		uint8* s8 = (uint8*)s64;
		uint8* d8 = (uint8*)d64;
		while (n-- > 0)
  801630:	8b 45 10             	mov    0x10(%ebp),%eax
  801633:	8d 50 ff             	lea    -0x1(%eax),%edx
  801636:	89 55 10             	mov    %edx,0x10(%ebp)
  801639:	85 c0                	test   %eax,%eax
  80163b:	75 dd                	jne    80161a <memcpy+0x50>
			*d8++ = *s8++;
	}
	return dst;
  80163d:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801640:	c9                   	leave  
  801641:	c3                   	ret    

00801642 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  801642:	55                   	push   %ebp
  801643:	89 e5                	mov    %esp,%ebp
  801645:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801648:	8b 45 0c             	mov    0xc(%ebp),%eax
  80164b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  80164e:	8b 45 08             	mov    0x8(%ebp),%eax
  801651:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  801654:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801657:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  80165a:	73 50                	jae    8016ac <memmove+0x6a>
  80165c:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80165f:	8b 45 10             	mov    0x10(%ebp),%eax
  801662:	01 d0                	add    %edx,%eax
  801664:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801667:	76 43                	jbe    8016ac <memmove+0x6a>
		s += n;
  801669:	8b 45 10             	mov    0x10(%ebp),%eax
  80166c:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  80166f:	8b 45 10             	mov    0x10(%ebp),%eax
  801672:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  801675:	eb 10                	jmp    801687 <memmove+0x45>
			*--d = *--s;
  801677:	ff 4d f8             	decl   -0x8(%ebp)
  80167a:	ff 4d fc             	decl   -0x4(%ebp)
  80167d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801680:	8a 10                	mov    (%eax),%dl
  801682:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801685:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  801687:	8b 45 10             	mov    0x10(%ebp),%eax
  80168a:	8d 50 ff             	lea    -0x1(%eax),%edx
  80168d:	89 55 10             	mov    %edx,0x10(%ebp)
  801690:	85 c0                	test   %eax,%eax
  801692:	75 e3                	jne    801677 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  801694:	eb 23                	jmp    8016b9 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  801696:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801699:	8d 50 01             	lea    0x1(%eax),%edx
  80169c:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80169f:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8016a2:	8d 4a 01             	lea    0x1(%edx),%ecx
  8016a5:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  8016a8:	8a 12                	mov    (%edx),%dl
  8016aa:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  8016ac:	8b 45 10             	mov    0x10(%ebp),%eax
  8016af:	8d 50 ff             	lea    -0x1(%eax),%edx
  8016b2:	89 55 10             	mov    %edx,0x10(%ebp)
  8016b5:	85 c0                	test   %eax,%eax
  8016b7:	75 dd                	jne    801696 <memmove+0x54>
			*d++ = *s++;

	return dst;
  8016b9:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8016bc:	c9                   	leave  
  8016bd:	c3                   	ret    

008016be <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  8016be:	55                   	push   %ebp
  8016bf:	89 e5                	mov    %esp,%ebp
  8016c1:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  8016c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8016c7:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  8016ca:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016cd:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  8016d0:	eb 2a                	jmp    8016fc <memcmp+0x3e>
		if (*s1 != *s2)
  8016d2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8016d5:	8a 10                	mov    (%eax),%dl
  8016d7:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8016da:	8a 00                	mov    (%eax),%al
  8016dc:	38 c2                	cmp    %al,%dl
  8016de:	74 16                	je     8016f6 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  8016e0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8016e3:	8a 00                	mov    (%eax),%al
  8016e5:	0f b6 d0             	movzbl %al,%edx
  8016e8:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8016eb:	8a 00                	mov    (%eax),%al
  8016ed:	0f b6 c0             	movzbl %al,%eax
  8016f0:	29 c2                	sub    %eax,%edx
  8016f2:	89 d0                	mov    %edx,%eax
  8016f4:	eb 18                	jmp    80170e <memcmp+0x50>
		s1++, s2++;
  8016f6:	ff 45 fc             	incl   -0x4(%ebp)
  8016f9:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  8016fc:	8b 45 10             	mov    0x10(%ebp),%eax
  8016ff:	8d 50 ff             	lea    -0x1(%eax),%edx
  801702:	89 55 10             	mov    %edx,0x10(%ebp)
  801705:	85 c0                	test   %eax,%eax
  801707:	75 c9                	jne    8016d2 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801709:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80170e:	c9                   	leave  
  80170f:	c3                   	ret    

00801710 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  801710:	55                   	push   %ebp
  801711:	89 e5                	mov    %esp,%ebp
  801713:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  801716:	8b 55 08             	mov    0x8(%ebp),%edx
  801719:	8b 45 10             	mov    0x10(%ebp),%eax
  80171c:	01 d0                	add    %edx,%eax
  80171e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  801721:	eb 15                	jmp    801738 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  801723:	8b 45 08             	mov    0x8(%ebp),%eax
  801726:	8a 00                	mov    (%eax),%al
  801728:	0f b6 d0             	movzbl %al,%edx
  80172b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80172e:	0f b6 c0             	movzbl %al,%eax
  801731:	39 c2                	cmp    %eax,%edx
  801733:	74 0d                	je     801742 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801735:	ff 45 08             	incl   0x8(%ebp)
  801738:	8b 45 08             	mov    0x8(%ebp),%eax
  80173b:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  80173e:	72 e3                	jb     801723 <memfind+0x13>
  801740:	eb 01                	jmp    801743 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  801742:	90                   	nop
	return (void *) s;
  801743:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801746:	c9                   	leave  
  801747:	c3                   	ret    

00801748 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801748:	55                   	push   %ebp
  801749:	89 e5                	mov    %esp,%ebp
  80174b:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  80174e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  801755:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80175c:	eb 03                	jmp    801761 <strtol+0x19>
		s++;
  80175e:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801761:	8b 45 08             	mov    0x8(%ebp),%eax
  801764:	8a 00                	mov    (%eax),%al
  801766:	3c 20                	cmp    $0x20,%al
  801768:	74 f4                	je     80175e <strtol+0x16>
  80176a:	8b 45 08             	mov    0x8(%ebp),%eax
  80176d:	8a 00                	mov    (%eax),%al
  80176f:	3c 09                	cmp    $0x9,%al
  801771:	74 eb                	je     80175e <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  801773:	8b 45 08             	mov    0x8(%ebp),%eax
  801776:	8a 00                	mov    (%eax),%al
  801778:	3c 2b                	cmp    $0x2b,%al
  80177a:	75 05                	jne    801781 <strtol+0x39>
		s++;
  80177c:	ff 45 08             	incl   0x8(%ebp)
  80177f:	eb 13                	jmp    801794 <strtol+0x4c>
	else if (*s == '-')
  801781:	8b 45 08             	mov    0x8(%ebp),%eax
  801784:	8a 00                	mov    (%eax),%al
  801786:	3c 2d                	cmp    $0x2d,%al
  801788:	75 0a                	jne    801794 <strtol+0x4c>
		s++, neg = 1;
  80178a:	ff 45 08             	incl   0x8(%ebp)
  80178d:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801794:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801798:	74 06                	je     8017a0 <strtol+0x58>
  80179a:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  80179e:	75 20                	jne    8017c0 <strtol+0x78>
  8017a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8017a3:	8a 00                	mov    (%eax),%al
  8017a5:	3c 30                	cmp    $0x30,%al
  8017a7:	75 17                	jne    8017c0 <strtol+0x78>
  8017a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8017ac:	40                   	inc    %eax
  8017ad:	8a 00                	mov    (%eax),%al
  8017af:	3c 78                	cmp    $0x78,%al
  8017b1:	75 0d                	jne    8017c0 <strtol+0x78>
		s += 2, base = 16;
  8017b3:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  8017b7:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  8017be:	eb 28                	jmp    8017e8 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  8017c0:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8017c4:	75 15                	jne    8017db <strtol+0x93>
  8017c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8017c9:	8a 00                	mov    (%eax),%al
  8017cb:	3c 30                	cmp    $0x30,%al
  8017cd:	75 0c                	jne    8017db <strtol+0x93>
		s++, base = 8;
  8017cf:	ff 45 08             	incl   0x8(%ebp)
  8017d2:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  8017d9:	eb 0d                	jmp    8017e8 <strtol+0xa0>
	else if (base == 0)
  8017db:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8017df:	75 07                	jne    8017e8 <strtol+0xa0>
		base = 10;
  8017e1:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8017e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8017eb:	8a 00                	mov    (%eax),%al
  8017ed:	3c 2f                	cmp    $0x2f,%al
  8017ef:	7e 19                	jle    80180a <strtol+0xc2>
  8017f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8017f4:	8a 00                	mov    (%eax),%al
  8017f6:	3c 39                	cmp    $0x39,%al
  8017f8:	7f 10                	jg     80180a <strtol+0xc2>
			dig = *s - '0';
  8017fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8017fd:	8a 00                	mov    (%eax),%al
  8017ff:	0f be c0             	movsbl %al,%eax
  801802:	83 e8 30             	sub    $0x30,%eax
  801805:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801808:	eb 42                	jmp    80184c <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  80180a:	8b 45 08             	mov    0x8(%ebp),%eax
  80180d:	8a 00                	mov    (%eax),%al
  80180f:	3c 60                	cmp    $0x60,%al
  801811:	7e 19                	jle    80182c <strtol+0xe4>
  801813:	8b 45 08             	mov    0x8(%ebp),%eax
  801816:	8a 00                	mov    (%eax),%al
  801818:	3c 7a                	cmp    $0x7a,%al
  80181a:	7f 10                	jg     80182c <strtol+0xe4>
			dig = *s - 'a' + 10;
  80181c:	8b 45 08             	mov    0x8(%ebp),%eax
  80181f:	8a 00                	mov    (%eax),%al
  801821:	0f be c0             	movsbl %al,%eax
  801824:	83 e8 57             	sub    $0x57,%eax
  801827:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80182a:	eb 20                	jmp    80184c <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  80182c:	8b 45 08             	mov    0x8(%ebp),%eax
  80182f:	8a 00                	mov    (%eax),%al
  801831:	3c 40                	cmp    $0x40,%al
  801833:	7e 39                	jle    80186e <strtol+0x126>
  801835:	8b 45 08             	mov    0x8(%ebp),%eax
  801838:	8a 00                	mov    (%eax),%al
  80183a:	3c 5a                	cmp    $0x5a,%al
  80183c:	7f 30                	jg     80186e <strtol+0x126>
			dig = *s - 'A' + 10;
  80183e:	8b 45 08             	mov    0x8(%ebp),%eax
  801841:	8a 00                	mov    (%eax),%al
  801843:	0f be c0             	movsbl %al,%eax
  801846:	83 e8 37             	sub    $0x37,%eax
  801849:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  80184c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80184f:	3b 45 10             	cmp    0x10(%ebp),%eax
  801852:	7d 19                	jge    80186d <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801854:	ff 45 08             	incl   0x8(%ebp)
  801857:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80185a:	0f af 45 10          	imul   0x10(%ebp),%eax
  80185e:	89 c2                	mov    %eax,%edx
  801860:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801863:	01 d0                	add    %edx,%eax
  801865:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  801868:	e9 7b ff ff ff       	jmp    8017e8 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  80186d:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  80186e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801872:	74 08                	je     80187c <strtol+0x134>
		*endptr = (char *) s;
  801874:	8b 45 0c             	mov    0xc(%ebp),%eax
  801877:	8b 55 08             	mov    0x8(%ebp),%edx
  80187a:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  80187c:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801880:	74 07                	je     801889 <strtol+0x141>
  801882:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801885:	f7 d8                	neg    %eax
  801887:	eb 03                	jmp    80188c <strtol+0x144>
  801889:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  80188c:	c9                   	leave  
  80188d:	c3                   	ret    

0080188e <ltostr>:

void
ltostr(long value, char *str)
{
  80188e:	55                   	push   %ebp
  80188f:	89 e5                	mov    %esp,%ebp
  801891:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  801894:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  80189b:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  8018a2:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8018a6:	79 13                	jns    8018bb <ltostr+0x2d>
	{
		neg = 1;
  8018a8:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  8018af:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018b2:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  8018b5:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  8018b8:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  8018bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8018be:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8018c3:	99                   	cltd   
  8018c4:	f7 f9                	idiv   %ecx
  8018c6:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  8018c9:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8018cc:	8d 50 01             	lea    0x1(%eax),%edx
  8018cf:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8018d2:	89 c2                	mov    %eax,%edx
  8018d4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018d7:	01 d0                	add    %edx,%eax
  8018d9:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8018dc:	83 c2 30             	add    $0x30,%edx
  8018df:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  8018e1:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8018e4:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8018e9:	f7 e9                	imul   %ecx
  8018eb:	c1 fa 02             	sar    $0x2,%edx
  8018ee:	89 c8                	mov    %ecx,%eax
  8018f0:	c1 f8 1f             	sar    $0x1f,%eax
  8018f3:	29 c2                	sub    %eax,%edx
  8018f5:	89 d0                	mov    %edx,%eax
  8018f7:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  8018fa:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8018fe:	75 bb                	jne    8018bb <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801900:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801907:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80190a:	48                   	dec    %eax
  80190b:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  80190e:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801912:	74 3d                	je     801951 <ltostr+0xc3>
		start = 1 ;
  801914:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  80191b:	eb 34                	jmp    801951 <ltostr+0xc3>
	{
		char tmp = str[start] ;
  80191d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801920:	8b 45 0c             	mov    0xc(%ebp),%eax
  801923:	01 d0                	add    %edx,%eax
  801925:	8a 00                	mov    (%eax),%al
  801927:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  80192a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80192d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801930:	01 c2                	add    %eax,%edx
  801932:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801935:	8b 45 0c             	mov    0xc(%ebp),%eax
  801938:	01 c8                	add    %ecx,%eax
  80193a:	8a 00                	mov    (%eax),%al
  80193c:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  80193e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801941:	8b 45 0c             	mov    0xc(%ebp),%eax
  801944:	01 c2                	add    %eax,%edx
  801946:	8a 45 eb             	mov    -0x15(%ebp),%al
  801949:	88 02                	mov    %al,(%edx)
		start++ ;
  80194b:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  80194e:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801951:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801954:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801957:	7c c4                	jl     80191d <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801959:	8b 55 f8             	mov    -0x8(%ebp),%edx
  80195c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80195f:	01 d0                	add    %edx,%eax
  801961:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801964:	90                   	nop
  801965:	c9                   	leave  
  801966:	c3                   	ret    

00801967 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  801967:	55                   	push   %ebp
  801968:	89 e5                	mov    %esp,%ebp
  80196a:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  80196d:	ff 75 08             	pushl  0x8(%ebp)
  801970:	e8 c4 f9 ff ff       	call   801339 <strlen>
  801975:	83 c4 04             	add    $0x4,%esp
  801978:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  80197b:	ff 75 0c             	pushl  0xc(%ebp)
  80197e:	e8 b6 f9 ff ff       	call   801339 <strlen>
  801983:	83 c4 04             	add    $0x4,%esp
  801986:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  801989:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  801990:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801997:	eb 17                	jmp    8019b0 <strcconcat+0x49>
		final[s] = str1[s] ;
  801999:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80199c:	8b 45 10             	mov    0x10(%ebp),%eax
  80199f:	01 c2                	add    %eax,%edx
  8019a1:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8019a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8019a7:	01 c8                	add    %ecx,%eax
  8019a9:	8a 00                	mov    (%eax),%al
  8019ab:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  8019ad:	ff 45 fc             	incl   -0x4(%ebp)
  8019b0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8019b3:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8019b6:	7c e1                	jl     801999 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  8019b8:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  8019bf:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8019c6:	eb 1f                	jmp    8019e7 <strcconcat+0x80>
		final[s++] = str2[i] ;
  8019c8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8019cb:	8d 50 01             	lea    0x1(%eax),%edx
  8019ce:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8019d1:	89 c2                	mov    %eax,%edx
  8019d3:	8b 45 10             	mov    0x10(%ebp),%eax
  8019d6:	01 c2                	add    %eax,%edx
  8019d8:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8019db:	8b 45 0c             	mov    0xc(%ebp),%eax
  8019de:	01 c8                	add    %ecx,%eax
  8019e0:	8a 00                	mov    (%eax),%al
  8019e2:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  8019e4:	ff 45 f8             	incl   -0x8(%ebp)
  8019e7:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8019ea:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8019ed:	7c d9                	jl     8019c8 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  8019ef:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8019f2:	8b 45 10             	mov    0x10(%ebp),%eax
  8019f5:	01 d0                	add    %edx,%eax
  8019f7:	c6 00 00             	movb   $0x0,(%eax)
}
  8019fa:	90                   	nop
  8019fb:	c9                   	leave  
  8019fc:	c3                   	ret    

008019fd <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  8019fd:	55                   	push   %ebp
  8019fe:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801a00:	8b 45 14             	mov    0x14(%ebp),%eax
  801a03:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801a09:	8b 45 14             	mov    0x14(%ebp),%eax
  801a0c:	8b 00                	mov    (%eax),%eax
  801a0e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801a15:	8b 45 10             	mov    0x10(%ebp),%eax
  801a18:	01 d0                	add    %edx,%eax
  801a1a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801a20:	eb 0c                	jmp    801a2e <strsplit+0x31>
			*string++ = 0;
  801a22:	8b 45 08             	mov    0x8(%ebp),%eax
  801a25:	8d 50 01             	lea    0x1(%eax),%edx
  801a28:	89 55 08             	mov    %edx,0x8(%ebp)
  801a2b:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801a2e:	8b 45 08             	mov    0x8(%ebp),%eax
  801a31:	8a 00                	mov    (%eax),%al
  801a33:	84 c0                	test   %al,%al
  801a35:	74 18                	je     801a4f <strsplit+0x52>
  801a37:	8b 45 08             	mov    0x8(%ebp),%eax
  801a3a:	8a 00                	mov    (%eax),%al
  801a3c:	0f be c0             	movsbl %al,%eax
  801a3f:	50                   	push   %eax
  801a40:	ff 75 0c             	pushl  0xc(%ebp)
  801a43:	e8 83 fa ff ff       	call   8014cb <strchr>
  801a48:	83 c4 08             	add    $0x8,%esp
  801a4b:	85 c0                	test   %eax,%eax
  801a4d:	75 d3                	jne    801a22 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801a4f:	8b 45 08             	mov    0x8(%ebp),%eax
  801a52:	8a 00                	mov    (%eax),%al
  801a54:	84 c0                	test   %al,%al
  801a56:	74 5a                	je     801ab2 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801a58:	8b 45 14             	mov    0x14(%ebp),%eax
  801a5b:	8b 00                	mov    (%eax),%eax
  801a5d:	83 f8 0f             	cmp    $0xf,%eax
  801a60:	75 07                	jne    801a69 <strsplit+0x6c>
		{
			return 0;
  801a62:	b8 00 00 00 00       	mov    $0x0,%eax
  801a67:	eb 66                	jmp    801acf <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801a69:	8b 45 14             	mov    0x14(%ebp),%eax
  801a6c:	8b 00                	mov    (%eax),%eax
  801a6e:	8d 48 01             	lea    0x1(%eax),%ecx
  801a71:	8b 55 14             	mov    0x14(%ebp),%edx
  801a74:	89 0a                	mov    %ecx,(%edx)
  801a76:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801a7d:	8b 45 10             	mov    0x10(%ebp),%eax
  801a80:	01 c2                	add    %eax,%edx
  801a82:	8b 45 08             	mov    0x8(%ebp),%eax
  801a85:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801a87:	eb 03                	jmp    801a8c <strsplit+0x8f>
			string++;
  801a89:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801a8c:	8b 45 08             	mov    0x8(%ebp),%eax
  801a8f:	8a 00                	mov    (%eax),%al
  801a91:	84 c0                	test   %al,%al
  801a93:	74 8b                	je     801a20 <strsplit+0x23>
  801a95:	8b 45 08             	mov    0x8(%ebp),%eax
  801a98:	8a 00                	mov    (%eax),%al
  801a9a:	0f be c0             	movsbl %al,%eax
  801a9d:	50                   	push   %eax
  801a9e:	ff 75 0c             	pushl  0xc(%ebp)
  801aa1:	e8 25 fa ff ff       	call   8014cb <strchr>
  801aa6:	83 c4 08             	add    $0x8,%esp
  801aa9:	85 c0                	test   %eax,%eax
  801aab:	74 dc                	je     801a89 <strsplit+0x8c>
			string++;
	}
  801aad:	e9 6e ff ff ff       	jmp    801a20 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801ab2:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801ab3:	8b 45 14             	mov    0x14(%ebp),%eax
  801ab6:	8b 00                	mov    (%eax),%eax
  801ab8:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801abf:	8b 45 10             	mov    0x10(%ebp),%eax
  801ac2:	01 d0                	add    %edx,%eax
  801ac4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801aca:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801acf:	c9                   	leave  
  801ad0:	c3                   	ret    

00801ad1 <str2lower>:


char* str2lower(char *dst, const char *src)
{
  801ad1:	55                   	push   %ebp
  801ad2:	89 e5                	mov    %esp,%ebp
  801ad4:	83 ec 10             	sub    $0x10,%esp
	char* ret = dst;
  801ad7:	8b 45 08             	mov    0x8(%ebp),%eax
  801ada:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (int i = 0; i < strlen(src); ++i)
  801add:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801ae4:	eb 4a                	jmp    801b30 <str2lower+0x5f>
	{
		dst[i] = src[i] ;
  801ae6:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801ae9:	8b 45 08             	mov    0x8(%ebp),%eax
  801aec:	01 c2                	add    %eax,%edx
  801aee:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801af1:	8b 45 0c             	mov    0xc(%ebp),%eax
  801af4:	01 c8                	add    %ecx,%eax
  801af6:	8a 00                	mov    (%eax),%al
  801af8:	88 02                	mov    %al,(%edx)
		if (src[i] >= 'A' && src[i] <= 'Z')
  801afa:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801afd:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b00:	01 d0                	add    %edx,%eax
  801b02:	8a 00                	mov    (%eax),%al
  801b04:	3c 40                	cmp    $0x40,%al
  801b06:	7e 25                	jle    801b2d <str2lower+0x5c>
  801b08:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801b0b:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b0e:	01 d0                	add    %edx,%eax
  801b10:	8a 00                	mov    (%eax),%al
  801b12:	3c 5a                	cmp    $0x5a,%al
  801b14:	7f 17                	jg     801b2d <str2lower+0x5c>
		{
			dst[i] += 32 ;
  801b16:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801b19:	8b 45 08             	mov    0x8(%ebp),%eax
  801b1c:	01 d0                	add    %edx,%eax
  801b1e:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801b21:	8b 55 08             	mov    0x8(%ebp),%edx
  801b24:	01 ca                	add    %ecx,%edx
  801b26:	8a 12                	mov    (%edx),%dl
  801b28:	83 c2 20             	add    $0x20,%edx
  801b2b:	88 10                	mov    %dl,(%eax)


char* str2lower(char *dst, const char *src)
{
	char* ret = dst;
	for (int i = 0; i < strlen(src); ++i)
  801b2d:	ff 45 fc             	incl   -0x4(%ebp)
  801b30:	ff 75 0c             	pushl  0xc(%ebp)
  801b33:	e8 01 f8 ff ff       	call   801339 <strlen>
  801b38:	83 c4 04             	add    $0x4,%esp
  801b3b:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801b3e:	7f a6                	jg     801ae6 <str2lower+0x15>
		if (src[i] >= 'A' && src[i] <= 'Z')
		{
			dst[i] += 32 ;
		}
	}
	return ret;
  801b40:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801b43:	c9                   	leave  
  801b44:	c3                   	ret    

00801b45 <uheap_init>:
//==============================================
// [1] INITIALIZE USER HEAP:
//==============================================
int __firstTimeFlag = 1;
void uheap_init()
{
  801b45:	55                   	push   %ebp
  801b46:	89 e5                	mov    %esp,%ebp
  801b48:	83 ec 08             	sub    $0x8,%esp
	if(__firstTimeFlag)
  801b4b:	a1 08 40 80 00       	mov    0x804008,%eax
  801b50:	85 c0                	test   %eax,%eax
  801b52:	74 42                	je     801b96 <uheap_init+0x51>
	{
		initialize_dynamic_allocator(USER_HEAP_START, USER_HEAP_START + DYN_ALLOC_MAX_SIZE);
  801b54:	83 ec 08             	sub    $0x8,%esp
  801b57:	68 00 00 00 82       	push   $0x82000000
  801b5c:	68 00 00 00 80       	push   $0x80000000
  801b61:	e8 00 08 00 00       	call   802366 <initialize_dynamic_allocator>
  801b66:	83 c4 10             	add    $0x10,%esp
		uheapPlaceStrategy = sys_get_uheap_strategy();
  801b69:	e8 e7 05 00 00       	call   802155 <sys_get_uheap_strategy>
  801b6e:	a3 60 c0 81 00       	mov    %eax,0x81c060
		uheapPageAllocStart = dynAllocEnd + PAGE_SIZE;
  801b73:	a1 40 40 80 00       	mov    0x804040,%eax
  801b78:	05 00 10 00 00       	add    $0x1000,%eax
  801b7d:	a3 10 c1 81 00       	mov    %eax,0x81c110
		uheapPageAllocBreak = uheapPageAllocStart;
  801b82:	a1 10 c1 81 00       	mov    0x81c110,%eax
  801b87:	a3 68 c0 81 00       	mov    %eax,0x81c068

		__firstTimeFlag = 0;
  801b8c:	c7 05 08 40 80 00 00 	movl   $0x0,0x804008
  801b93:	00 00 00 
	}
}
  801b96:	90                   	nop
  801b97:	c9                   	leave  
  801b98:	c3                   	ret    

00801b99 <get_page>:

//==============================================
// [2] GET A PAGE FROM THE KERNEL FOR DA:
//==============================================
int get_page(void* va)
{
  801b99:	55                   	push   %ebp
  801b9a:	89 e5                	mov    %esp,%ebp
  801b9c:	83 ec 18             	sub    $0x18,%esp
	int ret = __sys_allocate_page(ROUNDDOWN(va, PAGE_SIZE), PERM_USER|PERM_WRITEABLE|PERM_UHPAGE);
  801b9f:	8b 45 08             	mov    0x8(%ebp),%eax
  801ba2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801ba5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ba8:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801bad:	83 ec 08             	sub    $0x8,%esp
  801bb0:	68 06 04 00 00       	push   $0x406
  801bb5:	50                   	push   %eax
  801bb6:	e8 e4 01 00 00       	call   801d9f <__sys_allocate_page>
  801bbb:	83 c4 10             	add    $0x10,%esp
  801bbe:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (ret < 0)
  801bc1:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801bc5:	79 14                	jns    801bdb <get_page+0x42>
		panic("get_page() in user: failed to allocate page from the kernel");
  801bc7:	83 ec 04             	sub    $0x4,%esp
  801bca:	68 9c 37 80 00       	push   $0x80379c
  801bcf:	6a 1f                	push   $0x1f
  801bd1:	68 d8 37 80 00       	push   $0x8037d8
  801bd6:	e8 af eb ff ff       	call   80078a <_panic>
	return 0;
  801bdb:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801be0:	c9                   	leave  
  801be1:	c3                   	ret    

00801be2 <return_page>:

//==============================================
// [3] RETURN A PAGE FROM THE DA TO KERNEL:
//==============================================
void return_page(void* va)
{
  801be2:	55                   	push   %ebp
  801be3:	89 e5                	mov    %esp,%ebp
  801be5:	83 ec 18             	sub    $0x18,%esp
	int ret = __sys_unmap_frame(ROUNDDOWN((uint32)va, PAGE_SIZE));
  801be8:	8b 45 08             	mov    0x8(%ebp),%eax
  801beb:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801bee:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801bf1:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801bf6:	83 ec 0c             	sub    $0xc,%esp
  801bf9:	50                   	push   %eax
  801bfa:	e8 e7 01 00 00       	call   801de6 <__sys_unmap_frame>
  801bff:	83 c4 10             	add    $0x10,%esp
  801c02:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (ret < 0)
  801c05:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801c09:	79 14                	jns    801c1f <return_page+0x3d>
		panic("return_page() in user: failed to return a page to the kernel");
  801c0b:	83 ec 04             	sub    $0x4,%esp
  801c0e:	68 e4 37 80 00       	push   $0x8037e4
  801c13:	6a 2a                	push   $0x2a
  801c15:	68 d8 37 80 00       	push   $0x8037d8
  801c1a:	e8 6b eb ff ff       	call   80078a <_panic>
}
  801c1f:	90                   	nop
  801c20:	c9                   	leave  
  801c21:	c3                   	ret    

00801c22 <malloc>:

//=================================
// [1] ALLOCATE SPACE IN USER HEAP:
//=================================
void* malloc(uint32 size)
{
  801c22:	55                   	push   %ebp
  801c23:	89 e5                	mov    %esp,%ebp
  801c25:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  801c28:	e8 18 ff ff ff       	call   801b45 <uheap_init>
	if (size == 0) return NULL ;
  801c2d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801c31:	75 07                	jne    801c3a <malloc+0x18>
  801c33:	b8 00 00 00 00       	mov    $0x0,%eax
  801c38:	eb 14                	jmp    801c4e <malloc+0x2c>
	//==============================================================
	//TODO: [PROJECT'25.IM#2] USER HEAP - #1 malloc
	//Your code is here
	//Comment the following line
	panic("malloc() is not implemented yet...!!");
  801c3a:	83 ec 04             	sub    $0x4,%esp
  801c3d:	68 24 38 80 00       	push   $0x803824
  801c42:	6a 3e                	push   $0x3e
  801c44:	68 d8 37 80 00       	push   $0x8037d8
  801c49:	e8 3c eb ff ff       	call   80078a <_panic>
}
  801c4e:	c9                   	leave  
  801c4f:	c3                   	ret    

00801c50 <free>:

//=================================
// [2] FREE SPACE FROM USER HEAP:
//=================================
void free(void* virtual_address)
{
  801c50:	55                   	push   %ebp
  801c51:	89 e5                	mov    %esp,%ebp
  801c53:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.IM#2] USER HEAP - #3 free
	//Your code is here
	//Comment the following line
	panic("free() is not implemented yet...!!");
  801c56:	83 ec 04             	sub    $0x4,%esp
  801c59:	68 4c 38 80 00       	push   $0x80384c
  801c5e:	6a 49                	push   $0x49
  801c60:	68 d8 37 80 00       	push   $0x8037d8
  801c65:	e8 20 eb ff ff       	call   80078a <_panic>

00801c6a <smalloc>:

//=================================
// [3] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  801c6a:	55                   	push   %ebp
  801c6b:	89 e5                	mov    %esp,%ebp
  801c6d:	83 ec 18             	sub    $0x18,%esp
  801c70:	8b 45 10             	mov    0x10(%ebp),%eax
  801c73:	88 45 f4             	mov    %al,-0xc(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  801c76:	e8 ca fe ff ff       	call   801b45 <uheap_init>
	if (size == 0) return NULL ;
  801c7b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801c7f:	75 07                	jne    801c88 <smalloc+0x1e>
  801c81:	b8 00 00 00 00       	mov    $0x0,%eax
  801c86:	eb 14                	jmp    801c9c <smalloc+0x32>
	//==============================================================

	//TODO: [PROJECT'25.IM#3] SHARED MEMORY - #2 smalloc
	//Your code is here
	//Comment the following line
	panic("smalloc() is not implemented yet...!!");
  801c88:	83 ec 04             	sub    $0x4,%esp
  801c8b:	68 70 38 80 00       	push   $0x803870
  801c90:	6a 5a                	push   $0x5a
  801c92:	68 d8 37 80 00       	push   $0x8037d8
  801c97:	e8 ee ea ff ff       	call   80078a <_panic>
}
  801c9c:	c9                   	leave  
  801c9d:	c3                   	ret    

00801c9e <sget>:

//========================================
// [4] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801c9e:	55                   	push   %ebp
  801c9f:	89 e5                	mov    %esp,%ebp
  801ca1:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  801ca4:	e8 9c fe ff ff       	call   801b45 <uheap_init>
	//==============================================================

	//TODO: [PROJECT'25.IM#3] SHARED MEMORY - #4 sget
	//Your code is here
	//Comment the following line
	panic("sget() is not implemented yet...!!");
  801ca9:	83 ec 04             	sub    $0x4,%esp
  801cac:	68 98 38 80 00       	push   $0x803898
  801cb1:	6a 6a                	push   $0x6a
  801cb3:	68 d8 37 80 00       	push   $0x8037d8
  801cb8:	e8 cd ea ff ff       	call   80078a <_panic>

00801cbd <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801cbd:	55                   	push   %ebp
  801cbe:	89 e5                	mov    %esp,%ebp
  801cc0:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  801cc3:	e8 7d fe ff ff       	call   801b45 <uheap_init>
	//==============================================================
	panic("realloc() is not implemented yet...!!");
  801cc8:	83 ec 04             	sub    $0x4,%esp
  801ccb:	68 bc 38 80 00       	push   $0x8038bc
  801cd0:	68 88 00 00 00       	push   $0x88
  801cd5:	68 d8 37 80 00       	push   $0x8037d8
  801cda:	e8 ab ea ff ff       	call   80078a <_panic>

00801cdf <sfree>:
//
//	use sys_delete_shared_object(...); which switches to the kernel mode,
//	calls delete_shared_object(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the delete_shared_object() function is empty, make sure to implement it.
void sfree(void* virtual_address)
{
  801cdf:	55                   	push   %ebp
  801ce0:	89 e5                	mov    %esp,%ebp
  801ce2:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.BONUS#5] EXIT #2 - sfree
	//Your code is here
	//Comment the following line
	panic("sfree() is not implemented yet...!!");
  801ce5:	83 ec 04             	sub    $0x4,%esp
  801ce8:	68 e4 38 80 00       	push   $0x8038e4
  801ced:	68 9b 00 00 00       	push   $0x9b
  801cf2:	68 d8 37 80 00       	push   $0x8037d8
  801cf7:	e8 8e ea ff ff       	call   80078a <_panic>

00801cfc <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801cfc:	55                   	push   %ebp
  801cfd:	89 e5                	mov    %esp,%ebp
  801cff:	57                   	push   %edi
  801d00:	56                   	push   %esi
  801d01:	53                   	push   %ebx
  801d02:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801d05:	8b 45 08             	mov    0x8(%ebp),%eax
  801d08:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d0b:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801d0e:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801d11:	8b 7d 18             	mov    0x18(%ebp),%edi
  801d14:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801d17:	cd 30                	int    $0x30
  801d19:	89 45 f0             	mov    %eax,-0x10(%ebp)
				"b" (a3),
				"D" (a4),
				"S" (a5)
				: "cc", "memory");

	return ret;
  801d1c:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801d1f:	83 c4 10             	add    $0x10,%esp
  801d22:	5b                   	pop    %ebx
  801d23:	5e                   	pop    %esi
  801d24:	5f                   	pop    %edi
  801d25:	5d                   	pop    %ebp
  801d26:	c3                   	ret    

00801d27 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName, int color)
{
  801d27:	55                   	push   %ebp
  801d28:	89 e5                	mov    %esp,%ebp
  801d2a:	83 ec 04             	sub    $0x4,%esp
  801d2d:	8b 45 10             	mov    0x10(%ebp),%eax
  801d30:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, color, 0);
  801d33:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801d36:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801d3a:	8b 45 08             	mov    0x8(%ebp),%eax
  801d3d:	6a 00                	push   $0x0
  801d3f:	51                   	push   %ecx
  801d40:	52                   	push   %edx
  801d41:	ff 75 0c             	pushl  0xc(%ebp)
  801d44:	50                   	push   %eax
  801d45:	6a 00                	push   $0x0
  801d47:	e8 b0 ff ff ff       	call   801cfc <syscall>
  801d4c:	83 c4 18             	add    $0x18,%esp
}
  801d4f:	90                   	nop
  801d50:	c9                   	leave  
  801d51:	c3                   	ret    

00801d52 <sys_cgetc>:

int
sys_cgetc(void)
{
  801d52:	55                   	push   %ebp
  801d53:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801d55:	6a 00                	push   $0x0
  801d57:	6a 00                	push   $0x0
  801d59:	6a 00                	push   $0x0
  801d5b:	6a 00                	push   $0x0
  801d5d:	6a 00                	push   $0x0
  801d5f:	6a 02                	push   $0x2
  801d61:	e8 96 ff ff ff       	call   801cfc <syscall>
  801d66:	83 c4 18             	add    $0x18,%esp
}
  801d69:	c9                   	leave  
  801d6a:	c3                   	ret    

00801d6b <sys_lock_cons>:

void sys_lock_cons(void)
{
  801d6b:	55                   	push   %ebp
  801d6c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  801d6e:	6a 00                	push   $0x0
  801d70:	6a 00                	push   $0x0
  801d72:	6a 00                	push   $0x0
  801d74:	6a 00                	push   $0x0
  801d76:	6a 00                	push   $0x0
  801d78:	6a 03                	push   $0x3
  801d7a:	e8 7d ff ff ff       	call   801cfc <syscall>
  801d7f:	83 c4 18             	add    $0x18,%esp
}
  801d82:	90                   	nop
  801d83:	c9                   	leave  
  801d84:	c3                   	ret    

00801d85 <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  801d85:	55                   	push   %ebp
  801d86:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  801d88:	6a 00                	push   $0x0
  801d8a:	6a 00                	push   $0x0
  801d8c:	6a 00                	push   $0x0
  801d8e:	6a 00                	push   $0x0
  801d90:	6a 00                	push   $0x0
  801d92:	6a 04                	push   $0x4
  801d94:	e8 63 ff ff ff       	call   801cfc <syscall>
  801d99:	83 c4 18             	add    $0x18,%esp
}
  801d9c:	90                   	nop
  801d9d:	c9                   	leave  
  801d9e:	c3                   	ret    

00801d9f <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801d9f:	55                   	push   %ebp
  801da0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801da2:	8b 55 0c             	mov    0xc(%ebp),%edx
  801da5:	8b 45 08             	mov    0x8(%ebp),%eax
  801da8:	6a 00                	push   $0x0
  801daa:	6a 00                	push   $0x0
  801dac:	6a 00                	push   $0x0
  801dae:	52                   	push   %edx
  801daf:	50                   	push   %eax
  801db0:	6a 08                	push   $0x8
  801db2:	e8 45 ff ff ff       	call   801cfc <syscall>
  801db7:	83 c4 18             	add    $0x18,%esp
}
  801dba:	c9                   	leave  
  801dbb:	c3                   	ret    

00801dbc <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801dbc:	55                   	push   %ebp
  801dbd:	89 e5                	mov    %esp,%ebp
  801dbf:	56                   	push   %esi
  801dc0:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801dc1:	8b 75 18             	mov    0x18(%ebp),%esi
  801dc4:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801dc7:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801dca:	8b 55 0c             	mov    0xc(%ebp),%edx
  801dcd:	8b 45 08             	mov    0x8(%ebp),%eax
  801dd0:	56                   	push   %esi
  801dd1:	53                   	push   %ebx
  801dd2:	51                   	push   %ecx
  801dd3:	52                   	push   %edx
  801dd4:	50                   	push   %eax
  801dd5:	6a 09                	push   $0x9
  801dd7:	e8 20 ff ff ff       	call   801cfc <syscall>
  801ddc:	83 c4 18             	add    $0x18,%esp
}
  801ddf:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801de2:	5b                   	pop    %ebx
  801de3:	5e                   	pop    %esi
  801de4:	5d                   	pop    %ebp
  801de5:	c3                   	ret    

00801de6 <__sys_unmap_frame>:

int __sys_unmap_frame(uint32 va)
{
  801de6:	55                   	push   %ebp
  801de7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, va, 0, 0, 0, 0);
  801de9:	6a 00                	push   $0x0
  801deb:	6a 00                	push   $0x0
  801ded:	6a 00                	push   $0x0
  801def:	6a 00                	push   $0x0
  801df1:	ff 75 08             	pushl  0x8(%ebp)
  801df4:	6a 0a                	push   $0xa
  801df6:	e8 01 ff ff ff       	call   801cfc <syscall>
  801dfb:	83 c4 18             	add    $0x18,%esp
}
  801dfe:	c9                   	leave  
  801dff:	c3                   	ret    

00801e00 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801e00:	55                   	push   %ebp
  801e01:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801e03:	6a 00                	push   $0x0
  801e05:	6a 00                	push   $0x0
  801e07:	6a 00                	push   $0x0
  801e09:	ff 75 0c             	pushl  0xc(%ebp)
  801e0c:	ff 75 08             	pushl  0x8(%ebp)
  801e0f:	6a 0b                	push   $0xb
  801e11:	e8 e6 fe ff ff       	call   801cfc <syscall>
  801e16:	83 c4 18             	add    $0x18,%esp
}
  801e19:	c9                   	leave  
  801e1a:	c3                   	ret    

00801e1b <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801e1b:	55                   	push   %ebp
  801e1c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801e1e:	6a 00                	push   $0x0
  801e20:	6a 00                	push   $0x0
  801e22:	6a 00                	push   $0x0
  801e24:	6a 00                	push   $0x0
  801e26:	6a 00                	push   $0x0
  801e28:	6a 0c                	push   $0xc
  801e2a:	e8 cd fe ff ff       	call   801cfc <syscall>
  801e2f:	83 c4 18             	add    $0x18,%esp
}
  801e32:	c9                   	leave  
  801e33:	c3                   	ret    

00801e34 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801e34:	55                   	push   %ebp
  801e35:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801e37:	6a 00                	push   $0x0
  801e39:	6a 00                	push   $0x0
  801e3b:	6a 00                	push   $0x0
  801e3d:	6a 00                	push   $0x0
  801e3f:	6a 00                	push   $0x0
  801e41:	6a 0d                	push   $0xd
  801e43:	e8 b4 fe ff ff       	call   801cfc <syscall>
  801e48:	83 c4 18             	add    $0x18,%esp
}
  801e4b:	c9                   	leave  
  801e4c:	c3                   	ret    

00801e4d <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801e4d:	55                   	push   %ebp
  801e4e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801e50:	6a 00                	push   $0x0
  801e52:	6a 00                	push   $0x0
  801e54:	6a 00                	push   $0x0
  801e56:	6a 00                	push   $0x0
  801e58:	6a 00                	push   $0x0
  801e5a:	6a 0e                	push   $0xe
  801e5c:	e8 9b fe ff ff       	call   801cfc <syscall>
  801e61:	83 c4 18             	add    $0x18,%esp
}
  801e64:	c9                   	leave  
  801e65:	c3                   	ret    

00801e66 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801e66:	55                   	push   %ebp
  801e67:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801e69:	6a 00                	push   $0x0
  801e6b:	6a 00                	push   $0x0
  801e6d:	6a 00                	push   $0x0
  801e6f:	6a 00                	push   $0x0
  801e71:	6a 00                	push   $0x0
  801e73:	6a 0f                	push   $0xf
  801e75:	e8 82 fe ff ff       	call   801cfc <syscall>
  801e7a:	83 c4 18             	add    $0x18,%esp
}
  801e7d:	c9                   	leave  
  801e7e:	c3                   	ret    

00801e7f <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801e7f:	55                   	push   %ebp
  801e80:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801e82:	6a 00                	push   $0x0
  801e84:	6a 00                	push   $0x0
  801e86:	6a 00                	push   $0x0
  801e88:	6a 00                	push   $0x0
  801e8a:	ff 75 08             	pushl  0x8(%ebp)
  801e8d:	6a 10                	push   $0x10
  801e8f:	e8 68 fe ff ff       	call   801cfc <syscall>
  801e94:	83 c4 18             	add    $0x18,%esp
}
  801e97:	c9                   	leave  
  801e98:	c3                   	ret    

00801e99 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801e99:	55                   	push   %ebp
  801e9a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801e9c:	6a 00                	push   $0x0
  801e9e:	6a 00                	push   $0x0
  801ea0:	6a 00                	push   $0x0
  801ea2:	6a 00                	push   $0x0
  801ea4:	6a 00                	push   $0x0
  801ea6:	6a 11                	push   $0x11
  801ea8:	e8 4f fe ff ff       	call   801cfc <syscall>
  801ead:	83 c4 18             	add    $0x18,%esp
}
  801eb0:	90                   	nop
  801eb1:	c9                   	leave  
  801eb2:	c3                   	ret    

00801eb3 <sys_cputc>:

void
sys_cputc(const char c)
{
  801eb3:	55                   	push   %ebp
  801eb4:	89 e5                	mov    %esp,%ebp
  801eb6:	83 ec 04             	sub    $0x4,%esp
  801eb9:	8b 45 08             	mov    0x8(%ebp),%eax
  801ebc:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801ebf:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801ec3:	6a 00                	push   $0x0
  801ec5:	6a 00                	push   $0x0
  801ec7:	6a 00                	push   $0x0
  801ec9:	6a 00                	push   $0x0
  801ecb:	50                   	push   %eax
  801ecc:	6a 01                	push   $0x1
  801ece:	e8 29 fe ff ff       	call   801cfc <syscall>
  801ed3:	83 c4 18             	add    $0x18,%esp
}
  801ed6:	90                   	nop
  801ed7:	c9                   	leave  
  801ed8:	c3                   	ret    

00801ed9 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801ed9:	55                   	push   %ebp
  801eda:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801edc:	6a 00                	push   $0x0
  801ede:	6a 00                	push   $0x0
  801ee0:	6a 00                	push   $0x0
  801ee2:	6a 00                	push   $0x0
  801ee4:	6a 00                	push   $0x0
  801ee6:	6a 14                	push   $0x14
  801ee8:	e8 0f fe ff ff       	call   801cfc <syscall>
  801eed:	83 c4 18             	add    $0x18,%esp
}
  801ef0:	90                   	nop
  801ef1:	c9                   	leave  
  801ef2:	c3                   	ret    

00801ef3 <sys_create_shared_object>:

int sys_create_shared_object(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801ef3:	55                   	push   %ebp
  801ef4:	89 e5                	mov    %esp,%ebp
  801ef6:	83 ec 04             	sub    $0x4,%esp
  801ef9:	8b 45 10             	mov    0x10(%ebp),%eax
  801efc:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801eff:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801f02:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801f06:	8b 45 08             	mov    0x8(%ebp),%eax
  801f09:	6a 00                	push   $0x0
  801f0b:	51                   	push   %ecx
  801f0c:	52                   	push   %edx
  801f0d:	ff 75 0c             	pushl  0xc(%ebp)
  801f10:	50                   	push   %eax
  801f11:	6a 15                	push   $0x15
  801f13:	e8 e4 fd ff ff       	call   801cfc <syscall>
  801f18:	83 c4 18             	add    $0x18,%esp
}
  801f1b:	c9                   	leave  
  801f1c:	c3                   	ret    

00801f1d <sys_size_of_shared_object>:

//2017:
int sys_size_of_shared_object(int32 ownerID, char* shareName)
{
  801f1d:	55                   	push   %ebp
  801f1e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801f20:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f23:	8b 45 08             	mov    0x8(%ebp),%eax
  801f26:	6a 00                	push   $0x0
  801f28:	6a 00                	push   $0x0
  801f2a:	6a 00                	push   $0x0
  801f2c:	52                   	push   %edx
  801f2d:	50                   	push   %eax
  801f2e:	6a 16                	push   $0x16
  801f30:	e8 c7 fd ff ff       	call   801cfc <syscall>
  801f35:	83 c4 18             	add    $0x18,%esp
}
  801f38:	c9                   	leave  
  801f39:	c3                   	ret    

00801f3a <sys_get_shared_object>:
//==========

int sys_get_shared_object(int32 ownerID, char* shareName, void* virtual_address)
{
  801f3a:	55                   	push   %ebp
  801f3b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801f3d:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801f40:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f43:	8b 45 08             	mov    0x8(%ebp),%eax
  801f46:	6a 00                	push   $0x0
  801f48:	6a 00                	push   $0x0
  801f4a:	51                   	push   %ecx
  801f4b:	52                   	push   %edx
  801f4c:	50                   	push   %eax
  801f4d:	6a 17                	push   $0x17
  801f4f:	e8 a8 fd ff ff       	call   801cfc <syscall>
  801f54:	83 c4 18             	add    $0x18,%esp
}
  801f57:	c9                   	leave  
  801f58:	c3                   	ret    

00801f59 <sys_delete_shared_object>:

int sys_delete_shared_object(int32 sharedObjectID, void *startVA)
{
  801f59:	55                   	push   %ebp
  801f5a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801f5c:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f5f:	8b 45 08             	mov    0x8(%ebp),%eax
  801f62:	6a 00                	push   $0x0
  801f64:	6a 00                	push   $0x0
  801f66:	6a 00                	push   $0x0
  801f68:	52                   	push   %edx
  801f69:	50                   	push   %eax
  801f6a:	6a 18                	push   $0x18
  801f6c:	e8 8b fd ff ff       	call   801cfc <syscall>
  801f71:	83 c4 18             	add    $0x18,%esp
}
  801f74:	c9                   	leave  
  801f75:	c3                   	ret    

00801f76 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801f76:	55                   	push   %ebp
  801f77:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801f79:	8b 45 08             	mov    0x8(%ebp),%eax
  801f7c:	6a 00                	push   $0x0
  801f7e:	ff 75 14             	pushl  0x14(%ebp)
  801f81:	ff 75 10             	pushl  0x10(%ebp)
  801f84:	ff 75 0c             	pushl  0xc(%ebp)
  801f87:	50                   	push   %eax
  801f88:	6a 19                	push   $0x19
  801f8a:	e8 6d fd ff ff       	call   801cfc <syscall>
  801f8f:	83 c4 18             	add    $0x18,%esp
}
  801f92:	c9                   	leave  
  801f93:	c3                   	ret    

00801f94 <sys_run_env>:

void sys_run_env(int32 envId)
{
  801f94:	55                   	push   %ebp
  801f95:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801f97:	8b 45 08             	mov    0x8(%ebp),%eax
  801f9a:	6a 00                	push   $0x0
  801f9c:	6a 00                	push   $0x0
  801f9e:	6a 00                	push   $0x0
  801fa0:	6a 00                	push   $0x0
  801fa2:	50                   	push   %eax
  801fa3:	6a 1a                	push   $0x1a
  801fa5:	e8 52 fd ff ff       	call   801cfc <syscall>
  801faa:	83 c4 18             	add    $0x18,%esp
}
  801fad:	90                   	nop
  801fae:	c9                   	leave  
  801faf:	c3                   	ret    

00801fb0 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801fb0:	55                   	push   %ebp
  801fb1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801fb3:	8b 45 08             	mov    0x8(%ebp),%eax
  801fb6:	6a 00                	push   $0x0
  801fb8:	6a 00                	push   $0x0
  801fba:	6a 00                	push   $0x0
  801fbc:	6a 00                	push   $0x0
  801fbe:	50                   	push   %eax
  801fbf:	6a 1b                	push   $0x1b
  801fc1:	e8 36 fd ff ff       	call   801cfc <syscall>
  801fc6:	83 c4 18             	add    $0x18,%esp
}
  801fc9:	c9                   	leave  
  801fca:	c3                   	ret    

00801fcb <sys_getenvid>:

int32 sys_getenvid(void)
{
  801fcb:	55                   	push   %ebp
  801fcc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801fce:	6a 00                	push   $0x0
  801fd0:	6a 00                	push   $0x0
  801fd2:	6a 00                	push   $0x0
  801fd4:	6a 00                	push   $0x0
  801fd6:	6a 00                	push   $0x0
  801fd8:	6a 05                	push   $0x5
  801fda:	e8 1d fd ff ff       	call   801cfc <syscall>
  801fdf:	83 c4 18             	add    $0x18,%esp
}
  801fe2:	c9                   	leave  
  801fe3:	c3                   	ret    

00801fe4 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801fe4:	55                   	push   %ebp
  801fe5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801fe7:	6a 00                	push   $0x0
  801fe9:	6a 00                	push   $0x0
  801feb:	6a 00                	push   $0x0
  801fed:	6a 00                	push   $0x0
  801fef:	6a 00                	push   $0x0
  801ff1:	6a 06                	push   $0x6
  801ff3:	e8 04 fd ff ff       	call   801cfc <syscall>
  801ff8:	83 c4 18             	add    $0x18,%esp
}
  801ffb:	c9                   	leave  
  801ffc:	c3                   	ret    

00801ffd <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801ffd:	55                   	push   %ebp
  801ffe:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  802000:	6a 00                	push   $0x0
  802002:	6a 00                	push   $0x0
  802004:	6a 00                	push   $0x0
  802006:	6a 00                	push   $0x0
  802008:	6a 00                	push   $0x0
  80200a:	6a 07                	push   $0x7
  80200c:	e8 eb fc ff ff       	call   801cfc <syscall>
  802011:	83 c4 18             	add    $0x18,%esp
}
  802014:	c9                   	leave  
  802015:	c3                   	ret    

00802016 <sys_exit_env>:


void sys_exit_env(void)
{
  802016:	55                   	push   %ebp
  802017:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  802019:	6a 00                	push   $0x0
  80201b:	6a 00                	push   $0x0
  80201d:	6a 00                	push   $0x0
  80201f:	6a 00                	push   $0x0
  802021:	6a 00                	push   $0x0
  802023:	6a 1c                	push   $0x1c
  802025:	e8 d2 fc ff ff       	call   801cfc <syscall>
  80202a:	83 c4 18             	add    $0x18,%esp
}
  80202d:	90                   	nop
  80202e:	c9                   	leave  
  80202f:	c3                   	ret    

00802030 <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  802030:	55                   	push   %ebp
  802031:	89 e5                	mov    %esp,%ebp
  802033:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  802036:	8d 45 f8             	lea    -0x8(%ebp),%eax
  802039:	8d 50 04             	lea    0x4(%eax),%edx
  80203c:	8d 45 f8             	lea    -0x8(%ebp),%eax
  80203f:	6a 00                	push   $0x0
  802041:	6a 00                	push   $0x0
  802043:	6a 00                	push   $0x0
  802045:	52                   	push   %edx
  802046:	50                   	push   %eax
  802047:	6a 1d                	push   $0x1d
  802049:	e8 ae fc ff ff       	call   801cfc <syscall>
  80204e:	83 c4 18             	add    $0x18,%esp
	return result;
  802051:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802054:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802057:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80205a:	89 01                	mov    %eax,(%ecx)
  80205c:	89 51 04             	mov    %edx,0x4(%ecx)
}
  80205f:	8b 45 08             	mov    0x8(%ebp),%eax
  802062:	c9                   	leave  
  802063:	c2 04 00             	ret    $0x4

00802066 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  802066:	55                   	push   %ebp
  802067:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  802069:	6a 00                	push   $0x0
  80206b:	6a 00                	push   $0x0
  80206d:	ff 75 10             	pushl  0x10(%ebp)
  802070:	ff 75 0c             	pushl  0xc(%ebp)
  802073:	ff 75 08             	pushl  0x8(%ebp)
  802076:	6a 13                	push   $0x13
  802078:	e8 7f fc ff ff       	call   801cfc <syscall>
  80207d:	83 c4 18             	add    $0x18,%esp
	return ;
  802080:	90                   	nop
}
  802081:	c9                   	leave  
  802082:	c3                   	ret    

00802083 <sys_rcr2>:
uint32 sys_rcr2()
{
  802083:	55                   	push   %ebp
  802084:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  802086:	6a 00                	push   $0x0
  802088:	6a 00                	push   $0x0
  80208a:	6a 00                	push   $0x0
  80208c:	6a 00                	push   $0x0
  80208e:	6a 00                	push   $0x0
  802090:	6a 1e                	push   $0x1e
  802092:	e8 65 fc ff ff       	call   801cfc <syscall>
  802097:	83 c4 18             	add    $0x18,%esp
}
  80209a:	c9                   	leave  
  80209b:	c3                   	ret    

0080209c <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  80209c:	55                   	push   %ebp
  80209d:	89 e5                	mov    %esp,%ebp
  80209f:	83 ec 04             	sub    $0x4,%esp
  8020a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8020a5:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  8020a8:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  8020ac:	6a 00                	push   $0x0
  8020ae:	6a 00                	push   $0x0
  8020b0:	6a 00                	push   $0x0
  8020b2:	6a 00                	push   $0x0
  8020b4:	50                   	push   %eax
  8020b5:	6a 1f                	push   $0x1f
  8020b7:	e8 40 fc ff ff       	call   801cfc <syscall>
  8020bc:	83 c4 18             	add    $0x18,%esp
	return ;
  8020bf:	90                   	nop
}
  8020c0:	c9                   	leave  
  8020c1:	c3                   	ret    

008020c2 <rsttst>:
void rsttst()
{
  8020c2:	55                   	push   %ebp
  8020c3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  8020c5:	6a 00                	push   $0x0
  8020c7:	6a 00                	push   $0x0
  8020c9:	6a 00                	push   $0x0
  8020cb:	6a 00                	push   $0x0
  8020cd:	6a 00                	push   $0x0
  8020cf:	6a 21                	push   $0x21
  8020d1:	e8 26 fc ff ff       	call   801cfc <syscall>
  8020d6:	83 c4 18             	add    $0x18,%esp
	return ;
  8020d9:	90                   	nop
}
  8020da:	c9                   	leave  
  8020db:	c3                   	ret    

008020dc <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  8020dc:	55                   	push   %ebp
  8020dd:	89 e5                	mov    %esp,%ebp
  8020df:	83 ec 04             	sub    $0x4,%esp
  8020e2:	8b 45 14             	mov    0x14(%ebp),%eax
  8020e5:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  8020e8:	8b 55 18             	mov    0x18(%ebp),%edx
  8020eb:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8020ef:	52                   	push   %edx
  8020f0:	50                   	push   %eax
  8020f1:	ff 75 10             	pushl  0x10(%ebp)
  8020f4:	ff 75 0c             	pushl  0xc(%ebp)
  8020f7:	ff 75 08             	pushl  0x8(%ebp)
  8020fa:	6a 20                	push   $0x20
  8020fc:	e8 fb fb ff ff       	call   801cfc <syscall>
  802101:	83 c4 18             	add    $0x18,%esp
	return ;
  802104:	90                   	nop
}
  802105:	c9                   	leave  
  802106:	c3                   	ret    

00802107 <chktst>:
void chktst(uint32 n)
{
  802107:	55                   	push   %ebp
  802108:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  80210a:	6a 00                	push   $0x0
  80210c:	6a 00                	push   $0x0
  80210e:	6a 00                	push   $0x0
  802110:	6a 00                	push   $0x0
  802112:	ff 75 08             	pushl  0x8(%ebp)
  802115:	6a 22                	push   $0x22
  802117:	e8 e0 fb ff ff       	call   801cfc <syscall>
  80211c:	83 c4 18             	add    $0x18,%esp
	return ;
  80211f:	90                   	nop
}
  802120:	c9                   	leave  
  802121:	c3                   	ret    

00802122 <inctst>:

void inctst()
{
  802122:	55                   	push   %ebp
  802123:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  802125:	6a 00                	push   $0x0
  802127:	6a 00                	push   $0x0
  802129:	6a 00                	push   $0x0
  80212b:	6a 00                	push   $0x0
  80212d:	6a 00                	push   $0x0
  80212f:	6a 23                	push   $0x23
  802131:	e8 c6 fb ff ff       	call   801cfc <syscall>
  802136:	83 c4 18             	add    $0x18,%esp
	return ;
  802139:	90                   	nop
}
  80213a:	c9                   	leave  
  80213b:	c3                   	ret    

0080213c <gettst>:
uint32 gettst()
{
  80213c:	55                   	push   %ebp
  80213d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  80213f:	6a 00                	push   $0x0
  802141:	6a 00                	push   $0x0
  802143:	6a 00                	push   $0x0
  802145:	6a 00                	push   $0x0
  802147:	6a 00                	push   $0x0
  802149:	6a 24                	push   $0x24
  80214b:	e8 ac fb ff ff       	call   801cfc <syscall>
  802150:	83 c4 18             	add    $0x18,%esp
}
  802153:	c9                   	leave  
  802154:	c3                   	ret    

00802155 <sys_get_uheap_strategy>:

/*2025*/
uint32 sys_get_uheap_strategy()
{
  802155:	55                   	push   %ebp
  802156:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802158:	6a 00                	push   $0x0
  80215a:	6a 00                	push   $0x0
  80215c:	6a 00                	push   $0x0
  80215e:	6a 00                	push   $0x0
  802160:	6a 00                	push   $0x0
  802162:	6a 25                	push   $0x25
  802164:	e8 93 fb ff ff       	call   801cfc <syscall>
  802169:	83 c4 18             	add    $0x18,%esp
  80216c:	a3 60 c0 81 00       	mov    %eax,0x81c060
	return uheapPlaceStrategy ;
  802171:	a1 60 c0 81 00       	mov    0x81c060,%eax
}
  802176:	c9                   	leave  
  802177:	c3                   	ret    

00802178 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  802178:	55                   	push   %ebp
  802179:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = heapStrategy;
  80217b:	8b 45 08             	mov    0x8(%ebp),%eax
  80217e:	a3 60 c0 81 00       	mov    %eax,0x81c060
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  802183:	6a 00                	push   $0x0
  802185:	6a 00                	push   $0x0
  802187:	6a 00                	push   $0x0
  802189:	6a 00                	push   $0x0
  80218b:	ff 75 08             	pushl  0x8(%ebp)
  80218e:	6a 26                	push   $0x26
  802190:	e8 67 fb ff ff       	call   801cfc <syscall>
  802195:	83 c4 18             	add    $0x18,%esp
	return ;
  802198:	90                   	nop
}
  802199:	c9                   	leave  
  80219a:	c3                   	ret    

0080219b <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  80219b:	55                   	push   %ebp
  80219c:	89 e5                	mov    %esp,%ebp
  80219e:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  80219f:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8021a2:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8021a5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8021a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8021ab:	6a 00                	push   $0x0
  8021ad:	53                   	push   %ebx
  8021ae:	51                   	push   %ecx
  8021af:	52                   	push   %edx
  8021b0:	50                   	push   %eax
  8021b1:	6a 27                	push   $0x27
  8021b3:	e8 44 fb ff ff       	call   801cfc <syscall>
  8021b8:	83 c4 18             	add    $0x18,%esp
}
  8021bb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8021be:	c9                   	leave  
  8021bf:	c3                   	ret    

008021c0 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  8021c0:	55                   	push   %ebp
  8021c1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  8021c3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8021c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8021c9:	6a 00                	push   $0x0
  8021cb:	6a 00                	push   $0x0
  8021cd:	6a 00                	push   $0x0
  8021cf:	52                   	push   %edx
  8021d0:	50                   	push   %eax
  8021d1:	6a 28                	push   $0x28
  8021d3:	e8 24 fb ff ff       	call   801cfc <syscall>
  8021d8:	83 c4 18             	add    $0x18,%esp
}
  8021db:	c9                   	leave  
  8021dc:	c3                   	ret    

008021dd <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  8021dd:	55                   	push   %ebp
  8021de:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  8021e0:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8021e3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8021e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8021e9:	6a 00                	push   $0x0
  8021eb:	51                   	push   %ecx
  8021ec:	ff 75 10             	pushl  0x10(%ebp)
  8021ef:	52                   	push   %edx
  8021f0:	50                   	push   %eax
  8021f1:	6a 29                	push   $0x29
  8021f3:	e8 04 fb ff ff       	call   801cfc <syscall>
  8021f8:	83 c4 18             	add    $0x18,%esp
}
  8021fb:	c9                   	leave  
  8021fc:	c3                   	ret    

008021fd <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  8021fd:	55                   	push   %ebp
  8021fe:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  802200:	6a 00                	push   $0x0
  802202:	6a 00                	push   $0x0
  802204:	ff 75 10             	pushl  0x10(%ebp)
  802207:	ff 75 0c             	pushl  0xc(%ebp)
  80220a:	ff 75 08             	pushl  0x8(%ebp)
  80220d:	6a 12                	push   $0x12
  80220f:	e8 e8 fa ff ff       	call   801cfc <syscall>
  802214:	83 c4 18             	add    $0x18,%esp
	return ;
  802217:	90                   	nop
}
  802218:	c9                   	leave  
  802219:	c3                   	ret    

0080221a <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  80221a:	55                   	push   %ebp
  80221b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  80221d:	8b 55 0c             	mov    0xc(%ebp),%edx
  802220:	8b 45 08             	mov    0x8(%ebp),%eax
  802223:	6a 00                	push   $0x0
  802225:	6a 00                	push   $0x0
  802227:	6a 00                	push   $0x0
  802229:	52                   	push   %edx
  80222a:	50                   	push   %eax
  80222b:	6a 2a                	push   $0x2a
  80222d:	e8 ca fa ff ff       	call   801cfc <syscall>
  802232:	83 c4 18             	add    $0x18,%esp
	return;
  802235:	90                   	nop
}
  802236:	c9                   	leave  
  802237:	c3                   	ret    

00802238 <sys_get_optimal_num_faults>:
/*2025*/
int sys_get_optimal_num_faults()
{
  802238:	55                   	push   %ebp
  802239:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_optimal_num_faults, 0, 0, 0, 0, 0);
  80223b:	6a 00                	push   $0x0
  80223d:	6a 00                	push   $0x0
  80223f:	6a 00                	push   $0x0
  802241:	6a 00                	push   $0x0
  802243:	6a 00                	push   $0x0
  802245:	6a 2b                	push   $0x2b
  802247:	e8 b0 fa ff ff       	call   801cfc <syscall>
  80224c:	83 c4 18             	add    $0x18,%esp
}
  80224f:	c9                   	leave  
  802250:	c3                   	ret    

00802251 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  802251:	55                   	push   %ebp
  802252:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  802254:	6a 00                	push   $0x0
  802256:	6a 00                	push   $0x0
  802258:	6a 00                	push   $0x0
  80225a:	ff 75 0c             	pushl  0xc(%ebp)
  80225d:	ff 75 08             	pushl  0x8(%ebp)
  802260:	6a 2d                	push   $0x2d
  802262:	e8 95 fa ff ff       	call   801cfc <syscall>
  802267:	83 c4 18             	add    $0x18,%esp
	return;
  80226a:	90                   	nop
}
  80226b:	c9                   	leave  
  80226c:	c3                   	ret    

0080226d <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  80226d:	55                   	push   %ebp
  80226e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  802270:	6a 00                	push   $0x0
  802272:	6a 00                	push   $0x0
  802274:	6a 00                	push   $0x0
  802276:	ff 75 0c             	pushl  0xc(%ebp)
  802279:	ff 75 08             	pushl  0x8(%ebp)
  80227c:	6a 2c                	push   $0x2c
  80227e:	e8 79 fa ff ff       	call   801cfc <syscall>
  802283:	83 c4 18             	add    $0x18,%esp
	return ;
  802286:	90                   	nop
}
  802287:	c9                   	leave  
  802288:	c3                   	ret    

00802289 <sys_env_set_priority>:


void sys_env_set_priority(int32 envID, int priority)
{
  802289:	55                   	push   %ebp
  80228a:	89 e5                	mov    %esp,%ebp
  80228c:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.IM#4] CPU SCHEDULING - #1 System Calls - Add suitable code here
	//Your code is here
	//Comment the following line
	panic("sys_env_set_priority() is not implemented yet...!!");
  80228f:	83 ec 04             	sub    $0x4,%esp
  802292:	68 08 39 80 00       	push   $0x803908
  802297:	68 25 01 00 00       	push   $0x125
  80229c:	68 3b 39 80 00       	push   $0x80393b
  8022a1:	e8 e4 e4 ff ff       	call   80078a <_panic>

008022a6 <to_page_va>:
//==================================
//==================================
// [1] GET PAGE VA:
//==================================
__inline__ uint32 to_page_va(struct PageInfoElement *ptrPageInfo)
{
  8022a6:	55                   	push   %ebp
  8022a7:	89 e5                	mov    %esp,%ebp
  8022a9:	83 ec 18             	sub    $0x18,%esp
	if (ptrPageInfo < &pageBlockInfoArr[0] || ptrPageInfo >= &pageBlockInfoArr[DYN_ALLOC_MAX_SIZE/PAGE_SIZE])
  8022ac:	81 7d 08 60 40 80 00 	cmpl   $0x804060,0x8(%ebp)
  8022b3:	72 09                	jb     8022be <to_page_va+0x18>
  8022b5:	81 7d 08 60 c0 81 00 	cmpl   $0x81c060,0x8(%ebp)
  8022bc:	72 14                	jb     8022d2 <to_page_va+0x2c>
			panic("to_page_va called with invalid pageInfoPtr");
  8022be:	83 ec 04             	sub    $0x4,%esp
  8022c1:	68 4c 39 80 00       	push   $0x80394c
  8022c6:	6a 15                	push   $0x15
  8022c8:	68 77 39 80 00       	push   $0x803977
  8022cd:	e8 b8 e4 ff ff       	call   80078a <_panic>
	//Get start VA of the page from the corresponding Page Info pointer
	int idxInPageInfoArr = (ptrPageInfo - pageBlockInfoArr);
  8022d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8022d5:	ba 60 40 80 00       	mov    $0x804060,%edx
  8022da:	29 d0                	sub    %edx,%eax
  8022dc:	c1 f8 02             	sar    $0x2,%eax
  8022df:	89 c2                	mov    %eax,%edx
  8022e1:	89 d0                	mov    %edx,%eax
  8022e3:	c1 e0 02             	shl    $0x2,%eax
  8022e6:	01 d0                	add    %edx,%eax
  8022e8:	c1 e0 02             	shl    $0x2,%eax
  8022eb:	01 d0                	add    %edx,%eax
  8022ed:	c1 e0 02             	shl    $0x2,%eax
  8022f0:	01 d0                	add    %edx,%eax
  8022f2:	89 c1                	mov    %eax,%ecx
  8022f4:	c1 e1 08             	shl    $0x8,%ecx
  8022f7:	01 c8                	add    %ecx,%eax
  8022f9:	89 c1                	mov    %eax,%ecx
  8022fb:	c1 e1 10             	shl    $0x10,%ecx
  8022fe:	01 c8                	add    %ecx,%eax
  802300:	01 c0                	add    %eax,%eax
  802302:	01 d0                	add    %edx,%eax
  802304:	89 45 f4             	mov    %eax,-0xc(%ebp)
	return dynAllocStart + (idxInPageInfoArr << PGSHIFT);
  802307:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80230a:	c1 e0 0c             	shl    $0xc,%eax
  80230d:	89 c2                	mov    %eax,%edx
  80230f:	a1 64 c0 81 00       	mov    0x81c064,%eax
  802314:	01 d0                	add    %edx,%eax
}
  802316:	c9                   	leave  
  802317:	c3                   	ret    

00802318 <to_page_info>:

//==================================
// [2] GET PAGE INFO OF PAGE VA:
//==================================
__inline__ struct PageInfoElement * to_page_info(uint32 va)
{
  802318:	55                   	push   %ebp
  802319:	89 e5                	mov    %esp,%ebp
  80231b:	83 ec 18             	sub    $0x18,%esp
	int idxInPageInfoArr = (va - dynAllocStart) >> PGSHIFT;
  80231e:	a1 64 c0 81 00       	mov    0x81c064,%eax
  802323:	8b 55 08             	mov    0x8(%ebp),%edx
  802326:	29 c2                	sub    %eax,%edx
  802328:	89 d0                	mov    %edx,%eax
  80232a:	c1 e8 0c             	shr    $0xc,%eax
  80232d:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if (idxInPageInfoArr < 0 || idxInPageInfoArr >= DYN_ALLOC_MAX_SIZE/PAGE_SIZE)
  802330:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802334:	78 09                	js     80233f <to_page_info+0x27>
  802336:	81 7d f4 ff 1f 00 00 	cmpl   $0x1fff,-0xc(%ebp)
  80233d:	7e 14                	jle    802353 <to_page_info+0x3b>
		panic("to_page_info called with invalid pa");
  80233f:	83 ec 04             	sub    $0x4,%esp
  802342:	68 90 39 80 00       	push   $0x803990
  802347:	6a 22                	push   $0x22
  802349:	68 77 39 80 00       	push   $0x803977
  80234e:	e8 37 e4 ff ff       	call   80078a <_panic>
	return &pageBlockInfoArr[idxInPageInfoArr];
  802353:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802356:	89 d0                	mov    %edx,%eax
  802358:	01 c0                	add    %eax,%eax
  80235a:	01 d0                	add    %edx,%eax
  80235c:	c1 e0 02             	shl    $0x2,%eax
  80235f:	05 60 40 80 00       	add    $0x804060,%eax
}
  802364:	c9                   	leave  
  802365:	c3                   	ret    

00802366 <initialize_dynamic_allocator>:
//==================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================
bool is_initialized = 0;
void initialize_dynamic_allocator(uint32 daStart, uint32 daEnd)
{
  802366:	55                   	push   %ebp
  802367:	89 e5                	mov    %esp,%ebp
  802369:	83 ec 18             	sub    $0x18,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		assert(daEnd <= daStart + DYN_ALLOC_MAX_SIZE);
  80236c:	8b 45 08             	mov    0x8(%ebp),%eax
  80236f:	05 00 00 00 02       	add    $0x2000000,%eax
  802374:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802377:	73 16                	jae    80238f <initialize_dynamic_allocator+0x29>
  802379:	68 b4 39 80 00       	push   $0x8039b4
  80237e:	68 da 39 80 00       	push   $0x8039da
  802383:	6a 34                	push   $0x34
  802385:	68 77 39 80 00       	push   $0x803977
  80238a:	e8 fb e3 ff ff       	call   80078a <_panic>
		is_initialized = 1;
  80238f:	c7 05 28 40 80 00 01 	movl   $0x1,0x804028
  802396:	00 00 00 
	//==================================================================================
	//==================================================================================
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #1 initialize_dynamic_allocator
	//Your code is here
	// init bounds of the dynalloc
	dynAllocStart = daStart;
  802399:	8b 45 08             	mov    0x8(%ebp),%eax
  80239c:	a3 64 c0 81 00       	mov    %eax,0x81c064
	dynAllocEnd = daEnd;
  8023a1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8023a4:	a3 40 40 80 00       	mov    %eax,0x804040
	// init the list that keep track of all free pageBlockInfoArr instances.
	LIST_INIT(&freePagesList);
  8023a9:	c7 05 48 40 80 00 00 	movl   $0x0,0x804048
  8023b0:	00 00 00 
  8023b3:	c7 05 4c 40 80 00 00 	movl   $0x0,0x80404c
  8023ba:	00 00 00 
  8023bd:	c7 05 54 40 80 00 00 	movl   $0x0,0x804054
  8023c4:	00 00 00 

	// no.of pages in the dynamic allocator.
	int pCount = (daEnd - daStart) / PAGE_SIZE;
  8023c7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8023ca:	2b 45 08             	sub    0x8(%ebp),%eax
  8023cd:	c1 e8 0c             	shr    $0xc,%eax
  8023d0:	89 45 ec             	mov    %eax,-0x14(%ebp)
	// iterate over each page and init its data in pageBlockInfoArr and reset it.
	for (int i = 0; i < pCount; ++i) {
  8023d3:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  8023da:	e9 c8 00 00 00       	jmp    8024a7 <initialize_dynamic_allocator+0x141>
	    pageBlockInfoArr[i].block_size = 0;
  8023df:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8023e2:	89 d0                	mov    %edx,%eax
  8023e4:	01 c0                	add    %eax,%eax
  8023e6:	01 d0                	add    %edx,%eax
  8023e8:	c1 e0 02             	shl    $0x2,%eax
  8023eb:	05 68 40 80 00       	add    $0x804068,%eax
  8023f0:	66 c7 00 00 00       	movw   $0x0,(%eax)
	    pageBlockInfoArr[i].num_of_free_blocks = 0;
  8023f5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8023f8:	89 d0                	mov    %edx,%eax
  8023fa:	01 c0                	add    %eax,%eax
  8023fc:	01 d0                	add    %edx,%eax
  8023fe:	c1 e0 02             	shl    $0x2,%eax
  802401:	05 6a 40 80 00       	add    $0x80406a,%eax
  802406:	66 c7 00 00 00       	movw   $0x0,(%eax)
	    LIST_INSERT_TAIL(&freePagesList, &pageBlockInfoArr[i]);
  80240b:	8b 15 4c 40 80 00    	mov    0x80404c,%edx
  802411:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  802414:	89 c8                	mov    %ecx,%eax
  802416:	01 c0                	add    %eax,%eax
  802418:	01 c8                	add    %ecx,%eax
  80241a:	c1 e0 02             	shl    $0x2,%eax
  80241d:	05 64 40 80 00       	add    $0x804064,%eax
  802422:	89 10                	mov    %edx,(%eax)
  802424:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802427:	89 d0                	mov    %edx,%eax
  802429:	01 c0                	add    %eax,%eax
  80242b:	01 d0                	add    %edx,%eax
  80242d:	c1 e0 02             	shl    $0x2,%eax
  802430:	05 64 40 80 00       	add    $0x804064,%eax
  802435:	8b 00                	mov    (%eax),%eax
  802437:	85 c0                	test   %eax,%eax
  802439:	74 1b                	je     802456 <initialize_dynamic_allocator+0xf0>
  80243b:	8b 15 4c 40 80 00    	mov    0x80404c,%edx
  802441:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  802444:	89 c8                	mov    %ecx,%eax
  802446:	01 c0                	add    %eax,%eax
  802448:	01 c8                	add    %ecx,%eax
  80244a:	c1 e0 02             	shl    $0x2,%eax
  80244d:	05 60 40 80 00       	add    $0x804060,%eax
  802452:	89 02                	mov    %eax,(%edx)
  802454:	eb 16                	jmp    80246c <initialize_dynamic_allocator+0x106>
  802456:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802459:	89 d0                	mov    %edx,%eax
  80245b:	01 c0                	add    %eax,%eax
  80245d:	01 d0                	add    %edx,%eax
  80245f:	c1 e0 02             	shl    $0x2,%eax
  802462:	05 60 40 80 00       	add    $0x804060,%eax
  802467:	a3 48 40 80 00       	mov    %eax,0x804048
  80246c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80246f:	89 d0                	mov    %edx,%eax
  802471:	01 c0                	add    %eax,%eax
  802473:	01 d0                	add    %edx,%eax
  802475:	c1 e0 02             	shl    $0x2,%eax
  802478:	05 60 40 80 00       	add    $0x804060,%eax
  80247d:	a3 4c 40 80 00       	mov    %eax,0x80404c
  802482:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802485:	89 d0                	mov    %edx,%eax
  802487:	01 c0                	add    %eax,%eax
  802489:	01 d0                	add    %edx,%eax
  80248b:	c1 e0 02             	shl    $0x2,%eax
  80248e:	05 60 40 80 00       	add    $0x804060,%eax
  802493:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802499:	a1 54 40 80 00       	mov    0x804054,%eax
  80249e:	40                   	inc    %eax
  80249f:	a3 54 40 80 00       	mov    %eax,0x804054
	LIST_INIT(&freePagesList);

	// no.of pages in the dynamic allocator.
	int pCount = (daEnd - daStart) / PAGE_SIZE;
	// iterate over each page and init its data in pageBlockInfoArr and reset it.
	for (int i = 0; i < pCount; ++i) {
  8024a4:	ff 45 f4             	incl   -0xc(%ebp)
  8024a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024aa:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  8024ad:	0f 8c 2c ff ff ff    	jl     8023df <initialize_dynamic_allocator+0x79>
	    LIST_INSERT_TAIL(&freePagesList, &pageBlockInfoArr[i]);
	}
	// init the array of lists of each size..
	// 8 16 32 64 128 256 512 1024 2056
	// 0 1  2  3   4  5    6   7    8
	for (int i = 0; i <= (LOG2_MAX_SIZE - LOG2_MIN_SIZE); ++i){
  8024b3:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8024ba:	eb 36                	jmp    8024f2 <initialize_dynamic_allocator+0x18c>
		LIST_INIT(&freeBlockLists[i]);
  8024bc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024bf:	c1 e0 04             	shl    $0x4,%eax
  8024c2:	05 80 c0 81 00       	add    $0x81c080,%eax
  8024c7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8024cd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024d0:	c1 e0 04             	shl    $0x4,%eax
  8024d3:	05 84 c0 81 00       	add    $0x81c084,%eax
  8024d8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8024de:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024e1:	c1 e0 04             	shl    $0x4,%eax
  8024e4:	05 8c c0 81 00       	add    $0x81c08c,%eax
  8024e9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	    LIST_INSERT_TAIL(&freePagesList, &pageBlockInfoArr[i]);
	}
	// init the array of lists of each size..
	// 8 16 32 64 128 256 512 1024 2056
	// 0 1  2  3   4  5    6   7    8
	for (int i = 0; i <= (LOG2_MAX_SIZE - LOG2_MIN_SIZE); ++i){
  8024ef:	ff 45 f0             	incl   -0x10(%ebp)
  8024f2:	83 7d f0 08          	cmpl   $0x8,-0x10(%ebp)
  8024f6:	7e c4                	jle    8024bc <initialize_dynamic_allocator+0x156>
		LIST_INIT(&freeBlockLists[i]);
	}
	//Comment the following line
	//panic("initialize_dynamic_allocator() Not implemented yet");

}
  8024f8:	90                   	nop
  8024f9:	c9                   	leave  
  8024fa:	c3                   	ret    

008024fb <get_block_size>:

//===========================
// [2] GET BLOCK SIZE:
//===========================
__inline__ uint32 get_block_size(void *va)
{
  8024fb:	55                   	push   %ebp
  8024fc:	89 e5                	mov    %esp,%ebp
  8024fe:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #2 get_block_size
	//Your code is here
	// get the page that saves this va
	struct PageInfoElement* ptr = to_page_info((uint32)va);
  802501:	8b 45 08             	mov    0x8(%ebp),%eax
  802504:	83 ec 0c             	sub    $0xc,%esp
  802507:	50                   	push   %eax
  802508:	e8 0b fe ff ff       	call   802318 <to_page_info>
  80250d:	83 c4 10             	add    $0x10,%esp
  802510:	89 45 f4             	mov    %eax,-0xc(%ebp)
	return ptr->block_size;
  802513:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802516:	8b 40 08             	mov    0x8(%eax),%eax
  802519:	0f b7 c0             	movzwl %ax,%eax
	//Comment the following line
	//panic("get_block_size() Not implemented yet");
}
  80251c:	c9                   	leave  
  80251d:	c3                   	ret    

0080251e <split_page_to_blocks>:
// =====================
// h) split page to blocks and add them in freeBlockLists
// =====================
// function that split the page provided into same sized blocks
//and putem in suitable freeblockList index according to size.
 void split_page_to_blocks(uint32 blk_size, struct PageInfoElement *pageInfo) {
  80251e:	55                   	push   %ebp
  80251f:	89 e5                	mov    %esp,%ebp
  802521:	83 ec 28             	sub    $0x28,%esp
	 // cur page virtual address by the pageInfo.
	 uint32 page_va = (uint32)to_page_va(pageInfo);
  802524:	83 ec 0c             	sub    $0xc,%esp
  802527:	ff 75 0c             	pushl  0xc(%ebp)
  80252a:	e8 77 fd ff ff       	call   8022a6 <to_page_va>
  80252f:	83 c4 10             	add    $0x10,%esp
  802532:	89 45 e8             	mov    %eax,-0x18(%ebp)
	 // no. of blks to save in freeblockList.
	 int blk_count = PAGE_SIZE / blk_size;
  802535:	b8 00 10 00 00       	mov    $0x1000,%eax
  80253a:	ba 00 00 00 00       	mov    $0x0,%edx
  80253f:	f7 75 08             	divl   0x8(%ebp)
  802542:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	 // save page in memory.
	 get_page((uint32*)page_va);
  802545:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802548:	83 ec 0c             	sub    $0xc,%esp
  80254b:	50                   	push   %eax
  80254c:	e8 48 f6 ff ff       	call   801b99 <get_page>
  802551:	83 c4 10             	add    $0x10,%esp
	 // assigning the pageInfo data block size, free block which is whole block count.
	 pageInfo->num_of_free_blocks = blk_count;
  802554:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802557:	8b 55 0c             	mov    0xc(%ebp),%edx
  80255a:	66 89 42 0a          	mov    %ax,0xa(%edx)
	 pageInfo->block_size = blk_size;
  80255e:	8b 45 08             	mov    0x8(%ebp),%eax
  802561:	8b 55 0c             	mov    0xc(%ebp),%edx
  802564:	66 89 42 08          	mov    %ax,0x8(%edx)
	 // get index by size block in freeblocklist.
	 int idx = 0;
  802568:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	 for (int i = LOG2_MIN_SIZE; i <= LOG2_MAX_SIZE; i++) {
  80256f:	c7 45 f0 03 00 00 00 	movl   $0x3,-0x10(%ebp)
  802576:	eb 19                	jmp    802591 <split_page_to_blocks+0x73>
	     if ((1 << i) == blk_size)
  802578:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80257b:	ba 01 00 00 00       	mov    $0x1,%edx
  802580:	88 c1                	mov    %al,%cl
  802582:	d3 e2                	shl    %cl,%edx
  802584:	89 d0                	mov    %edx,%eax
  802586:	3b 45 08             	cmp    0x8(%ebp),%eax
  802589:	74 0e                	je     802599 <split_page_to_blocks+0x7b>
	         break;
	     idx++;
  80258b:	ff 45 f4             	incl   -0xc(%ebp)
	 // assigning the pageInfo data block size, free block which is whole block count.
	 pageInfo->num_of_free_blocks = blk_count;
	 pageInfo->block_size = blk_size;
	 // get index by size block in freeblocklist.
	 int idx = 0;
	 for (int i = LOG2_MIN_SIZE; i <= LOG2_MAX_SIZE; i++) {
  80258e:	ff 45 f0             	incl   -0x10(%ebp)
  802591:	83 7d f0 0b          	cmpl   $0xb,-0x10(%ebp)
  802595:	7e e1                	jle    802578 <split_page_to_blocks+0x5a>
  802597:	eb 01                	jmp    80259a <split_page_to_blocks+0x7c>
	     if ((1 << i) == blk_size)
	         break;
  802599:	90                   	nop
	     idx++;
	 }
	 // iterate over each blk and make and element of it by passing its address in blockElement pointer and save those in the list.
	 // starting from the page_va.
	 for (uint32 i = 0; i < blk_count; ++i) {
  80259a:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  8025a1:	e9 a7 00 00 00       	jmp    80264d <split_page_to_blocks+0x12f>
	     struct BlockElement *blk =(struct BlockElement*)(page_va + i * blk_size);
  8025a6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8025a9:	0f af 45 08          	imul   0x8(%ebp),%eax
  8025ad:	89 c2                	mov    %eax,%edx
  8025af:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8025b2:	01 d0                	add    %edx,%eax
  8025b4:	89 45 e0             	mov    %eax,-0x20(%ebp)
	     LIST_INSERT_TAIL(&freeBlockLists[idx],blk);
  8025b7:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8025bb:	75 14                	jne    8025d1 <split_page_to_blocks+0xb3>
  8025bd:	83 ec 04             	sub    $0x4,%esp
  8025c0:	68 f0 39 80 00       	push   $0x8039f0
  8025c5:	6a 7c                	push   $0x7c
  8025c7:	68 77 39 80 00       	push   $0x803977
  8025cc:	e8 b9 e1 ff ff       	call   80078a <_panic>
  8025d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025d4:	c1 e0 04             	shl    $0x4,%eax
  8025d7:	05 84 c0 81 00       	add    $0x81c084,%eax
  8025dc:	8b 10                	mov    (%eax),%edx
  8025de:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8025e1:	89 50 04             	mov    %edx,0x4(%eax)
  8025e4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8025e7:	8b 40 04             	mov    0x4(%eax),%eax
  8025ea:	85 c0                	test   %eax,%eax
  8025ec:	74 14                	je     802602 <split_page_to_blocks+0xe4>
  8025ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025f1:	c1 e0 04             	shl    $0x4,%eax
  8025f4:	05 84 c0 81 00       	add    $0x81c084,%eax
  8025f9:	8b 00                	mov    (%eax),%eax
  8025fb:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8025fe:	89 10                	mov    %edx,(%eax)
  802600:	eb 11                	jmp    802613 <split_page_to_blocks+0xf5>
  802602:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802605:	c1 e0 04             	shl    $0x4,%eax
  802608:	8d 90 80 c0 81 00    	lea    0x81c080(%eax),%edx
  80260e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802611:	89 02                	mov    %eax,(%edx)
  802613:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802616:	c1 e0 04             	shl    $0x4,%eax
  802619:	8d 90 84 c0 81 00    	lea    0x81c084(%eax),%edx
  80261f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802622:	89 02                	mov    %eax,(%edx)
  802624:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802627:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80262d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802630:	c1 e0 04             	shl    $0x4,%eax
  802633:	05 8c c0 81 00       	add    $0x81c08c,%eax
  802638:	8b 00                	mov    (%eax),%eax
  80263a:	8d 50 01             	lea    0x1(%eax),%edx
  80263d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802640:	c1 e0 04             	shl    $0x4,%eax
  802643:	05 8c c0 81 00       	add    $0x81c08c,%eax
  802648:	89 10                	mov    %edx,(%eax)
	         break;
	     idx++;
	 }
	 // iterate over each blk and make and element of it by passing its address in blockElement pointer and save those in the list.
	 // starting from the page_va.
	 for (uint32 i = 0; i < blk_count; ++i) {
  80264a:	ff 45 ec             	incl   -0x14(%ebp)
  80264d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802650:	39 45 ec             	cmp    %eax,-0x14(%ebp)
  802653:	0f 82 4d ff ff ff    	jb     8025a6 <split_page_to_blocks+0x88>
	     struct BlockElement *blk =(struct BlockElement*)(page_va + i * blk_size);
	     LIST_INSERT_TAIL(&freeBlockLists[idx],blk);
	 }
 }
  802659:	90                   	nop
  80265a:	c9                   	leave  
  80265b:	c3                   	ret    

0080265c <alloc_block>:

//===========================
// 3) ALLOCATE BLOCK:
//===========================
void *alloc_block(uint32 size)
{
  80265c:	55                   	push   %ebp
  80265d:	89 e5                	mov    %esp,%ebp
  80265f:	83 ec 38             	sub    $0x38,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		assert(size <= DYN_ALLOC_MAX_BLOCK_SIZE);
  802662:	81 7d 08 00 08 00 00 	cmpl   $0x800,0x8(%ebp)
  802669:	76 19                	jbe    802684 <alloc_block+0x28>
  80266b:	68 14 3a 80 00       	push   $0x803a14
  802670:	68 da 39 80 00       	push   $0x8039da
  802675:	68 8a 00 00 00       	push   $0x8a
  80267a:	68 77 39 80 00       	push   $0x803977
  80267f:	e8 06 e1 ff ff       	call   80078a <_panic>
	//==================================================================================
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #3 alloc_block
	//Your code is here
	//Comment the following line
	// get index in freeBlockList by size.
	uint32 idx = 0;
  802684:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int i = LOG2_MIN_SIZE; i <= LOG2_MAX_SIZE; ++i){
  80268b:	c7 45 f0 03 00 00 00 	movl   $0x3,-0x10(%ebp)
  802692:	eb 19                	jmp    8026ad <alloc_block+0x51>
		if((1 << i) >= size) break;
  802694:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802697:	ba 01 00 00 00       	mov    $0x1,%edx
  80269c:	88 c1                	mov    %al,%cl
  80269e:	d3 e2                	shl    %cl,%edx
  8026a0:	89 d0                	mov    %edx,%eax
  8026a2:	3b 45 08             	cmp    0x8(%ebp),%eax
  8026a5:	73 0e                	jae    8026b5 <alloc_block+0x59>
		idx++;
  8026a7:	ff 45 f4             	incl   -0xc(%ebp)
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #3 alloc_block
	//Your code is here
	//Comment the following line
	// get index in freeBlockList by size.
	uint32 idx = 0;
	for (int i = LOG2_MIN_SIZE; i <= LOG2_MAX_SIZE; ++i){
  8026aa:	ff 45 f0             	incl   -0x10(%ebp)
  8026ad:	83 7d f0 0b          	cmpl   $0xb,-0x10(%ebp)
  8026b1:	7e e1                	jle    802694 <alloc_block+0x38>
  8026b3:	eb 01                	jmp    8026b6 <alloc_block+0x5a>
		if((1 << i) >= size) break;
  8026b5:	90                   	nop
		idx++;
	}

	//case 1: the free block of the cur size is available.
	if (freeBlockLists[idx].size > 0) {
  8026b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026b9:	c1 e0 04             	shl    $0x4,%eax
  8026bc:	05 8c c0 81 00       	add    $0x81c08c,%eax
  8026c1:	8b 00                	mov    (%eax),%eax
  8026c3:	85 c0                	test   %eax,%eax
  8026c5:	0f 84 df 00 00 00    	je     8027aa <alloc_block+0x14e>

		// remove from the list and updat the pageInfoArr free blocks.
		// pop from the freeBlockList.
		struct BlockElement *blk = LIST_FIRST(&freeBlockLists[idx]);
  8026cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026ce:	c1 e0 04             	shl    $0x4,%eax
  8026d1:	05 80 c0 81 00       	add    $0x81c080,%eax
  8026d6:	8b 00                	mov    (%eax),%eax
  8026d8:	89 45 ec             	mov    %eax,-0x14(%ebp)
	    LIST_REMOVE(&freeBlockLists[idx], blk);
  8026db:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8026df:	75 17                	jne    8026f8 <alloc_block+0x9c>
  8026e1:	83 ec 04             	sub    $0x4,%esp
  8026e4:	68 35 3a 80 00       	push   $0x803a35
  8026e9:	68 9e 00 00 00       	push   $0x9e
  8026ee:	68 77 39 80 00       	push   $0x803977
  8026f3:	e8 92 e0 ff ff       	call   80078a <_panic>
  8026f8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8026fb:	8b 00                	mov    (%eax),%eax
  8026fd:	85 c0                	test   %eax,%eax
  8026ff:	74 10                	je     802711 <alloc_block+0xb5>
  802701:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802704:	8b 00                	mov    (%eax),%eax
  802706:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802709:	8b 52 04             	mov    0x4(%edx),%edx
  80270c:	89 50 04             	mov    %edx,0x4(%eax)
  80270f:	eb 14                	jmp    802725 <alloc_block+0xc9>
  802711:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802714:	8b 40 04             	mov    0x4(%eax),%eax
  802717:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80271a:	c1 e2 04             	shl    $0x4,%edx
  80271d:	81 c2 84 c0 81 00    	add    $0x81c084,%edx
  802723:	89 02                	mov    %eax,(%edx)
  802725:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802728:	8b 40 04             	mov    0x4(%eax),%eax
  80272b:	85 c0                	test   %eax,%eax
  80272d:	74 0f                	je     80273e <alloc_block+0xe2>
  80272f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802732:	8b 40 04             	mov    0x4(%eax),%eax
  802735:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802738:	8b 12                	mov    (%edx),%edx
  80273a:	89 10                	mov    %edx,(%eax)
  80273c:	eb 13                	jmp    802751 <alloc_block+0xf5>
  80273e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802741:	8b 00                	mov    (%eax),%eax
  802743:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802746:	c1 e2 04             	shl    $0x4,%edx
  802749:	81 c2 80 c0 81 00    	add    $0x81c080,%edx
  80274f:	89 02                	mov    %eax,(%edx)
  802751:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802754:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80275a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80275d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802764:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802767:	c1 e0 04             	shl    $0x4,%eax
  80276a:	05 8c c0 81 00       	add    $0x81c08c,%eax
  80276f:	8b 00                	mov    (%eax),%eax
  802771:	8d 50 ff             	lea    -0x1(%eax),%edx
  802774:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802777:	c1 e0 04             	shl    $0x4,%eax
  80277a:	05 8c c0 81 00       	add    $0x81c08c,%eax
  80277f:	89 10                	mov    %edx,(%eax)
	    // update pageBlockInfoArr
	    struct PageInfoElement *pageInfo = to_page_info((uint32)blk);
  802781:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802784:	83 ec 0c             	sub    $0xc,%esp
  802787:	50                   	push   %eax
  802788:	e8 8b fb ff ff       	call   802318 <to_page_info>
  80278d:	83 c4 10             	add    $0x10,%esp
  802790:	89 45 e8             	mov    %eax,-0x18(%ebp)
	    pageInfo->num_of_free_blocks--;
  802793:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802796:	66 8b 40 0a          	mov    0xa(%eax),%ax
  80279a:	48                   	dec    %eax
  80279b:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80279e:	66 89 42 0a          	mov    %ax,0xa(%edx)
	    return blk;
  8027a2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8027a5:	e9 bc 02 00 00       	jmp    802a66 <alloc_block+0x40a>
	}else{ //case(2, 3): 2. no free blocks available in the freeblocklist but there is free pages.
				//3. no free blocks and no available freepages so search in higher block sizes.
		// case 2:
		if(freePagesList.size > 0){ //have free pages.
  8027aa:	a1 54 40 80 00       	mov    0x804054,%eax
  8027af:	85 c0                	test   %eax,%eax
  8027b1:	0f 84 7d 02 00 00    	je     802a34 <alloc_block+0x3d8>
			// get page to split and use from freepagesList.
			struct PageInfoElement *ptr_new_page = LIST_FIRST(&freePagesList);
  8027b7:	a1 48 40 80 00       	mov    0x804048,%eax
  8027bc:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			LIST_REMOVE(&freePagesList, ptr_new_page);
  8027bf:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8027c3:	75 17                	jne    8027dc <alloc_block+0x180>
  8027c5:	83 ec 04             	sub    $0x4,%esp
  8027c8:	68 35 3a 80 00       	push   $0x803a35
  8027cd:	68 a9 00 00 00       	push   $0xa9
  8027d2:	68 77 39 80 00       	push   $0x803977
  8027d7:	e8 ae df ff ff       	call   80078a <_panic>
  8027dc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8027df:	8b 00                	mov    (%eax),%eax
  8027e1:	85 c0                	test   %eax,%eax
  8027e3:	74 10                	je     8027f5 <alloc_block+0x199>
  8027e5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8027e8:	8b 00                	mov    (%eax),%eax
  8027ea:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8027ed:	8b 52 04             	mov    0x4(%edx),%edx
  8027f0:	89 50 04             	mov    %edx,0x4(%eax)
  8027f3:	eb 0b                	jmp    802800 <alloc_block+0x1a4>
  8027f5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8027f8:	8b 40 04             	mov    0x4(%eax),%eax
  8027fb:	a3 4c 40 80 00       	mov    %eax,0x80404c
  802800:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802803:	8b 40 04             	mov    0x4(%eax),%eax
  802806:	85 c0                	test   %eax,%eax
  802808:	74 0f                	je     802819 <alloc_block+0x1bd>
  80280a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80280d:	8b 40 04             	mov    0x4(%eax),%eax
  802810:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802813:	8b 12                	mov    (%edx),%edx
  802815:	89 10                	mov    %edx,(%eax)
  802817:	eb 0a                	jmp    802823 <alloc_block+0x1c7>
  802819:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80281c:	8b 00                	mov    (%eax),%eax
  80281e:	a3 48 40 80 00       	mov    %eax,0x804048
  802823:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802826:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80282c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80282f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802836:	a1 54 40 80 00       	mov    0x804054,%eax
  80283b:	48                   	dec    %eax
  80283c:	a3 54 40 80 00       	mov    %eax,0x804054
			// from page to freeblockList by the pageInfo and the block size.
			split_page_to_blocks(1 << (idx + LOG2_MIN_SIZE), ptr_new_page);
  802841:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802844:	83 c0 03             	add    $0x3,%eax
  802847:	ba 01 00 00 00       	mov    $0x1,%edx
  80284c:	88 c1                	mov    %al,%cl
  80284e:	d3 e2                	shl    %cl,%edx
  802850:	89 d0                	mov    %edx,%eax
  802852:	83 ec 08             	sub    $0x8,%esp
  802855:	ff 75 e4             	pushl  -0x1c(%ebp)
  802858:	50                   	push   %eax
  802859:	e8 c0 fc ff ff       	call   80251e <split_page_to_blocks>
  80285e:	83 c4 10             	add    $0x10,%esp

			// remove from the list and updat the pageInfoArr free blocks.
			// pop from the freeBlockList.
			struct BlockElement *blk = LIST_FIRST(&freeBlockLists[idx]);
  802861:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802864:	c1 e0 04             	shl    $0x4,%eax
  802867:	05 80 c0 81 00       	add    $0x81c080,%eax
  80286c:	8b 00                	mov    (%eax),%eax
  80286e:	89 45 e0             	mov    %eax,-0x20(%ebp)
		    LIST_REMOVE(&freeBlockLists[idx], blk);
  802871:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  802875:	75 17                	jne    80288e <alloc_block+0x232>
  802877:	83 ec 04             	sub    $0x4,%esp
  80287a:	68 35 3a 80 00       	push   $0x803a35
  80287f:	68 b0 00 00 00       	push   $0xb0
  802884:	68 77 39 80 00       	push   $0x803977
  802889:	e8 fc de ff ff       	call   80078a <_panic>
  80288e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802891:	8b 00                	mov    (%eax),%eax
  802893:	85 c0                	test   %eax,%eax
  802895:	74 10                	je     8028a7 <alloc_block+0x24b>
  802897:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80289a:	8b 00                	mov    (%eax),%eax
  80289c:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80289f:	8b 52 04             	mov    0x4(%edx),%edx
  8028a2:	89 50 04             	mov    %edx,0x4(%eax)
  8028a5:	eb 14                	jmp    8028bb <alloc_block+0x25f>
  8028a7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8028aa:	8b 40 04             	mov    0x4(%eax),%eax
  8028ad:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8028b0:	c1 e2 04             	shl    $0x4,%edx
  8028b3:	81 c2 84 c0 81 00    	add    $0x81c084,%edx
  8028b9:	89 02                	mov    %eax,(%edx)
  8028bb:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8028be:	8b 40 04             	mov    0x4(%eax),%eax
  8028c1:	85 c0                	test   %eax,%eax
  8028c3:	74 0f                	je     8028d4 <alloc_block+0x278>
  8028c5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8028c8:	8b 40 04             	mov    0x4(%eax),%eax
  8028cb:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8028ce:	8b 12                	mov    (%edx),%edx
  8028d0:	89 10                	mov    %edx,(%eax)
  8028d2:	eb 13                	jmp    8028e7 <alloc_block+0x28b>
  8028d4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8028d7:	8b 00                	mov    (%eax),%eax
  8028d9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8028dc:	c1 e2 04             	shl    $0x4,%edx
  8028df:	81 c2 80 c0 81 00    	add    $0x81c080,%edx
  8028e5:	89 02                	mov    %eax,(%edx)
  8028e7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8028ea:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8028f0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8028f3:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8028fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028fd:	c1 e0 04             	shl    $0x4,%eax
  802900:	05 8c c0 81 00       	add    $0x81c08c,%eax
  802905:	8b 00                	mov    (%eax),%eax
  802907:	8d 50 ff             	lea    -0x1(%eax),%edx
  80290a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80290d:	c1 e0 04             	shl    $0x4,%eax
  802910:	05 8c c0 81 00       	add    $0x81c08c,%eax
  802915:	89 10                	mov    %edx,(%eax)
		    // update pageBlockInfoArr
		    struct PageInfoElement *pageInfo = to_page_info((uint32)blk);
  802917:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80291a:	83 ec 0c             	sub    $0xc,%esp
  80291d:	50                   	push   %eax
  80291e:	e8 f5 f9 ff ff       	call   802318 <to_page_info>
  802923:	83 c4 10             	add    $0x10,%esp
  802926:	89 45 dc             	mov    %eax,-0x24(%ebp)
		    pageInfo->num_of_free_blocks--;
  802929:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80292c:	66 8b 40 0a          	mov    0xa(%eax),%ax
  802930:	48                   	dec    %eax
  802931:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802934:	66 89 42 0a          	mov    %ax,0xa(%edx)
		    return blk;
  802938:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80293b:	e9 26 01 00 00       	jmp    802a66 <alloc_block+0x40a>
		}else{//case 3: no free block and no free page so iterate and try to find bigger size.
			// iterate over the list until finding available block
			while (idx <= (LOG2_MAX_SIZE - LOG2_MIN_SIZE) && freeBlockLists[idx].size == 0) {
				idx++;
  802940:	ff 45 f4             	incl   -0xc(%ebp)
				// found free block
				if(freeBlockLists[idx].size > 0){
  802943:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802946:	c1 e0 04             	shl    $0x4,%eax
  802949:	05 8c c0 81 00       	add    $0x81c08c,%eax
  80294e:	8b 00                	mov    (%eax),%eax
  802950:	85 c0                	test   %eax,%eax
  802952:	0f 84 dc 00 00 00    	je     802a34 <alloc_block+0x3d8>
					// remove from the list and updat the pageInfoArr free blocks.
					// pop from the freeBlockList.
					struct BlockElement *blk = LIST_FIRST(&freeBlockLists[idx]);
  802958:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80295b:	c1 e0 04             	shl    $0x4,%eax
  80295e:	05 80 c0 81 00       	add    $0x81c080,%eax
  802963:	8b 00                	mov    (%eax),%eax
  802965:	89 45 d8             	mov    %eax,-0x28(%ebp)
				    LIST_REMOVE(&freeBlockLists[idx], blk);
  802968:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  80296c:	75 17                	jne    802985 <alloc_block+0x329>
  80296e:	83 ec 04             	sub    $0x4,%esp
  802971:	68 35 3a 80 00       	push   $0x803a35
  802976:	68 be 00 00 00       	push   $0xbe
  80297b:	68 77 39 80 00       	push   $0x803977
  802980:	e8 05 de ff ff       	call   80078a <_panic>
  802985:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802988:	8b 00                	mov    (%eax),%eax
  80298a:	85 c0                	test   %eax,%eax
  80298c:	74 10                	je     80299e <alloc_block+0x342>
  80298e:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802991:	8b 00                	mov    (%eax),%eax
  802993:	8b 55 d8             	mov    -0x28(%ebp),%edx
  802996:	8b 52 04             	mov    0x4(%edx),%edx
  802999:	89 50 04             	mov    %edx,0x4(%eax)
  80299c:	eb 14                	jmp    8029b2 <alloc_block+0x356>
  80299e:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8029a1:	8b 40 04             	mov    0x4(%eax),%eax
  8029a4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8029a7:	c1 e2 04             	shl    $0x4,%edx
  8029aa:	81 c2 84 c0 81 00    	add    $0x81c084,%edx
  8029b0:	89 02                	mov    %eax,(%edx)
  8029b2:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8029b5:	8b 40 04             	mov    0x4(%eax),%eax
  8029b8:	85 c0                	test   %eax,%eax
  8029ba:	74 0f                	je     8029cb <alloc_block+0x36f>
  8029bc:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8029bf:	8b 40 04             	mov    0x4(%eax),%eax
  8029c2:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8029c5:	8b 12                	mov    (%edx),%edx
  8029c7:	89 10                	mov    %edx,(%eax)
  8029c9:	eb 13                	jmp    8029de <alloc_block+0x382>
  8029cb:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8029ce:	8b 00                	mov    (%eax),%eax
  8029d0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8029d3:	c1 e2 04             	shl    $0x4,%edx
  8029d6:	81 c2 80 c0 81 00    	add    $0x81c080,%edx
  8029dc:	89 02                	mov    %eax,(%edx)
  8029de:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8029e1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8029e7:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8029ea:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8029f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029f4:	c1 e0 04             	shl    $0x4,%eax
  8029f7:	05 8c c0 81 00       	add    $0x81c08c,%eax
  8029fc:	8b 00                	mov    (%eax),%eax
  8029fe:	8d 50 ff             	lea    -0x1(%eax),%edx
  802a01:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a04:	c1 e0 04             	shl    $0x4,%eax
  802a07:	05 8c c0 81 00       	add    $0x81c08c,%eax
  802a0c:	89 10                	mov    %edx,(%eax)
				    // update pageBlockInfoArr
				    struct PageInfoElement *pageInfo = to_page_info((uint32)blk);
  802a0e:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802a11:	83 ec 0c             	sub    $0xc,%esp
  802a14:	50                   	push   %eax
  802a15:	e8 fe f8 ff ff       	call   802318 <to_page_info>
  802a1a:	83 c4 10             	add    $0x10,%esp
  802a1d:	89 45 d4             	mov    %eax,-0x2c(%ebp)
				    pageInfo->num_of_free_blocks--;
  802a20:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802a23:	66 8b 40 0a          	mov    0xa(%eax),%ax
  802a27:	48                   	dec    %eax
  802a28:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  802a2b:	66 89 42 0a          	mov    %ax,0xa(%edx)
				    return blk;
  802a2f:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802a32:	eb 32                	jmp    802a66 <alloc_block+0x40a>
		    struct PageInfoElement *pageInfo = to_page_info((uint32)blk);
		    pageInfo->num_of_free_blocks--;
		    return blk;
		}else{//case 3: no free block and no free page so iterate and try to find bigger size.
			// iterate over the list until finding available block
			while (idx <= (LOG2_MAX_SIZE - LOG2_MIN_SIZE) && freeBlockLists[idx].size == 0) {
  802a34:	83 7d f4 08          	cmpl   $0x8,-0xc(%ebp)
  802a38:	77 15                	ja     802a4f <alloc_block+0x3f3>
  802a3a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a3d:	c1 e0 04             	shl    $0x4,%eax
  802a40:	05 8c c0 81 00       	add    $0x81c08c,%eax
  802a45:	8b 00                	mov    (%eax),%eax
  802a47:	85 c0                	test   %eax,%eax
  802a49:	0f 84 f1 fe ff ff    	je     802940 <alloc_block+0x2e4>
				}
			}
		}
	}
	//case4: no free blocks or pages.
	panic("no free blocks!");
  802a4f:	83 ec 04             	sub    $0x4,%esp
  802a52:	68 53 3a 80 00       	push   $0x803a53
  802a57:	68 c8 00 00 00       	push   $0xc8
  802a5c:	68 77 39 80 00       	push   $0x803977
  802a61:	e8 24 dd ff ff       	call   80078a <_panic>
	//panic("alloc_block() Not implemented yet");
	//TODO: [PROJECT'25.BONUS#1] DYNAMIC ALLOCATOR - block if no free block
	return NULL;
}
  802a66:	c9                   	leave  
  802a67:	c3                   	ret    

00802a68 <free_block>:

//===========================
// [4] FREE BLOCK:
//===========================
void free_block(void *va)
{
  802a68:	55                   	push   %ebp
  802a69:	89 e5                	mov    %esp,%ebp
  802a6b:	83 ec 38             	sub    $0x38,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		assert((uint32)va >= dynAllocStart && (uint32)va < dynAllocEnd);
  802a6e:	8b 55 08             	mov    0x8(%ebp),%edx
  802a71:	a1 64 c0 81 00       	mov    0x81c064,%eax
  802a76:	39 c2                	cmp    %eax,%edx
  802a78:	72 0c                	jb     802a86 <free_block+0x1e>
  802a7a:	8b 55 08             	mov    0x8(%ebp),%edx
  802a7d:	a1 40 40 80 00       	mov    0x804040,%eax
  802a82:	39 c2                	cmp    %eax,%edx
  802a84:	72 19                	jb     802a9f <free_block+0x37>
  802a86:	68 64 3a 80 00       	push   $0x803a64
  802a8b:	68 da 39 80 00       	push   $0x8039da
  802a90:	68 d7 00 00 00       	push   $0xd7
  802a95:	68 77 39 80 00       	push   $0x803977
  802a9a:	e8 eb dc ff ff       	call   80078a <_panic>
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #4 free_block
	//Your code is here
	//Comment the following line
	// va of a piece in memory to free so:
	// 1. get its page, and make blk with this address to be put in the freeBlockList.
	struct BlockElement* blk_to_free = (struct BlockElement*)va;
  802a9f:	8b 45 08             	mov    0x8(%ebp),%eax
  802aa2:	89 45 e8             	mov    %eax,-0x18(%ebp)
	struct PageInfoElement *pageInfo = to_page_info((uint32)va);
  802aa5:	8b 45 08             	mov    0x8(%ebp),%eax
  802aa8:	83 ec 0c             	sub    $0xc,%esp
  802aab:	50                   	push   %eax
  802aac:	e8 67 f8 ff ff       	call   802318 <to_page_info>
  802ab1:	83 c4 10             	add    $0x10,%esp
  802ab4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	uint32 blk_size = pageInfo->block_size;
  802ab7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802aba:	8b 40 08             	mov    0x8(%eax),%eax
  802abd:	0f b7 c0             	movzwl %ax,%eax
  802ac0:	89 45 e0             	mov    %eax,-0x20(%ebp)

	// its index in the freeBlocklist.
	int idx = 0;
  802ac3:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int i = LOG2_MIN_SIZE; i <= LOG2_MAX_SIZE; i++) {
  802aca:	c7 45 f0 03 00 00 00 	movl   $0x3,-0x10(%ebp)
  802ad1:	eb 19                	jmp    802aec <free_block+0x84>
	    if ((1 << i) == blk_size)
  802ad3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ad6:	ba 01 00 00 00       	mov    $0x1,%edx
  802adb:	88 c1                	mov    %al,%cl
  802add:	d3 e2                	shl    %cl,%edx
  802adf:	89 d0                	mov    %edx,%eax
  802ae1:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  802ae4:	74 0e                	je     802af4 <free_block+0x8c>
	        break;
	    idx++;
  802ae6:	ff 45 f4             	incl   -0xc(%ebp)
	struct PageInfoElement *pageInfo = to_page_info((uint32)va);
	uint32 blk_size = pageInfo->block_size;

	// its index in the freeBlocklist.
	int idx = 0;
	for (int i = LOG2_MIN_SIZE; i <= LOG2_MAX_SIZE; i++) {
  802ae9:	ff 45 f0             	incl   -0x10(%ebp)
  802aec:	83 7d f0 0b          	cmpl   $0xb,-0x10(%ebp)
  802af0:	7e e1                	jle    802ad3 <free_block+0x6b>
  802af2:	eb 01                	jmp    802af5 <free_block+0x8d>
	    if ((1 << i) == blk_size)
	        break;
  802af4:	90                   	nop
	    idx++;
	}

	pageInfo->num_of_free_blocks++;
  802af5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802af8:	66 8b 40 0a          	mov    0xa(%eax),%ax
  802afc:	40                   	inc    %eax
  802afd:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802b00:	66 89 42 0a          	mov    %ax,0xa(%edx)
	LIST_INSERT_TAIL(&freeBlockLists[idx], blk_to_free);
  802b04:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802b08:	75 17                	jne    802b21 <free_block+0xb9>
  802b0a:	83 ec 04             	sub    $0x4,%esp
  802b0d:	68 f0 39 80 00       	push   $0x8039f0
  802b12:	68 ee 00 00 00       	push   $0xee
  802b17:	68 77 39 80 00       	push   $0x803977
  802b1c:	e8 69 dc ff ff       	call   80078a <_panic>
  802b21:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b24:	c1 e0 04             	shl    $0x4,%eax
  802b27:	05 84 c0 81 00       	add    $0x81c084,%eax
  802b2c:	8b 10                	mov    (%eax),%edx
  802b2e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802b31:	89 50 04             	mov    %edx,0x4(%eax)
  802b34:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802b37:	8b 40 04             	mov    0x4(%eax),%eax
  802b3a:	85 c0                	test   %eax,%eax
  802b3c:	74 14                	je     802b52 <free_block+0xea>
  802b3e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b41:	c1 e0 04             	shl    $0x4,%eax
  802b44:	05 84 c0 81 00       	add    $0x81c084,%eax
  802b49:	8b 00                	mov    (%eax),%eax
  802b4b:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802b4e:	89 10                	mov    %edx,(%eax)
  802b50:	eb 11                	jmp    802b63 <free_block+0xfb>
  802b52:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b55:	c1 e0 04             	shl    $0x4,%eax
  802b58:	8d 90 80 c0 81 00    	lea    0x81c080(%eax),%edx
  802b5e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802b61:	89 02                	mov    %eax,(%edx)
  802b63:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b66:	c1 e0 04             	shl    $0x4,%eax
  802b69:	8d 90 84 c0 81 00    	lea    0x81c084(%eax),%edx
  802b6f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802b72:	89 02                	mov    %eax,(%edx)
  802b74:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802b77:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802b7d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b80:	c1 e0 04             	shl    $0x4,%eax
  802b83:	05 8c c0 81 00       	add    $0x81c08c,%eax
  802b88:	8b 00                	mov    (%eax),%eax
  802b8a:	8d 50 01             	lea    0x1(%eax),%edx
  802b8d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b90:	c1 e0 04             	shl    $0x4,%eax
  802b93:	05 8c c0 81 00       	add    $0x81c08c,%eax
  802b98:	89 10                	mov    %edx,(%eax)

	// now, case 1: the page all blocks are freed so you free the page.
	int blk_count = PAGE_SIZE / blk_size;
  802b9a:	b8 00 10 00 00       	mov    $0x1000,%eax
  802b9f:	ba 00 00 00 00       	mov    $0x0,%edx
  802ba4:	f7 75 e0             	divl   -0x20(%ebp)
  802ba7:	89 45 dc             	mov    %eax,-0x24(%ebp)
	// the blk count in the page is same as number fo free blocks free up the page.
	if (pageInfo->num_of_free_blocks == blk_count) {
  802baa:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802bad:	66 8b 40 0a          	mov    0xa(%eax),%ax
  802bb1:	0f b7 c0             	movzwl %ax,%eax
  802bb4:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  802bb7:	0f 85 70 01 00 00    	jne    802d2d <free_block+0x2c5>
		uint32 page_va = to_page_va(pageInfo);
  802bbd:	83 ec 0c             	sub    $0xc,%esp
  802bc0:	ff 75 e4             	pushl  -0x1c(%ebp)
  802bc3:	e8 de f6 ff ff       	call   8022a6 <to_page_va>
  802bc8:	83 c4 10             	add    $0x10,%esp
  802bcb:	89 45 d8             	mov    %eax,-0x28(%ebp)
		// remove all blk in the freeBlockList.
		for (uint32 off = 0; off < PAGE_SIZE; off += blk_size) {
  802bce:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  802bd5:	e9 b7 00 00 00       	jmp    802c91 <free_block+0x229>
			struct BlockElement *blk = (struct BlockElement*)(page_va + off);
  802bda:	8b 55 d8             	mov    -0x28(%ebp),%edx
  802bdd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802be0:	01 d0                	add    %edx,%eax
  802be2:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			LIST_REMOVE(&freeBlockLists[idx], blk);
  802be5:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  802be9:	75 17                	jne    802c02 <free_block+0x19a>
  802beb:	83 ec 04             	sub    $0x4,%esp
  802bee:	68 35 3a 80 00       	push   $0x803a35
  802bf3:	68 f8 00 00 00       	push   $0xf8
  802bf8:	68 77 39 80 00       	push   $0x803977
  802bfd:	e8 88 db ff ff       	call   80078a <_panic>
  802c02:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802c05:	8b 00                	mov    (%eax),%eax
  802c07:	85 c0                	test   %eax,%eax
  802c09:	74 10                	je     802c1b <free_block+0x1b3>
  802c0b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802c0e:	8b 00                	mov    (%eax),%eax
  802c10:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  802c13:	8b 52 04             	mov    0x4(%edx),%edx
  802c16:	89 50 04             	mov    %edx,0x4(%eax)
  802c19:	eb 14                	jmp    802c2f <free_block+0x1c7>
  802c1b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802c1e:	8b 40 04             	mov    0x4(%eax),%eax
  802c21:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802c24:	c1 e2 04             	shl    $0x4,%edx
  802c27:	81 c2 84 c0 81 00    	add    $0x81c084,%edx
  802c2d:	89 02                	mov    %eax,(%edx)
  802c2f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802c32:	8b 40 04             	mov    0x4(%eax),%eax
  802c35:	85 c0                	test   %eax,%eax
  802c37:	74 0f                	je     802c48 <free_block+0x1e0>
  802c39:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802c3c:	8b 40 04             	mov    0x4(%eax),%eax
  802c3f:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  802c42:	8b 12                	mov    (%edx),%edx
  802c44:	89 10                	mov    %edx,(%eax)
  802c46:	eb 13                	jmp    802c5b <free_block+0x1f3>
  802c48:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802c4b:	8b 00                	mov    (%eax),%eax
  802c4d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802c50:	c1 e2 04             	shl    $0x4,%edx
  802c53:	81 c2 80 c0 81 00    	add    $0x81c080,%edx
  802c59:	89 02                	mov    %eax,(%edx)
  802c5b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802c5e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802c64:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802c67:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802c6e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c71:	c1 e0 04             	shl    $0x4,%eax
  802c74:	05 8c c0 81 00       	add    $0x81c08c,%eax
  802c79:	8b 00                	mov    (%eax),%eax
  802c7b:	8d 50 ff             	lea    -0x1(%eax),%edx
  802c7e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c81:	c1 e0 04             	shl    $0x4,%eax
  802c84:	05 8c c0 81 00       	add    $0x81c08c,%eax
  802c89:	89 10                	mov    %edx,(%eax)
	int blk_count = PAGE_SIZE / blk_size;
	// the blk count in the page is same as number fo free blocks free up the page.
	if (pageInfo->num_of_free_blocks == blk_count) {
		uint32 page_va = to_page_va(pageInfo);
		// remove all blk in the freeBlockList.
		for (uint32 off = 0; off < PAGE_SIZE; off += blk_size) {
  802c8b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802c8e:	01 45 ec             	add    %eax,-0x14(%ebp)
  802c91:	81 7d ec ff 0f 00 00 	cmpl   $0xfff,-0x14(%ebp)
  802c98:	0f 86 3c ff ff ff    	jbe    802bda <free_block+0x172>
			struct BlockElement *blk = (struct BlockElement*)(page_va + off);
			LIST_REMOVE(&freeBlockLists[idx], blk);
		}
		// reset page info.
		pageInfo->block_size = 0;
  802c9e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802ca1:	66 c7 40 08 00 00    	movw   $0x0,0x8(%eax)
		pageInfo->num_of_free_blocks = 0;
  802ca7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802caa:	66 c7 40 0a 00 00    	movw   $0x0,0xa(%eax)
		// add it to the available pages.
		LIST_INSERT_TAIL(&freePagesList, pageInfo);
  802cb0:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  802cb4:	75 17                	jne    802ccd <free_block+0x265>
  802cb6:	83 ec 04             	sub    $0x4,%esp
  802cb9:	68 f0 39 80 00       	push   $0x8039f0
  802cbe:	68 fe 00 00 00       	push   $0xfe
  802cc3:	68 77 39 80 00       	push   $0x803977
  802cc8:	e8 bd da ff ff       	call   80078a <_panic>
  802ccd:	8b 15 4c 40 80 00    	mov    0x80404c,%edx
  802cd3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802cd6:	89 50 04             	mov    %edx,0x4(%eax)
  802cd9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802cdc:	8b 40 04             	mov    0x4(%eax),%eax
  802cdf:	85 c0                	test   %eax,%eax
  802ce1:	74 0c                	je     802cef <free_block+0x287>
  802ce3:	a1 4c 40 80 00       	mov    0x80404c,%eax
  802ce8:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802ceb:	89 10                	mov    %edx,(%eax)
  802ced:	eb 08                	jmp    802cf7 <free_block+0x28f>
  802cef:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802cf2:	a3 48 40 80 00       	mov    %eax,0x804048
  802cf7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802cfa:	a3 4c 40 80 00       	mov    %eax,0x80404c
  802cff:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802d02:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802d08:	a1 54 40 80 00       	mov    0x804054,%eax
  802d0d:	40                   	inc    %eax
  802d0e:	a3 54 40 80 00       	mov    %eax,0x804054
		// make it available in memory.
		return_page((uint32 *)to_page_va(pageInfo));
  802d13:	83 ec 0c             	sub    $0xc,%esp
  802d16:	ff 75 e4             	pushl  -0x1c(%ebp)
  802d19:	e8 88 f5 ff ff       	call   8022a6 <to_page_va>
  802d1e:	83 c4 10             	add    $0x10,%esp
  802d21:	83 ec 0c             	sub    $0xc,%esp
  802d24:	50                   	push   %eax
  802d25:	e8 b8 ee ff ff       	call   801be2 <return_page>
  802d2a:	83 c4 10             	add    $0x10,%esp
	}
	//panic("free_block() Not implemented yet");
}
  802d2d:	90                   	nop
  802d2e:	c9                   	leave  
  802d2f:	c3                   	ret    

00802d30 <realloc_block>:

//===========================
// [1] REALLOCATE BLOCK:
//===========================
void *realloc_block(void* va, uint32 new_size)
{
  802d30:	55                   	push   %ebp
  802d31:	89 e5                	mov    %esp,%ebp
  802d33:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.BONUS#2] KERNEL REALLOC - realloc_block
	//Your code is here
	//Comment the following line
	panic("realloc_block() Not implemented yet");
  802d36:	83 ec 04             	sub    $0x4,%esp
  802d39:	68 9c 3a 80 00       	push   $0x803a9c
  802d3e:	68 11 01 00 00       	push   $0x111
  802d43:	68 77 39 80 00       	push   $0x803977
  802d48:	e8 3d da ff ff       	call   80078a <_panic>
  802d4d:	66 90                	xchg   %ax,%ax
  802d4f:	90                   	nop

00802d50 <__udivdi3>:
  802d50:	55                   	push   %ebp
  802d51:	57                   	push   %edi
  802d52:	56                   	push   %esi
  802d53:	53                   	push   %ebx
  802d54:	83 ec 1c             	sub    $0x1c,%esp
  802d57:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  802d5b:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  802d5f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  802d63:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802d67:	89 ca                	mov    %ecx,%edx
  802d69:	89 f8                	mov    %edi,%eax
  802d6b:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  802d6f:	85 f6                	test   %esi,%esi
  802d71:	75 2d                	jne    802da0 <__udivdi3+0x50>
  802d73:	39 cf                	cmp    %ecx,%edi
  802d75:	77 65                	ja     802ddc <__udivdi3+0x8c>
  802d77:	89 fd                	mov    %edi,%ebp
  802d79:	85 ff                	test   %edi,%edi
  802d7b:	75 0b                	jne    802d88 <__udivdi3+0x38>
  802d7d:	b8 01 00 00 00       	mov    $0x1,%eax
  802d82:	31 d2                	xor    %edx,%edx
  802d84:	f7 f7                	div    %edi
  802d86:	89 c5                	mov    %eax,%ebp
  802d88:	31 d2                	xor    %edx,%edx
  802d8a:	89 c8                	mov    %ecx,%eax
  802d8c:	f7 f5                	div    %ebp
  802d8e:	89 c1                	mov    %eax,%ecx
  802d90:	89 d8                	mov    %ebx,%eax
  802d92:	f7 f5                	div    %ebp
  802d94:	89 cf                	mov    %ecx,%edi
  802d96:	89 fa                	mov    %edi,%edx
  802d98:	83 c4 1c             	add    $0x1c,%esp
  802d9b:	5b                   	pop    %ebx
  802d9c:	5e                   	pop    %esi
  802d9d:	5f                   	pop    %edi
  802d9e:	5d                   	pop    %ebp
  802d9f:	c3                   	ret    
  802da0:	39 ce                	cmp    %ecx,%esi
  802da2:	77 28                	ja     802dcc <__udivdi3+0x7c>
  802da4:	0f bd fe             	bsr    %esi,%edi
  802da7:	83 f7 1f             	xor    $0x1f,%edi
  802daa:	75 40                	jne    802dec <__udivdi3+0x9c>
  802dac:	39 ce                	cmp    %ecx,%esi
  802dae:	72 0a                	jb     802dba <__udivdi3+0x6a>
  802db0:	3b 44 24 08          	cmp    0x8(%esp),%eax
  802db4:	0f 87 9e 00 00 00    	ja     802e58 <__udivdi3+0x108>
  802dba:	b8 01 00 00 00       	mov    $0x1,%eax
  802dbf:	89 fa                	mov    %edi,%edx
  802dc1:	83 c4 1c             	add    $0x1c,%esp
  802dc4:	5b                   	pop    %ebx
  802dc5:	5e                   	pop    %esi
  802dc6:	5f                   	pop    %edi
  802dc7:	5d                   	pop    %ebp
  802dc8:	c3                   	ret    
  802dc9:	8d 76 00             	lea    0x0(%esi),%esi
  802dcc:	31 ff                	xor    %edi,%edi
  802dce:	31 c0                	xor    %eax,%eax
  802dd0:	89 fa                	mov    %edi,%edx
  802dd2:	83 c4 1c             	add    $0x1c,%esp
  802dd5:	5b                   	pop    %ebx
  802dd6:	5e                   	pop    %esi
  802dd7:	5f                   	pop    %edi
  802dd8:	5d                   	pop    %ebp
  802dd9:	c3                   	ret    
  802dda:	66 90                	xchg   %ax,%ax
  802ddc:	89 d8                	mov    %ebx,%eax
  802dde:	f7 f7                	div    %edi
  802de0:	31 ff                	xor    %edi,%edi
  802de2:	89 fa                	mov    %edi,%edx
  802de4:	83 c4 1c             	add    $0x1c,%esp
  802de7:	5b                   	pop    %ebx
  802de8:	5e                   	pop    %esi
  802de9:	5f                   	pop    %edi
  802dea:	5d                   	pop    %ebp
  802deb:	c3                   	ret    
  802dec:	bd 20 00 00 00       	mov    $0x20,%ebp
  802df1:	89 eb                	mov    %ebp,%ebx
  802df3:	29 fb                	sub    %edi,%ebx
  802df5:	89 f9                	mov    %edi,%ecx
  802df7:	d3 e6                	shl    %cl,%esi
  802df9:	89 c5                	mov    %eax,%ebp
  802dfb:	88 d9                	mov    %bl,%cl
  802dfd:	d3 ed                	shr    %cl,%ebp
  802dff:	89 e9                	mov    %ebp,%ecx
  802e01:	09 f1                	or     %esi,%ecx
  802e03:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  802e07:	89 f9                	mov    %edi,%ecx
  802e09:	d3 e0                	shl    %cl,%eax
  802e0b:	89 c5                	mov    %eax,%ebp
  802e0d:	89 d6                	mov    %edx,%esi
  802e0f:	88 d9                	mov    %bl,%cl
  802e11:	d3 ee                	shr    %cl,%esi
  802e13:	89 f9                	mov    %edi,%ecx
  802e15:	d3 e2                	shl    %cl,%edx
  802e17:	8b 44 24 08          	mov    0x8(%esp),%eax
  802e1b:	88 d9                	mov    %bl,%cl
  802e1d:	d3 e8                	shr    %cl,%eax
  802e1f:	09 c2                	or     %eax,%edx
  802e21:	89 d0                	mov    %edx,%eax
  802e23:	89 f2                	mov    %esi,%edx
  802e25:	f7 74 24 0c          	divl   0xc(%esp)
  802e29:	89 d6                	mov    %edx,%esi
  802e2b:	89 c3                	mov    %eax,%ebx
  802e2d:	f7 e5                	mul    %ebp
  802e2f:	39 d6                	cmp    %edx,%esi
  802e31:	72 19                	jb     802e4c <__udivdi3+0xfc>
  802e33:	74 0b                	je     802e40 <__udivdi3+0xf0>
  802e35:	89 d8                	mov    %ebx,%eax
  802e37:	31 ff                	xor    %edi,%edi
  802e39:	e9 58 ff ff ff       	jmp    802d96 <__udivdi3+0x46>
  802e3e:	66 90                	xchg   %ax,%ax
  802e40:	8b 54 24 08          	mov    0x8(%esp),%edx
  802e44:	89 f9                	mov    %edi,%ecx
  802e46:	d3 e2                	shl    %cl,%edx
  802e48:	39 c2                	cmp    %eax,%edx
  802e4a:	73 e9                	jae    802e35 <__udivdi3+0xe5>
  802e4c:	8d 43 ff             	lea    -0x1(%ebx),%eax
  802e4f:	31 ff                	xor    %edi,%edi
  802e51:	e9 40 ff ff ff       	jmp    802d96 <__udivdi3+0x46>
  802e56:	66 90                	xchg   %ax,%ax
  802e58:	31 c0                	xor    %eax,%eax
  802e5a:	e9 37 ff ff ff       	jmp    802d96 <__udivdi3+0x46>
  802e5f:	90                   	nop

00802e60 <__umoddi3>:
  802e60:	55                   	push   %ebp
  802e61:	57                   	push   %edi
  802e62:	56                   	push   %esi
  802e63:	53                   	push   %ebx
  802e64:	83 ec 1c             	sub    $0x1c,%esp
  802e67:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  802e6b:	8b 74 24 34          	mov    0x34(%esp),%esi
  802e6f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  802e73:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  802e77:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802e7b:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802e7f:	89 f3                	mov    %esi,%ebx
  802e81:	89 fa                	mov    %edi,%edx
  802e83:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  802e87:	89 34 24             	mov    %esi,(%esp)
  802e8a:	85 c0                	test   %eax,%eax
  802e8c:	75 1a                	jne    802ea8 <__umoddi3+0x48>
  802e8e:	39 f7                	cmp    %esi,%edi
  802e90:	0f 86 a2 00 00 00    	jbe    802f38 <__umoddi3+0xd8>
  802e96:	89 c8                	mov    %ecx,%eax
  802e98:	89 f2                	mov    %esi,%edx
  802e9a:	f7 f7                	div    %edi
  802e9c:	89 d0                	mov    %edx,%eax
  802e9e:	31 d2                	xor    %edx,%edx
  802ea0:	83 c4 1c             	add    $0x1c,%esp
  802ea3:	5b                   	pop    %ebx
  802ea4:	5e                   	pop    %esi
  802ea5:	5f                   	pop    %edi
  802ea6:	5d                   	pop    %ebp
  802ea7:	c3                   	ret    
  802ea8:	39 f0                	cmp    %esi,%eax
  802eaa:	0f 87 ac 00 00 00    	ja     802f5c <__umoddi3+0xfc>
  802eb0:	0f bd e8             	bsr    %eax,%ebp
  802eb3:	83 f5 1f             	xor    $0x1f,%ebp
  802eb6:	0f 84 ac 00 00 00    	je     802f68 <__umoddi3+0x108>
  802ebc:	bf 20 00 00 00       	mov    $0x20,%edi
  802ec1:	29 ef                	sub    %ebp,%edi
  802ec3:	89 fe                	mov    %edi,%esi
  802ec5:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802ec9:	89 e9                	mov    %ebp,%ecx
  802ecb:	d3 e0                	shl    %cl,%eax
  802ecd:	89 d7                	mov    %edx,%edi
  802ecf:	89 f1                	mov    %esi,%ecx
  802ed1:	d3 ef                	shr    %cl,%edi
  802ed3:	09 c7                	or     %eax,%edi
  802ed5:	89 e9                	mov    %ebp,%ecx
  802ed7:	d3 e2                	shl    %cl,%edx
  802ed9:	89 14 24             	mov    %edx,(%esp)
  802edc:	89 d8                	mov    %ebx,%eax
  802ede:	d3 e0                	shl    %cl,%eax
  802ee0:	89 c2                	mov    %eax,%edx
  802ee2:	8b 44 24 08          	mov    0x8(%esp),%eax
  802ee6:	d3 e0                	shl    %cl,%eax
  802ee8:	89 44 24 04          	mov    %eax,0x4(%esp)
  802eec:	8b 44 24 08          	mov    0x8(%esp),%eax
  802ef0:	89 f1                	mov    %esi,%ecx
  802ef2:	d3 e8                	shr    %cl,%eax
  802ef4:	09 d0                	or     %edx,%eax
  802ef6:	d3 eb                	shr    %cl,%ebx
  802ef8:	89 da                	mov    %ebx,%edx
  802efa:	f7 f7                	div    %edi
  802efc:	89 d3                	mov    %edx,%ebx
  802efe:	f7 24 24             	mull   (%esp)
  802f01:	89 c6                	mov    %eax,%esi
  802f03:	89 d1                	mov    %edx,%ecx
  802f05:	39 d3                	cmp    %edx,%ebx
  802f07:	0f 82 87 00 00 00    	jb     802f94 <__umoddi3+0x134>
  802f0d:	0f 84 91 00 00 00    	je     802fa4 <__umoddi3+0x144>
  802f13:	8b 54 24 04          	mov    0x4(%esp),%edx
  802f17:	29 f2                	sub    %esi,%edx
  802f19:	19 cb                	sbb    %ecx,%ebx
  802f1b:	89 d8                	mov    %ebx,%eax
  802f1d:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  802f21:	d3 e0                	shl    %cl,%eax
  802f23:	89 e9                	mov    %ebp,%ecx
  802f25:	d3 ea                	shr    %cl,%edx
  802f27:	09 d0                	or     %edx,%eax
  802f29:	89 e9                	mov    %ebp,%ecx
  802f2b:	d3 eb                	shr    %cl,%ebx
  802f2d:	89 da                	mov    %ebx,%edx
  802f2f:	83 c4 1c             	add    $0x1c,%esp
  802f32:	5b                   	pop    %ebx
  802f33:	5e                   	pop    %esi
  802f34:	5f                   	pop    %edi
  802f35:	5d                   	pop    %ebp
  802f36:	c3                   	ret    
  802f37:	90                   	nop
  802f38:	89 fd                	mov    %edi,%ebp
  802f3a:	85 ff                	test   %edi,%edi
  802f3c:	75 0b                	jne    802f49 <__umoddi3+0xe9>
  802f3e:	b8 01 00 00 00       	mov    $0x1,%eax
  802f43:	31 d2                	xor    %edx,%edx
  802f45:	f7 f7                	div    %edi
  802f47:	89 c5                	mov    %eax,%ebp
  802f49:	89 f0                	mov    %esi,%eax
  802f4b:	31 d2                	xor    %edx,%edx
  802f4d:	f7 f5                	div    %ebp
  802f4f:	89 c8                	mov    %ecx,%eax
  802f51:	f7 f5                	div    %ebp
  802f53:	89 d0                	mov    %edx,%eax
  802f55:	e9 44 ff ff ff       	jmp    802e9e <__umoddi3+0x3e>
  802f5a:	66 90                	xchg   %ax,%ax
  802f5c:	89 c8                	mov    %ecx,%eax
  802f5e:	89 f2                	mov    %esi,%edx
  802f60:	83 c4 1c             	add    $0x1c,%esp
  802f63:	5b                   	pop    %ebx
  802f64:	5e                   	pop    %esi
  802f65:	5f                   	pop    %edi
  802f66:	5d                   	pop    %ebp
  802f67:	c3                   	ret    
  802f68:	3b 04 24             	cmp    (%esp),%eax
  802f6b:	72 06                	jb     802f73 <__umoddi3+0x113>
  802f6d:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  802f71:	77 0f                	ja     802f82 <__umoddi3+0x122>
  802f73:	89 f2                	mov    %esi,%edx
  802f75:	29 f9                	sub    %edi,%ecx
  802f77:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  802f7b:	89 14 24             	mov    %edx,(%esp)
  802f7e:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  802f82:	8b 44 24 04          	mov    0x4(%esp),%eax
  802f86:	8b 14 24             	mov    (%esp),%edx
  802f89:	83 c4 1c             	add    $0x1c,%esp
  802f8c:	5b                   	pop    %ebx
  802f8d:	5e                   	pop    %esi
  802f8e:	5f                   	pop    %edi
  802f8f:	5d                   	pop    %ebp
  802f90:	c3                   	ret    
  802f91:	8d 76 00             	lea    0x0(%esi),%esi
  802f94:	2b 04 24             	sub    (%esp),%eax
  802f97:	19 fa                	sbb    %edi,%edx
  802f99:	89 d1                	mov    %edx,%ecx
  802f9b:	89 c6                	mov    %eax,%esi
  802f9d:	e9 71 ff ff ff       	jmp    802f13 <__umoddi3+0xb3>
  802fa2:	66 90                	xchg   %ax,%ax
  802fa4:	39 44 24 04          	cmp    %eax,0x4(%esp)
  802fa8:	72 ea                	jb     802f94 <__umoddi3+0x134>
  802faa:	89 d9                	mov    %ebx,%ecx
  802fac:	e9 62 ff ff ff       	jmp    802f13 <__umoddi3+0xb3>
