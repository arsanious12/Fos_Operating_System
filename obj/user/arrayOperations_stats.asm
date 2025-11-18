
obj/user/arrayOperations_stats:     file format elf32-i386


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
  800031:	e8 31 06 00 00       	call   800667 <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
void ArrayStats(int *Elements, int NumOfElements, int64 *mean, int64 *var, int *min, int *max, int *med);
int KthElement(int *Elements, int NumOfElements, int k);
int QSort(int *Elements,int NumOfElements, int startIndex, int finalIndex, int kIndex);

void _main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	83 ec 68             	sub    $0x68,%esp
	int32 envID = sys_getenvid();
  80003e:	e8 34 1c 00 00       	call   801c77 <sys_getenvid>
  800043:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int32 parentenvID = sys_getparentenvid();
  800046:	e8 5e 1c 00 00       	call   801ca9 <sys_getparentenvid>
  80004b:	89 45 ec             	mov    %eax,-0x14(%ebp)

	int ret;
	/*[1] GET SEMAPHORES*/
	struct semaphore ready = get_semaphore(parentenvID, "Ready");
  80004e:	8d 45 c4             	lea    -0x3c(%ebp),%eax
  800051:	83 ec 04             	sub    $0x4,%esp
  800054:	68 40 30 80 00       	push   $0x803040
  800059:	ff 75 ec             	pushl  -0x14(%ebp)
  80005c:	50                   	push   %eax
  80005d:	e8 b1 29 00 00       	call   802a13 <get_semaphore>
  800062:	83 c4 0c             	add    $0xc,%esp
	struct semaphore finished = get_semaphore(parentenvID, "Finished");
  800065:	8d 45 c0             	lea    -0x40(%ebp),%eax
  800068:	83 ec 04             	sub    $0x4,%esp
  80006b:	68 46 30 80 00       	push   $0x803046
  800070:	ff 75 ec             	pushl  -0x14(%ebp)
  800073:	50                   	push   %eax
  800074:	e8 9a 29 00 00       	call   802a13 <get_semaphore>
  800079:	83 c4 0c             	add    $0xc,%esp

	/*[2] WAIT A READY SIGNAL FROM THE MASTER*/
	wait_semaphore(ready);
  80007c:	83 ec 0c             	sub    $0xc,%esp
  80007f:	ff 75 c4             	pushl  -0x3c(%ebp)
  800082:	e8 a6 29 00 00       	call   802a2d <wait_semaphore>
  800087:	83 c4 10             	add    $0x10,%esp

	/*[3] GET SHARED VARs*/
	//Get the cons_mutex ownerID
	int* consMutexOwnerID = sget(parentenvID, "cons_mutex ownerID") ;
  80008a:	83 ec 08             	sub    $0x8,%esp
  80008d:	68 4f 30 80 00       	push   $0x80304f
  800092:	ff 75 ec             	pushl  -0x14(%ebp)
  800095:	e8 b0 18 00 00       	call   80194a <sget>
  80009a:	83 c4 10             	add    $0x10,%esp
  80009d:	89 45 e8             	mov    %eax,-0x18(%ebp)
	struct semaphore cons_mutex = get_semaphore(*consMutexOwnerID, "Console Mutex");
  8000a0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8000a3:	8b 10                	mov    (%eax),%edx
  8000a5:	8d 45 bc             	lea    -0x44(%ebp),%eax
  8000a8:	83 ec 04             	sub    $0x4,%esp
  8000ab:	68 62 30 80 00       	push   $0x803062
  8000b0:	52                   	push   %edx
  8000b1:	50                   	push   %eax
  8000b2:	e8 5c 29 00 00       	call   802a13 <get_semaphore>
  8000b7:	83 c4 0c             	add    $0xc,%esp

	//Get the shared array & its size
	int *numOfElements = NULL;
  8000ba:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	int *sharedArray = NULL;
  8000c1:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
	sharedArray = sget(parentenvID,"arr") ;
  8000c8:	83 ec 08             	sub    $0x8,%esp
  8000cb:	68 70 30 80 00       	push   $0x803070
  8000d0:	ff 75 ec             	pushl  -0x14(%ebp)
  8000d3:	e8 72 18 00 00       	call   80194a <sget>
  8000d8:	83 c4 10             	add    $0x10,%esp
  8000db:	89 45 e0             	mov    %eax,-0x20(%ebp)
	numOfElements = sget(parentenvID,"arrSize") ;
  8000de:	83 ec 08             	sub    $0x8,%esp
  8000e1:	68 74 30 80 00       	push   $0x803074
  8000e6:	ff 75 ec             	pushl  -0x14(%ebp)
  8000e9:	e8 5c 18 00 00       	call   80194a <sget>
  8000ee:	83 c4 10             	add    $0x10,%esp
  8000f1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	int max ;
	int med ;

	//take a copy from the original array
	int *tmpArray;
	tmpArray = smalloc("tmpArr", sizeof(int) * *numOfElements, 0) ;
  8000f4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8000f7:	8b 00                	mov    (%eax),%eax
  8000f9:	c1 e0 02             	shl    $0x2,%eax
  8000fc:	83 ec 04             	sub    $0x4,%esp
  8000ff:	6a 00                	push   $0x0
  800101:	50                   	push   %eax
  800102:	68 7c 30 80 00       	push   $0x80307c
  800107:	e8 0a 18 00 00       	call   801916 <smalloc>
  80010c:	83 c4 10             	add    $0x10,%esp
  80010f:	89 45 dc             	mov    %eax,-0x24(%ebp)
	int i ;
	for (i = 0 ; i < *numOfElements ; i++)
  800112:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  800119:	eb 25                	jmp    800140 <_main+0x108>
	{
		tmpArray[i] = sharedArray[i];
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

	//take a copy from the original array
	int *tmpArray;
	tmpArray = smalloc("tmpArr", sizeof(int) * *numOfElements, 0) ;
	int i ;
	for (i = 0 ; i < *numOfElements ; i++)
  80013d:	ff 45 f4             	incl   -0xc(%ebp)
  800140:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800143:	8b 00                	mov    (%eax),%eax
  800145:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  800148:	7f d1                	jg     80011b <_main+0xe3>
	{
		tmpArray[i] = sharedArray[i];
	}

	ArrayStats(tmpArray ,*numOfElements, &mean, &var, &min, &max, &med);
  80014a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80014d:	8b 00                	mov    (%eax),%eax
  80014f:	83 ec 04             	sub    $0x4,%esp
  800152:	8d 55 9c             	lea    -0x64(%ebp),%edx
  800155:	52                   	push   %edx
  800156:	8d 55 a0             	lea    -0x60(%ebp),%edx
  800159:	52                   	push   %edx
  80015a:	8d 55 a4             	lea    -0x5c(%ebp),%edx
  80015d:	52                   	push   %edx
  80015e:	8d 55 a8             	lea    -0x58(%ebp),%edx
  800161:	52                   	push   %edx
  800162:	8d 55 b0             	lea    -0x50(%ebp),%edx
  800165:	52                   	push   %edx
  800166:	50                   	push   %eax
  800167:	ff 75 dc             	pushl  -0x24(%ebp)
  80016a:	e8 bf 02 00 00       	call   80042e <ArrayStats>
  80016f:	83 c4 20             	add    $0x20,%esp

	wait_semaphore(cons_mutex);
  800172:	83 ec 0c             	sub    $0xc,%esp
  800175:	ff 75 bc             	pushl  -0x44(%ebp)
  800178:	e8 b0 28 00 00       	call   802a2d <wait_semaphore>
  80017d:	83 c4 10             	add    $0x10,%esp
	{
		cprintf("Stats Calculations are Finished!!!!\n") ;
  800180:	83 ec 0c             	sub    $0xc,%esp
  800183:	68 84 30 80 00       	push   $0x803084
  800188:	e8 7f 07 00 00       	call   80090c <cprintf>
  80018d:	83 c4 10             	add    $0x10,%esp
		cprintf("will share the rsults & notify the master now...\n");
  800190:	83 ec 0c             	sub    $0xc,%esp
  800193:	68 ac 30 80 00       	push   $0x8030ac
  800198:	e8 6f 07 00 00       	call   80090c <cprintf>
  80019d:	83 c4 10             	add    $0x10,%esp
	}
	signal_semaphore(cons_mutex);
  8001a0:	83 ec 0c             	sub    $0xc,%esp
  8001a3:	ff 75 bc             	pushl  -0x44(%ebp)
  8001a6:	e8 9c 28 00 00       	call   802a47 <signal_semaphore>
  8001ab:	83 c4 10             	add    $0x10,%esp

	/*[3] SHARE THE RESULTS & DECLARE FINISHING*/
	int64 *shMean, *shVar;
	int *shMin, *shMax, *shMed;
	shMean = smalloc("mean", sizeof(int64), 0) ; *shMean = mean;
  8001ae:	83 ec 04             	sub    $0x4,%esp
  8001b1:	6a 00                	push   $0x0
  8001b3:	6a 08                	push   $0x8
  8001b5:	68 de 30 80 00       	push   $0x8030de
  8001ba:	e8 57 17 00 00       	call   801916 <smalloc>
  8001bf:	83 c4 10             	add    $0x10,%esp
  8001c2:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8001c5:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8001c8:	8b 55 b4             	mov    -0x4c(%ebp),%edx
  8001cb:	8b 4d d8             	mov    -0x28(%ebp),%ecx
  8001ce:	89 01                	mov    %eax,(%ecx)
  8001d0:	89 51 04             	mov    %edx,0x4(%ecx)
	shVar = smalloc("var", sizeof(int64), 0) ; *shVar = var;
  8001d3:	83 ec 04             	sub    $0x4,%esp
  8001d6:	6a 00                	push   $0x0
  8001d8:	6a 08                	push   $0x8
  8001da:	68 e3 30 80 00       	push   $0x8030e3
  8001df:	e8 32 17 00 00       	call   801916 <smalloc>
  8001e4:	83 c4 10             	add    $0x10,%esp
  8001e7:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  8001ea:	8b 45 a8             	mov    -0x58(%ebp),%eax
  8001ed:	8b 55 ac             	mov    -0x54(%ebp),%edx
  8001f0:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  8001f3:	89 01                	mov    %eax,(%ecx)
  8001f5:	89 51 04             	mov    %edx,0x4(%ecx)
	shMin = smalloc("min", sizeof(int), 0) ; *shMin = min;
  8001f8:	83 ec 04             	sub    $0x4,%esp
  8001fb:	6a 00                	push   $0x0
  8001fd:	6a 04                	push   $0x4
  8001ff:	68 e7 30 80 00       	push   $0x8030e7
  800204:	e8 0d 17 00 00       	call   801916 <smalloc>
  800209:	83 c4 10             	add    $0x10,%esp
  80020c:	89 45 d0             	mov    %eax,-0x30(%ebp)
  80020f:	8b 55 a4             	mov    -0x5c(%ebp),%edx
  800212:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800215:	89 10                	mov    %edx,(%eax)
	shMax = smalloc("max", sizeof(int), 0) ; *shMax = max;
  800217:	83 ec 04             	sub    $0x4,%esp
  80021a:	6a 00                	push   $0x0
  80021c:	6a 04                	push   $0x4
  80021e:	68 eb 30 80 00       	push   $0x8030eb
  800223:	e8 ee 16 00 00       	call   801916 <smalloc>
  800228:	83 c4 10             	add    $0x10,%esp
  80022b:	89 45 cc             	mov    %eax,-0x34(%ebp)
  80022e:	8b 55 a0             	mov    -0x60(%ebp),%edx
  800231:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800234:	89 10                	mov    %edx,(%eax)
	shMed = smalloc("med", sizeof(int), 0) ; *shMed = med;
  800236:	83 ec 04             	sub    $0x4,%esp
  800239:	6a 00                	push   $0x0
  80023b:	6a 04                	push   $0x4
  80023d:	68 ef 30 80 00       	push   $0x8030ef
  800242:	e8 cf 16 00 00       	call   801916 <smalloc>
  800247:	83 c4 10             	add    $0x10,%esp
  80024a:	89 45 c8             	mov    %eax,-0x38(%ebp)
  80024d:	8b 55 9c             	mov    -0x64(%ebp),%edx
  800250:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800253:	89 10                	mov    %edx,(%eax)

	wait_semaphore(cons_mutex);
  800255:	83 ec 0c             	sub    $0xc,%esp
  800258:	ff 75 bc             	pushl  -0x44(%ebp)
  80025b:	e8 cd 27 00 00       	call   802a2d <wait_semaphore>
  800260:	83 c4 10             	add    $0x10,%esp
	{
		cprintf("Stats app says GOOD BYE :)\n") ;
  800263:	83 ec 0c             	sub    $0xc,%esp
  800266:	68 f3 30 80 00       	push   $0x8030f3
  80026b:	e8 9c 06 00 00       	call   80090c <cprintf>
  800270:	83 c4 10             	add    $0x10,%esp
	}
	signal_semaphore(cons_mutex);
  800273:	83 ec 0c             	sub    $0xc,%esp
  800276:	ff 75 bc             	pushl  -0x44(%ebp)
  800279:	e8 c9 27 00 00       	call   802a47 <signal_semaphore>
  80027e:	83 c4 10             	add    $0x10,%esp

	signal_semaphore(finished);
  800281:	83 ec 0c             	sub    $0xc,%esp
  800284:	ff 75 c0             	pushl  -0x40(%ebp)
  800287:	e8 bb 27 00 00       	call   802a47 <signal_semaphore>
  80028c:	83 c4 10             	add    $0x10,%esp

}
  80028f:	90                   	nop
  800290:	c9                   	leave  
  800291:	c3                   	ret    

00800292 <KthElement>:



///Kth Element
int KthElement(int *Elements, int NumOfElements, int k)
{
  800292:	55                   	push   %ebp
  800293:	89 e5                	mov    %esp,%ebp
  800295:	83 ec 08             	sub    $0x8,%esp
	return QSort(Elements, NumOfElements, 0, NumOfElements-1, k-1) ;
  800298:	8b 45 10             	mov    0x10(%ebp),%eax
  80029b:	8d 50 ff             	lea    -0x1(%eax),%edx
  80029e:	8b 45 0c             	mov    0xc(%ebp),%eax
  8002a1:	48                   	dec    %eax
  8002a2:	83 ec 0c             	sub    $0xc,%esp
  8002a5:	52                   	push   %edx
  8002a6:	50                   	push   %eax
  8002a7:	6a 00                	push   $0x0
  8002a9:	ff 75 0c             	pushl  0xc(%ebp)
  8002ac:	ff 75 08             	pushl  0x8(%ebp)
  8002af:	e8 05 00 00 00       	call   8002b9 <QSort>
  8002b4:	83 c4 20             	add    $0x20,%esp
}
  8002b7:	c9                   	leave  
  8002b8:	c3                   	ret    

008002b9 <QSort>:


