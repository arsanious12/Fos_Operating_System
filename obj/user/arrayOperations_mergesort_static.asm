
obj/user/arrayOperations_mergesort_static:     file format elf32-i386


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
  800031:	e8 91 04 00 00       	call   8004c7 <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:

//int *Left;
//int *Right;

void _main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	83 ec 38             	sub    $0x38,%esp
	int32 parentenvID = sys_getparentenvid();
  80003e:	e8 c6 1a 00 00       	call   801b09 <sys_getparentenvid>
  800043:	89 45 f0             	mov    %eax,-0x10(%ebp)

	int ret;

	/*[1] GET SEMAPHORES*/
	struct semaphore ready = get_semaphore(parentenvID, "Ready");
  800046:	8d 45 dc             	lea    -0x24(%ebp),%eax
  800049:	83 ec 04             	sub    $0x4,%esp
  80004c:	68 20 2d 80 00       	push   $0x802d20
  800051:	ff 75 f0             	pushl  -0x10(%ebp)
  800054:	50                   	push   %eax
  800055:	e8 19 28 00 00       	call   802873 <get_semaphore>
  80005a:	83 c4 0c             	add    $0xc,%esp
	struct semaphore finished = get_semaphore(parentenvID, "Finished");
  80005d:	8d 45 d8             	lea    -0x28(%ebp),%eax
  800060:	83 ec 04             	sub    $0x4,%esp
  800063:	68 26 2d 80 00       	push   $0x802d26
  800068:	ff 75 f0             	pushl  -0x10(%ebp)
  80006b:	50                   	push   %eax
  80006c:	e8 02 28 00 00       	call   802873 <get_semaphore>
  800071:	83 c4 0c             	add    $0xc,%esp

	/*[2] WAIT A READY SIGNAL FROM THE MASTER*/
	wait_semaphore(ready);
  800074:	83 ec 0c             	sub    $0xc,%esp
  800077:	ff 75 dc             	pushl  -0x24(%ebp)
  80007a:	e8 0e 28 00 00       	call   80288d <wait_semaphore>
  80007f:	83 c4 10             	add    $0x10,%esp

	/*[3] GET SHARED VARs*/
	//Get the cons_mutex ownerID
	int* consMutexOwnerID = sget(parentenvID, "cons_mutex ownerID") ;
  800082:	83 ec 08             	sub    $0x8,%esp
  800085:	68 2f 2d 80 00       	push   $0x802d2f
  80008a:	ff 75 f0             	pushl  -0x10(%ebp)
  80008d:	e8 18 17 00 00       	call   8017aa <sget>
  800092:	83 c4 10             	add    $0x10,%esp
  800095:	89 45 ec             	mov    %eax,-0x14(%ebp)
	struct semaphore cons_mutex = get_semaphore(*consMutexOwnerID, "Console Mutex");
  800098:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80009b:	8b 10                	mov    (%eax),%edx
  80009d:	8d 45 d4             	lea    -0x2c(%ebp),%eax
  8000a0:	83 ec 04             	sub    $0x4,%esp
  8000a3:	68 42 2d 80 00       	push   $0x802d42
  8000a8:	52                   	push   %edx
  8000a9:	50                   	push   %eax
  8000aa:	e8 c4 27 00 00       	call   802873 <get_semaphore>
  8000af:	83 c4 0c             	add    $0xc,%esp

	//Get the shared array & its size
	int *numOfElements = NULL;
  8000b2:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	int *sharedArray = NULL;
  8000b9:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	sharedArray = sget(parentenvID, "arr") ;
  8000c0:	83 ec 08             	sub    $0x8,%esp
  8000c3:	68 50 2d 80 00       	push   $0x802d50
  8000c8:	ff 75 f0             	pushl  -0x10(%ebp)
  8000cb:	e8 da 16 00 00       	call   8017aa <sget>
  8000d0:	83 c4 10             	add    $0x10,%esp
  8000d3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	numOfElements = sget(parentenvID, "arrSize") ;
  8000d6:	83 ec 08             	sub    $0x8,%esp
  8000d9:	68 54 2d 80 00       	push   $0x802d54
  8000de:	ff 75 f0             	pushl  -0x10(%ebp)
  8000e1:	e8 c4 16 00 00       	call   8017aa <sget>
  8000e6:	83 c4 10             	add    $0x10,%esp
  8000e9:	89 45 e8             	mov    %eax,-0x18(%ebp)

	/*[4] DO THE JOB*/
	//take a copy from the original array
	int *sortedArray;

	sortedArray = smalloc("mergesortedArr", sizeof(int) * *numOfElements, 0) ;
  8000ec:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8000ef:	8b 00                	mov    (%eax),%eax
  8000f1:	c1 e0 02             	shl    $0x2,%eax
  8000f4:	83 ec 04             	sub    $0x4,%esp
  8000f7:	6a 00                	push   $0x0
  8000f9:	50                   	push   %eax
  8000fa:	68 5c 2d 80 00       	push   $0x802d5c
  8000ff:	e8 72 16 00 00       	call   801776 <smalloc>
  800104:	83 c4 10             	add    $0x10,%esp
  800107:	89 45 e0             	mov    %eax,-0x20(%ebp)
	int i ;
	for (i = 0 ; i < *numOfElements ; i++)
  80010a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  800111:	eb 25                	jmp    800138 <_main+0x100>
	{
		sortedArray[i] = sharedArray[i];
  800113:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800116:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80011d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800120:	01 c2                	add    %eax,%edx
  800122:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800125:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  80012c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80012f:	01 c8                	add    %ecx,%eax
  800131:	8b 00                	mov    (%eax),%eax
  800133:	89 02                	mov    %eax,(%edx)
	//take a copy from the original array
	int *sortedArray;

	sortedArray = smalloc("mergesortedArr", sizeof(int) * *numOfElements, 0) ;
	int i ;
	for (i = 0 ; i < *numOfElements ; i++)
  800135:	ff 45 f4             	incl   -0xc(%ebp)
  800138:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80013b:	8b 00                	mov    (%eax),%eax
  80013d:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  800140:	7f d1                	jg     800113 <_main+0xdb>
	}
//	//Create two temps array for "left" & "right"
//	Left = smalloc("mergesortLeftArr", sizeof(int) * (*numOfElements), 1) ;
//	Right = smalloc("mergesortRightArr", sizeof(int) * (*numOfElements), 1) ;

	MSort(sortedArray, 1, *numOfElements);
  800142:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800145:	8b 00                	mov    (%eax),%eax
  800147:	83 ec 04             	sub    $0x4,%esp
  80014a:	50                   	push   %eax
  80014b:	6a 01                	push   $0x1
  80014d:	ff 75 e0             	pushl  -0x20(%ebp)
  800150:	e8 39 01 00 00       	call   80028e <MSort>
  800155:	83 c4 10             	add    $0x10,%esp

	wait_semaphore(cons_mutex);
  800158:	83 ec 0c             	sub    $0xc,%esp
  80015b:	ff 75 d4             	pushl  -0x2c(%ebp)
  80015e:	e8 2a 27 00 00       	call   80288d <wait_semaphore>
  800163:	83 c4 10             	add    $0x10,%esp
	{
		cprintf("Merge sort is Finished!!!!\n") ;
  800166:	83 ec 0c             	sub    $0xc,%esp
  800169:	68 6b 2d 80 00       	push   $0x802d6b
  80016e:	e8 f9 05 00 00       	call   80076c <cprintf>
  800173:	83 c4 10             	add    $0x10,%esp
		cprintf("will notify the master now...\n");
  800176:	83 ec 0c             	sub    $0xc,%esp
  800179:	68 88 2d 80 00       	push   $0x802d88
  80017e:	e8 e9 05 00 00       	call   80076c <cprintf>
  800183:	83 c4 10             	add    $0x10,%esp
		cprintf("Merge sort says GOOD BYE :)\n") ;
  800186:	83 ec 0c             	sub    $0xc,%esp
  800189:	68 a7 2d 80 00       	push   $0x802da7
  80018e:	e8 d9 05 00 00       	call   80076c <cprintf>
  800193:	83 c4 10             	add    $0x10,%esp
	}
	signal_semaphore(cons_mutex);
  800196:	83 ec 0c             	sub    $0xc,%esp
  800199:	ff 75 d4             	pushl  -0x2c(%ebp)
  80019c:	e8 06 27 00 00       	call   8028a7 <signal_semaphore>
  8001a1:	83 c4 10             	add    $0x10,%esp

	/*[5] DECLARE FINISHING*/
	signal_semaphore(finished);
  8001a4:	83 ec 0c             	sub    $0xc,%esp
  8001a7:	ff 75 d8             	pushl  -0x28(%ebp)
  8001aa:	e8 f8 26 00 00       	call   8028a7 <signal_semaphore>
  8001af:	83 c4 10             	add    $0x10,%esp
}
  8001b2:	90                   	nop
  8001b3:	c9                   	leave  
  8001b4:	c3                   	ret    

008001b5 <Swap>:

void Swap(int *Elements, int First, int Second)
{
  8001b5:	55                   	push   %ebp
  8001b6:	89 e5                	mov    %esp,%ebp
  8001b8:	83 ec 10             	sub    $0x10,%esp
	int Tmp = Elements[First] ;
  8001bb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8001be:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8001c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8001c8:	01 d0                	add    %edx,%eax
  8001ca:	8b 00                	mov    (%eax),%eax
  8001cc:	89 45 fc             	mov    %eax,-0x4(%ebp)
	Elements[First] = Elements[Second] ;
  8001cf:	8b 45 0c             	mov    0xc(%ebp),%eax
  8001d2:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8001d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8001dc:	01 c2                	add    %eax,%edx
  8001de:	8b 45 10             	mov    0x10(%ebp),%eax
  8001e1:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8001e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8001eb:	01 c8                	add    %ecx,%eax
  8001ed:	8b 00                	mov    (%eax),%eax
  8001ef:	89 02                	mov    %eax,(%edx)
	Elements[Second] = Tmp ;
  8001f1:	8b 45 10             	mov    0x10(%ebp),%eax
  8001f4:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8001fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8001fe:	01 c2                	add    %eax,%edx
  800200:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800203:	89 02                	mov    %eax,(%edx)
}
  800205:	90                   	nop
  800206:	c9                   	leave  
  800207:	c3                   	ret    

00800208 <PrintElements>:


void PrintElements(int *Elements, int NumOfElements)
{
  800208:	55                   	push   %ebp
  800209:	89 e5                	mov    %esp,%ebp
  80020b:	83 ec 18             	sub    $0x18,%esp
	int i ;
	int NumsPerLine = 20 ;
  80020e:	c7 45 f0 14 00 00 00 	movl   $0x14,-0x10(%ebp)
	for (i = 0 ; i < NumOfElements-1 ; i++)
  800215:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  80021c:	eb 42                	jmp    800260 <PrintElements+0x58>
	{
		if (i%NumsPerLine == 0)
  80021e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800221:	99                   	cltd   
  800222:	f7 7d f0             	idivl  -0x10(%ebp)
  800225:	89 d0                	mov    %edx,%eax
  800227:	85 c0                	test   %eax,%eax
  800229:	75 10                	jne    80023b <PrintElements+0x33>
			cprintf("\n");
  80022b:	83 ec 0c             	sub    $0xc,%esp
  80022e:	68 c4 2d 80 00       	push   $0x802dc4
  800233:	e8 34 05 00 00       	call   80076c <cprintf>
  800238:	83 c4 10             	add    $0x10,%esp
		cprintf("%d, ",Elements[i]);
  80023b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80023e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800245:	8b 45 08             	mov    0x8(%ebp),%eax
  800248:	01 d0                	add    %edx,%eax
  80024a:	8b 00                	mov    (%eax),%eax
  80024c:	83 ec 08             	sub    $0x8,%esp
  80024f:	50                   	push   %eax
  800250:	68 c6 2d 80 00       	push   $0x802dc6
  800255:	e8 12 05 00 00       	call   80076c <cprintf>
  80025a:	83 c4 10             	add    $0x10,%esp

void PrintElements(int *Elements, int NumOfElements)
{
	int i ;
	int NumsPerLine = 20 ;
	for (i = 0 ; i < NumOfElements-1 ; i++)
  80025d:	ff 45 f4             	incl   -0xc(%ebp)
  800260:	8b 45 0c             	mov    0xc(%ebp),%eax
  800263:	48                   	dec    %eax
  800264:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  800267:	7f b5                	jg     80021e <PrintElements+0x16>
	{
		if (i%NumsPerLine == 0)
			cprintf("\n");
		cprintf("%d, ",Elements[i]);
	}
	cprintf("%d\n",Elements[i]);
  800269:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80026c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800273:	8b 45 08             	mov    0x8(%ebp),%eax
  800276:	01 d0                	add    %edx,%eax
  800278:	8b 00                	mov    (%eax),%eax
  80027a:	83 ec 08             	sub    $0x8,%esp
  80027d:	50                   	push   %eax
  80027e:	68 cb 2d 80 00       	push   $0x802dcb
  800283:	e8 e4 04 00 00       	call   80076c <cprintf>
  800288:	83 c4 10             	add    $0x10,%esp

}
  80028b:	90                   	nop
  80028c:	c9                   	leave  
  80028d:	c3                   	ret    

0080028e <MSort>:


void MSort(int* A, int p, int r)
{
  80028e:	55                   	push   %ebp
  80028f:	89 e5                	mov    %esp,%ebp
  800291:	83 ec 18             	sub    $0x18,%esp
	if (p >= r)
  800294:	8b 45 0c             	mov    0xc(%ebp),%eax
  800297:	3b 45 10             	cmp    0x10(%ebp),%eax
  80029a:	7d 54                	jge    8002f0 <MSort+0x62>
	{
		return;
	}

	int q = (p + r) / 2;
  80029c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80029f:	8b 45 10             	mov    0x10(%ebp),%eax
  8002a2:	01 d0                	add    %edx,%eax
  8002a4:	89 c2                	mov    %eax,%edx
  8002a6:	c1 ea 1f             	shr    $0x1f,%edx
  8002a9:	01 d0                	add    %edx,%eax
  8002ab:	d1 f8                	sar    %eax
  8002ad:	89 45 f4             	mov    %eax,-0xc(%ebp)

	MSort(A, p, q);
  8002b0:	83 ec 04             	sub    $0x4,%esp
  8002b3:	ff 75 f4             	pushl  -0xc(%ebp)
  8002b6:	ff 75 0c             	pushl  0xc(%ebp)
  8002b9:	ff 75 08             	pushl  0x8(%ebp)
  8002bc:	e8 cd ff ff ff       	call   80028e <MSort>
  8002c1:	83 c4 10             	add    $0x10,%esp
//	cprintf("LEFT is sorted: from %d to %d\n", p, q);

	MSort(A, q + 1, r);
  8002c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8002c7:	40                   	inc    %eax
  8002c8:	83 ec 04             	sub    $0x4,%esp
  8002cb:	ff 75 10             	pushl  0x10(%ebp)
  8002ce:	50                   	push   %eax
  8002cf:	ff 75 08             	pushl  0x8(%ebp)
  8002d2:	e8 b7 ff ff ff       	call   80028e <MSort>
  8002d7:	83 c4 10             	add    $0x10,%esp
//	cprintf("RIGHT is sorted: from %d to %d\n", q+1, r);

	Merge(A, p, q, r);
  8002da:	ff 75 10             	pushl  0x10(%ebp)
  8002dd:	ff 75 f4             	pushl  -0xc(%ebp)
  8002e0:	ff 75 0c             	pushl  0xc(%ebp)
  8002e3:	ff 75 08             	pushl  0x8(%ebp)
  8002e6:	e8 08 00 00 00       	call   8002f3 <Merge>
  8002eb:	83 c4 10             	add    $0x10,%esp
  8002ee:	eb 01                	jmp    8002f1 <MSort+0x63>

void MSort(int* A, int p, int r)
{
	if (p >= r)
	{
		return;
  8002f0:	90                   	nop
//	cprintf("RIGHT is sorted: from %d to %d\n", q+1, r);

	Merge(A, p, q, r);
	//cprintf("[%d %d] + [%d %d] = [%d %d]\n", p, q, q+1, r, p, r);

}
  8002f1:	c9                   	leave  
  8002f2:	c3                   	ret    

008002f3 <Merge>:

void Merge(int* A, int p, int q, int r)
{
  8002f3:	55                   	push   %ebp
  8002f4:	89 e5                	mov    %esp,%ebp
  8002f6:	83 ec 30             	sub    $0x30,%esp
	int leftCapacity = q - p + 1;
  8002f9:	8b 45 10             	mov    0x10(%ebp),%eax
  8002fc:	2b 45 0c             	sub    0xc(%ebp),%eax
  8002ff:	40                   	inc    %eax
  800300:	89 45 e8             	mov    %eax,-0x18(%ebp)

	int rightCapacity = r - q;
  800303:	8b 45 14             	mov    0x14(%ebp),%eax
  800306:	2b 45 10             	sub    0x10(%ebp),%eax
  800309:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	int leftIndex = 0;
  80030c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)

	int rightIndex = 0;
  800313:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	//int* Left = malloc(sizeof(int) * leftCapacity);
	int* Left = __Left ;
  80031a:	c7 45 e0 60 40 80 00 	movl   $0x804060,-0x20(%ebp)
	int* Right = __Right;
  800321:	c7 45 dc c0 db 87 00 	movl   $0x87dbc0,-0x24(%ebp)
	//int* Right = malloc(sizeof(int) * rightCapacity);

	int i, j, k;
	for (i = 0; i < leftCapacity; i++)
  800328:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  80032f:	eb 2f                	jmp    800360 <Merge+0x6d>
	{
		Left[i] = A[p + i - 1];
  800331:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800334:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80033b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80033e:	01 c2                	add    %eax,%edx
  800340:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800343:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800346:	01 c8                	add    %ecx,%eax
  800348:	05 ff ff ff 3f       	add    $0x3fffffff,%eax
  80034d:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800354:	8b 45 08             	mov    0x8(%ebp),%eax
  800357:	01 c8                	add    %ecx,%eax
  800359:	8b 00                	mov    (%eax),%eax
  80035b:	89 02                	mov    %eax,(%edx)
	int* Left = __Left ;
	int* Right = __Right;
	//int* Right = malloc(sizeof(int) * rightCapacity);

	int i, j, k;
	for (i = 0; i < leftCapacity; i++)
  80035d:	ff 45 f4             	incl   -0xc(%ebp)
  800360:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800363:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  800366:	7c c9                	jl     800331 <Merge+0x3e>
	{
		Left[i] = A[p + i - 1];
	}
	for (j = 0; j < rightCapacity; j++)
  800368:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80036f:	eb 2a                	jmp    80039b <Merge+0xa8>
	{
		Right[j] = A[q + j];
  800371:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800374:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80037b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80037e:	01 c2                	add    %eax,%edx
  800380:	8b 4d 10             	mov    0x10(%ebp),%ecx
  800383:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800386:	01 c8                	add    %ecx,%eax
  800388:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  80038f:	8b 45 08             	mov    0x8(%ebp),%eax
  800392:	01 c8                	add    %ecx,%eax
  800394:	8b 00                	mov    (%eax),%eax
  800396:	89 02                	mov    %eax,(%edx)
	int i, j, k;
	for (i = 0; i < leftCapacity; i++)
	{
		Left[i] = A[p + i - 1];
	}
	for (j = 0; j < rightCapacity; j++)
  800398:	ff 45 f0             	incl   -0x10(%ebp)
  80039b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80039e:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8003a1:	7c ce                	jl     800371 <Merge+0x7e>
	{
		Right[j] = A[q + j];
	}

	for ( k = p; k <= r; k++)
  8003a3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003a6:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8003a9:	e9 0a 01 00 00       	jmp    8004b8 <Merge+0x1c5>
	{
		if (leftIndex < leftCapacity && rightIndex < rightCapacity)
  8003ae:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8003b1:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  8003b4:	0f 8d 95 00 00 00    	jge    80044f <Merge+0x15c>
  8003ba:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8003bd:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8003c0:	0f 8d 89 00 00 00    	jge    80044f <Merge+0x15c>
		{
			if (Left[leftIndex] < Right[rightIndex] )
  8003c6:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8003c9:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8003d0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8003d3:	01 d0                	add    %edx,%eax
  8003d5:	8b 10                	mov    (%eax),%edx
  8003d7:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8003da:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8003e1:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8003e4:	01 c8                	add    %ecx,%eax
  8003e6:	8b 00                	mov    (%eax),%eax
  8003e8:	39 c2                	cmp    %eax,%edx
  8003ea:	7d 33                	jge    80041f <Merge+0x12c>
			{
				A[k - 1] = Left[leftIndex++];
  8003ec:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8003ef:	05 ff ff ff 3f       	add    $0x3fffffff,%eax
  8003f4:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8003fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8003fe:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  800401:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800404:	8d 50 01             	lea    0x1(%eax),%edx
  800407:	89 55 fc             	mov    %edx,-0x4(%ebp)
  80040a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800411:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800414:	01 d0                	add    %edx,%eax
  800416:	8b 00                	mov    (%eax),%eax
  800418:	89 01                	mov    %eax,(%ecx)

	for ( k = p; k <= r; k++)
	{
		if (leftIndex < leftCapacity && rightIndex < rightCapacity)
		{
			if (Left[leftIndex] < Right[rightIndex] )
  80041a:	e9 96 00 00 00       	jmp    8004b5 <Merge+0x1c2>
			{
				A[k - 1] = Left[leftIndex++];
			}
			else
			{
				A[k - 1] = Right[rightIndex++];
  80041f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800422:	05 ff ff ff 3f       	add    $0x3fffffff,%eax
  800427:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80042e:	8b 45 08             	mov    0x8(%ebp),%eax
  800431:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  800434:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800437:	8d 50 01             	lea    0x1(%eax),%edx
  80043a:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80043d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800444:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800447:	01 d0                	add    %edx,%eax
  800449:	8b 00                	mov    (%eax),%eax
  80044b:	89 01                	mov    %eax,(%ecx)

	for ( k = p; k <= r; k++)
	{
		if (leftIndex < leftCapacity && rightIndex < rightCapacity)
		{
			if (Left[leftIndex] < Right[rightIndex] )
  80044d:	eb 66                	jmp    8004b5 <Merge+0x1c2>
			else
			{
				A[k - 1] = Right[rightIndex++];
			}
		}
		else if (leftIndex < leftCapacity)
  80044f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800452:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  800455:	7d 30                	jge    800487 <Merge+0x194>
		{
			A[k - 1] = Left[leftIndex++];
  800457:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80045a:	05 ff ff ff 3f       	add    $0x3fffffff,%eax
  80045f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800466:	8b 45 08             	mov    0x8(%ebp),%eax
  800469:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  80046c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80046f:	8d 50 01             	lea    0x1(%eax),%edx
  800472:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800475:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80047c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80047f:	01 d0                	add    %edx,%eax
  800481:	8b 00                	mov    (%eax),%eax
  800483:	89 01                	mov    %eax,(%ecx)
  800485:	eb 2e                	jmp    8004b5 <Merge+0x1c2>
		}
		else
		{
			A[k - 1] = Right[rightIndex++];
  800487:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80048a:	05 ff ff ff 3f       	add    $0x3fffffff,%eax
  80048f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800496:	8b 45 08             	mov    0x8(%ebp),%eax
  800499:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  80049c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80049f:	8d 50 01             	lea    0x1(%eax),%edx
  8004a2:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8004a5:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8004ac:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8004af:	01 d0                	add    %edx,%eax
  8004b1:	8b 00                	mov    (%eax),%eax
  8004b3:	89 01                	mov    %eax,(%ecx)
	for (j = 0; j < rightCapacity; j++)
	{
		Right[j] = A[q + j];
	}

	for ( k = p; k <= r; k++)
  8004b5:	ff 45 ec             	incl   -0x14(%ebp)
  8004b8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8004bb:	3b 45 14             	cmp    0x14(%ebp),%eax
  8004be:	0f 8e ea fe ff ff    	jle    8003ae <Merge+0xbb>
		{
			A[k - 1] = Right[rightIndex++];
		}
	}

}
  8004c4:	90                   	nop
  8004c5:	c9                   	leave  
  8004c6:	c3                   	ret    

008004c7 <libmain>:
volatile bool printStats = 1;

volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";
void
libmain(int argc, char **argv)
{
  8004c7:	55                   	push   %ebp
  8004c8:	89 e5                	mov    %esp,%ebp
  8004ca:	57                   	push   %edi
  8004cb:	56                   	push   %esi
  8004cc:	53                   	push   %ebx
  8004cd:	83 ec 7c             	sub    $0x7c,%esp
	//printStats = 1;
	int envIndex = sys_getenvindex();
  8004d0:	e8 1b 16 00 00       	call   801af0 <sys_getenvindex>
  8004d5:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	myEnv = &(envs[envIndex]);
  8004d8:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8004db:	89 d0                	mov    %edx,%eax
  8004dd:	c1 e0 06             	shl    $0x6,%eax
  8004e0:	29 d0                	sub    %edx,%eax
  8004e2:	c1 e0 02             	shl    $0x2,%eax
  8004e5:	01 d0                	add    %edx,%eax
  8004e7:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8004ee:	01 c8                	add    %ecx,%eax
  8004f0:	c1 e0 03             	shl    $0x3,%eax
  8004f3:	01 d0                	add    %edx,%eax
  8004f5:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8004fc:	29 c2                	sub    %eax,%edx
  8004fe:	8d 04 95 00 00 00 00 	lea    0x0(,%edx,4),%eax
  800505:	89 c2                	mov    %eax,%edx
  800507:	8d 82 00 00 c0 ee    	lea    -0x11400000(%edx),%eax
  80050d:	a3 20 40 80 00       	mov    %eax,0x804020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800512:	a1 20 40 80 00       	mov    0x804020,%eax
  800517:	8a 40 20             	mov    0x20(%eax),%al
  80051a:	84 c0                	test   %al,%al
  80051c:	74 0d                	je     80052b <libmain+0x64>
		binaryname = myEnv->prog_name;
  80051e:	a1 20 40 80 00       	mov    0x804020,%eax
  800523:	83 c0 20             	add    $0x20,%eax
  800526:	a3 04 40 80 00       	mov    %eax,0x804004

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80052b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80052f:	7e 0a                	jle    80053b <libmain+0x74>
		binaryname = argv[0];
  800531:	8b 45 0c             	mov    0xc(%ebp),%eax
  800534:	8b 00                	mov    (%eax),%eax
  800536:	a3 04 40 80 00       	mov    %eax,0x804004

	// call user main routine
	_main(argc, argv);
  80053b:	83 ec 08             	sub    $0x8,%esp
  80053e:	ff 75 0c             	pushl  0xc(%ebp)
  800541:	ff 75 08             	pushl  0x8(%ebp)
  800544:	e8 ef fa ff ff       	call   800038 <_main>
  800549:	83 c4 10             	add    $0x10,%esp

	if (printStats)
  80054c:	a1 00 40 80 00       	mov    0x804000,%eax
  800551:	85 c0                	test   %eax,%eax
  800553:	0f 84 01 01 00 00    	je     80065a <libmain+0x193>
	{
		char isOPTReplCmd[100] = "__IsOPTRepl__" ;
  800559:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  80055f:	bb c8 2e 80 00       	mov    $0x802ec8,%ebx
  800564:	ba 0e 00 00 00       	mov    $0xe,%edx
  800569:	89 c7                	mov    %eax,%edi
  80056b:	89 de                	mov    %ebx,%esi
  80056d:	89 d1                	mov    %edx,%ecx
  80056f:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  800571:	8d 55 8a             	lea    -0x76(%ebp),%edx
  800574:	b9 56 00 00 00       	mov    $0x56,%ecx
  800579:	b0 00                	mov    $0x0,%al
  80057b:	89 d7                	mov    %edx,%edi
  80057d:	f3 aa                	rep stos %al,%es:(%edi)
		int isOPTRepl = 0;
  80057f:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
		sys_utilities(isOPTReplCmd, (uint32)(&isOPTRepl));
  800586:	8d 45 e0             	lea    -0x20(%ebp),%eax
  800589:	83 ec 08             	sub    $0x8,%esp
  80058c:	50                   	push   %eax
  80058d:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  800593:	50                   	push   %eax
  800594:	e8 8d 17 00 00       	call   801d26 <sys_utilities>
  800599:	83 c4 10             	add    $0x10,%esp

		sys_lock_cons();
  80059c:	e8 d6 12 00 00       	call   801877 <sys_lock_cons>
		{
			cprintf("**************************************\n");
  8005a1:	83 ec 0c             	sub    $0xc,%esp
  8005a4:	68 e8 2d 80 00       	push   $0x802de8
  8005a9:	e8 be 01 00 00       	call   80076c <cprintf>
  8005ae:	83 c4 10             	add    $0x10,%esp
			if (isOPTRepl)
  8005b1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8005b4:	85 c0                	test   %eax,%eax
  8005b6:	74 18                	je     8005d0 <libmain+0x109>
			{
				cprintf("OPTIMAL number of page faults = %d\n", sys_get_optimal_num_faults());
  8005b8:	e8 87 17 00 00       	call   801d44 <sys_get_optimal_num_faults>
  8005bd:	83 ec 08             	sub    $0x8,%esp
  8005c0:	50                   	push   %eax
  8005c1:	68 10 2e 80 00       	push   $0x802e10
  8005c6:	e8 a1 01 00 00       	call   80076c <cprintf>
  8005cb:	83 c4 10             	add    $0x10,%esp
  8005ce:	eb 59                	jmp    800629 <libmain+0x162>
			}
			else
			{
				cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8005d0:	a1 20 40 80 00       	mov    0x804020,%eax
  8005d5:	8b 90 50 da 01 00    	mov    0x1da50(%eax),%edx
  8005db:	a1 20 40 80 00       	mov    0x804020,%eax
  8005e0:	8b 80 40 da 01 00    	mov    0x1da40(%eax),%eax
  8005e6:	83 ec 04             	sub    $0x4,%esp
  8005e9:	52                   	push   %edx
  8005ea:	50                   	push   %eax
  8005eb:	68 34 2e 80 00       	push   $0x802e34
  8005f0:	e8 77 01 00 00       	call   80076c <cprintf>
  8005f5:	83 c4 10             	add    $0x10,%esp
				cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  8005f8:	a1 20 40 80 00       	mov    0x804020,%eax
  8005fd:	8b 88 64 da 01 00    	mov    0x1da64(%eax),%ecx
  800603:	a1 20 40 80 00       	mov    0x804020,%eax
  800608:	8b 90 60 da 01 00    	mov    0x1da60(%eax),%edx
  80060e:	a1 20 40 80 00       	mov    0x804020,%eax
  800613:	8b 80 5c da 01 00    	mov    0x1da5c(%eax),%eax
  800619:	51                   	push   %ecx
  80061a:	52                   	push   %edx
  80061b:	50                   	push   %eax
  80061c:	68 5c 2e 80 00       	push   $0x802e5c
  800621:	e8 46 01 00 00       	call   80076c <cprintf>
  800626:	83 c4 10             	add    $0x10,%esp
			}
			//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
			cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800629:	a1 20 40 80 00       	mov    0x804020,%eax
  80062e:	8b 80 68 da 01 00    	mov    0x1da68(%eax),%eax
  800634:	83 ec 08             	sub    $0x8,%esp
  800637:	50                   	push   %eax
  800638:	68 b4 2e 80 00       	push   $0x802eb4
  80063d:	e8 2a 01 00 00       	call   80076c <cprintf>
  800642:	83 c4 10             	add    $0x10,%esp
			cprintf("**************************************\n");
  800645:	83 ec 0c             	sub    $0xc,%esp
  800648:	68 e8 2d 80 00       	push   $0x802de8
  80064d:	e8 1a 01 00 00       	call   80076c <cprintf>
  800652:	83 c4 10             	add    $0x10,%esp
		}
		sys_unlock_cons();
  800655:	e8 37 12 00 00       	call   801891 <sys_unlock_cons>
	}

	// exit gracefully
	exit();
  80065a:	e8 1f 00 00 00       	call   80067e <exit>
}
  80065f:	90                   	nop
  800660:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800663:	5b                   	pop    %ebx
  800664:	5e                   	pop    %esi
  800665:	5f                   	pop    %edi
  800666:	5d                   	pop    %ebp
  800667:	c3                   	ret    

00800668 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800668:	55                   	push   %ebp
  800669:	89 e5                	mov    %esp,%ebp
  80066b:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  80066e:	83 ec 0c             	sub    $0xc,%esp
  800671:	6a 00                	push   $0x0
  800673:	e8 44 14 00 00       	call   801abc <sys_destroy_env>
  800678:	83 c4 10             	add    $0x10,%esp
}
  80067b:	90                   	nop
  80067c:	c9                   	leave  
  80067d:	c3                   	ret    

0080067e <exit>:

void
exit(void)
{
  80067e:	55                   	push   %ebp
  80067f:	89 e5                	mov    %esp,%ebp
  800681:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  800684:	e8 99 14 00 00       	call   801b22 <sys_exit_env>
}
  800689:	90                   	nop
  80068a:	c9                   	leave  
  80068b:	c3                   	ret    

0080068c <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  80068c:	55                   	push   %ebp
  80068d:	89 e5                	mov    %esp,%ebp
  80068f:	53                   	push   %ebx
  800690:	83 ec 04             	sub    $0x4,%esp
	b->buf[b->idx++] = ch;
  800693:	8b 45 0c             	mov    0xc(%ebp),%eax
  800696:	8b 00                	mov    (%eax),%eax
  800698:	8d 48 01             	lea    0x1(%eax),%ecx
  80069b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80069e:	89 0a                	mov    %ecx,(%edx)
  8006a0:	8b 55 08             	mov    0x8(%ebp),%edx
  8006a3:	88 d1                	mov    %dl,%cl
  8006a5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8006a8:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  8006ac:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006af:	8b 00                	mov    (%eax),%eax
  8006b1:	3d ff 00 00 00       	cmp    $0xff,%eax
  8006b6:	75 30                	jne    8006e8 <putch+0x5c>
		sys_cputs(b->buf, b->idx, printProgName, curTextClr);
  8006b8:	8b 15 44 f6 8d 00    	mov    0x8df644,%edx
  8006be:	a0 e0 5a 86 00       	mov    0x865ae0,%al
  8006c3:	0f b6 c0             	movzbl %al,%eax
  8006c6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8006c9:	8b 09                	mov    (%ecx),%ecx
  8006cb:	89 cb                	mov    %ecx,%ebx
  8006cd:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8006d0:	83 c1 08             	add    $0x8,%ecx
  8006d3:	52                   	push   %edx
  8006d4:	50                   	push   %eax
  8006d5:	53                   	push   %ebx
  8006d6:	51                   	push   %ecx
  8006d7:	e8 57 11 00 00       	call   801833 <sys_cputs>
  8006dc:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8006df:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006e2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8006e8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006eb:	8b 40 04             	mov    0x4(%eax),%eax
  8006ee:	8d 50 01             	lea    0x1(%eax),%edx
  8006f1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006f4:	89 50 04             	mov    %edx,0x4(%eax)
}
  8006f7:	90                   	nop
  8006f8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8006fb:	c9                   	leave  
  8006fc:	c3                   	ret    

008006fd <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  8006fd:	55                   	push   %ebp
  8006fe:	89 e5                	mov    %esp,%ebp
  800700:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800706:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80070d:	00 00 00 
	b.cnt = 0;
  800710:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800717:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  80071a:	ff 75 0c             	pushl  0xc(%ebp)
  80071d:	ff 75 08             	pushl  0x8(%ebp)
  800720:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800726:	50                   	push   %eax
  800727:	68 8c 06 80 00       	push   $0x80068c
  80072c:	e8 5a 02 00 00       	call   80098b <vprintfmt>
  800731:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName, curTextClr);
  800734:	8b 15 44 f6 8d 00    	mov    0x8df644,%edx
  80073a:	a0 e0 5a 86 00       	mov    0x865ae0,%al
  80073f:	0f b6 c0             	movzbl %al,%eax
  800742:	8b 8d f0 fe ff ff    	mov    -0x110(%ebp),%ecx
  800748:	52                   	push   %edx
  800749:	50                   	push   %eax
  80074a:	51                   	push   %ecx
  80074b:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800751:	83 c0 08             	add    $0x8,%eax
  800754:	50                   	push   %eax
  800755:	e8 d9 10 00 00       	call   801833 <sys_cputs>
  80075a:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  80075d:	c6 05 e0 5a 86 00 00 	movb   $0x0,0x865ae0
	return b.cnt;
  800764:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  80076a:	c9                   	leave  
  80076b:	c3                   	ret    

0080076c <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  80076c:	55                   	push   %ebp
  80076d:	89 e5                	mov    %esp,%ebp
  80076f:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800772:	c6 05 e0 5a 86 00 01 	movb   $0x1,0x865ae0
	va_start(ap, fmt);
  800779:	8d 45 0c             	lea    0xc(%ebp),%eax
  80077c:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  80077f:	8b 45 08             	mov    0x8(%ebp),%eax
  800782:	83 ec 08             	sub    $0x8,%esp
  800785:	ff 75 f4             	pushl  -0xc(%ebp)
  800788:	50                   	push   %eax
  800789:	e8 6f ff ff ff       	call   8006fd <vcprintf>
  80078e:	83 c4 10             	add    $0x10,%esp
  800791:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800794:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800797:	c9                   	leave  
  800798:	c3                   	ret    

00800799 <cprintf_colored>:

// *************** This text coloring feature is implemented by *************
// ********** Abd-Alrahman Zedan From Team Frozen-Bytes - FCIS'24-25 ********
int cprintf_colored(int textClr, const char *fmt, ...) {
  800799:	55                   	push   %ebp
  80079a:	89 e5                	mov    %esp,%ebp
  80079c:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  80079f:	c6 05 e0 5a 86 00 01 	movb   $0x1,0x865ae0
	curTextClr = (textClr << 8) ; //set text color by the given value
  8007a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8007a9:	c1 e0 08             	shl    $0x8,%eax
  8007ac:	a3 44 f6 8d 00       	mov    %eax,0x8df644
	va_start(ap, fmt);
  8007b1:	8d 45 0c             	lea    0xc(%ebp),%eax
  8007b4:	83 c0 04             	add    $0x4,%eax
  8007b7:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8007ba:	8b 45 0c             	mov    0xc(%ebp),%eax
  8007bd:	83 ec 08             	sub    $0x8,%esp
  8007c0:	ff 75 f4             	pushl  -0xc(%ebp)
  8007c3:	50                   	push   %eax
  8007c4:	e8 34 ff ff ff       	call   8006fd <vcprintf>
  8007c9:	83 c4 10             	add    $0x10,%esp
  8007cc:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);
	curTextClr = TEXT_DEFAULT_CLR; //restore default color
  8007cf:	c7 05 44 f6 8d 00 00 	movl   $0x700,0x8df644
  8007d6:	07 00 00 

	return cnt;
  8007d9:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8007dc:	c9                   	leave  
  8007dd:	c3                   	ret    

008007de <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  8007de:	55                   	push   %ebp
  8007df:	89 e5                	mov    %esp,%ebp
  8007e1:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  8007e4:	e8 8e 10 00 00       	call   801877 <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  8007e9:	8d 45 0c             	lea    0xc(%ebp),%eax
  8007ec:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  8007ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8007f2:	83 ec 08             	sub    $0x8,%esp
  8007f5:	ff 75 f4             	pushl  -0xc(%ebp)
  8007f8:	50                   	push   %eax
  8007f9:	e8 ff fe ff ff       	call   8006fd <vcprintf>
  8007fe:	83 c4 10             	add    $0x10,%esp
  800801:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  800804:	e8 88 10 00 00       	call   801891 <sys_unlock_cons>
	return cnt;
  800809:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80080c:	c9                   	leave  
  80080d:	c3                   	ret    

0080080e <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  80080e:	55                   	push   %ebp
  80080f:	89 e5                	mov    %esp,%ebp
  800811:	53                   	push   %ebx
  800812:	83 ec 14             	sub    $0x14,%esp
  800815:	8b 45 10             	mov    0x10(%ebp),%eax
  800818:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80081b:	8b 45 14             	mov    0x14(%ebp),%eax
  80081e:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800821:	8b 45 18             	mov    0x18(%ebp),%eax
  800824:	ba 00 00 00 00       	mov    $0x0,%edx
  800829:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  80082c:	77 55                	ja     800883 <printnum+0x75>
  80082e:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800831:	72 05                	jb     800838 <printnum+0x2a>
  800833:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800836:	77 4b                	ja     800883 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800838:	8b 45 1c             	mov    0x1c(%ebp),%eax
  80083b:	8d 58 ff             	lea    -0x1(%eax),%ebx
  80083e:	8b 45 18             	mov    0x18(%ebp),%eax
  800841:	ba 00 00 00 00       	mov    $0x0,%edx
  800846:	52                   	push   %edx
  800847:	50                   	push   %eax
  800848:	ff 75 f4             	pushl  -0xc(%ebp)
  80084b:	ff 75 f0             	pushl  -0x10(%ebp)
  80084e:	e8 69 22 00 00       	call   802abc <__udivdi3>
  800853:	83 c4 10             	add    $0x10,%esp
  800856:	83 ec 04             	sub    $0x4,%esp
  800859:	ff 75 20             	pushl  0x20(%ebp)
  80085c:	53                   	push   %ebx
  80085d:	ff 75 18             	pushl  0x18(%ebp)
  800860:	52                   	push   %edx
  800861:	50                   	push   %eax
  800862:	ff 75 0c             	pushl  0xc(%ebp)
  800865:	ff 75 08             	pushl  0x8(%ebp)
  800868:	e8 a1 ff ff ff       	call   80080e <printnum>
  80086d:	83 c4 20             	add    $0x20,%esp
  800870:	eb 1a                	jmp    80088c <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800872:	83 ec 08             	sub    $0x8,%esp
  800875:	ff 75 0c             	pushl  0xc(%ebp)
  800878:	ff 75 20             	pushl  0x20(%ebp)
  80087b:	8b 45 08             	mov    0x8(%ebp),%eax
  80087e:	ff d0                	call   *%eax
  800880:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800883:	ff 4d 1c             	decl   0x1c(%ebp)
  800886:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  80088a:	7f e6                	jg     800872 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80088c:	8b 4d 18             	mov    0x18(%ebp),%ecx
  80088f:	bb 00 00 00 00       	mov    $0x0,%ebx
  800894:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800897:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80089a:	53                   	push   %ebx
  80089b:	51                   	push   %ecx
  80089c:	52                   	push   %edx
  80089d:	50                   	push   %eax
  80089e:	e8 29 23 00 00       	call   802bcc <__umoddi3>
  8008a3:	83 c4 10             	add    $0x10,%esp
  8008a6:	05 54 31 80 00       	add    $0x803154,%eax
  8008ab:	8a 00                	mov    (%eax),%al
  8008ad:	0f be c0             	movsbl %al,%eax
  8008b0:	83 ec 08             	sub    $0x8,%esp
  8008b3:	ff 75 0c             	pushl  0xc(%ebp)
  8008b6:	50                   	push   %eax
  8008b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8008ba:	ff d0                	call   *%eax
  8008bc:	83 c4 10             	add    $0x10,%esp
}
  8008bf:	90                   	nop
  8008c0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8008c3:	c9                   	leave  
  8008c4:	c3                   	ret    

008008c5 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8008c5:	55                   	push   %ebp
  8008c6:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8008c8:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8008cc:	7e 1c                	jle    8008ea <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  8008ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8008d1:	8b 00                	mov    (%eax),%eax
  8008d3:	8d 50 08             	lea    0x8(%eax),%edx
  8008d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8008d9:	89 10                	mov    %edx,(%eax)
  8008db:	8b 45 08             	mov    0x8(%ebp),%eax
  8008de:	8b 00                	mov    (%eax),%eax
  8008e0:	83 e8 08             	sub    $0x8,%eax
  8008e3:	8b 50 04             	mov    0x4(%eax),%edx
  8008e6:	8b 00                	mov    (%eax),%eax
  8008e8:	eb 40                	jmp    80092a <getuint+0x65>
	else if (lflag)
  8008ea:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8008ee:	74 1e                	je     80090e <getuint+0x49>
		return va_arg(*ap, unsigned long);
  8008f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8008f3:	8b 00                	mov    (%eax),%eax
  8008f5:	8d 50 04             	lea    0x4(%eax),%edx
  8008f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8008fb:	89 10                	mov    %edx,(%eax)
  8008fd:	8b 45 08             	mov    0x8(%ebp),%eax
  800900:	8b 00                	mov    (%eax),%eax
  800902:	83 e8 04             	sub    $0x4,%eax
  800905:	8b 00                	mov    (%eax),%eax
  800907:	ba 00 00 00 00       	mov    $0x0,%edx
  80090c:	eb 1c                	jmp    80092a <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  80090e:	8b 45 08             	mov    0x8(%ebp),%eax
  800911:	8b 00                	mov    (%eax),%eax
  800913:	8d 50 04             	lea    0x4(%eax),%edx
  800916:	8b 45 08             	mov    0x8(%ebp),%eax
  800919:	89 10                	mov    %edx,(%eax)
  80091b:	8b 45 08             	mov    0x8(%ebp),%eax
  80091e:	8b 00                	mov    (%eax),%eax
  800920:	83 e8 04             	sub    $0x4,%eax
  800923:	8b 00                	mov    (%eax),%eax
  800925:	ba 00 00 00 00       	mov    $0x0,%edx
}
  80092a:	5d                   	pop    %ebp
  80092b:	c3                   	ret    

0080092c <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  80092c:	55                   	push   %ebp
  80092d:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  80092f:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800933:	7e 1c                	jle    800951 <getint+0x25>
		return va_arg(*ap, long long);
  800935:	8b 45 08             	mov    0x8(%ebp),%eax
  800938:	8b 00                	mov    (%eax),%eax
  80093a:	8d 50 08             	lea    0x8(%eax),%edx
  80093d:	8b 45 08             	mov    0x8(%ebp),%eax
  800940:	89 10                	mov    %edx,(%eax)
  800942:	8b 45 08             	mov    0x8(%ebp),%eax
  800945:	8b 00                	mov    (%eax),%eax
  800947:	83 e8 08             	sub    $0x8,%eax
  80094a:	8b 50 04             	mov    0x4(%eax),%edx
  80094d:	8b 00                	mov    (%eax),%eax
  80094f:	eb 38                	jmp    800989 <getint+0x5d>
	else if (lflag)
  800951:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800955:	74 1a                	je     800971 <getint+0x45>
		return va_arg(*ap, long);
  800957:	8b 45 08             	mov    0x8(%ebp),%eax
  80095a:	8b 00                	mov    (%eax),%eax
  80095c:	8d 50 04             	lea    0x4(%eax),%edx
  80095f:	8b 45 08             	mov    0x8(%ebp),%eax
  800962:	89 10                	mov    %edx,(%eax)
  800964:	8b 45 08             	mov    0x8(%ebp),%eax
  800967:	8b 00                	mov    (%eax),%eax
  800969:	83 e8 04             	sub    $0x4,%eax
  80096c:	8b 00                	mov    (%eax),%eax
  80096e:	99                   	cltd   
  80096f:	eb 18                	jmp    800989 <getint+0x5d>
	else
		return va_arg(*ap, int);
  800971:	8b 45 08             	mov    0x8(%ebp),%eax
  800974:	8b 00                	mov    (%eax),%eax
  800976:	8d 50 04             	lea    0x4(%eax),%edx
  800979:	8b 45 08             	mov    0x8(%ebp),%eax
  80097c:	89 10                	mov    %edx,(%eax)
  80097e:	8b 45 08             	mov    0x8(%ebp),%eax
  800981:	8b 00                	mov    (%eax),%eax
  800983:	83 e8 04             	sub    $0x4,%eax
  800986:	8b 00                	mov    (%eax),%eax
  800988:	99                   	cltd   
}
  800989:	5d                   	pop    %ebp
  80098a:	c3                   	ret    

0080098b <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  80098b:	55                   	push   %ebp
  80098c:	89 e5                	mov    %esp,%ebp
  80098e:	56                   	push   %esi
  80098f:	53                   	push   %ebx
  800990:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800993:	eb 17                	jmp    8009ac <vprintfmt+0x21>
			if (ch == '\0')
  800995:	85 db                	test   %ebx,%ebx
  800997:	0f 84 c1 03 00 00    	je     800d5e <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  80099d:	83 ec 08             	sub    $0x8,%esp
  8009a0:	ff 75 0c             	pushl  0xc(%ebp)
  8009a3:	53                   	push   %ebx
  8009a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8009a7:	ff d0                	call   *%eax
  8009a9:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8009ac:	8b 45 10             	mov    0x10(%ebp),%eax
  8009af:	8d 50 01             	lea    0x1(%eax),%edx
  8009b2:	89 55 10             	mov    %edx,0x10(%ebp)
  8009b5:	8a 00                	mov    (%eax),%al
  8009b7:	0f b6 d8             	movzbl %al,%ebx
  8009ba:	83 fb 25             	cmp    $0x25,%ebx
  8009bd:	75 d6                	jne    800995 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  8009bf:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  8009c3:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  8009ca:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8009d1:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  8009d8:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8009df:	8b 45 10             	mov    0x10(%ebp),%eax
  8009e2:	8d 50 01             	lea    0x1(%eax),%edx
  8009e5:	89 55 10             	mov    %edx,0x10(%ebp)
  8009e8:	8a 00                	mov    (%eax),%al
  8009ea:	0f b6 d8             	movzbl %al,%ebx
  8009ed:	8d 43 dd             	lea    -0x23(%ebx),%eax
  8009f0:	83 f8 5b             	cmp    $0x5b,%eax
  8009f3:	0f 87 3d 03 00 00    	ja     800d36 <vprintfmt+0x3ab>
  8009f9:	8b 04 85 78 31 80 00 	mov    0x803178(,%eax,4),%eax
  800a00:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800a02:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800a06:	eb d7                	jmp    8009df <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800a08:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800a0c:	eb d1                	jmp    8009df <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800a0e:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800a15:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800a18:	89 d0                	mov    %edx,%eax
  800a1a:	c1 e0 02             	shl    $0x2,%eax
  800a1d:	01 d0                	add    %edx,%eax
  800a1f:	01 c0                	add    %eax,%eax
  800a21:	01 d8                	add    %ebx,%eax
  800a23:	83 e8 30             	sub    $0x30,%eax
  800a26:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800a29:	8b 45 10             	mov    0x10(%ebp),%eax
  800a2c:	8a 00                	mov    (%eax),%al
  800a2e:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800a31:	83 fb 2f             	cmp    $0x2f,%ebx
  800a34:	7e 3e                	jle    800a74 <vprintfmt+0xe9>
  800a36:	83 fb 39             	cmp    $0x39,%ebx
  800a39:	7f 39                	jg     800a74 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800a3b:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800a3e:	eb d5                	jmp    800a15 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800a40:	8b 45 14             	mov    0x14(%ebp),%eax
  800a43:	83 c0 04             	add    $0x4,%eax
  800a46:	89 45 14             	mov    %eax,0x14(%ebp)
  800a49:	8b 45 14             	mov    0x14(%ebp),%eax
  800a4c:	83 e8 04             	sub    $0x4,%eax
  800a4f:	8b 00                	mov    (%eax),%eax
  800a51:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800a54:	eb 1f                	jmp    800a75 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800a56:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a5a:	79 83                	jns    8009df <vprintfmt+0x54>
				width = 0;
  800a5c:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800a63:	e9 77 ff ff ff       	jmp    8009df <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800a68:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800a6f:	e9 6b ff ff ff       	jmp    8009df <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800a74:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800a75:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a79:	0f 89 60 ff ff ff    	jns    8009df <vprintfmt+0x54>
				width = precision, precision = -1;
  800a7f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800a82:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800a85:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800a8c:	e9 4e ff ff ff       	jmp    8009df <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800a91:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800a94:	e9 46 ff ff ff       	jmp    8009df <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800a99:	8b 45 14             	mov    0x14(%ebp),%eax
  800a9c:	83 c0 04             	add    $0x4,%eax
  800a9f:	89 45 14             	mov    %eax,0x14(%ebp)
  800aa2:	8b 45 14             	mov    0x14(%ebp),%eax
  800aa5:	83 e8 04             	sub    $0x4,%eax
  800aa8:	8b 00                	mov    (%eax),%eax
  800aaa:	83 ec 08             	sub    $0x8,%esp
  800aad:	ff 75 0c             	pushl  0xc(%ebp)
  800ab0:	50                   	push   %eax
  800ab1:	8b 45 08             	mov    0x8(%ebp),%eax
  800ab4:	ff d0                	call   *%eax
  800ab6:	83 c4 10             	add    $0x10,%esp
			break;
  800ab9:	e9 9b 02 00 00       	jmp    800d59 <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800abe:	8b 45 14             	mov    0x14(%ebp),%eax
  800ac1:	83 c0 04             	add    $0x4,%eax
  800ac4:	89 45 14             	mov    %eax,0x14(%ebp)
  800ac7:	8b 45 14             	mov    0x14(%ebp),%eax
  800aca:	83 e8 04             	sub    $0x4,%eax
  800acd:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800acf:	85 db                	test   %ebx,%ebx
  800ad1:	79 02                	jns    800ad5 <vprintfmt+0x14a>
				err = -err;
  800ad3:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800ad5:	83 fb 64             	cmp    $0x64,%ebx
  800ad8:	7f 0b                	jg     800ae5 <vprintfmt+0x15a>
  800ada:	8b 34 9d c0 2f 80 00 	mov    0x802fc0(,%ebx,4),%esi
  800ae1:	85 f6                	test   %esi,%esi
  800ae3:	75 19                	jne    800afe <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800ae5:	53                   	push   %ebx
  800ae6:	68 65 31 80 00       	push   $0x803165
  800aeb:	ff 75 0c             	pushl  0xc(%ebp)
  800aee:	ff 75 08             	pushl  0x8(%ebp)
  800af1:	e8 70 02 00 00       	call   800d66 <printfmt>
  800af6:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800af9:	e9 5b 02 00 00       	jmp    800d59 <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800afe:	56                   	push   %esi
  800aff:	68 6e 31 80 00       	push   $0x80316e
  800b04:	ff 75 0c             	pushl  0xc(%ebp)
  800b07:	ff 75 08             	pushl  0x8(%ebp)
  800b0a:	e8 57 02 00 00       	call   800d66 <printfmt>
  800b0f:	83 c4 10             	add    $0x10,%esp
			break;
  800b12:	e9 42 02 00 00       	jmp    800d59 <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800b17:	8b 45 14             	mov    0x14(%ebp),%eax
  800b1a:	83 c0 04             	add    $0x4,%eax
  800b1d:	89 45 14             	mov    %eax,0x14(%ebp)
  800b20:	8b 45 14             	mov    0x14(%ebp),%eax
  800b23:	83 e8 04             	sub    $0x4,%eax
  800b26:	8b 30                	mov    (%eax),%esi
  800b28:	85 f6                	test   %esi,%esi
  800b2a:	75 05                	jne    800b31 <vprintfmt+0x1a6>
				p = "(null)";
  800b2c:	be 71 31 80 00       	mov    $0x803171,%esi
			if (width > 0 && padc != '-')
  800b31:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800b35:	7e 6d                	jle    800ba4 <vprintfmt+0x219>
  800b37:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800b3b:	74 67                	je     800ba4 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800b3d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800b40:	83 ec 08             	sub    $0x8,%esp
  800b43:	50                   	push   %eax
  800b44:	56                   	push   %esi
  800b45:	e8 1e 03 00 00       	call   800e68 <strnlen>
  800b4a:	83 c4 10             	add    $0x10,%esp
  800b4d:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800b50:	eb 16                	jmp    800b68 <vprintfmt+0x1dd>
					putch(padc, putdat);
  800b52:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800b56:	83 ec 08             	sub    $0x8,%esp
  800b59:	ff 75 0c             	pushl  0xc(%ebp)
  800b5c:	50                   	push   %eax
  800b5d:	8b 45 08             	mov    0x8(%ebp),%eax
  800b60:	ff d0                	call   *%eax
  800b62:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800b65:	ff 4d e4             	decl   -0x1c(%ebp)
  800b68:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800b6c:	7f e4                	jg     800b52 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800b6e:	eb 34                	jmp    800ba4 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800b70:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800b74:	74 1c                	je     800b92 <vprintfmt+0x207>
  800b76:	83 fb 1f             	cmp    $0x1f,%ebx
  800b79:	7e 05                	jle    800b80 <vprintfmt+0x1f5>
  800b7b:	83 fb 7e             	cmp    $0x7e,%ebx
  800b7e:	7e 12                	jle    800b92 <vprintfmt+0x207>
					putch('?', putdat);
  800b80:	83 ec 08             	sub    $0x8,%esp
  800b83:	ff 75 0c             	pushl  0xc(%ebp)
  800b86:	6a 3f                	push   $0x3f
  800b88:	8b 45 08             	mov    0x8(%ebp),%eax
  800b8b:	ff d0                	call   *%eax
  800b8d:	83 c4 10             	add    $0x10,%esp
  800b90:	eb 0f                	jmp    800ba1 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800b92:	83 ec 08             	sub    $0x8,%esp
  800b95:	ff 75 0c             	pushl  0xc(%ebp)
  800b98:	53                   	push   %ebx
  800b99:	8b 45 08             	mov    0x8(%ebp),%eax
  800b9c:	ff d0                	call   *%eax
  800b9e:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800ba1:	ff 4d e4             	decl   -0x1c(%ebp)
  800ba4:	89 f0                	mov    %esi,%eax
  800ba6:	8d 70 01             	lea    0x1(%eax),%esi
  800ba9:	8a 00                	mov    (%eax),%al
  800bab:	0f be d8             	movsbl %al,%ebx
  800bae:	85 db                	test   %ebx,%ebx
  800bb0:	74 24                	je     800bd6 <vprintfmt+0x24b>
  800bb2:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800bb6:	78 b8                	js     800b70 <vprintfmt+0x1e5>
  800bb8:	ff 4d e0             	decl   -0x20(%ebp)
  800bbb:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800bbf:	79 af                	jns    800b70 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800bc1:	eb 13                	jmp    800bd6 <vprintfmt+0x24b>
				putch(' ', putdat);
  800bc3:	83 ec 08             	sub    $0x8,%esp
  800bc6:	ff 75 0c             	pushl  0xc(%ebp)
  800bc9:	6a 20                	push   $0x20
  800bcb:	8b 45 08             	mov    0x8(%ebp),%eax
  800bce:	ff d0                	call   *%eax
  800bd0:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800bd3:	ff 4d e4             	decl   -0x1c(%ebp)
  800bd6:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800bda:	7f e7                	jg     800bc3 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800bdc:	e9 78 01 00 00       	jmp    800d59 <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800be1:	83 ec 08             	sub    $0x8,%esp
  800be4:	ff 75 e8             	pushl  -0x18(%ebp)
  800be7:	8d 45 14             	lea    0x14(%ebp),%eax
  800bea:	50                   	push   %eax
  800beb:	e8 3c fd ff ff       	call   80092c <getint>
  800bf0:	83 c4 10             	add    $0x10,%esp
  800bf3:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800bf6:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800bf9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800bfc:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800bff:	85 d2                	test   %edx,%edx
  800c01:	79 23                	jns    800c26 <vprintfmt+0x29b>
				putch('-', putdat);
  800c03:	83 ec 08             	sub    $0x8,%esp
  800c06:	ff 75 0c             	pushl  0xc(%ebp)
  800c09:	6a 2d                	push   $0x2d
  800c0b:	8b 45 08             	mov    0x8(%ebp),%eax
  800c0e:	ff d0                	call   *%eax
  800c10:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800c13:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800c16:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800c19:	f7 d8                	neg    %eax
  800c1b:	83 d2 00             	adc    $0x0,%edx
  800c1e:	f7 da                	neg    %edx
  800c20:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c23:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800c26:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800c2d:	e9 bc 00 00 00       	jmp    800cee <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800c32:	83 ec 08             	sub    $0x8,%esp
  800c35:	ff 75 e8             	pushl  -0x18(%ebp)
  800c38:	8d 45 14             	lea    0x14(%ebp),%eax
  800c3b:	50                   	push   %eax
  800c3c:	e8 84 fc ff ff       	call   8008c5 <getuint>
  800c41:	83 c4 10             	add    $0x10,%esp
  800c44:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c47:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800c4a:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800c51:	e9 98 00 00 00       	jmp    800cee <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800c56:	83 ec 08             	sub    $0x8,%esp
  800c59:	ff 75 0c             	pushl  0xc(%ebp)
  800c5c:	6a 58                	push   $0x58
  800c5e:	8b 45 08             	mov    0x8(%ebp),%eax
  800c61:	ff d0                	call   *%eax
  800c63:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800c66:	83 ec 08             	sub    $0x8,%esp
  800c69:	ff 75 0c             	pushl  0xc(%ebp)
  800c6c:	6a 58                	push   $0x58
  800c6e:	8b 45 08             	mov    0x8(%ebp),%eax
  800c71:	ff d0                	call   *%eax
  800c73:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800c76:	83 ec 08             	sub    $0x8,%esp
  800c79:	ff 75 0c             	pushl  0xc(%ebp)
  800c7c:	6a 58                	push   $0x58
  800c7e:	8b 45 08             	mov    0x8(%ebp),%eax
  800c81:	ff d0                	call   *%eax
  800c83:	83 c4 10             	add    $0x10,%esp
			break;
  800c86:	e9 ce 00 00 00       	jmp    800d59 <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  800c8b:	83 ec 08             	sub    $0x8,%esp
  800c8e:	ff 75 0c             	pushl  0xc(%ebp)
  800c91:	6a 30                	push   $0x30
  800c93:	8b 45 08             	mov    0x8(%ebp),%eax
  800c96:	ff d0                	call   *%eax
  800c98:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800c9b:	83 ec 08             	sub    $0x8,%esp
  800c9e:	ff 75 0c             	pushl  0xc(%ebp)
  800ca1:	6a 78                	push   $0x78
  800ca3:	8b 45 08             	mov    0x8(%ebp),%eax
  800ca6:	ff d0                	call   *%eax
  800ca8:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800cab:	8b 45 14             	mov    0x14(%ebp),%eax
  800cae:	83 c0 04             	add    $0x4,%eax
  800cb1:	89 45 14             	mov    %eax,0x14(%ebp)
  800cb4:	8b 45 14             	mov    0x14(%ebp),%eax
  800cb7:	83 e8 04             	sub    $0x4,%eax
  800cba:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800cbc:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800cbf:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800cc6:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800ccd:	eb 1f                	jmp    800cee <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800ccf:	83 ec 08             	sub    $0x8,%esp
  800cd2:	ff 75 e8             	pushl  -0x18(%ebp)
  800cd5:	8d 45 14             	lea    0x14(%ebp),%eax
  800cd8:	50                   	push   %eax
  800cd9:	e8 e7 fb ff ff       	call   8008c5 <getuint>
  800cde:	83 c4 10             	add    $0x10,%esp
  800ce1:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800ce4:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800ce7:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800cee:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800cf2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800cf5:	83 ec 04             	sub    $0x4,%esp
  800cf8:	52                   	push   %edx
  800cf9:	ff 75 e4             	pushl  -0x1c(%ebp)
  800cfc:	50                   	push   %eax
  800cfd:	ff 75 f4             	pushl  -0xc(%ebp)
  800d00:	ff 75 f0             	pushl  -0x10(%ebp)
  800d03:	ff 75 0c             	pushl  0xc(%ebp)
  800d06:	ff 75 08             	pushl  0x8(%ebp)
  800d09:	e8 00 fb ff ff       	call   80080e <printnum>
  800d0e:	83 c4 20             	add    $0x20,%esp
			break;
  800d11:	eb 46                	jmp    800d59 <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800d13:	83 ec 08             	sub    $0x8,%esp
  800d16:	ff 75 0c             	pushl  0xc(%ebp)
  800d19:	53                   	push   %ebx
  800d1a:	8b 45 08             	mov    0x8(%ebp),%eax
  800d1d:	ff d0                	call   *%eax
  800d1f:	83 c4 10             	add    $0x10,%esp
			break;
  800d22:	eb 35                	jmp    800d59 <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  800d24:	c6 05 e0 5a 86 00 00 	movb   $0x0,0x865ae0
			break;
  800d2b:	eb 2c                	jmp    800d59 <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  800d2d:	c6 05 e0 5a 86 00 01 	movb   $0x1,0x865ae0
			break;
  800d34:	eb 23                	jmp    800d59 <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800d36:	83 ec 08             	sub    $0x8,%esp
  800d39:	ff 75 0c             	pushl  0xc(%ebp)
  800d3c:	6a 25                	push   $0x25
  800d3e:	8b 45 08             	mov    0x8(%ebp),%eax
  800d41:	ff d0                	call   *%eax
  800d43:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800d46:	ff 4d 10             	decl   0x10(%ebp)
  800d49:	eb 03                	jmp    800d4e <vprintfmt+0x3c3>
  800d4b:	ff 4d 10             	decl   0x10(%ebp)
  800d4e:	8b 45 10             	mov    0x10(%ebp),%eax
  800d51:	48                   	dec    %eax
  800d52:	8a 00                	mov    (%eax),%al
  800d54:	3c 25                	cmp    $0x25,%al
  800d56:	75 f3                	jne    800d4b <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  800d58:	90                   	nop
		}
	}
  800d59:	e9 35 fc ff ff       	jmp    800993 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800d5e:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800d5f:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800d62:	5b                   	pop    %ebx
  800d63:	5e                   	pop    %esi
  800d64:	5d                   	pop    %ebp
  800d65:	c3                   	ret    

00800d66 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800d66:	55                   	push   %ebp
  800d67:	89 e5                	mov    %esp,%ebp
  800d69:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800d6c:	8d 45 10             	lea    0x10(%ebp),%eax
  800d6f:	83 c0 04             	add    $0x4,%eax
  800d72:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800d75:	8b 45 10             	mov    0x10(%ebp),%eax
  800d78:	ff 75 f4             	pushl  -0xc(%ebp)
  800d7b:	50                   	push   %eax
  800d7c:	ff 75 0c             	pushl  0xc(%ebp)
  800d7f:	ff 75 08             	pushl  0x8(%ebp)
  800d82:	e8 04 fc ff ff       	call   80098b <vprintfmt>
  800d87:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800d8a:	90                   	nop
  800d8b:	c9                   	leave  
  800d8c:	c3                   	ret    

00800d8d <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800d8d:	55                   	push   %ebp
  800d8e:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800d90:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d93:	8b 40 08             	mov    0x8(%eax),%eax
  800d96:	8d 50 01             	lea    0x1(%eax),%edx
  800d99:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d9c:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800d9f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800da2:	8b 10                	mov    (%eax),%edx
  800da4:	8b 45 0c             	mov    0xc(%ebp),%eax
  800da7:	8b 40 04             	mov    0x4(%eax),%eax
  800daa:	39 c2                	cmp    %eax,%edx
  800dac:	73 12                	jae    800dc0 <sprintputch+0x33>
		*b->buf++ = ch;
  800dae:	8b 45 0c             	mov    0xc(%ebp),%eax
  800db1:	8b 00                	mov    (%eax),%eax
  800db3:	8d 48 01             	lea    0x1(%eax),%ecx
  800db6:	8b 55 0c             	mov    0xc(%ebp),%edx
  800db9:	89 0a                	mov    %ecx,(%edx)
  800dbb:	8b 55 08             	mov    0x8(%ebp),%edx
  800dbe:	88 10                	mov    %dl,(%eax)
}
  800dc0:	90                   	nop
  800dc1:	5d                   	pop    %ebp
  800dc2:	c3                   	ret    

00800dc3 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800dc3:	55                   	push   %ebp
  800dc4:	89 e5                	mov    %esp,%ebp
  800dc6:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800dc9:	8b 45 08             	mov    0x8(%ebp),%eax
  800dcc:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800dcf:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dd2:	8d 50 ff             	lea    -0x1(%eax),%edx
  800dd5:	8b 45 08             	mov    0x8(%ebp),%eax
  800dd8:	01 d0                	add    %edx,%eax
  800dda:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800ddd:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800de4:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800de8:	74 06                	je     800df0 <vsnprintf+0x2d>
  800dea:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800dee:	7f 07                	jg     800df7 <vsnprintf+0x34>
		return -E_INVAL;
  800df0:	b8 03 00 00 00       	mov    $0x3,%eax
  800df5:	eb 20                	jmp    800e17 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800df7:	ff 75 14             	pushl  0x14(%ebp)
  800dfa:	ff 75 10             	pushl  0x10(%ebp)
  800dfd:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800e00:	50                   	push   %eax
  800e01:	68 8d 0d 80 00       	push   $0x800d8d
  800e06:	e8 80 fb ff ff       	call   80098b <vprintfmt>
  800e0b:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800e0e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800e11:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800e14:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800e17:	c9                   	leave  
  800e18:	c3                   	ret    

00800e19 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800e19:	55                   	push   %ebp
  800e1a:	89 e5                	mov    %esp,%ebp
  800e1c:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800e1f:	8d 45 10             	lea    0x10(%ebp),%eax
  800e22:	83 c0 04             	add    $0x4,%eax
  800e25:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800e28:	8b 45 10             	mov    0x10(%ebp),%eax
  800e2b:	ff 75 f4             	pushl  -0xc(%ebp)
  800e2e:	50                   	push   %eax
  800e2f:	ff 75 0c             	pushl  0xc(%ebp)
  800e32:	ff 75 08             	pushl  0x8(%ebp)
  800e35:	e8 89 ff ff ff       	call   800dc3 <vsnprintf>
  800e3a:	83 c4 10             	add    $0x10,%esp
  800e3d:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800e40:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800e43:	c9                   	leave  
  800e44:	c3                   	ret    

00800e45 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800e45:	55                   	push   %ebp
  800e46:	89 e5                	mov    %esp,%ebp
  800e48:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800e4b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800e52:	eb 06                	jmp    800e5a <strlen+0x15>
		n++;
  800e54:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800e57:	ff 45 08             	incl   0x8(%ebp)
  800e5a:	8b 45 08             	mov    0x8(%ebp),%eax
  800e5d:	8a 00                	mov    (%eax),%al
  800e5f:	84 c0                	test   %al,%al
  800e61:	75 f1                	jne    800e54 <strlen+0xf>
		n++;
	return n;
  800e63:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800e66:	c9                   	leave  
  800e67:	c3                   	ret    

00800e68 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800e68:	55                   	push   %ebp
  800e69:	89 e5                	mov    %esp,%ebp
  800e6b:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800e6e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800e75:	eb 09                	jmp    800e80 <strnlen+0x18>
		n++;
  800e77:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800e7a:	ff 45 08             	incl   0x8(%ebp)
  800e7d:	ff 4d 0c             	decl   0xc(%ebp)
  800e80:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800e84:	74 09                	je     800e8f <strnlen+0x27>
  800e86:	8b 45 08             	mov    0x8(%ebp),%eax
  800e89:	8a 00                	mov    (%eax),%al
  800e8b:	84 c0                	test   %al,%al
  800e8d:	75 e8                	jne    800e77 <strnlen+0xf>
		n++;
	return n;
  800e8f:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800e92:	c9                   	leave  
  800e93:	c3                   	ret    

00800e94 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800e94:	55                   	push   %ebp
  800e95:	89 e5                	mov    %esp,%ebp
  800e97:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800e9a:	8b 45 08             	mov    0x8(%ebp),%eax
  800e9d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800ea0:	90                   	nop
  800ea1:	8b 45 08             	mov    0x8(%ebp),%eax
  800ea4:	8d 50 01             	lea    0x1(%eax),%edx
  800ea7:	89 55 08             	mov    %edx,0x8(%ebp)
  800eaa:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ead:	8d 4a 01             	lea    0x1(%edx),%ecx
  800eb0:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800eb3:	8a 12                	mov    (%edx),%dl
  800eb5:	88 10                	mov    %dl,(%eax)
  800eb7:	8a 00                	mov    (%eax),%al
  800eb9:	84 c0                	test   %al,%al
  800ebb:	75 e4                	jne    800ea1 <strcpy+0xd>
		/* do nothing */;
	return ret;
  800ebd:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800ec0:	c9                   	leave  
  800ec1:	c3                   	ret    

00800ec2 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800ec2:	55                   	push   %ebp
  800ec3:	89 e5                	mov    %esp,%ebp
  800ec5:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800ec8:	8b 45 08             	mov    0x8(%ebp),%eax
  800ecb:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800ece:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800ed5:	eb 1f                	jmp    800ef6 <strncpy+0x34>
		*dst++ = *src;
  800ed7:	8b 45 08             	mov    0x8(%ebp),%eax
  800eda:	8d 50 01             	lea    0x1(%eax),%edx
  800edd:	89 55 08             	mov    %edx,0x8(%ebp)
  800ee0:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ee3:	8a 12                	mov    (%edx),%dl
  800ee5:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800ee7:	8b 45 0c             	mov    0xc(%ebp),%eax
  800eea:	8a 00                	mov    (%eax),%al
  800eec:	84 c0                	test   %al,%al
  800eee:	74 03                	je     800ef3 <strncpy+0x31>
			src++;
  800ef0:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800ef3:	ff 45 fc             	incl   -0x4(%ebp)
  800ef6:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ef9:	3b 45 10             	cmp    0x10(%ebp),%eax
  800efc:	72 d9                	jb     800ed7 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800efe:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800f01:	c9                   	leave  
  800f02:	c3                   	ret    

00800f03 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800f03:	55                   	push   %ebp
  800f04:	89 e5                	mov    %esp,%ebp
  800f06:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800f09:	8b 45 08             	mov    0x8(%ebp),%eax
  800f0c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800f0f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f13:	74 30                	je     800f45 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800f15:	eb 16                	jmp    800f2d <strlcpy+0x2a>
			*dst++ = *src++;
  800f17:	8b 45 08             	mov    0x8(%ebp),%eax
  800f1a:	8d 50 01             	lea    0x1(%eax),%edx
  800f1d:	89 55 08             	mov    %edx,0x8(%ebp)
  800f20:	8b 55 0c             	mov    0xc(%ebp),%edx
  800f23:	8d 4a 01             	lea    0x1(%edx),%ecx
  800f26:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800f29:	8a 12                	mov    (%edx),%dl
  800f2b:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800f2d:	ff 4d 10             	decl   0x10(%ebp)
  800f30:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f34:	74 09                	je     800f3f <strlcpy+0x3c>
  800f36:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f39:	8a 00                	mov    (%eax),%al
  800f3b:	84 c0                	test   %al,%al
  800f3d:	75 d8                	jne    800f17 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800f3f:	8b 45 08             	mov    0x8(%ebp),%eax
  800f42:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800f45:	8b 55 08             	mov    0x8(%ebp),%edx
  800f48:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f4b:	29 c2                	sub    %eax,%edx
  800f4d:	89 d0                	mov    %edx,%eax
}
  800f4f:	c9                   	leave  
  800f50:	c3                   	ret    

00800f51 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800f51:	55                   	push   %ebp
  800f52:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800f54:	eb 06                	jmp    800f5c <strcmp+0xb>
		p++, q++;
  800f56:	ff 45 08             	incl   0x8(%ebp)
  800f59:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800f5c:	8b 45 08             	mov    0x8(%ebp),%eax
  800f5f:	8a 00                	mov    (%eax),%al
  800f61:	84 c0                	test   %al,%al
  800f63:	74 0e                	je     800f73 <strcmp+0x22>
  800f65:	8b 45 08             	mov    0x8(%ebp),%eax
  800f68:	8a 10                	mov    (%eax),%dl
  800f6a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f6d:	8a 00                	mov    (%eax),%al
  800f6f:	38 c2                	cmp    %al,%dl
  800f71:	74 e3                	je     800f56 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800f73:	8b 45 08             	mov    0x8(%ebp),%eax
  800f76:	8a 00                	mov    (%eax),%al
  800f78:	0f b6 d0             	movzbl %al,%edx
  800f7b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f7e:	8a 00                	mov    (%eax),%al
  800f80:	0f b6 c0             	movzbl %al,%eax
  800f83:	29 c2                	sub    %eax,%edx
  800f85:	89 d0                	mov    %edx,%eax
}
  800f87:	5d                   	pop    %ebp
  800f88:	c3                   	ret    

00800f89 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800f89:	55                   	push   %ebp
  800f8a:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800f8c:	eb 09                	jmp    800f97 <strncmp+0xe>
		n--, p++, q++;
  800f8e:	ff 4d 10             	decl   0x10(%ebp)
  800f91:	ff 45 08             	incl   0x8(%ebp)
  800f94:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800f97:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f9b:	74 17                	je     800fb4 <strncmp+0x2b>
  800f9d:	8b 45 08             	mov    0x8(%ebp),%eax
  800fa0:	8a 00                	mov    (%eax),%al
  800fa2:	84 c0                	test   %al,%al
  800fa4:	74 0e                	je     800fb4 <strncmp+0x2b>
  800fa6:	8b 45 08             	mov    0x8(%ebp),%eax
  800fa9:	8a 10                	mov    (%eax),%dl
  800fab:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fae:	8a 00                	mov    (%eax),%al
  800fb0:	38 c2                	cmp    %al,%dl
  800fb2:	74 da                	je     800f8e <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800fb4:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800fb8:	75 07                	jne    800fc1 <strncmp+0x38>
		return 0;
  800fba:	b8 00 00 00 00       	mov    $0x0,%eax
  800fbf:	eb 14                	jmp    800fd5 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800fc1:	8b 45 08             	mov    0x8(%ebp),%eax
  800fc4:	8a 00                	mov    (%eax),%al
  800fc6:	0f b6 d0             	movzbl %al,%edx
  800fc9:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fcc:	8a 00                	mov    (%eax),%al
  800fce:	0f b6 c0             	movzbl %al,%eax
  800fd1:	29 c2                	sub    %eax,%edx
  800fd3:	89 d0                	mov    %edx,%eax
}
  800fd5:	5d                   	pop    %ebp
  800fd6:	c3                   	ret    

