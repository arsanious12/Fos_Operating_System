
obj/user/tst_ksemaphore_2master:     file format elf32-i386


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
  800031:	e8 a8 02 00 00       	call   8002de <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
// Master program: take user input, create the semaphores, run slaves and wait them to finish
#include <inc/lib.h>

void
_main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	57                   	push   %edi
  80003c:	56                   	push   %esi
  80003d:	53                   	push   %ebx
  80003e:	81 ec 6c 02 00 00    	sub    $0x26c,%esp
	int envID = sys_getenvid();
  800044:	e8 cf 1a 00 00       	call   801b18 <sys_getenvid>
  800049:	89 45 e0             	mov    %eax,-0x20(%ebp)
	char line[256] ;
	readline("Enter total number of customers: ", line) ;
  80004c:	83 ec 08             	sub    $0x8,%esp
  80004f:	8d 85 d4 fe ff ff    	lea    -0x12c(%ebp),%eax
  800055:	50                   	push   %eax
  800056:	68 60 21 80 00       	push   $0x802160
  80005b:	e8 d5 0d 00 00       	call   800e35 <readline>
  800060:	83 c4 10             	add    $0x10,%esp
	int totalNumOfCusts = strtol(line, NULL, 10);
  800063:	83 ec 04             	sub    $0x4,%esp
  800066:	6a 0a                	push   $0xa
  800068:	6a 00                	push   $0x0
  80006a:	8d 85 d4 fe ff ff    	lea    -0x12c(%ebp),%eax
  800070:	50                   	push   %eax
  800071:	e8 d6 13 00 00       	call   80144c <strtol>
  800076:	83 c4 10             	add    $0x10,%esp
  800079:	89 45 dc             	mov    %eax,-0x24(%ebp)
	readline("Enter shop capacity: ", line) ;
  80007c:	83 ec 08             	sub    $0x8,%esp
  80007f:	8d 85 d4 fe ff ff    	lea    -0x12c(%ebp),%eax
  800085:	50                   	push   %eax
  800086:	68 82 21 80 00       	push   $0x802182
  80008b:	e8 a5 0d 00 00       	call   800e35 <readline>
  800090:	83 c4 10             	add    $0x10,%esp
	int shopCapacity = strtol(line, NULL, 10);
  800093:	83 ec 04             	sub    $0x4,%esp
  800096:	6a 0a                	push   $0xa
  800098:	6a 00                	push   $0x0
  80009a:	8d 85 d4 fe ff ff    	lea    -0x12c(%ebp),%eax
  8000a0:	50                   	push   %eax
  8000a1:	e8 a6 13 00 00       	call   80144c <strtol>
  8000a6:	83 c4 10             	add    $0x10,%esp
  8000a9:	89 45 d8             	mov    %eax,-0x28(%ebp)

	int semVal ;
	//Initialize the kernel semaphores
	char initCmd1[64] = "__KSem@0@Init";
  8000ac:	8d 85 90 fe ff ff    	lea    -0x170(%ebp),%eax
  8000b2:	bb a5 22 80 00       	mov    $0x8022a5,%ebx
  8000b7:	ba 0e 00 00 00       	mov    $0xe,%edx
  8000bc:	89 c7                	mov    %eax,%edi
  8000be:	89 de                	mov    %ebx,%esi
  8000c0:	89 d1                	mov    %edx,%ecx
  8000c2:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  8000c4:	8d 95 9e fe ff ff    	lea    -0x162(%ebp),%edx
  8000ca:	b9 32 00 00 00       	mov    $0x32,%ecx
  8000cf:	b0 00                	mov    $0x0,%al
  8000d1:	89 d7                	mov    %edx,%edi
  8000d3:	f3 aa                	rep stos %al,%es:(%edi)
	char initCmd2[64] = "__KSem@1@Init";
  8000d5:	8d 85 50 fe ff ff    	lea    -0x1b0(%ebp),%eax
  8000db:	bb e5 22 80 00       	mov    $0x8022e5,%ebx
  8000e0:	ba 0e 00 00 00       	mov    $0xe,%edx
  8000e5:	89 c7                	mov    %eax,%edi
  8000e7:	89 de                	mov    %ebx,%esi
  8000e9:	89 d1                	mov    %edx,%ecx
  8000eb:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  8000ed:	8d 95 5e fe ff ff    	lea    -0x1a2(%ebp),%edx
  8000f3:	b9 32 00 00 00       	mov    $0x32,%ecx
  8000f8:	b0 00                	mov    $0x0,%al
  8000fa:	89 d7                	mov    %edx,%edi
  8000fc:	f3 aa                	rep stos %al,%es:(%edi)
	semVal = shopCapacity;
  8000fe:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800101:	89 85 d0 fe ff ff    	mov    %eax,-0x130(%ebp)
	sys_utilities(initCmd1, (uint32)(&semVal));
  800107:	8d 85 d0 fe ff ff    	lea    -0x130(%ebp),%eax
  80010d:	83 ec 08             	sub    $0x8,%esp
  800110:	50                   	push   %eax
  800111:	8d 85 90 fe ff ff    	lea    -0x170(%ebp),%eax
  800117:	50                   	push   %eax
  800118:	e8 4a 1c 00 00       	call   801d67 <sys_utilities>
  80011d:	83 c4 10             	add    $0x10,%esp
	semVal = 0;
  800120:	c7 85 d0 fe ff ff 00 	movl   $0x0,-0x130(%ebp)
  800127:	00 00 00 
	sys_utilities(initCmd2, (uint32)(&semVal));
  80012a:	8d 85 d0 fe ff ff    	lea    -0x130(%ebp),%eax
  800130:	83 ec 08             	sub    $0x8,%esp
  800133:	50                   	push   %eax
  800134:	8d 85 50 fe ff ff    	lea    -0x1b0(%ebp),%eax
  80013a:	50                   	push   %eax
  80013b:	e8 27 1c 00 00       	call   801d67 <sys_utilities>
  800140:	83 c4 10             	add    $0x10,%esp

	int i = 0 ;
  800143:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	int id ;
	for (; i<totalNumOfCusts; i++)
  80014a:	eb 61                	jmp    8001ad <_main+0x175>
	{
		id = sys_create_env("ksem2Slave", (myEnv->page_WS_max_size), (myEnv->SecondListSize),(myEnv->percentage_of_WS_pages_to_be_removed));
  80014c:	a1 20 30 80 00       	mov    0x803020,%eax
  800151:	8b 90 94 05 00 00    	mov    0x594(%eax),%edx
  800157:	a1 20 30 80 00       	mov    0x803020,%eax
  80015c:	8b 80 8c 05 00 00    	mov    0x58c(%eax),%eax
  800162:	89 c1                	mov    %eax,%ecx
  800164:	a1 20 30 80 00       	mov    0x803020,%eax
  800169:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
  80016f:	52                   	push   %edx
  800170:	51                   	push   %ecx
  800171:	50                   	push   %eax
  800172:	68 98 21 80 00       	push   $0x802198
  800177:	e8 47 19 00 00       	call   801ac3 <sys_create_env>
  80017c:	83 c4 10             	add    $0x10,%esp
  80017f:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		if (id == E_ENV_CREATION_ERROR)
  800182:	83 7d d4 ef          	cmpl   $0xffffffef,-0x2c(%ebp)
  800186:	75 14                	jne    80019c <_main+0x164>
			panic("NO AVAILABLE ENVs... Please reduce the number of customers and try again...");
  800188:	83 ec 04             	sub    $0x4,%esp
  80018b:	68 a4 21 80 00       	push   $0x8021a4
  800190:	6a 1e                	push   $0x1e
  800192:	68 f0 21 80 00       	push   $0x8021f0
  800197:	e8 f2 02 00 00       	call   80048e <_panic>
		sys_run_env(id) ;
  80019c:	83 ec 0c             	sub    $0xc,%esp
  80019f:	ff 75 d4             	pushl  -0x2c(%ebp)
  8001a2:	e8 3a 19 00 00       	call   801ae1 <sys_run_env>
  8001a7:	83 c4 10             	add    $0x10,%esp
	semVal = 0;
	sys_utilities(initCmd2, (uint32)(&semVal));

	int i = 0 ;
	int id ;
	for (; i<totalNumOfCusts; i++)
  8001aa:	ff 45 e4             	incl   -0x1c(%ebp)
  8001ad:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8001b0:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  8001b3:	7c 97                	jl     80014c <_main+0x114>
			panic("NO AVAILABLE ENVs... Please reduce the number of customers and try again...");
		sys_run_env(id) ;
	}

	//Wait until all finished
	for (i = 0 ; i<totalNumOfCusts; i++)
  8001b5:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  8001bc:	eb 40                	jmp    8001fe <_main+0x1c6>
	{
		char waitCmd[64] = "__KSem@1@Wait";
  8001be:	8d 85 88 fd ff ff    	lea    -0x278(%ebp),%eax
  8001c4:	bb 25 23 80 00       	mov    $0x802325,%ebx
  8001c9:	ba 0e 00 00 00       	mov    $0xe,%edx
  8001ce:	89 c7                	mov    %eax,%edi
  8001d0:	89 de                	mov    %ebx,%esi
  8001d2:	89 d1                	mov    %edx,%ecx
  8001d4:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  8001d6:	8d 95 96 fd ff ff    	lea    -0x26a(%ebp),%edx
  8001dc:	b9 32 00 00 00       	mov    $0x32,%ecx
  8001e1:	b0 00                	mov    $0x0,%al
  8001e3:	89 d7                	mov    %edx,%edi
  8001e5:	f3 aa                	rep stos %al,%es:(%edi)
		sys_utilities(waitCmd, 0);
  8001e7:	83 ec 08             	sub    $0x8,%esp
  8001ea:	6a 00                	push   $0x0
  8001ec:	8d 85 88 fd ff ff    	lea    -0x278(%ebp),%eax
  8001f2:	50                   	push   %eax
  8001f3:	e8 6f 1b 00 00       	call   801d67 <sys_utilities>
  8001f8:	83 c4 10             	add    $0x10,%esp
			panic("NO AVAILABLE ENVs... Please reduce the number of customers and try again...");
		sys_run_env(id) ;
	}

	//Wait until all finished
	for (i = 0 ; i<totalNumOfCusts; i++)
  8001fb:	ff 45 e4             	incl   -0x1c(%ebp)
  8001fe:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800201:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  800204:	7c b8                	jl     8001be <_main+0x186>
	}

	//Check semaphore values
	int sem1val ;
	int sem2val ;
	char getCmd1[64] = "__KSem@0@Get";
  800206:	8d 85 08 fe ff ff    	lea    -0x1f8(%ebp),%eax
  80020c:	bb 65 23 80 00       	mov    $0x802365,%ebx
  800211:	ba 0d 00 00 00       	mov    $0xd,%edx
  800216:	89 c7                	mov    %eax,%edi
  800218:	89 de                	mov    %ebx,%esi
  80021a:	89 d1                	mov    %edx,%ecx
  80021c:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  80021e:	8d 95 15 fe ff ff    	lea    -0x1eb(%ebp),%edx
  800224:	b9 33 00 00 00       	mov    $0x33,%ecx
  800229:	b0 00                	mov    $0x0,%al
  80022b:	89 d7                	mov    %edx,%edi
  80022d:	f3 aa                	rep stos %al,%es:(%edi)
	char getCmd2[64] = "__KSem@1@Get";
  80022f:	8d 85 c8 fd ff ff    	lea    -0x238(%ebp),%eax
  800235:	bb a5 23 80 00       	mov    $0x8023a5,%ebx
  80023a:	ba 0d 00 00 00       	mov    $0xd,%edx
  80023f:	89 c7                	mov    %eax,%edi
  800241:	89 de                	mov    %ebx,%esi
  800243:	89 d1                	mov    %edx,%ecx
  800245:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  800247:	8d 95 d5 fd ff ff    	lea    -0x22b(%ebp),%edx
  80024d:	b9 33 00 00 00       	mov    $0x33,%ecx
  800252:	b0 00                	mov    $0x0,%al
  800254:	89 d7                	mov    %edx,%edi
  800256:	f3 aa                	rep stos %al,%es:(%edi)

	sys_utilities(getCmd1, (uint32)(&sem1val));
  800258:	8d 85 4c fe ff ff    	lea    -0x1b4(%ebp),%eax
  80025e:	83 ec 08             	sub    $0x8,%esp
  800261:	50                   	push   %eax
  800262:	8d 85 08 fe ff ff    	lea    -0x1f8(%ebp),%eax
  800268:	50                   	push   %eax
  800269:	e8 f9 1a 00 00       	call   801d67 <sys_utilities>
  80026e:	83 c4 10             	add    $0x10,%esp
	sys_utilities(getCmd2, (uint32)(&sem2val));
  800271:	8d 85 48 fe ff ff    	lea    -0x1b8(%ebp),%eax
  800277:	83 ec 08             	sub    $0x8,%esp
  80027a:	50                   	push   %eax
  80027b:	8d 85 c8 fd ff ff    	lea    -0x238(%ebp),%eax
  800281:	50                   	push   %eax
  800282:	e8 e0 1a 00 00       	call   801d67 <sys_utilities>
  800287:	83 c4 10             	add    $0x10,%esp

	//wait a while to allow the slaves to finish printing their closing messages
	env_sleep(10000);
  80028a:	83 ec 0c             	sub    $0xc,%esp
  80028d:	68 10 27 00 00       	push   $0x2710
  800292:	e8 5c 1b 00 00       	call   801df3 <env_sleep>
  800297:	83 c4 10             	add    $0x10,%esp
	if (sem2val == 0 && sem1val == shopCapacity)
  80029a:	8b 85 48 fe ff ff    	mov    -0x1b8(%ebp),%eax
  8002a0:	85 c0                	test   %eax,%eax
  8002a2:	75 1f                	jne    8002c3 <_main+0x28b>
  8002a4:	8b 85 4c fe ff ff    	mov    -0x1b4(%ebp),%eax
  8002aa:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  8002ad:	75 14                	jne    8002c3 <_main+0x28b>
		cprintf_colored(TEXT_light_green,"\nCongratulations!! Test of Semaphores [2] completed successfully!!\n\n\n");
  8002af:	83 ec 08             	sub    $0x8,%esp
  8002b2:	68 10 22 80 00       	push   $0x802210
  8002b7:	6a 0a                	push   $0xa
  8002b9:	e8 cb 04 00 00       	call   800789 <cprintf_colored>
  8002be:	83 c4 10             	add    $0x10,%esp
  8002c1:	eb 12                	jmp    8002d5 <_main+0x29d>
	else
		cprintf_colored(TEXT_TESTERR_CLR,"\nError: wrong semaphore value... please review your semaphore code again...\n");
  8002c3:	83 ec 08             	sub    $0x8,%esp
  8002c6:	68 58 22 80 00       	push   $0x802258
  8002cb:	6a 0c                	push   $0xc
  8002cd:	e8 b7 04 00 00       	call   800789 <cprintf_colored>
  8002d2:	83 c4 10             	add    $0x10,%esp

	return;
  8002d5:	90                   	nop
}
  8002d6:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8002d9:	5b                   	pop    %ebx
  8002da:	5e                   	pop    %esi
  8002db:	5f                   	pop    %edi
  8002dc:	5d                   	pop    %ebp
  8002dd:	c3                   	ret    

008002de <libmain>:
volatile bool printStats = 1;

volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";
void
libmain(int argc, char **argv)
{
  8002de:	55                   	push   %ebp
  8002df:	89 e5                	mov    %esp,%ebp
  8002e1:	57                   	push   %edi
  8002e2:	56                   	push   %esi
  8002e3:	53                   	push   %ebx
  8002e4:	83 ec 7c             	sub    $0x7c,%esp
	//printStats = 1;
	int envIndex = sys_getenvindex();
  8002e7:	e8 45 18 00 00       	call   801b31 <sys_getenvindex>
  8002ec:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	myEnv = &(envs[envIndex]);
  8002ef:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8002f2:	89 d0                	mov    %edx,%eax
  8002f4:	c1 e0 02             	shl    $0x2,%eax
  8002f7:	01 d0                	add    %edx,%eax
  8002f9:	c1 e0 03             	shl    $0x3,%eax
  8002fc:	01 d0                	add    %edx,%eax
  8002fe:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  800305:	01 d0                	add    %edx,%eax
  800307:	c1 e0 02             	shl    $0x2,%eax
  80030a:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80030f:	a3 20 30 80 00       	mov    %eax,0x803020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800314:	a1 20 30 80 00       	mov    0x803020,%eax
  800319:	8a 40 20             	mov    0x20(%eax),%al
  80031c:	84 c0                	test   %al,%al
  80031e:	74 0d                	je     80032d <libmain+0x4f>
		binaryname = myEnv->prog_name;
  800320:	a1 20 30 80 00       	mov    0x803020,%eax
  800325:	83 c0 20             	add    $0x20,%eax
  800328:	a3 04 30 80 00       	mov    %eax,0x803004

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80032d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800331:	7e 0a                	jle    80033d <libmain+0x5f>
		binaryname = argv[0];
  800333:	8b 45 0c             	mov    0xc(%ebp),%eax
  800336:	8b 00                	mov    (%eax),%eax
  800338:	a3 04 30 80 00       	mov    %eax,0x803004

	// call user main routine
	_main(argc, argv);
  80033d:	83 ec 08             	sub    $0x8,%esp
  800340:	ff 75 0c             	pushl  0xc(%ebp)
  800343:	ff 75 08             	pushl  0x8(%ebp)
  800346:	e8 ed fc ff ff       	call   800038 <_main>
  80034b:	83 c4 10             	add    $0x10,%esp

	if (printStats)
  80034e:	a1 00 30 80 00       	mov    0x803000,%eax
  800353:	85 c0                	test   %eax,%eax
  800355:	0f 84 01 01 00 00    	je     80045c <libmain+0x17e>
	{
		char isOPTReplCmd[100] = "__IsOPTRepl__" ;
  80035b:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  800361:	bb e0 24 80 00       	mov    $0x8024e0,%ebx
  800366:	ba 0e 00 00 00       	mov    $0xe,%edx
  80036b:	89 c7                	mov    %eax,%edi
  80036d:	89 de                	mov    %ebx,%esi
  80036f:	89 d1                	mov    %edx,%ecx
  800371:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  800373:	8d 55 8a             	lea    -0x76(%ebp),%edx
  800376:	b9 56 00 00 00       	mov    $0x56,%ecx
  80037b:	b0 00                	mov    $0x0,%al
  80037d:	89 d7                	mov    %edx,%edi
  80037f:	f3 aa                	rep stos %al,%es:(%edi)
		int isOPTRepl = 0;
  800381:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
		sys_utilities(isOPTReplCmd, (uint32)(&isOPTRepl));
  800388:	8d 45 e0             	lea    -0x20(%ebp),%eax
  80038b:	83 ec 08             	sub    $0x8,%esp
  80038e:	50                   	push   %eax
  80038f:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  800395:	50                   	push   %eax
  800396:	e8 cc 19 00 00       	call   801d67 <sys_utilities>
  80039b:	83 c4 10             	add    $0x10,%esp

		sys_lock_cons();
  80039e:	e8 15 15 00 00       	call   8018b8 <sys_lock_cons>
		{
			cprintf("**************************************\n");
  8003a3:	83 ec 0c             	sub    $0xc,%esp
  8003a6:	68 00 24 80 00       	push   $0x802400
  8003ab:	e8 ac 03 00 00       	call   80075c <cprintf>
  8003b0:	83 c4 10             	add    $0x10,%esp
			if (isOPTRepl)
  8003b3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8003b6:	85 c0                	test   %eax,%eax
  8003b8:	74 18                	je     8003d2 <libmain+0xf4>
			{
				cprintf("OPTIMAL number of page faults = %d\n", sys_get_optimal_num_faults());
  8003ba:	e8 c6 19 00 00       	call   801d85 <sys_get_optimal_num_faults>
  8003bf:	83 ec 08             	sub    $0x8,%esp
  8003c2:	50                   	push   %eax
  8003c3:	68 28 24 80 00       	push   $0x802428
  8003c8:	e8 8f 03 00 00       	call   80075c <cprintf>
  8003cd:	83 c4 10             	add    $0x10,%esp
  8003d0:	eb 59                	jmp    80042b <libmain+0x14d>
			}
			else
			{
				cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8003d2:	a1 20 30 80 00       	mov    0x803020,%eax
  8003d7:	8b 90 a8 05 00 00    	mov    0x5a8(%eax),%edx
  8003dd:	a1 20 30 80 00       	mov    0x803020,%eax
  8003e2:	8b 80 98 05 00 00    	mov    0x598(%eax),%eax
  8003e8:	83 ec 04             	sub    $0x4,%esp
  8003eb:	52                   	push   %edx
  8003ec:	50                   	push   %eax
  8003ed:	68 4c 24 80 00       	push   $0x80244c
  8003f2:	e8 65 03 00 00       	call   80075c <cprintf>
  8003f7:	83 c4 10             	add    $0x10,%esp
				cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  8003fa:	a1 20 30 80 00       	mov    0x803020,%eax
  8003ff:	8b 88 bc 05 00 00    	mov    0x5bc(%eax),%ecx
  800405:	a1 20 30 80 00       	mov    0x803020,%eax
  80040a:	8b 90 b8 05 00 00    	mov    0x5b8(%eax),%edx
  800410:	a1 20 30 80 00       	mov    0x803020,%eax
  800415:	8b 80 b4 05 00 00    	mov    0x5b4(%eax),%eax
  80041b:	51                   	push   %ecx
  80041c:	52                   	push   %edx
  80041d:	50                   	push   %eax
  80041e:	68 74 24 80 00       	push   $0x802474
  800423:	e8 34 03 00 00       	call   80075c <cprintf>
  800428:	83 c4 10             	add    $0x10,%esp
			}
			//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
			cprintf("Num of clocks = %d\n", myEnv->nClocks);
  80042b:	a1 20 30 80 00       	mov    0x803020,%eax
  800430:	8b 80 c0 05 00 00    	mov    0x5c0(%eax),%eax
  800436:	83 ec 08             	sub    $0x8,%esp
  800439:	50                   	push   %eax
  80043a:	68 cc 24 80 00       	push   $0x8024cc
  80043f:	e8 18 03 00 00       	call   80075c <cprintf>
  800444:	83 c4 10             	add    $0x10,%esp
			cprintf("**************************************\n");
  800447:	83 ec 0c             	sub    $0xc,%esp
  80044a:	68 00 24 80 00       	push   $0x802400
  80044f:	e8 08 03 00 00       	call   80075c <cprintf>
  800454:	83 c4 10             	add    $0x10,%esp
		}
		sys_unlock_cons();
  800457:	e8 76 14 00 00       	call   8018d2 <sys_unlock_cons>
	}

	// exit gracefully
	exit();
  80045c:	e8 1f 00 00 00       	call   800480 <exit>
}
  800461:	90                   	nop
  800462:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800465:	5b                   	pop    %ebx
  800466:	5e                   	pop    %esi
  800467:	5f                   	pop    %edi
  800468:	5d                   	pop    %ebp
  800469:	c3                   	ret    

