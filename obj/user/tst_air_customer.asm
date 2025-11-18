
obj/user/tst_air_customer:     file format elf32-i386


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
  800031:	e8 3a 06 00 00       	call   800670 <libmain>
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
  80003e:	81 ec 0c 02 00 00    	sub    $0x20c,%esp
	//disable the print of prog stats after finishing
	printStats = 0;
  800044:	c7 05 00 40 80 00 00 	movl   $0x0,0x804000
  80004b:	00 00 00 

	int32 parentenvID = sys_getparentenvid();
  80004e:	e8 5f 1c 00 00       	call   801cb2 <sys_getparentenvid>
  800053:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	char _agentCapacity[] = "agentCapacity";
  800056:	8d 45 a2             	lea    -0x5e(%ebp),%eax
  800059:	bb e9 2f 80 00       	mov    $0x802fe9,%ebx
  80005e:	ba 0e 00 00 00       	mov    $0xe,%edx
  800063:	89 c7                	mov    %eax,%edi
  800065:	89 de                	mov    %ebx,%esi
  800067:	89 d1                	mov    %edx,%ecx
  800069:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _customers[] = "customers";
  80006b:	8d 45 98             	lea    -0x68(%ebp),%eax
  80006e:	bb f7 2f 80 00       	mov    $0x802ff7,%ebx
  800073:	ba 0a 00 00 00       	mov    $0xa,%edx
  800078:	89 c7                	mov    %eax,%edi
  80007a:	89 de                	mov    %ebx,%esi
  80007c:	89 d1                	mov    %edx,%ecx
  80007e:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _custCounter[] = "custCounter";
  800080:	8d 45 8c             	lea    -0x74(%ebp),%eax
  800083:	bb 01 30 80 00       	mov    $0x803001,%ebx
  800088:	ba 03 00 00 00       	mov    $0x3,%edx
  80008d:	89 c7                	mov    %eax,%edi
  80008f:	89 de                	mov    %ebx,%esi
  800091:	89 d1                	mov    %edx,%ecx
  800093:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
	char _flight1Counter[] = "flight1Counter";
  800095:	8d 85 7d ff ff ff    	lea    -0x83(%ebp),%eax
  80009b:	bb 0d 30 80 00       	mov    $0x80300d,%ebx
  8000a0:	ba 0f 00 00 00       	mov    $0xf,%edx
  8000a5:	89 c7                	mov    %eax,%edi
  8000a7:	89 de                	mov    %ebx,%esi
  8000a9:	89 d1                	mov    %edx,%ecx
  8000ab:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _flight2Counter[] = "flight2Counter";
  8000ad:	8d 85 6e ff ff ff    	lea    -0x92(%ebp),%eax
  8000b3:	bb 1c 30 80 00       	mov    $0x80301c,%ebx
  8000b8:	ba 0f 00 00 00       	mov    $0xf,%edx
  8000bd:	89 c7                	mov    %eax,%edi
  8000bf:	89 de                	mov    %ebx,%esi
  8000c1:	89 d1                	mov    %edx,%ecx
  8000c3:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _flightBooked1Counter[] = "flightBooked1Counter";
  8000c5:	8d 85 59 ff ff ff    	lea    -0xa7(%ebp),%eax
  8000cb:	bb 2b 30 80 00       	mov    $0x80302b,%ebx
  8000d0:	ba 15 00 00 00       	mov    $0x15,%edx
  8000d5:	89 c7                	mov    %eax,%edi
  8000d7:	89 de                	mov    %ebx,%esi
  8000d9:	89 d1                	mov    %edx,%ecx
  8000db:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _flightBooked2Counter[] = "flightBooked2Counter";
  8000dd:	8d 85 44 ff ff ff    	lea    -0xbc(%ebp),%eax
  8000e3:	bb 40 30 80 00       	mov    $0x803040,%ebx
  8000e8:	ba 15 00 00 00       	mov    $0x15,%edx
  8000ed:	89 c7                	mov    %eax,%edi
  8000ef:	89 de                	mov    %ebx,%esi
  8000f1:	89 d1                	mov    %edx,%ecx
  8000f3:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _flightBooked1Arr[] = "flightBooked1Arr";
  8000f5:	8d 85 33 ff ff ff    	lea    -0xcd(%ebp),%eax
  8000fb:	bb 55 30 80 00       	mov    $0x803055,%ebx
  800100:	ba 11 00 00 00       	mov    $0x11,%edx
  800105:	89 c7                	mov    %eax,%edi
  800107:	89 de                	mov    %ebx,%esi
  800109:	89 d1                	mov    %edx,%ecx
  80010b:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _flightBooked2Arr[] = "flightBooked2Arr";
  80010d:	8d 85 22 ff ff ff    	lea    -0xde(%ebp),%eax
  800113:	bb 66 30 80 00       	mov    $0x803066,%ebx
  800118:	ba 11 00 00 00       	mov    $0x11,%edx
  80011d:	89 c7                	mov    %eax,%edi
  80011f:	89 de                	mov    %ebx,%esi
  800121:	89 d1                	mov    %edx,%ecx
  800123:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _cust_ready_queue[] = "cust_ready_queue";
  800125:	8d 85 11 ff ff ff    	lea    -0xef(%ebp),%eax
  80012b:	bb 77 30 80 00       	mov    $0x803077,%ebx
  800130:	ba 11 00 00 00       	mov    $0x11,%edx
  800135:	89 c7                	mov    %eax,%edi
  800137:	89 de                	mov    %ebx,%esi
  800139:	89 d1                	mov    %edx,%ecx
  80013b:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _queue_in[] = "queue_in";
  80013d:	8d 85 08 ff ff ff    	lea    -0xf8(%ebp),%eax
  800143:	bb 88 30 80 00       	mov    $0x803088,%ebx
  800148:	ba 09 00 00 00       	mov    $0x9,%edx
  80014d:	89 c7                	mov    %eax,%edi
  80014f:	89 de                	mov    %ebx,%esi
  800151:	89 d1                	mov    %edx,%ecx
  800153:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _queue_out[] = "queue_out";
  800155:	8d 85 fe fe ff ff    	lea    -0x102(%ebp),%eax
  80015b:	bb 91 30 80 00       	mov    $0x803091,%ebx
  800160:	ba 0a 00 00 00       	mov    $0xa,%edx
  800165:	89 c7                	mov    %eax,%edi
  800167:	89 de                	mov    %ebx,%esi
  800169:	89 d1                	mov    %edx,%ecx
  80016b:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)

	char _cust_ready[] = "cust_ready";
  80016d:	8d 85 f3 fe ff ff    	lea    -0x10d(%ebp),%eax
  800173:	bb 9b 30 80 00       	mov    $0x80309b,%ebx
  800178:	ba 0b 00 00 00       	mov    $0xb,%edx
  80017d:	89 c7                	mov    %eax,%edi
  80017f:	89 de                	mov    %ebx,%esi
  800181:	89 d1                	mov    %edx,%ecx
  800183:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _custQueueCS[] = "custQueueCS";
  800185:	8d 85 e7 fe ff ff    	lea    -0x119(%ebp),%eax
  80018b:	bb a6 30 80 00       	mov    $0x8030a6,%ebx
  800190:	ba 03 00 00 00       	mov    $0x3,%edx
  800195:	89 c7                	mov    %eax,%edi
  800197:	89 de                	mov    %ebx,%esi
  800199:	89 d1                	mov    %edx,%ecx
  80019b:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
	char _flight1CS[] = "flight1CS";
  80019d:	8d 85 dd fe ff ff    	lea    -0x123(%ebp),%eax
  8001a3:	bb b2 30 80 00       	mov    $0x8030b2,%ebx
  8001a8:	ba 0a 00 00 00       	mov    $0xa,%edx
  8001ad:	89 c7                	mov    %eax,%edi
  8001af:	89 de                	mov    %ebx,%esi
  8001b1:	89 d1                	mov    %edx,%ecx
  8001b3:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _flight2CS[] = "flight2CS";
  8001b5:	8d 85 d3 fe ff ff    	lea    -0x12d(%ebp),%eax
  8001bb:	bb bc 30 80 00       	mov    $0x8030bc,%ebx
  8001c0:	ba 0a 00 00 00       	mov    $0xa,%edx
  8001c5:	89 c7                	mov    %eax,%edi
  8001c7:	89 de                	mov    %ebx,%esi
  8001c9:	89 d1                	mov    %edx,%ecx
  8001cb:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)

	char _clerk[] = "clerk";
  8001cd:	c7 85 cd fe ff ff 63 	movl   $0x72656c63,-0x133(%ebp)
  8001d4:	6c 65 72 
  8001d7:	66 c7 85 d1 fe ff ff 	movw   $0x6b,-0x12f(%ebp)
  8001de:	6b 00 
	char _custCounterCS[] = "custCounterCS";
  8001e0:	8d 85 bf fe ff ff    	lea    -0x141(%ebp),%eax
  8001e6:	bb c6 30 80 00       	mov    $0x8030c6,%ebx
  8001eb:	ba 0e 00 00 00       	mov    $0xe,%edx
  8001f0:	89 c7                	mov    %eax,%edi
  8001f2:	89 de                	mov    %ebx,%esi
  8001f4:	89 d1                	mov    %edx,%ecx
  8001f6:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _custTerminated[] = "custTerminated";
  8001f8:	8d 85 b0 fe ff ff    	lea    -0x150(%ebp),%eax
  8001fe:	bb d4 30 80 00       	mov    $0x8030d4,%ebx
  800203:	ba 0f 00 00 00       	mov    $0xf,%edx
  800208:	89 c7                	mov    %eax,%edi
  80020a:	89 de                	mov    %ebx,%esi
  80020c:	89 d1                	mov    %edx,%ecx
  80020e:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)

	char _taircl[] = "taircl";
  800210:	8d 85 a9 fe ff ff    	lea    -0x157(%ebp),%eax
  800216:	bb e3 30 80 00       	mov    $0x8030e3,%ebx
  80021b:	ba 07 00 00 00       	mov    $0x7,%edx
  800220:	89 c7                	mov    %eax,%edi
  800222:	89 de                	mov    %ebx,%esi
  800224:	89 d1                	mov    %edx,%ecx
  800226:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _taircu[] = "taircu";
  800228:	8d 85 a2 fe ff ff    	lea    -0x15e(%ebp),%eax
  80022e:	bb ea 30 80 00       	mov    $0x8030ea,%ebx
  800233:	ba 07 00 00 00       	mov    $0x7,%edx
  800238:	89 c7                	mov    %eax,%edi
  80023a:	89 de                	mov    %ebx,%esi
  80023c:	89 d1                	mov    %edx,%ecx
  80023e:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)

	char _flight1Customers[] = "flight1Customers";
  800240:	8d 85 91 fe ff ff    	lea    -0x16f(%ebp),%eax
  800246:	bb f1 30 80 00       	mov    $0x8030f1,%ebx
  80024b:	ba 11 00 00 00       	mov    $0x11,%edx
  800250:	89 c7                	mov    %eax,%edi
  800252:	89 de                	mov    %ebx,%esi
  800254:	89 d1                	mov    %edx,%ecx
  800256:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _flight2Customers[] = "flight2Customers";
  800258:	8d 85 80 fe ff ff    	lea    -0x180(%ebp),%eax
  80025e:	bb 02 31 80 00       	mov    $0x803102,%ebx
  800263:	ba 11 00 00 00       	mov    $0x11,%edx
  800268:	89 c7                	mov    %eax,%edi
  80026a:	89 de                	mov    %ebx,%esi
  80026c:	89 d1                	mov    %edx,%ecx
  80026e:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _flight3Customers[] = "flight3Customers";
  800270:	8d 85 6f fe ff ff    	lea    -0x191(%ebp),%eax
  800276:	bb 13 31 80 00       	mov    $0x803113,%ebx
  80027b:	ba 11 00 00 00       	mov    $0x11,%edx
  800280:	89 c7                	mov    %eax,%edi
  800282:	89 de                	mov    %ebx,%esi
  800284:	89 d1                	mov    %edx,%ecx
  800286:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)

	// Get the shared variables from the main program ***********************************

	struct Customer * customers = sget(parentenvID, _customers);
  800288:	83 ec 08             	sub    $0x8,%esp
  80028b:	8d 45 98             	lea    -0x68(%ebp),%eax
  80028e:	50                   	push   %eax
  80028f:	ff 75 e4             	pushl  -0x1c(%ebp)
  800292:	e8 bc 16 00 00       	call   801953 <sget>
  800297:	83 c4 10             	add    $0x10,%esp
  80029a:	89 45 e0             	mov    %eax,-0x20(%ebp)

	int* custCounter = sget(parentenvID, _custCounter);
  80029d:	83 ec 08             	sub    $0x8,%esp
  8002a0:	8d 45 8c             	lea    -0x74(%ebp),%eax
  8002a3:	50                   	push   %eax
  8002a4:	ff 75 e4             	pushl  -0x1c(%ebp)
  8002a7:	e8 a7 16 00 00       	call   801953 <sget>
  8002ac:	83 c4 10             	add    $0x10,%esp
  8002af:	89 45 dc             	mov    %eax,-0x24(%ebp)

	int* cust_ready_queue = sget(parentenvID, _cust_ready_queue);
  8002b2:	83 ec 08             	sub    $0x8,%esp
  8002b5:	8d 85 11 ff ff ff    	lea    -0xef(%ebp),%eax
  8002bb:	50                   	push   %eax
  8002bc:	ff 75 e4             	pushl  -0x1c(%ebp)
  8002bf:	e8 8f 16 00 00       	call   801953 <sget>
  8002c4:	83 c4 10             	add    $0x10,%esp
  8002c7:	89 45 d8             	mov    %eax,-0x28(%ebp)

	int* queue_in = sget(parentenvID, _queue_in);
  8002ca:	83 ec 08             	sub    $0x8,%esp
  8002cd:	8d 85 08 ff ff ff    	lea    -0xf8(%ebp),%eax
  8002d3:	50                   	push   %eax
  8002d4:	ff 75 e4             	pushl  -0x1c(%ebp)
  8002d7:	e8 77 16 00 00       	call   801953 <sget>
  8002dc:	83 c4 10             	add    $0x10,%esp
  8002df:	89 45 d4             	mov    %eax,-0x2c(%ebp)

	int* flight1Customers = sget(parentenvID, _flight1Customers);
  8002e2:	83 ec 08             	sub    $0x8,%esp
  8002e5:	8d 85 91 fe ff ff    	lea    -0x16f(%ebp),%eax
  8002eb:	50                   	push   %eax
  8002ec:	ff 75 e4             	pushl  -0x1c(%ebp)
  8002ef:	e8 5f 16 00 00       	call   801953 <sget>
  8002f4:	83 c4 10             	add    $0x10,%esp
  8002f7:	89 45 d0             	mov    %eax,-0x30(%ebp)
	int* flight2Customers = sget(parentenvID, _flight2Customers);
  8002fa:	83 ec 08             	sub    $0x8,%esp
  8002fd:	8d 85 80 fe ff ff    	lea    -0x180(%ebp),%eax
  800303:	50                   	push   %eax
  800304:	ff 75 e4             	pushl  -0x1c(%ebp)
  800307:	e8 47 16 00 00       	call   801953 <sget>
  80030c:	83 c4 10             	add    $0x10,%esp
  80030f:	89 45 cc             	mov    %eax,-0x34(%ebp)
	int* flight3Customers = sget(parentenvID, _flight3Customers);
  800312:	83 ec 08             	sub    $0x8,%esp
  800315:	8d 85 6f fe ff ff    	lea    -0x191(%ebp),%eax
  80031b:	50                   	push   %eax
  80031c:	ff 75 e4             	pushl  -0x1c(%ebp)
  80031f:	e8 2f 16 00 00       	call   801953 <sget>
  800324:	83 c4 10             	add    $0x10,%esp
  800327:	89 45 c8             	mov    %eax,-0x38(%ebp)

	// Get the shared semaphores from the main program ***********************************

	struct semaphore capacity = get_semaphore(parentenvID, _agentCapacity);
  80032a:	8d 85 68 fe ff ff    	lea    -0x198(%ebp),%eax
  800330:	83 ec 04             	sub    $0x4,%esp
  800333:	8d 55 a2             	lea    -0x5e(%ebp),%edx
  800336:	52                   	push   %edx
  800337:	ff 75 e4             	pushl  -0x1c(%ebp)
  80033a:	50                   	push   %eax
  80033b:	e8 dc 26 00 00       	call   802a1c <get_semaphore>
  800340:	83 c4 0c             	add    $0xc,%esp
	struct semaphore custCounterCS = get_semaphore(parentenvID, _custCounterCS);
  800343:	8d 85 64 fe ff ff    	lea    -0x19c(%ebp),%eax
  800349:	83 ec 04             	sub    $0x4,%esp
  80034c:	8d 95 bf fe ff ff    	lea    -0x141(%ebp),%edx
  800352:	52                   	push   %edx
  800353:	ff 75 e4             	pushl  -0x1c(%ebp)
  800356:	50                   	push   %eax
  800357:	e8 c0 26 00 00       	call   802a1c <get_semaphore>
  80035c:	83 c4 0c             	add    $0xc,%esp
	struct semaphore clerk = get_semaphore(parentenvID, _clerk);
  80035f:	8d 85 60 fe ff ff    	lea    -0x1a0(%ebp),%eax
  800365:	83 ec 04             	sub    $0x4,%esp
  800368:	8d 95 cd fe ff ff    	lea    -0x133(%ebp),%edx
  80036e:	52                   	push   %edx
  80036f:	ff 75 e4             	pushl  -0x1c(%ebp)
  800372:	50                   	push   %eax
  800373:	e8 a4 26 00 00       	call   802a1c <get_semaphore>
  800378:	83 c4 0c             	add    $0xc,%esp
	struct semaphore custQueueCS = get_semaphore(parentenvID, _custQueueCS);
  80037b:	8d 85 5c fe ff ff    	lea    -0x1a4(%ebp),%eax
  800381:	83 ec 04             	sub    $0x4,%esp
  800384:	8d 95 e7 fe ff ff    	lea    -0x119(%ebp),%edx
  80038a:	52                   	push   %edx
  80038b:	ff 75 e4             	pushl  -0x1c(%ebp)
  80038e:	50                   	push   %eax
  80038f:	e8 88 26 00 00       	call   802a1c <get_semaphore>
  800394:	83 c4 0c             	add    $0xc,%esp
	struct semaphore cust_ready = get_semaphore(parentenvID, _cust_ready);
  800397:	8d 85 58 fe ff ff    	lea    -0x1a8(%ebp),%eax
  80039d:	83 ec 04             	sub    $0x4,%esp
  8003a0:	8d 95 f3 fe ff ff    	lea    -0x10d(%ebp),%edx
  8003a6:	52                   	push   %edx
  8003a7:	ff 75 e4             	pushl  -0x1c(%ebp)
  8003aa:	50                   	push   %eax
  8003ab:	e8 6c 26 00 00       	call   802a1c <get_semaphore>
  8003b0:	83 c4 0c             	add    $0xc,%esp
	struct semaphore custTerminated = get_semaphore(parentenvID, _custTerminated);
  8003b3:	8d 85 54 fe ff ff    	lea    -0x1ac(%ebp),%eax
  8003b9:	83 ec 04             	sub    $0x4,%esp
  8003bc:	8d 95 b0 fe ff ff    	lea    -0x150(%ebp),%edx
  8003c2:	52                   	push   %edx
  8003c3:	ff 75 e4             	pushl  -0x1c(%ebp)
  8003c6:	50                   	push   %eax
  8003c7:	e8 50 26 00 00       	call   802a1c <get_semaphore>
  8003cc:	83 c4 0c             	add    $0xc,%esp

	int custId, flightType;
	wait_semaphore(custCounterCS);
  8003cf:	83 ec 0c             	sub    $0xc,%esp
  8003d2:	ff b5 64 fe ff ff    	pushl  -0x19c(%ebp)
  8003d8:	e8 59 26 00 00       	call   802a36 <wait_semaphore>
  8003dd:	83 c4 10             	add    $0x10,%esp
	{
		custId = *custCounter;
  8003e0:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8003e3:	8b 00                	mov    (%eax),%eax
  8003e5:	89 45 c4             	mov    %eax,-0x3c(%ebp)
		//cprintf("custCounter= %d\n", *custCounter);
		*custCounter = *custCounter +1;
  8003e8:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8003eb:	8b 00                	mov    (%eax),%eax
  8003ed:	8d 50 01             	lea    0x1(%eax),%edx
  8003f0:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8003f3:	89 10                	mov    %edx,(%eax)

static inline __attribute__((always_inline)) struct uint64 get_virtual_time_user()
{
	struct uint64 result;

	__asm __volatile("rdtsc\n"
  8003f5:	0f 31                	rdtsc  
  8003f7:	89 85 44 fe ff ff    	mov    %eax,-0x1bc(%ebp)
  8003fd:	89 95 48 fe ff ff    	mov    %edx,-0x1b8(%ebp)
	: "=a" (result.low), "=d" (result.hi)
	);

	return result;
  800403:	8b 85 44 fe ff ff    	mov    -0x1bc(%ebp),%eax
  800409:	8b 95 48 fe ff ff    	mov    -0x1b8(%ebp),%edx
  80040f:	89 45 b0             	mov    %eax,-0x50(%ebp)
  800412:	89 55 b4             	mov    %edx,-0x4c(%ebp)
		repFlightSel:
		//get random flight
		flightType = RANDU(1, 4);
  800415:	8b 45 b0             	mov    -0x50(%ebp),%eax
  800418:	b9 03 00 00 00       	mov    $0x3,%ecx
  80041d:	ba 00 00 00 00       	mov    $0x0,%edx
  800422:	f7 f1                	div    %ecx
  800424:	89 d0                	mov    %edx,%eax
  800426:	40                   	inc    %eax
  800427:	89 45 c0             	mov    %eax,-0x40(%ebp)
		if(flightType == 1 && *flight1Customers > 0)		(*flight1Customers)--;
  80042a:	83 7d c0 01          	cmpl   $0x1,-0x40(%ebp)
  80042e:	75 18                	jne    800448 <_main+0x410>
  800430:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800433:	8b 00                	mov    (%eax),%eax
  800435:	85 c0                	test   %eax,%eax
  800437:	7e 0f                	jle    800448 <_main+0x410>
  800439:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80043c:	8b 00                	mov    (%eax),%eax
  80043e:	8d 50 ff             	lea    -0x1(%eax),%edx
  800441:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800444:	89 10                	mov    %edx,(%eax)
  800446:	eb 3a                	jmp    800482 <_main+0x44a>
		else if(flightType == 2 && *flight2Customers > 0)	(*flight2Customers)--;
  800448:	83 7d c0 02          	cmpl   $0x2,-0x40(%ebp)
  80044c:	75 18                	jne    800466 <_main+0x42e>
  80044e:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800451:	8b 00                	mov    (%eax),%eax
  800453:	85 c0                	test   %eax,%eax
  800455:	7e 0f                	jle    800466 <_main+0x42e>
  800457:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80045a:	8b 00                	mov    (%eax),%eax
  80045c:	8d 50 ff             	lea    -0x1(%eax),%edx
  80045f:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800462:	89 10                	mov    %edx,(%eax)
  800464:	eb 1c                	jmp    800482 <_main+0x44a>
		else if(flightType == 3 && *flight3Customers > 0)	(*flight3Customers)--;
  800466:	83 7d c0 03          	cmpl   $0x3,-0x40(%ebp)
  80046a:	75 89                	jne    8003f5 <_main+0x3bd>
  80046c:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80046f:	8b 00                	mov    (%eax),%eax
  800471:	85 c0                	test   %eax,%eax
  800473:	7e 80                	jle    8003f5 <_main+0x3bd>
  800475:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800478:	8b 00                	mov    (%eax),%eax
  80047a:	8d 50 ff             	lea    -0x1(%eax),%edx
  80047d:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800480:	89 10                	mov    %edx,(%eax)
		else goto repFlightSel;
	}
	signal_semaphore(custCounterCS);
  800482:	83 ec 0c             	sub    $0xc,%esp
  800485:	ff b5 64 fe ff ff    	pushl  -0x19c(%ebp)
  80048b:	e8 c0 25 00 00       	call   802a50 <signal_semaphore>
  800490:	83 c4 10             	add    $0x10,%esp

static inline __attribute__((always_inline)) struct uint64 get_virtual_time_user()
{
	struct uint64 result;

	__asm __volatile("rdtsc\n"
  800493:	0f 31                	rdtsc  
  800495:	89 85 4c fe ff ff    	mov    %eax,-0x1b4(%ebp)
  80049b:	89 95 50 fe ff ff    	mov    %edx,-0x1b0(%ebp)
	: "=a" (result.low), "=d" (result.hi)
	);

	return result;
  8004a1:	8b 85 4c fe ff ff    	mov    -0x1b4(%ebp),%eax
  8004a7:	8b 95 50 fe ff ff    	mov    -0x1b0(%ebp),%edx
  8004ad:	89 45 b8             	mov    %eax,-0x48(%ebp)
  8004b0:	89 55 bc             	mov    %edx,-0x44(%ebp)

	//delay for a random time
	env_sleep(RANDU(100, 10000));
  8004b3:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8004b6:	b9 ac 26 00 00       	mov    $0x26ac,%ecx
  8004bb:	ba 00 00 00 00       	mov    $0x0,%edx
  8004c0:	f7 f1                	div    %ecx
  8004c2:	89 d0                	mov    %edx,%eax
  8004c4:	83 c0 64             	add    $0x64,%eax
  8004c7:	83 ec 0c             	sub    $0xc,%esp
  8004ca:	50                   	push   %eax
  8004cb:	e8 a5 25 00 00       	call   802a75 <env_sleep>
  8004d0:	83 c4 10             	add    $0x10,%esp

	//enter the agent if there's a space
	wait_semaphore(capacity);
  8004d3:	83 ec 0c             	sub    $0xc,%esp
  8004d6:	ff b5 68 fe ff ff    	pushl  -0x198(%ebp)
  8004dc:	e8 55 25 00 00       	call   802a36 <wait_semaphore>
  8004e1:	83 c4 10             	add    $0x10,%esp
	{
		//wait on one of the clerks
		wait_semaphore(clerk);
  8004e4:	83 ec 0c             	sub    $0xc,%esp
  8004e7:	ff b5 60 fe ff ff    	pushl  -0x1a0(%ebp)
  8004ed:	e8 44 25 00 00       	call   802a36 <wait_semaphore>
  8004f2:	83 c4 10             	add    $0x10,%esp

		//enqueue the request
		customers[custId].booked = 0 ;
  8004f5:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8004f8:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  8004ff:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800502:	01 d0                	add    %edx,%eax
  800504:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
		customers[custId].flightType = flightType ;
  80050b:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  80050e:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  800515:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800518:	01 c2                	add    %eax,%edx
  80051a:	8b 45 c0             	mov    -0x40(%ebp),%eax
  80051d:	89 02                	mov    %eax,(%edx)
		wait_semaphore(custQueueCS);
  80051f:	83 ec 0c             	sub    $0xc,%esp
  800522:	ff b5 5c fe ff ff    	pushl  -0x1a4(%ebp)
  800528:	e8 09 25 00 00       	call   802a36 <wait_semaphore>
  80052d:	83 c4 10             	add    $0x10,%esp
		{
			cust_ready_queue[*queue_in] = custId;
  800530:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800533:	8b 00                	mov    (%eax),%eax
  800535:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80053c:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80053f:	01 c2                	add    %eax,%edx
  800541:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  800544:	89 02                	mov    %eax,(%edx)
			*queue_in = *queue_in +1;
  800546:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800549:	8b 00                	mov    (%eax),%eax
  80054b:	8d 50 01             	lea    0x1(%eax),%edx
  80054e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800551:	89 10                	mov    %edx,(%eax)
		}
		signal_semaphore(custQueueCS);
  800553:	83 ec 0c             	sub    $0xc,%esp
  800556:	ff b5 5c fe ff ff    	pushl  -0x1a4(%ebp)
  80055c:	e8 ef 24 00 00       	call   802a50 <signal_semaphore>
  800561:	83 c4 10             	add    $0x10,%esp

		//signal ready
		signal_semaphore(cust_ready);
  800564:	83 ec 0c             	sub    $0xc,%esp
  800567:	ff b5 58 fe ff ff    	pushl  -0x1a8(%ebp)
  80056d:	e8 de 24 00 00       	call   802a50 <signal_semaphore>
  800572:	83 c4 10             	add    $0x10,%esp

		//wait on finished
		char prefix[30]="cust_finished";
  800575:	8d 85 26 fe ff ff    	lea    -0x1da(%ebp),%eax
  80057b:	bb 24 31 80 00       	mov    $0x803124,%ebx
  800580:	ba 0e 00 00 00       	mov    $0xe,%edx
  800585:	89 c7                	mov    %eax,%edi
  800587:	89 de                	mov    %ebx,%esi
  800589:	89 d1                	mov    %edx,%ecx
  80058b:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  80058d:	8d 95 34 fe ff ff    	lea    -0x1cc(%ebp),%edx
  800593:	b9 04 00 00 00       	mov    $0x4,%ecx
  800598:	b8 00 00 00 00       	mov    $0x0,%eax
  80059d:	89 d7                	mov    %edx,%edi
  80059f:	f3 ab                	rep stos %eax,%es:(%edi)
		char id[5]; char sname[50];
		ltostr(custId, id);
  8005a1:	83 ec 08             	sub    $0x8,%esp
  8005a4:	8d 85 21 fe ff ff    	lea    -0x1df(%ebp),%eax
  8005aa:	50                   	push   %eax
  8005ab:	ff 75 c4             	pushl  -0x3c(%ebp)
  8005ae:	e8 90 0f 00 00       	call   801543 <ltostr>
  8005b3:	83 c4 10             	add    $0x10,%esp
		strcconcat(prefix, id, sname);
  8005b6:	83 ec 04             	sub    $0x4,%esp
  8005b9:	8d 85 ea fd ff ff    	lea    -0x216(%ebp),%eax
  8005bf:	50                   	push   %eax
  8005c0:	8d 85 21 fe ff ff    	lea    -0x1df(%ebp),%eax
  8005c6:	50                   	push   %eax
  8005c7:	8d 85 26 fe ff ff    	lea    -0x1da(%ebp),%eax
  8005cd:	50                   	push   %eax
  8005ce:	e8 49 10 00 00       	call   80161c <strcconcat>
  8005d3:	83 c4 10             	add    $0x10,%esp
		//sys_waitSemaphore(parentenvID, sname);
		struct semaphore cust_finished = get_semaphore(parentenvID, sname);
  8005d6:	8d 85 1c fe ff ff    	lea    -0x1e4(%ebp),%eax
  8005dc:	83 ec 04             	sub    $0x4,%esp
  8005df:	8d 95 ea fd ff ff    	lea    -0x216(%ebp),%edx
  8005e5:	52                   	push   %edx
  8005e6:	ff 75 e4             	pushl  -0x1c(%ebp)
  8005e9:	50                   	push   %eax
  8005ea:	e8 2d 24 00 00       	call   802a1c <get_semaphore>
  8005ef:	83 c4 0c             	add    $0xc,%esp
		wait_semaphore(cust_finished);
  8005f2:	83 ec 0c             	sub    $0xc,%esp
  8005f5:	ff b5 1c fe ff ff    	pushl  -0x1e4(%ebp)
  8005fb:	e8 36 24 00 00       	call   802a36 <wait_semaphore>
  800600:	83 c4 10             	add    $0x10,%esp

		//print the customer status
		if(customers[custId].booked == 1)
  800603:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  800606:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  80060d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800610:	01 d0                	add    %edx,%eax
  800612:	8b 40 04             	mov    0x4(%eax),%eax
  800615:	83 f8 01             	cmp    $0x1,%eax
  800618:	75 18                	jne    800632 <_main+0x5fa>
		{
			cprintf("cust %d: finished (BOOKED flight %d) \n", custId, flightType);
  80061a:	83 ec 04             	sub    $0x4,%esp
  80061d:	ff 75 c0             	pushl  -0x40(%ebp)
  800620:	ff 75 c4             	pushl  -0x3c(%ebp)
  800623:	68 a0 2f 80 00       	push   $0x802fa0
  800628:	e8 e8 02 00 00       	call   800915 <cprintf>
  80062d:	83 c4 10             	add    $0x10,%esp
  800630:	eb 13                	jmp    800645 <_main+0x60d>
		}
		else
		{
			cprintf("cust %d: finished (NOT BOOKED) \n", custId);
  800632:	83 ec 08             	sub    $0x8,%esp
  800635:	ff 75 c4             	pushl  -0x3c(%ebp)
  800638:	68 c8 2f 80 00       	push   $0x802fc8
  80063d:	e8 d3 02 00 00       	call   800915 <cprintf>
  800642:	83 c4 10             	add    $0x10,%esp
		}
	}
	//exit the agent
	signal_semaphore(capacity);
  800645:	83 ec 0c             	sub    $0xc,%esp
  800648:	ff b5 68 fe ff ff    	pushl  -0x198(%ebp)
  80064e:	e8 fd 23 00 00       	call   802a50 <signal_semaphore>
  800653:	83 c4 10             	add    $0x10,%esp

	//customer is terminated
	signal_semaphore(custTerminated);
  800656:	83 ec 0c             	sub    $0xc,%esp
  800659:	ff b5 54 fe ff ff    	pushl  -0x1ac(%ebp)
  80065f:	e8 ec 23 00 00       	call   802a50 <signal_semaphore>
  800664:	83 c4 10             	add    $0x10,%esp

	return;
  800667:	90                   	nop
}
  800668:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80066b:	5b                   	pop    %ebx
  80066c:	5e                   	pop    %esi
  80066d:	5f                   	pop    %edi
  80066e:	5d                   	pop    %ebp
  80066f:	c3                   	ret    

00800670 <libmain>:
volatile bool printStats = 1;

volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";
void
libmain(int argc, char **argv)
{
  800670:	55                   	push   %ebp
  800671:	89 e5                	mov    %esp,%ebp
  800673:	57                   	push   %edi
  800674:	56                   	push   %esi
  800675:	53                   	push   %ebx
  800676:	83 ec 7c             	sub    $0x7c,%esp
	//printStats = 1;
	int envIndex = sys_getenvindex();
  800679:	e8 1b 16 00 00       	call   801c99 <sys_getenvindex>
  80067e:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	myEnv = &(envs[envIndex]);
  800681:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800684:	89 d0                	mov    %edx,%eax
  800686:	c1 e0 06             	shl    $0x6,%eax
  800689:	29 d0                	sub    %edx,%eax
  80068b:	c1 e0 02             	shl    $0x2,%eax
  80068e:	01 d0                	add    %edx,%eax
  800690:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800697:	01 c8                	add    %ecx,%eax
  800699:	c1 e0 03             	shl    $0x3,%eax
  80069c:	01 d0                	add    %edx,%eax
  80069e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8006a5:	29 c2                	sub    %eax,%edx
  8006a7:	8d 04 95 00 00 00 00 	lea    0x0(,%edx,4),%eax
  8006ae:	89 c2                	mov    %eax,%edx
  8006b0:	8d 82 00 00 c0 ee    	lea    -0x11400000(%edx),%eax
  8006b6:	a3 20 40 80 00       	mov    %eax,0x804020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  8006bb:	a1 20 40 80 00       	mov    0x804020,%eax
  8006c0:	8a 40 20             	mov    0x20(%eax),%al
  8006c3:	84 c0                	test   %al,%al
  8006c5:	74 0d                	je     8006d4 <libmain+0x64>
		binaryname = myEnv->prog_name;
  8006c7:	a1 20 40 80 00       	mov    0x804020,%eax
  8006cc:	83 c0 20             	add    $0x20,%eax
  8006cf:	a3 04 40 80 00       	mov    %eax,0x804004

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8006d4:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8006d8:	7e 0a                	jle    8006e4 <libmain+0x74>
		binaryname = argv[0];
  8006da:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006dd:	8b 00                	mov    (%eax),%eax
  8006df:	a3 04 40 80 00       	mov    %eax,0x804004

	// call user main routine
	_main(argc, argv);
  8006e4:	83 ec 08             	sub    $0x8,%esp
  8006e7:	ff 75 0c             	pushl  0xc(%ebp)
  8006ea:	ff 75 08             	pushl  0x8(%ebp)
  8006ed:	e8 46 f9 ff ff       	call   800038 <_main>
  8006f2:	83 c4 10             	add    $0x10,%esp

	if (printStats)
  8006f5:	a1 00 40 80 00       	mov    0x804000,%eax
  8006fa:	85 c0                	test   %eax,%eax
  8006fc:	0f 84 01 01 00 00    	je     800803 <libmain+0x193>
	{
		char isOPTReplCmd[100] = "__IsOPTRepl__" ;
  800702:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  800708:	bb 3c 32 80 00       	mov    $0x80323c,%ebx
  80070d:	ba 0e 00 00 00       	mov    $0xe,%edx
  800712:	89 c7                	mov    %eax,%edi
  800714:	89 de                	mov    %ebx,%esi
  800716:	89 d1                	mov    %edx,%ecx
  800718:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  80071a:	8d 55 8a             	lea    -0x76(%ebp),%edx
  80071d:	b9 56 00 00 00       	mov    $0x56,%ecx
  800722:	b0 00                	mov    $0x0,%al
  800724:	89 d7                	mov    %edx,%edi
  800726:	f3 aa                	rep stos %al,%es:(%edi)
		int isOPTRepl = 0;
  800728:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
		sys_utilities(isOPTReplCmd, (uint32)(&isOPTRepl));
  80072f:	8d 45 e0             	lea    -0x20(%ebp),%eax
  800732:	83 ec 08             	sub    $0x8,%esp
  800735:	50                   	push   %eax
  800736:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  80073c:	50                   	push   %eax
  80073d:	e8 8d 17 00 00       	call   801ecf <sys_utilities>
  800742:	83 c4 10             	add    $0x10,%esp

		sys_lock_cons();
  800745:	e8 d6 12 00 00       	call   801a20 <sys_lock_cons>
		{
			cprintf("**************************************\n");
  80074a:	83 ec 0c             	sub    $0xc,%esp
  80074d:	68 5c 31 80 00       	push   $0x80315c
  800752:	e8 be 01 00 00       	call   800915 <cprintf>
  800757:	83 c4 10             	add    $0x10,%esp
			if (isOPTRepl)
  80075a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80075d:	85 c0                	test   %eax,%eax
  80075f:	74 18                	je     800779 <libmain+0x109>
			{
				cprintf("OPTIMAL number of page faults = %d\n", sys_get_optimal_num_faults());
  800761:	e8 87 17 00 00       	call   801eed <sys_get_optimal_num_faults>
  800766:	83 ec 08             	sub    $0x8,%esp
  800769:	50                   	push   %eax
  80076a:	68 84 31 80 00       	push   $0x803184
  80076f:	e8 a1 01 00 00       	call   800915 <cprintf>
  800774:	83 c4 10             	add    $0x10,%esp
  800777:	eb 59                	jmp    8007d2 <libmain+0x162>
			}
			else
			{
				cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  800779:	a1 20 40 80 00       	mov    0x804020,%eax
  80077e:	8b 90 50 da 01 00    	mov    0x1da50(%eax),%edx
  800784:	a1 20 40 80 00       	mov    0x804020,%eax
  800789:	8b 80 40 da 01 00    	mov    0x1da40(%eax),%eax
  80078f:	83 ec 04             	sub    $0x4,%esp
  800792:	52                   	push   %edx
  800793:	50                   	push   %eax
  800794:	68 a8 31 80 00       	push   $0x8031a8
  800799:	e8 77 01 00 00       	call   800915 <cprintf>
  80079e:	83 c4 10             	add    $0x10,%esp
				cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  8007a1:	a1 20 40 80 00       	mov    0x804020,%eax
  8007a6:	8b 88 64 da 01 00    	mov    0x1da64(%eax),%ecx
  8007ac:	a1 20 40 80 00       	mov    0x804020,%eax
  8007b1:	8b 90 60 da 01 00    	mov    0x1da60(%eax),%edx
  8007b7:	a1 20 40 80 00       	mov    0x804020,%eax
  8007bc:	8b 80 5c da 01 00    	mov    0x1da5c(%eax),%eax
  8007c2:	51                   	push   %ecx
  8007c3:	52                   	push   %edx
  8007c4:	50                   	push   %eax
  8007c5:	68 d0 31 80 00       	push   $0x8031d0
  8007ca:	e8 46 01 00 00       	call   800915 <cprintf>
  8007cf:	83 c4 10             	add    $0x10,%esp
			}
			//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
			cprintf("Num of clocks = %d\n", myEnv->nClocks);
  8007d2:	a1 20 40 80 00       	mov    0x804020,%eax
  8007d7:	8b 80 68 da 01 00    	mov    0x1da68(%eax),%eax
  8007dd:	83 ec 08             	sub    $0x8,%esp
  8007e0:	50                   	push   %eax
  8007e1:	68 28 32 80 00       	push   $0x803228
  8007e6:	e8 2a 01 00 00       	call   800915 <cprintf>
  8007eb:	83 c4 10             	add    $0x10,%esp
			cprintf("**************************************\n");
  8007ee:	83 ec 0c             	sub    $0xc,%esp
  8007f1:	68 5c 31 80 00       	push   $0x80315c
  8007f6:	e8 1a 01 00 00       	call   800915 <cprintf>
  8007fb:	83 c4 10             	add    $0x10,%esp
		}
		sys_unlock_cons();
  8007fe:	e8 37 12 00 00       	call   801a3a <sys_unlock_cons>
	}

	// exit gracefully
	exit();
  800803:	e8 1f 00 00 00       	call   800827 <exit>
}
  800808:	90                   	nop
  800809:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80080c:	5b                   	pop    %ebx
  80080d:	5e                   	pop    %esi
  80080e:	5f                   	pop    %edi
  80080f:	5d                   	pop    %ebp
  800810:	c3                   	ret    

00800811 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800811:	55                   	push   %ebp
  800812:	89 e5                	mov    %esp,%ebp
  800814:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800817:	83 ec 0c             	sub    $0xc,%esp
  80081a:	6a 00                	push   $0x0
  80081c:	e8 44 14 00 00       	call   801c65 <sys_destroy_env>
  800821:	83 c4 10             	add    $0x10,%esp
}
  800824:	90                   	nop
  800825:	c9                   	leave  
  800826:	c3                   	ret    

