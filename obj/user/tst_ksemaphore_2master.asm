
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
  800044:	e8 e4 1a 00 00       	call   801b2d <sys_getenvid>
  800049:	89 45 e0             	mov    %eax,-0x20(%ebp)
	char line[256] ;
	readline("Enter total number of customers: ", line) ;
  80004c:	83 ec 08             	sub    $0x8,%esp
  80004f:	8d 85 d4 fe ff ff    	lea    -0x12c(%ebp),%eax
  800055:	50                   	push   %eax
  800056:	68 80 21 80 00       	push   $0x802180
  80005b:	e8 ea 0d 00 00       	call   800e4a <readline>
  800060:	83 c4 10             	add    $0x10,%esp
	int totalNumOfCusts = strtol(line, NULL, 10);
  800063:	83 ec 04             	sub    $0x4,%esp
  800066:	6a 0a                	push   $0xa
  800068:	6a 00                	push   $0x0
  80006a:	8d 85 d4 fe ff ff    	lea    -0x12c(%ebp),%eax
  800070:	50                   	push   %eax
  800071:	e8 eb 13 00 00       	call   801461 <strtol>
  800076:	83 c4 10             	add    $0x10,%esp
  800079:	89 45 dc             	mov    %eax,-0x24(%ebp)
	readline("Enter shop capacity: ", line) ;
  80007c:	83 ec 08             	sub    $0x8,%esp
  80007f:	8d 85 d4 fe ff ff    	lea    -0x12c(%ebp),%eax
  800085:	50                   	push   %eax
  800086:	68 a2 21 80 00       	push   $0x8021a2
  80008b:	e8 ba 0d 00 00       	call   800e4a <readline>
  800090:	83 c4 10             	add    $0x10,%esp
	int shopCapacity = strtol(line, NULL, 10);
  800093:	83 ec 04             	sub    $0x4,%esp
  800096:	6a 0a                	push   $0xa
  800098:	6a 00                	push   $0x0
  80009a:	8d 85 d4 fe ff ff    	lea    -0x12c(%ebp),%eax
  8000a0:	50                   	push   %eax
  8000a1:	e8 bb 13 00 00       	call   801461 <strtol>
  8000a6:	83 c4 10             	add    $0x10,%esp
  8000a9:	89 45 d8             	mov    %eax,-0x28(%ebp)

	int semVal ;
	//Initialize the kernel semaphores
	char initCmd1[64] = "__KSem@0@Init";
  8000ac:	8d 85 90 fe ff ff    	lea    -0x170(%ebp),%eax
  8000b2:	bb c5 22 80 00       	mov    $0x8022c5,%ebx
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
  8000db:	bb 05 23 80 00       	mov    $0x802305,%ebx
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
  800118:	e8 5f 1c 00 00       	call   801d7c <sys_utilities>
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
  80013b:	e8 3c 1c 00 00       	call   801d7c <sys_utilities>
  800140:	83 c4 10             	add    $0x10,%esp

	int i = 0 ;
  800143:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	int id ;
	for (; i<totalNumOfCusts; i++)
  80014a:	eb 61                	jmp    8001ad <_main+0x175>
	{
		id = sys_create_env("ksem2Slave", (myEnv->page_WS_max_size), (myEnv->SecondListSize),(myEnv->percentage_of_WS_pages_to_be_removed));
  80014c:	a1 20 30 80 00       	mov    0x803020,%eax
  800151:	8b 90 3c da 01 00    	mov    0x1da3c(%eax),%edx
  800157:	a1 20 30 80 00       	mov    0x803020,%eax
  80015c:	8b 80 34 da 01 00    	mov    0x1da34(%eax),%eax
  800162:	89 c1                	mov    %eax,%ecx
  800164:	a1 20 30 80 00       	mov    0x803020,%eax
  800169:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
  80016f:	52                   	push   %edx
  800170:	51                   	push   %ecx
  800171:	50                   	push   %eax
  800172:	68 b8 21 80 00       	push   $0x8021b8
  800177:	e8 5c 19 00 00       	call   801ad8 <sys_create_env>
  80017c:	83 c4 10             	add    $0x10,%esp
  80017f:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		if (id == E_ENV_CREATION_ERROR)
  800182:	83 7d d4 ef          	cmpl   $0xffffffef,-0x2c(%ebp)
  800186:	75 14                	jne    80019c <_main+0x164>
			panic("NO AVAILABLE ENVs... Please reduce the number of customers and try again...");
  800188:	83 ec 04             	sub    $0x4,%esp
  80018b:	68 c4 21 80 00       	push   $0x8021c4
  800190:	6a 1e                	push   $0x1e
  800192:	68 10 22 80 00       	push   $0x802210
  800197:	e8 07 03 00 00       	call   8004a3 <_panic>
		sys_run_env(id) ;
  80019c:	83 ec 0c             	sub    $0xc,%esp
  80019f:	ff 75 d4             	pushl  -0x2c(%ebp)
  8001a2:	e8 4f 19 00 00       	call   801af6 <sys_run_env>
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
  8001c4:	bb 45 23 80 00       	mov    $0x802345,%ebx
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
  8001f3:	e8 84 1b 00 00       	call   801d7c <sys_utilities>
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
  80020c:	bb 85 23 80 00       	mov    $0x802385,%ebx
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
  800235:	bb c5 23 80 00       	mov    $0x8023c5,%ebx
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
  800269:	e8 0e 1b 00 00       	call   801d7c <sys_utilities>
  80026e:	83 c4 10             	add    $0x10,%esp
	sys_utilities(getCmd2, (uint32)(&sem2val));
  800271:	8d 85 48 fe ff ff    	lea    -0x1b8(%ebp),%eax
  800277:	83 ec 08             	sub    $0x8,%esp
  80027a:	50                   	push   %eax
  80027b:	8d 85 c8 fd ff ff    	lea    -0x238(%ebp),%eax
  800281:	50                   	push   %eax
  800282:	e8 f5 1a 00 00       	call   801d7c <sys_utilities>
  800287:	83 c4 10             	add    $0x10,%esp

	//wait a while to allow the slaves to finish printing their closing messages
	env_sleep(10000);
  80028a:	83 ec 0c             	sub    $0xc,%esp
  80028d:	68 10 27 00 00       	push   $0x2710
  800292:	e8 71 1b 00 00       	call   801e08 <env_sleep>
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
  8002b2:	68 30 22 80 00       	push   $0x802230
  8002b7:	6a 0a                	push   $0xa
  8002b9:	e8 e0 04 00 00       	call   80079e <cprintf_colored>
  8002be:	83 c4 10             	add    $0x10,%esp
  8002c1:	eb 12                	jmp    8002d5 <_main+0x29d>
	else
		cprintf_colored(TEXT_TESTERR_CLR,"\nError: wrong semaphore value... please review your semaphore code again...\n");
  8002c3:	83 ec 08             	sub    $0x8,%esp
  8002c6:	68 78 22 80 00       	push   $0x802278
  8002cb:	6a 0c                	push   $0xc
  8002cd:	e8 cc 04 00 00       	call   80079e <cprintf_colored>
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
  8002e7:	e8 5a 18 00 00       	call   801b46 <sys_getenvindex>
  8002ec:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	myEnv = &(envs[envIndex]);
  8002ef:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8002f2:	89 d0                	mov    %edx,%eax
  8002f4:	c1 e0 06             	shl    $0x6,%eax
  8002f7:	29 d0                	sub    %edx,%eax
  8002f9:	c1 e0 02             	shl    $0x2,%eax
  8002fc:	01 d0                	add    %edx,%eax
  8002fe:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800305:	01 c8                	add    %ecx,%eax
  800307:	c1 e0 03             	shl    $0x3,%eax
  80030a:	01 d0                	add    %edx,%eax
  80030c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800313:	29 c2                	sub    %eax,%edx
  800315:	8d 04 95 00 00 00 00 	lea    0x0(,%edx,4),%eax
  80031c:	89 c2                	mov    %eax,%edx
  80031e:	8d 82 00 00 c0 ee    	lea    -0x11400000(%edx),%eax
  800324:	a3 20 30 80 00       	mov    %eax,0x803020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800329:	a1 20 30 80 00       	mov    0x803020,%eax
  80032e:	8a 40 20             	mov    0x20(%eax),%al
  800331:	84 c0                	test   %al,%al
  800333:	74 0d                	je     800342 <libmain+0x64>
		binaryname = myEnv->prog_name;
  800335:	a1 20 30 80 00       	mov    0x803020,%eax
  80033a:	83 c0 20             	add    $0x20,%eax
  80033d:	a3 04 30 80 00       	mov    %eax,0x803004

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800342:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800346:	7e 0a                	jle    800352 <libmain+0x74>
		binaryname = argv[0];
  800348:	8b 45 0c             	mov    0xc(%ebp),%eax
  80034b:	8b 00                	mov    (%eax),%eax
  80034d:	a3 04 30 80 00       	mov    %eax,0x803004

	// call user main routine
	_main(argc, argv);
  800352:	83 ec 08             	sub    $0x8,%esp
  800355:	ff 75 0c             	pushl  0xc(%ebp)
  800358:	ff 75 08             	pushl  0x8(%ebp)
  80035b:	e8 d8 fc ff ff       	call   800038 <_main>
  800360:	83 c4 10             	add    $0x10,%esp

	if (printStats)
  800363:	a1 00 30 80 00       	mov    0x803000,%eax
  800368:	85 c0                	test   %eax,%eax
  80036a:	0f 84 01 01 00 00    	je     800471 <libmain+0x193>
	{
		char isOPTReplCmd[100] = "__IsOPTRepl__" ;
  800370:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  800376:	bb 00 25 80 00       	mov    $0x802500,%ebx
  80037b:	ba 0e 00 00 00       	mov    $0xe,%edx
  800380:	89 c7                	mov    %eax,%edi
  800382:	89 de                	mov    %ebx,%esi
  800384:	89 d1                	mov    %edx,%ecx
  800386:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  800388:	8d 55 8a             	lea    -0x76(%ebp),%edx
  80038b:	b9 56 00 00 00       	mov    $0x56,%ecx
  800390:	b0 00                	mov    $0x0,%al
  800392:	89 d7                	mov    %edx,%edi
  800394:	f3 aa                	rep stos %al,%es:(%edi)
		int isOPTRepl = 0;
  800396:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
		sys_utilities(isOPTReplCmd, (uint32)(&isOPTRepl));
  80039d:	8d 45 e0             	lea    -0x20(%ebp),%eax
  8003a0:	83 ec 08             	sub    $0x8,%esp
  8003a3:	50                   	push   %eax
  8003a4:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  8003aa:	50                   	push   %eax
  8003ab:	e8 cc 19 00 00       	call   801d7c <sys_utilities>
  8003b0:	83 c4 10             	add    $0x10,%esp

		sys_lock_cons();
  8003b3:	e8 15 15 00 00       	call   8018cd <sys_lock_cons>
		{
			cprintf("**************************************\n");
  8003b8:	83 ec 0c             	sub    $0xc,%esp
  8003bb:	68 20 24 80 00       	push   $0x802420
  8003c0:	e8 ac 03 00 00       	call   800771 <cprintf>
  8003c5:	83 c4 10             	add    $0x10,%esp
			if (isOPTRepl)
  8003c8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8003cb:	85 c0                	test   %eax,%eax
  8003cd:	74 18                	je     8003e7 <libmain+0x109>
			{
				cprintf("OPTIMAL number of page faults = %d\n", sys_get_optimal_num_faults());
  8003cf:	e8 c6 19 00 00       	call   801d9a <sys_get_optimal_num_faults>
  8003d4:	83 ec 08             	sub    $0x8,%esp
  8003d7:	50                   	push   %eax
  8003d8:	68 48 24 80 00       	push   $0x802448
  8003dd:	e8 8f 03 00 00       	call   800771 <cprintf>
  8003e2:	83 c4 10             	add    $0x10,%esp
  8003e5:	eb 59                	jmp    800440 <libmain+0x162>
			}
			else
			{
				cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8003e7:	a1 20 30 80 00       	mov    0x803020,%eax
  8003ec:	8b 90 50 da 01 00    	mov    0x1da50(%eax),%edx
  8003f2:	a1 20 30 80 00       	mov    0x803020,%eax
  8003f7:	8b 80 40 da 01 00    	mov    0x1da40(%eax),%eax
  8003fd:	83 ec 04             	sub    $0x4,%esp
  800400:	52                   	push   %edx
  800401:	50                   	push   %eax
  800402:	68 6c 24 80 00       	push   $0x80246c
  800407:	e8 65 03 00 00       	call   800771 <cprintf>
  80040c:	83 c4 10             	add    $0x10,%esp
				cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  80040f:	a1 20 30 80 00       	mov    0x803020,%eax
  800414:	8b 88 64 da 01 00    	mov    0x1da64(%eax),%ecx
  80041a:	a1 20 30 80 00       	mov    0x803020,%eax
  80041f:	8b 90 60 da 01 00    	mov    0x1da60(%eax),%edx
  800425:	a1 20 30 80 00       	mov    0x803020,%eax
  80042a:	8b 80 5c da 01 00    	mov    0x1da5c(%eax),%eax
  800430:	51                   	push   %ecx
  800431:	52                   	push   %edx
  800432:	50                   	push   %eax
  800433:	68 94 24 80 00       	push   $0x802494
  800438:	e8 34 03 00 00       	call   800771 <cprintf>
  80043d:	83 c4 10             	add    $0x10,%esp
			}
			//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
			cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800440:	a1 20 30 80 00       	mov    0x803020,%eax
  800445:	8b 80 68 da 01 00    	mov    0x1da68(%eax),%eax
  80044b:	83 ec 08             	sub    $0x8,%esp
  80044e:	50                   	push   %eax
  80044f:	68 ec 24 80 00       	push   $0x8024ec
  800454:	e8 18 03 00 00       	call   800771 <cprintf>
  800459:	83 c4 10             	add    $0x10,%esp
			cprintf("**************************************\n");
  80045c:	83 ec 0c             	sub    $0xc,%esp
  80045f:	68 20 24 80 00       	push   $0x802420
  800464:	e8 08 03 00 00       	call   800771 <cprintf>
  800469:	83 c4 10             	add    $0x10,%esp
		}
		sys_unlock_cons();
  80046c:	e8 76 14 00 00       	call   8018e7 <sys_unlock_cons>
	}

	// exit gracefully
	exit();
  800471:	e8 1f 00 00 00       	call   800495 <exit>
}
  800476:	90                   	nop
  800477:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80047a:	5b                   	pop    %ebx
  80047b:	5e                   	pop    %esi
  80047c:	5f                   	pop    %edi
  80047d:	5d                   	pop    %ebp
  80047e:	c3                   	ret    

0080047f <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  80047f:	55                   	push   %ebp
  800480:	89 e5                	mov    %esp,%ebp
  800482:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800485:	83 ec 0c             	sub    $0xc,%esp
  800488:	6a 00                	push   $0x0
  80048a:	e8 83 16 00 00       	call   801b12 <sys_destroy_env>
  80048f:	83 c4 10             	add    $0x10,%esp
}
  800492:	90                   	nop
  800493:	c9                   	leave  
  800494:	c3                   	ret    

00800495 <exit>:

void
exit(void)
{
  800495:	55                   	push   %ebp
  800496:	89 e5                	mov    %esp,%ebp
  800498:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  80049b:	e8 d8 16 00 00       	call   801b78 <sys_exit_env>
}
  8004a0:	90                   	nop
  8004a1:	c9                   	leave  
  8004a2:	c3                   	ret    

008004a3 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  8004a3:	55                   	push   %ebp
  8004a4:	89 e5                	mov    %esp,%ebp
  8004a6:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  8004a9:	8d 45 10             	lea    0x10(%ebp),%eax
  8004ac:	83 c0 04             	add    $0x4,%eax
  8004af:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  8004b2:	a1 18 b1 81 00       	mov    0x81b118,%eax
  8004b7:	85 c0                	test   %eax,%eax
  8004b9:	74 16                	je     8004d1 <_panic+0x2e>
		cprintf("%s: ", argv0);
  8004bb:	a1 18 b1 81 00       	mov    0x81b118,%eax
  8004c0:	83 ec 08             	sub    $0x8,%esp
  8004c3:	50                   	push   %eax
  8004c4:	68 64 25 80 00       	push   $0x802564
  8004c9:	e8 a3 02 00 00       	call   800771 <cprintf>
  8004ce:	83 c4 10             	add    $0x10,%esp
	cprintf_colored(TEXT_PANIC_CLR, "user [EVAL_FINAL]panic in %s at %s:%d: ", binaryname, file, line);
  8004d1:	a1 04 30 80 00       	mov    0x803004,%eax
  8004d6:	83 ec 0c             	sub    $0xc,%esp
  8004d9:	ff 75 0c             	pushl  0xc(%ebp)
  8004dc:	ff 75 08             	pushl  0x8(%ebp)
  8004df:	50                   	push   %eax
  8004e0:	68 6c 25 80 00       	push   $0x80256c
  8004e5:	6a 74                	push   $0x74
  8004e7:	e8 b2 02 00 00       	call   80079e <cprintf_colored>
  8004ec:	83 c4 20             	add    $0x20,%esp
	vcprintf(fmt, ap);
  8004ef:	8b 45 10             	mov    0x10(%ebp),%eax
  8004f2:	83 ec 08             	sub    $0x8,%esp
  8004f5:	ff 75 f4             	pushl  -0xc(%ebp)
  8004f8:	50                   	push   %eax
  8004f9:	e8 04 02 00 00       	call   800702 <vcprintf>
  8004fe:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  800501:	83 ec 08             	sub    $0x8,%esp
  800504:	6a 00                	push   $0x0
  800506:	68 94 25 80 00       	push   $0x802594
  80050b:	e8 f2 01 00 00       	call   800702 <vcprintf>
  800510:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  800513:	e8 7d ff ff ff       	call   800495 <exit>

	// should not return here
	while (1) ;
  800518:	eb fe                	jmp    800518 <_panic+0x75>

0080051a <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  80051a:	55                   	push   %ebp
  80051b:	89 e5                	mov    %esp,%ebp
  80051d:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  800520:	a1 20 30 80 00       	mov    0x803020,%eax
  800525:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  80052b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80052e:	39 c2                	cmp    %eax,%edx
  800530:	74 14                	je     800546 <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  800532:	83 ec 04             	sub    $0x4,%esp
  800535:	68 98 25 80 00       	push   $0x802598
  80053a:	6a 26                	push   $0x26
  80053c:	68 e4 25 80 00       	push   $0x8025e4
  800541:	e8 5d ff ff ff       	call   8004a3 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  800546:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  80054d:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800554:	e9 c5 00 00 00       	jmp    80061e <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  800559:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80055c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800563:	8b 45 08             	mov    0x8(%ebp),%eax
  800566:	01 d0                	add    %edx,%eax
  800568:	8b 00                	mov    (%eax),%eax
  80056a:	85 c0                	test   %eax,%eax
  80056c:	75 08                	jne    800576 <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  80056e:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  800571:	e9 a5 00 00 00       	jmp    80061b <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  800576:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80057d:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  800584:	eb 69                	jmp    8005ef <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  800586:	a1 20 30 80 00       	mov    0x803020,%eax
  80058b:	8b 88 38 da 01 00    	mov    0x1da38(%eax),%ecx
  800591:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800594:	89 d0                	mov    %edx,%eax
  800596:	01 c0                	add    %eax,%eax
  800598:	01 d0                	add    %edx,%eax
  80059a:	c1 e0 03             	shl    $0x3,%eax
  80059d:	01 c8                	add    %ecx,%eax
  80059f:	8a 40 04             	mov    0x4(%eax),%al
  8005a2:	84 c0                	test   %al,%al
  8005a4:	75 46                	jne    8005ec <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8005a6:	a1 20 30 80 00       	mov    0x803020,%eax
  8005ab:	8b 88 38 da 01 00    	mov    0x1da38(%eax),%ecx
  8005b1:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8005b4:	89 d0                	mov    %edx,%eax
  8005b6:	01 c0                	add    %eax,%eax
  8005b8:	01 d0                	add    %edx,%eax
  8005ba:	c1 e0 03             	shl    $0x3,%eax
  8005bd:	01 c8                	add    %ecx,%eax
  8005bf:	8b 00                	mov    (%eax),%eax
  8005c1:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8005c4:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8005c7:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8005cc:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  8005ce:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8005d1:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8005d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8005db:	01 c8                	add    %ecx,%eax
  8005dd:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8005df:	39 c2                	cmp    %eax,%edx
  8005e1:	75 09                	jne    8005ec <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  8005e3:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  8005ea:	eb 15                	jmp    800601 <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8005ec:	ff 45 e8             	incl   -0x18(%ebp)
  8005ef:	a1 20 30 80 00       	mov    0x803020,%eax
  8005f4:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  8005fa:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8005fd:	39 c2                	cmp    %eax,%edx
  8005ff:	77 85                	ja     800586 <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  800601:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800605:	75 14                	jne    80061b <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  800607:	83 ec 04             	sub    $0x4,%esp
  80060a:	68 f0 25 80 00       	push   $0x8025f0
  80060f:	6a 3a                	push   $0x3a
  800611:	68 e4 25 80 00       	push   $0x8025e4
  800616:	e8 88 fe ff ff       	call   8004a3 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  80061b:	ff 45 f0             	incl   -0x10(%ebp)
  80061e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800621:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800624:	0f 8c 2f ff ff ff    	jl     800559 <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  80062a:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800631:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800638:	eb 26                	jmp    800660 <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  80063a:	a1 20 30 80 00       	mov    0x803020,%eax
  80063f:	8b 88 38 da 01 00    	mov    0x1da38(%eax),%ecx
  800645:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800648:	89 d0                	mov    %edx,%eax
  80064a:	01 c0                	add    %eax,%eax
  80064c:	01 d0                	add    %edx,%eax
  80064e:	c1 e0 03             	shl    $0x3,%eax
  800651:	01 c8                	add    %ecx,%eax
  800653:	8a 40 04             	mov    0x4(%eax),%al
  800656:	3c 01                	cmp    $0x1,%al
  800658:	75 03                	jne    80065d <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  80065a:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80065d:	ff 45 e0             	incl   -0x20(%ebp)
  800660:	a1 20 30 80 00       	mov    0x803020,%eax
  800665:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  80066b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80066e:	39 c2                	cmp    %eax,%edx
  800670:	77 c8                	ja     80063a <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  800672:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800675:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800678:	74 14                	je     80068e <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  80067a:	83 ec 04             	sub    $0x4,%esp
  80067d:	68 44 26 80 00       	push   $0x802644
  800682:	6a 44                	push   $0x44
  800684:	68 e4 25 80 00       	push   $0x8025e4
  800689:	e8 15 fe ff ff       	call   8004a3 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  80068e:	90                   	nop
  80068f:	c9                   	leave  
  800690:	c3                   	ret    

