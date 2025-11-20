
obj/user/tst_sleeplock_slave:     file format elf32-i386


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
  800031:	e8 46 02 00 00       	call   80027c <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
#include <inc/lib.h>
extern volatile bool printStats ;

void
_main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	57                   	push   %edi
  80003c:	56                   	push   %esi
  80003d:	53                   	push   %ebx
  80003e:	81 ec 6c 01 00 00    	sub    $0x16c,%esp
	int envID = sys_getenvid();
  800044:	e8 65 18 00 00       	call   8018ae <sys_getenvid>
  800049:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	//Acquire the lock
	char cmd1[64] = "__AcquireSleepLock__";
  80004c:	8d 45 98             	lea    -0x68(%ebp),%eax
  80004f:	bb b0 1f 80 00       	mov    $0x801fb0,%ebx
  800054:	ba 15 00 00 00       	mov    $0x15,%edx
  800059:	89 c7                	mov    %eax,%edi
  80005b:	89 de                	mov    %ebx,%esi
  80005d:	89 d1                	mov    %edx,%ecx
  80005f:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  800061:	8d 55 ad             	lea    -0x53(%ebp),%edx
  800064:	b9 2b 00 00 00       	mov    $0x2b,%ecx
  800069:	b0 00                	mov    $0x0,%al
  80006b:	89 d7                	mov    %edx,%edi
  80006d:	f3 aa                	rep stos %al,%es:(%edi)
	sys_utilities(cmd1, 0);
  80006f:	83 ec 08             	sub    $0x8,%esp
  800072:	6a 00                	push   $0x0
  800074:	8d 45 98             	lea    -0x68(%ebp),%eax
  800077:	50                   	push   %eax
  800078:	e8 80 1a 00 00       	call   801afd <sys_utilities>
  80007d:	83 c4 10             	add    $0x10,%esp
	{
		if (gettst() > 1)
  800080:	e8 9a 19 00 00       	call   801a1f <gettst>
  800085:	83 f8 01             	cmp    $0x1,%eax
  800088:	76 33                	jbe    8000bd <_main+0x85>
		{
			//Other slaves: wait for a while
			env_sleep(RAND(5000, 10000));
  80008a:	8d 45 d8             	lea    -0x28(%ebp),%eax
  80008d:	83 ec 0c             	sub    $0xc,%esp
  800090:	50                   	push   %eax
  800091:	e8 7d 18 00 00       	call   801913 <sys_get_virtual_time>
  800096:	83 c4 0c             	add    $0xc,%esp
  800099:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80009c:	b9 88 13 00 00       	mov    $0x1388,%ecx
  8000a1:	ba 00 00 00 00       	mov    $0x0,%edx
  8000a6:	f7 f1                	div    %ecx
  8000a8:	89 d0                	mov    %edx,%eax
  8000aa:	05 88 13 00 00       	add    $0x1388,%eax
  8000af:	83 ec 0c             	sub    $0xc,%esp
  8000b2:	50                   	push   %eax
  8000b3:	e8 d1 1a 00 00       	call   801b89 <env_sleep>
  8000b8:	83 c4 10             	add    $0x10,%esp
  8000bb:	eb 0b                	jmp    8000c8 <_main+0x90>
		}
		else
		{
			//this is the first slave inside C.S.! so wait until receiving signal from master
			while (gettst() != 1);
  8000bd:	90                   	nop
  8000be:	e8 5c 19 00 00       	call   801a1f <gettst>
  8000c3:	83 f8 01             	cmp    $0x1,%eax
  8000c6:	75 f6                	jne    8000be <_main+0x86>
		}

		//Check lock value inside C.S.
		int lockVal = 0;
  8000c8:	c7 85 54 ff ff ff 00 	movl   $0x0,-0xac(%ebp)
  8000cf:	00 00 00 
		char cmd2[64] = "__GetLockValue__";
  8000d2:	8d 85 8c fe ff ff    	lea    -0x174(%ebp),%eax
  8000d8:	bb f0 1f 80 00       	mov    $0x801ff0,%ebx
  8000dd:	ba 11 00 00 00       	mov    $0x11,%edx
  8000e2:	89 c7                	mov    %eax,%edi
  8000e4:	89 de                	mov    %ebx,%esi
  8000e6:	89 d1                	mov    %edx,%ecx
  8000e8:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  8000ea:	8d 95 9d fe ff ff    	lea    -0x163(%ebp),%edx
  8000f0:	b9 2f 00 00 00       	mov    $0x2f,%ecx
  8000f5:	b0 00                	mov    $0x0,%al
  8000f7:	89 d7                	mov    %edx,%edi
  8000f9:	f3 aa                	rep stos %al,%es:(%edi)
		sys_utilities(cmd2, (int)(&lockVal));
  8000fb:	8d 85 54 ff ff ff    	lea    -0xac(%ebp),%eax
  800101:	83 ec 08             	sub    $0x8,%esp
  800104:	50                   	push   %eax
  800105:	8d 85 8c fe ff ff    	lea    -0x174(%ebp),%eax
  80010b:	50                   	push   %eax
  80010c:	e8 ec 19 00 00       	call   801afd <sys_utilities>
  800111:	83 c4 10             	add    $0x10,%esp
		if (lockVal != 1)
  800114:	8b 85 54 ff ff ff    	mov    -0xac(%ebp),%eax
  80011a:	83 f8 01             	cmp    $0x1,%eax
  80011d:	74 14                	je     800133 <_main+0xfb>
		{
			panic("%~test sleeplock failed! lock is not held while it's expected to be");
  80011f:	83 ec 04             	sub    $0x4,%esp
  800122:	68 c0 1e 80 00       	push   $0x801ec0
  800127:	6a 20                	push   $0x20
  800129:	68 04 1f 80 00       	push   $0x801f04
  80012e:	e8 f9 02 00 00       	call   80042c <_panic>
		}

		//Validate the number of blocked processes till now
		int numOfBlockedProcesses = 0;
  800133:	c7 85 50 ff ff ff 00 	movl   $0x0,-0xb0(%ebp)
  80013a:	00 00 00 
		char cmd3[64] = "__GetLockQueueSize__";
  80013d:	8d 85 cc fe ff ff    	lea    -0x134(%ebp),%eax
  800143:	bb 30 20 80 00       	mov    $0x802030,%ebx
  800148:	ba 15 00 00 00       	mov    $0x15,%edx
  80014d:	89 c7                	mov    %eax,%edi
  80014f:	89 de                	mov    %ebx,%esi
  800151:	89 d1                	mov    %edx,%ecx
  800153:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  800155:	8d 95 e1 fe ff ff    	lea    -0x11f(%ebp),%edx
  80015b:	b9 2b 00 00 00       	mov    $0x2b,%ecx
  800160:	b0 00                	mov    $0x0,%al
  800162:	89 d7                	mov    %edx,%edi
  800164:	f3 aa                	rep stos %al,%es:(%edi)
		sys_utilities(cmd3, (uint32)(&numOfBlockedProcesses));
  800166:	8d 85 50 ff ff ff    	lea    -0xb0(%ebp),%eax
  80016c:	83 ec 08             	sub    $0x8,%esp
  80016f:	50                   	push   %eax
  800170:	8d 85 cc fe ff ff    	lea    -0x134(%ebp),%eax
  800176:	50                   	push   %eax
  800177:	e8 81 19 00 00       	call   801afd <sys_utilities>
  80017c:	83 c4 10             	add    $0x10,%esp
		int numOfFinishedProcesses = gettst() -1 /*since master already incremented it by 1*/;
  80017f:	e8 9b 18 00 00       	call   801a1f <gettst>
  800184:	48                   	dec    %eax
  800185:	89 45 e0             	mov    %eax,-0x20(%ebp)
		int numOfSlaves = 0;
  800188:	c7 85 4c ff ff ff 00 	movl   $0x0,-0xb4(%ebp)
  80018f:	00 00 00 
		char cmd4[64] = "__NumOfSlaves@Get";
  800192:	8d 85 0c ff ff ff    	lea    -0xf4(%ebp),%eax
  800198:	bb 70 20 80 00       	mov    $0x802070,%ebx
  80019d:	ba 12 00 00 00       	mov    $0x12,%edx
  8001a2:	89 c7                	mov    %eax,%edi
  8001a4:	89 de                	mov    %ebx,%esi
  8001a6:	89 d1                	mov    %edx,%ecx
  8001a8:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  8001aa:	8d 95 1e ff ff ff    	lea    -0xe2(%ebp),%edx
  8001b0:	b9 2e 00 00 00       	mov    $0x2e,%ecx
  8001b5:	b0 00                	mov    $0x0,%al
  8001b7:	89 d7                	mov    %edx,%edi
  8001b9:	f3 aa                	rep stos %al,%es:(%edi)
		sys_utilities(cmd4, (uint32)(&numOfSlaves));
  8001bb:	8d 85 4c ff ff ff    	lea    -0xb4(%ebp),%eax
  8001c1:	83 ec 08             	sub    $0x8,%esp
  8001c4:	50                   	push   %eax
  8001c5:	8d 85 0c ff ff ff    	lea    -0xf4(%ebp),%eax
  8001cb:	50                   	push   %eax
  8001cc:	e8 2c 19 00 00       	call   801afd <sys_utilities>
  8001d1:	83 c4 10             	add    $0x10,%esp

		if (numOfFinishedProcesses + numOfBlockedProcesses != numOfSlaves - 1)
  8001d4:	8b 95 50 ff ff ff    	mov    -0xb0(%ebp),%edx
  8001da:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8001dd:	01 c2                	add    %eax,%edx
  8001df:	8b 85 4c ff ff ff    	mov    -0xb4(%ebp),%eax
  8001e5:	48                   	dec    %eax
  8001e6:	39 c2                	cmp    %eax,%edx
  8001e8:	74 28                	je     800212 <_main+0x1da>
		{
			panic("%~test SleepLock failed! inconsistent number of blocked & waken-up processes. #wakenup %d + #blocked %d != #slaves %d", numOfFinishedProcesses, numOfBlockedProcesses, numOfSlaves-1);
  8001ea:	8b 85 4c ff ff ff    	mov    -0xb4(%ebp),%eax
  8001f0:	8d 50 ff             	lea    -0x1(%eax),%edx
  8001f3:	8b 85 50 ff ff ff    	mov    -0xb0(%ebp),%eax
  8001f9:	83 ec 08             	sub    $0x8,%esp
  8001fc:	52                   	push   %edx
  8001fd:	50                   	push   %eax
  8001fe:	ff 75 e0             	pushl  -0x20(%ebp)
  800201:	68 20 1f 80 00       	push   $0x801f20
  800206:	6a 2e                	push   $0x2e
  800208:	68 04 1f 80 00       	push   $0x801f04
  80020d:	e8 1a 02 00 00       	call   80042c <_panic>
		}

		//indicates finishing
		inctst();
  800212:	e8 ee 17 00 00       	call   801a05 <inctst>
	}
	//Release the lock
	char cmd5[64] = "__ReleaseSleepLock__";
  800217:	8d 85 58 ff ff ff    	lea    -0xa8(%ebp),%eax
  80021d:	bb b0 20 80 00       	mov    $0x8020b0,%ebx
  800222:	ba 15 00 00 00       	mov    $0x15,%edx
  800227:	89 c7                	mov    %eax,%edi
  800229:	89 de                	mov    %ebx,%esi
  80022b:	89 d1                	mov    %edx,%ecx
  80022d:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  80022f:	8d 95 6d ff ff ff    	lea    -0x93(%ebp),%edx
  800235:	b9 2b 00 00 00       	mov    $0x2b,%ecx
  80023a:	b0 00                	mov    $0x0,%al
  80023c:	89 d7                	mov    %edx,%edi
  80023e:	f3 aa                	rep stos %al,%es:(%edi)
	sys_utilities(cmd5, 0);
  800240:	83 ec 08             	sub    $0x8,%esp
  800243:	6a 00                	push   $0x0
  800245:	8d 85 58 ff ff ff    	lea    -0xa8(%ebp),%eax
  80024b:	50                   	push   %eax
  80024c:	e8 ac 18 00 00       	call   801afd <sys_utilities>
  800251:	83 c4 10             	add    $0x10,%esp

	cprintf_colored(TEXT_light_magenta, ">>> Slave %d is Finished\n", envID);
  800254:	83 ec 04             	sub    $0x4,%esp
  800257:	ff 75 e4             	pushl  -0x1c(%ebp)
  80025a:	68 96 1f 80 00       	push   $0x801f96
  80025f:	6a 0d                	push   $0xd
  800261:	e8 c1 04 00 00       	call   800727 <cprintf_colored>
  800266:	83 c4 10             	add    $0x10,%esp
	printStats = 0;
  800269:	c7 05 00 30 80 00 00 	movl   $0x0,0x803000
  800270:	00 00 00 

	return;
  800273:	90                   	nop
}
  800274:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800277:	5b                   	pop    %ebx
  800278:	5e                   	pop    %esi
  800279:	5f                   	pop    %edi
  80027a:	5d                   	pop    %ebp
  80027b:	c3                   	ret    

0080027c <libmain>:
volatile bool printStats = 1;

volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";
void
libmain(int argc, char **argv)
{
  80027c:	55                   	push   %ebp
  80027d:	89 e5                	mov    %esp,%ebp
  80027f:	57                   	push   %edi
  800280:	56                   	push   %esi
  800281:	53                   	push   %ebx
  800282:	83 ec 7c             	sub    $0x7c,%esp
	//printStats = 1;
	int envIndex = sys_getenvindex();
  800285:	e8 3d 16 00 00       	call   8018c7 <sys_getenvindex>
  80028a:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	myEnv = &(envs[envIndex]);
  80028d:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800290:	89 d0                	mov    %edx,%eax
  800292:	c1 e0 02             	shl    $0x2,%eax
  800295:	01 d0                	add    %edx,%eax
  800297:	c1 e0 03             	shl    $0x3,%eax
  80029a:	01 d0                	add    %edx,%eax
  80029c:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  8002a3:	01 d0                	add    %edx,%eax
  8002a5:	c1 e0 02             	shl    $0x2,%eax
  8002a8:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8002ad:	a3 20 30 80 00       	mov    %eax,0x803020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  8002b2:	a1 20 30 80 00       	mov    0x803020,%eax
  8002b7:	8a 40 20             	mov    0x20(%eax),%al
  8002ba:	84 c0                	test   %al,%al
  8002bc:	74 0d                	je     8002cb <libmain+0x4f>
		binaryname = myEnv->prog_name;
  8002be:	a1 20 30 80 00       	mov    0x803020,%eax
  8002c3:	83 c0 20             	add    $0x20,%eax
  8002c6:	a3 04 30 80 00       	mov    %eax,0x803004

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8002cb:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8002cf:	7e 0a                	jle    8002db <libmain+0x5f>
		binaryname = argv[0];
  8002d1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8002d4:	8b 00                	mov    (%eax),%eax
  8002d6:	a3 04 30 80 00       	mov    %eax,0x803004

	// call user main routine
	_main(argc, argv);
  8002db:	83 ec 08             	sub    $0x8,%esp
  8002de:	ff 75 0c             	pushl  0xc(%ebp)
  8002e1:	ff 75 08             	pushl  0x8(%ebp)
  8002e4:	e8 4f fd ff ff       	call   800038 <_main>
  8002e9:	83 c4 10             	add    $0x10,%esp

	if (printStats)
  8002ec:	a1 00 30 80 00       	mov    0x803000,%eax
  8002f1:	85 c0                	test   %eax,%eax
  8002f3:	0f 84 01 01 00 00    	je     8003fa <libmain+0x17e>
	{
		char isOPTReplCmd[100] = "__IsOPTRepl__" ;
  8002f9:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  8002ff:	bb e8 21 80 00       	mov    $0x8021e8,%ebx
  800304:	ba 0e 00 00 00       	mov    $0xe,%edx
  800309:	89 c7                	mov    %eax,%edi
  80030b:	89 de                	mov    %ebx,%esi
  80030d:	89 d1                	mov    %edx,%ecx
  80030f:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  800311:	8d 55 8a             	lea    -0x76(%ebp),%edx
  800314:	b9 56 00 00 00       	mov    $0x56,%ecx
  800319:	b0 00                	mov    $0x0,%al
  80031b:	89 d7                	mov    %edx,%edi
  80031d:	f3 aa                	rep stos %al,%es:(%edi)
		int isOPTRepl = 0;
  80031f:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
		sys_utilities(isOPTReplCmd, (uint32)(&isOPTRepl));
  800326:	8d 45 e0             	lea    -0x20(%ebp),%eax
  800329:	83 ec 08             	sub    $0x8,%esp
  80032c:	50                   	push   %eax
  80032d:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  800333:	50                   	push   %eax
  800334:	e8 c4 17 00 00       	call   801afd <sys_utilities>
  800339:	83 c4 10             	add    $0x10,%esp

		sys_lock_cons();
  80033c:	e8 0d 13 00 00       	call   80164e <sys_lock_cons>
		{
			cprintf("**************************************\n");
  800341:	83 ec 0c             	sub    $0xc,%esp
  800344:	68 08 21 80 00       	push   $0x802108
  800349:	e8 ac 03 00 00       	call   8006fa <cprintf>
  80034e:	83 c4 10             	add    $0x10,%esp
			if (isOPTRepl)
  800351:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800354:	85 c0                	test   %eax,%eax
  800356:	74 18                	je     800370 <libmain+0xf4>
			{
				cprintf("OPTIMAL number of page faults = %d\n", sys_get_optimal_num_faults());
  800358:	e8 be 17 00 00       	call   801b1b <sys_get_optimal_num_faults>
  80035d:	83 ec 08             	sub    $0x8,%esp
  800360:	50                   	push   %eax
  800361:	68 30 21 80 00       	push   $0x802130
  800366:	e8 8f 03 00 00       	call   8006fa <cprintf>
  80036b:	83 c4 10             	add    $0x10,%esp
  80036e:	eb 59                	jmp    8003c9 <libmain+0x14d>
			}
			else
			{
				cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  800370:	a1 20 30 80 00       	mov    0x803020,%eax
  800375:	8b 90 a8 05 00 00    	mov    0x5a8(%eax),%edx
  80037b:	a1 20 30 80 00       	mov    0x803020,%eax
  800380:	8b 80 98 05 00 00    	mov    0x598(%eax),%eax
  800386:	83 ec 04             	sub    $0x4,%esp
  800389:	52                   	push   %edx
  80038a:	50                   	push   %eax
  80038b:	68 54 21 80 00       	push   $0x802154
  800390:	e8 65 03 00 00       	call   8006fa <cprintf>
  800395:	83 c4 10             	add    $0x10,%esp
				cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800398:	a1 20 30 80 00       	mov    0x803020,%eax
  80039d:	8b 88 bc 05 00 00    	mov    0x5bc(%eax),%ecx
  8003a3:	a1 20 30 80 00       	mov    0x803020,%eax
  8003a8:	8b 90 b8 05 00 00    	mov    0x5b8(%eax),%edx
  8003ae:	a1 20 30 80 00       	mov    0x803020,%eax
  8003b3:	8b 80 b4 05 00 00    	mov    0x5b4(%eax),%eax
  8003b9:	51                   	push   %ecx
  8003ba:	52                   	push   %edx
  8003bb:	50                   	push   %eax
  8003bc:	68 7c 21 80 00       	push   $0x80217c
  8003c1:	e8 34 03 00 00       	call   8006fa <cprintf>
  8003c6:	83 c4 10             	add    $0x10,%esp
			}
			//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
			cprintf("Num of clocks = %d\n", myEnv->nClocks);
  8003c9:	a1 20 30 80 00       	mov    0x803020,%eax
  8003ce:	8b 80 c0 05 00 00    	mov    0x5c0(%eax),%eax
  8003d4:	83 ec 08             	sub    $0x8,%esp
  8003d7:	50                   	push   %eax
  8003d8:	68 d4 21 80 00       	push   $0x8021d4
  8003dd:	e8 18 03 00 00       	call   8006fa <cprintf>
  8003e2:	83 c4 10             	add    $0x10,%esp
			cprintf("**************************************\n");
  8003e5:	83 ec 0c             	sub    $0xc,%esp
  8003e8:	68 08 21 80 00       	push   $0x802108
  8003ed:	e8 08 03 00 00       	call   8006fa <cprintf>
  8003f2:	83 c4 10             	add    $0x10,%esp
		}
		sys_unlock_cons();
  8003f5:	e8 6e 12 00 00       	call   801668 <sys_unlock_cons>
	}

	// exit gracefully
	exit();
  8003fa:	e8 1f 00 00 00       	call   80041e <exit>
}
  8003ff:	90                   	nop
  800400:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800403:	5b                   	pop    %ebx
  800404:	5e                   	pop    %esi
  800405:	5f                   	pop    %edi
  800406:	5d                   	pop    %ebp
  800407:	c3                   	ret    

