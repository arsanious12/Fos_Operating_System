
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
  800044:	e8 7a 18 00 00       	call   8018c3 <sys_getenvid>
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
  800078:	e8 95 1a 00 00       	call   801b12 <sys_utilities>
  80007d:	83 c4 10             	add    $0x10,%esp
	{
		if (gettst() > 1)
  800080:	e8 af 19 00 00       	call   801a34 <gettst>
  800085:	83 f8 01             	cmp    $0x1,%eax
  800088:	76 33                	jbe    8000bd <_main+0x85>
		{
			//Other slaves: wait for a while
			env_sleep(RAND(5000, 10000));
  80008a:	8d 45 d8             	lea    -0x28(%ebp),%eax
  80008d:	83 ec 0c             	sub    $0xc,%esp
  800090:	50                   	push   %eax
  800091:	e8 92 18 00 00       	call   801928 <sys_get_virtual_time>
  800096:	83 c4 0c             	add    $0xc,%esp
  800099:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80009c:	b9 88 13 00 00       	mov    $0x1388,%ecx
  8000a1:	ba 00 00 00 00       	mov    $0x0,%edx
  8000a6:	f7 f1                	div    %ecx
  8000a8:	89 d0                	mov    %edx,%eax
  8000aa:	05 88 13 00 00       	add    $0x1388,%eax
  8000af:	83 ec 0c             	sub    $0xc,%esp
  8000b2:	50                   	push   %eax
  8000b3:	e8 e6 1a 00 00       	call   801b9e <env_sleep>
  8000b8:	83 c4 10             	add    $0x10,%esp
  8000bb:	eb 0b                	jmp    8000c8 <_main+0x90>
		}
		else
		{
			//this is the first slave inside C.S.! so wait until receiving signal from master
			while (gettst() != 1);
  8000bd:	90                   	nop
  8000be:	e8 71 19 00 00       	call   801a34 <gettst>
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
  80010c:	e8 01 1a 00 00       	call   801b12 <sys_utilities>
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
  80012e:	e8 0e 03 00 00       	call   800441 <_panic>
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
  800177:	e8 96 19 00 00       	call   801b12 <sys_utilities>
  80017c:	83 c4 10             	add    $0x10,%esp
		int numOfFinishedProcesses = gettst() -1 /*since master already incremented it by 1*/;
  80017f:	e8 b0 18 00 00       	call   801a34 <gettst>
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
  8001cc:	e8 41 19 00 00       	call   801b12 <sys_utilities>
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
  80020d:	e8 2f 02 00 00       	call   800441 <_panic>
		}

		//indicates finishing
		inctst();
  800212:	e8 03 18 00 00       	call   801a1a <inctst>
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
  80024c:	e8 c1 18 00 00       	call   801b12 <sys_utilities>
  800251:	83 c4 10             	add    $0x10,%esp

	cprintf_colored(TEXT_light_magenta, ">>> Slave %d is Finished\n", envID);
  800254:	83 ec 04             	sub    $0x4,%esp
  800257:	ff 75 e4             	pushl  -0x1c(%ebp)
  80025a:	68 96 1f 80 00       	push   $0x801f96
  80025f:	6a 0d                	push   $0xd
  800261:	e8 d6 04 00 00       	call   80073c <cprintf_colored>
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
  800285:	e8 52 16 00 00       	call   8018dc <sys_getenvindex>
  80028a:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	myEnv = &(envs[envIndex]);
  80028d:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800290:	89 d0                	mov    %edx,%eax
  800292:	c1 e0 06             	shl    $0x6,%eax
  800295:	29 d0                	sub    %edx,%eax
  800297:	c1 e0 02             	shl    $0x2,%eax
  80029a:	01 d0                	add    %edx,%eax
  80029c:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8002a3:	01 c8                	add    %ecx,%eax
  8002a5:	c1 e0 03             	shl    $0x3,%eax
  8002a8:	01 d0                	add    %edx,%eax
  8002aa:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8002b1:	29 c2                	sub    %eax,%edx
  8002b3:	8d 04 95 00 00 00 00 	lea    0x0(,%edx,4),%eax
  8002ba:	89 c2                	mov    %eax,%edx
  8002bc:	8d 82 00 00 c0 ee    	lea    -0x11400000(%edx),%eax
  8002c2:	a3 20 30 80 00       	mov    %eax,0x803020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  8002c7:	a1 20 30 80 00       	mov    0x803020,%eax
  8002cc:	8a 40 20             	mov    0x20(%eax),%al
  8002cf:	84 c0                	test   %al,%al
  8002d1:	74 0d                	je     8002e0 <libmain+0x64>
		binaryname = myEnv->prog_name;
  8002d3:	a1 20 30 80 00       	mov    0x803020,%eax
  8002d8:	83 c0 20             	add    $0x20,%eax
  8002db:	a3 04 30 80 00       	mov    %eax,0x803004

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8002e0:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8002e4:	7e 0a                	jle    8002f0 <libmain+0x74>
		binaryname = argv[0];
  8002e6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8002e9:	8b 00                	mov    (%eax),%eax
  8002eb:	a3 04 30 80 00       	mov    %eax,0x803004

	// call user main routine
	_main(argc, argv);
  8002f0:	83 ec 08             	sub    $0x8,%esp
  8002f3:	ff 75 0c             	pushl  0xc(%ebp)
  8002f6:	ff 75 08             	pushl  0x8(%ebp)
  8002f9:	e8 3a fd ff ff       	call   800038 <_main>
  8002fe:	83 c4 10             	add    $0x10,%esp

	if (printStats)
  800301:	a1 00 30 80 00       	mov    0x803000,%eax
  800306:	85 c0                	test   %eax,%eax
  800308:	0f 84 01 01 00 00    	je     80040f <libmain+0x193>
	{
		char isOPTReplCmd[100] = "__IsOPTRepl__" ;
  80030e:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  800314:	bb e8 21 80 00       	mov    $0x8021e8,%ebx
  800319:	ba 0e 00 00 00       	mov    $0xe,%edx
  80031e:	89 c7                	mov    %eax,%edi
  800320:	89 de                	mov    %ebx,%esi
  800322:	89 d1                	mov    %edx,%ecx
  800324:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  800326:	8d 55 8a             	lea    -0x76(%ebp),%edx
  800329:	b9 56 00 00 00       	mov    $0x56,%ecx
  80032e:	b0 00                	mov    $0x0,%al
  800330:	89 d7                	mov    %edx,%edi
  800332:	f3 aa                	rep stos %al,%es:(%edi)
		int isOPTRepl = 0;
  800334:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
		sys_utilities(isOPTReplCmd, (uint32)(&isOPTRepl));
  80033b:	8d 45 e0             	lea    -0x20(%ebp),%eax
  80033e:	83 ec 08             	sub    $0x8,%esp
  800341:	50                   	push   %eax
  800342:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  800348:	50                   	push   %eax
  800349:	e8 c4 17 00 00       	call   801b12 <sys_utilities>
  80034e:	83 c4 10             	add    $0x10,%esp

		sys_lock_cons();
  800351:	e8 0d 13 00 00       	call   801663 <sys_lock_cons>
		{
			cprintf("**************************************\n");
  800356:	83 ec 0c             	sub    $0xc,%esp
  800359:	68 08 21 80 00       	push   $0x802108
  80035e:	e8 ac 03 00 00       	call   80070f <cprintf>
  800363:	83 c4 10             	add    $0x10,%esp
			if (isOPTRepl)
  800366:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800369:	85 c0                	test   %eax,%eax
  80036b:	74 18                	je     800385 <libmain+0x109>
			{
				cprintf("OPTIMAL number of page faults = %d\n", sys_get_optimal_num_faults());
  80036d:	e8 be 17 00 00       	call   801b30 <sys_get_optimal_num_faults>
  800372:	83 ec 08             	sub    $0x8,%esp
  800375:	50                   	push   %eax
  800376:	68 30 21 80 00       	push   $0x802130
  80037b:	e8 8f 03 00 00       	call   80070f <cprintf>
  800380:	83 c4 10             	add    $0x10,%esp
  800383:	eb 59                	jmp    8003de <libmain+0x162>
			}
			else
			{
				cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  800385:	a1 20 30 80 00       	mov    0x803020,%eax
  80038a:	8b 90 50 da 01 00    	mov    0x1da50(%eax),%edx
  800390:	a1 20 30 80 00       	mov    0x803020,%eax
  800395:	8b 80 40 da 01 00    	mov    0x1da40(%eax),%eax
  80039b:	83 ec 04             	sub    $0x4,%esp
  80039e:	52                   	push   %edx
  80039f:	50                   	push   %eax
  8003a0:	68 54 21 80 00       	push   $0x802154
  8003a5:	e8 65 03 00 00       	call   80070f <cprintf>
  8003aa:	83 c4 10             	add    $0x10,%esp
				cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  8003ad:	a1 20 30 80 00       	mov    0x803020,%eax
  8003b2:	8b 88 64 da 01 00    	mov    0x1da64(%eax),%ecx
  8003b8:	a1 20 30 80 00       	mov    0x803020,%eax
  8003bd:	8b 90 60 da 01 00    	mov    0x1da60(%eax),%edx
  8003c3:	a1 20 30 80 00       	mov    0x803020,%eax
  8003c8:	8b 80 5c da 01 00    	mov    0x1da5c(%eax),%eax
  8003ce:	51                   	push   %ecx
  8003cf:	52                   	push   %edx
  8003d0:	50                   	push   %eax
  8003d1:	68 7c 21 80 00       	push   $0x80217c
  8003d6:	e8 34 03 00 00       	call   80070f <cprintf>
  8003db:	83 c4 10             	add    $0x10,%esp
			}
			//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
			cprintf("Num of clocks = %d\n", myEnv->nClocks);
  8003de:	a1 20 30 80 00       	mov    0x803020,%eax
  8003e3:	8b 80 68 da 01 00    	mov    0x1da68(%eax),%eax
  8003e9:	83 ec 08             	sub    $0x8,%esp
  8003ec:	50                   	push   %eax
  8003ed:	68 d4 21 80 00       	push   $0x8021d4
  8003f2:	e8 18 03 00 00       	call   80070f <cprintf>
  8003f7:	83 c4 10             	add    $0x10,%esp
			cprintf("**************************************\n");
  8003fa:	83 ec 0c             	sub    $0xc,%esp
  8003fd:	68 08 21 80 00       	push   $0x802108
  800402:	e8 08 03 00 00       	call   80070f <cprintf>
  800407:	83 c4 10             	add    $0x10,%esp
		}
		sys_unlock_cons();
  80040a:	e8 6e 12 00 00       	call   80167d <sys_unlock_cons>
	}

	// exit gracefully
	exit();
  80040f:	e8 1f 00 00 00       	call   800433 <exit>
}
  800414:	90                   	nop
  800415:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800418:	5b                   	pop    %ebx
  800419:	5e                   	pop    %esi
  80041a:	5f                   	pop    %edi
  80041b:	5d                   	pop    %ebp
  80041c:	c3                   	ret    

0080041d <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  80041d:	55                   	push   %ebp
  80041e:	89 e5                	mov    %esp,%ebp
  800420:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800423:	83 ec 0c             	sub    $0xc,%esp
  800426:	6a 00                	push   $0x0
  800428:	e8 7b 14 00 00       	call   8018a8 <sys_destroy_env>
  80042d:	83 c4 10             	add    $0x10,%esp
}
  800430:	90                   	nop
  800431:	c9                   	leave  
  800432:	c3                   	ret    

00800433 <exit>:

void
exit(void)
{
  800433:	55                   	push   %ebp
  800434:	89 e5                	mov    %esp,%ebp
  800436:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  800439:	e8 d0 14 00 00       	call   80190e <sys_exit_env>
}
  80043e:	90                   	nop
  80043f:	c9                   	leave  
  800440:	c3                   	ret    

00800441 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  800441:	55                   	push   %ebp
  800442:	89 e5                	mov    %esp,%ebp
  800444:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  800447:	8d 45 10             	lea    0x10(%ebp),%eax
  80044a:	83 c0 04             	add    $0x4,%eax
  80044d:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  800450:	a1 18 b1 81 00       	mov    0x81b118,%eax
  800455:	85 c0                	test   %eax,%eax
  800457:	74 16                	je     80046f <_panic+0x2e>
		cprintf("%s: ", argv0);
  800459:	a1 18 b1 81 00       	mov    0x81b118,%eax
  80045e:	83 ec 08             	sub    $0x8,%esp
  800461:	50                   	push   %eax
  800462:	68 4c 22 80 00       	push   $0x80224c
  800467:	e8 a3 02 00 00       	call   80070f <cprintf>
  80046c:	83 c4 10             	add    $0x10,%esp
	cprintf_colored(TEXT_PANIC_CLR, "user [EVAL_FINAL]panic in %s at %s:%d: ", binaryname, file, line);
  80046f:	a1 04 30 80 00       	mov    0x803004,%eax
  800474:	83 ec 0c             	sub    $0xc,%esp
  800477:	ff 75 0c             	pushl  0xc(%ebp)
  80047a:	ff 75 08             	pushl  0x8(%ebp)
  80047d:	50                   	push   %eax
  80047e:	68 54 22 80 00       	push   $0x802254
  800483:	6a 74                	push   $0x74
  800485:	e8 b2 02 00 00       	call   80073c <cprintf_colored>
  80048a:	83 c4 20             	add    $0x20,%esp
	vcprintf(fmt, ap);
  80048d:	8b 45 10             	mov    0x10(%ebp),%eax
  800490:	83 ec 08             	sub    $0x8,%esp
  800493:	ff 75 f4             	pushl  -0xc(%ebp)
  800496:	50                   	push   %eax
  800497:	e8 04 02 00 00       	call   8006a0 <vcprintf>
  80049c:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  80049f:	83 ec 08             	sub    $0x8,%esp
  8004a2:	6a 00                	push   $0x0
  8004a4:	68 7c 22 80 00       	push   $0x80227c
  8004a9:	e8 f2 01 00 00       	call   8006a0 <vcprintf>
  8004ae:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  8004b1:	e8 7d ff ff ff       	call   800433 <exit>

	// should not return here
	while (1) ;
  8004b6:	eb fe                	jmp    8004b6 <_panic+0x75>

008004b8 <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  8004b8:	55                   	push   %ebp
  8004b9:	89 e5                	mov    %esp,%ebp
  8004bb:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  8004be:	a1 20 30 80 00       	mov    0x803020,%eax
  8004c3:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  8004c9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004cc:	39 c2                	cmp    %eax,%edx
  8004ce:	74 14                	je     8004e4 <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  8004d0:	83 ec 04             	sub    $0x4,%esp
  8004d3:	68 80 22 80 00       	push   $0x802280
  8004d8:	6a 26                	push   $0x26
  8004da:	68 cc 22 80 00       	push   $0x8022cc
  8004df:	e8 5d ff ff ff       	call   800441 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  8004e4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  8004eb:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8004f2:	e9 c5 00 00 00       	jmp    8005bc <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  8004f7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8004fa:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800501:	8b 45 08             	mov    0x8(%ebp),%eax
  800504:	01 d0                	add    %edx,%eax
  800506:	8b 00                	mov    (%eax),%eax
  800508:	85 c0                	test   %eax,%eax
  80050a:	75 08                	jne    800514 <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  80050c:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  80050f:	e9 a5 00 00 00       	jmp    8005b9 <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  800514:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80051b:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  800522:	eb 69                	jmp    80058d <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  800524:	a1 20 30 80 00       	mov    0x803020,%eax
  800529:	8b 88 38 da 01 00    	mov    0x1da38(%eax),%ecx
  80052f:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800532:	89 d0                	mov    %edx,%eax
  800534:	01 c0                	add    %eax,%eax
  800536:	01 d0                	add    %edx,%eax
  800538:	c1 e0 03             	shl    $0x3,%eax
  80053b:	01 c8                	add    %ecx,%eax
  80053d:	8a 40 04             	mov    0x4(%eax),%al
  800540:	84 c0                	test   %al,%al
  800542:	75 46                	jne    80058a <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800544:	a1 20 30 80 00       	mov    0x803020,%eax
  800549:	8b 88 38 da 01 00    	mov    0x1da38(%eax),%ecx
  80054f:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800552:	89 d0                	mov    %edx,%eax
  800554:	01 c0                	add    %eax,%eax
  800556:	01 d0                	add    %edx,%eax
  800558:	c1 e0 03             	shl    $0x3,%eax
  80055b:	01 c8                	add    %ecx,%eax
  80055d:	8b 00                	mov    (%eax),%eax
  80055f:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800562:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800565:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80056a:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  80056c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80056f:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800576:	8b 45 08             	mov    0x8(%ebp),%eax
  800579:	01 c8                	add    %ecx,%eax
  80057b:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  80057d:	39 c2                	cmp    %eax,%edx
  80057f:	75 09                	jne    80058a <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  800581:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  800588:	eb 15                	jmp    80059f <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80058a:	ff 45 e8             	incl   -0x18(%ebp)
  80058d:	a1 20 30 80 00       	mov    0x803020,%eax
  800592:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  800598:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80059b:	39 c2                	cmp    %eax,%edx
  80059d:	77 85                	ja     800524 <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  80059f:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8005a3:	75 14                	jne    8005b9 <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  8005a5:	83 ec 04             	sub    $0x4,%esp
  8005a8:	68 d8 22 80 00       	push   $0x8022d8
  8005ad:	6a 3a                	push   $0x3a
  8005af:	68 cc 22 80 00       	push   $0x8022cc
  8005b4:	e8 88 fe ff ff       	call   800441 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  8005b9:	ff 45 f0             	incl   -0x10(%ebp)
  8005bc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8005bf:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8005c2:	0f 8c 2f ff ff ff    	jl     8004f7 <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  8005c8:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8005cf:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  8005d6:	eb 26                	jmp    8005fe <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  8005d8:	a1 20 30 80 00       	mov    0x803020,%eax
  8005dd:	8b 88 38 da 01 00    	mov    0x1da38(%eax),%ecx
  8005e3:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8005e6:	89 d0                	mov    %edx,%eax
  8005e8:	01 c0                	add    %eax,%eax
  8005ea:	01 d0                	add    %edx,%eax
  8005ec:	c1 e0 03             	shl    $0x3,%eax
  8005ef:	01 c8                	add    %ecx,%eax
  8005f1:	8a 40 04             	mov    0x4(%eax),%al
  8005f4:	3c 01                	cmp    $0x1,%al
  8005f6:	75 03                	jne    8005fb <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  8005f8:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8005fb:	ff 45 e0             	incl   -0x20(%ebp)
  8005fe:	a1 20 30 80 00       	mov    0x803020,%eax
  800603:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  800609:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80060c:	39 c2                	cmp    %eax,%edx
  80060e:	77 c8                	ja     8005d8 <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  800610:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800613:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800616:	74 14                	je     80062c <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  800618:	83 ec 04             	sub    $0x4,%esp
  80061b:	68 2c 23 80 00       	push   $0x80232c
  800620:	6a 44                	push   $0x44
  800622:	68 cc 22 80 00       	push   $0x8022cc
  800627:	e8 15 fe ff ff       	call   800441 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  80062c:	90                   	nop
  80062d:	c9                   	leave  
  80062e:	c3                   	ret    

