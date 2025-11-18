
obj/user/arrayOperations_mergesort:     file format elf32-i386


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
  800031:	e8 c9 04 00 00       	call   8004ff <libmain>
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
  80003e:	e8 fe 1a 00 00       	call   801b41 <sys_getparentenvid>
  800043:	89 45 f0             	mov    %eax,-0x10(%ebp)

	int ret;

	/*[1] GET SEMAPHORES*/
	struct semaphore ready = get_semaphore(parentenvID, "Ready");
  800046:	8d 45 dc             	lea    -0x24(%ebp),%eax
  800049:	83 ec 04             	sub    $0x4,%esp
  80004c:	68 60 2d 80 00       	push   $0x802d60
  800051:	ff 75 f0             	pushl  -0x10(%ebp)
  800054:	50                   	push   %eax
  800055:	e8 51 28 00 00       	call   8028ab <get_semaphore>
  80005a:	83 c4 0c             	add    $0xc,%esp
	struct semaphore finished = get_semaphore(parentenvID, "Finished");
  80005d:	8d 45 d8             	lea    -0x28(%ebp),%eax
  800060:	83 ec 04             	sub    $0x4,%esp
  800063:	68 66 2d 80 00       	push   $0x802d66
  800068:	ff 75 f0             	pushl  -0x10(%ebp)
  80006b:	50                   	push   %eax
  80006c:	e8 3a 28 00 00       	call   8028ab <get_semaphore>
  800071:	83 c4 0c             	add    $0xc,%esp

	/*[2] WAIT A READY SIGNAL FROM THE MASTER*/
	wait_semaphore(ready);
  800074:	83 ec 0c             	sub    $0xc,%esp
  800077:	ff 75 dc             	pushl  -0x24(%ebp)
  80007a:	e8 46 28 00 00       	call   8028c5 <wait_semaphore>
  80007f:	83 c4 10             	add    $0x10,%esp

	/*[3] GET SHARED VARs*/
	//Get the cons_mutex ownerID
	int* consMutexOwnerID = sget(parentenvID, "cons_mutex ownerID") ;
  800082:	83 ec 08             	sub    $0x8,%esp
  800085:	68 6f 2d 80 00       	push   $0x802d6f
  80008a:	ff 75 f0             	pushl  -0x10(%ebp)
  80008d:	e8 50 17 00 00       	call   8017e2 <sget>
  800092:	83 c4 10             	add    $0x10,%esp
  800095:	89 45 ec             	mov    %eax,-0x14(%ebp)
	struct semaphore cons_mutex = get_semaphore(*consMutexOwnerID, "Console Mutex");
  800098:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80009b:	8b 10                	mov    (%eax),%edx
  80009d:	8d 45 d4             	lea    -0x2c(%ebp),%eax
  8000a0:	83 ec 04             	sub    $0x4,%esp
  8000a3:	68 82 2d 80 00       	push   $0x802d82
  8000a8:	52                   	push   %edx
  8000a9:	50                   	push   %eax
  8000aa:	e8 fc 27 00 00       	call   8028ab <get_semaphore>
  8000af:	83 c4 0c             	add    $0xc,%esp

	//Get the shared array & its size
	int *numOfElements = NULL;
  8000b2:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	int *sharedArray = NULL;
  8000b9:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	sharedArray = sget(parentenvID, "arr") ;
  8000c0:	83 ec 08             	sub    $0x8,%esp
  8000c3:	68 90 2d 80 00       	push   $0x802d90
  8000c8:	ff 75 f0             	pushl  -0x10(%ebp)
  8000cb:	e8 12 17 00 00       	call   8017e2 <sget>
  8000d0:	83 c4 10             	add    $0x10,%esp
  8000d3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	numOfElements = sget(parentenvID, "arrSize") ;
  8000d6:	83 ec 08             	sub    $0x8,%esp
  8000d9:	68 94 2d 80 00       	push   $0x802d94
  8000de:	ff 75 f0             	pushl  -0x10(%ebp)
  8000e1:	e8 fc 16 00 00       	call   8017e2 <sget>
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
  8000fa:	68 9c 2d 80 00       	push   $0x802d9c
  8000ff:	e8 aa 16 00 00       	call   8017ae <smalloc>
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
  80015e:	e8 62 27 00 00       	call   8028c5 <wait_semaphore>
  800163:	83 c4 10             	add    $0x10,%esp
	{
		cprintf("Merge sort is Finished!!!!\n") ;
  800166:	83 ec 0c             	sub    $0xc,%esp
  800169:	68 ab 2d 80 00       	push   $0x802dab
  80016e:	e8 31 06 00 00       	call   8007a4 <cprintf>
  800173:	83 c4 10             	add    $0x10,%esp
		cprintf("will notify the master now...\n");
  800176:	83 ec 0c             	sub    $0xc,%esp
  800179:	68 c8 2d 80 00       	push   $0x802dc8
  80017e:	e8 21 06 00 00       	call   8007a4 <cprintf>
  800183:	83 c4 10             	add    $0x10,%esp
		cprintf("Merge sort says GOOD BYE :)\n") ;
  800186:	83 ec 0c             	sub    $0xc,%esp
  800189:	68 e7 2d 80 00       	push   $0x802de7
  80018e:	e8 11 06 00 00       	call   8007a4 <cprintf>
  800193:	83 c4 10             	add    $0x10,%esp
	}
	signal_semaphore(cons_mutex);
  800196:	83 ec 0c             	sub    $0xc,%esp
  800199:	ff 75 d4             	pushl  -0x2c(%ebp)
  80019c:	e8 3e 27 00 00       	call   8028df <signal_semaphore>
  8001a1:	83 c4 10             	add    $0x10,%esp

	/*[5] DECLARE FINISHING*/
	signal_semaphore(finished);
  8001a4:	83 ec 0c             	sub    $0xc,%esp
  8001a7:	ff 75 d8             	pushl  -0x28(%ebp)
  8001aa:	e8 30 27 00 00       	call   8028df <signal_semaphore>
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
  80022e:	68 04 2e 80 00       	push   $0x802e04
  800233:	e8 6c 05 00 00       	call   8007a4 <cprintf>
  800238:	83 c4 10             	add    $0x10,%esp
		cprintf("%d, ",Elements[i]);
  80023b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80023e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800245:	8b 45 08             	mov    0x8(%ebp),%eax
  800248:	01 d0                	add    %edx,%eax
  80024a:	8b 00                	mov    (%eax),%eax
  80024c:	83 ec 08             	sub    $0x8,%esp
  80024f:	50                   	push   %eax
  800250:	68 06 2e 80 00       	push   $0x802e06
  800255:	e8 4a 05 00 00       	call   8007a4 <cprintf>
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
  80027e:	68 0b 2e 80 00       	push   $0x802e0b
  800283:	e8 1c 05 00 00       	call   8007a4 <cprintf>
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
  8002f6:	83 ec 38             	sub    $0x38,%esp
	int leftCapacity = q - p + 1;
  8002f9:	8b 45 10             	mov    0x10(%ebp),%eax
  8002fc:	2b 45 0c             	sub    0xc(%ebp),%eax
  8002ff:	40                   	inc    %eax
  800300:	89 45 e0             	mov    %eax,-0x20(%ebp)

	int rightCapacity = r - q;
  800303:	8b 45 14             	mov    0x14(%ebp),%eax
  800306:	2b 45 10             	sub    0x10(%ebp),%eax
  800309:	89 45 dc             	mov    %eax,-0x24(%ebp)

	int leftIndex = 0;
  80030c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	int rightIndex = 0;
  800313:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

	int* Left = malloc(sizeof(int) * leftCapacity);
  80031a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80031d:	c1 e0 02             	shl    $0x2,%eax
  800320:	83 ec 0c             	sub    $0xc,%esp
  800323:	50                   	push   %eax
  800324:	e8 3d 14 00 00       	call   801766 <malloc>
  800329:	83 c4 10             	add    $0x10,%esp
  80032c:	89 45 d8             	mov    %eax,-0x28(%ebp)

	int* Right = malloc(sizeof(int) * rightCapacity);
  80032f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800332:	c1 e0 02             	shl    $0x2,%eax
  800335:	83 ec 0c             	sub    $0xc,%esp
  800338:	50                   	push   %eax
  800339:	e8 28 14 00 00       	call   801766 <malloc>
  80033e:	83 c4 10             	add    $0x10,%esp
  800341:	89 45 d4             	mov    %eax,-0x2c(%ebp)

	int i, j, k;
	for (i = 0; i < leftCapacity; i++)
  800344:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  80034b:	eb 2f                	jmp    80037c <Merge+0x89>
	{
		Left[i] = A[p + i - 1];
  80034d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800350:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800357:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80035a:	01 c2                	add    %eax,%edx
  80035c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80035f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800362:	01 c8                	add    %ecx,%eax
  800364:	05 ff ff ff 3f       	add    $0x3fffffff,%eax
  800369:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800370:	8b 45 08             	mov    0x8(%ebp),%eax
  800373:	01 c8                	add    %ecx,%eax
  800375:	8b 00                	mov    (%eax),%eax
  800377:	89 02                	mov    %eax,(%edx)
	int* Left = malloc(sizeof(int) * leftCapacity);

	int* Right = malloc(sizeof(int) * rightCapacity);

	int i, j, k;
	for (i = 0; i < leftCapacity; i++)
  800379:	ff 45 ec             	incl   -0x14(%ebp)
  80037c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80037f:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  800382:	7c c9                	jl     80034d <Merge+0x5a>
	{
		Left[i] = A[p + i - 1];
	}
	for (j = 0; j < rightCapacity; j++)
  800384:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  80038b:	eb 2a                	jmp    8003b7 <Merge+0xc4>
	{
		Right[j] = A[q + j];
  80038d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800390:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800397:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80039a:	01 c2                	add    %eax,%edx
  80039c:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80039f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8003a2:	01 c8                	add    %ecx,%eax
  8003a4:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8003ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8003ae:	01 c8                	add    %ecx,%eax
  8003b0:	8b 00                	mov    (%eax),%eax
  8003b2:	89 02                	mov    %eax,(%edx)
	int i, j, k;
	for (i = 0; i < leftCapacity; i++)
	{
		Left[i] = A[p + i - 1];
	}
	for (j = 0; j < rightCapacity; j++)
  8003b4:	ff 45 e8             	incl   -0x18(%ebp)
  8003b7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8003ba:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  8003bd:	7c ce                	jl     80038d <Merge+0x9a>
	{
		Right[j] = A[q + j];
	}

	for ( k = p; k <= r; k++)
  8003bf:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003c2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8003c5:	e9 0a 01 00 00       	jmp    8004d4 <Merge+0x1e1>
	{
		if (leftIndex < leftCapacity && rightIndex < rightCapacity)
  8003ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8003cd:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8003d0:	0f 8d 95 00 00 00    	jge    80046b <Merge+0x178>
  8003d6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8003d9:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  8003dc:	0f 8d 89 00 00 00    	jge    80046b <Merge+0x178>
		{
			if (Left[leftIndex] < Right[rightIndex] )
  8003e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8003e5:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8003ec:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8003ef:	01 d0                	add    %edx,%eax
  8003f1:	8b 10                	mov    (%eax),%edx
  8003f3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8003f6:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8003fd:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800400:	01 c8                	add    %ecx,%eax
  800402:	8b 00                	mov    (%eax),%eax
  800404:	39 c2                	cmp    %eax,%edx
  800406:	7d 33                	jge    80043b <Merge+0x148>
			{
				A[k - 1] = Left[leftIndex++];
  800408:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80040b:	05 ff ff ff 3f       	add    $0x3fffffff,%eax
  800410:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800417:	8b 45 08             	mov    0x8(%ebp),%eax
  80041a:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  80041d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800420:	8d 50 01             	lea    0x1(%eax),%edx
  800423:	89 55 f4             	mov    %edx,-0xc(%ebp)
  800426:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80042d:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800430:	01 d0                	add    %edx,%eax
  800432:	8b 00                	mov    (%eax),%eax
  800434:	89 01                	mov    %eax,(%ecx)

	for ( k = p; k <= r; k++)
	{
		if (leftIndex < leftCapacity && rightIndex < rightCapacity)
		{
			if (Left[leftIndex] < Right[rightIndex] )
  800436:	e9 96 00 00 00       	jmp    8004d1 <Merge+0x1de>
			{
				A[k - 1] = Left[leftIndex++];
			}
			else
			{
				A[k - 1] = Right[rightIndex++];
  80043b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80043e:	05 ff ff ff 3f       	add    $0x3fffffff,%eax
  800443:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80044a:	8b 45 08             	mov    0x8(%ebp),%eax
  80044d:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  800450:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800453:	8d 50 01             	lea    0x1(%eax),%edx
  800456:	89 55 f0             	mov    %edx,-0x10(%ebp)
  800459:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800460:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800463:	01 d0                	add    %edx,%eax
  800465:	8b 00                	mov    (%eax),%eax
  800467:	89 01                	mov    %eax,(%ecx)

	for ( k = p; k <= r; k++)
	{
		if (leftIndex < leftCapacity && rightIndex < rightCapacity)
		{
			if (Left[leftIndex] < Right[rightIndex] )
  800469:	eb 66                	jmp    8004d1 <Merge+0x1de>
			else
			{
				A[k - 1] = Right[rightIndex++];
			}
		}
		else if (leftIndex < leftCapacity)
  80046b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80046e:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  800471:	7d 30                	jge    8004a3 <Merge+0x1b0>
		{
			A[k - 1] = Left[leftIndex++];
  800473:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800476:	05 ff ff ff 3f       	add    $0x3fffffff,%eax
  80047b:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800482:	8b 45 08             	mov    0x8(%ebp),%eax
  800485:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  800488:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80048b:	8d 50 01             	lea    0x1(%eax),%edx
  80048e:	89 55 f4             	mov    %edx,-0xc(%ebp)
  800491:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800498:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80049b:	01 d0                	add    %edx,%eax
  80049d:	8b 00                	mov    (%eax),%eax
  80049f:	89 01                	mov    %eax,(%ecx)
  8004a1:	eb 2e                	jmp    8004d1 <Merge+0x1de>
		}
		else
		{
			A[k - 1] = Right[rightIndex++];
  8004a3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8004a6:	05 ff ff ff 3f       	add    $0x3fffffff,%eax
  8004ab:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8004b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8004b5:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  8004b8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8004bb:	8d 50 01             	lea    0x1(%eax),%edx
  8004be:	89 55 f0             	mov    %edx,-0x10(%ebp)
  8004c1:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8004c8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8004cb:	01 d0                	add    %edx,%eax
  8004cd:	8b 00                	mov    (%eax),%eax
  8004cf:	89 01                	mov    %eax,(%ecx)
	for (j = 0; j < rightCapacity; j++)
	{
		Right[j] = A[q + j];
	}

	for ( k = p; k <= r; k++)
  8004d1:	ff 45 e4             	incl   -0x1c(%ebp)
  8004d4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8004d7:	3b 45 14             	cmp    0x14(%ebp),%eax
  8004da:	0f 8e ea fe ff ff    	jle    8003ca <Merge+0xd7>
		{
			A[k - 1] = Right[rightIndex++];
		}
	}

	free(Left);
  8004e0:	83 ec 0c             	sub    $0xc,%esp
  8004e3:	ff 75 d8             	pushl  -0x28(%ebp)
  8004e6:	e8 a9 12 00 00       	call   801794 <free>
  8004eb:	83 c4 10             	add    $0x10,%esp
	free(Right);
  8004ee:	83 ec 0c             	sub    $0xc,%esp
  8004f1:	ff 75 d4             	pushl  -0x2c(%ebp)
  8004f4:	e8 9b 12 00 00       	call   801794 <free>
  8004f9:	83 c4 10             	add    $0x10,%esp

}
  8004fc:	90                   	nop
  8004fd:	c9                   	leave  
  8004fe:	c3                   	ret    

008004ff <libmain>:
volatile bool printStats = 1;

volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";
void
libmain(int argc, char **argv)
{
  8004ff:	55                   	push   %ebp
  800500:	89 e5                	mov    %esp,%ebp
  800502:	57                   	push   %edi
  800503:	56                   	push   %esi
  800504:	53                   	push   %ebx
  800505:	83 ec 7c             	sub    $0x7c,%esp
	//printStats = 1;
	int envIndex = sys_getenvindex();
  800508:	e8 1b 16 00 00       	call   801b28 <sys_getenvindex>
  80050d:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	myEnv = &(envs[envIndex]);
  800510:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800513:	89 d0                	mov    %edx,%eax
  800515:	c1 e0 06             	shl    $0x6,%eax
  800518:	29 d0                	sub    %edx,%eax
  80051a:	c1 e0 02             	shl    $0x2,%eax
  80051d:	01 d0                	add    %edx,%eax
  80051f:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800526:	01 c8                	add    %ecx,%eax
  800528:	c1 e0 03             	shl    $0x3,%eax
  80052b:	01 d0                	add    %edx,%eax
  80052d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800534:	29 c2                	sub    %eax,%edx
  800536:	8d 04 95 00 00 00 00 	lea    0x0(,%edx,4),%eax
  80053d:	89 c2                	mov    %eax,%edx
  80053f:	8d 82 00 00 c0 ee    	lea    -0x11400000(%edx),%eax
  800545:	a3 20 40 80 00       	mov    %eax,0x804020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  80054a:	a1 20 40 80 00       	mov    0x804020,%eax
  80054f:	8a 40 20             	mov    0x20(%eax),%al
  800552:	84 c0                	test   %al,%al
  800554:	74 0d                	je     800563 <libmain+0x64>
		binaryname = myEnv->prog_name;
  800556:	a1 20 40 80 00       	mov    0x804020,%eax
  80055b:	83 c0 20             	add    $0x20,%eax
  80055e:	a3 04 40 80 00       	mov    %eax,0x804004

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800563:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800567:	7e 0a                	jle    800573 <libmain+0x74>
		binaryname = argv[0];
  800569:	8b 45 0c             	mov    0xc(%ebp),%eax
  80056c:	8b 00                	mov    (%eax),%eax
  80056e:	a3 04 40 80 00       	mov    %eax,0x804004

	// call user main routine
	_main(argc, argv);
  800573:	83 ec 08             	sub    $0x8,%esp
  800576:	ff 75 0c             	pushl  0xc(%ebp)
  800579:	ff 75 08             	pushl  0x8(%ebp)
  80057c:	e8 b7 fa ff ff       	call   800038 <_main>
  800581:	83 c4 10             	add    $0x10,%esp

	if (printStats)
  800584:	a1 00 40 80 00       	mov    0x804000,%eax
  800589:	85 c0                	test   %eax,%eax
  80058b:	0f 84 01 01 00 00    	je     800692 <libmain+0x193>
	{
		char isOPTReplCmd[100] = "__IsOPTRepl__" ;
  800591:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  800597:	bb 08 2f 80 00       	mov    $0x802f08,%ebx
  80059c:	ba 0e 00 00 00       	mov    $0xe,%edx
  8005a1:	89 c7                	mov    %eax,%edi
  8005a3:	89 de                	mov    %ebx,%esi
  8005a5:	89 d1                	mov    %edx,%ecx
  8005a7:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  8005a9:	8d 55 8a             	lea    -0x76(%ebp),%edx
  8005ac:	b9 56 00 00 00       	mov    $0x56,%ecx
  8005b1:	b0 00                	mov    $0x0,%al
  8005b3:	89 d7                	mov    %edx,%edi
  8005b5:	f3 aa                	rep stos %al,%es:(%edi)
		int isOPTRepl = 0;
  8005b7:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
		sys_utilities(isOPTReplCmd, (uint32)(&isOPTRepl));
  8005be:	8d 45 e0             	lea    -0x20(%ebp),%eax
  8005c1:	83 ec 08             	sub    $0x8,%esp
  8005c4:	50                   	push   %eax
  8005c5:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  8005cb:	50                   	push   %eax
  8005cc:	e8 8d 17 00 00       	call   801d5e <sys_utilities>
  8005d1:	83 c4 10             	add    $0x10,%esp

		sys_lock_cons();
  8005d4:	e8 d6 12 00 00       	call   8018af <sys_lock_cons>
		{
			cprintf("**************************************\n");
  8005d9:	83 ec 0c             	sub    $0xc,%esp
  8005dc:	68 28 2e 80 00       	push   $0x802e28
  8005e1:	e8 be 01 00 00       	call   8007a4 <cprintf>
  8005e6:	83 c4 10             	add    $0x10,%esp
			if (isOPTRepl)
  8005e9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8005ec:	85 c0                	test   %eax,%eax
  8005ee:	74 18                	je     800608 <libmain+0x109>
			{
				cprintf("OPTIMAL number of page faults = %d\n", sys_get_optimal_num_faults());
  8005f0:	e8 87 17 00 00       	call   801d7c <sys_get_optimal_num_faults>
  8005f5:	83 ec 08             	sub    $0x8,%esp
  8005f8:	50                   	push   %eax
  8005f9:	68 50 2e 80 00       	push   $0x802e50
  8005fe:	e8 a1 01 00 00       	call   8007a4 <cprintf>
  800603:	83 c4 10             	add    $0x10,%esp
  800606:	eb 59                	jmp    800661 <libmain+0x162>
			}
			else
			{
				cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  800608:	a1 20 40 80 00       	mov    0x804020,%eax
  80060d:	8b 90 50 da 01 00    	mov    0x1da50(%eax),%edx
  800613:	a1 20 40 80 00       	mov    0x804020,%eax
  800618:	8b 80 40 da 01 00    	mov    0x1da40(%eax),%eax
  80061e:	83 ec 04             	sub    $0x4,%esp
  800621:	52                   	push   %edx
  800622:	50                   	push   %eax
  800623:	68 74 2e 80 00       	push   $0x802e74
  800628:	e8 77 01 00 00       	call   8007a4 <cprintf>
  80062d:	83 c4 10             	add    $0x10,%esp
				cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800630:	a1 20 40 80 00       	mov    0x804020,%eax
  800635:	8b 88 64 da 01 00    	mov    0x1da64(%eax),%ecx
  80063b:	a1 20 40 80 00       	mov    0x804020,%eax
  800640:	8b 90 60 da 01 00    	mov    0x1da60(%eax),%edx
  800646:	a1 20 40 80 00       	mov    0x804020,%eax
  80064b:	8b 80 5c da 01 00    	mov    0x1da5c(%eax),%eax
  800651:	51                   	push   %ecx
  800652:	52                   	push   %edx
  800653:	50                   	push   %eax
  800654:	68 9c 2e 80 00       	push   $0x802e9c
  800659:	e8 46 01 00 00       	call   8007a4 <cprintf>
  80065e:	83 c4 10             	add    $0x10,%esp
			}
			//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
			cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800661:	a1 20 40 80 00       	mov    0x804020,%eax
  800666:	8b 80 68 da 01 00    	mov    0x1da68(%eax),%eax
  80066c:	83 ec 08             	sub    $0x8,%esp
  80066f:	50                   	push   %eax
  800670:	68 f4 2e 80 00       	push   $0x802ef4
  800675:	e8 2a 01 00 00       	call   8007a4 <cprintf>
  80067a:	83 c4 10             	add    $0x10,%esp
			cprintf("**************************************\n");
  80067d:	83 ec 0c             	sub    $0xc,%esp
  800680:	68 28 2e 80 00       	push   $0x802e28
  800685:	e8 1a 01 00 00       	call   8007a4 <cprintf>
  80068a:	83 c4 10             	add    $0x10,%esp
		}
		sys_unlock_cons();
  80068d:	e8 37 12 00 00       	call   8018c9 <sys_unlock_cons>
	}

	// exit gracefully
	exit();
  800692:	e8 1f 00 00 00       	call   8006b6 <exit>
}
  800697:	90                   	nop
  800698:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80069b:	5b                   	pop    %ebx
  80069c:	5e                   	pop    %esi
  80069d:	5f                   	pop    %edi
  80069e:	5d                   	pop    %ebp
  80069f:	c3                   	ret    

008006a0 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  8006a0:	55                   	push   %ebp
  8006a1:	89 e5                	mov    %esp,%ebp
  8006a3:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  8006a6:	83 ec 0c             	sub    $0xc,%esp
  8006a9:	6a 00                	push   $0x0
  8006ab:	e8 44 14 00 00       	call   801af4 <sys_destroy_env>
  8006b0:	83 c4 10             	add    $0x10,%esp
}
  8006b3:	90                   	nop
  8006b4:	c9                   	leave  
  8006b5:	c3                   	ret    

008006b6 <exit>:

void
exit(void)
{
  8006b6:	55                   	push   %ebp
  8006b7:	89 e5                	mov    %esp,%ebp
  8006b9:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  8006bc:	e8 99 14 00 00       	call   801b5a <sys_exit_env>
}
  8006c1:	90                   	nop
  8006c2:	c9                   	leave  
  8006c3:	c3                   	ret    

008006c4 <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  8006c4:	55                   	push   %ebp
  8006c5:	89 e5                	mov    %esp,%ebp
  8006c7:	53                   	push   %ebx
  8006c8:	83 ec 04             	sub    $0x4,%esp
	b->buf[b->idx++] = ch;
  8006cb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006ce:	8b 00                	mov    (%eax),%eax
  8006d0:	8d 48 01             	lea    0x1(%eax),%ecx
  8006d3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8006d6:	89 0a                	mov    %ecx,(%edx)
  8006d8:	8b 55 08             	mov    0x8(%ebp),%edx
  8006db:	88 d1                	mov    %dl,%cl
  8006dd:	8b 55 0c             	mov    0xc(%ebp),%edx
  8006e0:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  8006e4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006e7:	8b 00                	mov    (%eax),%eax
  8006e9:	3d ff 00 00 00       	cmp    $0xff,%eax
  8006ee:	75 30                	jne    800720 <putch+0x5c>
		sys_cputs(b->buf, b->idx, printProgName, curTextClr);
  8006f0:	8b 15 18 c1 81 00    	mov    0x81c118,%edx
  8006f6:	a0 44 40 80 00       	mov    0x804044,%al
  8006fb:	0f b6 c0             	movzbl %al,%eax
  8006fe:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800701:	8b 09                	mov    (%ecx),%ecx
  800703:	89 cb                	mov    %ecx,%ebx
  800705:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800708:	83 c1 08             	add    $0x8,%ecx
  80070b:	52                   	push   %edx
  80070c:	50                   	push   %eax
  80070d:	53                   	push   %ebx
  80070e:	51                   	push   %ecx
  80070f:	e8 57 11 00 00       	call   80186b <sys_cputs>
  800714:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800717:	8b 45 0c             	mov    0xc(%ebp),%eax
  80071a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800720:	8b 45 0c             	mov    0xc(%ebp),%eax
  800723:	8b 40 04             	mov    0x4(%eax),%eax
  800726:	8d 50 01             	lea    0x1(%eax),%edx
  800729:	8b 45 0c             	mov    0xc(%ebp),%eax
  80072c:	89 50 04             	mov    %edx,0x4(%eax)
}
  80072f:	90                   	nop
  800730:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800733:	c9                   	leave  
  800734:	c3                   	ret    

00800735 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800735:	55                   	push   %ebp
  800736:	89 e5                	mov    %esp,%ebp
  800738:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  80073e:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800745:	00 00 00 
	b.cnt = 0;
  800748:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  80074f:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800752:	ff 75 0c             	pushl  0xc(%ebp)
  800755:	ff 75 08             	pushl  0x8(%ebp)
  800758:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80075e:	50                   	push   %eax
  80075f:	68 c4 06 80 00       	push   $0x8006c4
  800764:	e8 5a 02 00 00       	call   8009c3 <vprintfmt>
  800769:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName, curTextClr);
  80076c:	8b 15 18 c1 81 00    	mov    0x81c118,%edx
  800772:	a0 44 40 80 00       	mov    0x804044,%al
  800777:	0f b6 c0             	movzbl %al,%eax
  80077a:	8b 8d f0 fe ff ff    	mov    -0x110(%ebp),%ecx
  800780:	52                   	push   %edx
  800781:	50                   	push   %eax
  800782:	51                   	push   %ecx
  800783:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800789:	83 c0 08             	add    $0x8,%eax
  80078c:	50                   	push   %eax
  80078d:	e8 d9 10 00 00       	call   80186b <sys_cputs>
  800792:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800795:	c6 05 44 40 80 00 00 	movb   $0x0,0x804044
	return b.cnt;
  80079c:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  8007a2:	c9                   	leave  
  8007a3:	c3                   	ret    

008007a4 <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  8007a4:	55                   	push   %ebp
  8007a5:	89 e5                	mov    %esp,%ebp
  8007a7:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  8007aa:	c6 05 44 40 80 00 01 	movb   $0x1,0x804044
	va_start(ap, fmt);
  8007b1:	8d 45 0c             	lea    0xc(%ebp),%eax
  8007b4:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8007b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8007ba:	83 ec 08             	sub    $0x8,%esp
  8007bd:	ff 75 f4             	pushl  -0xc(%ebp)
  8007c0:	50                   	push   %eax
  8007c1:	e8 6f ff ff ff       	call   800735 <vcprintf>
  8007c6:	83 c4 10             	add    $0x10,%esp
  8007c9:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  8007cc:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8007cf:	c9                   	leave  
  8007d0:	c3                   	ret    

008007d1 <cprintf_colored>:

// *************** This text coloring feature is implemented by *************
// ********** Abd-Alrahman Zedan From Team Frozen-Bytes - FCIS'24-25 ********
int cprintf_colored(int textClr, const char *fmt, ...) {
  8007d1:	55                   	push   %ebp
  8007d2:	89 e5                	mov    %esp,%ebp
  8007d4:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  8007d7:	c6 05 44 40 80 00 01 	movb   $0x1,0x804044
	curTextClr = (textClr << 8) ; //set text color by the given value
  8007de:	8b 45 08             	mov    0x8(%ebp),%eax
  8007e1:	c1 e0 08             	shl    $0x8,%eax
  8007e4:	a3 18 c1 81 00       	mov    %eax,0x81c118
	va_start(ap, fmt);
  8007e9:	8d 45 0c             	lea    0xc(%ebp),%eax
  8007ec:	83 c0 04             	add    $0x4,%eax
  8007ef:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8007f2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8007f5:	83 ec 08             	sub    $0x8,%esp
  8007f8:	ff 75 f4             	pushl  -0xc(%ebp)
  8007fb:	50                   	push   %eax
  8007fc:	e8 34 ff ff ff       	call   800735 <vcprintf>
  800801:	83 c4 10             	add    $0x10,%esp
  800804:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);
	curTextClr = TEXT_DEFAULT_CLR; //restore default color
  800807:	c7 05 18 c1 81 00 00 	movl   $0x700,0x81c118
  80080e:	07 00 00 

	return cnt;
  800811:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800814:	c9                   	leave  
  800815:	c3                   	ret    

00800816 <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  800816:	55                   	push   %ebp
  800817:	89 e5                	mov    %esp,%ebp
  800819:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  80081c:	e8 8e 10 00 00       	call   8018af <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  800821:	8d 45 0c             	lea    0xc(%ebp),%eax
  800824:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  800827:	8b 45 08             	mov    0x8(%ebp),%eax
  80082a:	83 ec 08             	sub    $0x8,%esp
  80082d:	ff 75 f4             	pushl  -0xc(%ebp)
  800830:	50                   	push   %eax
  800831:	e8 ff fe ff ff       	call   800735 <vcprintf>
  800836:	83 c4 10             	add    $0x10,%esp
  800839:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  80083c:	e8 88 10 00 00       	call   8018c9 <sys_unlock_cons>
	return cnt;
  800841:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800844:	c9                   	leave  
  800845:	c3                   	ret    

00800846 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800846:	55                   	push   %ebp
  800847:	89 e5                	mov    %esp,%ebp
  800849:	53                   	push   %ebx
  80084a:	83 ec 14             	sub    $0x14,%esp
  80084d:	8b 45 10             	mov    0x10(%ebp),%eax
  800850:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800853:	8b 45 14             	mov    0x14(%ebp),%eax
  800856:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800859:	8b 45 18             	mov    0x18(%ebp),%eax
  80085c:	ba 00 00 00 00       	mov    $0x0,%edx
  800861:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800864:	77 55                	ja     8008bb <printnum+0x75>
  800866:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800869:	72 05                	jb     800870 <printnum+0x2a>
  80086b:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80086e:	77 4b                	ja     8008bb <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800870:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800873:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800876:	8b 45 18             	mov    0x18(%ebp),%eax
  800879:	ba 00 00 00 00       	mov    $0x0,%edx
  80087e:	52                   	push   %edx
  80087f:	50                   	push   %eax
  800880:	ff 75 f4             	pushl  -0xc(%ebp)
  800883:	ff 75 f0             	pushl  -0x10(%ebp)
  800886:	e8 69 22 00 00       	call   802af4 <__udivdi3>
  80088b:	83 c4 10             	add    $0x10,%esp
  80088e:	83 ec 04             	sub    $0x4,%esp
  800891:	ff 75 20             	pushl  0x20(%ebp)
  800894:	53                   	push   %ebx
  800895:	ff 75 18             	pushl  0x18(%ebp)
  800898:	52                   	push   %edx
  800899:	50                   	push   %eax
  80089a:	ff 75 0c             	pushl  0xc(%ebp)
  80089d:	ff 75 08             	pushl  0x8(%ebp)
  8008a0:	e8 a1 ff ff ff       	call   800846 <printnum>
  8008a5:	83 c4 20             	add    $0x20,%esp
  8008a8:	eb 1a                	jmp    8008c4 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8008aa:	83 ec 08             	sub    $0x8,%esp
  8008ad:	ff 75 0c             	pushl  0xc(%ebp)
  8008b0:	ff 75 20             	pushl  0x20(%ebp)
  8008b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8008b6:	ff d0                	call   *%eax
  8008b8:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8008bb:	ff 4d 1c             	decl   0x1c(%ebp)
  8008be:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  8008c2:	7f e6                	jg     8008aa <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8008c4:	8b 4d 18             	mov    0x18(%ebp),%ecx
  8008c7:	bb 00 00 00 00       	mov    $0x0,%ebx
  8008cc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8008cf:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8008d2:	53                   	push   %ebx
  8008d3:	51                   	push   %ecx
  8008d4:	52                   	push   %edx
  8008d5:	50                   	push   %eax
  8008d6:	e8 29 23 00 00       	call   802c04 <__umoddi3>
  8008db:	83 c4 10             	add    $0x10,%esp
  8008de:	05 94 31 80 00       	add    $0x803194,%eax
  8008e3:	8a 00                	mov    (%eax),%al
  8008e5:	0f be c0             	movsbl %al,%eax
  8008e8:	83 ec 08             	sub    $0x8,%esp
  8008eb:	ff 75 0c             	pushl  0xc(%ebp)
  8008ee:	50                   	push   %eax
  8008ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8008f2:	ff d0                	call   *%eax
  8008f4:	83 c4 10             	add    $0x10,%esp
}
  8008f7:	90                   	nop
  8008f8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8008fb:	c9                   	leave  
  8008fc:	c3                   	ret    

008008fd <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8008fd:	55                   	push   %ebp
  8008fe:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800900:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800904:	7e 1c                	jle    800922 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800906:	8b 45 08             	mov    0x8(%ebp),%eax
  800909:	8b 00                	mov    (%eax),%eax
  80090b:	8d 50 08             	lea    0x8(%eax),%edx
  80090e:	8b 45 08             	mov    0x8(%ebp),%eax
  800911:	89 10                	mov    %edx,(%eax)
  800913:	8b 45 08             	mov    0x8(%ebp),%eax
  800916:	8b 00                	mov    (%eax),%eax
  800918:	83 e8 08             	sub    $0x8,%eax
  80091b:	8b 50 04             	mov    0x4(%eax),%edx
  80091e:	8b 00                	mov    (%eax),%eax
  800920:	eb 40                	jmp    800962 <getuint+0x65>
	else if (lflag)
  800922:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800926:	74 1e                	je     800946 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800928:	8b 45 08             	mov    0x8(%ebp),%eax
  80092b:	8b 00                	mov    (%eax),%eax
  80092d:	8d 50 04             	lea    0x4(%eax),%edx
  800930:	8b 45 08             	mov    0x8(%ebp),%eax
  800933:	89 10                	mov    %edx,(%eax)
  800935:	8b 45 08             	mov    0x8(%ebp),%eax
  800938:	8b 00                	mov    (%eax),%eax
  80093a:	83 e8 04             	sub    $0x4,%eax
  80093d:	8b 00                	mov    (%eax),%eax
  80093f:	ba 00 00 00 00       	mov    $0x0,%edx
  800944:	eb 1c                	jmp    800962 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800946:	8b 45 08             	mov    0x8(%ebp),%eax
  800949:	8b 00                	mov    (%eax),%eax
  80094b:	8d 50 04             	lea    0x4(%eax),%edx
  80094e:	8b 45 08             	mov    0x8(%ebp),%eax
  800951:	89 10                	mov    %edx,(%eax)
  800953:	8b 45 08             	mov    0x8(%ebp),%eax
  800956:	8b 00                	mov    (%eax),%eax
  800958:	83 e8 04             	sub    $0x4,%eax
  80095b:	8b 00                	mov    (%eax),%eax
  80095d:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800962:	5d                   	pop    %ebp
  800963:	c3                   	ret    

00800964 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800964:	55                   	push   %ebp
  800965:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800967:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  80096b:	7e 1c                	jle    800989 <getint+0x25>
		return va_arg(*ap, long long);
  80096d:	8b 45 08             	mov    0x8(%ebp),%eax
  800970:	8b 00                	mov    (%eax),%eax
  800972:	8d 50 08             	lea    0x8(%eax),%edx
  800975:	8b 45 08             	mov    0x8(%ebp),%eax
  800978:	89 10                	mov    %edx,(%eax)
  80097a:	8b 45 08             	mov    0x8(%ebp),%eax
  80097d:	8b 00                	mov    (%eax),%eax
  80097f:	83 e8 08             	sub    $0x8,%eax
  800982:	8b 50 04             	mov    0x4(%eax),%edx
  800985:	8b 00                	mov    (%eax),%eax
  800987:	eb 38                	jmp    8009c1 <getint+0x5d>
	else if (lflag)
  800989:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80098d:	74 1a                	je     8009a9 <getint+0x45>
		return va_arg(*ap, long);
  80098f:	8b 45 08             	mov    0x8(%ebp),%eax
  800992:	8b 00                	mov    (%eax),%eax
  800994:	8d 50 04             	lea    0x4(%eax),%edx
  800997:	8b 45 08             	mov    0x8(%ebp),%eax
  80099a:	89 10                	mov    %edx,(%eax)
  80099c:	8b 45 08             	mov    0x8(%ebp),%eax
  80099f:	8b 00                	mov    (%eax),%eax
  8009a1:	83 e8 04             	sub    $0x4,%eax
  8009a4:	8b 00                	mov    (%eax),%eax
  8009a6:	99                   	cltd   
  8009a7:	eb 18                	jmp    8009c1 <getint+0x5d>
	else
		return va_arg(*ap, int);
  8009a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8009ac:	8b 00                	mov    (%eax),%eax
  8009ae:	8d 50 04             	lea    0x4(%eax),%edx
  8009b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8009b4:	89 10                	mov    %edx,(%eax)
  8009b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8009b9:	8b 00                	mov    (%eax),%eax
  8009bb:	83 e8 04             	sub    $0x4,%eax
  8009be:	8b 00                	mov    (%eax),%eax
  8009c0:	99                   	cltd   
}
  8009c1:	5d                   	pop    %ebp
  8009c2:	c3                   	ret    

008009c3 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8009c3:	55                   	push   %ebp
  8009c4:	89 e5                	mov    %esp,%ebp
  8009c6:	56                   	push   %esi
  8009c7:	53                   	push   %ebx
  8009c8:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8009cb:	eb 17                	jmp    8009e4 <vprintfmt+0x21>
			if (ch == '\0')
  8009cd:	85 db                	test   %ebx,%ebx
  8009cf:	0f 84 c1 03 00 00    	je     800d96 <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  8009d5:	83 ec 08             	sub    $0x8,%esp
  8009d8:	ff 75 0c             	pushl  0xc(%ebp)
  8009db:	53                   	push   %ebx
  8009dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8009df:	ff d0                	call   *%eax
  8009e1:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8009e4:	8b 45 10             	mov    0x10(%ebp),%eax
  8009e7:	8d 50 01             	lea    0x1(%eax),%edx
  8009ea:	89 55 10             	mov    %edx,0x10(%ebp)
  8009ed:	8a 00                	mov    (%eax),%al
  8009ef:	0f b6 d8             	movzbl %al,%ebx
  8009f2:	83 fb 25             	cmp    $0x25,%ebx
  8009f5:	75 d6                	jne    8009cd <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  8009f7:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  8009fb:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800a02:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800a09:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800a10:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800a17:	8b 45 10             	mov    0x10(%ebp),%eax
  800a1a:	8d 50 01             	lea    0x1(%eax),%edx
  800a1d:	89 55 10             	mov    %edx,0x10(%ebp)
  800a20:	8a 00                	mov    (%eax),%al
  800a22:	0f b6 d8             	movzbl %al,%ebx
  800a25:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800a28:	83 f8 5b             	cmp    $0x5b,%eax
  800a2b:	0f 87 3d 03 00 00    	ja     800d6e <vprintfmt+0x3ab>
  800a31:	8b 04 85 b8 31 80 00 	mov    0x8031b8(,%eax,4),%eax
  800a38:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800a3a:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800a3e:	eb d7                	jmp    800a17 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800a40:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800a44:	eb d1                	jmp    800a17 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800a46:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800a4d:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800a50:	89 d0                	mov    %edx,%eax
  800a52:	c1 e0 02             	shl    $0x2,%eax
  800a55:	01 d0                	add    %edx,%eax
  800a57:	01 c0                	add    %eax,%eax
  800a59:	01 d8                	add    %ebx,%eax
  800a5b:	83 e8 30             	sub    $0x30,%eax
  800a5e:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800a61:	8b 45 10             	mov    0x10(%ebp),%eax
  800a64:	8a 00                	mov    (%eax),%al
  800a66:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800a69:	83 fb 2f             	cmp    $0x2f,%ebx
  800a6c:	7e 3e                	jle    800aac <vprintfmt+0xe9>
  800a6e:	83 fb 39             	cmp    $0x39,%ebx
  800a71:	7f 39                	jg     800aac <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800a73:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800a76:	eb d5                	jmp    800a4d <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800a78:	8b 45 14             	mov    0x14(%ebp),%eax
  800a7b:	83 c0 04             	add    $0x4,%eax
  800a7e:	89 45 14             	mov    %eax,0x14(%ebp)
  800a81:	8b 45 14             	mov    0x14(%ebp),%eax
  800a84:	83 e8 04             	sub    $0x4,%eax
  800a87:	8b 00                	mov    (%eax),%eax
  800a89:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800a8c:	eb 1f                	jmp    800aad <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800a8e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a92:	79 83                	jns    800a17 <vprintfmt+0x54>
				width = 0;
  800a94:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800a9b:	e9 77 ff ff ff       	jmp    800a17 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800aa0:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800aa7:	e9 6b ff ff ff       	jmp    800a17 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800aac:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800aad:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800ab1:	0f 89 60 ff ff ff    	jns    800a17 <vprintfmt+0x54>
				width = precision, precision = -1;
  800ab7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800aba:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800abd:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800ac4:	e9 4e ff ff ff       	jmp    800a17 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800ac9:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800acc:	e9 46 ff ff ff       	jmp    800a17 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800ad1:	8b 45 14             	mov    0x14(%ebp),%eax
  800ad4:	83 c0 04             	add    $0x4,%eax
  800ad7:	89 45 14             	mov    %eax,0x14(%ebp)
  800ada:	8b 45 14             	mov    0x14(%ebp),%eax
  800add:	83 e8 04             	sub    $0x4,%eax
  800ae0:	8b 00                	mov    (%eax),%eax
  800ae2:	83 ec 08             	sub    $0x8,%esp
  800ae5:	ff 75 0c             	pushl  0xc(%ebp)
  800ae8:	50                   	push   %eax
  800ae9:	8b 45 08             	mov    0x8(%ebp),%eax
  800aec:	ff d0                	call   *%eax
  800aee:	83 c4 10             	add    $0x10,%esp
			break;
  800af1:	e9 9b 02 00 00       	jmp    800d91 <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800af6:	8b 45 14             	mov    0x14(%ebp),%eax
  800af9:	83 c0 04             	add    $0x4,%eax
  800afc:	89 45 14             	mov    %eax,0x14(%ebp)
  800aff:	8b 45 14             	mov    0x14(%ebp),%eax
  800b02:	83 e8 04             	sub    $0x4,%eax
  800b05:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800b07:	85 db                	test   %ebx,%ebx
  800b09:	79 02                	jns    800b0d <vprintfmt+0x14a>
				err = -err;
  800b0b:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800b0d:	83 fb 64             	cmp    $0x64,%ebx
  800b10:	7f 0b                	jg     800b1d <vprintfmt+0x15a>
  800b12:	8b 34 9d 00 30 80 00 	mov    0x803000(,%ebx,4),%esi
  800b19:	85 f6                	test   %esi,%esi
  800b1b:	75 19                	jne    800b36 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800b1d:	53                   	push   %ebx
  800b1e:	68 a5 31 80 00       	push   $0x8031a5
  800b23:	ff 75 0c             	pushl  0xc(%ebp)
  800b26:	ff 75 08             	pushl  0x8(%ebp)
  800b29:	e8 70 02 00 00       	call   800d9e <printfmt>
  800b2e:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800b31:	e9 5b 02 00 00       	jmp    800d91 <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800b36:	56                   	push   %esi
  800b37:	68 ae 31 80 00       	push   $0x8031ae
  800b3c:	ff 75 0c             	pushl  0xc(%ebp)
  800b3f:	ff 75 08             	pushl  0x8(%ebp)
  800b42:	e8 57 02 00 00       	call   800d9e <printfmt>
  800b47:	83 c4 10             	add    $0x10,%esp
			break;
  800b4a:	e9 42 02 00 00       	jmp    800d91 <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800b4f:	8b 45 14             	mov    0x14(%ebp),%eax
  800b52:	83 c0 04             	add    $0x4,%eax
  800b55:	89 45 14             	mov    %eax,0x14(%ebp)
  800b58:	8b 45 14             	mov    0x14(%ebp),%eax
  800b5b:	83 e8 04             	sub    $0x4,%eax
  800b5e:	8b 30                	mov    (%eax),%esi
  800b60:	85 f6                	test   %esi,%esi
  800b62:	75 05                	jne    800b69 <vprintfmt+0x1a6>
				p = "(null)";
  800b64:	be b1 31 80 00       	mov    $0x8031b1,%esi
			if (width > 0 && padc != '-')
  800b69:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800b6d:	7e 6d                	jle    800bdc <vprintfmt+0x219>
  800b6f:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800b73:	74 67                	je     800bdc <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800b75:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800b78:	83 ec 08             	sub    $0x8,%esp
  800b7b:	50                   	push   %eax
  800b7c:	56                   	push   %esi
  800b7d:	e8 1e 03 00 00       	call   800ea0 <strnlen>
  800b82:	83 c4 10             	add    $0x10,%esp
  800b85:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800b88:	eb 16                	jmp    800ba0 <vprintfmt+0x1dd>
					putch(padc, putdat);
  800b8a:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800b8e:	83 ec 08             	sub    $0x8,%esp
  800b91:	ff 75 0c             	pushl  0xc(%ebp)
  800b94:	50                   	push   %eax
  800b95:	8b 45 08             	mov    0x8(%ebp),%eax
  800b98:	ff d0                	call   *%eax
  800b9a:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800b9d:	ff 4d e4             	decl   -0x1c(%ebp)
  800ba0:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800ba4:	7f e4                	jg     800b8a <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800ba6:	eb 34                	jmp    800bdc <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800ba8:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800bac:	74 1c                	je     800bca <vprintfmt+0x207>
  800bae:	83 fb 1f             	cmp    $0x1f,%ebx
  800bb1:	7e 05                	jle    800bb8 <vprintfmt+0x1f5>
  800bb3:	83 fb 7e             	cmp    $0x7e,%ebx
  800bb6:	7e 12                	jle    800bca <vprintfmt+0x207>
					putch('?', putdat);
  800bb8:	83 ec 08             	sub    $0x8,%esp
  800bbb:	ff 75 0c             	pushl  0xc(%ebp)
  800bbe:	6a 3f                	push   $0x3f
  800bc0:	8b 45 08             	mov    0x8(%ebp),%eax
  800bc3:	ff d0                	call   *%eax
  800bc5:	83 c4 10             	add    $0x10,%esp
  800bc8:	eb 0f                	jmp    800bd9 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800bca:	83 ec 08             	sub    $0x8,%esp
  800bcd:	ff 75 0c             	pushl  0xc(%ebp)
  800bd0:	53                   	push   %ebx
  800bd1:	8b 45 08             	mov    0x8(%ebp),%eax
  800bd4:	ff d0                	call   *%eax
  800bd6:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800bd9:	ff 4d e4             	decl   -0x1c(%ebp)
  800bdc:	89 f0                	mov    %esi,%eax
  800bde:	8d 70 01             	lea    0x1(%eax),%esi
  800be1:	8a 00                	mov    (%eax),%al
  800be3:	0f be d8             	movsbl %al,%ebx
  800be6:	85 db                	test   %ebx,%ebx
  800be8:	74 24                	je     800c0e <vprintfmt+0x24b>
  800bea:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800bee:	78 b8                	js     800ba8 <vprintfmt+0x1e5>
  800bf0:	ff 4d e0             	decl   -0x20(%ebp)
  800bf3:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800bf7:	79 af                	jns    800ba8 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800bf9:	eb 13                	jmp    800c0e <vprintfmt+0x24b>
				putch(' ', putdat);
  800bfb:	83 ec 08             	sub    $0x8,%esp
  800bfe:	ff 75 0c             	pushl  0xc(%ebp)
  800c01:	6a 20                	push   $0x20
  800c03:	8b 45 08             	mov    0x8(%ebp),%eax
  800c06:	ff d0                	call   *%eax
  800c08:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800c0b:	ff 4d e4             	decl   -0x1c(%ebp)
  800c0e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800c12:	7f e7                	jg     800bfb <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800c14:	e9 78 01 00 00       	jmp    800d91 <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800c19:	83 ec 08             	sub    $0x8,%esp
  800c1c:	ff 75 e8             	pushl  -0x18(%ebp)
  800c1f:	8d 45 14             	lea    0x14(%ebp),%eax
  800c22:	50                   	push   %eax
  800c23:	e8 3c fd ff ff       	call   800964 <getint>
  800c28:	83 c4 10             	add    $0x10,%esp
  800c2b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c2e:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800c31:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800c34:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800c37:	85 d2                	test   %edx,%edx
  800c39:	79 23                	jns    800c5e <vprintfmt+0x29b>
				putch('-', putdat);
  800c3b:	83 ec 08             	sub    $0x8,%esp
  800c3e:	ff 75 0c             	pushl  0xc(%ebp)
  800c41:	6a 2d                	push   $0x2d
  800c43:	8b 45 08             	mov    0x8(%ebp),%eax
  800c46:	ff d0                	call   *%eax
  800c48:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800c4b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800c4e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800c51:	f7 d8                	neg    %eax
  800c53:	83 d2 00             	adc    $0x0,%edx
  800c56:	f7 da                	neg    %edx
  800c58:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c5b:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800c5e:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800c65:	e9 bc 00 00 00       	jmp    800d26 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800c6a:	83 ec 08             	sub    $0x8,%esp
  800c6d:	ff 75 e8             	pushl  -0x18(%ebp)
  800c70:	8d 45 14             	lea    0x14(%ebp),%eax
  800c73:	50                   	push   %eax
  800c74:	e8 84 fc ff ff       	call   8008fd <getuint>
  800c79:	83 c4 10             	add    $0x10,%esp
  800c7c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c7f:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800c82:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800c89:	e9 98 00 00 00       	jmp    800d26 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800c8e:	83 ec 08             	sub    $0x8,%esp
  800c91:	ff 75 0c             	pushl  0xc(%ebp)
  800c94:	6a 58                	push   $0x58
  800c96:	8b 45 08             	mov    0x8(%ebp),%eax
  800c99:	ff d0                	call   *%eax
  800c9b:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800c9e:	83 ec 08             	sub    $0x8,%esp
  800ca1:	ff 75 0c             	pushl  0xc(%ebp)
  800ca4:	6a 58                	push   $0x58
  800ca6:	8b 45 08             	mov    0x8(%ebp),%eax
  800ca9:	ff d0                	call   *%eax
  800cab:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800cae:	83 ec 08             	sub    $0x8,%esp
  800cb1:	ff 75 0c             	pushl  0xc(%ebp)
  800cb4:	6a 58                	push   $0x58
  800cb6:	8b 45 08             	mov    0x8(%ebp),%eax
  800cb9:	ff d0                	call   *%eax
  800cbb:	83 c4 10             	add    $0x10,%esp
			break;
  800cbe:	e9 ce 00 00 00       	jmp    800d91 <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  800cc3:	83 ec 08             	sub    $0x8,%esp
  800cc6:	ff 75 0c             	pushl  0xc(%ebp)
  800cc9:	6a 30                	push   $0x30
  800ccb:	8b 45 08             	mov    0x8(%ebp),%eax
  800cce:	ff d0                	call   *%eax
  800cd0:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800cd3:	83 ec 08             	sub    $0x8,%esp
  800cd6:	ff 75 0c             	pushl  0xc(%ebp)
  800cd9:	6a 78                	push   $0x78
  800cdb:	8b 45 08             	mov    0x8(%ebp),%eax
  800cde:	ff d0                	call   *%eax
  800ce0:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800ce3:	8b 45 14             	mov    0x14(%ebp),%eax
  800ce6:	83 c0 04             	add    $0x4,%eax
  800ce9:	89 45 14             	mov    %eax,0x14(%ebp)
  800cec:	8b 45 14             	mov    0x14(%ebp),%eax
  800cef:	83 e8 04             	sub    $0x4,%eax
  800cf2:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800cf4:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800cf7:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800cfe:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800d05:	eb 1f                	jmp    800d26 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800d07:	83 ec 08             	sub    $0x8,%esp
  800d0a:	ff 75 e8             	pushl  -0x18(%ebp)
  800d0d:	8d 45 14             	lea    0x14(%ebp),%eax
  800d10:	50                   	push   %eax
  800d11:	e8 e7 fb ff ff       	call   8008fd <getuint>
  800d16:	83 c4 10             	add    $0x10,%esp
  800d19:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800d1c:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800d1f:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800d26:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800d2a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800d2d:	83 ec 04             	sub    $0x4,%esp
  800d30:	52                   	push   %edx
  800d31:	ff 75 e4             	pushl  -0x1c(%ebp)
  800d34:	50                   	push   %eax
  800d35:	ff 75 f4             	pushl  -0xc(%ebp)
  800d38:	ff 75 f0             	pushl  -0x10(%ebp)
  800d3b:	ff 75 0c             	pushl  0xc(%ebp)
  800d3e:	ff 75 08             	pushl  0x8(%ebp)
  800d41:	e8 00 fb ff ff       	call   800846 <printnum>
  800d46:	83 c4 20             	add    $0x20,%esp
			break;
  800d49:	eb 46                	jmp    800d91 <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800d4b:	83 ec 08             	sub    $0x8,%esp
  800d4e:	ff 75 0c             	pushl  0xc(%ebp)
  800d51:	53                   	push   %ebx
  800d52:	8b 45 08             	mov    0x8(%ebp),%eax
  800d55:	ff d0                	call   *%eax
  800d57:	83 c4 10             	add    $0x10,%esp
			break;
  800d5a:	eb 35                	jmp    800d91 <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  800d5c:	c6 05 44 40 80 00 00 	movb   $0x0,0x804044
			break;
  800d63:	eb 2c                	jmp    800d91 <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  800d65:	c6 05 44 40 80 00 01 	movb   $0x1,0x804044
			break;
  800d6c:	eb 23                	jmp    800d91 <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800d6e:	83 ec 08             	sub    $0x8,%esp
  800d71:	ff 75 0c             	pushl  0xc(%ebp)
  800d74:	6a 25                	push   $0x25
  800d76:	8b 45 08             	mov    0x8(%ebp),%eax
  800d79:	ff d0                	call   *%eax
  800d7b:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800d7e:	ff 4d 10             	decl   0x10(%ebp)
  800d81:	eb 03                	jmp    800d86 <vprintfmt+0x3c3>
  800d83:	ff 4d 10             	decl   0x10(%ebp)
  800d86:	8b 45 10             	mov    0x10(%ebp),%eax
  800d89:	48                   	dec    %eax
  800d8a:	8a 00                	mov    (%eax),%al
  800d8c:	3c 25                	cmp    $0x25,%al
  800d8e:	75 f3                	jne    800d83 <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  800d90:	90                   	nop
		}
	}
  800d91:	e9 35 fc ff ff       	jmp    8009cb <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800d96:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800d97:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800d9a:	5b                   	pop    %ebx
  800d9b:	5e                   	pop    %esi
  800d9c:	5d                   	pop    %ebp
  800d9d:	c3                   	ret    

00800d9e <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800d9e:	55                   	push   %ebp
  800d9f:	89 e5                	mov    %esp,%ebp
  800da1:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800da4:	8d 45 10             	lea    0x10(%ebp),%eax
  800da7:	83 c0 04             	add    $0x4,%eax
  800daa:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800dad:	8b 45 10             	mov    0x10(%ebp),%eax
  800db0:	ff 75 f4             	pushl  -0xc(%ebp)
  800db3:	50                   	push   %eax
  800db4:	ff 75 0c             	pushl  0xc(%ebp)
  800db7:	ff 75 08             	pushl  0x8(%ebp)
  800dba:	e8 04 fc ff ff       	call   8009c3 <vprintfmt>
  800dbf:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800dc2:	90                   	nop
  800dc3:	c9                   	leave  
  800dc4:	c3                   	ret    

00800dc5 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800dc5:	55                   	push   %ebp
  800dc6:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800dc8:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dcb:	8b 40 08             	mov    0x8(%eax),%eax
  800dce:	8d 50 01             	lea    0x1(%eax),%edx
  800dd1:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dd4:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800dd7:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dda:	8b 10                	mov    (%eax),%edx
  800ddc:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ddf:	8b 40 04             	mov    0x4(%eax),%eax
  800de2:	39 c2                	cmp    %eax,%edx
  800de4:	73 12                	jae    800df8 <sprintputch+0x33>
		*b->buf++ = ch;
  800de6:	8b 45 0c             	mov    0xc(%ebp),%eax
  800de9:	8b 00                	mov    (%eax),%eax
  800deb:	8d 48 01             	lea    0x1(%eax),%ecx
  800dee:	8b 55 0c             	mov    0xc(%ebp),%edx
  800df1:	89 0a                	mov    %ecx,(%edx)
  800df3:	8b 55 08             	mov    0x8(%ebp),%edx
  800df6:	88 10                	mov    %dl,(%eax)
}
  800df8:	90                   	nop
  800df9:	5d                   	pop    %ebp
  800dfa:	c3                   	ret    

