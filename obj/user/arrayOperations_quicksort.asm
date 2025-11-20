
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
  80003e:	e8 b4 19 00 00       	call   8019f7 <sys_getenvid>
  800043:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int32 parentenvID = sys_getparentenvid();
  800046:	e8 de 19 00 00       	call   801a29 <sys_getparentenvid>
  80004b:	89 45 ec             	mov    %eax,-0x14(%ebp)

	int ret;
	/*[1] GET SEMAPHORES*/
	struct semaphore ready = get_semaphore(parentenvID, "Ready");
  80004e:	8d 45 d8             	lea    -0x28(%ebp),%eax
  800051:	83 ec 04             	sub    $0x4,%esp
  800054:	68 40 2c 80 00       	push   $0x802c40
  800059:	ff 75 ec             	pushl  -0x14(%ebp)
  80005c:	50                   	push   %eax
  80005d:	e8 31 27 00 00       	call   802793 <get_semaphore>
  800062:	83 c4 0c             	add    $0xc,%esp
	struct semaphore finished = get_semaphore(parentenvID, "Finished");
  800065:	8d 45 d4             	lea    -0x2c(%ebp),%eax
  800068:	83 ec 04             	sub    $0x4,%esp
  80006b:	68 46 2c 80 00       	push   $0x802c46
  800070:	ff 75 ec             	pushl  -0x14(%ebp)
  800073:	50                   	push   %eax
  800074:	e8 1a 27 00 00       	call   802793 <get_semaphore>
  800079:	83 c4 0c             	add    $0xc,%esp

	/*[2] WAIT A READY SIGNAL FROM THE MASTER*/
	wait_semaphore(ready);
  80007c:	83 ec 0c             	sub    $0xc,%esp
  80007f:	ff 75 d8             	pushl  -0x28(%ebp)
  800082:	e8 26 27 00 00       	call   8027ad <wait_semaphore>
  800087:	83 c4 10             	add    $0x10,%esp

	/*[3] GET SHARED VARs*/
	//Get the cons_mutex ownerID
	int* consMutexOwnerID = sget(parentenvID, "cons_mutex ownerID") ;
  80008a:	83 ec 08             	sub    $0x8,%esp
  80008d:	68 4f 2c 80 00       	push   $0x802c4f
  800092:	ff 75 ec             	pushl  -0x14(%ebp)
  800095:	e8 30 16 00 00       	call   8016ca <sget>
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
  8000b2:	e8 dc 26 00 00       	call   802793 <get_semaphore>
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
  8000d3:	e8 f2 15 00 00       	call   8016ca <sget>
  8000d8:	83 c4 10             	add    $0x10,%esp
  8000db:	89 45 e0             	mov    %eax,-0x20(%ebp)
	numOfElements = sget(parentenvID,"arrSize") ;
  8000de:	83 ec 08             	sub    $0x8,%esp
  8000e1:	68 74 2c 80 00       	push   $0x802c74
  8000e6:	ff 75 ec             	pushl  -0x14(%ebp)
  8000e9:	e8 dc 15 00 00       	call   8016ca <sget>
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
  800107:	e8 8a 15 00 00       	call   801696 <smalloc>
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
  800164:	e8 44 26 00 00       	call   8027ad <wait_semaphore>
  800169:	83 c4 10             	add    $0x10,%esp
	{
		cprintf("Quick sort is Finished!!!!\n") ;
  80016c:	83 ec 0c             	sub    $0xc,%esp
  80016f:	68 8b 2c 80 00       	push   $0x802c8b
  800174:	e8 13 05 00 00       	call   80068c <cprintf>
  800179:	83 c4 10             	add    $0x10,%esp
		cprintf("will notify the master now...\n");
  80017c:	83 ec 0c             	sub    $0xc,%esp
  80017f:	68 a8 2c 80 00       	push   $0x802ca8
  800184:	e8 03 05 00 00       	call   80068c <cprintf>
  800189:	83 c4 10             	add    $0x10,%esp
		cprintf("Quick sort says GOOD BYE :)\n") ;
  80018c:	83 ec 0c             	sub    $0xc,%esp
  80018f:	68 c7 2c 80 00       	push   $0x802cc7
  800194:	e8 f3 04 00 00       	call   80068c <cprintf>
  800199:	83 c4 10             	add    $0x10,%esp
	}
	signal_semaphore(cons_mutex);
  80019c:	83 ec 0c             	sub    $0xc,%esp
  80019f:	ff 75 d0             	pushl  -0x30(%ebp)
  8001a2:	e8 20 26 00 00       	call   8027c7 <signal_semaphore>
  8001a7:	83 c4 10             	add    $0x10,%esp

	/*[5] DECLARE FINISHING*/
	signal_semaphore(finished);
  8001aa:	83 ec 0c             	sub    $0xc,%esp
  8001ad:	ff 75 d4             	pushl  -0x2c(%ebp)
  8001b0:	e8 12 26 00 00       	call   8027c7 <signal_semaphore>
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
  80038c:	e8 fb 02 00 00       	call   80068c <cprintf>
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
  8003ae:	e8 d9 02 00 00       	call   80068c <cprintf>
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
  8003dc:	e8 ab 02 00 00       	call   80068c <cprintf>
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
  8003f0:	e8 1b 16 00 00       	call   801a10 <sys_getenvindex>
  8003f5:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	myEnv = &(envs[envIndex]);
  8003f8:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8003fb:	89 d0                	mov    %edx,%eax
  8003fd:	c1 e0 06             	shl    $0x6,%eax
  800400:	29 d0                	sub    %edx,%eax
  800402:	c1 e0 02             	shl    $0x2,%eax
  800405:	01 d0                	add    %edx,%eax
  800407:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  80040e:	01 c8                	add    %ecx,%eax
  800410:	c1 e0 03             	shl    $0x3,%eax
  800413:	01 d0                	add    %edx,%eax
  800415:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80041c:	29 c2                	sub    %eax,%edx
  80041e:	8d 04 95 00 00 00 00 	lea    0x0(,%edx,4),%eax
  800425:	89 c2                	mov    %eax,%edx
  800427:	8d 82 00 00 c0 ee    	lea    -0x11400000(%edx),%eax
  80042d:	a3 20 40 80 00       	mov    %eax,0x804020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800432:	a1 20 40 80 00       	mov    0x804020,%eax
  800437:	8a 40 20             	mov    0x20(%eax),%al
  80043a:	84 c0                	test   %al,%al
  80043c:	74 0d                	je     80044b <libmain+0x64>
		binaryname = myEnv->prog_name;
  80043e:	a1 20 40 80 00       	mov    0x804020,%eax
  800443:	83 c0 20             	add    $0x20,%eax
  800446:	a3 04 40 80 00       	mov    %eax,0x804004

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80044b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80044f:	7e 0a                	jle    80045b <libmain+0x74>
		binaryname = argv[0];
  800451:	8b 45 0c             	mov    0xc(%ebp),%eax
  800454:	8b 00                	mov    (%eax),%eax
  800456:	a3 04 40 80 00       	mov    %eax,0x804004

	// call user main routine
	_main(argc, argv);
  80045b:	83 ec 08             	sub    $0x8,%esp
  80045e:	ff 75 0c             	pushl  0xc(%ebp)
  800461:	ff 75 08             	pushl  0x8(%ebp)
  800464:	e8 cf fb ff ff       	call   800038 <_main>
  800469:	83 c4 10             	add    $0x10,%esp

	if (printStats)
  80046c:	a1 00 40 80 00       	mov    0x804000,%eax
  800471:	85 c0                	test   %eax,%eax
  800473:	0f 84 01 01 00 00    	je     80057a <libmain+0x193>
	{
		char isOPTReplCmd[100] = "__IsOPTRepl__" ;
  800479:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  80047f:	bb e8 2d 80 00       	mov    $0x802de8,%ebx
  800484:	ba 0e 00 00 00       	mov    $0xe,%edx
  800489:	89 c7                	mov    %eax,%edi
  80048b:	89 de                	mov    %ebx,%esi
  80048d:	89 d1                	mov    %edx,%ecx
  80048f:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  800491:	8d 55 8a             	lea    -0x76(%ebp),%edx
  800494:	b9 56 00 00 00       	mov    $0x56,%ecx
  800499:	b0 00                	mov    $0x0,%al
  80049b:	89 d7                	mov    %edx,%edi
  80049d:	f3 aa                	rep stos %al,%es:(%edi)
		int isOPTRepl = 0;
  80049f:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
		sys_utilities(isOPTReplCmd, (uint32)(&isOPTRepl));
  8004a6:	8d 45 e0             	lea    -0x20(%ebp),%eax
  8004a9:	83 ec 08             	sub    $0x8,%esp
  8004ac:	50                   	push   %eax
  8004ad:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  8004b3:	50                   	push   %eax
  8004b4:	e8 8d 17 00 00       	call   801c46 <sys_utilities>
  8004b9:	83 c4 10             	add    $0x10,%esp

		sys_lock_cons();
  8004bc:	e8 d6 12 00 00       	call   801797 <sys_lock_cons>
		{
			cprintf("**************************************\n");
  8004c1:	83 ec 0c             	sub    $0xc,%esp
  8004c4:	68 08 2d 80 00       	push   $0x802d08
  8004c9:	e8 be 01 00 00       	call   80068c <cprintf>
  8004ce:	83 c4 10             	add    $0x10,%esp
			if (isOPTRepl)
  8004d1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8004d4:	85 c0                	test   %eax,%eax
  8004d6:	74 18                	je     8004f0 <libmain+0x109>
			{
				cprintf("OPTIMAL number of page faults = %d\n", sys_get_optimal_num_faults());
  8004d8:	e8 87 17 00 00       	call   801c64 <sys_get_optimal_num_faults>
  8004dd:	83 ec 08             	sub    $0x8,%esp
  8004e0:	50                   	push   %eax
  8004e1:	68 30 2d 80 00       	push   $0x802d30
  8004e6:	e8 a1 01 00 00       	call   80068c <cprintf>
  8004eb:	83 c4 10             	add    $0x10,%esp
  8004ee:	eb 59                	jmp    800549 <libmain+0x162>
			}
			else
			{
				cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8004f0:	a1 20 40 80 00       	mov    0x804020,%eax
  8004f5:	8b 90 50 da 01 00    	mov    0x1da50(%eax),%edx
  8004fb:	a1 20 40 80 00       	mov    0x804020,%eax
  800500:	8b 80 40 da 01 00    	mov    0x1da40(%eax),%eax
  800506:	83 ec 04             	sub    $0x4,%esp
  800509:	52                   	push   %edx
  80050a:	50                   	push   %eax
  80050b:	68 54 2d 80 00       	push   $0x802d54
  800510:	e8 77 01 00 00       	call   80068c <cprintf>
  800515:	83 c4 10             	add    $0x10,%esp
				cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800518:	a1 20 40 80 00       	mov    0x804020,%eax
  80051d:	8b 88 64 da 01 00    	mov    0x1da64(%eax),%ecx
  800523:	a1 20 40 80 00       	mov    0x804020,%eax
  800528:	8b 90 60 da 01 00    	mov    0x1da60(%eax),%edx
  80052e:	a1 20 40 80 00       	mov    0x804020,%eax
  800533:	8b 80 5c da 01 00    	mov    0x1da5c(%eax),%eax
  800539:	51                   	push   %ecx
  80053a:	52                   	push   %edx
  80053b:	50                   	push   %eax
  80053c:	68 7c 2d 80 00       	push   $0x802d7c
  800541:	e8 46 01 00 00       	call   80068c <cprintf>
  800546:	83 c4 10             	add    $0x10,%esp
			}
			//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
			cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800549:	a1 20 40 80 00       	mov    0x804020,%eax
  80054e:	8b 80 68 da 01 00    	mov    0x1da68(%eax),%eax
  800554:	83 ec 08             	sub    $0x8,%esp
  800557:	50                   	push   %eax
  800558:	68 d4 2d 80 00       	push   $0x802dd4
  80055d:	e8 2a 01 00 00       	call   80068c <cprintf>
  800562:	83 c4 10             	add    $0x10,%esp
			cprintf("**************************************\n");
  800565:	83 ec 0c             	sub    $0xc,%esp
  800568:	68 08 2d 80 00       	push   $0x802d08
  80056d:	e8 1a 01 00 00       	call   80068c <cprintf>
  800572:	83 c4 10             	add    $0x10,%esp
		}
		sys_unlock_cons();
  800575:	e8 37 12 00 00       	call   8017b1 <sys_unlock_cons>
	}

	// exit gracefully
	exit();
  80057a:	e8 1f 00 00 00       	call   80059e <exit>
}
  80057f:	90                   	nop
  800580:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800583:	5b                   	pop    %ebx
  800584:	5e                   	pop    %esi
  800585:	5f                   	pop    %edi
  800586:	5d                   	pop    %ebp
  800587:	c3                   	ret    

00800588 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800588:	55                   	push   %ebp
  800589:	89 e5                	mov    %esp,%ebp
  80058b:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  80058e:	83 ec 0c             	sub    $0xc,%esp
  800591:	6a 00                	push   $0x0
  800593:	e8 44 14 00 00       	call   8019dc <sys_destroy_env>
  800598:	83 c4 10             	add    $0x10,%esp
}
  80059b:	90                   	nop
  80059c:	c9                   	leave  
  80059d:	c3                   	ret    

0080059e <exit>:

void
exit(void)
{
  80059e:	55                   	push   %ebp
  80059f:	89 e5                	mov    %esp,%ebp
  8005a1:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  8005a4:	e8 99 14 00 00       	call   801a42 <sys_exit_env>
}
  8005a9:	90                   	nop
  8005aa:	c9                   	leave  
  8005ab:	c3                   	ret    

008005ac <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  8005ac:	55                   	push   %ebp
  8005ad:	89 e5                	mov    %esp,%ebp
  8005af:	53                   	push   %ebx
  8005b0:	83 ec 04             	sub    $0x4,%esp
	b->buf[b->idx++] = ch;
  8005b3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8005b6:	8b 00                	mov    (%eax),%eax
  8005b8:	8d 48 01             	lea    0x1(%eax),%ecx
  8005bb:	8b 55 0c             	mov    0xc(%ebp),%edx
  8005be:	89 0a                	mov    %ecx,(%edx)
  8005c0:	8b 55 08             	mov    0x8(%ebp),%edx
  8005c3:	88 d1                	mov    %dl,%cl
  8005c5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8005c8:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  8005cc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8005cf:	8b 00                	mov    (%eax),%eax
  8005d1:	3d ff 00 00 00       	cmp    $0xff,%eax
  8005d6:	75 30                	jne    800608 <putch+0x5c>
		sys_cputs(b->buf, b->idx, printProgName, curTextClr);
  8005d8:	8b 15 18 c1 81 00    	mov    0x81c118,%edx
  8005de:	a0 44 40 80 00       	mov    0x804044,%al
  8005e3:	0f b6 c0             	movzbl %al,%eax
  8005e6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8005e9:	8b 09                	mov    (%ecx),%ecx
  8005eb:	89 cb                	mov    %ecx,%ebx
  8005ed:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8005f0:	83 c1 08             	add    $0x8,%ecx
  8005f3:	52                   	push   %edx
  8005f4:	50                   	push   %eax
  8005f5:	53                   	push   %ebx
  8005f6:	51                   	push   %ecx
  8005f7:	e8 57 11 00 00       	call   801753 <sys_cputs>
  8005fc:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8005ff:	8b 45 0c             	mov    0xc(%ebp),%eax
  800602:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800608:	8b 45 0c             	mov    0xc(%ebp),%eax
  80060b:	8b 40 04             	mov    0x4(%eax),%eax
  80060e:	8d 50 01             	lea    0x1(%eax),%edx
  800611:	8b 45 0c             	mov    0xc(%ebp),%eax
  800614:	89 50 04             	mov    %edx,0x4(%eax)
}
  800617:	90                   	nop
  800618:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80061b:	c9                   	leave  
  80061c:	c3                   	ret    

0080061d <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  80061d:	55                   	push   %ebp
  80061e:	89 e5                	mov    %esp,%ebp
  800620:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800626:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80062d:	00 00 00 
	b.cnt = 0;
  800630:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800637:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  80063a:	ff 75 0c             	pushl  0xc(%ebp)
  80063d:	ff 75 08             	pushl  0x8(%ebp)
  800640:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800646:	50                   	push   %eax
  800647:	68 ac 05 80 00       	push   $0x8005ac
  80064c:	e8 5a 02 00 00       	call   8008ab <vprintfmt>
  800651:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName, curTextClr);
  800654:	8b 15 18 c1 81 00    	mov    0x81c118,%edx
  80065a:	a0 44 40 80 00       	mov    0x804044,%al
  80065f:	0f b6 c0             	movzbl %al,%eax
  800662:	8b 8d f0 fe ff ff    	mov    -0x110(%ebp),%ecx
  800668:	52                   	push   %edx
  800669:	50                   	push   %eax
  80066a:	51                   	push   %ecx
  80066b:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800671:	83 c0 08             	add    $0x8,%eax
  800674:	50                   	push   %eax
  800675:	e8 d9 10 00 00       	call   801753 <sys_cputs>
  80067a:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  80067d:	c6 05 44 40 80 00 00 	movb   $0x0,0x804044
	return b.cnt;
  800684:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  80068a:	c9                   	leave  
  80068b:	c3                   	ret    

0080068c <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  80068c:	55                   	push   %ebp
  80068d:	89 e5                	mov    %esp,%ebp
  80068f:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800692:	c6 05 44 40 80 00 01 	movb   $0x1,0x804044
	va_start(ap, fmt);
  800699:	8d 45 0c             	lea    0xc(%ebp),%eax
  80069c:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  80069f:	8b 45 08             	mov    0x8(%ebp),%eax
  8006a2:	83 ec 08             	sub    $0x8,%esp
  8006a5:	ff 75 f4             	pushl  -0xc(%ebp)
  8006a8:	50                   	push   %eax
  8006a9:	e8 6f ff ff ff       	call   80061d <vcprintf>
  8006ae:	83 c4 10             	add    $0x10,%esp
  8006b1:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  8006b4:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8006b7:	c9                   	leave  
  8006b8:	c3                   	ret    

008006b9 <cprintf_colored>:

// *************** This text coloring feature is implemented by *************
// ********** Abd-Alrahman Zedan From Team Frozen-Bytes - FCIS'24-25 ********
int cprintf_colored(int textClr, const char *fmt, ...) {
  8006b9:	55                   	push   %ebp
  8006ba:	89 e5                	mov    %esp,%ebp
  8006bc:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  8006bf:	c6 05 44 40 80 00 01 	movb   $0x1,0x804044
	curTextClr = (textClr << 8) ; //set text color by the given value
  8006c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8006c9:	c1 e0 08             	shl    $0x8,%eax
  8006cc:	a3 18 c1 81 00       	mov    %eax,0x81c118
	va_start(ap, fmt);
  8006d1:	8d 45 0c             	lea    0xc(%ebp),%eax
  8006d4:	83 c0 04             	add    $0x4,%eax
  8006d7:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8006da:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006dd:	83 ec 08             	sub    $0x8,%esp
  8006e0:	ff 75 f4             	pushl  -0xc(%ebp)
  8006e3:	50                   	push   %eax
  8006e4:	e8 34 ff ff ff       	call   80061d <vcprintf>
  8006e9:	83 c4 10             	add    $0x10,%esp
  8006ec:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);
	curTextClr = TEXT_DEFAULT_CLR; //restore default color
  8006ef:	c7 05 18 c1 81 00 00 	movl   $0x700,0x81c118
  8006f6:	07 00 00 

	return cnt;
  8006f9:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8006fc:	c9                   	leave  
  8006fd:	c3                   	ret    

008006fe <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  8006fe:	55                   	push   %ebp
  8006ff:	89 e5                	mov    %esp,%ebp
  800701:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  800704:	e8 8e 10 00 00       	call   801797 <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  800709:	8d 45 0c             	lea    0xc(%ebp),%eax
  80070c:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  80070f:	8b 45 08             	mov    0x8(%ebp),%eax
  800712:	83 ec 08             	sub    $0x8,%esp
  800715:	ff 75 f4             	pushl  -0xc(%ebp)
  800718:	50                   	push   %eax
  800719:	e8 ff fe ff ff       	call   80061d <vcprintf>
  80071e:	83 c4 10             	add    $0x10,%esp
  800721:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  800724:	e8 88 10 00 00       	call   8017b1 <sys_unlock_cons>
	return cnt;
  800729:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80072c:	c9                   	leave  
  80072d:	c3                   	ret    

0080072e <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  80072e:	55                   	push   %ebp
  80072f:	89 e5                	mov    %esp,%ebp
  800731:	53                   	push   %ebx
  800732:	83 ec 14             	sub    $0x14,%esp
  800735:	8b 45 10             	mov    0x10(%ebp),%eax
  800738:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80073b:	8b 45 14             	mov    0x14(%ebp),%eax
  80073e:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800741:	8b 45 18             	mov    0x18(%ebp),%eax
  800744:	ba 00 00 00 00       	mov    $0x0,%edx
  800749:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  80074c:	77 55                	ja     8007a3 <printnum+0x75>
  80074e:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800751:	72 05                	jb     800758 <printnum+0x2a>
  800753:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800756:	77 4b                	ja     8007a3 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800758:	8b 45 1c             	mov    0x1c(%ebp),%eax
  80075b:	8d 58 ff             	lea    -0x1(%eax),%ebx
  80075e:	8b 45 18             	mov    0x18(%ebp),%eax
  800761:	ba 00 00 00 00       	mov    $0x0,%edx
  800766:	52                   	push   %edx
  800767:	50                   	push   %eax
  800768:	ff 75 f4             	pushl  -0xc(%ebp)
  80076b:	ff 75 f0             	pushl  -0x10(%ebp)
  80076e:	e8 69 22 00 00       	call   8029dc <__udivdi3>
  800773:	83 c4 10             	add    $0x10,%esp
  800776:	83 ec 04             	sub    $0x4,%esp
  800779:	ff 75 20             	pushl  0x20(%ebp)
  80077c:	53                   	push   %ebx
  80077d:	ff 75 18             	pushl  0x18(%ebp)
  800780:	52                   	push   %edx
  800781:	50                   	push   %eax
  800782:	ff 75 0c             	pushl  0xc(%ebp)
  800785:	ff 75 08             	pushl  0x8(%ebp)
  800788:	e8 a1 ff ff ff       	call   80072e <printnum>
  80078d:	83 c4 20             	add    $0x20,%esp
  800790:	eb 1a                	jmp    8007ac <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800792:	83 ec 08             	sub    $0x8,%esp
  800795:	ff 75 0c             	pushl  0xc(%ebp)
  800798:	ff 75 20             	pushl  0x20(%ebp)
  80079b:	8b 45 08             	mov    0x8(%ebp),%eax
  80079e:	ff d0                	call   *%eax
  8007a0:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8007a3:	ff 4d 1c             	decl   0x1c(%ebp)
  8007a6:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  8007aa:	7f e6                	jg     800792 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8007ac:	8b 4d 18             	mov    0x18(%ebp),%ecx
  8007af:	bb 00 00 00 00       	mov    $0x0,%ebx
  8007b4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8007b7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8007ba:	53                   	push   %ebx
  8007bb:	51                   	push   %ecx
  8007bc:	52                   	push   %edx
  8007bd:	50                   	push   %eax
  8007be:	e8 29 23 00 00       	call   802aec <__umoddi3>
  8007c3:	83 c4 10             	add    $0x10,%esp
  8007c6:	05 74 30 80 00       	add    $0x803074,%eax
  8007cb:	8a 00                	mov    (%eax),%al
  8007cd:	0f be c0             	movsbl %al,%eax
  8007d0:	83 ec 08             	sub    $0x8,%esp
  8007d3:	ff 75 0c             	pushl  0xc(%ebp)
  8007d6:	50                   	push   %eax
  8007d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8007da:	ff d0                	call   *%eax
  8007dc:	83 c4 10             	add    $0x10,%esp
}
  8007df:	90                   	nop
  8007e0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8007e3:	c9                   	leave  
  8007e4:	c3                   	ret    

008007e5 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8007e5:	55                   	push   %ebp
  8007e6:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8007e8:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8007ec:	7e 1c                	jle    80080a <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  8007ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8007f1:	8b 00                	mov    (%eax),%eax
  8007f3:	8d 50 08             	lea    0x8(%eax),%edx
  8007f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8007f9:	89 10                	mov    %edx,(%eax)
  8007fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8007fe:	8b 00                	mov    (%eax),%eax
  800800:	83 e8 08             	sub    $0x8,%eax
  800803:	8b 50 04             	mov    0x4(%eax),%edx
  800806:	8b 00                	mov    (%eax),%eax
  800808:	eb 40                	jmp    80084a <getuint+0x65>
	else if (lflag)
  80080a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80080e:	74 1e                	je     80082e <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800810:	8b 45 08             	mov    0x8(%ebp),%eax
  800813:	8b 00                	mov    (%eax),%eax
  800815:	8d 50 04             	lea    0x4(%eax),%edx
  800818:	8b 45 08             	mov    0x8(%ebp),%eax
  80081b:	89 10                	mov    %edx,(%eax)
  80081d:	8b 45 08             	mov    0x8(%ebp),%eax
  800820:	8b 00                	mov    (%eax),%eax
  800822:	83 e8 04             	sub    $0x4,%eax
  800825:	8b 00                	mov    (%eax),%eax
  800827:	ba 00 00 00 00       	mov    $0x0,%edx
  80082c:	eb 1c                	jmp    80084a <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  80082e:	8b 45 08             	mov    0x8(%ebp),%eax
  800831:	8b 00                	mov    (%eax),%eax
  800833:	8d 50 04             	lea    0x4(%eax),%edx
  800836:	8b 45 08             	mov    0x8(%ebp),%eax
  800839:	89 10                	mov    %edx,(%eax)
  80083b:	8b 45 08             	mov    0x8(%ebp),%eax
  80083e:	8b 00                	mov    (%eax),%eax
  800840:	83 e8 04             	sub    $0x4,%eax
  800843:	8b 00                	mov    (%eax),%eax
  800845:	ba 00 00 00 00       	mov    $0x0,%edx
}
  80084a:	5d                   	pop    %ebp
  80084b:	c3                   	ret    