00800408 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800408:	55                   	push   %ebp
  800409:	89 e5                	mov    %esp,%ebp
  80040b:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  80040e:	83 ec 0c             	sub    $0xc,%esp
  800411:	6a 00                	push   $0x0
  800413:	e8 7b 14 00 00       	call   801893 <sys_destroy_env>
  800418:	83 c4 10             	add    $0x10,%esp
}
  80041b:	90                   	nop
  80041c:	c9                   	leave  
  80041d:	c3                   	ret    

0080041e <exit>:

void
exit(void)
{
  80041e:	55                   	push   %ebp
  80041f:	89 e5                	mov    %esp,%ebp
  800421:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  800424:	e8 d0 14 00 00       	call   8018f9 <sys_exit_env>
}
  800429:	90                   	nop
  80042a:	c9                   	leave  
  80042b:	c3                   	ret    

0080042c <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  80042c:	55                   	push   %ebp
  80042d:	89 e5                	mov    %esp,%ebp
  80042f:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  800432:	8d 45 10             	lea    0x10(%ebp),%eax
  800435:	83 c0 04             	add    $0x4,%eax
  800438:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  80043b:	a1 18 b1 81 00       	mov    0x81b118,%eax
  800440:	85 c0                	test   %eax,%eax
  800442:	74 16                	je     80045a <_panic+0x2e>
		cprintf("%s: ", argv0);
  800444:	a1 18 b1 81 00       	mov    0x81b118,%eax
  800449:	83 ec 08             	sub    $0x8,%esp
  80044c:	50                   	push   %eax
  80044d:	68 4c 22 80 00       	push   $0x80224c
  800452:	e8 a3 02 00 00       	call   8006fa <cprintf>
  800457:	83 c4 10             	add    $0x10,%esp
	cprintf_colored(TEXT_PANIC_CLR, "user [EVAL_FINAL]panic in %s at %s:%d: ", binaryname, file, line);
  80045a:	a1 04 30 80 00       	mov    0x803004,%eax
  80045f:	83 ec 0c             	sub    $0xc,%esp
  800462:	ff 75 0c             	pushl  0xc(%ebp)
  800465:	ff 75 08             	pushl  0x8(%ebp)
  800468:	50                   	push   %eax
  800469:	68 54 22 80 00       	push   $0x802254
  80046e:	6a 74                	push   $0x74
  800470:	e8 b2 02 00 00       	call   800727 <cprintf_colored>
  800475:	83 c4 20             	add    $0x20,%esp
	vcprintf(fmt, ap);
  800478:	8b 45 10             	mov    0x10(%ebp),%eax
  80047b:	83 ec 08             	sub    $0x8,%esp
  80047e:	ff 75 f4             	pushl  -0xc(%ebp)
  800481:	50                   	push   %eax
  800482:	e8 04 02 00 00       	call   80068b <vcprintf>
  800487:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  80048a:	83 ec 08             	sub    $0x8,%esp
  80048d:	6a 00                	push   $0x0
  80048f:	68 7c 22 80 00       	push   $0x80227c
  800494:	e8 f2 01 00 00       	call   80068b <vcprintf>
  800499:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  80049c:	e8 7d ff ff ff       	call   80041e <exit>

	// should not return here
	while (1) ;
  8004a1:	eb fe                	jmp    8004a1 <_panic+0x75>

008004a3 <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  8004a3:	55                   	push   %ebp
  8004a4:	89 e5                	mov    %esp,%ebp
  8004a6:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  8004a9:	a1 20 30 80 00       	mov    0x803020,%eax
  8004ae:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  8004b4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004b7:	39 c2                	cmp    %eax,%edx
  8004b9:	74 14                	je     8004cf <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  8004bb:	83 ec 04             	sub    $0x4,%esp
  8004be:	68 80 22 80 00       	push   $0x802280
  8004c3:	6a 26                	push   $0x26
  8004c5:	68 cc 22 80 00       	push   $0x8022cc
  8004ca:	e8 5d ff ff ff       	call   80042c <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  8004cf:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  8004d6:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8004dd:	e9 c5 00 00 00       	jmp    8005a7 <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  8004e2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8004e5:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8004ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8004ef:	01 d0                	add    %edx,%eax
  8004f1:	8b 00                	mov    (%eax),%eax
  8004f3:	85 c0                	test   %eax,%eax
  8004f5:	75 08                	jne    8004ff <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  8004f7:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  8004fa:	e9 a5 00 00 00       	jmp    8005a4 <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  8004ff:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800506:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  80050d:	eb 69                	jmp    800578 <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  80050f:	a1 20 30 80 00       	mov    0x803020,%eax
  800514:	8b 88 90 05 00 00    	mov    0x590(%eax),%ecx
  80051a:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80051d:	89 d0                	mov    %edx,%eax
  80051f:	01 c0                	add    %eax,%eax
  800521:	01 d0                	add    %edx,%eax
  800523:	c1 e0 03             	shl    $0x3,%eax
  800526:	01 c8                	add    %ecx,%eax
  800528:	8a 40 04             	mov    0x4(%eax),%al
  80052b:	84 c0                	test   %al,%al
  80052d:	75 46                	jne    800575 <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  80052f:	a1 20 30 80 00       	mov    0x803020,%eax
  800534:	8b 88 90 05 00 00    	mov    0x590(%eax),%ecx
  80053a:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80053d:	89 d0                	mov    %edx,%eax
  80053f:	01 c0                	add    %eax,%eax
  800541:	01 d0                	add    %edx,%eax
  800543:	c1 e0 03             	shl    $0x3,%eax
  800546:	01 c8                	add    %ecx,%eax
  800548:	8b 00                	mov    (%eax),%eax
  80054a:	89 45 dc             	mov    %eax,-0x24(%ebp)
  80054d:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800550:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800555:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  800557:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80055a:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800561:	8b 45 08             	mov    0x8(%ebp),%eax
  800564:	01 c8                	add    %ecx,%eax
  800566:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800568:	39 c2                	cmp    %eax,%edx
  80056a:	75 09                	jne    800575 <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  80056c:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  800573:	eb 15                	jmp    80058a <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800575:	ff 45 e8             	incl   -0x18(%ebp)
  800578:	a1 20 30 80 00       	mov    0x803020,%eax
  80057d:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  800583:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800586:	39 c2                	cmp    %eax,%edx
  800588:	77 85                	ja     80050f <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  80058a:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80058e:	75 14                	jne    8005a4 <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  800590:	83 ec 04             	sub    $0x4,%esp
  800593:	68 d8 22 80 00       	push   $0x8022d8
  800598:	6a 3a                	push   $0x3a
  80059a:	68 cc 22 80 00       	push   $0x8022cc
  80059f:	e8 88 fe ff ff       	call   80042c <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  8005a4:	ff 45 f0             	incl   -0x10(%ebp)
  8005a7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8005aa:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8005ad:	0f 8c 2f ff ff ff    	jl     8004e2 <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  8005b3:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8005ba:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  8005c1:	eb 26                	jmp    8005e9 <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  8005c3:	a1 20 30 80 00       	mov    0x803020,%eax
  8005c8:	8b 88 90 05 00 00    	mov    0x590(%eax),%ecx
  8005ce:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8005d1:	89 d0                	mov    %edx,%eax
  8005d3:	01 c0                	add    %eax,%eax
  8005d5:	01 d0                	add    %edx,%eax
  8005d7:	c1 e0 03             	shl    $0x3,%eax
  8005da:	01 c8                	add    %ecx,%eax
  8005dc:	8a 40 04             	mov    0x4(%eax),%al
  8005df:	3c 01                	cmp    $0x1,%al
  8005e1:	75 03                	jne    8005e6 <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  8005e3:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8005e6:	ff 45 e0             	incl   -0x20(%ebp)
  8005e9:	a1 20 30 80 00       	mov    0x803020,%eax
  8005ee:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  8005f4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8005f7:	39 c2                	cmp    %eax,%edx
  8005f9:	77 c8                	ja     8005c3 <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  8005fb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8005fe:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800601:	74 14                	je     800617 <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  800603:	83 ec 04             	sub    $0x4,%esp
  800606:	68 2c 23 80 00       	push   $0x80232c
  80060b:	6a 44                	push   $0x44
  80060d:	68 cc 22 80 00       	push   $0x8022cc
  800612:	e8 15 fe ff ff       	call   80042c <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  800617:	90                   	nop
  800618:	c9                   	leave  
  800619:	c3                   	ret    

0080061a <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  80061a:	55                   	push   %ebp
  80061b:	89 e5                	mov    %esp,%ebp
  80061d:	53                   	push   %ebx
  80061e:	83 ec 04             	sub    $0x4,%esp
	b->buf[b->idx++] = ch;
  800621:	8b 45 0c             	mov    0xc(%ebp),%eax
  800624:	8b 00                	mov    (%eax),%eax
  800626:	8d 48 01             	lea    0x1(%eax),%ecx
  800629:	8b 55 0c             	mov    0xc(%ebp),%edx
  80062c:	89 0a                	mov    %ecx,(%edx)
  80062e:	8b 55 08             	mov    0x8(%ebp),%edx
  800631:	88 d1                	mov    %dl,%cl
  800633:	8b 55 0c             	mov    0xc(%ebp),%edx
  800636:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  80063a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80063d:	8b 00                	mov    (%eax),%eax
  80063f:	3d ff 00 00 00       	cmp    $0xff,%eax
  800644:	75 30                	jne    800676 <putch+0x5c>
		sys_cputs(b->buf, b->idx, printProgName, curTextClr);
  800646:	8b 15 1c b1 81 00    	mov    0x81b11c,%edx
  80064c:	a0 44 30 80 00       	mov    0x803044,%al
  800651:	0f b6 c0             	movzbl %al,%eax
  800654:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800657:	8b 09                	mov    (%ecx),%ecx
  800659:	89 cb                	mov    %ecx,%ebx
  80065b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80065e:	83 c1 08             	add    $0x8,%ecx
  800661:	52                   	push   %edx
  800662:	50                   	push   %eax
  800663:	53                   	push   %ebx
  800664:	51                   	push   %ecx
  800665:	e8 a0 0f 00 00       	call   80160a <sys_cputs>
  80066a:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  80066d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800670:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800676:	8b 45 0c             	mov    0xc(%ebp),%eax
  800679:	8b 40 04             	mov    0x4(%eax),%eax
  80067c:	8d 50 01             	lea    0x1(%eax),%edx
  80067f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800682:	89 50 04             	mov    %edx,0x4(%eax)
}
  800685:	90                   	nop
  800686:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800689:	c9                   	leave  
  80068a:	c3                   	ret    

0080068b <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  80068b:	55                   	push   %ebp
  80068c:	89 e5                	mov    %esp,%ebp
  80068e:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800694:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80069b:	00 00 00 
	b.cnt = 0;
  80069e:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8006a5:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  8006a8:	ff 75 0c             	pushl  0xc(%ebp)
  8006ab:	ff 75 08             	pushl  0x8(%ebp)
  8006ae:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8006b4:	50                   	push   %eax
  8006b5:	68 1a 06 80 00       	push   $0x80061a
  8006ba:	e8 5a 02 00 00       	call   800919 <vprintfmt>
  8006bf:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName, curTextClr);
  8006c2:	8b 15 1c b1 81 00    	mov    0x81b11c,%edx
  8006c8:	a0 44 30 80 00       	mov    0x803044,%al
  8006cd:	0f b6 c0             	movzbl %al,%eax
  8006d0:	8b 8d f0 fe ff ff    	mov    -0x110(%ebp),%ecx
  8006d6:	52                   	push   %edx
  8006d7:	50                   	push   %eax
  8006d8:	51                   	push   %ecx
  8006d9:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8006df:	83 c0 08             	add    $0x8,%eax
  8006e2:	50                   	push   %eax
  8006e3:	e8 22 0f 00 00       	call   80160a <sys_cputs>
  8006e8:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  8006eb:	c6 05 44 30 80 00 00 	movb   $0x0,0x803044
	return b.cnt;
  8006f2:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  8006f8:	c9                   	leave  
  8006f9:	c3                   	ret    

008006fa <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  8006fa:	55                   	push   %ebp
  8006fb:	89 e5                	mov    %esp,%ebp
  8006fd:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800700:	c6 05 44 30 80 00 01 	movb   $0x1,0x803044
	va_start(ap, fmt);
  800707:	8d 45 0c             	lea    0xc(%ebp),%eax
  80070a:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  80070d:	8b 45 08             	mov    0x8(%ebp),%eax
  800710:	83 ec 08             	sub    $0x8,%esp
  800713:	ff 75 f4             	pushl  -0xc(%ebp)
  800716:	50                   	push   %eax
  800717:	e8 6f ff ff ff       	call   80068b <vcprintf>
  80071c:	83 c4 10             	add    $0x10,%esp
  80071f:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800722:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800725:	c9                   	leave  
  800726:	c3                   	ret    

00800727 <cprintf_colored>:

// *************** This text coloring feature is implemented by *************
// ********** Abd-Alrahman Zedan From Team Frozen-Bytes - FCIS'24-25 ********
int cprintf_colored(int textClr, const char *fmt, ...) {
  800727:	55                   	push   %ebp
  800728:	89 e5                	mov    %esp,%ebp
  80072a:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  80072d:	c6 05 44 30 80 00 01 	movb   $0x1,0x803044
	curTextClr = (textClr << 8) ; //set text color by the given value
  800734:	8b 45 08             	mov    0x8(%ebp),%eax
  800737:	c1 e0 08             	shl    $0x8,%eax
  80073a:	a3 1c b1 81 00       	mov    %eax,0x81b11c
	va_start(ap, fmt);
  80073f:	8d 45 0c             	lea    0xc(%ebp),%eax
  800742:	83 c0 04             	add    $0x4,%eax
  800745:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800748:	8b 45 0c             	mov    0xc(%ebp),%eax
  80074b:	83 ec 08             	sub    $0x8,%esp
  80074e:	ff 75 f4             	pushl  -0xc(%ebp)
  800751:	50                   	push   %eax
  800752:	e8 34 ff ff ff       	call   80068b <vcprintf>
  800757:	83 c4 10             	add    $0x10,%esp
  80075a:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);
	curTextClr = TEXT_DEFAULT_CLR; //restore default color
  80075d:	c7 05 1c b1 81 00 00 	movl   $0x700,0x81b11c
  800764:	07 00 00 

	return cnt;
  800767:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80076a:	c9                   	leave  
  80076b:	c3                   	ret    

0080076c <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  80076c:	55                   	push   %ebp
  80076d:	89 e5                	mov    %esp,%ebp
  80076f:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  800772:	e8 d7 0e 00 00       	call   80164e <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  800777:	8d 45 0c             	lea    0xc(%ebp),%eax
  80077a:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  80077d:	8b 45 08             	mov    0x8(%ebp),%eax
  800780:	83 ec 08             	sub    $0x8,%esp
  800783:	ff 75 f4             	pushl  -0xc(%ebp)
  800786:	50                   	push   %eax
  800787:	e8 ff fe ff ff       	call   80068b <vcprintf>
  80078c:	83 c4 10             	add    $0x10,%esp
  80078f:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  800792:	e8 d1 0e 00 00       	call   801668 <sys_unlock_cons>
	return cnt;
  800797:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80079a:	c9                   	leave  
  80079b:	c3                   	ret    

0080079c <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  80079c:	55                   	push   %ebp
  80079d:	89 e5                	mov    %esp,%ebp
  80079f:	53                   	push   %ebx
  8007a0:	83 ec 14             	sub    $0x14,%esp
  8007a3:	8b 45 10             	mov    0x10(%ebp),%eax
  8007a6:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8007a9:	8b 45 14             	mov    0x14(%ebp),%eax
  8007ac:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8007af:	8b 45 18             	mov    0x18(%ebp),%eax
  8007b2:	ba 00 00 00 00       	mov    $0x0,%edx
  8007b7:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8007ba:	77 55                	ja     800811 <printnum+0x75>
  8007bc:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8007bf:	72 05                	jb     8007c6 <printnum+0x2a>
  8007c1:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8007c4:	77 4b                	ja     800811 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8007c6:	8b 45 1c             	mov    0x1c(%ebp),%eax
  8007c9:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8007cc:	8b 45 18             	mov    0x18(%ebp),%eax
  8007cf:	ba 00 00 00 00       	mov    $0x0,%edx
  8007d4:	52                   	push   %edx
  8007d5:	50                   	push   %eax
  8007d6:	ff 75 f4             	pushl  -0xc(%ebp)
  8007d9:	ff 75 f0             	pushl  -0x10(%ebp)
  8007dc:	e8 67 14 00 00       	call   801c48 <__udivdi3>
  8007e1:	83 c4 10             	add    $0x10,%esp
  8007e4:	83 ec 04             	sub    $0x4,%esp
  8007e7:	ff 75 20             	pushl  0x20(%ebp)
  8007ea:	53                   	push   %ebx
  8007eb:	ff 75 18             	pushl  0x18(%ebp)
  8007ee:	52                   	push   %edx
  8007ef:	50                   	push   %eax
  8007f0:	ff 75 0c             	pushl  0xc(%ebp)
  8007f3:	ff 75 08             	pushl  0x8(%ebp)
  8007f6:	e8 a1 ff ff ff       	call   80079c <printnum>
  8007fb:	83 c4 20             	add    $0x20,%esp
  8007fe:	eb 1a                	jmp    80081a <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800800:	83 ec 08             	sub    $0x8,%esp
  800803:	ff 75 0c             	pushl  0xc(%ebp)
  800806:	ff 75 20             	pushl  0x20(%ebp)
  800809:	8b 45 08             	mov    0x8(%ebp),%eax
  80080c:	ff d0                	call   *%eax
  80080e:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800811:	ff 4d 1c             	decl   0x1c(%ebp)
  800814:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800818:	7f e6                	jg     800800 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80081a:	8b 4d 18             	mov    0x18(%ebp),%ecx
  80081d:	bb 00 00 00 00       	mov    $0x0,%ebx
  800822:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800825:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800828:	53                   	push   %ebx
  800829:	51                   	push   %ecx
  80082a:	52                   	push   %edx
  80082b:	50                   	push   %eax
  80082c:	e8 27 15 00 00       	call   801d58 <__umoddi3>
  800831:	83 c4 10             	add    $0x10,%esp
  800834:	05 94 25 80 00       	add    $0x802594,%eax
  800839:	8a 00                	mov    (%eax),%al
  80083b:	0f be c0             	movsbl %al,%eax
  80083e:	83 ec 08             	sub    $0x8,%esp
  800841:	ff 75 0c             	pushl  0xc(%ebp)
  800844:	50                   	push   %eax
  800845:	8b 45 08             	mov    0x8(%ebp),%eax
  800848:	ff d0                	call   *%eax
  80084a:	83 c4 10             	add    $0x10,%esp
}
  80084d:	90                   	nop
  80084e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800851:	c9                   	leave  
  800852:	c3                   	ret    

