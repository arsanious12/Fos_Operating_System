
obj/user/tst_air_clerk:     file format elf32-i386


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
  800031:	e8 5b 07 00 00       	call   800791 <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
#include <user/air.h>

extern volatile bool printStats;
void
_main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	57                   	push   %edi
  80003c:	56                   	push   %esi
  80003d:	53                   	push   %ebx
  80003e:	81 ec dc 01 00 00    	sub    $0x1dc,%esp
	//disable the print of prog stats after finishing
	printStats = 0;
  800044:	c7 05 00 40 80 00 00 	movl   $0x0,0x804000
  80004b:	00 00 00 

	int parentenvID = sys_getparentenvid();
  80004e:	e8 6e 1f 00 00       	call   801fc1 <sys_getparentenvid>
  800053:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	// Get the shared variables from the main program ***********************************

	char _isOpened[] = "isOpened";
  800056:	8d 45 ab             	lea    -0x55(%ebp),%eax
  800059:	bb 3f 31 80 00       	mov    $0x80313f,%ebx
  80005e:	ba 09 00 00 00       	mov    $0x9,%edx
  800063:	89 c7                	mov    %eax,%edi
  800065:	89 de                	mov    %ebx,%esi
  800067:	89 d1                	mov    %edx,%ecx
  800069:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _customers[] = "customers";
  80006b:	8d 45 a1             	lea    -0x5f(%ebp),%eax
  80006e:	bb 48 31 80 00       	mov    $0x803148,%ebx
  800073:	ba 0a 00 00 00       	mov    $0xa,%edx
  800078:	89 c7                	mov    %eax,%edi
  80007a:	89 de                	mov    %ebx,%esi
  80007c:	89 d1                	mov    %edx,%ecx
  80007e:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _custCounter[] = "custCounter";
  800080:	8d 45 95             	lea    -0x6b(%ebp),%eax
  800083:	bb 52 31 80 00       	mov    $0x803152,%ebx
  800088:	ba 03 00 00 00       	mov    $0x3,%edx
  80008d:	89 c7                	mov    %eax,%edi
  80008f:	89 de                	mov    %ebx,%esi
  800091:	89 d1                	mov    %edx,%ecx
  800093:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
	char _flight1Counter[] = "flight1Counter";
  800095:	8d 45 86             	lea    -0x7a(%ebp),%eax
  800098:	bb 5e 31 80 00       	mov    $0x80315e,%ebx
  80009d:	ba 0f 00 00 00       	mov    $0xf,%edx
  8000a2:	89 c7                	mov    %eax,%edi
  8000a4:	89 de                	mov    %ebx,%esi
  8000a6:	89 d1                	mov    %edx,%ecx
  8000a8:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _flight2Counter[] = "flight2Counter";
  8000aa:	8d 85 77 ff ff ff    	lea    -0x89(%ebp),%eax
  8000b0:	bb 6d 31 80 00       	mov    $0x80316d,%ebx
  8000b5:	ba 0f 00 00 00       	mov    $0xf,%edx
  8000ba:	89 c7                	mov    %eax,%edi
  8000bc:	89 de                	mov    %ebx,%esi
  8000be:	89 d1                	mov    %edx,%ecx
  8000c0:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _flightBooked1Counter[] = "flightBooked1Counter";
  8000c2:	8d 85 62 ff ff ff    	lea    -0x9e(%ebp),%eax
  8000c8:	bb 7c 31 80 00       	mov    $0x80317c,%ebx
  8000cd:	ba 15 00 00 00       	mov    $0x15,%edx
  8000d2:	89 c7                	mov    %eax,%edi
  8000d4:	89 de                	mov    %ebx,%esi
  8000d6:	89 d1                	mov    %edx,%ecx
  8000d8:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _flightBooked2Counter[] = "flightBooked2Counter";
  8000da:	8d 85 4d ff ff ff    	lea    -0xb3(%ebp),%eax
  8000e0:	bb 91 31 80 00       	mov    $0x803191,%ebx
  8000e5:	ba 15 00 00 00       	mov    $0x15,%edx
  8000ea:	89 c7                	mov    %eax,%edi
  8000ec:	89 de                	mov    %ebx,%esi
  8000ee:	89 d1                	mov    %edx,%ecx
  8000f0:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _flightBooked1Arr[] = "flightBooked1Arr";
  8000f2:	8d 85 3c ff ff ff    	lea    -0xc4(%ebp),%eax
  8000f8:	bb a6 31 80 00       	mov    $0x8031a6,%ebx
  8000fd:	ba 11 00 00 00       	mov    $0x11,%edx
  800102:	89 c7                	mov    %eax,%edi
  800104:	89 de                	mov    %ebx,%esi
  800106:	89 d1                	mov    %edx,%ecx
  800108:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _flightBooked2Arr[] = "flightBooked2Arr";
  80010a:	8d 85 2b ff ff ff    	lea    -0xd5(%ebp),%eax
  800110:	bb b7 31 80 00       	mov    $0x8031b7,%ebx
  800115:	ba 11 00 00 00       	mov    $0x11,%edx
  80011a:	89 c7                	mov    %eax,%edi
  80011c:	89 de                	mov    %ebx,%esi
  80011e:	89 d1                	mov    %edx,%ecx
  800120:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _cust_ready_queue[] = "cust_ready_queue";
  800122:	8d 85 1a ff ff ff    	lea    -0xe6(%ebp),%eax
  800128:	bb c8 31 80 00       	mov    $0x8031c8,%ebx
  80012d:	ba 11 00 00 00       	mov    $0x11,%edx
  800132:	89 c7                	mov    %eax,%edi
  800134:	89 de                	mov    %ebx,%esi
  800136:	89 d1                	mov    %edx,%ecx
  800138:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _queue_in[] = "queue_in";
  80013a:	8d 85 11 ff ff ff    	lea    -0xef(%ebp),%eax
  800140:	bb d9 31 80 00       	mov    $0x8031d9,%ebx
  800145:	ba 09 00 00 00       	mov    $0x9,%edx
  80014a:	89 c7                	mov    %eax,%edi
  80014c:	89 de                	mov    %ebx,%esi
  80014e:	89 d1                	mov    %edx,%ecx
  800150:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _queue_out[] = "queue_out";
  800152:	8d 85 07 ff ff ff    	lea    -0xf9(%ebp),%eax
  800158:	bb e2 31 80 00       	mov    $0x8031e2,%ebx
  80015d:	ba 0a 00 00 00       	mov    $0xa,%edx
  800162:	89 c7                	mov    %eax,%edi
  800164:	89 de                	mov    %ebx,%esi
  800166:	89 d1                	mov    %edx,%ecx
  800168:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)

	char _cust_ready[] = "cust_ready";
  80016a:	8d 85 fc fe ff ff    	lea    -0x104(%ebp),%eax
  800170:	bb ec 31 80 00       	mov    $0x8031ec,%ebx
  800175:	ba 0b 00 00 00       	mov    $0xb,%edx
  80017a:	89 c7                	mov    %eax,%edi
  80017c:	89 de                	mov    %ebx,%esi
  80017e:	89 d1                	mov    %edx,%ecx
  800180:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _custQueueCS[] = "custQueueCS";
  800182:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800188:	bb f7 31 80 00       	mov    $0x8031f7,%ebx
  80018d:	ba 03 00 00 00       	mov    $0x3,%edx
  800192:	89 c7                	mov    %eax,%edi
  800194:	89 de                	mov    %ebx,%esi
  800196:	89 d1                	mov    %edx,%ecx
  800198:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
	char _flight1CS[] = "flight1CS";
  80019a:	8d 85 e6 fe ff ff    	lea    -0x11a(%ebp),%eax
  8001a0:	bb 03 32 80 00       	mov    $0x803203,%ebx
  8001a5:	ba 0a 00 00 00       	mov    $0xa,%edx
  8001aa:	89 c7                	mov    %eax,%edi
  8001ac:	89 de                	mov    %ebx,%esi
  8001ae:	89 d1                	mov    %edx,%ecx
  8001b0:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _flight2CS[] = "flight2CS";
  8001b2:	8d 85 dc fe ff ff    	lea    -0x124(%ebp),%eax
  8001b8:	bb 0d 32 80 00       	mov    $0x80320d,%ebx
  8001bd:	ba 0a 00 00 00       	mov    $0xa,%edx
  8001c2:	89 c7                	mov    %eax,%edi
  8001c4:	89 de                	mov    %ebx,%esi
  8001c6:	89 d1                	mov    %edx,%ecx
  8001c8:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)

	char _clerk[] = "clerk";
  8001ca:	c7 85 d6 fe ff ff 63 	movl   $0x72656c63,-0x12a(%ebp)
  8001d1:	6c 65 72 
  8001d4:	66 c7 85 da fe ff ff 	movw   $0x6b,-0x126(%ebp)
  8001db:	6b 00 
	char _custCounterCS[] = "custCounterCS";
  8001dd:	8d 85 c8 fe ff ff    	lea    -0x138(%ebp),%eax
  8001e3:	bb 17 32 80 00       	mov    $0x803217,%ebx
  8001e8:	ba 0e 00 00 00       	mov    $0xe,%edx
  8001ed:	89 c7                	mov    %eax,%edi
  8001ef:	89 de                	mov    %ebx,%esi
  8001f1:	89 d1                	mov    %edx,%ecx
  8001f3:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _custTerminated[] = "custTerminated";
  8001f5:	8d 85 b9 fe ff ff    	lea    -0x147(%ebp),%eax
  8001fb:	bb 25 32 80 00       	mov    $0x803225,%ebx
  800200:	ba 0f 00 00 00       	mov    $0xf,%edx
  800205:	89 c7                	mov    %eax,%edi
  800207:	89 de                	mov    %ebx,%esi
  800209:	89 d1                	mov    %edx,%ecx
  80020b:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _clerkTerminated[] = "clerkTerminated";
  80020d:	8d 85 a9 fe ff ff    	lea    -0x157(%ebp),%eax
  800213:	bb 34 32 80 00       	mov    $0x803234,%ebx
  800218:	ba 04 00 00 00       	mov    $0x4,%edx
  80021d:	89 c7                	mov    %eax,%edi
  80021f:	89 de                	mov    %ebx,%esi
  800221:	89 d1                	mov    %edx,%ecx
  800223:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)

	char _taircl[] = "taircl";
  800225:	8d 85 a2 fe ff ff    	lea    -0x15e(%ebp),%eax
  80022b:	bb 44 32 80 00       	mov    $0x803244,%ebx
  800230:	ba 07 00 00 00       	mov    $0x7,%edx
  800235:	89 c7                	mov    %eax,%edi
  800237:	89 de                	mov    %ebx,%esi
  800239:	89 d1                	mov    %edx,%ecx
  80023b:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _taircu[] = "taircu";
  80023d:	8d 85 9b fe ff ff    	lea    -0x165(%ebp),%eax
  800243:	bb 4b 32 80 00       	mov    $0x80324b,%ebx
  800248:	ba 07 00 00 00       	mov    $0x7,%edx
  80024d:	89 c7                	mov    %eax,%edi
  80024f:	89 de                	mov    %ebx,%esi
  800251:	89 d1                	mov    %edx,%ecx
  800253:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)

	struct Customer * customers = sget(parentenvID, _customers);
  800255:	83 ec 08             	sub    $0x8,%esp
  800258:	8d 45 a1             	lea    -0x5f(%ebp),%eax
  80025b:	50                   	push   %eax
  80025c:	ff 75 e4             	pushl  -0x1c(%ebp)
  80025f:	e8 fe 19 00 00       	call   801c62 <sget>
  800264:	83 c4 10             	add    $0x10,%esp
  800267:	89 45 e0             	mov    %eax,-0x20(%ebp)

	int* isOpened = sget(parentenvID, _isOpened);
  80026a:	83 ec 08             	sub    $0x8,%esp
  80026d:	8d 45 ab             	lea    -0x55(%ebp),%eax
  800270:	50                   	push   %eax
  800271:	ff 75 e4             	pushl  -0x1c(%ebp)
  800274:	e8 e9 19 00 00       	call   801c62 <sget>
  800279:	83 c4 10             	add    $0x10,%esp
  80027c:	89 45 dc             	mov    %eax,-0x24(%ebp)

	int* flight1Counter = sget(parentenvID, _flight1Counter);
  80027f:	83 ec 08             	sub    $0x8,%esp
  800282:	8d 45 86             	lea    -0x7a(%ebp),%eax
  800285:	50                   	push   %eax
  800286:	ff 75 e4             	pushl  -0x1c(%ebp)
  800289:	e8 d4 19 00 00       	call   801c62 <sget>
  80028e:	83 c4 10             	add    $0x10,%esp
  800291:	89 45 d8             	mov    %eax,-0x28(%ebp)
	int* flight2Counter = sget(parentenvID, _flight2Counter);
  800294:	83 ec 08             	sub    $0x8,%esp
  800297:	8d 85 77 ff ff ff    	lea    -0x89(%ebp),%eax
  80029d:	50                   	push   %eax
  80029e:	ff 75 e4             	pushl  -0x1c(%ebp)
  8002a1:	e8 bc 19 00 00       	call   801c62 <sget>
  8002a6:	83 c4 10             	add    $0x10,%esp
  8002a9:	89 45 d4             	mov    %eax,-0x2c(%ebp)

	int* flight1BookedCounter = sget(parentenvID, _flightBooked1Counter);
  8002ac:	83 ec 08             	sub    $0x8,%esp
  8002af:	8d 85 62 ff ff ff    	lea    -0x9e(%ebp),%eax
  8002b5:	50                   	push   %eax
  8002b6:	ff 75 e4             	pushl  -0x1c(%ebp)
  8002b9:	e8 a4 19 00 00       	call   801c62 <sget>
  8002be:	83 c4 10             	add    $0x10,%esp
  8002c1:	89 45 d0             	mov    %eax,-0x30(%ebp)
	int* flight2BookedCounter = sget(parentenvID, _flightBooked2Counter);
  8002c4:	83 ec 08             	sub    $0x8,%esp
  8002c7:	8d 85 4d ff ff ff    	lea    -0xb3(%ebp),%eax
  8002cd:	50                   	push   %eax
  8002ce:	ff 75 e4             	pushl  -0x1c(%ebp)
  8002d1:	e8 8c 19 00 00       	call   801c62 <sget>
  8002d6:	83 c4 10             	add    $0x10,%esp
  8002d9:	89 45 cc             	mov    %eax,-0x34(%ebp)

	int* flight1BookedArr = sget(parentenvID, _flightBooked1Arr);
  8002dc:	83 ec 08             	sub    $0x8,%esp
  8002df:	8d 85 3c ff ff ff    	lea    -0xc4(%ebp),%eax
  8002e5:	50                   	push   %eax
  8002e6:	ff 75 e4             	pushl  -0x1c(%ebp)
  8002e9:	e8 74 19 00 00       	call   801c62 <sget>
  8002ee:	83 c4 10             	add    $0x10,%esp
  8002f1:	89 45 c8             	mov    %eax,-0x38(%ebp)
	int* flight2BookedArr = sget(parentenvID, _flightBooked2Arr);
  8002f4:	83 ec 08             	sub    $0x8,%esp
  8002f7:	8d 85 2b ff ff ff    	lea    -0xd5(%ebp),%eax
  8002fd:	50                   	push   %eax
  8002fe:	ff 75 e4             	pushl  -0x1c(%ebp)
  800301:	e8 5c 19 00 00       	call   801c62 <sget>
  800306:	83 c4 10             	add    $0x10,%esp
  800309:	89 45 c4             	mov    %eax,-0x3c(%ebp)

	int* cust_ready_queue = sget(parentenvID, _cust_ready_queue);
  80030c:	83 ec 08             	sub    $0x8,%esp
  80030f:	8d 85 1a ff ff ff    	lea    -0xe6(%ebp),%eax
  800315:	50                   	push   %eax
  800316:	ff 75 e4             	pushl  -0x1c(%ebp)
  800319:	e8 44 19 00 00       	call   801c62 <sget>
  80031e:	83 c4 10             	add    $0x10,%esp
  800321:	89 45 c0             	mov    %eax,-0x40(%ebp)

	int* queue_out = sget(parentenvID, _queue_out);
  800324:	83 ec 08             	sub    $0x8,%esp
  800327:	8d 85 07 ff ff ff    	lea    -0xf9(%ebp),%eax
  80032d:	50                   	push   %eax
  80032e:	ff 75 e4             	pushl  -0x1c(%ebp)
  800331:	e8 2c 19 00 00       	call   801c62 <sget>
  800336:	83 c4 10             	add    $0x10,%esp
  800339:	89 45 bc             	mov    %eax,-0x44(%ebp)
	//cprintf("address of queue_out = %d\n", queue_out);
	// *********************************************************************************

	struct semaphore cust_ready = get_semaphore(parentenvID, _cust_ready);
  80033c:	8d 85 94 fe ff ff    	lea    -0x16c(%ebp),%eax
  800342:	83 ec 04             	sub    $0x4,%esp
  800345:	8d 95 fc fe ff ff    	lea    -0x104(%ebp),%edx
  80034b:	52                   	push   %edx
  80034c:	ff 75 e4             	pushl  -0x1c(%ebp)
  80034f:	50                   	push   %eax
  800350:	e8 d6 29 00 00       	call   802d2b <get_semaphore>
  800355:	83 c4 0c             	add    $0xc,%esp
	struct semaphore custQueueCS = get_semaphore(parentenvID, _custQueueCS);
  800358:	8d 85 90 fe ff ff    	lea    -0x170(%ebp),%eax
  80035e:	83 ec 04             	sub    $0x4,%esp
  800361:	8d 95 f0 fe ff ff    	lea    -0x110(%ebp),%edx
  800367:	52                   	push   %edx
  800368:	ff 75 e4             	pushl  -0x1c(%ebp)
  80036b:	50                   	push   %eax
  80036c:	e8 ba 29 00 00       	call   802d2b <get_semaphore>
  800371:	83 c4 0c             	add    $0xc,%esp
	struct semaphore flight1CS = get_semaphore(parentenvID, _flight1CS);
  800374:	8d 85 8c fe ff ff    	lea    -0x174(%ebp),%eax
  80037a:	83 ec 04             	sub    $0x4,%esp
  80037d:	8d 95 e6 fe ff ff    	lea    -0x11a(%ebp),%edx
  800383:	52                   	push   %edx
  800384:	ff 75 e4             	pushl  -0x1c(%ebp)
  800387:	50                   	push   %eax
  800388:	e8 9e 29 00 00       	call   802d2b <get_semaphore>
  80038d:	83 c4 0c             	add    $0xc,%esp
	struct semaphore flight2CS = get_semaphore(parentenvID, _flight2CS);
  800390:	8d 85 88 fe ff ff    	lea    -0x178(%ebp),%eax
  800396:	83 ec 04             	sub    $0x4,%esp
  800399:	8d 95 dc fe ff ff    	lea    -0x124(%ebp),%edx
  80039f:	52                   	push   %edx
  8003a0:	ff 75 e4             	pushl  -0x1c(%ebp)
  8003a3:	50                   	push   %eax
  8003a4:	e8 82 29 00 00       	call   802d2b <get_semaphore>
  8003a9:	83 c4 0c             	add    $0xc,%esp
	struct semaphore clerk = get_semaphore(parentenvID, _clerk);
  8003ac:	8d 85 84 fe ff ff    	lea    -0x17c(%ebp),%eax
  8003b2:	83 ec 04             	sub    $0x4,%esp
  8003b5:	8d 95 d6 fe ff ff    	lea    -0x12a(%ebp),%edx
  8003bb:	52                   	push   %edx
  8003bc:	ff 75 e4             	pushl  -0x1c(%ebp)
  8003bf:	50                   	push   %eax
  8003c0:	e8 66 29 00 00       	call   802d2b <get_semaphore>
  8003c5:	83 c4 0c             	add    $0xc,%esp
	struct semaphore clerkTerminated = get_semaphore(parentenvID, _clerkTerminated);
  8003c8:	8d 85 80 fe ff ff    	lea    -0x180(%ebp),%eax
  8003ce:	83 ec 04             	sub    $0x4,%esp
  8003d1:	8d 95 a9 fe ff ff    	lea    -0x157(%ebp),%edx
  8003d7:	52                   	push   %edx
  8003d8:	ff 75 e4             	pushl  -0x1c(%ebp)
  8003db:	50                   	push   %eax
  8003dc:	e8 4a 29 00 00       	call   802d2b <get_semaphore>
  8003e1:	83 c4 0c             	add    $0xc,%esp

	while(*isOpened)
  8003e4:	e9 71 03 00 00       	jmp    80075a <_main+0x722>
	{
		int custId;
		//wait for a customer
		wait_semaphore(cust_ready);
  8003e9:	83 ec 0c             	sub    $0xc,%esp
  8003ec:	ff b5 94 fe ff ff    	pushl  -0x16c(%ebp)
  8003f2:	e8 4e 29 00 00       	call   802d45 <wait_semaphore>
  8003f7:	83 c4 10             	add    $0x10,%esp

		//dequeue the customer info
		wait_semaphore(custQueueCS);
  8003fa:	83 ec 0c             	sub    $0xc,%esp
  8003fd:	ff b5 90 fe ff ff    	pushl  -0x170(%ebp)
  800403:	e8 3d 29 00 00       	call   802d45 <wait_semaphore>
  800408:	83 c4 10             	add    $0x10,%esp
		{
			//cprintf("*queue_out = %d\n", *queue_out);
			custId = cust_ready_queue[*queue_out];
  80040b:	8b 45 bc             	mov    -0x44(%ebp),%eax
  80040e:	8b 00                	mov    (%eax),%eax
  800410:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800417:	8b 45 c0             	mov    -0x40(%ebp),%eax
  80041a:	01 d0                	add    %edx,%eax
  80041c:	8b 00                	mov    (%eax),%eax
  80041e:	89 45 b8             	mov    %eax,-0x48(%ebp)
			//there's no more customers for now...
			if (custId == -1)
  800421:	83 7d b8 ff          	cmpl   $0xffffffff,-0x48(%ebp)
  800425:	75 16                	jne    80043d <_main+0x405>
			{
				signal_semaphore(custQueueCS);
  800427:	83 ec 0c             	sub    $0xc,%esp
  80042a:	ff b5 90 fe ff ff    	pushl  -0x170(%ebp)
  800430:	e8 2a 29 00 00       	call   802d5f <signal_semaphore>
  800435:	83 c4 10             	add    $0x10,%esp
  800438:	e9 1d 03 00 00       	jmp    80075a <_main+0x722>
				continue;
			}
			*queue_out = *queue_out +1;
  80043d:	8b 45 bc             	mov    -0x44(%ebp),%eax
  800440:	8b 00                	mov    (%eax),%eax
  800442:	8d 50 01             	lea    0x1(%eax),%edx
  800445:	8b 45 bc             	mov    -0x44(%ebp),%eax
  800448:	89 10                	mov    %edx,(%eax)
		}
		signal_semaphore(custQueueCS);
  80044a:	83 ec 0c             	sub    $0xc,%esp
  80044d:	ff b5 90 fe ff ff    	pushl  -0x170(%ebp)
  800453:	e8 07 29 00 00       	call   802d5f <signal_semaphore>
  800458:	83 c4 10             	add    $0x10,%esp

		//try reserving on the required flight
		int custFlightType = customers[custId].flightType;
  80045b:	8b 45 b8             	mov    -0x48(%ebp),%eax
  80045e:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  800465:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800468:	01 d0                	add    %edx,%eax
  80046a:	8b 00                	mov    (%eax),%eax
  80046c:	89 45 b4             	mov    %eax,-0x4c(%ebp)
		//cprintf("custId dequeued = %d, ft = %d\n", custId, customers[custId].flightType);

		switch (custFlightType)
  80046f:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  800472:	83 f8 02             	cmp    $0x2,%eax
  800475:	0f 84 9d 00 00 00    	je     800518 <_main+0x4e0>
  80047b:	83 f8 03             	cmp    $0x3,%eax
  80047e:	0f 84 1f 01 00 00    	je     8005a3 <_main+0x56b>
  800484:	83 f8 01             	cmp    $0x1,%eax
  800487:	0f 85 17 02 00 00    	jne    8006a4 <_main+0x66c>
		{
		case 1:
		{
			//Check and update Flight1
			wait_semaphore(flight1CS);
  80048d:	83 ec 0c             	sub    $0xc,%esp
  800490:	ff b5 8c fe ff ff    	pushl  -0x174(%ebp)
  800496:	e8 aa 28 00 00       	call   802d45 <wait_semaphore>
  80049b:	83 c4 10             	add    $0x10,%esp
			{
				if(*flight1Counter > 0)
  80049e:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8004a1:	8b 00                	mov    (%eax),%eax
  8004a3:	85 c0                	test   %eax,%eax
  8004a5:	7e 48                	jle    8004ef <_main+0x4b7>
				{
					*flight1Counter = *flight1Counter - 1;
  8004a7:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8004aa:	8b 00                	mov    (%eax),%eax
  8004ac:	8d 50 ff             	lea    -0x1(%eax),%edx
  8004af:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8004b2:	89 10                	mov    %edx,(%eax)
					customers[custId].booked = 1;
  8004b4:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8004b7:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  8004be:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8004c1:	01 d0                	add    %edx,%eax
  8004c3:	c7 40 04 01 00 00 00 	movl   $0x1,0x4(%eax)
					flight1BookedArr[*flight1BookedCounter] = custId;
  8004ca:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8004cd:	8b 00                	mov    (%eax),%eax
  8004cf:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8004d6:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8004d9:	01 c2                	add    %eax,%edx
  8004db:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8004de:	89 02                	mov    %eax,(%edx)
					*flight1BookedCounter =*flight1BookedCounter+1;
  8004e0:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8004e3:	8b 00                	mov    (%eax),%eax
  8004e5:	8d 50 01             	lea    0x1(%eax),%edx
  8004e8:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8004eb:	89 10                	mov    %edx,(%eax)
  8004ed:	eb 13                	jmp    800502 <_main+0x4ca>
				}
				else
				{
					cprintf("%~\nFlight#1 is FULL! Reservation request of customer#%d is rejected\n", custId);
  8004ef:	83 ec 08             	sub    $0x8,%esp
  8004f2:	ff 75 b8             	pushl  -0x48(%ebp)
  8004f5:	68 00 30 80 00       	push   $0x803000
  8004fa:	e8 25 07 00 00       	call   800c24 <cprintf>
  8004ff:	83 c4 10             	add    $0x10,%esp
				}
			}
			signal_semaphore(flight1CS);
  800502:	83 ec 0c             	sub    $0xc,%esp
  800505:	ff b5 8c fe ff ff    	pushl  -0x174(%ebp)
  80050b:	e8 4f 28 00 00       	call   802d5f <signal_semaphore>
  800510:	83 c4 10             	add    $0x10,%esp
		}

		break;
  800513:	e9 a3 01 00 00       	jmp    8006bb <_main+0x683>
		case 2:
		{
			//Check and update Flight2
			wait_semaphore(flight2CS);
  800518:	83 ec 0c             	sub    $0xc,%esp
  80051b:	ff b5 88 fe ff ff    	pushl  -0x178(%ebp)
  800521:	e8 1f 28 00 00       	call   802d45 <wait_semaphore>
  800526:	83 c4 10             	add    $0x10,%esp
			{
				if(*flight2Counter > 0)
  800529:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80052c:	8b 00                	mov    (%eax),%eax
  80052e:	85 c0                	test   %eax,%eax
  800530:	7e 48                	jle    80057a <_main+0x542>
				{
					*flight2Counter = *flight2Counter - 1;
  800532:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800535:	8b 00                	mov    (%eax),%eax
  800537:	8d 50 ff             	lea    -0x1(%eax),%edx
  80053a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80053d:	89 10                	mov    %edx,(%eax)
					customers[custId].booked = 1;
  80053f:	8b 45 b8             	mov    -0x48(%ebp),%eax
  800542:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  800549:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80054c:	01 d0                	add    %edx,%eax
  80054e:	c7 40 04 01 00 00 00 	movl   $0x1,0x4(%eax)
					flight2BookedArr[*flight2BookedCounter] = custId;
  800555:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800558:	8b 00                	mov    (%eax),%eax
  80055a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800561:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  800564:	01 c2                	add    %eax,%edx
  800566:	8b 45 b8             	mov    -0x48(%ebp),%eax
  800569:	89 02                	mov    %eax,(%edx)
					*flight2BookedCounter =*flight2BookedCounter+1;
  80056b:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80056e:	8b 00                	mov    (%eax),%eax
  800570:	8d 50 01             	lea    0x1(%eax),%edx
  800573:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800576:	89 10                	mov    %edx,(%eax)
  800578:	eb 13                	jmp    80058d <_main+0x555>
				}
				else
				{
					cprintf("%~\nFlight#2 is FULL! Reservation request of customer#%d is rejected\n", custId);
  80057a:	83 ec 08             	sub    $0x8,%esp
  80057d:	ff 75 b8             	pushl  -0x48(%ebp)
  800580:	68 48 30 80 00       	push   $0x803048
  800585:	e8 9a 06 00 00       	call   800c24 <cprintf>
  80058a:	83 c4 10             	add    $0x10,%esp
				}
			}
			signal_semaphore(flight2CS);
  80058d:	83 ec 0c             	sub    $0xc,%esp
  800590:	ff b5 88 fe ff ff    	pushl  -0x178(%ebp)
  800596:	e8 c4 27 00 00       	call   802d5f <signal_semaphore>
  80059b:	83 c4 10             	add    $0x10,%esp
		}
		break;
  80059e:	e9 18 01 00 00       	jmp    8006bb <_main+0x683>
		case 3:
		{
			//Check and update Both Flights
			wait_semaphore(flight1CS); wait_semaphore(flight2CS);
  8005a3:	83 ec 0c             	sub    $0xc,%esp
  8005a6:	ff b5 8c fe ff ff    	pushl  -0x174(%ebp)
  8005ac:	e8 94 27 00 00       	call   802d45 <wait_semaphore>
  8005b1:	83 c4 10             	add    $0x10,%esp
  8005b4:	83 ec 0c             	sub    $0xc,%esp
  8005b7:	ff b5 88 fe ff ff    	pushl  -0x178(%ebp)
  8005bd:	e8 83 27 00 00       	call   802d45 <wait_semaphore>
  8005c2:	83 c4 10             	add    $0x10,%esp
			{
				if(*flight1Counter > 0 && *flight2Counter >0 )
  8005c5:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8005c8:	8b 00                	mov    (%eax),%eax
  8005ca:	85 c0                	test   %eax,%eax
  8005cc:	0f 8e 9b 00 00 00    	jle    80066d <_main+0x635>
  8005d2:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8005d5:	8b 00                	mov    (%eax),%eax
  8005d7:	85 c0                	test   %eax,%eax
  8005d9:	0f 8e 8e 00 00 00    	jle    80066d <_main+0x635>
				{
					*flight1Counter = *flight1Counter - 1;
  8005df:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8005e2:	8b 00                	mov    (%eax),%eax
  8005e4:	8d 50 ff             	lea    -0x1(%eax),%edx
  8005e7:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8005ea:	89 10                	mov    %edx,(%eax)
					customers[custId].booked = 1;
  8005ec:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8005ef:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  8005f6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8005f9:	01 d0                	add    %edx,%eax
  8005fb:	c7 40 04 01 00 00 00 	movl   $0x1,0x4(%eax)
					flight1BookedArr[*flight1BookedCounter] = custId;
  800602:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800605:	8b 00                	mov    (%eax),%eax
  800607:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80060e:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800611:	01 c2                	add    %eax,%edx
  800613:	8b 45 b8             	mov    -0x48(%ebp),%eax
  800616:	89 02                	mov    %eax,(%edx)
					*flight1BookedCounter =*flight1BookedCounter+1;
  800618:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80061b:	8b 00                	mov    (%eax),%eax
  80061d:	8d 50 01             	lea    0x1(%eax),%edx
  800620:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800623:	89 10                	mov    %edx,(%eax)

					*flight2Counter = *flight2Counter - 1;
  800625:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800628:	8b 00                	mov    (%eax),%eax
  80062a:	8d 50 ff             	lea    -0x1(%eax),%edx
  80062d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800630:	89 10                	mov    %edx,(%eax)
					customers[custId].booked = 1;
  800632:	8b 45 b8             	mov    -0x48(%ebp),%eax
  800635:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  80063c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80063f:	01 d0                	add    %edx,%eax
  800641:	c7 40 04 01 00 00 00 	movl   $0x1,0x4(%eax)
					flight2BookedArr[*flight2BookedCounter] = custId;
  800648:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80064b:	8b 00                	mov    (%eax),%eax
  80064d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800654:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  800657:	01 c2                	add    %eax,%edx
  800659:	8b 45 b8             	mov    -0x48(%ebp),%eax
  80065c:	89 02                	mov    %eax,(%edx)
					*flight2BookedCounter =*flight2BookedCounter+1;
  80065e:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800661:	8b 00                	mov    (%eax),%eax
  800663:	8d 50 01             	lea    0x1(%eax),%edx
  800666:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800669:	89 10                	mov    %edx,(%eax)
  80066b:	eb 13                	jmp    800680 <_main+0x648>

				}
				else
				{
					cprintf("%~\nFlight#1 and/or Flight#2 is FULL! Reservation request of customer#%d is rejected\n", custId);
  80066d:	83 ec 08             	sub    $0x8,%esp
  800670:	ff 75 b8             	pushl  -0x48(%ebp)
  800673:	68 90 30 80 00       	push   $0x803090
  800678:	e8 a7 05 00 00       	call   800c24 <cprintf>
  80067d:	83 c4 10             	add    $0x10,%esp
				}
			}
			signal_semaphore(flight1CS); signal_semaphore(flight2CS);
  800680:	83 ec 0c             	sub    $0xc,%esp
  800683:	ff b5 8c fe ff ff    	pushl  -0x174(%ebp)
  800689:	e8 d1 26 00 00       	call   802d5f <signal_semaphore>
  80068e:	83 c4 10             	add    $0x10,%esp
  800691:	83 ec 0c             	sub    $0xc,%esp
  800694:	ff b5 88 fe ff ff    	pushl  -0x178(%ebp)
  80069a:	e8 c0 26 00 00       	call   802d5f <signal_semaphore>
  80069f:	83 c4 10             	add    $0x10,%esp
		}
		break;
  8006a2:	eb 17                	jmp    8006bb <_main+0x683>
		default:
			panic("customer must have flight type\n");
  8006a4:	83 ec 04             	sub    $0x4,%esp
  8006a7:	68 e8 30 80 00       	push   $0x8030e8
  8006ac:	68 a4 00 00 00       	push   $0xa4
  8006b1:	68 08 31 80 00       	push   $0x803108
  8006b6:	e8 9b 02 00 00       	call   800956 <_panic>
		}

		//signal finished
		char prefix[30]="cust_finished";
  8006bb:	8d 85 62 fe ff ff    	lea    -0x19e(%ebp),%eax
  8006c1:	bb 52 32 80 00       	mov    $0x803252,%ebx
  8006c6:	ba 0e 00 00 00       	mov    $0xe,%edx
  8006cb:	89 c7                	mov    %eax,%edi
  8006cd:	89 de                	mov    %ebx,%esi
  8006cf:	89 d1                	mov    %edx,%ecx
  8006d1:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  8006d3:	8d 95 70 fe ff ff    	lea    -0x190(%ebp),%edx
  8006d9:	b9 04 00 00 00       	mov    $0x4,%ecx
  8006de:	b8 00 00 00 00       	mov    $0x0,%eax
  8006e3:	89 d7                	mov    %edx,%edi
  8006e5:	f3 ab                	rep stos %eax,%es:(%edi)
		char id[5]; char sname[50];
		ltostr(custId, id);
  8006e7:	83 ec 08             	sub    $0x8,%esp
  8006ea:	8d 85 5d fe ff ff    	lea    -0x1a3(%ebp),%eax
  8006f0:	50                   	push   %eax
  8006f1:	ff 75 b8             	pushl  -0x48(%ebp)
  8006f4:	e8 59 11 00 00       	call   801852 <ltostr>
  8006f9:	83 c4 10             	add    $0x10,%esp
		strcconcat(prefix, id, sname);
  8006fc:	83 ec 04             	sub    $0x4,%esp
  8006ff:	8d 85 26 fe ff ff    	lea    -0x1da(%ebp),%eax
  800705:	50                   	push   %eax
  800706:	8d 85 5d fe ff ff    	lea    -0x1a3(%ebp),%eax
  80070c:	50                   	push   %eax
  80070d:	8d 85 62 fe ff ff    	lea    -0x19e(%ebp),%eax
  800713:	50                   	push   %eax
  800714:	e8 12 12 00 00       	call   80192b <strcconcat>
  800719:	83 c4 10             	add    $0x10,%esp
		//sys_signalSemaphore(parentenvID, sname);
		struct semaphore cust_finished = get_semaphore(parentenvID, sname);
  80071c:	8d 85 58 fe ff ff    	lea    -0x1a8(%ebp),%eax
  800722:	83 ec 04             	sub    $0x4,%esp
  800725:	8d 95 26 fe ff ff    	lea    -0x1da(%ebp),%edx
  80072b:	52                   	push   %edx
  80072c:	ff 75 e4             	pushl  -0x1c(%ebp)
  80072f:	50                   	push   %eax
  800730:	e8 f6 25 00 00       	call   802d2b <get_semaphore>
  800735:	83 c4 0c             	add    $0xc,%esp
		signal_semaphore(cust_finished);
  800738:	83 ec 0c             	sub    $0xc,%esp
  80073b:	ff b5 58 fe ff ff    	pushl  -0x1a8(%ebp)
  800741:	e8 19 26 00 00       	call   802d5f <signal_semaphore>
  800746:	83 c4 10             	add    $0x10,%esp

		//signal the clerk
		signal_semaphore(clerk);
  800749:	83 ec 0c             	sub    $0xc,%esp
  80074c:	ff b5 84 fe ff ff    	pushl  -0x17c(%ebp)
  800752:	e8 08 26 00 00       	call   802d5f <signal_semaphore>
  800757:	83 c4 10             	add    $0x10,%esp
	struct semaphore flight1CS = get_semaphore(parentenvID, _flight1CS);
	struct semaphore flight2CS = get_semaphore(parentenvID, _flight2CS);
	struct semaphore clerk = get_semaphore(parentenvID, _clerk);
	struct semaphore clerkTerminated = get_semaphore(parentenvID, _clerkTerminated);

	while(*isOpened)
  80075a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80075d:	8b 00                	mov    (%eax),%eax
  80075f:	85 c0                	test   %eax,%eax
  800761:	0f 85 82 fc ff ff    	jne    8003e9 <_main+0x3b1>

		//signal the clerk
		signal_semaphore(clerk);
	}

	cprintf("\nclerk is finished...........\n");
  800767:	83 ec 0c             	sub    $0xc,%esp
  80076a:	68 20 31 80 00       	push   $0x803120
  80076f:	e8 b0 04 00 00       	call   800c24 <cprintf>
  800774:	83 c4 10             	add    $0x10,%esp
	signal_semaphore(clerkTerminated);
  800777:	83 ec 0c             	sub    $0xc,%esp
  80077a:	ff b5 80 fe ff ff    	pushl  -0x180(%ebp)
  800780:	e8 da 25 00 00       	call   802d5f <signal_semaphore>
  800785:	83 c4 10             	add    $0x10,%esp
}
  800788:	90                   	nop
  800789:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80078c:	5b                   	pop    %ebx
  80078d:	5e                   	pop    %esi
  80078e:	5f                   	pop    %edi
  80078f:	5d                   	pop    %ebp
  800790:	c3                   	ret    