0080046a <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  80046a:	55                   	push   %ebp
  80046b:	89 e5                	mov    %esp,%ebp
  80046d:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800470:	83 ec 0c             	sub    $0xc,%esp
  800473:	6a 00                	push   $0x0
  800475:	e8 83 16 00 00       	call   801afd <sys_destroy_env>
  80047a:	83 c4 10             	add    $0x10,%esp
}
  80047d:	90                   	nop
  80047e:	c9                   	leave  
  80047f:	c3                   	ret    

00800480 <exit>:

void
exit(void)
{
  800480:	55                   	push   %ebp
  800481:	89 e5                	mov    %esp,%ebp
  800483:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  800486:	e8 d8 16 00 00       	call   801b63 <sys_exit_env>
}
  80048b:	90                   	nop
  80048c:	c9                   	leave  
  80048d:	c3                   	ret    

0080048e <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  80048e:	55                   	push   %ebp
  80048f:	89 e5                	mov    %esp,%ebp
  800491:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  800494:	8d 45 10             	lea    0x10(%ebp),%eax
  800497:	83 c0 04             	add    $0x4,%eax
  80049a:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  80049d:	a1 18 b1 81 00       	mov    0x81b118,%eax
  8004a2:	85 c0                	test   %eax,%eax
  8004a4:	74 16                	je     8004bc <_panic+0x2e>
		cprintf("%s: ", argv0);
  8004a6:	a1 18 b1 81 00       	mov    0x81b118,%eax
  8004ab:	83 ec 08             	sub    $0x8,%esp
  8004ae:	50                   	push   %eax
  8004af:	68 44 25 80 00       	push   $0x802544
  8004b4:	e8 a3 02 00 00       	call   80075c <cprintf>
  8004b9:	83 c4 10             	add    $0x10,%esp
	cprintf_colored(TEXT_PANIC_CLR, "user [EVAL_FINAL]panic in %s at %s:%d: ", binaryname, file, line);
  8004bc:	a1 04 30 80 00       	mov    0x803004,%eax
  8004c1:	83 ec 0c             	sub    $0xc,%esp
  8004c4:	ff 75 0c             	pushl  0xc(%ebp)
  8004c7:	ff 75 08             	pushl  0x8(%ebp)
  8004ca:	50                   	push   %eax
  8004cb:	68 4c 25 80 00       	push   $0x80254c
  8004d0:	6a 74                	push   $0x74
  8004d2:	e8 b2 02 00 00       	call   800789 <cprintf_colored>
  8004d7:	83 c4 20             	add    $0x20,%esp
	vcprintf(fmt, ap);
  8004da:	8b 45 10             	mov    0x10(%ebp),%eax
  8004dd:	83 ec 08             	sub    $0x8,%esp
  8004e0:	ff 75 f4             	pushl  -0xc(%ebp)
  8004e3:	50                   	push   %eax
  8004e4:	e8 04 02 00 00       	call   8006ed <vcprintf>
  8004e9:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  8004ec:	83 ec 08             	sub    $0x8,%esp
  8004ef:	6a 00                	push   $0x0
  8004f1:	68 74 25 80 00       	push   $0x802574
  8004f6:	e8 f2 01 00 00       	call   8006ed <vcprintf>
  8004fb:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  8004fe:	e8 7d ff ff ff       	call   800480 <exit>

	// should not return here
	while (1) ;
  800503:	eb fe                	jmp    800503 <_panic+0x75>

00800505 <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  800505:	55                   	push   %ebp
  800506:	89 e5                	mov    %esp,%ebp
  800508:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  80050b:	a1 20 30 80 00       	mov    0x803020,%eax
  800510:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  800516:	8b 45 0c             	mov    0xc(%ebp),%eax
  800519:	39 c2                	cmp    %eax,%edx
  80051b:	74 14                	je     800531 <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  80051d:	83 ec 04             	sub    $0x4,%esp
  800520:	68 78 25 80 00       	push   $0x802578
  800525:	6a 26                	push   $0x26
  800527:	68 c4 25 80 00       	push   $0x8025c4
  80052c:	e8 5d ff ff ff       	call   80048e <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  800531:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  800538:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80053f:	e9 c5 00 00 00       	jmp    800609 <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  800544:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800547:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80054e:	8b 45 08             	mov    0x8(%ebp),%eax
  800551:	01 d0                	add    %edx,%eax
  800553:	8b 00                	mov    (%eax),%eax
  800555:	85 c0                	test   %eax,%eax
  800557:	75 08                	jne    800561 <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  800559:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  80055c:	e9 a5 00 00 00       	jmp    800606 <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  800561:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800568:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  80056f:	eb 69                	jmp    8005da <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  800571:	a1 20 30 80 00       	mov    0x803020,%eax
  800576:	8b 88 90 05 00 00    	mov    0x590(%eax),%ecx
  80057c:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80057f:	89 d0                	mov    %edx,%eax
  800581:	01 c0                	add    %eax,%eax
  800583:	01 d0                	add    %edx,%eax
  800585:	c1 e0 03             	shl    $0x3,%eax
  800588:	01 c8                	add    %ecx,%eax
  80058a:	8a 40 04             	mov    0x4(%eax),%al
  80058d:	84 c0                	test   %al,%al
  80058f:	75 46                	jne    8005d7 <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800591:	a1 20 30 80 00       	mov    0x803020,%eax
  800596:	8b 88 90 05 00 00    	mov    0x590(%eax),%ecx
  80059c:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80059f:	89 d0                	mov    %edx,%eax
  8005a1:	01 c0                	add    %eax,%eax
  8005a3:	01 d0                	add    %edx,%eax
  8005a5:	c1 e0 03             	shl    $0x3,%eax
  8005a8:	01 c8                	add    %ecx,%eax
  8005aa:	8b 00                	mov    (%eax),%eax
  8005ac:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8005af:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8005b2:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8005b7:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  8005b9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8005bc:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8005c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8005c6:	01 c8                	add    %ecx,%eax
  8005c8:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8005ca:	39 c2                	cmp    %eax,%edx
  8005cc:	75 09                	jne    8005d7 <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  8005ce:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  8005d5:	eb 15                	jmp    8005ec <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8005d7:	ff 45 e8             	incl   -0x18(%ebp)
  8005da:	a1 20 30 80 00       	mov    0x803020,%eax
  8005df:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  8005e5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8005e8:	39 c2                	cmp    %eax,%edx
  8005ea:	77 85                	ja     800571 <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  8005ec:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8005f0:	75 14                	jne    800606 <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  8005f2:	83 ec 04             	sub    $0x4,%esp
  8005f5:	68 d0 25 80 00       	push   $0x8025d0
  8005fa:	6a 3a                	push   $0x3a
  8005fc:	68 c4 25 80 00       	push   $0x8025c4
  800601:	e8 88 fe ff ff       	call   80048e <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  800606:	ff 45 f0             	incl   -0x10(%ebp)
  800609:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80060c:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80060f:	0f 8c 2f ff ff ff    	jl     800544 <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  800615:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80061c:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800623:	eb 26                	jmp    80064b <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  800625:	a1 20 30 80 00       	mov    0x803020,%eax
  80062a:	8b 88 90 05 00 00    	mov    0x590(%eax),%ecx
  800630:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800633:	89 d0                	mov    %edx,%eax
  800635:	01 c0                	add    %eax,%eax
  800637:	01 d0                	add    %edx,%eax
  800639:	c1 e0 03             	shl    $0x3,%eax
  80063c:	01 c8                	add    %ecx,%eax
  80063e:	8a 40 04             	mov    0x4(%eax),%al
  800641:	3c 01                	cmp    $0x1,%al
  800643:	75 03                	jne    800648 <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  800645:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800648:	ff 45 e0             	incl   -0x20(%ebp)
  80064b:	a1 20 30 80 00       	mov    0x803020,%eax
  800650:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  800656:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800659:	39 c2                	cmp    %eax,%edx
  80065b:	77 c8                	ja     800625 <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  80065d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800660:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800663:	74 14                	je     800679 <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  800665:	83 ec 04             	sub    $0x4,%esp
  800668:	68 24 26 80 00       	push   $0x802624
  80066d:	6a 44                	push   $0x44
  80066f:	68 c4 25 80 00       	push   $0x8025c4
  800674:	e8 15 fe ff ff       	call   80048e <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  800679:	90                   	nop
  80067a:	c9                   	leave  
  80067b:	c3                   	ret    

0080067c <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  80067c:	55                   	push   %ebp
  80067d:	89 e5                	mov    %esp,%ebp
  80067f:	53                   	push   %ebx
  800680:	83 ec 04             	sub    $0x4,%esp
	b->buf[b->idx++] = ch;
  800683:	8b 45 0c             	mov    0xc(%ebp),%eax
  800686:	8b 00                	mov    (%eax),%eax
  800688:	8d 48 01             	lea    0x1(%eax),%ecx
  80068b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80068e:	89 0a                	mov    %ecx,(%edx)
  800690:	8b 55 08             	mov    0x8(%ebp),%edx
  800693:	88 d1                	mov    %dl,%cl
  800695:	8b 55 0c             	mov    0xc(%ebp),%edx
  800698:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  80069c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80069f:	8b 00                	mov    (%eax),%eax
  8006a1:	3d ff 00 00 00       	cmp    $0xff,%eax
  8006a6:	75 30                	jne    8006d8 <putch+0x5c>
		sys_cputs(b->buf, b->idx, printProgName, curTextClr);
  8006a8:	8b 15 1c b1 81 00    	mov    0x81b11c,%edx
  8006ae:	a0 44 30 80 00       	mov    0x803044,%al
  8006b3:	0f b6 c0             	movzbl %al,%eax
  8006b6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8006b9:	8b 09                	mov    (%ecx),%ecx
  8006bb:	89 cb                	mov    %ecx,%ebx
  8006bd:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8006c0:	83 c1 08             	add    $0x8,%ecx
  8006c3:	52                   	push   %edx
  8006c4:	50                   	push   %eax
  8006c5:	53                   	push   %ebx
  8006c6:	51                   	push   %ecx
  8006c7:	e8 a8 11 00 00       	call   801874 <sys_cputs>
  8006cc:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8006cf:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006d2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8006d8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006db:	8b 40 04             	mov    0x4(%eax),%eax
  8006de:	8d 50 01             	lea    0x1(%eax),%edx
  8006e1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006e4:	89 50 04             	mov    %edx,0x4(%eax)
}
  8006e7:	90                   	nop
  8006e8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8006eb:	c9                   	leave  
  8006ec:	c3                   	ret    

008006ed <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  8006ed:	55                   	push   %ebp
  8006ee:	89 e5                	mov    %esp,%ebp
  8006f0:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8006f6:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8006fd:	00 00 00 
	b.cnt = 0;
  800700:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800707:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  80070a:	ff 75 0c             	pushl  0xc(%ebp)
  80070d:	ff 75 08             	pushl  0x8(%ebp)
  800710:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800716:	50                   	push   %eax
  800717:	68 7c 06 80 00       	push   $0x80067c
  80071c:	e8 5a 02 00 00       	call   80097b <vprintfmt>
  800721:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName, curTextClr);
  800724:	8b 15 1c b1 81 00    	mov    0x81b11c,%edx
  80072a:	a0 44 30 80 00       	mov    0x803044,%al
  80072f:	0f b6 c0             	movzbl %al,%eax
  800732:	8b 8d f0 fe ff ff    	mov    -0x110(%ebp),%ecx
  800738:	52                   	push   %edx
  800739:	50                   	push   %eax
  80073a:	51                   	push   %ecx
  80073b:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800741:	83 c0 08             	add    $0x8,%eax
  800744:	50                   	push   %eax
  800745:	e8 2a 11 00 00       	call   801874 <sys_cputs>
  80074a:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  80074d:	c6 05 44 30 80 00 00 	movb   $0x0,0x803044
	return b.cnt;
  800754:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  80075a:	c9                   	leave  
  80075b:	c3                   	ret    

0080075c <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  80075c:	55                   	push   %ebp
  80075d:	89 e5                	mov    %esp,%ebp
  80075f:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800762:	c6 05 44 30 80 00 01 	movb   $0x1,0x803044
	va_start(ap, fmt);
  800769:	8d 45 0c             	lea    0xc(%ebp),%eax
  80076c:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  80076f:	8b 45 08             	mov    0x8(%ebp),%eax
  800772:	83 ec 08             	sub    $0x8,%esp
  800775:	ff 75 f4             	pushl  -0xc(%ebp)
  800778:	50                   	push   %eax
  800779:	e8 6f ff ff ff       	call   8006ed <vcprintf>
  80077e:	83 c4 10             	add    $0x10,%esp
  800781:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800784:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800787:	c9                   	leave  
  800788:	c3                   	ret    

00800789 <cprintf_colored>:

// *************** This text coloring feature is implemented by *************
// ********** Abd-Alrahman Zedan From Team Frozen-Bytes - FCIS'24-25 ********
int cprintf_colored(int textClr, const char *fmt, ...) {
  800789:	55                   	push   %ebp
  80078a:	89 e5                	mov    %esp,%ebp
  80078c:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  80078f:	c6 05 44 30 80 00 01 	movb   $0x1,0x803044
	curTextClr = (textClr << 8) ; //set text color by the given value
  800796:	8b 45 08             	mov    0x8(%ebp),%eax
  800799:	c1 e0 08             	shl    $0x8,%eax
  80079c:	a3 1c b1 81 00       	mov    %eax,0x81b11c
	va_start(ap, fmt);
  8007a1:	8d 45 0c             	lea    0xc(%ebp),%eax
  8007a4:	83 c0 04             	add    $0x4,%eax
  8007a7:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8007aa:	8b 45 0c             	mov    0xc(%ebp),%eax
  8007ad:	83 ec 08             	sub    $0x8,%esp
  8007b0:	ff 75 f4             	pushl  -0xc(%ebp)
  8007b3:	50                   	push   %eax
  8007b4:	e8 34 ff ff ff       	call   8006ed <vcprintf>
  8007b9:	83 c4 10             	add    $0x10,%esp
  8007bc:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);
	curTextClr = TEXT_DEFAULT_CLR; //restore default color
  8007bf:	c7 05 1c b1 81 00 00 	movl   $0x700,0x81b11c
  8007c6:	07 00 00 

	return cnt;
  8007c9:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8007cc:	c9                   	leave  
  8007cd:	c3                   	ret    

008007ce <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  8007ce:	55                   	push   %ebp
  8007cf:	89 e5                	mov    %esp,%ebp
  8007d1:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  8007d4:	e8 df 10 00 00       	call   8018b8 <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  8007d9:	8d 45 0c             	lea    0xc(%ebp),%eax
  8007dc:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  8007df:	8b 45 08             	mov    0x8(%ebp),%eax
  8007e2:	83 ec 08             	sub    $0x8,%esp
  8007e5:	ff 75 f4             	pushl  -0xc(%ebp)
  8007e8:	50                   	push   %eax
  8007e9:	e8 ff fe ff ff       	call   8006ed <vcprintf>
  8007ee:	83 c4 10             	add    $0x10,%esp
  8007f1:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  8007f4:	e8 d9 10 00 00       	call   8018d2 <sys_unlock_cons>
	return cnt;
  8007f9:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8007fc:	c9                   	leave  
  8007fd:	c3                   	ret    

008007fe <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8007fe:	55                   	push   %ebp
  8007ff:	89 e5                	mov    %esp,%ebp
  800801:	53                   	push   %ebx
  800802:	83 ec 14             	sub    $0x14,%esp
  800805:	8b 45 10             	mov    0x10(%ebp),%eax
  800808:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80080b:	8b 45 14             	mov    0x14(%ebp),%eax
  80080e:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800811:	8b 45 18             	mov    0x18(%ebp),%eax
  800814:	ba 00 00 00 00       	mov    $0x0,%edx
  800819:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  80081c:	77 55                	ja     800873 <printnum+0x75>
  80081e:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800821:	72 05                	jb     800828 <printnum+0x2a>
  800823:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800826:	77 4b                	ja     800873 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800828:	8b 45 1c             	mov    0x1c(%ebp),%eax
  80082b:	8d 58 ff             	lea    -0x1(%eax),%ebx
  80082e:	8b 45 18             	mov    0x18(%ebp),%eax
  800831:	ba 00 00 00 00       	mov    $0x0,%edx
  800836:	52                   	push   %edx
  800837:	50                   	push   %eax
  800838:	ff 75 f4             	pushl  -0xc(%ebp)
  80083b:	ff 75 f0             	pushl  -0x10(%ebp)
  80083e:	e8 ad 16 00 00       	call   801ef0 <__udivdi3>
  800843:	83 c4 10             	add    $0x10,%esp
  800846:	83 ec 04             	sub    $0x4,%esp
  800849:	ff 75 20             	pushl  0x20(%ebp)
  80084c:	53                   	push   %ebx
  80084d:	ff 75 18             	pushl  0x18(%ebp)
  800850:	52                   	push   %edx
  800851:	50                   	push   %eax
  800852:	ff 75 0c             	pushl  0xc(%ebp)
  800855:	ff 75 08             	pushl  0x8(%ebp)
  800858:	e8 a1 ff ff ff       	call   8007fe <printnum>
  80085d:	83 c4 20             	add    $0x20,%esp
  800860:	eb 1a                	jmp    80087c <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800862:	83 ec 08             	sub    $0x8,%esp
  800865:	ff 75 0c             	pushl  0xc(%ebp)
  800868:	ff 75 20             	pushl  0x20(%ebp)
  80086b:	8b 45 08             	mov    0x8(%ebp),%eax
  80086e:	ff d0                	call   *%eax
  800870:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800873:	ff 4d 1c             	decl   0x1c(%ebp)
  800876:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  80087a:	7f e6                	jg     800862 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80087c:	8b 4d 18             	mov    0x18(%ebp),%ecx
  80087f:	bb 00 00 00 00       	mov    $0x0,%ebx
  800884:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800887:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80088a:	53                   	push   %ebx
  80088b:	51                   	push   %ecx
  80088c:	52                   	push   %edx
  80088d:	50                   	push   %eax
  80088e:	e8 6d 17 00 00       	call   802000 <__umoddi3>
  800893:	83 c4 10             	add    $0x10,%esp
  800896:	05 94 28 80 00       	add    $0x802894,%eax
  80089b:	8a 00                	mov    (%eax),%al
  80089d:	0f be c0             	movsbl %al,%eax
  8008a0:	83 ec 08             	sub    $0x8,%esp
  8008a3:	ff 75 0c             	pushl  0xc(%ebp)
  8008a6:	50                   	push   %eax
  8008a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8008aa:	ff d0                	call   *%eax
  8008ac:	83 c4 10             	add    $0x10,%esp
}
  8008af:	90                   	nop
  8008b0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8008b3:	c9                   	leave  
  8008b4:	c3                   	ret    

008008b5 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8008b5:	55                   	push   %ebp
  8008b6:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8008b8:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8008bc:	7e 1c                	jle    8008da <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  8008be:	8b 45 08             	mov    0x8(%ebp),%eax
  8008c1:	8b 00                	mov    (%eax),%eax
  8008c3:	8d 50 08             	lea    0x8(%eax),%edx
  8008c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8008c9:	89 10                	mov    %edx,(%eax)
  8008cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8008ce:	8b 00                	mov    (%eax),%eax
  8008d0:	83 e8 08             	sub    $0x8,%eax
  8008d3:	8b 50 04             	mov    0x4(%eax),%edx
  8008d6:	8b 00                	mov    (%eax),%eax
  8008d8:	eb 40                	jmp    80091a <getuint+0x65>
	else if (lflag)
  8008da:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8008de:	74 1e                	je     8008fe <getuint+0x49>
		return va_arg(*ap, unsigned long);
  8008e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8008e3:	8b 00                	mov    (%eax),%eax
  8008e5:	8d 50 04             	lea    0x4(%eax),%edx
  8008e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8008eb:	89 10                	mov    %edx,(%eax)
  8008ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8008f0:	8b 00                	mov    (%eax),%eax
  8008f2:	83 e8 04             	sub    $0x4,%eax
  8008f5:	8b 00                	mov    (%eax),%eax
  8008f7:	ba 00 00 00 00       	mov    $0x0,%edx
  8008fc:	eb 1c                	jmp    80091a <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  8008fe:	8b 45 08             	mov    0x8(%ebp),%eax
  800901:	8b 00                	mov    (%eax),%eax
  800903:	8d 50 04             	lea    0x4(%eax),%edx
  800906:	8b 45 08             	mov    0x8(%ebp),%eax
  800909:	89 10                	mov    %edx,(%eax)
  80090b:	8b 45 08             	mov    0x8(%ebp),%eax
  80090e:	8b 00                	mov    (%eax),%eax
  800910:	83 e8 04             	sub    $0x4,%eax
  800913:	8b 00                	mov    (%eax),%eax
  800915:	ba 00 00 00 00       	mov    $0x0,%edx
}
  80091a:	5d                   	pop    %ebp
  80091b:	c3                   	ret    