0080084c <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  80084c:	55                   	push   %ebp
  80084d:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  80084f:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800853:	7e 1c                	jle    800871 <getint+0x25>
		return va_arg(*ap, long long);
  800855:	8b 45 08             	mov    0x8(%ebp),%eax
  800858:	8b 00                	mov    (%eax),%eax
  80085a:	8d 50 08             	lea    0x8(%eax),%edx
  80085d:	8b 45 08             	mov    0x8(%ebp),%eax
  800860:	89 10                	mov    %edx,(%eax)
  800862:	8b 45 08             	mov    0x8(%ebp),%eax
  800865:	8b 00                	mov    (%eax),%eax
  800867:	83 e8 08             	sub    $0x8,%eax
  80086a:	8b 50 04             	mov    0x4(%eax),%edx
  80086d:	8b 00                	mov    (%eax),%eax
  80086f:	eb 38                	jmp    8008a9 <getint+0x5d>
	else if (lflag)
  800871:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800875:	74 1a                	je     800891 <getint+0x45>
		return va_arg(*ap, long);
  800877:	8b 45 08             	mov    0x8(%ebp),%eax
  80087a:	8b 00                	mov    (%eax),%eax
  80087c:	8d 50 04             	lea    0x4(%eax),%edx
  80087f:	8b 45 08             	mov    0x8(%ebp),%eax
  800882:	89 10                	mov    %edx,(%eax)
  800884:	8b 45 08             	mov    0x8(%ebp),%eax
  800887:	8b 00                	mov    (%eax),%eax
  800889:	83 e8 04             	sub    $0x4,%eax
  80088c:	8b 00                	mov    (%eax),%eax
  80088e:	99                   	cltd   
  80088f:	eb 18                	jmp    8008a9 <getint+0x5d>
	else
		return va_arg(*ap, int);
  800891:	8b 45 08             	mov    0x8(%ebp),%eax
  800894:	8b 00                	mov    (%eax),%eax
  800896:	8d 50 04             	lea    0x4(%eax),%edx
  800899:	8b 45 08             	mov    0x8(%ebp),%eax
  80089c:	89 10                	mov    %edx,(%eax)
  80089e:	8b 45 08             	mov    0x8(%ebp),%eax
  8008a1:	8b 00                	mov    (%eax),%eax
  8008a3:	83 e8 04             	sub    $0x4,%eax
  8008a6:	8b 00                	mov    (%eax),%eax
  8008a8:	99                   	cltd   
}
  8008a9:	5d                   	pop    %ebp
  8008aa:	c3                   	ret    

008008ab <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8008ab:	55                   	push   %ebp
  8008ac:	89 e5                	mov    %esp,%ebp
  8008ae:	56                   	push   %esi
  8008af:	53                   	push   %ebx
  8008b0:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8008b3:	eb 17                	jmp    8008cc <vprintfmt+0x21>
			if (ch == '\0')
  8008b5:	85 db                	test   %ebx,%ebx
  8008b7:	0f 84 c1 03 00 00    	je     800c7e <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  8008bd:	83 ec 08             	sub    $0x8,%esp
  8008c0:	ff 75 0c             	pushl  0xc(%ebp)
  8008c3:	53                   	push   %ebx
  8008c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8008c7:	ff d0                	call   *%eax
  8008c9:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8008cc:	8b 45 10             	mov    0x10(%ebp),%eax
  8008cf:	8d 50 01             	lea    0x1(%eax),%edx
  8008d2:	89 55 10             	mov    %edx,0x10(%ebp)
  8008d5:	8a 00                	mov    (%eax),%al
  8008d7:	0f b6 d8             	movzbl %al,%ebx
  8008da:	83 fb 25             	cmp    $0x25,%ebx
  8008dd:	75 d6                	jne    8008b5 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  8008df:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  8008e3:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  8008ea:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8008f1:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  8008f8:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8008ff:	8b 45 10             	mov    0x10(%ebp),%eax
  800902:	8d 50 01             	lea    0x1(%eax),%edx
  800905:	89 55 10             	mov    %edx,0x10(%ebp)
  800908:	8a 00                	mov    (%eax),%al
  80090a:	0f b6 d8             	movzbl %al,%ebx
  80090d:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800910:	83 f8 5b             	cmp    $0x5b,%eax
  800913:	0f 87 3d 03 00 00    	ja     800c56 <vprintfmt+0x3ab>
  800919:	8b 04 85 98 30 80 00 	mov    0x803098(,%eax,4),%eax
  800920:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800922:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800926:	eb d7                	jmp    8008ff <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800928:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  80092c:	eb d1                	jmp    8008ff <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  80092e:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800935:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800938:	89 d0                	mov    %edx,%eax
  80093a:	c1 e0 02             	shl    $0x2,%eax
  80093d:	01 d0                	add    %edx,%eax
  80093f:	01 c0                	add    %eax,%eax
  800941:	01 d8                	add    %ebx,%eax
  800943:	83 e8 30             	sub    $0x30,%eax
  800946:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800949:	8b 45 10             	mov    0x10(%ebp),%eax
  80094c:	8a 00                	mov    (%eax),%al
  80094e:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800951:	83 fb 2f             	cmp    $0x2f,%ebx
  800954:	7e 3e                	jle    800994 <vprintfmt+0xe9>
  800956:	83 fb 39             	cmp    $0x39,%ebx
  800959:	7f 39                	jg     800994 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  80095b:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  80095e:	eb d5                	jmp    800935 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800960:	8b 45 14             	mov    0x14(%ebp),%eax
  800963:	83 c0 04             	add    $0x4,%eax
  800966:	89 45 14             	mov    %eax,0x14(%ebp)
  800969:	8b 45 14             	mov    0x14(%ebp),%eax
  80096c:	83 e8 04             	sub    $0x4,%eax
  80096f:	8b 00                	mov    (%eax),%eax
  800971:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800974:	eb 1f                	jmp    800995 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800976:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80097a:	79 83                	jns    8008ff <vprintfmt+0x54>
				width = 0;
  80097c:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800983:	e9 77 ff ff ff       	jmp    8008ff <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800988:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  80098f:	e9 6b ff ff ff       	jmp    8008ff <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800994:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800995:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800999:	0f 89 60 ff ff ff    	jns    8008ff <vprintfmt+0x54>
				width = precision, precision = -1;
  80099f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8009a2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8009a5:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  8009ac:	e9 4e ff ff ff       	jmp    8008ff <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  8009b1:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  8009b4:	e9 46 ff ff ff       	jmp    8008ff <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  8009b9:	8b 45 14             	mov    0x14(%ebp),%eax
  8009bc:	83 c0 04             	add    $0x4,%eax
  8009bf:	89 45 14             	mov    %eax,0x14(%ebp)
  8009c2:	8b 45 14             	mov    0x14(%ebp),%eax
  8009c5:	83 e8 04             	sub    $0x4,%eax
  8009c8:	8b 00                	mov    (%eax),%eax
  8009ca:	83 ec 08             	sub    $0x8,%esp
  8009cd:	ff 75 0c             	pushl  0xc(%ebp)
  8009d0:	50                   	push   %eax
  8009d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8009d4:	ff d0                	call   *%eax
  8009d6:	83 c4 10             	add    $0x10,%esp
			break;
  8009d9:	e9 9b 02 00 00       	jmp    800c79 <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  8009de:	8b 45 14             	mov    0x14(%ebp),%eax
  8009e1:	83 c0 04             	add    $0x4,%eax
  8009e4:	89 45 14             	mov    %eax,0x14(%ebp)
  8009e7:	8b 45 14             	mov    0x14(%ebp),%eax
  8009ea:	83 e8 04             	sub    $0x4,%eax
  8009ed:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  8009ef:	85 db                	test   %ebx,%ebx
  8009f1:	79 02                	jns    8009f5 <vprintfmt+0x14a>
				err = -err;
  8009f3:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  8009f5:	83 fb 64             	cmp    $0x64,%ebx
  8009f8:	7f 0b                	jg     800a05 <vprintfmt+0x15a>
  8009fa:	8b 34 9d e0 2e 80 00 	mov    0x802ee0(,%ebx,4),%esi
  800a01:	85 f6                	test   %esi,%esi
  800a03:	75 19                	jne    800a1e <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800a05:	53                   	push   %ebx
  800a06:	68 85 30 80 00       	push   $0x803085
  800a0b:	ff 75 0c             	pushl  0xc(%ebp)
  800a0e:	ff 75 08             	pushl  0x8(%ebp)
  800a11:	e8 70 02 00 00       	call   800c86 <printfmt>
  800a16:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800a19:	e9 5b 02 00 00       	jmp    800c79 <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800a1e:	56                   	push   %esi
  800a1f:	68 8e 30 80 00       	push   $0x80308e
  800a24:	ff 75 0c             	pushl  0xc(%ebp)
  800a27:	ff 75 08             	pushl  0x8(%ebp)
  800a2a:	e8 57 02 00 00       	call   800c86 <printfmt>
  800a2f:	83 c4 10             	add    $0x10,%esp
			break;
  800a32:	e9 42 02 00 00       	jmp    800c79 <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800a37:	8b 45 14             	mov    0x14(%ebp),%eax
  800a3a:	83 c0 04             	add    $0x4,%eax
  800a3d:	89 45 14             	mov    %eax,0x14(%ebp)
  800a40:	8b 45 14             	mov    0x14(%ebp),%eax
  800a43:	83 e8 04             	sub    $0x4,%eax
  800a46:	8b 30                	mov    (%eax),%esi
  800a48:	85 f6                	test   %esi,%esi
  800a4a:	75 05                	jne    800a51 <vprintfmt+0x1a6>
				p = "(null)";
  800a4c:	be 91 30 80 00       	mov    $0x803091,%esi
			if (width > 0 && padc != '-')
  800a51:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a55:	7e 6d                	jle    800ac4 <vprintfmt+0x219>
  800a57:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800a5b:	74 67                	je     800ac4 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800a5d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800a60:	83 ec 08             	sub    $0x8,%esp
  800a63:	50                   	push   %eax
  800a64:	56                   	push   %esi
  800a65:	e8 1e 03 00 00       	call   800d88 <strnlen>
  800a6a:	83 c4 10             	add    $0x10,%esp
  800a6d:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800a70:	eb 16                	jmp    800a88 <vprintfmt+0x1dd>
					putch(padc, putdat);
  800a72:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800a76:	83 ec 08             	sub    $0x8,%esp
  800a79:	ff 75 0c             	pushl  0xc(%ebp)
  800a7c:	50                   	push   %eax
  800a7d:	8b 45 08             	mov    0x8(%ebp),%eax
  800a80:	ff d0                	call   *%eax
  800a82:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800a85:	ff 4d e4             	decl   -0x1c(%ebp)
  800a88:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a8c:	7f e4                	jg     800a72 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800a8e:	eb 34                	jmp    800ac4 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800a90:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800a94:	74 1c                	je     800ab2 <vprintfmt+0x207>
  800a96:	83 fb 1f             	cmp    $0x1f,%ebx
  800a99:	7e 05                	jle    800aa0 <vprintfmt+0x1f5>
  800a9b:	83 fb 7e             	cmp    $0x7e,%ebx
  800a9e:	7e 12                	jle    800ab2 <vprintfmt+0x207>
					putch('?', putdat);
  800aa0:	83 ec 08             	sub    $0x8,%esp
  800aa3:	ff 75 0c             	pushl  0xc(%ebp)
  800aa6:	6a 3f                	push   $0x3f
  800aa8:	8b 45 08             	mov    0x8(%ebp),%eax
  800aab:	ff d0                	call   *%eax
  800aad:	83 c4 10             	add    $0x10,%esp
  800ab0:	eb 0f                	jmp    800ac1 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800ab2:	83 ec 08             	sub    $0x8,%esp
  800ab5:	ff 75 0c             	pushl  0xc(%ebp)
  800ab8:	53                   	push   %ebx
  800ab9:	8b 45 08             	mov    0x8(%ebp),%eax
  800abc:	ff d0                	call   *%eax
  800abe:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800ac1:	ff 4d e4             	decl   -0x1c(%ebp)
  800ac4:	89 f0                	mov    %esi,%eax
  800ac6:	8d 70 01             	lea    0x1(%eax),%esi
  800ac9:	8a 00                	mov    (%eax),%al
  800acb:	0f be d8             	movsbl %al,%ebx
  800ace:	85 db                	test   %ebx,%ebx
  800ad0:	74 24                	je     800af6 <vprintfmt+0x24b>
  800ad2:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800ad6:	78 b8                	js     800a90 <vprintfmt+0x1e5>
  800ad8:	ff 4d e0             	decl   -0x20(%ebp)
  800adb:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800adf:	79 af                	jns    800a90 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800ae1:	eb 13                	jmp    800af6 <vprintfmt+0x24b>
				putch(' ', putdat);
  800ae3:	83 ec 08             	sub    $0x8,%esp
  800ae6:	ff 75 0c             	pushl  0xc(%ebp)
  800ae9:	6a 20                	push   $0x20
  800aeb:	8b 45 08             	mov    0x8(%ebp),%eax
  800aee:	ff d0                	call   *%eax
  800af0:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800af3:	ff 4d e4             	decl   -0x1c(%ebp)
  800af6:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800afa:	7f e7                	jg     800ae3 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800afc:	e9 78 01 00 00       	jmp    800c79 <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800b01:	83 ec 08             	sub    $0x8,%esp
  800b04:	ff 75 e8             	pushl  -0x18(%ebp)
  800b07:	8d 45 14             	lea    0x14(%ebp),%eax
  800b0a:	50                   	push   %eax
  800b0b:	e8 3c fd ff ff       	call   80084c <getint>
  800b10:	83 c4 10             	add    $0x10,%esp
  800b13:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b16:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800b19:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800b1c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800b1f:	85 d2                	test   %edx,%edx
  800b21:	79 23                	jns    800b46 <vprintfmt+0x29b>
				putch('-', putdat);
  800b23:	83 ec 08             	sub    $0x8,%esp
  800b26:	ff 75 0c             	pushl  0xc(%ebp)
  800b29:	6a 2d                	push   $0x2d
  800b2b:	8b 45 08             	mov    0x8(%ebp),%eax
  800b2e:	ff d0                	call   *%eax
  800b30:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800b33:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800b36:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800b39:	f7 d8                	neg    %eax
  800b3b:	83 d2 00             	adc    $0x0,%edx
  800b3e:	f7 da                	neg    %edx
  800b40:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b43:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800b46:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800b4d:	e9 bc 00 00 00       	jmp    800c0e <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800b52:	83 ec 08             	sub    $0x8,%esp
  800b55:	ff 75 e8             	pushl  -0x18(%ebp)
  800b58:	8d 45 14             	lea    0x14(%ebp),%eax
  800b5b:	50                   	push   %eax
  800b5c:	e8 84 fc ff ff       	call   8007e5 <getuint>
  800b61:	83 c4 10             	add    $0x10,%esp
  800b64:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b67:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800b6a:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800b71:	e9 98 00 00 00       	jmp    800c0e <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800b76:	83 ec 08             	sub    $0x8,%esp
  800b79:	ff 75 0c             	pushl  0xc(%ebp)
  800b7c:	6a 58                	push   $0x58
  800b7e:	8b 45 08             	mov    0x8(%ebp),%eax
  800b81:	ff d0                	call   *%eax
  800b83:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800b86:	83 ec 08             	sub    $0x8,%esp
  800b89:	ff 75 0c             	pushl  0xc(%ebp)
  800b8c:	6a 58                	push   $0x58
  800b8e:	8b 45 08             	mov    0x8(%ebp),%eax
  800b91:	ff d0                	call   *%eax
  800b93:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800b96:	83 ec 08             	sub    $0x8,%esp
  800b99:	ff 75 0c             	pushl  0xc(%ebp)
  800b9c:	6a 58                	push   $0x58
  800b9e:	8b 45 08             	mov    0x8(%ebp),%eax
  800ba1:	ff d0                	call   *%eax
  800ba3:	83 c4 10             	add    $0x10,%esp
			break;
  800ba6:	e9 ce 00 00 00       	jmp    800c79 <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  800bab:	83 ec 08             	sub    $0x8,%esp
  800bae:	ff 75 0c             	pushl  0xc(%ebp)
  800bb1:	6a 30                	push   $0x30
  800bb3:	8b 45 08             	mov    0x8(%ebp),%eax
  800bb6:	ff d0                	call   *%eax
  800bb8:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800bbb:	83 ec 08             	sub    $0x8,%esp
  800bbe:	ff 75 0c             	pushl  0xc(%ebp)
  800bc1:	6a 78                	push   $0x78
  800bc3:	8b 45 08             	mov    0x8(%ebp),%eax
  800bc6:	ff d0                	call   *%eax
  800bc8:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800bcb:	8b 45 14             	mov    0x14(%ebp),%eax
  800bce:	83 c0 04             	add    $0x4,%eax
  800bd1:	89 45 14             	mov    %eax,0x14(%ebp)
  800bd4:	8b 45 14             	mov    0x14(%ebp),%eax
  800bd7:	83 e8 04             	sub    $0x4,%eax
  800bda:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800bdc:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800bdf:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800be6:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800bed:	eb 1f                	jmp    800c0e <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800bef:	83 ec 08             	sub    $0x8,%esp
  800bf2:	ff 75 e8             	pushl  -0x18(%ebp)
  800bf5:	8d 45 14             	lea    0x14(%ebp),%eax
  800bf8:	50                   	push   %eax
  800bf9:	e8 e7 fb ff ff       	call   8007e5 <getuint>
  800bfe:	83 c4 10             	add    $0x10,%esp
  800c01:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c04:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800c07:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800c0e:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800c12:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800c15:	83 ec 04             	sub    $0x4,%esp
  800c18:	52                   	push   %edx
  800c19:	ff 75 e4             	pushl  -0x1c(%ebp)
  800c1c:	50                   	push   %eax
  800c1d:	ff 75 f4             	pushl  -0xc(%ebp)
  800c20:	ff 75 f0             	pushl  -0x10(%ebp)
  800c23:	ff 75 0c             	pushl  0xc(%ebp)
  800c26:	ff 75 08             	pushl  0x8(%ebp)
  800c29:	e8 00 fb ff ff       	call   80072e <printnum>
  800c2e:	83 c4 20             	add    $0x20,%esp
			break;
  800c31:	eb 46                	jmp    800c79 <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800c33:	83 ec 08             	sub    $0x8,%esp
  800c36:	ff 75 0c             	pushl  0xc(%ebp)
  800c39:	53                   	push   %ebx
  800c3a:	8b 45 08             	mov    0x8(%ebp),%eax
  800c3d:	ff d0                	call   *%eax
  800c3f:	83 c4 10             	add    $0x10,%esp
			break;
  800c42:	eb 35                	jmp    800c79 <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  800c44:	c6 05 44 40 80 00 00 	movb   $0x0,0x804044
			break;
  800c4b:	eb 2c                	jmp    800c79 <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  800c4d:	c6 05 44 40 80 00 01 	movb   $0x1,0x804044
			break;
  800c54:	eb 23                	jmp    800c79 <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800c56:	83 ec 08             	sub    $0x8,%esp
  800c59:	ff 75 0c             	pushl  0xc(%ebp)
  800c5c:	6a 25                	push   $0x25
  800c5e:	8b 45 08             	mov    0x8(%ebp),%eax
  800c61:	ff d0                	call   *%eax
  800c63:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800c66:	ff 4d 10             	decl   0x10(%ebp)
  800c69:	eb 03                	jmp    800c6e <vprintfmt+0x3c3>
  800c6b:	ff 4d 10             	decl   0x10(%ebp)
  800c6e:	8b 45 10             	mov    0x10(%ebp),%eax
  800c71:	48                   	dec    %eax
  800c72:	8a 00                	mov    (%eax),%al
  800c74:	3c 25                	cmp    $0x25,%al
  800c76:	75 f3                	jne    800c6b <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  800c78:	90                   	nop
		}
	}
  800c79:	e9 35 fc ff ff       	jmp    8008b3 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800c7e:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800c7f:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800c82:	5b                   	pop    %ebx
  800c83:	5e                   	pop    %esi
  800c84:	5d                   	pop    %ebp
  800c85:	c3                   	ret    

00800c86 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800c86:	55                   	push   %ebp
  800c87:	89 e5                	mov    %esp,%ebp
  800c89:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800c8c:	8d 45 10             	lea    0x10(%ebp),%eax
  800c8f:	83 c0 04             	add    $0x4,%eax
  800c92:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800c95:	8b 45 10             	mov    0x10(%ebp),%eax
  800c98:	ff 75 f4             	pushl  -0xc(%ebp)
  800c9b:	50                   	push   %eax
  800c9c:	ff 75 0c             	pushl  0xc(%ebp)
  800c9f:	ff 75 08             	pushl  0x8(%ebp)
  800ca2:	e8 04 fc ff ff       	call   8008ab <vprintfmt>
  800ca7:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800caa:	90                   	nop
  800cab:	c9                   	leave  
  800cac:	c3                   	ret    

00800cad <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800cad:	55                   	push   %ebp
  800cae:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800cb0:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cb3:	8b 40 08             	mov    0x8(%eax),%eax
  800cb6:	8d 50 01             	lea    0x1(%eax),%edx
  800cb9:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cbc:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800cbf:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cc2:	8b 10                	mov    (%eax),%edx
  800cc4:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cc7:	8b 40 04             	mov    0x4(%eax),%eax
  800cca:	39 c2                	cmp    %eax,%edx
  800ccc:	73 12                	jae    800ce0 <sprintputch+0x33>
		*b->buf++ = ch;
  800cce:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cd1:	8b 00                	mov    (%eax),%eax
  800cd3:	8d 48 01             	lea    0x1(%eax),%ecx
  800cd6:	8b 55 0c             	mov    0xc(%ebp),%edx
  800cd9:	89 0a                	mov    %ecx,(%edx)
  800cdb:	8b 55 08             	mov    0x8(%ebp),%edx
  800cde:	88 10                	mov    %dl,(%eax)
}
  800ce0:	90                   	nop
  800ce1:	5d                   	pop    %ebp
  800ce2:	c3                   	ret    

00800ce3 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800ce3:	55                   	push   %ebp
  800ce4:	89 e5                	mov    %esp,%ebp
  800ce6:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800ce9:	8b 45 08             	mov    0x8(%ebp),%eax
  800cec:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800cef:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cf2:	8d 50 ff             	lea    -0x1(%eax),%edx
  800cf5:	8b 45 08             	mov    0x8(%ebp),%eax
  800cf8:	01 d0                	add    %edx,%eax
  800cfa:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800cfd:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800d04:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800d08:	74 06                	je     800d10 <vsnprintf+0x2d>
  800d0a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800d0e:	7f 07                	jg     800d17 <vsnprintf+0x34>
		return -E_INVAL;
  800d10:	b8 03 00 00 00       	mov    $0x3,%eax
  800d15:	eb 20                	jmp    800d37 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800d17:	ff 75 14             	pushl  0x14(%ebp)
  800d1a:	ff 75 10             	pushl  0x10(%ebp)
  800d1d:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800d20:	50                   	push   %eax
  800d21:	68 ad 0c 80 00       	push   $0x800cad
  800d26:	e8 80 fb ff ff       	call   8008ab <vprintfmt>
  800d2b:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800d2e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800d31:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800d34:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800d37:	c9                   	leave  
  800d38:	c3                   	ret    

00800d39 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800d39:	55                   	push   %ebp
  800d3a:	89 e5                	mov    %esp,%ebp
  800d3c:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800d3f:	8d 45 10             	lea    0x10(%ebp),%eax
  800d42:	83 c0 04             	add    $0x4,%eax
  800d45:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800d48:	8b 45 10             	mov    0x10(%ebp),%eax
  800d4b:	ff 75 f4             	pushl  -0xc(%ebp)
  800d4e:	50                   	push   %eax
  800d4f:	ff 75 0c             	pushl  0xc(%ebp)
  800d52:	ff 75 08             	pushl  0x8(%ebp)
  800d55:	e8 89 ff ff ff       	call   800ce3 <vsnprintf>
  800d5a:	83 c4 10             	add    $0x10,%esp
  800d5d:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800d60:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800d63:	c9                   	leave  
  800d64:	c3                   	ret    

00800d65 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800d65:	55                   	push   %ebp
  800d66:	89 e5                	mov    %esp,%ebp
  800d68:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800d6b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800d72:	eb 06                	jmp    800d7a <strlen+0x15>
		n++;
  800d74:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800d77:	ff 45 08             	incl   0x8(%ebp)
  800d7a:	8b 45 08             	mov    0x8(%ebp),%eax
  800d7d:	8a 00                	mov    (%eax),%al
  800d7f:	84 c0                	test   %al,%al
  800d81:	75 f1                	jne    800d74 <strlen+0xf>
		n++;
	return n;
  800d83:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800d86:	c9                   	leave  
  800d87:	c3                   	ret    

00800d88 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800d88:	55                   	push   %ebp
  800d89:	89 e5                	mov    %esp,%ebp
  800d8b:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800d8e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800d95:	eb 09                	jmp    800da0 <strnlen+0x18>
		n++;
  800d97:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800d9a:	ff 45 08             	incl   0x8(%ebp)
  800d9d:	ff 4d 0c             	decl   0xc(%ebp)
  800da0:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800da4:	74 09                	je     800daf <strnlen+0x27>
  800da6:	8b 45 08             	mov    0x8(%ebp),%eax
  800da9:	8a 00                	mov    (%eax),%al
  800dab:	84 c0                	test   %al,%al
  800dad:	75 e8                	jne    800d97 <strnlen+0xf>
		n++;
	return n;
  800daf:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800db2:	c9                   	leave  
  800db3:	c3                   	ret    

00800db4 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800db4:	55                   	push   %ebp
  800db5:	89 e5                	mov    %esp,%ebp
  800db7:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800dba:	8b 45 08             	mov    0x8(%ebp),%eax
  800dbd:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800dc0:	90                   	nop
  800dc1:	8b 45 08             	mov    0x8(%ebp),%eax
  800dc4:	8d 50 01             	lea    0x1(%eax),%edx
  800dc7:	89 55 08             	mov    %edx,0x8(%ebp)
  800dca:	8b 55 0c             	mov    0xc(%ebp),%edx
  800dcd:	8d 4a 01             	lea    0x1(%edx),%ecx
  800dd0:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800dd3:	8a 12                	mov    (%edx),%dl
  800dd5:	88 10                	mov    %dl,(%eax)
  800dd7:	8a 00                	mov    (%eax),%al
  800dd9:	84 c0                	test   %al,%al
  800ddb:	75 e4                	jne    800dc1 <strcpy+0xd>
		/* do nothing */;
	return ret;
  800ddd:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800de0:	c9                   	leave  
  800de1:	c3                   	ret    

00800de2 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800de2:	55                   	push   %ebp
  800de3:	89 e5                	mov    %esp,%ebp
  800de5:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800de8:	8b 45 08             	mov    0x8(%ebp),%eax
  800deb:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800dee:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800df5:	eb 1f                	jmp    800e16 <strncpy+0x34>
		*dst++ = *src;
  800df7:	8b 45 08             	mov    0x8(%ebp),%eax
  800dfa:	8d 50 01             	lea    0x1(%eax),%edx
  800dfd:	89 55 08             	mov    %edx,0x8(%ebp)
  800e00:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e03:	8a 12                	mov    (%edx),%dl
  800e05:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800e07:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e0a:	8a 00                	mov    (%eax),%al
  800e0c:	84 c0                	test   %al,%al
  800e0e:	74 03                	je     800e13 <strncpy+0x31>
			src++;
  800e10:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800e13:	ff 45 fc             	incl   -0x4(%ebp)
  800e16:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e19:	3b 45 10             	cmp    0x10(%ebp),%eax
  800e1c:	72 d9                	jb     800df7 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800e1e:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800e21:	c9                   	leave  
  800e22:	c3                   	ret    