int QSort(int *Elements,int NumOfElements, int startIndex, int finalIndex, int kIndex)
{
  8002b9:	55                   	push   %ebp
  8002ba:	89 e5                	mov    %esp,%ebp
  8002bc:	83 ec 28             	sub    $0x28,%esp
	if (startIndex >= finalIndex) return Elements[finalIndex];
  8002bf:	8b 45 10             	mov    0x10(%ebp),%eax
  8002c2:	3b 45 14             	cmp    0x14(%ebp),%eax
  8002c5:	7c 16                	jl     8002dd <QSort+0x24>
  8002c7:	8b 45 14             	mov    0x14(%ebp),%eax
  8002ca:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8002d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8002d4:	01 d0                	add    %edx,%eax
  8002d6:	8b 00                	mov    (%eax),%eax
  8002d8:	e9 4f 01 00 00       	jmp    80042c <QSort+0x173>

static inline __attribute__((always_inline)) struct uint64 get_virtual_time_user()
{
	struct uint64 result;

	__asm __volatile("rdtsc\n"
  8002dd:	0f 31                	rdtsc  
  8002df:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8002e2:	89 55 e0             	mov    %edx,-0x20(%ebp)
	: "=a" (result.low), "=d" (result.hi)
	);

	return result;
  8002e5:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8002e8:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8002eb:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8002ee:	89 55 e8             	mov    %edx,-0x18(%ebp)

	int pvtIndex = RANDU(startIndex, finalIndex) ;
  8002f1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8002f4:	8b 55 14             	mov    0x14(%ebp),%edx
  8002f7:	2b 55 10             	sub    0x10(%ebp),%edx
  8002fa:	89 d1                	mov    %edx,%ecx
  8002fc:	ba 00 00 00 00       	mov    $0x0,%edx
  800301:	f7 f1                	div    %ecx
  800303:	8b 45 10             	mov    0x10(%ebp),%eax
  800306:	01 d0                	add    %edx,%eax
  800308:	89 45 ec             	mov    %eax,-0x14(%ebp)
	Swap(Elements, startIndex, pvtIndex);
  80030b:	83 ec 04             	sub    $0x4,%esp
  80030e:	ff 75 ec             	pushl  -0x14(%ebp)
  800311:	ff 75 10             	pushl  0x10(%ebp)
  800314:	ff 75 08             	pushl  0x8(%ebp)
  800317:	e8 f8 02 00 00       	call   800614 <Swap>
  80031c:	83 c4 10             	add    $0x10,%esp

	int i = startIndex+1, j = finalIndex;
  80031f:	8b 45 10             	mov    0x10(%ebp),%eax
  800322:	40                   	inc    %eax
  800323:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800326:	8b 45 14             	mov    0x14(%ebp),%eax
  800329:	89 45 f0             	mov    %eax,-0x10(%ebp)

	while (i <= j)
  80032c:	e9 80 00 00 00       	jmp    8003b1 <QSort+0xf8>
	{
		while (i <= finalIndex && Elements[startIndex] >= Elements[i]) i++;
  800331:	ff 45 f4             	incl   -0xc(%ebp)
  800334:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800337:	3b 45 14             	cmp    0x14(%ebp),%eax
  80033a:	7f 2b                	jg     800367 <QSort+0xae>
  80033c:	8b 45 10             	mov    0x10(%ebp),%eax
  80033f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800346:	8b 45 08             	mov    0x8(%ebp),%eax
  800349:	01 d0                	add    %edx,%eax
  80034b:	8b 10                	mov    (%eax),%edx
  80034d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800350:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800357:	8b 45 08             	mov    0x8(%ebp),%eax
  80035a:	01 c8                	add    %ecx,%eax
  80035c:	8b 00                	mov    (%eax),%eax
  80035e:	39 c2                	cmp    %eax,%edx
  800360:	7d cf                	jge    800331 <QSort+0x78>
		while (j > startIndex && Elements[startIndex] < Elements[j]) j--;
  800362:	eb 03                	jmp    800367 <QSort+0xae>
  800364:	ff 4d f0             	decl   -0x10(%ebp)
  800367:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80036a:	3b 45 10             	cmp    0x10(%ebp),%eax
  80036d:	7e 26                	jle    800395 <QSort+0xdc>
  80036f:	8b 45 10             	mov    0x10(%ebp),%eax
  800372:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800379:	8b 45 08             	mov    0x8(%ebp),%eax
  80037c:	01 d0                	add    %edx,%eax
  80037e:	8b 10                	mov    (%eax),%edx
  800380:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800383:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  80038a:	8b 45 08             	mov    0x8(%ebp),%eax
  80038d:	01 c8                	add    %ecx,%eax
  80038f:	8b 00                	mov    (%eax),%eax
  800391:	39 c2                	cmp    %eax,%edx
  800393:	7c cf                	jl     800364 <QSort+0xab>

		if (i <= j)
  800395:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800398:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80039b:	7f 14                	jg     8003b1 <QSort+0xf8>
		{
			Swap(Elements, i, j);
  80039d:	83 ec 04             	sub    $0x4,%esp
  8003a0:	ff 75 f0             	pushl  -0x10(%ebp)
  8003a3:	ff 75 f4             	pushl  -0xc(%ebp)
  8003a6:	ff 75 08             	pushl  0x8(%ebp)
  8003a9:	e8 66 02 00 00       	call   800614 <Swap>
  8003ae:	83 c4 10             	add    $0x10,%esp
	int pvtIndex = RANDU(startIndex, finalIndex) ;
	Swap(Elements, startIndex, pvtIndex);

	int i = startIndex+1, j = finalIndex;

	while (i <= j)
  8003b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8003b4:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8003b7:	0f 8e 77 ff ff ff    	jle    800334 <QSort+0x7b>
		{
			Swap(Elements, i, j);
		}
	}

	Swap( Elements, startIndex, j);
  8003bd:	83 ec 04             	sub    $0x4,%esp
  8003c0:	ff 75 f0             	pushl  -0x10(%ebp)
  8003c3:	ff 75 10             	pushl  0x10(%ebp)
  8003c6:	ff 75 08             	pushl  0x8(%ebp)
  8003c9:	e8 46 02 00 00       	call   800614 <Swap>
  8003ce:	83 c4 10             	add    $0x10,%esp

	if (kIndex == j)
  8003d1:	8b 45 18             	mov    0x18(%ebp),%eax
  8003d4:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8003d7:	75 13                	jne    8003ec <QSort+0x133>
		return Elements[kIndex] ;
  8003d9:	8b 45 18             	mov    0x18(%ebp),%eax
  8003dc:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8003e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8003e6:	01 d0                	add    %edx,%eax
  8003e8:	8b 00                	mov    (%eax),%eax
  8003ea:	eb 40                	jmp    80042c <QSort+0x173>
	else if (kIndex < j)
  8003ec:	8b 45 18             	mov    0x18(%ebp),%eax
  8003ef:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8003f2:	7d 1e                	jge    800412 <QSort+0x159>
		return QSort(Elements, NumOfElements, startIndex, j - 1, kIndex);
  8003f4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8003f7:	48                   	dec    %eax
  8003f8:	83 ec 0c             	sub    $0xc,%esp
  8003fb:	ff 75 18             	pushl  0x18(%ebp)
  8003fe:	50                   	push   %eax
  8003ff:	ff 75 10             	pushl  0x10(%ebp)
  800402:	ff 75 0c             	pushl  0xc(%ebp)
  800405:	ff 75 08             	pushl  0x8(%ebp)
  800408:	e8 ac fe ff ff       	call   8002b9 <QSort>
  80040d:	83 c4 20             	add    $0x20,%esp
  800410:	eb 1a                	jmp    80042c <QSort+0x173>
	else
		return QSort(Elements, NumOfElements, i, finalIndex, kIndex);
  800412:	83 ec 0c             	sub    $0xc,%esp
  800415:	ff 75 18             	pushl  0x18(%ebp)
  800418:	ff 75 14             	pushl  0x14(%ebp)
  80041b:	ff 75 f4             	pushl  -0xc(%ebp)
  80041e:	ff 75 0c             	pushl  0xc(%ebp)
  800421:	ff 75 08             	pushl  0x8(%ebp)
  800424:	e8 90 fe ff ff       	call   8002b9 <QSort>
  800429:	83 c4 20             	add    $0x20,%esp
}
  80042c:	c9                   	leave  
  80042d:	c3                   	ret    

0080042e <ArrayStats>:

void ArrayStats(int *Elements, int NumOfElements, int64 *mean, int64 *var, int *min, int *max, int *med)
{
  80042e:	55                   	push   %ebp
  80042f:	89 e5                	mov    %esp,%ebp
  800431:	57                   	push   %edi
  800432:	56                   	push   %esi
  800433:	53                   	push   %ebx
  800434:	83 ec 2c             	sub    $0x2c,%esp
	int i ;
	*mean =0 ;
  800437:	8b 45 10             	mov    0x10(%ebp),%eax
  80043a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  800440:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
	*min = 0x7FFFFFFF ;
  800447:	8b 45 18             	mov    0x18(%ebp),%eax
  80044a:	c7 00 ff ff ff 7f    	movl   $0x7fffffff,(%eax)
	*max = 0x80000000 ;
  800450:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800453:	c7 00 00 00 00 80    	movl   $0x80000000,(%eax)
	for (i = 0 ; i < NumOfElements ; i++)
  800459:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  800460:	e9 89 00 00 00       	jmp    8004ee <ArrayStats+0xc0>
	{
		(*mean) += Elements[i];
  800465:	8b 45 10             	mov    0x10(%ebp),%eax
  800468:	8b 08                	mov    (%eax),%ecx
  80046a:	8b 58 04             	mov    0x4(%eax),%ebx
  80046d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800470:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800477:	8b 45 08             	mov    0x8(%ebp),%eax
  80047a:	01 d0                	add    %edx,%eax
  80047c:	8b 00                	mov    (%eax),%eax
  80047e:	99                   	cltd   
  80047f:	01 c8                	add    %ecx,%eax
  800481:	11 da                	adc    %ebx,%edx
  800483:	8b 4d 10             	mov    0x10(%ebp),%ecx
  800486:	89 01                	mov    %eax,(%ecx)
  800488:	89 51 04             	mov    %edx,0x4(%ecx)
		if (Elements[i] < (*min))
  80048b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80048e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800495:	8b 45 08             	mov    0x8(%ebp),%eax
  800498:	01 d0                	add    %edx,%eax
  80049a:	8b 10                	mov    (%eax),%edx
  80049c:	8b 45 18             	mov    0x18(%ebp),%eax
  80049f:	8b 00                	mov    (%eax),%eax
  8004a1:	39 c2                	cmp    %eax,%edx
  8004a3:	7d 16                	jge    8004bb <ArrayStats+0x8d>
		{
			(*min) = Elements[i];
  8004a5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8004a8:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8004af:	8b 45 08             	mov    0x8(%ebp),%eax
  8004b2:	01 d0                	add    %edx,%eax
  8004b4:	8b 10                	mov    (%eax),%edx
  8004b6:	8b 45 18             	mov    0x18(%ebp),%eax
  8004b9:	89 10                	mov    %edx,(%eax)
		}
		if (Elements[i] > (*max))
  8004bb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8004be:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8004c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8004c8:	01 d0                	add    %edx,%eax
  8004ca:	8b 10                	mov    (%eax),%edx
  8004cc:	8b 45 1c             	mov    0x1c(%ebp),%eax
  8004cf:	8b 00                	mov    (%eax),%eax
  8004d1:	39 c2                	cmp    %eax,%edx
  8004d3:	7e 16                	jle    8004eb <ArrayStats+0xbd>
		{
			(*max) = Elements[i];
  8004d5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8004d8:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8004df:	8b 45 08             	mov    0x8(%ebp),%eax
  8004e2:	01 d0                	add    %edx,%eax
  8004e4:	8b 10                	mov    (%eax),%edx
  8004e6:	8b 45 1c             	mov    0x1c(%ebp),%eax
  8004e9:	89 10                	mov    %edx,(%eax)
{
	int i ;
	*mean =0 ;
	*min = 0x7FFFFFFF ;
	*max = 0x80000000 ;
	for (i = 0 ; i < NumOfElements ; i++)
  8004eb:	ff 45 e4             	incl   -0x1c(%ebp)
  8004ee:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8004f1:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8004f4:	0f 8c 6b ff ff ff    	jl     800465 <ArrayStats+0x37>
		{
			(*max) = Elements[i];
		}
	}

	(*med) = KthElement(Elements, NumOfElements, (NumOfElements+1)/2);
  8004fa:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004fd:	40                   	inc    %eax
  8004fe:	89 c2                	mov    %eax,%edx
  800500:	c1 ea 1f             	shr    $0x1f,%edx
  800503:	01 d0                	add    %edx,%eax
  800505:	d1 f8                	sar    %eax
  800507:	83 ec 04             	sub    $0x4,%esp
  80050a:	50                   	push   %eax
  80050b:	ff 75 0c             	pushl  0xc(%ebp)
  80050e:	ff 75 08             	pushl  0x8(%ebp)
  800511:	e8 7c fd ff ff       	call   800292 <KthElement>
  800516:	83 c4 10             	add    $0x10,%esp
  800519:	89 c2                	mov    %eax,%edx
  80051b:	8b 45 20             	mov    0x20(%ebp),%eax
  80051e:	89 10                	mov    %edx,(%eax)

	(*mean) /= NumOfElements;
  800520:	8b 45 10             	mov    0x10(%ebp),%eax
  800523:	8b 50 04             	mov    0x4(%eax),%edx
  800526:	8b 00                	mov    (%eax),%eax
  800528:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80052b:	89 cb                	mov    %ecx,%ebx
  80052d:	c1 fb 1f             	sar    $0x1f,%ebx
  800530:	53                   	push   %ebx
  800531:	51                   	push   %ecx
  800532:	52                   	push   %edx
  800533:	50                   	push   %eax
  800534:	e8 23 27 00 00       	call   802c5c <__divdi3>
  800539:	83 c4 10             	add    $0x10,%esp
  80053c:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80053f:	89 01                	mov    %eax,(%ecx)
  800541:	89 51 04             	mov    %edx,0x4(%ecx)
	(*var) = 0;
  800544:	8b 45 14             	mov    0x14(%ebp),%eax
  800547:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80054d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
	for (i = 0 ; i < NumOfElements ; i++)
  800554:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  80055b:	eb 7e                	jmp    8005db <ArrayStats+0x1ad>
	{
		(*var) += (int64)((Elements[i] - (*mean))*(Elements[i] - (*mean)));
  80055d:	8b 45 14             	mov    0x14(%ebp),%eax
  800560:	8b 50 04             	mov    0x4(%eax),%edx
  800563:	8b 00                	mov    (%eax),%eax
  800565:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800568:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  80056b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80056e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800575:	8b 45 08             	mov    0x8(%ebp),%eax
  800578:	01 d0                	add    %edx,%eax
  80057a:	8b 00                	mov    (%eax),%eax
  80057c:	89 c1                	mov    %eax,%ecx
  80057e:	89 c3                	mov    %eax,%ebx
  800580:	c1 fb 1f             	sar    $0x1f,%ebx
  800583:	8b 45 10             	mov    0x10(%ebp),%eax
  800586:	8b 50 04             	mov    0x4(%eax),%edx
  800589:	8b 00                	mov    (%eax),%eax
  80058b:	29 c1                	sub    %eax,%ecx
  80058d:	19 d3                	sbb    %edx,%ebx
  80058f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800592:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800599:	8b 45 08             	mov    0x8(%ebp),%eax
  80059c:	01 d0                	add    %edx,%eax
  80059e:	8b 00                	mov    (%eax),%eax
  8005a0:	89 c6                	mov    %eax,%esi
  8005a2:	89 c7                	mov    %eax,%edi
  8005a4:	c1 ff 1f             	sar    $0x1f,%edi
  8005a7:	8b 45 10             	mov    0x10(%ebp),%eax
  8005aa:	8b 50 04             	mov    0x4(%eax),%edx
  8005ad:	8b 00                	mov    (%eax),%eax
  8005af:	29 c6                	sub    %eax,%esi
  8005b1:	19 d7                	sbb    %edx,%edi
  8005b3:	89 f0                	mov    %esi,%eax
  8005b5:	89 fa                	mov    %edi,%edx
  8005b7:	89 df                	mov    %ebx,%edi
  8005b9:	0f af f8             	imul   %eax,%edi
  8005bc:	89 d6                	mov    %edx,%esi
  8005be:	0f af f1             	imul   %ecx,%esi
  8005c1:	01 fe                	add    %edi,%esi
  8005c3:	f7 e1                	mul    %ecx
  8005c5:	8d 0c 16             	lea    (%esi,%edx,1),%ecx
  8005c8:	89 ca                	mov    %ecx,%edx
  8005ca:	03 45 d0             	add    -0x30(%ebp),%eax
  8005cd:	13 55 d4             	adc    -0x2c(%ebp),%edx
  8005d0:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8005d3:	89 01                	mov    %eax,(%ecx)
  8005d5:	89 51 04             	mov    %edx,0x4(%ecx)

	(*med) = KthElement(Elements, NumOfElements, (NumOfElements+1)/2);

	(*mean) /= NumOfElements;
	(*var) = 0;
	for (i = 0 ; i < NumOfElements ; i++)
  8005d8:	ff 45 e4             	incl   -0x1c(%ebp)
  8005db:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8005de:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8005e1:	0f 8c 76 ff ff ff    	jl     80055d <ArrayStats+0x12f>
	{
		(*var) += (int64)((Elements[i] - (*mean))*(Elements[i] - (*mean)));
	}
	(*var) /= NumOfElements;
  8005e7:	8b 45 14             	mov    0x14(%ebp),%eax
  8005ea:	8b 50 04             	mov    0x4(%eax),%edx
  8005ed:	8b 00                	mov    (%eax),%eax
  8005ef:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8005f2:	89 cb                	mov    %ecx,%ebx
  8005f4:	c1 fb 1f             	sar    $0x1f,%ebx
  8005f7:	53                   	push   %ebx
  8005f8:	51                   	push   %ecx
  8005f9:	52                   	push   %edx
  8005fa:	50                   	push   %eax
  8005fb:	e8 5c 26 00 00       	call   802c5c <__divdi3>
  800600:	83 c4 10             	add    $0x10,%esp
  800603:	8b 4d 14             	mov    0x14(%ebp),%ecx
  800606:	89 01                	mov    %eax,(%ecx)
  800608:	89 51 04             	mov    %edx,0x4(%ecx)
}
  80060b:	90                   	nop
  80060c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80060f:	5b                   	pop    %ebx
  800610:	5e                   	pop    %esi
  800611:	5f                   	pop    %edi
  800612:	5d                   	pop    %ebp
  800613:	c3                   	ret    

00800614 <Swap>:

///Private Functions
void Swap(int *Elements, int First, int Second)
{
  800614:	55                   	push   %ebp
  800615:	89 e5                	mov    %esp,%ebp
  800617:	83 ec 10             	sub    $0x10,%esp
	int Tmp = Elements[First] ;
  80061a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80061d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800624:	8b 45 08             	mov    0x8(%ebp),%eax
  800627:	01 d0                	add    %edx,%eax
  800629:	8b 00                	mov    (%eax),%eax
  80062b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	Elements[First] = Elements[Second] ;
  80062e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800631:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800638:	8b 45 08             	mov    0x8(%ebp),%eax
  80063b:	01 c2                	add    %eax,%edx
  80063d:	8b 45 10             	mov    0x10(%ebp),%eax
  800640:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800647:	8b 45 08             	mov    0x8(%ebp),%eax
  80064a:	01 c8                	add    %ecx,%eax
  80064c:	8b 00                	mov    (%eax),%eax
  80064e:	89 02                	mov    %eax,(%edx)
	Elements[Second] = Tmp ;
  800650:	8b 45 10             	mov    0x10(%ebp),%eax
  800653:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80065a:	8b 45 08             	mov    0x8(%ebp),%eax
  80065d:	01 c2                	add    %eax,%edx
  80065f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800662:	89 02                	mov    %eax,(%edx)
}
  800664:	90                   	nop
  800665:	c9                   	leave  
  800666:	c3                   	ret    

00800667 <libmain>:
volatile bool printStats = 1;

volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";
void
libmain(int argc, char **argv)
{
  800667:	55                   	push   %ebp
  800668:	89 e5                	mov    %esp,%ebp
  80066a:	57                   	push   %edi
  80066b:	56                   	push   %esi
  80066c:	53                   	push   %ebx
  80066d:	83 ec 7c             	sub    $0x7c,%esp
	//printStats = 1;
	int envIndex = sys_getenvindex();
  800670:	e8 1b 16 00 00       	call   801c90 <sys_getenvindex>
  800675:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	myEnv = &(envs[envIndex]);
  800678:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80067b:	89 d0                	mov    %edx,%eax
  80067d:	c1 e0 06             	shl    $0x6,%eax
  800680:	29 d0                	sub    %edx,%eax
  800682:	c1 e0 02             	shl    $0x2,%eax
  800685:	01 d0                	add    %edx,%eax
  800687:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  80068e:	01 c8                	add    %ecx,%eax
  800690:	c1 e0 03             	shl    $0x3,%eax
  800693:	01 d0                	add    %edx,%eax
  800695:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80069c:	29 c2                	sub    %eax,%edx
  80069e:	8d 04 95 00 00 00 00 	lea    0x0(,%edx,4),%eax
  8006a5:	89 c2                	mov    %eax,%edx
  8006a7:	8d 82 00 00 c0 ee    	lea    -0x11400000(%edx),%eax
  8006ad:	a3 20 40 80 00       	mov    %eax,0x804020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  8006b2:	a1 20 40 80 00       	mov    0x804020,%eax
  8006b7:	8a 40 20             	mov    0x20(%eax),%al
  8006ba:	84 c0                	test   %al,%al
  8006bc:	74 0d                	je     8006cb <libmain+0x64>
		binaryname = myEnv->prog_name;
  8006be:	a1 20 40 80 00       	mov    0x804020,%eax
  8006c3:	83 c0 20             	add    $0x20,%eax
  8006c6:	a3 04 40 80 00       	mov    %eax,0x804004

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8006cb:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8006cf:	7e 0a                	jle    8006db <libmain+0x74>
		binaryname = argv[0];
  8006d1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006d4:	8b 00                	mov    (%eax),%eax
  8006d6:	a3 04 40 80 00       	mov    %eax,0x804004

	// call user main routine
	_main(argc, argv);
  8006db:	83 ec 08             	sub    $0x8,%esp
  8006de:	ff 75 0c             	pushl  0xc(%ebp)
  8006e1:	ff 75 08             	pushl  0x8(%ebp)
  8006e4:	e8 4f f9 ff ff       	call   800038 <_main>
  8006e9:	83 c4 10             	add    $0x10,%esp

	if (printStats)
  8006ec:	a1 00 40 80 00       	mov    0x804000,%eax
  8006f1:	85 c0                	test   %eax,%eax
  8006f3:	0f 84 01 01 00 00    	je     8007fa <libmain+0x193>
	{
		char isOPTReplCmd[100] = "__IsOPTRepl__" ;
  8006f9:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  8006ff:	bb 08 32 80 00       	mov    $0x803208,%ebx
  800704:	ba 0e 00 00 00       	mov    $0xe,%edx
  800709:	89 c7                	mov    %eax,%edi
  80070b:	89 de                	mov    %ebx,%esi
  80070d:	89 d1                	mov    %edx,%ecx
  80070f:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  800711:	8d 55 8a             	lea    -0x76(%ebp),%edx
  800714:	b9 56 00 00 00       	mov    $0x56,%ecx
  800719:	b0 00                	mov    $0x0,%al
  80071b:	89 d7                	mov    %edx,%edi
  80071d:	f3 aa                	rep stos %al,%es:(%edi)
		int isOPTRepl = 0;
  80071f:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
		sys_utilities(isOPTReplCmd, (uint32)(&isOPTRepl));
  800726:	8d 45 e0             	lea    -0x20(%ebp),%eax
  800729:	83 ec 08             	sub    $0x8,%esp
  80072c:	50                   	push   %eax
  80072d:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  800733:	50                   	push   %eax
  800734:	e8 8d 17 00 00       	call   801ec6 <sys_utilities>
  800739:	83 c4 10             	add    $0x10,%esp

		sys_lock_cons();
  80073c:	e8 d6 12 00 00       	call   801a17 <sys_lock_cons>
		{
			cprintf("**************************************\n");
  800741:	83 ec 0c             	sub    $0xc,%esp
  800744:	68 28 31 80 00       	push   $0x803128
  800749:	e8 be 01 00 00       	call   80090c <cprintf>
  80074e:	83 c4 10             	add    $0x10,%esp
			if (isOPTRepl)
  800751:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800754:	85 c0                	test   %eax,%eax
  800756:	74 18                	je     800770 <libmain+0x109>
			{
				cprintf("OPTIMAL number of page faults = %d\n", sys_get_optimal_num_faults());
  800758:	e8 87 17 00 00       	call   801ee4 <sys_get_optimal_num_faults>
  80075d:	83 ec 08             	sub    $0x8,%esp
  800760:	50                   	push   %eax
  800761:	68 50 31 80 00       	push   $0x803150
  800766:	e8 a1 01 00 00       	call   80090c <cprintf>
  80076b:	83 c4 10             	add    $0x10,%esp
  80076e:	eb 59                	jmp    8007c9 <libmain+0x162>
			}
			else
			{
				cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  800770:	a1 20 40 80 00       	mov    0x804020,%eax
  800775:	8b 90 50 da 01 00    	mov    0x1da50(%eax),%edx
  80077b:	a1 20 40 80 00       	mov    0x804020,%eax
  800780:	8b 80 40 da 01 00    	mov    0x1da40(%eax),%eax
  800786:	83 ec 04             	sub    $0x4,%esp
  800789:	52                   	push   %edx
  80078a:	50                   	push   %eax
  80078b:	68 74 31 80 00       	push   $0x803174
  800790:	e8 77 01 00 00       	call   80090c <cprintf>
  800795:	83 c4 10             	add    $0x10,%esp
				cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800798:	a1 20 40 80 00       	mov    0x804020,%eax
  80079d:	8b 88 64 da 01 00    	mov    0x1da64(%eax),%ecx
  8007a3:	a1 20 40 80 00       	mov    0x804020,%eax
  8007a8:	8b 90 60 da 01 00    	mov    0x1da60(%eax),%edx
  8007ae:	a1 20 40 80 00       	mov    0x804020,%eax
  8007b3:	8b 80 5c da 01 00    	mov    0x1da5c(%eax),%eax
  8007b9:	51                   	push   %ecx
  8007ba:	52                   	push   %edx
  8007bb:	50                   	push   %eax
  8007bc:	68 9c 31 80 00       	push   $0x80319c
  8007c1:	e8 46 01 00 00       	call   80090c <cprintf>
  8007c6:	83 c4 10             	add    $0x10,%esp
			}
			//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
			cprintf("Num of clocks = %d\n", myEnv->nClocks);
  8007c9:	a1 20 40 80 00       	mov    0x804020,%eax
  8007ce:	8b 80 68 da 01 00    	mov    0x1da68(%eax),%eax
  8007d4:	83 ec 08             	sub    $0x8,%esp
  8007d7:	50                   	push   %eax
  8007d8:	68 f4 31 80 00       	push   $0x8031f4
  8007dd:	e8 2a 01 00 00       	call   80090c <cprintf>
  8007e2:	83 c4 10             	add    $0x10,%esp
			cprintf("**************************************\n");
  8007e5:	83 ec 0c             	sub    $0xc,%esp
  8007e8:	68 28 31 80 00       	push   $0x803128
  8007ed:	e8 1a 01 00 00       	call   80090c <cprintf>
  8007f2:	83 c4 10             	add    $0x10,%esp
		}
		sys_unlock_cons();
  8007f5:	e8 37 12 00 00       	call   801a31 <sys_unlock_cons>
	}

	// exit gracefully
	exit();
  8007fa:	e8 1f 00 00 00       	call   80081e <exit>
}
  8007ff:	90                   	nop
  800800:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800803:	5b                   	pop    %ebx
  800804:	5e                   	pop    %esi
  800805:	5f                   	pop    %edi
  800806:	5d                   	pop    %ebp
  800807:	c3                   	ret    

00800808 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800808:	55                   	push   %ebp
  800809:	89 e5                	mov    %esp,%ebp
  80080b:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  80080e:	83 ec 0c             	sub    $0xc,%esp
  800811:	6a 00                	push   $0x0
  800813:	e8 44 14 00 00       	call   801c5c <sys_destroy_env>
  800818:	83 c4 10             	add    $0x10,%esp
}
  80081b:	90                   	nop
  80081c:	c9                   	leave  
  80081d:	c3                   	ret    

0080081e <exit>:

void
exit(void)
{
  80081e:	55                   	push   %ebp
  80081f:	89 e5                	mov    %esp,%ebp
  800821:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  800824:	e8 99 14 00 00       	call   801cc2 <sys_exit_env>
}
  800829:	90                   	nop
  80082a:	c9                   	leave  
  80082b:	c3                   	ret    

0080082c <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  80082c:	55                   	push   %ebp
  80082d:	89 e5                	mov    %esp,%ebp
  80082f:	53                   	push   %ebx
  800830:	83 ec 04             	sub    $0x4,%esp
	b->buf[b->idx++] = ch;
  800833:	8b 45 0c             	mov    0xc(%ebp),%eax
  800836:	8b 00                	mov    (%eax),%eax
  800838:	8d 48 01             	lea    0x1(%eax),%ecx
  80083b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80083e:	89 0a                	mov    %ecx,(%edx)
  800840:	8b 55 08             	mov    0x8(%ebp),%edx
  800843:	88 d1                	mov    %dl,%cl
  800845:	8b 55 0c             	mov    0xc(%ebp),%edx
  800848:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  80084c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80084f:	8b 00                	mov    (%eax),%eax
  800851:	3d ff 00 00 00       	cmp    $0xff,%eax
  800856:	75 30                	jne    800888 <putch+0x5c>
		sys_cputs(b->buf, b->idx, printProgName, curTextClr);
  800858:	8b 15 18 c1 81 00    	mov    0x81c118,%edx
  80085e:	a0 44 40 80 00       	mov    0x804044,%al
  800863:	0f b6 c0             	movzbl %al,%eax
  800866:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800869:	8b 09                	mov    (%ecx),%ecx
  80086b:	89 cb                	mov    %ecx,%ebx
  80086d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800870:	83 c1 08             	add    $0x8,%ecx
  800873:	52                   	push   %edx
  800874:	50                   	push   %eax
  800875:	53                   	push   %ebx
  800876:	51                   	push   %ecx
  800877:	e8 57 11 00 00       	call   8019d3 <sys_cputs>
  80087c:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  80087f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800882:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800888:	8b 45 0c             	mov    0xc(%ebp),%eax
  80088b:	8b 40 04             	mov    0x4(%eax),%eax
  80088e:	8d 50 01             	lea    0x1(%eax),%edx
  800891:	8b 45 0c             	mov    0xc(%ebp),%eax
  800894:	89 50 04             	mov    %edx,0x4(%eax)
}
  800897:	90                   	nop
  800898:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80089b:	c9                   	leave  
  80089c:	c3                   	ret    

0080089d <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  80089d:	55                   	push   %ebp
  80089e:	89 e5                	mov    %esp,%ebp
  8008a0:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8008a6:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8008ad:	00 00 00 
	b.cnt = 0;
  8008b0:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8008b7:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  8008ba:	ff 75 0c             	pushl  0xc(%ebp)
  8008bd:	ff 75 08             	pushl  0x8(%ebp)
  8008c0:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8008c6:	50                   	push   %eax
  8008c7:	68 2c 08 80 00       	push   $0x80082c
  8008cc:	e8 5a 02 00 00       	call   800b2b <vprintfmt>
  8008d1:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName, curTextClr);
  8008d4:	8b 15 18 c1 81 00    	mov    0x81c118,%edx
  8008da:	a0 44 40 80 00       	mov    0x804044,%al
  8008df:	0f b6 c0             	movzbl %al,%eax
  8008e2:	8b 8d f0 fe ff ff    	mov    -0x110(%ebp),%ecx
  8008e8:	52                   	push   %edx
  8008e9:	50                   	push   %eax
  8008ea:	51                   	push   %ecx
  8008eb:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8008f1:	83 c0 08             	add    $0x8,%eax
  8008f4:	50                   	push   %eax
  8008f5:	e8 d9 10 00 00       	call   8019d3 <sys_cputs>
  8008fa:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  8008fd:	c6 05 44 40 80 00 00 	movb   $0x0,0x804044
	return b.cnt;
  800904:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  80090a:	c9                   	leave  
  80090b:	c3                   	ret    

0080090c <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  80090c:	55                   	push   %ebp
  80090d:	89 e5                	mov    %esp,%ebp
  80090f:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800912:	c6 05 44 40 80 00 01 	movb   $0x1,0x804044
	va_start(ap, fmt);
  800919:	8d 45 0c             	lea    0xc(%ebp),%eax
  80091c:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  80091f:	8b 45 08             	mov    0x8(%ebp),%eax
  800922:	83 ec 08             	sub    $0x8,%esp
  800925:	ff 75 f4             	pushl  -0xc(%ebp)
  800928:	50                   	push   %eax
  800929:	e8 6f ff ff ff       	call   80089d <vcprintf>
  80092e:	83 c4 10             	add    $0x10,%esp
  800931:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800934:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800937:	c9                   	leave  
  800938:	c3                   	ret    

00800939 <cprintf_colored>:

// *************** This text coloring feature is implemented by *************
// ********** Abd-Alrahman Zedan From Team Frozen-Bytes - FCIS'24-25 ********
int cprintf_colored(int textClr, const char *fmt, ...) {
  800939:	55                   	push   %ebp
  80093a:	89 e5                	mov    %esp,%ebp
  80093c:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  80093f:	c6 05 44 40 80 00 01 	movb   $0x1,0x804044
	curTextClr = (textClr << 8) ; //set text color by the given value
  800946:	8b 45 08             	mov    0x8(%ebp),%eax
  800949:	c1 e0 08             	shl    $0x8,%eax
  80094c:	a3 18 c1 81 00       	mov    %eax,0x81c118
	va_start(ap, fmt);
  800951:	8d 45 0c             	lea    0xc(%ebp),%eax
  800954:	83 c0 04             	add    $0x4,%eax
  800957:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  80095a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80095d:	83 ec 08             	sub    $0x8,%esp
  800960:	ff 75 f4             	pushl  -0xc(%ebp)
  800963:	50                   	push   %eax
  800964:	e8 34 ff ff ff       	call   80089d <vcprintf>
  800969:	83 c4 10             	add    $0x10,%esp
  80096c:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);
	curTextClr = TEXT_DEFAULT_CLR; //restore default color
  80096f:	c7 05 18 c1 81 00 00 	movl   $0x700,0x81c118
  800976:	07 00 00 

	return cnt;
  800979:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80097c:	c9                   	leave  
  80097d:	c3                   	ret    

0080097e <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  80097e:	55                   	push   %ebp
  80097f:	89 e5                	mov    %esp,%ebp
  800981:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  800984:	e8 8e 10 00 00       	call   801a17 <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  800989:	8d 45 0c             	lea    0xc(%ebp),%eax
  80098c:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  80098f:	8b 45 08             	mov    0x8(%ebp),%eax
  800992:	83 ec 08             	sub    $0x8,%esp
  800995:	ff 75 f4             	pushl  -0xc(%ebp)
  800998:	50                   	push   %eax
  800999:	e8 ff fe ff ff       	call   80089d <vcprintf>
  80099e:	83 c4 10             	add    $0x10,%esp
  8009a1:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  8009a4:	e8 88 10 00 00       	call   801a31 <sys_unlock_cons>
	return cnt;
  8009a9:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8009ac:	c9                   	leave  
  8009ad:	c3                   	ret    

008009ae <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8009ae:	55                   	push   %ebp
  8009af:	89 e5                	mov    %esp,%ebp
  8009b1:	53                   	push   %ebx
  8009b2:	83 ec 14             	sub    $0x14,%esp
  8009b5:	8b 45 10             	mov    0x10(%ebp),%eax
  8009b8:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8009bb:	8b 45 14             	mov    0x14(%ebp),%eax
  8009be:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8009c1:	8b 45 18             	mov    0x18(%ebp),%eax
  8009c4:	ba 00 00 00 00       	mov    $0x0,%edx
  8009c9:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8009cc:	77 55                	ja     800a23 <printnum+0x75>
  8009ce:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8009d1:	72 05                	jb     8009d8 <printnum+0x2a>
  8009d3:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8009d6:	77 4b                	ja     800a23 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8009d8:	8b 45 1c             	mov    0x1c(%ebp),%eax
  8009db:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8009de:	8b 45 18             	mov    0x18(%ebp),%eax
  8009e1:	ba 00 00 00 00       	mov    $0x0,%edx
  8009e6:	52                   	push   %edx
  8009e7:	50                   	push   %eax
  8009e8:	ff 75 f4             	pushl  -0xc(%ebp)
  8009eb:	ff 75 f0             	pushl  -0x10(%ebp)
  8009ee:	e8 d1 23 00 00       	call   802dc4 <__udivdi3>
  8009f3:	83 c4 10             	add    $0x10,%esp
  8009f6:	83 ec 04             	sub    $0x4,%esp
  8009f9:	ff 75 20             	pushl  0x20(%ebp)
  8009fc:	53                   	push   %ebx
  8009fd:	ff 75 18             	pushl  0x18(%ebp)
  800a00:	52                   	push   %edx
  800a01:	50                   	push   %eax
  800a02:	ff 75 0c             	pushl  0xc(%ebp)
  800a05:	ff 75 08             	pushl  0x8(%ebp)
  800a08:	e8 a1 ff ff ff       	call   8009ae <printnum>
  800a0d:	83 c4 20             	add    $0x20,%esp
  800a10:	eb 1a                	jmp    800a2c <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800a12:	83 ec 08             	sub    $0x8,%esp
  800a15:	ff 75 0c             	pushl  0xc(%ebp)
  800a18:	ff 75 20             	pushl  0x20(%ebp)
  800a1b:	8b 45 08             	mov    0x8(%ebp),%eax
  800a1e:	ff d0                	call   *%eax
  800a20:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800a23:	ff 4d 1c             	decl   0x1c(%ebp)
  800a26:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800a2a:	7f e6                	jg     800a12 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800a2c:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800a2f:	bb 00 00 00 00       	mov    $0x0,%ebx
  800a34:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800a37:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800a3a:	53                   	push   %ebx
  800a3b:	51                   	push   %ecx
  800a3c:	52                   	push   %edx
  800a3d:	50                   	push   %eax
  800a3e:	e8 91 24 00 00       	call   802ed4 <__umoddi3>
  800a43:	83 c4 10             	add    $0x10,%esp
  800a46:	05 94 34 80 00       	add    $0x803494,%eax
  800a4b:	8a 00                	mov    (%eax),%al
  800a4d:	0f be c0             	movsbl %al,%eax
  800a50:	83 ec 08             	sub    $0x8,%esp
  800a53:	ff 75 0c             	pushl  0xc(%ebp)
  800a56:	50                   	push   %eax
  800a57:	8b 45 08             	mov    0x8(%ebp),%eax
  800a5a:	ff d0                	call   *%eax
  800a5c:	83 c4 10             	add    $0x10,%esp
}
  800a5f:	90                   	nop
  800a60:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800a63:	c9                   	leave  
  800a64:	c3                   	ret    

00800a65 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800a65:	55                   	push   %ebp
  800a66:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800a68:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800a6c:	7e 1c                	jle    800a8a <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800a6e:	8b 45 08             	mov    0x8(%ebp),%eax
  800a71:	8b 00                	mov    (%eax),%eax
  800a73:	8d 50 08             	lea    0x8(%eax),%edx
  800a76:	8b 45 08             	mov    0x8(%ebp),%eax
  800a79:	89 10                	mov    %edx,(%eax)
  800a7b:	8b 45 08             	mov    0x8(%ebp),%eax
  800a7e:	8b 00                	mov    (%eax),%eax
  800a80:	83 e8 08             	sub    $0x8,%eax
  800a83:	8b 50 04             	mov    0x4(%eax),%edx
  800a86:	8b 00                	mov    (%eax),%eax
  800a88:	eb 40                	jmp    800aca <getuint+0x65>
	else if (lflag)
  800a8a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800a8e:	74 1e                	je     800aae <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800a90:	8b 45 08             	mov    0x8(%ebp),%eax
  800a93:	8b 00                	mov    (%eax),%eax
  800a95:	8d 50 04             	lea    0x4(%eax),%edx
  800a98:	8b 45 08             	mov    0x8(%ebp),%eax
  800a9b:	89 10                	mov    %edx,(%eax)
  800a9d:	8b 45 08             	mov    0x8(%ebp),%eax
  800aa0:	8b 00                	mov    (%eax),%eax
  800aa2:	83 e8 04             	sub    $0x4,%eax
  800aa5:	8b 00                	mov    (%eax),%eax
  800aa7:	ba 00 00 00 00       	mov    $0x0,%edx
  800aac:	eb 1c                	jmp    800aca <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800aae:	8b 45 08             	mov    0x8(%ebp),%eax
  800ab1:	8b 00                	mov    (%eax),%eax
  800ab3:	8d 50 04             	lea    0x4(%eax),%edx
  800ab6:	8b 45 08             	mov    0x8(%ebp),%eax
  800ab9:	89 10                	mov    %edx,(%eax)
  800abb:	8b 45 08             	mov    0x8(%ebp),%eax
  800abe:	8b 00                	mov    (%eax),%eax
  800ac0:	83 e8 04             	sub    $0x4,%eax
  800ac3:	8b 00                	mov    (%eax),%eax
  800ac5:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800aca:	5d                   	pop    %ebp
  800acb:	c3                   	ret    

00800acc <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800acc:	55                   	push   %ebp
  800acd:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800acf:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800ad3:	7e 1c                	jle    800af1 <getint+0x25>
		return va_arg(*ap, long long);
  800ad5:	8b 45 08             	mov    0x8(%ebp),%eax
  800ad8:	8b 00                	mov    (%eax),%eax
  800ada:	8d 50 08             	lea    0x8(%eax),%edx
  800add:	8b 45 08             	mov    0x8(%ebp),%eax
  800ae0:	89 10                	mov    %edx,(%eax)
  800ae2:	8b 45 08             	mov    0x8(%ebp),%eax
  800ae5:	8b 00                	mov    (%eax),%eax
  800ae7:	83 e8 08             	sub    $0x8,%eax
  800aea:	8b 50 04             	mov    0x4(%eax),%edx
  800aed:	8b 00                	mov    (%eax),%eax
  800aef:	eb 38                	jmp    800b29 <getint+0x5d>
	else if (lflag)
  800af1:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800af5:	74 1a                	je     800b11 <getint+0x45>
		return va_arg(*ap, long);
  800af7:	8b 45 08             	mov    0x8(%ebp),%eax
  800afa:	8b 00                	mov    (%eax),%eax
  800afc:	8d 50 04             	lea    0x4(%eax),%edx
  800aff:	8b 45 08             	mov    0x8(%ebp),%eax
  800b02:	89 10                	mov    %edx,(%eax)
  800b04:	8b 45 08             	mov    0x8(%ebp),%eax
  800b07:	8b 00                	mov    (%eax),%eax
  800b09:	83 e8 04             	sub    $0x4,%eax
  800b0c:	8b 00                	mov    (%eax),%eax
  800b0e:	99                   	cltd   
  800b0f:	eb 18                	jmp    800b29 <getint+0x5d>
	else
		return va_arg(*ap, int);
  800b11:	8b 45 08             	mov    0x8(%ebp),%eax
  800b14:	8b 00                	mov    (%eax),%eax
  800b16:	8d 50 04             	lea    0x4(%eax),%edx
  800b19:	8b 45 08             	mov    0x8(%ebp),%eax
  800b1c:	89 10                	mov    %edx,(%eax)
  800b1e:	8b 45 08             	mov    0x8(%ebp),%eax
  800b21:	8b 00                	mov    (%eax),%eax
  800b23:	83 e8 04             	sub    $0x4,%eax
  800b26:	8b 00                	mov    (%eax),%eax
  800b28:	99                   	cltd   
}
  800b29:	5d                   	pop    %ebp
  800b2a:	c3                   	ret    