00800fd7 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800fd7:	55                   	push   %ebp
  800fd8:	89 e5                	mov    %esp,%ebp
  800fda:	83 ec 04             	sub    $0x4,%esp
  800fdd:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fe0:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800fe3:	eb 12                	jmp    800ff7 <strchr+0x20>
		if (*s == c)
  800fe5:	8b 45 08             	mov    0x8(%ebp),%eax
  800fe8:	8a 00                	mov    (%eax),%al
  800fea:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800fed:	75 05                	jne    800ff4 <strchr+0x1d>
			return (char *) s;
  800fef:	8b 45 08             	mov    0x8(%ebp),%eax
  800ff2:	eb 11                	jmp    801005 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800ff4:	ff 45 08             	incl   0x8(%ebp)
  800ff7:	8b 45 08             	mov    0x8(%ebp),%eax
  800ffa:	8a 00                	mov    (%eax),%al
  800ffc:	84 c0                	test   %al,%al
  800ffe:	75 e5                	jne    800fe5 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  801000:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801005:	c9                   	leave  
  801006:	c3                   	ret    

00801007 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  801007:	55                   	push   %ebp
  801008:	89 e5                	mov    %esp,%ebp
  80100a:	83 ec 04             	sub    $0x4,%esp
  80100d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801010:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  801013:	eb 0d                	jmp    801022 <strfind+0x1b>
		if (*s == c)
  801015:	8b 45 08             	mov    0x8(%ebp),%eax
  801018:	8a 00                	mov    (%eax),%al
  80101a:	3a 45 fc             	cmp    -0x4(%ebp),%al
  80101d:	74 0e                	je     80102d <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  80101f:	ff 45 08             	incl   0x8(%ebp)
  801022:	8b 45 08             	mov    0x8(%ebp),%eax
  801025:	8a 00                	mov    (%eax),%al
  801027:	84 c0                	test   %al,%al
  801029:	75 ea                	jne    801015 <strfind+0xe>
  80102b:	eb 01                	jmp    80102e <strfind+0x27>
		if (*s == c)
			break;
  80102d:	90                   	nop
	return (char *) s;
  80102e:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801031:	c9                   	leave  
  801032:	c3                   	ret    

00801033 <memset>:

// *************** The faster implementation of memset & memcpy is implemented by *************
// ****************** Team80 (Yahia Khaled, Malek Ahmed et al) - FCIS'24-25 *******************
void *
memset(void *v, int c, uint32 n)
{
  801033:	55                   	push   %ebp
  801034:	89 e5                	mov    %esp,%ebp
  801036:	83 ec 10             	sub    $0x10,%esp
//	m = n;
//	while (--m >= 0)
//		*p++ = c;

	/*Faster Implementation*/
	uint64* p64 = (uint64*)v;
  801039:	8b 45 08             	mov    0x8(%ebp),%eax
  80103c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if(n >= 8){
  80103f:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  801043:	76 63                	jbe    8010a8 <memset+0x75>
		uint64 data_block = c;
  801045:	8b 45 0c             	mov    0xc(%ebp),%eax
  801048:	99                   	cltd   
  801049:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80104c:	89 55 f4             	mov    %edx,-0xc(%ebp)
		data_block |= data_block << 8;
  80104f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801052:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801055:	0f a4 c2 08          	shld   $0x8,%eax,%edx
  801059:	c1 e0 08             	shl    $0x8,%eax
  80105c:	09 45 f0             	or     %eax,-0x10(%ebp)
  80105f:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 16;
  801062:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801065:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801068:	0f a4 c2 10          	shld   $0x10,%eax,%edx
  80106c:	c1 e0 10             	shl    $0x10,%eax
  80106f:	09 45 f0             	or     %eax,-0x10(%ebp)
  801072:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 32;
  801075:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801078:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80107b:	89 c2                	mov    %eax,%edx
  80107d:	b8 00 00 00 00       	mov    $0x0,%eax
  801082:	09 45 f0             	or     %eax,-0x10(%ebp)
  801085:	09 55 f4             	or     %edx,-0xc(%ebp)

		while(n >= 8)
  801088:	eb 18                	jmp    8010a2 <memset+0x6f>
			*p64++ = data_block, n -= 8;
  80108a:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  80108d:	8d 41 08             	lea    0x8(%ecx),%eax
  801090:	89 45 fc             	mov    %eax,-0x4(%ebp)
  801093:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801096:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801099:	89 01                	mov    %eax,(%ecx)
  80109b:	89 51 04             	mov    %edx,0x4(%ecx)
  80109e:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
		uint64 data_block = c;
		data_block |= data_block << 8;
		data_block |= data_block << 16;
		data_block |= data_block << 32;

		while(n >= 8)
  8010a2:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  8010a6:	77 e2                	ja     80108a <memset+0x57>
			*p64++ = data_block, n -= 8;
	}

	if(n){
  8010a8:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8010ac:	74 23                	je     8010d1 <memset+0x9e>
		uint8* p8 = (uint8*)p64;
  8010ae:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8010b1:	89 45 f8             	mov    %eax,-0x8(%ebp)
		while (n-- > 0)
  8010b4:	eb 0e                	jmp    8010c4 <memset+0x91>
			*p8++ = (uint8)c;
  8010b6:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010b9:	8d 50 01             	lea    0x1(%eax),%edx
  8010bc:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8010bf:	8b 55 0c             	mov    0xc(%ebp),%edx
  8010c2:	88 10                	mov    %dl,(%eax)
			*p64++ = data_block, n -= 8;
	}

	if(n){
		uint8* p8 = (uint8*)p64;
		while (n-- > 0)
  8010c4:	8b 45 10             	mov    0x10(%ebp),%eax
  8010c7:	8d 50 ff             	lea    -0x1(%eax),%edx
  8010ca:	89 55 10             	mov    %edx,0x10(%ebp)
  8010cd:	85 c0                	test   %eax,%eax
  8010cf:	75 e5                	jne    8010b6 <memset+0x83>
			*p8++ = (uint8)c;
	}

	return v;
  8010d1:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8010d4:	c9                   	leave  
  8010d5:	c3                   	ret    

008010d6 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  8010d6:	55                   	push   %ebp
  8010d7:	89 e5                	mov    %esp,%ebp
  8010d9:	83 ec 10             	sub    $0x10,%esp
	//	s = src;
	//	d = dst;
	//	while (n-- > 0)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
  8010dc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010df:	89 45 fc             	mov    %eax,-0x4(%ebp)
	uint64* d64 = (uint64*)dst;
  8010e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8010e5:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if(n >= 8){
  8010e8:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  8010ec:	76 24                	jbe    801112 <memcpy+0x3c>
		while(n >= 8){
  8010ee:	eb 1c                	jmp    80110c <memcpy+0x36>
			*d64 = *s64;
  8010f0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8010f3:	8b 50 04             	mov    0x4(%eax),%edx
  8010f6:	8b 00                	mov    (%eax),%eax
  8010f8:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8010fb:	89 01                	mov    %eax,(%ecx)
  8010fd:	89 51 04             	mov    %edx,0x4(%ecx)
			n -= 8;
  801100:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
			++s64;
  801104:	83 45 fc 08          	addl   $0x8,-0x4(%ebp)
			++d64;
  801108:	83 45 f8 08          	addl   $0x8,-0x8(%ebp)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
	uint64* d64 = (uint64*)dst;
	if(n >= 8){
		while(n >= 8){
  80110c:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  801110:	77 de                	ja     8010f0 <memcpy+0x1a>
			++s64;
			++d64;
		}
	}

	if(n){
  801112:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801116:	74 31                	je     801149 <memcpy+0x73>
		uint8* s8 = (uint8*)s64;
  801118:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80111b:	89 45 f4             	mov    %eax,-0xc(%ebp)
		uint8* d8 = (uint8*)d64;
  80111e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801121:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (n-- > 0)
  801124:	eb 16                	jmp    80113c <memcpy+0x66>
			*d8++ = *s8++;
  801126:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801129:	8d 50 01             	lea    0x1(%eax),%edx
  80112c:	89 55 f0             	mov    %edx,-0x10(%ebp)
  80112f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801132:	8d 4a 01             	lea    0x1(%edx),%ecx
  801135:	89 4d f4             	mov    %ecx,-0xc(%ebp)
  801138:	8a 12                	mov    (%edx),%dl
  80113a:	88 10                	mov    %dl,(%eax)
	}

	if(n){
		uint8* s8 = (uint8*)s64;
		uint8* d8 = (uint8*)d64;
		while (n-- > 0)
  80113c:	8b 45 10             	mov    0x10(%ebp),%eax
  80113f:	8d 50 ff             	lea    -0x1(%eax),%edx
  801142:	89 55 10             	mov    %edx,0x10(%ebp)
  801145:	85 c0                	test   %eax,%eax
  801147:	75 dd                	jne    801126 <memcpy+0x50>
			*d8++ = *s8++;
	}
	return dst;
  801149:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80114c:	c9                   	leave  
  80114d:	c3                   	ret    

0080114e <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  80114e:	55                   	push   %ebp
  80114f:	89 e5                	mov    %esp,%ebp
  801151:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801154:	8b 45 0c             	mov    0xc(%ebp),%eax
  801157:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  80115a:	8b 45 08             	mov    0x8(%ebp),%eax
  80115d:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  801160:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801163:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801166:	73 50                	jae    8011b8 <memmove+0x6a>
  801168:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80116b:	8b 45 10             	mov    0x10(%ebp),%eax
  80116e:	01 d0                	add    %edx,%eax
  801170:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801173:	76 43                	jbe    8011b8 <memmove+0x6a>
		s += n;
  801175:	8b 45 10             	mov    0x10(%ebp),%eax
  801178:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  80117b:	8b 45 10             	mov    0x10(%ebp),%eax
  80117e:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  801181:	eb 10                	jmp    801193 <memmove+0x45>
			*--d = *--s;
  801183:	ff 4d f8             	decl   -0x8(%ebp)
  801186:	ff 4d fc             	decl   -0x4(%ebp)
  801189:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80118c:	8a 10                	mov    (%eax),%dl
  80118e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801191:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  801193:	8b 45 10             	mov    0x10(%ebp),%eax
  801196:	8d 50 ff             	lea    -0x1(%eax),%edx
  801199:	89 55 10             	mov    %edx,0x10(%ebp)
  80119c:	85 c0                	test   %eax,%eax
  80119e:	75 e3                	jne    801183 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  8011a0:	eb 23                	jmp    8011c5 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  8011a2:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011a5:	8d 50 01             	lea    0x1(%eax),%edx
  8011a8:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8011ab:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8011ae:	8d 4a 01             	lea    0x1(%edx),%ecx
  8011b1:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  8011b4:	8a 12                	mov    (%edx),%dl
  8011b6:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  8011b8:	8b 45 10             	mov    0x10(%ebp),%eax
  8011bb:	8d 50 ff             	lea    -0x1(%eax),%edx
  8011be:	89 55 10             	mov    %edx,0x10(%ebp)
  8011c1:	85 c0                	test   %eax,%eax
  8011c3:	75 dd                	jne    8011a2 <memmove+0x54>
			*d++ = *s++;

	return dst;
  8011c5:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8011c8:	c9                   	leave  
  8011c9:	c3                   	ret    

008011ca <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  8011ca:	55                   	push   %ebp
  8011cb:	89 e5                	mov    %esp,%ebp
  8011cd:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  8011d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8011d3:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  8011d6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011d9:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  8011dc:	eb 2a                	jmp    801208 <memcmp+0x3e>
		if (*s1 != *s2)
  8011de:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8011e1:	8a 10                	mov    (%eax),%dl
  8011e3:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011e6:	8a 00                	mov    (%eax),%al
  8011e8:	38 c2                	cmp    %al,%dl
  8011ea:	74 16                	je     801202 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  8011ec:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8011ef:	8a 00                	mov    (%eax),%al
  8011f1:	0f b6 d0             	movzbl %al,%edx
  8011f4:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011f7:	8a 00                	mov    (%eax),%al
  8011f9:	0f b6 c0             	movzbl %al,%eax
  8011fc:	29 c2                	sub    %eax,%edx
  8011fe:	89 d0                	mov    %edx,%eax
  801200:	eb 18                	jmp    80121a <memcmp+0x50>
		s1++, s2++;
  801202:	ff 45 fc             	incl   -0x4(%ebp)
  801205:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  801208:	8b 45 10             	mov    0x10(%ebp),%eax
  80120b:	8d 50 ff             	lea    -0x1(%eax),%edx
  80120e:	89 55 10             	mov    %edx,0x10(%ebp)
  801211:	85 c0                	test   %eax,%eax
  801213:	75 c9                	jne    8011de <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801215:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80121a:	c9                   	leave  
  80121b:	c3                   	ret    

0080121c <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  80121c:	55                   	push   %ebp
  80121d:	89 e5                	mov    %esp,%ebp
  80121f:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  801222:	8b 55 08             	mov    0x8(%ebp),%edx
  801225:	8b 45 10             	mov    0x10(%ebp),%eax
  801228:	01 d0                	add    %edx,%eax
  80122a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  80122d:	eb 15                	jmp    801244 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  80122f:	8b 45 08             	mov    0x8(%ebp),%eax
  801232:	8a 00                	mov    (%eax),%al
  801234:	0f b6 d0             	movzbl %al,%edx
  801237:	8b 45 0c             	mov    0xc(%ebp),%eax
  80123a:	0f b6 c0             	movzbl %al,%eax
  80123d:	39 c2                	cmp    %eax,%edx
  80123f:	74 0d                	je     80124e <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801241:	ff 45 08             	incl   0x8(%ebp)
  801244:	8b 45 08             	mov    0x8(%ebp),%eax
  801247:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  80124a:	72 e3                	jb     80122f <memfind+0x13>
  80124c:	eb 01                	jmp    80124f <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  80124e:	90                   	nop
	return (void *) s;
  80124f:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801252:	c9                   	leave  
  801253:	c3                   	ret    

00801254 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801254:	55                   	push   %ebp
  801255:	89 e5                	mov    %esp,%ebp
  801257:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  80125a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  801261:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801268:	eb 03                	jmp    80126d <strtol+0x19>
		s++;
  80126a:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80126d:	8b 45 08             	mov    0x8(%ebp),%eax
  801270:	8a 00                	mov    (%eax),%al
  801272:	3c 20                	cmp    $0x20,%al
  801274:	74 f4                	je     80126a <strtol+0x16>
  801276:	8b 45 08             	mov    0x8(%ebp),%eax
  801279:	8a 00                	mov    (%eax),%al
  80127b:	3c 09                	cmp    $0x9,%al
  80127d:	74 eb                	je     80126a <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  80127f:	8b 45 08             	mov    0x8(%ebp),%eax
  801282:	8a 00                	mov    (%eax),%al
  801284:	3c 2b                	cmp    $0x2b,%al
  801286:	75 05                	jne    80128d <strtol+0x39>
		s++;
  801288:	ff 45 08             	incl   0x8(%ebp)
  80128b:	eb 13                	jmp    8012a0 <strtol+0x4c>
	else if (*s == '-')
  80128d:	8b 45 08             	mov    0x8(%ebp),%eax
  801290:	8a 00                	mov    (%eax),%al
  801292:	3c 2d                	cmp    $0x2d,%al
  801294:	75 0a                	jne    8012a0 <strtol+0x4c>
		s++, neg = 1;
  801296:	ff 45 08             	incl   0x8(%ebp)
  801299:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8012a0:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8012a4:	74 06                	je     8012ac <strtol+0x58>
  8012a6:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  8012aa:	75 20                	jne    8012cc <strtol+0x78>
  8012ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8012af:	8a 00                	mov    (%eax),%al
  8012b1:	3c 30                	cmp    $0x30,%al
  8012b3:	75 17                	jne    8012cc <strtol+0x78>
  8012b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8012b8:	40                   	inc    %eax
  8012b9:	8a 00                	mov    (%eax),%al
  8012bb:	3c 78                	cmp    $0x78,%al
  8012bd:	75 0d                	jne    8012cc <strtol+0x78>
		s += 2, base = 16;
  8012bf:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  8012c3:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  8012ca:	eb 28                	jmp    8012f4 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  8012cc:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8012d0:	75 15                	jne    8012e7 <strtol+0x93>
  8012d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8012d5:	8a 00                	mov    (%eax),%al
  8012d7:	3c 30                	cmp    $0x30,%al
  8012d9:	75 0c                	jne    8012e7 <strtol+0x93>
		s++, base = 8;
  8012db:	ff 45 08             	incl   0x8(%ebp)
  8012de:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  8012e5:	eb 0d                	jmp    8012f4 <strtol+0xa0>
	else if (base == 0)
  8012e7:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8012eb:	75 07                	jne    8012f4 <strtol+0xa0>
		base = 10;
  8012ed:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8012f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8012f7:	8a 00                	mov    (%eax),%al
  8012f9:	3c 2f                	cmp    $0x2f,%al
  8012fb:	7e 19                	jle    801316 <strtol+0xc2>
  8012fd:	8b 45 08             	mov    0x8(%ebp),%eax
  801300:	8a 00                	mov    (%eax),%al
  801302:	3c 39                	cmp    $0x39,%al
  801304:	7f 10                	jg     801316 <strtol+0xc2>
			dig = *s - '0';
  801306:	8b 45 08             	mov    0x8(%ebp),%eax
  801309:	8a 00                	mov    (%eax),%al
  80130b:	0f be c0             	movsbl %al,%eax
  80130e:	83 e8 30             	sub    $0x30,%eax
  801311:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801314:	eb 42                	jmp    801358 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  801316:	8b 45 08             	mov    0x8(%ebp),%eax
  801319:	8a 00                	mov    (%eax),%al
  80131b:	3c 60                	cmp    $0x60,%al
  80131d:	7e 19                	jle    801338 <strtol+0xe4>
  80131f:	8b 45 08             	mov    0x8(%ebp),%eax
  801322:	8a 00                	mov    (%eax),%al
  801324:	3c 7a                	cmp    $0x7a,%al
  801326:	7f 10                	jg     801338 <strtol+0xe4>
			dig = *s - 'a' + 10;
  801328:	8b 45 08             	mov    0x8(%ebp),%eax
  80132b:	8a 00                	mov    (%eax),%al
  80132d:	0f be c0             	movsbl %al,%eax
  801330:	83 e8 57             	sub    $0x57,%eax
  801333:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801336:	eb 20                	jmp    801358 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  801338:	8b 45 08             	mov    0x8(%ebp),%eax
  80133b:	8a 00                	mov    (%eax),%al
  80133d:	3c 40                	cmp    $0x40,%al
  80133f:	7e 39                	jle    80137a <strtol+0x126>
  801341:	8b 45 08             	mov    0x8(%ebp),%eax
  801344:	8a 00                	mov    (%eax),%al
  801346:	3c 5a                	cmp    $0x5a,%al
  801348:	7f 30                	jg     80137a <strtol+0x126>
			dig = *s - 'A' + 10;
  80134a:	8b 45 08             	mov    0x8(%ebp),%eax
  80134d:	8a 00                	mov    (%eax),%al
  80134f:	0f be c0             	movsbl %al,%eax
  801352:	83 e8 37             	sub    $0x37,%eax
  801355:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  801358:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80135b:	3b 45 10             	cmp    0x10(%ebp),%eax
  80135e:	7d 19                	jge    801379 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801360:	ff 45 08             	incl   0x8(%ebp)
  801363:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801366:	0f af 45 10          	imul   0x10(%ebp),%eax
  80136a:	89 c2                	mov    %eax,%edx
  80136c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80136f:	01 d0                	add    %edx,%eax
  801371:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  801374:	e9 7b ff ff ff       	jmp    8012f4 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801379:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  80137a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80137e:	74 08                	je     801388 <strtol+0x134>
		*endptr = (char *) s;
  801380:	8b 45 0c             	mov    0xc(%ebp),%eax
  801383:	8b 55 08             	mov    0x8(%ebp),%edx
  801386:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  801388:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80138c:	74 07                	je     801395 <strtol+0x141>
  80138e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801391:	f7 d8                	neg    %eax
  801393:	eb 03                	jmp    801398 <strtol+0x144>
  801395:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801398:	c9                   	leave  
  801399:	c3                   	ret    

0080139a <ltostr>:

void
ltostr(long value, char *str)
{
  80139a:	55                   	push   %ebp
  80139b:	89 e5                	mov    %esp,%ebp
  80139d:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  8013a0:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  8013a7:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  8013ae:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8013b2:	79 13                	jns    8013c7 <ltostr+0x2d>
	{
		neg = 1;
  8013b4:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  8013bb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013be:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  8013c1:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  8013c4:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  8013c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8013ca:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8013cf:	99                   	cltd   
  8013d0:	f7 f9                	idiv   %ecx
  8013d2:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  8013d5:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8013d8:	8d 50 01             	lea    0x1(%eax),%edx
  8013db:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8013de:	89 c2                	mov    %eax,%edx
  8013e0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013e3:	01 d0                	add    %edx,%eax
  8013e5:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8013e8:	83 c2 30             	add    $0x30,%edx
  8013eb:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  8013ed:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8013f0:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8013f5:	f7 e9                	imul   %ecx
  8013f7:	c1 fa 02             	sar    $0x2,%edx
  8013fa:	89 c8                	mov    %ecx,%eax
  8013fc:	c1 f8 1f             	sar    $0x1f,%eax
  8013ff:	29 c2                	sub    %eax,%edx
  801401:	89 d0                	mov    %edx,%eax
  801403:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  801406:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80140a:	75 bb                	jne    8013c7 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  80140c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801413:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801416:	48                   	dec    %eax
  801417:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  80141a:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80141e:	74 3d                	je     80145d <ltostr+0xc3>
		start = 1 ;
  801420:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  801427:	eb 34                	jmp    80145d <ltostr+0xc3>
	{
		char tmp = str[start] ;
  801429:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80142c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80142f:	01 d0                	add    %edx,%eax
  801431:	8a 00                	mov    (%eax),%al
  801433:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801436:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801439:	8b 45 0c             	mov    0xc(%ebp),%eax
  80143c:	01 c2                	add    %eax,%edx
  80143e:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801441:	8b 45 0c             	mov    0xc(%ebp),%eax
  801444:	01 c8                	add    %ecx,%eax
  801446:	8a 00                	mov    (%eax),%al
  801448:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  80144a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80144d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801450:	01 c2                	add    %eax,%edx
  801452:	8a 45 eb             	mov    -0x15(%ebp),%al
  801455:	88 02                	mov    %al,(%edx)
		start++ ;
  801457:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  80145a:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  80145d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801460:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801463:	7c c4                	jl     801429 <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801465:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801468:	8b 45 0c             	mov    0xc(%ebp),%eax
  80146b:	01 d0                	add    %edx,%eax
  80146d:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801470:	90                   	nop
  801471:	c9                   	leave  
  801472:	c3                   	ret    

00801473 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  801473:	55                   	push   %ebp
  801474:	89 e5                	mov    %esp,%ebp
  801476:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801479:	ff 75 08             	pushl  0x8(%ebp)
  80147c:	e8 c4 f9 ff ff       	call   800e45 <strlen>
  801481:	83 c4 04             	add    $0x4,%esp
  801484:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  801487:	ff 75 0c             	pushl  0xc(%ebp)
  80148a:	e8 b6 f9 ff ff       	call   800e45 <strlen>
  80148f:	83 c4 04             	add    $0x4,%esp
  801492:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  801495:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  80149c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8014a3:	eb 17                	jmp    8014bc <strcconcat+0x49>
		final[s] = str1[s] ;
  8014a5:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8014a8:	8b 45 10             	mov    0x10(%ebp),%eax
  8014ab:	01 c2                	add    %eax,%edx
  8014ad:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8014b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8014b3:	01 c8                	add    %ecx,%eax
  8014b5:	8a 00                	mov    (%eax),%al
  8014b7:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  8014b9:	ff 45 fc             	incl   -0x4(%ebp)
  8014bc:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8014bf:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8014c2:	7c e1                	jl     8014a5 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  8014c4:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  8014cb:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8014d2:	eb 1f                	jmp    8014f3 <strcconcat+0x80>
		final[s++] = str2[i] ;
  8014d4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8014d7:	8d 50 01             	lea    0x1(%eax),%edx
  8014da:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8014dd:	89 c2                	mov    %eax,%edx
  8014df:	8b 45 10             	mov    0x10(%ebp),%eax
  8014e2:	01 c2                	add    %eax,%edx
  8014e4:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8014e7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014ea:	01 c8                	add    %ecx,%eax
  8014ec:	8a 00                	mov    (%eax),%al
  8014ee:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  8014f0:	ff 45 f8             	incl   -0x8(%ebp)
  8014f3:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8014f6:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8014f9:	7c d9                	jl     8014d4 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  8014fb:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8014fe:	8b 45 10             	mov    0x10(%ebp),%eax
  801501:	01 d0                	add    %edx,%eax
  801503:	c6 00 00             	movb   $0x0,(%eax)
}
  801506:	90                   	nop
  801507:	c9                   	leave  
  801508:	c3                   	ret    

00801509 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801509:	55                   	push   %ebp
  80150a:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  80150c:	8b 45 14             	mov    0x14(%ebp),%eax
  80150f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801515:	8b 45 14             	mov    0x14(%ebp),%eax
  801518:	8b 00                	mov    (%eax),%eax
  80151a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801521:	8b 45 10             	mov    0x10(%ebp),%eax
  801524:	01 d0                	add    %edx,%eax
  801526:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80152c:	eb 0c                	jmp    80153a <strsplit+0x31>
			*string++ = 0;
  80152e:	8b 45 08             	mov    0x8(%ebp),%eax
  801531:	8d 50 01             	lea    0x1(%eax),%edx
  801534:	89 55 08             	mov    %edx,0x8(%ebp)
  801537:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80153a:	8b 45 08             	mov    0x8(%ebp),%eax
  80153d:	8a 00                	mov    (%eax),%al
  80153f:	84 c0                	test   %al,%al
  801541:	74 18                	je     80155b <strsplit+0x52>
  801543:	8b 45 08             	mov    0x8(%ebp),%eax
  801546:	8a 00                	mov    (%eax),%al
  801548:	0f be c0             	movsbl %al,%eax
  80154b:	50                   	push   %eax
  80154c:	ff 75 0c             	pushl  0xc(%ebp)
  80154f:	e8 83 fa ff ff       	call   800fd7 <strchr>
  801554:	83 c4 08             	add    $0x8,%esp
  801557:	85 c0                	test   %eax,%eax
  801559:	75 d3                	jne    80152e <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  80155b:	8b 45 08             	mov    0x8(%ebp),%eax
  80155e:	8a 00                	mov    (%eax),%al
  801560:	84 c0                	test   %al,%al
  801562:	74 5a                	je     8015be <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801564:	8b 45 14             	mov    0x14(%ebp),%eax
  801567:	8b 00                	mov    (%eax),%eax
  801569:	83 f8 0f             	cmp    $0xf,%eax
  80156c:	75 07                	jne    801575 <strsplit+0x6c>
		{
			return 0;
  80156e:	b8 00 00 00 00       	mov    $0x0,%eax
  801573:	eb 66                	jmp    8015db <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801575:	8b 45 14             	mov    0x14(%ebp),%eax
  801578:	8b 00                	mov    (%eax),%eax
  80157a:	8d 48 01             	lea    0x1(%eax),%ecx
  80157d:	8b 55 14             	mov    0x14(%ebp),%edx
  801580:	89 0a                	mov    %ecx,(%edx)
  801582:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801589:	8b 45 10             	mov    0x10(%ebp),%eax
  80158c:	01 c2                	add    %eax,%edx
  80158e:	8b 45 08             	mov    0x8(%ebp),%eax
  801591:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801593:	eb 03                	jmp    801598 <strsplit+0x8f>
			string++;
  801595:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801598:	8b 45 08             	mov    0x8(%ebp),%eax
  80159b:	8a 00                	mov    (%eax),%al
  80159d:	84 c0                	test   %al,%al
  80159f:	74 8b                	je     80152c <strsplit+0x23>
  8015a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8015a4:	8a 00                	mov    (%eax),%al
  8015a6:	0f be c0             	movsbl %al,%eax
  8015a9:	50                   	push   %eax
  8015aa:	ff 75 0c             	pushl  0xc(%ebp)
  8015ad:	e8 25 fa ff ff       	call   800fd7 <strchr>
  8015b2:	83 c4 08             	add    $0x8,%esp
  8015b5:	85 c0                	test   %eax,%eax
  8015b7:	74 dc                	je     801595 <strsplit+0x8c>
			string++;
	}
  8015b9:	e9 6e ff ff ff       	jmp    80152c <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  8015be:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  8015bf:	8b 45 14             	mov    0x14(%ebp),%eax
  8015c2:	8b 00                	mov    (%eax),%eax
  8015c4:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8015cb:	8b 45 10             	mov    0x10(%ebp),%eax
  8015ce:	01 d0                	add    %edx,%eax
  8015d0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  8015d6:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8015db:	c9                   	leave  
  8015dc:	c3                   	ret    

008015dd <str2lower>:


char* str2lower(char *dst, const char *src)
{
  8015dd:	55                   	push   %ebp
  8015de:	89 e5                	mov    %esp,%ebp
  8015e0:	83 ec 10             	sub    $0x10,%esp
	char* ret = dst;
  8015e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8015e6:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (int i = 0; i < strlen(src); ++i)
  8015e9:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8015f0:	eb 4a                	jmp    80163c <str2lower+0x5f>
	{
		dst[i] = src[i] ;
  8015f2:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8015f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8015f8:	01 c2                	add    %eax,%edx
  8015fa:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8015fd:	8b 45 0c             	mov    0xc(%ebp),%eax
  801600:	01 c8                	add    %ecx,%eax
  801602:	8a 00                	mov    (%eax),%al
  801604:	88 02                	mov    %al,(%edx)
		if (src[i] >= 'A' && src[i] <= 'Z')
  801606:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801609:	8b 45 0c             	mov    0xc(%ebp),%eax
  80160c:	01 d0                	add    %edx,%eax
  80160e:	8a 00                	mov    (%eax),%al
  801610:	3c 40                	cmp    $0x40,%al
  801612:	7e 25                	jle    801639 <str2lower+0x5c>
  801614:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801617:	8b 45 0c             	mov    0xc(%ebp),%eax
  80161a:	01 d0                	add    %edx,%eax
  80161c:	8a 00                	mov    (%eax),%al
  80161e:	3c 5a                	cmp    $0x5a,%al
  801620:	7f 17                	jg     801639 <str2lower+0x5c>
		{
			dst[i] += 32 ;
  801622:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801625:	8b 45 08             	mov    0x8(%ebp),%eax
  801628:	01 d0                	add    %edx,%eax
  80162a:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  80162d:	8b 55 08             	mov    0x8(%ebp),%edx
  801630:	01 ca                	add    %ecx,%edx
  801632:	8a 12                	mov    (%edx),%dl
  801634:	83 c2 20             	add    $0x20,%edx
  801637:	88 10                	mov    %dl,(%eax)


char* str2lower(char *dst, const char *src)
{
	char* ret = dst;
	for (int i = 0; i < strlen(src); ++i)
  801639:	ff 45 fc             	incl   -0x4(%ebp)
  80163c:	ff 75 0c             	pushl  0xc(%ebp)
  80163f:	e8 01 f8 ff ff       	call   800e45 <strlen>
  801644:	83 c4 04             	add    $0x4,%esp
  801647:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  80164a:	7f a6                	jg     8015f2 <str2lower+0x15>
		if (src[i] >= 'A' && src[i] <= 'Z')
		{
			dst[i] += 32 ;
		}
	}
	return ret;
  80164c:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  80164f:	c9                   	leave  
  801650:	c3                   	ret    

00801651 <uheap_init>:
//==============================================
// [1] INITIALIZE USER HEAP:
//==============================================
int __firstTimeFlag = 1;
void uheap_init()
{
  801651:	55                   	push   %ebp
  801652:	89 e5                	mov    %esp,%ebp
  801654:	83 ec 08             	sub    $0x8,%esp
	if(__firstTimeFlag)
  801657:	a1 08 40 80 00       	mov    0x804008,%eax
  80165c:	85 c0                	test   %eax,%eax
  80165e:	74 42                	je     8016a2 <uheap_init+0x51>
	{
		initialize_dynamic_allocator(USER_HEAP_START, USER_HEAP_START + DYN_ALLOC_MAX_SIZE);
  801660:	83 ec 08             	sub    $0x8,%esp
  801663:	68 00 00 00 82       	push   $0x82000000
  801668:	68 00 00 00 80       	push   $0x80000000
  80166d:	e8 00 08 00 00       	call   801e72 <initialize_dynamic_allocator>
  801672:	83 c4 10             	add    $0x10,%esp
		uheapPlaceStrategy = sys_get_uheap_strategy();
  801675:	e8 e7 05 00 00       	call   801c61 <sys_get_uheap_strategy>
  80167a:	a3 00 db 87 00       	mov    %eax,0x87db00
		uheapPageAllocStart = dynAllocEnd + PAGE_SIZE;
  80167f:	a1 40 40 80 00       	mov    0x804040,%eax
  801684:	05 00 10 00 00       	add    $0x1000,%eax
  801689:	a3 b0 db 87 00       	mov    %eax,0x87dbb0
		uheapPageAllocBreak = uheapPageAllocStart;
  80168e:	a1 b0 db 87 00       	mov    0x87dbb0,%eax
  801693:	a3 08 db 87 00       	mov    %eax,0x87db08

		__firstTimeFlag = 0;
  801698:	c7 05 08 40 80 00 00 	movl   $0x0,0x804008
  80169f:	00 00 00 
	}
}
  8016a2:	90                   	nop
  8016a3:	c9                   	leave  
  8016a4:	c3                   	ret    

008016a5 <get_page>:

//==============================================
// [2] GET A PAGE FROM THE KERNEL FOR DA:
//==============================================
int get_page(void* va)
{
  8016a5:	55                   	push   %ebp
  8016a6:	89 e5                	mov    %esp,%ebp
  8016a8:	83 ec 18             	sub    $0x18,%esp
	int ret = __sys_allocate_page(ROUNDDOWN(va, PAGE_SIZE), PERM_USER|PERM_WRITEABLE|PERM_UHPAGE);
  8016ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8016ae:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8016b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8016b4:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8016b9:	83 ec 08             	sub    $0x8,%esp
  8016bc:	68 06 04 00 00       	push   $0x406
  8016c1:	50                   	push   %eax
  8016c2:	e8 e4 01 00 00       	call   8018ab <__sys_allocate_page>
  8016c7:	83 c4 10             	add    $0x10,%esp
  8016ca:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (ret < 0)
  8016cd:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8016d1:	79 14                	jns    8016e7 <get_page+0x42>
		panic("get_page() in user: failed to allocate page from the kernel");
  8016d3:	83 ec 04             	sub    $0x4,%esp
  8016d6:	68 e8 32 80 00       	push   $0x8032e8
  8016db:	6a 1f                	push   $0x1f
  8016dd:	68 24 33 80 00       	push   $0x803324
  8016e2:	e8 e5 11 00 00       	call   8028cc <_panic>
	return 0;
  8016e7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8016ec:	c9                   	leave  
  8016ed:	c3                   	ret    

008016ee <return_page>:

//==============================================
// [3] RETURN A PAGE FROM THE DA TO KERNEL:
//==============================================
void return_page(void* va)
{
  8016ee:	55                   	push   %ebp
  8016ef:	89 e5                	mov    %esp,%ebp
  8016f1:	83 ec 18             	sub    $0x18,%esp
	int ret = __sys_unmap_frame(ROUNDDOWN((uint32)va, PAGE_SIZE));
  8016f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8016f7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8016fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8016fd:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801702:	83 ec 0c             	sub    $0xc,%esp
  801705:	50                   	push   %eax
  801706:	e8 e7 01 00 00       	call   8018f2 <__sys_unmap_frame>
  80170b:	83 c4 10             	add    $0x10,%esp
  80170e:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (ret < 0)
  801711:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801715:	79 14                	jns    80172b <return_page+0x3d>
		panic("return_page() in user: failed to return a page to the kernel");
  801717:	83 ec 04             	sub    $0x4,%esp
  80171a:	68 30 33 80 00       	push   $0x803330
  80171f:	6a 2a                	push   $0x2a
  801721:	68 24 33 80 00       	push   $0x803324
  801726:	e8 a1 11 00 00       	call   8028cc <_panic>
}
  80172b:	90                   	nop
  80172c:	c9                   	leave  
  80172d:	c3                   	ret    

0080172e <malloc>:

//=================================
// [1] ALLOCATE SPACE IN USER HEAP:
//=================================
void* malloc(uint32 size)
{
  80172e:	55                   	push   %ebp
  80172f:	89 e5                	mov    %esp,%ebp
  801731:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  801734:	e8 18 ff ff ff       	call   801651 <uheap_init>
	if (size == 0) return NULL ;
  801739:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80173d:	75 07                	jne    801746 <malloc+0x18>
  80173f:	b8 00 00 00 00       	mov    $0x0,%eax
  801744:	eb 14                	jmp    80175a <malloc+0x2c>
	//==============================================================
	//TODO: [PROJECT'25.IM#2] USER HEAP - #1 malloc
	//Your code is here
	//Comment the following line
	panic("malloc() is not implemented yet...!!");
  801746:	83 ec 04             	sub    $0x4,%esp
  801749:	68 70 33 80 00       	push   $0x803370
  80174e:	6a 3e                	push   $0x3e
  801750:	68 24 33 80 00       	push   $0x803324
  801755:	e8 72 11 00 00       	call   8028cc <_panic>
}
  80175a:	c9                   	leave  
  80175b:	c3                   	ret    

0080175c <free>:

//=================================
// [2] FREE SPACE FROM USER HEAP:
//=================================
void free(void* virtual_address)
{
  80175c:	55                   	push   %ebp
  80175d:	89 e5                	mov    %esp,%ebp
  80175f:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.IM#2] USER HEAP - #3 free
	//Your code is here
	//Comment the following line
	panic("free() is not implemented yet...!!");
  801762:	83 ec 04             	sub    $0x4,%esp
  801765:	68 98 33 80 00       	push   $0x803398
  80176a:	6a 49                	push   $0x49
  80176c:	68 24 33 80 00       	push   $0x803324
  801771:	e8 56 11 00 00       	call   8028cc <_panic>

00801776 <smalloc>:

//=================================
// [3] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  801776:	55                   	push   %ebp
  801777:	89 e5                	mov    %esp,%ebp
  801779:	83 ec 18             	sub    $0x18,%esp
  80177c:	8b 45 10             	mov    0x10(%ebp),%eax
  80177f:	88 45 f4             	mov    %al,-0xc(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  801782:	e8 ca fe ff ff       	call   801651 <uheap_init>
	if (size == 0) return NULL ;
  801787:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80178b:	75 07                	jne    801794 <smalloc+0x1e>
  80178d:	b8 00 00 00 00       	mov    $0x0,%eax
  801792:	eb 14                	jmp    8017a8 <smalloc+0x32>
	//==============================================================

	//TODO: [PROJECT'25.IM#3] SHARED MEMORY - #2 smalloc
	//Your code is here
	//Comment the following line
	panic("smalloc() is not implemented yet...!!");
  801794:	83 ec 04             	sub    $0x4,%esp
  801797:	68 bc 33 80 00       	push   $0x8033bc
  80179c:	6a 5a                	push   $0x5a
  80179e:	68 24 33 80 00       	push   $0x803324
  8017a3:	e8 24 11 00 00       	call   8028cc <_panic>
}
  8017a8:	c9                   	leave  
  8017a9:	c3                   	ret    

008017aa <sget>:

//========================================
// [4] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  8017aa:	55                   	push   %ebp
  8017ab:	89 e5                	mov    %esp,%ebp
  8017ad:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  8017b0:	e8 9c fe ff ff       	call   801651 <uheap_init>
	//==============================================================

	//TODO: [PROJECT'25.IM#3] SHARED MEMORY - #4 sget
	//Your code is here
	//Comment the following line
	panic("sget() is not implemented yet...!!");
  8017b5:	83 ec 04             	sub    $0x4,%esp
  8017b8:	68 e4 33 80 00       	push   $0x8033e4
  8017bd:	6a 6a                	push   $0x6a
  8017bf:	68 24 33 80 00       	push   $0x803324
  8017c4:	e8 03 11 00 00       	call   8028cc <_panic>

008017c9 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  8017c9:	55                   	push   %ebp
  8017ca:	89 e5                	mov    %esp,%ebp
  8017cc:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  8017cf:	e8 7d fe ff ff       	call   801651 <uheap_init>
	//==============================================================
	panic("realloc() is not implemented yet...!!");
  8017d4:	83 ec 04             	sub    $0x4,%esp
  8017d7:	68 08 34 80 00       	push   $0x803408
  8017dc:	68 88 00 00 00       	push   $0x88
  8017e1:	68 24 33 80 00       	push   $0x803324
  8017e6:	e8 e1 10 00 00       	call   8028cc <_panic>

008017eb <sfree>:
//
//	use sys_delete_shared_object(...); which switches to the kernel mode,
//	calls delete_shared_object(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the delete_shared_object() function is empty, make sure to implement it.
void sfree(void* virtual_address)
{
  8017eb:	55                   	push   %ebp
  8017ec:	89 e5                	mov    %esp,%ebp
  8017ee:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.BONUS#5] EXIT #2 - sfree
	//Your code is here
	//Comment the following line
	panic("sfree() is not implemented yet...!!");
  8017f1:	83 ec 04             	sub    $0x4,%esp
  8017f4:	68 30 34 80 00       	push   $0x803430
  8017f9:	68 9b 00 00 00       	push   $0x9b
  8017fe:	68 24 33 80 00       	push   $0x803324
  801803:	e8 c4 10 00 00       	call   8028cc <_panic>

00801808 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801808:	55                   	push   %ebp
  801809:	89 e5                	mov    %esp,%ebp
  80180b:	57                   	push   %edi
  80180c:	56                   	push   %esi
  80180d:	53                   	push   %ebx
  80180e:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801811:	8b 45 08             	mov    0x8(%ebp),%eax
  801814:	8b 55 0c             	mov    0xc(%ebp),%edx
  801817:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80181a:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80181d:	8b 7d 18             	mov    0x18(%ebp),%edi
  801820:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801823:	cd 30                	int    $0x30
  801825:	89 45 f0             	mov    %eax,-0x10(%ebp)
				"b" (a3),
				"D" (a4),
				"S" (a5)
				: "cc", "memory");

	return ret;
  801828:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80182b:	83 c4 10             	add    $0x10,%esp
  80182e:	5b                   	pop    %ebx
  80182f:	5e                   	pop    %esi
  801830:	5f                   	pop    %edi
  801831:	5d                   	pop    %ebp
  801832:	c3                   	ret    

00801833 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName, int color)
{
  801833:	55                   	push   %ebp
  801834:	89 e5                	mov    %esp,%ebp
  801836:	83 ec 04             	sub    $0x4,%esp
  801839:	8b 45 10             	mov    0x10(%ebp),%eax
  80183c:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, color, 0);
  80183f:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801842:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801846:	8b 45 08             	mov    0x8(%ebp),%eax
  801849:	6a 00                	push   $0x0
  80184b:	51                   	push   %ecx
  80184c:	52                   	push   %edx
  80184d:	ff 75 0c             	pushl  0xc(%ebp)
  801850:	50                   	push   %eax
  801851:	6a 00                	push   $0x0
  801853:	e8 b0 ff ff ff       	call   801808 <syscall>
  801858:	83 c4 18             	add    $0x18,%esp
}
  80185b:	90                   	nop
  80185c:	c9                   	leave  
  80185d:	c3                   	ret    

0080185e <sys_cgetc>:

int
sys_cgetc(void)
{
  80185e:	55                   	push   %ebp
  80185f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801861:	6a 00                	push   $0x0
  801863:	6a 00                	push   $0x0
  801865:	6a 00                	push   $0x0
  801867:	6a 00                	push   $0x0
  801869:	6a 00                	push   $0x0
  80186b:	6a 02                	push   $0x2
  80186d:	e8 96 ff ff ff       	call   801808 <syscall>
  801872:	83 c4 18             	add    $0x18,%esp
}
  801875:	c9                   	leave  
  801876:	c3                   	ret    

00801877 <sys_lock_cons>:

void sys_lock_cons(void)
{
  801877:	55                   	push   %ebp
  801878:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  80187a:	6a 00                	push   $0x0
  80187c:	6a 00                	push   $0x0
  80187e:	6a 00                	push   $0x0
  801880:	6a 00                	push   $0x0
  801882:	6a 00                	push   $0x0
  801884:	6a 03                	push   $0x3
  801886:	e8 7d ff ff ff       	call   801808 <syscall>
  80188b:	83 c4 18             	add    $0x18,%esp
}
  80188e:	90                   	nop
  80188f:	c9                   	leave  
  801890:	c3                   	ret    

00801891 <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  801891:	55                   	push   %ebp
  801892:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  801894:	6a 00                	push   $0x0
  801896:	6a 00                	push   $0x0
  801898:	6a 00                	push   $0x0
  80189a:	6a 00                	push   $0x0
  80189c:	6a 00                	push   $0x0
  80189e:	6a 04                	push   $0x4
  8018a0:	e8 63 ff ff ff       	call   801808 <syscall>
  8018a5:	83 c4 18             	add    $0x18,%esp
}
  8018a8:	90                   	nop
  8018a9:	c9                   	leave  
  8018aa:	c3                   	ret    

008018ab <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  8018ab:	55                   	push   %ebp
  8018ac:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  8018ae:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8018b4:	6a 00                	push   $0x0
  8018b6:	6a 00                	push   $0x0
  8018b8:	6a 00                	push   $0x0
  8018ba:	52                   	push   %edx
  8018bb:	50                   	push   %eax
  8018bc:	6a 08                	push   $0x8
  8018be:	e8 45 ff ff ff       	call   801808 <syscall>
  8018c3:	83 c4 18             	add    $0x18,%esp
}
  8018c6:	c9                   	leave  
  8018c7:	c3                   	ret    

008018c8 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  8018c8:	55                   	push   %ebp
  8018c9:	89 e5                	mov    %esp,%ebp
  8018cb:	56                   	push   %esi
  8018cc:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  8018cd:	8b 75 18             	mov    0x18(%ebp),%esi
  8018d0:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8018d3:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8018d6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8018dc:	56                   	push   %esi
  8018dd:	53                   	push   %ebx
  8018de:	51                   	push   %ecx
  8018df:	52                   	push   %edx
  8018e0:	50                   	push   %eax
  8018e1:	6a 09                	push   $0x9
  8018e3:	e8 20 ff ff ff       	call   801808 <syscall>
  8018e8:	83 c4 18             	add    $0x18,%esp
}
  8018eb:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8018ee:	5b                   	pop    %ebx
  8018ef:	5e                   	pop    %esi
  8018f0:	5d                   	pop    %ebp
  8018f1:	c3                   	ret    

008018f2 <__sys_unmap_frame>:

int __sys_unmap_frame(uint32 va)
{
  8018f2:	55                   	push   %ebp
  8018f3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, va, 0, 0, 0, 0);
  8018f5:	6a 00                	push   $0x0
  8018f7:	6a 00                	push   $0x0
  8018f9:	6a 00                	push   $0x0
  8018fb:	6a 00                	push   $0x0
  8018fd:	ff 75 08             	pushl  0x8(%ebp)
  801900:	6a 0a                	push   $0xa
  801902:	e8 01 ff ff ff       	call   801808 <syscall>
  801907:	83 c4 18             	add    $0x18,%esp
}
  80190a:	c9                   	leave  
  80190b:	c3                   	ret    

0080190c <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  80190c:	55                   	push   %ebp
  80190d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  80190f:	6a 00                	push   $0x0
  801911:	6a 00                	push   $0x0
  801913:	6a 00                	push   $0x0
  801915:	ff 75 0c             	pushl  0xc(%ebp)
  801918:	ff 75 08             	pushl  0x8(%ebp)
  80191b:	6a 0b                	push   $0xb
  80191d:	e8 e6 fe ff ff       	call   801808 <syscall>
  801922:	83 c4 18             	add    $0x18,%esp
}
  801925:	c9                   	leave  
  801926:	c3                   	ret    

00801927 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801927:	55                   	push   %ebp
  801928:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  80192a:	6a 00                	push   $0x0
  80192c:	6a 00                	push   $0x0
  80192e:	6a 00                	push   $0x0
  801930:	6a 00                	push   $0x0
  801932:	6a 00                	push   $0x0
  801934:	6a 0c                	push   $0xc
  801936:	e8 cd fe ff ff       	call   801808 <syscall>
  80193b:	83 c4 18             	add    $0x18,%esp
}
  80193e:	c9                   	leave  
  80193f:	c3                   	ret    

00801940 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801940:	55                   	push   %ebp
  801941:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801943:	6a 00                	push   $0x0
  801945:	6a 00                	push   $0x0
  801947:	6a 00                	push   $0x0
  801949:	6a 00                	push   $0x0
  80194b:	6a 00                	push   $0x0
  80194d:	6a 0d                	push   $0xd
  80194f:	e8 b4 fe ff ff       	call   801808 <syscall>
  801954:	83 c4 18             	add    $0x18,%esp
}
  801957:	c9                   	leave  
  801958:	c3                   	ret    

00801959 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801959:	55                   	push   %ebp
  80195a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  80195c:	6a 00                	push   $0x0
  80195e:	6a 00                	push   $0x0
  801960:	6a 00                	push   $0x0
  801962:	6a 00                	push   $0x0
  801964:	6a 00                	push   $0x0
  801966:	6a 0e                	push   $0xe
  801968:	e8 9b fe ff ff       	call   801808 <syscall>
  80196d:	83 c4 18             	add    $0x18,%esp
}
  801970:	c9                   	leave  
  801971:	c3                   	ret    