00800691 <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  800691:	55                   	push   %ebp
  800692:	89 e5                	mov    %esp,%ebp
  800694:	53                   	push   %ebx
  800695:	83 ec 04             	sub    $0x4,%esp
	b->buf[b->idx++] = ch;
  800698:	8b 45 0c             	mov    0xc(%ebp),%eax
  80069b:	8b 00                	mov    (%eax),%eax
  80069d:	8d 48 01             	lea    0x1(%eax),%ecx
  8006a0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8006a3:	89 0a                	mov    %ecx,(%edx)
  8006a5:	8b 55 08             	mov    0x8(%ebp),%edx
  8006a8:	88 d1                	mov    %dl,%cl
  8006aa:	8b 55 0c             	mov    0xc(%ebp),%edx
  8006ad:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  8006b1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006b4:	8b 00                	mov    (%eax),%eax
  8006b6:	3d ff 00 00 00       	cmp    $0xff,%eax
  8006bb:	75 30                	jne    8006ed <putch+0x5c>
		sys_cputs(b->buf, b->idx, printProgName, curTextClr);
  8006bd:	8b 15 1c b1 81 00    	mov    0x81b11c,%edx
  8006c3:	a0 44 30 80 00       	mov    0x803044,%al
  8006c8:	0f b6 c0             	movzbl %al,%eax
  8006cb:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8006ce:	8b 09                	mov    (%ecx),%ecx
  8006d0:	89 cb                	mov    %ecx,%ebx
  8006d2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8006d5:	83 c1 08             	add    $0x8,%ecx
  8006d8:	52                   	push   %edx
  8006d9:	50                   	push   %eax
  8006da:	53                   	push   %ebx
  8006db:	51                   	push   %ecx
  8006dc:	e8 a8 11 00 00       	call   801889 <sys_cputs>
  8006e1:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8006e4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006e7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8006ed:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006f0:	8b 40 04             	mov    0x4(%eax),%eax
  8006f3:	8d 50 01             	lea    0x1(%eax),%edx
  8006f6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006f9:	89 50 04             	mov    %edx,0x4(%eax)
}
  8006fc:	90                   	nop
  8006fd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800700:	c9                   	leave  
  800701:	c3                   	ret    

00800702 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800702:	55                   	push   %ebp
  800703:	89 e5                	mov    %esp,%ebp
  800705:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  80070b:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800712:	00 00 00 
	b.cnt = 0;
  800715:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  80071c:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  80071f:	ff 75 0c             	pushl  0xc(%ebp)
  800722:	ff 75 08             	pushl  0x8(%ebp)
  800725:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80072b:	50                   	push   %eax
  80072c:	68 91 06 80 00       	push   $0x800691
  800731:	e8 5a 02 00 00       	call   800990 <vprintfmt>
  800736:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName, curTextClr);
  800739:	8b 15 1c b1 81 00    	mov    0x81b11c,%edx
  80073f:	a0 44 30 80 00       	mov    0x803044,%al
  800744:	0f b6 c0             	movzbl %al,%eax
  800747:	8b 8d f0 fe ff ff    	mov    -0x110(%ebp),%ecx
  80074d:	52                   	push   %edx
  80074e:	50                   	push   %eax
  80074f:	51                   	push   %ecx
  800750:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800756:	83 c0 08             	add    $0x8,%eax
  800759:	50                   	push   %eax
  80075a:	e8 2a 11 00 00       	call   801889 <sys_cputs>
  80075f:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800762:	c6 05 44 30 80 00 00 	movb   $0x0,0x803044
	return b.cnt;
  800769:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  80076f:	c9                   	leave  
  800770:	c3                   	ret    

00800771 <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  800771:	55                   	push   %ebp
  800772:	89 e5                	mov    %esp,%ebp
  800774:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800777:	c6 05 44 30 80 00 01 	movb   $0x1,0x803044
	va_start(ap, fmt);
  80077e:	8d 45 0c             	lea    0xc(%ebp),%eax
  800781:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800784:	8b 45 08             	mov    0x8(%ebp),%eax
  800787:	83 ec 08             	sub    $0x8,%esp
  80078a:	ff 75 f4             	pushl  -0xc(%ebp)
  80078d:	50                   	push   %eax
  80078e:	e8 6f ff ff ff       	call   800702 <vcprintf>
  800793:	83 c4 10             	add    $0x10,%esp
  800796:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800799:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80079c:	c9                   	leave  
  80079d:	c3                   	ret    

0080079e <cprintf_colored>:

// *************** This text coloring feature is implemented by *************
// ********** Abd-Alrahman Zedan From Team Frozen-Bytes - FCIS'24-25 ********
int cprintf_colored(int textClr, const char *fmt, ...) {
  80079e:	55                   	push   %ebp
  80079f:	89 e5                	mov    %esp,%ebp
  8007a1:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  8007a4:	c6 05 44 30 80 00 01 	movb   $0x1,0x803044
	curTextClr = (textClr << 8) ; //set text color by the given value
  8007ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8007ae:	c1 e0 08             	shl    $0x8,%eax
  8007b1:	a3 1c b1 81 00       	mov    %eax,0x81b11c
	va_start(ap, fmt);
  8007b6:	8d 45 0c             	lea    0xc(%ebp),%eax
  8007b9:	83 c0 04             	add    $0x4,%eax
  8007bc:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8007bf:	8b 45 0c             	mov    0xc(%ebp),%eax
  8007c2:	83 ec 08             	sub    $0x8,%esp
  8007c5:	ff 75 f4             	pushl  -0xc(%ebp)
  8007c8:	50                   	push   %eax
  8007c9:	e8 34 ff ff ff       	call   800702 <vcprintf>
  8007ce:	83 c4 10             	add    $0x10,%esp
  8007d1:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);
	curTextClr = TEXT_DEFAULT_CLR; //restore default color
  8007d4:	c7 05 1c b1 81 00 00 	movl   $0x700,0x81b11c
  8007db:	07 00 00 

	return cnt;
  8007de:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8007e1:	c9                   	leave  
  8007e2:	c3                   	ret    

008007e3 <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  8007e3:	55                   	push   %ebp
  8007e4:	89 e5                	mov    %esp,%ebp
  8007e6:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  8007e9:	e8 df 10 00 00       	call   8018cd <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  8007ee:	8d 45 0c             	lea    0xc(%ebp),%eax
  8007f1:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  8007f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8007f7:	83 ec 08             	sub    $0x8,%esp
  8007fa:	ff 75 f4             	pushl  -0xc(%ebp)
  8007fd:	50                   	push   %eax
  8007fe:	e8 ff fe ff ff       	call   800702 <vcprintf>
  800803:	83 c4 10             	add    $0x10,%esp
  800806:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  800809:	e8 d9 10 00 00       	call   8018e7 <sys_unlock_cons>
	return cnt;
  80080e:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800811:	c9                   	leave  
  800812:	c3                   	ret    

00800813 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800813:	55                   	push   %ebp
  800814:	89 e5                	mov    %esp,%ebp
  800816:	53                   	push   %ebx
  800817:	83 ec 14             	sub    $0x14,%esp
  80081a:	8b 45 10             	mov    0x10(%ebp),%eax
  80081d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800820:	8b 45 14             	mov    0x14(%ebp),%eax
  800823:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800826:	8b 45 18             	mov    0x18(%ebp),%eax
  800829:	ba 00 00 00 00       	mov    $0x0,%edx
  80082e:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800831:	77 55                	ja     800888 <printnum+0x75>
  800833:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800836:	72 05                	jb     80083d <printnum+0x2a>
  800838:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80083b:	77 4b                	ja     800888 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  80083d:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800840:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800843:	8b 45 18             	mov    0x18(%ebp),%eax
  800846:	ba 00 00 00 00       	mov    $0x0,%edx
  80084b:	52                   	push   %edx
  80084c:	50                   	push   %eax
  80084d:	ff 75 f4             	pushl  -0xc(%ebp)
  800850:	ff 75 f0             	pushl  -0x10(%ebp)
  800853:	e8 ac 16 00 00       	call   801f04 <__udivdi3>
  800858:	83 c4 10             	add    $0x10,%esp
  80085b:	83 ec 04             	sub    $0x4,%esp
  80085e:	ff 75 20             	pushl  0x20(%ebp)
  800861:	53                   	push   %ebx
  800862:	ff 75 18             	pushl  0x18(%ebp)
  800865:	52                   	push   %edx
  800866:	50                   	push   %eax
  800867:	ff 75 0c             	pushl  0xc(%ebp)
  80086a:	ff 75 08             	pushl  0x8(%ebp)
  80086d:	e8 a1 ff ff ff       	call   800813 <printnum>
  800872:	83 c4 20             	add    $0x20,%esp
  800875:	eb 1a                	jmp    800891 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800877:	83 ec 08             	sub    $0x8,%esp
  80087a:	ff 75 0c             	pushl  0xc(%ebp)
  80087d:	ff 75 20             	pushl  0x20(%ebp)
  800880:	8b 45 08             	mov    0x8(%ebp),%eax
  800883:	ff d0                	call   *%eax
  800885:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800888:	ff 4d 1c             	decl   0x1c(%ebp)
  80088b:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  80088f:	7f e6                	jg     800877 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800891:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800894:	bb 00 00 00 00       	mov    $0x0,%ebx
  800899:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80089c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80089f:	53                   	push   %ebx
  8008a0:	51                   	push   %ecx
  8008a1:	52                   	push   %edx
  8008a2:	50                   	push   %eax
  8008a3:	e8 6c 17 00 00       	call   802014 <__umoddi3>
  8008a8:	83 c4 10             	add    $0x10,%esp
  8008ab:	05 b4 28 80 00       	add    $0x8028b4,%eax
  8008b0:	8a 00                	mov    (%eax),%al
  8008b2:	0f be c0             	movsbl %al,%eax
  8008b5:	83 ec 08             	sub    $0x8,%esp
  8008b8:	ff 75 0c             	pushl  0xc(%ebp)
  8008bb:	50                   	push   %eax
  8008bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8008bf:	ff d0                	call   *%eax
  8008c1:	83 c4 10             	add    $0x10,%esp
}
  8008c4:	90                   	nop
  8008c5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8008c8:	c9                   	leave  
  8008c9:	c3                   	ret    

008008ca <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8008ca:	55                   	push   %ebp
  8008cb:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8008cd:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8008d1:	7e 1c                	jle    8008ef <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  8008d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8008d6:	8b 00                	mov    (%eax),%eax
  8008d8:	8d 50 08             	lea    0x8(%eax),%edx
  8008db:	8b 45 08             	mov    0x8(%ebp),%eax
  8008de:	89 10                	mov    %edx,(%eax)
  8008e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8008e3:	8b 00                	mov    (%eax),%eax
  8008e5:	83 e8 08             	sub    $0x8,%eax
  8008e8:	8b 50 04             	mov    0x4(%eax),%edx
  8008eb:	8b 00                	mov    (%eax),%eax
  8008ed:	eb 40                	jmp    80092f <getuint+0x65>
	else if (lflag)
  8008ef:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8008f3:	74 1e                	je     800913 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  8008f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8008f8:	8b 00                	mov    (%eax),%eax
  8008fa:	8d 50 04             	lea    0x4(%eax),%edx
  8008fd:	8b 45 08             	mov    0x8(%ebp),%eax
  800900:	89 10                	mov    %edx,(%eax)
  800902:	8b 45 08             	mov    0x8(%ebp),%eax
  800905:	8b 00                	mov    (%eax),%eax
  800907:	83 e8 04             	sub    $0x4,%eax
  80090a:	8b 00                	mov    (%eax),%eax
  80090c:	ba 00 00 00 00       	mov    $0x0,%edx
  800911:	eb 1c                	jmp    80092f <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800913:	8b 45 08             	mov    0x8(%ebp),%eax
  800916:	8b 00                	mov    (%eax),%eax
  800918:	8d 50 04             	lea    0x4(%eax),%edx
  80091b:	8b 45 08             	mov    0x8(%ebp),%eax
  80091e:	89 10                	mov    %edx,(%eax)
  800920:	8b 45 08             	mov    0x8(%ebp),%eax
  800923:	8b 00                	mov    (%eax),%eax
  800925:	83 e8 04             	sub    $0x4,%eax
  800928:	8b 00                	mov    (%eax),%eax
  80092a:	ba 00 00 00 00       	mov    $0x0,%edx
}
  80092f:	5d                   	pop    %ebp
  800930:	c3                   	ret    

00800931 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800931:	55                   	push   %ebp
  800932:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800934:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800938:	7e 1c                	jle    800956 <getint+0x25>
		return va_arg(*ap, long long);
  80093a:	8b 45 08             	mov    0x8(%ebp),%eax
  80093d:	8b 00                	mov    (%eax),%eax
  80093f:	8d 50 08             	lea    0x8(%eax),%edx
  800942:	8b 45 08             	mov    0x8(%ebp),%eax
  800945:	89 10                	mov    %edx,(%eax)
  800947:	8b 45 08             	mov    0x8(%ebp),%eax
  80094a:	8b 00                	mov    (%eax),%eax
  80094c:	83 e8 08             	sub    $0x8,%eax
  80094f:	8b 50 04             	mov    0x4(%eax),%edx
  800952:	8b 00                	mov    (%eax),%eax
  800954:	eb 38                	jmp    80098e <getint+0x5d>
	else if (lflag)
  800956:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80095a:	74 1a                	je     800976 <getint+0x45>
		return va_arg(*ap, long);
  80095c:	8b 45 08             	mov    0x8(%ebp),%eax
  80095f:	8b 00                	mov    (%eax),%eax
  800961:	8d 50 04             	lea    0x4(%eax),%edx
  800964:	8b 45 08             	mov    0x8(%ebp),%eax
  800967:	89 10                	mov    %edx,(%eax)
  800969:	8b 45 08             	mov    0x8(%ebp),%eax
  80096c:	8b 00                	mov    (%eax),%eax
  80096e:	83 e8 04             	sub    $0x4,%eax
  800971:	8b 00                	mov    (%eax),%eax
  800973:	99                   	cltd   
  800974:	eb 18                	jmp    80098e <getint+0x5d>
	else
		return va_arg(*ap, int);
  800976:	8b 45 08             	mov    0x8(%ebp),%eax
  800979:	8b 00                	mov    (%eax),%eax
  80097b:	8d 50 04             	lea    0x4(%eax),%edx
  80097e:	8b 45 08             	mov    0x8(%ebp),%eax
  800981:	89 10                	mov    %edx,(%eax)
  800983:	8b 45 08             	mov    0x8(%ebp),%eax
  800986:	8b 00                	mov    (%eax),%eax
  800988:	83 e8 04             	sub    $0x4,%eax
  80098b:	8b 00                	mov    (%eax),%eax
  80098d:	99                   	cltd   
}
  80098e:	5d                   	pop    %ebp
  80098f:	c3                   	ret    