00800dfb <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800dfb:	55                   	push   %ebp
  800dfc:	89 e5                	mov    %esp,%ebp
  800dfe:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800e01:	8b 45 08             	mov    0x8(%ebp),%eax
  800e04:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800e07:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e0a:	8d 50 ff             	lea    -0x1(%eax),%edx
  800e0d:	8b 45 08             	mov    0x8(%ebp),%eax
  800e10:	01 d0                	add    %edx,%eax
  800e12:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800e15:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800e1c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800e20:	74 06                	je     800e28 <vsnprintf+0x2d>
  800e22:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800e26:	7f 07                	jg     800e2f <vsnprintf+0x34>
		return -E_INVAL;
  800e28:	b8 03 00 00 00       	mov    $0x3,%eax
  800e2d:	eb 20                	jmp    800e4f <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800e2f:	ff 75 14             	pushl  0x14(%ebp)
  800e32:	ff 75 10             	pushl  0x10(%ebp)
  800e35:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800e38:	50                   	push   %eax
  800e39:	68 c5 0d 80 00       	push   $0x800dc5
  800e3e:	e8 80 fb ff ff       	call   8009c3 <vprintfmt>
  800e43:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800e46:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800e49:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800e4c:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800e4f:	c9                   	leave  
  800e50:	c3                   	ret    