00800791 <libmain>:
volatile bool printStats = 1;

volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";
void
libmain(int argc, char **argv)
{
  800791:	55                   	push   %ebp
  800792:	89 e5                	mov    %esp,%ebp
  800794:	57                   	push   %edi
  800795:	56                   	push   %esi
  800796:	53                   	push   %ebx
  800797:	83 ec 7c             	sub    $0x7c,%esp
	//printStats = 1;
	int envIndex = sys_getenvindex();
  80079a:	e8 09 18 00 00       	call   801fa8 <sys_getenvindex>
  80079f:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	myEnv = &(envs[envIndex]);
  8007a2:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8007a5:	89 d0                	mov    %edx,%eax
  8007a7:	c1 e0 06             	shl    $0x6,%eax
  8007aa:	29 d0                	sub    %edx,%eax
  8007ac:	c1 e0 02             	shl    $0x2,%eax
  8007af:	01 d0                	add    %edx,%eax
  8007b1:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8007b8:	01 c8                	add    %ecx,%eax
  8007ba:	c1 e0 03             	shl    $0x3,%eax
  8007bd:	01 d0                	add    %edx,%eax
  8007bf:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8007c6:	29 c2                	sub    %eax,%edx
  8007c8:	8d 04 95 00 00 00 00 	lea    0x0(,%edx,4),%eax
  8007cf:	89 c2                	mov    %eax,%edx
  8007d1:	8d 82 00 00 c0 ee    	lea    -0x11400000(%edx),%eax
  8007d7:	a3 20 40 80 00       	mov    %eax,0x804020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  8007dc:	a1 20 40 80 00       	mov    0x804020,%eax
  8007e1:	8a 40 20             	mov    0x20(%eax),%al
  8007e4:	84 c0                	test   %al,%al
  8007e6:	74 0d                	je     8007f5 <libmain+0x64>
		binaryname = myEnv->prog_name;
  8007e8:	a1 20 40 80 00       	mov    0x804020,%eax
  8007ed:	83 c0 20             	add    $0x20,%eax
  8007f0:	a3 04 40 80 00       	mov    %eax,0x804004

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8007f5:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8007f9:	7e 0a                	jle    800805 <libmain+0x74>
		binaryname = argv[0];
  8007fb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8007fe:	8b 00                	mov    (%eax),%eax
  800800:	a3 04 40 80 00       	mov    %eax,0x804004

	// call user main routine
	_main(argc, argv);
  800805:	83 ec 08             	sub    $0x8,%esp
  800808:	ff 75 0c             	pushl  0xc(%ebp)
  80080b:	ff 75 08             	pushl  0x8(%ebp)
  80080e:	e8 25 f8 ff ff       	call   800038 <_main>
  800813:	83 c4 10             	add    $0x10,%esp

	if (printStats)
  800816:	a1 00 40 80 00       	mov    0x804000,%eax
  80081b:	85 c0                	test   %eax,%eax
  80081d:	0f 84 01 01 00 00    	je     800924 <libmain+0x193>
	{
		char isOPTReplCmd[100] = "__IsOPTRepl__" ;
  800823:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  800829:	bb 68 33 80 00       	mov    $0x803368,%ebx
  80082e:	ba 0e 00 00 00       	mov    $0xe,%edx
  800833:	89 c7                	mov    %eax,%edi
  800835:	89 de                	mov    %ebx,%esi
  800837:	89 d1                	mov    %edx,%ecx
  800839:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  80083b:	8d 55 8a             	lea    -0x76(%ebp),%edx
  80083e:	b9 56 00 00 00       	mov    $0x56,%ecx
  800843:	b0 00                	mov    $0x0,%al
  800845:	89 d7                	mov    %edx,%edi
  800847:	f3 aa                	rep stos %al,%es:(%edi)
		int isOPTRepl = 0;
  800849:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
		sys_utilities(isOPTReplCmd, (uint32)(&isOPTRepl));
  800850:	8d 45 e0             	lea    -0x20(%ebp),%eax
  800853:	83 ec 08             	sub    $0x8,%esp
  800856:	50                   	push   %eax
  800857:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  80085d:	50                   	push   %eax
  80085e:	e8 7b 19 00 00       	call   8021de <sys_utilities>
  800863:	83 c4 10             	add    $0x10,%esp

		sys_lock_cons();
  800866:	e8 c4 14 00 00       	call   801d2f <sys_lock_cons>
		{
			cprintf("**************************************\n");
  80086b:	83 ec 0c             	sub    $0xc,%esp
  80086e:	68 88 32 80 00       	push   $0x803288
  800873:	e8 ac 03 00 00       	call   800c24 <cprintf>
  800878:	83 c4 10             	add    $0x10,%esp
			if (isOPTRepl)
  80087b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80087e:	85 c0                	test   %eax,%eax
  800880:	74 18                	je     80089a <libmain+0x109>
			{
				cprintf("OPTIMAL number of page faults = %d\n", sys_get_optimal_num_faults());
  800882:	e8 75 19 00 00       	call   8021fc <sys_get_optimal_num_faults>
  800887:	83 ec 08             	sub    $0x8,%esp
  80088a:	50                   	push   %eax
  80088b:	68 b0 32 80 00       	push   $0x8032b0
  800890:	e8 8f 03 00 00       	call   800c24 <cprintf>
  800895:	83 c4 10             	add    $0x10,%esp
  800898:	eb 59                	jmp    8008f3 <libmain+0x162>
			}
			else
			{
				cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  80089a:	a1 20 40 80 00       	mov    0x804020,%eax
  80089f:	8b 90 50 da 01 00    	mov    0x1da50(%eax),%edx
  8008a5:	a1 20 40 80 00       	mov    0x804020,%eax
  8008aa:	8b 80 40 da 01 00    	mov    0x1da40(%eax),%eax
  8008b0:	83 ec 04             	sub    $0x4,%esp
  8008b3:	52                   	push   %edx
  8008b4:	50                   	push   %eax
  8008b5:	68 d4 32 80 00       	push   $0x8032d4
  8008ba:	e8 65 03 00 00       	call   800c24 <cprintf>
  8008bf:	83 c4 10             	add    $0x10,%esp
				cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  8008c2:	a1 20 40 80 00       	mov    0x804020,%eax
  8008c7:	8b 88 64 da 01 00    	mov    0x1da64(%eax),%ecx
  8008cd:	a1 20 40 80 00       	mov    0x804020,%eax
  8008d2:	8b 90 60 da 01 00    	mov    0x1da60(%eax),%edx
  8008d8:	a1 20 40 80 00       	mov    0x804020,%eax
  8008dd:	8b 80 5c da 01 00    	mov    0x1da5c(%eax),%eax
  8008e3:	51                   	push   %ecx
  8008e4:	52                   	push   %edx
  8008e5:	50                   	push   %eax
  8008e6:	68 fc 32 80 00       	push   $0x8032fc
  8008eb:	e8 34 03 00 00       	call   800c24 <cprintf>
  8008f0:	83 c4 10             	add    $0x10,%esp
			}
			//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
			cprintf("Num of clocks = %d\n", myEnv->nClocks);
  8008f3:	a1 20 40 80 00       	mov    0x804020,%eax
  8008f8:	8b 80 68 da 01 00    	mov    0x1da68(%eax),%eax
  8008fe:	83 ec 08             	sub    $0x8,%esp
  800901:	50                   	push   %eax
  800902:	68 54 33 80 00       	push   $0x803354
  800907:	e8 18 03 00 00       	call   800c24 <cprintf>
  80090c:	83 c4 10             	add    $0x10,%esp
			cprintf("**************************************\n");
  80090f:	83 ec 0c             	sub    $0xc,%esp
  800912:	68 88 32 80 00       	push   $0x803288
  800917:	e8 08 03 00 00       	call   800c24 <cprintf>
  80091c:	83 c4 10             	add    $0x10,%esp
		}
		sys_unlock_cons();
  80091f:	e8 25 14 00 00       	call   801d49 <sys_unlock_cons>
	}

	// exit gracefully
	exit();
  800924:	e8 1f 00 00 00       	call   800948 <exit>
}
  800929:	90                   	nop
  80092a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80092d:	5b                   	pop    %ebx
  80092e:	5e                   	pop    %esi
  80092f:	5f                   	pop    %edi
  800930:	5d                   	pop    %ebp
  800931:	c3                   	ret    

00800932 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800932:	55                   	push   %ebp
  800933:	89 e5                	mov    %esp,%ebp
  800935:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800938:	83 ec 0c             	sub    $0xc,%esp
  80093b:	6a 00                	push   $0x0
  80093d:	e8 32 16 00 00       	call   801f74 <sys_destroy_env>
  800942:	83 c4 10             	add    $0x10,%esp
}
  800945:	90                   	nop
  800946:	c9                   	leave  
  800947:	c3                   	ret    

00800948 <exit>:

void
exit(void)
{
  800948:	55                   	push   %ebp
  800949:	89 e5                	mov    %esp,%ebp
  80094b:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  80094e:	e8 87 16 00 00       	call   801fda <sys_exit_env>
}
  800953:	90                   	nop
  800954:	c9                   	leave  
  800955:	c3                   	ret    

00800956 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  800956:	55                   	push   %ebp
  800957:	89 e5                	mov    %esp,%ebp
  800959:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  80095c:	8d 45 10             	lea    0x10(%ebp),%eax
  80095f:	83 c0 04             	add    $0x4,%eax
  800962:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  800965:	a1 18 c1 81 00       	mov    0x81c118,%eax
  80096a:	85 c0                	test   %eax,%eax
  80096c:	74 16                	je     800984 <_panic+0x2e>
		cprintf("%s: ", argv0);
  80096e:	a1 18 c1 81 00       	mov    0x81c118,%eax
  800973:	83 ec 08             	sub    $0x8,%esp
  800976:	50                   	push   %eax
  800977:	68 cc 33 80 00       	push   $0x8033cc
  80097c:	e8 a3 02 00 00       	call   800c24 <cprintf>
  800981:	83 c4 10             	add    $0x10,%esp
	cprintf_colored(TEXT_PANIC_CLR, "user [EVAL_FINAL]panic in %s at %s:%d: ", binaryname, file, line);
  800984:	a1 04 40 80 00       	mov    0x804004,%eax
  800989:	83 ec 0c             	sub    $0xc,%esp
  80098c:	ff 75 0c             	pushl  0xc(%ebp)
  80098f:	ff 75 08             	pushl  0x8(%ebp)
  800992:	50                   	push   %eax
  800993:	68 d4 33 80 00       	push   $0x8033d4
  800998:	6a 74                	push   $0x74
  80099a:	e8 b2 02 00 00       	call   800c51 <cprintf_colored>
  80099f:	83 c4 20             	add    $0x20,%esp
	vcprintf(fmt, ap);
  8009a2:	8b 45 10             	mov    0x10(%ebp),%eax
  8009a5:	83 ec 08             	sub    $0x8,%esp
  8009a8:	ff 75 f4             	pushl  -0xc(%ebp)
  8009ab:	50                   	push   %eax
  8009ac:	e8 04 02 00 00       	call   800bb5 <vcprintf>
  8009b1:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  8009b4:	83 ec 08             	sub    $0x8,%esp
  8009b7:	6a 00                	push   $0x0
  8009b9:	68 fc 33 80 00       	push   $0x8033fc
  8009be:	e8 f2 01 00 00       	call   800bb5 <vcprintf>
  8009c3:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  8009c6:	e8 7d ff ff ff       	call   800948 <exit>

	// should not return here
	while (1) ;
  8009cb:	eb fe                	jmp    8009cb <_panic+0x75>

008009cd <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  8009cd:	55                   	push   %ebp
  8009ce:	89 e5                	mov    %esp,%ebp
  8009d0:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  8009d3:	a1 20 40 80 00       	mov    0x804020,%eax
  8009d8:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  8009de:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009e1:	39 c2                	cmp    %eax,%edx
  8009e3:	74 14                	je     8009f9 <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  8009e5:	83 ec 04             	sub    $0x4,%esp
  8009e8:	68 00 34 80 00       	push   $0x803400
  8009ed:	6a 26                	push   $0x26
  8009ef:	68 4c 34 80 00       	push   $0x80344c
  8009f4:	e8 5d ff ff ff       	call   800956 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  8009f9:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  800a00:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800a07:	e9 c5 00 00 00       	jmp    800ad1 <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  800a0c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800a0f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800a16:	8b 45 08             	mov    0x8(%ebp),%eax
  800a19:	01 d0                	add    %edx,%eax
  800a1b:	8b 00                	mov    (%eax),%eax
  800a1d:	85 c0                	test   %eax,%eax
  800a1f:	75 08                	jne    800a29 <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  800a21:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  800a24:	e9 a5 00 00 00       	jmp    800ace <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  800a29:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800a30:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  800a37:	eb 69                	jmp    800aa2 <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  800a39:	a1 20 40 80 00       	mov    0x804020,%eax
  800a3e:	8b 88 38 da 01 00    	mov    0x1da38(%eax),%ecx
  800a44:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800a47:	89 d0                	mov    %edx,%eax
  800a49:	01 c0                	add    %eax,%eax
  800a4b:	01 d0                	add    %edx,%eax
  800a4d:	c1 e0 03             	shl    $0x3,%eax
  800a50:	01 c8                	add    %ecx,%eax
  800a52:	8a 40 04             	mov    0x4(%eax),%al
  800a55:	84 c0                	test   %al,%al
  800a57:	75 46                	jne    800a9f <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800a59:	a1 20 40 80 00       	mov    0x804020,%eax
  800a5e:	8b 88 38 da 01 00    	mov    0x1da38(%eax),%ecx
  800a64:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800a67:	89 d0                	mov    %edx,%eax
  800a69:	01 c0                	add    %eax,%eax
  800a6b:	01 d0                	add    %edx,%eax
  800a6d:	c1 e0 03             	shl    $0x3,%eax
  800a70:	01 c8                	add    %ecx,%eax
  800a72:	8b 00                	mov    (%eax),%eax
  800a74:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800a77:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800a7a:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800a7f:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  800a81:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800a84:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800a8b:	8b 45 08             	mov    0x8(%ebp),%eax
  800a8e:	01 c8                	add    %ecx,%eax
  800a90:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800a92:	39 c2                	cmp    %eax,%edx
  800a94:	75 09                	jne    800a9f <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  800a96:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  800a9d:	eb 15                	jmp    800ab4 <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800a9f:	ff 45 e8             	incl   -0x18(%ebp)
  800aa2:	a1 20 40 80 00       	mov    0x804020,%eax
  800aa7:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  800aad:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800ab0:	39 c2                	cmp    %eax,%edx
  800ab2:	77 85                	ja     800a39 <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  800ab4:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800ab8:	75 14                	jne    800ace <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  800aba:	83 ec 04             	sub    $0x4,%esp
  800abd:	68 58 34 80 00       	push   $0x803458
  800ac2:	6a 3a                	push   $0x3a
  800ac4:	68 4c 34 80 00       	push   $0x80344c
  800ac9:	e8 88 fe ff ff       	call   800956 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  800ace:	ff 45 f0             	incl   -0x10(%ebp)
  800ad1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800ad4:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800ad7:	0f 8c 2f ff ff ff    	jl     800a0c <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  800add:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800ae4:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800aeb:	eb 26                	jmp    800b13 <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  800aed:	a1 20 40 80 00       	mov    0x804020,%eax
  800af2:	8b 88 38 da 01 00    	mov    0x1da38(%eax),%ecx
  800af8:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800afb:	89 d0                	mov    %edx,%eax
  800afd:	01 c0                	add    %eax,%eax
  800aff:	01 d0                	add    %edx,%eax
  800b01:	c1 e0 03             	shl    $0x3,%eax
  800b04:	01 c8                	add    %ecx,%eax
  800b06:	8a 40 04             	mov    0x4(%eax),%al
  800b09:	3c 01                	cmp    $0x1,%al
  800b0b:	75 03                	jne    800b10 <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  800b0d:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800b10:	ff 45 e0             	incl   -0x20(%ebp)
  800b13:	a1 20 40 80 00       	mov    0x804020,%eax
  800b18:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  800b1e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800b21:	39 c2                	cmp    %eax,%edx
  800b23:	77 c8                	ja     800aed <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  800b25:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800b28:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800b2b:	74 14                	je     800b41 <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  800b2d:	83 ec 04             	sub    $0x4,%esp
  800b30:	68 ac 34 80 00       	push   $0x8034ac
  800b35:	6a 44                	push   $0x44
  800b37:	68 4c 34 80 00       	push   $0x80344c
  800b3c:	e8 15 fe ff ff       	call   800956 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  800b41:	90                   	nop
  800b42:	c9                   	leave  
  800b43:	c3                   	ret    

00800b44 <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  800b44:	55                   	push   %ebp
  800b45:	89 e5                	mov    %esp,%ebp
  800b47:	53                   	push   %ebx
  800b48:	83 ec 04             	sub    $0x4,%esp
	b->buf[b->idx++] = ch;
  800b4b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b4e:	8b 00                	mov    (%eax),%eax
  800b50:	8d 48 01             	lea    0x1(%eax),%ecx
  800b53:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b56:	89 0a                	mov    %ecx,(%edx)
  800b58:	8b 55 08             	mov    0x8(%ebp),%edx
  800b5b:	88 d1                	mov    %dl,%cl
  800b5d:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b60:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800b64:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b67:	8b 00                	mov    (%eax),%eax
  800b69:	3d ff 00 00 00       	cmp    $0xff,%eax
  800b6e:	75 30                	jne    800ba0 <putch+0x5c>
		sys_cputs(b->buf, b->idx, printProgName, curTextClr);
  800b70:	8b 15 1c c1 81 00    	mov    0x81c11c,%edx
  800b76:	a0 44 40 80 00       	mov    0x804044,%al
  800b7b:	0f b6 c0             	movzbl %al,%eax
  800b7e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800b81:	8b 09                	mov    (%ecx),%ecx
  800b83:	89 cb                	mov    %ecx,%ebx
  800b85:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800b88:	83 c1 08             	add    $0x8,%ecx
  800b8b:	52                   	push   %edx
  800b8c:	50                   	push   %eax
  800b8d:	53                   	push   %ebx
  800b8e:	51                   	push   %ecx
  800b8f:	e8 57 11 00 00       	call   801ceb <sys_cputs>
  800b94:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800b97:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b9a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800ba0:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ba3:	8b 40 04             	mov    0x4(%eax),%eax
  800ba6:	8d 50 01             	lea    0x1(%eax),%edx
  800ba9:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bac:	89 50 04             	mov    %edx,0x4(%eax)
}
  800baf:	90                   	nop
  800bb0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800bb3:	c9                   	leave  
  800bb4:	c3                   	ret    

00800bb5 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800bb5:	55                   	push   %ebp
  800bb6:	89 e5                	mov    %esp,%ebp
  800bb8:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800bbe:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800bc5:	00 00 00 
	b.cnt = 0;
  800bc8:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800bcf:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800bd2:	ff 75 0c             	pushl  0xc(%ebp)
  800bd5:	ff 75 08             	pushl  0x8(%ebp)
  800bd8:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800bde:	50                   	push   %eax
  800bdf:	68 44 0b 80 00       	push   $0x800b44
  800be4:	e8 5a 02 00 00       	call   800e43 <vprintfmt>
  800be9:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName, curTextClr);
  800bec:	8b 15 1c c1 81 00    	mov    0x81c11c,%edx
  800bf2:	a0 44 40 80 00       	mov    0x804044,%al
  800bf7:	0f b6 c0             	movzbl %al,%eax
  800bfa:	8b 8d f0 fe ff ff    	mov    -0x110(%ebp),%ecx
  800c00:	52                   	push   %edx
  800c01:	50                   	push   %eax
  800c02:	51                   	push   %ecx
  800c03:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800c09:	83 c0 08             	add    $0x8,%eax
  800c0c:	50                   	push   %eax
  800c0d:	e8 d9 10 00 00       	call   801ceb <sys_cputs>
  800c12:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800c15:	c6 05 44 40 80 00 00 	movb   $0x0,0x804044
	return b.cnt;
  800c1c:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800c22:	c9                   	leave  
  800c23:	c3                   	ret    

00800c24 <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  800c24:	55                   	push   %ebp
  800c25:	89 e5                	mov    %esp,%ebp
  800c27:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800c2a:	c6 05 44 40 80 00 01 	movb   $0x1,0x804044
	va_start(ap, fmt);
  800c31:	8d 45 0c             	lea    0xc(%ebp),%eax
  800c34:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800c37:	8b 45 08             	mov    0x8(%ebp),%eax
  800c3a:	83 ec 08             	sub    $0x8,%esp
  800c3d:	ff 75 f4             	pushl  -0xc(%ebp)
  800c40:	50                   	push   %eax
  800c41:	e8 6f ff ff ff       	call   800bb5 <vcprintf>
  800c46:	83 c4 10             	add    $0x10,%esp
  800c49:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800c4c:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800c4f:	c9                   	leave  
  800c50:	c3                   	ret    

00800c51 <cprintf_colored>:

// *************** This text coloring feature is implemented by *************
// ********** Abd-Alrahman Zedan From Team Frozen-Bytes - FCIS'24-25 ********
int cprintf_colored(int textClr, const char *fmt, ...) {
  800c51:	55                   	push   %ebp
  800c52:	89 e5                	mov    %esp,%ebp
  800c54:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800c57:	c6 05 44 40 80 00 01 	movb   $0x1,0x804044
	curTextClr = (textClr << 8) ; //set text color by the given value
  800c5e:	8b 45 08             	mov    0x8(%ebp),%eax
  800c61:	c1 e0 08             	shl    $0x8,%eax
  800c64:	a3 1c c1 81 00       	mov    %eax,0x81c11c
	va_start(ap, fmt);
  800c69:	8d 45 0c             	lea    0xc(%ebp),%eax
  800c6c:	83 c0 04             	add    $0x4,%eax
  800c6f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800c72:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c75:	83 ec 08             	sub    $0x8,%esp
  800c78:	ff 75 f4             	pushl  -0xc(%ebp)
  800c7b:	50                   	push   %eax
  800c7c:	e8 34 ff ff ff       	call   800bb5 <vcprintf>
  800c81:	83 c4 10             	add    $0x10,%esp
  800c84:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);
	curTextClr = TEXT_DEFAULT_CLR; //restore default color
  800c87:	c7 05 1c c1 81 00 00 	movl   $0x700,0x81c11c
  800c8e:	07 00 00 

	return cnt;
  800c91:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800c94:	c9                   	leave  
  800c95:	c3                   	ret    

00800c96 <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  800c96:	55                   	push   %ebp
  800c97:	89 e5                	mov    %esp,%ebp
  800c99:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  800c9c:	e8 8e 10 00 00       	call   801d2f <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  800ca1:	8d 45 0c             	lea    0xc(%ebp),%eax
  800ca4:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  800ca7:	8b 45 08             	mov    0x8(%ebp),%eax
  800caa:	83 ec 08             	sub    $0x8,%esp
  800cad:	ff 75 f4             	pushl  -0xc(%ebp)
  800cb0:	50                   	push   %eax
  800cb1:	e8 ff fe ff ff       	call   800bb5 <vcprintf>
  800cb6:	83 c4 10             	add    $0x10,%esp
  800cb9:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  800cbc:	e8 88 10 00 00       	call   801d49 <sys_unlock_cons>
	return cnt;
  800cc1:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800cc4:	c9                   	leave  
  800cc5:	c3                   	ret    

