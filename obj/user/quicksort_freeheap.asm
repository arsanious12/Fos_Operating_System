
obj/user/quicksort_freeheap:     file format elf32-i386


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
  800031:	e8 5d 05 00 00       	call   800593 <libmain>
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
  800049:	e8 9b 1d 00 00       	call   801de9 <sys_calculate_free_frames>
  80004e:	89 c3                	mov    %eax,%ebx
  800050:	e8 ad 1d 00 00       	call   801e02 <sys_calculate_modified_frames>
  800055:	01 d8                	add    %ebx,%eax
  800057:	89 45 f0             	mov    %eax,-0x10(%ebp)

		Iteration++ ;
  80005a:	ff 45 f4             	incl   -0xc(%ebp)
		//		cprintf("Free Frames Before Allocation = %d\n", sys_calculate_free_frames()) ;

		//	sys_lock_cons();

		readline("Enter the number of elements: ", Line);
  80005d:	83 ec 08             	sub    $0x8,%esp
  800060:	8d 85 e1 fe ff ff    	lea    -0x11f(%ebp),%eax
  800066:	50                   	push   %eax
  800067:	68 80 2f 80 00       	push   $0x802f80
  80006c:	e8 8e 10 00 00       	call   8010ff <readline>
  800071:	83 c4 10             	add    $0x10,%esp
		int NumOfElements = strtol(Line, NULL, 10) ;
  800074:	83 ec 04             	sub    $0x4,%esp
  800077:	6a 0a                	push   $0xa
  800079:	6a 00                	push   $0x0
  80007b:	8d 85 e1 fe ff ff    	lea    -0x11f(%ebp),%eax
  800081:	50                   	push   %eax
  800082:	e8 8f 16 00 00       	call   801716 <strtol>
  800087:	83 c4 10             	add    $0x10,%esp
  80008a:	89 45 ec             	mov    %eax,-0x14(%ebp)
		int *Elements = malloc(sizeof(int) * NumOfElements) ;
  80008d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800090:	c1 e0 02             	shl    $0x2,%eax
  800093:	83 ec 0c             	sub    $0xc,%esp
  800096:	50                   	push   %eax
  800097:	e8 54 1b 00 00       	call   801bf0 <malloc>
  80009c:	83 c4 10             	add    $0x10,%esp
  80009f:	89 45 e8             	mov    %eax,-0x18(%ebp)
		cprintf("Choose the initialization method:\n") ;
  8000a2:	83 ec 0c             	sub    $0xc,%esp
  8000a5:	68 a0 2f 80 00       	push   $0x802fa0
  8000aa:	e8 77 09 00 00       	call   800a26 <cprintf>
  8000af:	83 c4 10             	add    $0x10,%esp
		cprintf("a) Ascending\n") ;
  8000b2:	83 ec 0c             	sub    $0xc,%esp
  8000b5:	68 c3 2f 80 00       	push   $0x802fc3
  8000ba:	e8 67 09 00 00       	call   800a26 <cprintf>
  8000bf:	83 c4 10             	add    $0x10,%esp
		cprintf("b) Descending\n") ;
  8000c2:	83 ec 0c             	sub    $0xc,%esp
  8000c5:	68 d1 2f 80 00       	push   $0x802fd1
  8000ca:	e8 57 09 00 00       	call   800a26 <cprintf>
  8000cf:	83 c4 10             	add    $0x10,%esp
		cprintf("c) Semi random\n");
  8000d2:	83 ec 0c             	sub    $0xc,%esp
  8000d5:	68 e0 2f 80 00       	push   $0x802fe0
  8000da:	e8 47 09 00 00       	call   800a26 <cprintf>
  8000df:	83 c4 10             	add    $0x10,%esp
		do
		{
			cprintf("Select: ") ;
  8000e2:	83 ec 0c             	sub    $0xc,%esp
  8000e5:	68 f0 2f 80 00       	push   $0x802ff0
  8000ea:	e8 37 09 00 00       	call   800a26 <cprintf>
  8000ef:	83 c4 10             	add    $0x10,%esp
			Chose = getchar() ;
  8000f2:	e8 7f 04 00 00       	call   800576 <getchar>
  8000f7:	88 45 e7             	mov    %al,-0x19(%ebp)
			cputchar(Chose);
  8000fa:	0f be 45 e7          	movsbl -0x19(%ebp),%eax
  8000fe:	83 ec 0c             	sub    $0xc,%esp
  800101:	50                   	push   %eax
  800102:	e8 50 04 00 00       	call   800557 <cputchar>
  800107:	83 c4 10             	add    $0x10,%esp
			cputchar('\n');
  80010a:	83 ec 0c             	sub    $0xc,%esp
  80010d:	6a 0a                	push   $0xa
  80010f:	e8 43 04 00 00       	call   800557 <cputchar>
  800114:	83 c4 10             	add    $0x10,%esp
		} while (Chose != 'a' && Chose != 'b' && Chose != 'c');
  800117:	80 7d e7 61          	cmpb   $0x61,-0x19(%ebp)
  80011b:	74 0c                	je     800129 <_main+0xf1>
  80011d:	80 7d e7 62          	cmpb   $0x62,-0x19(%ebp)
  800121:	74 06                	je     800129 <_main+0xf1>
  800123:	80 7d e7 63          	cmpb   $0x63,-0x19(%ebp)
  800127:	75 b9                	jne    8000e2 <_main+0xaa>
		//sys_unlock_cons();
		int  i ;
		switch (Chose)
  800129:	0f be 45 e7          	movsbl -0x19(%ebp),%eax
  80012d:	83 f8 62             	cmp    $0x62,%eax
  800130:	74 1d                	je     80014f <_main+0x117>
  800132:	83 f8 63             	cmp    $0x63,%eax
  800135:	74 2b                	je     800162 <_main+0x12a>
  800137:	83 f8 61             	cmp    $0x61,%eax
  80013a:	75 39                	jne    800175 <_main+0x13d>
		{
		case 'a':
			InitializeAscending(Elements, NumOfElements);
  80013c:	83 ec 08             	sub    $0x8,%esp
  80013f:	ff 75 ec             	pushl  -0x14(%ebp)
  800142:	ff 75 e8             	pushl  -0x18(%ebp)
  800145:	e8 c8 02 00 00       	call   800412 <InitializeAscending>
  80014a:	83 c4 10             	add    $0x10,%esp
			break ;
  80014d:	eb 37                	jmp    800186 <_main+0x14e>
		case 'b':
			InitializeIdentical(Elements, NumOfElements);
  80014f:	83 ec 08             	sub    $0x8,%esp
  800152:	ff 75 ec             	pushl  -0x14(%ebp)
  800155:	ff 75 e8             	pushl  -0x18(%ebp)
  800158:	e8 e6 02 00 00       	call   800443 <InitializeIdentical>
  80015d:	83 c4 10             	add    $0x10,%esp
			break ;
  800160:	eb 24                	jmp    800186 <_main+0x14e>
		case 'c':
			InitializeSemiRandom(Elements, NumOfElements);
  800162:	83 ec 08             	sub    $0x8,%esp
  800165:	ff 75 ec             	pushl  -0x14(%ebp)
  800168:	ff 75 e8             	pushl  -0x18(%ebp)
  80016b:	e8 08 03 00 00       	call   800478 <InitializeSemiRandom>
  800170:	83 c4 10             	add    $0x10,%esp
			break ;
  800173:	eb 11                	jmp    800186 <_main+0x14e>
		default:
			InitializeSemiRandom(Elements, NumOfElements);
  800175:	83 ec 08             	sub    $0x8,%esp
  800178:	ff 75 ec             	pushl  -0x14(%ebp)
  80017b:	ff 75 e8             	pushl  -0x18(%ebp)
  80017e:	e8 f5 02 00 00       	call   800478 <InitializeSemiRandom>
  800183:	83 c4 10             	add    $0x10,%esp
		}

		QuickSort(Elements, NumOfElements);
  800186:	83 ec 08             	sub    $0x8,%esp
  800189:	ff 75 ec             	pushl  -0x14(%ebp)
  80018c:	ff 75 e8             	pushl  -0x18(%ebp)
  80018f:	e8 c3 00 00 00       	call   800257 <QuickSort>
  800194:	83 c4 10             	add    $0x10,%esp

		//		PrintElements(Elements, NumOfElements);

		uint32 Sorted = CheckSorted(Elements, NumOfElements);
  800197:	83 ec 08             	sub    $0x8,%esp
  80019a:	ff 75 ec             	pushl  -0x14(%ebp)
  80019d:	ff 75 e8             	pushl  -0x18(%ebp)
  8001a0:	e8 c3 01 00 00       	call   800368 <CheckSorted>
  8001a5:	83 c4 10             	add    $0x10,%esp
  8001a8:	89 45 e0             	mov    %eax,-0x20(%ebp)

		if(Sorted == 0) panic("The array is NOT sorted correctly") ;
  8001ab:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8001af:	75 14                	jne    8001c5 <_main+0x18d>
  8001b1:	83 ec 04             	sub    $0x4,%esp
  8001b4:	68 fc 2f 80 00       	push   $0x802ffc
  8001b9:	6a 45                	push   $0x45
  8001bb:	68 1e 30 80 00       	push   $0x80301e
  8001c0:	e8 93 05 00 00       	call   800758 <_panic>
		else
		{
			cprintf("===============================================\n") ;
  8001c5:	83 ec 0c             	sub    $0xc,%esp
  8001c8:	68 38 30 80 00       	push   $0x803038
  8001cd:	e8 54 08 00 00       	call   800a26 <cprintf>
  8001d2:	83 c4 10             	add    $0x10,%esp
			cprintf("Congratulations!! The array is sorted correctly\n") ;
  8001d5:	83 ec 0c             	sub    $0xc,%esp
  8001d8:	68 6c 30 80 00       	push   $0x80306c
  8001dd:	e8 44 08 00 00       	call   800a26 <cprintf>
  8001e2:	83 c4 10             	add    $0x10,%esp
			cprintf("===============================================\n\n") ;
  8001e5:	83 ec 0c             	sub    $0xc,%esp
  8001e8:	68 a0 30 80 00       	push   $0x8030a0
  8001ed:	e8 34 08 00 00       	call   800a26 <cprintf>
  8001f2:	83 c4 10             	add    $0x10,%esp
		}

		//		cprintf("Free Frames After Calculation = %d\n", sys_calculate_free_frames()) ;

		cprintf("Freeing the Heap...\n\n") ;
  8001f5:	83 ec 0c             	sub    $0xc,%esp
  8001f8:	68 d2 30 80 00       	push   $0x8030d2
  8001fd:	e8 24 08 00 00       	call   800a26 <cprintf>
  800202:	83 c4 10             	add    $0x10,%esp

		//freeHeap() ;

		///========================================================================
		//sys_lock_cons();
		cprintf("Do you want to repeat (y/n): ") ;
  800205:	83 ec 0c             	sub    $0xc,%esp
  800208:	68 e8 30 80 00       	push   $0x8030e8
  80020d:	e8 14 08 00 00       	call   800a26 <cprintf>
  800212:	83 c4 10             	add    $0x10,%esp
		Chose = getchar() ;
  800215:	e8 5c 03 00 00       	call   800576 <getchar>
  80021a:	88 45 e7             	mov    %al,-0x19(%ebp)
		cputchar(Chose);
  80021d:	0f be 45 e7          	movsbl -0x19(%ebp),%eax
  800221:	83 ec 0c             	sub    $0xc,%esp
  800224:	50                   	push   %eax
  800225:	e8 2d 03 00 00       	call   800557 <cputchar>
  80022a:	83 c4 10             	add    $0x10,%esp
		cputchar('\n');
  80022d:	83 ec 0c             	sub    $0xc,%esp
  800230:	6a 0a                	push   $0xa
  800232:	e8 20 03 00 00       	call   800557 <cputchar>
  800237:	83 c4 10             	add    $0x10,%esp
		cputchar('\n');
  80023a:	83 ec 0c             	sub    $0xc,%esp
  80023d:	6a 0a                	push   $0xa
  80023f:	e8 13 03 00 00       	call   800557 <cputchar>
  800244:	83 c4 10             	add    $0x10,%esp
		//sys_unlock_cons();

	} while (Chose == 'y');
  800247:	80 7d e7 79          	cmpb   $0x79,-0x19(%ebp)
  80024b:	0f 84 f8 fd ff ff    	je     800049 <_main+0x11>

}
  800251:	90                   	nop
  800252:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800255:	c9                   	leave  
  800256:	c3                   	ret    

00800257 <QuickSort>:

///Quick sort
void QuickSort(int *Elements, int NumOfElements)
{
  800257:	55                   	push   %ebp
  800258:	89 e5                	mov    %esp,%ebp
  80025a:	83 ec 08             	sub    $0x8,%esp
	QSort(Elements, NumOfElements, 0, NumOfElements-1) ;
  80025d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800260:	48                   	dec    %eax
  800261:	50                   	push   %eax
  800262:	6a 00                	push   $0x0
  800264:	ff 75 0c             	pushl  0xc(%ebp)
  800267:	ff 75 08             	pushl  0x8(%ebp)
  80026a:	e8 06 00 00 00       	call   800275 <QSort>
  80026f:	83 c4 10             	add    $0x10,%esp
}
  800272:	90                   	nop
  800273:	c9                   	leave  
  800274:	c3                   	ret    

00800275 <QSort>:


void QSort(int *Elements,int NumOfElements, int startIndex, int finalIndex)
{
  800275:	55                   	push   %ebp
  800276:	89 e5                	mov    %esp,%ebp
  800278:	83 ec 18             	sub    $0x18,%esp
	if (startIndex >= finalIndex) return;
  80027b:	8b 45 10             	mov    0x10(%ebp),%eax
  80027e:	3b 45 14             	cmp    0x14(%ebp),%eax
  800281:	0f 8d de 00 00 00    	jge    800365 <QSort+0xf0>

	int i = startIndex+1, j = finalIndex;
  800287:	8b 45 10             	mov    0x10(%ebp),%eax
  80028a:	40                   	inc    %eax
  80028b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80028e:	8b 45 14             	mov    0x14(%ebp),%eax
  800291:	89 45 f0             	mov    %eax,-0x10(%ebp)

	while (i <= j)
  800294:	e9 80 00 00 00       	jmp    800319 <QSort+0xa4>
	{
		while (i <= finalIndex && Elements[startIndex] >= Elements[i]) i++;
  800299:	ff 45 f4             	incl   -0xc(%ebp)
  80029c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80029f:	3b 45 14             	cmp    0x14(%ebp),%eax
  8002a2:	7f 2b                	jg     8002cf <QSort+0x5a>
  8002a4:	8b 45 10             	mov    0x10(%ebp),%eax
  8002a7:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8002ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8002b1:	01 d0                	add    %edx,%eax
  8002b3:	8b 10                	mov    (%eax),%edx
  8002b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8002b8:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8002bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8002c2:	01 c8                	add    %ecx,%eax
  8002c4:	8b 00                	mov    (%eax),%eax
  8002c6:	39 c2                	cmp    %eax,%edx
  8002c8:	7d cf                	jge    800299 <QSort+0x24>
		while (j > startIndex && Elements[startIndex] <= Elements[j]) j--;
  8002ca:	eb 03                	jmp    8002cf <QSort+0x5a>
  8002cc:	ff 4d f0             	decl   -0x10(%ebp)
  8002cf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8002d2:	3b 45 10             	cmp    0x10(%ebp),%eax
  8002d5:	7e 26                	jle    8002fd <QSort+0x88>
  8002d7:	8b 45 10             	mov    0x10(%ebp),%eax
  8002da:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8002e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8002e4:	01 d0                	add    %edx,%eax
  8002e6:	8b 10                	mov    (%eax),%edx
  8002e8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8002eb:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8002f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8002f5:	01 c8                	add    %ecx,%eax
  8002f7:	8b 00                	mov    (%eax),%eax
  8002f9:	39 c2                	cmp    %eax,%edx
  8002fb:	7e cf                	jle    8002cc <QSort+0x57>

		if (i <= j)
  8002fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800300:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800303:	7f 14                	jg     800319 <QSort+0xa4>
		{
			Swap(Elements, i, j);
  800305:	83 ec 04             	sub    $0x4,%esp
  800308:	ff 75 f0             	pushl  -0x10(%ebp)
  80030b:	ff 75 f4             	pushl  -0xc(%ebp)
  80030e:	ff 75 08             	pushl  0x8(%ebp)
  800311:	e8 a9 00 00 00       	call   8003bf <Swap>
  800316:	83 c4 10             	add    $0x10,%esp
{
	if (startIndex >= finalIndex) return;

	int i = startIndex+1, j = finalIndex;

	while (i <= j)
  800319:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80031c:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80031f:	0f 8e 77 ff ff ff    	jle    80029c <QSort+0x27>
		{
			Swap(Elements, i, j);
		}
	}

	Swap( Elements, startIndex, j);
  800325:	83 ec 04             	sub    $0x4,%esp
  800328:	ff 75 f0             	pushl  -0x10(%ebp)
  80032b:	ff 75 10             	pushl  0x10(%ebp)
  80032e:	ff 75 08             	pushl  0x8(%ebp)
  800331:	e8 89 00 00 00       	call   8003bf <Swap>
  800336:	83 c4 10             	add    $0x10,%esp

	QSort(Elements, NumOfElements, startIndex, j - 1);
  800339:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80033c:	48                   	dec    %eax
  80033d:	50                   	push   %eax
  80033e:	ff 75 10             	pushl  0x10(%ebp)
  800341:	ff 75 0c             	pushl  0xc(%ebp)
  800344:	ff 75 08             	pushl  0x8(%ebp)
  800347:	e8 29 ff ff ff       	call   800275 <QSort>
  80034c:	83 c4 10             	add    $0x10,%esp
	QSort(Elements, NumOfElements, i, finalIndex);
  80034f:	ff 75 14             	pushl  0x14(%ebp)
  800352:	ff 75 f4             	pushl  -0xc(%ebp)
  800355:	ff 75 0c             	pushl  0xc(%ebp)
  800358:	ff 75 08             	pushl  0x8(%ebp)
  80035b:	e8 15 ff ff ff       	call   800275 <QSort>
  800360:	83 c4 10             	add    $0x10,%esp
  800363:	eb 01                	jmp    800366 <QSort+0xf1>
}


void QSort(int *Elements,int NumOfElements, int startIndex, int finalIndex)
{
	if (startIndex >= finalIndex) return;
  800365:	90                   	nop

	Swap( Elements, startIndex, j);

	QSort(Elements, NumOfElements, startIndex, j - 1);
	QSort(Elements, NumOfElements, i, finalIndex);
}
  800366:	c9                   	leave  
  800367:	c3                   	ret    

00800368 <CheckSorted>:

uint32 CheckSorted(int *Elements, int NumOfElements)
{
  800368:	55                   	push   %ebp
  800369:	89 e5                	mov    %esp,%ebp
  80036b:	83 ec 10             	sub    $0x10,%esp
	uint32 Sorted = 1 ;
  80036e:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
	int i ;
	for (i = 0 ; i < NumOfElements - 1; i++)
  800375:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  80037c:	eb 33                	jmp    8003b1 <CheckSorted+0x49>
	{
		if (Elements[i] > Elements[i+1])
  80037e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800381:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800388:	8b 45 08             	mov    0x8(%ebp),%eax
  80038b:	01 d0                	add    %edx,%eax
  80038d:	8b 10                	mov    (%eax),%edx
  80038f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800392:	40                   	inc    %eax
  800393:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  80039a:	8b 45 08             	mov    0x8(%ebp),%eax
  80039d:	01 c8                	add    %ecx,%eax
  80039f:	8b 00                	mov    (%eax),%eax
  8003a1:	39 c2                	cmp    %eax,%edx
  8003a3:	7e 09                	jle    8003ae <CheckSorted+0x46>
		{
			Sorted = 0 ;
  8003a5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
			break;
  8003ac:	eb 0c                	jmp    8003ba <CheckSorted+0x52>

uint32 CheckSorted(int *Elements, int NumOfElements)
{
	uint32 Sorted = 1 ;
	int i ;
	for (i = 0 ; i < NumOfElements - 1; i++)
  8003ae:	ff 45 f8             	incl   -0x8(%ebp)
  8003b1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003b4:	48                   	dec    %eax
  8003b5:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8003b8:	7f c4                	jg     80037e <CheckSorted+0x16>
		{
			Sorted = 0 ;
			break;
		}
	}
	return Sorted ;
  8003ba:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8003bd:	c9                   	leave  
  8003be:	c3                   	ret    

008003bf <Swap>:

///Private Functions


void Swap(int *Elements, int First, int Second)
{
  8003bf:	55                   	push   %ebp
  8003c0:	89 e5                	mov    %esp,%ebp
  8003c2:	83 ec 10             	sub    $0x10,%esp
	int Tmp = Elements[First] ;
  8003c5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003c8:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8003cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8003d2:	01 d0                	add    %edx,%eax
  8003d4:	8b 00                	mov    (%eax),%eax
  8003d6:	89 45 fc             	mov    %eax,-0x4(%ebp)
	Elements[First] = Elements[Second] ;
  8003d9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003dc:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8003e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8003e6:	01 c2                	add    %eax,%edx
  8003e8:	8b 45 10             	mov    0x10(%ebp),%eax
  8003eb:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8003f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8003f5:	01 c8                	add    %ecx,%eax
  8003f7:	8b 00                	mov    (%eax),%eax
  8003f9:	89 02                	mov    %eax,(%edx)
	Elements[Second] = Tmp ;
  8003fb:	8b 45 10             	mov    0x10(%ebp),%eax
  8003fe:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800405:	8b 45 08             	mov    0x8(%ebp),%eax
  800408:	01 c2                	add    %eax,%edx
  80040a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80040d:	89 02                	mov    %eax,(%edx)
}
  80040f:	90                   	nop
  800410:	c9                   	leave  
  800411:	c3                   	ret    

00800412 <InitializeAscending>:

void InitializeAscending(int *Elements, int NumOfElements)
{
  800412:	55                   	push   %ebp
  800413:	89 e5                	mov    %esp,%ebp
  800415:	83 ec 10             	sub    $0x10,%esp
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  800418:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80041f:	eb 17                	jmp    800438 <InitializeAscending+0x26>
	{
		(Elements)[i] = i ;
  800421:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800424:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80042b:	8b 45 08             	mov    0x8(%ebp),%eax
  80042e:	01 c2                	add    %eax,%edx
  800430:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800433:	89 02                	mov    %eax,(%edx)
}

void InitializeAscending(int *Elements, int NumOfElements)
{
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  800435:	ff 45 fc             	incl   -0x4(%ebp)
  800438:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80043b:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80043e:	7c e1                	jl     800421 <InitializeAscending+0xf>
	{
		(Elements)[i] = i ;
	}

}
  800440:	90                   	nop
  800441:	c9                   	leave  
  800442:	c3                   	ret    

00800443 <InitializeIdentical>:

void InitializeIdentical(int *Elements, int NumOfElements)
{
  800443:	55                   	push   %ebp
  800444:	89 e5                	mov    %esp,%ebp
  800446:	83 ec 10             	sub    $0x10,%esp
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  800449:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800450:	eb 1b                	jmp    80046d <InitializeIdentical+0x2a>
	{
		Elements[i] = NumOfElements - i - 1 ;
  800452:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800455:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80045c:	8b 45 08             	mov    0x8(%ebp),%eax
  80045f:	01 c2                	add    %eax,%edx
  800461:	8b 45 0c             	mov    0xc(%ebp),%eax
  800464:	2b 45 fc             	sub    -0x4(%ebp),%eax
  800467:	48                   	dec    %eax
  800468:	89 02                	mov    %eax,(%edx)
}

void InitializeIdentical(int *Elements, int NumOfElements)
{
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  80046a:	ff 45 fc             	incl   -0x4(%ebp)
  80046d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800470:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800473:	7c dd                	jl     800452 <InitializeIdentical+0xf>
	{
		Elements[i] = NumOfElements - i - 1 ;
	}

}
  800475:	90                   	nop
  800476:	c9                   	leave  
  800477:	c3                   	ret    

00800478 <InitializeSemiRandom>:

void InitializeSemiRandom(int *Elements, int NumOfElements)
{
  800478:	55                   	push   %ebp
  800479:	89 e5                	mov    %esp,%ebp
  80047b:	83 ec 10             	sub    $0x10,%esp
	int i ;
	int Repetition = NumOfElements / 3 ;
  80047e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800481:	b8 56 55 55 55       	mov    $0x55555556,%eax
  800486:	f7 e9                	imul   %ecx
  800488:	c1 f9 1f             	sar    $0x1f,%ecx
  80048b:	89 d0                	mov    %edx,%eax
  80048d:	29 c8                	sub    %ecx,%eax
  80048f:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (Repetition == 0)
  800492:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800496:	75 07                	jne    80049f <InitializeSemiRandom+0x27>
			Repetition = 3;
  800498:	c7 45 f8 03 00 00 00 	movl   $0x3,-0x8(%ebp)
	for (i = 0 ; i < NumOfElements ; i++)
  80049f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8004a6:	eb 1e                	jmp    8004c6 <InitializeSemiRandom+0x4e>
	{
		Elements[i] = i % Repetition ;
  8004a8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8004ab:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8004b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8004b5:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  8004b8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8004bb:	99                   	cltd   
  8004bc:	f7 7d f8             	idivl  -0x8(%ebp)
  8004bf:	89 d0                	mov    %edx,%eax
  8004c1:	89 01                	mov    %eax,(%ecx)
{
	int i ;
	int Repetition = NumOfElements / 3 ;
	if (Repetition == 0)
			Repetition = 3;
	for (i = 0 ; i < NumOfElements ; i++)
  8004c3:	ff 45 fc             	incl   -0x4(%ebp)
  8004c6:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8004c9:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8004cc:	7c da                	jl     8004a8 <InitializeSemiRandom+0x30>
	{
		Elements[i] = i % Repetition ;
	}

}
  8004ce:	90                   	nop
  8004cf:	c9                   	leave  
  8004d0:	c3                   	ret    

008004d1 <PrintElements>:

void PrintElements(int *Elements, int NumOfElements)
{
  8004d1:	55                   	push   %ebp
  8004d2:	89 e5                	mov    %esp,%ebp
  8004d4:	83 ec 18             	sub    $0x18,%esp
	int i ;
	int NumsPerLine = 20 ;
  8004d7:	c7 45 f0 14 00 00 00 	movl   $0x14,-0x10(%ebp)
	for (i = 0 ; i < NumOfElements-1 ; i++)
  8004de:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  8004e5:	eb 42                	jmp    800529 <PrintElements+0x58>
	{
		if (i%NumsPerLine == 0)
  8004e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8004ea:	99                   	cltd   
  8004eb:	f7 7d f0             	idivl  -0x10(%ebp)
  8004ee:	89 d0                	mov    %edx,%eax
  8004f0:	85 c0                	test   %eax,%eax
  8004f2:	75 10                	jne    800504 <PrintElements+0x33>
			cprintf("\n");
  8004f4:	83 ec 0c             	sub    $0xc,%esp
  8004f7:	68 06 31 80 00       	push   $0x803106
  8004fc:	e8 25 05 00 00       	call   800a26 <cprintf>
  800501:	83 c4 10             	add    $0x10,%esp
		cprintf("%d, ",Elements[i]);
  800504:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800507:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80050e:	8b 45 08             	mov    0x8(%ebp),%eax
  800511:	01 d0                	add    %edx,%eax
  800513:	8b 00                	mov    (%eax),%eax
  800515:	83 ec 08             	sub    $0x8,%esp
  800518:	50                   	push   %eax
  800519:	68 08 31 80 00       	push   $0x803108
  80051e:	e8 03 05 00 00       	call   800a26 <cprintf>
  800523:	83 c4 10             	add    $0x10,%esp

void PrintElements(int *Elements, int NumOfElements)
{
	int i ;
	int NumsPerLine = 20 ;
	for (i = 0 ; i < NumOfElements-1 ; i++)
  800526:	ff 45 f4             	incl   -0xc(%ebp)
  800529:	8b 45 0c             	mov    0xc(%ebp),%eax
  80052c:	48                   	dec    %eax
  80052d:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  800530:	7f b5                	jg     8004e7 <PrintElements+0x16>
	{
		if (i%NumsPerLine == 0)
			cprintf("\n");
		cprintf("%d, ",Elements[i]);
	}
	cprintf("%d\n",Elements[i]);
  800532:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800535:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80053c:	8b 45 08             	mov    0x8(%ebp),%eax
  80053f:	01 d0                	add    %edx,%eax
  800541:	8b 00                	mov    (%eax),%eax
  800543:	83 ec 08             	sub    $0x8,%esp
  800546:	50                   	push   %eax
  800547:	68 0d 31 80 00       	push   $0x80310d
  80054c:	e8 d5 04 00 00       	call   800a26 <cprintf>
  800551:	83 c4 10             	add    $0x10,%esp
}
  800554:	90                   	nop
  800555:	c9                   	leave  
  800556:	c3                   	ret    

00800557 <cputchar>:
#include <inc/lib.h>


void
cputchar(int ch)
{
  800557:	55                   	push   %ebp
  800558:	89 e5                	mov    %esp,%ebp
  80055a:	83 ec 18             	sub    $0x18,%esp
	char c = ch;
  80055d:	8b 45 08             	mov    0x8(%ebp),%eax
  800560:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	//sys_cputs(&c, 1);

	sys_cputc(c);
  800563:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  800567:	83 ec 0c             	sub    $0xc,%esp
  80056a:	50                   	push   %eax
  80056b:	e8 11 19 00 00       	call   801e81 <sys_cputc>
  800570:	83 c4 10             	add    $0x10,%esp
}
  800573:	90                   	nop
  800574:	c9                   	leave  
  800575:	c3                   	ret    

00800576 <getchar>:


int
getchar(void)
{
  800576:	55                   	push   %ebp
  800577:	89 e5                	mov    %esp,%ebp
  800579:	83 ec 18             	sub    $0x18,%esp
	int c =sys_cgetc();
  80057c:	e8 9f 17 00 00       	call   801d20 <sys_cgetc>
  800581:	89 45 f4             	mov    %eax,-0xc(%ebp)
	return c;
  800584:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800587:	c9                   	leave  
  800588:	c3                   	ret    

00800589 <iscons>:

int iscons(int fdnum)
{
  800589:	55                   	push   %ebp
  80058a:	89 e5                	mov    %esp,%ebp
	// used by readline
	return 1;
  80058c:	b8 01 00 00 00       	mov    $0x1,%eax
}
  800591:	5d                   	pop    %ebp
  800592:	c3                   	ret    

00800593 <libmain>:
volatile bool printStats = 1;

volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";
void
libmain(int argc, char **argv)
{
  800593:	55                   	push   %ebp
  800594:	89 e5                	mov    %esp,%ebp
  800596:	57                   	push   %edi
  800597:	56                   	push   %esi
  800598:	53                   	push   %ebx
  800599:	83 ec 7c             	sub    $0x7c,%esp
	//printStats = 1;
	int envIndex = sys_getenvindex();
  80059c:	e8 11 1a 00 00       	call   801fb2 <sys_getenvindex>
  8005a1:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	myEnv = &(envs[envIndex]);
  8005a4:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8005a7:	89 d0                	mov    %edx,%eax
  8005a9:	c1 e0 06             	shl    $0x6,%eax
  8005ac:	29 d0                	sub    %edx,%eax
  8005ae:	c1 e0 02             	shl    $0x2,%eax
  8005b1:	01 d0                	add    %edx,%eax
  8005b3:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8005ba:	01 c8                	add    %ecx,%eax
  8005bc:	c1 e0 03             	shl    $0x3,%eax
  8005bf:	01 d0                	add    %edx,%eax
  8005c1:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8005c8:	29 c2                	sub    %eax,%edx
  8005ca:	8d 04 95 00 00 00 00 	lea    0x0(,%edx,4),%eax
  8005d1:	89 c2                	mov    %eax,%edx
  8005d3:	8d 82 00 00 c0 ee    	lea    -0x11400000(%edx),%eax
  8005d9:	a3 24 40 80 00       	mov    %eax,0x804024

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  8005de:	a1 24 40 80 00       	mov    0x804024,%eax
  8005e3:	8a 40 20             	mov    0x20(%eax),%al
  8005e6:	84 c0                	test   %al,%al
  8005e8:	74 0d                	je     8005f7 <libmain+0x64>
		binaryname = myEnv->prog_name;
  8005ea:	a1 24 40 80 00       	mov    0x804024,%eax
  8005ef:	83 c0 20             	add    $0x20,%eax
  8005f2:	a3 04 40 80 00       	mov    %eax,0x804004

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8005f7:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8005fb:	7e 0a                	jle    800607 <libmain+0x74>
		binaryname = argv[0];
  8005fd:	8b 45 0c             	mov    0xc(%ebp),%eax
  800600:	8b 00                	mov    (%eax),%eax
  800602:	a3 04 40 80 00       	mov    %eax,0x804004

	// call user main routine
	_main(argc, argv);
  800607:	83 ec 08             	sub    $0x8,%esp
  80060a:	ff 75 0c             	pushl  0xc(%ebp)
  80060d:	ff 75 08             	pushl  0x8(%ebp)
  800610:	e8 23 fa ff ff       	call   800038 <_main>
  800615:	83 c4 10             	add    $0x10,%esp

	if (printStats)
  800618:	a1 00 40 80 00       	mov    0x804000,%eax
  80061d:	85 c0                	test   %eax,%eax
  80061f:	0f 84 01 01 00 00    	je     800726 <libmain+0x193>
	{
		char isOPTReplCmd[100] = "__IsOPTRepl__" ;
  800625:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  80062b:	bb 0c 32 80 00       	mov    $0x80320c,%ebx
  800630:	ba 0e 00 00 00       	mov    $0xe,%edx
  800635:	89 c7                	mov    %eax,%edi
  800637:	89 de                	mov    %ebx,%esi
  800639:	89 d1                	mov    %edx,%ecx
  80063b:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  80063d:	8d 55 8a             	lea    -0x76(%ebp),%edx
  800640:	b9 56 00 00 00       	mov    $0x56,%ecx
  800645:	b0 00                	mov    $0x0,%al
  800647:	89 d7                	mov    %edx,%edi
  800649:	f3 aa                	rep stos %al,%es:(%edi)
		int isOPTRepl = 0;
  80064b:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
		sys_utilities(isOPTReplCmd, (uint32)(&isOPTRepl));
  800652:	8d 45 e0             	lea    -0x20(%ebp),%eax
  800655:	83 ec 08             	sub    $0x8,%esp
  800658:	50                   	push   %eax
  800659:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  80065f:	50                   	push   %eax
  800660:	e8 83 1b 00 00       	call   8021e8 <sys_utilities>
  800665:	83 c4 10             	add    $0x10,%esp

		sys_lock_cons();
  800668:	e8 cc 16 00 00       	call   801d39 <sys_lock_cons>
		{
			cprintf("**************************************\n");
  80066d:	83 ec 0c             	sub    $0xc,%esp
  800670:	68 2c 31 80 00       	push   $0x80312c
  800675:	e8 ac 03 00 00       	call   800a26 <cprintf>
  80067a:	83 c4 10             	add    $0x10,%esp
			if (isOPTRepl)
  80067d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800680:	85 c0                	test   %eax,%eax
  800682:	74 18                	je     80069c <libmain+0x109>
			{
				cprintf("OPTIMAL number of page faults = %d\n", sys_get_optimal_num_faults());
  800684:	e8 7d 1b 00 00       	call   802206 <sys_get_optimal_num_faults>
  800689:	83 ec 08             	sub    $0x8,%esp
  80068c:	50                   	push   %eax
  80068d:	68 54 31 80 00       	push   $0x803154
  800692:	e8 8f 03 00 00       	call   800a26 <cprintf>
  800697:	83 c4 10             	add    $0x10,%esp
  80069a:	eb 59                	jmp    8006f5 <libmain+0x162>
			}
			else
			{
				cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  80069c:	a1 24 40 80 00       	mov    0x804024,%eax
  8006a1:	8b 90 50 da 01 00    	mov    0x1da50(%eax),%edx
  8006a7:	a1 24 40 80 00       	mov    0x804024,%eax
  8006ac:	8b 80 40 da 01 00    	mov    0x1da40(%eax),%eax
  8006b2:	83 ec 04             	sub    $0x4,%esp
  8006b5:	52                   	push   %edx
  8006b6:	50                   	push   %eax
  8006b7:	68 78 31 80 00       	push   $0x803178
  8006bc:	e8 65 03 00 00       	call   800a26 <cprintf>
  8006c1:	83 c4 10             	add    $0x10,%esp
				cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  8006c4:	a1 24 40 80 00       	mov    0x804024,%eax
  8006c9:	8b 88 64 da 01 00    	mov    0x1da64(%eax),%ecx
  8006cf:	a1 24 40 80 00       	mov    0x804024,%eax
  8006d4:	8b 90 60 da 01 00    	mov    0x1da60(%eax),%edx
  8006da:	a1 24 40 80 00       	mov    0x804024,%eax
  8006df:	8b 80 5c da 01 00    	mov    0x1da5c(%eax),%eax
  8006e5:	51                   	push   %ecx
  8006e6:	52                   	push   %edx
  8006e7:	50                   	push   %eax
  8006e8:	68 a0 31 80 00       	push   $0x8031a0
  8006ed:	e8 34 03 00 00       	call   800a26 <cprintf>
  8006f2:	83 c4 10             	add    $0x10,%esp
			}
			//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
			cprintf("Num of clocks = %d\n", myEnv->nClocks);
  8006f5:	a1 24 40 80 00       	mov    0x804024,%eax
  8006fa:	8b 80 68 da 01 00    	mov    0x1da68(%eax),%eax
  800700:	83 ec 08             	sub    $0x8,%esp
  800703:	50                   	push   %eax
  800704:	68 f8 31 80 00       	push   $0x8031f8
  800709:	e8 18 03 00 00       	call   800a26 <cprintf>
  80070e:	83 c4 10             	add    $0x10,%esp
			cprintf("**************************************\n");
  800711:	83 ec 0c             	sub    $0xc,%esp
  800714:	68 2c 31 80 00       	push   $0x80312c
  800719:	e8 08 03 00 00       	call   800a26 <cprintf>
  80071e:	83 c4 10             	add    $0x10,%esp
		}
		sys_unlock_cons();
  800721:	e8 2d 16 00 00       	call   801d53 <sys_unlock_cons>
	}

	// exit gracefully
	exit();
  800726:	e8 1f 00 00 00       	call   80074a <exit>
}
  80072b:	90                   	nop
  80072c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80072f:	5b                   	pop    %ebx
  800730:	5e                   	pop    %esi
  800731:	5f                   	pop    %edi
  800732:	5d                   	pop    %ebp
  800733:	c3                   	ret    

00800734 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800734:	55                   	push   %ebp
  800735:	89 e5                	mov    %esp,%ebp
  800737:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  80073a:	83 ec 0c             	sub    $0xc,%esp
  80073d:	6a 00                	push   $0x0
  80073f:	e8 3a 18 00 00       	call   801f7e <sys_destroy_env>
  800744:	83 c4 10             	add    $0x10,%esp
}
  800747:	90                   	nop
  800748:	c9                   	leave  
  800749:	c3                   	ret    

0080074a <exit>:

void
exit(void)
{
  80074a:	55                   	push   %ebp
  80074b:	89 e5                	mov    %esp,%ebp
  80074d:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  800750:	e8 8f 18 00 00       	call   801fe4 <sys_exit_env>
}
  800755:	90                   	nop
  800756:	c9                   	leave  
  800757:	c3                   	ret    

00800758 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  800758:	55                   	push   %ebp
  800759:	89 e5                	mov    %esp,%ebp
  80075b:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  80075e:	8d 45 10             	lea    0x10(%ebp),%eax
  800761:	83 c0 04             	add    $0x4,%eax
  800764:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  800767:	a1 18 c1 81 00       	mov    0x81c118,%eax
  80076c:	85 c0                	test   %eax,%eax
  80076e:	74 16                	je     800786 <_panic+0x2e>
		cprintf("%s: ", argv0);
  800770:	a1 18 c1 81 00       	mov    0x81c118,%eax
  800775:	83 ec 08             	sub    $0x8,%esp
  800778:	50                   	push   %eax
  800779:	68 70 32 80 00       	push   $0x803270
  80077e:	e8 a3 02 00 00       	call   800a26 <cprintf>
  800783:	83 c4 10             	add    $0x10,%esp
	cprintf_colored(TEXT_PANIC_CLR, "user [EVAL_FINAL]panic in %s at %s:%d: ", binaryname, file, line);
  800786:	a1 04 40 80 00       	mov    0x804004,%eax
  80078b:	83 ec 0c             	sub    $0xc,%esp
  80078e:	ff 75 0c             	pushl  0xc(%ebp)
  800791:	ff 75 08             	pushl  0x8(%ebp)
  800794:	50                   	push   %eax
  800795:	68 78 32 80 00       	push   $0x803278
  80079a:	6a 74                	push   $0x74
  80079c:	e8 b2 02 00 00       	call   800a53 <cprintf_colored>
  8007a1:	83 c4 20             	add    $0x20,%esp
	vcprintf(fmt, ap);
  8007a4:	8b 45 10             	mov    0x10(%ebp),%eax
  8007a7:	83 ec 08             	sub    $0x8,%esp
  8007aa:	ff 75 f4             	pushl  -0xc(%ebp)
  8007ad:	50                   	push   %eax
  8007ae:	e8 04 02 00 00       	call   8009b7 <vcprintf>
  8007b3:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  8007b6:	83 ec 08             	sub    $0x8,%esp
  8007b9:	6a 00                	push   $0x0
  8007bb:	68 a0 32 80 00       	push   $0x8032a0
  8007c0:	e8 f2 01 00 00       	call   8009b7 <vcprintf>
  8007c5:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  8007c8:	e8 7d ff ff ff       	call   80074a <exit>

	// should not return here
	while (1) ;
  8007cd:	eb fe                	jmp    8007cd <_panic+0x75>

008007cf <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  8007cf:	55                   	push   %ebp
  8007d0:	89 e5                	mov    %esp,%ebp
  8007d2:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  8007d5:	a1 24 40 80 00       	mov    0x804024,%eax
  8007da:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  8007e0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8007e3:	39 c2                	cmp    %eax,%edx
  8007e5:	74 14                	je     8007fb <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  8007e7:	83 ec 04             	sub    $0x4,%esp
  8007ea:	68 a4 32 80 00       	push   $0x8032a4
  8007ef:	6a 26                	push   $0x26
  8007f1:	68 f0 32 80 00       	push   $0x8032f0
  8007f6:	e8 5d ff ff ff       	call   800758 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  8007fb:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  800802:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800809:	e9 c5 00 00 00       	jmp    8008d3 <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  80080e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800811:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800818:	8b 45 08             	mov    0x8(%ebp),%eax
  80081b:	01 d0                	add    %edx,%eax
  80081d:	8b 00                	mov    (%eax),%eax
  80081f:	85 c0                	test   %eax,%eax
  800821:	75 08                	jne    80082b <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  800823:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  800826:	e9 a5 00 00 00       	jmp    8008d0 <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  80082b:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800832:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  800839:	eb 69                	jmp    8008a4 <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  80083b:	a1 24 40 80 00       	mov    0x804024,%eax
  800840:	8b 88 38 da 01 00    	mov    0x1da38(%eax),%ecx
  800846:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800849:	89 d0                	mov    %edx,%eax
  80084b:	01 c0                	add    %eax,%eax
  80084d:	01 d0                	add    %edx,%eax
  80084f:	c1 e0 03             	shl    $0x3,%eax
  800852:	01 c8                	add    %ecx,%eax
  800854:	8a 40 04             	mov    0x4(%eax),%al
  800857:	84 c0                	test   %al,%al
  800859:	75 46                	jne    8008a1 <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  80085b:	a1 24 40 80 00       	mov    0x804024,%eax
  800860:	8b 88 38 da 01 00    	mov    0x1da38(%eax),%ecx
  800866:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800869:	89 d0                	mov    %edx,%eax
  80086b:	01 c0                	add    %eax,%eax
  80086d:	01 d0                	add    %edx,%eax
  80086f:	c1 e0 03             	shl    $0x3,%eax
  800872:	01 c8                	add    %ecx,%eax
  800874:	8b 00                	mov    (%eax),%eax
  800876:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800879:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80087c:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800881:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  800883:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800886:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  80088d:	8b 45 08             	mov    0x8(%ebp),%eax
  800890:	01 c8                	add    %ecx,%eax
  800892:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800894:	39 c2                	cmp    %eax,%edx
  800896:	75 09                	jne    8008a1 <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  800898:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  80089f:	eb 15                	jmp    8008b6 <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8008a1:	ff 45 e8             	incl   -0x18(%ebp)
  8008a4:	a1 24 40 80 00       	mov    0x804024,%eax
  8008a9:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  8008af:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8008b2:	39 c2                	cmp    %eax,%edx
  8008b4:	77 85                	ja     80083b <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  8008b6:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8008ba:	75 14                	jne    8008d0 <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  8008bc:	83 ec 04             	sub    $0x4,%esp
  8008bf:	68 fc 32 80 00       	push   $0x8032fc
  8008c4:	6a 3a                	push   $0x3a
  8008c6:	68 f0 32 80 00       	push   $0x8032f0
  8008cb:	e8 88 fe ff ff       	call   800758 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  8008d0:	ff 45 f0             	incl   -0x10(%ebp)
  8008d3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8008d6:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8008d9:	0f 8c 2f ff ff ff    	jl     80080e <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  8008df:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8008e6:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  8008ed:	eb 26                	jmp    800915 <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  8008ef:	a1 24 40 80 00       	mov    0x804024,%eax
  8008f4:	8b 88 38 da 01 00    	mov    0x1da38(%eax),%ecx
  8008fa:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8008fd:	89 d0                	mov    %edx,%eax
  8008ff:	01 c0                	add    %eax,%eax
  800901:	01 d0                	add    %edx,%eax
  800903:	c1 e0 03             	shl    $0x3,%eax
  800906:	01 c8                	add    %ecx,%eax
  800908:	8a 40 04             	mov    0x4(%eax),%al
  80090b:	3c 01                	cmp    $0x1,%al
  80090d:	75 03                	jne    800912 <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  80090f:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800912:	ff 45 e0             	incl   -0x20(%ebp)
  800915:	a1 24 40 80 00       	mov    0x804024,%eax
  80091a:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  800920:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800923:	39 c2                	cmp    %eax,%edx
  800925:	77 c8                	ja     8008ef <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  800927:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80092a:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  80092d:	74 14                	je     800943 <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  80092f:	83 ec 04             	sub    $0x4,%esp
  800932:	68 50 33 80 00       	push   $0x803350
  800937:	6a 44                	push   $0x44
  800939:	68 f0 32 80 00       	push   $0x8032f0
  80093e:	e8 15 fe ff ff       	call   800758 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  800943:	90                   	nop
  800944:	c9                   	leave  
  800945:	c3                   	ret    

00800946 <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  800946:	55                   	push   %ebp
  800947:	89 e5                	mov    %esp,%ebp
  800949:	53                   	push   %ebx
  80094a:	83 ec 04             	sub    $0x4,%esp
	b->buf[b->idx++] = ch;
  80094d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800950:	8b 00                	mov    (%eax),%eax
  800952:	8d 48 01             	lea    0x1(%eax),%ecx
  800955:	8b 55 0c             	mov    0xc(%ebp),%edx
  800958:	89 0a                	mov    %ecx,(%edx)
  80095a:	8b 55 08             	mov    0x8(%ebp),%edx
  80095d:	88 d1                	mov    %dl,%cl
  80095f:	8b 55 0c             	mov    0xc(%ebp),%edx
  800962:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800966:	8b 45 0c             	mov    0xc(%ebp),%eax
  800969:	8b 00                	mov    (%eax),%eax
  80096b:	3d ff 00 00 00       	cmp    $0xff,%eax
  800970:	75 30                	jne    8009a2 <putch+0x5c>
		sys_cputs(b->buf, b->idx, printProgName, curTextClr);
  800972:	8b 15 1c c1 81 00    	mov    0x81c11c,%edx
  800978:	a0 44 40 80 00       	mov    0x804044,%al
  80097d:	0f b6 c0             	movzbl %al,%eax
  800980:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800983:	8b 09                	mov    (%ecx),%ecx
  800985:	89 cb                	mov    %ecx,%ebx
  800987:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80098a:	83 c1 08             	add    $0x8,%ecx
  80098d:	52                   	push   %edx
  80098e:	50                   	push   %eax
  80098f:	53                   	push   %ebx
  800990:	51                   	push   %ecx
  800991:	e8 5f 13 00 00       	call   801cf5 <sys_cputs>
  800996:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800999:	8b 45 0c             	mov    0xc(%ebp),%eax
  80099c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8009a2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009a5:	8b 40 04             	mov    0x4(%eax),%eax
  8009a8:	8d 50 01             	lea    0x1(%eax),%edx
  8009ab:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009ae:	89 50 04             	mov    %edx,0x4(%eax)
}
  8009b1:	90                   	nop
  8009b2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8009b5:	c9                   	leave  
  8009b6:	c3                   	ret    

008009b7 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  8009b7:	55                   	push   %ebp
  8009b8:	89 e5                	mov    %esp,%ebp
  8009ba:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8009c0:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8009c7:	00 00 00 
	b.cnt = 0;
  8009ca:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8009d1:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  8009d4:	ff 75 0c             	pushl  0xc(%ebp)
  8009d7:	ff 75 08             	pushl  0x8(%ebp)
  8009da:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8009e0:	50                   	push   %eax
  8009e1:	68 46 09 80 00       	push   $0x800946
  8009e6:	e8 5a 02 00 00       	call   800c45 <vprintfmt>
  8009eb:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName, curTextClr);
  8009ee:	8b 15 1c c1 81 00    	mov    0x81c11c,%edx
  8009f4:	a0 44 40 80 00       	mov    0x804044,%al
  8009f9:	0f b6 c0             	movzbl %al,%eax
  8009fc:	8b 8d f0 fe ff ff    	mov    -0x110(%ebp),%ecx
  800a02:	52                   	push   %edx
  800a03:	50                   	push   %eax
  800a04:	51                   	push   %ecx
  800a05:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800a0b:	83 c0 08             	add    $0x8,%eax
  800a0e:	50                   	push   %eax
  800a0f:	e8 e1 12 00 00       	call   801cf5 <sys_cputs>
  800a14:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800a17:	c6 05 44 40 80 00 00 	movb   $0x0,0x804044
	return b.cnt;
  800a1e:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800a24:	c9                   	leave  
  800a25:	c3                   	ret    

00800a26 <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  800a26:	55                   	push   %ebp
  800a27:	89 e5                	mov    %esp,%ebp
  800a29:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800a2c:	c6 05 44 40 80 00 01 	movb   $0x1,0x804044
	va_start(ap, fmt);
  800a33:	8d 45 0c             	lea    0xc(%ebp),%eax
  800a36:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800a39:	8b 45 08             	mov    0x8(%ebp),%eax
  800a3c:	83 ec 08             	sub    $0x8,%esp
  800a3f:	ff 75 f4             	pushl  -0xc(%ebp)
  800a42:	50                   	push   %eax
  800a43:	e8 6f ff ff ff       	call   8009b7 <vcprintf>
  800a48:	83 c4 10             	add    $0x10,%esp
  800a4b:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800a4e:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800a51:	c9                   	leave  
  800a52:	c3                   	ret    

00800a53 <cprintf_colored>:

// *************** This text coloring feature is implemented by *************
// ********** Abd-Alrahman Zedan From Team Frozen-Bytes - FCIS'24-25 ********
int cprintf_colored(int textClr, const char *fmt, ...) {
  800a53:	55                   	push   %ebp
  800a54:	89 e5                	mov    %esp,%ebp
  800a56:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800a59:	c6 05 44 40 80 00 01 	movb   $0x1,0x804044
	curTextClr = (textClr << 8) ; //set text color by the given value
  800a60:	8b 45 08             	mov    0x8(%ebp),%eax
  800a63:	c1 e0 08             	shl    $0x8,%eax
  800a66:	a3 1c c1 81 00       	mov    %eax,0x81c11c
	va_start(ap, fmt);
  800a6b:	8d 45 0c             	lea    0xc(%ebp),%eax
  800a6e:	83 c0 04             	add    $0x4,%eax
  800a71:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800a74:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a77:	83 ec 08             	sub    $0x8,%esp
  800a7a:	ff 75 f4             	pushl  -0xc(%ebp)
  800a7d:	50                   	push   %eax
  800a7e:	e8 34 ff ff ff       	call   8009b7 <vcprintf>
  800a83:	83 c4 10             	add    $0x10,%esp
  800a86:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);
	curTextClr = TEXT_DEFAULT_CLR; //restore default color
  800a89:	c7 05 1c c1 81 00 00 	movl   $0x700,0x81c11c
  800a90:	07 00 00 

	return cnt;
  800a93:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800a96:	c9                   	leave  
  800a97:	c3                   	ret    

00800a98 <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  800a98:	55                   	push   %ebp
  800a99:	89 e5                	mov    %esp,%ebp
  800a9b:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  800a9e:	e8 96 12 00 00       	call   801d39 <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  800aa3:	8d 45 0c             	lea    0xc(%ebp),%eax
  800aa6:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  800aa9:	8b 45 08             	mov    0x8(%ebp),%eax
  800aac:	83 ec 08             	sub    $0x8,%esp
  800aaf:	ff 75 f4             	pushl  -0xc(%ebp)
  800ab2:	50                   	push   %eax
  800ab3:	e8 ff fe ff ff       	call   8009b7 <vcprintf>
  800ab8:	83 c4 10             	add    $0x10,%esp
  800abb:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  800abe:	e8 90 12 00 00       	call   801d53 <sys_unlock_cons>
	return cnt;
  800ac3:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800ac6:	c9                   	leave  
  800ac7:	c3                   	ret    

00800ac8 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800ac8:	55                   	push   %ebp
  800ac9:	89 e5                	mov    %esp,%ebp
  800acb:	53                   	push   %ebx
  800acc:	83 ec 14             	sub    $0x14,%esp
  800acf:	8b 45 10             	mov    0x10(%ebp),%eax
  800ad2:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800ad5:	8b 45 14             	mov    0x14(%ebp),%eax
  800ad8:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800adb:	8b 45 18             	mov    0x18(%ebp),%eax
  800ade:	ba 00 00 00 00       	mov    $0x0,%edx
  800ae3:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800ae6:	77 55                	ja     800b3d <printnum+0x75>
  800ae8:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800aeb:	72 05                	jb     800af2 <printnum+0x2a>
  800aed:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800af0:	77 4b                	ja     800b3d <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800af2:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800af5:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800af8:	8b 45 18             	mov    0x18(%ebp),%eax
  800afb:	ba 00 00 00 00       	mov    $0x0,%edx
  800b00:	52                   	push   %edx
  800b01:	50                   	push   %eax
  800b02:	ff 75 f4             	pushl  -0xc(%ebp)
  800b05:	ff 75 f0             	pushl  -0x10(%ebp)
  800b08:	e8 0f 22 00 00       	call   802d1c <__udivdi3>
  800b0d:	83 c4 10             	add    $0x10,%esp
  800b10:	83 ec 04             	sub    $0x4,%esp
  800b13:	ff 75 20             	pushl  0x20(%ebp)
  800b16:	53                   	push   %ebx
  800b17:	ff 75 18             	pushl  0x18(%ebp)
  800b1a:	52                   	push   %edx
  800b1b:	50                   	push   %eax
  800b1c:	ff 75 0c             	pushl  0xc(%ebp)
  800b1f:	ff 75 08             	pushl  0x8(%ebp)
  800b22:	e8 a1 ff ff ff       	call   800ac8 <printnum>
  800b27:	83 c4 20             	add    $0x20,%esp
  800b2a:	eb 1a                	jmp    800b46 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800b2c:	83 ec 08             	sub    $0x8,%esp
  800b2f:	ff 75 0c             	pushl  0xc(%ebp)
  800b32:	ff 75 20             	pushl  0x20(%ebp)
  800b35:	8b 45 08             	mov    0x8(%ebp),%eax
  800b38:	ff d0                	call   *%eax
  800b3a:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800b3d:	ff 4d 1c             	decl   0x1c(%ebp)
  800b40:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800b44:	7f e6                	jg     800b2c <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800b46:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800b49:	bb 00 00 00 00       	mov    $0x0,%ebx
  800b4e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800b51:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800b54:	53                   	push   %ebx
  800b55:	51                   	push   %ecx
  800b56:	52                   	push   %edx
  800b57:	50                   	push   %eax
  800b58:	e8 cf 22 00 00       	call   802e2c <__umoddi3>
  800b5d:	83 c4 10             	add    $0x10,%esp
  800b60:	05 b4 35 80 00       	add    $0x8035b4,%eax
  800b65:	8a 00                	mov    (%eax),%al
  800b67:	0f be c0             	movsbl %al,%eax
  800b6a:	83 ec 08             	sub    $0x8,%esp
  800b6d:	ff 75 0c             	pushl  0xc(%ebp)
  800b70:	50                   	push   %eax
  800b71:	8b 45 08             	mov    0x8(%ebp),%eax
  800b74:	ff d0                	call   *%eax
  800b76:	83 c4 10             	add    $0x10,%esp
}
  800b79:	90                   	nop
  800b7a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800b7d:	c9                   	leave  
  800b7e:	c3                   	ret    

00800b7f <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800b7f:	55                   	push   %ebp
  800b80:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800b82:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800b86:	7e 1c                	jle    800ba4 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800b88:	8b 45 08             	mov    0x8(%ebp),%eax
  800b8b:	8b 00                	mov    (%eax),%eax
  800b8d:	8d 50 08             	lea    0x8(%eax),%edx
  800b90:	8b 45 08             	mov    0x8(%ebp),%eax
  800b93:	89 10                	mov    %edx,(%eax)
  800b95:	8b 45 08             	mov    0x8(%ebp),%eax
  800b98:	8b 00                	mov    (%eax),%eax
  800b9a:	83 e8 08             	sub    $0x8,%eax
  800b9d:	8b 50 04             	mov    0x4(%eax),%edx
  800ba0:	8b 00                	mov    (%eax),%eax
  800ba2:	eb 40                	jmp    800be4 <getuint+0x65>
	else if (lflag)
  800ba4:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800ba8:	74 1e                	je     800bc8 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800baa:	8b 45 08             	mov    0x8(%ebp),%eax
  800bad:	8b 00                	mov    (%eax),%eax
  800baf:	8d 50 04             	lea    0x4(%eax),%edx
  800bb2:	8b 45 08             	mov    0x8(%ebp),%eax
  800bb5:	89 10                	mov    %edx,(%eax)
  800bb7:	8b 45 08             	mov    0x8(%ebp),%eax
  800bba:	8b 00                	mov    (%eax),%eax
  800bbc:	83 e8 04             	sub    $0x4,%eax
  800bbf:	8b 00                	mov    (%eax),%eax
  800bc1:	ba 00 00 00 00       	mov    $0x0,%edx
  800bc6:	eb 1c                	jmp    800be4 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800bc8:	8b 45 08             	mov    0x8(%ebp),%eax
  800bcb:	8b 00                	mov    (%eax),%eax
  800bcd:	8d 50 04             	lea    0x4(%eax),%edx
  800bd0:	8b 45 08             	mov    0x8(%ebp),%eax
  800bd3:	89 10                	mov    %edx,(%eax)
  800bd5:	8b 45 08             	mov    0x8(%ebp),%eax
  800bd8:	8b 00                	mov    (%eax),%eax
  800bda:	83 e8 04             	sub    $0x4,%eax
  800bdd:	8b 00                	mov    (%eax),%eax
  800bdf:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800be4:	5d                   	pop    %ebp
  800be5:	c3                   	ret    

00800be6 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800be6:	55                   	push   %ebp
  800be7:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800be9:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800bed:	7e 1c                	jle    800c0b <getint+0x25>
		return va_arg(*ap, long long);
  800bef:	8b 45 08             	mov    0x8(%ebp),%eax
  800bf2:	8b 00                	mov    (%eax),%eax
  800bf4:	8d 50 08             	lea    0x8(%eax),%edx
  800bf7:	8b 45 08             	mov    0x8(%ebp),%eax
  800bfa:	89 10                	mov    %edx,(%eax)
  800bfc:	8b 45 08             	mov    0x8(%ebp),%eax
  800bff:	8b 00                	mov    (%eax),%eax
  800c01:	83 e8 08             	sub    $0x8,%eax
  800c04:	8b 50 04             	mov    0x4(%eax),%edx
  800c07:	8b 00                	mov    (%eax),%eax
  800c09:	eb 38                	jmp    800c43 <getint+0x5d>
	else if (lflag)
  800c0b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c0f:	74 1a                	je     800c2b <getint+0x45>
		return va_arg(*ap, long);
  800c11:	8b 45 08             	mov    0x8(%ebp),%eax
  800c14:	8b 00                	mov    (%eax),%eax
  800c16:	8d 50 04             	lea    0x4(%eax),%edx
  800c19:	8b 45 08             	mov    0x8(%ebp),%eax
  800c1c:	89 10                	mov    %edx,(%eax)
  800c1e:	8b 45 08             	mov    0x8(%ebp),%eax
  800c21:	8b 00                	mov    (%eax),%eax
  800c23:	83 e8 04             	sub    $0x4,%eax
  800c26:	8b 00                	mov    (%eax),%eax
  800c28:	99                   	cltd   
  800c29:	eb 18                	jmp    800c43 <getint+0x5d>
	else
		return va_arg(*ap, int);
  800c2b:	8b 45 08             	mov    0x8(%ebp),%eax
  800c2e:	8b 00                	mov    (%eax),%eax
  800c30:	8d 50 04             	lea    0x4(%eax),%edx
  800c33:	8b 45 08             	mov    0x8(%ebp),%eax
  800c36:	89 10                	mov    %edx,(%eax)
  800c38:	8b 45 08             	mov    0x8(%ebp),%eax
  800c3b:	8b 00                	mov    (%eax),%eax
  800c3d:	83 e8 04             	sub    $0x4,%eax
  800c40:	8b 00                	mov    (%eax),%eax
  800c42:	99                   	cltd   
}
  800c43:	5d                   	pop    %ebp
  800c44:	c3                   	ret    

00800c45 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800c45:	55                   	push   %ebp
  800c46:	89 e5                	mov    %esp,%ebp
  800c48:	56                   	push   %esi
  800c49:	53                   	push   %ebx
  800c4a:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800c4d:	eb 17                	jmp    800c66 <vprintfmt+0x21>
			if (ch == '\0')
  800c4f:	85 db                	test   %ebx,%ebx
  800c51:	0f 84 c1 03 00 00    	je     801018 <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  800c57:	83 ec 08             	sub    $0x8,%esp
  800c5a:	ff 75 0c             	pushl  0xc(%ebp)
  800c5d:	53                   	push   %ebx
  800c5e:	8b 45 08             	mov    0x8(%ebp),%eax
  800c61:	ff d0                	call   *%eax
  800c63:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800c66:	8b 45 10             	mov    0x10(%ebp),%eax
  800c69:	8d 50 01             	lea    0x1(%eax),%edx
  800c6c:	89 55 10             	mov    %edx,0x10(%ebp)
  800c6f:	8a 00                	mov    (%eax),%al
  800c71:	0f b6 d8             	movzbl %al,%ebx
  800c74:	83 fb 25             	cmp    $0x25,%ebx
  800c77:	75 d6                	jne    800c4f <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800c79:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800c7d:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800c84:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800c8b:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800c92:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800c99:	8b 45 10             	mov    0x10(%ebp),%eax
  800c9c:	8d 50 01             	lea    0x1(%eax),%edx
  800c9f:	89 55 10             	mov    %edx,0x10(%ebp)
  800ca2:	8a 00                	mov    (%eax),%al
  800ca4:	0f b6 d8             	movzbl %al,%ebx
  800ca7:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800caa:	83 f8 5b             	cmp    $0x5b,%eax
  800cad:	0f 87 3d 03 00 00    	ja     800ff0 <vprintfmt+0x3ab>
  800cb3:	8b 04 85 d8 35 80 00 	mov    0x8035d8(,%eax,4),%eax
  800cba:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800cbc:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800cc0:	eb d7                	jmp    800c99 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800cc2:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800cc6:	eb d1                	jmp    800c99 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800cc8:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800ccf:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800cd2:	89 d0                	mov    %edx,%eax
  800cd4:	c1 e0 02             	shl    $0x2,%eax
  800cd7:	01 d0                	add    %edx,%eax
  800cd9:	01 c0                	add    %eax,%eax
  800cdb:	01 d8                	add    %ebx,%eax
  800cdd:	83 e8 30             	sub    $0x30,%eax
  800ce0:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800ce3:	8b 45 10             	mov    0x10(%ebp),%eax
  800ce6:	8a 00                	mov    (%eax),%al
  800ce8:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800ceb:	83 fb 2f             	cmp    $0x2f,%ebx
  800cee:	7e 3e                	jle    800d2e <vprintfmt+0xe9>
  800cf0:	83 fb 39             	cmp    $0x39,%ebx
  800cf3:	7f 39                	jg     800d2e <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800cf5:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800cf8:	eb d5                	jmp    800ccf <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800cfa:	8b 45 14             	mov    0x14(%ebp),%eax
  800cfd:	83 c0 04             	add    $0x4,%eax
  800d00:	89 45 14             	mov    %eax,0x14(%ebp)
  800d03:	8b 45 14             	mov    0x14(%ebp),%eax
  800d06:	83 e8 04             	sub    $0x4,%eax
  800d09:	8b 00                	mov    (%eax),%eax
  800d0b:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800d0e:	eb 1f                	jmp    800d2f <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800d10:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800d14:	79 83                	jns    800c99 <vprintfmt+0x54>
				width = 0;
  800d16:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800d1d:	e9 77 ff ff ff       	jmp    800c99 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800d22:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800d29:	e9 6b ff ff ff       	jmp    800c99 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800d2e:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800d2f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800d33:	0f 89 60 ff ff ff    	jns    800c99 <vprintfmt+0x54>
				width = precision, precision = -1;
  800d39:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800d3c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800d3f:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800d46:	e9 4e ff ff ff       	jmp    800c99 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800d4b:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800d4e:	e9 46 ff ff ff       	jmp    800c99 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800d53:	8b 45 14             	mov    0x14(%ebp),%eax
  800d56:	83 c0 04             	add    $0x4,%eax
  800d59:	89 45 14             	mov    %eax,0x14(%ebp)
  800d5c:	8b 45 14             	mov    0x14(%ebp),%eax
  800d5f:	83 e8 04             	sub    $0x4,%eax
  800d62:	8b 00                	mov    (%eax),%eax
  800d64:	83 ec 08             	sub    $0x8,%esp
  800d67:	ff 75 0c             	pushl  0xc(%ebp)
  800d6a:	50                   	push   %eax
  800d6b:	8b 45 08             	mov    0x8(%ebp),%eax
  800d6e:	ff d0                	call   *%eax
  800d70:	83 c4 10             	add    $0x10,%esp
			break;
  800d73:	e9 9b 02 00 00       	jmp    801013 <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800d78:	8b 45 14             	mov    0x14(%ebp),%eax
  800d7b:	83 c0 04             	add    $0x4,%eax
  800d7e:	89 45 14             	mov    %eax,0x14(%ebp)
  800d81:	8b 45 14             	mov    0x14(%ebp),%eax
  800d84:	83 e8 04             	sub    $0x4,%eax
  800d87:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800d89:	85 db                	test   %ebx,%ebx
  800d8b:	79 02                	jns    800d8f <vprintfmt+0x14a>
				err = -err;
  800d8d:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800d8f:	83 fb 64             	cmp    $0x64,%ebx
  800d92:	7f 0b                	jg     800d9f <vprintfmt+0x15a>
  800d94:	8b 34 9d 20 34 80 00 	mov    0x803420(,%ebx,4),%esi
  800d9b:	85 f6                	test   %esi,%esi
  800d9d:	75 19                	jne    800db8 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800d9f:	53                   	push   %ebx
  800da0:	68 c5 35 80 00       	push   $0x8035c5
  800da5:	ff 75 0c             	pushl  0xc(%ebp)
  800da8:	ff 75 08             	pushl  0x8(%ebp)
  800dab:	e8 70 02 00 00       	call   801020 <printfmt>
  800db0:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800db3:	e9 5b 02 00 00       	jmp    801013 <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800db8:	56                   	push   %esi
  800db9:	68 ce 35 80 00       	push   $0x8035ce
  800dbe:	ff 75 0c             	pushl  0xc(%ebp)
  800dc1:	ff 75 08             	pushl  0x8(%ebp)
  800dc4:	e8 57 02 00 00       	call   801020 <printfmt>
  800dc9:	83 c4 10             	add    $0x10,%esp
			break;
  800dcc:	e9 42 02 00 00       	jmp    801013 <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800dd1:	8b 45 14             	mov    0x14(%ebp),%eax
  800dd4:	83 c0 04             	add    $0x4,%eax
  800dd7:	89 45 14             	mov    %eax,0x14(%ebp)
  800dda:	8b 45 14             	mov    0x14(%ebp),%eax
  800ddd:	83 e8 04             	sub    $0x4,%eax
  800de0:	8b 30                	mov    (%eax),%esi
  800de2:	85 f6                	test   %esi,%esi
  800de4:	75 05                	jne    800deb <vprintfmt+0x1a6>
				p = "(null)";
  800de6:	be d1 35 80 00       	mov    $0x8035d1,%esi
			if (width > 0 && padc != '-')
  800deb:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800def:	7e 6d                	jle    800e5e <vprintfmt+0x219>
  800df1:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800df5:	74 67                	je     800e5e <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800df7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800dfa:	83 ec 08             	sub    $0x8,%esp
  800dfd:	50                   	push   %eax
  800dfe:	56                   	push   %esi
  800dff:	e8 26 05 00 00       	call   80132a <strnlen>
  800e04:	83 c4 10             	add    $0x10,%esp
  800e07:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800e0a:	eb 16                	jmp    800e22 <vprintfmt+0x1dd>
					putch(padc, putdat);
  800e0c:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800e10:	83 ec 08             	sub    $0x8,%esp
  800e13:	ff 75 0c             	pushl  0xc(%ebp)
  800e16:	50                   	push   %eax
  800e17:	8b 45 08             	mov    0x8(%ebp),%eax
  800e1a:	ff d0                	call   *%eax
  800e1c:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800e1f:	ff 4d e4             	decl   -0x1c(%ebp)
  800e22:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800e26:	7f e4                	jg     800e0c <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800e28:	eb 34                	jmp    800e5e <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800e2a:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800e2e:	74 1c                	je     800e4c <vprintfmt+0x207>
  800e30:	83 fb 1f             	cmp    $0x1f,%ebx
  800e33:	7e 05                	jle    800e3a <vprintfmt+0x1f5>
  800e35:	83 fb 7e             	cmp    $0x7e,%ebx
  800e38:	7e 12                	jle    800e4c <vprintfmt+0x207>
					putch('?', putdat);
  800e3a:	83 ec 08             	sub    $0x8,%esp
  800e3d:	ff 75 0c             	pushl  0xc(%ebp)
  800e40:	6a 3f                	push   $0x3f
  800e42:	8b 45 08             	mov    0x8(%ebp),%eax
  800e45:	ff d0                	call   *%eax
  800e47:	83 c4 10             	add    $0x10,%esp
  800e4a:	eb 0f                	jmp    800e5b <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800e4c:	83 ec 08             	sub    $0x8,%esp
  800e4f:	ff 75 0c             	pushl  0xc(%ebp)
  800e52:	53                   	push   %ebx
  800e53:	8b 45 08             	mov    0x8(%ebp),%eax
  800e56:	ff d0                	call   *%eax
  800e58:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800e5b:	ff 4d e4             	decl   -0x1c(%ebp)
  800e5e:	89 f0                	mov    %esi,%eax
  800e60:	8d 70 01             	lea    0x1(%eax),%esi
  800e63:	8a 00                	mov    (%eax),%al
  800e65:	0f be d8             	movsbl %al,%ebx
  800e68:	85 db                	test   %ebx,%ebx
  800e6a:	74 24                	je     800e90 <vprintfmt+0x24b>
  800e6c:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800e70:	78 b8                	js     800e2a <vprintfmt+0x1e5>
  800e72:	ff 4d e0             	decl   -0x20(%ebp)
  800e75:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800e79:	79 af                	jns    800e2a <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800e7b:	eb 13                	jmp    800e90 <vprintfmt+0x24b>
				putch(' ', putdat);
  800e7d:	83 ec 08             	sub    $0x8,%esp
  800e80:	ff 75 0c             	pushl  0xc(%ebp)
  800e83:	6a 20                	push   $0x20
  800e85:	8b 45 08             	mov    0x8(%ebp),%eax
  800e88:	ff d0                	call   *%eax
  800e8a:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800e8d:	ff 4d e4             	decl   -0x1c(%ebp)
  800e90:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800e94:	7f e7                	jg     800e7d <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800e96:	e9 78 01 00 00       	jmp    801013 <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800e9b:	83 ec 08             	sub    $0x8,%esp
  800e9e:	ff 75 e8             	pushl  -0x18(%ebp)
  800ea1:	8d 45 14             	lea    0x14(%ebp),%eax
  800ea4:	50                   	push   %eax
  800ea5:	e8 3c fd ff ff       	call   800be6 <getint>
  800eaa:	83 c4 10             	add    $0x10,%esp
  800ead:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800eb0:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800eb3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800eb6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800eb9:	85 d2                	test   %edx,%edx
  800ebb:	79 23                	jns    800ee0 <vprintfmt+0x29b>
				putch('-', putdat);
  800ebd:	83 ec 08             	sub    $0x8,%esp
  800ec0:	ff 75 0c             	pushl  0xc(%ebp)
  800ec3:	6a 2d                	push   $0x2d
  800ec5:	8b 45 08             	mov    0x8(%ebp),%eax
  800ec8:	ff d0                	call   *%eax
  800eca:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800ecd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800ed0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800ed3:	f7 d8                	neg    %eax
  800ed5:	83 d2 00             	adc    $0x0,%edx
  800ed8:	f7 da                	neg    %edx
  800eda:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800edd:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800ee0:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800ee7:	e9 bc 00 00 00       	jmp    800fa8 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800eec:	83 ec 08             	sub    $0x8,%esp
  800eef:	ff 75 e8             	pushl  -0x18(%ebp)
  800ef2:	8d 45 14             	lea    0x14(%ebp),%eax
  800ef5:	50                   	push   %eax
  800ef6:	e8 84 fc ff ff       	call   800b7f <getuint>
  800efb:	83 c4 10             	add    $0x10,%esp
  800efe:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800f01:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800f04:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800f0b:	e9 98 00 00 00       	jmp    800fa8 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800f10:	83 ec 08             	sub    $0x8,%esp
  800f13:	ff 75 0c             	pushl  0xc(%ebp)
  800f16:	6a 58                	push   $0x58
  800f18:	8b 45 08             	mov    0x8(%ebp),%eax
  800f1b:	ff d0                	call   *%eax
  800f1d:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800f20:	83 ec 08             	sub    $0x8,%esp
  800f23:	ff 75 0c             	pushl  0xc(%ebp)
  800f26:	6a 58                	push   $0x58
  800f28:	8b 45 08             	mov    0x8(%ebp),%eax
  800f2b:	ff d0                	call   *%eax
  800f2d:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800f30:	83 ec 08             	sub    $0x8,%esp
  800f33:	ff 75 0c             	pushl  0xc(%ebp)
  800f36:	6a 58                	push   $0x58
  800f38:	8b 45 08             	mov    0x8(%ebp),%eax
  800f3b:	ff d0                	call   *%eax
  800f3d:	83 c4 10             	add    $0x10,%esp
			break;
  800f40:	e9 ce 00 00 00       	jmp    801013 <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  800f45:	83 ec 08             	sub    $0x8,%esp
  800f48:	ff 75 0c             	pushl  0xc(%ebp)
  800f4b:	6a 30                	push   $0x30
  800f4d:	8b 45 08             	mov    0x8(%ebp),%eax
  800f50:	ff d0                	call   *%eax
  800f52:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800f55:	83 ec 08             	sub    $0x8,%esp
  800f58:	ff 75 0c             	pushl  0xc(%ebp)
  800f5b:	6a 78                	push   $0x78
  800f5d:	8b 45 08             	mov    0x8(%ebp),%eax
  800f60:	ff d0                	call   *%eax
  800f62:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800f65:	8b 45 14             	mov    0x14(%ebp),%eax
  800f68:	83 c0 04             	add    $0x4,%eax
  800f6b:	89 45 14             	mov    %eax,0x14(%ebp)
  800f6e:	8b 45 14             	mov    0x14(%ebp),%eax
  800f71:	83 e8 04             	sub    $0x4,%eax
  800f74:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800f76:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800f79:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800f80:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800f87:	eb 1f                	jmp    800fa8 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800f89:	83 ec 08             	sub    $0x8,%esp
  800f8c:	ff 75 e8             	pushl  -0x18(%ebp)
  800f8f:	8d 45 14             	lea    0x14(%ebp),%eax
  800f92:	50                   	push   %eax
  800f93:	e8 e7 fb ff ff       	call   800b7f <getuint>
  800f98:	83 c4 10             	add    $0x10,%esp
  800f9b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800f9e:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800fa1:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800fa8:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800fac:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800faf:	83 ec 04             	sub    $0x4,%esp
  800fb2:	52                   	push   %edx
  800fb3:	ff 75 e4             	pushl  -0x1c(%ebp)
  800fb6:	50                   	push   %eax
  800fb7:	ff 75 f4             	pushl  -0xc(%ebp)
  800fba:	ff 75 f0             	pushl  -0x10(%ebp)
  800fbd:	ff 75 0c             	pushl  0xc(%ebp)
  800fc0:	ff 75 08             	pushl  0x8(%ebp)
  800fc3:	e8 00 fb ff ff       	call   800ac8 <printnum>
  800fc8:	83 c4 20             	add    $0x20,%esp
			break;
  800fcb:	eb 46                	jmp    801013 <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800fcd:	83 ec 08             	sub    $0x8,%esp
  800fd0:	ff 75 0c             	pushl  0xc(%ebp)
  800fd3:	53                   	push   %ebx
  800fd4:	8b 45 08             	mov    0x8(%ebp),%eax
  800fd7:	ff d0                	call   *%eax
  800fd9:	83 c4 10             	add    $0x10,%esp
			break;
  800fdc:	eb 35                	jmp    801013 <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  800fde:	c6 05 44 40 80 00 00 	movb   $0x0,0x804044
			break;
  800fe5:	eb 2c                	jmp    801013 <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  800fe7:	c6 05 44 40 80 00 01 	movb   $0x1,0x804044
			break;
  800fee:	eb 23                	jmp    801013 <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800ff0:	83 ec 08             	sub    $0x8,%esp
  800ff3:	ff 75 0c             	pushl  0xc(%ebp)
  800ff6:	6a 25                	push   $0x25
  800ff8:	8b 45 08             	mov    0x8(%ebp),%eax
  800ffb:	ff d0                	call   *%eax
  800ffd:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  801000:	ff 4d 10             	decl   0x10(%ebp)
  801003:	eb 03                	jmp    801008 <vprintfmt+0x3c3>
  801005:	ff 4d 10             	decl   0x10(%ebp)
  801008:	8b 45 10             	mov    0x10(%ebp),%eax
  80100b:	48                   	dec    %eax
  80100c:	8a 00                	mov    (%eax),%al
  80100e:	3c 25                	cmp    $0x25,%al
  801010:	75 f3                	jne    801005 <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  801012:	90                   	nop
		}
	}
  801013:	e9 35 fc ff ff       	jmp    800c4d <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  801018:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  801019:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80101c:	5b                   	pop    %ebx
  80101d:	5e                   	pop    %esi
  80101e:	5d                   	pop    %ebp
  80101f:	c3                   	ret    

00801020 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  801020:	55                   	push   %ebp
  801021:	89 e5                	mov    %esp,%ebp
  801023:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  801026:	8d 45 10             	lea    0x10(%ebp),%eax
  801029:	83 c0 04             	add    $0x4,%eax
  80102c:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  80102f:	8b 45 10             	mov    0x10(%ebp),%eax
  801032:	ff 75 f4             	pushl  -0xc(%ebp)
  801035:	50                   	push   %eax
  801036:	ff 75 0c             	pushl  0xc(%ebp)
  801039:	ff 75 08             	pushl  0x8(%ebp)
  80103c:	e8 04 fc ff ff       	call   800c45 <vprintfmt>
  801041:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  801044:	90                   	nop
  801045:	c9                   	leave  
  801046:	c3                   	ret    

00801047 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  801047:	55                   	push   %ebp
  801048:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  80104a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80104d:	8b 40 08             	mov    0x8(%eax),%eax
  801050:	8d 50 01             	lea    0x1(%eax),%edx
  801053:	8b 45 0c             	mov    0xc(%ebp),%eax
  801056:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  801059:	8b 45 0c             	mov    0xc(%ebp),%eax
  80105c:	8b 10                	mov    (%eax),%edx
  80105e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801061:	8b 40 04             	mov    0x4(%eax),%eax
  801064:	39 c2                	cmp    %eax,%edx
  801066:	73 12                	jae    80107a <sprintputch+0x33>
		*b->buf++ = ch;
  801068:	8b 45 0c             	mov    0xc(%ebp),%eax
  80106b:	8b 00                	mov    (%eax),%eax
  80106d:	8d 48 01             	lea    0x1(%eax),%ecx
  801070:	8b 55 0c             	mov    0xc(%ebp),%edx
  801073:	89 0a                	mov    %ecx,(%edx)
  801075:	8b 55 08             	mov    0x8(%ebp),%edx
  801078:	88 10                	mov    %dl,(%eax)
}
  80107a:	90                   	nop
  80107b:	5d                   	pop    %ebp
  80107c:	c3                   	ret    

0080107d <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  80107d:	55                   	push   %ebp
  80107e:	89 e5                	mov    %esp,%ebp
  801080:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  801083:	8b 45 08             	mov    0x8(%ebp),%eax
  801086:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801089:	8b 45 0c             	mov    0xc(%ebp),%eax
  80108c:	8d 50 ff             	lea    -0x1(%eax),%edx
  80108f:	8b 45 08             	mov    0x8(%ebp),%eax
  801092:	01 d0                	add    %edx,%eax
  801094:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801097:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  80109e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8010a2:	74 06                	je     8010aa <vsnprintf+0x2d>
  8010a4:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8010a8:	7f 07                	jg     8010b1 <vsnprintf+0x34>
		return -E_INVAL;
  8010aa:	b8 03 00 00 00       	mov    $0x3,%eax
  8010af:	eb 20                	jmp    8010d1 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8010b1:	ff 75 14             	pushl  0x14(%ebp)
  8010b4:	ff 75 10             	pushl  0x10(%ebp)
  8010b7:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8010ba:	50                   	push   %eax
  8010bb:	68 47 10 80 00       	push   $0x801047
  8010c0:	e8 80 fb ff ff       	call   800c45 <vprintfmt>
  8010c5:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  8010c8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8010cb:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8010ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  8010d1:	c9                   	leave  
  8010d2:	c3                   	ret    

008010d3 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8010d3:	55                   	push   %ebp
  8010d4:	89 e5                	mov    %esp,%ebp
  8010d6:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8010d9:	8d 45 10             	lea    0x10(%ebp),%eax
  8010dc:	83 c0 04             	add    $0x4,%eax
  8010df:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  8010e2:	8b 45 10             	mov    0x10(%ebp),%eax
  8010e5:	ff 75 f4             	pushl  -0xc(%ebp)
  8010e8:	50                   	push   %eax
  8010e9:	ff 75 0c             	pushl  0xc(%ebp)
  8010ec:	ff 75 08             	pushl  0x8(%ebp)
  8010ef:	e8 89 ff ff ff       	call   80107d <vsnprintf>
  8010f4:	83 c4 10             	add    $0x10,%esp
  8010f7:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  8010fa:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8010fd:	c9                   	leave  
  8010fe:	c3                   	ret    

008010ff <readline>:
#include <inc/lib.h>

//static char buf[BUFLEN];

void readline(const char *prompt, char* buf)
{
  8010ff:	55                   	push   %ebp
  801100:	89 e5                	mov    %esp,%ebp
  801102:	83 ec 18             	sub    $0x18,%esp
	int i, c, echoing;

	if (prompt != NULL)
  801105:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801109:	74 13                	je     80111e <readline+0x1f>
		cprintf("%s", prompt);
  80110b:	83 ec 08             	sub    $0x8,%esp
  80110e:	ff 75 08             	pushl  0x8(%ebp)
  801111:	68 48 37 80 00       	push   $0x803748
  801116:	e8 0b f9 ff ff       	call   800a26 <cprintf>
  80111b:	83 c4 10             	add    $0x10,%esp

	i = 0;
  80111e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	echoing = iscons(0);
  801125:	83 ec 0c             	sub    $0xc,%esp
  801128:	6a 00                	push   $0x0
  80112a:	e8 5a f4 ff ff       	call   800589 <iscons>
  80112f:	83 c4 10             	add    $0x10,%esp
  801132:	89 45 f0             	mov    %eax,-0x10(%ebp)
	while (1) {
		c = getchar();
  801135:	e8 3c f4 ff ff       	call   800576 <getchar>
  80113a:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if (c < 0) {
  80113d:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801141:	79 22                	jns    801165 <readline+0x66>
			if (c != -E_EOF)
  801143:	83 7d ec 07          	cmpl   $0x7,-0x14(%ebp)
  801147:	0f 84 ad 00 00 00    	je     8011fa <readline+0xfb>
				cprintf("read error: %e\n", c);
  80114d:	83 ec 08             	sub    $0x8,%esp
  801150:	ff 75 ec             	pushl  -0x14(%ebp)
  801153:	68 4b 37 80 00       	push   $0x80374b
  801158:	e8 c9 f8 ff ff       	call   800a26 <cprintf>
  80115d:	83 c4 10             	add    $0x10,%esp
			break;
  801160:	e9 95 00 00 00       	jmp    8011fa <readline+0xfb>
		} else if (c >= ' ' && i < BUFLEN-1) {
  801165:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%ebp)
  801169:	7e 34                	jle    80119f <readline+0xa0>
  80116b:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  801172:	7f 2b                	jg     80119f <readline+0xa0>
			if (echoing)
  801174:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801178:	74 0e                	je     801188 <readline+0x89>
				cputchar(c);
  80117a:	83 ec 0c             	sub    $0xc,%esp
  80117d:	ff 75 ec             	pushl  -0x14(%ebp)
  801180:	e8 d2 f3 ff ff       	call   800557 <cputchar>
  801185:	83 c4 10             	add    $0x10,%esp
			buf[i++] = c;
  801188:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80118b:	8d 50 01             	lea    0x1(%eax),%edx
  80118e:	89 55 f4             	mov    %edx,-0xc(%ebp)
  801191:	89 c2                	mov    %eax,%edx
  801193:	8b 45 0c             	mov    0xc(%ebp),%eax
  801196:	01 d0                	add    %edx,%eax
  801198:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80119b:	88 10                	mov    %dl,(%eax)
  80119d:	eb 56                	jmp    8011f5 <readline+0xf6>
		} else if (c == '\b' && i > 0) {
  80119f:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  8011a3:	75 1f                	jne    8011c4 <readline+0xc5>
  8011a5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8011a9:	7e 19                	jle    8011c4 <readline+0xc5>
			if (echoing)
  8011ab:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8011af:	74 0e                	je     8011bf <readline+0xc0>
				cputchar(c);
  8011b1:	83 ec 0c             	sub    $0xc,%esp
  8011b4:	ff 75 ec             	pushl  -0x14(%ebp)
  8011b7:	e8 9b f3 ff ff       	call   800557 <cputchar>
  8011bc:	83 c4 10             	add    $0x10,%esp

			i--;
  8011bf:	ff 4d f4             	decl   -0xc(%ebp)
  8011c2:	eb 31                	jmp    8011f5 <readline+0xf6>
		} else if (c == '\n' || c == '\r') {
  8011c4:	83 7d ec 0a          	cmpl   $0xa,-0x14(%ebp)
  8011c8:	74 0a                	je     8011d4 <readline+0xd5>
  8011ca:	83 7d ec 0d          	cmpl   $0xd,-0x14(%ebp)
  8011ce:	0f 85 61 ff ff ff    	jne    801135 <readline+0x36>
			if (echoing)
  8011d4:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8011d8:	74 0e                	je     8011e8 <readline+0xe9>
				cputchar(c);
  8011da:	83 ec 0c             	sub    $0xc,%esp
  8011dd:	ff 75 ec             	pushl  -0x14(%ebp)
  8011e0:	e8 72 f3 ff ff       	call   800557 <cputchar>
  8011e5:	83 c4 10             	add    $0x10,%esp

			buf[i] = 0;
  8011e8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8011eb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011ee:	01 d0                	add    %edx,%eax
  8011f0:	c6 00 00             	movb   $0x0,(%eax)
			break;
  8011f3:	eb 06                	jmp    8011fb <readline+0xfc>
		}
	}
  8011f5:	e9 3b ff ff ff       	jmp    801135 <readline+0x36>
	while (1) {
		c = getchar();
		if (c < 0) {
			if (c != -E_EOF)
				cprintf("read error: %e\n", c);
			break;
  8011fa:	90                   	nop

			buf[i] = 0;
			break;
		}
	}
}
  8011fb:	90                   	nop
  8011fc:	c9                   	leave  
  8011fd:	c3                   	ret    

008011fe <atomic_readline>:

void atomic_readline(const char *prompt, char* buf)
{
  8011fe:	55                   	push   %ebp
  8011ff:	89 e5                	mov    %esp,%ebp
  801201:	83 ec 18             	sub    $0x18,%esp
	sys_lock_cons();
  801204:	e8 30 0b 00 00       	call   801d39 <sys_lock_cons>
	{
		int i, c, echoing;

		if (prompt != NULL)
  801209:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80120d:	74 13                	je     801222 <atomic_readline+0x24>
			cprintf("%s", prompt);
  80120f:	83 ec 08             	sub    $0x8,%esp
  801212:	ff 75 08             	pushl  0x8(%ebp)
  801215:	68 48 37 80 00       	push   $0x803748
  80121a:	e8 07 f8 ff ff       	call   800a26 <cprintf>
  80121f:	83 c4 10             	add    $0x10,%esp

		i = 0;
  801222:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
		echoing = iscons(0);
  801229:	83 ec 0c             	sub    $0xc,%esp
  80122c:	6a 00                	push   $0x0
  80122e:	e8 56 f3 ff ff       	call   800589 <iscons>
  801233:	83 c4 10             	add    $0x10,%esp
  801236:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (1) {
			c = getchar();
  801239:	e8 38 f3 ff ff       	call   800576 <getchar>
  80123e:	89 45 ec             	mov    %eax,-0x14(%ebp)
			if (c < 0) {
  801241:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801245:	79 22                	jns    801269 <atomic_readline+0x6b>
				if (c != -E_EOF)
  801247:	83 7d ec 07          	cmpl   $0x7,-0x14(%ebp)
  80124b:	0f 84 ad 00 00 00    	je     8012fe <atomic_readline+0x100>
					cprintf("read error: %e\n", c);
  801251:	83 ec 08             	sub    $0x8,%esp
  801254:	ff 75 ec             	pushl  -0x14(%ebp)
  801257:	68 4b 37 80 00       	push   $0x80374b
  80125c:	e8 c5 f7 ff ff       	call   800a26 <cprintf>
  801261:	83 c4 10             	add    $0x10,%esp
				break;
  801264:	e9 95 00 00 00       	jmp    8012fe <atomic_readline+0x100>
			} else if (c >= ' ' && i < BUFLEN-1) {
  801269:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%ebp)
  80126d:	7e 34                	jle    8012a3 <atomic_readline+0xa5>
  80126f:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  801276:	7f 2b                	jg     8012a3 <atomic_readline+0xa5>
				if (echoing)
  801278:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80127c:	74 0e                	je     80128c <atomic_readline+0x8e>
					cputchar(c);
  80127e:	83 ec 0c             	sub    $0xc,%esp
  801281:	ff 75 ec             	pushl  -0x14(%ebp)
  801284:	e8 ce f2 ff ff       	call   800557 <cputchar>
  801289:	83 c4 10             	add    $0x10,%esp
				buf[i++] = c;
  80128c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80128f:	8d 50 01             	lea    0x1(%eax),%edx
  801292:	89 55 f4             	mov    %edx,-0xc(%ebp)
  801295:	89 c2                	mov    %eax,%edx
  801297:	8b 45 0c             	mov    0xc(%ebp),%eax
  80129a:	01 d0                	add    %edx,%eax
  80129c:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80129f:	88 10                	mov    %dl,(%eax)
  8012a1:	eb 56                	jmp    8012f9 <atomic_readline+0xfb>
			} else if (c == '\b' && i > 0) {
  8012a3:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  8012a7:	75 1f                	jne    8012c8 <atomic_readline+0xca>
  8012a9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8012ad:	7e 19                	jle    8012c8 <atomic_readline+0xca>
				if (echoing)
  8012af:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8012b3:	74 0e                	je     8012c3 <atomic_readline+0xc5>
					cputchar(c);
  8012b5:	83 ec 0c             	sub    $0xc,%esp
  8012b8:	ff 75 ec             	pushl  -0x14(%ebp)
  8012bb:	e8 97 f2 ff ff       	call   800557 <cputchar>
  8012c0:	83 c4 10             	add    $0x10,%esp
				i--;
  8012c3:	ff 4d f4             	decl   -0xc(%ebp)
  8012c6:	eb 31                	jmp    8012f9 <atomic_readline+0xfb>
			} else if (c == '\n' || c == '\r') {
  8012c8:	83 7d ec 0a          	cmpl   $0xa,-0x14(%ebp)
  8012cc:	74 0a                	je     8012d8 <atomic_readline+0xda>
  8012ce:	83 7d ec 0d          	cmpl   $0xd,-0x14(%ebp)
  8012d2:	0f 85 61 ff ff ff    	jne    801239 <atomic_readline+0x3b>
				if (echoing)
  8012d8:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8012dc:	74 0e                	je     8012ec <atomic_readline+0xee>
					cputchar(c);
  8012de:	83 ec 0c             	sub    $0xc,%esp
  8012e1:	ff 75 ec             	pushl  -0x14(%ebp)
  8012e4:	e8 6e f2 ff ff       	call   800557 <cputchar>
  8012e9:	83 c4 10             	add    $0x10,%esp
				buf[i] = 0;
  8012ec:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8012ef:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012f2:	01 d0                	add    %edx,%eax
  8012f4:	c6 00 00             	movb   $0x0,(%eax)
				break;
  8012f7:	eb 06                	jmp    8012ff <atomic_readline+0x101>
			}
		}
  8012f9:	e9 3b ff ff ff       	jmp    801239 <atomic_readline+0x3b>
		while (1) {
			c = getchar();
			if (c < 0) {
				if (c != -E_EOF)
					cprintf("read error: %e\n", c);
				break;
  8012fe:	90                   	nop
				buf[i] = 0;
				break;
			}
		}
	}
	sys_unlock_cons();
  8012ff:	e8 4f 0a 00 00       	call   801d53 <sys_unlock_cons>
}
  801304:	90                   	nop
  801305:	c9                   	leave  
  801306:	c3                   	ret    

00801307 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  801307:	55                   	push   %ebp
  801308:	89 e5                	mov    %esp,%ebp
  80130a:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  80130d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801314:	eb 06                	jmp    80131c <strlen+0x15>
		n++;
  801316:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  801319:	ff 45 08             	incl   0x8(%ebp)
  80131c:	8b 45 08             	mov    0x8(%ebp),%eax
  80131f:	8a 00                	mov    (%eax),%al
  801321:	84 c0                	test   %al,%al
  801323:	75 f1                	jne    801316 <strlen+0xf>
		n++;
	return n;
  801325:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801328:	c9                   	leave  
  801329:	c3                   	ret    

0080132a <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  80132a:	55                   	push   %ebp
  80132b:	89 e5                	mov    %esp,%ebp
  80132d:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801330:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801337:	eb 09                	jmp    801342 <strnlen+0x18>
		n++;
  801339:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80133c:	ff 45 08             	incl   0x8(%ebp)
  80133f:	ff 4d 0c             	decl   0xc(%ebp)
  801342:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801346:	74 09                	je     801351 <strnlen+0x27>
  801348:	8b 45 08             	mov    0x8(%ebp),%eax
  80134b:	8a 00                	mov    (%eax),%al
  80134d:	84 c0                	test   %al,%al
  80134f:	75 e8                	jne    801339 <strnlen+0xf>
		n++;
	return n;
  801351:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801354:	c9                   	leave  
  801355:	c3                   	ret    

00801356 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  801356:	55                   	push   %ebp
  801357:	89 e5                	mov    %esp,%ebp
  801359:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  80135c:	8b 45 08             	mov    0x8(%ebp),%eax
  80135f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  801362:	90                   	nop
  801363:	8b 45 08             	mov    0x8(%ebp),%eax
  801366:	8d 50 01             	lea    0x1(%eax),%edx
  801369:	89 55 08             	mov    %edx,0x8(%ebp)
  80136c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80136f:	8d 4a 01             	lea    0x1(%edx),%ecx
  801372:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  801375:	8a 12                	mov    (%edx),%dl
  801377:	88 10                	mov    %dl,(%eax)
  801379:	8a 00                	mov    (%eax),%al
  80137b:	84 c0                	test   %al,%al
  80137d:	75 e4                	jne    801363 <strcpy+0xd>
		/* do nothing */;
	return ret;
  80137f:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801382:	c9                   	leave  
  801383:	c3                   	ret    

00801384 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  801384:	55                   	push   %ebp
  801385:	89 e5                	mov    %esp,%ebp
  801387:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  80138a:	8b 45 08             	mov    0x8(%ebp),%eax
  80138d:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  801390:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801397:	eb 1f                	jmp    8013b8 <strncpy+0x34>
		*dst++ = *src;
  801399:	8b 45 08             	mov    0x8(%ebp),%eax
  80139c:	8d 50 01             	lea    0x1(%eax),%edx
  80139f:	89 55 08             	mov    %edx,0x8(%ebp)
  8013a2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8013a5:	8a 12                	mov    (%edx),%dl
  8013a7:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  8013a9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013ac:	8a 00                	mov    (%eax),%al
  8013ae:	84 c0                	test   %al,%al
  8013b0:	74 03                	je     8013b5 <strncpy+0x31>
			src++;
  8013b2:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8013b5:	ff 45 fc             	incl   -0x4(%ebp)
  8013b8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8013bb:	3b 45 10             	cmp    0x10(%ebp),%eax
  8013be:	72 d9                	jb     801399 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  8013c0:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8013c3:	c9                   	leave  
  8013c4:	c3                   	ret    

008013c5 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  8013c5:	55                   	push   %ebp
  8013c6:	89 e5                	mov    %esp,%ebp
  8013c8:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  8013cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8013ce:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  8013d1:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8013d5:	74 30                	je     801407 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  8013d7:	eb 16                	jmp    8013ef <strlcpy+0x2a>
			*dst++ = *src++;
  8013d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8013dc:	8d 50 01             	lea    0x1(%eax),%edx
  8013df:	89 55 08             	mov    %edx,0x8(%ebp)
  8013e2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8013e5:	8d 4a 01             	lea    0x1(%edx),%ecx
  8013e8:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  8013eb:	8a 12                	mov    (%edx),%dl
  8013ed:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  8013ef:	ff 4d 10             	decl   0x10(%ebp)
  8013f2:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8013f6:	74 09                	je     801401 <strlcpy+0x3c>
  8013f8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013fb:	8a 00                	mov    (%eax),%al
  8013fd:	84 c0                	test   %al,%al
  8013ff:	75 d8                	jne    8013d9 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  801401:	8b 45 08             	mov    0x8(%ebp),%eax
  801404:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  801407:	8b 55 08             	mov    0x8(%ebp),%edx
  80140a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80140d:	29 c2                	sub    %eax,%edx
  80140f:	89 d0                	mov    %edx,%eax
}
  801411:	c9                   	leave  
  801412:	c3                   	ret    

00801413 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  801413:	55                   	push   %ebp
  801414:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  801416:	eb 06                	jmp    80141e <strcmp+0xb>
		p++, q++;
  801418:	ff 45 08             	incl   0x8(%ebp)
  80141b:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  80141e:	8b 45 08             	mov    0x8(%ebp),%eax
  801421:	8a 00                	mov    (%eax),%al
  801423:	84 c0                	test   %al,%al
  801425:	74 0e                	je     801435 <strcmp+0x22>
  801427:	8b 45 08             	mov    0x8(%ebp),%eax
  80142a:	8a 10                	mov    (%eax),%dl
  80142c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80142f:	8a 00                	mov    (%eax),%al
  801431:	38 c2                	cmp    %al,%dl
  801433:	74 e3                	je     801418 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  801435:	8b 45 08             	mov    0x8(%ebp),%eax
  801438:	8a 00                	mov    (%eax),%al
  80143a:	0f b6 d0             	movzbl %al,%edx
  80143d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801440:	8a 00                	mov    (%eax),%al
  801442:	0f b6 c0             	movzbl %al,%eax
  801445:	29 c2                	sub    %eax,%edx
  801447:	89 d0                	mov    %edx,%eax
}
  801449:	5d                   	pop    %ebp
  80144a:	c3                   	ret    

