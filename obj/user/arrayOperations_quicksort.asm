
obj/user/arrayOperations_quicksort:     file format elf32-i386


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
  800031:	e8 b1 03 00 00       	call   8003e7 <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:

void QuickSort(int *Elements, int NumOfElements);
void QSort(int *Elements,int NumOfElements, int startIndex, int finalIndex);

void _main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	83 ec 38             	sub    $0x38,%esp
	int32 envID = sys_getenvid();
  80003e:	e8 9f 19 00 00       	call   8019e2 <sys_getenvid>
  800043:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int32 parentenvID = sys_getparentenvid();
  800046:	e8 c9 19 00 00       	call   801a14 <sys_getparentenvid>
  80004b:	89 45 ec             	mov    %eax,-0x14(%ebp)

	int ret;
	/*[1] GET SEMAPHORES*/
	struct semaphore ready = get_semaphore(parentenvID, "Ready");
  80004e:	8d 45 d8             	lea    -0x28(%ebp),%eax
  800051:	83 ec 04             	sub    $0x4,%esp
  800054:	68 40 2c 80 00       	push   $0x802c40
  800059:	ff 75 ec             	pushl  -0x14(%ebp)
  80005c:	50                   	push   %eax
  80005d:	e8 1c 27 00 00       	call   80277e <get_semaphore>
  800062:	83 c4 0c             	add    $0xc,%esp
	struct semaphore finished = get_semaphore(parentenvID, "Finished");
  800065:	8d 45 d4             	lea    -0x2c(%ebp),%eax
  800068:	83 ec 04             	sub    $0x4,%esp
  80006b:	68 46 2c 80 00       	push   $0x802c46
  800070:	ff 75 ec             	pushl  -0x14(%ebp)
  800073:	50                   	push   %eax
  800074:	e8 05 27 00 00       	call   80277e <get_semaphore>
  800079:	83 c4 0c             	add    $0xc,%esp

	/*[2] WAIT A READY SIGNAL FROM THE MASTER*/
	wait_semaphore(ready);
  80007c:	83 ec 0c             	sub    $0xc,%esp
  80007f:	ff 75 d8             	pushl  -0x28(%ebp)
  800082:	e8 11 27 00 00       	call   802798 <wait_semaphore>
  800087:	83 c4 10             	add    $0x10,%esp

	/*[3] GET SHARED VARs*/
	//Get the cons_mutex ownerID
	int* consMutexOwnerID = sget(parentenvID, "cons_mutex ownerID") ;
  80008a:	83 ec 08             	sub    $0x8,%esp
  80008d:	68 4f 2c 80 00       	push   $0x802c4f
  800092:	ff 75 ec             	pushl  -0x14(%ebp)
  800095:	e8 1b 16 00 00       	call   8016b5 <sget>
  80009a:	83 c4 10             	add    $0x10,%esp
  80009d:	89 45 e8             	mov    %eax,-0x18(%ebp)
	struct semaphore cons_mutex = get_semaphore(*consMutexOwnerID, "Console Mutex");
  8000a0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8000a3:	8b 10                	mov    (%eax),%edx
  8000a5:	8d 45 d0             	lea    -0x30(%ebp),%eax
  8000a8:	83 ec 04             	sub    $0x4,%esp
  8000ab:	68 62 2c 80 00       	push   $0x802c62
  8000b0:	52                   	push   %edx
  8000b1:	50                   	push   %eax
  8000b2:	e8 c7 26 00 00       	call   80277e <get_semaphore>
  8000b7:	83 c4 0c             	add    $0xc,%esp

	//Get the shared array & its size
	int *numOfElements = NULL;
  8000ba:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	int *sharedArray = NULL;
  8000c1:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
	sharedArray = sget(parentenvID,"arr") ;
  8000c8:	83 ec 08             	sub    $0x8,%esp
  8000cb:	68 70 2c 80 00       	push   $0x802c70
  8000d0:	ff 75 ec             	pushl  -0x14(%ebp)
  8000d3:	e8 dd 15 00 00       	call   8016b5 <sget>
  8000d8:	83 c4 10             	add    $0x10,%esp
  8000db:	89 45 e0             	mov    %eax,-0x20(%ebp)
	numOfElements = sget(parentenvID,"arrSize") ;
  8000de:	83 ec 08             	sub    $0x8,%esp
  8000e1:	68 74 2c 80 00       	push   $0x802c74
  8000e6:	ff 75 ec             	pushl  -0x14(%ebp)
  8000e9:	e8 c7 15 00 00       	call   8016b5 <sget>
  8000ee:	83 c4 10             	add    $0x10,%esp
  8000f1:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	/*[4] DO THE JOB*/
	//take a copy from the original array
	int *sortedArray;
	sortedArray = smalloc("quicksortedArr", sizeof(int) * *numOfElements, 0) ;
  8000f4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8000f7:	8b 00                	mov    (%eax),%eax
  8000f9:	c1 e0 02             	shl    $0x2,%eax
  8000fc:	83 ec 04             	sub    $0x4,%esp
  8000ff:	6a 00                	push   $0x0
  800101:	50                   	push   %eax
  800102:	68 7c 2c 80 00       	push   $0x802c7c
  800107:	e8 75 15 00 00       	call   801681 <smalloc>
  80010c:	83 c4 10             	add    $0x10,%esp
  80010f:	89 45 dc             	mov    %eax,-0x24(%ebp)
	int i ;
	for (i = 0 ; i < *numOfElements ; i++)
  800112:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  800119:	eb 25                	jmp    800140 <_main+0x108>
	{
		sortedArray[i] = sharedArray[i];
  80011b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80011e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800125:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800128:	01 c2                	add    %eax,%edx
  80012a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80012d:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800134:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800137:	01 c8                	add    %ecx,%eax
  800139:	8b 00                	mov    (%eax),%eax
  80013b:	89 02                	mov    %eax,(%edx)
	/*[4] DO THE JOB*/
	//take a copy from the original array
	int *sortedArray;
	sortedArray = smalloc("quicksortedArr", sizeof(int) * *numOfElements, 0) ;
	int i ;
	for (i = 0 ; i < *numOfElements ; i++)
  80013d:	ff 45 f4             	incl   -0xc(%ebp)
  800140:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800143:	8b 00                	mov    (%eax),%eax
  800145:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  800148:	7f d1                	jg     80011b <_main+0xe3>
	{
		sortedArray[i] = sharedArray[i];
	}
	QuickSort(sortedArray, *numOfElements);
  80014a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80014d:	8b 00                	mov    (%eax),%eax
  80014f:	83 ec 08             	sub    $0x8,%esp
  800152:	50                   	push   %eax
  800153:	ff 75 dc             	pushl  -0x24(%ebp)
  800156:	e8 60 00 00 00       	call   8001bb <QuickSort>
  80015b:	83 c4 10             	add    $0x10,%esp

	wait_semaphore(cons_mutex);
  80015e:	83 ec 0c             	sub    $0xc,%esp
  800161:	ff 75 d0             	pushl  -0x30(%ebp)
  800164:	e8 2f 26 00 00       	call   802798 <wait_semaphore>
  800169:	83 c4 10             	add    $0x10,%esp
	{
		cprintf("Quick sort is Finished!!!!\n") ;
  80016c:	83 ec 0c             	sub    $0xc,%esp
  80016f:	68 8b 2c 80 00       	push   $0x802c8b
  800174:	e8 fe 04 00 00       	call   800677 <cprintf>
  800179:	83 c4 10             	add    $0x10,%esp
		cprintf("will notify the master now...\n");
  80017c:	83 ec 0c             	sub    $0xc,%esp
  80017f:	68 a8 2c 80 00       	push   $0x802ca8
  800184:	e8 ee 04 00 00       	call   800677 <cprintf>
  800189:	83 c4 10             	add    $0x10,%esp
		cprintf("Quick sort says GOOD BYE :)\n") ;
  80018c:	83 ec 0c             	sub    $0xc,%esp
  80018f:	68 c7 2c 80 00       	push   $0x802cc7
  800194:	e8 de 04 00 00       	call   800677 <cprintf>
  800199:	83 c4 10             	add    $0x10,%esp
	}
	signal_semaphore(cons_mutex);
  80019c:	83 ec 0c             	sub    $0xc,%esp
  80019f:	ff 75 d0             	pushl  -0x30(%ebp)
  8001a2:	e8 0b 26 00 00       	call   8027b2 <signal_semaphore>
  8001a7:	83 c4 10             	add    $0x10,%esp

	/*[5] DECLARE FINISHING*/
	signal_semaphore(finished);
  8001aa:	83 ec 0c             	sub    $0xc,%esp
  8001ad:	ff 75 d4             	pushl  -0x2c(%ebp)
  8001b0:	e8 fd 25 00 00       	call   8027b2 <signal_semaphore>
  8001b5:	83 c4 10             	add    $0x10,%esp
}
  8001b8:	90                   	nop
  8001b9:	c9                   	leave  
  8001ba:	c3                   	ret    

008001bb <QuickSort>:

///Quick sort
void QuickSort(int *Elements, int NumOfElements)
{
  8001bb:	55                   	push   %ebp
  8001bc:	89 e5                	mov    %esp,%ebp
  8001be:	83 ec 08             	sub    $0x8,%esp
	QSort(Elements, NumOfElements, 0, NumOfElements-1) ;
  8001c1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8001c4:	48                   	dec    %eax
  8001c5:	50                   	push   %eax
  8001c6:	6a 00                	push   $0x0
  8001c8:	ff 75 0c             	pushl  0xc(%ebp)
  8001cb:	ff 75 08             	pushl  0x8(%ebp)
  8001ce:	e8 06 00 00 00       	call   8001d9 <QSort>
  8001d3:	83 c4 10             	add    $0x10,%esp
}
  8001d6:	90                   	nop
  8001d7:	c9                   	leave  
  8001d8:	c3                   	ret    

008001d9 <QSort>:


void QSort(int *Elements,int NumOfElements, int startIndex, int finalIndex)
{
  8001d9:	55                   	push   %ebp
  8001da:	89 e5                	mov    %esp,%ebp
  8001dc:	83 ec 28             	sub    $0x28,%esp
	if (startIndex >= finalIndex) return;
  8001df:	8b 45 10             	mov    0x10(%ebp),%eax
  8001e2:	3b 45 14             	cmp    0x14(%ebp),%eax
  8001e5:	0f 8d 20 01 00 00    	jge    80030b <QSort+0x132>

static inline __attribute__((always_inline)) struct uint64 get_virtual_time_user()
{
	struct uint64 result;

	__asm __volatile("rdtsc\n"
  8001eb:	0f 31                	rdtsc  
  8001ed:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8001f0:	89 55 e0             	mov    %edx,-0x20(%ebp)
	: "=a" (result.low), "=d" (result.hi)
	);

	return result;
  8001f3:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8001f6:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8001f9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8001fc:	89 55 e8             	mov    %edx,-0x18(%ebp)
	int pvtIndex = RANDU(startIndex, finalIndex) ;
  8001ff:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800202:	8b 55 14             	mov    0x14(%ebp),%edx
  800205:	2b 55 10             	sub    0x10(%ebp),%edx
  800208:	89 d1                	mov    %edx,%ecx
  80020a:	ba 00 00 00 00       	mov    $0x0,%edx
  80020f:	f7 f1                	div    %ecx
  800211:	8b 45 10             	mov    0x10(%ebp),%eax
  800214:	01 d0                	add    %edx,%eax
  800216:	89 45 ec             	mov    %eax,-0x14(%ebp)
	Swap(Elements, startIndex, pvtIndex);
  800219:	83 ec 04             	sub    $0x4,%esp
  80021c:	ff 75 ec             	pushl  -0x14(%ebp)
  80021f:	ff 75 10             	pushl  0x10(%ebp)
  800222:	ff 75 08             	pushl  0x8(%ebp)
  800225:	e8 e4 00 00 00       	call   80030e <Swap>
  80022a:	83 c4 10             	add    $0x10,%esp

	int i = startIndex+1, j = finalIndex;
  80022d:	8b 45 10             	mov    0x10(%ebp),%eax
  800230:	40                   	inc    %eax
  800231:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800234:	8b 45 14             	mov    0x14(%ebp),%eax
  800237:	89 45 f0             	mov    %eax,-0x10(%ebp)

	while (i <= j)
  80023a:	e9 80 00 00 00       	jmp    8002bf <QSort+0xe6>
	{
		while (i <= finalIndex && Elements[startIndex] >= Elements[i]) i++;
  80023f:	ff 45 f4             	incl   -0xc(%ebp)
  800242:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800245:	3b 45 14             	cmp    0x14(%ebp),%eax
  800248:	7f 2b                	jg     800275 <QSort+0x9c>
  80024a:	8b 45 10             	mov    0x10(%ebp),%eax
  80024d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800254:	8b 45 08             	mov    0x8(%ebp),%eax
  800257:	01 d0                	add    %edx,%eax
  800259:	8b 10                	mov    (%eax),%edx
  80025b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80025e:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800265:	8b 45 08             	mov    0x8(%ebp),%eax
  800268:	01 c8                	add    %ecx,%eax
  80026a:	8b 00                	mov    (%eax),%eax
  80026c:	39 c2                	cmp    %eax,%edx
  80026e:	7d cf                	jge    80023f <QSort+0x66>
		while (j > startIndex && Elements[startIndex] <= Elements[j]) j--;
  800270:	eb 03                	jmp    800275 <QSort+0x9c>
  800272:	ff 4d f0             	decl   -0x10(%ebp)
  800275:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800278:	3b 45 10             	cmp    0x10(%ebp),%eax
  80027b:	7e 26                	jle    8002a3 <QSort+0xca>
  80027d:	8b 45 10             	mov    0x10(%ebp),%eax
  800280:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800287:	8b 45 08             	mov    0x8(%ebp),%eax
  80028a:	01 d0                	add    %edx,%eax
  80028c:	8b 10                	mov    (%eax),%edx
  80028e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800291:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800298:	8b 45 08             	mov    0x8(%ebp),%eax
  80029b:	01 c8                	add    %ecx,%eax
  80029d:	8b 00                	mov    (%eax),%eax
  80029f:	39 c2                	cmp    %eax,%edx
  8002a1:	7e cf                	jle    800272 <QSort+0x99>

		if (i <= j)
  8002a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8002a6:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8002a9:	7f 14                	jg     8002bf <QSort+0xe6>
		{
			Swap(Elements, i, j);
  8002ab:	83 ec 04             	sub    $0x4,%esp
  8002ae:	ff 75 f0             	pushl  -0x10(%ebp)
  8002b1:	ff 75 f4             	pushl  -0xc(%ebp)
  8002b4:	ff 75 08             	pushl  0x8(%ebp)
  8002b7:	e8 52 00 00 00       	call   80030e <Swap>
  8002bc:	83 c4 10             	add    $0x10,%esp
	int pvtIndex = RANDU(startIndex, finalIndex) ;
	Swap(Elements, startIndex, pvtIndex);

	int i = startIndex+1, j = finalIndex;

	while (i <= j)
  8002bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8002c2:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8002c5:	0f 8e 77 ff ff ff    	jle    800242 <QSort+0x69>
		{
			Swap(Elements, i, j);
		}
	}

	Swap( Elements, startIndex, j);
  8002cb:	83 ec 04             	sub    $0x4,%esp
  8002ce:	ff 75 f0             	pushl  -0x10(%ebp)
  8002d1:	ff 75 10             	pushl  0x10(%ebp)
  8002d4:	ff 75 08             	pushl  0x8(%ebp)
  8002d7:	e8 32 00 00 00       	call   80030e <Swap>
  8002dc:	83 c4 10             	add    $0x10,%esp

	QSort(Elements, NumOfElements, startIndex, j - 1);
  8002df:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8002e2:	48                   	dec    %eax
  8002e3:	50                   	push   %eax
  8002e4:	ff 75 10             	pushl  0x10(%ebp)
  8002e7:	ff 75 0c             	pushl  0xc(%ebp)
  8002ea:	ff 75 08             	pushl  0x8(%ebp)
  8002ed:	e8 e7 fe ff ff       	call   8001d9 <QSort>
  8002f2:	83 c4 10             	add    $0x10,%esp
	QSort(Elements, NumOfElements, i, finalIndex);
  8002f5:	ff 75 14             	pushl  0x14(%ebp)
  8002f8:	ff 75 f4             	pushl  -0xc(%ebp)
  8002fb:	ff 75 0c             	pushl  0xc(%ebp)
  8002fe:	ff 75 08             	pushl  0x8(%ebp)
  800301:	e8 d3 fe ff ff       	call   8001d9 <QSort>
  800306:	83 c4 10             	add    $0x10,%esp
  800309:	eb 01                	jmp    80030c <QSort+0x133>
}


void QSort(int *Elements,int NumOfElements, int startIndex, int finalIndex)
{
	if (startIndex >= finalIndex) return;
  80030b:	90                   	nop
	QSort(Elements, NumOfElements, startIndex, j - 1);
	QSort(Elements, NumOfElements, i, finalIndex);

	//cprintf("qs,after sorting: start = %d, end = %d\n", startIndex, finalIndex);

}
  80030c:	c9                   	leave  
  80030d:	c3                   	ret    

0080030e <Swap>:

///Private Functions


void Swap(int *Elements, int First, int Second)
{
  80030e:	55                   	push   %ebp
  80030f:	89 e5                	mov    %esp,%ebp
  800311:	83 ec 10             	sub    $0x10,%esp
	int Tmp = Elements[First] ;
  800314:	8b 45 0c             	mov    0xc(%ebp),%eax
  800317:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80031e:	8b 45 08             	mov    0x8(%ebp),%eax
  800321:	01 d0                	add    %edx,%eax
  800323:	8b 00                	mov    (%eax),%eax
  800325:	89 45 fc             	mov    %eax,-0x4(%ebp)
	Elements[First] = Elements[Second] ;
  800328:	8b 45 0c             	mov    0xc(%ebp),%eax
  80032b:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800332:	8b 45 08             	mov    0x8(%ebp),%eax
  800335:	01 c2                	add    %eax,%edx
  800337:	8b 45 10             	mov    0x10(%ebp),%eax
  80033a:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800341:	8b 45 08             	mov    0x8(%ebp),%eax
  800344:	01 c8                	add    %ecx,%eax
  800346:	8b 00                	mov    (%eax),%eax
  800348:	89 02                	mov    %eax,(%edx)
	Elements[Second] = Tmp ;
  80034a:	8b 45 10             	mov    0x10(%ebp),%eax
  80034d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800354:	8b 45 08             	mov    0x8(%ebp),%eax
  800357:	01 c2                	add    %eax,%edx
  800359:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80035c:	89 02                	mov    %eax,(%edx)
}
  80035e:	90                   	nop
  80035f:	c9                   	leave  
  800360:	c3                   	ret    

00800361 <PrintElements>:


void PrintElements(int *Elements, int NumOfElements)
{
  800361:	55                   	push   %ebp
  800362:	89 e5                	mov    %esp,%ebp
  800364:	83 ec 18             	sub    $0x18,%esp
	int i ;
	int NumsPerLine = 20 ;
  800367:	c7 45 f0 14 00 00 00 	movl   $0x14,-0x10(%ebp)
	for (i = 0 ; i < NumOfElements-1 ; i++)
  80036e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  800375:	eb 42                	jmp    8003b9 <PrintElements+0x58>
	{
		if (i%NumsPerLine == 0)
  800377:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80037a:	99                   	cltd   
  80037b:	f7 7d f0             	idivl  -0x10(%ebp)
  80037e:	89 d0                	mov    %edx,%eax
  800380:	85 c0                	test   %eax,%eax
  800382:	75 10                	jne    800394 <PrintElements+0x33>
			cprintf("\n");
  800384:	83 ec 0c             	sub    $0xc,%esp
  800387:	68 e4 2c 80 00       	push   $0x802ce4
  80038c:	e8 e6 02 00 00       	call   800677 <cprintf>
  800391:	83 c4 10             	add    $0x10,%esp
		cprintf("%d, ",Elements[i]);
  800394:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800397:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80039e:	8b 45 08             	mov    0x8(%ebp),%eax
  8003a1:	01 d0                	add    %edx,%eax
  8003a3:	8b 00                	mov    (%eax),%eax
  8003a5:	83 ec 08             	sub    $0x8,%esp
  8003a8:	50                   	push   %eax
  8003a9:	68 e6 2c 80 00       	push   $0x802ce6
  8003ae:	e8 c4 02 00 00       	call   800677 <cprintf>
  8003b3:	83 c4 10             	add    $0x10,%esp

void PrintElements(int *Elements, int NumOfElements)
{
	int i ;
	int NumsPerLine = 20 ;
	for (i = 0 ; i < NumOfElements-1 ; i++)
  8003b6:	ff 45 f4             	incl   -0xc(%ebp)
  8003b9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003bc:	48                   	dec    %eax
  8003bd:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8003c0:	7f b5                	jg     800377 <PrintElements+0x16>
	{
		if (i%NumsPerLine == 0)
			cprintf("\n");
		cprintf("%d, ",Elements[i]);
	}
	cprintf("%d\n",Elements[i]);
  8003c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8003c5:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8003cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8003cf:	01 d0                	add    %edx,%eax
  8003d1:	8b 00                	mov    (%eax),%eax
  8003d3:	83 ec 08             	sub    $0x8,%esp
  8003d6:	50                   	push   %eax
  8003d7:	68 eb 2c 80 00       	push   $0x802ceb
  8003dc:	e8 96 02 00 00       	call   800677 <cprintf>
  8003e1:	83 c4 10             	add    $0x10,%esp

}
  8003e4:	90                   	nop
  8003e5:	c9                   	leave  
  8003e6:	c3                   	ret    

008003e7 <libmain>:
volatile bool printStats = 1;

volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";
void
libmain(int argc, char **argv)
{
  8003e7:	55                   	push   %ebp
  8003e8:	89 e5                	mov    %esp,%ebp
  8003ea:	57                   	push   %edi
  8003eb:	56                   	push   %esi
  8003ec:	53                   	push   %ebx
  8003ed:	83 ec 7c             	sub    $0x7c,%esp
	//printStats = 1;
	int envIndex = sys_getenvindex();
  8003f0:	e8 06 16 00 00       	call   8019fb <sys_getenvindex>
  8003f5:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	myEnv = &(envs[envIndex]);
  8003f8:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8003fb:	89 d0                	mov    %edx,%eax
  8003fd:	c1 e0 02             	shl    $0x2,%eax
  800400:	01 d0                	add    %edx,%eax
  800402:	c1 e0 03             	shl    $0x3,%eax
  800405:	01 d0                	add    %edx,%eax
  800407:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  80040e:	01 d0                	add    %edx,%eax
  800410:	c1 e0 02             	shl    $0x2,%eax
  800413:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800418:	a3 20 40 80 00       	mov    %eax,0x804020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  80041d:	a1 20 40 80 00       	mov    0x804020,%eax
  800422:	8a 40 20             	mov    0x20(%eax),%al
  800425:	84 c0                	test   %al,%al
  800427:	74 0d                	je     800436 <libmain+0x4f>
		binaryname = myEnv->prog_name;
  800429:	a1 20 40 80 00       	mov    0x804020,%eax
  80042e:	83 c0 20             	add    $0x20,%eax
  800431:	a3 04 40 80 00       	mov    %eax,0x804004

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800436:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80043a:	7e 0a                	jle    800446 <libmain+0x5f>
		binaryname = argv[0];
  80043c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80043f:	8b 00                	mov    (%eax),%eax
  800441:	a3 04 40 80 00       	mov    %eax,0x804004

	// call user main routine
	_main(argc, argv);
  800446:	83 ec 08             	sub    $0x8,%esp
  800449:	ff 75 0c             	pushl  0xc(%ebp)
  80044c:	ff 75 08             	pushl  0x8(%ebp)
  80044f:	e8 e4 fb ff ff       	call   800038 <_main>
  800454:	83 c4 10             	add    $0x10,%esp

	if (printStats)
  800457:	a1 00 40 80 00       	mov    0x804000,%eax
  80045c:	85 c0                	test   %eax,%eax
  80045e:	0f 84 01 01 00 00    	je     800565 <libmain+0x17e>
	{
		char isOPTReplCmd[100] = "__IsOPTRepl__" ;
  800464:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  80046a:	bb e8 2d 80 00       	mov    $0x802de8,%ebx
  80046f:	ba 0e 00 00 00       	mov    $0xe,%edx
  800474:	89 c7                	mov    %eax,%edi
  800476:	89 de                	mov    %ebx,%esi
  800478:	89 d1                	mov    %edx,%ecx
  80047a:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  80047c:	8d 55 8a             	lea    -0x76(%ebp),%edx
  80047f:	b9 56 00 00 00       	mov    $0x56,%ecx
  800484:	b0 00                	mov    $0x0,%al
  800486:	89 d7                	mov    %edx,%edi
  800488:	f3 aa                	rep stos %al,%es:(%edi)
		int isOPTRepl = 0;
  80048a:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
		sys_utilities(isOPTReplCmd, (uint32)(&isOPTRepl));
  800491:	8d 45 e0             	lea    -0x20(%ebp),%eax
  800494:	83 ec 08             	sub    $0x8,%esp
  800497:	50                   	push   %eax
  800498:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  80049e:	50                   	push   %eax
  80049f:	e8 8d 17 00 00       	call   801c31 <sys_utilities>
  8004a4:	83 c4 10             	add    $0x10,%esp

		sys_lock_cons();
  8004a7:	e8 d6 12 00 00       	call   801782 <sys_lock_cons>
		{
			cprintf("**************************************\n");
  8004ac:	83 ec 0c             	sub    $0xc,%esp
  8004af:	68 08 2d 80 00       	push   $0x802d08
  8004b4:	e8 be 01 00 00       	call   800677 <cprintf>
  8004b9:	83 c4 10             	add    $0x10,%esp
			if (isOPTRepl)
  8004bc:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8004bf:	85 c0                	test   %eax,%eax
  8004c1:	74 18                	je     8004db <libmain+0xf4>
			{
				cprintf("OPTIMAL number of page faults = %d\n", sys_get_optimal_num_faults());
  8004c3:	e8 87 17 00 00       	call   801c4f <sys_get_optimal_num_faults>
  8004c8:	83 ec 08             	sub    $0x8,%esp
  8004cb:	50                   	push   %eax
  8004cc:	68 30 2d 80 00       	push   $0x802d30
  8004d1:	e8 a1 01 00 00       	call   800677 <cprintf>
  8004d6:	83 c4 10             	add    $0x10,%esp
  8004d9:	eb 59                	jmp    800534 <libmain+0x14d>
			}
			else
			{
				cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8004db:	a1 20 40 80 00       	mov    0x804020,%eax
  8004e0:	8b 90 a8 05 00 00    	mov    0x5a8(%eax),%edx
  8004e6:	a1 20 40 80 00       	mov    0x804020,%eax
  8004eb:	8b 80 98 05 00 00    	mov    0x598(%eax),%eax
  8004f1:	83 ec 04             	sub    $0x4,%esp
  8004f4:	52                   	push   %edx
  8004f5:	50                   	push   %eax
  8004f6:	68 54 2d 80 00       	push   $0x802d54
  8004fb:	e8 77 01 00 00       	call   800677 <cprintf>
  800500:	83 c4 10             	add    $0x10,%esp
				cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800503:	a1 20 40 80 00       	mov    0x804020,%eax
  800508:	8b 88 bc 05 00 00    	mov    0x5bc(%eax),%ecx
  80050e:	a1 20 40 80 00       	mov    0x804020,%eax
  800513:	8b 90 b8 05 00 00    	mov    0x5b8(%eax),%edx
  800519:	a1 20 40 80 00       	mov    0x804020,%eax
  80051e:	8b 80 b4 05 00 00    	mov    0x5b4(%eax),%eax
  800524:	51                   	push   %ecx
  800525:	52                   	push   %edx
  800526:	50                   	push   %eax
  800527:	68 7c 2d 80 00       	push   $0x802d7c
  80052c:	e8 46 01 00 00       	call   800677 <cprintf>
  800531:	83 c4 10             	add    $0x10,%esp
			}
			//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
			cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800534:	a1 20 40 80 00       	mov    0x804020,%eax
  800539:	8b 80 c0 05 00 00    	mov    0x5c0(%eax),%eax
  80053f:	83 ec 08             	sub    $0x8,%esp
  800542:	50                   	push   %eax
  800543:	68 d4 2d 80 00       	push   $0x802dd4
  800548:	e8 2a 01 00 00       	call   800677 <cprintf>
  80054d:	83 c4 10             	add    $0x10,%esp
			cprintf("**************************************\n");
  800550:	83 ec 0c             	sub    $0xc,%esp
  800553:	68 08 2d 80 00       	push   $0x802d08
  800558:	e8 1a 01 00 00       	call   800677 <cprintf>
  80055d:	83 c4 10             	add    $0x10,%esp
		}
		sys_unlock_cons();
  800560:	e8 37 12 00 00       	call   80179c <sys_unlock_cons>
	}

	// exit gracefully
	exit();
  800565:	e8 1f 00 00 00       	call   800589 <exit>
}
  80056a:	90                   	nop
  80056b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80056e:	5b                   	pop    %ebx
  80056f:	5e                   	pop    %esi
  800570:	5f                   	pop    %edi
  800571:	5d                   	pop    %ebp
  800572:	c3                   	ret    

00800573 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800573:	55                   	push   %ebp
  800574:	89 e5                	mov    %esp,%ebp
  800576:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800579:	83 ec 0c             	sub    $0xc,%esp
  80057c:	6a 00                	push   $0x0
  80057e:	e8 44 14 00 00       	call   8019c7 <sys_destroy_env>
  800583:	83 c4 10             	add    $0x10,%esp
}
  800586:	90                   	nop
  800587:	c9                   	leave  
  800588:	c3                   	ret    

00800589 <exit>:

void
exit(void)
{
  800589:	55                   	push   %ebp
  80058a:	89 e5                	mov    %esp,%ebp
  80058c:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  80058f:	e8 99 14 00 00       	call   801a2d <sys_exit_env>
}
  800594:	90                   	nop
  800595:	c9                   	leave  
  800596:	c3                   	ret    

00800597 <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  800597:	55                   	push   %ebp
  800598:	89 e5                	mov    %esp,%ebp
  80059a:	53                   	push   %ebx
  80059b:	83 ec 04             	sub    $0x4,%esp
	b->buf[b->idx++] = ch;
  80059e:	8b 45 0c             	mov    0xc(%ebp),%eax
  8005a1:	8b 00                	mov    (%eax),%eax
  8005a3:	8d 48 01             	lea    0x1(%eax),%ecx
  8005a6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8005a9:	89 0a                	mov    %ecx,(%edx)
  8005ab:	8b 55 08             	mov    0x8(%ebp),%edx
  8005ae:	88 d1                	mov    %dl,%cl
  8005b0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8005b3:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  8005b7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8005ba:	8b 00                	mov    (%eax),%eax
  8005bc:	3d ff 00 00 00       	cmp    $0xff,%eax
  8005c1:	75 30                	jne    8005f3 <putch+0x5c>
		sys_cputs(b->buf, b->idx, printProgName, curTextClr);
  8005c3:	8b 15 18 c1 81 00    	mov    0x81c118,%edx
  8005c9:	a0 44 40 80 00       	mov    0x804044,%al
  8005ce:	0f b6 c0             	movzbl %al,%eax
  8005d1:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8005d4:	8b 09                	mov    (%ecx),%ecx
  8005d6:	89 cb                	mov    %ecx,%ebx
  8005d8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8005db:	83 c1 08             	add    $0x8,%ecx
  8005de:	52                   	push   %edx
  8005df:	50                   	push   %eax
  8005e0:	53                   	push   %ebx
  8005e1:	51                   	push   %ecx
  8005e2:	e8 57 11 00 00       	call   80173e <sys_cputs>
  8005e7:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8005ea:	8b 45 0c             	mov    0xc(%ebp),%eax
  8005ed:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8005f3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8005f6:	8b 40 04             	mov    0x4(%eax),%eax
  8005f9:	8d 50 01             	lea    0x1(%eax),%edx
  8005fc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8005ff:	89 50 04             	mov    %edx,0x4(%eax)
}
  800602:	90                   	nop
  800603:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800606:	c9                   	leave  
  800607:	c3                   	ret    

00800608 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800608:	55                   	push   %ebp
  800609:	89 e5                	mov    %esp,%ebp
  80060b:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800611:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800618:	00 00 00 
	b.cnt = 0;
  80061b:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800622:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800625:	ff 75 0c             	pushl  0xc(%ebp)
  800628:	ff 75 08             	pushl  0x8(%ebp)
  80062b:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800631:	50                   	push   %eax
  800632:	68 97 05 80 00       	push   $0x800597
  800637:	e8 5a 02 00 00       	call   800896 <vprintfmt>
  80063c:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName, curTextClr);
  80063f:	8b 15 18 c1 81 00    	mov    0x81c118,%edx
  800645:	a0 44 40 80 00       	mov    0x804044,%al
  80064a:	0f b6 c0             	movzbl %al,%eax
  80064d:	8b 8d f0 fe ff ff    	mov    -0x110(%ebp),%ecx
  800653:	52                   	push   %edx
  800654:	50                   	push   %eax
  800655:	51                   	push   %ecx
  800656:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80065c:	83 c0 08             	add    $0x8,%eax
  80065f:	50                   	push   %eax
  800660:	e8 d9 10 00 00       	call   80173e <sys_cputs>
  800665:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800668:	c6 05 44 40 80 00 00 	movb   $0x0,0x804044
	return b.cnt;
  80066f:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800675:	c9                   	leave  
  800676:	c3                   	ret    

00800677 <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  800677:	55                   	push   %ebp
  800678:	89 e5                	mov    %esp,%ebp
  80067a:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  80067d:	c6 05 44 40 80 00 01 	movb   $0x1,0x804044
	va_start(ap, fmt);
  800684:	8d 45 0c             	lea    0xc(%ebp),%eax
  800687:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  80068a:	8b 45 08             	mov    0x8(%ebp),%eax
  80068d:	83 ec 08             	sub    $0x8,%esp
  800690:	ff 75 f4             	pushl  -0xc(%ebp)
  800693:	50                   	push   %eax
  800694:	e8 6f ff ff ff       	call   800608 <vcprintf>
  800699:	83 c4 10             	add    $0x10,%esp
  80069c:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  80069f:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8006a2:	c9                   	leave  
  8006a3:	c3                   	ret    

008006a4 <cprintf_colored>:

// *************** This text coloring feature is implemented by *************
// ********** Abd-Alrahman Zedan From Team Frozen-Bytes - FCIS'24-25 ********
int cprintf_colored(int textClr, const char *fmt, ...) {
  8006a4:	55                   	push   %ebp
  8006a5:	89 e5                	mov    %esp,%ebp
  8006a7:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  8006aa:	c6 05 44 40 80 00 01 	movb   $0x1,0x804044
	curTextClr = (textClr << 8) ; //set text color by the given value
  8006b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8006b4:	c1 e0 08             	shl    $0x8,%eax
  8006b7:	a3 18 c1 81 00       	mov    %eax,0x81c118
	va_start(ap, fmt);
  8006bc:	8d 45 0c             	lea    0xc(%ebp),%eax
  8006bf:	83 c0 04             	add    $0x4,%eax
  8006c2:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8006c5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006c8:	83 ec 08             	sub    $0x8,%esp
  8006cb:	ff 75 f4             	pushl  -0xc(%ebp)
  8006ce:	50                   	push   %eax
  8006cf:	e8 34 ff ff ff       	call   800608 <vcprintf>
  8006d4:	83 c4 10             	add    $0x10,%esp
  8006d7:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);
	curTextClr = TEXT_DEFAULT_CLR; //restore default color
  8006da:	c7 05 18 c1 81 00 00 	movl   $0x700,0x81c118
  8006e1:	07 00 00 

	return cnt;
  8006e4:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8006e7:	c9                   	leave  
  8006e8:	c3                   	ret    

008006e9 <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  8006e9:	55                   	push   %ebp
  8006ea:	89 e5                	mov    %esp,%ebp
  8006ec:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  8006ef:	e8 8e 10 00 00       	call   801782 <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  8006f4:	8d 45 0c             	lea    0xc(%ebp),%eax
  8006f7:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  8006fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8006fd:	83 ec 08             	sub    $0x8,%esp
  800700:	ff 75 f4             	pushl  -0xc(%ebp)
  800703:	50                   	push   %eax
  800704:	e8 ff fe ff ff       	call   800608 <vcprintf>
  800709:	83 c4 10             	add    $0x10,%esp
  80070c:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  80070f:	e8 88 10 00 00       	call   80179c <sys_unlock_cons>
	return cnt;
  800714:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800717:	c9                   	leave  
  800718:	c3                   	ret    

00800719 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800719:	55                   	push   %ebp
  80071a:	89 e5                	mov    %esp,%ebp
  80071c:	53                   	push   %ebx
  80071d:	83 ec 14             	sub    $0x14,%esp
  800720:	8b 45 10             	mov    0x10(%ebp),%eax
  800723:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800726:	8b 45 14             	mov    0x14(%ebp),%eax
  800729:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  80072c:	8b 45 18             	mov    0x18(%ebp),%eax
  80072f:	ba 00 00 00 00       	mov    $0x0,%edx
  800734:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800737:	77 55                	ja     80078e <printnum+0x75>
  800739:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  80073c:	72 05                	jb     800743 <printnum+0x2a>
  80073e:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800741:	77 4b                	ja     80078e <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800743:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800746:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800749:	8b 45 18             	mov    0x18(%ebp),%eax
  80074c:	ba 00 00 00 00       	mov    $0x0,%edx
  800751:	52                   	push   %edx
  800752:	50                   	push   %eax
  800753:	ff 75 f4             	pushl  -0xc(%ebp)
  800756:	ff 75 f0             	pushl  -0x10(%ebp)
  800759:	e8 6a 22 00 00       	call   8029c8 <__udivdi3>
  80075e:	83 c4 10             	add    $0x10,%esp
  800761:	83 ec 04             	sub    $0x4,%esp
  800764:	ff 75 20             	pushl  0x20(%ebp)
  800767:	53                   	push   %ebx
  800768:	ff 75 18             	pushl  0x18(%ebp)
  80076b:	52                   	push   %edx
  80076c:	50                   	push   %eax
  80076d:	ff 75 0c             	pushl  0xc(%ebp)
  800770:	ff 75 08             	pushl  0x8(%ebp)
  800773:	e8 a1 ff ff ff       	call   800719 <printnum>
  800778:	83 c4 20             	add    $0x20,%esp
  80077b:	eb 1a                	jmp    800797 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  80077d:	83 ec 08             	sub    $0x8,%esp
  800780:	ff 75 0c             	pushl  0xc(%ebp)
  800783:	ff 75 20             	pushl  0x20(%ebp)
  800786:	8b 45 08             	mov    0x8(%ebp),%eax
  800789:	ff d0                	call   *%eax
  80078b:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80078e:	ff 4d 1c             	decl   0x1c(%ebp)
  800791:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800795:	7f e6                	jg     80077d <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800797:	8b 4d 18             	mov    0x18(%ebp),%ecx
  80079a:	bb 00 00 00 00       	mov    $0x0,%ebx
  80079f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8007a2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8007a5:	53                   	push   %ebx
  8007a6:	51                   	push   %ecx
  8007a7:	52                   	push   %edx
  8007a8:	50                   	push   %eax
  8007a9:	e8 2a 23 00 00       	call   802ad8 <__umoddi3>
  8007ae:	83 c4 10             	add    $0x10,%esp
  8007b1:	05 74 30 80 00       	add    $0x803074,%eax
  8007b6:	8a 00                	mov    (%eax),%al
  8007b8:	0f be c0             	movsbl %al,%eax
  8007bb:	83 ec 08             	sub    $0x8,%esp
  8007be:	ff 75 0c             	pushl  0xc(%ebp)
  8007c1:	50                   	push   %eax
  8007c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8007c5:	ff d0                	call   *%eax
  8007c7:	83 c4 10             	add    $0x10,%esp
}
  8007ca:	90                   	nop
  8007cb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8007ce:	c9                   	leave  
  8007cf:	c3                   	ret    