00800827 <exit>:

void
exit(void)
{
  800827:	55                   	push   %ebp
  800828:	89 e5                	mov    %esp,%ebp
  80082a:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  80082d:	e8 99 14 00 00       	call   801ccb <sys_exit_env>
}
  800832:	90                   	nop
  800833:	c9                   	leave  
  800834:	c3                   	ret    

00800835 <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  800835:	55                   	push   %ebp
  800836:	89 e5                	mov    %esp,%ebp
  800838:	53                   	push   %ebx
  800839:	83 ec 04             	sub    $0x4,%esp
	b->buf[b->idx++] = ch;
  80083c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80083f:	8b 00                	mov    (%eax),%eax
  800841:	8d 48 01             	lea    0x1(%eax),%ecx
  800844:	8b 55 0c             	mov    0xc(%ebp),%edx
  800847:	89 0a                	mov    %ecx,(%edx)
  800849:	8b 55 08             	mov    0x8(%ebp),%edx
  80084c:	88 d1                	mov    %dl,%cl
  80084e:	8b 55 0c             	mov    0xc(%ebp),%edx
  800851:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800855:	8b 45 0c             	mov    0xc(%ebp),%eax
  800858:	8b 00                	mov    (%eax),%eax
  80085a:	3d ff 00 00 00       	cmp    $0xff,%eax
  80085f:	75 30                	jne    800891 <putch+0x5c>
		sys_cputs(b->buf, b->idx, printProgName, curTextClr);
  800861:	8b 15 18 c1 81 00    	mov    0x81c118,%edx
  800867:	a0 44 40 80 00       	mov    0x804044,%al
  80086c:	0f b6 c0             	movzbl %al,%eax
  80086f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800872:	8b 09                	mov    (%ecx),%ecx
  800874:	89 cb                	mov    %ecx,%ebx
  800876:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800879:	83 c1 08             	add    $0x8,%ecx
  80087c:	52                   	push   %edx
  80087d:	50                   	push   %eax
  80087e:	53                   	push   %ebx
  80087f:	51                   	push   %ecx
  800880:	e8 57 11 00 00       	call   8019dc <sys_cputs>
  800885:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800888:	8b 45 0c             	mov    0xc(%ebp),%eax
  80088b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800891:	8b 45 0c             	mov    0xc(%ebp),%eax
  800894:	8b 40 04             	mov    0x4(%eax),%eax
  800897:	8d 50 01             	lea    0x1(%eax),%edx
  80089a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80089d:	89 50 04             	mov    %edx,0x4(%eax)
}
  8008a0:	90                   	nop
  8008a1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8008a4:	c9                   	leave  
  8008a5:	c3                   	ret    

008008a6 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  8008a6:	55                   	push   %ebp
  8008a7:	89 e5                	mov    %esp,%ebp
  8008a9:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8008af:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8008b6:	00 00 00 
	b.cnt = 0;
  8008b9:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8008c0:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  8008c3:	ff 75 0c             	pushl  0xc(%ebp)
  8008c6:	ff 75 08             	pushl  0x8(%ebp)
  8008c9:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8008cf:	50                   	push   %eax
  8008d0:	68 35 08 80 00       	push   $0x800835
  8008d5:	e8 5a 02 00 00       	call   800b34 <vprintfmt>
  8008da:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName, curTextClr);
  8008dd:	8b 15 18 c1 81 00    	mov    0x81c118,%edx
  8008e3:	a0 44 40 80 00       	mov    0x804044,%al
  8008e8:	0f b6 c0             	movzbl %al,%eax
  8008eb:	8b 8d f0 fe ff ff    	mov    -0x110(%ebp),%ecx
  8008f1:	52                   	push   %edx
  8008f2:	50                   	push   %eax
  8008f3:	51                   	push   %ecx
  8008f4:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8008fa:	83 c0 08             	add    $0x8,%eax
  8008fd:	50                   	push   %eax
  8008fe:	e8 d9 10 00 00       	call   8019dc <sys_cputs>
  800903:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800906:	c6 05 44 40 80 00 00 	movb   $0x0,0x804044
	return b.cnt;
  80090d:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800913:	c9                   	leave  
  800914:	c3                   	ret    

00800915 <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  800915:	55                   	push   %ebp
  800916:	89 e5                	mov    %esp,%ebp
  800918:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  80091b:	c6 05 44 40 80 00 01 	movb   $0x1,0x804044
	va_start(ap, fmt);
  800922:	8d 45 0c             	lea    0xc(%ebp),%eax
  800925:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800928:	8b 45 08             	mov    0x8(%ebp),%eax
  80092b:	83 ec 08             	sub    $0x8,%esp
  80092e:	ff 75 f4             	pushl  -0xc(%ebp)
  800931:	50                   	push   %eax
  800932:	e8 6f ff ff ff       	call   8008a6 <vcprintf>
  800937:	83 c4 10             	add    $0x10,%esp
  80093a:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  80093d:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800940:	c9                   	leave  
  800941:	c3                   	ret    

00800942 <cprintf_colored>:

// *************** This text coloring feature is implemented by *************
// ********** Abd-Alrahman Zedan From Team Frozen-Bytes - FCIS'24-25 ********
int cprintf_colored(int textClr, const char *fmt, ...) {
  800942:	55                   	push   %ebp
  800943:	89 e5                	mov    %esp,%ebp
  800945:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800948:	c6 05 44 40 80 00 01 	movb   $0x1,0x804044
	curTextClr = (textClr << 8) ; //set text color by the given value
  80094f:	8b 45 08             	mov    0x8(%ebp),%eax
  800952:	c1 e0 08             	shl    $0x8,%eax
  800955:	a3 18 c1 81 00       	mov    %eax,0x81c118
	va_start(ap, fmt);
  80095a:	8d 45 0c             	lea    0xc(%ebp),%eax
  80095d:	83 c0 04             	add    $0x4,%eax
  800960:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800963:	8b 45 0c             	mov    0xc(%ebp),%eax
  800966:	83 ec 08             	sub    $0x8,%esp
  800969:	ff 75 f4             	pushl  -0xc(%ebp)
  80096c:	50                   	push   %eax
  80096d:	e8 34 ff ff ff       	call   8008a6 <vcprintf>
  800972:	83 c4 10             	add    $0x10,%esp
  800975:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);
	curTextClr = TEXT_DEFAULT_CLR; //restore default color
  800978:	c7 05 18 c1 81 00 00 	movl   $0x700,0x81c118
  80097f:	07 00 00 

	return cnt;
  800982:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800985:	c9                   	leave  
  800986:	c3                   	ret    

00800987 <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  800987:	55                   	push   %ebp
  800988:	89 e5                	mov    %esp,%ebp
  80098a:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  80098d:	e8 8e 10 00 00       	call   801a20 <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  800992:	8d 45 0c             	lea    0xc(%ebp),%eax
  800995:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  800998:	8b 45 08             	mov    0x8(%ebp),%eax
  80099b:	83 ec 08             	sub    $0x8,%esp
  80099e:	ff 75 f4             	pushl  -0xc(%ebp)
  8009a1:	50                   	push   %eax
  8009a2:	e8 ff fe ff ff       	call   8008a6 <vcprintf>
  8009a7:	83 c4 10             	add    $0x10,%esp
  8009aa:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  8009ad:	e8 88 10 00 00       	call   801a3a <sys_unlock_cons>
	return cnt;
  8009b2:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8009b5:	c9                   	leave  
  8009b6:	c3                   	ret    

008009b7 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8009b7:	55                   	push   %ebp
  8009b8:	89 e5                	mov    %esp,%ebp
  8009ba:	53                   	push   %ebx
  8009bb:	83 ec 14             	sub    $0x14,%esp
  8009be:	8b 45 10             	mov    0x10(%ebp),%eax
  8009c1:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8009c4:	8b 45 14             	mov    0x14(%ebp),%eax
  8009c7:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8009ca:	8b 45 18             	mov    0x18(%ebp),%eax
  8009cd:	ba 00 00 00 00       	mov    $0x0,%edx
  8009d2:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8009d5:	77 55                	ja     800a2c <printnum+0x75>
  8009d7:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8009da:	72 05                	jb     8009e1 <printnum+0x2a>
  8009dc:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8009df:	77 4b                	ja     800a2c <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8009e1:	8b 45 1c             	mov    0x1c(%ebp),%eax
  8009e4:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8009e7:	8b 45 18             	mov    0x18(%ebp),%eax
  8009ea:	ba 00 00 00 00       	mov    $0x0,%edx
  8009ef:	52                   	push   %edx
  8009f0:	50                   	push   %eax
  8009f1:	ff 75 f4             	pushl  -0xc(%ebp)
  8009f4:	ff 75 f0             	pushl  -0x10(%ebp)
  8009f7:	e8 28 23 00 00       	call   802d24 <__udivdi3>
  8009fc:	83 c4 10             	add    $0x10,%esp
  8009ff:	83 ec 04             	sub    $0x4,%esp
  800a02:	ff 75 20             	pushl  0x20(%ebp)
  800a05:	53                   	push   %ebx
  800a06:	ff 75 18             	pushl  0x18(%ebp)
  800a09:	52                   	push   %edx
  800a0a:	50                   	push   %eax
  800a0b:	ff 75 0c             	pushl  0xc(%ebp)
  800a0e:	ff 75 08             	pushl  0x8(%ebp)
  800a11:	e8 a1 ff ff ff       	call   8009b7 <printnum>
  800a16:	83 c4 20             	add    $0x20,%esp
  800a19:	eb 1a                	jmp    800a35 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800a1b:	83 ec 08             	sub    $0x8,%esp
  800a1e:	ff 75 0c             	pushl  0xc(%ebp)
  800a21:	ff 75 20             	pushl  0x20(%ebp)
  800a24:	8b 45 08             	mov    0x8(%ebp),%eax
  800a27:	ff d0                	call   *%eax
  800a29:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800a2c:	ff 4d 1c             	decl   0x1c(%ebp)
  800a2f:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800a33:	7f e6                	jg     800a1b <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800a35:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800a38:	bb 00 00 00 00       	mov    $0x0,%ebx
  800a3d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800a40:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800a43:	53                   	push   %ebx
  800a44:	51                   	push   %ecx
  800a45:	52                   	push   %edx
  800a46:	50                   	push   %eax
  800a47:	e8 e8 23 00 00       	call   802e34 <__umoddi3>
  800a4c:	83 c4 10             	add    $0x10,%esp
  800a4f:	05 b4 34 80 00       	add    $0x8034b4,%eax
  800a54:	8a 00                	mov    (%eax),%al
  800a56:	0f be c0             	movsbl %al,%eax
  800a59:	83 ec 08             	sub    $0x8,%esp
  800a5c:	ff 75 0c             	pushl  0xc(%ebp)
  800a5f:	50                   	push   %eax
  800a60:	8b 45 08             	mov    0x8(%ebp),%eax
  800a63:	ff d0                	call   *%eax
  800a65:	83 c4 10             	add    $0x10,%esp
}
  800a68:	90                   	nop
  800a69:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800a6c:	c9                   	leave  
  800a6d:	c3                   	ret    

00800a6e <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800a6e:	55                   	push   %ebp
  800a6f:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800a71:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800a75:	7e 1c                	jle    800a93 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800a77:	8b 45 08             	mov    0x8(%ebp),%eax
  800a7a:	8b 00                	mov    (%eax),%eax
  800a7c:	8d 50 08             	lea    0x8(%eax),%edx
  800a7f:	8b 45 08             	mov    0x8(%ebp),%eax
  800a82:	89 10                	mov    %edx,(%eax)
  800a84:	8b 45 08             	mov    0x8(%ebp),%eax
  800a87:	8b 00                	mov    (%eax),%eax
  800a89:	83 e8 08             	sub    $0x8,%eax
  800a8c:	8b 50 04             	mov    0x4(%eax),%edx
  800a8f:	8b 00                	mov    (%eax),%eax
  800a91:	eb 40                	jmp    800ad3 <getuint+0x65>
	else if (lflag)
  800a93:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800a97:	74 1e                	je     800ab7 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800a99:	8b 45 08             	mov    0x8(%ebp),%eax
  800a9c:	8b 00                	mov    (%eax),%eax
  800a9e:	8d 50 04             	lea    0x4(%eax),%edx
  800aa1:	8b 45 08             	mov    0x8(%ebp),%eax
  800aa4:	89 10                	mov    %edx,(%eax)
  800aa6:	8b 45 08             	mov    0x8(%ebp),%eax
  800aa9:	8b 00                	mov    (%eax),%eax
  800aab:	83 e8 04             	sub    $0x4,%eax
  800aae:	8b 00                	mov    (%eax),%eax
  800ab0:	ba 00 00 00 00       	mov    $0x0,%edx
  800ab5:	eb 1c                	jmp    800ad3 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800ab7:	8b 45 08             	mov    0x8(%ebp),%eax
  800aba:	8b 00                	mov    (%eax),%eax
  800abc:	8d 50 04             	lea    0x4(%eax),%edx
  800abf:	8b 45 08             	mov    0x8(%ebp),%eax
  800ac2:	89 10                	mov    %edx,(%eax)
  800ac4:	8b 45 08             	mov    0x8(%ebp),%eax
  800ac7:	8b 00                	mov    (%eax),%eax
  800ac9:	83 e8 04             	sub    $0x4,%eax
  800acc:	8b 00                	mov    (%eax),%eax
  800ace:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800ad3:	5d                   	pop    %ebp
  800ad4:	c3                   	ret    

00800ad5 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800ad5:	55                   	push   %ebp
  800ad6:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800ad8:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800adc:	7e 1c                	jle    800afa <getint+0x25>
		return va_arg(*ap, long long);
  800ade:	8b 45 08             	mov    0x8(%ebp),%eax
  800ae1:	8b 00                	mov    (%eax),%eax
  800ae3:	8d 50 08             	lea    0x8(%eax),%edx
  800ae6:	8b 45 08             	mov    0x8(%ebp),%eax
  800ae9:	89 10                	mov    %edx,(%eax)
  800aeb:	8b 45 08             	mov    0x8(%ebp),%eax
  800aee:	8b 00                	mov    (%eax),%eax
  800af0:	83 e8 08             	sub    $0x8,%eax
  800af3:	8b 50 04             	mov    0x4(%eax),%edx
  800af6:	8b 00                	mov    (%eax),%eax
  800af8:	eb 38                	jmp    800b32 <getint+0x5d>
	else if (lflag)
  800afa:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800afe:	74 1a                	je     800b1a <getint+0x45>
		return va_arg(*ap, long);
  800b00:	8b 45 08             	mov    0x8(%ebp),%eax
  800b03:	8b 00                	mov    (%eax),%eax
  800b05:	8d 50 04             	lea    0x4(%eax),%edx
  800b08:	8b 45 08             	mov    0x8(%ebp),%eax
  800b0b:	89 10                	mov    %edx,(%eax)
  800b0d:	8b 45 08             	mov    0x8(%ebp),%eax
  800b10:	8b 00                	mov    (%eax),%eax
  800b12:	83 e8 04             	sub    $0x4,%eax
  800b15:	8b 00                	mov    (%eax),%eax
  800b17:	99                   	cltd   
  800b18:	eb 18                	jmp    800b32 <getint+0x5d>
	else
		return va_arg(*ap, int);
  800b1a:	8b 45 08             	mov    0x8(%ebp),%eax
  800b1d:	8b 00                	mov    (%eax),%eax
  800b1f:	8d 50 04             	lea    0x4(%eax),%edx
  800b22:	8b 45 08             	mov    0x8(%ebp),%eax
  800b25:	89 10                	mov    %edx,(%eax)
  800b27:	8b 45 08             	mov    0x8(%ebp),%eax
  800b2a:	8b 00                	mov    (%eax),%eax
  800b2c:	83 e8 04             	sub    $0x4,%eax
  800b2f:	8b 00                	mov    (%eax),%eax
  800b31:	99                   	cltd   
}
  800b32:	5d                   	pop    %ebp
  800b33:	c3                   	ret    