00800990 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800990:	55                   	push   %ebp
  800991:	89 e5                	mov    %esp,%ebp
  800993:	56                   	push   %esi
  800994:	53                   	push   %ebx
  800995:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800998:	eb 17                	jmp    8009b1 <vprintfmt+0x21>
			if (ch == '\0')
  80099a:	85 db                	test   %ebx,%ebx
  80099c:	0f 84 c1 03 00 00    	je     800d63 <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  8009a2:	83 ec 08             	sub    $0x8,%esp
  8009a5:	ff 75 0c             	pushl  0xc(%ebp)
  8009a8:	53                   	push   %ebx
  8009a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8009ac:	ff d0                	call   *%eax
  8009ae:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8009b1:	8b 45 10             	mov    0x10(%ebp),%eax
  8009b4:	8d 50 01             	lea    0x1(%eax),%edx
  8009b7:	89 55 10             	mov    %edx,0x10(%ebp)
  8009ba:	8a 00                	mov    (%eax),%al
  8009bc:	0f b6 d8             	movzbl %al,%ebx
  8009bf:	83 fb 25             	cmp    $0x25,%ebx
  8009c2:	75 d6                	jne    80099a <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  8009c4:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  8009c8:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  8009cf:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8009d6:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  8009dd:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8009e4:	8b 45 10             	mov    0x10(%ebp),%eax
  8009e7:	8d 50 01             	lea    0x1(%eax),%edx
  8009ea:	89 55 10             	mov    %edx,0x10(%ebp)
  8009ed:	8a 00                	mov    (%eax),%al
  8009ef:	0f b6 d8             	movzbl %al,%ebx
  8009f2:	8d 43 dd             	lea    -0x23(%ebx),%eax
  8009f5:	83 f8 5b             	cmp    $0x5b,%eax
  8009f8:	0f 87 3d 03 00 00    	ja     800d3b <vprintfmt+0x3ab>
  8009fe:	8b 04 85 d8 28 80 00 	mov    0x8028d8(,%eax,4),%eax
  800a05:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800a07:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800a0b:	eb d7                	jmp    8009e4 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800a0d:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800a11:	eb d1                	jmp    8009e4 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800a13:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800a1a:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800a1d:	89 d0                	mov    %edx,%eax
  800a1f:	c1 e0 02             	shl    $0x2,%eax
  800a22:	01 d0                	add    %edx,%eax
  800a24:	01 c0                	add    %eax,%eax
  800a26:	01 d8                	add    %ebx,%eax
  800a28:	83 e8 30             	sub    $0x30,%eax
  800a2b:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800a2e:	8b 45 10             	mov    0x10(%ebp),%eax
  800a31:	8a 00                	mov    (%eax),%al
  800a33:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800a36:	83 fb 2f             	cmp    $0x2f,%ebx
  800a39:	7e 3e                	jle    800a79 <vprintfmt+0xe9>
  800a3b:	83 fb 39             	cmp    $0x39,%ebx
  800a3e:	7f 39                	jg     800a79 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800a40:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800a43:	eb d5                	jmp    800a1a <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800a45:	8b 45 14             	mov    0x14(%ebp),%eax
  800a48:	83 c0 04             	add    $0x4,%eax
  800a4b:	89 45 14             	mov    %eax,0x14(%ebp)
  800a4e:	8b 45 14             	mov    0x14(%ebp),%eax
  800a51:	83 e8 04             	sub    $0x4,%eax
  800a54:	8b 00                	mov    (%eax),%eax
  800a56:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800a59:	eb 1f                	jmp    800a7a <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800a5b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a5f:	79 83                	jns    8009e4 <vprintfmt+0x54>
				width = 0;
  800a61:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800a68:	e9 77 ff ff ff       	jmp    8009e4 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800a6d:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800a74:	e9 6b ff ff ff       	jmp    8009e4 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800a79:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800a7a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a7e:	0f 89 60 ff ff ff    	jns    8009e4 <vprintfmt+0x54>
				width = precision, precision = -1;
  800a84:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800a87:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800a8a:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800a91:	e9 4e ff ff ff       	jmp    8009e4 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800a96:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800a99:	e9 46 ff ff ff       	jmp    8009e4 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800a9e:	8b 45 14             	mov    0x14(%ebp),%eax
  800aa1:	83 c0 04             	add    $0x4,%eax
  800aa4:	89 45 14             	mov    %eax,0x14(%ebp)
  800aa7:	8b 45 14             	mov    0x14(%ebp),%eax
  800aaa:	83 e8 04             	sub    $0x4,%eax
  800aad:	8b 00                	mov    (%eax),%eax
  800aaf:	83 ec 08             	sub    $0x8,%esp
  800ab2:	ff 75 0c             	pushl  0xc(%ebp)
  800ab5:	50                   	push   %eax
  800ab6:	8b 45 08             	mov    0x8(%ebp),%eax
  800ab9:	ff d0                	call   *%eax
  800abb:	83 c4 10             	add    $0x10,%esp
			break;
  800abe:	e9 9b 02 00 00       	jmp    800d5e <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800ac3:	8b 45 14             	mov    0x14(%ebp),%eax
  800ac6:	83 c0 04             	add    $0x4,%eax
  800ac9:	89 45 14             	mov    %eax,0x14(%ebp)
  800acc:	8b 45 14             	mov    0x14(%ebp),%eax
  800acf:	83 e8 04             	sub    $0x4,%eax
  800ad2:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800ad4:	85 db                	test   %ebx,%ebx
  800ad6:	79 02                	jns    800ada <vprintfmt+0x14a>
				err = -err;
  800ad8:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800ada:	83 fb 64             	cmp    $0x64,%ebx
  800add:	7f 0b                	jg     800aea <vprintfmt+0x15a>
  800adf:	8b 34 9d 20 27 80 00 	mov    0x802720(,%ebx,4),%esi
  800ae6:	85 f6                	test   %esi,%esi
  800ae8:	75 19                	jne    800b03 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800aea:	53                   	push   %ebx
  800aeb:	68 c5 28 80 00       	push   $0x8028c5
  800af0:	ff 75 0c             	pushl  0xc(%ebp)
  800af3:	ff 75 08             	pushl  0x8(%ebp)
  800af6:	e8 70 02 00 00       	call   800d6b <printfmt>
  800afb:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800afe:	e9 5b 02 00 00       	jmp    800d5e <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800b03:	56                   	push   %esi
  800b04:	68 ce 28 80 00       	push   $0x8028ce
  800b09:	ff 75 0c             	pushl  0xc(%ebp)
  800b0c:	ff 75 08             	pushl  0x8(%ebp)
  800b0f:	e8 57 02 00 00       	call   800d6b <printfmt>
  800b14:	83 c4 10             	add    $0x10,%esp
			break;
  800b17:	e9 42 02 00 00       	jmp    800d5e <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800b1c:	8b 45 14             	mov    0x14(%ebp),%eax
  800b1f:	83 c0 04             	add    $0x4,%eax
  800b22:	89 45 14             	mov    %eax,0x14(%ebp)
  800b25:	8b 45 14             	mov    0x14(%ebp),%eax
  800b28:	83 e8 04             	sub    $0x4,%eax
  800b2b:	8b 30                	mov    (%eax),%esi
  800b2d:	85 f6                	test   %esi,%esi
  800b2f:	75 05                	jne    800b36 <vprintfmt+0x1a6>
				p = "(null)";
  800b31:	be d1 28 80 00       	mov    $0x8028d1,%esi
			if (width > 0 && padc != '-')
  800b36:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800b3a:	7e 6d                	jle    800ba9 <vprintfmt+0x219>
  800b3c:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800b40:	74 67                	je     800ba9 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800b42:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800b45:	83 ec 08             	sub    $0x8,%esp
  800b48:	50                   	push   %eax
  800b49:	56                   	push   %esi
  800b4a:	e8 26 05 00 00       	call   801075 <strnlen>
  800b4f:	83 c4 10             	add    $0x10,%esp
  800b52:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800b55:	eb 16                	jmp    800b6d <vprintfmt+0x1dd>
					putch(padc, putdat);
  800b57:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800b5b:	83 ec 08             	sub    $0x8,%esp
  800b5e:	ff 75 0c             	pushl  0xc(%ebp)
  800b61:	50                   	push   %eax
  800b62:	8b 45 08             	mov    0x8(%ebp),%eax
  800b65:	ff d0                	call   *%eax
  800b67:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800b6a:	ff 4d e4             	decl   -0x1c(%ebp)
  800b6d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800b71:	7f e4                	jg     800b57 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800b73:	eb 34                	jmp    800ba9 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800b75:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800b79:	74 1c                	je     800b97 <vprintfmt+0x207>
  800b7b:	83 fb 1f             	cmp    $0x1f,%ebx
  800b7e:	7e 05                	jle    800b85 <vprintfmt+0x1f5>
  800b80:	83 fb 7e             	cmp    $0x7e,%ebx
  800b83:	7e 12                	jle    800b97 <vprintfmt+0x207>
					putch('?', putdat);
  800b85:	83 ec 08             	sub    $0x8,%esp
  800b88:	ff 75 0c             	pushl  0xc(%ebp)
  800b8b:	6a 3f                	push   $0x3f
  800b8d:	8b 45 08             	mov    0x8(%ebp),%eax
  800b90:	ff d0                	call   *%eax
  800b92:	83 c4 10             	add    $0x10,%esp
  800b95:	eb 0f                	jmp    800ba6 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800b97:	83 ec 08             	sub    $0x8,%esp
  800b9a:	ff 75 0c             	pushl  0xc(%ebp)
  800b9d:	53                   	push   %ebx
  800b9e:	8b 45 08             	mov    0x8(%ebp),%eax
  800ba1:	ff d0                	call   *%eax
  800ba3:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800ba6:	ff 4d e4             	decl   -0x1c(%ebp)
  800ba9:	89 f0                	mov    %esi,%eax
  800bab:	8d 70 01             	lea    0x1(%eax),%esi
  800bae:	8a 00                	mov    (%eax),%al
  800bb0:	0f be d8             	movsbl %al,%ebx
  800bb3:	85 db                	test   %ebx,%ebx
  800bb5:	74 24                	je     800bdb <vprintfmt+0x24b>
  800bb7:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800bbb:	78 b8                	js     800b75 <vprintfmt+0x1e5>
  800bbd:	ff 4d e0             	decl   -0x20(%ebp)
  800bc0:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800bc4:	79 af                	jns    800b75 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800bc6:	eb 13                	jmp    800bdb <vprintfmt+0x24b>
				putch(' ', putdat);
  800bc8:	83 ec 08             	sub    $0x8,%esp
  800bcb:	ff 75 0c             	pushl  0xc(%ebp)
  800bce:	6a 20                	push   $0x20
  800bd0:	8b 45 08             	mov    0x8(%ebp),%eax
  800bd3:	ff d0                	call   *%eax
  800bd5:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800bd8:	ff 4d e4             	decl   -0x1c(%ebp)
  800bdb:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800bdf:	7f e7                	jg     800bc8 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800be1:	e9 78 01 00 00       	jmp    800d5e <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800be6:	83 ec 08             	sub    $0x8,%esp
  800be9:	ff 75 e8             	pushl  -0x18(%ebp)
  800bec:	8d 45 14             	lea    0x14(%ebp),%eax
  800bef:	50                   	push   %eax
  800bf0:	e8 3c fd ff ff       	call   800931 <getint>
  800bf5:	83 c4 10             	add    $0x10,%esp
  800bf8:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800bfb:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800bfe:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800c01:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800c04:	85 d2                	test   %edx,%edx
  800c06:	79 23                	jns    800c2b <vprintfmt+0x29b>
				putch('-', putdat);
  800c08:	83 ec 08             	sub    $0x8,%esp
  800c0b:	ff 75 0c             	pushl  0xc(%ebp)
  800c0e:	6a 2d                	push   $0x2d
  800c10:	8b 45 08             	mov    0x8(%ebp),%eax
  800c13:	ff d0                	call   *%eax
  800c15:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800c18:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800c1b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800c1e:	f7 d8                	neg    %eax
  800c20:	83 d2 00             	adc    $0x0,%edx
  800c23:	f7 da                	neg    %edx
  800c25:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c28:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800c2b:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800c32:	e9 bc 00 00 00       	jmp    800cf3 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800c37:	83 ec 08             	sub    $0x8,%esp
  800c3a:	ff 75 e8             	pushl  -0x18(%ebp)
  800c3d:	8d 45 14             	lea    0x14(%ebp),%eax
  800c40:	50                   	push   %eax
  800c41:	e8 84 fc ff ff       	call   8008ca <getuint>
  800c46:	83 c4 10             	add    $0x10,%esp
  800c49:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c4c:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800c4f:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800c56:	e9 98 00 00 00       	jmp    800cf3 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800c5b:	83 ec 08             	sub    $0x8,%esp
  800c5e:	ff 75 0c             	pushl  0xc(%ebp)
  800c61:	6a 58                	push   $0x58
  800c63:	8b 45 08             	mov    0x8(%ebp),%eax
  800c66:	ff d0                	call   *%eax
  800c68:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800c6b:	83 ec 08             	sub    $0x8,%esp
  800c6e:	ff 75 0c             	pushl  0xc(%ebp)
  800c71:	6a 58                	push   $0x58
  800c73:	8b 45 08             	mov    0x8(%ebp),%eax
  800c76:	ff d0                	call   *%eax
  800c78:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800c7b:	83 ec 08             	sub    $0x8,%esp
  800c7e:	ff 75 0c             	pushl  0xc(%ebp)
  800c81:	6a 58                	push   $0x58
  800c83:	8b 45 08             	mov    0x8(%ebp),%eax
  800c86:	ff d0                	call   *%eax
  800c88:	83 c4 10             	add    $0x10,%esp
			break;
  800c8b:	e9 ce 00 00 00       	jmp    800d5e <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  800c90:	83 ec 08             	sub    $0x8,%esp
  800c93:	ff 75 0c             	pushl  0xc(%ebp)
  800c96:	6a 30                	push   $0x30
  800c98:	8b 45 08             	mov    0x8(%ebp),%eax
  800c9b:	ff d0                	call   *%eax
  800c9d:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800ca0:	83 ec 08             	sub    $0x8,%esp
  800ca3:	ff 75 0c             	pushl  0xc(%ebp)
  800ca6:	6a 78                	push   $0x78
  800ca8:	8b 45 08             	mov    0x8(%ebp),%eax
  800cab:	ff d0                	call   *%eax
  800cad:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800cb0:	8b 45 14             	mov    0x14(%ebp),%eax
  800cb3:	83 c0 04             	add    $0x4,%eax
  800cb6:	89 45 14             	mov    %eax,0x14(%ebp)
  800cb9:	8b 45 14             	mov    0x14(%ebp),%eax
  800cbc:	83 e8 04             	sub    $0x4,%eax
  800cbf:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800cc1:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800cc4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800ccb:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800cd2:	eb 1f                	jmp    800cf3 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800cd4:	83 ec 08             	sub    $0x8,%esp
  800cd7:	ff 75 e8             	pushl  -0x18(%ebp)
  800cda:	8d 45 14             	lea    0x14(%ebp),%eax
  800cdd:	50                   	push   %eax
  800cde:	e8 e7 fb ff ff       	call   8008ca <getuint>
  800ce3:	83 c4 10             	add    $0x10,%esp
  800ce6:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800ce9:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800cec:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800cf3:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800cf7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800cfa:	83 ec 04             	sub    $0x4,%esp
  800cfd:	52                   	push   %edx
  800cfe:	ff 75 e4             	pushl  -0x1c(%ebp)
  800d01:	50                   	push   %eax
  800d02:	ff 75 f4             	pushl  -0xc(%ebp)
  800d05:	ff 75 f0             	pushl  -0x10(%ebp)
  800d08:	ff 75 0c             	pushl  0xc(%ebp)
  800d0b:	ff 75 08             	pushl  0x8(%ebp)
  800d0e:	e8 00 fb ff ff       	call   800813 <printnum>
  800d13:	83 c4 20             	add    $0x20,%esp
			break;
  800d16:	eb 46                	jmp    800d5e <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800d18:	83 ec 08             	sub    $0x8,%esp
  800d1b:	ff 75 0c             	pushl  0xc(%ebp)
  800d1e:	53                   	push   %ebx
  800d1f:	8b 45 08             	mov    0x8(%ebp),%eax
  800d22:	ff d0                	call   *%eax
  800d24:	83 c4 10             	add    $0x10,%esp
			break;
  800d27:	eb 35                	jmp    800d5e <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  800d29:	c6 05 44 30 80 00 00 	movb   $0x0,0x803044
			break;
  800d30:	eb 2c                	jmp    800d5e <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  800d32:	c6 05 44 30 80 00 01 	movb   $0x1,0x803044
			break;
  800d39:	eb 23                	jmp    800d5e <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800d3b:	83 ec 08             	sub    $0x8,%esp
  800d3e:	ff 75 0c             	pushl  0xc(%ebp)
  800d41:	6a 25                	push   $0x25
  800d43:	8b 45 08             	mov    0x8(%ebp),%eax
  800d46:	ff d0                	call   *%eax
  800d48:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800d4b:	ff 4d 10             	decl   0x10(%ebp)
  800d4e:	eb 03                	jmp    800d53 <vprintfmt+0x3c3>
  800d50:	ff 4d 10             	decl   0x10(%ebp)
  800d53:	8b 45 10             	mov    0x10(%ebp),%eax
  800d56:	48                   	dec    %eax
  800d57:	8a 00                	mov    (%eax),%al
  800d59:	3c 25                	cmp    $0x25,%al
  800d5b:	75 f3                	jne    800d50 <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  800d5d:	90                   	nop
		}
	}
  800d5e:	e9 35 fc ff ff       	jmp    800998 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800d63:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800d64:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800d67:	5b                   	pop    %ebx
  800d68:	5e                   	pop    %esi
  800d69:	5d                   	pop    %ebp
  800d6a:	c3                   	ret    

00800d6b <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800d6b:	55                   	push   %ebp
  800d6c:	89 e5                	mov    %esp,%ebp
  800d6e:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800d71:	8d 45 10             	lea    0x10(%ebp),%eax
  800d74:	83 c0 04             	add    $0x4,%eax
  800d77:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800d7a:	8b 45 10             	mov    0x10(%ebp),%eax
  800d7d:	ff 75 f4             	pushl  -0xc(%ebp)
  800d80:	50                   	push   %eax
  800d81:	ff 75 0c             	pushl  0xc(%ebp)
  800d84:	ff 75 08             	pushl  0x8(%ebp)
  800d87:	e8 04 fc ff ff       	call   800990 <vprintfmt>
  800d8c:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800d8f:	90                   	nop
  800d90:	c9                   	leave  
  800d91:	c3                   	ret    

00800d92 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800d92:	55                   	push   %ebp
  800d93:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800d95:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d98:	8b 40 08             	mov    0x8(%eax),%eax
  800d9b:	8d 50 01             	lea    0x1(%eax),%edx
  800d9e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800da1:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800da4:	8b 45 0c             	mov    0xc(%ebp),%eax
  800da7:	8b 10                	mov    (%eax),%edx
  800da9:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dac:	8b 40 04             	mov    0x4(%eax),%eax
  800daf:	39 c2                	cmp    %eax,%edx
  800db1:	73 12                	jae    800dc5 <sprintputch+0x33>
		*b->buf++ = ch;
  800db3:	8b 45 0c             	mov    0xc(%ebp),%eax
  800db6:	8b 00                	mov    (%eax),%eax
  800db8:	8d 48 01             	lea    0x1(%eax),%ecx
  800dbb:	8b 55 0c             	mov    0xc(%ebp),%edx
  800dbe:	89 0a                	mov    %ecx,(%edx)
  800dc0:	8b 55 08             	mov    0x8(%ebp),%edx
  800dc3:	88 10                	mov    %dl,(%eax)
}
  800dc5:	90                   	nop
  800dc6:	5d                   	pop    %ebp
  800dc7:	c3                   	ret    

00800dc8 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800dc8:	55                   	push   %ebp
  800dc9:	89 e5                	mov    %esp,%ebp
  800dcb:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800dce:	8b 45 08             	mov    0x8(%ebp),%eax
  800dd1:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800dd4:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dd7:	8d 50 ff             	lea    -0x1(%eax),%edx
  800dda:	8b 45 08             	mov    0x8(%ebp),%eax
  800ddd:	01 d0                	add    %edx,%eax
  800ddf:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800de2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800de9:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800ded:	74 06                	je     800df5 <vsnprintf+0x2d>
  800def:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800df3:	7f 07                	jg     800dfc <vsnprintf+0x34>
		return -E_INVAL;
  800df5:	b8 03 00 00 00       	mov    $0x3,%eax
  800dfa:	eb 20                	jmp    800e1c <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800dfc:	ff 75 14             	pushl  0x14(%ebp)
  800dff:	ff 75 10             	pushl  0x10(%ebp)
  800e02:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800e05:	50                   	push   %eax
  800e06:	68 92 0d 80 00       	push   $0x800d92
  800e0b:	e8 80 fb ff ff       	call   800990 <vprintfmt>
  800e10:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800e13:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800e16:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800e19:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800e1c:	c9                   	leave  
  800e1d:	c3                   	ret    

00800e1e <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800e1e:	55                   	push   %ebp
  800e1f:	89 e5                	mov    %esp,%ebp
  800e21:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800e24:	8d 45 10             	lea    0x10(%ebp),%eax
  800e27:	83 c0 04             	add    $0x4,%eax
  800e2a:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800e2d:	8b 45 10             	mov    0x10(%ebp),%eax
  800e30:	ff 75 f4             	pushl  -0xc(%ebp)
  800e33:	50                   	push   %eax
  800e34:	ff 75 0c             	pushl  0xc(%ebp)
  800e37:	ff 75 08             	pushl  0x8(%ebp)
  800e3a:	e8 89 ff ff ff       	call   800dc8 <vsnprintf>
  800e3f:	83 c4 10             	add    $0x10,%esp
  800e42:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800e45:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800e48:	c9                   	leave  
  800e49:	c3                   	ret    

00800e4a <readline>:
#include <inc/lib.h>

//static char buf[BUFLEN];

void readline(const char *prompt, char* buf)
{
  800e4a:	55                   	push   %ebp
  800e4b:	89 e5                	mov    %esp,%ebp
  800e4d:	83 ec 18             	sub    $0x18,%esp
	int i, c, echoing;

	if (prompt != NULL)
  800e50:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800e54:	74 13                	je     800e69 <readline+0x1f>
		cprintf("%s", prompt);
  800e56:	83 ec 08             	sub    $0x8,%esp
  800e59:	ff 75 08             	pushl  0x8(%ebp)
  800e5c:	68 48 2a 80 00       	push   $0x802a48
  800e61:	e8 0b f9 ff ff       	call   800771 <cprintf>
  800e66:	83 c4 10             	add    $0x10,%esp

	i = 0;
  800e69:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	echoing = iscons(0);
  800e70:	83 ec 0c             	sub    $0xc,%esp
  800e73:	6a 00                	push   $0x0
  800e75:	e8 7e 10 00 00       	call   801ef8 <iscons>
  800e7a:	83 c4 10             	add    $0x10,%esp
  800e7d:	89 45 f0             	mov    %eax,-0x10(%ebp)
	while (1) {
		c = getchar();
  800e80:	e8 60 10 00 00       	call   801ee5 <getchar>
  800e85:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if (c < 0) {
  800e88:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800e8c:	79 22                	jns    800eb0 <readline+0x66>
			if (c != -E_EOF)
  800e8e:	83 7d ec 07          	cmpl   $0x7,-0x14(%ebp)
  800e92:	0f 84 ad 00 00 00    	je     800f45 <readline+0xfb>
				cprintf("read error: %e\n", c);
  800e98:	83 ec 08             	sub    $0x8,%esp
  800e9b:	ff 75 ec             	pushl  -0x14(%ebp)
  800e9e:	68 4b 2a 80 00       	push   $0x802a4b
  800ea3:	e8 c9 f8 ff ff       	call   800771 <cprintf>
  800ea8:	83 c4 10             	add    $0x10,%esp
			break;
  800eab:	e9 95 00 00 00       	jmp    800f45 <readline+0xfb>
		} else if (c >= ' ' && i < BUFLEN-1) {
  800eb0:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%ebp)
  800eb4:	7e 34                	jle    800eea <readline+0xa0>
  800eb6:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  800ebd:	7f 2b                	jg     800eea <readline+0xa0>
			if (echoing)
  800ebf:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800ec3:	74 0e                	je     800ed3 <readline+0x89>
				cputchar(c);
  800ec5:	83 ec 0c             	sub    $0xc,%esp
  800ec8:	ff 75 ec             	pushl  -0x14(%ebp)
  800ecb:	e8 f6 0f 00 00       	call   801ec6 <cputchar>
  800ed0:	83 c4 10             	add    $0x10,%esp
			buf[i++] = c;
  800ed3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800ed6:	8d 50 01             	lea    0x1(%eax),%edx
  800ed9:	89 55 f4             	mov    %edx,-0xc(%ebp)
  800edc:	89 c2                	mov    %eax,%edx
  800ede:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ee1:	01 d0                	add    %edx,%eax
  800ee3:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800ee6:	88 10                	mov    %dl,(%eax)
  800ee8:	eb 56                	jmp    800f40 <readline+0xf6>
		} else if (c == '\b' && i > 0) {
  800eea:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  800eee:	75 1f                	jne    800f0f <readline+0xc5>
  800ef0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  800ef4:	7e 19                	jle    800f0f <readline+0xc5>
			if (echoing)
  800ef6:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800efa:	74 0e                	je     800f0a <readline+0xc0>
				cputchar(c);
  800efc:	83 ec 0c             	sub    $0xc,%esp
  800eff:	ff 75 ec             	pushl  -0x14(%ebp)
  800f02:	e8 bf 0f 00 00       	call   801ec6 <cputchar>
  800f07:	83 c4 10             	add    $0x10,%esp

			i--;
  800f0a:	ff 4d f4             	decl   -0xc(%ebp)
  800f0d:	eb 31                	jmp    800f40 <readline+0xf6>
		} else if (c == '\n' || c == '\r') {
  800f0f:	83 7d ec 0a          	cmpl   $0xa,-0x14(%ebp)
  800f13:	74 0a                	je     800f1f <readline+0xd5>
  800f15:	83 7d ec 0d          	cmpl   $0xd,-0x14(%ebp)
  800f19:	0f 85 61 ff ff ff    	jne    800e80 <readline+0x36>
			if (echoing)
  800f1f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800f23:	74 0e                	je     800f33 <readline+0xe9>
				cputchar(c);
  800f25:	83 ec 0c             	sub    $0xc,%esp
  800f28:	ff 75 ec             	pushl  -0x14(%ebp)
  800f2b:	e8 96 0f 00 00       	call   801ec6 <cputchar>
  800f30:	83 c4 10             	add    $0x10,%esp

			buf[i] = 0;
  800f33:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800f36:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f39:	01 d0                	add    %edx,%eax
  800f3b:	c6 00 00             	movb   $0x0,(%eax)
			break;
  800f3e:	eb 06                	jmp    800f46 <readline+0xfc>
		}
	}
  800f40:	e9 3b ff ff ff       	jmp    800e80 <readline+0x36>
	while (1) {
		c = getchar();
		if (c < 0) {
			if (c != -E_EOF)
				cprintf("read error: %e\n", c);
			break;
  800f45:	90                   	nop

			buf[i] = 0;
			break;
		}
	}
}
  800f46:	90                   	nop
  800f47:	c9                   	leave  
  800f48:	c3                   	ret    