0080062f <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  80062f:	55                   	push   %ebp
  800630:	89 e5                	mov    %esp,%ebp
  800632:	53                   	push   %ebx
  800633:	83 ec 04             	sub    $0x4,%esp
	b->buf[b->idx++] = ch;
  800636:	8b 45 0c             	mov    0xc(%ebp),%eax
  800639:	8b 00                	mov    (%eax),%eax
  80063b:	8d 48 01             	lea    0x1(%eax),%ecx
  80063e:	8b 55 0c             	mov    0xc(%ebp),%edx
  800641:	89 0a                	mov    %ecx,(%edx)
  800643:	8b 55 08             	mov    0x8(%ebp),%edx
  800646:	88 d1                	mov    %dl,%cl
  800648:	8b 55 0c             	mov    0xc(%ebp),%edx
  80064b:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  80064f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800652:	8b 00                	mov    (%eax),%eax
  800654:	3d ff 00 00 00       	cmp    $0xff,%eax
  800659:	75 30                	jne    80068b <putch+0x5c>
		sys_cputs(b->buf, b->idx, printProgName, curTextClr);
  80065b:	8b 15 1c b1 81 00    	mov    0x81b11c,%edx
  800661:	a0 44 30 80 00       	mov    0x803044,%al
  800666:	0f b6 c0             	movzbl %al,%eax
  800669:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80066c:	8b 09                	mov    (%ecx),%ecx
  80066e:	89 cb                	mov    %ecx,%ebx
  800670:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800673:	83 c1 08             	add    $0x8,%ecx
  800676:	52                   	push   %edx
  800677:	50                   	push   %eax
  800678:	53                   	push   %ebx
  800679:	51                   	push   %ecx
  80067a:	e8 a0 0f 00 00       	call   80161f <sys_cputs>
  80067f:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800682:	8b 45 0c             	mov    0xc(%ebp),%eax
  800685:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  80068b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80068e:	8b 40 04             	mov    0x4(%eax),%eax
  800691:	8d 50 01             	lea    0x1(%eax),%edx
  800694:	8b 45 0c             	mov    0xc(%ebp),%eax
  800697:	89 50 04             	mov    %edx,0x4(%eax)
}
  80069a:	90                   	nop
  80069b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80069e:	c9                   	leave  
  80069f:	c3                   	ret    

008006a0 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  8006a0:	55                   	push   %ebp
  8006a1:	89 e5                	mov    %esp,%ebp
  8006a3:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8006a9:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8006b0:	00 00 00 
	b.cnt = 0;
  8006b3:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8006ba:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  8006bd:	ff 75 0c             	pushl  0xc(%ebp)
  8006c0:	ff 75 08             	pushl  0x8(%ebp)
  8006c3:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8006c9:	50                   	push   %eax
  8006ca:	68 2f 06 80 00       	push   $0x80062f
  8006cf:	e8 5a 02 00 00       	call   80092e <vprintfmt>
  8006d4:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName, curTextClr);
  8006d7:	8b 15 1c b1 81 00    	mov    0x81b11c,%edx
  8006dd:	a0 44 30 80 00       	mov    0x803044,%al
  8006e2:	0f b6 c0             	movzbl %al,%eax
  8006e5:	8b 8d f0 fe ff ff    	mov    -0x110(%ebp),%ecx
  8006eb:	52                   	push   %edx
  8006ec:	50                   	push   %eax
  8006ed:	51                   	push   %ecx
  8006ee:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8006f4:	83 c0 08             	add    $0x8,%eax
  8006f7:	50                   	push   %eax
  8006f8:	e8 22 0f 00 00       	call   80161f <sys_cputs>
  8006fd:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800700:	c6 05 44 30 80 00 00 	movb   $0x0,0x803044
	return b.cnt;
  800707:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  80070d:	c9                   	leave  
  80070e:	c3                   	ret    

0080070f <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  80070f:	55                   	push   %ebp
  800710:	89 e5                	mov    %esp,%ebp
  800712:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800715:	c6 05 44 30 80 00 01 	movb   $0x1,0x803044
	va_start(ap, fmt);
  80071c:	8d 45 0c             	lea    0xc(%ebp),%eax
  80071f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800722:	8b 45 08             	mov    0x8(%ebp),%eax
  800725:	83 ec 08             	sub    $0x8,%esp
  800728:	ff 75 f4             	pushl  -0xc(%ebp)
  80072b:	50                   	push   %eax
  80072c:	e8 6f ff ff ff       	call   8006a0 <vcprintf>
  800731:	83 c4 10             	add    $0x10,%esp
  800734:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800737:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80073a:	c9                   	leave  
  80073b:	c3                   	ret    

0080073c <cprintf_colored>:

// *************** This text coloring feature is implemented by *************
// ********** Abd-Alrahman Zedan From Team Frozen-Bytes - FCIS'24-25 ********
int cprintf_colored(int textClr, const char *fmt, ...) {
  80073c:	55                   	push   %ebp
  80073d:	89 e5                	mov    %esp,%ebp
  80073f:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800742:	c6 05 44 30 80 00 01 	movb   $0x1,0x803044
	curTextClr = (textClr << 8) ; //set text color by the given value
  800749:	8b 45 08             	mov    0x8(%ebp),%eax
  80074c:	c1 e0 08             	shl    $0x8,%eax
  80074f:	a3 1c b1 81 00       	mov    %eax,0x81b11c
	va_start(ap, fmt);
  800754:	8d 45 0c             	lea    0xc(%ebp),%eax
  800757:	83 c0 04             	add    $0x4,%eax
  80075a:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  80075d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800760:	83 ec 08             	sub    $0x8,%esp
  800763:	ff 75 f4             	pushl  -0xc(%ebp)
  800766:	50                   	push   %eax
  800767:	e8 34 ff ff ff       	call   8006a0 <vcprintf>
  80076c:	83 c4 10             	add    $0x10,%esp
  80076f:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);
	curTextClr = TEXT_DEFAULT_CLR; //restore default color
  800772:	c7 05 1c b1 81 00 00 	movl   $0x700,0x81b11c
  800779:	07 00 00 

	return cnt;
  80077c:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80077f:	c9                   	leave  
  800780:	c3                   	ret    

00800781 <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  800781:	55                   	push   %ebp
  800782:	89 e5                	mov    %esp,%ebp
  800784:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  800787:	e8 d7 0e 00 00       	call   801663 <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  80078c:	8d 45 0c             	lea    0xc(%ebp),%eax
  80078f:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  800792:	8b 45 08             	mov    0x8(%ebp),%eax
  800795:	83 ec 08             	sub    $0x8,%esp
  800798:	ff 75 f4             	pushl  -0xc(%ebp)
  80079b:	50                   	push   %eax
  80079c:	e8 ff fe ff ff       	call   8006a0 <vcprintf>
  8007a1:	83 c4 10             	add    $0x10,%esp
  8007a4:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  8007a7:	e8 d1 0e 00 00       	call   80167d <sys_unlock_cons>
	return cnt;
  8007ac:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8007af:	c9                   	leave  
  8007b0:	c3                   	ret    

008007b1 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8007b1:	55                   	push   %ebp
  8007b2:	89 e5                	mov    %esp,%ebp
  8007b4:	53                   	push   %ebx
  8007b5:	83 ec 14             	sub    $0x14,%esp
  8007b8:	8b 45 10             	mov    0x10(%ebp),%eax
  8007bb:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8007be:	8b 45 14             	mov    0x14(%ebp),%eax
  8007c1:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8007c4:	8b 45 18             	mov    0x18(%ebp),%eax
  8007c7:	ba 00 00 00 00       	mov    $0x0,%edx
  8007cc:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8007cf:	77 55                	ja     800826 <printnum+0x75>
  8007d1:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8007d4:	72 05                	jb     8007db <printnum+0x2a>
  8007d6:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8007d9:	77 4b                	ja     800826 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8007db:	8b 45 1c             	mov    0x1c(%ebp),%eax
  8007de:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8007e1:	8b 45 18             	mov    0x18(%ebp),%eax
  8007e4:	ba 00 00 00 00       	mov    $0x0,%edx
  8007e9:	52                   	push   %edx
  8007ea:	50                   	push   %eax
  8007eb:	ff 75 f4             	pushl  -0xc(%ebp)
  8007ee:	ff 75 f0             	pushl  -0x10(%ebp)
  8007f1:	e8 66 14 00 00       	call   801c5c <__udivdi3>
  8007f6:	83 c4 10             	add    $0x10,%esp
  8007f9:	83 ec 04             	sub    $0x4,%esp
  8007fc:	ff 75 20             	pushl  0x20(%ebp)
  8007ff:	53                   	push   %ebx
  800800:	ff 75 18             	pushl  0x18(%ebp)
  800803:	52                   	push   %edx
  800804:	50                   	push   %eax
  800805:	ff 75 0c             	pushl  0xc(%ebp)
  800808:	ff 75 08             	pushl  0x8(%ebp)
  80080b:	e8 a1 ff ff ff       	call   8007b1 <printnum>
  800810:	83 c4 20             	add    $0x20,%esp
  800813:	eb 1a                	jmp    80082f <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800815:	83 ec 08             	sub    $0x8,%esp
  800818:	ff 75 0c             	pushl  0xc(%ebp)
  80081b:	ff 75 20             	pushl  0x20(%ebp)
  80081e:	8b 45 08             	mov    0x8(%ebp),%eax
  800821:	ff d0                	call   *%eax
  800823:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800826:	ff 4d 1c             	decl   0x1c(%ebp)
  800829:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  80082d:	7f e6                	jg     800815 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80082f:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800832:	bb 00 00 00 00       	mov    $0x0,%ebx
  800837:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80083a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80083d:	53                   	push   %ebx
  80083e:	51                   	push   %ecx
  80083f:	52                   	push   %edx
  800840:	50                   	push   %eax
  800841:	e8 26 15 00 00       	call   801d6c <__umoddi3>
  800846:	83 c4 10             	add    $0x10,%esp
  800849:	05 94 25 80 00       	add    $0x802594,%eax
  80084e:	8a 00                	mov    (%eax),%al
  800850:	0f be c0             	movsbl %al,%eax
  800853:	83 ec 08             	sub    $0x8,%esp
  800856:	ff 75 0c             	pushl  0xc(%ebp)
  800859:	50                   	push   %eax
  80085a:	8b 45 08             	mov    0x8(%ebp),%eax
  80085d:	ff d0                	call   *%eax
  80085f:	83 c4 10             	add    $0x10,%esp
}
  800862:	90                   	nop
  800863:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800866:	c9                   	leave  
  800867:	c3                   	ret    

00800868 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800868:	55                   	push   %ebp
  800869:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  80086b:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  80086f:	7e 1c                	jle    80088d <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800871:	8b 45 08             	mov    0x8(%ebp),%eax
  800874:	8b 00                	mov    (%eax),%eax
  800876:	8d 50 08             	lea    0x8(%eax),%edx
  800879:	8b 45 08             	mov    0x8(%ebp),%eax
  80087c:	89 10                	mov    %edx,(%eax)
  80087e:	8b 45 08             	mov    0x8(%ebp),%eax
  800881:	8b 00                	mov    (%eax),%eax
  800883:	83 e8 08             	sub    $0x8,%eax
  800886:	8b 50 04             	mov    0x4(%eax),%edx
  800889:	8b 00                	mov    (%eax),%eax
  80088b:	eb 40                	jmp    8008cd <getuint+0x65>
	else if (lflag)
  80088d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800891:	74 1e                	je     8008b1 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800893:	8b 45 08             	mov    0x8(%ebp),%eax
  800896:	8b 00                	mov    (%eax),%eax
  800898:	8d 50 04             	lea    0x4(%eax),%edx
  80089b:	8b 45 08             	mov    0x8(%ebp),%eax
  80089e:	89 10                	mov    %edx,(%eax)
  8008a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8008a3:	8b 00                	mov    (%eax),%eax
  8008a5:	83 e8 04             	sub    $0x4,%eax
  8008a8:	8b 00                	mov    (%eax),%eax
  8008aa:	ba 00 00 00 00       	mov    $0x0,%edx
  8008af:	eb 1c                	jmp    8008cd <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  8008b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8008b4:	8b 00                	mov    (%eax),%eax
  8008b6:	8d 50 04             	lea    0x4(%eax),%edx
  8008b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8008bc:	89 10                	mov    %edx,(%eax)
  8008be:	8b 45 08             	mov    0x8(%ebp),%eax
  8008c1:	8b 00                	mov    (%eax),%eax
  8008c3:	83 e8 04             	sub    $0x4,%eax
  8008c6:	8b 00                	mov    (%eax),%eax
  8008c8:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8008cd:	5d                   	pop    %ebp
  8008ce:	c3                   	ret    

008008cf <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8008cf:	55                   	push   %ebp
  8008d0:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8008d2:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8008d6:	7e 1c                	jle    8008f4 <getint+0x25>
		return va_arg(*ap, long long);
  8008d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8008db:	8b 00                	mov    (%eax),%eax
  8008dd:	8d 50 08             	lea    0x8(%eax),%edx
  8008e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8008e3:	89 10                	mov    %edx,(%eax)
  8008e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8008e8:	8b 00                	mov    (%eax),%eax
  8008ea:	83 e8 08             	sub    $0x8,%eax
  8008ed:	8b 50 04             	mov    0x4(%eax),%edx
  8008f0:	8b 00                	mov    (%eax),%eax
  8008f2:	eb 38                	jmp    80092c <getint+0x5d>
	else if (lflag)
  8008f4:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8008f8:	74 1a                	je     800914 <getint+0x45>
		return va_arg(*ap, long);
  8008fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8008fd:	8b 00                	mov    (%eax),%eax
  8008ff:	8d 50 04             	lea    0x4(%eax),%edx
  800902:	8b 45 08             	mov    0x8(%ebp),%eax
  800905:	89 10                	mov    %edx,(%eax)
  800907:	8b 45 08             	mov    0x8(%ebp),%eax
  80090a:	8b 00                	mov    (%eax),%eax
  80090c:	83 e8 04             	sub    $0x4,%eax
  80090f:	8b 00                	mov    (%eax),%eax
  800911:	99                   	cltd   
  800912:	eb 18                	jmp    80092c <getint+0x5d>
	else
		return va_arg(*ap, int);
  800914:	8b 45 08             	mov    0x8(%ebp),%eax
  800917:	8b 00                	mov    (%eax),%eax
  800919:	8d 50 04             	lea    0x4(%eax),%edx
  80091c:	8b 45 08             	mov    0x8(%ebp),%eax
  80091f:	89 10                	mov    %edx,(%eax)
  800921:	8b 45 08             	mov    0x8(%ebp),%eax
  800924:	8b 00                	mov    (%eax),%eax
  800926:	83 e8 04             	sub    $0x4,%eax
  800929:	8b 00                	mov    (%eax),%eax
  80092b:	99                   	cltd   
}
  80092c:	5d                   	pop    %ebp
  80092d:	c3                   	ret    