00801972 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801972:	55                   	push   %ebp
  801973:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801975:	6a 00                	push   $0x0
  801977:	6a 00                	push   $0x0
  801979:	6a 00                	push   $0x0
  80197b:	6a 00                	push   $0x0
  80197d:	6a 00                	push   $0x0
  80197f:	6a 0f                	push   $0xf
  801981:	e8 82 fe ff ff       	call   801808 <syscall>
  801986:	83 c4 18             	add    $0x18,%esp
}
  801989:	c9                   	leave  
  80198a:	c3                   	ret    

0080198b <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  80198b:	55                   	push   %ebp
  80198c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  80198e:	6a 00                	push   $0x0
  801990:	6a 00                	push   $0x0
  801992:	6a 00                	push   $0x0
  801994:	6a 00                	push   $0x0
  801996:	ff 75 08             	pushl  0x8(%ebp)
  801999:	6a 10                	push   $0x10
  80199b:	e8 68 fe ff ff       	call   801808 <syscall>
  8019a0:	83 c4 18             	add    $0x18,%esp
}
  8019a3:	c9                   	leave  
  8019a4:	c3                   	ret    

008019a5 <sys_scarce_memory>:

void sys_scarce_memory()
{
  8019a5:	55                   	push   %ebp
  8019a6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  8019a8:	6a 00                	push   $0x0
  8019aa:	6a 00                	push   $0x0
  8019ac:	6a 00                	push   $0x0
  8019ae:	6a 00                	push   $0x0
  8019b0:	6a 00                	push   $0x0
  8019b2:	6a 11                	push   $0x11
  8019b4:	e8 4f fe ff ff       	call   801808 <syscall>
  8019b9:	83 c4 18             	add    $0x18,%esp
}
  8019bc:	90                   	nop
  8019bd:	c9                   	leave  
  8019be:	c3                   	ret    

008019bf <sys_cputc>:

void
sys_cputc(const char c)
{
  8019bf:	55                   	push   %ebp
  8019c0:	89 e5                	mov    %esp,%ebp
  8019c2:	83 ec 04             	sub    $0x4,%esp
  8019c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8019c8:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  8019cb:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8019cf:	6a 00                	push   $0x0
  8019d1:	6a 00                	push   $0x0
  8019d3:	6a 00                	push   $0x0
  8019d5:	6a 00                	push   $0x0
  8019d7:	50                   	push   %eax
  8019d8:	6a 01                	push   $0x1
  8019da:	e8 29 fe ff ff       	call   801808 <syscall>
  8019df:	83 c4 18             	add    $0x18,%esp
}
  8019e2:	90                   	nop
  8019e3:	c9                   	leave  
  8019e4:	c3                   	ret    

008019e5 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  8019e5:	55                   	push   %ebp
  8019e6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  8019e8:	6a 00                	push   $0x0
  8019ea:	6a 00                	push   $0x0
  8019ec:	6a 00                	push   $0x0
  8019ee:	6a 00                	push   $0x0
  8019f0:	6a 00                	push   $0x0
  8019f2:	6a 14                	push   $0x14
  8019f4:	e8 0f fe ff ff       	call   801808 <syscall>
  8019f9:	83 c4 18             	add    $0x18,%esp
}
  8019fc:	90                   	nop
  8019fd:	c9                   	leave  
  8019fe:	c3                   	ret    

008019ff <sys_create_shared_object>:

int sys_create_shared_object(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  8019ff:	55                   	push   %ebp
  801a00:	89 e5                	mov    %esp,%ebp
  801a02:	83 ec 04             	sub    $0x4,%esp
  801a05:	8b 45 10             	mov    0x10(%ebp),%eax
  801a08:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801a0b:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801a0e:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801a12:	8b 45 08             	mov    0x8(%ebp),%eax
  801a15:	6a 00                	push   $0x0
  801a17:	51                   	push   %ecx
  801a18:	52                   	push   %edx
  801a19:	ff 75 0c             	pushl  0xc(%ebp)
  801a1c:	50                   	push   %eax
  801a1d:	6a 15                	push   $0x15
  801a1f:	e8 e4 fd ff ff       	call   801808 <syscall>
  801a24:	83 c4 18             	add    $0x18,%esp
}
  801a27:	c9                   	leave  
  801a28:	c3                   	ret    

00801a29 <sys_size_of_shared_object>:

//2017:
int sys_size_of_shared_object(int32 ownerID, char* shareName)
{
  801a29:	55                   	push   %ebp
  801a2a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801a2c:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a2f:	8b 45 08             	mov    0x8(%ebp),%eax
  801a32:	6a 00                	push   $0x0
  801a34:	6a 00                	push   $0x0
  801a36:	6a 00                	push   $0x0
  801a38:	52                   	push   %edx
  801a39:	50                   	push   %eax
  801a3a:	6a 16                	push   $0x16
  801a3c:	e8 c7 fd ff ff       	call   801808 <syscall>
  801a41:	83 c4 18             	add    $0x18,%esp
}
  801a44:	c9                   	leave  
  801a45:	c3                   	ret    

00801a46 <sys_get_shared_object>:
//==========

int sys_get_shared_object(int32 ownerID, char* shareName, void* virtual_address)
{
  801a46:	55                   	push   %ebp
  801a47:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801a49:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801a4c:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a4f:	8b 45 08             	mov    0x8(%ebp),%eax
  801a52:	6a 00                	push   $0x0
  801a54:	6a 00                	push   $0x0
  801a56:	51                   	push   %ecx
  801a57:	52                   	push   %edx
  801a58:	50                   	push   %eax
  801a59:	6a 17                	push   $0x17
  801a5b:	e8 a8 fd ff ff       	call   801808 <syscall>
  801a60:	83 c4 18             	add    $0x18,%esp
}
  801a63:	c9                   	leave  
  801a64:	c3                   	ret    

00801a65 <sys_delete_shared_object>:

int sys_delete_shared_object(int32 sharedObjectID, void *startVA)
{
  801a65:	55                   	push   %ebp
  801a66:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801a68:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a6b:	8b 45 08             	mov    0x8(%ebp),%eax
  801a6e:	6a 00                	push   $0x0
  801a70:	6a 00                	push   $0x0
  801a72:	6a 00                	push   $0x0
  801a74:	52                   	push   %edx
  801a75:	50                   	push   %eax
  801a76:	6a 18                	push   $0x18
  801a78:	e8 8b fd ff ff       	call   801808 <syscall>
  801a7d:	83 c4 18             	add    $0x18,%esp
}
  801a80:	c9                   	leave  
  801a81:	c3                   	ret    

00801a82 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801a82:	55                   	push   %ebp
  801a83:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801a85:	8b 45 08             	mov    0x8(%ebp),%eax
  801a88:	6a 00                	push   $0x0
  801a8a:	ff 75 14             	pushl  0x14(%ebp)
  801a8d:	ff 75 10             	pushl  0x10(%ebp)
  801a90:	ff 75 0c             	pushl  0xc(%ebp)
  801a93:	50                   	push   %eax
  801a94:	6a 19                	push   $0x19
  801a96:	e8 6d fd ff ff       	call   801808 <syscall>
  801a9b:	83 c4 18             	add    $0x18,%esp
}
  801a9e:	c9                   	leave  
  801a9f:	c3                   	ret    

00801aa0 <sys_run_env>:

void sys_run_env(int32 envId)
{
  801aa0:	55                   	push   %ebp
  801aa1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801aa3:	8b 45 08             	mov    0x8(%ebp),%eax
  801aa6:	6a 00                	push   $0x0
  801aa8:	6a 00                	push   $0x0
  801aaa:	6a 00                	push   $0x0
  801aac:	6a 00                	push   $0x0
  801aae:	50                   	push   %eax
  801aaf:	6a 1a                	push   $0x1a
  801ab1:	e8 52 fd ff ff       	call   801808 <syscall>
  801ab6:	83 c4 18             	add    $0x18,%esp
}
  801ab9:	90                   	nop
  801aba:	c9                   	leave  
  801abb:	c3                   	ret    

00801abc <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801abc:	55                   	push   %ebp
  801abd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801abf:	8b 45 08             	mov    0x8(%ebp),%eax
  801ac2:	6a 00                	push   $0x0
  801ac4:	6a 00                	push   $0x0
  801ac6:	6a 00                	push   $0x0
  801ac8:	6a 00                	push   $0x0
  801aca:	50                   	push   %eax
  801acb:	6a 1b                	push   $0x1b
  801acd:	e8 36 fd ff ff       	call   801808 <syscall>
  801ad2:	83 c4 18             	add    $0x18,%esp
}
  801ad5:	c9                   	leave  
  801ad6:	c3                   	ret    

00801ad7 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801ad7:	55                   	push   %ebp
  801ad8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801ada:	6a 00                	push   $0x0
  801adc:	6a 00                	push   $0x0
  801ade:	6a 00                	push   $0x0
  801ae0:	6a 00                	push   $0x0
  801ae2:	6a 00                	push   $0x0
  801ae4:	6a 05                	push   $0x5
  801ae6:	e8 1d fd ff ff       	call   801808 <syscall>
  801aeb:	83 c4 18             	add    $0x18,%esp
}
  801aee:	c9                   	leave  
  801aef:	c3                   	ret    

00801af0 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801af0:	55                   	push   %ebp
  801af1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801af3:	6a 00                	push   $0x0
  801af5:	6a 00                	push   $0x0
  801af7:	6a 00                	push   $0x0
  801af9:	6a 00                	push   $0x0
  801afb:	6a 00                	push   $0x0
  801afd:	6a 06                	push   $0x6
  801aff:	e8 04 fd ff ff       	call   801808 <syscall>
  801b04:	83 c4 18             	add    $0x18,%esp
}
  801b07:	c9                   	leave  
  801b08:	c3                   	ret    

00801b09 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801b09:	55                   	push   %ebp
  801b0a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801b0c:	6a 00                	push   $0x0
  801b0e:	6a 00                	push   $0x0
  801b10:	6a 00                	push   $0x0
  801b12:	6a 00                	push   $0x0
  801b14:	6a 00                	push   $0x0
  801b16:	6a 07                	push   $0x7
  801b18:	e8 eb fc ff ff       	call   801808 <syscall>
  801b1d:	83 c4 18             	add    $0x18,%esp
}
  801b20:	c9                   	leave  
  801b21:	c3                   	ret    

00801b22 <sys_exit_env>:


void sys_exit_env(void)
{
  801b22:	55                   	push   %ebp
  801b23:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801b25:	6a 00                	push   $0x0
  801b27:	6a 00                	push   $0x0
  801b29:	6a 00                	push   $0x0
  801b2b:	6a 00                	push   $0x0
  801b2d:	6a 00                	push   $0x0
  801b2f:	6a 1c                	push   $0x1c
  801b31:	e8 d2 fc ff ff       	call   801808 <syscall>
  801b36:	83 c4 18             	add    $0x18,%esp
}
  801b39:	90                   	nop
  801b3a:	c9                   	leave  
  801b3b:	c3                   	ret    

00801b3c <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  801b3c:	55                   	push   %ebp
  801b3d:	89 e5                	mov    %esp,%ebp
  801b3f:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801b42:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801b45:	8d 50 04             	lea    0x4(%eax),%edx
  801b48:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801b4b:	6a 00                	push   $0x0
  801b4d:	6a 00                	push   $0x0
  801b4f:	6a 00                	push   $0x0
  801b51:	52                   	push   %edx
  801b52:	50                   	push   %eax
  801b53:	6a 1d                	push   $0x1d
  801b55:	e8 ae fc ff ff       	call   801808 <syscall>
  801b5a:	83 c4 18             	add    $0x18,%esp
	return result;
  801b5d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801b60:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801b63:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801b66:	89 01                	mov    %eax,(%ecx)
  801b68:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801b6b:	8b 45 08             	mov    0x8(%ebp),%eax
  801b6e:	c9                   	leave  
  801b6f:	c2 04 00             	ret    $0x4

00801b72 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801b72:	55                   	push   %ebp
  801b73:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801b75:	6a 00                	push   $0x0
  801b77:	6a 00                	push   $0x0
  801b79:	ff 75 10             	pushl  0x10(%ebp)
  801b7c:	ff 75 0c             	pushl  0xc(%ebp)
  801b7f:	ff 75 08             	pushl  0x8(%ebp)
  801b82:	6a 13                	push   $0x13
  801b84:	e8 7f fc ff ff       	call   801808 <syscall>
  801b89:	83 c4 18             	add    $0x18,%esp
	return ;
  801b8c:	90                   	nop
}
  801b8d:	c9                   	leave  
  801b8e:	c3                   	ret    

00801b8f <sys_rcr2>:
uint32 sys_rcr2()
{
  801b8f:	55                   	push   %ebp
  801b90:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801b92:	6a 00                	push   $0x0
  801b94:	6a 00                	push   $0x0
  801b96:	6a 00                	push   $0x0
  801b98:	6a 00                	push   $0x0
  801b9a:	6a 00                	push   $0x0
  801b9c:	6a 1e                	push   $0x1e
  801b9e:	e8 65 fc ff ff       	call   801808 <syscall>
  801ba3:	83 c4 18             	add    $0x18,%esp
}
  801ba6:	c9                   	leave  
  801ba7:	c3                   	ret    

00801ba8 <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  801ba8:	55                   	push   %ebp
  801ba9:	89 e5                	mov    %esp,%ebp
  801bab:	83 ec 04             	sub    $0x4,%esp
  801bae:	8b 45 08             	mov    0x8(%ebp),%eax
  801bb1:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801bb4:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801bb8:	6a 00                	push   $0x0
  801bba:	6a 00                	push   $0x0
  801bbc:	6a 00                	push   $0x0
  801bbe:	6a 00                	push   $0x0
  801bc0:	50                   	push   %eax
  801bc1:	6a 1f                	push   $0x1f
  801bc3:	e8 40 fc ff ff       	call   801808 <syscall>
  801bc8:	83 c4 18             	add    $0x18,%esp
	return ;
  801bcb:	90                   	nop
}
  801bcc:	c9                   	leave  
  801bcd:	c3                   	ret    

00801bce <rsttst>:
void rsttst()
{
  801bce:	55                   	push   %ebp
  801bcf:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801bd1:	6a 00                	push   $0x0
  801bd3:	6a 00                	push   $0x0
  801bd5:	6a 00                	push   $0x0
  801bd7:	6a 00                	push   $0x0
  801bd9:	6a 00                	push   $0x0
  801bdb:	6a 21                	push   $0x21
  801bdd:	e8 26 fc ff ff       	call   801808 <syscall>
  801be2:	83 c4 18             	add    $0x18,%esp
	return ;
  801be5:	90                   	nop
}
  801be6:	c9                   	leave  
  801be7:	c3                   	ret    

00801be8 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801be8:	55                   	push   %ebp
  801be9:	89 e5                	mov    %esp,%ebp
  801beb:	83 ec 04             	sub    $0x4,%esp
  801bee:	8b 45 14             	mov    0x14(%ebp),%eax
  801bf1:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801bf4:	8b 55 18             	mov    0x18(%ebp),%edx
  801bf7:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801bfb:	52                   	push   %edx
  801bfc:	50                   	push   %eax
  801bfd:	ff 75 10             	pushl  0x10(%ebp)
  801c00:	ff 75 0c             	pushl  0xc(%ebp)
  801c03:	ff 75 08             	pushl  0x8(%ebp)
  801c06:	6a 20                	push   $0x20
  801c08:	e8 fb fb ff ff       	call   801808 <syscall>
  801c0d:	83 c4 18             	add    $0x18,%esp
	return ;
  801c10:	90                   	nop
}
  801c11:	c9                   	leave  
  801c12:	c3                   	ret    

00801c13 <chktst>:
void chktst(uint32 n)
{
  801c13:	55                   	push   %ebp
  801c14:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801c16:	6a 00                	push   $0x0
  801c18:	6a 00                	push   $0x0
  801c1a:	6a 00                	push   $0x0
  801c1c:	6a 00                	push   $0x0
  801c1e:	ff 75 08             	pushl  0x8(%ebp)
  801c21:	6a 22                	push   $0x22
  801c23:	e8 e0 fb ff ff       	call   801808 <syscall>
  801c28:	83 c4 18             	add    $0x18,%esp
	return ;
  801c2b:	90                   	nop
}
  801c2c:	c9                   	leave  
  801c2d:	c3                   	ret    

00801c2e <inctst>:

void inctst()
{
  801c2e:	55                   	push   %ebp
  801c2f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801c31:	6a 00                	push   $0x0
  801c33:	6a 00                	push   $0x0
  801c35:	6a 00                	push   $0x0
  801c37:	6a 00                	push   $0x0
  801c39:	6a 00                	push   $0x0
  801c3b:	6a 23                	push   $0x23
  801c3d:	e8 c6 fb ff ff       	call   801808 <syscall>
  801c42:	83 c4 18             	add    $0x18,%esp
	return ;
  801c45:	90                   	nop
}
  801c46:	c9                   	leave  
  801c47:	c3                   	ret    

00801c48 <gettst>:
uint32 gettst()
{
  801c48:	55                   	push   %ebp
  801c49:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801c4b:	6a 00                	push   $0x0
  801c4d:	6a 00                	push   $0x0
  801c4f:	6a 00                	push   $0x0
  801c51:	6a 00                	push   $0x0
  801c53:	6a 00                	push   $0x0
  801c55:	6a 24                	push   $0x24
  801c57:	e8 ac fb ff ff       	call   801808 <syscall>
  801c5c:	83 c4 18             	add    $0x18,%esp
}
  801c5f:	c9                   	leave  
  801c60:	c3                   	ret    

00801c61 <sys_get_uheap_strategy>:

/*2025*/
uint32 sys_get_uheap_strategy()
{
  801c61:	55                   	push   %ebp
  801c62:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801c64:	6a 00                	push   $0x0
  801c66:	6a 00                	push   $0x0
  801c68:	6a 00                	push   $0x0
  801c6a:	6a 00                	push   $0x0
  801c6c:	6a 00                	push   $0x0
  801c6e:	6a 25                	push   $0x25
  801c70:	e8 93 fb ff ff       	call   801808 <syscall>
  801c75:	83 c4 18             	add    $0x18,%esp
  801c78:	a3 00 db 87 00       	mov    %eax,0x87db00
	return uheapPlaceStrategy ;
  801c7d:	a1 00 db 87 00       	mov    0x87db00,%eax
}
  801c82:	c9                   	leave  
  801c83:	c3                   	ret    

00801c84 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801c84:	55                   	push   %ebp
  801c85:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = heapStrategy;
  801c87:	8b 45 08             	mov    0x8(%ebp),%eax
  801c8a:	a3 00 db 87 00       	mov    %eax,0x87db00
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801c8f:	6a 00                	push   $0x0
  801c91:	6a 00                	push   $0x0
  801c93:	6a 00                	push   $0x0
  801c95:	6a 00                	push   $0x0
  801c97:	ff 75 08             	pushl  0x8(%ebp)
  801c9a:	6a 26                	push   $0x26
  801c9c:	e8 67 fb ff ff       	call   801808 <syscall>
  801ca1:	83 c4 18             	add    $0x18,%esp
	return ;
  801ca4:	90                   	nop
}
  801ca5:	c9                   	leave  
  801ca6:	c3                   	ret    

00801ca7 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801ca7:	55                   	push   %ebp
  801ca8:	89 e5                	mov    %esp,%ebp
  801caa:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801cab:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801cae:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801cb1:	8b 55 0c             	mov    0xc(%ebp),%edx
  801cb4:	8b 45 08             	mov    0x8(%ebp),%eax
  801cb7:	6a 00                	push   $0x0
  801cb9:	53                   	push   %ebx
  801cba:	51                   	push   %ecx
  801cbb:	52                   	push   %edx
  801cbc:	50                   	push   %eax
  801cbd:	6a 27                	push   $0x27
  801cbf:	e8 44 fb ff ff       	call   801808 <syscall>
  801cc4:	83 c4 18             	add    $0x18,%esp
}
  801cc7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801cca:	c9                   	leave  
  801ccb:	c3                   	ret    