00800b34 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800b34:	55                   	push   %ebp
  800b35:	89 e5                	mov    %esp,%ebp
  800b37:	56                   	push   %esi
  800b38:	53                   	push   %ebx
  800b39:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800b3c:	eb 17                	jmp    800b55 <vprintfmt+0x21>
			if (ch == '\0')
  800b3e:	85 db                	test   %ebx,%ebx
  800b40:	0f 84 c1 03 00 00    	je     800f07 <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  800b46:	83 ec 08             	sub    $0x8,%esp
  800b49:	ff 75 0c             	pushl  0xc(%ebp)
  800b4c:	53                   	push   %ebx
  800b4d:	8b 45 08             	mov    0x8(%ebp),%eax
  800b50:	ff d0                	call   *%eax
  800b52:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800b55:	8b 45 10             	mov    0x10(%ebp),%eax
  800b58:	8d 50 01             	lea    0x1(%eax),%edx
  800b5b:	89 55 10             	mov    %edx,0x10(%ebp)
  800b5e:	8a 00                	mov    (%eax),%al
  800b60:	0f b6 d8             	movzbl %al,%ebx
  800b63:	83 fb 25             	cmp    $0x25,%ebx
  800b66:	75 d6                	jne    800b3e <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800b68:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800b6c:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800b73:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800b7a:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800b81:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800b88:	8b 45 10             	mov    0x10(%ebp),%eax
  800b8b:	8d 50 01             	lea    0x1(%eax),%edx
  800b8e:	89 55 10             	mov    %edx,0x10(%ebp)
  800b91:	8a 00                	mov    (%eax),%al
  800b93:	0f b6 d8             	movzbl %al,%ebx
  800b96:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800b99:	83 f8 5b             	cmp    $0x5b,%eax
  800b9c:	0f 87 3d 03 00 00    	ja     800edf <vprintfmt+0x3ab>
  800ba2:	8b 04 85 d8 34 80 00 	mov    0x8034d8(,%eax,4),%eax
  800ba9:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800bab:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800baf:	eb d7                	jmp    800b88 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800bb1:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800bb5:	eb d1                	jmp    800b88 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800bb7:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800bbe:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800bc1:	89 d0                	mov    %edx,%eax
  800bc3:	c1 e0 02             	shl    $0x2,%eax
  800bc6:	01 d0                	add    %edx,%eax
  800bc8:	01 c0                	add    %eax,%eax
  800bca:	01 d8                	add    %ebx,%eax
  800bcc:	83 e8 30             	sub    $0x30,%eax
  800bcf:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800bd2:	8b 45 10             	mov    0x10(%ebp),%eax
  800bd5:	8a 00                	mov    (%eax),%al
  800bd7:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800bda:	83 fb 2f             	cmp    $0x2f,%ebx
  800bdd:	7e 3e                	jle    800c1d <vprintfmt+0xe9>
  800bdf:	83 fb 39             	cmp    $0x39,%ebx
  800be2:	7f 39                	jg     800c1d <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800be4:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800be7:	eb d5                	jmp    800bbe <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800be9:	8b 45 14             	mov    0x14(%ebp),%eax
  800bec:	83 c0 04             	add    $0x4,%eax
  800bef:	89 45 14             	mov    %eax,0x14(%ebp)
  800bf2:	8b 45 14             	mov    0x14(%ebp),%eax
  800bf5:	83 e8 04             	sub    $0x4,%eax
  800bf8:	8b 00                	mov    (%eax),%eax
  800bfa:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800bfd:	eb 1f                	jmp    800c1e <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800bff:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800c03:	79 83                	jns    800b88 <vprintfmt+0x54>
				width = 0;
  800c05:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800c0c:	e9 77 ff ff ff       	jmp    800b88 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800c11:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800c18:	e9 6b ff ff ff       	jmp    800b88 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800c1d:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800c1e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800c22:	0f 89 60 ff ff ff    	jns    800b88 <vprintfmt+0x54>
				width = precision, precision = -1;
  800c28:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800c2b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800c2e:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800c35:	e9 4e ff ff ff       	jmp    800b88 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800c3a:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800c3d:	e9 46 ff ff ff       	jmp    800b88 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800c42:	8b 45 14             	mov    0x14(%ebp),%eax
  800c45:	83 c0 04             	add    $0x4,%eax
  800c48:	89 45 14             	mov    %eax,0x14(%ebp)
  800c4b:	8b 45 14             	mov    0x14(%ebp),%eax
  800c4e:	83 e8 04             	sub    $0x4,%eax
  800c51:	8b 00                	mov    (%eax),%eax
  800c53:	83 ec 08             	sub    $0x8,%esp
  800c56:	ff 75 0c             	pushl  0xc(%ebp)
  800c59:	50                   	push   %eax
  800c5a:	8b 45 08             	mov    0x8(%ebp),%eax
  800c5d:	ff d0                	call   *%eax
  800c5f:	83 c4 10             	add    $0x10,%esp
			break;
  800c62:	e9 9b 02 00 00       	jmp    800f02 <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800c67:	8b 45 14             	mov    0x14(%ebp),%eax
  800c6a:	83 c0 04             	add    $0x4,%eax
  800c6d:	89 45 14             	mov    %eax,0x14(%ebp)
  800c70:	8b 45 14             	mov    0x14(%ebp),%eax
  800c73:	83 e8 04             	sub    $0x4,%eax
  800c76:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800c78:	85 db                	test   %ebx,%ebx
  800c7a:	79 02                	jns    800c7e <vprintfmt+0x14a>
				err = -err;
  800c7c:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800c7e:	83 fb 64             	cmp    $0x64,%ebx
  800c81:	7f 0b                	jg     800c8e <vprintfmt+0x15a>
  800c83:	8b 34 9d 20 33 80 00 	mov    0x803320(,%ebx,4),%esi
  800c8a:	85 f6                	test   %esi,%esi
  800c8c:	75 19                	jne    800ca7 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800c8e:	53                   	push   %ebx
  800c8f:	68 c5 34 80 00       	push   $0x8034c5
  800c94:	ff 75 0c             	pushl  0xc(%ebp)
  800c97:	ff 75 08             	pushl  0x8(%ebp)
  800c9a:	e8 70 02 00 00       	call   800f0f <printfmt>
  800c9f:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800ca2:	e9 5b 02 00 00       	jmp    800f02 <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800ca7:	56                   	push   %esi
  800ca8:	68 ce 34 80 00       	push   $0x8034ce
  800cad:	ff 75 0c             	pushl  0xc(%ebp)
  800cb0:	ff 75 08             	pushl  0x8(%ebp)
  800cb3:	e8 57 02 00 00       	call   800f0f <printfmt>
  800cb8:	83 c4 10             	add    $0x10,%esp
			break;
  800cbb:	e9 42 02 00 00       	jmp    800f02 <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800cc0:	8b 45 14             	mov    0x14(%ebp),%eax
  800cc3:	83 c0 04             	add    $0x4,%eax
  800cc6:	89 45 14             	mov    %eax,0x14(%ebp)
  800cc9:	8b 45 14             	mov    0x14(%ebp),%eax
  800ccc:	83 e8 04             	sub    $0x4,%eax
  800ccf:	8b 30                	mov    (%eax),%esi
  800cd1:	85 f6                	test   %esi,%esi
  800cd3:	75 05                	jne    800cda <vprintfmt+0x1a6>
				p = "(null)";
  800cd5:	be d1 34 80 00       	mov    $0x8034d1,%esi
			if (width > 0 && padc != '-')
  800cda:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800cde:	7e 6d                	jle    800d4d <vprintfmt+0x219>
  800ce0:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800ce4:	74 67                	je     800d4d <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800ce6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800ce9:	83 ec 08             	sub    $0x8,%esp
  800cec:	50                   	push   %eax
  800ced:	56                   	push   %esi
  800cee:	e8 1e 03 00 00       	call   801011 <strnlen>
  800cf3:	83 c4 10             	add    $0x10,%esp
  800cf6:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800cf9:	eb 16                	jmp    800d11 <vprintfmt+0x1dd>
					putch(padc, putdat);
  800cfb:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800cff:	83 ec 08             	sub    $0x8,%esp
  800d02:	ff 75 0c             	pushl  0xc(%ebp)
  800d05:	50                   	push   %eax
  800d06:	8b 45 08             	mov    0x8(%ebp),%eax
  800d09:	ff d0                	call   *%eax
  800d0b:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800d0e:	ff 4d e4             	decl   -0x1c(%ebp)
  800d11:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800d15:	7f e4                	jg     800cfb <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800d17:	eb 34                	jmp    800d4d <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800d19:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800d1d:	74 1c                	je     800d3b <vprintfmt+0x207>
  800d1f:	83 fb 1f             	cmp    $0x1f,%ebx
  800d22:	7e 05                	jle    800d29 <vprintfmt+0x1f5>
  800d24:	83 fb 7e             	cmp    $0x7e,%ebx
  800d27:	7e 12                	jle    800d3b <vprintfmt+0x207>
					putch('?', putdat);
  800d29:	83 ec 08             	sub    $0x8,%esp
  800d2c:	ff 75 0c             	pushl  0xc(%ebp)
  800d2f:	6a 3f                	push   $0x3f
  800d31:	8b 45 08             	mov    0x8(%ebp),%eax
  800d34:	ff d0                	call   *%eax
  800d36:	83 c4 10             	add    $0x10,%esp
  800d39:	eb 0f                	jmp    800d4a <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800d3b:	83 ec 08             	sub    $0x8,%esp
  800d3e:	ff 75 0c             	pushl  0xc(%ebp)
  800d41:	53                   	push   %ebx
  800d42:	8b 45 08             	mov    0x8(%ebp),%eax
  800d45:	ff d0                	call   *%eax
  800d47:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800d4a:	ff 4d e4             	decl   -0x1c(%ebp)
  800d4d:	89 f0                	mov    %esi,%eax
  800d4f:	8d 70 01             	lea    0x1(%eax),%esi
  800d52:	8a 00                	mov    (%eax),%al
  800d54:	0f be d8             	movsbl %al,%ebx
  800d57:	85 db                	test   %ebx,%ebx
  800d59:	74 24                	je     800d7f <vprintfmt+0x24b>
  800d5b:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800d5f:	78 b8                	js     800d19 <vprintfmt+0x1e5>
  800d61:	ff 4d e0             	decl   -0x20(%ebp)
  800d64:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800d68:	79 af                	jns    800d19 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800d6a:	eb 13                	jmp    800d7f <vprintfmt+0x24b>
				putch(' ', putdat);
  800d6c:	83 ec 08             	sub    $0x8,%esp
  800d6f:	ff 75 0c             	pushl  0xc(%ebp)
  800d72:	6a 20                	push   $0x20
  800d74:	8b 45 08             	mov    0x8(%ebp),%eax
  800d77:	ff d0                	call   *%eax
  800d79:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800d7c:	ff 4d e4             	decl   -0x1c(%ebp)
  800d7f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800d83:	7f e7                	jg     800d6c <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800d85:	e9 78 01 00 00       	jmp    800f02 <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800d8a:	83 ec 08             	sub    $0x8,%esp
  800d8d:	ff 75 e8             	pushl  -0x18(%ebp)
  800d90:	8d 45 14             	lea    0x14(%ebp),%eax
  800d93:	50                   	push   %eax
  800d94:	e8 3c fd ff ff       	call   800ad5 <getint>
  800d99:	83 c4 10             	add    $0x10,%esp
  800d9c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800d9f:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800da2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800da5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800da8:	85 d2                	test   %edx,%edx
  800daa:	79 23                	jns    800dcf <vprintfmt+0x29b>
				putch('-', putdat);
  800dac:	83 ec 08             	sub    $0x8,%esp
  800daf:	ff 75 0c             	pushl  0xc(%ebp)
  800db2:	6a 2d                	push   $0x2d
  800db4:	8b 45 08             	mov    0x8(%ebp),%eax
  800db7:	ff d0                	call   *%eax
  800db9:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800dbc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800dbf:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800dc2:	f7 d8                	neg    %eax
  800dc4:	83 d2 00             	adc    $0x0,%edx
  800dc7:	f7 da                	neg    %edx
  800dc9:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800dcc:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800dcf:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800dd6:	e9 bc 00 00 00       	jmp    800e97 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800ddb:	83 ec 08             	sub    $0x8,%esp
  800dde:	ff 75 e8             	pushl  -0x18(%ebp)
  800de1:	8d 45 14             	lea    0x14(%ebp),%eax
  800de4:	50                   	push   %eax
  800de5:	e8 84 fc ff ff       	call   800a6e <getuint>
  800dea:	83 c4 10             	add    $0x10,%esp
  800ded:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800df0:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800df3:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800dfa:	e9 98 00 00 00       	jmp    800e97 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800dff:	83 ec 08             	sub    $0x8,%esp
  800e02:	ff 75 0c             	pushl  0xc(%ebp)
  800e05:	6a 58                	push   $0x58
  800e07:	8b 45 08             	mov    0x8(%ebp),%eax
  800e0a:	ff d0                	call   *%eax
  800e0c:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800e0f:	83 ec 08             	sub    $0x8,%esp
  800e12:	ff 75 0c             	pushl  0xc(%ebp)
  800e15:	6a 58                	push   $0x58
  800e17:	8b 45 08             	mov    0x8(%ebp),%eax
  800e1a:	ff d0                	call   *%eax
  800e1c:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800e1f:	83 ec 08             	sub    $0x8,%esp
  800e22:	ff 75 0c             	pushl  0xc(%ebp)
  800e25:	6a 58                	push   $0x58
  800e27:	8b 45 08             	mov    0x8(%ebp),%eax
  800e2a:	ff d0                	call   *%eax
  800e2c:	83 c4 10             	add    $0x10,%esp
			break;
  800e2f:	e9 ce 00 00 00       	jmp    800f02 <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  800e34:	83 ec 08             	sub    $0x8,%esp
  800e37:	ff 75 0c             	pushl  0xc(%ebp)
  800e3a:	6a 30                	push   $0x30
  800e3c:	8b 45 08             	mov    0x8(%ebp),%eax
  800e3f:	ff d0                	call   *%eax
  800e41:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800e44:	83 ec 08             	sub    $0x8,%esp
  800e47:	ff 75 0c             	pushl  0xc(%ebp)
  800e4a:	6a 78                	push   $0x78
  800e4c:	8b 45 08             	mov    0x8(%ebp),%eax
  800e4f:	ff d0                	call   *%eax
  800e51:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800e54:	8b 45 14             	mov    0x14(%ebp),%eax
  800e57:	83 c0 04             	add    $0x4,%eax
  800e5a:	89 45 14             	mov    %eax,0x14(%ebp)
  800e5d:	8b 45 14             	mov    0x14(%ebp),%eax
  800e60:	83 e8 04             	sub    $0x4,%eax
  800e63:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800e65:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800e68:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800e6f:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800e76:	eb 1f                	jmp    800e97 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800e78:	83 ec 08             	sub    $0x8,%esp
  800e7b:	ff 75 e8             	pushl  -0x18(%ebp)
  800e7e:	8d 45 14             	lea    0x14(%ebp),%eax
  800e81:	50                   	push   %eax
  800e82:	e8 e7 fb ff ff       	call   800a6e <getuint>
  800e87:	83 c4 10             	add    $0x10,%esp
  800e8a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800e8d:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800e90:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800e97:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800e9b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800e9e:	83 ec 04             	sub    $0x4,%esp
  800ea1:	52                   	push   %edx
  800ea2:	ff 75 e4             	pushl  -0x1c(%ebp)
  800ea5:	50                   	push   %eax
  800ea6:	ff 75 f4             	pushl  -0xc(%ebp)
  800ea9:	ff 75 f0             	pushl  -0x10(%ebp)
  800eac:	ff 75 0c             	pushl  0xc(%ebp)
  800eaf:	ff 75 08             	pushl  0x8(%ebp)
  800eb2:	e8 00 fb ff ff       	call   8009b7 <printnum>
  800eb7:	83 c4 20             	add    $0x20,%esp
			break;
  800eba:	eb 46                	jmp    800f02 <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800ebc:	83 ec 08             	sub    $0x8,%esp
  800ebf:	ff 75 0c             	pushl  0xc(%ebp)
  800ec2:	53                   	push   %ebx
  800ec3:	8b 45 08             	mov    0x8(%ebp),%eax
  800ec6:	ff d0                	call   *%eax
  800ec8:	83 c4 10             	add    $0x10,%esp
			break;
  800ecb:	eb 35                	jmp    800f02 <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  800ecd:	c6 05 44 40 80 00 00 	movb   $0x0,0x804044
			break;
  800ed4:	eb 2c                	jmp    800f02 <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  800ed6:	c6 05 44 40 80 00 01 	movb   $0x1,0x804044
			break;
  800edd:	eb 23                	jmp    800f02 <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800edf:	83 ec 08             	sub    $0x8,%esp
  800ee2:	ff 75 0c             	pushl  0xc(%ebp)
  800ee5:	6a 25                	push   $0x25
  800ee7:	8b 45 08             	mov    0x8(%ebp),%eax
  800eea:	ff d0                	call   *%eax
  800eec:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800eef:	ff 4d 10             	decl   0x10(%ebp)
  800ef2:	eb 03                	jmp    800ef7 <vprintfmt+0x3c3>
  800ef4:	ff 4d 10             	decl   0x10(%ebp)
  800ef7:	8b 45 10             	mov    0x10(%ebp),%eax
  800efa:	48                   	dec    %eax
  800efb:	8a 00                	mov    (%eax),%al
  800efd:	3c 25                	cmp    $0x25,%al
  800eff:	75 f3                	jne    800ef4 <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  800f01:	90                   	nop
		}
	}
  800f02:	e9 35 fc ff ff       	jmp    800b3c <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800f07:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800f08:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800f0b:	5b                   	pop    %ebx
  800f0c:	5e                   	pop    %esi
  800f0d:	5d                   	pop    %ebp
  800f0e:	c3                   	ret    

00800f0f <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800f0f:	55                   	push   %ebp
  800f10:	89 e5                	mov    %esp,%ebp
  800f12:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800f15:	8d 45 10             	lea    0x10(%ebp),%eax
  800f18:	83 c0 04             	add    $0x4,%eax
  800f1b:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800f1e:	8b 45 10             	mov    0x10(%ebp),%eax
  800f21:	ff 75 f4             	pushl  -0xc(%ebp)
  800f24:	50                   	push   %eax
  800f25:	ff 75 0c             	pushl  0xc(%ebp)
  800f28:	ff 75 08             	pushl  0x8(%ebp)
  800f2b:	e8 04 fc ff ff       	call   800b34 <vprintfmt>
  800f30:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800f33:	90                   	nop
  800f34:	c9                   	leave  
  800f35:	c3                   	ret    

00800f36 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800f36:	55                   	push   %ebp
  800f37:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800f39:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f3c:	8b 40 08             	mov    0x8(%eax),%eax
  800f3f:	8d 50 01             	lea    0x1(%eax),%edx
  800f42:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f45:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800f48:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f4b:	8b 10                	mov    (%eax),%edx
  800f4d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f50:	8b 40 04             	mov    0x4(%eax),%eax
  800f53:	39 c2                	cmp    %eax,%edx
  800f55:	73 12                	jae    800f69 <sprintputch+0x33>
		*b->buf++ = ch;
  800f57:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f5a:	8b 00                	mov    (%eax),%eax
  800f5c:	8d 48 01             	lea    0x1(%eax),%ecx
  800f5f:	8b 55 0c             	mov    0xc(%ebp),%edx
  800f62:	89 0a                	mov    %ecx,(%edx)
  800f64:	8b 55 08             	mov    0x8(%ebp),%edx
  800f67:	88 10                	mov    %dl,(%eax)
}
  800f69:	90                   	nop
  800f6a:	5d                   	pop    %ebp
  800f6b:	c3                   	ret    

00800f6c <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800f6c:	55                   	push   %ebp
  800f6d:	89 e5                	mov    %esp,%ebp
  800f6f:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800f72:	8b 45 08             	mov    0x8(%ebp),%eax
  800f75:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800f78:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f7b:	8d 50 ff             	lea    -0x1(%eax),%edx
  800f7e:	8b 45 08             	mov    0x8(%ebp),%eax
  800f81:	01 d0                	add    %edx,%eax
  800f83:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800f86:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800f8d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800f91:	74 06                	je     800f99 <vsnprintf+0x2d>
  800f93:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800f97:	7f 07                	jg     800fa0 <vsnprintf+0x34>
		return -E_INVAL;
  800f99:	b8 03 00 00 00       	mov    $0x3,%eax
  800f9e:	eb 20                	jmp    800fc0 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800fa0:	ff 75 14             	pushl  0x14(%ebp)
  800fa3:	ff 75 10             	pushl  0x10(%ebp)
  800fa6:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800fa9:	50                   	push   %eax
  800faa:	68 36 0f 80 00       	push   $0x800f36
  800faf:	e8 80 fb ff ff       	call   800b34 <vprintfmt>
  800fb4:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800fb7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800fba:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800fbd:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800fc0:	c9                   	leave  
  800fc1:	c3                   	ret    

00800fc2 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800fc2:	55                   	push   %ebp
  800fc3:	89 e5                	mov    %esp,%ebp
  800fc5:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800fc8:	8d 45 10             	lea    0x10(%ebp),%eax
  800fcb:	83 c0 04             	add    $0x4,%eax
  800fce:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800fd1:	8b 45 10             	mov    0x10(%ebp),%eax
  800fd4:	ff 75 f4             	pushl  -0xc(%ebp)
  800fd7:	50                   	push   %eax
  800fd8:	ff 75 0c             	pushl  0xc(%ebp)
  800fdb:	ff 75 08             	pushl  0x8(%ebp)
  800fde:	e8 89 ff ff ff       	call   800f6c <vsnprintf>
  800fe3:	83 c4 10             	add    $0x10,%esp
  800fe6:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800fe9:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800fec:	c9                   	leave  
  800fed:	c3                   	ret    

00800fee <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800fee:	55                   	push   %ebp
  800fef:	89 e5                	mov    %esp,%ebp
  800ff1:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800ff4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800ffb:	eb 06                	jmp    801003 <strlen+0x15>
		n++;
  800ffd:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  801000:	ff 45 08             	incl   0x8(%ebp)
  801003:	8b 45 08             	mov    0x8(%ebp),%eax
  801006:	8a 00                	mov    (%eax),%al
  801008:	84 c0                	test   %al,%al
  80100a:	75 f1                	jne    800ffd <strlen+0xf>
		n++;
	return n;
  80100c:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  80100f:	c9                   	leave  
  801010:	c3                   	ret    

00801011 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  801011:	55                   	push   %ebp
  801012:	89 e5                	mov    %esp,%ebp
  801014:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801017:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80101e:	eb 09                	jmp    801029 <strnlen+0x18>
		n++;
  801020:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801023:	ff 45 08             	incl   0x8(%ebp)
  801026:	ff 4d 0c             	decl   0xc(%ebp)
  801029:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80102d:	74 09                	je     801038 <strnlen+0x27>
  80102f:	8b 45 08             	mov    0x8(%ebp),%eax
  801032:	8a 00                	mov    (%eax),%al
  801034:	84 c0                	test   %al,%al
  801036:	75 e8                	jne    801020 <strnlen+0xf>
		n++;
	return n;
  801038:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  80103b:	c9                   	leave  
  80103c:	c3                   	ret    

0080103d <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  80103d:	55                   	push   %ebp
  80103e:	89 e5                	mov    %esp,%ebp
  801040:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  801043:	8b 45 08             	mov    0x8(%ebp),%eax
  801046:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  801049:	90                   	nop
  80104a:	8b 45 08             	mov    0x8(%ebp),%eax
  80104d:	8d 50 01             	lea    0x1(%eax),%edx
  801050:	89 55 08             	mov    %edx,0x8(%ebp)
  801053:	8b 55 0c             	mov    0xc(%ebp),%edx
  801056:	8d 4a 01             	lea    0x1(%edx),%ecx
  801059:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  80105c:	8a 12                	mov    (%edx),%dl
  80105e:	88 10                	mov    %dl,(%eax)
  801060:	8a 00                	mov    (%eax),%al
  801062:	84 c0                	test   %al,%al
  801064:	75 e4                	jne    80104a <strcpy+0xd>
		/* do nothing */;
	return ret;
  801066:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801069:	c9                   	leave  
  80106a:	c3                   	ret    

0080106b <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  80106b:	55                   	push   %ebp
  80106c:	89 e5                	mov    %esp,%ebp
  80106e:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  801071:	8b 45 08             	mov    0x8(%ebp),%eax
  801074:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  801077:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80107e:	eb 1f                	jmp    80109f <strncpy+0x34>
		*dst++ = *src;
  801080:	8b 45 08             	mov    0x8(%ebp),%eax
  801083:	8d 50 01             	lea    0x1(%eax),%edx
  801086:	89 55 08             	mov    %edx,0x8(%ebp)
  801089:	8b 55 0c             	mov    0xc(%ebp),%edx
  80108c:	8a 12                	mov    (%edx),%dl
  80108e:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  801090:	8b 45 0c             	mov    0xc(%ebp),%eax
  801093:	8a 00                	mov    (%eax),%al
  801095:	84 c0                	test   %al,%al
  801097:	74 03                	je     80109c <strncpy+0x31>
			src++;
  801099:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  80109c:	ff 45 fc             	incl   -0x4(%ebp)
  80109f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8010a2:	3b 45 10             	cmp    0x10(%ebp),%eax
  8010a5:	72 d9                	jb     801080 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  8010a7:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8010aa:	c9                   	leave  
  8010ab:	c3                   	ret    

008010ac <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  8010ac:	55                   	push   %ebp
  8010ad:	89 e5                	mov    %esp,%ebp
  8010af:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  8010b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8010b5:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  8010b8:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8010bc:	74 30                	je     8010ee <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  8010be:	eb 16                	jmp    8010d6 <strlcpy+0x2a>
			*dst++ = *src++;
  8010c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8010c3:	8d 50 01             	lea    0x1(%eax),%edx
  8010c6:	89 55 08             	mov    %edx,0x8(%ebp)
  8010c9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8010cc:	8d 4a 01             	lea    0x1(%edx),%ecx
  8010cf:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  8010d2:	8a 12                	mov    (%edx),%dl
  8010d4:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  8010d6:	ff 4d 10             	decl   0x10(%ebp)
  8010d9:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8010dd:	74 09                	je     8010e8 <strlcpy+0x3c>
  8010df:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010e2:	8a 00                	mov    (%eax),%al
  8010e4:	84 c0                	test   %al,%al
  8010e6:	75 d8                	jne    8010c0 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  8010e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8010eb:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  8010ee:	8b 55 08             	mov    0x8(%ebp),%edx
  8010f1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8010f4:	29 c2                	sub    %eax,%edx
  8010f6:	89 d0                	mov    %edx,%eax
}
  8010f8:	c9                   	leave  
  8010f9:	c3                   	ret    

008010fa <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8010fa:	55                   	push   %ebp
  8010fb:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  8010fd:	eb 06                	jmp    801105 <strcmp+0xb>
		p++, q++;
  8010ff:	ff 45 08             	incl   0x8(%ebp)
  801102:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  801105:	8b 45 08             	mov    0x8(%ebp),%eax
  801108:	8a 00                	mov    (%eax),%al
  80110a:	84 c0                	test   %al,%al
  80110c:	74 0e                	je     80111c <strcmp+0x22>
  80110e:	8b 45 08             	mov    0x8(%ebp),%eax
  801111:	8a 10                	mov    (%eax),%dl
  801113:	8b 45 0c             	mov    0xc(%ebp),%eax
  801116:	8a 00                	mov    (%eax),%al
  801118:	38 c2                	cmp    %al,%dl
  80111a:	74 e3                	je     8010ff <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  80111c:	8b 45 08             	mov    0x8(%ebp),%eax
  80111f:	8a 00                	mov    (%eax),%al
  801121:	0f b6 d0             	movzbl %al,%edx
  801124:	8b 45 0c             	mov    0xc(%ebp),%eax
  801127:	8a 00                	mov    (%eax),%al
  801129:	0f b6 c0             	movzbl %al,%eax
  80112c:	29 c2                	sub    %eax,%edx
  80112e:	89 d0                	mov    %edx,%eax
}
  801130:	5d                   	pop    %ebp
  801131:	c3                   	ret    

00801132 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  801132:	55                   	push   %ebp
  801133:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  801135:	eb 09                	jmp    801140 <strncmp+0xe>
		n--, p++, q++;
  801137:	ff 4d 10             	decl   0x10(%ebp)
  80113a:	ff 45 08             	incl   0x8(%ebp)
  80113d:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  801140:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801144:	74 17                	je     80115d <strncmp+0x2b>
  801146:	8b 45 08             	mov    0x8(%ebp),%eax
  801149:	8a 00                	mov    (%eax),%al
  80114b:	84 c0                	test   %al,%al
  80114d:	74 0e                	je     80115d <strncmp+0x2b>
  80114f:	8b 45 08             	mov    0x8(%ebp),%eax
  801152:	8a 10                	mov    (%eax),%dl
  801154:	8b 45 0c             	mov    0xc(%ebp),%eax
  801157:	8a 00                	mov    (%eax),%al
  801159:	38 c2                	cmp    %al,%dl
  80115b:	74 da                	je     801137 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  80115d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801161:	75 07                	jne    80116a <strncmp+0x38>
		return 0;
  801163:	b8 00 00 00 00       	mov    $0x0,%eax
  801168:	eb 14                	jmp    80117e <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  80116a:	8b 45 08             	mov    0x8(%ebp),%eax
  80116d:	8a 00                	mov    (%eax),%al
  80116f:	0f b6 d0             	movzbl %al,%edx
  801172:	8b 45 0c             	mov    0xc(%ebp),%eax
  801175:	8a 00                	mov    (%eax),%al
  801177:	0f b6 c0             	movzbl %al,%eax
  80117a:	29 c2                	sub    %eax,%edx
  80117c:	89 d0                	mov    %edx,%eax
}
  80117e:	5d                   	pop    %ebp
  80117f:	c3                   	ret    

00801180 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  801180:	55                   	push   %ebp
  801181:	89 e5                	mov    %esp,%ebp
  801183:	83 ec 04             	sub    $0x4,%esp
  801186:	8b 45 0c             	mov    0xc(%ebp),%eax
  801189:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  80118c:	eb 12                	jmp    8011a0 <strchr+0x20>
		if (*s == c)
  80118e:	8b 45 08             	mov    0x8(%ebp),%eax
  801191:	8a 00                	mov    (%eax),%al
  801193:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801196:	75 05                	jne    80119d <strchr+0x1d>
			return (char *) s;
  801198:	8b 45 08             	mov    0x8(%ebp),%eax
  80119b:	eb 11                	jmp    8011ae <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  80119d:	ff 45 08             	incl   0x8(%ebp)
  8011a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8011a3:	8a 00                	mov    (%eax),%al
  8011a5:	84 c0                	test   %al,%al
  8011a7:	75 e5                	jne    80118e <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  8011a9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8011ae:	c9                   	leave  
  8011af:	c3                   	ret    

008011b0 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8011b0:	55                   	push   %ebp
  8011b1:	89 e5                	mov    %esp,%ebp
  8011b3:	83 ec 04             	sub    $0x4,%esp
  8011b6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011b9:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  8011bc:	eb 0d                	jmp    8011cb <strfind+0x1b>
		if (*s == c)
  8011be:	8b 45 08             	mov    0x8(%ebp),%eax
  8011c1:	8a 00                	mov    (%eax),%al
  8011c3:	3a 45 fc             	cmp    -0x4(%ebp),%al
  8011c6:	74 0e                	je     8011d6 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  8011c8:	ff 45 08             	incl   0x8(%ebp)
  8011cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8011ce:	8a 00                	mov    (%eax),%al
  8011d0:	84 c0                	test   %al,%al
  8011d2:	75 ea                	jne    8011be <strfind+0xe>
  8011d4:	eb 01                	jmp    8011d7 <strfind+0x27>
		if (*s == c)
			break;
  8011d6:	90                   	nop
	return (char *) s;
  8011d7:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8011da:	c9                   	leave  
  8011db:	c3                   	ret    

008011dc <memset>:

// *************** The faster implementation of memset & memcpy is implemented by *************
// ****************** Team80 (Yahia Khaled, Malek Ahmed et al) - FCIS'24-25 *******************
void *
memset(void *v, int c, uint32 n)
{
  8011dc:	55                   	push   %ebp
  8011dd:	89 e5                	mov    %esp,%ebp
  8011df:	83 ec 10             	sub    $0x10,%esp
//	m = n;
//	while (--m >= 0)
//		*p++ = c;

	/*Faster Implementation*/
	uint64* p64 = (uint64*)v;
  8011e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8011e5:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if(n >= 8){
  8011e8:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  8011ec:	76 63                	jbe    801251 <memset+0x75>
		uint64 data_block = c;
  8011ee:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011f1:	99                   	cltd   
  8011f2:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8011f5:	89 55 f4             	mov    %edx,-0xc(%ebp)
		data_block |= data_block << 8;
  8011f8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8011fb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8011fe:	0f a4 c2 08          	shld   $0x8,%eax,%edx
  801202:	c1 e0 08             	shl    $0x8,%eax
  801205:	09 45 f0             	or     %eax,-0x10(%ebp)
  801208:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 16;
  80120b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80120e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801211:	0f a4 c2 10          	shld   $0x10,%eax,%edx
  801215:	c1 e0 10             	shl    $0x10,%eax
  801218:	09 45 f0             	or     %eax,-0x10(%ebp)
  80121b:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 32;
  80121e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801221:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801224:	89 c2                	mov    %eax,%edx
  801226:	b8 00 00 00 00       	mov    $0x0,%eax
  80122b:	09 45 f0             	or     %eax,-0x10(%ebp)
  80122e:	09 55 f4             	or     %edx,-0xc(%ebp)

		while(n >= 8)
  801231:	eb 18                	jmp    80124b <memset+0x6f>
			*p64++ = data_block, n -= 8;
  801233:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801236:	8d 41 08             	lea    0x8(%ecx),%eax
  801239:	89 45 fc             	mov    %eax,-0x4(%ebp)
  80123c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80123f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801242:	89 01                	mov    %eax,(%ecx)
  801244:	89 51 04             	mov    %edx,0x4(%ecx)
  801247:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
		uint64 data_block = c;
		data_block |= data_block << 8;
		data_block |= data_block << 16;
		data_block |= data_block << 32;

		while(n >= 8)
  80124b:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  80124f:	77 e2                	ja     801233 <memset+0x57>
			*p64++ = data_block, n -= 8;
	}

	if(n){
  801251:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801255:	74 23                	je     80127a <memset+0x9e>
		uint8* p8 = (uint8*)p64;
  801257:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80125a:	89 45 f8             	mov    %eax,-0x8(%ebp)
		while (n-- > 0)
  80125d:	eb 0e                	jmp    80126d <memset+0x91>
			*p8++ = (uint8)c;
  80125f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801262:	8d 50 01             	lea    0x1(%eax),%edx
  801265:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801268:	8b 55 0c             	mov    0xc(%ebp),%edx
  80126b:	88 10                	mov    %dl,(%eax)
			*p64++ = data_block, n -= 8;
	}

	if(n){
		uint8* p8 = (uint8*)p64;
		while (n-- > 0)
  80126d:	8b 45 10             	mov    0x10(%ebp),%eax
  801270:	8d 50 ff             	lea    -0x1(%eax),%edx
  801273:	89 55 10             	mov    %edx,0x10(%ebp)
  801276:	85 c0                	test   %eax,%eax
  801278:	75 e5                	jne    80125f <memset+0x83>
			*p8++ = (uint8)c;
	}

	return v;
  80127a:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80127d:	c9                   	leave  
  80127e:	c3                   	ret    

0080127f <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  80127f:	55                   	push   %ebp
  801280:	89 e5                	mov    %esp,%ebp
  801282:	83 ec 10             	sub    $0x10,%esp
	//	s = src;
	//	d = dst;
	//	while (n-- > 0)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
  801285:	8b 45 0c             	mov    0xc(%ebp),%eax
  801288:	89 45 fc             	mov    %eax,-0x4(%ebp)
	uint64* d64 = (uint64*)dst;
  80128b:	8b 45 08             	mov    0x8(%ebp),%eax
  80128e:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if(n >= 8){
  801291:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  801295:	76 24                	jbe    8012bb <memcpy+0x3c>
		while(n >= 8){
  801297:	eb 1c                	jmp    8012b5 <memcpy+0x36>
			*d64 = *s64;
  801299:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80129c:	8b 50 04             	mov    0x4(%eax),%edx
  80129f:	8b 00                	mov    (%eax),%eax
  8012a1:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8012a4:	89 01                	mov    %eax,(%ecx)
  8012a6:	89 51 04             	mov    %edx,0x4(%ecx)
			n -= 8;
  8012a9:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
			++s64;
  8012ad:	83 45 fc 08          	addl   $0x8,-0x4(%ebp)
			++d64;
  8012b1:	83 45 f8 08          	addl   $0x8,-0x8(%ebp)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
	uint64* d64 = (uint64*)dst;
	if(n >= 8){
		while(n >= 8){
  8012b5:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  8012b9:	77 de                	ja     801299 <memcpy+0x1a>
			++s64;
			++d64;
		}
	}

	if(n){
  8012bb:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8012bf:	74 31                	je     8012f2 <memcpy+0x73>
		uint8* s8 = (uint8*)s64;
  8012c1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8012c4:	89 45 f4             	mov    %eax,-0xc(%ebp)
		uint8* d8 = (uint8*)d64;
  8012c7:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8012ca:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (n-- > 0)
  8012cd:	eb 16                	jmp    8012e5 <memcpy+0x66>
			*d8++ = *s8++;
  8012cf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8012d2:	8d 50 01             	lea    0x1(%eax),%edx
  8012d5:	89 55 f0             	mov    %edx,-0x10(%ebp)
  8012d8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8012db:	8d 4a 01             	lea    0x1(%edx),%ecx
  8012de:	89 4d f4             	mov    %ecx,-0xc(%ebp)
  8012e1:	8a 12                	mov    (%edx),%dl
  8012e3:	88 10                	mov    %dl,(%eax)
	}

	if(n){
		uint8* s8 = (uint8*)s64;
		uint8* d8 = (uint8*)d64;
		while (n-- > 0)
  8012e5:	8b 45 10             	mov    0x10(%ebp),%eax
  8012e8:	8d 50 ff             	lea    -0x1(%eax),%edx
  8012eb:	89 55 10             	mov    %edx,0x10(%ebp)
  8012ee:	85 c0                	test   %eax,%eax
  8012f0:	75 dd                	jne    8012cf <memcpy+0x50>
			*d8++ = *s8++;
	}
	return dst;
  8012f2:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8012f5:	c9                   	leave  
  8012f6:	c3                   	ret    

008012f7 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  8012f7:	55                   	push   %ebp
  8012f8:	89 e5                	mov    %esp,%ebp
  8012fa:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  8012fd:	8b 45 0c             	mov    0xc(%ebp),%eax
  801300:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801303:	8b 45 08             	mov    0x8(%ebp),%eax
  801306:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  801309:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80130c:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  80130f:	73 50                	jae    801361 <memmove+0x6a>
  801311:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801314:	8b 45 10             	mov    0x10(%ebp),%eax
  801317:	01 d0                	add    %edx,%eax
  801319:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  80131c:	76 43                	jbe    801361 <memmove+0x6a>
		s += n;
  80131e:	8b 45 10             	mov    0x10(%ebp),%eax
  801321:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  801324:	8b 45 10             	mov    0x10(%ebp),%eax
  801327:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  80132a:	eb 10                	jmp    80133c <memmove+0x45>
			*--d = *--s;
  80132c:	ff 4d f8             	decl   -0x8(%ebp)
  80132f:	ff 4d fc             	decl   -0x4(%ebp)
  801332:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801335:	8a 10                	mov    (%eax),%dl
  801337:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80133a:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  80133c:	8b 45 10             	mov    0x10(%ebp),%eax
  80133f:	8d 50 ff             	lea    -0x1(%eax),%edx
  801342:	89 55 10             	mov    %edx,0x10(%ebp)
  801345:	85 c0                	test   %eax,%eax
  801347:	75 e3                	jne    80132c <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  801349:	eb 23                	jmp    80136e <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  80134b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80134e:	8d 50 01             	lea    0x1(%eax),%edx
  801351:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801354:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801357:	8d 4a 01             	lea    0x1(%edx),%ecx
  80135a:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  80135d:	8a 12                	mov    (%edx),%dl
  80135f:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  801361:	8b 45 10             	mov    0x10(%ebp),%eax
  801364:	8d 50 ff             	lea    -0x1(%eax),%edx
  801367:	89 55 10             	mov    %edx,0x10(%ebp)
  80136a:	85 c0                	test   %eax,%eax
  80136c:	75 dd                	jne    80134b <memmove+0x54>
			*d++ = *s++;

	return dst;
  80136e:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801371:	c9                   	leave  
  801372:	c3                   	ret    

00801373 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  801373:	55                   	push   %ebp
  801374:	89 e5                	mov    %esp,%ebp
  801376:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  801379:	8b 45 08             	mov    0x8(%ebp),%eax
  80137c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  80137f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801382:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  801385:	eb 2a                	jmp    8013b1 <memcmp+0x3e>
		if (*s1 != *s2)
  801387:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80138a:	8a 10                	mov    (%eax),%dl
  80138c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80138f:	8a 00                	mov    (%eax),%al
  801391:	38 c2                	cmp    %al,%dl
  801393:	74 16                	je     8013ab <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  801395:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801398:	8a 00                	mov    (%eax),%al
  80139a:	0f b6 d0             	movzbl %al,%edx
  80139d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8013a0:	8a 00                	mov    (%eax),%al
  8013a2:	0f b6 c0             	movzbl %al,%eax
  8013a5:	29 c2                	sub    %eax,%edx
  8013a7:	89 d0                	mov    %edx,%eax
  8013a9:	eb 18                	jmp    8013c3 <memcmp+0x50>
		s1++, s2++;
  8013ab:	ff 45 fc             	incl   -0x4(%ebp)
  8013ae:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  8013b1:	8b 45 10             	mov    0x10(%ebp),%eax
  8013b4:	8d 50 ff             	lea    -0x1(%eax),%edx
  8013b7:	89 55 10             	mov    %edx,0x10(%ebp)
  8013ba:	85 c0                	test   %eax,%eax
  8013bc:	75 c9                	jne    801387 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  8013be:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8013c3:	c9                   	leave  
  8013c4:	c3                   	ret    

008013c5 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  8013c5:	55                   	push   %ebp
  8013c6:	89 e5                	mov    %esp,%ebp
  8013c8:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  8013cb:	8b 55 08             	mov    0x8(%ebp),%edx
  8013ce:	8b 45 10             	mov    0x10(%ebp),%eax
  8013d1:	01 d0                	add    %edx,%eax
  8013d3:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  8013d6:	eb 15                	jmp    8013ed <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  8013d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8013db:	8a 00                	mov    (%eax),%al
  8013dd:	0f b6 d0             	movzbl %al,%edx
  8013e0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013e3:	0f b6 c0             	movzbl %al,%eax
  8013e6:	39 c2                	cmp    %eax,%edx
  8013e8:	74 0d                	je     8013f7 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  8013ea:	ff 45 08             	incl   0x8(%ebp)
  8013ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8013f0:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  8013f3:	72 e3                	jb     8013d8 <memfind+0x13>
  8013f5:	eb 01                	jmp    8013f8 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  8013f7:	90                   	nop
	return (void *) s;
  8013f8:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8013fb:	c9                   	leave  
  8013fc:	c3                   	ret    

008013fd <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  8013fd:	55                   	push   %ebp
  8013fe:	89 e5                	mov    %esp,%ebp
  801400:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  801403:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  80140a:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801411:	eb 03                	jmp    801416 <strtol+0x19>
		s++;
  801413:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801416:	8b 45 08             	mov    0x8(%ebp),%eax
  801419:	8a 00                	mov    (%eax),%al
  80141b:	3c 20                	cmp    $0x20,%al
  80141d:	74 f4                	je     801413 <strtol+0x16>
  80141f:	8b 45 08             	mov    0x8(%ebp),%eax
  801422:	8a 00                	mov    (%eax),%al
  801424:	3c 09                	cmp    $0x9,%al
  801426:	74 eb                	je     801413 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  801428:	8b 45 08             	mov    0x8(%ebp),%eax
  80142b:	8a 00                	mov    (%eax),%al
  80142d:	3c 2b                	cmp    $0x2b,%al
  80142f:	75 05                	jne    801436 <strtol+0x39>
		s++;
  801431:	ff 45 08             	incl   0x8(%ebp)
  801434:	eb 13                	jmp    801449 <strtol+0x4c>
	else if (*s == '-')
  801436:	8b 45 08             	mov    0x8(%ebp),%eax
  801439:	8a 00                	mov    (%eax),%al
  80143b:	3c 2d                	cmp    $0x2d,%al
  80143d:	75 0a                	jne    801449 <strtol+0x4c>
		s++, neg = 1;
  80143f:	ff 45 08             	incl   0x8(%ebp)
  801442:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801449:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80144d:	74 06                	je     801455 <strtol+0x58>
  80144f:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  801453:	75 20                	jne    801475 <strtol+0x78>
  801455:	8b 45 08             	mov    0x8(%ebp),%eax
  801458:	8a 00                	mov    (%eax),%al
  80145a:	3c 30                	cmp    $0x30,%al
  80145c:	75 17                	jne    801475 <strtol+0x78>
  80145e:	8b 45 08             	mov    0x8(%ebp),%eax
  801461:	40                   	inc    %eax
  801462:	8a 00                	mov    (%eax),%al
  801464:	3c 78                	cmp    $0x78,%al
  801466:	75 0d                	jne    801475 <strtol+0x78>
		s += 2, base = 16;
  801468:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  80146c:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  801473:	eb 28                	jmp    80149d <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  801475:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801479:	75 15                	jne    801490 <strtol+0x93>
  80147b:	8b 45 08             	mov    0x8(%ebp),%eax
  80147e:	8a 00                	mov    (%eax),%al
  801480:	3c 30                	cmp    $0x30,%al
  801482:	75 0c                	jne    801490 <strtol+0x93>
		s++, base = 8;
  801484:	ff 45 08             	incl   0x8(%ebp)
  801487:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  80148e:	eb 0d                	jmp    80149d <strtol+0xa0>
	else if (base == 0)
  801490:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801494:	75 07                	jne    80149d <strtol+0xa0>
		base = 10;
  801496:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  80149d:	8b 45 08             	mov    0x8(%ebp),%eax
  8014a0:	8a 00                	mov    (%eax),%al
  8014a2:	3c 2f                	cmp    $0x2f,%al
  8014a4:	7e 19                	jle    8014bf <strtol+0xc2>
  8014a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8014a9:	8a 00                	mov    (%eax),%al
  8014ab:	3c 39                	cmp    $0x39,%al
  8014ad:	7f 10                	jg     8014bf <strtol+0xc2>
			dig = *s - '0';
  8014af:	8b 45 08             	mov    0x8(%ebp),%eax
  8014b2:	8a 00                	mov    (%eax),%al
  8014b4:	0f be c0             	movsbl %al,%eax
  8014b7:	83 e8 30             	sub    $0x30,%eax
  8014ba:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8014bd:	eb 42                	jmp    801501 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  8014bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8014c2:	8a 00                	mov    (%eax),%al
  8014c4:	3c 60                	cmp    $0x60,%al
  8014c6:	7e 19                	jle    8014e1 <strtol+0xe4>
  8014c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8014cb:	8a 00                	mov    (%eax),%al
  8014cd:	3c 7a                	cmp    $0x7a,%al
  8014cf:	7f 10                	jg     8014e1 <strtol+0xe4>
			dig = *s - 'a' + 10;
  8014d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8014d4:	8a 00                	mov    (%eax),%al
  8014d6:	0f be c0             	movsbl %al,%eax
  8014d9:	83 e8 57             	sub    $0x57,%eax
  8014dc:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8014df:	eb 20                	jmp    801501 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  8014e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8014e4:	8a 00                	mov    (%eax),%al
  8014e6:	3c 40                	cmp    $0x40,%al
  8014e8:	7e 39                	jle    801523 <strtol+0x126>
  8014ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8014ed:	8a 00                	mov    (%eax),%al
  8014ef:	3c 5a                	cmp    $0x5a,%al
  8014f1:	7f 30                	jg     801523 <strtol+0x126>
			dig = *s - 'A' + 10;
  8014f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8014f6:	8a 00                	mov    (%eax),%al
  8014f8:	0f be c0             	movsbl %al,%eax
  8014fb:	83 e8 37             	sub    $0x37,%eax
  8014fe:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  801501:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801504:	3b 45 10             	cmp    0x10(%ebp),%eax
  801507:	7d 19                	jge    801522 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801509:	ff 45 08             	incl   0x8(%ebp)
  80150c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80150f:	0f af 45 10          	imul   0x10(%ebp),%eax
  801513:	89 c2                	mov    %eax,%edx
  801515:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801518:	01 d0                	add    %edx,%eax
  80151a:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  80151d:	e9 7b ff ff ff       	jmp    80149d <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801522:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801523:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801527:	74 08                	je     801531 <strtol+0x134>
		*endptr = (char *) s;
  801529:	8b 45 0c             	mov    0xc(%ebp),%eax
  80152c:	8b 55 08             	mov    0x8(%ebp),%edx
  80152f:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  801531:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801535:	74 07                	je     80153e <strtol+0x141>
  801537:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80153a:	f7 d8                	neg    %eax
  80153c:	eb 03                	jmp    801541 <strtol+0x144>
  80153e:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801541:	c9                   	leave  
  801542:	c3                   	ret    

00801543 <ltostr>:

void
ltostr(long value, char *str)
{
  801543:	55                   	push   %ebp
  801544:	89 e5                	mov    %esp,%ebp
  801546:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  801549:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  801550:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  801557:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80155b:	79 13                	jns    801570 <ltostr+0x2d>
	{
		neg = 1;
  80155d:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  801564:	8b 45 0c             	mov    0xc(%ebp),%eax
  801567:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  80156a:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  80156d:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  801570:	8b 45 08             	mov    0x8(%ebp),%eax
  801573:	b9 0a 00 00 00       	mov    $0xa,%ecx
  801578:	99                   	cltd   
  801579:	f7 f9                	idiv   %ecx
  80157b:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  80157e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801581:	8d 50 01             	lea    0x1(%eax),%edx
  801584:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801587:	89 c2                	mov    %eax,%edx
  801589:	8b 45 0c             	mov    0xc(%ebp),%eax
  80158c:	01 d0                	add    %edx,%eax
  80158e:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801591:	83 c2 30             	add    $0x30,%edx
  801594:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  801596:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801599:	b8 67 66 66 66       	mov    $0x66666667,%eax
  80159e:	f7 e9                	imul   %ecx
  8015a0:	c1 fa 02             	sar    $0x2,%edx
  8015a3:	89 c8                	mov    %ecx,%eax
  8015a5:	c1 f8 1f             	sar    $0x1f,%eax
  8015a8:	29 c2                	sub    %eax,%edx
  8015aa:	89 d0                	mov    %edx,%eax
  8015ac:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  8015af:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8015b3:	75 bb                	jne    801570 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  8015b5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  8015bc:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8015bf:	48                   	dec    %eax
  8015c0:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  8015c3:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8015c7:	74 3d                	je     801606 <ltostr+0xc3>
		start = 1 ;
  8015c9:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  8015d0:	eb 34                	jmp    801606 <ltostr+0xc3>
	{
		char tmp = str[start] ;
  8015d2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8015d5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015d8:	01 d0                	add    %edx,%eax
  8015da:	8a 00                	mov    (%eax),%al
  8015dc:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  8015df:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8015e2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015e5:	01 c2                	add    %eax,%edx
  8015e7:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  8015ea:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015ed:	01 c8                	add    %ecx,%eax
  8015ef:	8a 00                	mov    (%eax),%al
  8015f1:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  8015f3:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8015f6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015f9:	01 c2                	add    %eax,%edx
  8015fb:	8a 45 eb             	mov    -0x15(%ebp),%al
  8015fe:	88 02                	mov    %al,(%edx)
		start++ ;
  801600:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801603:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801606:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801609:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80160c:	7c c4                	jl     8015d2 <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  80160e:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801611:	8b 45 0c             	mov    0xc(%ebp),%eax
  801614:	01 d0                	add    %edx,%eax
  801616:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801619:	90                   	nop
  80161a:	c9                   	leave  
  80161b:	c3                   	ret    

0080161c <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  80161c:	55                   	push   %ebp
  80161d:	89 e5                	mov    %esp,%ebp
  80161f:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801622:	ff 75 08             	pushl  0x8(%ebp)
  801625:	e8 c4 f9 ff ff       	call   800fee <strlen>
  80162a:	83 c4 04             	add    $0x4,%esp
  80162d:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  801630:	ff 75 0c             	pushl  0xc(%ebp)
  801633:	e8 b6 f9 ff ff       	call   800fee <strlen>
  801638:	83 c4 04             	add    $0x4,%esp
  80163b:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  80163e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  801645:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80164c:	eb 17                	jmp    801665 <strcconcat+0x49>
		final[s] = str1[s] ;
  80164e:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801651:	8b 45 10             	mov    0x10(%ebp),%eax
  801654:	01 c2                	add    %eax,%edx
  801656:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801659:	8b 45 08             	mov    0x8(%ebp),%eax
  80165c:	01 c8                	add    %ecx,%eax
  80165e:	8a 00                	mov    (%eax),%al
  801660:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  801662:	ff 45 fc             	incl   -0x4(%ebp)
  801665:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801668:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  80166b:	7c e1                	jl     80164e <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  80166d:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  801674:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  80167b:	eb 1f                	jmp    80169c <strcconcat+0x80>
		final[s++] = str2[i] ;
  80167d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801680:	8d 50 01             	lea    0x1(%eax),%edx
  801683:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801686:	89 c2                	mov    %eax,%edx
  801688:	8b 45 10             	mov    0x10(%ebp),%eax
  80168b:	01 c2                	add    %eax,%edx
  80168d:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801690:	8b 45 0c             	mov    0xc(%ebp),%eax
  801693:	01 c8                	add    %ecx,%eax
  801695:	8a 00                	mov    (%eax),%al
  801697:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801699:	ff 45 f8             	incl   -0x8(%ebp)
  80169c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80169f:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8016a2:	7c d9                	jl     80167d <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  8016a4:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8016a7:	8b 45 10             	mov    0x10(%ebp),%eax
  8016aa:	01 d0                	add    %edx,%eax
  8016ac:	c6 00 00             	movb   $0x0,(%eax)
}
  8016af:	90                   	nop
  8016b0:	c9                   	leave  
  8016b1:	c3                   	ret    

008016b2 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  8016b2:	55                   	push   %ebp
  8016b3:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  8016b5:	8b 45 14             	mov    0x14(%ebp),%eax
  8016b8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  8016be:	8b 45 14             	mov    0x14(%ebp),%eax
  8016c1:	8b 00                	mov    (%eax),%eax
  8016c3:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8016ca:	8b 45 10             	mov    0x10(%ebp),%eax
  8016cd:	01 d0                	add    %edx,%eax
  8016cf:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8016d5:	eb 0c                	jmp    8016e3 <strsplit+0x31>
			*string++ = 0;
  8016d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8016da:	8d 50 01             	lea    0x1(%eax),%edx
  8016dd:	89 55 08             	mov    %edx,0x8(%ebp)
  8016e0:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8016e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8016e6:	8a 00                	mov    (%eax),%al
  8016e8:	84 c0                	test   %al,%al
  8016ea:	74 18                	je     801704 <strsplit+0x52>
  8016ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8016ef:	8a 00                	mov    (%eax),%al
  8016f1:	0f be c0             	movsbl %al,%eax
  8016f4:	50                   	push   %eax
  8016f5:	ff 75 0c             	pushl  0xc(%ebp)
  8016f8:	e8 83 fa ff ff       	call   801180 <strchr>
  8016fd:	83 c4 08             	add    $0x8,%esp
  801700:	85 c0                	test   %eax,%eax
  801702:	75 d3                	jne    8016d7 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801704:	8b 45 08             	mov    0x8(%ebp),%eax
  801707:	8a 00                	mov    (%eax),%al
  801709:	84 c0                	test   %al,%al
  80170b:	74 5a                	je     801767 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  80170d:	8b 45 14             	mov    0x14(%ebp),%eax
  801710:	8b 00                	mov    (%eax),%eax
  801712:	83 f8 0f             	cmp    $0xf,%eax
  801715:	75 07                	jne    80171e <strsplit+0x6c>
		{
			return 0;
  801717:	b8 00 00 00 00       	mov    $0x0,%eax
  80171c:	eb 66                	jmp    801784 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  80171e:	8b 45 14             	mov    0x14(%ebp),%eax
  801721:	8b 00                	mov    (%eax),%eax
  801723:	8d 48 01             	lea    0x1(%eax),%ecx
  801726:	8b 55 14             	mov    0x14(%ebp),%edx
  801729:	89 0a                	mov    %ecx,(%edx)
  80172b:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801732:	8b 45 10             	mov    0x10(%ebp),%eax
  801735:	01 c2                	add    %eax,%edx
  801737:	8b 45 08             	mov    0x8(%ebp),%eax
  80173a:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  80173c:	eb 03                	jmp    801741 <strsplit+0x8f>
			string++;
  80173e:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801741:	8b 45 08             	mov    0x8(%ebp),%eax
  801744:	8a 00                	mov    (%eax),%al
  801746:	84 c0                	test   %al,%al
  801748:	74 8b                	je     8016d5 <strsplit+0x23>
  80174a:	8b 45 08             	mov    0x8(%ebp),%eax
  80174d:	8a 00                	mov    (%eax),%al
  80174f:	0f be c0             	movsbl %al,%eax
  801752:	50                   	push   %eax
  801753:	ff 75 0c             	pushl  0xc(%ebp)
  801756:	e8 25 fa ff ff       	call   801180 <strchr>
  80175b:	83 c4 08             	add    $0x8,%esp
  80175e:	85 c0                	test   %eax,%eax
  801760:	74 dc                	je     80173e <strsplit+0x8c>
			string++;
	}
  801762:	e9 6e ff ff ff       	jmp    8016d5 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801767:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801768:	8b 45 14             	mov    0x14(%ebp),%eax
  80176b:	8b 00                	mov    (%eax),%eax
  80176d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801774:	8b 45 10             	mov    0x10(%ebp),%eax
  801777:	01 d0                	add    %edx,%eax
  801779:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  80177f:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801784:	c9                   	leave  
  801785:	c3                   	ret    

00801786 <str2lower>:


char* str2lower(char *dst, const char *src)
{
  801786:	55                   	push   %ebp
  801787:	89 e5                	mov    %esp,%ebp
  801789:	83 ec 10             	sub    $0x10,%esp
	char* ret = dst;
  80178c:	8b 45 08             	mov    0x8(%ebp),%eax
  80178f:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (int i = 0; i < strlen(src); ++i)
  801792:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801799:	eb 4a                	jmp    8017e5 <str2lower+0x5f>
	{
		dst[i] = src[i] ;
  80179b:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80179e:	8b 45 08             	mov    0x8(%ebp),%eax
  8017a1:	01 c2                	add    %eax,%edx
  8017a3:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8017a6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017a9:	01 c8                	add    %ecx,%eax
  8017ab:	8a 00                	mov    (%eax),%al
  8017ad:	88 02                	mov    %al,(%edx)
		if (src[i] >= 'A' && src[i] <= 'Z')
  8017af:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8017b2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017b5:	01 d0                	add    %edx,%eax
  8017b7:	8a 00                	mov    (%eax),%al
  8017b9:	3c 40                	cmp    $0x40,%al
  8017bb:	7e 25                	jle    8017e2 <str2lower+0x5c>
  8017bd:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8017c0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017c3:	01 d0                	add    %edx,%eax
  8017c5:	8a 00                	mov    (%eax),%al
  8017c7:	3c 5a                	cmp    $0x5a,%al
  8017c9:	7f 17                	jg     8017e2 <str2lower+0x5c>
		{
			dst[i] += 32 ;
  8017cb:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8017ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8017d1:	01 d0                	add    %edx,%eax
  8017d3:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8017d6:	8b 55 08             	mov    0x8(%ebp),%edx
  8017d9:	01 ca                	add    %ecx,%edx
  8017db:	8a 12                	mov    (%edx),%dl
  8017dd:	83 c2 20             	add    $0x20,%edx
  8017e0:	88 10                	mov    %dl,(%eax)


char* str2lower(char *dst, const char *src)
{
	char* ret = dst;
	for (int i = 0; i < strlen(src); ++i)
  8017e2:	ff 45 fc             	incl   -0x4(%ebp)
  8017e5:	ff 75 0c             	pushl  0xc(%ebp)
  8017e8:	e8 01 f8 ff ff       	call   800fee <strlen>
  8017ed:	83 c4 04             	add    $0x4,%esp
  8017f0:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  8017f3:	7f a6                	jg     80179b <str2lower+0x15>
		if (src[i] >= 'A' && src[i] <= 'Z')
		{
			dst[i] += 32 ;
		}
	}
	return ret;
  8017f5:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8017f8:	c9                   	leave  
  8017f9:	c3                   	ret    

008017fa <uheap_init>:
//==============================================
// [1] INITIALIZE USER HEAP:
//==============================================
int __firstTimeFlag = 1;
void uheap_init()
{
  8017fa:	55                   	push   %ebp
  8017fb:	89 e5                	mov    %esp,%ebp
  8017fd:	83 ec 08             	sub    $0x8,%esp
	if(__firstTimeFlag)
  801800:	a1 08 40 80 00       	mov    0x804008,%eax
  801805:	85 c0                	test   %eax,%eax
  801807:	74 42                	je     80184b <uheap_init+0x51>
	{
		initialize_dynamic_allocator(USER_HEAP_START, USER_HEAP_START + DYN_ALLOC_MAX_SIZE);
  801809:	83 ec 08             	sub    $0x8,%esp
  80180c:	68 00 00 00 82       	push   $0x82000000
  801811:	68 00 00 00 80       	push   $0x80000000
  801816:	e8 00 08 00 00       	call   80201b <initialize_dynamic_allocator>
  80181b:	83 c4 10             	add    $0x10,%esp
		uheapPlaceStrategy = sys_get_uheap_strategy();
  80181e:	e8 e7 05 00 00       	call   801e0a <sys_get_uheap_strategy>
  801823:	a3 60 c0 81 00       	mov    %eax,0x81c060
		uheapPageAllocStart = dynAllocEnd + PAGE_SIZE;
  801828:	a1 40 40 80 00       	mov    0x804040,%eax
  80182d:	05 00 10 00 00       	add    $0x1000,%eax
  801832:	a3 10 c1 81 00       	mov    %eax,0x81c110
		uheapPageAllocBreak = uheapPageAllocStart;
  801837:	a1 10 c1 81 00       	mov    0x81c110,%eax
  80183c:	a3 68 c0 81 00       	mov    %eax,0x81c068

		__firstTimeFlag = 0;
  801841:	c7 05 08 40 80 00 00 	movl   $0x0,0x804008
  801848:	00 00 00 
	}
}
  80184b:	90                   	nop
  80184c:	c9                   	leave  
  80184d:	c3                   	ret    

0080184e <get_page>:

//==============================================
// [2] GET A PAGE FROM THE KERNEL FOR DA:
//==============================================
int get_page(void* va)
{
  80184e:	55                   	push   %ebp
  80184f:	89 e5                	mov    %esp,%ebp
  801851:	83 ec 18             	sub    $0x18,%esp
	int ret = __sys_allocate_page(ROUNDDOWN(va, PAGE_SIZE), PERM_USER|PERM_WRITEABLE|PERM_UHPAGE);
  801854:	8b 45 08             	mov    0x8(%ebp),%eax
  801857:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80185a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80185d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801862:	83 ec 08             	sub    $0x8,%esp
  801865:	68 06 04 00 00       	push   $0x406
  80186a:	50                   	push   %eax
  80186b:	e8 e4 01 00 00       	call   801a54 <__sys_allocate_page>
  801870:	83 c4 10             	add    $0x10,%esp
  801873:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (ret < 0)
  801876:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80187a:	79 14                	jns    801890 <get_page+0x42>
		panic("get_page() in user: failed to allocate page from the kernel");
  80187c:	83 ec 04             	sub    $0x4,%esp
  80187f:	68 48 36 80 00       	push   $0x803648
  801884:	6a 1f                	push   $0x1f
  801886:	68 84 36 80 00       	push   $0x803684
  80188b:	e8 a3 12 00 00       	call   802b33 <_panic>
	return 0;
  801890:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801895:	c9                   	leave  
  801896:	c3                   	ret    

00801897 <return_page>:

//==============================================
// [3] RETURN A PAGE FROM THE DA TO KERNEL:
//==============================================
void return_page(void* va)
{
  801897:	55                   	push   %ebp
  801898:	89 e5                	mov    %esp,%ebp
  80189a:	83 ec 18             	sub    $0x18,%esp
	int ret = __sys_unmap_frame(ROUNDDOWN((uint32)va, PAGE_SIZE));
  80189d:	8b 45 08             	mov    0x8(%ebp),%eax
  8018a0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8018a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8018a6:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8018ab:	83 ec 0c             	sub    $0xc,%esp
  8018ae:	50                   	push   %eax
  8018af:	e8 e7 01 00 00       	call   801a9b <__sys_unmap_frame>
  8018b4:	83 c4 10             	add    $0x10,%esp
  8018b7:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (ret < 0)
  8018ba:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8018be:	79 14                	jns    8018d4 <return_page+0x3d>
		panic("return_page() in user: failed to return a page to the kernel");
  8018c0:	83 ec 04             	sub    $0x4,%esp
  8018c3:	68 90 36 80 00       	push   $0x803690
  8018c8:	6a 2a                	push   $0x2a
  8018ca:	68 84 36 80 00       	push   $0x803684
  8018cf:	e8 5f 12 00 00       	call   802b33 <_panic>
}
  8018d4:	90                   	nop
  8018d5:	c9                   	leave  
  8018d6:	c3                   	ret    

008018d7 <malloc>:

//=================================
// [1] ALLOCATE SPACE IN USER HEAP:
//=================================
void* malloc(uint32 size)
{
  8018d7:	55                   	push   %ebp
  8018d8:	89 e5                	mov    %esp,%ebp
  8018da:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  8018dd:	e8 18 ff ff ff       	call   8017fa <uheap_init>
	if (size == 0) return NULL ;
  8018e2:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8018e6:	75 07                	jne    8018ef <malloc+0x18>
  8018e8:	b8 00 00 00 00       	mov    $0x0,%eax
  8018ed:	eb 14                	jmp    801903 <malloc+0x2c>
	//==============================================================
	//TODO: [PROJECT'25.IM#2] USER HEAP - #1 malloc
	//Your code is here
	//Comment the following line
	panic("malloc() is not implemented yet...!!");
  8018ef:	83 ec 04             	sub    $0x4,%esp
  8018f2:	68 d0 36 80 00       	push   $0x8036d0
  8018f7:	6a 3e                	push   $0x3e
  8018f9:	68 84 36 80 00       	push   $0x803684
  8018fe:	e8 30 12 00 00       	call   802b33 <_panic>
}
  801903:	c9                   	leave  
  801904:	c3                   	ret    

00801905 <free>:

//=================================
// [2] FREE SPACE FROM USER HEAP:
//=================================
void free(void* virtual_address)
{
  801905:	55                   	push   %ebp
  801906:	89 e5                	mov    %esp,%ebp
  801908:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.IM#2] USER HEAP - #3 free
	//Your code is here
	//Comment the following line
	panic("free() is not implemented yet...!!");
  80190b:	83 ec 04             	sub    $0x4,%esp
  80190e:	68 f8 36 80 00       	push   $0x8036f8
  801913:	6a 49                	push   $0x49
  801915:	68 84 36 80 00       	push   $0x803684
  80191a:	e8 14 12 00 00       	call   802b33 <_panic>

0080191f <smalloc>:

//=================================
// [3] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  80191f:	55                   	push   %ebp
  801920:	89 e5                	mov    %esp,%ebp
  801922:	83 ec 18             	sub    $0x18,%esp
  801925:	8b 45 10             	mov    0x10(%ebp),%eax
  801928:	88 45 f4             	mov    %al,-0xc(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  80192b:	e8 ca fe ff ff       	call   8017fa <uheap_init>
	if (size == 0) return NULL ;
  801930:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801934:	75 07                	jne    80193d <smalloc+0x1e>
  801936:	b8 00 00 00 00       	mov    $0x0,%eax
  80193b:	eb 14                	jmp    801951 <smalloc+0x32>
	//==============================================================

	//TODO: [PROJECT'25.IM#3] SHARED MEMORY - #2 smalloc
	//Your code is here
	//Comment the following line
	panic("smalloc() is not implemented yet...!!");
  80193d:	83 ec 04             	sub    $0x4,%esp
  801940:	68 1c 37 80 00       	push   $0x80371c
  801945:	6a 5a                	push   $0x5a
  801947:	68 84 36 80 00       	push   $0x803684
  80194c:	e8 e2 11 00 00       	call   802b33 <_panic>
}
  801951:	c9                   	leave  
  801952:	c3                   	ret    

00801953 <sget>:

//========================================
// [4] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801953:	55                   	push   %ebp
  801954:	89 e5                	mov    %esp,%ebp
  801956:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  801959:	e8 9c fe ff ff       	call   8017fa <uheap_init>
	//==============================================================

	//TODO: [PROJECT'25.IM#3] SHARED MEMORY - #4 sget
	//Your code is here
	//Comment the following line
	panic("sget() is not implemented yet...!!");
  80195e:	83 ec 04             	sub    $0x4,%esp
  801961:	68 44 37 80 00       	push   $0x803744
  801966:	6a 6a                	push   $0x6a
  801968:	68 84 36 80 00       	push   $0x803684
  80196d:	e8 c1 11 00 00       	call   802b33 <_panic>

00801972 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801972:	55                   	push   %ebp
  801973:	89 e5                	mov    %esp,%ebp
  801975:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  801978:	e8 7d fe ff ff       	call   8017fa <uheap_init>
	//==============================================================
	panic("realloc() is not implemented yet...!!");
  80197d:	83 ec 04             	sub    $0x4,%esp
  801980:	68 68 37 80 00       	push   $0x803768
  801985:	68 88 00 00 00       	push   $0x88
  80198a:	68 84 36 80 00       	push   $0x803684
  80198f:	e8 9f 11 00 00       	call   802b33 <_panic>

00801994 <sfree>:
//
//	use sys_delete_shared_object(...); which switches to the kernel mode,
//	calls delete_shared_object(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the delete_shared_object() function is empty, make sure to implement it.
void sfree(void* virtual_address)
{
  801994:	55                   	push   %ebp
  801995:	89 e5                	mov    %esp,%ebp
  801997:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.BONUS#5] EXIT #2 - sfree
	//Your code is here
	//Comment the following line
	panic("sfree() is not implemented yet...!!");
  80199a:	83 ec 04             	sub    $0x4,%esp
  80199d:	68 90 37 80 00       	push   $0x803790
  8019a2:	68 9b 00 00 00       	push   $0x9b
  8019a7:	68 84 36 80 00       	push   $0x803684
  8019ac:	e8 82 11 00 00       	call   802b33 <_panic>

008019b1 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  8019b1:	55                   	push   %ebp
  8019b2:	89 e5                	mov    %esp,%ebp
  8019b4:	57                   	push   %edi
  8019b5:	56                   	push   %esi
  8019b6:	53                   	push   %ebx
  8019b7:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8019ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8019bd:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019c0:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8019c3:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8019c6:	8b 7d 18             	mov    0x18(%ebp),%edi
  8019c9:	8b 75 1c             	mov    0x1c(%ebp),%esi
  8019cc:	cd 30                	int    $0x30
  8019ce:	89 45 f0             	mov    %eax,-0x10(%ebp)
				"b" (a3),
				"D" (a4),
				"S" (a5)
				: "cc", "memory");

	return ret;
  8019d1:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8019d4:	83 c4 10             	add    $0x10,%esp
  8019d7:	5b                   	pop    %ebx
  8019d8:	5e                   	pop    %esi
  8019d9:	5f                   	pop    %edi
  8019da:	5d                   	pop    %ebp
  8019db:	c3                   	ret    

008019dc <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName, int color)
{
  8019dc:	55                   	push   %ebp
  8019dd:	89 e5                	mov    %esp,%ebp
  8019df:	83 ec 04             	sub    $0x4,%esp
  8019e2:	8b 45 10             	mov    0x10(%ebp),%eax
  8019e5:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, color, 0);
  8019e8:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8019eb:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8019ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8019f2:	6a 00                	push   $0x0
  8019f4:	51                   	push   %ecx
  8019f5:	52                   	push   %edx
  8019f6:	ff 75 0c             	pushl  0xc(%ebp)
  8019f9:	50                   	push   %eax
  8019fa:	6a 00                	push   $0x0
  8019fc:	e8 b0 ff ff ff       	call   8019b1 <syscall>
  801a01:	83 c4 18             	add    $0x18,%esp
}
  801a04:	90                   	nop
  801a05:	c9                   	leave  
  801a06:	c3                   	ret    

00801a07 <sys_cgetc>:

int
sys_cgetc(void)
{
  801a07:	55                   	push   %ebp
  801a08:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801a0a:	6a 00                	push   $0x0
  801a0c:	6a 00                	push   $0x0
  801a0e:	6a 00                	push   $0x0
  801a10:	6a 00                	push   $0x0
  801a12:	6a 00                	push   $0x0
  801a14:	6a 02                	push   $0x2
  801a16:	e8 96 ff ff ff       	call   8019b1 <syscall>
  801a1b:	83 c4 18             	add    $0x18,%esp
}
  801a1e:	c9                   	leave  
  801a1f:	c3                   	ret    

00801a20 <sys_lock_cons>:

void sys_lock_cons(void)
{
  801a20:	55                   	push   %ebp
  801a21:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  801a23:	6a 00                	push   $0x0
  801a25:	6a 00                	push   $0x0
  801a27:	6a 00                	push   $0x0
  801a29:	6a 00                	push   $0x0
  801a2b:	6a 00                	push   $0x0
  801a2d:	6a 03                	push   $0x3
  801a2f:	e8 7d ff ff ff       	call   8019b1 <syscall>
  801a34:	83 c4 18             	add    $0x18,%esp
}
  801a37:	90                   	nop
  801a38:	c9                   	leave  
  801a39:	c3                   	ret    

00801a3a <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  801a3a:	55                   	push   %ebp
  801a3b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  801a3d:	6a 00                	push   $0x0
  801a3f:	6a 00                	push   $0x0
  801a41:	6a 00                	push   $0x0
  801a43:	6a 00                	push   $0x0
  801a45:	6a 00                	push   $0x0
  801a47:	6a 04                	push   $0x4
  801a49:	e8 63 ff ff ff       	call   8019b1 <syscall>
  801a4e:	83 c4 18             	add    $0x18,%esp
}
  801a51:	90                   	nop
  801a52:	c9                   	leave  
  801a53:	c3                   	ret    

00801a54 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801a54:	55                   	push   %ebp
  801a55:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801a57:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a5a:	8b 45 08             	mov    0x8(%ebp),%eax
  801a5d:	6a 00                	push   $0x0
  801a5f:	6a 00                	push   $0x0
  801a61:	6a 00                	push   $0x0
  801a63:	52                   	push   %edx
  801a64:	50                   	push   %eax
  801a65:	6a 08                	push   $0x8
  801a67:	e8 45 ff ff ff       	call   8019b1 <syscall>
  801a6c:	83 c4 18             	add    $0x18,%esp
}
  801a6f:	c9                   	leave  
  801a70:	c3                   	ret    

00801a71 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801a71:	55                   	push   %ebp
  801a72:	89 e5                	mov    %esp,%ebp
  801a74:	56                   	push   %esi
  801a75:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801a76:	8b 75 18             	mov    0x18(%ebp),%esi
  801a79:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801a7c:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801a7f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a82:	8b 45 08             	mov    0x8(%ebp),%eax
  801a85:	56                   	push   %esi
  801a86:	53                   	push   %ebx
  801a87:	51                   	push   %ecx
  801a88:	52                   	push   %edx
  801a89:	50                   	push   %eax
  801a8a:	6a 09                	push   $0x9
  801a8c:	e8 20 ff ff ff       	call   8019b1 <syscall>
  801a91:	83 c4 18             	add    $0x18,%esp
}
  801a94:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801a97:	5b                   	pop    %ebx
  801a98:	5e                   	pop    %esi
  801a99:	5d                   	pop    %ebp
  801a9a:	c3                   	ret    

00801a9b <__sys_unmap_frame>:

int __sys_unmap_frame(uint32 va)
{
  801a9b:	55                   	push   %ebp
  801a9c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, va, 0, 0, 0, 0);
  801a9e:	6a 00                	push   $0x0
  801aa0:	6a 00                	push   $0x0
  801aa2:	6a 00                	push   $0x0
  801aa4:	6a 00                	push   $0x0
  801aa6:	ff 75 08             	pushl  0x8(%ebp)
  801aa9:	6a 0a                	push   $0xa
  801aab:	e8 01 ff ff ff       	call   8019b1 <syscall>
  801ab0:	83 c4 18             	add    $0x18,%esp
}
  801ab3:	c9                   	leave  
  801ab4:	c3                   	ret    

00801ab5 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801ab5:	55                   	push   %ebp
  801ab6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801ab8:	6a 00                	push   $0x0
  801aba:	6a 00                	push   $0x0
  801abc:	6a 00                	push   $0x0
  801abe:	ff 75 0c             	pushl  0xc(%ebp)
  801ac1:	ff 75 08             	pushl  0x8(%ebp)
  801ac4:	6a 0b                	push   $0xb
  801ac6:	e8 e6 fe ff ff       	call   8019b1 <syscall>
  801acb:	83 c4 18             	add    $0x18,%esp
}
  801ace:	c9                   	leave  
  801acf:	c3                   	ret    

00801ad0 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801ad0:	55                   	push   %ebp
  801ad1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801ad3:	6a 00                	push   $0x0
  801ad5:	6a 00                	push   $0x0
  801ad7:	6a 00                	push   $0x0
  801ad9:	6a 00                	push   $0x0
  801adb:	6a 00                	push   $0x0
  801add:	6a 0c                	push   $0xc
  801adf:	e8 cd fe ff ff       	call   8019b1 <syscall>
  801ae4:	83 c4 18             	add    $0x18,%esp
}
  801ae7:	c9                   	leave  
  801ae8:	c3                   	ret    

00801ae9 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801ae9:	55                   	push   %ebp
  801aea:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801aec:	6a 00                	push   $0x0
  801aee:	6a 00                	push   $0x0
  801af0:	6a 00                	push   $0x0
  801af2:	6a 00                	push   $0x0
  801af4:	6a 00                	push   $0x0
  801af6:	6a 0d                	push   $0xd
  801af8:	e8 b4 fe ff ff       	call   8019b1 <syscall>
  801afd:	83 c4 18             	add    $0x18,%esp
}
  801b00:	c9                   	leave  
  801b01:	c3                   	ret    

00801b02 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801b02:	55                   	push   %ebp
  801b03:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801b05:	6a 00                	push   $0x0
  801b07:	6a 00                	push   $0x0
  801b09:	6a 00                	push   $0x0
  801b0b:	6a 00                	push   $0x0
  801b0d:	6a 00                	push   $0x0
  801b0f:	6a 0e                	push   $0xe
  801b11:	e8 9b fe ff ff       	call   8019b1 <syscall>
  801b16:	83 c4 18             	add    $0x18,%esp
}
  801b19:	c9                   	leave  
  801b1a:	c3                   	ret    