008007d0 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8007d0:	55                   	push   %ebp
  8007d1:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8007d3:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8007d7:	7e 1c                	jle    8007f5 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  8007d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8007dc:	8b 00                	mov    (%eax),%eax
  8007de:	8d 50 08             	lea    0x8(%eax),%edx
  8007e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8007e4:	89 10                	mov    %edx,(%eax)
  8007e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8007e9:	8b 00                	mov    (%eax),%eax
  8007eb:	83 e8 08             	sub    $0x8,%eax
  8007ee:	8b 50 04             	mov    0x4(%eax),%edx
  8007f1:	8b 00                	mov    (%eax),%eax
  8007f3:	eb 40                	jmp    800835 <getuint+0x65>
	else if (lflag)
  8007f5:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8007f9:	74 1e                	je     800819 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  8007fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8007fe:	8b 00                	mov    (%eax),%eax
  800800:	8d 50 04             	lea    0x4(%eax),%edx
  800803:	8b 45 08             	mov    0x8(%ebp),%eax
  800806:	89 10                	mov    %edx,(%eax)
  800808:	8b 45 08             	mov    0x8(%ebp),%eax
  80080b:	8b 00                	mov    (%eax),%eax
  80080d:	83 e8 04             	sub    $0x4,%eax
  800810:	8b 00                	mov    (%eax),%eax
  800812:	ba 00 00 00 00       	mov    $0x0,%edx
  800817:	eb 1c                	jmp    800835 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800819:	8b 45 08             	mov    0x8(%ebp),%eax
  80081c:	8b 00                	mov    (%eax),%eax
  80081e:	8d 50 04             	lea    0x4(%eax),%edx
  800821:	8b 45 08             	mov    0x8(%ebp),%eax
  800824:	89 10                	mov    %edx,(%eax)
  800826:	8b 45 08             	mov    0x8(%ebp),%eax
  800829:	8b 00                	mov    (%eax),%eax
  80082b:	83 e8 04             	sub    $0x4,%eax
  80082e:	8b 00                	mov    (%eax),%eax
  800830:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800835:	5d                   	pop    %ebp
  800836:	c3                   	ret    

00800837 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800837:	55                   	push   %ebp
  800838:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  80083a:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  80083e:	7e 1c                	jle    80085c <getint+0x25>
		return va_arg(*ap, long long);
  800840:	8b 45 08             	mov    0x8(%ebp),%eax
  800843:	8b 00                	mov    (%eax),%eax
  800845:	8d 50 08             	lea    0x8(%eax),%edx
  800848:	8b 45 08             	mov    0x8(%ebp),%eax
  80084b:	89 10                	mov    %edx,(%eax)
  80084d:	8b 45 08             	mov    0x8(%ebp),%eax
  800850:	8b 00                	mov    (%eax),%eax
  800852:	83 e8 08             	sub    $0x8,%eax
  800855:	8b 50 04             	mov    0x4(%eax),%edx
  800858:	8b 00                	mov    (%eax),%eax
  80085a:	eb 38                	jmp    800894 <getint+0x5d>
	else if (lflag)
  80085c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800860:	74 1a                	je     80087c <getint+0x45>
		return va_arg(*ap, long);
  800862:	8b 45 08             	mov    0x8(%ebp),%eax
  800865:	8b 00                	mov    (%eax),%eax
  800867:	8d 50 04             	lea    0x4(%eax),%edx
  80086a:	8b 45 08             	mov    0x8(%ebp),%eax
  80086d:	89 10                	mov    %edx,(%eax)
  80086f:	8b 45 08             	mov    0x8(%ebp),%eax
  800872:	8b 00                	mov    (%eax),%eax
  800874:	83 e8 04             	sub    $0x4,%eax
  800877:	8b 00                	mov    (%eax),%eax
  800879:	99                   	cltd   
  80087a:	eb 18                	jmp    800894 <getint+0x5d>
	else
		return va_arg(*ap, int);
  80087c:	8b 45 08             	mov    0x8(%ebp),%eax
  80087f:	8b 00                	mov    (%eax),%eax
  800881:	8d 50 04             	lea    0x4(%eax),%edx
  800884:	8b 45 08             	mov    0x8(%ebp),%eax
  800887:	89 10                	mov    %edx,(%eax)
  800889:	8b 45 08             	mov    0x8(%ebp),%eax
  80088c:	8b 00                	mov    (%eax),%eax
  80088e:	83 e8 04             	sub    $0x4,%eax
  800891:	8b 00                	mov    (%eax),%eax
  800893:	99                   	cltd   
}
  800894:	5d                   	pop    %ebp
  800895:	c3                   	ret    

00800896 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800896:	55                   	push   %ebp
  800897:	89 e5                	mov    %esp,%ebp
  800899:	56                   	push   %esi
  80089a:	53                   	push   %ebx
  80089b:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80089e:	eb 17                	jmp    8008b7 <vprintfmt+0x21>
			if (ch == '\0')
  8008a0:	85 db                	test   %ebx,%ebx
  8008a2:	0f 84 c1 03 00 00    	je     800c69 <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  8008a8:	83 ec 08             	sub    $0x8,%esp
  8008ab:	ff 75 0c             	pushl  0xc(%ebp)
  8008ae:	53                   	push   %ebx
  8008af:	8b 45 08             	mov    0x8(%ebp),%eax
  8008b2:	ff d0                	call   *%eax
  8008b4:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8008b7:	8b 45 10             	mov    0x10(%ebp),%eax
  8008ba:	8d 50 01             	lea    0x1(%eax),%edx
  8008bd:	89 55 10             	mov    %edx,0x10(%ebp)
  8008c0:	8a 00                	mov    (%eax),%al
  8008c2:	0f b6 d8             	movzbl %al,%ebx
  8008c5:	83 fb 25             	cmp    $0x25,%ebx
  8008c8:	75 d6                	jne    8008a0 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  8008ca:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  8008ce:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  8008d5:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8008dc:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  8008e3:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8008ea:	8b 45 10             	mov    0x10(%ebp),%eax
  8008ed:	8d 50 01             	lea    0x1(%eax),%edx
  8008f0:	89 55 10             	mov    %edx,0x10(%ebp)
  8008f3:	8a 00                	mov    (%eax),%al
  8008f5:	0f b6 d8             	movzbl %al,%ebx
  8008f8:	8d 43 dd             	lea    -0x23(%ebx),%eax
  8008fb:	83 f8 5b             	cmp    $0x5b,%eax
  8008fe:	0f 87 3d 03 00 00    	ja     800c41 <vprintfmt+0x3ab>
  800904:	8b 04 85 98 30 80 00 	mov    0x803098(,%eax,4),%eax
  80090b:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  80090d:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800911:	eb d7                	jmp    8008ea <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800913:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800917:	eb d1                	jmp    8008ea <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800919:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800920:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800923:	89 d0                	mov    %edx,%eax
  800925:	c1 e0 02             	shl    $0x2,%eax
  800928:	01 d0                	add    %edx,%eax
  80092a:	01 c0                	add    %eax,%eax
  80092c:	01 d8                	add    %ebx,%eax
  80092e:	83 e8 30             	sub    $0x30,%eax
  800931:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800934:	8b 45 10             	mov    0x10(%ebp),%eax
  800937:	8a 00                	mov    (%eax),%al
  800939:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  80093c:	83 fb 2f             	cmp    $0x2f,%ebx
  80093f:	7e 3e                	jle    80097f <vprintfmt+0xe9>
  800941:	83 fb 39             	cmp    $0x39,%ebx
  800944:	7f 39                	jg     80097f <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800946:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800949:	eb d5                	jmp    800920 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  80094b:	8b 45 14             	mov    0x14(%ebp),%eax
  80094e:	83 c0 04             	add    $0x4,%eax
  800951:	89 45 14             	mov    %eax,0x14(%ebp)
  800954:	8b 45 14             	mov    0x14(%ebp),%eax
  800957:	83 e8 04             	sub    $0x4,%eax
  80095a:	8b 00                	mov    (%eax),%eax
  80095c:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  80095f:	eb 1f                	jmp    800980 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800961:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800965:	79 83                	jns    8008ea <vprintfmt+0x54>
				width = 0;
  800967:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  80096e:	e9 77 ff ff ff       	jmp    8008ea <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800973:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  80097a:	e9 6b ff ff ff       	jmp    8008ea <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  80097f:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800980:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800984:	0f 89 60 ff ff ff    	jns    8008ea <vprintfmt+0x54>
				width = precision, precision = -1;
  80098a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80098d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800990:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800997:	e9 4e ff ff ff       	jmp    8008ea <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  80099c:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  80099f:	e9 46 ff ff ff       	jmp    8008ea <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  8009a4:	8b 45 14             	mov    0x14(%ebp),%eax
  8009a7:	83 c0 04             	add    $0x4,%eax
  8009aa:	89 45 14             	mov    %eax,0x14(%ebp)
  8009ad:	8b 45 14             	mov    0x14(%ebp),%eax
  8009b0:	83 e8 04             	sub    $0x4,%eax
  8009b3:	8b 00                	mov    (%eax),%eax
  8009b5:	83 ec 08             	sub    $0x8,%esp
  8009b8:	ff 75 0c             	pushl  0xc(%ebp)
  8009bb:	50                   	push   %eax
  8009bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8009bf:	ff d0                	call   *%eax
  8009c1:	83 c4 10             	add    $0x10,%esp
			break;
  8009c4:	e9 9b 02 00 00       	jmp    800c64 <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  8009c9:	8b 45 14             	mov    0x14(%ebp),%eax
  8009cc:	83 c0 04             	add    $0x4,%eax
  8009cf:	89 45 14             	mov    %eax,0x14(%ebp)
  8009d2:	8b 45 14             	mov    0x14(%ebp),%eax
  8009d5:	83 e8 04             	sub    $0x4,%eax
  8009d8:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  8009da:	85 db                	test   %ebx,%ebx
  8009dc:	79 02                	jns    8009e0 <vprintfmt+0x14a>
				err = -err;
  8009de:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  8009e0:	83 fb 64             	cmp    $0x64,%ebx
  8009e3:	7f 0b                	jg     8009f0 <vprintfmt+0x15a>
  8009e5:	8b 34 9d e0 2e 80 00 	mov    0x802ee0(,%ebx,4),%esi
  8009ec:	85 f6                	test   %esi,%esi
  8009ee:	75 19                	jne    800a09 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  8009f0:	53                   	push   %ebx
  8009f1:	68 85 30 80 00       	push   $0x803085
  8009f6:	ff 75 0c             	pushl  0xc(%ebp)
  8009f9:	ff 75 08             	pushl  0x8(%ebp)
  8009fc:	e8 70 02 00 00       	call   800c71 <printfmt>
  800a01:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800a04:	e9 5b 02 00 00       	jmp    800c64 <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800a09:	56                   	push   %esi
  800a0a:	68 8e 30 80 00       	push   $0x80308e
  800a0f:	ff 75 0c             	pushl  0xc(%ebp)
  800a12:	ff 75 08             	pushl  0x8(%ebp)
  800a15:	e8 57 02 00 00       	call   800c71 <printfmt>
  800a1a:	83 c4 10             	add    $0x10,%esp
			break;
  800a1d:	e9 42 02 00 00       	jmp    800c64 <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800a22:	8b 45 14             	mov    0x14(%ebp),%eax
  800a25:	83 c0 04             	add    $0x4,%eax
  800a28:	89 45 14             	mov    %eax,0x14(%ebp)
  800a2b:	8b 45 14             	mov    0x14(%ebp),%eax
  800a2e:	83 e8 04             	sub    $0x4,%eax
  800a31:	8b 30                	mov    (%eax),%esi
  800a33:	85 f6                	test   %esi,%esi
  800a35:	75 05                	jne    800a3c <vprintfmt+0x1a6>
				p = "(null)";
  800a37:	be 91 30 80 00       	mov    $0x803091,%esi
			if (width > 0 && padc != '-')
  800a3c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a40:	7e 6d                	jle    800aaf <vprintfmt+0x219>
  800a42:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800a46:	74 67                	je     800aaf <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800a48:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800a4b:	83 ec 08             	sub    $0x8,%esp
  800a4e:	50                   	push   %eax
  800a4f:	56                   	push   %esi
  800a50:	e8 1e 03 00 00       	call   800d73 <strnlen>
  800a55:	83 c4 10             	add    $0x10,%esp
  800a58:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800a5b:	eb 16                	jmp    800a73 <vprintfmt+0x1dd>
					putch(padc, putdat);
  800a5d:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800a61:	83 ec 08             	sub    $0x8,%esp
  800a64:	ff 75 0c             	pushl  0xc(%ebp)
  800a67:	50                   	push   %eax
  800a68:	8b 45 08             	mov    0x8(%ebp),%eax
  800a6b:	ff d0                	call   *%eax
  800a6d:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800a70:	ff 4d e4             	decl   -0x1c(%ebp)
  800a73:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a77:	7f e4                	jg     800a5d <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800a79:	eb 34                	jmp    800aaf <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800a7b:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800a7f:	74 1c                	je     800a9d <vprintfmt+0x207>
  800a81:	83 fb 1f             	cmp    $0x1f,%ebx
  800a84:	7e 05                	jle    800a8b <vprintfmt+0x1f5>
  800a86:	83 fb 7e             	cmp    $0x7e,%ebx
  800a89:	7e 12                	jle    800a9d <vprintfmt+0x207>
					putch('?', putdat);
  800a8b:	83 ec 08             	sub    $0x8,%esp
  800a8e:	ff 75 0c             	pushl  0xc(%ebp)
  800a91:	6a 3f                	push   $0x3f
  800a93:	8b 45 08             	mov    0x8(%ebp),%eax
  800a96:	ff d0                	call   *%eax
  800a98:	83 c4 10             	add    $0x10,%esp
  800a9b:	eb 0f                	jmp    800aac <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800a9d:	83 ec 08             	sub    $0x8,%esp
  800aa0:	ff 75 0c             	pushl  0xc(%ebp)
  800aa3:	53                   	push   %ebx
  800aa4:	8b 45 08             	mov    0x8(%ebp),%eax
  800aa7:	ff d0                	call   *%eax
  800aa9:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800aac:	ff 4d e4             	decl   -0x1c(%ebp)
  800aaf:	89 f0                	mov    %esi,%eax
  800ab1:	8d 70 01             	lea    0x1(%eax),%esi
  800ab4:	8a 00                	mov    (%eax),%al
  800ab6:	0f be d8             	movsbl %al,%ebx
  800ab9:	85 db                	test   %ebx,%ebx
  800abb:	74 24                	je     800ae1 <vprintfmt+0x24b>
  800abd:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800ac1:	78 b8                	js     800a7b <vprintfmt+0x1e5>
  800ac3:	ff 4d e0             	decl   -0x20(%ebp)
  800ac6:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800aca:	79 af                	jns    800a7b <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800acc:	eb 13                	jmp    800ae1 <vprintfmt+0x24b>
				putch(' ', putdat);
  800ace:	83 ec 08             	sub    $0x8,%esp
  800ad1:	ff 75 0c             	pushl  0xc(%ebp)
  800ad4:	6a 20                	push   $0x20
  800ad6:	8b 45 08             	mov    0x8(%ebp),%eax
  800ad9:	ff d0                	call   *%eax
  800adb:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800ade:	ff 4d e4             	decl   -0x1c(%ebp)
  800ae1:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800ae5:	7f e7                	jg     800ace <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800ae7:	e9 78 01 00 00       	jmp    800c64 <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800aec:	83 ec 08             	sub    $0x8,%esp
  800aef:	ff 75 e8             	pushl  -0x18(%ebp)
  800af2:	8d 45 14             	lea    0x14(%ebp),%eax
  800af5:	50                   	push   %eax
  800af6:	e8 3c fd ff ff       	call   800837 <getint>
  800afb:	83 c4 10             	add    $0x10,%esp
  800afe:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b01:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800b04:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800b07:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800b0a:	85 d2                	test   %edx,%edx
  800b0c:	79 23                	jns    800b31 <vprintfmt+0x29b>
				putch('-', putdat);
  800b0e:	83 ec 08             	sub    $0x8,%esp
  800b11:	ff 75 0c             	pushl  0xc(%ebp)
  800b14:	6a 2d                	push   $0x2d
  800b16:	8b 45 08             	mov    0x8(%ebp),%eax
  800b19:	ff d0                	call   *%eax
  800b1b:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800b1e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800b21:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800b24:	f7 d8                	neg    %eax
  800b26:	83 d2 00             	adc    $0x0,%edx
  800b29:	f7 da                	neg    %edx
  800b2b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b2e:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800b31:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800b38:	e9 bc 00 00 00       	jmp    800bf9 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800b3d:	83 ec 08             	sub    $0x8,%esp
  800b40:	ff 75 e8             	pushl  -0x18(%ebp)
  800b43:	8d 45 14             	lea    0x14(%ebp),%eax
  800b46:	50                   	push   %eax
  800b47:	e8 84 fc ff ff       	call   8007d0 <getuint>
  800b4c:	83 c4 10             	add    $0x10,%esp
  800b4f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b52:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800b55:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800b5c:	e9 98 00 00 00       	jmp    800bf9 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800b61:	83 ec 08             	sub    $0x8,%esp
  800b64:	ff 75 0c             	pushl  0xc(%ebp)
  800b67:	6a 58                	push   $0x58
  800b69:	8b 45 08             	mov    0x8(%ebp),%eax
  800b6c:	ff d0                	call   *%eax
  800b6e:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800b71:	83 ec 08             	sub    $0x8,%esp
  800b74:	ff 75 0c             	pushl  0xc(%ebp)
  800b77:	6a 58                	push   $0x58
  800b79:	8b 45 08             	mov    0x8(%ebp),%eax
  800b7c:	ff d0                	call   *%eax
  800b7e:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800b81:	83 ec 08             	sub    $0x8,%esp
  800b84:	ff 75 0c             	pushl  0xc(%ebp)
  800b87:	6a 58                	push   $0x58
  800b89:	8b 45 08             	mov    0x8(%ebp),%eax
  800b8c:	ff d0                	call   *%eax
  800b8e:	83 c4 10             	add    $0x10,%esp
			break;
  800b91:	e9 ce 00 00 00       	jmp    800c64 <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  800b96:	83 ec 08             	sub    $0x8,%esp
  800b99:	ff 75 0c             	pushl  0xc(%ebp)
  800b9c:	6a 30                	push   $0x30
  800b9e:	8b 45 08             	mov    0x8(%ebp),%eax
  800ba1:	ff d0                	call   *%eax
  800ba3:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800ba6:	83 ec 08             	sub    $0x8,%esp
  800ba9:	ff 75 0c             	pushl  0xc(%ebp)
  800bac:	6a 78                	push   $0x78
  800bae:	8b 45 08             	mov    0x8(%ebp),%eax
  800bb1:	ff d0                	call   *%eax
  800bb3:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800bb6:	8b 45 14             	mov    0x14(%ebp),%eax
  800bb9:	83 c0 04             	add    $0x4,%eax
  800bbc:	89 45 14             	mov    %eax,0x14(%ebp)
  800bbf:	8b 45 14             	mov    0x14(%ebp),%eax
  800bc2:	83 e8 04             	sub    $0x4,%eax
  800bc5:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800bc7:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800bca:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800bd1:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800bd8:	eb 1f                	jmp    800bf9 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800bda:	83 ec 08             	sub    $0x8,%esp
  800bdd:	ff 75 e8             	pushl  -0x18(%ebp)
  800be0:	8d 45 14             	lea    0x14(%ebp),%eax
  800be3:	50                   	push   %eax
  800be4:	e8 e7 fb ff ff       	call   8007d0 <getuint>
  800be9:	83 c4 10             	add    $0x10,%esp
  800bec:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800bef:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800bf2:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800bf9:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800bfd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800c00:	83 ec 04             	sub    $0x4,%esp
  800c03:	52                   	push   %edx
  800c04:	ff 75 e4             	pushl  -0x1c(%ebp)
  800c07:	50                   	push   %eax
  800c08:	ff 75 f4             	pushl  -0xc(%ebp)
  800c0b:	ff 75 f0             	pushl  -0x10(%ebp)
  800c0e:	ff 75 0c             	pushl  0xc(%ebp)
  800c11:	ff 75 08             	pushl  0x8(%ebp)
  800c14:	e8 00 fb ff ff       	call   800719 <printnum>
  800c19:	83 c4 20             	add    $0x20,%esp
			break;
  800c1c:	eb 46                	jmp    800c64 <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800c1e:	83 ec 08             	sub    $0x8,%esp
  800c21:	ff 75 0c             	pushl  0xc(%ebp)
  800c24:	53                   	push   %ebx
  800c25:	8b 45 08             	mov    0x8(%ebp),%eax
  800c28:	ff d0                	call   *%eax
  800c2a:	83 c4 10             	add    $0x10,%esp
			break;
  800c2d:	eb 35                	jmp    800c64 <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  800c2f:	c6 05 44 40 80 00 00 	movb   $0x0,0x804044
			break;
  800c36:	eb 2c                	jmp    800c64 <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  800c38:	c6 05 44 40 80 00 01 	movb   $0x1,0x804044
			break;
  800c3f:	eb 23                	jmp    800c64 <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800c41:	83 ec 08             	sub    $0x8,%esp
  800c44:	ff 75 0c             	pushl  0xc(%ebp)
  800c47:	6a 25                	push   $0x25
  800c49:	8b 45 08             	mov    0x8(%ebp),%eax
  800c4c:	ff d0                	call   *%eax
  800c4e:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800c51:	ff 4d 10             	decl   0x10(%ebp)
  800c54:	eb 03                	jmp    800c59 <vprintfmt+0x3c3>
  800c56:	ff 4d 10             	decl   0x10(%ebp)
  800c59:	8b 45 10             	mov    0x10(%ebp),%eax
  800c5c:	48                   	dec    %eax
  800c5d:	8a 00                	mov    (%eax),%al
  800c5f:	3c 25                	cmp    $0x25,%al
  800c61:	75 f3                	jne    800c56 <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  800c63:	90                   	nop
		}
	}
  800c64:	e9 35 fc ff ff       	jmp    80089e <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800c69:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800c6a:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800c6d:	5b                   	pop    %ebx
  800c6e:	5e                   	pop    %esi
  800c6f:	5d                   	pop    %ebp
  800c70:	c3                   	ret    