0080091c <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  80091c:	55                   	push   %ebp
  80091d:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  80091f:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800923:	7e 1c                	jle    800941 <getint+0x25>
		return va_arg(*ap, long long);
  800925:	8b 45 08             	mov    0x8(%ebp),%eax
  800928:	8b 00                	mov    (%eax),%eax
  80092a:	8d 50 08             	lea    0x8(%eax),%edx
  80092d:	8b 45 08             	mov    0x8(%ebp),%eax
  800930:	89 10                	mov    %edx,(%eax)
  800932:	8b 45 08             	mov    0x8(%ebp),%eax
  800935:	8b 00                	mov    (%eax),%eax
  800937:	83 e8 08             	sub    $0x8,%eax
  80093a:	8b 50 04             	mov    0x4(%eax),%edx
  80093d:	8b 00                	mov    (%eax),%eax
  80093f:	eb 38                	jmp    800979 <getint+0x5d>
	else if (lflag)
  800941:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800945:	74 1a                	je     800961 <getint+0x45>
		return va_arg(*ap, long);
  800947:	8b 45 08             	mov    0x8(%ebp),%eax
  80094a:	8b 00                	mov    (%eax),%eax
  80094c:	8d 50 04             	lea    0x4(%eax),%edx
  80094f:	8b 45 08             	mov    0x8(%ebp),%eax
  800952:	89 10                	mov    %edx,(%eax)
  800954:	8b 45 08             	mov    0x8(%ebp),%eax
  800957:	8b 00                	mov    (%eax),%eax
  800959:	83 e8 04             	sub    $0x4,%eax
  80095c:	8b 00                	mov    (%eax),%eax
  80095e:	99                   	cltd   
  80095f:	eb 18                	jmp    800979 <getint+0x5d>
	else
		return va_arg(*ap, int);
  800961:	8b 45 08             	mov    0x8(%ebp),%eax
  800964:	8b 00                	mov    (%eax),%eax
  800966:	8d 50 04             	lea    0x4(%eax),%edx
  800969:	8b 45 08             	mov    0x8(%ebp),%eax
  80096c:	89 10                	mov    %edx,(%eax)
  80096e:	8b 45 08             	mov    0x8(%ebp),%eax
  800971:	8b 00                	mov    (%eax),%eax
  800973:	83 e8 04             	sub    $0x4,%eax
  800976:	8b 00                	mov    (%eax),%eax
  800978:	99                   	cltd   
}
  800979:	5d                   	pop    %ebp
  80097a:	c3                   	ret    

0080097b <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  80097b:	55                   	push   %ebp
  80097c:	89 e5                	mov    %esp,%ebp
  80097e:	56                   	push   %esi
  80097f:	53                   	push   %ebx
  800980:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800983:	eb 17                	jmp    80099c <vprintfmt+0x21>
			if (ch == '\0')
  800985:	85 db                	test   %ebx,%ebx
  800987:	0f 84 c1 03 00 00    	je     800d4e <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  80098d:	83 ec 08             	sub    $0x8,%esp
  800990:	ff 75 0c             	pushl  0xc(%ebp)
  800993:	53                   	push   %ebx
  800994:	8b 45 08             	mov    0x8(%ebp),%eax
  800997:	ff d0                	call   *%eax
  800999:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80099c:	8b 45 10             	mov    0x10(%ebp),%eax
  80099f:	8d 50 01             	lea    0x1(%eax),%edx
  8009a2:	89 55 10             	mov    %edx,0x10(%ebp)
  8009a5:	8a 00                	mov    (%eax),%al
  8009a7:	0f b6 d8             	movzbl %al,%ebx
  8009aa:	83 fb 25             	cmp    $0x25,%ebx
  8009ad:	75 d6                	jne    800985 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  8009af:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  8009b3:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  8009ba:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8009c1:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  8009c8:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8009cf:	8b 45 10             	mov    0x10(%ebp),%eax
  8009d2:	8d 50 01             	lea    0x1(%eax),%edx
  8009d5:	89 55 10             	mov    %edx,0x10(%ebp)
  8009d8:	8a 00                	mov    (%eax),%al
  8009da:	0f b6 d8             	movzbl %al,%ebx
  8009dd:	8d 43 dd             	lea    -0x23(%ebx),%eax
  8009e0:	83 f8 5b             	cmp    $0x5b,%eax
  8009e3:	0f 87 3d 03 00 00    	ja     800d26 <vprintfmt+0x3ab>
  8009e9:	8b 04 85 b8 28 80 00 	mov    0x8028b8(,%eax,4),%eax
  8009f0:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  8009f2:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  8009f6:	eb d7                	jmp    8009cf <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8009f8:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  8009fc:	eb d1                	jmp    8009cf <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8009fe:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800a05:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800a08:	89 d0                	mov    %edx,%eax
  800a0a:	c1 e0 02             	shl    $0x2,%eax
  800a0d:	01 d0                	add    %edx,%eax
  800a0f:	01 c0                	add    %eax,%eax
  800a11:	01 d8                	add    %ebx,%eax
  800a13:	83 e8 30             	sub    $0x30,%eax
  800a16:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800a19:	8b 45 10             	mov    0x10(%ebp),%eax
  800a1c:	8a 00                	mov    (%eax),%al
  800a1e:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800a21:	83 fb 2f             	cmp    $0x2f,%ebx
  800a24:	7e 3e                	jle    800a64 <vprintfmt+0xe9>
  800a26:	83 fb 39             	cmp    $0x39,%ebx
  800a29:	7f 39                	jg     800a64 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800a2b:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800a2e:	eb d5                	jmp    800a05 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800a30:	8b 45 14             	mov    0x14(%ebp),%eax
  800a33:	83 c0 04             	add    $0x4,%eax
  800a36:	89 45 14             	mov    %eax,0x14(%ebp)
  800a39:	8b 45 14             	mov    0x14(%ebp),%eax
  800a3c:	83 e8 04             	sub    $0x4,%eax
  800a3f:	8b 00                	mov    (%eax),%eax
  800a41:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800a44:	eb 1f                	jmp    800a65 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800a46:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a4a:	79 83                	jns    8009cf <vprintfmt+0x54>
				width = 0;
  800a4c:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800a53:	e9 77 ff ff ff       	jmp    8009cf <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800a58:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800a5f:	e9 6b ff ff ff       	jmp    8009cf <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800a64:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800a65:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a69:	0f 89 60 ff ff ff    	jns    8009cf <vprintfmt+0x54>
				width = precision, precision = -1;
  800a6f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800a72:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800a75:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800a7c:	e9 4e ff ff ff       	jmp    8009cf <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800a81:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800a84:	e9 46 ff ff ff       	jmp    8009cf <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800a89:	8b 45 14             	mov    0x14(%ebp),%eax
  800a8c:	83 c0 04             	add    $0x4,%eax
  800a8f:	89 45 14             	mov    %eax,0x14(%ebp)
  800a92:	8b 45 14             	mov    0x14(%ebp),%eax
  800a95:	83 e8 04             	sub    $0x4,%eax
  800a98:	8b 00                	mov    (%eax),%eax
  800a9a:	83 ec 08             	sub    $0x8,%esp
  800a9d:	ff 75 0c             	pushl  0xc(%ebp)
  800aa0:	50                   	push   %eax
  800aa1:	8b 45 08             	mov    0x8(%ebp),%eax
  800aa4:	ff d0                	call   *%eax
  800aa6:	83 c4 10             	add    $0x10,%esp
			break;
  800aa9:	e9 9b 02 00 00       	jmp    800d49 <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800aae:	8b 45 14             	mov    0x14(%ebp),%eax
  800ab1:	83 c0 04             	add    $0x4,%eax
  800ab4:	89 45 14             	mov    %eax,0x14(%ebp)
  800ab7:	8b 45 14             	mov    0x14(%ebp),%eax
  800aba:	83 e8 04             	sub    $0x4,%eax
  800abd:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800abf:	85 db                	test   %ebx,%ebx
  800ac1:	79 02                	jns    800ac5 <vprintfmt+0x14a>
				err = -err;
  800ac3:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800ac5:	83 fb 64             	cmp    $0x64,%ebx
  800ac8:	7f 0b                	jg     800ad5 <vprintfmt+0x15a>
  800aca:	8b 34 9d 00 27 80 00 	mov    0x802700(,%ebx,4),%esi
  800ad1:	85 f6                	test   %esi,%esi
  800ad3:	75 19                	jne    800aee <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800ad5:	53                   	push   %ebx
  800ad6:	68 a5 28 80 00       	push   $0x8028a5
  800adb:	ff 75 0c             	pushl  0xc(%ebp)
  800ade:	ff 75 08             	pushl  0x8(%ebp)
  800ae1:	e8 70 02 00 00       	call   800d56 <printfmt>
  800ae6:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800ae9:	e9 5b 02 00 00       	jmp    800d49 <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800aee:	56                   	push   %esi
  800aef:	68 ae 28 80 00       	push   $0x8028ae
  800af4:	ff 75 0c             	pushl  0xc(%ebp)
  800af7:	ff 75 08             	pushl  0x8(%ebp)
  800afa:	e8 57 02 00 00       	call   800d56 <printfmt>
  800aff:	83 c4 10             	add    $0x10,%esp
			break;
  800b02:	e9 42 02 00 00       	jmp    800d49 <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800b07:	8b 45 14             	mov    0x14(%ebp),%eax
  800b0a:	83 c0 04             	add    $0x4,%eax
  800b0d:	89 45 14             	mov    %eax,0x14(%ebp)
  800b10:	8b 45 14             	mov    0x14(%ebp),%eax
  800b13:	83 e8 04             	sub    $0x4,%eax
  800b16:	8b 30                	mov    (%eax),%esi
  800b18:	85 f6                	test   %esi,%esi
  800b1a:	75 05                	jne    800b21 <vprintfmt+0x1a6>
				p = "(null)";
  800b1c:	be b1 28 80 00       	mov    $0x8028b1,%esi
			if (width > 0 && padc != '-')
  800b21:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800b25:	7e 6d                	jle    800b94 <vprintfmt+0x219>
  800b27:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800b2b:	74 67                	je     800b94 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800b2d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800b30:	83 ec 08             	sub    $0x8,%esp
  800b33:	50                   	push   %eax
  800b34:	56                   	push   %esi
  800b35:	e8 26 05 00 00       	call   801060 <strnlen>
  800b3a:	83 c4 10             	add    $0x10,%esp
  800b3d:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800b40:	eb 16                	jmp    800b58 <vprintfmt+0x1dd>
					putch(padc, putdat);
  800b42:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800b46:	83 ec 08             	sub    $0x8,%esp
  800b49:	ff 75 0c             	pushl  0xc(%ebp)
  800b4c:	50                   	push   %eax
  800b4d:	8b 45 08             	mov    0x8(%ebp),%eax
  800b50:	ff d0                	call   *%eax
  800b52:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800b55:	ff 4d e4             	decl   -0x1c(%ebp)
  800b58:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800b5c:	7f e4                	jg     800b42 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800b5e:	eb 34                	jmp    800b94 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800b60:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800b64:	74 1c                	je     800b82 <vprintfmt+0x207>
  800b66:	83 fb 1f             	cmp    $0x1f,%ebx
  800b69:	7e 05                	jle    800b70 <vprintfmt+0x1f5>
  800b6b:	83 fb 7e             	cmp    $0x7e,%ebx
  800b6e:	7e 12                	jle    800b82 <vprintfmt+0x207>
					putch('?', putdat);
  800b70:	83 ec 08             	sub    $0x8,%esp
  800b73:	ff 75 0c             	pushl  0xc(%ebp)
  800b76:	6a 3f                	push   $0x3f
  800b78:	8b 45 08             	mov    0x8(%ebp),%eax
  800b7b:	ff d0                	call   *%eax
  800b7d:	83 c4 10             	add    $0x10,%esp
  800b80:	eb 0f                	jmp    800b91 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800b82:	83 ec 08             	sub    $0x8,%esp
  800b85:	ff 75 0c             	pushl  0xc(%ebp)
  800b88:	53                   	push   %ebx
  800b89:	8b 45 08             	mov    0x8(%ebp),%eax
  800b8c:	ff d0                	call   *%eax
  800b8e:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800b91:	ff 4d e4             	decl   -0x1c(%ebp)
  800b94:	89 f0                	mov    %esi,%eax
  800b96:	8d 70 01             	lea    0x1(%eax),%esi
  800b99:	8a 00                	mov    (%eax),%al
  800b9b:	0f be d8             	movsbl %al,%ebx
  800b9e:	85 db                	test   %ebx,%ebx
  800ba0:	74 24                	je     800bc6 <vprintfmt+0x24b>
  800ba2:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800ba6:	78 b8                	js     800b60 <vprintfmt+0x1e5>
  800ba8:	ff 4d e0             	decl   -0x20(%ebp)
  800bab:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800baf:	79 af                	jns    800b60 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800bb1:	eb 13                	jmp    800bc6 <vprintfmt+0x24b>
				putch(' ', putdat);
  800bb3:	83 ec 08             	sub    $0x8,%esp
  800bb6:	ff 75 0c             	pushl  0xc(%ebp)
  800bb9:	6a 20                	push   $0x20
  800bbb:	8b 45 08             	mov    0x8(%ebp),%eax
  800bbe:	ff d0                	call   *%eax
  800bc0:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800bc3:	ff 4d e4             	decl   -0x1c(%ebp)
  800bc6:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800bca:	7f e7                	jg     800bb3 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800bcc:	e9 78 01 00 00       	jmp    800d49 <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800bd1:	83 ec 08             	sub    $0x8,%esp
  800bd4:	ff 75 e8             	pushl  -0x18(%ebp)
  800bd7:	8d 45 14             	lea    0x14(%ebp),%eax
  800bda:	50                   	push   %eax
  800bdb:	e8 3c fd ff ff       	call   80091c <getint>
  800be0:	83 c4 10             	add    $0x10,%esp
  800be3:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800be6:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800be9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800bec:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800bef:	85 d2                	test   %edx,%edx
  800bf1:	79 23                	jns    800c16 <vprintfmt+0x29b>
				putch('-', putdat);
  800bf3:	83 ec 08             	sub    $0x8,%esp
  800bf6:	ff 75 0c             	pushl  0xc(%ebp)
  800bf9:	6a 2d                	push   $0x2d
  800bfb:	8b 45 08             	mov    0x8(%ebp),%eax
  800bfe:	ff d0                	call   *%eax
  800c00:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800c03:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800c06:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800c09:	f7 d8                	neg    %eax
  800c0b:	83 d2 00             	adc    $0x0,%edx
  800c0e:	f7 da                	neg    %edx
  800c10:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c13:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800c16:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800c1d:	e9 bc 00 00 00       	jmp    800cde <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800c22:	83 ec 08             	sub    $0x8,%esp
  800c25:	ff 75 e8             	pushl  -0x18(%ebp)
  800c28:	8d 45 14             	lea    0x14(%ebp),%eax
  800c2b:	50                   	push   %eax
  800c2c:	e8 84 fc ff ff       	call   8008b5 <getuint>
  800c31:	83 c4 10             	add    $0x10,%esp
  800c34:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c37:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800c3a:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800c41:	e9 98 00 00 00       	jmp    800cde <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800c46:	83 ec 08             	sub    $0x8,%esp
  800c49:	ff 75 0c             	pushl  0xc(%ebp)
  800c4c:	6a 58                	push   $0x58
  800c4e:	8b 45 08             	mov    0x8(%ebp),%eax
  800c51:	ff d0                	call   *%eax
  800c53:	83 c4 10             	add    $0x10,%esp
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
			break;
  800c76:	e9 ce 00 00 00       	jmp    800d49 <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  800c7b:	83 ec 08             	sub    $0x8,%esp
  800c7e:	ff 75 0c             	pushl  0xc(%ebp)
  800c81:	6a 30                	push   $0x30
  800c83:	8b 45 08             	mov    0x8(%ebp),%eax
  800c86:	ff d0                	call   *%eax
  800c88:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800c8b:	83 ec 08             	sub    $0x8,%esp
  800c8e:	ff 75 0c             	pushl  0xc(%ebp)
  800c91:	6a 78                	push   $0x78
  800c93:	8b 45 08             	mov    0x8(%ebp),%eax
  800c96:	ff d0                	call   *%eax
  800c98:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800c9b:	8b 45 14             	mov    0x14(%ebp),%eax
  800c9e:	83 c0 04             	add    $0x4,%eax
  800ca1:	89 45 14             	mov    %eax,0x14(%ebp)
  800ca4:	8b 45 14             	mov    0x14(%ebp),%eax
  800ca7:	83 e8 04             	sub    $0x4,%eax
  800caa:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800cac:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800caf:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800cb6:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800cbd:	eb 1f                	jmp    800cde <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800cbf:	83 ec 08             	sub    $0x8,%esp
  800cc2:	ff 75 e8             	pushl  -0x18(%ebp)
  800cc5:	8d 45 14             	lea    0x14(%ebp),%eax
  800cc8:	50                   	push   %eax
  800cc9:	e8 e7 fb ff ff       	call   8008b5 <getuint>
  800cce:	83 c4 10             	add    $0x10,%esp
  800cd1:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800cd4:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800cd7:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800cde:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800ce2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800ce5:	83 ec 04             	sub    $0x4,%esp
  800ce8:	52                   	push   %edx
  800ce9:	ff 75 e4             	pushl  -0x1c(%ebp)
  800cec:	50                   	push   %eax
  800ced:	ff 75 f4             	pushl  -0xc(%ebp)
  800cf0:	ff 75 f0             	pushl  -0x10(%ebp)
  800cf3:	ff 75 0c             	pushl  0xc(%ebp)
  800cf6:	ff 75 08             	pushl  0x8(%ebp)
  800cf9:	e8 00 fb ff ff       	call   8007fe <printnum>
  800cfe:	83 c4 20             	add    $0x20,%esp
			break;
  800d01:	eb 46                	jmp    800d49 <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800d03:	83 ec 08             	sub    $0x8,%esp
  800d06:	ff 75 0c             	pushl  0xc(%ebp)
  800d09:	53                   	push   %ebx
  800d0a:	8b 45 08             	mov    0x8(%ebp),%eax
  800d0d:	ff d0                	call   *%eax
  800d0f:	83 c4 10             	add    $0x10,%esp
			break;
  800d12:	eb 35                	jmp    800d49 <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  800d14:	c6 05 44 30 80 00 00 	movb   $0x0,0x803044
			break;
  800d1b:	eb 2c                	jmp    800d49 <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  800d1d:	c6 05 44 30 80 00 01 	movb   $0x1,0x803044
			break;
  800d24:	eb 23                	jmp    800d49 <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800d26:	83 ec 08             	sub    $0x8,%esp
  800d29:	ff 75 0c             	pushl  0xc(%ebp)
  800d2c:	6a 25                	push   $0x25
  800d2e:	8b 45 08             	mov    0x8(%ebp),%eax
  800d31:	ff d0                	call   *%eax
  800d33:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800d36:	ff 4d 10             	decl   0x10(%ebp)
  800d39:	eb 03                	jmp    800d3e <vprintfmt+0x3c3>
  800d3b:	ff 4d 10             	decl   0x10(%ebp)
  800d3e:	8b 45 10             	mov    0x10(%ebp),%eax
  800d41:	48                   	dec    %eax
  800d42:	8a 00                	mov    (%eax),%al
  800d44:	3c 25                	cmp    $0x25,%al
  800d46:	75 f3                	jne    800d3b <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  800d48:	90                   	nop
		}
	}
  800d49:	e9 35 fc ff ff       	jmp    800983 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800d4e:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800d4f:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800d52:	5b                   	pop    %ebx
  800d53:	5e                   	pop    %esi
  800d54:	5d                   	pop    %ebp
  800d55:	c3                   	ret    

00800d56 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800d56:	55                   	push   %ebp
  800d57:	89 e5                	mov    %esp,%ebp
  800d59:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800d5c:	8d 45 10             	lea    0x10(%ebp),%eax
  800d5f:	83 c0 04             	add    $0x4,%eax
  800d62:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800d65:	8b 45 10             	mov    0x10(%ebp),%eax
  800d68:	ff 75 f4             	pushl  -0xc(%ebp)
  800d6b:	50                   	push   %eax
  800d6c:	ff 75 0c             	pushl  0xc(%ebp)
  800d6f:	ff 75 08             	pushl  0x8(%ebp)
  800d72:	e8 04 fc ff ff       	call   80097b <vprintfmt>
  800d77:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800d7a:	90                   	nop
  800d7b:	c9                   	leave  
  800d7c:	c3                   	ret    

00800d7d <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800d7d:	55                   	push   %ebp
  800d7e:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800d80:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d83:	8b 40 08             	mov    0x8(%eax),%eax
  800d86:	8d 50 01             	lea    0x1(%eax),%edx
  800d89:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d8c:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800d8f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d92:	8b 10                	mov    (%eax),%edx
  800d94:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d97:	8b 40 04             	mov    0x4(%eax),%eax
  800d9a:	39 c2                	cmp    %eax,%edx
  800d9c:	73 12                	jae    800db0 <sprintputch+0x33>
		*b->buf++ = ch;
  800d9e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800da1:	8b 00                	mov    (%eax),%eax
  800da3:	8d 48 01             	lea    0x1(%eax),%ecx
  800da6:	8b 55 0c             	mov    0xc(%ebp),%edx
  800da9:	89 0a                	mov    %ecx,(%edx)
  800dab:	8b 55 08             	mov    0x8(%ebp),%edx
  800dae:	88 10                	mov    %dl,(%eax)
}
  800db0:	90                   	nop
  800db1:	5d                   	pop    %ebp
  800db2:	c3                   	ret    