00801ccc <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801ccc:	55                   	push   %ebp
  801ccd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801ccf:	8b 55 0c             	mov    0xc(%ebp),%edx
  801cd2:	8b 45 08             	mov    0x8(%ebp),%eax
  801cd5:	6a 00                	push   $0x0
  801cd7:	6a 00                	push   $0x0
  801cd9:	6a 00                	push   $0x0
  801cdb:	52                   	push   %edx
  801cdc:	50                   	push   %eax
  801cdd:	6a 28                	push   $0x28
  801cdf:	e8 24 fb ff ff       	call   801808 <syscall>
  801ce4:	83 c4 18             	add    $0x18,%esp
}
  801ce7:	c9                   	leave  
  801ce8:	c3                   	ret    

00801ce9 <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  801ce9:	55                   	push   %ebp
  801cea:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  801cec:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801cef:	8b 55 0c             	mov    0xc(%ebp),%edx
  801cf2:	8b 45 08             	mov    0x8(%ebp),%eax
  801cf5:	6a 00                	push   $0x0
  801cf7:	51                   	push   %ecx
  801cf8:	ff 75 10             	pushl  0x10(%ebp)
  801cfb:	52                   	push   %edx
  801cfc:	50                   	push   %eax
  801cfd:	6a 29                	push   $0x29
  801cff:	e8 04 fb ff ff       	call   801808 <syscall>
  801d04:	83 c4 18             	add    $0x18,%esp
}
  801d07:	c9                   	leave  
  801d08:	c3                   	ret    

00801d09 <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801d09:	55                   	push   %ebp
  801d0a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801d0c:	6a 00                	push   $0x0
  801d0e:	6a 00                	push   $0x0
  801d10:	ff 75 10             	pushl  0x10(%ebp)
  801d13:	ff 75 0c             	pushl  0xc(%ebp)
  801d16:	ff 75 08             	pushl  0x8(%ebp)
  801d19:	6a 12                	push   $0x12
  801d1b:	e8 e8 fa ff ff       	call   801808 <syscall>
  801d20:	83 c4 18             	add    $0x18,%esp
	return ;
  801d23:	90                   	nop
}
  801d24:	c9                   	leave  
  801d25:	c3                   	ret    

00801d26 <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  801d26:	55                   	push   %ebp
  801d27:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  801d29:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d2c:	8b 45 08             	mov    0x8(%ebp),%eax
  801d2f:	6a 00                	push   $0x0
  801d31:	6a 00                	push   $0x0
  801d33:	6a 00                	push   $0x0
  801d35:	52                   	push   %edx
  801d36:	50                   	push   %eax
  801d37:	6a 2a                	push   $0x2a
  801d39:	e8 ca fa ff ff       	call   801808 <syscall>
  801d3e:	83 c4 18             	add    $0x18,%esp
	return;
  801d41:	90                   	nop
}
  801d42:	c9                   	leave  
  801d43:	c3                   	ret    

00801d44 <sys_get_optimal_num_faults>:
/*2025*/
int sys_get_optimal_num_faults()
{
  801d44:	55                   	push   %ebp
  801d45:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_optimal_num_faults, 0, 0, 0, 0, 0);
  801d47:	6a 00                	push   $0x0
  801d49:	6a 00                	push   $0x0
  801d4b:	6a 00                	push   $0x0
  801d4d:	6a 00                	push   $0x0
  801d4f:	6a 00                	push   $0x0
  801d51:	6a 2b                	push   $0x2b
  801d53:	e8 b0 fa ff ff       	call   801808 <syscall>
  801d58:	83 c4 18             	add    $0x18,%esp
}
  801d5b:	c9                   	leave  
  801d5c:	c3                   	ret    

00801d5d <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801d5d:	55                   	push   %ebp
  801d5e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801d60:	6a 00                	push   $0x0
  801d62:	6a 00                	push   $0x0
  801d64:	6a 00                	push   $0x0
  801d66:	ff 75 0c             	pushl  0xc(%ebp)
  801d69:	ff 75 08             	pushl  0x8(%ebp)
  801d6c:	6a 2d                	push   $0x2d
  801d6e:	e8 95 fa ff ff       	call   801808 <syscall>
  801d73:	83 c4 18             	add    $0x18,%esp
	return;
  801d76:	90                   	nop
}
  801d77:	c9                   	leave  
  801d78:	c3                   	ret    

00801d79 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801d79:	55                   	push   %ebp
  801d7a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801d7c:	6a 00                	push   $0x0
  801d7e:	6a 00                	push   $0x0
  801d80:	6a 00                	push   $0x0
  801d82:	ff 75 0c             	pushl  0xc(%ebp)
  801d85:	ff 75 08             	pushl  0x8(%ebp)
  801d88:	6a 2c                	push   $0x2c
  801d8a:	e8 79 fa ff ff       	call   801808 <syscall>
  801d8f:	83 c4 18             	add    $0x18,%esp
	return ;
  801d92:	90                   	nop
}
  801d93:	c9                   	leave  
  801d94:	c3                   	ret    

00801d95 <sys_env_set_priority>:


void sys_env_set_priority(int32 envID, int priority)
{
  801d95:	55                   	push   %ebp
  801d96:	89 e5                	mov    %esp,%ebp
  801d98:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.IM#4] CPU SCHEDULING - #1 System Calls - Add suitable code here
	//Your code is here
	//Comment the following line
	panic("sys_env_set_priority() is not implemented yet...!!");
  801d9b:	83 ec 04             	sub    $0x4,%esp
  801d9e:	68 54 34 80 00       	push   $0x803454
  801da3:	68 25 01 00 00       	push   $0x125
  801da8:	68 87 34 80 00       	push   $0x803487
  801dad:	e8 1a 0b 00 00       	call   8028cc <_panic>

00801db2 <to_page_va>:
//==================================
//==================================
// [1] GET PAGE VA:
//==================================
__inline__ uint32 to_page_va(struct PageInfoElement *ptrPageInfo)
{
  801db2:	55                   	push   %ebp
  801db3:	89 e5                	mov    %esp,%ebp
  801db5:	83 ec 18             	sub    $0x18,%esp
	if (ptrPageInfo < &pageBlockInfoArr[0] || ptrPageInfo >= &pageBlockInfoArr[DYN_ALLOC_MAX_SIZE/PAGE_SIZE])
  801db8:	81 7d 08 00 5b 86 00 	cmpl   $0x865b00,0x8(%ebp)
  801dbf:	72 09                	jb     801dca <to_page_va+0x18>
  801dc1:	81 7d 08 00 db 87 00 	cmpl   $0x87db00,0x8(%ebp)
  801dc8:	72 14                	jb     801dde <to_page_va+0x2c>
			panic("to_page_va called with invalid pageInfoPtr");
  801dca:	83 ec 04             	sub    $0x4,%esp
  801dcd:	68 98 34 80 00       	push   $0x803498
  801dd2:	6a 15                	push   $0x15
  801dd4:	68 c3 34 80 00       	push   $0x8034c3
  801dd9:	e8 ee 0a 00 00       	call   8028cc <_panic>
	//Get start VA of the page from the corresponding Page Info pointer
	int idxInPageInfoArr = (ptrPageInfo - pageBlockInfoArr);
  801dde:	8b 45 08             	mov    0x8(%ebp),%eax
  801de1:	ba 00 5b 86 00       	mov    $0x865b00,%edx
  801de6:	29 d0                	sub    %edx,%eax
  801de8:	c1 f8 02             	sar    $0x2,%eax
  801deb:	89 c2                	mov    %eax,%edx
  801ded:	89 d0                	mov    %edx,%eax
  801def:	c1 e0 02             	shl    $0x2,%eax
  801df2:	01 d0                	add    %edx,%eax
  801df4:	c1 e0 02             	shl    $0x2,%eax
  801df7:	01 d0                	add    %edx,%eax
  801df9:	c1 e0 02             	shl    $0x2,%eax
  801dfc:	01 d0                	add    %edx,%eax
  801dfe:	89 c1                	mov    %eax,%ecx
  801e00:	c1 e1 08             	shl    $0x8,%ecx
  801e03:	01 c8                	add    %ecx,%eax
  801e05:	89 c1                	mov    %eax,%ecx
  801e07:	c1 e1 10             	shl    $0x10,%ecx
  801e0a:	01 c8                	add    %ecx,%eax
  801e0c:	01 c0                	add    %eax,%eax
  801e0e:	01 d0                	add    %edx,%eax
  801e10:	89 45 f4             	mov    %eax,-0xc(%ebp)
	return dynAllocStart + (idxInPageInfoArr << PGSHIFT);
  801e13:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e16:	c1 e0 0c             	shl    $0xc,%eax
  801e19:	89 c2                	mov    %eax,%edx
  801e1b:	a1 04 db 87 00       	mov    0x87db04,%eax
  801e20:	01 d0                	add    %edx,%eax
}
  801e22:	c9                   	leave  
  801e23:	c3                   	ret    

00801e24 <to_page_info>:

//==================================
// [2] GET PAGE INFO OF PAGE VA:
//==================================
__inline__ struct PageInfoElement * to_page_info(uint32 va)
{
  801e24:	55                   	push   %ebp
  801e25:	89 e5                	mov    %esp,%ebp
  801e27:	83 ec 18             	sub    $0x18,%esp
	int idxInPageInfoArr = (va - dynAllocStart) >> PGSHIFT;
  801e2a:	a1 04 db 87 00       	mov    0x87db04,%eax
  801e2f:	8b 55 08             	mov    0x8(%ebp),%edx
  801e32:	29 c2                	sub    %eax,%edx
  801e34:	89 d0                	mov    %edx,%eax
  801e36:	c1 e8 0c             	shr    $0xc,%eax
  801e39:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if (idxInPageInfoArr < 0 || idxInPageInfoArr >= DYN_ALLOC_MAX_SIZE/PAGE_SIZE)
  801e3c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801e40:	78 09                	js     801e4b <to_page_info+0x27>
  801e42:	81 7d f4 ff 1f 00 00 	cmpl   $0x1fff,-0xc(%ebp)
  801e49:	7e 14                	jle    801e5f <to_page_info+0x3b>
		panic("to_page_info called with invalid pa");
  801e4b:	83 ec 04             	sub    $0x4,%esp
  801e4e:	68 dc 34 80 00       	push   $0x8034dc
  801e53:	6a 22                	push   $0x22
  801e55:	68 c3 34 80 00       	push   $0x8034c3
  801e5a:	e8 6d 0a 00 00       	call   8028cc <_panic>
	return &pageBlockInfoArr[idxInPageInfoArr];
  801e5f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801e62:	89 d0                	mov    %edx,%eax
  801e64:	01 c0                	add    %eax,%eax
  801e66:	01 d0                	add    %edx,%eax
  801e68:	c1 e0 02             	shl    $0x2,%eax
  801e6b:	05 00 5b 86 00       	add    $0x865b00,%eax
}
  801e70:	c9                   	leave  
  801e71:	c3                   	ret    

00801e72 <initialize_dynamic_allocator>:
//==================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================
bool is_initialized = 0;
void initialize_dynamic_allocator(uint32 daStart, uint32 daEnd)
{
  801e72:	55                   	push   %ebp
  801e73:	89 e5                	mov    %esp,%ebp
  801e75:	83 ec 18             	sub    $0x18,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		assert(daEnd <= daStart + DYN_ALLOC_MAX_SIZE);
  801e78:	8b 45 08             	mov    0x8(%ebp),%eax
  801e7b:	05 00 00 00 02       	add    $0x2000000,%eax
  801e80:	3b 45 0c             	cmp    0xc(%ebp),%eax
  801e83:	73 16                	jae    801e9b <initialize_dynamic_allocator+0x29>
  801e85:	68 00 35 80 00       	push   $0x803500
  801e8a:	68 26 35 80 00       	push   $0x803526
  801e8f:	6a 34                	push   $0x34
  801e91:	68 c3 34 80 00       	push   $0x8034c3
  801e96:	e8 31 0a 00 00       	call   8028cc <_panic>
		is_initialized = 1;
  801e9b:	c7 05 24 40 80 00 01 	movl   $0x1,0x804024
  801ea2:	00 00 00 
	//==================================================================================
	//==================================================================================
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #1 initialize_dynamic_allocator
	//Your code is here
	// init bounds of the dynalloc
	dynAllocStart = daStart;
  801ea5:	8b 45 08             	mov    0x8(%ebp),%eax
  801ea8:	a3 04 db 87 00       	mov    %eax,0x87db04
	dynAllocEnd = daEnd;
  801ead:	8b 45 0c             	mov    0xc(%ebp),%eax
  801eb0:	a3 40 40 80 00       	mov    %eax,0x804040
	// init the list that keep track of all free pageBlockInfoArr instances.
	LIST_INIT(&freePagesList);
  801eb5:	c7 05 e4 5a 86 00 00 	movl   $0x0,0x865ae4
  801ebc:	00 00 00 
  801ebf:	c7 05 e8 5a 86 00 00 	movl   $0x0,0x865ae8
  801ec6:	00 00 00 
  801ec9:	c7 05 f0 5a 86 00 00 	movl   $0x0,0x865af0
  801ed0:	00 00 00 

	// no.of pages in the dynamic allocator.
	int pCount = (daEnd - daStart) / PAGE_SIZE;
  801ed3:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ed6:	2b 45 08             	sub    0x8(%ebp),%eax
  801ed9:	c1 e8 0c             	shr    $0xc,%eax
  801edc:	89 45 ec             	mov    %eax,-0x14(%ebp)
	// iterate over each page and init its data in pageBlockInfoArr and reset it.
	for (int i = 0; i < pCount; ++i) {
  801edf:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  801ee6:	e9 c8 00 00 00       	jmp    801fb3 <initialize_dynamic_allocator+0x141>
	    pageBlockInfoArr[i].block_size = 0;
  801eeb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801eee:	89 d0                	mov    %edx,%eax
  801ef0:	01 c0                	add    %eax,%eax
  801ef2:	01 d0                	add    %edx,%eax
  801ef4:	c1 e0 02             	shl    $0x2,%eax
  801ef7:	05 08 5b 86 00       	add    $0x865b08,%eax
  801efc:	66 c7 00 00 00       	movw   $0x0,(%eax)
	    pageBlockInfoArr[i].num_of_free_blocks = 0;
  801f01:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801f04:	89 d0                	mov    %edx,%eax
  801f06:	01 c0                	add    %eax,%eax
  801f08:	01 d0                	add    %edx,%eax
  801f0a:	c1 e0 02             	shl    $0x2,%eax
  801f0d:	05 0a 5b 86 00       	add    $0x865b0a,%eax
  801f12:	66 c7 00 00 00       	movw   $0x0,(%eax)
	    LIST_INSERT_TAIL(&freePagesList, &pageBlockInfoArr[i]);
  801f17:	8b 15 e8 5a 86 00    	mov    0x865ae8,%edx
  801f1d:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  801f20:	89 c8                	mov    %ecx,%eax
  801f22:	01 c0                	add    %eax,%eax
  801f24:	01 c8                	add    %ecx,%eax
  801f26:	c1 e0 02             	shl    $0x2,%eax
  801f29:	05 04 5b 86 00       	add    $0x865b04,%eax
  801f2e:	89 10                	mov    %edx,(%eax)
  801f30:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801f33:	89 d0                	mov    %edx,%eax
  801f35:	01 c0                	add    %eax,%eax
  801f37:	01 d0                	add    %edx,%eax
  801f39:	c1 e0 02             	shl    $0x2,%eax
  801f3c:	05 04 5b 86 00       	add    $0x865b04,%eax
  801f41:	8b 00                	mov    (%eax),%eax
  801f43:	85 c0                	test   %eax,%eax
  801f45:	74 1b                	je     801f62 <initialize_dynamic_allocator+0xf0>
  801f47:	8b 15 e8 5a 86 00    	mov    0x865ae8,%edx
  801f4d:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  801f50:	89 c8                	mov    %ecx,%eax
  801f52:	01 c0                	add    %eax,%eax
  801f54:	01 c8                	add    %ecx,%eax
  801f56:	c1 e0 02             	shl    $0x2,%eax
  801f59:	05 00 5b 86 00       	add    $0x865b00,%eax
  801f5e:	89 02                	mov    %eax,(%edx)
  801f60:	eb 16                	jmp    801f78 <initialize_dynamic_allocator+0x106>
  801f62:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801f65:	89 d0                	mov    %edx,%eax
  801f67:	01 c0                	add    %eax,%eax
  801f69:	01 d0                	add    %edx,%eax
  801f6b:	c1 e0 02             	shl    $0x2,%eax
  801f6e:	05 00 5b 86 00       	add    $0x865b00,%eax
  801f73:	a3 e4 5a 86 00       	mov    %eax,0x865ae4
  801f78:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801f7b:	89 d0                	mov    %edx,%eax
  801f7d:	01 c0                	add    %eax,%eax
  801f7f:	01 d0                	add    %edx,%eax
  801f81:	c1 e0 02             	shl    $0x2,%eax
  801f84:	05 00 5b 86 00       	add    $0x865b00,%eax
  801f89:	a3 e8 5a 86 00       	mov    %eax,0x865ae8
  801f8e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801f91:	89 d0                	mov    %edx,%eax
  801f93:	01 c0                	add    %eax,%eax
  801f95:	01 d0                	add    %edx,%eax
  801f97:	c1 e0 02             	shl    $0x2,%eax
  801f9a:	05 00 5b 86 00       	add    $0x865b00,%eax
  801f9f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801fa5:	a1 f0 5a 86 00       	mov    0x865af0,%eax
  801faa:	40                   	inc    %eax
  801fab:	a3 f0 5a 86 00       	mov    %eax,0x865af0
	LIST_INIT(&freePagesList);

	// no.of pages in the dynamic allocator.
	int pCount = (daEnd - daStart) / PAGE_SIZE;
	// iterate over each page and init its data in pageBlockInfoArr and reset it.
	for (int i = 0; i < pCount; ++i) {
  801fb0:	ff 45 f4             	incl   -0xc(%ebp)
  801fb3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fb6:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  801fb9:	0f 8c 2c ff ff ff    	jl     801eeb <initialize_dynamic_allocator+0x79>
	    LIST_INSERT_TAIL(&freePagesList, &pageBlockInfoArr[i]);
	}
	// init the array of lists of each size..
	// 8 16 32 64 128 256 512 1024 2056
	// 0 1  2  3   4  5    6   7    8
	for (int i = 0; i <= (LOG2_MAX_SIZE - LOG2_MIN_SIZE); ++i){
  801fbf:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  801fc6:	eb 36                	jmp    801ffe <initialize_dynamic_allocator+0x18c>
		LIST_INIT(&freeBlockLists[i]);
  801fc8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801fcb:	c1 e0 04             	shl    $0x4,%eax
  801fce:	05 20 db 87 00       	add    $0x87db20,%eax
  801fd3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801fd9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801fdc:	c1 e0 04             	shl    $0x4,%eax
  801fdf:	05 24 db 87 00       	add    $0x87db24,%eax
  801fe4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801fea:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801fed:	c1 e0 04             	shl    $0x4,%eax
  801ff0:	05 2c db 87 00       	add    $0x87db2c,%eax
  801ff5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	    LIST_INSERT_TAIL(&freePagesList, &pageBlockInfoArr[i]);
	}
	// init the array of lists of each size..
	// 8 16 32 64 128 256 512 1024 2056
	// 0 1  2  3   4  5    6   7    8
	for (int i = 0; i <= (LOG2_MAX_SIZE - LOG2_MIN_SIZE); ++i){
  801ffb:	ff 45 f0             	incl   -0x10(%ebp)
  801ffe:	83 7d f0 08          	cmpl   $0x8,-0x10(%ebp)
  802002:	7e c4                	jle    801fc8 <initialize_dynamic_allocator+0x156>
		LIST_INIT(&freeBlockLists[i]);
	}
	//Comment the following line
	//panic("initialize_dynamic_allocator() Not implemented yet");

}
  802004:	90                   	nop
  802005:	c9                   	leave  
  802006:	c3                   	ret    

00802007 <get_block_size>:

//===========================
// [2] GET BLOCK SIZE:
//===========================
__inline__ uint32 get_block_size(void *va)
{
  802007:	55                   	push   %ebp
  802008:	89 e5                	mov    %esp,%ebp
  80200a:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #2 get_block_size
	//Your code is here
	// get the page that saves this va
	struct PageInfoElement* ptr = to_page_info((uint32)va);
  80200d:	8b 45 08             	mov    0x8(%ebp),%eax
  802010:	83 ec 0c             	sub    $0xc,%esp
  802013:	50                   	push   %eax
  802014:	e8 0b fe ff ff       	call   801e24 <to_page_info>
  802019:	83 c4 10             	add    $0x10,%esp
  80201c:	89 45 f4             	mov    %eax,-0xc(%ebp)
	return ptr->block_size;
  80201f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802022:	8b 40 08             	mov    0x8(%eax),%eax
  802025:	0f b7 c0             	movzwl %ax,%eax
	//Comment the following line
	//panic("get_block_size() Not implemented yet");
}
  802028:	c9                   	leave  
  802029:	c3                   	ret    

0080202a <split_page_to_blocks>:
// =====================
// h) split page to blocks and add them in freeBlockLists
// =====================
// function that split the page provided into same sized blocks
//and putem in suitable freeblockList index according to size.
 void split_page_to_blocks(uint32 blk_size, struct PageInfoElement *pageInfo) {
  80202a:	55                   	push   %ebp
  80202b:	89 e5                	mov    %esp,%ebp
  80202d:	83 ec 28             	sub    $0x28,%esp
	 // cur page virtual address by the pageInfo.
	 uint32 page_va = (uint32)to_page_va(pageInfo);
  802030:	83 ec 0c             	sub    $0xc,%esp
  802033:	ff 75 0c             	pushl  0xc(%ebp)
  802036:	e8 77 fd ff ff       	call   801db2 <to_page_va>
  80203b:	83 c4 10             	add    $0x10,%esp
  80203e:	89 45 e8             	mov    %eax,-0x18(%ebp)
	 // no. of blks to save in freeblockList.
	 int blk_count = PAGE_SIZE / blk_size;
  802041:	b8 00 10 00 00       	mov    $0x1000,%eax
  802046:	ba 00 00 00 00       	mov    $0x0,%edx
  80204b:	f7 75 08             	divl   0x8(%ebp)
  80204e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	 // save page in memory.
	 get_page((uint32*)page_va);
  802051:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802054:	83 ec 0c             	sub    $0xc,%esp
  802057:	50                   	push   %eax
  802058:	e8 48 f6 ff ff       	call   8016a5 <get_page>
  80205d:	83 c4 10             	add    $0x10,%esp
	 // assigning the pageInfo data block size, free block which is whole block count.
	 pageInfo->num_of_free_blocks = blk_count;
  802060:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802063:	8b 55 0c             	mov    0xc(%ebp),%edx
  802066:	66 89 42 0a          	mov    %ax,0xa(%edx)
	 pageInfo->block_size = blk_size;
  80206a:	8b 45 08             	mov    0x8(%ebp),%eax
  80206d:	8b 55 0c             	mov    0xc(%ebp),%edx
  802070:	66 89 42 08          	mov    %ax,0x8(%edx)
	 // get index by size block in freeblocklist.
	 int idx = 0;
  802074:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	 for (int i = LOG2_MIN_SIZE; i <= LOG2_MAX_SIZE; i++) {
  80207b:	c7 45 f0 03 00 00 00 	movl   $0x3,-0x10(%ebp)
  802082:	eb 19                	jmp    80209d <split_page_to_blocks+0x73>
	     if ((1 << i) == blk_size)
  802084:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802087:	ba 01 00 00 00       	mov    $0x1,%edx
  80208c:	88 c1                	mov    %al,%cl
  80208e:	d3 e2                	shl    %cl,%edx
  802090:	89 d0                	mov    %edx,%eax
  802092:	3b 45 08             	cmp    0x8(%ebp),%eax
  802095:	74 0e                	je     8020a5 <split_page_to_blocks+0x7b>
	         break;
	     idx++;
  802097:	ff 45 f4             	incl   -0xc(%ebp)
	 // assigning the pageInfo data block size, free block which is whole block count.
	 pageInfo->num_of_free_blocks = blk_count;
	 pageInfo->block_size = blk_size;
	 // get index by size block in freeblocklist.
	 int idx = 0;
	 for (int i = LOG2_MIN_SIZE; i <= LOG2_MAX_SIZE; i++) {
  80209a:	ff 45 f0             	incl   -0x10(%ebp)
  80209d:	83 7d f0 0b          	cmpl   $0xb,-0x10(%ebp)
  8020a1:	7e e1                	jle    802084 <split_page_to_blocks+0x5a>
  8020a3:	eb 01                	jmp    8020a6 <split_page_to_blocks+0x7c>
	     if ((1 << i) == blk_size)
	         break;
  8020a5:	90                   	nop
	     idx++;
	 }
	 // iterate over each blk and make and element of it by passing its address in blockElement pointer and save those in the list.
	 // starting from the page_va.
	 for (uint32 i = 0; i < blk_count; ++i) {
  8020a6:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  8020ad:	e9 a7 00 00 00       	jmp    802159 <split_page_to_blocks+0x12f>
	     struct BlockElement *blk =(struct BlockElement*)(page_va + i * blk_size);
  8020b2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8020b5:	0f af 45 08          	imul   0x8(%ebp),%eax
  8020b9:	89 c2                	mov    %eax,%edx
  8020bb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8020be:	01 d0                	add    %edx,%eax
  8020c0:	89 45 e0             	mov    %eax,-0x20(%ebp)
	     LIST_INSERT_TAIL(&freeBlockLists[idx],blk);
  8020c3:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8020c7:	75 14                	jne    8020dd <split_page_to_blocks+0xb3>
  8020c9:	83 ec 04             	sub    $0x4,%esp
  8020cc:	68 3c 35 80 00       	push   $0x80353c
  8020d1:	6a 7c                	push   $0x7c
  8020d3:	68 c3 34 80 00       	push   $0x8034c3
  8020d8:	e8 ef 07 00 00       	call   8028cc <_panic>
  8020dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020e0:	c1 e0 04             	shl    $0x4,%eax
  8020e3:	05 24 db 87 00       	add    $0x87db24,%eax
  8020e8:	8b 10                	mov    (%eax),%edx
  8020ea:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8020ed:	89 50 04             	mov    %edx,0x4(%eax)
  8020f0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8020f3:	8b 40 04             	mov    0x4(%eax),%eax
  8020f6:	85 c0                	test   %eax,%eax
  8020f8:	74 14                	je     80210e <split_page_to_blocks+0xe4>
  8020fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020fd:	c1 e0 04             	shl    $0x4,%eax
  802100:	05 24 db 87 00       	add    $0x87db24,%eax
  802105:	8b 00                	mov    (%eax),%eax
  802107:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80210a:	89 10                	mov    %edx,(%eax)
  80210c:	eb 11                	jmp    80211f <split_page_to_blocks+0xf5>
  80210e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802111:	c1 e0 04             	shl    $0x4,%eax
  802114:	8d 90 20 db 87 00    	lea    0x87db20(%eax),%edx
  80211a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80211d:	89 02                	mov    %eax,(%edx)
  80211f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802122:	c1 e0 04             	shl    $0x4,%eax
  802125:	8d 90 24 db 87 00    	lea    0x87db24(%eax),%edx
  80212b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80212e:	89 02                	mov    %eax,(%edx)
  802130:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802133:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802139:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80213c:	c1 e0 04             	shl    $0x4,%eax
  80213f:	05 2c db 87 00       	add    $0x87db2c,%eax
  802144:	8b 00                	mov    (%eax),%eax
  802146:	8d 50 01             	lea    0x1(%eax),%edx
  802149:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80214c:	c1 e0 04             	shl    $0x4,%eax
  80214f:	05 2c db 87 00       	add    $0x87db2c,%eax
  802154:	89 10                	mov    %edx,(%eax)
	         break;
	     idx++;
	 }
	 // iterate over each blk and make and element of it by passing its address in blockElement pointer and save those in the list.
	 // starting from the page_va.
	 for (uint32 i = 0; i < blk_count; ++i) {
  802156:	ff 45 ec             	incl   -0x14(%ebp)
  802159:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80215c:	39 45 ec             	cmp    %eax,-0x14(%ebp)
  80215f:	0f 82 4d ff ff ff    	jb     8020b2 <split_page_to_blocks+0x88>
	     struct BlockElement *blk =(struct BlockElement*)(page_va + i * blk_size);
	     LIST_INSERT_TAIL(&freeBlockLists[idx],blk);
	 }
 }
  802165:	90                   	nop
  802166:	c9                   	leave  
  802167:	c3                   	ret    

00802168 <alloc_block>:

//===========================
// 3) ALLOCATE BLOCK:
//===========================
void *alloc_block(uint32 size)
{
  802168:	55                   	push   %ebp
  802169:	89 e5                	mov    %esp,%ebp
  80216b:	83 ec 38             	sub    $0x38,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		assert(size <= DYN_ALLOC_MAX_BLOCK_SIZE);
  80216e:	81 7d 08 00 08 00 00 	cmpl   $0x800,0x8(%ebp)
  802175:	76 19                	jbe    802190 <alloc_block+0x28>
  802177:	68 60 35 80 00       	push   $0x803560
  80217c:	68 26 35 80 00       	push   $0x803526
  802181:	68 8a 00 00 00       	push   $0x8a
  802186:	68 c3 34 80 00       	push   $0x8034c3
  80218b:	e8 3c 07 00 00       	call   8028cc <_panic>
	//==================================================================================
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #3 alloc_block
	//Your code is here
	//Comment the following line
	// get index in freeBlockList by size.
	uint32 idx = 0;
  802190:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int i = LOG2_MIN_SIZE; i <= LOG2_MAX_SIZE; ++i){
  802197:	c7 45 f0 03 00 00 00 	movl   $0x3,-0x10(%ebp)
  80219e:	eb 19                	jmp    8021b9 <alloc_block+0x51>
		if((1 << i) >= size) break;
  8021a0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8021a3:	ba 01 00 00 00       	mov    $0x1,%edx
  8021a8:	88 c1                	mov    %al,%cl
  8021aa:	d3 e2                	shl    %cl,%edx
  8021ac:	89 d0                	mov    %edx,%eax
  8021ae:	3b 45 08             	cmp    0x8(%ebp),%eax
  8021b1:	73 0e                	jae    8021c1 <alloc_block+0x59>
		idx++;
  8021b3:	ff 45 f4             	incl   -0xc(%ebp)
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #3 alloc_block
	//Your code is here
	//Comment the following line
	// get index in freeBlockList by size.
	uint32 idx = 0;
	for (int i = LOG2_MIN_SIZE; i <= LOG2_MAX_SIZE; ++i){
  8021b6:	ff 45 f0             	incl   -0x10(%ebp)
  8021b9:	83 7d f0 0b          	cmpl   $0xb,-0x10(%ebp)
  8021bd:	7e e1                	jle    8021a0 <alloc_block+0x38>
  8021bf:	eb 01                	jmp    8021c2 <alloc_block+0x5a>
		if((1 << i) >= size) break;
  8021c1:	90                   	nop
		idx++;
	}

	//case 1: the free block of the cur size is available.
	if (freeBlockLists[idx].size > 0) {
  8021c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021c5:	c1 e0 04             	shl    $0x4,%eax
  8021c8:	05 2c db 87 00       	add    $0x87db2c,%eax
  8021cd:	8b 00                	mov    (%eax),%eax
  8021cf:	85 c0                	test   %eax,%eax
  8021d1:	0f 84 df 00 00 00    	je     8022b6 <alloc_block+0x14e>

		// remove from the list and updat the pageInfoArr free blocks.
		// pop from the freeBlockList.
		struct BlockElement *blk = LIST_FIRST(&freeBlockLists[idx]);
  8021d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021da:	c1 e0 04             	shl    $0x4,%eax
  8021dd:	05 20 db 87 00       	add    $0x87db20,%eax
  8021e2:	8b 00                	mov    (%eax),%eax
  8021e4:	89 45 ec             	mov    %eax,-0x14(%ebp)
	    LIST_REMOVE(&freeBlockLists[idx], blk);
  8021e7:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8021eb:	75 17                	jne    802204 <alloc_block+0x9c>
  8021ed:	83 ec 04             	sub    $0x4,%esp
  8021f0:	68 81 35 80 00       	push   $0x803581
  8021f5:	68 9e 00 00 00       	push   $0x9e
  8021fa:	68 c3 34 80 00       	push   $0x8034c3
  8021ff:	e8 c8 06 00 00       	call   8028cc <_panic>
  802204:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802207:	8b 00                	mov    (%eax),%eax
  802209:	85 c0                	test   %eax,%eax
  80220b:	74 10                	je     80221d <alloc_block+0xb5>
  80220d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802210:	8b 00                	mov    (%eax),%eax
  802212:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802215:	8b 52 04             	mov    0x4(%edx),%edx
  802218:	89 50 04             	mov    %edx,0x4(%eax)
  80221b:	eb 14                	jmp    802231 <alloc_block+0xc9>
  80221d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802220:	8b 40 04             	mov    0x4(%eax),%eax
  802223:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802226:	c1 e2 04             	shl    $0x4,%edx
  802229:	81 c2 24 db 87 00    	add    $0x87db24,%edx
  80222f:	89 02                	mov    %eax,(%edx)
  802231:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802234:	8b 40 04             	mov    0x4(%eax),%eax
  802237:	85 c0                	test   %eax,%eax
  802239:	74 0f                	je     80224a <alloc_block+0xe2>
  80223b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80223e:	8b 40 04             	mov    0x4(%eax),%eax
  802241:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802244:	8b 12                	mov    (%edx),%edx
  802246:	89 10                	mov    %edx,(%eax)
  802248:	eb 13                	jmp    80225d <alloc_block+0xf5>
  80224a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80224d:	8b 00                	mov    (%eax),%eax
  80224f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802252:	c1 e2 04             	shl    $0x4,%edx
  802255:	81 c2 20 db 87 00    	add    $0x87db20,%edx
  80225b:	89 02                	mov    %eax,(%edx)
  80225d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802260:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802266:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802269:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802270:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802273:	c1 e0 04             	shl    $0x4,%eax
  802276:	05 2c db 87 00       	add    $0x87db2c,%eax
  80227b:	8b 00                	mov    (%eax),%eax
  80227d:	8d 50 ff             	lea    -0x1(%eax),%edx
  802280:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802283:	c1 e0 04             	shl    $0x4,%eax
  802286:	05 2c db 87 00       	add    $0x87db2c,%eax
  80228b:	89 10                	mov    %edx,(%eax)
	    // update pageBlockInfoArr
	    struct PageInfoElement *pageInfo = to_page_info((uint32)blk);
  80228d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802290:	83 ec 0c             	sub    $0xc,%esp
  802293:	50                   	push   %eax
  802294:	e8 8b fb ff ff       	call   801e24 <to_page_info>
  802299:	83 c4 10             	add    $0x10,%esp
  80229c:	89 45 e8             	mov    %eax,-0x18(%ebp)
	    pageInfo->num_of_free_blocks--;
  80229f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8022a2:	66 8b 40 0a          	mov    0xa(%eax),%ax
  8022a6:	48                   	dec    %eax
  8022a7:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8022aa:	66 89 42 0a          	mov    %ax,0xa(%edx)
	    return blk;
  8022ae:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8022b1:	e9 bc 02 00 00       	jmp    802572 <alloc_block+0x40a>
	}else{ //case(2, 3): 2. no free blocks available in the freeblocklist but there is free pages.
				//3. no free blocks and no available freepages so search in higher block sizes.
		// case 2:
		if(freePagesList.size > 0){ //have free pages.
  8022b6:	a1 f0 5a 86 00       	mov    0x865af0,%eax
  8022bb:	85 c0                	test   %eax,%eax
  8022bd:	0f 84 7d 02 00 00    	je     802540 <alloc_block+0x3d8>
			// get page to split and use from freepagesList.
			struct PageInfoElement *ptr_new_page = LIST_FIRST(&freePagesList);
  8022c3:	a1 e4 5a 86 00       	mov    0x865ae4,%eax
  8022c8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			LIST_REMOVE(&freePagesList, ptr_new_page);
  8022cb:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8022cf:	75 17                	jne    8022e8 <alloc_block+0x180>
  8022d1:	83 ec 04             	sub    $0x4,%esp
  8022d4:	68 81 35 80 00       	push   $0x803581
  8022d9:	68 a9 00 00 00       	push   $0xa9
  8022de:	68 c3 34 80 00       	push   $0x8034c3
  8022e3:	e8 e4 05 00 00       	call   8028cc <_panic>
  8022e8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8022eb:	8b 00                	mov    (%eax),%eax
  8022ed:	85 c0                	test   %eax,%eax
  8022ef:	74 10                	je     802301 <alloc_block+0x199>
  8022f1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8022f4:	8b 00                	mov    (%eax),%eax
  8022f6:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8022f9:	8b 52 04             	mov    0x4(%edx),%edx
  8022fc:	89 50 04             	mov    %edx,0x4(%eax)
  8022ff:	eb 0b                	jmp    80230c <alloc_block+0x1a4>
  802301:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802304:	8b 40 04             	mov    0x4(%eax),%eax
  802307:	a3 e8 5a 86 00       	mov    %eax,0x865ae8
  80230c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80230f:	8b 40 04             	mov    0x4(%eax),%eax
  802312:	85 c0                	test   %eax,%eax
  802314:	74 0f                	je     802325 <alloc_block+0x1bd>
  802316:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802319:	8b 40 04             	mov    0x4(%eax),%eax
  80231c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80231f:	8b 12                	mov    (%edx),%edx
  802321:	89 10                	mov    %edx,(%eax)
  802323:	eb 0a                	jmp    80232f <alloc_block+0x1c7>
  802325:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802328:	8b 00                	mov    (%eax),%eax
  80232a:	a3 e4 5a 86 00       	mov    %eax,0x865ae4
  80232f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802332:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802338:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80233b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802342:	a1 f0 5a 86 00       	mov    0x865af0,%eax
  802347:	48                   	dec    %eax
  802348:	a3 f0 5a 86 00       	mov    %eax,0x865af0
			// from page to freeblockList by the pageInfo and the block size.
			split_page_to_blocks(1 << (idx + LOG2_MIN_SIZE), ptr_new_page);
  80234d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802350:	83 c0 03             	add    $0x3,%eax
  802353:	ba 01 00 00 00       	mov    $0x1,%edx
  802358:	88 c1                	mov    %al,%cl
  80235a:	d3 e2                	shl    %cl,%edx
  80235c:	89 d0                	mov    %edx,%eax
  80235e:	83 ec 08             	sub    $0x8,%esp
  802361:	ff 75 e4             	pushl  -0x1c(%ebp)
  802364:	50                   	push   %eax
  802365:	e8 c0 fc ff ff       	call   80202a <split_page_to_blocks>
  80236a:	83 c4 10             	add    $0x10,%esp

			// remove from the list and updat the pageInfoArr free blocks.
			// pop from the freeBlockList.
			struct BlockElement *blk = LIST_FIRST(&freeBlockLists[idx]);
  80236d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802370:	c1 e0 04             	shl    $0x4,%eax
  802373:	05 20 db 87 00       	add    $0x87db20,%eax
  802378:	8b 00                	mov    (%eax),%eax
  80237a:	89 45 e0             	mov    %eax,-0x20(%ebp)
		    LIST_REMOVE(&freeBlockLists[idx], blk);
  80237d:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  802381:	75 17                	jne    80239a <alloc_block+0x232>
  802383:	83 ec 04             	sub    $0x4,%esp
  802386:	68 81 35 80 00       	push   $0x803581
  80238b:	68 b0 00 00 00       	push   $0xb0
  802390:	68 c3 34 80 00       	push   $0x8034c3
  802395:	e8 32 05 00 00       	call   8028cc <_panic>
  80239a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80239d:	8b 00                	mov    (%eax),%eax
  80239f:	85 c0                	test   %eax,%eax
  8023a1:	74 10                	je     8023b3 <alloc_block+0x24b>
  8023a3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8023a6:	8b 00                	mov    (%eax),%eax
  8023a8:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8023ab:	8b 52 04             	mov    0x4(%edx),%edx
  8023ae:	89 50 04             	mov    %edx,0x4(%eax)
  8023b1:	eb 14                	jmp    8023c7 <alloc_block+0x25f>
  8023b3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8023b6:	8b 40 04             	mov    0x4(%eax),%eax
  8023b9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8023bc:	c1 e2 04             	shl    $0x4,%edx
  8023bf:	81 c2 24 db 87 00    	add    $0x87db24,%edx
  8023c5:	89 02                	mov    %eax,(%edx)
  8023c7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8023ca:	8b 40 04             	mov    0x4(%eax),%eax
  8023cd:	85 c0                	test   %eax,%eax
  8023cf:	74 0f                	je     8023e0 <alloc_block+0x278>
  8023d1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8023d4:	8b 40 04             	mov    0x4(%eax),%eax
  8023d7:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8023da:	8b 12                	mov    (%edx),%edx
  8023dc:	89 10                	mov    %edx,(%eax)
  8023de:	eb 13                	jmp    8023f3 <alloc_block+0x28b>
  8023e0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8023e3:	8b 00                	mov    (%eax),%eax
  8023e5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8023e8:	c1 e2 04             	shl    $0x4,%edx
  8023eb:	81 c2 20 db 87 00    	add    $0x87db20,%edx
  8023f1:	89 02                	mov    %eax,(%edx)
  8023f3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8023f6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8023fc:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8023ff:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802406:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802409:	c1 e0 04             	shl    $0x4,%eax
  80240c:	05 2c db 87 00       	add    $0x87db2c,%eax
  802411:	8b 00                	mov    (%eax),%eax
  802413:	8d 50 ff             	lea    -0x1(%eax),%edx
  802416:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802419:	c1 e0 04             	shl    $0x4,%eax
  80241c:	05 2c db 87 00       	add    $0x87db2c,%eax
  802421:	89 10                	mov    %edx,(%eax)
		    // update pageBlockInfoArr
		    struct PageInfoElement *pageInfo = to_page_info((uint32)blk);
  802423:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802426:	83 ec 0c             	sub    $0xc,%esp
  802429:	50                   	push   %eax
  80242a:	e8 f5 f9 ff ff       	call   801e24 <to_page_info>
  80242f:	83 c4 10             	add    $0x10,%esp
  802432:	89 45 dc             	mov    %eax,-0x24(%ebp)
		    pageInfo->num_of_free_blocks--;
  802435:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802438:	66 8b 40 0a          	mov    0xa(%eax),%ax
  80243c:	48                   	dec    %eax
  80243d:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802440:	66 89 42 0a          	mov    %ax,0xa(%edx)
		    return blk;
  802444:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802447:	e9 26 01 00 00       	jmp    802572 <alloc_block+0x40a>
		}else{//case 3: no free block and no free page so iterate and try to find bigger size.
			// iterate over the list until finding available block
			while (idx <= (LOG2_MAX_SIZE - LOG2_MIN_SIZE) && freeBlockLists[idx].size == 0) {
				idx++;
  80244c:	ff 45 f4             	incl   -0xc(%ebp)
				// found free block
				if(freeBlockLists[idx].size > 0){
  80244f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802452:	c1 e0 04             	shl    $0x4,%eax
  802455:	05 2c db 87 00       	add    $0x87db2c,%eax
  80245a:	8b 00                	mov    (%eax),%eax
  80245c:	85 c0                	test   %eax,%eax
  80245e:	0f 84 dc 00 00 00    	je     802540 <alloc_block+0x3d8>
					// remove from the list and updat the pageInfoArr free blocks.
					// pop from the freeBlockList.
					struct BlockElement *blk = LIST_FIRST(&freeBlockLists[idx]);
  802464:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802467:	c1 e0 04             	shl    $0x4,%eax
  80246a:	05 20 db 87 00       	add    $0x87db20,%eax
  80246f:	8b 00                	mov    (%eax),%eax
  802471:	89 45 d8             	mov    %eax,-0x28(%ebp)
				    LIST_REMOVE(&freeBlockLists[idx], blk);
  802474:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  802478:	75 17                	jne    802491 <alloc_block+0x329>
  80247a:	83 ec 04             	sub    $0x4,%esp
  80247d:	68 81 35 80 00       	push   $0x803581
  802482:	68 be 00 00 00       	push   $0xbe
  802487:	68 c3 34 80 00       	push   $0x8034c3
  80248c:	e8 3b 04 00 00       	call   8028cc <_panic>
  802491:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802494:	8b 00                	mov    (%eax),%eax
  802496:	85 c0                	test   %eax,%eax
  802498:	74 10                	je     8024aa <alloc_block+0x342>
  80249a:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80249d:	8b 00                	mov    (%eax),%eax
  80249f:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8024a2:	8b 52 04             	mov    0x4(%edx),%edx
  8024a5:	89 50 04             	mov    %edx,0x4(%eax)
  8024a8:	eb 14                	jmp    8024be <alloc_block+0x356>
  8024aa:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8024ad:	8b 40 04             	mov    0x4(%eax),%eax
  8024b0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8024b3:	c1 e2 04             	shl    $0x4,%edx
  8024b6:	81 c2 24 db 87 00    	add    $0x87db24,%edx
  8024bc:	89 02                	mov    %eax,(%edx)
  8024be:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8024c1:	8b 40 04             	mov    0x4(%eax),%eax
  8024c4:	85 c0                	test   %eax,%eax
  8024c6:	74 0f                	je     8024d7 <alloc_block+0x36f>
  8024c8:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8024cb:	8b 40 04             	mov    0x4(%eax),%eax
  8024ce:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8024d1:	8b 12                	mov    (%edx),%edx
  8024d3:	89 10                	mov    %edx,(%eax)
  8024d5:	eb 13                	jmp    8024ea <alloc_block+0x382>
  8024d7:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8024da:	8b 00                	mov    (%eax),%eax
  8024dc:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8024df:	c1 e2 04             	shl    $0x4,%edx
  8024e2:	81 c2 20 db 87 00    	add    $0x87db20,%edx
  8024e8:	89 02                	mov    %eax,(%edx)
  8024ea:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8024ed:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8024f3:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8024f6:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8024fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802500:	c1 e0 04             	shl    $0x4,%eax
  802503:	05 2c db 87 00       	add    $0x87db2c,%eax
  802508:	8b 00                	mov    (%eax),%eax
  80250a:	8d 50 ff             	lea    -0x1(%eax),%edx
  80250d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802510:	c1 e0 04             	shl    $0x4,%eax
  802513:	05 2c db 87 00       	add    $0x87db2c,%eax
  802518:	89 10                	mov    %edx,(%eax)
				    // update pageBlockInfoArr
				    struct PageInfoElement *pageInfo = to_page_info((uint32)blk);
  80251a:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80251d:	83 ec 0c             	sub    $0xc,%esp
  802520:	50                   	push   %eax
  802521:	e8 fe f8 ff ff       	call   801e24 <to_page_info>
  802526:	83 c4 10             	add    $0x10,%esp
  802529:	89 45 d4             	mov    %eax,-0x2c(%ebp)
				    pageInfo->num_of_free_blocks--;
  80252c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80252f:	66 8b 40 0a          	mov    0xa(%eax),%ax
  802533:	48                   	dec    %eax
  802534:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  802537:	66 89 42 0a          	mov    %ax,0xa(%edx)
				    return blk;
  80253b:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80253e:	eb 32                	jmp    802572 <alloc_block+0x40a>
		    struct PageInfoElement *pageInfo = to_page_info((uint32)blk);
		    pageInfo->num_of_free_blocks--;
		    return blk;
		}else{//case 3: no free block and no free page so iterate and try to find bigger size.
			// iterate over the list until finding available block
			while (idx <= (LOG2_MAX_SIZE - LOG2_MIN_SIZE) && freeBlockLists[idx].size == 0) {
  802540:	83 7d f4 08          	cmpl   $0x8,-0xc(%ebp)
  802544:	77 15                	ja     80255b <alloc_block+0x3f3>
  802546:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802549:	c1 e0 04             	shl    $0x4,%eax
  80254c:	05 2c db 87 00       	add    $0x87db2c,%eax
  802551:	8b 00                	mov    (%eax),%eax
  802553:	85 c0                	test   %eax,%eax
  802555:	0f 84 f1 fe ff ff    	je     80244c <alloc_block+0x2e4>
				}
			}
		}
	}
	//case4: no free blocks or pages.
	panic("no free blocks!");
  80255b:	83 ec 04             	sub    $0x4,%esp
  80255e:	68 9f 35 80 00       	push   $0x80359f
  802563:	68 c8 00 00 00       	push   $0xc8
  802568:	68 c3 34 80 00       	push   $0x8034c3
  80256d:	e8 5a 03 00 00       	call   8028cc <_panic>
	//panic("alloc_block() Not implemented yet");
	//TODO: [PROJECT'25.BONUS#1] DYNAMIC ALLOCATOR - block if no free block
	return NULL;
}
  802572:	c9                   	leave  
  802573:	c3                   	ret    

00802574 <free_block>:

//===========================
// [4] FREE BLOCK:
//===========================
void free_block(void *va)
{
  802574:	55                   	push   %ebp
  802575:	89 e5                	mov    %esp,%ebp
  802577:	83 ec 38             	sub    $0x38,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		assert((uint32)va >= dynAllocStart && (uint32)va < dynAllocEnd);
  80257a:	8b 55 08             	mov    0x8(%ebp),%edx
  80257d:	a1 04 db 87 00       	mov    0x87db04,%eax
  802582:	39 c2                	cmp    %eax,%edx
  802584:	72 0c                	jb     802592 <free_block+0x1e>
  802586:	8b 55 08             	mov    0x8(%ebp),%edx
  802589:	a1 40 40 80 00       	mov    0x804040,%eax
  80258e:	39 c2                	cmp    %eax,%edx
  802590:	72 19                	jb     8025ab <free_block+0x37>
  802592:	68 b0 35 80 00       	push   $0x8035b0
  802597:	68 26 35 80 00       	push   $0x803526
  80259c:	68 d7 00 00 00       	push   $0xd7
  8025a1:	68 c3 34 80 00       	push   $0x8034c3
  8025a6:	e8 21 03 00 00       	call   8028cc <_panic>
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #4 free_block
	//Your code is here
	//Comment the following line
	// va of a piece in memory to free so:
	// 1. get its page, and make blk with this address to be put in the freeBlockList.
	struct BlockElement* blk_to_free = (struct BlockElement*)va;
  8025ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8025ae:	89 45 e8             	mov    %eax,-0x18(%ebp)
	struct PageInfoElement *pageInfo = to_page_info((uint32)va);
  8025b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8025b4:	83 ec 0c             	sub    $0xc,%esp
  8025b7:	50                   	push   %eax
  8025b8:	e8 67 f8 ff ff       	call   801e24 <to_page_info>
  8025bd:	83 c4 10             	add    $0x10,%esp
  8025c0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	uint32 blk_size = pageInfo->block_size;
  8025c3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8025c6:	8b 40 08             	mov    0x8(%eax),%eax
  8025c9:	0f b7 c0             	movzwl %ax,%eax
  8025cc:	89 45 e0             	mov    %eax,-0x20(%ebp)

	// its index in the freeBlocklist.
	int idx = 0;
  8025cf:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int i = LOG2_MIN_SIZE; i <= LOG2_MAX_SIZE; i++) {
  8025d6:	c7 45 f0 03 00 00 00 	movl   $0x3,-0x10(%ebp)
  8025dd:	eb 19                	jmp    8025f8 <free_block+0x84>
	    if ((1 << i) == blk_size)
  8025df:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025e2:	ba 01 00 00 00       	mov    $0x1,%edx
  8025e7:	88 c1                	mov    %al,%cl
  8025e9:	d3 e2                	shl    %cl,%edx
  8025eb:	89 d0                	mov    %edx,%eax
  8025ed:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8025f0:	74 0e                	je     802600 <free_block+0x8c>
	        break;
	    idx++;
  8025f2:	ff 45 f4             	incl   -0xc(%ebp)
	struct PageInfoElement *pageInfo = to_page_info((uint32)va);
	uint32 blk_size = pageInfo->block_size;

	// its index in the freeBlocklist.
	int idx = 0;
	for (int i = LOG2_MIN_SIZE; i <= LOG2_MAX_SIZE; i++) {
  8025f5:	ff 45 f0             	incl   -0x10(%ebp)
  8025f8:	83 7d f0 0b          	cmpl   $0xb,-0x10(%ebp)
  8025fc:	7e e1                	jle    8025df <free_block+0x6b>
  8025fe:	eb 01                	jmp    802601 <free_block+0x8d>
	    if ((1 << i) == blk_size)
	        break;
  802600:	90                   	nop
	    idx++;
	}

	pageInfo->num_of_free_blocks++;
  802601:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802604:	66 8b 40 0a          	mov    0xa(%eax),%ax
  802608:	40                   	inc    %eax
  802609:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80260c:	66 89 42 0a          	mov    %ax,0xa(%edx)
	LIST_INSERT_TAIL(&freeBlockLists[idx], blk_to_free);
  802610:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802614:	75 17                	jne    80262d <free_block+0xb9>
  802616:	83 ec 04             	sub    $0x4,%esp
  802619:	68 3c 35 80 00       	push   $0x80353c
  80261e:	68 ee 00 00 00       	push   $0xee
  802623:	68 c3 34 80 00       	push   $0x8034c3
  802628:	e8 9f 02 00 00       	call   8028cc <_panic>
  80262d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802630:	c1 e0 04             	shl    $0x4,%eax
  802633:	05 24 db 87 00       	add    $0x87db24,%eax
  802638:	8b 10                	mov    (%eax),%edx
  80263a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80263d:	89 50 04             	mov    %edx,0x4(%eax)
  802640:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802643:	8b 40 04             	mov    0x4(%eax),%eax
  802646:	85 c0                	test   %eax,%eax
  802648:	74 14                	je     80265e <free_block+0xea>
  80264a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80264d:	c1 e0 04             	shl    $0x4,%eax
  802650:	05 24 db 87 00       	add    $0x87db24,%eax
  802655:	8b 00                	mov    (%eax),%eax
  802657:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80265a:	89 10                	mov    %edx,(%eax)
  80265c:	eb 11                	jmp    80266f <free_block+0xfb>
  80265e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802661:	c1 e0 04             	shl    $0x4,%eax
  802664:	8d 90 20 db 87 00    	lea    0x87db20(%eax),%edx
  80266a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80266d:	89 02                	mov    %eax,(%edx)
  80266f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802672:	c1 e0 04             	shl    $0x4,%eax
  802675:	8d 90 24 db 87 00    	lea    0x87db24(%eax),%edx
  80267b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80267e:	89 02                	mov    %eax,(%edx)
  802680:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802683:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802689:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80268c:	c1 e0 04             	shl    $0x4,%eax
  80268f:	05 2c db 87 00       	add    $0x87db2c,%eax
  802694:	8b 00                	mov    (%eax),%eax
  802696:	8d 50 01             	lea    0x1(%eax),%edx
  802699:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80269c:	c1 e0 04             	shl    $0x4,%eax
  80269f:	05 2c db 87 00       	add    $0x87db2c,%eax
  8026a4:	89 10                	mov    %edx,(%eax)

	// now, case 1: the page all blocks are freed so you free the page.
	int blk_count = PAGE_SIZE / blk_size;
  8026a6:	b8 00 10 00 00       	mov    $0x1000,%eax
  8026ab:	ba 00 00 00 00       	mov    $0x0,%edx
  8026b0:	f7 75 e0             	divl   -0x20(%ebp)
  8026b3:	89 45 dc             	mov    %eax,-0x24(%ebp)
	// the blk count in the page is same as number fo free blocks free up the page.
	if (pageInfo->num_of_free_blocks == blk_count) {
  8026b6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8026b9:	66 8b 40 0a          	mov    0xa(%eax),%ax
  8026bd:	0f b7 c0             	movzwl %ax,%eax
  8026c0:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  8026c3:	0f 85 70 01 00 00    	jne    802839 <free_block+0x2c5>
		uint32 page_va = to_page_va(pageInfo);
  8026c9:	83 ec 0c             	sub    $0xc,%esp
  8026cc:	ff 75 e4             	pushl  -0x1c(%ebp)
  8026cf:	e8 de f6 ff ff       	call   801db2 <to_page_va>
  8026d4:	83 c4 10             	add    $0x10,%esp
  8026d7:	89 45 d8             	mov    %eax,-0x28(%ebp)
		// remove all blk in the freeBlockList.
		for (uint32 off = 0; off < PAGE_SIZE; off += blk_size) {
  8026da:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  8026e1:	e9 b7 00 00 00       	jmp    80279d <free_block+0x229>
			struct BlockElement *blk = (struct BlockElement*)(page_va + off);
  8026e6:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8026e9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8026ec:	01 d0                	add    %edx,%eax
  8026ee:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			LIST_REMOVE(&freeBlockLists[idx], blk);
  8026f1:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8026f5:	75 17                	jne    80270e <free_block+0x19a>
  8026f7:	83 ec 04             	sub    $0x4,%esp
  8026fa:	68 81 35 80 00       	push   $0x803581
  8026ff:	68 f8 00 00 00       	push   $0xf8
  802704:	68 c3 34 80 00       	push   $0x8034c3
  802709:	e8 be 01 00 00       	call   8028cc <_panic>
  80270e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802711:	8b 00                	mov    (%eax),%eax
  802713:	85 c0                	test   %eax,%eax
  802715:	74 10                	je     802727 <free_block+0x1b3>
  802717:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80271a:	8b 00                	mov    (%eax),%eax
  80271c:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  80271f:	8b 52 04             	mov    0x4(%edx),%edx
  802722:	89 50 04             	mov    %edx,0x4(%eax)
  802725:	eb 14                	jmp    80273b <free_block+0x1c7>
  802727:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80272a:	8b 40 04             	mov    0x4(%eax),%eax
  80272d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802730:	c1 e2 04             	shl    $0x4,%edx
  802733:	81 c2 24 db 87 00    	add    $0x87db24,%edx
  802739:	89 02                	mov    %eax,(%edx)
  80273b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80273e:	8b 40 04             	mov    0x4(%eax),%eax
  802741:	85 c0                	test   %eax,%eax
  802743:	74 0f                	je     802754 <free_block+0x1e0>
  802745:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802748:	8b 40 04             	mov    0x4(%eax),%eax
  80274b:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  80274e:	8b 12                	mov    (%edx),%edx
  802750:	89 10                	mov    %edx,(%eax)
  802752:	eb 13                	jmp    802767 <free_block+0x1f3>
  802754:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802757:	8b 00                	mov    (%eax),%eax
  802759:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80275c:	c1 e2 04             	shl    $0x4,%edx
  80275f:	81 c2 20 db 87 00    	add    $0x87db20,%edx
  802765:	89 02                	mov    %eax,(%edx)
  802767:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80276a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802770:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802773:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80277a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80277d:	c1 e0 04             	shl    $0x4,%eax
  802780:	05 2c db 87 00       	add    $0x87db2c,%eax
  802785:	8b 00                	mov    (%eax),%eax
  802787:	8d 50 ff             	lea    -0x1(%eax),%edx
  80278a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80278d:	c1 e0 04             	shl    $0x4,%eax
  802790:	05 2c db 87 00       	add    $0x87db2c,%eax
  802795:	89 10                	mov    %edx,(%eax)
	int blk_count = PAGE_SIZE / blk_size;
	// the blk count in the page is same as number fo free blocks free up the page.
	if (pageInfo->num_of_free_blocks == blk_count) {
		uint32 page_va = to_page_va(pageInfo);
		// remove all blk in the freeBlockList.
		for (uint32 off = 0; off < PAGE_SIZE; off += blk_size) {
  802797:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80279a:	01 45 ec             	add    %eax,-0x14(%ebp)
  80279d:	81 7d ec ff 0f 00 00 	cmpl   $0xfff,-0x14(%ebp)
  8027a4:	0f 86 3c ff ff ff    	jbe    8026e6 <free_block+0x172>
			struct BlockElement *blk = (struct BlockElement*)(page_va + off);
			LIST_REMOVE(&freeBlockLists[idx], blk);
		}
		// reset page info.
		pageInfo->block_size = 0;
  8027aa:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8027ad:	66 c7 40 08 00 00    	movw   $0x0,0x8(%eax)
		pageInfo->num_of_free_blocks = 0;
  8027b3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8027b6:	66 c7 40 0a 00 00    	movw   $0x0,0xa(%eax)
		// add it to the available pages.
		LIST_INSERT_TAIL(&freePagesList, pageInfo);
  8027bc:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8027c0:	75 17                	jne    8027d9 <free_block+0x265>
  8027c2:	83 ec 04             	sub    $0x4,%esp
  8027c5:	68 3c 35 80 00       	push   $0x80353c
  8027ca:	68 fe 00 00 00       	push   $0xfe
  8027cf:	68 c3 34 80 00       	push   $0x8034c3
  8027d4:	e8 f3 00 00 00       	call   8028cc <_panic>
  8027d9:	8b 15 e8 5a 86 00    	mov    0x865ae8,%edx
  8027df:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8027e2:	89 50 04             	mov    %edx,0x4(%eax)
  8027e5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8027e8:	8b 40 04             	mov    0x4(%eax),%eax
  8027eb:	85 c0                	test   %eax,%eax
  8027ed:	74 0c                	je     8027fb <free_block+0x287>
  8027ef:	a1 e8 5a 86 00       	mov    0x865ae8,%eax
  8027f4:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8027f7:	89 10                	mov    %edx,(%eax)
  8027f9:	eb 08                	jmp    802803 <free_block+0x28f>
  8027fb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8027fe:	a3 e4 5a 86 00       	mov    %eax,0x865ae4
  802803:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802806:	a3 e8 5a 86 00       	mov    %eax,0x865ae8
  80280b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80280e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802814:	a1 f0 5a 86 00       	mov    0x865af0,%eax
  802819:	40                   	inc    %eax
  80281a:	a3 f0 5a 86 00       	mov    %eax,0x865af0
		// make it available in memory.
		return_page((uint32 *)to_page_va(pageInfo));
  80281f:	83 ec 0c             	sub    $0xc,%esp
  802822:	ff 75 e4             	pushl  -0x1c(%ebp)
  802825:	e8 88 f5 ff ff       	call   801db2 <to_page_va>
  80282a:	83 c4 10             	add    $0x10,%esp
  80282d:	83 ec 0c             	sub    $0xc,%esp
  802830:	50                   	push   %eax
  802831:	e8 b8 ee ff ff       	call   8016ee <return_page>
  802836:	83 c4 10             	add    $0x10,%esp
	}
	//panic("free_block() Not implemented yet");
}
  802839:	90                   	nop
  80283a:	c9                   	leave  
  80283b:	c3                   	ret    

0080283c <realloc_block>:

//===========================
// [1] REALLOCATE BLOCK:
//===========================
void *realloc_block(void* va, uint32 new_size)
{
  80283c:	55                   	push   %ebp
  80283d:	89 e5                	mov    %esp,%ebp
  80283f:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.BONUS#2] KERNEL REALLOC - realloc_block
	//Your code is here
	//Comment the following line
	panic("realloc_block() Not implemented yet");
  802842:	83 ec 04             	sub    $0x4,%esp
  802845:	68 e8 35 80 00       	push   $0x8035e8
  80284a:	68 11 01 00 00       	push   $0x111
  80284f:	68 c3 34 80 00       	push   $0x8034c3
  802854:	e8 73 00 00 00       	call   8028cc <_panic>

00802859 <create_semaphore>:
// User-level Semaphore

#include "inc/lib.h"

struct semaphore create_semaphore(char *semaphoreName, uint32 value)
{
  802859:	55                   	push   %ebp
  80285a:	89 e5                	mov    %esp,%ebp
  80285c:	83 ec 08             	sub    $0x8,%esp
	panic("create_semaphore() is not implemented yet...!!");
  80285f:	83 ec 04             	sub    $0x4,%esp
  802862:	68 0c 36 80 00       	push   $0x80360c
  802867:	6a 07                	push   $0x7
  802869:	68 3b 36 80 00       	push   $0x80363b
  80286e:	e8 59 00 00 00       	call   8028cc <_panic>

00802873 <get_semaphore>:
}
struct semaphore get_semaphore(int32 ownerEnvID, char* semaphoreName)
{
  802873:	55                   	push   %ebp
  802874:	89 e5                	mov    %esp,%ebp
  802876:	83 ec 08             	sub    $0x8,%esp
	panic("get_semaphore() is not implemented yet...!!");
  802879:	83 ec 04             	sub    $0x4,%esp
  80287c:	68 4c 36 80 00       	push   $0x80364c
  802881:	6a 0b                	push   $0xb
  802883:	68 3b 36 80 00       	push   $0x80363b
  802888:	e8 3f 00 00 00       	call   8028cc <_panic>

0080288d <wait_semaphore>:
}

void wait_semaphore(struct semaphore sem)
{
  80288d:	55                   	push   %ebp
  80288e:	89 e5                	mov    %esp,%ebp
  802890:	83 ec 08             	sub    $0x8,%esp
	panic("wait_semaphore() is not implemented yet...!!");
  802893:	83 ec 04             	sub    $0x4,%esp
  802896:	68 78 36 80 00       	push   $0x803678
  80289b:	6a 10                	push   $0x10
  80289d:	68 3b 36 80 00       	push   $0x80363b
  8028a2:	e8 25 00 00 00       	call   8028cc <_panic>

008028a7 <signal_semaphore>:
}

void signal_semaphore(struct semaphore sem)
{
  8028a7:	55                   	push   %ebp
  8028a8:	89 e5                	mov    %esp,%ebp
  8028aa:	83 ec 08             	sub    $0x8,%esp
	panic("signal_semaphore() is not implemented yet...!!");
  8028ad:	83 ec 04             	sub    $0x4,%esp
  8028b0:	68 a8 36 80 00       	push   $0x8036a8
  8028b5:	6a 15                	push   $0x15
  8028b7:	68 3b 36 80 00       	push   $0x80363b
  8028bc:	e8 0b 00 00 00       	call   8028cc <_panic>

008028c1 <semaphore_count>:
}

int semaphore_count(struct semaphore sem)
{
  8028c1:	55                   	push   %ebp
  8028c2:	89 e5                	mov    %esp,%ebp
	return sem.semdata->count;
  8028c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8028c7:	8b 40 10             	mov    0x10(%eax),%eax
}
  8028ca:	5d                   	pop    %ebp
  8028cb:	c3                   	ret    

008028cc <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  8028cc:	55                   	push   %ebp
  8028cd:	89 e5                	mov    %esp,%ebp
  8028cf:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  8028d2:	8d 45 10             	lea    0x10(%ebp),%eax
  8028d5:	83 c0 04             	add    $0x4,%eax
  8028d8:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  8028db:	a1 48 f6 8d 00       	mov    0x8df648,%eax
  8028e0:	85 c0                	test   %eax,%eax
  8028e2:	74 16                	je     8028fa <_panic+0x2e>
		cprintf("%s: ", argv0);
  8028e4:	a1 48 f6 8d 00       	mov    0x8df648,%eax
  8028e9:	83 ec 08             	sub    $0x8,%esp
  8028ec:	50                   	push   %eax
  8028ed:	68 d8 36 80 00       	push   $0x8036d8
  8028f2:	e8 75 de ff ff       	call   80076c <cprintf>
  8028f7:	83 c4 10             	add    $0x10,%esp
	cprintf_colored(TEXT_PANIC_CLR, "user [EVAL_FINAL]panic in %s at %s:%d: ", binaryname, file, line);
  8028fa:	a1 04 40 80 00       	mov    0x804004,%eax
  8028ff:	83 ec 0c             	sub    $0xc,%esp
  802902:	ff 75 0c             	pushl  0xc(%ebp)
  802905:	ff 75 08             	pushl  0x8(%ebp)
  802908:	50                   	push   %eax
  802909:	68 e0 36 80 00       	push   $0x8036e0
  80290e:	6a 74                	push   $0x74
  802910:	e8 84 de ff ff       	call   800799 <cprintf_colored>
  802915:	83 c4 20             	add    $0x20,%esp
	vcprintf(fmt, ap);
  802918:	8b 45 10             	mov    0x10(%ebp),%eax
  80291b:	83 ec 08             	sub    $0x8,%esp
  80291e:	ff 75 f4             	pushl  -0xc(%ebp)
  802921:	50                   	push   %eax
  802922:	e8 d6 dd ff ff       	call   8006fd <vcprintf>
  802927:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  80292a:	83 ec 08             	sub    $0x8,%esp
  80292d:	6a 00                	push   $0x0
  80292f:	68 08 37 80 00       	push   $0x803708
  802934:	e8 c4 dd ff ff       	call   8006fd <vcprintf>
  802939:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  80293c:	e8 3d dd ff ff       	call   80067e <exit>

	// should not return here
	while (1) ;
  802941:	eb fe                	jmp    802941 <_panic+0x75>

00802943 <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  802943:	55                   	push   %ebp
  802944:	89 e5                	mov    %esp,%ebp
  802946:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  802949:	a1 20 40 80 00       	mov    0x804020,%eax
  80294e:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  802954:	8b 45 0c             	mov    0xc(%ebp),%eax
  802957:	39 c2                	cmp    %eax,%edx
  802959:	74 14                	je     80296f <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  80295b:	83 ec 04             	sub    $0x4,%esp
  80295e:	68 0c 37 80 00       	push   $0x80370c
  802963:	6a 26                	push   $0x26
  802965:	68 58 37 80 00       	push   $0x803758
  80296a:	e8 5d ff ff ff       	call   8028cc <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  80296f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  802976:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80297d:	e9 c5 00 00 00       	jmp    802a47 <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  802982:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802985:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80298c:	8b 45 08             	mov    0x8(%ebp),%eax
  80298f:	01 d0                	add    %edx,%eax
  802991:	8b 00                	mov    (%eax),%eax
  802993:	85 c0                	test   %eax,%eax
  802995:	75 08                	jne    80299f <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  802997:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  80299a:	e9 a5 00 00 00       	jmp    802a44 <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  80299f:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8029a6:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  8029ad:	eb 69                	jmp    802a18 <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  8029af:	a1 20 40 80 00       	mov    0x804020,%eax
  8029b4:	8b 88 38 da 01 00    	mov    0x1da38(%eax),%ecx
  8029ba:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8029bd:	89 d0                	mov    %edx,%eax
  8029bf:	01 c0                	add    %eax,%eax
  8029c1:	01 d0                	add    %edx,%eax
  8029c3:	c1 e0 03             	shl    $0x3,%eax
  8029c6:	01 c8                	add    %ecx,%eax
  8029c8:	8a 40 04             	mov    0x4(%eax),%al
  8029cb:	84 c0                	test   %al,%al
  8029cd:	75 46                	jne    802a15 <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8029cf:	a1 20 40 80 00       	mov    0x804020,%eax
  8029d4:	8b 88 38 da 01 00    	mov    0x1da38(%eax),%ecx
  8029da:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8029dd:	89 d0                	mov    %edx,%eax
  8029df:	01 c0                	add    %eax,%eax
  8029e1:	01 d0                	add    %edx,%eax
  8029e3:	c1 e0 03             	shl    $0x3,%eax
  8029e6:	01 c8                	add    %ecx,%eax
  8029e8:	8b 00                	mov    (%eax),%eax
  8029ea:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8029ed:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8029f0:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8029f5:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  8029f7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029fa:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  802a01:	8b 45 08             	mov    0x8(%ebp),%eax
  802a04:	01 c8                	add    %ecx,%eax
  802a06:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  802a08:	39 c2                	cmp    %eax,%edx
  802a0a:	75 09                	jne    802a15 <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  802a0c:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  802a13:	eb 15                	jmp    802a2a <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  802a15:	ff 45 e8             	incl   -0x18(%ebp)
  802a18:	a1 20 40 80 00       	mov    0x804020,%eax
  802a1d:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  802a23:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802a26:	39 c2                	cmp    %eax,%edx
  802a28:	77 85                	ja     8029af <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  802a2a:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802a2e:	75 14                	jne    802a44 <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  802a30:	83 ec 04             	sub    $0x4,%esp
  802a33:	68 64 37 80 00       	push   $0x803764
  802a38:	6a 3a                	push   $0x3a
  802a3a:	68 58 37 80 00       	push   $0x803758
  802a3f:	e8 88 fe ff ff       	call   8028cc <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  802a44:	ff 45 f0             	incl   -0x10(%ebp)
  802a47:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a4a:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802a4d:	0f 8c 2f ff ff ff    	jl     802982 <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  802a53:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  802a5a:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  802a61:	eb 26                	jmp    802a89 <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  802a63:	a1 20 40 80 00       	mov    0x804020,%eax
  802a68:	8b 88 38 da 01 00    	mov    0x1da38(%eax),%ecx
  802a6e:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802a71:	89 d0                	mov    %edx,%eax
  802a73:	01 c0                	add    %eax,%eax
  802a75:	01 d0                	add    %edx,%eax
  802a77:	c1 e0 03             	shl    $0x3,%eax
  802a7a:	01 c8                	add    %ecx,%eax
  802a7c:	8a 40 04             	mov    0x4(%eax),%al
  802a7f:	3c 01                	cmp    $0x1,%al
  802a81:	75 03                	jne    802a86 <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  802a83:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  802a86:	ff 45 e0             	incl   -0x20(%ebp)
  802a89:	a1 20 40 80 00       	mov    0x804020,%eax
  802a8e:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  802a94:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802a97:	39 c2                	cmp    %eax,%edx
  802a99:	77 c8                	ja     802a63 <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  802a9b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a9e:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  802aa1:	74 14                	je     802ab7 <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  802aa3:	83 ec 04             	sub    $0x4,%esp
  802aa6:	68 b8 37 80 00       	push   $0x8037b8
  802aab:	6a 44                	push   $0x44
  802aad:	68 58 37 80 00       	push   $0x803758
  802ab2:	e8 15 fe ff ff       	call   8028cc <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  802ab7:	90                   	nop
  802ab8:	c9                   	leave  
  802ab9:	c3                   	ret    
  802aba:	66 90                	xchg   %ax,%ax

00802abc <__udivdi3>:
  802abc:	55                   	push   %ebp
  802abd:	57                   	push   %edi
  802abe:	56                   	push   %esi
  802abf:	53                   	push   %ebx
  802ac0:	83 ec 1c             	sub    $0x1c,%esp
  802ac3:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  802ac7:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  802acb:	8b 7c 24 38          	mov    0x38(%esp),%edi
  802acf:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802ad3:	89 ca                	mov    %ecx,%edx
  802ad5:	89 f8                	mov    %edi,%eax
  802ad7:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  802adb:	85 f6                	test   %esi,%esi
  802add:	75 2d                	jne    802b0c <__udivdi3+0x50>
  802adf:	39 cf                	cmp    %ecx,%edi
  802ae1:	77 65                	ja     802b48 <__udivdi3+0x8c>
  802ae3:	89 fd                	mov    %edi,%ebp
  802ae5:	85 ff                	test   %edi,%edi
  802ae7:	75 0b                	jne    802af4 <__udivdi3+0x38>
  802ae9:	b8 01 00 00 00       	mov    $0x1,%eax
  802aee:	31 d2                	xor    %edx,%edx
  802af0:	f7 f7                	div    %edi
  802af2:	89 c5                	mov    %eax,%ebp
  802af4:	31 d2                	xor    %edx,%edx
  802af6:	89 c8                	mov    %ecx,%eax
  802af8:	f7 f5                	div    %ebp
  802afa:	89 c1                	mov    %eax,%ecx
  802afc:	89 d8                	mov    %ebx,%eax
  802afe:	f7 f5                	div    %ebp
  802b00:	89 cf                	mov    %ecx,%edi
  802b02:	89 fa                	mov    %edi,%edx
  802b04:	83 c4 1c             	add    $0x1c,%esp
  802b07:	5b                   	pop    %ebx
  802b08:	5e                   	pop    %esi
  802b09:	5f                   	pop    %edi
  802b0a:	5d                   	pop    %ebp
  802b0b:	c3                   	ret    
  802b0c:	39 ce                	cmp    %ecx,%esi
  802b0e:	77 28                	ja     802b38 <__udivdi3+0x7c>
  802b10:	0f bd fe             	bsr    %esi,%edi
  802b13:	83 f7 1f             	xor    $0x1f,%edi
  802b16:	75 40                	jne    802b58 <__udivdi3+0x9c>
  802b18:	39 ce                	cmp    %ecx,%esi
  802b1a:	72 0a                	jb     802b26 <__udivdi3+0x6a>
  802b1c:	3b 44 24 08          	cmp    0x8(%esp),%eax
  802b20:	0f 87 9e 00 00 00    	ja     802bc4 <__udivdi3+0x108>
  802b26:	b8 01 00 00 00       	mov    $0x1,%eax
  802b2b:	89 fa                	mov    %edi,%edx
  802b2d:	83 c4 1c             	add    $0x1c,%esp
  802b30:	5b                   	pop    %ebx
  802b31:	5e                   	pop    %esi
  802b32:	5f                   	pop    %edi
  802b33:	5d                   	pop    %ebp
  802b34:	c3                   	ret    
  802b35:	8d 76 00             	lea    0x0(%esi),%esi
  802b38:	31 ff                	xor    %edi,%edi
  802b3a:	31 c0                	xor    %eax,%eax
  802b3c:	89 fa                	mov    %edi,%edx
  802b3e:	83 c4 1c             	add    $0x1c,%esp
  802b41:	5b                   	pop    %ebx
  802b42:	5e                   	pop    %esi
  802b43:	5f                   	pop    %edi
  802b44:	5d                   	pop    %ebp
  802b45:	c3                   	ret    
  802b46:	66 90                	xchg   %ax,%ax
  802b48:	89 d8                	mov    %ebx,%eax
  802b4a:	f7 f7                	div    %edi
  802b4c:	31 ff                	xor    %edi,%edi
  802b4e:	89 fa                	mov    %edi,%edx
  802b50:	83 c4 1c             	add    $0x1c,%esp
  802b53:	5b                   	pop    %ebx
  802b54:	5e                   	pop    %esi
  802b55:	5f                   	pop    %edi
  802b56:	5d                   	pop    %ebp
  802b57:	c3                   	ret    
  802b58:	bd 20 00 00 00       	mov    $0x20,%ebp
  802b5d:	89 eb                	mov    %ebp,%ebx
  802b5f:	29 fb                	sub    %edi,%ebx
  802b61:	89 f9                	mov    %edi,%ecx
  802b63:	d3 e6                	shl    %cl,%esi
  802b65:	89 c5                	mov    %eax,%ebp
  802b67:	88 d9                	mov    %bl,%cl
  802b69:	d3 ed                	shr    %cl,%ebp
  802b6b:	89 e9                	mov    %ebp,%ecx
  802b6d:	09 f1                	or     %esi,%ecx
  802b6f:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  802b73:	89 f9                	mov    %edi,%ecx
  802b75:	d3 e0                	shl    %cl,%eax
  802b77:	89 c5                	mov    %eax,%ebp
  802b79:	89 d6                	mov    %edx,%esi
  802b7b:	88 d9                	mov    %bl,%cl
  802b7d:	d3 ee                	shr    %cl,%esi
  802b7f:	89 f9                	mov    %edi,%ecx
  802b81:	d3 e2                	shl    %cl,%edx
  802b83:	8b 44 24 08          	mov    0x8(%esp),%eax
  802b87:	88 d9                	mov    %bl,%cl
  802b89:	d3 e8                	shr    %cl,%eax
  802b8b:	09 c2                	or     %eax,%edx
  802b8d:	89 d0                	mov    %edx,%eax
  802b8f:	89 f2                	mov    %esi,%edx
  802b91:	f7 74 24 0c          	divl   0xc(%esp)
  802b95:	89 d6                	mov    %edx,%esi
  802b97:	89 c3                	mov    %eax,%ebx
  802b99:	f7 e5                	mul    %ebp
  802b9b:	39 d6                	cmp    %edx,%esi
  802b9d:	72 19                	jb     802bb8 <__udivdi3+0xfc>
  802b9f:	74 0b                	je     802bac <__udivdi3+0xf0>
  802ba1:	89 d8                	mov    %ebx,%eax
  802ba3:	31 ff                	xor    %edi,%edi
  802ba5:	e9 58 ff ff ff       	jmp    802b02 <__udivdi3+0x46>
  802baa:	66 90                	xchg   %ax,%ax
  802bac:	8b 54 24 08          	mov    0x8(%esp),%edx
  802bb0:	89 f9                	mov    %edi,%ecx
  802bb2:	d3 e2                	shl    %cl,%edx
  802bb4:	39 c2                	cmp    %eax,%edx
  802bb6:	73 e9                	jae    802ba1 <__udivdi3+0xe5>
  802bb8:	8d 43 ff             	lea    -0x1(%ebx),%eax
  802bbb:	31 ff                	xor    %edi,%edi
  802bbd:	e9 40 ff ff ff       	jmp    802b02 <__udivdi3+0x46>
  802bc2:	66 90                	xchg   %ax,%ax
  802bc4:	31 c0                	xor    %eax,%eax
  802bc6:	e9 37 ff ff ff       	jmp    802b02 <__udivdi3+0x46>
  802bcb:	90                   	nop

00802bcc <__umoddi3>:
  802bcc:	55                   	push   %ebp
  802bcd:	57                   	push   %edi
  802bce:	56                   	push   %esi
  802bcf:	53                   	push   %ebx
  802bd0:	83 ec 1c             	sub    $0x1c,%esp
  802bd3:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  802bd7:	8b 74 24 34          	mov    0x34(%esp),%esi
  802bdb:	8b 7c 24 38          	mov    0x38(%esp),%edi
  802bdf:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  802be3:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802be7:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802beb:	89 f3                	mov    %esi,%ebx
  802bed:	89 fa                	mov    %edi,%edx
  802bef:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  802bf3:	89 34 24             	mov    %esi,(%esp)
  802bf6:	85 c0                	test   %eax,%eax
  802bf8:	75 1a                	jne    802c14 <__umoddi3+0x48>
  802bfa:	39 f7                	cmp    %esi,%edi
  802bfc:	0f 86 a2 00 00 00    	jbe    802ca4 <__umoddi3+0xd8>
  802c02:	89 c8                	mov    %ecx,%eax
  802c04:	89 f2                	mov    %esi,%edx
  802c06:	f7 f7                	div    %edi
  802c08:	89 d0                	mov    %edx,%eax
  802c0a:	31 d2                	xor    %edx,%edx
  802c0c:	83 c4 1c             	add    $0x1c,%esp
  802c0f:	5b                   	pop    %ebx
  802c10:	5e                   	pop    %esi
  802c11:	5f                   	pop    %edi
  802c12:	5d                   	pop    %ebp
  802c13:	c3                   	ret    
  802c14:	39 f0                	cmp    %esi,%eax
  802c16:	0f 87 ac 00 00 00    	ja     802cc8 <__umoddi3+0xfc>
  802c1c:	0f bd e8             	bsr    %eax,%ebp
  802c1f:	83 f5 1f             	xor    $0x1f,%ebp
  802c22:	0f 84 ac 00 00 00    	je     802cd4 <__umoddi3+0x108>
  802c28:	bf 20 00 00 00       	mov    $0x20,%edi
  802c2d:	29 ef                	sub    %ebp,%edi
  802c2f:	89 fe                	mov    %edi,%esi
  802c31:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802c35:	89 e9                	mov    %ebp,%ecx
  802c37:	d3 e0                	shl    %cl,%eax
  802c39:	89 d7                	mov    %edx,%edi
  802c3b:	89 f1                	mov    %esi,%ecx
  802c3d:	d3 ef                	shr    %cl,%edi
  802c3f:	09 c7                	or     %eax,%edi
  802c41:	89 e9                	mov    %ebp,%ecx
  802c43:	d3 e2                	shl    %cl,%edx
  802c45:	89 14 24             	mov    %edx,(%esp)
  802c48:	89 d8                	mov    %ebx,%eax
  802c4a:	d3 e0                	shl    %cl,%eax
  802c4c:	89 c2                	mov    %eax,%edx
  802c4e:	8b 44 24 08          	mov    0x8(%esp),%eax
  802c52:	d3 e0                	shl    %cl,%eax
  802c54:	89 44 24 04          	mov    %eax,0x4(%esp)
  802c58:	8b 44 24 08          	mov    0x8(%esp),%eax
  802c5c:	89 f1                	mov    %esi,%ecx
  802c5e:	d3 e8                	shr    %cl,%eax
  802c60:	09 d0                	or     %edx,%eax
  802c62:	d3 eb                	shr    %cl,%ebx
  802c64:	89 da                	mov    %ebx,%edx
  802c66:	f7 f7                	div    %edi
  802c68:	89 d3                	mov    %edx,%ebx
  802c6a:	f7 24 24             	mull   (%esp)
  802c6d:	89 c6                	mov    %eax,%esi
  802c6f:	89 d1                	mov    %edx,%ecx
  802c71:	39 d3                	cmp    %edx,%ebx
  802c73:	0f 82 87 00 00 00    	jb     802d00 <__umoddi3+0x134>
  802c79:	0f 84 91 00 00 00    	je     802d10 <__umoddi3+0x144>
  802c7f:	8b 54 24 04          	mov    0x4(%esp),%edx
  802c83:	29 f2                	sub    %esi,%edx
  802c85:	19 cb                	sbb    %ecx,%ebx
  802c87:	89 d8                	mov    %ebx,%eax
  802c89:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  802c8d:	d3 e0                	shl    %cl,%eax
  802c8f:	89 e9                	mov    %ebp,%ecx
  802c91:	d3 ea                	shr    %cl,%edx
  802c93:	09 d0                	or     %edx,%eax
  802c95:	89 e9                	mov    %ebp,%ecx
  802c97:	d3 eb                	shr    %cl,%ebx
  802c99:	89 da                	mov    %ebx,%edx
  802c9b:	83 c4 1c             	add    $0x1c,%esp
  802c9e:	5b                   	pop    %ebx
  802c9f:	5e                   	pop    %esi
  802ca0:	5f                   	pop    %edi
  802ca1:	5d                   	pop    %ebp
  802ca2:	c3                   	ret    
  802ca3:	90                   	nop
  802ca4:	89 fd                	mov    %edi,%ebp
  802ca6:	85 ff                	test   %edi,%edi
  802ca8:	75 0b                	jne    802cb5 <__umoddi3+0xe9>
  802caa:	b8 01 00 00 00       	mov    $0x1,%eax
  802caf:	31 d2                	xor    %edx,%edx
  802cb1:	f7 f7                	div    %edi
  802cb3:	89 c5                	mov    %eax,%ebp
  802cb5:	89 f0                	mov    %esi,%eax
  802cb7:	31 d2                	xor    %edx,%edx
  802cb9:	f7 f5                	div    %ebp
  802cbb:	89 c8                	mov    %ecx,%eax
  802cbd:	f7 f5                	div    %ebp
  802cbf:	89 d0                	mov    %edx,%eax
  802cc1:	e9 44 ff ff ff       	jmp    802c0a <__umoddi3+0x3e>
  802cc6:	66 90                	xchg   %ax,%ax
  802cc8:	89 c8                	mov    %ecx,%eax
  802cca:	89 f2                	mov    %esi,%edx
  802ccc:	83 c4 1c             	add    $0x1c,%esp
  802ccf:	5b                   	pop    %ebx
  802cd0:	5e                   	pop    %esi
  802cd1:	5f                   	pop    %edi
  802cd2:	5d                   	pop    %ebp
  802cd3:	c3                   	ret    
  802cd4:	3b 04 24             	cmp    (%esp),%eax
  802cd7:	72 06                	jb     802cdf <__umoddi3+0x113>
  802cd9:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  802cdd:	77 0f                	ja     802cee <__umoddi3+0x122>
  802cdf:	89 f2                	mov    %esi,%edx
  802ce1:	29 f9                	sub    %edi,%ecx
  802ce3:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  802ce7:	89 14 24             	mov    %edx,(%esp)
  802cea:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  802cee:	8b 44 24 04          	mov    0x4(%esp),%eax
  802cf2:	8b 14 24             	mov    (%esp),%edx
  802cf5:	83 c4 1c             	add    $0x1c,%esp
  802cf8:	5b                   	pop    %ebx
  802cf9:	5e                   	pop    %esi
  802cfa:	5f                   	pop    %edi
  802cfb:	5d                   	pop    %ebp
  802cfc:	c3                   	ret    
  802cfd:	8d 76 00             	lea    0x0(%esi),%esi
  802d00:	2b 04 24             	sub    (%esp),%eax
  802d03:	19 fa                	sbb    %edi,%edx
  802d05:	89 d1                	mov    %edx,%ecx
  802d07:	89 c6                	mov    %eax,%esi
  802d09:	e9 71 ff ff ff       	jmp    802c7f <__umoddi3+0xb3>
  802d0e:	66 90                	xchg   %ax,%ax
  802d10:	39 44 24 04          	cmp    %eax,0x4(%esp)
  802d14:	72 ea                	jb     802d00 <__umoddi3+0x134>
  802d16:	89 d9                	mov    %ebx,%ecx
  802d18:	e9 62 ff ff ff       	jmp    802c7f <__umoddi3+0xb3>