00801b1b <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801b1b:	55                   	push   %ebp
  801b1c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801b1e:	6a 00                	push   $0x0
  801b20:	6a 00                	push   $0x0
  801b22:	6a 00                	push   $0x0
  801b24:	6a 00                	push   $0x0
  801b26:	6a 00                	push   $0x0
  801b28:	6a 0f                	push   $0xf
  801b2a:	e8 82 fe ff ff       	call   8019b1 <syscall>
  801b2f:	83 c4 18             	add    $0x18,%esp
}
  801b32:	c9                   	leave  
  801b33:	c3                   	ret    

00801b34 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801b34:	55                   	push   %ebp
  801b35:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801b37:	6a 00                	push   $0x0
  801b39:	6a 00                	push   $0x0
  801b3b:	6a 00                	push   $0x0
  801b3d:	6a 00                	push   $0x0
  801b3f:	ff 75 08             	pushl  0x8(%ebp)
  801b42:	6a 10                	push   $0x10
  801b44:	e8 68 fe ff ff       	call   8019b1 <syscall>
  801b49:	83 c4 18             	add    $0x18,%esp
}
  801b4c:	c9                   	leave  
  801b4d:	c3                   	ret    

00801b4e <sys_scarce_memory>:

void sys_scarce_memory()
{
  801b4e:	55                   	push   %ebp
  801b4f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801b51:	6a 00                	push   $0x0
  801b53:	6a 00                	push   $0x0
  801b55:	6a 00                	push   $0x0
  801b57:	6a 00                	push   $0x0
  801b59:	6a 00                	push   $0x0
  801b5b:	6a 11                	push   $0x11
  801b5d:	e8 4f fe ff ff       	call   8019b1 <syscall>
  801b62:	83 c4 18             	add    $0x18,%esp
}
  801b65:	90                   	nop
  801b66:	c9                   	leave  
  801b67:	c3                   	ret    

00801b68 <sys_cputc>:

void
sys_cputc(const char c)
{
  801b68:	55                   	push   %ebp
  801b69:	89 e5                	mov    %esp,%ebp
  801b6b:	83 ec 04             	sub    $0x4,%esp
  801b6e:	8b 45 08             	mov    0x8(%ebp),%eax
  801b71:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801b74:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801b78:	6a 00                	push   $0x0
  801b7a:	6a 00                	push   $0x0
  801b7c:	6a 00                	push   $0x0
  801b7e:	6a 00                	push   $0x0
  801b80:	50                   	push   %eax
  801b81:	6a 01                	push   $0x1
  801b83:	e8 29 fe ff ff       	call   8019b1 <syscall>
  801b88:	83 c4 18             	add    $0x18,%esp
}
  801b8b:	90                   	nop
  801b8c:	c9                   	leave  
  801b8d:	c3                   	ret    

00801b8e <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801b8e:	55                   	push   %ebp
  801b8f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801b91:	6a 00                	push   $0x0
  801b93:	6a 00                	push   $0x0
  801b95:	6a 00                	push   $0x0
  801b97:	6a 00                	push   $0x0
  801b99:	6a 00                	push   $0x0
  801b9b:	6a 14                	push   $0x14
  801b9d:	e8 0f fe ff ff       	call   8019b1 <syscall>
  801ba2:	83 c4 18             	add    $0x18,%esp
}
  801ba5:	90                   	nop
  801ba6:	c9                   	leave  
  801ba7:	c3                   	ret    

00801ba8 <sys_create_shared_object>:

int sys_create_shared_object(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801ba8:	55                   	push   %ebp
  801ba9:	89 e5                	mov    %esp,%ebp
  801bab:	83 ec 04             	sub    $0x4,%esp
  801bae:	8b 45 10             	mov    0x10(%ebp),%eax
  801bb1:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801bb4:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801bb7:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801bbb:	8b 45 08             	mov    0x8(%ebp),%eax
  801bbe:	6a 00                	push   $0x0
  801bc0:	51                   	push   %ecx
  801bc1:	52                   	push   %edx
  801bc2:	ff 75 0c             	pushl  0xc(%ebp)
  801bc5:	50                   	push   %eax
  801bc6:	6a 15                	push   $0x15
  801bc8:	e8 e4 fd ff ff       	call   8019b1 <syscall>
  801bcd:	83 c4 18             	add    $0x18,%esp
}
  801bd0:	c9                   	leave  
  801bd1:	c3                   	ret    

00801bd2 <sys_size_of_shared_object>:

//2017:
int sys_size_of_shared_object(int32 ownerID, char* shareName)
{
  801bd2:	55                   	push   %ebp
  801bd3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801bd5:	8b 55 0c             	mov    0xc(%ebp),%edx
  801bd8:	8b 45 08             	mov    0x8(%ebp),%eax
  801bdb:	6a 00                	push   $0x0
  801bdd:	6a 00                	push   $0x0
  801bdf:	6a 00                	push   $0x0
  801be1:	52                   	push   %edx
  801be2:	50                   	push   %eax
  801be3:	6a 16                	push   $0x16
  801be5:	e8 c7 fd ff ff       	call   8019b1 <syscall>
  801bea:	83 c4 18             	add    $0x18,%esp
}
  801bed:	c9                   	leave  
  801bee:	c3                   	ret    

00801bef <sys_get_shared_object>:
//==========

int sys_get_shared_object(int32 ownerID, char* shareName, void* virtual_address)
{
  801bef:	55                   	push   %ebp
  801bf0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801bf2:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801bf5:	8b 55 0c             	mov    0xc(%ebp),%edx
  801bf8:	8b 45 08             	mov    0x8(%ebp),%eax
  801bfb:	6a 00                	push   $0x0
  801bfd:	6a 00                	push   $0x0
  801bff:	51                   	push   %ecx
  801c00:	52                   	push   %edx
  801c01:	50                   	push   %eax
  801c02:	6a 17                	push   $0x17
  801c04:	e8 a8 fd ff ff       	call   8019b1 <syscall>
  801c09:	83 c4 18             	add    $0x18,%esp
}
  801c0c:	c9                   	leave  
  801c0d:	c3                   	ret    

00801c0e <sys_delete_shared_object>:

int sys_delete_shared_object(int32 sharedObjectID, void *startVA)
{
  801c0e:	55                   	push   %ebp
  801c0f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801c11:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c14:	8b 45 08             	mov    0x8(%ebp),%eax
  801c17:	6a 00                	push   $0x0
  801c19:	6a 00                	push   $0x0
  801c1b:	6a 00                	push   $0x0
  801c1d:	52                   	push   %edx
  801c1e:	50                   	push   %eax
  801c1f:	6a 18                	push   $0x18
  801c21:	e8 8b fd ff ff       	call   8019b1 <syscall>
  801c26:	83 c4 18             	add    $0x18,%esp
}
  801c29:	c9                   	leave  
  801c2a:	c3                   	ret    

00801c2b <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801c2b:	55                   	push   %ebp
  801c2c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801c2e:	8b 45 08             	mov    0x8(%ebp),%eax
  801c31:	6a 00                	push   $0x0
  801c33:	ff 75 14             	pushl  0x14(%ebp)
  801c36:	ff 75 10             	pushl  0x10(%ebp)
  801c39:	ff 75 0c             	pushl  0xc(%ebp)
  801c3c:	50                   	push   %eax
  801c3d:	6a 19                	push   $0x19
  801c3f:	e8 6d fd ff ff       	call   8019b1 <syscall>
  801c44:	83 c4 18             	add    $0x18,%esp
}
  801c47:	c9                   	leave  
  801c48:	c3                   	ret    

00801c49 <sys_run_env>:

void sys_run_env(int32 envId)
{
  801c49:	55                   	push   %ebp
  801c4a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801c4c:	8b 45 08             	mov    0x8(%ebp),%eax
  801c4f:	6a 00                	push   $0x0
  801c51:	6a 00                	push   $0x0
  801c53:	6a 00                	push   $0x0
  801c55:	6a 00                	push   $0x0
  801c57:	50                   	push   %eax
  801c58:	6a 1a                	push   $0x1a
  801c5a:	e8 52 fd ff ff       	call   8019b1 <syscall>
  801c5f:	83 c4 18             	add    $0x18,%esp
}
  801c62:	90                   	nop
  801c63:	c9                   	leave  
  801c64:	c3                   	ret    

00801c65 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801c65:	55                   	push   %ebp
  801c66:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801c68:	8b 45 08             	mov    0x8(%ebp),%eax
  801c6b:	6a 00                	push   $0x0
  801c6d:	6a 00                	push   $0x0
  801c6f:	6a 00                	push   $0x0
  801c71:	6a 00                	push   $0x0
  801c73:	50                   	push   %eax
  801c74:	6a 1b                	push   $0x1b
  801c76:	e8 36 fd ff ff       	call   8019b1 <syscall>
  801c7b:	83 c4 18             	add    $0x18,%esp
}
  801c7e:	c9                   	leave  
  801c7f:	c3                   	ret    

00801c80 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801c80:	55                   	push   %ebp
  801c81:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801c83:	6a 00                	push   $0x0
  801c85:	6a 00                	push   $0x0
  801c87:	6a 00                	push   $0x0
  801c89:	6a 00                	push   $0x0
  801c8b:	6a 00                	push   $0x0
  801c8d:	6a 05                	push   $0x5
  801c8f:	e8 1d fd ff ff       	call   8019b1 <syscall>
  801c94:	83 c4 18             	add    $0x18,%esp
}
  801c97:	c9                   	leave  
  801c98:	c3                   	ret    

00801c99 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801c99:	55                   	push   %ebp
  801c9a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801c9c:	6a 00                	push   $0x0
  801c9e:	6a 00                	push   $0x0
  801ca0:	6a 00                	push   $0x0
  801ca2:	6a 00                	push   $0x0
  801ca4:	6a 00                	push   $0x0
  801ca6:	6a 06                	push   $0x6
  801ca8:	e8 04 fd ff ff       	call   8019b1 <syscall>
  801cad:	83 c4 18             	add    $0x18,%esp
}
  801cb0:	c9                   	leave  
  801cb1:	c3                   	ret    

00801cb2 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801cb2:	55                   	push   %ebp
  801cb3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801cb5:	6a 00                	push   $0x0
  801cb7:	6a 00                	push   $0x0
  801cb9:	6a 00                	push   $0x0
  801cbb:	6a 00                	push   $0x0
  801cbd:	6a 00                	push   $0x0
  801cbf:	6a 07                	push   $0x7
  801cc1:	e8 eb fc ff ff       	call   8019b1 <syscall>
  801cc6:	83 c4 18             	add    $0x18,%esp
}
  801cc9:	c9                   	leave  
  801cca:	c3                   	ret    

00801ccb <sys_exit_env>:


void sys_exit_env(void)
{
  801ccb:	55                   	push   %ebp
  801ccc:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801cce:	6a 00                	push   $0x0
  801cd0:	6a 00                	push   $0x0
  801cd2:	6a 00                	push   $0x0
  801cd4:	6a 00                	push   $0x0
  801cd6:	6a 00                	push   $0x0
  801cd8:	6a 1c                	push   $0x1c
  801cda:	e8 d2 fc ff ff       	call   8019b1 <syscall>
  801cdf:	83 c4 18             	add    $0x18,%esp
}
  801ce2:	90                   	nop
  801ce3:	c9                   	leave  
  801ce4:	c3                   	ret    

00801ce5 <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  801ce5:	55                   	push   %ebp
  801ce6:	89 e5                	mov    %esp,%ebp
  801ce8:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801ceb:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801cee:	8d 50 04             	lea    0x4(%eax),%edx
  801cf1:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801cf4:	6a 00                	push   $0x0
  801cf6:	6a 00                	push   $0x0
  801cf8:	6a 00                	push   $0x0
  801cfa:	52                   	push   %edx
  801cfb:	50                   	push   %eax
  801cfc:	6a 1d                	push   $0x1d
  801cfe:	e8 ae fc ff ff       	call   8019b1 <syscall>
  801d03:	83 c4 18             	add    $0x18,%esp
	return result;
  801d06:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801d09:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801d0c:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801d0f:	89 01                	mov    %eax,(%ecx)
  801d11:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801d14:	8b 45 08             	mov    0x8(%ebp),%eax
  801d17:	c9                   	leave  
  801d18:	c2 04 00             	ret    $0x4

00801d1b <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801d1b:	55                   	push   %ebp
  801d1c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801d1e:	6a 00                	push   $0x0
  801d20:	6a 00                	push   $0x0
  801d22:	ff 75 10             	pushl  0x10(%ebp)
  801d25:	ff 75 0c             	pushl  0xc(%ebp)
  801d28:	ff 75 08             	pushl  0x8(%ebp)
  801d2b:	6a 13                	push   $0x13
  801d2d:	e8 7f fc ff ff       	call   8019b1 <syscall>
  801d32:	83 c4 18             	add    $0x18,%esp
	return ;
  801d35:	90                   	nop
}
  801d36:	c9                   	leave  
  801d37:	c3                   	ret    

00801d38 <sys_rcr2>:
uint32 sys_rcr2()
{
  801d38:	55                   	push   %ebp
  801d39:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801d3b:	6a 00                	push   $0x0
  801d3d:	6a 00                	push   $0x0
  801d3f:	6a 00                	push   $0x0
  801d41:	6a 00                	push   $0x0
  801d43:	6a 00                	push   $0x0
  801d45:	6a 1e                	push   $0x1e
  801d47:	e8 65 fc ff ff       	call   8019b1 <syscall>
  801d4c:	83 c4 18             	add    $0x18,%esp
}
  801d4f:	c9                   	leave  
  801d50:	c3                   	ret    

00801d51 <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  801d51:	55                   	push   %ebp
  801d52:	89 e5                	mov    %esp,%ebp
  801d54:	83 ec 04             	sub    $0x4,%esp
  801d57:	8b 45 08             	mov    0x8(%ebp),%eax
  801d5a:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801d5d:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801d61:	6a 00                	push   $0x0
  801d63:	6a 00                	push   $0x0
  801d65:	6a 00                	push   $0x0
  801d67:	6a 00                	push   $0x0
  801d69:	50                   	push   %eax
  801d6a:	6a 1f                	push   $0x1f
  801d6c:	e8 40 fc ff ff       	call   8019b1 <syscall>
  801d71:	83 c4 18             	add    $0x18,%esp
	return ;
  801d74:	90                   	nop
}
  801d75:	c9                   	leave  
  801d76:	c3                   	ret    

00801d77 <rsttst>:
void rsttst()
{
  801d77:	55                   	push   %ebp
  801d78:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801d7a:	6a 00                	push   $0x0
  801d7c:	6a 00                	push   $0x0
  801d7e:	6a 00                	push   $0x0
  801d80:	6a 00                	push   $0x0
  801d82:	6a 00                	push   $0x0
  801d84:	6a 21                	push   $0x21
  801d86:	e8 26 fc ff ff       	call   8019b1 <syscall>
  801d8b:	83 c4 18             	add    $0x18,%esp
	return ;
  801d8e:	90                   	nop
}
  801d8f:	c9                   	leave  
  801d90:	c3                   	ret    

00801d91 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801d91:	55                   	push   %ebp
  801d92:	89 e5                	mov    %esp,%ebp
  801d94:	83 ec 04             	sub    $0x4,%esp
  801d97:	8b 45 14             	mov    0x14(%ebp),%eax
  801d9a:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801d9d:	8b 55 18             	mov    0x18(%ebp),%edx
  801da0:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801da4:	52                   	push   %edx
  801da5:	50                   	push   %eax
  801da6:	ff 75 10             	pushl  0x10(%ebp)
  801da9:	ff 75 0c             	pushl  0xc(%ebp)
  801dac:	ff 75 08             	pushl  0x8(%ebp)
  801daf:	6a 20                	push   $0x20
  801db1:	e8 fb fb ff ff       	call   8019b1 <syscall>
  801db6:	83 c4 18             	add    $0x18,%esp
	return ;
  801db9:	90                   	nop
}
  801dba:	c9                   	leave  
  801dbb:	c3                   	ret    

00801dbc <chktst>:
void chktst(uint32 n)
{
  801dbc:	55                   	push   %ebp
  801dbd:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801dbf:	6a 00                	push   $0x0
  801dc1:	6a 00                	push   $0x0
  801dc3:	6a 00                	push   $0x0
  801dc5:	6a 00                	push   $0x0
  801dc7:	ff 75 08             	pushl  0x8(%ebp)
  801dca:	6a 22                	push   $0x22
  801dcc:	e8 e0 fb ff ff       	call   8019b1 <syscall>
  801dd1:	83 c4 18             	add    $0x18,%esp
	return ;
  801dd4:	90                   	nop
}
  801dd5:	c9                   	leave  
  801dd6:	c3                   	ret    

00801dd7 <inctst>:

void inctst()
{
  801dd7:	55                   	push   %ebp
  801dd8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801dda:	6a 00                	push   $0x0
  801ddc:	6a 00                	push   $0x0
  801dde:	6a 00                	push   $0x0
  801de0:	6a 00                	push   $0x0
  801de2:	6a 00                	push   $0x0
  801de4:	6a 23                	push   $0x23
  801de6:	e8 c6 fb ff ff       	call   8019b1 <syscall>
  801deb:	83 c4 18             	add    $0x18,%esp
	return ;
  801dee:	90                   	nop
}
  801def:	c9                   	leave  
  801df0:	c3                   	ret    

00801df1 <gettst>:
uint32 gettst()
{
  801df1:	55                   	push   %ebp
  801df2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801df4:	6a 00                	push   $0x0
  801df6:	6a 00                	push   $0x0
  801df8:	6a 00                	push   $0x0
  801dfa:	6a 00                	push   $0x0
  801dfc:	6a 00                	push   $0x0
  801dfe:	6a 24                	push   $0x24
  801e00:	e8 ac fb ff ff       	call   8019b1 <syscall>
  801e05:	83 c4 18             	add    $0x18,%esp
}
  801e08:	c9                   	leave  
  801e09:	c3                   	ret    

00801e0a <sys_get_uheap_strategy>:

/*2025*/
uint32 sys_get_uheap_strategy()
{
  801e0a:	55                   	push   %ebp
  801e0b:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801e0d:	6a 00                	push   $0x0
  801e0f:	6a 00                	push   $0x0
  801e11:	6a 00                	push   $0x0
  801e13:	6a 00                	push   $0x0
  801e15:	6a 00                	push   $0x0
  801e17:	6a 25                	push   $0x25
  801e19:	e8 93 fb ff ff       	call   8019b1 <syscall>
  801e1e:	83 c4 18             	add    $0x18,%esp
  801e21:	a3 60 c0 81 00       	mov    %eax,0x81c060
	return uheapPlaceStrategy ;
  801e26:	a1 60 c0 81 00       	mov    0x81c060,%eax
}
  801e2b:	c9                   	leave  
  801e2c:	c3                   	ret    

00801e2d <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801e2d:	55                   	push   %ebp
  801e2e:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = heapStrategy;
  801e30:	8b 45 08             	mov    0x8(%ebp),%eax
  801e33:	a3 60 c0 81 00       	mov    %eax,0x81c060
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801e38:	6a 00                	push   $0x0
  801e3a:	6a 00                	push   $0x0
  801e3c:	6a 00                	push   $0x0
  801e3e:	6a 00                	push   $0x0
  801e40:	ff 75 08             	pushl  0x8(%ebp)
  801e43:	6a 26                	push   $0x26
  801e45:	e8 67 fb ff ff       	call   8019b1 <syscall>
  801e4a:	83 c4 18             	add    $0x18,%esp
	return ;
  801e4d:	90                   	nop
}
  801e4e:	c9                   	leave  
  801e4f:	c3                   	ret    

00801e50 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801e50:	55                   	push   %ebp
  801e51:	89 e5                	mov    %esp,%ebp
  801e53:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801e54:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801e57:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801e5a:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e5d:	8b 45 08             	mov    0x8(%ebp),%eax
  801e60:	6a 00                	push   $0x0
  801e62:	53                   	push   %ebx
  801e63:	51                   	push   %ecx
  801e64:	52                   	push   %edx
  801e65:	50                   	push   %eax
  801e66:	6a 27                	push   $0x27
  801e68:	e8 44 fb ff ff       	call   8019b1 <syscall>
  801e6d:	83 c4 18             	add    $0x18,%esp
}
  801e70:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801e73:	c9                   	leave  
  801e74:	c3                   	ret    