00800db3 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800db3:	55                   	push   %ebp
  800db4:	89 e5                	mov    %esp,%ebp
  800db6:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800db9:	8b 45 08             	mov    0x8(%ebp),%eax
  800dbc:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800dbf:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dc2:	8d 50 ff             	lea    -0x1(%eax),%edx
  800dc5:	8b 45 08             	mov    0x8(%ebp),%eax
  800dc8:	01 d0                	add    %edx,%eax
  800dca:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800dcd:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800dd4:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800dd8:	74 06                	je     800de0 <vsnprintf+0x2d>
  800dda:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800dde:	7f 07                	jg     800de7 <vsnprintf+0x34>
		return -E_INVAL;
  800de0:	b8 03 00 00 00       	mov    $0x3,%eax
  800de5:	eb 20                	jmp    800e07 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800de7:	ff 75 14             	pushl  0x14(%ebp)
  800dea:	ff 75 10             	pushl  0x10(%ebp)
  800ded:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800df0:	50                   	push   %eax
  800df1:	68 7d 0d 80 00       	push   $0x800d7d
  800df6:	e8 80 fb ff ff       	call   80097b <vprintfmt>
  800dfb:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800dfe:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800e01:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800e04:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800e07:	c9                   	leave  
  800e08:	c3                   	ret    

00800e09 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800e09:	55                   	push   %ebp
  800e0a:	89 e5                	mov    %esp,%ebp
  800e0c:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800e0f:	8d 45 10             	lea    0x10(%ebp),%eax
  800e12:	83 c0 04             	add    $0x4,%eax
  800e15:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800e18:	8b 45 10             	mov    0x10(%ebp),%eax
  800e1b:	ff 75 f4             	pushl  -0xc(%ebp)
  800e1e:	50                   	push   %eax
  800e1f:	ff 75 0c             	pushl  0xc(%ebp)
  800e22:	ff 75 08             	pushl  0x8(%ebp)
  800e25:	e8 89 ff ff ff       	call   800db3 <vsnprintf>
  800e2a:	83 c4 10             	add    $0x10,%esp
  800e2d:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800e30:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800e33:	c9                   	leave  
  800e34:	c3                   	ret    

00800e35 <readline>:
#include <inc/lib.h>

//static char buf[BUFLEN];

void readline(const char *prompt, char* buf)
{
  800e35:	55                   	push   %ebp
  800e36:	89 e5                	mov    %esp,%ebp
  800e38:	83 ec 18             	sub    $0x18,%esp
	int i, c, echoing;

	if (prompt != NULL)
  800e3b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800e3f:	74 13                	je     800e54 <readline+0x1f>
		cprintf("%s", prompt);
  800e41:	83 ec 08             	sub    $0x8,%esp
  800e44:	ff 75 08             	pushl  0x8(%ebp)
  800e47:	68 28 2a 80 00       	push   $0x802a28
  800e4c:	e8 0b f9 ff ff       	call   80075c <cprintf>
  800e51:	83 c4 10             	add    $0x10,%esp

	i = 0;
  800e54:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	echoing = iscons(0);
  800e5b:	83 ec 0c             	sub    $0xc,%esp
  800e5e:	6a 00                	push   $0x0
  800e60:	e8 7e 10 00 00       	call   801ee3 <iscons>
  800e65:	83 c4 10             	add    $0x10,%esp
  800e68:	89 45 f0             	mov    %eax,-0x10(%ebp)
	while (1) {
		c = getchar();
  800e6b:	e8 60 10 00 00       	call   801ed0 <getchar>
  800e70:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if (c < 0) {
  800e73:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800e77:	79 22                	jns    800e9b <readline+0x66>
			if (c != -E_EOF)
  800e79:	83 7d ec 07          	cmpl   $0x7,-0x14(%ebp)
  800e7d:	0f 84 ad 00 00 00    	je     800f30 <readline+0xfb>
				cprintf("read error: %e\n", c);
  800e83:	83 ec 08             	sub    $0x8,%esp
  800e86:	ff 75 ec             	pushl  -0x14(%ebp)
  800e89:	68 2b 2a 80 00       	push   $0x802a2b
  800e8e:	e8 c9 f8 ff ff       	call   80075c <cprintf>
  800e93:	83 c4 10             	add    $0x10,%esp
			break;
  800e96:	e9 95 00 00 00       	jmp    800f30 <readline+0xfb>
		} else if (c >= ' ' && i < BUFLEN-1) {
  800e9b:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%ebp)
  800e9f:	7e 34                	jle    800ed5 <readline+0xa0>
  800ea1:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  800ea8:	7f 2b                	jg     800ed5 <readline+0xa0>
			if (echoing)
  800eaa:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800eae:	74 0e                	je     800ebe <readline+0x89>
				cputchar(c);
  800eb0:	83 ec 0c             	sub    $0xc,%esp
  800eb3:	ff 75 ec             	pushl  -0x14(%ebp)
  800eb6:	e8 f6 0f 00 00       	call   801eb1 <cputchar>
  800ebb:	83 c4 10             	add    $0x10,%esp
			buf[i++] = c;
  800ebe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800ec1:	8d 50 01             	lea    0x1(%eax),%edx
  800ec4:	89 55 f4             	mov    %edx,-0xc(%ebp)
  800ec7:	89 c2                	mov    %eax,%edx
  800ec9:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ecc:	01 d0                	add    %edx,%eax
  800ece:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800ed1:	88 10                	mov    %dl,(%eax)
  800ed3:	eb 56                	jmp    800f2b <readline+0xf6>
		} else if (c == '\b' && i > 0) {
  800ed5:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  800ed9:	75 1f                	jne    800efa <readline+0xc5>
  800edb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  800edf:	7e 19                	jle    800efa <readline+0xc5>
			if (echoing)
  800ee1:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800ee5:	74 0e                	je     800ef5 <readline+0xc0>
				cputchar(c);
  800ee7:	83 ec 0c             	sub    $0xc,%esp
  800eea:	ff 75 ec             	pushl  -0x14(%ebp)
  800eed:	e8 bf 0f 00 00       	call   801eb1 <cputchar>
  800ef2:	83 c4 10             	add    $0x10,%esp

			i--;
  800ef5:	ff 4d f4             	decl   -0xc(%ebp)
  800ef8:	eb 31                	jmp    800f2b <readline+0xf6>
		} else if (c == '\n' || c == '\r') {
  800efa:	83 7d ec 0a          	cmpl   $0xa,-0x14(%ebp)
  800efe:	74 0a                	je     800f0a <readline+0xd5>
  800f00:	83 7d ec 0d          	cmpl   $0xd,-0x14(%ebp)
  800f04:	0f 85 61 ff ff ff    	jne    800e6b <readline+0x36>
			if (echoing)
  800f0a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800f0e:	74 0e                	je     800f1e <readline+0xe9>
				cputchar(c);
  800f10:	83 ec 0c             	sub    $0xc,%esp
  800f13:	ff 75 ec             	pushl  -0x14(%ebp)
  800f16:	e8 96 0f 00 00       	call   801eb1 <cputchar>
  800f1b:	83 c4 10             	add    $0x10,%esp

			buf[i] = 0;
  800f1e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800f21:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f24:	01 d0                	add    %edx,%eax
  800f26:	c6 00 00             	movb   $0x0,(%eax)
			break;
  800f29:	eb 06                	jmp    800f31 <readline+0xfc>
		}
	}
  800f2b:	e9 3b ff ff ff       	jmp    800e6b <readline+0x36>
	while (1) {
		c = getchar();
		if (c < 0) {
			if (c != -E_EOF)
				cprintf("read error: %e\n", c);
			break;
  800f30:	90                   	nop

			buf[i] = 0;
			break;
		}
	}
}
  800f31:	90                   	nop
  800f32:	c9                   	leave  
  800f33:	c3                   	ret    

00800f34 <atomic_readline>:

void atomic_readline(const char *prompt, char* buf)
{
  800f34:	55                   	push   %ebp
  800f35:	89 e5                	mov    %esp,%ebp
  800f37:	83 ec 18             	sub    $0x18,%esp
	sys_lock_cons();
  800f3a:	e8 79 09 00 00       	call   8018b8 <sys_lock_cons>
	{
		int i, c, echoing;

		if (prompt != NULL)
  800f3f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800f43:	74 13                	je     800f58 <atomic_readline+0x24>
			cprintf("%s", prompt);
  800f45:	83 ec 08             	sub    $0x8,%esp
  800f48:	ff 75 08             	pushl  0x8(%ebp)
  800f4b:	68 28 2a 80 00       	push   $0x802a28
  800f50:	e8 07 f8 ff ff       	call   80075c <cprintf>
  800f55:	83 c4 10             	add    $0x10,%esp

		i = 0;
  800f58:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
		echoing = iscons(0);
  800f5f:	83 ec 0c             	sub    $0xc,%esp
  800f62:	6a 00                	push   $0x0
  800f64:	e8 7a 0f 00 00       	call   801ee3 <iscons>
  800f69:	83 c4 10             	add    $0x10,%esp
  800f6c:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (1) {
			c = getchar();
  800f6f:	e8 5c 0f 00 00       	call   801ed0 <getchar>
  800f74:	89 45 ec             	mov    %eax,-0x14(%ebp)
			if (c < 0) {
  800f77:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800f7b:	79 22                	jns    800f9f <atomic_readline+0x6b>
				if (c != -E_EOF)
  800f7d:	83 7d ec 07          	cmpl   $0x7,-0x14(%ebp)
  800f81:	0f 84 ad 00 00 00    	je     801034 <atomic_readline+0x100>
					cprintf("read error: %e\n", c);
  800f87:	83 ec 08             	sub    $0x8,%esp
  800f8a:	ff 75 ec             	pushl  -0x14(%ebp)
  800f8d:	68 2b 2a 80 00       	push   $0x802a2b
  800f92:	e8 c5 f7 ff ff       	call   80075c <cprintf>
  800f97:	83 c4 10             	add    $0x10,%esp
				break;
  800f9a:	e9 95 00 00 00       	jmp    801034 <atomic_readline+0x100>
			} else if (c >= ' ' && i < BUFLEN-1) {
  800f9f:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%ebp)
  800fa3:	7e 34                	jle    800fd9 <atomic_readline+0xa5>
  800fa5:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  800fac:	7f 2b                	jg     800fd9 <atomic_readline+0xa5>
				if (echoing)
  800fae:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800fb2:	74 0e                	je     800fc2 <atomic_readline+0x8e>
					cputchar(c);
  800fb4:	83 ec 0c             	sub    $0xc,%esp
  800fb7:	ff 75 ec             	pushl  -0x14(%ebp)
  800fba:	e8 f2 0e 00 00       	call   801eb1 <cputchar>
  800fbf:	83 c4 10             	add    $0x10,%esp
				buf[i++] = c;
  800fc2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800fc5:	8d 50 01             	lea    0x1(%eax),%edx
  800fc8:	89 55 f4             	mov    %edx,-0xc(%ebp)
  800fcb:	89 c2                	mov    %eax,%edx
  800fcd:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fd0:	01 d0                	add    %edx,%eax
  800fd2:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800fd5:	88 10                	mov    %dl,(%eax)
  800fd7:	eb 56                	jmp    80102f <atomic_readline+0xfb>
			} else if (c == '\b' && i > 0) {
  800fd9:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  800fdd:	75 1f                	jne    800ffe <atomic_readline+0xca>
  800fdf:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  800fe3:	7e 19                	jle    800ffe <atomic_readline+0xca>
				if (echoing)
  800fe5:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800fe9:	74 0e                	je     800ff9 <atomic_readline+0xc5>
					cputchar(c);
  800feb:	83 ec 0c             	sub    $0xc,%esp
  800fee:	ff 75 ec             	pushl  -0x14(%ebp)
  800ff1:	e8 bb 0e 00 00       	call   801eb1 <cputchar>
  800ff6:	83 c4 10             	add    $0x10,%esp
				i--;
  800ff9:	ff 4d f4             	decl   -0xc(%ebp)
  800ffc:	eb 31                	jmp    80102f <atomic_readline+0xfb>
			} else if (c == '\n' || c == '\r') {
  800ffe:	83 7d ec 0a          	cmpl   $0xa,-0x14(%ebp)
  801002:	74 0a                	je     80100e <atomic_readline+0xda>
  801004:	83 7d ec 0d          	cmpl   $0xd,-0x14(%ebp)
  801008:	0f 85 61 ff ff ff    	jne    800f6f <atomic_readline+0x3b>
				if (echoing)
  80100e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801012:	74 0e                	je     801022 <atomic_readline+0xee>
					cputchar(c);
  801014:	83 ec 0c             	sub    $0xc,%esp
  801017:	ff 75 ec             	pushl  -0x14(%ebp)
  80101a:	e8 92 0e 00 00       	call   801eb1 <cputchar>
  80101f:	83 c4 10             	add    $0x10,%esp
				buf[i] = 0;
  801022:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801025:	8b 45 0c             	mov    0xc(%ebp),%eax
  801028:	01 d0                	add    %edx,%eax
  80102a:	c6 00 00             	movb   $0x0,(%eax)
				break;
  80102d:	eb 06                	jmp    801035 <atomic_readline+0x101>
			}
		}
  80102f:	e9 3b ff ff ff       	jmp    800f6f <atomic_readline+0x3b>
		while (1) {
			c = getchar();
			if (c < 0) {
				if (c != -E_EOF)
					cprintf("read error: %e\n", c);
				break;
  801034:	90                   	nop
				buf[i] = 0;
				break;
			}
		}
	}
	sys_unlock_cons();
  801035:	e8 98 08 00 00       	call   8018d2 <sys_unlock_cons>
}
  80103a:	90                   	nop
  80103b:	c9                   	leave  
  80103c:	c3                   	ret    

0080103d <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  80103d:	55                   	push   %ebp
  80103e:	89 e5                	mov    %esp,%ebp
  801040:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  801043:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80104a:	eb 06                	jmp    801052 <strlen+0x15>
		n++;
  80104c:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  80104f:	ff 45 08             	incl   0x8(%ebp)
  801052:	8b 45 08             	mov    0x8(%ebp),%eax
  801055:	8a 00                	mov    (%eax),%al
  801057:	84 c0                	test   %al,%al
  801059:	75 f1                	jne    80104c <strlen+0xf>
		n++;
	return n;
  80105b:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  80105e:	c9                   	leave  
  80105f:	c3                   	ret    

00801060 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  801060:	55                   	push   %ebp
  801061:	89 e5                	mov    %esp,%ebp
  801063:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801066:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80106d:	eb 09                	jmp    801078 <strnlen+0x18>
		n++;
  80106f:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801072:	ff 45 08             	incl   0x8(%ebp)
  801075:	ff 4d 0c             	decl   0xc(%ebp)
  801078:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80107c:	74 09                	je     801087 <strnlen+0x27>
  80107e:	8b 45 08             	mov    0x8(%ebp),%eax
  801081:	8a 00                	mov    (%eax),%al
  801083:	84 c0                	test   %al,%al
  801085:	75 e8                	jne    80106f <strnlen+0xf>
		n++;
	return n;
  801087:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  80108a:	c9                   	leave  
  80108b:	c3                   	ret    

0080108c <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  80108c:	55                   	push   %ebp
  80108d:	89 e5                	mov    %esp,%ebp
  80108f:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  801092:	8b 45 08             	mov    0x8(%ebp),%eax
  801095:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  801098:	90                   	nop
  801099:	8b 45 08             	mov    0x8(%ebp),%eax
  80109c:	8d 50 01             	lea    0x1(%eax),%edx
  80109f:	89 55 08             	mov    %edx,0x8(%ebp)
  8010a2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8010a5:	8d 4a 01             	lea    0x1(%edx),%ecx
  8010a8:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  8010ab:	8a 12                	mov    (%edx),%dl
  8010ad:	88 10                	mov    %dl,(%eax)
  8010af:	8a 00                	mov    (%eax),%al
  8010b1:	84 c0                	test   %al,%al
  8010b3:	75 e4                	jne    801099 <strcpy+0xd>
		/* do nothing */;
	return ret;
  8010b5:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8010b8:	c9                   	leave  
  8010b9:	c3                   	ret    

008010ba <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  8010ba:	55                   	push   %ebp
  8010bb:	89 e5                	mov    %esp,%ebp
  8010bd:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  8010c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8010c3:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  8010c6:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8010cd:	eb 1f                	jmp    8010ee <strncpy+0x34>
		*dst++ = *src;
  8010cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8010d2:	8d 50 01             	lea    0x1(%eax),%edx
  8010d5:	89 55 08             	mov    %edx,0x8(%ebp)
  8010d8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8010db:	8a 12                	mov    (%edx),%dl
  8010dd:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  8010df:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010e2:	8a 00                	mov    (%eax),%al
  8010e4:	84 c0                	test   %al,%al
  8010e6:	74 03                	je     8010eb <strncpy+0x31>
			src++;
  8010e8:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8010eb:	ff 45 fc             	incl   -0x4(%ebp)
  8010ee:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8010f1:	3b 45 10             	cmp    0x10(%ebp),%eax
  8010f4:	72 d9                	jb     8010cf <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  8010f6:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8010f9:	c9                   	leave  
  8010fa:	c3                   	ret    

008010fb <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  8010fb:	55                   	push   %ebp
  8010fc:	89 e5                	mov    %esp,%ebp
  8010fe:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  801101:	8b 45 08             	mov    0x8(%ebp),%eax
  801104:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  801107:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80110b:	74 30                	je     80113d <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  80110d:	eb 16                	jmp    801125 <strlcpy+0x2a>
			*dst++ = *src++;
  80110f:	8b 45 08             	mov    0x8(%ebp),%eax
  801112:	8d 50 01             	lea    0x1(%eax),%edx
  801115:	89 55 08             	mov    %edx,0x8(%ebp)
  801118:	8b 55 0c             	mov    0xc(%ebp),%edx
  80111b:	8d 4a 01             	lea    0x1(%edx),%ecx
  80111e:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  801121:	8a 12                	mov    (%edx),%dl
  801123:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  801125:	ff 4d 10             	decl   0x10(%ebp)
  801128:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80112c:	74 09                	je     801137 <strlcpy+0x3c>
  80112e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801131:	8a 00                	mov    (%eax),%al
  801133:	84 c0                	test   %al,%al
  801135:	75 d8                	jne    80110f <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  801137:	8b 45 08             	mov    0x8(%ebp),%eax
  80113a:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  80113d:	8b 55 08             	mov    0x8(%ebp),%edx
  801140:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801143:	29 c2                	sub    %eax,%edx
  801145:	89 d0                	mov    %edx,%eax
}
  801147:	c9                   	leave  
  801148:	c3                   	ret    

00801149 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  801149:	55                   	push   %ebp
  80114a:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  80114c:	eb 06                	jmp    801154 <strcmp+0xb>
		p++, q++;
  80114e:	ff 45 08             	incl   0x8(%ebp)
  801151:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  801154:	8b 45 08             	mov    0x8(%ebp),%eax
  801157:	8a 00                	mov    (%eax),%al
  801159:	84 c0                	test   %al,%al
  80115b:	74 0e                	je     80116b <strcmp+0x22>
  80115d:	8b 45 08             	mov    0x8(%ebp),%eax
  801160:	8a 10                	mov    (%eax),%dl
  801162:	8b 45 0c             	mov    0xc(%ebp),%eax
  801165:	8a 00                	mov    (%eax),%al
  801167:	38 c2                	cmp    %al,%dl
  801169:	74 e3                	je     80114e <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  80116b:	8b 45 08             	mov    0x8(%ebp),%eax
  80116e:	8a 00                	mov    (%eax),%al
  801170:	0f b6 d0             	movzbl %al,%edx
  801173:	8b 45 0c             	mov    0xc(%ebp),%eax
  801176:	8a 00                	mov    (%eax),%al
  801178:	0f b6 c0             	movzbl %al,%eax
  80117b:	29 c2                	sub    %eax,%edx
  80117d:	89 d0                	mov    %edx,%eax
}
  80117f:	5d                   	pop    %ebp
  801180:	c3                   	ret    

00801181 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  801181:	55                   	push   %ebp
  801182:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  801184:	eb 09                	jmp    80118f <strncmp+0xe>
		n--, p++, q++;
  801186:	ff 4d 10             	decl   0x10(%ebp)
  801189:	ff 45 08             	incl   0x8(%ebp)
  80118c:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  80118f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801193:	74 17                	je     8011ac <strncmp+0x2b>
  801195:	8b 45 08             	mov    0x8(%ebp),%eax
  801198:	8a 00                	mov    (%eax),%al
  80119a:	84 c0                	test   %al,%al
  80119c:	74 0e                	je     8011ac <strncmp+0x2b>
  80119e:	8b 45 08             	mov    0x8(%ebp),%eax
  8011a1:	8a 10                	mov    (%eax),%dl
  8011a3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011a6:	8a 00                	mov    (%eax),%al
  8011a8:	38 c2                	cmp    %al,%dl
  8011aa:	74 da                	je     801186 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  8011ac:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8011b0:	75 07                	jne    8011b9 <strncmp+0x38>
		return 0;
  8011b2:	b8 00 00 00 00       	mov    $0x0,%eax
  8011b7:	eb 14                	jmp    8011cd <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8011b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8011bc:	8a 00                	mov    (%eax),%al
  8011be:	0f b6 d0             	movzbl %al,%edx
  8011c1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011c4:	8a 00                	mov    (%eax),%al
  8011c6:	0f b6 c0             	movzbl %al,%eax
  8011c9:	29 c2                	sub    %eax,%edx
  8011cb:	89 d0                	mov    %edx,%eax
}
  8011cd:	5d                   	pop    %ebp
  8011ce:	c3                   	ret    