0080092e <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  80092e:	55                   	push   %ebp
  80092f:	89 e5                	mov    %esp,%ebp
  800931:	56                   	push   %esi
  800932:	53                   	push   %ebx
  800933:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800936:	eb 17                	jmp    80094f <vprintfmt+0x21>
			if (ch == '\0')
  800938:	85 db                	test   %ebx,%ebx
  80093a:	0f 84 c1 03 00 00    	je     800d01 <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  800940:	83 ec 08             	sub    $0x8,%esp
  800943:	ff 75 0c             	pushl  0xc(%ebp)
  800946:	53                   	push   %ebx
  800947:	8b 45 08             	mov    0x8(%ebp),%eax
  80094a:	ff d0                	call   *%eax
  80094c:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80094f:	8b 45 10             	mov    0x10(%ebp),%eax
  800952:	8d 50 01             	lea    0x1(%eax),%edx
  800955:	89 55 10             	mov    %edx,0x10(%ebp)
  800958:	8a 00                	mov    (%eax),%al
  80095a:	0f b6 d8             	movzbl %al,%ebx
  80095d:	83 fb 25             	cmp    $0x25,%ebx
  800960:	75 d6                	jne    800938 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800962:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800966:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  80096d:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800974:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  80097b:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800982:	8b 45 10             	mov    0x10(%ebp),%eax
  800985:	8d 50 01             	lea    0x1(%eax),%edx
  800988:	89 55 10             	mov    %edx,0x10(%ebp)
  80098b:	8a 00                	mov    (%eax),%al
  80098d:	0f b6 d8             	movzbl %al,%ebx
  800990:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800993:	83 f8 5b             	cmp    $0x5b,%eax
  800996:	0f 87 3d 03 00 00    	ja     800cd9 <vprintfmt+0x3ab>
  80099c:	8b 04 85 b8 25 80 00 	mov    0x8025b8(,%eax,4),%eax
  8009a3:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  8009a5:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  8009a9:	eb d7                	jmp    800982 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8009ab:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  8009af:	eb d1                	jmp    800982 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8009b1:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  8009b8:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8009bb:	89 d0                	mov    %edx,%eax
  8009bd:	c1 e0 02             	shl    $0x2,%eax
  8009c0:	01 d0                	add    %edx,%eax
  8009c2:	01 c0                	add    %eax,%eax
  8009c4:	01 d8                	add    %ebx,%eax
  8009c6:	83 e8 30             	sub    $0x30,%eax
  8009c9:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  8009cc:	8b 45 10             	mov    0x10(%ebp),%eax
  8009cf:	8a 00                	mov    (%eax),%al
  8009d1:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8009d4:	83 fb 2f             	cmp    $0x2f,%ebx
  8009d7:	7e 3e                	jle    800a17 <vprintfmt+0xe9>
  8009d9:	83 fb 39             	cmp    $0x39,%ebx
  8009dc:	7f 39                	jg     800a17 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8009de:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8009e1:	eb d5                	jmp    8009b8 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8009e3:	8b 45 14             	mov    0x14(%ebp),%eax
  8009e6:	83 c0 04             	add    $0x4,%eax
  8009e9:	89 45 14             	mov    %eax,0x14(%ebp)
  8009ec:	8b 45 14             	mov    0x14(%ebp),%eax
  8009ef:	83 e8 04             	sub    $0x4,%eax
  8009f2:	8b 00                	mov    (%eax),%eax
  8009f4:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  8009f7:	eb 1f                	jmp    800a18 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  8009f9:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8009fd:	79 83                	jns    800982 <vprintfmt+0x54>
				width = 0;
  8009ff:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800a06:	e9 77 ff ff ff       	jmp    800982 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800a0b:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800a12:	e9 6b ff ff ff       	jmp    800982 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800a17:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800a18:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a1c:	0f 89 60 ff ff ff    	jns    800982 <vprintfmt+0x54>
				width = precision, precision = -1;
  800a22:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800a25:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800a28:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800a2f:	e9 4e ff ff ff       	jmp    800982 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800a34:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800a37:	e9 46 ff ff ff       	jmp    800982 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800a3c:	8b 45 14             	mov    0x14(%ebp),%eax
  800a3f:	83 c0 04             	add    $0x4,%eax
  800a42:	89 45 14             	mov    %eax,0x14(%ebp)
  800a45:	8b 45 14             	mov    0x14(%ebp),%eax
  800a48:	83 e8 04             	sub    $0x4,%eax
  800a4b:	8b 00                	mov    (%eax),%eax
  800a4d:	83 ec 08             	sub    $0x8,%esp
  800a50:	ff 75 0c             	pushl  0xc(%ebp)
  800a53:	50                   	push   %eax
  800a54:	8b 45 08             	mov    0x8(%ebp),%eax
  800a57:	ff d0                	call   *%eax
  800a59:	83 c4 10             	add    $0x10,%esp
			break;
  800a5c:	e9 9b 02 00 00       	jmp    800cfc <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800a61:	8b 45 14             	mov    0x14(%ebp),%eax
  800a64:	83 c0 04             	add    $0x4,%eax
  800a67:	89 45 14             	mov    %eax,0x14(%ebp)
  800a6a:	8b 45 14             	mov    0x14(%ebp),%eax
  800a6d:	83 e8 04             	sub    $0x4,%eax
  800a70:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800a72:	85 db                	test   %ebx,%ebx
  800a74:	79 02                	jns    800a78 <vprintfmt+0x14a>
				err = -err;
  800a76:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800a78:	83 fb 64             	cmp    $0x64,%ebx
  800a7b:	7f 0b                	jg     800a88 <vprintfmt+0x15a>
  800a7d:	8b 34 9d 00 24 80 00 	mov    0x802400(,%ebx,4),%esi
  800a84:	85 f6                	test   %esi,%esi
  800a86:	75 19                	jne    800aa1 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800a88:	53                   	push   %ebx
  800a89:	68 a5 25 80 00       	push   $0x8025a5
  800a8e:	ff 75 0c             	pushl  0xc(%ebp)
  800a91:	ff 75 08             	pushl  0x8(%ebp)
  800a94:	e8 70 02 00 00       	call   800d09 <printfmt>
  800a99:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800a9c:	e9 5b 02 00 00       	jmp    800cfc <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800aa1:	56                   	push   %esi
  800aa2:	68 ae 25 80 00       	push   $0x8025ae
  800aa7:	ff 75 0c             	pushl  0xc(%ebp)
  800aaa:	ff 75 08             	pushl  0x8(%ebp)
  800aad:	e8 57 02 00 00       	call   800d09 <printfmt>
  800ab2:	83 c4 10             	add    $0x10,%esp
			break;
  800ab5:	e9 42 02 00 00       	jmp    800cfc <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800aba:	8b 45 14             	mov    0x14(%ebp),%eax
  800abd:	83 c0 04             	add    $0x4,%eax
  800ac0:	89 45 14             	mov    %eax,0x14(%ebp)
  800ac3:	8b 45 14             	mov    0x14(%ebp),%eax
  800ac6:	83 e8 04             	sub    $0x4,%eax
  800ac9:	8b 30                	mov    (%eax),%esi
  800acb:	85 f6                	test   %esi,%esi
  800acd:	75 05                	jne    800ad4 <vprintfmt+0x1a6>
				p = "(null)";
  800acf:	be b1 25 80 00       	mov    $0x8025b1,%esi
			if (width > 0 && padc != '-')
  800ad4:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800ad8:	7e 6d                	jle    800b47 <vprintfmt+0x219>
  800ada:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800ade:	74 67                	je     800b47 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800ae0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800ae3:	83 ec 08             	sub    $0x8,%esp
  800ae6:	50                   	push   %eax
  800ae7:	56                   	push   %esi
  800ae8:	e8 1e 03 00 00       	call   800e0b <strnlen>
  800aed:	83 c4 10             	add    $0x10,%esp
  800af0:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800af3:	eb 16                	jmp    800b0b <vprintfmt+0x1dd>
					putch(padc, putdat);
  800af5:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800af9:	83 ec 08             	sub    $0x8,%esp
  800afc:	ff 75 0c             	pushl  0xc(%ebp)
  800aff:	50                   	push   %eax
  800b00:	8b 45 08             	mov    0x8(%ebp),%eax
  800b03:	ff d0                	call   *%eax
  800b05:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800b08:	ff 4d e4             	decl   -0x1c(%ebp)
  800b0b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800b0f:	7f e4                	jg     800af5 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800b11:	eb 34                	jmp    800b47 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800b13:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800b17:	74 1c                	je     800b35 <vprintfmt+0x207>
  800b19:	83 fb 1f             	cmp    $0x1f,%ebx
  800b1c:	7e 05                	jle    800b23 <vprintfmt+0x1f5>
  800b1e:	83 fb 7e             	cmp    $0x7e,%ebx
  800b21:	7e 12                	jle    800b35 <vprintfmt+0x207>
					putch('?', putdat);
  800b23:	83 ec 08             	sub    $0x8,%esp
  800b26:	ff 75 0c             	pushl  0xc(%ebp)
  800b29:	6a 3f                	push   $0x3f
  800b2b:	8b 45 08             	mov    0x8(%ebp),%eax
  800b2e:	ff d0                	call   *%eax
  800b30:	83 c4 10             	add    $0x10,%esp
  800b33:	eb 0f                	jmp    800b44 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800b35:	83 ec 08             	sub    $0x8,%esp
  800b38:	ff 75 0c             	pushl  0xc(%ebp)
  800b3b:	53                   	push   %ebx
  800b3c:	8b 45 08             	mov    0x8(%ebp),%eax
  800b3f:	ff d0                	call   *%eax
  800b41:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800b44:	ff 4d e4             	decl   -0x1c(%ebp)
  800b47:	89 f0                	mov    %esi,%eax
  800b49:	8d 70 01             	lea    0x1(%eax),%esi
  800b4c:	8a 00                	mov    (%eax),%al
  800b4e:	0f be d8             	movsbl %al,%ebx
  800b51:	85 db                	test   %ebx,%ebx
  800b53:	74 24                	je     800b79 <vprintfmt+0x24b>
  800b55:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800b59:	78 b8                	js     800b13 <vprintfmt+0x1e5>
  800b5b:	ff 4d e0             	decl   -0x20(%ebp)
  800b5e:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800b62:	79 af                	jns    800b13 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800b64:	eb 13                	jmp    800b79 <vprintfmt+0x24b>
				putch(' ', putdat);
  800b66:	83 ec 08             	sub    $0x8,%esp
  800b69:	ff 75 0c             	pushl  0xc(%ebp)
  800b6c:	6a 20                	push   $0x20
  800b6e:	8b 45 08             	mov    0x8(%ebp),%eax
  800b71:	ff d0                	call   *%eax
  800b73:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800b76:	ff 4d e4             	decl   -0x1c(%ebp)
  800b79:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800b7d:	7f e7                	jg     800b66 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800b7f:	e9 78 01 00 00       	jmp    800cfc <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800b84:	83 ec 08             	sub    $0x8,%esp
  800b87:	ff 75 e8             	pushl  -0x18(%ebp)
  800b8a:	8d 45 14             	lea    0x14(%ebp),%eax
  800b8d:	50                   	push   %eax
  800b8e:	e8 3c fd ff ff       	call   8008cf <getint>
  800b93:	83 c4 10             	add    $0x10,%esp
  800b96:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b99:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800b9c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800b9f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800ba2:	85 d2                	test   %edx,%edx
  800ba4:	79 23                	jns    800bc9 <vprintfmt+0x29b>
				putch('-', putdat);
  800ba6:	83 ec 08             	sub    $0x8,%esp
  800ba9:	ff 75 0c             	pushl  0xc(%ebp)
  800bac:	6a 2d                	push   $0x2d
  800bae:	8b 45 08             	mov    0x8(%ebp),%eax
  800bb1:	ff d0                	call   *%eax
  800bb3:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800bb6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800bb9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800bbc:	f7 d8                	neg    %eax
  800bbe:	83 d2 00             	adc    $0x0,%edx
  800bc1:	f7 da                	neg    %edx
  800bc3:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800bc6:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800bc9:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800bd0:	e9 bc 00 00 00       	jmp    800c91 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800bd5:	83 ec 08             	sub    $0x8,%esp
  800bd8:	ff 75 e8             	pushl  -0x18(%ebp)
  800bdb:	8d 45 14             	lea    0x14(%ebp),%eax
  800bde:	50                   	push   %eax
  800bdf:	e8 84 fc ff ff       	call   800868 <getuint>
  800be4:	83 c4 10             	add    $0x10,%esp
  800be7:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800bea:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800bed:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800bf4:	e9 98 00 00 00       	jmp    800c91 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800bf9:	83 ec 08             	sub    $0x8,%esp
  800bfc:	ff 75 0c             	pushl  0xc(%ebp)
  800bff:	6a 58                	push   $0x58
  800c01:	8b 45 08             	mov    0x8(%ebp),%eax
  800c04:	ff d0                	call   *%eax
  800c06:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800c09:	83 ec 08             	sub    $0x8,%esp
  800c0c:	ff 75 0c             	pushl  0xc(%ebp)
  800c0f:	6a 58                	push   $0x58
  800c11:	8b 45 08             	mov    0x8(%ebp),%eax
  800c14:	ff d0                	call   *%eax
  800c16:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800c19:	83 ec 08             	sub    $0x8,%esp
  800c1c:	ff 75 0c             	pushl  0xc(%ebp)
  800c1f:	6a 58                	push   $0x58
  800c21:	8b 45 08             	mov    0x8(%ebp),%eax
  800c24:	ff d0                	call   *%eax
  800c26:	83 c4 10             	add    $0x10,%esp
			break;
  800c29:	e9 ce 00 00 00       	jmp    800cfc <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  800c2e:	83 ec 08             	sub    $0x8,%esp
  800c31:	ff 75 0c             	pushl  0xc(%ebp)
  800c34:	6a 30                	push   $0x30
  800c36:	8b 45 08             	mov    0x8(%ebp),%eax
  800c39:	ff d0                	call   *%eax
  800c3b:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800c3e:	83 ec 08             	sub    $0x8,%esp
  800c41:	ff 75 0c             	pushl  0xc(%ebp)
  800c44:	6a 78                	push   $0x78
  800c46:	8b 45 08             	mov    0x8(%ebp),%eax
  800c49:	ff d0                	call   *%eax
  800c4b:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800c4e:	8b 45 14             	mov    0x14(%ebp),%eax
  800c51:	83 c0 04             	add    $0x4,%eax
  800c54:	89 45 14             	mov    %eax,0x14(%ebp)
  800c57:	8b 45 14             	mov    0x14(%ebp),%eax
  800c5a:	83 e8 04             	sub    $0x4,%eax
  800c5d:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800c5f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c62:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800c69:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800c70:	eb 1f                	jmp    800c91 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800c72:	83 ec 08             	sub    $0x8,%esp
  800c75:	ff 75 e8             	pushl  -0x18(%ebp)
  800c78:	8d 45 14             	lea    0x14(%ebp),%eax
  800c7b:	50                   	push   %eax
  800c7c:	e8 e7 fb ff ff       	call   800868 <getuint>
  800c81:	83 c4 10             	add    $0x10,%esp
  800c84:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c87:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800c8a:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800c91:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800c95:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800c98:	83 ec 04             	sub    $0x4,%esp
  800c9b:	52                   	push   %edx
  800c9c:	ff 75 e4             	pushl  -0x1c(%ebp)
  800c9f:	50                   	push   %eax
  800ca0:	ff 75 f4             	pushl  -0xc(%ebp)
  800ca3:	ff 75 f0             	pushl  -0x10(%ebp)
  800ca6:	ff 75 0c             	pushl  0xc(%ebp)
  800ca9:	ff 75 08             	pushl  0x8(%ebp)
  800cac:	e8 00 fb ff ff       	call   8007b1 <printnum>
  800cb1:	83 c4 20             	add    $0x20,%esp
			break;
  800cb4:	eb 46                	jmp    800cfc <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800cb6:	83 ec 08             	sub    $0x8,%esp
  800cb9:	ff 75 0c             	pushl  0xc(%ebp)
  800cbc:	53                   	push   %ebx
  800cbd:	8b 45 08             	mov    0x8(%ebp),%eax
  800cc0:	ff d0                	call   *%eax
  800cc2:	83 c4 10             	add    $0x10,%esp
			break;
  800cc5:	eb 35                	jmp    800cfc <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  800cc7:	c6 05 44 30 80 00 00 	movb   $0x0,0x803044
			break;
  800cce:	eb 2c                	jmp    800cfc <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  800cd0:	c6 05 44 30 80 00 01 	movb   $0x1,0x803044
			break;
  800cd7:	eb 23                	jmp    800cfc <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800cd9:	83 ec 08             	sub    $0x8,%esp
  800cdc:	ff 75 0c             	pushl  0xc(%ebp)
  800cdf:	6a 25                	push   $0x25
  800ce1:	8b 45 08             	mov    0x8(%ebp),%eax
  800ce4:	ff d0                	call   *%eax
  800ce6:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800ce9:	ff 4d 10             	decl   0x10(%ebp)
  800cec:	eb 03                	jmp    800cf1 <vprintfmt+0x3c3>
  800cee:	ff 4d 10             	decl   0x10(%ebp)
  800cf1:	8b 45 10             	mov    0x10(%ebp),%eax
  800cf4:	48                   	dec    %eax
  800cf5:	8a 00                	mov    (%eax),%al
  800cf7:	3c 25                	cmp    $0x25,%al
  800cf9:	75 f3                	jne    800cee <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  800cfb:	90                   	nop
		}
	}
  800cfc:	e9 35 fc ff ff       	jmp    800936 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800d01:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800d02:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800d05:	5b                   	pop    %ebx
  800d06:	5e                   	pop    %esi
  800d07:	5d                   	pop    %ebp
  800d08:	c3                   	ret    

00800d09 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800d09:	55                   	push   %ebp
  800d0a:	89 e5                	mov    %esp,%ebp
  800d0c:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800d0f:	8d 45 10             	lea    0x10(%ebp),%eax
  800d12:	83 c0 04             	add    $0x4,%eax
  800d15:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800d18:	8b 45 10             	mov    0x10(%ebp),%eax
  800d1b:	ff 75 f4             	pushl  -0xc(%ebp)
  800d1e:	50                   	push   %eax
  800d1f:	ff 75 0c             	pushl  0xc(%ebp)
  800d22:	ff 75 08             	pushl  0x8(%ebp)
  800d25:	e8 04 fc ff ff       	call   80092e <vprintfmt>
  800d2a:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800d2d:	90                   	nop
  800d2e:	c9                   	leave  
  800d2f:	c3                   	ret    

00800d30 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800d30:	55                   	push   %ebp
  800d31:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800d33:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d36:	8b 40 08             	mov    0x8(%eax),%eax
  800d39:	8d 50 01             	lea    0x1(%eax),%edx
  800d3c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d3f:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800d42:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d45:	8b 10                	mov    (%eax),%edx
  800d47:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d4a:	8b 40 04             	mov    0x4(%eax),%eax
  800d4d:	39 c2                	cmp    %eax,%edx
  800d4f:	73 12                	jae    800d63 <sprintputch+0x33>
		*b->buf++ = ch;
  800d51:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d54:	8b 00                	mov    (%eax),%eax
  800d56:	8d 48 01             	lea    0x1(%eax),%ecx
  800d59:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d5c:	89 0a                	mov    %ecx,(%edx)
  800d5e:	8b 55 08             	mov    0x8(%ebp),%edx
  800d61:	88 10                	mov    %dl,(%eax)
}
  800d63:	90                   	nop
  800d64:	5d                   	pop    %ebp
  800d65:	c3                   	ret    

00800d66 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800d66:	55                   	push   %ebp
  800d67:	89 e5                	mov    %esp,%ebp
  800d69:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800d6c:	8b 45 08             	mov    0x8(%ebp),%eax
  800d6f:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800d72:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d75:	8d 50 ff             	lea    -0x1(%eax),%edx
  800d78:	8b 45 08             	mov    0x8(%ebp),%eax
  800d7b:	01 d0                	add    %edx,%eax
  800d7d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800d80:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800d87:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800d8b:	74 06                	je     800d93 <vsnprintf+0x2d>
  800d8d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800d91:	7f 07                	jg     800d9a <vsnprintf+0x34>
		return -E_INVAL;
  800d93:	b8 03 00 00 00       	mov    $0x3,%eax
  800d98:	eb 20                	jmp    800dba <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800d9a:	ff 75 14             	pushl  0x14(%ebp)
  800d9d:	ff 75 10             	pushl  0x10(%ebp)
  800da0:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800da3:	50                   	push   %eax
  800da4:	68 30 0d 80 00       	push   $0x800d30
  800da9:	e8 80 fb ff ff       	call   80092e <vprintfmt>
  800dae:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800db1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800db4:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800db7:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800dba:	c9                   	leave  
  800dbb:	c3                   	ret    

00800dbc <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800dbc:	55                   	push   %ebp
  800dbd:	89 e5                	mov    %esp,%ebp
  800dbf:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800dc2:	8d 45 10             	lea    0x10(%ebp),%eax
  800dc5:	83 c0 04             	add    $0x4,%eax
  800dc8:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800dcb:	8b 45 10             	mov    0x10(%ebp),%eax
  800dce:	ff 75 f4             	pushl  -0xc(%ebp)
  800dd1:	50                   	push   %eax
  800dd2:	ff 75 0c             	pushl  0xc(%ebp)
  800dd5:	ff 75 08             	pushl  0x8(%ebp)
  800dd8:	e8 89 ff ff ff       	call   800d66 <vsnprintf>
  800ddd:	83 c4 10             	add    $0x10,%esp
  800de0:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800de3:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800de6:	c9                   	leave  
  800de7:	c3                   	ret    

00800de8 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800de8:	55                   	push   %ebp
  800de9:	89 e5                	mov    %esp,%ebp
  800deb:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800dee:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800df5:	eb 06                	jmp    800dfd <strlen+0x15>
		n++;
  800df7:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800dfa:	ff 45 08             	incl   0x8(%ebp)
  800dfd:	8b 45 08             	mov    0x8(%ebp),%eax
  800e00:	8a 00                	mov    (%eax),%al
  800e02:	84 c0                	test   %al,%al
  800e04:	75 f1                	jne    800df7 <strlen+0xf>
		n++;
	return n;
  800e06:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800e09:	c9                   	leave  
  800e0a:	c3                   	ret    