0080144b <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  80144b:	55                   	push   %ebp
  80144c:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  80144e:	eb 09                	jmp    801459 <strncmp+0xe>
		n--, p++, q++;
  801450:	ff 4d 10             	decl   0x10(%ebp)
  801453:	ff 45 08             	incl   0x8(%ebp)
  801456:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  801459:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80145d:	74 17                	je     801476 <strncmp+0x2b>
  80145f:	8b 45 08             	mov    0x8(%ebp),%eax
  801462:	8a 00                	mov    (%eax),%al
  801464:	84 c0                	test   %al,%al
  801466:	74 0e                	je     801476 <strncmp+0x2b>
  801468:	8b 45 08             	mov    0x8(%ebp),%eax
  80146b:	8a 10                	mov    (%eax),%dl
  80146d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801470:	8a 00                	mov    (%eax),%al
  801472:	38 c2                	cmp    %al,%dl
  801474:	74 da                	je     801450 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  801476:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80147a:	75 07                	jne    801483 <strncmp+0x38>
		return 0;
  80147c:	b8 00 00 00 00       	mov    $0x0,%eax
  801481:	eb 14                	jmp    801497 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  801483:	8b 45 08             	mov    0x8(%ebp),%eax
  801486:	8a 00                	mov    (%eax),%al
  801488:	0f b6 d0             	movzbl %al,%edx
  80148b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80148e:	8a 00                	mov    (%eax),%al
  801490:	0f b6 c0             	movzbl %al,%eax
  801493:	29 c2                	sub    %eax,%edx
  801495:	89 d0                	mov    %edx,%eax
}
  801497:	5d                   	pop    %ebp
  801498:	c3                   	ret    