008011cf <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8011cf:	55                   	push   %ebp
  8011d0:	89 e5                	mov    %esp,%ebp
  8011d2:	83 ec 04             	sub    $0x4,%esp
  8011d5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011d8:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  8011db:	eb 12                	jmp    8011ef <strchr+0x20>
		if (*s == c)
  8011dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8011e0:	8a 00                	mov    (%eax),%al
  8011e2:	3a 45 fc             	cmp    -0x4(%ebp),%al
  8011e5:	75 05                	jne    8011ec <strchr+0x1d>
			return (char *) s;
  8011e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8011ea:	eb 11                	jmp    8011fd <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  8011ec:	ff 45 08             	incl   0x8(%ebp)
  8011ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8011f2:	8a 00                	mov    (%eax),%al
  8011f4:	84 c0                	test   %al,%al
  8011f6:	75 e5                	jne    8011dd <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  8011f8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8011fd:	c9                   	leave  
  8011fe:	c3                   	ret    

008011ff <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8011ff:	55                   	push   %ebp
  801200:	89 e5                	mov    %esp,%ebp
  801202:	83 ec 04             	sub    $0x4,%esp
  801205:	8b 45 0c             	mov    0xc(%ebp),%eax
  801208:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  80120b:	eb 0d                	jmp    80121a <strfind+0x1b>
		if (*s == c)
  80120d:	8b 45 08             	mov    0x8(%ebp),%eax
  801210:	8a 00                	mov    (%eax),%al
  801212:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801215:	74 0e                	je     801225 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  801217:	ff 45 08             	incl   0x8(%ebp)
  80121a:	8b 45 08             	mov    0x8(%ebp),%eax
  80121d:	8a 00                	mov    (%eax),%al
  80121f:	84 c0                	test   %al,%al
  801221:	75 ea                	jne    80120d <strfind+0xe>
  801223:	eb 01                	jmp    801226 <strfind+0x27>
		if (*s == c)
			break;
  801225:	90                   	nop
	return (char *) s;
  801226:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801229:	c9                   	leave  
  80122a:	c3                   	ret    

0080122b <memset>:

// *************** The faster implementation of memset & memcpy is implemented by *************
// ****************** Team80 (Yahia Khaled, Malek Ahmed et al) - FCIS'24-25 *******************
void *
memset(void *v, int c, uint32 n)
{
  80122b:	55                   	push   %ebp
  80122c:	89 e5                	mov    %esp,%ebp
  80122e:	83 ec 10             	sub    $0x10,%esp
//	m = n;
//	while (--m >= 0)
//		*p++ = c;

	/*Faster Implementation*/
	uint64* p64 = (uint64*)v;
  801231:	8b 45 08             	mov    0x8(%ebp),%eax
  801234:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if(n >= 8){
  801237:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  80123b:	76 63                	jbe    8012a0 <memset+0x75>
		uint64 data_block = c;
  80123d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801240:	99                   	cltd   
  801241:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801244:	89 55 f4             	mov    %edx,-0xc(%ebp)
		data_block |= data_block << 8;
  801247:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80124a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80124d:	0f a4 c2 08          	shld   $0x8,%eax,%edx
  801251:	c1 e0 08             	shl    $0x8,%eax
  801254:	09 45 f0             	or     %eax,-0x10(%ebp)
  801257:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 16;
  80125a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80125d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801260:	0f a4 c2 10          	shld   $0x10,%eax,%edx
  801264:	c1 e0 10             	shl    $0x10,%eax
  801267:	09 45 f0             	or     %eax,-0x10(%ebp)
  80126a:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 32;
  80126d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801270:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801273:	89 c2                	mov    %eax,%edx
  801275:	b8 00 00 00 00       	mov    $0x0,%eax
  80127a:	09 45 f0             	or     %eax,-0x10(%ebp)
  80127d:	09 55 f4             	or     %edx,-0xc(%ebp)

		while(n >= 8)
  801280:	eb 18                	jmp    80129a <memset+0x6f>
			*p64++ = data_block, n -= 8;
  801282:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801285:	8d 41 08             	lea    0x8(%ecx),%eax
  801288:	89 45 fc             	mov    %eax,-0x4(%ebp)
  80128b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80128e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801291:	89 01                	mov    %eax,(%ecx)
  801293:	89 51 04             	mov    %edx,0x4(%ecx)
  801296:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
		uint64 data_block = c;
		data_block |= data_block << 8;
		data_block |= data_block << 16;
		data_block |= data_block << 32;

		while(n >= 8)
  80129a:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  80129e:	77 e2                	ja     801282 <memset+0x57>
			*p64++ = data_block, n -= 8;
	}

	if(n){
  8012a0:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8012a4:	74 23                	je     8012c9 <memset+0x9e>
		uint8* p8 = (uint8*)p64;
  8012a6:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8012a9:	89 45 f8             	mov    %eax,-0x8(%ebp)
		while (n-- > 0)
  8012ac:	eb 0e                	jmp    8012bc <memset+0x91>
			*p8++ = (uint8)c;
  8012ae:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8012b1:	8d 50 01             	lea    0x1(%eax),%edx
  8012b4:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8012b7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8012ba:	88 10                	mov    %dl,(%eax)
			*p64++ = data_block, n -= 8;
	}

	if(n){
		uint8* p8 = (uint8*)p64;
		while (n-- > 0)
  8012bc:	8b 45 10             	mov    0x10(%ebp),%eax
  8012bf:	8d 50 ff             	lea    -0x1(%eax),%edx
  8012c2:	89 55 10             	mov    %edx,0x10(%ebp)
  8012c5:	85 c0                	test   %eax,%eax
  8012c7:	75 e5                	jne    8012ae <memset+0x83>
			*p8++ = (uint8)c;
	}

	return v;
  8012c9:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8012cc:	c9                   	leave  
  8012cd:	c3                   	ret    

008012ce <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  8012ce:	55                   	push   %ebp
  8012cf:	89 e5                	mov    %esp,%ebp
  8012d1:	83 ec 10             	sub    $0x10,%esp
	//	s = src;
	//	d = dst;
	//	while (n-- > 0)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
  8012d4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012d7:	89 45 fc             	mov    %eax,-0x4(%ebp)
	uint64* d64 = (uint64*)dst;
  8012da:	8b 45 08             	mov    0x8(%ebp),%eax
  8012dd:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if(n >= 8){
  8012e0:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  8012e4:	76 24                	jbe    80130a <memcpy+0x3c>
		while(n >= 8){
  8012e6:	eb 1c                	jmp    801304 <memcpy+0x36>
			*d64 = *s64;
  8012e8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8012eb:	8b 50 04             	mov    0x4(%eax),%edx
  8012ee:	8b 00                	mov    (%eax),%eax
  8012f0:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8012f3:	89 01                	mov    %eax,(%ecx)
  8012f5:	89 51 04             	mov    %edx,0x4(%ecx)
			n -= 8;
  8012f8:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
			++s64;
  8012fc:	83 45 fc 08          	addl   $0x8,-0x4(%ebp)
			++d64;
  801300:	83 45 f8 08          	addl   $0x8,-0x8(%ebp)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
	uint64* d64 = (uint64*)dst;
	if(n >= 8){
		while(n >= 8){
  801304:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  801308:	77 de                	ja     8012e8 <memcpy+0x1a>
			++s64;
			++d64;
		}
	}

	if(n){
  80130a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80130e:	74 31                	je     801341 <memcpy+0x73>
		uint8* s8 = (uint8*)s64;
  801310:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801313:	89 45 f4             	mov    %eax,-0xc(%ebp)
		uint8* d8 = (uint8*)d64;
  801316:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801319:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (n-- > 0)
  80131c:	eb 16                	jmp    801334 <memcpy+0x66>
			*d8++ = *s8++;
  80131e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801321:	8d 50 01             	lea    0x1(%eax),%edx
  801324:	89 55 f0             	mov    %edx,-0x10(%ebp)
  801327:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80132a:	8d 4a 01             	lea    0x1(%edx),%ecx
  80132d:	89 4d f4             	mov    %ecx,-0xc(%ebp)
  801330:	8a 12                	mov    (%edx),%dl
  801332:	88 10                	mov    %dl,(%eax)
	}

	if(n){
		uint8* s8 = (uint8*)s64;
		uint8* d8 = (uint8*)d64;
		while (n-- > 0)
  801334:	8b 45 10             	mov    0x10(%ebp),%eax
  801337:	8d 50 ff             	lea    -0x1(%eax),%edx
  80133a:	89 55 10             	mov    %edx,0x10(%ebp)
  80133d:	85 c0                	test   %eax,%eax
  80133f:	75 dd                	jne    80131e <memcpy+0x50>
			*d8++ = *s8++;
	}
	return dst;
  801341:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801344:	c9                   	leave  
  801345:	c3                   	ret    

00801346 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  801346:	55                   	push   %ebp
  801347:	89 e5                	mov    %esp,%ebp
  801349:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  80134c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80134f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801352:	8b 45 08             	mov    0x8(%ebp),%eax
  801355:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  801358:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80135b:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  80135e:	73 50                	jae    8013b0 <memmove+0x6a>
  801360:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801363:	8b 45 10             	mov    0x10(%ebp),%eax
  801366:	01 d0                	add    %edx,%eax
  801368:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  80136b:	76 43                	jbe    8013b0 <memmove+0x6a>
		s += n;
  80136d:	8b 45 10             	mov    0x10(%ebp),%eax
  801370:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  801373:	8b 45 10             	mov    0x10(%ebp),%eax
  801376:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  801379:	eb 10                	jmp    80138b <memmove+0x45>
			*--d = *--s;
  80137b:	ff 4d f8             	decl   -0x8(%ebp)
  80137e:	ff 4d fc             	decl   -0x4(%ebp)
  801381:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801384:	8a 10                	mov    (%eax),%dl
  801386:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801389:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  80138b:	8b 45 10             	mov    0x10(%ebp),%eax
  80138e:	8d 50 ff             	lea    -0x1(%eax),%edx
  801391:	89 55 10             	mov    %edx,0x10(%ebp)
  801394:	85 c0                	test   %eax,%eax
  801396:	75 e3                	jne    80137b <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  801398:	eb 23                	jmp    8013bd <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  80139a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80139d:	8d 50 01             	lea    0x1(%eax),%edx
  8013a0:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8013a3:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8013a6:	8d 4a 01             	lea    0x1(%edx),%ecx
  8013a9:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  8013ac:	8a 12                	mov    (%edx),%dl
  8013ae:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  8013b0:	8b 45 10             	mov    0x10(%ebp),%eax
  8013b3:	8d 50 ff             	lea    -0x1(%eax),%edx
  8013b6:	89 55 10             	mov    %edx,0x10(%ebp)
  8013b9:	85 c0                	test   %eax,%eax
  8013bb:	75 dd                	jne    80139a <memmove+0x54>
			*d++ = *s++;

	return dst;
  8013bd:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8013c0:	c9                   	leave  
  8013c1:	c3                   	ret    

008013c2 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  8013c2:	55                   	push   %ebp
  8013c3:	89 e5                	mov    %esp,%ebp
  8013c5:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  8013c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8013cb:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  8013ce:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013d1:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  8013d4:	eb 2a                	jmp    801400 <memcmp+0x3e>
		if (*s1 != *s2)
  8013d6:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8013d9:	8a 10                	mov    (%eax),%dl
  8013db:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8013de:	8a 00                	mov    (%eax),%al
  8013e0:	38 c2                	cmp    %al,%dl
  8013e2:	74 16                	je     8013fa <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  8013e4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8013e7:	8a 00                	mov    (%eax),%al
  8013e9:	0f b6 d0             	movzbl %al,%edx
  8013ec:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8013ef:	8a 00                	mov    (%eax),%al
  8013f1:	0f b6 c0             	movzbl %al,%eax
  8013f4:	29 c2                	sub    %eax,%edx
  8013f6:	89 d0                	mov    %edx,%eax
  8013f8:	eb 18                	jmp    801412 <memcmp+0x50>
		s1++, s2++;
  8013fa:	ff 45 fc             	incl   -0x4(%ebp)
  8013fd:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  801400:	8b 45 10             	mov    0x10(%ebp),%eax
  801403:	8d 50 ff             	lea    -0x1(%eax),%edx
  801406:	89 55 10             	mov    %edx,0x10(%ebp)
  801409:	85 c0                	test   %eax,%eax
  80140b:	75 c9                	jne    8013d6 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  80140d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801412:	c9                   	leave  
  801413:	c3                   	ret    

00801414 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  801414:	55                   	push   %ebp
  801415:	89 e5                	mov    %esp,%ebp
  801417:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  80141a:	8b 55 08             	mov    0x8(%ebp),%edx
  80141d:	8b 45 10             	mov    0x10(%ebp),%eax
  801420:	01 d0                	add    %edx,%eax
  801422:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  801425:	eb 15                	jmp    80143c <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  801427:	8b 45 08             	mov    0x8(%ebp),%eax
  80142a:	8a 00                	mov    (%eax),%al
  80142c:	0f b6 d0             	movzbl %al,%edx
  80142f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801432:	0f b6 c0             	movzbl %al,%eax
  801435:	39 c2                	cmp    %eax,%edx
  801437:	74 0d                	je     801446 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801439:	ff 45 08             	incl   0x8(%ebp)
  80143c:	8b 45 08             	mov    0x8(%ebp),%eax
  80143f:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801442:	72 e3                	jb     801427 <memfind+0x13>
  801444:	eb 01                	jmp    801447 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  801446:	90                   	nop
	return (void *) s;
  801447:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80144a:	c9                   	leave  
  80144b:	c3                   	ret    

0080144c <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  80144c:	55                   	push   %ebp
  80144d:	89 e5                	mov    %esp,%ebp
  80144f:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  801452:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  801459:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801460:	eb 03                	jmp    801465 <strtol+0x19>
		s++;
  801462:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801465:	8b 45 08             	mov    0x8(%ebp),%eax
  801468:	8a 00                	mov    (%eax),%al
  80146a:	3c 20                	cmp    $0x20,%al
  80146c:	74 f4                	je     801462 <strtol+0x16>
  80146e:	8b 45 08             	mov    0x8(%ebp),%eax
  801471:	8a 00                	mov    (%eax),%al
  801473:	3c 09                	cmp    $0x9,%al
  801475:	74 eb                	je     801462 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  801477:	8b 45 08             	mov    0x8(%ebp),%eax
  80147a:	8a 00                	mov    (%eax),%al
  80147c:	3c 2b                	cmp    $0x2b,%al
  80147e:	75 05                	jne    801485 <strtol+0x39>
		s++;
  801480:	ff 45 08             	incl   0x8(%ebp)
  801483:	eb 13                	jmp    801498 <strtol+0x4c>
	else if (*s == '-')
  801485:	8b 45 08             	mov    0x8(%ebp),%eax
  801488:	8a 00                	mov    (%eax),%al
  80148a:	3c 2d                	cmp    $0x2d,%al
  80148c:	75 0a                	jne    801498 <strtol+0x4c>
		s++, neg = 1;
  80148e:	ff 45 08             	incl   0x8(%ebp)
  801491:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801498:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80149c:	74 06                	je     8014a4 <strtol+0x58>
  80149e:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  8014a2:	75 20                	jne    8014c4 <strtol+0x78>
  8014a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8014a7:	8a 00                	mov    (%eax),%al
  8014a9:	3c 30                	cmp    $0x30,%al
  8014ab:	75 17                	jne    8014c4 <strtol+0x78>
  8014ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8014b0:	40                   	inc    %eax
  8014b1:	8a 00                	mov    (%eax),%al
  8014b3:	3c 78                	cmp    $0x78,%al
  8014b5:	75 0d                	jne    8014c4 <strtol+0x78>
		s += 2, base = 16;
  8014b7:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  8014bb:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  8014c2:	eb 28                	jmp    8014ec <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  8014c4:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8014c8:	75 15                	jne    8014df <strtol+0x93>
  8014ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8014cd:	8a 00                	mov    (%eax),%al
  8014cf:	3c 30                	cmp    $0x30,%al
  8014d1:	75 0c                	jne    8014df <strtol+0x93>
		s++, base = 8;
  8014d3:	ff 45 08             	incl   0x8(%ebp)
  8014d6:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  8014dd:	eb 0d                	jmp    8014ec <strtol+0xa0>
	else if (base == 0)
  8014df:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8014e3:	75 07                	jne    8014ec <strtol+0xa0>
		base = 10;
  8014e5:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8014ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8014ef:	8a 00                	mov    (%eax),%al
  8014f1:	3c 2f                	cmp    $0x2f,%al
  8014f3:	7e 19                	jle    80150e <strtol+0xc2>
  8014f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8014f8:	8a 00                	mov    (%eax),%al
  8014fa:	3c 39                	cmp    $0x39,%al
  8014fc:	7f 10                	jg     80150e <strtol+0xc2>
			dig = *s - '0';
  8014fe:	8b 45 08             	mov    0x8(%ebp),%eax
  801501:	8a 00                	mov    (%eax),%al
  801503:	0f be c0             	movsbl %al,%eax
  801506:	83 e8 30             	sub    $0x30,%eax
  801509:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80150c:	eb 42                	jmp    801550 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  80150e:	8b 45 08             	mov    0x8(%ebp),%eax
  801511:	8a 00                	mov    (%eax),%al
  801513:	3c 60                	cmp    $0x60,%al
  801515:	7e 19                	jle    801530 <strtol+0xe4>
  801517:	8b 45 08             	mov    0x8(%ebp),%eax
  80151a:	8a 00                	mov    (%eax),%al
  80151c:	3c 7a                	cmp    $0x7a,%al
  80151e:	7f 10                	jg     801530 <strtol+0xe4>
			dig = *s - 'a' + 10;
  801520:	8b 45 08             	mov    0x8(%ebp),%eax
  801523:	8a 00                	mov    (%eax),%al
  801525:	0f be c0             	movsbl %al,%eax
  801528:	83 e8 57             	sub    $0x57,%eax
  80152b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80152e:	eb 20                	jmp    801550 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  801530:	8b 45 08             	mov    0x8(%ebp),%eax
  801533:	8a 00                	mov    (%eax),%al
  801535:	3c 40                	cmp    $0x40,%al
  801537:	7e 39                	jle    801572 <strtol+0x126>
  801539:	8b 45 08             	mov    0x8(%ebp),%eax
  80153c:	8a 00                	mov    (%eax),%al
  80153e:	3c 5a                	cmp    $0x5a,%al
  801540:	7f 30                	jg     801572 <strtol+0x126>
			dig = *s - 'A' + 10;
  801542:	8b 45 08             	mov    0x8(%ebp),%eax
  801545:	8a 00                	mov    (%eax),%al
  801547:	0f be c0             	movsbl %al,%eax
  80154a:	83 e8 37             	sub    $0x37,%eax
  80154d:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  801550:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801553:	3b 45 10             	cmp    0x10(%ebp),%eax
  801556:	7d 19                	jge    801571 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801558:	ff 45 08             	incl   0x8(%ebp)
  80155b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80155e:	0f af 45 10          	imul   0x10(%ebp),%eax
  801562:	89 c2                	mov    %eax,%edx
  801564:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801567:	01 d0                	add    %edx,%eax
  801569:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  80156c:	e9 7b ff ff ff       	jmp    8014ec <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801571:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801572:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801576:	74 08                	je     801580 <strtol+0x134>
		*endptr = (char *) s;
  801578:	8b 45 0c             	mov    0xc(%ebp),%eax
  80157b:	8b 55 08             	mov    0x8(%ebp),%edx
  80157e:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  801580:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801584:	74 07                	je     80158d <strtol+0x141>
  801586:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801589:	f7 d8                	neg    %eax
  80158b:	eb 03                	jmp    801590 <strtol+0x144>
  80158d:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801590:	c9                   	leave  
  801591:	c3                   	ret    

00801592 <ltostr>:

void
ltostr(long value, char *str)
{
  801592:	55                   	push   %ebp
  801593:	89 e5                	mov    %esp,%ebp
  801595:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  801598:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  80159f:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  8015a6:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8015aa:	79 13                	jns    8015bf <ltostr+0x2d>
	{
		neg = 1;
  8015ac:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  8015b3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015b6:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  8015b9:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  8015bc:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  8015bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8015c2:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8015c7:	99                   	cltd   
  8015c8:	f7 f9                	idiv   %ecx
  8015ca:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  8015cd:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8015d0:	8d 50 01             	lea    0x1(%eax),%edx
  8015d3:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8015d6:	89 c2                	mov    %eax,%edx
  8015d8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015db:	01 d0                	add    %edx,%eax
  8015dd:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8015e0:	83 c2 30             	add    $0x30,%edx
  8015e3:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  8015e5:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8015e8:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8015ed:	f7 e9                	imul   %ecx
  8015ef:	c1 fa 02             	sar    $0x2,%edx
  8015f2:	89 c8                	mov    %ecx,%eax
  8015f4:	c1 f8 1f             	sar    $0x1f,%eax
  8015f7:	29 c2                	sub    %eax,%edx
  8015f9:	89 d0                	mov    %edx,%eax
  8015fb:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  8015fe:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801602:	75 bb                	jne    8015bf <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801604:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  80160b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80160e:	48                   	dec    %eax
  80160f:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801612:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801616:	74 3d                	je     801655 <ltostr+0xc3>
		start = 1 ;
  801618:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  80161f:	eb 34                	jmp    801655 <ltostr+0xc3>
	{
		char tmp = str[start] ;
  801621:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801624:	8b 45 0c             	mov    0xc(%ebp),%eax
  801627:	01 d0                	add    %edx,%eax
  801629:	8a 00                	mov    (%eax),%al
  80162b:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  80162e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801631:	8b 45 0c             	mov    0xc(%ebp),%eax
  801634:	01 c2                	add    %eax,%edx
  801636:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801639:	8b 45 0c             	mov    0xc(%ebp),%eax
  80163c:	01 c8                	add    %ecx,%eax
  80163e:	8a 00                	mov    (%eax),%al
  801640:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801642:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801645:	8b 45 0c             	mov    0xc(%ebp),%eax
  801648:	01 c2                	add    %eax,%edx
  80164a:	8a 45 eb             	mov    -0x15(%ebp),%al
  80164d:	88 02                	mov    %al,(%edx)
		start++ ;
  80164f:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801652:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801655:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801658:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80165b:	7c c4                	jl     801621 <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  80165d:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801660:	8b 45 0c             	mov    0xc(%ebp),%eax
  801663:	01 d0                	add    %edx,%eax
  801665:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801668:	90                   	nop
  801669:	c9                   	leave  
  80166a:	c3                   	ret    

0080166b <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  80166b:	55                   	push   %ebp
  80166c:	89 e5                	mov    %esp,%ebp
  80166e:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801671:	ff 75 08             	pushl  0x8(%ebp)
  801674:	e8 c4 f9 ff ff       	call   80103d <strlen>
  801679:	83 c4 04             	add    $0x4,%esp
  80167c:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  80167f:	ff 75 0c             	pushl  0xc(%ebp)
  801682:	e8 b6 f9 ff ff       	call   80103d <strlen>
  801687:	83 c4 04             	add    $0x4,%esp
  80168a:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  80168d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  801694:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80169b:	eb 17                	jmp    8016b4 <strcconcat+0x49>
		final[s] = str1[s] ;
  80169d:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8016a0:	8b 45 10             	mov    0x10(%ebp),%eax
  8016a3:	01 c2                	add    %eax,%edx
  8016a5:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8016a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8016ab:	01 c8                	add    %ecx,%eax
  8016ad:	8a 00                	mov    (%eax),%al
  8016af:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  8016b1:	ff 45 fc             	incl   -0x4(%ebp)
  8016b4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8016b7:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8016ba:	7c e1                	jl     80169d <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  8016bc:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  8016c3:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8016ca:	eb 1f                	jmp    8016eb <strcconcat+0x80>
		final[s++] = str2[i] ;
  8016cc:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8016cf:	8d 50 01             	lea    0x1(%eax),%edx
  8016d2:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8016d5:	89 c2                	mov    %eax,%edx
  8016d7:	8b 45 10             	mov    0x10(%ebp),%eax
  8016da:	01 c2                	add    %eax,%edx
  8016dc:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8016df:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016e2:	01 c8                	add    %ecx,%eax
  8016e4:	8a 00                	mov    (%eax),%al
  8016e6:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  8016e8:	ff 45 f8             	incl   -0x8(%ebp)
  8016eb:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8016ee:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8016f1:	7c d9                	jl     8016cc <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  8016f3:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8016f6:	8b 45 10             	mov    0x10(%ebp),%eax
  8016f9:	01 d0                	add    %edx,%eax
  8016fb:	c6 00 00             	movb   $0x0,(%eax)
}
  8016fe:	90                   	nop
  8016ff:	c9                   	leave  
  801700:	c3                   	ret    

00801701 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801701:	55                   	push   %ebp
  801702:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801704:	8b 45 14             	mov    0x14(%ebp),%eax
  801707:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  80170d:	8b 45 14             	mov    0x14(%ebp),%eax
  801710:	8b 00                	mov    (%eax),%eax
  801712:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801719:	8b 45 10             	mov    0x10(%ebp),%eax
  80171c:	01 d0                	add    %edx,%eax
  80171e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801724:	eb 0c                	jmp    801732 <strsplit+0x31>
			*string++ = 0;
  801726:	8b 45 08             	mov    0x8(%ebp),%eax
  801729:	8d 50 01             	lea    0x1(%eax),%edx
  80172c:	89 55 08             	mov    %edx,0x8(%ebp)
  80172f:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801732:	8b 45 08             	mov    0x8(%ebp),%eax
  801735:	8a 00                	mov    (%eax),%al
  801737:	84 c0                	test   %al,%al
  801739:	74 18                	je     801753 <strsplit+0x52>
  80173b:	8b 45 08             	mov    0x8(%ebp),%eax
  80173e:	8a 00                	mov    (%eax),%al
  801740:	0f be c0             	movsbl %al,%eax
  801743:	50                   	push   %eax
  801744:	ff 75 0c             	pushl  0xc(%ebp)
  801747:	e8 83 fa ff ff       	call   8011cf <strchr>
  80174c:	83 c4 08             	add    $0x8,%esp
  80174f:	85 c0                	test   %eax,%eax
  801751:	75 d3                	jne    801726 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801753:	8b 45 08             	mov    0x8(%ebp),%eax
  801756:	8a 00                	mov    (%eax),%al
  801758:	84 c0                	test   %al,%al
  80175a:	74 5a                	je     8017b6 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  80175c:	8b 45 14             	mov    0x14(%ebp),%eax
  80175f:	8b 00                	mov    (%eax),%eax
  801761:	83 f8 0f             	cmp    $0xf,%eax
  801764:	75 07                	jne    80176d <strsplit+0x6c>
		{
			return 0;
  801766:	b8 00 00 00 00       	mov    $0x0,%eax
  80176b:	eb 66                	jmp    8017d3 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  80176d:	8b 45 14             	mov    0x14(%ebp),%eax
  801770:	8b 00                	mov    (%eax),%eax
  801772:	8d 48 01             	lea    0x1(%eax),%ecx
  801775:	8b 55 14             	mov    0x14(%ebp),%edx
  801778:	89 0a                	mov    %ecx,(%edx)
  80177a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801781:	8b 45 10             	mov    0x10(%ebp),%eax
  801784:	01 c2                	add    %eax,%edx
  801786:	8b 45 08             	mov    0x8(%ebp),%eax
  801789:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  80178b:	eb 03                	jmp    801790 <strsplit+0x8f>
			string++;
  80178d:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801790:	8b 45 08             	mov    0x8(%ebp),%eax
  801793:	8a 00                	mov    (%eax),%al
  801795:	84 c0                	test   %al,%al
  801797:	74 8b                	je     801724 <strsplit+0x23>
  801799:	8b 45 08             	mov    0x8(%ebp),%eax
  80179c:	8a 00                	mov    (%eax),%al
  80179e:	0f be c0             	movsbl %al,%eax
  8017a1:	50                   	push   %eax
  8017a2:	ff 75 0c             	pushl  0xc(%ebp)
  8017a5:	e8 25 fa ff ff       	call   8011cf <strchr>
  8017aa:	83 c4 08             	add    $0x8,%esp
  8017ad:	85 c0                	test   %eax,%eax
  8017af:	74 dc                	je     80178d <strsplit+0x8c>
			string++;
	}
  8017b1:	e9 6e ff ff ff       	jmp    801724 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  8017b6:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  8017b7:	8b 45 14             	mov    0x14(%ebp),%eax
  8017ba:	8b 00                	mov    (%eax),%eax
  8017bc:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8017c3:	8b 45 10             	mov    0x10(%ebp),%eax
  8017c6:	01 d0                	add    %edx,%eax
  8017c8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  8017ce:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8017d3:	c9                   	leave  
  8017d4:	c3                   	ret    

008017d5 <str2lower>:


char* str2lower(char *dst, const char *src)
{
  8017d5:	55                   	push   %ebp
  8017d6:	89 e5                	mov    %esp,%ebp
  8017d8:	83 ec 10             	sub    $0x10,%esp
	char* ret = dst;
  8017db:	8b 45 08             	mov    0x8(%ebp),%eax
  8017de:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (int i = 0; i < strlen(src); ++i)
  8017e1:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8017e8:	eb 4a                	jmp    801834 <str2lower+0x5f>
	{
		dst[i] = src[i] ;
  8017ea:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8017ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8017f0:	01 c2                	add    %eax,%edx
  8017f2:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8017f5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017f8:	01 c8                	add    %ecx,%eax
  8017fa:	8a 00                	mov    (%eax),%al
  8017fc:	88 02                	mov    %al,(%edx)
		if (src[i] >= 'A' && src[i] <= 'Z')
  8017fe:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801801:	8b 45 0c             	mov    0xc(%ebp),%eax
  801804:	01 d0                	add    %edx,%eax
  801806:	8a 00                	mov    (%eax),%al
  801808:	3c 40                	cmp    $0x40,%al
  80180a:	7e 25                	jle    801831 <str2lower+0x5c>
  80180c:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80180f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801812:	01 d0                	add    %edx,%eax
  801814:	8a 00                	mov    (%eax),%al
  801816:	3c 5a                	cmp    $0x5a,%al
  801818:	7f 17                	jg     801831 <str2lower+0x5c>
		{
			dst[i] += 32 ;
  80181a:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80181d:	8b 45 08             	mov    0x8(%ebp),%eax
  801820:	01 d0                	add    %edx,%eax
  801822:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801825:	8b 55 08             	mov    0x8(%ebp),%edx
  801828:	01 ca                	add    %ecx,%edx
  80182a:	8a 12                	mov    (%edx),%dl
  80182c:	83 c2 20             	add    $0x20,%edx
  80182f:	88 10                	mov    %dl,(%eax)


char* str2lower(char *dst, const char *src)
{
	char* ret = dst;
	for (int i = 0; i < strlen(src); ++i)
  801831:	ff 45 fc             	incl   -0x4(%ebp)
  801834:	ff 75 0c             	pushl  0xc(%ebp)
  801837:	e8 01 f8 ff ff       	call   80103d <strlen>
  80183c:	83 c4 04             	add    $0x4,%esp
  80183f:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801842:	7f a6                	jg     8017ea <str2lower+0x15>
		if (src[i] >= 'A' && src[i] <= 'Z')
		{
			dst[i] += 32 ;
		}
	}
	return ret;
  801844:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801847:	c9                   	leave  
  801848:	c3                   	ret    

00801849 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801849:	55                   	push   %ebp
  80184a:	89 e5                	mov    %esp,%ebp
  80184c:	57                   	push   %edi
  80184d:	56                   	push   %esi
  80184e:	53                   	push   %ebx
  80184f:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801852:	8b 45 08             	mov    0x8(%ebp),%eax
  801855:	8b 55 0c             	mov    0xc(%ebp),%edx
  801858:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80185b:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80185e:	8b 7d 18             	mov    0x18(%ebp),%edi
  801861:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801864:	cd 30                	int    $0x30
  801866:	89 45 f0             	mov    %eax,-0x10(%ebp)
				"b" (a3),
				"D" (a4),
				"S" (a5)
				: "cc", "memory");

	return ret;
  801869:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80186c:	83 c4 10             	add    $0x10,%esp
  80186f:	5b                   	pop    %ebx
  801870:	5e                   	pop    %esi
  801871:	5f                   	pop    %edi
  801872:	5d                   	pop    %ebp
  801873:	c3                   	ret    

00801874 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName, int color)
{
  801874:	55                   	push   %ebp
  801875:	89 e5                	mov    %esp,%ebp
  801877:	83 ec 04             	sub    $0x4,%esp
  80187a:	8b 45 10             	mov    0x10(%ebp),%eax
  80187d:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, color, 0);
  801880:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801883:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801887:	8b 45 08             	mov    0x8(%ebp),%eax
  80188a:	6a 00                	push   $0x0
  80188c:	51                   	push   %ecx
  80188d:	52                   	push   %edx
  80188e:	ff 75 0c             	pushl  0xc(%ebp)
  801891:	50                   	push   %eax
  801892:	6a 00                	push   $0x0
  801894:	e8 b0 ff ff ff       	call   801849 <syscall>
  801899:	83 c4 18             	add    $0x18,%esp
}
  80189c:	90                   	nop
  80189d:	c9                   	leave  
  80189e:	c3                   	ret    

0080189f <sys_cgetc>:

int
sys_cgetc(void)
{
  80189f:	55                   	push   %ebp
  8018a0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  8018a2:	6a 00                	push   $0x0
  8018a4:	6a 00                	push   $0x0
  8018a6:	6a 00                	push   $0x0
  8018a8:	6a 00                	push   $0x0
  8018aa:	6a 00                	push   $0x0
  8018ac:	6a 02                	push   $0x2
  8018ae:	e8 96 ff ff ff       	call   801849 <syscall>
  8018b3:	83 c4 18             	add    $0x18,%esp
}
  8018b6:	c9                   	leave  
  8018b7:	c3                   	ret    

008018b8 <sys_lock_cons>:

void sys_lock_cons(void)
{
  8018b8:	55                   	push   %ebp
  8018b9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  8018bb:	6a 00                	push   $0x0
  8018bd:	6a 00                	push   $0x0
  8018bf:	6a 00                	push   $0x0
  8018c1:	6a 00                	push   $0x0
  8018c3:	6a 00                	push   $0x0
  8018c5:	6a 03                	push   $0x3
  8018c7:	e8 7d ff ff ff       	call   801849 <syscall>
  8018cc:	83 c4 18             	add    $0x18,%esp
}
  8018cf:	90                   	nop
  8018d0:	c9                   	leave  
  8018d1:	c3                   	ret    

008018d2 <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  8018d2:	55                   	push   %ebp
  8018d3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  8018d5:	6a 00                	push   $0x0
  8018d7:	6a 00                	push   $0x0
  8018d9:	6a 00                	push   $0x0
  8018db:	6a 00                	push   $0x0
  8018dd:	6a 00                	push   $0x0
  8018df:	6a 04                	push   $0x4
  8018e1:	e8 63 ff ff ff       	call   801849 <syscall>
  8018e6:	83 c4 18             	add    $0x18,%esp
}
  8018e9:	90                   	nop
  8018ea:	c9                   	leave  
  8018eb:	c3                   	ret    

008018ec <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  8018ec:	55                   	push   %ebp
  8018ed:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  8018ef:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8018f5:	6a 00                	push   $0x0
  8018f7:	6a 00                	push   $0x0
  8018f9:	6a 00                	push   $0x0
  8018fb:	52                   	push   %edx
  8018fc:	50                   	push   %eax
  8018fd:	6a 08                	push   $0x8
  8018ff:	e8 45 ff ff ff       	call   801849 <syscall>
  801904:	83 c4 18             	add    $0x18,%esp
}
  801907:	c9                   	leave  
  801908:	c3                   	ret    

00801909 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801909:	55                   	push   %ebp
  80190a:	89 e5                	mov    %esp,%ebp
  80190c:	56                   	push   %esi
  80190d:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  80190e:	8b 75 18             	mov    0x18(%ebp),%esi
  801911:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801914:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801917:	8b 55 0c             	mov    0xc(%ebp),%edx
  80191a:	8b 45 08             	mov    0x8(%ebp),%eax
  80191d:	56                   	push   %esi
  80191e:	53                   	push   %ebx
  80191f:	51                   	push   %ecx
  801920:	52                   	push   %edx
  801921:	50                   	push   %eax
  801922:	6a 09                	push   $0x9
  801924:	e8 20 ff ff ff       	call   801849 <syscall>
  801929:	83 c4 18             	add    $0x18,%esp
}
  80192c:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80192f:	5b                   	pop    %ebx
  801930:	5e                   	pop    %esi
  801931:	5d                   	pop    %ebp
  801932:	c3                   	ret    

00801933 <__sys_unmap_frame>:

int __sys_unmap_frame(uint32 va)
{
  801933:	55                   	push   %ebp
  801934:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, va, 0, 0, 0, 0);
  801936:	6a 00                	push   $0x0
  801938:	6a 00                	push   $0x0
  80193a:	6a 00                	push   $0x0
  80193c:	6a 00                	push   $0x0
  80193e:	ff 75 08             	pushl  0x8(%ebp)
  801941:	6a 0a                	push   $0xa
  801943:	e8 01 ff ff ff       	call   801849 <syscall>
  801948:	83 c4 18             	add    $0x18,%esp
}
  80194b:	c9                   	leave  
  80194c:	c3                   	ret    

0080194d <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  80194d:	55                   	push   %ebp
  80194e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801950:	6a 00                	push   $0x0
  801952:	6a 00                	push   $0x0
  801954:	6a 00                	push   $0x0
  801956:	ff 75 0c             	pushl  0xc(%ebp)
  801959:	ff 75 08             	pushl  0x8(%ebp)
  80195c:	6a 0b                	push   $0xb
  80195e:	e8 e6 fe ff ff       	call   801849 <syscall>
  801963:	83 c4 18             	add    $0x18,%esp
}
  801966:	c9                   	leave  
  801967:	c3                   	ret    