00800e0b <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800e0b:	55                   	push   %ebp
  800e0c:	89 e5                	mov    %esp,%ebp
  800e0e:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800e11:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800e18:	eb 09                	jmp    800e23 <strnlen+0x18>
		n++;
  800e1a:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800e1d:	ff 45 08             	incl   0x8(%ebp)
  800e20:	ff 4d 0c             	decl   0xc(%ebp)
  800e23:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800e27:	74 09                	je     800e32 <strnlen+0x27>
  800e29:	8b 45 08             	mov    0x8(%ebp),%eax
  800e2c:	8a 00                	mov    (%eax),%al
  800e2e:	84 c0                	test   %al,%al
  800e30:	75 e8                	jne    800e1a <strnlen+0xf>
		n++;
	return n;
  800e32:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800e35:	c9                   	leave  
  800e36:	c3                   	ret    

00800e37 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800e37:	55                   	push   %ebp
  800e38:	89 e5                	mov    %esp,%ebp
  800e3a:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800e3d:	8b 45 08             	mov    0x8(%ebp),%eax
  800e40:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800e43:	90                   	nop
  800e44:	8b 45 08             	mov    0x8(%ebp),%eax
  800e47:	8d 50 01             	lea    0x1(%eax),%edx
  800e4a:	89 55 08             	mov    %edx,0x8(%ebp)
  800e4d:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e50:	8d 4a 01             	lea    0x1(%edx),%ecx
  800e53:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800e56:	8a 12                	mov    (%edx),%dl
  800e58:	88 10                	mov    %dl,(%eax)
  800e5a:	8a 00                	mov    (%eax),%al
  800e5c:	84 c0                	test   %al,%al
  800e5e:	75 e4                	jne    800e44 <strcpy+0xd>
		/* do nothing */;
	return ret;
  800e60:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800e63:	c9                   	leave  
  800e64:	c3                   	ret    

00800e65 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800e65:	55                   	push   %ebp
  800e66:	89 e5                	mov    %esp,%ebp
  800e68:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800e6b:	8b 45 08             	mov    0x8(%ebp),%eax
  800e6e:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800e71:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800e78:	eb 1f                	jmp    800e99 <strncpy+0x34>
		*dst++ = *src;
  800e7a:	8b 45 08             	mov    0x8(%ebp),%eax
  800e7d:	8d 50 01             	lea    0x1(%eax),%edx
  800e80:	89 55 08             	mov    %edx,0x8(%ebp)
  800e83:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e86:	8a 12                	mov    (%edx),%dl
  800e88:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800e8a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e8d:	8a 00                	mov    (%eax),%al
  800e8f:	84 c0                	test   %al,%al
  800e91:	74 03                	je     800e96 <strncpy+0x31>
			src++;
  800e93:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800e96:	ff 45 fc             	incl   -0x4(%ebp)
  800e99:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e9c:	3b 45 10             	cmp    0x10(%ebp),%eax
  800e9f:	72 d9                	jb     800e7a <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800ea1:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800ea4:	c9                   	leave  
  800ea5:	c3                   	ret    

00800ea6 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800ea6:	55                   	push   %ebp
  800ea7:	89 e5                	mov    %esp,%ebp
  800ea9:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800eac:	8b 45 08             	mov    0x8(%ebp),%eax
  800eaf:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800eb2:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800eb6:	74 30                	je     800ee8 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800eb8:	eb 16                	jmp    800ed0 <strlcpy+0x2a>
			*dst++ = *src++;
  800eba:	8b 45 08             	mov    0x8(%ebp),%eax
  800ebd:	8d 50 01             	lea    0x1(%eax),%edx
  800ec0:	89 55 08             	mov    %edx,0x8(%ebp)
  800ec3:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ec6:	8d 4a 01             	lea    0x1(%edx),%ecx
  800ec9:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800ecc:	8a 12                	mov    (%edx),%dl
  800ece:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800ed0:	ff 4d 10             	decl   0x10(%ebp)
  800ed3:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ed7:	74 09                	je     800ee2 <strlcpy+0x3c>
  800ed9:	8b 45 0c             	mov    0xc(%ebp),%eax
  800edc:	8a 00                	mov    (%eax),%al
  800ede:	84 c0                	test   %al,%al
  800ee0:	75 d8                	jne    800eba <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800ee2:	8b 45 08             	mov    0x8(%ebp),%eax
  800ee5:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800ee8:	8b 55 08             	mov    0x8(%ebp),%edx
  800eeb:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800eee:	29 c2                	sub    %eax,%edx
  800ef0:	89 d0                	mov    %edx,%eax
}
  800ef2:	c9                   	leave  
  800ef3:	c3                   	ret    

00800ef4 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800ef4:	55                   	push   %ebp
  800ef5:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800ef7:	eb 06                	jmp    800eff <strcmp+0xb>
		p++, q++;
  800ef9:	ff 45 08             	incl   0x8(%ebp)
  800efc:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800eff:	8b 45 08             	mov    0x8(%ebp),%eax
  800f02:	8a 00                	mov    (%eax),%al
  800f04:	84 c0                	test   %al,%al
  800f06:	74 0e                	je     800f16 <strcmp+0x22>
  800f08:	8b 45 08             	mov    0x8(%ebp),%eax
  800f0b:	8a 10                	mov    (%eax),%dl
  800f0d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f10:	8a 00                	mov    (%eax),%al
  800f12:	38 c2                	cmp    %al,%dl
  800f14:	74 e3                	je     800ef9 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800f16:	8b 45 08             	mov    0x8(%ebp),%eax
  800f19:	8a 00                	mov    (%eax),%al
  800f1b:	0f b6 d0             	movzbl %al,%edx
  800f1e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f21:	8a 00                	mov    (%eax),%al
  800f23:	0f b6 c0             	movzbl %al,%eax
  800f26:	29 c2                	sub    %eax,%edx
  800f28:	89 d0                	mov    %edx,%eax
}
  800f2a:	5d                   	pop    %ebp
  800f2b:	c3                   	ret    

00800f2c <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800f2c:	55                   	push   %ebp
  800f2d:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800f2f:	eb 09                	jmp    800f3a <strncmp+0xe>
		n--, p++, q++;
  800f31:	ff 4d 10             	decl   0x10(%ebp)
  800f34:	ff 45 08             	incl   0x8(%ebp)
  800f37:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800f3a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f3e:	74 17                	je     800f57 <strncmp+0x2b>
  800f40:	8b 45 08             	mov    0x8(%ebp),%eax
  800f43:	8a 00                	mov    (%eax),%al
  800f45:	84 c0                	test   %al,%al
  800f47:	74 0e                	je     800f57 <strncmp+0x2b>
  800f49:	8b 45 08             	mov    0x8(%ebp),%eax
  800f4c:	8a 10                	mov    (%eax),%dl
  800f4e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f51:	8a 00                	mov    (%eax),%al
  800f53:	38 c2                	cmp    %al,%dl
  800f55:	74 da                	je     800f31 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800f57:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f5b:	75 07                	jne    800f64 <strncmp+0x38>
		return 0;
  800f5d:	b8 00 00 00 00       	mov    $0x0,%eax
  800f62:	eb 14                	jmp    800f78 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800f64:	8b 45 08             	mov    0x8(%ebp),%eax
  800f67:	8a 00                	mov    (%eax),%al
  800f69:	0f b6 d0             	movzbl %al,%edx
  800f6c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f6f:	8a 00                	mov    (%eax),%al
  800f71:	0f b6 c0             	movzbl %al,%eax
  800f74:	29 c2                	sub    %eax,%edx
  800f76:	89 d0                	mov    %edx,%eax
}
  800f78:	5d                   	pop    %ebp
  800f79:	c3                   	ret    

00800f7a <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800f7a:	55                   	push   %ebp
  800f7b:	89 e5                	mov    %esp,%ebp
  800f7d:	83 ec 04             	sub    $0x4,%esp
  800f80:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f83:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800f86:	eb 12                	jmp    800f9a <strchr+0x20>
		if (*s == c)
  800f88:	8b 45 08             	mov    0x8(%ebp),%eax
  800f8b:	8a 00                	mov    (%eax),%al
  800f8d:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800f90:	75 05                	jne    800f97 <strchr+0x1d>
			return (char *) s;
  800f92:	8b 45 08             	mov    0x8(%ebp),%eax
  800f95:	eb 11                	jmp    800fa8 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800f97:	ff 45 08             	incl   0x8(%ebp)
  800f9a:	8b 45 08             	mov    0x8(%ebp),%eax
  800f9d:	8a 00                	mov    (%eax),%al
  800f9f:	84 c0                	test   %al,%al
  800fa1:	75 e5                	jne    800f88 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800fa3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800fa8:	c9                   	leave  
  800fa9:	c3                   	ret    

00800faa <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800faa:	55                   	push   %ebp
  800fab:	89 e5                	mov    %esp,%ebp
  800fad:	83 ec 04             	sub    $0x4,%esp
  800fb0:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fb3:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800fb6:	eb 0d                	jmp    800fc5 <strfind+0x1b>
		if (*s == c)
  800fb8:	8b 45 08             	mov    0x8(%ebp),%eax
  800fbb:	8a 00                	mov    (%eax),%al
  800fbd:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800fc0:	74 0e                	je     800fd0 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800fc2:	ff 45 08             	incl   0x8(%ebp)
  800fc5:	8b 45 08             	mov    0x8(%ebp),%eax
  800fc8:	8a 00                	mov    (%eax),%al
  800fca:	84 c0                	test   %al,%al
  800fcc:	75 ea                	jne    800fb8 <strfind+0xe>
  800fce:	eb 01                	jmp    800fd1 <strfind+0x27>
		if (*s == c)
			break;
  800fd0:	90                   	nop
	return (char *) s;
  800fd1:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800fd4:	c9                   	leave  
  800fd5:	c3                   	ret    

00800fd6 <memset>:

// *************** The faster implementation of memset & memcpy is implemented by *************
// ****************** Team80 (Yahia Khaled, Malek Ahmed et al) - FCIS'24-25 *******************
void *
memset(void *v, int c, uint32 n)
{
  800fd6:	55                   	push   %ebp
  800fd7:	89 e5                	mov    %esp,%ebp
  800fd9:	83 ec 10             	sub    $0x10,%esp
//	m = n;
//	while (--m >= 0)
//		*p++ = c;

	/*Faster Implementation*/
	uint64* p64 = (uint64*)v;
  800fdc:	8b 45 08             	mov    0x8(%ebp),%eax
  800fdf:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if(n >= 8){
  800fe2:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800fe6:	76 63                	jbe    80104b <memset+0x75>
		uint64 data_block = c;
  800fe8:	8b 45 0c             	mov    0xc(%ebp),%eax
  800feb:	99                   	cltd   
  800fec:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800fef:	89 55 f4             	mov    %edx,-0xc(%ebp)
		data_block |= data_block << 8;
  800ff2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800ff5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800ff8:	0f a4 c2 08          	shld   $0x8,%eax,%edx
  800ffc:	c1 e0 08             	shl    $0x8,%eax
  800fff:	09 45 f0             	or     %eax,-0x10(%ebp)
  801002:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 16;
  801005:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801008:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80100b:	0f a4 c2 10          	shld   $0x10,%eax,%edx
  80100f:	c1 e0 10             	shl    $0x10,%eax
  801012:	09 45 f0             	or     %eax,-0x10(%ebp)
  801015:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 32;
  801018:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80101b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80101e:	89 c2                	mov    %eax,%edx
  801020:	b8 00 00 00 00       	mov    $0x0,%eax
  801025:	09 45 f0             	or     %eax,-0x10(%ebp)
  801028:	09 55 f4             	or     %edx,-0xc(%ebp)

		while(n >= 8)
  80102b:	eb 18                	jmp    801045 <memset+0x6f>
			*p64++ = data_block, n -= 8;
  80102d:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801030:	8d 41 08             	lea    0x8(%ecx),%eax
  801033:	89 45 fc             	mov    %eax,-0x4(%ebp)
  801036:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801039:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80103c:	89 01                	mov    %eax,(%ecx)
  80103e:	89 51 04             	mov    %edx,0x4(%ecx)
  801041:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
		uint64 data_block = c;
		data_block |= data_block << 8;
		data_block |= data_block << 16;
		data_block |= data_block << 32;

		while(n >= 8)
  801045:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  801049:	77 e2                	ja     80102d <memset+0x57>
			*p64++ = data_block, n -= 8;
	}

	if(n){
  80104b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80104f:	74 23                	je     801074 <memset+0x9e>
		uint8* p8 = (uint8*)p64;
  801051:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801054:	89 45 f8             	mov    %eax,-0x8(%ebp)
		while (n-- > 0)
  801057:	eb 0e                	jmp    801067 <memset+0x91>
			*p8++ = (uint8)c;
  801059:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80105c:	8d 50 01             	lea    0x1(%eax),%edx
  80105f:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801062:	8b 55 0c             	mov    0xc(%ebp),%edx
  801065:	88 10                	mov    %dl,(%eax)
			*p64++ = data_block, n -= 8;
	}

	if(n){
		uint8* p8 = (uint8*)p64;
		while (n-- > 0)
  801067:	8b 45 10             	mov    0x10(%ebp),%eax
  80106a:	8d 50 ff             	lea    -0x1(%eax),%edx
  80106d:	89 55 10             	mov    %edx,0x10(%ebp)
  801070:	85 c0                	test   %eax,%eax
  801072:	75 e5                	jne    801059 <memset+0x83>
			*p8++ = (uint8)c;
	}

	return v;
  801074:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801077:	c9                   	leave  
  801078:	c3                   	ret    

00801079 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  801079:	55                   	push   %ebp
  80107a:	89 e5                	mov    %esp,%ebp
  80107c:	83 ec 10             	sub    $0x10,%esp
	//	s = src;
	//	d = dst;
	//	while (n-- > 0)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
  80107f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801082:	89 45 fc             	mov    %eax,-0x4(%ebp)
	uint64* d64 = (uint64*)dst;
  801085:	8b 45 08             	mov    0x8(%ebp),%eax
  801088:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if(n >= 8){
  80108b:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  80108f:	76 24                	jbe    8010b5 <memcpy+0x3c>
		while(n >= 8){
  801091:	eb 1c                	jmp    8010af <memcpy+0x36>
			*d64 = *s64;
  801093:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801096:	8b 50 04             	mov    0x4(%eax),%edx
  801099:	8b 00                	mov    (%eax),%eax
  80109b:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  80109e:	89 01                	mov    %eax,(%ecx)
  8010a0:	89 51 04             	mov    %edx,0x4(%ecx)
			n -= 8;
  8010a3:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
			++s64;
  8010a7:	83 45 fc 08          	addl   $0x8,-0x4(%ebp)
			++d64;
  8010ab:	83 45 f8 08          	addl   $0x8,-0x8(%ebp)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
	uint64* d64 = (uint64*)dst;
	if(n >= 8){
		while(n >= 8){
  8010af:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  8010b3:	77 de                	ja     801093 <memcpy+0x1a>
			++s64;
			++d64;
		}
	}

	if(n){
  8010b5:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8010b9:	74 31                	je     8010ec <memcpy+0x73>
		uint8* s8 = (uint8*)s64;
  8010bb:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8010be:	89 45 f4             	mov    %eax,-0xc(%ebp)
		uint8* d8 = (uint8*)d64;
  8010c1:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010c4:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (n-- > 0)
  8010c7:	eb 16                	jmp    8010df <memcpy+0x66>
			*d8++ = *s8++;
  8010c9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8010cc:	8d 50 01             	lea    0x1(%eax),%edx
  8010cf:	89 55 f0             	mov    %edx,-0x10(%ebp)
  8010d2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8010d5:	8d 4a 01             	lea    0x1(%edx),%ecx
  8010d8:	89 4d f4             	mov    %ecx,-0xc(%ebp)
  8010db:	8a 12                	mov    (%edx),%dl
  8010dd:	88 10                	mov    %dl,(%eax)
	}

	if(n){
		uint8* s8 = (uint8*)s64;
		uint8* d8 = (uint8*)d64;
		while (n-- > 0)
  8010df:	8b 45 10             	mov    0x10(%ebp),%eax
  8010e2:	8d 50 ff             	lea    -0x1(%eax),%edx
  8010e5:	89 55 10             	mov    %edx,0x10(%ebp)
  8010e8:	85 c0                	test   %eax,%eax
  8010ea:	75 dd                	jne    8010c9 <memcpy+0x50>
			*d8++ = *s8++;
	}
	return dst;
  8010ec:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8010ef:	c9                   	leave  
  8010f0:	c3                   	ret    

008010f1 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  8010f1:	55                   	push   %ebp
  8010f2:	89 e5                	mov    %esp,%ebp
  8010f4:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  8010f7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010fa:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  8010fd:	8b 45 08             	mov    0x8(%ebp),%eax
  801100:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  801103:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801106:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801109:	73 50                	jae    80115b <memmove+0x6a>
  80110b:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80110e:	8b 45 10             	mov    0x10(%ebp),%eax
  801111:	01 d0                	add    %edx,%eax
  801113:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801116:	76 43                	jbe    80115b <memmove+0x6a>
		s += n;
  801118:	8b 45 10             	mov    0x10(%ebp),%eax
  80111b:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  80111e:	8b 45 10             	mov    0x10(%ebp),%eax
  801121:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  801124:	eb 10                	jmp    801136 <memmove+0x45>
			*--d = *--s;
  801126:	ff 4d f8             	decl   -0x8(%ebp)
  801129:	ff 4d fc             	decl   -0x4(%ebp)
  80112c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80112f:	8a 10                	mov    (%eax),%dl
  801131:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801134:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  801136:	8b 45 10             	mov    0x10(%ebp),%eax
  801139:	8d 50 ff             	lea    -0x1(%eax),%edx
  80113c:	89 55 10             	mov    %edx,0x10(%ebp)
  80113f:	85 c0                	test   %eax,%eax
  801141:	75 e3                	jne    801126 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  801143:	eb 23                	jmp    801168 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  801145:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801148:	8d 50 01             	lea    0x1(%eax),%edx
  80114b:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80114e:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801151:	8d 4a 01             	lea    0x1(%edx),%ecx
  801154:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801157:	8a 12                	mov    (%edx),%dl
  801159:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  80115b:	8b 45 10             	mov    0x10(%ebp),%eax
  80115e:	8d 50 ff             	lea    -0x1(%eax),%edx
  801161:	89 55 10             	mov    %edx,0x10(%ebp)
  801164:	85 c0                	test   %eax,%eax
  801166:	75 dd                	jne    801145 <memmove+0x54>
			*d++ = *s++;

	return dst;
  801168:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80116b:	c9                   	leave  
  80116c:	c3                   	ret    

0080116d <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  80116d:	55                   	push   %ebp
  80116e:	89 e5                	mov    %esp,%ebp
  801170:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  801173:	8b 45 08             	mov    0x8(%ebp),%eax
  801176:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  801179:	8b 45 0c             	mov    0xc(%ebp),%eax
  80117c:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  80117f:	eb 2a                	jmp    8011ab <memcmp+0x3e>
		if (*s1 != *s2)
  801181:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801184:	8a 10                	mov    (%eax),%dl
  801186:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801189:	8a 00                	mov    (%eax),%al
  80118b:	38 c2                	cmp    %al,%dl
  80118d:	74 16                	je     8011a5 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  80118f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801192:	8a 00                	mov    (%eax),%al
  801194:	0f b6 d0             	movzbl %al,%edx
  801197:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80119a:	8a 00                	mov    (%eax),%al
  80119c:	0f b6 c0             	movzbl %al,%eax
  80119f:	29 c2                	sub    %eax,%edx
  8011a1:	89 d0                	mov    %edx,%eax
  8011a3:	eb 18                	jmp    8011bd <memcmp+0x50>
		s1++, s2++;
  8011a5:	ff 45 fc             	incl   -0x4(%ebp)
  8011a8:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  8011ab:	8b 45 10             	mov    0x10(%ebp),%eax
  8011ae:	8d 50 ff             	lea    -0x1(%eax),%edx
  8011b1:	89 55 10             	mov    %edx,0x10(%ebp)
  8011b4:	85 c0                	test   %eax,%eax
  8011b6:	75 c9                	jne    801181 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  8011b8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8011bd:	c9                   	leave  
  8011be:	c3                   	ret    

008011bf <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  8011bf:	55                   	push   %ebp
  8011c0:	89 e5                	mov    %esp,%ebp
  8011c2:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  8011c5:	8b 55 08             	mov    0x8(%ebp),%edx
  8011c8:	8b 45 10             	mov    0x10(%ebp),%eax
  8011cb:	01 d0                	add    %edx,%eax
  8011cd:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  8011d0:	eb 15                	jmp    8011e7 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  8011d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8011d5:	8a 00                	mov    (%eax),%al
  8011d7:	0f b6 d0             	movzbl %al,%edx
  8011da:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011dd:	0f b6 c0             	movzbl %al,%eax
  8011e0:	39 c2                	cmp    %eax,%edx
  8011e2:	74 0d                	je     8011f1 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  8011e4:	ff 45 08             	incl   0x8(%ebp)
  8011e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8011ea:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  8011ed:	72 e3                	jb     8011d2 <memfind+0x13>
  8011ef:	eb 01                	jmp    8011f2 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  8011f1:	90                   	nop
	return (void *) s;
  8011f2:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8011f5:	c9                   	leave  
  8011f6:	c3                   	ret    

008011f7 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  8011f7:	55                   	push   %ebp
  8011f8:	89 e5                	mov    %esp,%ebp
  8011fa:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  8011fd:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  801204:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80120b:	eb 03                	jmp    801210 <strtol+0x19>
		s++;
  80120d:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801210:	8b 45 08             	mov    0x8(%ebp),%eax
  801213:	8a 00                	mov    (%eax),%al
  801215:	3c 20                	cmp    $0x20,%al
  801217:	74 f4                	je     80120d <strtol+0x16>
  801219:	8b 45 08             	mov    0x8(%ebp),%eax
  80121c:	8a 00                	mov    (%eax),%al
  80121e:	3c 09                	cmp    $0x9,%al
  801220:	74 eb                	je     80120d <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  801222:	8b 45 08             	mov    0x8(%ebp),%eax
  801225:	8a 00                	mov    (%eax),%al
  801227:	3c 2b                	cmp    $0x2b,%al
  801229:	75 05                	jne    801230 <strtol+0x39>
		s++;
  80122b:	ff 45 08             	incl   0x8(%ebp)
  80122e:	eb 13                	jmp    801243 <strtol+0x4c>
	else if (*s == '-')
  801230:	8b 45 08             	mov    0x8(%ebp),%eax
  801233:	8a 00                	mov    (%eax),%al
  801235:	3c 2d                	cmp    $0x2d,%al
  801237:	75 0a                	jne    801243 <strtol+0x4c>
		s++, neg = 1;
  801239:	ff 45 08             	incl   0x8(%ebp)
  80123c:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801243:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801247:	74 06                	je     80124f <strtol+0x58>
  801249:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  80124d:	75 20                	jne    80126f <strtol+0x78>
  80124f:	8b 45 08             	mov    0x8(%ebp),%eax
  801252:	8a 00                	mov    (%eax),%al
  801254:	3c 30                	cmp    $0x30,%al
  801256:	75 17                	jne    80126f <strtol+0x78>
  801258:	8b 45 08             	mov    0x8(%ebp),%eax
  80125b:	40                   	inc    %eax
  80125c:	8a 00                	mov    (%eax),%al
  80125e:	3c 78                	cmp    $0x78,%al
  801260:	75 0d                	jne    80126f <strtol+0x78>
		s += 2, base = 16;
  801262:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  801266:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  80126d:	eb 28                	jmp    801297 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  80126f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801273:	75 15                	jne    80128a <strtol+0x93>
  801275:	8b 45 08             	mov    0x8(%ebp),%eax
  801278:	8a 00                	mov    (%eax),%al
  80127a:	3c 30                	cmp    $0x30,%al
  80127c:	75 0c                	jne    80128a <strtol+0x93>
		s++, base = 8;
  80127e:	ff 45 08             	incl   0x8(%ebp)
  801281:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  801288:	eb 0d                	jmp    801297 <strtol+0xa0>
	else if (base == 0)
  80128a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80128e:	75 07                	jne    801297 <strtol+0xa0>
		base = 10;
  801290:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801297:	8b 45 08             	mov    0x8(%ebp),%eax
  80129a:	8a 00                	mov    (%eax),%al
  80129c:	3c 2f                	cmp    $0x2f,%al
  80129e:	7e 19                	jle    8012b9 <strtol+0xc2>
  8012a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8012a3:	8a 00                	mov    (%eax),%al
  8012a5:	3c 39                	cmp    $0x39,%al
  8012a7:	7f 10                	jg     8012b9 <strtol+0xc2>
			dig = *s - '0';
  8012a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8012ac:	8a 00                	mov    (%eax),%al
  8012ae:	0f be c0             	movsbl %al,%eax
  8012b1:	83 e8 30             	sub    $0x30,%eax
  8012b4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8012b7:	eb 42                	jmp    8012fb <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  8012b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8012bc:	8a 00                	mov    (%eax),%al
  8012be:	3c 60                	cmp    $0x60,%al
  8012c0:	7e 19                	jle    8012db <strtol+0xe4>
  8012c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8012c5:	8a 00                	mov    (%eax),%al
  8012c7:	3c 7a                	cmp    $0x7a,%al
  8012c9:	7f 10                	jg     8012db <strtol+0xe4>
			dig = *s - 'a' + 10;
  8012cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8012ce:	8a 00                	mov    (%eax),%al
  8012d0:	0f be c0             	movsbl %al,%eax
  8012d3:	83 e8 57             	sub    $0x57,%eax
  8012d6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8012d9:	eb 20                	jmp    8012fb <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  8012db:	8b 45 08             	mov    0x8(%ebp),%eax
  8012de:	8a 00                	mov    (%eax),%al
  8012e0:	3c 40                	cmp    $0x40,%al
  8012e2:	7e 39                	jle    80131d <strtol+0x126>
  8012e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8012e7:	8a 00                	mov    (%eax),%al
  8012e9:	3c 5a                	cmp    $0x5a,%al
  8012eb:	7f 30                	jg     80131d <strtol+0x126>
			dig = *s - 'A' + 10;
  8012ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8012f0:	8a 00                	mov    (%eax),%al
  8012f2:	0f be c0             	movsbl %al,%eax
  8012f5:	83 e8 37             	sub    $0x37,%eax
  8012f8:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  8012fb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8012fe:	3b 45 10             	cmp    0x10(%ebp),%eax
  801301:	7d 19                	jge    80131c <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801303:	ff 45 08             	incl   0x8(%ebp)
  801306:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801309:	0f af 45 10          	imul   0x10(%ebp),%eax
  80130d:	89 c2                	mov    %eax,%edx
  80130f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801312:	01 d0                	add    %edx,%eax
  801314:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  801317:	e9 7b ff ff ff       	jmp    801297 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  80131c:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  80131d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801321:	74 08                	je     80132b <strtol+0x134>
		*endptr = (char *) s;
  801323:	8b 45 0c             	mov    0xc(%ebp),%eax
  801326:	8b 55 08             	mov    0x8(%ebp),%edx
  801329:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  80132b:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80132f:	74 07                	je     801338 <strtol+0x141>
  801331:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801334:	f7 d8                	neg    %eax
  801336:	eb 03                	jmp    80133b <strtol+0x144>
  801338:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  80133b:	c9                   	leave  
  80133c:	c3                   	ret    

0080133d <ltostr>:

void
ltostr(long value, char *str)
{
  80133d:	55                   	push   %ebp
  80133e:	89 e5                	mov    %esp,%ebp
  801340:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  801343:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  80134a:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  801351:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801355:	79 13                	jns    80136a <ltostr+0x2d>
	{
		neg = 1;
  801357:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  80135e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801361:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  801364:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  801367:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  80136a:	8b 45 08             	mov    0x8(%ebp),%eax
  80136d:	b9 0a 00 00 00       	mov    $0xa,%ecx
  801372:	99                   	cltd   
  801373:	f7 f9                	idiv   %ecx
  801375:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  801378:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80137b:	8d 50 01             	lea    0x1(%eax),%edx
  80137e:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801381:	89 c2                	mov    %eax,%edx
  801383:	8b 45 0c             	mov    0xc(%ebp),%eax
  801386:	01 d0                	add    %edx,%eax
  801388:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80138b:	83 c2 30             	add    $0x30,%edx
  80138e:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  801390:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801393:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801398:	f7 e9                	imul   %ecx
  80139a:	c1 fa 02             	sar    $0x2,%edx
  80139d:	89 c8                	mov    %ecx,%eax
  80139f:	c1 f8 1f             	sar    $0x1f,%eax
  8013a2:	29 c2                	sub    %eax,%edx
  8013a4:	89 d0                	mov    %edx,%eax
  8013a6:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  8013a9:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8013ad:	75 bb                	jne    80136a <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  8013af:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  8013b6:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8013b9:	48                   	dec    %eax
  8013ba:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  8013bd:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8013c1:	74 3d                	je     801400 <ltostr+0xc3>
		start = 1 ;
  8013c3:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  8013ca:	eb 34                	jmp    801400 <ltostr+0xc3>
	{
		char tmp = str[start] ;
  8013cc:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8013cf:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013d2:	01 d0                	add    %edx,%eax
  8013d4:	8a 00                	mov    (%eax),%al
  8013d6:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  8013d9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8013dc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013df:	01 c2                	add    %eax,%edx
  8013e1:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  8013e4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013e7:	01 c8                	add    %ecx,%eax
  8013e9:	8a 00                	mov    (%eax),%al
  8013eb:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  8013ed:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8013f0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013f3:	01 c2                	add    %eax,%edx
  8013f5:	8a 45 eb             	mov    -0x15(%ebp),%al
  8013f8:	88 02                	mov    %al,(%edx)
		start++ ;
  8013fa:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  8013fd:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801400:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801403:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801406:	7c c4                	jl     8013cc <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801408:	8b 55 f8             	mov    -0x8(%ebp),%edx
  80140b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80140e:	01 d0                	add    %edx,%eax
  801410:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801413:	90                   	nop
  801414:	c9                   	leave  
  801415:	c3                   	ret    

00801416 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  801416:	55                   	push   %ebp
  801417:	89 e5                	mov    %esp,%ebp
  801419:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  80141c:	ff 75 08             	pushl  0x8(%ebp)
  80141f:	e8 c4 f9 ff ff       	call   800de8 <strlen>
  801424:	83 c4 04             	add    $0x4,%esp
  801427:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  80142a:	ff 75 0c             	pushl  0xc(%ebp)
  80142d:	e8 b6 f9 ff ff       	call   800de8 <strlen>
  801432:	83 c4 04             	add    $0x4,%esp
  801435:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  801438:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  80143f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801446:	eb 17                	jmp    80145f <strcconcat+0x49>
		final[s] = str1[s] ;
  801448:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80144b:	8b 45 10             	mov    0x10(%ebp),%eax
  80144e:	01 c2                	add    %eax,%edx
  801450:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801453:	8b 45 08             	mov    0x8(%ebp),%eax
  801456:	01 c8                	add    %ecx,%eax
  801458:	8a 00                	mov    (%eax),%al
  80145a:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  80145c:	ff 45 fc             	incl   -0x4(%ebp)
  80145f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801462:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801465:	7c e1                	jl     801448 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  801467:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  80146e:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  801475:	eb 1f                	jmp    801496 <strcconcat+0x80>
		final[s++] = str2[i] ;
  801477:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80147a:	8d 50 01             	lea    0x1(%eax),%edx
  80147d:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801480:	89 c2                	mov    %eax,%edx
  801482:	8b 45 10             	mov    0x10(%ebp),%eax
  801485:	01 c2                	add    %eax,%edx
  801487:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  80148a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80148d:	01 c8                	add    %ecx,%eax
  80148f:	8a 00                	mov    (%eax),%al
  801491:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801493:	ff 45 f8             	incl   -0x8(%ebp)
  801496:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801499:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80149c:	7c d9                	jl     801477 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  80149e:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8014a1:	8b 45 10             	mov    0x10(%ebp),%eax
  8014a4:	01 d0                	add    %edx,%eax
  8014a6:	c6 00 00             	movb   $0x0,(%eax)
}
  8014a9:	90                   	nop
  8014aa:	c9                   	leave  
  8014ab:	c3                   	ret    

008014ac <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  8014ac:	55                   	push   %ebp
  8014ad:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  8014af:	8b 45 14             	mov    0x14(%ebp),%eax
  8014b2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  8014b8:	8b 45 14             	mov    0x14(%ebp),%eax
  8014bb:	8b 00                	mov    (%eax),%eax
  8014bd:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8014c4:	8b 45 10             	mov    0x10(%ebp),%eax
  8014c7:	01 d0                	add    %edx,%eax
  8014c9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8014cf:	eb 0c                	jmp    8014dd <strsplit+0x31>
			*string++ = 0;
  8014d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8014d4:	8d 50 01             	lea    0x1(%eax),%edx
  8014d7:	89 55 08             	mov    %edx,0x8(%ebp)
  8014da:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8014dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8014e0:	8a 00                	mov    (%eax),%al
  8014e2:	84 c0                	test   %al,%al
  8014e4:	74 18                	je     8014fe <strsplit+0x52>
  8014e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8014e9:	8a 00                	mov    (%eax),%al
  8014eb:	0f be c0             	movsbl %al,%eax
  8014ee:	50                   	push   %eax
  8014ef:	ff 75 0c             	pushl  0xc(%ebp)
  8014f2:	e8 83 fa ff ff       	call   800f7a <strchr>
  8014f7:	83 c4 08             	add    $0x8,%esp
  8014fa:	85 c0                	test   %eax,%eax
  8014fc:	75 d3                	jne    8014d1 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  8014fe:	8b 45 08             	mov    0x8(%ebp),%eax
  801501:	8a 00                	mov    (%eax),%al
  801503:	84 c0                	test   %al,%al
  801505:	74 5a                	je     801561 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801507:	8b 45 14             	mov    0x14(%ebp),%eax
  80150a:	8b 00                	mov    (%eax),%eax
  80150c:	83 f8 0f             	cmp    $0xf,%eax
  80150f:	75 07                	jne    801518 <strsplit+0x6c>
		{
			return 0;
  801511:	b8 00 00 00 00       	mov    $0x0,%eax
  801516:	eb 66                	jmp    80157e <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801518:	8b 45 14             	mov    0x14(%ebp),%eax
  80151b:	8b 00                	mov    (%eax),%eax
  80151d:	8d 48 01             	lea    0x1(%eax),%ecx
  801520:	8b 55 14             	mov    0x14(%ebp),%edx
  801523:	89 0a                	mov    %ecx,(%edx)
  801525:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80152c:	8b 45 10             	mov    0x10(%ebp),%eax
  80152f:	01 c2                	add    %eax,%edx
  801531:	8b 45 08             	mov    0x8(%ebp),%eax
  801534:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801536:	eb 03                	jmp    80153b <strsplit+0x8f>
			string++;
  801538:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  80153b:	8b 45 08             	mov    0x8(%ebp),%eax
  80153e:	8a 00                	mov    (%eax),%al
  801540:	84 c0                	test   %al,%al
  801542:	74 8b                	je     8014cf <strsplit+0x23>
  801544:	8b 45 08             	mov    0x8(%ebp),%eax
  801547:	8a 00                	mov    (%eax),%al
  801549:	0f be c0             	movsbl %al,%eax
  80154c:	50                   	push   %eax
  80154d:	ff 75 0c             	pushl  0xc(%ebp)
  801550:	e8 25 fa ff ff       	call   800f7a <strchr>
  801555:	83 c4 08             	add    $0x8,%esp
  801558:	85 c0                	test   %eax,%eax
  80155a:	74 dc                	je     801538 <strsplit+0x8c>
			string++;
	}
  80155c:	e9 6e ff ff ff       	jmp    8014cf <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801561:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801562:	8b 45 14             	mov    0x14(%ebp),%eax
  801565:	8b 00                	mov    (%eax),%eax
  801567:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80156e:	8b 45 10             	mov    0x10(%ebp),%eax
  801571:	01 d0                	add    %edx,%eax
  801573:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801579:	b8 01 00 00 00       	mov    $0x1,%eax
}
  80157e:	c9                   	leave  
  80157f:	c3                   	ret    

00801580 <str2lower>:


char* str2lower(char *dst, const char *src)
{
  801580:	55                   	push   %ebp
  801581:	89 e5                	mov    %esp,%ebp
  801583:	83 ec 10             	sub    $0x10,%esp
	char* ret = dst;
  801586:	8b 45 08             	mov    0x8(%ebp),%eax
  801589:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (int i = 0; i < strlen(src); ++i)
  80158c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801593:	eb 4a                	jmp    8015df <str2lower+0x5f>
	{
		dst[i] = src[i] ;
  801595:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801598:	8b 45 08             	mov    0x8(%ebp),%eax
  80159b:	01 c2                	add    %eax,%edx
  80159d:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8015a0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015a3:	01 c8                	add    %ecx,%eax
  8015a5:	8a 00                	mov    (%eax),%al
  8015a7:	88 02                	mov    %al,(%edx)
		if (src[i] >= 'A' && src[i] <= 'Z')
  8015a9:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8015ac:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015af:	01 d0                	add    %edx,%eax
  8015b1:	8a 00                	mov    (%eax),%al
  8015b3:	3c 40                	cmp    $0x40,%al
  8015b5:	7e 25                	jle    8015dc <str2lower+0x5c>
  8015b7:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8015ba:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015bd:	01 d0                	add    %edx,%eax
  8015bf:	8a 00                	mov    (%eax),%al
  8015c1:	3c 5a                	cmp    $0x5a,%al
  8015c3:	7f 17                	jg     8015dc <str2lower+0x5c>
		{
			dst[i] += 32 ;
  8015c5:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8015c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8015cb:	01 d0                	add    %edx,%eax
  8015cd:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8015d0:	8b 55 08             	mov    0x8(%ebp),%edx
  8015d3:	01 ca                	add    %ecx,%edx
  8015d5:	8a 12                	mov    (%edx),%dl
  8015d7:	83 c2 20             	add    $0x20,%edx
  8015da:	88 10                	mov    %dl,(%eax)


char* str2lower(char *dst, const char *src)
{
	char* ret = dst;
	for (int i = 0; i < strlen(src); ++i)
  8015dc:	ff 45 fc             	incl   -0x4(%ebp)
  8015df:	ff 75 0c             	pushl  0xc(%ebp)
  8015e2:	e8 01 f8 ff ff       	call   800de8 <strlen>
  8015e7:	83 c4 04             	add    $0x4,%esp
  8015ea:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  8015ed:	7f a6                	jg     801595 <str2lower+0x15>
		if (src[i] >= 'A' && src[i] <= 'Z')
		{
			dst[i] += 32 ;
		}
	}
	return ret;
  8015ef:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8015f2:	c9                   	leave  
  8015f3:	c3                   	ret    

008015f4 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  8015f4:	55                   	push   %ebp
  8015f5:	89 e5                	mov    %esp,%ebp
  8015f7:	57                   	push   %edi
  8015f8:	56                   	push   %esi
  8015f9:	53                   	push   %ebx
  8015fa:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8015fd:	8b 45 08             	mov    0x8(%ebp),%eax
  801600:	8b 55 0c             	mov    0xc(%ebp),%edx
  801603:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801606:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801609:	8b 7d 18             	mov    0x18(%ebp),%edi
  80160c:	8b 75 1c             	mov    0x1c(%ebp),%esi
  80160f:	cd 30                	int    $0x30
  801611:	89 45 f0             	mov    %eax,-0x10(%ebp)
				"b" (a3),
				"D" (a4),
				"S" (a5)
				: "cc", "memory");

	return ret;
  801614:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801617:	83 c4 10             	add    $0x10,%esp
  80161a:	5b                   	pop    %ebx
  80161b:	5e                   	pop    %esi
  80161c:	5f                   	pop    %edi
  80161d:	5d                   	pop    %ebp
  80161e:	c3                   	ret    

0080161f <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName, int color)
{
  80161f:	55                   	push   %ebp
  801620:	89 e5                	mov    %esp,%ebp
  801622:	83 ec 04             	sub    $0x4,%esp
  801625:	8b 45 10             	mov    0x10(%ebp),%eax
  801628:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, color, 0);
  80162b:	8b 4d 14             	mov    0x14(%ebp),%ecx
  80162e:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801632:	8b 45 08             	mov    0x8(%ebp),%eax
  801635:	6a 00                	push   $0x0
  801637:	51                   	push   %ecx
  801638:	52                   	push   %edx
  801639:	ff 75 0c             	pushl  0xc(%ebp)
  80163c:	50                   	push   %eax
  80163d:	6a 00                	push   $0x0
  80163f:	e8 b0 ff ff ff       	call   8015f4 <syscall>
  801644:	83 c4 18             	add    $0x18,%esp
}
  801647:	90                   	nop
  801648:	c9                   	leave  
  801649:	c3                   	ret    

0080164a <sys_cgetc>:

int
sys_cgetc(void)
{
  80164a:	55                   	push   %ebp
  80164b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  80164d:	6a 00                	push   $0x0
  80164f:	6a 00                	push   $0x0
  801651:	6a 00                	push   $0x0
  801653:	6a 00                	push   $0x0
  801655:	6a 00                	push   $0x0
  801657:	6a 02                	push   $0x2
  801659:	e8 96 ff ff ff       	call   8015f4 <syscall>
  80165e:	83 c4 18             	add    $0x18,%esp
}
  801661:	c9                   	leave  
  801662:	c3                   	ret    

00801663 <sys_lock_cons>:

void sys_lock_cons(void)
{
  801663:	55                   	push   %ebp
  801664:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  801666:	6a 00                	push   $0x0
  801668:	6a 00                	push   $0x0
  80166a:	6a 00                	push   $0x0
  80166c:	6a 00                	push   $0x0
  80166e:	6a 00                	push   $0x0
  801670:	6a 03                	push   $0x3
  801672:	e8 7d ff ff ff       	call   8015f4 <syscall>
  801677:	83 c4 18             	add    $0x18,%esp
}
  80167a:	90                   	nop
  80167b:	c9                   	leave  
  80167c:	c3                   	ret    

0080167d <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  80167d:	55                   	push   %ebp
  80167e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  801680:	6a 00                	push   $0x0
  801682:	6a 00                	push   $0x0
  801684:	6a 00                	push   $0x0
  801686:	6a 00                	push   $0x0
  801688:	6a 00                	push   $0x0
  80168a:	6a 04                	push   $0x4
  80168c:	e8 63 ff ff ff       	call   8015f4 <syscall>
  801691:	83 c4 18             	add    $0x18,%esp
}
  801694:	90                   	nop
  801695:	c9                   	leave  
  801696:	c3                   	ret    

00801697 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801697:	55                   	push   %ebp
  801698:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  80169a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80169d:	8b 45 08             	mov    0x8(%ebp),%eax
  8016a0:	6a 00                	push   $0x0
  8016a2:	6a 00                	push   $0x0
  8016a4:	6a 00                	push   $0x0
  8016a6:	52                   	push   %edx
  8016a7:	50                   	push   %eax
  8016a8:	6a 08                	push   $0x8
  8016aa:	e8 45 ff ff ff       	call   8015f4 <syscall>
  8016af:	83 c4 18             	add    $0x18,%esp
}
  8016b2:	c9                   	leave  
  8016b3:	c3                   	ret    

008016b4 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  8016b4:	55                   	push   %ebp
  8016b5:	89 e5                	mov    %esp,%ebp
  8016b7:	56                   	push   %esi
  8016b8:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  8016b9:	8b 75 18             	mov    0x18(%ebp),%esi
  8016bc:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8016bf:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8016c2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8016c8:	56                   	push   %esi
  8016c9:	53                   	push   %ebx
  8016ca:	51                   	push   %ecx
  8016cb:	52                   	push   %edx
  8016cc:	50                   	push   %eax
  8016cd:	6a 09                	push   $0x9
  8016cf:	e8 20 ff ff ff       	call   8015f4 <syscall>
  8016d4:	83 c4 18             	add    $0x18,%esp
}
  8016d7:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8016da:	5b                   	pop    %ebx
  8016db:	5e                   	pop    %esi
  8016dc:	5d                   	pop    %ebp
  8016dd:	c3                   	ret    

008016de <__sys_unmap_frame>:

int __sys_unmap_frame(uint32 va)
{
  8016de:	55                   	push   %ebp
  8016df:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, va, 0, 0, 0, 0);
  8016e1:	6a 00                	push   $0x0
  8016e3:	6a 00                	push   $0x0
  8016e5:	6a 00                	push   $0x0
  8016e7:	6a 00                	push   $0x0
  8016e9:	ff 75 08             	pushl  0x8(%ebp)
  8016ec:	6a 0a                	push   $0xa
  8016ee:	e8 01 ff ff ff       	call   8015f4 <syscall>
  8016f3:	83 c4 18             	add    $0x18,%esp
}
  8016f6:	c9                   	leave  
  8016f7:	c3                   	ret    