00800f49 <atomic_readline>:

void atomic_readline(const char *prompt, char* buf)
{
  800f49:	55                   	push   %ebp
  800f4a:	89 e5                	mov    %esp,%ebp
  800f4c:	83 ec 18             	sub    $0x18,%esp
	sys_lock_cons();
  800f4f:	e8 79 09 00 00       	call   8018cd <sys_lock_cons>
	{
		int i, c, echoing;

		if (prompt != NULL)
  800f54:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800f58:	74 13                	je     800f6d <atomic_readline+0x24>
			cprintf("%s", prompt);
  800f5a:	83 ec 08             	sub    $0x8,%esp
  800f5d:	ff 75 08             	pushl  0x8(%ebp)
  800f60:	68 48 2a 80 00       	push   $0x802a48
  800f65:	e8 07 f8 ff ff       	call   800771 <cprintf>
  800f6a:	83 c4 10             	add    $0x10,%esp

		i = 0;
  800f6d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
		echoing = iscons(0);
  800f74:	83 ec 0c             	sub    $0xc,%esp
  800f77:	6a 00                	push   $0x0
  800f79:	e8 7a 0f 00 00       	call   801ef8 <iscons>
  800f7e:	83 c4 10             	add    $0x10,%esp
  800f81:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (1) {
			c = getchar();
  800f84:	e8 5c 0f 00 00       	call   801ee5 <getchar>
  800f89:	89 45 ec             	mov    %eax,-0x14(%ebp)
			if (c < 0) {
  800f8c:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800f90:	79 22                	jns    800fb4 <atomic_readline+0x6b>
				if (c != -E_EOF)
  800f92:	83 7d ec 07          	cmpl   $0x7,-0x14(%ebp)
  800f96:	0f 84 ad 00 00 00    	je     801049 <atomic_readline+0x100>
					cprintf("read error: %e\n", c);
  800f9c:	83 ec 08             	sub    $0x8,%esp
  800f9f:	ff 75 ec             	pushl  -0x14(%ebp)
  800fa2:	68 4b 2a 80 00       	push   $0x802a4b
  800fa7:	e8 c5 f7 ff ff       	call   800771 <cprintf>
  800fac:	83 c4 10             	add    $0x10,%esp
				break;
  800faf:	e9 95 00 00 00       	jmp    801049 <atomic_readline+0x100>
			} else if (c >= ' ' && i < BUFLEN-1) {
  800fb4:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%ebp)
  800fb8:	7e 34                	jle    800fee <atomic_readline+0xa5>
  800fba:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  800fc1:	7f 2b                	jg     800fee <atomic_readline+0xa5>
				if (echoing)
  800fc3:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800fc7:	74 0e                	je     800fd7 <atomic_readline+0x8e>
					cputchar(c);
  800fc9:	83 ec 0c             	sub    $0xc,%esp
  800fcc:	ff 75 ec             	pushl  -0x14(%ebp)
  800fcf:	e8 f2 0e 00 00       	call   801ec6 <cputchar>
  800fd4:	83 c4 10             	add    $0x10,%esp
				buf[i++] = c;
  800fd7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800fda:	8d 50 01             	lea    0x1(%eax),%edx
  800fdd:	89 55 f4             	mov    %edx,-0xc(%ebp)
  800fe0:	89 c2                	mov    %eax,%edx
  800fe2:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fe5:	01 d0                	add    %edx,%eax
  800fe7:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800fea:	88 10                	mov    %dl,(%eax)
  800fec:	eb 56                	jmp    801044 <atomic_readline+0xfb>
			} else if (c == '\b' && i > 0) {
  800fee:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  800ff2:	75 1f                	jne    801013 <atomic_readline+0xca>
  800ff4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  800ff8:	7e 19                	jle    801013 <atomic_readline+0xca>
				if (echoing)
  800ffa:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800ffe:	74 0e                	je     80100e <atomic_readline+0xc5>
					cputchar(c);
  801000:	83 ec 0c             	sub    $0xc,%esp
  801003:	ff 75 ec             	pushl  -0x14(%ebp)
  801006:	e8 bb 0e 00 00       	call   801ec6 <cputchar>
  80100b:	83 c4 10             	add    $0x10,%esp
				i--;
  80100e:	ff 4d f4             	decl   -0xc(%ebp)
  801011:	eb 31                	jmp    801044 <atomic_readline+0xfb>
			} else if (c == '\n' || c == '\r') {
  801013:	83 7d ec 0a          	cmpl   $0xa,-0x14(%ebp)
  801017:	74 0a                	je     801023 <atomic_readline+0xda>
  801019:	83 7d ec 0d          	cmpl   $0xd,-0x14(%ebp)
  80101d:	0f 85 61 ff ff ff    	jne    800f84 <atomic_readline+0x3b>
				if (echoing)
  801023:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801027:	74 0e                	je     801037 <atomic_readline+0xee>
					cputchar(c);
  801029:	83 ec 0c             	sub    $0xc,%esp
  80102c:	ff 75 ec             	pushl  -0x14(%ebp)
  80102f:	e8 92 0e 00 00       	call   801ec6 <cputchar>
  801034:	83 c4 10             	add    $0x10,%esp
				buf[i] = 0;
  801037:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80103a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80103d:	01 d0                	add    %edx,%eax
  80103f:	c6 00 00             	movb   $0x0,(%eax)
				break;
  801042:	eb 06                	jmp    80104a <atomic_readline+0x101>
			}
		}
  801044:	e9 3b ff ff ff       	jmp    800f84 <atomic_readline+0x3b>
		while (1) {
			c = getchar();
			if (c < 0) {
				if (c != -E_EOF)
					cprintf("read error: %e\n", c);
				break;
  801049:	90                   	nop
				buf[i] = 0;
				break;
			}
		}
	}
	sys_unlock_cons();
  80104a:	e8 98 08 00 00       	call   8018e7 <sys_unlock_cons>
}
  80104f:	90                   	nop
  801050:	c9                   	leave  
  801051:	c3                   	ret    

00801052 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  801052:	55                   	push   %ebp
  801053:	89 e5                	mov    %esp,%ebp
  801055:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  801058:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80105f:	eb 06                	jmp    801067 <strlen+0x15>
		n++;
  801061:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  801064:	ff 45 08             	incl   0x8(%ebp)
  801067:	8b 45 08             	mov    0x8(%ebp),%eax
  80106a:	8a 00                	mov    (%eax),%al
  80106c:	84 c0                	test   %al,%al
  80106e:	75 f1                	jne    801061 <strlen+0xf>
		n++;
	return n;
  801070:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801073:	c9                   	leave  
  801074:	c3                   	ret    

00801075 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  801075:	55                   	push   %ebp
  801076:	89 e5                	mov    %esp,%ebp
  801078:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80107b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801082:	eb 09                	jmp    80108d <strnlen+0x18>
		n++;
  801084:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801087:	ff 45 08             	incl   0x8(%ebp)
  80108a:	ff 4d 0c             	decl   0xc(%ebp)
  80108d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801091:	74 09                	je     80109c <strnlen+0x27>
  801093:	8b 45 08             	mov    0x8(%ebp),%eax
  801096:	8a 00                	mov    (%eax),%al
  801098:	84 c0                	test   %al,%al
  80109a:	75 e8                	jne    801084 <strnlen+0xf>
		n++;
	return n;
  80109c:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  80109f:	c9                   	leave  
  8010a0:	c3                   	ret    

008010a1 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8010a1:	55                   	push   %ebp
  8010a2:	89 e5                	mov    %esp,%ebp
  8010a4:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  8010a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8010aa:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  8010ad:	90                   	nop
  8010ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8010b1:	8d 50 01             	lea    0x1(%eax),%edx
  8010b4:	89 55 08             	mov    %edx,0x8(%ebp)
  8010b7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8010ba:	8d 4a 01             	lea    0x1(%edx),%ecx
  8010bd:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  8010c0:	8a 12                	mov    (%edx),%dl
  8010c2:	88 10                	mov    %dl,(%eax)
  8010c4:	8a 00                	mov    (%eax),%al
  8010c6:	84 c0                	test   %al,%al
  8010c8:	75 e4                	jne    8010ae <strcpy+0xd>
		/* do nothing */;
	return ret;
  8010ca:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8010cd:	c9                   	leave  
  8010ce:	c3                   	ret    

008010cf <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  8010cf:	55                   	push   %ebp
  8010d0:	89 e5                	mov    %esp,%ebp
  8010d2:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  8010d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8010d8:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  8010db:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8010e2:	eb 1f                	jmp    801103 <strncpy+0x34>
		*dst++ = *src;
  8010e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8010e7:	8d 50 01             	lea    0x1(%eax),%edx
  8010ea:	89 55 08             	mov    %edx,0x8(%ebp)
  8010ed:	8b 55 0c             	mov    0xc(%ebp),%edx
  8010f0:	8a 12                	mov    (%edx),%dl
  8010f2:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  8010f4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010f7:	8a 00                	mov    (%eax),%al
  8010f9:	84 c0                	test   %al,%al
  8010fb:	74 03                	je     801100 <strncpy+0x31>
			src++;
  8010fd:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  801100:	ff 45 fc             	incl   -0x4(%ebp)
  801103:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801106:	3b 45 10             	cmp    0x10(%ebp),%eax
  801109:	72 d9                	jb     8010e4 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  80110b:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  80110e:	c9                   	leave  
  80110f:	c3                   	ret    

00801110 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  801110:	55                   	push   %ebp
  801111:	89 e5                	mov    %esp,%ebp
  801113:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  801116:	8b 45 08             	mov    0x8(%ebp),%eax
  801119:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  80111c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801120:	74 30                	je     801152 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  801122:	eb 16                	jmp    80113a <strlcpy+0x2a>
			*dst++ = *src++;
  801124:	8b 45 08             	mov    0x8(%ebp),%eax
  801127:	8d 50 01             	lea    0x1(%eax),%edx
  80112a:	89 55 08             	mov    %edx,0x8(%ebp)
  80112d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801130:	8d 4a 01             	lea    0x1(%edx),%ecx
  801133:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  801136:	8a 12                	mov    (%edx),%dl
  801138:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  80113a:	ff 4d 10             	decl   0x10(%ebp)
  80113d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801141:	74 09                	je     80114c <strlcpy+0x3c>
  801143:	8b 45 0c             	mov    0xc(%ebp),%eax
  801146:	8a 00                	mov    (%eax),%al
  801148:	84 c0                	test   %al,%al
  80114a:	75 d8                	jne    801124 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  80114c:	8b 45 08             	mov    0x8(%ebp),%eax
  80114f:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  801152:	8b 55 08             	mov    0x8(%ebp),%edx
  801155:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801158:	29 c2                	sub    %eax,%edx
  80115a:	89 d0                	mov    %edx,%eax
}
  80115c:	c9                   	leave  
  80115d:	c3                   	ret    

0080115e <strcmp>:

int
strcmp(const char *p, const char *q)
{
  80115e:	55                   	push   %ebp
  80115f:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  801161:	eb 06                	jmp    801169 <strcmp+0xb>
		p++, q++;
  801163:	ff 45 08             	incl   0x8(%ebp)
  801166:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  801169:	8b 45 08             	mov    0x8(%ebp),%eax
  80116c:	8a 00                	mov    (%eax),%al
  80116e:	84 c0                	test   %al,%al
  801170:	74 0e                	je     801180 <strcmp+0x22>
  801172:	8b 45 08             	mov    0x8(%ebp),%eax
  801175:	8a 10                	mov    (%eax),%dl
  801177:	8b 45 0c             	mov    0xc(%ebp),%eax
  80117a:	8a 00                	mov    (%eax),%al
  80117c:	38 c2                	cmp    %al,%dl
  80117e:	74 e3                	je     801163 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  801180:	8b 45 08             	mov    0x8(%ebp),%eax
  801183:	8a 00                	mov    (%eax),%al
  801185:	0f b6 d0             	movzbl %al,%edx
  801188:	8b 45 0c             	mov    0xc(%ebp),%eax
  80118b:	8a 00                	mov    (%eax),%al
  80118d:	0f b6 c0             	movzbl %al,%eax
  801190:	29 c2                	sub    %eax,%edx
  801192:	89 d0                	mov    %edx,%eax
}
  801194:	5d                   	pop    %ebp
  801195:	c3                   	ret    

00801196 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  801196:	55                   	push   %ebp
  801197:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  801199:	eb 09                	jmp    8011a4 <strncmp+0xe>
		n--, p++, q++;
  80119b:	ff 4d 10             	decl   0x10(%ebp)
  80119e:	ff 45 08             	incl   0x8(%ebp)
  8011a1:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  8011a4:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8011a8:	74 17                	je     8011c1 <strncmp+0x2b>
  8011aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8011ad:	8a 00                	mov    (%eax),%al
  8011af:	84 c0                	test   %al,%al
  8011b1:	74 0e                	je     8011c1 <strncmp+0x2b>
  8011b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8011b6:	8a 10                	mov    (%eax),%dl
  8011b8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011bb:	8a 00                	mov    (%eax),%al
  8011bd:	38 c2                	cmp    %al,%dl
  8011bf:	74 da                	je     80119b <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  8011c1:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8011c5:	75 07                	jne    8011ce <strncmp+0x38>
		return 0;
  8011c7:	b8 00 00 00 00       	mov    $0x0,%eax
  8011cc:	eb 14                	jmp    8011e2 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8011ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8011d1:	8a 00                	mov    (%eax),%al
  8011d3:	0f b6 d0             	movzbl %al,%edx
  8011d6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011d9:	8a 00                	mov    (%eax),%al
  8011db:	0f b6 c0             	movzbl %al,%eax
  8011de:	29 c2                	sub    %eax,%edx
  8011e0:	89 d0                	mov    %edx,%eax
}
  8011e2:	5d                   	pop    %ebp
  8011e3:	c3                   	ret    

008011e4 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8011e4:	55                   	push   %ebp
  8011e5:	89 e5                	mov    %esp,%ebp
  8011e7:	83 ec 04             	sub    $0x4,%esp
  8011ea:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011ed:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  8011f0:	eb 12                	jmp    801204 <strchr+0x20>
		if (*s == c)
  8011f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8011f5:	8a 00                	mov    (%eax),%al
  8011f7:	3a 45 fc             	cmp    -0x4(%ebp),%al
  8011fa:	75 05                	jne    801201 <strchr+0x1d>
			return (char *) s;
  8011fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8011ff:	eb 11                	jmp    801212 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  801201:	ff 45 08             	incl   0x8(%ebp)
  801204:	8b 45 08             	mov    0x8(%ebp),%eax
  801207:	8a 00                	mov    (%eax),%al
  801209:	84 c0                	test   %al,%al
  80120b:	75 e5                	jne    8011f2 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  80120d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801212:	c9                   	leave  
  801213:	c3                   	ret    

00801214 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  801214:	55                   	push   %ebp
  801215:	89 e5                	mov    %esp,%ebp
  801217:	83 ec 04             	sub    $0x4,%esp
  80121a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80121d:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  801220:	eb 0d                	jmp    80122f <strfind+0x1b>
		if (*s == c)
  801222:	8b 45 08             	mov    0x8(%ebp),%eax
  801225:	8a 00                	mov    (%eax),%al
  801227:	3a 45 fc             	cmp    -0x4(%ebp),%al
  80122a:	74 0e                	je     80123a <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  80122c:	ff 45 08             	incl   0x8(%ebp)
  80122f:	8b 45 08             	mov    0x8(%ebp),%eax
  801232:	8a 00                	mov    (%eax),%al
  801234:	84 c0                	test   %al,%al
  801236:	75 ea                	jne    801222 <strfind+0xe>
  801238:	eb 01                	jmp    80123b <strfind+0x27>
		if (*s == c)
			break;
  80123a:	90                   	nop
	return (char *) s;
  80123b:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80123e:	c9                   	leave  
  80123f:	c3                   	ret    

00801240 <memset>:

// *************** The faster implementation of memset & memcpy is implemented by *************
// ****************** Team80 (Yahia Khaled, Malek Ahmed et al) - FCIS'24-25 *******************
void *
memset(void *v, int c, uint32 n)
{
  801240:	55                   	push   %ebp
  801241:	89 e5                	mov    %esp,%ebp
  801243:	83 ec 10             	sub    $0x10,%esp
//	m = n;
//	while (--m >= 0)
//		*p++ = c;

	/*Faster Implementation*/
	uint64* p64 = (uint64*)v;
  801246:	8b 45 08             	mov    0x8(%ebp),%eax
  801249:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if(n >= 8){
  80124c:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  801250:	76 63                	jbe    8012b5 <memset+0x75>
		uint64 data_block = c;
  801252:	8b 45 0c             	mov    0xc(%ebp),%eax
  801255:	99                   	cltd   
  801256:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801259:	89 55 f4             	mov    %edx,-0xc(%ebp)
		data_block |= data_block << 8;
  80125c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80125f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801262:	0f a4 c2 08          	shld   $0x8,%eax,%edx
  801266:	c1 e0 08             	shl    $0x8,%eax
  801269:	09 45 f0             	or     %eax,-0x10(%ebp)
  80126c:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 16;
  80126f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801272:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801275:	0f a4 c2 10          	shld   $0x10,%eax,%edx
  801279:	c1 e0 10             	shl    $0x10,%eax
  80127c:	09 45 f0             	or     %eax,-0x10(%ebp)
  80127f:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 32;
  801282:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801285:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801288:	89 c2                	mov    %eax,%edx
  80128a:	b8 00 00 00 00       	mov    $0x0,%eax
  80128f:	09 45 f0             	or     %eax,-0x10(%ebp)
  801292:	09 55 f4             	or     %edx,-0xc(%ebp)

		while(n >= 8)
  801295:	eb 18                	jmp    8012af <memset+0x6f>
			*p64++ = data_block, n -= 8;
  801297:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  80129a:	8d 41 08             	lea    0x8(%ecx),%eax
  80129d:	89 45 fc             	mov    %eax,-0x4(%ebp)
  8012a0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8012a3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8012a6:	89 01                	mov    %eax,(%ecx)
  8012a8:	89 51 04             	mov    %edx,0x4(%ecx)
  8012ab:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
		uint64 data_block = c;
		data_block |= data_block << 8;
		data_block |= data_block << 16;
		data_block |= data_block << 32;

		while(n >= 8)
  8012af:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  8012b3:	77 e2                	ja     801297 <memset+0x57>
			*p64++ = data_block, n -= 8;
	}

	if(n){
  8012b5:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8012b9:	74 23                	je     8012de <memset+0x9e>
		uint8* p8 = (uint8*)p64;
  8012bb:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8012be:	89 45 f8             	mov    %eax,-0x8(%ebp)
		while (n-- > 0)
  8012c1:	eb 0e                	jmp    8012d1 <memset+0x91>
			*p8++ = (uint8)c;
  8012c3:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8012c6:	8d 50 01             	lea    0x1(%eax),%edx
  8012c9:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8012cc:	8b 55 0c             	mov    0xc(%ebp),%edx
  8012cf:	88 10                	mov    %dl,(%eax)
			*p64++ = data_block, n -= 8;
	}

	if(n){
		uint8* p8 = (uint8*)p64;
		while (n-- > 0)
  8012d1:	8b 45 10             	mov    0x10(%ebp),%eax
  8012d4:	8d 50 ff             	lea    -0x1(%eax),%edx
  8012d7:	89 55 10             	mov    %edx,0x10(%ebp)
  8012da:	85 c0                	test   %eax,%eax
  8012dc:	75 e5                	jne    8012c3 <memset+0x83>
			*p8++ = (uint8)c;
	}

	return v;
  8012de:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8012e1:	c9                   	leave  
  8012e2:	c3                   	ret    

008012e3 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  8012e3:	55                   	push   %ebp
  8012e4:	89 e5                	mov    %esp,%ebp
  8012e6:	83 ec 10             	sub    $0x10,%esp
	//	s = src;
	//	d = dst;
	//	while (n-- > 0)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
  8012e9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012ec:	89 45 fc             	mov    %eax,-0x4(%ebp)
	uint64* d64 = (uint64*)dst;
  8012ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8012f2:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if(n >= 8){
  8012f5:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  8012f9:	76 24                	jbe    80131f <memcpy+0x3c>
		while(n >= 8){
  8012fb:	eb 1c                	jmp    801319 <memcpy+0x36>
			*d64 = *s64;
  8012fd:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801300:	8b 50 04             	mov    0x4(%eax),%edx
  801303:	8b 00                	mov    (%eax),%eax
  801305:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801308:	89 01                	mov    %eax,(%ecx)
  80130a:	89 51 04             	mov    %edx,0x4(%ecx)
			n -= 8;
  80130d:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
			++s64;
  801311:	83 45 fc 08          	addl   $0x8,-0x4(%ebp)
			++d64;
  801315:	83 45 f8 08          	addl   $0x8,-0x8(%ebp)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
	uint64* d64 = (uint64*)dst;
	if(n >= 8){
		while(n >= 8){
  801319:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  80131d:	77 de                	ja     8012fd <memcpy+0x1a>
			++s64;
			++d64;
		}
	}

	if(n){
  80131f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801323:	74 31                	je     801356 <memcpy+0x73>
		uint8* s8 = (uint8*)s64;
  801325:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801328:	89 45 f4             	mov    %eax,-0xc(%ebp)
		uint8* d8 = (uint8*)d64;
  80132b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80132e:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (n-- > 0)
  801331:	eb 16                	jmp    801349 <memcpy+0x66>
			*d8++ = *s8++;
  801333:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801336:	8d 50 01             	lea    0x1(%eax),%edx
  801339:	89 55 f0             	mov    %edx,-0x10(%ebp)
  80133c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80133f:	8d 4a 01             	lea    0x1(%edx),%ecx
  801342:	89 4d f4             	mov    %ecx,-0xc(%ebp)
  801345:	8a 12                	mov    (%edx),%dl
  801347:	88 10                	mov    %dl,(%eax)
	}

	if(n){
		uint8* s8 = (uint8*)s64;
		uint8* d8 = (uint8*)d64;
		while (n-- > 0)
  801349:	8b 45 10             	mov    0x10(%ebp),%eax
  80134c:	8d 50 ff             	lea    -0x1(%eax),%edx
  80134f:	89 55 10             	mov    %edx,0x10(%ebp)
  801352:	85 c0                	test   %eax,%eax
  801354:	75 dd                	jne    801333 <memcpy+0x50>
			*d8++ = *s8++;
	}
	return dst;
  801356:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801359:	c9                   	leave  
  80135a:	c3                   	ret    

0080135b <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  80135b:	55                   	push   %ebp
  80135c:	89 e5                	mov    %esp,%ebp
  80135e:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801361:	8b 45 0c             	mov    0xc(%ebp),%eax
  801364:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801367:	8b 45 08             	mov    0x8(%ebp),%eax
  80136a:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  80136d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801370:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801373:	73 50                	jae    8013c5 <memmove+0x6a>
  801375:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801378:	8b 45 10             	mov    0x10(%ebp),%eax
  80137b:	01 d0                	add    %edx,%eax
  80137d:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801380:	76 43                	jbe    8013c5 <memmove+0x6a>
		s += n;
  801382:	8b 45 10             	mov    0x10(%ebp),%eax
  801385:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  801388:	8b 45 10             	mov    0x10(%ebp),%eax
  80138b:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  80138e:	eb 10                	jmp    8013a0 <memmove+0x45>
			*--d = *--s;
  801390:	ff 4d f8             	decl   -0x8(%ebp)
  801393:	ff 4d fc             	decl   -0x4(%ebp)
  801396:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801399:	8a 10                	mov    (%eax),%dl
  80139b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80139e:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  8013a0:	8b 45 10             	mov    0x10(%ebp),%eax
  8013a3:	8d 50 ff             	lea    -0x1(%eax),%edx
  8013a6:	89 55 10             	mov    %edx,0x10(%ebp)
  8013a9:	85 c0                	test   %eax,%eax
  8013ab:	75 e3                	jne    801390 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  8013ad:	eb 23                	jmp    8013d2 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  8013af:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8013b2:	8d 50 01             	lea    0x1(%eax),%edx
  8013b5:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8013b8:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8013bb:	8d 4a 01             	lea    0x1(%edx),%ecx
  8013be:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  8013c1:	8a 12                	mov    (%edx),%dl
  8013c3:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  8013c5:	8b 45 10             	mov    0x10(%ebp),%eax
  8013c8:	8d 50 ff             	lea    -0x1(%eax),%edx
  8013cb:	89 55 10             	mov    %edx,0x10(%ebp)
  8013ce:	85 c0                	test   %eax,%eax
  8013d0:	75 dd                	jne    8013af <memmove+0x54>
			*d++ = *s++;

	return dst;
  8013d2:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8013d5:	c9                   	leave  
  8013d6:	c3                   	ret    

008013d7 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  8013d7:	55                   	push   %ebp
  8013d8:	89 e5                	mov    %esp,%ebp
  8013da:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  8013dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8013e0:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  8013e3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013e6:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  8013e9:	eb 2a                	jmp    801415 <memcmp+0x3e>
		if (*s1 != *s2)
  8013eb:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8013ee:	8a 10                	mov    (%eax),%dl
  8013f0:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8013f3:	8a 00                	mov    (%eax),%al
  8013f5:	38 c2                	cmp    %al,%dl
  8013f7:	74 16                	je     80140f <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  8013f9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8013fc:	8a 00                	mov    (%eax),%al
  8013fe:	0f b6 d0             	movzbl %al,%edx
  801401:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801404:	8a 00                	mov    (%eax),%al
  801406:	0f b6 c0             	movzbl %al,%eax
  801409:	29 c2                	sub    %eax,%edx
  80140b:	89 d0                	mov    %edx,%eax
  80140d:	eb 18                	jmp    801427 <memcmp+0x50>
		s1++, s2++;
  80140f:	ff 45 fc             	incl   -0x4(%ebp)
  801412:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  801415:	8b 45 10             	mov    0x10(%ebp),%eax
  801418:	8d 50 ff             	lea    -0x1(%eax),%edx
  80141b:	89 55 10             	mov    %edx,0x10(%ebp)
  80141e:	85 c0                	test   %eax,%eax
  801420:	75 c9                	jne    8013eb <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801422:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801427:	c9                   	leave  
  801428:	c3                   	ret    

00801429 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  801429:	55                   	push   %ebp
  80142a:	89 e5                	mov    %esp,%ebp
  80142c:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  80142f:	8b 55 08             	mov    0x8(%ebp),%edx
  801432:	8b 45 10             	mov    0x10(%ebp),%eax
  801435:	01 d0                	add    %edx,%eax
  801437:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  80143a:	eb 15                	jmp    801451 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  80143c:	8b 45 08             	mov    0x8(%ebp),%eax
  80143f:	8a 00                	mov    (%eax),%al
  801441:	0f b6 d0             	movzbl %al,%edx
  801444:	8b 45 0c             	mov    0xc(%ebp),%eax
  801447:	0f b6 c0             	movzbl %al,%eax
  80144a:	39 c2                	cmp    %eax,%edx
  80144c:	74 0d                	je     80145b <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  80144e:	ff 45 08             	incl   0x8(%ebp)
  801451:	8b 45 08             	mov    0x8(%ebp),%eax
  801454:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801457:	72 e3                	jb     80143c <memfind+0x13>
  801459:	eb 01                	jmp    80145c <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  80145b:	90                   	nop
	return (void *) s;
  80145c:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80145f:	c9                   	leave  
  801460:	c3                   	ret    

00801461 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801461:	55                   	push   %ebp
  801462:	89 e5                	mov    %esp,%ebp
  801464:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  801467:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  80146e:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801475:	eb 03                	jmp    80147a <strtol+0x19>
		s++;
  801477:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80147a:	8b 45 08             	mov    0x8(%ebp),%eax
  80147d:	8a 00                	mov    (%eax),%al
  80147f:	3c 20                	cmp    $0x20,%al
  801481:	74 f4                	je     801477 <strtol+0x16>
  801483:	8b 45 08             	mov    0x8(%ebp),%eax
  801486:	8a 00                	mov    (%eax),%al
  801488:	3c 09                	cmp    $0x9,%al
  80148a:	74 eb                	je     801477 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  80148c:	8b 45 08             	mov    0x8(%ebp),%eax
  80148f:	8a 00                	mov    (%eax),%al
  801491:	3c 2b                	cmp    $0x2b,%al
  801493:	75 05                	jne    80149a <strtol+0x39>
		s++;
  801495:	ff 45 08             	incl   0x8(%ebp)
  801498:	eb 13                	jmp    8014ad <strtol+0x4c>
	else if (*s == '-')
  80149a:	8b 45 08             	mov    0x8(%ebp),%eax
  80149d:	8a 00                	mov    (%eax),%al
  80149f:	3c 2d                	cmp    $0x2d,%al
  8014a1:	75 0a                	jne    8014ad <strtol+0x4c>
		s++, neg = 1;
  8014a3:	ff 45 08             	incl   0x8(%ebp)
  8014a6:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8014ad:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8014b1:	74 06                	je     8014b9 <strtol+0x58>
  8014b3:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  8014b7:	75 20                	jne    8014d9 <strtol+0x78>
  8014b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8014bc:	8a 00                	mov    (%eax),%al
  8014be:	3c 30                	cmp    $0x30,%al
  8014c0:	75 17                	jne    8014d9 <strtol+0x78>
  8014c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8014c5:	40                   	inc    %eax
  8014c6:	8a 00                	mov    (%eax),%al
  8014c8:	3c 78                	cmp    $0x78,%al
  8014ca:	75 0d                	jne    8014d9 <strtol+0x78>
		s += 2, base = 16;
  8014cc:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  8014d0:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  8014d7:	eb 28                	jmp    801501 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  8014d9:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8014dd:	75 15                	jne    8014f4 <strtol+0x93>
  8014df:	8b 45 08             	mov    0x8(%ebp),%eax
  8014e2:	8a 00                	mov    (%eax),%al
  8014e4:	3c 30                	cmp    $0x30,%al
  8014e6:	75 0c                	jne    8014f4 <strtol+0x93>
		s++, base = 8;
  8014e8:	ff 45 08             	incl   0x8(%ebp)
  8014eb:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  8014f2:	eb 0d                	jmp    801501 <strtol+0xa0>
	else if (base == 0)
  8014f4:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8014f8:	75 07                	jne    801501 <strtol+0xa0>
		base = 10;
  8014fa:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801501:	8b 45 08             	mov    0x8(%ebp),%eax
  801504:	8a 00                	mov    (%eax),%al
  801506:	3c 2f                	cmp    $0x2f,%al
  801508:	7e 19                	jle    801523 <strtol+0xc2>
  80150a:	8b 45 08             	mov    0x8(%ebp),%eax
  80150d:	8a 00                	mov    (%eax),%al
  80150f:	3c 39                	cmp    $0x39,%al
  801511:	7f 10                	jg     801523 <strtol+0xc2>
			dig = *s - '0';
  801513:	8b 45 08             	mov    0x8(%ebp),%eax
  801516:	8a 00                	mov    (%eax),%al
  801518:	0f be c0             	movsbl %al,%eax
  80151b:	83 e8 30             	sub    $0x30,%eax
  80151e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801521:	eb 42                	jmp    801565 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  801523:	8b 45 08             	mov    0x8(%ebp),%eax
  801526:	8a 00                	mov    (%eax),%al
  801528:	3c 60                	cmp    $0x60,%al
  80152a:	7e 19                	jle    801545 <strtol+0xe4>
  80152c:	8b 45 08             	mov    0x8(%ebp),%eax
  80152f:	8a 00                	mov    (%eax),%al
  801531:	3c 7a                	cmp    $0x7a,%al
  801533:	7f 10                	jg     801545 <strtol+0xe4>
			dig = *s - 'a' + 10;
  801535:	8b 45 08             	mov    0x8(%ebp),%eax
  801538:	8a 00                	mov    (%eax),%al
  80153a:	0f be c0             	movsbl %al,%eax
  80153d:	83 e8 57             	sub    $0x57,%eax
  801540:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801543:	eb 20                	jmp    801565 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  801545:	8b 45 08             	mov    0x8(%ebp),%eax
  801548:	8a 00                	mov    (%eax),%al
  80154a:	3c 40                	cmp    $0x40,%al
  80154c:	7e 39                	jle    801587 <strtol+0x126>
  80154e:	8b 45 08             	mov    0x8(%ebp),%eax
  801551:	8a 00                	mov    (%eax),%al
  801553:	3c 5a                	cmp    $0x5a,%al
  801555:	7f 30                	jg     801587 <strtol+0x126>
			dig = *s - 'A' + 10;
  801557:	8b 45 08             	mov    0x8(%ebp),%eax
  80155a:	8a 00                	mov    (%eax),%al
  80155c:	0f be c0             	movsbl %al,%eax
  80155f:	83 e8 37             	sub    $0x37,%eax
  801562:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  801565:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801568:	3b 45 10             	cmp    0x10(%ebp),%eax
  80156b:	7d 19                	jge    801586 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  80156d:	ff 45 08             	incl   0x8(%ebp)
  801570:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801573:	0f af 45 10          	imul   0x10(%ebp),%eax
  801577:	89 c2                	mov    %eax,%edx
  801579:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80157c:	01 d0                	add    %edx,%eax
  80157e:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  801581:	e9 7b ff ff ff       	jmp    801501 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801586:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801587:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80158b:	74 08                	je     801595 <strtol+0x134>
		*endptr = (char *) s;
  80158d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801590:	8b 55 08             	mov    0x8(%ebp),%edx
  801593:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  801595:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801599:	74 07                	je     8015a2 <strtol+0x141>
  80159b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80159e:	f7 d8                	neg    %eax
  8015a0:	eb 03                	jmp    8015a5 <strtol+0x144>
  8015a2:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8015a5:	c9                   	leave  
  8015a6:	c3                   	ret    

008015a7 <ltostr>:

void
ltostr(long value, char *str)
{
  8015a7:	55                   	push   %ebp
  8015a8:	89 e5                	mov    %esp,%ebp
  8015aa:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  8015ad:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  8015b4:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  8015bb:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8015bf:	79 13                	jns    8015d4 <ltostr+0x2d>
	{
		neg = 1;
  8015c1:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  8015c8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015cb:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  8015ce:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  8015d1:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  8015d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8015d7:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8015dc:	99                   	cltd   
  8015dd:	f7 f9                	idiv   %ecx
  8015df:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  8015e2:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8015e5:	8d 50 01             	lea    0x1(%eax),%edx
  8015e8:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8015eb:	89 c2                	mov    %eax,%edx
  8015ed:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015f0:	01 d0                	add    %edx,%eax
  8015f2:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8015f5:	83 c2 30             	add    $0x30,%edx
  8015f8:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  8015fa:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8015fd:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801602:	f7 e9                	imul   %ecx
  801604:	c1 fa 02             	sar    $0x2,%edx
  801607:	89 c8                	mov    %ecx,%eax
  801609:	c1 f8 1f             	sar    $0x1f,%eax
  80160c:	29 c2                	sub    %eax,%edx
  80160e:	89 d0                	mov    %edx,%eax
  801610:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  801613:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801617:	75 bb                	jne    8015d4 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801619:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801620:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801623:	48                   	dec    %eax
  801624:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801627:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80162b:	74 3d                	je     80166a <ltostr+0xc3>
		start = 1 ;
  80162d:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  801634:	eb 34                	jmp    80166a <ltostr+0xc3>
	{
		char tmp = str[start] ;
  801636:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801639:	8b 45 0c             	mov    0xc(%ebp),%eax
  80163c:	01 d0                	add    %edx,%eax
  80163e:	8a 00                	mov    (%eax),%al
  801640:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801643:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801646:	8b 45 0c             	mov    0xc(%ebp),%eax
  801649:	01 c2                	add    %eax,%edx
  80164b:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  80164e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801651:	01 c8                	add    %ecx,%eax
  801653:	8a 00                	mov    (%eax),%al
  801655:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801657:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80165a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80165d:	01 c2                	add    %eax,%edx
  80165f:	8a 45 eb             	mov    -0x15(%ebp),%al
  801662:	88 02                	mov    %al,(%edx)
		start++ ;
  801664:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801667:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  80166a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80166d:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801670:	7c c4                	jl     801636 <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801672:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801675:	8b 45 0c             	mov    0xc(%ebp),%eax
  801678:	01 d0                	add    %edx,%eax
  80167a:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  80167d:	90                   	nop
  80167e:	c9                   	leave  
  80167f:	c3                   	ret    

00801680 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  801680:	55                   	push   %ebp
  801681:	89 e5                	mov    %esp,%ebp
  801683:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801686:	ff 75 08             	pushl  0x8(%ebp)
  801689:	e8 c4 f9 ff ff       	call   801052 <strlen>
  80168e:	83 c4 04             	add    $0x4,%esp
  801691:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  801694:	ff 75 0c             	pushl  0xc(%ebp)
  801697:	e8 b6 f9 ff ff       	call   801052 <strlen>
  80169c:	83 c4 04             	add    $0x4,%esp
  80169f:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  8016a2:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  8016a9:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8016b0:	eb 17                	jmp    8016c9 <strcconcat+0x49>
		final[s] = str1[s] ;
  8016b2:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8016b5:	8b 45 10             	mov    0x10(%ebp),%eax
  8016b8:	01 c2                	add    %eax,%edx
  8016ba:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8016bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8016c0:	01 c8                	add    %ecx,%eax
  8016c2:	8a 00                	mov    (%eax),%al
  8016c4:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  8016c6:	ff 45 fc             	incl   -0x4(%ebp)
  8016c9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8016cc:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8016cf:	7c e1                	jl     8016b2 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  8016d1:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  8016d8:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8016df:	eb 1f                	jmp    801700 <strcconcat+0x80>
		final[s++] = str2[i] ;
  8016e1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8016e4:	8d 50 01             	lea    0x1(%eax),%edx
  8016e7:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8016ea:	89 c2                	mov    %eax,%edx
  8016ec:	8b 45 10             	mov    0x10(%ebp),%eax
  8016ef:	01 c2                	add    %eax,%edx
  8016f1:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8016f4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016f7:	01 c8                	add    %ecx,%eax
  8016f9:	8a 00                	mov    (%eax),%al
  8016fb:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  8016fd:	ff 45 f8             	incl   -0x8(%ebp)
  801700:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801703:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801706:	7c d9                	jl     8016e1 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801708:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80170b:	8b 45 10             	mov    0x10(%ebp),%eax
  80170e:	01 d0                	add    %edx,%eax
  801710:	c6 00 00             	movb   $0x0,(%eax)
}
  801713:	90                   	nop
  801714:	c9                   	leave  
  801715:	c3                   	ret    

00801716 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801716:	55                   	push   %ebp
  801717:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801719:	8b 45 14             	mov    0x14(%ebp),%eax
  80171c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801722:	8b 45 14             	mov    0x14(%ebp),%eax
  801725:	8b 00                	mov    (%eax),%eax
  801727:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80172e:	8b 45 10             	mov    0x10(%ebp),%eax
  801731:	01 d0                	add    %edx,%eax
  801733:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801739:	eb 0c                	jmp    801747 <strsplit+0x31>
			*string++ = 0;
  80173b:	8b 45 08             	mov    0x8(%ebp),%eax
  80173e:	8d 50 01             	lea    0x1(%eax),%edx
  801741:	89 55 08             	mov    %edx,0x8(%ebp)
  801744:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801747:	8b 45 08             	mov    0x8(%ebp),%eax
  80174a:	8a 00                	mov    (%eax),%al
  80174c:	84 c0                	test   %al,%al
  80174e:	74 18                	je     801768 <strsplit+0x52>
  801750:	8b 45 08             	mov    0x8(%ebp),%eax
  801753:	8a 00                	mov    (%eax),%al
  801755:	0f be c0             	movsbl %al,%eax
  801758:	50                   	push   %eax
  801759:	ff 75 0c             	pushl  0xc(%ebp)
  80175c:	e8 83 fa ff ff       	call   8011e4 <strchr>
  801761:	83 c4 08             	add    $0x8,%esp
  801764:	85 c0                	test   %eax,%eax
  801766:	75 d3                	jne    80173b <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801768:	8b 45 08             	mov    0x8(%ebp),%eax
  80176b:	8a 00                	mov    (%eax),%al
  80176d:	84 c0                	test   %al,%al
  80176f:	74 5a                	je     8017cb <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801771:	8b 45 14             	mov    0x14(%ebp),%eax
  801774:	8b 00                	mov    (%eax),%eax
  801776:	83 f8 0f             	cmp    $0xf,%eax
  801779:	75 07                	jne    801782 <strsplit+0x6c>
		{
			return 0;
  80177b:	b8 00 00 00 00       	mov    $0x0,%eax
  801780:	eb 66                	jmp    8017e8 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801782:	8b 45 14             	mov    0x14(%ebp),%eax
  801785:	8b 00                	mov    (%eax),%eax
  801787:	8d 48 01             	lea    0x1(%eax),%ecx
  80178a:	8b 55 14             	mov    0x14(%ebp),%edx
  80178d:	89 0a                	mov    %ecx,(%edx)
  80178f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801796:	8b 45 10             	mov    0x10(%ebp),%eax
  801799:	01 c2                	add    %eax,%edx
  80179b:	8b 45 08             	mov    0x8(%ebp),%eax
  80179e:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  8017a0:	eb 03                	jmp    8017a5 <strsplit+0x8f>
			string++;
  8017a2:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  8017a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8017a8:	8a 00                	mov    (%eax),%al
  8017aa:	84 c0                	test   %al,%al
  8017ac:	74 8b                	je     801739 <strsplit+0x23>
  8017ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8017b1:	8a 00                	mov    (%eax),%al
  8017b3:	0f be c0             	movsbl %al,%eax
  8017b6:	50                   	push   %eax
  8017b7:	ff 75 0c             	pushl  0xc(%ebp)
  8017ba:	e8 25 fa ff ff       	call   8011e4 <strchr>
  8017bf:	83 c4 08             	add    $0x8,%esp
  8017c2:	85 c0                	test   %eax,%eax
  8017c4:	74 dc                	je     8017a2 <strsplit+0x8c>
			string++;
	}
  8017c6:	e9 6e ff ff ff       	jmp    801739 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  8017cb:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  8017cc:	8b 45 14             	mov    0x14(%ebp),%eax
  8017cf:	8b 00                	mov    (%eax),%eax
  8017d1:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8017d8:	8b 45 10             	mov    0x10(%ebp),%eax
  8017db:	01 d0                	add    %edx,%eax
  8017dd:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  8017e3:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8017e8:	c9                   	leave  
  8017e9:	c3                   	ret    

008017ea <str2lower>:


char* str2lower(char *dst, const char *src)
{
  8017ea:	55                   	push   %ebp
  8017eb:	89 e5                	mov    %esp,%ebp
  8017ed:	83 ec 10             	sub    $0x10,%esp
	char* ret = dst;
  8017f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8017f3:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (int i = 0; i < strlen(src); ++i)
  8017f6:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8017fd:	eb 4a                	jmp    801849 <str2lower+0x5f>
	{
		dst[i] = src[i] ;
  8017ff:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801802:	8b 45 08             	mov    0x8(%ebp),%eax
  801805:	01 c2                	add    %eax,%edx
  801807:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  80180a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80180d:	01 c8                	add    %ecx,%eax
  80180f:	8a 00                	mov    (%eax),%al
  801811:	88 02                	mov    %al,(%edx)
		if (src[i] >= 'A' && src[i] <= 'Z')
  801813:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801816:	8b 45 0c             	mov    0xc(%ebp),%eax
  801819:	01 d0                	add    %edx,%eax
  80181b:	8a 00                	mov    (%eax),%al
  80181d:	3c 40                	cmp    $0x40,%al
  80181f:	7e 25                	jle    801846 <str2lower+0x5c>
  801821:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801824:	8b 45 0c             	mov    0xc(%ebp),%eax
  801827:	01 d0                	add    %edx,%eax
  801829:	8a 00                	mov    (%eax),%al
  80182b:	3c 5a                	cmp    $0x5a,%al
  80182d:	7f 17                	jg     801846 <str2lower+0x5c>
		{
			dst[i] += 32 ;
  80182f:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801832:	8b 45 08             	mov    0x8(%ebp),%eax
  801835:	01 d0                	add    %edx,%eax
  801837:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  80183a:	8b 55 08             	mov    0x8(%ebp),%edx
  80183d:	01 ca                	add    %ecx,%edx
  80183f:	8a 12                	mov    (%edx),%dl
  801841:	83 c2 20             	add    $0x20,%edx
  801844:	88 10                	mov    %dl,(%eax)


char* str2lower(char *dst, const char *src)
{
	char* ret = dst;
	for (int i = 0; i < strlen(src); ++i)
  801846:	ff 45 fc             	incl   -0x4(%ebp)
  801849:	ff 75 0c             	pushl  0xc(%ebp)
  80184c:	e8 01 f8 ff ff       	call   801052 <strlen>
  801851:	83 c4 04             	add    $0x4,%esp
  801854:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801857:	7f a6                	jg     8017ff <str2lower+0x15>
		if (src[i] >= 'A' && src[i] <= 'Z')
		{
			dst[i] += 32 ;
		}
	}
	return ret;
  801859:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  80185c:	c9                   	leave  
  80185d:	c3                   	ret    

0080185e <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  80185e:	55                   	push   %ebp
  80185f:	89 e5                	mov    %esp,%ebp
  801861:	57                   	push   %edi
  801862:	56                   	push   %esi
  801863:	53                   	push   %ebx
  801864:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801867:	8b 45 08             	mov    0x8(%ebp),%eax
  80186a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80186d:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801870:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801873:	8b 7d 18             	mov    0x18(%ebp),%edi
  801876:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801879:	cd 30                	int    $0x30
  80187b:	89 45 f0             	mov    %eax,-0x10(%ebp)
				"b" (a3),
				"D" (a4),
				"S" (a5)
				: "cc", "memory");

	return ret;
  80187e:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801881:	83 c4 10             	add    $0x10,%esp
  801884:	5b                   	pop    %ebx
  801885:	5e                   	pop    %esi
  801886:	5f                   	pop    %edi
  801887:	5d                   	pop    %ebp
  801888:	c3                   	ret    

00801889 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName, int color)
{
  801889:	55                   	push   %ebp
  80188a:	89 e5                	mov    %esp,%ebp
  80188c:	83 ec 04             	sub    $0x4,%esp
  80188f:	8b 45 10             	mov    0x10(%ebp),%eax
  801892:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, color, 0);
  801895:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801898:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80189c:	8b 45 08             	mov    0x8(%ebp),%eax
  80189f:	6a 00                	push   $0x0
  8018a1:	51                   	push   %ecx
  8018a2:	52                   	push   %edx
  8018a3:	ff 75 0c             	pushl  0xc(%ebp)
  8018a6:	50                   	push   %eax
  8018a7:	6a 00                	push   $0x0
  8018a9:	e8 b0 ff ff ff       	call   80185e <syscall>
  8018ae:	83 c4 18             	add    $0x18,%esp
}
  8018b1:	90                   	nop
  8018b2:	c9                   	leave  
  8018b3:	c3                   	ret    

008018b4 <sys_cgetc>:

int
sys_cgetc(void)
{
  8018b4:	55                   	push   %ebp
  8018b5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  8018b7:	6a 00                	push   $0x0
  8018b9:	6a 00                	push   $0x0
  8018bb:	6a 00                	push   $0x0
  8018bd:	6a 00                	push   $0x0
  8018bf:	6a 00                	push   $0x0
  8018c1:	6a 02                	push   $0x2
  8018c3:	e8 96 ff ff ff       	call   80185e <syscall>
  8018c8:	83 c4 18             	add    $0x18,%esp
}
  8018cb:	c9                   	leave  
  8018cc:	c3                   	ret    

008018cd <sys_lock_cons>:

void sys_lock_cons(void)
{
  8018cd:	55                   	push   %ebp
  8018ce:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  8018d0:	6a 00                	push   $0x0
  8018d2:	6a 00                	push   $0x0
  8018d4:	6a 00                	push   $0x0
  8018d6:	6a 00                	push   $0x0
  8018d8:	6a 00                	push   $0x0
  8018da:	6a 03                	push   $0x3
  8018dc:	e8 7d ff ff ff       	call   80185e <syscall>
  8018e1:	83 c4 18             	add    $0x18,%esp
}
  8018e4:	90                   	nop
  8018e5:	c9                   	leave  
  8018e6:	c3                   	ret    

008018e7 <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  8018e7:	55                   	push   %ebp
  8018e8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  8018ea:	6a 00                	push   $0x0
  8018ec:	6a 00                	push   $0x0
  8018ee:	6a 00                	push   $0x0
  8018f0:	6a 00                	push   $0x0
  8018f2:	6a 00                	push   $0x0
  8018f4:	6a 04                	push   $0x4
  8018f6:	e8 63 ff ff ff       	call   80185e <syscall>
  8018fb:	83 c4 18             	add    $0x18,%esp
}
  8018fe:	90                   	nop
  8018ff:	c9                   	leave  
  801900:	c3                   	ret    

00801901 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801901:	55                   	push   %ebp
  801902:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801904:	8b 55 0c             	mov    0xc(%ebp),%edx
  801907:	8b 45 08             	mov    0x8(%ebp),%eax
  80190a:	6a 00                	push   $0x0
  80190c:	6a 00                	push   $0x0
  80190e:	6a 00                	push   $0x0
  801910:	52                   	push   %edx
  801911:	50                   	push   %eax
  801912:	6a 08                	push   $0x8
  801914:	e8 45 ff ff ff       	call   80185e <syscall>
  801919:	83 c4 18             	add    $0x18,%esp
}
  80191c:	c9                   	leave  
  80191d:	c3                   	ret    

0080191e <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  80191e:	55                   	push   %ebp
  80191f:	89 e5                	mov    %esp,%ebp
  801921:	56                   	push   %esi
  801922:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801923:	8b 75 18             	mov    0x18(%ebp),%esi
  801926:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801929:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80192c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80192f:	8b 45 08             	mov    0x8(%ebp),%eax
  801932:	56                   	push   %esi
  801933:	53                   	push   %ebx
  801934:	51                   	push   %ecx
  801935:	52                   	push   %edx
  801936:	50                   	push   %eax
  801937:	6a 09                	push   $0x9
  801939:	e8 20 ff ff ff       	call   80185e <syscall>
  80193e:	83 c4 18             	add    $0x18,%esp
}
  801941:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801944:	5b                   	pop    %ebx
  801945:	5e                   	pop    %esi
  801946:	5d                   	pop    %ebp
  801947:	c3                   	ret    

00801948 <__sys_unmap_frame>:

int __sys_unmap_frame(uint32 va)
{
  801948:	55                   	push   %ebp
  801949:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, va, 0, 0, 0, 0);
  80194b:	6a 00                	push   $0x0
  80194d:	6a 00                	push   $0x0
  80194f:	6a 00                	push   $0x0
  801951:	6a 00                	push   $0x0
  801953:	ff 75 08             	pushl  0x8(%ebp)
  801956:	6a 0a                	push   $0xa
  801958:	e8 01 ff ff ff       	call   80185e <syscall>
  80195d:	83 c4 18             	add    $0x18,%esp
}
  801960:	c9                   	leave  
  801961:	c3                   	ret    

00801962 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801962:	55                   	push   %ebp
  801963:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801965:	6a 00                	push   $0x0
  801967:	6a 00                	push   $0x0
  801969:	6a 00                	push   $0x0
  80196b:	ff 75 0c             	pushl  0xc(%ebp)
  80196e:	ff 75 08             	pushl  0x8(%ebp)
  801971:	6a 0b                	push   $0xb
  801973:	e8 e6 fe ff ff       	call   80185e <syscall>
  801978:	83 c4 18             	add    $0x18,%esp
}
  80197b:	c9                   	leave  
  80197c:	c3                   	ret    