00800b2b <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800b2b:	55                   	push   %ebp
  800b2c:	89 e5                	mov    %esp,%ebp
  800b2e:	56                   	push   %esi
  800b2f:	53                   	push   %ebx
  800b30:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800b33:	eb 17                	jmp    800b4c <vprintfmt+0x21>
			if (ch == '\0')
  800b35:	85 db                	test   %ebx,%ebx
  800b37:	0f 84 c1 03 00 00    	je     800efe <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  800b3d:	83 ec 08             	sub    $0x8,%esp
  800b40:	ff 75 0c             	pushl  0xc(%ebp)
  800b43:	53                   	push   %ebx
  800b44:	8b 45 08             	mov    0x8(%ebp),%eax
  800b47:	ff d0                	call   *%eax
  800b49:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800b4c:	8b 45 10             	mov    0x10(%ebp),%eax
  800b4f:	8d 50 01             	lea    0x1(%eax),%edx
  800b52:	89 55 10             	mov    %edx,0x10(%ebp)
  800b55:	8a 00                	mov    (%eax),%al
  800b57:	0f b6 d8             	movzbl %al,%ebx
  800b5a:	83 fb 25             	cmp    $0x25,%ebx
  800b5d:	75 d6                	jne    800b35 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800b5f:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800b63:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800b6a:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800b71:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800b78:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800b7f:	8b 45 10             	mov    0x10(%ebp),%eax
  800b82:	8d 50 01             	lea    0x1(%eax),%edx
  800b85:	89 55 10             	mov    %edx,0x10(%ebp)
  800b88:	8a 00                	mov    (%eax),%al
  800b8a:	0f b6 d8             	movzbl %al,%ebx
  800b8d:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800b90:	83 f8 5b             	cmp    $0x5b,%eax
  800b93:	0f 87 3d 03 00 00    	ja     800ed6 <vprintfmt+0x3ab>
  800b99:	8b 04 85 b8 34 80 00 	mov    0x8034b8(,%eax,4),%eax
  800ba0:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800ba2:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800ba6:	eb d7                	jmp    800b7f <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800ba8:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800bac:	eb d1                	jmp    800b7f <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800bae:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800bb5:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800bb8:	89 d0                	mov    %edx,%eax
  800bba:	c1 e0 02             	shl    $0x2,%eax
  800bbd:	01 d0                	add    %edx,%eax
  800bbf:	01 c0                	add    %eax,%eax
  800bc1:	01 d8                	add    %ebx,%eax
  800bc3:	83 e8 30             	sub    $0x30,%eax
  800bc6:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800bc9:	8b 45 10             	mov    0x10(%ebp),%eax
  800bcc:	8a 00                	mov    (%eax),%al
  800bce:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800bd1:	83 fb 2f             	cmp    $0x2f,%ebx
  800bd4:	7e 3e                	jle    800c14 <vprintfmt+0xe9>
  800bd6:	83 fb 39             	cmp    $0x39,%ebx
  800bd9:	7f 39                	jg     800c14 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800bdb:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800bde:	eb d5                	jmp    800bb5 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800be0:	8b 45 14             	mov    0x14(%ebp),%eax
  800be3:	83 c0 04             	add    $0x4,%eax
  800be6:	89 45 14             	mov    %eax,0x14(%ebp)
  800be9:	8b 45 14             	mov    0x14(%ebp),%eax
  800bec:	83 e8 04             	sub    $0x4,%eax
  800bef:	8b 00                	mov    (%eax),%eax
  800bf1:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800bf4:	eb 1f                	jmp    800c15 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800bf6:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800bfa:	79 83                	jns    800b7f <vprintfmt+0x54>
				width = 0;
  800bfc:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800c03:	e9 77 ff ff ff       	jmp    800b7f <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800c08:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800c0f:	e9 6b ff ff ff       	jmp    800b7f <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800c14:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800c15:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800c19:	0f 89 60 ff ff ff    	jns    800b7f <vprintfmt+0x54>
				width = precision, precision = -1;
  800c1f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800c22:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800c25:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800c2c:	e9 4e ff ff ff       	jmp    800b7f <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800c31:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800c34:	e9 46 ff ff ff       	jmp    800b7f <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800c39:	8b 45 14             	mov    0x14(%ebp),%eax
  800c3c:	83 c0 04             	add    $0x4,%eax
  800c3f:	89 45 14             	mov    %eax,0x14(%ebp)
  800c42:	8b 45 14             	mov    0x14(%ebp),%eax
  800c45:	83 e8 04             	sub    $0x4,%eax
  800c48:	8b 00                	mov    (%eax),%eax
  800c4a:	83 ec 08             	sub    $0x8,%esp
  800c4d:	ff 75 0c             	pushl  0xc(%ebp)
  800c50:	50                   	push   %eax
  800c51:	8b 45 08             	mov    0x8(%ebp),%eax
  800c54:	ff d0                	call   *%eax
  800c56:	83 c4 10             	add    $0x10,%esp
			break;
  800c59:	e9 9b 02 00 00       	jmp    800ef9 <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800c5e:	8b 45 14             	mov    0x14(%ebp),%eax
  800c61:	83 c0 04             	add    $0x4,%eax
  800c64:	89 45 14             	mov    %eax,0x14(%ebp)
  800c67:	8b 45 14             	mov    0x14(%ebp),%eax
  800c6a:	83 e8 04             	sub    $0x4,%eax
  800c6d:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800c6f:	85 db                	test   %ebx,%ebx
  800c71:	79 02                	jns    800c75 <vprintfmt+0x14a>
				err = -err;
  800c73:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800c75:	83 fb 64             	cmp    $0x64,%ebx
  800c78:	7f 0b                	jg     800c85 <vprintfmt+0x15a>
  800c7a:	8b 34 9d 00 33 80 00 	mov    0x803300(,%ebx,4),%esi
  800c81:	85 f6                	test   %esi,%esi
  800c83:	75 19                	jne    800c9e <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800c85:	53                   	push   %ebx
  800c86:	68 a5 34 80 00       	push   $0x8034a5
  800c8b:	ff 75 0c             	pushl  0xc(%ebp)
  800c8e:	ff 75 08             	pushl  0x8(%ebp)
  800c91:	e8 70 02 00 00       	call   800f06 <printfmt>
  800c96:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800c99:	e9 5b 02 00 00       	jmp    800ef9 <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800c9e:	56                   	push   %esi
  800c9f:	68 ae 34 80 00       	push   $0x8034ae
  800ca4:	ff 75 0c             	pushl  0xc(%ebp)
  800ca7:	ff 75 08             	pushl  0x8(%ebp)
  800caa:	e8 57 02 00 00       	call   800f06 <printfmt>
  800caf:	83 c4 10             	add    $0x10,%esp
			break;
  800cb2:	e9 42 02 00 00       	jmp    800ef9 <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800cb7:	8b 45 14             	mov    0x14(%ebp),%eax
  800cba:	83 c0 04             	add    $0x4,%eax
  800cbd:	89 45 14             	mov    %eax,0x14(%ebp)
  800cc0:	8b 45 14             	mov    0x14(%ebp),%eax
  800cc3:	83 e8 04             	sub    $0x4,%eax
  800cc6:	8b 30                	mov    (%eax),%esi
  800cc8:	85 f6                	test   %esi,%esi
  800cca:	75 05                	jne    800cd1 <vprintfmt+0x1a6>
				p = "(null)";
  800ccc:	be b1 34 80 00       	mov    $0x8034b1,%esi
			if (width > 0 && padc != '-')
  800cd1:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800cd5:	7e 6d                	jle    800d44 <vprintfmt+0x219>
  800cd7:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800cdb:	74 67                	je     800d44 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800cdd:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800ce0:	83 ec 08             	sub    $0x8,%esp
  800ce3:	50                   	push   %eax
  800ce4:	56                   	push   %esi
  800ce5:	e8 1e 03 00 00       	call   801008 <strnlen>
  800cea:	83 c4 10             	add    $0x10,%esp
  800ced:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800cf0:	eb 16                	jmp    800d08 <vprintfmt+0x1dd>
					putch(padc, putdat);
  800cf2:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800cf6:	83 ec 08             	sub    $0x8,%esp
  800cf9:	ff 75 0c             	pushl  0xc(%ebp)
  800cfc:	50                   	push   %eax
  800cfd:	8b 45 08             	mov    0x8(%ebp),%eax
  800d00:	ff d0                	call   *%eax
  800d02:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800d05:	ff 4d e4             	decl   -0x1c(%ebp)
  800d08:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800d0c:	7f e4                	jg     800cf2 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800d0e:	eb 34                	jmp    800d44 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800d10:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800d14:	74 1c                	je     800d32 <vprintfmt+0x207>
  800d16:	83 fb 1f             	cmp    $0x1f,%ebx
  800d19:	7e 05                	jle    800d20 <vprintfmt+0x1f5>
  800d1b:	83 fb 7e             	cmp    $0x7e,%ebx
  800d1e:	7e 12                	jle    800d32 <vprintfmt+0x207>
					putch('?', putdat);
  800d20:	83 ec 08             	sub    $0x8,%esp
  800d23:	ff 75 0c             	pushl  0xc(%ebp)
  800d26:	6a 3f                	push   $0x3f
  800d28:	8b 45 08             	mov    0x8(%ebp),%eax
  800d2b:	ff d0                	call   *%eax
  800d2d:	83 c4 10             	add    $0x10,%esp
  800d30:	eb 0f                	jmp    800d41 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800d32:	83 ec 08             	sub    $0x8,%esp
  800d35:	ff 75 0c             	pushl  0xc(%ebp)
  800d38:	53                   	push   %ebx
  800d39:	8b 45 08             	mov    0x8(%ebp),%eax
  800d3c:	ff d0                	call   *%eax
  800d3e:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800d41:	ff 4d e4             	decl   -0x1c(%ebp)
  800d44:	89 f0                	mov    %esi,%eax
  800d46:	8d 70 01             	lea    0x1(%eax),%esi
  800d49:	8a 00                	mov    (%eax),%al
  800d4b:	0f be d8             	movsbl %al,%ebx
  800d4e:	85 db                	test   %ebx,%ebx
  800d50:	74 24                	je     800d76 <vprintfmt+0x24b>
  800d52:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800d56:	78 b8                	js     800d10 <vprintfmt+0x1e5>
  800d58:	ff 4d e0             	decl   -0x20(%ebp)
  800d5b:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800d5f:	79 af                	jns    800d10 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800d61:	eb 13                	jmp    800d76 <vprintfmt+0x24b>
				putch(' ', putdat);
  800d63:	83 ec 08             	sub    $0x8,%esp
  800d66:	ff 75 0c             	pushl  0xc(%ebp)
  800d69:	6a 20                	push   $0x20
  800d6b:	8b 45 08             	mov    0x8(%ebp),%eax
  800d6e:	ff d0                	call   *%eax
  800d70:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800d73:	ff 4d e4             	decl   -0x1c(%ebp)
  800d76:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800d7a:	7f e7                	jg     800d63 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800d7c:	e9 78 01 00 00       	jmp    800ef9 <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800d81:	83 ec 08             	sub    $0x8,%esp
  800d84:	ff 75 e8             	pushl  -0x18(%ebp)
  800d87:	8d 45 14             	lea    0x14(%ebp),%eax
  800d8a:	50                   	push   %eax
  800d8b:	e8 3c fd ff ff       	call   800acc <getint>
  800d90:	83 c4 10             	add    $0x10,%esp
  800d93:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800d96:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800d99:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800d9c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800d9f:	85 d2                	test   %edx,%edx
  800da1:	79 23                	jns    800dc6 <vprintfmt+0x29b>
				putch('-', putdat);
  800da3:	83 ec 08             	sub    $0x8,%esp
  800da6:	ff 75 0c             	pushl  0xc(%ebp)
  800da9:	6a 2d                	push   $0x2d
  800dab:	8b 45 08             	mov    0x8(%ebp),%eax
  800dae:	ff d0                	call   *%eax
  800db0:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800db3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800db6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800db9:	f7 d8                	neg    %eax
  800dbb:	83 d2 00             	adc    $0x0,%edx
  800dbe:	f7 da                	neg    %edx
  800dc0:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800dc3:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800dc6:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800dcd:	e9 bc 00 00 00       	jmp    800e8e <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800dd2:	83 ec 08             	sub    $0x8,%esp
  800dd5:	ff 75 e8             	pushl  -0x18(%ebp)
  800dd8:	8d 45 14             	lea    0x14(%ebp),%eax
  800ddb:	50                   	push   %eax
  800ddc:	e8 84 fc ff ff       	call   800a65 <getuint>
  800de1:	83 c4 10             	add    $0x10,%esp
  800de4:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800de7:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800dea:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800df1:	e9 98 00 00 00       	jmp    800e8e <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800df6:	83 ec 08             	sub    $0x8,%esp
  800df9:	ff 75 0c             	pushl  0xc(%ebp)
  800dfc:	6a 58                	push   $0x58
  800dfe:	8b 45 08             	mov    0x8(%ebp),%eax
  800e01:	ff d0                	call   *%eax
  800e03:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800e06:	83 ec 08             	sub    $0x8,%esp
  800e09:	ff 75 0c             	pushl  0xc(%ebp)
  800e0c:	6a 58                	push   $0x58
  800e0e:	8b 45 08             	mov    0x8(%ebp),%eax
  800e11:	ff d0                	call   *%eax
  800e13:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800e16:	83 ec 08             	sub    $0x8,%esp
  800e19:	ff 75 0c             	pushl  0xc(%ebp)
  800e1c:	6a 58                	push   $0x58
  800e1e:	8b 45 08             	mov    0x8(%ebp),%eax
  800e21:	ff d0                	call   *%eax
  800e23:	83 c4 10             	add    $0x10,%esp
			break;
  800e26:	e9 ce 00 00 00       	jmp    800ef9 <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  800e2b:	83 ec 08             	sub    $0x8,%esp
  800e2e:	ff 75 0c             	pushl  0xc(%ebp)
  800e31:	6a 30                	push   $0x30
  800e33:	8b 45 08             	mov    0x8(%ebp),%eax
  800e36:	ff d0                	call   *%eax
  800e38:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800e3b:	83 ec 08             	sub    $0x8,%esp
  800e3e:	ff 75 0c             	pushl  0xc(%ebp)
  800e41:	6a 78                	push   $0x78
  800e43:	8b 45 08             	mov    0x8(%ebp),%eax
  800e46:	ff d0                	call   *%eax
  800e48:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800e4b:	8b 45 14             	mov    0x14(%ebp),%eax
  800e4e:	83 c0 04             	add    $0x4,%eax
  800e51:	89 45 14             	mov    %eax,0x14(%ebp)
  800e54:	8b 45 14             	mov    0x14(%ebp),%eax
  800e57:	83 e8 04             	sub    $0x4,%eax
  800e5a:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800e5c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800e5f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800e66:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800e6d:	eb 1f                	jmp    800e8e <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800e6f:	83 ec 08             	sub    $0x8,%esp
  800e72:	ff 75 e8             	pushl  -0x18(%ebp)
  800e75:	8d 45 14             	lea    0x14(%ebp),%eax
  800e78:	50                   	push   %eax
  800e79:	e8 e7 fb ff ff       	call   800a65 <getuint>
  800e7e:	83 c4 10             	add    $0x10,%esp
  800e81:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800e84:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800e87:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800e8e:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800e92:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800e95:	83 ec 04             	sub    $0x4,%esp
  800e98:	52                   	push   %edx
  800e99:	ff 75 e4             	pushl  -0x1c(%ebp)
  800e9c:	50                   	push   %eax
  800e9d:	ff 75 f4             	pushl  -0xc(%ebp)
  800ea0:	ff 75 f0             	pushl  -0x10(%ebp)
  800ea3:	ff 75 0c             	pushl  0xc(%ebp)
  800ea6:	ff 75 08             	pushl  0x8(%ebp)
  800ea9:	e8 00 fb ff ff       	call   8009ae <printnum>
  800eae:	83 c4 20             	add    $0x20,%esp
			break;
  800eb1:	eb 46                	jmp    800ef9 <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800eb3:	83 ec 08             	sub    $0x8,%esp
  800eb6:	ff 75 0c             	pushl  0xc(%ebp)
  800eb9:	53                   	push   %ebx
  800eba:	8b 45 08             	mov    0x8(%ebp),%eax
  800ebd:	ff d0                	call   *%eax
  800ebf:	83 c4 10             	add    $0x10,%esp
			break;
  800ec2:	eb 35                	jmp    800ef9 <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  800ec4:	c6 05 44 40 80 00 00 	movb   $0x0,0x804044
			break;
  800ecb:	eb 2c                	jmp    800ef9 <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  800ecd:	c6 05 44 40 80 00 01 	movb   $0x1,0x804044
			break;
  800ed4:	eb 23                	jmp    800ef9 <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800ed6:	83 ec 08             	sub    $0x8,%esp
  800ed9:	ff 75 0c             	pushl  0xc(%ebp)
  800edc:	6a 25                	push   $0x25
  800ede:	8b 45 08             	mov    0x8(%ebp),%eax
  800ee1:	ff d0                	call   *%eax
  800ee3:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800ee6:	ff 4d 10             	decl   0x10(%ebp)
  800ee9:	eb 03                	jmp    800eee <vprintfmt+0x3c3>
  800eeb:	ff 4d 10             	decl   0x10(%ebp)
  800eee:	8b 45 10             	mov    0x10(%ebp),%eax
  800ef1:	48                   	dec    %eax
  800ef2:	8a 00                	mov    (%eax),%al
  800ef4:	3c 25                	cmp    $0x25,%al
  800ef6:	75 f3                	jne    800eeb <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  800ef8:	90                   	nop
		}
	}
  800ef9:	e9 35 fc ff ff       	jmp    800b33 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800efe:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800eff:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800f02:	5b                   	pop    %ebx
  800f03:	5e                   	pop    %esi
  800f04:	5d                   	pop    %ebp
  800f05:	c3                   	ret    

00800f06 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800f06:	55                   	push   %ebp
  800f07:	89 e5                	mov    %esp,%ebp
  800f09:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800f0c:	8d 45 10             	lea    0x10(%ebp),%eax
  800f0f:	83 c0 04             	add    $0x4,%eax
  800f12:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800f15:	8b 45 10             	mov    0x10(%ebp),%eax
  800f18:	ff 75 f4             	pushl  -0xc(%ebp)
  800f1b:	50                   	push   %eax
  800f1c:	ff 75 0c             	pushl  0xc(%ebp)
  800f1f:	ff 75 08             	pushl  0x8(%ebp)
  800f22:	e8 04 fc ff ff       	call   800b2b <vprintfmt>
  800f27:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800f2a:	90                   	nop
  800f2b:	c9                   	leave  
  800f2c:	c3                   	ret    

00800f2d <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800f2d:	55                   	push   %ebp
  800f2e:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800f30:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f33:	8b 40 08             	mov    0x8(%eax),%eax
  800f36:	8d 50 01             	lea    0x1(%eax),%edx
  800f39:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f3c:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800f3f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f42:	8b 10                	mov    (%eax),%edx
  800f44:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f47:	8b 40 04             	mov    0x4(%eax),%eax
  800f4a:	39 c2                	cmp    %eax,%edx
  800f4c:	73 12                	jae    800f60 <sprintputch+0x33>
		*b->buf++ = ch;
  800f4e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f51:	8b 00                	mov    (%eax),%eax
  800f53:	8d 48 01             	lea    0x1(%eax),%ecx
  800f56:	8b 55 0c             	mov    0xc(%ebp),%edx
  800f59:	89 0a                	mov    %ecx,(%edx)
  800f5b:	8b 55 08             	mov    0x8(%ebp),%edx
  800f5e:	88 10                	mov    %dl,(%eax)
}
  800f60:	90                   	nop
  800f61:	5d                   	pop    %ebp
  800f62:	c3                   	ret    

00800f63 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800f63:	55                   	push   %ebp
  800f64:	89 e5                	mov    %esp,%ebp
  800f66:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800f69:	8b 45 08             	mov    0x8(%ebp),%eax
  800f6c:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800f6f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f72:	8d 50 ff             	lea    -0x1(%eax),%edx
  800f75:	8b 45 08             	mov    0x8(%ebp),%eax
  800f78:	01 d0                	add    %edx,%eax
  800f7a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800f7d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800f84:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800f88:	74 06                	je     800f90 <vsnprintf+0x2d>
  800f8a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800f8e:	7f 07                	jg     800f97 <vsnprintf+0x34>
		return -E_INVAL;
  800f90:	b8 03 00 00 00       	mov    $0x3,%eax
  800f95:	eb 20                	jmp    800fb7 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800f97:	ff 75 14             	pushl  0x14(%ebp)
  800f9a:	ff 75 10             	pushl  0x10(%ebp)
  800f9d:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800fa0:	50                   	push   %eax
  800fa1:	68 2d 0f 80 00       	push   $0x800f2d
  800fa6:	e8 80 fb ff ff       	call   800b2b <vprintfmt>
  800fab:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800fae:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800fb1:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800fb4:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800fb7:	c9                   	leave  
  800fb8:	c3                   	ret    

00800fb9 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800fb9:	55                   	push   %ebp
  800fba:	89 e5                	mov    %esp,%ebp
  800fbc:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800fbf:	8d 45 10             	lea    0x10(%ebp),%eax
  800fc2:	83 c0 04             	add    $0x4,%eax
  800fc5:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800fc8:	8b 45 10             	mov    0x10(%ebp),%eax
  800fcb:	ff 75 f4             	pushl  -0xc(%ebp)
  800fce:	50                   	push   %eax
  800fcf:	ff 75 0c             	pushl  0xc(%ebp)
  800fd2:	ff 75 08             	pushl  0x8(%ebp)
  800fd5:	e8 89 ff ff ff       	call   800f63 <vsnprintf>
  800fda:	83 c4 10             	add    $0x10,%esp
  800fdd:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800fe0:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800fe3:	c9                   	leave  
  800fe4:	c3                   	ret    

00800fe5 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800fe5:	55                   	push   %ebp
  800fe6:	89 e5                	mov    %esp,%ebp
  800fe8:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800feb:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800ff2:	eb 06                	jmp    800ffa <strlen+0x15>
		n++;
  800ff4:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800ff7:	ff 45 08             	incl   0x8(%ebp)
  800ffa:	8b 45 08             	mov    0x8(%ebp),%eax
  800ffd:	8a 00                	mov    (%eax),%al
  800fff:	84 c0                	test   %al,%al
  801001:	75 f1                	jne    800ff4 <strlen+0xf>
		n++;
	return n;
  801003:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801006:	c9                   	leave  
  801007:	c3                   	ret    

00801008 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  801008:	55                   	push   %ebp
  801009:	89 e5                	mov    %esp,%ebp
  80100b:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80100e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801015:	eb 09                	jmp    801020 <strnlen+0x18>
		n++;
  801017:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80101a:	ff 45 08             	incl   0x8(%ebp)
  80101d:	ff 4d 0c             	decl   0xc(%ebp)
  801020:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801024:	74 09                	je     80102f <strnlen+0x27>
  801026:	8b 45 08             	mov    0x8(%ebp),%eax
  801029:	8a 00                	mov    (%eax),%al
  80102b:	84 c0                	test   %al,%al
  80102d:	75 e8                	jne    801017 <strnlen+0xf>
		n++;
	return n;
  80102f:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801032:	c9                   	leave  
  801033:	c3                   	ret    

00801034 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  801034:	55                   	push   %ebp
  801035:	89 e5                	mov    %esp,%ebp
  801037:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  80103a:	8b 45 08             	mov    0x8(%ebp),%eax
  80103d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  801040:	90                   	nop
  801041:	8b 45 08             	mov    0x8(%ebp),%eax
  801044:	8d 50 01             	lea    0x1(%eax),%edx
  801047:	89 55 08             	mov    %edx,0x8(%ebp)
  80104a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80104d:	8d 4a 01             	lea    0x1(%edx),%ecx
  801050:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  801053:	8a 12                	mov    (%edx),%dl
  801055:	88 10                	mov    %dl,(%eax)
  801057:	8a 00                	mov    (%eax),%al
  801059:	84 c0                	test   %al,%al
  80105b:	75 e4                	jne    801041 <strcpy+0xd>
		/* do nothing */;
	return ret;
  80105d:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801060:	c9                   	leave  
  801061:	c3                   	ret    

00801062 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  801062:	55                   	push   %ebp
  801063:	89 e5                	mov    %esp,%ebp
  801065:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  801068:	8b 45 08             	mov    0x8(%ebp),%eax
  80106b:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  80106e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801075:	eb 1f                	jmp    801096 <strncpy+0x34>
		*dst++ = *src;
  801077:	8b 45 08             	mov    0x8(%ebp),%eax
  80107a:	8d 50 01             	lea    0x1(%eax),%edx
  80107d:	89 55 08             	mov    %edx,0x8(%ebp)
  801080:	8b 55 0c             	mov    0xc(%ebp),%edx
  801083:	8a 12                	mov    (%edx),%dl
  801085:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  801087:	8b 45 0c             	mov    0xc(%ebp),%eax
  80108a:	8a 00                	mov    (%eax),%al
  80108c:	84 c0                	test   %al,%al
  80108e:	74 03                	je     801093 <strncpy+0x31>
			src++;
  801090:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  801093:	ff 45 fc             	incl   -0x4(%ebp)
  801096:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801099:	3b 45 10             	cmp    0x10(%ebp),%eax
  80109c:	72 d9                	jb     801077 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  80109e:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8010a1:	c9                   	leave  
  8010a2:	c3                   	ret    

008010a3 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  8010a3:	55                   	push   %ebp
  8010a4:	89 e5                	mov    %esp,%ebp
  8010a6:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  8010a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8010ac:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  8010af:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8010b3:	74 30                	je     8010e5 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  8010b5:	eb 16                	jmp    8010cd <strlcpy+0x2a>
			*dst++ = *src++;
  8010b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8010ba:	8d 50 01             	lea    0x1(%eax),%edx
  8010bd:	89 55 08             	mov    %edx,0x8(%ebp)
  8010c0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8010c3:	8d 4a 01             	lea    0x1(%edx),%ecx
  8010c6:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  8010c9:	8a 12                	mov    (%edx),%dl
  8010cb:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  8010cd:	ff 4d 10             	decl   0x10(%ebp)
  8010d0:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8010d4:	74 09                	je     8010df <strlcpy+0x3c>
  8010d6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010d9:	8a 00                	mov    (%eax),%al
  8010db:	84 c0                	test   %al,%al
  8010dd:	75 d8                	jne    8010b7 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  8010df:	8b 45 08             	mov    0x8(%ebp),%eax
  8010e2:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  8010e5:	8b 55 08             	mov    0x8(%ebp),%edx
  8010e8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8010eb:	29 c2                	sub    %eax,%edx
  8010ed:	89 d0                	mov    %edx,%eax
}
  8010ef:	c9                   	leave  
  8010f0:	c3                   	ret    

008010f1 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8010f1:	55                   	push   %ebp
  8010f2:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  8010f4:	eb 06                	jmp    8010fc <strcmp+0xb>
		p++, q++;
  8010f6:	ff 45 08             	incl   0x8(%ebp)
  8010f9:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  8010fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8010ff:	8a 00                	mov    (%eax),%al
  801101:	84 c0                	test   %al,%al
  801103:	74 0e                	je     801113 <strcmp+0x22>
  801105:	8b 45 08             	mov    0x8(%ebp),%eax
  801108:	8a 10                	mov    (%eax),%dl
  80110a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80110d:	8a 00                	mov    (%eax),%al
  80110f:	38 c2                	cmp    %al,%dl
  801111:	74 e3                	je     8010f6 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  801113:	8b 45 08             	mov    0x8(%ebp),%eax
  801116:	8a 00                	mov    (%eax),%al
  801118:	0f b6 d0             	movzbl %al,%edx
  80111b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80111e:	8a 00                	mov    (%eax),%al
  801120:	0f b6 c0             	movzbl %al,%eax
  801123:	29 c2                	sub    %eax,%edx
  801125:	89 d0                	mov    %edx,%eax
}
  801127:	5d                   	pop    %ebp
  801128:	c3                   	ret    

00801129 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  801129:	55                   	push   %ebp
  80112a:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  80112c:	eb 09                	jmp    801137 <strncmp+0xe>
		n--, p++, q++;
  80112e:	ff 4d 10             	decl   0x10(%ebp)
  801131:	ff 45 08             	incl   0x8(%ebp)
  801134:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  801137:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80113b:	74 17                	je     801154 <strncmp+0x2b>
  80113d:	8b 45 08             	mov    0x8(%ebp),%eax
  801140:	8a 00                	mov    (%eax),%al
  801142:	84 c0                	test   %al,%al
  801144:	74 0e                	je     801154 <strncmp+0x2b>
  801146:	8b 45 08             	mov    0x8(%ebp),%eax
  801149:	8a 10                	mov    (%eax),%dl
  80114b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80114e:	8a 00                	mov    (%eax),%al
  801150:	38 c2                	cmp    %al,%dl
  801152:	74 da                	je     80112e <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  801154:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801158:	75 07                	jne    801161 <strncmp+0x38>
		return 0;
  80115a:	b8 00 00 00 00       	mov    $0x0,%eax
  80115f:	eb 14                	jmp    801175 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  801161:	8b 45 08             	mov    0x8(%ebp),%eax
  801164:	8a 00                	mov    (%eax),%al
  801166:	0f b6 d0             	movzbl %al,%edx
  801169:	8b 45 0c             	mov    0xc(%ebp),%eax
  80116c:	8a 00                	mov    (%eax),%al
  80116e:	0f b6 c0             	movzbl %al,%eax
  801171:	29 c2                	sub    %eax,%edx
  801173:	89 d0                	mov    %edx,%eax
}
  801175:	5d                   	pop    %ebp
  801176:	c3                   	ret    

00801177 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  801177:	55                   	push   %ebp
  801178:	89 e5                	mov    %esp,%ebp
  80117a:	83 ec 04             	sub    $0x4,%esp
  80117d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801180:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  801183:	eb 12                	jmp    801197 <strchr+0x20>
		if (*s == c)
  801185:	8b 45 08             	mov    0x8(%ebp),%eax
  801188:	8a 00                	mov    (%eax),%al
  80118a:	3a 45 fc             	cmp    -0x4(%ebp),%al
  80118d:	75 05                	jne    801194 <strchr+0x1d>
			return (char *) s;
  80118f:	8b 45 08             	mov    0x8(%ebp),%eax
  801192:	eb 11                	jmp    8011a5 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  801194:	ff 45 08             	incl   0x8(%ebp)
  801197:	8b 45 08             	mov    0x8(%ebp),%eax
  80119a:	8a 00                	mov    (%eax),%al
  80119c:	84 c0                	test   %al,%al
  80119e:	75 e5                	jne    801185 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  8011a0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8011a5:	c9                   	leave  
  8011a6:	c3                   	ret    

008011a7 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8011a7:	55                   	push   %ebp
  8011a8:	89 e5                	mov    %esp,%ebp
  8011aa:	83 ec 04             	sub    $0x4,%esp
  8011ad:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011b0:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  8011b3:	eb 0d                	jmp    8011c2 <strfind+0x1b>
		if (*s == c)
  8011b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8011b8:	8a 00                	mov    (%eax),%al
  8011ba:	3a 45 fc             	cmp    -0x4(%ebp),%al
  8011bd:	74 0e                	je     8011cd <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  8011bf:	ff 45 08             	incl   0x8(%ebp)
  8011c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8011c5:	8a 00                	mov    (%eax),%al
  8011c7:	84 c0                	test   %al,%al
  8011c9:	75 ea                	jne    8011b5 <strfind+0xe>
  8011cb:	eb 01                	jmp    8011ce <strfind+0x27>
		if (*s == c)
			break;
  8011cd:	90                   	nop
	return (char *) s;
  8011ce:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8011d1:	c9                   	leave  
  8011d2:	c3                   	ret    

008011d3 <memset>:

// *************** The faster implementation of memset & memcpy is implemented by *************
// ****************** Team80 (Yahia Khaled, Malek Ahmed et al) - FCIS'24-25 *******************
void *
memset(void *v, int c, uint32 n)
{
  8011d3:	55                   	push   %ebp
  8011d4:	89 e5                	mov    %esp,%ebp
  8011d6:	83 ec 10             	sub    $0x10,%esp
//	m = n;
//	while (--m >= 0)
//		*p++ = c;

	/*Faster Implementation*/
	uint64* p64 = (uint64*)v;
  8011d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8011dc:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if(n >= 8){
  8011df:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  8011e3:	76 63                	jbe    801248 <memset+0x75>
		uint64 data_block = c;
  8011e5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011e8:	99                   	cltd   
  8011e9:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8011ec:	89 55 f4             	mov    %edx,-0xc(%ebp)
		data_block |= data_block << 8;
  8011ef:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8011f2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8011f5:	0f a4 c2 08          	shld   $0x8,%eax,%edx
  8011f9:	c1 e0 08             	shl    $0x8,%eax
  8011fc:	09 45 f0             	or     %eax,-0x10(%ebp)
  8011ff:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 16;
  801202:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801205:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801208:	0f a4 c2 10          	shld   $0x10,%eax,%edx
  80120c:	c1 e0 10             	shl    $0x10,%eax
  80120f:	09 45 f0             	or     %eax,-0x10(%ebp)
  801212:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 32;
  801215:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801218:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80121b:	89 c2                	mov    %eax,%edx
  80121d:	b8 00 00 00 00       	mov    $0x0,%eax
  801222:	09 45 f0             	or     %eax,-0x10(%ebp)
  801225:	09 55 f4             	or     %edx,-0xc(%ebp)

		while(n >= 8)
  801228:	eb 18                	jmp    801242 <memset+0x6f>
			*p64++ = data_block, n -= 8;
  80122a:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  80122d:	8d 41 08             	lea    0x8(%ecx),%eax
  801230:	89 45 fc             	mov    %eax,-0x4(%ebp)
  801233:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801236:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801239:	89 01                	mov    %eax,(%ecx)
  80123b:	89 51 04             	mov    %edx,0x4(%ecx)
  80123e:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
		uint64 data_block = c;
		data_block |= data_block << 8;
		data_block |= data_block << 16;
		data_block |= data_block << 32;

		while(n >= 8)
  801242:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  801246:	77 e2                	ja     80122a <memset+0x57>
			*p64++ = data_block, n -= 8;
	}

	if(n){
  801248:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80124c:	74 23                	je     801271 <memset+0x9e>
		uint8* p8 = (uint8*)p64;
  80124e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801251:	89 45 f8             	mov    %eax,-0x8(%ebp)
		while (n-- > 0)
  801254:	eb 0e                	jmp    801264 <memset+0x91>
			*p8++ = (uint8)c;
  801256:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801259:	8d 50 01             	lea    0x1(%eax),%edx
  80125c:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80125f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801262:	88 10                	mov    %dl,(%eax)
			*p64++ = data_block, n -= 8;
	}

	if(n){
		uint8* p8 = (uint8*)p64;
		while (n-- > 0)
  801264:	8b 45 10             	mov    0x10(%ebp),%eax
  801267:	8d 50 ff             	lea    -0x1(%eax),%edx
  80126a:	89 55 10             	mov    %edx,0x10(%ebp)
  80126d:	85 c0                	test   %eax,%eax
  80126f:	75 e5                	jne    801256 <memset+0x83>
			*p8++ = (uint8)c;
	}

	return v;
  801271:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801274:	c9                   	leave  
  801275:	c3                   	ret    

00801276 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  801276:	55                   	push   %ebp
  801277:	89 e5                	mov    %esp,%ebp
  801279:	83 ec 10             	sub    $0x10,%esp
	//	s = src;
	//	d = dst;
	//	while (n-- > 0)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
  80127c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80127f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	uint64* d64 = (uint64*)dst;
  801282:	8b 45 08             	mov    0x8(%ebp),%eax
  801285:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if(n >= 8){
  801288:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  80128c:	76 24                	jbe    8012b2 <memcpy+0x3c>
		while(n >= 8){
  80128e:	eb 1c                	jmp    8012ac <memcpy+0x36>
			*d64 = *s64;
  801290:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801293:	8b 50 04             	mov    0x4(%eax),%edx
  801296:	8b 00                	mov    (%eax),%eax
  801298:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  80129b:	89 01                	mov    %eax,(%ecx)
  80129d:	89 51 04             	mov    %edx,0x4(%ecx)
			n -= 8;
  8012a0:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
			++s64;
  8012a4:	83 45 fc 08          	addl   $0x8,-0x4(%ebp)
			++d64;
  8012a8:	83 45 f8 08          	addl   $0x8,-0x8(%ebp)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
	uint64* d64 = (uint64*)dst;
	if(n >= 8){
		while(n >= 8){
  8012ac:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  8012b0:	77 de                	ja     801290 <memcpy+0x1a>
			++s64;
			++d64;
		}
	}

	if(n){
  8012b2:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8012b6:	74 31                	je     8012e9 <memcpy+0x73>
		uint8* s8 = (uint8*)s64;
  8012b8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8012bb:	89 45 f4             	mov    %eax,-0xc(%ebp)
		uint8* d8 = (uint8*)d64;
  8012be:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8012c1:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (n-- > 0)
  8012c4:	eb 16                	jmp    8012dc <memcpy+0x66>
			*d8++ = *s8++;
  8012c6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8012c9:	8d 50 01             	lea    0x1(%eax),%edx
  8012cc:	89 55 f0             	mov    %edx,-0x10(%ebp)
  8012cf:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8012d2:	8d 4a 01             	lea    0x1(%edx),%ecx
  8012d5:	89 4d f4             	mov    %ecx,-0xc(%ebp)
  8012d8:	8a 12                	mov    (%edx),%dl
  8012da:	88 10                	mov    %dl,(%eax)
	}

	if(n){
		uint8* s8 = (uint8*)s64;
		uint8* d8 = (uint8*)d64;
		while (n-- > 0)
  8012dc:	8b 45 10             	mov    0x10(%ebp),%eax
  8012df:	8d 50 ff             	lea    -0x1(%eax),%edx
  8012e2:	89 55 10             	mov    %edx,0x10(%ebp)
  8012e5:	85 c0                	test   %eax,%eax
  8012e7:	75 dd                	jne    8012c6 <memcpy+0x50>
			*d8++ = *s8++;
	}
	return dst;
  8012e9:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8012ec:	c9                   	leave  
  8012ed:	c3                   	ret    

008012ee <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  8012ee:	55                   	push   %ebp
  8012ef:	89 e5                	mov    %esp,%ebp
  8012f1:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  8012f4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012f7:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  8012fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8012fd:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  801300:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801303:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801306:	73 50                	jae    801358 <memmove+0x6a>
  801308:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80130b:	8b 45 10             	mov    0x10(%ebp),%eax
  80130e:	01 d0                	add    %edx,%eax
  801310:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801313:	76 43                	jbe    801358 <memmove+0x6a>
		s += n;
  801315:	8b 45 10             	mov    0x10(%ebp),%eax
  801318:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  80131b:	8b 45 10             	mov    0x10(%ebp),%eax
  80131e:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  801321:	eb 10                	jmp    801333 <memmove+0x45>
			*--d = *--s;
  801323:	ff 4d f8             	decl   -0x8(%ebp)
  801326:	ff 4d fc             	decl   -0x4(%ebp)
  801329:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80132c:	8a 10                	mov    (%eax),%dl
  80132e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801331:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  801333:	8b 45 10             	mov    0x10(%ebp),%eax
  801336:	8d 50 ff             	lea    -0x1(%eax),%edx
  801339:	89 55 10             	mov    %edx,0x10(%ebp)
  80133c:	85 c0                	test   %eax,%eax
  80133e:	75 e3                	jne    801323 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  801340:	eb 23                	jmp    801365 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  801342:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801345:	8d 50 01             	lea    0x1(%eax),%edx
  801348:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80134b:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80134e:	8d 4a 01             	lea    0x1(%edx),%ecx
  801351:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801354:	8a 12                	mov    (%edx),%dl
  801356:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  801358:	8b 45 10             	mov    0x10(%ebp),%eax
  80135b:	8d 50 ff             	lea    -0x1(%eax),%edx
  80135e:	89 55 10             	mov    %edx,0x10(%ebp)
  801361:	85 c0                	test   %eax,%eax
  801363:	75 dd                	jne    801342 <memmove+0x54>
			*d++ = *s++;

	return dst;
  801365:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801368:	c9                   	leave  
  801369:	c3                   	ret    

0080136a <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  80136a:	55                   	push   %ebp
  80136b:	89 e5                	mov    %esp,%ebp
  80136d:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  801370:	8b 45 08             	mov    0x8(%ebp),%eax
  801373:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  801376:	8b 45 0c             	mov    0xc(%ebp),%eax
  801379:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  80137c:	eb 2a                	jmp    8013a8 <memcmp+0x3e>
		if (*s1 != *s2)
  80137e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801381:	8a 10                	mov    (%eax),%dl
  801383:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801386:	8a 00                	mov    (%eax),%al
  801388:	38 c2                	cmp    %al,%dl
  80138a:	74 16                	je     8013a2 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  80138c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80138f:	8a 00                	mov    (%eax),%al
  801391:	0f b6 d0             	movzbl %al,%edx
  801394:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801397:	8a 00                	mov    (%eax),%al
  801399:	0f b6 c0             	movzbl %al,%eax
  80139c:	29 c2                	sub    %eax,%edx
  80139e:	89 d0                	mov    %edx,%eax
  8013a0:	eb 18                	jmp    8013ba <memcmp+0x50>
		s1++, s2++;
  8013a2:	ff 45 fc             	incl   -0x4(%ebp)
  8013a5:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  8013a8:	8b 45 10             	mov    0x10(%ebp),%eax
  8013ab:	8d 50 ff             	lea    -0x1(%eax),%edx
  8013ae:	89 55 10             	mov    %edx,0x10(%ebp)
  8013b1:	85 c0                	test   %eax,%eax
  8013b3:	75 c9                	jne    80137e <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  8013b5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8013ba:	c9                   	leave  
  8013bb:	c3                   	ret    

008013bc <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  8013bc:	55                   	push   %ebp
  8013bd:	89 e5                	mov    %esp,%ebp
  8013bf:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  8013c2:	8b 55 08             	mov    0x8(%ebp),%edx
  8013c5:	8b 45 10             	mov    0x10(%ebp),%eax
  8013c8:	01 d0                	add    %edx,%eax
  8013ca:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  8013cd:	eb 15                	jmp    8013e4 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  8013cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8013d2:	8a 00                	mov    (%eax),%al
  8013d4:	0f b6 d0             	movzbl %al,%edx
  8013d7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013da:	0f b6 c0             	movzbl %al,%eax
  8013dd:	39 c2                	cmp    %eax,%edx
  8013df:	74 0d                	je     8013ee <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  8013e1:	ff 45 08             	incl   0x8(%ebp)
  8013e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8013e7:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  8013ea:	72 e3                	jb     8013cf <memfind+0x13>
  8013ec:	eb 01                	jmp    8013ef <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  8013ee:	90                   	nop
	return (void *) s;
  8013ef:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8013f2:	c9                   	leave  
  8013f3:	c3                   	ret    

008013f4 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  8013f4:	55                   	push   %ebp
  8013f5:	89 e5                	mov    %esp,%ebp
  8013f7:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  8013fa:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  801401:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801408:	eb 03                	jmp    80140d <strtol+0x19>
		s++;
  80140a:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80140d:	8b 45 08             	mov    0x8(%ebp),%eax
  801410:	8a 00                	mov    (%eax),%al
  801412:	3c 20                	cmp    $0x20,%al
  801414:	74 f4                	je     80140a <strtol+0x16>
  801416:	8b 45 08             	mov    0x8(%ebp),%eax
  801419:	8a 00                	mov    (%eax),%al
  80141b:	3c 09                	cmp    $0x9,%al
  80141d:	74 eb                	je     80140a <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  80141f:	8b 45 08             	mov    0x8(%ebp),%eax
  801422:	8a 00                	mov    (%eax),%al
  801424:	3c 2b                	cmp    $0x2b,%al
  801426:	75 05                	jne    80142d <strtol+0x39>
		s++;
  801428:	ff 45 08             	incl   0x8(%ebp)
  80142b:	eb 13                	jmp    801440 <strtol+0x4c>
	else if (*s == '-')
  80142d:	8b 45 08             	mov    0x8(%ebp),%eax
  801430:	8a 00                	mov    (%eax),%al
  801432:	3c 2d                	cmp    $0x2d,%al
  801434:	75 0a                	jne    801440 <strtol+0x4c>
		s++, neg = 1;
  801436:	ff 45 08             	incl   0x8(%ebp)
  801439:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801440:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801444:	74 06                	je     80144c <strtol+0x58>
  801446:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  80144a:	75 20                	jne    80146c <strtol+0x78>
  80144c:	8b 45 08             	mov    0x8(%ebp),%eax
  80144f:	8a 00                	mov    (%eax),%al
  801451:	3c 30                	cmp    $0x30,%al
  801453:	75 17                	jne    80146c <strtol+0x78>
  801455:	8b 45 08             	mov    0x8(%ebp),%eax
  801458:	40                   	inc    %eax
  801459:	8a 00                	mov    (%eax),%al
  80145b:	3c 78                	cmp    $0x78,%al
  80145d:	75 0d                	jne    80146c <strtol+0x78>
		s += 2, base = 16;
  80145f:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  801463:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  80146a:	eb 28                	jmp    801494 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  80146c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801470:	75 15                	jne    801487 <strtol+0x93>
  801472:	8b 45 08             	mov    0x8(%ebp),%eax
  801475:	8a 00                	mov    (%eax),%al
  801477:	3c 30                	cmp    $0x30,%al
  801479:	75 0c                	jne    801487 <strtol+0x93>
		s++, base = 8;
  80147b:	ff 45 08             	incl   0x8(%ebp)
  80147e:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  801485:	eb 0d                	jmp    801494 <strtol+0xa0>
	else if (base == 0)
  801487:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80148b:	75 07                	jne    801494 <strtol+0xa0>
		base = 10;
  80148d:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801494:	8b 45 08             	mov    0x8(%ebp),%eax
  801497:	8a 00                	mov    (%eax),%al
  801499:	3c 2f                	cmp    $0x2f,%al
  80149b:	7e 19                	jle    8014b6 <strtol+0xc2>
  80149d:	8b 45 08             	mov    0x8(%ebp),%eax
  8014a0:	8a 00                	mov    (%eax),%al
  8014a2:	3c 39                	cmp    $0x39,%al
  8014a4:	7f 10                	jg     8014b6 <strtol+0xc2>
			dig = *s - '0';
  8014a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8014a9:	8a 00                	mov    (%eax),%al
  8014ab:	0f be c0             	movsbl %al,%eax
  8014ae:	83 e8 30             	sub    $0x30,%eax
  8014b1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8014b4:	eb 42                	jmp    8014f8 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  8014b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8014b9:	8a 00                	mov    (%eax),%al
  8014bb:	3c 60                	cmp    $0x60,%al
  8014bd:	7e 19                	jle    8014d8 <strtol+0xe4>
  8014bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8014c2:	8a 00                	mov    (%eax),%al
  8014c4:	3c 7a                	cmp    $0x7a,%al
  8014c6:	7f 10                	jg     8014d8 <strtol+0xe4>
			dig = *s - 'a' + 10;
  8014c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8014cb:	8a 00                	mov    (%eax),%al
  8014cd:	0f be c0             	movsbl %al,%eax
  8014d0:	83 e8 57             	sub    $0x57,%eax
  8014d3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8014d6:	eb 20                	jmp    8014f8 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  8014d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8014db:	8a 00                	mov    (%eax),%al
  8014dd:	3c 40                	cmp    $0x40,%al
  8014df:	7e 39                	jle    80151a <strtol+0x126>
  8014e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8014e4:	8a 00                	mov    (%eax),%al
  8014e6:	3c 5a                	cmp    $0x5a,%al
  8014e8:	7f 30                	jg     80151a <strtol+0x126>
			dig = *s - 'A' + 10;
  8014ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8014ed:	8a 00                	mov    (%eax),%al
  8014ef:	0f be c0             	movsbl %al,%eax
  8014f2:	83 e8 37             	sub    $0x37,%eax
  8014f5:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  8014f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8014fb:	3b 45 10             	cmp    0x10(%ebp),%eax
  8014fe:	7d 19                	jge    801519 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801500:	ff 45 08             	incl   0x8(%ebp)
  801503:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801506:	0f af 45 10          	imul   0x10(%ebp),%eax
  80150a:	89 c2                	mov    %eax,%edx
  80150c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80150f:	01 d0                	add    %edx,%eax
  801511:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  801514:	e9 7b ff ff ff       	jmp    801494 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801519:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  80151a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80151e:	74 08                	je     801528 <strtol+0x134>
		*endptr = (char *) s;
  801520:	8b 45 0c             	mov    0xc(%ebp),%eax
  801523:	8b 55 08             	mov    0x8(%ebp),%edx
  801526:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  801528:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80152c:	74 07                	je     801535 <strtol+0x141>
  80152e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801531:	f7 d8                	neg    %eax
  801533:	eb 03                	jmp    801538 <strtol+0x144>
  801535:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801538:	c9                   	leave  
  801539:	c3                   	ret    

0080153a <ltostr>:

void
ltostr(long value, char *str)
{
  80153a:	55                   	push   %ebp
  80153b:	89 e5                	mov    %esp,%ebp
  80153d:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  801540:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  801547:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  80154e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801552:	79 13                	jns    801567 <ltostr+0x2d>
	{
		neg = 1;
  801554:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  80155b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80155e:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  801561:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  801564:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  801567:	8b 45 08             	mov    0x8(%ebp),%eax
  80156a:	b9 0a 00 00 00       	mov    $0xa,%ecx
  80156f:	99                   	cltd   
  801570:	f7 f9                	idiv   %ecx
  801572:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  801575:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801578:	8d 50 01             	lea    0x1(%eax),%edx
  80157b:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80157e:	89 c2                	mov    %eax,%edx
  801580:	8b 45 0c             	mov    0xc(%ebp),%eax
  801583:	01 d0                	add    %edx,%eax
  801585:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801588:	83 c2 30             	add    $0x30,%edx
  80158b:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  80158d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801590:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801595:	f7 e9                	imul   %ecx
  801597:	c1 fa 02             	sar    $0x2,%edx
  80159a:	89 c8                	mov    %ecx,%eax
  80159c:	c1 f8 1f             	sar    $0x1f,%eax
  80159f:	29 c2                	sub    %eax,%edx
  8015a1:	89 d0                	mov    %edx,%eax
  8015a3:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  8015a6:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8015aa:	75 bb                	jne    801567 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  8015ac:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  8015b3:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8015b6:	48                   	dec    %eax
  8015b7:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  8015ba:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8015be:	74 3d                	je     8015fd <ltostr+0xc3>
		start = 1 ;
  8015c0:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  8015c7:	eb 34                	jmp    8015fd <ltostr+0xc3>
	{
		char tmp = str[start] ;
  8015c9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8015cc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015cf:	01 d0                	add    %edx,%eax
  8015d1:	8a 00                	mov    (%eax),%al
  8015d3:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  8015d6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8015d9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015dc:	01 c2                	add    %eax,%edx
  8015de:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  8015e1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015e4:	01 c8                	add    %ecx,%eax
  8015e6:	8a 00                	mov    (%eax),%al
  8015e8:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  8015ea:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8015ed:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015f0:	01 c2                	add    %eax,%edx
  8015f2:	8a 45 eb             	mov    -0x15(%ebp),%al
  8015f5:	88 02                	mov    %al,(%edx)
		start++ ;
  8015f7:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  8015fa:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  8015fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801600:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801603:	7c c4                	jl     8015c9 <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801605:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801608:	8b 45 0c             	mov    0xc(%ebp),%eax
  80160b:	01 d0                	add    %edx,%eax
  80160d:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801610:	90                   	nop
  801611:	c9                   	leave  
  801612:	c3                   	ret    

00801613 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  801613:	55                   	push   %ebp
  801614:	89 e5                	mov    %esp,%ebp
  801616:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801619:	ff 75 08             	pushl  0x8(%ebp)
  80161c:	e8 c4 f9 ff ff       	call   800fe5 <strlen>
  801621:	83 c4 04             	add    $0x4,%esp
  801624:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  801627:	ff 75 0c             	pushl  0xc(%ebp)
  80162a:	e8 b6 f9 ff ff       	call   800fe5 <strlen>
  80162f:	83 c4 04             	add    $0x4,%esp
  801632:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  801635:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  80163c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801643:	eb 17                	jmp    80165c <strcconcat+0x49>
		final[s] = str1[s] ;
  801645:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801648:	8b 45 10             	mov    0x10(%ebp),%eax
  80164b:	01 c2                	add    %eax,%edx
  80164d:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801650:	8b 45 08             	mov    0x8(%ebp),%eax
  801653:	01 c8                	add    %ecx,%eax
  801655:	8a 00                	mov    (%eax),%al
  801657:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  801659:	ff 45 fc             	incl   -0x4(%ebp)
  80165c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80165f:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801662:	7c e1                	jl     801645 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  801664:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  80166b:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  801672:	eb 1f                	jmp    801693 <strcconcat+0x80>
		final[s++] = str2[i] ;
  801674:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801677:	8d 50 01             	lea    0x1(%eax),%edx
  80167a:	89 55 fc             	mov    %edx,-0x4(%ebp)
  80167d:	89 c2                	mov    %eax,%edx
  80167f:	8b 45 10             	mov    0x10(%ebp),%eax
  801682:	01 c2                	add    %eax,%edx
  801684:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801687:	8b 45 0c             	mov    0xc(%ebp),%eax
  80168a:	01 c8                	add    %ecx,%eax
  80168c:	8a 00                	mov    (%eax),%al
  80168e:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801690:	ff 45 f8             	incl   -0x8(%ebp)
  801693:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801696:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801699:	7c d9                	jl     801674 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  80169b:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80169e:	8b 45 10             	mov    0x10(%ebp),%eax
  8016a1:	01 d0                	add    %edx,%eax
  8016a3:	c6 00 00             	movb   $0x0,(%eax)
}
  8016a6:	90                   	nop
  8016a7:	c9                   	leave  
  8016a8:	c3                   	ret    

008016a9 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  8016a9:	55                   	push   %ebp
  8016aa:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  8016ac:	8b 45 14             	mov    0x14(%ebp),%eax
  8016af:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  8016b5:	8b 45 14             	mov    0x14(%ebp),%eax
  8016b8:	8b 00                	mov    (%eax),%eax
  8016ba:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8016c1:	8b 45 10             	mov    0x10(%ebp),%eax
  8016c4:	01 d0                	add    %edx,%eax
  8016c6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8016cc:	eb 0c                	jmp    8016da <strsplit+0x31>
			*string++ = 0;
  8016ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8016d1:	8d 50 01             	lea    0x1(%eax),%edx
  8016d4:	89 55 08             	mov    %edx,0x8(%ebp)
  8016d7:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8016da:	8b 45 08             	mov    0x8(%ebp),%eax
  8016dd:	8a 00                	mov    (%eax),%al
  8016df:	84 c0                	test   %al,%al
  8016e1:	74 18                	je     8016fb <strsplit+0x52>
  8016e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8016e6:	8a 00                	mov    (%eax),%al
  8016e8:	0f be c0             	movsbl %al,%eax
  8016eb:	50                   	push   %eax
  8016ec:	ff 75 0c             	pushl  0xc(%ebp)
  8016ef:	e8 83 fa ff ff       	call   801177 <strchr>
  8016f4:	83 c4 08             	add    $0x8,%esp
  8016f7:	85 c0                	test   %eax,%eax
  8016f9:	75 d3                	jne    8016ce <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  8016fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8016fe:	8a 00                	mov    (%eax),%al
  801700:	84 c0                	test   %al,%al
  801702:	74 5a                	je     80175e <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801704:	8b 45 14             	mov    0x14(%ebp),%eax
  801707:	8b 00                	mov    (%eax),%eax
  801709:	83 f8 0f             	cmp    $0xf,%eax
  80170c:	75 07                	jne    801715 <strsplit+0x6c>
		{
			return 0;
  80170e:	b8 00 00 00 00       	mov    $0x0,%eax
  801713:	eb 66                	jmp    80177b <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801715:	8b 45 14             	mov    0x14(%ebp),%eax
  801718:	8b 00                	mov    (%eax),%eax
  80171a:	8d 48 01             	lea    0x1(%eax),%ecx
  80171d:	8b 55 14             	mov    0x14(%ebp),%edx
  801720:	89 0a                	mov    %ecx,(%edx)
  801722:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801729:	8b 45 10             	mov    0x10(%ebp),%eax
  80172c:	01 c2                	add    %eax,%edx
  80172e:	8b 45 08             	mov    0x8(%ebp),%eax
  801731:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801733:	eb 03                	jmp    801738 <strsplit+0x8f>
			string++;
  801735:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801738:	8b 45 08             	mov    0x8(%ebp),%eax
  80173b:	8a 00                	mov    (%eax),%al
  80173d:	84 c0                	test   %al,%al
  80173f:	74 8b                	je     8016cc <strsplit+0x23>
  801741:	8b 45 08             	mov    0x8(%ebp),%eax
  801744:	8a 00                	mov    (%eax),%al
  801746:	0f be c0             	movsbl %al,%eax
  801749:	50                   	push   %eax
  80174a:	ff 75 0c             	pushl  0xc(%ebp)
  80174d:	e8 25 fa ff ff       	call   801177 <strchr>
  801752:	83 c4 08             	add    $0x8,%esp
  801755:	85 c0                	test   %eax,%eax
  801757:	74 dc                	je     801735 <strsplit+0x8c>
			string++;
	}
  801759:	e9 6e ff ff ff       	jmp    8016cc <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  80175e:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  80175f:	8b 45 14             	mov    0x14(%ebp),%eax
  801762:	8b 00                	mov    (%eax),%eax
  801764:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80176b:	8b 45 10             	mov    0x10(%ebp),%eax
  80176e:	01 d0                	add    %edx,%eax
  801770:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801776:	b8 01 00 00 00       	mov    $0x1,%eax
}
  80177b:	c9                   	leave  
  80177c:	c3                   	ret    

0080177d <str2lower>:


char* str2lower(char *dst, const char *src)
{
  80177d:	55                   	push   %ebp
  80177e:	89 e5                	mov    %esp,%ebp
  801780:	83 ec 10             	sub    $0x10,%esp
	char* ret = dst;
  801783:	8b 45 08             	mov    0x8(%ebp),%eax
  801786:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (int i = 0; i < strlen(src); ++i)
  801789:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801790:	eb 4a                	jmp    8017dc <str2lower+0x5f>
	{
		dst[i] = src[i] ;
  801792:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801795:	8b 45 08             	mov    0x8(%ebp),%eax
  801798:	01 c2                	add    %eax,%edx
  80179a:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  80179d:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017a0:	01 c8                	add    %ecx,%eax
  8017a2:	8a 00                	mov    (%eax),%al
  8017a4:	88 02                	mov    %al,(%edx)
		if (src[i] >= 'A' && src[i] <= 'Z')
  8017a6:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8017a9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017ac:	01 d0                	add    %edx,%eax
  8017ae:	8a 00                	mov    (%eax),%al
  8017b0:	3c 40                	cmp    $0x40,%al
  8017b2:	7e 25                	jle    8017d9 <str2lower+0x5c>
  8017b4:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8017b7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017ba:	01 d0                	add    %edx,%eax
  8017bc:	8a 00                	mov    (%eax),%al
  8017be:	3c 5a                	cmp    $0x5a,%al
  8017c0:	7f 17                	jg     8017d9 <str2lower+0x5c>
		{
			dst[i] += 32 ;
  8017c2:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8017c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8017c8:	01 d0                	add    %edx,%eax
  8017ca:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8017cd:	8b 55 08             	mov    0x8(%ebp),%edx
  8017d0:	01 ca                	add    %ecx,%edx
  8017d2:	8a 12                	mov    (%edx),%dl
  8017d4:	83 c2 20             	add    $0x20,%edx
  8017d7:	88 10                	mov    %dl,(%eax)


char* str2lower(char *dst, const char *src)
{
	char* ret = dst;
	for (int i = 0; i < strlen(src); ++i)
  8017d9:	ff 45 fc             	incl   -0x4(%ebp)
  8017dc:	ff 75 0c             	pushl  0xc(%ebp)
  8017df:	e8 01 f8 ff ff       	call   800fe5 <strlen>
  8017e4:	83 c4 04             	add    $0x4,%esp
  8017e7:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  8017ea:	7f a6                	jg     801792 <str2lower+0x15>
		if (src[i] >= 'A' && src[i] <= 'Z')
		{
			dst[i] += 32 ;
		}
	}
	return ret;
  8017ec:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8017ef:	c9                   	leave  
  8017f0:	c3                   	ret    

008017f1 <uheap_init>:
//==============================================
// [1] INITIALIZE USER HEAP:
//==============================================
int __firstTimeFlag = 1;
void uheap_init()
{
  8017f1:	55                   	push   %ebp
  8017f2:	89 e5                	mov    %esp,%ebp
  8017f4:	83 ec 08             	sub    $0x8,%esp
	if(__firstTimeFlag)
  8017f7:	a1 08 40 80 00       	mov    0x804008,%eax
  8017fc:	85 c0                	test   %eax,%eax
  8017fe:	74 42                	je     801842 <uheap_init+0x51>
	{
		initialize_dynamic_allocator(USER_HEAP_START, USER_HEAP_START + DYN_ALLOC_MAX_SIZE);
  801800:	83 ec 08             	sub    $0x8,%esp
  801803:	68 00 00 00 82       	push   $0x82000000
  801808:	68 00 00 00 80       	push   $0x80000000
  80180d:	e8 00 08 00 00       	call   802012 <initialize_dynamic_allocator>
  801812:	83 c4 10             	add    $0x10,%esp
		uheapPlaceStrategy = sys_get_uheap_strategy();
  801815:	e8 e7 05 00 00       	call   801e01 <sys_get_uheap_strategy>
  80181a:	a3 60 c0 81 00       	mov    %eax,0x81c060
		uheapPageAllocStart = dynAllocEnd + PAGE_SIZE;
  80181f:	a1 40 40 80 00       	mov    0x804040,%eax
  801824:	05 00 10 00 00       	add    $0x1000,%eax
  801829:	a3 10 c1 81 00       	mov    %eax,0x81c110
		uheapPageAllocBreak = uheapPageAllocStart;
  80182e:	a1 10 c1 81 00       	mov    0x81c110,%eax
  801833:	a3 68 c0 81 00       	mov    %eax,0x81c068

		__firstTimeFlag = 0;
  801838:	c7 05 08 40 80 00 00 	movl   $0x0,0x804008
  80183f:	00 00 00 
	}
}
  801842:	90                   	nop
  801843:	c9                   	leave  
  801844:	c3                   	ret    

00801845 <get_page>:

//==============================================
// [2] GET A PAGE FROM THE KERNEL FOR DA:
//==============================================
int get_page(void* va)
{
  801845:	55                   	push   %ebp
  801846:	89 e5                	mov    %esp,%ebp
  801848:	83 ec 18             	sub    $0x18,%esp
	int ret = __sys_allocate_page(ROUNDDOWN(va, PAGE_SIZE), PERM_USER|PERM_WRITEABLE|PERM_UHPAGE);
  80184b:	8b 45 08             	mov    0x8(%ebp),%eax
  80184e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801851:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801854:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801859:	83 ec 08             	sub    $0x8,%esp
  80185c:	68 06 04 00 00       	push   $0x406
  801861:	50                   	push   %eax
  801862:	e8 e4 01 00 00       	call   801a4b <__sys_allocate_page>
  801867:	83 c4 10             	add    $0x10,%esp
  80186a:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (ret < 0)
  80186d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801871:	79 14                	jns    801887 <get_page+0x42>
		panic("get_page() in user: failed to allocate page from the kernel");
  801873:	83 ec 04             	sub    $0x4,%esp
  801876:	68 28 36 80 00       	push   $0x803628
  80187b:	6a 1f                	push   $0x1f
  80187d:	68 64 36 80 00       	push   $0x803664
  801882:	e8 e5 11 00 00       	call   802a6c <_panic>
	return 0;
  801887:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80188c:	c9                   	leave  
  80188d:	c3                   	ret    

0080188e <return_page>:

//==============================================
// [3] RETURN A PAGE FROM THE DA TO KERNEL:
//==============================================
void return_page(void* va)
{
  80188e:	55                   	push   %ebp
  80188f:	89 e5                	mov    %esp,%ebp
  801891:	83 ec 18             	sub    $0x18,%esp
	int ret = __sys_unmap_frame(ROUNDDOWN((uint32)va, PAGE_SIZE));
  801894:	8b 45 08             	mov    0x8(%ebp),%eax
  801897:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80189a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80189d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8018a2:	83 ec 0c             	sub    $0xc,%esp
  8018a5:	50                   	push   %eax
  8018a6:	e8 e7 01 00 00       	call   801a92 <__sys_unmap_frame>
  8018ab:	83 c4 10             	add    $0x10,%esp
  8018ae:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (ret < 0)
  8018b1:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8018b5:	79 14                	jns    8018cb <return_page+0x3d>
		panic("return_page() in user: failed to return a page to the kernel");
  8018b7:	83 ec 04             	sub    $0x4,%esp
  8018ba:	68 70 36 80 00       	push   $0x803670
  8018bf:	6a 2a                	push   $0x2a
  8018c1:	68 64 36 80 00       	push   $0x803664
  8018c6:	e8 a1 11 00 00       	call   802a6c <_panic>
}
  8018cb:	90                   	nop
  8018cc:	c9                   	leave  
  8018cd:	c3                   	ret    

008018ce <malloc>:

//=================================
// [1] ALLOCATE SPACE IN USER HEAP:
//=================================
void* malloc(uint32 size)
{
  8018ce:	55                   	push   %ebp
  8018cf:	89 e5                	mov    %esp,%ebp
  8018d1:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  8018d4:	e8 18 ff ff ff       	call   8017f1 <uheap_init>
	if (size == 0) return NULL ;
  8018d9:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8018dd:	75 07                	jne    8018e6 <malloc+0x18>
  8018df:	b8 00 00 00 00       	mov    $0x0,%eax
  8018e4:	eb 14                	jmp    8018fa <malloc+0x2c>
	//==============================================================
	//TODO: [PROJECT'25.IM#2] USER HEAP - #1 malloc
	//Your code is here
	//Comment the following line
	panic("malloc() is not implemented yet...!!");
  8018e6:	83 ec 04             	sub    $0x4,%esp
  8018e9:	68 b0 36 80 00       	push   $0x8036b0
  8018ee:	6a 3e                	push   $0x3e
  8018f0:	68 64 36 80 00       	push   $0x803664
  8018f5:	e8 72 11 00 00       	call   802a6c <_panic>
}
  8018fa:	c9                   	leave  
  8018fb:	c3                   	ret    

008018fc <free>:

//=================================
// [2] FREE SPACE FROM USER HEAP:
//=================================
void free(void* virtual_address)
{
  8018fc:	55                   	push   %ebp
  8018fd:	89 e5                	mov    %esp,%ebp
  8018ff:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.IM#2] USER HEAP - #3 free
	//Your code is here
	//Comment the following line
	panic("free() is not implemented yet...!!");
  801902:	83 ec 04             	sub    $0x4,%esp
  801905:	68 d8 36 80 00       	push   $0x8036d8
  80190a:	6a 49                	push   $0x49
  80190c:	68 64 36 80 00       	push   $0x803664
  801911:	e8 56 11 00 00       	call   802a6c <_panic>

00801916 <smalloc>:

//=================================
// [3] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  801916:	55                   	push   %ebp
  801917:	89 e5                	mov    %esp,%ebp
  801919:	83 ec 18             	sub    $0x18,%esp
  80191c:	8b 45 10             	mov    0x10(%ebp),%eax
  80191f:	88 45 f4             	mov    %al,-0xc(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  801922:	e8 ca fe ff ff       	call   8017f1 <uheap_init>
	if (size == 0) return NULL ;
  801927:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80192b:	75 07                	jne    801934 <smalloc+0x1e>
  80192d:	b8 00 00 00 00       	mov    $0x0,%eax
  801932:	eb 14                	jmp    801948 <smalloc+0x32>
	//==============================================================

	//TODO: [PROJECT'25.IM#3] SHARED MEMORY - #2 smalloc
	//Your code is here
	//Comment the following line
	panic("smalloc() is not implemented yet...!!");
  801934:	83 ec 04             	sub    $0x4,%esp
  801937:	68 fc 36 80 00       	push   $0x8036fc
  80193c:	6a 5a                	push   $0x5a
  80193e:	68 64 36 80 00       	push   $0x803664
  801943:	e8 24 11 00 00       	call   802a6c <_panic>
}
  801948:	c9                   	leave  
  801949:	c3                   	ret    

0080194a <sget>:

//========================================
// [4] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  80194a:	55                   	push   %ebp
  80194b:	89 e5                	mov    %esp,%ebp
  80194d:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  801950:	e8 9c fe ff ff       	call   8017f1 <uheap_init>
	//==============================================================

	//TODO: [PROJECT'25.IM#3] SHARED MEMORY - #4 sget
	//Your code is here
	//Comment the following line
	panic("sget() is not implemented yet...!!");
  801955:	83 ec 04             	sub    $0x4,%esp
  801958:	68 24 37 80 00       	push   $0x803724
  80195d:	6a 6a                	push   $0x6a
  80195f:	68 64 36 80 00       	push   $0x803664
  801964:	e8 03 11 00 00       	call   802a6c <_panic>

00801969 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801969:	55                   	push   %ebp
  80196a:	89 e5                	mov    %esp,%ebp
  80196c:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  80196f:	e8 7d fe ff ff       	call   8017f1 <uheap_init>
	//==============================================================
	panic("realloc() is not implemented yet...!!");
  801974:	83 ec 04             	sub    $0x4,%esp
  801977:	68 48 37 80 00       	push   $0x803748
  80197c:	68 88 00 00 00       	push   $0x88
  801981:	68 64 36 80 00       	push   $0x803664
  801986:	e8 e1 10 00 00       	call   802a6c <_panic>

0080198b <sfree>:
//
//	use sys_delete_shared_object(...); which switches to the kernel mode,
//	calls delete_shared_object(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the delete_shared_object() function is empty, make sure to implement it.
void sfree(void* virtual_address)
{
  80198b:	55                   	push   %ebp
  80198c:	89 e5                	mov    %esp,%ebp
  80198e:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.BONUS#5] EXIT #2 - sfree
	//Your code is here
	//Comment the following line
	panic("sfree() is not implemented yet...!!");
  801991:	83 ec 04             	sub    $0x4,%esp
  801994:	68 70 37 80 00       	push   $0x803770
  801999:	68 9b 00 00 00       	push   $0x9b
  80199e:	68 64 36 80 00       	push   $0x803664
  8019a3:	e8 c4 10 00 00       	call   802a6c <_panic>

008019a8 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  8019a8:	55                   	push   %ebp
  8019a9:	89 e5                	mov    %esp,%ebp
  8019ab:	57                   	push   %edi
  8019ac:	56                   	push   %esi
  8019ad:	53                   	push   %ebx
  8019ae:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8019b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8019b4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019b7:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8019ba:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8019bd:	8b 7d 18             	mov    0x18(%ebp),%edi
  8019c0:	8b 75 1c             	mov    0x1c(%ebp),%esi
  8019c3:	cd 30                	int    $0x30
  8019c5:	89 45 f0             	mov    %eax,-0x10(%ebp)
				"b" (a3),
				"D" (a4),
				"S" (a5)
				: "cc", "memory");

	return ret;
  8019c8:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8019cb:	83 c4 10             	add    $0x10,%esp
  8019ce:	5b                   	pop    %ebx
  8019cf:	5e                   	pop    %esi
  8019d0:	5f                   	pop    %edi
  8019d1:	5d                   	pop    %ebp
  8019d2:	c3                   	ret    

008019d3 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName, int color)
{
  8019d3:	55                   	push   %ebp
  8019d4:	89 e5                	mov    %esp,%ebp
  8019d6:	83 ec 04             	sub    $0x4,%esp
  8019d9:	8b 45 10             	mov    0x10(%ebp),%eax
  8019dc:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, color, 0);
  8019df:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8019e2:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8019e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8019e9:	6a 00                	push   $0x0
  8019eb:	51                   	push   %ecx
  8019ec:	52                   	push   %edx
  8019ed:	ff 75 0c             	pushl  0xc(%ebp)
  8019f0:	50                   	push   %eax
  8019f1:	6a 00                	push   $0x0
  8019f3:	e8 b0 ff ff ff       	call   8019a8 <syscall>
  8019f8:	83 c4 18             	add    $0x18,%esp
}
  8019fb:	90                   	nop
  8019fc:	c9                   	leave  
  8019fd:	c3                   	ret    

008019fe <sys_cgetc>:

int
sys_cgetc(void)
{
  8019fe:	55                   	push   %ebp
  8019ff:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801a01:	6a 00                	push   $0x0
  801a03:	6a 00                	push   $0x0
  801a05:	6a 00                	push   $0x0
  801a07:	6a 00                	push   $0x0
  801a09:	6a 00                	push   $0x0
  801a0b:	6a 02                	push   $0x2
  801a0d:	e8 96 ff ff ff       	call   8019a8 <syscall>
  801a12:	83 c4 18             	add    $0x18,%esp
}
  801a15:	c9                   	leave  
  801a16:	c3                   	ret    

00801a17 <sys_lock_cons>:

void sys_lock_cons(void)
{
  801a17:	55                   	push   %ebp
  801a18:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  801a1a:	6a 00                	push   $0x0
  801a1c:	6a 00                	push   $0x0
  801a1e:	6a 00                	push   $0x0
  801a20:	6a 00                	push   $0x0
  801a22:	6a 00                	push   $0x0
  801a24:	6a 03                	push   $0x3
  801a26:	e8 7d ff ff ff       	call   8019a8 <syscall>
  801a2b:	83 c4 18             	add    $0x18,%esp
}
  801a2e:	90                   	nop
  801a2f:	c9                   	leave  
  801a30:	c3                   	ret    

00801a31 <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  801a31:	55                   	push   %ebp
  801a32:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  801a34:	6a 00                	push   $0x0
  801a36:	6a 00                	push   $0x0
  801a38:	6a 00                	push   $0x0
  801a3a:	6a 00                	push   $0x0
  801a3c:	6a 00                	push   $0x0
  801a3e:	6a 04                	push   $0x4
  801a40:	e8 63 ff ff ff       	call   8019a8 <syscall>
  801a45:	83 c4 18             	add    $0x18,%esp
}
  801a48:	90                   	nop
  801a49:	c9                   	leave  
  801a4a:	c3                   	ret    

00801a4b <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801a4b:	55                   	push   %ebp
  801a4c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801a4e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a51:	8b 45 08             	mov    0x8(%ebp),%eax
  801a54:	6a 00                	push   $0x0
  801a56:	6a 00                	push   $0x0
  801a58:	6a 00                	push   $0x0
  801a5a:	52                   	push   %edx
  801a5b:	50                   	push   %eax
  801a5c:	6a 08                	push   $0x8
  801a5e:	e8 45 ff ff ff       	call   8019a8 <syscall>
  801a63:	83 c4 18             	add    $0x18,%esp
}
  801a66:	c9                   	leave  
  801a67:	c3                   	ret    

00801a68 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801a68:	55                   	push   %ebp
  801a69:	89 e5                	mov    %esp,%ebp
  801a6b:	56                   	push   %esi
  801a6c:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801a6d:	8b 75 18             	mov    0x18(%ebp),%esi
  801a70:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801a73:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801a76:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a79:	8b 45 08             	mov    0x8(%ebp),%eax
  801a7c:	56                   	push   %esi
  801a7d:	53                   	push   %ebx
  801a7e:	51                   	push   %ecx
  801a7f:	52                   	push   %edx
  801a80:	50                   	push   %eax
  801a81:	6a 09                	push   $0x9
  801a83:	e8 20 ff ff ff       	call   8019a8 <syscall>
  801a88:	83 c4 18             	add    $0x18,%esp
}
  801a8b:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801a8e:	5b                   	pop    %ebx
  801a8f:	5e                   	pop    %esi
  801a90:	5d                   	pop    %ebp
  801a91:	c3                   	ret    

00801a92 <__sys_unmap_frame>:

int __sys_unmap_frame(uint32 va)
{
  801a92:	55                   	push   %ebp
  801a93:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, va, 0, 0, 0, 0);
  801a95:	6a 00                	push   $0x0
  801a97:	6a 00                	push   $0x0
  801a99:	6a 00                	push   $0x0
  801a9b:	6a 00                	push   $0x0
  801a9d:	ff 75 08             	pushl  0x8(%ebp)
  801aa0:	6a 0a                	push   $0xa
  801aa2:	e8 01 ff ff ff       	call   8019a8 <syscall>
  801aa7:	83 c4 18             	add    $0x18,%esp
}
  801aaa:	c9                   	leave  
  801aab:	c3                   	ret    

00801aac <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801aac:	55                   	push   %ebp
  801aad:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801aaf:	6a 00                	push   $0x0
  801ab1:	6a 00                	push   $0x0
  801ab3:	6a 00                	push   $0x0
  801ab5:	ff 75 0c             	pushl  0xc(%ebp)
  801ab8:	ff 75 08             	pushl  0x8(%ebp)
  801abb:	6a 0b                	push   $0xb
  801abd:	e8 e6 fe ff ff       	call   8019a8 <syscall>
  801ac2:	83 c4 18             	add    $0x18,%esp
}
  801ac5:	c9                   	leave  
  801ac6:	c3                   	ret    

00801ac7 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801ac7:	55                   	push   %ebp
  801ac8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801aca:	6a 00                	push   $0x0
  801acc:	6a 00                	push   $0x0
  801ace:	6a 00                	push   $0x0
  801ad0:	6a 00                	push   $0x0
  801ad2:	6a 00                	push   $0x0
  801ad4:	6a 0c                	push   $0xc
  801ad6:	e8 cd fe ff ff       	call   8019a8 <syscall>
  801adb:	83 c4 18             	add    $0x18,%esp
}
  801ade:	c9                   	leave  
  801adf:	c3                   	ret    

00801ae0 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801ae0:	55                   	push   %ebp
  801ae1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801ae3:	6a 00                	push   $0x0
  801ae5:	6a 00                	push   $0x0
  801ae7:	6a 00                	push   $0x0
  801ae9:	6a 00                	push   $0x0
  801aeb:	6a 00                	push   $0x0
  801aed:	6a 0d                	push   $0xd
  801aef:	e8 b4 fe ff ff       	call   8019a8 <syscall>
  801af4:	83 c4 18             	add    $0x18,%esp
}
  801af7:	c9                   	leave  
  801af8:	c3                   	ret    