00800cc6 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800cc6:	55                   	push   %ebp
  800cc7:	89 e5                	mov    %esp,%ebp
  800cc9:	53                   	push   %ebx
  800cca:	83 ec 14             	sub    $0x14,%esp
  800ccd:	8b 45 10             	mov    0x10(%ebp),%eax
  800cd0:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800cd3:	8b 45 14             	mov    0x14(%ebp),%eax
  800cd6:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800cd9:	8b 45 18             	mov    0x18(%ebp),%eax
  800cdc:	ba 00 00 00 00       	mov    $0x0,%edx
  800ce1:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800ce4:	77 55                	ja     800d3b <printnum+0x75>
  800ce6:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800ce9:	72 05                	jb     800cf0 <printnum+0x2a>
  800ceb:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800cee:	77 4b                	ja     800d3b <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800cf0:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800cf3:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800cf6:	8b 45 18             	mov    0x18(%ebp),%eax
  800cf9:	ba 00 00 00 00       	mov    $0x0,%edx
  800cfe:	52                   	push   %edx
  800cff:	50                   	push   %eax
  800d00:	ff 75 f4             	pushl  -0xc(%ebp)
  800d03:	ff 75 f0             	pushl  -0x10(%ebp)
  800d06:	e8 79 20 00 00       	call   802d84 <__udivdi3>
  800d0b:	83 c4 10             	add    $0x10,%esp
  800d0e:	83 ec 04             	sub    $0x4,%esp
  800d11:	ff 75 20             	pushl  0x20(%ebp)
  800d14:	53                   	push   %ebx
  800d15:	ff 75 18             	pushl  0x18(%ebp)
  800d18:	52                   	push   %edx
  800d19:	50                   	push   %eax
  800d1a:	ff 75 0c             	pushl  0xc(%ebp)
  800d1d:	ff 75 08             	pushl  0x8(%ebp)
  800d20:	e8 a1 ff ff ff       	call   800cc6 <printnum>
  800d25:	83 c4 20             	add    $0x20,%esp
  800d28:	eb 1a                	jmp    800d44 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800d2a:	83 ec 08             	sub    $0x8,%esp
  800d2d:	ff 75 0c             	pushl  0xc(%ebp)
  800d30:	ff 75 20             	pushl  0x20(%ebp)
  800d33:	8b 45 08             	mov    0x8(%ebp),%eax
  800d36:	ff d0                	call   *%eax
  800d38:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800d3b:	ff 4d 1c             	decl   0x1c(%ebp)
  800d3e:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800d42:	7f e6                	jg     800d2a <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800d44:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800d47:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d4c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800d4f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800d52:	53                   	push   %ebx
  800d53:	51                   	push   %ecx
  800d54:	52                   	push   %edx
  800d55:	50                   	push   %eax
  800d56:	e8 39 21 00 00       	call   802e94 <__umoddi3>
  800d5b:	83 c4 10             	add    $0x10,%esp
  800d5e:	05 14 37 80 00       	add    $0x803714,%eax
  800d63:	8a 00                	mov    (%eax),%al
  800d65:	0f be c0             	movsbl %al,%eax
  800d68:	83 ec 08             	sub    $0x8,%esp
  800d6b:	ff 75 0c             	pushl  0xc(%ebp)
  800d6e:	50                   	push   %eax
  800d6f:	8b 45 08             	mov    0x8(%ebp),%eax
  800d72:	ff d0                	call   *%eax
  800d74:	83 c4 10             	add    $0x10,%esp
}
  800d77:	90                   	nop
  800d78:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800d7b:	c9                   	leave  
  800d7c:	c3                   	ret    

00800d7d <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800d7d:	55                   	push   %ebp
  800d7e:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800d80:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800d84:	7e 1c                	jle    800da2 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800d86:	8b 45 08             	mov    0x8(%ebp),%eax
  800d89:	8b 00                	mov    (%eax),%eax
  800d8b:	8d 50 08             	lea    0x8(%eax),%edx
  800d8e:	8b 45 08             	mov    0x8(%ebp),%eax
  800d91:	89 10                	mov    %edx,(%eax)
  800d93:	8b 45 08             	mov    0x8(%ebp),%eax
  800d96:	8b 00                	mov    (%eax),%eax
  800d98:	83 e8 08             	sub    $0x8,%eax
  800d9b:	8b 50 04             	mov    0x4(%eax),%edx
  800d9e:	8b 00                	mov    (%eax),%eax
  800da0:	eb 40                	jmp    800de2 <getuint+0x65>
	else if (lflag)
  800da2:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800da6:	74 1e                	je     800dc6 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800da8:	8b 45 08             	mov    0x8(%ebp),%eax
  800dab:	8b 00                	mov    (%eax),%eax
  800dad:	8d 50 04             	lea    0x4(%eax),%edx
  800db0:	8b 45 08             	mov    0x8(%ebp),%eax
  800db3:	89 10                	mov    %edx,(%eax)
  800db5:	8b 45 08             	mov    0x8(%ebp),%eax
  800db8:	8b 00                	mov    (%eax),%eax
  800dba:	83 e8 04             	sub    $0x4,%eax
  800dbd:	8b 00                	mov    (%eax),%eax
  800dbf:	ba 00 00 00 00       	mov    $0x0,%edx
  800dc4:	eb 1c                	jmp    800de2 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800dc6:	8b 45 08             	mov    0x8(%ebp),%eax
  800dc9:	8b 00                	mov    (%eax),%eax
  800dcb:	8d 50 04             	lea    0x4(%eax),%edx
  800dce:	8b 45 08             	mov    0x8(%ebp),%eax
  800dd1:	89 10                	mov    %edx,(%eax)
  800dd3:	8b 45 08             	mov    0x8(%ebp),%eax
  800dd6:	8b 00                	mov    (%eax),%eax
  800dd8:	83 e8 04             	sub    $0x4,%eax
  800ddb:	8b 00                	mov    (%eax),%eax
  800ddd:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800de2:	5d                   	pop    %ebp
  800de3:	c3                   	ret    

00800de4 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800de4:	55                   	push   %ebp
  800de5:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800de7:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800deb:	7e 1c                	jle    800e09 <getint+0x25>
		return va_arg(*ap, long long);
  800ded:	8b 45 08             	mov    0x8(%ebp),%eax
  800df0:	8b 00                	mov    (%eax),%eax
  800df2:	8d 50 08             	lea    0x8(%eax),%edx
  800df5:	8b 45 08             	mov    0x8(%ebp),%eax
  800df8:	89 10                	mov    %edx,(%eax)
  800dfa:	8b 45 08             	mov    0x8(%ebp),%eax
  800dfd:	8b 00                	mov    (%eax),%eax
  800dff:	83 e8 08             	sub    $0x8,%eax
  800e02:	8b 50 04             	mov    0x4(%eax),%edx
  800e05:	8b 00                	mov    (%eax),%eax
  800e07:	eb 38                	jmp    800e41 <getint+0x5d>
	else if (lflag)
  800e09:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800e0d:	74 1a                	je     800e29 <getint+0x45>
		return va_arg(*ap, long);
  800e0f:	8b 45 08             	mov    0x8(%ebp),%eax
  800e12:	8b 00                	mov    (%eax),%eax
  800e14:	8d 50 04             	lea    0x4(%eax),%edx
  800e17:	8b 45 08             	mov    0x8(%ebp),%eax
  800e1a:	89 10                	mov    %edx,(%eax)
  800e1c:	8b 45 08             	mov    0x8(%ebp),%eax
  800e1f:	8b 00                	mov    (%eax),%eax
  800e21:	83 e8 04             	sub    $0x4,%eax
  800e24:	8b 00                	mov    (%eax),%eax
  800e26:	99                   	cltd   
  800e27:	eb 18                	jmp    800e41 <getint+0x5d>
	else
		return va_arg(*ap, int);
  800e29:	8b 45 08             	mov    0x8(%ebp),%eax
  800e2c:	8b 00                	mov    (%eax),%eax
  800e2e:	8d 50 04             	lea    0x4(%eax),%edx
  800e31:	8b 45 08             	mov    0x8(%ebp),%eax
  800e34:	89 10                	mov    %edx,(%eax)
  800e36:	8b 45 08             	mov    0x8(%ebp),%eax
  800e39:	8b 00                	mov    (%eax),%eax
  800e3b:	83 e8 04             	sub    $0x4,%eax
  800e3e:	8b 00                	mov    (%eax),%eax
  800e40:	99                   	cltd   
}
  800e41:	5d                   	pop    %ebp
  800e42:	c3                   	ret    

00800e43 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800e43:	55                   	push   %ebp
  800e44:	89 e5                	mov    %esp,%ebp
  800e46:	56                   	push   %esi
  800e47:	53                   	push   %ebx
  800e48:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800e4b:	eb 17                	jmp    800e64 <vprintfmt+0x21>
			if (ch == '\0')
  800e4d:	85 db                	test   %ebx,%ebx
  800e4f:	0f 84 c1 03 00 00    	je     801216 <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  800e55:	83 ec 08             	sub    $0x8,%esp
  800e58:	ff 75 0c             	pushl  0xc(%ebp)
  800e5b:	53                   	push   %ebx
  800e5c:	8b 45 08             	mov    0x8(%ebp),%eax
  800e5f:	ff d0                	call   *%eax
  800e61:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800e64:	8b 45 10             	mov    0x10(%ebp),%eax
  800e67:	8d 50 01             	lea    0x1(%eax),%edx
  800e6a:	89 55 10             	mov    %edx,0x10(%ebp)
  800e6d:	8a 00                	mov    (%eax),%al
  800e6f:	0f b6 d8             	movzbl %al,%ebx
  800e72:	83 fb 25             	cmp    $0x25,%ebx
  800e75:	75 d6                	jne    800e4d <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800e77:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800e7b:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800e82:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800e89:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800e90:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800e97:	8b 45 10             	mov    0x10(%ebp),%eax
  800e9a:	8d 50 01             	lea    0x1(%eax),%edx
  800e9d:	89 55 10             	mov    %edx,0x10(%ebp)
  800ea0:	8a 00                	mov    (%eax),%al
  800ea2:	0f b6 d8             	movzbl %al,%ebx
  800ea5:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800ea8:	83 f8 5b             	cmp    $0x5b,%eax
  800eab:	0f 87 3d 03 00 00    	ja     8011ee <vprintfmt+0x3ab>
  800eb1:	8b 04 85 38 37 80 00 	mov    0x803738(,%eax,4),%eax
  800eb8:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800eba:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800ebe:	eb d7                	jmp    800e97 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800ec0:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800ec4:	eb d1                	jmp    800e97 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800ec6:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800ecd:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800ed0:	89 d0                	mov    %edx,%eax
  800ed2:	c1 e0 02             	shl    $0x2,%eax
  800ed5:	01 d0                	add    %edx,%eax
  800ed7:	01 c0                	add    %eax,%eax
  800ed9:	01 d8                	add    %ebx,%eax
  800edb:	83 e8 30             	sub    $0x30,%eax
  800ede:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800ee1:	8b 45 10             	mov    0x10(%ebp),%eax
  800ee4:	8a 00                	mov    (%eax),%al
  800ee6:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800ee9:	83 fb 2f             	cmp    $0x2f,%ebx
  800eec:	7e 3e                	jle    800f2c <vprintfmt+0xe9>
  800eee:	83 fb 39             	cmp    $0x39,%ebx
  800ef1:	7f 39                	jg     800f2c <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800ef3:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800ef6:	eb d5                	jmp    800ecd <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800ef8:	8b 45 14             	mov    0x14(%ebp),%eax
  800efb:	83 c0 04             	add    $0x4,%eax
  800efe:	89 45 14             	mov    %eax,0x14(%ebp)
  800f01:	8b 45 14             	mov    0x14(%ebp),%eax
  800f04:	83 e8 04             	sub    $0x4,%eax
  800f07:	8b 00                	mov    (%eax),%eax
  800f09:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800f0c:	eb 1f                	jmp    800f2d <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800f0e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800f12:	79 83                	jns    800e97 <vprintfmt+0x54>
				width = 0;
  800f14:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800f1b:	e9 77 ff ff ff       	jmp    800e97 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800f20:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800f27:	e9 6b ff ff ff       	jmp    800e97 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800f2c:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800f2d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800f31:	0f 89 60 ff ff ff    	jns    800e97 <vprintfmt+0x54>
				width = precision, precision = -1;
  800f37:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800f3a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800f3d:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800f44:	e9 4e ff ff ff       	jmp    800e97 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800f49:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800f4c:	e9 46 ff ff ff       	jmp    800e97 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800f51:	8b 45 14             	mov    0x14(%ebp),%eax
  800f54:	83 c0 04             	add    $0x4,%eax
  800f57:	89 45 14             	mov    %eax,0x14(%ebp)
  800f5a:	8b 45 14             	mov    0x14(%ebp),%eax
  800f5d:	83 e8 04             	sub    $0x4,%eax
  800f60:	8b 00                	mov    (%eax),%eax
  800f62:	83 ec 08             	sub    $0x8,%esp
  800f65:	ff 75 0c             	pushl  0xc(%ebp)
  800f68:	50                   	push   %eax
  800f69:	8b 45 08             	mov    0x8(%ebp),%eax
  800f6c:	ff d0                	call   *%eax
  800f6e:	83 c4 10             	add    $0x10,%esp
			break;
  800f71:	e9 9b 02 00 00       	jmp    801211 <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800f76:	8b 45 14             	mov    0x14(%ebp),%eax
  800f79:	83 c0 04             	add    $0x4,%eax
  800f7c:	89 45 14             	mov    %eax,0x14(%ebp)
  800f7f:	8b 45 14             	mov    0x14(%ebp),%eax
  800f82:	83 e8 04             	sub    $0x4,%eax
  800f85:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800f87:	85 db                	test   %ebx,%ebx
  800f89:	79 02                	jns    800f8d <vprintfmt+0x14a>
				err = -err;
  800f8b:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800f8d:	83 fb 64             	cmp    $0x64,%ebx
  800f90:	7f 0b                	jg     800f9d <vprintfmt+0x15a>
  800f92:	8b 34 9d 80 35 80 00 	mov    0x803580(,%ebx,4),%esi
  800f99:	85 f6                	test   %esi,%esi
  800f9b:	75 19                	jne    800fb6 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800f9d:	53                   	push   %ebx
  800f9e:	68 25 37 80 00       	push   $0x803725
  800fa3:	ff 75 0c             	pushl  0xc(%ebp)
  800fa6:	ff 75 08             	pushl  0x8(%ebp)
  800fa9:	e8 70 02 00 00       	call   80121e <printfmt>
  800fae:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800fb1:	e9 5b 02 00 00       	jmp    801211 <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800fb6:	56                   	push   %esi
  800fb7:	68 2e 37 80 00       	push   $0x80372e
  800fbc:	ff 75 0c             	pushl  0xc(%ebp)
  800fbf:	ff 75 08             	pushl  0x8(%ebp)
  800fc2:	e8 57 02 00 00       	call   80121e <printfmt>
  800fc7:	83 c4 10             	add    $0x10,%esp
			break;
  800fca:	e9 42 02 00 00       	jmp    801211 <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800fcf:	8b 45 14             	mov    0x14(%ebp),%eax
  800fd2:	83 c0 04             	add    $0x4,%eax
  800fd5:	89 45 14             	mov    %eax,0x14(%ebp)
  800fd8:	8b 45 14             	mov    0x14(%ebp),%eax
  800fdb:	83 e8 04             	sub    $0x4,%eax
  800fde:	8b 30                	mov    (%eax),%esi
  800fe0:	85 f6                	test   %esi,%esi
  800fe2:	75 05                	jne    800fe9 <vprintfmt+0x1a6>
				p = "(null)";
  800fe4:	be 31 37 80 00       	mov    $0x803731,%esi
			if (width > 0 && padc != '-')
  800fe9:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800fed:	7e 6d                	jle    80105c <vprintfmt+0x219>
  800fef:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800ff3:	74 67                	je     80105c <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800ff5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800ff8:	83 ec 08             	sub    $0x8,%esp
  800ffb:	50                   	push   %eax
  800ffc:	56                   	push   %esi
  800ffd:	e8 1e 03 00 00       	call   801320 <strnlen>
  801002:	83 c4 10             	add    $0x10,%esp
  801005:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  801008:	eb 16                	jmp    801020 <vprintfmt+0x1dd>
					putch(padc, putdat);
  80100a:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  80100e:	83 ec 08             	sub    $0x8,%esp
  801011:	ff 75 0c             	pushl  0xc(%ebp)
  801014:	50                   	push   %eax
  801015:	8b 45 08             	mov    0x8(%ebp),%eax
  801018:	ff d0                	call   *%eax
  80101a:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  80101d:	ff 4d e4             	decl   -0x1c(%ebp)
  801020:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801024:	7f e4                	jg     80100a <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  801026:	eb 34                	jmp    80105c <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  801028:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  80102c:	74 1c                	je     80104a <vprintfmt+0x207>
  80102e:	83 fb 1f             	cmp    $0x1f,%ebx
  801031:	7e 05                	jle    801038 <vprintfmt+0x1f5>
  801033:	83 fb 7e             	cmp    $0x7e,%ebx
  801036:	7e 12                	jle    80104a <vprintfmt+0x207>
					putch('?', putdat);
  801038:	83 ec 08             	sub    $0x8,%esp
  80103b:	ff 75 0c             	pushl  0xc(%ebp)
  80103e:	6a 3f                	push   $0x3f
  801040:	8b 45 08             	mov    0x8(%ebp),%eax
  801043:	ff d0                	call   *%eax
  801045:	83 c4 10             	add    $0x10,%esp
  801048:	eb 0f                	jmp    801059 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  80104a:	83 ec 08             	sub    $0x8,%esp
  80104d:	ff 75 0c             	pushl  0xc(%ebp)
  801050:	53                   	push   %ebx
  801051:	8b 45 08             	mov    0x8(%ebp),%eax
  801054:	ff d0                	call   *%eax
  801056:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  801059:	ff 4d e4             	decl   -0x1c(%ebp)
  80105c:	89 f0                	mov    %esi,%eax
  80105e:	8d 70 01             	lea    0x1(%eax),%esi
  801061:	8a 00                	mov    (%eax),%al
  801063:	0f be d8             	movsbl %al,%ebx
  801066:	85 db                	test   %ebx,%ebx
  801068:	74 24                	je     80108e <vprintfmt+0x24b>
  80106a:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80106e:	78 b8                	js     801028 <vprintfmt+0x1e5>
  801070:	ff 4d e0             	decl   -0x20(%ebp)
  801073:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801077:	79 af                	jns    801028 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  801079:	eb 13                	jmp    80108e <vprintfmt+0x24b>
				putch(' ', putdat);
  80107b:	83 ec 08             	sub    $0x8,%esp
  80107e:	ff 75 0c             	pushl  0xc(%ebp)
  801081:	6a 20                	push   $0x20
  801083:	8b 45 08             	mov    0x8(%ebp),%eax
  801086:	ff d0                	call   *%eax
  801088:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  80108b:	ff 4d e4             	decl   -0x1c(%ebp)
  80108e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801092:	7f e7                	jg     80107b <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  801094:	e9 78 01 00 00       	jmp    801211 <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  801099:	83 ec 08             	sub    $0x8,%esp
  80109c:	ff 75 e8             	pushl  -0x18(%ebp)
  80109f:	8d 45 14             	lea    0x14(%ebp),%eax
  8010a2:	50                   	push   %eax
  8010a3:	e8 3c fd ff ff       	call   800de4 <getint>
  8010a8:	83 c4 10             	add    $0x10,%esp
  8010ab:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8010ae:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  8010b1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8010b4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8010b7:	85 d2                	test   %edx,%edx
  8010b9:	79 23                	jns    8010de <vprintfmt+0x29b>
				putch('-', putdat);
  8010bb:	83 ec 08             	sub    $0x8,%esp
  8010be:	ff 75 0c             	pushl  0xc(%ebp)
  8010c1:	6a 2d                	push   $0x2d
  8010c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8010c6:	ff d0                	call   *%eax
  8010c8:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  8010cb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8010ce:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8010d1:	f7 d8                	neg    %eax
  8010d3:	83 d2 00             	adc    $0x0,%edx
  8010d6:	f7 da                	neg    %edx
  8010d8:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8010db:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  8010de:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8010e5:	e9 bc 00 00 00       	jmp    8011a6 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  8010ea:	83 ec 08             	sub    $0x8,%esp
  8010ed:	ff 75 e8             	pushl  -0x18(%ebp)
  8010f0:	8d 45 14             	lea    0x14(%ebp),%eax
  8010f3:	50                   	push   %eax
  8010f4:	e8 84 fc ff ff       	call   800d7d <getuint>
  8010f9:	83 c4 10             	add    $0x10,%esp
  8010fc:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8010ff:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  801102:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  801109:	e9 98 00 00 00       	jmp    8011a6 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  80110e:	83 ec 08             	sub    $0x8,%esp
  801111:	ff 75 0c             	pushl  0xc(%ebp)
  801114:	6a 58                	push   $0x58
  801116:	8b 45 08             	mov    0x8(%ebp),%eax
  801119:	ff d0                	call   *%eax
  80111b:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  80111e:	83 ec 08             	sub    $0x8,%esp
  801121:	ff 75 0c             	pushl  0xc(%ebp)
  801124:	6a 58                	push   $0x58
  801126:	8b 45 08             	mov    0x8(%ebp),%eax
  801129:	ff d0                	call   *%eax
  80112b:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  80112e:	83 ec 08             	sub    $0x8,%esp
  801131:	ff 75 0c             	pushl  0xc(%ebp)
  801134:	6a 58                	push   $0x58
  801136:	8b 45 08             	mov    0x8(%ebp),%eax
  801139:	ff d0                	call   *%eax
  80113b:	83 c4 10             	add    $0x10,%esp
			break;
  80113e:	e9 ce 00 00 00       	jmp    801211 <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  801143:	83 ec 08             	sub    $0x8,%esp
  801146:	ff 75 0c             	pushl  0xc(%ebp)
  801149:	6a 30                	push   $0x30
  80114b:	8b 45 08             	mov    0x8(%ebp),%eax
  80114e:	ff d0                	call   *%eax
  801150:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  801153:	83 ec 08             	sub    $0x8,%esp
  801156:	ff 75 0c             	pushl  0xc(%ebp)
  801159:	6a 78                	push   $0x78
  80115b:	8b 45 08             	mov    0x8(%ebp),%eax
  80115e:	ff d0                	call   *%eax
  801160:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  801163:	8b 45 14             	mov    0x14(%ebp),%eax
  801166:	83 c0 04             	add    $0x4,%eax
  801169:	89 45 14             	mov    %eax,0x14(%ebp)
  80116c:	8b 45 14             	mov    0x14(%ebp),%eax
  80116f:	83 e8 04             	sub    $0x4,%eax
  801172:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  801174:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801177:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  80117e:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  801185:	eb 1f                	jmp    8011a6 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  801187:	83 ec 08             	sub    $0x8,%esp
  80118a:	ff 75 e8             	pushl  -0x18(%ebp)
  80118d:	8d 45 14             	lea    0x14(%ebp),%eax
  801190:	50                   	push   %eax
  801191:	e8 e7 fb ff ff       	call   800d7d <getuint>
  801196:	83 c4 10             	add    $0x10,%esp
  801199:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80119c:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  80119f:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  8011a6:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  8011aa:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8011ad:	83 ec 04             	sub    $0x4,%esp
  8011b0:	52                   	push   %edx
  8011b1:	ff 75 e4             	pushl  -0x1c(%ebp)
  8011b4:	50                   	push   %eax
  8011b5:	ff 75 f4             	pushl  -0xc(%ebp)
  8011b8:	ff 75 f0             	pushl  -0x10(%ebp)
  8011bb:	ff 75 0c             	pushl  0xc(%ebp)
  8011be:	ff 75 08             	pushl  0x8(%ebp)
  8011c1:	e8 00 fb ff ff       	call   800cc6 <printnum>
  8011c6:	83 c4 20             	add    $0x20,%esp
			break;
  8011c9:	eb 46                	jmp    801211 <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  8011cb:	83 ec 08             	sub    $0x8,%esp
  8011ce:	ff 75 0c             	pushl  0xc(%ebp)
  8011d1:	53                   	push   %ebx
  8011d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8011d5:	ff d0                	call   *%eax
  8011d7:	83 c4 10             	add    $0x10,%esp
			break;
  8011da:	eb 35                	jmp    801211 <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  8011dc:	c6 05 44 40 80 00 00 	movb   $0x0,0x804044
			break;
  8011e3:	eb 2c                	jmp    801211 <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  8011e5:	c6 05 44 40 80 00 01 	movb   $0x1,0x804044
			break;
  8011ec:	eb 23                	jmp    801211 <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  8011ee:	83 ec 08             	sub    $0x8,%esp
  8011f1:	ff 75 0c             	pushl  0xc(%ebp)
  8011f4:	6a 25                	push   $0x25
  8011f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8011f9:	ff d0                	call   *%eax
  8011fb:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  8011fe:	ff 4d 10             	decl   0x10(%ebp)
  801201:	eb 03                	jmp    801206 <vprintfmt+0x3c3>
  801203:	ff 4d 10             	decl   0x10(%ebp)
  801206:	8b 45 10             	mov    0x10(%ebp),%eax
  801209:	48                   	dec    %eax
  80120a:	8a 00                	mov    (%eax),%al
  80120c:	3c 25                	cmp    $0x25,%al
  80120e:	75 f3                	jne    801203 <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  801210:	90                   	nop
		}
	}
  801211:	e9 35 fc ff ff       	jmp    800e4b <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  801216:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  801217:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80121a:	5b                   	pop    %ebx
  80121b:	5e                   	pop    %esi
  80121c:	5d                   	pop    %ebp
  80121d:	c3                   	ret    

0080121e <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  80121e:	55                   	push   %ebp
  80121f:	89 e5                	mov    %esp,%ebp
  801221:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  801224:	8d 45 10             	lea    0x10(%ebp),%eax
  801227:	83 c0 04             	add    $0x4,%eax
  80122a:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  80122d:	8b 45 10             	mov    0x10(%ebp),%eax
  801230:	ff 75 f4             	pushl  -0xc(%ebp)
  801233:	50                   	push   %eax
  801234:	ff 75 0c             	pushl  0xc(%ebp)
  801237:	ff 75 08             	pushl  0x8(%ebp)
  80123a:	e8 04 fc ff ff       	call   800e43 <vprintfmt>
  80123f:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  801242:	90                   	nop
  801243:	c9                   	leave  
  801244:	c3                   	ret    

00801245 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  801245:	55                   	push   %ebp
  801246:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  801248:	8b 45 0c             	mov    0xc(%ebp),%eax
  80124b:	8b 40 08             	mov    0x8(%eax),%eax
  80124e:	8d 50 01             	lea    0x1(%eax),%edx
  801251:	8b 45 0c             	mov    0xc(%ebp),%eax
  801254:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  801257:	8b 45 0c             	mov    0xc(%ebp),%eax
  80125a:	8b 10                	mov    (%eax),%edx
  80125c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80125f:	8b 40 04             	mov    0x4(%eax),%eax
  801262:	39 c2                	cmp    %eax,%edx
  801264:	73 12                	jae    801278 <sprintputch+0x33>
		*b->buf++ = ch;
  801266:	8b 45 0c             	mov    0xc(%ebp),%eax
  801269:	8b 00                	mov    (%eax),%eax
  80126b:	8d 48 01             	lea    0x1(%eax),%ecx
  80126e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801271:	89 0a                	mov    %ecx,(%edx)
  801273:	8b 55 08             	mov    0x8(%ebp),%edx
  801276:	88 10                	mov    %dl,(%eax)
}
  801278:	90                   	nop
  801279:	5d                   	pop    %ebp
  80127a:	c3                   	ret    

0080127b <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  80127b:	55                   	push   %ebp
  80127c:	89 e5                	mov    %esp,%ebp
  80127e:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  801281:	8b 45 08             	mov    0x8(%ebp),%eax
  801284:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801287:	8b 45 0c             	mov    0xc(%ebp),%eax
  80128a:	8d 50 ff             	lea    -0x1(%eax),%edx
  80128d:	8b 45 08             	mov    0x8(%ebp),%eax
  801290:	01 d0                	add    %edx,%eax
  801292:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801295:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  80129c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8012a0:	74 06                	je     8012a8 <vsnprintf+0x2d>
  8012a2:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8012a6:	7f 07                	jg     8012af <vsnprintf+0x34>
		return -E_INVAL;
  8012a8:	b8 03 00 00 00       	mov    $0x3,%eax
  8012ad:	eb 20                	jmp    8012cf <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8012af:	ff 75 14             	pushl  0x14(%ebp)
  8012b2:	ff 75 10             	pushl  0x10(%ebp)
  8012b5:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8012b8:	50                   	push   %eax
  8012b9:	68 45 12 80 00       	push   $0x801245
  8012be:	e8 80 fb ff ff       	call   800e43 <vprintfmt>
  8012c3:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  8012c6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8012c9:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8012cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  8012cf:	c9                   	leave  
  8012d0:	c3                   	ret    

008012d1 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8012d1:	55                   	push   %ebp
  8012d2:	89 e5                	mov    %esp,%ebp
  8012d4:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8012d7:	8d 45 10             	lea    0x10(%ebp),%eax
  8012da:	83 c0 04             	add    $0x4,%eax
  8012dd:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  8012e0:	8b 45 10             	mov    0x10(%ebp),%eax
  8012e3:	ff 75 f4             	pushl  -0xc(%ebp)
  8012e6:	50                   	push   %eax
  8012e7:	ff 75 0c             	pushl  0xc(%ebp)
  8012ea:	ff 75 08             	pushl  0x8(%ebp)
  8012ed:	e8 89 ff ff ff       	call   80127b <vsnprintf>
  8012f2:	83 c4 10             	add    $0x10,%esp
  8012f5:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  8012f8:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8012fb:	c9                   	leave  
  8012fc:	c3                   	ret    

008012fd <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  8012fd:	55                   	push   %ebp
  8012fe:	89 e5                	mov    %esp,%ebp
  801300:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  801303:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80130a:	eb 06                	jmp    801312 <strlen+0x15>
		n++;
  80130c:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  80130f:	ff 45 08             	incl   0x8(%ebp)
  801312:	8b 45 08             	mov    0x8(%ebp),%eax
  801315:	8a 00                	mov    (%eax),%al
  801317:	84 c0                	test   %al,%al
  801319:	75 f1                	jne    80130c <strlen+0xf>
		n++;
	return n;
  80131b:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  80131e:	c9                   	leave  
  80131f:	c3                   	ret    

00801320 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  801320:	55                   	push   %ebp
  801321:	89 e5                	mov    %esp,%ebp
  801323:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801326:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80132d:	eb 09                	jmp    801338 <strnlen+0x18>
		n++;
  80132f:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801332:	ff 45 08             	incl   0x8(%ebp)
  801335:	ff 4d 0c             	decl   0xc(%ebp)
  801338:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80133c:	74 09                	je     801347 <strnlen+0x27>
  80133e:	8b 45 08             	mov    0x8(%ebp),%eax
  801341:	8a 00                	mov    (%eax),%al
  801343:	84 c0                	test   %al,%al
  801345:	75 e8                	jne    80132f <strnlen+0xf>
		n++;
	return n;
  801347:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  80134a:	c9                   	leave  
  80134b:	c3                   	ret    

0080134c <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  80134c:	55                   	push   %ebp
  80134d:	89 e5                	mov    %esp,%ebp
  80134f:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  801352:	8b 45 08             	mov    0x8(%ebp),%eax
  801355:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  801358:	90                   	nop
  801359:	8b 45 08             	mov    0x8(%ebp),%eax
  80135c:	8d 50 01             	lea    0x1(%eax),%edx
  80135f:	89 55 08             	mov    %edx,0x8(%ebp)
  801362:	8b 55 0c             	mov    0xc(%ebp),%edx
  801365:	8d 4a 01             	lea    0x1(%edx),%ecx
  801368:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  80136b:	8a 12                	mov    (%edx),%dl
  80136d:	88 10                	mov    %dl,(%eax)
  80136f:	8a 00                	mov    (%eax),%al
  801371:	84 c0                	test   %al,%al
  801373:	75 e4                	jne    801359 <strcpy+0xd>
		/* do nothing */;
	return ret;
  801375:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801378:	c9                   	leave  
  801379:	c3                   	ret    