00800e23 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800e23:	55                   	push   %ebp
  800e24:	89 e5                	mov    %esp,%ebp
  800e26:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800e29:	8b 45 08             	mov    0x8(%ebp),%eax
  800e2c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800e2f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e33:	74 30                	je     800e65 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800e35:	eb 16                	jmp    800e4d <strlcpy+0x2a>
			*dst++ = *src++;
  800e37:	8b 45 08             	mov    0x8(%ebp),%eax
  800e3a:	8d 50 01             	lea    0x1(%eax),%edx
  800e3d:	89 55 08             	mov    %edx,0x8(%ebp)
  800e40:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e43:	8d 4a 01             	lea    0x1(%edx),%ecx
  800e46:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800e49:	8a 12                	mov    (%edx),%dl
  800e4b:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800e4d:	ff 4d 10             	decl   0x10(%ebp)
  800e50:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e54:	74 09                	je     800e5f <strlcpy+0x3c>
  800e56:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e59:	8a 00                	mov    (%eax),%al
  800e5b:	84 c0                	test   %al,%al
  800e5d:	75 d8                	jne    800e37 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800e5f:	8b 45 08             	mov    0x8(%ebp),%eax
  800e62:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800e65:	8b 55 08             	mov    0x8(%ebp),%edx
  800e68:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e6b:	29 c2                	sub    %eax,%edx
  800e6d:	89 d0                	mov    %edx,%eax
}
  800e6f:	c9                   	leave  
  800e70:	c3                   	ret    

00800e71 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800e71:	55                   	push   %ebp
  800e72:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800e74:	eb 06                	jmp    800e7c <strcmp+0xb>
		p++, q++;
  800e76:	ff 45 08             	incl   0x8(%ebp)
  800e79:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800e7c:	8b 45 08             	mov    0x8(%ebp),%eax
  800e7f:	8a 00                	mov    (%eax),%al
  800e81:	84 c0                	test   %al,%al
  800e83:	74 0e                	je     800e93 <strcmp+0x22>
  800e85:	8b 45 08             	mov    0x8(%ebp),%eax
  800e88:	8a 10                	mov    (%eax),%dl
  800e8a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e8d:	8a 00                	mov    (%eax),%al
  800e8f:	38 c2                	cmp    %al,%dl
  800e91:	74 e3                	je     800e76 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800e93:	8b 45 08             	mov    0x8(%ebp),%eax
  800e96:	8a 00                	mov    (%eax),%al
  800e98:	0f b6 d0             	movzbl %al,%edx
  800e9b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e9e:	8a 00                	mov    (%eax),%al
  800ea0:	0f b6 c0             	movzbl %al,%eax
  800ea3:	29 c2                	sub    %eax,%edx
  800ea5:	89 d0                	mov    %edx,%eax
}
  800ea7:	5d                   	pop    %ebp
  800ea8:	c3                   	ret    

00800ea9 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800ea9:	55                   	push   %ebp
  800eaa:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800eac:	eb 09                	jmp    800eb7 <strncmp+0xe>
		n--, p++, q++;
  800eae:	ff 4d 10             	decl   0x10(%ebp)
  800eb1:	ff 45 08             	incl   0x8(%ebp)
  800eb4:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800eb7:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ebb:	74 17                	je     800ed4 <strncmp+0x2b>
  800ebd:	8b 45 08             	mov    0x8(%ebp),%eax
  800ec0:	8a 00                	mov    (%eax),%al
  800ec2:	84 c0                	test   %al,%al
  800ec4:	74 0e                	je     800ed4 <strncmp+0x2b>
  800ec6:	8b 45 08             	mov    0x8(%ebp),%eax
  800ec9:	8a 10                	mov    (%eax),%dl
  800ecb:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ece:	8a 00                	mov    (%eax),%al
  800ed0:	38 c2                	cmp    %al,%dl
  800ed2:	74 da                	je     800eae <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800ed4:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ed8:	75 07                	jne    800ee1 <strncmp+0x38>
		return 0;
  800eda:	b8 00 00 00 00       	mov    $0x0,%eax
  800edf:	eb 14                	jmp    800ef5 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800ee1:	8b 45 08             	mov    0x8(%ebp),%eax
  800ee4:	8a 00                	mov    (%eax),%al
  800ee6:	0f b6 d0             	movzbl %al,%edx
  800ee9:	8b 45 0c             	mov    0xc(%ebp),%eax
  800eec:	8a 00                	mov    (%eax),%al
  800eee:	0f b6 c0             	movzbl %al,%eax
  800ef1:	29 c2                	sub    %eax,%edx
  800ef3:	89 d0                	mov    %edx,%eax
}
  800ef5:	5d                   	pop    %ebp
  800ef6:	c3                   	ret    

00800ef7 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800ef7:	55                   	push   %ebp
  800ef8:	89 e5                	mov    %esp,%ebp
  800efa:	83 ec 04             	sub    $0x4,%esp
  800efd:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f00:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800f03:	eb 12                	jmp    800f17 <strchr+0x20>
		if (*s == c)
  800f05:	8b 45 08             	mov    0x8(%ebp),%eax
  800f08:	8a 00                	mov    (%eax),%al
  800f0a:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800f0d:	75 05                	jne    800f14 <strchr+0x1d>
			return (char *) s;
  800f0f:	8b 45 08             	mov    0x8(%ebp),%eax
  800f12:	eb 11                	jmp    800f25 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800f14:	ff 45 08             	incl   0x8(%ebp)
  800f17:	8b 45 08             	mov    0x8(%ebp),%eax
  800f1a:	8a 00                	mov    (%eax),%al
  800f1c:	84 c0                	test   %al,%al
  800f1e:	75 e5                	jne    800f05 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800f20:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800f25:	c9                   	leave  
  800f26:	c3                   	ret    

00800f27 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800f27:	55                   	push   %ebp
  800f28:	89 e5                	mov    %esp,%ebp
  800f2a:	83 ec 04             	sub    $0x4,%esp
  800f2d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f30:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800f33:	eb 0d                	jmp    800f42 <strfind+0x1b>
		if (*s == c)
  800f35:	8b 45 08             	mov    0x8(%ebp),%eax
  800f38:	8a 00                	mov    (%eax),%al
  800f3a:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800f3d:	74 0e                	je     800f4d <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800f3f:	ff 45 08             	incl   0x8(%ebp)
  800f42:	8b 45 08             	mov    0x8(%ebp),%eax
  800f45:	8a 00                	mov    (%eax),%al
  800f47:	84 c0                	test   %al,%al
  800f49:	75 ea                	jne    800f35 <strfind+0xe>
  800f4b:	eb 01                	jmp    800f4e <strfind+0x27>
		if (*s == c)
			break;
  800f4d:	90                   	nop
	return (char *) s;
  800f4e:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f51:	c9                   	leave  
  800f52:	c3                   	ret    

00800f53 <memset>:

// *************** The faster implementation of memset & memcpy is implemented by *************
// ****************** Team80 (Yahia Khaled, Malek Ahmed et al) - FCIS'24-25 *******************
void *
memset(void *v, int c, uint32 n)
{
  800f53:	55                   	push   %ebp
  800f54:	89 e5                	mov    %esp,%ebp
  800f56:	83 ec 10             	sub    $0x10,%esp
//	m = n;
//	while (--m >= 0)
//		*p++ = c;

	/*Faster Implementation*/
	uint64* p64 = (uint64*)v;
  800f59:	8b 45 08             	mov    0x8(%ebp),%eax
  800f5c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if(n >= 8){
  800f5f:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800f63:	76 63                	jbe    800fc8 <memset+0x75>
		uint64 data_block = c;
  800f65:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f68:	99                   	cltd   
  800f69:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800f6c:	89 55 f4             	mov    %edx,-0xc(%ebp)
		data_block |= data_block << 8;
  800f6f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800f72:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800f75:	0f a4 c2 08          	shld   $0x8,%eax,%edx
  800f79:	c1 e0 08             	shl    $0x8,%eax
  800f7c:	09 45 f0             	or     %eax,-0x10(%ebp)
  800f7f:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 16;
  800f82:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800f85:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800f88:	0f a4 c2 10          	shld   $0x10,%eax,%edx
  800f8c:	c1 e0 10             	shl    $0x10,%eax
  800f8f:	09 45 f0             	or     %eax,-0x10(%ebp)
  800f92:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 32;
  800f95:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800f98:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800f9b:	89 c2                	mov    %eax,%edx
  800f9d:	b8 00 00 00 00       	mov    $0x0,%eax
  800fa2:	09 45 f0             	or     %eax,-0x10(%ebp)
  800fa5:	09 55 f4             	or     %edx,-0xc(%ebp)

		while(n >= 8)
  800fa8:	eb 18                	jmp    800fc2 <memset+0x6f>
			*p64++ = data_block, n -= 8;
  800faa:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  800fad:	8d 41 08             	lea    0x8(%ecx),%eax
  800fb0:	89 45 fc             	mov    %eax,-0x4(%ebp)
  800fb3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800fb6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800fb9:	89 01                	mov    %eax,(%ecx)
  800fbb:	89 51 04             	mov    %edx,0x4(%ecx)
  800fbe:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
		uint64 data_block = c;
		data_block |= data_block << 8;
		data_block |= data_block << 16;
		data_block |= data_block << 32;

		while(n >= 8)
  800fc2:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800fc6:	77 e2                	ja     800faa <memset+0x57>
			*p64++ = data_block, n -= 8;
	}

	if(n){
  800fc8:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800fcc:	74 23                	je     800ff1 <memset+0x9e>
		uint8* p8 = (uint8*)p64;
  800fce:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800fd1:	89 45 f8             	mov    %eax,-0x8(%ebp)
		while (n-- > 0)
  800fd4:	eb 0e                	jmp    800fe4 <memset+0x91>
			*p8++ = (uint8)c;
  800fd6:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800fd9:	8d 50 01             	lea    0x1(%eax),%edx
  800fdc:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800fdf:	8b 55 0c             	mov    0xc(%ebp),%edx
  800fe2:	88 10                	mov    %dl,(%eax)
			*p64++ = data_block, n -= 8;
	}

	if(n){
		uint8* p8 = (uint8*)p64;
		while (n-- > 0)
  800fe4:	8b 45 10             	mov    0x10(%ebp),%eax
  800fe7:	8d 50 ff             	lea    -0x1(%eax),%edx
  800fea:	89 55 10             	mov    %edx,0x10(%ebp)
  800fed:	85 c0                	test   %eax,%eax
  800fef:	75 e5                	jne    800fd6 <memset+0x83>
			*p8++ = (uint8)c;
	}

	return v;
  800ff1:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800ff4:	c9                   	leave  
  800ff5:	c3                   	ret    

00800ff6 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800ff6:	55                   	push   %ebp
  800ff7:	89 e5                	mov    %esp,%ebp
  800ff9:	83 ec 10             	sub    $0x10,%esp
	//	s = src;
	//	d = dst;
	//	while (n-- > 0)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
  800ffc:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fff:	89 45 fc             	mov    %eax,-0x4(%ebp)
	uint64* d64 = (uint64*)dst;
  801002:	8b 45 08             	mov    0x8(%ebp),%eax
  801005:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if(n >= 8){
  801008:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  80100c:	76 24                	jbe    801032 <memcpy+0x3c>
		while(n >= 8){
  80100e:	eb 1c                	jmp    80102c <memcpy+0x36>
			*d64 = *s64;
  801010:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801013:	8b 50 04             	mov    0x4(%eax),%edx
  801016:	8b 00                	mov    (%eax),%eax
  801018:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  80101b:	89 01                	mov    %eax,(%ecx)
  80101d:	89 51 04             	mov    %edx,0x4(%ecx)
			n -= 8;
  801020:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
			++s64;
  801024:	83 45 fc 08          	addl   $0x8,-0x4(%ebp)
			++d64;
  801028:	83 45 f8 08          	addl   $0x8,-0x8(%ebp)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
	uint64* d64 = (uint64*)dst;
	if(n >= 8){
		while(n >= 8){
  80102c:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  801030:	77 de                	ja     801010 <memcpy+0x1a>
			++s64;
			++d64;
		}
	}

	if(n){
  801032:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801036:	74 31                	je     801069 <memcpy+0x73>
		uint8* s8 = (uint8*)s64;
  801038:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80103b:	89 45 f4             	mov    %eax,-0xc(%ebp)
		uint8* d8 = (uint8*)d64;
  80103e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801041:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (n-- > 0)
  801044:	eb 16                	jmp    80105c <memcpy+0x66>
			*d8++ = *s8++;
  801046:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801049:	8d 50 01             	lea    0x1(%eax),%edx
  80104c:	89 55 f0             	mov    %edx,-0x10(%ebp)
  80104f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801052:	8d 4a 01             	lea    0x1(%edx),%ecx
  801055:	89 4d f4             	mov    %ecx,-0xc(%ebp)
  801058:	8a 12                	mov    (%edx),%dl
  80105a:	88 10                	mov    %dl,(%eax)
	}

	if(n){
		uint8* s8 = (uint8*)s64;
		uint8* d8 = (uint8*)d64;
		while (n-- > 0)
  80105c:	8b 45 10             	mov    0x10(%ebp),%eax
  80105f:	8d 50 ff             	lea    -0x1(%eax),%edx
  801062:	89 55 10             	mov    %edx,0x10(%ebp)
  801065:	85 c0                	test   %eax,%eax
  801067:	75 dd                	jne    801046 <memcpy+0x50>
			*d8++ = *s8++;
	}
	return dst;
  801069:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80106c:	c9                   	leave  
  80106d:	c3                   	ret    

0080106e <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  80106e:	55                   	push   %ebp
  80106f:	89 e5                	mov    %esp,%ebp
  801071:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801074:	8b 45 0c             	mov    0xc(%ebp),%eax
  801077:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  80107a:	8b 45 08             	mov    0x8(%ebp),%eax
  80107d:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  801080:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801083:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801086:	73 50                	jae    8010d8 <memmove+0x6a>
  801088:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80108b:	8b 45 10             	mov    0x10(%ebp),%eax
  80108e:	01 d0                	add    %edx,%eax
  801090:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801093:	76 43                	jbe    8010d8 <memmove+0x6a>
		s += n;
  801095:	8b 45 10             	mov    0x10(%ebp),%eax
  801098:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  80109b:	8b 45 10             	mov    0x10(%ebp),%eax
  80109e:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  8010a1:	eb 10                	jmp    8010b3 <memmove+0x45>
			*--d = *--s;
  8010a3:	ff 4d f8             	decl   -0x8(%ebp)
  8010a6:	ff 4d fc             	decl   -0x4(%ebp)
  8010a9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8010ac:	8a 10                	mov    (%eax),%dl
  8010ae:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010b1:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  8010b3:	8b 45 10             	mov    0x10(%ebp),%eax
  8010b6:	8d 50 ff             	lea    -0x1(%eax),%edx
  8010b9:	89 55 10             	mov    %edx,0x10(%ebp)
  8010bc:	85 c0                	test   %eax,%eax
  8010be:	75 e3                	jne    8010a3 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  8010c0:	eb 23                	jmp    8010e5 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  8010c2:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010c5:	8d 50 01             	lea    0x1(%eax),%edx
  8010c8:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8010cb:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8010ce:	8d 4a 01             	lea    0x1(%edx),%ecx
  8010d1:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  8010d4:	8a 12                	mov    (%edx),%dl
  8010d6:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  8010d8:	8b 45 10             	mov    0x10(%ebp),%eax
  8010db:	8d 50 ff             	lea    -0x1(%eax),%edx
  8010de:	89 55 10             	mov    %edx,0x10(%ebp)
  8010e1:	85 c0                	test   %eax,%eax
  8010e3:	75 dd                	jne    8010c2 <memmove+0x54>
			*d++ = *s++;

	return dst;
  8010e5:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8010e8:	c9                   	leave  
  8010e9:	c3                   	ret    

008010ea <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  8010ea:	55                   	push   %ebp
  8010eb:	89 e5                	mov    %esp,%ebp
  8010ed:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  8010f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8010f3:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  8010f6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010f9:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  8010fc:	eb 2a                	jmp    801128 <memcmp+0x3e>
		if (*s1 != *s2)
  8010fe:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801101:	8a 10                	mov    (%eax),%dl
  801103:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801106:	8a 00                	mov    (%eax),%al
  801108:	38 c2                	cmp    %al,%dl
  80110a:	74 16                	je     801122 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  80110c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80110f:	8a 00                	mov    (%eax),%al
  801111:	0f b6 d0             	movzbl %al,%edx
  801114:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801117:	8a 00                	mov    (%eax),%al
  801119:	0f b6 c0             	movzbl %al,%eax
  80111c:	29 c2                	sub    %eax,%edx
  80111e:	89 d0                	mov    %edx,%eax
  801120:	eb 18                	jmp    80113a <memcmp+0x50>
		s1++, s2++;
  801122:	ff 45 fc             	incl   -0x4(%ebp)
  801125:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  801128:	8b 45 10             	mov    0x10(%ebp),%eax
  80112b:	8d 50 ff             	lea    -0x1(%eax),%edx
  80112e:	89 55 10             	mov    %edx,0x10(%ebp)
  801131:	85 c0                	test   %eax,%eax
  801133:	75 c9                	jne    8010fe <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801135:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80113a:	c9                   	leave  
  80113b:	c3                   	ret    

0080113c <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  80113c:	55                   	push   %ebp
  80113d:	89 e5                	mov    %esp,%ebp
  80113f:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  801142:	8b 55 08             	mov    0x8(%ebp),%edx
  801145:	8b 45 10             	mov    0x10(%ebp),%eax
  801148:	01 d0                	add    %edx,%eax
  80114a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  80114d:	eb 15                	jmp    801164 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  80114f:	8b 45 08             	mov    0x8(%ebp),%eax
  801152:	8a 00                	mov    (%eax),%al
  801154:	0f b6 d0             	movzbl %al,%edx
  801157:	8b 45 0c             	mov    0xc(%ebp),%eax
  80115a:	0f b6 c0             	movzbl %al,%eax
  80115d:	39 c2                	cmp    %eax,%edx
  80115f:	74 0d                	je     80116e <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801161:	ff 45 08             	incl   0x8(%ebp)
  801164:	8b 45 08             	mov    0x8(%ebp),%eax
  801167:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  80116a:	72 e3                	jb     80114f <memfind+0x13>
  80116c:	eb 01                	jmp    80116f <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  80116e:	90                   	nop
	return (void *) s;
  80116f:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801172:	c9                   	leave  
  801173:	c3                   	ret    

00801174 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801174:	55                   	push   %ebp
  801175:	89 e5                	mov    %esp,%ebp
  801177:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  80117a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  801181:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801188:	eb 03                	jmp    80118d <strtol+0x19>
		s++;
  80118a:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80118d:	8b 45 08             	mov    0x8(%ebp),%eax
  801190:	8a 00                	mov    (%eax),%al
  801192:	3c 20                	cmp    $0x20,%al
  801194:	74 f4                	je     80118a <strtol+0x16>
  801196:	8b 45 08             	mov    0x8(%ebp),%eax
  801199:	8a 00                	mov    (%eax),%al
  80119b:	3c 09                	cmp    $0x9,%al
  80119d:	74 eb                	je     80118a <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  80119f:	8b 45 08             	mov    0x8(%ebp),%eax
  8011a2:	8a 00                	mov    (%eax),%al
  8011a4:	3c 2b                	cmp    $0x2b,%al
  8011a6:	75 05                	jne    8011ad <strtol+0x39>
		s++;
  8011a8:	ff 45 08             	incl   0x8(%ebp)
  8011ab:	eb 13                	jmp    8011c0 <strtol+0x4c>
	else if (*s == '-')
  8011ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8011b0:	8a 00                	mov    (%eax),%al
  8011b2:	3c 2d                	cmp    $0x2d,%al
  8011b4:	75 0a                	jne    8011c0 <strtol+0x4c>
		s++, neg = 1;
  8011b6:	ff 45 08             	incl   0x8(%ebp)
  8011b9:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8011c0:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8011c4:	74 06                	je     8011cc <strtol+0x58>
  8011c6:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  8011ca:	75 20                	jne    8011ec <strtol+0x78>
  8011cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8011cf:	8a 00                	mov    (%eax),%al
  8011d1:	3c 30                	cmp    $0x30,%al
  8011d3:	75 17                	jne    8011ec <strtol+0x78>
  8011d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8011d8:	40                   	inc    %eax
  8011d9:	8a 00                	mov    (%eax),%al
  8011db:	3c 78                	cmp    $0x78,%al
  8011dd:	75 0d                	jne    8011ec <strtol+0x78>
		s += 2, base = 16;
  8011df:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  8011e3:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  8011ea:	eb 28                	jmp    801214 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  8011ec:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8011f0:	75 15                	jne    801207 <strtol+0x93>
  8011f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8011f5:	8a 00                	mov    (%eax),%al
  8011f7:	3c 30                	cmp    $0x30,%al
  8011f9:	75 0c                	jne    801207 <strtol+0x93>
		s++, base = 8;
  8011fb:	ff 45 08             	incl   0x8(%ebp)
  8011fe:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  801205:	eb 0d                	jmp    801214 <strtol+0xa0>
	else if (base == 0)
  801207:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80120b:	75 07                	jne    801214 <strtol+0xa0>
		base = 10;
  80120d:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801214:	8b 45 08             	mov    0x8(%ebp),%eax
  801217:	8a 00                	mov    (%eax),%al
  801219:	3c 2f                	cmp    $0x2f,%al
  80121b:	7e 19                	jle    801236 <strtol+0xc2>
  80121d:	8b 45 08             	mov    0x8(%ebp),%eax
  801220:	8a 00                	mov    (%eax),%al
  801222:	3c 39                	cmp    $0x39,%al
  801224:	7f 10                	jg     801236 <strtol+0xc2>
			dig = *s - '0';
  801226:	8b 45 08             	mov    0x8(%ebp),%eax
  801229:	8a 00                	mov    (%eax),%al
  80122b:	0f be c0             	movsbl %al,%eax
  80122e:	83 e8 30             	sub    $0x30,%eax
  801231:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801234:	eb 42                	jmp    801278 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  801236:	8b 45 08             	mov    0x8(%ebp),%eax
  801239:	8a 00                	mov    (%eax),%al
  80123b:	3c 60                	cmp    $0x60,%al
  80123d:	7e 19                	jle    801258 <strtol+0xe4>
  80123f:	8b 45 08             	mov    0x8(%ebp),%eax
  801242:	8a 00                	mov    (%eax),%al
  801244:	3c 7a                	cmp    $0x7a,%al
  801246:	7f 10                	jg     801258 <strtol+0xe4>
			dig = *s - 'a' + 10;
  801248:	8b 45 08             	mov    0x8(%ebp),%eax
  80124b:	8a 00                	mov    (%eax),%al
  80124d:	0f be c0             	movsbl %al,%eax
  801250:	83 e8 57             	sub    $0x57,%eax
  801253:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801256:	eb 20                	jmp    801278 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  801258:	8b 45 08             	mov    0x8(%ebp),%eax
  80125b:	8a 00                	mov    (%eax),%al
  80125d:	3c 40                	cmp    $0x40,%al
  80125f:	7e 39                	jle    80129a <strtol+0x126>
  801261:	8b 45 08             	mov    0x8(%ebp),%eax
  801264:	8a 00                	mov    (%eax),%al
  801266:	3c 5a                	cmp    $0x5a,%al
  801268:	7f 30                	jg     80129a <strtol+0x126>
			dig = *s - 'A' + 10;
  80126a:	8b 45 08             	mov    0x8(%ebp),%eax
  80126d:	8a 00                	mov    (%eax),%al
  80126f:	0f be c0             	movsbl %al,%eax
  801272:	83 e8 37             	sub    $0x37,%eax
  801275:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  801278:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80127b:	3b 45 10             	cmp    0x10(%ebp),%eax
  80127e:	7d 19                	jge    801299 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801280:	ff 45 08             	incl   0x8(%ebp)
  801283:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801286:	0f af 45 10          	imul   0x10(%ebp),%eax
  80128a:	89 c2                	mov    %eax,%edx
  80128c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80128f:	01 d0                	add    %edx,%eax
  801291:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  801294:	e9 7b ff ff ff       	jmp    801214 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801299:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  80129a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80129e:	74 08                	je     8012a8 <strtol+0x134>
		*endptr = (char *) s;
  8012a0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012a3:	8b 55 08             	mov    0x8(%ebp),%edx
  8012a6:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  8012a8:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8012ac:	74 07                	je     8012b5 <strtol+0x141>
  8012ae:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8012b1:	f7 d8                	neg    %eax
  8012b3:	eb 03                	jmp    8012b8 <strtol+0x144>
  8012b5:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8012b8:	c9                   	leave  
  8012b9:	c3                   	ret    

008012ba <ltostr>:

void
ltostr(long value, char *str)
{
  8012ba:	55                   	push   %ebp
  8012bb:	89 e5                	mov    %esp,%ebp
  8012bd:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  8012c0:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  8012c7:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  8012ce:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8012d2:	79 13                	jns    8012e7 <ltostr+0x2d>
	{
		neg = 1;
  8012d4:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  8012db:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012de:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  8012e1:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  8012e4:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  8012e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8012ea:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8012ef:	99                   	cltd   
  8012f0:	f7 f9                	idiv   %ecx
  8012f2:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  8012f5:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8012f8:	8d 50 01             	lea    0x1(%eax),%edx
  8012fb:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8012fe:	89 c2                	mov    %eax,%edx
  801300:	8b 45 0c             	mov    0xc(%ebp),%eax
  801303:	01 d0                	add    %edx,%eax
  801305:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801308:	83 c2 30             	add    $0x30,%edx
  80130b:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  80130d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801310:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801315:	f7 e9                	imul   %ecx
  801317:	c1 fa 02             	sar    $0x2,%edx
  80131a:	89 c8                	mov    %ecx,%eax
  80131c:	c1 f8 1f             	sar    $0x1f,%eax
  80131f:	29 c2                	sub    %eax,%edx
  801321:	89 d0                	mov    %edx,%eax
  801323:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  801326:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80132a:	75 bb                	jne    8012e7 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  80132c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801333:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801336:	48                   	dec    %eax
  801337:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  80133a:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80133e:	74 3d                	je     80137d <ltostr+0xc3>
		start = 1 ;
  801340:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  801347:	eb 34                	jmp    80137d <ltostr+0xc3>
	{
		char tmp = str[start] ;
  801349:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80134c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80134f:	01 d0                	add    %edx,%eax
  801351:	8a 00                	mov    (%eax),%al
  801353:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801356:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801359:	8b 45 0c             	mov    0xc(%ebp),%eax
  80135c:	01 c2                	add    %eax,%edx
  80135e:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801361:	8b 45 0c             	mov    0xc(%ebp),%eax
  801364:	01 c8                	add    %ecx,%eax
  801366:	8a 00                	mov    (%eax),%al
  801368:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  80136a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80136d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801370:	01 c2                	add    %eax,%edx
  801372:	8a 45 eb             	mov    -0x15(%ebp),%al
  801375:	88 02                	mov    %al,(%edx)
		start++ ;
  801377:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  80137a:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  80137d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801380:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801383:	7c c4                	jl     801349 <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801385:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801388:	8b 45 0c             	mov    0xc(%ebp),%eax
  80138b:	01 d0                	add    %edx,%eax
  80138d:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801390:	90                   	nop
  801391:	c9                   	leave  
  801392:	c3                   	ret    

00801393 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  801393:	55                   	push   %ebp
  801394:	89 e5                	mov    %esp,%ebp
  801396:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801399:	ff 75 08             	pushl  0x8(%ebp)
  80139c:	e8 c4 f9 ff ff       	call   800d65 <strlen>
  8013a1:	83 c4 04             	add    $0x4,%esp
  8013a4:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  8013a7:	ff 75 0c             	pushl  0xc(%ebp)
  8013aa:	e8 b6 f9 ff ff       	call   800d65 <strlen>
  8013af:	83 c4 04             	add    $0x4,%esp
  8013b2:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  8013b5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  8013bc:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8013c3:	eb 17                	jmp    8013dc <strcconcat+0x49>
		final[s] = str1[s] ;
  8013c5:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8013c8:	8b 45 10             	mov    0x10(%ebp),%eax
  8013cb:	01 c2                	add    %eax,%edx
  8013cd:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8013d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8013d3:	01 c8                	add    %ecx,%eax
  8013d5:	8a 00                	mov    (%eax),%al
  8013d7:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  8013d9:	ff 45 fc             	incl   -0x4(%ebp)
  8013dc:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8013df:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8013e2:	7c e1                	jl     8013c5 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  8013e4:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  8013eb:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8013f2:	eb 1f                	jmp    801413 <strcconcat+0x80>
		final[s++] = str2[i] ;
  8013f4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8013f7:	8d 50 01             	lea    0x1(%eax),%edx
  8013fa:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8013fd:	89 c2                	mov    %eax,%edx
  8013ff:	8b 45 10             	mov    0x10(%ebp),%eax
  801402:	01 c2                	add    %eax,%edx
  801404:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801407:	8b 45 0c             	mov    0xc(%ebp),%eax
  80140a:	01 c8                	add    %ecx,%eax
  80140c:	8a 00                	mov    (%eax),%al
  80140e:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801410:	ff 45 f8             	incl   -0x8(%ebp)
  801413:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801416:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801419:	7c d9                	jl     8013f4 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  80141b:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80141e:	8b 45 10             	mov    0x10(%ebp),%eax
  801421:	01 d0                	add    %edx,%eax
  801423:	c6 00 00             	movb   $0x0,(%eax)
}
  801426:	90                   	nop
  801427:	c9                   	leave  
  801428:	c3                   	ret    

00801429 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801429:	55                   	push   %ebp
  80142a:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  80142c:	8b 45 14             	mov    0x14(%ebp),%eax
  80142f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801435:	8b 45 14             	mov    0x14(%ebp),%eax
  801438:	8b 00                	mov    (%eax),%eax
  80143a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801441:	8b 45 10             	mov    0x10(%ebp),%eax
  801444:	01 d0                	add    %edx,%eax
  801446:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80144c:	eb 0c                	jmp    80145a <strsplit+0x31>
			*string++ = 0;
  80144e:	8b 45 08             	mov    0x8(%ebp),%eax
  801451:	8d 50 01             	lea    0x1(%eax),%edx
  801454:	89 55 08             	mov    %edx,0x8(%ebp)
  801457:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80145a:	8b 45 08             	mov    0x8(%ebp),%eax
  80145d:	8a 00                	mov    (%eax),%al
  80145f:	84 c0                	test   %al,%al
  801461:	74 18                	je     80147b <strsplit+0x52>
  801463:	8b 45 08             	mov    0x8(%ebp),%eax
  801466:	8a 00                	mov    (%eax),%al
  801468:	0f be c0             	movsbl %al,%eax
  80146b:	50                   	push   %eax
  80146c:	ff 75 0c             	pushl  0xc(%ebp)
  80146f:	e8 83 fa ff ff       	call   800ef7 <strchr>
  801474:	83 c4 08             	add    $0x8,%esp
  801477:	85 c0                	test   %eax,%eax
  801479:	75 d3                	jne    80144e <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  80147b:	8b 45 08             	mov    0x8(%ebp),%eax
  80147e:	8a 00                	mov    (%eax),%al
  801480:	84 c0                	test   %al,%al
  801482:	74 5a                	je     8014de <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801484:	8b 45 14             	mov    0x14(%ebp),%eax
  801487:	8b 00                	mov    (%eax),%eax
  801489:	83 f8 0f             	cmp    $0xf,%eax
  80148c:	75 07                	jne    801495 <strsplit+0x6c>
		{
			return 0;
  80148e:	b8 00 00 00 00       	mov    $0x0,%eax
  801493:	eb 66                	jmp    8014fb <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801495:	8b 45 14             	mov    0x14(%ebp),%eax
  801498:	8b 00                	mov    (%eax),%eax
  80149a:	8d 48 01             	lea    0x1(%eax),%ecx
  80149d:	8b 55 14             	mov    0x14(%ebp),%edx
  8014a0:	89 0a                	mov    %ecx,(%edx)
  8014a2:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8014a9:	8b 45 10             	mov    0x10(%ebp),%eax
  8014ac:	01 c2                	add    %eax,%edx
  8014ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8014b1:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  8014b3:	eb 03                	jmp    8014b8 <strsplit+0x8f>
			string++;
  8014b5:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  8014b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8014bb:	8a 00                	mov    (%eax),%al
  8014bd:	84 c0                	test   %al,%al
  8014bf:	74 8b                	je     80144c <strsplit+0x23>
  8014c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8014c4:	8a 00                	mov    (%eax),%al
  8014c6:	0f be c0             	movsbl %al,%eax
  8014c9:	50                   	push   %eax
  8014ca:	ff 75 0c             	pushl  0xc(%ebp)
  8014cd:	e8 25 fa ff ff       	call   800ef7 <strchr>
  8014d2:	83 c4 08             	add    $0x8,%esp
  8014d5:	85 c0                	test   %eax,%eax
  8014d7:	74 dc                	je     8014b5 <strsplit+0x8c>
			string++;
	}
  8014d9:	e9 6e ff ff ff       	jmp    80144c <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  8014de:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  8014df:	8b 45 14             	mov    0x14(%ebp),%eax
  8014e2:	8b 00                	mov    (%eax),%eax
  8014e4:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8014eb:	8b 45 10             	mov    0x10(%ebp),%eax
  8014ee:	01 d0                	add    %edx,%eax
  8014f0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  8014f6:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8014fb:	c9                   	leave  
  8014fc:	c3                   	ret    

008014fd <str2lower>:


char* str2lower(char *dst, const char *src)
{
  8014fd:	55                   	push   %ebp
  8014fe:	89 e5                	mov    %esp,%ebp
  801500:	83 ec 10             	sub    $0x10,%esp
	char* ret = dst;
  801503:	8b 45 08             	mov    0x8(%ebp),%eax
  801506:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (int i = 0; i < strlen(src); ++i)
  801509:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801510:	eb 4a                	jmp    80155c <str2lower+0x5f>
	{
		dst[i] = src[i] ;
  801512:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801515:	8b 45 08             	mov    0x8(%ebp),%eax
  801518:	01 c2                	add    %eax,%edx
  80151a:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  80151d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801520:	01 c8                	add    %ecx,%eax
  801522:	8a 00                	mov    (%eax),%al
  801524:	88 02                	mov    %al,(%edx)
		if (src[i] >= 'A' && src[i] <= 'Z')
  801526:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801529:	8b 45 0c             	mov    0xc(%ebp),%eax
  80152c:	01 d0                	add    %edx,%eax
  80152e:	8a 00                	mov    (%eax),%al
  801530:	3c 40                	cmp    $0x40,%al
  801532:	7e 25                	jle    801559 <str2lower+0x5c>
  801534:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801537:	8b 45 0c             	mov    0xc(%ebp),%eax
  80153a:	01 d0                	add    %edx,%eax
  80153c:	8a 00                	mov    (%eax),%al
  80153e:	3c 5a                	cmp    $0x5a,%al
  801540:	7f 17                	jg     801559 <str2lower+0x5c>
		{
			dst[i] += 32 ;
  801542:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801545:	8b 45 08             	mov    0x8(%ebp),%eax
  801548:	01 d0                	add    %edx,%eax
  80154a:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  80154d:	8b 55 08             	mov    0x8(%ebp),%edx
  801550:	01 ca                	add    %ecx,%edx
  801552:	8a 12                	mov    (%edx),%dl
  801554:	83 c2 20             	add    $0x20,%edx
  801557:	88 10                	mov    %dl,(%eax)


char* str2lower(char *dst, const char *src)
{
	char* ret = dst;
	for (int i = 0; i < strlen(src); ++i)
  801559:	ff 45 fc             	incl   -0x4(%ebp)
  80155c:	ff 75 0c             	pushl  0xc(%ebp)
  80155f:	e8 01 f8 ff ff       	call   800d65 <strlen>
  801564:	83 c4 04             	add    $0x4,%esp
  801567:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  80156a:	7f a6                	jg     801512 <str2lower+0x15>
		if (src[i] >= 'A' && src[i] <= 'Z')
		{
			dst[i] += 32 ;
		}
	}
	return ret;
  80156c:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  80156f:	c9                   	leave  
  801570:	c3                   	ret    

00801571 <uheap_init>:
//==============================================
// [1] INITIALIZE USER HEAP:
//==============================================
int __firstTimeFlag = 1;
void uheap_init()
{
  801571:	55                   	push   %ebp
  801572:	89 e5                	mov    %esp,%ebp
  801574:	83 ec 08             	sub    $0x8,%esp
	if(__firstTimeFlag)
  801577:	a1 08 40 80 00       	mov    0x804008,%eax
  80157c:	85 c0                	test   %eax,%eax
  80157e:	74 42                	je     8015c2 <uheap_init+0x51>
	{
		initialize_dynamic_allocator(USER_HEAP_START, USER_HEAP_START + DYN_ALLOC_MAX_SIZE);
  801580:	83 ec 08             	sub    $0x8,%esp
  801583:	68 00 00 00 82       	push   $0x82000000
  801588:	68 00 00 00 80       	push   $0x80000000
  80158d:	e8 00 08 00 00       	call   801d92 <initialize_dynamic_allocator>
  801592:	83 c4 10             	add    $0x10,%esp
		uheapPlaceStrategy = sys_get_uheap_strategy();
  801595:	e8 e7 05 00 00       	call   801b81 <sys_get_uheap_strategy>
  80159a:	a3 60 c0 81 00       	mov    %eax,0x81c060
		uheapPageAllocStart = dynAllocEnd + PAGE_SIZE;
  80159f:	a1 40 40 80 00       	mov    0x804040,%eax
  8015a4:	05 00 10 00 00       	add    $0x1000,%eax
  8015a9:	a3 10 c1 81 00       	mov    %eax,0x81c110
		uheapPageAllocBreak = uheapPageAllocStart;
  8015ae:	a1 10 c1 81 00       	mov    0x81c110,%eax
  8015b3:	a3 68 c0 81 00       	mov    %eax,0x81c068

		__firstTimeFlag = 0;
  8015b8:	c7 05 08 40 80 00 00 	movl   $0x0,0x804008
  8015bf:	00 00 00 
	}
}
  8015c2:	90                   	nop
  8015c3:	c9                   	leave  
  8015c4:	c3                   	ret    

008015c5 <get_page>:

//==============================================
// [2] GET A PAGE FROM THE KERNEL FOR DA:
//==============================================
int get_page(void* va)
{
  8015c5:	55                   	push   %ebp
  8015c6:	89 e5                	mov    %esp,%ebp
  8015c8:	83 ec 18             	sub    $0x18,%esp
	int ret = __sys_allocate_page(ROUNDDOWN(va, PAGE_SIZE), PERM_USER|PERM_WRITEABLE|PERM_UHPAGE);
  8015cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8015ce:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8015d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8015d4:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8015d9:	83 ec 08             	sub    $0x8,%esp
  8015dc:	68 06 04 00 00       	push   $0x406
  8015e1:	50                   	push   %eax
  8015e2:	e8 e4 01 00 00       	call   8017cb <__sys_allocate_page>
  8015e7:	83 c4 10             	add    $0x10,%esp
  8015ea:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (ret < 0)
  8015ed:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8015f1:	79 14                	jns    801607 <get_page+0x42>
		panic("get_page() in user: failed to allocate page from the kernel");
  8015f3:	83 ec 04             	sub    $0x4,%esp
  8015f6:	68 08 32 80 00       	push   $0x803208
  8015fb:	6a 1f                	push   $0x1f
  8015fd:	68 44 32 80 00       	push   $0x803244
  801602:	e8 e5 11 00 00       	call   8027ec <_panic>
	return 0;
  801607:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80160c:	c9                   	leave  
  80160d:	c3                   	ret    

0080160e <return_page>:

//==============================================
// [3] RETURN A PAGE FROM THE DA TO KERNEL:
//==============================================
void return_page(void* va)
{
  80160e:	55                   	push   %ebp
  80160f:	89 e5                	mov    %esp,%ebp
  801611:	83 ec 18             	sub    $0x18,%esp
	int ret = __sys_unmap_frame(ROUNDDOWN((uint32)va, PAGE_SIZE));
  801614:	8b 45 08             	mov    0x8(%ebp),%eax
  801617:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80161a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80161d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801622:	83 ec 0c             	sub    $0xc,%esp
  801625:	50                   	push   %eax
  801626:	e8 e7 01 00 00       	call   801812 <__sys_unmap_frame>
  80162b:	83 c4 10             	add    $0x10,%esp
  80162e:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (ret < 0)
  801631:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801635:	79 14                	jns    80164b <return_page+0x3d>
		panic("return_page() in user: failed to return a page to the kernel");
  801637:	83 ec 04             	sub    $0x4,%esp
  80163a:	68 50 32 80 00       	push   $0x803250
  80163f:	6a 2a                	push   $0x2a
  801641:	68 44 32 80 00       	push   $0x803244
  801646:	e8 a1 11 00 00       	call   8027ec <_panic>
}
  80164b:	90                   	nop
  80164c:	c9                   	leave  
  80164d:	c3                   	ret    

0080164e <malloc>:

//=================================
// [1] ALLOCATE SPACE IN USER HEAP:
//=================================
void* malloc(uint32 size)
{
  80164e:	55                   	push   %ebp
  80164f:	89 e5                	mov    %esp,%ebp
  801651:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  801654:	e8 18 ff ff ff       	call   801571 <uheap_init>
	if (size == 0) return NULL ;
  801659:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80165d:	75 07                	jne    801666 <malloc+0x18>
  80165f:	b8 00 00 00 00       	mov    $0x0,%eax
  801664:	eb 14                	jmp    80167a <malloc+0x2c>
	//==============================================================
	//TODO: [PROJECT'25.IM#2] USER HEAP - #1 malloc
	//Your code is here
	//Comment the following line
	panic("malloc() is not implemented yet...!!");
  801666:	83 ec 04             	sub    $0x4,%esp
  801669:	68 90 32 80 00       	push   $0x803290
  80166e:	6a 3e                	push   $0x3e
  801670:	68 44 32 80 00       	push   $0x803244
  801675:	e8 72 11 00 00       	call   8027ec <_panic>
}
  80167a:	c9                   	leave  
  80167b:	c3                   	ret    

0080167c <free>:

//=================================
// [2] FREE SPACE FROM USER HEAP:
//=================================
void free(void* virtual_address)
{
  80167c:	55                   	push   %ebp
  80167d:	89 e5                	mov    %esp,%ebp
  80167f:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.IM#2] USER HEAP - #3 free
	//Your code is here
	//Comment the following line
	panic("free() is not implemented yet...!!");
  801682:	83 ec 04             	sub    $0x4,%esp
  801685:	68 b8 32 80 00       	push   $0x8032b8
  80168a:	6a 49                	push   $0x49
  80168c:	68 44 32 80 00       	push   $0x803244
  801691:	e8 56 11 00 00       	call   8027ec <_panic>

00801696 <smalloc>:

//=================================
// [3] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  801696:	55                   	push   %ebp
  801697:	89 e5                	mov    %esp,%ebp
  801699:	83 ec 18             	sub    $0x18,%esp
  80169c:	8b 45 10             	mov    0x10(%ebp),%eax
  80169f:	88 45 f4             	mov    %al,-0xc(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  8016a2:	e8 ca fe ff ff       	call   801571 <uheap_init>
	if (size == 0) return NULL ;
  8016a7:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8016ab:	75 07                	jne    8016b4 <smalloc+0x1e>
  8016ad:	b8 00 00 00 00       	mov    $0x0,%eax
  8016b2:	eb 14                	jmp    8016c8 <smalloc+0x32>
	//==============================================================

	//TODO: [PROJECT'25.IM#3] SHARED MEMORY - #2 smalloc
	//Your code is here
	//Comment the following line
	panic("smalloc() is not implemented yet...!!");
  8016b4:	83 ec 04             	sub    $0x4,%esp
  8016b7:	68 dc 32 80 00       	push   $0x8032dc
  8016bc:	6a 5a                	push   $0x5a
  8016be:	68 44 32 80 00       	push   $0x803244
  8016c3:	e8 24 11 00 00       	call   8027ec <_panic>
}
  8016c8:	c9                   	leave  
  8016c9:	c3                   	ret    

008016ca <sget>:

//========================================
// [4] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  8016ca:	55                   	push   %ebp
  8016cb:	89 e5                	mov    %esp,%ebp
  8016cd:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  8016d0:	e8 9c fe ff ff       	call   801571 <uheap_init>
	//==============================================================

	//TODO: [PROJECT'25.IM#3] SHARED MEMORY - #4 sget
	//Your code is here
	//Comment the following line
	panic("sget() is not implemented yet...!!");
  8016d5:	83 ec 04             	sub    $0x4,%esp
  8016d8:	68 04 33 80 00       	push   $0x803304
  8016dd:	6a 6a                	push   $0x6a
  8016df:	68 44 32 80 00       	push   $0x803244
  8016e4:	e8 03 11 00 00       	call   8027ec <_panic>

008016e9 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  8016e9:	55                   	push   %ebp
  8016ea:	89 e5                	mov    %esp,%ebp
  8016ec:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  8016ef:	e8 7d fe ff ff       	call   801571 <uheap_init>
	//==============================================================
	panic("realloc() is not implemented yet...!!");
  8016f4:	83 ec 04             	sub    $0x4,%esp
  8016f7:	68 28 33 80 00       	push   $0x803328
  8016fc:	68 88 00 00 00       	push   $0x88
  801701:	68 44 32 80 00       	push   $0x803244
  801706:	e8 e1 10 00 00       	call   8027ec <_panic>

0080170b <sfree>:
//
//	use sys_delete_shared_object(...); which switches to the kernel mode,
//	calls delete_shared_object(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the delete_shared_object() function is empty, make sure to implement it.
void sfree(void* virtual_address)
{
  80170b:	55                   	push   %ebp
  80170c:	89 e5                	mov    %esp,%ebp
  80170e:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.BONUS#5] EXIT #2 - sfree
	//Your code is here
	//Comment the following line
	panic("sfree() is not implemented yet...!!");
  801711:	83 ec 04             	sub    $0x4,%esp
  801714:	68 50 33 80 00       	push   $0x803350
  801719:	68 9b 00 00 00       	push   $0x9b
  80171e:	68 44 32 80 00       	push   $0x803244
  801723:	e8 c4 10 00 00       	call   8027ec <_panic>

00801728 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801728:	55                   	push   %ebp
  801729:	89 e5                	mov    %esp,%ebp
  80172b:	57                   	push   %edi
  80172c:	56                   	push   %esi
  80172d:	53                   	push   %ebx
  80172e:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801731:	8b 45 08             	mov    0x8(%ebp),%eax
  801734:	8b 55 0c             	mov    0xc(%ebp),%edx
  801737:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80173a:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80173d:	8b 7d 18             	mov    0x18(%ebp),%edi
  801740:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801743:	cd 30                	int    $0x30
  801745:	89 45 f0             	mov    %eax,-0x10(%ebp)
				"b" (a3),
				"D" (a4),
				"S" (a5)
				: "cc", "memory");

	return ret;
  801748:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80174b:	83 c4 10             	add    $0x10,%esp
  80174e:	5b                   	pop    %ebx
  80174f:	5e                   	pop    %esi
  801750:	5f                   	pop    %edi
  801751:	5d                   	pop    %ebp
  801752:	c3                   	ret    

00801753 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName, int color)
{
  801753:	55                   	push   %ebp
  801754:	89 e5                	mov    %esp,%ebp
  801756:	83 ec 04             	sub    $0x4,%esp
  801759:	8b 45 10             	mov    0x10(%ebp),%eax
  80175c:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, color, 0);
  80175f:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801762:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801766:	8b 45 08             	mov    0x8(%ebp),%eax
  801769:	6a 00                	push   $0x0
  80176b:	51                   	push   %ecx
  80176c:	52                   	push   %edx
  80176d:	ff 75 0c             	pushl  0xc(%ebp)
  801770:	50                   	push   %eax
  801771:	6a 00                	push   $0x0
  801773:	e8 b0 ff ff ff       	call   801728 <syscall>
  801778:	83 c4 18             	add    $0x18,%esp
}
  80177b:	90                   	nop
  80177c:	c9                   	leave  
  80177d:	c3                   	ret    

0080177e <sys_cgetc>:

int
sys_cgetc(void)
{
  80177e:	55                   	push   %ebp
  80177f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801781:	6a 00                	push   $0x0
  801783:	6a 00                	push   $0x0
  801785:	6a 00                	push   $0x0
  801787:	6a 00                	push   $0x0
  801789:	6a 00                	push   $0x0
  80178b:	6a 02                	push   $0x2
  80178d:	e8 96 ff ff ff       	call   801728 <syscall>
  801792:	83 c4 18             	add    $0x18,%esp
}
  801795:	c9                   	leave  
  801796:	c3                   	ret    

00801797 <sys_lock_cons>:

void sys_lock_cons(void)
{
  801797:	55                   	push   %ebp
  801798:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  80179a:	6a 00                	push   $0x0
  80179c:	6a 00                	push   $0x0
  80179e:	6a 00                	push   $0x0
  8017a0:	6a 00                	push   $0x0
  8017a2:	6a 00                	push   $0x0
  8017a4:	6a 03                	push   $0x3
  8017a6:	e8 7d ff ff ff       	call   801728 <syscall>
  8017ab:	83 c4 18             	add    $0x18,%esp
}
  8017ae:	90                   	nop
  8017af:	c9                   	leave  
  8017b0:	c3                   	ret    

008017b1 <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  8017b1:	55                   	push   %ebp
  8017b2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  8017b4:	6a 00                	push   $0x0
  8017b6:	6a 00                	push   $0x0
  8017b8:	6a 00                	push   $0x0
  8017ba:	6a 00                	push   $0x0
  8017bc:	6a 00                	push   $0x0
  8017be:	6a 04                	push   $0x4
  8017c0:	e8 63 ff ff ff       	call   801728 <syscall>
  8017c5:	83 c4 18             	add    $0x18,%esp
}
  8017c8:	90                   	nop
  8017c9:	c9                   	leave  
  8017ca:	c3                   	ret    

008017cb <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  8017cb:	55                   	push   %ebp
  8017cc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  8017ce:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8017d4:	6a 00                	push   $0x0
  8017d6:	6a 00                	push   $0x0
  8017d8:	6a 00                	push   $0x0
  8017da:	52                   	push   %edx
  8017db:	50                   	push   %eax
  8017dc:	6a 08                	push   $0x8
  8017de:	e8 45 ff ff ff       	call   801728 <syscall>
  8017e3:	83 c4 18             	add    $0x18,%esp
}
  8017e6:	c9                   	leave  
  8017e7:	c3                   	ret    

008017e8 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  8017e8:	55                   	push   %ebp
  8017e9:	89 e5                	mov    %esp,%ebp
  8017eb:	56                   	push   %esi
  8017ec:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  8017ed:	8b 75 18             	mov    0x18(%ebp),%esi
  8017f0:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8017f3:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8017f6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8017fc:	56                   	push   %esi
  8017fd:	53                   	push   %ebx
  8017fe:	51                   	push   %ecx
  8017ff:	52                   	push   %edx
  801800:	50                   	push   %eax
  801801:	6a 09                	push   $0x9
  801803:	e8 20 ff ff ff       	call   801728 <syscall>
  801808:	83 c4 18             	add    $0x18,%esp
}
  80180b:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80180e:	5b                   	pop    %ebx
  80180f:	5e                   	pop    %esi
  801810:	5d                   	pop    %ebp
  801811:	c3                   	ret    

00801812 <__sys_unmap_frame>:

int __sys_unmap_frame(uint32 va)
{
  801812:	55                   	push   %ebp
  801813:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, va, 0, 0, 0, 0);
  801815:	6a 00                	push   $0x0
  801817:	6a 00                	push   $0x0
  801819:	6a 00                	push   $0x0
  80181b:	6a 00                	push   $0x0
  80181d:	ff 75 08             	pushl  0x8(%ebp)
  801820:	6a 0a                	push   $0xa
  801822:	e8 01 ff ff ff       	call   801728 <syscall>
  801827:	83 c4 18             	add    $0x18,%esp
}
  80182a:	c9                   	leave  
  80182b:	c3                   	ret    

0080182c <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  80182c:	55                   	push   %ebp
  80182d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  80182f:	6a 00                	push   $0x0
  801831:	6a 00                	push   $0x0
  801833:	6a 00                	push   $0x0
  801835:	ff 75 0c             	pushl  0xc(%ebp)
  801838:	ff 75 08             	pushl  0x8(%ebp)
  80183b:	6a 0b                	push   $0xb
  80183d:	e8 e6 fe ff ff       	call   801728 <syscall>
  801842:	83 c4 18             	add    $0x18,%esp
}
  801845:	c9                   	leave  
  801846:	c3                   	ret    

00801847 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801847:	55                   	push   %ebp
  801848:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  80184a:	6a 00                	push   $0x0
  80184c:	6a 00                	push   $0x0
  80184e:	6a 00                	push   $0x0
  801850:	6a 00                	push   $0x0
  801852:	6a 00                	push   $0x0
  801854:	6a 0c                	push   $0xc
  801856:	e8 cd fe ff ff       	call   801728 <syscall>
  80185b:	83 c4 18             	add    $0x18,%esp
}
  80185e:	c9                   	leave  
  80185f:	c3                   	ret    

00801860 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801860:	55                   	push   %ebp
  801861:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801863:	6a 00                	push   $0x0
  801865:	6a 00                	push   $0x0
  801867:	6a 00                	push   $0x0
  801869:	6a 00                	push   $0x0
  80186b:	6a 00                	push   $0x0
  80186d:	6a 0d                	push   $0xd
  80186f:	e8 b4 fe ff ff       	call   801728 <syscall>
  801874:	83 c4 18             	add    $0x18,%esp
}
  801877:	c9                   	leave  
  801878:	c3                   	ret    

00801879 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801879:	55                   	push   %ebp
  80187a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  80187c:	6a 00                	push   $0x0
  80187e:	6a 00                	push   $0x0
  801880:	6a 00                	push   $0x0
  801882:	6a 00                	push   $0x0
  801884:	6a 00                	push   $0x0
  801886:	6a 0e                	push   $0xe
  801888:	e8 9b fe ff ff       	call   801728 <syscall>
  80188d:	83 c4 18             	add    $0x18,%esp
}
  801890:	c9                   	leave  
  801891:	c3                   	ret    

00801892 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801892:	55                   	push   %ebp
  801893:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801895:	6a 00                	push   $0x0
  801897:	6a 00                	push   $0x0
  801899:	6a 00                	push   $0x0
  80189b:	6a 00                	push   $0x0
  80189d:	6a 00                	push   $0x0
  80189f:	6a 0f                	push   $0xf
  8018a1:	e8 82 fe ff ff       	call   801728 <syscall>
  8018a6:	83 c4 18             	add    $0x18,%esp
}
  8018a9:	c9                   	leave  
  8018aa:	c3                   	ret    