008016f8 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  8016f8:	55                   	push   %ebp
  8016f9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  8016fb:	6a 00                	push   $0x0
  8016fd:	6a 00                	push   $0x0
  8016ff:	6a 00                	push   $0x0
  801701:	ff 75 0c             	pushl  0xc(%ebp)
  801704:	ff 75 08             	pushl  0x8(%ebp)
  801707:	6a 0b                	push   $0xb
  801709:	e8 e6 fe ff ff       	call   8015f4 <syscall>
  80170e:	83 c4 18             	add    $0x18,%esp
}
  801711:	c9                   	leave  
  801712:	c3                   	ret    

00801713 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801713:	55                   	push   %ebp
  801714:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801716:	6a 00                	push   $0x0
  801718:	6a 00                	push   $0x0
  80171a:	6a 00                	push   $0x0
  80171c:	6a 00                	push   $0x0
  80171e:	6a 00                	push   $0x0
  801720:	6a 0c                	push   $0xc
  801722:	e8 cd fe ff ff       	call   8015f4 <syscall>
  801727:	83 c4 18             	add    $0x18,%esp
}
  80172a:	c9                   	leave  
  80172b:	c3                   	ret    

0080172c <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  80172c:	55                   	push   %ebp
  80172d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  80172f:	6a 00                	push   $0x0
  801731:	6a 00                	push   $0x0
  801733:	6a 00                	push   $0x0
  801735:	6a 00                	push   $0x0
  801737:	6a 00                	push   $0x0
  801739:	6a 0d                	push   $0xd
  80173b:	e8 b4 fe ff ff       	call   8015f4 <syscall>
  801740:	83 c4 18             	add    $0x18,%esp
}
  801743:	c9                   	leave  
  801744:	c3                   	ret    

00801745 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801745:	55                   	push   %ebp
  801746:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801748:	6a 00                	push   $0x0
  80174a:	6a 00                	push   $0x0
  80174c:	6a 00                	push   $0x0
  80174e:	6a 00                	push   $0x0
  801750:	6a 00                	push   $0x0
  801752:	6a 0e                	push   $0xe
  801754:	e8 9b fe ff ff       	call   8015f4 <syscall>
  801759:	83 c4 18             	add    $0x18,%esp
}
  80175c:	c9                   	leave  
  80175d:	c3                   	ret    

0080175e <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  80175e:	55                   	push   %ebp
  80175f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801761:	6a 00                	push   $0x0
  801763:	6a 00                	push   $0x0
  801765:	6a 00                	push   $0x0
  801767:	6a 00                	push   $0x0
  801769:	6a 00                	push   $0x0
  80176b:	6a 0f                	push   $0xf
  80176d:	e8 82 fe ff ff       	call   8015f4 <syscall>
  801772:	83 c4 18             	add    $0x18,%esp
}
  801775:	c9                   	leave  
  801776:	c3                   	ret    

00801777 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801777:	55                   	push   %ebp
  801778:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  80177a:	6a 00                	push   $0x0
  80177c:	6a 00                	push   $0x0
  80177e:	6a 00                	push   $0x0
  801780:	6a 00                	push   $0x0
  801782:	ff 75 08             	pushl  0x8(%ebp)
  801785:	6a 10                	push   $0x10
  801787:	e8 68 fe ff ff       	call   8015f4 <syscall>
  80178c:	83 c4 18             	add    $0x18,%esp
}
  80178f:	c9                   	leave  
  801790:	c3                   	ret    

00801791 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801791:	55                   	push   %ebp
  801792:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801794:	6a 00                	push   $0x0
  801796:	6a 00                	push   $0x0
  801798:	6a 00                	push   $0x0
  80179a:	6a 00                	push   $0x0
  80179c:	6a 00                	push   $0x0
  80179e:	6a 11                	push   $0x11
  8017a0:	e8 4f fe ff ff       	call   8015f4 <syscall>
  8017a5:	83 c4 18             	add    $0x18,%esp
}
  8017a8:	90                   	nop
  8017a9:	c9                   	leave  
  8017aa:	c3                   	ret    

008017ab <sys_cputc>:

void
sys_cputc(const char c)
{
  8017ab:	55                   	push   %ebp
  8017ac:	89 e5                	mov    %esp,%ebp
  8017ae:	83 ec 04             	sub    $0x4,%esp
  8017b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8017b4:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  8017b7:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8017bb:	6a 00                	push   $0x0
  8017bd:	6a 00                	push   $0x0
  8017bf:	6a 00                	push   $0x0
  8017c1:	6a 00                	push   $0x0
  8017c3:	50                   	push   %eax
  8017c4:	6a 01                	push   $0x1
  8017c6:	e8 29 fe ff ff       	call   8015f4 <syscall>
  8017cb:	83 c4 18             	add    $0x18,%esp
}
  8017ce:	90                   	nop
  8017cf:	c9                   	leave  
  8017d0:	c3                   	ret    

008017d1 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  8017d1:	55                   	push   %ebp
  8017d2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  8017d4:	6a 00                	push   $0x0
  8017d6:	6a 00                	push   $0x0
  8017d8:	6a 00                	push   $0x0
  8017da:	6a 00                	push   $0x0
  8017dc:	6a 00                	push   $0x0
  8017de:	6a 14                	push   $0x14
  8017e0:	e8 0f fe ff ff       	call   8015f4 <syscall>
  8017e5:	83 c4 18             	add    $0x18,%esp
}
  8017e8:	90                   	nop
  8017e9:	c9                   	leave  
  8017ea:	c3                   	ret    

008017eb <sys_create_shared_object>:

int sys_create_shared_object(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  8017eb:	55                   	push   %ebp
  8017ec:	89 e5                	mov    %esp,%ebp
  8017ee:	83 ec 04             	sub    $0x4,%esp
  8017f1:	8b 45 10             	mov    0x10(%ebp),%eax
  8017f4:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  8017f7:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8017fa:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8017fe:	8b 45 08             	mov    0x8(%ebp),%eax
  801801:	6a 00                	push   $0x0
  801803:	51                   	push   %ecx
  801804:	52                   	push   %edx
  801805:	ff 75 0c             	pushl  0xc(%ebp)
  801808:	50                   	push   %eax
  801809:	6a 15                	push   $0x15
  80180b:	e8 e4 fd ff ff       	call   8015f4 <syscall>
  801810:	83 c4 18             	add    $0x18,%esp
}
  801813:	c9                   	leave  
  801814:	c3                   	ret    

00801815 <sys_size_of_shared_object>:

//2017:
int sys_size_of_shared_object(int32 ownerID, char* shareName)
{
  801815:	55                   	push   %ebp
  801816:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801818:	8b 55 0c             	mov    0xc(%ebp),%edx
  80181b:	8b 45 08             	mov    0x8(%ebp),%eax
  80181e:	6a 00                	push   $0x0
  801820:	6a 00                	push   $0x0
  801822:	6a 00                	push   $0x0
  801824:	52                   	push   %edx
  801825:	50                   	push   %eax
  801826:	6a 16                	push   $0x16
  801828:	e8 c7 fd ff ff       	call   8015f4 <syscall>
  80182d:	83 c4 18             	add    $0x18,%esp
}
  801830:	c9                   	leave  
  801831:	c3                   	ret    

00801832 <sys_get_shared_object>:
//==========

int sys_get_shared_object(int32 ownerID, char* shareName, void* virtual_address)
{
  801832:	55                   	push   %ebp
  801833:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801835:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801838:	8b 55 0c             	mov    0xc(%ebp),%edx
  80183b:	8b 45 08             	mov    0x8(%ebp),%eax
  80183e:	6a 00                	push   $0x0
  801840:	6a 00                	push   $0x0
  801842:	51                   	push   %ecx
  801843:	52                   	push   %edx
  801844:	50                   	push   %eax
  801845:	6a 17                	push   $0x17
  801847:	e8 a8 fd ff ff       	call   8015f4 <syscall>
  80184c:	83 c4 18             	add    $0x18,%esp
}
  80184f:	c9                   	leave  
  801850:	c3                   	ret    

00801851 <sys_delete_shared_object>:

int sys_delete_shared_object(int32 sharedObjectID, void *startVA)
{
  801851:	55                   	push   %ebp
  801852:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801854:	8b 55 0c             	mov    0xc(%ebp),%edx
  801857:	8b 45 08             	mov    0x8(%ebp),%eax
  80185a:	6a 00                	push   $0x0
  80185c:	6a 00                	push   $0x0
  80185e:	6a 00                	push   $0x0
  801860:	52                   	push   %edx
  801861:	50                   	push   %eax
  801862:	6a 18                	push   $0x18
  801864:	e8 8b fd ff ff       	call   8015f4 <syscall>
  801869:	83 c4 18             	add    $0x18,%esp
}
  80186c:	c9                   	leave  
  80186d:	c3                   	ret    

0080186e <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  80186e:	55                   	push   %ebp
  80186f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801871:	8b 45 08             	mov    0x8(%ebp),%eax
  801874:	6a 00                	push   $0x0
  801876:	ff 75 14             	pushl  0x14(%ebp)
  801879:	ff 75 10             	pushl  0x10(%ebp)
  80187c:	ff 75 0c             	pushl  0xc(%ebp)
  80187f:	50                   	push   %eax
  801880:	6a 19                	push   $0x19
  801882:	e8 6d fd ff ff       	call   8015f4 <syscall>
  801887:	83 c4 18             	add    $0x18,%esp
}
  80188a:	c9                   	leave  
  80188b:	c3                   	ret    

0080188c <sys_run_env>:

void sys_run_env(int32 envId)
{
  80188c:	55                   	push   %ebp
  80188d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  80188f:	8b 45 08             	mov    0x8(%ebp),%eax
  801892:	6a 00                	push   $0x0
  801894:	6a 00                	push   $0x0
  801896:	6a 00                	push   $0x0
  801898:	6a 00                	push   $0x0
  80189a:	50                   	push   %eax
  80189b:	6a 1a                	push   $0x1a
  80189d:	e8 52 fd ff ff       	call   8015f4 <syscall>
  8018a2:	83 c4 18             	add    $0x18,%esp
}
  8018a5:	90                   	nop
  8018a6:	c9                   	leave  
  8018a7:	c3                   	ret    

008018a8 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  8018a8:	55                   	push   %ebp
  8018a9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  8018ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8018ae:	6a 00                	push   $0x0
  8018b0:	6a 00                	push   $0x0
  8018b2:	6a 00                	push   $0x0
  8018b4:	6a 00                	push   $0x0
  8018b6:	50                   	push   %eax
  8018b7:	6a 1b                	push   $0x1b
  8018b9:	e8 36 fd ff ff       	call   8015f4 <syscall>
  8018be:	83 c4 18             	add    $0x18,%esp
}
  8018c1:	c9                   	leave  
  8018c2:	c3                   	ret    

008018c3 <sys_getenvid>:

int32 sys_getenvid(void)
{
  8018c3:	55                   	push   %ebp
  8018c4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  8018c6:	6a 00                	push   $0x0
  8018c8:	6a 00                	push   $0x0
  8018ca:	6a 00                	push   $0x0
  8018cc:	6a 00                	push   $0x0
  8018ce:	6a 00                	push   $0x0
  8018d0:	6a 05                	push   $0x5
  8018d2:	e8 1d fd ff ff       	call   8015f4 <syscall>
  8018d7:	83 c4 18             	add    $0x18,%esp
}
  8018da:	c9                   	leave  
  8018db:	c3                   	ret    

008018dc <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  8018dc:	55                   	push   %ebp
  8018dd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  8018df:	6a 00                	push   $0x0
  8018e1:	6a 00                	push   $0x0
  8018e3:	6a 00                	push   $0x0
  8018e5:	6a 00                	push   $0x0
  8018e7:	6a 00                	push   $0x0
  8018e9:	6a 06                	push   $0x6
  8018eb:	e8 04 fd ff ff       	call   8015f4 <syscall>
  8018f0:	83 c4 18             	add    $0x18,%esp
}
  8018f3:	c9                   	leave  
  8018f4:	c3                   	ret    

008018f5 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  8018f5:	55                   	push   %ebp
  8018f6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  8018f8:	6a 00                	push   $0x0
  8018fa:	6a 00                	push   $0x0
  8018fc:	6a 00                	push   $0x0
  8018fe:	6a 00                	push   $0x0
  801900:	6a 00                	push   $0x0
  801902:	6a 07                	push   $0x7
  801904:	e8 eb fc ff ff       	call   8015f4 <syscall>
  801909:	83 c4 18             	add    $0x18,%esp
}
  80190c:	c9                   	leave  
  80190d:	c3                   	ret    

0080190e <sys_exit_env>:


void sys_exit_env(void)
{
  80190e:	55                   	push   %ebp
  80190f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801911:	6a 00                	push   $0x0
  801913:	6a 00                	push   $0x0
  801915:	6a 00                	push   $0x0
  801917:	6a 00                	push   $0x0
  801919:	6a 00                	push   $0x0
  80191b:	6a 1c                	push   $0x1c
  80191d:	e8 d2 fc ff ff       	call   8015f4 <syscall>
  801922:	83 c4 18             	add    $0x18,%esp
}
  801925:	90                   	nop
  801926:	c9                   	leave  
  801927:	c3                   	ret    

00801928 <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  801928:	55                   	push   %ebp
  801929:	89 e5                	mov    %esp,%ebp
  80192b:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  80192e:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801931:	8d 50 04             	lea    0x4(%eax),%edx
  801934:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801937:	6a 00                	push   $0x0
  801939:	6a 00                	push   $0x0
  80193b:	6a 00                	push   $0x0
  80193d:	52                   	push   %edx
  80193e:	50                   	push   %eax
  80193f:	6a 1d                	push   $0x1d
  801941:	e8 ae fc ff ff       	call   8015f4 <syscall>
  801946:	83 c4 18             	add    $0x18,%esp
	return result;
  801949:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80194c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80194f:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801952:	89 01                	mov    %eax,(%ecx)
  801954:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801957:	8b 45 08             	mov    0x8(%ebp),%eax
  80195a:	c9                   	leave  
  80195b:	c2 04 00             	ret    $0x4

0080195e <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  80195e:	55                   	push   %ebp
  80195f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801961:	6a 00                	push   $0x0
  801963:	6a 00                	push   $0x0
  801965:	ff 75 10             	pushl  0x10(%ebp)
  801968:	ff 75 0c             	pushl  0xc(%ebp)
  80196b:	ff 75 08             	pushl  0x8(%ebp)
  80196e:	6a 13                	push   $0x13
  801970:	e8 7f fc ff ff       	call   8015f4 <syscall>
  801975:	83 c4 18             	add    $0x18,%esp
	return ;
  801978:	90                   	nop
}
  801979:	c9                   	leave  
  80197a:	c3                   	ret    

0080197b <sys_rcr2>:
uint32 sys_rcr2()
{
  80197b:	55                   	push   %ebp
  80197c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  80197e:	6a 00                	push   $0x0
  801980:	6a 00                	push   $0x0
  801982:	6a 00                	push   $0x0
  801984:	6a 00                	push   $0x0
  801986:	6a 00                	push   $0x0
  801988:	6a 1e                	push   $0x1e
  80198a:	e8 65 fc ff ff       	call   8015f4 <syscall>
  80198f:	83 c4 18             	add    $0x18,%esp
}
  801992:	c9                   	leave  
  801993:	c3                   	ret    

00801994 <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  801994:	55                   	push   %ebp
  801995:	89 e5                	mov    %esp,%ebp
  801997:	83 ec 04             	sub    $0x4,%esp
  80199a:	8b 45 08             	mov    0x8(%ebp),%eax
  80199d:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  8019a0:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  8019a4:	6a 00                	push   $0x0
  8019a6:	6a 00                	push   $0x0
  8019a8:	6a 00                	push   $0x0
  8019aa:	6a 00                	push   $0x0
  8019ac:	50                   	push   %eax
  8019ad:	6a 1f                	push   $0x1f
  8019af:	e8 40 fc ff ff       	call   8015f4 <syscall>
  8019b4:	83 c4 18             	add    $0x18,%esp
	return ;
  8019b7:	90                   	nop
}
  8019b8:	c9                   	leave  
  8019b9:	c3                   	ret    

008019ba <rsttst>:
void rsttst()
{
  8019ba:	55                   	push   %ebp
  8019bb:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  8019bd:	6a 00                	push   $0x0
  8019bf:	6a 00                	push   $0x0
  8019c1:	6a 00                	push   $0x0
  8019c3:	6a 00                	push   $0x0
  8019c5:	6a 00                	push   $0x0
  8019c7:	6a 21                	push   $0x21
  8019c9:	e8 26 fc ff ff       	call   8015f4 <syscall>
  8019ce:	83 c4 18             	add    $0x18,%esp
	return ;
  8019d1:	90                   	nop
}
  8019d2:	c9                   	leave  
  8019d3:	c3                   	ret    

008019d4 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  8019d4:	55                   	push   %ebp
  8019d5:	89 e5                	mov    %esp,%ebp
  8019d7:	83 ec 04             	sub    $0x4,%esp
  8019da:	8b 45 14             	mov    0x14(%ebp),%eax
  8019dd:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  8019e0:	8b 55 18             	mov    0x18(%ebp),%edx
  8019e3:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8019e7:	52                   	push   %edx
  8019e8:	50                   	push   %eax
  8019e9:	ff 75 10             	pushl  0x10(%ebp)
  8019ec:	ff 75 0c             	pushl  0xc(%ebp)
  8019ef:	ff 75 08             	pushl  0x8(%ebp)
  8019f2:	6a 20                	push   $0x20
  8019f4:	e8 fb fb ff ff       	call   8015f4 <syscall>
  8019f9:	83 c4 18             	add    $0x18,%esp
	return ;
  8019fc:	90                   	nop
}
  8019fd:	c9                   	leave  
  8019fe:	c3                   	ret    

008019ff <chktst>:
void chktst(uint32 n)
{
  8019ff:	55                   	push   %ebp
  801a00:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801a02:	6a 00                	push   $0x0
  801a04:	6a 00                	push   $0x0
  801a06:	6a 00                	push   $0x0
  801a08:	6a 00                	push   $0x0
  801a0a:	ff 75 08             	pushl  0x8(%ebp)
  801a0d:	6a 22                	push   $0x22
  801a0f:	e8 e0 fb ff ff       	call   8015f4 <syscall>
  801a14:	83 c4 18             	add    $0x18,%esp
	return ;
  801a17:	90                   	nop
}
  801a18:	c9                   	leave  
  801a19:	c3                   	ret    

00801a1a <inctst>:

void inctst()
{
  801a1a:	55                   	push   %ebp
  801a1b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801a1d:	6a 00                	push   $0x0
  801a1f:	6a 00                	push   $0x0
  801a21:	6a 00                	push   $0x0
  801a23:	6a 00                	push   $0x0
  801a25:	6a 00                	push   $0x0
  801a27:	6a 23                	push   $0x23
  801a29:	e8 c6 fb ff ff       	call   8015f4 <syscall>
  801a2e:	83 c4 18             	add    $0x18,%esp
	return ;
  801a31:	90                   	nop
}
  801a32:	c9                   	leave  
  801a33:	c3                   	ret    

00801a34 <gettst>:
uint32 gettst()
{
  801a34:	55                   	push   %ebp
  801a35:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801a37:	6a 00                	push   $0x0
  801a39:	6a 00                	push   $0x0
  801a3b:	6a 00                	push   $0x0
  801a3d:	6a 00                	push   $0x0
  801a3f:	6a 00                	push   $0x0
  801a41:	6a 24                	push   $0x24
  801a43:	e8 ac fb ff ff       	call   8015f4 <syscall>
  801a48:	83 c4 18             	add    $0x18,%esp
}
  801a4b:	c9                   	leave  
  801a4c:	c3                   	ret    

00801a4d <sys_get_uheap_strategy>:

/*2025*/
uint32 sys_get_uheap_strategy()
{
  801a4d:	55                   	push   %ebp
  801a4e:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801a50:	6a 00                	push   $0x0
  801a52:	6a 00                	push   $0x0
  801a54:	6a 00                	push   $0x0
  801a56:	6a 00                	push   $0x0
  801a58:	6a 00                	push   $0x0
  801a5a:	6a 25                	push   $0x25
  801a5c:	e8 93 fb ff ff       	call   8015f4 <syscall>
  801a61:	83 c4 18             	add    $0x18,%esp
  801a64:	a3 60 b0 81 00       	mov    %eax,0x81b060
	return uheapPlaceStrategy ;
  801a69:	a1 60 b0 81 00       	mov    0x81b060,%eax
}
  801a6e:	c9                   	leave  
  801a6f:	c3                   	ret    

00801a70 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801a70:	55                   	push   %ebp
  801a71:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = heapStrategy;
  801a73:	8b 45 08             	mov    0x8(%ebp),%eax
  801a76:	a3 60 b0 81 00       	mov    %eax,0x81b060
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801a7b:	6a 00                	push   $0x0
  801a7d:	6a 00                	push   $0x0
  801a7f:	6a 00                	push   $0x0
  801a81:	6a 00                	push   $0x0
  801a83:	ff 75 08             	pushl  0x8(%ebp)
  801a86:	6a 26                	push   $0x26
  801a88:	e8 67 fb ff ff       	call   8015f4 <syscall>
  801a8d:	83 c4 18             	add    $0x18,%esp
	return ;
  801a90:	90                   	nop
}
  801a91:	c9                   	leave  
  801a92:	c3                   	ret    

00801a93 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801a93:	55                   	push   %ebp
  801a94:	89 e5                	mov    %esp,%ebp
  801a96:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801a97:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801a9a:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801a9d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801aa0:	8b 45 08             	mov    0x8(%ebp),%eax
  801aa3:	6a 00                	push   $0x0
  801aa5:	53                   	push   %ebx
  801aa6:	51                   	push   %ecx
  801aa7:	52                   	push   %edx
  801aa8:	50                   	push   %eax
  801aa9:	6a 27                	push   $0x27
  801aab:	e8 44 fb ff ff       	call   8015f4 <syscall>
  801ab0:	83 c4 18             	add    $0x18,%esp
}
  801ab3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801ab6:	c9                   	leave  
  801ab7:	c3                   	ret    

00801ab8 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801ab8:	55                   	push   %ebp
  801ab9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801abb:	8b 55 0c             	mov    0xc(%ebp),%edx
  801abe:	8b 45 08             	mov    0x8(%ebp),%eax
  801ac1:	6a 00                	push   $0x0
  801ac3:	6a 00                	push   $0x0
  801ac5:	6a 00                	push   $0x0
  801ac7:	52                   	push   %edx
  801ac8:	50                   	push   %eax
  801ac9:	6a 28                	push   $0x28
  801acb:	e8 24 fb ff ff       	call   8015f4 <syscall>
  801ad0:	83 c4 18             	add    $0x18,%esp
}
  801ad3:	c9                   	leave  
  801ad4:	c3                   	ret    

00801ad5 <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  801ad5:	55                   	push   %ebp
  801ad6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  801ad8:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801adb:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ade:	8b 45 08             	mov    0x8(%ebp),%eax
  801ae1:	6a 00                	push   $0x0
  801ae3:	51                   	push   %ecx
  801ae4:	ff 75 10             	pushl  0x10(%ebp)
  801ae7:	52                   	push   %edx
  801ae8:	50                   	push   %eax
  801ae9:	6a 29                	push   $0x29
  801aeb:	e8 04 fb ff ff       	call   8015f4 <syscall>
  801af0:	83 c4 18             	add    $0x18,%esp
}
  801af3:	c9                   	leave  
  801af4:	c3                   	ret    

00801af5 <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801af5:	55                   	push   %ebp
  801af6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801af8:	6a 00                	push   $0x0
  801afa:	6a 00                	push   $0x0
  801afc:	ff 75 10             	pushl  0x10(%ebp)
  801aff:	ff 75 0c             	pushl  0xc(%ebp)
  801b02:	ff 75 08             	pushl  0x8(%ebp)
  801b05:	6a 12                	push   $0x12
  801b07:	e8 e8 fa ff ff       	call   8015f4 <syscall>
  801b0c:	83 c4 18             	add    $0x18,%esp
	return ;
  801b0f:	90                   	nop
}
  801b10:	c9                   	leave  
  801b11:	c3                   	ret    

00801b12 <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  801b12:	55                   	push   %ebp
  801b13:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  801b15:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b18:	8b 45 08             	mov    0x8(%ebp),%eax
  801b1b:	6a 00                	push   $0x0
  801b1d:	6a 00                	push   $0x0
  801b1f:	6a 00                	push   $0x0
  801b21:	52                   	push   %edx
  801b22:	50                   	push   %eax
  801b23:	6a 2a                	push   $0x2a
  801b25:	e8 ca fa ff ff       	call   8015f4 <syscall>
  801b2a:	83 c4 18             	add    $0x18,%esp
	return;
  801b2d:	90                   	nop
}
  801b2e:	c9                   	leave  
  801b2f:	c3                   	ret    

00801b30 <sys_get_optimal_num_faults>:
/*2025*/
int sys_get_optimal_num_faults()
{
  801b30:	55                   	push   %ebp
  801b31:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_optimal_num_faults, 0, 0, 0, 0, 0);
  801b33:	6a 00                	push   $0x0
  801b35:	6a 00                	push   $0x0
  801b37:	6a 00                	push   $0x0
  801b39:	6a 00                	push   $0x0
  801b3b:	6a 00                	push   $0x0
  801b3d:	6a 2b                	push   $0x2b
  801b3f:	e8 b0 fa ff ff       	call   8015f4 <syscall>
  801b44:	83 c4 18             	add    $0x18,%esp
}
  801b47:	c9                   	leave  
  801b48:	c3                   	ret    

00801b49 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801b49:	55                   	push   %ebp
  801b4a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801b4c:	6a 00                	push   $0x0
  801b4e:	6a 00                	push   $0x0
  801b50:	6a 00                	push   $0x0
  801b52:	ff 75 0c             	pushl  0xc(%ebp)
  801b55:	ff 75 08             	pushl  0x8(%ebp)
  801b58:	6a 2d                	push   $0x2d
  801b5a:	e8 95 fa ff ff       	call   8015f4 <syscall>
  801b5f:	83 c4 18             	add    $0x18,%esp
	return;
  801b62:	90                   	nop
}
  801b63:	c9                   	leave  
  801b64:	c3                   	ret    

00801b65 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801b65:	55                   	push   %ebp
  801b66:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801b68:	6a 00                	push   $0x0
  801b6a:	6a 00                	push   $0x0
  801b6c:	6a 00                	push   $0x0
  801b6e:	ff 75 0c             	pushl  0xc(%ebp)
  801b71:	ff 75 08             	pushl  0x8(%ebp)
  801b74:	6a 2c                	push   $0x2c
  801b76:	e8 79 fa ff ff       	call   8015f4 <syscall>
  801b7b:	83 c4 18             	add    $0x18,%esp
	return ;
  801b7e:	90                   	nop
}
  801b7f:	c9                   	leave  
  801b80:	c3                   	ret    

00801b81 <sys_env_set_priority>:


void sys_env_set_priority(int32 envID, int priority)
{
  801b81:	55                   	push   %ebp
  801b82:	89 e5                	mov    %esp,%ebp
  801b84:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.IM#4] CPU SCHEDULING - #1 System Calls - Add suitable code here
	//Your code is here
	//Comment the following line
	panic("sys_env_set_priority() is not implemented yet...!!");
  801b87:	83 ec 04             	sub    $0x4,%esp
  801b8a:	68 28 27 80 00       	push   $0x802728
  801b8f:	68 25 01 00 00       	push   $0x125
  801b94:	68 5b 27 80 00       	push   $0x80275b
  801b99:	e8 a3 e8 ff ff       	call   800441 <_panic>

00801b9e <env_sleep>:
#include <inc/lib.h>
#include <inc/timerreg.h>

void
env_sleep(uint32 approxMilliSeconds)
{
  801b9e:	55                   	push   %ebp
  801b9f:	89 e5                	mov    %esp,%ebp
  801ba1:	83 ec 30             	sub    $0x30,%esp
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
  801ba4:	8b 55 08             	mov    0x8(%ebp),%edx
  801ba7:	89 d0                	mov    %edx,%eax
  801ba9:	c1 e0 02             	shl    $0x2,%eax
  801bac:	01 d0                	add    %edx,%eax
  801bae:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801bb5:	01 d0                	add    %edx,%eax
  801bb7:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801bbe:	01 d0                	add    %edx,%eax
  801bc0:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801bc7:	01 d0                	add    %edx,%eax
  801bc9:	c1 e0 04             	shl    $0x4,%eax
  801bcc:	89 45 f8             	mov    %eax,-0x8(%ebp)
	uint32 cycles_counter =0;
  801bcf:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)

static inline __attribute__((always_inline)) struct uint64 get_virtual_time_user()
{
	struct uint64 result;

	__asm __volatile("rdtsc\n"
  801bd6:	0f 31                	rdtsc  
  801bd8:	89 45 e8             	mov    %eax,-0x18(%ebp)
  801bdb:	89 55 ec             	mov    %edx,-0x14(%ebp)
	: "=a" (result.low), "=d" (result.hi)
	);

	return result;
  801bde:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801be1:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801be4:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801be7:	89 55 f4             	mov    %edx,-0xc(%ebp)

	/*2024*/ //USE A USER-SIDE VERSION OF THIS FUNCTION TO AVOID SLOW-DOWN THE PERFORMANCE DUE SYS_CALL (el7 :))
	//struct uint64 baseTime = sys_get_virtual_time() ;
	struct uint64 baseTime = get_virtual_time_user() ;
	while(cycles_counter<time_in_cycles)
  801bea:	eb 46                	jmp    801c32 <env_sleep+0x94>

static inline __attribute__((always_inline)) struct uint64 get_virtual_time_user()
{
	struct uint64 result;

	__asm __volatile("rdtsc\n"
  801bec:	0f 31                	rdtsc  
  801bee:	89 45 d0             	mov    %eax,-0x30(%ebp)
  801bf1:	89 55 d4             	mov    %edx,-0x2c(%ebp)
	: "=a" (result.low), "=d" (result.hi)
	);

	return result;
  801bf4:	8b 45 d0             	mov    -0x30(%ebp),%eax
  801bf7:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  801bfa:	89 45 e0             	mov    %eax,-0x20(%ebp)
  801bfd:	89 55 e4             	mov    %edx,-0x1c(%ebp)

		// update the cycles_count
		#define M32 0xffffffff
		// subtract basetime from current time
		struct uint64 res;
		res.low = (currentTime.low - baseTime.low) & M32;
  801c00:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801c03:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801c06:	29 c2                	sub    %eax,%edx
  801c08:	89 d0                	mov    %edx,%eax
  801c0a:	89 45 d8             	mov    %eax,-0x28(%ebp)
		res.hi = (currentTime.hi - baseTime.hi - (res.low > currentTime.low)) & M32;
  801c0d:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801c10:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c13:	89 d1                	mov    %edx,%ecx
  801c15:	29 c1                	sub    %eax,%ecx
  801c17:	8b 55 d8             	mov    -0x28(%ebp),%edx
  801c1a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801c1d:	39 c2                	cmp    %eax,%edx
  801c1f:	0f 97 c0             	seta   %al
  801c22:	0f b6 c0             	movzbl %al,%eax
  801c25:	29 c1                	sub    %eax,%ecx
  801c27:	89 c8                	mov    %ecx,%eax
  801c29:	89 45 dc             	mov    %eax,-0x24(%ebp)

		//update cycles_count with result
		cycles_counter = res.low;
  801c2c:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801c2f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	uint32 cycles_counter =0;

	/*2024*/ //USE A USER-SIDE VERSION OF THIS FUNCTION TO AVOID SLOW-DOWN THE PERFORMANCE DUE SYS_CALL (el7 :))
	//struct uint64 baseTime = sys_get_virtual_time() ;
	struct uint64 baseTime = get_virtual_time_user() ;
	while(cycles_counter<time_in_cycles)
  801c32:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801c35:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801c38:	72 b2                	jb     801bec <env_sleep+0x4e>
//				,cycles_counter
//				);
	}
	//cprintf("%s [%d] wake up now!\n", myEnv->prog_name, myEnv->env_id);

}
  801c3a:	90                   	nop
  801c3b:	c9                   	leave  
  801c3c:	c3                   	ret    

00801c3d <busy_wait>:

//2017
uint32 busy_wait(uint32 loopMax)
{
  801c3d:	55                   	push   %ebp
  801c3e:	89 e5                	mov    %esp,%ebp
  801c40:	83 ec 10             	sub    $0x10,%esp
	uint32 i = 0 ;
  801c43:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	while (i < loopMax) i++;
  801c4a:	eb 03                	jmp    801c4f <busy_wait+0x12>
  801c4c:	ff 45 fc             	incl   -0x4(%ebp)
  801c4f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801c52:	3b 45 08             	cmp    0x8(%ebp),%eax
  801c55:	72 f5                	jb     801c4c <busy_wait+0xf>
	return i;
  801c57:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801c5a:	c9                   	leave  
  801c5b:	c3                   	ret    

00801c5c <__udivdi3>:
  801c5c:	55                   	push   %ebp
  801c5d:	57                   	push   %edi
  801c5e:	56                   	push   %esi
  801c5f:	53                   	push   %ebx
  801c60:	83 ec 1c             	sub    $0x1c,%esp
  801c63:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  801c67:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  801c6b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801c6f:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801c73:	89 ca                	mov    %ecx,%edx
  801c75:	89 f8                	mov    %edi,%eax
  801c77:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  801c7b:	85 f6                	test   %esi,%esi
  801c7d:	75 2d                	jne    801cac <__udivdi3+0x50>
  801c7f:	39 cf                	cmp    %ecx,%edi
  801c81:	77 65                	ja     801ce8 <__udivdi3+0x8c>
  801c83:	89 fd                	mov    %edi,%ebp
  801c85:	85 ff                	test   %edi,%edi
  801c87:	75 0b                	jne    801c94 <__udivdi3+0x38>
  801c89:	b8 01 00 00 00       	mov    $0x1,%eax
  801c8e:	31 d2                	xor    %edx,%edx
  801c90:	f7 f7                	div    %edi
  801c92:	89 c5                	mov    %eax,%ebp
  801c94:	31 d2                	xor    %edx,%edx
  801c96:	89 c8                	mov    %ecx,%eax
  801c98:	f7 f5                	div    %ebp
  801c9a:	89 c1                	mov    %eax,%ecx
  801c9c:	89 d8                	mov    %ebx,%eax
  801c9e:	f7 f5                	div    %ebp
  801ca0:	89 cf                	mov    %ecx,%edi
  801ca2:	89 fa                	mov    %edi,%edx
  801ca4:	83 c4 1c             	add    $0x1c,%esp
  801ca7:	5b                   	pop    %ebx
  801ca8:	5e                   	pop    %esi
  801ca9:	5f                   	pop    %edi
  801caa:	5d                   	pop    %ebp
  801cab:	c3                   	ret    
  801cac:	39 ce                	cmp    %ecx,%esi
  801cae:	77 28                	ja     801cd8 <__udivdi3+0x7c>
  801cb0:	0f bd fe             	bsr    %esi,%edi
  801cb3:	83 f7 1f             	xor    $0x1f,%edi
  801cb6:	75 40                	jne    801cf8 <__udivdi3+0x9c>
  801cb8:	39 ce                	cmp    %ecx,%esi
  801cba:	72 0a                	jb     801cc6 <__udivdi3+0x6a>
  801cbc:	3b 44 24 08          	cmp    0x8(%esp),%eax
  801cc0:	0f 87 9e 00 00 00    	ja     801d64 <__udivdi3+0x108>
  801cc6:	b8 01 00 00 00       	mov    $0x1,%eax
  801ccb:	89 fa                	mov    %edi,%edx
  801ccd:	83 c4 1c             	add    $0x1c,%esp
  801cd0:	5b                   	pop    %ebx
  801cd1:	5e                   	pop    %esi
  801cd2:	5f                   	pop    %edi
  801cd3:	5d                   	pop    %ebp
  801cd4:	c3                   	ret    
  801cd5:	8d 76 00             	lea    0x0(%esi),%esi
  801cd8:	31 ff                	xor    %edi,%edi
  801cda:	31 c0                	xor    %eax,%eax
  801cdc:	89 fa                	mov    %edi,%edx
  801cde:	83 c4 1c             	add    $0x1c,%esp
  801ce1:	5b                   	pop    %ebx
  801ce2:	5e                   	pop    %esi
  801ce3:	5f                   	pop    %edi
  801ce4:	5d                   	pop    %ebp
  801ce5:	c3                   	ret    
  801ce6:	66 90                	xchg   %ax,%ax
  801ce8:	89 d8                	mov    %ebx,%eax
  801cea:	f7 f7                	div    %edi
  801cec:	31 ff                	xor    %edi,%edi
  801cee:	89 fa                	mov    %edi,%edx
  801cf0:	83 c4 1c             	add    $0x1c,%esp
  801cf3:	5b                   	pop    %ebx
  801cf4:	5e                   	pop    %esi
  801cf5:	5f                   	pop    %edi
  801cf6:	5d                   	pop    %ebp
  801cf7:	c3                   	ret    
  801cf8:	bd 20 00 00 00       	mov    $0x20,%ebp
  801cfd:	89 eb                	mov    %ebp,%ebx
  801cff:	29 fb                	sub    %edi,%ebx
  801d01:	89 f9                	mov    %edi,%ecx
  801d03:	d3 e6                	shl    %cl,%esi
  801d05:	89 c5                	mov    %eax,%ebp
  801d07:	88 d9                	mov    %bl,%cl
  801d09:	d3 ed                	shr    %cl,%ebp
  801d0b:	89 e9                	mov    %ebp,%ecx
  801d0d:	09 f1                	or     %esi,%ecx
  801d0f:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  801d13:	89 f9                	mov    %edi,%ecx
  801d15:	d3 e0                	shl    %cl,%eax
  801d17:	89 c5                	mov    %eax,%ebp
  801d19:	89 d6                	mov    %edx,%esi
  801d1b:	88 d9                	mov    %bl,%cl
  801d1d:	d3 ee                	shr    %cl,%esi
  801d1f:	89 f9                	mov    %edi,%ecx
  801d21:	d3 e2                	shl    %cl,%edx
  801d23:	8b 44 24 08          	mov    0x8(%esp),%eax
  801d27:	88 d9                	mov    %bl,%cl
  801d29:	d3 e8                	shr    %cl,%eax
  801d2b:	09 c2                	or     %eax,%edx
  801d2d:	89 d0                	mov    %edx,%eax
  801d2f:	89 f2                	mov    %esi,%edx
  801d31:	f7 74 24 0c          	divl   0xc(%esp)
  801d35:	89 d6                	mov    %edx,%esi
  801d37:	89 c3                	mov    %eax,%ebx
  801d39:	f7 e5                	mul    %ebp
  801d3b:	39 d6                	cmp    %edx,%esi
  801d3d:	72 19                	jb     801d58 <__udivdi3+0xfc>
  801d3f:	74 0b                	je     801d4c <__udivdi3+0xf0>
  801d41:	89 d8                	mov    %ebx,%eax
  801d43:	31 ff                	xor    %edi,%edi
  801d45:	e9 58 ff ff ff       	jmp    801ca2 <__udivdi3+0x46>
  801d4a:	66 90                	xchg   %ax,%ax
  801d4c:	8b 54 24 08          	mov    0x8(%esp),%edx
  801d50:	89 f9                	mov    %edi,%ecx
  801d52:	d3 e2                	shl    %cl,%edx
  801d54:	39 c2                	cmp    %eax,%edx
  801d56:	73 e9                	jae    801d41 <__udivdi3+0xe5>
  801d58:	8d 43 ff             	lea    -0x1(%ebx),%eax
  801d5b:	31 ff                	xor    %edi,%edi
  801d5d:	e9 40 ff ff ff       	jmp    801ca2 <__udivdi3+0x46>
  801d62:	66 90                	xchg   %ax,%ax
  801d64:	31 c0                	xor    %eax,%eax
  801d66:	e9 37 ff ff ff       	jmp    801ca2 <__udivdi3+0x46>
  801d6b:	90                   	nop

00801d6c <__umoddi3>:
  801d6c:	55                   	push   %ebp
  801d6d:	57                   	push   %edi
  801d6e:	56                   	push   %esi
  801d6f:	53                   	push   %ebx
  801d70:	83 ec 1c             	sub    $0x1c,%esp
  801d73:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  801d77:	8b 74 24 34          	mov    0x34(%esp),%esi
  801d7b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801d7f:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  801d83:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801d87:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801d8b:	89 f3                	mov    %esi,%ebx
  801d8d:	89 fa                	mov    %edi,%edx
  801d8f:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801d93:	89 34 24             	mov    %esi,(%esp)
  801d96:	85 c0                	test   %eax,%eax
  801d98:	75 1a                	jne    801db4 <__umoddi3+0x48>
  801d9a:	39 f7                	cmp    %esi,%edi
  801d9c:	0f 86 a2 00 00 00    	jbe    801e44 <__umoddi3+0xd8>
  801da2:	89 c8                	mov    %ecx,%eax
  801da4:	89 f2                	mov    %esi,%edx
  801da6:	f7 f7                	div    %edi
  801da8:	89 d0                	mov    %edx,%eax
  801daa:	31 d2                	xor    %edx,%edx
  801dac:	83 c4 1c             	add    $0x1c,%esp
  801daf:	5b                   	pop    %ebx
  801db0:	5e                   	pop    %esi
  801db1:	5f                   	pop    %edi
  801db2:	5d                   	pop    %ebp
  801db3:	c3                   	ret    
  801db4:	39 f0                	cmp    %esi,%eax
  801db6:	0f 87 ac 00 00 00    	ja     801e68 <__umoddi3+0xfc>
  801dbc:	0f bd e8             	bsr    %eax,%ebp
  801dbf:	83 f5 1f             	xor    $0x1f,%ebp
  801dc2:	0f 84 ac 00 00 00    	je     801e74 <__umoddi3+0x108>
  801dc8:	bf 20 00 00 00       	mov    $0x20,%edi
  801dcd:	29 ef                	sub    %ebp,%edi
  801dcf:	89 fe                	mov    %edi,%esi
  801dd1:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801dd5:	89 e9                	mov    %ebp,%ecx
  801dd7:	d3 e0                	shl    %cl,%eax
  801dd9:	89 d7                	mov    %edx,%edi
  801ddb:	89 f1                	mov    %esi,%ecx
  801ddd:	d3 ef                	shr    %cl,%edi
  801ddf:	09 c7                	or     %eax,%edi
  801de1:	89 e9                	mov    %ebp,%ecx
  801de3:	d3 e2                	shl    %cl,%edx
  801de5:	89 14 24             	mov    %edx,(%esp)
  801de8:	89 d8                	mov    %ebx,%eax
  801dea:	d3 e0                	shl    %cl,%eax
  801dec:	89 c2                	mov    %eax,%edx
  801dee:	8b 44 24 08          	mov    0x8(%esp),%eax
  801df2:	d3 e0                	shl    %cl,%eax
  801df4:	89 44 24 04          	mov    %eax,0x4(%esp)
  801df8:	8b 44 24 08          	mov    0x8(%esp),%eax
  801dfc:	89 f1                	mov    %esi,%ecx
  801dfe:	d3 e8                	shr    %cl,%eax
  801e00:	09 d0                	or     %edx,%eax
  801e02:	d3 eb                	shr    %cl,%ebx
  801e04:	89 da                	mov    %ebx,%edx
  801e06:	f7 f7                	div    %edi
  801e08:	89 d3                	mov    %edx,%ebx
  801e0a:	f7 24 24             	mull   (%esp)
  801e0d:	89 c6                	mov    %eax,%esi
  801e0f:	89 d1                	mov    %edx,%ecx
  801e11:	39 d3                	cmp    %edx,%ebx
  801e13:	0f 82 87 00 00 00    	jb     801ea0 <__umoddi3+0x134>
  801e19:	0f 84 91 00 00 00    	je     801eb0 <__umoddi3+0x144>
  801e1f:	8b 54 24 04          	mov    0x4(%esp),%edx
  801e23:	29 f2                	sub    %esi,%edx
  801e25:	19 cb                	sbb    %ecx,%ebx
  801e27:	89 d8                	mov    %ebx,%eax
  801e29:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  801e2d:	d3 e0                	shl    %cl,%eax
  801e2f:	89 e9                	mov    %ebp,%ecx
  801e31:	d3 ea                	shr    %cl,%edx
  801e33:	09 d0                	or     %edx,%eax
  801e35:	89 e9                	mov    %ebp,%ecx
  801e37:	d3 eb                	shr    %cl,%ebx
  801e39:	89 da                	mov    %ebx,%edx
  801e3b:	83 c4 1c             	add    $0x1c,%esp
  801e3e:	5b                   	pop    %ebx
  801e3f:	5e                   	pop    %esi
  801e40:	5f                   	pop    %edi
  801e41:	5d                   	pop    %ebp
  801e42:	c3                   	ret    
  801e43:	90                   	nop
  801e44:	89 fd                	mov    %edi,%ebp
  801e46:	85 ff                	test   %edi,%edi
  801e48:	75 0b                	jne    801e55 <__umoddi3+0xe9>
  801e4a:	b8 01 00 00 00       	mov    $0x1,%eax
  801e4f:	31 d2                	xor    %edx,%edx
  801e51:	f7 f7                	div    %edi
  801e53:	89 c5                	mov    %eax,%ebp
  801e55:	89 f0                	mov    %esi,%eax
  801e57:	31 d2                	xor    %edx,%edx
  801e59:	f7 f5                	div    %ebp
  801e5b:	89 c8                	mov    %ecx,%eax
  801e5d:	f7 f5                	div    %ebp
  801e5f:	89 d0                	mov    %edx,%eax
  801e61:	e9 44 ff ff ff       	jmp    801daa <__umoddi3+0x3e>
  801e66:	66 90                	xchg   %ax,%ax
  801e68:	89 c8                	mov    %ecx,%eax
  801e6a:	89 f2                	mov    %esi,%edx
  801e6c:	83 c4 1c             	add    $0x1c,%esp
  801e6f:	5b                   	pop    %ebx
  801e70:	5e                   	pop    %esi
  801e71:	5f                   	pop    %edi
  801e72:	5d                   	pop    %ebp
  801e73:	c3                   	ret    
  801e74:	3b 04 24             	cmp    (%esp),%eax
  801e77:	72 06                	jb     801e7f <__umoddi3+0x113>
  801e79:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  801e7d:	77 0f                	ja     801e8e <__umoddi3+0x122>
  801e7f:	89 f2                	mov    %esi,%edx
  801e81:	29 f9                	sub    %edi,%ecx
  801e83:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  801e87:	89 14 24             	mov    %edx,(%esp)
  801e8a:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801e8e:	8b 44 24 04          	mov    0x4(%esp),%eax
  801e92:	8b 14 24             	mov    (%esp),%edx
  801e95:	83 c4 1c             	add    $0x1c,%esp
  801e98:	5b                   	pop    %ebx
  801e99:	5e                   	pop    %esi
  801e9a:	5f                   	pop    %edi
  801e9b:	5d                   	pop    %ebp
  801e9c:	c3                   	ret    
  801e9d:	8d 76 00             	lea    0x0(%esi),%esi
  801ea0:	2b 04 24             	sub    (%esp),%eax
  801ea3:	19 fa                	sbb    %edi,%edx
  801ea5:	89 d1                	mov    %edx,%ecx
  801ea7:	89 c6                	mov    %eax,%esi
  801ea9:	e9 71 ff ff ff       	jmp    801e1f <__umoddi3+0xb3>
  801eae:	66 90                	xchg   %ax,%ax
  801eb0:	39 44 24 04          	cmp    %eax,0x4(%esp)
  801eb4:	72 ea                	jb     801ea0 <__umoddi3+0x134>
  801eb6:	89 d9                	mov    %ebx,%ecx
  801eb8:	e9 62 ff ff ff       	jmp    801e1f <__umoddi3+0xb3>