00801af9 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801af9:	55                   	push   %ebp
  801afa:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801afc:	6a 00                	push   $0x0
  801afe:	6a 00                	push   $0x0
  801b00:	6a 00                	push   $0x0
  801b02:	6a 00                	push   $0x0
  801b04:	6a 00                	push   $0x0
  801b06:	6a 0e                	push   $0xe
  801b08:	e8 9b fe ff ff       	call   8019a8 <syscall>
  801b0d:	83 c4 18             	add    $0x18,%esp
}
  801b10:	c9                   	leave  
  801b11:	c3                   	ret    

00801b12 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801b12:	55                   	push   %ebp
  801b13:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801b15:	6a 00                	push   $0x0
  801b17:	6a 00                	push   $0x0
  801b19:	6a 00                	push   $0x0
  801b1b:	6a 00                	push   $0x0
  801b1d:	6a 00                	push   $0x0
  801b1f:	6a 0f                	push   $0xf
  801b21:	e8 82 fe ff ff       	call   8019a8 <syscall>
  801b26:	83 c4 18             	add    $0x18,%esp
}
  801b29:	c9                   	leave  
  801b2a:	c3                   	ret    

00801b2b <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801b2b:	55                   	push   %ebp
  801b2c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801b2e:	6a 00                	push   $0x0
  801b30:	6a 00                	push   $0x0
  801b32:	6a 00                	push   $0x0
  801b34:	6a 00                	push   $0x0
  801b36:	ff 75 08             	pushl  0x8(%ebp)
  801b39:	6a 10                	push   $0x10
  801b3b:	e8 68 fe ff ff       	call   8019a8 <syscall>
  801b40:	83 c4 18             	add    $0x18,%esp
}
  801b43:	c9                   	leave  
  801b44:	c3                   	ret    

00801b45 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801b45:	55                   	push   %ebp
  801b46:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801b48:	6a 00                	push   $0x0
  801b4a:	6a 00                	push   $0x0
  801b4c:	6a 00                	push   $0x0
  801b4e:	6a 00                	push   $0x0
  801b50:	6a 00                	push   $0x0
  801b52:	6a 11                	push   $0x11
  801b54:	e8 4f fe ff ff       	call   8019a8 <syscall>
  801b59:	83 c4 18             	add    $0x18,%esp
}
  801b5c:	90                   	nop
  801b5d:	c9                   	leave  
  801b5e:	c3                   	ret    

00801b5f <sys_cputc>:

void
sys_cputc(const char c)
{
  801b5f:	55                   	push   %ebp
  801b60:	89 e5                	mov    %esp,%ebp
  801b62:	83 ec 04             	sub    $0x4,%esp
  801b65:	8b 45 08             	mov    0x8(%ebp),%eax
  801b68:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801b6b:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801b6f:	6a 00                	push   $0x0
  801b71:	6a 00                	push   $0x0
  801b73:	6a 00                	push   $0x0
  801b75:	6a 00                	push   $0x0
  801b77:	50                   	push   %eax
  801b78:	6a 01                	push   $0x1
  801b7a:	e8 29 fe ff ff       	call   8019a8 <syscall>
  801b7f:	83 c4 18             	add    $0x18,%esp
}
  801b82:	90                   	nop
  801b83:	c9                   	leave  
  801b84:	c3                   	ret    

00801b85 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801b85:	55                   	push   %ebp
  801b86:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801b88:	6a 00                	push   $0x0
  801b8a:	6a 00                	push   $0x0
  801b8c:	6a 00                	push   $0x0
  801b8e:	6a 00                	push   $0x0
  801b90:	6a 00                	push   $0x0
  801b92:	6a 14                	push   $0x14
  801b94:	e8 0f fe ff ff       	call   8019a8 <syscall>
  801b99:	83 c4 18             	add    $0x18,%esp
}
  801b9c:	90                   	nop
  801b9d:	c9                   	leave  
  801b9e:	c3                   	ret    

00801b9f <sys_create_shared_object>:

int sys_create_shared_object(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801b9f:	55                   	push   %ebp
  801ba0:	89 e5                	mov    %esp,%ebp
  801ba2:	83 ec 04             	sub    $0x4,%esp
  801ba5:	8b 45 10             	mov    0x10(%ebp),%eax
  801ba8:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801bab:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801bae:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801bb2:	8b 45 08             	mov    0x8(%ebp),%eax
  801bb5:	6a 00                	push   $0x0
  801bb7:	51                   	push   %ecx
  801bb8:	52                   	push   %edx
  801bb9:	ff 75 0c             	pushl  0xc(%ebp)
  801bbc:	50                   	push   %eax
  801bbd:	6a 15                	push   $0x15
  801bbf:	e8 e4 fd ff ff       	call   8019a8 <syscall>
  801bc4:	83 c4 18             	add    $0x18,%esp
}
  801bc7:	c9                   	leave  
  801bc8:	c3                   	ret    

00801bc9 <sys_size_of_shared_object>:

//2017:
int sys_size_of_shared_object(int32 ownerID, char* shareName)
{
  801bc9:	55                   	push   %ebp
  801bca:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801bcc:	8b 55 0c             	mov    0xc(%ebp),%edx
  801bcf:	8b 45 08             	mov    0x8(%ebp),%eax
  801bd2:	6a 00                	push   $0x0
  801bd4:	6a 00                	push   $0x0
  801bd6:	6a 00                	push   $0x0
  801bd8:	52                   	push   %edx
  801bd9:	50                   	push   %eax
  801bda:	6a 16                	push   $0x16
  801bdc:	e8 c7 fd ff ff       	call   8019a8 <syscall>
  801be1:	83 c4 18             	add    $0x18,%esp
}
  801be4:	c9                   	leave  
  801be5:	c3                   	ret    

00801be6 <sys_get_shared_object>:
//==========

int sys_get_shared_object(int32 ownerID, char* shareName, void* virtual_address)
{
  801be6:	55                   	push   %ebp
  801be7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801be9:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801bec:	8b 55 0c             	mov    0xc(%ebp),%edx
  801bef:	8b 45 08             	mov    0x8(%ebp),%eax
  801bf2:	6a 00                	push   $0x0
  801bf4:	6a 00                	push   $0x0
  801bf6:	51                   	push   %ecx
  801bf7:	52                   	push   %edx
  801bf8:	50                   	push   %eax
  801bf9:	6a 17                	push   $0x17
  801bfb:	e8 a8 fd ff ff       	call   8019a8 <syscall>
  801c00:	83 c4 18             	add    $0x18,%esp
}
  801c03:	c9                   	leave  
  801c04:	c3                   	ret    

00801c05 <sys_delete_shared_object>:

int sys_delete_shared_object(int32 sharedObjectID, void *startVA)
{
  801c05:	55                   	push   %ebp
  801c06:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801c08:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c0b:	8b 45 08             	mov    0x8(%ebp),%eax
  801c0e:	6a 00                	push   $0x0
  801c10:	6a 00                	push   $0x0
  801c12:	6a 00                	push   $0x0
  801c14:	52                   	push   %edx
  801c15:	50                   	push   %eax
  801c16:	6a 18                	push   $0x18
  801c18:	e8 8b fd ff ff       	call   8019a8 <syscall>
  801c1d:	83 c4 18             	add    $0x18,%esp
}
  801c20:	c9                   	leave  
  801c21:	c3                   	ret    

00801c22 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801c22:	55                   	push   %ebp
  801c23:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801c25:	8b 45 08             	mov    0x8(%ebp),%eax
  801c28:	6a 00                	push   $0x0
  801c2a:	ff 75 14             	pushl  0x14(%ebp)
  801c2d:	ff 75 10             	pushl  0x10(%ebp)
  801c30:	ff 75 0c             	pushl  0xc(%ebp)
  801c33:	50                   	push   %eax
  801c34:	6a 19                	push   $0x19
  801c36:	e8 6d fd ff ff       	call   8019a8 <syscall>
  801c3b:	83 c4 18             	add    $0x18,%esp
}
  801c3e:	c9                   	leave  
  801c3f:	c3                   	ret    

00801c40 <sys_run_env>:

void sys_run_env(int32 envId)
{
  801c40:	55                   	push   %ebp
  801c41:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801c43:	8b 45 08             	mov    0x8(%ebp),%eax
  801c46:	6a 00                	push   $0x0
  801c48:	6a 00                	push   $0x0
  801c4a:	6a 00                	push   $0x0
  801c4c:	6a 00                	push   $0x0
  801c4e:	50                   	push   %eax
  801c4f:	6a 1a                	push   $0x1a
  801c51:	e8 52 fd ff ff       	call   8019a8 <syscall>
  801c56:	83 c4 18             	add    $0x18,%esp
}
  801c59:	90                   	nop
  801c5a:	c9                   	leave  
  801c5b:	c3                   	ret    

00801c5c <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801c5c:	55                   	push   %ebp
  801c5d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801c5f:	8b 45 08             	mov    0x8(%ebp),%eax
  801c62:	6a 00                	push   $0x0
  801c64:	6a 00                	push   $0x0
  801c66:	6a 00                	push   $0x0
  801c68:	6a 00                	push   $0x0
  801c6a:	50                   	push   %eax
  801c6b:	6a 1b                	push   $0x1b
  801c6d:	e8 36 fd ff ff       	call   8019a8 <syscall>
  801c72:	83 c4 18             	add    $0x18,%esp
}
  801c75:	c9                   	leave  
  801c76:	c3                   	ret    

00801c77 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801c77:	55                   	push   %ebp
  801c78:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801c7a:	6a 00                	push   $0x0
  801c7c:	6a 00                	push   $0x0
  801c7e:	6a 00                	push   $0x0
  801c80:	6a 00                	push   $0x0
  801c82:	6a 00                	push   $0x0
  801c84:	6a 05                	push   $0x5
  801c86:	e8 1d fd ff ff       	call   8019a8 <syscall>
  801c8b:	83 c4 18             	add    $0x18,%esp
}
  801c8e:	c9                   	leave  
  801c8f:	c3                   	ret    

00801c90 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801c90:	55                   	push   %ebp
  801c91:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801c93:	6a 00                	push   $0x0
  801c95:	6a 00                	push   $0x0
  801c97:	6a 00                	push   $0x0
  801c99:	6a 00                	push   $0x0
  801c9b:	6a 00                	push   $0x0
  801c9d:	6a 06                	push   $0x6
  801c9f:	e8 04 fd ff ff       	call   8019a8 <syscall>
  801ca4:	83 c4 18             	add    $0x18,%esp
}
  801ca7:	c9                   	leave  
  801ca8:	c3                   	ret    

00801ca9 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801ca9:	55                   	push   %ebp
  801caa:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801cac:	6a 00                	push   $0x0
  801cae:	6a 00                	push   $0x0
  801cb0:	6a 00                	push   $0x0
  801cb2:	6a 00                	push   $0x0
  801cb4:	6a 00                	push   $0x0
  801cb6:	6a 07                	push   $0x7
  801cb8:	e8 eb fc ff ff       	call   8019a8 <syscall>
  801cbd:	83 c4 18             	add    $0x18,%esp
}
  801cc0:	c9                   	leave  
  801cc1:	c3                   	ret    

00801cc2 <sys_exit_env>:


void sys_exit_env(void)
{
  801cc2:	55                   	push   %ebp
  801cc3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801cc5:	6a 00                	push   $0x0
  801cc7:	6a 00                	push   $0x0
  801cc9:	6a 00                	push   $0x0
  801ccb:	6a 00                	push   $0x0
  801ccd:	6a 00                	push   $0x0
  801ccf:	6a 1c                	push   $0x1c
  801cd1:	e8 d2 fc ff ff       	call   8019a8 <syscall>
  801cd6:	83 c4 18             	add    $0x18,%esp
}
  801cd9:	90                   	nop
  801cda:	c9                   	leave  
  801cdb:	c3                   	ret    

00801cdc <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  801cdc:	55                   	push   %ebp
  801cdd:	89 e5                	mov    %esp,%ebp
  801cdf:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801ce2:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801ce5:	8d 50 04             	lea    0x4(%eax),%edx
  801ce8:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801ceb:	6a 00                	push   $0x0
  801ced:	6a 00                	push   $0x0
  801cef:	6a 00                	push   $0x0
  801cf1:	52                   	push   %edx
  801cf2:	50                   	push   %eax
  801cf3:	6a 1d                	push   $0x1d
  801cf5:	e8 ae fc ff ff       	call   8019a8 <syscall>
  801cfa:	83 c4 18             	add    $0x18,%esp
	return result;
  801cfd:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801d00:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801d03:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801d06:	89 01                	mov    %eax,(%ecx)
  801d08:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801d0b:	8b 45 08             	mov    0x8(%ebp),%eax
  801d0e:	c9                   	leave  
  801d0f:	c2 04 00             	ret    $0x4

00801d12 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801d12:	55                   	push   %ebp
  801d13:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801d15:	6a 00                	push   $0x0
  801d17:	6a 00                	push   $0x0
  801d19:	ff 75 10             	pushl  0x10(%ebp)
  801d1c:	ff 75 0c             	pushl  0xc(%ebp)
  801d1f:	ff 75 08             	pushl  0x8(%ebp)
  801d22:	6a 13                	push   $0x13
  801d24:	e8 7f fc ff ff       	call   8019a8 <syscall>
  801d29:	83 c4 18             	add    $0x18,%esp
	return ;
  801d2c:	90                   	nop
}
  801d2d:	c9                   	leave  
  801d2e:	c3                   	ret    

00801d2f <sys_rcr2>:
uint32 sys_rcr2()
{
  801d2f:	55                   	push   %ebp
  801d30:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801d32:	6a 00                	push   $0x0
  801d34:	6a 00                	push   $0x0
  801d36:	6a 00                	push   $0x0
  801d38:	6a 00                	push   $0x0
  801d3a:	6a 00                	push   $0x0
  801d3c:	6a 1e                	push   $0x1e
  801d3e:	e8 65 fc ff ff       	call   8019a8 <syscall>
  801d43:	83 c4 18             	add    $0x18,%esp
}
  801d46:	c9                   	leave  
  801d47:	c3                   	ret    

00801d48 <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  801d48:	55                   	push   %ebp
  801d49:	89 e5                	mov    %esp,%ebp
  801d4b:	83 ec 04             	sub    $0x4,%esp
  801d4e:	8b 45 08             	mov    0x8(%ebp),%eax
  801d51:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801d54:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801d58:	6a 00                	push   $0x0
  801d5a:	6a 00                	push   $0x0
  801d5c:	6a 00                	push   $0x0
  801d5e:	6a 00                	push   $0x0
  801d60:	50                   	push   %eax
  801d61:	6a 1f                	push   $0x1f
  801d63:	e8 40 fc ff ff       	call   8019a8 <syscall>
  801d68:	83 c4 18             	add    $0x18,%esp
	return ;
  801d6b:	90                   	nop
}
  801d6c:	c9                   	leave  
  801d6d:	c3                   	ret    

00801d6e <rsttst>:
void rsttst()
{
  801d6e:	55                   	push   %ebp
  801d6f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801d71:	6a 00                	push   $0x0
  801d73:	6a 00                	push   $0x0
  801d75:	6a 00                	push   $0x0
  801d77:	6a 00                	push   $0x0
  801d79:	6a 00                	push   $0x0
  801d7b:	6a 21                	push   $0x21
  801d7d:	e8 26 fc ff ff       	call   8019a8 <syscall>
  801d82:	83 c4 18             	add    $0x18,%esp
	return ;
  801d85:	90                   	nop
}
  801d86:	c9                   	leave  
  801d87:	c3                   	ret    

00801d88 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801d88:	55                   	push   %ebp
  801d89:	89 e5                	mov    %esp,%ebp
  801d8b:	83 ec 04             	sub    $0x4,%esp
  801d8e:	8b 45 14             	mov    0x14(%ebp),%eax
  801d91:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801d94:	8b 55 18             	mov    0x18(%ebp),%edx
  801d97:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801d9b:	52                   	push   %edx
  801d9c:	50                   	push   %eax
  801d9d:	ff 75 10             	pushl  0x10(%ebp)
  801da0:	ff 75 0c             	pushl  0xc(%ebp)
  801da3:	ff 75 08             	pushl  0x8(%ebp)
  801da6:	6a 20                	push   $0x20
  801da8:	e8 fb fb ff ff       	call   8019a8 <syscall>
  801dad:	83 c4 18             	add    $0x18,%esp
	return ;
  801db0:	90                   	nop
}
  801db1:	c9                   	leave  
  801db2:	c3                   	ret    

00801db3 <chktst>:
void chktst(uint32 n)
{
  801db3:	55                   	push   %ebp
  801db4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801db6:	6a 00                	push   $0x0
  801db8:	6a 00                	push   $0x0
  801dba:	6a 00                	push   $0x0
  801dbc:	6a 00                	push   $0x0
  801dbe:	ff 75 08             	pushl  0x8(%ebp)
  801dc1:	6a 22                	push   $0x22
  801dc3:	e8 e0 fb ff ff       	call   8019a8 <syscall>
  801dc8:	83 c4 18             	add    $0x18,%esp
	return ;
  801dcb:	90                   	nop
}
  801dcc:	c9                   	leave  
  801dcd:	c3                   	ret    

00801dce <inctst>:

void inctst()
{
  801dce:	55                   	push   %ebp
  801dcf:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801dd1:	6a 00                	push   $0x0
  801dd3:	6a 00                	push   $0x0
  801dd5:	6a 00                	push   $0x0
  801dd7:	6a 00                	push   $0x0
  801dd9:	6a 00                	push   $0x0
  801ddb:	6a 23                	push   $0x23
  801ddd:	e8 c6 fb ff ff       	call   8019a8 <syscall>
  801de2:	83 c4 18             	add    $0x18,%esp
	return ;
  801de5:	90                   	nop
}
  801de6:	c9                   	leave  
  801de7:	c3                   	ret    

00801de8 <gettst>:
uint32 gettst()
{
  801de8:	55                   	push   %ebp
  801de9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801deb:	6a 00                	push   $0x0
  801ded:	6a 00                	push   $0x0
  801def:	6a 00                	push   $0x0
  801df1:	6a 00                	push   $0x0
  801df3:	6a 00                	push   $0x0
  801df5:	6a 24                	push   $0x24
  801df7:	e8 ac fb ff ff       	call   8019a8 <syscall>
  801dfc:	83 c4 18             	add    $0x18,%esp
}
  801dff:	c9                   	leave  
  801e00:	c3                   	ret    

00801e01 <sys_get_uheap_strategy>:

/*2025*/
uint32 sys_get_uheap_strategy()
{
  801e01:	55                   	push   %ebp
  801e02:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801e04:	6a 00                	push   $0x0
  801e06:	6a 00                	push   $0x0
  801e08:	6a 00                	push   $0x0
  801e0a:	6a 00                	push   $0x0
  801e0c:	6a 00                	push   $0x0
  801e0e:	6a 25                	push   $0x25
  801e10:	e8 93 fb ff ff       	call   8019a8 <syscall>
  801e15:	83 c4 18             	add    $0x18,%esp
  801e18:	a3 60 c0 81 00       	mov    %eax,0x81c060
	return uheapPlaceStrategy ;
  801e1d:	a1 60 c0 81 00       	mov    0x81c060,%eax
}
  801e22:	c9                   	leave  
  801e23:	c3                   	ret    

00801e24 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801e24:	55                   	push   %ebp
  801e25:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = heapStrategy;
  801e27:	8b 45 08             	mov    0x8(%ebp),%eax
  801e2a:	a3 60 c0 81 00       	mov    %eax,0x81c060
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801e2f:	6a 00                	push   $0x0
  801e31:	6a 00                	push   $0x0
  801e33:	6a 00                	push   $0x0
  801e35:	6a 00                	push   $0x0
  801e37:	ff 75 08             	pushl  0x8(%ebp)
  801e3a:	6a 26                	push   $0x26
  801e3c:	e8 67 fb ff ff       	call   8019a8 <syscall>
  801e41:	83 c4 18             	add    $0x18,%esp
	return ;
  801e44:	90                   	nop
}
  801e45:	c9                   	leave  
  801e46:	c3                   	ret    

00801e47 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801e47:	55                   	push   %ebp
  801e48:	89 e5                	mov    %esp,%ebp
  801e4a:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801e4b:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801e4e:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801e51:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e54:	8b 45 08             	mov    0x8(%ebp),%eax
  801e57:	6a 00                	push   $0x0
  801e59:	53                   	push   %ebx
  801e5a:	51                   	push   %ecx
  801e5b:	52                   	push   %edx
  801e5c:	50                   	push   %eax
  801e5d:	6a 27                	push   $0x27
  801e5f:	e8 44 fb ff ff       	call   8019a8 <syscall>
  801e64:	83 c4 18             	add    $0x18,%esp
}
  801e67:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801e6a:	c9                   	leave  
  801e6b:	c3                   	ret    

00801e6c <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801e6c:	55                   	push   %ebp
  801e6d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801e6f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e72:	8b 45 08             	mov    0x8(%ebp),%eax
  801e75:	6a 00                	push   $0x0
  801e77:	6a 00                	push   $0x0
  801e79:	6a 00                	push   $0x0
  801e7b:	52                   	push   %edx
  801e7c:	50                   	push   %eax
  801e7d:	6a 28                	push   $0x28
  801e7f:	e8 24 fb ff ff       	call   8019a8 <syscall>
  801e84:	83 c4 18             	add    $0x18,%esp
}
  801e87:	c9                   	leave  
  801e88:	c3                   	ret    

00801e89 <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  801e89:	55                   	push   %ebp
  801e8a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  801e8c:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801e8f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e92:	8b 45 08             	mov    0x8(%ebp),%eax
  801e95:	6a 00                	push   $0x0
  801e97:	51                   	push   %ecx
  801e98:	ff 75 10             	pushl  0x10(%ebp)
  801e9b:	52                   	push   %edx
  801e9c:	50                   	push   %eax
  801e9d:	6a 29                	push   $0x29
  801e9f:	e8 04 fb ff ff       	call   8019a8 <syscall>
  801ea4:	83 c4 18             	add    $0x18,%esp
}
  801ea7:	c9                   	leave  
  801ea8:	c3                   	ret    

00801ea9 <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801ea9:	55                   	push   %ebp
  801eaa:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801eac:	6a 00                	push   $0x0
  801eae:	6a 00                	push   $0x0
  801eb0:	ff 75 10             	pushl  0x10(%ebp)
  801eb3:	ff 75 0c             	pushl  0xc(%ebp)
  801eb6:	ff 75 08             	pushl  0x8(%ebp)
  801eb9:	6a 12                	push   $0x12
  801ebb:	e8 e8 fa ff ff       	call   8019a8 <syscall>
  801ec0:	83 c4 18             	add    $0x18,%esp
	return ;
  801ec3:	90                   	nop
}
  801ec4:	c9                   	leave  
  801ec5:	c3                   	ret    