00800e51 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800e51:	55                   	push   %ebp
  800e52:	89 e5                	mov    %esp,%ebp
  800e54:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800e57:	8d 45 10             	lea    0x10(%ebp),%eax
  800e5a:	83 c0 04             	add    $0x4,%eax
  800e5d:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800e60:	8b 45 10             	mov    0x10(%ebp),%eax
  800e63:	ff 75 f4             	pushl  -0xc(%ebp)
  800e66:	50                   	push   %eax
  800e67:	ff 75 0c             	pushl  0xc(%ebp)
  800e6a:	ff 75 08             	pushl  0x8(%ebp)
  800e6d:	e8 89 ff ff ff       	call   800dfb <vsnprintf>
  800e72:	83 c4 10             	add    $0x10,%esp
  800e75:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800e78:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800e7b:	c9                   	leave  
  800e7c:	c3                   	ret    

00800e7d <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800e7d:	55                   	push   %ebp
  800e7e:	89 e5                	mov    %esp,%ebp
  800e80:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800e83:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800e8a:	eb 06                	jmp    800e92 <strlen+0x15>
		n++;
  800e8c:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800e8f:	ff 45 08             	incl   0x8(%ebp)
  800e92:	8b 45 08             	mov    0x8(%ebp),%eax
  800e95:	8a 00                	mov    (%eax),%al
  800e97:	84 c0                	test   %al,%al
  800e99:	75 f1                	jne    800e8c <strlen+0xf>
		n++;
	return n;
  800e9b:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800e9e:	c9                   	leave  
  800e9f:	c3                   	ret    

00800ea0 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800ea0:	55                   	push   %ebp
  800ea1:	89 e5                	mov    %esp,%ebp
  800ea3:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800ea6:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800ead:	eb 09                	jmp    800eb8 <strnlen+0x18>
		n++;
  800eaf:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800eb2:	ff 45 08             	incl   0x8(%ebp)
  800eb5:	ff 4d 0c             	decl   0xc(%ebp)
  800eb8:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800ebc:	74 09                	je     800ec7 <strnlen+0x27>
  800ebe:	8b 45 08             	mov    0x8(%ebp),%eax
  800ec1:	8a 00                	mov    (%eax),%al
  800ec3:	84 c0                	test   %al,%al
  800ec5:	75 e8                	jne    800eaf <strnlen+0xf>
		n++;
	return n;
  800ec7:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800eca:	c9                   	leave  
  800ecb:	c3                   	ret    

00800ecc <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800ecc:	55                   	push   %ebp
  800ecd:	89 e5                	mov    %esp,%ebp
  800ecf:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800ed2:	8b 45 08             	mov    0x8(%ebp),%eax
  800ed5:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800ed8:	90                   	nop
  800ed9:	8b 45 08             	mov    0x8(%ebp),%eax
  800edc:	8d 50 01             	lea    0x1(%eax),%edx
  800edf:	89 55 08             	mov    %edx,0x8(%ebp)
  800ee2:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ee5:	8d 4a 01             	lea    0x1(%edx),%ecx
  800ee8:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800eeb:	8a 12                	mov    (%edx),%dl
  800eed:	88 10                	mov    %dl,(%eax)
  800eef:	8a 00                	mov    (%eax),%al
  800ef1:	84 c0                	test   %al,%al
  800ef3:	75 e4                	jne    800ed9 <strcpy+0xd>
		/* do nothing */;
	return ret;
  800ef5:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800ef8:	c9                   	leave  
  800ef9:	c3                   	ret    

00800efa <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800efa:	55                   	push   %ebp
  800efb:	89 e5                	mov    %esp,%ebp
  800efd:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800f00:	8b 45 08             	mov    0x8(%ebp),%eax
  800f03:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800f06:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800f0d:	eb 1f                	jmp    800f2e <strncpy+0x34>
		*dst++ = *src;
  800f0f:	8b 45 08             	mov    0x8(%ebp),%eax
  800f12:	8d 50 01             	lea    0x1(%eax),%edx
  800f15:	89 55 08             	mov    %edx,0x8(%ebp)
  800f18:	8b 55 0c             	mov    0xc(%ebp),%edx
  800f1b:	8a 12                	mov    (%edx),%dl
  800f1d:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800f1f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f22:	8a 00                	mov    (%eax),%al
  800f24:	84 c0                	test   %al,%al
  800f26:	74 03                	je     800f2b <strncpy+0x31>
			src++;
  800f28:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800f2b:	ff 45 fc             	incl   -0x4(%ebp)
  800f2e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f31:	3b 45 10             	cmp    0x10(%ebp),%eax
  800f34:	72 d9                	jb     800f0f <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800f36:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800f39:	c9                   	leave  
  800f3a:	c3                   	ret    

00800f3b <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800f3b:	55                   	push   %ebp
  800f3c:	89 e5                	mov    %esp,%ebp
  800f3e:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800f41:	8b 45 08             	mov    0x8(%ebp),%eax
  800f44:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800f47:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f4b:	74 30                	je     800f7d <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800f4d:	eb 16                	jmp    800f65 <strlcpy+0x2a>
			*dst++ = *src++;
  800f4f:	8b 45 08             	mov    0x8(%ebp),%eax
  800f52:	8d 50 01             	lea    0x1(%eax),%edx
  800f55:	89 55 08             	mov    %edx,0x8(%ebp)
  800f58:	8b 55 0c             	mov    0xc(%ebp),%edx
  800f5b:	8d 4a 01             	lea    0x1(%edx),%ecx
  800f5e:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800f61:	8a 12                	mov    (%edx),%dl
  800f63:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800f65:	ff 4d 10             	decl   0x10(%ebp)
  800f68:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f6c:	74 09                	je     800f77 <strlcpy+0x3c>
  800f6e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f71:	8a 00                	mov    (%eax),%al
  800f73:	84 c0                	test   %al,%al
  800f75:	75 d8                	jne    800f4f <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800f77:	8b 45 08             	mov    0x8(%ebp),%eax
  800f7a:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800f7d:	8b 55 08             	mov    0x8(%ebp),%edx
  800f80:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f83:	29 c2                	sub    %eax,%edx
  800f85:	89 d0                	mov    %edx,%eax
}
  800f87:	c9                   	leave  
  800f88:	c3                   	ret    

00800f89 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800f89:	55                   	push   %ebp
  800f8a:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800f8c:	eb 06                	jmp    800f94 <strcmp+0xb>
		p++, q++;
  800f8e:	ff 45 08             	incl   0x8(%ebp)
  800f91:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800f94:	8b 45 08             	mov    0x8(%ebp),%eax
  800f97:	8a 00                	mov    (%eax),%al
  800f99:	84 c0                	test   %al,%al
  800f9b:	74 0e                	je     800fab <strcmp+0x22>
  800f9d:	8b 45 08             	mov    0x8(%ebp),%eax
  800fa0:	8a 10                	mov    (%eax),%dl
  800fa2:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fa5:	8a 00                	mov    (%eax),%al
  800fa7:	38 c2                	cmp    %al,%dl
  800fa9:	74 e3                	je     800f8e <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800fab:	8b 45 08             	mov    0x8(%ebp),%eax
  800fae:	8a 00                	mov    (%eax),%al
  800fb0:	0f b6 d0             	movzbl %al,%edx
  800fb3:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fb6:	8a 00                	mov    (%eax),%al
  800fb8:	0f b6 c0             	movzbl %al,%eax
  800fbb:	29 c2                	sub    %eax,%edx
  800fbd:	89 d0                	mov    %edx,%eax
}
  800fbf:	5d                   	pop    %ebp
  800fc0:	c3                   	ret    

00800fc1 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800fc1:	55                   	push   %ebp
  800fc2:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800fc4:	eb 09                	jmp    800fcf <strncmp+0xe>
		n--, p++, q++;
  800fc6:	ff 4d 10             	decl   0x10(%ebp)
  800fc9:	ff 45 08             	incl   0x8(%ebp)
  800fcc:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800fcf:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800fd3:	74 17                	je     800fec <strncmp+0x2b>
  800fd5:	8b 45 08             	mov    0x8(%ebp),%eax
  800fd8:	8a 00                	mov    (%eax),%al
  800fda:	84 c0                	test   %al,%al
  800fdc:	74 0e                	je     800fec <strncmp+0x2b>
  800fde:	8b 45 08             	mov    0x8(%ebp),%eax
  800fe1:	8a 10                	mov    (%eax),%dl
  800fe3:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fe6:	8a 00                	mov    (%eax),%al
  800fe8:	38 c2                	cmp    %al,%dl
  800fea:	74 da                	je     800fc6 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800fec:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ff0:	75 07                	jne    800ff9 <strncmp+0x38>
		return 0;
  800ff2:	b8 00 00 00 00       	mov    $0x0,%eax
  800ff7:	eb 14                	jmp    80100d <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800ff9:	8b 45 08             	mov    0x8(%ebp),%eax
  800ffc:	8a 00                	mov    (%eax),%al
  800ffe:	0f b6 d0             	movzbl %al,%edx
  801001:	8b 45 0c             	mov    0xc(%ebp),%eax
  801004:	8a 00                	mov    (%eax),%al
  801006:	0f b6 c0             	movzbl %al,%eax
  801009:	29 c2                	sub    %eax,%edx
  80100b:	89 d0                	mov    %edx,%eax
}
  80100d:	5d                   	pop    %ebp
  80100e:	c3                   	ret    

0080100f <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  80100f:	55                   	push   %ebp
  801010:	89 e5                	mov    %esp,%ebp
  801012:	83 ec 04             	sub    $0x4,%esp
  801015:	8b 45 0c             	mov    0xc(%ebp),%eax
  801018:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  80101b:	eb 12                	jmp    80102f <strchr+0x20>
		if (*s == c)
  80101d:	8b 45 08             	mov    0x8(%ebp),%eax
  801020:	8a 00                	mov    (%eax),%al
  801022:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801025:	75 05                	jne    80102c <strchr+0x1d>
			return (char *) s;
  801027:	8b 45 08             	mov    0x8(%ebp),%eax
  80102a:	eb 11                	jmp    80103d <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  80102c:	ff 45 08             	incl   0x8(%ebp)
  80102f:	8b 45 08             	mov    0x8(%ebp),%eax
  801032:	8a 00                	mov    (%eax),%al
  801034:	84 c0                	test   %al,%al
  801036:	75 e5                	jne    80101d <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  801038:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80103d:	c9                   	leave  
  80103e:	c3                   	ret    

0080103f <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  80103f:	55                   	push   %ebp
  801040:	89 e5                	mov    %esp,%ebp
  801042:	83 ec 04             	sub    $0x4,%esp
  801045:	8b 45 0c             	mov    0xc(%ebp),%eax
  801048:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  80104b:	eb 0d                	jmp    80105a <strfind+0x1b>
		if (*s == c)
  80104d:	8b 45 08             	mov    0x8(%ebp),%eax
  801050:	8a 00                	mov    (%eax),%al
  801052:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801055:	74 0e                	je     801065 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  801057:	ff 45 08             	incl   0x8(%ebp)
  80105a:	8b 45 08             	mov    0x8(%ebp),%eax
  80105d:	8a 00                	mov    (%eax),%al
  80105f:	84 c0                	test   %al,%al
  801061:	75 ea                	jne    80104d <strfind+0xe>
  801063:	eb 01                	jmp    801066 <strfind+0x27>
		if (*s == c)
			break;
  801065:	90                   	nop
	return (char *) s;
  801066:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801069:	c9                   	leave  
  80106a:	c3                   	ret    

0080106b <memset>:

// *************** The faster implementation of memset & memcpy is implemented by *************
// ****************** Team80 (Yahia Khaled, Malek Ahmed et al) - FCIS'24-25 *******************
void *
memset(void *v, int c, uint32 n)
{
  80106b:	55                   	push   %ebp
  80106c:	89 e5                	mov    %esp,%ebp
  80106e:	83 ec 10             	sub    $0x10,%esp
//	m = n;
//	while (--m >= 0)
//		*p++ = c;

	/*Faster Implementation*/
	uint64* p64 = (uint64*)v;
  801071:	8b 45 08             	mov    0x8(%ebp),%eax
  801074:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if(n >= 8){
  801077:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  80107b:	76 63                	jbe    8010e0 <memset+0x75>
		uint64 data_block = c;
  80107d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801080:	99                   	cltd   
  801081:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801084:	89 55 f4             	mov    %edx,-0xc(%ebp)
		data_block |= data_block << 8;
  801087:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80108a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80108d:	0f a4 c2 08          	shld   $0x8,%eax,%edx
  801091:	c1 e0 08             	shl    $0x8,%eax
  801094:	09 45 f0             	or     %eax,-0x10(%ebp)
  801097:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 16;
  80109a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80109d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8010a0:	0f a4 c2 10          	shld   $0x10,%eax,%edx
  8010a4:	c1 e0 10             	shl    $0x10,%eax
  8010a7:	09 45 f0             	or     %eax,-0x10(%ebp)
  8010aa:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 32;
  8010ad:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8010b0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8010b3:	89 c2                	mov    %eax,%edx
  8010b5:	b8 00 00 00 00       	mov    $0x0,%eax
  8010ba:	09 45 f0             	or     %eax,-0x10(%ebp)
  8010bd:	09 55 f4             	or     %edx,-0xc(%ebp)

		while(n >= 8)
  8010c0:	eb 18                	jmp    8010da <memset+0x6f>
			*p64++ = data_block, n -= 8;
  8010c2:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8010c5:	8d 41 08             	lea    0x8(%ecx),%eax
  8010c8:	89 45 fc             	mov    %eax,-0x4(%ebp)
  8010cb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8010ce:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8010d1:	89 01                	mov    %eax,(%ecx)
  8010d3:	89 51 04             	mov    %edx,0x4(%ecx)
  8010d6:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
		uint64 data_block = c;
		data_block |= data_block << 8;
		data_block |= data_block << 16;
		data_block |= data_block << 32;

		while(n >= 8)
  8010da:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  8010de:	77 e2                	ja     8010c2 <memset+0x57>
			*p64++ = data_block, n -= 8;
	}

	if(n){
  8010e0:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8010e4:	74 23                	je     801109 <memset+0x9e>
		uint8* p8 = (uint8*)p64;
  8010e6:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8010e9:	89 45 f8             	mov    %eax,-0x8(%ebp)
		while (n-- > 0)
  8010ec:	eb 0e                	jmp    8010fc <memset+0x91>
			*p8++ = (uint8)c;
  8010ee:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010f1:	8d 50 01             	lea    0x1(%eax),%edx
  8010f4:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8010f7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8010fa:	88 10                	mov    %dl,(%eax)
			*p64++ = data_block, n -= 8;
	}

	if(n){
		uint8* p8 = (uint8*)p64;
		while (n-- > 0)
  8010fc:	8b 45 10             	mov    0x10(%ebp),%eax
  8010ff:	8d 50 ff             	lea    -0x1(%eax),%edx
  801102:	89 55 10             	mov    %edx,0x10(%ebp)
  801105:	85 c0                	test   %eax,%eax
  801107:	75 e5                	jne    8010ee <memset+0x83>
			*p8++ = (uint8)c;
	}

	return v;
  801109:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80110c:	c9                   	leave  
  80110d:	c3                   	ret    

0080110e <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  80110e:	55                   	push   %ebp
  80110f:	89 e5                	mov    %esp,%ebp
  801111:	83 ec 10             	sub    $0x10,%esp
	//	s = src;
	//	d = dst;
	//	while (n-- > 0)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
  801114:	8b 45 0c             	mov    0xc(%ebp),%eax
  801117:	89 45 fc             	mov    %eax,-0x4(%ebp)
	uint64* d64 = (uint64*)dst;
  80111a:	8b 45 08             	mov    0x8(%ebp),%eax
  80111d:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if(n >= 8){
  801120:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  801124:	76 24                	jbe    80114a <memcpy+0x3c>
		while(n >= 8){
  801126:	eb 1c                	jmp    801144 <memcpy+0x36>
			*d64 = *s64;
  801128:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80112b:	8b 50 04             	mov    0x4(%eax),%edx
  80112e:	8b 00                	mov    (%eax),%eax
  801130:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801133:	89 01                	mov    %eax,(%ecx)
  801135:	89 51 04             	mov    %edx,0x4(%ecx)
			n -= 8;
  801138:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
			++s64;
  80113c:	83 45 fc 08          	addl   $0x8,-0x4(%ebp)
			++d64;
  801140:	83 45 f8 08          	addl   $0x8,-0x8(%ebp)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
	uint64* d64 = (uint64*)dst;
	if(n >= 8){
		while(n >= 8){
  801144:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  801148:	77 de                	ja     801128 <memcpy+0x1a>
			++s64;
			++d64;
		}
	}

	if(n){
  80114a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80114e:	74 31                	je     801181 <memcpy+0x73>
		uint8* s8 = (uint8*)s64;
  801150:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801153:	89 45 f4             	mov    %eax,-0xc(%ebp)
		uint8* d8 = (uint8*)d64;
  801156:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801159:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (n-- > 0)
  80115c:	eb 16                	jmp    801174 <memcpy+0x66>
			*d8++ = *s8++;
  80115e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801161:	8d 50 01             	lea    0x1(%eax),%edx
  801164:	89 55 f0             	mov    %edx,-0x10(%ebp)
  801167:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80116a:	8d 4a 01             	lea    0x1(%edx),%ecx
  80116d:	89 4d f4             	mov    %ecx,-0xc(%ebp)
  801170:	8a 12                	mov    (%edx),%dl
  801172:	88 10                	mov    %dl,(%eax)
	}

	if(n){
		uint8* s8 = (uint8*)s64;
		uint8* d8 = (uint8*)d64;
		while (n-- > 0)
  801174:	8b 45 10             	mov    0x10(%ebp),%eax
  801177:	8d 50 ff             	lea    -0x1(%eax),%edx
  80117a:	89 55 10             	mov    %edx,0x10(%ebp)
  80117d:	85 c0                	test   %eax,%eax
  80117f:	75 dd                	jne    80115e <memcpy+0x50>
			*d8++ = *s8++;
	}
	return dst;
  801181:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801184:	c9                   	leave  
  801185:	c3                   	ret    

00801186 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  801186:	55                   	push   %ebp
  801187:	89 e5                	mov    %esp,%ebp
  801189:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  80118c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80118f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801192:	8b 45 08             	mov    0x8(%ebp),%eax
  801195:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  801198:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80119b:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  80119e:	73 50                	jae    8011f0 <memmove+0x6a>
  8011a0:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8011a3:	8b 45 10             	mov    0x10(%ebp),%eax
  8011a6:	01 d0                	add    %edx,%eax
  8011a8:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8011ab:	76 43                	jbe    8011f0 <memmove+0x6a>
		s += n;
  8011ad:	8b 45 10             	mov    0x10(%ebp),%eax
  8011b0:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  8011b3:	8b 45 10             	mov    0x10(%ebp),%eax
  8011b6:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  8011b9:	eb 10                	jmp    8011cb <memmove+0x45>
			*--d = *--s;
  8011bb:	ff 4d f8             	decl   -0x8(%ebp)
  8011be:	ff 4d fc             	decl   -0x4(%ebp)
  8011c1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8011c4:	8a 10                	mov    (%eax),%dl
  8011c6:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011c9:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  8011cb:	8b 45 10             	mov    0x10(%ebp),%eax
  8011ce:	8d 50 ff             	lea    -0x1(%eax),%edx
  8011d1:	89 55 10             	mov    %edx,0x10(%ebp)
  8011d4:	85 c0                	test   %eax,%eax
  8011d6:	75 e3                	jne    8011bb <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  8011d8:	eb 23                	jmp    8011fd <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  8011da:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011dd:	8d 50 01             	lea    0x1(%eax),%edx
  8011e0:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8011e3:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8011e6:	8d 4a 01             	lea    0x1(%edx),%ecx
  8011e9:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  8011ec:	8a 12                	mov    (%edx),%dl
  8011ee:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  8011f0:	8b 45 10             	mov    0x10(%ebp),%eax
  8011f3:	8d 50 ff             	lea    -0x1(%eax),%edx
  8011f6:	89 55 10             	mov    %edx,0x10(%ebp)
  8011f9:	85 c0                	test   %eax,%eax
  8011fb:	75 dd                	jne    8011da <memmove+0x54>
			*d++ = *s++;

	return dst;
  8011fd:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801200:	c9                   	leave  
  801201:	c3                   	ret    

00801202 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  801202:	55                   	push   %ebp
  801203:	89 e5                	mov    %esp,%ebp
  801205:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  801208:	8b 45 08             	mov    0x8(%ebp),%eax
  80120b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  80120e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801211:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  801214:	eb 2a                	jmp    801240 <memcmp+0x3e>
		if (*s1 != *s2)
  801216:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801219:	8a 10                	mov    (%eax),%dl
  80121b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80121e:	8a 00                	mov    (%eax),%al
  801220:	38 c2                	cmp    %al,%dl
  801222:	74 16                	je     80123a <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  801224:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801227:	8a 00                	mov    (%eax),%al
  801229:	0f b6 d0             	movzbl %al,%edx
  80122c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80122f:	8a 00                	mov    (%eax),%al
  801231:	0f b6 c0             	movzbl %al,%eax
  801234:	29 c2                	sub    %eax,%edx
  801236:	89 d0                	mov    %edx,%eax
  801238:	eb 18                	jmp    801252 <memcmp+0x50>
		s1++, s2++;
  80123a:	ff 45 fc             	incl   -0x4(%ebp)
  80123d:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  801240:	8b 45 10             	mov    0x10(%ebp),%eax
  801243:	8d 50 ff             	lea    -0x1(%eax),%edx
  801246:	89 55 10             	mov    %edx,0x10(%ebp)
  801249:	85 c0                	test   %eax,%eax
  80124b:	75 c9                	jne    801216 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  80124d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801252:	c9                   	leave  
  801253:	c3                   	ret    

00801254 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  801254:	55                   	push   %ebp
  801255:	89 e5                	mov    %esp,%ebp
  801257:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  80125a:	8b 55 08             	mov    0x8(%ebp),%edx
  80125d:	8b 45 10             	mov    0x10(%ebp),%eax
  801260:	01 d0                	add    %edx,%eax
  801262:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  801265:	eb 15                	jmp    80127c <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  801267:	8b 45 08             	mov    0x8(%ebp),%eax
  80126a:	8a 00                	mov    (%eax),%al
  80126c:	0f b6 d0             	movzbl %al,%edx
  80126f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801272:	0f b6 c0             	movzbl %al,%eax
  801275:	39 c2                	cmp    %eax,%edx
  801277:	74 0d                	je     801286 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801279:	ff 45 08             	incl   0x8(%ebp)
  80127c:	8b 45 08             	mov    0x8(%ebp),%eax
  80127f:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801282:	72 e3                	jb     801267 <memfind+0x13>
  801284:	eb 01                	jmp    801287 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  801286:	90                   	nop
	return (void *) s;
  801287:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80128a:	c9                   	leave  
  80128b:	c3                   	ret    

0080128c <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  80128c:	55                   	push   %ebp
  80128d:	89 e5                	mov    %esp,%ebp
  80128f:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  801292:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  801299:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8012a0:	eb 03                	jmp    8012a5 <strtol+0x19>
		s++;
  8012a2:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8012a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8012a8:	8a 00                	mov    (%eax),%al
  8012aa:	3c 20                	cmp    $0x20,%al
  8012ac:	74 f4                	je     8012a2 <strtol+0x16>
  8012ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8012b1:	8a 00                	mov    (%eax),%al
  8012b3:	3c 09                	cmp    $0x9,%al
  8012b5:	74 eb                	je     8012a2 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  8012b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8012ba:	8a 00                	mov    (%eax),%al
  8012bc:	3c 2b                	cmp    $0x2b,%al
  8012be:	75 05                	jne    8012c5 <strtol+0x39>
		s++;
  8012c0:	ff 45 08             	incl   0x8(%ebp)
  8012c3:	eb 13                	jmp    8012d8 <strtol+0x4c>
	else if (*s == '-')
  8012c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8012c8:	8a 00                	mov    (%eax),%al
  8012ca:	3c 2d                	cmp    $0x2d,%al
  8012cc:	75 0a                	jne    8012d8 <strtol+0x4c>
		s++, neg = 1;
  8012ce:	ff 45 08             	incl   0x8(%ebp)
  8012d1:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8012d8:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8012dc:	74 06                	je     8012e4 <strtol+0x58>
  8012de:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  8012e2:	75 20                	jne    801304 <strtol+0x78>
  8012e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8012e7:	8a 00                	mov    (%eax),%al
  8012e9:	3c 30                	cmp    $0x30,%al
  8012eb:	75 17                	jne    801304 <strtol+0x78>
  8012ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8012f0:	40                   	inc    %eax
  8012f1:	8a 00                	mov    (%eax),%al
  8012f3:	3c 78                	cmp    $0x78,%al
  8012f5:	75 0d                	jne    801304 <strtol+0x78>
		s += 2, base = 16;
  8012f7:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  8012fb:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  801302:	eb 28                	jmp    80132c <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  801304:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801308:	75 15                	jne    80131f <strtol+0x93>
  80130a:	8b 45 08             	mov    0x8(%ebp),%eax
  80130d:	8a 00                	mov    (%eax),%al
  80130f:	3c 30                	cmp    $0x30,%al
  801311:	75 0c                	jne    80131f <strtol+0x93>
		s++, base = 8;
  801313:	ff 45 08             	incl   0x8(%ebp)
  801316:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  80131d:	eb 0d                	jmp    80132c <strtol+0xa0>
	else if (base == 0)
  80131f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801323:	75 07                	jne    80132c <strtol+0xa0>
		base = 10;
  801325:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  80132c:	8b 45 08             	mov    0x8(%ebp),%eax
  80132f:	8a 00                	mov    (%eax),%al
  801331:	3c 2f                	cmp    $0x2f,%al
  801333:	7e 19                	jle    80134e <strtol+0xc2>
  801335:	8b 45 08             	mov    0x8(%ebp),%eax
  801338:	8a 00                	mov    (%eax),%al
  80133a:	3c 39                	cmp    $0x39,%al
  80133c:	7f 10                	jg     80134e <strtol+0xc2>
			dig = *s - '0';
  80133e:	8b 45 08             	mov    0x8(%ebp),%eax
  801341:	8a 00                	mov    (%eax),%al
  801343:	0f be c0             	movsbl %al,%eax
  801346:	83 e8 30             	sub    $0x30,%eax
  801349:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80134c:	eb 42                	jmp    801390 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  80134e:	8b 45 08             	mov    0x8(%ebp),%eax
  801351:	8a 00                	mov    (%eax),%al
  801353:	3c 60                	cmp    $0x60,%al
  801355:	7e 19                	jle    801370 <strtol+0xe4>
  801357:	8b 45 08             	mov    0x8(%ebp),%eax
  80135a:	8a 00                	mov    (%eax),%al
  80135c:	3c 7a                	cmp    $0x7a,%al
  80135e:	7f 10                	jg     801370 <strtol+0xe4>
			dig = *s - 'a' + 10;
  801360:	8b 45 08             	mov    0x8(%ebp),%eax
  801363:	8a 00                	mov    (%eax),%al
  801365:	0f be c0             	movsbl %al,%eax
  801368:	83 e8 57             	sub    $0x57,%eax
  80136b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80136e:	eb 20                	jmp    801390 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  801370:	8b 45 08             	mov    0x8(%ebp),%eax
  801373:	8a 00                	mov    (%eax),%al
  801375:	3c 40                	cmp    $0x40,%al
  801377:	7e 39                	jle    8013b2 <strtol+0x126>
  801379:	8b 45 08             	mov    0x8(%ebp),%eax
  80137c:	8a 00                	mov    (%eax),%al
  80137e:	3c 5a                	cmp    $0x5a,%al
  801380:	7f 30                	jg     8013b2 <strtol+0x126>
			dig = *s - 'A' + 10;
  801382:	8b 45 08             	mov    0x8(%ebp),%eax
  801385:	8a 00                	mov    (%eax),%al
  801387:	0f be c0             	movsbl %al,%eax
  80138a:	83 e8 37             	sub    $0x37,%eax
  80138d:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  801390:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801393:	3b 45 10             	cmp    0x10(%ebp),%eax
  801396:	7d 19                	jge    8013b1 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801398:	ff 45 08             	incl   0x8(%ebp)
  80139b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80139e:	0f af 45 10          	imul   0x10(%ebp),%eax
  8013a2:	89 c2                	mov    %eax,%edx
  8013a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8013a7:	01 d0                	add    %edx,%eax
  8013a9:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  8013ac:	e9 7b ff ff ff       	jmp    80132c <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  8013b1:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  8013b2:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8013b6:	74 08                	je     8013c0 <strtol+0x134>
		*endptr = (char *) s;
  8013b8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013bb:	8b 55 08             	mov    0x8(%ebp),%edx
  8013be:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  8013c0:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8013c4:	74 07                	je     8013cd <strtol+0x141>
  8013c6:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8013c9:	f7 d8                	neg    %eax
  8013cb:	eb 03                	jmp    8013d0 <strtol+0x144>
  8013cd:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8013d0:	c9                   	leave  
  8013d1:	c3                   	ret    

008013d2 <ltostr>:

void
ltostr(long value, char *str)
{
  8013d2:	55                   	push   %ebp
  8013d3:	89 e5                	mov    %esp,%ebp
  8013d5:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  8013d8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  8013df:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  8013e6:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8013ea:	79 13                	jns    8013ff <ltostr+0x2d>
	{
		neg = 1;
  8013ec:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  8013f3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013f6:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  8013f9:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  8013fc:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  8013ff:	8b 45 08             	mov    0x8(%ebp),%eax
  801402:	b9 0a 00 00 00       	mov    $0xa,%ecx
  801407:	99                   	cltd   
  801408:	f7 f9                	idiv   %ecx
  80140a:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  80140d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801410:	8d 50 01             	lea    0x1(%eax),%edx
  801413:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801416:	89 c2                	mov    %eax,%edx
  801418:	8b 45 0c             	mov    0xc(%ebp),%eax
  80141b:	01 d0                	add    %edx,%eax
  80141d:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801420:	83 c2 30             	add    $0x30,%edx
  801423:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  801425:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801428:	b8 67 66 66 66       	mov    $0x66666667,%eax
  80142d:	f7 e9                	imul   %ecx
  80142f:	c1 fa 02             	sar    $0x2,%edx
  801432:	89 c8                	mov    %ecx,%eax
  801434:	c1 f8 1f             	sar    $0x1f,%eax
  801437:	29 c2                	sub    %eax,%edx
  801439:	89 d0                	mov    %edx,%eax
  80143b:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  80143e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801442:	75 bb                	jne    8013ff <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801444:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  80144b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80144e:	48                   	dec    %eax
  80144f:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801452:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801456:	74 3d                	je     801495 <ltostr+0xc3>
		start = 1 ;
  801458:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  80145f:	eb 34                	jmp    801495 <ltostr+0xc3>
	{
		char tmp = str[start] ;
  801461:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801464:	8b 45 0c             	mov    0xc(%ebp),%eax
  801467:	01 d0                	add    %edx,%eax
  801469:	8a 00                	mov    (%eax),%al
  80146b:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  80146e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801471:	8b 45 0c             	mov    0xc(%ebp),%eax
  801474:	01 c2                	add    %eax,%edx
  801476:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801479:	8b 45 0c             	mov    0xc(%ebp),%eax
  80147c:	01 c8                	add    %ecx,%eax
  80147e:	8a 00                	mov    (%eax),%al
  801480:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801482:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801485:	8b 45 0c             	mov    0xc(%ebp),%eax
  801488:	01 c2                	add    %eax,%edx
  80148a:	8a 45 eb             	mov    -0x15(%ebp),%al
  80148d:	88 02                	mov    %al,(%edx)
		start++ ;
  80148f:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801492:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801495:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801498:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80149b:	7c c4                	jl     801461 <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  80149d:	8b 55 f8             	mov    -0x8(%ebp),%edx
  8014a0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014a3:	01 d0                	add    %edx,%eax
  8014a5:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  8014a8:	90                   	nop
  8014a9:	c9                   	leave  
  8014aa:	c3                   	ret    

008014ab <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  8014ab:	55                   	push   %ebp
  8014ac:	89 e5                	mov    %esp,%ebp
  8014ae:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  8014b1:	ff 75 08             	pushl  0x8(%ebp)
  8014b4:	e8 c4 f9 ff ff       	call   800e7d <strlen>
  8014b9:	83 c4 04             	add    $0x4,%esp
  8014bc:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  8014bf:	ff 75 0c             	pushl  0xc(%ebp)
  8014c2:	e8 b6 f9 ff ff       	call   800e7d <strlen>
  8014c7:	83 c4 04             	add    $0x4,%esp
  8014ca:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  8014cd:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  8014d4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8014db:	eb 17                	jmp    8014f4 <strcconcat+0x49>
		final[s] = str1[s] ;
  8014dd:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8014e0:	8b 45 10             	mov    0x10(%ebp),%eax
  8014e3:	01 c2                	add    %eax,%edx
  8014e5:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8014e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8014eb:	01 c8                	add    %ecx,%eax
  8014ed:	8a 00                	mov    (%eax),%al
  8014ef:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  8014f1:	ff 45 fc             	incl   -0x4(%ebp)
  8014f4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8014f7:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8014fa:	7c e1                	jl     8014dd <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  8014fc:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  801503:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  80150a:	eb 1f                	jmp    80152b <strcconcat+0x80>
		final[s++] = str2[i] ;
  80150c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80150f:	8d 50 01             	lea    0x1(%eax),%edx
  801512:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801515:	89 c2                	mov    %eax,%edx
  801517:	8b 45 10             	mov    0x10(%ebp),%eax
  80151a:	01 c2                	add    %eax,%edx
  80151c:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  80151f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801522:	01 c8                	add    %ecx,%eax
  801524:	8a 00                	mov    (%eax),%al
  801526:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801528:	ff 45 f8             	incl   -0x8(%ebp)
  80152b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80152e:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801531:	7c d9                	jl     80150c <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801533:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801536:	8b 45 10             	mov    0x10(%ebp),%eax
  801539:	01 d0                	add    %edx,%eax
  80153b:	c6 00 00             	movb   $0x0,(%eax)
}
  80153e:	90                   	nop
  80153f:	c9                   	leave  
  801540:	c3                   	ret    

00801541 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801541:	55                   	push   %ebp
  801542:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801544:	8b 45 14             	mov    0x14(%ebp),%eax
  801547:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  80154d:	8b 45 14             	mov    0x14(%ebp),%eax
  801550:	8b 00                	mov    (%eax),%eax
  801552:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801559:	8b 45 10             	mov    0x10(%ebp),%eax
  80155c:	01 d0                	add    %edx,%eax
  80155e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801564:	eb 0c                	jmp    801572 <strsplit+0x31>
			*string++ = 0;
  801566:	8b 45 08             	mov    0x8(%ebp),%eax
  801569:	8d 50 01             	lea    0x1(%eax),%edx
  80156c:	89 55 08             	mov    %edx,0x8(%ebp)
  80156f:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801572:	8b 45 08             	mov    0x8(%ebp),%eax
  801575:	8a 00                	mov    (%eax),%al
  801577:	84 c0                	test   %al,%al
  801579:	74 18                	je     801593 <strsplit+0x52>
  80157b:	8b 45 08             	mov    0x8(%ebp),%eax
  80157e:	8a 00                	mov    (%eax),%al
  801580:	0f be c0             	movsbl %al,%eax
  801583:	50                   	push   %eax
  801584:	ff 75 0c             	pushl  0xc(%ebp)
  801587:	e8 83 fa ff ff       	call   80100f <strchr>
  80158c:	83 c4 08             	add    $0x8,%esp
  80158f:	85 c0                	test   %eax,%eax
  801591:	75 d3                	jne    801566 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801593:	8b 45 08             	mov    0x8(%ebp),%eax
  801596:	8a 00                	mov    (%eax),%al
  801598:	84 c0                	test   %al,%al
  80159a:	74 5a                	je     8015f6 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  80159c:	8b 45 14             	mov    0x14(%ebp),%eax
  80159f:	8b 00                	mov    (%eax),%eax
  8015a1:	83 f8 0f             	cmp    $0xf,%eax
  8015a4:	75 07                	jne    8015ad <strsplit+0x6c>
		{
			return 0;
  8015a6:	b8 00 00 00 00       	mov    $0x0,%eax
  8015ab:	eb 66                	jmp    801613 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  8015ad:	8b 45 14             	mov    0x14(%ebp),%eax
  8015b0:	8b 00                	mov    (%eax),%eax
  8015b2:	8d 48 01             	lea    0x1(%eax),%ecx
  8015b5:	8b 55 14             	mov    0x14(%ebp),%edx
  8015b8:	89 0a                	mov    %ecx,(%edx)
  8015ba:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8015c1:	8b 45 10             	mov    0x10(%ebp),%eax
  8015c4:	01 c2                	add    %eax,%edx
  8015c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8015c9:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  8015cb:	eb 03                	jmp    8015d0 <strsplit+0x8f>
			string++;
  8015cd:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  8015d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8015d3:	8a 00                	mov    (%eax),%al
  8015d5:	84 c0                	test   %al,%al
  8015d7:	74 8b                	je     801564 <strsplit+0x23>
  8015d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8015dc:	8a 00                	mov    (%eax),%al
  8015de:	0f be c0             	movsbl %al,%eax
  8015e1:	50                   	push   %eax
  8015e2:	ff 75 0c             	pushl  0xc(%ebp)
  8015e5:	e8 25 fa ff ff       	call   80100f <strchr>
  8015ea:	83 c4 08             	add    $0x8,%esp
  8015ed:	85 c0                	test   %eax,%eax
  8015ef:	74 dc                	je     8015cd <strsplit+0x8c>
			string++;
	}
  8015f1:	e9 6e ff ff ff       	jmp    801564 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  8015f6:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  8015f7:	8b 45 14             	mov    0x14(%ebp),%eax
  8015fa:	8b 00                	mov    (%eax),%eax
  8015fc:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801603:	8b 45 10             	mov    0x10(%ebp),%eax
  801606:	01 d0                	add    %edx,%eax
  801608:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  80160e:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801613:	c9                   	leave  
  801614:	c3                   	ret    

00801615 <str2lower>:


char* str2lower(char *dst, const char *src)
{
  801615:	55                   	push   %ebp
  801616:	89 e5                	mov    %esp,%ebp
  801618:	83 ec 10             	sub    $0x10,%esp
	char* ret = dst;
  80161b:	8b 45 08             	mov    0x8(%ebp),%eax
  80161e:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (int i = 0; i < strlen(src); ++i)
  801621:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801628:	eb 4a                	jmp    801674 <str2lower+0x5f>
	{
		dst[i] = src[i] ;
  80162a:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80162d:	8b 45 08             	mov    0x8(%ebp),%eax
  801630:	01 c2                	add    %eax,%edx
  801632:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801635:	8b 45 0c             	mov    0xc(%ebp),%eax
  801638:	01 c8                	add    %ecx,%eax
  80163a:	8a 00                	mov    (%eax),%al
  80163c:	88 02                	mov    %al,(%edx)
		if (src[i] >= 'A' && src[i] <= 'Z')
  80163e:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801641:	8b 45 0c             	mov    0xc(%ebp),%eax
  801644:	01 d0                	add    %edx,%eax
  801646:	8a 00                	mov    (%eax),%al
  801648:	3c 40                	cmp    $0x40,%al
  80164a:	7e 25                	jle    801671 <str2lower+0x5c>
  80164c:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80164f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801652:	01 d0                	add    %edx,%eax
  801654:	8a 00                	mov    (%eax),%al
  801656:	3c 5a                	cmp    $0x5a,%al
  801658:	7f 17                	jg     801671 <str2lower+0x5c>
		{
			dst[i] += 32 ;
  80165a:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80165d:	8b 45 08             	mov    0x8(%ebp),%eax
  801660:	01 d0                	add    %edx,%eax
  801662:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801665:	8b 55 08             	mov    0x8(%ebp),%edx
  801668:	01 ca                	add    %ecx,%edx
  80166a:	8a 12                	mov    (%edx),%dl
  80166c:	83 c2 20             	add    $0x20,%edx
  80166f:	88 10                	mov    %dl,(%eax)


char* str2lower(char *dst, const char *src)
{
	char* ret = dst;
	for (int i = 0; i < strlen(src); ++i)
  801671:	ff 45 fc             	incl   -0x4(%ebp)
  801674:	ff 75 0c             	pushl  0xc(%ebp)
  801677:	e8 01 f8 ff ff       	call   800e7d <strlen>
  80167c:	83 c4 04             	add    $0x4,%esp
  80167f:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801682:	7f a6                	jg     80162a <str2lower+0x15>
		if (src[i] >= 'A' && src[i] <= 'Z')
		{
			dst[i] += 32 ;
		}
	}
	return ret;
  801684:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801687:	c9                   	leave  
  801688:	c3                   	ret    

00801689 <uheap_init>:
//==============================================
// [1] INITIALIZE USER HEAP:
//==============================================
int __firstTimeFlag = 1;
void uheap_init()
{
  801689:	55                   	push   %ebp
  80168a:	89 e5                	mov    %esp,%ebp
  80168c:	83 ec 08             	sub    $0x8,%esp
	if(__firstTimeFlag)
  80168f:	a1 08 40 80 00       	mov    0x804008,%eax
  801694:	85 c0                	test   %eax,%eax
  801696:	74 42                	je     8016da <uheap_init+0x51>
	{
		initialize_dynamic_allocator(USER_HEAP_START, USER_HEAP_START + DYN_ALLOC_MAX_SIZE);
  801698:	83 ec 08             	sub    $0x8,%esp
  80169b:	68 00 00 00 82       	push   $0x82000000
  8016a0:	68 00 00 00 80       	push   $0x80000000
  8016a5:	e8 00 08 00 00       	call   801eaa <initialize_dynamic_allocator>
  8016aa:	83 c4 10             	add    $0x10,%esp
		uheapPlaceStrategy = sys_get_uheap_strategy();
  8016ad:	e8 e7 05 00 00       	call   801c99 <sys_get_uheap_strategy>
  8016b2:	a3 60 c0 81 00       	mov    %eax,0x81c060
		uheapPageAllocStart = dynAllocEnd + PAGE_SIZE;
  8016b7:	a1 40 40 80 00       	mov    0x804040,%eax
  8016bc:	05 00 10 00 00       	add    $0x1000,%eax
  8016c1:	a3 10 c1 81 00       	mov    %eax,0x81c110
		uheapPageAllocBreak = uheapPageAllocStart;
  8016c6:	a1 10 c1 81 00       	mov    0x81c110,%eax
  8016cb:	a3 68 c0 81 00       	mov    %eax,0x81c068

		__firstTimeFlag = 0;
  8016d0:	c7 05 08 40 80 00 00 	movl   $0x0,0x804008
  8016d7:	00 00 00 
	}
}
  8016da:	90                   	nop
  8016db:	c9                   	leave  
  8016dc:	c3                   	ret    

008016dd <get_page>:

//==============================================
// [2] GET A PAGE FROM THE KERNEL FOR DA:
//==============================================
int get_page(void* va)
{
  8016dd:	55                   	push   %ebp
  8016de:	89 e5                	mov    %esp,%ebp
  8016e0:	83 ec 18             	sub    $0x18,%esp
	int ret = __sys_allocate_page(ROUNDDOWN(va, PAGE_SIZE), PERM_USER|PERM_WRITEABLE|PERM_UHPAGE);
  8016e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8016e6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8016e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8016ec:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8016f1:	83 ec 08             	sub    $0x8,%esp
  8016f4:	68 06 04 00 00       	push   $0x406
  8016f9:	50                   	push   %eax
  8016fa:	e8 e4 01 00 00       	call   8018e3 <__sys_allocate_page>
  8016ff:	83 c4 10             	add    $0x10,%esp
  801702:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (ret < 0)
  801705:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801709:	79 14                	jns    80171f <get_page+0x42>
		panic("get_page() in user: failed to allocate page from the kernel");
  80170b:	83 ec 04             	sub    $0x4,%esp
  80170e:	68 28 33 80 00       	push   $0x803328
  801713:	6a 1f                	push   $0x1f
  801715:	68 64 33 80 00       	push   $0x803364
  80171a:	e8 e5 11 00 00       	call   802904 <_panic>
	return 0;
  80171f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801724:	c9                   	leave  
  801725:	c3                   	ret    

00801726 <return_page>:

//==============================================
// [3] RETURN A PAGE FROM THE DA TO KERNEL:
//==============================================
void return_page(void* va)
{
  801726:	55                   	push   %ebp
  801727:	89 e5                	mov    %esp,%ebp
  801729:	83 ec 18             	sub    $0x18,%esp
	int ret = __sys_unmap_frame(ROUNDDOWN((uint32)va, PAGE_SIZE));
  80172c:	8b 45 08             	mov    0x8(%ebp),%eax
  80172f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801732:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801735:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80173a:	83 ec 0c             	sub    $0xc,%esp
  80173d:	50                   	push   %eax
  80173e:	e8 e7 01 00 00       	call   80192a <__sys_unmap_frame>
  801743:	83 c4 10             	add    $0x10,%esp
  801746:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (ret < 0)
  801749:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80174d:	79 14                	jns    801763 <return_page+0x3d>
		panic("return_page() in user: failed to return a page to the kernel");
  80174f:	83 ec 04             	sub    $0x4,%esp
  801752:	68 70 33 80 00       	push   $0x803370
  801757:	6a 2a                	push   $0x2a
  801759:	68 64 33 80 00       	push   $0x803364
  80175e:	e8 a1 11 00 00       	call   802904 <_panic>
}
  801763:	90                   	nop
  801764:	c9                   	leave  
  801765:	c3                   	ret    

00801766 <malloc>:

//=================================
// [1] ALLOCATE SPACE IN USER HEAP:
//=================================
void* malloc(uint32 size)
{
  801766:	55                   	push   %ebp
  801767:	89 e5                	mov    %esp,%ebp
  801769:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  80176c:	e8 18 ff ff ff       	call   801689 <uheap_init>
	if (size == 0) return NULL ;
  801771:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801775:	75 07                	jne    80177e <malloc+0x18>
  801777:	b8 00 00 00 00       	mov    $0x0,%eax
  80177c:	eb 14                	jmp    801792 <malloc+0x2c>
	//==============================================================
	//TODO: [PROJECT'25.IM#2] USER HEAP - #1 malloc
	//Your code is here
	//Comment the following line
	panic("malloc() is not implemented yet...!!");
  80177e:	83 ec 04             	sub    $0x4,%esp
  801781:	68 b0 33 80 00       	push   $0x8033b0
  801786:	6a 3e                	push   $0x3e
  801788:	68 64 33 80 00       	push   $0x803364
  80178d:	e8 72 11 00 00       	call   802904 <_panic>
}
  801792:	c9                   	leave  
  801793:	c3                   	ret    

00801794 <free>:

//=================================
// [2] FREE SPACE FROM USER HEAP:
//=================================
void free(void* virtual_address)
{
  801794:	55                   	push   %ebp
  801795:	89 e5                	mov    %esp,%ebp
  801797:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.IM#2] USER HEAP - #3 free
	//Your code is here
	//Comment the following line
	panic("free() is not implemented yet...!!");
  80179a:	83 ec 04             	sub    $0x4,%esp
  80179d:	68 d8 33 80 00       	push   $0x8033d8
  8017a2:	6a 49                	push   $0x49
  8017a4:	68 64 33 80 00       	push   $0x803364
  8017a9:	e8 56 11 00 00       	call   802904 <_panic>

008017ae <smalloc>:

//=================================
// [3] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  8017ae:	55                   	push   %ebp
  8017af:	89 e5                	mov    %esp,%ebp
  8017b1:	83 ec 18             	sub    $0x18,%esp
  8017b4:	8b 45 10             	mov    0x10(%ebp),%eax
  8017b7:	88 45 f4             	mov    %al,-0xc(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  8017ba:	e8 ca fe ff ff       	call   801689 <uheap_init>
	if (size == 0) return NULL ;
  8017bf:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8017c3:	75 07                	jne    8017cc <smalloc+0x1e>
  8017c5:	b8 00 00 00 00       	mov    $0x0,%eax
  8017ca:	eb 14                	jmp    8017e0 <smalloc+0x32>
	//==============================================================

	//TODO: [PROJECT'25.IM#3] SHARED MEMORY - #2 smalloc
	//Your code is here
	//Comment the following line
	panic("smalloc() is not implemented yet...!!");
  8017cc:	83 ec 04             	sub    $0x4,%esp
  8017cf:	68 fc 33 80 00       	push   $0x8033fc
  8017d4:	6a 5a                	push   $0x5a
  8017d6:	68 64 33 80 00       	push   $0x803364
  8017db:	e8 24 11 00 00       	call   802904 <_panic>
}
  8017e0:	c9                   	leave  
  8017e1:	c3                   	ret    

008017e2 <sget>:

//========================================
// [4] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  8017e2:	55                   	push   %ebp
  8017e3:	89 e5                	mov    %esp,%ebp
  8017e5:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  8017e8:	e8 9c fe ff ff       	call   801689 <uheap_init>
	//==============================================================

	//TODO: [PROJECT'25.IM#3] SHARED MEMORY - #4 sget
	//Your code is here
	//Comment the following line
	panic("sget() is not implemented yet...!!");
  8017ed:	83 ec 04             	sub    $0x4,%esp
  8017f0:	68 24 34 80 00       	push   $0x803424
  8017f5:	6a 6a                	push   $0x6a
  8017f7:	68 64 33 80 00       	push   $0x803364
  8017fc:	e8 03 11 00 00       	call   802904 <_panic>

00801801 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801801:	55                   	push   %ebp
  801802:	89 e5                	mov    %esp,%ebp
  801804:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  801807:	e8 7d fe ff ff       	call   801689 <uheap_init>
	//==============================================================
	panic("realloc() is not implemented yet...!!");
  80180c:	83 ec 04             	sub    $0x4,%esp
  80180f:	68 48 34 80 00       	push   $0x803448
  801814:	68 88 00 00 00       	push   $0x88
  801819:	68 64 33 80 00       	push   $0x803364
  80181e:	e8 e1 10 00 00       	call   802904 <_panic>

00801823 <sfree>:
//
//	use sys_delete_shared_object(...); which switches to the kernel mode,
//	calls delete_shared_object(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the delete_shared_object() function is empty, make sure to implement it.
void sfree(void* virtual_address)
{
  801823:	55                   	push   %ebp
  801824:	89 e5                	mov    %esp,%ebp
  801826:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.BONUS#5] EXIT #2 - sfree
	//Your code is here
	//Comment the following line
	panic("sfree() is not implemented yet...!!");
  801829:	83 ec 04             	sub    $0x4,%esp
  80182c:	68 70 34 80 00       	push   $0x803470
  801831:	68 9b 00 00 00       	push   $0x9b
  801836:	68 64 33 80 00       	push   $0x803364
  80183b:	e8 c4 10 00 00       	call   802904 <_panic>

00801840 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801840:	55                   	push   %ebp
  801841:	89 e5                	mov    %esp,%ebp
  801843:	57                   	push   %edi
  801844:	56                   	push   %esi
  801845:	53                   	push   %ebx
  801846:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801849:	8b 45 08             	mov    0x8(%ebp),%eax
  80184c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80184f:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801852:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801855:	8b 7d 18             	mov    0x18(%ebp),%edi
  801858:	8b 75 1c             	mov    0x1c(%ebp),%esi
  80185b:	cd 30                	int    $0x30
  80185d:	89 45 f0             	mov    %eax,-0x10(%ebp)
				"b" (a3),
				"D" (a4),
				"S" (a5)
				: "cc", "memory");

	return ret;
  801860:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801863:	83 c4 10             	add    $0x10,%esp
  801866:	5b                   	pop    %ebx
  801867:	5e                   	pop    %esi
  801868:	5f                   	pop    %edi
  801869:	5d                   	pop    %ebp
  80186a:	c3                   	ret    

0080186b <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName, int color)
{
  80186b:	55                   	push   %ebp
  80186c:	89 e5                	mov    %esp,%ebp
  80186e:	83 ec 04             	sub    $0x4,%esp
  801871:	8b 45 10             	mov    0x10(%ebp),%eax
  801874:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, color, 0);
  801877:	8b 4d 14             	mov    0x14(%ebp),%ecx
  80187a:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80187e:	8b 45 08             	mov    0x8(%ebp),%eax
  801881:	6a 00                	push   $0x0
  801883:	51                   	push   %ecx
  801884:	52                   	push   %edx
  801885:	ff 75 0c             	pushl  0xc(%ebp)
  801888:	50                   	push   %eax
  801889:	6a 00                	push   $0x0
  80188b:	e8 b0 ff ff ff       	call   801840 <syscall>
  801890:	83 c4 18             	add    $0x18,%esp
}
  801893:	90                   	nop
  801894:	c9                   	leave  
  801895:	c3                   	ret    

00801896 <sys_cgetc>:

int
sys_cgetc(void)
{
  801896:	55                   	push   %ebp
  801897:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801899:	6a 00                	push   $0x0
  80189b:	6a 00                	push   $0x0
  80189d:	6a 00                	push   $0x0
  80189f:	6a 00                	push   $0x0
  8018a1:	6a 00                	push   $0x0
  8018a3:	6a 02                	push   $0x2
  8018a5:	e8 96 ff ff ff       	call   801840 <syscall>
  8018aa:	83 c4 18             	add    $0x18,%esp
}
  8018ad:	c9                   	leave  
  8018ae:	c3                   	ret    

008018af <sys_lock_cons>:

void sys_lock_cons(void)
{
  8018af:	55                   	push   %ebp
  8018b0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  8018b2:	6a 00                	push   $0x0
  8018b4:	6a 00                	push   $0x0
  8018b6:	6a 00                	push   $0x0
  8018b8:	6a 00                	push   $0x0
  8018ba:	6a 00                	push   $0x0
  8018bc:	6a 03                	push   $0x3
  8018be:	e8 7d ff ff ff       	call   801840 <syscall>
  8018c3:	83 c4 18             	add    $0x18,%esp
}
  8018c6:	90                   	nop
  8018c7:	c9                   	leave  
  8018c8:	c3                   	ret    

008018c9 <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  8018c9:	55                   	push   %ebp
  8018ca:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  8018cc:	6a 00                	push   $0x0
  8018ce:	6a 00                	push   $0x0
  8018d0:	6a 00                	push   $0x0
  8018d2:	6a 00                	push   $0x0
  8018d4:	6a 00                	push   $0x0
  8018d6:	6a 04                	push   $0x4
  8018d8:	e8 63 ff ff ff       	call   801840 <syscall>
  8018dd:	83 c4 18             	add    $0x18,%esp
}
  8018e0:	90                   	nop
  8018e1:	c9                   	leave  
  8018e2:	c3                   	ret    

008018e3 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  8018e3:	55                   	push   %ebp
  8018e4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  8018e6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8018ec:	6a 00                	push   $0x0
  8018ee:	6a 00                	push   $0x0
  8018f0:	6a 00                	push   $0x0
  8018f2:	52                   	push   %edx
  8018f3:	50                   	push   %eax
  8018f4:	6a 08                	push   $0x8
  8018f6:	e8 45 ff ff ff       	call   801840 <syscall>
  8018fb:	83 c4 18             	add    $0x18,%esp
}
  8018fe:	c9                   	leave  
  8018ff:	c3                   	ret    

00801900 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801900:	55                   	push   %ebp
  801901:	89 e5                	mov    %esp,%ebp
  801903:	56                   	push   %esi
  801904:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801905:	8b 75 18             	mov    0x18(%ebp),%esi
  801908:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80190b:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80190e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801911:	8b 45 08             	mov    0x8(%ebp),%eax
  801914:	56                   	push   %esi
  801915:	53                   	push   %ebx
  801916:	51                   	push   %ecx
  801917:	52                   	push   %edx
  801918:	50                   	push   %eax
  801919:	6a 09                	push   $0x9
  80191b:	e8 20 ff ff ff       	call   801840 <syscall>
  801920:	83 c4 18             	add    $0x18,%esp
}
  801923:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801926:	5b                   	pop    %ebx
  801927:	5e                   	pop    %esi
  801928:	5d                   	pop    %ebp
  801929:	c3                   	ret    

0080192a <__sys_unmap_frame>:

int __sys_unmap_frame(uint32 va)
{
  80192a:	55                   	push   %ebp
  80192b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, va, 0, 0, 0, 0);
  80192d:	6a 00                	push   $0x0
  80192f:	6a 00                	push   $0x0
  801931:	6a 00                	push   $0x0
  801933:	6a 00                	push   $0x0
  801935:	ff 75 08             	pushl  0x8(%ebp)
  801938:	6a 0a                	push   $0xa
  80193a:	e8 01 ff ff ff       	call   801840 <syscall>
  80193f:	83 c4 18             	add    $0x18,%esp
}
  801942:	c9                   	leave  
  801943:	c3                   	ret    

00801944 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801944:	55                   	push   %ebp
  801945:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801947:	6a 00                	push   $0x0
  801949:	6a 00                	push   $0x0
  80194b:	6a 00                	push   $0x0
  80194d:	ff 75 0c             	pushl  0xc(%ebp)
  801950:	ff 75 08             	pushl  0x8(%ebp)
  801953:	6a 0b                	push   $0xb
  801955:	e8 e6 fe ff ff       	call   801840 <syscall>
  80195a:	83 c4 18             	add    $0x18,%esp
}
  80195d:	c9                   	leave  
  80195e:	c3                   	ret    

0080195f <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  80195f:	55                   	push   %ebp
  801960:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801962:	6a 00                	push   $0x0
  801964:	6a 00                	push   $0x0
  801966:	6a 00                	push   $0x0
  801968:	6a 00                	push   $0x0
  80196a:	6a 00                	push   $0x0
  80196c:	6a 0c                	push   $0xc
  80196e:	e8 cd fe ff ff       	call   801840 <syscall>
  801973:	83 c4 18             	add    $0x18,%esp
}
  801976:	c9                   	leave  
  801977:	c3                   	ret    

00801978 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801978:	55                   	push   %ebp
  801979:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  80197b:	6a 00                	push   $0x0
  80197d:	6a 00                	push   $0x0
  80197f:	6a 00                	push   $0x0
  801981:	6a 00                	push   $0x0
  801983:	6a 00                	push   $0x0
  801985:	6a 0d                	push   $0xd
  801987:	e8 b4 fe ff ff       	call   801840 <syscall>
  80198c:	83 c4 18             	add    $0x18,%esp
}
  80198f:	c9                   	leave  
  801990:	c3                   	ret    

00801991 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801991:	55                   	push   %ebp
  801992:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801994:	6a 00                	push   $0x0
  801996:	6a 00                	push   $0x0
  801998:	6a 00                	push   $0x0
  80199a:	6a 00                	push   $0x0
  80199c:	6a 00                	push   $0x0
  80199e:	6a 0e                	push   $0xe
  8019a0:	e8 9b fe ff ff       	call   801840 <syscall>
  8019a5:	83 c4 18             	add    $0x18,%esp
}
  8019a8:	c9                   	leave  
  8019a9:	c3                   	ret    