00800853 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800853:	55                   	push   %ebp
  800854:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800856:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  80085a:	7e 1c                	jle    800878 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  80085c:	8b 45 08             	mov    0x8(%ebp),%eax
  80085f:	8b 00                	mov    (%eax),%eax
  800861:	8d 50 08             	lea    0x8(%eax),%edx
  800864:	8b 45 08             	mov    0x8(%ebp),%eax
  800867:	89 10                	mov    %edx,(%eax)
  800869:	8b 45 08             	mov    0x8(%ebp),%eax
  80086c:	8b 00                	mov    (%eax),%eax
  80086e:	83 e8 08             	sub    $0x8,%eax
  800871:	8b 50 04             	mov    0x4(%eax),%edx
  800874:	8b 00                	mov    (%eax),%eax
  800876:	eb 40                	jmp    8008b8 <getuint+0x65>
	else if (lflag)
  800878:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80087c:	74 1e                	je     80089c <getuint+0x49>
		return va_arg(*ap, unsigned long);
  80087e:	8b 45 08             	mov    0x8(%ebp),%eax
  800881:	8b 00                	mov    (%eax),%eax
  800883:	8d 50 04             	lea    0x4(%eax),%edx
  800886:	8b 45 08             	mov    0x8(%ebp),%eax
  800889:	89 10                	mov    %edx,(%eax)
  80088b:	8b 45 08             	mov    0x8(%ebp),%eax
  80088e:	8b 00                	mov    (%eax),%eax
  800890:	83 e8 04             	sub    $0x4,%eax
  800893:	8b 00                	mov    (%eax),%eax
  800895:	ba 00 00 00 00       	mov    $0x0,%edx
  80089a:	eb 1c                	jmp    8008b8 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  80089c:	8b 45 08             	mov    0x8(%ebp),%eax
  80089f:	8b 00                	mov    (%eax),%eax
  8008a1:	8d 50 04             	lea    0x4(%eax),%edx
  8008a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8008a7:	89 10                	mov    %edx,(%eax)
  8008a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8008ac:	8b 00                	mov    (%eax),%eax
  8008ae:	83 e8 04             	sub    $0x4,%eax
  8008b1:	8b 00                	mov    (%eax),%eax
  8008b3:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8008b8:	5d                   	pop    %ebp
  8008b9:	c3                   	ret    

008008ba <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8008ba:	55                   	push   %ebp
  8008bb:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8008bd:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8008c1:	7e 1c                	jle    8008df <getint+0x25>
		return va_arg(*ap, long long);
  8008c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8008c6:	8b 00                	mov    (%eax),%eax
  8008c8:	8d 50 08             	lea    0x8(%eax),%edx
  8008cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8008ce:	89 10                	mov    %edx,(%eax)
  8008d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8008d3:	8b 00                	mov    (%eax),%eax
  8008d5:	83 e8 08             	sub    $0x8,%eax
  8008d8:	8b 50 04             	mov    0x4(%eax),%edx
  8008db:	8b 00                	mov    (%eax),%eax
  8008dd:	eb 38                	jmp    800917 <getint+0x5d>
	else if (lflag)
  8008df:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8008e3:	74 1a                	je     8008ff <getint+0x45>
		return va_arg(*ap, long);
  8008e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8008e8:	8b 00                	mov    (%eax),%eax
  8008ea:	8d 50 04             	lea    0x4(%eax),%edx
  8008ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8008f0:	89 10                	mov    %edx,(%eax)
  8008f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8008f5:	8b 00                	mov    (%eax),%eax
  8008f7:	83 e8 04             	sub    $0x4,%eax
  8008fa:	8b 00                	mov    (%eax),%eax
  8008fc:	99                   	cltd   
  8008fd:	eb 18                	jmp    800917 <getint+0x5d>
	else
		return va_arg(*ap, int);
  8008ff:	8b 45 08             	mov    0x8(%ebp),%eax
  800902:	8b 00                	mov    (%eax),%eax
  800904:	8d 50 04             	lea    0x4(%eax),%edx
  800907:	8b 45 08             	mov    0x8(%ebp),%eax
  80090a:	89 10                	mov    %edx,(%eax)
  80090c:	8b 45 08             	mov    0x8(%ebp),%eax
  80090f:	8b 00                	mov    (%eax),%eax
  800911:	83 e8 04             	sub    $0x4,%eax
  800914:	8b 00                	mov    (%eax),%eax
  800916:	99                   	cltd   
}
  800917:	5d                   	pop    %ebp
  800918:	c3                   	ret    

00800919 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800919:	55                   	push   %ebp
  80091a:	89 e5                	mov    %esp,%ebp
  80091c:	56                   	push   %esi
  80091d:	53                   	push   %ebx
  80091e:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800921:	eb 17                	jmp    80093a <vprintfmt+0x21>
			if (ch == '\0')
  800923:	85 db                	test   %ebx,%ebx
  800925:	0f 84 c1 03 00 00    	je     800cec <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  80092b:	83 ec 08             	sub    $0x8,%esp
  80092e:	ff 75 0c             	pushl  0xc(%ebp)
  800931:	53                   	push   %ebx
  800932:	8b 45 08             	mov    0x8(%ebp),%eax
  800935:	ff d0                	call   *%eax
  800937:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80093a:	8b 45 10             	mov    0x10(%ebp),%eax
  80093d:	8d 50 01             	lea    0x1(%eax),%edx
  800940:	89 55 10             	mov    %edx,0x10(%ebp)
  800943:	8a 00                	mov    (%eax),%al
  800945:	0f b6 d8             	movzbl %al,%ebx
  800948:	83 fb 25             	cmp    $0x25,%ebx
  80094b:	75 d6                	jne    800923 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  80094d:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800951:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800958:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  80095f:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800966:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80096d:	8b 45 10             	mov    0x10(%ebp),%eax
  800970:	8d 50 01             	lea    0x1(%eax),%edx
  800973:	89 55 10             	mov    %edx,0x10(%ebp)
  800976:	8a 00                	mov    (%eax),%al
  800978:	0f b6 d8             	movzbl %al,%ebx
  80097b:	8d 43 dd             	lea    -0x23(%ebx),%eax
  80097e:	83 f8 5b             	cmp    $0x5b,%eax
  800981:	0f 87 3d 03 00 00    	ja     800cc4 <vprintfmt+0x3ab>
  800987:	8b 04 85 b8 25 80 00 	mov    0x8025b8(,%eax,4),%eax
  80098e:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800990:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800994:	eb d7                	jmp    80096d <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800996:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  80099a:	eb d1                	jmp    80096d <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  80099c:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  8009a3:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8009a6:	89 d0                	mov    %edx,%eax
  8009a8:	c1 e0 02             	shl    $0x2,%eax
  8009ab:	01 d0                	add    %edx,%eax
  8009ad:	01 c0                	add    %eax,%eax
  8009af:	01 d8                	add    %ebx,%eax
  8009b1:	83 e8 30             	sub    $0x30,%eax
  8009b4:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  8009b7:	8b 45 10             	mov    0x10(%ebp),%eax
  8009ba:	8a 00                	mov    (%eax),%al
  8009bc:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8009bf:	83 fb 2f             	cmp    $0x2f,%ebx
  8009c2:	7e 3e                	jle    800a02 <vprintfmt+0xe9>
  8009c4:	83 fb 39             	cmp    $0x39,%ebx
  8009c7:	7f 39                	jg     800a02 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8009c9:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8009cc:	eb d5                	jmp    8009a3 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8009ce:	8b 45 14             	mov    0x14(%ebp),%eax
  8009d1:	83 c0 04             	add    $0x4,%eax
  8009d4:	89 45 14             	mov    %eax,0x14(%ebp)
  8009d7:	8b 45 14             	mov    0x14(%ebp),%eax
  8009da:	83 e8 04             	sub    $0x4,%eax
  8009dd:	8b 00                	mov    (%eax),%eax
  8009df:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  8009e2:	eb 1f                	jmp    800a03 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  8009e4:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8009e8:	79 83                	jns    80096d <vprintfmt+0x54>
				width = 0;
  8009ea:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  8009f1:	e9 77 ff ff ff       	jmp    80096d <vprintfmt+0x54>

		case '#':
			altflag = 1;
  8009f6:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  8009fd:	e9 6b ff ff ff       	jmp    80096d <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800a02:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800a03:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a07:	0f 89 60 ff ff ff    	jns    80096d <vprintfmt+0x54>
				width = precision, precision = -1;
  800a0d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800a10:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800a13:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800a1a:	e9 4e ff ff ff       	jmp    80096d <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800a1f:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800a22:	e9 46 ff ff ff       	jmp    80096d <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800a27:	8b 45 14             	mov    0x14(%ebp),%eax
  800a2a:	83 c0 04             	add    $0x4,%eax
  800a2d:	89 45 14             	mov    %eax,0x14(%ebp)
  800a30:	8b 45 14             	mov    0x14(%ebp),%eax
  800a33:	83 e8 04             	sub    $0x4,%eax
  800a36:	8b 00                	mov    (%eax),%eax
  800a38:	83 ec 08             	sub    $0x8,%esp
  800a3b:	ff 75 0c             	pushl  0xc(%ebp)
  800a3e:	50                   	push   %eax
  800a3f:	8b 45 08             	mov    0x8(%ebp),%eax
  800a42:	ff d0                	call   *%eax
  800a44:	83 c4 10             	add    $0x10,%esp
			break;
  800a47:	e9 9b 02 00 00       	jmp    800ce7 <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800a4c:	8b 45 14             	mov    0x14(%ebp),%eax
  800a4f:	83 c0 04             	add    $0x4,%eax
  800a52:	89 45 14             	mov    %eax,0x14(%ebp)
  800a55:	8b 45 14             	mov    0x14(%ebp),%eax
  800a58:	83 e8 04             	sub    $0x4,%eax
  800a5b:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800a5d:	85 db                	test   %ebx,%ebx
  800a5f:	79 02                	jns    800a63 <vprintfmt+0x14a>
				err = -err;
  800a61:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800a63:	83 fb 64             	cmp    $0x64,%ebx
  800a66:	7f 0b                	jg     800a73 <vprintfmt+0x15a>
  800a68:	8b 34 9d 00 24 80 00 	mov    0x802400(,%ebx,4),%esi
  800a6f:	85 f6                	test   %esi,%esi
  800a71:	75 19                	jne    800a8c <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800a73:	53                   	push   %ebx
  800a74:	68 a5 25 80 00       	push   $0x8025a5
  800a79:	ff 75 0c             	pushl  0xc(%ebp)
  800a7c:	ff 75 08             	pushl  0x8(%ebp)
  800a7f:	e8 70 02 00 00       	call   800cf4 <printfmt>
  800a84:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800a87:	e9 5b 02 00 00       	jmp    800ce7 <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800a8c:	56                   	push   %esi
  800a8d:	68 ae 25 80 00       	push   $0x8025ae
  800a92:	ff 75 0c             	pushl  0xc(%ebp)
  800a95:	ff 75 08             	pushl  0x8(%ebp)
  800a98:	e8 57 02 00 00       	call   800cf4 <printfmt>
  800a9d:	83 c4 10             	add    $0x10,%esp
			break;
  800aa0:	e9 42 02 00 00       	jmp    800ce7 <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800aa5:	8b 45 14             	mov    0x14(%ebp),%eax
  800aa8:	83 c0 04             	add    $0x4,%eax
  800aab:	89 45 14             	mov    %eax,0x14(%ebp)
  800aae:	8b 45 14             	mov    0x14(%ebp),%eax
  800ab1:	83 e8 04             	sub    $0x4,%eax
  800ab4:	8b 30                	mov    (%eax),%esi
  800ab6:	85 f6                	test   %esi,%esi
  800ab8:	75 05                	jne    800abf <vprintfmt+0x1a6>
				p = "(null)";
  800aba:	be b1 25 80 00       	mov    $0x8025b1,%esi
			if (width > 0 && padc != '-')
  800abf:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800ac3:	7e 6d                	jle    800b32 <vprintfmt+0x219>
  800ac5:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800ac9:	74 67                	je     800b32 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800acb:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800ace:	83 ec 08             	sub    $0x8,%esp
  800ad1:	50                   	push   %eax
  800ad2:	56                   	push   %esi
  800ad3:	e8 1e 03 00 00       	call   800df6 <strnlen>
  800ad8:	83 c4 10             	add    $0x10,%esp
  800adb:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800ade:	eb 16                	jmp    800af6 <vprintfmt+0x1dd>
					putch(padc, putdat);
  800ae0:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800ae4:	83 ec 08             	sub    $0x8,%esp
  800ae7:	ff 75 0c             	pushl  0xc(%ebp)
  800aea:	50                   	push   %eax
  800aeb:	8b 45 08             	mov    0x8(%ebp),%eax
  800aee:	ff d0                	call   *%eax
  800af0:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800af3:	ff 4d e4             	decl   -0x1c(%ebp)
  800af6:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800afa:	7f e4                	jg     800ae0 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800afc:	eb 34                	jmp    800b32 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800afe:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800b02:	74 1c                	je     800b20 <vprintfmt+0x207>
  800b04:	83 fb 1f             	cmp    $0x1f,%ebx
  800b07:	7e 05                	jle    800b0e <vprintfmt+0x1f5>
  800b09:	83 fb 7e             	cmp    $0x7e,%ebx
  800b0c:	7e 12                	jle    800b20 <vprintfmt+0x207>
					putch('?', putdat);
  800b0e:	83 ec 08             	sub    $0x8,%esp
  800b11:	ff 75 0c             	pushl  0xc(%ebp)
  800b14:	6a 3f                	push   $0x3f
  800b16:	8b 45 08             	mov    0x8(%ebp),%eax
  800b19:	ff d0                	call   *%eax
  800b1b:	83 c4 10             	add    $0x10,%esp
  800b1e:	eb 0f                	jmp    800b2f <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800b20:	83 ec 08             	sub    $0x8,%esp
  800b23:	ff 75 0c             	pushl  0xc(%ebp)
  800b26:	53                   	push   %ebx
  800b27:	8b 45 08             	mov    0x8(%ebp),%eax
  800b2a:	ff d0                	call   *%eax
  800b2c:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800b2f:	ff 4d e4             	decl   -0x1c(%ebp)
  800b32:	89 f0                	mov    %esi,%eax
  800b34:	8d 70 01             	lea    0x1(%eax),%esi
  800b37:	8a 00                	mov    (%eax),%al
  800b39:	0f be d8             	movsbl %al,%ebx
  800b3c:	85 db                	test   %ebx,%ebx
  800b3e:	74 24                	je     800b64 <vprintfmt+0x24b>
  800b40:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800b44:	78 b8                	js     800afe <vprintfmt+0x1e5>
  800b46:	ff 4d e0             	decl   -0x20(%ebp)
  800b49:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800b4d:	79 af                	jns    800afe <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800b4f:	eb 13                	jmp    800b64 <vprintfmt+0x24b>
				putch(' ', putdat);
  800b51:	83 ec 08             	sub    $0x8,%esp
  800b54:	ff 75 0c             	pushl  0xc(%ebp)
  800b57:	6a 20                	push   $0x20
  800b59:	8b 45 08             	mov    0x8(%ebp),%eax
  800b5c:	ff d0                	call   *%eax
  800b5e:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800b61:	ff 4d e4             	decl   -0x1c(%ebp)
  800b64:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800b68:	7f e7                	jg     800b51 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800b6a:	e9 78 01 00 00       	jmp    800ce7 <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800b6f:	83 ec 08             	sub    $0x8,%esp
  800b72:	ff 75 e8             	pushl  -0x18(%ebp)
  800b75:	8d 45 14             	lea    0x14(%ebp),%eax
  800b78:	50                   	push   %eax
  800b79:	e8 3c fd ff ff       	call   8008ba <getint>
  800b7e:	83 c4 10             	add    $0x10,%esp
  800b81:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b84:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800b87:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800b8a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800b8d:	85 d2                	test   %edx,%edx
  800b8f:	79 23                	jns    800bb4 <vprintfmt+0x29b>
				putch('-', putdat);
  800b91:	83 ec 08             	sub    $0x8,%esp
  800b94:	ff 75 0c             	pushl  0xc(%ebp)
  800b97:	6a 2d                	push   $0x2d
  800b99:	8b 45 08             	mov    0x8(%ebp),%eax
  800b9c:	ff d0                	call   *%eax
  800b9e:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800ba1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800ba4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800ba7:	f7 d8                	neg    %eax
  800ba9:	83 d2 00             	adc    $0x0,%edx
  800bac:	f7 da                	neg    %edx
  800bae:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800bb1:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800bb4:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800bbb:	e9 bc 00 00 00       	jmp    800c7c <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800bc0:	83 ec 08             	sub    $0x8,%esp
  800bc3:	ff 75 e8             	pushl  -0x18(%ebp)
  800bc6:	8d 45 14             	lea    0x14(%ebp),%eax
  800bc9:	50                   	push   %eax
  800bca:	e8 84 fc ff ff       	call   800853 <getuint>
  800bcf:	83 c4 10             	add    $0x10,%esp
  800bd2:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800bd5:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800bd8:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800bdf:	e9 98 00 00 00       	jmp    800c7c <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800be4:	83 ec 08             	sub    $0x8,%esp
  800be7:	ff 75 0c             	pushl  0xc(%ebp)
  800bea:	6a 58                	push   $0x58
  800bec:	8b 45 08             	mov    0x8(%ebp),%eax
  800bef:	ff d0                	call   *%eax
  800bf1:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800bf4:	83 ec 08             	sub    $0x8,%esp
  800bf7:	ff 75 0c             	pushl  0xc(%ebp)
  800bfa:	6a 58                	push   $0x58
  800bfc:	8b 45 08             	mov    0x8(%ebp),%eax
  800bff:	ff d0                	call   *%eax
  800c01:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800c04:	83 ec 08             	sub    $0x8,%esp
  800c07:	ff 75 0c             	pushl  0xc(%ebp)
  800c0a:	6a 58                	push   $0x58
  800c0c:	8b 45 08             	mov    0x8(%ebp),%eax
  800c0f:	ff d0                	call   *%eax
  800c11:	83 c4 10             	add    $0x10,%esp
			break;
  800c14:	e9 ce 00 00 00       	jmp    800ce7 <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  800c19:	83 ec 08             	sub    $0x8,%esp
  800c1c:	ff 75 0c             	pushl  0xc(%ebp)
  800c1f:	6a 30                	push   $0x30
  800c21:	8b 45 08             	mov    0x8(%ebp),%eax
  800c24:	ff d0                	call   *%eax
  800c26:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800c29:	83 ec 08             	sub    $0x8,%esp
  800c2c:	ff 75 0c             	pushl  0xc(%ebp)
  800c2f:	6a 78                	push   $0x78
  800c31:	8b 45 08             	mov    0x8(%ebp),%eax
  800c34:	ff d0                	call   *%eax
  800c36:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800c39:	8b 45 14             	mov    0x14(%ebp),%eax
  800c3c:	83 c0 04             	add    $0x4,%eax
  800c3f:	89 45 14             	mov    %eax,0x14(%ebp)
  800c42:	8b 45 14             	mov    0x14(%ebp),%eax
  800c45:	83 e8 04             	sub    $0x4,%eax
  800c48:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800c4a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c4d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800c54:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800c5b:	eb 1f                	jmp    800c7c <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800c5d:	83 ec 08             	sub    $0x8,%esp
  800c60:	ff 75 e8             	pushl  -0x18(%ebp)
  800c63:	8d 45 14             	lea    0x14(%ebp),%eax
  800c66:	50                   	push   %eax
  800c67:	e8 e7 fb ff ff       	call   800853 <getuint>
  800c6c:	83 c4 10             	add    $0x10,%esp
  800c6f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c72:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800c75:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800c7c:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800c80:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800c83:	83 ec 04             	sub    $0x4,%esp
  800c86:	52                   	push   %edx
  800c87:	ff 75 e4             	pushl  -0x1c(%ebp)
  800c8a:	50                   	push   %eax
  800c8b:	ff 75 f4             	pushl  -0xc(%ebp)
  800c8e:	ff 75 f0             	pushl  -0x10(%ebp)
  800c91:	ff 75 0c             	pushl  0xc(%ebp)
  800c94:	ff 75 08             	pushl  0x8(%ebp)
  800c97:	e8 00 fb ff ff       	call   80079c <printnum>
  800c9c:	83 c4 20             	add    $0x20,%esp
			break;
  800c9f:	eb 46                	jmp    800ce7 <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800ca1:	83 ec 08             	sub    $0x8,%esp
  800ca4:	ff 75 0c             	pushl  0xc(%ebp)
  800ca7:	53                   	push   %ebx
  800ca8:	8b 45 08             	mov    0x8(%ebp),%eax
  800cab:	ff d0                	call   *%eax
  800cad:	83 c4 10             	add    $0x10,%esp
			break;
  800cb0:	eb 35                	jmp    800ce7 <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  800cb2:	c6 05 44 30 80 00 00 	movb   $0x0,0x803044
			break;
  800cb9:	eb 2c                	jmp    800ce7 <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  800cbb:	c6 05 44 30 80 00 01 	movb   $0x1,0x803044
			break;
  800cc2:	eb 23                	jmp    800ce7 <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800cc4:	83 ec 08             	sub    $0x8,%esp
  800cc7:	ff 75 0c             	pushl  0xc(%ebp)
  800cca:	6a 25                	push   $0x25
  800ccc:	8b 45 08             	mov    0x8(%ebp),%eax
  800ccf:	ff d0                	call   *%eax
  800cd1:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800cd4:	ff 4d 10             	decl   0x10(%ebp)
  800cd7:	eb 03                	jmp    800cdc <vprintfmt+0x3c3>
  800cd9:	ff 4d 10             	decl   0x10(%ebp)
  800cdc:	8b 45 10             	mov    0x10(%ebp),%eax
  800cdf:	48                   	dec    %eax
  800ce0:	8a 00                	mov    (%eax),%al
  800ce2:	3c 25                	cmp    $0x25,%al
  800ce4:	75 f3                	jne    800cd9 <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  800ce6:	90                   	nop
		}
	}
  800ce7:	e9 35 fc ff ff       	jmp    800921 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800cec:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800ced:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800cf0:	5b                   	pop    %ebx
  800cf1:	5e                   	pop    %esi
  800cf2:	5d                   	pop    %ebp
  800cf3:	c3                   	ret    