00801499 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  801499:	55                   	push   %ebp
  80149a:	89 e5                	mov    %esp,%ebp
  80149c:	83 ec 04             	sub    $0x4,%esp
  80149f:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014a2:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  8014a5:	eb 12                	jmp    8014b9 <strchr+0x20>
		if (*s == c)
  8014a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8014aa:	8a 00                	mov    (%eax),%al
  8014ac:	3a 45 fc             	cmp    -0x4(%ebp),%al
  8014af:	75 05                	jne    8014b6 <strchr+0x1d>
			return (char *) s;
  8014b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8014b4:	eb 11                	jmp    8014c7 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  8014b6:	ff 45 08             	incl   0x8(%ebp)
  8014b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8014bc:	8a 00                	mov    (%eax),%al
  8014be:	84 c0                	test   %al,%al
  8014c0:	75 e5                	jne    8014a7 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  8014c2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8014c7:	c9                   	leave  
  8014c8:	c3                   	ret    

008014c9 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8014c9:	55                   	push   %ebp
  8014ca:	89 e5                	mov    %esp,%ebp
  8014cc:	83 ec 04             	sub    $0x4,%esp
  8014cf:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014d2:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  8014d5:	eb 0d                	jmp    8014e4 <strfind+0x1b>
		if (*s == c)
  8014d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8014da:	8a 00                	mov    (%eax),%al
  8014dc:	3a 45 fc             	cmp    -0x4(%ebp),%al
  8014df:	74 0e                	je     8014ef <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  8014e1:	ff 45 08             	incl   0x8(%ebp)
  8014e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8014e7:	8a 00                	mov    (%eax),%al
  8014e9:	84 c0                	test   %al,%al
  8014eb:	75 ea                	jne    8014d7 <strfind+0xe>
  8014ed:	eb 01                	jmp    8014f0 <strfind+0x27>
		if (*s == c)
			break;
  8014ef:	90                   	nop
	return (char *) s;
  8014f0:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8014f3:	c9                   	leave  
  8014f4:	c3                   	ret    

008014f5 <memset>:

// *************** The faster implementation of memset & memcpy is implemented by *************
// ****************** Team80 (Yahia Khaled, Malek Ahmed et al) - FCIS'24-25 *******************
void *
memset(void *v, int c, uint32 n)
{
  8014f5:	55                   	push   %ebp
  8014f6:	89 e5                	mov    %esp,%ebp
  8014f8:	83 ec 10             	sub    $0x10,%esp
//	m = n;
//	while (--m >= 0)
//		*p++ = c;

	/*Faster Implementation*/
	uint64* p64 = (uint64*)v;
  8014fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8014fe:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if(n >= 8){
  801501:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  801505:	76 63                	jbe    80156a <memset+0x75>
		uint64 data_block = c;
  801507:	8b 45 0c             	mov    0xc(%ebp),%eax
  80150a:	99                   	cltd   
  80150b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80150e:	89 55 f4             	mov    %edx,-0xc(%ebp)
		data_block |= data_block << 8;
  801511:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801514:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801517:	0f a4 c2 08          	shld   $0x8,%eax,%edx
  80151b:	c1 e0 08             	shl    $0x8,%eax
  80151e:	09 45 f0             	or     %eax,-0x10(%ebp)
  801521:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 16;
  801524:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801527:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80152a:	0f a4 c2 10          	shld   $0x10,%eax,%edx
  80152e:	c1 e0 10             	shl    $0x10,%eax
  801531:	09 45 f0             	or     %eax,-0x10(%ebp)
  801534:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 32;
  801537:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80153a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80153d:	89 c2                	mov    %eax,%edx
  80153f:	b8 00 00 00 00       	mov    $0x0,%eax
  801544:	09 45 f0             	or     %eax,-0x10(%ebp)
  801547:	09 55 f4             	or     %edx,-0xc(%ebp)

		while(n >= 8)
  80154a:	eb 18                	jmp    801564 <memset+0x6f>
			*p64++ = data_block, n -= 8;
  80154c:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  80154f:	8d 41 08             	lea    0x8(%ecx),%eax
  801552:	89 45 fc             	mov    %eax,-0x4(%ebp)
  801555:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801558:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80155b:	89 01                	mov    %eax,(%ecx)
  80155d:	89 51 04             	mov    %edx,0x4(%ecx)
  801560:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
		uint64 data_block = c;
		data_block |= data_block << 8;
		data_block |= data_block << 16;
		data_block |= data_block << 32;

		while(n >= 8)
  801564:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  801568:	77 e2                	ja     80154c <memset+0x57>
			*p64++ = data_block, n -= 8;
	}

	if(n){
  80156a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80156e:	74 23                	je     801593 <memset+0x9e>
		uint8* p8 = (uint8*)p64;
  801570:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801573:	89 45 f8             	mov    %eax,-0x8(%ebp)
		while (n-- > 0)
  801576:	eb 0e                	jmp    801586 <memset+0x91>
			*p8++ = (uint8)c;
  801578:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80157b:	8d 50 01             	lea    0x1(%eax),%edx
  80157e:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801581:	8b 55 0c             	mov    0xc(%ebp),%edx
  801584:	88 10                	mov    %dl,(%eax)
			*p64++ = data_block, n -= 8;
	}

	if(n){
		uint8* p8 = (uint8*)p64;
		while (n-- > 0)
  801586:	8b 45 10             	mov    0x10(%ebp),%eax
  801589:	8d 50 ff             	lea    -0x1(%eax),%edx
  80158c:	89 55 10             	mov    %edx,0x10(%ebp)
  80158f:	85 c0                	test   %eax,%eax
  801591:	75 e5                	jne    801578 <memset+0x83>
			*p8++ = (uint8)c;
	}

	return v;
  801593:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801596:	c9                   	leave  
  801597:	c3                   	ret    

00801598 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  801598:	55                   	push   %ebp
  801599:	89 e5                	mov    %esp,%ebp
  80159b:	83 ec 10             	sub    $0x10,%esp
	//	s = src;
	//	d = dst;
	//	while (n-- > 0)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
  80159e:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015a1:	89 45 fc             	mov    %eax,-0x4(%ebp)
	uint64* d64 = (uint64*)dst;
  8015a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8015a7:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if(n >= 8){
  8015aa:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  8015ae:	76 24                	jbe    8015d4 <memcpy+0x3c>
		while(n >= 8){
  8015b0:	eb 1c                	jmp    8015ce <memcpy+0x36>
			*d64 = *s64;
  8015b2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8015b5:	8b 50 04             	mov    0x4(%eax),%edx
  8015b8:	8b 00                	mov    (%eax),%eax
  8015ba:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8015bd:	89 01                	mov    %eax,(%ecx)
  8015bf:	89 51 04             	mov    %edx,0x4(%ecx)
			n -= 8;
  8015c2:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
			++s64;
  8015c6:	83 45 fc 08          	addl   $0x8,-0x4(%ebp)
			++d64;
  8015ca:	83 45 f8 08          	addl   $0x8,-0x8(%ebp)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
	uint64* d64 = (uint64*)dst;
	if(n >= 8){
		while(n >= 8){
  8015ce:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  8015d2:	77 de                	ja     8015b2 <memcpy+0x1a>
			++s64;
			++d64;
		}
	}

	if(n){
  8015d4:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8015d8:	74 31                	je     80160b <memcpy+0x73>
		uint8* s8 = (uint8*)s64;
  8015da:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8015dd:	89 45 f4             	mov    %eax,-0xc(%ebp)
		uint8* d8 = (uint8*)d64;
  8015e0:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8015e3:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (n-- > 0)
  8015e6:	eb 16                	jmp    8015fe <memcpy+0x66>
			*d8++ = *s8++;
  8015e8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015eb:	8d 50 01             	lea    0x1(%eax),%edx
  8015ee:	89 55 f0             	mov    %edx,-0x10(%ebp)
  8015f1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8015f4:	8d 4a 01             	lea    0x1(%edx),%ecx
  8015f7:	89 4d f4             	mov    %ecx,-0xc(%ebp)
  8015fa:	8a 12                	mov    (%edx),%dl
  8015fc:	88 10                	mov    %dl,(%eax)
	}

	if(n){
		uint8* s8 = (uint8*)s64;
		uint8* d8 = (uint8*)d64;
		while (n-- > 0)
  8015fe:	8b 45 10             	mov    0x10(%ebp),%eax
  801601:	8d 50 ff             	lea    -0x1(%eax),%edx
  801604:	89 55 10             	mov    %edx,0x10(%ebp)
  801607:	85 c0                	test   %eax,%eax
  801609:	75 dd                	jne    8015e8 <memcpy+0x50>
			*d8++ = *s8++;
	}
	return dst;
  80160b:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80160e:	c9                   	leave  
  80160f:	c3                   	ret    

00801610 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  801610:	55                   	push   %ebp
  801611:	89 e5                	mov    %esp,%ebp
  801613:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801616:	8b 45 0c             	mov    0xc(%ebp),%eax
  801619:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  80161c:	8b 45 08             	mov    0x8(%ebp),%eax
  80161f:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  801622:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801625:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801628:	73 50                	jae    80167a <memmove+0x6a>
  80162a:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80162d:	8b 45 10             	mov    0x10(%ebp),%eax
  801630:	01 d0                	add    %edx,%eax
  801632:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801635:	76 43                	jbe    80167a <memmove+0x6a>
		s += n;
  801637:	8b 45 10             	mov    0x10(%ebp),%eax
  80163a:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  80163d:	8b 45 10             	mov    0x10(%ebp),%eax
  801640:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  801643:	eb 10                	jmp    801655 <memmove+0x45>
			*--d = *--s;
  801645:	ff 4d f8             	decl   -0x8(%ebp)
  801648:	ff 4d fc             	decl   -0x4(%ebp)
  80164b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80164e:	8a 10                	mov    (%eax),%dl
  801650:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801653:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  801655:	8b 45 10             	mov    0x10(%ebp),%eax
  801658:	8d 50 ff             	lea    -0x1(%eax),%edx
  80165b:	89 55 10             	mov    %edx,0x10(%ebp)
  80165e:	85 c0                	test   %eax,%eax
  801660:	75 e3                	jne    801645 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  801662:	eb 23                	jmp    801687 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  801664:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801667:	8d 50 01             	lea    0x1(%eax),%edx
  80166a:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80166d:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801670:	8d 4a 01             	lea    0x1(%edx),%ecx
  801673:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801676:	8a 12                	mov    (%edx),%dl
  801678:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  80167a:	8b 45 10             	mov    0x10(%ebp),%eax
  80167d:	8d 50 ff             	lea    -0x1(%eax),%edx
  801680:	89 55 10             	mov    %edx,0x10(%ebp)
  801683:	85 c0                	test   %eax,%eax
  801685:	75 dd                	jne    801664 <memmove+0x54>
			*d++ = *s++;

	return dst;
  801687:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80168a:	c9                   	leave  
  80168b:	c3                   	ret    

0080168c <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  80168c:	55                   	push   %ebp
  80168d:	89 e5                	mov    %esp,%ebp
  80168f:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  801692:	8b 45 08             	mov    0x8(%ebp),%eax
  801695:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  801698:	8b 45 0c             	mov    0xc(%ebp),%eax
  80169b:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  80169e:	eb 2a                	jmp    8016ca <memcmp+0x3e>
		if (*s1 != *s2)
  8016a0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8016a3:	8a 10                	mov    (%eax),%dl
  8016a5:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8016a8:	8a 00                	mov    (%eax),%al
  8016aa:	38 c2                	cmp    %al,%dl
  8016ac:	74 16                	je     8016c4 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  8016ae:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8016b1:	8a 00                	mov    (%eax),%al
  8016b3:	0f b6 d0             	movzbl %al,%edx
  8016b6:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8016b9:	8a 00                	mov    (%eax),%al
  8016bb:	0f b6 c0             	movzbl %al,%eax
  8016be:	29 c2                	sub    %eax,%edx
  8016c0:	89 d0                	mov    %edx,%eax
  8016c2:	eb 18                	jmp    8016dc <memcmp+0x50>
		s1++, s2++;
  8016c4:	ff 45 fc             	incl   -0x4(%ebp)
  8016c7:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  8016ca:	8b 45 10             	mov    0x10(%ebp),%eax
  8016cd:	8d 50 ff             	lea    -0x1(%eax),%edx
  8016d0:	89 55 10             	mov    %edx,0x10(%ebp)
  8016d3:	85 c0                	test   %eax,%eax
  8016d5:	75 c9                	jne    8016a0 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  8016d7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8016dc:	c9                   	leave  
  8016dd:	c3                   	ret    

008016de <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  8016de:	55                   	push   %ebp
  8016df:	89 e5                	mov    %esp,%ebp
  8016e1:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  8016e4:	8b 55 08             	mov    0x8(%ebp),%edx
  8016e7:	8b 45 10             	mov    0x10(%ebp),%eax
  8016ea:	01 d0                	add    %edx,%eax
  8016ec:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  8016ef:	eb 15                	jmp    801706 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  8016f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8016f4:	8a 00                	mov    (%eax),%al
  8016f6:	0f b6 d0             	movzbl %al,%edx
  8016f9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016fc:	0f b6 c0             	movzbl %al,%eax
  8016ff:	39 c2                	cmp    %eax,%edx
  801701:	74 0d                	je     801710 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801703:	ff 45 08             	incl   0x8(%ebp)
  801706:	8b 45 08             	mov    0x8(%ebp),%eax
  801709:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  80170c:	72 e3                	jb     8016f1 <memfind+0x13>
  80170e:	eb 01                	jmp    801711 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  801710:	90                   	nop
	return (void *) s;
  801711:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801714:	c9                   	leave  
  801715:	c3                   	ret    

00801716 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801716:	55                   	push   %ebp
  801717:	89 e5                	mov    %esp,%ebp
  801719:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  80171c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  801723:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80172a:	eb 03                	jmp    80172f <strtol+0x19>
		s++;
  80172c:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80172f:	8b 45 08             	mov    0x8(%ebp),%eax
  801732:	8a 00                	mov    (%eax),%al
  801734:	3c 20                	cmp    $0x20,%al
  801736:	74 f4                	je     80172c <strtol+0x16>
  801738:	8b 45 08             	mov    0x8(%ebp),%eax
  80173b:	8a 00                	mov    (%eax),%al
  80173d:	3c 09                	cmp    $0x9,%al
  80173f:	74 eb                	je     80172c <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  801741:	8b 45 08             	mov    0x8(%ebp),%eax
  801744:	8a 00                	mov    (%eax),%al
  801746:	3c 2b                	cmp    $0x2b,%al
  801748:	75 05                	jne    80174f <strtol+0x39>
		s++;
  80174a:	ff 45 08             	incl   0x8(%ebp)
  80174d:	eb 13                	jmp    801762 <strtol+0x4c>
	else if (*s == '-')
  80174f:	8b 45 08             	mov    0x8(%ebp),%eax
  801752:	8a 00                	mov    (%eax),%al
  801754:	3c 2d                	cmp    $0x2d,%al
  801756:	75 0a                	jne    801762 <strtol+0x4c>
		s++, neg = 1;
  801758:	ff 45 08             	incl   0x8(%ebp)
  80175b:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801762:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801766:	74 06                	je     80176e <strtol+0x58>
  801768:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  80176c:	75 20                	jne    80178e <strtol+0x78>
  80176e:	8b 45 08             	mov    0x8(%ebp),%eax
  801771:	8a 00                	mov    (%eax),%al
  801773:	3c 30                	cmp    $0x30,%al
  801775:	75 17                	jne    80178e <strtol+0x78>
  801777:	8b 45 08             	mov    0x8(%ebp),%eax
  80177a:	40                   	inc    %eax
  80177b:	8a 00                	mov    (%eax),%al
  80177d:	3c 78                	cmp    $0x78,%al
  80177f:	75 0d                	jne    80178e <strtol+0x78>
		s += 2, base = 16;
  801781:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  801785:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  80178c:	eb 28                	jmp    8017b6 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  80178e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801792:	75 15                	jne    8017a9 <strtol+0x93>
  801794:	8b 45 08             	mov    0x8(%ebp),%eax
  801797:	8a 00                	mov    (%eax),%al
  801799:	3c 30                	cmp    $0x30,%al
  80179b:	75 0c                	jne    8017a9 <strtol+0x93>
		s++, base = 8;
  80179d:	ff 45 08             	incl   0x8(%ebp)
  8017a0:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  8017a7:	eb 0d                	jmp    8017b6 <strtol+0xa0>
	else if (base == 0)
  8017a9:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8017ad:	75 07                	jne    8017b6 <strtol+0xa0>
		base = 10;
  8017af:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8017b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8017b9:	8a 00                	mov    (%eax),%al
  8017bb:	3c 2f                	cmp    $0x2f,%al
  8017bd:	7e 19                	jle    8017d8 <strtol+0xc2>
  8017bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8017c2:	8a 00                	mov    (%eax),%al
  8017c4:	3c 39                	cmp    $0x39,%al
  8017c6:	7f 10                	jg     8017d8 <strtol+0xc2>
			dig = *s - '0';
  8017c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8017cb:	8a 00                	mov    (%eax),%al
  8017cd:	0f be c0             	movsbl %al,%eax
  8017d0:	83 e8 30             	sub    $0x30,%eax
  8017d3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8017d6:	eb 42                	jmp    80181a <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  8017d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8017db:	8a 00                	mov    (%eax),%al
  8017dd:	3c 60                	cmp    $0x60,%al
  8017df:	7e 19                	jle    8017fa <strtol+0xe4>
  8017e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8017e4:	8a 00                	mov    (%eax),%al
  8017e6:	3c 7a                	cmp    $0x7a,%al
  8017e8:	7f 10                	jg     8017fa <strtol+0xe4>
			dig = *s - 'a' + 10;
  8017ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8017ed:	8a 00                	mov    (%eax),%al
  8017ef:	0f be c0             	movsbl %al,%eax
  8017f2:	83 e8 57             	sub    $0x57,%eax
  8017f5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8017f8:	eb 20                	jmp    80181a <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  8017fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8017fd:	8a 00                	mov    (%eax),%al
  8017ff:	3c 40                	cmp    $0x40,%al
  801801:	7e 39                	jle    80183c <strtol+0x126>
  801803:	8b 45 08             	mov    0x8(%ebp),%eax
  801806:	8a 00                	mov    (%eax),%al
  801808:	3c 5a                	cmp    $0x5a,%al
  80180a:	7f 30                	jg     80183c <strtol+0x126>
			dig = *s - 'A' + 10;
  80180c:	8b 45 08             	mov    0x8(%ebp),%eax
  80180f:	8a 00                	mov    (%eax),%al
  801811:	0f be c0             	movsbl %al,%eax
  801814:	83 e8 37             	sub    $0x37,%eax
  801817:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  80181a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80181d:	3b 45 10             	cmp    0x10(%ebp),%eax
  801820:	7d 19                	jge    80183b <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801822:	ff 45 08             	incl   0x8(%ebp)
  801825:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801828:	0f af 45 10          	imul   0x10(%ebp),%eax
  80182c:	89 c2                	mov    %eax,%edx
  80182e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801831:	01 d0                	add    %edx,%eax
  801833:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  801836:	e9 7b ff ff ff       	jmp    8017b6 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  80183b:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  80183c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801840:	74 08                	je     80184a <strtol+0x134>
		*endptr = (char *) s;
  801842:	8b 45 0c             	mov    0xc(%ebp),%eax
  801845:	8b 55 08             	mov    0x8(%ebp),%edx
  801848:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  80184a:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80184e:	74 07                	je     801857 <strtol+0x141>
  801850:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801853:	f7 d8                	neg    %eax
  801855:	eb 03                	jmp    80185a <strtol+0x144>
  801857:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  80185a:	c9                   	leave  
  80185b:	c3                   	ret    

0080185c <ltostr>:

void
ltostr(long value, char *str)
{
  80185c:	55                   	push   %ebp
  80185d:	89 e5                	mov    %esp,%ebp
  80185f:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  801862:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  801869:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  801870:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801874:	79 13                	jns    801889 <ltostr+0x2d>
	{
		neg = 1;
  801876:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  80187d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801880:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  801883:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  801886:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  801889:	8b 45 08             	mov    0x8(%ebp),%eax
  80188c:	b9 0a 00 00 00       	mov    $0xa,%ecx
  801891:	99                   	cltd   
  801892:	f7 f9                	idiv   %ecx
  801894:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  801897:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80189a:	8d 50 01             	lea    0x1(%eax),%edx
  80189d:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8018a0:	89 c2                	mov    %eax,%edx
  8018a2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018a5:	01 d0                	add    %edx,%eax
  8018a7:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8018aa:	83 c2 30             	add    $0x30,%edx
  8018ad:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  8018af:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8018b2:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8018b7:	f7 e9                	imul   %ecx
  8018b9:	c1 fa 02             	sar    $0x2,%edx
  8018bc:	89 c8                	mov    %ecx,%eax
  8018be:	c1 f8 1f             	sar    $0x1f,%eax
  8018c1:	29 c2                	sub    %eax,%edx
  8018c3:	89 d0                	mov    %edx,%eax
  8018c5:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  8018c8:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8018cc:	75 bb                	jne    801889 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  8018ce:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  8018d5:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8018d8:	48                   	dec    %eax
  8018d9:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  8018dc:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8018e0:	74 3d                	je     80191f <ltostr+0xc3>
		start = 1 ;
  8018e2:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  8018e9:	eb 34                	jmp    80191f <ltostr+0xc3>
	{
		char tmp = str[start] ;
  8018eb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8018ee:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018f1:	01 d0                	add    %edx,%eax
  8018f3:	8a 00                	mov    (%eax),%al
  8018f5:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  8018f8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8018fb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018fe:	01 c2                	add    %eax,%edx
  801900:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801903:	8b 45 0c             	mov    0xc(%ebp),%eax
  801906:	01 c8                	add    %ecx,%eax
  801908:	8a 00                	mov    (%eax),%al
  80190a:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  80190c:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80190f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801912:	01 c2                	add    %eax,%edx
  801914:	8a 45 eb             	mov    -0x15(%ebp),%al
  801917:	88 02                	mov    %al,(%edx)
		start++ ;
  801919:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  80191c:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  80191f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801922:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801925:	7c c4                	jl     8018eb <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801927:	8b 55 f8             	mov    -0x8(%ebp),%edx
  80192a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80192d:	01 d0                	add    %edx,%eax
  80192f:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801932:	90                   	nop
  801933:	c9                   	leave  
  801934:	c3                   	ret    

00801935 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  801935:	55                   	push   %ebp
  801936:	89 e5                	mov    %esp,%ebp
  801938:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  80193b:	ff 75 08             	pushl  0x8(%ebp)
  80193e:	e8 c4 f9 ff ff       	call   801307 <strlen>
  801943:	83 c4 04             	add    $0x4,%esp
  801946:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  801949:	ff 75 0c             	pushl  0xc(%ebp)
  80194c:	e8 b6 f9 ff ff       	call   801307 <strlen>
  801951:	83 c4 04             	add    $0x4,%esp
  801954:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  801957:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  80195e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801965:	eb 17                	jmp    80197e <strcconcat+0x49>
		final[s] = str1[s] ;
  801967:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80196a:	8b 45 10             	mov    0x10(%ebp),%eax
  80196d:	01 c2                	add    %eax,%edx
  80196f:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801972:	8b 45 08             	mov    0x8(%ebp),%eax
  801975:	01 c8                	add    %ecx,%eax
  801977:	8a 00                	mov    (%eax),%al
  801979:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  80197b:	ff 45 fc             	incl   -0x4(%ebp)
  80197e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801981:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801984:	7c e1                	jl     801967 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  801986:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  80198d:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  801994:	eb 1f                	jmp    8019b5 <strcconcat+0x80>
		final[s++] = str2[i] ;
  801996:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801999:	8d 50 01             	lea    0x1(%eax),%edx
  80199c:	89 55 fc             	mov    %edx,-0x4(%ebp)
  80199f:	89 c2                	mov    %eax,%edx
  8019a1:	8b 45 10             	mov    0x10(%ebp),%eax
  8019a4:	01 c2                	add    %eax,%edx
  8019a6:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8019a9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8019ac:	01 c8                	add    %ecx,%eax
  8019ae:	8a 00                	mov    (%eax),%al
  8019b0:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  8019b2:	ff 45 f8             	incl   -0x8(%ebp)
  8019b5:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8019b8:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8019bb:	7c d9                	jl     801996 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  8019bd:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8019c0:	8b 45 10             	mov    0x10(%ebp),%eax
  8019c3:	01 d0                	add    %edx,%eax
  8019c5:	c6 00 00             	movb   $0x0,(%eax)
}
  8019c8:	90                   	nop
  8019c9:	c9                   	leave  
  8019ca:	c3                   	ret    

008019cb <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  8019cb:	55                   	push   %ebp
  8019cc:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  8019ce:	8b 45 14             	mov    0x14(%ebp),%eax
  8019d1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  8019d7:	8b 45 14             	mov    0x14(%ebp),%eax
  8019da:	8b 00                	mov    (%eax),%eax
  8019dc:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8019e3:	8b 45 10             	mov    0x10(%ebp),%eax
  8019e6:	01 d0                	add    %edx,%eax
  8019e8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8019ee:	eb 0c                	jmp    8019fc <strsplit+0x31>
			*string++ = 0;
  8019f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8019f3:	8d 50 01             	lea    0x1(%eax),%edx
  8019f6:	89 55 08             	mov    %edx,0x8(%ebp)
  8019f9:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8019fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8019ff:	8a 00                	mov    (%eax),%al
  801a01:	84 c0                	test   %al,%al
  801a03:	74 18                	je     801a1d <strsplit+0x52>
  801a05:	8b 45 08             	mov    0x8(%ebp),%eax
  801a08:	8a 00                	mov    (%eax),%al
  801a0a:	0f be c0             	movsbl %al,%eax
  801a0d:	50                   	push   %eax
  801a0e:	ff 75 0c             	pushl  0xc(%ebp)
  801a11:	e8 83 fa ff ff       	call   801499 <strchr>
  801a16:	83 c4 08             	add    $0x8,%esp
  801a19:	85 c0                	test   %eax,%eax
  801a1b:	75 d3                	jne    8019f0 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801a1d:	8b 45 08             	mov    0x8(%ebp),%eax
  801a20:	8a 00                	mov    (%eax),%al
  801a22:	84 c0                	test   %al,%al
  801a24:	74 5a                	je     801a80 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801a26:	8b 45 14             	mov    0x14(%ebp),%eax
  801a29:	8b 00                	mov    (%eax),%eax
  801a2b:	83 f8 0f             	cmp    $0xf,%eax
  801a2e:	75 07                	jne    801a37 <strsplit+0x6c>
		{
			return 0;
  801a30:	b8 00 00 00 00       	mov    $0x0,%eax
  801a35:	eb 66                	jmp    801a9d <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801a37:	8b 45 14             	mov    0x14(%ebp),%eax
  801a3a:	8b 00                	mov    (%eax),%eax
  801a3c:	8d 48 01             	lea    0x1(%eax),%ecx
  801a3f:	8b 55 14             	mov    0x14(%ebp),%edx
  801a42:	89 0a                	mov    %ecx,(%edx)
  801a44:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801a4b:	8b 45 10             	mov    0x10(%ebp),%eax
  801a4e:	01 c2                	add    %eax,%edx
  801a50:	8b 45 08             	mov    0x8(%ebp),%eax
  801a53:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801a55:	eb 03                	jmp    801a5a <strsplit+0x8f>
			string++;
  801a57:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801a5a:	8b 45 08             	mov    0x8(%ebp),%eax
  801a5d:	8a 00                	mov    (%eax),%al
  801a5f:	84 c0                	test   %al,%al
  801a61:	74 8b                	je     8019ee <strsplit+0x23>
  801a63:	8b 45 08             	mov    0x8(%ebp),%eax
  801a66:	8a 00                	mov    (%eax),%al
  801a68:	0f be c0             	movsbl %al,%eax
  801a6b:	50                   	push   %eax
  801a6c:	ff 75 0c             	pushl  0xc(%ebp)
  801a6f:	e8 25 fa ff ff       	call   801499 <strchr>
  801a74:	83 c4 08             	add    $0x8,%esp
  801a77:	85 c0                	test   %eax,%eax
  801a79:	74 dc                	je     801a57 <strsplit+0x8c>
			string++;
	}
  801a7b:	e9 6e ff ff ff       	jmp    8019ee <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801a80:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801a81:	8b 45 14             	mov    0x14(%ebp),%eax
  801a84:	8b 00                	mov    (%eax),%eax
  801a86:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801a8d:	8b 45 10             	mov    0x10(%ebp),%eax
  801a90:	01 d0                	add    %edx,%eax
  801a92:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801a98:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801a9d:	c9                   	leave  
  801a9e:	c3                   	ret    

00801a9f <str2lower>:


char* str2lower(char *dst, const char *src)
{
  801a9f:	55                   	push   %ebp
  801aa0:	89 e5                	mov    %esp,%ebp
  801aa2:	83 ec 10             	sub    $0x10,%esp
	char* ret = dst;
  801aa5:	8b 45 08             	mov    0x8(%ebp),%eax
  801aa8:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (int i = 0; i < strlen(src); ++i)
  801aab:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801ab2:	eb 4a                	jmp    801afe <str2lower+0x5f>
	{
		dst[i] = src[i] ;
  801ab4:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801ab7:	8b 45 08             	mov    0x8(%ebp),%eax
  801aba:	01 c2                	add    %eax,%edx
  801abc:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801abf:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ac2:	01 c8                	add    %ecx,%eax
  801ac4:	8a 00                	mov    (%eax),%al
  801ac6:	88 02                	mov    %al,(%edx)
		if (src[i] >= 'A' && src[i] <= 'Z')
  801ac8:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801acb:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ace:	01 d0                	add    %edx,%eax
  801ad0:	8a 00                	mov    (%eax),%al
  801ad2:	3c 40                	cmp    $0x40,%al
  801ad4:	7e 25                	jle    801afb <str2lower+0x5c>
  801ad6:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801ad9:	8b 45 0c             	mov    0xc(%ebp),%eax
  801adc:	01 d0                	add    %edx,%eax
  801ade:	8a 00                	mov    (%eax),%al
  801ae0:	3c 5a                	cmp    $0x5a,%al
  801ae2:	7f 17                	jg     801afb <str2lower+0x5c>
		{
			dst[i] += 32 ;
  801ae4:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801ae7:	8b 45 08             	mov    0x8(%ebp),%eax
  801aea:	01 d0                	add    %edx,%eax
  801aec:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801aef:	8b 55 08             	mov    0x8(%ebp),%edx
  801af2:	01 ca                	add    %ecx,%edx
  801af4:	8a 12                	mov    (%edx),%dl
  801af6:	83 c2 20             	add    $0x20,%edx
  801af9:	88 10                	mov    %dl,(%eax)


char* str2lower(char *dst, const char *src)
{
	char* ret = dst;
	for (int i = 0; i < strlen(src); ++i)
  801afb:	ff 45 fc             	incl   -0x4(%ebp)
  801afe:	ff 75 0c             	pushl  0xc(%ebp)
  801b01:	e8 01 f8 ff ff       	call   801307 <strlen>
  801b06:	83 c4 04             	add    $0x4,%esp
  801b09:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801b0c:	7f a6                	jg     801ab4 <str2lower+0x15>
		if (src[i] >= 'A' && src[i] <= 'Z')
		{
			dst[i] += 32 ;
		}
	}
	return ret;
  801b0e:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801b11:	c9                   	leave  
  801b12:	c3                   	ret    

00801b13 <uheap_init>:
//==============================================
// [1] INITIALIZE USER HEAP:
//==============================================
int __firstTimeFlag = 1;
void uheap_init()
{
  801b13:	55                   	push   %ebp
  801b14:	89 e5                	mov    %esp,%ebp
  801b16:	83 ec 08             	sub    $0x8,%esp
	if(__firstTimeFlag)
  801b19:	a1 08 40 80 00       	mov    0x804008,%eax
  801b1e:	85 c0                	test   %eax,%eax
  801b20:	74 42                	je     801b64 <uheap_init+0x51>
	{
		initialize_dynamic_allocator(USER_HEAP_START, USER_HEAP_START + DYN_ALLOC_MAX_SIZE);
  801b22:	83 ec 08             	sub    $0x8,%esp
  801b25:	68 00 00 00 82       	push   $0x82000000
  801b2a:	68 00 00 00 80       	push   $0x80000000
  801b2f:	e8 00 08 00 00       	call   802334 <initialize_dynamic_allocator>
  801b34:	83 c4 10             	add    $0x10,%esp
		uheapPlaceStrategy = sys_get_uheap_strategy();
  801b37:	e8 e7 05 00 00       	call   802123 <sys_get_uheap_strategy>
  801b3c:	a3 60 c0 81 00       	mov    %eax,0x81c060
		uheapPageAllocStart = dynAllocEnd + PAGE_SIZE;
  801b41:	a1 40 40 80 00       	mov    0x804040,%eax
  801b46:	05 00 10 00 00       	add    $0x1000,%eax
  801b4b:	a3 10 c1 81 00       	mov    %eax,0x81c110
		uheapPageAllocBreak = uheapPageAllocStart;
  801b50:	a1 10 c1 81 00       	mov    0x81c110,%eax
  801b55:	a3 68 c0 81 00       	mov    %eax,0x81c068

		__firstTimeFlag = 0;
  801b5a:	c7 05 08 40 80 00 00 	movl   $0x0,0x804008
  801b61:	00 00 00 
	}
}
  801b64:	90                   	nop
  801b65:	c9                   	leave  
  801b66:	c3                   	ret    

00801b67 <get_page>:

//==============================================
// [2] GET A PAGE FROM THE KERNEL FOR DA:
//==============================================
int get_page(void* va)
{
  801b67:	55                   	push   %ebp
  801b68:	89 e5                	mov    %esp,%ebp
  801b6a:	83 ec 18             	sub    $0x18,%esp
	int ret = __sys_allocate_page(ROUNDDOWN(va, PAGE_SIZE), PERM_USER|PERM_WRITEABLE|PERM_UHPAGE);
  801b6d:	8b 45 08             	mov    0x8(%ebp),%eax
  801b70:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801b73:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b76:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801b7b:	83 ec 08             	sub    $0x8,%esp
  801b7e:	68 06 04 00 00       	push   $0x406
  801b83:	50                   	push   %eax
  801b84:	e8 e4 01 00 00       	call   801d6d <__sys_allocate_page>
  801b89:	83 c4 10             	add    $0x10,%esp
  801b8c:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (ret < 0)
  801b8f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801b93:	79 14                	jns    801ba9 <get_page+0x42>
		panic("get_page() in user: failed to allocate page from the kernel");
  801b95:	83 ec 04             	sub    $0x4,%esp
  801b98:	68 5c 37 80 00       	push   $0x80375c
  801b9d:	6a 1f                	push   $0x1f
  801b9f:	68 98 37 80 00       	push   $0x803798
  801ba4:	e8 af eb ff ff       	call   800758 <_panic>
	return 0;
  801ba9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801bae:	c9                   	leave  
  801baf:	c3                   	ret    

00801bb0 <return_page>:

//==============================================
// [3] RETURN A PAGE FROM THE DA TO KERNEL:
//==============================================
void return_page(void* va)
{
  801bb0:	55                   	push   %ebp
  801bb1:	89 e5                	mov    %esp,%ebp
  801bb3:	83 ec 18             	sub    $0x18,%esp
	int ret = __sys_unmap_frame(ROUNDDOWN((uint32)va, PAGE_SIZE));
  801bb6:	8b 45 08             	mov    0x8(%ebp),%eax
  801bb9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801bbc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801bbf:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801bc4:	83 ec 0c             	sub    $0xc,%esp
  801bc7:	50                   	push   %eax
  801bc8:	e8 e7 01 00 00       	call   801db4 <__sys_unmap_frame>
  801bcd:	83 c4 10             	add    $0x10,%esp
  801bd0:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (ret < 0)
  801bd3:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801bd7:	79 14                	jns    801bed <return_page+0x3d>
		panic("return_page() in user: failed to return a page to the kernel");
  801bd9:	83 ec 04             	sub    $0x4,%esp
  801bdc:	68 a4 37 80 00       	push   $0x8037a4
  801be1:	6a 2a                	push   $0x2a
  801be3:	68 98 37 80 00       	push   $0x803798
  801be8:	e8 6b eb ff ff       	call   800758 <_panic>
}
  801bed:	90                   	nop
  801bee:	c9                   	leave  
  801bef:	c3                   	ret    

00801bf0 <malloc>:

//=================================
// [1] ALLOCATE SPACE IN USER HEAP:
//=================================
void* malloc(uint32 size)
{
  801bf0:	55                   	push   %ebp
  801bf1:	89 e5                	mov    %esp,%ebp
  801bf3:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  801bf6:	e8 18 ff ff ff       	call   801b13 <uheap_init>
	if (size == 0) return NULL ;
  801bfb:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801bff:	75 07                	jne    801c08 <malloc+0x18>
  801c01:	b8 00 00 00 00       	mov    $0x0,%eax
  801c06:	eb 14                	jmp    801c1c <malloc+0x2c>
	//==============================================================
	//TODO: [PROJECT'25.IM#2] USER HEAP - #1 malloc
	//Your code is here
	//Comment the following line
	panic("malloc() is not implemented yet...!!");
  801c08:	83 ec 04             	sub    $0x4,%esp
  801c0b:	68 e4 37 80 00       	push   $0x8037e4
  801c10:	6a 3e                	push   $0x3e
  801c12:	68 98 37 80 00       	push   $0x803798
  801c17:	e8 3c eb ff ff       	call   800758 <_panic>
}
  801c1c:	c9                   	leave  
  801c1d:	c3                   	ret    

00801c1e <free>:

//=================================
// [2] FREE SPACE FROM USER HEAP:
//=================================
void free(void* virtual_address)
{
  801c1e:	55                   	push   %ebp
  801c1f:	89 e5                	mov    %esp,%ebp
  801c21:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.IM#2] USER HEAP - #3 free
	//Your code is here
	//Comment the following line
	panic("free() is not implemented yet...!!");
  801c24:	83 ec 04             	sub    $0x4,%esp
  801c27:	68 0c 38 80 00       	push   $0x80380c
  801c2c:	6a 49                	push   $0x49
  801c2e:	68 98 37 80 00       	push   $0x803798
  801c33:	e8 20 eb ff ff       	call   800758 <_panic>

00801c38 <smalloc>:

//=================================
// [3] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  801c38:	55                   	push   %ebp
  801c39:	89 e5                	mov    %esp,%ebp
  801c3b:	83 ec 18             	sub    $0x18,%esp
  801c3e:	8b 45 10             	mov    0x10(%ebp),%eax
  801c41:	88 45 f4             	mov    %al,-0xc(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  801c44:	e8 ca fe ff ff       	call   801b13 <uheap_init>
	if (size == 0) return NULL ;
  801c49:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801c4d:	75 07                	jne    801c56 <smalloc+0x1e>
  801c4f:	b8 00 00 00 00       	mov    $0x0,%eax
  801c54:	eb 14                	jmp    801c6a <smalloc+0x32>
	//==============================================================

	//TODO: [PROJECT'25.IM#3] SHARED MEMORY - #2 smalloc
	//Your code is here
	//Comment the following line
	panic("smalloc() is not implemented yet...!!");
  801c56:	83 ec 04             	sub    $0x4,%esp
  801c59:	68 30 38 80 00       	push   $0x803830
  801c5e:	6a 5a                	push   $0x5a
  801c60:	68 98 37 80 00       	push   $0x803798
  801c65:	e8 ee ea ff ff       	call   800758 <_panic>
}
  801c6a:	c9                   	leave  
  801c6b:	c3                   	ret    

00801c6c <sget>:

//========================================
// [4] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801c6c:	55                   	push   %ebp
  801c6d:	89 e5                	mov    %esp,%ebp
  801c6f:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  801c72:	e8 9c fe ff ff       	call   801b13 <uheap_init>
	//==============================================================

	//TODO: [PROJECT'25.IM#3] SHARED MEMORY - #4 sget
	//Your code is here
	//Comment the following line
	panic("sget() is not implemented yet...!!");
  801c77:	83 ec 04             	sub    $0x4,%esp
  801c7a:	68 58 38 80 00       	push   $0x803858
  801c7f:	6a 6a                	push   $0x6a
  801c81:	68 98 37 80 00       	push   $0x803798
  801c86:	e8 cd ea ff ff       	call   800758 <_panic>

00801c8b <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801c8b:	55                   	push   %ebp
  801c8c:	89 e5                	mov    %esp,%ebp
  801c8e:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  801c91:	e8 7d fe ff ff       	call   801b13 <uheap_init>
	//==============================================================
	panic("realloc() is not implemented yet...!!");
  801c96:	83 ec 04             	sub    $0x4,%esp
  801c99:	68 7c 38 80 00       	push   $0x80387c
  801c9e:	68 88 00 00 00       	push   $0x88
  801ca3:	68 98 37 80 00       	push   $0x803798
  801ca8:	e8 ab ea ff ff       	call   800758 <_panic>

00801cad <sfree>:
//
//	use sys_delete_shared_object(...); which switches to the kernel mode,
//	calls delete_shared_object(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the delete_shared_object() function is empty, make sure to implement it.
void sfree(void* virtual_address)
{
  801cad:	55                   	push   %ebp
  801cae:	89 e5                	mov    %esp,%ebp
  801cb0:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.BONUS#5] EXIT #2 - sfree
	//Your code is here
	//Comment the following line
	panic("sfree() is not implemented yet...!!");
  801cb3:	83 ec 04             	sub    $0x4,%esp
  801cb6:	68 a4 38 80 00       	push   $0x8038a4
  801cbb:	68 9b 00 00 00       	push   $0x9b
  801cc0:	68 98 37 80 00       	push   $0x803798
  801cc5:	e8 8e ea ff ff       	call   800758 <_panic>

00801cca <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801cca:	55                   	push   %ebp
  801ccb:	89 e5                	mov    %esp,%ebp
  801ccd:	57                   	push   %edi
  801cce:	56                   	push   %esi
  801ccf:	53                   	push   %ebx
  801cd0:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801cd3:	8b 45 08             	mov    0x8(%ebp),%eax
  801cd6:	8b 55 0c             	mov    0xc(%ebp),%edx
  801cd9:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801cdc:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801cdf:	8b 7d 18             	mov    0x18(%ebp),%edi
  801ce2:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801ce5:	cd 30                	int    $0x30
  801ce7:	89 45 f0             	mov    %eax,-0x10(%ebp)
				"b" (a3),
				"D" (a4),
				"S" (a5)
				: "cc", "memory");

	return ret;
  801cea:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801ced:	83 c4 10             	add    $0x10,%esp
  801cf0:	5b                   	pop    %ebx
  801cf1:	5e                   	pop    %esi
  801cf2:	5f                   	pop    %edi
  801cf3:	5d                   	pop    %ebp
  801cf4:	c3                   	ret    

00801cf5 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName, int color)
{
  801cf5:	55                   	push   %ebp
  801cf6:	89 e5                	mov    %esp,%ebp
  801cf8:	83 ec 04             	sub    $0x4,%esp
  801cfb:	8b 45 10             	mov    0x10(%ebp),%eax
  801cfe:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, color, 0);
  801d01:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801d04:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801d08:	8b 45 08             	mov    0x8(%ebp),%eax
  801d0b:	6a 00                	push   $0x0
  801d0d:	51                   	push   %ecx
  801d0e:	52                   	push   %edx
  801d0f:	ff 75 0c             	pushl  0xc(%ebp)
  801d12:	50                   	push   %eax
  801d13:	6a 00                	push   $0x0
  801d15:	e8 b0 ff ff ff       	call   801cca <syscall>
  801d1a:	83 c4 18             	add    $0x18,%esp
}
  801d1d:	90                   	nop
  801d1e:	c9                   	leave  
  801d1f:	c3                   	ret    

00801d20 <sys_cgetc>:

int
sys_cgetc(void)
{
  801d20:	55                   	push   %ebp
  801d21:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801d23:	6a 00                	push   $0x0
  801d25:	6a 00                	push   $0x0
  801d27:	6a 00                	push   $0x0
  801d29:	6a 00                	push   $0x0
  801d2b:	6a 00                	push   $0x0
  801d2d:	6a 02                	push   $0x2
  801d2f:	e8 96 ff ff ff       	call   801cca <syscall>
  801d34:	83 c4 18             	add    $0x18,%esp
}
  801d37:	c9                   	leave  
  801d38:	c3                   	ret    

00801d39 <sys_lock_cons>:

void sys_lock_cons(void)
{
  801d39:	55                   	push   %ebp
  801d3a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  801d3c:	6a 00                	push   $0x0
  801d3e:	6a 00                	push   $0x0
  801d40:	6a 00                	push   $0x0
  801d42:	6a 00                	push   $0x0
  801d44:	6a 00                	push   $0x0
  801d46:	6a 03                	push   $0x3
  801d48:	e8 7d ff ff ff       	call   801cca <syscall>
  801d4d:	83 c4 18             	add    $0x18,%esp
}
  801d50:	90                   	nop
  801d51:	c9                   	leave  
  801d52:	c3                   	ret    

00801d53 <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  801d53:	55                   	push   %ebp
  801d54:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  801d56:	6a 00                	push   $0x0
  801d58:	6a 00                	push   $0x0
  801d5a:	6a 00                	push   $0x0
  801d5c:	6a 00                	push   $0x0
  801d5e:	6a 00                	push   $0x0
  801d60:	6a 04                	push   $0x4
  801d62:	e8 63 ff ff ff       	call   801cca <syscall>
  801d67:	83 c4 18             	add    $0x18,%esp
}
  801d6a:	90                   	nop
  801d6b:	c9                   	leave  
  801d6c:	c3                   	ret    

00801d6d <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801d6d:	55                   	push   %ebp
  801d6e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801d70:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d73:	8b 45 08             	mov    0x8(%ebp),%eax
  801d76:	6a 00                	push   $0x0
  801d78:	6a 00                	push   $0x0
  801d7a:	6a 00                	push   $0x0
  801d7c:	52                   	push   %edx
  801d7d:	50                   	push   %eax
  801d7e:	6a 08                	push   $0x8
  801d80:	e8 45 ff ff ff       	call   801cca <syscall>
  801d85:	83 c4 18             	add    $0x18,%esp
}
  801d88:	c9                   	leave  
  801d89:	c3                   	ret    

00801d8a <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801d8a:	55                   	push   %ebp
  801d8b:	89 e5                	mov    %esp,%ebp
  801d8d:	56                   	push   %esi
  801d8e:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801d8f:	8b 75 18             	mov    0x18(%ebp),%esi
  801d92:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801d95:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801d98:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d9b:	8b 45 08             	mov    0x8(%ebp),%eax
  801d9e:	56                   	push   %esi
  801d9f:	53                   	push   %ebx
  801da0:	51                   	push   %ecx
  801da1:	52                   	push   %edx
  801da2:	50                   	push   %eax
  801da3:	6a 09                	push   $0x9
  801da5:	e8 20 ff ff ff       	call   801cca <syscall>
  801daa:	83 c4 18             	add    $0x18,%esp
}
  801dad:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801db0:	5b                   	pop    %ebx
  801db1:	5e                   	pop    %esi
  801db2:	5d                   	pop    %ebp
  801db3:	c3                   	ret    

00801db4 <__sys_unmap_frame>:

int __sys_unmap_frame(uint32 va)
{
  801db4:	55                   	push   %ebp
  801db5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, va, 0, 0, 0, 0);
  801db7:	6a 00                	push   $0x0
  801db9:	6a 00                	push   $0x0
  801dbb:	6a 00                	push   $0x0
  801dbd:	6a 00                	push   $0x0
  801dbf:	ff 75 08             	pushl  0x8(%ebp)
  801dc2:	6a 0a                	push   $0xa
  801dc4:	e8 01 ff ff ff       	call   801cca <syscall>
  801dc9:	83 c4 18             	add    $0x18,%esp
}
  801dcc:	c9                   	leave  
  801dcd:	c3                   	ret    

00801dce <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801dce:	55                   	push   %ebp
  801dcf:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801dd1:	6a 00                	push   $0x0
  801dd3:	6a 00                	push   $0x0
  801dd5:	6a 00                	push   $0x0
  801dd7:	ff 75 0c             	pushl  0xc(%ebp)
  801dda:	ff 75 08             	pushl  0x8(%ebp)
  801ddd:	6a 0b                	push   $0xb
  801ddf:	e8 e6 fe ff ff       	call   801cca <syscall>
  801de4:	83 c4 18             	add    $0x18,%esp
}
  801de7:	c9                   	leave  
  801de8:	c3                   	ret    

00801de9 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801de9:	55                   	push   %ebp
  801dea:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801dec:	6a 00                	push   $0x0
  801dee:	6a 00                	push   $0x0
  801df0:	6a 00                	push   $0x0
  801df2:	6a 00                	push   $0x0
  801df4:	6a 00                	push   $0x0
  801df6:	6a 0c                	push   $0xc
  801df8:	e8 cd fe ff ff       	call   801cca <syscall>
  801dfd:	83 c4 18             	add    $0x18,%esp
}
  801e00:	c9                   	leave  
  801e01:	c3                   	ret    

00801e02 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801e02:	55                   	push   %ebp
  801e03:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801e05:	6a 00                	push   $0x0
  801e07:	6a 00                	push   $0x0
  801e09:	6a 00                	push   $0x0
  801e0b:	6a 00                	push   $0x0
  801e0d:	6a 00                	push   $0x0
  801e0f:	6a 0d                	push   $0xd
  801e11:	e8 b4 fe ff ff       	call   801cca <syscall>
  801e16:	83 c4 18             	add    $0x18,%esp
}
  801e19:	c9                   	leave  
  801e1a:	c3                   	ret    

00801e1b <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801e1b:	55                   	push   %ebp
  801e1c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801e1e:	6a 00                	push   $0x0
  801e20:	6a 00                	push   $0x0
  801e22:	6a 00                	push   $0x0
  801e24:	6a 00                	push   $0x0
  801e26:	6a 00                	push   $0x0
  801e28:	6a 0e                	push   $0xe
  801e2a:	e8 9b fe ff ff       	call   801cca <syscall>
  801e2f:	83 c4 18             	add    $0x18,%esp
}
  801e32:	c9                   	leave  
  801e33:	c3                   	ret    

00801e34 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801e34:	55                   	push   %ebp
  801e35:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801e37:	6a 00                	push   $0x0
  801e39:	6a 00                	push   $0x0
  801e3b:	6a 00                	push   $0x0
  801e3d:	6a 00                	push   $0x0
  801e3f:	6a 00                	push   $0x0
  801e41:	6a 0f                	push   $0xf
  801e43:	e8 82 fe ff ff       	call   801cca <syscall>
  801e48:	83 c4 18             	add    $0x18,%esp
}
  801e4b:	c9                   	leave  
  801e4c:	c3                   	ret    

00801e4d <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801e4d:	55                   	push   %ebp
  801e4e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801e50:	6a 00                	push   $0x0
  801e52:	6a 00                	push   $0x0
  801e54:	6a 00                	push   $0x0
  801e56:	6a 00                	push   $0x0
  801e58:	ff 75 08             	pushl  0x8(%ebp)
  801e5b:	6a 10                	push   $0x10
  801e5d:	e8 68 fe ff ff       	call   801cca <syscall>
  801e62:	83 c4 18             	add    $0x18,%esp
}
  801e65:	c9                   	leave  
  801e66:	c3                   	ret    

00801e67 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801e67:	55                   	push   %ebp
  801e68:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801e6a:	6a 00                	push   $0x0
  801e6c:	6a 00                	push   $0x0
  801e6e:	6a 00                	push   $0x0
  801e70:	6a 00                	push   $0x0
  801e72:	6a 00                	push   $0x0
  801e74:	6a 11                	push   $0x11
  801e76:	e8 4f fe ff ff       	call   801cca <syscall>
  801e7b:	83 c4 18             	add    $0x18,%esp
}
  801e7e:	90                   	nop
  801e7f:	c9                   	leave  
  801e80:	c3                   	ret    

00801e81 <sys_cputc>:

void
sys_cputc(const char c)
{
  801e81:	55                   	push   %ebp
  801e82:	89 e5                	mov    %esp,%ebp
  801e84:	83 ec 04             	sub    $0x4,%esp
  801e87:	8b 45 08             	mov    0x8(%ebp),%eax
  801e8a:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801e8d:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801e91:	6a 00                	push   $0x0
  801e93:	6a 00                	push   $0x0
  801e95:	6a 00                	push   $0x0
  801e97:	6a 00                	push   $0x0
  801e99:	50                   	push   %eax
  801e9a:	6a 01                	push   $0x1
  801e9c:	e8 29 fe ff ff       	call   801cca <syscall>
  801ea1:	83 c4 18             	add    $0x18,%esp
}
  801ea4:	90                   	nop
  801ea5:	c9                   	leave  
  801ea6:	c3                   	ret    

00801ea7 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801ea7:	55                   	push   %ebp
  801ea8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801eaa:	6a 00                	push   $0x0
  801eac:	6a 00                	push   $0x0
  801eae:	6a 00                	push   $0x0
  801eb0:	6a 00                	push   $0x0
  801eb2:	6a 00                	push   $0x0
  801eb4:	6a 14                	push   $0x14
  801eb6:	e8 0f fe ff ff       	call   801cca <syscall>
  801ebb:	83 c4 18             	add    $0x18,%esp
}
  801ebe:	90                   	nop
  801ebf:	c9                   	leave  
  801ec0:	c3                   	ret    

00801ec1 <sys_create_shared_object>:

int sys_create_shared_object(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801ec1:	55                   	push   %ebp
  801ec2:	89 e5                	mov    %esp,%ebp
  801ec4:	83 ec 04             	sub    $0x4,%esp
  801ec7:	8b 45 10             	mov    0x10(%ebp),%eax
  801eca:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801ecd:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801ed0:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801ed4:	8b 45 08             	mov    0x8(%ebp),%eax
  801ed7:	6a 00                	push   $0x0
  801ed9:	51                   	push   %ecx
  801eda:	52                   	push   %edx
  801edb:	ff 75 0c             	pushl  0xc(%ebp)
  801ede:	50                   	push   %eax
  801edf:	6a 15                	push   $0x15
  801ee1:	e8 e4 fd ff ff       	call   801cca <syscall>
  801ee6:	83 c4 18             	add    $0x18,%esp
}
  801ee9:	c9                   	leave  
  801eea:	c3                   	ret    