00801ec6 <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  801ec6:	55                   	push   %ebp
  801ec7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  801ec9:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ecc:	8b 45 08             	mov    0x8(%ebp),%eax
  801ecf:	6a 00                	push   $0x0
  801ed1:	6a 00                	push   $0x0
  801ed3:	6a 00                	push   $0x0
  801ed5:	52                   	push   %edx
  801ed6:	50                   	push   %eax
  801ed7:	6a 2a                	push   $0x2a
  801ed9:	e8 ca fa ff ff       	call   8019a8 <syscall>
  801ede:	83 c4 18             	add    $0x18,%esp
	return;
  801ee1:	90                   	nop
}
  801ee2:	c9                   	leave  
  801ee3:	c3                   	ret    

00801ee4 <sys_get_optimal_num_faults>:
/*2025*/
int sys_get_optimal_num_faults()
{
  801ee4:	55                   	push   %ebp
  801ee5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_optimal_num_faults, 0, 0, 0, 0, 0);
  801ee7:	6a 00                	push   $0x0
  801ee9:	6a 00                	push   $0x0
  801eeb:	6a 00                	push   $0x0
  801eed:	6a 00                	push   $0x0
  801eef:	6a 00                	push   $0x0
  801ef1:	6a 2b                	push   $0x2b
  801ef3:	e8 b0 fa ff ff       	call   8019a8 <syscall>
  801ef8:	83 c4 18             	add    $0x18,%esp
}
  801efb:	c9                   	leave  
  801efc:	c3                   	ret    

00801efd <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801efd:	55                   	push   %ebp
  801efe:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801f00:	6a 00                	push   $0x0
  801f02:	6a 00                	push   $0x0
  801f04:	6a 00                	push   $0x0
  801f06:	ff 75 0c             	pushl  0xc(%ebp)
  801f09:	ff 75 08             	pushl  0x8(%ebp)
  801f0c:	6a 2d                	push   $0x2d
  801f0e:	e8 95 fa ff ff       	call   8019a8 <syscall>
  801f13:	83 c4 18             	add    $0x18,%esp
	return;
  801f16:	90                   	nop
}
  801f17:	c9                   	leave  
  801f18:	c3                   	ret    

00801f19 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801f19:	55                   	push   %ebp
  801f1a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801f1c:	6a 00                	push   $0x0
  801f1e:	6a 00                	push   $0x0
  801f20:	6a 00                	push   $0x0
  801f22:	ff 75 0c             	pushl  0xc(%ebp)
  801f25:	ff 75 08             	pushl  0x8(%ebp)
  801f28:	6a 2c                	push   $0x2c
  801f2a:	e8 79 fa ff ff       	call   8019a8 <syscall>
  801f2f:	83 c4 18             	add    $0x18,%esp
	return ;
  801f32:	90                   	nop
}
  801f33:	c9                   	leave  
  801f34:	c3                   	ret    

00801f35 <sys_env_set_priority>:


void sys_env_set_priority(int32 envID, int priority)
{
  801f35:	55                   	push   %ebp
  801f36:	89 e5                	mov    %esp,%ebp
  801f38:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.IM#4] CPU SCHEDULING - #1 System Calls - Add suitable code here
	//Your code is here
	//Comment the following line
	panic("sys_env_set_priority() is not implemented yet...!!");
  801f3b:	83 ec 04             	sub    $0x4,%esp
  801f3e:	68 94 37 80 00       	push   $0x803794
  801f43:	68 25 01 00 00       	push   $0x125
  801f48:	68 c7 37 80 00       	push   $0x8037c7
  801f4d:	e8 1a 0b 00 00       	call   802a6c <_panic>

00801f52 <to_page_va>:
//==================================
//==================================
// [1] GET PAGE VA:
//==================================
__inline__ uint32 to_page_va(struct PageInfoElement *ptrPageInfo)
{
  801f52:	55                   	push   %ebp
  801f53:	89 e5                	mov    %esp,%ebp
  801f55:	83 ec 18             	sub    $0x18,%esp
	if (ptrPageInfo < &pageBlockInfoArr[0] || ptrPageInfo >= &pageBlockInfoArr[DYN_ALLOC_MAX_SIZE/PAGE_SIZE])
  801f58:	81 7d 08 60 40 80 00 	cmpl   $0x804060,0x8(%ebp)
  801f5f:	72 09                	jb     801f6a <to_page_va+0x18>
  801f61:	81 7d 08 60 c0 81 00 	cmpl   $0x81c060,0x8(%ebp)
  801f68:	72 14                	jb     801f7e <to_page_va+0x2c>
			panic("to_page_va called with invalid pageInfoPtr");
  801f6a:	83 ec 04             	sub    $0x4,%esp
  801f6d:	68 d8 37 80 00       	push   $0x8037d8
  801f72:	6a 15                	push   $0x15
  801f74:	68 03 38 80 00       	push   $0x803803
  801f79:	e8 ee 0a 00 00       	call   802a6c <_panic>
	//Get start VA of the page from the corresponding Page Info pointer
	int idxInPageInfoArr = (ptrPageInfo - pageBlockInfoArr);
  801f7e:	8b 45 08             	mov    0x8(%ebp),%eax
  801f81:	ba 60 40 80 00       	mov    $0x804060,%edx
  801f86:	29 d0                	sub    %edx,%eax
  801f88:	c1 f8 02             	sar    $0x2,%eax
  801f8b:	89 c2                	mov    %eax,%edx
  801f8d:	89 d0                	mov    %edx,%eax
  801f8f:	c1 e0 02             	shl    $0x2,%eax
  801f92:	01 d0                	add    %edx,%eax
  801f94:	c1 e0 02             	shl    $0x2,%eax
  801f97:	01 d0                	add    %edx,%eax
  801f99:	c1 e0 02             	shl    $0x2,%eax
  801f9c:	01 d0                	add    %edx,%eax
  801f9e:	89 c1                	mov    %eax,%ecx
  801fa0:	c1 e1 08             	shl    $0x8,%ecx
  801fa3:	01 c8                	add    %ecx,%eax
  801fa5:	89 c1                	mov    %eax,%ecx
  801fa7:	c1 e1 10             	shl    $0x10,%ecx
  801faa:	01 c8                	add    %ecx,%eax
  801fac:	01 c0                	add    %eax,%eax
  801fae:	01 d0                	add    %edx,%eax
  801fb0:	89 45 f4             	mov    %eax,-0xc(%ebp)
	return dynAllocStart + (idxInPageInfoArr << PGSHIFT);
  801fb3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fb6:	c1 e0 0c             	shl    $0xc,%eax
  801fb9:	89 c2                	mov    %eax,%edx
  801fbb:	a1 64 c0 81 00       	mov    0x81c064,%eax
  801fc0:	01 d0                	add    %edx,%eax
}
  801fc2:	c9                   	leave  
  801fc3:	c3                   	ret    

00801fc4 <to_page_info>:

//==================================
// [2] GET PAGE INFO OF PAGE VA:
//==================================
__inline__ struct PageInfoElement * to_page_info(uint32 va)
{
  801fc4:	55                   	push   %ebp
  801fc5:	89 e5                	mov    %esp,%ebp
  801fc7:	83 ec 18             	sub    $0x18,%esp
	int idxInPageInfoArr = (va - dynAllocStart) >> PGSHIFT;
  801fca:	a1 64 c0 81 00       	mov    0x81c064,%eax
  801fcf:	8b 55 08             	mov    0x8(%ebp),%edx
  801fd2:	29 c2                	sub    %eax,%edx
  801fd4:	89 d0                	mov    %edx,%eax
  801fd6:	c1 e8 0c             	shr    $0xc,%eax
  801fd9:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if (idxInPageInfoArr < 0 || idxInPageInfoArr >= DYN_ALLOC_MAX_SIZE/PAGE_SIZE)
  801fdc:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801fe0:	78 09                	js     801feb <to_page_info+0x27>
  801fe2:	81 7d f4 ff 1f 00 00 	cmpl   $0x1fff,-0xc(%ebp)
  801fe9:	7e 14                	jle    801fff <to_page_info+0x3b>
		panic("to_page_info called with invalid pa");
  801feb:	83 ec 04             	sub    $0x4,%esp
  801fee:	68 1c 38 80 00       	push   $0x80381c
  801ff3:	6a 22                	push   $0x22
  801ff5:	68 03 38 80 00       	push   $0x803803
  801ffa:	e8 6d 0a 00 00       	call   802a6c <_panic>
	return &pageBlockInfoArr[idxInPageInfoArr];
  801fff:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802002:	89 d0                	mov    %edx,%eax
  802004:	01 c0                	add    %eax,%eax
  802006:	01 d0                	add    %edx,%eax
  802008:	c1 e0 02             	shl    $0x2,%eax
  80200b:	05 60 40 80 00       	add    $0x804060,%eax
}
  802010:	c9                   	leave  
  802011:	c3                   	ret    

00802012 <initialize_dynamic_allocator>:
//==================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================
bool is_initialized = 0;
void initialize_dynamic_allocator(uint32 daStart, uint32 daEnd)
{
  802012:	55                   	push   %ebp
  802013:	89 e5                	mov    %esp,%ebp
  802015:	83 ec 18             	sub    $0x18,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		assert(daEnd <= daStart + DYN_ALLOC_MAX_SIZE);
  802018:	8b 45 08             	mov    0x8(%ebp),%eax
  80201b:	05 00 00 00 02       	add    $0x2000000,%eax
  802020:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802023:	73 16                	jae    80203b <initialize_dynamic_allocator+0x29>
  802025:	68 40 38 80 00       	push   $0x803840
  80202a:	68 66 38 80 00       	push   $0x803866
  80202f:	6a 34                	push   $0x34
  802031:	68 03 38 80 00       	push   $0x803803
  802036:	e8 31 0a 00 00       	call   802a6c <_panic>
		is_initialized = 1;
  80203b:	c7 05 24 40 80 00 01 	movl   $0x1,0x804024
  802042:	00 00 00 
	//==================================================================================
	//==================================================================================
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #1 initialize_dynamic_allocator
	//Your code is here
	// init bounds of the dynalloc
	dynAllocStart = daStart;
  802045:	8b 45 08             	mov    0x8(%ebp),%eax
  802048:	a3 64 c0 81 00       	mov    %eax,0x81c064
	dynAllocEnd = daEnd;
  80204d:	8b 45 0c             	mov    0xc(%ebp),%eax
  802050:	a3 40 40 80 00       	mov    %eax,0x804040
	// init the list that keep track of all free pageBlockInfoArr instances.
	LIST_INIT(&freePagesList);
  802055:	c7 05 48 40 80 00 00 	movl   $0x0,0x804048
  80205c:	00 00 00 
  80205f:	c7 05 4c 40 80 00 00 	movl   $0x0,0x80404c
  802066:	00 00 00 
  802069:	c7 05 54 40 80 00 00 	movl   $0x0,0x804054
  802070:	00 00 00 

	// no.of pages in the dynamic allocator.
	int pCount = (daEnd - daStart) / PAGE_SIZE;
  802073:	8b 45 0c             	mov    0xc(%ebp),%eax
  802076:	2b 45 08             	sub    0x8(%ebp),%eax
  802079:	c1 e8 0c             	shr    $0xc,%eax
  80207c:	89 45 ec             	mov    %eax,-0x14(%ebp)
	// iterate over each page and init its data in pageBlockInfoArr and reset it.
	for (int i = 0; i < pCount; ++i) {
  80207f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  802086:	e9 c8 00 00 00       	jmp    802153 <initialize_dynamic_allocator+0x141>
	    pageBlockInfoArr[i].block_size = 0;
  80208b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80208e:	89 d0                	mov    %edx,%eax
  802090:	01 c0                	add    %eax,%eax
  802092:	01 d0                	add    %edx,%eax
  802094:	c1 e0 02             	shl    $0x2,%eax
  802097:	05 68 40 80 00       	add    $0x804068,%eax
  80209c:	66 c7 00 00 00       	movw   $0x0,(%eax)
	    pageBlockInfoArr[i].num_of_free_blocks = 0;
  8020a1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8020a4:	89 d0                	mov    %edx,%eax
  8020a6:	01 c0                	add    %eax,%eax
  8020a8:	01 d0                	add    %edx,%eax
  8020aa:	c1 e0 02             	shl    $0x2,%eax
  8020ad:	05 6a 40 80 00       	add    $0x80406a,%eax
  8020b2:	66 c7 00 00 00       	movw   $0x0,(%eax)
	    LIST_INSERT_TAIL(&freePagesList, &pageBlockInfoArr[i]);
  8020b7:	8b 15 4c 40 80 00    	mov    0x80404c,%edx
  8020bd:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  8020c0:	89 c8                	mov    %ecx,%eax
  8020c2:	01 c0                	add    %eax,%eax
  8020c4:	01 c8                	add    %ecx,%eax
  8020c6:	c1 e0 02             	shl    $0x2,%eax
  8020c9:	05 64 40 80 00       	add    $0x804064,%eax
  8020ce:	89 10                	mov    %edx,(%eax)
  8020d0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8020d3:	89 d0                	mov    %edx,%eax
  8020d5:	01 c0                	add    %eax,%eax
  8020d7:	01 d0                	add    %edx,%eax
  8020d9:	c1 e0 02             	shl    $0x2,%eax
  8020dc:	05 64 40 80 00       	add    $0x804064,%eax
  8020e1:	8b 00                	mov    (%eax),%eax
  8020e3:	85 c0                	test   %eax,%eax
  8020e5:	74 1b                	je     802102 <initialize_dynamic_allocator+0xf0>
  8020e7:	8b 15 4c 40 80 00    	mov    0x80404c,%edx
  8020ed:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  8020f0:	89 c8                	mov    %ecx,%eax
  8020f2:	01 c0                	add    %eax,%eax
  8020f4:	01 c8                	add    %ecx,%eax
  8020f6:	c1 e0 02             	shl    $0x2,%eax
  8020f9:	05 60 40 80 00       	add    $0x804060,%eax
  8020fe:	89 02                	mov    %eax,(%edx)
  802100:	eb 16                	jmp    802118 <initialize_dynamic_allocator+0x106>
  802102:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802105:	89 d0                	mov    %edx,%eax
  802107:	01 c0                	add    %eax,%eax
  802109:	01 d0                	add    %edx,%eax
  80210b:	c1 e0 02             	shl    $0x2,%eax
  80210e:	05 60 40 80 00       	add    $0x804060,%eax
  802113:	a3 48 40 80 00       	mov    %eax,0x804048
  802118:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80211b:	89 d0                	mov    %edx,%eax
  80211d:	01 c0                	add    %eax,%eax
  80211f:	01 d0                	add    %edx,%eax
  802121:	c1 e0 02             	shl    $0x2,%eax
  802124:	05 60 40 80 00       	add    $0x804060,%eax
  802129:	a3 4c 40 80 00       	mov    %eax,0x80404c
  80212e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802131:	89 d0                	mov    %edx,%eax
  802133:	01 c0                	add    %eax,%eax
  802135:	01 d0                	add    %edx,%eax
  802137:	c1 e0 02             	shl    $0x2,%eax
  80213a:	05 60 40 80 00       	add    $0x804060,%eax
  80213f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802145:	a1 54 40 80 00       	mov    0x804054,%eax
  80214a:	40                   	inc    %eax
  80214b:	a3 54 40 80 00       	mov    %eax,0x804054
	LIST_INIT(&freePagesList);

	// no.of pages in the dynamic allocator.
	int pCount = (daEnd - daStart) / PAGE_SIZE;
	// iterate over each page and init its data in pageBlockInfoArr and reset it.
	for (int i = 0; i < pCount; ++i) {
  802150:	ff 45 f4             	incl   -0xc(%ebp)
  802153:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802156:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  802159:	0f 8c 2c ff ff ff    	jl     80208b <initialize_dynamic_allocator+0x79>
	    LIST_INSERT_TAIL(&freePagesList, &pageBlockInfoArr[i]);
	}
	// init the array of lists of each size..
	// 8 16 32 64 128 256 512 1024 2056
	// 0 1  2  3   4  5    6   7    8
	for (int i = 0; i <= (LOG2_MAX_SIZE - LOG2_MIN_SIZE); ++i){
  80215f:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  802166:	eb 36                	jmp    80219e <initialize_dynamic_allocator+0x18c>
		LIST_INIT(&freeBlockLists[i]);
  802168:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80216b:	c1 e0 04             	shl    $0x4,%eax
  80216e:	05 80 c0 81 00       	add    $0x81c080,%eax
  802173:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802179:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80217c:	c1 e0 04             	shl    $0x4,%eax
  80217f:	05 84 c0 81 00       	add    $0x81c084,%eax
  802184:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80218a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80218d:	c1 e0 04             	shl    $0x4,%eax
  802190:	05 8c c0 81 00       	add    $0x81c08c,%eax
  802195:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	    LIST_INSERT_TAIL(&freePagesList, &pageBlockInfoArr[i]);
	}
	// init the array of lists of each size..
	// 8 16 32 64 128 256 512 1024 2056
	// 0 1  2  3   4  5    6   7    8
	for (int i = 0; i <= (LOG2_MAX_SIZE - LOG2_MIN_SIZE); ++i){
  80219b:	ff 45 f0             	incl   -0x10(%ebp)
  80219e:	83 7d f0 08          	cmpl   $0x8,-0x10(%ebp)
  8021a2:	7e c4                	jle    802168 <initialize_dynamic_allocator+0x156>
		LIST_INIT(&freeBlockLists[i]);
	}
	//Comment the following line
	//panic("initialize_dynamic_allocator() Not implemented yet");

}
  8021a4:	90                   	nop
  8021a5:	c9                   	leave  
  8021a6:	c3                   	ret    

008021a7 <get_block_size>:

//===========================
// [2] GET BLOCK SIZE:
//===========================
__inline__ uint32 get_block_size(void *va)
{
  8021a7:	55                   	push   %ebp
  8021a8:	89 e5                	mov    %esp,%ebp
  8021aa:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #2 get_block_size
	//Your code is here
	// get the page that saves this va
	struct PageInfoElement* ptr = to_page_info((uint32)va);
  8021ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8021b0:	83 ec 0c             	sub    $0xc,%esp
  8021b3:	50                   	push   %eax
  8021b4:	e8 0b fe ff ff       	call   801fc4 <to_page_info>
  8021b9:	83 c4 10             	add    $0x10,%esp
  8021bc:	89 45 f4             	mov    %eax,-0xc(%ebp)
	return ptr->block_size;
  8021bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021c2:	8b 40 08             	mov    0x8(%eax),%eax
  8021c5:	0f b7 c0             	movzwl %ax,%eax
	//Comment the following line
	//panic("get_block_size() Not implemented yet");
}
  8021c8:	c9                   	leave  
  8021c9:	c3                   	ret    

008021ca <split_page_to_blocks>:
// =====================
// h) split page to blocks and add them in freeBlockLists
// =====================
// function that split the page provided into same sized blocks
//and putem in suitable freeblockList index according to size.
 void split_page_to_blocks(uint32 blk_size, struct PageInfoElement *pageInfo) {
  8021ca:	55                   	push   %ebp
  8021cb:	89 e5                	mov    %esp,%ebp
  8021cd:	83 ec 28             	sub    $0x28,%esp
	 // cur page virtual address by the pageInfo.
	 uint32 page_va = (uint32)to_page_va(pageInfo);
  8021d0:	83 ec 0c             	sub    $0xc,%esp
  8021d3:	ff 75 0c             	pushl  0xc(%ebp)
  8021d6:	e8 77 fd ff ff       	call   801f52 <to_page_va>
  8021db:	83 c4 10             	add    $0x10,%esp
  8021de:	89 45 e8             	mov    %eax,-0x18(%ebp)
	 // no. of blks to save in freeblockList.
	 int blk_count = PAGE_SIZE / blk_size;
  8021e1:	b8 00 10 00 00       	mov    $0x1000,%eax
  8021e6:	ba 00 00 00 00       	mov    $0x0,%edx
  8021eb:	f7 75 08             	divl   0x8(%ebp)
  8021ee:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	 // save page in memory.
	 get_page((uint32*)page_va);
  8021f1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8021f4:	83 ec 0c             	sub    $0xc,%esp
  8021f7:	50                   	push   %eax
  8021f8:	e8 48 f6 ff ff       	call   801845 <get_page>
  8021fd:	83 c4 10             	add    $0x10,%esp
	 // assigning the pageInfo data block size, free block which is whole block count.
	 pageInfo->num_of_free_blocks = blk_count;
  802200:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802203:	8b 55 0c             	mov    0xc(%ebp),%edx
  802206:	66 89 42 0a          	mov    %ax,0xa(%edx)
	 pageInfo->block_size = blk_size;
  80220a:	8b 45 08             	mov    0x8(%ebp),%eax
  80220d:	8b 55 0c             	mov    0xc(%ebp),%edx
  802210:	66 89 42 08          	mov    %ax,0x8(%edx)
	 // get index by size block in freeblocklist.
	 int idx = 0;
  802214:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	 for (int i = LOG2_MIN_SIZE; i <= LOG2_MAX_SIZE; i++) {
  80221b:	c7 45 f0 03 00 00 00 	movl   $0x3,-0x10(%ebp)
  802222:	eb 19                	jmp    80223d <split_page_to_blocks+0x73>
	     if ((1 << i) == blk_size)
  802224:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802227:	ba 01 00 00 00       	mov    $0x1,%edx
  80222c:	88 c1                	mov    %al,%cl
  80222e:	d3 e2                	shl    %cl,%edx
  802230:	89 d0                	mov    %edx,%eax
  802232:	3b 45 08             	cmp    0x8(%ebp),%eax
  802235:	74 0e                	je     802245 <split_page_to_blocks+0x7b>
	         break;
	     idx++;
  802237:	ff 45 f4             	incl   -0xc(%ebp)
	 // assigning the pageInfo data block size, free block which is whole block count.
	 pageInfo->num_of_free_blocks = blk_count;
	 pageInfo->block_size = blk_size;
	 // get index by size block in freeblocklist.
	 int idx = 0;
	 for (int i = LOG2_MIN_SIZE; i <= LOG2_MAX_SIZE; i++) {
  80223a:	ff 45 f0             	incl   -0x10(%ebp)
  80223d:	83 7d f0 0b          	cmpl   $0xb,-0x10(%ebp)
  802241:	7e e1                	jle    802224 <split_page_to_blocks+0x5a>
  802243:	eb 01                	jmp    802246 <split_page_to_blocks+0x7c>
	     if ((1 << i) == blk_size)
	         break;
  802245:	90                   	nop
	     idx++;
	 }
	 // iterate over each blk and make and element of it by passing its address in blockElement pointer and save those in the list.
	 // starting from the page_va.
	 for (uint32 i = 0; i < blk_count; ++i) {
  802246:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  80224d:	e9 a7 00 00 00       	jmp    8022f9 <split_page_to_blocks+0x12f>
	     struct BlockElement *blk =(struct BlockElement*)(page_va + i * blk_size);
  802252:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802255:	0f af 45 08          	imul   0x8(%ebp),%eax
  802259:	89 c2                	mov    %eax,%edx
  80225b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80225e:	01 d0                	add    %edx,%eax
  802260:	89 45 e0             	mov    %eax,-0x20(%ebp)
	     LIST_INSERT_TAIL(&freeBlockLists[idx],blk);
  802263:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  802267:	75 14                	jne    80227d <split_page_to_blocks+0xb3>
  802269:	83 ec 04             	sub    $0x4,%esp
  80226c:	68 7c 38 80 00       	push   $0x80387c
  802271:	6a 7c                	push   $0x7c
  802273:	68 03 38 80 00       	push   $0x803803
  802278:	e8 ef 07 00 00       	call   802a6c <_panic>
  80227d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802280:	c1 e0 04             	shl    $0x4,%eax
  802283:	05 84 c0 81 00       	add    $0x81c084,%eax
  802288:	8b 10                	mov    (%eax),%edx
  80228a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80228d:	89 50 04             	mov    %edx,0x4(%eax)
  802290:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802293:	8b 40 04             	mov    0x4(%eax),%eax
  802296:	85 c0                	test   %eax,%eax
  802298:	74 14                	je     8022ae <split_page_to_blocks+0xe4>
  80229a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80229d:	c1 e0 04             	shl    $0x4,%eax
  8022a0:	05 84 c0 81 00       	add    $0x81c084,%eax
  8022a5:	8b 00                	mov    (%eax),%eax
  8022a7:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8022aa:	89 10                	mov    %edx,(%eax)
  8022ac:	eb 11                	jmp    8022bf <split_page_to_blocks+0xf5>
  8022ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022b1:	c1 e0 04             	shl    $0x4,%eax
  8022b4:	8d 90 80 c0 81 00    	lea    0x81c080(%eax),%edx
  8022ba:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8022bd:	89 02                	mov    %eax,(%edx)
  8022bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022c2:	c1 e0 04             	shl    $0x4,%eax
  8022c5:	8d 90 84 c0 81 00    	lea    0x81c084(%eax),%edx
  8022cb:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8022ce:	89 02                	mov    %eax,(%edx)
  8022d0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8022d3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8022d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022dc:	c1 e0 04             	shl    $0x4,%eax
  8022df:	05 8c c0 81 00       	add    $0x81c08c,%eax
  8022e4:	8b 00                	mov    (%eax),%eax
  8022e6:	8d 50 01             	lea    0x1(%eax),%edx
  8022e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022ec:	c1 e0 04             	shl    $0x4,%eax
  8022ef:	05 8c c0 81 00       	add    $0x81c08c,%eax
  8022f4:	89 10                	mov    %edx,(%eax)
	         break;
	     idx++;
	 }
	 // iterate over each blk and make and element of it by passing its address in blockElement pointer and save those in the list.
	 // starting from the page_va.
	 for (uint32 i = 0; i < blk_count; ++i) {
  8022f6:	ff 45 ec             	incl   -0x14(%ebp)
  8022f9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8022fc:	39 45 ec             	cmp    %eax,-0x14(%ebp)
  8022ff:	0f 82 4d ff ff ff    	jb     802252 <split_page_to_blocks+0x88>
	     struct BlockElement *blk =(struct BlockElement*)(page_va + i * blk_size);
	     LIST_INSERT_TAIL(&freeBlockLists[idx],blk);
	 }
 }
  802305:	90                   	nop
  802306:	c9                   	leave  
  802307:	c3                   	ret    

00802308 <alloc_block>:

//===========================
// 3) ALLOCATE BLOCK:
//===========================
void *alloc_block(uint32 size)
{
  802308:	55                   	push   %ebp
  802309:	89 e5                	mov    %esp,%ebp
  80230b:	83 ec 38             	sub    $0x38,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		assert(size <= DYN_ALLOC_MAX_BLOCK_SIZE);
  80230e:	81 7d 08 00 08 00 00 	cmpl   $0x800,0x8(%ebp)
  802315:	76 19                	jbe    802330 <alloc_block+0x28>
  802317:	68 a0 38 80 00       	push   $0x8038a0
  80231c:	68 66 38 80 00       	push   $0x803866
  802321:	68 8a 00 00 00       	push   $0x8a
  802326:	68 03 38 80 00       	push   $0x803803
  80232b:	e8 3c 07 00 00       	call   802a6c <_panic>
	//==================================================================================
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #3 alloc_block
	//Your code is here
	//Comment the following line
	// get index in freeBlockList by size.
	uint32 idx = 0;
  802330:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int i = LOG2_MIN_SIZE; i <= LOG2_MAX_SIZE; ++i){
  802337:	c7 45 f0 03 00 00 00 	movl   $0x3,-0x10(%ebp)
  80233e:	eb 19                	jmp    802359 <alloc_block+0x51>
		if((1 << i) >= size) break;
  802340:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802343:	ba 01 00 00 00       	mov    $0x1,%edx
  802348:	88 c1                	mov    %al,%cl
  80234a:	d3 e2                	shl    %cl,%edx
  80234c:	89 d0                	mov    %edx,%eax
  80234e:	3b 45 08             	cmp    0x8(%ebp),%eax
  802351:	73 0e                	jae    802361 <alloc_block+0x59>
		idx++;
  802353:	ff 45 f4             	incl   -0xc(%ebp)
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #3 alloc_block
	//Your code is here
	//Comment the following line
	// get index in freeBlockList by size.
	uint32 idx = 0;
	for (int i = LOG2_MIN_SIZE; i <= LOG2_MAX_SIZE; ++i){
  802356:	ff 45 f0             	incl   -0x10(%ebp)
  802359:	83 7d f0 0b          	cmpl   $0xb,-0x10(%ebp)
  80235d:	7e e1                	jle    802340 <alloc_block+0x38>
  80235f:	eb 01                	jmp    802362 <alloc_block+0x5a>
		if((1 << i) >= size) break;
  802361:	90                   	nop
		idx++;
	}

	//case 1: the free block of the cur size is available.
	if (freeBlockLists[idx].size > 0) {
  802362:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802365:	c1 e0 04             	shl    $0x4,%eax
  802368:	05 8c c0 81 00       	add    $0x81c08c,%eax
  80236d:	8b 00                	mov    (%eax),%eax
  80236f:	85 c0                	test   %eax,%eax
  802371:	0f 84 df 00 00 00    	je     802456 <alloc_block+0x14e>

		// remove from the list and updat the pageInfoArr free blocks.
		// pop from the freeBlockList.
		struct BlockElement *blk = LIST_FIRST(&freeBlockLists[idx]);
  802377:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80237a:	c1 e0 04             	shl    $0x4,%eax
  80237d:	05 80 c0 81 00       	add    $0x81c080,%eax
  802382:	8b 00                	mov    (%eax),%eax
  802384:	89 45 ec             	mov    %eax,-0x14(%ebp)
	    LIST_REMOVE(&freeBlockLists[idx], blk);
  802387:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80238b:	75 17                	jne    8023a4 <alloc_block+0x9c>
  80238d:	83 ec 04             	sub    $0x4,%esp
  802390:	68 c1 38 80 00       	push   $0x8038c1
  802395:	68 9e 00 00 00       	push   $0x9e
  80239a:	68 03 38 80 00       	push   $0x803803
  80239f:	e8 c8 06 00 00       	call   802a6c <_panic>
  8023a4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8023a7:	8b 00                	mov    (%eax),%eax
  8023a9:	85 c0                	test   %eax,%eax
  8023ab:	74 10                	je     8023bd <alloc_block+0xb5>
  8023ad:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8023b0:	8b 00                	mov    (%eax),%eax
  8023b2:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8023b5:	8b 52 04             	mov    0x4(%edx),%edx
  8023b8:	89 50 04             	mov    %edx,0x4(%eax)
  8023bb:	eb 14                	jmp    8023d1 <alloc_block+0xc9>
  8023bd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8023c0:	8b 40 04             	mov    0x4(%eax),%eax
  8023c3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8023c6:	c1 e2 04             	shl    $0x4,%edx
  8023c9:	81 c2 84 c0 81 00    	add    $0x81c084,%edx
  8023cf:	89 02                	mov    %eax,(%edx)
  8023d1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8023d4:	8b 40 04             	mov    0x4(%eax),%eax
  8023d7:	85 c0                	test   %eax,%eax
  8023d9:	74 0f                	je     8023ea <alloc_block+0xe2>
  8023db:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8023de:	8b 40 04             	mov    0x4(%eax),%eax
  8023e1:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8023e4:	8b 12                	mov    (%edx),%edx
  8023e6:	89 10                	mov    %edx,(%eax)
  8023e8:	eb 13                	jmp    8023fd <alloc_block+0xf5>
  8023ea:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8023ed:	8b 00                	mov    (%eax),%eax
  8023ef:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8023f2:	c1 e2 04             	shl    $0x4,%edx
  8023f5:	81 c2 80 c0 81 00    	add    $0x81c080,%edx
  8023fb:	89 02                	mov    %eax,(%edx)
  8023fd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802400:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802406:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802409:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802410:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802413:	c1 e0 04             	shl    $0x4,%eax
  802416:	05 8c c0 81 00       	add    $0x81c08c,%eax
  80241b:	8b 00                	mov    (%eax),%eax
  80241d:	8d 50 ff             	lea    -0x1(%eax),%edx
  802420:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802423:	c1 e0 04             	shl    $0x4,%eax
  802426:	05 8c c0 81 00       	add    $0x81c08c,%eax
  80242b:	89 10                	mov    %edx,(%eax)
	    // update pageBlockInfoArr
	    struct PageInfoElement *pageInfo = to_page_info((uint32)blk);
  80242d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802430:	83 ec 0c             	sub    $0xc,%esp
  802433:	50                   	push   %eax
  802434:	e8 8b fb ff ff       	call   801fc4 <to_page_info>
  802439:	83 c4 10             	add    $0x10,%esp
  80243c:	89 45 e8             	mov    %eax,-0x18(%ebp)
	    pageInfo->num_of_free_blocks--;
  80243f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802442:	66 8b 40 0a          	mov    0xa(%eax),%ax
  802446:	48                   	dec    %eax
  802447:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80244a:	66 89 42 0a          	mov    %ax,0xa(%edx)
	    return blk;
  80244e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802451:	e9 bc 02 00 00       	jmp    802712 <alloc_block+0x40a>
	}else{ //case(2, 3): 2. no free blocks available in the freeblocklist but there is free pages.
				//3. no free blocks and no available freepages so search in higher block sizes.
		// case 2:
		if(freePagesList.size > 0){ //have free pages.
  802456:	a1 54 40 80 00       	mov    0x804054,%eax
  80245b:	85 c0                	test   %eax,%eax
  80245d:	0f 84 7d 02 00 00    	je     8026e0 <alloc_block+0x3d8>
			// get page to split and use from freepagesList.
			struct PageInfoElement *ptr_new_page = LIST_FIRST(&freePagesList);
  802463:	a1 48 40 80 00       	mov    0x804048,%eax
  802468:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			LIST_REMOVE(&freePagesList, ptr_new_page);
  80246b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80246f:	75 17                	jne    802488 <alloc_block+0x180>
  802471:	83 ec 04             	sub    $0x4,%esp
  802474:	68 c1 38 80 00       	push   $0x8038c1
  802479:	68 a9 00 00 00       	push   $0xa9
  80247e:	68 03 38 80 00       	push   $0x803803
  802483:	e8 e4 05 00 00       	call   802a6c <_panic>
  802488:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80248b:	8b 00                	mov    (%eax),%eax
  80248d:	85 c0                	test   %eax,%eax
  80248f:	74 10                	je     8024a1 <alloc_block+0x199>
  802491:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802494:	8b 00                	mov    (%eax),%eax
  802496:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802499:	8b 52 04             	mov    0x4(%edx),%edx
  80249c:	89 50 04             	mov    %edx,0x4(%eax)
  80249f:	eb 0b                	jmp    8024ac <alloc_block+0x1a4>
  8024a1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8024a4:	8b 40 04             	mov    0x4(%eax),%eax
  8024a7:	a3 4c 40 80 00       	mov    %eax,0x80404c
  8024ac:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8024af:	8b 40 04             	mov    0x4(%eax),%eax
  8024b2:	85 c0                	test   %eax,%eax
  8024b4:	74 0f                	je     8024c5 <alloc_block+0x1bd>
  8024b6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8024b9:	8b 40 04             	mov    0x4(%eax),%eax
  8024bc:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8024bf:	8b 12                	mov    (%edx),%edx
  8024c1:	89 10                	mov    %edx,(%eax)
  8024c3:	eb 0a                	jmp    8024cf <alloc_block+0x1c7>
  8024c5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8024c8:	8b 00                	mov    (%eax),%eax
  8024ca:	a3 48 40 80 00       	mov    %eax,0x804048
  8024cf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8024d2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8024d8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8024db:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8024e2:	a1 54 40 80 00       	mov    0x804054,%eax
  8024e7:	48                   	dec    %eax
  8024e8:	a3 54 40 80 00       	mov    %eax,0x804054
			// from page to freeblockList by the pageInfo and the block size.
			split_page_to_blocks(1 << (idx + LOG2_MIN_SIZE), ptr_new_page);
  8024ed:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024f0:	83 c0 03             	add    $0x3,%eax
  8024f3:	ba 01 00 00 00       	mov    $0x1,%edx
  8024f8:	88 c1                	mov    %al,%cl
  8024fa:	d3 e2                	shl    %cl,%edx
  8024fc:	89 d0                	mov    %edx,%eax
  8024fe:	83 ec 08             	sub    $0x8,%esp
  802501:	ff 75 e4             	pushl  -0x1c(%ebp)
  802504:	50                   	push   %eax
  802505:	e8 c0 fc ff ff       	call   8021ca <split_page_to_blocks>
  80250a:	83 c4 10             	add    $0x10,%esp

			// remove from the list and updat the pageInfoArr free blocks.
			// pop from the freeBlockList.
			struct BlockElement *blk = LIST_FIRST(&freeBlockLists[idx]);
  80250d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802510:	c1 e0 04             	shl    $0x4,%eax
  802513:	05 80 c0 81 00       	add    $0x81c080,%eax
  802518:	8b 00                	mov    (%eax),%eax
  80251a:	89 45 e0             	mov    %eax,-0x20(%ebp)
		    LIST_REMOVE(&freeBlockLists[idx], blk);
  80251d:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  802521:	75 17                	jne    80253a <alloc_block+0x232>
  802523:	83 ec 04             	sub    $0x4,%esp
  802526:	68 c1 38 80 00       	push   $0x8038c1
  80252b:	68 b0 00 00 00       	push   $0xb0
  802530:	68 03 38 80 00       	push   $0x803803
  802535:	e8 32 05 00 00       	call   802a6c <_panic>
  80253a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80253d:	8b 00                	mov    (%eax),%eax
  80253f:	85 c0                	test   %eax,%eax
  802541:	74 10                	je     802553 <alloc_block+0x24b>
  802543:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802546:	8b 00                	mov    (%eax),%eax
  802548:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80254b:	8b 52 04             	mov    0x4(%edx),%edx
  80254e:	89 50 04             	mov    %edx,0x4(%eax)
  802551:	eb 14                	jmp    802567 <alloc_block+0x25f>
  802553:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802556:	8b 40 04             	mov    0x4(%eax),%eax
  802559:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80255c:	c1 e2 04             	shl    $0x4,%edx
  80255f:	81 c2 84 c0 81 00    	add    $0x81c084,%edx
  802565:	89 02                	mov    %eax,(%edx)
  802567:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80256a:	8b 40 04             	mov    0x4(%eax),%eax
  80256d:	85 c0                	test   %eax,%eax
  80256f:	74 0f                	je     802580 <alloc_block+0x278>
  802571:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802574:	8b 40 04             	mov    0x4(%eax),%eax
  802577:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80257a:	8b 12                	mov    (%edx),%edx
  80257c:	89 10                	mov    %edx,(%eax)
  80257e:	eb 13                	jmp    802593 <alloc_block+0x28b>
  802580:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802583:	8b 00                	mov    (%eax),%eax
  802585:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802588:	c1 e2 04             	shl    $0x4,%edx
  80258b:	81 c2 80 c0 81 00    	add    $0x81c080,%edx
  802591:	89 02                	mov    %eax,(%edx)
  802593:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802596:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80259c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80259f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8025a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025a9:	c1 e0 04             	shl    $0x4,%eax
  8025ac:	05 8c c0 81 00       	add    $0x81c08c,%eax
  8025b1:	8b 00                	mov    (%eax),%eax
  8025b3:	8d 50 ff             	lea    -0x1(%eax),%edx
  8025b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025b9:	c1 e0 04             	shl    $0x4,%eax
  8025bc:	05 8c c0 81 00       	add    $0x81c08c,%eax
  8025c1:	89 10                	mov    %edx,(%eax)
		    // update pageBlockInfoArr
		    struct PageInfoElement *pageInfo = to_page_info((uint32)blk);
  8025c3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8025c6:	83 ec 0c             	sub    $0xc,%esp
  8025c9:	50                   	push   %eax
  8025ca:	e8 f5 f9 ff ff       	call   801fc4 <to_page_info>
  8025cf:	83 c4 10             	add    $0x10,%esp
  8025d2:	89 45 dc             	mov    %eax,-0x24(%ebp)
		    pageInfo->num_of_free_blocks--;
  8025d5:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8025d8:	66 8b 40 0a          	mov    0xa(%eax),%ax
  8025dc:	48                   	dec    %eax
  8025dd:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8025e0:	66 89 42 0a          	mov    %ax,0xa(%edx)
		    return blk;
  8025e4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8025e7:	e9 26 01 00 00       	jmp    802712 <alloc_block+0x40a>
		}else{//case 3: no free block and no free page so iterate and try to find bigger size.
			// iterate over the list until finding available block
			while (idx <= (LOG2_MAX_SIZE - LOG2_MIN_SIZE) && freeBlockLists[idx].size == 0) {
				idx++;
  8025ec:	ff 45 f4             	incl   -0xc(%ebp)
				// found free block
				if(freeBlockLists[idx].size > 0){
  8025ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025f2:	c1 e0 04             	shl    $0x4,%eax
  8025f5:	05 8c c0 81 00       	add    $0x81c08c,%eax
  8025fa:	8b 00                	mov    (%eax),%eax
  8025fc:	85 c0                	test   %eax,%eax
  8025fe:	0f 84 dc 00 00 00    	je     8026e0 <alloc_block+0x3d8>
					// remove from the list and updat the pageInfoArr free blocks.
					// pop from the freeBlockList.
					struct BlockElement *blk = LIST_FIRST(&freeBlockLists[idx]);
  802604:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802607:	c1 e0 04             	shl    $0x4,%eax
  80260a:	05 80 c0 81 00       	add    $0x81c080,%eax
  80260f:	8b 00                	mov    (%eax),%eax
  802611:	89 45 d8             	mov    %eax,-0x28(%ebp)
				    LIST_REMOVE(&freeBlockLists[idx], blk);
  802614:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  802618:	75 17                	jne    802631 <alloc_block+0x329>
  80261a:	83 ec 04             	sub    $0x4,%esp
  80261d:	68 c1 38 80 00       	push   $0x8038c1
  802622:	68 be 00 00 00       	push   $0xbe
  802627:	68 03 38 80 00       	push   $0x803803
  80262c:	e8 3b 04 00 00       	call   802a6c <_panic>
  802631:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802634:	8b 00                	mov    (%eax),%eax
  802636:	85 c0                	test   %eax,%eax
  802638:	74 10                	je     80264a <alloc_block+0x342>
  80263a:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80263d:	8b 00                	mov    (%eax),%eax
  80263f:	8b 55 d8             	mov    -0x28(%ebp),%edx
  802642:	8b 52 04             	mov    0x4(%edx),%edx
  802645:	89 50 04             	mov    %edx,0x4(%eax)
  802648:	eb 14                	jmp    80265e <alloc_block+0x356>
  80264a:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80264d:	8b 40 04             	mov    0x4(%eax),%eax
  802650:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802653:	c1 e2 04             	shl    $0x4,%edx
  802656:	81 c2 84 c0 81 00    	add    $0x81c084,%edx
  80265c:	89 02                	mov    %eax,(%edx)
  80265e:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802661:	8b 40 04             	mov    0x4(%eax),%eax
  802664:	85 c0                	test   %eax,%eax
  802666:	74 0f                	je     802677 <alloc_block+0x36f>
  802668:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80266b:	8b 40 04             	mov    0x4(%eax),%eax
  80266e:	8b 55 d8             	mov    -0x28(%ebp),%edx
  802671:	8b 12                	mov    (%edx),%edx
  802673:	89 10                	mov    %edx,(%eax)
  802675:	eb 13                	jmp    80268a <alloc_block+0x382>
  802677:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80267a:	8b 00                	mov    (%eax),%eax
  80267c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80267f:	c1 e2 04             	shl    $0x4,%edx
  802682:	81 c2 80 c0 81 00    	add    $0x81c080,%edx
  802688:	89 02                	mov    %eax,(%edx)
  80268a:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80268d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802693:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802696:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80269d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026a0:	c1 e0 04             	shl    $0x4,%eax
  8026a3:	05 8c c0 81 00       	add    $0x81c08c,%eax
  8026a8:	8b 00                	mov    (%eax),%eax
  8026aa:	8d 50 ff             	lea    -0x1(%eax),%edx
  8026ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026b0:	c1 e0 04             	shl    $0x4,%eax
  8026b3:	05 8c c0 81 00       	add    $0x81c08c,%eax
  8026b8:	89 10                	mov    %edx,(%eax)
				    // update pageBlockInfoArr
				    struct PageInfoElement *pageInfo = to_page_info((uint32)blk);
  8026ba:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8026bd:	83 ec 0c             	sub    $0xc,%esp
  8026c0:	50                   	push   %eax
  8026c1:	e8 fe f8 ff ff       	call   801fc4 <to_page_info>
  8026c6:	83 c4 10             	add    $0x10,%esp
  8026c9:	89 45 d4             	mov    %eax,-0x2c(%ebp)
				    pageInfo->num_of_free_blocks--;
  8026cc:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8026cf:	66 8b 40 0a          	mov    0xa(%eax),%ax
  8026d3:	48                   	dec    %eax
  8026d4:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8026d7:	66 89 42 0a          	mov    %ax,0xa(%edx)
				    return blk;
  8026db:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8026de:	eb 32                	jmp    802712 <alloc_block+0x40a>
		    struct PageInfoElement *pageInfo = to_page_info((uint32)blk);
		    pageInfo->num_of_free_blocks--;
		    return blk;
		}else{//case 3: no free block and no free page so iterate and try to find bigger size.
			// iterate over the list until finding available block
			while (idx <= (LOG2_MAX_SIZE - LOG2_MIN_SIZE) && freeBlockLists[idx].size == 0) {
  8026e0:	83 7d f4 08          	cmpl   $0x8,-0xc(%ebp)
  8026e4:	77 15                	ja     8026fb <alloc_block+0x3f3>
  8026e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026e9:	c1 e0 04             	shl    $0x4,%eax
  8026ec:	05 8c c0 81 00       	add    $0x81c08c,%eax
  8026f1:	8b 00                	mov    (%eax),%eax
  8026f3:	85 c0                	test   %eax,%eax
  8026f5:	0f 84 f1 fe ff ff    	je     8025ec <alloc_block+0x2e4>
				}
			}
		}
	}
	//case4: no free blocks or pages.
	panic("no free blocks!");
  8026fb:	83 ec 04             	sub    $0x4,%esp
  8026fe:	68 df 38 80 00       	push   $0x8038df
  802703:	68 c8 00 00 00       	push   $0xc8
  802708:	68 03 38 80 00       	push   $0x803803
  80270d:	e8 5a 03 00 00       	call   802a6c <_panic>
	//panic("alloc_block() Not implemented yet");
	//TODO: [PROJECT'25.BONUS#1] DYNAMIC ALLOCATOR - block if no free block
	return NULL;
}
  802712:	c9                   	leave  
  802713:	c3                   	ret    

00802714 <free_block>:

//===========================
// [4] FREE BLOCK:
//===========================
void free_block(void *va)
{
  802714:	55                   	push   %ebp
  802715:	89 e5                	mov    %esp,%ebp
  802717:	83 ec 38             	sub    $0x38,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		assert((uint32)va >= dynAllocStart && (uint32)va < dynAllocEnd);
  80271a:	8b 55 08             	mov    0x8(%ebp),%edx
  80271d:	a1 64 c0 81 00       	mov    0x81c064,%eax
  802722:	39 c2                	cmp    %eax,%edx
  802724:	72 0c                	jb     802732 <free_block+0x1e>
  802726:	8b 55 08             	mov    0x8(%ebp),%edx
  802729:	a1 40 40 80 00       	mov    0x804040,%eax
  80272e:	39 c2                	cmp    %eax,%edx
  802730:	72 19                	jb     80274b <free_block+0x37>
  802732:	68 f0 38 80 00       	push   $0x8038f0
  802737:	68 66 38 80 00       	push   $0x803866
  80273c:	68 d7 00 00 00       	push   $0xd7
  802741:	68 03 38 80 00       	push   $0x803803
  802746:	e8 21 03 00 00       	call   802a6c <_panic>
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #4 free_block
	//Your code is here
	//Comment the following line
	// va of a piece in memory to free so:
	// 1. get its page, and make blk with this address to be put in the freeBlockList.
	struct BlockElement* blk_to_free = (struct BlockElement*)va;
  80274b:	8b 45 08             	mov    0x8(%ebp),%eax
  80274e:	89 45 e8             	mov    %eax,-0x18(%ebp)
	struct PageInfoElement *pageInfo = to_page_info((uint32)va);
  802751:	8b 45 08             	mov    0x8(%ebp),%eax
  802754:	83 ec 0c             	sub    $0xc,%esp
  802757:	50                   	push   %eax
  802758:	e8 67 f8 ff ff       	call   801fc4 <to_page_info>
  80275d:	83 c4 10             	add    $0x10,%esp
  802760:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	uint32 blk_size = pageInfo->block_size;
  802763:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802766:	8b 40 08             	mov    0x8(%eax),%eax
  802769:	0f b7 c0             	movzwl %ax,%eax
  80276c:	89 45 e0             	mov    %eax,-0x20(%ebp)

	// its index in the freeBlocklist.
	int idx = 0;
  80276f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int i = LOG2_MIN_SIZE; i <= LOG2_MAX_SIZE; i++) {
  802776:	c7 45 f0 03 00 00 00 	movl   $0x3,-0x10(%ebp)
  80277d:	eb 19                	jmp    802798 <free_block+0x84>
	    if ((1 << i) == blk_size)
  80277f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802782:	ba 01 00 00 00       	mov    $0x1,%edx
  802787:	88 c1                	mov    %al,%cl
  802789:	d3 e2                	shl    %cl,%edx
  80278b:	89 d0                	mov    %edx,%eax
  80278d:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  802790:	74 0e                	je     8027a0 <free_block+0x8c>
	        break;
	    idx++;
  802792:	ff 45 f4             	incl   -0xc(%ebp)
	struct PageInfoElement *pageInfo = to_page_info((uint32)va);
	uint32 blk_size = pageInfo->block_size;

	// its index in the freeBlocklist.
	int idx = 0;
	for (int i = LOG2_MIN_SIZE; i <= LOG2_MAX_SIZE; i++) {
  802795:	ff 45 f0             	incl   -0x10(%ebp)
  802798:	83 7d f0 0b          	cmpl   $0xb,-0x10(%ebp)
  80279c:	7e e1                	jle    80277f <free_block+0x6b>
  80279e:	eb 01                	jmp    8027a1 <free_block+0x8d>
	    if ((1 << i) == blk_size)
	        break;
  8027a0:	90                   	nop
	    idx++;
	}

	pageInfo->num_of_free_blocks++;
  8027a1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8027a4:	66 8b 40 0a          	mov    0xa(%eax),%ax
  8027a8:	40                   	inc    %eax
  8027a9:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8027ac:	66 89 42 0a          	mov    %ax,0xa(%edx)
	LIST_INSERT_TAIL(&freeBlockLists[idx], blk_to_free);
  8027b0:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8027b4:	75 17                	jne    8027cd <free_block+0xb9>
  8027b6:	83 ec 04             	sub    $0x4,%esp
  8027b9:	68 7c 38 80 00       	push   $0x80387c
  8027be:	68 ee 00 00 00       	push   $0xee
  8027c3:	68 03 38 80 00       	push   $0x803803
  8027c8:	e8 9f 02 00 00       	call   802a6c <_panic>
  8027cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027d0:	c1 e0 04             	shl    $0x4,%eax
  8027d3:	05 84 c0 81 00       	add    $0x81c084,%eax
  8027d8:	8b 10                	mov    (%eax),%edx
  8027da:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8027dd:	89 50 04             	mov    %edx,0x4(%eax)
  8027e0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8027e3:	8b 40 04             	mov    0x4(%eax),%eax
  8027e6:	85 c0                	test   %eax,%eax
  8027e8:	74 14                	je     8027fe <free_block+0xea>
  8027ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027ed:	c1 e0 04             	shl    $0x4,%eax
  8027f0:	05 84 c0 81 00       	add    $0x81c084,%eax
  8027f5:	8b 00                	mov    (%eax),%eax
  8027f7:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8027fa:	89 10                	mov    %edx,(%eax)
  8027fc:	eb 11                	jmp    80280f <free_block+0xfb>
  8027fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802801:	c1 e0 04             	shl    $0x4,%eax
  802804:	8d 90 80 c0 81 00    	lea    0x81c080(%eax),%edx
  80280a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80280d:	89 02                	mov    %eax,(%edx)
  80280f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802812:	c1 e0 04             	shl    $0x4,%eax
  802815:	8d 90 84 c0 81 00    	lea    0x81c084(%eax),%edx
  80281b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80281e:	89 02                	mov    %eax,(%edx)
  802820:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802823:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802829:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80282c:	c1 e0 04             	shl    $0x4,%eax
  80282f:	05 8c c0 81 00       	add    $0x81c08c,%eax
  802834:	8b 00                	mov    (%eax),%eax
  802836:	8d 50 01             	lea    0x1(%eax),%edx
  802839:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80283c:	c1 e0 04             	shl    $0x4,%eax
  80283f:	05 8c c0 81 00       	add    $0x81c08c,%eax
  802844:	89 10                	mov    %edx,(%eax)

	// now, case 1: the page all blocks are freed so you free the page.
	int blk_count = PAGE_SIZE / blk_size;
  802846:	b8 00 10 00 00       	mov    $0x1000,%eax
  80284b:	ba 00 00 00 00       	mov    $0x0,%edx
  802850:	f7 75 e0             	divl   -0x20(%ebp)
  802853:	89 45 dc             	mov    %eax,-0x24(%ebp)
	// the blk count in the page is same as number fo free blocks free up the page.
	if (pageInfo->num_of_free_blocks == blk_count) {
  802856:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802859:	66 8b 40 0a          	mov    0xa(%eax),%ax
  80285d:	0f b7 c0             	movzwl %ax,%eax
  802860:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  802863:	0f 85 70 01 00 00    	jne    8029d9 <free_block+0x2c5>
		uint32 page_va = to_page_va(pageInfo);
  802869:	83 ec 0c             	sub    $0xc,%esp
  80286c:	ff 75 e4             	pushl  -0x1c(%ebp)
  80286f:	e8 de f6 ff ff       	call   801f52 <to_page_va>
  802874:	83 c4 10             	add    $0x10,%esp
  802877:	89 45 d8             	mov    %eax,-0x28(%ebp)
		// remove all blk in the freeBlockList.
		for (uint32 off = 0; off < PAGE_SIZE; off += blk_size) {
  80287a:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  802881:	e9 b7 00 00 00       	jmp    80293d <free_block+0x229>
			struct BlockElement *blk = (struct BlockElement*)(page_va + off);
  802886:	8b 55 d8             	mov    -0x28(%ebp),%edx
  802889:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80288c:	01 d0                	add    %edx,%eax
  80288e:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			LIST_REMOVE(&freeBlockLists[idx], blk);
  802891:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  802895:	75 17                	jne    8028ae <free_block+0x19a>
  802897:	83 ec 04             	sub    $0x4,%esp
  80289a:	68 c1 38 80 00       	push   $0x8038c1
  80289f:	68 f8 00 00 00       	push   $0xf8
  8028a4:	68 03 38 80 00       	push   $0x803803
  8028a9:	e8 be 01 00 00       	call   802a6c <_panic>
  8028ae:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8028b1:	8b 00                	mov    (%eax),%eax
  8028b3:	85 c0                	test   %eax,%eax
  8028b5:	74 10                	je     8028c7 <free_block+0x1b3>
  8028b7:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8028ba:	8b 00                	mov    (%eax),%eax
  8028bc:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8028bf:	8b 52 04             	mov    0x4(%edx),%edx
  8028c2:	89 50 04             	mov    %edx,0x4(%eax)
  8028c5:	eb 14                	jmp    8028db <free_block+0x1c7>
  8028c7:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8028ca:	8b 40 04             	mov    0x4(%eax),%eax
  8028cd:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8028d0:	c1 e2 04             	shl    $0x4,%edx
  8028d3:	81 c2 84 c0 81 00    	add    $0x81c084,%edx
  8028d9:	89 02                	mov    %eax,(%edx)
  8028db:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8028de:	8b 40 04             	mov    0x4(%eax),%eax
  8028e1:	85 c0                	test   %eax,%eax
  8028e3:	74 0f                	je     8028f4 <free_block+0x1e0>
  8028e5:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8028e8:	8b 40 04             	mov    0x4(%eax),%eax
  8028eb:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8028ee:	8b 12                	mov    (%edx),%edx
  8028f0:	89 10                	mov    %edx,(%eax)
  8028f2:	eb 13                	jmp    802907 <free_block+0x1f3>
  8028f4:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8028f7:	8b 00                	mov    (%eax),%eax
  8028f9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8028fc:	c1 e2 04             	shl    $0x4,%edx
  8028ff:	81 c2 80 c0 81 00    	add    $0x81c080,%edx
  802905:	89 02                	mov    %eax,(%edx)
  802907:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80290a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802910:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802913:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80291a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80291d:	c1 e0 04             	shl    $0x4,%eax
  802920:	05 8c c0 81 00       	add    $0x81c08c,%eax
  802925:	8b 00                	mov    (%eax),%eax
  802927:	8d 50 ff             	lea    -0x1(%eax),%edx
  80292a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80292d:	c1 e0 04             	shl    $0x4,%eax
  802930:	05 8c c0 81 00       	add    $0x81c08c,%eax
  802935:	89 10                	mov    %edx,(%eax)
	int blk_count = PAGE_SIZE / blk_size;
	// the blk count in the page is same as number fo free blocks free up the page.
	if (pageInfo->num_of_free_blocks == blk_count) {
		uint32 page_va = to_page_va(pageInfo);
		// remove all blk in the freeBlockList.
		for (uint32 off = 0; off < PAGE_SIZE; off += blk_size) {
  802937:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80293a:	01 45 ec             	add    %eax,-0x14(%ebp)
  80293d:	81 7d ec ff 0f 00 00 	cmpl   $0xfff,-0x14(%ebp)
  802944:	0f 86 3c ff ff ff    	jbe    802886 <free_block+0x172>
			struct BlockElement *blk = (struct BlockElement*)(page_va + off);
			LIST_REMOVE(&freeBlockLists[idx], blk);
		}
		// reset page info.
		pageInfo->block_size = 0;
  80294a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80294d:	66 c7 40 08 00 00    	movw   $0x0,0x8(%eax)
		pageInfo->num_of_free_blocks = 0;
  802953:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802956:	66 c7 40 0a 00 00    	movw   $0x0,0xa(%eax)
		// add it to the available pages.
		LIST_INSERT_TAIL(&freePagesList, pageInfo);
  80295c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  802960:	75 17                	jne    802979 <free_block+0x265>
  802962:	83 ec 04             	sub    $0x4,%esp
  802965:	68 7c 38 80 00       	push   $0x80387c
  80296a:	68 fe 00 00 00       	push   $0xfe
  80296f:	68 03 38 80 00       	push   $0x803803
  802974:	e8 f3 00 00 00       	call   802a6c <_panic>
  802979:	8b 15 4c 40 80 00    	mov    0x80404c,%edx
  80297f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802982:	89 50 04             	mov    %edx,0x4(%eax)
  802985:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802988:	8b 40 04             	mov    0x4(%eax),%eax
  80298b:	85 c0                	test   %eax,%eax
  80298d:	74 0c                	je     80299b <free_block+0x287>
  80298f:	a1 4c 40 80 00       	mov    0x80404c,%eax
  802994:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802997:	89 10                	mov    %edx,(%eax)
  802999:	eb 08                	jmp    8029a3 <free_block+0x28f>
  80299b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80299e:	a3 48 40 80 00       	mov    %eax,0x804048
  8029a3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8029a6:	a3 4c 40 80 00       	mov    %eax,0x80404c
  8029ab:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8029ae:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8029b4:	a1 54 40 80 00       	mov    0x804054,%eax
  8029b9:	40                   	inc    %eax
  8029ba:	a3 54 40 80 00       	mov    %eax,0x804054
		// make it available in memory.
		return_page((uint32 *)to_page_va(pageInfo));
  8029bf:	83 ec 0c             	sub    $0xc,%esp
  8029c2:	ff 75 e4             	pushl  -0x1c(%ebp)
  8029c5:	e8 88 f5 ff ff       	call   801f52 <to_page_va>
  8029ca:	83 c4 10             	add    $0x10,%esp
  8029cd:	83 ec 0c             	sub    $0xc,%esp
  8029d0:	50                   	push   %eax
  8029d1:	e8 b8 ee ff ff       	call   80188e <return_page>
  8029d6:	83 c4 10             	add    $0x10,%esp
	}
	//panic("free_block() Not implemented yet");
}
  8029d9:	90                   	nop
  8029da:	c9                   	leave  
  8029db:	c3                   	ret    

008029dc <realloc_block>:

//===========================
// [1] REALLOCATE BLOCK:
//===========================
void *realloc_block(void* va, uint32 new_size)
{
  8029dc:	55                   	push   %ebp
  8029dd:	89 e5                	mov    %esp,%ebp
  8029df:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.BONUS#2] KERNEL REALLOC - realloc_block
	//Your code is here
	//Comment the following line
	panic("realloc_block() Not implemented yet");
  8029e2:	83 ec 04             	sub    $0x4,%esp
  8029e5:	68 28 39 80 00       	push   $0x803928
  8029ea:	68 11 01 00 00       	push   $0x111
  8029ef:	68 03 38 80 00       	push   $0x803803
  8029f4:	e8 73 00 00 00       	call   802a6c <_panic>

008029f9 <create_semaphore>:
// User-level Semaphore

#include "inc/lib.h"

struct semaphore create_semaphore(char *semaphoreName, uint32 value)
{
  8029f9:	55                   	push   %ebp
  8029fa:	89 e5                	mov    %esp,%ebp
  8029fc:	83 ec 08             	sub    $0x8,%esp
	panic("create_semaphore() is not implemented yet...!!");
  8029ff:	83 ec 04             	sub    $0x4,%esp
  802a02:	68 4c 39 80 00       	push   $0x80394c
  802a07:	6a 07                	push   $0x7
  802a09:	68 7b 39 80 00       	push   $0x80397b
  802a0e:	e8 59 00 00 00       	call   802a6c <_panic>

00802a13 <get_semaphore>:
}
struct semaphore get_semaphore(int32 ownerEnvID, char* semaphoreName)
{
  802a13:	55                   	push   %ebp
  802a14:	89 e5                	mov    %esp,%ebp
  802a16:	83 ec 08             	sub    $0x8,%esp
	panic("get_semaphore() is not implemented yet...!!");
  802a19:	83 ec 04             	sub    $0x4,%esp
  802a1c:	68 8c 39 80 00       	push   $0x80398c
  802a21:	6a 0b                	push   $0xb
  802a23:	68 7b 39 80 00       	push   $0x80397b
  802a28:	e8 3f 00 00 00       	call   802a6c <_panic>

00802a2d <wait_semaphore>:
}

void wait_semaphore(struct semaphore sem)
{
  802a2d:	55                   	push   %ebp
  802a2e:	89 e5                	mov    %esp,%ebp
  802a30:	83 ec 08             	sub    $0x8,%esp
	panic("wait_semaphore() is not implemented yet...!!");
  802a33:	83 ec 04             	sub    $0x4,%esp
  802a36:	68 b8 39 80 00       	push   $0x8039b8
  802a3b:	6a 10                	push   $0x10
  802a3d:	68 7b 39 80 00       	push   $0x80397b
  802a42:	e8 25 00 00 00       	call   802a6c <_panic>

00802a47 <signal_semaphore>:
}

void signal_semaphore(struct semaphore sem)
{
  802a47:	55                   	push   %ebp
  802a48:	89 e5                	mov    %esp,%ebp
  802a4a:	83 ec 08             	sub    $0x8,%esp
	panic("signal_semaphore() is not implemented yet...!!");
  802a4d:	83 ec 04             	sub    $0x4,%esp
  802a50:	68 e8 39 80 00       	push   $0x8039e8
  802a55:	6a 15                	push   $0x15
  802a57:	68 7b 39 80 00       	push   $0x80397b
  802a5c:	e8 0b 00 00 00       	call   802a6c <_panic>

00802a61 <semaphore_count>:
}

int semaphore_count(struct semaphore sem)
{
  802a61:	55                   	push   %ebp
  802a62:	89 e5                	mov    %esp,%ebp
	return sem.semdata->count;
  802a64:	8b 45 08             	mov    0x8(%ebp),%eax
  802a67:	8b 40 10             	mov    0x10(%eax),%eax
}
  802a6a:	5d                   	pop    %ebp
  802a6b:	c3                   	ret    

00802a6c <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  802a6c:	55                   	push   %ebp
  802a6d:	89 e5                	mov    %esp,%ebp
  802a6f:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  802a72:	8d 45 10             	lea    0x10(%ebp),%eax
  802a75:	83 c0 04             	add    $0x4,%eax
  802a78:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  802a7b:	a1 1c c1 81 00       	mov    0x81c11c,%eax
  802a80:	85 c0                	test   %eax,%eax
  802a82:	74 16                	je     802a9a <_panic+0x2e>
		cprintf("%s: ", argv0);
  802a84:	a1 1c c1 81 00       	mov    0x81c11c,%eax
  802a89:	83 ec 08             	sub    $0x8,%esp
  802a8c:	50                   	push   %eax
  802a8d:	68 18 3a 80 00       	push   $0x803a18
  802a92:	e8 75 de ff ff       	call   80090c <cprintf>
  802a97:	83 c4 10             	add    $0x10,%esp
	cprintf_colored(TEXT_PANIC_CLR, "user [EVAL_FINAL]panic in %s at %s:%d: ", binaryname, file, line);
  802a9a:	a1 04 40 80 00       	mov    0x804004,%eax
  802a9f:	83 ec 0c             	sub    $0xc,%esp
  802aa2:	ff 75 0c             	pushl  0xc(%ebp)
  802aa5:	ff 75 08             	pushl  0x8(%ebp)
  802aa8:	50                   	push   %eax
  802aa9:	68 20 3a 80 00       	push   $0x803a20
  802aae:	6a 74                	push   $0x74
  802ab0:	e8 84 de ff ff       	call   800939 <cprintf_colored>
  802ab5:	83 c4 20             	add    $0x20,%esp
	vcprintf(fmt, ap);
  802ab8:	8b 45 10             	mov    0x10(%ebp),%eax
  802abb:	83 ec 08             	sub    $0x8,%esp
  802abe:	ff 75 f4             	pushl  -0xc(%ebp)
  802ac1:	50                   	push   %eax
  802ac2:	e8 d6 dd ff ff       	call   80089d <vcprintf>
  802ac7:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  802aca:	83 ec 08             	sub    $0x8,%esp
  802acd:	6a 00                	push   $0x0
  802acf:	68 48 3a 80 00       	push   $0x803a48
  802ad4:	e8 c4 dd ff ff       	call   80089d <vcprintf>
  802ad9:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  802adc:	e8 3d dd ff ff       	call   80081e <exit>

	// should not return here
	while (1) ;
  802ae1:	eb fe                	jmp    802ae1 <_panic+0x75>

00802ae3 <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  802ae3:	55                   	push   %ebp
  802ae4:	89 e5                	mov    %esp,%ebp
  802ae6:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  802ae9:	a1 20 40 80 00       	mov    0x804020,%eax
  802aee:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  802af4:	8b 45 0c             	mov    0xc(%ebp),%eax
  802af7:	39 c2                	cmp    %eax,%edx
  802af9:	74 14                	je     802b0f <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  802afb:	83 ec 04             	sub    $0x4,%esp
  802afe:	68 4c 3a 80 00       	push   $0x803a4c
  802b03:	6a 26                	push   $0x26
  802b05:	68 98 3a 80 00       	push   $0x803a98
  802b0a:	e8 5d ff ff ff       	call   802a6c <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  802b0f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  802b16:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  802b1d:	e9 c5 00 00 00       	jmp    802be7 <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  802b22:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b25:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  802b2c:	8b 45 08             	mov    0x8(%ebp),%eax
  802b2f:	01 d0                	add    %edx,%eax
  802b31:	8b 00                	mov    (%eax),%eax
  802b33:	85 c0                	test   %eax,%eax
  802b35:	75 08                	jne    802b3f <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  802b37:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  802b3a:	e9 a5 00 00 00       	jmp    802be4 <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  802b3f:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  802b46:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  802b4d:	eb 69                	jmp    802bb8 <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  802b4f:	a1 20 40 80 00       	mov    0x804020,%eax
  802b54:	8b 88 38 da 01 00    	mov    0x1da38(%eax),%ecx
  802b5a:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802b5d:	89 d0                	mov    %edx,%eax
  802b5f:	01 c0                	add    %eax,%eax
  802b61:	01 d0                	add    %edx,%eax
  802b63:	c1 e0 03             	shl    $0x3,%eax
  802b66:	01 c8                	add    %ecx,%eax
  802b68:	8a 40 04             	mov    0x4(%eax),%al
  802b6b:	84 c0                	test   %al,%al
  802b6d:	75 46                	jne    802bb5 <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  802b6f:	a1 20 40 80 00       	mov    0x804020,%eax
  802b74:	8b 88 38 da 01 00    	mov    0x1da38(%eax),%ecx
  802b7a:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802b7d:	89 d0                	mov    %edx,%eax
  802b7f:	01 c0                	add    %eax,%eax
  802b81:	01 d0                	add    %edx,%eax
  802b83:	c1 e0 03             	shl    $0x3,%eax
  802b86:	01 c8                	add    %ecx,%eax
  802b88:	8b 00                	mov    (%eax),%eax
  802b8a:	89 45 dc             	mov    %eax,-0x24(%ebp)
  802b8d:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802b90:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  802b95:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  802b97:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b9a:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  802ba1:	8b 45 08             	mov    0x8(%ebp),%eax
  802ba4:	01 c8                	add    %ecx,%eax
  802ba6:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  802ba8:	39 c2                	cmp    %eax,%edx
  802baa:	75 09                	jne    802bb5 <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  802bac:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  802bb3:	eb 15                	jmp    802bca <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  802bb5:	ff 45 e8             	incl   -0x18(%ebp)
  802bb8:	a1 20 40 80 00       	mov    0x804020,%eax
  802bbd:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  802bc3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802bc6:	39 c2                	cmp    %eax,%edx
  802bc8:	77 85                	ja     802b4f <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  802bca:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802bce:	75 14                	jne    802be4 <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  802bd0:	83 ec 04             	sub    $0x4,%esp
  802bd3:	68 a4 3a 80 00       	push   $0x803aa4
  802bd8:	6a 3a                	push   $0x3a
  802bda:	68 98 3a 80 00       	push   $0x803a98
  802bdf:	e8 88 fe ff ff       	call   802a6c <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  802be4:	ff 45 f0             	incl   -0x10(%ebp)
  802be7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bea:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802bed:	0f 8c 2f ff ff ff    	jl     802b22 <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  802bf3:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  802bfa:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  802c01:	eb 26                	jmp    802c29 <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  802c03:	a1 20 40 80 00       	mov    0x804020,%eax
  802c08:	8b 88 38 da 01 00    	mov    0x1da38(%eax),%ecx
  802c0e:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802c11:	89 d0                	mov    %edx,%eax
  802c13:	01 c0                	add    %eax,%eax
  802c15:	01 d0                	add    %edx,%eax
  802c17:	c1 e0 03             	shl    $0x3,%eax
  802c1a:	01 c8                	add    %ecx,%eax
  802c1c:	8a 40 04             	mov    0x4(%eax),%al
  802c1f:	3c 01                	cmp    $0x1,%al
  802c21:	75 03                	jne    802c26 <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  802c23:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  802c26:	ff 45 e0             	incl   -0x20(%ebp)
  802c29:	a1 20 40 80 00       	mov    0x804020,%eax
  802c2e:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  802c34:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802c37:	39 c2                	cmp    %eax,%edx
  802c39:	77 c8                	ja     802c03 <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  802c3b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c3e:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  802c41:	74 14                	je     802c57 <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  802c43:	83 ec 04             	sub    $0x4,%esp
  802c46:	68 f8 3a 80 00       	push   $0x803af8
  802c4b:	6a 44                	push   $0x44
  802c4d:	68 98 3a 80 00       	push   $0x803a98
  802c52:	e8 15 fe ff ff       	call   802a6c <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  802c57:	90                   	nop
  802c58:	c9                   	leave  
  802c59:	c3                   	ret    
  802c5a:	66 90                	xchg   %ax,%ax

00802c5c <__divdi3>:
  802c5c:	55                   	push   %ebp
  802c5d:	57                   	push   %edi
  802c5e:	56                   	push   %esi
  802c5f:	53                   	push   %ebx
  802c60:	83 ec 1c             	sub    $0x1c,%esp
  802c63:	8b 44 24 30          	mov    0x30(%esp),%eax
  802c67:	8b 54 24 34          	mov    0x34(%esp),%edx
  802c6b:	8b 74 24 38          	mov    0x38(%esp),%esi
  802c6f:	8b 7c 24 3c          	mov    0x3c(%esp),%edi
  802c73:	89 f9                	mov    %edi,%ecx
  802c75:	85 d2                	test   %edx,%edx
  802c77:	0f 88 bb 00 00 00    	js     802d38 <__divdi3+0xdc>
  802c7d:	31 ed                	xor    %ebp,%ebp
  802c7f:	85 c9                	test   %ecx,%ecx
  802c81:	0f 88 99 00 00 00    	js     802d20 <__divdi3+0xc4>
  802c87:	89 34 24             	mov    %esi,(%esp)
  802c8a:	89 7c 24 04          	mov    %edi,0x4(%esp)
  802c8e:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802c92:	89 d3                	mov    %edx,%ebx
  802c94:	8b 34 24             	mov    (%esp),%esi
  802c97:	8b 7c 24 04          	mov    0x4(%esp),%edi
  802c9b:	89 74 24 08          	mov    %esi,0x8(%esp)
  802c9f:	8b 34 24             	mov    (%esp),%esi
  802ca2:	89 c1                	mov    %eax,%ecx
  802ca4:	85 ff                	test   %edi,%edi
  802ca6:	75 10                	jne    802cb8 <__divdi3+0x5c>
  802ca8:	8b 7c 24 08          	mov    0x8(%esp),%edi
  802cac:	39 d7                	cmp    %edx,%edi
  802cae:	76 4c                	jbe    802cfc <__divdi3+0xa0>
  802cb0:	f7 f7                	div    %edi
  802cb2:	89 c1                	mov    %eax,%ecx
  802cb4:	31 f6                	xor    %esi,%esi
  802cb6:	eb 08                	jmp    802cc0 <__divdi3+0x64>
  802cb8:	39 d7                	cmp    %edx,%edi
  802cba:	76 1c                	jbe    802cd8 <__divdi3+0x7c>
  802cbc:	31 f6                	xor    %esi,%esi
  802cbe:	31 c9                	xor    %ecx,%ecx
  802cc0:	89 c8                	mov    %ecx,%eax
  802cc2:	89 f2                	mov    %esi,%edx
  802cc4:	85 ed                	test   %ebp,%ebp
  802cc6:	74 07                	je     802ccf <__divdi3+0x73>
  802cc8:	f7 d8                	neg    %eax
  802cca:	83 d2 00             	adc    $0x0,%edx
  802ccd:	f7 da                	neg    %edx
  802ccf:	83 c4 1c             	add    $0x1c,%esp
  802cd2:	5b                   	pop    %ebx
  802cd3:	5e                   	pop    %esi
  802cd4:	5f                   	pop    %edi
  802cd5:	5d                   	pop    %ebp
  802cd6:	c3                   	ret    
  802cd7:	90                   	nop
  802cd8:	0f bd f7             	bsr    %edi,%esi
  802cdb:	83 f6 1f             	xor    $0x1f,%esi
  802cde:	75 6c                	jne    802d4c <__divdi3+0xf0>
  802ce0:	39 d7                	cmp    %edx,%edi
  802ce2:	72 0e                	jb     802cf2 <__divdi3+0x96>
  802ce4:	8b 7c 24 0c          	mov    0xc(%esp),%edi
  802ce8:	39 7c 24 08          	cmp    %edi,0x8(%esp)
  802cec:	0f 87 ca 00 00 00    	ja     802dbc <__divdi3+0x160>
  802cf2:	b9 01 00 00 00       	mov    $0x1,%ecx
  802cf7:	eb c7                	jmp    802cc0 <__divdi3+0x64>
  802cf9:	8d 76 00             	lea    0x0(%esi),%esi
  802cfc:	85 f6                	test   %esi,%esi
  802cfe:	75 0b                	jne    802d0b <__divdi3+0xaf>
  802d00:	b8 01 00 00 00       	mov    $0x1,%eax
  802d05:	31 d2                	xor    %edx,%edx
  802d07:	f7 f6                	div    %esi
  802d09:	89 c6                	mov    %eax,%esi
  802d0b:	31 d2                	xor    %edx,%edx
  802d0d:	89 d8                	mov    %ebx,%eax
  802d0f:	f7 f6                	div    %esi
  802d11:	89 c7                	mov    %eax,%edi
  802d13:	89 c8                	mov    %ecx,%eax
  802d15:	f7 f6                	div    %esi
  802d17:	89 c1                	mov    %eax,%ecx
  802d19:	89 fe                	mov    %edi,%esi
  802d1b:	eb a3                	jmp    802cc0 <__divdi3+0x64>
  802d1d:	8d 76 00             	lea    0x0(%esi),%esi
  802d20:	f7 d5                	not    %ebp
  802d22:	f7 de                	neg    %esi
  802d24:	83 d7 00             	adc    $0x0,%edi
  802d27:	f7 df                	neg    %edi
  802d29:	89 34 24             	mov    %esi,(%esp)
  802d2c:	89 7c 24 04          	mov    %edi,0x4(%esp)
  802d30:	e9 59 ff ff ff       	jmp    802c8e <__divdi3+0x32>
  802d35:	8d 76 00             	lea    0x0(%esi),%esi
  802d38:	f7 d8                	neg    %eax
  802d3a:	83 d2 00             	adc    $0x0,%edx
  802d3d:	f7 da                	neg    %edx
  802d3f:	bd ff ff ff ff       	mov    $0xffffffff,%ebp
  802d44:	e9 36 ff ff ff       	jmp    802c7f <__divdi3+0x23>
  802d49:	8d 76 00             	lea    0x0(%esi),%esi
  802d4c:	b8 20 00 00 00       	mov    $0x20,%eax
  802d51:	29 f0                	sub    %esi,%eax
  802d53:	89 f1                	mov    %esi,%ecx
  802d55:	d3 e7                	shl    %cl,%edi
  802d57:	8b 54 24 08          	mov    0x8(%esp),%edx
  802d5b:	88 c1                	mov    %al,%cl
  802d5d:	d3 ea                	shr    %cl,%edx
  802d5f:	89 d1                	mov    %edx,%ecx
  802d61:	09 f9                	or     %edi,%ecx
  802d63:	89 0c 24             	mov    %ecx,(%esp)
  802d66:	8b 54 24 08          	mov    0x8(%esp),%edx
  802d6a:	89 f1                	mov    %esi,%ecx
  802d6c:	d3 e2                	shl    %cl,%edx
  802d6e:	89 54 24 08          	mov    %edx,0x8(%esp)
  802d72:	89 df                	mov    %ebx,%edi
  802d74:	88 c1                	mov    %al,%cl
  802d76:	d3 ef                	shr    %cl,%edi
  802d78:	89 f1                	mov    %esi,%ecx
  802d7a:	d3 e3                	shl    %cl,%ebx
  802d7c:	8b 54 24 0c          	mov    0xc(%esp),%edx
  802d80:	88 c1                	mov    %al,%cl
  802d82:	d3 ea                	shr    %cl,%edx
  802d84:	09 d3                	or     %edx,%ebx
  802d86:	89 d8                	mov    %ebx,%eax
  802d88:	89 fa                	mov    %edi,%edx
  802d8a:	f7 34 24             	divl   (%esp)
  802d8d:	89 d1                	mov    %edx,%ecx
  802d8f:	89 c3                	mov    %eax,%ebx
  802d91:	f7 64 24 08          	mull   0x8(%esp)
  802d95:	39 d1                	cmp    %edx,%ecx
  802d97:	72 17                	jb     802db0 <__divdi3+0x154>
  802d99:	74 09                	je     802da4 <__divdi3+0x148>
  802d9b:	89 d9                	mov    %ebx,%ecx
  802d9d:	31 f6                	xor    %esi,%esi
  802d9f:	e9 1c ff ff ff       	jmp    802cc0 <__divdi3+0x64>
  802da4:	8b 54 24 0c          	mov    0xc(%esp),%edx
  802da8:	89 f1                	mov    %esi,%ecx
  802daa:	d3 e2                	shl    %cl,%edx
  802dac:	39 c2                	cmp    %eax,%edx
  802dae:	73 eb                	jae    802d9b <__divdi3+0x13f>
  802db0:	8d 4b ff             	lea    -0x1(%ebx),%ecx
  802db3:	31 f6                	xor    %esi,%esi
  802db5:	e9 06 ff ff ff       	jmp    802cc0 <__divdi3+0x64>
  802dba:	66 90                	xchg   %ax,%ax
  802dbc:	31 c9                	xor    %ecx,%ecx
  802dbe:	e9 fd fe ff ff       	jmp    802cc0 <__divdi3+0x64>
  802dc3:	90                   	nop

00802dc4 <__udivdi3>:
  802dc4:	55                   	push   %ebp
  802dc5:	57                   	push   %edi
  802dc6:	56                   	push   %esi
  802dc7:	53                   	push   %ebx
  802dc8:	83 ec 1c             	sub    $0x1c,%esp
  802dcb:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  802dcf:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  802dd3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  802dd7:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802ddb:	89 ca                	mov    %ecx,%edx
  802ddd:	89 f8                	mov    %edi,%eax
  802ddf:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  802de3:	85 f6                	test   %esi,%esi
  802de5:	75 2d                	jne    802e14 <__udivdi3+0x50>
  802de7:	39 cf                	cmp    %ecx,%edi
  802de9:	77 65                	ja     802e50 <__udivdi3+0x8c>
  802deb:	89 fd                	mov    %edi,%ebp
  802ded:	85 ff                	test   %edi,%edi
  802def:	75 0b                	jne    802dfc <__udivdi3+0x38>
  802df1:	b8 01 00 00 00       	mov    $0x1,%eax
  802df6:	31 d2                	xor    %edx,%edx
  802df8:	f7 f7                	div    %edi
  802dfa:	89 c5                	mov    %eax,%ebp
  802dfc:	31 d2                	xor    %edx,%edx
  802dfe:	89 c8                	mov    %ecx,%eax
  802e00:	f7 f5                	div    %ebp
  802e02:	89 c1                	mov    %eax,%ecx
  802e04:	89 d8                	mov    %ebx,%eax
  802e06:	f7 f5                	div    %ebp
  802e08:	89 cf                	mov    %ecx,%edi
  802e0a:	89 fa                	mov    %edi,%edx
  802e0c:	83 c4 1c             	add    $0x1c,%esp
  802e0f:	5b                   	pop    %ebx
  802e10:	5e                   	pop    %esi
  802e11:	5f                   	pop    %edi
  802e12:	5d                   	pop    %ebp
  802e13:	c3                   	ret    
  802e14:	39 ce                	cmp    %ecx,%esi
  802e16:	77 28                	ja     802e40 <__udivdi3+0x7c>
  802e18:	0f bd fe             	bsr    %esi,%edi
  802e1b:	83 f7 1f             	xor    $0x1f,%edi
  802e1e:	75 40                	jne    802e60 <__udivdi3+0x9c>
  802e20:	39 ce                	cmp    %ecx,%esi
  802e22:	72 0a                	jb     802e2e <__udivdi3+0x6a>
  802e24:	3b 44 24 08          	cmp    0x8(%esp),%eax
  802e28:	0f 87 9e 00 00 00    	ja     802ecc <__udivdi3+0x108>
  802e2e:	b8 01 00 00 00       	mov    $0x1,%eax
  802e33:	89 fa                	mov    %edi,%edx
  802e35:	83 c4 1c             	add    $0x1c,%esp
  802e38:	5b                   	pop    %ebx
  802e39:	5e                   	pop    %esi
  802e3a:	5f                   	pop    %edi
  802e3b:	5d                   	pop    %ebp
  802e3c:	c3                   	ret    
  802e3d:	8d 76 00             	lea    0x0(%esi),%esi
  802e40:	31 ff                	xor    %edi,%edi
  802e42:	31 c0                	xor    %eax,%eax
  802e44:	89 fa                	mov    %edi,%edx
  802e46:	83 c4 1c             	add    $0x1c,%esp
  802e49:	5b                   	pop    %ebx
  802e4a:	5e                   	pop    %esi
  802e4b:	5f                   	pop    %edi
  802e4c:	5d                   	pop    %ebp
  802e4d:	c3                   	ret    
  802e4e:	66 90                	xchg   %ax,%ax
  802e50:	89 d8                	mov    %ebx,%eax
  802e52:	f7 f7                	div    %edi
  802e54:	31 ff                	xor    %edi,%edi
  802e56:	89 fa                	mov    %edi,%edx
  802e58:	83 c4 1c             	add    $0x1c,%esp
  802e5b:	5b                   	pop    %ebx
  802e5c:	5e                   	pop    %esi
  802e5d:	5f                   	pop    %edi
  802e5e:	5d                   	pop    %ebp
  802e5f:	c3                   	ret    
  802e60:	bd 20 00 00 00       	mov    $0x20,%ebp
  802e65:	89 eb                	mov    %ebp,%ebx
  802e67:	29 fb                	sub    %edi,%ebx
  802e69:	89 f9                	mov    %edi,%ecx
  802e6b:	d3 e6                	shl    %cl,%esi
  802e6d:	89 c5                	mov    %eax,%ebp
  802e6f:	88 d9                	mov    %bl,%cl
  802e71:	d3 ed                	shr    %cl,%ebp
  802e73:	89 e9                	mov    %ebp,%ecx
  802e75:	09 f1                	or     %esi,%ecx
  802e77:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  802e7b:	89 f9                	mov    %edi,%ecx
  802e7d:	d3 e0                	shl    %cl,%eax
  802e7f:	89 c5                	mov    %eax,%ebp
  802e81:	89 d6                	mov    %edx,%esi
  802e83:	88 d9                	mov    %bl,%cl
  802e85:	d3 ee                	shr    %cl,%esi
  802e87:	89 f9                	mov    %edi,%ecx
  802e89:	d3 e2                	shl    %cl,%edx
  802e8b:	8b 44 24 08          	mov    0x8(%esp),%eax
  802e8f:	88 d9                	mov    %bl,%cl
  802e91:	d3 e8                	shr    %cl,%eax
  802e93:	09 c2                	or     %eax,%edx
  802e95:	89 d0                	mov    %edx,%eax
  802e97:	89 f2                	mov    %esi,%edx
  802e99:	f7 74 24 0c          	divl   0xc(%esp)
  802e9d:	89 d6                	mov    %edx,%esi
  802e9f:	89 c3                	mov    %eax,%ebx
  802ea1:	f7 e5                	mul    %ebp
  802ea3:	39 d6                	cmp    %edx,%esi
  802ea5:	72 19                	jb     802ec0 <__udivdi3+0xfc>
  802ea7:	74 0b                	je     802eb4 <__udivdi3+0xf0>
  802ea9:	89 d8                	mov    %ebx,%eax
  802eab:	31 ff                	xor    %edi,%edi
  802ead:	e9 58 ff ff ff       	jmp    802e0a <__udivdi3+0x46>
  802eb2:	66 90                	xchg   %ax,%ax
  802eb4:	8b 54 24 08          	mov    0x8(%esp),%edx
  802eb8:	89 f9                	mov    %edi,%ecx
  802eba:	d3 e2                	shl    %cl,%edx
  802ebc:	39 c2                	cmp    %eax,%edx
  802ebe:	73 e9                	jae    802ea9 <__udivdi3+0xe5>
  802ec0:	8d 43 ff             	lea    -0x1(%ebx),%eax
  802ec3:	31 ff                	xor    %edi,%edi
  802ec5:	e9 40 ff ff ff       	jmp    802e0a <__udivdi3+0x46>
  802eca:	66 90                	xchg   %ax,%ax
  802ecc:	31 c0                	xor    %eax,%eax
  802ece:	e9 37 ff ff ff       	jmp    802e0a <__udivdi3+0x46>
  802ed3:	90                   	nop

00802ed4 <__umoddi3>:
  802ed4:	55                   	push   %ebp
  802ed5:	57                   	push   %edi
  802ed6:	56                   	push   %esi
  802ed7:	53                   	push   %ebx
  802ed8:	83 ec 1c             	sub    $0x1c,%esp
  802edb:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  802edf:	8b 74 24 34          	mov    0x34(%esp),%esi
  802ee3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  802ee7:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  802eeb:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802eef:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802ef3:	89 f3                	mov    %esi,%ebx
  802ef5:	89 fa                	mov    %edi,%edx
  802ef7:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  802efb:	89 34 24             	mov    %esi,(%esp)
  802efe:	85 c0                	test   %eax,%eax
  802f00:	75 1a                	jne    802f1c <__umoddi3+0x48>
  802f02:	39 f7                	cmp    %esi,%edi
  802f04:	0f 86 a2 00 00 00    	jbe    802fac <__umoddi3+0xd8>
  802f0a:	89 c8                	mov    %ecx,%eax
  802f0c:	89 f2                	mov    %esi,%edx
  802f0e:	f7 f7                	div    %edi
  802f10:	89 d0                	mov    %edx,%eax
  802f12:	31 d2                	xor    %edx,%edx
  802f14:	83 c4 1c             	add    $0x1c,%esp
  802f17:	5b                   	pop    %ebx
  802f18:	5e                   	pop    %esi
  802f19:	5f                   	pop    %edi
  802f1a:	5d                   	pop    %ebp
  802f1b:	c3                   	ret    
  802f1c:	39 f0                	cmp    %esi,%eax
  802f1e:	0f 87 ac 00 00 00    	ja     802fd0 <__umoddi3+0xfc>
  802f24:	0f bd e8             	bsr    %eax,%ebp
  802f27:	83 f5 1f             	xor    $0x1f,%ebp
  802f2a:	0f 84 ac 00 00 00    	je     802fdc <__umoddi3+0x108>
  802f30:	bf 20 00 00 00       	mov    $0x20,%edi
  802f35:	29 ef                	sub    %ebp,%edi
  802f37:	89 fe                	mov    %edi,%esi
  802f39:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802f3d:	89 e9                	mov    %ebp,%ecx
  802f3f:	d3 e0                	shl    %cl,%eax
  802f41:	89 d7                	mov    %edx,%edi
  802f43:	89 f1                	mov    %esi,%ecx
  802f45:	d3 ef                	shr    %cl,%edi
  802f47:	09 c7                	or     %eax,%edi
  802f49:	89 e9                	mov    %ebp,%ecx
  802f4b:	d3 e2                	shl    %cl,%edx
  802f4d:	89 14 24             	mov    %edx,(%esp)
  802f50:	89 d8                	mov    %ebx,%eax
  802f52:	d3 e0                	shl    %cl,%eax
  802f54:	89 c2                	mov    %eax,%edx
  802f56:	8b 44 24 08          	mov    0x8(%esp),%eax
  802f5a:	d3 e0                	shl    %cl,%eax
  802f5c:	89 44 24 04          	mov    %eax,0x4(%esp)
  802f60:	8b 44 24 08          	mov    0x8(%esp),%eax
  802f64:	89 f1                	mov    %esi,%ecx
  802f66:	d3 e8                	shr    %cl,%eax
  802f68:	09 d0                	or     %edx,%eax
  802f6a:	d3 eb                	shr    %cl,%ebx
  802f6c:	89 da                	mov    %ebx,%edx
  802f6e:	f7 f7                	div    %edi
  802f70:	89 d3                	mov    %edx,%ebx
  802f72:	f7 24 24             	mull   (%esp)
  802f75:	89 c6                	mov    %eax,%esi
  802f77:	89 d1                	mov    %edx,%ecx
  802f79:	39 d3                	cmp    %edx,%ebx
  802f7b:	0f 82 87 00 00 00    	jb     803008 <__umoddi3+0x134>
  802f81:	0f 84 91 00 00 00    	je     803018 <__umoddi3+0x144>
  802f87:	8b 54 24 04          	mov    0x4(%esp),%edx
  802f8b:	29 f2                	sub    %esi,%edx
  802f8d:	19 cb                	sbb    %ecx,%ebx
  802f8f:	89 d8                	mov    %ebx,%eax
  802f91:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  802f95:	d3 e0                	shl    %cl,%eax
  802f97:	89 e9                	mov    %ebp,%ecx
  802f99:	d3 ea                	shr    %cl,%edx
  802f9b:	09 d0                	or     %edx,%eax
  802f9d:	89 e9                	mov    %ebp,%ecx
  802f9f:	d3 eb                	shr    %cl,%ebx
  802fa1:	89 da                	mov    %ebx,%edx
  802fa3:	83 c4 1c             	add    $0x1c,%esp
  802fa6:	5b                   	pop    %ebx
  802fa7:	5e                   	pop    %esi
  802fa8:	5f                   	pop    %edi
  802fa9:	5d                   	pop    %ebp
  802faa:	c3                   	ret    
  802fab:	90                   	nop
  802fac:	89 fd                	mov    %edi,%ebp
  802fae:	85 ff                	test   %edi,%edi
  802fb0:	75 0b                	jne    802fbd <__umoddi3+0xe9>
  802fb2:	b8 01 00 00 00       	mov    $0x1,%eax
  802fb7:	31 d2                	xor    %edx,%edx
  802fb9:	f7 f7                	div    %edi
  802fbb:	89 c5                	mov    %eax,%ebp
  802fbd:	89 f0                	mov    %esi,%eax
  802fbf:	31 d2                	xor    %edx,%edx
  802fc1:	f7 f5                	div    %ebp
  802fc3:	89 c8                	mov    %ecx,%eax
  802fc5:	f7 f5                	div    %ebp
  802fc7:	89 d0                	mov    %edx,%eax
  802fc9:	e9 44 ff ff ff       	jmp    802f12 <__umoddi3+0x3e>
  802fce:	66 90                	xchg   %ax,%ax
  802fd0:	89 c8                	mov    %ecx,%eax
  802fd2:	89 f2                	mov    %esi,%edx
  802fd4:	83 c4 1c             	add    $0x1c,%esp
  802fd7:	5b                   	pop    %ebx
  802fd8:	5e                   	pop    %esi
  802fd9:	5f                   	pop    %edi
  802fda:	5d                   	pop    %ebp
  802fdb:	c3                   	ret    
  802fdc:	3b 04 24             	cmp    (%esp),%eax
  802fdf:	72 06                	jb     802fe7 <__umoddi3+0x113>
  802fe1:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  802fe5:	77 0f                	ja     802ff6 <__umoddi3+0x122>
  802fe7:	89 f2                	mov    %esi,%edx
  802fe9:	29 f9                	sub    %edi,%ecx
  802feb:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  802fef:	89 14 24             	mov    %edx,(%esp)
  802ff2:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  802ff6:	8b 44 24 04          	mov    0x4(%esp),%eax
  802ffa:	8b 14 24             	mov    (%esp),%edx
  802ffd:	83 c4 1c             	add    $0x1c,%esp
  803000:	5b                   	pop    %ebx
  803001:	5e                   	pop    %esi
  803002:	5f                   	pop    %edi
  803003:	5d                   	pop    %ebp
  803004:	c3                   	ret    
  803005:	8d 76 00             	lea    0x0(%esi),%esi
  803008:	2b 04 24             	sub    (%esp),%eax
  80300b:	19 fa                	sbb    %edi,%edx
  80300d:	89 d1                	mov    %edx,%ecx
  80300f:	89 c6                	mov    %eax,%esi
  803011:	e9 71 ff ff ff       	jmp    802f87 <__umoddi3+0xb3>
  803016:	66 90                	xchg   %ax,%ax
  803018:	39 44 24 04          	cmp    %eax,0x4(%esp)
  80301c:	72 ea                	jb     803008 <__umoddi3+0x134>
  80301e:	89 d9                	mov    %ebx,%ecx
  803020:	e9 62 ff ff ff       	jmp    802f87 <__umoddi3+0xb3>