00800cf4 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800cf4:	55                   	push   %ebp
  800cf5:	89 e5                	mov    %esp,%ebp
  800cf7:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800cfa:	8d 45 10             	lea    0x10(%ebp),%eax
  800cfd:	83 c0 04             	add    $0x4,%eax
  800d00:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800d03:	8b 45 10             	mov    0x10(%ebp),%eax
  800d06:	ff 75 f4             	pushl  -0xc(%ebp)
  800d09:	50                   	push   %eax
  800d0a:	ff 75 0c             	pushl  0xc(%ebp)
  800d0d:	ff 75 08             	pushl  0x8(%ebp)
  800d10:	e8 04 fc ff ff       	call   800919 <vprintfmt>
  800d15:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800d18:	90                   	nop
  800d19:	c9                   	leave  
  800d1a:	c3                   	ret    

00800d1b <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800d1b:	55                   	push   %ebp
  800d1c:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800d1e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d21:	8b 40 08             	mov    0x8(%eax),%eax
  800d24:	8d 50 01             	lea    0x1(%eax),%edx
  800d27:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d2a:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800d2d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d30:	8b 10                	mov    (%eax),%edx
  800d32:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d35:	8b 40 04             	mov    0x4(%eax),%eax
  800d38:	39 c2                	cmp    %eax,%edx
  800d3a:	73 12                	jae    800d4e <sprintputch+0x33>
		*b->buf++ = ch;
  800d3c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d3f:	8b 00                	mov    (%eax),%eax
  800d41:	8d 48 01             	lea    0x1(%eax),%ecx
  800d44:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d47:	89 0a                	mov    %ecx,(%edx)
  800d49:	8b 55 08             	mov    0x8(%ebp),%edx
  800d4c:	88 10                	mov    %dl,(%eax)
}
  800d4e:	90                   	nop
  800d4f:	5d                   	pop    %ebp
  800d50:	c3                   	ret    

00800d51 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800d51:	55                   	push   %ebp
  800d52:	89 e5                	mov    %esp,%ebp
  800d54:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800d57:	8b 45 08             	mov    0x8(%ebp),%eax
  800d5a:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800d5d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d60:	8d 50 ff             	lea    -0x1(%eax),%edx
  800d63:	8b 45 08             	mov    0x8(%ebp),%eax
  800d66:	01 d0                	add    %edx,%eax
  800d68:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800d6b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800d72:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800d76:	74 06                	je     800d7e <vsnprintf+0x2d>
  800d78:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800d7c:	7f 07                	jg     800d85 <vsnprintf+0x34>
		return -E_INVAL;
  800d7e:	b8 03 00 00 00       	mov    $0x3,%eax
  800d83:	eb 20                	jmp    800da5 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800d85:	ff 75 14             	pushl  0x14(%ebp)
  800d88:	ff 75 10             	pushl  0x10(%ebp)
  800d8b:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800d8e:	50                   	push   %eax
  800d8f:	68 1b 0d 80 00       	push   $0x800d1b
  800d94:	e8 80 fb ff ff       	call   800919 <vprintfmt>
  800d99:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800d9c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800d9f:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800da2:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800da5:	c9                   	leave  
  800da6:	c3                   	ret    

00800da7 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800da7:	55                   	push   %ebp
  800da8:	89 e5                	mov    %esp,%ebp
  800daa:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800dad:	8d 45 10             	lea    0x10(%ebp),%eax
  800db0:	83 c0 04             	add    $0x4,%eax
  800db3:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800db6:	8b 45 10             	mov    0x10(%ebp),%eax
  800db9:	ff 75 f4             	pushl  -0xc(%ebp)
  800dbc:	50                   	push   %eax
  800dbd:	ff 75 0c             	pushl  0xc(%ebp)
  800dc0:	ff 75 08             	pushl  0x8(%ebp)
  800dc3:	e8 89 ff ff ff       	call   800d51 <vsnprintf>
  800dc8:	83 c4 10             	add    $0x10,%esp
  800dcb:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800dce:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800dd1:	c9                   	leave  
  800dd2:	c3                   	ret    

00800dd3 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800dd3:	55                   	push   %ebp
  800dd4:	89 e5                	mov    %esp,%ebp
  800dd6:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800dd9:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800de0:	eb 06                	jmp    800de8 <strlen+0x15>
		n++;
  800de2:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800de5:	ff 45 08             	incl   0x8(%ebp)
  800de8:	8b 45 08             	mov    0x8(%ebp),%eax
  800deb:	8a 00                	mov    (%eax),%al
  800ded:	84 c0                	test   %al,%al
  800def:	75 f1                	jne    800de2 <strlen+0xf>
		n++;
	return n;
  800df1:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800df4:	c9                   	leave  
  800df5:	c3                   	ret    

00800df6 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800df6:	55                   	push   %ebp
  800df7:	89 e5                	mov    %esp,%ebp
  800df9:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800dfc:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800e03:	eb 09                	jmp    800e0e <strnlen+0x18>
		n++;
  800e05:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800e08:	ff 45 08             	incl   0x8(%ebp)
  800e0b:	ff 4d 0c             	decl   0xc(%ebp)
  800e0e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800e12:	74 09                	je     800e1d <strnlen+0x27>
  800e14:	8b 45 08             	mov    0x8(%ebp),%eax
  800e17:	8a 00                	mov    (%eax),%al
  800e19:	84 c0                	test   %al,%al
  800e1b:	75 e8                	jne    800e05 <strnlen+0xf>
		n++;
	return n;
  800e1d:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800e20:	c9                   	leave  
  800e21:	c3                   	ret    

00800e22 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800e22:	55                   	push   %ebp
  800e23:	89 e5                	mov    %esp,%ebp
  800e25:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800e28:	8b 45 08             	mov    0x8(%ebp),%eax
  800e2b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800e2e:	90                   	nop
  800e2f:	8b 45 08             	mov    0x8(%ebp),%eax
  800e32:	8d 50 01             	lea    0x1(%eax),%edx
  800e35:	89 55 08             	mov    %edx,0x8(%ebp)
  800e38:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e3b:	8d 4a 01             	lea    0x1(%edx),%ecx
  800e3e:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800e41:	8a 12                	mov    (%edx),%dl
  800e43:	88 10                	mov    %dl,(%eax)
  800e45:	8a 00                	mov    (%eax),%al
  800e47:	84 c0                	test   %al,%al
  800e49:	75 e4                	jne    800e2f <strcpy+0xd>
		/* do nothing */;
	return ret;
  800e4b:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800e4e:	c9                   	leave  
  800e4f:	c3                   	ret    

00800e50 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800e50:	55                   	push   %ebp
  800e51:	89 e5                	mov    %esp,%ebp
  800e53:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800e56:	8b 45 08             	mov    0x8(%ebp),%eax
  800e59:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800e5c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800e63:	eb 1f                	jmp    800e84 <strncpy+0x34>
		*dst++ = *src;
  800e65:	8b 45 08             	mov    0x8(%ebp),%eax
  800e68:	8d 50 01             	lea    0x1(%eax),%edx
  800e6b:	89 55 08             	mov    %edx,0x8(%ebp)
  800e6e:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e71:	8a 12                	mov    (%edx),%dl
  800e73:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800e75:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e78:	8a 00                	mov    (%eax),%al
  800e7a:	84 c0                	test   %al,%al
  800e7c:	74 03                	je     800e81 <strncpy+0x31>
			src++;
  800e7e:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800e81:	ff 45 fc             	incl   -0x4(%ebp)
  800e84:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e87:	3b 45 10             	cmp    0x10(%ebp),%eax
  800e8a:	72 d9                	jb     800e65 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800e8c:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800e8f:	c9                   	leave  
  800e90:	c3                   	ret    

00800e91 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800e91:	55                   	push   %ebp
  800e92:	89 e5                	mov    %esp,%ebp
  800e94:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800e97:	8b 45 08             	mov    0x8(%ebp),%eax
  800e9a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800e9d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ea1:	74 30                	je     800ed3 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800ea3:	eb 16                	jmp    800ebb <strlcpy+0x2a>
			*dst++ = *src++;
  800ea5:	8b 45 08             	mov    0x8(%ebp),%eax
  800ea8:	8d 50 01             	lea    0x1(%eax),%edx
  800eab:	89 55 08             	mov    %edx,0x8(%ebp)
  800eae:	8b 55 0c             	mov    0xc(%ebp),%edx
  800eb1:	8d 4a 01             	lea    0x1(%edx),%ecx
  800eb4:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800eb7:	8a 12                	mov    (%edx),%dl
  800eb9:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800ebb:	ff 4d 10             	decl   0x10(%ebp)
  800ebe:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ec2:	74 09                	je     800ecd <strlcpy+0x3c>
  800ec4:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ec7:	8a 00                	mov    (%eax),%al
  800ec9:	84 c0                	test   %al,%al
  800ecb:	75 d8                	jne    800ea5 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800ecd:	8b 45 08             	mov    0x8(%ebp),%eax
  800ed0:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800ed3:	8b 55 08             	mov    0x8(%ebp),%edx
  800ed6:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ed9:	29 c2                	sub    %eax,%edx
  800edb:	89 d0                	mov    %edx,%eax
}
  800edd:	c9                   	leave  
  800ede:	c3                   	ret    

00800edf <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800edf:	55                   	push   %ebp
  800ee0:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800ee2:	eb 06                	jmp    800eea <strcmp+0xb>
		p++, q++;
  800ee4:	ff 45 08             	incl   0x8(%ebp)
  800ee7:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800eea:	8b 45 08             	mov    0x8(%ebp),%eax
  800eed:	8a 00                	mov    (%eax),%al
  800eef:	84 c0                	test   %al,%al
  800ef1:	74 0e                	je     800f01 <strcmp+0x22>
  800ef3:	8b 45 08             	mov    0x8(%ebp),%eax
  800ef6:	8a 10                	mov    (%eax),%dl
  800ef8:	8b 45 0c             	mov    0xc(%ebp),%eax
  800efb:	8a 00                	mov    (%eax),%al
  800efd:	38 c2                	cmp    %al,%dl
  800eff:	74 e3                	je     800ee4 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800f01:	8b 45 08             	mov    0x8(%ebp),%eax
  800f04:	8a 00                	mov    (%eax),%al
  800f06:	0f b6 d0             	movzbl %al,%edx
  800f09:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f0c:	8a 00                	mov    (%eax),%al
  800f0e:	0f b6 c0             	movzbl %al,%eax
  800f11:	29 c2                	sub    %eax,%edx
  800f13:	89 d0                	mov    %edx,%eax
}
  800f15:	5d                   	pop    %ebp
  800f16:	c3                   	ret    

00800f17 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800f17:	55                   	push   %ebp
  800f18:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800f1a:	eb 09                	jmp    800f25 <strncmp+0xe>
		n--, p++, q++;
  800f1c:	ff 4d 10             	decl   0x10(%ebp)
  800f1f:	ff 45 08             	incl   0x8(%ebp)
  800f22:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800f25:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f29:	74 17                	je     800f42 <strncmp+0x2b>
  800f2b:	8b 45 08             	mov    0x8(%ebp),%eax
  800f2e:	8a 00                	mov    (%eax),%al
  800f30:	84 c0                	test   %al,%al
  800f32:	74 0e                	je     800f42 <strncmp+0x2b>
  800f34:	8b 45 08             	mov    0x8(%ebp),%eax
  800f37:	8a 10                	mov    (%eax),%dl
  800f39:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f3c:	8a 00                	mov    (%eax),%al
  800f3e:	38 c2                	cmp    %al,%dl
  800f40:	74 da                	je     800f1c <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800f42:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f46:	75 07                	jne    800f4f <strncmp+0x38>
		return 0;
  800f48:	b8 00 00 00 00       	mov    $0x0,%eax
  800f4d:	eb 14                	jmp    800f63 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800f4f:	8b 45 08             	mov    0x8(%ebp),%eax
  800f52:	8a 00                	mov    (%eax),%al
  800f54:	0f b6 d0             	movzbl %al,%edx
  800f57:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f5a:	8a 00                	mov    (%eax),%al
  800f5c:	0f b6 c0             	movzbl %al,%eax
  800f5f:	29 c2                	sub    %eax,%edx
  800f61:	89 d0                	mov    %edx,%eax
}
  800f63:	5d                   	pop    %ebp
  800f64:	c3                   	ret    

00800f65 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800f65:	55                   	push   %ebp
  800f66:	89 e5                	mov    %esp,%ebp
  800f68:	83 ec 04             	sub    $0x4,%esp
  800f6b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f6e:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800f71:	eb 12                	jmp    800f85 <strchr+0x20>
		if (*s == c)
  800f73:	8b 45 08             	mov    0x8(%ebp),%eax
  800f76:	8a 00                	mov    (%eax),%al
  800f78:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800f7b:	75 05                	jne    800f82 <strchr+0x1d>
			return (char *) s;
  800f7d:	8b 45 08             	mov    0x8(%ebp),%eax
  800f80:	eb 11                	jmp    800f93 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800f82:	ff 45 08             	incl   0x8(%ebp)
  800f85:	8b 45 08             	mov    0x8(%ebp),%eax
  800f88:	8a 00                	mov    (%eax),%al
  800f8a:	84 c0                	test   %al,%al
  800f8c:	75 e5                	jne    800f73 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800f8e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800f93:	c9                   	leave  
  800f94:	c3                   	ret    

00800f95 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800f95:	55                   	push   %ebp
  800f96:	89 e5                	mov    %esp,%ebp
  800f98:	83 ec 04             	sub    $0x4,%esp
  800f9b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f9e:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800fa1:	eb 0d                	jmp    800fb0 <strfind+0x1b>
		if (*s == c)
  800fa3:	8b 45 08             	mov    0x8(%ebp),%eax
  800fa6:	8a 00                	mov    (%eax),%al
  800fa8:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800fab:	74 0e                	je     800fbb <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800fad:	ff 45 08             	incl   0x8(%ebp)
  800fb0:	8b 45 08             	mov    0x8(%ebp),%eax
  800fb3:	8a 00                	mov    (%eax),%al
  800fb5:	84 c0                	test   %al,%al
  800fb7:	75 ea                	jne    800fa3 <strfind+0xe>
  800fb9:	eb 01                	jmp    800fbc <strfind+0x27>
		if (*s == c)
			break;
  800fbb:	90                   	nop
	return (char *) s;
  800fbc:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800fbf:	c9                   	leave  
  800fc0:	c3                   	ret    

00800fc1 <memset>:

// *************** The faster implementation of memset & memcpy is implemented by *************
// ****************** Team80 (Yahia Khaled, Malek Ahmed et al) - FCIS'24-25 *******************
void *
memset(void *v, int c, uint32 n)
{
  800fc1:	55                   	push   %ebp
  800fc2:	89 e5                	mov    %esp,%ebp
  800fc4:	83 ec 10             	sub    $0x10,%esp
//	m = n;
//	while (--m >= 0)
//		*p++ = c;

	/*Faster Implementation*/
	uint64* p64 = (uint64*)v;
  800fc7:	8b 45 08             	mov    0x8(%ebp),%eax
  800fca:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if(n >= 8){
  800fcd:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800fd1:	76 63                	jbe    801036 <memset+0x75>
		uint64 data_block = c;
  800fd3:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fd6:	99                   	cltd   
  800fd7:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800fda:	89 55 f4             	mov    %edx,-0xc(%ebp)
		data_block |= data_block << 8;
  800fdd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800fe0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800fe3:	0f a4 c2 08          	shld   $0x8,%eax,%edx
  800fe7:	c1 e0 08             	shl    $0x8,%eax
  800fea:	09 45 f0             	or     %eax,-0x10(%ebp)
  800fed:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 16;
  800ff0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800ff3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800ff6:	0f a4 c2 10          	shld   $0x10,%eax,%edx
  800ffa:	c1 e0 10             	shl    $0x10,%eax
  800ffd:	09 45 f0             	or     %eax,-0x10(%ebp)
  801000:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 32;
  801003:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801006:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801009:	89 c2                	mov    %eax,%edx
  80100b:	b8 00 00 00 00       	mov    $0x0,%eax
  801010:	09 45 f0             	or     %eax,-0x10(%ebp)
  801013:	09 55 f4             	or     %edx,-0xc(%ebp)

		while(n >= 8)
  801016:	eb 18                	jmp    801030 <memset+0x6f>
			*p64++ = data_block, n -= 8;
  801018:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  80101b:	8d 41 08             	lea    0x8(%ecx),%eax
  80101e:	89 45 fc             	mov    %eax,-0x4(%ebp)
  801021:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801024:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801027:	89 01                	mov    %eax,(%ecx)
  801029:	89 51 04             	mov    %edx,0x4(%ecx)
  80102c:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
		uint64 data_block = c;
		data_block |= data_block << 8;
		data_block |= data_block << 16;
		data_block |= data_block << 32;

		while(n >= 8)
  801030:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  801034:	77 e2                	ja     801018 <memset+0x57>
			*p64++ = data_block, n -= 8;
	}

	if(n){
  801036:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80103a:	74 23                	je     80105f <memset+0x9e>
		uint8* p8 = (uint8*)p64;
  80103c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80103f:	89 45 f8             	mov    %eax,-0x8(%ebp)
		while (n-- > 0)
  801042:	eb 0e                	jmp    801052 <memset+0x91>
			*p8++ = (uint8)c;
  801044:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801047:	8d 50 01             	lea    0x1(%eax),%edx
  80104a:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80104d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801050:	88 10                	mov    %dl,(%eax)
			*p64++ = data_block, n -= 8;
	}

	if(n){
		uint8* p8 = (uint8*)p64;
		while (n-- > 0)
  801052:	8b 45 10             	mov    0x10(%ebp),%eax
  801055:	8d 50 ff             	lea    -0x1(%eax),%edx
  801058:	89 55 10             	mov    %edx,0x10(%ebp)
  80105b:	85 c0                	test   %eax,%eax
  80105d:	75 e5                	jne    801044 <memset+0x83>
			*p8++ = (uint8)c;
	}

	return v;
  80105f:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801062:	c9                   	leave  
  801063:	c3                   	ret    

00801064 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  801064:	55                   	push   %ebp
  801065:	89 e5                	mov    %esp,%ebp
  801067:	83 ec 10             	sub    $0x10,%esp
	//	s = src;
	//	d = dst;
	//	while (n-- > 0)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
  80106a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80106d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	uint64* d64 = (uint64*)dst;
  801070:	8b 45 08             	mov    0x8(%ebp),%eax
  801073:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if(n >= 8){
  801076:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  80107a:	76 24                	jbe    8010a0 <memcpy+0x3c>
		while(n >= 8){
  80107c:	eb 1c                	jmp    80109a <memcpy+0x36>
			*d64 = *s64;
  80107e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801081:	8b 50 04             	mov    0x4(%eax),%edx
  801084:	8b 00                	mov    (%eax),%eax
  801086:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801089:	89 01                	mov    %eax,(%ecx)
  80108b:	89 51 04             	mov    %edx,0x4(%ecx)
			n -= 8;
  80108e:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
			++s64;
  801092:	83 45 fc 08          	addl   $0x8,-0x4(%ebp)
			++d64;
  801096:	83 45 f8 08          	addl   $0x8,-0x8(%ebp)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
	uint64* d64 = (uint64*)dst;
	if(n >= 8){
		while(n >= 8){
  80109a:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  80109e:	77 de                	ja     80107e <memcpy+0x1a>
			++s64;
			++d64;
		}
	}

	if(n){
  8010a0:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8010a4:	74 31                	je     8010d7 <memcpy+0x73>
		uint8* s8 = (uint8*)s64;
  8010a6:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8010a9:	89 45 f4             	mov    %eax,-0xc(%ebp)
		uint8* d8 = (uint8*)d64;
  8010ac:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010af:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (n-- > 0)
  8010b2:	eb 16                	jmp    8010ca <memcpy+0x66>
			*d8++ = *s8++;
  8010b4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8010b7:	8d 50 01             	lea    0x1(%eax),%edx
  8010ba:	89 55 f0             	mov    %edx,-0x10(%ebp)
  8010bd:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8010c0:	8d 4a 01             	lea    0x1(%edx),%ecx
  8010c3:	89 4d f4             	mov    %ecx,-0xc(%ebp)
  8010c6:	8a 12                	mov    (%edx),%dl
  8010c8:	88 10                	mov    %dl,(%eax)
	}

	if(n){
		uint8* s8 = (uint8*)s64;
		uint8* d8 = (uint8*)d64;
		while (n-- > 0)
  8010ca:	8b 45 10             	mov    0x10(%ebp),%eax
  8010cd:	8d 50 ff             	lea    -0x1(%eax),%edx
  8010d0:	89 55 10             	mov    %edx,0x10(%ebp)
  8010d3:	85 c0                	test   %eax,%eax
  8010d5:	75 dd                	jne    8010b4 <memcpy+0x50>
			*d8++ = *s8++;
	}
	return dst;
  8010d7:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8010da:	c9                   	leave  
  8010db:	c3                   	ret    

008010dc <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  8010dc:	55                   	push   %ebp
  8010dd:	89 e5                	mov    %esp,%ebp
  8010df:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  8010e2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010e5:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  8010e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8010eb:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  8010ee:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8010f1:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8010f4:	73 50                	jae    801146 <memmove+0x6a>
  8010f6:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8010f9:	8b 45 10             	mov    0x10(%ebp),%eax
  8010fc:	01 d0                	add    %edx,%eax
  8010fe:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801101:	76 43                	jbe    801146 <memmove+0x6a>
		s += n;
  801103:	8b 45 10             	mov    0x10(%ebp),%eax
  801106:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  801109:	8b 45 10             	mov    0x10(%ebp),%eax
  80110c:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  80110f:	eb 10                	jmp    801121 <memmove+0x45>
			*--d = *--s;
  801111:	ff 4d f8             	decl   -0x8(%ebp)
  801114:	ff 4d fc             	decl   -0x4(%ebp)
  801117:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80111a:	8a 10                	mov    (%eax),%dl
  80111c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80111f:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  801121:	8b 45 10             	mov    0x10(%ebp),%eax
  801124:	8d 50 ff             	lea    -0x1(%eax),%edx
  801127:	89 55 10             	mov    %edx,0x10(%ebp)
  80112a:	85 c0                	test   %eax,%eax
  80112c:	75 e3                	jne    801111 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  80112e:	eb 23                	jmp    801153 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  801130:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801133:	8d 50 01             	lea    0x1(%eax),%edx
  801136:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801139:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80113c:	8d 4a 01             	lea    0x1(%edx),%ecx
  80113f:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801142:	8a 12                	mov    (%edx),%dl
  801144:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  801146:	8b 45 10             	mov    0x10(%ebp),%eax
  801149:	8d 50 ff             	lea    -0x1(%eax),%edx
  80114c:	89 55 10             	mov    %edx,0x10(%ebp)
  80114f:	85 c0                	test   %eax,%eax
  801151:	75 dd                	jne    801130 <memmove+0x54>
			*d++ = *s++;

	return dst;
  801153:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801156:	c9                   	leave  
  801157:	c3                   	ret    

00801158 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  801158:	55                   	push   %ebp
  801159:	89 e5                	mov    %esp,%ebp
  80115b:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  80115e:	8b 45 08             	mov    0x8(%ebp),%eax
  801161:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  801164:	8b 45 0c             	mov    0xc(%ebp),%eax
  801167:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  80116a:	eb 2a                	jmp    801196 <memcmp+0x3e>
		if (*s1 != *s2)
  80116c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80116f:	8a 10                	mov    (%eax),%dl
  801171:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801174:	8a 00                	mov    (%eax),%al
  801176:	38 c2                	cmp    %al,%dl
  801178:	74 16                	je     801190 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  80117a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80117d:	8a 00                	mov    (%eax),%al
  80117f:	0f b6 d0             	movzbl %al,%edx
  801182:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801185:	8a 00                	mov    (%eax),%al
  801187:	0f b6 c0             	movzbl %al,%eax
  80118a:	29 c2                	sub    %eax,%edx
  80118c:	89 d0                	mov    %edx,%eax
  80118e:	eb 18                	jmp    8011a8 <memcmp+0x50>
		s1++, s2++;
  801190:	ff 45 fc             	incl   -0x4(%ebp)
  801193:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  801196:	8b 45 10             	mov    0x10(%ebp),%eax
  801199:	8d 50 ff             	lea    -0x1(%eax),%edx
  80119c:	89 55 10             	mov    %edx,0x10(%ebp)
  80119f:	85 c0                	test   %eax,%eax
  8011a1:	75 c9                	jne    80116c <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  8011a3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8011a8:	c9                   	leave  
  8011a9:	c3                   	ret    

008011aa <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  8011aa:	55                   	push   %ebp
  8011ab:	89 e5                	mov    %esp,%ebp
  8011ad:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  8011b0:	8b 55 08             	mov    0x8(%ebp),%edx
  8011b3:	8b 45 10             	mov    0x10(%ebp),%eax
  8011b6:	01 d0                	add    %edx,%eax
  8011b8:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  8011bb:	eb 15                	jmp    8011d2 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  8011bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8011c0:	8a 00                	mov    (%eax),%al
  8011c2:	0f b6 d0             	movzbl %al,%edx
  8011c5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011c8:	0f b6 c0             	movzbl %al,%eax
  8011cb:	39 c2                	cmp    %eax,%edx
  8011cd:	74 0d                	je     8011dc <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  8011cf:	ff 45 08             	incl   0x8(%ebp)
  8011d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8011d5:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  8011d8:	72 e3                	jb     8011bd <memfind+0x13>
  8011da:	eb 01                	jmp    8011dd <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  8011dc:	90                   	nop
	return (void *) s;
  8011dd:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8011e0:	c9                   	leave  
  8011e1:	c3                   	ret    

008011e2 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  8011e2:	55                   	push   %ebp
  8011e3:	89 e5                	mov    %esp,%ebp
  8011e5:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  8011e8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  8011ef:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8011f6:	eb 03                	jmp    8011fb <strtol+0x19>
		s++;
  8011f8:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8011fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8011fe:	8a 00                	mov    (%eax),%al
  801200:	3c 20                	cmp    $0x20,%al
  801202:	74 f4                	je     8011f8 <strtol+0x16>
  801204:	8b 45 08             	mov    0x8(%ebp),%eax
  801207:	8a 00                	mov    (%eax),%al
  801209:	3c 09                	cmp    $0x9,%al
  80120b:	74 eb                	je     8011f8 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  80120d:	8b 45 08             	mov    0x8(%ebp),%eax
  801210:	8a 00                	mov    (%eax),%al
  801212:	3c 2b                	cmp    $0x2b,%al
  801214:	75 05                	jne    80121b <strtol+0x39>
		s++;
  801216:	ff 45 08             	incl   0x8(%ebp)
  801219:	eb 13                	jmp    80122e <strtol+0x4c>
	else if (*s == '-')
  80121b:	8b 45 08             	mov    0x8(%ebp),%eax
  80121e:	8a 00                	mov    (%eax),%al
  801220:	3c 2d                	cmp    $0x2d,%al
  801222:	75 0a                	jne    80122e <strtol+0x4c>
		s++, neg = 1;
  801224:	ff 45 08             	incl   0x8(%ebp)
  801227:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  80122e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801232:	74 06                	je     80123a <strtol+0x58>
  801234:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  801238:	75 20                	jne    80125a <strtol+0x78>
  80123a:	8b 45 08             	mov    0x8(%ebp),%eax
  80123d:	8a 00                	mov    (%eax),%al
  80123f:	3c 30                	cmp    $0x30,%al
  801241:	75 17                	jne    80125a <strtol+0x78>
  801243:	8b 45 08             	mov    0x8(%ebp),%eax
  801246:	40                   	inc    %eax
  801247:	8a 00                	mov    (%eax),%al
  801249:	3c 78                	cmp    $0x78,%al
  80124b:	75 0d                	jne    80125a <strtol+0x78>
		s += 2, base = 16;
  80124d:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  801251:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  801258:	eb 28                	jmp    801282 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  80125a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80125e:	75 15                	jne    801275 <strtol+0x93>
  801260:	8b 45 08             	mov    0x8(%ebp),%eax
  801263:	8a 00                	mov    (%eax),%al
  801265:	3c 30                	cmp    $0x30,%al
  801267:	75 0c                	jne    801275 <strtol+0x93>
		s++, base = 8;
  801269:	ff 45 08             	incl   0x8(%ebp)
  80126c:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  801273:	eb 0d                	jmp    801282 <strtol+0xa0>
	else if (base == 0)
  801275:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801279:	75 07                	jne    801282 <strtol+0xa0>
		base = 10;
  80127b:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801282:	8b 45 08             	mov    0x8(%ebp),%eax
  801285:	8a 00                	mov    (%eax),%al
  801287:	3c 2f                	cmp    $0x2f,%al
  801289:	7e 19                	jle    8012a4 <strtol+0xc2>
  80128b:	8b 45 08             	mov    0x8(%ebp),%eax
  80128e:	8a 00                	mov    (%eax),%al
  801290:	3c 39                	cmp    $0x39,%al
  801292:	7f 10                	jg     8012a4 <strtol+0xc2>
			dig = *s - '0';
  801294:	8b 45 08             	mov    0x8(%ebp),%eax
  801297:	8a 00                	mov    (%eax),%al
  801299:	0f be c0             	movsbl %al,%eax
  80129c:	83 e8 30             	sub    $0x30,%eax
  80129f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8012a2:	eb 42                	jmp    8012e6 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  8012a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8012a7:	8a 00                	mov    (%eax),%al
  8012a9:	3c 60                	cmp    $0x60,%al
  8012ab:	7e 19                	jle    8012c6 <strtol+0xe4>
  8012ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8012b0:	8a 00                	mov    (%eax),%al
  8012b2:	3c 7a                	cmp    $0x7a,%al
  8012b4:	7f 10                	jg     8012c6 <strtol+0xe4>
			dig = *s - 'a' + 10;
  8012b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8012b9:	8a 00                	mov    (%eax),%al
  8012bb:	0f be c0             	movsbl %al,%eax
  8012be:	83 e8 57             	sub    $0x57,%eax
  8012c1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8012c4:	eb 20                	jmp    8012e6 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  8012c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8012c9:	8a 00                	mov    (%eax),%al
  8012cb:	3c 40                	cmp    $0x40,%al
  8012cd:	7e 39                	jle    801308 <strtol+0x126>
  8012cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8012d2:	8a 00                	mov    (%eax),%al
  8012d4:	3c 5a                	cmp    $0x5a,%al
  8012d6:	7f 30                	jg     801308 <strtol+0x126>
			dig = *s - 'A' + 10;
  8012d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8012db:	8a 00                	mov    (%eax),%al
  8012dd:	0f be c0             	movsbl %al,%eax
  8012e0:	83 e8 37             	sub    $0x37,%eax
  8012e3:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  8012e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8012e9:	3b 45 10             	cmp    0x10(%ebp),%eax
  8012ec:	7d 19                	jge    801307 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  8012ee:	ff 45 08             	incl   0x8(%ebp)
  8012f1:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8012f4:	0f af 45 10          	imul   0x10(%ebp),%eax
  8012f8:	89 c2                	mov    %eax,%edx
  8012fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8012fd:	01 d0                	add    %edx,%eax
  8012ff:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  801302:	e9 7b ff ff ff       	jmp    801282 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801307:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801308:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80130c:	74 08                	je     801316 <strtol+0x134>
		*endptr = (char *) s;
  80130e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801311:	8b 55 08             	mov    0x8(%ebp),%edx
  801314:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  801316:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80131a:	74 07                	je     801323 <strtol+0x141>
  80131c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80131f:	f7 d8                	neg    %eax
  801321:	eb 03                	jmp    801326 <strtol+0x144>
  801323:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801326:	c9                   	leave  
  801327:	c3                   	ret    

00801328 <ltostr>:

void
ltostr(long value, char *str)
{
  801328:	55                   	push   %ebp
  801329:	89 e5                	mov    %esp,%ebp
  80132b:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  80132e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  801335:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  80133c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801340:	79 13                	jns    801355 <ltostr+0x2d>
	{
		neg = 1;
  801342:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  801349:	8b 45 0c             	mov    0xc(%ebp),%eax
  80134c:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  80134f:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  801352:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  801355:	8b 45 08             	mov    0x8(%ebp),%eax
  801358:	b9 0a 00 00 00       	mov    $0xa,%ecx
  80135d:	99                   	cltd   
  80135e:	f7 f9                	idiv   %ecx
  801360:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  801363:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801366:	8d 50 01             	lea    0x1(%eax),%edx
  801369:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80136c:	89 c2                	mov    %eax,%edx
  80136e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801371:	01 d0                	add    %edx,%eax
  801373:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801376:	83 c2 30             	add    $0x30,%edx
  801379:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  80137b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80137e:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801383:	f7 e9                	imul   %ecx
  801385:	c1 fa 02             	sar    $0x2,%edx
  801388:	89 c8                	mov    %ecx,%eax
  80138a:	c1 f8 1f             	sar    $0x1f,%eax
  80138d:	29 c2                	sub    %eax,%edx
  80138f:	89 d0                	mov    %edx,%eax
  801391:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  801394:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801398:	75 bb                	jne    801355 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  80139a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  8013a1:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8013a4:	48                   	dec    %eax
  8013a5:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  8013a8:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8013ac:	74 3d                	je     8013eb <ltostr+0xc3>
		start = 1 ;
  8013ae:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  8013b5:	eb 34                	jmp    8013eb <ltostr+0xc3>
	{
		char tmp = str[start] ;
  8013b7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8013ba:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013bd:	01 d0                	add    %edx,%eax
  8013bf:	8a 00                	mov    (%eax),%al
  8013c1:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  8013c4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8013c7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013ca:	01 c2                	add    %eax,%edx
  8013cc:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  8013cf:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013d2:	01 c8                	add    %ecx,%eax
  8013d4:	8a 00                	mov    (%eax),%al
  8013d6:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  8013d8:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8013db:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013de:	01 c2                	add    %eax,%edx
  8013e0:	8a 45 eb             	mov    -0x15(%ebp),%al
  8013e3:	88 02                	mov    %al,(%edx)
		start++ ;
  8013e5:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  8013e8:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  8013eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8013ee:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8013f1:	7c c4                	jl     8013b7 <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  8013f3:	8b 55 f8             	mov    -0x8(%ebp),%edx
  8013f6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013f9:	01 d0                	add    %edx,%eax
  8013fb:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  8013fe:	90                   	nop
  8013ff:	c9                   	leave  
  801400:	c3                   	ret    

00801401 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  801401:	55                   	push   %ebp
  801402:	89 e5                	mov    %esp,%ebp
  801404:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801407:	ff 75 08             	pushl  0x8(%ebp)
  80140a:	e8 c4 f9 ff ff       	call   800dd3 <strlen>
  80140f:	83 c4 04             	add    $0x4,%esp
  801412:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  801415:	ff 75 0c             	pushl  0xc(%ebp)
  801418:	e8 b6 f9 ff ff       	call   800dd3 <strlen>
  80141d:	83 c4 04             	add    $0x4,%esp
  801420:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  801423:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  80142a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801431:	eb 17                	jmp    80144a <strcconcat+0x49>
		final[s] = str1[s] ;
  801433:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801436:	8b 45 10             	mov    0x10(%ebp),%eax
  801439:	01 c2                	add    %eax,%edx
  80143b:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  80143e:	8b 45 08             	mov    0x8(%ebp),%eax
  801441:	01 c8                	add    %ecx,%eax
  801443:	8a 00                	mov    (%eax),%al
  801445:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  801447:	ff 45 fc             	incl   -0x4(%ebp)
  80144a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80144d:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801450:	7c e1                	jl     801433 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  801452:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  801459:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  801460:	eb 1f                	jmp    801481 <strcconcat+0x80>
		final[s++] = str2[i] ;
  801462:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801465:	8d 50 01             	lea    0x1(%eax),%edx
  801468:	89 55 fc             	mov    %edx,-0x4(%ebp)
  80146b:	89 c2                	mov    %eax,%edx
  80146d:	8b 45 10             	mov    0x10(%ebp),%eax
  801470:	01 c2                	add    %eax,%edx
  801472:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801475:	8b 45 0c             	mov    0xc(%ebp),%eax
  801478:	01 c8                	add    %ecx,%eax
  80147a:	8a 00                	mov    (%eax),%al
  80147c:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  80147e:	ff 45 f8             	incl   -0x8(%ebp)
  801481:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801484:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801487:	7c d9                	jl     801462 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801489:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80148c:	8b 45 10             	mov    0x10(%ebp),%eax
  80148f:	01 d0                	add    %edx,%eax
  801491:	c6 00 00             	movb   $0x0,(%eax)
}
  801494:	90                   	nop
  801495:	c9                   	leave  
  801496:	c3                   	ret    

00801497 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801497:	55                   	push   %ebp
  801498:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  80149a:	8b 45 14             	mov    0x14(%ebp),%eax
  80149d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  8014a3:	8b 45 14             	mov    0x14(%ebp),%eax
  8014a6:	8b 00                	mov    (%eax),%eax
  8014a8:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8014af:	8b 45 10             	mov    0x10(%ebp),%eax
  8014b2:	01 d0                	add    %edx,%eax
  8014b4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8014ba:	eb 0c                	jmp    8014c8 <strsplit+0x31>
			*string++ = 0;
  8014bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8014bf:	8d 50 01             	lea    0x1(%eax),%edx
  8014c2:	89 55 08             	mov    %edx,0x8(%ebp)
  8014c5:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8014c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8014cb:	8a 00                	mov    (%eax),%al
  8014cd:	84 c0                	test   %al,%al
  8014cf:	74 18                	je     8014e9 <strsplit+0x52>
  8014d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8014d4:	8a 00                	mov    (%eax),%al
  8014d6:	0f be c0             	movsbl %al,%eax
  8014d9:	50                   	push   %eax
  8014da:	ff 75 0c             	pushl  0xc(%ebp)
  8014dd:	e8 83 fa ff ff       	call   800f65 <strchr>
  8014e2:	83 c4 08             	add    $0x8,%esp
  8014e5:	85 c0                	test   %eax,%eax
  8014e7:	75 d3                	jne    8014bc <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  8014e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8014ec:	8a 00                	mov    (%eax),%al
  8014ee:	84 c0                	test   %al,%al
  8014f0:	74 5a                	je     80154c <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  8014f2:	8b 45 14             	mov    0x14(%ebp),%eax
  8014f5:	8b 00                	mov    (%eax),%eax
  8014f7:	83 f8 0f             	cmp    $0xf,%eax
  8014fa:	75 07                	jne    801503 <strsplit+0x6c>
		{
			return 0;
  8014fc:	b8 00 00 00 00       	mov    $0x0,%eax
  801501:	eb 66                	jmp    801569 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801503:	8b 45 14             	mov    0x14(%ebp),%eax
  801506:	8b 00                	mov    (%eax),%eax
  801508:	8d 48 01             	lea    0x1(%eax),%ecx
  80150b:	8b 55 14             	mov    0x14(%ebp),%edx
  80150e:	89 0a                	mov    %ecx,(%edx)
  801510:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801517:	8b 45 10             	mov    0x10(%ebp),%eax
  80151a:	01 c2                	add    %eax,%edx
  80151c:	8b 45 08             	mov    0x8(%ebp),%eax
  80151f:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801521:	eb 03                	jmp    801526 <strsplit+0x8f>
			string++;
  801523:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801526:	8b 45 08             	mov    0x8(%ebp),%eax
  801529:	8a 00                	mov    (%eax),%al
  80152b:	84 c0                	test   %al,%al
  80152d:	74 8b                	je     8014ba <strsplit+0x23>
  80152f:	8b 45 08             	mov    0x8(%ebp),%eax
  801532:	8a 00                	mov    (%eax),%al
  801534:	0f be c0             	movsbl %al,%eax
  801537:	50                   	push   %eax
  801538:	ff 75 0c             	pushl  0xc(%ebp)
  80153b:	e8 25 fa ff ff       	call   800f65 <strchr>
  801540:	83 c4 08             	add    $0x8,%esp
  801543:	85 c0                	test   %eax,%eax
  801545:	74 dc                	je     801523 <strsplit+0x8c>
			string++;
	}
  801547:	e9 6e ff ff ff       	jmp    8014ba <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  80154c:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  80154d:	8b 45 14             	mov    0x14(%ebp),%eax
  801550:	8b 00                	mov    (%eax),%eax
  801552:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801559:	8b 45 10             	mov    0x10(%ebp),%eax
  80155c:	01 d0                	add    %edx,%eax
  80155e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801564:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801569:	c9                   	leave  
  80156a:	c3                   	ret    

0080156b <str2lower>:


char* str2lower(char *dst, const char *src)
{
  80156b:	55                   	push   %ebp
  80156c:	89 e5                	mov    %esp,%ebp
  80156e:	83 ec 10             	sub    $0x10,%esp
	char* ret = dst;
  801571:	8b 45 08             	mov    0x8(%ebp),%eax
  801574:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (int i = 0; i < strlen(src); ++i)
  801577:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80157e:	eb 4a                	jmp    8015ca <str2lower+0x5f>
	{
		dst[i] = src[i] ;
  801580:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801583:	8b 45 08             	mov    0x8(%ebp),%eax
  801586:	01 c2                	add    %eax,%edx
  801588:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  80158b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80158e:	01 c8                	add    %ecx,%eax
  801590:	8a 00                	mov    (%eax),%al
  801592:	88 02                	mov    %al,(%edx)
		if (src[i] >= 'A' && src[i] <= 'Z')
  801594:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801597:	8b 45 0c             	mov    0xc(%ebp),%eax
  80159a:	01 d0                	add    %edx,%eax
  80159c:	8a 00                	mov    (%eax),%al
  80159e:	3c 40                	cmp    $0x40,%al
  8015a0:	7e 25                	jle    8015c7 <str2lower+0x5c>
  8015a2:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8015a5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015a8:	01 d0                	add    %edx,%eax
  8015aa:	8a 00                	mov    (%eax),%al
  8015ac:	3c 5a                	cmp    $0x5a,%al
  8015ae:	7f 17                	jg     8015c7 <str2lower+0x5c>
		{
			dst[i] += 32 ;
  8015b0:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8015b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8015b6:	01 d0                	add    %edx,%eax
  8015b8:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8015bb:	8b 55 08             	mov    0x8(%ebp),%edx
  8015be:	01 ca                	add    %ecx,%edx
  8015c0:	8a 12                	mov    (%edx),%dl
  8015c2:	83 c2 20             	add    $0x20,%edx
  8015c5:	88 10                	mov    %dl,(%eax)


char* str2lower(char *dst, const char *src)
{
	char* ret = dst;
	for (int i = 0; i < strlen(src); ++i)
  8015c7:	ff 45 fc             	incl   -0x4(%ebp)
  8015ca:	ff 75 0c             	pushl  0xc(%ebp)
  8015cd:	e8 01 f8 ff ff       	call   800dd3 <strlen>
  8015d2:	83 c4 04             	add    $0x4,%esp
  8015d5:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  8015d8:	7f a6                	jg     801580 <str2lower+0x15>
		if (src[i] >= 'A' && src[i] <= 'Z')
		{
			dst[i] += 32 ;
		}
	}
	return ret;
  8015da:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8015dd:	c9                   	leave  
  8015de:	c3                   	ret    

008015df <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  8015df:	55                   	push   %ebp
  8015e0:	89 e5                	mov    %esp,%ebp
  8015e2:	57                   	push   %edi
  8015e3:	56                   	push   %esi
  8015e4:	53                   	push   %ebx
  8015e5:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8015e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8015eb:	8b 55 0c             	mov    0xc(%ebp),%edx
  8015ee:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8015f1:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8015f4:	8b 7d 18             	mov    0x18(%ebp),%edi
  8015f7:	8b 75 1c             	mov    0x1c(%ebp),%esi
  8015fa:	cd 30                	int    $0x30
  8015fc:	89 45 f0             	mov    %eax,-0x10(%ebp)
				"b" (a3),
				"D" (a4),
				"S" (a5)
				: "cc", "memory");

	return ret;
  8015ff:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801602:	83 c4 10             	add    $0x10,%esp
  801605:	5b                   	pop    %ebx
  801606:	5e                   	pop    %esi
  801607:	5f                   	pop    %edi
  801608:	5d                   	pop    %ebp
  801609:	c3                   	ret    

0080160a <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName, int color)
{
  80160a:	55                   	push   %ebp
  80160b:	89 e5                	mov    %esp,%ebp
  80160d:	83 ec 04             	sub    $0x4,%esp
  801610:	8b 45 10             	mov    0x10(%ebp),%eax
  801613:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, color, 0);
  801616:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801619:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80161d:	8b 45 08             	mov    0x8(%ebp),%eax
  801620:	6a 00                	push   $0x0
  801622:	51                   	push   %ecx
  801623:	52                   	push   %edx
  801624:	ff 75 0c             	pushl  0xc(%ebp)
  801627:	50                   	push   %eax
  801628:	6a 00                	push   $0x0
  80162a:	e8 b0 ff ff ff       	call   8015df <syscall>
  80162f:	83 c4 18             	add    $0x18,%esp
}
  801632:	90                   	nop
  801633:	c9                   	leave  
  801634:	c3                   	ret    

00801635 <sys_cgetc>:

int
sys_cgetc(void)
{
  801635:	55                   	push   %ebp
  801636:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801638:	6a 00                	push   $0x0
  80163a:	6a 00                	push   $0x0
  80163c:	6a 00                	push   $0x0
  80163e:	6a 00                	push   $0x0
  801640:	6a 00                	push   $0x0
  801642:	6a 02                	push   $0x2
  801644:	e8 96 ff ff ff       	call   8015df <syscall>
  801649:	83 c4 18             	add    $0x18,%esp
}
  80164c:	c9                   	leave  
  80164d:	c3                   	ret    

0080164e <sys_lock_cons>:

void sys_lock_cons(void)
{
  80164e:	55                   	push   %ebp
  80164f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  801651:	6a 00                	push   $0x0
  801653:	6a 00                	push   $0x0
  801655:	6a 00                	push   $0x0
  801657:	6a 00                	push   $0x0
  801659:	6a 00                	push   $0x0
  80165b:	6a 03                	push   $0x3
  80165d:	e8 7d ff ff ff       	call   8015df <syscall>
  801662:	83 c4 18             	add    $0x18,%esp
}
  801665:	90                   	nop
  801666:	c9                   	leave  
  801667:	c3                   	ret    

00801668 <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  801668:	55                   	push   %ebp
  801669:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  80166b:	6a 00                	push   $0x0
  80166d:	6a 00                	push   $0x0
  80166f:	6a 00                	push   $0x0
  801671:	6a 00                	push   $0x0
  801673:	6a 00                	push   $0x0
  801675:	6a 04                	push   $0x4
  801677:	e8 63 ff ff ff       	call   8015df <syscall>
  80167c:	83 c4 18             	add    $0x18,%esp
}
  80167f:	90                   	nop
  801680:	c9                   	leave  
  801681:	c3                   	ret    

00801682 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801682:	55                   	push   %ebp
  801683:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801685:	8b 55 0c             	mov    0xc(%ebp),%edx
  801688:	8b 45 08             	mov    0x8(%ebp),%eax
  80168b:	6a 00                	push   $0x0
  80168d:	6a 00                	push   $0x0
  80168f:	6a 00                	push   $0x0
  801691:	52                   	push   %edx
  801692:	50                   	push   %eax
  801693:	6a 08                	push   $0x8
  801695:	e8 45 ff ff ff       	call   8015df <syscall>
  80169a:	83 c4 18             	add    $0x18,%esp
}
  80169d:	c9                   	leave  
  80169e:	c3                   	ret    

0080169f <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  80169f:	55                   	push   %ebp
  8016a0:	89 e5                	mov    %esp,%ebp
  8016a2:	56                   	push   %esi
  8016a3:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  8016a4:	8b 75 18             	mov    0x18(%ebp),%esi
  8016a7:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8016aa:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8016ad:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8016b3:	56                   	push   %esi
  8016b4:	53                   	push   %ebx
  8016b5:	51                   	push   %ecx
  8016b6:	52                   	push   %edx
  8016b7:	50                   	push   %eax
  8016b8:	6a 09                	push   $0x9
  8016ba:	e8 20 ff ff ff       	call   8015df <syscall>
  8016bf:	83 c4 18             	add    $0x18,%esp
}
  8016c2:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8016c5:	5b                   	pop    %ebx
  8016c6:	5e                   	pop    %esi
  8016c7:	5d                   	pop    %ebp
  8016c8:	c3                   	ret    

008016c9 <__sys_unmap_frame>:

int __sys_unmap_frame(uint32 va)
{
  8016c9:	55                   	push   %ebp
  8016ca:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, va, 0, 0, 0, 0);
  8016cc:	6a 00                	push   $0x0
  8016ce:	6a 00                	push   $0x0
  8016d0:	6a 00                	push   $0x0
  8016d2:	6a 00                	push   $0x0
  8016d4:	ff 75 08             	pushl  0x8(%ebp)
  8016d7:	6a 0a                	push   $0xa
  8016d9:	e8 01 ff ff ff       	call   8015df <syscall>
  8016de:	83 c4 18             	add    $0x18,%esp
}
  8016e1:	c9                   	leave  
  8016e2:	c3                   	ret    

008016e3 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  8016e3:	55                   	push   %ebp
  8016e4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  8016e6:	6a 00                	push   $0x0
  8016e8:	6a 00                	push   $0x0
  8016ea:	6a 00                	push   $0x0
  8016ec:	ff 75 0c             	pushl  0xc(%ebp)
  8016ef:	ff 75 08             	pushl  0x8(%ebp)
  8016f2:	6a 0b                	push   $0xb
  8016f4:	e8 e6 fe ff ff       	call   8015df <syscall>
  8016f9:	83 c4 18             	add    $0x18,%esp
}
  8016fc:	c9                   	leave  
  8016fd:	c3                   	ret    