00801e75 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801e75:	55                   	push   %ebp
  801e76:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801e78:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e7b:	8b 45 08             	mov    0x8(%ebp),%eax
  801e7e:	6a 00                	push   $0x0
  801e80:	6a 00                	push   $0x0
  801e82:	6a 00                	push   $0x0
  801e84:	52                   	push   %edx
  801e85:	50                   	push   %eax
  801e86:	6a 28                	push   $0x28
  801e88:	e8 24 fb ff ff       	call   8019b1 <syscall>
  801e8d:	83 c4 18             	add    $0x18,%esp
}
  801e90:	c9                   	leave  
  801e91:	c3                   	ret    

00801e92 <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  801e92:	55                   	push   %ebp
  801e93:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  801e95:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801e98:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e9b:	8b 45 08             	mov    0x8(%ebp),%eax
  801e9e:	6a 00                	push   $0x0
  801ea0:	51                   	push   %ecx
  801ea1:	ff 75 10             	pushl  0x10(%ebp)
  801ea4:	52                   	push   %edx
  801ea5:	50                   	push   %eax
  801ea6:	6a 29                	push   $0x29
  801ea8:	e8 04 fb ff ff       	call   8019b1 <syscall>
  801ead:	83 c4 18             	add    $0x18,%esp
}
  801eb0:	c9                   	leave  
  801eb1:	c3                   	ret    

00801eb2 <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801eb2:	55                   	push   %ebp
  801eb3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801eb5:	6a 00                	push   $0x0
  801eb7:	6a 00                	push   $0x0
  801eb9:	ff 75 10             	pushl  0x10(%ebp)
  801ebc:	ff 75 0c             	pushl  0xc(%ebp)
  801ebf:	ff 75 08             	pushl  0x8(%ebp)
  801ec2:	6a 12                	push   $0x12
  801ec4:	e8 e8 fa ff ff       	call   8019b1 <syscall>
  801ec9:	83 c4 18             	add    $0x18,%esp
	return ;
  801ecc:	90                   	nop
}
  801ecd:	c9                   	leave  
  801ece:	c3                   	ret    

00801ecf <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  801ecf:	55                   	push   %ebp
  801ed0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  801ed2:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ed5:	8b 45 08             	mov    0x8(%ebp),%eax
  801ed8:	6a 00                	push   $0x0
  801eda:	6a 00                	push   $0x0
  801edc:	6a 00                	push   $0x0
  801ede:	52                   	push   %edx
  801edf:	50                   	push   %eax
  801ee0:	6a 2a                	push   $0x2a
  801ee2:	e8 ca fa ff ff       	call   8019b1 <syscall>
  801ee7:	83 c4 18             	add    $0x18,%esp
	return;
  801eea:	90                   	nop
}
  801eeb:	c9                   	leave  
  801eec:	c3                   	ret    

00801eed <sys_get_optimal_num_faults>:
/*2025*/
int sys_get_optimal_num_faults()
{
  801eed:	55                   	push   %ebp
  801eee:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_optimal_num_faults, 0, 0, 0, 0, 0);
  801ef0:	6a 00                	push   $0x0
  801ef2:	6a 00                	push   $0x0
  801ef4:	6a 00                	push   $0x0
  801ef6:	6a 00                	push   $0x0
  801ef8:	6a 00                	push   $0x0
  801efa:	6a 2b                	push   $0x2b
  801efc:	e8 b0 fa ff ff       	call   8019b1 <syscall>
  801f01:	83 c4 18             	add    $0x18,%esp
}
  801f04:	c9                   	leave  
  801f05:	c3                   	ret    

00801f06 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801f06:	55                   	push   %ebp
  801f07:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801f09:	6a 00                	push   $0x0
  801f0b:	6a 00                	push   $0x0
  801f0d:	6a 00                	push   $0x0
  801f0f:	ff 75 0c             	pushl  0xc(%ebp)
  801f12:	ff 75 08             	pushl  0x8(%ebp)
  801f15:	6a 2d                	push   $0x2d
  801f17:	e8 95 fa ff ff       	call   8019b1 <syscall>
  801f1c:	83 c4 18             	add    $0x18,%esp
	return;
  801f1f:	90                   	nop
}
  801f20:	c9                   	leave  
  801f21:	c3                   	ret    

00801f22 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801f22:	55                   	push   %ebp
  801f23:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801f25:	6a 00                	push   $0x0
  801f27:	6a 00                	push   $0x0
  801f29:	6a 00                	push   $0x0
  801f2b:	ff 75 0c             	pushl  0xc(%ebp)
  801f2e:	ff 75 08             	pushl  0x8(%ebp)
  801f31:	6a 2c                	push   $0x2c
  801f33:	e8 79 fa ff ff       	call   8019b1 <syscall>
  801f38:	83 c4 18             	add    $0x18,%esp
	return ;
  801f3b:	90                   	nop
}
  801f3c:	c9                   	leave  
  801f3d:	c3                   	ret    

00801f3e <sys_env_set_priority>:


void sys_env_set_priority(int32 envID, int priority)
{
  801f3e:	55                   	push   %ebp
  801f3f:	89 e5                	mov    %esp,%ebp
  801f41:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.IM#4] CPU SCHEDULING - #1 System Calls - Add suitable code here
	//Your code is here
	//Comment the following line
	panic("sys_env_set_priority() is not implemented yet...!!");
  801f44:	83 ec 04             	sub    $0x4,%esp
  801f47:	68 b4 37 80 00       	push   $0x8037b4
  801f4c:	68 25 01 00 00       	push   $0x125
  801f51:	68 e7 37 80 00       	push   $0x8037e7
  801f56:	e8 d8 0b 00 00       	call   802b33 <_panic>

00801f5b <to_page_va>:
//==================================
//==================================
// [1] GET PAGE VA:
//==================================
__inline__ uint32 to_page_va(struct PageInfoElement *ptrPageInfo)
{
  801f5b:	55                   	push   %ebp
  801f5c:	89 e5                	mov    %esp,%ebp
  801f5e:	83 ec 18             	sub    $0x18,%esp
	if (ptrPageInfo < &pageBlockInfoArr[0] || ptrPageInfo >= &pageBlockInfoArr[DYN_ALLOC_MAX_SIZE/PAGE_SIZE])
  801f61:	81 7d 08 60 40 80 00 	cmpl   $0x804060,0x8(%ebp)
  801f68:	72 09                	jb     801f73 <to_page_va+0x18>
  801f6a:	81 7d 08 60 c0 81 00 	cmpl   $0x81c060,0x8(%ebp)
  801f71:	72 14                	jb     801f87 <to_page_va+0x2c>
			panic("to_page_va called with invalid pageInfoPtr");
  801f73:	83 ec 04             	sub    $0x4,%esp
  801f76:	68 f8 37 80 00       	push   $0x8037f8
  801f7b:	6a 15                	push   $0x15
  801f7d:	68 23 38 80 00       	push   $0x803823
  801f82:	e8 ac 0b 00 00       	call   802b33 <_panic>
	//Get start VA of the page from the corresponding Page Info pointer
	int idxInPageInfoArr = (ptrPageInfo - pageBlockInfoArr);
  801f87:	8b 45 08             	mov    0x8(%ebp),%eax
  801f8a:	ba 60 40 80 00       	mov    $0x804060,%edx
  801f8f:	29 d0                	sub    %edx,%eax
  801f91:	c1 f8 02             	sar    $0x2,%eax
  801f94:	89 c2                	mov    %eax,%edx
  801f96:	89 d0                	mov    %edx,%eax
  801f98:	c1 e0 02             	shl    $0x2,%eax
  801f9b:	01 d0                	add    %edx,%eax
  801f9d:	c1 e0 02             	shl    $0x2,%eax
  801fa0:	01 d0                	add    %edx,%eax
  801fa2:	c1 e0 02             	shl    $0x2,%eax
  801fa5:	01 d0                	add    %edx,%eax
  801fa7:	89 c1                	mov    %eax,%ecx
  801fa9:	c1 e1 08             	shl    $0x8,%ecx
  801fac:	01 c8                	add    %ecx,%eax
  801fae:	89 c1                	mov    %eax,%ecx
  801fb0:	c1 e1 10             	shl    $0x10,%ecx
  801fb3:	01 c8                	add    %ecx,%eax
  801fb5:	01 c0                	add    %eax,%eax
  801fb7:	01 d0                	add    %edx,%eax
  801fb9:	89 45 f4             	mov    %eax,-0xc(%ebp)
	return dynAllocStart + (idxInPageInfoArr << PGSHIFT);
  801fbc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fbf:	c1 e0 0c             	shl    $0xc,%eax
  801fc2:	89 c2                	mov    %eax,%edx
  801fc4:	a1 64 c0 81 00       	mov    0x81c064,%eax
  801fc9:	01 d0                	add    %edx,%eax
}
  801fcb:	c9                   	leave  
  801fcc:	c3                   	ret    

00801fcd <to_page_info>:

//==================================
// [2] GET PAGE INFO OF PAGE VA:
//==================================
__inline__ struct PageInfoElement * to_page_info(uint32 va)
{
  801fcd:	55                   	push   %ebp
  801fce:	89 e5                	mov    %esp,%ebp
  801fd0:	83 ec 18             	sub    $0x18,%esp
	int idxInPageInfoArr = (va - dynAllocStart) >> PGSHIFT;
  801fd3:	a1 64 c0 81 00       	mov    0x81c064,%eax
  801fd8:	8b 55 08             	mov    0x8(%ebp),%edx
  801fdb:	29 c2                	sub    %eax,%edx
  801fdd:	89 d0                	mov    %edx,%eax
  801fdf:	c1 e8 0c             	shr    $0xc,%eax
  801fe2:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if (idxInPageInfoArr < 0 || idxInPageInfoArr >= DYN_ALLOC_MAX_SIZE/PAGE_SIZE)
  801fe5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801fe9:	78 09                	js     801ff4 <to_page_info+0x27>
  801feb:	81 7d f4 ff 1f 00 00 	cmpl   $0x1fff,-0xc(%ebp)
  801ff2:	7e 14                	jle    802008 <to_page_info+0x3b>
		panic("to_page_info called with invalid pa");
  801ff4:	83 ec 04             	sub    $0x4,%esp
  801ff7:	68 3c 38 80 00       	push   $0x80383c
  801ffc:	6a 22                	push   $0x22
  801ffe:	68 23 38 80 00       	push   $0x803823
  802003:	e8 2b 0b 00 00       	call   802b33 <_panic>
	return &pageBlockInfoArr[idxInPageInfoArr];
  802008:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80200b:	89 d0                	mov    %edx,%eax
  80200d:	01 c0                	add    %eax,%eax
  80200f:	01 d0                	add    %edx,%eax
  802011:	c1 e0 02             	shl    $0x2,%eax
  802014:	05 60 40 80 00       	add    $0x804060,%eax
}
  802019:	c9                   	leave  
  80201a:	c3                   	ret    

0080201b <initialize_dynamic_allocator>:
//==================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================
bool is_initialized = 0;
void initialize_dynamic_allocator(uint32 daStart, uint32 daEnd)
{
  80201b:	55                   	push   %ebp
  80201c:	89 e5                	mov    %esp,%ebp
  80201e:	83 ec 18             	sub    $0x18,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		assert(daEnd <= daStart + DYN_ALLOC_MAX_SIZE);
  802021:	8b 45 08             	mov    0x8(%ebp),%eax
  802024:	05 00 00 00 02       	add    $0x2000000,%eax
  802029:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80202c:	73 16                	jae    802044 <initialize_dynamic_allocator+0x29>
  80202e:	68 60 38 80 00       	push   $0x803860
  802033:	68 86 38 80 00       	push   $0x803886
  802038:	6a 34                	push   $0x34
  80203a:	68 23 38 80 00       	push   $0x803823
  80203f:	e8 ef 0a 00 00       	call   802b33 <_panic>
		is_initialized = 1;
  802044:	c7 05 24 40 80 00 01 	movl   $0x1,0x804024
  80204b:	00 00 00 
	//==================================================================================
	//==================================================================================
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #1 initialize_dynamic_allocator
	//Your code is here
	// init bounds of the dynalloc
	dynAllocStart = daStart;
  80204e:	8b 45 08             	mov    0x8(%ebp),%eax
  802051:	a3 64 c0 81 00       	mov    %eax,0x81c064
	dynAllocEnd = daEnd;
  802056:	8b 45 0c             	mov    0xc(%ebp),%eax
  802059:	a3 40 40 80 00       	mov    %eax,0x804040
	// init the list that keep track of all free pageBlockInfoArr instances.
	LIST_INIT(&freePagesList);
  80205e:	c7 05 48 40 80 00 00 	movl   $0x0,0x804048
  802065:	00 00 00 
  802068:	c7 05 4c 40 80 00 00 	movl   $0x0,0x80404c
  80206f:	00 00 00 
  802072:	c7 05 54 40 80 00 00 	movl   $0x0,0x804054
  802079:	00 00 00 

	// no.of pages in the dynamic allocator.
	int pCount = (daEnd - daStart) / PAGE_SIZE;
  80207c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80207f:	2b 45 08             	sub    0x8(%ebp),%eax
  802082:	c1 e8 0c             	shr    $0xc,%eax
  802085:	89 45 ec             	mov    %eax,-0x14(%ebp)
	// iterate over each page and init its data in pageBlockInfoArr and reset it.
	for (int i = 0; i < pCount; ++i) {
  802088:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  80208f:	e9 c8 00 00 00       	jmp    80215c <initialize_dynamic_allocator+0x141>
	    pageBlockInfoArr[i].block_size = 0;
  802094:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802097:	89 d0                	mov    %edx,%eax
  802099:	01 c0                	add    %eax,%eax
  80209b:	01 d0                	add    %edx,%eax
  80209d:	c1 e0 02             	shl    $0x2,%eax
  8020a0:	05 68 40 80 00       	add    $0x804068,%eax
  8020a5:	66 c7 00 00 00       	movw   $0x0,(%eax)
	    pageBlockInfoArr[i].num_of_free_blocks = 0;
  8020aa:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8020ad:	89 d0                	mov    %edx,%eax
  8020af:	01 c0                	add    %eax,%eax
  8020b1:	01 d0                	add    %edx,%eax
  8020b3:	c1 e0 02             	shl    $0x2,%eax
  8020b6:	05 6a 40 80 00       	add    $0x80406a,%eax
  8020bb:	66 c7 00 00 00       	movw   $0x0,(%eax)
	    LIST_INSERT_TAIL(&freePagesList, &pageBlockInfoArr[i]);
  8020c0:	8b 15 4c 40 80 00    	mov    0x80404c,%edx
  8020c6:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  8020c9:	89 c8                	mov    %ecx,%eax
  8020cb:	01 c0                	add    %eax,%eax
  8020cd:	01 c8                	add    %ecx,%eax
  8020cf:	c1 e0 02             	shl    $0x2,%eax
  8020d2:	05 64 40 80 00       	add    $0x804064,%eax
  8020d7:	89 10                	mov    %edx,(%eax)
  8020d9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8020dc:	89 d0                	mov    %edx,%eax
  8020de:	01 c0                	add    %eax,%eax
  8020e0:	01 d0                	add    %edx,%eax
  8020e2:	c1 e0 02             	shl    $0x2,%eax
  8020e5:	05 64 40 80 00       	add    $0x804064,%eax
  8020ea:	8b 00                	mov    (%eax),%eax
  8020ec:	85 c0                	test   %eax,%eax
  8020ee:	74 1b                	je     80210b <initialize_dynamic_allocator+0xf0>
  8020f0:	8b 15 4c 40 80 00    	mov    0x80404c,%edx
  8020f6:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  8020f9:	89 c8                	mov    %ecx,%eax
  8020fb:	01 c0                	add    %eax,%eax
  8020fd:	01 c8                	add    %ecx,%eax
  8020ff:	c1 e0 02             	shl    $0x2,%eax
  802102:	05 60 40 80 00       	add    $0x804060,%eax
  802107:	89 02                	mov    %eax,(%edx)
  802109:	eb 16                	jmp    802121 <initialize_dynamic_allocator+0x106>
  80210b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80210e:	89 d0                	mov    %edx,%eax
  802110:	01 c0                	add    %eax,%eax
  802112:	01 d0                	add    %edx,%eax
  802114:	c1 e0 02             	shl    $0x2,%eax
  802117:	05 60 40 80 00       	add    $0x804060,%eax
  80211c:	a3 48 40 80 00       	mov    %eax,0x804048
  802121:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802124:	89 d0                	mov    %edx,%eax
  802126:	01 c0                	add    %eax,%eax
  802128:	01 d0                	add    %edx,%eax
  80212a:	c1 e0 02             	shl    $0x2,%eax
  80212d:	05 60 40 80 00       	add    $0x804060,%eax
  802132:	a3 4c 40 80 00       	mov    %eax,0x80404c
  802137:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80213a:	89 d0                	mov    %edx,%eax
  80213c:	01 c0                	add    %eax,%eax
  80213e:	01 d0                	add    %edx,%eax
  802140:	c1 e0 02             	shl    $0x2,%eax
  802143:	05 60 40 80 00       	add    $0x804060,%eax
  802148:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80214e:	a1 54 40 80 00       	mov    0x804054,%eax
  802153:	40                   	inc    %eax
  802154:	a3 54 40 80 00       	mov    %eax,0x804054
	LIST_INIT(&freePagesList);

	// no.of pages in the dynamic allocator.
	int pCount = (daEnd - daStart) / PAGE_SIZE;
	// iterate over each page and init its data in pageBlockInfoArr and reset it.
	for (int i = 0; i < pCount; ++i) {
  802159:	ff 45 f4             	incl   -0xc(%ebp)
  80215c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80215f:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  802162:	0f 8c 2c ff ff ff    	jl     802094 <initialize_dynamic_allocator+0x79>
	    LIST_INSERT_TAIL(&freePagesList, &pageBlockInfoArr[i]);
	}
	// init the array of lists of each size..
	// 8 16 32 64 128 256 512 1024 2056
	// 0 1  2  3   4  5    6   7    8
	for (int i = 0; i <= (LOG2_MAX_SIZE - LOG2_MIN_SIZE); ++i){
  802168:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80216f:	eb 36                	jmp    8021a7 <initialize_dynamic_allocator+0x18c>
		LIST_INIT(&freeBlockLists[i]);
  802171:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802174:	c1 e0 04             	shl    $0x4,%eax
  802177:	05 80 c0 81 00       	add    $0x81c080,%eax
  80217c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802182:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802185:	c1 e0 04             	shl    $0x4,%eax
  802188:	05 84 c0 81 00       	add    $0x81c084,%eax
  80218d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802193:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802196:	c1 e0 04             	shl    $0x4,%eax
  802199:	05 8c c0 81 00       	add    $0x81c08c,%eax
  80219e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	    LIST_INSERT_TAIL(&freePagesList, &pageBlockInfoArr[i]);
	}
	// init the array of lists of each size..
	// 8 16 32 64 128 256 512 1024 2056
	// 0 1  2  3   4  5    6   7    8
	for (int i = 0; i <= (LOG2_MAX_SIZE - LOG2_MIN_SIZE); ++i){
  8021a4:	ff 45 f0             	incl   -0x10(%ebp)
  8021a7:	83 7d f0 08          	cmpl   $0x8,-0x10(%ebp)
  8021ab:	7e c4                	jle    802171 <initialize_dynamic_allocator+0x156>
		LIST_INIT(&freeBlockLists[i]);
	}
	//Comment the following line
	//panic("initialize_dynamic_allocator() Not implemented yet");

}
  8021ad:	90                   	nop
  8021ae:	c9                   	leave  
  8021af:	c3                   	ret    

008021b0 <get_block_size>:

//===========================
// [2] GET BLOCK SIZE:
//===========================
__inline__ uint32 get_block_size(void *va)
{
  8021b0:	55                   	push   %ebp
  8021b1:	89 e5                	mov    %esp,%ebp
  8021b3:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #2 get_block_size
	//Your code is here
	// get the page that saves this va
	struct PageInfoElement* ptr = to_page_info((uint32)va);
  8021b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8021b9:	83 ec 0c             	sub    $0xc,%esp
  8021bc:	50                   	push   %eax
  8021bd:	e8 0b fe ff ff       	call   801fcd <to_page_info>
  8021c2:	83 c4 10             	add    $0x10,%esp
  8021c5:	89 45 f4             	mov    %eax,-0xc(%ebp)
	return ptr->block_size;
  8021c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021cb:	8b 40 08             	mov    0x8(%eax),%eax
  8021ce:	0f b7 c0             	movzwl %ax,%eax
	//Comment the following line
	//panic("get_block_size() Not implemented yet");
}
  8021d1:	c9                   	leave  
  8021d2:	c3                   	ret    

008021d3 <split_page_to_blocks>:
// =====================
// h) split page to blocks and add them in freeBlockLists
// =====================
// function that split the page provided into same sized blocks
//and putem in suitable freeblockList index according to size.
 void split_page_to_blocks(uint32 blk_size, struct PageInfoElement *pageInfo) {
  8021d3:	55                   	push   %ebp
  8021d4:	89 e5                	mov    %esp,%ebp
  8021d6:	83 ec 28             	sub    $0x28,%esp
	 // cur page virtual address by the pageInfo.
	 uint32 page_va = (uint32)to_page_va(pageInfo);
  8021d9:	83 ec 0c             	sub    $0xc,%esp
  8021dc:	ff 75 0c             	pushl  0xc(%ebp)
  8021df:	e8 77 fd ff ff       	call   801f5b <to_page_va>
  8021e4:	83 c4 10             	add    $0x10,%esp
  8021e7:	89 45 e8             	mov    %eax,-0x18(%ebp)
	 // no. of blks to save in freeblockList.
	 int blk_count = PAGE_SIZE / blk_size;
  8021ea:	b8 00 10 00 00       	mov    $0x1000,%eax
  8021ef:	ba 00 00 00 00       	mov    $0x0,%edx
  8021f4:	f7 75 08             	divl   0x8(%ebp)
  8021f7:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	 // save page in memory.
	 get_page((uint32*)page_va);
  8021fa:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8021fd:	83 ec 0c             	sub    $0xc,%esp
  802200:	50                   	push   %eax
  802201:	e8 48 f6 ff ff       	call   80184e <get_page>
  802206:	83 c4 10             	add    $0x10,%esp
	 // assigning the pageInfo data block size, free block which is whole block count.
	 pageInfo->num_of_free_blocks = blk_count;
  802209:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80220c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80220f:	66 89 42 0a          	mov    %ax,0xa(%edx)
	 pageInfo->block_size = blk_size;
  802213:	8b 45 08             	mov    0x8(%ebp),%eax
  802216:	8b 55 0c             	mov    0xc(%ebp),%edx
  802219:	66 89 42 08          	mov    %ax,0x8(%edx)
	 // get index by size block in freeblocklist.
	 int idx = 0;
  80221d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	 for (int i = LOG2_MIN_SIZE; i <= LOG2_MAX_SIZE; i++) {
  802224:	c7 45 f0 03 00 00 00 	movl   $0x3,-0x10(%ebp)
  80222b:	eb 19                	jmp    802246 <split_page_to_blocks+0x73>
	     if ((1 << i) == blk_size)
  80222d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802230:	ba 01 00 00 00       	mov    $0x1,%edx
  802235:	88 c1                	mov    %al,%cl
  802237:	d3 e2                	shl    %cl,%edx
  802239:	89 d0                	mov    %edx,%eax
  80223b:	3b 45 08             	cmp    0x8(%ebp),%eax
  80223e:	74 0e                	je     80224e <split_page_to_blocks+0x7b>
	         break;
	     idx++;
  802240:	ff 45 f4             	incl   -0xc(%ebp)
	 // assigning the pageInfo data block size, free block which is whole block count.
	 pageInfo->num_of_free_blocks = blk_count;
	 pageInfo->block_size = blk_size;
	 // get index by size block in freeblocklist.
	 int idx = 0;
	 for (int i = LOG2_MIN_SIZE; i <= LOG2_MAX_SIZE; i++) {
  802243:	ff 45 f0             	incl   -0x10(%ebp)
  802246:	83 7d f0 0b          	cmpl   $0xb,-0x10(%ebp)
  80224a:	7e e1                	jle    80222d <split_page_to_blocks+0x5a>
  80224c:	eb 01                	jmp    80224f <split_page_to_blocks+0x7c>
	     if ((1 << i) == blk_size)
	         break;
  80224e:	90                   	nop
	     idx++;
	 }
	 // iterate over each blk and make and element of it by passing its address in blockElement pointer and save those in the list.
	 // starting from the page_va.
	 for (uint32 i = 0; i < blk_count; ++i) {
  80224f:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  802256:	e9 a7 00 00 00       	jmp    802302 <split_page_to_blocks+0x12f>
	     struct BlockElement *blk =(struct BlockElement*)(page_va + i * blk_size);
  80225b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80225e:	0f af 45 08          	imul   0x8(%ebp),%eax
  802262:	89 c2                	mov    %eax,%edx
  802264:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802267:	01 d0                	add    %edx,%eax
  802269:	89 45 e0             	mov    %eax,-0x20(%ebp)
	     LIST_INSERT_TAIL(&freeBlockLists[idx],blk);
  80226c:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  802270:	75 14                	jne    802286 <split_page_to_blocks+0xb3>
  802272:	83 ec 04             	sub    $0x4,%esp
  802275:	68 9c 38 80 00       	push   $0x80389c
  80227a:	6a 7c                	push   $0x7c
  80227c:	68 23 38 80 00       	push   $0x803823
  802281:	e8 ad 08 00 00       	call   802b33 <_panic>
  802286:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802289:	c1 e0 04             	shl    $0x4,%eax
  80228c:	05 84 c0 81 00       	add    $0x81c084,%eax
  802291:	8b 10                	mov    (%eax),%edx
  802293:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802296:	89 50 04             	mov    %edx,0x4(%eax)
  802299:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80229c:	8b 40 04             	mov    0x4(%eax),%eax
  80229f:	85 c0                	test   %eax,%eax
  8022a1:	74 14                	je     8022b7 <split_page_to_blocks+0xe4>
  8022a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022a6:	c1 e0 04             	shl    $0x4,%eax
  8022a9:	05 84 c0 81 00       	add    $0x81c084,%eax
  8022ae:	8b 00                	mov    (%eax),%eax
  8022b0:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8022b3:	89 10                	mov    %edx,(%eax)
  8022b5:	eb 11                	jmp    8022c8 <split_page_to_blocks+0xf5>
  8022b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022ba:	c1 e0 04             	shl    $0x4,%eax
  8022bd:	8d 90 80 c0 81 00    	lea    0x81c080(%eax),%edx
  8022c3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8022c6:	89 02                	mov    %eax,(%edx)
  8022c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022cb:	c1 e0 04             	shl    $0x4,%eax
  8022ce:	8d 90 84 c0 81 00    	lea    0x81c084(%eax),%edx
  8022d4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8022d7:	89 02                	mov    %eax,(%edx)
  8022d9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8022dc:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8022e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022e5:	c1 e0 04             	shl    $0x4,%eax
  8022e8:	05 8c c0 81 00       	add    $0x81c08c,%eax
  8022ed:	8b 00                	mov    (%eax),%eax
  8022ef:	8d 50 01             	lea    0x1(%eax),%edx
  8022f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022f5:	c1 e0 04             	shl    $0x4,%eax
  8022f8:	05 8c c0 81 00       	add    $0x81c08c,%eax
  8022fd:	89 10                	mov    %edx,(%eax)
	         break;
	     idx++;
	 }
	 // iterate over each blk and make and element of it by passing its address in blockElement pointer and save those in the list.
	 // starting from the page_va.
	 for (uint32 i = 0; i < blk_count; ++i) {
  8022ff:	ff 45 ec             	incl   -0x14(%ebp)
  802302:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802305:	39 45 ec             	cmp    %eax,-0x14(%ebp)
  802308:	0f 82 4d ff ff ff    	jb     80225b <split_page_to_blocks+0x88>
	     struct BlockElement *blk =(struct BlockElement*)(page_va + i * blk_size);
	     LIST_INSERT_TAIL(&freeBlockLists[idx],blk);
	 }
 }
  80230e:	90                   	nop
  80230f:	c9                   	leave  
  802310:	c3                   	ret    

00802311 <alloc_block>:

//===========================
// 3) ALLOCATE BLOCK:
//===========================
void *alloc_block(uint32 size)
{
  802311:	55                   	push   %ebp
  802312:	89 e5                	mov    %esp,%ebp
  802314:	83 ec 38             	sub    $0x38,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		assert(size <= DYN_ALLOC_MAX_BLOCK_SIZE);
  802317:	81 7d 08 00 08 00 00 	cmpl   $0x800,0x8(%ebp)
  80231e:	76 19                	jbe    802339 <alloc_block+0x28>
  802320:	68 c0 38 80 00       	push   $0x8038c0
  802325:	68 86 38 80 00       	push   $0x803886
  80232a:	68 8a 00 00 00       	push   $0x8a
  80232f:	68 23 38 80 00       	push   $0x803823
  802334:	e8 fa 07 00 00       	call   802b33 <_panic>
	//==================================================================================
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #3 alloc_block
	//Your code is here
	//Comment the following line
	// get index in freeBlockList by size.
	uint32 idx = 0;
  802339:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int i = LOG2_MIN_SIZE; i <= LOG2_MAX_SIZE; ++i){
  802340:	c7 45 f0 03 00 00 00 	movl   $0x3,-0x10(%ebp)
  802347:	eb 19                	jmp    802362 <alloc_block+0x51>
		if((1 << i) >= size) break;
  802349:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80234c:	ba 01 00 00 00       	mov    $0x1,%edx
  802351:	88 c1                	mov    %al,%cl
  802353:	d3 e2                	shl    %cl,%edx
  802355:	89 d0                	mov    %edx,%eax
  802357:	3b 45 08             	cmp    0x8(%ebp),%eax
  80235a:	73 0e                	jae    80236a <alloc_block+0x59>
		idx++;
  80235c:	ff 45 f4             	incl   -0xc(%ebp)
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #3 alloc_block
	//Your code is here
	//Comment the following line
	// get index in freeBlockList by size.
	uint32 idx = 0;
	for (int i = LOG2_MIN_SIZE; i <= LOG2_MAX_SIZE; ++i){
  80235f:	ff 45 f0             	incl   -0x10(%ebp)
  802362:	83 7d f0 0b          	cmpl   $0xb,-0x10(%ebp)
  802366:	7e e1                	jle    802349 <alloc_block+0x38>
  802368:	eb 01                	jmp    80236b <alloc_block+0x5a>
		if((1 << i) >= size) break;
  80236a:	90                   	nop
		idx++;
	}

	//case 1: the free block of the cur size is available.
	if (freeBlockLists[idx].size > 0) {
  80236b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80236e:	c1 e0 04             	shl    $0x4,%eax
  802371:	05 8c c0 81 00       	add    $0x81c08c,%eax
  802376:	8b 00                	mov    (%eax),%eax
  802378:	85 c0                	test   %eax,%eax
  80237a:	0f 84 df 00 00 00    	je     80245f <alloc_block+0x14e>

		// remove from the list and updat the pageInfoArr free blocks.
		// pop from the freeBlockList.
		struct BlockElement *blk = LIST_FIRST(&freeBlockLists[idx]);
  802380:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802383:	c1 e0 04             	shl    $0x4,%eax
  802386:	05 80 c0 81 00       	add    $0x81c080,%eax
  80238b:	8b 00                	mov    (%eax),%eax
  80238d:	89 45 ec             	mov    %eax,-0x14(%ebp)
	    LIST_REMOVE(&freeBlockLists[idx], blk);
  802390:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802394:	75 17                	jne    8023ad <alloc_block+0x9c>
  802396:	83 ec 04             	sub    $0x4,%esp
  802399:	68 e1 38 80 00       	push   $0x8038e1
  80239e:	68 9e 00 00 00       	push   $0x9e
  8023a3:	68 23 38 80 00       	push   $0x803823
  8023a8:	e8 86 07 00 00       	call   802b33 <_panic>
  8023ad:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8023b0:	8b 00                	mov    (%eax),%eax
  8023b2:	85 c0                	test   %eax,%eax
  8023b4:	74 10                	je     8023c6 <alloc_block+0xb5>
  8023b6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8023b9:	8b 00                	mov    (%eax),%eax
  8023bb:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8023be:	8b 52 04             	mov    0x4(%edx),%edx
  8023c1:	89 50 04             	mov    %edx,0x4(%eax)
  8023c4:	eb 14                	jmp    8023da <alloc_block+0xc9>
  8023c6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8023c9:	8b 40 04             	mov    0x4(%eax),%eax
  8023cc:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8023cf:	c1 e2 04             	shl    $0x4,%edx
  8023d2:	81 c2 84 c0 81 00    	add    $0x81c084,%edx
  8023d8:	89 02                	mov    %eax,(%edx)
  8023da:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8023dd:	8b 40 04             	mov    0x4(%eax),%eax
  8023e0:	85 c0                	test   %eax,%eax
  8023e2:	74 0f                	je     8023f3 <alloc_block+0xe2>
  8023e4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8023e7:	8b 40 04             	mov    0x4(%eax),%eax
  8023ea:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8023ed:	8b 12                	mov    (%edx),%edx
  8023ef:	89 10                	mov    %edx,(%eax)
  8023f1:	eb 13                	jmp    802406 <alloc_block+0xf5>
  8023f3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8023f6:	8b 00                	mov    (%eax),%eax
  8023f8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8023fb:	c1 e2 04             	shl    $0x4,%edx
  8023fe:	81 c2 80 c0 81 00    	add    $0x81c080,%edx
  802404:	89 02                	mov    %eax,(%edx)
  802406:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802409:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80240f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802412:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802419:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80241c:	c1 e0 04             	shl    $0x4,%eax
  80241f:	05 8c c0 81 00       	add    $0x81c08c,%eax
  802424:	8b 00                	mov    (%eax),%eax
  802426:	8d 50 ff             	lea    -0x1(%eax),%edx
  802429:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80242c:	c1 e0 04             	shl    $0x4,%eax
  80242f:	05 8c c0 81 00       	add    $0x81c08c,%eax
  802434:	89 10                	mov    %edx,(%eax)
	    // update pageBlockInfoArr
	    struct PageInfoElement *pageInfo = to_page_info((uint32)blk);
  802436:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802439:	83 ec 0c             	sub    $0xc,%esp
  80243c:	50                   	push   %eax
  80243d:	e8 8b fb ff ff       	call   801fcd <to_page_info>
  802442:	83 c4 10             	add    $0x10,%esp
  802445:	89 45 e8             	mov    %eax,-0x18(%ebp)
	    pageInfo->num_of_free_blocks--;
  802448:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80244b:	66 8b 40 0a          	mov    0xa(%eax),%ax
  80244f:	48                   	dec    %eax
  802450:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802453:	66 89 42 0a          	mov    %ax,0xa(%edx)
	    return blk;
  802457:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80245a:	e9 bc 02 00 00       	jmp    80271b <alloc_block+0x40a>
	}else{ //case(2, 3): 2. no free blocks available in the freeblocklist but there is free pages.
				//3. no free blocks and no available freepages so search in higher block sizes.
		// case 2:
		if(freePagesList.size > 0){ //have free pages.
  80245f:	a1 54 40 80 00       	mov    0x804054,%eax
  802464:	85 c0                	test   %eax,%eax
  802466:	0f 84 7d 02 00 00    	je     8026e9 <alloc_block+0x3d8>
			// get page to split and use from freepagesList.
			struct PageInfoElement *ptr_new_page = LIST_FIRST(&freePagesList);
  80246c:	a1 48 40 80 00       	mov    0x804048,%eax
  802471:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			LIST_REMOVE(&freePagesList, ptr_new_page);
  802474:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  802478:	75 17                	jne    802491 <alloc_block+0x180>
  80247a:	83 ec 04             	sub    $0x4,%esp
  80247d:	68 e1 38 80 00       	push   $0x8038e1
  802482:	68 a9 00 00 00       	push   $0xa9
  802487:	68 23 38 80 00       	push   $0x803823
  80248c:	e8 a2 06 00 00       	call   802b33 <_panic>
  802491:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802494:	8b 00                	mov    (%eax),%eax
  802496:	85 c0                	test   %eax,%eax
  802498:	74 10                	je     8024aa <alloc_block+0x199>
  80249a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80249d:	8b 00                	mov    (%eax),%eax
  80249f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8024a2:	8b 52 04             	mov    0x4(%edx),%edx
  8024a5:	89 50 04             	mov    %edx,0x4(%eax)
  8024a8:	eb 0b                	jmp    8024b5 <alloc_block+0x1a4>
  8024aa:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8024ad:	8b 40 04             	mov    0x4(%eax),%eax
  8024b0:	a3 4c 40 80 00       	mov    %eax,0x80404c
  8024b5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8024b8:	8b 40 04             	mov    0x4(%eax),%eax
  8024bb:	85 c0                	test   %eax,%eax
  8024bd:	74 0f                	je     8024ce <alloc_block+0x1bd>
  8024bf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8024c2:	8b 40 04             	mov    0x4(%eax),%eax
  8024c5:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8024c8:	8b 12                	mov    (%edx),%edx
  8024ca:	89 10                	mov    %edx,(%eax)
  8024cc:	eb 0a                	jmp    8024d8 <alloc_block+0x1c7>
  8024ce:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8024d1:	8b 00                	mov    (%eax),%eax
  8024d3:	a3 48 40 80 00       	mov    %eax,0x804048
  8024d8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8024db:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8024e1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8024e4:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8024eb:	a1 54 40 80 00       	mov    0x804054,%eax
  8024f0:	48                   	dec    %eax
  8024f1:	a3 54 40 80 00       	mov    %eax,0x804054
			// from page to freeblockList by the pageInfo and the block size.
			split_page_to_blocks(1 << (idx + LOG2_MIN_SIZE), ptr_new_page);
  8024f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024f9:	83 c0 03             	add    $0x3,%eax
  8024fc:	ba 01 00 00 00       	mov    $0x1,%edx
  802501:	88 c1                	mov    %al,%cl
  802503:	d3 e2                	shl    %cl,%edx
  802505:	89 d0                	mov    %edx,%eax
  802507:	83 ec 08             	sub    $0x8,%esp
  80250a:	ff 75 e4             	pushl  -0x1c(%ebp)
  80250d:	50                   	push   %eax
  80250e:	e8 c0 fc ff ff       	call   8021d3 <split_page_to_blocks>
  802513:	83 c4 10             	add    $0x10,%esp

			// remove from the list and updat the pageInfoArr free blocks.
			// pop from the freeBlockList.
			struct BlockElement *blk = LIST_FIRST(&freeBlockLists[idx]);
  802516:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802519:	c1 e0 04             	shl    $0x4,%eax
  80251c:	05 80 c0 81 00       	add    $0x81c080,%eax
  802521:	8b 00                	mov    (%eax),%eax
  802523:	89 45 e0             	mov    %eax,-0x20(%ebp)
		    LIST_REMOVE(&freeBlockLists[idx], blk);
  802526:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80252a:	75 17                	jne    802543 <alloc_block+0x232>
  80252c:	83 ec 04             	sub    $0x4,%esp
  80252f:	68 e1 38 80 00       	push   $0x8038e1
  802534:	68 b0 00 00 00       	push   $0xb0
  802539:	68 23 38 80 00       	push   $0x803823
  80253e:	e8 f0 05 00 00       	call   802b33 <_panic>
  802543:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802546:	8b 00                	mov    (%eax),%eax
  802548:	85 c0                	test   %eax,%eax
  80254a:	74 10                	je     80255c <alloc_block+0x24b>
  80254c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80254f:	8b 00                	mov    (%eax),%eax
  802551:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802554:	8b 52 04             	mov    0x4(%edx),%edx
  802557:	89 50 04             	mov    %edx,0x4(%eax)
  80255a:	eb 14                	jmp    802570 <alloc_block+0x25f>
  80255c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80255f:	8b 40 04             	mov    0x4(%eax),%eax
  802562:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802565:	c1 e2 04             	shl    $0x4,%edx
  802568:	81 c2 84 c0 81 00    	add    $0x81c084,%edx
  80256e:	89 02                	mov    %eax,(%edx)
  802570:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802573:	8b 40 04             	mov    0x4(%eax),%eax
  802576:	85 c0                	test   %eax,%eax
  802578:	74 0f                	je     802589 <alloc_block+0x278>
  80257a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80257d:	8b 40 04             	mov    0x4(%eax),%eax
  802580:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802583:	8b 12                	mov    (%edx),%edx
  802585:	89 10                	mov    %edx,(%eax)
  802587:	eb 13                	jmp    80259c <alloc_block+0x28b>
  802589:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80258c:	8b 00                	mov    (%eax),%eax
  80258e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802591:	c1 e2 04             	shl    $0x4,%edx
  802594:	81 c2 80 c0 81 00    	add    $0x81c080,%edx
  80259a:	89 02                	mov    %eax,(%edx)
  80259c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80259f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8025a5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8025a8:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8025af:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025b2:	c1 e0 04             	shl    $0x4,%eax
  8025b5:	05 8c c0 81 00       	add    $0x81c08c,%eax
  8025ba:	8b 00                	mov    (%eax),%eax
  8025bc:	8d 50 ff             	lea    -0x1(%eax),%edx
  8025bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025c2:	c1 e0 04             	shl    $0x4,%eax
  8025c5:	05 8c c0 81 00       	add    $0x81c08c,%eax
  8025ca:	89 10                	mov    %edx,(%eax)
		    // update pageBlockInfoArr
		    struct PageInfoElement *pageInfo = to_page_info((uint32)blk);
  8025cc:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8025cf:	83 ec 0c             	sub    $0xc,%esp
  8025d2:	50                   	push   %eax
  8025d3:	e8 f5 f9 ff ff       	call   801fcd <to_page_info>
  8025d8:	83 c4 10             	add    $0x10,%esp
  8025db:	89 45 dc             	mov    %eax,-0x24(%ebp)
		    pageInfo->num_of_free_blocks--;
  8025de:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8025e1:	66 8b 40 0a          	mov    0xa(%eax),%ax
  8025e5:	48                   	dec    %eax
  8025e6:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8025e9:	66 89 42 0a          	mov    %ax,0xa(%edx)
		    return blk;
  8025ed:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8025f0:	e9 26 01 00 00       	jmp    80271b <alloc_block+0x40a>
		}else{//case 3: no free block and no free page so iterate and try to find bigger size.
			// iterate over the list until finding available block
			while (idx <= (LOG2_MAX_SIZE - LOG2_MIN_SIZE) && freeBlockLists[idx].size == 0) {
				idx++;
  8025f5:	ff 45 f4             	incl   -0xc(%ebp)
				// found free block
				if(freeBlockLists[idx].size > 0){
  8025f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025fb:	c1 e0 04             	shl    $0x4,%eax
  8025fe:	05 8c c0 81 00       	add    $0x81c08c,%eax
  802603:	8b 00                	mov    (%eax),%eax
  802605:	85 c0                	test   %eax,%eax
  802607:	0f 84 dc 00 00 00    	je     8026e9 <alloc_block+0x3d8>
					// remove from the list and updat the pageInfoArr free blocks.
					// pop from the freeBlockList.
					struct BlockElement *blk = LIST_FIRST(&freeBlockLists[idx]);
  80260d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802610:	c1 e0 04             	shl    $0x4,%eax
  802613:	05 80 c0 81 00       	add    $0x81c080,%eax
  802618:	8b 00                	mov    (%eax),%eax
  80261a:	89 45 d8             	mov    %eax,-0x28(%ebp)
				    LIST_REMOVE(&freeBlockLists[idx], blk);
  80261d:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  802621:	75 17                	jne    80263a <alloc_block+0x329>
  802623:	83 ec 04             	sub    $0x4,%esp
  802626:	68 e1 38 80 00       	push   $0x8038e1
  80262b:	68 be 00 00 00       	push   $0xbe
  802630:	68 23 38 80 00       	push   $0x803823
  802635:	e8 f9 04 00 00       	call   802b33 <_panic>
  80263a:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80263d:	8b 00                	mov    (%eax),%eax
  80263f:	85 c0                	test   %eax,%eax
  802641:	74 10                	je     802653 <alloc_block+0x342>
  802643:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802646:	8b 00                	mov    (%eax),%eax
  802648:	8b 55 d8             	mov    -0x28(%ebp),%edx
  80264b:	8b 52 04             	mov    0x4(%edx),%edx
  80264e:	89 50 04             	mov    %edx,0x4(%eax)
  802651:	eb 14                	jmp    802667 <alloc_block+0x356>
  802653:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802656:	8b 40 04             	mov    0x4(%eax),%eax
  802659:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80265c:	c1 e2 04             	shl    $0x4,%edx
  80265f:	81 c2 84 c0 81 00    	add    $0x81c084,%edx
  802665:	89 02                	mov    %eax,(%edx)
  802667:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80266a:	8b 40 04             	mov    0x4(%eax),%eax
  80266d:	85 c0                	test   %eax,%eax
  80266f:	74 0f                	je     802680 <alloc_block+0x36f>
  802671:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802674:	8b 40 04             	mov    0x4(%eax),%eax
  802677:	8b 55 d8             	mov    -0x28(%ebp),%edx
  80267a:	8b 12                	mov    (%edx),%edx
  80267c:	89 10                	mov    %edx,(%eax)
  80267e:	eb 13                	jmp    802693 <alloc_block+0x382>
  802680:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802683:	8b 00                	mov    (%eax),%eax
  802685:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802688:	c1 e2 04             	shl    $0x4,%edx
  80268b:	81 c2 80 c0 81 00    	add    $0x81c080,%edx
  802691:	89 02                	mov    %eax,(%edx)
  802693:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802696:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80269c:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80269f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8026a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026a9:	c1 e0 04             	shl    $0x4,%eax
  8026ac:	05 8c c0 81 00       	add    $0x81c08c,%eax
  8026b1:	8b 00                	mov    (%eax),%eax
  8026b3:	8d 50 ff             	lea    -0x1(%eax),%edx
  8026b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026b9:	c1 e0 04             	shl    $0x4,%eax
  8026bc:	05 8c c0 81 00       	add    $0x81c08c,%eax
  8026c1:	89 10                	mov    %edx,(%eax)
				    // update pageBlockInfoArr
				    struct PageInfoElement *pageInfo = to_page_info((uint32)blk);
  8026c3:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8026c6:	83 ec 0c             	sub    $0xc,%esp
  8026c9:	50                   	push   %eax
  8026ca:	e8 fe f8 ff ff       	call   801fcd <to_page_info>
  8026cf:	83 c4 10             	add    $0x10,%esp
  8026d2:	89 45 d4             	mov    %eax,-0x2c(%ebp)
				    pageInfo->num_of_free_blocks--;
  8026d5:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8026d8:	66 8b 40 0a          	mov    0xa(%eax),%ax
  8026dc:	48                   	dec    %eax
  8026dd:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8026e0:	66 89 42 0a          	mov    %ax,0xa(%edx)
				    return blk;
  8026e4:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8026e7:	eb 32                	jmp    80271b <alloc_block+0x40a>
		    struct PageInfoElement *pageInfo = to_page_info((uint32)blk);
		    pageInfo->num_of_free_blocks--;
		    return blk;
		}else{//case 3: no free block and no free page so iterate and try to find bigger size.
			// iterate over the list until finding available block
			while (idx <= (LOG2_MAX_SIZE - LOG2_MIN_SIZE) && freeBlockLists[idx].size == 0) {
  8026e9:	83 7d f4 08          	cmpl   $0x8,-0xc(%ebp)
  8026ed:	77 15                	ja     802704 <alloc_block+0x3f3>
  8026ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026f2:	c1 e0 04             	shl    $0x4,%eax
  8026f5:	05 8c c0 81 00       	add    $0x81c08c,%eax
  8026fa:	8b 00                	mov    (%eax),%eax
  8026fc:	85 c0                	test   %eax,%eax
  8026fe:	0f 84 f1 fe ff ff    	je     8025f5 <alloc_block+0x2e4>
				}
			}
		}
	}
	//case4: no free blocks or pages.
	panic("no free blocks!");
  802704:	83 ec 04             	sub    $0x4,%esp
  802707:	68 ff 38 80 00       	push   $0x8038ff
  80270c:	68 c8 00 00 00       	push   $0xc8
  802711:	68 23 38 80 00       	push   $0x803823
  802716:	e8 18 04 00 00       	call   802b33 <_panic>
	//panic("alloc_block() Not implemented yet");
	//TODO: [PROJECT'25.BONUS#1] DYNAMIC ALLOCATOR - block if no free block
	return NULL;
}
  80271b:	c9                   	leave  
  80271c:	c3                   	ret    

0080271d <free_block>:

//===========================
// [4] FREE BLOCK:
//===========================
void free_block(void *va)
{
  80271d:	55                   	push   %ebp
  80271e:	89 e5                	mov    %esp,%ebp
  802720:	83 ec 38             	sub    $0x38,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		assert((uint32)va >= dynAllocStart && (uint32)va < dynAllocEnd);
  802723:	8b 55 08             	mov    0x8(%ebp),%edx
  802726:	a1 64 c0 81 00       	mov    0x81c064,%eax
  80272b:	39 c2                	cmp    %eax,%edx
  80272d:	72 0c                	jb     80273b <free_block+0x1e>
  80272f:	8b 55 08             	mov    0x8(%ebp),%edx
  802732:	a1 40 40 80 00       	mov    0x804040,%eax
  802737:	39 c2                	cmp    %eax,%edx
  802739:	72 19                	jb     802754 <free_block+0x37>
  80273b:	68 10 39 80 00       	push   $0x803910
  802740:	68 86 38 80 00       	push   $0x803886
  802745:	68 d7 00 00 00       	push   $0xd7
  80274a:	68 23 38 80 00       	push   $0x803823
  80274f:	e8 df 03 00 00       	call   802b33 <_panic>
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #4 free_block
	//Your code is here
	//Comment the following line
	// va of a piece in memory to free so:
	// 1. get its page, and make blk with this address to be put in the freeBlockList.
	struct BlockElement* blk_to_free = (struct BlockElement*)va;
  802754:	8b 45 08             	mov    0x8(%ebp),%eax
  802757:	89 45 e8             	mov    %eax,-0x18(%ebp)
	struct PageInfoElement *pageInfo = to_page_info((uint32)va);
  80275a:	8b 45 08             	mov    0x8(%ebp),%eax
  80275d:	83 ec 0c             	sub    $0xc,%esp
  802760:	50                   	push   %eax
  802761:	e8 67 f8 ff ff       	call   801fcd <to_page_info>
  802766:	83 c4 10             	add    $0x10,%esp
  802769:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	uint32 blk_size = pageInfo->block_size;
  80276c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80276f:	8b 40 08             	mov    0x8(%eax),%eax
  802772:	0f b7 c0             	movzwl %ax,%eax
  802775:	89 45 e0             	mov    %eax,-0x20(%ebp)

	// its index in the freeBlocklist.
	int idx = 0;
  802778:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int i = LOG2_MIN_SIZE; i <= LOG2_MAX_SIZE; i++) {
  80277f:	c7 45 f0 03 00 00 00 	movl   $0x3,-0x10(%ebp)
  802786:	eb 19                	jmp    8027a1 <free_block+0x84>
	    if ((1 << i) == blk_size)
  802788:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80278b:	ba 01 00 00 00       	mov    $0x1,%edx
  802790:	88 c1                	mov    %al,%cl
  802792:	d3 e2                	shl    %cl,%edx
  802794:	89 d0                	mov    %edx,%eax
  802796:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  802799:	74 0e                	je     8027a9 <free_block+0x8c>
	        break;
	    idx++;
  80279b:	ff 45 f4             	incl   -0xc(%ebp)
	struct PageInfoElement *pageInfo = to_page_info((uint32)va);
	uint32 blk_size = pageInfo->block_size;

	// its index in the freeBlocklist.
	int idx = 0;
	for (int i = LOG2_MIN_SIZE; i <= LOG2_MAX_SIZE; i++) {
  80279e:	ff 45 f0             	incl   -0x10(%ebp)
  8027a1:	83 7d f0 0b          	cmpl   $0xb,-0x10(%ebp)
  8027a5:	7e e1                	jle    802788 <free_block+0x6b>
  8027a7:	eb 01                	jmp    8027aa <free_block+0x8d>
	    if ((1 << i) == blk_size)
	        break;
  8027a9:	90                   	nop
	    idx++;
	}

	pageInfo->num_of_free_blocks++;
  8027aa:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8027ad:	66 8b 40 0a          	mov    0xa(%eax),%ax
  8027b1:	40                   	inc    %eax
  8027b2:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8027b5:	66 89 42 0a          	mov    %ax,0xa(%edx)
	LIST_INSERT_TAIL(&freeBlockLists[idx], blk_to_free);
  8027b9:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8027bd:	75 17                	jne    8027d6 <free_block+0xb9>
  8027bf:	83 ec 04             	sub    $0x4,%esp
  8027c2:	68 9c 38 80 00       	push   $0x80389c
  8027c7:	68 ee 00 00 00       	push   $0xee
  8027cc:	68 23 38 80 00       	push   $0x803823
  8027d1:	e8 5d 03 00 00       	call   802b33 <_panic>
  8027d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027d9:	c1 e0 04             	shl    $0x4,%eax
  8027dc:	05 84 c0 81 00       	add    $0x81c084,%eax
  8027e1:	8b 10                	mov    (%eax),%edx
  8027e3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8027e6:	89 50 04             	mov    %edx,0x4(%eax)
  8027e9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8027ec:	8b 40 04             	mov    0x4(%eax),%eax
  8027ef:	85 c0                	test   %eax,%eax
  8027f1:	74 14                	je     802807 <free_block+0xea>
  8027f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027f6:	c1 e0 04             	shl    $0x4,%eax
  8027f9:	05 84 c0 81 00       	add    $0x81c084,%eax
  8027fe:	8b 00                	mov    (%eax),%eax
  802800:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802803:	89 10                	mov    %edx,(%eax)
  802805:	eb 11                	jmp    802818 <free_block+0xfb>
  802807:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80280a:	c1 e0 04             	shl    $0x4,%eax
  80280d:	8d 90 80 c0 81 00    	lea    0x81c080(%eax),%edx
  802813:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802816:	89 02                	mov    %eax,(%edx)
  802818:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80281b:	c1 e0 04             	shl    $0x4,%eax
  80281e:	8d 90 84 c0 81 00    	lea    0x81c084(%eax),%edx
  802824:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802827:	89 02                	mov    %eax,(%edx)
  802829:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80282c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802832:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802835:	c1 e0 04             	shl    $0x4,%eax
  802838:	05 8c c0 81 00       	add    $0x81c08c,%eax
  80283d:	8b 00                	mov    (%eax),%eax
  80283f:	8d 50 01             	lea    0x1(%eax),%edx
  802842:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802845:	c1 e0 04             	shl    $0x4,%eax
  802848:	05 8c c0 81 00       	add    $0x81c08c,%eax
  80284d:	89 10                	mov    %edx,(%eax)

	// now, case 1: the page all blocks are freed so you free the page.
	int blk_count = PAGE_SIZE / blk_size;
  80284f:	b8 00 10 00 00       	mov    $0x1000,%eax
  802854:	ba 00 00 00 00       	mov    $0x0,%edx
  802859:	f7 75 e0             	divl   -0x20(%ebp)
  80285c:	89 45 dc             	mov    %eax,-0x24(%ebp)
	// the blk count in the page is same as number fo free blocks free up the page.
	if (pageInfo->num_of_free_blocks == blk_count) {
  80285f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802862:	66 8b 40 0a          	mov    0xa(%eax),%ax
  802866:	0f b7 c0             	movzwl %ax,%eax
  802869:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  80286c:	0f 85 70 01 00 00    	jne    8029e2 <free_block+0x2c5>
		uint32 page_va = to_page_va(pageInfo);
  802872:	83 ec 0c             	sub    $0xc,%esp
  802875:	ff 75 e4             	pushl  -0x1c(%ebp)
  802878:	e8 de f6 ff ff       	call   801f5b <to_page_va>
  80287d:	83 c4 10             	add    $0x10,%esp
  802880:	89 45 d8             	mov    %eax,-0x28(%ebp)
		// remove all blk in the freeBlockList.
		for (uint32 off = 0; off < PAGE_SIZE; off += blk_size) {
  802883:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  80288a:	e9 b7 00 00 00       	jmp    802946 <free_block+0x229>
			struct BlockElement *blk = (struct BlockElement*)(page_va + off);
  80288f:	8b 55 d8             	mov    -0x28(%ebp),%edx
  802892:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802895:	01 d0                	add    %edx,%eax
  802897:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			LIST_REMOVE(&freeBlockLists[idx], blk);
  80289a:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  80289e:	75 17                	jne    8028b7 <free_block+0x19a>
  8028a0:	83 ec 04             	sub    $0x4,%esp
  8028a3:	68 e1 38 80 00       	push   $0x8038e1
  8028a8:	68 f8 00 00 00       	push   $0xf8
  8028ad:	68 23 38 80 00       	push   $0x803823
  8028b2:	e8 7c 02 00 00       	call   802b33 <_panic>
  8028b7:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8028ba:	8b 00                	mov    (%eax),%eax
  8028bc:	85 c0                	test   %eax,%eax
  8028be:	74 10                	je     8028d0 <free_block+0x1b3>
  8028c0:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8028c3:	8b 00                	mov    (%eax),%eax
  8028c5:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8028c8:	8b 52 04             	mov    0x4(%edx),%edx
  8028cb:	89 50 04             	mov    %edx,0x4(%eax)
  8028ce:	eb 14                	jmp    8028e4 <free_block+0x1c7>
  8028d0:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8028d3:	8b 40 04             	mov    0x4(%eax),%eax
  8028d6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8028d9:	c1 e2 04             	shl    $0x4,%edx
  8028dc:	81 c2 84 c0 81 00    	add    $0x81c084,%edx
  8028e2:	89 02                	mov    %eax,(%edx)
  8028e4:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8028e7:	8b 40 04             	mov    0x4(%eax),%eax
  8028ea:	85 c0                	test   %eax,%eax
  8028ec:	74 0f                	je     8028fd <free_block+0x1e0>
  8028ee:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8028f1:	8b 40 04             	mov    0x4(%eax),%eax
  8028f4:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8028f7:	8b 12                	mov    (%edx),%edx
  8028f9:	89 10                	mov    %edx,(%eax)
  8028fb:	eb 13                	jmp    802910 <free_block+0x1f3>
  8028fd:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802900:	8b 00                	mov    (%eax),%eax
  802902:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802905:	c1 e2 04             	shl    $0x4,%edx
  802908:	81 c2 80 c0 81 00    	add    $0x81c080,%edx
  80290e:	89 02                	mov    %eax,(%edx)
  802910:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802913:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802919:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80291c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802923:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802926:	c1 e0 04             	shl    $0x4,%eax
  802929:	05 8c c0 81 00       	add    $0x81c08c,%eax
  80292e:	8b 00                	mov    (%eax),%eax
  802930:	8d 50 ff             	lea    -0x1(%eax),%edx
  802933:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802936:	c1 e0 04             	shl    $0x4,%eax
  802939:	05 8c c0 81 00       	add    $0x81c08c,%eax
  80293e:	89 10                	mov    %edx,(%eax)
	int blk_count = PAGE_SIZE / blk_size;
	// the blk count in the page is same as number fo free blocks free up the page.
	if (pageInfo->num_of_free_blocks == blk_count) {
		uint32 page_va = to_page_va(pageInfo);
		// remove all blk in the freeBlockList.
		for (uint32 off = 0; off < PAGE_SIZE; off += blk_size) {
  802940:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802943:	01 45 ec             	add    %eax,-0x14(%ebp)
  802946:	81 7d ec ff 0f 00 00 	cmpl   $0xfff,-0x14(%ebp)
  80294d:	0f 86 3c ff ff ff    	jbe    80288f <free_block+0x172>
			struct BlockElement *blk = (struct BlockElement*)(page_va + off);
			LIST_REMOVE(&freeBlockLists[idx], blk);
		}
		// reset page info.
		pageInfo->block_size = 0;
  802953:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802956:	66 c7 40 08 00 00    	movw   $0x0,0x8(%eax)
		pageInfo->num_of_free_blocks = 0;
  80295c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80295f:	66 c7 40 0a 00 00    	movw   $0x0,0xa(%eax)
		// add it to the available pages.
		LIST_INSERT_TAIL(&freePagesList, pageInfo);
  802965:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  802969:	75 17                	jne    802982 <free_block+0x265>
  80296b:	83 ec 04             	sub    $0x4,%esp
  80296e:	68 9c 38 80 00       	push   $0x80389c
  802973:	68 fe 00 00 00       	push   $0xfe
  802978:	68 23 38 80 00       	push   $0x803823
  80297d:	e8 b1 01 00 00       	call   802b33 <_panic>
  802982:	8b 15 4c 40 80 00    	mov    0x80404c,%edx
  802988:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80298b:	89 50 04             	mov    %edx,0x4(%eax)
  80298e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802991:	8b 40 04             	mov    0x4(%eax),%eax
  802994:	85 c0                	test   %eax,%eax
  802996:	74 0c                	je     8029a4 <free_block+0x287>
  802998:	a1 4c 40 80 00       	mov    0x80404c,%eax
  80299d:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8029a0:	89 10                	mov    %edx,(%eax)
  8029a2:	eb 08                	jmp    8029ac <free_block+0x28f>
  8029a4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8029a7:	a3 48 40 80 00       	mov    %eax,0x804048
  8029ac:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8029af:	a3 4c 40 80 00       	mov    %eax,0x80404c
  8029b4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8029b7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8029bd:	a1 54 40 80 00       	mov    0x804054,%eax
  8029c2:	40                   	inc    %eax
  8029c3:	a3 54 40 80 00       	mov    %eax,0x804054
		// make it available in memory.
		return_page((uint32 *)to_page_va(pageInfo));
  8029c8:	83 ec 0c             	sub    $0xc,%esp
  8029cb:	ff 75 e4             	pushl  -0x1c(%ebp)
  8029ce:	e8 88 f5 ff ff       	call   801f5b <to_page_va>
  8029d3:	83 c4 10             	add    $0x10,%esp
  8029d6:	83 ec 0c             	sub    $0xc,%esp
  8029d9:	50                   	push   %eax
  8029da:	e8 b8 ee ff ff       	call   801897 <return_page>
  8029df:	83 c4 10             	add    $0x10,%esp
	}
	//panic("free_block() Not implemented yet");
}
  8029e2:	90                   	nop
  8029e3:	c9                   	leave  
  8029e4:	c3                   	ret    

008029e5 <realloc_block>:

//===========================
// [1] REALLOCATE BLOCK:
//===========================
void *realloc_block(void* va, uint32 new_size)
{
  8029e5:	55                   	push   %ebp
  8029e6:	89 e5                	mov    %esp,%ebp
  8029e8:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.BONUS#2] KERNEL REALLOC - realloc_block
	//Your code is here
	//Comment the following line
	panic("realloc_block() Not implemented yet");
  8029eb:	83 ec 04             	sub    $0x4,%esp
  8029ee:	68 48 39 80 00       	push   $0x803948
  8029f3:	68 11 01 00 00       	push   $0x111
  8029f8:	68 23 38 80 00       	push   $0x803823
  8029fd:	e8 31 01 00 00       	call   802b33 <_panic>

00802a02 <create_semaphore>:
// User-level Semaphore

#include "inc/lib.h"

struct semaphore create_semaphore(char *semaphoreName, uint32 value)
{
  802a02:	55                   	push   %ebp
  802a03:	89 e5                	mov    %esp,%ebp
  802a05:	83 ec 08             	sub    $0x8,%esp
	panic("create_semaphore() is not implemented yet...!!");
  802a08:	83 ec 04             	sub    $0x4,%esp
  802a0b:	68 6c 39 80 00       	push   $0x80396c
  802a10:	6a 07                	push   $0x7
  802a12:	68 9b 39 80 00       	push   $0x80399b
  802a17:	e8 17 01 00 00       	call   802b33 <_panic>

00802a1c <get_semaphore>:
}
struct semaphore get_semaphore(int32 ownerEnvID, char* semaphoreName)
{
  802a1c:	55                   	push   %ebp
  802a1d:	89 e5                	mov    %esp,%ebp
  802a1f:	83 ec 08             	sub    $0x8,%esp
	panic("get_semaphore() is not implemented yet...!!");
  802a22:	83 ec 04             	sub    $0x4,%esp
  802a25:	68 ac 39 80 00       	push   $0x8039ac
  802a2a:	6a 0b                	push   $0xb
  802a2c:	68 9b 39 80 00       	push   $0x80399b
  802a31:	e8 fd 00 00 00       	call   802b33 <_panic>

00802a36 <wait_semaphore>:
}

void wait_semaphore(struct semaphore sem)
{
  802a36:	55                   	push   %ebp
  802a37:	89 e5                	mov    %esp,%ebp
  802a39:	83 ec 08             	sub    $0x8,%esp
	panic("wait_semaphore() is not implemented yet...!!");
  802a3c:	83 ec 04             	sub    $0x4,%esp
  802a3f:	68 d8 39 80 00       	push   $0x8039d8
  802a44:	6a 10                	push   $0x10
  802a46:	68 9b 39 80 00       	push   $0x80399b
  802a4b:	e8 e3 00 00 00       	call   802b33 <_panic>

00802a50 <signal_semaphore>:
}

void signal_semaphore(struct semaphore sem)
{
  802a50:	55                   	push   %ebp
  802a51:	89 e5                	mov    %esp,%ebp
  802a53:	83 ec 08             	sub    $0x8,%esp
	panic("signal_semaphore() is not implemented yet...!!");
  802a56:	83 ec 04             	sub    $0x4,%esp
  802a59:	68 08 3a 80 00       	push   $0x803a08
  802a5e:	6a 15                	push   $0x15
  802a60:	68 9b 39 80 00       	push   $0x80399b
  802a65:	e8 c9 00 00 00       	call   802b33 <_panic>

00802a6a <semaphore_count>:
}

int semaphore_count(struct semaphore sem)
{
  802a6a:	55                   	push   %ebp
  802a6b:	89 e5                	mov    %esp,%ebp
	return sem.semdata->count;
  802a6d:	8b 45 08             	mov    0x8(%ebp),%eax
  802a70:	8b 40 10             	mov    0x10(%eax),%eax
}
  802a73:	5d                   	pop    %ebp
  802a74:	c3                   	ret    

00802a75 <env_sleep>:
#include <inc/lib.h>
#include <inc/timerreg.h>

void
env_sleep(uint32 approxMilliSeconds)
{
  802a75:	55                   	push   %ebp
  802a76:	89 e5                	mov    %esp,%ebp
  802a78:	83 ec 30             	sub    $0x30,%esp
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
  802a7b:	8b 55 08             	mov    0x8(%ebp),%edx
  802a7e:	89 d0                	mov    %edx,%eax
  802a80:	c1 e0 02             	shl    $0x2,%eax
  802a83:	01 d0                	add    %edx,%eax
  802a85:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  802a8c:	01 d0                	add    %edx,%eax
  802a8e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  802a95:	01 d0                	add    %edx,%eax
  802a97:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  802a9e:	01 d0                	add    %edx,%eax
  802aa0:	c1 e0 04             	shl    $0x4,%eax
  802aa3:	89 45 f8             	mov    %eax,-0x8(%ebp)
	uint32 cycles_counter =0;
  802aa6:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)

static inline __attribute__((always_inline)) struct uint64 get_virtual_time_user()
{
	struct uint64 result;

	__asm __volatile("rdtsc\n"
  802aad:	0f 31                	rdtsc  
  802aaf:	89 45 e8             	mov    %eax,-0x18(%ebp)
  802ab2:	89 55 ec             	mov    %edx,-0x14(%ebp)
	: "=a" (result.low), "=d" (result.hi)
	);

	return result;
  802ab5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ab8:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802abb:	89 45 f0             	mov    %eax,-0x10(%ebp)
  802abe:	89 55 f4             	mov    %edx,-0xc(%ebp)

	/*2024*/ //USE A USER-SIDE VERSION OF THIS FUNCTION TO AVOID SLOW-DOWN THE PERFORMANCE DUE SYS_CALL (el7 :))
	//struct uint64 baseTime = sys_get_virtual_time() ;
	struct uint64 baseTime = get_virtual_time_user() ;
	while(cycles_counter<time_in_cycles)
  802ac1:	eb 46                	jmp    802b09 <env_sleep+0x94>

static inline __attribute__((always_inline)) struct uint64 get_virtual_time_user()
{
	struct uint64 result;

	__asm __volatile("rdtsc\n"
  802ac3:	0f 31                	rdtsc  
  802ac5:	89 45 d0             	mov    %eax,-0x30(%ebp)
  802ac8:	89 55 d4             	mov    %edx,-0x2c(%ebp)
	: "=a" (result.low), "=d" (result.hi)
	);

	return result;
  802acb:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802ace:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  802ad1:	89 45 e0             	mov    %eax,-0x20(%ebp)
  802ad4:	89 55 e4             	mov    %edx,-0x1c(%ebp)

		// update the cycles_count
		#define M32 0xffffffff
		// subtract basetime from current time
		struct uint64 res;
		res.low = (currentTime.low - baseTime.low) & M32;
  802ad7:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802ada:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802add:	29 c2                	sub    %eax,%edx
  802adf:	89 d0                	mov    %edx,%eax
  802ae1:	89 45 d8             	mov    %eax,-0x28(%ebp)
		res.hi = (currentTime.hi - baseTime.hi - (res.low > currentTime.low)) & M32;
  802ae4:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802ae7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802aea:	89 d1                	mov    %edx,%ecx
  802aec:	29 c1                	sub    %eax,%ecx
  802aee:	8b 55 d8             	mov    -0x28(%ebp),%edx
  802af1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802af4:	39 c2                	cmp    %eax,%edx
  802af6:	0f 97 c0             	seta   %al
  802af9:	0f b6 c0             	movzbl %al,%eax
  802afc:	29 c1                	sub    %eax,%ecx
  802afe:	89 c8                	mov    %ecx,%eax
  802b00:	89 45 dc             	mov    %eax,-0x24(%ebp)

		//update cycles_count with result
		cycles_counter = res.low;
  802b03:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802b06:	89 45 fc             	mov    %eax,-0x4(%ebp)
	uint32 cycles_counter =0;

	/*2024*/ //USE A USER-SIDE VERSION OF THIS FUNCTION TO AVOID SLOW-DOWN THE PERFORMANCE DUE SYS_CALL (el7 :))
	//struct uint64 baseTime = sys_get_virtual_time() ;
	struct uint64 baseTime = get_virtual_time_user() ;
	while(cycles_counter<time_in_cycles)
  802b09:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802b0c:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  802b0f:	72 b2                	jb     802ac3 <env_sleep+0x4e>
//				,cycles_counter
//				);
	}
	//cprintf("%s [%d] wake up now!\n", myEnv->prog_name, myEnv->env_id);

}
  802b11:	90                   	nop
  802b12:	c9                   	leave  
  802b13:	c3                   	ret    

00802b14 <busy_wait>:

//2017
uint32 busy_wait(uint32 loopMax)
{
  802b14:	55                   	push   %ebp
  802b15:	89 e5                	mov    %esp,%ebp
  802b17:	83 ec 10             	sub    $0x10,%esp
	uint32 i = 0 ;
  802b1a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	while (i < loopMax) i++;
  802b21:	eb 03                	jmp    802b26 <busy_wait+0x12>
  802b23:	ff 45 fc             	incl   -0x4(%ebp)
  802b26:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802b29:	3b 45 08             	cmp    0x8(%ebp),%eax
  802b2c:	72 f5                	jb     802b23 <busy_wait+0xf>
	return i;
  802b2e:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  802b31:	c9                   	leave  
  802b32:	c3                   	ret    

00802b33 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  802b33:	55                   	push   %ebp
  802b34:	89 e5                	mov    %esp,%ebp
  802b36:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  802b39:	8d 45 10             	lea    0x10(%ebp),%eax
  802b3c:	83 c0 04             	add    $0x4,%eax
  802b3f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  802b42:	a1 1c c1 81 00       	mov    0x81c11c,%eax
  802b47:	85 c0                	test   %eax,%eax
  802b49:	74 16                	je     802b61 <_panic+0x2e>
		cprintf("%s: ", argv0);
  802b4b:	a1 1c c1 81 00       	mov    0x81c11c,%eax
  802b50:	83 ec 08             	sub    $0x8,%esp
  802b53:	50                   	push   %eax
  802b54:	68 38 3a 80 00       	push   $0x803a38
  802b59:	e8 b7 dd ff ff       	call   800915 <cprintf>
  802b5e:	83 c4 10             	add    $0x10,%esp
	cprintf_colored(TEXT_PANIC_CLR, "user [EVAL_FINAL]panic in %s at %s:%d: ", binaryname, file, line);
  802b61:	a1 04 40 80 00       	mov    0x804004,%eax
  802b66:	83 ec 0c             	sub    $0xc,%esp
  802b69:	ff 75 0c             	pushl  0xc(%ebp)
  802b6c:	ff 75 08             	pushl  0x8(%ebp)
  802b6f:	50                   	push   %eax
  802b70:	68 40 3a 80 00       	push   $0x803a40
  802b75:	6a 74                	push   $0x74
  802b77:	e8 c6 dd ff ff       	call   800942 <cprintf_colored>
  802b7c:	83 c4 20             	add    $0x20,%esp
	vcprintf(fmt, ap);
  802b7f:	8b 45 10             	mov    0x10(%ebp),%eax
  802b82:	83 ec 08             	sub    $0x8,%esp
  802b85:	ff 75 f4             	pushl  -0xc(%ebp)
  802b88:	50                   	push   %eax
  802b89:	e8 18 dd ff ff       	call   8008a6 <vcprintf>
  802b8e:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  802b91:	83 ec 08             	sub    $0x8,%esp
  802b94:	6a 00                	push   $0x0
  802b96:	68 68 3a 80 00       	push   $0x803a68
  802b9b:	e8 06 dd ff ff       	call   8008a6 <vcprintf>
  802ba0:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  802ba3:	e8 7f dc ff ff       	call   800827 <exit>

	// should not return here
	while (1) ;
  802ba8:	eb fe                	jmp    802ba8 <_panic+0x75>

00802baa <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  802baa:	55                   	push   %ebp
  802bab:	89 e5                	mov    %esp,%ebp
  802bad:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  802bb0:	a1 20 40 80 00       	mov    0x804020,%eax
  802bb5:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  802bbb:	8b 45 0c             	mov    0xc(%ebp),%eax
  802bbe:	39 c2                	cmp    %eax,%edx
  802bc0:	74 14                	je     802bd6 <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  802bc2:	83 ec 04             	sub    $0x4,%esp
  802bc5:	68 6c 3a 80 00       	push   $0x803a6c
  802bca:	6a 26                	push   $0x26
  802bcc:	68 b8 3a 80 00       	push   $0x803ab8
  802bd1:	e8 5d ff ff ff       	call   802b33 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  802bd6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  802bdd:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  802be4:	e9 c5 00 00 00       	jmp    802cae <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  802be9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bec:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  802bf3:	8b 45 08             	mov    0x8(%ebp),%eax
  802bf6:	01 d0                	add    %edx,%eax
  802bf8:	8b 00                	mov    (%eax),%eax
  802bfa:	85 c0                	test   %eax,%eax
  802bfc:	75 08                	jne    802c06 <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  802bfe:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  802c01:	e9 a5 00 00 00       	jmp    802cab <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  802c06:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  802c0d:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  802c14:	eb 69                	jmp    802c7f <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  802c16:	a1 20 40 80 00       	mov    0x804020,%eax
  802c1b:	8b 88 38 da 01 00    	mov    0x1da38(%eax),%ecx
  802c21:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802c24:	89 d0                	mov    %edx,%eax
  802c26:	01 c0                	add    %eax,%eax
  802c28:	01 d0                	add    %edx,%eax
  802c2a:	c1 e0 03             	shl    $0x3,%eax
  802c2d:	01 c8                	add    %ecx,%eax
  802c2f:	8a 40 04             	mov    0x4(%eax),%al
  802c32:	84 c0                	test   %al,%al
  802c34:	75 46                	jne    802c7c <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  802c36:	a1 20 40 80 00       	mov    0x804020,%eax
  802c3b:	8b 88 38 da 01 00    	mov    0x1da38(%eax),%ecx
  802c41:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802c44:	89 d0                	mov    %edx,%eax
  802c46:	01 c0                	add    %eax,%eax
  802c48:	01 d0                	add    %edx,%eax
  802c4a:	c1 e0 03             	shl    $0x3,%eax
  802c4d:	01 c8                	add    %ecx,%eax
  802c4f:	8b 00                	mov    (%eax),%eax
  802c51:	89 45 dc             	mov    %eax,-0x24(%ebp)
  802c54:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802c57:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  802c5c:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  802c5e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c61:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  802c68:	8b 45 08             	mov    0x8(%ebp),%eax
  802c6b:	01 c8                	add    %ecx,%eax
  802c6d:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  802c6f:	39 c2                	cmp    %eax,%edx
  802c71:	75 09                	jne    802c7c <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  802c73:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  802c7a:	eb 15                	jmp    802c91 <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  802c7c:	ff 45 e8             	incl   -0x18(%ebp)
  802c7f:	a1 20 40 80 00       	mov    0x804020,%eax
  802c84:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  802c8a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802c8d:	39 c2                	cmp    %eax,%edx
  802c8f:	77 85                	ja     802c16 <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  802c91:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802c95:	75 14                	jne    802cab <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  802c97:	83 ec 04             	sub    $0x4,%esp
  802c9a:	68 c4 3a 80 00       	push   $0x803ac4
  802c9f:	6a 3a                	push   $0x3a
  802ca1:	68 b8 3a 80 00       	push   $0x803ab8
  802ca6:	e8 88 fe ff ff       	call   802b33 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  802cab:	ff 45 f0             	incl   -0x10(%ebp)
  802cae:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802cb1:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802cb4:	0f 8c 2f ff ff ff    	jl     802be9 <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  802cba:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  802cc1:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  802cc8:	eb 26                	jmp    802cf0 <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  802cca:	a1 20 40 80 00       	mov    0x804020,%eax
  802ccf:	8b 88 38 da 01 00    	mov    0x1da38(%eax),%ecx
  802cd5:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802cd8:	89 d0                	mov    %edx,%eax
  802cda:	01 c0                	add    %eax,%eax
  802cdc:	01 d0                	add    %edx,%eax
  802cde:	c1 e0 03             	shl    $0x3,%eax
  802ce1:	01 c8                	add    %ecx,%eax
  802ce3:	8a 40 04             	mov    0x4(%eax),%al
  802ce6:	3c 01                	cmp    $0x1,%al
  802ce8:	75 03                	jne    802ced <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  802cea:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  802ced:	ff 45 e0             	incl   -0x20(%ebp)
  802cf0:	a1 20 40 80 00       	mov    0x804020,%eax
  802cf5:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  802cfb:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802cfe:	39 c2                	cmp    %eax,%edx
  802d00:	77 c8                	ja     802cca <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  802d02:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d05:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  802d08:	74 14                	je     802d1e <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  802d0a:	83 ec 04             	sub    $0x4,%esp
  802d0d:	68 18 3b 80 00       	push   $0x803b18
  802d12:	6a 44                	push   $0x44
  802d14:	68 b8 3a 80 00       	push   $0x803ab8
  802d19:	e8 15 fe ff ff       	call   802b33 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  802d1e:	90                   	nop
  802d1f:	c9                   	leave  
  802d20:	c3                   	ret    
  802d21:	66 90                	xchg   %ax,%ax
  802d23:	90                   	nop

00802d24 <__udivdi3>:
  802d24:	55                   	push   %ebp
  802d25:	57                   	push   %edi
  802d26:	56                   	push   %esi
  802d27:	53                   	push   %ebx
  802d28:	83 ec 1c             	sub    $0x1c,%esp
  802d2b:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  802d2f:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  802d33:	8b 7c 24 38          	mov    0x38(%esp),%edi
  802d37:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802d3b:	89 ca                	mov    %ecx,%edx
  802d3d:	89 f8                	mov    %edi,%eax
  802d3f:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  802d43:	85 f6                	test   %esi,%esi
  802d45:	75 2d                	jne    802d74 <__udivdi3+0x50>
  802d47:	39 cf                	cmp    %ecx,%edi
  802d49:	77 65                	ja     802db0 <__udivdi3+0x8c>
  802d4b:	89 fd                	mov    %edi,%ebp
  802d4d:	85 ff                	test   %edi,%edi
  802d4f:	75 0b                	jne    802d5c <__udivdi3+0x38>
  802d51:	b8 01 00 00 00       	mov    $0x1,%eax
  802d56:	31 d2                	xor    %edx,%edx
  802d58:	f7 f7                	div    %edi
  802d5a:	89 c5                	mov    %eax,%ebp
  802d5c:	31 d2                	xor    %edx,%edx
  802d5e:	89 c8                	mov    %ecx,%eax
  802d60:	f7 f5                	div    %ebp
  802d62:	89 c1                	mov    %eax,%ecx
  802d64:	89 d8                	mov    %ebx,%eax
  802d66:	f7 f5                	div    %ebp
  802d68:	89 cf                	mov    %ecx,%edi
  802d6a:	89 fa                	mov    %edi,%edx
  802d6c:	83 c4 1c             	add    $0x1c,%esp
  802d6f:	5b                   	pop    %ebx
  802d70:	5e                   	pop    %esi
  802d71:	5f                   	pop    %edi
  802d72:	5d                   	pop    %ebp
  802d73:	c3                   	ret    
  802d74:	39 ce                	cmp    %ecx,%esi
  802d76:	77 28                	ja     802da0 <__udivdi3+0x7c>
  802d78:	0f bd fe             	bsr    %esi,%edi
  802d7b:	83 f7 1f             	xor    $0x1f,%edi
  802d7e:	75 40                	jne    802dc0 <__udivdi3+0x9c>
  802d80:	39 ce                	cmp    %ecx,%esi
  802d82:	72 0a                	jb     802d8e <__udivdi3+0x6a>
  802d84:	3b 44 24 08          	cmp    0x8(%esp),%eax
  802d88:	0f 87 9e 00 00 00    	ja     802e2c <__udivdi3+0x108>
  802d8e:	b8 01 00 00 00       	mov    $0x1,%eax
  802d93:	89 fa                	mov    %edi,%edx
  802d95:	83 c4 1c             	add    $0x1c,%esp
  802d98:	5b                   	pop    %ebx
  802d99:	5e                   	pop    %esi
  802d9a:	5f                   	pop    %edi
  802d9b:	5d                   	pop    %ebp
  802d9c:	c3                   	ret    
  802d9d:	8d 76 00             	lea    0x0(%esi),%esi
  802da0:	31 ff                	xor    %edi,%edi
  802da2:	31 c0                	xor    %eax,%eax
  802da4:	89 fa                	mov    %edi,%edx
  802da6:	83 c4 1c             	add    $0x1c,%esp
  802da9:	5b                   	pop    %ebx
  802daa:	5e                   	pop    %esi
  802dab:	5f                   	pop    %edi
  802dac:	5d                   	pop    %ebp
  802dad:	c3                   	ret    
  802dae:	66 90                	xchg   %ax,%ax
  802db0:	89 d8                	mov    %ebx,%eax
  802db2:	f7 f7                	div    %edi
  802db4:	31 ff                	xor    %edi,%edi
  802db6:	89 fa                	mov    %edi,%edx
  802db8:	83 c4 1c             	add    $0x1c,%esp
  802dbb:	5b                   	pop    %ebx
  802dbc:	5e                   	pop    %esi
  802dbd:	5f                   	pop    %edi
  802dbe:	5d                   	pop    %ebp
  802dbf:	c3                   	ret    
  802dc0:	bd 20 00 00 00       	mov    $0x20,%ebp
  802dc5:	89 eb                	mov    %ebp,%ebx
  802dc7:	29 fb                	sub    %edi,%ebx
  802dc9:	89 f9                	mov    %edi,%ecx
  802dcb:	d3 e6                	shl    %cl,%esi
  802dcd:	89 c5                	mov    %eax,%ebp
  802dcf:	88 d9                	mov    %bl,%cl
  802dd1:	d3 ed                	shr    %cl,%ebp
  802dd3:	89 e9                	mov    %ebp,%ecx
  802dd5:	09 f1                	or     %esi,%ecx
  802dd7:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  802ddb:	89 f9                	mov    %edi,%ecx
  802ddd:	d3 e0                	shl    %cl,%eax
  802ddf:	89 c5                	mov    %eax,%ebp
  802de1:	89 d6                	mov    %edx,%esi
  802de3:	88 d9                	mov    %bl,%cl
  802de5:	d3 ee                	shr    %cl,%esi
  802de7:	89 f9                	mov    %edi,%ecx
  802de9:	d3 e2                	shl    %cl,%edx
  802deb:	8b 44 24 08          	mov    0x8(%esp),%eax
  802def:	88 d9                	mov    %bl,%cl
  802df1:	d3 e8                	shr    %cl,%eax
  802df3:	09 c2                	or     %eax,%edx
  802df5:	89 d0                	mov    %edx,%eax
  802df7:	89 f2                	mov    %esi,%edx
  802df9:	f7 74 24 0c          	divl   0xc(%esp)
  802dfd:	89 d6                	mov    %edx,%esi
  802dff:	89 c3                	mov    %eax,%ebx
  802e01:	f7 e5                	mul    %ebp
  802e03:	39 d6                	cmp    %edx,%esi
  802e05:	72 19                	jb     802e20 <__udivdi3+0xfc>
  802e07:	74 0b                	je     802e14 <__udivdi3+0xf0>
  802e09:	89 d8                	mov    %ebx,%eax
  802e0b:	31 ff                	xor    %edi,%edi
  802e0d:	e9 58 ff ff ff       	jmp    802d6a <__udivdi3+0x46>
  802e12:	66 90                	xchg   %ax,%ax
  802e14:	8b 54 24 08          	mov    0x8(%esp),%edx
  802e18:	89 f9                	mov    %edi,%ecx
  802e1a:	d3 e2                	shl    %cl,%edx
  802e1c:	39 c2                	cmp    %eax,%edx
  802e1e:	73 e9                	jae    802e09 <__udivdi3+0xe5>
  802e20:	8d 43 ff             	lea    -0x1(%ebx),%eax
  802e23:	31 ff                	xor    %edi,%edi
  802e25:	e9 40 ff ff ff       	jmp    802d6a <__udivdi3+0x46>
  802e2a:	66 90                	xchg   %ax,%ax
  802e2c:	31 c0                	xor    %eax,%eax
  802e2e:	e9 37 ff ff ff       	jmp    802d6a <__udivdi3+0x46>
  802e33:	90                   	nop

00802e34 <__umoddi3>:
  802e34:	55                   	push   %ebp
  802e35:	57                   	push   %edi
  802e36:	56                   	push   %esi
  802e37:	53                   	push   %ebx
  802e38:	83 ec 1c             	sub    $0x1c,%esp
  802e3b:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  802e3f:	8b 74 24 34          	mov    0x34(%esp),%esi
  802e43:	8b 7c 24 38          	mov    0x38(%esp),%edi
  802e47:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  802e4b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802e4f:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802e53:	89 f3                	mov    %esi,%ebx
  802e55:	89 fa                	mov    %edi,%edx
  802e57:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  802e5b:	89 34 24             	mov    %esi,(%esp)
  802e5e:	85 c0                	test   %eax,%eax
  802e60:	75 1a                	jne    802e7c <__umoddi3+0x48>
  802e62:	39 f7                	cmp    %esi,%edi
  802e64:	0f 86 a2 00 00 00    	jbe    802f0c <__umoddi3+0xd8>
  802e6a:	89 c8                	mov    %ecx,%eax
  802e6c:	89 f2                	mov    %esi,%edx
  802e6e:	f7 f7                	div    %edi
  802e70:	89 d0                	mov    %edx,%eax
  802e72:	31 d2                	xor    %edx,%edx
  802e74:	83 c4 1c             	add    $0x1c,%esp
  802e77:	5b                   	pop    %ebx
  802e78:	5e                   	pop    %esi
  802e79:	5f                   	pop    %edi
  802e7a:	5d                   	pop    %ebp
  802e7b:	c3                   	ret    
  802e7c:	39 f0                	cmp    %esi,%eax
  802e7e:	0f 87 ac 00 00 00    	ja     802f30 <__umoddi3+0xfc>
  802e84:	0f bd e8             	bsr    %eax,%ebp
  802e87:	83 f5 1f             	xor    $0x1f,%ebp
  802e8a:	0f 84 ac 00 00 00    	je     802f3c <__umoddi3+0x108>
  802e90:	bf 20 00 00 00       	mov    $0x20,%edi
  802e95:	29 ef                	sub    %ebp,%edi
  802e97:	89 fe                	mov    %edi,%esi
  802e99:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802e9d:	89 e9                	mov    %ebp,%ecx
  802e9f:	d3 e0                	shl    %cl,%eax
  802ea1:	89 d7                	mov    %edx,%edi
  802ea3:	89 f1                	mov    %esi,%ecx
  802ea5:	d3 ef                	shr    %cl,%edi
  802ea7:	09 c7                	or     %eax,%edi
  802ea9:	89 e9                	mov    %ebp,%ecx
  802eab:	d3 e2                	shl    %cl,%edx
  802ead:	89 14 24             	mov    %edx,(%esp)
  802eb0:	89 d8                	mov    %ebx,%eax
  802eb2:	d3 e0                	shl    %cl,%eax
  802eb4:	89 c2                	mov    %eax,%edx
  802eb6:	8b 44 24 08          	mov    0x8(%esp),%eax
  802eba:	d3 e0                	shl    %cl,%eax
  802ebc:	89 44 24 04          	mov    %eax,0x4(%esp)
  802ec0:	8b 44 24 08          	mov    0x8(%esp),%eax
  802ec4:	89 f1                	mov    %esi,%ecx
  802ec6:	d3 e8                	shr    %cl,%eax
  802ec8:	09 d0                	or     %edx,%eax
  802eca:	d3 eb                	shr    %cl,%ebx
  802ecc:	89 da                	mov    %ebx,%edx
  802ece:	f7 f7                	div    %edi
  802ed0:	89 d3                	mov    %edx,%ebx
  802ed2:	f7 24 24             	mull   (%esp)
  802ed5:	89 c6                	mov    %eax,%esi
  802ed7:	89 d1                	mov    %edx,%ecx
  802ed9:	39 d3                	cmp    %edx,%ebx
  802edb:	0f 82 87 00 00 00    	jb     802f68 <__umoddi3+0x134>
  802ee1:	0f 84 91 00 00 00    	je     802f78 <__umoddi3+0x144>
  802ee7:	8b 54 24 04          	mov    0x4(%esp),%edx
  802eeb:	29 f2                	sub    %esi,%edx
  802eed:	19 cb                	sbb    %ecx,%ebx
  802eef:	89 d8                	mov    %ebx,%eax
  802ef1:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  802ef5:	d3 e0                	shl    %cl,%eax
  802ef7:	89 e9                	mov    %ebp,%ecx
  802ef9:	d3 ea                	shr    %cl,%edx
  802efb:	09 d0                	or     %edx,%eax
  802efd:	89 e9                	mov    %ebp,%ecx
  802eff:	d3 eb                	shr    %cl,%ebx
  802f01:	89 da                	mov    %ebx,%edx
  802f03:	83 c4 1c             	add    $0x1c,%esp
  802f06:	5b                   	pop    %ebx
  802f07:	5e                   	pop    %esi
  802f08:	5f                   	pop    %edi
  802f09:	5d                   	pop    %ebp
  802f0a:	c3                   	ret    
  802f0b:	90                   	nop
  802f0c:	89 fd                	mov    %edi,%ebp
  802f0e:	85 ff                	test   %edi,%edi
  802f10:	75 0b                	jne    802f1d <__umoddi3+0xe9>
  802f12:	b8 01 00 00 00       	mov    $0x1,%eax
  802f17:	31 d2                	xor    %edx,%edx
  802f19:	f7 f7                	div    %edi
  802f1b:	89 c5                	mov    %eax,%ebp
  802f1d:	89 f0                	mov    %esi,%eax
  802f1f:	31 d2                	xor    %edx,%edx
  802f21:	f7 f5                	div    %ebp
  802f23:	89 c8                	mov    %ecx,%eax
  802f25:	f7 f5                	div    %ebp
  802f27:	89 d0                	mov    %edx,%eax
  802f29:	e9 44 ff ff ff       	jmp    802e72 <__umoddi3+0x3e>
  802f2e:	66 90                	xchg   %ax,%ax
  802f30:	89 c8                	mov    %ecx,%eax
  802f32:	89 f2                	mov    %esi,%edx
  802f34:	83 c4 1c             	add    $0x1c,%esp
  802f37:	5b                   	pop    %ebx
  802f38:	5e                   	pop    %esi
  802f39:	5f                   	pop    %edi
  802f3a:	5d                   	pop    %ebp
  802f3b:	c3                   	ret    
  802f3c:	3b 04 24             	cmp    (%esp),%eax
  802f3f:	72 06                	jb     802f47 <__umoddi3+0x113>
  802f41:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  802f45:	77 0f                	ja     802f56 <__umoddi3+0x122>
  802f47:	89 f2                	mov    %esi,%edx
  802f49:	29 f9                	sub    %edi,%ecx
  802f4b:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  802f4f:	89 14 24             	mov    %edx,(%esp)
  802f52:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  802f56:	8b 44 24 04          	mov    0x4(%esp),%eax
  802f5a:	8b 14 24             	mov    (%esp),%edx
  802f5d:	83 c4 1c             	add    $0x1c,%esp
  802f60:	5b                   	pop    %ebx
  802f61:	5e                   	pop    %esi
  802f62:	5f                   	pop    %edi
  802f63:	5d                   	pop    %ebp
  802f64:	c3                   	ret    
  802f65:	8d 76 00             	lea    0x0(%esi),%esi
  802f68:	2b 04 24             	sub    (%esp),%eax
  802f6b:	19 fa                	sbb    %edi,%edx
  802f6d:	89 d1                	mov    %edx,%ecx
  802f6f:	89 c6                	mov    %eax,%esi
  802f71:	e9 71 ff ff ff       	jmp    802ee7 <__umoddi3+0xb3>
  802f76:	66 90                	xchg   %ax,%ax
  802f78:	39 44 24 04          	cmp    %eax,0x4(%esp)
  802f7c:	72 ea                	jb     802f68 <__umoddi3+0x134>
  802f7e:	89 d9                	mov    %ebx,%ecx
  802f80:	e9 62 ff ff ff       	jmp    802ee7 <__umoddi3+0xb3>