0080137a <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  80137a:	55                   	push   %ebp
  80137b:	89 e5                	mov    %esp,%ebp
  80137d:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  801380:	8b 45 08             	mov    0x8(%ebp),%eax
  801383:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  801386:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80138d:	eb 1f                	jmp    8013ae <strncpy+0x34>
		*dst++ = *src;
  80138f:	8b 45 08             	mov    0x8(%ebp),%eax
  801392:	8d 50 01             	lea    0x1(%eax),%edx
  801395:	89 55 08             	mov    %edx,0x8(%ebp)
  801398:	8b 55 0c             	mov    0xc(%ebp),%edx
  80139b:	8a 12                	mov    (%edx),%dl
  80139d:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  80139f:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013a2:	8a 00                	mov    (%eax),%al
  8013a4:	84 c0                	test   %al,%al
  8013a6:	74 03                	je     8013ab <strncpy+0x31>
			src++;
  8013a8:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8013ab:	ff 45 fc             	incl   -0x4(%ebp)
  8013ae:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8013b1:	3b 45 10             	cmp    0x10(%ebp),%eax
  8013b4:	72 d9                	jb     80138f <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  8013b6:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8013b9:	c9                   	leave  
  8013ba:	c3                   	ret    

008013bb <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  8013bb:	55                   	push   %ebp
  8013bc:	89 e5                	mov    %esp,%ebp
  8013be:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  8013c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8013c4:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  8013c7:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8013cb:	74 30                	je     8013fd <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  8013cd:	eb 16                	jmp    8013e5 <strlcpy+0x2a>
			*dst++ = *src++;
  8013cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8013d2:	8d 50 01             	lea    0x1(%eax),%edx
  8013d5:	89 55 08             	mov    %edx,0x8(%ebp)
  8013d8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8013db:	8d 4a 01             	lea    0x1(%edx),%ecx
  8013de:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  8013e1:	8a 12                	mov    (%edx),%dl
  8013e3:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  8013e5:	ff 4d 10             	decl   0x10(%ebp)
  8013e8:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8013ec:	74 09                	je     8013f7 <strlcpy+0x3c>
  8013ee:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013f1:	8a 00                	mov    (%eax),%al
  8013f3:	84 c0                	test   %al,%al
  8013f5:	75 d8                	jne    8013cf <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  8013f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8013fa:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  8013fd:	8b 55 08             	mov    0x8(%ebp),%edx
  801400:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801403:	29 c2                	sub    %eax,%edx
  801405:	89 d0                	mov    %edx,%eax
}
  801407:	c9                   	leave  
  801408:	c3                   	ret    

00801409 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  801409:	55                   	push   %ebp
  80140a:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  80140c:	eb 06                	jmp    801414 <strcmp+0xb>
		p++, q++;
  80140e:	ff 45 08             	incl   0x8(%ebp)
  801411:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  801414:	8b 45 08             	mov    0x8(%ebp),%eax
  801417:	8a 00                	mov    (%eax),%al
  801419:	84 c0                	test   %al,%al
  80141b:	74 0e                	je     80142b <strcmp+0x22>
  80141d:	8b 45 08             	mov    0x8(%ebp),%eax
  801420:	8a 10                	mov    (%eax),%dl
  801422:	8b 45 0c             	mov    0xc(%ebp),%eax
  801425:	8a 00                	mov    (%eax),%al
  801427:	38 c2                	cmp    %al,%dl
  801429:	74 e3                	je     80140e <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  80142b:	8b 45 08             	mov    0x8(%ebp),%eax
  80142e:	8a 00                	mov    (%eax),%al
  801430:	0f b6 d0             	movzbl %al,%edx
  801433:	8b 45 0c             	mov    0xc(%ebp),%eax
  801436:	8a 00                	mov    (%eax),%al
  801438:	0f b6 c0             	movzbl %al,%eax
  80143b:	29 c2                	sub    %eax,%edx
  80143d:	89 d0                	mov    %edx,%eax
}
  80143f:	5d                   	pop    %ebp
  801440:	c3                   	ret    

00801441 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  801441:	55                   	push   %ebp
  801442:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  801444:	eb 09                	jmp    80144f <strncmp+0xe>
		n--, p++, q++;
  801446:	ff 4d 10             	decl   0x10(%ebp)
  801449:	ff 45 08             	incl   0x8(%ebp)
  80144c:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  80144f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801453:	74 17                	je     80146c <strncmp+0x2b>
  801455:	8b 45 08             	mov    0x8(%ebp),%eax
  801458:	8a 00                	mov    (%eax),%al
  80145a:	84 c0                	test   %al,%al
  80145c:	74 0e                	je     80146c <strncmp+0x2b>
  80145e:	8b 45 08             	mov    0x8(%ebp),%eax
  801461:	8a 10                	mov    (%eax),%dl
  801463:	8b 45 0c             	mov    0xc(%ebp),%eax
  801466:	8a 00                	mov    (%eax),%al
  801468:	38 c2                	cmp    %al,%dl
  80146a:	74 da                	je     801446 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  80146c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801470:	75 07                	jne    801479 <strncmp+0x38>
		return 0;
  801472:	b8 00 00 00 00       	mov    $0x0,%eax
  801477:	eb 14                	jmp    80148d <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  801479:	8b 45 08             	mov    0x8(%ebp),%eax
  80147c:	8a 00                	mov    (%eax),%al
  80147e:	0f b6 d0             	movzbl %al,%edx
  801481:	8b 45 0c             	mov    0xc(%ebp),%eax
  801484:	8a 00                	mov    (%eax),%al
  801486:	0f b6 c0             	movzbl %al,%eax
  801489:	29 c2                	sub    %eax,%edx
  80148b:	89 d0                	mov    %edx,%eax
}
  80148d:	5d                   	pop    %ebp
  80148e:	c3                   	ret    

0080148f <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  80148f:	55                   	push   %ebp
  801490:	89 e5                	mov    %esp,%ebp
  801492:	83 ec 04             	sub    $0x4,%esp
  801495:	8b 45 0c             	mov    0xc(%ebp),%eax
  801498:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  80149b:	eb 12                	jmp    8014af <strchr+0x20>
		if (*s == c)
  80149d:	8b 45 08             	mov    0x8(%ebp),%eax
  8014a0:	8a 00                	mov    (%eax),%al
  8014a2:	3a 45 fc             	cmp    -0x4(%ebp),%al
  8014a5:	75 05                	jne    8014ac <strchr+0x1d>
			return (char *) s;
  8014a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8014aa:	eb 11                	jmp    8014bd <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  8014ac:	ff 45 08             	incl   0x8(%ebp)
  8014af:	8b 45 08             	mov    0x8(%ebp),%eax
  8014b2:	8a 00                	mov    (%eax),%al
  8014b4:	84 c0                	test   %al,%al
  8014b6:	75 e5                	jne    80149d <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  8014b8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8014bd:	c9                   	leave  
  8014be:	c3                   	ret    

008014bf <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8014bf:	55                   	push   %ebp
  8014c0:	89 e5                	mov    %esp,%ebp
  8014c2:	83 ec 04             	sub    $0x4,%esp
  8014c5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014c8:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  8014cb:	eb 0d                	jmp    8014da <strfind+0x1b>
		if (*s == c)
  8014cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8014d0:	8a 00                	mov    (%eax),%al
  8014d2:	3a 45 fc             	cmp    -0x4(%ebp),%al
  8014d5:	74 0e                	je     8014e5 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  8014d7:	ff 45 08             	incl   0x8(%ebp)
  8014da:	8b 45 08             	mov    0x8(%ebp),%eax
  8014dd:	8a 00                	mov    (%eax),%al
  8014df:	84 c0                	test   %al,%al
  8014e1:	75 ea                	jne    8014cd <strfind+0xe>
  8014e3:	eb 01                	jmp    8014e6 <strfind+0x27>
		if (*s == c)
			break;
  8014e5:	90                   	nop
	return (char *) s;
  8014e6:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8014e9:	c9                   	leave  
  8014ea:	c3                   	ret    

008014eb <memset>:

// *************** The faster implementation of memset & memcpy is implemented by *************
// ****************** Team80 (Yahia Khaled, Malek Ahmed et al) - FCIS'24-25 *******************
void *
memset(void *v, int c, uint32 n)
{
  8014eb:	55                   	push   %ebp
  8014ec:	89 e5                	mov    %esp,%ebp
  8014ee:	83 ec 10             	sub    $0x10,%esp
//	m = n;
//	while (--m >= 0)
//		*p++ = c;

	/*Faster Implementation*/
	uint64* p64 = (uint64*)v;
  8014f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8014f4:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if(n >= 8){
  8014f7:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  8014fb:	76 63                	jbe    801560 <memset+0x75>
		uint64 data_block = c;
  8014fd:	8b 45 0c             	mov    0xc(%ebp),%eax
  801500:	99                   	cltd   
  801501:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801504:	89 55 f4             	mov    %edx,-0xc(%ebp)
		data_block |= data_block << 8;
  801507:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80150a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80150d:	0f a4 c2 08          	shld   $0x8,%eax,%edx
  801511:	c1 e0 08             	shl    $0x8,%eax
  801514:	09 45 f0             	or     %eax,-0x10(%ebp)
  801517:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 16;
  80151a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80151d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801520:	0f a4 c2 10          	shld   $0x10,%eax,%edx
  801524:	c1 e0 10             	shl    $0x10,%eax
  801527:	09 45 f0             	or     %eax,-0x10(%ebp)
  80152a:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 32;
  80152d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801530:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801533:	89 c2                	mov    %eax,%edx
  801535:	b8 00 00 00 00       	mov    $0x0,%eax
  80153a:	09 45 f0             	or     %eax,-0x10(%ebp)
  80153d:	09 55 f4             	or     %edx,-0xc(%ebp)

		while(n >= 8)
  801540:	eb 18                	jmp    80155a <memset+0x6f>
			*p64++ = data_block, n -= 8;
  801542:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801545:	8d 41 08             	lea    0x8(%ecx),%eax
  801548:	89 45 fc             	mov    %eax,-0x4(%ebp)
  80154b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80154e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801551:	89 01                	mov    %eax,(%ecx)
  801553:	89 51 04             	mov    %edx,0x4(%ecx)
  801556:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
		uint64 data_block = c;
		data_block |= data_block << 8;
		data_block |= data_block << 16;
		data_block |= data_block << 32;

		while(n >= 8)
  80155a:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  80155e:	77 e2                	ja     801542 <memset+0x57>
			*p64++ = data_block, n -= 8;
	}

	if(n){
  801560:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801564:	74 23                	je     801589 <memset+0x9e>
		uint8* p8 = (uint8*)p64;
  801566:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801569:	89 45 f8             	mov    %eax,-0x8(%ebp)
		while (n-- > 0)
  80156c:	eb 0e                	jmp    80157c <memset+0x91>
			*p8++ = (uint8)c;
  80156e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801571:	8d 50 01             	lea    0x1(%eax),%edx
  801574:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801577:	8b 55 0c             	mov    0xc(%ebp),%edx
  80157a:	88 10                	mov    %dl,(%eax)
			*p64++ = data_block, n -= 8;
	}

	if(n){
		uint8* p8 = (uint8*)p64;
		while (n-- > 0)
  80157c:	8b 45 10             	mov    0x10(%ebp),%eax
  80157f:	8d 50 ff             	lea    -0x1(%eax),%edx
  801582:	89 55 10             	mov    %edx,0x10(%ebp)
  801585:	85 c0                	test   %eax,%eax
  801587:	75 e5                	jne    80156e <memset+0x83>
			*p8++ = (uint8)c;
	}

	return v;
  801589:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80158c:	c9                   	leave  
  80158d:	c3                   	ret    

0080158e <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  80158e:	55                   	push   %ebp
  80158f:	89 e5                	mov    %esp,%ebp
  801591:	83 ec 10             	sub    $0x10,%esp
	//	s = src;
	//	d = dst;
	//	while (n-- > 0)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
  801594:	8b 45 0c             	mov    0xc(%ebp),%eax
  801597:	89 45 fc             	mov    %eax,-0x4(%ebp)
	uint64* d64 = (uint64*)dst;
  80159a:	8b 45 08             	mov    0x8(%ebp),%eax
  80159d:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if(n >= 8){
  8015a0:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  8015a4:	76 24                	jbe    8015ca <memcpy+0x3c>
		while(n >= 8){
  8015a6:	eb 1c                	jmp    8015c4 <memcpy+0x36>
			*d64 = *s64;
  8015a8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8015ab:	8b 50 04             	mov    0x4(%eax),%edx
  8015ae:	8b 00                	mov    (%eax),%eax
  8015b0:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8015b3:	89 01                	mov    %eax,(%ecx)
  8015b5:	89 51 04             	mov    %edx,0x4(%ecx)
			n -= 8;
  8015b8:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
			++s64;
  8015bc:	83 45 fc 08          	addl   $0x8,-0x4(%ebp)
			++d64;
  8015c0:	83 45 f8 08          	addl   $0x8,-0x8(%ebp)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
	uint64* d64 = (uint64*)dst;
	if(n >= 8){
		while(n >= 8){
  8015c4:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  8015c8:	77 de                	ja     8015a8 <memcpy+0x1a>
			++s64;
			++d64;
		}
	}

	if(n){
  8015ca:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8015ce:	74 31                	je     801601 <memcpy+0x73>
		uint8* s8 = (uint8*)s64;
  8015d0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8015d3:	89 45 f4             	mov    %eax,-0xc(%ebp)
		uint8* d8 = (uint8*)d64;
  8015d6:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8015d9:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (n-- > 0)
  8015dc:	eb 16                	jmp    8015f4 <memcpy+0x66>
			*d8++ = *s8++;
  8015de:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015e1:	8d 50 01             	lea    0x1(%eax),%edx
  8015e4:	89 55 f0             	mov    %edx,-0x10(%ebp)
  8015e7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8015ea:	8d 4a 01             	lea    0x1(%edx),%ecx
  8015ed:	89 4d f4             	mov    %ecx,-0xc(%ebp)
  8015f0:	8a 12                	mov    (%edx),%dl
  8015f2:	88 10                	mov    %dl,(%eax)
	}

	if(n){
		uint8* s8 = (uint8*)s64;
		uint8* d8 = (uint8*)d64;
		while (n-- > 0)
  8015f4:	8b 45 10             	mov    0x10(%ebp),%eax
  8015f7:	8d 50 ff             	lea    -0x1(%eax),%edx
  8015fa:	89 55 10             	mov    %edx,0x10(%ebp)
  8015fd:	85 c0                	test   %eax,%eax
  8015ff:	75 dd                	jne    8015de <memcpy+0x50>
			*d8++ = *s8++;
	}
	return dst;
  801601:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801604:	c9                   	leave  
  801605:	c3                   	ret    

00801606 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  801606:	55                   	push   %ebp
  801607:	89 e5                	mov    %esp,%ebp
  801609:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  80160c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80160f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801612:	8b 45 08             	mov    0x8(%ebp),%eax
  801615:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  801618:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80161b:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  80161e:	73 50                	jae    801670 <memmove+0x6a>
  801620:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801623:	8b 45 10             	mov    0x10(%ebp),%eax
  801626:	01 d0                	add    %edx,%eax
  801628:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  80162b:	76 43                	jbe    801670 <memmove+0x6a>
		s += n;
  80162d:	8b 45 10             	mov    0x10(%ebp),%eax
  801630:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  801633:	8b 45 10             	mov    0x10(%ebp),%eax
  801636:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  801639:	eb 10                	jmp    80164b <memmove+0x45>
			*--d = *--s;
  80163b:	ff 4d f8             	decl   -0x8(%ebp)
  80163e:	ff 4d fc             	decl   -0x4(%ebp)
  801641:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801644:	8a 10                	mov    (%eax),%dl
  801646:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801649:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  80164b:	8b 45 10             	mov    0x10(%ebp),%eax
  80164e:	8d 50 ff             	lea    -0x1(%eax),%edx
  801651:	89 55 10             	mov    %edx,0x10(%ebp)
  801654:	85 c0                	test   %eax,%eax
  801656:	75 e3                	jne    80163b <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  801658:	eb 23                	jmp    80167d <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  80165a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80165d:	8d 50 01             	lea    0x1(%eax),%edx
  801660:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801663:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801666:	8d 4a 01             	lea    0x1(%edx),%ecx
  801669:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  80166c:	8a 12                	mov    (%edx),%dl
  80166e:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  801670:	8b 45 10             	mov    0x10(%ebp),%eax
  801673:	8d 50 ff             	lea    -0x1(%eax),%edx
  801676:	89 55 10             	mov    %edx,0x10(%ebp)
  801679:	85 c0                	test   %eax,%eax
  80167b:	75 dd                	jne    80165a <memmove+0x54>
			*d++ = *s++;

	return dst;
  80167d:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801680:	c9                   	leave  
  801681:	c3                   	ret    

00801682 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  801682:	55                   	push   %ebp
  801683:	89 e5                	mov    %esp,%ebp
  801685:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  801688:	8b 45 08             	mov    0x8(%ebp),%eax
  80168b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  80168e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801691:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  801694:	eb 2a                	jmp    8016c0 <memcmp+0x3e>
		if (*s1 != *s2)
  801696:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801699:	8a 10                	mov    (%eax),%dl
  80169b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80169e:	8a 00                	mov    (%eax),%al
  8016a0:	38 c2                	cmp    %al,%dl
  8016a2:	74 16                	je     8016ba <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  8016a4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8016a7:	8a 00                	mov    (%eax),%al
  8016a9:	0f b6 d0             	movzbl %al,%edx
  8016ac:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8016af:	8a 00                	mov    (%eax),%al
  8016b1:	0f b6 c0             	movzbl %al,%eax
  8016b4:	29 c2                	sub    %eax,%edx
  8016b6:	89 d0                	mov    %edx,%eax
  8016b8:	eb 18                	jmp    8016d2 <memcmp+0x50>
		s1++, s2++;
  8016ba:	ff 45 fc             	incl   -0x4(%ebp)
  8016bd:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  8016c0:	8b 45 10             	mov    0x10(%ebp),%eax
  8016c3:	8d 50 ff             	lea    -0x1(%eax),%edx
  8016c6:	89 55 10             	mov    %edx,0x10(%ebp)
  8016c9:	85 c0                	test   %eax,%eax
  8016cb:	75 c9                	jne    801696 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  8016cd:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8016d2:	c9                   	leave  
  8016d3:	c3                   	ret    

008016d4 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  8016d4:	55                   	push   %ebp
  8016d5:	89 e5                	mov    %esp,%ebp
  8016d7:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  8016da:	8b 55 08             	mov    0x8(%ebp),%edx
  8016dd:	8b 45 10             	mov    0x10(%ebp),%eax
  8016e0:	01 d0                	add    %edx,%eax
  8016e2:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  8016e5:	eb 15                	jmp    8016fc <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  8016e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8016ea:	8a 00                	mov    (%eax),%al
  8016ec:	0f b6 d0             	movzbl %al,%edx
  8016ef:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016f2:	0f b6 c0             	movzbl %al,%eax
  8016f5:	39 c2                	cmp    %eax,%edx
  8016f7:	74 0d                	je     801706 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  8016f9:	ff 45 08             	incl   0x8(%ebp)
  8016fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8016ff:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801702:	72 e3                	jb     8016e7 <memfind+0x13>
  801704:	eb 01                	jmp    801707 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  801706:	90                   	nop
	return (void *) s;
  801707:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80170a:	c9                   	leave  
  80170b:	c3                   	ret    

0080170c <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  80170c:	55                   	push   %ebp
  80170d:	89 e5                	mov    %esp,%ebp
  80170f:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  801712:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  801719:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801720:	eb 03                	jmp    801725 <strtol+0x19>
		s++;
  801722:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801725:	8b 45 08             	mov    0x8(%ebp),%eax
  801728:	8a 00                	mov    (%eax),%al
  80172a:	3c 20                	cmp    $0x20,%al
  80172c:	74 f4                	je     801722 <strtol+0x16>
  80172e:	8b 45 08             	mov    0x8(%ebp),%eax
  801731:	8a 00                	mov    (%eax),%al
  801733:	3c 09                	cmp    $0x9,%al
  801735:	74 eb                	je     801722 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  801737:	8b 45 08             	mov    0x8(%ebp),%eax
  80173a:	8a 00                	mov    (%eax),%al
  80173c:	3c 2b                	cmp    $0x2b,%al
  80173e:	75 05                	jne    801745 <strtol+0x39>
		s++;
  801740:	ff 45 08             	incl   0x8(%ebp)
  801743:	eb 13                	jmp    801758 <strtol+0x4c>
	else if (*s == '-')
  801745:	8b 45 08             	mov    0x8(%ebp),%eax
  801748:	8a 00                	mov    (%eax),%al
  80174a:	3c 2d                	cmp    $0x2d,%al
  80174c:	75 0a                	jne    801758 <strtol+0x4c>
		s++, neg = 1;
  80174e:	ff 45 08             	incl   0x8(%ebp)
  801751:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801758:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80175c:	74 06                	je     801764 <strtol+0x58>
  80175e:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  801762:	75 20                	jne    801784 <strtol+0x78>
  801764:	8b 45 08             	mov    0x8(%ebp),%eax
  801767:	8a 00                	mov    (%eax),%al
  801769:	3c 30                	cmp    $0x30,%al
  80176b:	75 17                	jne    801784 <strtol+0x78>
  80176d:	8b 45 08             	mov    0x8(%ebp),%eax
  801770:	40                   	inc    %eax
  801771:	8a 00                	mov    (%eax),%al
  801773:	3c 78                	cmp    $0x78,%al
  801775:	75 0d                	jne    801784 <strtol+0x78>
		s += 2, base = 16;
  801777:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  80177b:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  801782:	eb 28                	jmp    8017ac <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  801784:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801788:	75 15                	jne    80179f <strtol+0x93>
  80178a:	8b 45 08             	mov    0x8(%ebp),%eax
  80178d:	8a 00                	mov    (%eax),%al
  80178f:	3c 30                	cmp    $0x30,%al
  801791:	75 0c                	jne    80179f <strtol+0x93>
		s++, base = 8;
  801793:	ff 45 08             	incl   0x8(%ebp)
  801796:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  80179d:	eb 0d                	jmp    8017ac <strtol+0xa0>
	else if (base == 0)
  80179f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8017a3:	75 07                	jne    8017ac <strtol+0xa0>
		base = 10;
  8017a5:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8017ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8017af:	8a 00                	mov    (%eax),%al
  8017b1:	3c 2f                	cmp    $0x2f,%al
  8017b3:	7e 19                	jle    8017ce <strtol+0xc2>
  8017b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8017b8:	8a 00                	mov    (%eax),%al
  8017ba:	3c 39                	cmp    $0x39,%al
  8017bc:	7f 10                	jg     8017ce <strtol+0xc2>
			dig = *s - '0';
  8017be:	8b 45 08             	mov    0x8(%ebp),%eax
  8017c1:	8a 00                	mov    (%eax),%al
  8017c3:	0f be c0             	movsbl %al,%eax
  8017c6:	83 e8 30             	sub    $0x30,%eax
  8017c9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8017cc:	eb 42                	jmp    801810 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  8017ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8017d1:	8a 00                	mov    (%eax),%al
  8017d3:	3c 60                	cmp    $0x60,%al
  8017d5:	7e 19                	jle    8017f0 <strtol+0xe4>
  8017d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8017da:	8a 00                	mov    (%eax),%al
  8017dc:	3c 7a                	cmp    $0x7a,%al
  8017de:	7f 10                	jg     8017f0 <strtol+0xe4>
			dig = *s - 'a' + 10;
  8017e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8017e3:	8a 00                	mov    (%eax),%al
  8017e5:	0f be c0             	movsbl %al,%eax
  8017e8:	83 e8 57             	sub    $0x57,%eax
  8017eb:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8017ee:	eb 20                	jmp    801810 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  8017f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8017f3:	8a 00                	mov    (%eax),%al
  8017f5:	3c 40                	cmp    $0x40,%al
  8017f7:	7e 39                	jle    801832 <strtol+0x126>
  8017f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8017fc:	8a 00                	mov    (%eax),%al
  8017fe:	3c 5a                	cmp    $0x5a,%al
  801800:	7f 30                	jg     801832 <strtol+0x126>
			dig = *s - 'A' + 10;
  801802:	8b 45 08             	mov    0x8(%ebp),%eax
  801805:	8a 00                	mov    (%eax),%al
  801807:	0f be c0             	movsbl %al,%eax
  80180a:	83 e8 37             	sub    $0x37,%eax
  80180d:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  801810:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801813:	3b 45 10             	cmp    0x10(%ebp),%eax
  801816:	7d 19                	jge    801831 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801818:	ff 45 08             	incl   0x8(%ebp)
  80181b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80181e:	0f af 45 10          	imul   0x10(%ebp),%eax
  801822:	89 c2                	mov    %eax,%edx
  801824:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801827:	01 d0                	add    %edx,%eax
  801829:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  80182c:	e9 7b ff ff ff       	jmp    8017ac <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801831:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801832:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801836:	74 08                	je     801840 <strtol+0x134>
		*endptr = (char *) s;
  801838:	8b 45 0c             	mov    0xc(%ebp),%eax
  80183b:	8b 55 08             	mov    0x8(%ebp),%edx
  80183e:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  801840:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801844:	74 07                	je     80184d <strtol+0x141>
  801846:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801849:	f7 d8                	neg    %eax
  80184b:	eb 03                	jmp    801850 <strtol+0x144>
  80184d:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801850:	c9                   	leave  
  801851:	c3                   	ret    

00801852 <ltostr>:

void
ltostr(long value, char *str)
{
  801852:	55                   	push   %ebp
  801853:	89 e5                	mov    %esp,%ebp
  801855:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  801858:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  80185f:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  801866:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80186a:	79 13                	jns    80187f <ltostr+0x2d>
	{
		neg = 1;
  80186c:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  801873:	8b 45 0c             	mov    0xc(%ebp),%eax
  801876:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  801879:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  80187c:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  80187f:	8b 45 08             	mov    0x8(%ebp),%eax
  801882:	b9 0a 00 00 00       	mov    $0xa,%ecx
  801887:	99                   	cltd   
  801888:	f7 f9                	idiv   %ecx
  80188a:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  80188d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801890:	8d 50 01             	lea    0x1(%eax),%edx
  801893:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801896:	89 c2                	mov    %eax,%edx
  801898:	8b 45 0c             	mov    0xc(%ebp),%eax
  80189b:	01 d0                	add    %edx,%eax
  80189d:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8018a0:	83 c2 30             	add    $0x30,%edx
  8018a3:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  8018a5:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8018a8:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8018ad:	f7 e9                	imul   %ecx
  8018af:	c1 fa 02             	sar    $0x2,%edx
  8018b2:	89 c8                	mov    %ecx,%eax
  8018b4:	c1 f8 1f             	sar    $0x1f,%eax
  8018b7:	29 c2                	sub    %eax,%edx
  8018b9:	89 d0                	mov    %edx,%eax
  8018bb:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  8018be:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8018c2:	75 bb                	jne    80187f <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  8018c4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  8018cb:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8018ce:	48                   	dec    %eax
  8018cf:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  8018d2:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8018d6:	74 3d                	je     801915 <ltostr+0xc3>
		start = 1 ;
  8018d8:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  8018df:	eb 34                	jmp    801915 <ltostr+0xc3>
	{
		char tmp = str[start] ;
  8018e1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8018e4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018e7:	01 d0                	add    %edx,%eax
  8018e9:	8a 00                	mov    (%eax),%al
  8018eb:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  8018ee:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8018f1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018f4:	01 c2                	add    %eax,%edx
  8018f6:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  8018f9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018fc:	01 c8                	add    %ecx,%eax
  8018fe:	8a 00                	mov    (%eax),%al
  801900:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801902:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801905:	8b 45 0c             	mov    0xc(%ebp),%eax
  801908:	01 c2                	add    %eax,%edx
  80190a:	8a 45 eb             	mov    -0x15(%ebp),%al
  80190d:	88 02                	mov    %al,(%edx)
		start++ ;
  80190f:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801912:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801915:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801918:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80191b:	7c c4                	jl     8018e1 <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  80191d:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801920:	8b 45 0c             	mov    0xc(%ebp),%eax
  801923:	01 d0                	add    %edx,%eax
  801925:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801928:	90                   	nop
  801929:	c9                   	leave  
  80192a:	c3                   	ret    

0080192b <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  80192b:	55                   	push   %ebp
  80192c:	89 e5                	mov    %esp,%ebp
  80192e:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801931:	ff 75 08             	pushl  0x8(%ebp)
  801934:	e8 c4 f9 ff ff       	call   8012fd <strlen>
  801939:	83 c4 04             	add    $0x4,%esp
  80193c:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  80193f:	ff 75 0c             	pushl  0xc(%ebp)
  801942:	e8 b6 f9 ff ff       	call   8012fd <strlen>
  801947:	83 c4 04             	add    $0x4,%esp
  80194a:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  80194d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  801954:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80195b:	eb 17                	jmp    801974 <strcconcat+0x49>
		final[s] = str1[s] ;
  80195d:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801960:	8b 45 10             	mov    0x10(%ebp),%eax
  801963:	01 c2                	add    %eax,%edx
  801965:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801968:	8b 45 08             	mov    0x8(%ebp),%eax
  80196b:	01 c8                	add    %ecx,%eax
  80196d:	8a 00                	mov    (%eax),%al
  80196f:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  801971:	ff 45 fc             	incl   -0x4(%ebp)
  801974:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801977:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  80197a:	7c e1                	jl     80195d <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  80197c:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  801983:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  80198a:	eb 1f                	jmp    8019ab <strcconcat+0x80>
		final[s++] = str2[i] ;
  80198c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80198f:	8d 50 01             	lea    0x1(%eax),%edx
  801992:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801995:	89 c2                	mov    %eax,%edx
  801997:	8b 45 10             	mov    0x10(%ebp),%eax
  80199a:	01 c2                	add    %eax,%edx
  80199c:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  80199f:	8b 45 0c             	mov    0xc(%ebp),%eax
  8019a2:	01 c8                	add    %ecx,%eax
  8019a4:	8a 00                	mov    (%eax),%al
  8019a6:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  8019a8:	ff 45 f8             	incl   -0x8(%ebp)
  8019ab:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8019ae:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8019b1:	7c d9                	jl     80198c <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  8019b3:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8019b6:	8b 45 10             	mov    0x10(%ebp),%eax
  8019b9:	01 d0                	add    %edx,%eax
  8019bb:	c6 00 00             	movb   $0x0,(%eax)
}
  8019be:	90                   	nop
  8019bf:	c9                   	leave  
  8019c0:	c3                   	ret    

008019c1 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  8019c1:	55                   	push   %ebp
  8019c2:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  8019c4:	8b 45 14             	mov    0x14(%ebp),%eax
  8019c7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  8019cd:	8b 45 14             	mov    0x14(%ebp),%eax
  8019d0:	8b 00                	mov    (%eax),%eax
  8019d2:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8019d9:	8b 45 10             	mov    0x10(%ebp),%eax
  8019dc:	01 d0                	add    %edx,%eax
  8019de:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8019e4:	eb 0c                	jmp    8019f2 <strsplit+0x31>
			*string++ = 0;
  8019e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8019e9:	8d 50 01             	lea    0x1(%eax),%edx
  8019ec:	89 55 08             	mov    %edx,0x8(%ebp)
  8019ef:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8019f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8019f5:	8a 00                	mov    (%eax),%al
  8019f7:	84 c0                	test   %al,%al
  8019f9:	74 18                	je     801a13 <strsplit+0x52>
  8019fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8019fe:	8a 00                	mov    (%eax),%al
  801a00:	0f be c0             	movsbl %al,%eax
  801a03:	50                   	push   %eax
  801a04:	ff 75 0c             	pushl  0xc(%ebp)
  801a07:	e8 83 fa ff ff       	call   80148f <strchr>
  801a0c:	83 c4 08             	add    $0x8,%esp
  801a0f:	85 c0                	test   %eax,%eax
  801a11:	75 d3                	jne    8019e6 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801a13:	8b 45 08             	mov    0x8(%ebp),%eax
  801a16:	8a 00                	mov    (%eax),%al
  801a18:	84 c0                	test   %al,%al
  801a1a:	74 5a                	je     801a76 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801a1c:	8b 45 14             	mov    0x14(%ebp),%eax
  801a1f:	8b 00                	mov    (%eax),%eax
  801a21:	83 f8 0f             	cmp    $0xf,%eax
  801a24:	75 07                	jne    801a2d <strsplit+0x6c>
		{
			return 0;
  801a26:	b8 00 00 00 00       	mov    $0x0,%eax
  801a2b:	eb 66                	jmp    801a93 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801a2d:	8b 45 14             	mov    0x14(%ebp),%eax
  801a30:	8b 00                	mov    (%eax),%eax
  801a32:	8d 48 01             	lea    0x1(%eax),%ecx
  801a35:	8b 55 14             	mov    0x14(%ebp),%edx
  801a38:	89 0a                	mov    %ecx,(%edx)
  801a3a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801a41:	8b 45 10             	mov    0x10(%ebp),%eax
  801a44:	01 c2                	add    %eax,%edx
  801a46:	8b 45 08             	mov    0x8(%ebp),%eax
  801a49:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801a4b:	eb 03                	jmp    801a50 <strsplit+0x8f>
			string++;
  801a4d:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801a50:	8b 45 08             	mov    0x8(%ebp),%eax
  801a53:	8a 00                	mov    (%eax),%al
  801a55:	84 c0                	test   %al,%al
  801a57:	74 8b                	je     8019e4 <strsplit+0x23>
  801a59:	8b 45 08             	mov    0x8(%ebp),%eax
  801a5c:	8a 00                	mov    (%eax),%al
  801a5e:	0f be c0             	movsbl %al,%eax
  801a61:	50                   	push   %eax
  801a62:	ff 75 0c             	pushl  0xc(%ebp)
  801a65:	e8 25 fa ff ff       	call   80148f <strchr>
  801a6a:	83 c4 08             	add    $0x8,%esp
  801a6d:	85 c0                	test   %eax,%eax
  801a6f:	74 dc                	je     801a4d <strsplit+0x8c>
			string++;
	}
  801a71:	e9 6e ff ff ff       	jmp    8019e4 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801a76:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801a77:	8b 45 14             	mov    0x14(%ebp),%eax
  801a7a:	8b 00                	mov    (%eax),%eax
  801a7c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801a83:	8b 45 10             	mov    0x10(%ebp),%eax
  801a86:	01 d0                	add    %edx,%eax
  801a88:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801a8e:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801a93:	c9                   	leave  
  801a94:	c3                   	ret    

00801a95 <str2lower>:


char* str2lower(char *dst, const char *src)
{
  801a95:	55                   	push   %ebp
  801a96:	89 e5                	mov    %esp,%ebp
  801a98:	83 ec 10             	sub    $0x10,%esp
	char* ret = dst;
  801a9b:	8b 45 08             	mov    0x8(%ebp),%eax
  801a9e:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (int i = 0; i < strlen(src); ++i)
  801aa1:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801aa8:	eb 4a                	jmp    801af4 <str2lower+0x5f>
	{
		dst[i] = src[i] ;
  801aaa:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801aad:	8b 45 08             	mov    0x8(%ebp),%eax
  801ab0:	01 c2                	add    %eax,%edx
  801ab2:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801ab5:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ab8:	01 c8                	add    %ecx,%eax
  801aba:	8a 00                	mov    (%eax),%al
  801abc:	88 02                	mov    %al,(%edx)
		if (src[i] >= 'A' && src[i] <= 'Z')
  801abe:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801ac1:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ac4:	01 d0                	add    %edx,%eax
  801ac6:	8a 00                	mov    (%eax),%al
  801ac8:	3c 40                	cmp    $0x40,%al
  801aca:	7e 25                	jle    801af1 <str2lower+0x5c>
  801acc:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801acf:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ad2:	01 d0                	add    %edx,%eax
  801ad4:	8a 00                	mov    (%eax),%al
  801ad6:	3c 5a                	cmp    $0x5a,%al
  801ad8:	7f 17                	jg     801af1 <str2lower+0x5c>
		{
			dst[i] += 32 ;
  801ada:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801add:	8b 45 08             	mov    0x8(%ebp),%eax
  801ae0:	01 d0                	add    %edx,%eax
  801ae2:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801ae5:	8b 55 08             	mov    0x8(%ebp),%edx
  801ae8:	01 ca                	add    %ecx,%edx
  801aea:	8a 12                	mov    (%edx),%dl
  801aec:	83 c2 20             	add    $0x20,%edx
  801aef:	88 10                	mov    %dl,(%eax)


char* str2lower(char *dst, const char *src)
{
	char* ret = dst;
	for (int i = 0; i < strlen(src); ++i)
  801af1:	ff 45 fc             	incl   -0x4(%ebp)
  801af4:	ff 75 0c             	pushl  0xc(%ebp)
  801af7:	e8 01 f8 ff ff       	call   8012fd <strlen>
  801afc:	83 c4 04             	add    $0x4,%esp
  801aff:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801b02:	7f a6                	jg     801aaa <str2lower+0x15>
		if (src[i] >= 'A' && src[i] <= 'Z')
		{
			dst[i] += 32 ;
		}
	}
	return ret;
  801b04:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801b07:	c9                   	leave  
  801b08:	c3                   	ret    

00801b09 <uheap_init>:
//==============================================
// [1] INITIALIZE USER HEAP:
//==============================================
int __firstTimeFlag = 1;
void uheap_init()
{
  801b09:	55                   	push   %ebp
  801b0a:	89 e5                	mov    %esp,%ebp
  801b0c:	83 ec 08             	sub    $0x8,%esp
	if(__firstTimeFlag)
  801b0f:	a1 08 40 80 00       	mov    0x804008,%eax
  801b14:	85 c0                	test   %eax,%eax
  801b16:	74 42                	je     801b5a <uheap_init+0x51>
	{
		initialize_dynamic_allocator(USER_HEAP_START, USER_HEAP_START + DYN_ALLOC_MAX_SIZE);
  801b18:	83 ec 08             	sub    $0x8,%esp
  801b1b:	68 00 00 00 82       	push   $0x82000000
  801b20:	68 00 00 00 80       	push   $0x80000000
  801b25:	e8 00 08 00 00       	call   80232a <initialize_dynamic_allocator>
  801b2a:	83 c4 10             	add    $0x10,%esp
		uheapPlaceStrategy = sys_get_uheap_strategy();
  801b2d:	e8 e7 05 00 00       	call   802119 <sys_get_uheap_strategy>
  801b32:	a3 60 c0 81 00       	mov    %eax,0x81c060
		uheapPageAllocStart = dynAllocEnd + PAGE_SIZE;
  801b37:	a1 40 40 80 00       	mov    0x804040,%eax
  801b3c:	05 00 10 00 00       	add    $0x1000,%eax
  801b41:	a3 10 c1 81 00       	mov    %eax,0x81c110
		uheapPageAllocBreak = uheapPageAllocStart;
  801b46:	a1 10 c1 81 00       	mov    0x81c110,%eax
  801b4b:	a3 68 c0 81 00       	mov    %eax,0x81c068

		__firstTimeFlag = 0;
  801b50:	c7 05 08 40 80 00 00 	movl   $0x0,0x804008
  801b57:	00 00 00 
	}
}
  801b5a:	90                   	nop
  801b5b:	c9                   	leave  
  801b5c:	c3                   	ret    

00801b5d <get_page>:

//==============================================
// [2] GET A PAGE FROM THE KERNEL FOR DA:
//==============================================
int get_page(void* va)
{
  801b5d:	55                   	push   %ebp
  801b5e:	89 e5                	mov    %esp,%ebp
  801b60:	83 ec 18             	sub    $0x18,%esp
	int ret = __sys_allocate_page(ROUNDDOWN(va, PAGE_SIZE), PERM_USER|PERM_WRITEABLE|PERM_UHPAGE);
  801b63:	8b 45 08             	mov    0x8(%ebp),%eax
  801b66:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801b69:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b6c:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801b71:	83 ec 08             	sub    $0x8,%esp
  801b74:	68 06 04 00 00       	push   $0x406
  801b79:	50                   	push   %eax
  801b7a:	e8 e4 01 00 00       	call   801d63 <__sys_allocate_page>
  801b7f:	83 c4 10             	add    $0x10,%esp
  801b82:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (ret < 0)
  801b85:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801b89:	79 14                	jns    801b9f <get_page+0x42>
		panic("get_page() in user: failed to allocate page from the kernel");
  801b8b:	83 ec 04             	sub    $0x4,%esp
  801b8e:	68 a8 38 80 00       	push   $0x8038a8
  801b93:	6a 1f                	push   $0x1f
  801b95:	68 e4 38 80 00       	push   $0x8038e4
  801b9a:	e8 b7 ed ff ff       	call   800956 <_panic>
	return 0;
  801b9f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801ba4:	c9                   	leave  
  801ba5:	c3                   	ret    

00801ba6 <return_page>:

//==============================================
// [3] RETURN A PAGE FROM THE DA TO KERNEL:
//==============================================
void return_page(void* va)
{
  801ba6:	55                   	push   %ebp
  801ba7:	89 e5                	mov    %esp,%ebp
  801ba9:	83 ec 18             	sub    $0x18,%esp
	int ret = __sys_unmap_frame(ROUNDDOWN((uint32)va, PAGE_SIZE));
  801bac:	8b 45 08             	mov    0x8(%ebp),%eax
  801baf:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801bb2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801bb5:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801bba:	83 ec 0c             	sub    $0xc,%esp
  801bbd:	50                   	push   %eax
  801bbe:	e8 e7 01 00 00       	call   801daa <__sys_unmap_frame>
  801bc3:	83 c4 10             	add    $0x10,%esp
  801bc6:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (ret < 0)
  801bc9:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801bcd:	79 14                	jns    801be3 <return_page+0x3d>
		panic("return_page() in user: failed to return a page to the kernel");
  801bcf:	83 ec 04             	sub    $0x4,%esp
  801bd2:	68 f0 38 80 00       	push   $0x8038f0
  801bd7:	6a 2a                	push   $0x2a
  801bd9:	68 e4 38 80 00       	push   $0x8038e4
  801bde:	e8 73 ed ff ff       	call   800956 <_panic>
}
  801be3:	90                   	nop
  801be4:	c9                   	leave  
  801be5:	c3                   	ret    

00801be6 <malloc>:

//=================================
// [1] ALLOCATE SPACE IN USER HEAP:
//=================================
void* malloc(uint32 size)
{
  801be6:	55                   	push   %ebp
  801be7:	89 e5                	mov    %esp,%ebp
  801be9:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  801bec:	e8 18 ff ff ff       	call   801b09 <uheap_init>
	if (size == 0) return NULL ;
  801bf1:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801bf5:	75 07                	jne    801bfe <malloc+0x18>
  801bf7:	b8 00 00 00 00       	mov    $0x0,%eax
  801bfc:	eb 14                	jmp    801c12 <malloc+0x2c>
	//==============================================================
	//TODO: [PROJECT'25.IM#2] USER HEAP - #1 malloc
	//Your code is here
	//Comment the following line
	panic("malloc() is not implemented yet...!!");
  801bfe:	83 ec 04             	sub    $0x4,%esp
  801c01:	68 30 39 80 00       	push   $0x803930
  801c06:	6a 3e                	push   $0x3e
  801c08:	68 e4 38 80 00       	push   $0x8038e4
  801c0d:	e8 44 ed ff ff       	call   800956 <_panic>
}
  801c12:	c9                   	leave  
  801c13:	c3                   	ret    

00801c14 <free>:

//=================================
// [2] FREE SPACE FROM USER HEAP:
//=================================
void free(void* virtual_address)
{
  801c14:	55                   	push   %ebp
  801c15:	89 e5                	mov    %esp,%ebp
  801c17:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.IM#2] USER HEAP - #3 free
	//Your code is here
	//Comment the following line
	panic("free() is not implemented yet...!!");
  801c1a:	83 ec 04             	sub    $0x4,%esp
  801c1d:	68 58 39 80 00       	push   $0x803958
  801c22:	6a 49                	push   $0x49
  801c24:	68 e4 38 80 00       	push   $0x8038e4
  801c29:	e8 28 ed ff ff       	call   800956 <_panic>

00801c2e <smalloc>:

//=================================
// [3] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  801c2e:	55                   	push   %ebp
  801c2f:	89 e5                	mov    %esp,%ebp
  801c31:	83 ec 18             	sub    $0x18,%esp
  801c34:	8b 45 10             	mov    0x10(%ebp),%eax
  801c37:	88 45 f4             	mov    %al,-0xc(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  801c3a:	e8 ca fe ff ff       	call   801b09 <uheap_init>
	if (size == 0) return NULL ;
  801c3f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801c43:	75 07                	jne    801c4c <smalloc+0x1e>
  801c45:	b8 00 00 00 00       	mov    $0x0,%eax
  801c4a:	eb 14                	jmp    801c60 <smalloc+0x32>
	//==============================================================

	//TODO: [PROJECT'25.IM#3] SHARED MEMORY - #2 smalloc
	//Your code is here
	//Comment the following line
	panic("smalloc() is not implemented yet...!!");
  801c4c:	83 ec 04             	sub    $0x4,%esp
  801c4f:	68 7c 39 80 00       	push   $0x80397c
  801c54:	6a 5a                	push   $0x5a
  801c56:	68 e4 38 80 00       	push   $0x8038e4
  801c5b:	e8 f6 ec ff ff       	call   800956 <_panic>
}
  801c60:	c9                   	leave  
  801c61:	c3                   	ret    

00801c62 <sget>:

//========================================
// [4] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801c62:	55                   	push   %ebp
  801c63:	89 e5                	mov    %esp,%ebp
  801c65:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  801c68:	e8 9c fe ff ff       	call   801b09 <uheap_init>
	//==============================================================

	//TODO: [PROJECT'25.IM#3] SHARED MEMORY - #4 sget
	//Your code is here
	//Comment the following line
	panic("sget() is not implemented yet...!!");
  801c6d:	83 ec 04             	sub    $0x4,%esp
  801c70:	68 a4 39 80 00       	push   $0x8039a4
  801c75:	6a 6a                	push   $0x6a
  801c77:	68 e4 38 80 00       	push   $0x8038e4
  801c7c:	e8 d5 ec ff ff       	call   800956 <_panic>

00801c81 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801c81:	55                   	push   %ebp
  801c82:	89 e5                	mov    %esp,%ebp
  801c84:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  801c87:	e8 7d fe ff ff       	call   801b09 <uheap_init>
	//==============================================================
	panic("realloc() is not implemented yet...!!");
  801c8c:	83 ec 04             	sub    $0x4,%esp
  801c8f:	68 c8 39 80 00       	push   $0x8039c8
  801c94:	68 88 00 00 00       	push   $0x88
  801c99:	68 e4 38 80 00       	push   $0x8038e4
  801c9e:	e8 b3 ec ff ff       	call   800956 <_panic>

00801ca3 <sfree>:
//
//	use sys_delete_shared_object(...); which switches to the kernel mode,
//	calls delete_shared_object(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the delete_shared_object() function is empty, make sure to implement it.
void sfree(void* virtual_address)
{
  801ca3:	55                   	push   %ebp
  801ca4:	89 e5                	mov    %esp,%ebp
  801ca6:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.BONUS#5] EXIT #2 - sfree
	//Your code is here
	//Comment the following line
	panic("sfree() is not implemented yet...!!");
  801ca9:	83 ec 04             	sub    $0x4,%esp
  801cac:	68 f0 39 80 00       	push   $0x8039f0
  801cb1:	68 9b 00 00 00       	push   $0x9b
  801cb6:	68 e4 38 80 00       	push   $0x8038e4
  801cbb:	e8 96 ec ff ff       	call   800956 <_panic>

00801cc0 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801cc0:	55                   	push   %ebp
  801cc1:	89 e5                	mov    %esp,%ebp
  801cc3:	57                   	push   %edi
  801cc4:	56                   	push   %esi
  801cc5:	53                   	push   %ebx
  801cc6:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801cc9:	8b 45 08             	mov    0x8(%ebp),%eax
  801ccc:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ccf:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801cd2:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801cd5:	8b 7d 18             	mov    0x18(%ebp),%edi
  801cd8:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801cdb:	cd 30                	int    $0x30
  801cdd:	89 45 f0             	mov    %eax,-0x10(%ebp)
				"b" (a3),
				"D" (a4),
				"S" (a5)
				: "cc", "memory");

	return ret;
  801ce0:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801ce3:	83 c4 10             	add    $0x10,%esp
  801ce6:	5b                   	pop    %ebx
  801ce7:	5e                   	pop    %esi
  801ce8:	5f                   	pop    %edi
  801ce9:	5d                   	pop    %ebp
  801cea:	c3                   	ret    

00801ceb <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName, int color)
{
  801ceb:	55                   	push   %ebp
  801cec:	89 e5                	mov    %esp,%ebp
  801cee:	83 ec 04             	sub    $0x4,%esp
  801cf1:	8b 45 10             	mov    0x10(%ebp),%eax
  801cf4:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, color, 0);
  801cf7:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801cfa:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801cfe:	8b 45 08             	mov    0x8(%ebp),%eax
  801d01:	6a 00                	push   $0x0
  801d03:	51                   	push   %ecx
  801d04:	52                   	push   %edx
  801d05:	ff 75 0c             	pushl  0xc(%ebp)
  801d08:	50                   	push   %eax
  801d09:	6a 00                	push   $0x0
  801d0b:	e8 b0 ff ff ff       	call   801cc0 <syscall>
  801d10:	83 c4 18             	add    $0x18,%esp
}
  801d13:	90                   	nop
  801d14:	c9                   	leave  
  801d15:	c3                   	ret    

00801d16 <sys_cgetc>:

int
sys_cgetc(void)
{
  801d16:	55                   	push   %ebp
  801d17:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801d19:	6a 00                	push   $0x0
  801d1b:	6a 00                	push   $0x0
  801d1d:	6a 00                	push   $0x0
  801d1f:	6a 00                	push   $0x0
  801d21:	6a 00                	push   $0x0
  801d23:	6a 02                	push   $0x2
  801d25:	e8 96 ff ff ff       	call   801cc0 <syscall>
  801d2a:	83 c4 18             	add    $0x18,%esp
}
  801d2d:	c9                   	leave  
  801d2e:	c3                   	ret    

00801d2f <sys_lock_cons>:

void sys_lock_cons(void)
{
  801d2f:	55                   	push   %ebp
  801d30:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  801d32:	6a 00                	push   $0x0
  801d34:	6a 00                	push   $0x0
  801d36:	6a 00                	push   $0x0
  801d38:	6a 00                	push   $0x0
  801d3a:	6a 00                	push   $0x0
  801d3c:	6a 03                	push   $0x3
  801d3e:	e8 7d ff ff ff       	call   801cc0 <syscall>
  801d43:	83 c4 18             	add    $0x18,%esp
}
  801d46:	90                   	nop
  801d47:	c9                   	leave  
  801d48:	c3                   	ret    

00801d49 <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  801d49:	55                   	push   %ebp
  801d4a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  801d4c:	6a 00                	push   $0x0
  801d4e:	6a 00                	push   $0x0
  801d50:	6a 00                	push   $0x0
  801d52:	6a 00                	push   $0x0
  801d54:	6a 00                	push   $0x0
  801d56:	6a 04                	push   $0x4
  801d58:	e8 63 ff ff ff       	call   801cc0 <syscall>
  801d5d:	83 c4 18             	add    $0x18,%esp
}
  801d60:	90                   	nop
  801d61:	c9                   	leave  
  801d62:	c3                   	ret    

00801d63 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801d63:	55                   	push   %ebp
  801d64:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801d66:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d69:	8b 45 08             	mov    0x8(%ebp),%eax
  801d6c:	6a 00                	push   $0x0
  801d6e:	6a 00                	push   $0x0
  801d70:	6a 00                	push   $0x0
  801d72:	52                   	push   %edx
  801d73:	50                   	push   %eax
  801d74:	6a 08                	push   $0x8
  801d76:	e8 45 ff ff ff       	call   801cc0 <syscall>
  801d7b:	83 c4 18             	add    $0x18,%esp
}
  801d7e:	c9                   	leave  
  801d7f:	c3                   	ret    

00801d80 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801d80:	55                   	push   %ebp
  801d81:	89 e5                	mov    %esp,%ebp
  801d83:	56                   	push   %esi
  801d84:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801d85:	8b 75 18             	mov    0x18(%ebp),%esi
  801d88:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801d8b:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801d8e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d91:	8b 45 08             	mov    0x8(%ebp),%eax
  801d94:	56                   	push   %esi
  801d95:	53                   	push   %ebx
  801d96:	51                   	push   %ecx
  801d97:	52                   	push   %edx
  801d98:	50                   	push   %eax
  801d99:	6a 09                	push   $0x9
  801d9b:	e8 20 ff ff ff       	call   801cc0 <syscall>
  801da0:	83 c4 18             	add    $0x18,%esp
}
  801da3:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801da6:	5b                   	pop    %ebx
  801da7:	5e                   	pop    %esi
  801da8:	5d                   	pop    %ebp
  801da9:	c3                   	ret    

00801daa <__sys_unmap_frame>:

int __sys_unmap_frame(uint32 va)
{
  801daa:	55                   	push   %ebp
  801dab:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, va, 0, 0, 0, 0);
  801dad:	6a 00                	push   $0x0
  801daf:	6a 00                	push   $0x0
  801db1:	6a 00                	push   $0x0
  801db3:	6a 00                	push   $0x0
  801db5:	ff 75 08             	pushl  0x8(%ebp)
  801db8:	6a 0a                	push   $0xa
  801dba:	e8 01 ff ff ff       	call   801cc0 <syscall>
  801dbf:	83 c4 18             	add    $0x18,%esp
}
  801dc2:	c9                   	leave  
  801dc3:	c3                   	ret    

00801dc4 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801dc4:	55                   	push   %ebp
  801dc5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801dc7:	6a 00                	push   $0x0
  801dc9:	6a 00                	push   $0x0
  801dcb:	6a 00                	push   $0x0
  801dcd:	ff 75 0c             	pushl  0xc(%ebp)
  801dd0:	ff 75 08             	pushl  0x8(%ebp)
  801dd3:	6a 0b                	push   $0xb
  801dd5:	e8 e6 fe ff ff       	call   801cc0 <syscall>
  801dda:	83 c4 18             	add    $0x18,%esp
}
  801ddd:	c9                   	leave  
  801dde:	c3                   	ret    

00801ddf <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801ddf:	55                   	push   %ebp
  801de0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801de2:	6a 00                	push   $0x0
  801de4:	6a 00                	push   $0x0
  801de6:	6a 00                	push   $0x0
  801de8:	6a 00                	push   $0x0
  801dea:	6a 00                	push   $0x0
  801dec:	6a 0c                	push   $0xc
  801dee:	e8 cd fe ff ff       	call   801cc0 <syscall>
  801df3:	83 c4 18             	add    $0x18,%esp
}
  801df6:	c9                   	leave  
  801df7:	c3                   	ret    

00801df8 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801df8:	55                   	push   %ebp
  801df9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801dfb:	6a 00                	push   $0x0
  801dfd:	6a 00                	push   $0x0
  801dff:	6a 00                	push   $0x0
  801e01:	6a 00                	push   $0x0
  801e03:	6a 00                	push   $0x0
  801e05:	6a 0d                	push   $0xd
  801e07:	e8 b4 fe ff ff       	call   801cc0 <syscall>
  801e0c:	83 c4 18             	add    $0x18,%esp
}
  801e0f:	c9                   	leave  
  801e10:	c3                   	ret    

00801e11 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801e11:	55                   	push   %ebp
  801e12:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801e14:	6a 00                	push   $0x0
  801e16:	6a 00                	push   $0x0
  801e18:	6a 00                	push   $0x0
  801e1a:	6a 00                	push   $0x0
  801e1c:	6a 00                	push   $0x0
  801e1e:	6a 0e                	push   $0xe
  801e20:	e8 9b fe ff ff       	call   801cc0 <syscall>
  801e25:	83 c4 18             	add    $0x18,%esp
}
  801e28:	c9                   	leave  
  801e29:	c3                   	ret    

00801e2a <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801e2a:	55                   	push   %ebp
  801e2b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801e2d:	6a 00                	push   $0x0
  801e2f:	6a 00                	push   $0x0
  801e31:	6a 00                	push   $0x0
  801e33:	6a 00                	push   $0x0
  801e35:	6a 00                	push   $0x0
  801e37:	6a 0f                	push   $0xf
  801e39:	e8 82 fe ff ff       	call   801cc0 <syscall>
  801e3e:	83 c4 18             	add    $0x18,%esp
}
  801e41:	c9                   	leave  
  801e42:	c3                   	ret    

00801e43 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801e43:	55                   	push   %ebp
  801e44:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801e46:	6a 00                	push   $0x0
  801e48:	6a 00                	push   $0x0
  801e4a:	6a 00                	push   $0x0
  801e4c:	6a 00                	push   $0x0
  801e4e:	ff 75 08             	pushl  0x8(%ebp)
  801e51:	6a 10                	push   $0x10
  801e53:	e8 68 fe ff ff       	call   801cc0 <syscall>
  801e58:	83 c4 18             	add    $0x18,%esp
}
  801e5b:	c9                   	leave  
  801e5c:	c3                   	ret    

00801e5d <sys_scarce_memory>:

void sys_scarce_memory()
{
  801e5d:	55                   	push   %ebp
  801e5e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801e60:	6a 00                	push   $0x0
  801e62:	6a 00                	push   $0x0
  801e64:	6a 00                	push   $0x0
  801e66:	6a 00                	push   $0x0
  801e68:	6a 00                	push   $0x0
  801e6a:	6a 11                	push   $0x11
  801e6c:	e8 4f fe ff ff       	call   801cc0 <syscall>
  801e71:	83 c4 18             	add    $0x18,%esp
}
  801e74:	90                   	nop
  801e75:	c9                   	leave  
  801e76:	c3                   	ret    

00801e77 <sys_cputc>:

void
sys_cputc(const char c)
{
  801e77:	55                   	push   %ebp
  801e78:	89 e5                	mov    %esp,%ebp
  801e7a:	83 ec 04             	sub    $0x4,%esp
  801e7d:	8b 45 08             	mov    0x8(%ebp),%eax
  801e80:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801e83:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801e87:	6a 00                	push   $0x0
  801e89:	6a 00                	push   $0x0
  801e8b:	6a 00                	push   $0x0
  801e8d:	6a 00                	push   $0x0
  801e8f:	50                   	push   %eax
  801e90:	6a 01                	push   $0x1
  801e92:	e8 29 fe ff ff       	call   801cc0 <syscall>
  801e97:	83 c4 18             	add    $0x18,%esp
}
  801e9a:	90                   	nop
  801e9b:	c9                   	leave  
  801e9c:	c3                   	ret    

00801e9d <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801e9d:	55                   	push   %ebp
  801e9e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801ea0:	6a 00                	push   $0x0
  801ea2:	6a 00                	push   $0x0
  801ea4:	6a 00                	push   $0x0
  801ea6:	6a 00                	push   $0x0
  801ea8:	6a 00                	push   $0x0
  801eaa:	6a 14                	push   $0x14
  801eac:	e8 0f fe ff ff       	call   801cc0 <syscall>
  801eb1:	83 c4 18             	add    $0x18,%esp
}
  801eb4:	90                   	nop
  801eb5:	c9                   	leave  
  801eb6:	c3                   	ret    

00801eb7 <sys_create_shared_object>:

int sys_create_shared_object(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801eb7:	55                   	push   %ebp
  801eb8:	89 e5                	mov    %esp,%ebp
  801eba:	83 ec 04             	sub    $0x4,%esp
  801ebd:	8b 45 10             	mov    0x10(%ebp),%eax
  801ec0:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801ec3:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801ec6:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801eca:	8b 45 08             	mov    0x8(%ebp),%eax
  801ecd:	6a 00                	push   $0x0
  801ecf:	51                   	push   %ecx
  801ed0:	52                   	push   %edx
  801ed1:	ff 75 0c             	pushl  0xc(%ebp)
  801ed4:	50                   	push   %eax
  801ed5:	6a 15                	push   $0x15
  801ed7:	e8 e4 fd ff ff       	call   801cc0 <syscall>
  801edc:	83 c4 18             	add    $0x18,%esp
}
  801edf:	c9                   	leave  
  801ee0:	c3                   	ret    

00801ee1 <sys_size_of_shared_object>:

//2017:
int sys_size_of_shared_object(int32 ownerID, char* shareName)
{
  801ee1:	55                   	push   %ebp
  801ee2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801ee4:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ee7:	8b 45 08             	mov    0x8(%ebp),%eax
  801eea:	6a 00                	push   $0x0
  801eec:	6a 00                	push   $0x0
  801eee:	6a 00                	push   $0x0
  801ef0:	52                   	push   %edx
  801ef1:	50                   	push   %eax
  801ef2:	6a 16                	push   $0x16
  801ef4:	e8 c7 fd ff ff       	call   801cc0 <syscall>
  801ef9:	83 c4 18             	add    $0x18,%esp
}
  801efc:	c9                   	leave  
  801efd:	c3                   	ret    

00801efe <sys_get_shared_object>:
//==========

int sys_get_shared_object(int32 ownerID, char* shareName, void* virtual_address)
{
  801efe:	55                   	push   %ebp
  801eff:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801f01:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801f04:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f07:	8b 45 08             	mov    0x8(%ebp),%eax
  801f0a:	6a 00                	push   $0x0
  801f0c:	6a 00                	push   $0x0
  801f0e:	51                   	push   %ecx
  801f0f:	52                   	push   %edx
  801f10:	50                   	push   %eax
  801f11:	6a 17                	push   $0x17
  801f13:	e8 a8 fd ff ff       	call   801cc0 <syscall>
  801f18:	83 c4 18             	add    $0x18,%esp
}
  801f1b:	c9                   	leave  
  801f1c:	c3                   	ret    

00801f1d <sys_delete_shared_object>:

int sys_delete_shared_object(int32 sharedObjectID, void *startVA)
{
  801f1d:	55                   	push   %ebp
  801f1e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801f20:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f23:	8b 45 08             	mov    0x8(%ebp),%eax
  801f26:	6a 00                	push   $0x0
  801f28:	6a 00                	push   $0x0
  801f2a:	6a 00                	push   $0x0
  801f2c:	52                   	push   %edx
  801f2d:	50                   	push   %eax
  801f2e:	6a 18                	push   $0x18
  801f30:	e8 8b fd ff ff       	call   801cc0 <syscall>
  801f35:	83 c4 18             	add    $0x18,%esp
}
  801f38:	c9                   	leave  
  801f39:	c3                   	ret    