00800c71 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800c71:	55                   	push   %ebp
  800c72:	89 e5                	mov    %esp,%ebp
  800c74:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800c77:	8d 45 10             	lea    0x10(%ebp),%eax
  800c7a:	83 c0 04             	add    $0x4,%eax
  800c7d:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800c80:	8b 45 10             	mov    0x10(%ebp),%eax
  800c83:	ff 75 f4             	pushl  -0xc(%ebp)
  800c86:	50                   	push   %eax
  800c87:	ff 75 0c             	pushl  0xc(%ebp)
  800c8a:	ff 75 08             	pushl  0x8(%ebp)
  800c8d:	e8 04 fc ff ff       	call   800896 <vprintfmt>
  800c92:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800c95:	90                   	nop
  800c96:	c9                   	leave  
  800c97:	c3                   	ret    

00800c98 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800c98:	55                   	push   %ebp
  800c99:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800c9b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c9e:	8b 40 08             	mov    0x8(%eax),%eax
  800ca1:	8d 50 01             	lea    0x1(%eax),%edx
  800ca4:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ca7:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800caa:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cad:	8b 10                	mov    (%eax),%edx
  800caf:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cb2:	8b 40 04             	mov    0x4(%eax),%eax
  800cb5:	39 c2                	cmp    %eax,%edx
  800cb7:	73 12                	jae    800ccb <sprintputch+0x33>
		*b->buf++ = ch;
  800cb9:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cbc:	8b 00                	mov    (%eax),%eax
  800cbe:	8d 48 01             	lea    0x1(%eax),%ecx
  800cc1:	8b 55 0c             	mov    0xc(%ebp),%edx
  800cc4:	89 0a                	mov    %ecx,(%edx)
  800cc6:	8b 55 08             	mov    0x8(%ebp),%edx
  800cc9:	88 10                	mov    %dl,(%eax)
}
  800ccb:	90                   	nop
  800ccc:	5d                   	pop    %ebp
  800ccd:	c3                   	ret    

00800cce <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800cce:	55                   	push   %ebp
  800ccf:	89 e5                	mov    %esp,%ebp
  800cd1:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800cd4:	8b 45 08             	mov    0x8(%ebp),%eax
  800cd7:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800cda:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cdd:	8d 50 ff             	lea    -0x1(%eax),%edx
  800ce0:	8b 45 08             	mov    0x8(%ebp),%eax
  800ce3:	01 d0                	add    %edx,%eax
  800ce5:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800ce8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800cef:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800cf3:	74 06                	je     800cfb <vsnprintf+0x2d>
  800cf5:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800cf9:	7f 07                	jg     800d02 <vsnprintf+0x34>
		return -E_INVAL;
  800cfb:	b8 03 00 00 00       	mov    $0x3,%eax
  800d00:	eb 20                	jmp    800d22 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800d02:	ff 75 14             	pushl  0x14(%ebp)
  800d05:	ff 75 10             	pushl  0x10(%ebp)
  800d08:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800d0b:	50                   	push   %eax
  800d0c:	68 98 0c 80 00       	push   $0x800c98
  800d11:	e8 80 fb ff ff       	call   800896 <vprintfmt>
  800d16:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800d19:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800d1c:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800d1f:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800d22:	c9                   	leave  
  800d23:	c3                   	ret    

00800d24 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800d24:	55                   	push   %ebp
  800d25:	89 e5                	mov    %esp,%ebp
  800d27:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800d2a:	8d 45 10             	lea    0x10(%ebp),%eax
  800d2d:	83 c0 04             	add    $0x4,%eax
  800d30:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800d33:	8b 45 10             	mov    0x10(%ebp),%eax
  800d36:	ff 75 f4             	pushl  -0xc(%ebp)
  800d39:	50                   	push   %eax
  800d3a:	ff 75 0c             	pushl  0xc(%ebp)
  800d3d:	ff 75 08             	pushl  0x8(%ebp)
  800d40:	e8 89 ff ff ff       	call   800cce <vsnprintf>
  800d45:	83 c4 10             	add    $0x10,%esp
  800d48:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800d4b:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800d4e:	c9                   	leave  
  800d4f:	c3                   	ret    

00800d50 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800d50:	55                   	push   %ebp
  800d51:	89 e5                	mov    %esp,%ebp
  800d53:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800d56:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800d5d:	eb 06                	jmp    800d65 <strlen+0x15>
		n++;
  800d5f:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800d62:	ff 45 08             	incl   0x8(%ebp)
  800d65:	8b 45 08             	mov    0x8(%ebp),%eax
  800d68:	8a 00                	mov    (%eax),%al
  800d6a:	84 c0                	test   %al,%al
  800d6c:	75 f1                	jne    800d5f <strlen+0xf>
		n++;
	return n;
  800d6e:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800d71:	c9                   	leave  
  800d72:	c3                   	ret    

00800d73 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800d73:	55                   	push   %ebp
  800d74:	89 e5                	mov    %esp,%ebp
  800d76:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800d79:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800d80:	eb 09                	jmp    800d8b <strnlen+0x18>
		n++;
  800d82:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800d85:	ff 45 08             	incl   0x8(%ebp)
  800d88:	ff 4d 0c             	decl   0xc(%ebp)
  800d8b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800d8f:	74 09                	je     800d9a <strnlen+0x27>
  800d91:	8b 45 08             	mov    0x8(%ebp),%eax
  800d94:	8a 00                	mov    (%eax),%al
  800d96:	84 c0                	test   %al,%al
  800d98:	75 e8                	jne    800d82 <strnlen+0xf>
		n++;
	return n;
  800d9a:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800d9d:	c9                   	leave  
  800d9e:	c3                   	ret    

00800d9f <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800d9f:	55                   	push   %ebp
  800da0:	89 e5                	mov    %esp,%ebp
  800da2:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800da5:	8b 45 08             	mov    0x8(%ebp),%eax
  800da8:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800dab:	90                   	nop
  800dac:	8b 45 08             	mov    0x8(%ebp),%eax
  800daf:	8d 50 01             	lea    0x1(%eax),%edx
  800db2:	89 55 08             	mov    %edx,0x8(%ebp)
  800db5:	8b 55 0c             	mov    0xc(%ebp),%edx
  800db8:	8d 4a 01             	lea    0x1(%edx),%ecx
  800dbb:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800dbe:	8a 12                	mov    (%edx),%dl
  800dc0:	88 10                	mov    %dl,(%eax)
  800dc2:	8a 00                	mov    (%eax),%al
  800dc4:	84 c0                	test   %al,%al
  800dc6:	75 e4                	jne    800dac <strcpy+0xd>
		/* do nothing */;
	return ret;
  800dc8:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800dcb:	c9                   	leave  
  800dcc:	c3                   	ret    

00800dcd <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800dcd:	55                   	push   %ebp
  800dce:	89 e5                	mov    %esp,%ebp
  800dd0:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800dd3:	8b 45 08             	mov    0x8(%ebp),%eax
  800dd6:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800dd9:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800de0:	eb 1f                	jmp    800e01 <strncpy+0x34>
		*dst++ = *src;
  800de2:	8b 45 08             	mov    0x8(%ebp),%eax
  800de5:	8d 50 01             	lea    0x1(%eax),%edx
  800de8:	89 55 08             	mov    %edx,0x8(%ebp)
  800deb:	8b 55 0c             	mov    0xc(%ebp),%edx
  800dee:	8a 12                	mov    (%edx),%dl
  800df0:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800df2:	8b 45 0c             	mov    0xc(%ebp),%eax
  800df5:	8a 00                	mov    (%eax),%al
  800df7:	84 c0                	test   %al,%al
  800df9:	74 03                	je     800dfe <strncpy+0x31>
			src++;
  800dfb:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800dfe:	ff 45 fc             	incl   -0x4(%ebp)
  800e01:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e04:	3b 45 10             	cmp    0x10(%ebp),%eax
  800e07:	72 d9                	jb     800de2 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800e09:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800e0c:	c9                   	leave  
  800e0d:	c3                   	ret    

00800e0e <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800e0e:	55                   	push   %ebp
  800e0f:	89 e5                	mov    %esp,%ebp
  800e11:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800e14:	8b 45 08             	mov    0x8(%ebp),%eax
  800e17:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800e1a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e1e:	74 30                	je     800e50 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800e20:	eb 16                	jmp    800e38 <strlcpy+0x2a>
			*dst++ = *src++;
  800e22:	8b 45 08             	mov    0x8(%ebp),%eax
  800e25:	8d 50 01             	lea    0x1(%eax),%edx
  800e28:	89 55 08             	mov    %edx,0x8(%ebp)
  800e2b:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e2e:	8d 4a 01             	lea    0x1(%edx),%ecx
  800e31:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800e34:	8a 12                	mov    (%edx),%dl
  800e36:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800e38:	ff 4d 10             	decl   0x10(%ebp)
  800e3b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e3f:	74 09                	je     800e4a <strlcpy+0x3c>
  800e41:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e44:	8a 00                	mov    (%eax),%al
  800e46:	84 c0                	test   %al,%al
  800e48:	75 d8                	jne    800e22 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800e4a:	8b 45 08             	mov    0x8(%ebp),%eax
  800e4d:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800e50:	8b 55 08             	mov    0x8(%ebp),%edx
  800e53:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e56:	29 c2                	sub    %eax,%edx
  800e58:	89 d0                	mov    %edx,%eax
}
  800e5a:	c9                   	leave  
  800e5b:	c3                   	ret    

00800e5c <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800e5c:	55                   	push   %ebp
  800e5d:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800e5f:	eb 06                	jmp    800e67 <strcmp+0xb>
		p++, q++;
  800e61:	ff 45 08             	incl   0x8(%ebp)
  800e64:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800e67:	8b 45 08             	mov    0x8(%ebp),%eax
  800e6a:	8a 00                	mov    (%eax),%al
  800e6c:	84 c0                	test   %al,%al
  800e6e:	74 0e                	je     800e7e <strcmp+0x22>
  800e70:	8b 45 08             	mov    0x8(%ebp),%eax
  800e73:	8a 10                	mov    (%eax),%dl
  800e75:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e78:	8a 00                	mov    (%eax),%al
  800e7a:	38 c2                	cmp    %al,%dl
  800e7c:	74 e3                	je     800e61 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800e7e:	8b 45 08             	mov    0x8(%ebp),%eax
  800e81:	8a 00                	mov    (%eax),%al
  800e83:	0f b6 d0             	movzbl %al,%edx
  800e86:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e89:	8a 00                	mov    (%eax),%al
  800e8b:	0f b6 c0             	movzbl %al,%eax
  800e8e:	29 c2                	sub    %eax,%edx
  800e90:	89 d0                	mov    %edx,%eax
}
  800e92:	5d                   	pop    %ebp
  800e93:	c3                   	ret    

00800e94 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800e94:	55                   	push   %ebp
  800e95:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800e97:	eb 09                	jmp    800ea2 <strncmp+0xe>
		n--, p++, q++;
  800e99:	ff 4d 10             	decl   0x10(%ebp)
  800e9c:	ff 45 08             	incl   0x8(%ebp)
  800e9f:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800ea2:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ea6:	74 17                	je     800ebf <strncmp+0x2b>
  800ea8:	8b 45 08             	mov    0x8(%ebp),%eax
  800eab:	8a 00                	mov    (%eax),%al
  800ead:	84 c0                	test   %al,%al
  800eaf:	74 0e                	je     800ebf <strncmp+0x2b>
  800eb1:	8b 45 08             	mov    0x8(%ebp),%eax
  800eb4:	8a 10                	mov    (%eax),%dl
  800eb6:	8b 45 0c             	mov    0xc(%ebp),%eax
  800eb9:	8a 00                	mov    (%eax),%al
  800ebb:	38 c2                	cmp    %al,%dl
  800ebd:	74 da                	je     800e99 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800ebf:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ec3:	75 07                	jne    800ecc <strncmp+0x38>
		return 0;
  800ec5:	b8 00 00 00 00       	mov    $0x0,%eax
  800eca:	eb 14                	jmp    800ee0 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800ecc:	8b 45 08             	mov    0x8(%ebp),%eax
  800ecf:	8a 00                	mov    (%eax),%al
  800ed1:	0f b6 d0             	movzbl %al,%edx
  800ed4:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ed7:	8a 00                	mov    (%eax),%al
  800ed9:	0f b6 c0             	movzbl %al,%eax
  800edc:	29 c2                	sub    %eax,%edx
  800ede:	89 d0                	mov    %edx,%eax
}
  800ee0:	5d                   	pop    %ebp
  800ee1:	c3                   	ret    

00800ee2 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800ee2:	55                   	push   %ebp
  800ee3:	89 e5                	mov    %esp,%ebp
  800ee5:	83 ec 04             	sub    $0x4,%esp
  800ee8:	8b 45 0c             	mov    0xc(%ebp),%eax
  800eeb:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800eee:	eb 12                	jmp    800f02 <strchr+0x20>
		if (*s == c)
  800ef0:	8b 45 08             	mov    0x8(%ebp),%eax
  800ef3:	8a 00                	mov    (%eax),%al
  800ef5:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800ef8:	75 05                	jne    800eff <strchr+0x1d>
			return (char *) s;
  800efa:	8b 45 08             	mov    0x8(%ebp),%eax
  800efd:	eb 11                	jmp    800f10 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800eff:	ff 45 08             	incl   0x8(%ebp)
  800f02:	8b 45 08             	mov    0x8(%ebp),%eax
  800f05:	8a 00                	mov    (%eax),%al
  800f07:	84 c0                	test   %al,%al
  800f09:	75 e5                	jne    800ef0 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800f0b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800f10:	c9                   	leave  
  800f11:	c3                   	ret    

00800f12 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800f12:	55                   	push   %ebp
  800f13:	89 e5                	mov    %esp,%ebp
  800f15:	83 ec 04             	sub    $0x4,%esp
  800f18:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f1b:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800f1e:	eb 0d                	jmp    800f2d <strfind+0x1b>
		if (*s == c)
  800f20:	8b 45 08             	mov    0x8(%ebp),%eax
  800f23:	8a 00                	mov    (%eax),%al
  800f25:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800f28:	74 0e                	je     800f38 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800f2a:	ff 45 08             	incl   0x8(%ebp)
  800f2d:	8b 45 08             	mov    0x8(%ebp),%eax
  800f30:	8a 00                	mov    (%eax),%al
  800f32:	84 c0                	test   %al,%al
  800f34:	75 ea                	jne    800f20 <strfind+0xe>
  800f36:	eb 01                	jmp    800f39 <strfind+0x27>
		if (*s == c)
			break;
  800f38:	90                   	nop
	return (char *) s;
  800f39:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f3c:	c9                   	leave  
  800f3d:	c3                   	ret    

00800f3e <memset>:

// *************** The faster implementation of memset & memcpy is implemented by *************
// ****************** Team80 (Yahia Khaled, Malek Ahmed et al) - FCIS'24-25 *******************
void *
memset(void *v, int c, uint32 n)
{
  800f3e:	55                   	push   %ebp
  800f3f:	89 e5                	mov    %esp,%ebp
  800f41:	83 ec 10             	sub    $0x10,%esp
//	m = n;
//	while (--m >= 0)
//		*p++ = c;

	/*Faster Implementation*/
	uint64* p64 = (uint64*)v;
  800f44:	8b 45 08             	mov    0x8(%ebp),%eax
  800f47:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if(n >= 8){
  800f4a:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800f4e:	76 63                	jbe    800fb3 <memset+0x75>
		uint64 data_block = c;
  800f50:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f53:	99                   	cltd   
  800f54:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800f57:	89 55 f4             	mov    %edx,-0xc(%ebp)
		data_block |= data_block << 8;
  800f5a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800f5d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800f60:	0f a4 c2 08          	shld   $0x8,%eax,%edx
  800f64:	c1 e0 08             	shl    $0x8,%eax
  800f67:	09 45 f0             	or     %eax,-0x10(%ebp)
  800f6a:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 16;
  800f6d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800f70:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800f73:	0f a4 c2 10          	shld   $0x10,%eax,%edx
  800f77:	c1 e0 10             	shl    $0x10,%eax
  800f7a:	09 45 f0             	or     %eax,-0x10(%ebp)
  800f7d:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 32;
  800f80:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800f83:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800f86:	89 c2                	mov    %eax,%edx
  800f88:	b8 00 00 00 00       	mov    $0x0,%eax
  800f8d:	09 45 f0             	or     %eax,-0x10(%ebp)
  800f90:	09 55 f4             	or     %edx,-0xc(%ebp)

		while(n >= 8)
  800f93:	eb 18                	jmp    800fad <memset+0x6f>
			*p64++ = data_block, n -= 8;
  800f95:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  800f98:	8d 41 08             	lea    0x8(%ecx),%eax
  800f9b:	89 45 fc             	mov    %eax,-0x4(%ebp)
  800f9e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800fa1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800fa4:	89 01                	mov    %eax,(%ecx)
  800fa6:	89 51 04             	mov    %edx,0x4(%ecx)
  800fa9:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
		uint64 data_block = c;
		data_block |= data_block << 8;
		data_block |= data_block << 16;
		data_block |= data_block << 32;

		while(n >= 8)
  800fad:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800fb1:	77 e2                	ja     800f95 <memset+0x57>
			*p64++ = data_block, n -= 8;
	}

	if(n){
  800fb3:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800fb7:	74 23                	je     800fdc <memset+0x9e>
		uint8* p8 = (uint8*)p64;
  800fb9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800fbc:	89 45 f8             	mov    %eax,-0x8(%ebp)
		while (n-- > 0)
  800fbf:	eb 0e                	jmp    800fcf <memset+0x91>
			*p8++ = (uint8)c;
  800fc1:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800fc4:	8d 50 01             	lea    0x1(%eax),%edx
  800fc7:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800fca:	8b 55 0c             	mov    0xc(%ebp),%edx
  800fcd:	88 10                	mov    %dl,(%eax)
			*p64++ = data_block, n -= 8;
	}

	if(n){
		uint8* p8 = (uint8*)p64;
		while (n-- > 0)
  800fcf:	8b 45 10             	mov    0x10(%ebp),%eax
  800fd2:	8d 50 ff             	lea    -0x1(%eax),%edx
  800fd5:	89 55 10             	mov    %edx,0x10(%ebp)
  800fd8:	85 c0                	test   %eax,%eax
  800fda:	75 e5                	jne    800fc1 <memset+0x83>
			*p8++ = (uint8)c;
	}

	return v;
  800fdc:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800fdf:	c9                   	leave  
  800fe0:	c3                   	ret    

00800fe1 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800fe1:	55                   	push   %ebp
  800fe2:	89 e5                	mov    %esp,%ebp
  800fe4:	83 ec 10             	sub    $0x10,%esp
	//	s = src;
	//	d = dst;
	//	while (n-- > 0)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
  800fe7:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fea:	89 45 fc             	mov    %eax,-0x4(%ebp)
	uint64* d64 = (uint64*)dst;
  800fed:	8b 45 08             	mov    0x8(%ebp),%eax
  800ff0:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if(n >= 8){
  800ff3:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800ff7:	76 24                	jbe    80101d <memcpy+0x3c>
		while(n >= 8){
  800ff9:	eb 1c                	jmp    801017 <memcpy+0x36>
			*d64 = *s64;
  800ffb:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ffe:	8b 50 04             	mov    0x4(%eax),%edx
  801001:	8b 00                	mov    (%eax),%eax
  801003:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801006:	89 01                	mov    %eax,(%ecx)
  801008:	89 51 04             	mov    %edx,0x4(%ecx)
			n -= 8;
  80100b:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
			++s64;
  80100f:	83 45 fc 08          	addl   $0x8,-0x4(%ebp)
			++d64;
  801013:	83 45 f8 08          	addl   $0x8,-0x8(%ebp)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
	uint64* d64 = (uint64*)dst;
	if(n >= 8){
		while(n >= 8){
  801017:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  80101b:	77 de                	ja     800ffb <memcpy+0x1a>
			++s64;
			++d64;
		}
	}

	if(n){
  80101d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801021:	74 31                	je     801054 <memcpy+0x73>
		uint8* s8 = (uint8*)s64;
  801023:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801026:	89 45 f4             	mov    %eax,-0xc(%ebp)
		uint8* d8 = (uint8*)d64;
  801029:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80102c:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (n-- > 0)
  80102f:	eb 16                	jmp    801047 <memcpy+0x66>
			*d8++ = *s8++;
  801031:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801034:	8d 50 01             	lea    0x1(%eax),%edx
  801037:	89 55 f0             	mov    %edx,-0x10(%ebp)
  80103a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80103d:	8d 4a 01             	lea    0x1(%edx),%ecx
  801040:	89 4d f4             	mov    %ecx,-0xc(%ebp)
  801043:	8a 12                	mov    (%edx),%dl
  801045:	88 10                	mov    %dl,(%eax)
	}

	if(n){
		uint8* s8 = (uint8*)s64;
		uint8* d8 = (uint8*)d64;
		while (n-- > 0)
  801047:	8b 45 10             	mov    0x10(%ebp),%eax
  80104a:	8d 50 ff             	lea    -0x1(%eax),%edx
  80104d:	89 55 10             	mov    %edx,0x10(%ebp)
  801050:	85 c0                	test   %eax,%eax
  801052:	75 dd                	jne    801031 <memcpy+0x50>
			*d8++ = *s8++;
	}
	return dst;
  801054:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801057:	c9                   	leave  
  801058:	c3                   	ret    

00801059 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  801059:	55                   	push   %ebp
  80105a:	89 e5                	mov    %esp,%ebp
  80105c:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  80105f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801062:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801065:	8b 45 08             	mov    0x8(%ebp),%eax
  801068:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  80106b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80106e:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801071:	73 50                	jae    8010c3 <memmove+0x6a>
  801073:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801076:	8b 45 10             	mov    0x10(%ebp),%eax
  801079:	01 d0                	add    %edx,%eax
  80107b:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  80107e:	76 43                	jbe    8010c3 <memmove+0x6a>
		s += n;
  801080:	8b 45 10             	mov    0x10(%ebp),%eax
  801083:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  801086:	8b 45 10             	mov    0x10(%ebp),%eax
  801089:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  80108c:	eb 10                	jmp    80109e <memmove+0x45>
			*--d = *--s;
  80108e:	ff 4d f8             	decl   -0x8(%ebp)
  801091:	ff 4d fc             	decl   -0x4(%ebp)
  801094:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801097:	8a 10                	mov    (%eax),%dl
  801099:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80109c:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  80109e:	8b 45 10             	mov    0x10(%ebp),%eax
  8010a1:	8d 50 ff             	lea    -0x1(%eax),%edx
  8010a4:	89 55 10             	mov    %edx,0x10(%ebp)
  8010a7:	85 c0                	test   %eax,%eax
  8010a9:	75 e3                	jne    80108e <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  8010ab:	eb 23                	jmp    8010d0 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  8010ad:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010b0:	8d 50 01             	lea    0x1(%eax),%edx
  8010b3:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8010b6:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8010b9:	8d 4a 01             	lea    0x1(%edx),%ecx
  8010bc:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  8010bf:	8a 12                	mov    (%edx),%dl
  8010c1:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  8010c3:	8b 45 10             	mov    0x10(%ebp),%eax
  8010c6:	8d 50 ff             	lea    -0x1(%eax),%edx
  8010c9:	89 55 10             	mov    %edx,0x10(%ebp)
  8010cc:	85 c0                	test   %eax,%eax
  8010ce:	75 dd                	jne    8010ad <memmove+0x54>
			*d++ = *s++;

	return dst;
  8010d0:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8010d3:	c9                   	leave  
  8010d4:	c3                   	ret    

008010d5 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  8010d5:	55                   	push   %ebp
  8010d6:	89 e5                	mov    %esp,%ebp
  8010d8:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  8010db:	8b 45 08             	mov    0x8(%ebp),%eax
  8010de:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  8010e1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010e4:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  8010e7:	eb 2a                	jmp    801113 <memcmp+0x3e>
		if (*s1 != *s2)
  8010e9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8010ec:	8a 10                	mov    (%eax),%dl
  8010ee:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010f1:	8a 00                	mov    (%eax),%al
  8010f3:	38 c2                	cmp    %al,%dl
  8010f5:	74 16                	je     80110d <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  8010f7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8010fa:	8a 00                	mov    (%eax),%al
  8010fc:	0f b6 d0             	movzbl %al,%edx
  8010ff:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801102:	8a 00                	mov    (%eax),%al
  801104:	0f b6 c0             	movzbl %al,%eax
  801107:	29 c2                	sub    %eax,%edx
  801109:	89 d0                	mov    %edx,%eax
  80110b:	eb 18                	jmp    801125 <memcmp+0x50>
		s1++, s2++;
  80110d:	ff 45 fc             	incl   -0x4(%ebp)
  801110:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  801113:	8b 45 10             	mov    0x10(%ebp),%eax
  801116:	8d 50 ff             	lea    -0x1(%eax),%edx
  801119:	89 55 10             	mov    %edx,0x10(%ebp)
  80111c:	85 c0                	test   %eax,%eax
  80111e:	75 c9                	jne    8010e9 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801120:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801125:	c9                   	leave  
  801126:	c3                   	ret    

00801127 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  801127:	55                   	push   %ebp
  801128:	89 e5                	mov    %esp,%ebp
  80112a:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  80112d:	8b 55 08             	mov    0x8(%ebp),%edx
  801130:	8b 45 10             	mov    0x10(%ebp),%eax
  801133:	01 d0                	add    %edx,%eax
  801135:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  801138:	eb 15                	jmp    80114f <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  80113a:	8b 45 08             	mov    0x8(%ebp),%eax
  80113d:	8a 00                	mov    (%eax),%al
  80113f:	0f b6 d0             	movzbl %al,%edx
  801142:	8b 45 0c             	mov    0xc(%ebp),%eax
  801145:	0f b6 c0             	movzbl %al,%eax
  801148:	39 c2                	cmp    %eax,%edx
  80114a:	74 0d                	je     801159 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  80114c:	ff 45 08             	incl   0x8(%ebp)
  80114f:	8b 45 08             	mov    0x8(%ebp),%eax
  801152:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801155:	72 e3                	jb     80113a <memfind+0x13>
  801157:	eb 01                	jmp    80115a <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  801159:	90                   	nop
	return (void *) s;
  80115a:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80115d:	c9                   	leave  
  80115e:	c3                   	ret    

0080115f <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  80115f:	55                   	push   %ebp
  801160:	89 e5                	mov    %esp,%ebp
  801162:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  801165:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  80116c:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801173:	eb 03                	jmp    801178 <strtol+0x19>
		s++;
  801175:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801178:	8b 45 08             	mov    0x8(%ebp),%eax
  80117b:	8a 00                	mov    (%eax),%al
  80117d:	3c 20                	cmp    $0x20,%al
  80117f:	74 f4                	je     801175 <strtol+0x16>
  801181:	8b 45 08             	mov    0x8(%ebp),%eax
  801184:	8a 00                	mov    (%eax),%al
  801186:	3c 09                	cmp    $0x9,%al
  801188:	74 eb                	je     801175 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  80118a:	8b 45 08             	mov    0x8(%ebp),%eax
  80118d:	8a 00                	mov    (%eax),%al
  80118f:	3c 2b                	cmp    $0x2b,%al
  801191:	75 05                	jne    801198 <strtol+0x39>
		s++;
  801193:	ff 45 08             	incl   0x8(%ebp)
  801196:	eb 13                	jmp    8011ab <strtol+0x4c>
	else if (*s == '-')
  801198:	8b 45 08             	mov    0x8(%ebp),%eax
  80119b:	8a 00                	mov    (%eax),%al
  80119d:	3c 2d                	cmp    $0x2d,%al
  80119f:	75 0a                	jne    8011ab <strtol+0x4c>
		s++, neg = 1;
  8011a1:	ff 45 08             	incl   0x8(%ebp)
  8011a4:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8011ab:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8011af:	74 06                	je     8011b7 <strtol+0x58>
  8011b1:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  8011b5:	75 20                	jne    8011d7 <strtol+0x78>
  8011b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8011ba:	8a 00                	mov    (%eax),%al
  8011bc:	3c 30                	cmp    $0x30,%al
  8011be:	75 17                	jne    8011d7 <strtol+0x78>
  8011c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8011c3:	40                   	inc    %eax
  8011c4:	8a 00                	mov    (%eax),%al
  8011c6:	3c 78                	cmp    $0x78,%al
  8011c8:	75 0d                	jne    8011d7 <strtol+0x78>
		s += 2, base = 16;
  8011ca:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  8011ce:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  8011d5:	eb 28                	jmp    8011ff <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  8011d7:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8011db:	75 15                	jne    8011f2 <strtol+0x93>
  8011dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8011e0:	8a 00                	mov    (%eax),%al
  8011e2:	3c 30                	cmp    $0x30,%al
  8011e4:	75 0c                	jne    8011f2 <strtol+0x93>
		s++, base = 8;
  8011e6:	ff 45 08             	incl   0x8(%ebp)
  8011e9:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  8011f0:	eb 0d                	jmp    8011ff <strtol+0xa0>
	else if (base == 0)
  8011f2:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8011f6:	75 07                	jne    8011ff <strtol+0xa0>
		base = 10;
  8011f8:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8011ff:	8b 45 08             	mov    0x8(%ebp),%eax
  801202:	8a 00                	mov    (%eax),%al
  801204:	3c 2f                	cmp    $0x2f,%al
  801206:	7e 19                	jle    801221 <strtol+0xc2>
  801208:	8b 45 08             	mov    0x8(%ebp),%eax
  80120b:	8a 00                	mov    (%eax),%al
  80120d:	3c 39                	cmp    $0x39,%al
  80120f:	7f 10                	jg     801221 <strtol+0xc2>
			dig = *s - '0';
  801211:	8b 45 08             	mov    0x8(%ebp),%eax
  801214:	8a 00                	mov    (%eax),%al
  801216:	0f be c0             	movsbl %al,%eax
  801219:	83 e8 30             	sub    $0x30,%eax
  80121c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80121f:	eb 42                	jmp    801263 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  801221:	8b 45 08             	mov    0x8(%ebp),%eax
  801224:	8a 00                	mov    (%eax),%al
  801226:	3c 60                	cmp    $0x60,%al
  801228:	7e 19                	jle    801243 <strtol+0xe4>
  80122a:	8b 45 08             	mov    0x8(%ebp),%eax
  80122d:	8a 00                	mov    (%eax),%al
  80122f:	3c 7a                	cmp    $0x7a,%al
  801231:	7f 10                	jg     801243 <strtol+0xe4>
			dig = *s - 'a' + 10;
  801233:	8b 45 08             	mov    0x8(%ebp),%eax
  801236:	8a 00                	mov    (%eax),%al
  801238:	0f be c0             	movsbl %al,%eax
  80123b:	83 e8 57             	sub    $0x57,%eax
  80123e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801241:	eb 20                	jmp    801263 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  801243:	8b 45 08             	mov    0x8(%ebp),%eax
  801246:	8a 00                	mov    (%eax),%al
  801248:	3c 40                	cmp    $0x40,%al
  80124a:	7e 39                	jle    801285 <strtol+0x126>
  80124c:	8b 45 08             	mov    0x8(%ebp),%eax
  80124f:	8a 00                	mov    (%eax),%al
  801251:	3c 5a                	cmp    $0x5a,%al
  801253:	7f 30                	jg     801285 <strtol+0x126>
			dig = *s - 'A' + 10;
  801255:	8b 45 08             	mov    0x8(%ebp),%eax
  801258:	8a 00                	mov    (%eax),%al
  80125a:	0f be c0             	movsbl %al,%eax
  80125d:	83 e8 37             	sub    $0x37,%eax
  801260:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  801263:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801266:	3b 45 10             	cmp    0x10(%ebp),%eax
  801269:	7d 19                	jge    801284 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  80126b:	ff 45 08             	incl   0x8(%ebp)
  80126e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801271:	0f af 45 10          	imul   0x10(%ebp),%eax
  801275:	89 c2                	mov    %eax,%edx
  801277:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80127a:	01 d0                	add    %edx,%eax
  80127c:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  80127f:	e9 7b ff ff ff       	jmp    8011ff <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801284:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801285:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801289:	74 08                	je     801293 <strtol+0x134>
		*endptr = (char *) s;
  80128b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80128e:	8b 55 08             	mov    0x8(%ebp),%edx
  801291:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  801293:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801297:	74 07                	je     8012a0 <strtol+0x141>
  801299:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80129c:	f7 d8                	neg    %eax
  80129e:	eb 03                	jmp    8012a3 <strtol+0x144>
  8012a0:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8012a3:	c9                   	leave  
  8012a4:	c3                   	ret    

008012a5 <ltostr>:

void
ltostr(long value, char *str)
{
  8012a5:	55                   	push   %ebp
  8012a6:	89 e5                	mov    %esp,%ebp
  8012a8:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  8012ab:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  8012b2:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  8012b9:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8012bd:	79 13                	jns    8012d2 <ltostr+0x2d>
	{
		neg = 1;
  8012bf:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  8012c6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012c9:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  8012cc:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  8012cf:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  8012d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8012d5:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8012da:	99                   	cltd   
  8012db:	f7 f9                	idiv   %ecx
  8012dd:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  8012e0:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8012e3:	8d 50 01             	lea    0x1(%eax),%edx
  8012e6:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8012e9:	89 c2                	mov    %eax,%edx
  8012eb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012ee:	01 d0                	add    %edx,%eax
  8012f0:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8012f3:	83 c2 30             	add    $0x30,%edx
  8012f6:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  8012f8:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8012fb:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801300:	f7 e9                	imul   %ecx
  801302:	c1 fa 02             	sar    $0x2,%edx
  801305:	89 c8                	mov    %ecx,%eax
  801307:	c1 f8 1f             	sar    $0x1f,%eax
  80130a:	29 c2                	sub    %eax,%edx
  80130c:	89 d0                	mov    %edx,%eax
  80130e:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  801311:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801315:	75 bb                	jne    8012d2 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801317:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  80131e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801321:	48                   	dec    %eax
  801322:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801325:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801329:	74 3d                	je     801368 <ltostr+0xc3>
		start = 1 ;
  80132b:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  801332:	eb 34                	jmp    801368 <ltostr+0xc3>
	{
		char tmp = str[start] ;
  801334:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801337:	8b 45 0c             	mov    0xc(%ebp),%eax
  80133a:	01 d0                	add    %edx,%eax
  80133c:	8a 00                	mov    (%eax),%al
  80133e:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801341:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801344:	8b 45 0c             	mov    0xc(%ebp),%eax
  801347:	01 c2                	add    %eax,%edx
  801349:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  80134c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80134f:	01 c8                	add    %ecx,%eax
  801351:	8a 00                	mov    (%eax),%al
  801353:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801355:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801358:	8b 45 0c             	mov    0xc(%ebp),%eax
  80135b:	01 c2                	add    %eax,%edx
  80135d:	8a 45 eb             	mov    -0x15(%ebp),%al
  801360:	88 02                	mov    %al,(%edx)
		start++ ;
  801362:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801365:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801368:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80136b:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80136e:	7c c4                	jl     801334 <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801370:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801373:	8b 45 0c             	mov    0xc(%ebp),%eax
  801376:	01 d0                	add    %edx,%eax
  801378:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  80137b:	90                   	nop
  80137c:	c9                   	leave  
  80137d:	c3                   	ret    

0080137e <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  80137e:	55                   	push   %ebp
  80137f:	89 e5                	mov    %esp,%ebp
  801381:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801384:	ff 75 08             	pushl  0x8(%ebp)
  801387:	e8 c4 f9 ff ff       	call   800d50 <strlen>
  80138c:	83 c4 04             	add    $0x4,%esp
  80138f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  801392:	ff 75 0c             	pushl  0xc(%ebp)
  801395:	e8 b6 f9 ff ff       	call   800d50 <strlen>
  80139a:	83 c4 04             	add    $0x4,%esp
  80139d:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  8013a0:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  8013a7:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8013ae:	eb 17                	jmp    8013c7 <strcconcat+0x49>
		final[s] = str1[s] ;
  8013b0:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8013b3:	8b 45 10             	mov    0x10(%ebp),%eax
  8013b6:	01 c2                	add    %eax,%edx
  8013b8:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8013bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8013be:	01 c8                	add    %ecx,%eax
  8013c0:	8a 00                	mov    (%eax),%al
  8013c2:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  8013c4:	ff 45 fc             	incl   -0x4(%ebp)
  8013c7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8013ca:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8013cd:	7c e1                	jl     8013b0 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  8013cf:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  8013d6:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8013dd:	eb 1f                	jmp    8013fe <strcconcat+0x80>
		final[s++] = str2[i] ;
  8013df:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8013e2:	8d 50 01             	lea    0x1(%eax),%edx
  8013e5:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8013e8:	89 c2                	mov    %eax,%edx
  8013ea:	8b 45 10             	mov    0x10(%ebp),%eax
  8013ed:	01 c2                	add    %eax,%edx
  8013ef:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8013f2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013f5:	01 c8                	add    %ecx,%eax
  8013f7:	8a 00                	mov    (%eax),%al
  8013f9:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  8013fb:	ff 45 f8             	incl   -0x8(%ebp)
  8013fe:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801401:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801404:	7c d9                	jl     8013df <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801406:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801409:	8b 45 10             	mov    0x10(%ebp),%eax
  80140c:	01 d0                	add    %edx,%eax
  80140e:	c6 00 00             	movb   $0x0,(%eax)
}
  801411:	90                   	nop
  801412:	c9                   	leave  
  801413:	c3                   	ret    

00801414 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801414:	55                   	push   %ebp
  801415:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801417:	8b 45 14             	mov    0x14(%ebp),%eax
  80141a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801420:	8b 45 14             	mov    0x14(%ebp),%eax
  801423:	8b 00                	mov    (%eax),%eax
  801425:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80142c:	8b 45 10             	mov    0x10(%ebp),%eax
  80142f:	01 d0                	add    %edx,%eax
  801431:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801437:	eb 0c                	jmp    801445 <strsplit+0x31>
			*string++ = 0;
  801439:	8b 45 08             	mov    0x8(%ebp),%eax
  80143c:	8d 50 01             	lea    0x1(%eax),%edx
  80143f:	89 55 08             	mov    %edx,0x8(%ebp)
  801442:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801445:	8b 45 08             	mov    0x8(%ebp),%eax
  801448:	8a 00                	mov    (%eax),%al
  80144a:	84 c0                	test   %al,%al
  80144c:	74 18                	je     801466 <strsplit+0x52>
  80144e:	8b 45 08             	mov    0x8(%ebp),%eax
  801451:	8a 00                	mov    (%eax),%al
  801453:	0f be c0             	movsbl %al,%eax
  801456:	50                   	push   %eax
  801457:	ff 75 0c             	pushl  0xc(%ebp)
  80145a:	e8 83 fa ff ff       	call   800ee2 <strchr>
  80145f:	83 c4 08             	add    $0x8,%esp
  801462:	85 c0                	test   %eax,%eax
  801464:	75 d3                	jne    801439 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801466:	8b 45 08             	mov    0x8(%ebp),%eax
  801469:	8a 00                	mov    (%eax),%al
  80146b:	84 c0                	test   %al,%al
  80146d:	74 5a                	je     8014c9 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  80146f:	8b 45 14             	mov    0x14(%ebp),%eax
  801472:	8b 00                	mov    (%eax),%eax
  801474:	83 f8 0f             	cmp    $0xf,%eax
  801477:	75 07                	jne    801480 <strsplit+0x6c>
		{
			return 0;
  801479:	b8 00 00 00 00       	mov    $0x0,%eax
  80147e:	eb 66                	jmp    8014e6 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801480:	8b 45 14             	mov    0x14(%ebp),%eax
  801483:	8b 00                	mov    (%eax),%eax
  801485:	8d 48 01             	lea    0x1(%eax),%ecx
  801488:	8b 55 14             	mov    0x14(%ebp),%edx
  80148b:	89 0a                	mov    %ecx,(%edx)
  80148d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801494:	8b 45 10             	mov    0x10(%ebp),%eax
  801497:	01 c2                	add    %eax,%edx
  801499:	8b 45 08             	mov    0x8(%ebp),%eax
  80149c:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  80149e:	eb 03                	jmp    8014a3 <strsplit+0x8f>
			string++;
  8014a0:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  8014a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8014a6:	8a 00                	mov    (%eax),%al
  8014a8:	84 c0                	test   %al,%al
  8014aa:	74 8b                	je     801437 <strsplit+0x23>
  8014ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8014af:	8a 00                	mov    (%eax),%al
  8014b1:	0f be c0             	movsbl %al,%eax
  8014b4:	50                   	push   %eax
  8014b5:	ff 75 0c             	pushl  0xc(%ebp)
  8014b8:	e8 25 fa ff ff       	call   800ee2 <strchr>
  8014bd:	83 c4 08             	add    $0x8,%esp
  8014c0:	85 c0                	test   %eax,%eax
  8014c2:	74 dc                	je     8014a0 <strsplit+0x8c>
			string++;
	}
  8014c4:	e9 6e ff ff ff       	jmp    801437 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  8014c9:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  8014ca:	8b 45 14             	mov    0x14(%ebp),%eax
  8014cd:	8b 00                	mov    (%eax),%eax
  8014cf:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8014d6:	8b 45 10             	mov    0x10(%ebp),%eax
  8014d9:	01 d0                	add    %edx,%eax
  8014db:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  8014e1:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8014e6:	c9                   	leave  
  8014e7:	c3                   	ret    

008014e8 <str2lower>:


char* str2lower(char *dst, const char *src)
{
  8014e8:	55                   	push   %ebp
  8014e9:	89 e5                	mov    %esp,%ebp
  8014eb:	83 ec 10             	sub    $0x10,%esp
	char* ret = dst;
  8014ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8014f1:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (int i = 0; i < strlen(src); ++i)
  8014f4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8014fb:	eb 4a                	jmp    801547 <str2lower+0x5f>
	{
		dst[i] = src[i] ;
  8014fd:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801500:	8b 45 08             	mov    0x8(%ebp),%eax
  801503:	01 c2                	add    %eax,%edx
  801505:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801508:	8b 45 0c             	mov    0xc(%ebp),%eax
  80150b:	01 c8                	add    %ecx,%eax
  80150d:	8a 00                	mov    (%eax),%al
  80150f:	88 02                	mov    %al,(%edx)
		if (src[i] >= 'A' && src[i] <= 'Z')
  801511:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801514:	8b 45 0c             	mov    0xc(%ebp),%eax
  801517:	01 d0                	add    %edx,%eax
  801519:	8a 00                	mov    (%eax),%al
  80151b:	3c 40                	cmp    $0x40,%al
  80151d:	7e 25                	jle    801544 <str2lower+0x5c>
  80151f:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801522:	8b 45 0c             	mov    0xc(%ebp),%eax
  801525:	01 d0                	add    %edx,%eax
  801527:	8a 00                	mov    (%eax),%al
  801529:	3c 5a                	cmp    $0x5a,%al
  80152b:	7f 17                	jg     801544 <str2lower+0x5c>
		{
			dst[i] += 32 ;
  80152d:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801530:	8b 45 08             	mov    0x8(%ebp),%eax
  801533:	01 d0                	add    %edx,%eax
  801535:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801538:	8b 55 08             	mov    0x8(%ebp),%edx
  80153b:	01 ca                	add    %ecx,%edx
  80153d:	8a 12                	mov    (%edx),%dl
  80153f:	83 c2 20             	add    $0x20,%edx
  801542:	88 10                	mov    %dl,(%eax)


char* str2lower(char *dst, const char *src)
{
	char* ret = dst;
	for (int i = 0; i < strlen(src); ++i)
  801544:	ff 45 fc             	incl   -0x4(%ebp)
  801547:	ff 75 0c             	pushl  0xc(%ebp)
  80154a:	e8 01 f8 ff ff       	call   800d50 <strlen>
  80154f:	83 c4 04             	add    $0x4,%esp
  801552:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801555:	7f a6                	jg     8014fd <str2lower+0x15>
		if (src[i] >= 'A' && src[i] <= 'Z')
		{
			dst[i] += 32 ;
		}
	}
	return ret;
  801557:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  80155a:	c9                   	leave  
  80155b:	c3                   	ret    

0080155c <uheap_init>:
//==============================================
// [1] INITIALIZE USER HEAP:
//==============================================
int __firstTimeFlag = 1;
void uheap_init()
{
  80155c:	55                   	push   %ebp
  80155d:	89 e5                	mov    %esp,%ebp
  80155f:	83 ec 08             	sub    $0x8,%esp
	if(__firstTimeFlag)
  801562:	a1 08 40 80 00       	mov    0x804008,%eax
  801567:	85 c0                	test   %eax,%eax
  801569:	74 42                	je     8015ad <uheap_init+0x51>
	{
		initialize_dynamic_allocator(USER_HEAP_START, USER_HEAP_START + DYN_ALLOC_MAX_SIZE);
  80156b:	83 ec 08             	sub    $0x8,%esp
  80156e:	68 00 00 00 82       	push   $0x82000000
  801573:	68 00 00 00 80       	push   $0x80000000
  801578:	e8 00 08 00 00       	call   801d7d <initialize_dynamic_allocator>
  80157d:	83 c4 10             	add    $0x10,%esp
		uheapPlaceStrategy = sys_get_uheap_strategy();
  801580:	e8 e7 05 00 00       	call   801b6c <sys_get_uheap_strategy>
  801585:	a3 60 c0 81 00       	mov    %eax,0x81c060
		uheapPageAllocStart = dynAllocEnd + PAGE_SIZE;
  80158a:	a1 40 40 80 00       	mov    0x804040,%eax
  80158f:	05 00 10 00 00       	add    $0x1000,%eax
  801594:	a3 10 c1 81 00       	mov    %eax,0x81c110
		uheapPageAllocBreak = uheapPageAllocStart;
  801599:	a1 10 c1 81 00       	mov    0x81c110,%eax
  80159e:	a3 68 c0 81 00       	mov    %eax,0x81c068

		__firstTimeFlag = 0;
  8015a3:	c7 05 08 40 80 00 00 	movl   $0x0,0x804008
  8015aa:	00 00 00 
	}
}
  8015ad:	90                   	nop
  8015ae:	c9                   	leave  
  8015af:	c3                   	ret    

008015b0 <get_page>:

//==============================================
// [2] GET A PAGE FROM THE KERNEL FOR DA:
//==============================================
int get_page(void* va)
{
  8015b0:	55                   	push   %ebp
  8015b1:	89 e5                	mov    %esp,%ebp
  8015b3:	83 ec 18             	sub    $0x18,%esp
	int ret = __sys_allocate_page(ROUNDDOWN(va, PAGE_SIZE), PERM_USER|PERM_WRITEABLE|PERM_UHPAGE);
  8015b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8015b9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8015bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8015bf:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8015c4:	83 ec 08             	sub    $0x8,%esp
  8015c7:	68 06 04 00 00       	push   $0x406
  8015cc:	50                   	push   %eax
  8015cd:	e8 e4 01 00 00       	call   8017b6 <__sys_allocate_page>
  8015d2:	83 c4 10             	add    $0x10,%esp
  8015d5:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (ret < 0)
  8015d8:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8015dc:	79 14                	jns    8015f2 <get_page+0x42>
		panic("get_page() in user: failed to allocate page from the kernel");
  8015de:	83 ec 04             	sub    $0x4,%esp
  8015e1:	68 08 32 80 00       	push   $0x803208
  8015e6:	6a 1f                	push   $0x1f
  8015e8:	68 44 32 80 00       	push   $0x803244
  8015ed:	e8 e5 11 00 00       	call   8027d7 <_panic>
	return 0;
  8015f2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8015f7:	c9                   	leave  
  8015f8:	c3                   	ret    

008015f9 <return_page>:

//==============================================
// [3] RETURN A PAGE FROM THE DA TO KERNEL:
//==============================================
void return_page(void* va)
{
  8015f9:	55                   	push   %ebp
  8015fa:	89 e5                	mov    %esp,%ebp
  8015fc:	83 ec 18             	sub    $0x18,%esp
	int ret = __sys_unmap_frame(ROUNDDOWN((uint32)va, PAGE_SIZE));
  8015ff:	8b 45 08             	mov    0x8(%ebp),%eax
  801602:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801605:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801608:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80160d:	83 ec 0c             	sub    $0xc,%esp
  801610:	50                   	push   %eax
  801611:	e8 e7 01 00 00       	call   8017fd <__sys_unmap_frame>
  801616:	83 c4 10             	add    $0x10,%esp
  801619:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (ret < 0)
  80161c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801620:	79 14                	jns    801636 <return_page+0x3d>
		panic("return_page() in user: failed to return a page to the kernel");
  801622:	83 ec 04             	sub    $0x4,%esp
  801625:	68 50 32 80 00       	push   $0x803250
  80162a:	6a 2a                	push   $0x2a
  80162c:	68 44 32 80 00       	push   $0x803244
  801631:	e8 a1 11 00 00       	call   8027d7 <_panic>
}
  801636:	90                   	nop
  801637:	c9                   	leave  
  801638:	c3                   	ret    

00801639 <malloc>:

//=================================
// [1] ALLOCATE SPACE IN USER HEAP:
//=================================
void* malloc(uint32 size)
{
  801639:	55                   	push   %ebp
  80163a:	89 e5                	mov    %esp,%ebp
  80163c:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  80163f:	e8 18 ff ff ff       	call   80155c <uheap_init>
	if (size == 0) return NULL ;
  801644:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801648:	75 07                	jne    801651 <malloc+0x18>
  80164a:	b8 00 00 00 00       	mov    $0x0,%eax
  80164f:	eb 14                	jmp    801665 <malloc+0x2c>
	//==============================================================
	//TODO: [PROJECT'25.IM#2] USER HEAP - #1 malloc
	//Your code is here
	//Comment the following line
	panic("malloc() is not implemented yet...!!");
  801651:	83 ec 04             	sub    $0x4,%esp
  801654:	68 90 32 80 00       	push   $0x803290
  801659:	6a 3e                	push   $0x3e
  80165b:	68 44 32 80 00       	push   $0x803244
  801660:	e8 72 11 00 00       	call   8027d7 <_panic>
}
  801665:	c9                   	leave  
  801666:	c3                   	ret    

00801667 <free>:

//=================================
// [2] FREE SPACE FROM USER HEAP:
//=================================
void free(void* virtual_address)
{
  801667:	55                   	push   %ebp
  801668:	89 e5                	mov    %esp,%ebp
  80166a:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.IM#2] USER HEAP - #3 free
	//Your code is here
	//Comment the following line
	panic("free() is not implemented yet...!!");
  80166d:	83 ec 04             	sub    $0x4,%esp
  801670:	68 b8 32 80 00       	push   $0x8032b8
  801675:	6a 49                	push   $0x49
  801677:	68 44 32 80 00       	push   $0x803244
  80167c:	e8 56 11 00 00       	call   8027d7 <_panic>

00801681 <smalloc>:

//=================================
// [3] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  801681:	55                   	push   %ebp
  801682:	89 e5                	mov    %esp,%ebp
  801684:	83 ec 18             	sub    $0x18,%esp
  801687:	8b 45 10             	mov    0x10(%ebp),%eax
  80168a:	88 45 f4             	mov    %al,-0xc(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  80168d:	e8 ca fe ff ff       	call   80155c <uheap_init>
	if (size == 0) return NULL ;
  801692:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801696:	75 07                	jne    80169f <smalloc+0x1e>
  801698:	b8 00 00 00 00       	mov    $0x0,%eax
  80169d:	eb 14                	jmp    8016b3 <smalloc+0x32>
	//==============================================================

	//TODO: [PROJECT'25.IM#3] SHARED MEMORY - #2 smalloc
	//Your code is here
	//Comment the following line
	panic("smalloc() is not implemented yet...!!");
  80169f:	83 ec 04             	sub    $0x4,%esp
  8016a2:	68 dc 32 80 00       	push   $0x8032dc
  8016a7:	6a 5a                	push   $0x5a
  8016a9:	68 44 32 80 00       	push   $0x803244
  8016ae:	e8 24 11 00 00       	call   8027d7 <_panic>
}
  8016b3:	c9                   	leave  
  8016b4:	c3                   	ret    

008016b5 <sget>:

//========================================
// [4] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  8016b5:	55                   	push   %ebp
  8016b6:	89 e5                	mov    %esp,%ebp
  8016b8:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  8016bb:	e8 9c fe ff ff       	call   80155c <uheap_init>
	//==============================================================

	//TODO: [PROJECT'25.IM#3] SHARED MEMORY - #4 sget
	//Your code is here
	//Comment the following line
	panic("sget() is not implemented yet...!!");
  8016c0:	83 ec 04             	sub    $0x4,%esp
  8016c3:	68 04 33 80 00       	push   $0x803304
  8016c8:	6a 6a                	push   $0x6a
  8016ca:	68 44 32 80 00       	push   $0x803244
  8016cf:	e8 03 11 00 00       	call   8027d7 <_panic>

008016d4 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  8016d4:	55                   	push   %ebp
  8016d5:	89 e5                	mov    %esp,%ebp
  8016d7:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  8016da:	e8 7d fe ff ff       	call   80155c <uheap_init>
	//==============================================================
	panic("realloc() is not implemented yet...!!");
  8016df:	83 ec 04             	sub    $0x4,%esp
  8016e2:	68 28 33 80 00       	push   $0x803328
  8016e7:	68 88 00 00 00       	push   $0x88
  8016ec:	68 44 32 80 00       	push   $0x803244
  8016f1:	e8 e1 10 00 00       	call   8027d7 <_panic>

008016f6 <sfree>:
//
//	use sys_delete_shared_object(...); which switches to the kernel mode,
//	calls delete_shared_object(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the delete_shared_object() function is empty, make sure to implement it.
void sfree(void* virtual_address)
{
  8016f6:	55                   	push   %ebp
  8016f7:	89 e5                	mov    %esp,%ebp
  8016f9:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.BONUS#5] EXIT #2 - sfree
	//Your code is here
	//Comment the following line
	panic("sfree() is not implemented yet...!!");
  8016fc:	83 ec 04             	sub    $0x4,%esp
  8016ff:	68 50 33 80 00       	push   $0x803350
  801704:	68 9b 00 00 00       	push   $0x9b
  801709:	68 44 32 80 00       	push   $0x803244
  80170e:	e8 c4 10 00 00       	call   8027d7 <_panic>

00801713 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801713:	55                   	push   %ebp
  801714:	89 e5                	mov    %esp,%ebp
  801716:	57                   	push   %edi
  801717:	56                   	push   %esi
  801718:	53                   	push   %ebx
  801719:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80171c:	8b 45 08             	mov    0x8(%ebp),%eax
  80171f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801722:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801725:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801728:	8b 7d 18             	mov    0x18(%ebp),%edi
  80172b:	8b 75 1c             	mov    0x1c(%ebp),%esi
  80172e:	cd 30                	int    $0x30
  801730:	89 45 f0             	mov    %eax,-0x10(%ebp)
				"b" (a3),
				"D" (a4),
				"S" (a5)
				: "cc", "memory");

	return ret;
  801733:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801736:	83 c4 10             	add    $0x10,%esp
  801739:	5b                   	pop    %ebx
  80173a:	5e                   	pop    %esi
  80173b:	5f                   	pop    %edi
  80173c:	5d                   	pop    %ebp
  80173d:	c3                   	ret    

0080173e <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName, int color)
{
  80173e:	55                   	push   %ebp
  80173f:	89 e5                	mov    %esp,%ebp
  801741:	83 ec 04             	sub    $0x4,%esp
  801744:	8b 45 10             	mov    0x10(%ebp),%eax
  801747:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, color, 0);
  80174a:	8b 4d 14             	mov    0x14(%ebp),%ecx
  80174d:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801751:	8b 45 08             	mov    0x8(%ebp),%eax
  801754:	6a 00                	push   $0x0
  801756:	51                   	push   %ecx
  801757:	52                   	push   %edx
  801758:	ff 75 0c             	pushl  0xc(%ebp)
  80175b:	50                   	push   %eax
  80175c:	6a 00                	push   $0x0
  80175e:	e8 b0 ff ff ff       	call   801713 <syscall>
  801763:	83 c4 18             	add    $0x18,%esp
}
  801766:	90                   	nop
  801767:	c9                   	leave  
  801768:	c3                   	ret    

00801769 <sys_cgetc>:

int
sys_cgetc(void)
{
  801769:	55                   	push   %ebp
  80176a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  80176c:	6a 00                	push   $0x0
  80176e:	6a 00                	push   $0x0
  801770:	6a 00                	push   $0x0
  801772:	6a 00                	push   $0x0
  801774:	6a 00                	push   $0x0
  801776:	6a 02                	push   $0x2
  801778:	e8 96 ff ff ff       	call   801713 <syscall>
  80177d:	83 c4 18             	add    $0x18,%esp
}
  801780:	c9                   	leave  
  801781:	c3                   	ret    

00801782 <sys_lock_cons>:

void sys_lock_cons(void)
{
  801782:	55                   	push   %ebp
  801783:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  801785:	6a 00                	push   $0x0
  801787:	6a 00                	push   $0x0
  801789:	6a 00                	push   $0x0
  80178b:	6a 00                	push   $0x0
  80178d:	6a 00                	push   $0x0
  80178f:	6a 03                	push   $0x3
  801791:	e8 7d ff ff ff       	call   801713 <syscall>
  801796:	83 c4 18             	add    $0x18,%esp
}
  801799:	90                   	nop
  80179a:	c9                   	leave  
  80179b:	c3                   	ret    

0080179c <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  80179c:	55                   	push   %ebp
  80179d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  80179f:	6a 00                	push   $0x0
  8017a1:	6a 00                	push   $0x0
  8017a3:	6a 00                	push   $0x0
  8017a5:	6a 00                	push   $0x0
  8017a7:	6a 00                	push   $0x0
  8017a9:	6a 04                	push   $0x4
  8017ab:	e8 63 ff ff ff       	call   801713 <syscall>
  8017b0:	83 c4 18             	add    $0x18,%esp
}
  8017b3:	90                   	nop
  8017b4:	c9                   	leave  
  8017b5:	c3                   	ret    

008017b6 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  8017b6:	55                   	push   %ebp
  8017b7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  8017b9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8017bf:	6a 00                	push   $0x0
  8017c1:	6a 00                	push   $0x0
  8017c3:	6a 00                	push   $0x0
  8017c5:	52                   	push   %edx
  8017c6:	50                   	push   %eax
  8017c7:	6a 08                	push   $0x8
  8017c9:	e8 45 ff ff ff       	call   801713 <syscall>
  8017ce:	83 c4 18             	add    $0x18,%esp
}
  8017d1:	c9                   	leave  
  8017d2:	c3                   	ret    

008017d3 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  8017d3:	55                   	push   %ebp
  8017d4:	89 e5                	mov    %esp,%ebp
  8017d6:	56                   	push   %esi
  8017d7:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  8017d8:	8b 75 18             	mov    0x18(%ebp),%esi
  8017db:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8017de:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8017e1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8017e7:	56                   	push   %esi
  8017e8:	53                   	push   %ebx
  8017e9:	51                   	push   %ecx
  8017ea:	52                   	push   %edx
  8017eb:	50                   	push   %eax
  8017ec:	6a 09                	push   $0x9
  8017ee:	e8 20 ff ff ff       	call   801713 <syscall>
  8017f3:	83 c4 18             	add    $0x18,%esp
}
  8017f6:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8017f9:	5b                   	pop    %ebx
  8017fa:	5e                   	pop    %esi
  8017fb:	5d                   	pop    %ebp
  8017fc:	c3                   	ret    

008017fd <__sys_unmap_frame>:

int __sys_unmap_frame(uint32 va)
{
  8017fd:	55                   	push   %ebp
  8017fe:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, va, 0, 0, 0, 0);
  801800:	6a 00                	push   $0x0
  801802:	6a 00                	push   $0x0
  801804:	6a 00                	push   $0x0
  801806:	6a 00                	push   $0x0
  801808:	ff 75 08             	pushl  0x8(%ebp)
  80180b:	6a 0a                	push   $0xa
  80180d:	e8 01 ff ff ff       	call   801713 <syscall>
  801812:	83 c4 18             	add    $0x18,%esp
}
  801815:	c9                   	leave  
  801816:	c3                   	ret    

00801817 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801817:	55                   	push   %ebp
  801818:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  80181a:	6a 00                	push   $0x0
  80181c:	6a 00                	push   $0x0
  80181e:	6a 00                	push   $0x0
  801820:	ff 75 0c             	pushl  0xc(%ebp)
  801823:	ff 75 08             	pushl  0x8(%ebp)
  801826:	6a 0b                	push   $0xb
  801828:	e8 e6 fe ff ff       	call   801713 <syscall>
  80182d:	83 c4 18             	add    $0x18,%esp
}
  801830:	c9                   	leave  
  801831:	c3                   	ret    

00801832 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801832:	55                   	push   %ebp
  801833:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801835:	6a 00                	push   $0x0
  801837:	6a 00                	push   $0x0
  801839:	6a 00                	push   $0x0
  80183b:	6a 00                	push   $0x0
  80183d:	6a 00                	push   $0x0
  80183f:	6a 0c                	push   $0xc
  801841:	e8 cd fe ff ff       	call   801713 <syscall>
  801846:	83 c4 18             	add    $0x18,%esp
}
  801849:	c9                   	leave  
  80184a:	c3                   	ret    

0080184b <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  80184b:	55                   	push   %ebp
  80184c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  80184e:	6a 00                	push   $0x0
  801850:	6a 00                	push   $0x0
  801852:	6a 00                	push   $0x0
  801854:	6a 00                	push   $0x0
  801856:	6a 00                	push   $0x0
  801858:	6a 0d                	push   $0xd
  80185a:	e8 b4 fe ff ff       	call   801713 <syscall>
  80185f:	83 c4 18             	add    $0x18,%esp
}
  801862:	c9                   	leave  
  801863:	c3                   	ret    

00801864 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801864:	55                   	push   %ebp
  801865:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801867:	6a 00                	push   $0x0
  801869:	6a 00                	push   $0x0
  80186b:	6a 00                	push   $0x0
  80186d:	6a 00                	push   $0x0
  80186f:	6a 00                	push   $0x0
  801871:	6a 0e                	push   $0xe
  801873:	e8 9b fe ff ff       	call   801713 <syscall>
  801878:	83 c4 18             	add    $0x18,%esp
}
  80187b:	c9                   	leave  
  80187c:	c3                   	ret    