00801968 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801968:	55                   	push   %ebp
  801969:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  80196b:	6a 00                	push   $0x0
  80196d:	6a 00                	push   $0x0
  80196f:	6a 00                	push   $0x0
  801971:	6a 00                	push   $0x0
  801973:	6a 00                	push   $0x0
  801975:	6a 0c                	push   $0xc
  801977:	e8 cd fe ff ff       	call   801849 <syscall>
  80197c:	83 c4 18             	add    $0x18,%esp
}
  80197f:	c9                   	leave  
  801980:	c3                   	ret    

00801981 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801981:	55                   	push   %ebp
  801982:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801984:	6a 00                	push   $0x0
  801986:	6a 00                	push   $0x0
  801988:	6a 00                	push   $0x0
  80198a:	6a 00                	push   $0x0
  80198c:	6a 00                	push   $0x0
  80198e:	6a 0d                	push   $0xd
  801990:	e8 b4 fe ff ff       	call   801849 <syscall>
  801995:	83 c4 18             	add    $0x18,%esp
}
  801998:	c9                   	leave  
  801999:	c3                   	ret    

0080199a <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  80199a:	55                   	push   %ebp
  80199b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  80199d:	6a 00                	push   $0x0
  80199f:	6a 00                	push   $0x0
  8019a1:	6a 00                	push   $0x0
  8019a3:	6a 00                	push   $0x0
  8019a5:	6a 00                	push   $0x0
  8019a7:	6a 0e                	push   $0xe
  8019a9:	e8 9b fe ff ff       	call   801849 <syscall>
  8019ae:	83 c4 18             	add    $0x18,%esp
}
  8019b1:	c9                   	leave  
  8019b2:	c3                   	ret    

008019b3 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  8019b3:	55                   	push   %ebp
  8019b4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  8019b6:	6a 00                	push   $0x0
  8019b8:	6a 00                	push   $0x0
  8019ba:	6a 00                	push   $0x0
  8019bc:	6a 00                	push   $0x0
  8019be:	6a 00                	push   $0x0
  8019c0:	6a 0f                	push   $0xf
  8019c2:	e8 82 fe ff ff       	call   801849 <syscall>
  8019c7:	83 c4 18             	add    $0x18,%esp
}
  8019ca:	c9                   	leave  
  8019cb:	c3                   	ret    

008019cc <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  8019cc:	55                   	push   %ebp
  8019cd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  8019cf:	6a 00                	push   $0x0
  8019d1:	6a 00                	push   $0x0
  8019d3:	6a 00                	push   $0x0
  8019d5:	6a 00                	push   $0x0
  8019d7:	ff 75 08             	pushl  0x8(%ebp)
  8019da:	6a 10                	push   $0x10
  8019dc:	e8 68 fe ff ff       	call   801849 <syscall>
  8019e1:	83 c4 18             	add    $0x18,%esp
}
  8019e4:	c9                   	leave  
  8019e5:	c3                   	ret    

008019e6 <sys_scarce_memory>:

void sys_scarce_memory()
{
  8019e6:	55                   	push   %ebp
  8019e7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  8019e9:	6a 00                	push   $0x0
  8019eb:	6a 00                	push   $0x0
  8019ed:	6a 00                	push   $0x0
  8019ef:	6a 00                	push   $0x0
  8019f1:	6a 00                	push   $0x0
  8019f3:	6a 11                	push   $0x11
  8019f5:	e8 4f fe ff ff       	call   801849 <syscall>
  8019fa:	83 c4 18             	add    $0x18,%esp
}
  8019fd:	90                   	nop
  8019fe:	c9                   	leave  
  8019ff:	c3                   	ret    

00801a00 <sys_cputc>:

void
sys_cputc(const char c)
{
  801a00:	55                   	push   %ebp
  801a01:	89 e5                	mov    %esp,%ebp
  801a03:	83 ec 04             	sub    $0x4,%esp
  801a06:	8b 45 08             	mov    0x8(%ebp),%eax
  801a09:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801a0c:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801a10:	6a 00                	push   $0x0
  801a12:	6a 00                	push   $0x0
  801a14:	6a 00                	push   $0x0
  801a16:	6a 00                	push   $0x0
  801a18:	50                   	push   %eax
  801a19:	6a 01                	push   $0x1
  801a1b:	e8 29 fe ff ff       	call   801849 <syscall>
  801a20:	83 c4 18             	add    $0x18,%esp
}
  801a23:	90                   	nop
  801a24:	c9                   	leave  
  801a25:	c3                   	ret    

00801a26 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801a26:	55                   	push   %ebp
  801a27:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801a29:	6a 00                	push   $0x0
  801a2b:	6a 00                	push   $0x0
  801a2d:	6a 00                	push   $0x0
  801a2f:	6a 00                	push   $0x0
  801a31:	6a 00                	push   $0x0
  801a33:	6a 14                	push   $0x14
  801a35:	e8 0f fe ff ff       	call   801849 <syscall>
  801a3a:	83 c4 18             	add    $0x18,%esp
}
  801a3d:	90                   	nop
  801a3e:	c9                   	leave  
  801a3f:	c3                   	ret    

00801a40 <sys_create_shared_object>:

int sys_create_shared_object(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801a40:	55                   	push   %ebp
  801a41:	89 e5                	mov    %esp,%ebp
  801a43:	83 ec 04             	sub    $0x4,%esp
  801a46:	8b 45 10             	mov    0x10(%ebp),%eax
  801a49:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801a4c:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801a4f:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801a53:	8b 45 08             	mov    0x8(%ebp),%eax
  801a56:	6a 00                	push   $0x0
  801a58:	51                   	push   %ecx
  801a59:	52                   	push   %edx
  801a5a:	ff 75 0c             	pushl  0xc(%ebp)
  801a5d:	50                   	push   %eax
  801a5e:	6a 15                	push   $0x15
  801a60:	e8 e4 fd ff ff       	call   801849 <syscall>
  801a65:	83 c4 18             	add    $0x18,%esp
}
  801a68:	c9                   	leave  
  801a69:	c3                   	ret    