008019aa <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  8019aa:	55                   	push   %ebp
  8019ab:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  8019ad:	6a 00                	push   $0x0
  8019af:	6a 00                	push   $0x0
  8019b1:	6a 00                	push   $0x0
  8019b3:	6a 00                	push   $0x0
  8019b5:	6a 00                	push   $0x0
  8019b7:	6a 0f                	push   $0xf
  8019b9:	e8 82 fe ff ff       	call   801840 <syscall>
  8019be:	83 c4 18             	add    $0x18,%esp
}
  8019c1:	c9                   	leave  
  8019c2:	c3                   	ret    

008019c3 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  8019c3:	55                   	push   %ebp
  8019c4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  8019c6:	6a 00                	push   $0x0
  8019c8:	6a 00                	push   $0x0
  8019ca:	6a 00                	push   $0x0
  8019cc:	6a 00                	push   $0x0
  8019ce:	ff 75 08             	pushl  0x8(%ebp)
  8019d1:	6a 10                	push   $0x10
  8019d3:	e8 68 fe ff ff       	call   801840 <syscall>
  8019d8:	83 c4 18             	add    $0x18,%esp
}
  8019db:	c9                   	leave  
  8019dc:	c3                   	ret    

008019dd <sys_scarce_memory>:

void sys_scarce_memory()
{
  8019dd:	55                   	push   %ebp
  8019de:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  8019e0:	6a 00                	push   $0x0
  8019e2:	6a 00                	push   $0x0
  8019e4:	6a 00                	push   $0x0
  8019e6:	6a 00                	push   $0x0
  8019e8:	6a 00                	push   $0x0
  8019ea:	6a 11                	push   $0x11
  8019ec:	e8 4f fe ff ff       	call   801840 <syscall>
  8019f1:	83 c4 18             	add    $0x18,%esp
}
  8019f4:	90                   	nop
  8019f5:	c9                   	leave  
  8019f6:	c3                   	ret    

008019f7 <sys_cputc>:

void
sys_cputc(const char c)
{
  8019f7:	55                   	push   %ebp
  8019f8:	89 e5                	mov    %esp,%ebp
  8019fa:	83 ec 04             	sub    $0x4,%esp
  8019fd:	8b 45 08             	mov    0x8(%ebp),%eax
  801a00:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801a03:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801a07:	6a 00                	push   $0x0
  801a09:	6a 00                	push   $0x0
  801a0b:	6a 00                	push   $0x0
  801a0d:	6a 00                	push   $0x0
  801a0f:	50                   	push   %eax
  801a10:	6a 01                	push   $0x1
  801a12:	e8 29 fe ff ff       	call   801840 <syscall>
  801a17:	83 c4 18             	add    $0x18,%esp
}
  801a1a:	90                   	nop
  801a1b:	c9                   	leave  
  801a1c:	c3                   	ret    

00801a1d <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801a1d:	55                   	push   %ebp
  801a1e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801a20:	6a 00                	push   $0x0
  801a22:	6a 00                	push   $0x0
  801a24:	6a 00                	push   $0x0
  801a26:	6a 00                	push   $0x0
  801a28:	6a 00                	push   $0x0
  801a2a:	6a 14                	push   $0x14
  801a2c:	e8 0f fe ff ff       	call   801840 <syscall>
  801a31:	83 c4 18             	add    $0x18,%esp
}
  801a34:	90                   	nop
  801a35:	c9                   	leave  
  801a36:	c3                   	ret    

00801a37 <sys_create_shared_object>:

int sys_create_shared_object(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801a37:	55                   	push   %ebp
  801a38:	89 e5                	mov    %esp,%ebp
  801a3a:	83 ec 04             	sub    $0x4,%esp
  801a3d:	8b 45 10             	mov    0x10(%ebp),%eax
  801a40:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801a43:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801a46:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801a4a:	8b 45 08             	mov    0x8(%ebp),%eax
  801a4d:	6a 00                	push   $0x0
  801a4f:	51                   	push   %ecx
  801a50:	52                   	push   %edx
  801a51:	ff 75 0c             	pushl  0xc(%ebp)
  801a54:	50                   	push   %eax
  801a55:	6a 15                	push   $0x15
  801a57:	e8 e4 fd ff ff       	call   801840 <syscall>
  801a5c:	83 c4 18             	add    $0x18,%esp
}
  801a5f:	c9                   	leave  
  801a60:	c3                   	ret    

00801a61 <sys_size_of_shared_object>:

//2017:
int sys_size_of_shared_object(int32 ownerID, char* shareName)
{
  801a61:	55                   	push   %ebp
  801a62:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801a64:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a67:	8b 45 08             	mov    0x8(%ebp),%eax
  801a6a:	6a 00                	push   $0x0
  801a6c:	6a 00                	push   $0x0
  801a6e:	6a 00                	push   $0x0
  801a70:	52                   	push   %edx
  801a71:	50                   	push   %eax
  801a72:	6a 16                	push   $0x16
  801a74:	e8 c7 fd ff ff       	call   801840 <syscall>
  801a79:	83 c4 18             	add    $0x18,%esp
}
  801a7c:	c9                   	leave  
  801a7d:	c3                   	ret    

00801a7e <sys_get_shared_object>:
//==========

int sys_get_shared_object(int32 ownerID, char* shareName, void* virtual_address)
{
  801a7e:	55                   	push   %ebp
  801a7f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801a81:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801a84:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a87:	8b 45 08             	mov    0x8(%ebp),%eax
  801a8a:	6a 00                	push   $0x0
  801a8c:	6a 00                	push   $0x0
  801a8e:	51                   	push   %ecx
  801a8f:	52                   	push   %edx
  801a90:	50                   	push   %eax
  801a91:	6a 17                	push   $0x17
  801a93:	e8 a8 fd ff ff       	call   801840 <syscall>
  801a98:	83 c4 18             	add    $0x18,%esp
}
  801a9b:	c9                   	leave  
  801a9c:	c3                   	ret    

00801a9d <sys_delete_shared_object>:

int sys_delete_shared_object(int32 sharedObjectID, void *startVA)
{
  801a9d:	55                   	push   %ebp
  801a9e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801aa0:	8b 55 0c             	mov    0xc(%ebp),%edx
  801aa3:	8b 45 08             	mov    0x8(%ebp),%eax
  801aa6:	6a 00                	push   $0x0
  801aa8:	6a 00                	push   $0x0
  801aaa:	6a 00                	push   $0x0
  801aac:	52                   	push   %edx
  801aad:	50                   	push   %eax
  801aae:	6a 18                	push   $0x18
  801ab0:	e8 8b fd ff ff       	call   801840 <syscall>
  801ab5:	83 c4 18             	add    $0x18,%esp
}
  801ab8:	c9                   	leave  
  801ab9:	c3                   	ret    

00801aba <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801aba:	55                   	push   %ebp
  801abb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801abd:	8b 45 08             	mov    0x8(%ebp),%eax
  801ac0:	6a 00                	push   $0x0
  801ac2:	ff 75 14             	pushl  0x14(%ebp)
  801ac5:	ff 75 10             	pushl  0x10(%ebp)
  801ac8:	ff 75 0c             	pushl  0xc(%ebp)
  801acb:	50                   	push   %eax
  801acc:	6a 19                	push   $0x19
  801ace:	e8 6d fd ff ff       	call   801840 <syscall>
  801ad3:	83 c4 18             	add    $0x18,%esp
}
  801ad6:	c9                   	leave  
  801ad7:	c3                   	ret    

00801ad8 <sys_run_env>:

void sys_run_env(int32 envId)
{
  801ad8:	55                   	push   %ebp
  801ad9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801adb:	8b 45 08             	mov    0x8(%ebp),%eax
  801ade:	6a 00                	push   $0x0
  801ae0:	6a 00                	push   $0x0
  801ae2:	6a 00                	push   $0x0
  801ae4:	6a 00                	push   $0x0
  801ae6:	50                   	push   %eax
  801ae7:	6a 1a                	push   $0x1a
  801ae9:	e8 52 fd ff ff       	call   801840 <syscall>
  801aee:	83 c4 18             	add    $0x18,%esp
}
  801af1:	90                   	nop
  801af2:	c9                   	leave  
  801af3:	c3                   	ret    

00801af4 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801af4:	55                   	push   %ebp
  801af5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801af7:	8b 45 08             	mov    0x8(%ebp),%eax
  801afa:	6a 00                	push   $0x0
  801afc:	6a 00                	push   $0x0
  801afe:	6a 00                	push   $0x0
  801b00:	6a 00                	push   $0x0
  801b02:	50                   	push   %eax
  801b03:	6a 1b                	push   $0x1b
  801b05:	e8 36 fd ff ff       	call   801840 <syscall>
  801b0a:	83 c4 18             	add    $0x18,%esp
}
  801b0d:	c9                   	leave  
  801b0e:	c3                   	ret    

00801b0f <sys_getenvid>:

int32 sys_getenvid(void)
{
  801b0f:	55                   	push   %ebp
  801b10:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801b12:	6a 00                	push   $0x0
  801b14:	6a 00                	push   $0x0
  801b16:	6a 00                	push   $0x0
  801b18:	6a 00                	push   $0x0
  801b1a:	6a 00                	push   $0x0
  801b1c:	6a 05                	push   $0x5
  801b1e:	e8 1d fd ff ff       	call   801840 <syscall>
  801b23:	83 c4 18             	add    $0x18,%esp
}
  801b26:	c9                   	leave  
  801b27:	c3                   	ret    

00801b28 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801b28:	55                   	push   %ebp
  801b29:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801b2b:	6a 00                	push   $0x0
  801b2d:	6a 00                	push   $0x0
  801b2f:	6a 00                	push   $0x0
  801b31:	6a 00                	push   $0x0
  801b33:	6a 00                	push   $0x0
  801b35:	6a 06                	push   $0x6
  801b37:	e8 04 fd ff ff       	call   801840 <syscall>
  801b3c:	83 c4 18             	add    $0x18,%esp
}
  801b3f:	c9                   	leave  
  801b40:	c3                   	ret    

00801b41 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801b41:	55                   	push   %ebp
  801b42:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801b44:	6a 00                	push   $0x0
  801b46:	6a 00                	push   $0x0
  801b48:	6a 00                	push   $0x0
  801b4a:	6a 00                	push   $0x0
  801b4c:	6a 00                	push   $0x0
  801b4e:	6a 07                	push   $0x7
  801b50:	e8 eb fc ff ff       	call   801840 <syscall>
  801b55:	83 c4 18             	add    $0x18,%esp
}
  801b58:	c9                   	leave  
  801b59:	c3                   	ret    

00801b5a <sys_exit_env>:


void sys_exit_env(void)
{
  801b5a:	55                   	push   %ebp
  801b5b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801b5d:	6a 00                	push   $0x0
  801b5f:	6a 00                	push   $0x0
  801b61:	6a 00                	push   $0x0
  801b63:	6a 00                	push   $0x0
  801b65:	6a 00                	push   $0x0
  801b67:	6a 1c                	push   $0x1c
  801b69:	e8 d2 fc ff ff       	call   801840 <syscall>
  801b6e:	83 c4 18             	add    $0x18,%esp
}
  801b71:	90                   	nop
  801b72:	c9                   	leave  
  801b73:	c3                   	ret    

00801b74 <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  801b74:	55                   	push   %ebp
  801b75:	89 e5                	mov    %esp,%ebp
  801b77:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801b7a:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801b7d:	8d 50 04             	lea    0x4(%eax),%edx
  801b80:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801b83:	6a 00                	push   $0x0
  801b85:	6a 00                	push   $0x0
  801b87:	6a 00                	push   $0x0
  801b89:	52                   	push   %edx
  801b8a:	50                   	push   %eax
  801b8b:	6a 1d                	push   $0x1d
  801b8d:	e8 ae fc ff ff       	call   801840 <syscall>
  801b92:	83 c4 18             	add    $0x18,%esp
	return result;
  801b95:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801b98:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801b9b:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801b9e:	89 01                	mov    %eax,(%ecx)
  801ba0:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801ba3:	8b 45 08             	mov    0x8(%ebp),%eax
  801ba6:	c9                   	leave  
  801ba7:	c2 04 00             	ret    $0x4

00801baa <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801baa:	55                   	push   %ebp
  801bab:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801bad:	6a 00                	push   $0x0
  801baf:	6a 00                	push   $0x0
  801bb1:	ff 75 10             	pushl  0x10(%ebp)
  801bb4:	ff 75 0c             	pushl  0xc(%ebp)
  801bb7:	ff 75 08             	pushl  0x8(%ebp)
  801bba:	6a 13                	push   $0x13
  801bbc:	e8 7f fc ff ff       	call   801840 <syscall>
  801bc1:	83 c4 18             	add    $0x18,%esp
	return ;
  801bc4:	90                   	nop
}
  801bc5:	c9                   	leave  
  801bc6:	c3                   	ret    

00801bc7 <sys_rcr2>:
uint32 sys_rcr2()
{
  801bc7:	55                   	push   %ebp
  801bc8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801bca:	6a 00                	push   $0x0
  801bcc:	6a 00                	push   $0x0
  801bce:	6a 00                	push   $0x0
  801bd0:	6a 00                	push   $0x0
  801bd2:	6a 00                	push   $0x0
  801bd4:	6a 1e                	push   $0x1e
  801bd6:	e8 65 fc ff ff       	call   801840 <syscall>
  801bdb:	83 c4 18             	add    $0x18,%esp
}
  801bde:	c9                   	leave  
  801bdf:	c3                   	ret    

00801be0 <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  801be0:	55                   	push   %ebp
  801be1:	89 e5                	mov    %esp,%ebp
  801be3:	83 ec 04             	sub    $0x4,%esp
  801be6:	8b 45 08             	mov    0x8(%ebp),%eax
  801be9:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801bec:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801bf0:	6a 00                	push   $0x0
  801bf2:	6a 00                	push   $0x0
  801bf4:	6a 00                	push   $0x0
  801bf6:	6a 00                	push   $0x0
  801bf8:	50                   	push   %eax
  801bf9:	6a 1f                	push   $0x1f
  801bfb:	e8 40 fc ff ff       	call   801840 <syscall>
  801c00:	83 c4 18             	add    $0x18,%esp
	return ;
  801c03:	90                   	nop
}
  801c04:	c9                   	leave  
  801c05:	c3                   	ret    

00801c06 <rsttst>:
void rsttst()
{
  801c06:	55                   	push   %ebp
  801c07:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801c09:	6a 00                	push   $0x0
  801c0b:	6a 00                	push   $0x0
  801c0d:	6a 00                	push   $0x0
  801c0f:	6a 00                	push   $0x0
  801c11:	6a 00                	push   $0x0
  801c13:	6a 21                	push   $0x21
  801c15:	e8 26 fc ff ff       	call   801840 <syscall>
  801c1a:	83 c4 18             	add    $0x18,%esp
	return ;
  801c1d:	90                   	nop
}
  801c1e:	c9                   	leave  
  801c1f:	c3                   	ret    

00801c20 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801c20:	55                   	push   %ebp
  801c21:	89 e5                	mov    %esp,%ebp
  801c23:	83 ec 04             	sub    $0x4,%esp
  801c26:	8b 45 14             	mov    0x14(%ebp),%eax
  801c29:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801c2c:	8b 55 18             	mov    0x18(%ebp),%edx
  801c2f:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801c33:	52                   	push   %edx
  801c34:	50                   	push   %eax
  801c35:	ff 75 10             	pushl  0x10(%ebp)
  801c38:	ff 75 0c             	pushl  0xc(%ebp)
  801c3b:	ff 75 08             	pushl  0x8(%ebp)
  801c3e:	6a 20                	push   $0x20
  801c40:	e8 fb fb ff ff       	call   801840 <syscall>
  801c45:	83 c4 18             	add    $0x18,%esp
	return ;
  801c48:	90                   	nop
}
  801c49:	c9                   	leave  
  801c4a:	c3                   	ret    

00801c4b <chktst>:
void chktst(uint32 n)
{
  801c4b:	55                   	push   %ebp
  801c4c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801c4e:	6a 00                	push   $0x0
  801c50:	6a 00                	push   $0x0
  801c52:	6a 00                	push   $0x0
  801c54:	6a 00                	push   $0x0
  801c56:	ff 75 08             	pushl  0x8(%ebp)
  801c59:	6a 22                	push   $0x22
  801c5b:	e8 e0 fb ff ff       	call   801840 <syscall>
  801c60:	83 c4 18             	add    $0x18,%esp
	return ;
  801c63:	90                   	nop
}
  801c64:	c9                   	leave  
  801c65:	c3                   	ret    

00801c66 <inctst>:

void inctst()
{
  801c66:	55                   	push   %ebp
  801c67:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801c69:	6a 00                	push   $0x0
  801c6b:	6a 00                	push   $0x0
  801c6d:	6a 00                	push   $0x0
  801c6f:	6a 00                	push   $0x0
  801c71:	6a 00                	push   $0x0
  801c73:	6a 23                	push   $0x23
  801c75:	e8 c6 fb ff ff       	call   801840 <syscall>
  801c7a:	83 c4 18             	add    $0x18,%esp
	return ;
  801c7d:	90                   	nop
}
  801c7e:	c9                   	leave  
  801c7f:	c3                   	ret    

00801c80 <gettst>:
uint32 gettst()
{
  801c80:	55                   	push   %ebp
  801c81:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801c83:	6a 00                	push   $0x0
  801c85:	6a 00                	push   $0x0
  801c87:	6a 00                	push   $0x0
  801c89:	6a 00                	push   $0x0
  801c8b:	6a 00                	push   $0x0
  801c8d:	6a 24                	push   $0x24
  801c8f:	e8 ac fb ff ff       	call   801840 <syscall>
  801c94:	83 c4 18             	add    $0x18,%esp
}
  801c97:	c9                   	leave  
  801c98:	c3                   	ret    

00801c99 <sys_get_uheap_strategy>:

/*2025*/
uint32 sys_get_uheap_strategy()
{
  801c99:	55                   	push   %ebp
  801c9a:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801c9c:	6a 00                	push   $0x0
  801c9e:	6a 00                	push   $0x0
  801ca0:	6a 00                	push   $0x0
  801ca2:	6a 00                	push   $0x0
  801ca4:	6a 00                	push   $0x0
  801ca6:	6a 25                	push   $0x25
  801ca8:	e8 93 fb ff ff       	call   801840 <syscall>
  801cad:	83 c4 18             	add    $0x18,%esp
  801cb0:	a3 60 c0 81 00       	mov    %eax,0x81c060
	return uheapPlaceStrategy ;
  801cb5:	a1 60 c0 81 00       	mov    0x81c060,%eax
}
  801cba:	c9                   	leave  
  801cbb:	c3                   	ret    

00801cbc <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801cbc:	55                   	push   %ebp
  801cbd:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = heapStrategy;
  801cbf:	8b 45 08             	mov    0x8(%ebp),%eax
  801cc2:	a3 60 c0 81 00       	mov    %eax,0x81c060
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801cc7:	6a 00                	push   $0x0
  801cc9:	6a 00                	push   $0x0
  801ccb:	6a 00                	push   $0x0
  801ccd:	6a 00                	push   $0x0
  801ccf:	ff 75 08             	pushl  0x8(%ebp)
  801cd2:	6a 26                	push   $0x26
  801cd4:	e8 67 fb ff ff       	call   801840 <syscall>
  801cd9:	83 c4 18             	add    $0x18,%esp
	return ;
  801cdc:	90                   	nop
}
  801cdd:	c9                   	leave  
  801cde:	c3                   	ret    

00801cdf <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801cdf:	55                   	push   %ebp
  801ce0:	89 e5                	mov    %esp,%ebp
  801ce2:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801ce3:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801ce6:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801ce9:	8b 55 0c             	mov    0xc(%ebp),%edx
  801cec:	8b 45 08             	mov    0x8(%ebp),%eax
  801cef:	6a 00                	push   $0x0
  801cf1:	53                   	push   %ebx
  801cf2:	51                   	push   %ecx
  801cf3:	52                   	push   %edx
  801cf4:	50                   	push   %eax
  801cf5:	6a 27                	push   $0x27
  801cf7:	e8 44 fb ff ff       	call   801840 <syscall>
  801cfc:	83 c4 18             	add    $0x18,%esp
}
  801cff:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801d02:	c9                   	leave  
  801d03:	c3                   	ret    

00801d04 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801d04:	55                   	push   %ebp
  801d05:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801d07:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d0a:	8b 45 08             	mov    0x8(%ebp),%eax
  801d0d:	6a 00                	push   $0x0
  801d0f:	6a 00                	push   $0x0
  801d11:	6a 00                	push   $0x0
  801d13:	52                   	push   %edx
  801d14:	50                   	push   %eax
  801d15:	6a 28                	push   $0x28
  801d17:	e8 24 fb ff ff       	call   801840 <syscall>
  801d1c:	83 c4 18             	add    $0x18,%esp
}
  801d1f:	c9                   	leave  
  801d20:	c3                   	ret    

00801d21 <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  801d21:	55                   	push   %ebp
  801d22:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  801d24:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801d27:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d2a:	8b 45 08             	mov    0x8(%ebp),%eax
  801d2d:	6a 00                	push   $0x0
  801d2f:	51                   	push   %ecx
  801d30:	ff 75 10             	pushl  0x10(%ebp)
  801d33:	52                   	push   %edx
  801d34:	50                   	push   %eax
  801d35:	6a 29                	push   $0x29
  801d37:	e8 04 fb ff ff       	call   801840 <syscall>
  801d3c:	83 c4 18             	add    $0x18,%esp
}
  801d3f:	c9                   	leave  
  801d40:	c3                   	ret    

00801d41 <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801d41:	55                   	push   %ebp
  801d42:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801d44:	6a 00                	push   $0x0
  801d46:	6a 00                	push   $0x0
  801d48:	ff 75 10             	pushl  0x10(%ebp)
  801d4b:	ff 75 0c             	pushl  0xc(%ebp)
  801d4e:	ff 75 08             	pushl  0x8(%ebp)
  801d51:	6a 12                	push   $0x12
  801d53:	e8 e8 fa ff ff       	call   801840 <syscall>
  801d58:	83 c4 18             	add    $0x18,%esp
	return ;
  801d5b:	90                   	nop
}
  801d5c:	c9                   	leave  
  801d5d:	c3                   	ret    

00801d5e <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  801d5e:	55                   	push   %ebp
  801d5f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  801d61:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d64:	8b 45 08             	mov    0x8(%ebp),%eax
  801d67:	6a 00                	push   $0x0
  801d69:	6a 00                	push   $0x0
  801d6b:	6a 00                	push   $0x0
  801d6d:	52                   	push   %edx
  801d6e:	50                   	push   %eax
  801d6f:	6a 2a                	push   $0x2a
  801d71:	e8 ca fa ff ff       	call   801840 <syscall>
  801d76:	83 c4 18             	add    $0x18,%esp
	return;
  801d79:	90                   	nop
}
  801d7a:	c9                   	leave  
  801d7b:	c3                   	ret    