0080187d <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  80187d:	55                   	push   %ebp
  80187e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801880:	6a 00                	push   $0x0
  801882:	6a 00                	push   $0x0
  801884:	6a 00                	push   $0x0
  801886:	6a 00                	push   $0x0
  801888:	6a 00                	push   $0x0
  80188a:	6a 0f                	push   $0xf
  80188c:	e8 82 fe ff ff       	call   801713 <syscall>
  801891:	83 c4 18             	add    $0x18,%esp
}
  801894:	c9                   	leave  
  801895:	c3                   	ret    

00801896 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801896:	55                   	push   %ebp
  801897:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801899:	6a 00                	push   $0x0
  80189b:	6a 00                	push   $0x0
  80189d:	6a 00                	push   $0x0
  80189f:	6a 00                	push   $0x0
  8018a1:	ff 75 08             	pushl  0x8(%ebp)
  8018a4:	6a 10                	push   $0x10
  8018a6:	e8 68 fe ff ff       	call   801713 <syscall>
  8018ab:	83 c4 18             	add    $0x18,%esp
}
  8018ae:	c9                   	leave  
  8018af:	c3                   	ret    

008018b0 <sys_scarce_memory>:

void sys_scarce_memory()
{
  8018b0:	55                   	push   %ebp
  8018b1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  8018b3:	6a 00                	push   $0x0
  8018b5:	6a 00                	push   $0x0
  8018b7:	6a 00                	push   $0x0
  8018b9:	6a 00                	push   $0x0
  8018bb:	6a 00                	push   $0x0
  8018bd:	6a 11                	push   $0x11
  8018bf:	e8 4f fe ff ff       	call   801713 <syscall>
  8018c4:	83 c4 18             	add    $0x18,%esp
}
  8018c7:	90                   	nop
  8018c8:	c9                   	leave  
  8018c9:	c3                   	ret    

008018ca <sys_cputc>:

void
sys_cputc(const char c)
{
  8018ca:	55                   	push   %ebp
  8018cb:	89 e5                	mov    %esp,%ebp
  8018cd:	83 ec 04             	sub    $0x4,%esp
  8018d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8018d3:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  8018d6:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8018da:	6a 00                	push   $0x0
  8018dc:	6a 00                	push   $0x0
  8018de:	6a 00                	push   $0x0
  8018e0:	6a 00                	push   $0x0
  8018e2:	50                   	push   %eax
  8018e3:	6a 01                	push   $0x1
  8018e5:	e8 29 fe ff ff       	call   801713 <syscall>
  8018ea:	83 c4 18             	add    $0x18,%esp
}
  8018ed:	90                   	nop
  8018ee:	c9                   	leave  
  8018ef:	c3                   	ret    

008018f0 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  8018f0:	55                   	push   %ebp
  8018f1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  8018f3:	6a 00                	push   $0x0
  8018f5:	6a 00                	push   $0x0
  8018f7:	6a 00                	push   $0x0
  8018f9:	6a 00                	push   $0x0
  8018fb:	6a 00                	push   $0x0
  8018fd:	6a 14                	push   $0x14
  8018ff:	e8 0f fe ff ff       	call   801713 <syscall>
  801904:	83 c4 18             	add    $0x18,%esp
}
  801907:	90                   	nop
  801908:	c9                   	leave  
  801909:	c3                   	ret    

0080190a <sys_create_shared_object>:

int sys_create_shared_object(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  80190a:	55                   	push   %ebp
  80190b:	89 e5                	mov    %esp,%ebp
  80190d:	83 ec 04             	sub    $0x4,%esp
  801910:	8b 45 10             	mov    0x10(%ebp),%eax
  801913:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801916:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801919:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80191d:	8b 45 08             	mov    0x8(%ebp),%eax
  801920:	6a 00                	push   $0x0
  801922:	51                   	push   %ecx
  801923:	52                   	push   %edx
  801924:	ff 75 0c             	pushl  0xc(%ebp)
  801927:	50                   	push   %eax
  801928:	6a 15                	push   $0x15
  80192a:	e8 e4 fd ff ff       	call   801713 <syscall>
  80192f:	83 c4 18             	add    $0x18,%esp
}
  801932:	c9                   	leave  
  801933:	c3                   	ret    

00801934 <sys_size_of_shared_object>:

//2017:
int sys_size_of_shared_object(int32 ownerID, char* shareName)
{
  801934:	55                   	push   %ebp
  801935:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801937:	8b 55 0c             	mov    0xc(%ebp),%edx
  80193a:	8b 45 08             	mov    0x8(%ebp),%eax
  80193d:	6a 00                	push   $0x0
  80193f:	6a 00                	push   $0x0
  801941:	6a 00                	push   $0x0
  801943:	52                   	push   %edx
  801944:	50                   	push   %eax
  801945:	6a 16                	push   $0x16
  801947:	e8 c7 fd ff ff       	call   801713 <syscall>
  80194c:	83 c4 18             	add    $0x18,%esp
}
  80194f:	c9                   	leave  
  801950:	c3                   	ret    

00801951 <sys_get_shared_object>:
//==========

int sys_get_shared_object(int32 ownerID, char* shareName, void* virtual_address)
{
  801951:	55                   	push   %ebp
  801952:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801954:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801957:	8b 55 0c             	mov    0xc(%ebp),%edx
  80195a:	8b 45 08             	mov    0x8(%ebp),%eax
  80195d:	6a 00                	push   $0x0
  80195f:	6a 00                	push   $0x0
  801961:	51                   	push   %ecx
  801962:	52                   	push   %edx
  801963:	50                   	push   %eax
  801964:	6a 17                	push   $0x17
  801966:	e8 a8 fd ff ff       	call   801713 <syscall>
  80196b:	83 c4 18             	add    $0x18,%esp
}
  80196e:	c9                   	leave  
  80196f:	c3                   	ret    

00801970 <sys_delete_shared_object>:

int sys_delete_shared_object(int32 sharedObjectID, void *startVA)
{
  801970:	55                   	push   %ebp
  801971:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801973:	8b 55 0c             	mov    0xc(%ebp),%edx
  801976:	8b 45 08             	mov    0x8(%ebp),%eax
  801979:	6a 00                	push   $0x0
  80197b:	6a 00                	push   $0x0
  80197d:	6a 00                	push   $0x0
  80197f:	52                   	push   %edx
  801980:	50                   	push   %eax
  801981:	6a 18                	push   $0x18
  801983:	e8 8b fd ff ff       	call   801713 <syscall>
  801988:	83 c4 18             	add    $0x18,%esp
}
  80198b:	c9                   	leave  
  80198c:	c3                   	ret    

0080198d <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  80198d:	55                   	push   %ebp
  80198e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801990:	8b 45 08             	mov    0x8(%ebp),%eax
  801993:	6a 00                	push   $0x0
  801995:	ff 75 14             	pushl  0x14(%ebp)
  801998:	ff 75 10             	pushl  0x10(%ebp)
  80199b:	ff 75 0c             	pushl  0xc(%ebp)
  80199e:	50                   	push   %eax
  80199f:	6a 19                	push   $0x19
  8019a1:	e8 6d fd ff ff       	call   801713 <syscall>
  8019a6:	83 c4 18             	add    $0x18,%esp
}
  8019a9:	c9                   	leave  
  8019aa:	c3                   	ret    

008019ab <sys_run_env>:

void sys_run_env(int32 envId)
{
  8019ab:	55                   	push   %ebp
  8019ac:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  8019ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8019b1:	6a 00                	push   $0x0
  8019b3:	6a 00                	push   $0x0
  8019b5:	6a 00                	push   $0x0
  8019b7:	6a 00                	push   $0x0
  8019b9:	50                   	push   %eax
  8019ba:	6a 1a                	push   $0x1a
  8019bc:	e8 52 fd ff ff       	call   801713 <syscall>
  8019c1:	83 c4 18             	add    $0x18,%esp
}
  8019c4:	90                   	nop
  8019c5:	c9                   	leave  
  8019c6:	c3                   	ret    

008019c7 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  8019c7:	55                   	push   %ebp
  8019c8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  8019ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8019cd:	6a 00                	push   $0x0
  8019cf:	6a 00                	push   $0x0
  8019d1:	6a 00                	push   $0x0
  8019d3:	6a 00                	push   $0x0
  8019d5:	50                   	push   %eax
  8019d6:	6a 1b                	push   $0x1b
  8019d8:	e8 36 fd ff ff       	call   801713 <syscall>
  8019dd:	83 c4 18             	add    $0x18,%esp
}
  8019e0:	c9                   	leave  
  8019e1:	c3                   	ret    

008019e2 <sys_getenvid>:

int32 sys_getenvid(void)
{
  8019e2:	55                   	push   %ebp
  8019e3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  8019e5:	6a 00                	push   $0x0
  8019e7:	6a 00                	push   $0x0
  8019e9:	6a 00                	push   $0x0
  8019eb:	6a 00                	push   $0x0
  8019ed:	6a 00                	push   $0x0
  8019ef:	6a 05                	push   $0x5
  8019f1:	e8 1d fd ff ff       	call   801713 <syscall>
  8019f6:	83 c4 18             	add    $0x18,%esp
}
  8019f9:	c9                   	leave  
  8019fa:	c3                   	ret    

008019fb <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  8019fb:	55                   	push   %ebp
  8019fc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  8019fe:	6a 00                	push   $0x0
  801a00:	6a 00                	push   $0x0
  801a02:	6a 00                	push   $0x0
  801a04:	6a 00                	push   $0x0
  801a06:	6a 00                	push   $0x0
  801a08:	6a 06                	push   $0x6
  801a0a:	e8 04 fd ff ff       	call   801713 <syscall>
  801a0f:	83 c4 18             	add    $0x18,%esp
}
  801a12:	c9                   	leave  
  801a13:	c3                   	ret    

00801a14 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801a14:	55                   	push   %ebp
  801a15:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801a17:	6a 00                	push   $0x0
  801a19:	6a 00                	push   $0x0
  801a1b:	6a 00                	push   $0x0
  801a1d:	6a 00                	push   $0x0
  801a1f:	6a 00                	push   $0x0
  801a21:	6a 07                	push   $0x7
  801a23:	e8 eb fc ff ff       	call   801713 <syscall>
  801a28:	83 c4 18             	add    $0x18,%esp
}
  801a2b:	c9                   	leave  
  801a2c:	c3                   	ret    

00801a2d <sys_exit_env>:


void sys_exit_env(void)
{
  801a2d:	55                   	push   %ebp
  801a2e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801a30:	6a 00                	push   $0x0
  801a32:	6a 00                	push   $0x0
  801a34:	6a 00                	push   $0x0
  801a36:	6a 00                	push   $0x0
  801a38:	6a 00                	push   $0x0
  801a3a:	6a 1c                	push   $0x1c
  801a3c:	e8 d2 fc ff ff       	call   801713 <syscall>
  801a41:	83 c4 18             	add    $0x18,%esp
}
  801a44:	90                   	nop
  801a45:	c9                   	leave  
  801a46:	c3                   	ret    

00801a47 <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  801a47:	55                   	push   %ebp
  801a48:	89 e5                	mov    %esp,%ebp
  801a4a:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801a4d:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801a50:	8d 50 04             	lea    0x4(%eax),%edx
  801a53:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801a56:	6a 00                	push   $0x0
  801a58:	6a 00                	push   $0x0
  801a5a:	6a 00                	push   $0x0
  801a5c:	52                   	push   %edx
  801a5d:	50                   	push   %eax
  801a5e:	6a 1d                	push   $0x1d
  801a60:	e8 ae fc ff ff       	call   801713 <syscall>
  801a65:	83 c4 18             	add    $0x18,%esp
	return result;
  801a68:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801a6b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801a6e:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801a71:	89 01                	mov    %eax,(%ecx)
  801a73:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801a76:	8b 45 08             	mov    0x8(%ebp),%eax
  801a79:	c9                   	leave  
  801a7a:	c2 04 00             	ret    $0x4

00801a7d <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801a7d:	55                   	push   %ebp
  801a7e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801a80:	6a 00                	push   $0x0
  801a82:	6a 00                	push   $0x0
  801a84:	ff 75 10             	pushl  0x10(%ebp)
  801a87:	ff 75 0c             	pushl  0xc(%ebp)
  801a8a:	ff 75 08             	pushl  0x8(%ebp)
  801a8d:	6a 13                	push   $0x13
  801a8f:	e8 7f fc ff ff       	call   801713 <syscall>
  801a94:	83 c4 18             	add    $0x18,%esp
	return ;
  801a97:	90                   	nop
}
  801a98:	c9                   	leave  
  801a99:	c3                   	ret    

00801a9a <sys_rcr2>:
uint32 sys_rcr2()
{
  801a9a:	55                   	push   %ebp
  801a9b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801a9d:	6a 00                	push   $0x0
  801a9f:	6a 00                	push   $0x0
  801aa1:	6a 00                	push   $0x0
  801aa3:	6a 00                	push   $0x0
  801aa5:	6a 00                	push   $0x0
  801aa7:	6a 1e                	push   $0x1e
  801aa9:	e8 65 fc ff ff       	call   801713 <syscall>
  801aae:	83 c4 18             	add    $0x18,%esp
}
  801ab1:	c9                   	leave  
  801ab2:	c3                   	ret    

00801ab3 <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  801ab3:	55                   	push   %ebp
  801ab4:	89 e5                	mov    %esp,%ebp
  801ab6:	83 ec 04             	sub    $0x4,%esp
  801ab9:	8b 45 08             	mov    0x8(%ebp),%eax
  801abc:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801abf:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801ac3:	6a 00                	push   $0x0
  801ac5:	6a 00                	push   $0x0
  801ac7:	6a 00                	push   $0x0
  801ac9:	6a 00                	push   $0x0
  801acb:	50                   	push   %eax
  801acc:	6a 1f                	push   $0x1f
  801ace:	e8 40 fc ff ff       	call   801713 <syscall>
  801ad3:	83 c4 18             	add    $0x18,%esp
	return ;
  801ad6:	90                   	nop
}
  801ad7:	c9                   	leave  
  801ad8:	c3                   	ret    

00801ad9 <rsttst>:
void rsttst()
{
  801ad9:	55                   	push   %ebp
  801ada:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801adc:	6a 00                	push   $0x0
  801ade:	6a 00                	push   $0x0
  801ae0:	6a 00                	push   $0x0
  801ae2:	6a 00                	push   $0x0
  801ae4:	6a 00                	push   $0x0
  801ae6:	6a 21                	push   $0x21
  801ae8:	e8 26 fc ff ff       	call   801713 <syscall>
  801aed:	83 c4 18             	add    $0x18,%esp
	return ;
  801af0:	90                   	nop
}
  801af1:	c9                   	leave  
  801af2:	c3                   	ret    

00801af3 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801af3:	55                   	push   %ebp
  801af4:	89 e5                	mov    %esp,%ebp
  801af6:	83 ec 04             	sub    $0x4,%esp
  801af9:	8b 45 14             	mov    0x14(%ebp),%eax
  801afc:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801aff:	8b 55 18             	mov    0x18(%ebp),%edx
  801b02:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801b06:	52                   	push   %edx
  801b07:	50                   	push   %eax
  801b08:	ff 75 10             	pushl  0x10(%ebp)
  801b0b:	ff 75 0c             	pushl  0xc(%ebp)
  801b0e:	ff 75 08             	pushl  0x8(%ebp)
  801b11:	6a 20                	push   $0x20
  801b13:	e8 fb fb ff ff       	call   801713 <syscall>
  801b18:	83 c4 18             	add    $0x18,%esp
	return ;
  801b1b:	90                   	nop
}
  801b1c:	c9                   	leave  
  801b1d:	c3                   	ret    

00801b1e <chktst>:
void chktst(uint32 n)
{
  801b1e:	55                   	push   %ebp
  801b1f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801b21:	6a 00                	push   $0x0
  801b23:	6a 00                	push   $0x0
  801b25:	6a 00                	push   $0x0
  801b27:	6a 00                	push   $0x0
  801b29:	ff 75 08             	pushl  0x8(%ebp)
  801b2c:	6a 22                	push   $0x22
  801b2e:	e8 e0 fb ff ff       	call   801713 <syscall>
  801b33:	83 c4 18             	add    $0x18,%esp
	return ;
  801b36:	90                   	nop
}
  801b37:	c9                   	leave  
  801b38:	c3                   	ret    

00801b39 <inctst>:

void inctst()
{
  801b39:	55                   	push   %ebp
  801b3a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801b3c:	6a 00                	push   $0x0
  801b3e:	6a 00                	push   $0x0
  801b40:	6a 00                	push   $0x0
  801b42:	6a 00                	push   $0x0
  801b44:	6a 00                	push   $0x0
  801b46:	6a 23                	push   $0x23
  801b48:	e8 c6 fb ff ff       	call   801713 <syscall>
  801b4d:	83 c4 18             	add    $0x18,%esp
	return ;
  801b50:	90                   	nop
}
  801b51:	c9                   	leave  
  801b52:	c3                   	ret    

00801b53 <gettst>:
uint32 gettst()
{
  801b53:	55                   	push   %ebp
  801b54:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801b56:	6a 00                	push   $0x0
  801b58:	6a 00                	push   $0x0
  801b5a:	6a 00                	push   $0x0
  801b5c:	6a 00                	push   $0x0
  801b5e:	6a 00                	push   $0x0
  801b60:	6a 24                	push   $0x24
  801b62:	e8 ac fb ff ff       	call   801713 <syscall>
  801b67:	83 c4 18             	add    $0x18,%esp
}
  801b6a:	c9                   	leave  
  801b6b:	c3                   	ret    

00801b6c <sys_get_uheap_strategy>:

/*2025*/
uint32 sys_get_uheap_strategy()
{
  801b6c:	55                   	push   %ebp
  801b6d:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801b6f:	6a 00                	push   $0x0
  801b71:	6a 00                	push   $0x0
  801b73:	6a 00                	push   $0x0
  801b75:	6a 00                	push   $0x0
  801b77:	6a 00                	push   $0x0
  801b79:	6a 25                	push   $0x25
  801b7b:	e8 93 fb ff ff       	call   801713 <syscall>
  801b80:	83 c4 18             	add    $0x18,%esp
  801b83:	a3 60 c0 81 00       	mov    %eax,0x81c060
	return uheapPlaceStrategy ;
  801b88:	a1 60 c0 81 00       	mov    0x81c060,%eax
}
  801b8d:	c9                   	leave  
  801b8e:	c3                   	ret    

00801b8f <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801b8f:	55                   	push   %ebp
  801b90:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = heapStrategy;
  801b92:	8b 45 08             	mov    0x8(%ebp),%eax
  801b95:	a3 60 c0 81 00       	mov    %eax,0x81c060
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801b9a:	6a 00                	push   $0x0
  801b9c:	6a 00                	push   $0x0
  801b9e:	6a 00                	push   $0x0
  801ba0:	6a 00                	push   $0x0
  801ba2:	ff 75 08             	pushl  0x8(%ebp)
  801ba5:	6a 26                	push   $0x26
  801ba7:	e8 67 fb ff ff       	call   801713 <syscall>
  801bac:	83 c4 18             	add    $0x18,%esp
	return ;
  801baf:	90                   	nop
}
  801bb0:	c9                   	leave  
  801bb1:	c3                   	ret    

00801bb2 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801bb2:	55                   	push   %ebp
  801bb3:	89 e5                	mov    %esp,%ebp
  801bb5:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801bb6:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801bb9:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801bbc:	8b 55 0c             	mov    0xc(%ebp),%edx
  801bbf:	8b 45 08             	mov    0x8(%ebp),%eax
  801bc2:	6a 00                	push   $0x0
  801bc4:	53                   	push   %ebx
  801bc5:	51                   	push   %ecx
  801bc6:	52                   	push   %edx
  801bc7:	50                   	push   %eax
  801bc8:	6a 27                	push   $0x27
  801bca:	e8 44 fb ff ff       	call   801713 <syscall>
  801bcf:	83 c4 18             	add    $0x18,%esp
}
  801bd2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801bd5:	c9                   	leave  
  801bd6:	c3                   	ret    

00801bd7 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801bd7:	55                   	push   %ebp
  801bd8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801bda:	8b 55 0c             	mov    0xc(%ebp),%edx
  801bdd:	8b 45 08             	mov    0x8(%ebp),%eax
  801be0:	6a 00                	push   $0x0
  801be2:	6a 00                	push   $0x0
  801be4:	6a 00                	push   $0x0
  801be6:	52                   	push   %edx
  801be7:	50                   	push   %eax
  801be8:	6a 28                	push   $0x28
  801bea:	e8 24 fb ff ff       	call   801713 <syscall>
  801bef:	83 c4 18             	add    $0x18,%esp
}
  801bf2:	c9                   	leave  
  801bf3:	c3                   	ret    

00801bf4 <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  801bf4:	55                   	push   %ebp
  801bf5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  801bf7:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801bfa:	8b 55 0c             	mov    0xc(%ebp),%edx
  801bfd:	8b 45 08             	mov    0x8(%ebp),%eax
  801c00:	6a 00                	push   $0x0
  801c02:	51                   	push   %ecx
  801c03:	ff 75 10             	pushl  0x10(%ebp)
  801c06:	52                   	push   %edx
  801c07:	50                   	push   %eax
  801c08:	6a 29                	push   $0x29
  801c0a:	e8 04 fb ff ff       	call   801713 <syscall>
  801c0f:	83 c4 18             	add    $0x18,%esp
}
  801c12:	c9                   	leave  
  801c13:	c3                   	ret    