00801eeb <sys_size_of_shared_object>:

//2017:
int sys_size_of_shared_object(int32 ownerID, char* shareName)
{
  801eeb:	55                   	push   %ebp
  801eec:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801eee:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ef1:	8b 45 08             	mov    0x8(%ebp),%eax
  801ef4:	6a 00                	push   $0x0
  801ef6:	6a 00                	push   $0x0
  801ef8:	6a 00                	push   $0x0
  801efa:	52                   	push   %edx
  801efb:	50                   	push   %eax
  801efc:	6a 16                	push   $0x16
  801efe:	e8 c7 fd ff ff       	call   801cca <syscall>
  801f03:	83 c4 18             	add    $0x18,%esp
}
  801f06:	c9                   	leave  
  801f07:	c3                   	ret    

00801f08 <sys_get_shared_object>:
//==========

int sys_get_shared_object(int32 ownerID, char* shareName, void* virtual_address)
{
  801f08:	55                   	push   %ebp
  801f09:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801f0b:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801f0e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f11:	8b 45 08             	mov    0x8(%ebp),%eax
  801f14:	6a 00                	push   $0x0
  801f16:	6a 00                	push   $0x0
  801f18:	51                   	push   %ecx
  801f19:	52                   	push   %edx
  801f1a:	50                   	push   %eax
  801f1b:	6a 17                	push   $0x17
  801f1d:	e8 a8 fd ff ff       	call   801cca <syscall>
  801f22:	83 c4 18             	add    $0x18,%esp
}
  801f25:	c9                   	leave  
  801f26:	c3                   	ret    

00801f27 <sys_delete_shared_object>:

int sys_delete_shared_object(int32 sharedObjectID, void *startVA)
{
  801f27:	55                   	push   %ebp
  801f28:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801f2a:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f2d:	8b 45 08             	mov    0x8(%ebp),%eax
  801f30:	6a 00                	push   $0x0
  801f32:	6a 00                	push   $0x0
  801f34:	6a 00                	push   $0x0
  801f36:	52                   	push   %edx
  801f37:	50                   	push   %eax
  801f38:	6a 18                	push   $0x18
  801f3a:	e8 8b fd ff ff       	call   801cca <syscall>
  801f3f:	83 c4 18             	add    $0x18,%esp
}
  801f42:	c9                   	leave  
  801f43:	c3                   	ret    

00801f44 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801f44:	55                   	push   %ebp
  801f45:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801f47:	8b 45 08             	mov    0x8(%ebp),%eax
  801f4a:	6a 00                	push   $0x0
  801f4c:	ff 75 14             	pushl  0x14(%ebp)
  801f4f:	ff 75 10             	pushl  0x10(%ebp)
  801f52:	ff 75 0c             	pushl  0xc(%ebp)
  801f55:	50                   	push   %eax
  801f56:	6a 19                	push   $0x19
  801f58:	e8 6d fd ff ff       	call   801cca <syscall>
  801f5d:	83 c4 18             	add    $0x18,%esp
}
  801f60:	c9                   	leave  
  801f61:	c3                   	ret    

00801f62 <sys_run_env>:

void sys_run_env(int32 envId)
{
  801f62:	55                   	push   %ebp
  801f63:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801f65:	8b 45 08             	mov    0x8(%ebp),%eax
  801f68:	6a 00                	push   $0x0
  801f6a:	6a 00                	push   $0x0
  801f6c:	6a 00                	push   $0x0
  801f6e:	6a 00                	push   $0x0
  801f70:	50                   	push   %eax
  801f71:	6a 1a                	push   $0x1a
  801f73:	e8 52 fd ff ff       	call   801cca <syscall>
  801f78:	83 c4 18             	add    $0x18,%esp
}
  801f7b:	90                   	nop
  801f7c:	c9                   	leave  
  801f7d:	c3                   	ret    

00801f7e <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801f7e:	55                   	push   %ebp
  801f7f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801f81:	8b 45 08             	mov    0x8(%ebp),%eax
  801f84:	6a 00                	push   $0x0
  801f86:	6a 00                	push   $0x0
  801f88:	6a 00                	push   $0x0
  801f8a:	6a 00                	push   $0x0
  801f8c:	50                   	push   %eax
  801f8d:	6a 1b                	push   $0x1b
  801f8f:	e8 36 fd ff ff       	call   801cca <syscall>
  801f94:	83 c4 18             	add    $0x18,%esp
}
  801f97:	c9                   	leave  
  801f98:	c3                   	ret    

00801f99 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801f99:	55                   	push   %ebp
  801f9a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801f9c:	6a 00                	push   $0x0
  801f9e:	6a 00                	push   $0x0
  801fa0:	6a 00                	push   $0x0
  801fa2:	6a 00                	push   $0x0
  801fa4:	6a 00                	push   $0x0
  801fa6:	6a 05                	push   $0x5
  801fa8:	e8 1d fd ff ff       	call   801cca <syscall>
  801fad:	83 c4 18             	add    $0x18,%esp
}
  801fb0:	c9                   	leave  
  801fb1:	c3                   	ret    

00801fb2 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801fb2:	55                   	push   %ebp
  801fb3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801fb5:	6a 00                	push   $0x0
  801fb7:	6a 00                	push   $0x0
  801fb9:	6a 00                	push   $0x0
  801fbb:	6a 00                	push   $0x0
  801fbd:	6a 00                	push   $0x0
  801fbf:	6a 06                	push   $0x6
  801fc1:	e8 04 fd ff ff       	call   801cca <syscall>
  801fc6:	83 c4 18             	add    $0x18,%esp
}
  801fc9:	c9                   	leave  
  801fca:	c3                   	ret    

00801fcb <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801fcb:	55                   	push   %ebp
  801fcc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801fce:	6a 00                	push   $0x0
  801fd0:	6a 00                	push   $0x0
  801fd2:	6a 00                	push   $0x0
  801fd4:	6a 00                	push   $0x0
  801fd6:	6a 00                	push   $0x0
  801fd8:	6a 07                	push   $0x7
  801fda:	e8 eb fc ff ff       	call   801cca <syscall>
  801fdf:	83 c4 18             	add    $0x18,%esp
}
  801fe2:	c9                   	leave  
  801fe3:	c3                   	ret    

00801fe4 <sys_exit_env>:


void sys_exit_env(void)
{
  801fe4:	55                   	push   %ebp
  801fe5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801fe7:	6a 00                	push   $0x0
  801fe9:	6a 00                	push   $0x0
  801feb:	6a 00                	push   $0x0
  801fed:	6a 00                	push   $0x0
  801fef:	6a 00                	push   $0x0
  801ff1:	6a 1c                	push   $0x1c
  801ff3:	e8 d2 fc ff ff       	call   801cca <syscall>
  801ff8:	83 c4 18             	add    $0x18,%esp
}
  801ffb:	90                   	nop
  801ffc:	c9                   	leave  
  801ffd:	c3                   	ret    

00801ffe <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  801ffe:	55                   	push   %ebp
  801fff:	89 e5                	mov    %esp,%ebp
  802001:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  802004:	8d 45 f8             	lea    -0x8(%ebp),%eax
  802007:	8d 50 04             	lea    0x4(%eax),%edx
  80200a:	8d 45 f8             	lea    -0x8(%ebp),%eax
  80200d:	6a 00                	push   $0x0
  80200f:	6a 00                	push   $0x0
  802011:	6a 00                	push   $0x0
  802013:	52                   	push   %edx
  802014:	50                   	push   %eax
  802015:	6a 1d                	push   $0x1d
  802017:	e8 ae fc ff ff       	call   801cca <syscall>
  80201c:	83 c4 18             	add    $0x18,%esp
	return result;
  80201f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802022:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802025:	8b 55 fc             	mov    -0x4(%ebp),%edx
  802028:	89 01                	mov    %eax,(%ecx)
  80202a:	89 51 04             	mov    %edx,0x4(%ecx)
}
  80202d:	8b 45 08             	mov    0x8(%ebp),%eax
  802030:	c9                   	leave  
  802031:	c2 04 00             	ret    $0x4

00802034 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  802034:	55                   	push   %ebp
  802035:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  802037:	6a 00                	push   $0x0
  802039:	6a 00                	push   $0x0
  80203b:	ff 75 10             	pushl  0x10(%ebp)
  80203e:	ff 75 0c             	pushl  0xc(%ebp)
  802041:	ff 75 08             	pushl  0x8(%ebp)
  802044:	6a 13                	push   $0x13
  802046:	e8 7f fc ff ff       	call   801cca <syscall>
  80204b:	83 c4 18             	add    $0x18,%esp
	return ;
  80204e:	90                   	nop
}
  80204f:	c9                   	leave  
  802050:	c3                   	ret    

00802051 <sys_rcr2>:
uint32 sys_rcr2()
{
  802051:	55                   	push   %ebp
  802052:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  802054:	6a 00                	push   $0x0
  802056:	6a 00                	push   $0x0
  802058:	6a 00                	push   $0x0
  80205a:	6a 00                	push   $0x0
  80205c:	6a 00                	push   $0x0
  80205e:	6a 1e                	push   $0x1e
  802060:	e8 65 fc ff ff       	call   801cca <syscall>
  802065:	83 c4 18             	add    $0x18,%esp
}
  802068:	c9                   	leave  
  802069:	c3                   	ret    

0080206a <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  80206a:	55                   	push   %ebp
  80206b:	89 e5                	mov    %esp,%ebp
  80206d:	83 ec 04             	sub    $0x4,%esp
  802070:	8b 45 08             	mov    0x8(%ebp),%eax
  802073:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  802076:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  80207a:	6a 00                	push   $0x0
  80207c:	6a 00                	push   $0x0
  80207e:	6a 00                	push   $0x0
  802080:	6a 00                	push   $0x0
  802082:	50                   	push   %eax
  802083:	6a 1f                	push   $0x1f
  802085:	e8 40 fc ff ff       	call   801cca <syscall>
  80208a:	83 c4 18             	add    $0x18,%esp
	return ;
  80208d:	90                   	nop
}
  80208e:	c9                   	leave  
  80208f:	c3                   	ret    

00802090 <rsttst>:
void rsttst()
{
  802090:	55                   	push   %ebp
  802091:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  802093:	6a 00                	push   $0x0
  802095:	6a 00                	push   $0x0
  802097:	6a 00                	push   $0x0
  802099:	6a 00                	push   $0x0
  80209b:	6a 00                	push   $0x0
  80209d:	6a 21                	push   $0x21
  80209f:	e8 26 fc ff ff       	call   801cca <syscall>
  8020a4:	83 c4 18             	add    $0x18,%esp
	return ;
  8020a7:	90                   	nop
}
  8020a8:	c9                   	leave  
  8020a9:	c3                   	ret    

008020aa <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  8020aa:	55                   	push   %ebp
  8020ab:	89 e5                	mov    %esp,%ebp
  8020ad:	83 ec 04             	sub    $0x4,%esp
  8020b0:	8b 45 14             	mov    0x14(%ebp),%eax
  8020b3:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  8020b6:	8b 55 18             	mov    0x18(%ebp),%edx
  8020b9:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8020bd:	52                   	push   %edx
  8020be:	50                   	push   %eax
  8020bf:	ff 75 10             	pushl  0x10(%ebp)
  8020c2:	ff 75 0c             	pushl  0xc(%ebp)
  8020c5:	ff 75 08             	pushl  0x8(%ebp)
  8020c8:	6a 20                	push   $0x20
  8020ca:	e8 fb fb ff ff       	call   801cca <syscall>
  8020cf:	83 c4 18             	add    $0x18,%esp
	return ;
  8020d2:	90                   	nop
}
  8020d3:	c9                   	leave  
  8020d4:	c3                   	ret    

008020d5 <chktst>:
void chktst(uint32 n)
{
  8020d5:	55                   	push   %ebp
  8020d6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  8020d8:	6a 00                	push   $0x0
  8020da:	6a 00                	push   $0x0
  8020dc:	6a 00                	push   $0x0
  8020de:	6a 00                	push   $0x0
  8020e0:	ff 75 08             	pushl  0x8(%ebp)
  8020e3:	6a 22                	push   $0x22
  8020e5:	e8 e0 fb ff ff       	call   801cca <syscall>
  8020ea:	83 c4 18             	add    $0x18,%esp
	return ;
  8020ed:	90                   	nop
}
  8020ee:	c9                   	leave  
  8020ef:	c3                   	ret    

008020f0 <inctst>:

void inctst()
{
  8020f0:	55                   	push   %ebp
  8020f1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  8020f3:	6a 00                	push   $0x0
  8020f5:	6a 00                	push   $0x0
  8020f7:	6a 00                	push   $0x0
  8020f9:	6a 00                	push   $0x0
  8020fb:	6a 00                	push   $0x0
  8020fd:	6a 23                	push   $0x23
  8020ff:	e8 c6 fb ff ff       	call   801cca <syscall>
  802104:	83 c4 18             	add    $0x18,%esp
	return ;
  802107:	90                   	nop
}
  802108:	c9                   	leave  
  802109:	c3                   	ret    

0080210a <gettst>:
uint32 gettst()
{
  80210a:	55                   	push   %ebp
  80210b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  80210d:	6a 00                	push   $0x0
  80210f:	6a 00                	push   $0x0
  802111:	6a 00                	push   $0x0
  802113:	6a 00                	push   $0x0
  802115:	6a 00                	push   $0x0
  802117:	6a 24                	push   $0x24
  802119:	e8 ac fb ff ff       	call   801cca <syscall>
  80211e:	83 c4 18             	add    $0x18,%esp
}
  802121:	c9                   	leave  
  802122:	c3                   	ret    

00802123 <sys_get_uheap_strategy>:

/*2025*/
uint32 sys_get_uheap_strategy()
{
  802123:	55                   	push   %ebp
  802124:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802126:	6a 00                	push   $0x0
  802128:	6a 00                	push   $0x0
  80212a:	6a 00                	push   $0x0
  80212c:	6a 00                	push   $0x0
  80212e:	6a 00                	push   $0x0
  802130:	6a 25                	push   $0x25
  802132:	e8 93 fb ff ff       	call   801cca <syscall>
  802137:	83 c4 18             	add    $0x18,%esp
  80213a:	a3 60 c0 81 00       	mov    %eax,0x81c060
	return uheapPlaceStrategy ;
  80213f:	a1 60 c0 81 00       	mov    0x81c060,%eax
}
  802144:	c9                   	leave  
  802145:	c3                   	ret    

00802146 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  802146:	55                   	push   %ebp
  802147:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = heapStrategy;
  802149:	8b 45 08             	mov    0x8(%ebp),%eax
  80214c:	a3 60 c0 81 00       	mov    %eax,0x81c060
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  802151:	6a 00                	push   $0x0
  802153:	6a 00                	push   $0x0
  802155:	6a 00                	push   $0x0
  802157:	6a 00                	push   $0x0
  802159:	ff 75 08             	pushl  0x8(%ebp)
  80215c:	6a 26                	push   $0x26
  80215e:	e8 67 fb ff ff       	call   801cca <syscall>
  802163:	83 c4 18             	add    $0x18,%esp
	return ;
  802166:	90                   	nop
}
  802167:	c9                   	leave  
  802168:	c3                   	ret    

00802169 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  802169:	55                   	push   %ebp
  80216a:	89 e5                	mov    %esp,%ebp
  80216c:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  80216d:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802170:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802173:	8b 55 0c             	mov    0xc(%ebp),%edx
  802176:	8b 45 08             	mov    0x8(%ebp),%eax
  802179:	6a 00                	push   $0x0
  80217b:	53                   	push   %ebx
  80217c:	51                   	push   %ecx
  80217d:	52                   	push   %edx
  80217e:	50                   	push   %eax
  80217f:	6a 27                	push   $0x27
  802181:	e8 44 fb ff ff       	call   801cca <syscall>
  802186:	83 c4 18             	add    $0x18,%esp
}
  802189:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80218c:	c9                   	leave  
  80218d:	c3                   	ret    

0080218e <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  80218e:	55                   	push   %ebp
  80218f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  802191:	8b 55 0c             	mov    0xc(%ebp),%edx
  802194:	8b 45 08             	mov    0x8(%ebp),%eax
  802197:	6a 00                	push   $0x0
  802199:	6a 00                	push   $0x0
  80219b:	6a 00                	push   $0x0
  80219d:	52                   	push   %edx
  80219e:	50                   	push   %eax
  80219f:	6a 28                	push   $0x28
  8021a1:	e8 24 fb ff ff       	call   801cca <syscall>
  8021a6:	83 c4 18             	add    $0x18,%esp
}
  8021a9:	c9                   	leave  
  8021aa:	c3                   	ret    

008021ab <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  8021ab:	55                   	push   %ebp
  8021ac:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  8021ae:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8021b1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8021b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8021b7:	6a 00                	push   $0x0
  8021b9:	51                   	push   %ecx
  8021ba:	ff 75 10             	pushl  0x10(%ebp)
  8021bd:	52                   	push   %edx
  8021be:	50                   	push   %eax
  8021bf:	6a 29                	push   $0x29
  8021c1:	e8 04 fb ff ff       	call   801cca <syscall>
  8021c6:	83 c4 18             	add    $0x18,%esp
}
  8021c9:	c9                   	leave  
  8021ca:	c3                   	ret    

008021cb <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  8021cb:	55                   	push   %ebp
  8021cc:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  8021ce:	6a 00                	push   $0x0
  8021d0:	6a 00                	push   $0x0
  8021d2:	ff 75 10             	pushl  0x10(%ebp)
  8021d5:	ff 75 0c             	pushl  0xc(%ebp)
  8021d8:	ff 75 08             	pushl  0x8(%ebp)
  8021db:	6a 12                	push   $0x12
  8021dd:	e8 e8 fa ff ff       	call   801cca <syscall>
  8021e2:	83 c4 18             	add    $0x18,%esp
	return ;
  8021e5:	90                   	nop
}
  8021e6:	c9                   	leave  
  8021e7:	c3                   	ret    

008021e8 <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  8021e8:	55                   	push   %ebp
  8021e9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  8021eb:	8b 55 0c             	mov    0xc(%ebp),%edx
  8021ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8021f1:	6a 00                	push   $0x0
  8021f3:	6a 00                	push   $0x0
  8021f5:	6a 00                	push   $0x0
  8021f7:	52                   	push   %edx
  8021f8:	50                   	push   %eax
  8021f9:	6a 2a                	push   $0x2a
  8021fb:	e8 ca fa ff ff       	call   801cca <syscall>
  802200:	83 c4 18             	add    $0x18,%esp
	return;
  802203:	90                   	nop
}
  802204:	c9                   	leave  
  802205:	c3                   	ret    

00802206 <sys_get_optimal_num_faults>:
/*2025*/
int sys_get_optimal_num_faults()
{
  802206:	55                   	push   %ebp
  802207:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_optimal_num_faults, 0, 0, 0, 0, 0);
  802209:	6a 00                	push   $0x0
  80220b:	6a 00                	push   $0x0
  80220d:	6a 00                	push   $0x0
  80220f:	6a 00                	push   $0x0
  802211:	6a 00                	push   $0x0
  802213:	6a 2b                	push   $0x2b
  802215:	e8 b0 fa ff ff       	call   801cca <syscall>
  80221a:	83 c4 18             	add    $0x18,%esp
}
  80221d:	c9                   	leave  
  80221e:	c3                   	ret    

0080221f <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  80221f:	55                   	push   %ebp
  802220:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  802222:	6a 00                	push   $0x0
  802224:	6a 00                	push   $0x0
  802226:	6a 00                	push   $0x0
  802228:	ff 75 0c             	pushl  0xc(%ebp)
  80222b:	ff 75 08             	pushl  0x8(%ebp)
  80222e:	6a 2d                	push   $0x2d
  802230:	e8 95 fa ff ff       	call   801cca <syscall>
  802235:	83 c4 18             	add    $0x18,%esp
	return;
  802238:	90                   	nop
}
  802239:	c9                   	leave  
  80223a:	c3                   	ret    

0080223b <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  80223b:	55                   	push   %ebp
  80223c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  80223e:	6a 00                	push   $0x0
  802240:	6a 00                	push   $0x0
  802242:	6a 00                	push   $0x0
  802244:	ff 75 0c             	pushl  0xc(%ebp)
  802247:	ff 75 08             	pushl  0x8(%ebp)
  80224a:	6a 2c                	push   $0x2c
  80224c:	e8 79 fa ff ff       	call   801cca <syscall>
  802251:	83 c4 18             	add    $0x18,%esp
	return ;
  802254:	90                   	nop
}
  802255:	c9                   	leave  
  802256:	c3                   	ret    

00802257 <sys_env_set_priority>:


void sys_env_set_priority(int32 envID, int priority)
{
  802257:	55                   	push   %ebp
  802258:	89 e5                	mov    %esp,%ebp
  80225a:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.IM#4] CPU SCHEDULING - #1 System Calls - Add suitable code here
	//Your code is here
	//Comment the following line
	panic("sys_env_set_priority() is not implemented yet...!!");
  80225d:	83 ec 04             	sub    $0x4,%esp
  802260:	68 c8 38 80 00       	push   $0x8038c8
  802265:	68 25 01 00 00       	push   $0x125
  80226a:	68 fb 38 80 00       	push   $0x8038fb
  80226f:	e8 e4 e4 ff ff       	call   800758 <_panic>

00802274 <to_page_va>:
//==================================
//==================================
// [1] GET PAGE VA:
//==================================
__inline__ uint32 to_page_va(struct PageInfoElement *ptrPageInfo)
{
  802274:	55                   	push   %ebp
  802275:	89 e5                	mov    %esp,%ebp
  802277:	83 ec 18             	sub    $0x18,%esp
	if (ptrPageInfo < &pageBlockInfoArr[0] || ptrPageInfo >= &pageBlockInfoArr[DYN_ALLOC_MAX_SIZE/PAGE_SIZE])
  80227a:	81 7d 08 60 40 80 00 	cmpl   $0x804060,0x8(%ebp)
  802281:	72 09                	jb     80228c <to_page_va+0x18>
  802283:	81 7d 08 60 c0 81 00 	cmpl   $0x81c060,0x8(%ebp)
  80228a:	72 14                	jb     8022a0 <to_page_va+0x2c>
			panic("to_page_va called with invalid pageInfoPtr");
  80228c:	83 ec 04             	sub    $0x4,%esp
  80228f:	68 0c 39 80 00       	push   $0x80390c
  802294:	6a 15                	push   $0x15
  802296:	68 37 39 80 00       	push   $0x803937
  80229b:	e8 b8 e4 ff ff       	call   800758 <_panic>
	//Get start VA of the page from the corresponding Page Info pointer
	int idxInPageInfoArr = (ptrPageInfo - pageBlockInfoArr);
  8022a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8022a3:	ba 60 40 80 00       	mov    $0x804060,%edx
  8022a8:	29 d0                	sub    %edx,%eax
  8022aa:	c1 f8 02             	sar    $0x2,%eax
  8022ad:	89 c2                	mov    %eax,%edx
  8022af:	89 d0                	mov    %edx,%eax
  8022b1:	c1 e0 02             	shl    $0x2,%eax
  8022b4:	01 d0                	add    %edx,%eax
  8022b6:	c1 e0 02             	shl    $0x2,%eax
  8022b9:	01 d0                	add    %edx,%eax
  8022bb:	c1 e0 02             	shl    $0x2,%eax
  8022be:	01 d0                	add    %edx,%eax
  8022c0:	89 c1                	mov    %eax,%ecx
  8022c2:	c1 e1 08             	shl    $0x8,%ecx
  8022c5:	01 c8                	add    %ecx,%eax
  8022c7:	89 c1                	mov    %eax,%ecx
  8022c9:	c1 e1 10             	shl    $0x10,%ecx
  8022cc:	01 c8                	add    %ecx,%eax
  8022ce:	01 c0                	add    %eax,%eax
  8022d0:	01 d0                	add    %edx,%eax
  8022d2:	89 45 f4             	mov    %eax,-0xc(%ebp)
	return dynAllocStart + (idxInPageInfoArr << PGSHIFT);
  8022d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022d8:	c1 e0 0c             	shl    $0xc,%eax
  8022db:	89 c2                	mov    %eax,%edx
  8022dd:	a1 64 c0 81 00       	mov    0x81c064,%eax
  8022e2:	01 d0                	add    %edx,%eax
}
  8022e4:	c9                   	leave  
  8022e5:	c3                   	ret    

008022e6 <to_page_info>:

//==================================
// [2] GET PAGE INFO OF PAGE VA:
//==================================
__inline__ struct PageInfoElement * to_page_info(uint32 va)
{
  8022e6:	55                   	push   %ebp
  8022e7:	89 e5                	mov    %esp,%ebp
  8022e9:	83 ec 18             	sub    $0x18,%esp
	int idxInPageInfoArr = (va - dynAllocStart) >> PGSHIFT;
  8022ec:	a1 64 c0 81 00       	mov    0x81c064,%eax
  8022f1:	8b 55 08             	mov    0x8(%ebp),%edx
  8022f4:	29 c2                	sub    %eax,%edx
  8022f6:	89 d0                	mov    %edx,%eax
  8022f8:	c1 e8 0c             	shr    $0xc,%eax
  8022fb:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if (idxInPageInfoArr < 0 || idxInPageInfoArr >= DYN_ALLOC_MAX_SIZE/PAGE_SIZE)
  8022fe:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802302:	78 09                	js     80230d <to_page_info+0x27>
  802304:	81 7d f4 ff 1f 00 00 	cmpl   $0x1fff,-0xc(%ebp)
  80230b:	7e 14                	jle    802321 <to_page_info+0x3b>
		panic("to_page_info called with invalid pa");
  80230d:	83 ec 04             	sub    $0x4,%esp
  802310:	68 50 39 80 00       	push   $0x803950
  802315:	6a 22                	push   $0x22
  802317:	68 37 39 80 00       	push   $0x803937
  80231c:	e8 37 e4 ff ff       	call   800758 <_panic>
	return &pageBlockInfoArr[idxInPageInfoArr];
  802321:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802324:	89 d0                	mov    %edx,%eax
  802326:	01 c0                	add    %eax,%eax
  802328:	01 d0                	add    %edx,%eax
  80232a:	c1 e0 02             	shl    $0x2,%eax
  80232d:	05 60 40 80 00       	add    $0x804060,%eax
}
  802332:	c9                   	leave  
  802333:	c3                   	ret    

00802334 <initialize_dynamic_allocator>:
//==================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================
bool is_initialized = 0;
void initialize_dynamic_allocator(uint32 daStart, uint32 daEnd)
{
  802334:	55                   	push   %ebp
  802335:	89 e5                	mov    %esp,%ebp
  802337:	83 ec 18             	sub    $0x18,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		assert(daEnd <= daStart + DYN_ALLOC_MAX_SIZE);
  80233a:	8b 45 08             	mov    0x8(%ebp),%eax
  80233d:	05 00 00 00 02       	add    $0x2000000,%eax
  802342:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802345:	73 16                	jae    80235d <initialize_dynamic_allocator+0x29>
  802347:	68 74 39 80 00       	push   $0x803974
  80234c:	68 9a 39 80 00       	push   $0x80399a
  802351:	6a 34                	push   $0x34
  802353:	68 37 39 80 00       	push   $0x803937
  802358:	e8 fb e3 ff ff       	call   800758 <_panic>
		is_initialized = 1;
  80235d:	c7 05 28 40 80 00 01 	movl   $0x1,0x804028
  802364:	00 00 00 
	//==================================================================================
	//==================================================================================
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #1 initialize_dynamic_allocator
	//Your code is here
	// init bounds of the dynalloc
	dynAllocStart = daStart;
  802367:	8b 45 08             	mov    0x8(%ebp),%eax
  80236a:	a3 64 c0 81 00       	mov    %eax,0x81c064
	dynAllocEnd = daEnd;
  80236f:	8b 45 0c             	mov    0xc(%ebp),%eax
  802372:	a3 40 40 80 00       	mov    %eax,0x804040
	// init the list that keep track of all free pageBlockInfoArr instances.
	LIST_INIT(&freePagesList);
  802377:	c7 05 48 40 80 00 00 	movl   $0x0,0x804048
  80237e:	00 00 00 
  802381:	c7 05 4c 40 80 00 00 	movl   $0x0,0x80404c
  802388:	00 00 00 
  80238b:	c7 05 54 40 80 00 00 	movl   $0x0,0x804054
  802392:	00 00 00 

	// no.of pages in the dynamic allocator.
	int pCount = (daEnd - daStart) / PAGE_SIZE;
  802395:	8b 45 0c             	mov    0xc(%ebp),%eax
  802398:	2b 45 08             	sub    0x8(%ebp),%eax
  80239b:	c1 e8 0c             	shr    $0xc,%eax
  80239e:	89 45 ec             	mov    %eax,-0x14(%ebp)
	// iterate over each page and init its data in pageBlockInfoArr and reset it.
	for (int i = 0; i < pCount; ++i) {
  8023a1:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  8023a8:	e9 c8 00 00 00       	jmp    802475 <initialize_dynamic_allocator+0x141>
	    pageBlockInfoArr[i].block_size = 0;
  8023ad:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8023b0:	89 d0                	mov    %edx,%eax
  8023b2:	01 c0                	add    %eax,%eax
  8023b4:	01 d0                	add    %edx,%eax
  8023b6:	c1 e0 02             	shl    $0x2,%eax
  8023b9:	05 68 40 80 00       	add    $0x804068,%eax
  8023be:	66 c7 00 00 00       	movw   $0x0,(%eax)
	    pageBlockInfoArr[i].num_of_free_blocks = 0;
  8023c3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8023c6:	89 d0                	mov    %edx,%eax
  8023c8:	01 c0                	add    %eax,%eax
  8023ca:	01 d0                	add    %edx,%eax
  8023cc:	c1 e0 02             	shl    $0x2,%eax
  8023cf:	05 6a 40 80 00       	add    $0x80406a,%eax
  8023d4:	66 c7 00 00 00       	movw   $0x0,(%eax)
	    LIST_INSERT_TAIL(&freePagesList, &pageBlockInfoArr[i]);
  8023d9:	8b 15 4c 40 80 00    	mov    0x80404c,%edx
  8023df:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  8023e2:	89 c8                	mov    %ecx,%eax
  8023e4:	01 c0                	add    %eax,%eax
  8023e6:	01 c8                	add    %ecx,%eax
  8023e8:	c1 e0 02             	shl    $0x2,%eax
  8023eb:	05 64 40 80 00       	add    $0x804064,%eax
  8023f0:	89 10                	mov    %edx,(%eax)
  8023f2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8023f5:	89 d0                	mov    %edx,%eax
  8023f7:	01 c0                	add    %eax,%eax
  8023f9:	01 d0                	add    %edx,%eax
  8023fb:	c1 e0 02             	shl    $0x2,%eax
  8023fe:	05 64 40 80 00       	add    $0x804064,%eax
  802403:	8b 00                	mov    (%eax),%eax
  802405:	85 c0                	test   %eax,%eax
  802407:	74 1b                	je     802424 <initialize_dynamic_allocator+0xf0>
  802409:	8b 15 4c 40 80 00    	mov    0x80404c,%edx
  80240f:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  802412:	89 c8                	mov    %ecx,%eax
  802414:	01 c0                	add    %eax,%eax
  802416:	01 c8                	add    %ecx,%eax
  802418:	c1 e0 02             	shl    $0x2,%eax
  80241b:	05 60 40 80 00       	add    $0x804060,%eax
  802420:	89 02                	mov    %eax,(%edx)
  802422:	eb 16                	jmp    80243a <initialize_dynamic_allocator+0x106>
  802424:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802427:	89 d0                	mov    %edx,%eax
  802429:	01 c0                	add    %eax,%eax
  80242b:	01 d0                	add    %edx,%eax
  80242d:	c1 e0 02             	shl    $0x2,%eax
  802430:	05 60 40 80 00       	add    $0x804060,%eax
  802435:	a3 48 40 80 00       	mov    %eax,0x804048
  80243a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80243d:	89 d0                	mov    %edx,%eax
  80243f:	01 c0                	add    %eax,%eax
  802441:	01 d0                	add    %edx,%eax
  802443:	c1 e0 02             	shl    $0x2,%eax
  802446:	05 60 40 80 00       	add    $0x804060,%eax
  80244b:	a3 4c 40 80 00       	mov    %eax,0x80404c
  802450:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802453:	89 d0                	mov    %edx,%eax
  802455:	01 c0                	add    %eax,%eax
  802457:	01 d0                	add    %edx,%eax
  802459:	c1 e0 02             	shl    $0x2,%eax
  80245c:	05 60 40 80 00       	add    $0x804060,%eax
  802461:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802467:	a1 54 40 80 00       	mov    0x804054,%eax
  80246c:	40                   	inc    %eax
  80246d:	a3 54 40 80 00       	mov    %eax,0x804054
	LIST_INIT(&freePagesList);

	// no.of pages in the dynamic allocator.
	int pCount = (daEnd - daStart) / PAGE_SIZE;
	// iterate over each page and init its data in pageBlockInfoArr and reset it.
	for (int i = 0; i < pCount; ++i) {
  802472:	ff 45 f4             	incl   -0xc(%ebp)
  802475:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802478:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  80247b:	0f 8c 2c ff ff ff    	jl     8023ad <initialize_dynamic_allocator+0x79>
	    LIST_INSERT_TAIL(&freePagesList, &pageBlockInfoArr[i]);
	}
	// init the array of lists of each size..
	// 8 16 32 64 128 256 512 1024 2056
	// 0 1  2  3   4  5    6   7    8
	for (int i = 0; i <= (LOG2_MAX_SIZE - LOG2_MIN_SIZE); ++i){
  802481:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  802488:	eb 36                	jmp    8024c0 <initialize_dynamic_allocator+0x18c>
		LIST_INIT(&freeBlockLists[i]);
  80248a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80248d:	c1 e0 04             	shl    $0x4,%eax
  802490:	05 80 c0 81 00       	add    $0x81c080,%eax
  802495:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80249b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80249e:	c1 e0 04             	shl    $0x4,%eax
  8024a1:	05 84 c0 81 00       	add    $0x81c084,%eax
  8024a6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8024ac:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024af:	c1 e0 04             	shl    $0x4,%eax
  8024b2:	05 8c c0 81 00       	add    $0x81c08c,%eax
  8024b7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	    LIST_INSERT_TAIL(&freePagesList, &pageBlockInfoArr[i]);
	}
	// init the array of lists of each size..
	// 8 16 32 64 128 256 512 1024 2056
	// 0 1  2  3   4  5    6   7    8
	for (int i = 0; i <= (LOG2_MAX_SIZE - LOG2_MIN_SIZE); ++i){
  8024bd:	ff 45 f0             	incl   -0x10(%ebp)
  8024c0:	83 7d f0 08          	cmpl   $0x8,-0x10(%ebp)
  8024c4:	7e c4                	jle    80248a <initialize_dynamic_allocator+0x156>
		LIST_INIT(&freeBlockLists[i]);
	}
	//Comment the following line
	//panic("initialize_dynamic_allocator() Not implemented yet");

}
  8024c6:	90                   	nop
  8024c7:	c9                   	leave  
  8024c8:	c3                   	ret    

008024c9 <get_block_size>:

//===========================
// [2] GET BLOCK SIZE:
//===========================
__inline__ uint32 get_block_size(void *va)
{
  8024c9:	55                   	push   %ebp
  8024ca:	89 e5                	mov    %esp,%ebp
  8024cc:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #2 get_block_size
	//Your code is here
	// get the page that saves this va
	struct PageInfoElement* ptr = to_page_info((uint32)va);
  8024cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8024d2:	83 ec 0c             	sub    $0xc,%esp
  8024d5:	50                   	push   %eax
  8024d6:	e8 0b fe ff ff       	call   8022e6 <to_page_info>
  8024db:	83 c4 10             	add    $0x10,%esp
  8024de:	89 45 f4             	mov    %eax,-0xc(%ebp)
	return ptr->block_size;
  8024e1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024e4:	8b 40 08             	mov    0x8(%eax),%eax
  8024e7:	0f b7 c0             	movzwl %ax,%eax
	//Comment the following line
	//panic("get_block_size() Not implemented yet");
}
  8024ea:	c9                   	leave  
  8024eb:	c3                   	ret    

008024ec <split_page_to_blocks>:
// =====================
// h) split page to blocks and add them in freeBlockLists
// =====================
// function that split the page provided into same sized blocks
//and putem in suitable freeblockList index according to size.
 void split_page_to_blocks(uint32 blk_size, struct PageInfoElement *pageInfo) {
  8024ec:	55                   	push   %ebp
  8024ed:	89 e5                	mov    %esp,%ebp
  8024ef:	83 ec 28             	sub    $0x28,%esp
	 // cur page virtual address by the pageInfo.
	 uint32 page_va = (uint32)to_page_va(pageInfo);
  8024f2:	83 ec 0c             	sub    $0xc,%esp
  8024f5:	ff 75 0c             	pushl  0xc(%ebp)
  8024f8:	e8 77 fd ff ff       	call   802274 <to_page_va>
  8024fd:	83 c4 10             	add    $0x10,%esp
  802500:	89 45 e8             	mov    %eax,-0x18(%ebp)
	 // no. of blks to save in freeblockList.
	 int blk_count = PAGE_SIZE / blk_size;
  802503:	b8 00 10 00 00       	mov    $0x1000,%eax
  802508:	ba 00 00 00 00       	mov    $0x0,%edx
  80250d:	f7 75 08             	divl   0x8(%ebp)
  802510:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	 // save page in memory.
	 get_page((uint32*)page_va);
  802513:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802516:	83 ec 0c             	sub    $0xc,%esp
  802519:	50                   	push   %eax
  80251a:	e8 48 f6 ff ff       	call   801b67 <get_page>
  80251f:	83 c4 10             	add    $0x10,%esp
	 // assigning the pageInfo data block size, free block which is whole block count.
	 pageInfo->num_of_free_blocks = blk_count;
  802522:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802525:	8b 55 0c             	mov    0xc(%ebp),%edx
  802528:	66 89 42 0a          	mov    %ax,0xa(%edx)
	 pageInfo->block_size = blk_size;
  80252c:	8b 45 08             	mov    0x8(%ebp),%eax
  80252f:	8b 55 0c             	mov    0xc(%ebp),%edx
  802532:	66 89 42 08          	mov    %ax,0x8(%edx)
	 // get index by size block in freeblocklist.
	 int idx = 0;
  802536:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	 for (int i = LOG2_MIN_SIZE; i <= LOG2_MAX_SIZE; i++) {
  80253d:	c7 45 f0 03 00 00 00 	movl   $0x3,-0x10(%ebp)
  802544:	eb 19                	jmp    80255f <split_page_to_blocks+0x73>
	     if ((1 << i) == blk_size)
  802546:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802549:	ba 01 00 00 00       	mov    $0x1,%edx
  80254e:	88 c1                	mov    %al,%cl
  802550:	d3 e2                	shl    %cl,%edx
  802552:	89 d0                	mov    %edx,%eax
  802554:	3b 45 08             	cmp    0x8(%ebp),%eax
  802557:	74 0e                	je     802567 <split_page_to_blocks+0x7b>
	         break;
	     idx++;
  802559:	ff 45 f4             	incl   -0xc(%ebp)
	 // assigning the pageInfo data block size, free block which is whole block count.
	 pageInfo->num_of_free_blocks = blk_count;
	 pageInfo->block_size = blk_size;
	 // get index by size block in freeblocklist.
	 int idx = 0;
	 for (int i = LOG2_MIN_SIZE; i <= LOG2_MAX_SIZE; i++) {
  80255c:	ff 45 f0             	incl   -0x10(%ebp)
  80255f:	83 7d f0 0b          	cmpl   $0xb,-0x10(%ebp)
  802563:	7e e1                	jle    802546 <split_page_to_blocks+0x5a>
  802565:	eb 01                	jmp    802568 <split_page_to_blocks+0x7c>
	     if ((1 << i) == blk_size)
	         break;
  802567:	90                   	nop
	     idx++;
	 }
	 // iterate over each blk and make and element of it by passing its address in blockElement pointer and save those in the list.
	 // starting from the page_va.
	 for (uint32 i = 0; i < blk_count; ++i) {
  802568:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  80256f:	e9 a7 00 00 00       	jmp    80261b <split_page_to_blocks+0x12f>
	     struct BlockElement *blk =(struct BlockElement*)(page_va + i * blk_size);
  802574:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802577:	0f af 45 08          	imul   0x8(%ebp),%eax
  80257b:	89 c2                	mov    %eax,%edx
  80257d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802580:	01 d0                	add    %edx,%eax
  802582:	89 45 e0             	mov    %eax,-0x20(%ebp)
	     LIST_INSERT_TAIL(&freeBlockLists[idx],blk);
  802585:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  802589:	75 14                	jne    80259f <split_page_to_blocks+0xb3>
  80258b:	83 ec 04             	sub    $0x4,%esp
  80258e:	68 b0 39 80 00       	push   $0x8039b0
  802593:	6a 7c                	push   $0x7c
  802595:	68 37 39 80 00       	push   $0x803937
  80259a:	e8 b9 e1 ff ff       	call   800758 <_panic>
  80259f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025a2:	c1 e0 04             	shl    $0x4,%eax
  8025a5:	05 84 c0 81 00       	add    $0x81c084,%eax
  8025aa:	8b 10                	mov    (%eax),%edx
  8025ac:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8025af:	89 50 04             	mov    %edx,0x4(%eax)
  8025b2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8025b5:	8b 40 04             	mov    0x4(%eax),%eax
  8025b8:	85 c0                	test   %eax,%eax
  8025ba:	74 14                	je     8025d0 <split_page_to_blocks+0xe4>
  8025bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025bf:	c1 e0 04             	shl    $0x4,%eax
  8025c2:	05 84 c0 81 00       	add    $0x81c084,%eax
  8025c7:	8b 00                	mov    (%eax),%eax
  8025c9:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8025cc:	89 10                	mov    %edx,(%eax)
  8025ce:	eb 11                	jmp    8025e1 <split_page_to_blocks+0xf5>
  8025d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025d3:	c1 e0 04             	shl    $0x4,%eax
  8025d6:	8d 90 80 c0 81 00    	lea    0x81c080(%eax),%edx
  8025dc:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8025df:	89 02                	mov    %eax,(%edx)
  8025e1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025e4:	c1 e0 04             	shl    $0x4,%eax
  8025e7:	8d 90 84 c0 81 00    	lea    0x81c084(%eax),%edx
  8025ed:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8025f0:	89 02                	mov    %eax,(%edx)
  8025f2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8025f5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8025fb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025fe:	c1 e0 04             	shl    $0x4,%eax
  802601:	05 8c c0 81 00       	add    $0x81c08c,%eax
  802606:	8b 00                	mov    (%eax),%eax
  802608:	8d 50 01             	lea    0x1(%eax),%edx
  80260b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80260e:	c1 e0 04             	shl    $0x4,%eax
  802611:	05 8c c0 81 00       	add    $0x81c08c,%eax
  802616:	89 10                	mov    %edx,(%eax)
	         break;
	     idx++;
	 }
	 // iterate over each blk and make and element of it by passing its address in blockElement pointer and save those in the list.
	 // starting from the page_va.
	 for (uint32 i = 0; i < blk_count; ++i) {
  802618:	ff 45 ec             	incl   -0x14(%ebp)
  80261b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80261e:	39 45 ec             	cmp    %eax,-0x14(%ebp)
  802621:	0f 82 4d ff ff ff    	jb     802574 <split_page_to_blocks+0x88>
	     struct BlockElement *blk =(struct BlockElement*)(page_va + i * blk_size);
	     LIST_INSERT_TAIL(&freeBlockLists[idx],blk);
	 }
 }
  802627:	90                   	nop
  802628:	c9                   	leave  
  802629:	c3                   	ret    

0080262a <alloc_block>:

//===========================
// 3) ALLOCATE BLOCK:
//===========================
void *alloc_block(uint32 size)
{
  80262a:	55                   	push   %ebp
  80262b:	89 e5                	mov    %esp,%ebp
  80262d:	83 ec 38             	sub    $0x38,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		assert(size <= DYN_ALLOC_MAX_BLOCK_SIZE);
  802630:	81 7d 08 00 08 00 00 	cmpl   $0x800,0x8(%ebp)
  802637:	76 19                	jbe    802652 <alloc_block+0x28>
  802639:	68 d4 39 80 00       	push   $0x8039d4
  80263e:	68 9a 39 80 00       	push   $0x80399a
  802643:	68 8a 00 00 00       	push   $0x8a
  802648:	68 37 39 80 00       	push   $0x803937
  80264d:	e8 06 e1 ff ff       	call   800758 <_panic>
	//==================================================================================
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #3 alloc_block
	//Your code is here
	//Comment the following line
	// get index in freeBlockList by size.
	uint32 idx = 0;
  802652:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int i = LOG2_MIN_SIZE; i <= LOG2_MAX_SIZE; ++i){
  802659:	c7 45 f0 03 00 00 00 	movl   $0x3,-0x10(%ebp)
  802660:	eb 19                	jmp    80267b <alloc_block+0x51>
		if((1 << i) >= size) break;
  802662:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802665:	ba 01 00 00 00       	mov    $0x1,%edx
  80266a:	88 c1                	mov    %al,%cl
  80266c:	d3 e2                	shl    %cl,%edx
  80266e:	89 d0                	mov    %edx,%eax
  802670:	3b 45 08             	cmp    0x8(%ebp),%eax
  802673:	73 0e                	jae    802683 <alloc_block+0x59>
		idx++;
  802675:	ff 45 f4             	incl   -0xc(%ebp)
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #3 alloc_block
	//Your code is here
	//Comment the following line
	// get index in freeBlockList by size.
	uint32 idx = 0;
	for (int i = LOG2_MIN_SIZE; i <= LOG2_MAX_SIZE; ++i){
  802678:	ff 45 f0             	incl   -0x10(%ebp)
  80267b:	83 7d f0 0b          	cmpl   $0xb,-0x10(%ebp)
  80267f:	7e e1                	jle    802662 <alloc_block+0x38>
  802681:	eb 01                	jmp    802684 <alloc_block+0x5a>
		if((1 << i) >= size) break;
  802683:	90                   	nop
		idx++;
	}

	//case 1: the free block of the cur size is available.
	if (freeBlockLists[idx].size > 0) {
  802684:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802687:	c1 e0 04             	shl    $0x4,%eax
  80268a:	05 8c c0 81 00       	add    $0x81c08c,%eax
  80268f:	8b 00                	mov    (%eax),%eax
  802691:	85 c0                	test   %eax,%eax
  802693:	0f 84 df 00 00 00    	je     802778 <alloc_block+0x14e>

		// remove from the list and updat the pageInfoArr free blocks.
		// pop from the freeBlockList.
		struct BlockElement *blk = LIST_FIRST(&freeBlockLists[idx]);
  802699:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80269c:	c1 e0 04             	shl    $0x4,%eax
  80269f:	05 80 c0 81 00       	add    $0x81c080,%eax
  8026a4:	8b 00                	mov    (%eax),%eax
  8026a6:	89 45 ec             	mov    %eax,-0x14(%ebp)
	    LIST_REMOVE(&freeBlockLists[idx], blk);
  8026a9:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8026ad:	75 17                	jne    8026c6 <alloc_block+0x9c>
  8026af:	83 ec 04             	sub    $0x4,%esp
  8026b2:	68 f5 39 80 00       	push   $0x8039f5
  8026b7:	68 9e 00 00 00       	push   $0x9e
  8026bc:	68 37 39 80 00       	push   $0x803937
  8026c1:	e8 92 e0 ff ff       	call   800758 <_panic>
  8026c6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8026c9:	8b 00                	mov    (%eax),%eax
  8026cb:	85 c0                	test   %eax,%eax
  8026cd:	74 10                	je     8026df <alloc_block+0xb5>
  8026cf:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8026d2:	8b 00                	mov    (%eax),%eax
  8026d4:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8026d7:	8b 52 04             	mov    0x4(%edx),%edx
  8026da:	89 50 04             	mov    %edx,0x4(%eax)
  8026dd:	eb 14                	jmp    8026f3 <alloc_block+0xc9>
  8026df:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8026e2:	8b 40 04             	mov    0x4(%eax),%eax
  8026e5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8026e8:	c1 e2 04             	shl    $0x4,%edx
  8026eb:	81 c2 84 c0 81 00    	add    $0x81c084,%edx
  8026f1:	89 02                	mov    %eax,(%edx)
  8026f3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8026f6:	8b 40 04             	mov    0x4(%eax),%eax
  8026f9:	85 c0                	test   %eax,%eax
  8026fb:	74 0f                	je     80270c <alloc_block+0xe2>
  8026fd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802700:	8b 40 04             	mov    0x4(%eax),%eax
  802703:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802706:	8b 12                	mov    (%edx),%edx
  802708:	89 10                	mov    %edx,(%eax)
  80270a:	eb 13                	jmp    80271f <alloc_block+0xf5>
  80270c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80270f:	8b 00                	mov    (%eax),%eax
  802711:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802714:	c1 e2 04             	shl    $0x4,%edx
  802717:	81 c2 80 c0 81 00    	add    $0x81c080,%edx
  80271d:	89 02                	mov    %eax,(%edx)
  80271f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802722:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802728:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80272b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802732:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802735:	c1 e0 04             	shl    $0x4,%eax
  802738:	05 8c c0 81 00       	add    $0x81c08c,%eax
  80273d:	8b 00                	mov    (%eax),%eax
  80273f:	8d 50 ff             	lea    -0x1(%eax),%edx
  802742:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802745:	c1 e0 04             	shl    $0x4,%eax
  802748:	05 8c c0 81 00       	add    $0x81c08c,%eax
  80274d:	89 10                	mov    %edx,(%eax)
	    // update pageBlockInfoArr
	    struct PageInfoElement *pageInfo = to_page_info((uint32)blk);
  80274f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802752:	83 ec 0c             	sub    $0xc,%esp
  802755:	50                   	push   %eax
  802756:	e8 8b fb ff ff       	call   8022e6 <to_page_info>
  80275b:	83 c4 10             	add    $0x10,%esp
  80275e:	89 45 e8             	mov    %eax,-0x18(%ebp)
	    pageInfo->num_of_free_blocks--;
  802761:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802764:	66 8b 40 0a          	mov    0xa(%eax),%ax
  802768:	48                   	dec    %eax
  802769:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80276c:	66 89 42 0a          	mov    %ax,0xa(%edx)
	    return blk;
  802770:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802773:	e9 bc 02 00 00       	jmp    802a34 <alloc_block+0x40a>
	}else{ //case(2, 3): 2. no free blocks available in the freeblocklist but there is free pages.
				//3. no free blocks and no available freepages so search in higher block sizes.
		// case 2:
		if(freePagesList.size > 0){ //have free pages.
  802778:	a1 54 40 80 00       	mov    0x804054,%eax
  80277d:	85 c0                	test   %eax,%eax
  80277f:	0f 84 7d 02 00 00    	je     802a02 <alloc_block+0x3d8>
			// get page to split and use from freepagesList.
			struct PageInfoElement *ptr_new_page = LIST_FIRST(&freePagesList);
  802785:	a1 48 40 80 00       	mov    0x804048,%eax
  80278a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			LIST_REMOVE(&freePagesList, ptr_new_page);
  80278d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  802791:	75 17                	jne    8027aa <alloc_block+0x180>
  802793:	83 ec 04             	sub    $0x4,%esp
  802796:	68 f5 39 80 00       	push   $0x8039f5
  80279b:	68 a9 00 00 00       	push   $0xa9
  8027a0:	68 37 39 80 00       	push   $0x803937
  8027a5:	e8 ae df ff ff       	call   800758 <_panic>
  8027aa:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8027ad:	8b 00                	mov    (%eax),%eax
  8027af:	85 c0                	test   %eax,%eax
  8027b1:	74 10                	je     8027c3 <alloc_block+0x199>
  8027b3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8027b6:	8b 00                	mov    (%eax),%eax
  8027b8:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8027bb:	8b 52 04             	mov    0x4(%edx),%edx
  8027be:	89 50 04             	mov    %edx,0x4(%eax)
  8027c1:	eb 0b                	jmp    8027ce <alloc_block+0x1a4>
  8027c3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8027c6:	8b 40 04             	mov    0x4(%eax),%eax
  8027c9:	a3 4c 40 80 00       	mov    %eax,0x80404c
  8027ce:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8027d1:	8b 40 04             	mov    0x4(%eax),%eax
  8027d4:	85 c0                	test   %eax,%eax
  8027d6:	74 0f                	je     8027e7 <alloc_block+0x1bd>
  8027d8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8027db:	8b 40 04             	mov    0x4(%eax),%eax
  8027de:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8027e1:	8b 12                	mov    (%edx),%edx
  8027e3:	89 10                	mov    %edx,(%eax)
  8027e5:	eb 0a                	jmp    8027f1 <alloc_block+0x1c7>
  8027e7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8027ea:	8b 00                	mov    (%eax),%eax
  8027ec:	a3 48 40 80 00       	mov    %eax,0x804048
  8027f1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8027f4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8027fa:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8027fd:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802804:	a1 54 40 80 00       	mov    0x804054,%eax
  802809:	48                   	dec    %eax
  80280a:	a3 54 40 80 00       	mov    %eax,0x804054
			// from page to freeblockList by the pageInfo and the block size.
			split_page_to_blocks(1 << (idx + LOG2_MIN_SIZE), ptr_new_page);
  80280f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802812:	83 c0 03             	add    $0x3,%eax
  802815:	ba 01 00 00 00       	mov    $0x1,%edx
  80281a:	88 c1                	mov    %al,%cl
  80281c:	d3 e2                	shl    %cl,%edx
  80281e:	89 d0                	mov    %edx,%eax
  802820:	83 ec 08             	sub    $0x8,%esp
  802823:	ff 75 e4             	pushl  -0x1c(%ebp)
  802826:	50                   	push   %eax
  802827:	e8 c0 fc ff ff       	call   8024ec <split_page_to_blocks>
  80282c:	83 c4 10             	add    $0x10,%esp

			// remove from the list and updat the pageInfoArr free blocks.
			// pop from the freeBlockList.
			struct BlockElement *blk = LIST_FIRST(&freeBlockLists[idx]);
  80282f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802832:	c1 e0 04             	shl    $0x4,%eax
  802835:	05 80 c0 81 00       	add    $0x81c080,%eax
  80283a:	8b 00                	mov    (%eax),%eax
  80283c:	89 45 e0             	mov    %eax,-0x20(%ebp)
		    LIST_REMOVE(&freeBlockLists[idx], blk);
  80283f:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  802843:	75 17                	jne    80285c <alloc_block+0x232>
  802845:	83 ec 04             	sub    $0x4,%esp
  802848:	68 f5 39 80 00       	push   $0x8039f5
  80284d:	68 b0 00 00 00       	push   $0xb0
  802852:	68 37 39 80 00       	push   $0x803937
  802857:	e8 fc de ff ff       	call   800758 <_panic>
  80285c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80285f:	8b 00                	mov    (%eax),%eax
  802861:	85 c0                	test   %eax,%eax
  802863:	74 10                	je     802875 <alloc_block+0x24b>
  802865:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802868:	8b 00                	mov    (%eax),%eax
  80286a:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80286d:	8b 52 04             	mov    0x4(%edx),%edx
  802870:	89 50 04             	mov    %edx,0x4(%eax)
  802873:	eb 14                	jmp    802889 <alloc_block+0x25f>
  802875:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802878:	8b 40 04             	mov    0x4(%eax),%eax
  80287b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80287e:	c1 e2 04             	shl    $0x4,%edx
  802881:	81 c2 84 c0 81 00    	add    $0x81c084,%edx
  802887:	89 02                	mov    %eax,(%edx)
  802889:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80288c:	8b 40 04             	mov    0x4(%eax),%eax
  80288f:	85 c0                	test   %eax,%eax
  802891:	74 0f                	je     8028a2 <alloc_block+0x278>
  802893:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802896:	8b 40 04             	mov    0x4(%eax),%eax
  802899:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80289c:	8b 12                	mov    (%edx),%edx
  80289e:	89 10                	mov    %edx,(%eax)
  8028a0:	eb 13                	jmp    8028b5 <alloc_block+0x28b>
  8028a2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8028a5:	8b 00                	mov    (%eax),%eax
  8028a7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8028aa:	c1 e2 04             	shl    $0x4,%edx
  8028ad:	81 c2 80 c0 81 00    	add    $0x81c080,%edx
  8028b3:	89 02                	mov    %eax,(%edx)
  8028b5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8028b8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8028be:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8028c1:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8028c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028cb:	c1 e0 04             	shl    $0x4,%eax
  8028ce:	05 8c c0 81 00       	add    $0x81c08c,%eax
  8028d3:	8b 00                	mov    (%eax),%eax
  8028d5:	8d 50 ff             	lea    -0x1(%eax),%edx
  8028d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028db:	c1 e0 04             	shl    $0x4,%eax
  8028de:	05 8c c0 81 00       	add    $0x81c08c,%eax
  8028e3:	89 10                	mov    %edx,(%eax)
		    // update pageBlockInfoArr
		    struct PageInfoElement *pageInfo = to_page_info((uint32)blk);
  8028e5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8028e8:	83 ec 0c             	sub    $0xc,%esp
  8028eb:	50                   	push   %eax
  8028ec:	e8 f5 f9 ff ff       	call   8022e6 <to_page_info>
  8028f1:	83 c4 10             	add    $0x10,%esp
  8028f4:	89 45 dc             	mov    %eax,-0x24(%ebp)
		    pageInfo->num_of_free_blocks--;
  8028f7:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8028fa:	66 8b 40 0a          	mov    0xa(%eax),%ax
  8028fe:	48                   	dec    %eax
  8028ff:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802902:	66 89 42 0a          	mov    %ax,0xa(%edx)
		    return blk;
  802906:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802909:	e9 26 01 00 00       	jmp    802a34 <alloc_block+0x40a>
		}else{//case 3: no free block and no free page so iterate and try to find bigger size.
			// iterate over the list until finding available block
			while (idx <= (LOG2_MAX_SIZE - LOG2_MIN_SIZE) && freeBlockLists[idx].size == 0) {
				idx++;
  80290e:	ff 45 f4             	incl   -0xc(%ebp)
				// found free block
				if(freeBlockLists[idx].size > 0){
  802911:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802914:	c1 e0 04             	shl    $0x4,%eax
  802917:	05 8c c0 81 00       	add    $0x81c08c,%eax
  80291c:	8b 00                	mov    (%eax),%eax
  80291e:	85 c0                	test   %eax,%eax
  802920:	0f 84 dc 00 00 00    	je     802a02 <alloc_block+0x3d8>
					// remove from the list and updat the pageInfoArr free blocks.
					// pop from the freeBlockList.
					struct BlockElement *blk = LIST_FIRST(&freeBlockLists[idx]);
  802926:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802929:	c1 e0 04             	shl    $0x4,%eax
  80292c:	05 80 c0 81 00       	add    $0x81c080,%eax
  802931:	8b 00                	mov    (%eax),%eax
  802933:	89 45 d8             	mov    %eax,-0x28(%ebp)
				    LIST_REMOVE(&freeBlockLists[idx], blk);
  802936:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  80293a:	75 17                	jne    802953 <alloc_block+0x329>
  80293c:	83 ec 04             	sub    $0x4,%esp
  80293f:	68 f5 39 80 00       	push   $0x8039f5
  802944:	68 be 00 00 00       	push   $0xbe
  802949:	68 37 39 80 00       	push   $0x803937
  80294e:	e8 05 de ff ff       	call   800758 <_panic>
  802953:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802956:	8b 00                	mov    (%eax),%eax
  802958:	85 c0                	test   %eax,%eax
  80295a:	74 10                	je     80296c <alloc_block+0x342>
  80295c:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80295f:	8b 00                	mov    (%eax),%eax
  802961:	8b 55 d8             	mov    -0x28(%ebp),%edx
  802964:	8b 52 04             	mov    0x4(%edx),%edx
  802967:	89 50 04             	mov    %edx,0x4(%eax)
  80296a:	eb 14                	jmp    802980 <alloc_block+0x356>
  80296c:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80296f:	8b 40 04             	mov    0x4(%eax),%eax
  802972:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802975:	c1 e2 04             	shl    $0x4,%edx
  802978:	81 c2 84 c0 81 00    	add    $0x81c084,%edx
  80297e:	89 02                	mov    %eax,(%edx)
  802980:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802983:	8b 40 04             	mov    0x4(%eax),%eax
  802986:	85 c0                	test   %eax,%eax
  802988:	74 0f                	je     802999 <alloc_block+0x36f>
  80298a:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80298d:	8b 40 04             	mov    0x4(%eax),%eax
  802990:	8b 55 d8             	mov    -0x28(%ebp),%edx
  802993:	8b 12                	mov    (%edx),%edx
  802995:	89 10                	mov    %edx,(%eax)
  802997:	eb 13                	jmp    8029ac <alloc_block+0x382>
  802999:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80299c:	8b 00                	mov    (%eax),%eax
  80299e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8029a1:	c1 e2 04             	shl    $0x4,%edx
  8029a4:	81 c2 80 c0 81 00    	add    $0x81c080,%edx
  8029aa:	89 02                	mov    %eax,(%edx)
  8029ac:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8029af:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8029b5:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8029b8:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8029bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029c2:	c1 e0 04             	shl    $0x4,%eax
  8029c5:	05 8c c0 81 00       	add    $0x81c08c,%eax
  8029ca:	8b 00                	mov    (%eax),%eax
  8029cc:	8d 50 ff             	lea    -0x1(%eax),%edx
  8029cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029d2:	c1 e0 04             	shl    $0x4,%eax
  8029d5:	05 8c c0 81 00       	add    $0x81c08c,%eax
  8029da:	89 10                	mov    %edx,(%eax)
				    // update pageBlockInfoArr
				    struct PageInfoElement *pageInfo = to_page_info((uint32)blk);
  8029dc:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8029df:	83 ec 0c             	sub    $0xc,%esp
  8029e2:	50                   	push   %eax
  8029e3:	e8 fe f8 ff ff       	call   8022e6 <to_page_info>
  8029e8:	83 c4 10             	add    $0x10,%esp
  8029eb:	89 45 d4             	mov    %eax,-0x2c(%ebp)
				    pageInfo->num_of_free_blocks--;
  8029ee:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8029f1:	66 8b 40 0a          	mov    0xa(%eax),%ax
  8029f5:	48                   	dec    %eax
  8029f6:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8029f9:	66 89 42 0a          	mov    %ax,0xa(%edx)
				    return blk;
  8029fd:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802a00:	eb 32                	jmp    802a34 <alloc_block+0x40a>
		    struct PageInfoElement *pageInfo = to_page_info((uint32)blk);
		    pageInfo->num_of_free_blocks--;
		    return blk;
		}else{//case 3: no free block and no free page so iterate and try to find bigger size.
			// iterate over the list until finding available block
			while (idx <= (LOG2_MAX_SIZE - LOG2_MIN_SIZE) && freeBlockLists[idx].size == 0) {
  802a02:	83 7d f4 08          	cmpl   $0x8,-0xc(%ebp)
  802a06:	77 15                	ja     802a1d <alloc_block+0x3f3>
  802a08:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a0b:	c1 e0 04             	shl    $0x4,%eax
  802a0e:	05 8c c0 81 00       	add    $0x81c08c,%eax
  802a13:	8b 00                	mov    (%eax),%eax
  802a15:	85 c0                	test   %eax,%eax
  802a17:	0f 84 f1 fe ff ff    	je     80290e <alloc_block+0x2e4>
				}
			}
		}
	}
	//case4: no free blocks or pages.
	panic("no free blocks!");
  802a1d:	83 ec 04             	sub    $0x4,%esp
  802a20:	68 13 3a 80 00       	push   $0x803a13
  802a25:	68 c8 00 00 00       	push   $0xc8
  802a2a:	68 37 39 80 00       	push   $0x803937
  802a2f:	e8 24 dd ff ff       	call   800758 <_panic>
	//panic("alloc_block() Not implemented yet");
	//TODO: [PROJECT'25.BONUS#1] DYNAMIC ALLOCATOR - block if no free block
	return NULL;
}
  802a34:	c9                   	leave  
  802a35:	c3                   	ret    

00802a36 <free_block>:

//===========================
// [4] FREE BLOCK:
//===========================
void free_block(void *va)
{
  802a36:	55                   	push   %ebp
  802a37:	89 e5                	mov    %esp,%ebp
  802a39:	83 ec 38             	sub    $0x38,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		assert((uint32)va >= dynAllocStart && (uint32)va < dynAllocEnd);
  802a3c:	8b 55 08             	mov    0x8(%ebp),%edx
  802a3f:	a1 64 c0 81 00       	mov    0x81c064,%eax
  802a44:	39 c2                	cmp    %eax,%edx
  802a46:	72 0c                	jb     802a54 <free_block+0x1e>
  802a48:	8b 55 08             	mov    0x8(%ebp),%edx
  802a4b:	a1 40 40 80 00       	mov    0x804040,%eax
  802a50:	39 c2                	cmp    %eax,%edx
  802a52:	72 19                	jb     802a6d <free_block+0x37>
  802a54:	68 24 3a 80 00       	push   $0x803a24
  802a59:	68 9a 39 80 00       	push   $0x80399a
  802a5e:	68 d7 00 00 00       	push   $0xd7
  802a63:	68 37 39 80 00       	push   $0x803937
  802a68:	e8 eb dc ff ff       	call   800758 <_panic>
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #4 free_block
	//Your code is here
	//Comment the following line
	// va of a piece in memory to free so:
	// 1. get its page, and make blk with this address to be put in the freeBlockList.
	struct BlockElement* blk_to_free = (struct BlockElement*)va;
  802a6d:	8b 45 08             	mov    0x8(%ebp),%eax
  802a70:	89 45 e8             	mov    %eax,-0x18(%ebp)
	struct PageInfoElement *pageInfo = to_page_info((uint32)va);
  802a73:	8b 45 08             	mov    0x8(%ebp),%eax
  802a76:	83 ec 0c             	sub    $0xc,%esp
  802a79:	50                   	push   %eax
  802a7a:	e8 67 f8 ff ff       	call   8022e6 <to_page_info>
  802a7f:	83 c4 10             	add    $0x10,%esp
  802a82:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	uint32 blk_size = pageInfo->block_size;
  802a85:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802a88:	8b 40 08             	mov    0x8(%eax),%eax
  802a8b:	0f b7 c0             	movzwl %ax,%eax
  802a8e:	89 45 e0             	mov    %eax,-0x20(%ebp)

	// its index in the freeBlocklist.
	int idx = 0;
  802a91:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int i = LOG2_MIN_SIZE; i <= LOG2_MAX_SIZE; i++) {
  802a98:	c7 45 f0 03 00 00 00 	movl   $0x3,-0x10(%ebp)
  802a9f:	eb 19                	jmp    802aba <free_block+0x84>
	    if ((1 << i) == blk_size)
  802aa1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802aa4:	ba 01 00 00 00       	mov    $0x1,%edx
  802aa9:	88 c1                	mov    %al,%cl
  802aab:	d3 e2                	shl    %cl,%edx
  802aad:	89 d0                	mov    %edx,%eax
  802aaf:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  802ab2:	74 0e                	je     802ac2 <free_block+0x8c>
	        break;
	    idx++;
  802ab4:	ff 45 f4             	incl   -0xc(%ebp)
	struct PageInfoElement *pageInfo = to_page_info((uint32)va);
	uint32 blk_size = pageInfo->block_size;

	// its index in the freeBlocklist.
	int idx = 0;
	for (int i = LOG2_MIN_SIZE; i <= LOG2_MAX_SIZE; i++) {
  802ab7:	ff 45 f0             	incl   -0x10(%ebp)
  802aba:	83 7d f0 0b          	cmpl   $0xb,-0x10(%ebp)
  802abe:	7e e1                	jle    802aa1 <free_block+0x6b>
  802ac0:	eb 01                	jmp    802ac3 <free_block+0x8d>
	    if ((1 << i) == blk_size)
	        break;
  802ac2:	90                   	nop
	    idx++;
	}

	pageInfo->num_of_free_blocks++;
  802ac3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802ac6:	66 8b 40 0a          	mov    0xa(%eax),%ax
  802aca:	40                   	inc    %eax
  802acb:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802ace:	66 89 42 0a          	mov    %ax,0xa(%edx)
	LIST_INSERT_TAIL(&freeBlockLists[idx], blk_to_free);
  802ad2:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802ad6:	75 17                	jne    802aef <free_block+0xb9>
  802ad8:	83 ec 04             	sub    $0x4,%esp
  802adb:	68 b0 39 80 00       	push   $0x8039b0
  802ae0:	68 ee 00 00 00       	push   $0xee
  802ae5:	68 37 39 80 00       	push   $0x803937
  802aea:	e8 69 dc ff ff       	call   800758 <_panic>
  802aef:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802af2:	c1 e0 04             	shl    $0x4,%eax
  802af5:	05 84 c0 81 00       	add    $0x81c084,%eax
  802afa:	8b 10                	mov    (%eax),%edx
  802afc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802aff:	89 50 04             	mov    %edx,0x4(%eax)
  802b02:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802b05:	8b 40 04             	mov    0x4(%eax),%eax
  802b08:	85 c0                	test   %eax,%eax
  802b0a:	74 14                	je     802b20 <free_block+0xea>
  802b0c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b0f:	c1 e0 04             	shl    $0x4,%eax
  802b12:	05 84 c0 81 00       	add    $0x81c084,%eax
  802b17:	8b 00                	mov    (%eax),%eax
  802b19:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802b1c:	89 10                	mov    %edx,(%eax)
  802b1e:	eb 11                	jmp    802b31 <free_block+0xfb>
  802b20:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b23:	c1 e0 04             	shl    $0x4,%eax
  802b26:	8d 90 80 c0 81 00    	lea    0x81c080(%eax),%edx
  802b2c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802b2f:	89 02                	mov    %eax,(%edx)
  802b31:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b34:	c1 e0 04             	shl    $0x4,%eax
  802b37:	8d 90 84 c0 81 00    	lea    0x81c084(%eax),%edx
  802b3d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802b40:	89 02                	mov    %eax,(%edx)
  802b42:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802b45:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802b4b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b4e:	c1 e0 04             	shl    $0x4,%eax
  802b51:	05 8c c0 81 00       	add    $0x81c08c,%eax
  802b56:	8b 00                	mov    (%eax),%eax
  802b58:	8d 50 01             	lea    0x1(%eax),%edx
  802b5b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b5e:	c1 e0 04             	shl    $0x4,%eax
  802b61:	05 8c c0 81 00       	add    $0x81c08c,%eax
  802b66:	89 10                	mov    %edx,(%eax)

	// now, case 1: the page all blocks are freed so you free the page.
	int blk_count = PAGE_SIZE / blk_size;
  802b68:	b8 00 10 00 00       	mov    $0x1000,%eax
  802b6d:	ba 00 00 00 00       	mov    $0x0,%edx
  802b72:	f7 75 e0             	divl   -0x20(%ebp)
  802b75:	89 45 dc             	mov    %eax,-0x24(%ebp)
	// the blk count in the page is same as number fo free blocks free up the page.
	if (pageInfo->num_of_free_blocks == blk_count) {
  802b78:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802b7b:	66 8b 40 0a          	mov    0xa(%eax),%ax
  802b7f:	0f b7 c0             	movzwl %ax,%eax
  802b82:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  802b85:	0f 85 70 01 00 00    	jne    802cfb <free_block+0x2c5>
		uint32 page_va = to_page_va(pageInfo);
  802b8b:	83 ec 0c             	sub    $0xc,%esp
  802b8e:	ff 75 e4             	pushl  -0x1c(%ebp)
  802b91:	e8 de f6 ff ff       	call   802274 <to_page_va>
  802b96:	83 c4 10             	add    $0x10,%esp
  802b99:	89 45 d8             	mov    %eax,-0x28(%ebp)
		// remove all blk in the freeBlockList.
		for (uint32 off = 0; off < PAGE_SIZE; off += blk_size) {
  802b9c:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  802ba3:	e9 b7 00 00 00       	jmp    802c5f <free_block+0x229>
			struct BlockElement *blk = (struct BlockElement*)(page_va + off);
  802ba8:	8b 55 d8             	mov    -0x28(%ebp),%edx
  802bab:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802bae:	01 d0                	add    %edx,%eax
  802bb0:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			LIST_REMOVE(&freeBlockLists[idx], blk);
  802bb3:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  802bb7:	75 17                	jne    802bd0 <free_block+0x19a>
  802bb9:	83 ec 04             	sub    $0x4,%esp
  802bbc:	68 f5 39 80 00       	push   $0x8039f5
  802bc1:	68 f8 00 00 00       	push   $0xf8
  802bc6:	68 37 39 80 00       	push   $0x803937
  802bcb:	e8 88 db ff ff       	call   800758 <_panic>
  802bd0:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802bd3:	8b 00                	mov    (%eax),%eax
  802bd5:	85 c0                	test   %eax,%eax
  802bd7:	74 10                	je     802be9 <free_block+0x1b3>
  802bd9:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802bdc:	8b 00                	mov    (%eax),%eax
  802bde:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  802be1:	8b 52 04             	mov    0x4(%edx),%edx
  802be4:	89 50 04             	mov    %edx,0x4(%eax)
  802be7:	eb 14                	jmp    802bfd <free_block+0x1c7>
  802be9:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802bec:	8b 40 04             	mov    0x4(%eax),%eax
  802bef:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802bf2:	c1 e2 04             	shl    $0x4,%edx
  802bf5:	81 c2 84 c0 81 00    	add    $0x81c084,%edx
  802bfb:	89 02                	mov    %eax,(%edx)
  802bfd:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802c00:	8b 40 04             	mov    0x4(%eax),%eax
  802c03:	85 c0                	test   %eax,%eax
  802c05:	74 0f                	je     802c16 <free_block+0x1e0>
  802c07:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802c0a:	8b 40 04             	mov    0x4(%eax),%eax
  802c0d:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  802c10:	8b 12                	mov    (%edx),%edx
  802c12:	89 10                	mov    %edx,(%eax)
  802c14:	eb 13                	jmp    802c29 <free_block+0x1f3>
  802c16:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802c19:	8b 00                	mov    (%eax),%eax
  802c1b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802c1e:	c1 e2 04             	shl    $0x4,%edx
  802c21:	81 c2 80 c0 81 00    	add    $0x81c080,%edx
  802c27:	89 02                	mov    %eax,(%edx)
  802c29:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802c2c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802c32:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802c35:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802c3c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c3f:	c1 e0 04             	shl    $0x4,%eax
  802c42:	05 8c c0 81 00       	add    $0x81c08c,%eax
  802c47:	8b 00                	mov    (%eax),%eax
  802c49:	8d 50 ff             	lea    -0x1(%eax),%edx
  802c4c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c4f:	c1 e0 04             	shl    $0x4,%eax
  802c52:	05 8c c0 81 00       	add    $0x81c08c,%eax
  802c57:	89 10                	mov    %edx,(%eax)
	int blk_count = PAGE_SIZE / blk_size;
	// the blk count in the page is same as number fo free blocks free up the page.
	if (pageInfo->num_of_free_blocks == blk_count) {
		uint32 page_va = to_page_va(pageInfo);
		// remove all blk in the freeBlockList.
		for (uint32 off = 0; off < PAGE_SIZE; off += blk_size) {
  802c59:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802c5c:	01 45 ec             	add    %eax,-0x14(%ebp)
  802c5f:	81 7d ec ff 0f 00 00 	cmpl   $0xfff,-0x14(%ebp)
  802c66:	0f 86 3c ff ff ff    	jbe    802ba8 <free_block+0x172>
			struct BlockElement *blk = (struct BlockElement*)(page_va + off);
			LIST_REMOVE(&freeBlockLists[idx], blk);
		}
		// reset page info.
		pageInfo->block_size = 0;
  802c6c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802c6f:	66 c7 40 08 00 00    	movw   $0x0,0x8(%eax)
		pageInfo->num_of_free_blocks = 0;
  802c75:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802c78:	66 c7 40 0a 00 00    	movw   $0x0,0xa(%eax)
		// add it to the available pages.
		LIST_INSERT_TAIL(&freePagesList, pageInfo);
  802c7e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  802c82:	75 17                	jne    802c9b <free_block+0x265>
  802c84:	83 ec 04             	sub    $0x4,%esp
  802c87:	68 b0 39 80 00       	push   $0x8039b0
  802c8c:	68 fe 00 00 00       	push   $0xfe
  802c91:	68 37 39 80 00       	push   $0x803937
  802c96:	e8 bd da ff ff       	call   800758 <_panic>
  802c9b:	8b 15 4c 40 80 00    	mov    0x80404c,%edx
  802ca1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802ca4:	89 50 04             	mov    %edx,0x4(%eax)
  802ca7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802caa:	8b 40 04             	mov    0x4(%eax),%eax
  802cad:	85 c0                	test   %eax,%eax
  802caf:	74 0c                	je     802cbd <free_block+0x287>
  802cb1:	a1 4c 40 80 00       	mov    0x80404c,%eax
  802cb6:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802cb9:	89 10                	mov    %edx,(%eax)
  802cbb:	eb 08                	jmp    802cc5 <free_block+0x28f>
  802cbd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802cc0:	a3 48 40 80 00       	mov    %eax,0x804048
  802cc5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802cc8:	a3 4c 40 80 00       	mov    %eax,0x80404c
  802ccd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802cd0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802cd6:	a1 54 40 80 00       	mov    0x804054,%eax
  802cdb:	40                   	inc    %eax
  802cdc:	a3 54 40 80 00       	mov    %eax,0x804054
		// make it available in memory.
		return_page((uint32 *)to_page_va(pageInfo));
  802ce1:	83 ec 0c             	sub    $0xc,%esp
  802ce4:	ff 75 e4             	pushl  -0x1c(%ebp)
  802ce7:	e8 88 f5 ff ff       	call   802274 <to_page_va>
  802cec:	83 c4 10             	add    $0x10,%esp
  802cef:	83 ec 0c             	sub    $0xc,%esp
  802cf2:	50                   	push   %eax
  802cf3:	e8 b8 ee ff ff       	call   801bb0 <return_page>
  802cf8:	83 c4 10             	add    $0x10,%esp
	}
	//panic("free_block() Not implemented yet");
}
  802cfb:	90                   	nop
  802cfc:	c9                   	leave  
  802cfd:	c3                   	ret    

00802cfe <realloc_block>:

//===========================
// [1] REALLOCATE BLOCK:
//===========================
void *realloc_block(void* va, uint32 new_size)
{
  802cfe:	55                   	push   %ebp
  802cff:	89 e5                	mov    %esp,%ebp
  802d01:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.BONUS#2] KERNEL REALLOC - realloc_block
	//Your code is here
	//Comment the following line
	panic("realloc_block() Not implemented yet");
  802d04:	83 ec 04             	sub    $0x4,%esp
  802d07:	68 5c 3a 80 00       	push   $0x803a5c
  802d0c:	68 11 01 00 00       	push   $0x111
  802d11:	68 37 39 80 00       	push   $0x803937
  802d16:	e8 3d da ff ff       	call   800758 <_panic>
  802d1b:	90                   	nop

00802d1c <__udivdi3>:
  802d1c:	55                   	push   %ebp
  802d1d:	57                   	push   %edi
  802d1e:	56                   	push   %esi
  802d1f:	53                   	push   %ebx
  802d20:	83 ec 1c             	sub    $0x1c,%esp
  802d23:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  802d27:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  802d2b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  802d2f:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802d33:	89 ca                	mov    %ecx,%edx
  802d35:	89 f8                	mov    %edi,%eax
  802d37:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  802d3b:	85 f6                	test   %esi,%esi
  802d3d:	75 2d                	jne    802d6c <__udivdi3+0x50>
  802d3f:	39 cf                	cmp    %ecx,%edi
  802d41:	77 65                	ja     802da8 <__udivdi3+0x8c>
  802d43:	89 fd                	mov    %edi,%ebp
  802d45:	85 ff                	test   %edi,%edi
  802d47:	75 0b                	jne    802d54 <__udivdi3+0x38>
  802d49:	b8 01 00 00 00       	mov    $0x1,%eax
  802d4e:	31 d2                	xor    %edx,%edx
  802d50:	f7 f7                	div    %edi
  802d52:	89 c5                	mov    %eax,%ebp
  802d54:	31 d2                	xor    %edx,%edx
  802d56:	89 c8                	mov    %ecx,%eax
  802d58:	f7 f5                	div    %ebp
  802d5a:	89 c1                	mov    %eax,%ecx
  802d5c:	89 d8                	mov    %ebx,%eax
  802d5e:	f7 f5                	div    %ebp
  802d60:	89 cf                	mov    %ecx,%edi
  802d62:	89 fa                	mov    %edi,%edx
  802d64:	83 c4 1c             	add    $0x1c,%esp
  802d67:	5b                   	pop    %ebx
  802d68:	5e                   	pop    %esi
  802d69:	5f                   	pop    %edi
  802d6a:	5d                   	pop    %ebp
  802d6b:	c3                   	ret    
  802d6c:	39 ce                	cmp    %ecx,%esi
  802d6e:	77 28                	ja     802d98 <__udivdi3+0x7c>
  802d70:	0f bd fe             	bsr    %esi,%edi
  802d73:	83 f7 1f             	xor    $0x1f,%edi
  802d76:	75 40                	jne    802db8 <__udivdi3+0x9c>
  802d78:	39 ce                	cmp    %ecx,%esi
  802d7a:	72 0a                	jb     802d86 <__udivdi3+0x6a>
  802d7c:	3b 44 24 08          	cmp    0x8(%esp),%eax
  802d80:	0f 87 9e 00 00 00    	ja     802e24 <__udivdi3+0x108>
  802d86:	b8 01 00 00 00       	mov    $0x1,%eax
  802d8b:	89 fa                	mov    %edi,%edx
  802d8d:	83 c4 1c             	add    $0x1c,%esp
  802d90:	5b                   	pop    %ebx
  802d91:	5e                   	pop    %esi
  802d92:	5f                   	pop    %edi
  802d93:	5d                   	pop    %ebp
  802d94:	c3                   	ret    
  802d95:	8d 76 00             	lea    0x0(%esi),%esi
  802d98:	31 ff                	xor    %edi,%edi
  802d9a:	31 c0                	xor    %eax,%eax
  802d9c:	89 fa                	mov    %edi,%edx
  802d9e:	83 c4 1c             	add    $0x1c,%esp
  802da1:	5b                   	pop    %ebx
  802da2:	5e                   	pop    %esi
  802da3:	5f                   	pop    %edi
  802da4:	5d                   	pop    %ebp
  802da5:	c3                   	ret    
  802da6:	66 90                	xchg   %ax,%ax
  802da8:	89 d8                	mov    %ebx,%eax
  802daa:	f7 f7                	div    %edi
  802dac:	31 ff                	xor    %edi,%edi
  802dae:	89 fa                	mov    %edi,%edx
  802db0:	83 c4 1c             	add    $0x1c,%esp
  802db3:	5b                   	pop    %ebx
  802db4:	5e                   	pop    %esi
  802db5:	5f                   	pop    %edi
  802db6:	5d                   	pop    %ebp
  802db7:	c3                   	ret    
  802db8:	bd 20 00 00 00       	mov    $0x20,%ebp
  802dbd:	89 eb                	mov    %ebp,%ebx
  802dbf:	29 fb                	sub    %edi,%ebx
  802dc1:	89 f9                	mov    %edi,%ecx
  802dc3:	d3 e6                	shl    %cl,%esi
  802dc5:	89 c5                	mov    %eax,%ebp
  802dc7:	88 d9                	mov    %bl,%cl
  802dc9:	d3 ed                	shr    %cl,%ebp
  802dcb:	89 e9                	mov    %ebp,%ecx
  802dcd:	09 f1                	or     %esi,%ecx
  802dcf:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  802dd3:	89 f9                	mov    %edi,%ecx
  802dd5:	d3 e0                	shl    %cl,%eax
  802dd7:	89 c5                	mov    %eax,%ebp
  802dd9:	89 d6                	mov    %edx,%esi
  802ddb:	88 d9                	mov    %bl,%cl
  802ddd:	d3 ee                	shr    %cl,%esi
  802ddf:	89 f9                	mov    %edi,%ecx
  802de1:	d3 e2                	shl    %cl,%edx
  802de3:	8b 44 24 08          	mov    0x8(%esp),%eax
  802de7:	88 d9                	mov    %bl,%cl
  802de9:	d3 e8                	shr    %cl,%eax
  802deb:	09 c2                	or     %eax,%edx
  802ded:	89 d0                	mov    %edx,%eax
  802def:	89 f2                	mov    %esi,%edx
  802df1:	f7 74 24 0c          	divl   0xc(%esp)
  802df5:	89 d6                	mov    %edx,%esi
  802df7:	89 c3                	mov    %eax,%ebx
  802df9:	f7 e5                	mul    %ebp
  802dfb:	39 d6                	cmp    %edx,%esi
  802dfd:	72 19                	jb     802e18 <__udivdi3+0xfc>
  802dff:	74 0b                	je     802e0c <__udivdi3+0xf0>
  802e01:	89 d8                	mov    %ebx,%eax
  802e03:	31 ff                	xor    %edi,%edi
  802e05:	e9 58 ff ff ff       	jmp    802d62 <__udivdi3+0x46>
  802e0a:	66 90                	xchg   %ax,%ax
  802e0c:	8b 54 24 08          	mov    0x8(%esp),%edx
  802e10:	89 f9                	mov    %edi,%ecx
  802e12:	d3 e2                	shl    %cl,%edx
  802e14:	39 c2                	cmp    %eax,%edx
  802e16:	73 e9                	jae    802e01 <__udivdi3+0xe5>
  802e18:	8d 43 ff             	lea    -0x1(%ebx),%eax
  802e1b:	31 ff                	xor    %edi,%edi
  802e1d:	e9 40 ff ff ff       	jmp    802d62 <__udivdi3+0x46>
  802e22:	66 90                	xchg   %ax,%ax
  802e24:	31 c0                	xor    %eax,%eax
  802e26:	e9 37 ff ff ff       	jmp    802d62 <__udivdi3+0x46>
  802e2b:	90                   	nop

00802e2c <__umoddi3>:
  802e2c:	55                   	push   %ebp
  802e2d:	57                   	push   %edi
  802e2e:	56                   	push   %esi
  802e2f:	53                   	push   %ebx
  802e30:	83 ec 1c             	sub    $0x1c,%esp
  802e33:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  802e37:	8b 74 24 34          	mov    0x34(%esp),%esi
  802e3b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  802e3f:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  802e43:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802e47:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802e4b:	89 f3                	mov    %esi,%ebx
  802e4d:	89 fa                	mov    %edi,%edx
  802e4f:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  802e53:	89 34 24             	mov    %esi,(%esp)
  802e56:	85 c0                	test   %eax,%eax
  802e58:	75 1a                	jne    802e74 <__umoddi3+0x48>
  802e5a:	39 f7                	cmp    %esi,%edi
  802e5c:	0f 86 a2 00 00 00    	jbe    802f04 <__umoddi3+0xd8>
  802e62:	89 c8                	mov    %ecx,%eax
  802e64:	89 f2                	mov    %esi,%edx
  802e66:	f7 f7                	div    %edi
  802e68:	89 d0                	mov    %edx,%eax
  802e6a:	31 d2                	xor    %edx,%edx
  802e6c:	83 c4 1c             	add    $0x1c,%esp
  802e6f:	5b                   	pop    %ebx
  802e70:	5e                   	pop    %esi
  802e71:	5f                   	pop    %edi
  802e72:	5d                   	pop    %ebp
  802e73:	c3                   	ret    
  802e74:	39 f0                	cmp    %esi,%eax
  802e76:	0f 87 ac 00 00 00    	ja     802f28 <__umoddi3+0xfc>
  802e7c:	0f bd e8             	bsr    %eax,%ebp
  802e7f:	83 f5 1f             	xor    $0x1f,%ebp
  802e82:	0f 84 ac 00 00 00    	je     802f34 <__umoddi3+0x108>
  802e88:	bf 20 00 00 00       	mov    $0x20,%edi
  802e8d:	29 ef                	sub    %ebp,%edi
  802e8f:	89 fe                	mov    %edi,%esi
  802e91:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802e95:	89 e9                	mov    %ebp,%ecx
  802e97:	d3 e0                	shl    %cl,%eax
  802e99:	89 d7                	mov    %edx,%edi
  802e9b:	89 f1                	mov    %esi,%ecx
  802e9d:	d3 ef                	shr    %cl,%edi
  802e9f:	09 c7                	or     %eax,%edi
  802ea1:	89 e9                	mov    %ebp,%ecx
  802ea3:	d3 e2                	shl    %cl,%edx
  802ea5:	89 14 24             	mov    %edx,(%esp)
  802ea8:	89 d8                	mov    %ebx,%eax
  802eaa:	d3 e0                	shl    %cl,%eax
  802eac:	89 c2                	mov    %eax,%edx
  802eae:	8b 44 24 08          	mov    0x8(%esp),%eax
  802eb2:	d3 e0                	shl    %cl,%eax
  802eb4:	89 44 24 04          	mov    %eax,0x4(%esp)
  802eb8:	8b 44 24 08          	mov    0x8(%esp),%eax
  802ebc:	89 f1                	mov    %esi,%ecx
  802ebe:	d3 e8                	shr    %cl,%eax
  802ec0:	09 d0                	or     %edx,%eax
  802ec2:	d3 eb                	shr    %cl,%ebx
  802ec4:	89 da                	mov    %ebx,%edx
  802ec6:	f7 f7                	div    %edi
  802ec8:	89 d3                	mov    %edx,%ebx
  802eca:	f7 24 24             	mull   (%esp)
  802ecd:	89 c6                	mov    %eax,%esi
  802ecf:	89 d1                	mov    %edx,%ecx
  802ed1:	39 d3                	cmp    %edx,%ebx
  802ed3:	0f 82 87 00 00 00    	jb     802f60 <__umoddi3+0x134>
  802ed9:	0f 84 91 00 00 00    	je     802f70 <__umoddi3+0x144>
  802edf:	8b 54 24 04          	mov    0x4(%esp),%edx
  802ee3:	29 f2                	sub    %esi,%edx
  802ee5:	19 cb                	sbb    %ecx,%ebx
  802ee7:	89 d8                	mov    %ebx,%eax
  802ee9:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  802eed:	d3 e0                	shl    %cl,%eax
  802eef:	89 e9                	mov    %ebp,%ecx
  802ef1:	d3 ea                	shr    %cl,%edx
  802ef3:	09 d0                	or     %edx,%eax
  802ef5:	89 e9                	mov    %ebp,%ecx
  802ef7:	d3 eb                	shr    %cl,%ebx
  802ef9:	89 da                	mov    %ebx,%edx
  802efb:	83 c4 1c             	add    $0x1c,%esp
  802efe:	5b                   	pop    %ebx
  802eff:	5e                   	pop    %esi
  802f00:	5f                   	pop    %edi
  802f01:	5d                   	pop    %ebp
  802f02:	c3                   	ret    
  802f03:	90                   	nop
  802f04:	89 fd                	mov    %edi,%ebp
  802f06:	85 ff                	test   %edi,%edi
  802f08:	75 0b                	jne    802f15 <__umoddi3+0xe9>
  802f0a:	b8 01 00 00 00       	mov    $0x1,%eax
  802f0f:	31 d2                	xor    %edx,%edx
  802f11:	f7 f7                	div    %edi
  802f13:	89 c5                	mov    %eax,%ebp
  802f15:	89 f0                	mov    %esi,%eax
  802f17:	31 d2                	xor    %edx,%edx
  802f19:	f7 f5                	div    %ebp
  802f1b:	89 c8                	mov    %ecx,%eax
  802f1d:	f7 f5                	div    %ebp
  802f1f:	89 d0                	mov    %edx,%eax
  802f21:	e9 44 ff ff ff       	jmp    802e6a <__umoddi3+0x3e>
  802f26:	66 90                	xchg   %ax,%ax
  802f28:	89 c8                	mov    %ecx,%eax
  802f2a:	89 f2                	mov    %esi,%edx
  802f2c:	83 c4 1c             	add    $0x1c,%esp
  802f2f:	5b                   	pop    %ebx
  802f30:	5e                   	pop    %esi
  802f31:	5f                   	pop    %edi
  802f32:	5d                   	pop    %ebp
  802f33:	c3                   	ret    
  802f34:	3b 04 24             	cmp    (%esp),%eax
  802f37:	72 06                	jb     802f3f <__umoddi3+0x113>
  802f39:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  802f3d:	77 0f                	ja     802f4e <__umoddi3+0x122>
  802f3f:	89 f2                	mov    %esi,%edx
  802f41:	29 f9                	sub    %edi,%ecx
  802f43:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  802f47:	89 14 24             	mov    %edx,(%esp)
  802f4a:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  802f4e:	8b 44 24 04          	mov    0x4(%esp),%eax
  802f52:	8b 14 24             	mov    (%esp),%edx
  802f55:	83 c4 1c             	add    $0x1c,%esp
  802f58:	5b                   	pop    %ebx
  802f59:	5e                   	pop    %esi
  802f5a:	5f                   	pop    %edi
  802f5b:	5d                   	pop    %ebp
  802f5c:	c3                   	ret    
  802f5d:	8d 76 00             	lea    0x0(%esi),%esi
  802f60:	2b 04 24             	sub    (%esp),%eax
  802f63:	19 fa                	sbb    %edi,%edx
  802f65:	89 d1                	mov    %edx,%ecx
  802f67:	89 c6                	mov    %eax,%esi
  802f69:	e9 71 ff ff ff       	jmp    802edf <__umoddi3+0xb3>
  802f6e:	66 90                	xchg   %ax,%ax
  802f70:	39 44 24 04          	cmp    %eax,0x4(%esp)
  802f74:	72 ea                	jb     802f60 <__umoddi3+0x134>
  802f76:	89 d9                	mov    %ebx,%ecx
  802f78:	e9 62 ff ff ff       	jmp    802edf <__umoddi3+0xb3>