0080197d <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  80197d:	55                   	push   %ebp
  80197e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801980:	6a 00                	push   $0x0
  801982:	6a 00                	push   $0x0
  801984:	6a 00                	push   $0x0
  801986:	6a 00                	push   $0x0
  801988:	6a 00                	push   $0x0
  80198a:	6a 0c                	push   $0xc
  80198c:	e8 cd fe ff ff       	call   80185e <syscall>
  801991:	83 c4 18             	add    $0x18,%esp
}
  801994:	c9                   	leave  
  801995:	c3                   	ret    

00801996 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801996:	55                   	push   %ebp
  801997:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801999:	6a 00                	push   $0x0
  80199b:	6a 00                	push   $0x0
  80199d:	6a 00                	push   $0x0
  80199f:	6a 00                	push   $0x0
  8019a1:	6a 00                	push   $0x0
  8019a3:	6a 0d                	push   $0xd
  8019a5:	e8 b4 fe ff ff       	call   80185e <syscall>
  8019aa:	83 c4 18             	add    $0x18,%esp
}
  8019ad:	c9                   	leave  
  8019ae:	c3                   	ret    

008019af <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  8019af:	55                   	push   %ebp
  8019b0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  8019b2:	6a 00                	push   $0x0
  8019b4:	6a 00                	push   $0x0
  8019b6:	6a 00                	push   $0x0
  8019b8:	6a 00                	push   $0x0
  8019ba:	6a 00                	push   $0x0
  8019bc:	6a 0e                	push   $0xe
  8019be:	e8 9b fe ff ff       	call   80185e <syscall>
  8019c3:	83 c4 18             	add    $0x18,%esp
}
  8019c6:	c9                   	leave  
  8019c7:	c3                   	ret    

008019c8 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  8019c8:	55                   	push   %ebp
  8019c9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  8019cb:	6a 00                	push   $0x0
  8019cd:	6a 00                	push   $0x0
  8019cf:	6a 00                	push   $0x0
  8019d1:	6a 00                	push   $0x0
  8019d3:	6a 00                	push   $0x0
  8019d5:	6a 0f                	push   $0xf
  8019d7:	e8 82 fe ff ff       	call   80185e <syscall>
  8019dc:	83 c4 18             	add    $0x18,%esp
}
  8019df:	c9                   	leave  
  8019e0:	c3                   	ret    

008019e1 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  8019e1:	55                   	push   %ebp
  8019e2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  8019e4:	6a 00                	push   $0x0
  8019e6:	6a 00                	push   $0x0
  8019e8:	6a 00                	push   $0x0
  8019ea:	6a 00                	push   $0x0
  8019ec:	ff 75 08             	pushl  0x8(%ebp)
  8019ef:	6a 10                	push   $0x10
  8019f1:	e8 68 fe ff ff       	call   80185e <syscall>
  8019f6:	83 c4 18             	add    $0x18,%esp
}
  8019f9:	c9                   	leave  
  8019fa:	c3                   	ret    

008019fb <sys_scarce_memory>:

void sys_scarce_memory()
{
  8019fb:	55                   	push   %ebp
  8019fc:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  8019fe:	6a 00                	push   $0x0
  801a00:	6a 00                	push   $0x0
  801a02:	6a 00                	push   $0x0
  801a04:	6a 00                	push   $0x0
  801a06:	6a 00                	push   $0x0
  801a08:	6a 11                	push   $0x11
  801a0a:	e8 4f fe ff ff       	call   80185e <syscall>
  801a0f:	83 c4 18             	add    $0x18,%esp
}
  801a12:	90                   	nop
  801a13:	c9                   	leave  
  801a14:	c3                   	ret    

00801a15 <sys_cputc>:

void
sys_cputc(const char c)
{
  801a15:	55                   	push   %ebp
  801a16:	89 e5                	mov    %esp,%ebp
  801a18:	83 ec 04             	sub    $0x4,%esp
  801a1b:	8b 45 08             	mov    0x8(%ebp),%eax
  801a1e:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801a21:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801a25:	6a 00                	push   $0x0
  801a27:	6a 00                	push   $0x0
  801a29:	6a 00                	push   $0x0
  801a2b:	6a 00                	push   $0x0
  801a2d:	50                   	push   %eax
  801a2e:	6a 01                	push   $0x1
  801a30:	e8 29 fe ff ff       	call   80185e <syscall>
  801a35:	83 c4 18             	add    $0x18,%esp
}
  801a38:	90                   	nop
  801a39:	c9                   	leave  
  801a3a:	c3                   	ret    

00801a3b <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801a3b:	55                   	push   %ebp
  801a3c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801a3e:	6a 00                	push   $0x0
  801a40:	6a 00                	push   $0x0
  801a42:	6a 00                	push   $0x0
  801a44:	6a 00                	push   $0x0
  801a46:	6a 00                	push   $0x0
  801a48:	6a 14                	push   $0x14
  801a4a:	e8 0f fe ff ff       	call   80185e <syscall>
  801a4f:	83 c4 18             	add    $0x18,%esp
}
  801a52:	90                   	nop
  801a53:	c9                   	leave  
  801a54:	c3                   	ret    

00801a55 <sys_create_shared_object>:

int sys_create_shared_object(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801a55:	55                   	push   %ebp
  801a56:	89 e5                	mov    %esp,%ebp
  801a58:	83 ec 04             	sub    $0x4,%esp
  801a5b:	8b 45 10             	mov    0x10(%ebp),%eax
  801a5e:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801a61:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801a64:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801a68:	8b 45 08             	mov    0x8(%ebp),%eax
  801a6b:	6a 00                	push   $0x0
  801a6d:	51                   	push   %ecx
  801a6e:	52                   	push   %edx
  801a6f:	ff 75 0c             	pushl  0xc(%ebp)
  801a72:	50                   	push   %eax
  801a73:	6a 15                	push   $0x15
  801a75:	e8 e4 fd ff ff       	call   80185e <syscall>
  801a7a:	83 c4 18             	add    $0x18,%esp
}
  801a7d:	c9                   	leave  
  801a7e:	c3                   	ret    

00801a7f <sys_size_of_shared_object>:

//2017:
int sys_size_of_shared_object(int32 ownerID, char* shareName)
{
  801a7f:	55                   	push   %ebp
  801a80:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801a82:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a85:	8b 45 08             	mov    0x8(%ebp),%eax
  801a88:	6a 00                	push   $0x0
  801a8a:	6a 00                	push   $0x0
  801a8c:	6a 00                	push   $0x0
  801a8e:	52                   	push   %edx
  801a8f:	50                   	push   %eax
  801a90:	6a 16                	push   $0x16
  801a92:	e8 c7 fd ff ff       	call   80185e <syscall>
  801a97:	83 c4 18             	add    $0x18,%esp
}
  801a9a:	c9                   	leave  
  801a9b:	c3                   	ret    

00801a9c <sys_get_shared_object>:
//==========

int sys_get_shared_object(int32 ownerID, char* shareName, void* virtual_address)
{
  801a9c:	55                   	push   %ebp
  801a9d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801a9f:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801aa2:	8b 55 0c             	mov    0xc(%ebp),%edx
  801aa5:	8b 45 08             	mov    0x8(%ebp),%eax
  801aa8:	6a 00                	push   $0x0
  801aaa:	6a 00                	push   $0x0
  801aac:	51                   	push   %ecx
  801aad:	52                   	push   %edx
  801aae:	50                   	push   %eax
  801aaf:	6a 17                	push   $0x17
  801ab1:	e8 a8 fd ff ff       	call   80185e <syscall>
  801ab6:	83 c4 18             	add    $0x18,%esp
}
  801ab9:	c9                   	leave  
  801aba:	c3                   	ret    

00801abb <sys_delete_shared_object>:

int sys_delete_shared_object(int32 sharedObjectID, void *startVA)
{
  801abb:	55                   	push   %ebp
  801abc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801abe:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ac1:	8b 45 08             	mov    0x8(%ebp),%eax
  801ac4:	6a 00                	push   $0x0
  801ac6:	6a 00                	push   $0x0
  801ac8:	6a 00                	push   $0x0
  801aca:	52                   	push   %edx
  801acb:	50                   	push   %eax
  801acc:	6a 18                	push   $0x18
  801ace:	e8 8b fd ff ff       	call   80185e <syscall>
  801ad3:	83 c4 18             	add    $0x18,%esp
}
  801ad6:	c9                   	leave  
  801ad7:	c3                   	ret    

00801ad8 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801ad8:	55                   	push   %ebp
  801ad9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801adb:	8b 45 08             	mov    0x8(%ebp),%eax
  801ade:	6a 00                	push   $0x0
  801ae0:	ff 75 14             	pushl  0x14(%ebp)
  801ae3:	ff 75 10             	pushl  0x10(%ebp)
  801ae6:	ff 75 0c             	pushl  0xc(%ebp)
  801ae9:	50                   	push   %eax
  801aea:	6a 19                	push   $0x19
  801aec:	e8 6d fd ff ff       	call   80185e <syscall>
  801af1:	83 c4 18             	add    $0x18,%esp
}
  801af4:	c9                   	leave  
  801af5:	c3                   	ret    

00801af6 <sys_run_env>:

void sys_run_env(int32 envId)
{
  801af6:	55                   	push   %ebp
  801af7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801af9:	8b 45 08             	mov    0x8(%ebp),%eax
  801afc:	6a 00                	push   $0x0
  801afe:	6a 00                	push   $0x0
  801b00:	6a 00                	push   $0x0
  801b02:	6a 00                	push   $0x0
  801b04:	50                   	push   %eax
  801b05:	6a 1a                	push   $0x1a
  801b07:	e8 52 fd ff ff       	call   80185e <syscall>
  801b0c:	83 c4 18             	add    $0x18,%esp
}
  801b0f:	90                   	nop
  801b10:	c9                   	leave  
  801b11:	c3                   	ret    

00801b12 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801b12:	55                   	push   %ebp
  801b13:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801b15:	8b 45 08             	mov    0x8(%ebp),%eax
  801b18:	6a 00                	push   $0x0
  801b1a:	6a 00                	push   $0x0
  801b1c:	6a 00                	push   $0x0
  801b1e:	6a 00                	push   $0x0
  801b20:	50                   	push   %eax
  801b21:	6a 1b                	push   $0x1b
  801b23:	e8 36 fd ff ff       	call   80185e <syscall>
  801b28:	83 c4 18             	add    $0x18,%esp
}
  801b2b:	c9                   	leave  
  801b2c:	c3                   	ret    

00801b2d <sys_getenvid>:

int32 sys_getenvid(void)
{
  801b2d:	55                   	push   %ebp
  801b2e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801b30:	6a 00                	push   $0x0
  801b32:	6a 00                	push   $0x0
  801b34:	6a 00                	push   $0x0
  801b36:	6a 00                	push   $0x0
  801b38:	6a 00                	push   $0x0
  801b3a:	6a 05                	push   $0x5
  801b3c:	e8 1d fd ff ff       	call   80185e <syscall>
  801b41:	83 c4 18             	add    $0x18,%esp
}
  801b44:	c9                   	leave  
  801b45:	c3                   	ret    

00801b46 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801b46:	55                   	push   %ebp
  801b47:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801b49:	6a 00                	push   $0x0
  801b4b:	6a 00                	push   $0x0
  801b4d:	6a 00                	push   $0x0
  801b4f:	6a 00                	push   $0x0
  801b51:	6a 00                	push   $0x0
  801b53:	6a 06                	push   $0x6
  801b55:	e8 04 fd ff ff       	call   80185e <syscall>
  801b5a:	83 c4 18             	add    $0x18,%esp
}
  801b5d:	c9                   	leave  
  801b5e:	c3                   	ret    

00801b5f <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801b5f:	55                   	push   %ebp
  801b60:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801b62:	6a 00                	push   $0x0
  801b64:	6a 00                	push   $0x0
  801b66:	6a 00                	push   $0x0
  801b68:	6a 00                	push   $0x0
  801b6a:	6a 00                	push   $0x0
  801b6c:	6a 07                	push   $0x7
  801b6e:	e8 eb fc ff ff       	call   80185e <syscall>
  801b73:	83 c4 18             	add    $0x18,%esp
}
  801b76:	c9                   	leave  
  801b77:	c3                   	ret    

00801b78 <sys_exit_env>:


void sys_exit_env(void)
{
  801b78:	55                   	push   %ebp
  801b79:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801b7b:	6a 00                	push   $0x0
  801b7d:	6a 00                	push   $0x0
  801b7f:	6a 00                	push   $0x0
  801b81:	6a 00                	push   $0x0
  801b83:	6a 00                	push   $0x0
  801b85:	6a 1c                	push   $0x1c
  801b87:	e8 d2 fc ff ff       	call   80185e <syscall>
  801b8c:	83 c4 18             	add    $0x18,%esp
}
  801b8f:	90                   	nop
  801b90:	c9                   	leave  
  801b91:	c3                   	ret    

00801b92 <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  801b92:	55                   	push   %ebp
  801b93:	89 e5                	mov    %esp,%ebp
  801b95:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801b98:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801b9b:	8d 50 04             	lea    0x4(%eax),%edx
  801b9e:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801ba1:	6a 00                	push   $0x0
  801ba3:	6a 00                	push   $0x0
  801ba5:	6a 00                	push   $0x0
  801ba7:	52                   	push   %edx
  801ba8:	50                   	push   %eax
  801ba9:	6a 1d                	push   $0x1d
  801bab:	e8 ae fc ff ff       	call   80185e <syscall>
  801bb0:	83 c4 18             	add    $0x18,%esp
	return result;
  801bb3:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801bb6:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801bb9:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801bbc:	89 01                	mov    %eax,(%ecx)
  801bbe:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801bc1:	8b 45 08             	mov    0x8(%ebp),%eax
  801bc4:	c9                   	leave  
  801bc5:	c2 04 00             	ret    $0x4

00801bc8 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801bc8:	55                   	push   %ebp
  801bc9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801bcb:	6a 00                	push   $0x0
  801bcd:	6a 00                	push   $0x0
  801bcf:	ff 75 10             	pushl  0x10(%ebp)
  801bd2:	ff 75 0c             	pushl  0xc(%ebp)
  801bd5:	ff 75 08             	pushl  0x8(%ebp)
  801bd8:	6a 13                	push   $0x13
  801bda:	e8 7f fc ff ff       	call   80185e <syscall>
  801bdf:	83 c4 18             	add    $0x18,%esp
	return ;
  801be2:	90                   	nop
}
  801be3:	c9                   	leave  
  801be4:	c3                   	ret    

00801be5 <sys_rcr2>:
uint32 sys_rcr2()
{
  801be5:	55                   	push   %ebp
  801be6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801be8:	6a 00                	push   $0x0
  801bea:	6a 00                	push   $0x0
  801bec:	6a 00                	push   $0x0
  801bee:	6a 00                	push   $0x0
  801bf0:	6a 00                	push   $0x0
  801bf2:	6a 1e                	push   $0x1e
  801bf4:	e8 65 fc ff ff       	call   80185e <syscall>
  801bf9:	83 c4 18             	add    $0x18,%esp
}
  801bfc:	c9                   	leave  
  801bfd:	c3                   	ret    

00801bfe <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  801bfe:	55                   	push   %ebp
  801bff:	89 e5                	mov    %esp,%ebp
  801c01:	83 ec 04             	sub    $0x4,%esp
  801c04:	8b 45 08             	mov    0x8(%ebp),%eax
  801c07:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801c0a:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801c0e:	6a 00                	push   $0x0
  801c10:	6a 00                	push   $0x0
  801c12:	6a 00                	push   $0x0
  801c14:	6a 00                	push   $0x0
  801c16:	50                   	push   %eax
  801c17:	6a 1f                	push   $0x1f
  801c19:	e8 40 fc ff ff       	call   80185e <syscall>
  801c1e:	83 c4 18             	add    $0x18,%esp
	return ;
  801c21:	90                   	nop
}
  801c22:	c9                   	leave  
  801c23:	c3                   	ret    

00801c24 <rsttst>:
void rsttst()
{
  801c24:	55                   	push   %ebp
  801c25:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801c27:	6a 00                	push   $0x0
  801c29:	6a 00                	push   $0x0
  801c2b:	6a 00                	push   $0x0
  801c2d:	6a 00                	push   $0x0
  801c2f:	6a 00                	push   $0x0
  801c31:	6a 21                	push   $0x21
  801c33:	e8 26 fc ff ff       	call   80185e <syscall>
  801c38:	83 c4 18             	add    $0x18,%esp
	return ;
  801c3b:	90                   	nop
}
  801c3c:	c9                   	leave  
  801c3d:	c3                   	ret    

00801c3e <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801c3e:	55                   	push   %ebp
  801c3f:	89 e5                	mov    %esp,%ebp
  801c41:	83 ec 04             	sub    $0x4,%esp
  801c44:	8b 45 14             	mov    0x14(%ebp),%eax
  801c47:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801c4a:	8b 55 18             	mov    0x18(%ebp),%edx
  801c4d:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801c51:	52                   	push   %edx
  801c52:	50                   	push   %eax
  801c53:	ff 75 10             	pushl  0x10(%ebp)
  801c56:	ff 75 0c             	pushl  0xc(%ebp)
  801c59:	ff 75 08             	pushl  0x8(%ebp)
  801c5c:	6a 20                	push   $0x20
  801c5e:	e8 fb fb ff ff       	call   80185e <syscall>
  801c63:	83 c4 18             	add    $0x18,%esp
	return ;
  801c66:	90                   	nop
}
  801c67:	c9                   	leave  
  801c68:	c3                   	ret    

00801c69 <chktst>:
void chktst(uint32 n)
{
  801c69:	55                   	push   %ebp
  801c6a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801c6c:	6a 00                	push   $0x0
  801c6e:	6a 00                	push   $0x0
  801c70:	6a 00                	push   $0x0
  801c72:	6a 00                	push   $0x0
  801c74:	ff 75 08             	pushl  0x8(%ebp)
  801c77:	6a 22                	push   $0x22
  801c79:	e8 e0 fb ff ff       	call   80185e <syscall>
  801c7e:	83 c4 18             	add    $0x18,%esp
	return ;
  801c81:	90                   	nop
}
  801c82:	c9                   	leave  
  801c83:	c3                   	ret    

00801c84 <inctst>:

void inctst()
{
  801c84:	55                   	push   %ebp
  801c85:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801c87:	6a 00                	push   $0x0
  801c89:	6a 00                	push   $0x0
  801c8b:	6a 00                	push   $0x0
  801c8d:	6a 00                	push   $0x0
  801c8f:	6a 00                	push   $0x0
  801c91:	6a 23                	push   $0x23
  801c93:	e8 c6 fb ff ff       	call   80185e <syscall>
  801c98:	83 c4 18             	add    $0x18,%esp
	return ;
  801c9b:	90                   	nop
}
  801c9c:	c9                   	leave  
  801c9d:	c3                   	ret    

00801c9e <gettst>:
uint32 gettst()
{
  801c9e:	55                   	push   %ebp
  801c9f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801ca1:	6a 00                	push   $0x0
  801ca3:	6a 00                	push   $0x0
  801ca5:	6a 00                	push   $0x0
  801ca7:	6a 00                	push   $0x0
  801ca9:	6a 00                	push   $0x0
  801cab:	6a 24                	push   $0x24
  801cad:	e8 ac fb ff ff       	call   80185e <syscall>
  801cb2:	83 c4 18             	add    $0x18,%esp
}
  801cb5:	c9                   	leave  
  801cb6:	c3                   	ret    

00801cb7 <sys_get_uheap_strategy>:

/*2025*/
uint32 sys_get_uheap_strategy()
{
  801cb7:	55                   	push   %ebp
  801cb8:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801cba:	6a 00                	push   $0x0
  801cbc:	6a 00                	push   $0x0
  801cbe:	6a 00                	push   $0x0
  801cc0:	6a 00                	push   $0x0
  801cc2:	6a 00                	push   $0x0
  801cc4:	6a 25                	push   $0x25
  801cc6:	e8 93 fb ff ff       	call   80185e <syscall>
  801ccb:	83 c4 18             	add    $0x18,%esp
  801cce:	a3 60 b0 81 00       	mov    %eax,0x81b060
	return uheapPlaceStrategy ;
  801cd3:	a1 60 b0 81 00       	mov    0x81b060,%eax
}
  801cd8:	c9                   	leave  
  801cd9:	c3                   	ret    

00801cda <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801cda:	55                   	push   %ebp
  801cdb:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = heapStrategy;
  801cdd:	8b 45 08             	mov    0x8(%ebp),%eax
  801ce0:	a3 60 b0 81 00       	mov    %eax,0x81b060
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801ce5:	6a 00                	push   $0x0
  801ce7:	6a 00                	push   $0x0
  801ce9:	6a 00                	push   $0x0
  801ceb:	6a 00                	push   $0x0
  801ced:	ff 75 08             	pushl  0x8(%ebp)
  801cf0:	6a 26                	push   $0x26
  801cf2:	e8 67 fb ff ff       	call   80185e <syscall>
  801cf7:	83 c4 18             	add    $0x18,%esp
	return ;
  801cfa:	90                   	nop
}
  801cfb:	c9                   	leave  
  801cfc:	c3                   	ret    

00801cfd <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801cfd:	55                   	push   %ebp
  801cfe:	89 e5                	mov    %esp,%ebp
  801d00:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801d01:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801d04:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801d07:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d0a:	8b 45 08             	mov    0x8(%ebp),%eax
  801d0d:	6a 00                	push   $0x0
  801d0f:	53                   	push   %ebx
  801d10:	51                   	push   %ecx
  801d11:	52                   	push   %edx
  801d12:	50                   	push   %eax
  801d13:	6a 27                	push   $0x27
  801d15:	e8 44 fb ff ff       	call   80185e <syscall>
  801d1a:	83 c4 18             	add    $0x18,%esp
}
  801d1d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801d20:	c9                   	leave  
  801d21:	c3                   	ret    

00801d22 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801d22:	55                   	push   %ebp
  801d23:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801d25:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d28:	8b 45 08             	mov    0x8(%ebp),%eax
  801d2b:	6a 00                	push   $0x0
  801d2d:	6a 00                	push   $0x0
  801d2f:	6a 00                	push   $0x0
  801d31:	52                   	push   %edx
  801d32:	50                   	push   %eax
  801d33:	6a 28                	push   $0x28
  801d35:	e8 24 fb ff ff       	call   80185e <syscall>
  801d3a:	83 c4 18             	add    $0x18,%esp
}
  801d3d:	c9                   	leave  
  801d3e:	c3                   	ret    

00801d3f <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  801d3f:	55                   	push   %ebp
  801d40:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  801d42:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801d45:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d48:	8b 45 08             	mov    0x8(%ebp),%eax
  801d4b:	6a 00                	push   $0x0
  801d4d:	51                   	push   %ecx
  801d4e:	ff 75 10             	pushl  0x10(%ebp)
  801d51:	52                   	push   %edx
  801d52:	50                   	push   %eax
  801d53:	6a 29                	push   $0x29
  801d55:	e8 04 fb ff ff       	call   80185e <syscall>
  801d5a:	83 c4 18             	add    $0x18,%esp
}
  801d5d:	c9                   	leave  
  801d5e:	c3                   	ret    

00801d5f <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801d5f:	55                   	push   %ebp
  801d60:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801d62:	6a 00                	push   $0x0
  801d64:	6a 00                	push   $0x0
  801d66:	ff 75 10             	pushl  0x10(%ebp)
  801d69:	ff 75 0c             	pushl  0xc(%ebp)
  801d6c:	ff 75 08             	pushl  0x8(%ebp)
  801d6f:	6a 12                	push   $0x12
  801d71:	e8 e8 fa ff ff       	call   80185e <syscall>
  801d76:	83 c4 18             	add    $0x18,%esp
	return ;
  801d79:	90                   	nop
}
  801d7a:	c9                   	leave  
  801d7b:	c3                   	ret    

00801d7c <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  801d7c:	55                   	push   %ebp
  801d7d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  801d7f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d82:	8b 45 08             	mov    0x8(%ebp),%eax
  801d85:	6a 00                	push   $0x0
  801d87:	6a 00                	push   $0x0
  801d89:	6a 00                	push   $0x0
  801d8b:	52                   	push   %edx
  801d8c:	50                   	push   %eax
  801d8d:	6a 2a                	push   $0x2a
  801d8f:	e8 ca fa ff ff       	call   80185e <syscall>
  801d94:	83 c4 18             	add    $0x18,%esp
	return;
  801d97:	90                   	nop
}
  801d98:	c9                   	leave  
  801d99:	c3                   	ret    

00801d9a <sys_get_optimal_num_faults>:
/*2025*/
int sys_get_optimal_num_faults()
{
  801d9a:	55                   	push   %ebp
  801d9b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_optimal_num_faults, 0, 0, 0, 0, 0);
  801d9d:	6a 00                	push   $0x0
  801d9f:	6a 00                	push   $0x0
  801da1:	6a 00                	push   $0x0
  801da3:	6a 00                	push   $0x0
  801da5:	6a 00                	push   $0x0
  801da7:	6a 2b                	push   $0x2b
  801da9:	e8 b0 fa ff ff       	call   80185e <syscall>
  801dae:	83 c4 18             	add    $0x18,%esp
}
  801db1:	c9                   	leave  
  801db2:	c3                   	ret    

00801db3 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801db3:	55                   	push   %ebp
  801db4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801db6:	6a 00                	push   $0x0
  801db8:	6a 00                	push   $0x0
  801dba:	6a 00                	push   $0x0
  801dbc:	ff 75 0c             	pushl  0xc(%ebp)
  801dbf:	ff 75 08             	pushl  0x8(%ebp)
  801dc2:	6a 2d                	push   $0x2d
  801dc4:	e8 95 fa ff ff       	call   80185e <syscall>
  801dc9:	83 c4 18             	add    $0x18,%esp
	return;
  801dcc:	90                   	nop
}
  801dcd:	c9                   	leave  
  801dce:	c3                   	ret    

00801dcf <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801dcf:	55                   	push   %ebp
  801dd0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801dd2:	6a 00                	push   $0x0
  801dd4:	6a 00                	push   $0x0
  801dd6:	6a 00                	push   $0x0
  801dd8:	ff 75 0c             	pushl  0xc(%ebp)
  801ddb:	ff 75 08             	pushl  0x8(%ebp)
  801dde:	6a 2c                	push   $0x2c
  801de0:	e8 79 fa ff ff       	call   80185e <syscall>
  801de5:	83 c4 18             	add    $0x18,%esp
	return ;
  801de8:	90                   	nop
}
  801de9:	c9                   	leave  
  801dea:	c3                   	ret    

00801deb <sys_env_set_priority>:


void sys_env_set_priority(int32 envID, int priority)
{
  801deb:	55                   	push   %ebp
  801dec:	89 e5                	mov    %esp,%ebp
  801dee:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.IM#4] CPU SCHEDULING - #1 System Calls - Add suitable code here
	//Your code is here
	//Comment the following line
	panic("sys_env_set_priority() is not implemented yet...!!");
  801df1:	83 ec 04             	sub    $0x4,%esp
  801df4:	68 5c 2a 80 00       	push   $0x802a5c
  801df9:	68 25 01 00 00       	push   $0x125
  801dfe:	68 8f 2a 80 00       	push   $0x802a8f
  801e03:	e8 9b e6 ff ff       	call   8004a3 <_panic>

00801e08 <env_sleep>:
#include <inc/lib.h>
#include <inc/timerreg.h>

void
env_sleep(uint32 approxMilliSeconds)
{
  801e08:	55                   	push   %ebp
  801e09:	89 e5                	mov    %esp,%ebp
  801e0b:	83 ec 30             	sub    $0x30,%esp
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
  801e0e:	8b 55 08             	mov    0x8(%ebp),%edx
  801e11:	89 d0                	mov    %edx,%eax
  801e13:	c1 e0 02             	shl    $0x2,%eax
  801e16:	01 d0                	add    %edx,%eax
  801e18:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801e1f:	01 d0                	add    %edx,%eax
  801e21:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801e28:	01 d0                	add    %edx,%eax
  801e2a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801e31:	01 d0                	add    %edx,%eax
  801e33:	c1 e0 04             	shl    $0x4,%eax
  801e36:	89 45 f8             	mov    %eax,-0x8(%ebp)
	uint32 cycles_counter =0;
  801e39:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)

static inline __attribute__((always_inline)) struct uint64 get_virtual_time_user()
{
	struct uint64 result;

	__asm __volatile("rdtsc\n"
  801e40:	0f 31                	rdtsc  
  801e42:	89 45 e8             	mov    %eax,-0x18(%ebp)
  801e45:	89 55 ec             	mov    %edx,-0x14(%ebp)
	: "=a" (result.low), "=d" (result.hi)
	);

	return result;
  801e48:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801e4b:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801e4e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801e51:	89 55 f4             	mov    %edx,-0xc(%ebp)

	/*2024*/ //USE A USER-SIDE VERSION OF THIS FUNCTION TO AVOID SLOW-DOWN THE PERFORMANCE DUE SYS_CALL (el7 :))
	//struct uint64 baseTime = sys_get_virtual_time() ;
	struct uint64 baseTime = get_virtual_time_user() ;
	while(cycles_counter<time_in_cycles)
  801e54:	eb 46                	jmp    801e9c <env_sleep+0x94>

static inline __attribute__((always_inline)) struct uint64 get_virtual_time_user()
{
	struct uint64 result;

	__asm __volatile("rdtsc\n"
  801e56:	0f 31                	rdtsc  
  801e58:	89 45 d0             	mov    %eax,-0x30(%ebp)
  801e5b:	89 55 d4             	mov    %edx,-0x2c(%ebp)
	: "=a" (result.low), "=d" (result.hi)
	);

	return result;
  801e5e:	8b 45 d0             	mov    -0x30(%ebp),%eax
  801e61:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  801e64:	89 45 e0             	mov    %eax,-0x20(%ebp)
  801e67:	89 55 e4             	mov    %edx,-0x1c(%ebp)

		// update the cycles_count
		#define M32 0xffffffff
		// subtract basetime from current time
		struct uint64 res;
		res.low = (currentTime.low - baseTime.low) & M32;
  801e6a:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801e6d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e70:	29 c2                	sub    %eax,%edx
  801e72:	89 d0                	mov    %edx,%eax
  801e74:	89 45 d8             	mov    %eax,-0x28(%ebp)
		res.hi = (currentTime.hi - baseTime.hi - (res.low > currentTime.low)) & M32;
  801e77:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801e7a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e7d:	89 d1                	mov    %edx,%ecx
  801e7f:	29 c1                	sub    %eax,%ecx
  801e81:	8b 55 d8             	mov    -0x28(%ebp),%edx
  801e84:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801e87:	39 c2                	cmp    %eax,%edx
  801e89:	0f 97 c0             	seta   %al
  801e8c:	0f b6 c0             	movzbl %al,%eax
  801e8f:	29 c1                	sub    %eax,%ecx
  801e91:	89 c8                	mov    %ecx,%eax
  801e93:	89 45 dc             	mov    %eax,-0x24(%ebp)

		//update cycles_count with result
		cycles_counter = res.low;
  801e96:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801e99:	89 45 fc             	mov    %eax,-0x4(%ebp)
	uint32 cycles_counter =0;

	/*2024*/ //USE A USER-SIDE VERSION OF THIS FUNCTION TO AVOID SLOW-DOWN THE PERFORMANCE DUE SYS_CALL (el7 :))
	//struct uint64 baseTime = sys_get_virtual_time() ;
	struct uint64 baseTime = get_virtual_time_user() ;
	while(cycles_counter<time_in_cycles)
  801e9c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801e9f:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801ea2:	72 b2                	jb     801e56 <env_sleep+0x4e>
//				,cycles_counter
//				);
	}
	//cprintf("%s [%d] wake up now!\n", myEnv->prog_name, myEnv->env_id);

}
  801ea4:	90                   	nop
  801ea5:	c9                   	leave  
  801ea6:	c3                   	ret    

00801ea7 <busy_wait>:

//2017
uint32 busy_wait(uint32 loopMax)
{
  801ea7:	55                   	push   %ebp
  801ea8:	89 e5                	mov    %esp,%ebp
  801eaa:	83 ec 10             	sub    $0x10,%esp
	uint32 i = 0 ;
  801ead:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	while (i < loopMax) i++;
  801eb4:	eb 03                	jmp    801eb9 <busy_wait+0x12>
  801eb6:	ff 45 fc             	incl   -0x4(%ebp)
  801eb9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801ebc:	3b 45 08             	cmp    0x8(%ebp),%eax
  801ebf:	72 f5                	jb     801eb6 <busy_wait+0xf>
	return i;
  801ec1:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801ec4:	c9                   	leave  
  801ec5:	c3                   	ret    

00801ec6 <cputchar>:
#include <inc/lib.h>


void
cputchar(int ch)
{
  801ec6:	55                   	push   %ebp
  801ec7:	89 e5                	mov    %esp,%ebp
  801ec9:	83 ec 18             	sub    $0x18,%esp
	char c = ch;
  801ecc:	8b 45 08             	mov    0x8(%ebp),%eax
  801ecf:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	//sys_cputs(&c, 1);

	sys_cputc(c);
  801ed2:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  801ed6:	83 ec 0c             	sub    $0xc,%esp
  801ed9:	50                   	push   %eax
  801eda:	e8 36 fb ff ff       	call   801a15 <sys_cputc>
  801edf:	83 c4 10             	add    $0x10,%esp
}
  801ee2:	90                   	nop
  801ee3:	c9                   	leave  
  801ee4:	c3                   	ret    

00801ee5 <getchar>:


int
getchar(void)
{
  801ee5:	55                   	push   %ebp
  801ee6:	89 e5                	mov    %esp,%ebp
  801ee8:	83 ec 18             	sub    $0x18,%esp
	int c =sys_cgetc();
  801eeb:	e8 c4 f9 ff ff       	call   8018b4 <sys_cgetc>
  801ef0:	89 45 f4             	mov    %eax,-0xc(%ebp)
	return c;
  801ef3:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  801ef6:	c9                   	leave  
  801ef7:	c3                   	ret    

00801ef8 <iscons>:

int iscons(int fdnum)
{
  801ef8:	55                   	push   %ebp
  801ef9:	89 e5                	mov    %esp,%ebp
	// used by readline
	return 1;
  801efb:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801f00:	5d                   	pop    %ebp
  801f01:	c3                   	ret    
  801f02:	66 90                	xchg   %ax,%ax

00801f04 <__udivdi3>:
  801f04:	55                   	push   %ebp
  801f05:	57                   	push   %edi
  801f06:	56                   	push   %esi
  801f07:	53                   	push   %ebx
  801f08:	83 ec 1c             	sub    $0x1c,%esp
  801f0b:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  801f0f:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  801f13:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801f17:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801f1b:	89 ca                	mov    %ecx,%edx
  801f1d:	89 f8                	mov    %edi,%eax
  801f1f:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  801f23:	85 f6                	test   %esi,%esi
  801f25:	75 2d                	jne    801f54 <__udivdi3+0x50>
  801f27:	39 cf                	cmp    %ecx,%edi
  801f29:	77 65                	ja     801f90 <__udivdi3+0x8c>
  801f2b:	89 fd                	mov    %edi,%ebp
  801f2d:	85 ff                	test   %edi,%edi
  801f2f:	75 0b                	jne    801f3c <__udivdi3+0x38>
  801f31:	b8 01 00 00 00       	mov    $0x1,%eax
  801f36:	31 d2                	xor    %edx,%edx
  801f38:	f7 f7                	div    %edi
  801f3a:	89 c5                	mov    %eax,%ebp
  801f3c:	31 d2                	xor    %edx,%edx
  801f3e:	89 c8                	mov    %ecx,%eax
  801f40:	f7 f5                	div    %ebp
  801f42:	89 c1                	mov    %eax,%ecx
  801f44:	89 d8                	mov    %ebx,%eax
  801f46:	f7 f5                	div    %ebp
  801f48:	89 cf                	mov    %ecx,%edi
  801f4a:	89 fa                	mov    %edi,%edx
  801f4c:	83 c4 1c             	add    $0x1c,%esp
  801f4f:	5b                   	pop    %ebx
  801f50:	5e                   	pop    %esi
  801f51:	5f                   	pop    %edi
  801f52:	5d                   	pop    %ebp
  801f53:	c3                   	ret    
  801f54:	39 ce                	cmp    %ecx,%esi
  801f56:	77 28                	ja     801f80 <__udivdi3+0x7c>
  801f58:	0f bd fe             	bsr    %esi,%edi
  801f5b:	83 f7 1f             	xor    $0x1f,%edi
  801f5e:	75 40                	jne    801fa0 <__udivdi3+0x9c>
  801f60:	39 ce                	cmp    %ecx,%esi
  801f62:	72 0a                	jb     801f6e <__udivdi3+0x6a>
  801f64:	3b 44 24 08          	cmp    0x8(%esp),%eax
  801f68:	0f 87 9e 00 00 00    	ja     80200c <__udivdi3+0x108>
  801f6e:	b8 01 00 00 00       	mov    $0x1,%eax
  801f73:	89 fa                	mov    %edi,%edx
  801f75:	83 c4 1c             	add    $0x1c,%esp
  801f78:	5b                   	pop    %ebx
  801f79:	5e                   	pop    %esi
  801f7a:	5f                   	pop    %edi
  801f7b:	5d                   	pop    %ebp
  801f7c:	c3                   	ret    
  801f7d:	8d 76 00             	lea    0x0(%esi),%esi
  801f80:	31 ff                	xor    %edi,%edi
  801f82:	31 c0                	xor    %eax,%eax
  801f84:	89 fa                	mov    %edi,%edx
  801f86:	83 c4 1c             	add    $0x1c,%esp
  801f89:	5b                   	pop    %ebx
  801f8a:	5e                   	pop    %esi
  801f8b:	5f                   	pop    %edi
  801f8c:	5d                   	pop    %ebp
  801f8d:	c3                   	ret    
  801f8e:	66 90                	xchg   %ax,%ax
  801f90:	89 d8                	mov    %ebx,%eax
  801f92:	f7 f7                	div    %edi
  801f94:	31 ff                	xor    %edi,%edi
  801f96:	89 fa                	mov    %edi,%edx
  801f98:	83 c4 1c             	add    $0x1c,%esp
  801f9b:	5b                   	pop    %ebx
  801f9c:	5e                   	pop    %esi
  801f9d:	5f                   	pop    %edi
  801f9e:	5d                   	pop    %ebp
  801f9f:	c3                   	ret    
  801fa0:	bd 20 00 00 00       	mov    $0x20,%ebp
  801fa5:	89 eb                	mov    %ebp,%ebx
  801fa7:	29 fb                	sub    %edi,%ebx
  801fa9:	89 f9                	mov    %edi,%ecx
  801fab:	d3 e6                	shl    %cl,%esi
  801fad:	89 c5                	mov    %eax,%ebp
  801faf:	88 d9                	mov    %bl,%cl
  801fb1:	d3 ed                	shr    %cl,%ebp
  801fb3:	89 e9                	mov    %ebp,%ecx
  801fb5:	09 f1                	or     %esi,%ecx
  801fb7:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  801fbb:	89 f9                	mov    %edi,%ecx
  801fbd:	d3 e0                	shl    %cl,%eax
  801fbf:	89 c5                	mov    %eax,%ebp
  801fc1:	89 d6                	mov    %edx,%esi
  801fc3:	88 d9                	mov    %bl,%cl
  801fc5:	d3 ee                	shr    %cl,%esi
  801fc7:	89 f9                	mov    %edi,%ecx
  801fc9:	d3 e2                	shl    %cl,%edx
  801fcb:	8b 44 24 08          	mov    0x8(%esp),%eax
  801fcf:	88 d9                	mov    %bl,%cl
  801fd1:	d3 e8                	shr    %cl,%eax
  801fd3:	09 c2                	or     %eax,%edx
  801fd5:	89 d0                	mov    %edx,%eax
  801fd7:	89 f2                	mov    %esi,%edx
  801fd9:	f7 74 24 0c          	divl   0xc(%esp)
  801fdd:	89 d6                	mov    %edx,%esi
  801fdf:	89 c3                	mov    %eax,%ebx
  801fe1:	f7 e5                	mul    %ebp
  801fe3:	39 d6                	cmp    %edx,%esi
  801fe5:	72 19                	jb     802000 <__udivdi3+0xfc>
  801fe7:	74 0b                	je     801ff4 <__udivdi3+0xf0>
  801fe9:	89 d8                	mov    %ebx,%eax
  801feb:	31 ff                	xor    %edi,%edi
  801fed:	e9 58 ff ff ff       	jmp    801f4a <__udivdi3+0x46>
  801ff2:	66 90                	xchg   %ax,%ax
  801ff4:	8b 54 24 08          	mov    0x8(%esp),%edx
  801ff8:	89 f9                	mov    %edi,%ecx
  801ffa:	d3 e2                	shl    %cl,%edx
  801ffc:	39 c2                	cmp    %eax,%edx
  801ffe:	73 e9                	jae    801fe9 <__udivdi3+0xe5>
  802000:	8d 43 ff             	lea    -0x1(%ebx),%eax
  802003:	31 ff                	xor    %edi,%edi
  802005:	e9 40 ff ff ff       	jmp    801f4a <__udivdi3+0x46>
  80200a:	66 90                	xchg   %ax,%ax
  80200c:	31 c0                	xor    %eax,%eax
  80200e:	e9 37 ff ff ff       	jmp    801f4a <__udivdi3+0x46>
  802013:	90                   	nop

00802014 <__umoddi3>:
  802014:	55                   	push   %ebp
  802015:	57                   	push   %edi
  802016:	56                   	push   %esi
  802017:	53                   	push   %ebx
  802018:	83 ec 1c             	sub    $0x1c,%esp
  80201b:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  80201f:	8b 74 24 34          	mov    0x34(%esp),%esi
  802023:	8b 7c 24 38          	mov    0x38(%esp),%edi
  802027:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80202b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80202f:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802033:	89 f3                	mov    %esi,%ebx
  802035:	89 fa                	mov    %edi,%edx
  802037:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80203b:	89 34 24             	mov    %esi,(%esp)
  80203e:	85 c0                	test   %eax,%eax
  802040:	75 1a                	jne    80205c <__umoddi3+0x48>
  802042:	39 f7                	cmp    %esi,%edi
  802044:	0f 86 a2 00 00 00    	jbe    8020ec <__umoddi3+0xd8>
  80204a:	89 c8                	mov    %ecx,%eax
  80204c:	89 f2                	mov    %esi,%edx
  80204e:	f7 f7                	div    %edi
  802050:	89 d0                	mov    %edx,%eax
  802052:	31 d2                	xor    %edx,%edx
  802054:	83 c4 1c             	add    $0x1c,%esp
  802057:	5b                   	pop    %ebx
  802058:	5e                   	pop    %esi
  802059:	5f                   	pop    %edi
  80205a:	5d                   	pop    %ebp
  80205b:	c3                   	ret    
  80205c:	39 f0                	cmp    %esi,%eax
  80205e:	0f 87 ac 00 00 00    	ja     802110 <__umoddi3+0xfc>
  802064:	0f bd e8             	bsr    %eax,%ebp
  802067:	83 f5 1f             	xor    $0x1f,%ebp
  80206a:	0f 84 ac 00 00 00    	je     80211c <__umoddi3+0x108>
  802070:	bf 20 00 00 00       	mov    $0x20,%edi
  802075:	29 ef                	sub    %ebp,%edi
  802077:	89 fe                	mov    %edi,%esi
  802079:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80207d:	89 e9                	mov    %ebp,%ecx
  80207f:	d3 e0                	shl    %cl,%eax
  802081:	89 d7                	mov    %edx,%edi
  802083:	89 f1                	mov    %esi,%ecx
  802085:	d3 ef                	shr    %cl,%edi
  802087:	09 c7                	or     %eax,%edi
  802089:	89 e9                	mov    %ebp,%ecx
  80208b:	d3 e2                	shl    %cl,%edx
  80208d:	89 14 24             	mov    %edx,(%esp)
  802090:	89 d8                	mov    %ebx,%eax
  802092:	d3 e0                	shl    %cl,%eax
  802094:	89 c2                	mov    %eax,%edx
  802096:	8b 44 24 08          	mov    0x8(%esp),%eax
  80209a:	d3 e0                	shl    %cl,%eax
  80209c:	89 44 24 04          	mov    %eax,0x4(%esp)
  8020a0:	8b 44 24 08          	mov    0x8(%esp),%eax
  8020a4:	89 f1                	mov    %esi,%ecx
  8020a6:	d3 e8                	shr    %cl,%eax
  8020a8:	09 d0                	or     %edx,%eax
  8020aa:	d3 eb                	shr    %cl,%ebx
  8020ac:	89 da                	mov    %ebx,%edx
  8020ae:	f7 f7                	div    %edi
  8020b0:	89 d3                	mov    %edx,%ebx
  8020b2:	f7 24 24             	mull   (%esp)
  8020b5:	89 c6                	mov    %eax,%esi
  8020b7:	89 d1                	mov    %edx,%ecx
  8020b9:	39 d3                	cmp    %edx,%ebx
  8020bb:	0f 82 87 00 00 00    	jb     802148 <__umoddi3+0x134>
  8020c1:	0f 84 91 00 00 00    	je     802158 <__umoddi3+0x144>
  8020c7:	8b 54 24 04          	mov    0x4(%esp),%edx
  8020cb:	29 f2                	sub    %esi,%edx
  8020cd:	19 cb                	sbb    %ecx,%ebx
  8020cf:	89 d8                	mov    %ebx,%eax
  8020d1:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  8020d5:	d3 e0                	shl    %cl,%eax
  8020d7:	89 e9                	mov    %ebp,%ecx
  8020d9:	d3 ea                	shr    %cl,%edx
  8020db:	09 d0                	or     %edx,%eax
  8020dd:	89 e9                	mov    %ebp,%ecx
  8020df:	d3 eb                	shr    %cl,%ebx
  8020e1:	89 da                	mov    %ebx,%edx
  8020e3:	83 c4 1c             	add    $0x1c,%esp
  8020e6:	5b                   	pop    %ebx
  8020e7:	5e                   	pop    %esi
  8020e8:	5f                   	pop    %edi
  8020e9:	5d                   	pop    %ebp
  8020ea:	c3                   	ret    
  8020eb:	90                   	nop
  8020ec:	89 fd                	mov    %edi,%ebp
  8020ee:	85 ff                	test   %edi,%edi
  8020f0:	75 0b                	jne    8020fd <__umoddi3+0xe9>
  8020f2:	b8 01 00 00 00       	mov    $0x1,%eax
  8020f7:	31 d2                	xor    %edx,%edx
  8020f9:	f7 f7                	div    %edi
  8020fb:	89 c5                	mov    %eax,%ebp
  8020fd:	89 f0                	mov    %esi,%eax
  8020ff:	31 d2                	xor    %edx,%edx
  802101:	f7 f5                	div    %ebp
  802103:	89 c8                	mov    %ecx,%eax
  802105:	f7 f5                	div    %ebp
  802107:	89 d0                	mov    %edx,%eax
  802109:	e9 44 ff ff ff       	jmp    802052 <__umoddi3+0x3e>
  80210e:	66 90                	xchg   %ax,%ax
  802110:	89 c8                	mov    %ecx,%eax
  802112:	89 f2                	mov    %esi,%edx
  802114:	83 c4 1c             	add    $0x1c,%esp
  802117:	5b                   	pop    %ebx
  802118:	5e                   	pop    %esi
  802119:	5f                   	pop    %edi
  80211a:	5d                   	pop    %ebp
  80211b:	c3                   	ret    
  80211c:	3b 04 24             	cmp    (%esp),%eax
  80211f:	72 06                	jb     802127 <__umoddi3+0x113>
  802121:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  802125:	77 0f                	ja     802136 <__umoddi3+0x122>
  802127:	89 f2                	mov    %esi,%edx
  802129:	29 f9                	sub    %edi,%ecx
  80212b:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  80212f:	89 14 24             	mov    %edx,(%esp)
  802132:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  802136:	8b 44 24 04          	mov    0x4(%esp),%eax
  80213a:	8b 14 24             	mov    (%esp),%edx
  80213d:	83 c4 1c             	add    $0x1c,%esp
  802140:	5b                   	pop    %ebx
  802141:	5e                   	pop    %esi
  802142:	5f                   	pop    %edi
  802143:	5d                   	pop    %ebp
  802144:	c3                   	ret    
  802145:	8d 76 00             	lea    0x0(%esi),%esi
  802148:	2b 04 24             	sub    (%esp),%eax
  80214b:	19 fa                	sbb    %edi,%edx
  80214d:	89 d1                	mov    %edx,%ecx
  80214f:	89 c6                	mov    %eax,%esi
  802151:	e9 71 ff ff ff       	jmp    8020c7 <__umoddi3+0xb3>
  802156:	66 90                	xchg   %ax,%ax
  802158:	39 44 24 04          	cmp    %eax,0x4(%esp)
  80215c:	72 ea                	jb     802148 <__umoddi3+0x134>
  80215e:	89 d9                	mov    %ebx,%ecx
  802160:	e9 62 ff ff ff       	jmp    8020c7 <__umoddi3+0xb3>