008018ab <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  8018ab:	55                   	push   %ebp
  8018ac:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  8018ae:	6a 00                	push   $0x0
  8018b0:	6a 00                	push   $0x0
  8018b2:	6a 00                	push   $0x0
  8018b4:	6a 00                	push   $0x0
  8018b6:	ff 75 08             	pushl  0x8(%ebp)
  8018b9:	6a 10                	push   $0x10
  8018bb:	e8 68 fe ff ff       	call   801728 <syscall>
  8018c0:	83 c4 18             	add    $0x18,%esp
}
  8018c3:	c9                   	leave  
  8018c4:	c3                   	ret    

008018c5 <sys_scarce_memory>:

void sys_scarce_memory()
{
  8018c5:	55                   	push   %ebp
  8018c6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  8018c8:	6a 00                	push   $0x0
  8018ca:	6a 00                	push   $0x0
  8018cc:	6a 00                	push   $0x0
  8018ce:	6a 00                	push   $0x0
  8018d0:	6a 00                	push   $0x0
  8018d2:	6a 11                	push   $0x11
  8018d4:	e8 4f fe ff ff       	call   801728 <syscall>
  8018d9:	83 c4 18             	add    $0x18,%esp
}
  8018dc:	90                   	nop
  8018dd:	c9                   	leave  
  8018de:	c3                   	ret    

008018df <sys_cputc>:

void
sys_cputc(const char c)
{
  8018df:	55                   	push   %ebp
  8018e0:	89 e5                	mov    %esp,%ebp
  8018e2:	83 ec 04             	sub    $0x4,%esp
  8018e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8018e8:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  8018eb:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8018ef:	6a 00                	push   $0x0
  8018f1:	6a 00                	push   $0x0
  8018f3:	6a 00                	push   $0x0
  8018f5:	6a 00                	push   $0x0
  8018f7:	50                   	push   %eax
  8018f8:	6a 01                	push   $0x1
  8018fa:	e8 29 fe ff ff       	call   801728 <syscall>
  8018ff:	83 c4 18             	add    $0x18,%esp
}
  801902:	90                   	nop
  801903:	c9                   	leave  
  801904:	c3                   	ret    

00801905 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801905:	55                   	push   %ebp
  801906:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801908:	6a 00                	push   $0x0
  80190a:	6a 00                	push   $0x0
  80190c:	6a 00                	push   $0x0
  80190e:	6a 00                	push   $0x0
  801910:	6a 00                	push   $0x0
  801912:	6a 14                	push   $0x14
  801914:	e8 0f fe ff ff       	call   801728 <syscall>
  801919:	83 c4 18             	add    $0x18,%esp
}
  80191c:	90                   	nop
  80191d:	c9                   	leave  
  80191e:	c3                   	ret    

0080191f <sys_create_shared_object>:

int sys_create_shared_object(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  80191f:	55                   	push   %ebp
  801920:	89 e5                	mov    %esp,%ebp
  801922:	83 ec 04             	sub    $0x4,%esp
  801925:	8b 45 10             	mov    0x10(%ebp),%eax
  801928:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  80192b:	8b 4d 14             	mov    0x14(%ebp),%ecx
  80192e:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801932:	8b 45 08             	mov    0x8(%ebp),%eax
  801935:	6a 00                	push   $0x0
  801937:	51                   	push   %ecx
  801938:	52                   	push   %edx
  801939:	ff 75 0c             	pushl  0xc(%ebp)
  80193c:	50                   	push   %eax
  80193d:	6a 15                	push   $0x15
  80193f:	e8 e4 fd ff ff       	call   801728 <syscall>
  801944:	83 c4 18             	add    $0x18,%esp
}
  801947:	c9                   	leave  
  801948:	c3                   	ret    

00801949 <sys_size_of_shared_object>:

//2017:
int sys_size_of_shared_object(int32 ownerID, char* shareName)
{
  801949:	55                   	push   %ebp
  80194a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  80194c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80194f:	8b 45 08             	mov    0x8(%ebp),%eax
  801952:	6a 00                	push   $0x0
  801954:	6a 00                	push   $0x0
  801956:	6a 00                	push   $0x0
  801958:	52                   	push   %edx
  801959:	50                   	push   %eax
  80195a:	6a 16                	push   $0x16
  80195c:	e8 c7 fd ff ff       	call   801728 <syscall>
  801961:	83 c4 18             	add    $0x18,%esp
}
  801964:	c9                   	leave  
  801965:	c3                   	ret    

00801966 <sys_get_shared_object>:
//==========

int sys_get_shared_object(int32 ownerID, char* shareName, void* virtual_address)
{
  801966:	55                   	push   %ebp
  801967:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801969:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80196c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80196f:	8b 45 08             	mov    0x8(%ebp),%eax
  801972:	6a 00                	push   $0x0
  801974:	6a 00                	push   $0x0
  801976:	51                   	push   %ecx
  801977:	52                   	push   %edx
  801978:	50                   	push   %eax
  801979:	6a 17                	push   $0x17
  80197b:	e8 a8 fd ff ff       	call   801728 <syscall>
  801980:	83 c4 18             	add    $0x18,%esp
}
  801983:	c9                   	leave  
  801984:	c3                   	ret    

00801985 <sys_delete_shared_object>:

int sys_delete_shared_object(int32 sharedObjectID, void *startVA)
{
  801985:	55                   	push   %ebp
  801986:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801988:	8b 55 0c             	mov    0xc(%ebp),%edx
  80198b:	8b 45 08             	mov    0x8(%ebp),%eax
  80198e:	6a 00                	push   $0x0
  801990:	6a 00                	push   $0x0
  801992:	6a 00                	push   $0x0
  801994:	52                   	push   %edx
  801995:	50                   	push   %eax
  801996:	6a 18                	push   $0x18
  801998:	e8 8b fd ff ff       	call   801728 <syscall>
  80199d:	83 c4 18             	add    $0x18,%esp
}
  8019a0:	c9                   	leave  
  8019a1:	c3                   	ret    

008019a2 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  8019a2:	55                   	push   %ebp
  8019a3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  8019a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8019a8:	6a 00                	push   $0x0
  8019aa:	ff 75 14             	pushl  0x14(%ebp)
  8019ad:	ff 75 10             	pushl  0x10(%ebp)
  8019b0:	ff 75 0c             	pushl  0xc(%ebp)
  8019b3:	50                   	push   %eax
  8019b4:	6a 19                	push   $0x19
  8019b6:	e8 6d fd ff ff       	call   801728 <syscall>
  8019bb:	83 c4 18             	add    $0x18,%esp
}
  8019be:	c9                   	leave  
  8019bf:	c3                   	ret    

008019c0 <sys_run_env>:

void sys_run_env(int32 envId)
{
  8019c0:	55                   	push   %ebp
  8019c1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  8019c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8019c6:	6a 00                	push   $0x0
  8019c8:	6a 00                	push   $0x0
  8019ca:	6a 00                	push   $0x0
  8019cc:	6a 00                	push   $0x0
  8019ce:	50                   	push   %eax
  8019cf:	6a 1a                	push   $0x1a
  8019d1:	e8 52 fd ff ff       	call   801728 <syscall>
  8019d6:	83 c4 18             	add    $0x18,%esp
}
  8019d9:	90                   	nop
  8019da:	c9                   	leave  
  8019db:	c3                   	ret    

008019dc <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  8019dc:	55                   	push   %ebp
  8019dd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  8019df:	8b 45 08             	mov    0x8(%ebp),%eax
  8019e2:	6a 00                	push   $0x0
  8019e4:	6a 00                	push   $0x0
  8019e6:	6a 00                	push   $0x0
  8019e8:	6a 00                	push   $0x0
  8019ea:	50                   	push   %eax
  8019eb:	6a 1b                	push   $0x1b
  8019ed:	e8 36 fd ff ff       	call   801728 <syscall>
  8019f2:	83 c4 18             	add    $0x18,%esp
}
  8019f5:	c9                   	leave  
  8019f6:	c3                   	ret    

008019f7 <sys_getenvid>:

int32 sys_getenvid(void)
{
  8019f7:	55                   	push   %ebp
  8019f8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  8019fa:	6a 00                	push   $0x0
  8019fc:	6a 00                	push   $0x0
  8019fe:	6a 00                	push   $0x0
  801a00:	6a 00                	push   $0x0
  801a02:	6a 00                	push   $0x0
  801a04:	6a 05                	push   $0x5
  801a06:	e8 1d fd ff ff       	call   801728 <syscall>
  801a0b:	83 c4 18             	add    $0x18,%esp
}
  801a0e:	c9                   	leave  
  801a0f:	c3                   	ret    

00801a10 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801a10:	55                   	push   %ebp
  801a11:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801a13:	6a 00                	push   $0x0
  801a15:	6a 00                	push   $0x0
  801a17:	6a 00                	push   $0x0
  801a19:	6a 00                	push   $0x0
  801a1b:	6a 00                	push   $0x0
  801a1d:	6a 06                	push   $0x6
  801a1f:	e8 04 fd ff ff       	call   801728 <syscall>
  801a24:	83 c4 18             	add    $0x18,%esp
}
  801a27:	c9                   	leave  
  801a28:	c3                   	ret    

00801a29 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801a29:	55                   	push   %ebp
  801a2a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801a2c:	6a 00                	push   $0x0
  801a2e:	6a 00                	push   $0x0
  801a30:	6a 00                	push   $0x0
  801a32:	6a 00                	push   $0x0
  801a34:	6a 00                	push   $0x0
  801a36:	6a 07                	push   $0x7
  801a38:	e8 eb fc ff ff       	call   801728 <syscall>
  801a3d:	83 c4 18             	add    $0x18,%esp
}
  801a40:	c9                   	leave  
  801a41:	c3                   	ret    

00801a42 <sys_exit_env>:


void sys_exit_env(void)
{
  801a42:	55                   	push   %ebp
  801a43:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801a45:	6a 00                	push   $0x0
  801a47:	6a 00                	push   $0x0
  801a49:	6a 00                	push   $0x0
  801a4b:	6a 00                	push   $0x0
  801a4d:	6a 00                	push   $0x0
  801a4f:	6a 1c                	push   $0x1c
  801a51:	e8 d2 fc ff ff       	call   801728 <syscall>
  801a56:	83 c4 18             	add    $0x18,%esp
}
  801a59:	90                   	nop
  801a5a:	c9                   	leave  
  801a5b:	c3                   	ret    

00801a5c <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  801a5c:	55                   	push   %ebp
  801a5d:	89 e5                	mov    %esp,%ebp
  801a5f:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801a62:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801a65:	8d 50 04             	lea    0x4(%eax),%edx
  801a68:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801a6b:	6a 00                	push   $0x0
  801a6d:	6a 00                	push   $0x0
  801a6f:	6a 00                	push   $0x0
  801a71:	52                   	push   %edx
  801a72:	50                   	push   %eax
  801a73:	6a 1d                	push   $0x1d
  801a75:	e8 ae fc ff ff       	call   801728 <syscall>
  801a7a:	83 c4 18             	add    $0x18,%esp
	return result;
  801a7d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801a80:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801a83:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801a86:	89 01                	mov    %eax,(%ecx)
  801a88:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801a8b:	8b 45 08             	mov    0x8(%ebp),%eax
  801a8e:	c9                   	leave  
  801a8f:	c2 04 00             	ret    $0x4

00801a92 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801a92:	55                   	push   %ebp
  801a93:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801a95:	6a 00                	push   $0x0
  801a97:	6a 00                	push   $0x0
  801a99:	ff 75 10             	pushl  0x10(%ebp)
  801a9c:	ff 75 0c             	pushl  0xc(%ebp)
  801a9f:	ff 75 08             	pushl  0x8(%ebp)
  801aa2:	6a 13                	push   $0x13
  801aa4:	e8 7f fc ff ff       	call   801728 <syscall>
  801aa9:	83 c4 18             	add    $0x18,%esp
	return ;
  801aac:	90                   	nop
}
  801aad:	c9                   	leave  
  801aae:	c3                   	ret    

00801aaf <sys_rcr2>:
uint32 sys_rcr2()
{
  801aaf:	55                   	push   %ebp
  801ab0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801ab2:	6a 00                	push   $0x0
  801ab4:	6a 00                	push   $0x0
  801ab6:	6a 00                	push   $0x0
  801ab8:	6a 00                	push   $0x0
  801aba:	6a 00                	push   $0x0
  801abc:	6a 1e                	push   $0x1e
  801abe:	e8 65 fc ff ff       	call   801728 <syscall>
  801ac3:	83 c4 18             	add    $0x18,%esp
}
  801ac6:	c9                   	leave  
  801ac7:	c3                   	ret    

00801ac8 <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  801ac8:	55                   	push   %ebp
  801ac9:	89 e5                	mov    %esp,%ebp
  801acb:	83 ec 04             	sub    $0x4,%esp
  801ace:	8b 45 08             	mov    0x8(%ebp),%eax
  801ad1:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801ad4:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801ad8:	6a 00                	push   $0x0
  801ada:	6a 00                	push   $0x0
  801adc:	6a 00                	push   $0x0
  801ade:	6a 00                	push   $0x0
  801ae0:	50                   	push   %eax
  801ae1:	6a 1f                	push   $0x1f
  801ae3:	e8 40 fc ff ff       	call   801728 <syscall>
  801ae8:	83 c4 18             	add    $0x18,%esp
	return ;
  801aeb:	90                   	nop
}
  801aec:	c9                   	leave  
  801aed:	c3                   	ret    

00801aee <rsttst>:
void rsttst()
{
  801aee:	55                   	push   %ebp
  801aef:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801af1:	6a 00                	push   $0x0
  801af3:	6a 00                	push   $0x0
  801af5:	6a 00                	push   $0x0
  801af7:	6a 00                	push   $0x0
  801af9:	6a 00                	push   $0x0
  801afb:	6a 21                	push   $0x21
  801afd:	e8 26 fc ff ff       	call   801728 <syscall>
  801b02:	83 c4 18             	add    $0x18,%esp
	return ;
  801b05:	90                   	nop
}
  801b06:	c9                   	leave  
  801b07:	c3                   	ret    

00801b08 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801b08:	55                   	push   %ebp
  801b09:	89 e5                	mov    %esp,%ebp
  801b0b:	83 ec 04             	sub    $0x4,%esp
  801b0e:	8b 45 14             	mov    0x14(%ebp),%eax
  801b11:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801b14:	8b 55 18             	mov    0x18(%ebp),%edx
  801b17:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801b1b:	52                   	push   %edx
  801b1c:	50                   	push   %eax
  801b1d:	ff 75 10             	pushl  0x10(%ebp)
  801b20:	ff 75 0c             	pushl  0xc(%ebp)
  801b23:	ff 75 08             	pushl  0x8(%ebp)
  801b26:	6a 20                	push   $0x20
  801b28:	e8 fb fb ff ff       	call   801728 <syscall>
  801b2d:	83 c4 18             	add    $0x18,%esp
	return ;
  801b30:	90                   	nop
}
  801b31:	c9                   	leave  
  801b32:	c3                   	ret    

00801b33 <chktst>:
void chktst(uint32 n)
{
  801b33:	55                   	push   %ebp
  801b34:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801b36:	6a 00                	push   $0x0
  801b38:	6a 00                	push   $0x0
  801b3a:	6a 00                	push   $0x0
  801b3c:	6a 00                	push   $0x0
  801b3e:	ff 75 08             	pushl  0x8(%ebp)
  801b41:	6a 22                	push   $0x22
  801b43:	e8 e0 fb ff ff       	call   801728 <syscall>
  801b48:	83 c4 18             	add    $0x18,%esp
	return ;
  801b4b:	90                   	nop
}
  801b4c:	c9                   	leave  
  801b4d:	c3                   	ret    

00801b4e <inctst>:

void inctst()
{
  801b4e:	55                   	push   %ebp
  801b4f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801b51:	6a 00                	push   $0x0
  801b53:	6a 00                	push   $0x0
  801b55:	6a 00                	push   $0x0
  801b57:	6a 00                	push   $0x0
  801b59:	6a 00                	push   $0x0
  801b5b:	6a 23                	push   $0x23
  801b5d:	e8 c6 fb ff ff       	call   801728 <syscall>
  801b62:	83 c4 18             	add    $0x18,%esp
	return ;
  801b65:	90                   	nop
}
  801b66:	c9                   	leave  
  801b67:	c3                   	ret    

00801b68 <gettst>:
uint32 gettst()
{
  801b68:	55                   	push   %ebp
  801b69:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801b6b:	6a 00                	push   $0x0
  801b6d:	6a 00                	push   $0x0
  801b6f:	6a 00                	push   $0x0
  801b71:	6a 00                	push   $0x0
  801b73:	6a 00                	push   $0x0
  801b75:	6a 24                	push   $0x24
  801b77:	e8 ac fb ff ff       	call   801728 <syscall>
  801b7c:	83 c4 18             	add    $0x18,%esp
}
  801b7f:	c9                   	leave  
  801b80:	c3                   	ret    

00801b81 <sys_get_uheap_strategy>:

/*2025*/
uint32 sys_get_uheap_strategy()
{
  801b81:	55                   	push   %ebp
  801b82:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801b84:	6a 00                	push   $0x0
  801b86:	6a 00                	push   $0x0
  801b88:	6a 00                	push   $0x0
  801b8a:	6a 00                	push   $0x0
  801b8c:	6a 00                	push   $0x0
  801b8e:	6a 25                	push   $0x25
  801b90:	e8 93 fb ff ff       	call   801728 <syscall>
  801b95:	83 c4 18             	add    $0x18,%esp
  801b98:	a3 60 c0 81 00       	mov    %eax,0x81c060
	return uheapPlaceStrategy ;
  801b9d:	a1 60 c0 81 00       	mov    0x81c060,%eax
}
  801ba2:	c9                   	leave  
  801ba3:	c3                   	ret    

00801ba4 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801ba4:	55                   	push   %ebp
  801ba5:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = heapStrategy;
  801ba7:	8b 45 08             	mov    0x8(%ebp),%eax
  801baa:	a3 60 c0 81 00       	mov    %eax,0x81c060
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801baf:	6a 00                	push   $0x0
  801bb1:	6a 00                	push   $0x0
  801bb3:	6a 00                	push   $0x0
  801bb5:	6a 00                	push   $0x0
  801bb7:	ff 75 08             	pushl  0x8(%ebp)
  801bba:	6a 26                	push   $0x26
  801bbc:	e8 67 fb ff ff       	call   801728 <syscall>
  801bc1:	83 c4 18             	add    $0x18,%esp
	return ;
  801bc4:	90                   	nop
}
  801bc5:	c9                   	leave  
  801bc6:	c3                   	ret    

00801bc7 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801bc7:	55                   	push   %ebp
  801bc8:	89 e5                	mov    %esp,%ebp
  801bca:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801bcb:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801bce:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801bd1:	8b 55 0c             	mov    0xc(%ebp),%edx
  801bd4:	8b 45 08             	mov    0x8(%ebp),%eax
  801bd7:	6a 00                	push   $0x0
  801bd9:	53                   	push   %ebx
  801bda:	51                   	push   %ecx
  801bdb:	52                   	push   %edx
  801bdc:	50                   	push   %eax
  801bdd:	6a 27                	push   $0x27
  801bdf:	e8 44 fb ff ff       	call   801728 <syscall>
  801be4:	83 c4 18             	add    $0x18,%esp
}
  801be7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801bea:	c9                   	leave  
  801beb:	c3                   	ret    

00801bec <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801bec:	55                   	push   %ebp
  801bed:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801bef:	8b 55 0c             	mov    0xc(%ebp),%edx
  801bf2:	8b 45 08             	mov    0x8(%ebp),%eax
  801bf5:	6a 00                	push   $0x0
  801bf7:	6a 00                	push   $0x0
  801bf9:	6a 00                	push   $0x0
  801bfb:	52                   	push   %edx
  801bfc:	50                   	push   %eax
  801bfd:	6a 28                	push   $0x28
  801bff:	e8 24 fb ff ff       	call   801728 <syscall>
  801c04:	83 c4 18             	add    $0x18,%esp
}
  801c07:	c9                   	leave  
  801c08:	c3                   	ret    

00801c09 <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  801c09:	55                   	push   %ebp
  801c0a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  801c0c:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801c0f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c12:	8b 45 08             	mov    0x8(%ebp),%eax
  801c15:	6a 00                	push   $0x0
  801c17:	51                   	push   %ecx
  801c18:	ff 75 10             	pushl  0x10(%ebp)
  801c1b:	52                   	push   %edx
  801c1c:	50                   	push   %eax
  801c1d:	6a 29                	push   $0x29
  801c1f:	e8 04 fb ff ff       	call   801728 <syscall>
  801c24:	83 c4 18             	add    $0x18,%esp
}
  801c27:	c9                   	leave  
  801c28:	c3                   	ret    

00801c29 <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801c29:	55                   	push   %ebp
  801c2a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801c2c:	6a 00                	push   $0x0
  801c2e:	6a 00                	push   $0x0
  801c30:	ff 75 10             	pushl  0x10(%ebp)
  801c33:	ff 75 0c             	pushl  0xc(%ebp)
  801c36:	ff 75 08             	pushl  0x8(%ebp)
  801c39:	6a 12                	push   $0x12
  801c3b:	e8 e8 fa ff ff       	call   801728 <syscall>
  801c40:	83 c4 18             	add    $0x18,%esp
	return ;
  801c43:	90                   	nop
}
  801c44:	c9                   	leave  
  801c45:	c3                   	ret    

00801c46 <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  801c46:	55                   	push   %ebp
  801c47:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  801c49:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c4c:	8b 45 08             	mov    0x8(%ebp),%eax
  801c4f:	6a 00                	push   $0x0
  801c51:	6a 00                	push   $0x0
  801c53:	6a 00                	push   $0x0
  801c55:	52                   	push   %edx
  801c56:	50                   	push   %eax
  801c57:	6a 2a                	push   $0x2a
  801c59:	e8 ca fa ff ff       	call   801728 <syscall>
  801c5e:	83 c4 18             	add    $0x18,%esp
	return;
  801c61:	90                   	nop
}
  801c62:	c9                   	leave  
  801c63:	c3                   	ret    

00801c64 <sys_get_optimal_num_faults>:
/*2025*/
int sys_get_optimal_num_faults()
{
  801c64:	55                   	push   %ebp
  801c65:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_optimal_num_faults, 0, 0, 0, 0, 0);
  801c67:	6a 00                	push   $0x0
  801c69:	6a 00                	push   $0x0
  801c6b:	6a 00                	push   $0x0
  801c6d:	6a 00                	push   $0x0
  801c6f:	6a 00                	push   $0x0
  801c71:	6a 2b                	push   $0x2b
  801c73:	e8 b0 fa ff ff       	call   801728 <syscall>
  801c78:	83 c4 18             	add    $0x18,%esp
}
  801c7b:	c9                   	leave  
  801c7c:	c3                   	ret    

00801c7d <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801c7d:	55                   	push   %ebp
  801c7e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801c80:	6a 00                	push   $0x0
  801c82:	6a 00                	push   $0x0
  801c84:	6a 00                	push   $0x0
  801c86:	ff 75 0c             	pushl  0xc(%ebp)
  801c89:	ff 75 08             	pushl  0x8(%ebp)
  801c8c:	6a 2d                	push   $0x2d
  801c8e:	e8 95 fa ff ff       	call   801728 <syscall>
  801c93:	83 c4 18             	add    $0x18,%esp
	return;
  801c96:	90                   	nop
}
  801c97:	c9                   	leave  
  801c98:	c3                   	ret    

00801c99 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801c99:	55                   	push   %ebp
  801c9a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801c9c:	6a 00                	push   $0x0
  801c9e:	6a 00                	push   $0x0
  801ca0:	6a 00                	push   $0x0
  801ca2:	ff 75 0c             	pushl  0xc(%ebp)
  801ca5:	ff 75 08             	pushl  0x8(%ebp)
  801ca8:	6a 2c                	push   $0x2c
  801caa:	e8 79 fa ff ff       	call   801728 <syscall>
  801caf:	83 c4 18             	add    $0x18,%esp
	return ;
  801cb2:	90                   	nop
}
  801cb3:	c9                   	leave  
  801cb4:	c3                   	ret    

00801cb5 <sys_env_set_priority>:


void sys_env_set_priority(int32 envID, int priority)
{
  801cb5:	55                   	push   %ebp
  801cb6:	89 e5                	mov    %esp,%ebp
  801cb8:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.IM#4] CPU SCHEDULING - #1 System Calls - Add suitable code here
	//Your code is here
	//Comment the following line
	panic("sys_env_set_priority() is not implemented yet...!!");
  801cbb:	83 ec 04             	sub    $0x4,%esp
  801cbe:	68 74 33 80 00       	push   $0x803374
  801cc3:	68 25 01 00 00       	push   $0x125
  801cc8:	68 a7 33 80 00       	push   $0x8033a7
  801ccd:	e8 1a 0b 00 00       	call   8027ec <_panic>

00801cd2 <to_page_va>:
//==================================
//==================================
// [1] GET PAGE VA:
//==================================
__inline__ uint32 to_page_va(struct PageInfoElement *ptrPageInfo)
{
  801cd2:	55                   	push   %ebp
  801cd3:	89 e5                	mov    %esp,%ebp
  801cd5:	83 ec 18             	sub    $0x18,%esp
	if (ptrPageInfo < &pageBlockInfoArr[0] || ptrPageInfo >= &pageBlockInfoArr[DYN_ALLOC_MAX_SIZE/PAGE_SIZE])
  801cd8:	81 7d 08 60 40 80 00 	cmpl   $0x804060,0x8(%ebp)
  801cdf:	72 09                	jb     801cea <to_page_va+0x18>
  801ce1:	81 7d 08 60 c0 81 00 	cmpl   $0x81c060,0x8(%ebp)
  801ce8:	72 14                	jb     801cfe <to_page_va+0x2c>
			panic("to_page_va called with invalid pageInfoPtr");
  801cea:	83 ec 04             	sub    $0x4,%esp
  801ced:	68 b8 33 80 00       	push   $0x8033b8
  801cf2:	6a 15                	push   $0x15
  801cf4:	68 e3 33 80 00       	push   $0x8033e3
  801cf9:	e8 ee 0a 00 00       	call   8027ec <_panic>
	//Get start VA of the page from the corresponding Page Info pointer
	int idxInPageInfoArr = (ptrPageInfo - pageBlockInfoArr);
  801cfe:	8b 45 08             	mov    0x8(%ebp),%eax
  801d01:	ba 60 40 80 00       	mov    $0x804060,%edx
  801d06:	29 d0                	sub    %edx,%eax
  801d08:	c1 f8 02             	sar    $0x2,%eax
  801d0b:	89 c2                	mov    %eax,%edx
  801d0d:	89 d0                	mov    %edx,%eax
  801d0f:	c1 e0 02             	shl    $0x2,%eax
  801d12:	01 d0                	add    %edx,%eax
  801d14:	c1 e0 02             	shl    $0x2,%eax
  801d17:	01 d0                	add    %edx,%eax
  801d19:	c1 e0 02             	shl    $0x2,%eax
  801d1c:	01 d0                	add    %edx,%eax
  801d1e:	89 c1                	mov    %eax,%ecx
  801d20:	c1 e1 08             	shl    $0x8,%ecx
  801d23:	01 c8                	add    %ecx,%eax
  801d25:	89 c1                	mov    %eax,%ecx
  801d27:	c1 e1 10             	shl    $0x10,%ecx
  801d2a:	01 c8                	add    %ecx,%eax
  801d2c:	01 c0                	add    %eax,%eax
  801d2e:	01 d0                	add    %edx,%eax
  801d30:	89 45 f4             	mov    %eax,-0xc(%ebp)
	return dynAllocStart + (idxInPageInfoArr << PGSHIFT);
  801d33:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d36:	c1 e0 0c             	shl    $0xc,%eax
  801d39:	89 c2                	mov    %eax,%edx
  801d3b:	a1 64 c0 81 00       	mov    0x81c064,%eax
  801d40:	01 d0                	add    %edx,%eax
}
  801d42:	c9                   	leave  
  801d43:	c3                   	ret    

00801d44 <to_page_info>:

//==================================
// [2] GET PAGE INFO OF PAGE VA:
//==================================
__inline__ struct PageInfoElement * to_page_info(uint32 va)
{
  801d44:	55                   	push   %ebp
  801d45:	89 e5                	mov    %esp,%ebp
  801d47:	83 ec 18             	sub    $0x18,%esp
	int idxInPageInfoArr = (va - dynAllocStart) >> PGSHIFT;
  801d4a:	a1 64 c0 81 00       	mov    0x81c064,%eax
  801d4f:	8b 55 08             	mov    0x8(%ebp),%edx
  801d52:	29 c2                	sub    %eax,%edx
  801d54:	89 d0                	mov    %edx,%eax
  801d56:	c1 e8 0c             	shr    $0xc,%eax
  801d59:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if (idxInPageInfoArr < 0 || idxInPageInfoArr >= DYN_ALLOC_MAX_SIZE/PAGE_SIZE)
  801d5c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801d60:	78 09                	js     801d6b <to_page_info+0x27>
  801d62:	81 7d f4 ff 1f 00 00 	cmpl   $0x1fff,-0xc(%ebp)
  801d69:	7e 14                	jle    801d7f <to_page_info+0x3b>
		panic("to_page_info called with invalid pa");
  801d6b:	83 ec 04             	sub    $0x4,%esp
  801d6e:	68 fc 33 80 00       	push   $0x8033fc
  801d73:	6a 22                	push   $0x22
  801d75:	68 e3 33 80 00       	push   $0x8033e3
  801d7a:	e8 6d 0a 00 00       	call   8027ec <_panic>
	return &pageBlockInfoArr[idxInPageInfoArr];
  801d7f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801d82:	89 d0                	mov    %edx,%eax
  801d84:	01 c0                	add    %eax,%eax
  801d86:	01 d0                	add    %edx,%eax
  801d88:	c1 e0 02             	shl    $0x2,%eax
  801d8b:	05 60 40 80 00       	add    $0x804060,%eax
}
  801d90:	c9                   	leave  
  801d91:	c3                   	ret    

00801d92 <initialize_dynamic_allocator>:
//==================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================
bool is_initialized = 0;
void initialize_dynamic_allocator(uint32 daStart, uint32 daEnd)
{
  801d92:	55                   	push   %ebp
  801d93:	89 e5                	mov    %esp,%ebp
  801d95:	83 ec 18             	sub    $0x18,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		assert(daEnd <= daStart + DYN_ALLOC_MAX_SIZE);
  801d98:	8b 45 08             	mov    0x8(%ebp),%eax
  801d9b:	05 00 00 00 02       	add    $0x2000000,%eax
  801da0:	3b 45 0c             	cmp    0xc(%ebp),%eax
  801da3:	73 16                	jae    801dbb <initialize_dynamic_allocator+0x29>
  801da5:	68 20 34 80 00       	push   $0x803420
  801daa:	68 46 34 80 00       	push   $0x803446
  801daf:	6a 34                	push   $0x34
  801db1:	68 e3 33 80 00       	push   $0x8033e3
  801db6:	e8 31 0a 00 00       	call   8027ec <_panic>
		is_initialized = 1;
  801dbb:	c7 05 24 40 80 00 01 	movl   $0x1,0x804024
  801dc2:	00 00 00 
	//==================================================================================
	//==================================================================================
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #1 initialize_dynamic_allocator
	//Your code is here
	// init bounds of the dynalloc
	dynAllocStart = daStart;
  801dc5:	8b 45 08             	mov    0x8(%ebp),%eax
  801dc8:	a3 64 c0 81 00       	mov    %eax,0x81c064
	dynAllocEnd = daEnd;
  801dcd:	8b 45 0c             	mov    0xc(%ebp),%eax
  801dd0:	a3 40 40 80 00       	mov    %eax,0x804040
	// init the list that keep track of all free pageBlockInfoArr instances.
	LIST_INIT(&freePagesList);
  801dd5:	c7 05 48 40 80 00 00 	movl   $0x0,0x804048
  801ddc:	00 00 00 
  801ddf:	c7 05 4c 40 80 00 00 	movl   $0x0,0x80404c
  801de6:	00 00 00 
  801de9:	c7 05 54 40 80 00 00 	movl   $0x0,0x804054
  801df0:	00 00 00 

	// no.of pages in the dynamic allocator.
	int pCount = (daEnd - daStart) / PAGE_SIZE;
  801df3:	8b 45 0c             	mov    0xc(%ebp),%eax
  801df6:	2b 45 08             	sub    0x8(%ebp),%eax
  801df9:	c1 e8 0c             	shr    $0xc,%eax
  801dfc:	89 45 ec             	mov    %eax,-0x14(%ebp)
	// iterate over each page and init its data in pageBlockInfoArr and reset it.
	for (int i = 0; i < pCount; ++i) {
  801dff:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  801e06:	e9 c8 00 00 00       	jmp    801ed3 <initialize_dynamic_allocator+0x141>
	    pageBlockInfoArr[i].block_size = 0;
  801e0b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801e0e:	89 d0                	mov    %edx,%eax
  801e10:	01 c0                	add    %eax,%eax
  801e12:	01 d0                	add    %edx,%eax
  801e14:	c1 e0 02             	shl    $0x2,%eax
  801e17:	05 68 40 80 00       	add    $0x804068,%eax
  801e1c:	66 c7 00 00 00       	movw   $0x0,(%eax)
	    pageBlockInfoArr[i].num_of_free_blocks = 0;
  801e21:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801e24:	89 d0                	mov    %edx,%eax
  801e26:	01 c0                	add    %eax,%eax
  801e28:	01 d0                	add    %edx,%eax
  801e2a:	c1 e0 02             	shl    $0x2,%eax
  801e2d:	05 6a 40 80 00       	add    $0x80406a,%eax
  801e32:	66 c7 00 00 00       	movw   $0x0,(%eax)
	    LIST_INSERT_TAIL(&freePagesList, &pageBlockInfoArr[i]);
  801e37:	8b 15 4c 40 80 00    	mov    0x80404c,%edx
  801e3d:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  801e40:	89 c8                	mov    %ecx,%eax
  801e42:	01 c0                	add    %eax,%eax
  801e44:	01 c8                	add    %ecx,%eax
  801e46:	c1 e0 02             	shl    $0x2,%eax
  801e49:	05 64 40 80 00       	add    $0x804064,%eax
  801e4e:	89 10                	mov    %edx,(%eax)
  801e50:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801e53:	89 d0                	mov    %edx,%eax
  801e55:	01 c0                	add    %eax,%eax
  801e57:	01 d0                	add    %edx,%eax
  801e59:	c1 e0 02             	shl    $0x2,%eax
  801e5c:	05 64 40 80 00       	add    $0x804064,%eax
  801e61:	8b 00                	mov    (%eax),%eax
  801e63:	85 c0                	test   %eax,%eax
  801e65:	74 1b                	je     801e82 <initialize_dynamic_allocator+0xf0>
  801e67:	8b 15 4c 40 80 00    	mov    0x80404c,%edx
  801e6d:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  801e70:	89 c8                	mov    %ecx,%eax
  801e72:	01 c0                	add    %eax,%eax
  801e74:	01 c8                	add    %ecx,%eax
  801e76:	c1 e0 02             	shl    $0x2,%eax
  801e79:	05 60 40 80 00       	add    $0x804060,%eax
  801e7e:	89 02                	mov    %eax,(%edx)
  801e80:	eb 16                	jmp    801e98 <initialize_dynamic_allocator+0x106>
  801e82:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801e85:	89 d0                	mov    %edx,%eax
  801e87:	01 c0                	add    %eax,%eax
  801e89:	01 d0                	add    %edx,%eax
  801e8b:	c1 e0 02             	shl    $0x2,%eax
  801e8e:	05 60 40 80 00       	add    $0x804060,%eax
  801e93:	a3 48 40 80 00       	mov    %eax,0x804048
  801e98:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801e9b:	89 d0                	mov    %edx,%eax
  801e9d:	01 c0                	add    %eax,%eax
  801e9f:	01 d0                	add    %edx,%eax
  801ea1:	c1 e0 02             	shl    $0x2,%eax
  801ea4:	05 60 40 80 00       	add    $0x804060,%eax
  801ea9:	a3 4c 40 80 00       	mov    %eax,0x80404c
  801eae:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801eb1:	89 d0                	mov    %edx,%eax
  801eb3:	01 c0                	add    %eax,%eax
  801eb5:	01 d0                	add    %edx,%eax
  801eb7:	c1 e0 02             	shl    $0x2,%eax
  801eba:	05 60 40 80 00       	add    $0x804060,%eax
  801ebf:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801ec5:	a1 54 40 80 00       	mov    0x804054,%eax
  801eca:	40                   	inc    %eax
  801ecb:	a3 54 40 80 00       	mov    %eax,0x804054
	LIST_INIT(&freePagesList);

	// no.of pages in the dynamic allocator.
	int pCount = (daEnd - daStart) / PAGE_SIZE;
	// iterate over each page and init its data in pageBlockInfoArr and reset it.
	for (int i = 0; i < pCount; ++i) {
  801ed0:	ff 45 f4             	incl   -0xc(%ebp)
  801ed3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ed6:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  801ed9:	0f 8c 2c ff ff ff    	jl     801e0b <initialize_dynamic_allocator+0x79>
	    LIST_INSERT_TAIL(&freePagesList, &pageBlockInfoArr[i]);
	}
	// init the array of lists of each size..
	// 8 16 32 64 128 256 512 1024 2056
	// 0 1  2  3   4  5    6   7    8
	for (int i = 0; i <= (LOG2_MAX_SIZE - LOG2_MIN_SIZE); ++i){
  801edf:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  801ee6:	eb 36                	jmp    801f1e <initialize_dynamic_allocator+0x18c>
		LIST_INIT(&freeBlockLists[i]);
  801ee8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801eeb:	c1 e0 04             	shl    $0x4,%eax
  801eee:	05 80 c0 81 00       	add    $0x81c080,%eax
  801ef3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801ef9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801efc:	c1 e0 04             	shl    $0x4,%eax
  801eff:	05 84 c0 81 00       	add    $0x81c084,%eax
  801f04:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801f0a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f0d:	c1 e0 04             	shl    $0x4,%eax
  801f10:	05 8c c0 81 00       	add    $0x81c08c,%eax
  801f15:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	    LIST_INSERT_TAIL(&freePagesList, &pageBlockInfoArr[i]);
	}
	// init the array of lists of each size..
	// 8 16 32 64 128 256 512 1024 2056
	// 0 1  2  3   4  5    6   7    8
	for (int i = 0; i <= (LOG2_MAX_SIZE - LOG2_MIN_SIZE); ++i){
  801f1b:	ff 45 f0             	incl   -0x10(%ebp)
  801f1e:	83 7d f0 08          	cmpl   $0x8,-0x10(%ebp)
  801f22:	7e c4                	jle    801ee8 <initialize_dynamic_allocator+0x156>
		LIST_INIT(&freeBlockLists[i]);
	}
	//Comment the following line
	//panic("initialize_dynamic_allocator() Not implemented yet");

}
  801f24:	90                   	nop
  801f25:	c9                   	leave  
  801f26:	c3                   	ret    

00801f27 <get_block_size>:

//===========================
// [2] GET BLOCK SIZE:
//===========================
__inline__ uint32 get_block_size(void *va)
{
  801f27:	55                   	push   %ebp
  801f28:	89 e5                	mov    %esp,%ebp
  801f2a:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #2 get_block_size
	//Your code is here
	// get the page that saves this va
	struct PageInfoElement* ptr = to_page_info((uint32)va);
  801f2d:	8b 45 08             	mov    0x8(%ebp),%eax
  801f30:	83 ec 0c             	sub    $0xc,%esp
  801f33:	50                   	push   %eax
  801f34:	e8 0b fe ff ff       	call   801d44 <to_page_info>
  801f39:	83 c4 10             	add    $0x10,%esp
  801f3c:	89 45 f4             	mov    %eax,-0xc(%ebp)
	return ptr->block_size;
  801f3f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f42:	8b 40 08             	mov    0x8(%eax),%eax
  801f45:	0f b7 c0             	movzwl %ax,%eax
	//Comment the following line
	//panic("get_block_size() Not implemented yet");
}
  801f48:	c9                   	leave  
  801f49:	c3                   	ret    

00801f4a <split_page_to_blocks>:
// =====================
// h) split page to blocks and add them in freeBlockLists
// =====================
// function that split the page provided into same sized blocks
//and putem in suitable freeblockList index according to size.
 void split_page_to_blocks(uint32 blk_size, struct PageInfoElement *pageInfo) {
  801f4a:	55                   	push   %ebp
  801f4b:	89 e5                	mov    %esp,%ebp
  801f4d:	83 ec 28             	sub    $0x28,%esp
	 // cur page virtual address by the pageInfo.
	 uint32 page_va = (uint32)to_page_va(pageInfo);
  801f50:	83 ec 0c             	sub    $0xc,%esp
  801f53:	ff 75 0c             	pushl  0xc(%ebp)
  801f56:	e8 77 fd ff ff       	call   801cd2 <to_page_va>
  801f5b:	83 c4 10             	add    $0x10,%esp
  801f5e:	89 45 e8             	mov    %eax,-0x18(%ebp)
	 // no. of blks to save in freeblockList.
	 int blk_count = PAGE_SIZE / blk_size;
  801f61:	b8 00 10 00 00       	mov    $0x1000,%eax
  801f66:	ba 00 00 00 00       	mov    $0x0,%edx
  801f6b:	f7 75 08             	divl   0x8(%ebp)
  801f6e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	 // save page in memory.
	 get_page((uint32*)page_va);
  801f71:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801f74:	83 ec 0c             	sub    $0xc,%esp
  801f77:	50                   	push   %eax
  801f78:	e8 48 f6 ff ff       	call   8015c5 <get_page>
  801f7d:	83 c4 10             	add    $0x10,%esp
	 // assigning the pageInfo data block size, free block which is whole block count.
	 pageInfo->num_of_free_blocks = blk_count;
  801f80:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801f83:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f86:	66 89 42 0a          	mov    %ax,0xa(%edx)
	 pageInfo->block_size = blk_size;
  801f8a:	8b 45 08             	mov    0x8(%ebp),%eax
  801f8d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f90:	66 89 42 08          	mov    %ax,0x8(%edx)
	 // get index by size block in freeblocklist.
	 int idx = 0;
  801f94:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	 for (int i = LOG2_MIN_SIZE; i <= LOG2_MAX_SIZE; i++) {
  801f9b:	c7 45 f0 03 00 00 00 	movl   $0x3,-0x10(%ebp)
  801fa2:	eb 19                	jmp    801fbd <split_page_to_blocks+0x73>
	     if ((1 << i) == blk_size)
  801fa4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801fa7:	ba 01 00 00 00       	mov    $0x1,%edx
  801fac:	88 c1                	mov    %al,%cl
  801fae:	d3 e2                	shl    %cl,%edx
  801fb0:	89 d0                	mov    %edx,%eax
  801fb2:	3b 45 08             	cmp    0x8(%ebp),%eax
  801fb5:	74 0e                	je     801fc5 <split_page_to_blocks+0x7b>
	         break;
	     idx++;
  801fb7:	ff 45 f4             	incl   -0xc(%ebp)
	 // assigning the pageInfo data block size, free block which is whole block count.
	 pageInfo->num_of_free_blocks = blk_count;
	 pageInfo->block_size = blk_size;
	 // get index by size block in freeblocklist.
	 int idx = 0;
	 for (int i = LOG2_MIN_SIZE; i <= LOG2_MAX_SIZE; i++) {
  801fba:	ff 45 f0             	incl   -0x10(%ebp)
  801fbd:	83 7d f0 0b          	cmpl   $0xb,-0x10(%ebp)
  801fc1:	7e e1                	jle    801fa4 <split_page_to_blocks+0x5a>
  801fc3:	eb 01                	jmp    801fc6 <split_page_to_blocks+0x7c>
	     if ((1 << i) == blk_size)
	         break;
  801fc5:	90                   	nop
	     idx++;
	 }
	 // iterate over each blk and make and element of it by passing its address in blockElement pointer and save those in the list.
	 // starting from the page_va.
	 for (uint32 i = 0; i < blk_count; ++i) {
  801fc6:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  801fcd:	e9 a7 00 00 00       	jmp    802079 <split_page_to_blocks+0x12f>
	     struct BlockElement *blk =(struct BlockElement*)(page_va + i * blk_size);
  801fd2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801fd5:	0f af 45 08          	imul   0x8(%ebp),%eax
  801fd9:	89 c2                	mov    %eax,%edx
  801fdb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801fde:	01 d0                	add    %edx,%eax
  801fe0:	89 45 e0             	mov    %eax,-0x20(%ebp)
	     LIST_INSERT_TAIL(&freeBlockLists[idx],blk);
  801fe3:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801fe7:	75 14                	jne    801ffd <split_page_to_blocks+0xb3>
  801fe9:	83 ec 04             	sub    $0x4,%esp
  801fec:	68 5c 34 80 00       	push   $0x80345c
  801ff1:	6a 7c                	push   $0x7c
  801ff3:	68 e3 33 80 00       	push   $0x8033e3
  801ff8:	e8 ef 07 00 00       	call   8027ec <_panic>
  801ffd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802000:	c1 e0 04             	shl    $0x4,%eax
  802003:	05 84 c0 81 00       	add    $0x81c084,%eax
  802008:	8b 10                	mov    (%eax),%edx
  80200a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80200d:	89 50 04             	mov    %edx,0x4(%eax)
  802010:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802013:	8b 40 04             	mov    0x4(%eax),%eax
  802016:	85 c0                	test   %eax,%eax
  802018:	74 14                	je     80202e <split_page_to_blocks+0xe4>
  80201a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80201d:	c1 e0 04             	shl    $0x4,%eax
  802020:	05 84 c0 81 00       	add    $0x81c084,%eax
  802025:	8b 00                	mov    (%eax),%eax
  802027:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80202a:	89 10                	mov    %edx,(%eax)
  80202c:	eb 11                	jmp    80203f <split_page_to_blocks+0xf5>
  80202e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802031:	c1 e0 04             	shl    $0x4,%eax
  802034:	8d 90 80 c0 81 00    	lea    0x81c080(%eax),%edx
  80203a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80203d:	89 02                	mov    %eax,(%edx)
  80203f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802042:	c1 e0 04             	shl    $0x4,%eax
  802045:	8d 90 84 c0 81 00    	lea    0x81c084(%eax),%edx
  80204b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80204e:	89 02                	mov    %eax,(%edx)
  802050:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802053:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802059:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80205c:	c1 e0 04             	shl    $0x4,%eax
  80205f:	05 8c c0 81 00       	add    $0x81c08c,%eax
  802064:	8b 00                	mov    (%eax),%eax
  802066:	8d 50 01             	lea    0x1(%eax),%edx
  802069:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80206c:	c1 e0 04             	shl    $0x4,%eax
  80206f:	05 8c c0 81 00       	add    $0x81c08c,%eax
  802074:	89 10                	mov    %edx,(%eax)
	         break;
	     idx++;
	 }
	 // iterate over each blk and make and element of it by passing its address in blockElement pointer and save those in the list.
	 // starting from the page_va.
	 for (uint32 i = 0; i < blk_count; ++i) {
  802076:	ff 45 ec             	incl   -0x14(%ebp)
  802079:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80207c:	39 45 ec             	cmp    %eax,-0x14(%ebp)
  80207f:	0f 82 4d ff ff ff    	jb     801fd2 <split_page_to_blocks+0x88>
	     struct BlockElement *blk =(struct BlockElement*)(page_va + i * blk_size);
	     LIST_INSERT_TAIL(&freeBlockLists[idx],blk);
	 }
 }
  802085:	90                   	nop
  802086:	c9                   	leave  
  802087:	c3                   	ret    

00802088 <alloc_block>:

//===========================
// 3) ALLOCATE BLOCK:
//===========================
void *alloc_block(uint32 size)
{
  802088:	55                   	push   %ebp
  802089:	89 e5                	mov    %esp,%ebp
  80208b:	83 ec 38             	sub    $0x38,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		assert(size <= DYN_ALLOC_MAX_BLOCK_SIZE);
  80208e:	81 7d 08 00 08 00 00 	cmpl   $0x800,0x8(%ebp)
  802095:	76 19                	jbe    8020b0 <alloc_block+0x28>
  802097:	68 80 34 80 00       	push   $0x803480
  80209c:	68 46 34 80 00       	push   $0x803446
  8020a1:	68 8a 00 00 00       	push   $0x8a
  8020a6:	68 e3 33 80 00       	push   $0x8033e3
  8020ab:	e8 3c 07 00 00       	call   8027ec <_panic>
	//==================================================================================
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #3 alloc_block
	//Your code is here
	//Comment the following line
	// get index in freeBlockList by size.
	uint32 idx = 0;
  8020b0:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int i = LOG2_MIN_SIZE; i <= LOG2_MAX_SIZE; ++i){
  8020b7:	c7 45 f0 03 00 00 00 	movl   $0x3,-0x10(%ebp)
  8020be:	eb 19                	jmp    8020d9 <alloc_block+0x51>
		if((1 << i) >= size) break;
  8020c0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8020c3:	ba 01 00 00 00       	mov    $0x1,%edx
  8020c8:	88 c1                	mov    %al,%cl
  8020ca:	d3 e2                	shl    %cl,%edx
  8020cc:	89 d0                	mov    %edx,%eax
  8020ce:	3b 45 08             	cmp    0x8(%ebp),%eax
  8020d1:	73 0e                	jae    8020e1 <alloc_block+0x59>
		idx++;
  8020d3:	ff 45 f4             	incl   -0xc(%ebp)
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #3 alloc_block
	//Your code is here
	//Comment the following line
	// get index in freeBlockList by size.
	uint32 idx = 0;
	for (int i = LOG2_MIN_SIZE; i <= LOG2_MAX_SIZE; ++i){
  8020d6:	ff 45 f0             	incl   -0x10(%ebp)
  8020d9:	83 7d f0 0b          	cmpl   $0xb,-0x10(%ebp)
  8020dd:	7e e1                	jle    8020c0 <alloc_block+0x38>
  8020df:	eb 01                	jmp    8020e2 <alloc_block+0x5a>
		if((1 << i) >= size) break;
  8020e1:	90                   	nop
		idx++;
	}

	//case 1: the free block of the cur size is available.
	if (freeBlockLists[idx].size > 0) {
  8020e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020e5:	c1 e0 04             	shl    $0x4,%eax
  8020e8:	05 8c c0 81 00       	add    $0x81c08c,%eax
  8020ed:	8b 00                	mov    (%eax),%eax
  8020ef:	85 c0                	test   %eax,%eax
  8020f1:	0f 84 df 00 00 00    	je     8021d6 <alloc_block+0x14e>

		// remove from the list and updat the pageInfoArr free blocks.
		// pop from the freeBlockList.
		struct BlockElement *blk = LIST_FIRST(&freeBlockLists[idx]);
  8020f7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020fa:	c1 e0 04             	shl    $0x4,%eax
  8020fd:	05 80 c0 81 00       	add    $0x81c080,%eax
  802102:	8b 00                	mov    (%eax),%eax
  802104:	89 45 ec             	mov    %eax,-0x14(%ebp)
	    LIST_REMOVE(&freeBlockLists[idx], blk);
  802107:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80210b:	75 17                	jne    802124 <alloc_block+0x9c>
  80210d:	83 ec 04             	sub    $0x4,%esp
  802110:	68 a1 34 80 00       	push   $0x8034a1
  802115:	68 9e 00 00 00       	push   $0x9e
  80211a:	68 e3 33 80 00       	push   $0x8033e3
  80211f:	e8 c8 06 00 00       	call   8027ec <_panic>
  802124:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802127:	8b 00                	mov    (%eax),%eax
  802129:	85 c0                	test   %eax,%eax
  80212b:	74 10                	je     80213d <alloc_block+0xb5>
  80212d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802130:	8b 00                	mov    (%eax),%eax
  802132:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802135:	8b 52 04             	mov    0x4(%edx),%edx
  802138:	89 50 04             	mov    %edx,0x4(%eax)
  80213b:	eb 14                	jmp    802151 <alloc_block+0xc9>
  80213d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802140:	8b 40 04             	mov    0x4(%eax),%eax
  802143:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802146:	c1 e2 04             	shl    $0x4,%edx
  802149:	81 c2 84 c0 81 00    	add    $0x81c084,%edx
  80214f:	89 02                	mov    %eax,(%edx)
  802151:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802154:	8b 40 04             	mov    0x4(%eax),%eax
  802157:	85 c0                	test   %eax,%eax
  802159:	74 0f                	je     80216a <alloc_block+0xe2>
  80215b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80215e:	8b 40 04             	mov    0x4(%eax),%eax
  802161:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802164:	8b 12                	mov    (%edx),%edx
  802166:	89 10                	mov    %edx,(%eax)
  802168:	eb 13                	jmp    80217d <alloc_block+0xf5>
  80216a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80216d:	8b 00                	mov    (%eax),%eax
  80216f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802172:	c1 e2 04             	shl    $0x4,%edx
  802175:	81 c2 80 c0 81 00    	add    $0x81c080,%edx
  80217b:	89 02                	mov    %eax,(%edx)
  80217d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802180:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802186:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802189:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802190:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802193:	c1 e0 04             	shl    $0x4,%eax
  802196:	05 8c c0 81 00       	add    $0x81c08c,%eax
  80219b:	8b 00                	mov    (%eax),%eax
  80219d:	8d 50 ff             	lea    -0x1(%eax),%edx
  8021a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021a3:	c1 e0 04             	shl    $0x4,%eax
  8021a6:	05 8c c0 81 00       	add    $0x81c08c,%eax
  8021ab:	89 10                	mov    %edx,(%eax)
	    // update pageBlockInfoArr
	    struct PageInfoElement *pageInfo = to_page_info((uint32)blk);
  8021ad:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8021b0:	83 ec 0c             	sub    $0xc,%esp
  8021b3:	50                   	push   %eax
  8021b4:	e8 8b fb ff ff       	call   801d44 <to_page_info>
  8021b9:	83 c4 10             	add    $0x10,%esp
  8021bc:	89 45 e8             	mov    %eax,-0x18(%ebp)
	    pageInfo->num_of_free_blocks--;
  8021bf:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8021c2:	66 8b 40 0a          	mov    0xa(%eax),%ax
  8021c6:	48                   	dec    %eax
  8021c7:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8021ca:	66 89 42 0a          	mov    %ax,0xa(%edx)
	    return blk;
  8021ce:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8021d1:	e9 bc 02 00 00       	jmp    802492 <alloc_block+0x40a>
	}else{ //case(2, 3): 2. no free blocks available in the freeblocklist but there is free pages.
				//3. no free blocks and no available freepages so search in higher block sizes.
		// case 2:
		if(freePagesList.size > 0){ //have free pages.
  8021d6:	a1 54 40 80 00       	mov    0x804054,%eax
  8021db:	85 c0                	test   %eax,%eax
  8021dd:	0f 84 7d 02 00 00    	je     802460 <alloc_block+0x3d8>
			// get page to split and use from freepagesList.
			struct PageInfoElement *ptr_new_page = LIST_FIRST(&freePagesList);
  8021e3:	a1 48 40 80 00       	mov    0x804048,%eax
  8021e8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			LIST_REMOVE(&freePagesList, ptr_new_page);
  8021eb:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8021ef:	75 17                	jne    802208 <alloc_block+0x180>
  8021f1:	83 ec 04             	sub    $0x4,%esp
  8021f4:	68 a1 34 80 00       	push   $0x8034a1
  8021f9:	68 a9 00 00 00       	push   $0xa9
  8021fe:	68 e3 33 80 00       	push   $0x8033e3
  802203:	e8 e4 05 00 00       	call   8027ec <_panic>
  802208:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80220b:	8b 00                	mov    (%eax),%eax
  80220d:	85 c0                	test   %eax,%eax
  80220f:	74 10                	je     802221 <alloc_block+0x199>
  802211:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802214:	8b 00                	mov    (%eax),%eax
  802216:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802219:	8b 52 04             	mov    0x4(%edx),%edx
  80221c:	89 50 04             	mov    %edx,0x4(%eax)
  80221f:	eb 0b                	jmp    80222c <alloc_block+0x1a4>
  802221:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802224:	8b 40 04             	mov    0x4(%eax),%eax
  802227:	a3 4c 40 80 00       	mov    %eax,0x80404c
  80222c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80222f:	8b 40 04             	mov    0x4(%eax),%eax
  802232:	85 c0                	test   %eax,%eax
  802234:	74 0f                	je     802245 <alloc_block+0x1bd>
  802236:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802239:	8b 40 04             	mov    0x4(%eax),%eax
  80223c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80223f:	8b 12                	mov    (%edx),%edx
  802241:	89 10                	mov    %edx,(%eax)
  802243:	eb 0a                	jmp    80224f <alloc_block+0x1c7>
  802245:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802248:	8b 00                	mov    (%eax),%eax
  80224a:	a3 48 40 80 00       	mov    %eax,0x804048
  80224f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802252:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802258:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80225b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802262:	a1 54 40 80 00       	mov    0x804054,%eax
  802267:	48                   	dec    %eax
  802268:	a3 54 40 80 00       	mov    %eax,0x804054
			// from page to freeblockList by the pageInfo and the block size.
			split_page_to_blocks(1 << (idx + LOG2_MIN_SIZE), ptr_new_page);
  80226d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802270:	83 c0 03             	add    $0x3,%eax
  802273:	ba 01 00 00 00       	mov    $0x1,%edx
  802278:	88 c1                	mov    %al,%cl
  80227a:	d3 e2                	shl    %cl,%edx
  80227c:	89 d0                	mov    %edx,%eax
  80227e:	83 ec 08             	sub    $0x8,%esp
  802281:	ff 75 e4             	pushl  -0x1c(%ebp)
  802284:	50                   	push   %eax
  802285:	e8 c0 fc ff ff       	call   801f4a <split_page_to_blocks>
  80228a:	83 c4 10             	add    $0x10,%esp

			// remove from the list and updat the pageInfoArr free blocks.
			// pop from the freeBlockList.
			struct BlockElement *blk = LIST_FIRST(&freeBlockLists[idx]);
  80228d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802290:	c1 e0 04             	shl    $0x4,%eax
  802293:	05 80 c0 81 00       	add    $0x81c080,%eax
  802298:	8b 00                	mov    (%eax),%eax
  80229a:	89 45 e0             	mov    %eax,-0x20(%ebp)
		    LIST_REMOVE(&freeBlockLists[idx], blk);
  80229d:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8022a1:	75 17                	jne    8022ba <alloc_block+0x232>
  8022a3:	83 ec 04             	sub    $0x4,%esp
  8022a6:	68 a1 34 80 00       	push   $0x8034a1
  8022ab:	68 b0 00 00 00       	push   $0xb0
  8022b0:	68 e3 33 80 00       	push   $0x8033e3
  8022b5:	e8 32 05 00 00       	call   8027ec <_panic>
  8022ba:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8022bd:	8b 00                	mov    (%eax),%eax
  8022bf:	85 c0                	test   %eax,%eax
  8022c1:	74 10                	je     8022d3 <alloc_block+0x24b>
  8022c3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8022c6:	8b 00                	mov    (%eax),%eax
  8022c8:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8022cb:	8b 52 04             	mov    0x4(%edx),%edx
  8022ce:	89 50 04             	mov    %edx,0x4(%eax)
  8022d1:	eb 14                	jmp    8022e7 <alloc_block+0x25f>
  8022d3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8022d6:	8b 40 04             	mov    0x4(%eax),%eax
  8022d9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8022dc:	c1 e2 04             	shl    $0x4,%edx
  8022df:	81 c2 84 c0 81 00    	add    $0x81c084,%edx
  8022e5:	89 02                	mov    %eax,(%edx)
  8022e7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8022ea:	8b 40 04             	mov    0x4(%eax),%eax
  8022ed:	85 c0                	test   %eax,%eax
  8022ef:	74 0f                	je     802300 <alloc_block+0x278>
  8022f1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8022f4:	8b 40 04             	mov    0x4(%eax),%eax
  8022f7:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8022fa:	8b 12                	mov    (%edx),%edx
  8022fc:	89 10                	mov    %edx,(%eax)
  8022fe:	eb 13                	jmp    802313 <alloc_block+0x28b>
  802300:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802303:	8b 00                	mov    (%eax),%eax
  802305:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802308:	c1 e2 04             	shl    $0x4,%edx
  80230b:	81 c2 80 c0 81 00    	add    $0x81c080,%edx
  802311:	89 02                	mov    %eax,(%edx)
  802313:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802316:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80231c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80231f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802326:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802329:	c1 e0 04             	shl    $0x4,%eax
  80232c:	05 8c c0 81 00       	add    $0x81c08c,%eax
  802331:	8b 00                	mov    (%eax),%eax
  802333:	8d 50 ff             	lea    -0x1(%eax),%edx
  802336:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802339:	c1 e0 04             	shl    $0x4,%eax
  80233c:	05 8c c0 81 00       	add    $0x81c08c,%eax
  802341:	89 10                	mov    %edx,(%eax)
		    // update pageBlockInfoArr
		    struct PageInfoElement *pageInfo = to_page_info((uint32)blk);
  802343:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802346:	83 ec 0c             	sub    $0xc,%esp
  802349:	50                   	push   %eax
  80234a:	e8 f5 f9 ff ff       	call   801d44 <to_page_info>
  80234f:	83 c4 10             	add    $0x10,%esp
  802352:	89 45 dc             	mov    %eax,-0x24(%ebp)
		    pageInfo->num_of_free_blocks--;
  802355:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802358:	66 8b 40 0a          	mov    0xa(%eax),%ax
  80235c:	48                   	dec    %eax
  80235d:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802360:	66 89 42 0a          	mov    %ax,0xa(%edx)
		    return blk;
  802364:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802367:	e9 26 01 00 00       	jmp    802492 <alloc_block+0x40a>
		}else{//case 3: no free block and no free page so iterate and try to find bigger size.
			// iterate over the list until finding available block
			while (idx <= (LOG2_MAX_SIZE - LOG2_MIN_SIZE) && freeBlockLists[idx].size == 0) {
				idx++;
  80236c:	ff 45 f4             	incl   -0xc(%ebp)
				// found free block
				if(freeBlockLists[idx].size > 0){
  80236f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802372:	c1 e0 04             	shl    $0x4,%eax
  802375:	05 8c c0 81 00       	add    $0x81c08c,%eax
  80237a:	8b 00                	mov    (%eax),%eax
  80237c:	85 c0                	test   %eax,%eax
  80237e:	0f 84 dc 00 00 00    	je     802460 <alloc_block+0x3d8>
					// remove from the list and updat the pageInfoArr free blocks.
					// pop from the freeBlockList.
					struct BlockElement *blk = LIST_FIRST(&freeBlockLists[idx]);
  802384:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802387:	c1 e0 04             	shl    $0x4,%eax
  80238a:	05 80 c0 81 00       	add    $0x81c080,%eax
  80238f:	8b 00                	mov    (%eax),%eax
  802391:	89 45 d8             	mov    %eax,-0x28(%ebp)
				    LIST_REMOVE(&freeBlockLists[idx], blk);
  802394:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  802398:	75 17                	jne    8023b1 <alloc_block+0x329>
  80239a:	83 ec 04             	sub    $0x4,%esp
  80239d:	68 a1 34 80 00       	push   $0x8034a1
  8023a2:	68 be 00 00 00       	push   $0xbe
  8023a7:	68 e3 33 80 00       	push   $0x8033e3
  8023ac:	e8 3b 04 00 00       	call   8027ec <_panic>
  8023b1:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8023b4:	8b 00                	mov    (%eax),%eax
  8023b6:	85 c0                	test   %eax,%eax
  8023b8:	74 10                	je     8023ca <alloc_block+0x342>
  8023ba:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8023bd:	8b 00                	mov    (%eax),%eax
  8023bf:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8023c2:	8b 52 04             	mov    0x4(%edx),%edx
  8023c5:	89 50 04             	mov    %edx,0x4(%eax)
  8023c8:	eb 14                	jmp    8023de <alloc_block+0x356>
  8023ca:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8023cd:	8b 40 04             	mov    0x4(%eax),%eax
  8023d0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8023d3:	c1 e2 04             	shl    $0x4,%edx
  8023d6:	81 c2 84 c0 81 00    	add    $0x81c084,%edx
  8023dc:	89 02                	mov    %eax,(%edx)
  8023de:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8023e1:	8b 40 04             	mov    0x4(%eax),%eax
  8023e4:	85 c0                	test   %eax,%eax
  8023e6:	74 0f                	je     8023f7 <alloc_block+0x36f>
  8023e8:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8023eb:	8b 40 04             	mov    0x4(%eax),%eax
  8023ee:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8023f1:	8b 12                	mov    (%edx),%edx
  8023f3:	89 10                	mov    %edx,(%eax)
  8023f5:	eb 13                	jmp    80240a <alloc_block+0x382>
  8023f7:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8023fa:	8b 00                	mov    (%eax),%eax
  8023fc:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8023ff:	c1 e2 04             	shl    $0x4,%edx
  802402:	81 c2 80 c0 81 00    	add    $0x81c080,%edx
  802408:	89 02                	mov    %eax,(%edx)
  80240a:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80240d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802413:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802416:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80241d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802420:	c1 e0 04             	shl    $0x4,%eax
  802423:	05 8c c0 81 00       	add    $0x81c08c,%eax
  802428:	8b 00                	mov    (%eax),%eax
  80242a:	8d 50 ff             	lea    -0x1(%eax),%edx
  80242d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802430:	c1 e0 04             	shl    $0x4,%eax
  802433:	05 8c c0 81 00       	add    $0x81c08c,%eax
  802438:	89 10                	mov    %edx,(%eax)
				    // update pageBlockInfoArr
				    struct PageInfoElement *pageInfo = to_page_info((uint32)blk);
  80243a:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80243d:	83 ec 0c             	sub    $0xc,%esp
  802440:	50                   	push   %eax
  802441:	e8 fe f8 ff ff       	call   801d44 <to_page_info>
  802446:	83 c4 10             	add    $0x10,%esp
  802449:	89 45 d4             	mov    %eax,-0x2c(%ebp)
				    pageInfo->num_of_free_blocks--;
  80244c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80244f:	66 8b 40 0a          	mov    0xa(%eax),%ax
  802453:	48                   	dec    %eax
  802454:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  802457:	66 89 42 0a          	mov    %ax,0xa(%edx)
				    return blk;
  80245b:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80245e:	eb 32                	jmp    802492 <alloc_block+0x40a>
		    struct PageInfoElement *pageInfo = to_page_info((uint32)blk);
		    pageInfo->num_of_free_blocks--;
		    return blk;
		}else{//case 3: no free block and no free page so iterate and try to find bigger size.
			// iterate over the list until finding available block
			while (idx <= (LOG2_MAX_SIZE - LOG2_MIN_SIZE) && freeBlockLists[idx].size == 0) {
  802460:	83 7d f4 08          	cmpl   $0x8,-0xc(%ebp)
  802464:	77 15                	ja     80247b <alloc_block+0x3f3>
  802466:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802469:	c1 e0 04             	shl    $0x4,%eax
  80246c:	05 8c c0 81 00       	add    $0x81c08c,%eax
  802471:	8b 00                	mov    (%eax),%eax
  802473:	85 c0                	test   %eax,%eax
  802475:	0f 84 f1 fe ff ff    	je     80236c <alloc_block+0x2e4>
				}
			}
		}
	}
	//case4: no free blocks or pages.
	panic("no free blocks!");
  80247b:	83 ec 04             	sub    $0x4,%esp
  80247e:	68 bf 34 80 00       	push   $0x8034bf
  802483:	68 c8 00 00 00       	push   $0xc8
  802488:	68 e3 33 80 00       	push   $0x8033e3
  80248d:	e8 5a 03 00 00       	call   8027ec <_panic>
	//panic("alloc_block() Not implemented yet");
	//TODO: [PROJECT'25.BONUS#1] DYNAMIC ALLOCATOR - block if no free block
	return NULL;
}
  802492:	c9                   	leave  
  802493:	c3                   	ret    

00802494 <free_block>:

//===========================
// [4] FREE BLOCK:
//===========================
void free_block(void *va)
{
  802494:	55                   	push   %ebp
  802495:	89 e5                	mov    %esp,%ebp
  802497:	83 ec 38             	sub    $0x38,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		assert((uint32)va >= dynAllocStart && (uint32)va < dynAllocEnd);
  80249a:	8b 55 08             	mov    0x8(%ebp),%edx
  80249d:	a1 64 c0 81 00       	mov    0x81c064,%eax
  8024a2:	39 c2                	cmp    %eax,%edx
  8024a4:	72 0c                	jb     8024b2 <free_block+0x1e>
  8024a6:	8b 55 08             	mov    0x8(%ebp),%edx
  8024a9:	a1 40 40 80 00       	mov    0x804040,%eax
  8024ae:	39 c2                	cmp    %eax,%edx
  8024b0:	72 19                	jb     8024cb <free_block+0x37>
  8024b2:	68 d0 34 80 00       	push   $0x8034d0
  8024b7:	68 46 34 80 00       	push   $0x803446
  8024bc:	68 d7 00 00 00       	push   $0xd7
  8024c1:	68 e3 33 80 00       	push   $0x8033e3
  8024c6:	e8 21 03 00 00       	call   8027ec <_panic>
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #4 free_block
	//Your code is here
	//Comment the following line
	// va of a piece in memory to free so:
	// 1. get its page, and make blk with this address to be put in the freeBlockList.
	struct BlockElement* blk_to_free = (struct BlockElement*)va;
  8024cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8024ce:	89 45 e8             	mov    %eax,-0x18(%ebp)
	struct PageInfoElement *pageInfo = to_page_info((uint32)va);
  8024d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8024d4:	83 ec 0c             	sub    $0xc,%esp
  8024d7:	50                   	push   %eax
  8024d8:	e8 67 f8 ff ff       	call   801d44 <to_page_info>
  8024dd:	83 c4 10             	add    $0x10,%esp
  8024e0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	uint32 blk_size = pageInfo->block_size;
  8024e3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8024e6:	8b 40 08             	mov    0x8(%eax),%eax
  8024e9:	0f b7 c0             	movzwl %ax,%eax
  8024ec:	89 45 e0             	mov    %eax,-0x20(%ebp)

	// its index in the freeBlocklist.
	int idx = 0;
  8024ef:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int i = LOG2_MIN_SIZE; i <= LOG2_MAX_SIZE; i++) {
  8024f6:	c7 45 f0 03 00 00 00 	movl   $0x3,-0x10(%ebp)
  8024fd:	eb 19                	jmp    802518 <free_block+0x84>
	    if ((1 << i) == blk_size)
  8024ff:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802502:	ba 01 00 00 00       	mov    $0x1,%edx
  802507:	88 c1                	mov    %al,%cl
  802509:	d3 e2                	shl    %cl,%edx
  80250b:	89 d0                	mov    %edx,%eax
  80250d:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  802510:	74 0e                	je     802520 <free_block+0x8c>
	        break;
	    idx++;
  802512:	ff 45 f4             	incl   -0xc(%ebp)
	struct PageInfoElement *pageInfo = to_page_info((uint32)va);
	uint32 blk_size = pageInfo->block_size;

	// its index in the freeBlocklist.
	int idx = 0;
	for (int i = LOG2_MIN_SIZE; i <= LOG2_MAX_SIZE; i++) {
  802515:	ff 45 f0             	incl   -0x10(%ebp)
  802518:	83 7d f0 0b          	cmpl   $0xb,-0x10(%ebp)
  80251c:	7e e1                	jle    8024ff <free_block+0x6b>
  80251e:	eb 01                	jmp    802521 <free_block+0x8d>
	    if ((1 << i) == blk_size)
	        break;
  802520:	90                   	nop
	    idx++;
	}

	pageInfo->num_of_free_blocks++;
  802521:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802524:	66 8b 40 0a          	mov    0xa(%eax),%ax
  802528:	40                   	inc    %eax
  802529:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80252c:	66 89 42 0a          	mov    %ax,0xa(%edx)
	LIST_INSERT_TAIL(&freeBlockLists[idx], blk_to_free);
  802530:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802534:	75 17                	jne    80254d <free_block+0xb9>
  802536:	83 ec 04             	sub    $0x4,%esp
  802539:	68 5c 34 80 00       	push   $0x80345c
  80253e:	68 ee 00 00 00       	push   $0xee
  802543:	68 e3 33 80 00       	push   $0x8033e3
  802548:	e8 9f 02 00 00       	call   8027ec <_panic>
  80254d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802550:	c1 e0 04             	shl    $0x4,%eax
  802553:	05 84 c0 81 00       	add    $0x81c084,%eax
  802558:	8b 10                	mov    (%eax),%edx
  80255a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80255d:	89 50 04             	mov    %edx,0x4(%eax)
  802560:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802563:	8b 40 04             	mov    0x4(%eax),%eax
  802566:	85 c0                	test   %eax,%eax
  802568:	74 14                	je     80257e <free_block+0xea>
  80256a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80256d:	c1 e0 04             	shl    $0x4,%eax
  802570:	05 84 c0 81 00       	add    $0x81c084,%eax
  802575:	8b 00                	mov    (%eax),%eax
  802577:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80257a:	89 10                	mov    %edx,(%eax)
  80257c:	eb 11                	jmp    80258f <free_block+0xfb>
  80257e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802581:	c1 e0 04             	shl    $0x4,%eax
  802584:	8d 90 80 c0 81 00    	lea    0x81c080(%eax),%edx
  80258a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80258d:	89 02                	mov    %eax,(%edx)
  80258f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802592:	c1 e0 04             	shl    $0x4,%eax
  802595:	8d 90 84 c0 81 00    	lea    0x81c084(%eax),%edx
  80259b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80259e:	89 02                	mov    %eax,(%edx)
  8025a0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8025a3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8025a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025ac:	c1 e0 04             	shl    $0x4,%eax
  8025af:	05 8c c0 81 00       	add    $0x81c08c,%eax
  8025b4:	8b 00                	mov    (%eax),%eax
  8025b6:	8d 50 01             	lea    0x1(%eax),%edx
  8025b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025bc:	c1 e0 04             	shl    $0x4,%eax
  8025bf:	05 8c c0 81 00       	add    $0x81c08c,%eax
  8025c4:	89 10                	mov    %edx,(%eax)

	// now, case 1: the page all blocks are freed so you free the page.
	int blk_count = PAGE_SIZE / blk_size;
  8025c6:	b8 00 10 00 00       	mov    $0x1000,%eax
  8025cb:	ba 00 00 00 00       	mov    $0x0,%edx
  8025d0:	f7 75 e0             	divl   -0x20(%ebp)
  8025d3:	89 45 dc             	mov    %eax,-0x24(%ebp)
	// the blk count in the page is same as number fo free blocks free up the page.
	if (pageInfo->num_of_free_blocks == blk_count) {
  8025d6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8025d9:	66 8b 40 0a          	mov    0xa(%eax),%ax
  8025dd:	0f b7 c0             	movzwl %ax,%eax
  8025e0:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  8025e3:	0f 85 70 01 00 00    	jne    802759 <free_block+0x2c5>
		uint32 page_va = to_page_va(pageInfo);
  8025e9:	83 ec 0c             	sub    $0xc,%esp
  8025ec:	ff 75 e4             	pushl  -0x1c(%ebp)
  8025ef:	e8 de f6 ff ff       	call   801cd2 <to_page_va>
  8025f4:	83 c4 10             	add    $0x10,%esp
  8025f7:	89 45 d8             	mov    %eax,-0x28(%ebp)
		// remove all blk in the freeBlockList.
		for (uint32 off = 0; off < PAGE_SIZE; off += blk_size) {
  8025fa:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  802601:	e9 b7 00 00 00       	jmp    8026bd <free_block+0x229>
			struct BlockElement *blk = (struct BlockElement*)(page_va + off);
  802606:	8b 55 d8             	mov    -0x28(%ebp),%edx
  802609:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80260c:	01 d0                	add    %edx,%eax
  80260e:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			LIST_REMOVE(&freeBlockLists[idx], blk);
  802611:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  802615:	75 17                	jne    80262e <free_block+0x19a>
  802617:	83 ec 04             	sub    $0x4,%esp
  80261a:	68 a1 34 80 00       	push   $0x8034a1
  80261f:	68 f8 00 00 00       	push   $0xf8
  802624:	68 e3 33 80 00       	push   $0x8033e3
  802629:	e8 be 01 00 00       	call   8027ec <_panic>
  80262e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802631:	8b 00                	mov    (%eax),%eax
  802633:	85 c0                	test   %eax,%eax
  802635:	74 10                	je     802647 <free_block+0x1b3>
  802637:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80263a:	8b 00                	mov    (%eax),%eax
  80263c:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  80263f:	8b 52 04             	mov    0x4(%edx),%edx
  802642:	89 50 04             	mov    %edx,0x4(%eax)
  802645:	eb 14                	jmp    80265b <free_block+0x1c7>
  802647:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80264a:	8b 40 04             	mov    0x4(%eax),%eax
  80264d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802650:	c1 e2 04             	shl    $0x4,%edx
  802653:	81 c2 84 c0 81 00    	add    $0x81c084,%edx
  802659:	89 02                	mov    %eax,(%edx)
  80265b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80265e:	8b 40 04             	mov    0x4(%eax),%eax
  802661:	85 c0                	test   %eax,%eax
  802663:	74 0f                	je     802674 <free_block+0x1e0>
  802665:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802668:	8b 40 04             	mov    0x4(%eax),%eax
  80266b:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  80266e:	8b 12                	mov    (%edx),%edx
  802670:	89 10                	mov    %edx,(%eax)
  802672:	eb 13                	jmp    802687 <free_block+0x1f3>
  802674:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802677:	8b 00                	mov    (%eax),%eax
  802679:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80267c:	c1 e2 04             	shl    $0x4,%edx
  80267f:	81 c2 80 c0 81 00    	add    $0x81c080,%edx
  802685:	89 02                	mov    %eax,(%edx)
  802687:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80268a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802690:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802693:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80269a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80269d:	c1 e0 04             	shl    $0x4,%eax
  8026a0:	05 8c c0 81 00       	add    $0x81c08c,%eax
  8026a5:	8b 00                	mov    (%eax),%eax
  8026a7:	8d 50 ff             	lea    -0x1(%eax),%edx
  8026aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026ad:	c1 e0 04             	shl    $0x4,%eax
  8026b0:	05 8c c0 81 00       	add    $0x81c08c,%eax
  8026b5:	89 10                	mov    %edx,(%eax)
	int blk_count = PAGE_SIZE / blk_size;
	// the blk count in the page is same as number fo free blocks free up the page.
	if (pageInfo->num_of_free_blocks == blk_count) {
		uint32 page_va = to_page_va(pageInfo);
		// remove all blk in the freeBlockList.
		for (uint32 off = 0; off < PAGE_SIZE; off += blk_size) {
  8026b7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8026ba:	01 45 ec             	add    %eax,-0x14(%ebp)
  8026bd:	81 7d ec ff 0f 00 00 	cmpl   $0xfff,-0x14(%ebp)
  8026c4:	0f 86 3c ff ff ff    	jbe    802606 <free_block+0x172>
			struct BlockElement *blk = (struct BlockElement*)(page_va + off);
			LIST_REMOVE(&freeBlockLists[idx], blk);
		}
		// reset page info.
		pageInfo->block_size = 0;
  8026ca:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8026cd:	66 c7 40 08 00 00    	movw   $0x0,0x8(%eax)
		pageInfo->num_of_free_blocks = 0;
  8026d3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8026d6:	66 c7 40 0a 00 00    	movw   $0x0,0xa(%eax)
		// add it to the available pages.
		LIST_INSERT_TAIL(&freePagesList, pageInfo);
  8026dc:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8026e0:	75 17                	jne    8026f9 <free_block+0x265>
  8026e2:	83 ec 04             	sub    $0x4,%esp
  8026e5:	68 5c 34 80 00       	push   $0x80345c
  8026ea:	68 fe 00 00 00       	push   $0xfe
  8026ef:	68 e3 33 80 00       	push   $0x8033e3
  8026f4:	e8 f3 00 00 00       	call   8027ec <_panic>
  8026f9:	8b 15 4c 40 80 00    	mov    0x80404c,%edx
  8026ff:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802702:	89 50 04             	mov    %edx,0x4(%eax)
  802705:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802708:	8b 40 04             	mov    0x4(%eax),%eax
  80270b:	85 c0                	test   %eax,%eax
  80270d:	74 0c                	je     80271b <free_block+0x287>
  80270f:	a1 4c 40 80 00       	mov    0x80404c,%eax
  802714:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802717:	89 10                	mov    %edx,(%eax)
  802719:	eb 08                	jmp    802723 <free_block+0x28f>
  80271b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80271e:	a3 48 40 80 00       	mov    %eax,0x804048
  802723:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802726:	a3 4c 40 80 00       	mov    %eax,0x80404c
  80272b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80272e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802734:	a1 54 40 80 00       	mov    0x804054,%eax
  802739:	40                   	inc    %eax
  80273a:	a3 54 40 80 00       	mov    %eax,0x804054
		// make it available in memory.
		return_page((uint32 *)to_page_va(pageInfo));
  80273f:	83 ec 0c             	sub    $0xc,%esp
  802742:	ff 75 e4             	pushl  -0x1c(%ebp)
  802745:	e8 88 f5 ff ff       	call   801cd2 <to_page_va>
  80274a:	83 c4 10             	add    $0x10,%esp
  80274d:	83 ec 0c             	sub    $0xc,%esp
  802750:	50                   	push   %eax
  802751:	e8 b8 ee ff ff       	call   80160e <return_page>
  802756:	83 c4 10             	add    $0x10,%esp
	}
	//panic("free_block() Not implemented yet");
}
  802759:	90                   	nop
  80275a:	c9                   	leave  
  80275b:	c3                   	ret    

0080275c <realloc_block>:

//===========================
// [1] REALLOCATE BLOCK:
//===========================
void *realloc_block(void* va, uint32 new_size)
{
  80275c:	55                   	push   %ebp
  80275d:	89 e5                	mov    %esp,%ebp
  80275f:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.BONUS#2] KERNEL REALLOC - realloc_block
	//Your code is here
	//Comment the following line
	panic("realloc_block() Not implemented yet");
  802762:	83 ec 04             	sub    $0x4,%esp
  802765:	68 08 35 80 00       	push   $0x803508
  80276a:	68 11 01 00 00       	push   $0x111
  80276f:	68 e3 33 80 00       	push   $0x8033e3
  802774:	e8 73 00 00 00       	call   8027ec <_panic>

00802779 <create_semaphore>:
// User-level Semaphore

#include "inc/lib.h"

struct semaphore create_semaphore(char *semaphoreName, uint32 value)
{
  802779:	55                   	push   %ebp
  80277a:	89 e5                	mov    %esp,%ebp
  80277c:	83 ec 08             	sub    $0x8,%esp
	panic("create_semaphore() is not implemented yet...!!");
  80277f:	83 ec 04             	sub    $0x4,%esp
  802782:	68 2c 35 80 00       	push   $0x80352c
  802787:	6a 07                	push   $0x7
  802789:	68 5b 35 80 00       	push   $0x80355b
  80278e:	e8 59 00 00 00       	call   8027ec <_panic>

00802793 <get_semaphore>:
}
struct semaphore get_semaphore(int32 ownerEnvID, char* semaphoreName)
{
  802793:	55                   	push   %ebp
  802794:	89 e5                	mov    %esp,%ebp
  802796:	83 ec 08             	sub    $0x8,%esp
	panic("get_semaphore() is not implemented yet...!!");
  802799:	83 ec 04             	sub    $0x4,%esp
  80279c:	68 6c 35 80 00       	push   $0x80356c
  8027a1:	6a 0b                	push   $0xb
  8027a3:	68 5b 35 80 00       	push   $0x80355b
  8027a8:	e8 3f 00 00 00       	call   8027ec <_panic>

008027ad <wait_semaphore>:
}

void wait_semaphore(struct semaphore sem)
{
  8027ad:	55                   	push   %ebp
  8027ae:	89 e5                	mov    %esp,%ebp
  8027b0:	83 ec 08             	sub    $0x8,%esp
	panic("wait_semaphore() is not implemented yet...!!");
  8027b3:	83 ec 04             	sub    $0x4,%esp
  8027b6:	68 98 35 80 00       	push   $0x803598
  8027bb:	6a 10                	push   $0x10
  8027bd:	68 5b 35 80 00       	push   $0x80355b
  8027c2:	e8 25 00 00 00       	call   8027ec <_panic>

008027c7 <signal_semaphore>:
}

void signal_semaphore(struct semaphore sem)
{
  8027c7:	55                   	push   %ebp
  8027c8:	89 e5                	mov    %esp,%ebp
  8027ca:	83 ec 08             	sub    $0x8,%esp
	panic("signal_semaphore() is not implemented yet...!!");
  8027cd:	83 ec 04             	sub    $0x4,%esp
  8027d0:	68 c8 35 80 00       	push   $0x8035c8
  8027d5:	6a 15                	push   $0x15
  8027d7:	68 5b 35 80 00       	push   $0x80355b
  8027dc:	e8 0b 00 00 00       	call   8027ec <_panic>

008027e1 <semaphore_count>:
}

int semaphore_count(struct semaphore sem)
{
  8027e1:	55                   	push   %ebp
  8027e2:	89 e5                	mov    %esp,%ebp
	return sem.semdata->count;
  8027e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8027e7:	8b 40 10             	mov    0x10(%eax),%eax
}
  8027ea:	5d                   	pop    %ebp
  8027eb:	c3                   	ret    

008027ec <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  8027ec:	55                   	push   %ebp
  8027ed:	89 e5                	mov    %esp,%ebp
  8027ef:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  8027f2:	8d 45 10             	lea    0x10(%ebp),%eax
  8027f5:	83 c0 04             	add    $0x4,%eax
  8027f8:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  8027fb:	a1 1c c1 81 00       	mov    0x81c11c,%eax
  802800:	85 c0                	test   %eax,%eax
  802802:	74 16                	je     80281a <_panic+0x2e>
		cprintf("%s: ", argv0);
  802804:	a1 1c c1 81 00       	mov    0x81c11c,%eax
  802809:	83 ec 08             	sub    $0x8,%esp
  80280c:	50                   	push   %eax
  80280d:	68 f8 35 80 00       	push   $0x8035f8
  802812:	e8 75 de ff ff       	call   80068c <cprintf>
  802817:	83 c4 10             	add    $0x10,%esp
	cprintf_colored(TEXT_PANIC_CLR, "user [EVAL_FINAL]panic in %s at %s:%d: ", binaryname, file, line);
  80281a:	a1 04 40 80 00       	mov    0x804004,%eax
  80281f:	83 ec 0c             	sub    $0xc,%esp
  802822:	ff 75 0c             	pushl  0xc(%ebp)
  802825:	ff 75 08             	pushl  0x8(%ebp)
  802828:	50                   	push   %eax
  802829:	68 00 36 80 00       	push   $0x803600
  80282e:	6a 74                	push   $0x74
  802830:	e8 84 de ff ff       	call   8006b9 <cprintf_colored>
  802835:	83 c4 20             	add    $0x20,%esp
	vcprintf(fmt, ap);
  802838:	8b 45 10             	mov    0x10(%ebp),%eax
  80283b:	83 ec 08             	sub    $0x8,%esp
  80283e:	ff 75 f4             	pushl  -0xc(%ebp)
  802841:	50                   	push   %eax
  802842:	e8 d6 dd ff ff       	call   80061d <vcprintf>
  802847:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  80284a:	83 ec 08             	sub    $0x8,%esp
  80284d:	6a 00                	push   $0x0
  80284f:	68 28 36 80 00       	push   $0x803628
  802854:	e8 c4 dd ff ff       	call   80061d <vcprintf>
  802859:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  80285c:	e8 3d dd ff ff       	call   80059e <exit>

	// should not return here
	while (1) ;
  802861:	eb fe                	jmp    802861 <_panic+0x75>

00802863 <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  802863:	55                   	push   %ebp
  802864:	89 e5                	mov    %esp,%ebp
  802866:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  802869:	a1 20 40 80 00       	mov    0x804020,%eax
  80286e:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  802874:	8b 45 0c             	mov    0xc(%ebp),%eax
  802877:	39 c2                	cmp    %eax,%edx
  802879:	74 14                	je     80288f <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  80287b:	83 ec 04             	sub    $0x4,%esp
  80287e:	68 2c 36 80 00       	push   $0x80362c
  802883:	6a 26                	push   $0x26
  802885:	68 78 36 80 00       	push   $0x803678
  80288a:	e8 5d ff ff ff       	call   8027ec <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  80288f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  802896:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80289d:	e9 c5 00 00 00       	jmp    802967 <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  8028a2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028a5:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8028ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8028af:	01 d0                	add    %edx,%eax
  8028b1:	8b 00                	mov    (%eax),%eax
  8028b3:	85 c0                	test   %eax,%eax
  8028b5:	75 08                	jne    8028bf <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  8028b7:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  8028ba:	e9 a5 00 00 00       	jmp    802964 <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  8028bf:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8028c6:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  8028cd:	eb 69                	jmp    802938 <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  8028cf:	a1 20 40 80 00       	mov    0x804020,%eax
  8028d4:	8b 88 38 da 01 00    	mov    0x1da38(%eax),%ecx
  8028da:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8028dd:	89 d0                	mov    %edx,%eax
  8028df:	01 c0                	add    %eax,%eax
  8028e1:	01 d0                	add    %edx,%eax
  8028e3:	c1 e0 03             	shl    $0x3,%eax
  8028e6:	01 c8                	add    %ecx,%eax
  8028e8:	8a 40 04             	mov    0x4(%eax),%al
  8028eb:	84 c0                	test   %al,%al
  8028ed:	75 46                	jne    802935 <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8028ef:	a1 20 40 80 00       	mov    0x804020,%eax
  8028f4:	8b 88 38 da 01 00    	mov    0x1da38(%eax),%ecx
  8028fa:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8028fd:	89 d0                	mov    %edx,%eax
  8028ff:	01 c0                	add    %eax,%eax
  802901:	01 d0                	add    %edx,%eax
  802903:	c1 e0 03             	shl    $0x3,%eax
  802906:	01 c8                	add    %ecx,%eax
  802908:	8b 00                	mov    (%eax),%eax
  80290a:	89 45 dc             	mov    %eax,-0x24(%ebp)
  80290d:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802910:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  802915:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  802917:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80291a:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  802921:	8b 45 08             	mov    0x8(%ebp),%eax
  802924:	01 c8                	add    %ecx,%eax
  802926:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  802928:	39 c2                	cmp    %eax,%edx
  80292a:	75 09                	jne    802935 <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  80292c:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  802933:	eb 15                	jmp    80294a <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  802935:	ff 45 e8             	incl   -0x18(%ebp)
  802938:	a1 20 40 80 00       	mov    0x804020,%eax
  80293d:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  802943:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802946:	39 c2                	cmp    %eax,%edx
  802948:	77 85                	ja     8028cf <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  80294a:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80294e:	75 14                	jne    802964 <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  802950:	83 ec 04             	sub    $0x4,%esp
  802953:	68 84 36 80 00       	push   $0x803684
  802958:	6a 3a                	push   $0x3a
  80295a:	68 78 36 80 00       	push   $0x803678
  80295f:	e8 88 fe ff ff       	call   8027ec <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  802964:	ff 45 f0             	incl   -0x10(%ebp)
  802967:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80296a:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80296d:	0f 8c 2f ff ff ff    	jl     8028a2 <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  802973:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80297a:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  802981:	eb 26                	jmp    8029a9 <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  802983:	a1 20 40 80 00       	mov    0x804020,%eax
  802988:	8b 88 38 da 01 00    	mov    0x1da38(%eax),%ecx
  80298e:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802991:	89 d0                	mov    %edx,%eax
  802993:	01 c0                	add    %eax,%eax
  802995:	01 d0                	add    %edx,%eax
  802997:	c1 e0 03             	shl    $0x3,%eax
  80299a:	01 c8                	add    %ecx,%eax
  80299c:	8a 40 04             	mov    0x4(%eax),%al
  80299f:	3c 01                	cmp    $0x1,%al
  8029a1:	75 03                	jne    8029a6 <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  8029a3:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8029a6:	ff 45 e0             	incl   -0x20(%ebp)
  8029a9:	a1 20 40 80 00       	mov    0x804020,%eax
  8029ae:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  8029b4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8029b7:	39 c2                	cmp    %eax,%edx
  8029b9:	77 c8                	ja     802983 <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  8029bb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029be:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8029c1:	74 14                	je     8029d7 <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  8029c3:	83 ec 04             	sub    $0x4,%esp
  8029c6:	68 d8 36 80 00       	push   $0x8036d8
  8029cb:	6a 44                	push   $0x44
  8029cd:	68 78 36 80 00       	push   $0x803678
  8029d2:	e8 15 fe ff ff       	call   8027ec <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  8029d7:	90                   	nop
  8029d8:	c9                   	leave  
  8029d9:	c3                   	ret    
  8029da:	66 90                	xchg   %ax,%ax

008029dc <__udivdi3>:
  8029dc:	55                   	push   %ebp
  8029dd:	57                   	push   %edi
  8029de:	56                   	push   %esi
  8029df:	53                   	push   %ebx
  8029e0:	83 ec 1c             	sub    $0x1c,%esp
  8029e3:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  8029e7:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  8029eb:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8029ef:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8029f3:	89 ca                	mov    %ecx,%edx
  8029f5:	89 f8                	mov    %edi,%eax
  8029f7:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  8029fb:	85 f6                	test   %esi,%esi
  8029fd:	75 2d                	jne    802a2c <__udivdi3+0x50>
  8029ff:	39 cf                	cmp    %ecx,%edi
  802a01:	77 65                	ja     802a68 <__udivdi3+0x8c>
  802a03:	89 fd                	mov    %edi,%ebp
  802a05:	85 ff                	test   %edi,%edi
  802a07:	75 0b                	jne    802a14 <__udivdi3+0x38>
  802a09:	b8 01 00 00 00       	mov    $0x1,%eax
  802a0e:	31 d2                	xor    %edx,%edx
  802a10:	f7 f7                	div    %edi
  802a12:	89 c5                	mov    %eax,%ebp
  802a14:	31 d2                	xor    %edx,%edx
  802a16:	89 c8                	mov    %ecx,%eax
  802a18:	f7 f5                	div    %ebp
  802a1a:	89 c1                	mov    %eax,%ecx
  802a1c:	89 d8                	mov    %ebx,%eax
  802a1e:	f7 f5                	div    %ebp
  802a20:	89 cf                	mov    %ecx,%edi
  802a22:	89 fa                	mov    %edi,%edx
  802a24:	83 c4 1c             	add    $0x1c,%esp
  802a27:	5b                   	pop    %ebx
  802a28:	5e                   	pop    %esi
  802a29:	5f                   	pop    %edi
  802a2a:	5d                   	pop    %ebp
  802a2b:	c3                   	ret    
  802a2c:	39 ce                	cmp    %ecx,%esi
  802a2e:	77 28                	ja     802a58 <__udivdi3+0x7c>
  802a30:	0f bd fe             	bsr    %esi,%edi
  802a33:	83 f7 1f             	xor    $0x1f,%edi
  802a36:	75 40                	jne    802a78 <__udivdi3+0x9c>
  802a38:	39 ce                	cmp    %ecx,%esi
  802a3a:	72 0a                	jb     802a46 <__udivdi3+0x6a>
  802a3c:	3b 44 24 08          	cmp    0x8(%esp),%eax
  802a40:	0f 87 9e 00 00 00    	ja     802ae4 <__udivdi3+0x108>
  802a46:	b8 01 00 00 00       	mov    $0x1,%eax
  802a4b:	89 fa                	mov    %edi,%edx
  802a4d:	83 c4 1c             	add    $0x1c,%esp
  802a50:	5b                   	pop    %ebx
  802a51:	5e                   	pop    %esi
  802a52:	5f                   	pop    %edi
  802a53:	5d                   	pop    %ebp
  802a54:	c3                   	ret    
  802a55:	8d 76 00             	lea    0x0(%esi),%esi
  802a58:	31 ff                	xor    %edi,%edi
  802a5a:	31 c0                	xor    %eax,%eax
  802a5c:	89 fa                	mov    %edi,%edx
  802a5e:	83 c4 1c             	add    $0x1c,%esp
  802a61:	5b                   	pop    %ebx
  802a62:	5e                   	pop    %esi
  802a63:	5f                   	pop    %edi
  802a64:	5d                   	pop    %ebp
  802a65:	c3                   	ret    
  802a66:	66 90                	xchg   %ax,%ax
  802a68:	89 d8                	mov    %ebx,%eax
  802a6a:	f7 f7                	div    %edi
  802a6c:	31 ff                	xor    %edi,%edi
  802a6e:	89 fa                	mov    %edi,%edx
  802a70:	83 c4 1c             	add    $0x1c,%esp
  802a73:	5b                   	pop    %ebx
  802a74:	5e                   	pop    %esi
  802a75:	5f                   	pop    %edi
  802a76:	5d                   	pop    %ebp
  802a77:	c3                   	ret    
  802a78:	bd 20 00 00 00       	mov    $0x20,%ebp
  802a7d:	89 eb                	mov    %ebp,%ebx
  802a7f:	29 fb                	sub    %edi,%ebx
  802a81:	89 f9                	mov    %edi,%ecx
  802a83:	d3 e6                	shl    %cl,%esi
  802a85:	89 c5                	mov    %eax,%ebp
  802a87:	88 d9                	mov    %bl,%cl
  802a89:	d3 ed                	shr    %cl,%ebp
  802a8b:	89 e9                	mov    %ebp,%ecx
  802a8d:	09 f1                	or     %esi,%ecx
  802a8f:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  802a93:	89 f9                	mov    %edi,%ecx
  802a95:	d3 e0                	shl    %cl,%eax
  802a97:	89 c5                	mov    %eax,%ebp
  802a99:	89 d6                	mov    %edx,%esi
  802a9b:	88 d9                	mov    %bl,%cl
  802a9d:	d3 ee                	shr    %cl,%esi
  802a9f:	89 f9                	mov    %edi,%ecx
  802aa1:	d3 e2                	shl    %cl,%edx
  802aa3:	8b 44 24 08          	mov    0x8(%esp),%eax
  802aa7:	88 d9                	mov    %bl,%cl
  802aa9:	d3 e8                	shr    %cl,%eax
  802aab:	09 c2                	or     %eax,%edx
  802aad:	89 d0                	mov    %edx,%eax
  802aaf:	89 f2                	mov    %esi,%edx
  802ab1:	f7 74 24 0c          	divl   0xc(%esp)
  802ab5:	89 d6                	mov    %edx,%esi
  802ab7:	89 c3                	mov    %eax,%ebx
  802ab9:	f7 e5                	mul    %ebp
  802abb:	39 d6                	cmp    %edx,%esi
  802abd:	72 19                	jb     802ad8 <__udivdi3+0xfc>
  802abf:	74 0b                	je     802acc <__udivdi3+0xf0>
  802ac1:	89 d8                	mov    %ebx,%eax
  802ac3:	31 ff                	xor    %edi,%edi
  802ac5:	e9 58 ff ff ff       	jmp    802a22 <__udivdi3+0x46>
  802aca:	66 90                	xchg   %ax,%ax
  802acc:	8b 54 24 08          	mov    0x8(%esp),%edx
  802ad0:	89 f9                	mov    %edi,%ecx
  802ad2:	d3 e2                	shl    %cl,%edx
  802ad4:	39 c2                	cmp    %eax,%edx
  802ad6:	73 e9                	jae    802ac1 <__udivdi3+0xe5>
  802ad8:	8d 43 ff             	lea    -0x1(%ebx),%eax
  802adb:	31 ff                	xor    %edi,%edi
  802add:	e9 40 ff ff ff       	jmp    802a22 <__udivdi3+0x46>
  802ae2:	66 90                	xchg   %ax,%ax
  802ae4:	31 c0                	xor    %eax,%eax
  802ae6:	e9 37 ff ff ff       	jmp    802a22 <__udivdi3+0x46>
  802aeb:	90                   	nop

00802aec <__umoddi3>:
  802aec:	55                   	push   %ebp
  802aed:	57                   	push   %edi
  802aee:	56                   	push   %esi
  802aef:	53                   	push   %ebx
  802af0:	83 ec 1c             	sub    $0x1c,%esp
  802af3:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  802af7:	8b 74 24 34          	mov    0x34(%esp),%esi
  802afb:	8b 7c 24 38          	mov    0x38(%esp),%edi
  802aff:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  802b03:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802b07:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802b0b:	89 f3                	mov    %esi,%ebx
  802b0d:	89 fa                	mov    %edi,%edx
  802b0f:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  802b13:	89 34 24             	mov    %esi,(%esp)
  802b16:	85 c0                	test   %eax,%eax
  802b18:	75 1a                	jne    802b34 <__umoddi3+0x48>
  802b1a:	39 f7                	cmp    %esi,%edi
  802b1c:	0f 86 a2 00 00 00    	jbe    802bc4 <__umoddi3+0xd8>
  802b22:	89 c8                	mov    %ecx,%eax
  802b24:	89 f2                	mov    %esi,%edx
  802b26:	f7 f7                	div    %edi
  802b28:	89 d0                	mov    %edx,%eax
  802b2a:	31 d2                	xor    %edx,%edx
  802b2c:	83 c4 1c             	add    $0x1c,%esp
  802b2f:	5b                   	pop    %ebx
  802b30:	5e                   	pop    %esi
  802b31:	5f                   	pop    %edi
  802b32:	5d                   	pop    %ebp
  802b33:	c3                   	ret    
  802b34:	39 f0                	cmp    %esi,%eax
  802b36:	0f 87 ac 00 00 00    	ja     802be8 <__umoddi3+0xfc>
  802b3c:	0f bd e8             	bsr    %eax,%ebp
  802b3f:	83 f5 1f             	xor    $0x1f,%ebp
  802b42:	0f 84 ac 00 00 00    	je     802bf4 <__umoddi3+0x108>
  802b48:	bf 20 00 00 00       	mov    $0x20,%edi
  802b4d:	29 ef                	sub    %ebp,%edi
  802b4f:	89 fe                	mov    %edi,%esi
  802b51:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802b55:	89 e9                	mov    %ebp,%ecx
  802b57:	d3 e0                	shl    %cl,%eax
  802b59:	89 d7                	mov    %edx,%edi
  802b5b:	89 f1                	mov    %esi,%ecx
  802b5d:	d3 ef                	shr    %cl,%edi
  802b5f:	09 c7                	or     %eax,%edi
  802b61:	89 e9                	mov    %ebp,%ecx
  802b63:	d3 e2                	shl    %cl,%edx
  802b65:	89 14 24             	mov    %edx,(%esp)
  802b68:	89 d8                	mov    %ebx,%eax
  802b6a:	d3 e0                	shl    %cl,%eax
  802b6c:	89 c2                	mov    %eax,%edx
  802b6e:	8b 44 24 08          	mov    0x8(%esp),%eax
  802b72:	d3 e0                	shl    %cl,%eax
  802b74:	89 44 24 04          	mov    %eax,0x4(%esp)
  802b78:	8b 44 24 08          	mov    0x8(%esp),%eax
  802b7c:	89 f1                	mov    %esi,%ecx
  802b7e:	d3 e8                	shr    %cl,%eax
  802b80:	09 d0                	or     %edx,%eax
  802b82:	d3 eb                	shr    %cl,%ebx
  802b84:	89 da                	mov    %ebx,%edx
  802b86:	f7 f7                	div    %edi
  802b88:	89 d3                	mov    %edx,%ebx
  802b8a:	f7 24 24             	mull   (%esp)
  802b8d:	89 c6                	mov    %eax,%esi
  802b8f:	89 d1                	mov    %edx,%ecx
  802b91:	39 d3                	cmp    %edx,%ebx
  802b93:	0f 82 87 00 00 00    	jb     802c20 <__umoddi3+0x134>
  802b99:	0f 84 91 00 00 00    	je     802c30 <__umoddi3+0x144>
  802b9f:	8b 54 24 04          	mov    0x4(%esp),%edx
  802ba3:	29 f2                	sub    %esi,%edx
  802ba5:	19 cb                	sbb    %ecx,%ebx
  802ba7:	89 d8                	mov    %ebx,%eax
  802ba9:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  802bad:	d3 e0                	shl    %cl,%eax
  802baf:	89 e9                	mov    %ebp,%ecx
  802bb1:	d3 ea                	shr    %cl,%edx
  802bb3:	09 d0                	or     %edx,%eax
  802bb5:	89 e9                	mov    %ebp,%ecx
  802bb7:	d3 eb                	shr    %cl,%ebx
  802bb9:	89 da                	mov    %ebx,%edx
  802bbb:	83 c4 1c             	add    $0x1c,%esp
  802bbe:	5b                   	pop    %ebx
  802bbf:	5e                   	pop    %esi
  802bc0:	5f                   	pop    %edi
  802bc1:	5d                   	pop    %ebp
  802bc2:	c3                   	ret    
  802bc3:	90                   	nop
  802bc4:	89 fd                	mov    %edi,%ebp
  802bc6:	85 ff                	test   %edi,%edi
  802bc8:	75 0b                	jne    802bd5 <__umoddi3+0xe9>
  802bca:	b8 01 00 00 00       	mov    $0x1,%eax
  802bcf:	31 d2                	xor    %edx,%edx
  802bd1:	f7 f7                	div    %edi
  802bd3:	89 c5                	mov    %eax,%ebp
  802bd5:	89 f0                	mov    %esi,%eax
  802bd7:	31 d2                	xor    %edx,%edx
  802bd9:	f7 f5                	div    %ebp
  802bdb:	89 c8                	mov    %ecx,%eax
  802bdd:	f7 f5                	div    %ebp
  802bdf:	89 d0                	mov    %edx,%eax
  802be1:	e9 44 ff ff ff       	jmp    802b2a <__umoddi3+0x3e>
  802be6:	66 90                	xchg   %ax,%ax
  802be8:	89 c8                	mov    %ecx,%eax
  802bea:	89 f2                	mov    %esi,%edx
  802bec:	83 c4 1c             	add    $0x1c,%esp
  802bef:	5b                   	pop    %ebx
  802bf0:	5e                   	pop    %esi
  802bf1:	5f                   	pop    %edi
  802bf2:	5d                   	pop    %ebp
  802bf3:	c3                   	ret    
  802bf4:	3b 04 24             	cmp    (%esp),%eax
  802bf7:	72 06                	jb     802bff <__umoddi3+0x113>
  802bf9:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  802bfd:	77 0f                	ja     802c0e <__umoddi3+0x122>
  802bff:	89 f2                	mov    %esi,%edx
  802c01:	29 f9                	sub    %edi,%ecx
  802c03:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  802c07:	89 14 24             	mov    %edx,(%esp)
  802c0a:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  802c0e:	8b 44 24 04          	mov    0x4(%esp),%eax
  802c12:	8b 14 24             	mov    (%esp),%edx
  802c15:	83 c4 1c             	add    $0x1c,%esp
  802c18:	5b                   	pop    %ebx
  802c19:	5e                   	pop    %esi
  802c1a:	5f                   	pop    %edi
  802c1b:	5d                   	pop    %ebp
  802c1c:	c3                   	ret    
  802c1d:	8d 76 00             	lea    0x0(%esi),%esi
  802c20:	2b 04 24             	sub    (%esp),%eax
  802c23:	19 fa                	sbb    %edi,%edx
  802c25:	89 d1                	mov    %edx,%ecx
  802c27:	89 c6                	mov    %eax,%esi
  802c29:	e9 71 ff ff ff       	jmp    802b9f <__umoddi3+0xb3>
  802c2e:	66 90                	xchg   %ax,%ax
  802c30:	39 44 24 04          	cmp    %eax,0x4(%esp)
  802c34:	72 ea                	jb     802c20 <__umoddi3+0x134>
  802c36:	89 d9                	mov    %ebx,%ecx
  802c38:	e9 62 ff ff ff       	jmp    802b9f <__umoddi3+0xb3>