008016fe <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  8016fe:	55                   	push   %ebp
  8016ff:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801701:	6a 00                	push   $0x0
  801703:	6a 00                	push   $0x0
  801705:	6a 00                	push   $0x0
  801707:	6a 00                	push   $0x0
  801709:	6a 00                	push   $0x0
  80170b:	6a 0c                	push   $0xc
  80170d:	e8 cd fe ff ff       	call   8015df <syscall>
  801712:	83 c4 18             	add    $0x18,%esp
}
  801715:	c9                   	leave  
  801716:	c3                   	ret    

00801717 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801717:	55                   	push   %ebp
  801718:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  80171a:	6a 00                	push   $0x0
  80171c:	6a 00                	push   $0x0
  80171e:	6a 00                	push   $0x0
  801720:	6a 00                	push   $0x0
  801722:	6a 00                	push   $0x0
  801724:	6a 0d                	push   $0xd
  801726:	e8 b4 fe ff ff       	call   8015df <syscall>
  80172b:	83 c4 18             	add    $0x18,%esp
}
  80172e:	c9                   	leave  
  80172f:	c3                   	ret    

00801730 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801730:	55                   	push   %ebp
  801731:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801733:	6a 00                	push   $0x0
  801735:	6a 00                	push   $0x0
  801737:	6a 00                	push   $0x0
  801739:	6a 00                	push   $0x0
  80173b:	6a 00                	push   $0x0
  80173d:	6a 0e                	push   $0xe
  80173f:	e8 9b fe ff ff       	call   8015df <syscall>
  801744:	83 c4 18             	add    $0x18,%esp
}
  801747:	c9                   	leave  
  801748:	c3                   	ret    

00801749 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801749:	55                   	push   %ebp
  80174a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  80174c:	6a 00                	push   $0x0
  80174e:	6a 00                	push   $0x0
  801750:	6a 00                	push   $0x0
  801752:	6a 00                	push   $0x0
  801754:	6a 00                	push   $0x0
  801756:	6a 0f                	push   $0xf
  801758:	e8 82 fe ff ff       	call   8015df <syscall>
  80175d:	83 c4 18             	add    $0x18,%esp
}
  801760:	c9                   	leave  
  801761:	c3                   	ret    

00801762 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801762:	55                   	push   %ebp
  801763:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801765:	6a 00                	push   $0x0
  801767:	6a 00                	push   $0x0
  801769:	6a 00                	push   $0x0
  80176b:	6a 00                	push   $0x0
  80176d:	ff 75 08             	pushl  0x8(%ebp)
  801770:	6a 10                	push   $0x10
  801772:	e8 68 fe ff ff       	call   8015df <syscall>
  801777:	83 c4 18             	add    $0x18,%esp
}
  80177a:	c9                   	leave  
  80177b:	c3                   	ret    

0080177c <sys_scarce_memory>:

void sys_scarce_memory()
{
  80177c:	55                   	push   %ebp
  80177d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  80177f:	6a 00                	push   $0x0
  801781:	6a 00                	push   $0x0
  801783:	6a 00                	push   $0x0
  801785:	6a 00                	push   $0x0
  801787:	6a 00                	push   $0x0
  801789:	6a 11                	push   $0x11
  80178b:	e8 4f fe ff ff       	call   8015df <syscall>
  801790:	83 c4 18             	add    $0x18,%esp
}
  801793:	90                   	nop
  801794:	c9                   	leave  
  801795:	c3                   	ret    

00801796 <sys_cputc>:

void
sys_cputc(const char c)
{
  801796:	55                   	push   %ebp
  801797:	89 e5                	mov    %esp,%ebp
  801799:	83 ec 04             	sub    $0x4,%esp
  80179c:	8b 45 08             	mov    0x8(%ebp),%eax
  80179f:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  8017a2:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8017a6:	6a 00                	push   $0x0
  8017a8:	6a 00                	push   $0x0
  8017aa:	6a 00                	push   $0x0
  8017ac:	6a 00                	push   $0x0
  8017ae:	50                   	push   %eax
  8017af:	6a 01                	push   $0x1
  8017b1:	e8 29 fe ff ff       	call   8015df <syscall>
  8017b6:	83 c4 18             	add    $0x18,%esp
}
  8017b9:	90                   	nop
  8017ba:	c9                   	leave  
  8017bb:	c3                   	ret    

008017bc <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  8017bc:	55                   	push   %ebp
  8017bd:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  8017bf:	6a 00                	push   $0x0
  8017c1:	6a 00                	push   $0x0
  8017c3:	6a 00                	push   $0x0
  8017c5:	6a 00                	push   $0x0
  8017c7:	6a 00                	push   $0x0
  8017c9:	6a 14                	push   $0x14
  8017cb:	e8 0f fe ff ff       	call   8015df <syscall>
  8017d0:	83 c4 18             	add    $0x18,%esp
}
  8017d3:	90                   	nop
  8017d4:	c9                   	leave  
  8017d5:	c3                   	ret    

008017d6 <sys_create_shared_object>:

int sys_create_shared_object(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  8017d6:	55                   	push   %ebp
  8017d7:	89 e5                	mov    %esp,%ebp
  8017d9:	83 ec 04             	sub    $0x4,%esp
  8017dc:	8b 45 10             	mov    0x10(%ebp),%eax
  8017df:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  8017e2:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8017e5:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8017e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8017ec:	6a 00                	push   $0x0
  8017ee:	51                   	push   %ecx
  8017ef:	52                   	push   %edx
  8017f0:	ff 75 0c             	pushl  0xc(%ebp)
  8017f3:	50                   	push   %eax
  8017f4:	6a 15                	push   $0x15
  8017f6:	e8 e4 fd ff ff       	call   8015df <syscall>
  8017fb:	83 c4 18             	add    $0x18,%esp
}
  8017fe:	c9                   	leave  
  8017ff:	c3                   	ret    

00801800 <sys_size_of_shared_object>:

//2017:
int sys_size_of_shared_object(int32 ownerID, char* shareName)
{
  801800:	55                   	push   %ebp
  801801:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801803:	8b 55 0c             	mov    0xc(%ebp),%edx
  801806:	8b 45 08             	mov    0x8(%ebp),%eax
  801809:	6a 00                	push   $0x0
  80180b:	6a 00                	push   $0x0
  80180d:	6a 00                	push   $0x0
  80180f:	52                   	push   %edx
  801810:	50                   	push   %eax
  801811:	6a 16                	push   $0x16
  801813:	e8 c7 fd ff ff       	call   8015df <syscall>
  801818:	83 c4 18             	add    $0x18,%esp
}
  80181b:	c9                   	leave  
  80181c:	c3                   	ret    

0080181d <sys_get_shared_object>:
//==========

int sys_get_shared_object(int32 ownerID, char* shareName, void* virtual_address)
{
  80181d:	55                   	push   %ebp
  80181e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801820:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801823:	8b 55 0c             	mov    0xc(%ebp),%edx
  801826:	8b 45 08             	mov    0x8(%ebp),%eax
  801829:	6a 00                	push   $0x0
  80182b:	6a 00                	push   $0x0
  80182d:	51                   	push   %ecx
  80182e:	52                   	push   %edx
  80182f:	50                   	push   %eax
  801830:	6a 17                	push   $0x17
  801832:	e8 a8 fd ff ff       	call   8015df <syscall>
  801837:	83 c4 18             	add    $0x18,%esp
}
  80183a:	c9                   	leave  
  80183b:	c3                   	ret    

0080183c <sys_delete_shared_object>:

int sys_delete_shared_object(int32 sharedObjectID, void *startVA)
{
  80183c:	55                   	push   %ebp
  80183d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  80183f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801842:	8b 45 08             	mov    0x8(%ebp),%eax
  801845:	6a 00                	push   $0x0
  801847:	6a 00                	push   $0x0
  801849:	6a 00                	push   $0x0
  80184b:	52                   	push   %edx
  80184c:	50                   	push   %eax
  80184d:	6a 18                	push   $0x18
  80184f:	e8 8b fd ff ff       	call   8015df <syscall>
  801854:	83 c4 18             	add    $0x18,%esp
}
  801857:	c9                   	leave  
  801858:	c3                   	ret    

00801859 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801859:	55                   	push   %ebp
  80185a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  80185c:	8b 45 08             	mov    0x8(%ebp),%eax
  80185f:	6a 00                	push   $0x0
  801861:	ff 75 14             	pushl  0x14(%ebp)
  801864:	ff 75 10             	pushl  0x10(%ebp)
  801867:	ff 75 0c             	pushl  0xc(%ebp)
  80186a:	50                   	push   %eax
  80186b:	6a 19                	push   $0x19
  80186d:	e8 6d fd ff ff       	call   8015df <syscall>
  801872:	83 c4 18             	add    $0x18,%esp
}
  801875:	c9                   	leave  
  801876:	c3                   	ret    

00801877 <sys_run_env>:

void sys_run_env(int32 envId)
{
  801877:	55                   	push   %ebp
  801878:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  80187a:	8b 45 08             	mov    0x8(%ebp),%eax
  80187d:	6a 00                	push   $0x0
  80187f:	6a 00                	push   $0x0
  801881:	6a 00                	push   $0x0
  801883:	6a 00                	push   $0x0
  801885:	50                   	push   %eax
  801886:	6a 1a                	push   $0x1a
  801888:	e8 52 fd ff ff       	call   8015df <syscall>
  80188d:	83 c4 18             	add    $0x18,%esp
}
  801890:	90                   	nop
  801891:	c9                   	leave  
  801892:	c3                   	ret    

00801893 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801893:	55                   	push   %ebp
  801894:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801896:	8b 45 08             	mov    0x8(%ebp),%eax
  801899:	6a 00                	push   $0x0
  80189b:	6a 00                	push   $0x0
  80189d:	6a 00                	push   $0x0
  80189f:	6a 00                	push   $0x0
  8018a1:	50                   	push   %eax
  8018a2:	6a 1b                	push   $0x1b
  8018a4:	e8 36 fd ff ff       	call   8015df <syscall>
  8018a9:	83 c4 18             	add    $0x18,%esp
}
  8018ac:	c9                   	leave  
  8018ad:	c3                   	ret    

008018ae <sys_getenvid>:

int32 sys_getenvid(void)
{
  8018ae:	55                   	push   %ebp
  8018af:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  8018b1:	6a 00                	push   $0x0
  8018b3:	6a 00                	push   $0x0
  8018b5:	6a 00                	push   $0x0
  8018b7:	6a 00                	push   $0x0
  8018b9:	6a 00                	push   $0x0
  8018bb:	6a 05                	push   $0x5
  8018bd:	e8 1d fd ff ff       	call   8015df <syscall>
  8018c2:	83 c4 18             	add    $0x18,%esp
}
  8018c5:	c9                   	leave  
  8018c6:	c3                   	ret    

008018c7 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  8018c7:	55                   	push   %ebp
  8018c8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  8018ca:	6a 00                	push   $0x0
  8018cc:	6a 00                	push   $0x0
  8018ce:	6a 00                	push   $0x0
  8018d0:	6a 00                	push   $0x0
  8018d2:	6a 00                	push   $0x0
  8018d4:	6a 06                	push   $0x6
  8018d6:	e8 04 fd ff ff       	call   8015df <syscall>
  8018db:	83 c4 18             	add    $0x18,%esp
}
  8018de:	c9                   	leave  
  8018df:	c3                   	ret    

008018e0 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  8018e0:	55                   	push   %ebp
  8018e1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  8018e3:	6a 00                	push   $0x0
  8018e5:	6a 00                	push   $0x0
  8018e7:	6a 00                	push   $0x0
  8018e9:	6a 00                	push   $0x0
  8018eb:	6a 00                	push   $0x0
  8018ed:	6a 07                	push   $0x7
  8018ef:	e8 eb fc ff ff       	call   8015df <syscall>
  8018f4:	83 c4 18             	add    $0x18,%esp
}
  8018f7:	c9                   	leave  
  8018f8:	c3                   	ret    

008018f9 <sys_exit_env>:


void sys_exit_env(void)
{
  8018f9:	55                   	push   %ebp
  8018fa:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  8018fc:	6a 00                	push   $0x0
  8018fe:	6a 00                	push   $0x0
  801900:	6a 00                	push   $0x0
  801902:	6a 00                	push   $0x0
  801904:	6a 00                	push   $0x0
  801906:	6a 1c                	push   $0x1c
  801908:	e8 d2 fc ff ff       	call   8015df <syscall>
  80190d:	83 c4 18             	add    $0x18,%esp
}
  801910:	90                   	nop
  801911:	c9                   	leave  
  801912:	c3                   	ret    

00801913 <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  801913:	55                   	push   %ebp
  801914:	89 e5                	mov    %esp,%ebp
  801916:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801919:	8d 45 f8             	lea    -0x8(%ebp),%eax
  80191c:	8d 50 04             	lea    0x4(%eax),%edx
  80191f:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801922:	6a 00                	push   $0x0
  801924:	6a 00                	push   $0x0
  801926:	6a 00                	push   $0x0
  801928:	52                   	push   %edx
  801929:	50                   	push   %eax
  80192a:	6a 1d                	push   $0x1d
  80192c:	e8 ae fc ff ff       	call   8015df <syscall>
  801931:	83 c4 18             	add    $0x18,%esp
	return result;
  801934:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801937:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80193a:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80193d:	89 01                	mov    %eax,(%ecx)
  80193f:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801942:	8b 45 08             	mov    0x8(%ebp),%eax
  801945:	c9                   	leave  
  801946:	c2 04 00             	ret    $0x4

00801949 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801949:	55                   	push   %ebp
  80194a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  80194c:	6a 00                	push   $0x0
  80194e:	6a 00                	push   $0x0
  801950:	ff 75 10             	pushl  0x10(%ebp)
  801953:	ff 75 0c             	pushl  0xc(%ebp)
  801956:	ff 75 08             	pushl  0x8(%ebp)
  801959:	6a 13                	push   $0x13
  80195b:	e8 7f fc ff ff       	call   8015df <syscall>
  801960:	83 c4 18             	add    $0x18,%esp
	return ;
  801963:	90                   	nop
}
  801964:	c9                   	leave  
  801965:	c3                   	ret    

00801966 <sys_rcr2>:
uint32 sys_rcr2()
{
  801966:	55                   	push   %ebp
  801967:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801969:	6a 00                	push   $0x0
  80196b:	6a 00                	push   $0x0
  80196d:	6a 00                	push   $0x0
  80196f:	6a 00                	push   $0x0
  801971:	6a 00                	push   $0x0
  801973:	6a 1e                	push   $0x1e
  801975:	e8 65 fc ff ff       	call   8015df <syscall>
  80197a:	83 c4 18             	add    $0x18,%esp
}
  80197d:	c9                   	leave  
  80197e:	c3                   	ret    

0080197f <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  80197f:	55                   	push   %ebp
  801980:	89 e5                	mov    %esp,%ebp
  801982:	83 ec 04             	sub    $0x4,%esp
  801985:	8b 45 08             	mov    0x8(%ebp),%eax
  801988:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  80198b:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  80198f:	6a 00                	push   $0x0
  801991:	6a 00                	push   $0x0
  801993:	6a 00                	push   $0x0
  801995:	6a 00                	push   $0x0
  801997:	50                   	push   %eax
  801998:	6a 1f                	push   $0x1f
  80199a:	e8 40 fc ff ff       	call   8015df <syscall>
  80199f:	83 c4 18             	add    $0x18,%esp
	return ;
  8019a2:	90                   	nop
}
  8019a3:	c9                   	leave  
  8019a4:	c3                   	ret    

008019a5 <rsttst>:
void rsttst()
{
  8019a5:	55                   	push   %ebp
  8019a6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  8019a8:	6a 00                	push   $0x0
  8019aa:	6a 00                	push   $0x0
  8019ac:	6a 00                	push   $0x0
  8019ae:	6a 00                	push   $0x0
  8019b0:	6a 00                	push   $0x0
  8019b2:	6a 21                	push   $0x21
  8019b4:	e8 26 fc ff ff       	call   8015df <syscall>
  8019b9:	83 c4 18             	add    $0x18,%esp
	return ;
  8019bc:	90                   	nop
}
  8019bd:	c9                   	leave  
  8019be:	c3                   	ret    

008019bf <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  8019bf:	55                   	push   %ebp
  8019c0:	89 e5                	mov    %esp,%ebp
  8019c2:	83 ec 04             	sub    $0x4,%esp
  8019c5:	8b 45 14             	mov    0x14(%ebp),%eax
  8019c8:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  8019cb:	8b 55 18             	mov    0x18(%ebp),%edx
  8019ce:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8019d2:	52                   	push   %edx
  8019d3:	50                   	push   %eax
  8019d4:	ff 75 10             	pushl  0x10(%ebp)
  8019d7:	ff 75 0c             	pushl  0xc(%ebp)
  8019da:	ff 75 08             	pushl  0x8(%ebp)
  8019dd:	6a 20                	push   $0x20
  8019df:	e8 fb fb ff ff       	call   8015df <syscall>
  8019e4:	83 c4 18             	add    $0x18,%esp
	return ;
  8019e7:	90                   	nop
}
  8019e8:	c9                   	leave  
  8019e9:	c3                   	ret    

008019ea <chktst>:
void chktst(uint32 n)
{
  8019ea:	55                   	push   %ebp
  8019eb:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  8019ed:	6a 00                	push   $0x0
  8019ef:	6a 00                	push   $0x0
  8019f1:	6a 00                	push   $0x0
  8019f3:	6a 00                	push   $0x0
  8019f5:	ff 75 08             	pushl  0x8(%ebp)
  8019f8:	6a 22                	push   $0x22
  8019fa:	e8 e0 fb ff ff       	call   8015df <syscall>
  8019ff:	83 c4 18             	add    $0x18,%esp
	return ;
  801a02:	90                   	nop
}
  801a03:	c9                   	leave  
  801a04:	c3                   	ret    

00801a05 <inctst>:

void inctst()
{
  801a05:	55                   	push   %ebp
  801a06:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801a08:	6a 00                	push   $0x0
  801a0a:	6a 00                	push   $0x0
  801a0c:	6a 00                	push   $0x0
  801a0e:	6a 00                	push   $0x0
  801a10:	6a 00                	push   $0x0
  801a12:	6a 23                	push   $0x23
  801a14:	e8 c6 fb ff ff       	call   8015df <syscall>
  801a19:	83 c4 18             	add    $0x18,%esp
	return ;
  801a1c:	90                   	nop
}
  801a1d:	c9                   	leave  
  801a1e:	c3                   	ret    

00801a1f <gettst>:
uint32 gettst()
{
  801a1f:	55                   	push   %ebp
  801a20:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801a22:	6a 00                	push   $0x0
  801a24:	6a 00                	push   $0x0
  801a26:	6a 00                	push   $0x0
  801a28:	6a 00                	push   $0x0
  801a2a:	6a 00                	push   $0x0
  801a2c:	6a 24                	push   $0x24
  801a2e:	e8 ac fb ff ff       	call   8015df <syscall>
  801a33:	83 c4 18             	add    $0x18,%esp
}
  801a36:	c9                   	leave  
  801a37:	c3                   	ret    

00801a38 <sys_get_uheap_strategy>:

/*2025*/
uint32 sys_get_uheap_strategy()
{
  801a38:	55                   	push   %ebp
  801a39:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801a3b:	6a 00                	push   $0x0
  801a3d:	6a 00                	push   $0x0
  801a3f:	6a 00                	push   $0x0
  801a41:	6a 00                	push   $0x0
  801a43:	6a 00                	push   $0x0
  801a45:	6a 25                	push   $0x25
  801a47:	e8 93 fb ff ff       	call   8015df <syscall>
  801a4c:	83 c4 18             	add    $0x18,%esp
  801a4f:	a3 60 b0 81 00       	mov    %eax,0x81b060
	return uheapPlaceStrategy ;
  801a54:	a1 60 b0 81 00       	mov    0x81b060,%eax
}
  801a59:	c9                   	leave  
  801a5a:	c3                   	ret    

00801a5b <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801a5b:	55                   	push   %ebp
  801a5c:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = heapStrategy;
  801a5e:	8b 45 08             	mov    0x8(%ebp),%eax
  801a61:	a3 60 b0 81 00       	mov    %eax,0x81b060
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801a66:	6a 00                	push   $0x0
  801a68:	6a 00                	push   $0x0
  801a6a:	6a 00                	push   $0x0
  801a6c:	6a 00                	push   $0x0
  801a6e:	ff 75 08             	pushl  0x8(%ebp)
  801a71:	6a 26                	push   $0x26
  801a73:	e8 67 fb ff ff       	call   8015df <syscall>
  801a78:	83 c4 18             	add    $0x18,%esp
	return ;
  801a7b:	90                   	nop
}
  801a7c:	c9                   	leave  
  801a7d:	c3                   	ret    

00801a7e <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801a7e:	55                   	push   %ebp
  801a7f:	89 e5                	mov    %esp,%ebp
  801a81:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801a82:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801a85:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801a88:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a8b:	8b 45 08             	mov    0x8(%ebp),%eax
  801a8e:	6a 00                	push   $0x0
  801a90:	53                   	push   %ebx
  801a91:	51                   	push   %ecx
  801a92:	52                   	push   %edx
  801a93:	50                   	push   %eax
  801a94:	6a 27                	push   $0x27
  801a96:	e8 44 fb ff ff       	call   8015df <syscall>
  801a9b:	83 c4 18             	add    $0x18,%esp
}
  801a9e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801aa1:	c9                   	leave  
  801aa2:	c3                   	ret    

00801aa3 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801aa3:	55                   	push   %ebp
  801aa4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801aa6:	8b 55 0c             	mov    0xc(%ebp),%edx
  801aa9:	8b 45 08             	mov    0x8(%ebp),%eax
  801aac:	6a 00                	push   $0x0
  801aae:	6a 00                	push   $0x0
  801ab0:	6a 00                	push   $0x0
  801ab2:	52                   	push   %edx
  801ab3:	50                   	push   %eax
  801ab4:	6a 28                	push   $0x28
  801ab6:	e8 24 fb ff ff       	call   8015df <syscall>
  801abb:	83 c4 18             	add    $0x18,%esp
}
  801abe:	c9                   	leave  
  801abf:	c3                   	ret    

00801ac0 <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  801ac0:	55                   	push   %ebp
  801ac1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  801ac3:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801ac6:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ac9:	8b 45 08             	mov    0x8(%ebp),%eax
  801acc:	6a 00                	push   $0x0
  801ace:	51                   	push   %ecx
  801acf:	ff 75 10             	pushl  0x10(%ebp)
  801ad2:	52                   	push   %edx
  801ad3:	50                   	push   %eax
  801ad4:	6a 29                	push   $0x29
  801ad6:	e8 04 fb ff ff       	call   8015df <syscall>
  801adb:	83 c4 18             	add    $0x18,%esp
}
  801ade:	c9                   	leave  
  801adf:	c3                   	ret    

00801ae0 <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801ae0:	55                   	push   %ebp
  801ae1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801ae3:	6a 00                	push   $0x0
  801ae5:	6a 00                	push   $0x0
  801ae7:	ff 75 10             	pushl  0x10(%ebp)
  801aea:	ff 75 0c             	pushl  0xc(%ebp)
  801aed:	ff 75 08             	pushl  0x8(%ebp)
  801af0:	6a 12                	push   $0x12
  801af2:	e8 e8 fa ff ff       	call   8015df <syscall>
  801af7:	83 c4 18             	add    $0x18,%esp
	return ;
  801afa:	90                   	nop
}
  801afb:	c9                   	leave  
  801afc:	c3                   	ret    

00801afd <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  801afd:	55                   	push   %ebp
  801afe:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  801b00:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b03:	8b 45 08             	mov    0x8(%ebp),%eax
  801b06:	6a 00                	push   $0x0
  801b08:	6a 00                	push   $0x0
  801b0a:	6a 00                	push   $0x0
  801b0c:	52                   	push   %edx
  801b0d:	50                   	push   %eax
  801b0e:	6a 2a                	push   $0x2a
  801b10:	e8 ca fa ff ff       	call   8015df <syscall>
  801b15:	83 c4 18             	add    $0x18,%esp
	return;
  801b18:	90                   	nop
}
  801b19:	c9                   	leave  
  801b1a:	c3                   	ret    

00801b1b <sys_get_optimal_num_faults>:
/*2025*/
int sys_get_optimal_num_faults()
{
  801b1b:	55                   	push   %ebp
  801b1c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_optimal_num_faults, 0, 0, 0, 0, 0);
  801b1e:	6a 00                	push   $0x0
  801b20:	6a 00                	push   $0x0
  801b22:	6a 00                	push   $0x0
  801b24:	6a 00                	push   $0x0
  801b26:	6a 00                	push   $0x0
  801b28:	6a 2b                	push   $0x2b
  801b2a:	e8 b0 fa ff ff       	call   8015df <syscall>
  801b2f:	83 c4 18             	add    $0x18,%esp
}
  801b32:	c9                   	leave  
  801b33:	c3                   	ret    

00801b34 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801b34:	55                   	push   %ebp
  801b35:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801b37:	6a 00                	push   $0x0
  801b39:	6a 00                	push   $0x0
  801b3b:	6a 00                	push   $0x0
  801b3d:	ff 75 0c             	pushl  0xc(%ebp)
  801b40:	ff 75 08             	pushl  0x8(%ebp)
  801b43:	6a 2d                	push   $0x2d
  801b45:	e8 95 fa ff ff       	call   8015df <syscall>
  801b4a:	83 c4 18             	add    $0x18,%esp
	return;
  801b4d:	90                   	nop
}
  801b4e:	c9                   	leave  
  801b4f:	c3                   	ret    

00801b50 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801b50:	55                   	push   %ebp
  801b51:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801b53:	6a 00                	push   $0x0
  801b55:	6a 00                	push   $0x0
  801b57:	6a 00                	push   $0x0
  801b59:	ff 75 0c             	pushl  0xc(%ebp)
  801b5c:	ff 75 08             	pushl  0x8(%ebp)
  801b5f:	6a 2c                	push   $0x2c
  801b61:	e8 79 fa ff ff       	call   8015df <syscall>
  801b66:	83 c4 18             	add    $0x18,%esp
	return ;
  801b69:	90                   	nop
}
  801b6a:	c9                   	leave  
  801b6b:	c3                   	ret    

00801b6c <sys_env_set_priority>:


void sys_env_set_priority(int32 envID, int priority)
{
  801b6c:	55                   	push   %ebp
  801b6d:	89 e5                	mov    %esp,%ebp
  801b6f:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.IM#4] CPU SCHEDULING - #1 System Calls - Add suitable code here
	//Your code is here
	//Comment the following line
	panic("sys_env_set_priority() is not implemented yet...!!");
  801b72:	83 ec 04             	sub    $0x4,%esp
  801b75:	68 28 27 80 00       	push   $0x802728
  801b7a:	68 25 01 00 00       	push   $0x125
  801b7f:	68 5b 27 80 00       	push   $0x80275b
  801b84:	e8 a3 e8 ff ff       	call   80042c <_panic>

00801b89 <env_sleep>:
#include <inc/lib.h>
#include <inc/timerreg.h>

void
env_sleep(uint32 approxMilliSeconds)
{
  801b89:	55                   	push   %ebp
  801b8a:	89 e5                	mov    %esp,%ebp
  801b8c:	83 ec 30             	sub    $0x30,%esp
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
  801b8f:	8b 55 08             	mov    0x8(%ebp),%edx
  801b92:	89 d0                	mov    %edx,%eax
  801b94:	c1 e0 02             	shl    $0x2,%eax
  801b97:	01 d0                	add    %edx,%eax
  801b99:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801ba0:	01 d0                	add    %edx,%eax
  801ba2:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801ba9:	01 d0                	add    %edx,%eax
  801bab:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801bb2:	01 d0                	add    %edx,%eax
  801bb4:	c1 e0 04             	shl    $0x4,%eax
  801bb7:	89 45 f8             	mov    %eax,-0x8(%ebp)
	uint32 cycles_counter =0;
  801bba:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)

static inline __attribute__((always_inline)) struct uint64 get_virtual_time_user()
{
	struct uint64 result;

	__asm __volatile("rdtsc\n"
  801bc1:	0f 31                	rdtsc  
  801bc3:	89 45 e8             	mov    %eax,-0x18(%ebp)
  801bc6:	89 55 ec             	mov    %edx,-0x14(%ebp)
	: "=a" (result.low), "=d" (result.hi)
	);

	return result;
  801bc9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801bcc:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801bcf:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801bd2:	89 55 f4             	mov    %edx,-0xc(%ebp)

	/*2024*/ //USE A USER-SIDE VERSION OF THIS FUNCTION TO AVOID SLOW-DOWN THE PERFORMANCE DUE SYS_CALL (el7 :))
	//struct uint64 baseTime = sys_get_virtual_time() ;
	struct uint64 baseTime = get_virtual_time_user() ;
	while(cycles_counter<time_in_cycles)
  801bd5:	eb 46                	jmp    801c1d <env_sleep+0x94>

static inline __attribute__((always_inline)) struct uint64 get_virtual_time_user()
{
	struct uint64 result;

	__asm __volatile("rdtsc\n"
  801bd7:	0f 31                	rdtsc  
  801bd9:	89 45 d0             	mov    %eax,-0x30(%ebp)
  801bdc:	89 55 d4             	mov    %edx,-0x2c(%ebp)
	: "=a" (result.low), "=d" (result.hi)
	);

	return result;
  801bdf:	8b 45 d0             	mov    -0x30(%ebp),%eax
  801be2:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  801be5:	89 45 e0             	mov    %eax,-0x20(%ebp)
  801be8:	89 55 e4             	mov    %edx,-0x1c(%ebp)

		// update the cycles_count
		#define M32 0xffffffff
		// subtract basetime from current time
		struct uint64 res;
		res.low = (currentTime.low - baseTime.low) & M32;
  801beb:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801bee:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801bf1:	29 c2                	sub    %eax,%edx
  801bf3:	89 d0                	mov    %edx,%eax
  801bf5:	89 45 d8             	mov    %eax,-0x28(%ebp)
		res.hi = (currentTime.hi - baseTime.hi - (res.low > currentTime.low)) & M32;
  801bf8:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801bfb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801bfe:	89 d1                	mov    %edx,%ecx
  801c00:	29 c1                	sub    %eax,%ecx
  801c02:	8b 55 d8             	mov    -0x28(%ebp),%edx
  801c05:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801c08:	39 c2                	cmp    %eax,%edx
  801c0a:	0f 97 c0             	seta   %al
  801c0d:	0f b6 c0             	movzbl %al,%eax
  801c10:	29 c1                	sub    %eax,%ecx
  801c12:	89 c8                	mov    %ecx,%eax
  801c14:	89 45 dc             	mov    %eax,-0x24(%ebp)

		//update cycles_count with result
		cycles_counter = res.low;
  801c17:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801c1a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	uint32 cycles_counter =0;

	/*2024*/ //USE A USER-SIDE VERSION OF THIS FUNCTION TO AVOID SLOW-DOWN THE PERFORMANCE DUE SYS_CALL (el7 :))
	//struct uint64 baseTime = sys_get_virtual_time() ;
	struct uint64 baseTime = get_virtual_time_user() ;
	while(cycles_counter<time_in_cycles)
  801c1d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801c20:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801c23:	72 b2                	jb     801bd7 <env_sleep+0x4e>
//				,cycles_counter
//				);
	}
	//cprintf("%s [%d] wake up now!\n", myEnv->prog_name, myEnv->env_id);

}
  801c25:	90                   	nop
  801c26:	c9                   	leave  
  801c27:	c3                   	ret    

00801c28 <busy_wait>:

//2017
uint32 busy_wait(uint32 loopMax)
{
  801c28:	55                   	push   %ebp
  801c29:	89 e5                	mov    %esp,%ebp
  801c2b:	83 ec 10             	sub    $0x10,%esp
	uint32 i = 0 ;
  801c2e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	while (i < loopMax) i++;
  801c35:	eb 03                	jmp    801c3a <busy_wait+0x12>
  801c37:	ff 45 fc             	incl   -0x4(%ebp)
  801c3a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801c3d:	3b 45 08             	cmp    0x8(%ebp),%eax
  801c40:	72 f5                	jb     801c37 <busy_wait+0xf>
	return i;
  801c42:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801c45:	c9                   	leave  
  801c46:	c3                   	ret    
  801c47:	90                   	nop

00801c48 <__udivdi3>:
  801c48:	55                   	push   %ebp
  801c49:	57                   	push   %edi
  801c4a:	56                   	push   %esi
  801c4b:	53                   	push   %ebx
  801c4c:	83 ec 1c             	sub    $0x1c,%esp
  801c4f:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  801c53:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  801c57:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801c5b:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801c5f:	89 ca                	mov    %ecx,%edx
  801c61:	89 f8                	mov    %edi,%eax
  801c63:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  801c67:	85 f6                	test   %esi,%esi
  801c69:	75 2d                	jne    801c98 <__udivdi3+0x50>
  801c6b:	39 cf                	cmp    %ecx,%edi
  801c6d:	77 65                	ja     801cd4 <__udivdi3+0x8c>
  801c6f:	89 fd                	mov    %edi,%ebp
  801c71:	85 ff                	test   %edi,%edi
  801c73:	75 0b                	jne    801c80 <__udivdi3+0x38>
  801c75:	b8 01 00 00 00       	mov    $0x1,%eax
  801c7a:	31 d2                	xor    %edx,%edx
  801c7c:	f7 f7                	div    %edi
  801c7e:	89 c5                	mov    %eax,%ebp
  801c80:	31 d2                	xor    %edx,%edx
  801c82:	89 c8                	mov    %ecx,%eax
  801c84:	f7 f5                	div    %ebp
  801c86:	89 c1                	mov    %eax,%ecx
  801c88:	89 d8                	mov    %ebx,%eax
  801c8a:	f7 f5                	div    %ebp
  801c8c:	89 cf                	mov    %ecx,%edi
  801c8e:	89 fa                	mov    %edi,%edx
  801c90:	83 c4 1c             	add    $0x1c,%esp
  801c93:	5b                   	pop    %ebx
  801c94:	5e                   	pop    %esi
  801c95:	5f                   	pop    %edi
  801c96:	5d                   	pop    %ebp
  801c97:	c3                   	ret    
  801c98:	39 ce                	cmp    %ecx,%esi
  801c9a:	77 28                	ja     801cc4 <__udivdi3+0x7c>
  801c9c:	0f bd fe             	bsr    %esi,%edi
  801c9f:	83 f7 1f             	xor    $0x1f,%edi
  801ca2:	75 40                	jne    801ce4 <__udivdi3+0x9c>
  801ca4:	39 ce                	cmp    %ecx,%esi
  801ca6:	72 0a                	jb     801cb2 <__udivdi3+0x6a>
  801ca8:	3b 44 24 08          	cmp    0x8(%esp),%eax
  801cac:	0f 87 9e 00 00 00    	ja     801d50 <__udivdi3+0x108>
  801cb2:	b8 01 00 00 00       	mov    $0x1,%eax
  801cb7:	89 fa                	mov    %edi,%edx
  801cb9:	83 c4 1c             	add    $0x1c,%esp
  801cbc:	5b                   	pop    %ebx
  801cbd:	5e                   	pop    %esi
  801cbe:	5f                   	pop    %edi
  801cbf:	5d                   	pop    %ebp
  801cc0:	c3                   	ret    
  801cc1:	8d 76 00             	lea    0x0(%esi),%esi
  801cc4:	31 ff                	xor    %edi,%edi
  801cc6:	31 c0                	xor    %eax,%eax
  801cc8:	89 fa                	mov    %edi,%edx
  801cca:	83 c4 1c             	add    $0x1c,%esp
  801ccd:	5b                   	pop    %ebx
  801cce:	5e                   	pop    %esi
  801ccf:	5f                   	pop    %edi
  801cd0:	5d                   	pop    %ebp
  801cd1:	c3                   	ret    
  801cd2:	66 90                	xchg   %ax,%ax
  801cd4:	89 d8                	mov    %ebx,%eax
  801cd6:	f7 f7                	div    %edi
  801cd8:	31 ff                	xor    %edi,%edi
  801cda:	89 fa                	mov    %edi,%edx
  801cdc:	83 c4 1c             	add    $0x1c,%esp
  801cdf:	5b                   	pop    %ebx
  801ce0:	5e                   	pop    %esi
  801ce1:	5f                   	pop    %edi
  801ce2:	5d                   	pop    %ebp
  801ce3:	c3                   	ret    
  801ce4:	bd 20 00 00 00       	mov    $0x20,%ebp
  801ce9:	89 eb                	mov    %ebp,%ebx
  801ceb:	29 fb                	sub    %edi,%ebx
  801ced:	89 f9                	mov    %edi,%ecx
  801cef:	d3 e6                	shl    %cl,%esi
  801cf1:	89 c5                	mov    %eax,%ebp
  801cf3:	88 d9                	mov    %bl,%cl
  801cf5:	d3 ed                	shr    %cl,%ebp
  801cf7:	89 e9                	mov    %ebp,%ecx
  801cf9:	09 f1                	or     %esi,%ecx
  801cfb:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  801cff:	89 f9                	mov    %edi,%ecx
  801d01:	d3 e0                	shl    %cl,%eax
  801d03:	89 c5                	mov    %eax,%ebp
  801d05:	89 d6                	mov    %edx,%esi
  801d07:	88 d9                	mov    %bl,%cl
  801d09:	d3 ee                	shr    %cl,%esi
  801d0b:	89 f9                	mov    %edi,%ecx
  801d0d:	d3 e2                	shl    %cl,%edx
  801d0f:	8b 44 24 08          	mov    0x8(%esp),%eax
  801d13:	88 d9                	mov    %bl,%cl
  801d15:	d3 e8                	shr    %cl,%eax
  801d17:	09 c2                	or     %eax,%edx
  801d19:	89 d0                	mov    %edx,%eax
  801d1b:	89 f2                	mov    %esi,%edx
  801d1d:	f7 74 24 0c          	divl   0xc(%esp)
  801d21:	89 d6                	mov    %edx,%esi
  801d23:	89 c3                	mov    %eax,%ebx
  801d25:	f7 e5                	mul    %ebp
  801d27:	39 d6                	cmp    %edx,%esi
  801d29:	72 19                	jb     801d44 <__udivdi3+0xfc>
  801d2b:	74 0b                	je     801d38 <__udivdi3+0xf0>
  801d2d:	89 d8                	mov    %ebx,%eax
  801d2f:	31 ff                	xor    %edi,%edi
  801d31:	e9 58 ff ff ff       	jmp    801c8e <__udivdi3+0x46>
  801d36:	66 90                	xchg   %ax,%ax
  801d38:	8b 54 24 08          	mov    0x8(%esp),%edx
  801d3c:	89 f9                	mov    %edi,%ecx
  801d3e:	d3 e2                	shl    %cl,%edx
  801d40:	39 c2                	cmp    %eax,%edx
  801d42:	73 e9                	jae    801d2d <__udivdi3+0xe5>
  801d44:	8d 43 ff             	lea    -0x1(%ebx),%eax
  801d47:	31 ff                	xor    %edi,%edi
  801d49:	e9 40 ff ff ff       	jmp    801c8e <__udivdi3+0x46>
  801d4e:	66 90                	xchg   %ax,%ax
  801d50:	31 c0                	xor    %eax,%eax
  801d52:	e9 37 ff ff ff       	jmp    801c8e <__udivdi3+0x46>
  801d57:	90                   	nop

00801d58 <__umoddi3>:
  801d58:	55                   	push   %ebp
  801d59:	57                   	push   %edi
  801d5a:	56                   	push   %esi
  801d5b:	53                   	push   %ebx
  801d5c:	83 ec 1c             	sub    $0x1c,%esp
  801d5f:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  801d63:	8b 74 24 34          	mov    0x34(%esp),%esi
  801d67:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801d6b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  801d6f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801d73:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801d77:	89 f3                	mov    %esi,%ebx
  801d79:	89 fa                	mov    %edi,%edx
  801d7b:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801d7f:	89 34 24             	mov    %esi,(%esp)
  801d82:	85 c0                	test   %eax,%eax
  801d84:	75 1a                	jne    801da0 <__umoddi3+0x48>
  801d86:	39 f7                	cmp    %esi,%edi
  801d88:	0f 86 a2 00 00 00    	jbe    801e30 <__umoddi3+0xd8>
  801d8e:	89 c8                	mov    %ecx,%eax
  801d90:	89 f2                	mov    %esi,%edx
  801d92:	f7 f7                	div    %edi
  801d94:	89 d0                	mov    %edx,%eax
  801d96:	31 d2                	xor    %edx,%edx
  801d98:	83 c4 1c             	add    $0x1c,%esp
  801d9b:	5b                   	pop    %ebx
  801d9c:	5e                   	pop    %esi
  801d9d:	5f                   	pop    %edi
  801d9e:	5d                   	pop    %ebp
  801d9f:	c3                   	ret    
  801da0:	39 f0                	cmp    %esi,%eax
  801da2:	0f 87 ac 00 00 00    	ja     801e54 <__umoddi3+0xfc>
  801da8:	0f bd e8             	bsr    %eax,%ebp
  801dab:	83 f5 1f             	xor    $0x1f,%ebp
  801dae:	0f 84 ac 00 00 00    	je     801e60 <__umoddi3+0x108>
  801db4:	bf 20 00 00 00       	mov    $0x20,%edi
  801db9:	29 ef                	sub    %ebp,%edi
  801dbb:	89 fe                	mov    %edi,%esi
  801dbd:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801dc1:	89 e9                	mov    %ebp,%ecx
  801dc3:	d3 e0                	shl    %cl,%eax
  801dc5:	89 d7                	mov    %edx,%edi
  801dc7:	89 f1                	mov    %esi,%ecx
  801dc9:	d3 ef                	shr    %cl,%edi
  801dcb:	09 c7                	or     %eax,%edi
  801dcd:	89 e9                	mov    %ebp,%ecx
  801dcf:	d3 e2                	shl    %cl,%edx
  801dd1:	89 14 24             	mov    %edx,(%esp)
  801dd4:	89 d8                	mov    %ebx,%eax
  801dd6:	d3 e0                	shl    %cl,%eax
  801dd8:	89 c2                	mov    %eax,%edx
  801dda:	8b 44 24 08          	mov    0x8(%esp),%eax
  801dde:	d3 e0                	shl    %cl,%eax
  801de0:	89 44 24 04          	mov    %eax,0x4(%esp)
  801de4:	8b 44 24 08          	mov    0x8(%esp),%eax
  801de8:	89 f1                	mov    %esi,%ecx
  801dea:	d3 e8                	shr    %cl,%eax
  801dec:	09 d0                	or     %edx,%eax
  801dee:	d3 eb                	shr    %cl,%ebx
  801df0:	89 da                	mov    %ebx,%edx
  801df2:	f7 f7                	div    %edi
  801df4:	89 d3                	mov    %edx,%ebx
  801df6:	f7 24 24             	mull   (%esp)
  801df9:	89 c6                	mov    %eax,%esi
  801dfb:	89 d1                	mov    %edx,%ecx
  801dfd:	39 d3                	cmp    %edx,%ebx
  801dff:	0f 82 87 00 00 00    	jb     801e8c <__umoddi3+0x134>
  801e05:	0f 84 91 00 00 00    	je     801e9c <__umoddi3+0x144>
  801e0b:	8b 54 24 04          	mov    0x4(%esp),%edx
  801e0f:	29 f2                	sub    %esi,%edx
  801e11:	19 cb                	sbb    %ecx,%ebx
  801e13:	89 d8                	mov    %ebx,%eax
  801e15:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  801e19:	d3 e0                	shl    %cl,%eax
  801e1b:	89 e9                	mov    %ebp,%ecx
  801e1d:	d3 ea                	shr    %cl,%edx
  801e1f:	09 d0                	or     %edx,%eax
  801e21:	89 e9                	mov    %ebp,%ecx
  801e23:	d3 eb                	shr    %cl,%ebx
  801e25:	89 da                	mov    %ebx,%edx
  801e27:	83 c4 1c             	add    $0x1c,%esp
  801e2a:	5b                   	pop    %ebx
  801e2b:	5e                   	pop    %esi
  801e2c:	5f                   	pop    %edi
  801e2d:	5d                   	pop    %ebp
  801e2e:	c3                   	ret    
  801e2f:	90                   	nop
  801e30:	89 fd                	mov    %edi,%ebp
  801e32:	85 ff                	test   %edi,%edi
  801e34:	75 0b                	jne    801e41 <__umoddi3+0xe9>
  801e36:	b8 01 00 00 00       	mov    $0x1,%eax
  801e3b:	31 d2                	xor    %edx,%edx
  801e3d:	f7 f7                	div    %edi
  801e3f:	89 c5                	mov    %eax,%ebp
  801e41:	89 f0                	mov    %esi,%eax
  801e43:	31 d2                	xor    %edx,%edx
  801e45:	f7 f5                	div    %ebp
  801e47:	89 c8                	mov    %ecx,%eax
  801e49:	f7 f5                	div    %ebp
  801e4b:	89 d0                	mov    %edx,%eax
  801e4d:	e9 44 ff ff ff       	jmp    801d96 <__umoddi3+0x3e>
  801e52:	66 90                	xchg   %ax,%ax
  801e54:	89 c8                	mov    %ecx,%eax
  801e56:	89 f2                	mov    %esi,%edx
  801e58:	83 c4 1c             	add    $0x1c,%esp
  801e5b:	5b                   	pop    %ebx
  801e5c:	5e                   	pop    %esi
  801e5d:	5f                   	pop    %edi
  801e5e:	5d                   	pop    %ebp
  801e5f:	c3                   	ret    
  801e60:	3b 04 24             	cmp    (%esp),%eax
  801e63:	72 06                	jb     801e6b <__umoddi3+0x113>
  801e65:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  801e69:	77 0f                	ja     801e7a <__umoddi3+0x122>
  801e6b:	89 f2                	mov    %esi,%edx
  801e6d:	29 f9                	sub    %edi,%ecx
  801e6f:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  801e73:	89 14 24             	mov    %edx,(%esp)
  801e76:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801e7a:	8b 44 24 04          	mov    0x4(%esp),%eax
  801e7e:	8b 14 24             	mov    (%esp),%edx
  801e81:	83 c4 1c             	add    $0x1c,%esp
  801e84:	5b                   	pop    %ebx
  801e85:	5e                   	pop    %esi
  801e86:	5f                   	pop    %edi
  801e87:	5d                   	pop    %ebp
  801e88:	c3                   	ret    
  801e89:	8d 76 00             	lea    0x0(%esi),%esi
  801e8c:	2b 04 24             	sub    (%esp),%eax
  801e8f:	19 fa                	sbb    %edi,%edx
  801e91:	89 d1                	mov    %edx,%ecx
  801e93:	89 c6                	mov    %eax,%esi
  801e95:	e9 71 ff ff ff       	jmp    801e0b <__umoddi3+0xb3>
  801e9a:	66 90                	xchg   %ax,%ax
  801e9c:	39 44 24 04          	cmp    %eax,0x4(%esp)
  801ea0:	72 ea                	jb     801e8c <__umoddi3+0x134>
  801ea2:	89 d9                	mov    %ebx,%ecx
  801ea4:	e9 62 ff ff ff       	jmp    801e0b <__umoddi3+0xb3>