00801a6a <sys_size_of_shared_object>:

//2017:
int sys_size_of_shared_object(int32 ownerID, char* shareName)
{
  801a6a:	55                   	push   %ebp
  801a6b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801a6d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a70:	8b 45 08             	mov    0x8(%ebp),%eax
  801a73:	6a 00                	push   $0x0
  801a75:	6a 00                	push   $0x0
  801a77:	6a 00                	push   $0x0
  801a79:	52                   	push   %edx
  801a7a:	50                   	push   %eax
  801a7b:	6a 16                	push   $0x16
  801a7d:	e8 c7 fd ff ff       	call   801849 <syscall>
  801a82:	83 c4 18             	add    $0x18,%esp
}
  801a85:	c9                   	leave  
  801a86:	c3                   	ret    

00801a87 <sys_get_shared_object>:
//==========

int sys_get_shared_object(int32 ownerID, char* shareName, void* virtual_address)
{
  801a87:	55                   	push   %ebp
  801a88:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801a8a:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801a8d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a90:	8b 45 08             	mov    0x8(%ebp),%eax
  801a93:	6a 00                	push   $0x0
  801a95:	6a 00                	push   $0x0
  801a97:	51                   	push   %ecx
  801a98:	52                   	push   %edx
  801a99:	50                   	push   %eax
  801a9a:	6a 17                	push   $0x17
  801a9c:	e8 a8 fd ff ff       	call   801849 <syscall>
  801aa1:	83 c4 18             	add    $0x18,%esp
}
  801aa4:	c9                   	leave  
  801aa5:	c3                   	ret    

00801aa6 <sys_delete_shared_object>:

int sys_delete_shared_object(int32 sharedObjectID, void *startVA)
{
  801aa6:	55                   	push   %ebp
  801aa7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801aa9:	8b 55 0c             	mov    0xc(%ebp),%edx
  801aac:	8b 45 08             	mov    0x8(%ebp),%eax
  801aaf:	6a 00                	push   $0x0
  801ab1:	6a 00                	push   $0x0
  801ab3:	6a 00                	push   $0x0
  801ab5:	52                   	push   %edx
  801ab6:	50                   	push   %eax
  801ab7:	6a 18                	push   $0x18
  801ab9:	e8 8b fd ff ff       	call   801849 <syscall>
  801abe:	83 c4 18             	add    $0x18,%esp
}
  801ac1:	c9                   	leave  
  801ac2:	c3                   	ret    

00801ac3 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801ac3:	55                   	push   %ebp
  801ac4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801ac6:	8b 45 08             	mov    0x8(%ebp),%eax
  801ac9:	6a 00                	push   $0x0
  801acb:	ff 75 14             	pushl  0x14(%ebp)
  801ace:	ff 75 10             	pushl  0x10(%ebp)
  801ad1:	ff 75 0c             	pushl  0xc(%ebp)
  801ad4:	50                   	push   %eax
  801ad5:	6a 19                	push   $0x19
  801ad7:	e8 6d fd ff ff       	call   801849 <syscall>
  801adc:	83 c4 18             	add    $0x18,%esp
}
  801adf:	c9                   	leave  
  801ae0:	c3                   	ret    

00801ae1 <sys_run_env>:

void sys_run_env(int32 envId)
{
  801ae1:	55                   	push   %ebp
  801ae2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801ae4:	8b 45 08             	mov    0x8(%ebp),%eax
  801ae7:	6a 00                	push   $0x0
  801ae9:	6a 00                	push   $0x0
  801aeb:	6a 00                	push   $0x0
  801aed:	6a 00                	push   $0x0
  801aef:	50                   	push   %eax
  801af0:	6a 1a                	push   $0x1a
  801af2:	e8 52 fd ff ff       	call   801849 <syscall>
  801af7:	83 c4 18             	add    $0x18,%esp
}
  801afa:	90                   	nop
  801afb:	c9                   	leave  
  801afc:	c3                   	ret    

00801afd <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801afd:	55                   	push   %ebp
  801afe:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801b00:	8b 45 08             	mov    0x8(%ebp),%eax
  801b03:	6a 00                	push   $0x0
  801b05:	6a 00                	push   $0x0
  801b07:	6a 00                	push   $0x0
  801b09:	6a 00                	push   $0x0
  801b0b:	50                   	push   %eax
  801b0c:	6a 1b                	push   $0x1b
  801b0e:	e8 36 fd ff ff       	call   801849 <syscall>
  801b13:	83 c4 18             	add    $0x18,%esp
}
  801b16:	c9                   	leave  
  801b17:	c3                   	ret    

00801b18 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801b18:	55                   	push   %ebp
  801b19:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801b1b:	6a 00                	push   $0x0
  801b1d:	6a 00                	push   $0x0
  801b1f:	6a 00                	push   $0x0
  801b21:	6a 00                	push   $0x0
  801b23:	6a 00                	push   $0x0
  801b25:	6a 05                	push   $0x5
  801b27:	e8 1d fd ff ff       	call   801849 <syscall>
  801b2c:	83 c4 18             	add    $0x18,%esp
}
  801b2f:	c9                   	leave  
  801b30:	c3                   	ret    

00801b31 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801b31:	55                   	push   %ebp
  801b32:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801b34:	6a 00                	push   $0x0
  801b36:	6a 00                	push   $0x0
  801b38:	6a 00                	push   $0x0
  801b3a:	6a 00                	push   $0x0
  801b3c:	6a 00                	push   $0x0
  801b3e:	6a 06                	push   $0x6
  801b40:	e8 04 fd ff ff       	call   801849 <syscall>
  801b45:	83 c4 18             	add    $0x18,%esp
}
  801b48:	c9                   	leave  
  801b49:	c3                   	ret    

00801b4a <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801b4a:	55                   	push   %ebp
  801b4b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801b4d:	6a 00                	push   $0x0
  801b4f:	6a 00                	push   $0x0
  801b51:	6a 00                	push   $0x0
  801b53:	6a 00                	push   $0x0
  801b55:	6a 00                	push   $0x0
  801b57:	6a 07                	push   $0x7
  801b59:	e8 eb fc ff ff       	call   801849 <syscall>
  801b5e:	83 c4 18             	add    $0x18,%esp
}
  801b61:	c9                   	leave  
  801b62:	c3                   	ret    

00801b63 <sys_exit_env>:


void sys_exit_env(void)
{
  801b63:	55                   	push   %ebp
  801b64:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801b66:	6a 00                	push   $0x0
  801b68:	6a 00                	push   $0x0
  801b6a:	6a 00                	push   $0x0
  801b6c:	6a 00                	push   $0x0
  801b6e:	6a 00                	push   $0x0
  801b70:	6a 1c                	push   $0x1c
  801b72:	e8 d2 fc ff ff       	call   801849 <syscall>
  801b77:	83 c4 18             	add    $0x18,%esp
}
  801b7a:	90                   	nop
  801b7b:	c9                   	leave  
  801b7c:	c3                   	ret    

00801b7d <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  801b7d:	55                   	push   %ebp
  801b7e:	89 e5                	mov    %esp,%ebp
  801b80:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801b83:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801b86:	8d 50 04             	lea    0x4(%eax),%edx
  801b89:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801b8c:	6a 00                	push   $0x0
  801b8e:	6a 00                	push   $0x0
  801b90:	6a 00                	push   $0x0
  801b92:	52                   	push   %edx
  801b93:	50                   	push   %eax
  801b94:	6a 1d                	push   $0x1d
  801b96:	e8 ae fc ff ff       	call   801849 <syscall>
  801b9b:	83 c4 18             	add    $0x18,%esp
	return result;
  801b9e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801ba1:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801ba4:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801ba7:	89 01                	mov    %eax,(%ecx)
  801ba9:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801bac:	8b 45 08             	mov    0x8(%ebp),%eax
  801baf:	c9                   	leave  
  801bb0:	c2 04 00             	ret    $0x4

00801bb3 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801bb3:	55                   	push   %ebp
  801bb4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801bb6:	6a 00                	push   $0x0
  801bb8:	6a 00                	push   $0x0
  801bba:	ff 75 10             	pushl  0x10(%ebp)
  801bbd:	ff 75 0c             	pushl  0xc(%ebp)
  801bc0:	ff 75 08             	pushl  0x8(%ebp)
  801bc3:	6a 13                	push   $0x13
  801bc5:	e8 7f fc ff ff       	call   801849 <syscall>
  801bca:	83 c4 18             	add    $0x18,%esp
	return ;
  801bcd:	90                   	nop
}
  801bce:	c9                   	leave  
  801bcf:	c3                   	ret    

00801bd0 <sys_rcr2>:
uint32 sys_rcr2()
{
  801bd0:	55                   	push   %ebp
  801bd1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801bd3:	6a 00                	push   $0x0
  801bd5:	6a 00                	push   $0x0
  801bd7:	6a 00                	push   $0x0
  801bd9:	6a 00                	push   $0x0
  801bdb:	6a 00                	push   $0x0
  801bdd:	6a 1e                	push   $0x1e
  801bdf:	e8 65 fc ff ff       	call   801849 <syscall>
  801be4:	83 c4 18             	add    $0x18,%esp
}
  801be7:	c9                   	leave  
  801be8:	c3                   	ret    

00801be9 <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  801be9:	55                   	push   %ebp
  801bea:	89 e5                	mov    %esp,%ebp
  801bec:	83 ec 04             	sub    $0x4,%esp
  801bef:	8b 45 08             	mov    0x8(%ebp),%eax
  801bf2:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801bf5:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801bf9:	6a 00                	push   $0x0
  801bfb:	6a 00                	push   $0x0
  801bfd:	6a 00                	push   $0x0
  801bff:	6a 00                	push   $0x0
  801c01:	50                   	push   %eax
  801c02:	6a 1f                	push   $0x1f
  801c04:	e8 40 fc ff ff       	call   801849 <syscall>
  801c09:	83 c4 18             	add    $0x18,%esp
	return ;
  801c0c:	90                   	nop
}
  801c0d:	c9                   	leave  
  801c0e:	c3                   	ret    

00801c0f <rsttst>:
void rsttst()
{
  801c0f:	55                   	push   %ebp
  801c10:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801c12:	6a 00                	push   $0x0
  801c14:	6a 00                	push   $0x0
  801c16:	6a 00                	push   $0x0
  801c18:	6a 00                	push   $0x0
  801c1a:	6a 00                	push   $0x0
  801c1c:	6a 21                	push   $0x21
  801c1e:	e8 26 fc ff ff       	call   801849 <syscall>
  801c23:	83 c4 18             	add    $0x18,%esp
	return ;
  801c26:	90                   	nop
}
  801c27:	c9                   	leave  
  801c28:	c3                   	ret    

00801c29 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801c29:	55                   	push   %ebp
  801c2a:	89 e5                	mov    %esp,%ebp
  801c2c:	83 ec 04             	sub    $0x4,%esp
  801c2f:	8b 45 14             	mov    0x14(%ebp),%eax
  801c32:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801c35:	8b 55 18             	mov    0x18(%ebp),%edx
  801c38:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801c3c:	52                   	push   %edx
  801c3d:	50                   	push   %eax
  801c3e:	ff 75 10             	pushl  0x10(%ebp)
  801c41:	ff 75 0c             	pushl  0xc(%ebp)
  801c44:	ff 75 08             	pushl  0x8(%ebp)
  801c47:	6a 20                	push   $0x20
  801c49:	e8 fb fb ff ff       	call   801849 <syscall>
  801c4e:	83 c4 18             	add    $0x18,%esp
	return ;
  801c51:	90                   	nop
}
  801c52:	c9                   	leave  
  801c53:	c3                   	ret    

00801c54 <chktst>:
void chktst(uint32 n)
{
  801c54:	55                   	push   %ebp
  801c55:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801c57:	6a 00                	push   $0x0
  801c59:	6a 00                	push   $0x0
  801c5b:	6a 00                	push   $0x0
  801c5d:	6a 00                	push   $0x0
  801c5f:	ff 75 08             	pushl  0x8(%ebp)
  801c62:	6a 22                	push   $0x22
  801c64:	e8 e0 fb ff ff       	call   801849 <syscall>
  801c69:	83 c4 18             	add    $0x18,%esp
	return ;
  801c6c:	90                   	nop
}
  801c6d:	c9                   	leave  
  801c6e:	c3                   	ret    

00801c6f <inctst>:

void inctst()
{
  801c6f:	55                   	push   %ebp
  801c70:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801c72:	6a 00                	push   $0x0
  801c74:	6a 00                	push   $0x0
  801c76:	6a 00                	push   $0x0
  801c78:	6a 00                	push   $0x0
  801c7a:	6a 00                	push   $0x0
  801c7c:	6a 23                	push   $0x23
  801c7e:	e8 c6 fb ff ff       	call   801849 <syscall>
  801c83:	83 c4 18             	add    $0x18,%esp
	return ;
  801c86:	90                   	nop
}
  801c87:	c9                   	leave  
  801c88:	c3                   	ret    

00801c89 <gettst>:
uint32 gettst()
{
  801c89:	55                   	push   %ebp
  801c8a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801c8c:	6a 00                	push   $0x0
  801c8e:	6a 00                	push   $0x0
  801c90:	6a 00                	push   $0x0
  801c92:	6a 00                	push   $0x0
  801c94:	6a 00                	push   $0x0
  801c96:	6a 24                	push   $0x24
  801c98:	e8 ac fb ff ff       	call   801849 <syscall>
  801c9d:	83 c4 18             	add    $0x18,%esp
}
  801ca0:	c9                   	leave  
  801ca1:	c3                   	ret    

00801ca2 <sys_get_uheap_strategy>:

/*2025*/
uint32 sys_get_uheap_strategy()
{
  801ca2:	55                   	push   %ebp
  801ca3:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801ca5:	6a 00                	push   $0x0
  801ca7:	6a 00                	push   $0x0
  801ca9:	6a 00                	push   $0x0
  801cab:	6a 00                	push   $0x0
  801cad:	6a 00                	push   $0x0
  801caf:	6a 25                	push   $0x25
  801cb1:	e8 93 fb ff ff       	call   801849 <syscall>
  801cb6:	83 c4 18             	add    $0x18,%esp
  801cb9:	a3 60 b0 81 00       	mov    %eax,0x81b060
	return uheapPlaceStrategy ;
  801cbe:	a1 60 b0 81 00       	mov    0x81b060,%eax
}
  801cc3:	c9                   	leave  
  801cc4:	c3                   	ret    

00801cc5 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801cc5:	55                   	push   %ebp
  801cc6:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = heapStrategy;
  801cc8:	8b 45 08             	mov    0x8(%ebp),%eax
  801ccb:	a3 60 b0 81 00       	mov    %eax,0x81b060
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801cd0:	6a 00                	push   $0x0
  801cd2:	6a 00                	push   $0x0
  801cd4:	6a 00                	push   $0x0
  801cd6:	6a 00                	push   $0x0
  801cd8:	ff 75 08             	pushl  0x8(%ebp)
  801cdb:	6a 26                	push   $0x26
  801cdd:	e8 67 fb ff ff       	call   801849 <syscall>
  801ce2:	83 c4 18             	add    $0x18,%esp
	return ;
  801ce5:	90                   	nop
}
  801ce6:	c9                   	leave  
  801ce7:	c3                   	ret    

00801ce8 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801ce8:	55                   	push   %ebp
  801ce9:	89 e5                	mov    %esp,%ebp
  801ceb:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801cec:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801cef:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801cf2:	8b 55 0c             	mov    0xc(%ebp),%edx
  801cf5:	8b 45 08             	mov    0x8(%ebp),%eax
  801cf8:	6a 00                	push   $0x0
  801cfa:	53                   	push   %ebx
  801cfb:	51                   	push   %ecx
  801cfc:	52                   	push   %edx
  801cfd:	50                   	push   %eax
  801cfe:	6a 27                	push   $0x27
  801d00:	e8 44 fb ff ff       	call   801849 <syscall>
  801d05:	83 c4 18             	add    $0x18,%esp
}
  801d08:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801d0b:	c9                   	leave  
  801d0c:	c3                   	ret    

00801d0d <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801d0d:	55                   	push   %ebp
  801d0e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801d10:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d13:	8b 45 08             	mov    0x8(%ebp),%eax
  801d16:	6a 00                	push   $0x0
  801d18:	6a 00                	push   $0x0
  801d1a:	6a 00                	push   $0x0
  801d1c:	52                   	push   %edx
  801d1d:	50                   	push   %eax
  801d1e:	6a 28                	push   $0x28
  801d20:	e8 24 fb ff ff       	call   801849 <syscall>
  801d25:	83 c4 18             	add    $0x18,%esp
}
  801d28:	c9                   	leave  
  801d29:	c3                   	ret    

00801d2a <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  801d2a:	55                   	push   %ebp
  801d2b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  801d2d:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801d30:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d33:	8b 45 08             	mov    0x8(%ebp),%eax
  801d36:	6a 00                	push   $0x0
  801d38:	51                   	push   %ecx
  801d39:	ff 75 10             	pushl  0x10(%ebp)
  801d3c:	52                   	push   %edx
  801d3d:	50                   	push   %eax
  801d3e:	6a 29                	push   $0x29
  801d40:	e8 04 fb ff ff       	call   801849 <syscall>
  801d45:	83 c4 18             	add    $0x18,%esp
}
  801d48:	c9                   	leave  
  801d49:	c3                   	ret    

00801d4a <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801d4a:	55                   	push   %ebp
  801d4b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801d4d:	6a 00                	push   $0x0
  801d4f:	6a 00                	push   $0x0
  801d51:	ff 75 10             	pushl  0x10(%ebp)
  801d54:	ff 75 0c             	pushl  0xc(%ebp)
  801d57:	ff 75 08             	pushl  0x8(%ebp)
  801d5a:	6a 12                	push   $0x12
  801d5c:	e8 e8 fa ff ff       	call   801849 <syscall>
  801d61:	83 c4 18             	add    $0x18,%esp
	return ;
  801d64:	90                   	nop
}
  801d65:	c9                   	leave  
  801d66:	c3                   	ret    

00801d67 <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  801d67:	55                   	push   %ebp
  801d68:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  801d6a:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d6d:	8b 45 08             	mov    0x8(%ebp),%eax
  801d70:	6a 00                	push   $0x0
  801d72:	6a 00                	push   $0x0
  801d74:	6a 00                	push   $0x0
  801d76:	52                   	push   %edx
  801d77:	50                   	push   %eax
  801d78:	6a 2a                	push   $0x2a
  801d7a:	e8 ca fa ff ff       	call   801849 <syscall>
  801d7f:	83 c4 18             	add    $0x18,%esp
	return;
  801d82:	90                   	nop
}
  801d83:	c9                   	leave  
  801d84:	c3                   	ret    

00801d85 <sys_get_optimal_num_faults>:
/*2025*/
int sys_get_optimal_num_faults()
{
  801d85:	55                   	push   %ebp
  801d86:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_optimal_num_faults, 0, 0, 0, 0, 0);
  801d88:	6a 00                	push   $0x0
  801d8a:	6a 00                	push   $0x0
  801d8c:	6a 00                	push   $0x0
  801d8e:	6a 00                	push   $0x0
  801d90:	6a 00                	push   $0x0
  801d92:	6a 2b                	push   $0x2b
  801d94:	e8 b0 fa ff ff       	call   801849 <syscall>
  801d99:	83 c4 18             	add    $0x18,%esp
}
  801d9c:	c9                   	leave  
  801d9d:	c3                   	ret    

00801d9e <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801d9e:	55                   	push   %ebp
  801d9f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801da1:	6a 00                	push   $0x0
  801da3:	6a 00                	push   $0x0
  801da5:	6a 00                	push   $0x0
  801da7:	ff 75 0c             	pushl  0xc(%ebp)
  801daa:	ff 75 08             	pushl  0x8(%ebp)
  801dad:	6a 2d                	push   $0x2d
  801daf:	e8 95 fa ff ff       	call   801849 <syscall>
  801db4:	83 c4 18             	add    $0x18,%esp
	return;
  801db7:	90                   	nop
}
  801db8:	c9                   	leave  
  801db9:	c3                   	ret    

00801dba <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801dba:	55                   	push   %ebp
  801dbb:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801dbd:	6a 00                	push   $0x0
  801dbf:	6a 00                	push   $0x0
  801dc1:	6a 00                	push   $0x0
  801dc3:	ff 75 0c             	pushl  0xc(%ebp)
  801dc6:	ff 75 08             	pushl  0x8(%ebp)
  801dc9:	6a 2c                	push   $0x2c
  801dcb:	e8 79 fa ff ff       	call   801849 <syscall>
  801dd0:	83 c4 18             	add    $0x18,%esp
	return ;
  801dd3:	90                   	nop
}
  801dd4:	c9                   	leave  
  801dd5:	c3                   	ret    

00801dd6 <sys_env_set_priority>:


void sys_env_set_priority(int32 envID, int priority)
{
  801dd6:	55                   	push   %ebp
  801dd7:	89 e5                	mov    %esp,%ebp
  801dd9:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.IM#4] CPU SCHEDULING - #1 System Calls - Add suitable code here
	//Your code is here
	//Comment the following line
	panic("sys_env_set_priority() is not implemented yet...!!");
  801ddc:	83 ec 04             	sub    $0x4,%esp
  801ddf:	68 3c 2a 80 00       	push   $0x802a3c
  801de4:	68 25 01 00 00       	push   $0x125
  801de9:	68 6f 2a 80 00       	push   $0x802a6f
  801dee:	e8 9b e6 ff ff       	call   80048e <_panic>

00801df3 <env_sleep>:
#include <inc/lib.h>
#include <inc/timerreg.h>

void
env_sleep(uint32 approxMilliSeconds)
{
  801df3:	55                   	push   %ebp
  801df4:	89 e5                	mov    %esp,%ebp
  801df6:	83 ec 30             	sub    $0x30,%esp
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
  801df9:	8b 55 08             	mov    0x8(%ebp),%edx
  801dfc:	89 d0                	mov    %edx,%eax
  801dfe:	c1 e0 02             	shl    $0x2,%eax
  801e01:	01 d0                	add    %edx,%eax
  801e03:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801e0a:	01 d0                	add    %edx,%eax
  801e0c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801e13:	01 d0                	add    %edx,%eax
  801e15:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801e1c:	01 d0                	add    %edx,%eax
  801e1e:	c1 e0 04             	shl    $0x4,%eax
  801e21:	89 45 f8             	mov    %eax,-0x8(%ebp)
	uint32 cycles_counter =0;
  801e24:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)

static inline __attribute__((always_inline)) struct uint64 get_virtual_time_user()
{
	struct uint64 result;

	__asm __volatile("rdtsc\n"
  801e2b:	0f 31                	rdtsc  
  801e2d:	89 45 e8             	mov    %eax,-0x18(%ebp)
  801e30:	89 55 ec             	mov    %edx,-0x14(%ebp)
	: "=a" (result.low), "=d" (result.hi)
	);

	return result;
  801e33:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801e36:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801e39:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801e3c:	89 55 f4             	mov    %edx,-0xc(%ebp)

	/*2024*/ //USE A USER-SIDE VERSION OF THIS FUNCTION TO AVOID SLOW-DOWN THE PERFORMANCE DUE SYS_CALL (el7 :))
	//struct uint64 baseTime = sys_get_virtual_time() ;
	struct uint64 baseTime = get_virtual_time_user() ;
	while(cycles_counter<time_in_cycles)
  801e3f:	eb 46                	jmp    801e87 <env_sleep+0x94>

static inline __attribute__((always_inline)) struct uint64 get_virtual_time_user()
{
	struct uint64 result;

	__asm __volatile("rdtsc\n"
  801e41:	0f 31                	rdtsc  
  801e43:	89 45 d0             	mov    %eax,-0x30(%ebp)
  801e46:	89 55 d4             	mov    %edx,-0x2c(%ebp)
	: "=a" (result.low), "=d" (result.hi)
	);

	return result;
  801e49:	8b 45 d0             	mov    -0x30(%ebp),%eax
  801e4c:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  801e4f:	89 45 e0             	mov    %eax,-0x20(%ebp)
  801e52:	89 55 e4             	mov    %edx,-0x1c(%ebp)

		// update the cycles_count
		#define M32 0xffffffff
		// subtract basetime from current time
		struct uint64 res;
		res.low = (currentTime.low - baseTime.low) & M32;
  801e55:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801e58:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e5b:	29 c2                	sub    %eax,%edx
  801e5d:	89 d0                	mov    %edx,%eax
  801e5f:	89 45 d8             	mov    %eax,-0x28(%ebp)
		res.hi = (currentTime.hi - baseTime.hi - (res.low > currentTime.low)) & M32;
  801e62:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801e65:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e68:	89 d1                	mov    %edx,%ecx
  801e6a:	29 c1                	sub    %eax,%ecx
  801e6c:	8b 55 d8             	mov    -0x28(%ebp),%edx
  801e6f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801e72:	39 c2                	cmp    %eax,%edx
  801e74:	0f 97 c0             	seta   %al
  801e77:	0f b6 c0             	movzbl %al,%eax
  801e7a:	29 c1                	sub    %eax,%ecx
  801e7c:	89 c8                	mov    %ecx,%eax
  801e7e:	89 45 dc             	mov    %eax,-0x24(%ebp)

		//update cycles_count with result
		cycles_counter = res.low;
  801e81:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801e84:	89 45 fc             	mov    %eax,-0x4(%ebp)
	uint32 cycles_counter =0;

	/*2024*/ //USE A USER-SIDE VERSION OF THIS FUNCTION TO AVOID SLOW-DOWN THE PERFORMANCE DUE SYS_CALL (el7 :))
	//struct uint64 baseTime = sys_get_virtual_time() ;
	struct uint64 baseTime = get_virtual_time_user() ;
	while(cycles_counter<time_in_cycles)
  801e87:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801e8a:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801e8d:	72 b2                	jb     801e41 <env_sleep+0x4e>
//				,cycles_counter
//				);
	}
	//cprintf("%s [%d] wake up now!\n", myEnv->prog_name, myEnv->env_id);

}
  801e8f:	90                   	nop
  801e90:	c9                   	leave  
  801e91:	c3                   	ret    

00801e92 <busy_wait>:

//2017
uint32 busy_wait(uint32 loopMax)
{
  801e92:	55                   	push   %ebp
  801e93:	89 e5                	mov    %esp,%ebp
  801e95:	83 ec 10             	sub    $0x10,%esp
	uint32 i = 0 ;
  801e98:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	while (i < loopMax) i++;
  801e9f:	eb 03                	jmp    801ea4 <busy_wait+0x12>
  801ea1:	ff 45 fc             	incl   -0x4(%ebp)
  801ea4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801ea7:	3b 45 08             	cmp    0x8(%ebp),%eax
  801eaa:	72 f5                	jb     801ea1 <busy_wait+0xf>
	return i;
  801eac:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801eaf:	c9                   	leave  
  801eb0:	c3                   	ret    

00801eb1 <cputchar>:
#include <inc/lib.h>


void
cputchar(int ch)
{
  801eb1:	55                   	push   %ebp
  801eb2:	89 e5                	mov    %esp,%ebp
  801eb4:	83 ec 18             	sub    $0x18,%esp
	char c = ch;
  801eb7:	8b 45 08             	mov    0x8(%ebp),%eax
  801eba:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	//sys_cputs(&c, 1);

	sys_cputc(c);
  801ebd:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  801ec1:	83 ec 0c             	sub    $0xc,%esp
  801ec4:	50                   	push   %eax
  801ec5:	e8 36 fb ff ff       	call   801a00 <sys_cputc>
  801eca:	83 c4 10             	add    $0x10,%esp
}
  801ecd:	90                   	nop
  801ece:	c9                   	leave  
  801ecf:	c3                   	ret    

00801ed0 <getchar>:


int
getchar(void)
{
  801ed0:	55                   	push   %ebp
  801ed1:	89 e5                	mov    %esp,%ebp
  801ed3:	83 ec 18             	sub    $0x18,%esp
	int c =sys_cgetc();
  801ed6:	e8 c4 f9 ff ff       	call   80189f <sys_cgetc>
  801edb:	89 45 f4             	mov    %eax,-0xc(%ebp)
	return c;
  801ede:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  801ee1:	c9                   	leave  
  801ee2:	c3                   	ret    

00801ee3 <iscons>:

int iscons(int fdnum)
{
  801ee3:	55                   	push   %ebp
  801ee4:	89 e5                	mov    %esp,%ebp
	// used by readline
	return 1;
  801ee6:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801eeb:	5d                   	pop    %ebp
  801eec:	c3                   	ret    
  801eed:	66 90                	xchg   %ax,%ax
  801eef:	90                   	nop

00801ef0 <__udivdi3>:
  801ef0:	55                   	push   %ebp
  801ef1:	57                   	push   %edi
  801ef2:	56                   	push   %esi
  801ef3:	53                   	push   %ebx
  801ef4:	83 ec 1c             	sub    $0x1c,%esp
  801ef7:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  801efb:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  801eff:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801f03:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801f07:	89 ca                	mov    %ecx,%edx
  801f09:	89 f8                	mov    %edi,%eax
  801f0b:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  801f0f:	85 f6                	test   %esi,%esi
  801f11:	75 2d                	jne    801f40 <__udivdi3+0x50>
  801f13:	39 cf                	cmp    %ecx,%edi
  801f15:	77 65                	ja     801f7c <__udivdi3+0x8c>
  801f17:	89 fd                	mov    %edi,%ebp
  801f19:	85 ff                	test   %edi,%edi
  801f1b:	75 0b                	jne    801f28 <__udivdi3+0x38>
  801f1d:	b8 01 00 00 00       	mov    $0x1,%eax
  801f22:	31 d2                	xor    %edx,%edx
  801f24:	f7 f7                	div    %edi
  801f26:	89 c5                	mov    %eax,%ebp
  801f28:	31 d2                	xor    %edx,%edx
  801f2a:	89 c8                	mov    %ecx,%eax
  801f2c:	f7 f5                	div    %ebp
  801f2e:	89 c1                	mov    %eax,%ecx
  801f30:	89 d8                	mov    %ebx,%eax
  801f32:	f7 f5                	div    %ebp
  801f34:	89 cf                	mov    %ecx,%edi
  801f36:	89 fa                	mov    %edi,%edx
  801f38:	83 c4 1c             	add    $0x1c,%esp
  801f3b:	5b                   	pop    %ebx
  801f3c:	5e                   	pop    %esi
  801f3d:	5f                   	pop    %edi
  801f3e:	5d                   	pop    %ebp
  801f3f:	c3                   	ret    
  801f40:	39 ce                	cmp    %ecx,%esi
  801f42:	77 28                	ja     801f6c <__udivdi3+0x7c>
  801f44:	0f bd fe             	bsr    %esi,%edi
  801f47:	83 f7 1f             	xor    $0x1f,%edi
  801f4a:	75 40                	jne    801f8c <__udivdi3+0x9c>
  801f4c:	39 ce                	cmp    %ecx,%esi
  801f4e:	72 0a                	jb     801f5a <__udivdi3+0x6a>
  801f50:	3b 44 24 08          	cmp    0x8(%esp),%eax
  801f54:	0f 87 9e 00 00 00    	ja     801ff8 <__udivdi3+0x108>
  801f5a:	b8 01 00 00 00       	mov    $0x1,%eax
  801f5f:	89 fa                	mov    %edi,%edx
  801f61:	83 c4 1c             	add    $0x1c,%esp
  801f64:	5b                   	pop    %ebx
  801f65:	5e                   	pop    %esi
  801f66:	5f                   	pop    %edi
  801f67:	5d                   	pop    %ebp
  801f68:	c3                   	ret    
  801f69:	8d 76 00             	lea    0x0(%esi),%esi
  801f6c:	31 ff                	xor    %edi,%edi
  801f6e:	31 c0                	xor    %eax,%eax
  801f70:	89 fa                	mov    %edi,%edx
  801f72:	83 c4 1c             	add    $0x1c,%esp
  801f75:	5b                   	pop    %ebx
  801f76:	5e                   	pop    %esi
  801f77:	5f                   	pop    %edi
  801f78:	5d                   	pop    %ebp
  801f79:	c3                   	ret    
  801f7a:	66 90                	xchg   %ax,%ax
  801f7c:	89 d8                	mov    %ebx,%eax
  801f7e:	f7 f7                	div    %edi
  801f80:	31 ff                	xor    %edi,%edi
  801f82:	89 fa                	mov    %edi,%edx
  801f84:	83 c4 1c             	add    $0x1c,%esp
  801f87:	5b                   	pop    %ebx
  801f88:	5e                   	pop    %esi
  801f89:	5f                   	pop    %edi
  801f8a:	5d                   	pop    %ebp
  801f8b:	c3                   	ret    
  801f8c:	bd 20 00 00 00       	mov    $0x20,%ebp
  801f91:	89 eb                	mov    %ebp,%ebx
  801f93:	29 fb                	sub    %edi,%ebx
  801f95:	89 f9                	mov    %edi,%ecx
  801f97:	d3 e6                	shl    %cl,%esi
  801f99:	89 c5                	mov    %eax,%ebp
  801f9b:	88 d9                	mov    %bl,%cl
  801f9d:	d3 ed                	shr    %cl,%ebp
  801f9f:	89 e9                	mov    %ebp,%ecx
  801fa1:	09 f1                	or     %esi,%ecx
  801fa3:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  801fa7:	89 f9                	mov    %edi,%ecx
  801fa9:	d3 e0                	shl    %cl,%eax
  801fab:	89 c5                	mov    %eax,%ebp
  801fad:	89 d6                	mov    %edx,%esi
  801faf:	88 d9                	mov    %bl,%cl
  801fb1:	d3 ee                	shr    %cl,%esi
  801fb3:	89 f9                	mov    %edi,%ecx
  801fb5:	d3 e2                	shl    %cl,%edx
  801fb7:	8b 44 24 08          	mov    0x8(%esp),%eax
  801fbb:	88 d9                	mov    %bl,%cl
  801fbd:	d3 e8                	shr    %cl,%eax
  801fbf:	09 c2                	or     %eax,%edx
  801fc1:	89 d0                	mov    %edx,%eax
  801fc3:	89 f2                	mov    %esi,%edx
  801fc5:	f7 74 24 0c          	divl   0xc(%esp)
  801fc9:	89 d6                	mov    %edx,%esi
  801fcb:	89 c3                	mov    %eax,%ebx
  801fcd:	f7 e5                	mul    %ebp
  801fcf:	39 d6                	cmp    %edx,%esi
  801fd1:	72 19                	jb     801fec <__udivdi3+0xfc>
  801fd3:	74 0b                	je     801fe0 <__udivdi3+0xf0>
  801fd5:	89 d8                	mov    %ebx,%eax
  801fd7:	31 ff                	xor    %edi,%edi
  801fd9:	e9 58 ff ff ff       	jmp    801f36 <__udivdi3+0x46>
  801fde:	66 90                	xchg   %ax,%ax
  801fe0:	8b 54 24 08          	mov    0x8(%esp),%edx
  801fe4:	89 f9                	mov    %edi,%ecx
  801fe6:	d3 e2                	shl    %cl,%edx
  801fe8:	39 c2                	cmp    %eax,%edx
  801fea:	73 e9                	jae    801fd5 <__udivdi3+0xe5>
  801fec:	8d 43 ff             	lea    -0x1(%ebx),%eax
  801fef:	31 ff                	xor    %edi,%edi
  801ff1:	e9 40 ff ff ff       	jmp    801f36 <__udivdi3+0x46>
  801ff6:	66 90                	xchg   %ax,%ax
  801ff8:	31 c0                	xor    %eax,%eax
  801ffa:	e9 37 ff ff ff       	jmp    801f36 <__udivdi3+0x46>
  801fff:	90                   	nop

00802000 <__umoddi3>:
  802000:	55                   	push   %ebp
  802001:	57                   	push   %edi
  802002:	56                   	push   %esi
  802003:	53                   	push   %ebx
  802004:	83 ec 1c             	sub    $0x1c,%esp
  802007:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  80200b:	8b 74 24 34          	mov    0x34(%esp),%esi
  80200f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  802013:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  802017:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80201b:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80201f:	89 f3                	mov    %esi,%ebx
  802021:	89 fa                	mov    %edi,%edx
  802023:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  802027:	89 34 24             	mov    %esi,(%esp)
  80202a:	85 c0                	test   %eax,%eax
  80202c:	75 1a                	jne    802048 <__umoddi3+0x48>
  80202e:	39 f7                	cmp    %esi,%edi
  802030:	0f 86 a2 00 00 00    	jbe    8020d8 <__umoddi3+0xd8>
  802036:	89 c8                	mov    %ecx,%eax
  802038:	89 f2                	mov    %esi,%edx
  80203a:	f7 f7                	div    %edi
  80203c:	89 d0                	mov    %edx,%eax
  80203e:	31 d2                	xor    %edx,%edx
  802040:	83 c4 1c             	add    $0x1c,%esp
  802043:	5b                   	pop    %ebx
  802044:	5e                   	pop    %esi
  802045:	5f                   	pop    %edi
  802046:	5d                   	pop    %ebp
  802047:	c3                   	ret    
  802048:	39 f0                	cmp    %esi,%eax
  80204a:	0f 87 ac 00 00 00    	ja     8020fc <__umoddi3+0xfc>
  802050:	0f bd e8             	bsr    %eax,%ebp
  802053:	83 f5 1f             	xor    $0x1f,%ebp
  802056:	0f 84 ac 00 00 00    	je     802108 <__umoddi3+0x108>
  80205c:	bf 20 00 00 00       	mov    $0x20,%edi
  802061:	29 ef                	sub    %ebp,%edi
  802063:	89 fe                	mov    %edi,%esi
  802065:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802069:	89 e9                	mov    %ebp,%ecx
  80206b:	d3 e0                	shl    %cl,%eax
  80206d:	89 d7                	mov    %edx,%edi
  80206f:	89 f1                	mov    %esi,%ecx
  802071:	d3 ef                	shr    %cl,%edi
  802073:	09 c7                	or     %eax,%edi
  802075:	89 e9                	mov    %ebp,%ecx
  802077:	d3 e2                	shl    %cl,%edx
  802079:	89 14 24             	mov    %edx,(%esp)
  80207c:	89 d8                	mov    %ebx,%eax
  80207e:	d3 e0                	shl    %cl,%eax
  802080:	89 c2                	mov    %eax,%edx
  802082:	8b 44 24 08          	mov    0x8(%esp),%eax
  802086:	d3 e0                	shl    %cl,%eax
  802088:	89 44 24 04          	mov    %eax,0x4(%esp)
  80208c:	8b 44 24 08          	mov    0x8(%esp),%eax
  802090:	89 f1                	mov    %esi,%ecx
  802092:	d3 e8                	shr    %cl,%eax
  802094:	09 d0                	or     %edx,%eax
  802096:	d3 eb                	shr    %cl,%ebx
  802098:	89 da                	mov    %ebx,%edx
  80209a:	f7 f7                	div    %edi
  80209c:	89 d3                	mov    %edx,%ebx
  80209e:	f7 24 24             	mull   (%esp)
  8020a1:	89 c6                	mov    %eax,%esi
  8020a3:	89 d1                	mov    %edx,%ecx
  8020a5:	39 d3                	cmp    %edx,%ebx
  8020a7:	0f 82 87 00 00 00    	jb     802134 <__umoddi3+0x134>
  8020ad:	0f 84 91 00 00 00    	je     802144 <__umoddi3+0x144>
  8020b3:	8b 54 24 04          	mov    0x4(%esp),%edx
  8020b7:	29 f2                	sub    %esi,%edx
  8020b9:	19 cb                	sbb    %ecx,%ebx
  8020bb:	89 d8                	mov    %ebx,%eax
  8020bd:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  8020c1:	d3 e0                	shl    %cl,%eax
  8020c3:	89 e9                	mov    %ebp,%ecx
  8020c5:	d3 ea                	shr    %cl,%edx
  8020c7:	09 d0                	or     %edx,%eax
  8020c9:	89 e9                	mov    %ebp,%ecx
  8020cb:	d3 eb                	shr    %cl,%ebx
  8020cd:	89 da                	mov    %ebx,%edx
  8020cf:	83 c4 1c             	add    $0x1c,%esp
  8020d2:	5b                   	pop    %ebx
  8020d3:	5e                   	pop    %esi
  8020d4:	5f                   	pop    %edi
  8020d5:	5d                   	pop    %ebp
  8020d6:	c3                   	ret    
  8020d7:	90                   	nop
  8020d8:	89 fd                	mov    %edi,%ebp
  8020da:	85 ff                	test   %edi,%edi
  8020dc:	75 0b                	jne    8020e9 <__umoddi3+0xe9>
  8020de:	b8 01 00 00 00       	mov    $0x1,%eax
  8020e3:	31 d2                	xor    %edx,%edx
  8020e5:	f7 f7                	div    %edi
  8020e7:	89 c5                	mov    %eax,%ebp
  8020e9:	89 f0                	mov    %esi,%eax
  8020eb:	31 d2                	xor    %edx,%edx
  8020ed:	f7 f5                	div    %ebp
  8020ef:	89 c8                	mov    %ecx,%eax
  8020f1:	f7 f5                	div    %ebp
  8020f3:	89 d0                	mov    %edx,%eax
  8020f5:	e9 44 ff ff ff       	jmp    80203e <__umoddi3+0x3e>
  8020fa:	66 90                	xchg   %ax,%ax
  8020fc:	89 c8                	mov    %ecx,%eax
  8020fe:	89 f2                	mov    %esi,%edx
  802100:	83 c4 1c             	add    $0x1c,%esp
  802103:	5b                   	pop    %ebx
  802104:	5e                   	pop    %esi
  802105:	5f                   	pop    %edi
  802106:	5d                   	pop    %ebp
  802107:	c3                   	ret    
  802108:	3b 04 24             	cmp    (%esp),%eax
  80210b:	72 06                	jb     802113 <__umoddi3+0x113>
  80210d:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  802111:	77 0f                	ja     802122 <__umoddi3+0x122>
  802113:	89 f2                	mov    %esi,%edx
  802115:	29 f9                	sub    %edi,%ecx
  802117:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  80211b:	89 14 24             	mov    %edx,(%esp)
  80211e:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  802122:	8b 44 24 04          	mov    0x4(%esp),%eax
  802126:	8b 14 24             	mov    (%esp),%edx
  802129:	83 c4 1c             	add    $0x1c,%esp
  80212c:	5b                   	pop    %ebx
  80212d:	5e                   	pop    %esi
  80212e:	5f                   	pop    %edi
  80212f:	5d                   	pop    %ebp
  802130:	c3                   	ret    
  802131:	8d 76 00             	lea    0x0(%esi),%esi
  802134:	2b 04 24             	sub    (%esp),%eax
  802137:	19 fa                	sbb    %edi,%edx
  802139:	89 d1                	mov    %edx,%ecx
  80213b:	89 c6                	mov    %eax,%esi
  80213d:	e9 71 ff ff ff       	jmp    8020b3 <__umoddi3+0xb3>
  802142:	66 90                	xchg   %ax,%ax
  802144:	39 44 24 04          	cmp    %eax,0x4(%esp)
  802148:	72 ea                	jb     802134 <__umoddi3+0x134>
  80214a:	89 d9                	mov    %ebx,%ecx
  80214c:	e9 62 ff ff ff       	jmp    8020b3 <__umoddi3+0xb3>