00801c14 <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801c14:	55                   	push   %ebp
  801c15:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801c17:	6a 00                	push   $0x0
  801c19:	6a 00                	push   $0x0
  801c1b:	ff 75 10             	pushl  0x10(%ebp)
  801c1e:	ff 75 0c             	pushl  0xc(%ebp)
  801c21:	ff 75 08             	pushl  0x8(%ebp)
  801c24:	6a 12                	push   $0x12
  801c26:	e8 e8 fa ff ff       	call   801713 <syscall>
  801c2b:	83 c4 18             	add    $0x18,%esp
	return ;
  801c2e:	90                   	nop
}
  801c2f:	c9                   	leave  
  801c30:	c3                   	ret    

00801c31 <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  801c31:	55                   	push   %ebp
  801c32:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  801c34:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c37:	8b 45 08             	mov    0x8(%ebp),%eax
  801c3a:	6a 00                	push   $0x0
  801c3c:	6a 00                	push   $0x0
  801c3e:	6a 00                	push   $0x0
  801c40:	52                   	push   %edx
  801c41:	50                   	push   %eax
  801c42:	6a 2a                	push   $0x2a
  801c44:	e8 ca fa ff ff       	call   801713 <syscall>
  801c49:	83 c4 18             	add    $0x18,%esp
	return;
  801c4c:	90                   	nop
}
  801c4d:	c9                   	leave  
  801c4e:	c3                   	ret    

00801c4f <sys_get_optimal_num_faults>:
/*2025*/
int sys_get_optimal_num_faults()
{
  801c4f:	55                   	push   %ebp
  801c50:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_optimal_num_faults, 0, 0, 0, 0, 0);
  801c52:	6a 00                	push   $0x0
  801c54:	6a 00                	push   $0x0
  801c56:	6a 00                	push   $0x0
  801c58:	6a 00                	push   $0x0
  801c5a:	6a 00                	push   $0x0
  801c5c:	6a 2b                	push   $0x2b
  801c5e:	e8 b0 fa ff ff       	call   801713 <syscall>
  801c63:	83 c4 18             	add    $0x18,%esp
}
  801c66:	c9                   	leave  
  801c67:	c3                   	ret    

00801c68 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801c68:	55                   	push   %ebp
  801c69:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801c6b:	6a 00                	push   $0x0
  801c6d:	6a 00                	push   $0x0
  801c6f:	6a 00                	push   $0x0
  801c71:	ff 75 0c             	pushl  0xc(%ebp)
  801c74:	ff 75 08             	pushl  0x8(%ebp)
  801c77:	6a 2d                	push   $0x2d
  801c79:	e8 95 fa ff ff       	call   801713 <syscall>
  801c7e:	83 c4 18             	add    $0x18,%esp
	return;
  801c81:	90                   	nop
}
  801c82:	c9                   	leave  
  801c83:	c3                   	ret    

00801c84 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801c84:	55                   	push   %ebp
  801c85:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801c87:	6a 00                	push   $0x0
  801c89:	6a 00                	push   $0x0
  801c8b:	6a 00                	push   $0x0
  801c8d:	ff 75 0c             	pushl  0xc(%ebp)
  801c90:	ff 75 08             	pushl  0x8(%ebp)
  801c93:	6a 2c                	push   $0x2c
  801c95:	e8 79 fa ff ff       	call   801713 <syscall>
  801c9a:	83 c4 18             	add    $0x18,%esp
	return ;
  801c9d:	90                   	nop
}
  801c9e:	c9                   	leave  
  801c9f:	c3                   	ret    

00801ca0 <sys_env_set_priority>:


void sys_env_set_priority(int32 envID, int priority)
{
  801ca0:	55                   	push   %ebp
  801ca1:	89 e5                	mov    %esp,%ebp
  801ca3:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.IM#4] CPU SCHEDULING - #1 System Calls - Add suitable code here
	//Your code is here
	//Comment the following line
	panic("sys_env_set_priority() is not implemented yet...!!");
  801ca6:	83 ec 04             	sub    $0x4,%esp
  801ca9:	68 74 33 80 00       	push   $0x803374
  801cae:	68 25 01 00 00       	push   $0x125
  801cb3:	68 a7 33 80 00       	push   $0x8033a7
  801cb8:	e8 1a 0b 00 00       	call   8027d7 <_panic>

00801cbd <to_page_va>:
//==================================
//==================================
// [1] GET PAGE VA:
//==================================
__inline__ uint32 to_page_va(struct PageInfoElement *ptrPageInfo)
{
  801cbd:	55                   	push   %ebp
  801cbe:	89 e5                	mov    %esp,%ebp
  801cc0:	83 ec 18             	sub    $0x18,%esp
	if (ptrPageInfo < &pageBlockInfoArr[0] || ptrPageInfo >= &pageBlockInfoArr[DYN_ALLOC_MAX_SIZE/PAGE_SIZE])
  801cc3:	81 7d 08 60 40 80 00 	cmpl   $0x804060,0x8(%ebp)
  801cca:	72 09                	jb     801cd5 <to_page_va+0x18>
  801ccc:	81 7d 08 60 c0 81 00 	cmpl   $0x81c060,0x8(%ebp)
  801cd3:	72 14                	jb     801ce9 <to_page_va+0x2c>
			panic("to_page_va called with invalid pageInfoPtr");
  801cd5:	83 ec 04             	sub    $0x4,%esp
  801cd8:	68 b8 33 80 00       	push   $0x8033b8
  801cdd:	6a 15                	push   $0x15
  801cdf:	68 e3 33 80 00       	push   $0x8033e3
  801ce4:	e8 ee 0a 00 00       	call   8027d7 <_panic>
	//Get start VA of the page from the corresponding Page Info pointer
	int idxInPageInfoArr = (ptrPageInfo - pageBlockInfoArr);
  801ce9:	8b 45 08             	mov    0x8(%ebp),%eax
  801cec:	ba 60 40 80 00       	mov    $0x804060,%edx
  801cf1:	29 d0                	sub    %edx,%eax
  801cf3:	c1 f8 02             	sar    $0x2,%eax
  801cf6:	89 c2                	mov    %eax,%edx
  801cf8:	89 d0                	mov    %edx,%eax
  801cfa:	c1 e0 02             	shl    $0x2,%eax
  801cfd:	01 d0                	add    %edx,%eax
  801cff:	c1 e0 02             	shl    $0x2,%eax
  801d02:	01 d0                	add    %edx,%eax
  801d04:	c1 e0 02             	shl    $0x2,%eax
  801d07:	01 d0                	add    %edx,%eax
  801d09:	89 c1                	mov    %eax,%ecx
  801d0b:	c1 e1 08             	shl    $0x8,%ecx
  801d0e:	01 c8                	add    %ecx,%eax
  801d10:	89 c1                	mov    %eax,%ecx
  801d12:	c1 e1 10             	shl    $0x10,%ecx
  801d15:	01 c8                	add    %ecx,%eax
  801d17:	01 c0                	add    %eax,%eax
  801d19:	01 d0                	add    %edx,%eax
  801d1b:	89 45 f4             	mov    %eax,-0xc(%ebp)
	return dynAllocStart + (idxInPageInfoArr << PGSHIFT);
  801d1e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d21:	c1 e0 0c             	shl    $0xc,%eax
  801d24:	89 c2                	mov    %eax,%edx
  801d26:	a1 64 c0 81 00       	mov    0x81c064,%eax
  801d2b:	01 d0                	add    %edx,%eax
}
  801d2d:	c9                   	leave  
  801d2e:	c3                   	ret    

00801d2f <to_page_info>:

//==================================
// [2] GET PAGE INFO OF PAGE VA:
//==================================
__inline__ struct PageInfoElement * to_page_info(uint32 va)
{
  801d2f:	55                   	push   %ebp
  801d30:	89 e5                	mov    %esp,%ebp
  801d32:	83 ec 18             	sub    $0x18,%esp
	int idxInPageInfoArr = (va - dynAllocStart) >> PGSHIFT;
  801d35:	a1 64 c0 81 00       	mov    0x81c064,%eax
  801d3a:	8b 55 08             	mov    0x8(%ebp),%edx
  801d3d:	29 c2                	sub    %eax,%edx
  801d3f:	89 d0                	mov    %edx,%eax
  801d41:	c1 e8 0c             	shr    $0xc,%eax
  801d44:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if (idxInPageInfoArr < 0 || idxInPageInfoArr >= DYN_ALLOC_MAX_SIZE/PAGE_SIZE)
  801d47:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801d4b:	78 09                	js     801d56 <to_page_info+0x27>
  801d4d:	81 7d f4 ff 1f 00 00 	cmpl   $0x1fff,-0xc(%ebp)
  801d54:	7e 14                	jle    801d6a <to_page_info+0x3b>
		panic("to_page_info called with invalid pa");
  801d56:	83 ec 04             	sub    $0x4,%esp
  801d59:	68 fc 33 80 00       	push   $0x8033fc
  801d5e:	6a 22                	push   $0x22
  801d60:	68 e3 33 80 00       	push   $0x8033e3
  801d65:	e8 6d 0a 00 00       	call   8027d7 <_panic>
	return &pageBlockInfoArr[idxInPageInfoArr];
  801d6a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801d6d:	89 d0                	mov    %edx,%eax
  801d6f:	01 c0                	add    %eax,%eax
  801d71:	01 d0                	add    %edx,%eax
  801d73:	c1 e0 02             	shl    $0x2,%eax
  801d76:	05 60 40 80 00       	add    $0x804060,%eax
}
  801d7b:	c9                   	leave  
  801d7c:	c3                   	ret    

00801d7d <initialize_dynamic_allocator>:
//==================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================
bool is_initialized = 0;
void initialize_dynamic_allocator(uint32 daStart, uint32 daEnd)
{
  801d7d:	55                   	push   %ebp
  801d7e:	89 e5                	mov    %esp,%ebp
  801d80:	83 ec 18             	sub    $0x18,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		assert(daEnd <= daStart + DYN_ALLOC_MAX_SIZE);
  801d83:	8b 45 08             	mov    0x8(%ebp),%eax
  801d86:	05 00 00 00 02       	add    $0x2000000,%eax
  801d8b:	3b 45 0c             	cmp    0xc(%ebp),%eax
  801d8e:	73 16                	jae    801da6 <initialize_dynamic_allocator+0x29>
  801d90:	68 20 34 80 00       	push   $0x803420
  801d95:	68 46 34 80 00       	push   $0x803446
  801d9a:	6a 34                	push   $0x34
  801d9c:	68 e3 33 80 00       	push   $0x8033e3
  801da1:	e8 31 0a 00 00       	call   8027d7 <_panic>
		is_initialized = 1;
  801da6:	c7 05 24 40 80 00 01 	movl   $0x1,0x804024
  801dad:	00 00 00 
	//==================================================================================
	//==================================================================================
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #1 initialize_dynamic_allocator
	//Your code is here
	// init bounds of the dynalloc
	dynAllocStart = daStart;
  801db0:	8b 45 08             	mov    0x8(%ebp),%eax
  801db3:	a3 64 c0 81 00       	mov    %eax,0x81c064
	dynAllocEnd = daEnd;
  801db8:	8b 45 0c             	mov    0xc(%ebp),%eax
  801dbb:	a3 40 40 80 00       	mov    %eax,0x804040
	// init the list that keep track of all free pageBlockInfoArr instances.
	LIST_INIT(&freePagesList);
  801dc0:	c7 05 48 40 80 00 00 	movl   $0x0,0x804048
  801dc7:	00 00 00 
  801dca:	c7 05 4c 40 80 00 00 	movl   $0x0,0x80404c
  801dd1:	00 00 00 
  801dd4:	c7 05 54 40 80 00 00 	movl   $0x0,0x804054
  801ddb:	00 00 00 

	// no.of pages in the dynamic allocator.
	int pCount = (daEnd - daStart) / PAGE_SIZE;
  801dde:	8b 45 0c             	mov    0xc(%ebp),%eax
  801de1:	2b 45 08             	sub    0x8(%ebp),%eax
  801de4:	c1 e8 0c             	shr    $0xc,%eax
  801de7:	89 45 ec             	mov    %eax,-0x14(%ebp)
	// iterate over each page and init its data in pageBlockInfoArr and reset it.
	for (int i = 0; i < pCount; ++i) {
  801dea:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  801df1:	e9 c8 00 00 00       	jmp    801ebe <initialize_dynamic_allocator+0x141>
	    pageBlockInfoArr[i].block_size = 0;
  801df6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801df9:	89 d0                	mov    %edx,%eax
  801dfb:	01 c0                	add    %eax,%eax
  801dfd:	01 d0                	add    %edx,%eax
  801dff:	c1 e0 02             	shl    $0x2,%eax
  801e02:	05 68 40 80 00       	add    $0x804068,%eax
  801e07:	66 c7 00 00 00       	movw   $0x0,(%eax)
	    pageBlockInfoArr[i].num_of_free_blocks = 0;
  801e0c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801e0f:	89 d0                	mov    %edx,%eax
  801e11:	01 c0                	add    %eax,%eax
  801e13:	01 d0                	add    %edx,%eax
  801e15:	c1 e0 02             	shl    $0x2,%eax
  801e18:	05 6a 40 80 00       	add    $0x80406a,%eax
  801e1d:	66 c7 00 00 00       	movw   $0x0,(%eax)
	    LIST_INSERT_TAIL(&freePagesList, &pageBlockInfoArr[i]);
  801e22:	8b 15 4c 40 80 00    	mov    0x80404c,%edx
  801e28:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  801e2b:	89 c8                	mov    %ecx,%eax
  801e2d:	01 c0                	add    %eax,%eax
  801e2f:	01 c8                	add    %ecx,%eax
  801e31:	c1 e0 02             	shl    $0x2,%eax
  801e34:	05 64 40 80 00       	add    $0x804064,%eax
  801e39:	89 10                	mov    %edx,(%eax)
  801e3b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801e3e:	89 d0                	mov    %edx,%eax
  801e40:	01 c0                	add    %eax,%eax
  801e42:	01 d0                	add    %edx,%eax
  801e44:	c1 e0 02             	shl    $0x2,%eax
  801e47:	05 64 40 80 00       	add    $0x804064,%eax
  801e4c:	8b 00                	mov    (%eax),%eax
  801e4e:	85 c0                	test   %eax,%eax
  801e50:	74 1b                	je     801e6d <initialize_dynamic_allocator+0xf0>
  801e52:	8b 15 4c 40 80 00    	mov    0x80404c,%edx
  801e58:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  801e5b:	89 c8                	mov    %ecx,%eax
  801e5d:	01 c0                	add    %eax,%eax
  801e5f:	01 c8                	add    %ecx,%eax
  801e61:	c1 e0 02             	shl    $0x2,%eax
  801e64:	05 60 40 80 00       	add    $0x804060,%eax
  801e69:	89 02                	mov    %eax,(%edx)
  801e6b:	eb 16                	jmp    801e83 <initialize_dynamic_allocator+0x106>
  801e6d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801e70:	89 d0                	mov    %edx,%eax
  801e72:	01 c0                	add    %eax,%eax
  801e74:	01 d0                	add    %edx,%eax
  801e76:	c1 e0 02             	shl    $0x2,%eax
  801e79:	05 60 40 80 00       	add    $0x804060,%eax
  801e7e:	a3 48 40 80 00       	mov    %eax,0x804048
  801e83:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801e86:	89 d0                	mov    %edx,%eax
  801e88:	01 c0                	add    %eax,%eax
  801e8a:	01 d0                	add    %edx,%eax
  801e8c:	c1 e0 02             	shl    $0x2,%eax
  801e8f:	05 60 40 80 00       	add    $0x804060,%eax
  801e94:	a3 4c 40 80 00       	mov    %eax,0x80404c
  801e99:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801e9c:	89 d0                	mov    %edx,%eax
  801e9e:	01 c0                	add    %eax,%eax
  801ea0:	01 d0                	add    %edx,%eax
  801ea2:	c1 e0 02             	shl    $0x2,%eax
  801ea5:	05 60 40 80 00       	add    $0x804060,%eax
  801eaa:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801eb0:	a1 54 40 80 00       	mov    0x804054,%eax
  801eb5:	40                   	inc    %eax
  801eb6:	a3 54 40 80 00       	mov    %eax,0x804054
	LIST_INIT(&freePagesList);

	// no.of pages in the dynamic allocator.
	int pCount = (daEnd - daStart) / PAGE_SIZE;
	// iterate over each page and init its data in pageBlockInfoArr and reset it.
	for (int i = 0; i < pCount; ++i) {
  801ebb:	ff 45 f4             	incl   -0xc(%ebp)
  801ebe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ec1:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  801ec4:	0f 8c 2c ff ff ff    	jl     801df6 <initialize_dynamic_allocator+0x79>
	    LIST_INSERT_TAIL(&freePagesList, &pageBlockInfoArr[i]);
	}
	// init the array of lists of each size..
	// 8 16 32 64 128 256 512 1024 2056
	// 0 1  2  3   4  5    6   7    8
	for (int i = 0; i <= (LOG2_MAX_SIZE - LOG2_MIN_SIZE); ++i){
  801eca:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  801ed1:	eb 36                	jmp    801f09 <initialize_dynamic_allocator+0x18c>
		LIST_INIT(&freeBlockLists[i]);
  801ed3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ed6:	c1 e0 04             	shl    $0x4,%eax
  801ed9:	05 80 c0 81 00       	add    $0x81c080,%eax
  801ede:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801ee4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ee7:	c1 e0 04             	shl    $0x4,%eax
  801eea:	05 84 c0 81 00       	add    $0x81c084,%eax
  801eef:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801ef5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ef8:	c1 e0 04             	shl    $0x4,%eax
  801efb:	05 8c c0 81 00       	add    $0x81c08c,%eax
  801f00:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	    LIST_INSERT_TAIL(&freePagesList, &pageBlockInfoArr[i]);
	}
	// init the array of lists of each size..
	// 8 16 32 64 128 256 512 1024 2056
	// 0 1  2  3   4  5    6   7    8
	for (int i = 0; i <= (LOG2_MAX_SIZE - LOG2_MIN_SIZE); ++i){
  801f06:	ff 45 f0             	incl   -0x10(%ebp)
  801f09:	83 7d f0 08          	cmpl   $0x8,-0x10(%ebp)
  801f0d:	7e c4                	jle    801ed3 <initialize_dynamic_allocator+0x156>
		LIST_INIT(&freeBlockLists[i]);
	}
	//Comment the following line
	//panic("initialize_dynamic_allocator() Not implemented yet");

}
  801f0f:	90                   	nop
  801f10:	c9                   	leave  
  801f11:	c3                   	ret    

00801f12 <get_block_size>:

//===========================
// [2] GET BLOCK SIZE:
//===========================
__inline__ uint32 get_block_size(void *va)
{
  801f12:	55                   	push   %ebp
  801f13:	89 e5                	mov    %esp,%ebp
  801f15:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #2 get_block_size
	//Your code is here
	// get the page that saves this va
	struct PageInfoElement* ptr = to_page_info((uint32)va);
  801f18:	8b 45 08             	mov    0x8(%ebp),%eax
  801f1b:	83 ec 0c             	sub    $0xc,%esp
  801f1e:	50                   	push   %eax
  801f1f:	e8 0b fe ff ff       	call   801d2f <to_page_info>
  801f24:	83 c4 10             	add    $0x10,%esp
  801f27:	89 45 f4             	mov    %eax,-0xc(%ebp)
	return ptr->block_size;
  801f2a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f2d:	8b 40 08             	mov    0x8(%eax),%eax
  801f30:	0f b7 c0             	movzwl %ax,%eax
	//Comment the following line
	//panic("get_block_size() Not implemented yet");
}
  801f33:	c9                   	leave  
  801f34:	c3                   	ret    

00801f35 <split_page_to_blocks>:
// =====================
// h) split page to blocks and add them in freeBlockLists
// =====================
// function that split the page provided into same sized blocks
//and putem in suitable freeblockList index according to size.
 void split_page_to_blocks(uint32 blk_size, struct PageInfoElement *pageInfo) {
  801f35:	55                   	push   %ebp
  801f36:	89 e5                	mov    %esp,%ebp
  801f38:	83 ec 28             	sub    $0x28,%esp
	 // cur page virtual address by the pageInfo.
	 uint32 page_va = (uint32)to_page_va(pageInfo);
  801f3b:	83 ec 0c             	sub    $0xc,%esp
  801f3e:	ff 75 0c             	pushl  0xc(%ebp)
  801f41:	e8 77 fd ff ff       	call   801cbd <to_page_va>
  801f46:	83 c4 10             	add    $0x10,%esp
  801f49:	89 45 e8             	mov    %eax,-0x18(%ebp)
	 // no. of blks to save in freeblockList.
	 int blk_count = PAGE_SIZE / blk_size;
  801f4c:	b8 00 10 00 00       	mov    $0x1000,%eax
  801f51:	ba 00 00 00 00       	mov    $0x0,%edx
  801f56:	f7 75 08             	divl   0x8(%ebp)
  801f59:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	 // save page in memory.
	 get_page((uint32*)page_va);
  801f5c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801f5f:	83 ec 0c             	sub    $0xc,%esp
  801f62:	50                   	push   %eax
  801f63:	e8 48 f6 ff ff       	call   8015b0 <get_page>
  801f68:	83 c4 10             	add    $0x10,%esp
	 // assigning the pageInfo data block size, free block which is whole block count.
	 pageInfo->num_of_free_blocks = blk_count;
  801f6b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801f6e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f71:	66 89 42 0a          	mov    %ax,0xa(%edx)
	 pageInfo->block_size = blk_size;
  801f75:	8b 45 08             	mov    0x8(%ebp),%eax
  801f78:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f7b:	66 89 42 08          	mov    %ax,0x8(%edx)
	 // get index by size block in freeblocklist.
	 int idx = 0;
  801f7f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	 for (int i = LOG2_MIN_SIZE; i <= LOG2_MAX_SIZE; i++) {
  801f86:	c7 45 f0 03 00 00 00 	movl   $0x3,-0x10(%ebp)
  801f8d:	eb 19                	jmp    801fa8 <split_page_to_blocks+0x73>
	     if ((1 << i) == blk_size)
  801f8f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f92:	ba 01 00 00 00       	mov    $0x1,%edx
  801f97:	88 c1                	mov    %al,%cl
  801f99:	d3 e2                	shl    %cl,%edx
  801f9b:	89 d0                	mov    %edx,%eax
  801f9d:	3b 45 08             	cmp    0x8(%ebp),%eax
  801fa0:	74 0e                	je     801fb0 <split_page_to_blocks+0x7b>
	         break;
	     idx++;
  801fa2:	ff 45 f4             	incl   -0xc(%ebp)
	 // assigning the pageInfo data block size, free block which is whole block count.
	 pageInfo->num_of_free_blocks = blk_count;
	 pageInfo->block_size = blk_size;
	 // get index by size block in freeblocklist.
	 int idx = 0;
	 for (int i = LOG2_MIN_SIZE; i <= LOG2_MAX_SIZE; i++) {
  801fa5:	ff 45 f0             	incl   -0x10(%ebp)
  801fa8:	83 7d f0 0b          	cmpl   $0xb,-0x10(%ebp)
  801fac:	7e e1                	jle    801f8f <split_page_to_blocks+0x5a>
  801fae:	eb 01                	jmp    801fb1 <split_page_to_blocks+0x7c>
	     if ((1 << i) == blk_size)
	         break;
  801fb0:	90                   	nop
	     idx++;
	 }
	 // iterate over each blk and make and element of it by passing its address in blockElement pointer and save those in the list.
	 // starting from the page_va.
	 for (uint32 i = 0; i < blk_count; ++i) {
  801fb1:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  801fb8:	e9 a7 00 00 00       	jmp    802064 <split_page_to_blocks+0x12f>
	     struct BlockElement *blk =(struct BlockElement*)(page_va + i * blk_size);
  801fbd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801fc0:	0f af 45 08          	imul   0x8(%ebp),%eax
  801fc4:	89 c2                	mov    %eax,%edx
  801fc6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801fc9:	01 d0                	add    %edx,%eax
  801fcb:	89 45 e0             	mov    %eax,-0x20(%ebp)
	     LIST_INSERT_TAIL(&freeBlockLists[idx],blk);
  801fce:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801fd2:	75 14                	jne    801fe8 <split_page_to_blocks+0xb3>
  801fd4:	83 ec 04             	sub    $0x4,%esp
  801fd7:	68 5c 34 80 00       	push   $0x80345c
  801fdc:	6a 7c                	push   $0x7c
  801fde:	68 e3 33 80 00       	push   $0x8033e3
  801fe3:	e8 ef 07 00 00       	call   8027d7 <_panic>
  801fe8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801feb:	c1 e0 04             	shl    $0x4,%eax
  801fee:	05 84 c0 81 00       	add    $0x81c084,%eax
  801ff3:	8b 10                	mov    (%eax),%edx
  801ff5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801ff8:	89 50 04             	mov    %edx,0x4(%eax)
  801ffb:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801ffe:	8b 40 04             	mov    0x4(%eax),%eax
  802001:	85 c0                	test   %eax,%eax
  802003:	74 14                	je     802019 <split_page_to_blocks+0xe4>
  802005:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802008:	c1 e0 04             	shl    $0x4,%eax
  80200b:	05 84 c0 81 00       	add    $0x81c084,%eax
  802010:	8b 00                	mov    (%eax),%eax
  802012:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802015:	89 10                	mov    %edx,(%eax)
  802017:	eb 11                	jmp    80202a <split_page_to_blocks+0xf5>
  802019:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80201c:	c1 e0 04             	shl    $0x4,%eax
  80201f:	8d 90 80 c0 81 00    	lea    0x81c080(%eax),%edx
  802025:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802028:	89 02                	mov    %eax,(%edx)
  80202a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80202d:	c1 e0 04             	shl    $0x4,%eax
  802030:	8d 90 84 c0 81 00    	lea    0x81c084(%eax),%edx
  802036:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802039:	89 02                	mov    %eax,(%edx)
  80203b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80203e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802044:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802047:	c1 e0 04             	shl    $0x4,%eax
  80204a:	05 8c c0 81 00       	add    $0x81c08c,%eax
  80204f:	8b 00                	mov    (%eax),%eax
  802051:	8d 50 01             	lea    0x1(%eax),%edx
  802054:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802057:	c1 e0 04             	shl    $0x4,%eax
  80205a:	05 8c c0 81 00       	add    $0x81c08c,%eax
  80205f:	89 10                	mov    %edx,(%eax)
	         break;
	     idx++;
	 }
	 // iterate over each blk and make and element of it by passing its address in blockElement pointer and save those in the list.
	 // starting from the page_va.
	 for (uint32 i = 0; i < blk_count; ++i) {
  802061:	ff 45 ec             	incl   -0x14(%ebp)
  802064:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802067:	39 45 ec             	cmp    %eax,-0x14(%ebp)
  80206a:	0f 82 4d ff ff ff    	jb     801fbd <split_page_to_blocks+0x88>
	     struct BlockElement *blk =(struct BlockElement*)(page_va + i * blk_size);
	     LIST_INSERT_TAIL(&freeBlockLists[idx],blk);
	 }
 }
  802070:	90                   	nop
  802071:	c9                   	leave  
  802072:	c3                   	ret    

00802073 <alloc_block>:

//===========================
// 3) ALLOCATE BLOCK:
//===========================
void *alloc_block(uint32 size)
{
  802073:	55                   	push   %ebp
  802074:	89 e5                	mov    %esp,%ebp
  802076:	83 ec 38             	sub    $0x38,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		assert(size <= DYN_ALLOC_MAX_BLOCK_SIZE);
  802079:	81 7d 08 00 08 00 00 	cmpl   $0x800,0x8(%ebp)
  802080:	76 19                	jbe    80209b <alloc_block+0x28>
  802082:	68 80 34 80 00       	push   $0x803480
  802087:	68 46 34 80 00       	push   $0x803446
  80208c:	68 8a 00 00 00       	push   $0x8a
  802091:	68 e3 33 80 00       	push   $0x8033e3
  802096:	e8 3c 07 00 00       	call   8027d7 <_panic>
	//==================================================================================
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #3 alloc_block
	//Your code is here
	//Comment the following line
	// get index in freeBlockList by size.
	uint32 idx = 0;
  80209b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int i = LOG2_MIN_SIZE; i <= LOG2_MAX_SIZE; ++i){
  8020a2:	c7 45 f0 03 00 00 00 	movl   $0x3,-0x10(%ebp)
  8020a9:	eb 19                	jmp    8020c4 <alloc_block+0x51>
		if((1 << i) >= size) break;
  8020ab:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8020ae:	ba 01 00 00 00       	mov    $0x1,%edx
  8020b3:	88 c1                	mov    %al,%cl
  8020b5:	d3 e2                	shl    %cl,%edx
  8020b7:	89 d0                	mov    %edx,%eax
  8020b9:	3b 45 08             	cmp    0x8(%ebp),%eax
  8020bc:	73 0e                	jae    8020cc <alloc_block+0x59>
		idx++;
  8020be:	ff 45 f4             	incl   -0xc(%ebp)
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #3 alloc_block
	//Your code is here
	//Comment the following line
	// get index in freeBlockList by size.
	uint32 idx = 0;
	for (int i = LOG2_MIN_SIZE; i <= LOG2_MAX_SIZE; ++i){
  8020c1:	ff 45 f0             	incl   -0x10(%ebp)
  8020c4:	83 7d f0 0b          	cmpl   $0xb,-0x10(%ebp)
  8020c8:	7e e1                	jle    8020ab <alloc_block+0x38>
  8020ca:	eb 01                	jmp    8020cd <alloc_block+0x5a>
		if((1 << i) >= size) break;
  8020cc:	90                   	nop
		idx++;
	}

	//case 1: the free block of the cur size is available.
	if (freeBlockLists[idx].size > 0) {
  8020cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020d0:	c1 e0 04             	shl    $0x4,%eax
  8020d3:	05 8c c0 81 00       	add    $0x81c08c,%eax
  8020d8:	8b 00                	mov    (%eax),%eax
  8020da:	85 c0                	test   %eax,%eax
  8020dc:	0f 84 df 00 00 00    	je     8021c1 <alloc_block+0x14e>

		// remove from the list and updat the pageInfoArr free blocks.
		// pop from the freeBlockList.
		struct BlockElement *blk = LIST_FIRST(&freeBlockLists[idx]);
  8020e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020e5:	c1 e0 04             	shl    $0x4,%eax
  8020e8:	05 80 c0 81 00       	add    $0x81c080,%eax
  8020ed:	8b 00                	mov    (%eax),%eax
  8020ef:	89 45 ec             	mov    %eax,-0x14(%ebp)
	    LIST_REMOVE(&freeBlockLists[idx], blk);
  8020f2:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8020f6:	75 17                	jne    80210f <alloc_block+0x9c>
  8020f8:	83 ec 04             	sub    $0x4,%esp
  8020fb:	68 a1 34 80 00       	push   $0x8034a1
  802100:	68 9e 00 00 00       	push   $0x9e
  802105:	68 e3 33 80 00       	push   $0x8033e3
  80210a:	e8 c8 06 00 00       	call   8027d7 <_panic>
  80210f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802112:	8b 00                	mov    (%eax),%eax
  802114:	85 c0                	test   %eax,%eax
  802116:	74 10                	je     802128 <alloc_block+0xb5>
  802118:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80211b:	8b 00                	mov    (%eax),%eax
  80211d:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802120:	8b 52 04             	mov    0x4(%edx),%edx
  802123:	89 50 04             	mov    %edx,0x4(%eax)
  802126:	eb 14                	jmp    80213c <alloc_block+0xc9>
  802128:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80212b:	8b 40 04             	mov    0x4(%eax),%eax
  80212e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802131:	c1 e2 04             	shl    $0x4,%edx
  802134:	81 c2 84 c0 81 00    	add    $0x81c084,%edx
  80213a:	89 02                	mov    %eax,(%edx)
  80213c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80213f:	8b 40 04             	mov    0x4(%eax),%eax
  802142:	85 c0                	test   %eax,%eax
  802144:	74 0f                	je     802155 <alloc_block+0xe2>
  802146:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802149:	8b 40 04             	mov    0x4(%eax),%eax
  80214c:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80214f:	8b 12                	mov    (%edx),%edx
  802151:	89 10                	mov    %edx,(%eax)
  802153:	eb 13                	jmp    802168 <alloc_block+0xf5>
  802155:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802158:	8b 00                	mov    (%eax),%eax
  80215a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80215d:	c1 e2 04             	shl    $0x4,%edx
  802160:	81 c2 80 c0 81 00    	add    $0x81c080,%edx
  802166:	89 02                	mov    %eax,(%edx)
  802168:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80216b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802171:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802174:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80217b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80217e:	c1 e0 04             	shl    $0x4,%eax
  802181:	05 8c c0 81 00       	add    $0x81c08c,%eax
  802186:	8b 00                	mov    (%eax),%eax
  802188:	8d 50 ff             	lea    -0x1(%eax),%edx
  80218b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80218e:	c1 e0 04             	shl    $0x4,%eax
  802191:	05 8c c0 81 00       	add    $0x81c08c,%eax
  802196:	89 10                	mov    %edx,(%eax)
	    // update pageBlockInfoArr
	    struct PageInfoElement *pageInfo = to_page_info((uint32)blk);
  802198:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80219b:	83 ec 0c             	sub    $0xc,%esp
  80219e:	50                   	push   %eax
  80219f:	e8 8b fb ff ff       	call   801d2f <to_page_info>
  8021a4:	83 c4 10             	add    $0x10,%esp
  8021a7:	89 45 e8             	mov    %eax,-0x18(%ebp)
	    pageInfo->num_of_free_blocks--;
  8021aa:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8021ad:	66 8b 40 0a          	mov    0xa(%eax),%ax
  8021b1:	48                   	dec    %eax
  8021b2:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8021b5:	66 89 42 0a          	mov    %ax,0xa(%edx)
	    return blk;
  8021b9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8021bc:	e9 bc 02 00 00       	jmp    80247d <alloc_block+0x40a>
	}else{ //case(2, 3): 2. no free blocks available in the freeblocklist but there is free pages.
				//3. no free blocks and no available freepages so search in higher block sizes.
		// case 2:
		if(freePagesList.size > 0){ //have free pages.
  8021c1:	a1 54 40 80 00       	mov    0x804054,%eax
  8021c6:	85 c0                	test   %eax,%eax
  8021c8:	0f 84 7d 02 00 00    	je     80244b <alloc_block+0x3d8>
			// get page to split and use from freepagesList.
			struct PageInfoElement *ptr_new_page = LIST_FIRST(&freePagesList);
  8021ce:	a1 48 40 80 00       	mov    0x804048,%eax
  8021d3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			LIST_REMOVE(&freePagesList, ptr_new_page);
  8021d6:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8021da:	75 17                	jne    8021f3 <alloc_block+0x180>
  8021dc:	83 ec 04             	sub    $0x4,%esp
  8021df:	68 a1 34 80 00       	push   $0x8034a1
  8021e4:	68 a9 00 00 00       	push   $0xa9
  8021e9:	68 e3 33 80 00       	push   $0x8033e3
  8021ee:	e8 e4 05 00 00       	call   8027d7 <_panic>
  8021f3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8021f6:	8b 00                	mov    (%eax),%eax
  8021f8:	85 c0                	test   %eax,%eax
  8021fa:	74 10                	je     80220c <alloc_block+0x199>
  8021fc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8021ff:	8b 00                	mov    (%eax),%eax
  802201:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802204:	8b 52 04             	mov    0x4(%edx),%edx
  802207:	89 50 04             	mov    %edx,0x4(%eax)
  80220a:	eb 0b                	jmp    802217 <alloc_block+0x1a4>
  80220c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80220f:	8b 40 04             	mov    0x4(%eax),%eax
  802212:	a3 4c 40 80 00       	mov    %eax,0x80404c
  802217:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80221a:	8b 40 04             	mov    0x4(%eax),%eax
  80221d:	85 c0                	test   %eax,%eax
  80221f:	74 0f                	je     802230 <alloc_block+0x1bd>
  802221:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802224:	8b 40 04             	mov    0x4(%eax),%eax
  802227:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80222a:	8b 12                	mov    (%edx),%edx
  80222c:	89 10                	mov    %edx,(%eax)
  80222e:	eb 0a                	jmp    80223a <alloc_block+0x1c7>
  802230:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802233:	8b 00                	mov    (%eax),%eax
  802235:	a3 48 40 80 00       	mov    %eax,0x804048
  80223a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80223d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802243:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802246:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80224d:	a1 54 40 80 00       	mov    0x804054,%eax
  802252:	48                   	dec    %eax
  802253:	a3 54 40 80 00       	mov    %eax,0x804054
			// from page to freeblockList by the pageInfo and the block size.
			split_page_to_blocks(1 << (idx + LOG2_MIN_SIZE), ptr_new_page);
  802258:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80225b:	83 c0 03             	add    $0x3,%eax
  80225e:	ba 01 00 00 00       	mov    $0x1,%edx
  802263:	88 c1                	mov    %al,%cl
  802265:	d3 e2                	shl    %cl,%edx
  802267:	89 d0                	mov    %edx,%eax
  802269:	83 ec 08             	sub    $0x8,%esp
  80226c:	ff 75 e4             	pushl  -0x1c(%ebp)
  80226f:	50                   	push   %eax
  802270:	e8 c0 fc ff ff       	call   801f35 <split_page_to_blocks>
  802275:	83 c4 10             	add    $0x10,%esp

			// remove from the list and updat the pageInfoArr free blocks.
			// pop from the freeBlockList.
			struct BlockElement *blk = LIST_FIRST(&freeBlockLists[idx]);
  802278:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80227b:	c1 e0 04             	shl    $0x4,%eax
  80227e:	05 80 c0 81 00       	add    $0x81c080,%eax
  802283:	8b 00                	mov    (%eax),%eax
  802285:	89 45 e0             	mov    %eax,-0x20(%ebp)
		    LIST_REMOVE(&freeBlockLists[idx], blk);
  802288:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80228c:	75 17                	jne    8022a5 <alloc_block+0x232>
  80228e:	83 ec 04             	sub    $0x4,%esp
  802291:	68 a1 34 80 00       	push   $0x8034a1
  802296:	68 b0 00 00 00       	push   $0xb0
  80229b:	68 e3 33 80 00       	push   $0x8033e3
  8022a0:	e8 32 05 00 00       	call   8027d7 <_panic>
  8022a5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8022a8:	8b 00                	mov    (%eax),%eax
  8022aa:	85 c0                	test   %eax,%eax
  8022ac:	74 10                	je     8022be <alloc_block+0x24b>
  8022ae:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8022b1:	8b 00                	mov    (%eax),%eax
  8022b3:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8022b6:	8b 52 04             	mov    0x4(%edx),%edx
  8022b9:	89 50 04             	mov    %edx,0x4(%eax)
  8022bc:	eb 14                	jmp    8022d2 <alloc_block+0x25f>
  8022be:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8022c1:	8b 40 04             	mov    0x4(%eax),%eax
  8022c4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8022c7:	c1 e2 04             	shl    $0x4,%edx
  8022ca:	81 c2 84 c0 81 00    	add    $0x81c084,%edx
  8022d0:	89 02                	mov    %eax,(%edx)
  8022d2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8022d5:	8b 40 04             	mov    0x4(%eax),%eax
  8022d8:	85 c0                	test   %eax,%eax
  8022da:	74 0f                	je     8022eb <alloc_block+0x278>
  8022dc:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8022df:	8b 40 04             	mov    0x4(%eax),%eax
  8022e2:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8022e5:	8b 12                	mov    (%edx),%edx
  8022e7:	89 10                	mov    %edx,(%eax)
  8022e9:	eb 13                	jmp    8022fe <alloc_block+0x28b>
  8022eb:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8022ee:	8b 00                	mov    (%eax),%eax
  8022f0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8022f3:	c1 e2 04             	shl    $0x4,%edx
  8022f6:	81 c2 80 c0 81 00    	add    $0x81c080,%edx
  8022fc:	89 02                	mov    %eax,(%edx)
  8022fe:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802301:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802307:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80230a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802311:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802314:	c1 e0 04             	shl    $0x4,%eax
  802317:	05 8c c0 81 00       	add    $0x81c08c,%eax
  80231c:	8b 00                	mov    (%eax),%eax
  80231e:	8d 50 ff             	lea    -0x1(%eax),%edx
  802321:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802324:	c1 e0 04             	shl    $0x4,%eax
  802327:	05 8c c0 81 00       	add    $0x81c08c,%eax
  80232c:	89 10                	mov    %edx,(%eax)
		    // update pageBlockInfoArr
		    struct PageInfoElement *pageInfo = to_page_info((uint32)blk);
  80232e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802331:	83 ec 0c             	sub    $0xc,%esp
  802334:	50                   	push   %eax
  802335:	e8 f5 f9 ff ff       	call   801d2f <to_page_info>
  80233a:	83 c4 10             	add    $0x10,%esp
  80233d:	89 45 dc             	mov    %eax,-0x24(%ebp)
		    pageInfo->num_of_free_blocks--;
  802340:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802343:	66 8b 40 0a          	mov    0xa(%eax),%ax
  802347:	48                   	dec    %eax
  802348:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80234b:	66 89 42 0a          	mov    %ax,0xa(%edx)
		    return blk;
  80234f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802352:	e9 26 01 00 00       	jmp    80247d <alloc_block+0x40a>
		}else{//case 3: no free block and no free page so iterate and try to find bigger size.
			// iterate over the list until finding available block
			while (idx <= (LOG2_MAX_SIZE - LOG2_MIN_SIZE) && freeBlockLists[idx].size == 0) {
				idx++;
  802357:	ff 45 f4             	incl   -0xc(%ebp)
				// found free block
				if(freeBlockLists[idx].size > 0){
  80235a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80235d:	c1 e0 04             	shl    $0x4,%eax
  802360:	05 8c c0 81 00       	add    $0x81c08c,%eax
  802365:	8b 00                	mov    (%eax),%eax
  802367:	85 c0                	test   %eax,%eax
  802369:	0f 84 dc 00 00 00    	je     80244b <alloc_block+0x3d8>
					// remove from the list and updat the pageInfoArr free blocks.
					// pop from the freeBlockList.
					struct BlockElement *blk = LIST_FIRST(&freeBlockLists[idx]);
  80236f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802372:	c1 e0 04             	shl    $0x4,%eax
  802375:	05 80 c0 81 00       	add    $0x81c080,%eax
  80237a:	8b 00                	mov    (%eax),%eax
  80237c:	89 45 d8             	mov    %eax,-0x28(%ebp)
				    LIST_REMOVE(&freeBlockLists[idx], blk);
  80237f:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  802383:	75 17                	jne    80239c <alloc_block+0x329>
  802385:	83 ec 04             	sub    $0x4,%esp
  802388:	68 a1 34 80 00       	push   $0x8034a1
  80238d:	68 be 00 00 00       	push   $0xbe
  802392:	68 e3 33 80 00       	push   $0x8033e3
  802397:	e8 3b 04 00 00       	call   8027d7 <_panic>
  80239c:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80239f:	8b 00                	mov    (%eax),%eax
  8023a1:	85 c0                	test   %eax,%eax
  8023a3:	74 10                	je     8023b5 <alloc_block+0x342>
  8023a5:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8023a8:	8b 00                	mov    (%eax),%eax
  8023aa:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8023ad:	8b 52 04             	mov    0x4(%edx),%edx
  8023b0:	89 50 04             	mov    %edx,0x4(%eax)
  8023b3:	eb 14                	jmp    8023c9 <alloc_block+0x356>
  8023b5:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8023b8:	8b 40 04             	mov    0x4(%eax),%eax
  8023bb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8023be:	c1 e2 04             	shl    $0x4,%edx
  8023c1:	81 c2 84 c0 81 00    	add    $0x81c084,%edx
  8023c7:	89 02                	mov    %eax,(%edx)
  8023c9:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8023cc:	8b 40 04             	mov    0x4(%eax),%eax
  8023cf:	85 c0                	test   %eax,%eax
  8023d1:	74 0f                	je     8023e2 <alloc_block+0x36f>
  8023d3:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8023d6:	8b 40 04             	mov    0x4(%eax),%eax
  8023d9:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8023dc:	8b 12                	mov    (%edx),%edx
  8023de:	89 10                	mov    %edx,(%eax)
  8023e0:	eb 13                	jmp    8023f5 <alloc_block+0x382>
  8023e2:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8023e5:	8b 00                	mov    (%eax),%eax
  8023e7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8023ea:	c1 e2 04             	shl    $0x4,%edx
  8023ed:	81 c2 80 c0 81 00    	add    $0x81c080,%edx
  8023f3:	89 02                	mov    %eax,(%edx)
  8023f5:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8023f8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8023fe:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802401:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802408:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80240b:	c1 e0 04             	shl    $0x4,%eax
  80240e:	05 8c c0 81 00       	add    $0x81c08c,%eax
  802413:	8b 00                	mov    (%eax),%eax
  802415:	8d 50 ff             	lea    -0x1(%eax),%edx
  802418:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80241b:	c1 e0 04             	shl    $0x4,%eax
  80241e:	05 8c c0 81 00       	add    $0x81c08c,%eax
  802423:	89 10                	mov    %edx,(%eax)
				    // update pageBlockInfoArr
				    struct PageInfoElement *pageInfo = to_page_info((uint32)blk);
  802425:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802428:	83 ec 0c             	sub    $0xc,%esp
  80242b:	50                   	push   %eax
  80242c:	e8 fe f8 ff ff       	call   801d2f <to_page_info>
  802431:	83 c4 10             	add    $0x10,%esp
  802434:	89 45 d4             	mov    %eax,-0x2c(%ebp)
				    pageInfo->num_of_free_blocks--;
  802437:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80243a:	66 8b 40 0a          	mov    0xa(%eax),%ax
  80243e:	48                   	dec    %eax
  80243f:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  802442:	66 89 42 0a          	mov    %ax,0xa(%edx)
				    return blk;
  802446:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802449:	eb 32                	jmp    80247d <alloc_block+0x40a>
		    struct PageInfoElement *pageInfo = to_page_info((uint32)blk);
		    pageInfo->num_of_free_blocks--;
		    return blk;
		}else{//case 3: no free block and no free page so iterate and try to find bigger size.
			// iterate over the list until finding available block
			while (idx <= (LOG2_MAX_SIZE - LOG2_MIN_SIZE) && freeBlockLists[idx].size == 0) {
  80244b:	83 7d f4 08          	cmpl   $0x8,-0xc(%ebp)
  80244f:	77 15                	ja     802466 <alloc_block+0x3f3>
  802451:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802454:	c1 e0 04             	shl    $0x4,%eax
  802457:	05 8c c0 81 00       	add    $0x81c08c,%eax
  80245c:	8b 00                	mov    (%eax),%eax
  80245e:	85 c0                	test   %eax,%eax
  802460:	0f 84 f1 fe ff ff    	je     802357 <alloc_block+0x2e4>
				}
			}
		}
	}
	//case4: no free blocks or pages.
	panic("no free blocks!");
  802466:	83 ec 04             	sub    $0x4,%esp
  802469:	68 bf 34 80 00       	push   $0x8034bf
  80246e:	68 c8 00 00 00       	push   $0xc8
  802473:	68 e3 33 80 00       	push   $0x8033e3
  802478:	e8 5a 03 00 00       	call   8027d7 <_panic>
	//panic("alloc_block() Not implemented yet");
	//TODO: [PROJECT'25.BONUS#1] DYNAMIC ALLOCATOR - block if no free block
	return NULL;
}
  80247d:	c9                   	leave  
  80247e:	c3                   	ret    

0080247f <free_block>:

//===========================
// [4] FREE BLOCK:
//===========================
void free_block(void *va)
{
  80247f:	55                   	push   %ebp
  802480:	89 e5                	mov    %esp,%ebp
  802482:	83 ec 38             	sub    $0x38,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		assert((uint32)va >= dynAllocStart && (uint32)va < dynAllocEnd);
  802485:	8b 55 08             	mov    0x8(%ebp),%edx
  802488:	a1 64 c0 81 00       	mov    0x81c064,%eax
  80248d:	39 c2                	cmp    %eax,%edx
  80248f:	72 0c                	jb     80249d <free_block+0x1e>
  802491:	8b 55 08             	mov    0x8(%ebp),%edx
  802494:	a1 40 40 80 00       	mov    0x804040,%eax
  802499:	39 c2                	cmp    %eax,%edx
  80249b:	72 19                	jb     8024b6 <free_block+0x37>
  80249d:	68 d0 34 80 00       	push   $0x8034d0
  8024a2:	68 46 34 80 00       	push   $0x803446
  8024a7:	68 d7 00 00 00       	push   $0xd7
  8024ac:	68 e3 33 80 00       	push   $0x8033e3
  8024b1:	e8 21 03 00 00       	call   8027d7 <_panic>
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #4 free_block
	//Your code is here
	//Comment the following line
	// va of a piece in memory to free so:
	// 1. get its page, and make blk with this address to be put in the freeBlockList.
	struct BlockElement* blk_to_free = (struct BlockElement*)va;
  8024b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8024b9:	89 45 e8             	mov    %eax,-0x18(%ebp)
	struct PageInfoElement *pageInfo = to_page_info((uint32)va);
  8024bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8024bf:	83 ec 0c             	sub    $0xc,%esp
  8024c2:	50                   	push   %eax
  8024c3:	e8 67 f8 ff ff       	call   801d2f <to_page_info>
  8024c8:	83 c4 10             	add    $0x10,%esp
  8024cb:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	uint32 blk_size = pageInfo->block_size;
  8024ce:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8024d1:	8b 40 08             	mov    0x8(%eax),%eax
  8024d4:	0f b7 c0             	movzwl %ax,%eax
  8024d7:	89 45 e0             	mov    %eax,-0x20(%ebp)

	// its index in the freeBlocklist.
	int idx = 0;
  8024da:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int i = LOG2_MIN_SIZE; i <= LOG2_MAX_SIZE; i++) {
  8024e1:	c7 45 f0 03 00 00 00 	movl   $0x3,-0x10(%ebp)
  8024e8:	eb 19                	jmp    802503 <free_block+0x84>
	    if ((1 << i) == blk_size)
  8024ea:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024ed:	ba 01 00 00 00       	mov    $0x1,%edx
  8024f2:	88 c1                	mov    %al,%cl
  8024f4:	d3 e2                	shl    %cl,%edx
  8024f6:	89 d0                	mov    %edx,%eax
  8024f8:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8024fb:	74 0e                	je     80250b <free_block+0x8c>
	        break;
	    idx++;
  8024fd:	ff 45 f4             	incl   -0xc(%ebp)
	struct PageInfoElement *pageInfo = to_page_info((uint32)va);
	uint32 blk_size = pageInfo->block_size;

	// its index in the freeBlocklist.
	int idx = 0;
	for (int i = LOG2_MIN_SIZE; i <= LOG2_MAX_SIZE; i++) {
  802500:	ff 45 f0             	incl   -0x10(%ebp)
  802503:	83 7d f0 0b          	cmpl   $0xb,-0x10(%ebp)
  802507:	7e e1                	jle    8024ea <free_block+0x6b>
  802509:	eb 01                	jmp    80250c <free_block+0x8d>
	    if ((1 << i) == blk_size)
	        break;
  80250b:	90                   	nop
	    idx++;
	}

	pageInfo->num_of_free_blocks++;
  80250c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80250f:	66 8b 40 0a          	mov    0xa(%eax),%ax
  802513:	40                   	inc    %eax
  802514:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802517:	66 89 42 0a          	mov    %ax,0xa(%edx)
	LIST_INSERT_TAIL(&freeBlockLists[idx], blk_to_free);
  80251b:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80251f:	75 17                	jne    802538 <free_block+0xb9>
  802521:	83 ec 04             	sub    $0x4,%esp
  802524:	68 5c 34 80 00       	push   $0x80345c
  802529:	68 ee 00 00 00       	push   $0xee
  80252e:	68 e3 33 80 00       	push   $0x8033e3
  802533:	e8 9f 02 00 00       	call   8027d7 <_panic>
  802538:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80253b:	c1 e0 04             	shl    $0x4,%eax
  80253e:	05 84 c0 81 00       	add    $0x81c084,%eax
  802543:	8b 10                	mov    (%eax),%edx
  802545:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802548:	89 50 04             	mov    %edx,0x4(%eax)
  80254b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80254e:	8b 40 04             	mov    0x4(%eax),%eax
  802551:	85 c0                	test   %eax,%eax
  802553:	74 14                	je     802569 <free_block+0xea>
  802555:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802558:	c1 e0 04             	shl    $0x4,%eax
  80255b:	05 84 c0 81 00       	add    $0x81c084,%eax
  802560:	8b 00                	mov    (%eax),%eax
  802562:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802565:	89 10                	mov    %edx,(%eax)
  802567:	eb 11                	jmp    80257a <free_block+0xfb>
  802569:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80256c:	c1 e0 04             	shl    $0x4,%eax
  80256f:	8d 90 80 c0 81 00    	lea    0x81c080(%eax),%edx
  802575:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802578:	89 02                	mov    %eax,(%edx)
  80257a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80257d:	c1 e0 04             	shl    $0x4,%eax
  802580:	8d 90 84 c0 81 00    	lea    0x81c084(%eax),%edx
  802586:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802589:	89 02                	mov    %eax,(%edx)
  80258b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80258e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802594:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802597:	c1 e0 04             	shl    $0x4,%eax
  80259a:	05 8c c0 81 00       	add    $0x81c08c,%eax
  80259f:	8b 00                	mov    (%eax),%eax
  8025a1:	8d 50 01             	lea    0x1(%eax),%edx
  8025a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025a7:	c1 e0 04             	shl    $0x4,%eax
  8025aa:	05 8c c0 81 00       	add    $0x81c08c,%eax
  8025af:	89 10                	mov    %edx,(%eax)

	// now, case 1: the page all blocks are freed so you free the page.
	int blk_count = PAGE_SIZE / blk_size;
  8025b1:	b8 00 10 00 00       	mov    $0x1000,%eax
  8025b6:	ba 00 00 00 00       	mov    $0x0,%edx
  8025bb:	f7 75 e0             	divl   -0x20(%ebp)
  8025be:	89 45 dc             	mov    %eax,-0x24(%ebp)
	// the blk count in the page is same as number fo free blocks free up the page.
	if (pageInfo->num_of_free_blocks == blk_count) {
  8025c1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8025c4:	66 8b 40 0a          	mov    0xa(%eax),%ax
  8025c8:	0f b7 c0             	movzwl %ax,%eax
  8025cb:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  8025ce:	0f 85 70 01 00 00    	jne    802744 <free_block+0x2c5>
		uint32 page_va = to_page_va(pageInfo);
  8025d4:	83 ec 0c             	sub    $0xc,%esp
  8025d7:	ff 75 e4             	pushl  -0x1c(%ebp)
  8025da:	e8 de f6 ff ff       	call   801cbd <to_page_va>
  8025df:	83 c4 10             	add    $0x10,%esp
  8025e2:	89 45 d8             	mov    %eax,-0x28(%ebp)
		// remove all blk in the freeBlockList.
		for (uint32 off = 0; off < PAGE_SIZE; off += blk_size) {
  8025e5:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  8025ec:	e9 b7 00 00 00       	jmp    8026a8 <free_block+0x229>
			struct BlockElement *blk = (struct BlockElement*)(page_va + off);
  8025f1:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8025f4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8025f7:	01 d0                	add    %edx,%eax
  8025f9:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			LIST_REMOVE(&freeBlockLists[idx], blk);
  8025fc:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  802600:	75 17                	jne    802619 <free_block+0x19a>
  802602:	83 ec 04             	sub    $0x4,%esp
  802605:	68 a1 34 80 00       	push   $0x8034a1
  80260a:	68 f8 00 00 00       	push   $0xf8
  80260f:	68 e3 33 80 00       	push   $0x8033e3
  802614:	e8 be 01 00 00       	call   8027d7 <_panic>
  802619:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80261c:	8b 00                	mov    (%eax),%eax
  80261e:	85 c0                	test   %eax,%eax
  802620:	74 10                	je     802632 <free_block+0x1b3>
  802622:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802625:	8b 00                	mov    (%eax),%eax
  802627:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  80262a:	8b 52 04             	mov    0x4(%edx),%edx
  80262d:	89 50 04             	mov    %edx,0x4(%eax)
  802630:	eb 14                	jmp    802646 <free_block+0x1c7>
  802632:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802635:	8b 40 04             	mov    0x4(%eax),%eax
  802638:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80263b:	c1 e2 04             	shl    $0x4,%edx
  80263e:	81 c2 84 c0 81 00    	add    $0x81c084,%edx
  802644:	89 02                	mov    %eax,(%edx)
  802646:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802649:	8b 40 04             	mov    0x4(%eax),%eax
  80264c:	85 c0                	test   %eax,%eax
  80264e:	74 0f                	je     80265f <free_block+0x1e0>
  802650:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802653:	8b 40 04             	mov    0x4(%eax),%eax
  802656:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  802659:	8b 12                	mov    (%edx),%edx
  80265b:	89 10                	mov    %edx,(%eax)
  80265d:	eb 13                	jmp    802672 <free_block+0x1f3>
  80265f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802662:	8b 00                	mov    (%eax),%eax
  802664:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802667:	c1 e2 04             	shl    $0x4,%edx
  80266a:	81 c2 80 c0 81 00    	add    $0x81c080,%edx
  802670:	89 02                	mov    %eax,(%edx)
  802672:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802675:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80267b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80267e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802685:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802688:	c1 e0 04             	shl    $0x4,%eax
  80268b:	05 8c c0 81 00       	add    $0x81c08c,%eax
  802690:	8b 00                	mov    (%eax),%eax
  802692:	8d 50 ff             	lea    -0x1(%eax),%edx
  802695:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802698:	c1 e0 04             	shl    $0x4,%eax
  80269b:	05 8c c0 81 00       	add    $0x81c08c,%eax
  8026a0:	89 10                	mov    %edx,(%eax)
	int blk_count = PAGE_SIZE / blk_size;
	// the blk count in the page is same as number fo free blocks free up the page.
	if (pageInfo->num_of_free_blocks == blk_count) {
		uint32 page_va = to_page_va(pageInfo);
		// remove all blk in the freeBlockList.
		for (uint32 off = 0; off < PAGE_SIZE; off += blk_size) {
  8026a2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8026a5:	01 45 ec             	add    %eax,-0x14(%ebp)
  8026a8:	81 7d ec ff 0f 00 00 	cmpl   $0xfff,-0x14(%ebp)
  8026af:	0f 86 3c ff ff ff    	jbe    8025f1 <free_block+0x172>
			struct BlockElement *blk = (struct BlockElement*)(page_va + off);
			LIST_REMOVE(&freeBlockLists[idx], blk);
		}
		// reset page info.
		pageInfo->block_size = 0;
  8026b5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8026b8:	66 c7 40 08 00 00    	movw   $0x0,0x8(%eax)
		pageInfo->num_of_free_blocks = 0;
  8026be:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8026c1:	66 c7 40 0a 00 00    	movw   $0x0,0xa(%eax)
		// add it to the available pages.
		LIST_INSERT_TAIL(&freePagesList, pageInfo);
  8026c7:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8026cb:	75 17                	jne    8026e4 <free_block+0x265>
  8026cd:	83 ec 04             	sub    $0x4,%esp
  8026d0:	68 5c 34 80 00       	push   $0x80345c
  8026d5:	68 fe 00 00 00       	push   $0xfe
  8026da:	68 e3 33 80 00       	push   $0x8033e3
  8026df:	e8 f3 00 00 00       	call   8027d7 <_panic>
  8026e4:	8b 15 4c 40 80 00    	mov    0x80404c,%edx
  8026ea:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8026ed:	89 50 04             	mov    %edx,0x4(%eax)
  8026f0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8026f3:	8b 40 04             	mov    0x4(%eax),%eax
  8026f6:	85 c0                	test   %eax,%eax
  8026f8:	74 0c                	je     802706 <free_block+0x287>
  8026fa:	a1 4c 40 80 00       	mov    0x80404c,%eax
  8026ff:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802702:	89 10                	mov    %edx,(%eax)
  802704:	eb 08                	jmp    80270e <free_block+0x28f>
  802706:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802709:	a3 48 40 80 00       	mov    %eax,0x804048
  80270e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802711:	a3 4c 40 80 00       	mov    %eax,0x80404c
  802716:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802719:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80271f:	a1 54 40 80 00       	mov    0x804054,%eax
  802724:	40                   	inc    %eax
  802725:	a3 54 40 80 00       	mov    %eax,0x804054
		// make it available in memory.
		return_page((uint32 *)to_page_va(pageInfo));
  80272a:	83 ec 0c             	sub    $0xc,%esp
  80272d:	ff 75 e4             	pushl  -0x1c(%ebp)
  802730:	e8 88 f5 ff ff       	call   801cbd <to_page_va>
  802735:	83 c4 10             	add    $0x10,%esp
  802738:	83 ec 0c             	sub    $0xc,%esp
  80273b:	50                   	push   %eax
  80273c:	e8 b8 ee ff ff       	call   8015f9 <return_page>
  802741:	83 c4 10             	add    $0x10,%esp
	}
	//panic("free_block() Not implemented yet");
}
  802744:	90                   	nop
  802745:	c9                   	leave  
  802746:	c3                   	ret    

00802747 <realloc_block>:

//===========================
// [1] REALLOCATE BLOCK:
//===========================
void *realloc_block(void* va, uint32 new_size)
{
  802747:	55                   	push   %ebp
  802748:	89 e5                	mov    %esp,%ebp
  80274a:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.BONUS#2] KERNEL REALLOC - realloc_block
	//Your code is here
	//Comment the following line
	panic("realloc_block() Not implemented yet");
  80274d:	83 ec 04             	sub    $0x4,%esp
  802750:	68 08 35 80 00       	push   $0x803508
  802755:	68 11 01 00 00       	push   $0x111
  80275a:	68 e3 33 80 00       	push   $0x8033e3
  80275f:	e8 73 00 00 00       	call   8027d7 <_panic>

00802764 <create_semaphore>:
// User-level Semaphore

#include "inc/lib.h"

struct semaphore create_semaphore(char *semaphoreName, uint32 value)
{
  802764:	55                   	push   %ebp
  802765:	89 e5                	mov    %esp,%ebp
  802767:	83 ec 08             	sub    $0x8,%esp
	panic("create_semaphore() is not implemented yet...!!");
  80276a:	83 ec 04             	sub    $0x4,%esp
  80276d:	68 2c 35 80 00       	push   $0x80352c
  802772:	6a 07                	push   $0x7
  802774:	68 5b 35 80 00       	push   $0x80355b
  802779:	e8 59 00 00 00       	call   8027d7 <_panic>

0080277e <get_semaphore>:
}
struct semaphore get_semaphore(int32 ownerEnvID, char* semaphoreName)
{
  80277e:	55                   	push   %ebp
  80277f:	89 e5                	mov    %esp,%ebp
  802781:	83 ec 08             	sub    $0x8,%esp
	panic("get_semaphore() is not implemented yet...!!");
  802784:	83 ec 04             	sub    $0x4,%esp
  802787:	68 6c 35 80 00       	push   $0x80356c
  80278c:	6a 0b                	push   $0xb
  80278e:	68 5b 35 80 00       	push   $0x80355b
  802793:	e8 3f 00 00 00       	call   8027d7 <_panic>

00802798 <wait_semaphore>:
}

void wait_semaphore(struct semaphore sem)
{
  802798:	55                   	push   %ebp
  802799:	89 e5                	mov    %esp,%ebp
  80279b:	83 ec 08             	sub    $0x8,%esp
	panic("wait_semaphore() is not implemented yet...!!");
  80279e:	83 ec 04             	sub    $0x4,%esp
  8027a1:	68 98 35 80 00       	push   $0x803598
  8027a6:	6a 10                	push   $0x10
  8027a8:	68 5b 35 80 00       	push   $0x80355b
  8027ad:	e8 25 00 00 00       	call   8027d7 <_panic>

008027b2 <signal_semaphore>:
}

void signal_semaphore(struct semaphore sem)
{
  8027b2:	55                   	push   %ebp
  8027b3:	89 e5                	mov    %esp,%ebp
  8027b5:	83 ec 08             	sub    $0x8,%esp
	panic("signal_semaphore() is not implemented yet...!!");
  8027b8:	83 ec 04             	sub    $0x4,%esp
  8027bb:	68 c8 35 80 00       	push   $0x8035c8
  8027c0:	6a 15                	push   $0x15
  8027c2:	68 5b 35 80 00       	push   $0x80355b
  8027c7:	e8 0b 00 00 00       	call   8027d7 <_panic>

008027cc <semaphore_count>:
}

int semaphore_count(struct semaphore sem)
{
  8027cc:	55                   	push   %ebp
  8027cd:	89 e5                	mov    %esp,%ebp
	return sem.semdata->count;
  8027cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8027d2:	8b 40 10             	mov    0x10(%eax),%eax
}
  8027d5:	5d                   	pop    %ebp
  8027d6:	c3                   	ret    

008027d7 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  8027d7:	55                   	push   %ebp
  8027d8:	89 e5                	mov    %esp,%ebp
  8027da:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  8027dd:	8d 45 10             	lea    0x10(%ebp),%eax
  8027e0:	83 c0 04             	add    $0x4,%eax
  8027e3:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  8027e6:	a1 1c c1 81 00       	mov    0x81c11c,%eax
  8027eb:	85 c0                	test   %eax,%eax
  8027ed:	74 16                	je     802805 <_panic+0x2e>
		cprintf("%s: ", argv0);
  8027ef:	a1 1c c1 81 00       	mov    0x81c11c,%eax
  8027f4:	83 ec 08             	sub    $0x8,%esp
  8027f7:	50                   	push   %eax
  8027f8:	68 f8 35 80 00       	push   $0x8035f8
  8027fd:	e8 75 de ff ff       	call   800677 <cprintf>
  802802:	83 c4 10             	add    $0x10,%esp
	cprintf_colored(TEXT_PANIC_CLR, "user [EVAL_FINAL]panic in %s at %s:%d: ", binaryname, file, line);
  802805:	a1 04 40 80 00       	mov    0x804004,%eax
  80280a:	83 ec 0c             	sub    $0xc,%esp
  80280d:	ff 75 0c             	pushl  0xc(%ebp)
  802810:	ff 75 08             	pushl  0x8(%ebp)
  802813:	50                   	push   %eax
  802814:	68 00 36 80 00       	push   $0x803600
  802819:	6a 74                	push   $0x74
  80281b:	e8 84 de ff ff       	call   8006a4 <cprintf_colored>
  802820:	83 c4 20             	add    $0x20,%esp
	vcprintf(fmt, ap);
  802823:	8b 45 10             	mov    0x10(%ebp),%eax
  802826:	83 ec 08             	sub    $0x8,%esp
  802829:	ff 75 f4             	pushl  -0xc(%ebp)
  80282c:	50                   	push   %eax
  80282d:	e8 d6 dd ff ff       	call   800608 <vcprintf>
  802832:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  802835:	83 ec 08             	sub    $0x8,%esp
  802838:	6a 00                	push   $0x0
  80283a:	68 28 36 80 00       	push   $0x803628
  80283f:	e8 c4 dd ff ff       	call   800608 <vcprintf>
  802844:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  802847:	e8 3d dd ff ff       	call   800589 <exit>

	// should not return here
	while (1) ;
  80284c:	eb fe                	jmp    80284c <_panic+0x75>

0080284e <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  80284e:	55                   	push   %ebp
  80284f:	89 e5                	mov    %esp,%ebp
  802851:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  802854:	a1 20 40 80 00       	mov    0x804020,%eax
  802859:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  80285f:	8b 45 0c             	mov    0xc(%ebp),%eax
  802862:	39 c2                	cmp    %eax,%edx
  802864:	74 14                	je     80287a <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  802866:	83 ec 04             	sub    $0x4,%esp
  802869:	68 2c 36 80 00       	push   $0x80362c
  80286e:	6a 26                	push   $0x26
  802870:	68 78 36 80 00       	push   $0x803678
  802875:	e8 5d ff ff ff       	call   8027d7 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  80287a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  802881:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  802888:	e9 c5 00 00 00       	jmp    802952 <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  80288d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802890:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  802897:	8b 45 08             	mov    0x8(%ebp),%eax
  80289a:	01 d0                	add    %edx,%eax
  80289c:	8b 00                	mov    (%eax),%eax
  80289e:	85 c0                	test   %eax,%eax
  8028a0:	75 08                	jne    8028aa <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  8028a2:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  8028a5:	e9 a5 00 00 00       	jmp    80294f <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  8028aa:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8028b1:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  8028b8:	eb 69                	jmp    802923 <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  8028ba:	a1 20 40 80 00       	mov    0x804020,%eax
  8028bf:	8b 88 90 05 00 00    	mov    0x590(%eax),%ecx
  8028c5:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8028c8:	89 d0                	mov    %edx,%eax
  8028ca:	01 c0                	add    %eax,%eax
  8028cc:	01 d0                	add    %edx,%eax
  8028ce:	c1 e0 03             	shl    $0x3,%eax
  8028d1:	01 c8                	add    %ecx,%eax
  8028d3:	8a 40 04             	mov    0x4(%eax),%al
  8028d6:	84 c0                	test   %al,%al
  8028d8:	75 46                	jne    802920 <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8028da:	a1 20 40 80 00       	mov    0x804020,%eax
  8028df:	8b 88 90 05 00 00    	mov    0x590(%eax),%ecx
  8028e5:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8028e8:	89 d0                	mov    %edx,%eax
  8028ea:	01 c0                	add    %eax,%eax
  8028ec:	01 d0                	add    %edx,%eax
  8028ee:	c1 e0 03             	shl    $0x3,%eax
  8028f1:	01 c8                	add    %ecx,%eax
  8028f3:	8b 00                	mov    (%eax),%eax
  8028f5:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8028f8:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8028fb:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  802900:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  802902:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802905:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  80290c:	8b 45 08             	mov    0x8(%ebp),%eax
  80290f:	01 c8                	add    %ecx,%eax
  802911:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  802913:	39 c2                	cmp    %eax,%edx
  802915:	75 09                	jne    802920 <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  802917:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  80291e:	eb 15                	jmp    802935 <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  802920:	ff 45 e8             	incl   -0x18(%ebp)
  802923:	a1 20 40 80 00       	mov    0x804020,%eax
  802928:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  80292e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802931:	39 c2                	cmp    %eax,%edx
  802933:	77 85                	ja     8028ba <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  802935:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802939:	75 14                	jne    80294f <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  80293b:	83 ec 04             	sub    $0x4,%esp
  80293e:	68 84 36 80 00       	push   $0x803684
  802943:	6a 3a                	push   $0x3a
  802945:	68 78 36 80 00       	push   $0x803678
  80294a:	e8 88 fe ff ff       	call   8027d7 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  80294f:	ff 45 f0             	incl   -0x10(%ebp)
  802952:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802955:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802958:	0f 8c 2f ff ff ff    	jl     80288d <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  80295e:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  802965:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  80296c:	eb 26                	jmp    802994 <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  80296e:	a1 20 40 80 00       	mov    0x804020,%eax
  802973:	8b 88 90 05 00 00    	mov    0x590(%eax),%ecx
  802979:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80297c:	89 d0                	mov    %edx,%eax
  80297e:	01 c0                	add    %eax,%eax
  802980:	01 d0                	add    %edx,%eax
  802982:	c1 e0 03             	shl    $0x3,%eax
  802985:	01 c8                	add    %ecx,%eax
  802987:	8a 40 04             	mov    0x4(%eax),%al
  80298a:	3c 01                	cmp    $0x1,%al
  80298c:	75 03                	jne    802991 <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  80298e:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  802991:	ff 45 e0             	incl   -0x20(%ebp)
  802994:	a1 20 40 80 00       	mov    0x804020,%eax
  802999:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  80299f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8029a2:	39 c2                	cmp    %eax,%edx
  8029a4:	77 c8                	ja     80296e <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  8029a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029a9:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8029ac:	74 14                	je     8029c2 <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  8029ae:	83 ec 04             	sub    $0x4,%esp
  8029b1:	68 d8 36 80 00       	push   $0x8036d8
  8029b6:	6a 44                	push   $0x44
  8029b8:	68 78 36 80 00       	push   $0x803678
  8029bd:	e8 15 fe ff ff       	call   8027d7 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  8029c2:	90                   	nop
  8029c3:	c9                   	leave  
  8029c4:	c3                   	ret    
  8029c5:	66 90                	xchg   %ax,%ax
  8029c7:	90                   	nop

008029c8 <__udivdi3>:
  8029c8:	55                   	push   %ebp
  8029c9:	57                   	push   %edi
  8029ca:	56                   	push   %esi
  8029cb:	53                   	push   %ebx
  8029cc:	83 ec 1c             	sub    $0x1c,%esp
  8029cf:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  8029d3:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  8029d7:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8029db:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8029df:	89 ca                	mov    %ecx,%edx
  8029e1:	89 f8                	mov    %edi,%eax
  8029e3:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  8029e7:	85 f6                	test   %esi,%esi
  8029e9:	75 2d                	jne    802a18 <__udivdi3+0x50>
  8029eb:	39 cf                	cmp    %ecx,%edi
  8029ed:	77 65                	ja     802a54 <__udivdi3+0x8c>
  8029ef:	89 fd                	mov    %edi,%ebp
  8029f1:	85 ff                	test   %edi,%edi
  8029f3:	75 0b                	jne    802a00 <__udivdi3+0x38>
  8029f5:	b8 01 00 00 00       	mov    $0x1,%eax
  8029fa:	31 d2                	xor    %edx,%edx
  8029fc:	f7 f7                	div    %edi
  8029fe:	89 c5                	mov    %eax,%ebp
  802a00:	31 d2                	xor    %edx,%edx
  802a02:	89 c8                	mov    %ecx,%eax
  802a04:	f7 f5                	div    %ebp
  802a06:	89 c1                	mov    %eax,%ecx
  802a08:	89 d8                	mov    %ebx,%eax
  802a0a:	f7 f5                	div    %ebp
  802a0c:	89 cf                	mov    %ecx,%edi
  802a0e:	89 fa                	mov    %edi,%edx
  802a10:	83 c4 1c             	add    $0x1c,%esp
  802a13:	5b                   	pop    %ebx
  802a14:	5e                   	pop    %esi
  802a15:	5f                   	pop    %edi
  802a16:	5d                   	pop    %ebp
  802a17:	c3                   	ret    
  802a18:	39 ce                	cmp    %ecx,%esi
  802a1a:	77 28                	ja     802a44 <__udivdi3+0x7c>
  802a1c:	0f bd fe             	bsr    %esi,%edi
  802a1f:	83 f7 1f             	xor    $0x1f,%edi
  802a22:	75 40                	jne    802a64 <__udivdi3+0x9c>
  802a24:	39 ce                	cmp    %ecx,%esi
  802a26:	72 0a                	jb     802a32 <__udivdi3+0x6a>
  802a28:	3b 44 24 08          	cmp    0x8(%esp),%eax
  802a2c:	0f 87 9e 00 00 00    	ja     802ad0 <__udivdi3+0x108>
  802a32:	b8 01 00 00 00       	mov    $0x1,%eax
  802a37:	89 fa                	mov    %edi,%edx
  802a39:	83 c4 1c             	add    $0x1c,%esp
  802a3c:	5b                   	pop    %ebx
  802a3d:	5e                   	pop    %esi
  802a3e:	5f                   	pop    %edi
  802a3f:	5d                   	pop    %ebp
  802a40:	c3                   	ret    
  802a41:	8d 76 00             	lea    0x0(%esi),%esi
  802a44:	31 ff                	xor    %edi,%edi
  802a46:	31 c0                	xor    %eax,%eax
  802a48:	89 fa                	mov    %edi,%edx
  802a4a:	83 c4 1c             	add    $0x1c,%esp
  802a4d:	5b                   	pop    %ebx
  802a4e:	5e                   	pop    %esi
  802a4f:	5f                   	pop    %edi
  802a50:	5d                   	pop    %ebp
  802a51:	c3                   	ret    
  802a52:	66 90                	xchg   %ax,%ax
  802a54:	89 d8                	mov    %ebx,%eax
  802a56:	f7 f7                	div    %edi
  802a58:	31 ff                	xor    %edi,%edi
  802a5a:	89 fa                	mov    %edi,%edx
  802a5c:	83 c4 1c             	add    $0x1c,%esp
  802a5f:	5b                   	pop    %ebx
  802a60:	5e                   	pop    %esi
  802a61:	5f                   	pop    %edi
  802a62:	5d                   	pop    %ebp
  802a63:	c3                   	ret    
  802a64:	bd 20 00 00 00       	mov    $0x20,%ebp
  802a69:	89 eb                	mov    %ebp,%ebx
  802a6b:	29 fb                	sub    %edi,%ebx
  802a6d:	89 f9                	mov    %edi,%ecx
  802a6f:	d3 e6                	shl    %cl,%esi
  802a71:	89 c5                	mov    %eax,%ebp
  802a73:	88 d9                	mov    %bl,%cl
  802a75:	d3 ed                	shr    %cl,%ebp
  802a77:	89 e9                	mov    %ebp,%ecx
  802a79:	09 f1                	or     %esi,%ecx
  802a7b:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  802a7f:	89 f9                	mov    %edi,%ecx
  802a81:	d3 e0                	shl    %cl,%eax
  802a83:	89 c5                	mov    %eax,%ebp
  802a85:	89 d6                	mov    %edx,%esi
  802a87:	88 d9                	mov    %bl,%cl
  802a89:	d3 ee                	shr    %cl,%esi
  802a8b:	89 f9                	mov    %edi,%ecx
  802a8d:	d3 e2                	shl    %cl,%edx
  802a8f:	8b 44 24 08          	mov    0x8(%esp),%eax
  802a93:	88 d9                	mov    %bl,%cl
  802a95:	d3 e8                	shr    %cl,%eax
  802a97:	09 c2                	or     %eax,%edx
  802a99:	89 d0                	mov    %edx,%eax
  802a9b:	89 f2                	mov    %esi,%edx
  802a9d:	f7 74 24 0c          	divl   0xc(%esp)
  802aa1:	89 d6                	mov    %edx,%esi
  802aa3:	89 c3                	mov    %eax,%ebx
  802aa5:	f7 e5                	mul    %ebp
  802aa7:	39 d6                	cmp    %edx,%esi
  802aa9:	72 19                	jb     802ac4 <__udivdi3+0xfc>
  802aab:	74 0b                	je     802ab8 <__udivdi3+0xf0>
  802aad:	89 d8                	mov    %ebx,%eax
  802aaf:	31 ff                	xor    %edi,%edi
  802ab1:	e9 58 ff ff ff       	jmp    802a0e <__udivdi3+0x46>
  802ab6:	66 90                	xchg   %ax,%ax
  802ab8:	8b 54 24 08          	mov    0x8(%esp),%edx
  802abc:	89 f9                	mov    %edi,%ecx
  802abe:	d3 e2                	shl    %cl,%edx
  802ac0:	39 c2                	cmp    %eax,%edx
  802ac2:	73 e9                	jae    802aad <__udivdi3+0xe5>
  802ac4:	8d 43 ff             	lea    -0x1(%ebx),%eax
  802ac7:	31 ff                	xor    %edi,%edi
  802ac9:	e9 40 ff ff ff       	jmp    802a0e <__udivdi3+0x46>
  802ace:	66 90                	xchg   %ax,%ax
  802ad0:	31 c0                	xor    %eax,%eax
  802ad2:	e9 37 ff ff ff       	jmp    802a0e <__udivdi3+0x46>
  802ad7:	90                   	nop

00802ad8 <__umoddi3>:
  802ad8:	55                   	push   %ebp
  802ad9:	57                   	push   %edi
  802ada:	56                   	push   %esi
  802adb:	53                   	push   %ebx
  802adc:	83 ec 1c             	sub    $0x1c,%esp
  802adf:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  802ae3:	8b 74 24 34          	mov    0x34(%esp),%esi
  802ae7:	8b 7c 24 38          	mov    0x38(%esp),%edi
  802aeb:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  802aef:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802af3:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802af7:	89 f3                	mov    %esi,%ebx
  802af9:	89 fa                	mov    %edi,%edx
  802afb:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  802aff:	89 34 24             	mov    %esi,(%esp)
  802b02:	85 c0                	test   %eax,%eax
  802b04:	75 1a                	jne    802b20 <__umoddi3+0x48>
  802b06:	39 f7                	cmp    %esi,%edi
  802b08:	0f 86 a2 00 00 00    	jbe    802bb0 <__umoddi3+0xd8>
  802b0e:	89 c8                	mov    %ecx,%eax
  802b10:	89 f2                	mov    %esi,%edx
  802b12:	f7 f7                	div    %edi
  802b14:	89 d0                	mov    %edx,%eax
  802b16:	31 d2                	xor    %edx,%edx
  802b18:	83 c4 1c             	add    $0x1c,%esp
  802b1b:	5b                   	pop    %ebx
  802b1c:	5e                   	pop    %esi
  802b1d:	5f                   	pop    %edi
  802b1e:	5d                   	pop    %ebp
  802b1f:	c3                   	ret    
  802b20:	39 f0                	cmp    %esi,%eax
  802b22:	0f 87 ac 00 00 00    	ja     802bd4 <__umoddi3+0xfc>
  802b28:	0f bd e8             	bsr    %eax,%ebp
  802b2b:	83 f5 1f             	xor    $0x1f,%ebp
  802b2e:	0f 84 ac 00 00 00    	je     802be0 <__umoddi3+0x108>
  802b34:	bf 20 00 00 00       	mov    $0x20,%edi
  802b39:	29 ef                	sub    %ebp,%edi
  802b3b:	89 fe                	mov    %edi,%esi
  802b3d:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802b41:	89 e9                	mov    %ebp,%ecx
  802b43:	d3 e0                	shl    %cl,%eax
  802b45:	89 d7                	mov    %edx,%edi
  802b47:	89 f1                	mov    %esi,%ecx
  802b49:	d3 ef                	shr    %cl,%edi
  802b4b:	09 c7                	or     %eax,%edi
  802b4d:	89 e9                	mov    %ebp,%ecx
  802b4f:	d3 e2                	shl    %cl,%edx
  802b51:	89 14 24             	mov    %edx,(%esp)
  802b54:	89 d8                	mov    %ebx,%eax
  802b56:	d3 e0                	shl    %cl,%eax
  802b58:	89 c2                	mov    %eax,%edx
  802b5a:	8b 44 24 08          	mov    0x8(%esp),%eax
  802b5e:	d3 e0                	shl    %cl,%eax
  802b60:	89 44 24 04          	mov    %eax,0x4(%esp)
  802b64:	8b 44 24 08          	mov    0x8(%esp),%eax
  802b68:	89 f1                	mov    %esi,%ecx
  802b6a:	d3 e8                	shr    %cl,%eax
  802b6c:	09 d0                	or     %edx,%eax
  802b6e:	d3 eb                	shr    %cl,%ebx
  802b70:	89 da                	mov    %ebx,%edx
  802b72:	f7 f7                	div    %edi
  802b74:	89 d3                	mov    %edx,%ebx
  802b76:	f7 24 24             	mull   (%esp)
  802b79:	89 c6                	mov    %eax,%esi
  802b7b:	89 d1                	mov    %edx,%ecx
  802b7d:	39 d3                	cmp    %edx,%ebx
  802b7f:	0f 82 87 00 00 00    	jb     802c0c <__umoddi3+0x134>
  802b85:	0f 84 91 00 00 00    	je     802c1c <__umoddi3+0x144>
  802b8b:	8b 54 24 04          	mov    0x4(%esp),%edx
  802b8f:	29 f2                	sub    %esi,%edx
  802b91:	19 cb                	sbb    %ecx,%ebx
  802b93:	89 d8                	mov    %ebx,%eax
  802b95:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  802b99:	d3 e0                	shl    %cl,%eax
  802b9b:	89 e9                	mov    %ebp,%ecx
  802b9d:	d3 ea                	shr    %cl,%edx
  802b9f:	09 d0                	or     %edx,%eax
  802ba1:	89 e9                	mov    %ebp,%ecx
  802ba3:	d3 eb                	shr    %cl,%ebx
  802ba5:	89 da                	mov    %ebx,%edx
  802ba7:	83 c4 1c             	add    $0x1c,%esp
  802baa:	5b                   	pop    %ebx
  802bab:	5e                   	pop    %esi
  802bac:	5f                   	pop    %edi
  802bad:	5d                   	pop    %ebp
  802bae:	c3                   	ret    
  802baf:	90                   	nop
  802bb0:	89 fd                	mov    %edi,%ebp
  802bb2:	85 ff                	test   %edi,%edi
  802bb4:	75 0b                	jne    802bc1 <__umoddi3+0xe9>
  802bb6:	b8 01 00 00 00       	mov    $0x1,%eax
  802bbb:	31 d2                	xor    %edx,%edx
  802bbd:	f7 f7                	div    %edi
  802bbf:	89 c5                	mov    %eax,%ebp
  802bc1:	89 f0                	mov    %esi,%eax
  802bc3:	31 d2                	xor    %edx,%edx
  802bc5:	f7 f5                	div    %ebp
  802bc7:	89 c8                	mov    %ecx,%eax
  802bc9:	f7 f5                	div    %ebp
  802bcb:	89 d0                	mov    %edx,%eax
  802bcd:	e9 44 ff ff ff       	jmp    802b16 <__umoddi3+0x3e>
  802bd2:	66 90                	xchg   %ax,%ax
  802bd4:	89 c8                	mov    %ecx,%eax
  802bd6:	89 f2                	mov    %esi,%edx
  802bd8:	83 c4 1c             	add    $0x1c,%esp
  802bdb:	5b                   	pop    %ebx
  802bdc:	5e                   	pop    %esi
  802bdd:	5f                   	pop    %edi
  802bde:	5d                   	pop    %ebp
  802bdf:	c3                   	ret    
  802be0:	3b 04 24             	cmp    (%esp),%eax
  802be3:	72 06                	jb     802beb <__umoddi3+0x113>
  802be5:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  802be9:	77 0f                	ja     802bfa <__umoddi3+0x122>
  802beb:	89 f2                	mov    %esi,%edx
  802bed:	29 f9                	sub    %edi,%ecx
  802bef:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  802bf3:	89 14 24             	mov    %edx,(%esp)
  802bf6:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  802bfa:	8b 44 24 04          	mov    0x4(%esp),%eax
  802bfe:	8b 14 24             	mov    (%esp),%edx
  802c01:	83 c4 1c             	add    $0x1c,%esp
  802c04:	5b                   	pop    %ebx
  802c05:	5e                   	pop    %esi
  802c06:	5f                   	pop    %edi
  802c07:	5d                   	pop    %ebp
  802c08:	c3                   	ret    
  802c09:	8d 76 00             	lea    0x0(%esi),%esi
  802c0c:	2b 04 24             	sub    (%esp),%eax
  802c0f:	19 fa                	sbb    %edi,%edx
  802c11:	89 d1                	mov    %edx,%ecx
  802c13:	89 c6                	mov    %eax,%esi
  802c15:	e9 71 ff ff ff       	jmp    802b8b <__umoddi3+0xb3>
  802c1a:	66 90                	xchg   %ax,%ax
  802c1c:	39 44 24 04          	cmp    %eax,0x4(%esp)
  802c20:	72 ea                	jb     802c0c <__umoddi3+0x134>
  802c22:	89 d9                	mov    %ebx,%ecx
  802c24:	e9 62 ff ff ff       	jmp    802b8b <__umoddi3+0xb3>