00801d7c <sys_get_optimal_num_faults>:
/*2025*/
int sys_get_optimal_num_faults()
{
  801d7c:	55                   	push   %ebp
  801d7d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_optimal_num_faults, 0, 0, 0, 0, 0);
  801d7f:	6a 00                	push   $0x0
  801d81:	6a 00                	push   $0x0
  801d83:	6a 00                	push   $0x0
  801d85:	6a 00                	push   $0x0
  801d87:	6a 00                	push   $0x0
  801d89:	6a 2b                	push   $0x2b
  801d8b:	e8 b0 fa ff ff       	call   801840 <syscall>
  801d90:	83 c4 18             	add    $0x18,%esp
}
  801d93:	c9                   	leave  
  801d94:	c3                   	ret    

00801d95 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801d95:	55                   	push   %ebp
  801d96:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801d98:	6a 00                	push   $0x0
  801d9a:	6a 00                	push   $0x0
  801d9c:	6a 00                	push   $0x0
  801d9e:	ff 75 0c             	pushl  0xc(%ebp)
  801da1:	ff 75 08             	pushl  0x8(%ebp)
  801da4:	6a 2d                	push   $0x2d
  801da6:	e8 95 fa ff ff       	call   801840 <syscall>
  801dab:	83 c4 18             	add    $0x18,%esp
	return;
  801dae:	90                   	nop
}
  801daf:	c9                   	leave  
  801db0:	c3                   	ret    

00801db1 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801db1:	55                   	push   %ebp
  801db2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801db4:	6a 00                	push   $0x0
  801db6:	6a 00                	push   $0x0
  801db8:	6a 00                	push   $0x0
  801dba:	ff 75 0c             	pushl  0xc(%ebp)
  801dbd:	ff 75 08             	pushl  0x8(%ebp)
  801dc0:	6a 2c                	push   $0x2c
  801dc2:	e8 79 fa ff ff       	call   801840 <syscall>
  801dc7:	83 c4 18             	add    $0x18,%esp
	return ;
  801dca:	90                   	nop
}
  801dcb:	c9                   	leave  
  801dcc:	c3                   	ret    

00801dcd <sys_env_set_priority>:


void sys_env_set_priority(int32 envID, int priority)
{
  801dcd:	55                   	push   %ebp
  801dce:	89 e5                	mov    %esp,%ebp
  801dd0:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.IM#4] CPU SCHEDULING - #1 System Calls - Add suitable code here
	//Your code is here
	//Comment the following line
	panic("sys_env_set_priority() is not implemented yet...!!");
  801dd3:	83 ec 04             	sub    $0x4,%esp
  801dd6:	68 94 34 80 00       	push   $0x803494
  801ddb:	68 25 01 00 00       	push   $0x125
  801de0:	68 c7 34 80 00       	push   $0x8034c7
  801de5:	e8 1a 0b 00 00       	call   802904 <_panic>

00801dea <to_page_va>:
//==================================
//==================================
// [1] GET PAGE VA:
//==================================
__inline__ uint32 to_page_va(struct PageInfoElement *ptrPageInfo)
{
  801dea:	55                   	push   %ebp
  801deb:	89 e5                	mov    %esp,%ebp
  801ded:	83 ec 18             	sub    $0x18,%esp
	if (ptrPageInfo < &pageBlockInfoArr[0] || ptrPageInfo >= &pageBlockInfoArr[DYN_ALLOC_MAX_SIZE/PAGE_SIZE])
  801df0:	81 7d 08 60 40 80 00 	cmpl   $0x804060,0x8(%ebp)
  801df7:	72 09                	jb     801e02 <to_page_va+0x18>
  801df9:	81 7d 08 60 c0 81 00 	cmpl   $0x81c060,0x8(%ebp)
  801e00:	72 14                	jb     801e16 <to_page_va+0x2c>
			panic("to_page_va called with invalid pageInfoPtr");
  801e02:	83 ec 04             	sub    $0x4,%esp
  801e05:	68 d8 34 80 00       	push   $0x8034d8
  801e0a:	6a 15                	push   $0x15
  801e0c:	68 03 35 80 00       	push   $0x803503
  801e11:	e8 ee 0a 00 00       	call   802904 <_panic>
	//Get start VA of the page from the corresponding Page Info pointer
	int idxInPageInfoArr = (ptrPageInfo - pageBlockInfoArr);
  801e16:	8b 45 08             	mov    0x8(%ebp),%eax
  801e19:	ba 60 40 80 00       	mov    $0x804060,%edx
  801e1e:	29 d0                	sub    %edx,%eax
  801e20:	c1 f8 02             	sar    $0x2,%eax
  801e23:	89 c2                	mov    %eax,%edx
  801e25:	89 d0                	mov    %edx,%eax
  801e27:	c1 e0 02             	shl    $0x2,%eax
  801e2a:	01 d0                	add    %edx,%eax
  801e2c:	c1 e0 02             	shl    $0x2,%eax
  801e2f:	01 d0                	add    %edx,%eax
  801e31:	c1 e0 02             	shl    $0x2,%eax
  801e34:	01 d0                	add    %edx,%eax
  801e36:	89 c1                	mov    %eax,%ecx
  801e38:	c1 e1 08             	shl    $0x8,%ecx
  801e3b:	01 c8                	add    %ecx,%eax
  801e3d:	89 c1                	mov    %eax,%ecx
  801e3f:	c1 e1 10             	shl    $0x10,%ecx
  801e42:	01 c8                	add    %ecx,%eax
  801e44:	01 c0                	add    %eax,%eax
  801e46:	01 d0                	add    %edx,%eax
  801e48:	89 45 f4             	mov    %eax,-0xc(%ebp)
	return dynAllocStart + (idxInPageInfoArr << PGSHIFT);
  801e4b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e4e:	c1 e0 0c             	shl    $0xc,%eax
  801e51:	89 c2                	mov    %eax,%edx
  801e53:	a1 64 c0 81 00       	mov    0x81c064,%eax
  801e58:	01 d0                	add    %edx,%eax
}
  801e5a:	c9                   	leave  
  801e5b:	c3                   	ret    

00801e5c <to_page_info>:

//==================================
// [2] GET PAGE INFO OF PAGE VA:
//==================================
__inline__ struct PageInfoElement * to_page_info(uint32 va)
{
  801e5c:	55                   	push   %ebp
  801e5d:	89 e5                	mov    %esp,%ebp
  801e5f:	83 ec 18             	sub    $0x18,%esp
	int idxInPageInfoArr = (va - dynAllocStart) >> PGSHIFT;
  801e62:	a1 64 c0 81 00       	mov    0x81c064,%eax
  801e67:	8b 55 08             	mov    0x8(%ebp),%edx
  801e6a:	29 c2                	sub    %eax,%edx
  801e6c:	89 d0                	mov    %edx,%eax
  801e6e:	c1 e8 0c             	shr    $0xc,%eax
  801e71:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if (idxInPageInfoArr < 0 || idxInPageInfoArr >= DYN_ALLOC_MAX_SIZE/PAGE_SIZE)
  801e74:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801e78:	78 09                	js     801e83 <to_page_info+0x27>
  801e7a:	81 7d f4 ff 1f 00 00 	cmpl   $0x1fff,-0xc(%ebp)
  801e81:	7e 14                	jle    801e97 <to_page_info+0x3b>
		panic("to_page_info called with invalid pa");
  801e83:	83 ec 04             	sub    $0x4,%esp
  801e86:	68 1c 35 80 00       	push   $0x80351c
  801e8b:	6a 22                	push   $0x22
  801e8d:	68 03 35 80 00       	push   $0x803503
  801e92:	e8 6d 0a 00 00       	call   802904 <_panic>
	return &pageBlockInfoArr[idxInPageInfoArr];
  801e97:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801e9a:	89 d0                	mov    %edx,%eax
  801e9c:	01 c0                	add    %eax,%eax
  801e9e:	01 d0                	add    %edx,%eax
  801ea0:	c1 e0 02             	shl    $0x2,%eax
  801ea3:	05 60 40 80 00       	add    $0x804060,%eax
}
  801ea8:	c9                   	leave  
  801ea9:	c3                   	ret    

00801eaa <initialize_dynamic_allocator>:
//==================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================
bool is_initialized = 0;
void initialize_dynamic_allocator(uint32 daStart, uint32 daEnd)
{
  801eaa:	55                   	push   %ebp
  801eab:	89 e5                	mov    %esp,%ebp
  801ead:	83 ec 18             	sub    $0x18,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		assert(daEnd <= daStart + DYN_ALLOC_MAX_SIZE);
  801eb0:	8b 45 08             	mov    0x8(%ebp),%eax
  801eb3:	05 00 00 00 02       	add    $0x2000000,%eax
  801eb8:	3b 45 0c             	cmp    0xc(%ebp),%eax
  801ebb:	73 16                	jae    801ed3 <initialize_dynamic_allocator+0x29>
  801ebd:	68 40 35 80 00       	push   $0x803540
  801ec2:	68 66 35 80 00       	push   $0x803566
  801ec7:	6a 34                	push   $0x34
  801ec9:	68 03 35 80 00       	push   $0x803503
  801ece:	e8 31 0a 00 00       	call   802904 <_panic>
		is_initialized = 1;
  801ed3:	c7 05 24 40 80 00 01 	movl   $0x1,0x804024
  801eda:	00 00 00 
	//==================================================================================
	//==================================================================================
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #1 initialize_dynamic_allocator
	//Your code is here
	// init bounds of the dynalloc
	dynAllocStart = daStart;
  801edd:	8b 45 08             	mov    0x8(%ebp),%eax
  801ee0:	a3 64 c0 81 00       	mov    %eax,0x81c064
	dynAllocEnd = daEnd;
  801ee5:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ee8:	a3 40 40 80 00       	mov    %eax,0x804040
	// init the list that keep track of all free pageBlockInfoArr instances.
	LIST_INIT(&freePagesList);
  801eed:	c7 05 48 40 80 00 00 	movl   $0x0,0x804048
  801ef4:	00 00 00 
  801ef7:	c7 05 4c 40 80 00 00 	movl   $0x0,0x80404c
  801efe:	00 00 00 
  801f01:	c7 05 54 40 80 00 00 	movl   $0x0,0x804054
  801f08:	00 00 00 

	// no.of pages in the dynamic allocator.
	int pCount = (daEnd - daStart) / PAGE_SIZE;
  801f0b:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f0e:	2b 45 08             	sub    0x8(%ebp),%eax
  801f11:	c1 e8 0c             	shr    $0xc,%eax
  801f14:	89 45 ec             	mov    %eax,-0x14(%ebp)
	// iterate over each page and init its data in pageBlockInfoArr and reset it.
	for (int i = 0; i < pCount; ++i) {
  801f17:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  801f1e:	e9 c8 00 00 00       	jmp    801feb <initialize_dynamic_allocator+0x141>
	    pageBlockInfoArr[i].block_size = 0;
  801f23:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801f26:	89 d0                	mov    %edx,%eax
  801f28:	01 c0                	add    %eax,%eax
  801f2a:	01 d0                	add    %edx,%eax
  801f2c:	c1 e0 02             	shl    $0x2,%eax
  801f2f:	05 68 40 80 00       	add    $0x804068,%eax
  801f34:	66 c7 00 00 00       	movw   $0x0,(%eax)
	    pageBlockInfoArr[i].num_of_free_blocks = 0;
  801f39:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801f3c:	89 d0                	mov    %edx,%eax
  801f3e:	01 c0                	add    %eax,%eax
  801f40:	01 d0                	add    %edx,%eax
  801f42:	c1 e0 02             	shl    $0x2,%eax
  801f45:	05 6a 40 80 00       	add    $0x80406a,%eax
  801f4a:	66 c7 00 00 00       	movw   $0x0,(%eax)
	    LIST_INSERT_TAIL(&freePagesList, &pageBlockInfoArr[i]);
  801f4f:	8b 15 4c 40 80 00    	mov    0x80404c,%edx
  801f55:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  801f58:	89 c8                	mov    %ecx,%eax
  801f5a:	01 c0                	add    %eax,%eax
  801f5c:	01 c8                	add    %ecx,%eax
  801f5e:	c1 e0 02             	shl    $0x2,%eax
  801f61:	05 64 40 80 00       	add    $0x804064,%eax
  801f66:	89 10                	mov    %edx,(%eax)
  801f68:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801f6b:	89 d0                	mov    %edx,%eax
  801f6d:	01 c0                	add    %eax,%eax
  801f6f:	01 d0                	add    %edx,%eax
  801f71:	c1 e0 02             	shl    $0x2,%eax
  801f74:	05 64 40 80 00       	add    $0x804064,%eax
  801f79:	8b 00                	mov    (%eax),%eax
  801f7b:	85 c0                	test   %eax,%eax
  801f7d:	74 1b                	je     801f9a <initialize_dynamic_allocator+0xf0>
  801f7f:	8b 15 4c 40 80 00    	mov    0x80404c,%edx
  801f85:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  801f88:	89 c8                	mov    %ecx,%eax
  801f8a:	01 c0                	add    %eax,%eax
  801f8c:	01 c8                	add    %ecx,%eax
  801f8e:	c1 e0 02             	shl    $0x2,%eax
  801f91:	05 60 40 80 00       	add    $0x804060,%eax
  801f96:	89 02                	mov    %eax,(%edx)
  801f98:	eb 16                	jmp    801fb0 <initialize_dynamic_allocator+0x106>
  801f9a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801f9d:	89 d0                	mov    %edx,%eax
  801f9f:	01 c0                	add    %eax,%eax
  801fa1:	01 d0                	add    %edx,%eax
  801fa3:	c1 e0 02             	shl    $0x2,%eax
  801fa6:	05 60 40 80 00       	add    $0x804060,%eax
  801fab:	a3 48 40 80 00       	mov    %eax,0x804048
  801fb0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801fb3:	89 d0                	mov    %edx,%eax
  801fb5:	01 c0                	add    %eax,%eax
  801fb7:	01 d0                	add    %edx,%eax
  801fb9:	c1 e0 02             	shl    $0x2,%eax
  801fbc:	05 60 40 80 00       	add    $0x804060,%eax
  801fc1:	a3 4c 40 80 00       	mov    %eax,0x80404c
  801fc6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801fc9:	89 d0                	mov    %edx,%eax
  801fcb:	01 c0                	add    %eax,%eax
  801fcd:	01 d0                	add    %edx,%eax
  801fcf:	c1 e0 02             	shl    $0x2,%eax
  801fd2:	05 60 40 80 00       	add    $0x804060,%eax
  801fd7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801fdd:	a1 54 40 80 00       	mov    0x804054,%eax
  801fe2:	40                   	inc    %eax
  801fe3:	a3 54 40 80 00       	mov    %eax,0x804054
	LIST_INIT(&freePagesList);

	// no.of pages in the dynamic allocator.
	int pCount = (daEnd - daStart) / PAGE_SIZE;
	// iterate over each page and init its data in pageBlockInfoArr and reset it.
	for (int i = 0; i < pCount; ++i) {
  801fe8:	ff 45 f4             	incl   -0xc(%ebp)
  801feb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fee:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  801ff1:	0f 8c 2c ff ff ff    	jl     801f23 <initialize_dynamic_allocator+0x79>
	    LIST_INSERT_TAIL(&freePagesList, &pageBlockInfoArr[i]);
	}
	// init the array of lists of each size..
	// 8 16 32 64 128 256 512 1024 2056
	// 0 1  2  3   4  5    6   7    8
	for (int i = 0; i <= (LOG2_MAX_SIZE - LOG2_MIN_SIZE); ++i){
  801ff7:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  801ffe:	eb 36                	jmp    802036 <initialize_dynamic_allocator+0x18c>
		LIST_INIT(&freeBlockLists[i]);
  802000:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802003:	c1 e0 04             	shl    $0x4,%eax
  802006:	05 80 c0 81 00       	add    $0x81c080,%eax
  80200b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802011:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802014:	c1 e0 04             	shl    $0x4,%eax
  802017:	05 84 c0 81 00       	add    $0x81c084,%eax
  80201c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802022:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802025:	c1 e0 04             	shl    $0x4,%eax
  802028:	05 8c c0 81 00       	add    $0x81c08c,%eax
  80202d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	    LIST_INSERT_TAIL(&freePagesList, &pageBlockInfoArr[i]);
	}
	// init the array of lists of each size..
	// 8 16 32 64 128 256 512 1024 2056
	// 0 1  2  3   4  5    6   7    8
	for (int i = 0; i <= (LOG2_MAX_SIZE - LOG2_MIN_SIZE); ++i){
  802033:	ff 45 f0             	incl   -0x10(%ebp)
  802036:	83 7d f0 08          	cmpl   $0x8,-0x10(%ebp)
  80203a:	7e c4                	jle    802000 <initialize_dynamic_allocator+0x156>
		LIST_INIT(&freeBlockLists[i]);
	}
	//Comment the following line
	//panic("initialize_dynamic_allocator() Not implemented yet");

}
  80203c:	90                   	nop
  80203d:	c9                   	leave  
  80203e:	c3                   	ret    

0080203f <get_block_size>:

//===========================
// [2] GET BLOCK SIZE:
//===========================
__inline__ uint32 get_block_size(void *va)
{
  80203f:	55                   	push   %ebp
  802040:	89 e5                	mov    %esp,%ebp
  802042:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #2 get_block_size
	//Your code is here
	// get the page that saves this va
	struct PageInfoElement* ptr = to_page_info((uint32)va);
  802045:	8b 45 08             	mov    0x8(%ebp),%eax
  802048:	83 ec 0c             	sub    $0xc,%esp
  80204b:	50                   	push   %eax
  80204c:	e8 0b fe ff ff       	call   801e5c <to_page_info>
  802051:	83 c4 10             	add    $0x10,%esp
  802054:	89 45 f4             	mov    %eax,-0xc(%ebp)
	return ptr->block_size;
  802057:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80205a:	8b 40 08             	mov    0x8(%eax),%eax
  80205d:	0f b7 c0             	movzwl %ax,%eax
	//Comment the following line
	//panic("get_block_size() Not implemented yet");
}
  802060:	c9                   	leave  
  802061:	c3                   	ret    

00802062 <split_page_to_blocks>:
// =====================
// h) split page to blocks and add them in freeBlockLists
// =====================
// function that split the page provided into same sized blocks
//and putem in suitable freeblockList index according to size.
 void split_page_to_blocks(uint32 blk_size, struct PageInfoElement *pageInfo) {
  802062:	55                   	push   %ebp
  802063:	89 e5                	mov    %esp,%ebp
  802065:	83 ec 28             	sub    $0x28,%esp
	 // cur page virtual address by the pageInfo.
	 uint32 page_va = (uint32)to_page_va(pageInfo);
  802068:	83 ec 0c             	sub    $0xc,%esp
  80206b:	ff 75 0c             	pushl  0xc(%ebp)
  80206e:	e8 77 fd ff ff       	call   801dea <to_page_va>
  802073:	83 c4 10             	add    $0x10,%esp
  802076:	89 45 e8             	mov    %eax,-0x18(%ebp)
	 // no. of blks to save in freeblockList.
	 int blk_count = PAGE_SIZE / blk_size;
  802079:	b8 00 10 00 00       	mov    $0x1000,%eax
  80207e:	ba 00 00 00 00       	mov    $0x0,%edx
  802083:	f7 75 08             	divl   0x8(%ebp)
  802086:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	 // save page in memory.
	 get_page((uint32*)page_va);
  802089:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80208c:	83 ec 0c             	sub    $0xc,%esp
  80208f:	50                   	push   %eax
  802090:	e8 48 f6 ff ff       	call   8016dd <get_page>
  802095:	83 c4 10             	add    $0x10,%esp
	 // assigning the pageInfo data block size, free block which is whole block count.
	 pageInfo->num_of_free_blocks = blk_count;
  802098:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80209b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80209e:	66 89 42 0a          	mov    %ax,0xa(%edx)
	 pageInfo->block_size = blk_size;
  8020a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8020a5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8020a8:	66 89 42 08          	mov    %ax,0x8(%edx)
	 // get index by size block in freeblocklist.
	 int idx = 0;
  8020ac:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	 for (int i = LOG2_MIN_SIZE; i <= LOG2_MAX_SIZE; i++) {
  8020b3:	c7 45 f0 03 00 00 00 	movl   $0x3,-0x10(%ebp)
  8020ba:	eb 19                	jmp    8020d5 <split_page_to_blocks+0x73>
	     if ((1 << i) == blk_size)
  8020bc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8020bf:	ba 01 00 00 00       	mov    $0x1,%edx
  8020c4:	88 c1                	mov    %al,%cl
  8020c6:	d3 e2                	shl    %cl,%edx
  8020c8:	89 d0                	mov    %edx,%eax
  8020ca:	3b 45 08             	cmp    0x8(%ebp),%eax
  8020cd:	74 0e                	je     8020dd <split_page_to_blocks+0x7b>
	         break;
	     idx++;
  8020cf:	ff 45 f4             	incl   -0xc(%ebp)
	 // assigning the pageInfo data block size, free block which is whole block count.
	 pageInfo->num_of_free_blocks = blk_count;
	 pageInfo->block_size = blk_size;
	 // get index by size block in freeblocklist.
	 int idx = 0;
	 for (int i = LOG2_MIN_SIZE; i <= LOG2_MAX_SIZE; i++) {
  8020d2:	ff 45 f0             	incl   -0x10(%ebp)
  8020d5:	83 7d f0 0b          	cmpl   $0xb,-0x10(%ebp)
  8020d9:	7e e1                	jle    8020bc <split_page_to_blocks+0x5a>
  8020db:	eb 01                	jmp    8020de <split_page_to_blocks+0x7c>
	     if ((1 << i) == blk_size)
	         break;
  8020dd:	90                   	nop
	     idx++;
	 }
	 // iterate over each blk and make and element of it by passing its address in blockElement pointer and save those in the list.
	 // starting from the page_va.
	 for (uint32 i = 0; i < blk_count; ++i) {
  8020de:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  8020e5:	e9 a7 00 00 00       	jmp    802191 <split_page_to_blocks+0x12f>
	     struct BlockElement *blk =(struct BlockElement*)(page_va + i * blk_size);
  8020ea:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8020ed:	0f af 45 08          	imul   0x8(%ebp),%eax
  8020f1:	89 c2                	mov    %eax,%edx
  8020f3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8020f6:	01 d0                	add    %edx,%eax
  8020f8:	89 45 e0             	mov    %eax,-0x20(%ebp)
	     LIST_INSERT_TAIL(&freeBlockLists[idx],blk);
  8020fb:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8020ff:	75 14                	jne    802115 <split_page_to_blocks+0xb3>
  802101:	83 ec 04             	sub    $0x4,%esp
  802104:	68 7c 35 80 00       	push   $0x80357c
  802109:	6a 7c                	push   $0x7c
  80210b:	68 03 35 80 00       	push   $0x803503
  802110:	e8 ef 07 00 00       	call   802904 <_panic>
  802115:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802118:	c1 e0 04             	shl    $0x4,%eax
  80211b:	05 84 c0 81 00       	add    $0x81c084,%eax
  802120:	8b 10                	mov    (%eax),%edx
  802122:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802125:	89 50 04             	mov    %edx,0x4(%eax)
  802128:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80212b:	8b 40 04             	mov    0x4(%eax),%eax
  80212e:	85 c0                	test   %eax,%eax
  802130:	74 14                	je     802146 <split_page_to_blocks+0xe4>
  802132:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802135:	c1 e0 04             	shl    $0x4,%eax
  802138:	05 84 c0 81 00       	add    $0x81c084,%eax
  80213d:	8b 00                	mov    (%eax),%eax
  80213f:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802142:	89 10                	mov    %edx,(%eax)
  802144:	eb 11                	jmp    802157 <split_page_to_blocks+0xf5>
  802146:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802149:	c1 e0 04             	shl    $0x4,%eax
  80214c:	8d 90 80 c0 81 00    	lea    0x81c080(%eax),%edx
  802152:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802155:	89 02                	mov    %eax,(%edx)
  802157:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80215a:	c1 e0 04             	shl    $0x4,%eax
  80215d:	8d 90 84 c0 81 00    	lea    0x81c084(%eax),%edx
  802163:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802166:	89 02                	mov    %eax,(%edx)
  802168:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80216b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802171:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802174:	c1 e0 04             	shl    $0x4,%eax
  802177:	05 8c c0 81 00       	add    $0x81c08c,%eax
  80217c:	8b 00                	mov    (%eax),%eax
  80217e:	8d 50 01             	lea    0x1(%eax),%edx
  802181:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802184:	c1 e0 04             	shl    $0x4,%eax
  802187:	05 8c c0 81 00       	add    $0x81c08c,%eax
  80218c:	89 10                	mov    %edx,(%eax)
	         break;
	     idx++;
	 }
	 // iterate over each blk and make and element of it by passing its address in blockElement pointer and save those in the list.
	 // starting from the page_va.
	 for (uint32 i = 0; i < blk_count; ++i) {
  80218e:	ff 45 ec             	incl   -0x14(%ebp)
  802191:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802194:	39 45 ec             	cmp    %eax,-0x14(%ebp)
  802197:	0f 82 4d ff ff ff    	jb     8020ea <split_page_to_blocks+0x88>
	     struct BlockElement *blk =(struct BlockElement*)(page_va + i * blk_size);
	     LIST_INSERT_TAIL(&freeBlockLists[idx],blk);
	 }
 }
  80219d:	90                   	nop
  80219e:	c9                   	leave  
  80219f:	c3                   	ret    

008021a0 <alloc_block>:

//===========================
// 3) ALLOCATE BLOCK:
//===========================
void *alloc_block(uint32 size)
{
  8021a0:	55                   	push   %ebp
  8021a1:	89 e5                	mov    %esp,%ebp
  8021a3:	83 ec 38             	sub    $0x38,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		assert(size <= DYN_ALLOC_MAX_BLOCK_SIZE);
  8021a6:	81 7d 08 00 08 00 00 	cmpl   $0x800,0x8(%ebp)
  8021ad:	76 19                	jbe    8021c8 <alloc_block+0x28>
  8021af:	68 a0 35 80 00       	push   $0x8035a0
  8021b4:	68 66 35 80 00       	push   $0x803566
  8021b9:	68 8a 00 00 00       	push   $0x8a
  8021be:	68 03 35 80 00       	push   $0x803503
  8021c3:	e8 3c 07 00 00       	call   802904 <_panic>
	//==================================================================================
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #3 alloc_block
	//Your code is here
	//Comment the following line
	// get index in freeBlockList by size.
	uint32 idx = 0;
  8021c8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int i = LOG2_MIN_SIZE; i <= LOG2_MAX_SIZE; ++i){
  8021cf:	c7 45 f0 03 00 00 00 	movl   $0x3,-0x10(%ebp)
  8021d6:	eb 19                	jmp    8021f1 <alloc_block+0x51>
		if((1 << i) >= size) break;
  8021d8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8021db:	ba 01 00 00 00       	mov    $0x1,%edx
  8021e0:	88 c1                	mov    %al,%cl
  8021e2:	d3 e2                	shl    %cl,%edx
  8021e4:	89 d0                	mov    %edx,%eax
  8021e6:	3b 45 08             	cmp    0x8(%ebp),%eax
  8021e9:	73 0e                	jae    8021f9 <alloc_block+0x59>
		idx++;
  8021eb:	ff 45 f4             	incl   -0xc(%ebp)
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #3 alloc_block
	//Your code is here
	//Comment the following line
	// get index in freeBlockList by size.
	uint32 idx = 0;
	for (int i = LOG2_MIN_SIZE; i <= LOG2_MAX_SIZE; ++i){
  8021ee:	ff 45 f0             	incl   -0x10(%ebp)
  8021f1:	83 7d f0 0b          	cmpl   $0xb,-0x10(%ebp)
  8021f5:	7e e1                	jle    8021d8 <alloc_block+0x38>
  8021f7:	eb 01                	jmp    8021fa <alloc_block+0x5a>
		if((1 << i) >= size) break;
  8021f9:	90                   	nop
		idx++;
	}

	//case 1: the free block of the cur size is available.
	if (freeBlockLists[idx].size > 0) {
  8021fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021fd:	c1 e0 04             	shl    $0x4,%eax
  802200:	05 8c c0 81 00       	add    $0x81c08c,%eax
  802205:	8b 00                	mov    (%eax),%eax
  802207:	85 c0                	test   %eax,%eax
  802209:	0f 84 df 00 00 00    	je     8022ee <alloc_block+0x14e>

		// remove from the list and updat the pageInfoArr free blocks.
		// pop from the freeBlockList.
		struct BlockElement *blk = LIST_FIRST(&freeBlockLists[idx]);
  80220f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802212:	c1 e0 04             	shl    $0x4,%eax
  802215:	05 80 c0 81 00       	add    $0x81c080,%eax
  80221a:	8b 00                	mov    (%eax),%eax
  80221c:	89 45 ec             	mov    %eax,-0x14(%ebp)
	    LIST_REMOVE(&freeBlockLists[idx], blk);
  80221f:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802223:	75 17                	jne    80223c <alloc_block+0x9c>
  802225:	83 ec 04             	sub    $0x4,%esp
  802228:	68 c1 35 80 00       	push   $0x8035c1
  80222d:	68 9e 00 00 00       	push   $0x9e
  802232:	68 03 35 80 00       	push   $0x803503
  802237:	e8 c8 06 00 00       	call   802904 <_panic>
  80223c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80223f:	8b 00                	mov    (%eax),%eax
  802241:	85 c0                	test   %eax,%eax
  802243:	74 10                	je     802255 <alloc_block+0xb5>
  802245:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802248:	8b 00                	mov    (%eax),%eax
  80224a:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80224d:	8b 52 04             	mov    0x4(%edx),%edx
  802250:	89 50 04             	mov    %edx,0x4(%eax)
  802253:	eb 14                	jmp    802269 <alloc_block+0xc9>
  802255:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802258:	8b 40 04             	mov    0x4(%eax),%eax
  80225b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80225e:	c1 e2 04             	shl    $0x4,%edx
  802261:	81 c2 84 c0 81 00    	add    $0x81c084,%edx
  802267:	89 02                	mov    %eax,(%edx)
  802269:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80226c:	8b 40 04             	mov    0x4(%eax),%eax
  80226f:	85 c0                	test   %eax,%eax
  802271:	74 0f                	je     802282 <alloc_block+0xe2>
  802273:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802276:	8b 40 04             	mov    0x4(%eax),%eax
  802279:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80227c:	8b 12                	mov    (%edx),%edx
  80227e:	89 10                	mov    %edx,(%eax)
  802280:	eb 13                	jmp    802295 <alloc_block+0xf5>
  802282:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802285:	8b 00                	mov    (%eax),%eax
  802287:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80228a:	c1 e2 04             	shl    $0x4,%edx
  80228d:	81 c2 80 c0 81 00    	add    $0x81c080,%edx
  802293:	89 02                	mov    %eax,(%edx)
  802295:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802298:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80229e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8022a1:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8022a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022ab:	c1 e0 04             	shl    $0x4,%eax
  8022ae:	05 8c c0 81 00       	add    $0x81c08c,%eax
  8022b3:	8b 00                	mov    (%eax),%eax
  8022b5:	8d 50 ff             	lea    -0x1(%eax),%edx
  8022b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022bb:	c1 e0 04             	shl    $0x4,%eax
  8022be:	05 8c c0 81 00       	add    $0x81c08c,%eax
  8022c3:	89 10                	mov    %edx,(%eax)
	    // update pageBlockInfoArr
	    struct PageInfoElement *pageInfo = to_page_info((uint32)blk);
  8022c5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8022c8:	83 ec 0c             	sub    $0xc,%esp
  8022cb:	50                   	push   %eax
  8022cc:	e8 8b fb ff ff       	call   801e5c <to_page_info>
  8022d1:	83 c4 10             	add    $0x10,%esp
  8022d4:	89 45 e8             	mov    %eax,-0x18(%ebp)
	    pageInfo->num_of_free_blocks--;
  8022d7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8022da:	66 8b 40 0a          	mov    0xa(%eax),%ax
  8022de:	48                   	dec    %eax
  8022df:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8022e2:	66 89 42 0a          	mov    %ax,0xa(%edx)
	    return blk;
  8022e6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8022e9:	e9 bc 02 00 00       	jmp    8025aa <alloc_block+0x40a>
	}else{ //case(2, 3): 2. no free blocks available in the freeblocklist but there is free pages.
				//3. no free blocks and no available freepages so search in higher block sizes.
		// case 2:
		if(freePagesList.size > 0){ //have free pages.
  8022ee:	a1 54 40 80 00       	mov    0x804054,%eax
  8022f3:	85 c0                	test   %eax,%eax
  8022f5:	0f 84 7d 02 00 00    	je     802578 <alloc_block+0x3d8>
			// get page to split and use from freepagesList.
			struct PageInfoElement *ptr_new_page = LIST_FIRST(&freePagesList);
  8022fb:	a1 48 40 80 00       	mov    0x804048,%eax
  802300:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			LIST_REMOVE(&freePagesList, ptr_new_page);
  802303:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  802307:	75 17                	jne    802320 <alloc_block+0x180>
  802309:	83 ec 04             	sub    $0x4,%esp
  80230c:	68 c1 35 80 00       	push   $0x8035c1
  802311:	68 a9 00 00 00       	push   $0xa9
  802316:	68 03 35 80 00       	push   $0x803503
  80231b:	e8 e4 05 00 00       	call   802904 <_panic>
  802320:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802323:	8b 00                	mov    (%eax),%eax
  802325:	85 c0                	test   %eax,%eax
  802327:	74 10                	je     802339 <alloc_block+0x199>
  802329:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80232c:	8b 00                	mov    (%eax),%eax
  80232e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802331:	8b 52 04             	mov    0x4(%edx),%edx
  802334:	89 50 04             	mov    %edx,0x4(%eax)
  802337:	eb 0b                	jmp    802344 <alloc_block+0x1a4>
  802339:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80233c:	8b 40 04             	mov    0x4(%eax),%eax
  80233f:	a3 4c 40 80 00       	mov    %eax,0x80404c
  802344:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802347:	8b 40 04             	mov    0x4(%eax),%eax
  80234a:	85 c0                	test   %eax,%eax
  80234c:	74 0f                	je     80235d <alloc_block+0x1bd>
  80234e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802351:	8b 40 04             	mov    0x4(%eax),%eax
  802354:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802357:	8b 12                	mov    (%edx),%edx
  802359:	89 10                	mov    %edx,(%eax)
  80235b:	eb 0a                	jmp    802367 <alloc_block+0x1c7>
  80235d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802360:	8b 00                	mov    (%eax),%eax
  802362:	a3 48 40 80 00       	mov    %eax,0x804048
  802367:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80236a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802370:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802373:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80237a:	a1 54 40 80 00       	mov    0x804054,%eax
  80237f:	48                   	dec    %eax
  802380:	a3 54 40 80 00       	mov    %eax,0x804054
			// from page to freeblockList by the pageInfo and the block size.
			split_page_to_blocks(1 << (idx + LOG2_MIN_SIZE), ptr_new_page);
  802385:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802388:	83 c0 03             	add    $0x3,%eax
  80238b:	ba 01 00 00 00       	mov    $0x1,%edx
  802390:	88 c1                	mov    %al,%cl
  802392:	d3 e2                	shl    %cl,%edx
  802394:	89 d0                	mov    %edx,%eax
  802396:	83 ec 08             	sub    $0x8,%esp
  802399:	ff 75 e4             	pushl  -0x1c(%ebp)
  80239c:	50                   	push   %eax
  80239d:	e8 c0 fc ff ff       	call   802062 <split_page_to_blocks>
  8023a2:	83 c4 10             	add    $0x10,%esp

			// remove from the list and updat the pageInfoArr free blocks.
			// pop from the freeBlockList.
			struct BlockElement *blk = LIST_FIRST(&freeBlockLists[idx]);
  8023a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023a8:	c1 e0 04             	shl    $0x4,%eax
  8023ab:	05 80 c0 81 00       	add    $0x81c080,%eax
  8023b0:	8b 00                	mov    (%eax),%eax
  8023b2:	89 45 e0             	mov    %eax,-0x20(%ebp)
		    LIST_REMOVE(&freeBlockLists[idx], blk);
  8023b5:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8023b9:	75 17                	jne    8023d2 <alloc_block+0x232>
  8023bb:	83 ec 04             	sub    $0x4,%esp
  8023be:	68 c1 35 80 00       	push   $0x8035c1
  8023c3:	68 b0 00 00 00       	push   $0xb0
  8023c8:	68 03 35 80 00       	push   $0x803503
  8023cd:	e8 32 05 00 00       	call   802904 <_panic>
  8023d2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8023d5:	8b 00                	mov    (%eax),%eax
  8023d7:	85 c0                	test   %eax,%eax
  8023d9:	74 10                	je     8023eb <alloc_block+0x24b>
  8023db:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8023de:	8b 00                	mov    (%eax),%eax
  8023e0:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8023e3:	8b 52 04             	mov    0x4(%edx),%edx
  8023e6:	89 50 04             	mov    %edx,0x4(%eax)
  8023e9:	eb 14                	jmp    8023ff <alloc_block+0x25f>
  8023eb:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8023ee:	8b 40 04             	mov    0x4(%eax),%eax
  8023f1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8023f4:	c1 e2 04             	shl    $0x4,%edx
  8023f7:	81 c2 84 c0 81 00    	add    $0x81c084,%edx
  8023fd:	89 02                	mov    %eax,(%edx)
  8023ff:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802402:	8b 40 04             	mov    0x4(%eax),%eax
  802405:	85 c0                	test   %eax,%eax
  802407:	74 0f                	je     802418 <alloc_block+0x278>
  802409:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80240c:	8b 40 04             	mov    0x4(%eax),%eax
  80240f:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802412:	8b 12                	mov    (%edx),%edx
  802414:	89 10                	mov    %edx,(%eax)
  802416:	eb 13                	jmp    80242b <alloc_block+0x28b>
  802418:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80241b:	8b 00                	mov    (%eax),%eax
  80241d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802420:	c1 e2 04             	shl    $0x4,%edx
  802423:	81 c2 80 c0 81 00    	add    $0x81c080,%edx
  802429:	89 02                	mov    %eax,(%edx)
  80242b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80242e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802434:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802437:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80243e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802441:	c1 e0 04             	shl    $0x4,%eax
  802444:	05 8c c0 81 00       	add    $0x81c08c,%eax
  802449:	8b 00                	mov    (%eax),%eax
  80244b:	8d 50 ff             	lea    -0x1(%eax),%edx
  80244e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802451:	c1 e0 04             	shl    $0x4,%eax
  802454:	05 8c c0 81 00       	add    $0x81c08c,%eax
  802459:	89 10                	mov    %edx,(%eax)
		    // update pageBlockInfoArr
		    struct PageInfoElement *pageInfo = to_page_info((uint32)blk);
  80245b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80245e:	83 ec 0c             	sub    $0xc,%esp
  802461:	50                   	push   %eax
  802462:	e8 f5 f9 ff ff       	call   801e5c <to_page_info>
  802467:	83 c4 10             	add    $0x10,%esp
  80246a:	89 45 dc             	mov    %eax,-0x24(%ebp)
		    pageInfo->num_of_free_blocks--;
  80246d:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802470:	66 8b 40 0a          	mov    0xa(%eax),%ax
  802474:	48                   	dec    %eax
  802475:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802478:	66 89 42 0a          	mov    %ax,0xa(%edx)
		    return blk;
  80247c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80247f:	e9 26 01 00 00       	jmp    8025aa <alloc_block+0x40a>
		}else{//case 3: no free block and no free page so iterate and try to find bigger size.
			// iterate over the list until finding available block
			while (idx <= (LOG2_MAX_SIZE - LOG2_MIN_SIZE) && freeBlockLists[idx].size == 0) {
				idx++;
  802484:	ff 45 f4             	incl   -0xc(%ebp)
				// found free block
				if(freeBlockLists[idx].size > 0){
  802487:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80248a:	c1 e0 04             	shl    $0x4,%eax
  80248d:	05 8c c0 81 00       	add    $0x81c08c,%eax
  802492:	8b 00                	mov    (%eax),%eax
  802494:	85 c0                	test   %eax,%eax
  802496:	0f 84 dc 00 00 00    	je     802578 <alloc_block+0x3d8>
					// remove from the list and updat the pageInfoArr free blocks.
					// pop from the freeBlockList.
					struct BlockElement *blk = LIST_FIRST(&freeBlockLists[idx]);
  80249c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80249f:	c1 e0 04             	shl    $0x4,%eax
  8024a2:	05 80 c0 81 00       	add    $0x81c080,%eax
  8024a7:	8b 00                	mov    (%eax),%eax
  8024a9:	89 45 d8             	mov    %eax,-0x28(%ebp)
				    LIST_REMOVE(&freeBlockLists[idx], blk);
  8024ac:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8024b0:	75 17                	jne    8024c9 <alloc_block+0x329>
  8024b2:	83 ec 04             	sub    $0x4,%esp
  8024b5:	68 c1 35 80 00       	push   $0x8035c1
  8024ba:	68 be 00 00 00       	push   $0xbe
  8024bf:	68 03 35 80 00       	push   $0x803503
  8024c4:	e8 3b 04 00 00       	call   802904 <_panic>
  8024c9:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8024cc:	8b 00                	mov    (%eax),%eax
  8024ce:	85 c0                	test   %eax,%eax
  8024d0:	74 10                	je     8024e2 <alloc_block+0x342>
  8024d2:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8024d5:	8b 00                	mov    (%eax),%eax
  8024d7:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8024da:	8b 52 04             	mov    0x4(%edx),%edx
  8024dd:	89 50 04             	mov    %edx,0x4(%eax)
  8024e0:	eb 14                	jmp    8024f6 <alloc_block+0x356>
  8024e2:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8024e5:	8b 40 04             	mov    0x4(%eax),%eax
  8024e8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8024eb:	c1 e2 04             	shl    $0x4,%edx
  8024ee:	81 c2 84 c0 81 00    	add    $0x81c084,%edx
  8024f4:	89 02                	mov    %eax,(%edx)
  8024f6:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8024f9:	8b 40 04             	mov    0x4(%eax),%eax
  8024fc:	85 c0                	test   %eax,%eax
  8024fe:	74 0f                	je     80250f <alloc_block+0x36f>
  802500:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802503:	8b 40 04             	mov    0x4(%eax),%eax
  802506:	8b 55 d8             	mov    -0x28(%ebp),%edx
  802509:	8b 12                	mov    (%edx),%edx
  80250b:	89 10                	mov    %edx,(%eax)
  80250d:	eb 13                	jmp    802522 <alloc_block+0x382>
  80250f:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802512:	8b 00                	mov    (%eax),%eax
  802514:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802517:	c1 e2 04             	shl    $0x4,%edx
  80251a:	81 c2 80 c0 81 00    	add    $0x81c080,%edx
  802520:	89 02                	mov    %eax,(%edx)
  802522:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802525:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80252b:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80252e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802535:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802538:	c1 e0 04             	shl    $0x4,%eax
  80253b:	05 8c c0 81 00       	add    $0x81c08c,%eax
  802540:	8b 00                	mov    (%eax),%eax
  802542:	8d 50 ff             	lea    -0x1(%eax),%edx
  802545:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802548:	c1 e0 04             	shl    $0x4,%eax
  80254b:	05 8c c0 81 00       	add    $0x81c08c,%eax
  802550:	89 10                	mov    %edx,(%eax)
				    // update pageBlockInfoArr
				    struct PageInfoElement *pageInfo = to_page_info((uint32)blk);
  802552:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802555:	83 ec 0c             	sub    $0xc,%esp
  802558:	50                   	push   %eax
  802559:	e8 fe f8 ff ff       	call   801e5c <to_page_info>
  80255e:	83 c4 10             	add    $0x10,%esp
  802561:	89 45 d4             	mov    %eax,-0x2c(%ebp)
				    pageInfo->num_of_free_blocks--;
  802564:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802567:	66 8b 40 0a          	mov    0xa(%eax),%ax
  80256b:	48                   	dec    %eax
  80256c:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  80256f:	66 89 42 0a          	mov    %ax,0xa(%edx)
				    return blk;
  802573:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802576:	eb 32                	jmp    8025aa <alloc_block+0x40a>
		    struct PageInfoElement *pageInfo = to_page_info((uint32)blk);
		    pageInfo->num_of_free_blocks--;
		    return blk;
		}else{//case 3: no free block and no free page so iterate and try to find bigger size.
			// iterate over the list until finding available block
			while (idx <= (LOG2_MAX_SIZE - LOG2_MIN_SIZE) && freeBlockLists[idx].size == 0) {
  802578:	83 7d f4 08          	cmpl   $0x8,-0xc(%ebp)
  80257c:	77 15                	ja     802593 <alloc_block+0x3f3>
  80257e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802581:	c1 e0 04             	shl    $0x4,%eax
  802584:	05 8c c0 81 00       	add    $0x81c08c,%eax
  802589:	8b 00                	mov    (%eax),%eax
  80258b:	85 c0                	test   %eax,%eax
  80258d:	0f 84 f1 fe ff ff    	je     802484 <alloc_block+0x2e4>
				}
			}
		}
	}
	//case4: no free blocks or pages.
	panic("no free blocks!");
  802593:	83 ec 04             	sub    $0x4,%esp
  802596:	68 df 35 80 00       	push   $0x8035df
  80259b:	68 c8 00 00 00       	push   $0xc8
  8025a0:	68 03 35 80 00       	push   $0x803503
  8025a5:	e8 5a 03 00 00       	call   802904 <_panic>
	//panic("alloc_block() Not implemented yet");
	//TODO: [PROJECT'25.BONUS#1] DYNAMIC ALLOCATOR - block if no free block
	return NULL;
}
  8025aa:	c9                   	leave  
  8025ab:	c3                   	ret    

008025ac <free_block>:

//===========================
// [4] FREE BLOCK:
//===========================
void free_block(void *va)
{
  8025ac:	55                   	push   %ebp
  8025ad:	89 e5                	mov    %esp,%ebp
  8025af:	83 ec 38             	sub    $0x38,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		assert((uint32)va >= dynAllocStart && (uint32)va < dynAllocEnd);
  8025b2:	8b 55 08             	mov    0x8(%ebp),%edx
  8025b5:	a1 64 c0 81 00       	mov    0x81c064,%eax
  8025ba:	39 c2                	cmp    %eax,%edx
  8025bc:	72 0c                	jb     8025ca <free_block+0x1e>
  8025be:	8b 55 08             	mov    0x8(%ebp),%edx
  8025c1:	a1 40 40 80 00       	mov    0x804040,%eax
  8025c6:	39 c2                	cmp    %eax,%edx
  8025c8:	72 19                	jb     8025e3 <free_block+0x37>
  8025ca:	68 f0 35 80 00       	push   $0x8035f0
  8025cf:	68 66 35 80 00       	push   $0x803566
  8025d4:	68 d7 00 00 00       	push   $0xd7
  8025d9:	68 03 35 80 00       	push   $0x803503
  8025de:	e8 21 03 00 00       	call   802904 <_panic>
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #4 free_block
	//Your code is here
	//Comment the following line
	// va of a piece in memory to free so:
	// 1. get its page, and make blk with this address to be put in the freeBlockList.
	struct BlockElement* blk_to_free = (struct BlockElement*)va;
  8025e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8025e6:	89 45 e8             	mov    %eax,-0x18(%ebp)
	struct PageInfoElement *pageInfo = to_page_info((uint32)va);
  8025e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8025ec:	83 ec 0c             	sub    $0xc,%esp
  8025ef:	50                   	push   %eax
  8025f0:	e8 67 f8 ff ff       	call   801e5c <to_page_info>
  8025f5:	83 c4 10             	add    $0x10,%esp
  8025f8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	uint32 blk_size = pageInfo->block_size;
  8025fb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8025fe:	8b 40 08             	mov    0x8(%eax),%eax
  802601:	0f b7 c0             	movzwl %ax,%eax
  802604:	89 45 e0             	mov    %eax,-0x20(%ebp)

	// its index in the freeBlocklist.
	int idx = 0;
  802607:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int i = LOG2_MIN_SIZE; i <= LOG2_MAX_SIZE; i++) {
  80260e:	c7 45 f0 03 00 00 00 	movl   $0x3,-0x10(%ebp)
  802615:	eb 19                	jmp    802630 <free_block+0x84>
	    if ((1 << i) == blk_size)
  802617:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80261a:	ba 01 00 00 00       	mov    $0x1,%edx
  80261f:	88 c1                	mov    %al,%cl
  802621:	d3 e2                	shl    %cl,%edx
  802623:	89 d0                	mov    %edx,%eax
  802625:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  802628:	74 0e                	je     802638 <free_block+0x8c>
	        break;
	    idx++;
  80262a:	ff 45 f4             	incl   -0xc(%ebp)
	struct PageInfoElement *pageInfo = to_page_info((uint32)va);
	uint32 blk_size = pageInfo->block_size;

	// its index in the freeBlocklist.
	int idx = 0;
	for (int i = LOG2_MIN_SIZE; i <= LOG2_MAX_SIZE; i++) {
  80262d:	ff 45 f0             	incl   -0x10(%ebp)
  802630:	83 7d f0 0b          	cmpl   $0xb,-0x10(%ebp)
  802634:	7e e1                	jle    802617 <free_block+0x6b>
  802636:	eb 01                	jmp    802639 <free_block+0x8d>
	    if ((1 << i) == blk_size)
	        break;
  802638:	90                   	nop
	    idx++;
	}

	pageInfo->num_of_free_blocks++;
  802639:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80263c:	66 8b 40 0a          	mov    0xa(%eax),%ax
  802640:	40                   	inc    %eax
  802641:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802644:	66 89 42 0a          	mov    %ax,0xa(%edx)
	LIST_INSERT_TAIL(&freeBlockLists[idx], blk_to_free);
  802648:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80264c:	75 17                	jne    802665 <free_block+0xb9>
  80264e:	83 ec 04             	sub    $0x4,%esp
  802651:	68 7c 35 80 00       	push   $0x80357c
  802656:	68 ee 00 00 00       	push   $0xee
  80265b:	68 03 35 80 00       	push   $0x803503
  802660:	e8 9f 02 00 00       	call   802904 <_panic>
  802665:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802668:	c1 e0 04             	shl    $0x4,%eax
  80266b:	05 84 c0 81 00       	add    $0x81c084,%eax
  802670:	8b 10                	mov    (%eax),%edx
  802672:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802675:	89 50 04             	mov    %edx,0x4(%eax)
  802678:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80267b:	8b 40 04             	mov    0x4(%eax),%eax
  80267e:	85 c0                	test   %eax,%eax
  802680:	74 14                	je     802696 <free_block+0xea>
  802682:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802685:	c1 e0 04             	shl    $0x4,%eax
  802688:	05 84 c0 81 00       	add    $0x81c084,%eax
  80268d:	8b 00                	mov    (%eax),%eax
  80268f:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802692:	89 10                	mov    %edx,(%eax)
  802694:	eb 11                	jmp    8026a7 <free_block+0xfb>
  802696:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802699:	c1 e0 04             	shl    $0x4,%eax
  80269c:	8d 90 80 c0 81 00    	lea    0x81c080(%eax),%edx
  8026a2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8026a5:	89 02                	mov    %eax,(%edx)
  8026a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026aa:	c1 e0 04             	shl    $0x4,%eax
  8026ad:	8d 90 84 c0 81 00    	lea    0x81c084(%eax),%edx
  8026b3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8026b6:	89 02                	mov    %eax,(%edx)
  8026b8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8026bb:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8026c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026c4:	c1 e0 04             	shl    $0x4,%eax
  8026c7:	05 8c c0 81 00       	add    $0x81c08c,%eax
  8026cc:	8b 00                	mov    (%eax),%eax
  8026ce:	8d 50 01             	lea    0x1(%eax),%edx
  8026d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026d4:	c1 e0 04             	shl    $0x4,%eax
  8026d7:	05 8c c0 81 00       	add    $0x81c08c,%eax
  8026dc:	89 10                	mov    %edx,(%eax)

	// now, case 1: the page all blocks are freed so you free the page.
	int blk_count = PAGE_SIZE / blk_size;
  8026de:	b8 00 10 00 00       	mov    $0x1000,%eax
  8026e3:	ba 00 00 00 00       	mov    $0x0,%edx
  8026e8:	f7 75 e0             	divl   -0x20(%ebp)
  8026eb:	89 45 dc             	mov    %eax,-0x24(%ebp)
	// the blk count in the page is same as number fo free blocks free up the page.
	if (pageInfo->num_of_free_blocks == blk_count) {
  8026ee:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8026f1:	66 8b 40 0a          	mov    0xa(%eax),%ax
  8026f5:	0f b7 c0             	movzwl %ax,%eax
  8026f8:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  8026fb:	0f 85 70 01 00 00    	jne    802871 <free_block+0x2c5>
		uint32 page_va = to_page_va(pageInfo);
  802701:	83 ec 0c             	sub    $0xc,%esp
  802704:	ff 75 e4             	pushl  -0x1c(%ebp)
  802707:	e8 de f6 ff ff       	call   801dea <to_page_va>
  80270c:	83 c4 10             	add    $0x10,%esp
  80270f:	89 45 d8             	mov    %eax,-0x28(%ebp)
		// remove all blk in the freeBlockList.
		for (uint32 off = 0; off < PAGE_SIZE; off += blk_size) {
  802712:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  802719:	e9 b7 00 00 00       	jmp    8027d5 <free_block+0x229>
			struct BlockElement *blk = (struct BlockElement*)(page_va + off);
  80271e:	8b 55 d8             	mov    -0x28(%ebp),%edx
  802721:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802724:	01 d0                	add    %edx,%eax
  802726:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			LIST_REMOVE(&freeBlockLists[idx], blk);
  802729:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  80272d:	75 17                	jne    802746 <free_block+0x19a>
  80272f:	83 ec 04             	sub    $0x4,%esp
  802732:	68 c1 35 80 00       	push   $0x8035c1
  802737:	68 f8 00 00 00       	push   $0xf8
  80273c:	68 03 35 80 00       	push   $0x803503
  802741:	e8 be 01 00 00       	call   802904 <_panic>
  802746:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802749:	8b 00                	mov    (%eax),%eax
  80274b:	85 c0                	test   %eax,%eax
  80274d:	74 10                	je     80275f <free_block+0x1b3>
  80274f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802752:	8b 00                	mov    (%eax),%eax
  802754:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  802757:	8b 52 04             	mov    0x4(%edx),%edx
  80275a:	89 50 04             	mov    %edx,0x4(%eax)
  80275d:	eb 14                	jmp    802773 <free_block+0x1c7>
  80275f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802762:	8b 40 04             	mov    0x4(%eax),%eax
  802765:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802768:	c1 e2 04             	shl    $0x4,%edx
  80276b:	81 c2 84 c0 81 00    	add    $0x81c084,%edx
  802771:	89 02                	mov    %eax,(%edx)
  802773:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802776:	8b 40 04             	mov    0x4(%eax),%eax
  802779:	85 c0                	test   %eax,%eax
  80277b:	74 0f                	je     80278c <free_block+0x1e0>
  80277d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802780:	8b 40 04             	mov    0x4(%eax),%eax
  802783:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  802786:	8b 12                	mov    (%edx),%edx
  802788:	89 10                	mov    %edx,(%eax)
  80278a:	eb 13                	jmp    80279f <free_block+0x1f3>
  80278c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80278f:	8b 00                	mov    (%eax),%eax
  802791:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802794:	c1 e2 04             	shl    $0x4,%edx
  802797:	81 c2 80 c0 81 00    	add    $0x81c080,%edx
  80279d:	89 02                	mov    %eax,(%edx)
  80279f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8027a2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8027a8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8027ab:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8027b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027b5:	c1 e0 04             	shl    $0x4,%eax
  8027b8:	05 8c c0 81 00       	add    $0x81c08c,%eax
  8027bd:	8b 00                	mov    (%eax),%eax
  8027bf:	8d 50 ff             	lea    -0x1(%eax),%edx
  8027c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027c5:	c1 e0 04             	shl    $0x4,%eax
  8027c8:	05 8c c0 81 00       	add    $0x81c08c,%eax
  8027cd:	89 10                	mov    %edx,(%eax)
	int blk_count = PAGE_SIZE / blk_size;
	// the blk count in the page is same as number fo free blocks free up the page.
	if (pageInfo->num_of_free_blocks == blk_count) {
		uint32 page_va = to_page_va(pageInfo);
		// remove all blk in the freeBlockList.
		for (uint32 off = 0; off < PAGE_SIZE; off += blk_size) {
  8027cf:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8027d2:	01 45 ec             	add    %eax,-0x14(%ebp)
  8027d5:	81 7d ec ff 0f 00 00 	cmpl   $0xfff,-0x14(%ebp)
  8027dc:	0f 86 3c ff ff ff    	jbe    80271e <free_block+0x172>
			struct BlockElement *blk = (struct BlockElement*)(page_va + off);
			LIST_REMOVE(&freeBlockLists[idx], blk);
		}
		// reset page info.
		pageInfo->block_size = 0;
  8027e2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8027e5:	66 c7 40 08 00 00    	movw   $0x0,0x8(%eax)
		pageInfo->num_of_free_blocks = 0;
  8027eb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8027ee:	66 c7 40 0a 00 00    	movw   $0x0,0xa(%eax)
		// add it to the available pages.
		LIST_INSERT_TAIL(&freePagesList, pageInfo);
  8027f4:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8027f8:	75 17                	jne    802811 <free_block+0x265>
  8027fa:	83 ec 04             	sub    $0x4,%esp
  8027fd:	68 7c 35 80 00       	push   $0x80357c
  802802:	68 fe 00 00 00       	push   $0xfe
  802807:	68 03 35 80 00       	push   $0x803503
  80280c:	e8 f3 00 00 00       	call   802904 <_panic>
  802811:	8b 15 4c 40 80 00    	mov    0x80404c,%edx
  802817:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80281a:	89 50 04             	mov    %edx,0x4(%eax)
  80281d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802820:	8b 40 04             	mov    0x4(%eax),%eax
  802823:	85 c0                	test   %eax,%eax
  802825:	74 0c                	je     802833 <free_block+0x287>
  802827:	a1 4c 40 80 00       	mov    0x80404c,%eax
  80282c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80282f:	89 10                	mov    %edx,(%eax)
  802831:	eb 08                	jmp    80283b <free_block+0x28f>
  802833:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802836:	a3 48 40 80 00       	mov    %eax,0x804048
  80283b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80283e:	a3 4c 40 80 00       	mov    %eax,0x80404c
  802843:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802846:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80284c:	a1 54 40 80 00       	mov    0x804054,%eax
  802851:	40                   	inc    %eax
  802852:	a3 54 40 80 00       	mov    %eax,0x804054
		// make it available in memory.
		return_page((uint32 *)to_page_va(pageInfo));
  802857:	83 ec 0c             	sub    $0xc,%esp
  80285a:	ff 75 e4             	pushl  -0x1c(%ebp)
  80285d:	e8 88 f5 ff ff       	call   801dea <to_page_va>
  802862:	83 c4 10             	add    $0x10,%esp
  802865:	83 ec 0c             	sub    $0xc,%esp
  802868:	50                   	push   %eax
  802869:	e8 b8 ee ff ff       	call   801726 <return_page>
  80286e:	83 c4 10             	add    $0x10,%esp
	}
	//panic("free_block() Not implemented yet");
}
  802871:	90                   	nop
  802872:	c9                   	leave  
  802873:	c3                   	ret    

00802874 <realloc_block>:

//===========================
// [1] REALLOCATE BLOCK:
//===========================
void *realloc_block(void* va, uint32 new_size)
{
  802874:	55                   	push   %ebp
  802875:	89 e5                	mov    %esp,%ebp
  802877:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.BONUS#2] KERNEL REALLOC - realloc_block
	//Your code is here
	//Comment the following line
	panic("realloc_block() Not implemented yet");
  80287a:	83 ec 04             	sub    $0x4,%esp
  80287d:	68 28 36 80 00       	push   $0x803628
  802882:	68 11 01 00 00       	push   $0x111
  802887:	68 03 35 80 00       	push   $0x803503
  80288c:	e8 73 00 00 00       	call   802904 <_panic>

00802891 <create_semaphore>:
// User-level Semaphore

#include "inc/lib.h"

struct semaphore create_semaphore(char *semaphoreName, uint32 value)
{
  802891:	55                   	push   %ebp
  802892:	89 e5                	mov    %esp,%ebp
  802894:	83 ec 08             	sub    $0x8,%esp
	panic("create_semaphore() is not implemented yet...!!");
  802897:	83 ec 04             	sub    $0x4,%esp
  80289a:	68 4c 36 80 00       	push   $0x80364c
  80289f:	6a 07                	push   $0x7
  8028a1:	68 7b 36 80 00       	push   $0x80367b
  8028a6:	e8 59 00 00 00       	call   802904 <_panic>

008028ab <get_semaphore>:
}
struct semaphore get_semaphore(int32 ownerEnvID, char* semaphoreName)
{
  8028ab:	55                   	push   %ebp
  8028ac:	89 e5                	mov    %esp,%ebp
  8028ae:	83 ec 08             	sub    $0x8,%esp
	panic("get_semaphore() is not implemented yet...!!");
  8028b1:	83 ec 04             	sub    $0x4,%esp
  8028b4:	68 8c 36 80 00       	push   $0x80368c
  8028b9:	6a 0b                	push   $0xb
  8028bb:	68 7b 36 80 00       	push   $0x80367b
  8028c0:	e8 3f 00 00 00       	call   802904 <_panic>

008028c5 <wait_semaphore>:
}

void wait_semaphore(struct semaphore sem)
{
  8028c5:	55                   	push   %ebp
  8028c6:	89 e5                	mov    %esp,%ebp
  8028c8:	83 ec 08             	sub    $0x8,%esp
	panic("wait_semaphore() is not implemented yet...!!");
  8028cb:	83 ec 04             	sub    $0x4,%esp
  8028ce:	68 b8 36 80 00       	push   $0x8036b8
  8028d3:	6a 10                	push   $0x10
  8028d5:	68 7b 36 80 00       	push   $0x80367b
  8028da:	e8 25 00 00 00       	call   802904 <_panic>

008028df <signal_semaphore>:
}

void signal_semaphore(struct semaphore sem)
{
  8028df:	55                   	push   %ebp
  8028e0:	89 e5                	mov    %esp,%ebp
  8028e2:	83 ec 08             	sub    $0x8,%esp
	panic("signal_semaphore() is not implemented yet...!!");
  8028e5:	83 ec 04             	sub    $0x4,%esp
  8028e8:	68 e8 36 80 00       	push   $0x8036e8
  8028ed:	6a 15                	push   $0x15
  8028ef:	68 7b 36 80 00       	push   $0x80367b
  8028f4:	e8 0b 00 00 00       	call   802904 <_panic>

008028f9 <semaphore_count>:
}

int semaphore_count(struct semaphore sem)
{
  8028f9:	55                   	push   %ebp
  8028fa:	89 e5                	mov    %esp,%ebp
	return sem.semdata->count;
  8028fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8028ff:	8b 40 10             	mov    0x10(%eax),%eax
}
  802902:	5d                   	pop    %ebp
  802903:	c3                   	ret    

00802904 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  802904:	55                   	push   %ebp
  802905:	89 e5                	mov    %esp,%ebp
  802907:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  80290a:	8d 45 10             	lea    0x10(%ebp),%eax
  80290d:	83 c0 04             	add    $0x4,%eax
  802910:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  802913:	a1 1c c1 81 00       	mov    0x81c11c,%eax
  802918:	85 c0                	test   %eax,%eax
  80291a:	74 16                	je     802932 <_panic+0x2e>
		cprintf("%s: ", argv0);
  80291c:	a1 1c c1 81 00       	mov    0x81c11c,%eax
  802921:	83 ec 08             	sub    $0x8,%esp
  802924:	50                   	push   %eax
  802925:	68 18 37 80 00       	push   $0x803718
  80292a:	e8 75 de ff ff       	call   8007a4 <cprintf>
  80292f:	83 c4 10             	add    $0x10,%esp
	cprintf_colored(TEXT_PANIC_CLR, "user [EVAL_FINAL]panic in %s at %s:%d: ", binaryname, file, line);
  802932:	a1 04 40 80 00       	mov    0x804004,%eax
  802937:	83 ec 0c             	sub    $0xc,%esp
  80293a:	ff 75 0c             	pushl  0xc(%ebp)
  80293d:	ff 75 08             	pushl  0x8(%ebp)
  802940:	50                   	push   %eax
  802941:	68 20 37 80 00       	push   $0x803720
  802946:	6a 74                	push   $0x74
  802948:	e8 84 de ff ff       	call   8007d1 <cprintf_colored>
  80294d:	83 c4 20             	add    $0x20,%esp
	vcprintf(fmt, ap);
  802950:	8b 45 10             	mov    0x10(%ebp),%eax
  802953:	83 ec 08             	sub    $0x8,%esp
  802956:	ff 75 f4             	pushl  -0xc(%ebp)
  802959:	50                   	push   %eax
  80295a:	e8 d6 dd ff ff       	call   800735 <vcprintf>
  80295f:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  802962:	83 ec 08             	sub    $0x8,%esp
  802965:	6a 00                	push   $0x0
  802967:	68 48 37 80 00       	push   $0x803748
  80296c:	e8 c4 dd ff ff       	call   800735 <vcprintf>
  802971:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  802974:	e8 3d dd ff ff       	call   8006b6 <exit>

	// should not return here
	while (1) ;
  802979:	eb fe                	jmp    802979 <_panic+0x75>

0080297b <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  80297b:	55                   	push   %ebp
  80297c:	89 e5                	mov    %esp,%ebp
  80297e:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  802981:	a1 20 40 80 00       	mov    0x804020,%eax
  802986:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  80298c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80298f:	39 c2                	cmp    %eax,%edx
  802991:	74 14                	je     8029a7 <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  802993:	83 ec 04             	sub    $0x4,%esp
  802996:	68 4c 37 80 00       	push   $0x80374c
  80299b:	6a 26                	push   $0x26
  80299d:	68 98 37 80 00       	push   $0x803798
  8029a2:	e8 5d ff ff ff       	call   802904 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  8029a7:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  8029ae:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8029b5:	e9 c5 00 00 00       	jmp    802a7f <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  8029ba:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029bd:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8029c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8029c7:	01 d0                	add    %edx,%eax
  8029c9:	8b 00                	mov    (%eax),%eax
  8029cb:	85 c0                	test   %eax,%eax
  8029cd:	75 08                	jne    8029d7 <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  8029cf:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  8029d2:	e9 a5 00 00 00       	jmp    802a7c <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  8029d7:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8029de:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  8029e5:	eb 69                	jmp    802a50 <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  8029e7:	a1 20 40 80 00       	mov    0x804020,%eax
  8029ec:	8b 88 38 da 01 00    	mov    0x1da38(%eax),%ecx
  8029f2:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8029f5:	89 d0                	mov    %edx,%eax
  8029f7:	01 c0                	add    %eax,%eax
  8029f9:	01 d0                	add    %edx,%eax
  8029fb:	c1 e0 03             	shl    $0x3,%eax
  8029fe:	01 c8                	add    %ecx,%eax
  802a00:	8a 40 04             	mov    0x4(%eax),%al
  802a03:	84 c0                	test   %al,%al
  802a05:	75 46                	jne    802a4d <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  802a07:	a1 20 40 80 00       	mov    0x804020,%eax
  802a0c:	8b 88 38 da 01 00    	mov    0x1da38(%eax),%ecx
  802a12:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802a15:	89 d0                	mov    %edx,%eax
  802a17:	01 c0                	add    %eax,%eax
  802a19:	01 d0                	add    %edx,%eax
  802a1b:	c1 e0 03             	shl    $0x3,%eax
  802a1e:	01 c8                	add    %ecx,%eax
  802a20:	8b 00                	mov    (%eax),%eax
  802a22:	89 45 dc             	mov    %eax,-0x24(%ebp)
  802a25:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802a28:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  802a2d:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  802a2f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a32:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  802a39:	8b 45 08             	mov    0x8(%ebp),%eax
  802a3c:	01 c8                	add    %ecx,%eax
  802a3e:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  802a40:	39 c2                	cmp    %eax,%edx
  802a42:	75 09                	jne    802a4d <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  802a44:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  802a4b:	eb 15                	jmp    802a62 <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  802a4d:	ff 45 e8             	incl   -0x18(%ebp)
  802a50:	a1 20 40 80 00       	mov    0x804020,%eax
  802a55:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  802a5b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802a5e:	39 c2                	cmp    %eax,%edx
  802a60:	77 85                	ja     8029e7 <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  802a62:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802a66:	75 14                	jne    802a7c <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  802a68:	83 ec 04             	sub    $0x4,%esp
  802a6b:	68 a4 37 80 00       	push   $0x8037a4
  802a70:	6a 3a                	push   $0x3a
  802a72:	68 98 37 80 00       	push   $0x803798
  802a77:	e8 88 fe ff ff       	call   802904 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  802a7c:	ff 45 f0             	incl   -0x10(%ebp)
  802a7f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a82:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802a85:	0f 8c 2f ff ff ff    	jl     8029ba <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  802a8b:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  802a92:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  802a99:	eb 26                	jmp    802ac1 <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  802a9b:	a1 20 40 80 00       	mov    0x804020,%eax
  802aa0:	8b 88 38 da 01 00    	mov    0x1da38(%eax),%ecx
  802aa6:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802aa9:	89 d0                	mov    %edx,%eax
  802aab:	01 c0                	add    %eax,%eax
  802aad:	01 d0                	add    %edx,%eax
  802aaf:	c1 e0 03             	shl    $0x3,%eax
  802ab2:	01 c8                	add    %ecx,%eax
  802ab4:	8a 40 04             	mov    0x4(%eax),%al
  802ab7:	3c 01                	cmp    $0x1,%al
  802ab9:	75 03                	jne    802abe <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  802abb:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  802abe:	ff 45 e0             	incl   -0x20(%ebp)
  802ac1:	a1 20 40 80 00       	mov    0x804020,%eax
  802ac6:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  802acc:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802acf:	39 c2                	cmp    %eax,%edx
  802ad1:	77 c8                	ja     802a9b <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  802ad3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ad6:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  802ad9:	74 14                	je     802aef <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  802adb:	83 ec 04             	sub    $0x4,%esp
  802ade:	68 f8 37 80 00       	push   $0x8037f8
  802ae3:	6a 44                	push   $0x44
  802ae5:	68 98 37 80 00       	push   $0x803798
  802aea:	e8 15 fe ff ff       	call   802904 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  802aef:	90                   	nop
  802af0:	c9                   	leave  
  802af1:	c3                   	ret    
  802af2:	66 90                	xchg   %ax,%ax

00802af4 <__udivdi3>:
  802af4:	55                   	push   %ebp
  802af5:	57                   	push   %edi
  802af6:	56                   	push   %esi
  802af7:	53                   	push   %ebx
  802af8:	83 ec 1c             	sub    $0x1c,%esp
  802afb:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  802aff:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  802b03:	8b 7c 24 38          	mov    0x38(%esp),%edi
  802b07:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802b0b:	89 ca                	mov    %ecx,%edx
  802b0d:	89 f8                	mov    %edi,%eax
  802b0f:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  802b13:	85 f6                	test   %esi,%esi
  802b15:	75 2d                	jne    802b44 <__udivdi3+0x50>
  802b17:	39 cf                	cmp    %ecx,%edi
  802b19:	77 65                	ja     802b80 <__udivdi3+0x8c>
  802b1b:	89 fd                	mov    %edi,%ebp
  802b1d:	85 ff                	test   %edi,%edi
  802b1f:	75 0b                	jne    802b2c <__udivdi3+0x38>
  802b21:	b8 01 00 00 00       	mov    $0x1,%eax
  802b26:	31 d2                	xor    %edx,%edx
  802b28:	f7 f7                	div    %edi
  802b2a:	89 c5                	mov    %eax,%ebp
  802b2c:	31 d2                	xor    %edx,%edx
  802b2e:	89 c8                	mov    %ecx,%eax
  802b30:	f7 f5                	div    %ebp
  802b32:	89 c1                	mov    %eax,%ecx
  802b34:	89 d8                	mov    %ebx,%eax
  802b36:	f7 f5                	div    %ebp
  802b38:	89 cf                	mov    %ecx,%edi
  802b3a:	89 fa                	mov    %edi,%edx
  802b3c:	83 c4 1c             	add    $0x1c,%esp
  802b3f:	5b                   	pop    %ebx
  802b40:	5e                   	pop    %esi
  802b41:	5f                   	pop    %edi
  802b42:	5d                   	pop    %ebp
  802b43:	c3                   	ret    
  802b44:	39 ce                	cmp    %ecx,%esi
  802b46:	77 28                	ja     802b70 <__udivdi3+0x7c>
  802b48:	0f bd fe             	bsr    %esi,%edi
  802b4b:	83 f7 1f             	xor    $0x1f,%edi
  802b4e:	75 40                	jne    802b90 <__udivdi3+0x9c>
  802b50:	39 ce                	cmp    %ecx,%esi
  802b52:	72 0a                	jb     802b5e <__udivdi3+0x6a>
  802b54:	3b 44 24 08          	cmp    0x8(%esp),%eax
  802b58:	0f 87 9e 00 00 00    	ja     802bfc <__udivdi3+0x108>
  802b5e:	b8 01 00 00 00       	mov    $0x1,%eax
  802b63:	89 fa                	mov    %edi,%edx
  802b65:	83 c4 1c             	add    $0x1c,%esp
  802b68:	5b                   	pop    %ebx
  802b69:	5e                   	pop    %esi
  802b6a:	5f                   	pop    %edi
  802b6b:	5d                   	pop    %ebp
  802b6c:	c3                   	ret    
  802b6d:	8d 76 00             	lea    0x0(%esi),%esi
  802b70:	31 ff                	xor    %edi,%edi
  802b72:	31 c0                	xor    %eax,%eax
  802b74:	89 fa                	mov    %edi,%edx
  802b76:	83 c4 1c             	add    $0x1c,%esp
  802b79:	5b                   	pop    %ebx
  802b7a:	5e                   	pop    %esi
  802b7b:	5f                   	pop    %edi
  802b7c:	5d                   	pop    %ebp
  802b7d:	c3                   	ret    
  802b7e:	66 90                	xchg   %ax,%ax
  802b80:	89 d8                	mov    %ebx,%eax
  802b82:	f7 f7                	div    %edi
  802b84:	31 ff                	xor    %edi,%edi
  802b86:	89 fa                	mov    %edi,%edx
  802b88:	83 c4 1c             	add    $0x1c,%esp
  802b8b:	5b                   	pop    %ebx
  802b8c:	5e                   	pop    %esi
  802b8d:	5f                   	pop    %edi
  802b8e:	5d                   	pop    %ebp
  802b8f:	c3                   	ret    
  802b90:	bd 20 00 00 00       	mov    $0x20,%ebp
  802b95:	89 eb                	mov    %ebp,%ebx
  802b97:	29 fb                	sub    %edi,%ebx
  802b99:	89 f9                	mov    %edi,%ecx
  802b9b:	d3 e6                	shl    %cl,%esi
  802b9d:	89 c5                	mov    %eax,%ebp
  802b9f:	88 d9                	mov    %bl,%cl
  802ba1:	d3 ed                	shr    %cl,%ebp
  802ba3:	89 e9                	mov    %ebp,%ecx
  802ba5:	09 f1                	or     %esi,%ecx
  802ba7:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  802bab:	89 f9                	mov    %edi,%ecx
  802bad:	d3 e0                	shl    %cl,%eax
  802baf:	89 c5                	mov    %eax,%ebp
  802bb1:	89 d6                	mov    %edx,%esi
  802bb3:	88 d9                	mov    %bl,%cl
  802bb5:	d3 ee                	shr    %cl,%esi
  802bb7:	89 f9                	mov    %edi,%ecx
  802bb9:	d3 e2                	shl    %cl,%edx
  802bbb:	8b 44 24 08          	mov    0x8(%esp),%eax
  802bbf:	88 d9                	mov    %bl,%cl
  802bc1:	d3 e8                	shr    %cl,%eax
  802bc3:	09 c2                	or     %eax,%edx
  802bc5:	89 d0                	mov    %edx,%eax
  802bc7:	89 f2                	mov    %esi,%edx
  802bc9:	f7 74 24 0c          	divl   0xc(%esp)
  802bcd:	89 d6                	mov    %edx,%esi
  802bcf:	89 c3                	mov    %eax,%ebx
  802bd1:	f7 e5                	mul    %ebp
  802bd3:	39 d6                	cmp    %edx,%esi
  802bd5:	72 19                	jb     802bf0 <__udivdi3+0xfc>
  802bd7:	74 0b                	je     802be4 <__udivdi3+0xf0>
  802bd9:	89 d8                	mov    %ebx,%eax
  802bdb:	31 ff                	xor    %edi,%edi
  802bdd:	e9 58 ff ff ff       	jmp    802b3a <__udivdi3+0x46>
  802be2:	66 90                	xchg   %ax,%ax
  802be4:	8b 54 24 08          	mov    0x8(%esp),%edx
  802be8:	89 f9                	mov    %edi,%ecx
  802bea:	d3 e2                	shl    %cl,%edx
  802bec:	39 c2                	cmp    %eax,%edx
  802bee:	73 e9                	jae    802bd9 <__udivdi3+0xe5>
  802bf0:	8d 43 ff             	lea    -0x1(%ebx),%eax
  802bf3:	31 ff                	xor    %edi,%edi
  802bf5:	e9 40 ff ff ff       	jmp    802b3a <__udivdi3+0x46>
  802bfa:	66 90                	xchg   %ax,%ax
  802bfc:	31 c0                	xor    %eax,%eax
  802bfe:	e9 37 ff ff ff       	jmp    802b3a <__udivdi3+0x46>
  802c03:	90                   	nop

00802c04 <__umoddi3>:
  802c04:	55                   	push   %ebp
  802c05:	57                   	push   %edi
  802c06:	56                   	push   %esi
  802c07:	53                   	push   %ebx
  802c08:	83 ec 1c             	sub    $0x1c,%esp
  802c0b:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  802c0f:	8b 74 24 34          	mov    0x34(%esp),%esi
  802c13:	8b 7c 24 38          	mov    0x38(%esp),%edi
  802c17:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  802c1b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802c1f:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802c23:	89 f3                	mov    %esi,%ebx
  802c25:	89 fa                	mov    %edi,%edx
  802c27:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  802c2b:	89 34 24             	mov    %esi,(%esp)
  802c2e:	85 c0                	test   %eax,%eax
  802c30:	75 1a                	jne    802c4c <__umoddi3+0x48>
  802c32:	39 f7                	cmp    %esi,%edi
  802c34:	0f 86 a2 00 00 00    	jbe    802cdc <__umoddi3+0xd8>
  802c3a:	89 c8                	mov    %ecx,%eax
  802c3c:	89 f2                	mov    %esi,%edx
  802c3e:	f7 f7                	div    %edi
  802c40:	89 d0                	mov    %edx,%eax
  802c42:	31 d2                	xor    %edx,%edx
  802c44:	83 c4 1c             	add    $0x1c,%esp
  802c47:	5b                   	pop    %ebx
  802c48:	5e                   	pop    %esi
  802c49:	5f                   	pop    %edi
  802c4a:	5d                   	pop    %ebp
  802c4b:	c3                   	ret    
  802c4c:	39 f0                	cmp    %esi,%eax
  802c4e:	0f 87 ac 00 00 00    	ja     802d00 <__umoddi3+0xfc>
  802c54:	0f bd e8             	bsr    %eax,%ebp
  802c57:	83 f5 1f             	xor    $0x1f,%ebp
  802c5a:	0f 84 ac 00 00 00    	je     802d0c <__umoddi3+0x108>
  802c60:	bf 20 00 00 00       	mov    $0x20,%edi
  802c65:	29 ef                	sub    %ebp,%edi
  802c67:	89 fe                	mov    %edi,%esi
  802c69:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802c6d:	89 e9                	mov    %ebp,%ecx
  802c6f:	d3 e0                	shl    %cl,%eax
  802c71:	89 d7                	mov    %edx,%edi
  802c73:	89 f1                	mov    %esi,%ecx
  802c75:	d3 ef                	shr    %cl,%edi
  802c77:	09 c7                	or     %eax,%edi
  802c79:	89 e9                	mov    %ebp,%ecx
  802c7b:	d3 e2                	shl    %cl,%edx
  802c7d:	89 14 24             	mov    %edx,(%esp)
  802c80:	89 d8                	mov    %ebx,%eax
  802c82:	d3 e0                	shl    %cl,%eax
  802c84:	89 c2                	mov    %eax,%edx
  802c86:	8b 44 24 08          	mov    0x8(%esp),%eax
  802c8a:	d3 e0                	shl    %cl,%eax
  802c8c:	89 44 24 04          	mov    %eax,0x4(%esp)
  802c90:	8b 44 24 08          	mov    0x8(%esp),%eax
  802c94:	89 f1                	mov    %esi,%ecx
  802c96:	d3 e8                	shr    %cl,%eax
  802c98:	09 d0                	or     %edx,%eax
  802c9a:	d3 eb                	shr    %cl,%ebx
  802c9c:	89 da                	mov    %ebx,%edx
  802c9e:	f7 f7                	div    %edi
  802ca0:	89 d3                	mov    %edx,%ebx
  802ca2:	f7 24 24             	mull   (%esp)
  802ca5:	89 c6                	mov    %eax,%esi
  802ca7:	89 d1                	mov    %edx,%ecx
  802ca9:	39 d3                	cmp    %edx,%ebx
  802cab:	0f 82 87 00 00 00    	jb     802d38 <__umoddi3+0x134>
  802cb1:	0f 84 91 00 00 00    	je     802d48 <__umoddi3+0x144>
  802cb7:	8b 54 24 04          	mov    0x4(%esp),%edx
  802cbb:	29 f2                	sub    %esi,%edx
  802cbd:	19 cb                	sbb    %ecx,%ebx
  802cbf:	89 d8                	mov    %ebx,%eax
  802cc1:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  802cc5:	d3 e0                	shl    %cl,%eax
  802cc7:	89 e9                	mov    %ebp,%ecx
  802cc9:	d3 ea                	shr    %cl,%edx
  802ccb:	09 d0                	or     %edx,%eax
  802ccd:	89 e9                	mov    %ebp,%ecx
  802ccf:	d3 eb                	shr    %cl,%ebx
  802cd1:	89 da                	mov    %ebx,%edx
  802cd3:	83 c4 1c             	add    $0x1c,%esp
  802cd6:	5b                   	pop    %ebx
  802cd7:	5e                   	pop    %esi
  802cd8:	5f                   	pop    %edi
  802cd9:	5d                   	pop    %ebp
  802cda:	c3                   	ret    
  802cdb:	90                   	nop
  802cdc:	89 fd                	mov    %edi,%ebp
  802cde:	85 ff                	test   %edi,%edi
  802ce0:	75 0b                	jne    802ced <__umoddi3+0xe9>
  802ce2:	b8 01 00 00 00       	mov    $0x1,%eax
  802ce7:	31 d2                	xor    %edx,%edx
  802ce9:	f7 f7                	div    %edi
  802ceb:	89 c5                	mov    %eax,%ebp
  802ced:	89 f0                	mov    %esi,%eax
  802cef:	31 d2                	xor    %edx,%edx
  802cf1:	f7 f5                	div    %ebp
  802cf3:	89 c8                	mov    %ecx,%eax
  802cf5:	f7 f5                	div    %ebp
  802cf7:	89 d0                	mov    %edx,%eax
  802cf9:	e9 44 ff ff ff       	jmp    802c42 <__umoddi3+0x3e>
  802cfe:	66 90                	xchg   %ax,%ax
  802d00:	89 c8                	mov    %ecx,%eax
  802d02:	89 f2                	mov    %esi,%edx
  802d04:	83 c4 1c             	add    $0x1c,%esp
  802d07:	5b                   	pop    %ebx
  802d08:	5e                   	pop    %esi
  802d09:	5f                   	pop    %edi
  802d0a:	5d                   	pop    %ebp
  802d0b:	c3                   	ret    
  802d0c:	3b 04 24             	cmp    (%esp),%eax
  802d0f:	72 06                	jb     802d17 <__umoddi3+0x113>
  802d11:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  802d15:	77 0f                	ja     802d26 <__umoddi3+0x122>
  802d17:	89 f2                	mov    %esi,%edx
  802d19:	29 f9                	sub    %edi,%ecx
  802d1b:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  802d1f:	89 14 24             	mov    %edx,(%esp)
  802d22:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  802d26:	8b 44 24 04          	mov    0x4(%esp),%eax
  802d2a:	8b 14 24             	mov    (%esp),%edx
  802d2d:	83 c4 1c             	add    $0x1c,%esp
  802d30:	5b                   	pop    %ebx
  802d31:	5e                   	pop    %esi
  802d32:	5f                   	pop    %edi
  802d33:	5d                   	pop    %ebp
  802d34:	c3                   	ret    
  802d35:	8d 76 00             	lea    0x0(%esi),%esi
  802d38:	2b 04 24             	sub    (%esp),%eax
  802d3b:	19 fa                	sbb    %edi,%edx
  802d3d:	89 d1                	mov    %edx,%ecx
  802d3f:	89 c6                	mov    %eax,%esi
  802d41:	e9 71 ff ff ff       	jmp    802cb7 <__umoddi3+0xb3>
  802d46:	66 90                	xchg   %ax,%ax
  802d48:	39 44 24 04          	cmp    %eax,0x4(%esp)
  802d4c:	72 ea                	jb     802d38 <__umoddi3+0x134>
  802d4e:	89 d9                	mov    %ebx,%ecx
  802d50:	e9 62 ff ff ff       	jmp    802cb7 <__umoddi3+0xb3>