00801f3a <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801f3a:	55                   	push   %ebp
  801f3b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801f3d:	8b 45 08             	mov    0x8(%ebp),%eax
  801f40:	6a 00                	push   $0x0
  801f42:	ff 75 14             	pushl  0x14(%ebp)
  801f45:	ff 75 10             	pushl  0x10(%ebp)
  801f48:	ff 75 0c             	pushl  0xc(%ebp)
  801f4b:	50                   	push   %eax
  801f4c:	6a 19                	push   $0x19
  801f4e:	e8 6d fd ff ff       	call   801cc0 <syscall>
  801f53:	83 c4 18             	add    $0x18,%esp
}
  801f56:	c9                   	leave  
  801f57:	c3                   	ret    

00801f58 <sys_run_env>:

void sys_run_env(int32 envId)
{
  801f58:	55                   	push   %ebp
  801f59:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801f5b:	8b 45 08             	mov    0x8(%ebp),%eax
  801f5e:	6a 00                	push   $0x0
  801f60:	6a 00                	push   $0x0
  801f62:	6a 00                	push   $0x0
  801f64:	6a 00                	push   $0x0
  801f66:	50                   	push   %eax
  801f67:	6a 1a                	push   $0x1a
  801f69:	e8 52 fd ff ff       	call   801cc0 <syscall>
  801f6e:	83 c4 18             	add    $0x18,%esp
}
  801f71:	90                   	nop
  801f72:	c9                   	leave  
  801f73:	c3                   	ret    

00801f74 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801f74:	55                   	push   %ebp
  801f75:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801f77:	8b 45 08             	mov    0x8(%ebp),%eax
  801f7a:	6a 00                	push   $0x0
  801f7c:	6a 00                	push   $0x0
  801f7e:	6a 00                	push   $0x0
  801f80:	6a 00                	push   $0x0
  801f82:	50                   	push   %eax
  801f83:	6a 1b                	push   $0x1b
  801f85:	e8 36 fd ff ff       	call   801cc0 <syscall>
  801f8a:	83 c4 18             	add    $0x18,%esp
}
  801f8d:	c9                   	leave  
  801f8e:	c3                   	ret    

00801f8f <sys_getenvid>:

int32 sys_getenvid(void)
{
  801f8f:	55                   	push   %ebp
  801f90:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801f92:	6a 00                	push   $0x0
  801f94:	6a 00                	push   $0x0
  801f96:	6a 00                	push   $0x0
  801f98:	6a 00                	push   $0x0
  801f9a:	6a 00                	push   $0x0
  801f9c:	6a 05                	push   $0x5
  801f9e:	e8 1d fd ff ff       	call   801cc0 <syscall>
  801fa3:	83 c4 18             	add    $0x18,%esp
}
  801fa6:	c9                   	leave  
  801fa7:	c3                   	ret    

00801fa8 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801fa8:	55                   	push   %ebp
  801fa9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801fab:	6a 00                	push   $0x0
  801fad:	6a 00                	push   $0x0
  801faf:	6a 00                	push   $0x0
  801fb1:	6a 00                	push   $0x0
  801fb3:	6a 00                	push   $0x0
  801fb5:	6a 06                	push   $0x6
  801fb7:	e8 04 fd ff ff       	call   801cc0 <syscall>
  801fbc:	83 c4 18             	add    $0x18,%esp
}
  801fbf:	c9                   	leave  
  801fc0:	c3                   	ret    

00801fc1 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801fc1:	55                   	push   %ebp
  801fc2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801fc4:	6a 00                	push   $0x0
  801fc6:	6a 00                	push   $0x0
  801fc8:	6a 00                	push   $0x0
  801fca:	6a 00                	push   $0x0
  801fcc:	6a 00                	push   $0x0
  801fce:	6a 07                	push   $0x7
  801fd0:	e8 eb fc ff ff       	call   801cc0 <syscall>
  801fd5:	83 c4 18             	add    $0x18,%esp
}
  801fd8:	c9                   	leave  
  801fd9:	c3                   	ret    

00801fda <sys_exit_env>:


void sys_exit_env(void)
{
  801fda:	55                   	push   %ebp
  801fdb:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801fdd:	6a 00                	push   $0x0
  801fdf:	6a 00                	push   $0x0
  801fe1:	6a 00                	push   $0x0
  801fe3:	6a 00                	push   $0x0
  801fe5:	6a 00                	push   $0x0
  801fe7:	6a 1c                	push   $0x1c
  801fe9:	e8 d2 fc ff ff       	call   801cc0 <syscall>
  801fee:	83 c4 18             	add    $0x18,%esp
}
  801ff1:	90                   	nop
  801ff2:	c9                   	leave  
  801ff3:	c3                   	ret    

00801ff4 <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  801ff4:	55                   	push   %ebp
  801ff5:	89 e5                	mov    %esp,%ebp
  801ff7:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801ffa:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801ffd:	8d 50 04             	lea    0x4(%eax),%edx
  802000:	8d 45 f8             	lea    -0x8(%ebp),%eax
  802003:	6a 00                	push   $0x0
  802005:	6a 00                	push   $0x0
  802007:	6a 00                	push   $0x0
  802009:	52                   	push   %edx
  80200a:	50                   	push   %eax
  80200b:	6a 1d                	push   $0x1d
  80200d:	e8 ae fc ff ff       	call   801cc0 <syscall>
  802012:	83 c4 18             	add    $0x18,%esp
	return result;
  802015:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802018:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80201b:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80201e:	89 01                	mov    %eax,(%ecx)
  802020:	89 51 04             	mov    %edx,0x4(%ecx)
}
  802023:	8b 45 08             	mov    0x8(%ebp),%eax
  802026:	c9                   	leave  
  802027:	c2 04 00             	ret    $0x4

0080202a <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  80202a:	55                   	push   %ebp
  80202b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  80202d:	6a 00                	push   $0x0
  80202f:	6a 00                	push   $0x0
  802031:	ff 75 10             	pushl  0x10(%ebp)
  802034:	ff 75 0c             	pushl  0xc(%ebp)
  802037:	ff 75 08             	pushl  0x8(%ebp)
  80203a:	6a 13                	push   $0x13
  80203c:	e8 7f fc ff ff       	call   801cc0 <syscall>
  802041:	83 c4 18             	add    $0x18,%esp
	return ;
  802044:	90                   	nop
}
  802045:	c9                   	leave  
  802046:	c3                   	ret    

00802047 <sys_rcr2>:
uint32 sys_rcr2()
{
  802047:	55                   	push   %ebp
  802048:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  80204a:	6a 00                	push   $0x0
  80204c:	6a 00                	push   $0x0
  80204e:	6a 00                	push   $0x0
  802050:	6a 00                	push   $0x0
  802052:	6a 00                	push   $0x0
  802054:	6a 1e                	push   $0x1e
  802056:	e8 65 fc ff ff       	call   801cc0 <syscall>
  80205b:	83 c4 18             	add    $0x18,%esp
}
  80205e:	c9                   	leave  
  80205f:	c3                   	ret    

00802060 <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  802060:	55                   	push   %ebp
  802061:	89 e5                	mov    %esp,%ebp
  802063:	83 ec 04             	sub    $0x4,%esp
  802066:	8b 45 08             	mov    0x8(%ebp),%eax
  802069:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  80206c:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  802070:	6a 00                	push   $0x0
  802072:	6a 00                	push   $0x0
  802074:	6a 00                	push   $0x0
  802076:	6a 00                	push   $0x0
  802078:	50                   	push   %eax
  802079:	6a 1f                	push   $0x1f
  80207b:	e8 40 fc ff ff       	call   801cc0 <syscall>
  802080:	83 c4 18             	add    $0x18,%esp
	return ;
  802083:	90                   	nop
}
  802084:	c9                   	leave  
  802085:	c3                   	ret    

00802086 <rsttst>:
void rsttst()
{
  802086:	55                   	push   %ebp
  802087:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  802089:	6a 00                	push   $0x0
  80208b:	6a 00                	push   $0x0
  80208d:	6a 00                	push   $0x0
  80208f:	6a 00                	push   $0x0
  802091:	6a 00                	push   $0x0
  802093:	6a 21                	push   $0x21
  802095:	e8 26 fc ff ff       	call   801cc0 <syscall>
  80209a:	83 c4 18             	add    $0x18,%esp
	return ;
  80209d:	90                   	nop
}
  80209e:	c9                   	leave  
  80209f:	c3                   	ret    

008020a0 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  8020a0:	55                   	push   %ebp
  8020a1:	89 e5                	mov    %esp,%ebp
  8020a3:	83 ec 04             	sub    $0x4,%esp
  8020a6:	8b 45 14             	mov    0x14(%ebp),%eax
  8020a9:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  8020ac:	8b 55 18             	mov    0x18(%ebp),%edx
  8020af:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8020b3:	52                   	push   %edx
  8020b4:	50                   	push   %eax
  8020b5:	ff 75 10             	pushl  0x10(%ebp)
  8020b8:	ff 75 0c             	pushl  0xc(%ebp)
  8020bb:	ff 75 08             	pushl  0x8(%ebp)
  8020be:	6a 20                	push   $0x20
  8020c0:	e8 fb fb ff ff       	call   801cc0 <syscall>
  8020c5:	83 c4 18             	add    $0x18,%esp
	return ;
  8020c8:	90                   	nop
}
  8020c9:	c9                   	leave  
  8020ca:	c3                   	ret    

008020cb <chktst>:
void chktst(uint32 n)
{
  8020cb:	55                   	push   %ebp
  8020cc:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  8020ce:	6a 00                	push   $0x0
  8020d0:	6a 00                	push   $0x0
  8020d2:	6a 00                	push   $0x0
  8020d4:	6a 00                	push   $0x0
  8020d6:	ff 75 08             	pushl  0x8(%ebp)
  8020d9:	6a 22                	push   $0x22
  8020db:	e8 e0 fb ff ff       	call   801cc0 <syscall>
  8020e0:	83 c4 18             	add    $0x18,%esp
	return ;
  8020e3:	90                   	nop
}
  8020e4:	c9                   	leave  
  8020e5:	c3                   	ret    

008020e6 <inctst>:

void inctst()
{
  8020e6:	55                   	push   %ebp
  8020e7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  8020e9:	6a 00                	push   $0x0
  8020eb:	6a 00                	push   $0x0
  8020ed:	6a 00                	push   $0x0
  8020ef:	6a 00                	push   $0x0
  8020f1:	6a 00                	push   $0x0
  8020f3:	6a 23                	push   $0x23
  8020f5:	e8 c6 fb ff ff       	call   801cc0 <syscall>
  8020fa:	83 c4 18             	add    $0x18,%esp
	return ;
  8020fd:	90                   	nop
}
  8020fe:	c9                   	leave  
  8020ff:	c3                   	ret    

00802100 <gettst>:
uint32 gettst()
{
  802100:	55                   	push   %ebp
  802101:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  802103:	6a 00                	push   $0x0
  802105:	6a 00                	push   $0x0
  802107:	6a 00                	push   $0x0
  802109:	6a 00                	push   $0x0
  80210b:	6a 00                	push   $0x0
  80210d:	6a 24                	push   $0x24
  80210f:	e8 ac fb ff ff       	call   801cc0 <syscall>
  802114:	83 c4 18             	add    $0x18,%esp
}
  802117:	c9                   	leave  
  802118:	c3                   	ret    

00802119 <sys_get_uheap_strategy>:

/*2025*/
uint32 sys_get_uheap_strategy()
{
  802119:	55                   	push   %ebp
  80211a:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80211c:	6a 00                	push   $0x0
  80211e:	6a 00                	push   $0x0
  802120:	6a 00                	push   $0x0
  802122:	6a 00                	push   $0x0
  802124:	6a 00                	push   $0x0
  802126:	6a 25                	push   $0x25
  802128:	e8 93 fb ff ff       	call   801cc0 <syscall>
  80212d:	83 c4 18             	add    $0x18,%esp
  802130:	a3 60 c0 81 00       	mov    %eax,0x81c060
	return uheapPlaceStrategy ;
  802135:	a1 60 c0 81 00       	mov    0x81c060,%eax
}
  80213a:	c9                   	leave  
  80213b:	c3                   	ret    

0080213c <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  80213c:	55                   	push   %ebp
  80213d:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = heapStrategy;
  80213f:	8b 45 08             	mov    0x8(%ebp),%eax
  802142:	a3 60 c0 81 00       	mov    %eax,0x81c060
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  802147:	6a 00                	push   $0x0
  802149:	6a 00                	push   $0x0
  80214b:	6a 00                	push   $0x0
  80214d:	6a 00                	push   $0x0
  80214f:	ff 75 08             	pushl  0x8(%ebp)
  802152:	6a 26                	push   $0x26
  802154:	e8 67 fb ff ff       	call   801cc0 <syscall>
  802159:	83 c4 18             	add    $0x18,%esp
	return ;
  80215c:	90                   	nop
}
  80215d:	c9                   	leave  
  80215e:	c3                   	ret    

0080215f <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  80215f:	55                   	push   %ebp
  802160:	89 e5                	mov    %esp,%ebp
  802162:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  802163:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802166:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802169:	8b 55 0c             	mov    0xc(%ebp),%edx
  80216c:	8b 45 08             	mov    0x8(%ebp),%eax
  80216f:	6a 00                	push   $0x0
  802171:	53                   	push   %ebx
  802172:	51                   	push   %ecx
  802173:	52                   	push   %edx
  802174:	50                   	push   %eax
  802175:	6a 27                	push   $0x27
  802177:	e8 44 fb ff ff       	call   801cc0 <syscall>
  80217c:	83 c4 18             	add    $0x18,%esp
}
  80217f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802182:	c9                   	leave  
  802183:	c3                   	ret    

00802184 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  802184:	55                   	push   %ebp
  802185:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  802187:	8b 55 0c             	mov    0xc(%ebp),%edx
  80218a:	8b 45 08             	mov    0x8(%ebp),%eax
  80218d:	6a 00                	push   $0x0
  80218f:	6a 00                	push   $0x0
  802191:	6a 00                	push   $0x0
  802193:	52                   	push   %edx
  802194:	50                   	push   %eax
  802195:	6a 28                	push   $0x28
  802197:	e8 24 fb ff ff       	call   801cc0 <syscall>
  80219c:	83 c4 18             	add    $0x18,%esp
}
  80219f:	c9                   	leave  
  8021a0:	c3                   	ret    

008021a1 <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  8021a1:	55                   	push   %ebp
  8021a2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  8021a4:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8021a7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8021aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8021ad:	6a 00                	push   $0x0
  8021af:	51                   	push   %ecx
  8021b0:	ff 75 10             	pushl  0x10(%ebp)
  8021b3:	52                   	push   %edx
  8021b4:	50                   	push   %eax
  8021b5:	6a 29                	push   $0x29
  8021b7:	e8 04 fb ff ff       	call   801cc0 <syscall>
  8021bc:	83 c4 18             	add    $0x18,%esp
}
  8021bf:	c9                   	leave  
  8021c0:	c3                   	ret    

008021c1 <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  8021c1:	55                   	push   %ebp
  8021c2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  8021c4:	6a 00                	push   $0x0
  8021c6:	6a 00                	push   $0x0
  8021c8:	ff 75 10             	pushl  0x10(%ebp)
  8021cb:	ff 75 0c             	pushl  0xc(%ebp)
  8021ce:	ff 75 08             	pushl  0x8(%ebp)
  8021d1:	6a 12                	push   $0x12
  8021d3:	e8 e8 fa ff ff       	call   801cc0 <syscall>
  8021d8:	83 c4 18             	add    $0x18,%esp
	return ;
  8021db:	90                   	nop
}
  8021dc:	c9                   	leave  
  8021dd:	c3                   	ret    

008021de <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  8021de:	55                   	push   %ebp
  8021df:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  8021e1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8021e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8021e7:	6a 00                	push   $0x0
  8021e9:	6a 00                	push   $0x0
  8021eb:	6a 00                	push   $0x0
  8021ed:	52                   	push   %edx
  8021ee:	50                   	push   %eax
  8021ef:	6a 2a                	push   $0x2a
  8021f1:	e8 ca fa ff ff       	call   801cc0 <syscall>
  8021f6:	83 c4 18             	add    $0x18,%esp
	return;
  8021f9:	90                   	nop
}
  8021fa:	c9                   	leave  
  8021fb:	c3                   	ret    

008021fc <sys_get_optimal_num_faults>:
/*2025*/
int sys_get_optimal_num_faults()
{
  8021fc:	55                   	push   %ebp
  8021fd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_optimal_num_faults, 0, 0, 0, 0, 0);
  8021ff:	6a 00                	push   $0x0
  802201:	6a 00                	push   $0x0
  802203:	6a 00                	push   $0x0
  802205:	6a 00                	push   $0x0
  802207:	6a 00                	push   $0x0
  802209:	6a 2b                	push   $0x2b
  80220b:	e8 b0 fa ff ff       	call   801cc0 <syscall>
  802210:	83 c4 18             	add    $0x18,%esp
}
  802213:	c9                   	leave  
  802214:	c3                   	ret    

00802215 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  802215:	55                   	push   %ebp
  802216:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  802218:	6a 00                	push   $0x0
  80221a:	6a 00                	push   $0x0
  80221c:	6a 00                	push   $0x0
  80221e:	ff 75 0c             	pushl  0xc(%ebp)
  802221:	ff 75 08             	pushl  0x8(%ebp)
  802224:	6a 2d                	push   $0x2d
  802226:	e8 95 fa ff ff       	call   801cc0 <syscall>
  80222b:	83 c4 18             	add    $0x18,%esp
	return;
  80222e:	90                   	nop
}
  80222f:	c9                   	leave  
  802230:	c3                   	ret    

00802231 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  802231:	55                   	push   %ebp
  802232:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  802234:	6a 00                	push   $0x0
  802236:	6a 00                	push   $0x0
  802238:	6a 00                	push   $0x0
  80223a:	ff 75 0c             	pushl  0xc(%ebp)
  80223d:	ff 75 08             	pushl  0x8(%ebp)
  802240:	6a 2c                	push   $0x2c
  802242:	e8 79 fa ff ff       	call   801cc0 <syscall>
  802247:	83 c4 18             	add    $0x18,%esp
	return ;
  80224a:	90                   	nop
}
  80224b:	c9                   	leave  
  80224c:	c3                   	ret    

0080224d <sys_env_set_priority>:


void sys_env_set_priority(int32 envID, int priority)
{
  80224d:	55                   	push   %ebp
  80224e:	89 e5                	mov    %esp,%ebp
  802250:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.IM#4] CPU SCHEDULING - #1 System Calls - Add suitable code here
	//Your code is here
	//Comment the following line
	panic("sys_env_set_priority() is not implemented yet...!!");
  802253:	83 ec 04             	sub    $0x4,%esp
  802256:	68 14 3a 80 00       	push   $0x803a14
  80225b:	68 25 01 00 00       	push   $0x125
  802260:	68 47 3a 80 00       	push   $0x803a47
  802265:	e8 ec e6 ff ff       	call   800956 <_panic>

0080226a <to_page_va>:
//==================================
//==================================
// [1] GET PAGE VA:
//==================================
__inline__ uint32 to_page_va(struct PageInfoElement *ptrPageInfo)
{
  80226a:	55                   	push   %ebp
  80226b:	89 e5                	mov    %esp,%ebp
  80226d:	83 ec 18             	sub    $0x18,%esp
	if (ptrPageInfo < &pageBlockInfoArr[0] || ptrPageInfo >= &pageBlockInfoArr[DYN_ALLOC_MAX_SIZE/PAGE_SIZE])
  802270:	81 7d 08 60 40 80 00 	cmpl   $0x804060,0x8(%ebp)
  802277:	72 09                	jb     802282 <to_page_va+0x18>
  802279:	81 7d 08 60 c0 81 00 	cmpl   $0x81c060,0x8(%ebp)
  802280:	72 14                	jb     802296 <to_page_va+0x2c>
			panic("to_page_va called with invalid pageInfoPtr");
  802282:	83 ec 04             	sub    $0x4,%esp
  802285:	68 58 3a 80 00       	push   $0x803a58
  80228a:	6a 15                	push   $0x15
  80228c:	68 83 3a 80 00       	push   $0x803a83
  802291:	e8 c0 e6 ff ff       	call   800956 <_panic>
	//Get start VA of the page from the corresponding Page Info pointer
	int idxInPageInfoArr = (ptrPageInfo - pageBlockInfoArr);
  802296:	8b 45 08             	mov    0x8(%ebp),%eax
  802299:	ba 60 40 80 00       	mov    $0x804060,%edx
  80229e:	29 d0                	sub    %edx,%eax
  8022a0:	c1 f8 02             	sar    $0x2,%eax
  8022a3:	89 c2                	mov    %eax,%edx
  8022a5:	89 d0                	mov    %edx,%eax
  8022a7:	c1 e0 02             	shl    $0x2,%eax
  8022aa:	01 d0                	add    %edx,%eax
  8022ac:	c1 e0 02             	shl    $0x2,%eax
  8022af:	01 d0                	add    %edx,%eax
  8022b1:	c1 e0 02             	shl    $0x2,%eax
  8022b4:	01 d0                	add    %edx,%eax
  8022b6:	89 c1                	mov    %eax,%ecx
  8022b8:	c1 e1 08             	shl    $0x8,%ecx
  8022bb:	01 c8                	add    %ecx,%eax
  8022bd:	89 c1                	mov    %eax,%ecx
  8022bf:	c1 e1 10             	shl    $0x10,%ecx
  8022c2:	01 c8                	add    %ecx,%eax
  8022c4:	01 c0                	add    %eax,%eax
  8022c6:	01 d0                	add    %edx,%eax
  8022c8:	89 45 f4             	mov    %eax,-0xc(%ebp)
	return dynAllocStart + (idxInPageInfoArr << PGSHIFT);
  8022cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022ce:	c1 e0 0c             	shl    $0xc,%eax
  8022d1:	89 c2                	mov    %eax,%edx
  8022d3:	a1 64 c0 81 00       	mov    0x81c064,%eax
  8022d8:	01 d0                	add    %edx,%eax
}
  8022da:	c9                   	leave  
  8022db:	c3                   	ret    

008022dc <to_page_info>:

//==================================
// [2] GET PAGE INFO OF PAGE VA:
//==================================
__inline__ struct PageInfoElement * to_page_info(uint32 va)
{
  8022dc:	55                   	push   %ebp
  8022dd:	89 e5                	mov    %esp,%ebp
  8022df:	83 ec 18             	sub    $0x18,%esp
	int idxInPageInfoArr = (va - dynAllocStart) >> PGSHIFT;
  8022e2:	a1 64 c0 81 00       	mov    0x81c064,%eax
  8022e7:	8b 55 08             	mov    0x8(%ebp),%edx
  8022ea:	29 c2                	sub    %eax,%edx
  8022ec:	89 d0                	mov    %edx,%eax
  8022ee:	c1 e8 0c             	shr    $0xc,%eax
  8022f1:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if (idxInPageInfoArr < 0 || idxInPageInfoArr >= DYN_ALLOC_MAX_SIZE/PAGE_SIZE)
  8022f4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8022f8:	78 09                	js     802303 <to_page_info+0x27>
  8022fa:	81 7d f4 ff 1f 00 00 	cmpl   $0x1fff,-0xc(%ebp)
  802301:	7e 14                	jle    802317 <to_page_info+0x3b>
		panic("to_page_info called with invalid pa");
  802303:	83 ec 04             	sub    $0x4,%esp
  802306:	68 9c 3a 80 00       	push   $0x803a9c
  80230b:	6a 22                	push   $0x22
  80230d:	68 83 3a 80 00       	push   $0x803a83
  802312:	e8 3f e6 ff ff       	call   800956 <_panic>
	return &pageBlockInfoArr[idxInPageInfoArr];
  802317:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80231a:	89 d0                	mov    %edx,%eax
  80231c:	01 c0                	add    %eax,%eax
  80231e:	01 d0                	add    %edx,%eax
  802320:	c1 e0 02             	shl    $0x2,%eax
  802323:	05 60 40 80 00       	add    $0x804060,%eax
}
  802328:	c9                   	leave  
  802329:	c3                   	ret    

0080232a <initialize_dynamic_allocator>:
//==================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================
bool is_initialized = 0;
void initialize_dynamic_allocator(uint32 daStart, uint32 daEnd)
{
  80232a:	55                   	push   %ebp
  80232b:	89 e5                	mov    %esp,%ebp
  80232d:	83 ec 18             	sub    $0x18,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		assert(daEnd <= daStart + DYN_ALLOC_MAX_SIZE);
  802330:	8b 45 08             	mov    0x8(%ebp),%eax
  802333:	05 00 00 00 02       	add    $0x2000000,%eax
  802338:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80233b:	73 16                	jae    802353 <initialize_dynamic_allocator+0x29>
  80233d:	68 c0 3a 80 00       	push   $0x803ac0
  802342:	68 e6 3a 80 00       	push   $0x803ae6
  802347:	6a 34                	push   $0x34
  802349:	68 83 3a 80 00       	push   $0x803a83
  80234e:	e8 03 e6 ff ff       	call   800956 <_panic>
		is_initialized = 1;
  802353:	c7 05 24 40 80 00 01 	movl   $0x1,0x804024
  80235a:	00 00 00 
	//==================================================================================
	//==================================================================================
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #1 initialize_dynamic_allocator
	//Your code is here
	// init bounds of the dynalloc
	dynAllocStart = daStart;
  80235d:	8b 45 08             	mov    0x8(%ebp),%eax
  802360:	a3 64 c0 81 00       	mov    %eax,0x81c064
	dynAllocEnd = daEnd;
  802365:	8b 45 0c             	mov    0xc(%ebp),%eax
  802368:	a3 40 40 80 00       	mov    %eax,0x804040
	// init the list that keep track of all free pageBlockInfoArr instances.
	LIST_INIT(&freePagesList);
  80236d:	c7 05 48 40 80 00 00 	movl   $0x0,0x804048
  802374:	00 00 00 
  802377:	c7 05 4c 40 80 00 00 	movl   $0x0,0x80404c
  80237e:	00 00 00 
  802381:	c7 05 54 40 80 00 00 	movl   $0x0,0x804054
  802388:	00 00 00 

	// no.of pages in the dynamic allocator.
	int pCount = (daEnd - daStart) / PAGE_SIZE;
  80238b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80238e:	2b 45 08             	sub    0x8(%ebp),%eax
  802391:	c1 e8 0c             	shr    $0xc,%eax
  802394:	89 45 ec             	mov    %eax,-0x14(%ebp)
	// iterate over each page and init its data in pageBlockInfoArr and reset it.
	for (int i = 0; i < pCount; ++i) {
  802397:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  80239e:	e9 c8 00 00 00       	jmp    80246b <initialize_dynamic_allocator+0x141>
	    pageBlockInfoArr[i].block_size = 0;
  8023a3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8023a6:	89 d0                	mov    %edx,%eax
  8023a8:	01 c0                	add    %eax,%eax
  8023aa:	01 d0                	add    %edx,%eax
  8023ac:	c1 e0 02             	shl    $0x2,%eax
  8023af:	05 68 40 80 00       	add    $0x804068,%eax
  8023b4:	66 c7 00 00 00       	movw   $0x0,(%eax)
	    pageBlockInfoArr[i].num_of_free_blocks = 0;
  8023b9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8023bc:	89 d0                	mov    %edx,%eax
  8023be:	01 c0                	add    %eax,%eax
  8023c0:	01 d0                	add    %edx,%eax
  8023c2:	c1 e0 02             	shl    $0x2,%eax
  8023c5:	05 6a 40 80 00       	add    $0x80406a,%eax
  8023ca:	66 c7 00 00 00       	movw   $0x0,(%eax)
	    LIST_INSERT_TAIL(&freePagesList, &pageBlockInfoArr[i]);
  8023cf:	8b 15 4c 40 80 00    	mov    0x80404c,%edx
  8023d5:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  8023d8:	89 c8                	mov    %ecx,%eax
  8023da:	01 c0                	add    %eax,%eax
  8023dc:	01 c8                	add    %ecx,%eax
  8023de:	c1 e0 02             	shl    $0x2,%eax
  8023e1:	05 64 40 80 00       	add    $0x804064,%eax
  8023e6:	89 10                	mov    %edx,(%eax)
  8023e8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8023eb:	89 d0                	mov    %edx,%eax
  8023ed:	01 c0                	add    %eax,%eax
  8023ef:	01 d0                	add    %edx,%eax
  8023f1:	c1 e0 02             	shl    $0x2,%eax
  8023f4:	05 64 40 80 00       	add    $0x804064,%eax
  8023f9:	8b 00                	mov    (%eax),%eax
  8023fb:	85 c0                	test   %eax,%eax
  8023fd:	74 1b                	je     80241a <initialize_dynamic_allocator+0xf0>
  8023ff:	8b 15 4c 40 80 00    	mov    0x80404c,%edx
  802405:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  802408:	89 c8                	mov    %ecx,%eax
  80240a:	01 c0                	add    %eax,%eax
  80240c:	01 c8                	add    %ecx,%eax
  80240e:	c1 e0 02             	shl    $0x2,%eax
  802411:	05 60 40 80 00       	add    $0x804060,%eax
  802416:	89 02                	mov    %eax,(%edx)
  802418:	eb 16                	jmp    802430 <initialize_dynamic_allocator+0x106>
  80241a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80241d:	89 d0                	mov    %edx,%eax
  80241f:	01 c0                	add    %eax,%eax
  802421:	01 d0                	add    %edx,%eax
  802423:	c1 e0 02             	shl    $0x2,%eax
  802426:	05 60 40 80 00       	add    $0x804060,%eax
  80242b:	a3 48 40 80 00       	mov    %eax,0x804048
  802430:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802433:	89 d0                	mov    %edx,%eax
  802435:	01 c0                	add    %eax,%eax
  802437:	01 d0                	add    %edx,%eax
  802439:	c1 e0 02             	shl    $0x2,%eax
  80243c:	05 60 40 80 00       	add    $0x804060,%eax
  802441:	a3 4c 40 80 00       	mov    %eax,0x80404c
  802446:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802449:	89 d0                	mov    %edx,%eax
  80244b:	01 c0                	add    %eax,%eax
  80244d:	01 d0                	add    %edx,%eax
  80244f:	c1 e0 02             	shl    $0x2,%eax
  802452:	05 60 40 80 00       	add    $0x804060,%eax
  802457:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80245d:	a1 54 40 80 00       	mov    0x804054,%eax
  802462:	40                   	inc    %eax
  802463:	a3 54 40 80 00       	mov    %eax,0x804054
	LIST_INIT(&freePagesList);

	// no.of pages in the dynamic allocator.
	int pCount = (daEnd - daStart) / PAGE_SIZE;
	// iterate over each page and init its data in pageBlockInfoArr and reset it.
	for (int i = 0; i < pCount; ++i) {
  802468:	ff 45 f4             	incl   -0xc(%ebp)
  80246b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80246e:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  802471:	0f 8c 2c ff ff ff    	jl     8023a3 <initialize_dynamic_allocator+0x79>
	    LIST_INSERT_TAIL(&freePagesList, &pageBlockInfoArr[i]);
	}
	// init the array of lists of each size..
	// 8 16 32 64 128 256 512 1024 2056
	// 0 1  2  3   4  5    6   7    8
	for (int i = 0; i <= (LOG2_MAX_SIZE - LOG2_MIN_SIZE); ++i){
  802477:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80247e:	eb 36                	jmp    8024b6 <initialize_dynamic_allocator+0x18c>
		LIST_INIT(&freeBlockLists[i]);
  802480:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802483:	c1 e0 04             	shl    $0x4,%eax
  802486:	05 80 c0 81 00       	add    $0x81c080,%eax
  80248b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802491:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802494:	c1 e0 04             	shl    $0x4,%eax
  802497:	05 84 c0 81 00       	add    $0x81c084,%eax
  80249c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8024a2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024a5:	c1 e0 04             	shl    $0x4,%eax
  8024a8:	05 8c c0 81 00       	add    $0x81c08c,%eax
  8024ad:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	    LIST_INSERT_TAIL(&freePagesList, &pageBlockInfoArr[i]);
	}
	// init the array of lists of each size..
	// 8 16 32 64 128 256 512 1024 2056
	// 0 1  2  3   4  5    6   7    8
	for (int i = 0; i <= (LOG2_MAX_SIZE - LOG2_MIN_SIZE); ++i){
  8024b3:	ff 45 f0             	incl   -0x10(%ebp)
  8024b6:	83 7d f0 08          	cmpl   $0x8,-0x10(%ebp)
  8024ba:	7e c4                	jle    802480 <initialize_dynamic_allocator+0x156>
		LIST_INIT(&freeBlockLists[i]);
	}
	//Comment the following line
	//panic("initialize_dynamic_allocator() Not implemented yet");

}
  8024bc:	90                   	nop
  8024bd:	c9                   	leave  
  8024be:	c3                   	ret    

008024bf <get_block_size>:

//===========================
// [2] GET BLOCK SIZE:
//===========================
__inline__ uint32 get_block_size(void *va)
{
  8024bf:	55                   	push   %ebp
  8024c0:	89 e5                	mov    %esp,%ebp
  8024c2:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #2 get_block_size
	//Your code is here
	// get the page that saves this va
	struct PageInfoElement* ptr = to_page_info((uint32)va);
  8024c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8024c8:	83 ec 0c             	sub    $0xc,%esp
  8024cb:	50                   	push   %eax
  8024cc:	e8 0b fe ff ff       	call   8022dc <to_page_info>
  8024d1:	83 c4 10             	add    $0x10,%esp
  8024d4:	89 45 f4             	mov    %eax,-0xc(%ebp)
	return ptr->block_size;
  8024d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024da:	8b 40 08             	mov    0x8(%eax),%eax
  8024dd:	0f b7 c0             	movzwl %ax,%eax
	//Comment the following line
	//panic("get_block_size() Not implemented yet");
}
  8024e0:	c9                   	leave  
  8024e1:	c3                   	ret    

008024e2 <split_page_to_blocks>:
// =====================
// h) split page to blocks and add them in freeBlockLists
// =====================
// function that split the page provided into same sized blocks
//and putem in suitable freeblockList index according to size.
 void split_page_to_blocks(uint32 blk_size, struct PageInfoElement *pageInfo) {
  8024e2:	55                   	push   %ebp
  8024e3:	89 e5                	mov    %esp,%ebp
  8024e5:	83 ec 28             	sub    $0x28,%esp
	 // cur page virtual address by the pageInfo.
	 uint32 page_va = (uint32)to_page_va(pageInfo);
  8024e8:	83 ec 0c             	sub    $0xc,%esp
  8024eb:	ff 75 0c             	pushl  0xc(%ebp)
  8024ee:	e8 77 fd ff ff       	call   80226a <to_page_va>
  8024f3:	83 c4 10             	add    $0x10,%esp
  8024f6:	89 45 e8             	mov    %eax,-0x18(%ebp)
	 // no. of blks to save in freeblockList.
	 int blk_count = PAGE_SIZE / blk_size;
  8024f9:	b8 00 10 00 00       	mov    $0x1000,%eax
  8024fe:	ba 00 00 00 00       	mov    $0x0,%edx
  802503:	f7 75 08             	divl   0x8(%ebp)
  802506:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	 // save page in memory.
	 get_page((uint32*)page_va);
  802509:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80250c:	83 ec 0c             	sub    $0xc,%esp
  80250f:	50                   	push   %eax
  802510:	e8 48 f6 ff ff       	call   801b5d <get_page>
  802515:	83 c4 10             	add    $0x10,%esp
	 // assigning the pageInfo data block size, free block which is whole block count.
	 pageInfo->num_of_free_blocks = blk_count;
  802518:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80251b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80251e:	66 89 42 0a          	mov    %ax,0xa(%edx)
	 pageInfo->block_size = blk_size;
  802522:	8b 45 08             	mov    0x8(%ebp),%eax
  802525:	8b 55 0c             	mov    0xc(%ebp),%edx
  802528:	66 89 42 08          	mov    %ax,0x8(%edx)
	 // get index by size block in freeblocklist.
	 int idx = 0;
  80252c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	 for (int i = LOG2_MIN_SIZE; i <= LOG2_MAX_SIZE; i++) {
  802533:	c7 45 f0 03 00 00 00 	movl   $0x3,-0x10(%ebp)
  80253a:	eb 19                	jmp    802555 <split_page_to_blocks+0x73>
	     if ((1 << i) == blk_size)
  80253c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80253f:	ba 01 00 00 00       	mov    $0x1,%edx
  802544:	88 c1                	mov    %al,%cl
  802546:	d3 e2                	shl    %cl,%edx
  802548:	89 d0                	mov    %edx,%eax
  80254a:	3b 45 08             	cmp    0x8(%ebp),%eax
  80254d:	74 0e                	je     80255d <split_page_to_blocks+0x7b>
	         break;
	     idx++;
  80254f:	ff 45 f4             	incl   -0xc(%ebp)
	 // assigning the pageInfo data block size, free block which is whole block count.
	 pageInfo->num_of_free_blocks = blk_count;
	 pageInfo->block_size = blk_size;
	 // get index by size block in freeblocklist.
	 int idx = 0;
	 for (int i = LOG2_MIN_SIZE; i <= LOG2_MAX_SIZE; i++) {
  802552:	ff 45 f0             	incl   -0x10(%ebp)
  802555:	83 7d f0 0b          	cmpl   $0xb,-0x10(%ebp)
  802559:	7e e1                	jle    80253c <split_page_to_blocks+0x5a>
  80255b:	eb 01                	jmp    80255e <split_page_to_blocks+0x7c>
	     if ((1 << i) == blk_size)
	         break;
  80255d:	90                   	nop
	     idx++;
	 }
	 // iterate over each blk and make and element of it by passing its address in blockElement pointer and save those in the list.
	 // starting from the page_va.
	 for (uint32 i = 0; i < blk_count; ++i) {
  80255e:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  802565:	e9 a7 00 00 00       	jmp    802611 <split_page_to_blocks+0x12f>
	     struct BlockElement *blk =(struct BlockElement*)(page_va + i * blk_size);
  80256a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80256d:	0f af 45 08          	imul   0x8(%ebp),%eax
  802571:	89 c2                	mov    %eax,%edx
  802573:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802576:	01 d0                	add    %edx,%eax
  802578:	89 45 e0             	mov    %eax,-0x20(%ebp)
	     LIST_INSERT_TAIL(&freeBlockLists[idx],blk);
  80257b:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80257f:	75 14                	jne    802595 <split_page_to_blocks+0xb3>
  802581:	83 ec 04             	sub    $0x4,%esp
  802584:	68 fc 3a 80 00       	push   $0x803afc
  802589:	6a 7c                	push   $0x7c
  80258b:	68 83 3a 80 00       	push   $0x803a83
  802590:	e8 c1 e3 ff ff       	call   800956 <_panic>
  802595:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802598:	c1 e0 04             	shl    $0x4,%eax
  80259b:	05 84 c0 81 00       	add    $0x81c084,%eax
  8025a0:	8b 10                	mov    (%eax),%edx
  8025a2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8025a5:	89 50 04             	mov    %edx,0x4(%eax)
  8025a8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8025ab:	8b 40 04             	mov    0x4(%eax),%eax
  8025ae:	85 c0                	test   %eax,%eax
  8025b0:	74 14                	je     8025c6 <split_page_to_blocks+0xe4>
  8025b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025b5:	c1 e0 04             	shl    $0x4,%eax
  8025b8:	05 84 c0 81 00       	add    $0x81c084,%eax
  8025bd:	8b 00                	mov    (%eax),%eax
  8025bf:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8025c2:	89 10                	mov    %edx,(%eax)
  8025c4:	eb 11                	jmp    8025d7 <split_page_to_blocks+0xf5>
  8025c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025c9:	c1 e0 04             	shl    $0x4,%eax
  8025cc:	8d 90 80 c0 81 00    	lea    0x81c080(%eax),%edx
  8025d2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8025d5:	89 02                	mov    %eax,(%edx)
  8025d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025da:	c1 e0 04             	shl    $0x4,%eax
  8025dd:	8d 90 84 c0 81 00    	lea    0x81c084(%eax),%edx
  8025e3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8025e6:	89 02                	mov    %eax,(%edx)
  8025e8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8025eb:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8025f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025f4:	c1 e0 04             	shl    $0x4,%eax
  8025f7:	05 8c c0 81 00       	add    $0x81c08c,%eax
  8025fc:	8b 00                	mov    (%eax),%eax
  8025fe:	8d 50 01             	lea    0x1(%eax),%edx
  802601:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802604:	c1 e0 04             	shl    $0x4,%eax
  802607:	05 8c c0 81 00       	add    $0x81c08c,%eax
  80260c:	89 10                	mov    %edx,(%eax)
	         break;
	     idx++;
	 }
	 // iterate over each blk and make and element of it by passing its address in blockElement pointer and save those in the list.
	 // starting from the page_va.
	 for (uint32 i = 0; i < blk_count; ++i) {
  80260e:	ff 45 ec             	incl   -0x14(%ebp)
  802611:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802614:	39 45 ec             	cmp    %eax,-0x14(%ebp)
  802617:	0f 82 4d ff ff ff    	jb     80256a <split_page_to_blocks+0x88>
	     struct BlockElement *blk =(struct BlockElement*)(page_va + i * blk_size);
	     LIST_INSERT_TAIL(&freeBlockLists[idx],blk);
	 }
 }
  80261d:	90                   	nop
  80261e:	c9                   	leave  
  80261f:	c3                   	ret    

00802620 <alloc_block>:

//===========================
// 3) ALLOCATE BLOCK:
//===========================
void *alloc_block(uint32 size)
{
  802620:	55                   	push   %ebp
  802621:	89 e5                	mov    %esp,%ebp
  802623:	83 ec 38             	sub    $0x38,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		assert(size <= DYN_ALLOC_MAX_BLOCK_SIZE);
  802626:	81 7d 08 00 08 00 00 	cmpl   $0x800,0x8(%ebp)
  80262d:	76 19                	jbe    802648 <alloc_block+0x28>
  80262f:	68 20 3b 80 00       	push   $0x803b20
  802634:	68 e6 3a 80 00       	push   $0x803ae6
  802639:	68 8a 00 00 00       	push   $0x8a
  80263e:	68 83 3a 80 00       	push   $0x803a83
  802643:	e8 0e e3 ff ff       	call   800956 <_panic>
	//==================================================================================
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #3 alloc_block
	//Your code is here
	//Comment the following line
	// get index in freeBlockList by size.
	uint32 idx = 0;
  802648:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int i = LOG2_MIN_SIZE; i <= LOG2_MAX_SIZE; ++i){
  80264f:	c7 45 f0 03 00 00 00 	movl   $0x3,-0x10(%ebp)
  802656:	eb 19                	jmp    802671 <alloc_block+0x51>
		if((1 << i) >= size) break;
  802658:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80265b:	ba 01 00 00 00       	mov    $0x1,%edx
  802660:	88 c1                	mov    %al,%cl
  802662:	d3 e2                	shl    %cl,%edx
  802664:	89 d0                	mov    %edx,%eax
  802666:	3b 45 08             	cmp    0x8(%ebp),%eax
  802669:	73 0e                	jae    802679 <alloc_block+0x59>
		idx++;
  80266b:	ff 45 f4             	incl   -0xc(%ebp)
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #3 alloc_block
	//Your code is here
	//Comment the following line
	// get index in freeBlockList by size.
	uint32 idx = 0;
	for (int i = LOG2_MIN_SIZE; i <= LOG2_MAX_SIZE; ++i){
  80266e:	ff 45 f0             	incl   -0x10(%ebp)
  802671:	83 7d f0 0b          	cmpl   $0xb,-0x10(%ebp)
  802675:	7e e1                	jle    802658 <alloc_block+0x38>
  802677:	eb 01                	jmp    80267a <alloc_block+0x5a>
		if((1 << i) >= size) break;
  802679:	90                   	nop
		idx++;
	}

	//case 1: the free block of the cur size is available.
	if (freeBlockLists[idx].size > 0) {
  80267a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80267d:	c1 e0 04             	shl    $0x4,%eax
  802680:	05 8c c0 81 00       	add    $0x81c08c,%eax
  802685:	8b 00                	mov    (%eax),%eax
  802687:	85 c0                	test   %eax,%eax
  802689:	0f 84 df 00 00 00    	je     80276e <alloc_block+0x14e>

		// remove from the list and updat the pageInfoArr free blocks.
		// pop from the freeBlockList.
		struct BlockElement *blk = LIST_FIRST(&freeBlockLists[idx]);
  80268f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802692:	c1 e0 04             	shl    $0x4,%eax
  802695:	05 80 c0 81 00       	add    $0x81c080,%eax
  80269a:	8b 00                	mov    (%eax),%eax
  80269c:	89 45 ec             	mov    %eax,-0x14(%ebp)
	    LIST_REMOVE(&freeBlockLists[idx], blk);
  80269f:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8026a3:	75 17                	jne    8026bc <alloc_block+0x9c>
  8026a5:	83 ec 04             	sub    $0x4,%esp
  8026a8:	68 41 3b 80 00       	push   $0x803b41
  8026ad:	68 9e 00 00 00       	push   $0x9e
  8026b2:	68 83 3a 80 00       	push   $0x803a83
  8026b7:	e8 9a e2 ff ff       	call   800956 <_panic>
  8026bc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8026bf:	8b 00                	mov    (%eax),%eax
  8026c1:	85 c0                	test   %eax,%eax
  8026c3:	74 10                	je     8026d5 <alloc_block+0xb5>
  8026c5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8026c8:	8b 00                	mov    (%eax),%eax
  8026ca:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8026cd:	8b 52 04             	mov    0x4(%edx),%edx
  8026d0:	89 50 04             	mov    %edx,0x4(%eax)
  8026d3:	eb 14                	jmp    8026e9 <alloc_block+0xc9>
  8026d5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8026d8:	8b 40 04             	mov    0x4(%eax),%eax
  8026db:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8026de:	c1 e2 04             	shl    $0x4,%edx
  8026e1:	81 c2 84 c0 81 00    	add    $0x81c084,%edx
  8026e7:	89 02                	mov    %eax,(%edx)
  8026e9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8026ec:	8b 40 04             	mov    0x4(%eax),%eax
  8026ef:	85 c0                	test   %eax,%eax
  8026f1:	74 0f                	je     802702 <alloc_block+0xe2>
  8026f3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8026f6:	8b 40 04             	mov    0x4(%eax),%eax
  8026f9:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8026fc:	8b 12                	mov    (%edx),%edx
  8026fe:	89 10                	mov    %edx,(%eax)
  802700:	eb 13                	jmp    802715 <alloc_block+0xf5>
  802702:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802705:	8b 00                	mov    (%eax),%eax
  802707:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80270a:	c1 e2 04             	shl    $0x4,%edx
  80270d:	81 c2 80 c0 81 00    	add    $0x81c080,%edx
  802713:	89 02                	mov    %eax,(%edx)
  802715:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802718:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80271e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802721:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802728:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80272b:	c1 e0 04             	shl    $0x4,%eax
  80272e:	05 8c c0 81 00       	add    $0x81c08c,%eax
  802733:	8b 00                	mov    (%eax),%eax
  802735:	8d 50 ff             	lea    -0x1(%eax),%edx
  802738:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80273b:	c1 e0 04             	shl    $0x4,%eax
  80273e:	05 8c c0 81 00       	add    $0x81c08c,%eax
  802743:	89 10                	mov    %edx,(%eax)
	    // update pageBlockInfoArr
	    struct PageInfoElement *pageInfo = to_page_info((uint32)blk);
  802745:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802748:	83 ec 0c             	sub    $0xc,%esp
  80274b:	50                   	push   %eax
  80274c:	e8 8b fb ff ff       	call   8022dc <to_page_info>
  802751:	83 c4 10             	add    $0x10,%esp
  802754:	89 45 e8             	mov    %eax,-0x18(%ebp)
	    pageInfo->num_of_free_blocks--;
  802757:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80275a:	66 8b 40 0a          	mov    0xa(%eax),%ax
  80275e:	48                   	dec    %eax
  80275f:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802762:	66 89 42 0a          	mov    %ax,0xa(%edx)
	    return blk;
  802766:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802769:	e9 bc 02 00 00       	jmp    802a2a <alloc_block+0x40a>
	}else{ //case(2, 3): 2. no free blocks available in the freeblocklist but there is free pages.
				//3. no free blocks and no available freepages so search in higher block sizes.
		// case 2:
		if(freePagesList.size > 0){ //have free pages.
  80276e:	a1 54 40 80 00       	mov    0x804054,%eax
  802773:	85 c0                	test   %eax,%eax
  802775:	0f 84 7d 02 00 00    	je     8029f8 <alloc_block+0x3d8>
			// get page to split and use from freepagesList.
			struct PageInfoElement *ptr_new_page = LIST_FIRST(&freePagesList);
  80277b:	a1 48 40 80 00       	mov    0x804048,%eax
  802780:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			LIST_REMOVE(&freePagesList, ptr_new_page);
  802783:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  802787:	75 17                	jne    8027a0 <alloc_block+0x180>
  802789:	83 ec 04             	sub    $0x4,%esp
  80278c:	68 41 3b 80 00       	push   $0x803b41
  802791:	68 a9 00 00 00       	push   $0xa9
  802796:	68 83 3a 80 00       	push   $0x803a83
  80279b:	e8 b6 e1 ff ff       	call   800956 <_panic>
  8027a0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8027a3:	8b 00                	mov    (%eax),%eax
  8027a5:	85 c0                	test   %eax,%eax
  8027a7:	74 10                	je     8027b9 <alloc_block+0x199>
  8027a9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8027ac:	8b 00                	mov    (%eax),%eax
  8027ae:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8027b1:	8b 52 04             	mov    0x4(%edx),%edx
  8027b4:	89 50 04             	mov    %edx,0x4(%eax)
  8027b7:	eb 0b                	jmp    8027c4 <alloc_block+0x1a4>
  8027b9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8027bc:	8b 40 04             	mov    0x4(%eax),%eax
  8027bf:	a3 4c 40 80 00       	mov    %eax,0x80404c
  8027c4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8027c7:	8b 40 04             	mov    0x4(%eax),%eax
  8027ca:	85 c0                	test   %eax,%eax
  8027cc:	74 0f                	je     8027dd <alloc_block+0x1bd>
  8027ce:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8027d1:	8b 40 04             	mov    0x4(%eax),%eax
  8027d4:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8027d7:	8b 12                	mov    (%edx),%edx
  8027d9:	89 10                	mov    %edx,(%eax)
  8027db:	eb 0a                	jmp    8027e7 <alloc_block+0x1c7>
  8027dd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8027e0:	8b 00                	mov    (%eax),%eax
  8027e2:	a3 48 40 80 00       	mov    %eax,0x804048
  8027e7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8027ea:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8027f0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8027f3:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8027fa:	a1 54 40 80 00       	mov    0x804054,%eax
  8027ff:	48                   	dec    %eax
  802800:	a3 54 40 80 00       	mov    %eax,0x804054
			// from page to freeblockList by the pageInfo and the block size.
			split_page_to_blocks(1 << (idx + LOG2_MIN_SIZE), ptr_new_page);
  802805:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802808:	83 c0 03             	add    $0x3,%eax
  80280b:	ba 01 00 00 00       	mov    $0x1,%edx
  802810:	88 c1                	mov    %al,%cl
  802812:	d3 e2                	shl    %cl,%edx
  802814:	89 d0                	mov    %edx,%eax
  802816:	83 ec 08             	sub    $0x8,%esp
  802819:	ff 75 e4             	pushl  -0x1c(%ebp)
  80281c:	50                   	push   %eax
  80281d:	e8 c0 fc ff ff       	call   8024e2 <split_page_to_blocks>
  802822:	83 c4 10             	add    $0x10,%esp

			// remove from the list and updat the pageInfoArr free blocks.
			// pop from the freeBlockList.
			struct BlockElement *blk = LIST_FIRST(&freeBlockLists[idx]);
  802825:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802828:	c1 e0 04             	shl    $0x4,%eax
  80282b:	05 80 c0 81 00       	add    $0x81c080,%eax
  802830:	8b 00                	mov    (%eax),%eax
  802832:	89 45 e0             	mov    %eax,-0x20(%ebp)
		    LIST_REMOVE(&freeBlockLists[idx], blk);
  802835:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  802839:	75 17                	jne    802852 <alloc_block+0x232>
  80283b:	83 ec 04             	sub    $0x4,%esp
  80283e:	68 41 3b 80 00       	push   $0x803b41
  802843:	68 b0 00 00 00       	push   $0xb0
  802848:	68 83 3a 80 00       	push   $0x803a83
  80284d:	e8 04 e1 ff ff       	call   800956 <_panic>
  802852:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802855:	8b 00                	mov    (%eax),%eax
  802857:	85 c0                	test   %eax,%eax
  802859:	74 10                	je     80286b <alloc_block+0x24b>
  80285b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80285e:	8b 00                	mov    (%eax),%eax
  802860:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802863:	8b 52 04             	mov    0x4(%edx),%edx
  802866:	89 50 04             	mov    %edx,0x4(%eax)
  802869:	eb 14                	jmp    80287f <alloc_block+0x25f>
  80286b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80286e:	8b 40 04             	mov    0x4(%eax),%eax
  802871:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802874:	c1 e2 04             	shl    $0x4,%edx
  802877:	81 c2 84 c0 81 00    	add    $0x81c084,%edx
  80287d:	89 02                	mov    %eax,(%edx)
  80287f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802882:	8b 40 04             	mov    0x4(%eax),%eax
  802885:	85 c0                	test   %eax,%eax
  802887:	74 0f                	je     802898 <alloc_block+0x278>
  802889:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80288c:	8b 40 04             	mov    0x4(%eax),%eax
  80288f:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802892:	8b 12                	mov    (%edx),%edx
  802894:	89 10                	mov    %edx,(%eax)
  802896:	eb 13                	jmp    8028ab <alloc_block+0x28b>
  802898:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80289b:	8b 00                	mov    (%eax),%eax
  80289d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8028a0:	c1 e2 04             	shl    $0x4,%edx
  8028a3:	81 c2 80 c0 81 00    	add    $0x81c080,%edx
  8028a9:	89 02                	mov    %eax,(%edx)
  8028ab:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8028ae:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8028b4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8028b7:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8028be:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028c1:	c1 e0 04             	shl    $0x4,%eax
  8028c4:	05 8c c0 81 00       	add    $0x81c08c,%eax
  8028c9:	8b 00                	mov    (%eax),%eax
  8028cb:	8d 50 ff             	lea    -0x1(%eax),%edx
  8028ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028d1:	c1 e0 04             	shl    $0x4,%eax
  8028d4:	05 8c c0 81 00       	add    $0x81c08c,%eax
  8028d9:	89 10                	mov    %edx,(%eax)
		    // update pageBlockInfoArr
		    struct PageInfoElement *pageInfo = to_page_info((uint32)blk);
  8028db:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8028de:	83 ec 0c             	sub    $0xc,%esp
  8028e1:	50                   	push   %eax
  8028e2:	e8 f5 f9 ff ff       	call   8022dc <to_page_info>
  8028e7:	83 c4 10             	add    $0x10,%esp
  8028ea:	89 45 dc             	mov    %eax,-0x24(%ebp)
		    pageInfo->num_of_free_blocks--;
  8028ed:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8028f0:	66 8b 40 0a          	mov    0xa(%eax),%ax
  8028f4:	48                   	dec    %eax
  8028f5:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8028f8:	66 89 42 0a          	mov    %ax,0xa(%edx)
		    return blk;
  8028fc:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8028ff:	e9 26 01 00 00       	jmp    802a2a <alloc_block+0x40a>
		}else{//case 3: no free block and no free page so iterate and try to find bigger size.
			// iterate over the list until finding available block
			while (idx <= (LOG2_MAX_SIZE - LOG2_MIN_SIZE) && freeBlockLists[idx].size == 0) {
				idx++;
  802904:	ff 45 f4             	incl   -0xc(%ebp)
				// found free block
				if(freeBlockLists[idx].size > 0){
  802907:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80290a:	c1 e0 04             	shl    $0x4,%eax
  80290d:	05 8c c0 81 00       	add    $0x81c08c,%eax
  802912:	8b 00                	mov    (%eax),%eax
  802914:	85 c0                	test   %eax,%eax
  802916:	0f 84 dc 00 00 00    	je     8029f8 <alloc_block+0x3d8>
					// remove from the list and updat the pageInfoArr free blocks.
					// pop from the freeBlockList.
					struct BlockElement *blk = LIST_FIRST(&freeBlockLists[idx]);
  80291c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80291f:	c1 e0 04             	shl    $0x4,%eax
  802922:	05 80 c0 81 00       	add    $0x81c080,%eax
  802927:	8b 00                	mov    (%eax),%eax
  802929:	89 45 d8             	mov    %eax,-0x28(%ebp)
				    LIST_REMOVE(&freeBlockLists[idx], blk);
  80292c:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  802930:	75 17                	jne    802949 <alloc_block+0x329>
  802932:	83 ec 04             	sub    $0x4,%esp
  802935:	68 41 3b 80 00       	push   $0x803b41
  80293a:	68 be 00 00 00       	push   $0xbe
  80293f:	68 83 3a 80 00       	push   $0x803a83
  802944:	e8 0d e0 ff ff       	call   800956 <_panic>
  802949:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80294c:	8b 00                	mov    (%eax),%eax
  80294e:	85 c0                	test   %eax,%eax
  802950:	74 10                	je     802962 <alloc_block+0x342>
  802952:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802955:	8b 00                	mov    (%eax),%eax
  802957:	8b 55 d8             	mov    -0x28(%ebp),%edx
  80295a:	8b 52 04             	mov    0x4(%edx),%edx
  80295d:	89 50 04             	mov    %edx,0x4(%eax)
  802960:	eb 14                	jmp    802976 <alloc_block+0x356>
  802962:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802965:	8b 40 04             	mov    0x4(%eax),%eax
  802968:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80296b:	c1 e2 04             	shl    $0x4,%edx
  80296e:	81 c2 84 c0 81 00    	add    $0x81c084,%edx
  802974:	89 02                	mov    %eax,(%edx)
  802976:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802979:	8b 40 04             	mov    0x4(%eax),%eax
  80297c:	85 c0                	test   %eax,%eax
  80297e:	74 0f                	je     80298f <alloc_block+0x36f>
  802980:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802983:	8b 40 04             	mov    0x4(%eax),%eax
  802986:	8b 55 d8             	mov    -0x28(%ebp),%edx
  802989:	8b 12                	mov    (%edx),%edx
  80298b:	89 10                	mov    %edx,(%eax)
  80298d:	eb 13                	jmp    8029a2 <alloc_block+0x382>
  80298f:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802992:	8b 00                	mov    (%eax),%eax
  802994:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802997:	c1 e2 04             	shl    $0x4,%edx
  80299a:	81 c2 80 c0 81 00    	add    $0x81c080,%edx
  8029a0:	89 02                	mov    %eax,(%edx)
  8029a2:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8029a5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8029ab:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8029ae:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8029b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029b8:	c1 e0 04             	shl    $0x4,%eax
  8029bb:	05 8c c0 81 00       	add    $0x81c08c,%eax
  8029c0:	8b 00                	mov    (%eax),%eax
  8029c2:	8d 50 ff             	lea    -0x1(%eax),%edx
  8029c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029c8:	c1 e0 04             	shl    $0x4,%eax
  8029cb:	05 8c c0 81 00       	add    $0x81c08c,%eax
  8029d0:	89 10                	mov    %edx,(%eax)
				    // update pageBlockInfoArr
				    struct PageInfoElement *pageInfo = to_page_info((uint32)blk);
  8029d2:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8029d5:	83 ec 0c             	sub    $0xc,%esp
  8029d8:	50                   	push   %eax
  8029d9:	e8 fe f8 ff ff       	call   8022dc <to_page_info>
  8029de:	83 c4 10             	add    $0x10,%esp
  8029e1:	89 45 d4             	mov    %eax,-0x2c(%ebp)
				    pageInfo->num_of_free_blocks--;
  8029e4:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8029e7:	66 8b 40 0a          	mov    0xa(%eax),%ax
  8029eb:	48                   	dec    %eax
  8029ec:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8029ef:	66 89 42 0a          	mov    %ax,0xa(%edx)
				    return blk;
  8029f3:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8029f6:	eb 32                	jmp    802a2a <alloc_block+0x40a>
		    struct PageInfoElement *pageInfo = to_page_info((uint32)blk);
		    pageInfo->num_of_free_blocks--;
		    return blk;
		}else{//case 3: no free block and no free page so iterate and try to find bigger size.
			// iterate over the list until finding available block
			while (idx <= (LOG2_MAX_SIZE - LOG2_MIN_SIZE) && freeBlockLists[idx].size == 0) {
  8029f8:	83 7d f4 08          	cmpl   $0x8,-0xc(%ebp)
  8029fc:	77 15                	ja     802a13 <alloc_block+0x3f3>
  8029fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a01:	c1 e0 04             	shl    $0x4,%eax
  802a04:	05 8c c0 81 00       	add    $0x81c08c,%eax
  802a09:	8b 00                	mov    (%eax),%eax
  802a0b:	85 c0                	test   %eax,%eax
  802a0d:	0f 84 f1 fe ff ff    	je     802904 <alloc_block+0x2e4>
				}
			}
		}
	}
	//case4: no free blocks or pages.
	panic("no free blocks!");
  802a13:	83 ec 04             	sub    $0x4,%esp
  802a16:	68 5f 3b 80 00       	push   $0x803b5f
  802a1b:	68 c8 00 00 00       	push   $0xc8
  802a20:	68 83 3a 80 00       	push   $0x803a83
  802a25:	e8 2c df ff ff       	call   800956 <_panic>
	//panic("alloc_block() Not implemented yet");
	//TODO: [PROJECT'25.BONUS#1] DYNAMIC ALLOCATOR - block if no free block
	return NULL;
}
  802a2a:	c9                   	leave  
  802a2b:	c3                   	ret    

00802a2c <free_block>:

//===========================
// [4] FREE BLOCK:
//===========================
void free_block(void *va)
{
  802a2c:	55                   	push   %ebp
  802a2d:	89 e5                	mov    %esp,%ebp
  802a2f:	83 ec 38             	sub    $0x38,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		assert((uint32)va >= dynAllocStart && (uint32)va < dynAllocEnd);
  802a32:	8b 55 08             	mov    0x8(%ebp),%edx
  802a35:	a1 64 c0 81 00       	mov    0x81c064,%eax
  802a3a:	39 c2                	cmp    %eax,%edx
  802a3c:	72 0c                	jb     802a4a <free_block+0x1e>
  802a3e:	8b 55 08             	mov    0x8(%ebp),%edx
  802a41:	a1 40 40 80 00       	mov    0x804040,%eax
  802a46:	39 c2                	cmp    %eax,%edx
  802a48:	72 19                	jb     802a63 <free_block+0x37>
  802a4a:	68 70 3b 80 00       	push   $0x803b70
  802a4f:	68 e6 3a 80 00       	push   $0x803ae6
  802a54:	68 d7 00 00 00       	push   $0xd7
  802a59:	68 83 3a 80 00       	push   $0x803a83
  802a5e:	e8 f3 de ff ff       	call   800956 <_panic>
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #4 free_block
	//Your code is here
	//Comment the following line
	// va of a piece in memory to free so:
	// 1. get its page, and make blk with this address to be put in the freeBlockList.
	struct BlockElement* blk_to_free = (struct BlockElement*)va;
  802a63:	8b 45 08             	mov    0x8(%ebp),%eax
  802a66:	89 45 e8             	mov    %eax,-0x18(%ebp)
	struct PageInfoElement *pageInfo = to_page_info((uint32)va);
  802a69:	8b 45 08             	mov    0x8(%ebp),%eax
  802a6c:	83 ec 0c             	sub    $0xc,%esp
  802a6f:	50                   	push   %eax
  802a70:	e8 67 f8 ff ff       	call   8022dc <to_page_info>
  802a75:	83 c4 10             	add    $0x10,%esp
  802a78:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	uint32 blk_size = pageInfo->block_size;
  802a7b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802a7e:	8b 40 08             	mov    0x8(%eax),%eax
  802a81:	0f b7 c0             	movzwl %ax,%eax
  802a84:	89 45 e0             	mov    %eax,-0x20(%ebp)

	// its index in the freeBlocklist.
	int idx = 0;
  802a87:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int i = LOG2_MIN_SIZE; i <= LOG2_MAX_SIZE; i++) {
  802a8e:	c7 45 f0 03 00 00 00 	movl   $0x3,-0x10(%ebp)
  802a95:	eb 19                	jmp    802ab0 <free_block+0x84>
	    if ((1 << i) == blk_size)
  802a97:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a9a:	ba 01 00 00 00       	mov    $0x1,%edx
  802a9f:	88 c1                	mov    %al,%cl
  802aa1:	d3 e2                	shl    %cl,%edx
  802aa3:	89 d0                	mov    %edx,%eax
  802aa5:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  802aa8:	74 0e                	je     802ab8 <free_block+0x8c>
	        break;
	    idx++;
  802aaa:	ff 45 f4             	incl   -0xc(%ebp)
	struct PageInfoElement *pageInfo = to_page_info((uint32)va);
	uint32 blk_size = pageInfo->block_size;

	// its index in the freeBlocklist.
	int idx = 0;
	for (int i = LOG2_MIN_SIZE; i <= LOG2_MAX_SIZE; i++) {
  802aad:	ff 45 f0             	incl   -0x10(%ebp)
  802ab0:	83 7d f0 0b          	cmpl   $0xb,-0x10(%ebp)
  802ab4:	7e e1                	jle    802a97 <free_block+0x6b>
  802ab6:	eb 01                	jmp    802ab9 <free_block+0x8d>
	    if ((1 << i) == blk_size)
	        break;
  802ab8:	90                   	nop
	    idx++;
	}

	pageInfo->num_of_free_blocks++;
  802ab9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802abc:	66 8b 40 0a          	mov    0xa(%eax),%ax
  802ac0:	40                   	inc    %eax
  802ac1:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802ac4:	66 89 42 0a          	mov    %ax,0xa(%edx)
	LIST_INSERT_TAIL(&freeBlockLists[idx], blk_to_free);
  802ac8:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802acc:	75 17                	jne    802ae5 <free_block+0xb9>
  802ace:	83 ec 04             	sub    $0x4,%esp
  802ad1:	68 fc 3a 80 00       	push   $0x803afc
  802ad6:	68 ee 00 00 00       	push   $0xee
  802adb:	68 83 3a 80 00       	push   $0x803a83
  802ae0:	e8 71 de ff ff       	call   800956 <_panic>
  802ae5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ae8:	c1 e0 04             	shl    $0x4,%eax
  802aeb:	05 84 c0 81 00       	add    $0x81c084,%eax
  802af0:	8b 10                	mov    (%eax),%edx
  802af2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802af5:	89 50 04             	mov    %edx,0x4(%eax)
  802af8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802afb:	8b 40 04             	mov    0x4(%eax),%eax
  802afe:	85 c0                	test   %eax,%eax
  802b00:	74 14                	je     802b16 <free_block+0xea>
  802b02:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b05:	c1 e0 04             	shl    $0x4,%eax
  802b08:	05 84 c0 81 00       	add    $0x81c084,%eax
  802b0d:	8b 00                	mov    (%eax),%eax
  802b0f:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802b12:	89 10                	mov    %edx,(%eax)
  802b14:	eb 11                	jmp    802b27 <free_block+0xfb>
  802b16:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b19:	c1 e0 04             	shl    $0x4,%eax
  802b1c:	8d 90 80 c0 81 00    	lea    0x81c080(%eax),%edx
  802b22:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802b25:	89 02                	mov    %eax,(%edx)
  802b27:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b2a:	c1 e0 04             	shl    $0x4,%eax
  802b2d:	8d 90 84 c0 81 00    	lea    0x81c084(%eax),%edx
  802b33:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802b36:	89 02                	mov    %eax,(%edx)
  802b38:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802b3b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802b41:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b44:	c1 e0 04             	shl    $0x4,%eax
  802b47:	05 8c c0 81 00       	add    $0x81c08c,%eax
  802b4c:	8b 00                	mov    (%eax),%eax
  802b4e:	8d 50 01             	lea    0x1(%eax),%edx
  802b51:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b54:	c1 e0 04             	shl    $0x4,%eax
  802b57:	05 8c c0 81 00       	add    $0x81c08c,%eax
  802b5c:	89 10                	mov    %edx,(%eax)

	// now, case 1: the page all blocks are freed so you free the page.
	int blk_count = PAGE_SIZE / blk_size;
  802b5e:	b8 00 10 00 00       	mov    $0x1000,%eax
  802b63:	ba 00 00 00 00       	mov    $0x0,%edx
  802b68:	f7 75 e0             	divl   -0x20(%ebp)
  802b6b:	89 45 dc             	mov    %eax,-0x24(%ebp)
	// the blk count in the page is same as number fo free blocks free up the page.
	if (pageInfo->num_of_free_blocks == blk_count) {
  802b6e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802b71:	66 8b 40 0a          	mov    0xa(%eax),%ax
  802b75:	0f b7 c0             	movzwl %ax,%eax
  802b78:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  802b7b:	0f 85 70 01 00 00    	jne    802cf1 <free_block+0x2c5>
		uint32 page_va = to_page_va(pageInfo);
  802b81:	83 ec 0c             	sub    $0xc,%esp
  802b84:	ff 75 e4             	pushl  -0x1c(%ebp)
  802b87:	e8 de f6 ff ff       	call   80226a <to_page_va>
  802b8c:	83 c4 10             	add    $0x10,%esp
  802b8f:	89 45 d8             	mov    %eax,-0x28(%ebp)
		// remove all blk in the freeBlockList.
		for (uint32 off = 0; off < PAGE_SIZE; off += blk_size) {
  802b92:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  802b99:	e9 b7 00 00 00       	jmp    802c55 <free_block+0x229>
			struct BlockElement *blk = (struct BlockElement*)(page_va + off);
  802b9e:	8b 55 d8             	mov    -0x28(%ebp),%edx
  802ba1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ba4:	01 d0                	add    %edx,%eax
  802ba6:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			LIST_REMOVE(&freeBlockLists[idx], blk);
  802ba9:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  802bad:	75 17                	jne    802bc6 <free_block+0x19a>
  802baf:	83 ec 04             	sub    $0x4,%esp
  802bb2:	68 41 3b 80 00       	push   $0x803b41
  802bb7:	68 f8 00 00 00       	push   $0xf8
  802bbc:	68 83 3a 80 00       	push   $0x803a83
  802bc1:	e8 90 dd ff ff       	call   800956 <_panic>
  802bc6:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802bc9:	8b 00                	mov    (%eax),%eax
  802bcb:	85 c0                	test   %eax,%eax
  802bcd:	74 10                	je     802bdf <free_block+0x1b3>
  802bcf:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802bd2:	8b 00                	mov    (%eax),%eax
  802bd4:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  802bd7:	8b 52 04             	mov    0x4(%edx),%edx
  802bda:	89 50 04             	mov    %edx,0x4(%eax)
  802bdd:	eb 14                	jmp    802bf3 <free_block+0x1c7>
  802bdf:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802be2:	8b 40 04             	mov    0x4(%eax),%eax
  802be5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802be8:	c1 e2 04             	shl    $0x4,%edx
  802beb:	81 c2 84 c0 81 00    	add    $0x81c084,%edx
  802bf1:	89 02                	mov    %eax,(%edx)
  802bf3:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802bf6:	8b 40 04             	mov    0x4(%eax),%eax
  802bf9:	85 c0                	test   %eax,%eax
  802bfb:	74 0f                	je     802c0c <free_block+0x1e0>
  802bfd:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802c00:	8b 40 04             	mov    0x4(%eax),%eax
  802c03:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  802c06:	8b 12                	mov    (%edx),%edx
  802c08:	89 10                	mov    %edx,(%eax)
  802c0a:	eb 13                	jmp    802c1f <free_block+0x1f3>
  802c0c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802c0f:	8b 00                	mov    (%eax),%eax
  802c11:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802c14:	c1 e2 04             	shl    $0x4,%edx
  802c17:	81 c2 80 c0 81 00    	add    $0x81c080,%edx
  802c1d:	89 02                	mov    %eax,(%edx)
  802c1f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802c22:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802c28:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802c2b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802c32:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c35:	c1 e0 04             	shl    $0x4,%eax
  802c38:	05 8c c0 81 00       	add    $0x81c08c,%eax
  802c3d:	8b 00                	mov    (%eax),%eax
  802c3f:	8d 50 ff             	lea    -0x1(%eax),%edx
  802c42:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c45:	c1 e0 04             	shl    $0x4,%eax
  802c48:	05 8c c0 81 00       	add    $0x81c08c,%eax
  802c4d:	89 10                	mov    %edx,(%eax)
	int blk_count = PAGE_SIZE / blk_size;
	// the blk count in the page is same as number fo free blocks free up the page.
	if (pageInfo->num_of_free_blocks == blk_count) {
		uint32 page_va = to_page_va(pageInfo);
		// remove all blk in the freeBlockList.
		for (uint32 off = 0; off < PAGE_SIZE; off += blk_size) {
  802c4f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802c52:	01 45 ec             	add    %eax,-0x14(%ebp)
  802c55:	81 7d ec ff 0f 00 00 	cmpl   $0xfff,-0x14(%ebp)
  802c5c:	0f 86 3c ff ff ff    	jbe    802b9e <free_block+0x172>
			struct BlockElement *blk = (struct BlockElement*)(page_va + off);
			LIST_REMOVE(&freeBlockLists[idx], blk);
		}
		// reset page info.
		pageInfo->block_size = 0;
  802c62:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802c65:	66 c7 40 08 00 00    	movw   $0x0,0x8(%eax)
		pageInfo->num_of_free_blocks = 0;
  802c6b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802c6e:	66 c7 40 0a 00 00    	movw   $0x0,0xa(%eax)
		// add it to the available pages.
		LIST_INSERT_TAIL(&freePagesList, pageInfo);
  802c74:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  802c78:	75 17                	jne    802c91 <free_block+0x265>
  802c7a:	83 ec 04             	sub    $0x4,%esp
  802c7d:	68 fc 3a 80 00       	push   $0x803afc
  802c82:	68 fe 00 00 00       	push   $0xfe
  802c87:	68 83 3a 80 00       	push   $0x803a83
  802c8c:	e8 c5 dc ff ff       	call   800956 <_panic>
  802c91:	8b 15 4c 40 80 00    	mov    0x80404c,%edx
  802c97:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802c9a:	89 50 04             	mov    %edx,0x4(%eax)
  802c9d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802ca0:	8b 40 04             	mov    0x4(%eax),%eax
  802ca3:	85 c0                	test   %eax,%eax
  802ca5:	74 0c                	je     802cb3 <free_block+0x287>
  802ca7:	a1 4c 40 80 00       	mov    0x80404c,%eax
  802cac:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802caf:	89 10                	mov    %edx,(%eax)
  802cb1:	eb 08                	jmp    802cbb <free_block+0x28f>
  802cb3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802cb6:	a3 48 40 80 00       	mov    %eax,0x804048
  802cbb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802cbe:	a3 4c 40 80 00       	mov    %eax,0x80404c
  802cc3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802cc6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802ccc:	a1 54 40 80 00       	mov    0x804054,%eax
  802cd1:	40                   	inc    %eax
  802cd2:	a3 54 40 80 00       	mov    %eax,0x804054
		// make it available in memory.
		return_page((uint32 *)to_page_va(pageInfo));
  802cd7:	83 ec 0c             	sub    $0xc,%esp
  802cda:	ff 75 e4             	pushl  -0x1c(%ebp)
  802cdd:	e8 88 f5 ff ff       	call   80226a <to_page_va>
  802ce2:	83 c4 10             	add    $0x10,%esp
  802ce5:	83 ec 0c             	sub    $0xc,%esp
  802ce8:	50                   	push   %eax
  802ce9:	e8 b8 ee ff ff       	call   801ba6 <return_page>
  802cee:	83 c4 10             	add    $0x10,%esp
	}
	//panic("free_block() Not implemented yet");
}
  802cf1:	90                   	nop
  802cf2:	c9                   	leave  
  802cf3:	c3                   	ret    

00802cf4 <realloc_block>:

//===========================
// [1] REALLOCATE BLOCK:
//===========================
void *realloc_block(void* va, uint32 new_size)
{
  802cf4:	55                   	push   %ebp
  802cf5:	89 e5                	mov    %esp,%ebp
  802cf7:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.BONUS#2] KERNEL REALLOC - realloc_block
	//Your code is here
	//Comment the following line
	panic("realloc_block() Not implemented yet");
  802cfa:	83 ec 04             	sub    $0x4,%esp
  802cfd:	68 a8 3b 80 00       	push   $0x803ba8
  802d02:	68 11 01 00 00       	push   $0x111
  802d07:	68 83 3a 80 00       	push   $0x803a83
  802d0c:	e8 45 dc ff ff       	call   800956 <_panic>

00802d11 <create_semaphore>:
// User-level Semaphore

#include "inc/lib.h"

struct semaphore create_semaphore(char *semaphoreName, uint32 value)
{
  802d11:	55                   	push   %ebp
  802d12:	89 e5                	mov    %esp,%ebp
  802d14:	83 ec 08             	sub    $0x8,%esp
	panic("create_semaphore() is not implemented yet...!!");
  802d17:	83 ec 04             	sub    $0x4,%esp
  802d1a:	68 cc 3b 80 00       	push   $0x803bcc
  802d1f:	6a 07                	push   $0x7
  802d21:	68 fb 3b 80 00       	push   $0x803bfb
  802d26:	e8 2b dc ff ff       	call   800956 <_panic>

00802d2b <get_semaphore>:
}
struct semaphore get_semaphore(int32 ownerEnvID, char* semaphoreName)
{
  802d2b:	55                   	push   %ebp
  802d2c:	89 e5                	mov    %esp,%ebp
  802d2e:	83 ec 08             	sub    $0x8,%esp
	panic("get_semaphore() is not implemented yet...!!");
  802d31:	83 ec 04             	sub    $0x4,%esp
  802d34:	68 0c 3c 80 00       	push   $0x803c0c
  802d39:	6a 0b                	push   $0xb
  802d3b:	68 fb 3b 80 00       	push   $0x803bfb
  802d40:	e8 11 dc ff ff       	call   800956 <_panic>

00802d45 <wait_semaphore>:
}

void wait_semaphore(struct semaphore sem)
{
  802d45:	55                   	push   %ebp
  802d46:	89 e5                	mov    %esp,%ebp
  802d48:	83 ec 08             	sub    $0x8,%esp
	panic("wait_semaphore() is not implemented yet...!!");
  802d4b:	83 ec 04             	sub    $0x4,%esp
  802d4e:	68 38 3c 80 00       	push   $0x803c38
  802d53:	6a 10                	push   $0x10
  802d55:	68 fb 3b 80 00       	push   $0x803bfb
  802d5a:	e8 f7 db ff ff       	call   800956 <_panic>

00802d5f <signal_semaphore>:
}

void signal_semaphore(struct semaphore sem)
{
  802d5f:	55                   	push   %ebp
  802d60:	89 e5                	mov    %esp,%ebp
  802d62:	83 ec 08             	sub    $0x8,%esp
	panic("signal_semaphore() is not implemented yet...!!");
  802d65:	83 ec 04             	sub    $0x4,%esp
  802d68:	68 68 3c 80 00       	push   $0x803c68
  802d6d:	6a 15                	push   $0x15
  802d6f:	68 fb 3b 80 00       	push   $0x803bfb
  802d74:	e8 dd db ff ff       	call   800956 <_panic>

00802d79 <semaphore_count>:
}

int semaphore_count(struct semaphore sem)
{
  802d79:	55                   	push   %ebp
  802d7a:	89 e5                	mov    %esp,%ebp
	return sem.semdata->count;
  802d7c:	8b 45 08             	mov    0x8(%ebp),%eax
  802d7f:	8b 40 10             	mov    0x10(%eax),%eax
}
  802d82:	5d                   	pop    %ebp
  802d83:	c3                   	ret    

00802d84 <__udivdi3>:
  802d84:	55                   	push   %ebp
  802d85:	57                   	push   %edi
  802d86:	56                   	push   %esi
  802d87:	53                   	push   %ebx
  802d88:	83 ec 1c             	sub    $0x1c,%esp
  802d8b:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  802d8f:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  802d93:	8b 7c 24 38          	mov    0x38(%esp),%edi
  802d97:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802d9b:	89 ca                	mov    %ecx,%edx
  802d9d:	89 f8                	mov    %edi,%eax
  802d9f:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  802da3:	85 f6                	test   %esi,%esi
  802da5:	75 2d                	jne    802dd4 <__udivdi3+0x50>
  802da7:	39 cf                	cmp    %ecx,%edi
  802da9:	77 65                	ja     802e10 <__udivdi3+0x8c>
  802dab:	89 fd                	mov    %edi,%ebp
  802dad:	85 ff                	test   %edi,%edi
  802daf:	75 0b                	jne    802dbc <__udivdi3+0x38>
  802db1:	b8 01 00 00 00       	mov    $0x1,%eax
  802db6:	31 d2                	xor    %edx,%edx
  802db8:	f7 f7                	div    %edi
  802dba:	89 c5                	mov    %eax,%ebp
  802dbc:	31 d2                	xor    %edx,%edx
  802dbe:	89 c8                	mov    %ecx,%eax
  802dc0:	f7 f5                	div    %ebp
  802dc2:	89 c1                	mov    %eax,%ecx
  802dc4:	89 d8                	mov    %ebx,%eax
  802dc6:	f7 f5                	div    %ebp
  802dc8:	89 cf                	mov    %ecx,%edi
  802dca:	89 fa                	mov    %edi,%edx
  802dcc:	83 c4 1c             	add    $0x1c,%esp
  802dcf:	5b                   	pop    %ebx
  802dd0:	5e                   	pop    %esi
  802dd1:	5f                   	pop    %edi
  802dd2:	5d                   	pop    %ebp
  802dd3:	c3                   	ret    
  802dd4:	39 ce                	cmp    %ecx,%esi
  802dd6:	77 28                	ja     802e00 <__udivdi3+0x7c>
  802dd8:	0f bd fe             	bsr    %esi,%edi
  802ddb:	83 f7 1f             	xor    $0x1f,%edi
  802dde:	75 40                	jne    802e20 <__udivdi3+0x9c>
  802de0:	39 ce                	cmp    %ecx,%esi
  802de2:	72 0a                	jb     802dee <__udivdi3+0x6a>
  802de4:	3b 44 24 08          	cmp    0x8(%esp),%eax
  802de8:	0f 87 9e 00 00 00    	ja     802e8c <__udivdi3+0x108>
  802dee:	b8 01 00 00 00       	mov    $0x1,%eax
  802df3:	89 fa                	mov    %edi,%edx
  802df5:	83 c4 1c             	add    $0x1c,%esp
  802df8:	5b                   	pop    %ebx
  802df9:	5e                   	pop    %esi
  802dfa:	5f                   	pop    %edi
  802dfb:	5d                   	pop    %ebp
  802dfc:	c3                   	ret    
  802dfd:	8d 76 00             	lea    0x0(%esi),%esi
  802e00:	31 ff                	xor    %edi,%edi
  802e02:	31 c0                	xor    %eax,%eax
  802e04:	89 fa                	mov    %edi,%edx
  802e06:	83 c4 1c             	add    $0x1c,%esp
  802e09:	5b                   	pop    %ebx
  802e0a:	5e                   	pop    %esi
  802e0b:	5f                   	pop    %edi
  802e0c:	5d                   	pop    %ebp
  802e0d:	c3                   	ret    
  802e0e:	66 90                	xchg   %ax,%ax
  802e10:	89 d8                	mov    %ebx,%eax
  802e12:	f7 f7                	div    %edi
  802e14:	31 ff                	xor    %edi,%edi
  802e16:	89 fa                	mov    %edi,%edx
  802e18:	83 c4 1c             	add    $0x1c,%esp
  802e1b:	5b                   	pop    %ebx
  802e1c:	5e                   	pop    %esi
  802e1d:	5f                   	pop    %edi
  802e1e:	5d                   	pop    %ebp
  802e1f:	c3                   	ret    
  802e20:	bd 20 00 00 00       	mov    $0x20,%ebp
  802e25:	89 eb                	mov    %ebp,%ebx
  802e27:	29 fb                	sub    %edi,%ebx
  802e29:	89 f9                	mov    %edi,%ecx
  802e2b:	d3 e6                	shl    %cl,%esi
  802e2d:	89 c5                	mov    %eax,%ebp
  802e2f:	88 d9                	mov    %bl,%cl
  802e31:	d3 ed                	shr    %cl,%ebp
  802e33:	89 e9                	mov    %ebp,%ecx
  802e35:	09 f1                	or     %esi,%ecx
  802e37:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  802e3b:	89 f9                	mov    %edi,%ecx
  802e3d:	d3 e0                	shl    %cl,%eax
  802e3f:	89 c5                	mov    %eax,%ebp
  802e41:	89 d6                	mov    %edx,%esi
  802e43:	88 d9                	mov    %bl,%cl
  802e45:	d3 ee                	shr    %cl,%esi
  802e47:	89 f9                	mov    %edi,%ecx
  802e49:	d3 e2                	shl    %cl,%edx
  802e4b:	8b 44 24 08          	mov    0x8(%esp),%eax
  802e4f:	88 d9                	mov    %bl,%cl
  802e51:	d3 e8                	shr    %cl,%eax
  802e53:	09 c2                	or     %eax,%edx
  802e55:	89 d0                	mov    %edx,%eax
  802e57:	89 f2                	mov    %esi,%edx
  802e59:	f7 74 24 0c          	divl   0xc(%esp)
  802e5d:	89 d6                	mov    %edx,%esi
  802e5f:	89 c3                	mov    %eax,%ebx
  802e61:	f7 e5                	mul    %ebp
  802e63:	39 d6                	cmp    %edx,%esi
  802e65:	72 19                	jb     802e80 <__udivdi3+0xfc>
  802e67:	74 0b                	je     802e74 <__udivdi3+0xf0>
  802e69:	89 d8                	mov    %ebx,%eax
  802e6b:	31 ff                	xor    %edi,%edi
  802e6d:	e9 58 ff ff ff       	jmp    802dca <__udivdi3+0x46>
  802e72:	66 90                	xchg   %ax,%ax
  802e74:	8b 54 24 08          	mov    0x8(%esp),%edx
  802e78:	89 f9                	mov    %edi,%ecx
  802e7a:	d3 e2                	shl    %cl,%edx
  802e7c:	39 c2                	cmp    %eax,%edx
  802e7e:	73 e9                	jae    802e69 <__udivdi3+0xe5>
  802e80:	8d 43 ff             	lea    -0x1(%ebx),%eax
  802e83:	31 ff                	xor    %edi,%edi
  802e85:	e9 40 ff ff ff       	jmp    802dca <__udivdi3+0x46>
  802e8a:	66 90                	xchg   %ax,%ax
  802e8c:	31 c0                	xor    %eax,%eax
  802e8e:	e9 37 ff ff ff       	jmp    802dca <__udivdi3+0x46>
  802e93:	90                   	nop

00802e94 <__umoddi3>:
  802e94:	55                   	push   %ebp
  802e95:	57                   	push   %edi
  802e96:	56                   	push   %esi
  802e97:	53                   	push   %ebx
  802e98:	83 ec 1c             	sub    $0x1c,%esp
  802e9b:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  802e9f:	8b 74 24 34          	mov    0x34(%esp),%esi
  802ea3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  802ea7:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  802eab:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802eaf:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802eb3:	89 f3                	mov    %esi,%ebx
  802eb5:	89 fa                	mov    %edi,%edx
  802eb7:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  802ebb:	89 34 24             	mov    %esi,(%esp)
  802ebe:	85 c0                	test   %eax,%eax
  802ec0:	75 1a                	jne    802edc <__umoddi3+0x48>
  802ec2:	39 f7                	cmp    %esi,%edi
  802ec4:	0f 86 a2 00 00 00    	jbe    802f6c <__umoddi3+0xd8>
  802eca:	89 c8                	mov    %ecx,%eax
  802ecc:	89 f2                	mov    %esi,%edx
  802ece:	f7 f7                	div    %edi
  802ed0:	89 d0                	mov    %edx,%eax
  802ed2:	31 d2                	xor    %edx,%edx
  802ed4:	83 c4 1c             	add    $0x1c,%esp
  802ed7:	5b                   	pop    %ebx
  802ed8:	5e                   	pop    %esi
  802ed9:	5f                   	pop    %edi
  802eda:	5d                   	pop    %ebp
  802edb:	c3                   	ret    
  802edc:	39 f0                	cmp    %esi,%eax
  802ede:	0f 87 ac 00 00 00    	ja     802f90 <__umoddi3+0xfc>
  802ee4:	0f bd e8             	bsr    %eax,%ebp
  802ee7:	83 f5 1f             	xor    $0x1f,%ebp
  802eea:	0f 84 ac 00 00 00    	je     802f9c <__umoddi3+0x108>
  802ef0:	bf 20 00 00 00       	mov    $0x20,%edi
  802ef5:	29 ef                	sub    %ebp,%edi
  802ef7:	89 fe                	mov    %edi,%esi
  802ef9:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802efd:	89 e9                	mov    %ebp,%ecx
  802eff:	d3 e0                	shl    %cl,%eax
  802f01:	89 d7                	mov    %edx,%edi
  802f03:	89 f1                	mov    %esi,%ecx
  802f05:	d3 ef                	shr    %cl,%edi
  802f07:	09 c7                	or     %eax,%edi
  802f09:	89 e9                	mov    %ebp,%ecx
  802f0b:	d3 e2                	shl    %cl,%edx
  802f0d:	89 14 24             	mov    %edx,(%esp)
  802f10:	89 d8                	mov    %ebx,%eax
  802f12:	d3 e0                	shl    %cl,%eax
  802f14:	89 c2                	mov    %eax,%edx
  802f16:	8b 44 24 08          	mov    0x8(%esp),%eax
  802f1a:	d3 e0                	shl    %cl,%eax
  802f1c:	89 44 24 04          	mov    %eax,0x4(%esp)
  802f20:	8b 44 24 08          	mov    0x8(%esp),%eax
  802f24:	89 f1                	mov    %esi,%ecx
  802f26:	d3 e8                	shr    %cl,%eax
  802f28:	09 d0                	or     %edx,%eax
  802f2a:	d3 eb                	shr    %cl,%ebx
  802f2c:	89 da                	mov    %ebx,%edx
  802f2e:	f7 f7                	div    %edi
  802f30:	89 d3                	mov    %edx,%ebx
  802f32:	f7 24 24             	mull   (%esp)
  802f35:	89 c6                	mov    %eax,%esi
  802f37:	89 d1                	mov    %edx,%ecx
  802f39:	39 d3                	cmp    %edx,%ebx
  802f3b:	0f 82 87 00 00 00    	jb     802fc8 <__umoddi3+0x134>
  802f41:	0f 84 91 00 00 00    	je     802fd8 <__umoddi3+0x144>
  802f47:	8b 54 24 04          	mov    0x4(%esp),%edx
  802f4b:	29 f2                	sub    %esi,%edx
  802f4d:	19 cb                	sbb    %ecx,%ebx
  802f4f:	89 d8                	mov    %ebx,%eax
  802f51:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  802f55:	d3 e0                	shl    %cl,%eax
  802f57:	89 e9                	mov    %ebp,%ecx
  802f59:	d3 ea                	shr    %cl,%edx
  802f5b:	09 d0                	or     %edx,%eax
  802f5d:	89 e9                	mov    %ebp,%ecx
  802f5f:	d3 eb                	shr    %cl,%ebx
  802f61:	89 da                	mov    %ebx,%edx
  802f63:	83 c4 1c             	add    $0x1c,%esp
  802f66:	5b                   	pop    %ebx
  802f67:	5e                   	pop    %esi
  802f68:	5f                   	pop    %edi
  802f69:	5d                   	pop    %ebp
  802f6a:	c3                   	ret    
  802f6b:	90                   	nop
  802f6c:	89 fd                	mov    %edi,%ebp
  802f6e:	85 ff                	test   %edi,%edi
  802f70:	75 0b                	jne    802f7d <__umoddi3+0xe9>
  802f72:	b8 01 00 00 00       	mov    $0x1,%eax
  802f77:	31 d2                	xor    %edx,%edx
  802f79:	f7 f7                	div    %edi
  802f7b:	89 c5                	mov    %eax,%ebp
  802f7d:	89 f0                	mov    %esi,%eax
  802f7f:	31 d2                	xor    %edx,%edx
  802f81:	f7 f5                	div    %ebp
  802f83:	89 c8                	mov    %ecx,%eax
  802f85:	f7 f5                	div    %ebp
  802f87:	89 d0                	mov    %edx,%eax
  802f89:	e9 44 ff ff ff       	jmp    802ed2 <__umoddi3+0x3e>
  802f8e:	66 90                	xchg   %ax,%ax
  802f90:	89 c8                	mov    %ecx,%eax
  802f92:	89 f2                	mov    %esi,%edx
  802f94:	83 c4 1c             	add    $0x1c,%esp
  802f97:	5b                   	pop    %ebx
  802f98:	5e                   	pop    %esi
  802f99:	5f                   	pop    %edi
  802f9a:	5d                   	pop    %ebp
  802f9b:	c3                   	ret    
  802f9c:	3b 04 24             	cmp    (%esp),%eax
  802f9f:	72 06                	jb     802fa7 <__umoddi3+0x113>
  802fa1:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  802fa5:	77 0f                	ja     802fb6 <__umoddi3+0x122>
  802fa7:	89 f2                	mov    %esi,%edx
  802fa9:	29 f9                	sub    %edi,%ecx
  802fab:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  802faf:	89 14 24             	mov    %edx,(%esp)
  802fb2:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  802fb6:	8b 44 24 04          	mov    0x4(%esp),%eax
  802fba:	8b 14 24             	mov    (%esp),%edx
  802fbd:	83 c4 1c             	add    $0x1c,%esp
  802fc0:	5b                   	pop    %ebx
  802fc1:	5e                   	pop    %esi
  802fc2:	5f                   	pop    %edi
  802fc3:	5d                   	pop    %ebp
  802fc4:	c3                   	ret    
  802fc5:	8d 76 00             	lea    0x0(%esi),%esi
  802fc8:	2b 04 24             	sub    (%esp),%eax
  802fcb:	19 fa                	sbb    %edi,%edx
  802fcd:	89 d1                	mov    %edx,%ecx
  802fcf:	89 c6                	mov    %eax,%esi
  802fd1:	e9 71 ff ff ff       	jmp    802f47 <__umoddi3+0xb3>
  802fd6:	66 90                	xchg   %ax,%ax
  802fd8:	39 44 24 04          	cmp    %eax,0x4(%esp)
  802fdc:	72 ea                	jb     802fc8 <__umoddi3+0x134>
  802fde:	89 d9                	mov    %ebx,%ecx
  802fe0:	e9 62 ff ff ff       	jmp    802f47 <__umoddi3+0xb3>
