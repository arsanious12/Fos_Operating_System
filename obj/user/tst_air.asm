
obj/user/tst_air:     file format elf32-i386


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
  800031:	e8 91 0f 00 00       	call   800fc7 <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
#include <user/air.h>
int find(int* arr, int size, int val);

void
_main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	57                   	push   %edi
  80003c:	56                   	push   %esi
  80003d:	53                   	push   %ebx
  80003e:	81 ec 9c 03 00 00    	sub    $0x39c,%esp
	int envID = sys_getenvid();
  800044:	e8 84 29 00 00       	call   8029cd <sys_getenvid>
  800049:	89 45 a0             	mov    %eax,-0x60(%ebp)

	int numOfClerks = 3;
  80004c:	c7 45 9c 03 00 00 00 	movl   $0x3,-0x64(%ebp)
	int agentCapacity = 20;
  800053:	c7 45 e4 14 00 00 00 	movl   $0x14,-0x1c(%ebp)
	int numOfCustomers = 30;
  80005a:	c7 45 e0 1e 00 00 00 	movl   $0x1e,-0x20(%ebp)
	int flight1NumOfCustomers = numOfCustomers/3;
  800061:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800064:	b8 56 55 55 55       	mov    $0x55555556,%eax
  800069:	f7 e9                	imul   %ecx
  80006b:	c1 f9 1f             	sar    $0x1f,%ecx
  80006e:	89 d0                	mov    %edx,%eax
  800070:	29 c8                	sub    %ecx,%eax
  800072:	89 45 dc             	mov    %eax,-0x24(%ebp)
	int flight2NumOfCustomers = numOfCustomers/3;
  800075:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800078:	b8 56 55 55 55       	mov    $0x55555556,%eax
  80007d:	f7 e9                	imul   %ecx
  80007f:	c1 f9 1f             	sar    $0x1f,%ecx
  800082:	89 d0                	mov    %edx,%eax
  800084:	29 c8                	sub    %ecx,%eax
  800086:	89 45 d8             	mov    %eax,-0x28(%ebp)
	int flight3NumOfCustomers = numOfCustomers - (flight1NumOfCustomers + flight2NumOfCustomers);
  800089:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80008c:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80008f:	01 c2                	add    %eax,%edx
  800091:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800094:	29 d0                	sub    %edx,%eax
  800096:	89 45 d4             	mov    %eax,-0x2c(%ebp)

	int flight1NumOfTickets = 15;
  800099:	c7 45 d0 0f 00 00 00 	movl   $0xf,-0x30(%ebp)
	int flight2NumOfTickets = 8;
  8000a0:	c7 45 cc 08 00 00 00 	movl   $0x8,-0x34(%ebp)
	// *************************************************************************************************
	/// Reading Inputs *********************************************************************************
	// *************************************************************************************************
	char Line[255] ;
	char Chose;
	sys_lock_cons();
  8000a7:	e8 c1 26 00 00       	call   80276d <sys_lock_cons>
	{
		cprintf("\n");
  8000ac:	83 ec 0c             	sub    $0xc,%esp
  8000af:	68 00 3b 80 00       	push   $0x803b00
  8000b4:	e8 a1 13 00 00       	call   80145a <cprintf>
  8000b9:	83 c4 10             	add    $0x10,%esp
		cprintf("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!\n");
  8000bc:	83 ec 0c             	sub    $0xc,%esp
  8000bf:	68 04 3b 80 00       	push   $0x803b04
  8000c4:	e8 91 13 00 00       	call   80145a <cprintf>
  8000c9:	83 c4 10             	add    $0x10,%esp
		cprintf("!!!! AIR PLANE RESERVATION !!!!\n");
  8000cc:	83 ec 0c             	sub    $0xc,%esp
  8000cf:	68 28 3b 80 00       	push   $0x803b28
  8000d4:	e8 81 13 00 00       	call   80145a <cprintf>
  8000d9:	83 c4 10             	add    $0x10,%esp
		cprintf("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!\n");
  8000dc:	83 ec 0c             	sub    $0xc,%esp
  8000df:	68 04 3b 80 00       	push   $0x803b04
  8000e4:	e8 71 13 00 00       	call   80145a <cprintf>
  8000e9:	83 c4 10             	add    $0x10,%esp
		cprintf("\n");
  8000ec:	83 ec 0c             	sub    $0xc,%esp
  8000ef:	68 00 3b 80 00       	push   $0x803b00
  8000f4:	e8 61 13 00 00       	call   80145a <cprintf>
  8000f9:	83 c4 10             	add    $0x10,%esp
		cprintf("%~Default #customers = %d (equally divided over the 3 flights).\n"
  8000fc:	83 ec 0c             	sub    $0xc,%esp
  8000ff:	ff 75 e4             	pushl  -0x1c(%ebp)
  800102:	ff 75 cc             	pushl  -0x34(%ebp)
  800105:	ff 75 d0             	pushl  -0x30(%ebp)
  800108:	ff 75 e0             	pushl  -0x20(%ebp)
  80010b:	68 4c 3b 80 00       	push   $0x803b4c
  800110:	e8 45 13 00 00       	call   80145a <cprintf>
  800115:	83 c4 20             	add    $0x20,%esp
				"Flight1 Tickets = %d, Flight2 Tickets = %d\n"
				"Agent Capacity = %d\n", numOfCustomers, flight1NumOfTickets, flight2NumOfTickets, agentCapacity) ;
		Chose = 0 ;
  800118:	c6 45 cb 00          	movb   $0x0,-0x35(%ebp)
		while (Chose != 'y' && Chose != 'n' && Chose != 'Y' && Chose != 'N')
  80011c:	eb 42                	jmp    800160 <_main+0x128>
		{
			cprintf("%~Do you want to change these values(y/n)? ") ;
  80011e:	83 ec 0c             	sub    $0xc,%esp
  800121:	68 cc 3b 80 00       	push   $0x803bcc
  800126:	e8 2f 13 00 00       	call   80145a <cprintf>
  80012b:	83 c4 10             	add    $0x10,%esp
			Chose = getchar() ;
  80012e:	e8 77 0e 00 00       	call   800faa <getchar>
  800133:	88 45 cb             	mov    %al,-0x35(%ebp)
			cputchar(Chose);
  800136:	0f be 45 cb          	movsbl -0x35(%ebp),%eax
  80013a:	83 ec 0c             	sub    $0xc,%esp
  80013d:	50                   	push   %eax
  80013e:	e8 48 0e 00 00       	call   800f8b <cputchar>
  800143:	83 c4 10             	add    $0x10,%esp
			cputchar('\n');
  800146:	83 ec 0c             	sub    $0xc,%esp
  800149:	6a 0a                	push   $0xa
  80014b:	e8 3b 0e 00 00       	call   800f8b <cputchar>
  800150:	83 c4 10             	add    $0x10,%esp
			cputchar('\n');
  800153:	83 ec 0c             	sub    $0xc,%esp
  800156:	6a 0a                	push   $0xa
  800158:	e8 2e 0e 00 00       	call   800f8b <cputchar>
  80015d:	83 c4 10             	add    $0x10,%esp
		cprintf("\n");
		cprintf("%~Default #customers = %d (equally divided over the 3 flights).\n"
				"Flight1 Tickets = %d, Flight2 Tickets = %d\n"
				"Agent Capacity = %d\n", numOfCustomers, flight1NumOfTickets, flight2NumOfTickets, agentCapacity) ;
		Chose = 0 ;
		while (Chose != 'y' && Chose != 'n' && Chose != 'Y' && Chose != 'N')
  800160:	80 7d cb 79          	cmpb   $0x79,-0x35(%ebp)
  800164:	74 12                	je     800178 <_main+0x140>
  800166:	80 7d cb 6e          	cmpb   $0x6e,-0x35(%ebp)
  80016a:	74 0c                	je     800178 <_main+0x140>
  80016c:	80 7d cb 59          	cmpb   $0x59,-0x35(%ebp)
  800170:	74 06                	je     800178 <_main+0x140>
  800172:	80 7d cb 4e          	cmpb   $0x4e,-0x35(%ebp)
  800176:	75 a6                	jne    80011e <_main+0xe6>
			Chose = getchar() ;
			cputchar(Chose);
			cputchar('\n');
			cputchar('\n');
		}
		if (Chose == 'y' || Chose == 'Y')
  800178:	80 7d cb 79          	cmpb   $0x79,-0x35(%ebp)
  80017c:	74 0a                	je     800188 <_main+0x150>
  80017e:	80 7d cb 59          	cmpb   $0x59,-0x35(%ebp)
  800182:	0f 85 ea 00 00 00    	jne    800272 <_main+0x23a>
		{
			readline("Enter the capacity of the agent: ", Line);
  800188:	83 ec 08             	sub    $0x8,%esp
  80018b:	8d 85 59 fe ff ff    	lea    -0x1a7(%ebp),%eax
  800191:	50                   	push   %eax
  800192:	68 f8 3b 80 00       	push   $0x803bf8
  800197:	e8 97 19 00 00       	call   801b33 <readline>
  80019c:	83 c4 10             	add    $0x10,%esp
			agentCapacity = strtol(Line, NULL, 10) ;
  80019f:	83 ec 04             	sub    $0x4,%esp
  8001a2:	6a 0a                	push   $0xa
  8001a4:	6a 00                	push   $0x0
  8001a6:	8d 85 59 fe ff ff    	lea    -0x1a7(%ebp),%eax
  8001ac:	50                   	push   %eax
  8001ad:	e8 98 1f 00 00       	call   80214a <strtol>
  8001b2:	83 c4 10             	add    $0x10,%esp
  8001b5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			readline("Enter the total number of customers: ", Line);
  8001b8:	83 ec 08             	sub    $0x8,%esp
  8001bb:	8d 85 59 fe ff ff    	lea    -0x1a7(%ebp),%eax
  8001c1:	50                   	push   %eax
  8001c2:	68 1c 3c 80 00       	push   $0x803c1c
  8001c7:	e8 67 19 00 00       	call   801b33 <readline>
  8001cc:	83 c4 10             	add    $0x10,%esp
			numOfCustomers = strtol(Line, NULL, 10) ;
  8001cf:	83 ec 04             	sub    $0x4,%esp
  8001d2:	6a 0a                	push   $0xa
  8001d4:	6a 00                	push   $0x0
  8001d6:	8d 85 59 fe ff ff    	lea    -0x1a7(%ebp),%eax
  8001dc:	50                   	push   %eax
  8001dd:	e8 68 1f 00 00       	call   80214a <strtol>
  8001e2:	83 c4 10             	add    $0x10,%esp
  8001e5:	89 45 e0             	mov    %eax,-0x20(%ebp)
			flight1NumOfCustomers = flight2NumOfCustomers = numOfCustomers / 3;
  8001e8:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  8001eb:	b8 56 55 55 55       	mov    $0x55555556,%eax
  8001f0:	f7 e9                	imul   %ecx
  8001f2:	c1 f9 1f             	sar    $0x1f,%ecx
  8001f5:	89 d0                	mov    %edx,%eax
  8001f7:	29 c8                	sub    %ecx,%eax
  8001f9:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8001fc:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8001ff:	89 45 dc             	mov    %eax,-0x24(%ebp)
			flight3NumOfCustomers = numOfCustomers - (flight1NumOfCustomers + flight2NumOfCustomers);
  800202:	8b 55 dc             	mov    -0x24(%ebp),%edx
  800205:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800208:	01 c2                	add    %eax,%edx
  80020a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80020d:	29 d0                	sub    %edx,%eax
  80020f:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			readline("Enter # tickets of flight#1: ", Line);
  800212:	83 ec 08             	sub    $0x8,%esp
  800215:	8d 85 59 fe ff ff    	lea    -0x1a7(%ebp),%eax
  80021b:	50                   	push   %eax
  80021c:	68 42 3c 80 00       	push   $0x803c42
  800221:	e8 0d 19 00 00       	call   801b33 <readline>
  800226:	83 c4 10             	add    $0x10,%esp
			flight1NumOfTickets = strtol(Line, NULL, 10) ;
  800229:	83 ec 04             	sub    $0x4,%esp
  80022c:	6a 0a                	push   $0xa
  80022e:	6a 00                	push   $0x0
  800230:	8d 85 59 fe ff ff    	lea    -0x1a7(%ebp),%eax
  800236:	50                   	push   %eax
  800237:	e8 0e 1f 00 00       	call   80214a <strtol>
  80023c:	83 c4 10             	add    $0x10,%esp
  80023f:	89 45 d0             	mov    %eax,-0x30(%ebp)
			readline("Enter # tickets of flight#2: ", Line);
  800242:	83 ec 08             	sub    $0x8,%esp
  800245:	8d 85 59 fe ff ff    	lea    -0x1a7(%ebp),%eax
  80024b:	50                   	push   %eax
  80024c:	68 60 3c 80 00       	push   $0x803c60
  800251:	e8 dd 18 00 00       	call   801b33 <readline>
  800256:	83 c4 10             	add    $0x10,%esp
			flight2NumOfTickets = strtol(Line, NULL, 10) ;
  800259:	83 ec 04             	sub    $0x4,%esp
  80025c:	6a 0a                	push   $0xa
  80025e:	6a 00                	push   $0x0
  800260:	8d 85 59 fe ff ff    	lea    -0x1a7(%ebp),%eax
  800266:	50                   	push   %eax
  800267:	e8 de 1e 00 00       	call   80214a <strtol>
  80026c:	83 c4 10             	add    $0x10,%esp
  80026f:	89 45 cc             	mov    %eax,-0x34(%ebp)
		}
	}
	sys_unlock_cons();
  800272:	e8 10 25 00 00       	call   802787 <sys_unlock_cons>

	// *************************************************************************************************
	/// Shared Variables Region ************************************************************************
	// *************************************************************************************************
	char _isOpened[] = "isOpened";
  800277:	8d 85 50 fe ff ff    	lea    -0x1b0(%ebp),%eax
  80027d:	bb 76 40 80 00       	mov    $0x804076,%ebx
  800282:	ba 09 00 00 00       	mov    $0x9,%edx
  800287:	89 c7                	mov    %eax,%edi
  800289:	89 de                	mov    %ebx,%esi
  80028b:	89 d1                	mov    %edx,%ecx
  80028d:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _agentCapacity[] = "agentCapacity";
  80028f:	8d 85 42 fe ff ff    	lea    -0x1be(%ebp),%eax
  800295:	bb 7f 40 80 00       	mov    $0x80407f,%ebx
  80029a:	ba 0e 00 00 00       	mov    $0xe,%edx
  80029f:	89 c7                	mov    %eax,%edi
  8002a1:	89 de                	mov    %ebx,%esi
  8002a3:	89 d1                	mov    %edx,%ecx
  8002a5:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _customers[] = "customers";
  8002a7:	8d 85 38 fe ff ff    	lea    -0x1c8(%ebp),%eax
  8002ad:	bb 8d 40 80 00       	mov    $0x80408d,%ebx
  8002b2:	ba 0a 00 00 00       	mov    $0xa,%edx
  8002b7:	89 c7                	mov    %eax,%edi
  8002b9:	89 de                	mov    %ebx,%esi
  8002bb:	89 d1                	mov    %edx,%ecx
  8002bd:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _custCounter[] = "custCounter";
  8002bf:	8d 85 2c fe ff ff    	lea    -0x1d4(%ebp),%eax
  8002c5:	bb 97 40 80 00       	mov    $0x804097,%ebx
  8002ca:	ba 03 00 00 00       	mov    $0x3,%edx
  8002cf:	89 c7                	mov    %eax,%edi
  8002d1:	89 de                	mov    %ebx,%esi
  8002d3:	89 d1                	mov    %edx,%ecx
  8002d5:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
	char _flight1Customers[] = "flight1Customers";
  8002d7:	8d 85 1b fe ff ff    	lea    -0x1e5(%ebp),%eax
  8002dd:	bb a3 40 80 00       	mov    $0x8040a3,%ebx
  8002e2:	ba 11 00 00 00       	mov    $0x11,%edx
  8002e7:	89 c7                	mov    %eax,%edi
  8002e9:	89 de                	mov    %ebx,%esi
  8002eb:	89 d1                	mov    %edx,%ecx
  8002ed:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _flight2Customers[] = "flight2Customers";
  8002ef:	8d 85 0a fe ff ff    	lea    -0x1f6(%ebp),%eax
  8002f5:	bb b4 40 80 00       	mov    $0x8040b4,%ebx
  8002fa:	ba 11 00 00 00       	mov    $0x11,%edx
  8002ff:	89 c7                	mov    %eax,%edi
  800301:	89 de                	mov    %ebx,%esi
  800303:	89 d1                	mov    %edx,%ecx
  800305:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _flight3Customers[] = "flight3Customers";
  800307:	8d 85 f9 fd ff ff    	lea    -0x207(%ebp),%eax
  80030d:	bb c5 40 80 00       	mov    $0x8040c5,%ebx
  800312:	ba 11 00 00 00       	mov    $0x11,%edx
  800317:	89 c7                	mov    %eax,%edi
  800319:	89 de                	mov    %ebx,%esi
  80031b:	89 d1                	mov    %edx,%ecx
  80031d:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _flight1Counter[] = "flight1Counter";
  80031f:	8d 85 ea fd ff ff    	lea    -0x216(%ebp),%eax
  800325:	bb d6 40 80 00       	mov    $0x8040d6,%ebx
  80032a:	ba 0f 00 00 00       	mov    $0xf,%edx
  80032f:	89 c7                	mov    %eax,%edi
  800331:	89 de                	mov    %ebx,%esi
  800333:	89 d1                	mov    %edx,%ecx
  800335:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _flight2Counter[] = "flight2Counter";
  800337:	8d 85 db fd ff ff    	lea    -0x225(%ebp),%eax
  80033d:	bb e5 40 80 00       	mov    $0x8040e5,%ebx
  800342:	ba 0f 00 00 00       	mov    $0xf,%edx
  800347:	89 c7                	mov    %eax,%edi
  800349:	89 de                	mov    %ebx,%esi
  80034b:	89 d1                	mov    %edx,%ecx
  80034d:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _flightBooked1Counter[] = "flightBooked1Counter";
  80034f:	8d 85 c6 fd ff ff    	lea    -0x23a(%ebp),%eax
  800355:	bb f4 40 80 00       	mov    $0x8040f4,%ebx
  80035a:	ba 15 00 00 00       	mov    $0x15,%edx
  80035f:	89 c7                	mov    %eax,%edi
  800361:	89 de                	mov    %ebx,%esi
  800363:	89 d1                	mov    %edx,%ecx
  800365:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _flightBooked2Counter[] = "flightBooked2Counter";
  800367:	8d 85 b1 fd ff ff    	lea    -0x24f(%ebp),%eax
  80036d:	bb 09 41 80 00       	mov    $0x804109,%ebx
  800372:	ba 15 00 00 00       	mov    $0x15,%edx
  800377:	89 c7                	mov    %eax,%edi
  800379:	89 de                	mov    %ebx,%esi
  80037b:	89 d1                	mov    %edx,%ecx
  80037d:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _flightBooked1Arr[] = "flightBooked1Arr";
  80037f:	8d 85 a0 fd ff ff    	lea    -0x260(%ebp),%eax
  800385:	bb 1e 41 80 00       	mov    $0x80411e,%ebx
  80038a:	ba 11 00 00 00       	mov    $0x11,%edx
  80038f:	89 c7                	mov    %eax,%edi
  800391:	89 de                	mov    %ebx,%esi
  800393:	89 d1                	mov    %edx,%ecx
  800395:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _flightBooked2Arr[] = "flightBooked2Arr";
  800397:	8d 85 8f fd ff ff    	lea    -0x271(%ebp),%eax
  80039d:	bb 2f 41 80 00       	mov    $0x80412f,%ebx
  8003a2:	ba 11 00 00 00       	mov    $0x11,%edx
  8003a7:	89 c7                	mov    %eax,%edi
  8003a9:	89 de                	mov    %ebx,%esi
  8003ab:	89 d1                	mov    %edx,%ecx
  8003ad:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _cust_ready_queue[] = "cust_ready_queue";
  8003af:	8d 85 7e fd ff ff    	lea    -0x282(%ebp),%eax
  8003b5:	bb 40 41 80 00       	mov    $0x804140,%ebx
  8003ba:	ba 11 00 00 00       	mov    $0x11,%edx
  8003bf:	89 c7                	mov    %eax,%edi
  8003c1:	89 de                	mov    %ebx,%esi
  8003c3:	89 d1                	mov    %edx,%ecx
  8003c5:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _queue_in[] = "queue_in";
  8003c7:	8d 85 75 fd ff ff    	lea    -0x28b(%ebp),%eax
  8003cd:	bb 51 41 80 00       	mov    $0x804151,%ebx
  8003d2:	ba 09 00 00 00       	mov    $0x9,%edx
  8003d7:	89 c7                	mov    %eax,%edi
  8003d9:	89 de                	mov    %ebx,%esi
  8003db:	89 d1                	mov    %edx,%ecx
  8003dd:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _queue_out[] = "queue_out";
  8003df:	8d 85 6b fd ff ff    	lea    -0x295(%ebp),%eax
  8003e5:	bb 5a 41 80 00       	mov    $0x80415a,%ebx
  8003ea:	ba 0a 00 00 00       	mov    $0xa,%edx
  8003ef:	89 c7                	mov    %eax,%edi
  8003f1:	89 de                	mov    %ebx,%esi
  8003f3:	89 d1                	mov    %edx,%ecx
  8003f5:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)

	char _cust_ready[] = "cust_ready";
  8003f7:	8d 85 60 fd ff ff    	lea    -0x2a0(%ebp),%eax
  8003fd:	bb 64 41 80 00       	mov    $0x804164,%ebx
  800402:	ba 0b 00 00 00       	mov    $0xb,%edx
  800407:	89 c7                	mov    %eax,%edi
  800409:	89 de                	mov    %ebx,%esi
  80040b:	89 d1                	mov    %edx,%ecx
  80040d:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _custQueueCS[] = "custQueueCS";
  80040f:	8d 85 54 fd ff ff    	lea    -0x2ac(%ebp),%eax
  800415:	bb 6f 41 80 00       	mov    $0x80416f,%ebx
  80041a:	ba 03 00 00 00       	mov    $0x3,%edx
  80041f:	89 c7                	mov    %eax,%edi
  800421:	89 de                	mov    %ebx,%esi
  800423:	89 d1                	mov    %edx,%ecx
  800425:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
	char _flight1CS[] = "flight1CS";
  800427:	8d 85 4a fd ff ff    	lea    -0x2b6(%ebp),%eax
  80042d:	bb 7b 41 80 00       	mov    $0x80417b,%ebx
  800432:	ba 0a 00 00 00       	mov    $0xa,%edx
  800437:	89 c7                	mov    %eax,%edi
  800439:	89 de                	mov    %ebx,%esi
  80043b:	89 d1                	mov    %edx,%ecx
  80043d:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _flight2CS[] = "flight2CS";
  80043f:	8d 85 40 fd ff ff    	lea    -0x2c0(%ebp),%eax
  800445:	bb 85 41 80 00       	mov    $0x804185,%ebx
  80044a:	ba 0a 00 00 00       	mov    $0xa,%edx
  80044f:	89 c7                	mov    %eax,%edi
  800451:	89 de                	mov    %ebx,%esi
  800453:	89 d1                	mov    %edx,%ecx
  800455:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)

	char _clerk[] = "clerk";
  800457:	c7 85 3a fd ff ff 63 	movl   $0x72656c63,-0x2c6(%ebp)
  80045e:	6c 65 72 
  800461:	66 c7 85 3e fd ff ff 	movw   $0x6b,-0x2c2(%ebp)
  800468:	6b 00 
	char _custCounterCS[] = "custCounterCS";
  80046a:	8d 85 2c fd ff ff    	lea    -0x2d4(%ebp),%eax
  800470:	bb 8f 41 80 00       	mov    $0x80418f,%ebx
  800475:	ba 0e 00 00 00       	mov    $0xe,%edx
  80047a:	89 c7                	mov    %eax,%edi
  80047c:	89 de                	mov    %ebx,%esi
  80047e:	89 d1                	mov    %edx,%ecx
  800480:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _custTerminated[] = "custTerminated";
  800482:	8d 85 1d fd ff ff    	lea    -0x2e3(%ebp),%eax
  800488:	bb 9d 41 80 00       	mov    $0x80419d,%ebx
  80048d:	ba 0f 00 00 00       	mov    $0xf,%edx
  800492:	89 c7                	mov    %eax,%edi
  800494:	89 de                	mov    %ebx,%esi
  800496:	89 d1                	mov    %edx,%ecx
  800498:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _clerkTerminated[] = "clerkTerminated";
  80049a:	8d 85 0d fd ff ff    	lea    -0x2f3(%ebp),%eax
  8004a0:	bb ac 41 80 00       	mov    $0x8041ac,%ebx
  8004a5:	ba 04 00 00 00       	mov    $0x4,%edx
  8004aa:	89 c7                	mov    %eax,%edi
  8004ac:	89 de                	mov    %ebx,%esi
  8004ae:	89 d1                	mov    %edx,%ecx
  8004b0:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)

	char _taircl[] = "taircl";
  8004b2:	8d 85 06 fd ff ff    	lea    -0x2fa(%ebp),%eax
  8004b8:	bb bc 41 80 00       	mov    $0x8041bc,%ebx
  8004bd:	ba 07 00 00 00       	mov    $0x7,%edx
  8004c2:	89 c7                	mov    %eax,%edi
  8004c4:	89 de                	mov    %ebx,%esi
  8004c6:	89 d1                	mov    %edx,%ecx
  8004c8:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _taircu[] = "taircu";
  8004ca:	8d 85 ff fc ff ff    	lea    -0x301(%ebp),%eax
  8004d0:	bb c3 41 80 00       	mov    $0x8041c3,%ebx
  8004d5:	ba 07 00 00 00       	mov    $0x7,%edx
  8004da:	89 c7                	mov    %eax,%edi
  8004dc:	89 de                	mov    %ebx,%esi
  8004de:	89 d1                	mov    %edx,%ecx
  8004e0:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)

	struct Customer * custs;
	custs = smalloc(_customers, sizeof(struct Customer)*(numOfCustomers+1), 1);
  8004e2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8004e5:	40                   	inc    %eax
  8004e6:	c1 e0 03             	shl    $0x3,%eax
  8004e9:	83 ec 04             	sub    $0x4,%esp
  8004ec:	6a 01                	push   $0x1
  8004ee:	50                   	push   %eax
  8004ef:	8d 85 38 fe ff ff    	lea    -0x1c8(%ebp),%eax
  8004f5:	50                   	push   %eax
  8004f6:	e8 71 21 00 00       	call   80266c <smalloc>
  8004fb:	83 c4 10             	add    $0x10,%esp
  8004fe:	89 45 98             	mov    %eax,-0x68(%ebp)
	//sys_createSharedObject("customers", sizeof(struct Customer)*numOfCustomers, 1, (void**)&custs);

	int* flight1Customers = smalloc(_flight1Customers, sizeof(int), 1); *flight1Customers = flight1NumOfCustomers;
  800501:	83 ec 04             	sub    $0x4,%esp
  800504:	6a 01                	push   $0x1
  800506:	6a 04                	push   $0x4
  800508:	8d 85 1b fe ff ff    	lea    -0x1e5(%ebp),%eax
  80050e:	50                   	push   %eax
  80050f:	e8 58 21 00 00       	call   80266c <smalloc>
  800514:	83 c4 10             	add    $0x10,%esp
  800517:	89 45 94             	mov    %eax,-0x6c(%ebp)
  80051a:	8b 45 94             	mov    -0x6c(%ebp),%eax
  80051d:	8b 55 dc             	mov    -0x24(%ebp),%edx
  800520:	89 10                	mov    %edx,(%eax)
	int* flight2Customers = smalloc(_flight2Customers, sizeof(int), 1); *flight2Customers = flight2NumOfCustomers;
  800522:	83 ec 04             	sub    $0x4,%esp
  800525:	6a 01                	push   $0x1
  800527:	6a 04                	push   $0x4
  800529:	8d 85 0a fe ff ff    	lea    -0x1f6(%ebp),%eax
  80052f:	50                   	push   %eax
  800530:	e8 37 21 00 00       	call   80266c <smalloc>
  800535:	83 c4 10             	add    $0x10,%esp
  800538:	89 45 90             	mov    %eax,-0x70(%ebp)
  80053b:	8b 45 90             	mov    -0x70(%ebp),%eax
  80053e:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800541:	89 10                	mov    %edx,(%eax)
	int* flight3Customers = smalloc(_flight3Customers, sizeof(int), 1); *flight3Customers = flight3NumOfCustomers;
  800543:	83 ec 04             	sub    $0x4,%esp
  800546:	6a 01                	push   $0x1
  800548:	6a 04                	push   $0x4
  80054a:	8d 85 f9 fd ff ff    	lea    -0x207(%ebp),%eax
  800550:	50                   	push   %eax
  800551:	e8 16 21 00 00       	call   80266c <smalloc>
  800556:	83 c4 10             	add    $0x10,%esp
  800559:	89 45 8c             	mov    %eax,-0x74(%ebp)
  80055c:	8b 45 8c             	mov    -0x74(%ebp),%eax
  80055f:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  800562:	89 10                	mov    %edx,(%eax)

	int* isOpened = smalloc(_isOpened, sizeof(int), 0);
  800564:	83 ec 04             	sub    $0x4,%esp
  800567:	6a 00                	push   $0x0
  800569:	6a 04                	push   $0x4
  80056b:	8d 85 50 fe ff ff    	lea    -0x1b0(%ebp),%eax
  800571:	50                   	push   %eax
  800572:	e8 f5 20 00 00       	call   80266c <smalloc>
  800577:	83 c4 10             	add    $0x10,%esp
  80057a:	89 45 88             	mov    %eax,-0x78(%ebp)
	*isOpened = 1;
  80057d:	8b 45 88             	mov    -0x78(%ebp),%eax
  800580:	c7 00 01 00 00 00    	movl   $0x1,(%eax)

	int* custCounter = smalloc(_custCounter, sizeof(int), 1);
  800586:	83 ec 04             	sub    $0x4,%esp
  800589:	6a 01                	push   $0x1
  80058b:	6a 04                	push   $0x4
  80058d:	8d 85 2c fe ff ff    	lea    -0x1d4(%ebp),%eax
  800593:	50                   	push   %eax
  800594:	e8 d3 20 00 00       	call   80266c <smalloc>
  800599:	83 c4 10             	add    $0x10,%esp
  80059c:	89 45 84             	mov    %eax,-0x7c(%ebp)
	*custCounter = 0;
  80059f:	8b 45 84             	mov    -0x7c(%ebp),%eax
  8005a2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

	int* flight1Counter = smalloc(_flight1Counter, sizeof(int), 1);
  8005a8:	83 ec 04             	sub    $0x4,%esp
  8005ab:	6a 01                	push   $0x1
  8005ad:	6a 04                	push   $0x4
  8005af:	8d 85 ea fd ff ff    	lea    -0x216(%ebp),%eax
  8005b5:	50                   	push   %eax
  8005b6:	e8 b1 20 00 00       	call   80266c <smalloc>
  8005bb:	83 c4 10             	add    $0x10,%esp
  8005be:	89 45 80             	mov    %eax,-0x80(%ebp)
	*flight1Counter = flight1NumOfTickets;
  8005c1:	8b 45 80             	mov    -0x80(%ebp),%eax
  8005c4:	8b 55 d0             	mov    -0x30(%ebp),%edx
  8005c7:	89 10                	mov    %edx,(%eax)

	int* flight2Counter = smalloc(_flight2Counter, sizeof(int), 1);
  8005c9:	83 ec 04             	sub    $0x4,%esp
  8005cc:	6a 01                	push   $0x1
  8005ce:	6a 04                	push   $0x4
  8005d0:	8d 85 db fd ff ff    	lea    -0x225(%ebp),%eax
  8005d6:	50                   	push   %eax
  8005d7:	e8 90 20 00 00       	call   80266c <smalloc>
  8005dc:	83 c4 10             	add    $0x10,%esp
  8005df:	89 85 7c ff ff ff    	mov    %eax,-0x84(%ebp)
	*flight2Counter = flight2NumOfTickets;
  8005e5:	8b 85 7c ff ff ff    	mov    -0x84(%ebp),%eax
  8005eb:	8b 55 cc             	mov    -0x34(%ebp),%edx
  8005ee:	89 10                	mov    %edx,(%eax)

	int* flight1BookedCounter = smalloc(_flightBooked1Counter, sizeof(int), 1);
  8005f0:	83 ec 04             	sub    $0x4,%esp
  8005f3:	6a 01                	push   $0x1
  8005f5:	6a 04                	push   $0x4
  8005f7:	8d 85 c6 fd ff ff    	lea    -0x23a(%ebp),%eax
  8005fd:	50                   	push   %eax
  8005fe:	e8 69 20 00 00       	call   80266c <smalloc>
  800603:	83 c4 10             	add    $0x10,%esp
  800606:	89 85 78 ff ff ff    	mov    %eax,-0x88(%ebp)
	*flight1BookedCounter = 0;
  80060c:	8b 85 78 ff ff ff    	mov    -0x88(%ebp),%eax
  800612:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

	int* flight2BookedCounter = smalloc(_flightBooked2Counter, sizeof(int), 1);
  800618:	83 ec 04             	sub    $0x4,%esp
  80061b:	6a 01                	push   $0x1
  80061d:	6a 04                	push   $0x4
  80061f:	8d 85 b1 fd ff ff    	lea    -0x24f(%ebp),%eax
  800625:	50                   	push   %eax
  800626:	e8 41 20 00 00       	call   80266c <smalloc>
  80062b:	83 c4 10             	add    $0x10,%esp
  80062e:	89 85 74 ff ff ff    	mov    %eax,-0x8c(%ebp)
	*flight2BookedCounter = 0;
  800634:	8b 85 74 ff ff ff    	mov    -0x8c(%ebp),%eax
  80063a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

	int* flight1BookedArr = smalloc(_flightBooked1Arr, sizeof(int)*flight1NumOfTickets, 1);
  800640:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800643:	c1 e0 02             	shl    $0x2,%eax
  800646:	83 ec 04             	sub    $0x4,%esp
  800649:	6a 01                	push   $0x1
  80064b:	50                   	push   %eax
  80064c:	8d 85 a0 fd ff ff    	lea    -0x260(%ebp),%eax
  800652:	50                   	push   %eax
  800653:	e8 14 20 00 00       	call   80266c <smalloc>
  800658:	83 c4 10             	add    $0x10,%esp
  80065b:	89 85 70 ff ff ff    	mov    %eax,-0x90(%ebp)
	int* flight2BookedArr = smalloc(_flightBooked2Arr, sizeof(int)*flight2NumOfTickets, 1);
  800661:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800664:	c1 e0 02             	shl    $0x2,%eax
  800667:	83 ec 04             	sub    $0x4,%esp
  80066a:	6a 01                	push   $0x1
  80066c:	50                   	push   %eax
  80066d:	8d 85 8f fd ff ff    	lea    -0x271(%ebp),%eax
  800673:	50                   	push   %eax
  800674:	e8 f3 1f 00 00       	call   80266c <smalloc>
  800679:	83 c4 10             	add    $0x10,%esp
  80067c:	89 85 6c ff ff ff    	mov    %eax,-0x94(%ebp)

	int* cust_ready_queue = smalloc(_cust_ready_queue, sizeof(int)*(numOfCustomers+1), 1);
  800682:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800685:	40                   	inc    %eax
  800686:	c1 e0 02             	shl    $0x2,%eax
  800689:	83 ec 04             	sub    $0x4,%esp
  80068c:	6a 01                	push   $0x1
  80068e:	50                   	push   %eax
  80068f:	8d 85 7e fd ff ff    	lea    -0x282(%ebp),%eax
  800695:	50                   	push   %eax
  800696:	e8 d1 1f 00 00       	call   80266c <smalloc>
  80069b:	83 c4 10             	add    $0x10,%esp
  80069e:	89 85 68 ff ff ff    	mov    %eax,-0x98(%ebp)

	int* queue_in = smalloc(_queue_in, sizeof(int), 1);
  8006a4:	83 ec 04             	sub    $0x4,%esp
  8006a7:	6a 01                	push   $0x1
  8006a9:	6a 04                	push   $0x4
  8006ab:	8d 85 75 fd ff ff    	lea    -0x28b(%ebp),%eax
  8006b1:	50                   	push   %eax
  8006b2:	e8 b5 1f 00 00       	call   80266c <smalloc>
  8006b7:	83 c4 10             	add    $0x10,%esp
  8006ba:	89 85 64 ff ff ff    	mov    %eax,-0x9c(%ebp)
	*queue_in = 0;
  8006c0:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
  8006c6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

	int* queue_out = smalloc(_queue_out, sizeof(int), 1);
  8006cc:	83 ec 04             	sub    $0x4,%esp
  8006cf:	6a 01                	push   $0x1
  8006d1:	6a 04                	push   $0x4
  8006d3:	8d 85 6b fd ff ff    	lea    -0x295(%ebp),%eax
  8006d9:	50                   	push   %eax
  8006da:	e8 8d 1f 00 00       	call   80266c <smalloc>
  8006df:	83 c4 10             	add    $0x10,%esp
  8006e2:	89 85 60 ff ff ff    	mov    %eax,-0xa0(%ebp)
	*queue_out = 0;
  8006e8:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
  8006ee:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

	// *************************************************************************************************
	/// Semaphores Region ******************************************************************************
	// *************************************************************************************************
	struct semaphore capacity = create_semaphore(_agentCapacity, agentCapacity);
  8006f4:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8006f7:	8d 85 f8 fc ff ff    	lea    -0x308(%ebp),%eax
  8006fd:	83 ec 04             	sub    $0x4,%esp
  800700:	52                   	push   %edx
  800701:	8d 95 42 fe ff ff    	lea    -0x1be(%ebp),%edx
  800707:	52                   	push   %edx
  800708:	50                   	push   %eax
  800709:	e8 41 30 00 00       	call   80374f <create_semaphore>
  80070e:	83 c4 0c             	add    $0xc,%esp

	struct semaphore flight1CS = create_semaphore(_flight1CS, 1);
  800711:	8d 85 f4 fc ff ff    	lea    -0x30c(%ebp),%eax
  800717:	83 ec 04             	sub    $0x4,%esp
  80071a:	6a 01                	push   $0x1
  80071c:	8d 95 4a fd ff ff    	lea    -0x2b6(%ebp),%edx
  800722:	52                   	push   %edx
  800723:	50                   	push   %eax
  800724:	e8 26 30 00 00       	call   80374f <create_semaphore>
  800729:	83 c4 0c             	add    $0xc,%esp
	struct semaphore flight2CS = create_semaphore(_flight2CS, 1);
  80072c:	8d 85 f0 fc ff ff    	lea    -0x310(%ebp),%eax
  800732:	83 ec 04             	sub    $0x4,%esp
  800735:	6a 01                	push   $0x1
  800737:	8d 95 40 fd ff ff    	lea    -0x2c0(%ebp),%edx
  80073d:	52                   	push   %edx
  80073e:	50                   	push   %eax
  80073f:	e8 0b 30 00 00       	call   80374f <create_semaphore>
  800744:	83 c4 0c             	add    $0xc,%esp

	struct semaphore custCounterCS = create_semaphore(_custCounterCS, 1);
  800747:	8d 85 ec fc ff ff    	lea    -0x314(%ebp),%eax
  80074d:	83 ec 04             	sub    $0x4,%esp
  800750:	6a 01                	push   $0x1
  800752:	8d 95 2c fd ff ff    	lea    -0x2d4(%ebp),%edx
  800758:	52                   	push   %edx
  800759:	50                   	push   %eax
  80075a:	e8 f0 2f 00 00       	call   80374f <create_semaphore>
  80075f:	83 c4 0c             	add    $0xc,%esp
	struct semaphore custQueueCS = create_semaphore(_custQueueCS, 1);
  800762:	8d 85 e8 fc ff ff    	lea    -0x318(%ebp),%eax
  800768:	83 ec 04             	sub    $0x4,%esp
  80076b:	6a 01                	push   $0x1
  80076d:	8d 95 54 fd ff ff    	lea    -0x2ac(%ebp),%edx
  800773:	52                   	push   %edx
  800774:	50                   	push   %eax
  800775:	e8 d5 2f 00 00       	call   80374f <create_semaphore>
  80077a:	83 c4 0c             	add    $0xc,%esp

	struct semaphore clerk = create_semaphore(_clerk, 3);
  80077d:	8d 85 e4 fc ff ff    	lea    -0x31c(%ebp),%eax
  800783:	83 ec 04             	sub    $0x4,%esp
  800786:	6a 03                	push   $0x3
  800788:	8d 95 3a fd ff ff    	lea    -0x2c6(%ebp),%edx
  80078e:	52                   	push   %edx
  80078f:	50                   	push   %eax
  800790:	e8 ba 2f 00 00       	call   80374f <create_semaphore>
  800795:	83 c4 0c             	add    $0xc,%esp

	struct semaphore cust_ready = create_semaphore(_cust_ready, 0);
  800798:	8d 85 e0 fc ff ff    	lea    -0x320(%ebp),%eax
  80079e:	83 ec 04             	sub    $0x4,%esp
  8007a1:	6a 00                	push   $0x0
  8007a3:	8d 95 60 fd ff ff    	lea    -0x2a0(%ebp),%edx
  8007a9:	52                   	push   %edx
  8007aa:	50                   	push   %eax
  8007ab:	e8 9f 2f 00 00       	call   80374f <create_semaphore>
  8007b0:	83 c4 0c             	add    $0xc,%esp

	struct semaphore custTerminated = create_semaphore(_custTerminated, 0);
  8007b3:	8d 85 dc fc ff ff    	lea    -0x324(%ebp),%eax
  8007b9:	83 ec 04             	sub    $0x4,%esp
  8007bc:	6a 00                	push   $0x0
  8007be:	8d 95 1d fd ff ff    	lea    -0x2e3(%ebp),%edx
  8007c4:	52                   	push   %edx
  8007c5:	50                   	push   %eax
  8007c6:	e8 84 2f 00 00       	call   80374f <create_semaphore>
  8007cb:	83 c4 0c             	add    $0xc,%esp
	struct semaphore clerkTerminated = create_semaphore(_clerkTerminated, 0);
  8007ce:	8d 85 d8 fc ff ff    	lea    -0x328(%ebp),%eax
  8007d4:	83 ec 04             	sub    $0x4,%esp
  8007d7:	6a 00                	push   $0x0
  8007d9:	8d 95 0d fd ff ff    	lea    -0x2f3(%ebp),%edx
  8007df:	52                   	push   %edx
  8007e0:	50                   	push   %eax
  8007e1:	e8 69 2f 00 00       	call   80374f <create_semaphore>
  8007e6:	83 c4 0c             	add    $0xc,%esp

	struct semaphore* cust_finished = smalloc("cust_finished_array", numOfCustomers*sizeof(struct semaphore), 1);
  8007e9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8007ec:	c1 e0 02             	shl    $0x2,%eax
  8007ef:	83 ec 04             	sub    $0x4,%esp
  8007f2:	6a 01                	push   $0x1
  8007f4:	50                   	push   %eax
  8007f5:	68 7e 3c 80 00       	push   $0x803c7e
  8007fa:	e8 6d 1e 00 00       	call   80266c <smalloc>
  8007ff:	83 c4 10             	add    $0x10,%esp
  800802:	89 85 5c ff ff ff    	mov    %eax,-0xa4(%ebp)

	int s=0;
  800808:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
	for(s=0; s<numOfCustomers; ++s)
  80080f:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
  800816:	e9 9a 00 00 00       	jmp    8008b5 <_main+0x87d>
	{
		char prefix[30]="cust_finished";
  80081b:	8d 85 ae fc ff ff    	lea    -0x352(%ebp),%eax
  800821:	bb ca 41 80 00       	mov    $0x8041ca,%ebx
  800826:	ba 0e 00 00 00       	mov    $0xe,%edx
  80082b:	89 c7                	mov    %eax,%edi
  80082d:	89 de                	mov    %ebx,%esi
  80082f:	89 d1                	mov    %edx,%ecx
  800831:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  800833:	8d 95 bc fc ff ff    	lea    -0x344(%ebp),%edx
  800839:	b9 04 00 00 00       	mov    $0x4,%ecx
  80083e:	b8 00 00 00 00       	mov    $0x0,%eax
  800843:	89 d7                	mov    %edx,%edi
  800845:	f3 ab                	rep stos %eax,%es:(%edi)
		char id[5]; char sname[50];
		ltostr(s, id);
  800847:	83 ec 08             	sub    $0x8,%esp
  80084a:	8d 85 a9 fc ff ff    	lea    -0x357(%ebp),%eax
  800850:	50                   	push   %eax
  800851:	ff 75 c4             	pushl  -0x3c(%ebp)
  800854:	e8 37 1a 00 00       	call   802290 <ltostr>
  800859:	83 c4 10             	add    $0x10,%esp
		strcconcat(prefix, id, sname);
  80085c:	83 ec 04             	sub    $0x4,%esp
  80085f:	8d 85 77 fc ff ff    	lea    -0x389(%ebp),%eax
  800865:	50                   	push   %eax
  800866:	8d 85 a9 fc ff ff    	lea    -0x357(%ebp),%eax
  80086c:	50                   	push   %eax
  80086d:	8d 85 ae fc ff ff    	lea    -0x352(%ebp),%eax
  800873:	50                   	push   %eax
  800874:	e8 f0 1a 00 00       	call   802369 <strcconcat>
  800879:	83 c4 10             	add    $0x10,%esp
		//sys_createSemaphore(sname, 0);
		cust_finished[s] = create_semaphore(sname, 0);
  80087c:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  80087f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800886:	8b 85 5c ff ff ff    	mov    -0xa4(%ebp),%eax
  80088c:	8d 1c 02             	lea    (%edx,%eax,1),%ebx
  80088f:	8d 85 64 fc ff ff    	lea    -0x39c(%ebp),%eax
  800895:	83 ec 04             	sub    $0x4,%esp
  800898:	6a 00                	push   $0x0
  80089a:	8d 95 77 fc ff ff    	lea    -0x389(%ebp),%edx
  8008a0:	52                   	push   %edx
  8008a1:	50                   	push   %eax
  8008a2:	e8 a8 2e 00 00       	call   80374f <create_semaphore>
  8008a7:	83 c4 0c             	add    $0xc,%esp
  8008aa:	8b 85 64 fc ff ff    	mov    -0x39c(%ebp),%eax
  8008b0:	89 03                	mov    %eax,(%ebx)
	struct semaphore clerkTerminated = create_semaphore(_clerkTerminated, 0);

	struct semaphore* cust_finished = smalloc("cust_finished_array", numOfCustomers*sizeof(struct semaphore), 1);

	int s=0;
	for(s=0; s<numOfCustomers; ++s)
  8008b2:	ff 45 c4             	incl   -0x3c(%ebp)
  8008b5:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8008b8:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8008bb:	0f 8c 5a ff ff ff    	jl     80081b <_main+0x7e3>
	// start all clerks and customers ******************************************************************
	// *************************************************************************************************

	//clerks
	uint32 envId;
	for (int k = 0; k < numOfClerks; ++k)
  8008c1:	c7 45 c0 00 00 00 00 	movl   $0x0,-0x40(%ebp)
  8008c8:	eb 50                	jmp    80091a <_main+0x8e2>
	{
		envId = sys_create_env(_taircl, (myEnv->page_WS_max_size),(myEnv->SecondListSize), (myEnv->percentage_of_WS_pages_to_be_removed));
  8008ca:	a1 20 50 80 00       	mov    0x805020,%eax
  8008cf:	8b 90 3c da 01 00    	mov    0x1da3c(%eax),%edx
  8008d5:	a1 20 50 80 00       	mov    0x805020,%eax
  8008da:	8b 80 34 da 01 00    	mov    0x1da34(%eax),%eax
  8008e0:	89 c1                	mov    %eax,%ecx
  8008e2:	a1 20 50 80 00       	mov    0x805020,%eax
  8008e7:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
  8008ed:	52                   	push   %edx
  8008ee:	51                   	push   %ecx
  8008ef:	50                   	push   %eax
  8008f0:	8d 85 06 fd ff ff    	lea    -0x2fa(%ebp),%eax
  8008f6:	50                   	push   %eax
  8008f7:	e8 7c 20 00 00       	call   802978 <sys_create_env>
  8008fc:	83 c4 10             	add    $0x10,%esp
  8008ff:	89 85 58 ff ff ff    	mov    %eax,-0xa8(%ebp)
		sys_run_env(envId);
  800905:	8b 85 58 ff ff ff    	mov    -0xa8(%ebp),%eax
  80090b:	83 ec 0c             	sub    $0xc,%esp
  80090e:	50                   	push   %eax
  80090f:	e8 82 20 00 00       	call   802996 <sys_run_env>
  800914:	83 c4 10             	add    $0x10,%esp
	// start all clerks and customers ******************************************************************
	// *************************************************************************************************

	//clerks
	uint32 envId;
	for (int k = 0; k < numOfClerks; ++k)
  800917:	ff 45 c0             	incl   -0x40(%ebp)
  80091a:	8b 45 c0             	mov    -0x40(%ebp),%eax
  80091d:	3b 45 9c             	cmp    -0x64(%ebp),%eax
  800920:	7c a8                	jl     8008ca <_main+0x892>
		sys_run_env(envId);
	}

	//customers
	int c;
	for(c=0; c< numOfCustomers;++c)
  800922:	c7 45 bc 00 00 00 00 	movl   $0x0,-0x44(%ebp)
  800929:	eb 70                	jmp    80099b <_main+0x963>
	{
		envId = sys_create_env(_taircu, (myEnv->page_WS_max_size),(myEnv->SecondListSize), (myEnv->percentage_of_WS_pages_to_be_removed));
  80092b:	a1 20 50 80 00       	mov    0x805020,%eax
  800930:	8b 90 3c da 01 00    	mov    0x1da3c(%eax),%edx
  800936:	a1 20 50 80 00       	mov    0x805020,%eax
  80093b:	8b 80 34 da 01 00    	mov    0x1da34(%eax),%eax
  800941:	89 c1                	mov    %eax,%ecx
  800943:	a1 20 50 80 00       	mov    0x805020,%eax
  800948:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
  80094e:	52                   	push   %edx
  80094f:	51                   	push   %ecx
  800950:	50                   	push   %eax
  800951:	8d 85 ff fc ff ff    	lea    -0x301(%ebp),%eax
  800957:	50                   	push   %eax
  800958:	e8 1b 20 00 00       	call   802978 <sys_create_env>
  80095d:	83 c4 10             	add    $0x10,%esp
  800960:	89 85 58 ff ff ff    	mov    %eax,-0xa8(%ebp)
		if (envId == E_ENV_CREATION_ERROR)
  800966:	83 bd 58 ff ff ff ef 	cmpl   $0xffffffef,-0xa8(%ebp)
  80096d:	75 17                	jne    800986 <_main+0x94e>
			panic("NO AVAILABLE ENVs... Please reduce the num of customers and try again");
  80096f:	83 ec 04             	sub    $0x4,%esp
  800972:	68 94 3c 80 00       	push   $0x803c94
  800977:	68 b5 00 00 00       	push   $0xb5
  80097c:	68 da 3c 80 00       	push   $0x803cda
  800981:	e8 06 08 00 00       	call   80118c <_panic>

		sys_run_env(envId);
  800986:	8b 85 58 ff ff ff    	mov    -0xa8(%ebp),%eax
  80098c:	83 ec 0c             	sub    $0xc,%esp
  80098f:	50                   	push   %eax
  800990:	e8 01 20 00 00       	call   802996 <sys_run_env>
  800995:	83 c4 10             	add    $0x10,%esp
		sys_run_env(envId);
	}

	//customers
	int c;
	for(c=0; c< numOfCustomers;++c)
  800998:	ff 45 bc             	incl   -0x44(%ebp)
  80099b:	8b 45 bc             	mov    -0x44(%ebp),%eax
  80099e:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8009a1:	7c 88                	jl     80092b <_main+0x8f3>

		sys_run_env(envId);
	}

	//wait until all customers terminated
	for(c=0; c< numOfCustomers;++c)
  8009a3:	c7 45 bc 00 00 00 00 	movl   $0x0,-0x44(%ebp)
  8009aa:	eb 14                	jmp    8009c0 <_main+0x988>
	{
		wait_semaphore(custTerminated);
  8009ac:	83 ec 0c             	sub    $0xc,%esp
  8009af:	ff b5 dc fc ff ff    	pushl  -0x324(%ebp)
  8009b5:	e8 c9 2d 00 00       	call   803783 <wait_semaphore>
  8009ba:	83 c4 10             	add    $0x10,%esp

		sys_run_env(envId);
	}

	//wait until all customers terminated
	for(c=0; c< numOfCustomers;++c)
  8009bd:	ff 45 bc             	incl   -0x44(%ebp)
  8009c0:	8b 45 bc             	mov    -0x44(%ebp),%eax
  8009c3:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8009c6:	7c e4                	jl     8009ac <_main+0x974>
	{
		wait_semaphore(custTerminated);
	}

	env_sleep(1500);
  8009c8:	83 ec 0c             	sub    $0xc,%esp
  8009cb:	68 dc 05 00 00       	push   $0x5dc
  8009d0:	e8 ed 2d 00 00       	call   8037c2 <env_sleep>
  8009d5:	83 c4 10             	add    $0x10,%esp
	int b;

	sys_lock_cons();
  8009d8:	e8 90 1d 00 00       	call   80276d <sys_lock_cons>
	{
	//print out the results
	for(b=0; b< (*flight1BookedCounter);++b)
  8009dd:	c7 45 b8 00 00 00 00 	movl   $0x0,-0x48(%ebp)
  8009e4:	eb 4b                	jmp    800a31 <_main+0x9f9>
	{
		cprintf("cust %d booked flight 1, originally ordered %d\n", flight1BookedArr[b], custs[flight1BookedArr[b]].flightType);
  8009e6:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8009e9:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8009f0:	8b 85 70 ff ff ff    	mov    -0x90(%ebp),%eax
  8009f6:	01 d0                	add    %edx,%eax
  8009f8:	8b 00                	mov    (%eax),%eax
  8009fa:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  800a01:	8b 45 98             	mov    -0x68(%ebp),%eax
  800a04:	01 d0                	add    %edx,%eax
  800a06:	8b 10                	mov    (%eax),%edx
  800a08:	8b 45 b8             	mov    -0x48(%ebp),%eax
  800a0b:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800a12:	8b 85 70 ff ff ff    	mov    -0x90(%ebp),%eax
  800a18:	01 c8                	add    %ecx,%eax
  800a1a:	8b 00                	mov    (%eax),%eax
  800a1c:	83 ec 04             	sub    $0x4,%esp
  800a1f:	52                   	push   %edx
  800a20:	50                   	push   %eax
  800a21:	68 ec 3c 80 00       	push   $0x803cec
  800a26:	e8 2f 0a 00 00       	call   80145a <cprintf>
  800a2b:	83 c4 10             	add    $0x10,%esp
	int b;

	sys_lock_cons();
	{
	//print out the results
	for(b=0; b< (*flight1BookedCounter);++b)
  800a2e:	ff 45 b8             	incl   -0x48(%ebp)
  800a31:	8b 85 78 ff ff ff    	mov    -0x88(%ebp),%eax
  800a37:	8b 00                	mov    (%eax),%eax
  800a39:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  800a3c:	7f a8                	jg     8009e6 <_main+0x9ae>
	{
		cprintf("cust %d booked flight 1, originally ordered %d\n", flight1BookedArr[b], custs[flight1BookedArr[b]].flightType);
	}

	for(b=0; b< (*flight2BookedCounter);++b)
  800a3e:	c7 45 b8 00 00 00 00 	movl   $0x0,-0x48(%ebp)
  800a45:	eb 4b                	jmp    800a92 <_main+0xa5a>
	{
		cprintf("cust %d booked flight 2, originally ordered %d\n", flight2BookedArr[b], custs[flight2BookedArr[b]].flightType);
  800a47:	8b 45 b8             	mov    -0x48(%ebp),%eax
  800a4a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800a51:	8b 85 6c ff ff ff    	mov    -0x94(%ebp),%eax
  800a57:	01 d0                	add    %edx,%eax
  800a59:	8b 00                	mov    (%eax),%eax
  800a5b:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  800a62:	8b 45 98             	mov    -0x68(%ebp),%eax
  800a65:	01 d0                	add    %edx,%eax
  800a67:	8b 10                	mov    (%eax),%edx
  800a69:	8b 45 b8             	mov    -0x48(%ebp),%eax
  800a6c:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800a73:	8b 85 6c ff ff ff    	mov    -0x94(%ebp),%eax
  800a79:	01 c8                	add    %ecx,%eax
  800a7b:	8b 00                	mov    (%eax),%eax
  800a7d:	83 ec 04             	sub    $0x4,%esp
  800a80:	52                   	push   %edx
  800a81:	50                   	push   %eax
  800a82:	68 1c 3d 80 00       	push   $0x803d1c
  800a87:	e8 ce 09 00 00       	call   80145a <cprintf>
  800a8c:	83 c4 10             	add    $0x10,%esp
	for(b=0; b< (*flight1BookedCounter);++b)
	{
		cprintf("cust %d booked flight 1, originally ordered %d\n", flight1BookedArr[b], custs[flight1BookedArr[b]].flightType);
	}

	for(b=0; b< (*flight2BookedCounter);++b)
  800a8f:	ff 45 b8             	incl   -0x48(%ebp)
  800a92:	8b 85 74 ff ff ff    	mov    -0x8c(%ebp),%eax
  800a98:	8b 00                	mov    (%eax),%eax
  800a9a:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  800a9d:	7f a8                	jg     800a47 <_main+0xa0f>
	{
		cprintf("cust %d booked flight 2, originally ordered %d\n", flight2BookedArr[b], custs[flight2BookedArr[b]].flightType);
	}
	}
	sys_unlock_cons();
  800a9f:	e8 e3 1c 00 00       	call   802787 <sys_unlock_cons>

	int numOfBookings = 0;
  800aa4:	c7 45 b4 00 00 00 00 	movl   $0x0,-0x4c(%ebp)
	int numOfFCusts[3] = {0};
  800aab:	8d 95 cc fc ff ff    	lea    -0x334(%ebp),%edx
  800ab1:	b9 03 00 00 00       	mov    $0x3,%ecx
  800ab6:	b8 00 00 00 00       	mov    $0x0,%eax
  800abb:	89 d7                	mov    %edx,%edi
  800abd:	f3 ab                	rep stos %eax,%es:(%edi)

	for(b=0; b< numOfCustomers;++b)
  800abf:	c7 45 b8 00 00 00 00 	movl   $0x0,-0x48(%ebp)
  800ac6:	eb 3d                	jmp    800b05 <_main+0xacd>
	{
		if (custs[b].booked)
  800ac8:	8b 45 b8             	mov    -0x48(%ebp),%eax
  800acb:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  800ad2:	8b 45 98             	mov    -0x68(%ebp),%eax
  800ad5:	01 d0                	add    %edx,%eax
  800ad7:	8b 40 04             	mov    0x4(%eax),%eax
  800ada:	85 c0                	test   %eax,%eax
  800adc:	74 24                	je     800b02 <_main+0xaca>
		{
			numOfBookings++;
  800ade:	ff 45 b4             	incl   -0x4c(%ebp)
			numOfFCusts[custs[b].flightType - 1]++ ;
  800ae1:	8b 45 b8             	mov    -0x48(%ebp),%eax
  800ae4:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  800aeb:	8b 45 98             	mov    -0x68(%ebp),%eax
  800aee:	01 d0                	add    %edx,%eax
  800af0:	8b 00                	mov    (%eax),%eax
  800af2:	48                   	dec    %eax
  800af3:	8b 94 85 cc fc ff ff 	mov    -0x334(%ebp,%eax,4),%edx
  800afa:	42                   	inc    %edx
  800afb:	89 94 85 cc fc ff ff 	mov    %edx,-0x334(%ebp,%eax,4)
	sys_unlock_cons();

	int numOfBookings = 0;
	int numOfFCusts[3] = {0};

	for(b=0; b< numOfCustomers;++b)
  800b02:	ff 45 b8             	incl   -0x48(%ebp)
  800b05:	8b 45 b8             	mov    -0x48(%ebp),%eax
  800b08:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  800b0b:	7c bb                	jl     800ac8 <_main+0xa90>
			numOfBookings++;
			numOfFCusts[custs[b].flightType - 1]++ ;
		}
	}

	sys_lock_cons();
  800b0d:	e8 5b 1c 00 00       	call   80276d <sys_lock_cons>
	{
	cprintf("%~[*] FINAL RESULTS:\n");
  800b12:	83 ec 0c             	sub    $0xc,%esp
  800b15:	68 4c 3d 80 00       	push   $0x803d4c
  800b1a:	e8 3b 09 00 00       	call   80145a <cprintf>
  800b1f:	83 c4 10             	add    $0x10,%esp
	cprintf("%~\tTotal number of customers = %d (Flight1# = %d, Flight2# = %d, Flight3# = %d)\n", numOfCustomers, flight1NumOfCustomers,flight2NumOfCustomers,flight3NumOfCustomers);
  800b22:	83 ec 0c             	sub    $0xc,%esp
  800b25:	ff 75 d4             	pushl  -0x2c(%ebp)
  800b28:	ff 75 d8             	pushl  -0x28(%ebp)
  800b2b:	ff 75 dc             	pushl  -0x24(%ebp)
  800b2e:	ff 75 e0             	pushl  -0x20(%ebp)
  800b31:	68 64 3d 80 00       	push   $0x803d64
  800b36:	e8 1f 09 00 00       	call   80145a <cprintf>
  800b3b:	83 c4 20             	add    $0x20,%esp
	cprintf("%~\tTotal number of customers who receive tickets = %d (Flight1# = %d, Flight2# = %d, Flight3# = %d)\n", numOfBookings, numOfFCusts[0],numOfFCusts[1],numOfFCusts[2]);
  800b3e:	8b 8d d4 fc ff ff    	mov    -0x32c(%ebp),%ecx
  800b44:	8b 95 d0 fc ff ff    	mov    -0x330(%ebp),%edx
  800b4a:	8b 85 cc fc ff ff    	mov    -0x334(%ebp),%eax
  800b50:	83 ec 0c             	sub    $0xc,%esp
  800b53:	51                   	push   %ecx
  800b54:	52                   	push   %edx
  800b55:	50                   	push   %eax
  800b56:	ff 75 b4             	pushl  -0x4c(%ebp)
  800b59:	68 b8 3d 80 00       	push   $0x803db8
  800b5e:	e8 f7 08 00 00       	call   80145a <cprintf>
  800b63:	83 c4 20             	add    $0x20,%esp
	}
	sys_unlock_cons();
  800b66:	e8 1c 1c 00 00       	call   802787 <sys_unlock_cons>
	//check out the final results and semaphores
	{
		for(int c = 0; c < numOfCustomers; ++c)
  800b6b:	c7 45 b0 00 00 00 00 	movl   $0x0,-0x50(%ebp)
  800b72:	e9 13 01 00 00       	jmp    800c8a <_main+0xc52>
		{
			if (custs[c].booked)
  800b77:	8b 45 b0             	mov    -0x50(%ebp),%eax
  800b7a:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  800b81:	8b 45 98             	mov    -0x68(%ebp),%eax
  800b84:	01 d0                	add    %edx,%eax
  800b86:	8b 40 04             	mov    0x4(%eax),%eax
  800b89:	85 c0                	test   %eax,%eax
  800b8b:	0f 84 f6 00 00 00    	je     800c87 <_main+0xc4f>
			{
				if(custs[c].flightType ==1 && find(flight1BookedArr, flight1NumOfTickets, c) != 1)
  800b91:	8b 45 b0             	mov    -0x50(%ebp),%eax
  800b94:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  800b9b:	8b 45 98             	mov    -0x68(%ebp),%eax
  800b9e:	01 d0                	add    %edx,%eax
  800ba0:	8b 00                	mov    (%eax),%eax
  800ba2:	83 f8 01             	cmp    $0x1,%eax
  800ba5:	75 33                	jne    800bda <_main+0xba2>
  800ba7:	83 ec 04             	sub    $0x4,%esp
  800baa:	ff 75 b0             	pushl  -0x50(%ebp)
  800bad:	ff 75 d0             	pushl  -0x30(%ebp)
  800bb0:	ff b5 70 ff ff ff    	pushl  -0x90(%ebp)
  800bb6:	e8 8b 03 00 00       	call   800f46 <find>
  800bbb:	83 c4 10             	add    $0x10,%esp
  800bbe:	83 f8 01             	cmp    $0x1,%eax
  800bc1:	74 17                	je     800bda <_main+0xba2>
				{
					panic("Error, wrong booking for user %d\n", c);
  800bc3:	ff 75 b0             	pushl  -0x50(%ebp)
  800bc6:	68 20 3e 80 00       	push   $0x803e20
  800bcb:	68 ed 00 00 00       	push   $0xed
  800bd0:	68 da 3c 80 00       	push   $0x803cda
  800bd5:	e8 b2 05 00 00       	call   80118c <_panic>
				}
				if(custs[c].flightType ==2 && find(flight2BookedArr, flight2NumOfTickets, c) != 1)
  800bda:	8b 45 b0             	mov    -0x50(%ebp),%eax
  800bdd:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  800be4:	8b 45 98             	mov    -0x68(%ebp),%eax
  800be7:	01 d0                	add    %edx,%eax
  800be9:	8b 00                	mov    (%eax),%eax
  800beb:	83 f8 02             	cmp    $0x2,%eax
  800bee:	75 33                	jne    800c23 <_main+0xbeb>
  800bf0:	83 ec 04             	sub    $0x4,%esp
  800bf3:	ff 75 b0             	pushl  -0x50(%ebp)
  800bf6:	ff 75 cc             	pushl  -0x34(%ebp)
  800bf9:	ff b5 6c ff ff ff    	pushl  -0x94(%ebp)
  800bff:	e8 42 03 00 00       	call   800f46 <find>
  800c04:	83 c4 10             	add    $0x10,%esp
  800c07:	83 f8 01             	cmp    $0x1,%eax
  800c0a:	74 17                	je     800c23 <_main+0xbeb>
				{
					panic("Error, wrong booking for user %d\n", c);
  800c0c:	ff 75 b0             	pushl  -0x50(%ebp)
  800c0f:	68 20 3e 80 00       	push   $0x803e20
  800c14:	68 f1 00 00 00       	push   $0xf1
  800c19:	68 da 3c 80 00       	push   $0x803cda
  800c1e:	e8 69 05 00 00       	call   80118c <_panic>
				}
				if(custs[c].flightType ==3 && ((find(flight1BookedArr, flight1NumOfTickets, c) + find(flight2BookedArr, flight2NumOfTickets, c)) != 2))
  800c23:	8b 45 b0             	mov    -0x50(%ebp),%eax
  800c26:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  800c2d:	8b 45 98             	mov    -0x68(%ebp),%eax
  800c30:	01 d0                	add    %edx,%eax
  800c32:	8b 00                	mov    (%eax),%eax
  800c34:	83 f8 03             	cmp    $0x3,%eax
  800c37:	75 4e                	jne    800c87 <_main+0xc4f>
  800c39:	83 ec 04             	sub    $0x4,%esp
  800c3c:	ff 75 b0             	pushl  -0x50(%ebp)
  800c3f:	ff 75 d0             	pushl  -0x30(%ebp)
  800c42:	ff b5 70 ff ff ff    	pushl  -0x90(%ebp)
  800c48:	e8 f9 02 00 00       	call   800f46 <find>
  800c4d:	83 c4 10             	add    $0x10,%esp
  800c50:	89 c3                	mov    %eax,%ebx
  800c52:	83 ec 04             	sub    $0x4,%esp
  800c55:	ff 75 b0             	pushl  -0x50(%ebp)
  800c58:	ff 75 cc             	pushl  -0x34(%ebp)
  800c5b:	ff b5 6c ff ff ff    	pushl  -0x94(%ebp)
  800c61:	e8 e0 02 00 00       	call   800f46 <find>
  800c66:	83 c4 10             	add    $0x10,%esp
  800c69:	01 d8                	add    %ebx,%eax
  800c6b:	83 f8 02             	cmp    $0x2,%eax
  800c6e:	74 17                	je     800c87 <_main+0xc4f>
				{
					panic("Error, wrong booking for user %d\n", c);
  800c70:	ff 75 b0             	pushl  -0x50(%ebp)
  800c73:	68 20 3e 80 00       	push   $0x803e20
  800c78:	68 f5 00 00 00       	push   $0xf5
  800c7d:	68 da 3c 80 00       	push   $0x803cda
  800c82:	e8 05 05 00 00       	call   80118c <_panic>
	cprintf("%~\tTotal number of customers who receive tickets = %d (Flight1# = %d, Flight2# = %d, Flight3# = %d)\n", numOfBookings, numOfFCusts[0],numOfFCusts[1],numOfFCusts[2]);
	}
	sys_unlock_cons();
	//check out the final results and semaphores
	{
		for(int c = 0; c < numOfCustomers; ++c)
  800c87:	ff 45 b0             	incl   -0x50(%ebp)
  800c8a:	8b 45 b0             	mov    -0x50(%ebp),%eax
  800c8d:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  800c90:	0f 8c e1 fe ff ff    	jl     800b77 <_main+0xb3f>
					panic("Error, wrong booking for user %d\n", c);
				}
			}
		}

		assert(semaphore_count(capacity) == agentCapacity);
  800c96:	83 ec 0c             	sub    $0xc,%esp
  800c99:	ff b5 f8 fc ff ff    	pushl  -0x308(%ebp)
  800c9f:	e8 13 2b 00 00       	call   8037b7 <semaphore_count>
  800ca4:	83 c4 10             	add    $0x10,%esp
  800ca7:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800caa:	74 19                	je     800cc5 <_main+0xc8d>
  800cac:	68 44 3e 80 00       	push   $0x803e44
  800cb1:	68 6f 3e 80 00       	push   $0x803e6f
  800cb6:	68 fa 00 00 00       	push   $0xfa
  800cbb:	68 da 3c 80 00       	push   $0x803cda
  800cc0:	e8 c7 04 00 00       	call   80118c <_panic>

		assert(semaphore_count(flight1CS) == 1);
  800cc5:	83 ec 0c             	sub    $0xc,%esp
  800cc8:	ff b5 f4 fc ff ff    	pushl  -0x30c(%ebp)
  800cce:	e8 e4 2a 00 00       	call   8037b7 <semaphore_count>
  800cd3:	83 c4 10             	add    $0x10,%esp
  800cd6:	83 f8 01             	cmp    $0x1,%eax
  800cd9:	74 19                	je     800cf4 <_main+0xcbc>
  800cdb:	68 84 3e 80 00       	push   $0x803e84
  800ce0:	68 6f 3e 80 00       	push   $0x803e6f
  800ce5:	68 fc 00 00 00       	push   $0xfc
  800cea:	68 da 3c 80 00       	push   $0x803cda
  800cef:	e8 98 04 00 00       	call   80118c <_panic>
		assert(semaphore_count(flight2CS) == 1);
  800cf4:	83 ec 0c             	sub    $0xc,%esp
  800cf7:	ff b5 f0 fc ff ff    	pushl  -0x310(%ebp)
  800cfd:	e8 b5 2a 00 00       	call   8037b7 <semaphore_count>
  800d02:	83 c4 10             	add    $0x10,%esp
  800d05:	83 f8 01             	cmp    $0x1,%eax
  800d08:	74 19                	je     800d23 <_main+0xceb>
  800d0a:	68 a4 3e 80 00       	push   $0x803ea4
  800d0f:	68 6f 3e 80 00       	push   $0x803e6f
  800d14:	68 fd 00 00 00       	push   $0xfd
  800d19:	68 da 3c 80 00       	push   $0x803cda
  800d1e:	e8 69 04 00 00       	call   80118c <_panic>

		assert(semaphore_count(custCounterCS) ==  1);
  800d23:	83 ec 0c             	sub    $0xc,%esp
  800d26:	ff b5 ec fc ff ff    	pushl  -0x314(%ebp)
  800d2c:	e8 86 2a 00 00       	call   8037b7 <semaphore_count>
  800d31:	83 c4 10             	add    $0x10,%esp
  800d34:	83 f8 01             	cmp    $0x1,%eax
  800d37:	74 19                	je     800d52 <_main+0xd1a>
  800d39:	68 c4 3e 80 00       	push   $0x803ec4
  800d3e:	68 6f 3e 80 00       	push   $0x803e6f
  800d43:	68 ff 00 00 00       	push   $0xff
  800d48:	68 da 3c 80 00       	push   $0x803cda
  800d4d:	e8 3a 04 00 00       	call   80118c <_panic>
		assert(semaphore_count(custQueueCS)  ==  1);
  800d52:	83 ec 0c             	sub    $0xc,%esp
  800d55:	ff b5 e8 fc ff ff    	pushl  -0x318(%ebp)
  800d5b:	e8 57 2a 00 00       	call   8037b7 <semaphore_count>
  800d60:	83 c4 10             	add    $0x10,%esp
  800d63:	83 f8 01             	cmp    $0x1,%eax
  800d66:	74 19                	je     800d81 <_main+0xd49>
  800d68:	68 e8 3e 80 00       	push   $0x803ee8
  800d6d:	68 6f 3e 80 00       	push   $0x803e6f
  800d72:	68 00 01 00 00       	push   $0x100
  800d77:	68 da 3c 80 00       	push   $0x803cda
  800d7c:	e8 0b 04 00 00       	call   80118c <_panic>

		assert(semaphore_count(clerk)  == 3);
  800d81:	83 ec 0c             	sub    $0xc,%esp
  800d84:	ff b5 e4 fc ff ff    	pushl  -0x31c(%ebp)
  800d8a:	e8 28 2a 00 00       	call   8037b7 <semaphore_count>
  800d8f:	83 c4 10             	add    $0x10,%esp
  800d92:	83 f8 03             	cmp    $0x3,%eax
  800d95:	74 19                	je     800db0 <_main+0xd78>
  800d97:	68 0a 3f 80 00       	push   $0x803f0a
  800d9c:	68 6f 3e 80 00       	push   $0x803e6f
  800da1:	68 02 01 00 00       	push   $0x102
  800da6:	68 da 3c 80 00       	push   $0x803cda
  800dab:	e8 dc 03 00 00       	call   80118c <_panic>

		assert(semaphore_count(cust_ready) == -3);
  800db0:	83 ec 0c             	sub    $0xc,%esp
  800db3:	ff b5 e0 fc ff ff    	pushl  -0x320(%ebp)
  800db9:	e8 f9 29 00 00       	call   8037b7 <semaphore_count>
  800dbe:	83 c4 10             	add    $0x10,%esp
  800dc1:	83 f8 fd             	cmp    $0xfffffffd,%eax
  800dc4:	74 19                	je     800ddf <_main+0xda7>
  800dc6:	68 28 3f 80 00       	push   $0x803f28
  800dcb:	68 6f 3e 80 00       	push   $0x803e6f
  800dd0:	68 04 01 00 00       	push   $0x104
  800dd5:	68 da 3c 80 00       	push   $0x803cda
  800dda:	e8 ad 03 00 00       	call   80118c <_panic>

		assert(semaphore_count(custTerminated) ==  0);
  800ddf:	83 ec 0c             	sub    $0xc,%esp
  800de2:	ff b5 dc fc ff ff    	pushl  -0x324(%ebp)
  800de8:	e8 ca 29 00 00       	call   8037b7 <semaphore_count>
  800ded:	83 c4 10             	add    $0x10,%esp
  800df0:	85 c0                	test   %eax,%eax
  800df2:	74 19                	je     800e0d <_main+0xdd5>
  800df4:	68 4c 3f 80 00       	push   $0x803f4c
  800df9:	68 6f 3e 80 00       	push   $0x803e6f
  800dfe:	68 06 01 00 00       	push   $0x106
  800e03:	68 da 3c 80 00       	push   $0x803cda
  800e08:	e8 7f 03 00 00       	call   80118c <_panic>

		int s=0;
  800e0d:	c7 45 ac 00 00 00 00 	movl   $0x0,-0x54(%ebp)
		for(s=0; s<numOfCustomers; ++s)
  800e14:	c7 45 ac 00 00 00 00 	movl   $0x0,-0x54(%ebp)
  800e1b:	eb 3f                	jmp    800e5c <_main+0xe24>
		{
			assert(semaphore_count(cust_finished[s]) ==  0);
  800e1d:	8b 45 ac             	mov    -0x54(%ebp),%eax
  800e20:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800e27:	8b 85 5c ff ff ff    	mov    -0xa4(%ebp),%eax
  800e2d:	01 d0                	add    %edx,%eax
  800e2f:	83 ec 0c             	sub    $0xc,%esp
  800e32:	ff 30                	pushl  (%eax)
  800e34:	e8 7e 29 00 00       	call   8037b7 <semaphore_count>
  800e39:	83 c4 10             	add    $0x10,%esp
  800e3c:	85 c0                	test   %eax,%eax
  800e3e:	74 19                	je     800e59 <_main+0xe21>
  800e40:	68 74 3f 80 00       	push   $0x803f74
  800e45:	68 6f 3e 80 00       	push   $0x803e6f
  800e4a:	68 0b 01 00 00       	push   $0x10b
  800e4f:	68 da 3c 80 00       	push   $0x803cda
  800e54:	e8 33 03 00 00       	call   80118c <_panic>
		assert(semaphore_count(cust_ready) == -3);

		assert(semaphore_count(custTerminated) ==  0);

		int s=0;
		for(s=0; s<numOfCustomers; ++s)
  800e59:	ff 45 ac             	incl   -0x54(%ebp)
  800e5c:	8b 45 ac             	mov    -0x54(%ebp),%eax
  800e5f:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  800e62:	7c b9                	jl     800e1d <_main+0xde5>
		{
			assert(semaphore_count(cust_finished[s]) ==  0);
		}

		atomic_cprintf("%~\nAll reservations are successfully done... have a nice flight :)\n");
  800e64:	83 ec 0c             	sub    $0xc,%esp
  800e67:	68 9c 3f 80 00       	push   $0x803f9c
  800e6c:	e8 5b 06 00 00       	call   8014cc <atomic_cprintf>
  800e71:	83 c4 10             	add    $0x10,%esp

		//waste some time then close the agency
		env_sleep(5000) ;
  800e74:	83 ec 0c             	sub    $0xc,%esp
  800e77:	68 88 13 00 00       	push   $0x1388
  800e7c:	e8 41 29 00 00       	call   8037c2 <env_sleep>
  800e81:	83 c4 10             	add    $0x10,%esp
		*isOpened = 0;
  800e84:	8b 45 88             	mov    -0x78(%ebp),%eax
  800e87:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
		atomic_cprintf("\n%~The agency is closing now...\n");
  800e8d:	83 ec 0c             	sub    $0xc,%esp
  800e90:	68 e0 3f 80 00       	push   $0x803fe0
  800e95:	e8 32 06 00 00       	call   8014cc <atomic_cprintf>
  800e9a:	83 c4 10             	add    $0x10,%esp

		//Signal all clerks to continue and recheck the isOpened flag
		cust_ready_queue[numOfCustomers] = -1; //to indicate, for the clerk, there's no more customers
  800e9d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800ea0:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800ea7:	8b 85 68 ff ff ff    	mov    -0x98(%ebp),%eax
  800ead:	01 d0                	add    %edx,%eax
  800eaf:	c7 00 ff ff ff ff    	movl   $0xffffffff,(%eax)
		for (int k = 0; k < numOfClerks; ++k)
  800eb5:	c7 45 a8 00 00 00 00 	movl   $0x0,-0x58(%ebp)
  800ebc:	eb 14                	jmp    800ed2 <_main+0xe9a>
		{
			signal_semaphore(cust_ready);
  800ebe:	83 ec 0c             	sub    $0xc,%esp
  800ec1:	ff b5 e0 fc ff ff    	pushl  -0x320(%ebp)
  800ec7:	e8 d1 28 00 00       	call   80379d <signal_semaphore>
  800ecc:	83 c4 10             	add    $0x10,%esp
		*isOpened = 0;
		atomic_cprintf("\n%~The agency is closing now...\n");

		//Signal all clerks to continue and recheck the isOpened flag
		cust_ready_queue[numOfCustomers] = -1; //to indicate, for the clerk, there's no more customers
		for (int k = 0; k < numOfClerks; ++k)
  800ecf:	ff 45 a8             	incl   -0x58(%ebp)
  800ed2:	8b 45 a8             	mov    -0x58(%ebp),%eax
  800ed5:	3b 45 9c             	cmp    -0x64(%ebp),%eax
  800ed8:	7c e4                	jl     800ebe <_main+0xe86>
		{
			signal_semaphore(cust_ready);
		}

		//Wait all clerks to finished
		for (int k = 0; k < numOfClerks; ++k)
  800eda:	c7 45 a4 00 00 00 00 	movl   $0x0,-0x5c(%ebp)
  800ee1:	eb 14                	jmp    800ef7 <_main+0xebf>
		{
			wait_semaphore(clerkTerminated);
  800ee3:	83 ec 0c             	sub    $0xc,%esp
  800ee6:	ff b5 d8 fc ff ff    	pushl  -0x328(%ebp)
  800eec:	e8 92 28 00 00       	call   803783 <wait_semaphore>
  800ef1:	83 c4 10             	add    $0x10,%esp
		{
			signal_semaphore(cust_ready);
		}

		//Wait all clerks to finished
		for (int k = 0; k < numOfClerks; ++k)
  800ef4:	ff 45 a4             	incl   -0x5c(%ebp)
  800ef7:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  800efa:	3b 45 9c             	cmp    -0x64(%ebp),%eax
  800efd:	7c e4                	jl     800ee3 <_main+0xeab>
		{
			wait_semaphore(clerkTerminated);
		}

		assert(semaphore_count(clerkTerminated) ==  0);
  800eff:	83 ec 0c             	sub    $0xc,%esp
  800f02:	ff b5 d8 fc ff ff    	pushl  -0x328(%ebp)
  800f08:	e8 aa 28 00 00       	call   8037b7 <semaphore_count>
  800f0d:	83 c4 10             	add    $0x10,%esp
  800f10:	85 c0                	test   %eax,%eax
  800f12:	74 19                	je     800f2d <_main+0xef5>
  800f14:	68 04 40 80 00       	push   $0x804004
  800f19:	68 6f 3e 80 00       	push   $0x803e6f
  800f1e:	68 22 01 00 00       	push   $0x122
  800f23:	68 da 3c 80 00       	push   $0x803cda
  800f28:	e8 5f 02 00 00       	call   80118c <_panic>

		atomic_cprintf("%~\nCongratulations... Airplane Reservation App is Finished Successfully\n\n");
  800f2d:	83 ec 0c             	sub    $0xc,%esp
  800f30:	68 2c 40 80 00       	push   $0x80402c
  800f35:	e8 92 05 00 00       	call   8014cc <atomic_cprintf>
  800f3a:	83 c4 10             	add    $0x10,%esp
	}

}
  800f3d:	90                   	nop
  800f3e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f41:	5b                   	pop    %ebx
  800f42:	5e                   	pop    %esi
  800f43:	5f                   	pop    %edi
  800f44:	5d                   	pop    %ebp
  800f45:	c3                   	ret    

00800f46 <find>:


int find(int* arr, int size, int val)
{
  800f46:	55                   	push   %ebp
  800f47:	89 e5                	mov    %esp,%ebp
  800f49:	83 ec 10             	sub    $0x10,%esp

	int result = 0;
  800f4c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)

	int i;
	for(i=0; i<size;++i )
  800f53:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  800f5a:	eb 22                	jmp    800f7e <find+0x38>
	{
		if(arr[i] == val)
  800f5c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f5f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800f66:	8b 45 08             	mov    0x8(%ebp),%eax
  800f69:	01 d0                	add    %edx,%eax
  800f6b:	8b 00                	mov    (%eax),%eax
  800f6d:	3b 45 10             	cmp    0x10(%ebp),%eax
  800f70:	75 09                	jne    800f7b <find+0x35>
		{
			result = 1;
  800f72:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
			break;
  800f79:	eb 0b                	jmp    800f86 <find+0x40>
{

	int result = 0;

	int i;
	for(i=0; i<size;++i )
  800f7b:	ff 45 f8             	incl   -0x8(%ebp)
  800f7e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f81:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800f84:	7c d6                	jl     800f5c <find+0x16>
			result = 1;
			break;
		}
	}

	return result;
  800f86:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800f89:	c9                   	leave  
  800f8a:	c3                   	ret    

00800f8b <cputchar>:
#include <inc/lib.h>


void
cputchar(int ch)
{
  800f8b:	55                   	push   %ebp
  800f8c:	89 e5                	mov    %esp,%ebp
  800f8e:	83 ec 18             	sub    $0x18,%esp
	char c = ch;
  800f91:	8b 45 08             	mov    0x8(%ebp),%eax
  800f94:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	//sys_cputs(&c, 1);

	sys_cputc(c);
  800f97:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  800f9b:	83 ec 0c             	sub    $0xc,%esp
  800f9e:	50                   	push   %eax
  800f9f:	e8 11 19 00 00       	call   8028b5 <sys_cputc>
  800fa4:	83 c4 10             	add    $0x10,%esp
}
  800fa7:	90                   	nop
  800fa8:	c9                   	leave  
  800fa9:	c3                   	ret    

00800faa <getchar>:


int
getchar(void)
{
  800faa:	55                   	push   %ebp
  800fab:	89 e5                	mov    %esp,%ebp
  800fad:	83 ec 18             	sub    $0x18,%esp
	int c =sys_cgetc();
  800fb0:	e8 9f 17 00 00       	call   802754 <sys_cgetc>
  800fb5:	89 45 f4             	mov    %eax,-0xc(%ebp)
	return c;
  800fb8:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800fbb:	c9                   	leave  
  800fbc:	c3                   	ret    

00800fbd <iscons>:

int iscons(int fdnum)
{
  800fbd:	55                   	push   %ebp
  800fbe:	89 e5                	mov    %esp,%ebp
	// used by readline
	return 1;
  800fc0:	b8 01 00 00 00       	mov    $0x1,%eax
}
  800fc5:	5d                   	pop    %ebp
  800fc6:	c3                   	ret    

00800fc7 <libmain>:
volatile bool printStats = 1;

volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";
void
libmain(int argc, char **argv)
{
  800fc7:	55                   	push   %ebp
  800fc8:	89 e5                	mov    %esp,%ebp
  800fca:	57                   	push   %edi
  800fcb:	56                   	push   %esi
  800fcc:	53                   	push   %ebx
  800fcd:	83 ec 7c             	sub    $0x7c,%esp
	//printStats = 1;
	int envIndex = sys_getenvindex();
  800fd0:	e8 11 1a 00 00       	call   8029e6 <sys_getenvindex>
  800fd5:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	myEnv = &(envs[envIndex]);
  800fd8:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800fdb:	89 d0                	mov    %edx,%eax
  800fdd:	c1 e0 06             	shl    $0x6,%eax
  800fe0:	29 d0                	sub    %edx,%eax
  800fe2:	c1 e0 02             	shl    $0x2,%eax
  800fe5:	01 d0                	add    %edx,%eax
  800fe7:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800fee:	01 c8                	add    %ecx,%eax
  800ff0:	c1 e0 03             	shl    $0x3,%eax
  800ff3:	01 d0                	add    %edx,%eax
  800ff5:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800ffc:	29 c2                	sub    %eax,%edx
  800ffe:	8d 04 95 00 00 00 00 	lea    0x0(,%edx,4),%eax
  801005:	89 c2                	mov    %eax,%edx
  801007:	8d 82 00 00 c0 ee    	lea    -0x11400000(%edx),%eax
  80100d:	a3 20 50 80 00       	mov    %eax,0x805020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  801012:	a1 20 50 80 00       	mov    0x805020,%eax
  801017:	8a 40 20             	mov    0x20(%eax),%al
  80101a:	84 c0                	test   %al,%al
  80101c:	74 0d                	je     80102b <libmain+0x64>
		binaryname = myEnv->prog_name;
  80101e:	a1 20 50 80 00       	mov    0x805020,%eax
  801023:	83 c0 20             	add    $0x20,%eax
  801026:	a3 04 50 80 00       	mov    %eax,0x805004

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80102b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80102f:	7e 0a                	jle    80103b <libmain+0x74>
		binaryname = argv[0];
  801031:	8b 45 0c             	mov    0xc(%ebp),%eax
  801034:	8b 00                	mov    (%eax),%eax
  801036:	a3 04 50 80 00       	mov    %eax,0x805004

	// call user main routine
	_main(argc, argv);
  80103b:	83 ec 08             	sub    $0x8,%esp
  80103e:	ff 75 0c             	pushl  0xc(%ebp)
  801041:	ff 75 08             	pushl  0x8(%ebp)
  801044:	e8 ef ef ff ff       	call   800038 <_main>
  801049:	83 c4 10             	add    $0x10,%esp

	if (printStats)
  80104c:	a1 00 50 80 00       	mov    0x805000,%eax
  801051:	85 c0                	test   %eax,%eax
  801053:	0f 84 01 01 00 00    	je     80115a <libmain+0x193>
	{
		char isOPTReplCmd[100] = "__IsOPTRepl__" ;
  801059:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  80105f:	bb e0 42 80 00       	mov    $0x8042e0,%ebx
  801064:	ba 0e 00 00 00       	mov    $0xe,%edx
  801069:	89 c7                	mov    %eax,%edi
  80106b:	89 de                	mov    %ebx,%esi
  80106d:	89 d1                	mov    %edx,%ecx
  80106f:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  801071:	8d 55 8a             	lea    -0x76(%ebp),%edx
  801074:	b9 56 00 00 00       	mov    $0x56,%ecx
  801079:	b0 00                	mov    $0x0,%al
  80107b:	89 d7                	mov    %edx,%edi
  80107d:	f3 aa                	rep stos %al,%es:(%edi)
		int isOPTRepl = 0;
  80107f:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
		sys_utilities(isOPTReplCmd, (uint32)(&isOPTRepl));
  801086:	8d 45 e0             	lea    -0x20(%ebp),%eax
  801089:	83 ec 08             	sub    $0x8,%esp
  80108c:	50                   	push   %eax
  80108d:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  801093:	50                   	push   %eax
  801094:	e8 83 1b 00 00       	call   802c1c <sys_utilities>
  801099:	83 c4 10             	add    $0x10,%esp

		sys_lock_cons();
  80109c:	e8 cc 16 00 00       	call   80276d <sys_lock_cons>
		{
			cprintf("**************************************\n");
  8010a1:	83 ec 0c             	sub    $0xc,%esp
  8010a4:	68 00 42 80 00       	push   $0x804200
  8010a9:	e8 ac 03 00 00       	call   80145a <cprintf>
  8010ae:	83 c4 10             	add    $0x10,%esp
			if (isOPTRepl)
  8010b1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8010b4:	85 c0                	test   %eax,%eax
  8010b6:	74 18                	je     8010d0 <libmain+0x109>
			{
				cprintf("OPTIMAL number of page faults = %d\n", sys_get_optimal_num_faults());
  8010b8:	e8 7d 1b 00 00       	call   802c3a <sys_get_optimal_num_faults>
  8010bd:	83 ec 08             	sub    $0x8,%esp
  8010c0:	50                   	push   %eax
  8010c1:	68 28 42 80 00       	push   $0x804228
  8010c6:	e8 8f 03 00 00       	call   80145a <cprintf>
  8010cb:	83 c4 10             	add    $0x10,%esp
  8010ce:	eb 59                	jmp    801129 <libmain+0x162>
			}
			else
			{
				cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8010d0:	a1 20 50 80 00       	mov    0x805020,%eax
  8010d5:	8b 90 50 da 01 00    	mov    0x1da50(%eax),%edx
  8010db:	a1 20 50 80 00       	mov    0x805020,%eax
  8010e0:	8b 80 40 da 01 00    	mov    0x1da40(%eax),%eax
  8010e6:	83 ec 04             	sub    $0x4,%esp
  8010e9:	52                   	push   %edx
  8010ea:	50                   	push   %eax
  8010eb:	68 4c 42 80 00       	push   $0x80424c
  8010f0:	e8 65 03 00 00       	call   80145a <cprintf>
  8010f5:	83 c4 10             	add    $0x10,%esp
				cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  8010f8:	a1 20 50 80 00       	mov    0x805020,%eax
  8010fd:	8b 88 64 da 01 00    	mov    0x1da64(%eax),%ecx
  801103:	a1 20 50 80 00       	mov    0x805020,%eax
  801108:	8b 90 60 da 01 00    	mov    0x1da60(%eax),%edx
  80110e:	a1 20 50 80 00       	mov    0x805020,%eax
  801113:	8b 80 5c da 01 00    	mov    0x1da5c(%eax),%eax
  801119:	51                   	push   %ecx
  80111a:	52                   	push   %edx
  80111b:	50                   	push   %eax
  80111c:	68 74 42 80 00       	push   $0x804274
  801121:	e8 34 03 00 00       	call   80145a <cprintf>
  801126:	83 c4 10             	add    $0x10,%esp
			}
			//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
			cprintf("Num of clocks = %d\n", myEnv->nClocks);
  801129:	a1 20 50 80 00       	mov    0x805020,%eax
  80112e:	8b 80 68 da 01 00    	mov    0x1da68(%eax),%eax
  801134:	83 ec 08             	sub    $0x8,%esp
  801137:	50                   	push   %eax
  801138:	68 cc 42 80 00       	push   $0x8042cc
  80113d:	e8 18 03 00 00       	call   80145a <cprintf>
  801142:	83 c4 10             	add    $0x10,%esp
			cprintf("**************************************\n");
  801145:	83 ec 0c             	sub    $0xc,%esp
  801148:	68 00 42 80 00       	push   $0x804200
  80114d:	e8 08 03 00 00       	call   80145a <cprintf>
  801152:	83 c4 10             	add    $0x10,%esp
		}
		sys_unlock_cons();
  801155:	e8 2d 16 00 00       	call   802787 <sys_unlock_cons>
	}

	// exit gracefully
	exit();
  80115a:	e8 1f 00 00 00       	call   80117e <exit>
}
  80115f:	90                   	nop
  801160:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801163:	5b                   	pop    %ebx
  801164:	5e                   	pop    %esi
  801165:	5f                   	pop    %edi
  801166:	5d                   	pop    %ebp
  801167:	c3                   	ret    

00801168 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  801168:	55                   	push   %ebp
  801169:	89 e5                	mov    %esp,%ebp
  80116b:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  80116e:	83 ec 0c             	sub    $0xc,%esp
  801171:	6a 00                	push   $0x0
  801173:	e8 3a 18 00 00       	call   8029b2 <sys_destroy_env>
  801178:	83 c4 10             	add    $0x10,%esp
}
  80117b:	90                   	nop
  80117c:	c9                   	leave  
  80117d:	c3                   	ret    

0080117e <exit>:

void
exit(void)
{
  80117e:	55                   	push   %ebp
  80117f:	89 e5                	mov    %esp,%ebp
  801181:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  801184:	e8 8f 18 00 00       	call   802a18 <sys_exit_env>
}
  801189:	90                   	nop
  80118a:	c9                   	leave  
  80118b:	c3                   	ret    

0080118c <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  80118c:	55                   	push   %ebp
  80118d:	89 e5                	mov    %esp,%ebp
  80118f:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  801192:	8d 45 10             	lea    0x10(%ebp),%eax
  801195:	83 c0 04             	add    $0x4,%eax
  801198:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  80119b:	a1 18 d1 81 00       	mov    0x81d118,%eax
  8011a0:	85 c0                	test   %eax,%eax
  8011a2:	74 16                	je     8011ba <_panic+0x2e>
		cprintf("%s: ", argv0);
  8011a4:	a1 18 d1 81 00       	mov    0x81d118,%eax
  8011a9:	83 ec 08             	sub    $0x8,%esp
  8011ac:	50                   	push   %eax
  8011ad:	68 44 43 80 00       	push   $0x804344
  8011b2:	e8 a3 02 00 00       	call   80145a <cprintf>
  8011b7:	83 c4 10             	add    $0x10,%esp
	cprintf_colored(TEXT_PANIC_CLR, "user [EVAL_FINAL]panic in %s at %s:%d: ", binaryname, file, line);
  8011ba:	a1 04 50 80 00       	mov    0x805004,%eax
  8011bf:	83 ec 0c             	sub    $0xc,%esp
  8011c2:	ff 75 0c             	pushl  0xc(%ebp)
  8011c5:	ff 75 08             	pushl  0x8(%ebp)
  8011c8:	50                   	push   %eax
  8011c9:	68 4c 43 80 00       	push   $0x80434c
  8011ce:	6a 74                	push   $0x74
  8011d0:	e8 b2 02 00 00       	call   801487 <cprintf_colored>
  8011d5:	83 c4 20             	add    $0x20,%esp
	vcprintf(fmt, ap);
  8011d8:	8b 45 10             	mov    0x10(%ebp),%eax
  8011db:	83 ec 08             	sub    $0x8,%esp
  8011de:	ff 75 f4             	pushl  -0xc(%ebp)
  8011e1:	50                   	push   %eax
  8011e2:	e8 04 02 00 00       	call   8013eb <vcprintf>
  8011e7:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  8011ea:	83 ec 08             	sub    $0x8,%esp
  8011ed:	6a 00                	push   $0x0
  8011ef:	68 74 43 80 00       	push   $0x804374
  8011f4:	e8 f2 01 00 00       	call   8013eb <vcprintf>
  8011f9:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  8011fc:	e8 7d ff ff ff       	call   80117e <exit>

	// should not return here
	while (1) ;
  801201:	eb fe                	jmp    801201 <_panic+0x75>

00801203 <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  801203:	55                   	push   %ebp
  801204:	89 e5                	mov    %esp,%ebp
  801206:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  801209:	a1 20 50 80 00       	mov    0x805020,%eax
  80120e:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  801214:	8b 45 0c             	mov    0xc(%ebp),%eax
  801217:	39 c2                	cmp    %eax,%edx
  801219:	74 14                	je     80122f <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  80121b:	83 ec 04             	sub    $0x4,%esp
  80121e:	68 78 43 80 00       	push   $0x804378
  801223:	6a 26                	push   $0x26
  801225:	68 c4 43 80 00       	push   $0x8043c4
  80122a:	e8 5d ff ff ff       	call   80118c <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  80122f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  801236:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80123d:	e9 c5 00 00 00       	jmp    801307 <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  801242:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801245:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80124c:	8b 45 08             	mov    0x8(%ebp),%eax
  80124f:	01 d0                	add    %edx,%eax
  801251:	8b 00                	mov    (%eax),%eax
  801253:	85 c0                	test   %eax,%eax
  801255:	75 08                	jne    80125f <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  801257:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  80125a:	e9 a5 00 00 00       	jmp    801304 <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  80125f:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  801266:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  80126d:	eb 69                	jmp    8012d8 <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  80126f:	a1 20 50 80 00       	mov    0x805020,%eax
  801274:	8b 88 38 da 01 00    	mov    0x1da38(%eax),%ecx
  80127a:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80127d:	89 d0                	mov    %edx,%eax
  80127f:	01 c0                	add    %eax,%eax
  801281:	01 d0                	add    %edx,%eax
  801283:	c1 e0 03             	shl    $0x3,%eax
  801286:	01 c8                	add    %ecx,%eax
  801288:	8a 40 04             	mov    0x4(%eax),%al
  80128b:	84 c0                	test   %al,%al
  80128d:	75 46                	jne    8012d5 <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  80128f:	a1 20 50 80 00       	mov    0x805020,%eax
  801294:	8b 88 38 da 01 00    	mov    0x1da38(%eax),%ecx
  80129a:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80129d:	89 d0                	mov    %edx,%eax
  80129f:	01 c0                	add    %eax,%eax
  8012a1:	01 d0                	add    %edx,%eax
  8012a3:	c1 e0 03             	shl    $0x3,%eax
  8012a6:	01 c8                	add    %ecx,%eax
  8012a8:	8b 00                	mov    (%eax),%eax
  8012aa:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8012ad:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8012b0:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8012b5:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  8012b7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8012ba:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8012c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8012c4:	01 c8                	add    %ecx,%eax
  8012c6:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8012c8:	39 c2                	cmp    %eax,%edx
  8012ca:	75 09                	jne    8012d5 <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  8012cc:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  8012d3:	eb 15                	jmp    8012ea <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8012d5:	ff 45 e8             	incl   -0x18(%ebp)
  8012d8:	a1 20 50 80 00       	mov    0x805020,%eax
  8012dd:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  8012e3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8012e6:	39 c2                	cmp    %eax,%edx
  8012e8:	77 85                	ja     80126f <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  8012ea:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8012ee:	75 14                	jne    801304 <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  8012f0:	83 ec 04             	sub    $0x4,%esp
  8012f3:	68 d0 43 80 00       	push   $0x8043d0
  8012f8:	6a 3a                	push   $0x3a
  8012fa:	68 c4 43 80 00       	push   $0x8043c4
  8012ff:	e8 88 fe ff ff       	call   80118c <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  801304:	ff 45 f0             	incl   -0x10(%ebp)
  801307:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80130a:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80130d:	0f 8c 2f ff ff ff    	jl     801242 <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  801313:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80131a:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  801321:	eb 26                	jmp    801349 <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  801323:	a1 20 50 80 00       	mov    0x805020,%eax
  801328:	8b 88 38 da 01 00    	mov    0x1da38(%eax),%ecx
  80132e:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801331:	89 d0                	mov    %edx,%eax
  801333:	01 c0                	add    %eax,%eax
  801335:	01 d0                	add    %edx,%eax
  801337:	c1 e0 03             	shl    $0x3,%eax
  80133a:	01 c8                	add    %ecx,%eax
  80133c:	8a 40 04             	mov    0x4(%eax),%al
  80133f:	3c 01                	cmp    $0x1,%al
  801341:	75 03                	jne    801346 <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  801343:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  801346:	ff 45 e0             	incl   -0x20(%ebp)
  801349:	a1 20 50 80 00       	mov    0x805020,%eax
  80134e:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  801354:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801357:	39 c2                	cmp    %eax,%edx
  801359:	77 c8                	ja     801323 <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  80135b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80135e:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  801361:	74 14                	je     801377 <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  801363:	83 ec 04             	sub    $0x4,%esp
  801366:	68 24 44 80 00       	push   $0x804424
  80136b:	6a 44                	push   $0x44
  80136d:	68 c4 43 80 00       	push   $0x8043c4
  801372:	e8 15 fe ff ff       	call   80118c <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  801377:	90                   	nop
  801378:	c9                   	leave  
  801379:	c3                   	ret    

0080137a <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  80137a:	55                   	push   %ebp
  80137b:	89 e5                	mov    %esp,%ebp
  80137d:	53                   	push   %ebx
  80137e:	83 ec 04             	sub    $0x4,%esp
	b->buf[b->idx++] = ch;
  801381:	8b 45 0c             	mov    0xc(%ebp),%eax
  801384:	8b 00                	mov    (%eax),%eax
  801386:	8d 48 01             	lea    0x1(%eax),%ecx
  801389:	8b 55 0c             	mov    0xc(%ebp),%edx
  80138c:	89 0a                	mov    %ecx,(%edx)
  80138e:	8b 55 08             	mov    0x8(%ebp),%edx
  801391:	88 d1                	mov    %dl,%cl
  801393:	8b 55 0c             	mov    0xc(%ebp),%edx
  801396:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  80139a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80139d:	8b 00                	mov    (%eax),%eax
  80139f:	3d ff 00 00 00       	cmp    $0xff,%eax
  8013a4:	75 30                	jne    8013d6 <putch+0x5c>
		sys_cputs(b->buf, b->idx, printProgName, curTextClr);
  8013a6:	8b 15 1c d1 81 00    	mov    0x81d11c,%edx
  8013ac:	a0 44 50 80 00       	mov    0x805044,%al
  8013b1:	0f b6 c0             	movzbl %al,%eax
  8013b4:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8013b7:	8b 09                	mov    (%ecx),%ecx
  8013b9:	89 cb                	mov    %ecx,%ebx
  8013bb:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8013be:	83 c1 08             	add    $0x8,%ecx
  8013c1:	52                   	push   %edx
  8013c2:	50                   	push   %eax
  8013c3:	53                   	push   %ebx
  8013c4:	51                   	push   %ecx
  8013c5:	e8 5f 13 00 00       	call   802729 <sys_cputs>
  8013ca:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8013cd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013d0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8013d6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013d9:	8b 40 04             	mov    0x4(%eax),%eax
  8013dc:	8d 50 01             	lea    0x1(%eax),%edx
  8013df:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013e2:	89 50 04             	mov    %edx,0x4(%eax)
}
  8013e5:	90                   	nop
  8013e6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8013e9:	c9                   	leave  
  8013ea:	c3                   	ret    

008013eb <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  8013eb:	55                   	push   %ebp
  8013ec:	89 e5                	mov    %esp,%ebp
  8013ee:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8013f4:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8013fb:	00 00 00 
	b.cnt = 0;
  8013fe:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  801405:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  801408:	ff 75 0c             	pushl  0xc(%ebp)
  80140b:	ff 75 08             	pushl  0x8(%ebp)
  80140e:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  801414:	50                   	push   %eax
  801415:	68 7a 13 80 00       	push   $0x80137a
  80141a:	e8 5a 02 00 00       	call   801679 <vprintfmt>
  80141f:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName, curTextClr);
  801422:	8b 15 1c d1 81 00    	mov    0x81d11c,%edx
  801428:	a0 44 50 80 00       	mov    0x805044,%al
  80142d:	0f b6 c0             	movzbl %al,%eax
  801430:	8b 8d f0 fe ff ff    	mov    -0x110(%ebp),%ecx
  801436:	52                   	push   %edx
  801437:	50                   	push   %eax
  801438:	51                   	push   %ecx
  801439:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80143f:	83 c0 08             	add    $0x8,%eax
  801442:	50                   	push   %eax
  801443:	e8 e1 12 00 00       	call   802729 <sys_cputs>
  801448:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  80144b:	c6 05 44 50 80 00 00 	movb   $0x0,0x805044
	return b.cnt;
  801452:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  801458:	c9                   	leave  
  801459:	c3                   	ret    

0080145a <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  80145a:	55                   	push   %ebp
  80145b:	89 e5                	mov    %esp,%ebp
  80145d:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  801460:	c6 05 44 50 80 00 01 	movb   $0x1,0x805044
	va_start(ap, fmt);
  801467:	8d 45 0c             	lea    0xc(%ebp),%eax
  80146a:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  80146d:	8b 45 08             	mov    0x8(%ebp),%eax
  801470:	83 ec 08             	sub    $0x8,%esp
  801473:	ff 75 f4             	pushl  -0xc(%ebp)
  801476:	50                   	push   %eax
  801477:	e8 6f ff ff ff       	call   8013eb <vcprintf>
  80147c:	83 c4 10             	add    $0x10,%esp
  80147f:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  801482:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801485:	c9                   	leave  
  801486:	c3                   	ret    

00801487 <cprintf_colored>:

// *************** This text coloring feature is implemented by *************
// ********** Abd-Alrahman Zedan From Team Frozen-Bytes - FCIS'24-25 ********
int cprintf_colored(int textClr, const char *fmt, ...) {
  801487:	55                   	push   %ebp
  801488:	89 e5                	mov    %esp,%ebp
  80148a:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  80148d:	c6 05 44 50 80 00 01 	movb   $0x1,0x805044
	curTextClr = (textClr << 8) ; //set text color by the given value
  801494:	8b 45 08             	mov    0x8(%ebp),%eax
  801497:	c1 e0 08             	shl    $0x8,%eax
  80149a:	a3 1c d1 81 00       	mov    %eax,0x81d11c
	va_start(ap, fmt);
  80149f:	8d 45 0c             	lea    0xc(%ebp),%eax
  8014a2:	83 c0 04             	add    $0x4,%eax
  8014a5:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8014a8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014ab:	83 ec 08             	sub    $0x8,%esp
  8014ae:	ff 75 f4             	pushl  -0xc(%ebp)
  8014b1:	50                   	push   %eax
  8014b2:	e8 34 ff ff ff       	call   8013eb <vcprintf>
  8014b7:	83 c4 10             	add    $0x10,%esp
  8014ba:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);
	curTextClr = TEXT_DEFAULT_CLR; //restore default color
  8014bd:	c7 05 1c d1 81 00 00 	movl   $0x700,0x81d11c
  8014c4:	07 00 00 

	return cnt;
  8014c7:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8014ca:	c9                   	leave  
  8014cb:	c3                   	ret    

008014cc <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  8014cc:	55                   	push   %ebp
  8014cd:	89 e5                	mov    %esp,%ebp
  8014cf:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  8014d2:	e8 96 12 00 00       	call   80276d <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  8014d7:	8d 45 0c             	lea    0xc(%ebp),%eax
  8014da:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  8014dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8014e0:	83 ec 08             	sub    $0x8,%esp
  8014e3:	ff 75 f4             	pushl  -0xc(%ebp)
  8014e6:	50                   	push   %eax
  8014e7:	e8 ff fe ff ff       	call   8013eb <vcprintf>
  8014ec:	83 c4 10             	add    $0x10,%esp
  8014ef:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  8014f2:	e8 90 12 00 00       	call   802787 <sys_unlock_cons>
	return cnt;
  8014f7:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8014fa:	c9                   	leave  
  8014fb:	c3                   	ret    

008014fc <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8014fc:	55                   	push   %ebp
  8014fd:	89 e5                	mov    %esp,%ebp
  8014ff:	53                   	push   %ebx
  801500:	83 ec 14             	sub    $0x14,%esp
  801503:	8b 45 10             	mov    0x10(%ebp),%eax
  801506:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801509:	8b 45 14             	mov    0x14(%ebp),%eax
  80150c:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  80150f:	8b 45 18             	mov    0x18(%ebp),%eax
  801512:	ba 00 00 00 00       	mov    $0x0,%edx
  801517:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  80151a:	77 55                	ja     801571 <printnum+0x75>
  80151c:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  80151f:	72 05                	jb     801526 <printnum+0x2a>
  801521:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801524:	77 4b                	ja     801571 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  801526:	8b 45 1c             	mov    0x1c(%ebp),%eax
  801529:	8d 58 ff             	lea    -0x1(%eax),%ebx
  80152c:	8b 45 18             	mov    0x18(%ebp),%eax
  80152f:	ba 00 00 00 00       	mov    $0x0,%edx
  801534:	52                   	push   %edx
  801535:	50                   	push   %eax
  801536:	ff 75 f4             	pushl  -0xc(%ebp)
  801539:	ff 75 f0             	pushl  -0x10(%ebp)
  80153c:	e8 3f 23 00 00       	call   803880 <__udivdi3>
  801541:	83 c4 10             	add    $0x10,%esp
  801544:	83 ec 04             	sub    $0x4,%esp
  801547:	ff 75 20             	pushl  0x20(%ebp)
  80154a:	53                   	push   %ebx
  80154b:	ff 75 18             	pushl  0x18(%ebp)
  80154e:	52                   	push   %edx
  80154f:	50                   	push   %eax
  801550:	ff 75 0c             	pushl  0xc(%ebp)
  801553:	ff 75 08             	pushl  0x8(%ebp)
  801556:	e8 a1 ff ff ff       	call   8014fc <printnum>
  80155b:	83 c4 20             	add    $0x20,%esp
  80155e:	eb 1a                	jmp    80157a <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  801560:	83 ec 08             	sub    $0x8,%esp
  801563:	ff 75 0c             	pushl  0xc(%ebp)
  801566:	ff 75 20             	pushl  0x20(%ebp)
  801569:	8b 45 08             	mov    0x8(%ebp),%eax
  80156c:	ff d0                	call   *%eax
  80156e:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  801571:	ff 4d 1c             	decl   0x1c(%ebp)
  801574:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  801578:	7f e6                	jg     801560 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80157a:	8b 4d 18             	mov    0x18(%ebp),%ecx
  80157d:	bb 00 00 00 00       	mov    $0x0,%ebx
  801582:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801585:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801588:	53                   	push   %ebx
  801589:	51                   	push   %ecx
  80158a:	52                   	push   %edx
  80158b:	50                   	push   %eax
  80158c:	e8 ff 23 00 00       	call   803990 <__umoddi3>
  801591:	83 c4 10             	add    $0x10,%esp
  801594:	05 94 46 80 00       	add    $0x804694,%eax
  801599:	8a 00                	mov    (%eax),%al
  80159b:	0f be c0             	movsbl %al,%eax
  80159e:	83 ec 08             	sub    $0x8,%esp
  8015a1:	ff 75 0c             	pushl  0xc(%ebp)
  8015a4:	50                   	push   %eax
  8015a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8015a8:	ff d0                	call   *%eax
  8015aa:	83 c4 10             	add    $0x10,%esp
}
  8015ad:	90                   	nop
  8015ae:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8015b1:	c9                   	leave  
  8015b2:	c3                   	ret    

008015b3 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8015b3:	55                   	push   %ebp
  8015b4:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8015b6:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8015ba:	7e 1c                	jle    8015d8 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  8015bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8015bf:	8b 00                	mov    (%eax),%eax
  8015c1:	8d 50 08             	lea    0x8(%eax),%edx
  8015c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8015c7:	89 10                	mov    %edx,(%eax)
  8015c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8015cc:	8b 00                	mov    (%eax),%eax
  8015ce:	83 e8 08             	sub    $0x8,%eax
  8015d1:	8b 50 04             	mov    0x4(%eax),%edx
  8015d4:	8b 00                	mov    (%eax),%eax
  8015d6:	eb 40                	jmp    801618 <getuint+0x65>
	else if (lflag)
  8015d8:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8015dc:	74 1e                	je     8015fc <getuint+0x49>
		return va_arg(*ap, unsigned long);
  8015de:	8b 45 08             	mov    0x8(%ebp),%eax
  8015e1:	8b 00                	mov    (%eax),%eax
  8015e3:	8d 50 04             	lea    0x4(%eax),%edx
  8015e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8015e9:	89 10                	mov    %edx,(%eax)
  8015eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8015ee:	8b 00                	mov    (%eax),%eax
  8015f0:	83 e8 04             	sub    $0x4,%eax
  8015f3:	8b 00                	mov    (%eax),%eax
  8015f5:	ba 00 00 00 00       	mov    $0x0,%edx
  8015fa:	eb 1c                	jmp    801618 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  8015fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8015ff:	8b 00                	mov    (%eax),%eax
  801601:	8d 50 04             	lea    0x4(%eax),%edx
  801604:	8b 45 08             	mov    0x8(%ebp),%eax
  801607:	89 10                	mov    %edx,(%eax)
  801609:	8b 45 08             	mov    0x8(%ebp),%eax
  80160c:	8b 00                	mov    (%eax),%eax
  80160e:	83 e8 04             	sub    $0x4,%eax
  801611:	8b 00                	mov    (%eax),%eax
  801613:	ba 00 00 00 00       	mov    $0x0,%edx
}
  801618:	5d                   	pop    %ebp
  801619:	c3                   	ret    

0080161a <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  80161a:	55                   	push   %ebp
  80161b:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  80161d:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  801621:	7e 1c                	jle    80163f <getint+0x25>
		return va_arg(*ap, long long);
  801623:	8b 45 08             	mov    0x8(%ebp),%eax
  801626:	8b 00                	mov    (%eax),%eax
  801628:	8d 50 08             	lea    0x8(%eax),%edx
  80162b:	8b 45 08             	mov    0x8(%ebp),%eax
  80162e:	89 10                	mov    %edx,(%eax)
  801630:	8b 45 08             	mov    0x8(%ebp),%eax
  801633:	8b 00                	mov    (%eax),%eax
  801635:	83 e8 08             	sub    $0x8,%eax
  801638:	8b 50 04             	mov    0x4(%eax),%edx
  80163b:	8b 00                	mov    (%eax),%eax
  80163d:	eb 38                	jmp    801677 <getint+0x5d>
	else if (lflag)
  80163f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801643:	74 1a                	je     80165f <getint+0x45>
		return va_arg(*ap, long);
  801645:	8b 45 08             	mov    0x8(%ebp),%eax
  801648:	8b 00                	mov    (%eax),%eax
  80164a:	8d 50 04             	lea    0x4(%eax),%edx
  80164d:	8b 45 08             	mov    0x8(%ebp),%eax
  801650:	89 10                	mov    %edx,(%eax)
  801652:	8b 45 08             	mov    0x8(%ebp),%eax
  801655:	8b 00                	mov    (%eax),%eax
  801657:	83 e8 04             	sub    $0x4,%eax
  80165a:	8b 00                	mov    (%eax),%eax
  80165c:	99                   	cltd   
  80165d:	eb 18                	jmp    801677 <getint+0x5d>
	else
		return va_arg(*ap, int);
  80165f:	8b 45 08             	mov    0x8(%ebp),%eax
  801662:	8b 00                	mov    (%eax),%eax
  801664:	8d 50 04             	lea    0x4(%eax),%edx
  801667:	8b 45 08             	mov    0x8(%ebp),%eax
  80166a:	89 10                	mov    %edx,(%eax)
  80166c:	8b 45 08             	mov    0x8(%ebp),%eax
  80166f:	8b 00                	mov    (%eax),%eax
  801671:	83 e8 04             	sub    $0x4,%eax
  801674:	8b 00                	mov    (%eax),%eax
  801676:	99                   	cltd   
}
  801677:	5d                   	pop    %ebp
  801678:	c3                   	ret    

00801679 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  801679:	55                   	push   %ebp
  80167a:	89 e5                	mov    %esp,%ebp
  80167c:	56                   	push   %esi
  80167d:	53                   	push   %ebx
  80167e:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  801681:	eb 17                	jmp    80169a <vprintfmt+0x21>
			if (ch == '\0')
  801683:	85 db                	test   %ebx,%ebx
  801685:	0f 84 c1 03 00 00    	je     801a4c <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  80168b:	83 ec 08             	sub    $0x8,%esp
  80168e:	ff 75 0c             	pushl  0xc(%ebp)
  801691:	53                   	push   %ebx
  801692:	8b 45 08             	mov    0x8(%ebp),%eax
  801695:	ff d0                	call   *%eax
  801697:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80169a:	8b 45 10             	mov    0x10(%ebp),%eax
  80169d:	8d 50 01             	lea    0x1(%eax),%edx
  8016a0:	89 55 10             	mov    %edx,0x10(%ebp)
  8016a3:	8a 00                	mov    (%eax),%al
  8016a5:	0f b6 d8             	movzbl %al,%ebx
  8016a8:	83 fb 25             	cmp    $0x25,%ebx
  8016ab:	75 d6                	jne    801683 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  8016ad:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  8016b1:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  8016b8:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8016bf:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  8016c6:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8016cd:	8b 45 10             	mov    0x10(%ebp),%eax
  8016d0:	8d 50 01             	lea    0x1(%eax),%edx
  8016d3:	89 55 10             	mov    %edx,0x10(%ebp)
  8016d6:	8a 00                	mov    (%eax),%al
  8016d8:	0f b6 d8             	movzbl %al,%ebx
  8016db:	8d 43 dd             	lea    -0x23(%ebx),%eax
  8016de:	83 f8 5b             	cmp    $0x5b,%eax
  8016e1:	0f 87 3d 03 00 00    	ja     801a24 <vprintfmt+0x3ab>
  8016e7:	8b 04 85 b8 46 80 00 	mov    0x8046b8(,%eax,4),%eax
  8016ee:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  8016f0:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  8016f4:	eb d7                	jmp    8016cd <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8016f6:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  8016fa:	eb d1                	jmp    8016cd <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8016fc:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  801703:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801706:	89 d0                	mov    %edx,%eax
  801708:	c1 e0 02             	shl    $0x2,%eax
  80170b:	01 d0                	add    %edx,%eax
  80170d:	01 c0                	add    %eax,%eax
  80170f:	01 d8                	add    %ebx,%eax
  801711:	83 e8 30             	sub    $0x30,%eax
  801714:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  801717:	8b 45 10             	mov    0x10(%ebp),%eax
  80171a:	8a 00                	mov    (%eax),%al
  80171c:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  80171f:	83 fb 2f             	cmp    $0x2f,%ebx
  801722:	7e 3e                	jle    801762 <vprintfmt+0xe9>
  801724:	83 fb 39             	cmp    $0x39,%ebx
  801727:	7f 39                	jg     801762 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  801729:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  80172c:	eb d5                	jmp    801703 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  80172e:	8b 45 14             	mov    0x14(%ebp),%eax
  801731:	83 c0 04             	add    $0x4,%eax
  801734:	89 45 14             	mov    %eax,0x14(%ebp)
  801737:	8b 45 14             	mov    0x14(%ebp),%eax
  80173a:	83 e8 04             	sub    $0x4,%eax
  80173d:	8b 00                	mov    (%eax),%eax
  80173f:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  801742:	eb 1f                	jmp    801763 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  801744:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801748:	79 83                	jns    8016cd <vprintfmt+0x54>
				width = 0;
  80174a:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  801751:	e9 77 ff ff ff       	jmp    8016cd <vprintfmt+0x54>

		case '#':
			altflag = 1;
  801756:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  80175d:	e9 6b ff ff ff       	jmp    8016cd <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  801762:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  801763:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801767:	0f 89 60 ff ff ff    	jns    8016cd <vprintfmt+0x54>
				width = precision, precision = -1;
  80176d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801770:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801773:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  80177a:	e9 4e ff ff ff       	jmp    8016cd <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  80177f:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  801782:	e9 46 ff ff ff       	jmp    8016cd <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  801787:	8b 45 14             	mov    0x14(%ebp),%eax
  80178a:	83 c0 04             	add    $0x4,%eax
  80178d:	89 45 14             	mov    %eax,0x14(%ebp)
  801790:	8b 45 14             	mov    0x14(%ebp),%eax
  801793:	83 e8 04             	sub    $0x4,%eax
  801796:	8b 00                	mov    (%eax),%eax
  801798:	83 ec 08             	sub    $0x8,%esp
  80179b:	ff 75 0c             	pushl  0xc(%ebp)
  80179e:	50                   	push   %eax
  80179f:	8b 45 08             	mov    0x8(%ebp),%eax
  8017a2:	ff d0                	call   *%eax
  8017a4:	83 c4 10             	add    $0x10,%esp
			break;
  8017a7:	e9 9b 02 00 00       	jmp    801a47 <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  8017ac:	8b 45 14             	mov    0x14(%ebp),%eax
  8017af:	83 c0 04             	add    $0x4,%eax
  8017b2:	89 45 14             	mov    %eax,0x14(%ebp)
  8017b5:	8b 45 14             	mov    0x14(%ebp),%eax
  8017b8:	83 e8 04             	sub    $0x4,%eax
  8017bb:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  8017bd:	85 db                	test   %ebx,%ebx
  8017bf:	79 02                	jns    8017c3 <vprintfmt+0x14a>
				err = -err;
  8017c1:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  8017c3:	83 fb 64             	cmp    $0x64,%ebx
  8017c6:	7f 0b                	jg     8017d3 <vprintfmt+0x15a>
  8017c8:	8b 34 9d 00 45 80 00 	mov    0x804500(,%ebx,4),%esi
  8017cf:	85 f6                	test   %esi,%esi
  8017d1:	75 19                	jne    8017ec <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  8017d3:	53                   	push   %ebx
  8017d4:	68 a5 46 80 00       	push   $0x8046a5
  8017d9:	ff 75 0c             	pushl  0xc(%ebp)
  8017dc:	ff 75 08             	pushl  0x8(%ebp)
  8017df:	e8 70 02 00 00       	call   801a54 <printfmt>
  8017e4:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  8017e7:	e9 5b 02 00 00       	jmp    801a47 <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  8017ec:	56                   	push   %esi
  8017ed:	68 ae 46 80 00       	push   $0x8046ae
  8017f2:	ff 75 0c             	pushl  0xc(%ebp)
  8017f5:	ff 75 08             	pushl  0x8(%ebp)
  8017f8:	e8 57 02 00 00       	call   801a54 <printfmt>
  8017fd:	83 c4 10             	add    $0x10,%esp
			break;
  801800:	e9 42 02 00 00       	jmp    801a47 <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  801805:	8b 45 14             	mov    0x14(%ebp),%eax
  801808:	83 c0 04             	add    $0x4,%eax
  80180b:	89 45 14             	mov    %eax,0x14(%ebp)
  80180e:	8b 45 14             	mov    0x14(%ebp),%eax
  801811:	83 e8 04             	sub    $0x4,%eax
  801814:	8b 30                	mov    (%eax),%esi
  801816:	85 f6                	test   %esi,%esi
  801818:	75 05                	jne    80181f <vprintfmt+0x1a6>
				p = "(null)";
  80181a:	be b1 46 80 00       	mov    $0x8046b1,%esi
			if (width > 0 && padc != '-')
  80181f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801823:	7e 6d                	jle    801892 <vprintfmt+0x219>
  801825:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  801829:	74 67                	je     801892 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  80182b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80182e:	83 ec 08             	sub    $0x8,%esp
  801831:	50                   	push   %eax
  801832:	56                   	push   %esi
  801833:	e8 26 05 00 00       	call   801d5e <strnlen>
  801838:	83 c4 10             	add    $0x10,%esp
  80183b:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  80183e:	eb 16                	jmp    801856 <vprintfmt+0x1dd>
					putch(padc, putdat);
  801840:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  801844:	83 ec 08             	sub    $0x8,%esp
  801847:	ff 75 0c             	pushl  0xc(%ebp)
  80184a:	50                   	push   %eax
  80184b:	8b 45 08             	mov    0x8(%ebp),%eax
  80184e:	ff d0                	call   *%eax
  801850:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  801853:	ff 4d e4             	decl   -0x1c(%ebp)
  801856:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80185a:	7f e4                	jg     801840 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80185c:	eb 34                	jmp    801892 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  80185e:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  801862:	74 1c                	je     801880 <vprintfmt+0x207>
  801864:	83 fb 1f             	cmp    $0x1f,%ebx
  801867:	7e 05                	jle    80186e <vprintfmt+0x1f5>
  801869:	83 fb 7e             	cmp    $0x7e,%ebx
  80186c:	7e 12                	jle    801880 <vprintfmt+0x207>
					putch('?', putdat);
  80186e:	83 ec 08             	sub    $0x8,%esp
  801871:	ff 75 0c             	pushl  0xc(%ebp)
  801874:	6a 3f                	push   $0x3f
  801876:	8b 45 08             	mov    0x8(%ebp),%eax
  801879:	ff d0                	call   *%eax
  80187b:	83 c4 10             	add    $0x10,%esp
  80187e:	eb 0f                	jmp    80188f <vprintfmt+0x216>
				else
					putch(ch, putdat);
  801880:	83 ec 08             	sub    $0x8,%esp
  801883:	ff 75 0c             	pushl  0xc(%ebp)
  801886:	53                   	push   %ebx
  801887:	8b 45 08             	mov    0x8(%ebp),%eax
  80188a:	ff d0                	call   *%eax
  80188c:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80188f:	ff 4d e4             	decl   -0x1c(%ebp)
  801892:	89 f0                	mov    %esi,%eax
  801894:	8d 70 01             	lea    0x1(%eax),%esi
  801897:	8a 00                	mov    (%eax),%al
  801899:	0f be d8             	movsbl %al,%ebx
  80189c:	85 db                	test   %ebx,%ebx
  80189e:	74 24                	je     8018c4 <vprintfmt+0x24b>
  8018a0:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8018a4:	78 b8                	js     80185e <vprintfmt+0x1e5>
  8018a6:	ff 4d e0             	decl   -0x20(%ebp)
  8018a9:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8018ad:	79 af                	jns    80185e <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8018af:	eb 13                	jmp    8018c4 <vprintfmt+0x24b>
				putch(' ', putdat);
  8018b1:	83 ec 08             	sub    $0x8,%esp
  8018b4:	ff 75 0c             	pushl  0xc(%ebp)
  8018b7:	6a 20                	push   $0x20
  8018b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8018bc:	ff d0                	call   *%eax
  8018be:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8018c1:	ff 4d e4             	decl   -0x1c(%ebp)
  8018c4:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8018c8:	7f e7                	jg     8018b1 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  8018ca:	e9 78 01 00 00       	jmp    801a47 <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  8018cf:	83 ec 08             	sub    $0x8,%esp
  8018d2:	ff 75 e8             	pushl  -0x18(%ebp)
  8018d5:	8d 45 14             	lea    0x14(%ebp),%eax
  8018d8:	50                   	push   %eax
  8018d9:	e8 3c fd ff ff       	call   80161a <getint>
  8018de:	83 c4 10             	add    $0x10,%esp
  8018e1:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8018e4:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  8018e7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8018ea:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8018ed:	85 d2                	test   %edx,%edx
  8018ef:	79 23                	jns    801914 <vprintfmt+0x29b>
				putch('-', putdat);
  8018f1:	83 ec 08             	sub    $0x8,%esp
  8018f4:	ff 75 0c             	pushl  0xc(%ebp)
  8018f7:	6a 2d                	push   $0x2d
  8018f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8018fc:	ff d0                	call   *%eax
  8018fe:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  801901:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801904:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801907:	f7 d8                	neg    %eax
  801909:	83 d2 00             	adc    $0x0,%edx
  80190c:	f7 da                	neg    %edx
  80190e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801911:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  801914:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  80191b:	e9 bc 00 00 00       	jmp    8019dc <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  801920:	83 ec 08             	sub    $0x8,%esp
  801923:	ff 75 e8             	pushl  -0x18(%ebp)
  801926:	8d 45 14             	lea    0x14(%ebp),%eax
  801929:	50                   	push   %eax
  80192a:	e8 84 fc ff ff       	call   8015b3 <getuint>
  80192f:	83 c4 10             	add    $0x10,%esp
  801932:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801935:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  801938:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  80193f:	e9 98 00 00 00       	jmp    8019dc <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  801944:	83 ec 08             	sub    $0x8,%esp
  801947:	ff 75 0c             	pushl  0xc(%ebp)
  80194a:	6a 58                	push   $0x58
  80194c:	8b 45 08             	mov    0x8(%ebp),%eax
  80194f:	ff d0                	call   *%eax
  801951:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  801954:	83 ec 08             	sub    $0x8,%esp
  801957:	ff 75 0c             	pushl  0xc(%ebp)
  80195a:	6a 58                	push   $0x58
  80195c:	8b 45 08             	mov    0x8(%ebp),%eax
  80195f:	ff d0                	call   *%eax
  801961:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  801964:	83 ec 08             	sub    $0x8,%esp
  801967:	ff 75 0c             	pushl  0xc(%ebp)
  80196a:	6a 58                	push   $0x58
  80196c:	8b 45 08             	mov    0x8(%ebp),%eax
  80196f:	ff d0                	call   *%eax
  801971:	83 c4 10             	add    $0x10,%esp
			break;
  801974:	e9 ce 00 00 00       	jmp    801a47 <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  801979:	83 ec 08             	sub    $0x8,%esp
  80197c:	ff 75 0c             	pushl  0xc(%ebp)
  80197f:	6a 30                	push   $0x30
  801981:	8b 45 08             	mov    0x8(%ebp),%eax
  801984:	ff d0                	call   *%eax
  801986:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  801989:	83 ec 08             	sub    $0x8,%esp
  80198c:	ff 75 0c             	pushl  0xc(%ebp)
  80198f:	6a 78                	push   $0x78
  801991:	8b 45 08             	mov    0x8(%ebp),%eax
  801994:	ff d0                	call   *%eax
  801996:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  801999:	8b 45 14             	mov    0x14(%ebp),%eax
  80199c:	83 c0 04             	add    $0x4,%eax
  80199f:	89 45 14             	mov    %eax,0x14(%ebp)
  8019a2:	8b 45 14             	mov    0x14(%ebp),%eax
  8019a5:	83 e8 04             	sub    $0x4,%eax
  8019a8:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  8019aa:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8019ad:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  8019b4:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  8019bb:	eb 1f                	jmp    8019dc <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  8019bd:	83 ec 08             	sub    $0x8,%esp
  8019c0:	ff 75 e8             	pushl  -0x18(%ebp)
  8019c3:	8d 45 14             	lea    0x14(%ebp),%eax
  8019c6:	50                   	push   %eax
  8019c7:	e8 e7 fb ff ff       	call   8015b3 <getuint>
  8019cc:	83 c4 10             	add    $0x10,%esp
  8019cf:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8019d2:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  8019d5:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  8019dc:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  8019e0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8019e3:	83 ec 04             	sub    $0x4,%esp
  8019e6:	52                   	push   %edx
  8019e7:	ff 75 e4             	pushl  -0x1c(%ebp)
  8019ea:	50                   	push   %eax
  8019eb:	ff 75 f4             	pushl  -0xc(%ebp)
  8019ee:	ff 75 f0             	pushl  -0x10(%ebp)
  8019f1:	ff 75 0c             	pushl  0xc(%ebp)
  8019f4:	ff 75 08             	pushl  0x8(%ebp)
  8019f7:	e8 00 fb ff ff       	call   8014fc <printnum>
  8019fc:	83 c4 20             	add    $0x20,%esp
			break;
  8019ff:	eb 46                	jmp    801a47 <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  801a01:	83 ec 08             	sub    $0x8,%esp
  801a04:	ff 75 0c             	pushl  0xc(%ebp)
  801a07:	53                   	push   %ebx
  801a08:	8b 45 08             	mov    0x8(%ebp),%eax
  801a0b:	ff d0                	call   *%eax
  801a0d:	83 c4 10             	add    $0x10,%esp
			break;
  801a10:	eb 35                	jmp    801a47 <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  801a12:	c6 05 44 50 80 00 00 	movb   $0x0,0x805044
			break;
  801a19:	eb 2c                	jmp    801a47 <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  801a1b:	c6 05 44 50 80 00 01 	movb   $0x1,0x805044
			break;
  801a22:	eb 23                	jmp    801a47 <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  801a24:	83 ec 08             	sub    $0x8,%esp
  801a27:	ff 75 0c             	pushl  0xc(%ebp)
  801a2a:	6a 25                	push   $0x25
  801a2c:	8b 45 08             	mov    0x8(%ebp),%eax
  801a2f:	ff d0                	call   *%eax
  801a31:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  801a34:	ff 4d 10             	decl   0x10(%ebp)
  801a37:	eb 03                	jmp    801a3c <vprintfmt+0x3c3>
  801a39:	ff 4d 10             	decl   0x10(%ebp)
  801a3c:	8b 45 10             	mov    0x10(%ebp),%eax
  801a3f:	48                   	dec    %eax
  801a40:	8a 00                	mov    (%eax),%al
  801a42:	3c 25                	cmp    $0x25,%al
  801a44:	75 f3                	jne    801a39 <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  801a46:	90                   	nop
		}
	}
  801a47:	e9 35 fc ff ff       	jmp    801681 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  801a4c:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  801a4d:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801a50:	5b                   	pop    %ebx
  801a51:	5e                   	pop    %esi
  801a52:	5d                   	pop    %ebp
  801a53:	c3                   	ret    

00801a54 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  801a54:	55                   	push   %ebp
  801a55:	89 e5                	mov    %esp,%ebp
  801a57:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  801a5a:	8d 45 10             	lea    0x10(%ebp),%eax
  801a5d:	83 c0 04             	add    $0x4,%eax
  801a60:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  801a63:	8b 45 10             	mov    0x10(%ebp),%eax
  801a66:	ff 75 f4             	pushl  -0xc(%ebp)
  801a69:	50                   	push   %eax
  801a6a:	ff 75 0c             	pushl  0xc(%ebp)
  801a6d:	ff 75 08             	pushl  0x8(%ebp)
  801a70:	e8 04 fc ff ff       	call   801679 <vprintfmt>
  801a75:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  801a78:	90                   	nop
  801a79:	c9                   	leave  
  801a7a:	c3                   	ret    

00801a7b <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  801a7b:	55                   	push   %ebp
  801a7c:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  801a7e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a81:	8b 40 08             	mov    0x8(%eax),%eax
  801a84:	8d 50 01             	lea    0x1(%eax),%edx
  801a87:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a8a:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  801a8d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a90:	8b 10                	mov    (%eax),%edx
  801a92:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a95:	8b 40 04             	mov    0x4(%eax),%eax
  801a98:	39 c2                	cmp    %eax,%edx
  801a9a:	73 12                	jae    801aae <sprintputch+0x33>
		*b->buf++ = ch;
  801a9c:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a9f:	8b 00                	mov    (%eax),%eax
  801aa1:	8d 48 01             	lea    0x1(%eax),%ecx
  801aa4:	8b 55 0c             	mov    0xc(%ebp),%edx
  801aa7:	89 0a                	mov    %ecx,(%edx)
  801aa9:	8b 55 08             	mov    0x8(%ebp),%edx
  801aac:	88 10                	mov    %dl,(%eax)
}
  801aae:	90                   	nop
  801aaf:	5d                   	pop    %ebp
  801ab0:	c3                   	ret    

00801ab1 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  801ab1:	55                   	push   %ebp
  801ab2:	89 e5                	mov    %esp,%ebp
  801ab4:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  801ab7:	8b 45 08             	mov    0x8(%ebp),%eax
  801aba:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801abd:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ac0:	8d 50 ff             	lea    -0x1(%eax),%edx
  801ac3:	8b 45 08             	mov    0x8(%ebp),%eax
  801ac6:	01 d0                	add    %edx,%eax
  801ac8:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801acb:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  801ad2:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801ad6:	74 06                	je     801ade <vsnprintf+0x2d>
  801ad8:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801adc:	7f 07                	jg     801ae5 <vsnprintf+0x34>
		return -E_INVAL;
  801ade:	b8 03 00 00 00       	mov    $0x3,%eax
  801ae3:	eb 20                	jmp    801b05 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  801ae5:	ff 75 14             	pushl  0x14(%ebp)
  801ae8:	ff 75 10             	pushl  0x10(%ebp)
  801aeb:	8d 45 ec             	lea    -0x14(%ebp),%eax
  801aee:	50                   	push   %eax
  801aef:	68 7b 1a 80 00       	push   $0x801a7b
  801af4:	e8 80 fb ff ff       	call   801679 <vprintfmt>
  801af9:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  801afc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801aff:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  801b02:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  801b05:	c9                   	leave  
  801b06:	c3                   	ret    

00801b07 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  801b07:	55                   	push   %ebp
  801b08:	89 e5                	mov    %esp,%ebp
  801b0a:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  801b0d:	8d 45 10             	lea    0x10(%ebp),%eax
  801b10:	83 c0 04             	add    $0x4,%eax
  801b13:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  801b16:	8b 45 10             	mov    0x10(%ebp),%eax
  801b19:	ff 75 f4             	pushl  -0xc(%ebp)
  801b1c:	50                   	push   %eax
  801b1d:	ff 75 0c             	pushl  0xc(%ebp)
  801b20:	ff 75 08             	pushl  0x8(%ebp)
  801b23:	e8 89 ff ff ff       	call   801ab1 <vsnprintf>
  801b28:	83 c4 10             	add    $0x10,%esp
  801b2b:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  801b2e:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801b31:	c9                   	leave  
  801b32:	c3                   	ret    

00801b33 <readline>:
#include <inc/lib.h>

//static char buf[BUFLEN];

void readline(const char *prompt, char* buf)
{
  801b33:	55                   	push   %ebp
  801b34:	89 e5                	mov    %esp,%ebp
  801b36:	83 ec 18             	sub    $0x18,%esp
	int i, c, echoing;

	if (prompt != NULL)
  801b39:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801b3d:	74 13                	je     801b52 <readline+0x1f>
		cprintf("%s", prompt);
  801b3f:	83 ec 08             	sub    $0x8,%esp
  801b42:	ff 75 08             	pushl  0x8(%ebp)
  801b45:	68 28 48 80 00       	push   $0x804828
  801b4a:	e8 0b f9 ff ff       	call   80145a <cprintf>
  801b4f:	83 c4 10             	add    $0x10,%esp

	i = 0;
  801b52:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	echoing = iscons(0);
  801b59:	83 ec 0c             	sub    $0xc,%esp
  801b5c:	6a 00                	push   $0x0
  801b5e:	e8 5a f4 ff ff       	call   800fbd <iscons>
  801b63:	83 c4 10             	add    $0x10,%esp
  801b66:	89 45 f0             	mov    %eax,-0x10(%ebp)
	while (1) {
		c = getchar();
  801b69:	e8 3c f4 ff ff       	call   800faa <getchar>
  801b6e:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if (c < 0) {
  801b71:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801b75:	79 22                	jns    801b99 <readline+0x66>
			if (c != -E_EOF)
  801b77:	83 7d ec 07          	cmpl   $0x7,-0x14(%ebp)
  801b7b:	0f 84 ad 00 00 00    	je     801c2e <readline+0xfb>
				cprintf("read error: %e\n", c);
  801b81:	83 ec 08             	sub    $0x8,%esp
  801b84:	ff 75 ec             	pushl  -0x14(%ebp)
  801b87:	68 2b 48 80 00       	push   $0x80482b
  801b8c:	e8 c9 f8 ff ff       	call   80145a <cprintf>
  801b91:	83 c4 10             	add    $0x10,%esp
			break;
  801b94:	e9 95 00 00 00       	jmp    801c2e <readline+0xfb>
		} else if (c >= ' ' && i < BUFLEN-1) {
  801b99:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%ebp)
  801b9d:	7e 34                	jle    801bd3 <readline+0xa0>
  801b9f:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  801ba6:	7f 2b                	jg     801bd3 <readline+0xa0>
			if (echoing)
  801ba8:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801bac:	74 0e                	je     801bbc <readline+0x89>
				cputchar(c);
  801bae:	83 ec 0c             	sub    $0xc,%esp
  801bb1:	ff 75 ec             	pushl  -0x14(%ebp)
  801bb4:	e8 d2 f3 ff ff       	call   800f8b <cputchar>
  801bb9:	83 c4 10             	add    $0x10,%esp
			buf[i++] = c;
  801bbc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801bbf:	8d 50 01             	lea    0x1(%eax),%edx
  801bc2:	89 55 f4             	mov    %edx,-0xc(%ebp)
  801bc5:	89 c2                	mov    %eax,%edx
  801bc7:	8b 45 0c             	mov    0xc(%ebp),%eax
  801bca:	01 d0                	add    %edx,%eax
  801bcc:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801bcf:	88 10                	mov    %dl,(%eax)
  801bd1:	eb 56                	jmp    801c29 <readline+0xf6>
		} else if (c == '\b' && i > 0) {
  801bd3:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  801bd7:	75 1f                	jne    801bf8 <readline+0xc5>
  801bd9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801bdd:	7e 19                	jle    801bf8 <readline+0xc5>
			if (echoing)
  801bdf:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801be3:	74 0e                	je     801bf3 <readline+0xc0>
				cputchar(c);
  801be5:	83 ec 0c             	sub    $0xc,%esp
  801be8:	ff 75 ec             	pushl  -0x14(%ebp)
  801beb:	e8 9b f3 ff ff       	call   800f8b <cputchar>
  801bf0:	83 c4 10             	add    $0x10,%esp

			i--;
  801bf3:	ff 4d f4             	decl   -0xc(%ebp)
  801bf6:	eb 31                	jmp    801c29 <readline+0xf6>
		} else if (c == '\n' || c == '\r') {
  801bf8:	83 7d ec 0a          	cmpl   $0xa,-0x14(%ebp)
  801bfc:	74 0a                	je     801c08 <readline+0xd5>
  801bfe:	83 7d ec 0d          	cmpl   $0xd,-0x14(%ebp)
  801c02:	0f 85 61 ff ff ff    	jne    801b69 <readline+0x36>
			if (echoing)
  801c08:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801c0c:	74 0e                	je     801c1c <readline+0xe9>
				cputchar(c);
  801c0e:	83 ec 0c             	sub    $0xc,%esp
  801c11:	ff 75 ec             	pushl  -0x14(%ebp)
  801c14:	e8 72 f3 ff ff       	call   800f8b <cputchar>
  801c19:	83 c4 10             	add    $0x10,%esp

			buf[i] = 0;
  801c1c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801c1f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c22:	01 d0                	add    %edx,%eax
  801c24:	c6 00 00             	movb   $0x0,(%eax)
			break;
  801c27:	eb 06                	jmp    801c2f <readline+0xfc>
		}
	}
  801c29:	e9 3b ff ff ff       	jmp    801b69 <readline+0x36>
	while (1) {
		c = getchar();
		if (c < 0) {
			if (c != -E_EOF)
				cprintf("read error: %e\n", c);
			break;
  801c2e:	90                   	nop

			buf[i] = 0;
			break;
		}
	}
}
  801c2f:	90                   	nop
  801c30:	c9                   	leave  
  801c31:	c3                   	ret    

00801c32 <atomic_readline>:

void atomic_readline(const char *prompt, char* buf)
{
  801c32:	55                   	push   %ebp
  801c33:	89 e5                	mov    %esp,%ebp
  801c35:	83 ec 18             	sub    $0x18,%esp
	sys_lock_cons();
  801c38:	e8 30 0b 00 00       	call   80276d <sys_lock_cons>
	{
		int i, c, echoing;

		if (prompt != NULL)
  801c3d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801c41:	74 13                	je     801c56 <atomic_readline+0x24>
			cprintf("%s", prompt);
  801c43:	83 ec 08             	sub    $0x8,%esp
  801c46:	ff 75 08             	pushl  0x8(%ebp)
  801c49:	68 28 48 80 00       	push   $0x804828
  801c4e:	e8 07 f8 ff ff       	call   80145a <cprintf>
  801c53:	83 c4 10             	add    $0x10,%esp

		i = 0;
  801c56:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
		echoing = iscons(0);
  801c5d:	83 ec 0c             	sub    $0xc,%esp
  801c60:	6a 00                	push   $0x0
  801c62:	e8 56 f3 ff ff       	call   800fbd <iscons>
  801c67:	83 c4 10             	add    $0x10,%esp
  801c6a:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (1) {
			c = getchar();
  801c6d:	e8 38 f3 ff ff       	call   800faa <getchar>
  801c72:	89 45 ec             	mov    %eax,-0x14(%ebp)
			if (c < 0) {
  801c75:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801c79:	79 22                	jns    801c9d <atomic_readline+0x6b>
				if (c != -E_EOF)
  801c7b:	83 7d ec 07          	cmpl   $0x7,-0x14(%ebp)
  801c7f:	0f 84 ad 00 00 00    	je     801d32 <atomic_readline+0x100>
					cprintf("read error: %e\n", c);
  801c85:	83 ec 08             	sub    $0x8,%esp
  801c88:	ff 75 ec             	pushl  -0x14(%ebp)
  801c8b:	68 2b 48 80 00       	push   $0x80482b
  801c90:	e8 c5 f7 ff ff       	call   80145a <cprintf>
  801c95:	83 c4 10             	add    $0x10,%esp
				break;
  801c98:	e9 95 00 00 00       	jmp    801d32 <atomic_readline+0x100>
			} else if (c >= ' ' && i < BUFLEN-1) {
  801c9d:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%ebp)
  801ca1:	7e 34                	jle    801cd7 <atomic_readline+0xa5>
  801ca3:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  801caa:	7f 2b                	jg     801cd7 <atomic_readline+0xa5>
				if (echoing)
  801cac:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801cb0:	74 0e                	je     801cc0 <atomic_readline+0x8e>
					cputchar(c);
  801cb2:	83 ec 0c             	sub    $0xc,%esp
  801cb5:	ff 75 ec             	pushl  -0x14(%ebp)
  801cb8:	e8 ce f2 ff ff       	call   800f8b <cputchar>
  801cbd:	83 c4 10             	add    $0x10,%esp
				buf[i++] = c;
  801cc0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801cc3:	8d 50 01             	lea    0x1(%eax),%edx
  801cc6:	89 55 f4             	mov    %edx,-0xc(%ebp)
  801cc9:	89 c2                	mov    %eax,%edx
  801ccb:	8b 45 0c             	mov    0xc(%ebp),%eax
  801cce:	01 d0                	add    %edx,%eax
  801cd0:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801cd3:	88 10                	mov    %dl,(%eax)
  801cd5:	eb 56                	jmp    801d2d <atomic_readline+0xfb>
			} else if (c == '\b' && i > 0) {
  801cd7:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  801cdb:	75 1f                	jne    801cfc <atomic_readline+0xca>
  801cdd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801ce1:	7e 19                	jle    801cfc <atomic_readline+0xca>
				if (echoing)
  801ce3:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801ce7:	74 0e                	je     801cf7 <atomic_readline+0xc5>
					cputchar(c);
  801ce9:	83 ec 0c             	sub    $0xc,%esp
  801cec:	ff 75 ec             	pushl  -0x14(%ebp)
  801cef:	e8 97 f2 ff ff       	call   800f8b <cputchar>
  801cf4:	83 c4 10             	add    $0x10,%esp
				i--;
  801cf7:	ff 4d f4             	decl   -0xc(%ebp)
  801cfa:	eb 31                	jmp    801d2d <atomic_readline+0xfb>
			} else if (c == '\n' || c == '\r') {
  801cfc:	83 7d ec 0a          	cmpl   $0xa,-0x14(%ebp)
  801d00:	74 0a                	je     801d0c <atomic_readline+0xda>
  801d02:	83 7d ec 0d          	cmpl   $0xd,-0x14(%ebp)
  801d06:	0f 85 61 ff ff ff    	jne    801c6d <atomic_readline+0x3b>
				if (echoing)
  801d0c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801d10:	74 0e                	je     801d20 <atomic_readline+0xee>
					cputchar(c);
  801d12:	83 ec 0c             	sub    $0xc,%esp
  801d15:	ff 75 ec             	pushl  -0x14(%ebp)
  801d18:	e8 6e f2 ff ff       	call   800f8b <cputchar>
  801d1d:	83 c4 10             	add    $0x10,%esp
				buf[i] = 0;
  801d20:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801d23:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d26:	01 d0                	add    %edx,%eax
  801d28:	c6 00 00             	movb   $0x0,(%eax)
				break;
  801d2b:	eb 06                	jmp    801d33 <atomic_readline+0x101>
			}
		}
  801d2d:	e9 3b ff ff ff       	jmp    801c6d <atomic_readline+0x3b>
		while (1) {
			c = getchar();
			if (c < 0) {
				if (c != -E_EOF)
					cprintf("read error: %e\n", c);
				break;
  801d32:	90                   	nop
				buf[i] = 0;
				break;
			}
		}
	}
	sys_unlock_cons();
  801d33:	e8 4f 0a 00 00       	call   802787 <sys_unlock_cons>
}
  801d38:	90                   	nop
  801d39:	c9                   	leave  
  801d3a:	c3                   	ret    

00801d3b <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  801d3b:	55                   	push   %ebp
  801d3c:	89 e5                	mov    %esp,%ebp
  801d3e:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  801d41:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801d48:	eb 06                	jmp    801d50 <strlen+0x15>
		n++;
  801d4a:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  801d4d:	ff 45 08             	incl   0x8(%ebp)
  801d50:	8b 45 08             	mov    0x8(%ebp),%eax
  801d53:	8a 00                	mov    (%eax),%al
  801d55:	84 c0                	test   %al,%al
  801d57:	75 f1                	jne    801d4a <strlen+0xf>
		n++;
	return n;
  801d59:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801d5c:	c9                   	leave  
  801d5d:	c3                   	ret    

00801d5e <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  801d5e:	55                   	push   %ebp
  801d5f:	89 e5                	mov    %esp,%ebp
  801d61:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801d64:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801d6b:	eb 09                	jmp    801d76 <strnlen+0x18>
		n++;
  801d6d:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801d70:	ff 45 08             	incl   0x8(%ebp)
  801d73:	ff 4d 0c             	decl   0xc(%ebp)
  801d76:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801d7a:	74 09                	je     801d85 <strnlen+0x27>
  801d7c:	8b 45 08             	mov    0x8(%ebp),%eax
  801d7f:	8a 00                	mov    (%eax),%al
  801d81:	84 c0                	test   %al,%al
  801d83:	75 e8                	jne    801d6d <strnlen+0xf>
		n++;
	return n;
  801d85:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801d88:	c9                   	leave  
  801d89:	c3                   	ret    

00801d8a <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  801d8a:	55                   	push   %ebp
  801d8b:	89 e5                	mov    %esp,%ebp
  801d8d:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  801d90:	8b 45 08             	mov    0x8(%ebp),%eax
  801d93:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  801d96:	90                   	nop
  801d97:	8b 45 08             	mov    0x8(%ebp),%eax
  801d9a:	8d 50 01             	lea    0x1(%eax),%edx
  801d9d:	89 55 08             	mov    %edx,0x8(%ebp)
  801da0:	8b 55 0c             	mov    0xc(%ebp),%edx
  801da3:	8d 4a 01             	lea    0x1(%edx),%ecx
  801da6:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  801da9:	8a 12                	mov    (%edx),%dl
  801dab:	88 10                	mov    %dl,(%eax)
  801dad:	8a 00                	mov    (%eax),%al
  801daf:	84 c0                	test   %al,%al
  801db1:	75 e4                	jne    801d97 <strcpy+0xd>
		/* do nothing */;
	return ret;
  801db3:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801db6:	c9                   	leave  
  801db7:	c3                   	ret    

00801db8 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  801db8:	55                   	push   %ebp
  801db9:	89 e5                	mov    %esp,%ebp
  801dbb:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  801dbe:	8b 45 08             	mov    0x8(%ebp),%eax
  801dc1:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  801dc4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801dcb:	eb 1f                	jmp    801dec <strncpy+0x34>
		*dst++ = *src;
  801dcd:	8b 45 08             	mov    0x8(%ebp),%eax
  801dd0:	8d 50 01             	lea    0x1(%eax),%edx
  801dd3:	89 55 08             	mov    %edx,0x8(%ebp)
  801dd6:	8b 55 0c             	mov    0xc(%ebp),%edx
  801dd9:	8a 12                	mov    (%edx),%dl
  801ddb:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  801ddd:	8b 45 0c             	mov    0xc(%ebp),%eax
  801de0:	8a 00                	mov    (%eax),%al
  801de2:	84 c0                	test   %al,%al
  801de4:	74 03                	je     801de9 <strncpy+0x31>
			src++;
  801de6:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  801de9:	ff 45 fc             	incl   -0x4(%ebp)
  801dec:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801def:	3b 45 10             	cmp    0x10(%ebp),%eax
  801df2:	72 d9                	jb     801dcd <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  801df4:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801df7:	c9                   	leave  
  801df8:	c3                   	ret    

00801df9 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  801df9:	55                   	push   %ebp
  801dfa:	89 e5                	mov    %esp,%ebp
  801dfc:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  801dff:	8b 45 08             	mov    0x8(%ebp),%eax
  801e02:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  801e05:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801e09:	74 30                	je     801e3b <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  801e0b:	eb 16                	jmp    801e23 <strlcpy+0x2a>
			*dst++ = *src++;
  801e0d:	8b 45 08             	mov    0x8(%ebp),%eax
  801e10:	8d 50 01             	lea    0x1(%eax),%edx
  801e13:	89 55 08             	mov    %edx,0x8(%ebp)
  801e16:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e19:	8d 4a 01             	lea    0x1(%edx),%ecx
  801e1c:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  801e1f:	8a 12                	mov    (%edx),%dl
  801e21:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  801e23:	ff 4d 10             	decl   0x10(%ebp)
  801e26:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801e2a:	74 09                	je     801e35 <strlcpy+0x3c>
  801e2c:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e2f:	8a 00                	mov    (%eax),%al
  801e31:	84 c0                	test   %al,%al
  801e33:	75 d8                	jne    801e0d <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  801e35:	8b 45 08             	mov    0x8(%ebp),%eax
  801e38:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  801e3b:	8b 55 08             	mov    0x8(%ebp),%edx
  801e3e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801e41:	29 c2                	sub    %eax,%edx
  801e43:	89 d0                	mov    %edx,%eax
}
  801e45:	c9                   	leave  
  801e46:	c3                   	ret    

00801e47 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  801e47:	55                   	push   %ebp
  801e48:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  801e4a:	eb 06                	jmp    801e52 <strcmp+0xb>
		p++, q++;
  801e4c:	ff 45 08             	incl   0x8(%ebp)
  801e4f:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  801e52:	8b 45 08             	mov    0x8(%ebp),%eax
  801e55:	8a 00                	mov    (%eax),%al
  801e57:	84 c0                	test   %al,%al
  801e59:	74 0e                	je     801e69 <strcmp+0x22>
  801e5b:	8b 45 08             	mov    0x8(%ebp),%eax
  801e5e:	8a 10                	mov    (%eax),%dl
  801e60:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e63:	8a 00                	mov    (%eax),%al
  801e65:	38 c2                	cmp    %al,%dl
  801e67:	74 e3                	je     801e4c <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  801e69:	8b 45 08             	mov    0x8(%ebp),%eax
  801e6c:	8a 00                	mov    (%eax),%al
  801e6e:	0f b6 d0             	movzbl %al,%edx
  801e71:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e74:	8a 00                	mov    (%eax),%al
  801e76:	0f b6 c0             	movzbl %al,%eax
  801e79:	29 c2                	sub    %eax,%edx
  801e7b:	89 d0                	mov    %edx,%eax
}
  801e7d:	5d                   	pop    %ebp
  801e7e:	c3                   	ret    

00801e7f <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  801e7f:	55                   	push   %ebp
  801e80:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  801e82:	eb 09                	jmp    801e8d <strncmp+0xe>
		n--, p++, q++;
  801e84:	ff 4d 10             	decl   0x10(%ebp)
  801e87:	ff 45 08             	incl   0x8(%ebp)
  801e8a:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  801e8d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801e91:	74 17                	je     801eaa <strncmp+0x2b>
  801e93:	8b 45 08             	mov    0x8(%ebp),%eax
  801e96:	8a 00                	mov    (%eax),%al
  801e98:	84 c0                	test   %al,%al
  801e9a:	74 0e                	je     801eaa <strncmp+0x2b>
  801e9c:	8b 45 08             	mov    0x8(%ebp),%eax
  801e9f:	8a 10                	mov    (%eax),%dl
  801ea1:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ea4:	8a 00                	mov    (%eax),%al
  801ea6:	38 c2                	cmp    %al,%dl
  801ea8:	74 da                	je     801e84 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  801eaa:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801eae:	75 07                	jne    801eb7 <strncmp+0x38>
		return 0;
  801eb0:	b8 00 00 00 00       	mov    $0x0,%eax
  801eb5:	eb 14                	jmp    801ecb <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  801eb7:	8b 45 08             	mov    0x8(%ebp),%eax
  801eba:	8a 00                	mov    (%eax),%al
  801ebc:	0f b6 d0             	movzbl %al,%edx
  801ebf:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ec2:	8a 00                	mov    (%eax),%al
  801ec4:	0f b6 c0             	movzbl %al,%eax
  801ec7:	29 c2                	sub    %eax,%edx
  801ec9:	89 d0                	mov    %edx,%eax
}
  801ecb:	5d                   	pop    %ebp
  801ecc:	c3                   	ret    

00801ecd <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  801ecd:	55                   	push   %ebp
  801ece:	89 e5                	mov    %esp,%ebp
  801ed0:	83 ec 04             	sub    $0x4,%esp
  801ed3:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ed6:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  801ed9:	eb 12                	jmp    801eed <strchr+0x20>
		if (*s == c)
  801edb:	8b 45 08             	mov    0x8(%ebp),%eax
  801ede:	8a 00                	mov    (%eax),%al
  801ee0:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801ee3:	75 05                	jne    801eea <strchr+0x1d>
			return (char *) s;
  801ee5:	8b 45 08             	mov    0x8(%ebp),%eax
  801ee8:	eb 11                	jmp    801efb <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  801eea:	ff 45 08             	incl   0x8(%ebp)
  801eed:	8b 45 08             	mov    0x8(%ebp),%eax
  801ef0:	8a 00                	mov    (%eax),%al
  801ef2:	84 c0                	test   %al,%al
  801ef4:	75 e5                	jne    801edb <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  801ef6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801efb:	c9                   	leave  
  801efc:	c3                   	ret    

00801efd <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  801efd:	55                   	push   %ebp
  801efe:	89 e5                	mov    %esp,%ebp
  801f00:	83 ec 04             	sub    $0x4,%esp
  801f03:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f06:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  801f09:	eb 0d                	jmp    801f18 <strfind+0x1b>
		if (*s == c)
  801f0b:	8b 45 08             	mov    0x8(%ebp),%eax
  801f0e:	8a 00                	mov    (%eax),%al
  801f10:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801f13:	74 0e                	je     801f23 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  801f15:	ff 45 08             	incl   0x8(%ebp)
  801f18:	8b 45 08             	mov    0x8(%ebp),%eax
  801f1b:	8a 00                	mov    (%eax),%al
  801f1d:	84 c0                	test   %al,%al
  801f1f:	75 ea                	jne    801f0b <strfind+0xe>
  801f21:	eb 01                	jmp    801f24 <strfind+0x27>
		if (*s == c)
			break;
  801f23:	90                   	nop
	return (char *) s;
  801f24:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801f27:	c9                   	leave  
  801f28:	c3                   	ret    

00801f29 <memset>:

// *************** The faster implementation of memset & memcpy is implemented by *************
// ****************** Team80 (Yahia Khaled, Malek Ahmed et al) - FCIS'24-25 *******************
void *
memset(void *v, int c, uint32 n)
{
  801f29:	55                   	push   %ebp
  801f2a:	89 e5                	mov    %esp,%ebp
  801f2c:	83 ec 10             	sub    $0x10,%esp
//	m = n;
//	while (--m >= 0)
//		*p++ = c;

	/*Faster Implementation*/
	uint64* p64 = (uint64*)v;
  801f2f:	8b 45 08             	mov    0x8(%ebp),%eax
  801f32:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if(n >= 8){
  801f35:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  801f39:	76 63                	jbe    801f9e <memset+0x75>
		uint64 data_block = c;
  801f3b:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f3e:	99                   	cltd   
  801f3f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801f42:	89 55 f4             	mov    %edx,-0xc(%ebp)
		data_block |= data_block << 8;
  801f45:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f48:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801f4b:	0f a4 c2 08          	shld   $0x8,%eax,%edx
  801f4f:	c1 e0 08             	shl    $0x8,%eax
  801f52:	09 45 f0             	or     %eax,-0x10(%ebp)
  801f55:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 16;
  801f58:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f5b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801f5e:	0f a4 c2 10          	shld   $0x10,%eax,%edx
  801f62:	c1 e0 10             	shl    $0x10,%eax
  801f65:	09 45 f0             	or     %eax,-0x10(%ebp)
  801f68:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 32;
  801f6b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f6e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801f71:	89 c2                	mov    %eax,%edx
  801f73:	b8 00 00 00 00       	mov    $0x0,%eax
  801f78:	09 45 f0             	or     %eax,-0x10(%ebp)
  801f7b:	09 55 f4             	or     %edx,-0xc(%ebp)

		while(n >= 8)
  801f7e:	eb 18                	jmp    801f98 <memset+0x6f>
			*p64++ = data_block, n -= 8;
  801f80:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801f83:	8d 41 08             	lea    0x8(%ecx),%eax
  801f86:	89 45 fc             	mov    %eax,-0x4(%ebp)
  801f89:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f8c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801f8f:	89 01                	mov    %eax,(%ecx)
  801f91:	89 51 04             	mov    %edx,0x4(%ecx)
  801f94:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
		uint64 data_block = c;
		data_block |= data_block << 8;
		data_block |= data_block << 16;
		data_block |= data_block << 32;

		while(n >= 8)
  801f98:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  801f9c:	77 e2                	ja     801f80 <memset+0x57>
			*p64++ = data_block, n -= 8;
	}

	if(n){
  801f9e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801fa2:	74 23                	je     801fc7 <memset+0x9e>
		uint8* p8 = (uint8*)p64;
  801fa4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801fa7:	89 45 f8             	mov    %eax,-0x8(%ebp)
		while (n-- > 0)
  801faa:	eb 0e                	jmp    801fba <memset+0x91>
			*p8++ = (uint8)c;
  801fac:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801faf:	8d 50 01             	lea    0x1(%eax),%edx
  801fb2:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801fb5:	8b 55 0c             	mov    0xc(%ebp),%edx
  801fb8:	88 10                	mov    %dl,(%eax)
			*p64++ = data_block, n -= 8;
	}

	if(n){
		uint8* p8 = (uint8*)p64;
		while (n-- > 0)
  801fba:	8b 45 10             	mov    0x10(%ebp),%eax
  801fbd:	8d 50 ff             	lea    -0x1(%eax),%edx
  801fc0:	89 55 10             	mov    %edx,0x10(%ebp)
  801fc3:	85 c0                	test   %eax,%eax
  801fc5:	75 e5                	jne    801fac <memset+0x83>
			*p8++ = (uint8)c;
	}

	return v;
  801fc7:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801fca:	c9                   	leave  
  801fcb:	c3                   	ret    

00801fcc <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  801fcc:	55                   	push   %ebp
  801fcd:	89 e5                	mov    %esp,%ebp
  801fcf:	83 ec 10             	sub    $0x10,%esp
	//	s = src;
	//	d = dst;
	//	while (n-- > 0)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
  801fd2:	8b 45 0c             	mov    0xc(%ebp),%eax
  801fd5:	89 45 fc             	mov    %eax,-0x4(%ebp)
	uint64* d64 = (uint64*)dst;
  801fd8:	8b 45 08             	mov    0x8(%ebp),%eax
  801fdb:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if(n >= 8){
  801fde:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  801fe2:	76 24                	jbe    802008 <memcpy+0x3c>
		while(n >= 8){
  801fe4:	eb 1c                	jmp    802002 <memcpy+0x36>
			*d64 = *s64;
  801fe6:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801fe9:	8b 50 04             	mov    0x4(%eax),%edx
  801fec:	8b 00                	mov    (%eax),%eax
  801fee:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801ff1:	89 01                	mov    %eax,(%ecx)
  801ff3:	89 51 04             	mov    %edx,0x4(%ecx)
			n -= 8;
  801ff6:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
			++s64;
  801ffa:	83 45 fc 08          	addl   $0x8,-0x4(%ebp)
			++d64;
  801ffe:	83 45 f8 08          	addl   $0x8,-0x8(%ebp)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
	uint64* d64 = (uint64*)dst;
	if(n >= 8){
		while(n >= 8){
  802002:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  802006:	77 de                	ja     801fe6 <memcpy+0x1a>
			++s64;
			++d64;
		}
	}

	if(n){
  802008:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80200c:	74 31                	je     80203f <memcpy+0x73>
		uint8* s8 = (uint8*)s64;
  80200e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802011:	89 45 f4             	mov    %eax,-0xc(%ebp)
		uint8* d8 = (uint8*)d64;
  802014:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802017:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (n-- > 0)
  80201a:	eb 16                	jmp    802032 <memcpy+0x66>
			*d8++ = *s8++;
  80201c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80201f:	8d 50 01             	lea    0x1(%eax),%edx
  802022:	89 55 f0             	mov    %edx,-0x10(%ebp)
  802025:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802028:	8d 4a 01             	lea    0x1(%edx),%ecx
  80202b:	89 4d f4             	mov    %ecx,-0xc(%ebp)
  80202e:	8a 12                	mov    (%edx),%dl
  802030:	88 10                	mov    %dl,(%eax)
	}

	if(n){
		uint8* s8 = (uint8*)s64;
		uint8* d8 = (uint8*)d64;
		while (n-- > 0)
  802032:	8b 45 10             	mov    0x10(%ebp),%eax
  802035:	8d 50 ff             	lea    -0x1(%eax),%edx
  802038:	89 55 10             	mov    %edx,0x10(%ebp)
  80203b:	85 c0                	test   %eax,%eax
  80203d:	75 dd                	jne    80201c <memcpy+0x50>
			*d8++ = *s8++;
	}
	return dst;
  80203f:	8b 45 08             	mov    0x8(%ebp),%eax
}
  802042:	c9                   	leave  
  802043:	c3                   	ret    

00802044 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  802044:	55                   	push   %ebp
  802045:	89 e5                	mov    %esp,%ebp
  802047:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  80204a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80204d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  802050:	8b 45 08             	mov    0x8(%ebp),%eax
  802053:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  802056:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802059:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  80205c:	73 50                	jae    8020ae <memmove+0x6a>
  80205e:	8b 55 fc             	mov    -0x4(%ebp),%edx
  802061:	8b 45 10             	mov    0x10(%ebp),%eax
  802064:	01 d0                	add    %edx,%eax
  802066:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  802069:	76 43                	jbe    8020ae <memmove+0x6a>
		s += n;
  80206b:	8b 45 10             	mov    0x10(%ebp),%eax
  80206e:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  802071:	8b 45 10             	mov    0x10(%ebp),%eax
  802074:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  802077:	eb 10                	jmp    802089 <memmove+0x45>
			*--d = *--s;
  802079:	ff 4d f8             	decl   -0x8(%ebp)
  80207c:	ff 4d fc             	decl   -0x4(%ebp)
  80207f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802082:	8a 10                	mov    (%eax),%dl
  802084:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802087:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  802089:	8b 45 10             	mov    0x10(%ebp),%eax
  80208c:	8d 50 ff             	lea    -0x1(%eax),%edx
  80208f:	89 55 10             	mov    %edx,0x10(%ebp)
  802092:	85 c0                	test   %eax,%eax
  802094:	75 e3                	jne    802079 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  802096:	eb 23                	jmp    8020bb <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  802098:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80209b:	8d 50 01             	lea    0x1(%eax),%edx
  80209e:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8020a1:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8020a4:	8d 4a 01             	lea    0x1(%edx),%ecx
  8020a7:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  8020aa:	8a 12                	mov    (%edx),%dl
  8020ac:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  8020ae:	8b 45 10             	mov    0x10(%ebp),%eax
  8020b1:	8d 50 ff             	lea    -0x1(%eax),%edx
  8020b4:	89 55 10             	mov    %edx,0x10(%ebp)
  8020b7:	85 c0                	test   %eax,%eax
  8020b9:	75 dd                	jne    802098 <memmove+0x54>
			*d++ = *s++;

	return dst;
  8020bb:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8020be:	c9                   	leave  
  8020bf:	c3                   	ret    

008020c0 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  8020c0:	55                   	push   %ebp
  8020c1:	89 e5                	mov    %esp,%ebp
  8020c3:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  8020c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8020c9:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  8020cc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8020cf:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  8020d2:	eb 2a                	jmp    8020fe <memcmp+0x3e>
		if (*s1 != *s2)
  8020d4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8020d7:	8a 10                	mov    (%eax),%dl
  8020d9:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8020dc:	8a 00                	mov    (%eax),%al
  8020de:	38 c2                	cmp    %al,%dl
  8020e0:	74 16                	je     8020f8 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  8020e2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8020e5:	8a 00                	mov    (%eax),%al
  8020e7:	0f b6 d0             	movzbl %al,%edx
  8020ea:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8020ed:	8a 00                	mov    (%eax),%al
  8020ef:	0f b6 c0             	movzbl %al,%eax
  8020f2:	29 c2                	sub    %eax,%edx
  8020f4:	89 d0                	mov    %edx,%eax
  8020f6:	eb 18                	jmp    802110 <memcmp+0x50>
		s1++, s2++;
  8020f8:	ff 45 fc             	incl   -0x4(%ebp)
  8020fb:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  8020fe:	8b 45 10             	mov    0x10(%ebp),%eax
  802101:	8d 50 ff             	lea    -0x1(%eax),%edx
  802104:	89 55 10             	mov    %edx,0x10(%ebp)
  802107:	85 c0                	test   %eax,%eax
  802109:	75 c9                	jne    8020d4 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  80210b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802110:	c9                   	leave  
  802111:	c3                   	ret    

00802112 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  802112:	55                   	push   %ebp
  802113:	89 e5                	mov    %esp,%ebp
  802115:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  802118:	8b 55 08             	mov    0x8(%ebp),%edx
  80211b:	8b 45 10             	mov    0x10(%ebp),%eax
  80211e:	01 d0                	add    %edx,%eax
  802120:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  802123:	eb 15                	jmp    80213a <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  802125:	8b 45 08             	mov    0x8(%ebp),%eax
  802128:	8a 00                	mov    (%eax),%al
  80212a:	0f b6 d0             	movzbl %al,%edx
  80212d:	8b 45 0c             	mov    0xc(%ebp),%eax
  802130:	0f b6 c0             	movzbl %al,%eax
  802133:	39 c2                	cmp    %eax,%edx
  802135:	74 0d                	je     802144 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  802137:	ff 45 08             	incl   0x8(%ebp)
  80213a:	8b 45 08             	mov    0x8(%ebp),%eax
  80213d:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  802140:	72 e3                	jb     802125 <memfind+0x13>
  802142:	eb 01                	jmp    802145 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  802144:	90                   	nop
	return (void *) s;
  802145:	8b 45 08             	mov    0x8(%ebp),%eax
}
  802148:	c9                   	leave  
  802149:	c3                   	ret    

0080214a <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  80214a:	55                   	push   %ebp
  80214b:	89 e5                	mov    %esp,%ebp
  80214d:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  802150:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  802157:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80215e:	eb 03                	jmp    802163 <strtol+0x19>
		s++;
  802160:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  802163:	8b 45 08             	mov    0x8(%ebp),%eax
  802166:	8a 00                	mov    (%eax),%al
  802168:	3c 20                	cmp    $0x20,%al
  80216a:	74 f4                	je     802160 <strtol+0x16>
  80216c:	8b 45 08             	mov    0x8(%ebp),%eax
  80216f:	8a 00                	mov    (%eax),%al
  802171:	3c 09                	cmp    $0x9,%al
  802173:	74 eb                	je     802160 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  802175:	8b 45 08             	mov    0x8(%ebp),%eax
  802178:	8a 00                	mov    (%eax),%al
  80217a:	3c 2b                	cmp    $0x2b,%al
  80217c:	75 05                	jne    802183 <strtol+0x39>
		s++;
  80217e:	ff 45 08             	incl   0x8(%ebp)
  802181:	eb 13                	jmp    802196 <strtol+0x4c>
	else if (*s == '-')
  802183:	8b 45 08             	mov    0x8(%ebp),%eax
  802186:	8a 00                	mov    (%eax),%al
  802188:	3c 2d                	cmp    $0x2d,%al
  80218a:	75 0a                	jne    802196 <strtol+0x4c>
		s++, neg = 1;
  80218c:	ff 45 08             	incl   0x8(%ebp)
  80218f:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  802196:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80219a:	74 06                	je     8021a2 <strtol+0x58>
  80219c:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  8021a0:	75 20                	jne    8021c2 <strtol+0x78>
  8021a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8021a5:	8a 00                	mov    (%eax),%al
  8021a7:	3c 30                	cmp    $0x30,%al
  8021a9:	75 17                	jne    8021c2 <strtol+0x78>
  8021ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8021ae:	40                   	inc    %eax
  8021af:	8a 00                	mov    (%eax),%al
  8021b1:	3c 78                	cmp    $0x78,%al
  8021b3:	75 0d                	jne    8021c2 <strtol+0x78>
		s += 2, base = 16;
  8021b5:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  8021b9:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  8021c0:	eb 28                	jmp    8021ea <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  8021c2:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8021c6:	75 15                	jne    8021dd <strtol+0x93>
  8021c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8021cb:	8a 00                	mov    (%eax),%al
  8021cd:	3c 30                	cmp    $0x30,%al
  8021cf:	75 0c                	jne    8021dd <strtol+0x93>
		s++, base = 8;
  8021d1:	ff 45 08             	incl   0x8(%ebp)
  8021d4:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  8021db:	eb 0d                	jmp    8021ea <strtol+0xa0>
	else if (base == 0)
  8021dd:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8021e1:	75 07                	jne    8021ea <strtol+0xa0>
		base = 10;
  8021e3:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8021ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8021ed:	8a 00                	mov    (%eax),%al
  8021ef:	3c 2f                	cmp    $0x2f,%al
  8021f1:	7e 19                	jle    80220c <strtol+0xc2>
  8021f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8021f6:	8a 00                	mov    (%eax),%al
  8021f8:	3c 39                	cmp    $0x39,%al
  8021fa:	7f 10                	jg     80220c <strtol+0xc2>
			dig = *s - '0';
  8021fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8021ff:	8a 00                	mov    (%eax),%al
  802201:	0f be c0             	movsbl %al,%eax
  802204:	83 e8 30             	sub    $0x30,%eax
  802207:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80220a:	eb 42                	jmp    80224e <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  80220c:	8b 45 08             	mov    0x8(%ebp),%eax
  80220f:	8a 00                	mov    (%eax),%al
  802211:	3c 60                	cmp    $0x60,%al
  802213:	7e 19                	jle    80222e <strtol+0xe4>
  802215:	8b 45 08             	mov    0x8(%ebp),%eax
  802218:	8a 00                	mov    (%eax),%al
  80221a:	3c 7a                	cmp    $0x7a,%al
  80221c:	7f 10                	jg     80222e <strtol+0xe4>
			dig = *s - 'a' + 10;
  80221e:	8b 45 08             	mov    0x8(%ebp),%eax
  802221:	8a 00                	mov    (%eax),%al
  802223:	0f be c0             	movsbl %al,%eax
  802226:	83 e8 57             	sub    $0x57,%eax
  802229:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80222c:	eb 20                	jmp    80224e <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  80222e:	8b 45 08             	mov    0x8(%ebp),%eax
  802231:	8a 00                	mov    (%eax),%al
  802233:	3c 40                	cmp    $0x40,%al
  802235:	7e 39                	jle    802270 <strtol+0x126>
  802237:	8b 45 08             	mov    0x8(%ebp),%eax
  80223a:	8a 00                	mov    (%eax),%al
  80223c:	3c 5a                	cmp    $0x5a,%al
  80223e:	7f 30                	jg     802270 <strtol+0x126>
			dig = *s - 'A' + 10;
  802240:	8b 45 08             	mov    0x8(%ebp),%eax
  802243:	8a 00                	mov    (%eax),%al
  802245:	0f be c0             	movsbl %al,%eax
  802248:	83 e8 37             	sub    $0x37,%eax
  80224b:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  80224e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802251:	3b 45 10             	cmp    0x10(%ebp),%eax
  802254:	7d 19                	jge    80226f <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  802256:	ff 45 08             	incl   0x8(%ebp)
  802259:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80225c:	0f af 45 10          	imul   0x10(%ebp),%eax
  802260:	89 c2                	mov    %eax,%edx
  802262:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802265:	01 d0                	add    %edx,%eax
  802267:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  80226a:	e9 7b ff ff ff       	jmp    8021ea <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  80226f:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  802270:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802274:	74 08                	je     80227e <strtol+0x134>
		*endptr = (char *) s;
  802276:	8b 45 0c             	mov    0xc(%ebp),%eax
  802279:	8b 55 08             	mov    0x8(%ebp),%edx
  80227c:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  80227e:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802282:	74 07                	je     80228b <strtol+0x141>
  802284:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802287:	f7 d8                	neg    %eax
  802289:	eb 03                	jmp    80228e <strtol+0x144>
  80228b:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  80228e:	c9                   	leave  
  80228f:	c3                   	ret    

00802290 <ltostr>:

void
ltostr(long value, char *str)
{
  802290:	55                   	push   %ebp
  802291:	89 e5                	mov    %esp,%ebp
  802293:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  802296:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  80229d:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  8022a4:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8022a8:	79 13                	jns    8022bd <ltostr+0x2d>
	{
		neg = 1;
  8022aa:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  8022b1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8022b4:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  8022b7:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  8022ba:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  8022bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8022c0:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8022c5:	99                   	cltd   
  8022c6:	f7 f9                	idiv   %ecx
  8022c8:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  8022cb:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8022ce:	8d 50 01             	lea    0x1(%eax),%edx
  8022d1:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8022d4:	89 c2                	mov    %eax,%edx
  8022d6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8022d9:	01 d0                	add    %edx,%eax
  8022db:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8022de:	83 c2 30             	add    $0x30,%edx
  8022e1:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  8022e3:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8022e6:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8022eb:	f7 e9                	imul   %ecx
  8022ed:	c1 fa 02             	sar    $0x2,%edx
  8022f0:	89 c8                	mov    %ecx,%eax
  8022f2:	c1 f8 1f             	sar    $0x1f,%eax
  8022f5:	29 c2                	sub    %eax,%edx
  8022f7:	89 d0                	mov    %edx,%eax
  8022f9:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  8022fc:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802300:	75 bb                	jne    8022bd <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  802302:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  802309:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80230c:	48                   	dec    %eax
  80230d:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  802310:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802314:	74 3d                	je     802353 <ltostr+0xc3>
		start = 1 ;
  802316:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  80231d:	eb 34                	jmp    802353 <ltostr+0xc3>
	{
		char tmp = str[start] ;
  80231f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802322:	8b 45 0c             	mov    0xc(%ebp),%eax
  802325:	01 d0                	add    %edx,%eax
  802327:	8a 00                	mov    (%eax),%al
  802329:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  80232c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80232f:	8b 45 0c             	mov    0xc(%ebp),%eax
  802332:	01 c2                	add    %eax,%edx
  802334:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  802337:	8b 45 0c             	mov    0xc(%ebp),%eax
  80233a:	01 c8                	add    %ecx,%eax
  80233c:	8a 00                	mov    (%eax),%al
  80233e:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  802340:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802343:	8b 45 0c             	mov    0xc(%ebp),%eax
  802346:	01 c2                	add    %eax,%edx
  802348:	8a 45 eb             	mov    -0x15(%ebp),%al
  80234b:	88 02                	mov    %al,(%edx)
		start++ ;
  80234d:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  802350:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  802353:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802356:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802359:	7c c4                	jl     80231f <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  80235b:	8b 55 f8             	mov    -0x8(%ebp),%edx
  80235e:	8b 45 0c             	mov    0xc(%ebp),%eax
  802361:	01 d0                	add    %edx,%eax
  802363:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  802366:	90                   	nop
  802367:	c9                   	leave  
  802368:	c3                   	ret    

00802369 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  802369:	55                   	push   %ebp
  80236a:	89 e5                	mov    %esp,%ebp
  80236c:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  80236f:	ff 75 08             	pushl  0x8(%ebp)
  802372:	e8 c4 f9 ff ff       	call   801d3b <strlen>
  802377:	83 c4 04             	add    $0x4,%esp
  80237a:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  80237d:	ff 75 0c             	pushl  0xc(%ebp)
  802380:	e8 b6 f9 ff ff       	call   801d3b <strlen>
  802385:	83 c4 04             	add    $0x4,%esp
  802388:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  80238b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  802392:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  802399:	eb 17                	jmp    8023b2 <strcconcat+0x49>
		final[s] = str1[s] ;
  80239b:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80239e:	8b 45 10             	mov    0x10(%ebp),%eax
  8023a1:	01 c2                	add    %eax,%edx
  8023a3:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8023a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8023a9:	01 c8                	add    %ecx,%eax
  8023ab:	8a 00                	mov    (%eax),%al
  8023ad:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  8023af:	ff 45 fc             	incl   -0x4(%ebp)
  8023b2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8023b5:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8023b8:	7c e1                	jl     80239b <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  8023ba:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  8023c1:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8023c8:	eb 1f                	jmp    8023e9 <strcconcat+0x80>
		final[s++] = str2[i] ;
  8023ca:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8023cd:	8d 50 01             	lea    0x1(%eax),%edx
  8023d0:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8023d3:	89 c2                	mov    %eax,%edx
  8023d5:	8b 45 10             	mov    0x10(%ebp),%eax
  8023d8:	01 c2                	add    %eax,%edx
  8023da:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8023dd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8023e0:	01 c8                	add    %ecx,%eax
  8023e2:	8a 00                	mov    (%eax),%al
  8023e4:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  8023e6:	ff 45 f8             	incl   -0x8(%ebp)
  8023e9:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8023ec:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8023ef:	7c d9                	jl     8023ca <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  8023f1:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8023f4:	8b 45 10             	mov    0x10(%ebp),%eax
  8023f7:	01 d0                	add    %edx,%eax
  8023f9:	c6 00 00             	movb   $0x0,(%eax)
}
  8023fc:	90                   	nop
  8023fd:	c9                   	leave  
  8023fe:	c3                   	ret    

008023ff <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  8023ff:	55                   	push   %ebp
  802400:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  802402:	8b 45 14             	mov    0x14(%ebp),%eax
  802405:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  80240b:	8b 45 14             	mov    0x14(%ebp),%eax
  80240e:	8b 00                	mov    (%eax),%eax
  802410:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  802417:	8b 45 10             	mov    0x10(%ebp),%eax
  80241a:	01 d0                	add    %edx,%eax
  80241c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  802422:	eb 0c                	jmp    802430 <strsplit+0x31>
			*string++ = 0;
  802424:	8b 45 08             	mov    0x8(%ebp),%eax
  802427:	8d 50 01             	lea    0x1(%eax),%edx
  80242a:	89 55 08             	mov    %edx,0x8(%ebp)
  80242d:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  802430:	8b 45 08             	mov    0x8(%ebp),%eax
  802433:	8a 00                	mov    (%eax),%al
  802435:	84 c0                	test   %al,%al
  802437:	74 18                	je     802451 <strsplit+0x52>
  802439:	8b 45 08             	mov    0x8(%ebp),%eax
  80243c:	8a 00                	mov    (%eax),%al
  80243e:	0f be c0             	movsbl %al,%eax
  802441:	50                   	push   %eax
  802442:	ff 75 0c             	pushl  0xc(%ebp)
  802445:	e8 83 fa ff ff       	call   801ecd <strchr>
  80244a:	83 c4 08             	add    $0x8,%esp
  80244d:	85 c0                	test   %eax,%eax
  80244f:	75 d3                	jne    802424 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  802451:	8b 45 08             	mov    0x8(%ebp),%eax
  802454:	8a 00                	mov    (%eax),%al
  802456:	84 c0                	test   %al,%al
  802458:	74 5a                	je     8024b4 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  80245a:	8b 45 14             	mov    0x14(%ebp),%eax
  80245d:	8b 00                	mov    (%eax),%eax
  80245f:	83 f8 0f             	cmp    $0xf,%eax
  802462:	75 07                	jne    80246b <strsplit+0x6c>
		{
			return 0;
  802464:	b8 00 00 00 00       	mov    $0x0,%eax
  802469:	eb 66                	jmp    8024d1 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  80246b:	8b 45 14             	mov    0x14(%ebp),%eax
  80246e:	8b 00                	mov    (%eax),%eax
  802470:	8d 48 01             	lea    0x1(%eax),%ecx
  802473:	8b 55 14             	mov    0x14(%ebp),%edx
  802476:	89 0a                	mov    %ecx,(%edx)
  802478:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80247f:	8b 45 10             	mov    0x10(%ebp),%eax
  802482:	01 c2                	add    %eax,%edx
  802484:	8b 45 08             	mov    0x8(%ebp),%eax
  802487:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  802489:	eb 03                	jmp    80248e <strsplit+0x8f>
			string++;
  80248b:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  80248e:	8b 45 08             	mov    0x8(%ebp),%eax
  802491:	8a 00                	mov    (%eax),%al
  802493:	84 c0                	test   %al,%al
  802495:	74 8b                	je     802422 <strsplit+0x23>
  802497:	8b 45 08             	mov    0x8(%ebp),%eax
  80249a:	8a 00                	mov    (%eax),%al
  80249c:	0f be c0             	movsbl %al,%eax
  80249f:	50                   	push   %eax
  8024a0:	ff 75 0c             	pushl  0xc(%ebp)
  8024a3:	e8 25 fa ff ff       	call   801ecd <strchr>
  8024a8:	83 c4 08             	add    $0x8,%esp
  8024ab:	85 c0                	test   %eax,%eax
  8024ad:	74 dc                	je     80248b <strsplit+0x8c>
			string++;
	}
  8024af:	e9 6e ff ff ff       	jmp    802422 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  8024b4:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  8024b5:	8b 45 14             	mov    0x14(%ebp),%eax
  8024b8:	8b 00                	mov    (%eax),%eax
  8024ba:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8024c1:	8b 45 10             	mov    0x10(%ebp),%eax
  8024c4:	01 d0                	add    %edx,%eax
  8024c6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  8024cc:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8024d1:	c9                   	leave  
  8024d2:	c3                   	ret    

008024d3 <str2lower>:


char* str2lower(char *dst, const char *src)
{
  8024d3:	55                   	push   %ebp
  8024d4:	89 e5                	mov    %esp,%ebp
  8024d6:	83 ec 10             	sub    $0x10,%esp
	char* ret = dst;
  8024d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8024dc:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (int i = 0; i < strlen(src); ++i)
  8024df:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8024e6:	eb 4a                	jmp    802532 <str2lower+0x5f>
	{
		dst[i] = src[i] ;
  8024e8:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8024eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8024ee:	01 c2                	add    %eax,%edx
  8024f0:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8024f3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8024f6:	01 c8                	add    %ecx,%eax
  8024f8:	8a 00                	mov    (%eax),%al
  8024fa:	88 02                	mov    %al,(%edx)
		if (src[i] >= 'A' && src[i] <= 'Z')
  8024fc:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8024ff:	8b 45 0c             	mov    0xc(%ebp),%eax
  802502:	01 d0                	add    %edx,%eax
  802504:	8a 00                	mov    (%eax),%al
  802506:	3c 40                	cmp    $0x40,%al
  802508:	7e 25                	jle    80252f <str2lower+0x5c>
  80250a:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80250d:	8b 45 0c             	mov    0xc(%ebp),%eax
  802510:	01 d0                	add    %edx,%eax
  802512:	8a 00                	mov    (%eax),%al
  802514:	3c 5a                	cmp    $0x5a,%al
  802516:	7f 17                	jg     80252f <str2lower+0x5c>
		{
			dst[i] += 32 ;
  802518:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80251b:	8b 45 08             	mov    0x8(%ebp),%eax
  80251e:	01 d0                	add    %edx,%eax
  802520:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  802523:	8b 55 08             	mov    0x8(%ebp),%edx
  802526:	01 ca                	add    %ecx,%edx
  802528:	8a 12                	mov    (%edx),%dl
  80252a:	83 c2 20             	add    $0x20,%edx
  80252d:	88 10                	mov    %dl,(%eax)


char* str2lower(char *dst, const char *src)
{
	char* ret = dst;
	for (int i = 0; i < strlen(src); ++i)
  80252f:	ff 45 fc             	incl   -0x4(%ebp)
  802532:	ff 75 0c             	pushl  0xc(%ebp)
  802535:	e8 01 f8 ff ff       	call   801d3b <strlen>
  80253a:	83 c4 04             	add    $0x4,%esp
  80253d:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  802540:	7f a6                	jg     8024e8 <str2lower+0x15>
		if (src[i] >= 'A' && src[i] <= 'Z')
		{
			dst[i] += 32 ;
		}
	}
	return ret;
  802542:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  802545:	c9                   	leave  
  802546:	c3                   	ret    

00802547 <uheap_init>:
//==============================================
// [1] INITIALIZE USER HEAP:
//==============================================
int __firstTimeFlag = 1;
void uheap_init()
{
  802547:	55                   	push   %ebp
  802548:	89 e5                	mov    %esp,%ebp
  80254a:	83 ec 08             	sub    $0x8,%esp
	if(__firstTimeFlag)
  80254d:	a1 08 50 80 00       	mov    0x805008,%eax
  802552:	85 c0                	test   %eax,%eax
  802554:	74 42                	je     802598 <uheap_init+0x51>
	{
		initialize_dynamic_allocator(USER_HEAP_START, USER_HEAP_START + DYN_ALLOC_MAX_SIZE);
  802556:	83 ec 08             	sub    $0x8,%esp
  802559:	68 00 00 00 82       	push   $0x82000000
  80255e:	68 00 00 00 80       	push   $0x80000000
  802563:	e8 00 08 00 00       	call   802d68 <initialize_dynamic_allocator>
  802568:	83 c4 10             	add    $0x10,%esp
		uheapPlaceStrategy = sys_get_uheap_strategy();
  80256b:	e8 e7 05 00 00       	call   802b57 <sys_get_uheap_strategy>
  802570:	a3 60 d0 81 00       	mov    %eax,0x81d060
		uheapPageAllocStart = dynAllocEnd + PAGE_SIZE;
  802575:	a1 40 50 80 00       	mov    0x805040,%eax
  80257a:	05 00 10 00 00       	add    $0x1000,%eax
  80257f:	a3 10 d1 81 00       	mov    %eax,0x81d110
		uheapPageAllocBreak = uheapPageAllocStart;
  802584:	a1 10 d1 81 00       	mov    0x81d110,%eax
  802589:	a3 68 d0 81 00       	mov    %eax,0x81d068

		__firstTimeFlag = 0;
  80258e:	c7 05 08 50 80 00 00 	movl   $0x0,0x805008
  802595:	00 00 00 
	}
}
  802598:	90                   	nop
  802599:	c9                   	leave  
  80259a:	c3                   	ret    

0080259b <get_page>:

//==============================================
// [2] GET A PAGE FROM THE KERNEL FOR DA:
//==============================================
int get_page(void* va)
{
  80259b:	55                   	push   %ebp
  80259c:	89 e5                	mov    %esp,%ebp
  80259e:	83 ec 18             	sub    $0x18,%esp
	int ret = __sys_allocate_page(ROUNDDOWN(va, PAGE_SIZE), PERM_USER|PERM_WRITEABLE|PERM_UHPAGE);
  8025a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8025a4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8025a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025aa:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8025af:	83 ec 08             	sub    $0x8,%esp
  8025b2:	68 06 04 00 00       	push   $0x406
  8025b7:	50                   	push   %eax
  8025b8:	e8 e4 01 00 00       	call   8027a1 <__sys_allocate_page>
  8025bd:	83 c4 10             	add    $0x10,%esp
  8025c0:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (ret < 0)
  8025c3:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8025c7:	79 14                	jns    8025dd <get_page+0x42>
		panic("get_page() in user: failed to allocate page from the kernel");
  8025c9:	83 ec 04             	sub    $0x4,%esp
  8025cc:	68 3c 48 80 00       	push   $0x80483c
  8025d1:	6a 1f                	push   $0x1f
  8025d3:	68 78 48 80 00       	push   $0x804878
  8025d8:	e8 af eb ff ff       	call   80118c <_panic>
	return 0;
  8025dd:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8025e2:	c9                   	leave  
  8025e3:	c3                   	ret    

008025e4 <return_page>:

//==============================================
// [3] RETURN A PAGE FROM THE DA TO KERNEL:
//==============================================
void return_page(void* va)
{
  8025e4:	55                   	push   %ebp
  8025e5:	89 e5                	mov    %esp,%ebp
  8025e7:	83 ec 18             	sub    $0x18,%esp
	int ret = __sys_unmap_frame(ROUNDDOWN((uint32)va, PAGE_SIZE));
  8025ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8025ed:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8025f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025f3:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8025f8:	83 ec 0c             	sub    $0xc,%esp
  8025fb:	50                   	push   %eax
  8025fc:	e8 e7 01 00 00       	call   8027e8 <__sys_unmap_frame>
  802601:	83 c4 10             	add    $0x10,%esp
  802604:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (ret < 0)
  802607:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80260b:	79 14                	jns    802621 <return_page+0x3d>
		panic("return_page() in user: failed to return a page to the kernel");
  80260d:	83 ec 04             	sub    $0x4,%esp
  802610:	68 84 48 80 00       	push   $0x804884
  802615:	6a 2a                	push   $0x2a
  802617:	68 78 48 80 00       	push   $0x804878
  80261c:	e8 6b eb ff ff       	call   80118c <_panic>
}
  802621:	90                   	nop
  802622:	c9                   	leave  
  802623:	c3                   	ret    

00802624 <malloc>:

//=================================
// [1] ALLOCATE SPACE IN USER HEAP:
//=================================
void* malloc(uint32 size)
{
  802624:	55                   	push   %ebp
  802625:	89 e5                	mov    %esp,%ebp
  802627:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  80262a:	e8 18 ff ff ff       	call   802547 <uheap_init>
	if (size == 0) return NULL ;
  80262f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802633:	75 07                	jne    80263c <malloc+0x18>
  802635:	b8 00 00 00 00       	mov    $0x0,%eax
  80263a:	eb 14                	jmp    802650 <malloc+0x2c>
	//==============================================================
	//TODO: [PROJECT'25.IM#2] USER HEAP - #1 malloc
	//Your code is here
	//Comment the following line
	panic("malloc() is not implemented yet...!!");
  80263c:	83 ec 04             	sub    $0x4,%esp
  80263f:	68 c4 48 80 00       	push   $0x8048c4
  802644:	6a 3e                	push   $0x3e
  802646:	68 78 48 80 00       	push   $0x804878
  80264b:	e8 3c eb ff ff       	call   80118c <_panic>
}
  802650:	c9                   	leave  
  802651:	c3                   	ret    

00802652 <free>:

//=================================
// [2] FREE SPACE FROM USER HEAP:
//=================================
void free(void* virtual_address)
{
  802652:	55                   	push   %ebp
  802653:	89 e5                	mov    %esp,%ebp
  802655:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.IM#2] USER HEAP - #3 free
	//Your code is here
	//Comment the following line
	panic("free() is not implemented yet...!!");
  802658:	83 ec 04             	sub    $0x4,%esp
  80265b:	68 ec 48 80 00       	push   $0x8048ec
  802660:	6a 49                	push   $0x49
  802662:	68 78 48 80 00       	push   $0x804878
  802667:	e8 20 eb ff ff       	call   80118c <_panic>

0080266c <smalloc>:

//=================================
// [3] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  80266c:	55                   	push   %ebp
  80266d:	89 e5                	mov    %esp,%ebp
  80266f:	83 ec 18             	sub    $0x18,%esp
  802672:	8b 45 10             	mov    0x10(%ebp),%eax
  802675:	88 45 f4             	mov    %al,-0xc(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  802678:	e8 ca fe ff ff       	call   802547 <uheap_init>
	if (size == 0) return NULL ;
  80267d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802681:	75 07                	jne    80268a <smalloc+0x1e>
  802683:	b8 00 00 00 00       	mov    $0x0,%eax
  802688:	eb 14                	jmp    80269e <smalloc+0x32>
	//==============================================================

	//TODO: [PROJECT'25.IM#3] SHARED MEMORY - #2 smalloc
	//Your code is here
	//Comment the following line
	panic("smalloc() is not implemented yet...!!");
  80268a:	83 ec 04             	sub    $0x4,%esp
  80268d:	68 10 49 80 00       	push   $0x804910
  802692:	6a 5a                	push   $0x5a
  802694:	68 78 48 80 00       	push   $0x804878
  802699:	e8 ee ea ff ff       	call   80118c <_panic>
}
  80269e:	c9                   	leave  
  80269f:	c3                   	ret    

008026a0 <sget>:

//========================================
// [4] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  8026a0:	55                   	push   %ebp
  8026a1:	89 e5                	mov    %esp,%ebp
  8026a3:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  8026a6:	e8 9c fe ff ff       	call   802547 <uheap_init>
	//==============================================================

	//TODO: [PROJECT'25.IM#3] SHARED MEMORY - #4 sget
	//Your code is here
	//Comment the following line
	panic("sget() is not implemented yet...!!");
  8026ab:	83 ec 04             	sub    $0x4,%esp
  8026ae:	68 38 49 80 00       	push   $0x804938
  8026b3:	6a 6a                	push   $0x6a
  8026b5:	68 78 48 80 00       	push   $0x804878
  8026ba:	e8 cd ea ff ff       	call   80118c <_panic>

008026bf <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  8026bf:	55                   	push   %ebp
  8026c0:	89 e5                	mov    %esp,%ebp
  8026c2:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  8026c5:	e8 7d fe ff ff       	call   802547 <uheap_init>
	//==============================================================
	panic("realloc() is not implemented yet...!!");
  8026ca:	83 ec 04             	sub    $0x4,%esp
  8026cd:	68 5c 49 80 00       	push   $0x80495c
  8026d2:	68 88 00 00 00       	push   $0x88
  8026d7:	68 78 48 80 00       	push   $0x804878
  8026dc:	e8 ab ea ff ff       	call   80118c <_panic>

008026e1 <sfree>:
//
//	use sys_delete_shared_object(...); which switches to the kernel mode,
//	calls delete_shared_object(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the delete_shared_object() function is empty, make sure to implement it.
void sfree(void* virtual_address)
{
  8026e1:	55                   	push   %ebp
  8026e2:	89 e5                	mov    %esp,%ebp
  8026e4:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.BONUS#5] EXIT #2 - sfree
	//Your code is here
	//Comment the following line
	panic("sfree() is not implemented yet...!!");
  8026e7:	83 ec 04             	sub    $0x4,%esp
  8026ea:	68 84 49 80 00       	push   $0x804984
  8026ef:	68 9b 00 00 00       	push   $0x9b
  8026f4:	68 78 48 80 00       	push   $0x804878
  8026f9:	e8 8e ea ff ff       	call   80118c <_panic>

008026fe <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  8026fe:	55                   	push   %ebp
  8026ff:	89 e5                	mov    %esp,%ebp
  802701:	57                   	push   %edi
  802702:	56                   	push   %esi
  802703:	53                   	push   %ebx
  802704:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  802707:	8b 45 08             	mov    0x8(%ebp),%eax
  80270a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80270d:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802710:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802713:	8b 7d 18             	mov    0x18(%ebp),%edi
  802716:	8b 75 1c             	mov    0x1c(%ebp),%esi
  802719:	cd 30                	int    $0x30
  80271b:	89 45 f0             	mov    %eax,-0x10(%ebp)
				"b" (a3),
				"D" (a4),
				"S" (a5)
				: "cc", "memory");

	return ret;
  80271e:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  802721:	83 c4 10             	add    $0x10,%esp
  802724:	5b                   	pop    %ebx
  802725:	5e                   	pop    %esi
  802726:	5f                   	pop    %edi
  802727:	5d                   	pop    %ebp
  802728:	c3                   	ret    

00802729 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName, int color)
{
  802729:	55                   	push   %ebp
  80272a:	89 e5                	mov    %esp,%ebp
  80272c:	83 ec 04             	sub    $0x4,%esp
  80272f:	8b 45 10             	mov    0x10(%ebp),%eax
  802732:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, color, 0);
  802735:	8b 4d 14             	mov    0x14(%ebp),%ecx
  802738:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80273c:	8b 45 08             	mov    0x8(%ebp),%eax
  80273f:	6a 00                	push   $0x0
  802741:	51                   	push   %ecx
  802742:	52                   	push   %edx
  802743:	ff 75 0c             	pushl  0xc(%ebp)
  802746:	50                   	push   %eax
  802747:	6a 00                	push   $0x0
  802749:	e8 b0 ff ff ff       	call   8026fe <syscall>
  80274e:	83 c4 18             	add    $0x18,%esp
}
  802751:	90                   	nop
  802752:	c9                   	leave  
  802753:	c3                   	ret    

00802754 <sys_cgetc>:

int
sys_cgetc(void)
{
  802754:	55                   	push   %ebp
  802755:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  802757:	6a 00                	push   $0x0
  802759:	6a 00                	push   $0x0
  80275b:	6a 00                	push   $0x0
  80275d:	6a 00                	push   $0x0
  80275f:	6a 00                	push   $0x0
  802761:	6a 02                	push   $0x2
  802763:	e8 96 ff ff ff       	call   8026fe <syscall>
  802768:	83 c4 18             	add    $0x18,%esp
}
  80276b:	c9                   	leave  
  80276c:	c3                   	ret    

0080276d <sys_lock_cons>:

void sys_lock_cons(void)
{
  80276d:	55                   	push   %ebp
  80276e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  802770:	6a 00                	push   $0x0
  802772:	6a 00                	push   $0x0
  802774:	6a 00                	push   $0x0
  802776:	6a 00                	push   $0x0
  802778:	6a 00                	push   $0x0
  80277a:	6a 03                	push   $0x3
  80277c:	e8 7d ff ff ff       	call   8026fe <syscall>
  802781:	83 c4 18             	add    $0x18,%esp
}
  802784:	90                   	nop
  802785:	c9                   	leave  
  802786:	c3                   	ret    

00802787 <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  802787:	55                   	push   %ebp
  802788:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  80278a:	6a 00                	push   $0x0
  80278c:	6a 00                	push   $0x0
  80278e:	6a 00                	push   $0x0
  802790:	6a 00                	push   $0x0
  802792:	6a 00                	push   $0x0
  802794:	6a 04                	push   $0x4
  802796:	e8 63 ff ff ff       	call   8026fe <syscall>
  80279b:	83 c4 18             	add    $0x18,%esp
}
  80279e:	90                   	nop
  80279f:	c9                   	leave  
  8027a0:	c3                   	ret    

008027a1 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  8027a1:	55                   	push   %ebp
  8027a2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  8027a4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8027a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8027aa:	6a 00                	push   $0x0
  8027ac:	6a 00                	push   $0x0
  8027ae:	6a 00                	push   $0x0
  8027b0:	52                   	push   %edx
  8027b1:	50                   	push   %eax
  8027b2:	6a 08                	push   $0x8
  8027b4:	e8 45 ff ff ff       	call   8026fe <syscall>
  8027b9:	83 c4 18             	add    $0x18,%esp
}
  8027bc:	c9                   	leave  
  8027bd:	c3                   	ret    

008027be <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  8027be:	55                   	push   %ebp
  8027bf:	89 e5                	mov    %esp,%ebp
  8027c1:	56                   	push   %esi
  8027c2:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  8027c3:	8b 75 18             	mov    0x18(%ebp),%esi
  8027c6:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8027c9:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8027cc:	8b 55 0c             	mov    0xc(%ebp),%edx
  8027cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8027d2:	56                   	push   %esi
  8027d3:	53                   	push   %ebx
  8027d4:	51                   	push   %ecx
  8027d5:	52                   	push   %edx
  8027d6:	50                   	push   %eax
  8027d7:	6a 09                	push   $0x9
  8027d9:	e8 20 ff ff ff       	call   8026fe <syscall>
  8027de:	83 c4 18             	add    $0x18,%esp
}
  8027e1:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8027e4:	5b                   	pop    %ebx
  8027e5:	5e                   	pop    %esi
  8027e6:	5d                   	pop    %ebp
  8027e7:	c3                   	ret    

008027e8 <__sys_unmap_frame>:

int __sys_unmap_frame(uint32 va)
{
  8027e8:	55                   	push   %ebp
  8027e9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, va, 0, 0, 0, 0);
  8027eb:	6a 00                	push   $0x0
  8027ed:	6a 00                	push   $0x0
  8027ef:	6a 00                	push   $0x0
  8027f1:	6a 00                	push   $0x0
  8027f3:	ff 75 08             	pushl  0x8(%ebp)
  8027f6:	6a 0a                	push   $0xa
  8027f8:	e8 01 ff ff ff       	call   8026fe <syscall>
  8027fd:	83 c4 18             	add    $0x18,%esp
}
  802800:	c9                   	leave  
  802801:	c3                   	ret    

00802802 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  802802:	55                   	push   %ebp
  802803:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  802805:	6a 00                	push   $0x0
  802807:	6a 00                	push   $0x0
  802809:	6a 00                	push   $0x0
  80280b:	ff 75 0c             	pushl  0xc(%ebp)
  80280e:	ff 75 08             	pushl  0x8(%ebp)
  802811:	6a 0b                	push   $0xb
  802813:	e8 e6 fe ff ff       	call   8026fe <syscall>
  802818:	83 c4 18             	add    $0x18,%esp
}
  80281b:	c9                   	leave  
  80281c:	c3                   	ret    

0080281d <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  80281d:	55                   	push   %ebp
  80281e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  802820:	6a 00                	push   $0x0
  802822:	6a 00                	push   $0x0
  802824:	6a 00                	push   $0x0
  802826:	6a 00                	push   $0x0
  802828:	6a 00                	push   $0x0
  80282a:	6a 0c                	push   $0xc
  80282c:	e8 cd fe ff ff       	call   8026fe <syscall>
  802831:	83 c4 18             	add    $0x18,%esp
}
  802834:	c9                   	leave  
  802835:	c3                   	ret    

00802836 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  802836:	55                   	push   %ebp
  802837:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  802839:	6a 00                	push   $0x0
  80283b:	6a 00                	push   $0x0
  80283d:	6a 00                	push   $0x0
  80283f:	6a 00                	push   $0x0
  802841:	6a 00                	push   $0x0
  802843:	6a 0d                	push   $0xd
  802845:	e8 b4 fe ff ff       	call   8026fe <syscall>
  80284a:	83 c4 18             	add    $0x18,%esp
}
  80284d:	c9                   	leave  
  80284e:	c3                   	ret    

0080284f <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  80284f:	55                   	push   %ebp
  802850:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  802852:	6a 00                	push   $0x0
  802854:	6a 00                	push   $0x0
  802856:	6a 00                	push   $0x0
  802858:	6a 00                	push   $0x0
  80285a:	6a 00                	push   $0x0
  80285c:	6a 0e                	push   $0xe
  80285e:	e8 9b fe ff ff       	call   8026fe <syscall>
  802863:	83 c4 18             	add    $0x18,%esp
}
  802866:	c9                   	leave  
  802867:	c3                   	ret    

00802868 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  802868:	55                   	push   %ebp
  802869:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  80286b:	6a 00                	push   $0x0
  80286d:	6a 00                	push   $0x0
  80286f:	6a 00                	push   $0x0
  802871:	6a 00                	push   $0x0
  802873:	6a 00                	push   $0x0
  802875:	6a 0f                	push   $0xf
  802877:	e8 82 fe ff ff       	call   8026fe <syscall>
  80287c:	83 c4 18             	add    $0x18,%esp
}
  80287f:	c9                   	leave  
  802880:	c3                   	ret    

00802881 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  802881:	55                   	push   %ebp
  802882:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  802884:	6a 00                	push   $0x0
  802886:	6a 00                	push   $0x0
  802888:	6a 00                	push   $0x0
  80288a:	6a 00                	push   $0x0
  80288c:	ff 75 08             	pushl  0x8(%ebp)
  80288f:	6a 10                	push   $0x10
  802891:	e8 68 fe ff ff       	call   8026fe <syscall>
  802896:	83 c4 18             	add    $0x18,%esp
}
  802899:	c9                   	leave  
  80289a:	c3                   	ret    

0080289b <sys_scarce_memory>:

void sys_scarce_memory()
{
  80289b:	55                   	push   %ebp
  80289c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  80289e:	6a 00                	push   $0x0
  8028a0:	6a 00                	push   $0x0
  8028a2:	6a 00                	push   $0x0
  8028a4:	6a 00                	push   $0x0
  8028a6:	6a 00                	push   $0x0
  8028a8:	6a 11                	push   $0x11
  8028aa:	e8 4f fe ff ff       	call   8026fe <syscall>
  8028af:	83 c4 18             	add    $0x18,%esp
}
  8028b2:	90                   	nop
  8028b3:	c9                   	leave  
  8028b4:	c3                   	ret    

008028b5 <sys_cputc>:

void
sys_cputc(const char c)
{
  8028b5:	55                   	push   %ebp
  8028b6:	89 e5                	mov    %esp,%ebp
  8028b8:	83 ec 04             	sub    $0x4,%esp
  8028bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8028be:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  8028c1:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8028c5:	6a 00                	push   $0x0
  8028c7:	6a 00                	push   $0x0
  8028c9:	6a 00                	push   $0x0
  8028cb:	6a 00                	push   $0x0
  8028cd:	50                   	push   %eax
  8028ce:	6a 01                	push   $0x1
  8028d0:	e8 29 fe ff ff       	call   8026fe <syscall>
  8028d5:	83 c4 18             	add    $0x18,%esp
}
  8028d8:	90                   	nop
  8028d9:	c9                   	leave  
  8028da:	c3                   	ret    

008028db <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  8028db:	55                   	push   %ebp
  8028dc:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  8028de:	6a 00                	push   $0x0
  8028e0:	6a 00                	push   $0x0
  8028e2:	6a 00                	push   $0x0
  8028e4:	6a 00                	push   $0x0
  8028e6:	6a 00                	push   $0x0
  8028e8:	6a 14                	push   $0x14
  8028ea:	e8 0f fe ff ff       	call   8026fe <syscall>
  8028ef:	83 c4 18             	add    $0x18,%esp
}
  8028f2:	90                   	nop
  8028f3:	c9                   	leave  
  8028f4:	c3                   	ret    

008028f5 <sys_create_shared_object>:

int sys_create_shared_object(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  8028f5:	55                   	push   %ebp
  8028f6:	89 e5                	mov    %esp,%ebp
  8028f8:	83 ec 04             	sub    $0x4,%esp
  8028fb:	8b 45 10             	mov    0x10(%ebp),%eax
  8028fe:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  802901:	8b 4d 14             	mov    0x14(%ebp),%ecx
  802904:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  802908:	8b 45 08             	mov    0x8(%ebp),%eax
  80290b:	6a 00                	push   $0x0
  80290d:	51                   	push   %ecx
  80290e:	52                   	push   %edx
  80290f:	ff 75 0c             	pushl  0xc(%ebp)
  802912:	50                   	push   %eax
  802913:	6a 15                	push   $0x15
  802915:	e8 e4 fd ff ff       	call   8026fe <syscall>
  80291a:	83 c4 18             	add    $0x18,%esp
}
  80291d:	c9                   	leave  
  80291e:	c3                   	ret    

0080291f <sys_size_of_shared_object>:

//2017:
int sys_size_of_shared_object(int32 ownerID, char* shareName)
{
  80291f:	55                   	push   %ebp
  802920:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  802922:	8b 55 0c             	mov    0xc(%ebp),%edx
  802925:	8b 45 08             	mov    0x8(%ebp),%eax
  802928:	6a 00                	push   $0x0
  80292a:	6a 00                	push   $0x0
  80292c:	6a 00                	push   $0x0
  80292e:	52                   	push   %edx
  80292f:	50                   	push   %eax
  802930:	6a 16                	push   $0x16
  802932:	e8 c7 fd ff ff       	call   8026fe <syscall>
  802937:	83 c4 18             	add    $0x18,%esp
}
  80293a:	c9                   	leave  
  80293b:	c3                   	ret    

0080293c <sys_get_shared_object>:
//==========

int sys_get_shared_object(int32 ownerID, char* shareName, void* virtual_address)
{
  80293c:	55                   	push   %ebp
  80293d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  80293f:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802942:	8b 55 0c             	mov    0xc(%ebp),%edx
  802945:	8b 45 08             	mov    0x8(%ebp),%eax
  802948:	6a 00                	push   $0x0
  80294a:	6a 00                	push   $0x0
  80294c:	51                   	push   %ecx
  80294d:	52                   	push   %edx
  80294e:	50                   	push   %eax
  80294f:	6a 17                	push   $0x17
  802951:	e8 a8 fd ff ff       	call   8026fe <syscall>
  802956:	83 c4 18             	add    $0x18,%esp
}
  802959:	c9                   	leave  
  80295a:	c3                   	ret    

0080295b <sys_delete_shared_object>:

int sys_delete_shared_object(int32 sharedObjectID, void *startVA)
{
  80295b:	55                   	push   %ebp
  80295c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  80295e:	8b 55 0c             	mov    0xc(%ebp),%edx
  802961:	8b 45 08             	mov    0x8(%ebp),%eax
  802964:	6a 00                	push   $0x0
  802966:	6a 00                	push   $0x0
  802968:	6a 00                	push   $0x0
  80296a:	52                   	push   %edx
  80296b:	50                   	push   %eax
  80296c:	6a 18                	push   $0x18
  80296e:	e8 8b fd ff ff       	call   8026fe <syscall>
  802973:	83 c4 18             	add    $0x18,%esp
}
  802976:	c9                   	leave  
  802977:	c3                   	ret    

00802978 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  802978:	55                   	push   %ebp
  802979:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  80297b:	8b 45 08             	mov    0x8(%ebp),%eax
  80297e:	6a 00                	push   $0x0
  802980:	ff 75 14             	pushl  0x14(%ebp)
  802983:	ff 75 10             	pushl  0x10(%ebp)
  802986:	ff 75 0c             	pushl  0xc(%ebp)
  802989:	50                   	push   %eax
  80298a:	6a 19                	push   $0x19
  80298c:	e8 6d fd ff ff       	call   8026fe <syscall>
  802991:	83 c4 18             	add    $0x18,%esp
}
  802994:	c9                   	leave  
  802995:	c3                   	ret    

00802996 <sys_run_env>:

void sys_run_env(int32 envId)
{
  802996:	55                   	push   %ebp
  802997:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  802999:	8b 45 08             	mov    0x8(%ebp),%eax
  80299c:	6a 00                	push   $0x0
  80299e:	6a 00                	push   $0x0
  8029a0:	6a 00                	push   $0x0
  8029a2:	6a 00                	push   $0x0
  8029a4:	50                   	push   %eax
  8029a5:	6a 1a                	push   $0x1a
  8029a7:	e8 52 fd ff ff       	call   8026fe <syscall>
  8029ac:	83 c4 18             	add    $0x18,%esp
}
  8029af:	90                   	nop
  8029b0:	c9                   	leave  
  8029b1:	c3                   	ret    

008029b2 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  8029b2:	55                   	push   %ebp
  8029b3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  8029b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8029b8:	6a 00                	push   $0x0
  8029ba:	6a 00                	push   $0x0
  8029bc:	6a 00                	push   $0x0
  8029be:	6a 00                	push   $0x0
  8029c0:	50                   	push   %eax
  8029c1:	6a 1b                	push   $0x1b
  8029c3:	e8 36 fd ff ff       	call   8026fe <syscall>
  8029c8:	83 c4 18             	add    $0x18,%esp
}
  8029cb:	c9                   	leave  
  8029cc:	c3                   	ret    

008029cd <sys_getenvid>:

int32 sys_getenvid(void)
{
  8029cd:	55                   	push   %ebp
  8029ce:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  8029d0:	6a 00                	push   $0x0
  8029d2:	6a 00                	push   $0x0
  8029d4:	6a 00                	push   $0x0
  8029d6:	6a 00                	push   $0x0
  8029d8:	6a 00                	push   $0x0
  8029da:	6a 05                	push   $0x5
  8029dc:	e8 1d fd ff ff       	call   8026fe <syscall>
  8029e1:	83 c4 18             	add    $0x18,%esp
}
  8029e4:	c9                   	leave  
  8029e5:	c3                   	ret    

008029e6 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  8029e6:	55                   	push   %ebp
  8029e7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  8029e9:	6a 00                	push   $0x0
  8029eb:	6a 00                	push   $0x0
  8029ed:	6a 00                	push   $0x0
  8029ef:	6a 00                	push   $0x0
  8029f1:	6a 00                	push   $0x0
  8029f3:	6a 06                	push   $0x6
  8029f5:	e8 04 fd ff ff       	call   8026fe <syscall>
  8029fa:	83 c4 18             	add    $0x18,%esp
}
  8029fd:	c9                   	leave  
  8029fe:	c3                   	ret    

008029ff <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  8029ff:	55                   	push   %ebp
  802a00:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  802a02:	6a 00                	push   $0x0
  802a04:	6a 00                	push   $0x0
  802a06:	6a 00                	push   $0x0
  802a08:	6a 00                	push   $0x0
  802a0a:	6a 00                	push   $0x0
  802a0c:	6a 07                	push   $0x7
  802a0e:	e8 eb fc ff ff       	call   8026fe <syscall>
  802a13:	83 c4 18             	add    $0x18,%esp
}
  802a16:	c9                   	leave  
  802a17:	c3                   	ret    

00802a18 <sys_exit_env>:


void sys_exit_env(void)
{
  802a18:	55                   	push   %ebp
  802a19:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  802a1b:	6a 00                	push   $0x0
  802a1d:	6a 00                	push   $0x0
  802a1f:	6a 00                	push   $0x0
  802a21:	6a 00                	push   $0x0
  802a23:	6a 00                	push   $0x0
  802a25:	6a 1c                	push   $0x1c
  802a27:	e8 d2 fc ff ff       	call   8026fe <syscall>
  802a2c:	83 c4 18             	add    $0x18,%esp
}
  802a2f:	90                   	nop
  802a30:	c9                   	leave  
  802a31:	c3                   	ret    

00802a32 <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  802a32:	55                   	push   %ebp
  802a33:	89 e5                	mov    %esp,%ebp
  802a35:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  802a38:	8d 45 f8             	lea    -0x8(%ebp),%eax
  802a3b:	8d 50 04             	lea    0x4(%eax),%edx
  802a3e:	8d 45 f8             	lea    -0x8(%ebp),%eax
  802a41:	6a 00                	push   $0x0
  802a43:	6a 00                	push   $0x0
  802a45:	6a 00                	push   $0x0
  802a47:	52                   	push   %edx
  802a48:	50                   	push   %eax
  802a49:	6a 1d                	push   $0x1d
  802a4b:	e8 ae fc ff ff       	call   8026fe <syscall>
  802a50:	83 c4 18             	add    $0x18,%esp
	return result;
  802a53:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802a56:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802a59:	8b 55 fc             	mov    -0x4(%ebp),%edx
  802a5c:	89 01                	mov    %eax,(%ecx)
  802a5e:	89 51 04             	mov    %edx,0x4(%ecx)
}
  802a61:	8b 45 08             	mov    0x8(%ebp),%eax
  802a64:	c9                   	leave  
  802a65:	c2 04 00             	ret    $0x4

00802a68 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  802a68:	55                   	push   %ebp
  802a69:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  802a6b:	6a 00                	push   $0x0
  802a6d:	6a 00                	push   $0x0
  802a6f:	ff 75 10             	pushl  0x10(%ebp)
  802a72:	ff 75 0c             	pushl  0xc(%ebp)
  802a75:	ff 75 08             	pushl  0x8(%ebp)
  802a78:	6a 13                	push   $0x13
  802a7a:	e8 7f fc ff ff       	call   8026fe <syscall>
  802a7f:	83 c4 18             	add    $0x18,%esp
	return ;
  802a82:	90                   	nop
}
  802a83:	c9                   	leave  
  802a84:	c3                   	ret    

00802a85 <sys_rcr2>:
uint32 sys_rcr2()
{
  802a85:	55                   	push   %ebp
  802a86:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  802a88:	6a 00                	push   $0x0
  802a8a:	6a 00                	push   $0x0
  802a8c:	6a 00                	push   $0x0
  802a8e:	6a 00                	push   $0x0
  802a90:	6a 00                	push   $0x0
  802a92:	6a 1e                	push   $0x1e
  802a94:	e8 65 fc ff ff       	call   8026fe <syscall>
  802a99:	83 c4 18             	add    $0x18,%esp
}
  802a9c:	c9                   	leave  
  802a9d:	c3                   	ret    

00802a9e <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  802a9e:	55                   	push   %ebp
  802a9f:	89 e5                	mov    %esp,%ebp
  802aa1:	83 ec 04             	sub    $0x4,%esp
  802aa4:	8b 45 08             	mov    0x8(%ebp),%eax
  802aa7:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  802aaa:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  802aae:	6a 00                	push   $0x0
  802ab0:	6a 00                	push   $0x0
  802ab2:	6a 00                	push   $0x0
  802ab4:	6a 00                	push   $0x0
  802ab6:	50                   	push   %eax
  802ab7:	6a 1f                	push   $0x1f
  802ab9:	e8 40 fc ff ff       	call   8026fe <syscall>
  802abe:	83 c4 18             	add    $0x18,%esp
	return ;
  802ac1:	90                   	nop
}
  802ac2:	c9                   	leave  
  802ac3:	c3                   	ret    

00802ac4 <rsttst>:
void rsttst()
{
  802ac4:	55                   	push   %ebp
  802ac5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  802ac7:	6a 00                	push   $0x0
  802ac9:	6a 00                	push   $0x0
  802acb:	6a 00                	push   $0x0
  802acd:	6a 00                	push   $0x0
  802acf:	6a 00                	push   $0x0
  802ad1:	6a 21                	push   $0x21
  802ad3:	e8 26 fc ff ff       	call   8026fe <syscall>
  802ad8:	83 c4 18             	add    $0x18,%esp
	return ;
  802adb:	90                   	nop
}
  802adc:	c9                   	leave  
  802add:	c3                   	ret    

00802ade <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  802ade:	55                   	push   %ebp
  802adf:	89 e5                	mov    %esp,%ebp
  802ae1:	83 ec 04             	sub    $0x4,%esp
  802ae4:	8b 45 14             	mov    0x14(%ebp),%eax
  802ae7:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  802aea:	8b 55 18             	mov    0x18(%ebp),%edx
  802aed:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  802af1:	52                   	push   %edx
  802af2:	50                   	push   %eax
  802af3:	ff 75 10             	pushl  0x10(%ebp)
  802af6:	ff 75 0c             	pushl  0xc(%ebp)
  802af9:	ff 75 08             	pushl  0x8(%ebp)
  802afc:	6a 20                	push   $0x20
  802afe:	e8 fb fb ff ff       	call   8026fe <syscall>
  802b03:	83 c4 18             	add    $0x18,%esp
	return ;
  802b06:	90                   	nop
}
  802b07:	c9                   	leave  
  802b08:	c3                   	ret    

00802b09 <chktst>:
void chktst(uint32 n)
{
  802b09:	55                   	push   %ebp
  802b0a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  802b0c:	6a 00                	push   $0x0
  802b0e:	6a 00                	push   $0x0
  802b10:	6a 00                	push   $0x0
  802b12:	6a 00                	push   $0x0
  802b14:	ff 75 08             	pushl  0x8(%ebp)
  802b17:	6a 22                	push   $0x22
  802b19:	e8 e0 fb ff ff       	call   8026fe <syscall>
  802b1e:	83 c4 18             	add    $0x18,%esp
	return ;
  802b21:	90                   	nop
}
  802b22:	c9                   	leave  
  802b23:	c3                   	ret    

00802b24 <inctst>:

void inctst()
{
  802b24:	55                   	push   %ebp
  802b25:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  802b27:	6a 00                	push   $0x0
  802b29:	6a 00                	push   $0x0
  802b2b:	6a 00                	push   $0x0
  802b2d:	6a 00                	push   $0x0
  802b2f:	6a 00                	push   $0x0
  802b31:	6a 23                	push   $0x23
  802b33:	e8 c6 fb ff ff       	call   8026fe <syscall>
  802b38:	83 c4 18             	add    $0x18,%esp
	return ;
  802b3b:	90                   	nop
}
  802b3c:	c9                   	leave  
  802b3d:	c3                   	ret    

00802b3e <gettst>:
uint32 gettst()
{
  802b3e:	55                   	push   %ebp
  802b3f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  802b41:	6a 00                	push   $0x0
  802b43:	6a 00                	push   $0x0
  802b45:	6a 00                	push   $0x0
  802b47:	6a 00                	push   $0x0
  802b49:	6a 00                	push   $0x0
  802b4b:	6a 24                	push   $0x24
  802b4d:	e8 ac fb ff ff       	call   8026fe <syscall>
  802b52:	83 c4 18             	add    $0x18,%esp
}
  802b55:	c9                   	leave  
  802b56:	c3                   	ret    

00802b57 <sys_get_uheap_strategy>:

/*2025*/
uint32 sys_get_uheap_strategy()
{
  802b57:	55                   	push   %ebp
  802b58:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802b5a:	6a 00                	push   $0x0
  802b5c:	6a 00                	push   $0x0
  802b5e:	6a 00                	push   $0x0
  802b60:	6a 00                	push   $0x0
  802b62:	6a 00                	push   $0x0
  802b64:	6a 25                	push   $0x25
  802b66:	e8 93 fb ff ff       	call   8026fe <syscall>
  802b6b:	83 c4 18             	add    $0x18,%esp
  802b6e:	a3 60 d0 81 00       	mov    %eax,0x81d060
	return uheapPlaceStrategy ;
  802b73:	a1 60 d0 81 00       	mov    0x81d060,%eax
}
  802b78:	c9                   	leave  
  802b79:	c3                   	ret    

00802b7a <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  802b7a:	55                   	push   %ebp
  802b7b:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = heapStrategy;
  802b7d:	8b 45 08             	mov    0x8(%ebp),%eax
  802b80:	a3 60 d0 81 00       	mov    %eax,0x81d060
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  802b85:	6a 00                	push   $0x0
  802b87:	6a 00                	push   $0x0
  802b89:	6a 00                	push   $0x0
  802b8b:	6a 00                	push   $0x0
  802b8d:	ff 75 08             	pushl  0x8(%ebp)
  802b90:	6a 26                	push   $0x26
  802b92:	e8 67 fb ff ff       	call   8026fe <syscall>
  802b97:	83 c4 18             	add    $0x18,%esp
	return ;
  802b9a:	90                   	nop
}
  802b9b:	c9                   	leave  
  802b9c:	c3                   	ret    

00802b9d <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  802b9d:	55                   	push   %ebp
  802b9e:	89 e5                	mov    %esp,%ebp
  802ba0:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  802ba1:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802ba4:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802ba7:	8b 55 0c             	mov    0xc(%ebp),%edx
  802baa:	8b 45 08             	mov    0x8(%ebp),%eax
  802bad:	6a 00                	push   $0x0
  802baf:	53                   	push   %ebx
  802bb0:	51                   	push   %ecx
  802bb1:	52                   	push   %edx
  802bb2:	50                   	push   %eax
  802bb3:	6a 27                	push   $0x27
  802bb5:	e8 44 fb ff ff       	call   8026fe <syscall>
  802bba:	83 c4 18             	add    $0x18,%esp
}
  802bbd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802bc0:	c9                   	leave  
  802bc1:	c3                   	ret    

00802bc2 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  802bc2:	55                   	push   %ebp
  802bc3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  802bc5:	8b 55 0c             	mov    0xc(%ebp),%edx
  802bc8:	8b 45 08             	mov    0x8(%ebp),%eax
  802bcb:	6a 00                	push   $0x0
  802bcd:	6a 00                	push   $0x0
  802bcf:	6a 00                	push   $0x0
  802bd1:	52                   	push   %edx
  802bd2:	50                   	push   %eax
  802bd3:	6a 28                	push   $0x28
  802bd5:	e8 24 fb ff ff       	call   8026fe <syscall>
  802bda:	83 c4 18             	add    $0x18,%esp
}
  802bdd:	c9                   	leave  
  802bde:	c3                   	ret    

00802bdf <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  802bdf:	55                   	push   %ebp
  802be0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  802be2:	8b 4d 14             	mov    0x14(%ebp),%ecx
  802be5:	8b 55 0c             	mov    0xc(%ebp),%edx
  802be8:	8b 45 08             	mov    0x8(%ebp),%eax
  802beb:	6a 00                	push   $0x0
  802bed:	51                   	push   %ecx
  802bee:	ff 75 10             	pushl  0x10(%ebp)
  802bf1:	52                   	push   %edx
  802bf2:	50                   	push   %eax
  802bf3:	6a 29                	push   $0x29
  802bf5:	e8 04 fb ff ff       	call   8026fe <syscall>
  802bfa:	83 c4 18             	add    $0x18,%esp
}
  802bfd:	c9                   	leave  
  802bfe:	c3                   	ret    

00802bff <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  802bff:	55                   	push   %ebp
  802c00:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  802c02:	6a 00                	push   $0x0
  802c04:	6a 00                	push   $0x0
  802c06:	ff 75 10             	pushl  0x10(%ebp)
  802c09:	ff 75 0c             	pushl  0xc(%ebp)
  802c0c:	ff 75 08             	pushl  0x8(%ebp)
  802c0f:	6a 12                	push   $0x12
  802c11:	e8 e8 fa ff ff       	call   8026fe <syscall>
  802c16:	83 c4 18             	add    $0x18,%esp
	return ;
  802c19:	90                   	nop
}
  802c1a:	c9                   	leave  
  802c1b:	c3                   	ret    

00802c1c <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  802c1c:	55                   	push   %ebp
  802c1d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  802c1f:	8b 55 0c             	mov    0xc(%ebp),%edx
  802c22:	8b 45 08             	mov    0x8(%ebp),%eax
  802c25:	6a 00                	push   $0x0
  802c27:	6a 00                	push   $0x0
  802c29:	6a 00                	push   $0x0
  802c2b:	52                   	push   %edx
  802c2c:	50                   	push   %eax
  802c2d:	6a 2a                	push   $0x2a
  802c2f:	e8 ca fa ff ff       	call   8026fe <syscall>
  802c34:	83 c4 18             	add    $0x18,%esp
	return;
  802c37:	90                   	nop
}
  802c38:	c9                   	leave  
  802c39:	c3                   	ret    

00802c3a <sys_get_optimal_num_faults>:
/*2025*/
int sys_get_optimal_num_faults()
{
  802c3a:	55                   	push   %ebp
  802c3b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_optimal_num_faults, 0, 0, 0, 0, 0);
  802c3d:	6a 00                	push   $0x0
  802c3f:	6a 00                	push   $0x0
  802c41:	6a 00                	push   $0x0
  802c43:	6a 00                	push   $0x0
  802c45:	6a 00                	push   $0x0
  802c47:	6a 2b                	push   $0x2b
  802c49:	e8 b0 fa ff ff       	call   8026fe <syscall>
  802c4e:	83 c4 18             	add    $0x18,%esp
}
  802c51:	c9                   	leave  
  802c52:	c3                   	ret    

00802c53 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  802c53:	55                   	push   %ebp
  802c54:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  802c56:	6a 00                	push   $0x0
  802c58:	6a 00                	push   $0x0
  802c5a:	6a 00                	push   $0x0
  802c5c:	ff 75 0c             	pushl  0xc(%ebp)
  802c5f:	ff 75 08             	pushl  0x8(%ebp)
  802c62:	6a 2d                	push   $0x2d
  802c64:	e8 95 fa ff ff       	call   8026fe <syscall>
  802c69:	83 c4 18             	add    $0x18,%esp
	return;
  802c6c:	90                   	nop
}
  802c6d:	c9                   	leave  
  802c6e:	c3                   	ret    

00802c6f <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  802c6f:	55                   	push   %ebp
  802c70:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  802c72:	6a 00                	push   $0x0
  802c74:	6a 00                	push   $0x0
  802c76:	6a 00                	push   $0x0
  802c78:	ff 75 0c             	pushl  0xc(%ebp)
  802c7b:	ff 75 08             	pushl  0x8(%ebp)
  802c7e:	6a 2c                	push   $0x2c
  802c80:	e8 79 fa ff ff       	call   8026fe <syscall>
  802c85:	83 c4 18             	add    $0x18,%esp
	return ;
  802c88:	90                   	nop
}
  802c89:	c9                   	leave  
  802c8a:	c3                   	ret    

00802c8b <sys_env_set_priority>:


void sys_env_set_priority(int32 envID, int priority)
{
  802c8b:	55                   	push   %ebp
  802c8c:	89 e5                	mov    %esp,%ebp
  802c8e:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.IM#4] CPU SCHEDULING - #1 System Calls - Add suitable code here
	//Your code is here
	//Comment the following line
	panic("sys_env_set_priority() is not implemented yet...!!");
  802c91:	83 ec 04             	sub    $0x4,%esp
  802c94:	68 a8 49 80 00       	push   $0x8049a8
  802c99:	68 25 01 00 00       	push   $0x125
  802c9e:	68 db 49 80 00       	push   $0x8049db
  802ca3:	e8 e4 e4 ff ff       	call   80118c <_panic>

00802ca8 <to_page_va>:
//==================================
//==================================
// [1] GET PAGE VA:
//==================================
__inline__ uint32 to_page_va(struct PageInfoElement *ptrPageInfo)
{
  802ca8:	55                   	push   %ebp
  802ca9:	89 e5                	mov    %esp,%ebp
  802cab:	83 ec 18             	sub    $0x18,%esp
	if (ptrPageInfo < &pageBlockInfoArr[0] || ptrPageInfo >= &pageBlockInfoArr[DYN_ALLOC_MAX_SIZE/PAGE_SIZE])
  802cae:	81 7d 08 60 50 80 00 	cmpl   $0x805060,0x8(%ebp)
  802cb5:	72 09                	jb     802cc0 <to_page_va+0x18>
  802cb7:	81 7d 08 60 d0 81 00 	cmpl   $0x81d060,0x8(%ebp)
  802cbe:	72 14                	jb     802cd4 <to_page_va+0x2c>
			panic("to_page_va called with invalid pageInfoPtr");
  802cc0:	83 ec 04             	sub    $0x4,%esp
  802cc3:	68 ec 49 80 00       	push   $0x8049ec
  802cc8:	6a 15                	push   $0x15
  802cca:	68 17 4a 80 00       	push   $0x804a17
  802ccf:	e8 b8 e4 ff ff       	call   80118c <_panic>
	//Get start VA of the page from the corresponding Page Info pointer
	int idxInPageInfoArr = (ptrPageInfo - pageBlockInfoArr);
  802cd4:	8b 45 08             	mov    0x8(%ebp),%eax
  802cd7:	ba 60 50 80 00       	mov    $0x805060,%edx
  802cdc:	29 d0                	sub    %edx,%eax
  802cde:	c1 f8 02             	sar    $0x2,%eax
  802ce1:	89 c2                	mov    %eax,%edx
  802ce3:	89 d0                	mov    %edx,%eax
  802ce5:	c1 e0 02             	shl    $0x2,%eax
  802ce8:	01 d0                	add    %edx,%eax
  802cea:	c1 e0 02             	shl    $0x2,%eax
  802ced:	01 d0                	add    %edx,%eax
  802cef:	c1 e0 02             	shl    $0x2,%eax
  802cf2:	01 d0                	add    %edx,%eax
  802cf4:	89 c1                	mov    %eax,%ecx
  802cf6:	c1 e1 08             	shl    $0x8,%ecx
  802cf9:	01 c8                	add    %ecx,%eax
  802cfb:	89 c1                	mov    %eax,%ecx
  802cfd:	c1 e1 10             	shl    $0x10,%ecx
  802d00:	01 c8                	add    %ecx,%eax
  802d02:	01 c0                	add    %eax,%eax
  802d04:	01 d0                	add    %edx,%eax
  802d06:	89 45 f4             	mov    %eax,-0xc(%ebp)
	return dynAllocStart + (idxInPageInfoArr << PGSHIFT);
  802d09:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d0c:	c1 e0 0c             	shl    $0xc,%eax
  802d0f:	89 c2                	mov    %eax,%edx
  802d11:	a1 64 d0 81 00       	mov    0x81d064,%eax
  802d16:	01 d0                	add    %edx,%eax
}
  802d18:	c9                   	leave  
  802d19:	c3                   	ret    

00802d1a <to_page_info>:

//==================================
// [2] GET PAGE INFO OF PAGE VA:
//==================================
__inline__ struct PageInfoElement * to_page_info(uint32 va)
{
  802d1a:	55                   	push   %ebp
  802d1b:	89 e5                	mov    %esp,%ebp
  802d1d:	83 ec 18             	sub    $0x18,%esp
	int idxInPageInfoArr = (va - dynAllocStart) >> PGSHIFT;
  802d20:	a1 64 d0 81 00       	mov    0x81d064,%eax
  802d25:	8b 55 08             	mov    0x8(%ebp),%edx
  802d28:	29 c2                	sub    %eax,%edx
  802d2a:	89 d0                	mov    %edx,%eax
  802d2c:	c1 e8 0c             	shr    $0xc,%eax
  802d2f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if (idxInPageInfoArr < 0 || idxInPageInfoArr >= DYN_ALLOC_MAX_SIZE/PAGE_SIZE)
  802d32:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802d36:	78 09                	js     802d41 <to_page_info+0x27>
  802d38:	81 7d f4 ff 1f 00 00 	cmpl   $0x1fff,-0xc(%ebp)
  802d3f:	7e 14                	jle    802d55 <to_page_info+0x3b>
		panic("to_page_info called with invalid pa");
  802d41:	83 ec 04             	sub    $0x4,%esp
  802d44:	68 30 4a 80 00       	push   $0x804a30
  802d49:	6a 22                	push   $0x22
  802d4b:	68 17 4a 80 00       	push   $0x804a17
  802d50:	e8 37 e4 ff ff       	call   80118c <_panic>
	return &pageBlockInfoArr[idxInPageInfoArr];
  802d55:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802d58:	89 d0                	mov    %edx,%eax
  802d5a:	01 c0                	add    %eax,%eax
  802d5c:	01 d0                	add    %edx,%eax
  802d5e:	c1 e0 02             	shl    $0x2,%eax
  802d61:	05 60 50 80 00       	add    $0x805060,%eax
}
  802d66:	c9                   	leave  
  802d67:	c3                   	ret    

00802d68 <initialize_dynamic_allocator>:
//==================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================
bool is_initialized = 0;
void initialize_dynamic_allocator(uint32 daStart, uint32 daEnd)
{
  802d68:	55                   	push   %ebp
  802d69:	89 e5                	mov    %esp,%ebp
  802d6b:	83 ec 18             	sub    $0x18,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		assert(daEnd <= daStart + DYN_ALLOC_MAX_SIZE);
  802d6e:	8b 45 08             	mov    0x8(%ebp),%eax
  802d71:	05 00 00 00 02       	add    $0x2000000,%eax
  802d76:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802d79:	73 16                	jae    802d91 <initialize_dynamic_allocator+0x29>
  802d7b:	68 54 4a 80 00       	push   $0x804a54
  802d80:	68 7a 4a 80 00       	push   $0x804a7a
  802d85:	6a 34                	push   $0x34
  802d87:	68 17 4a 80 00       	push   $0x804a17
  802d8c:	e8 fb e3 ff ff       	call   80118c <_panic>
		is_initialized = 1;
  802d91:	c7 05 24 50 80 00 01 	movl   $0x1,0x805024
  802d98:	00 00 00 
	//==================================================================================
	//==================================================================================
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #1 initialize_dynamic_allocator
	//Your code is here
	// init bounds of the dynalloc
	dynAllocStart = daStart;
  802d9b:	8b 45 08             	mov    0x8(%ebp),%eax
  802d9e:	a3 64 d0 81 00       	mov    %eax,0x81d064
	dynAllocEnd = daEnd;
  802da3:	8b 45 0c             	mov    0xc(%ebp),%eax
  802da6:	a3 40 50 80 00       	mov    %eax,0x805040
	// init the list that keep track of all free pageBlockInfoArr instances.
	LIST_INIT(&freePagesList);
  802dab:	c7 05 48 50 80 00 00 	movl   $0x0,0x805048
  802db2:	00 00 00 
  802db5:	c7 05 4c 50 80 00 00 	movl   $0x0,0x80504c
  802dbc:	00 00 00 
  802dbf:	c7 05 54 50 80 00 00 	movl   $0x0,0x805054
  802dc6:	00 00 00 

	// no.of pages in the dynamic allocator.
	int pCount = (daEnd - daStart) / PAGE_SIZE;
  802dc9:	8b 45 0c             	mov    0xc(%ebp),%eax
  802dcc:	2b 45 08             	sub    0x8(%ebp),%eax
  802dcf:	c1 e8 0c             	shr    $0xc,%eax
  802dd2:	89 45 ec             	mov    %eax,-0x14(%ebp)
	// iterate over each page and init its data in pageBlockInfoArr and reset it.
	for (int i = 0; i < pCount; ++i) {
  802dd5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  802ddc:	e9 c8 00 00 00       	jmp    802ea9 <initialize_dynamic_allocator+0x141>
	    pageBlockInfoArr[i].block_size = 0;
  802de1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802de4:	89 d0                	mov    %edx,%eax
  802de6:	01 c0                	add    %eax,%eax
  802de8:	01 d0                	add    %edx,%eax
  802dea:	c1 e0 02             	shl    $0x2,%eax
  802ded:	05 68 50 80 00       	add    $0x805068,%eax
  802df2:	66 c7 00 00 00       	movw   $0x0,(%eax)
	    pageBlockInfoArr[i].num_of_free_blocks = 0;
  802df7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802dfa:	89 d0                	mov    %edx,%eax
  802dfc:	01 c0                	add    %eax,%eax
  802dfe:	01 d0                	add    %edx,%eax
  802e00:	c1 e0 02             	shl    $0x2,%eax
  802e03:	05 6a 50 80 00       	add    $0x80506a,%eax
  802e08:	66 c7 00 00 00       	movw   $0x0,(%eax)
	    LIST_INSERT_TAIL(&freePagesList, &pageBlockInfoArr[i]);
  802e0d:	8b 15 4c 50 80 00    	mov    0x80504c,%edx
  802e13:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  802e16:	89 c8                	mov    %ecx,%eax
  802e18:	01 c0                	add    %eax,%eax
  802e1a:	01 c8                	add    %ecx,%eax
  802e1c:	c1 e0 02             	shl    $0x2,%eax
  802e1f:	05 64 50 80 00       	add    $0x805064,%eax
  802e24:	89 10                	mov    %edx,(%eax)
  802e26:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802e29:	89 d0                	mov    %edx,%eax
  802e2b:	01 c0                	add    %eax,%eax
  802e2d:	01 d0                	add    %edx,%eax
  802e2f:	c1 e0 02             	shl    $0x2,%eax
  802e32:	05 64 50 80 00       	add    $0x805064,%eax
  802e37:	8b 00                	mov    (%eax),%eax
  802e39:	85 c0                	test   %eax,%eax
  802e3b:	74 1b                	je     802e58 <initialize_dynamic_allocator+0xf0>
  802e3d:	8b 15 4c 50 80 00    	mov    0x80504c,%edx
  802e43:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  802e46:	89 c8                	mov    %ecx,%eax
  802e48:	01 c0                	add    %eax,%eax
  802e4a:	01 c8                	add    %ecx,%eax
  802e4c:	c1 e0 02             	shl    $0x2,%eax
  802e4f:	05 60 50 80 00       	add    $0x805060,%eax
  802e54:	89 02                	mov    %eax,(%edx)
  802e56:	eb 16                	jmp    802e6e <initialize_dynamic_allocator+0x106>
  802e58:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802e5b:	89 d0                	mov    %edx,%eax
  802e5d:	01 c0                	add    %eax,%eax
  802e5f:	01 d0                	add    %edx,%eax
  802e61:	c1 e0 02             	shl    $0x2,%eax
  802e64:	05 60 50 80 00       	add    $0x805060,%eax
  802e69:	a3 48 50 80 00       	mov    %eax,0x805048
  802e6e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802e71:	89 d0                	mov    %edx,%eax
  802e73:	01 c0                	add    %eax,%eax
  802e75:	01 d0                	add    %edx,%eax
  802e77:	c1 e0 02             	shl    $0x2,%eax
  802e7a:	05 60 50 80 00       	add    $0x805060,%eax
  802e7f:	a3 4c 50 80 00       	mov    %eax,0x80504c
  802e84:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802e87:	89 d0                	mov    %edx,%eax
  802e89:	01 c0                	add    %eax,%eax
  802e8b:	01 d0                	add    %edx,%eax
  802e8d:	c1 e0 02             	shl    $0x2,%eax
  802e90:	05 60 50 80 00       	add    $0x805060,%eax
  802e95:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802e9b:	a1 54 50 80 00       	mov    0x805054,%eax
  802ea0:	40                   	inc    %eax
  802ea1:	a3 54 50 80 00       	mov    %eax,0x805054
	LIST_INIT(&freePagesList);

	// no.of pages in the dynamic allocator.
	int pCount = (daEnd - daStart) / PAGE_SIZE;
	// iterate over each page and init its data in pageBlockInfoArr and reset it.
	for (int i = 0; i < pCount; ++i) {
  802ea6:	ff 45 f4             	incl   -0xc(%ebp)
  802ea9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802eac:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  802eaf:	0f 8c 2c ff ff ff    	jl     802de1 <initialize_dynamic_allocator+0x79>
	    LIST_INSERT_TAIL(&freePagesList, &pageBlockInfoArr[i]);
	}
	// init the array of lists of each size..
	// 8 16 32 64 128 256 512 1024 2056
	// 0 1  2  3   4  5    6   7    8
	for (int i = 0; i <= (LOG2_MAX_SIZE - LOG2_MIN_SIZE); ++i){
  802eb5:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  802ebc:	eb 36                	jmp    802ef4 <initialize_dynamic_allocator+0x18c>
		LIST_INIT(&freeBlockLists[i]);
  802ebe:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ec1:	c1 e0 04             	shl    $0x4,%eax
  802ec4:	05 80 d0 81 00       	add    $0x81d080,%eax
  802ec9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802ecf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ed2:	c1 e0 04             	shl    $0x4,%eax
  802ed5:	05 84 d0 81 00       	add    $0x81d084,%eax
  802eda:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802ee0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ee3:	c1 e0 04             	shl    $0x4,%eax
  802ee6:	05 8c d0 81 00       	add    $0x81d08c,%eax
  802eeb:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	    LIST_INSERT_TAIL(&freePagesList, &pageBlockInfoArr[i]);
	}
	// init the array of lists of each size..
	// 8 16 32 64 128 256 512 1024 2056
	// 0 1  2  3   4  5    6   7    8
	for (int i = 0; i <= (LOG2_MAX_SIZE - LOG2_MIN_SIZE); ++i){
  802ef1:	ff 45 f0             	incl   -0x10(%ebp)
  802ef4:	83 7d f0 08          	cmpl   $0x8,-0x10(%ebp)
  802ef8:	7e c4                	jle    802ebe <initialize_dynamic_allocator+0x156>
		LIST_INIT(&freeBlockLists[i]);
	}
	//Comment the following line
	//panic("initialize_dynamic_allocator() Not implemented yet");

}
  802efa:	90                   	nop
  802efb:	c9                   	leave  
  802efc:	c3                   	ret    

00802efd <get_block_size>:

//===========================
// [2] GET BLOCK SIZE:
//===========================
__inline__ uint32 get_block_size(void *va)
{
  802efd:	55                   	push   %ebp
  802efe:	89 e5                	mov    %esp,%ebp
  802f00:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #2 get_block_size
	//Your code is here
	// get the page that saves this va
	struct PageInfoElement* ptr = to_page_info((uint32)va);
  802f03:	8b 45 08             	mov    0x8(%ebp),%eax
  802f06:	83 ec 0c             	sub    $0xc,%esp
  802f09:	50                   	push   %eax
  802f0a:	e8 0b fe ff ff       	call   802d1a <to_page_info>
  802f0f:	83 c4 10             	add    $0x10,%esp
  802f12:	89 45 f4             	mov    %eax,-0xc(%ebp)
	return ptr->block_size;
  802f15:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f18:	8b 40 08             	mov    0x8(%eax),%eax
  802f1b:	0f b7 c0             	movzwl %ax,%eax
	//Comment the following line
	//panic("get_block_size() Not implemented yet");
}
  802f1e:	c9                   	leave  
  802f1f:	c3                   	ret    

00802f20 <split_page_to_blocks>:
// =====================
// h) split page to blocks and add them in freeBlockLists
// =====================
// function that split the page provided into same sized blocks
//and putem in suitable freeblockList index according to size.
 void split_page_to_blocks(uint32 blk_size, struct PageInfoElement *pageInfo) {
  802f20:	55                   	push   %ebp
  802f21:	89 e5                	mov    %esp,%ebp
  802f23:	83 ec 28             	sub    $0x28,%esp
	 // cur page virtual address by the pageInfo.
	 uint32 page_va = (uint32)to_page_va(pageInfo);
  802f26:	83 ec 0c             	sub    $0xc,%esp
  802f29:	ff 75 0c             	pushl  0xc(%ebp)
  802f2c:	e8 77 fd ff ff       	call   802ca8 <to_page_va>
  802f31:	83 c4 10             	add    $0x10,%esp
  802f34:	89 45 e8             	mov    %eax,-0x18(%ebp)
	 // no. of blks to save in freeblockList.
	 int blk_count = PAGE_SIZE / blk_size;
  802f37:	b8 00 10 00 00       	mov    $0x1000,%eax
  802f3c:	ba 00 00 00 00       	mov    $0x0,%edx
  802f41:	f7 75 08             	divl   0x8(%ebp)
  802f44:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	 // save page in memory.
	 get_page((uint32*)page_va);
  802f47:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f4a:	83 ec 0c             	sub    $0xc,%esp
  802f4d:	50                   	push   %eax
  802f4e:	e8 48 f6 ff ff       	call   80259b <get_page>
  802f53:	83 c4 10             	add    $0x10,%esp
	 // assigning the pageInfo data block size, free block which is whole block count.
	 pageInfo->num_of_free_blocks = blk_count;
  802f56:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802f59:	8b 55 0c             	mov    0xc(%ebp),%edx
  802f5c:	66 89 42 0a          	mov    %ax,0xa(%edx)
	 pageInfo->block_size = blk_size;
  802f60:	8b 45 08             	mov    0x8(%ebp),%eax
  802f63:	8b 55 0c             	mov    0xc(%ebp),%edx
  802f66:	66 89 42 08          	mov    %ax,0x8(%edx)
	 // get index by size block in freeblocklist.
	 int idx = 0;
  802f6a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	 for (int i = LOG2_MIN_SIZE; i <= LOG2_MAX_SIZE; i++) {
  802f71:	c7 45 f0 03 00 00 00 	movl   $0x3,-0x10(%ebp)
  802f78:	eb 19                	jmp    802f93 <split_page_to_blocks+0x73>
	     if ((1 << i) == blk_size)
  802f7a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f7d:	ba 01 00 00 00       	mov    $0x1,%edx
  802f82:	88 c1                	mov    %al,%cl
  802f84:	d3 e2                	shl    %cl,%edx
  802f86:	89 d0                	mov    %edx,%eax
  802f88:	3b 45 08             	cmp    0x8(%ebp),%eax
  802f8b:	74 0e                	je     802f9b <split_page_to_blocks+0x7b>
	         break;
	     idx++;
  802f8d:	ff 45 f4             	incl   -0xc(%ebp)
	 // assigning the pageInfo data block size, free block which is whole block count.
	 pageInfo->num_of_free_blocks = blk_count;
	 pageInfo->block_size = blk_size;
	 // get index by size block in freeblocklist.
	 int idx = 0;
	 for (int i = LOG2_MIN_SIZE; i <= LOG2_MAX_SIZE; i++) {
  802f90:	ff 45 f0             	incl   -0x10(%ebp)
  802f93:	83 7d f0 0b          	cmpl   $0xb,-0x10(%ebp)
  802f97:	7e e1                	jle    802f7a <split_page_to_blocks+0x5a>
  802f99:	eb 01                	jmp    802f9c <split_page_to_blocks+0x7c>
	     if ((1 << i) == blk_size)
	         break;
  802f9b:	90                   	nop
	     idx++;
	 }
	 // iterate over each blk and make and element of it by passing its address in blockElement pointer and save those in the list.
	 // starting from the page_va.
	 for (uint32 i = 0; i < blk_count; ++i) {
  802f9c:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  802fa3:	e9 a7 00 00 00       	jmp    80304f <split_page_to_blocks+0x12f>
	     struct BlockElement *blk =(struct BlockElement*)(page_va + i * blk_size);
  802fa8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802fab:	0f af 45 08          	imul   0x8(%ebp),%eax
  802faf:	89 c2                	mov    %eax,%edx
  802fb1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802fb4:	01 d0                	add    %edx,%eax
  802fb6:	89 45 e0             	mov    %eax,-0x20(%ebp)
	     LIST_INSERT_TAIL(&freeBlockLists[idx],blk);
  802fb9:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  802fbd:	75 14                	jne    802fd3 <split_page_to_blocks+0xb3>
  802fbf:	83 ec 04             	sub    $0x4,%esp
  802fc2:	68 90 4a 80 00       	push   $0x804a90
  802fc7:	6a 7c                	push   $0x7c
  802fc9:	68 17 4a 80 00       	push   $0x804a17
  802fce:	e8 b9 e1 ff ff       	call   80118c <_panic>
  802fd3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fd6:	c1 e0 04             	shl    $0x4,%eax
  802fd9:	05 84 d0 81 00       	add    $0x81d084,%eax
  802fde:	8b 10                	mov    (%eax),%edx
  802fe0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802fe3:	89 50 04             	mov    %edx,0x4(%eax)
  802fe6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802fe9:	8b 40 04             	mov    0x4(%eax),%eax
  802fec:	85 c0                	test   %eax,%eax
  802fee:	74 14                	je     803004 <split_page_to_blocks+0xe4>
  802ff0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ff3:	c1 e0 04             	shl    $0x4,%eax
  802ff6:	05 84 d0 81 00       	add    $0x81d084,%eax
  802ffb:	8b 00                	mov    (%eax),%eax
  802ffd:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803000:	89 10                	mov    %edx,(%eax)
  803002:	eb 11                	jmp    803015 <split_page_to_blocks+0xf5>
  803004:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803007:	c1 e0 04             	shl    $0x4,%eax
  80300a:	8d 90 80 d0 81 00    	lea    0x81d080(%eax),%edx
  803010:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803013:	89 02                	mov    %eax,(%edx)
  803015:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803018:	c1 e0 04             	shl    $0x4,%eax
  80301b:	8d 90 84 d0 81 00    	lea    0x81d084(%eax),%edx
  803021:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803024:	89 02                	mov    %eax,(%edx)
  803026:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803029:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80302f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803032:	c1 e0 04             	shl    $0x4,%eax
  803035:	05 8c d0 81 00       	add    $0x81d08c,%eax
  80303a:	8b 00                	mov    (%eax),%eax
  80303c:	8d 50 01             	lea    0x1(%eax),%edx
  80303f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803042:	c1 e0 04             	shl    $0x4,%eax
  803045:	05 8c d0 81 00       	add    $0x81d08c,%eax
  80304a:	89 10                	mov    %edx,(%eax)
	         break;
	     idx++;
	 }
	 // iterate over each blk and make and element of it by passing its address in blockElement pointer and save those in the list.
	 // starting from the page_va.
	 for (uint32 i = 0; i < blk_count; ++i) {
  80304c:	ff 45 ec             	incl   -0x14(%ebp)
  80304f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803052:	39 45 ec             	cmp    %eax,-0x14(%ebp)
  803055:	0f 82 4d ff ff ff    	jb     802fa8 <split_page_to_blocks+0x88>
	     struct BlockElement *blk =(struct BlockElement*)(page_va + i * blk_size);
	     LIST_INSERT_TAIL(&freeBlockLists[idx],blk);
	 }
 }
  80305b:	90                   	nop
  80305c:	c9                   	leave  
  80305d:	c3                   	ret    

0080305e <alloc_block>:

//===========================
// 3) ALLOCATE BLOCK:
//===========================
void *alloc_block(uint32 size)
{
  80305e:	55                   	push   %ebp
  80305f:	89 e5                	mov    %esp,%ebp
  803061:	83 ec 38             	sub    $0x38,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		assert(size <= DYN_ALLOC_MAX_BLOCK_SIZE);
  803064:	81 7d 08 00 08 00 00 	cmpl   $0x800,0x8(%ebp)
  80306b:	76 19                	jbe    803086 <alloc_block+0x28>
  80306d:	68 b4 4a 80 00       	push   $0x804ab4
  803072:	68 7a 4a 80 00       	push   $0x804a7a
  803077:	68 8a 00 00 00       	push   $0x8a
  80307c:	68 17 4a 80 00       	push   $0x804a17
  803081:	e8 06 e1 ff ff       	call   80118c <_panic>
	//==================================================================================
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #3 alloc_block
	//Your code is here
	//Comment the following line
	// get index in freeBlockList by size.
	uint32 idx = 0;
  803086:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int i = LOG2_MIN_SIZE; i <= LOG2_MAX_SIZE; ++i){
  80308d:	c7 45 f0 03 00 00 00 	movl   $0x3,-0x10(%ebp)
  803094:	eb 19                	jmp    8030af <alloc_block+0x51>
		if((1 << i) >= size) break;
  803096:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803099:	ba 01 00 00 00       	mov    $0x1,%edx
  80309e:	88 c1                	mov    %al,%cl
  8030a0:	d3 e2                	shl    %cl,%edx
  8030a2:	89 d0                	mov    %edx,%eax
  8030a4:	3b 45 08             	cmp    0x8(%ebp),%eax
  8030a7:	73 0e                	jae    8030b7 <alloc_block+0x59>
		idx++;
  8030a9:	ff 45 f4             	incl   -0xc(%ebp)
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #3 alloc_block
	//Your code is here
	//Comment the following line
	// get index in freeBlockList by size.
	uint32 idx = 0;
	for (int i = LOG2_MIN_SIZE; i <= LOG2_MAX_SIZE; ++i){
  8030ac:	ff 45 f0             	incl   -0x10(%ebp)
  8030af:	83 7d f0 0b          	cmpl   $0xb,-0x10(%ebp)
  8030b3:	7e e1                	jle    803096 <alloc_block+0x38>
  8030b5:	eb 01                	jmp    8030b8 <alloc_block+0x5a>
		if((1 << i) >= size) break;
  8030b7:	90                   	nop
		idx++;
	}

	//case 1: the free block of the cur size is available.
	if (freeBlockLists[idx].size > 0) {
  8030b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030bb:	c1 e0 04             	shl    $0x4,%eax
  8030be:	05 8c d0 81 00       	add    $0x81d08c,%eax
  8030c3:	8b 00                	mov    (%eax),%eax
  8030c5:	85 c0                	test   %eax,%eax
  8030c7:	0f 84 df 00 00 00    	je     8031ac <alloc_block+0x14e>

		// remove from the list and updat the pageInfoArr free blocks.
		// pop from the freeBlockList.
		struct BlockElement *blk = LIST_FIRST(&freeBlockLists[idx]);
  8030cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030d0:	c1 e0 04             	shl    $0x4,%eax
  8030d3:	05 80 d0 81 00       	add    $0x81d080,%eax
  8030d8:	8b 00                	mov    (%eax),%eax
  8030da:	89 45 ec             	mov    %eax,-0x14(%ebp)
	    LIST_REMOVE(&freeBlockLists[idx], blk);
  8030dd:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8030e1:	75 17                	jne    8030fa <alloc_block+0x9c>
  8030e3:	83 ec 04             	sub    $0x4,%esp
  8030e6:	68 d5 4a 80 00       	push   $0x804ad5
  8030eb:	68 9e 00 00 00       	push   $0x9e
  8030f0:	68 17 4a 80 00       	push   $0x804a17
  8030f5:	e8 92 e0 ff ff       	call   80118c <_panic>
  8030fa:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8030fd:	8b 00                	mov    (%eax),%eax
  8030ff:	85 c0                	test   %eax,%eax
  803101:	74 10                	je     803113 <alloc_block+0xb5>
  803103:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803106:	8b 00                	mov    (%eax),%eax
  803108:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80310b:	8b 52 04             	mov    0x4(%edx),%edx
  80310e:	89 50 04             	mov    %edx,0x4(%eax)
  803111:	eb 14                	jmp    803127 <alloc_block+0xc9>
  803113:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803116:	8b 40 04             	mov    0x4(%eax),%eax
  803119:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80311c:	c1 e2 04             	shl    $0x4,%edx
  80311f:	81 c2 84 d0 81 00    	add    $0x81d084,%edx
  803125:	89 02                	mov    %eax,(%edx)
  803127:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80312a:	8b 40 04             	mov    0x4(%eax),%eax
  80312d:	85 c0                	test   %eax,%eax
  80312f:	74 0f                	je     803140 <alloc_block+0xe2>
  803131:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803134:	8b 40 04             	mov    0x4(%eax),%eax
  803137:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80313a:	8b 12                	mov    (%edx),%edx
  80313c:	89 10                	mov    %edx,(%eax)
  80313e:	eb 13                	jmp    803153 <alloc_block+0xf5>
  803140:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803143:	8b 00                	mov    (%eax),%eax
  803145:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803148:	c1 e2 04             	shl    $0x4,%edx
  80314b:	81 c2 80 d0 81 00    	add    $0x81d080,%edx
  803151:	89 02                	mov    %eax,(%edx)
  803153:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803156:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80315c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80315f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803166:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803169:	c1 e0 04             	shl    $0x4,%eax
  80316c:	05 8c d0 81 00       	add    $0x81d08c,%eax
  803171:	8b 00                	mov    (%eax),%eax
  803173:	8d 50 ff             	lea    -0x1(%eax),%edx
  803176:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803179:	c1 e0 04             	shl    $0x4,%eax
  80317c:	05 8c d0 81 00       	add    $0x81d08c,%eax
  803181:	89 10                	mov    %edx,(%eax)
	    // update pageBlockInfoArr
	    struct PageInfoElement *pageInfo = to_page_info((uint32)blk);
  803183:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803186:	83 ec 0c             	sub    $0xc,%esp
  803189:	50                   	push   %eax
  80318a:	e8 8b fb ff ff       	call   802d1a <to_page_info>
  80318f:	83 c4 10             	add    $0x10,%esp
  803192:	89 45 e8             	mov    %eax,-0x18(%ebp)
	    pageInfo->num_of_free_blocks--;
  803195:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803198:	66 8b 40 0a          	mov    0xa(%eax),%ax
  80319c:	48                   	dec    %eax
  80319d:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8031a0:	66 89 42 0a          	mov    %ax,0xa(%edx)
	    return blk;
  8031a4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8031a7:	e9 bc 02 00 00       	jmp    803468 <alloc_block+0x40a>
	}else{ //case(2, 3): 2. no free blocks available in the freeblocklist but there is free pages.
				//3. no free blocks and no available freepages so search in higher block sizes.
		// case 2:
		if(freePagesList.size > 0){ //have free pages.
  8031ac:	a1 54 50 80 00       	mov    0x805054,%eax
  8031b1:	85 c0                	test   %eax,%eax
  8031b3:	0f 84 7d 02 00 00    	je     803436 <alloc_block+0x3d8>
			// get page to split and use from freepagesList.
			struct PageInfoElement *ptr_new_page = LIST_FIRST(&freePagesList);
  8031b9:	a1 48 50 80 00       	mov    0x805048,%eax
  8031be:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			LIST_REMOVE(&freePagesList, ptr_new_page);
  8031c1:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8031c5:	75 17                	jne    8031de <alloc_block+0x180>
  8031c7:	83 ec 04             	sub    $0x4,%esp
  8031ca:	68 d5 4a 80 00       	push   $0x804ad5
  8031cf:	68 a9 00 00 00       	push   $0xa9
  8031d4:	68 17 4a 80 00       	push   $0x804a17
  8031d9:	e8 ae df ff ff       	call   80118c <_panic>
  8031de:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8031e1:	8b 00                	mov    (%eax),%eax
  8031e3:	85 c0                	test   %eax,%eax
  8031e5:	74 10                	je     8031f7 <alloc_block+0x199>
  8031e7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8031ea:	8b 00                	mov    (%eax),%eax
  8031ec:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8031ef:	8b 52 04             	mov    0x4(%edx),%edx
  8031f2:	89 50 04             	mov    %edx,0x4(%eax)
  8031f5:	eb 0b                	jmp    803202 <alloc_block+0x1a4>
  8031f7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8031fa:	8b 40 04             	mov    0x4(%eax),%eax
  8031fd:	a3 4c 50 80 00       	mov    %eax,0x80504c
  803202:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803205:	8b 40 04             	mov    0x4(%eax),%eax
  803208:	85 c0                	test   %eax,%eax
  80320a:	74 0f                	je     80321b <alloc_block+0x1bd>
  80320c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80320f:	8b 40 04             	mov    0x4(%eax),%eax
  803212:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803215:	8b 12                	mov    (%edx),%edx
  803217:	89 10                	mov    %edx,(%eax)
  803219:	eb 0a                	jmp    803225 <alloc_block+0x1c7>
  80321b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80321e:	8b 00                	mov    (%eax),%eax
  803220:	a3 48 50 80 00       	mov    %eax,0x805048
  803225:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803228:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80322e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803231:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803238:	a1 54 50 80 00       	mov    0x805054,%eax
  80323d:	48                   	dec    %eax
  80323e:	a3 54 50 80 00       	mov    %eax,0x805054
			// from page to freeblockList by the pageInfo and the block size.
			split_page_to_blocks(1 << (idx + LOG2_MIN_SIZE), ptr_new_page);
  803243:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803246:	83 c0 03             	add    $0x3,%eax
  803249:	ba 01 00 00 00       	mov    $0x1,%edx
  80324e:	88 c1                	mov    %al,%cl
  803250:	d3 e2                	shl    %cl,%edx
  803252:	89 d0                	mov    %edx,%eax
  803254:	83 ec 08             	sub    $0x8,%esp
  803257:	ff 75 e4             	pushl  -0x1c(%ebp)
  80325a:	50                   	push   %eax
  80325b:	e8 c0 fc ff ff       	call   802f20 <split_page_to_blocks>
  803260:	83 c4 10             	add    $0x10,%esp

			// remove from the list and updat the pageInfoArr free blocks.
			// pop from the freeBlockList.
			struct BlockElement *blk = LIST_FIRST(&freeBlockLists[idx]);
  803263:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803266:	c1 e0 04             	shl    $0x4,%eax
  803269:	05 80 d0 81 00       	add    $0x81d080,%eax
  80326e:	8b 00                	mov    (%eax),%eax
  803270:	89 45 e0             	mov    %eax,-0x20(%ebp)
		    LIST_REMOVE(&freeBlockLists[idx], blk);
  803273:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  803277:	75 17                	jne    803290 <alloc_block+0x232>
  803279:	83 ec 04             	sub    $0x4,%esp
  80327c:	68 d5 4a 80 00       	push   $0x804ad5
  803281:	68 b0 00 00 00       	push   $0xb0
  803286:	68 17 4a 80 00       	push   $0x804a17
  80328b:	e8 fc de ff ff       	call   80118c <_panic>
  803290:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803293:	8b 00                	mov    (%eax),%eax
  803295:	85 c0                	test   %eax,%eax
  803297:	74 10                	je     8032a9 <alloc_block+0x24b>
  803299:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80329c:	8b 00                	mov    (%eax),%eax
  80329e:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8032a1:	8b 52 04             	mov    0x4(%edx),%edx
  8032a4:	89 50 04             	mov    %edx,0x4(%eax)
  8032a7:	eb 14                	jmp    8032bd <alloc_block+0x25f>
  8032a9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8032ac:	8b 40 04             	mov    0x4(%eax),%eax
  8032af:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8032b2:	c1 e2 04             	shl    $0x4,%edx
  8032b5:	81 c2 84 d0 81 00    	add    $0x81d084,%edx
  8032bb:	89 02                	mov    %eax,(%edx)
  8032bd:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8032c0:	8b 40 04             	mov    0x4(%eax),%eax
  8032c3:	85 c0                	test   %eax,%eax
  8032c5:	74 0f                	je     8032d6 <alloc_block+0x278>
  8032c7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8032ca:	8b 40 04             	mov    0x4(%eax),%eax
  8032cd:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8032d0:	8b 12                	mov    (%edx),%edx
  8032d2:	89 10                	mov    %edx,(%eax)
  8032d4:	eb 13                	jmp    8032e9 <alloc_block+0x28b>
  8032d6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8032d9:	8b 00                	mov    (%eax),%eax
  8032db:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8032de:	c1 e2 04             	shl    $0x4,%edx
  8032e1:	81 c2 80 d0 81 00    	add    $0x81d080,%edx
  8032e7:	89 02                	mov    %eax,(%edx)
  8032e9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8032ec:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8032f2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8032f5:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8032fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032ff:	c1 e0 04             	shl    $0x4,%eax
  803302:	05 8c d0 81 00       	add    $0x81d08c,%eax
  803307:	8b 00                	mov    (%eax),%eax
  803309:	8d 50 ff             	lea    -0x1(%eax),%edx
  80330c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80330f:	c1 e0 04             	shl    $0x4,%eax
  803312:	05 8c d0 81 00       	add    $0x81d08c,%eax
  803317:	89 10                	mov    %edx,(%eax)
		    // update pageBlockInfoArr
		    struct PageInfoElement *pageInfo = to_page_info((uint32)blk);
  803319:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80331c:	83 ec 0c             	sub    $0xc,%esp
  80331f:	50                   	push   %eax
  803320:	e8 f5 f9 ff ff       	call   802d1a <to_page_info>
  803325:	83 c4 10             	add    $0x10,%esp
  803328:	89 45 dc             	mov    %eax,-0x24(%ebp)
		    pageInfo->num_of_free_blocks--;
  80332b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80332e:	66 8b 40 0a          	mov    0xa(%eax),%ax
  803332:	48                   	dec    %eax
  803333:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803336:	66 89 42 0a          	mov    %ax,0xa(%edx)
		    return blk;
  80333a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80333d:	e9 26 01 00 00       	jmp    803468 <alloc_block+0x40a>
		}else{//case 3: no free block and no free page so iterate and try to find bigger size.
			// iterate over the list until finding available block
			while (idx <= (LOG2_MAX_SIZE - LOG2_MIN_SIZE) && freeBlockLists[idx].size == 0) {
				idx++;
  803342:	ff 45 f4             	incl   -0xc(%ebp)
				// found free block
				if(freeBlockLists[idx].size > 0){
  803345:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803348:	c1 e0 04             	shl    $0x4,%eax
  80334b:	05 8c d0 81 00       	add    $0x81d08c,%eax
  803350:	8b 00                	mov    (%eax),%eax
  803352:	85 c0                	test   %eax,%eax
  803354:	0f 84 dc 00 00 00    	je     803436 <alloc_block+0x3d8>
					// remove from the list and updat the pageInfoArr free blocks.
					// pop from the freeBlockList.
					struct BlockElement *blk = LIST_FIRST(&freeBlockLists[idx]);
  80335a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80335d:	c1 e0 04             	shl    $0x4,%eax
  803360:	05 80 d0 81 00       	add    $0x81d080,%eax
  803365:	8b 00                	mov    (%eax),%eax
  803367:	89 45 d8             	mov    %eax,-0x28(%ebp)
				    LIST_REMOVE(&freeBlockLists[idx], blk);
  80336a:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  80336e:	75 17                	jne    803387 <alloc_block+0x329>
  803370:	83 ec 04             	sub    $0x4,%esp
  803373:	68 d5 4a 80 00       	push   $0x804ad5
  803378:	68 be 00 00 00       	push   $0xbe
  80337d:	68 17 4a 80 00       	push   $0x804a17
  803382:	e8 05 de ff ff       	call   80118c <_panic>
  803387:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80338a:	8b 00                	mov    (%eax),%eax
  80338c:	85 c0                	test   %eax,%eax
  80338e:	74 10                	je     8033a0 <alloc_block+0x342>
  803390:	8b 45 d8             	mov    -0x28(%ebp),%eax
  803393:	8b 00                	mov    (%eax),%eax
  803395:	8b 55 d8             	mov    -0x28(%ebp),%edx
  803398:	8b 52 04             	mov    0x4(%edx),%edx
  80339b:	89 50 04             	mov    %edx,0x4(%eax)
  80339e:	eb 14                	jmp    8033b4 <alloc_block+0x356>
  8033a0:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8033a3:	8b 40 04             	mov    0x4(%eax),%eax
  8033a6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8033a9:	c1 e2 04             	shl    $0x4,%edx
  8033ac:	81 c2 84 d0 81 00    	add    $0x81d084,%edx
  8033b2:	89 02                	mov    %eax,(%edx)
  8033b4:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8033b7:	8b 40 04             	mov    0x4(%eax),%eax
  8033ba:	85 c0                	test   %eax,%eax
  8033bc:	74 0f                	je     8033cd <alloc_block+0x36f>
  8033be:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8033c1:	8b 40 04             	mov    0x4(%eax),%eax
  8033c4:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8033c7:	8b 12                	mov    (%edx),%edx
  8033c9:	89 10                	mov    %edx,(%eax)
  8033cb:	eb 13                	jmp    8033e0 <alloc_block+0x382>
  8033cd:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8033d0:	8b 00                	mov    (%eax),%eax
  8033d2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8033d5:	c1 e2 04             	shl    $0x4,%edx
  8033d8:	81 c2 80 d0 81 00    	add    $0x81d080,%edx
  8033de:	89 02                	mov    %eax,(%edx)
  8033e0:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8033e3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8033e9:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8033ec:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8033f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033f6:	c1 e0 04             	shl    $0x4,%eax
  8033f9:	05 8c d0 81 00       	add    $0x81d08c,%eax
  8033fe:	8b 00                	mov    (%eax),%eax
  803400:	8d 50 ff             	lea    -0x1(%eax),%edx
  803403:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803406:	c1 e0 04             	shl    $0x4,%eax
  803409:	05 8c d0 81 00       	add    $0x81d08c,%eax
  80340e:	89 10                	mov    %edx,(%eax)
				    // update pageBlockInfoArr
				    struct PageInfoElement *pageInfo = to_page_info((uint32)blk);
  803410:	8b 45 d8             	mov    -0x28(%ebp),%eax
  803413:	83 ec 0c             	sub    $0xc,%esp
  803416:	50                   	push   %eax
  803417:	e8 fe f8 ff ff       	call   802d1a <to_page_info>
  80341c:	83 c4 10             	add    $0x10,%esp
  80341f:	89 45 d4             	mov    %eax,-0x2c(%ebp)
				    pageInfo->num_of_free_blocks--;
  803422:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803425:	66 8b 40 0a          	mov    0xa(%eax),%ax
  803429:	48                   	dec    %eax
  80342a:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  80342d:	66 89 42 0a          	mov    %ax,0xa(%edx)
				    return blk;
  803431:	8b 45 d8             	mov    -0x28(%ebp),%eax
  803434:	eb 32                	jmp    803468 <alloc_block+0x40a>
		    struct PageInfoElement *pageInfo = to_page_info((uint32)blk);
		    pageInfo->num_of_free_blocks--;
		    return blk;
		}else{//case 3: no free block and no free page so iterate and try to find bigger size.
			// iterate over the list until finding available block
			while (idx <= (LOG2_MAX_SIZE - LOG2_MIN_SIZE) && freeBlockLists[idx].size == 0) {
  803436:	83 7d f4 08          	cmpl   $0x8,-0xc(%ebp)
  80343a:	77 15                	ja     803451 <alloc_block+0x3f3>
  80343c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80343f:	c1 e0 04             	shl    $0x4,%eax
  803442:	05 8c d0 81 00       	add    $0x81d08c,%eax
  803447:	8b 00                	mov    (%eax),%eax
  803449:	85 c0                	test   %eax,%eax
  80344b:	0f 84 f1 fe ff ff    	je     803342 <alloc_block+0x2e4>
				}
			}
		}
	}
	//case4: no free blocks or pages.
	panic("no free blocks!");
  803451:	83 ec 04             	sub    $0x4,%esp
  803454:	68 f3 4a 80 00       	push   $0x804af3
  803459:	68 c8 00 00 00       	push   $0xc8
  80345e:	68 17 4a 80 00       	push   $0x804a17
  803463:	e8 24 dd ff ff       	call   80118c <_panic>
	//panic("alloc_block() Not implemented yet");
	//TODO: [PROJECT'25.BONUS#1] DYNAMIC ALLOCATOR - block if no free block
	return NULL;
}
  803468:	c9                   	leave  
  803469:	c3                   	ret    

0080346a <free_block>:

//===========================
// [4] FREE BLOCK:
//===========================
void free_block(void *va)
{
  80346a:	55                   	push   %ebp
  80346b:	89 e5                	mov    %esp,%ebp
  80346d:	83 ec 38             	sub    $0x38,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		assert((uint32)va >= dynAllocStart && (uint32)va < dynAllocEnd);
  803470:	8b 55 08             	mov    0x8(%ebp),%edx
  803473:	a1 64 d0 81 00       	mov    0x81d064,%eax
  803478:	39 c2                	cmp    %eax,%edx
  80347a:	72 0c                	jb     803488 <free_block+0x1e>
  80347c:	8b 55 08             	mov    0x8(%ebp),%edx
  80347f:	a1 40 50 80 00       	mov    0x805040,%eax
  803484:	39 c2                	cmp    %eax,%edx
  803486:	72 19                	jb     8034a1 <free_block+0x37>
  803488:	68 04 4b 80 00       	push   $0x804b04
  80348d:	68 7a 4a 80 00       	push   $0x804a7a
  803492:	68 d7 00 00 00       	push   $0xd7
  803497:	68 17 4a 80 00       	push   $0x804a17
  80349c:	e8 eb dc ff ff       	call   80118c <_panic>
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #4 free_block
	//Your code is here
	//Comment the following line
	// va of a piece in memory to free so:
	// 1. get its page, and make blk with this address to be put in the freeBlockList.
	struct BlockElement* blk_to_free = (struct BlockElement*)va;
  8034a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8034a4:	89 45 e8             	mov    %eax,-0x18(%ebp)
	struct PageInfoElement *pageInfo = to_page_info((uint32)va);
  8034a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8034aa:	83 ec 0c             	sub    $0xc,%esp
  8034ad:	50                   	push   %eax
  8034ae:	e8 67 f8 ff ff       	call   802d1a <to_page_info>
  8034b3:	83 c4 10             	add    $0x10,%esp
  8034b6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	uint32 blk_size = pageInfo->block_size;
  8034b9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8034bc:	8b 40 08             	mov    0x8(%eax),%eax
  8034bf:	0f b7 c0             	movzwl %ax,%eax
  8034c2:	89 45 e0             	mov    %eax,-0x20(%ebp)

	// its index in the freeBlocklist.
	int idx = 0;
  8034c5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int i = LOG2_MIN_SIZE; i <= LOG2_MAX_SIZE; i++) {
  8034cc:	c7 45 f0 03 00 00 00 	movl   $0x3,-0x10(%ebp)
  8034d3:	eb 19                	jmp    8034ee <free_block+0x84>
	    if ((1 << i) == blk_size)
  8034d5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8034d8:	ba 01 00 00 00       	mov    $0x1,%edx
  8034dd:	88 c1                	mov    %al,%cl
  8034df:	d3 e2                	shl    %cl,%edx
  8034e1:	89 d0                	mov    %edx,%eax
  8034e3:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8034e6:	74 0e                	je     8034f6 <free_block+0x8c>
	        break;
	    idx++;
  8034e8:	ff 45 f4             	incl   -0xc(%ebp)
	struct PageInfoElement *pageInfo = to_page_info((uint32)va);
	uint32 blk_size = pageInfo->block_size;

	// its index in the freeBlocklist.
	int idx = 0;
	for (int i = LOG2_MIN_SIZE; i <= LOG2_MAX_SIZE; i++) {
  8034eb:	ff 45 f0             	incl   -0x10(%ebp)
  8034ee:	83 7d f0 0b          	cmpl   $0xb,-0x10(%ebp)
  8034f2:	7e e1                	jle    8034d5 <free_block+0x6b>
  8034f4:	eb 01                	jmp    8034f7 <free_block+0x8d>
	    if ((1 << i) == blk_size)
	        break;
  8034f6:	90                   	nop
	    idx++;
	}

	pageInfo->num_of_free_blocks++;
  8034f7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8034fa:	66 8b 40 0a          	mov    0xa(%eax),%ax
  8034fe:	40                   	inc    %eax
  8034ff:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803502:	66 89 42 0a          	mov    %ax,0xa(%edx)
	LIST_INSERT_TAIL(&freeBlockLists[idx], blk_to_free);
  803506:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80350a:	75 17                	jne    803523 <free_block+0xb9>
  80350c:	83 ec 04             	sub    $0x4,%esp
  80350f:	68 90 4a 80 00       	push   $0x804a90
  803514:	68 ee 00 00 00       	push   $0xee
  803519:	68 17 4a 80 00       	push   $0x804a17
  80351e:	e8 69 dc ff ff       	call   80118c <_panic>
  803523:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803526:	c1 e0 04             	shl    $0x4,%eax
  803529:	05 84 d0 81 00       	add    $0x81d084,%eax
  80352e:	8b 10                	mov    (%eax),%edx
  803530:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803533:	89 50 04             	mov    %edx,0x4(%eax)
  803536:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803539:	8b 40 04             	mov    0x4(%eax),%eax
  80353c:	85 c0                	test   %eax,%eax
  80353e:	74 14                	je     803554 <free_block+0xea>
  803540:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803543:	c1 e0 04             	shl    $0x4,%eax
  803546:	05 84 d0 81 00       	add    $0x81d084,%eax
  80354b:	8b 00                	mov    (%eax),%eax
  80354d:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803550:	89 10                	mov    %edx,(%eax)
  803552:	eb 11                	jmp    803565 <free_block+0xfb>
  803554:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803557:	c1 e0 04             	shl    $0x4,%eax
  80355a:	8d 90 80 d0 81 00    	lea    0x81d080(%eax),%edx
  803560:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803563:	89 02                	mov    %eax,(%edx)
  803565:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803568:	c1 e0 04             	shl    $0x4,%eax
  80356b:	8d 90 84 d0 81 00    	lea    0x81d084(%eax),%edx
  803571:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803574:	89 02                	mov    %eax,(%edx)
  803576:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803579:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80357f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803582:	c1 e0 04             	shl    $0x4,%eax
  803585:	05 8c d0 81 00       	add    $0x81d08c,%eax
  80358a:	8b 00                	mov    (%eax),%eax
  80358c:	8d 50 01             	lea    0x1(%eax),%edx
  80358f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803592:	c1 e0 04             	shl    $0x4,%eax
  803595:	05 8c d0 81 00       	add    $0x81d08c,%eax
  80359a:	89 10                	mov    %edx,(%eax)

	// now, case 1: the page all blocks are freed so you free the page.
	int blk_count = PAGE_SIZE / blk_size;
  80359c:	b8 00 10 00 00       	mov    $0x1000,%eax
  8035a1:	ba 00 00 00 00       	mov    $0x0,%edx
  8035a6:	f7 75 e0             	divl   -0x20(%ebp)
  8035a9:	89 45 dc             	mov    %eax,-0x24(%ebp)
	// the blk count in the page is same as number fo free blocks free up the page.
	if (pageInfo->num_of_free_blocks == blk_count) {
  8035ac:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8035af:	66 8b 40 0a          	mov    0xa(%eax),%ax
  8035b3:	0f b7 c0             	movzwl %ax,%eax
  8035b6:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  8035b9:	0f 85 70 01 00 00    	jne    80372f <free_block+0x2c5>
		uint32 page_va = to_page_va(pageInfo);
  8035bf:	83 ec 0c             	sub    $0xc,%esp
  8035c2:	ff 75 e4             	pushl  -0x1c(%ebp)
  8035c5:	e8 de f6 ff ff       	call   802ca8 <to_page_va>
  8035ca:	83 c4 10             	add    $0x10,%esp
  8035cd:	89 45 d8             	mov    %eax,-0x28(%ebp)
		// remove all blk in the freeBlockList.
		for (uint32 off = 0; off < PAGE_SIZE; off += blk_size) {
  8035d0:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  8035d7:	e9 b7 00 00 00       	jmp    803693 <free_block+0x229>
			struct BlockElement *blk = (struct BlockElement*)(page_va + off);
  8035dc:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8035df:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8035e2:	01 d0                	add    %edx,%eax
  8035e4:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			LIST_REMOVE(&freeBlockLists[idx], blk);
  8035e7:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8035eb:	75 17                	jne    803604 <free_block+0x19a>
  8035ed:	83 ec 04             	sub    $0x4,%esp
  8035f0:	68 d5 4a 80 00       	push   $0x804ad5
  8035f5:	68 f8 00 00 00       	push   $0xf8
  8035fa:	68 17 4a 80 00       	push   $0x804a17
  8035ff:	e8 88 db ff ff       	call   80118c <_panic>
  803604:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803607:	8b 00                	mov    (%eax),%eax
  803609:	85 c0                	test   %eax,%eax
  80360b:	74 10                	je     80361d <free_block+0x1b3>
  80360d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803610:	8b 00                	mov    (%eax),%eax
  803612:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803615:	8b 52 04             	mov    0x4(%edx),%edx
  803618:	89 50 04             	mov    %edx,0x4(%eax)
  80361b:	eb 14                	jmp    803631 <free_block+0x1c7>
  80361d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803620:	8b 40 04             	mov    0x4(%eax),%eax
  803623:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803626:	c1 e2 04             	shl    $0x4,%edx
  803629:	81 c2 84 d0 81 00    	add    $0x81d084,%edx
  80362f:	89 02                	mov    %eax,(%edx)
  803631:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803634:	8b 40 04             	mov    0x4(%eax),%eax
  803637:	85 c0                	test   %eax,%eax
  803639:	74 0f                	je     80364a <free_block+0x1e0>
  80363b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80363e:	8b 40 04             	mov    0x4(%eax),%eax
  803641:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803644:	8b 12                	mov    (%edx),%edx
  803646:	89 10                	mov    %edx,(%eax)
  803648:	eb 13                	jmp    80365d <free_block+0x1f3>
  80364a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80364d:	8b 00                	mov    (%eax),%eax
  80364f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803652:	c1 e2 04             	shl    $0x4,%edx
  803655:	81 c2 80 d0 81 00    	add    $0x81d080,%edx
  80365b:	89 02                	mov    %eax,(%edx)
  80365d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803660:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803666:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803669:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803670:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803673:	c1 e0 04             	shl    $0x4,%eax
  803676:	05 8c d0 81 00       	add    $0x81d08c,%eax
  80367b:	8b 00                	mov    (%eax),%eax
  80367d:	8d 50 ff             	lea    -0x1(%eax),%edx
  803680:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803683:	c1 e0 04             	shl    $0x4,%eax
  803686:	05 8c d0 81 00       	add    $0x81d08c,%eax
  80368b:	89 10                	mov    %edx,(%eax)
	int blk_count = PAGE_SIZE / blk_size;
	// the blk count in the page is same as number fo free blocks free up the page.
	if (pageInfo->num_of_free_blocks == blk_count) {
		uint32 page_va = to_page_va(pageInfo);
		// remove all blk in the freeBlockList.
		for (uint32 off = 0; off < PAGE_SIZE; off += blk_size) {
  80368d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803690:	01 45 ec             	add    %eax,-0x14(%ebp)
  803693:	81 7d ec ff 0f 00 00 	cmpl   $0xfff,-0x14(%ebp)
  80369a:	0f 86 3c ff ff ff    	jbe    8035dc <free_block+0x172>
			struct BlockElement *blk = (struct BlockElement*)(page_va + off);
			LIST_REMOVE(&freeBlockLists[idx], blk);
		}
		// reset page info.
		pageInfo->block_size = 0;
  8036a0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8036a3:	66 c7 40 08 00 00    	movw   $0x0,0x8(%eax)
		pageInfo->num_of_free_blocks = 0;
  8036a9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8036ac:	66 c7 40 0a 00 00    	movw   $0x0,0xa(%eax)
		// add it to the available pages.
		LIST_INSERT_TAIL(&freePagesList, pageInfo);
  8036b2:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8036b6:	75 17                	jne    8036cf <free_block+0x265>
  8036b8:	83 ec 04             	sub    $0x4,%esp
  8036bb:	68 90 4a 80 00       	push   $0x804a90
  8036c0:	68 fe 00 00 00       	push   $0xfe
  8036c5:	68 17 4a 80 00       	push   $0x804a17
  8036ca:	e8 bd da ff ff       	call   80118c <_panic>
  8036cf:	8b 15 4c 50 80 00    	mov    0x80504c,%edx
  8036d5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8036d8:	89 50 04             	mov    %edx,0x4(%eax)
  8036db:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8036de:	8b 40 04             	mov    0x4(%eax),%eax
  8036e1:	85 c0                	test   %eax,%eax
  8036e3:	74 0c                	je     8036f1 <free_block+0x287>
  8036e5:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8036ea:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8036ed:	89 10                	mov    %edx,(%eax)
  8036ef:	eb 08                	jmp    8036f9 <free_block+0x28f>
  8036f1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8036f4:	a3 48 50 80 00       	mov    %eax,0x805048
  8036f9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8036fc:	a3 4c 50 80 00       	mov    %eax,0x80504c
  803701:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803704:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80370a:	a1 54 50 80 00       	mov    0x805054,%eax
  80370f:	40                   	inc    %eax
  803710:	a3 54 50 80 00       	mov    %eax,0x805054
		// make it available in memory.
		return_page((uint32 *)to_page_va(pageInfo));
  803715:	83 ec 0c             	sub    $0xc,%esp
  803718:	ff 75 e4             	pushl  -0x1c(%ebp)
  80371b:	e8 88 f5 ff ff       	call   802ca8 <to_page_va>
  803720:	83 c4 10             	add    $0x10,%esp
  803723:	83 ec 0c             	sub    $0xc,%esp
  803726:	50                   	push   %eax
  803727:	e8 b8 ee ff ff       	call   8025e4 <return_page>
  80372c:	83 c4 10             	add    $0x10,%esp
	}
	//panic("free_block() Not implemented yet");
}
  80372f:	90                   	nop
  803730:	c9                   	leave  
  803731:	c3                   	ret    

00803732 <realloc_block>:

//===========================
// [1] REALLOCATE BLOCK:
//===========================
void *realloc_block(void* va, uint32 new_size)
{
  803732:	55                   	push   %ebp
  803733:	89 e5                	mov    %esp,%ebp
  803735:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.BONUS#2] KERNEL REALLOC - realloc_block
	//Your code is here
	//Comment the following line
	panic("realloc_block() Not implemented yet");
  803738:	83 ec 04             	sub    $0x4,%esp
  80373b:	68 3c 4b 80 00       	push   $0x804b3c
  803740:	68 11 01 00 00       	push   $0x111
  803745:	68 17 4a 80 00       	push   $0x804a17
  80374a:	e8 3d da ff ff       	call   80118c <_panic>

0080374f <create_semaphore>:
// User-level Semaphore

#include "inc/lib.h"

struct semaphore create_semaphore(char *semaphoreName, uint32 value)
{
  80374f:	55                   	push   %ebp
  803750:	89 e5                	mov    %esp,%ebp
  803752:	83 ec 08             	sub    $0x8,%esp
	panic("create_semaphore() is not implemented yet...!!");
  803755:	83 ec 04             	sub    $0x4,%esp
  803758:	68 60 4b 80 00       	push   $0x804b60
  80375d:	6a 07                	push   $0x7
  80375f:	68 8f 4b 80 00       	push   $0x804b8f
  803764:	e8 23 da ff ff       	call   80118c <_panic>

00803769 <get_semaphore>:
}
struct semaphore get_semaphore(int32 ownerEnvID, char* semaphoreName)
{
  803769:	55                   	push   %ebp
  80376a:	89 e5                	mov    %esp,%ebp
  80376c:	83 ec 08             	sub    $0x8,%esp
	panic("get_semaphore() is not implemented yet...!!");
  80376f:	83 ec 04             	sub    $0x4,%esp
  803772:	68 a0 4b 80 00       	push   $0x804ba0
  803777:	6a 0b                	push   $0xb
  803779:	68 8f 4b 80 00       	push   $0x804b8f
  80377e:	e8 09 da ff ff       	call   80118c <_panic>

00803783 <wait_semaphore>:
}

void wait_semaphore(struct semaphore sem)
{
  803783:	55                   	push   %ebp
  803784:	89 e5                	mov    %esp,%ebp
  803786:	83 ec 08             	sub    $0x8,%esp
	panic("wait_semaphore() is not implemented yet...!!");
  803789:	83 ec 04             	sub    $0x4,%esp
  80378c:	68 cc 4b 80 00       	push   $0x804bcc
  803791:	6a 10                	push   $0x10
  803793:	68 8f 4b 80 00       	push   $0x804b8f
  803798:	e8 ef d9 ff ff       	call   80118c <_panic>

0080379d <signal_semaphore>:
}

void signal_semaphore(struct semaphore sem)
{
  80379d:	55                   	push   %ebp
  80379e:	89 e5                	mov    %esp,%ebp
  8037a0:	83 ec 08             	sub    $0x8,%esp
	panic("signal_semaphore() is not implemented yet...!!");
  8037a3:	83 ec 04             	sub    $0x4,%esp
  8037a6:	68 fc 4b 80 00       	push   $0x804bfc
  8037ab:	6a 15                	push   $0x15
  8037ad:	68 8f 4b 80 00       	push   $0x804b8f
  8037b2:	e8 d5 d9 ff ff       	call   80118c <_panic>

008037b7 <semaphore_count>:
}

int semaphore_count(struct semaphore sem)
{
  8037b7:	55                   	push   %ebp
  8037b8:	89 e5                	mov    %esp,%ebp
	return sem.semdata->count;
  8037ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8037bd:	8b 40 10             	mov    0x10(%eax),%eax
}
  8037c0:	5d                   	pop    %ebp
  8037c1:	c3                   	ret    

008037c2 <env_sleep>:
#include <inc/lib.h>
#include <inc/timerreg.h>

void
env_sleep(uint32 approxMilliSeconds)
{
  8037c2:	55                   	push   %ebp
  8037c3:	89 e5                	mov    %esp,%ebp
  8037c5:	83 ec 30             	sub    $0x30,%esp
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
  8037c8:	8b 55 08             	mov    0x8(%ebp),%edx
  8037cb:	89 d0                	mov    %edx,%eax
  8037cd:	c1 e0 02             	shl    $0x2,%eax
  8037d0:	01 d0                	add    %edx,%eax
  8037d2:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8037d9:	01 d0                	add    %edx,%eax
  8037db:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8037e2:	01 d0                	add    %edx,%eax
  8037e4:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8037eb:	01 d0                	add    %edx,%eax
  8037ed:	c1 e0 04             	shl    $0x4,%eax
  8037f0:	89 45 f8             	mov    %eax,-0x8(%ebp)
	uint32 cycles_counter =0;
  8037f3:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)

static inline __attribute__((always_inline)) struct uint64 get_virtual_time_user()
{
	struct uint64 result;

	__asm __volatile("rdtsc\n"
  8037fa:	0f 31                	rdtsc  
  8037fc:	89 45 e8             	mov    %eax,-0x18(%ebp)
  8037ff:	89 55 ec             	mov    %edx,-0x14(%ebp)
	: "=a" (result.low), "=d" (result.hi)
	);

	return result;
  803802:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803805:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803808:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80380b:	89 55 f4             	mov    %edx,-0xc(%ebp)

	/*2024*/ //USE A USER-SIDE VERSION OF THIS FUNCTION TO AVOID SLOW-DOWN THE PERFORMANCE DUE SYS_CALL (el7 :))
	//struct uint64 baseTime = sys_get_virtual_time() ;
	struct uint64 baseTime = get_virtual_time_user() ;
	while(cycles_counter<time_in_cycles)
  80380e:	eb 46                	jmp    803856 <env_sleep+0x94>

static inline __attribute__((always_inline)) struct uint64 get_virtual_time_user()
{
	struct uint64 result;

	__asm __volatile("rdtsc\n"
  803810:	0f 31                	rdtsc  
  803812:	89 45 d0             	mov    %eax,-0x30(%ebp)
  803815:	89 55 d4             	mov    %edx,-0x2c(%ebp)
	: "=a" (result.low), "=d" (result.hi)
	);

	return result;
  803818:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80381b:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  80381e:	89 45 e0             	mov    %eax,-0x20(%ebp)
  803821:	89 55 e4             	mov    %edx,-0x1c(%ebp)

		// update the cycles_count
		#define M32 0xffffffff
		// subtract basetime from current time
		struct uint64 res;
		res.low = (currentTime.low - baseTime.low) & M32;
  803824:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803827:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80382a:	29 c2                	sub    %eax,%edx
  80382c:	89 d0                	mov    %edx,%eax
  80382e:	89 45 d8             	mov    %eax,-0x28(%ebp)
		res.hi = (currentTime.hi - baseTime.hi - (res.low > currentTime.low)) & M32;
  803831:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803834:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803837:	89 d1                	mov    %edx,%ecx
  803839:	29 c1                	sub    %eax,%ecx
  80383b:	8b 55 d8             	mov    -0x28(%ebp),%edx
  80383e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803841:	39 c2                	cmp    %eax,%edx
  803843:	0f 97 c0             	seta   %al
  803846:	0f b6 c0             	movzbl %al,%eax
  803849:	29 c1                	sub    %eax,%ecx
  80384b:	89 c8                	mov    %ecx,%eax
  80384d:	89 45 dc             	mov    %eax,-0x24(%ebp)

		//update cycles_count with result
		cycles_counter = res.low;
  803850:	8b 45 d8             	mov    -0x28(%ebp),%eax
  803853:	89 45 fc             	mov    %eax,-0x4(%ebp)
	uint32 cycles_counter =0;

	/*2024*/ //USE A USER-SIDE VERSION OF THIS FUNCTION TO AVOID SLOW-DOWN THE PERFORMANCE DUE SYS_CALL (el7 :))
	//struct uint64 baseTime = sys_get_virtual_time() ;
	struct uint64 baseTime = get_virtual_time_user() ;
	while(cycles_counter<time_in_cycles)
  803856:	8b 45 fc             	mov    -0x4(%ebp),%eax
  803859:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  80385c:	72 b2                	jb     803810 <env_sleep+0x4e>
//				,cycles_counter
//				);
	}
	//cprintf("%s [%d] wake up now!\n", myEnv->prog_name, myEnv->env_id);

}
  80385e:	90                   	nop
  80385f:	c9                   	leave  
  803860:	c3                   	ret    

00803861 <busy_wait>:

//2017
uint32 busy_wait(uint32 loopMax)
{
  803861:	55                   	push   %ebp
  803862:	89 e5                	mov    %esp,%ebp
  803864:	83 ec 10             	sub    $0x10,%esp
	uint32 i = 0 ;
  803867:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	while (i < loopMax) i++;
  80386e:	eb 03                	jmp    803873 <busy_wait+0x12>
  803870:	ff 45 fc             	incl   -0x4(%ebp)
  803873:	8b 45 fc             	mov    -0x4(%ebp),%eax
  803876:	3b 45 08             	cmp    0x8(%ebp),%eax
  803879:	72 f5                	jb     803870 <busy_wait+0xf>
	return i;
  80387b:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  80387e:	c9                   	leave  
  80387f:	c3                   	ret    

00803880 <__udivdi3>:
  803880:	55                   	push   %ebp
  803881:	57                   	push   %edi
  803882:	56                   	push   %esi
  803883:	53                   	push   %ebx
  803884:	83 ec 1c             	sub    $0x1c,%esp
  803887:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  80388b:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  80388f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803893:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803897:	89 ca                	mov    %ecx,%edx
  803899:	89 f8                	mov    %edi,%eax
  80389b:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  80389f:	85 f6                	test   %esi,%esi
  8038a1:	75 2d                	jne    8038d0 <__udivdi3+0x50>
  8038a3:	39 cf                	cmp    %ecx,%edi
  8038a5:	77 65                	ja     80390c <__udivdi3+0x8c>
  8038a7:	89 fd                	mov    %edi,%ebp
  8038a9:	85 ff                	test   %edi,%edi
  8038ab:	75 0b                	jne    8038b8 <__udivdi3+0x38>
  8038ad:	b8 01 00 00 00       	mov    $0x1,%eax
  8038b2:	31 d2                	xor    %edx,%edx
  8038b4:	f7 f7                	div    %edi
  8038b6:	89 c5                	mov    %eax,%ebp
  8038b8:	31 d2                	xor    %edx,%edx
  8038ba:	89 c8                	mov    %ecx,%eax
  8038bc:	f7 f5                	div    %ebp
  8038be:	89 c1                	mov    %eax,%ecx
  8038c0:	89 d8                	mov    %ebx,%eax
  8038c2:	f7 f5                	div    %ebp
  8038c4:	89 cf                	mov    %ecx,%edi
  8038c6:	89 fa                	mov    %edi,%edx
  8038c8:	83 c4 1c             	add    $0x1c,%esp
  8038cb:	5b                   	pop    %ebx
  8038cc:	5e                   	pop    %esi
  8038cd:	5f                   	pop    %edi
  8038ce:	5d                   	pop    %ebp
  8038cf:	c3                   	ret    
  8038d0:	39 ce                	cmp    %ecx,%esi
  8038d2:	77 28                	ja     8038fc <__udivdi3+0x7c>
  8038d4:	0f bd fe             	bsr    %esi,%edi
  8038d7:	83 f7 1f             	xor    $0x1f,%edi
  8038da:	75 40                	jne    80391c <__udivdi3+0x9c>
  8038dc:	39 ce                	cmp    %ecx,%esi
  8038de:	72 0a                	jb     8038ea <__udivdi3+0x6a>
  8038e0:	3b 44 24 08          	cmp    0x8(%esp),%eax
  8038e4:	0f 87 9e 00 00 00    	ja     803988 <__udivdi3+0x108>
  8038ea:	b8 01 00 00 00       	mov    $0x1,%eax
  8038ef:	89 fa                	mov    %edi,%edx
  8038f1:	83 c4 1c             	add    $0x1c,%esp
  8038f4:	5b                   	pop    %ebx
  8038f5:	5e                   	pop    %esi
  8038f6:	5f                   	pop    %edi
  8038f7:	5d                   	pop    %ebp
  8038f8:	c3                   	ret    
  8038f9:	8d 76 00             	lea    0x0(%esi),%esi
  8038fc:	31 ff                	xor    %edi,%edi
  8038fe:	31 c0                	xor    %eax,%eax
  803900:	89 fa                	mov    %edi,%edx
  803902:	83 c4 1c             	add    $0x1c,%esp
  803905:	5b                   	pop    %ebx
  803906:	5e                   	pop    %esi
  803907:	5f                   	pop    %edi
  803908:	5d                   	pop    %ebp
  803909:	c3                   	ret    
  80390a:	66 90                	xchg   %ax,%ax
  80390c:	89 d8                	mov    %ebx,%eax
  80390e:	f7 f7                	div    %edi
  803910:	31 ff                	xor    %edi,%edi
  803912:	89 fa                	mov    %edi,%edx
  803914:	83 c4 1c             	add    $0x1c,%esp
  803917:	5b                   	pop    %ebx
  803918:	5e                   	pop    %esi
  803919:	5f                   	pop    %edi
  80391a:	5d                   	pop    %ebp
  80391b:	c3                   	ret    
  80391c:	bd 20 00 00 00       	mov    $0x20,%ebp
  803921:	89 eb                	mov    %ebp,%ebx
  803923:	29 fb                	sub    %edi,%ebx
  803925:	89 f9                	mov    %edi,%ecx
  803927:	d3 e6                	shl    %cl,%esi
  803929:	89 c5                	mov    %eax,%ebp
  80392b:	88 d9                	mov    %bl,%cl
  80392d:	d3 ed                	shr    %cl,%ebp
  80392f:	89 e9                	mov    %ebp,%ecx
  803931:	09 f1                	or     %esi,%ecx
  803933:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  803937:	89 f9                	mov    %edi,%ecx
  803939:	d3 e0                	shl    %cl,%eax
  80393b:	89 c5                	mov    %eax,%ebp
  80393d:	89 d6                	mov    %edx,%esi
  80393f:	88 d9                	mov    %bl,%cl
  803941:	d3 ee                	shr    %cl,%esi
  803943:	89 f9                	mov    %edi,%ecx
  803945:	d3 e2                	shl    %cl,%edx
  803947:	8b 44 24 08          	mov    0x8(%esp),%eax
  80394b:	88 d9                	mov    %bl,%cl
  80394d:	d3 e8                	shr    %cl,%eax
  80394f:	09 c2                	or     %eax,%edx
  803951:	89 d0                	mov    %edx,%eax
  803953:	89 f2                	mov    %esi,%edx
  803955:	f7 74 24 0c          	divl   0xc(%esp)
  803959:	89 d6                	mov    %edx,%esi
  80395b:	89 c3                	mov    %eax,%ebx
  80395d:	f7 e5                	mul    %ebp
  80395f:	39 d6                	cmp    %edx,%esi
  803961:	72 19                	jb     80397c <__udivdi3+0xfc>
  803963:	74 0b                	je     803970 <__udivdi3+0xf0>
  803965:	89 d8                	mov    %ebx,%eax
  803967:	31 ff                	xor    %edi,%edi
  803969:	e9 58 ff ff ff       	jmp    8038c6 <__udivdi3+0x46>
  80396e:	66 90                	xchg   %ax,%ax
  803970:	8b 54 24 08          	mov    0x8(%esp),%edx
  803974:	89 f9                	mov    %edi,%ecx
  803976:	d3 e2                	shl    %cl,%edx
  803978:	39 c2                	cmp    %eax,%edx
  80397a:	73 e9                	jae    803965 <__udivdi3+0xe5>
  80397c:	8d 43 ff             	lea    -0x1(%ebx),%eax
  80397f:	31 ff                	xor    %edi,%edi
  803981:	e9 40 ff ff ff       	jmp    8038c6 <__udivdi3+0x46>
  803986:	66 90                	xchg   %ax,%ax
  803988:	31 c0                	xor    %eax,%eax
  80398a:	e9 37 ff ff ff       	jmp    8038c6 <__udivdi3+0x46>
  80398f:	90                   	nop

00803990 <__umoddi3>:
  803990:	55                   	push   %ebp
  803991:	57                   	push   %edi
  803992:	56                   	push   %esi
  803993:	53                   	push   %ebx
  803994:	83 ec 1c             	sub    $0x1c,%esp
  803997:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  80399b:	8b 74 24 34          	mov    0x34(%esp),%esi
  80399f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8039a3:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8039a7:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8039ab:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8039af:	89 f3                	mov    %esi,%ebx
  8039b1:	89 fa                	mov    %edi,%edx
  8039b3:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8039b7:	89 34 24             	mov    %esi,(%esp)
  8039ba:	85 c0                	test   %eax,%eax
  8039bc:	75 1a                	jne    8039d8 <__umoddi3+0x48>
  8039be:	39 f7                	cmp    %esi,%edi
  8039c0:	0f 86 a2 00 00 00    	jbe    803a68 <__umoddi3+0xd8>
  8039c6:	89 c8                	mov    %ecx,%eax
  8039c8:	89 f2                	mov    %esi,%edx
  8039ca:	f7 f7                	div    %edi
  8039cc:	89 d0                	mov    %edx,%eax
  8039ce:	31 d2                	xor    %edx,%edx
  8039d0:	83 c4 1c             	add    $0x1c,%esp
  8039d3:	5b                   	pop    %ebx
  8039d4:	5e                   	pop    %esi
  8039d5:	5f                   	pop    %edi
  8039d6:	5d                   	pop    %ebp
  8039d7:	c3                   	ret    
  8039d8:	39 f0                	cmp    %esi,%eax
  8039da:	0f 87 ac 00 00 00    	ja     803a8c <__umoddi3+0xfc>
  8039e0:	0f bd e8             	bsr    %eax,%ebp
  8039e3:	83 f5 1f             	xor    $0x1f,%ebp
  8039e6:	0f 84 ac 00 00 00    	je     803a98 <__umoddi3+0x108>
  8039ec:	bf 20 00 00 00       	mov    $0x20,%edi
  8039f1:	29 ef                	sub    %ebp,%edi
  8039f3:	89 fe                	mov    %edi,%esi
  8039f5:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8039f9:	89 e9                	mov    %ebp,%ecx
  8039fb:	d3 e0                	shl    %cl,%eax
  8039fd:	89 d7                	mov    %edx,%edi
  8039ff:	89 f1                	mov    %esi,%ecx
  803a01:	d3 ef                	shr    %cl,%edi
  803a03:	09 c7                	or     %eax,%edi
  803a05:	89 e9                	mov    %ebp,%ecx
  803a07:	d3 e2                	shl    %cl,%edx
  803a09:	89 14 24             	mov    %edx,(%esp)
  803a0c:	89 d8                	mov    %ebx,%eax
  803a0e:	d3 e0                	shl    %cl,%eax
  803a10:	89 c2                	mov    %eax,%edx
  803a12:	8b 44 24 08          	mov    0x8(%esp),%eax
  803a16:	d3 e0                	shl    %cl,%eax
  803a18:	89 44 24 04          	mov    %eax,0x4(%esp)
  803a1c:	8b 44 24 08          	mov    0x8(%esp),%eax
  803a20:	89 f1                	mov    %esi,%ecx
  803a22:	d3 e8                	shr    %cl,%eax
  803a24:	09 d0                	or     %edx,%eax
  803a26:	d3 eb                	shr    %cl,%ebx
  803a28:	89 da                	mov    %ebx,%edx
  803a2a:	f7 f7                	div    %edi
  803a2c:	89 d3                	mov    %edx,%ebx
  803a2e:	f7 24 24             	mull   (%esp)
  803a31:	89 c6                	mov    %eax,%esi
  803a33:	89 d1                	mov    %edx,%ecx
  803a35:	39 d3                	cmp    %edx,%ebx
  803a37:	0f 82 87 00 00 00    	jb     803ac4 <__umoddi3+0x134>
  803a3d:	0f 84 91 00 00 00    	je     803ad4 <__umoddi3+0x144>
  803a43:	8b 54 24 04          	mov    0x4(%esp),%edx
  803a47:	29 f2                	sub    %esi,%edx
  803a49:	19 cb                	sbb    %ecx,%ebx
  803a4b:	89 d8                	mov    %ebx,%eax
  803a4d:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803a51:	d3 e0                	shl    %cl,%eax
  803a53:	89 e9                	mov    %ebp,%ecx
  803a55:	d3 ea                	shr    %cl,%edx
  803a57:	09 d0                	or     %edx,%eax
  803a59:	89 e9                	mov    %ebp,%ecx
  803a5b:	d3 eb                	shr    %cl,%ebx
  803a5d:	89 da                	mov    %ebx,%edx
  803a5f:	83 c4 1c             	add    $0x1c,%esp
  803a62:	5b                   	pop    %ebx
  803a63:	5e                   	pop    %esi
  803a64:	5f                   	pop    %edi
  803a65:	5d                   	pop    %ebp
  803a66:	c3                   	ret    
  803a67:	90                   	nop
  803a68:	89 fd                	mov    %edi,%ebp
  803a6a:	85 ff                	test   %edi,%edi
  803a6c:	75 0b                	jne    803a79 <__umoddi3+0xe9>
  803a6e:	b8 01 00 00 00       	mov    $0x1,%eax
  803a73:	31 d2                	xor    %edx,%edx
  803a75:	f7 f7                	div    %edi
  803a77:	89 c5                	mov    %eax,%ebp
  803a79:	89 f0                	mov    %esi,%eax
  803a7b:	31 d2                	xor    %edx,%edx
  803a7d:	f7 f5                	div    %ebp
  803a7f:	89 c8                	mov    %ecx,%eax
  803a81:	f7 f5                	div    %ebp
  803a83:	89 d0                	mov    %edx,%eax
  803a85:	e9 44 ff ff ff       	jmp    8039ce <__umoddi3+0x3e>
  803a8a:	66 90                	xchg   %ax,%ax
  803a8c:	89 c8                	mov    %ecx,%eax
  803a8e:	89 f2                	mov    %esi,%edx
  803a90:	83 c4 1c             	add    $0x1c,%esp
  803a93:	5b                   	pop    %ebx
  803a94:	5e                   	pop    %esi
  803a95:	5f                   	pop    %edi
  803a96:	5d                   	pop    %ebp
  803a97:	c3                   	ret    
  803a98:	3b 04 24             	cmp    (%esp),%eax
  803a9b:	72 06                	jb     803aa3 <__umoddi3+0x113>
  803a9d:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803aa1:	77 0f                	ja     803ab2 <__umoddi3+0x122>
  803aa3:	89 f2                	mov    %esi,%edx
  803aa5:	29 f9                	sub    %edi,%ecx
  803aa7:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  803aab:	89 14 24             	mov    %edx,(%esp)
  803aae:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803ab2:	8b 44 24 04          	mov    0x4(%esp),%eax
  803ab6:	8b 14 24             	mov    (%esp),%edx
  803ab9:	83 c4 1c             	add    $0x1c,%esp
  803abc:	5b                   	pop    %ebx
  803abd:	5e                   	pop    %esi
  803abe:	5f                   	pop    %edi
  803abf:	5d                   	pop    %ebp
  803ac0:	c3                   	ret    
  803ac1:	8d 76 00             	lea    0x0(%esi),%esi
  803ac4:	2b 04 24             	sub    (%esp),%eax
  803ac7:	19 fa                	sbb    %edi,%edx
  803ac9:	89 d1                	mov    %edx,%ecx
  803acb:	89 c6                	mov    %eax,%esi
  803acd:	e9 71 ff ff ff       	jmp    803a43 <__umoddi3+0xb3>
  803ad2:	66 90                	xchg   %ax,%ax
  803ad4:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803ad8:	72 ea                	jb     803ac4 <__umoddi3+0x134>
  803ada:	89 d9                	mov    %ebx,%ecx
  803adc:	e9 62 ff ff ff       	jmp    803a43 <__umoddi3+0xb3>
