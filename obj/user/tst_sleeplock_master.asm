
obj/user/tst_sleeplock_master:     file format elf32-i386


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
  800031:	e8 73 02 00 00       	call   8002a9 <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
// Master program: create and run slaves, wait them to finish
#include <inc/lib.h>

void
_main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	57                   	push   %edi
  80003c:	56                   	push   %esi
  80003d:	53                   	push   %ebx
  80003e:	81 ec fc 00 00 00    	sub    $0xfc,%esp
	cprintf_colored(TEXT_yellow,"==============================================\n");
  800044:	83 ec 08             	sub    $0x8,%esp
  800047:	68 40 21 80 00       	push   $0x802140
  80004c:	6a 0e                	push   $0xe
  80004e:	e8 16 07 00 00       	call   800769 <cprintf_colored>
  800053:	83 c4 10             	add    $0x10,%esp
	cprintf_colored(TEXT_yellow,"MAKE SURE to have a FRESH RUN for this test\n(i.e. don't run any program/test before it)\n");
  800056:	83 ec 08             	sub    $0x8,%esp
  800059:	68 70 21 80 00       	push   $0x802170
  80005e:	6a 0e                	push   $0xe
  800060:	e8 04 07 00 00       	call   800769 <cprintf_colored>
  800065:	83 c4 10             	add    $0x10,%esp
	cprintf_colored(TEXT_yellow,"==============================================\n");
  800068:	83 ec 08             	sub    $0x8,%esp
  80006b:	68 40 21 80 00       	push   $0x802140
  800070:	6a 0e                	push   $0xe
  800072:	e8 f2 06 00 00       	call   800769 <cprintf_colored>
  800077:	83 c4 10             	add    $0x10,%esp

	int envID = sys_getenvid();
  80007a:	e8 79 1a 00 00       	call   801af8 <sys_getenvid>
  80007f:	89 45 dc             	mov    %eax,-0x24(%ebp)
	char slavesCnt[10];
	readline("Enter the number of Slave Programs: ", slavesCnt);
  800082:	83 ec 08             	sub    $0x8,%esp
  800085:	8d 45 ce             	lea    -0x32(%ebp),%eax
  800088:	50                   	push   %eax
  800089:	68 cc 21 80 00       	push   $0x8021cc
  80008e:	e8 82 0d 00 00       	call   800e15 <readline>
  800093:	83 c4 10             	add    $0x10,%esp
	int numOfSlaves = strtol(slavesCnt, NULL, 10);
  800096:	83 ec 04             	sub    $0x4,%esp
  800099:	6a 0a                	push   $0xa
  80009b:	6a 00                	push   $0x0
  80009d:	8d 45 ce             	lea    -0x32(%ebp),%eax
  8000a0:	50                   	push   %eax
  8000a1:	e8 86 13 00 00       	call   80142c <strtol>
  8000a6:	83 c4 10             	add    $0x10,%esp
  8000a9:	89 45 c8             	mov    %eax,-0x38(%ebp)

	//Save number of slaved to be checked later
	char cmd1[64] = "__NumOfSlaves@Set";
  8000ac:	8d 45 88             	lea    -0x78(%ebp),%eax
  8000af:	bb 64 23 80 00       	mov    $0x802364,%ebx
  8000b4:	ba 12 00 00 00       	mov    $0x12,%edx
  8000b9:	89 c7                	mov    %eax,%edi
  8000bb:	89 de                	mov    %ebx,%esi
  8000bd:	89 d1                	mov    %edx,%ecx
  8000bf:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  8000c1:	8d 55 9a             	lea    -0x66(%ebp),%edx
  8000c4:	b9 2e 00 00 00       	mov    $0x2e,%ecx
  8000c9:	b0 00                	mov    $0x0,%al
  8000cb:	89 d7                	mov    %edx,%edi
  8000cd:	f3 aa                	rep stos %al,%es:(%edi)
	sys_utilities(cmd1, (uint32)(&numOfSlaves));
  8000cf:	8d 45 c8             	lea    -0x38(%ebp),%eax
  8000d2:	83 ec 08             	sub    $0x8,%esp
  8000d5:	50                   	push   %eax
  8000d6:	8d 45 88             	lea    -0x78(%ebp),%eax
  8000d9:	50                   	push   %eax
  8000da:	e8 68 1c 00 00       	call   801d47 <sys_utilities>
  8000df:	83 c4 10             	add    $0x10,%esp

	rsttst();
  8000e2:	e8 08 1b 00 00       	call   801bef <rsttst>

	//Create and run slave programs that should sleep
	int id;
	for (int i = 0; i < numOfSlaves; ++i)
  8000e7:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  8000ee:	eb 6a                	jmp    80015a <_main+0x122>
	{
		id = sys_create_env("tstSleepLockSlave", (myEnv->page_WS_max_size),(myEnv->SecondListSize), (myEnv->percentage_of_WS_pages_to_be_removed));
  8000f0:	a1 20 30 80 00       	mov    0x803020,%eax
  8000f5:	8b 90 3c da 01 00    	mov    0x1da3c(%eax),%edx
  8000fb:	a1 20 30 80 00       	mov    0x803020,%eax
  800100:	8b 80 34 da 01 00    	mov    0x1da34(%eax),%eax
  800106:	89 c1                	mov    %eax,%ecx
  800108:	a1 20 30 80 00       	mov    0x803020,%eax
  80010d:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
  800113:	52                   	push   %edx
  800114:	51                   	push   %ecx
  800115:	50                   	push   %eax
  800116:	68 f1 21 80 00       	push   $0x8021f1
  80011b:	e8 83 19 00 00       	call   801aa3 <sys_create_env>
  800120:	83 c4 10             	add    $0x10,%esp
  800123:	89 45 d8             	mov    %eax,-0x28(%ebp)
		if (id== E_ENV_CREATION_ERROR)
  800126:	83 7d d8 ef          	cmpl   $0xffffffef,-0x28(%ebp)
  80012a:	75 1d                	jne    800149 <_main+0x111>
		{
			cprintf_colored(TEXT_TESTERR_CLR,"\n%~insufficient number of processes in the system! only %d slave processes are created\n", i);
  80012c:	83 ec 04             	sub    $0x4,%esp
  80012f:	ff 75 e4             	pushl  -0x1c(%ebp)
  800132:	68 04 22 80 00       	push   $0x802204
  800137:	6a 0c                	push   $0xc
  800139:	e8 2b 06 00 00       	call   800769 <cprintf_colored>
  80013e:	83 c4 10             	add    $0x10,%esp
			numOfSlaves = i;
  800141:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800144:	89 45 c8             	mov    %eax,-0x38(%ebp)
			break;
  800147:	eb 19                	jmp    800162 <_main+0x12a>
		}
		sys_run_env(id);
  800149:	83 ec 0c             	sub    $0xc,%esp
  80014c:	ff 75 d8             	pushl  -0x28(%ebp)
  80014f:	e8 6d 19 00 00       	call   801ac1 <sys_run_env>
  800154:	83 c4 10             	add    $0x10,%esp

	rsttst();

	//Create and run slave programs that should sleep
	int id;
	for (int i = 0; i < numOfSlaves; ++i)
  800157:	ff 45 e4             	incl   -0x1c(%ebp)
  80015a:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80015d:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  800160:	7c 8e                	jl     8000f0 <_main+0xb8>
		}
		sys_run_env(id);
	}

	//Wait until all slaves, except the one inside C.S., are blocked
	int numOfBlockedProcesses = 0;
  800162:	c7 45 84 00 00 00 00 	movl   $0x0,-0x7c(%ebp)
	char cmd2[64] = "__GetLockQueueSize__";
  800169:	8d 85 44 ff ff ff    	lea    -0xbc(%ebp),%eax
  80016f:	bb a4 23 80 00       	mov    $0x8023a4,%ebx
  800174:	ba 15 00 00 00       	mov    $0x15,%edx
  800179:	89 c7                	mov    %eax,%edi
  80017b:	89 de                	mov    %ebx,%esi
  80017d:	89 d1                	mov    %edx,%ecx
  80017f:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  800181:	8d 95 59 ff ff ff    	lea    -0xa7(%ebp),%edx
  800187:	b9 2b 00 00 00       	mov    $0x2b,%ecx
  80018c:	b0 00                	mov    $0x0,%al
  80018e:	89 d7                	mov    %edx,%edi
  800190:	f3 aa                	rep stos %al,%es:(%edi)
	sys_utilities(cmd2, (uint32)(&numOfBlockedProcesses));
  800192:	8d 45 84             	lea    -0x7c(%ebp),%eax
  800195:	83 ec 08             	sub    $0x8,%esp
  800198:	50                   	push   %eax
  800199:	8d 85 44 ff ff ff    	lea    -0xbc(%ebp),%eax
  80019f:	50                   	push   %eax
  8001a0:	e8 a2 1b 00 00       	call   801d47 <sys_utilities>
  8001a5:	83 c4 10             	add    $0x10,%esp
	int cnt = 0;
  8001a8:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
	while (numOfBlockedProcesses != numOfSlaves-1)
  8001af:	eb 77                	jmp    800228 <_main+0x1f0>
	{
		env_sleep(5000);
  8001b1:	83 ec 0c             	sub    $0xc,%esp
  8001b4:	68 88 13 00 00       	push   $0x1388
  8001b9:	e8 15 1c 00 00       	call   801dd3 <env_sleep>
  8001be:	83 c4 10             	add    $0x10,%esp
		if (cnt == numOfSlaves)
  8001c1:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8001c4:	39 45 e0             	cmp    %eax,-0x20(%ebp)
  8001c7:	75 1d                	jne    8001e6 <_main+0x1ae>
		{
			panic("%~test sleeplock failed! unexpected number of blocked slaves. Expected = %d, Current = %d", numOfSlaves-1, numOfBlockedProcesses);
  8001c9:	8b 45 84             	mov    -0x7c(%ebp),%eax
  8001cc:	8b 55 c8             	mov    -0x38(%ebp),%edx
  8001cf:	4a                   	dec    %edx
  8001d0:	83 ec 0c             	sub    $0xc,%esp
  8001d3:	50                   	push   %eax
  8001d4:	52                   	push   %edx
  8001d5:	68 5c 22 80 00       	push   $0x80225c
  8001da:	6a 2f                	push   $0x2f
  8001dc:	68 b6 22 80 00       	push   $0x8022b6
  8001e1:	e8 88 02 00 00       	call   80046e <_panic>
		}
		char cmd3[64] = "__GetLockQueueSize__";
  8001e6:	8d 85 04 ff ff ff    	lea    -0xfc(%ebp),%eax
  8001ec:	bb a4 23 80 00       	mov    $0x8023a4,%ebx
  8001f1:	ba 15 00 00 00       	mov    $0x15,%edx
  8001f6:	89 c7                	mov    %eax,%edi
  8001f8:	89 de                	mov    %ebx,%esi
  8001fa:	89 d1                	mov    %edx,%ecx
  8001fc:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  8001fe:	8d 95 19 ff ff ff    	lea    -0xe7(%ebp),%edx
  800204:	b9 2b 00 00 00       	mov    $0x2b,%ecx
  800209:	b0 00                	mov    $0x0,%al
  80020b:	89 d7                	mov    %edx,%edi
  80020d:	f3 aa                	rep stos %al,%es:(%edi)
		sys_utilities(cmd3, (uint32)(&numOfBlockedProcesses));
  80020f:	8d 45 84             	lea    -0x7c(%ebp),%eax
  800212:	83 ec 08             	sub    $0x8,%esp
  800215:	50                   	push   %eax
  800216:	8d 85 04 ff ff ff    	lea    -0xfc(%ebp),%eax
  80021c:	50                   	push   %eax
  80021d:	e8 25 1b 00 00       	call   801d47 <sys_utilities>
  800222:	83 c4 10             	add    $0x10,%esp
		cnt++ ;
  800225:	ff 45 e0             	incl   -0x20(%ebp)
	//Wait until all slaves, except the one inside C.S., are blocked
	int numOfBlockedProcesses = 0;
	char cmd2[64] = "__GetLockQueueSize__";
	sys_utilities(cmd2, (uint32)(&numOfBlockedProcesses));
	int cnt = 0;
	while (numOfBlockedProcesses != numOfSlaves-1)
  800228:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80022b:	8d 50 ff             	lea    -0x1(%eax),%edx
  80022e:	8b 45 84             	mov    -0x7c(%ebp),%eax
  800231:	39 c2                	cmp    %eax,%edx
  800233:	0f 85 78 ff ff ff    	jne    8001b1 <_main+0x179>
		cnt++ ;
	}
	//cprintf("\numOfBlockedProcesses = %d\n", numOfBlockedProcesses);

	//signal the slave inside the critical section to leave it
	inctst();
  800239:	e8 11 1a 00 00       	call   801c4f <inctst>

	//Wait until all slave finished
	cnt = 0;
  80023e:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
	while (gettst() != numOfSlaves +1/*since master already increment it by 1*/)
  800245:	eb 3a                	jmp    800281 <_main+0x249>
	{
		env_sleep(15000);
  800247:	83 ec 0c             	sub    $0xc,%esp
  80024a:	68 98 3a 00 00       	push   $0x3a98
  80024f:	e8 7f 1b 00 00       	call   801dd3 <env_sleep>
  800254:	83 c4 10             	add    $0x10,%esp
		if (cnt == numOfSlaves)
  800257:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80025a:	39 45 e0             	cmp    %eax,-0x20(%ebp)
  80025d:	75 1f                	jne    80027e <_main+0x246>
		{
			panic("%~test sleeplock failed! not all processes finished. Expected %d, Actual %d", numOfSlaves +1, gettst());
  80025f:	e8 05 1a 00 00       	call   801c69 <gettst>
  800264:	8b 55 c8             	mov    -0x38(%ebp),%edx
  800267:	42                   	inc    %edx
  800268:	83 ec 0c             	sub    $0xc,%esp
  80026b:	50                   	push   %eax
  80026c:	52                   	push   %edx
  80026d:	68 d4 22 80 00       	push   $0x8022d4
  800272:	6a 41                	push   $0x41
  800274:	68 b6 22 80 00       	push   $0x8022b6
  800279:	e8 f0 01 00 00       	call   80046e <_panic>
		}
		cnt++ ;
  80027e:	ff 45 e0             	incl   -0x20(%ebp)
	//signal the slave inside the critical section to leave it
	inctst();

	//Wait until all slave finished
	cnt = 0;
	while (gettst() != numOfSlaves +1/*since master already increment it by 1*/)
  800281:	e8 e3 19 00 00       	call   801c69 <gettst>
  800286:	8b 55 c8             	mov    -0x38(%ebp),%edx
  800289:	42                   	inc    %edx
  80028a:	39 d0                	cmp    %edx,%eax
  80028c:	75 b9                	jne    800247 <_main+0x20f>
			panic("%~test sleeplock failed! not all processes finished. Expected %d, Actual %d", numOfSlaves +1, gettst());
		}
		cnt++ ;
	}

	cprintf_colored(TEXT_light_green, "%~\n\nCongratulations!! Test of Sleep Lock completed successfully!!\n\n");
  80028e:	83 ec 08             	sub    $0x8,%esp
  800291:	68 20 23 80 00       	push   $0x802320
  800296:	6a 0a                	push   $0xa
  800298:	e8 cc 04 00 00       	call   800769 <cprintf_colored>
  80029d:	83 c4 10             	add    $0x10,%esp
}
  8002a0:	90                   	nop
  8002a1:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8002a4:	5b                   	pop    %ebx
  8002a5:	5e                   	pop    %esi
  8002a6:	5f                   	pop    %edi
  8002a7:	5d                   	pop    %ebp
  8002a8:	c3                   	ret    

008002a9 <libmain>:
volatile bool printStats = 1;

volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";
void
libmain(int argc, char **argv)
{
  8002a9:	55                   	push   %ebp
  8002aa:	89 e5                	mov    %esp,%ebp
  8002ac:	57                   	push   %edi
  8002ad:	56                   	push   %esi
  8002ae:	53                   	push   %ebx
  8002af:	83 ec 7c             	sub    $0x7c,%esp
	//printStats = 1;
	int envIndex = sys_getenvindex();
  8002b2:	e8 5a 18 00 00       	call   801b11 <sys_getenvindex>
  8002b7:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	myEnv = &(envs[envIndex]);
  8002ba:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8002bd:	89 d0                	mov    %edx,%eax
  8002bf:	c1 e0 06             	shl    $0x6,%eax
  8002c2:	29 d0                	sub    %edx,%eax
  8002c4:	c1 e0 02             	shl    $0x2,%eax
  8002c7:	01 d0                	add    %edx,%eax
  8002c9:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8002d0:	01 c8                	add    %ecx,%eax
  8002d2:	c1 e0 03             	shl    $0x3,%eax
  8002d5:	01 d0                	add    %edx,%eax
  8002d7:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8002de:	29 c2                	sub    %eax,%edx
  8002e0:	8d 04 95 00 00 00 00 	lea    0x0(,%edx,4),%eax
  8002e7:	89 c2                	mov    %eax,%edx
  8002e9:	8d 82 00 00 c0 ee    	lea    -0x11400000(%edx),%eax
  8002ef:	a3 20 30 80 00       	mov    %eax,0x803020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  8002f4:	a1 20 30 80 00       	mov    0x803020,%eax
  8002f9:	8a 40 20             	mov    0x20(%eax),%al
  8002fc:	84 c0                	test   %al,%al
  8002fe:	74 0d                	je     80030d <libmain+0x64>
		binaryname = myEnv->prog_name;
  800300:	a1 20 30 80 00       	mov    0x803020,%eax
  800305:	83 c0 20             	add    $0x20,%eax
  800308:	a3 04 30 80 00       	mov    %eax,0x803004

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80030d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800311:	7e 0a                	jle    80031d <libmain+0x74>
		binaryname = argv[0];
  800313:	8b 45 0c             	mov    0xc(%ebp),%eax
  800316:	8b 00                	mov    (%eax),%eax
  800318:	a3 04 30 80 00       	mov    %eax,0x803004

	// call user main routine
	_main(argc, argv);
  80031d:	83 ec 08             	sub    $0x8,%esp
  800320:	ff 75 0c             	pushl  0xc(%ebp)
  800323:	ff 75 08             	pushl  0x8(%ebp)
  800326:	e8 0d fd ff ff       	call   800038 <_main>
  80032b:	83 c4 10             	add    $0x10,%esp

	if (printStats)
  80032e:	a1 00 30 80 00       	mov    0x803000,%eax
  800333:	85 c0                	test   %eax,%eax
  800335:	0f 84 01 01 00 00    	je     80043c <libmain+0x193>
	{
		char isOPTReplCmd[100] = "__IsOPTRepl__" ;
  80033b:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  800341:	bb dc 24 80 00       	mov    $0x8024dc,%ebx
  800346:	ba 0e 00 00 00       	mov    $0xe,%edx
  80034b:	89 c7                	mov    %eax,%edi
  80034d:	89 de                	mov    %ebx,%esi
  80034f:	89 d1                	mov    %edx,%ecx
  800351:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  800353:	8d 55 8a             	lea    -0x76(%ebp),%edx
  800356:	b9 56 00 00 00       	mov    $0x56,%ecx
  80035b:	b0 00                	mov    $0x0,%al
  80035d:	89 d7                	mov    %edx,%edi
  80035f:	f3 aa                	rep stos %al,%es:(%edi)
		int isOPTRepl = 0;
  800361:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
		sys_utilities(isOPTReplCmd, (uint32)(&isOPTRepl));
  800368:	8d 45 e0             	lea    -0x20(%ebp),%eax
  80036b:	83 ec 08             	sub    $0x8,%esp
  80036e:	50                   	push   %eax
  80036f:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  800375:	50                   	push   %eax
  800376:	e8 cc 19 00 00       	call   801d47 <sys_utilities>
  80037b:	83 c4 10             	add    $0x10,%esp

		sys_lock_cons();
  80037e:	e8 15 15 00 00       	call   801898 <sys_lock_cons>
		{
			cprintf("**************************************\n");
  800383:	83 ec 0c             	sub    $0xc,%esp
  800386:	68 fc 23 80 00       	push   $0x8023fc
  80038b:	e8 ac 03 00 00       	call   80073c <cprintf>
  800390:	83 c4 10             	add    $0x10,%esp
			if (isOPTRepl)
  800393:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800396:	85 c0                	test   %eax,%eax
  800398:	74 18                	je     8003b2 <libmain+0x109>
			{
				cprintf("OPTIMAL number of page faults = %d\n", sys_get_optimal_num_faults());
  80039a:	e8 c6 19 00 00       	call   801d65 <sys_get_optimal_num_faults>
  80039f:	83 ec 08             	sub    $0x8,%esp
  8003a2:	50                   	push   %eax
  8003a3:	68 24 24 80 00       	push   $0x802424
  8003a8:	e8 8f 03 00 00       	call   80073c <cprintf>
  8003ad:	83 c4 10             	add    $0x10,%esp
  8003b0:	eb 59                	jmp    80040b <libmain+0x162>
			}
			else
			{
				cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8003b2:	a1 20 30 80 00       	mov    0x803020,%eax
  8003b7:	8b 90 50 da 01 00    	mov    0x1da50(%eax),%edx
  8003bd:	a1 20 30 80 00       	mov    0x803020,%eax
  8003c2:	8b 80 40 da 01 00    	mov    0x1da40(%eax),%eax
  8003c8:	83 ec 04             	sub    $0x4,%esp
  8003cb:	52                   	push   %edx
  8003cc:	50                   	push   %eax
  8003cd:	68 48 24 80 00       	push   $0x802448
  8003d2:	e8 65 03 00 00       	call   80073c <cprintf>
  8003d7:	83 c4 10             	add    $0x10,%esp
				cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  8003da:	a1 20 30 80 00       	mov    0x803020,%eax
  8003df:	8b 88 64 da 01 00    	mov    0x1da64(%eax),%ecx
  8003e5:	a1 20 30 80 00       	mov    0x803020,%eax
  8003ea:	8b 90 60 da 01 00    	mov    0x1da60(%eax),%edx
  8003f0:	a1 20 30 80 00       	mov    0x803020,%eax
  8003f5:	8b 80 5c da 01 00    	mov    0x1da5c(%eax),%eax
  8003fb:	51                   	push   %ecx
  8003fc:	52                   	push   %edx
  8003fd:	50                   	push   %eax
  8003fe:	68 70 24 80 00       	push   $0x802470
  800403:	e8 34 03 00 00       	call   80073c <cprintf>
  800408:	83 c4 10             	add    $0x10,%esp
			}
			//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
			cprintf("Num of clocks = %d\n", myEnv->nClocks);
  80040b:	a1 20 30 80 00       	mov    0x803020,%eax
  800410:	8b 80 68 da 01 00    	mov    0x1da68(%eax),%eax
  800416:	83 ec 08             	sub    $0x8,%esp
  800419:	50                   	push   %eax
  80041a:	68 c8 24 80 00       	push   $0x8024c8
  80041f:	e8 18 03 00 00       	call   80073c <cprintf>
  800424:	83 c4 10             	add    $0x10,%esp
			cprintf("**************************************\n");
  800427:	83 ec 0c             	sub    $0xc,%esp
  80042a:	68 fc 23 80 00       	push   $0x8023fc
  80042f:	e8 08 03 00 00       	call   80073c <cprintf>
  800434:	83 c4 10             	add    $0x10,%esp
		}
		sys_unlock_cons();
  800437:	e8 76 14 00 00       	call   8018b2 <sys_unlock_cons>
	}

	// exit gracefully
	exit();
  80043c:	e8 1f 00 00 00       	call   800460 <exit>
}
  800441:	90                   	nop
  800442:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800445:	5b                   	pop    %ebx
  800446:	5e                   	pop    %esi
  800447:	5f                   	pop    %edi
  800448:	5d                   	pop    %ebp
  800449:	c3                   	ret    

0080044a <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  80044a:	55                   	push   %ebp
  80044b:	89 e5                	mov    %esp,%ebp
  80044d:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800450:	83 ec 0c             	sub    $0xc,%esp
  800453:	6a 00                	push   $0x0
  800455:	e8 83 16 00 00       	call   801add <sys_destroy_env>
  80045a:	83 c4 10             	add    $0x10,%esp
}
  80045d:	90                   	nop
  80045e:	c9                   	leave  
  80045f:	c3                   	ret    

00800460 <exit>:

void
exit(void)
{
  800460:	55                   	push   %ebp
  800461:	89 e5                	mov    %esp,%ebp
  800463:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  800466:	e8 d8 16 00 00       	call   801b43 <sys_exit_env>
}
  80046b:	90                   	nop
  80046c:	c9                   	leave  
  80046d:	c3                   	ret    

0080046e <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  80046e:	55                   	push   %ebp
  80046f:	89 e5                	mov    %esp,%ebp
  800471:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  800474:	8d 45 10             	lea    0x10(%ebp),%eax
  800477:	83 c0 04             	add    $0x4,%eax
  80047a:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  80047d:	a1 18 b1 81 00       	mov    0x81b118,%eax
  800482:	85 c0                	test   %eax,%eax
  800484:	74 16                	je     80049c <_panic+0x2e>
		cprintf("%s: ", argv0);
  800486:	a1 18 b1 81 00       	mov    0x81b118,%eax
  80048b:	83 ec 08             	sub    $0x8,%esp
  80048e:	50                   	push   %eax
  80048f:	68 40 25 80 00       	push   $0x802540
  800494:	e8 a3 02 00 00       	call   80073c <cprintf>
  800499:	83 c4 10             	add    $0x10,%esp
	cprintf_colored(TEXT_PANIC_CLR, "user [EVAL_FINAL]panic in %s at %s:%d: ", binaryname, file, line);
  80049c:	a1 04 30 80 00       	mov    0x803004,%eax
  8004a1:	83 ec 0c             	sub    $0xc,%esp
  8004a4:	ff 75 0c             	pushl  0xc(%ebp)
  8004a7:	ff 75 08             	pushl  0x8(%ebp)
  8004aa:	50                   	push   %eax
  8004ab:	68 48 25 80 00       	push   $0x802548
  8004b0:	6a 74                	push   $0x74
  8004b2:	e8 b2 02 00 00       	call   800769 <cprintf_colored>
  8004b7:	83 c4 20             	add    $0x20,%esp
	vcprintf(fmt, ap);
  8004ba:	8b 45 10             	mov    0x10(%ebp),%eax
  8004bd:	83 ec 08             	sub    $0x8,%esp
  8004c0:	ff 75 f4             	pushl  -0xc(%ebp)
  8004c3:	50                   	push   %eax
  8004c4:	e8 04 02 00 00       	call   8006cd <vcprintf>
  8004c9:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  8004cc:	83 ec 08             	sub    $0x8,%esp
  8004cf:	6a 00                	push   $0x0
  8004d1:	68 70 25 80 00       	push   $0x802570
  8004d6:	e8 f2 01 00 00       	call   8006cd <vcprintf>
  8004db:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  8004de:	e8 7d ff ff ff       	call   800460 <exit>

	// should not return here
	while (1) ;
  8004e3:	eb fe                	jmp    8004e3 <_panic+0x75>

008004e5 <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  8004e5:	55                   	push   %ebp
  8004e6:	89 e5                	mov    %esp,%ebp
  8004e8:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  8004eb:	a1 20 30 80 00       	mov    0x803020,%eax
  8004f0:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  8004f6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004f9:	39 c2                	cmp    %eax,%edx
  8004fb:	74 14                	je     800511 <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  8004fd:	83 ec 04             	sub    $0x4,%esp
  800500:	68 74 25 80 00       	push   $0x802574
  800505:	6a 26                	push   $0x26
  800507:	68 c0 25 80 00       	push   $0x8025c0
  80050c:	e8 5d ff ff ff       	call   80046e <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  800511:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  800518:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80051f:	e9 c5 00 00 00       	jmp    8005e9 <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  800524:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800527:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80052e:	8b 45 08             	mov    0x8(%ebp),%eax
  800531:	01 d0                	add    %edx,%eax
  800533:	8b 00                	mov    (%eax),%eax
  800535:	85 c0                	test   %eax,%eax
  800537:	75 08                	jne    800541 <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  800539:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  80053c:	e9 a5 00 00 00       	jmp    8005e6 <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  800541:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800548:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  80054f:	eb 69                	jmp    8005ba <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  800551:	a1 20 30 80 00       	mov    0x803020,%eax
  800556:	8b 88 38 da 01 00    	mov    0x1da38(%eax),%ecx
  80055c:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80055f:	89 d0                	mov    %edx,%eax
  800561:	01 c0                	add    %eax,%eax
  800563:	01 d0                	add    %edx,%eax
  800565:	c1 e0 03             	shl    $0x3,%eax
  800568:	01 c8                	add    %ecx,%eax
  80056a:	8a 40 04             	mov    0x4(%eax),%al
  80056d:	84 c0                	test   %al,%al
  80056f:	75 46                	jne    8005b7 <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800571:	a1 20 30 80 00       	mov    0x803020,%eax
  800576:	8b 88 38 da 01 00    	mov    0x1da38(%eax),%ecx
  80057c:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80057f:	89 d0                	mov    %edx,%eax
  800581:	01 c0                	add    %eax,%eax
  800583:	01 d0                	add    %edx,%eax
  800585:	c1 e0 03             	shl    $0x3,%eax
  800588:	01 c8                	add    %ecx,%eax
  80058a:	8b 00                	mov    (%eax),%eax
  80058c:	89 45 dc             	mov    %eax,-0x24(%ebp)
  80058f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800592:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800597:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  800599:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80059c:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8005a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8005a6:	01 c8                	add    %ecx,%eax
  8005a8:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8005aa:	39 c2                	cmp    %eax,%edx
  8005ac:	75 09                	jne    8005b7 <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  8005ae:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  8005b5:	eb 15                	jmp    8005cc <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8005b7:	ff 45 e8             	incl   -0x18(%ebp)
  8005ba:	a1 20 30 80 00       	mov    0x803020,%eax
  8005bf:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  8005c5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8005c8:	39 c2                	cmp    %eax,%edx
  8005ca:	77 85                	ja     800551 <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  8005cc:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8005d0:	75 14                	jne    8005e6 <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  8005d2:	83 ec 04             	sub    $0x4,%esp
  8005d5:	68 cc 25 80 00       	push   $0x8025cc
  8005da:	6a 3a                	push   $0x3a
  8005dc:	68 c0 25 80 00       	push   $0x8025c0
  8005e1:	e8 88 fe ff ff       	call   80046e <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  8005e6:	ff 45 f0             	incl   -0x10(%ebp)
  8005e9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8005ec:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8005ef:	0f 8c 2f ff ff ff    	jl     800524 <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  8005f5:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8005fc:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800603:	eb 26                	jmp    80062b <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  800605:	a1 20 30 80 00       	mov    0x803020,%eax
  80060a:	8b 88 38 da 01 00    	mov    0x1da38(%eax),%ecx
  800610:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800613:	89 d0                	mov    %edx,%eax
  800615:	01 c0                	add    %eax,%eax
  800617:	01 d0                	add    %edx,%eax
  800619:	c1 e0 03             	shl    $0x3,%eax
  80061c:	01 c8                	add    %ecx,%eax
  80061e:	8a 40 04             	mov    0x4(%eax),%al
  800621:	3c 01                	cmp    $0x1,%al
  800623:	75 03                	jne    800628 <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  800625:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800628:	ff 45 e0             	incl   -0x20(%ebp)
  80062b:	a1 20 30 80 00       	mov    0x803020,%eax
  800630:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  800636:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800639:	39 c2                	cmp    %eax,%edx
  80063b:	77 c8                	ja     800605 <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  80063d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800640:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800643:	74 14                	je     800659 <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  800645:	83 ec 04             	sub    $0x4,%esp
  800648:	68 20 26 80 00       	push   $0x802620
  80064d:	6a 44                	push   $0x44
  80064f:	68 c0 25 80 00       	push   $0x8025c0
  800654:	e8 15 fe ff ff       	call   80046e <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  800659:	90                   	nop
  80065a:	c9                   	leave  
  80065b:	c3                   	ret    

0080065c <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  80065c:	55                   	push   %ebp
  80065d:	89 e5                	mov    %esp,%ebp
  80065f:	53                   	push   %ebx
  800660:	83 ec 04             	sub    $0x4,%esp
	b->buf[b->idx++] = ch;
  800663:	8b 45 0c             	mov    0xc(%ebp),%eax
  800666:	8b 00                	mov    (%eax),%eax
  800668:	8d 48 01             	lea    0x1(%eax),%ecx
  80066b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80066e:	89 0a                	mov    %ecx,(%edx)
  800670:	8b 55 08             	mov    0x8(%ebp),%edx
  800673:	88 d1                	mov    %dl,%cl
  800675:	8b 55 0c             	mov    0xc(%ebp),%edx
  800678:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  80067c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80067f:	8b 00                	mov    (%eax),%eax
  800681:	3d ff 00 00 00       	cmp    $0xff,%eax
  800686:	75 30                	jne    8006b8 <putch+0x5c>
		sys_cputs(b->buf, b->idx, printProgName, curTextClr);
  800688:	8b 15 1c b1 81 00    	mov    0x81b11c,%edx
  80068e:	a0 44 30 80 00       	mov    0x803044,%al
  800693:	0f b6 c0             	movzbl %al,%eax
  800696:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800699:	8b 09                	mov    (%ecx),%ecx
  80069b:	89 cb                	mov    %ecx,%ebx
  80069d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8006a0:	83 c1 08             	add    $0x8,%ecx
  8006a3:	52                   	push   %edx
  8006a4:	50                   	push   %eax
  8006a5:	53                   	push   %ebx
  8006a6:	51                   	push   %ecx
  8006a7:	e8 a8 11 00 00       	call   801854 <sys_cputs>
  8006ac:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8006af:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006b2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8006b8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006bb:	8b 40 04             	mov    0x4(%eax),%eax
  8006be:	8d 50 01             	lea    0x1(%eax),%edx
  8006c1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006c4:	89 50 04             	mov    %edx,0x4(%eax)
}
  8006c7:	90                   	nop
  8006c8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8006cb:	c9                   	leave  
  8006cc:	c3                   	ret    

008006cd <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  8006cd:	55                   	push   %ebp
  8006ce:	89 e5                	mov    %esp,%ebp
  8006d0:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8006d6:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8006dd:	00 00 00 
	b.cnt = 0;
  8006e0:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8006e7:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  8006ea:	ff 75 0c             	pushl  0xc(%ebp)
  8006ed:	ff 75 08             	pushl  0x8(%ebp)
  8006f0:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8006f6:	50                   	push   %eax
  8006f7:	68 5c 06 80 00       	push   $0x80065c
  8006fc:	e8 5a 02 00 00       	call   80095b <vprintfmt>
  800701:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName, curTextClr);
  800704:	8b 15 1c b1 81 00    	mov    0x81b11c,%edx
  80070a:	a0 44 30 80 00       	mov    0x803044,%al
  80070f:	0f b6 c0             	movzbl %al,%eax
  800712:	8b 8d f0 fe ff ff    	mov    -0x110(%ebp),%ecx
  800718:	52                   	push   %edx
  800719:	50                   	push   %eax
  80071a:	51                   	push   %ecx
  80071b:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800721:	83 c0 08             	add    $0x8,%eax
  800724:	50                   	push   %eax
  800725:	e8 2a 11 00 00       	call   801854 <sys_cputs>
  80072a:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  80072d:	c6 05 44 30 80 00 00 	movb   $0x0,0x803044
	return b.cnt;
  800734:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  80073a:	c9                   	leave  
  80073b:	c3                   	ret    

0080073c <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  80073c:	55                   	push   %ebp
  80073d:	89 e5                	mov    %esp,%ebp
  80073f:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800742:	c6 05 44 30 80 00 01 	movb   $0x1,0x803044
	va_start(ap, fmt);
  800749:	8d 45 0c             	lea    0xc(%ebp),%eax
  80074c:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  80074f:	8b 45 08             	mov    0x8(%ebp),%eax
  800752:	83 ec 08             	sub    $0x8,%esp
  800755:	ff 75 f4             	pushl  -0xc(%ebp)
  800758:	50                   	push   %eax
  800759:	e8 6f ff ff ff       	call   8006cd <vcprintf>
  80075e:	83 c4 10             	add    $0x10,%esp
  800761:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800764:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800767:	c9                   	leave  
  800768:	c3                   	ret    

00800769 <cprintf_colored>:

// *************** This text coloring feature is implemented by *************
// ********** Abd-Alrahman Zedan From Team Frozen-Bytes - FCIS'24-25 ********
int cprintf_colored(int textClr, const char *fmt, ...) {
  800769:	55                   	push   %ebp
  80076a:	89 e5                	mov    %esp,%ebp
  80076c:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  80076f:	c6 05 44 30 80 00 01 	movb   $0x1,0x803044
	curTextClr = (textClr << 8) ; //set text color by the given value
  800776:	8b 45 08             	mov    0x8(%ebp),%eax
  800779:	c1 e0 08             	shl    $0x8,%eax
  80077c:	a3 1c b1 81 00       	mov    %eax,0x81b11c
	va_start(ap, fmt);
  800781:	8d 45 0c             	lea    0xc(%ebp),%eax
  800784:	83 c0 04             	add    $0x4,%eax
  800787:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  80078a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80078d:	83 ec 08             	sub    $0x8,%esp
  800790:	ff 75 f4             	pushl  -0xc(%ebp)
  800793:	50                   	push   %eax
  800794:	e8 34 ff ff ff       	call   8006cd <vcprintf>
  800799:	83 c4 10             	add    $0x10,%esp
  80079c:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);
	curTextClr = TEXT_DEFAULT_CLR; //restore default color
  80079f:	c7 05 1c b1 81 00 00 	movl   $0x700,0x81b11c
  8007a6:	07 00 00 

	return cnt;
  8007a9:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8007ac:	c9                   	leave  
  8007ad:	c3                   	ret    

008007ae <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  8007ae:	55                   	push   %ebp
  8007af:	89 e5                	mov    %esp,%ebp
  8007b1:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  8007b4:	e8 df 10 00 00       	call   801898 <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  8007b9:	8d 45 0c             	lea    0xc(%ebp),%eax
  8007bc:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  8007bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8007c2:	83 ec 08             	sub    $0x8,%esp
  8007c5:	ff 75 f4             	pushl  -0xc(%ebp)
  8007c8:	50                   	push   %eax
  8007c9:	e8 ff fe ff ff       	call   8006cd <vcprintf>
  8007ce:	83 c4 10             	add    $0x10,%esp
  8007d1:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  8007d4:	e8 d9 10 00 00       	call   8018b2 <sys_unlock_cons>
	return cnt;
  8007d9:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8007dc:	c9                   	leave  
  8007dd:	c3                   	ret    

008007de <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8007de:	55                   	push   %ebp
  8007df:	89 e5                	mov    %esp,%ebp
  8007e1:	53                   	push   %ebx
  8007e2:	83 ec 14             	sub    $0x14,%esp
  8007e5:	8b 45 10             	mov    0x10(%ebp),%eax
  8007e8:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8007eb:	8b 45 14             	mov    0x14(%ebp),%eax
  8007ee:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8007f1:	8b 45 18             	mov    0x18(%ebp),%eax
  8007f4:	ba 00 00 00 00       	mov    $0x0,%edx
  8007f9:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8007fc:	77 55                	ja     800853 <printnum+0x75>
  8007fe:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800801:	72 05                	jb     800808 <printnum+0x2a>
  800803:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800806:	77 4b                	ja     800853 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800808:	8b 45 1c             	mov    0x1c(%ebp),%eax
  80080b:	8d 58 ff             	lea    -0x1(%eax),%ebx
  80080e:	8b 45 18             	mov    0x18(%ebp),%eax
  800811:	ba 00 00 00 00       	mov    $0x0,%edx
  800816:	52                   	push   %edx
  800817:	50                   	push   %eax
  800818:	ff 75 f4             	pushl  -0xc(%ebp)
  80081b:	ff 75 f0             	pushl  -0x10(%ebp)
  80081e:	e8 ad 16 00 00       	call   801ed0 <__udivdi3>
  800823:	83 c4 10             	add    $0x10,%esp
  800826:	83 ec 04             	sub    $0x4,%esp
  800829:	ff 75 20             	pushl  0x20(%ebp)
  80082c:	53                   	push   %ebx
  80082d:	ff 75 18             	pushl  0x18(%ebp)
  800830:	52                   	push   %edx
  800831:	50                   	push   %eax
  800832:	ff 75 0c             	pushl  0xc(%ebp)
  800835:	ff 75 08             	pushl  0x8(%ebp)
  800838:	e8 a1 ff ff ff       	call   8007de <printnum>
  80083d:	83 c4 20             	add    $0x20,%esp
  800840:	eb 1a                	jmp    80085c <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800842:	83 ec 08             	sub    $0x8,%esp
  800845:	ff 75 0c             	pushl  0xc(%ebp)
  800848:	ff 75 20             	pushl  0x20(%ebp)
  80084b:	8b 45 08             	mov    0x8(%ebp),%eax
  80084e:	ff d0                	call   *%eax
  800850:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800853:	ff 4d 1c             	decl   0x1c(%ebp)
  800856:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  80085a:	7f e6                	jg     800842 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80085c:	8b 4d 18             	mov    0x18(%ebp),%ecx
  80085f:	bb 00 00 00 00       	mov    $0x0,%ebx
  800864:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800867:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80086a:	53                   	push   %ebx
  80086b:	51                   	push   %ecx
  80086c:	52                   	push   %edx
  80086d:	50                   	push   %eax
  80086e:	e8 6d 17 00 00       	call   801fe0 <__umoddi3>
  800873:	83 c4 10             	add    $0x10,%esp
  800876:	05 94 28 80 00       	add    $0x802894,%eax
  80087b:	8a 00                	mov    (%eax),%al
  80087d:	0f be c0             	movsbl %al,%eax
  800880:	83 ec 08             	sub    $0x8,%esp
  800883:	ff 75 0c             	pushl  0xc(%ebp)
  800886:	50                   	push   %eax
  800887:	8b 45 08             	mov    0x8(%ebp),%eax
  80088a:	ff d0                	call   *%eax
  80088c:	83 c4 10             	add    $0x10,%esp
}
  80088f:	90                   	nop
  800890:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800893:	c9                   	leave  
  800894:	c3                   	ret    

00800895 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800895:	55                   	push   %ebp
  800896:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800898:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  80089c:	7e 1c                	jle    8008ba <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  80089e:	8b 45 08             	mov    0x8(%ebp),%eax
  8008a1:	8b 00                	mov    (%eax),%eax
  8008a3:	8d 50 08             	lea    0x8(%eax),%edx
  8008a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8008a9:	89 10                	mov    %edx,(%eax)
  8008ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8008ae:	8b 00                	mov    (%eax),%eax
  8008b0:	83 e8 08             	sub    $0x8,%eax
  8008b3:	8b 50 04             	mov    0x4(%eax),%edx
  8008b6:	8b 00                	mov    (%eax),%eax
  8008b8:	eb 40                	jmp    8008fa <getuint+0x65>
	else if (lflag)
  8008ba:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8008be:	74 1e                	je     8008de <getuint+0x49>
		return va_arg(*ap, unsigned long);
  8008c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8008c3:	8b 00                	mov    (%eax),%eax
  8008c5:	8d 50 04             	lea    0x4(%eax),%edx
  8008c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8008cb:	89 10                	mov    %edx,(%eax)
  8008cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8008d0:	8b 00                	mov    (%eax),%eax
  8008d2:	83 e8 04             	sub    $0x4,%eax
  8008d5:	8b 00                	mov    (%eax),%eax
  8008d7:	ba 00 00 00 00       	mov    $0x0,%edx
  8008dc:	eb 1c                	jmp    8008fa <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  8008de:	8b 45 08             	mov    0x8(%ebp),%eax
  8008e1:	8b 00                	mov    (%eax),%eax
  8008e3:	8d 50 04             	lea    0x4(%eax),%edx
  8008e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8008e9:	89 10                	mov    %edx,(%eax)
  8008eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8008ee:	8b 00                	mov    (%eax),%eax
  8008f0:	83 e8 04             	sub    $0x4,%eax
  8008f3:	8b 00                	mov    (%eax),%eax
  8008f5:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8008fa:	5d                   	pop    %ebp
  8008fb:	c3                   	ret    

008008fc <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8008fc:	55                   	push   %ebp
  8008fd:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8008ff:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800903:	7e 1c                	jle    800921 <getint+0x25>
		return va_arg(*ap, long long);
  800905:	8b 45 08             	mov    0x8(%ebp),%eax
  800908:	8b 00                	mov    (%eax),%eax
  80090a:	8d 50 08             	lea    0x8(%eax),%edx
  80090d:	8b 45 08             	mov    0x8(%ebp),%eax
  800910:	89 10                	mov    %edx,(%eax)
  800912:	8b 45 08             	mov    0x8(%ebp),%eax
  800915:	8b 00                	mov    (%eax),%eax
  800917:	83 e8 08             	sub    $0x8,%eax
  80091a:	8b 50 04             	mov    0x4(%eax),%edx
  80091d:	8b 00                	mov    (%eax),%eax
  80091f:	eb 38                	jmp    800959 <getint+0x5d>
	else if (lflag)
  800921:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800925:	74 1a                	je     800941 <getint+0x45>
		return va_arg(*ap, long);
  800927:	8b 45 08             	mov    0x8(%ebp),%eax
  80092a:	8b 00                	mov    (%eax),%eax
  80092c:	8d 50 04             	lea    0x4(%eax),%edx
  80092f:	8b 45 08             	mov    0x8(%ebp),%eax
  800932:	89 10                	mov    %edx,(%eax)
  800934:	8b 45 08             	mov    0x8(%ebp),%eax
  800937:	8b 00                	mov    (%eax),%eax
  800939:	83 e8 04             	sub    $0x4,%eax
  80093c:	8b 00                	mov    (%eax),%eax
  80093e:	99                   	cltd   
  80093f:	eb 18                	jmp    800959 <getint+0x5d>
	else
		return va_arg(*ap, int);
  800941:	8b 45 08             	mov    0x8(%ebp),%eax
  800944:	8b 00                	mov    (%eax),%eax
  800946:	8d 50 04             	lea    0x4(%eax),%edx
  800949:	8b 45 08             	mov    0x8(%ebp),%eax
  80094c:	89 10                	mov    %edx,(%eax)
  80094e:	8b 45 08             	mov    0x8(%ebp),%eax
  800951:	8b 00                	mov    (%eax),%eax
  800953:	83 e8 04             	sub    $0x4,%eax
  800956:	8b 00                	mov    (%eax),%eax
  800958:	99                   	cltd   
}
  800959:	5d                   	pop    %ebp
  80095a:	c3                   	ret    

0080095b <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  80095b:	55                   	push   %ebp
  80095c:	89 e5                	mov    %esp,%ebp
  80095e:	56                   	push   %esi
  80095f:	53                   	push   %ebx
  800960:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800963:	eb 17                	jmp    80097c <vprintfmt+0x21>
			if (ch == '\0')
  800965:	85 db                	test   %ebx,%ebx
  800967:	0f 84 c1 03 00 00    	je     800d2e <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  80096d:	83 ec 08             	sub    $0x8,%esp
  800970:	ff 75 0c             	pushl  0xc(%ebp)
  800973:	53                   	push   %ebx
  800974:	8b 45 08             	mov    0x8(%ebp),%eax
  800977:	ff d0                	call   *%eax
  800979:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80097c:	8b 45 10             	mov    0x10(%ebp),%eax
  80097f:	8d 50 01             	lea    0x1(%eax),%edx
  800982:	89 55 10             	mov    %edx,0x10(%ebp)
  800985:	8a 00                	mov    (%eax),%al
  800987:	0f b6 d8             	movzbl %al,%ebx
  80098a:	83 fb 25             	cmp    $0x25,%ebx
  80098d:	75 d6                	jne    800965 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  80098f:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800993:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  80099a:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8009a1:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  8009a8:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8009af:	8b 45 10             	mov    0x10(%ebp),%eax
  8009b2:	8d 50 01             	lea    0x1(%eax),%edx
  8009b5:	89 55 10             	mov    %edx,0x10(%ebp)
  8009b8:	8a 00                	mov    (%eax),%al
  8009ba:	0f b6 d8             	movzbl %al,%ebx
  8009bd:	8d 43 dd             	lea    -0x23(%ebx),%eax
  8009c0:	83 f8 5b             	cmp    $0x5b,%eax
  8009c3:	0f 87 3d 03 00 00    	ja     800d06 <vprintfmt+0x3ab>
  8009c9:	8b 04 85 b8 28 80 00 	mov    0x8028b8(,%eax,4),%eax
  8009d0:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  8009d2:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  8009d6:	eb d7                	jmp    8009af <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8009d8:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  8009dc:	eb d1                	jmp    8009af <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8009de:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  8009e5:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8009e8:	89 d0                	mov    %edx,%eax
  8009ea:	c1 e0 02             	shl    $0x2,%eax
  8009ed:	01 d0                	add    %edx,%eax
  8009ef:	01 c0                	add    %eax,%eax
  8009f1:	01 d8                	add    %ebx,%eax
  8009f3:	83 e8 30             	sub    $0x30,%eax
  8009f6:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  8009f9:	8b 45 10             	mov    0x10(%ebp),%eax
  8009fc:	8a 00                	mov    (%eax),%al
  8009fe:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800a01:	83 fb 2f             	cmp    $0x2f,%ebx
  800a04:	7e 3e                	jle    800a44 <vprintfmt+0xe9>
  800a06:	83 fb 39             	cmp    $0x39,%ebx
  800a09:	7f 39                	jg     800a44 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800a0b:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800a0e:	eb d5                	jmp    8009e5 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800a10:	8b 45 14             	mov    0x14(%ebp),%eax
  800a13:	83 c0 04             	add    $0x4,%eax
  800a16:	89 45 14             	mov    %eax,0x14(%ebp)
  800a19:	8b 45 14             	mov    0x14(%ebp),%eax
  800a1c:	83 e8 04             	sub    $0x4,%eax
  800a1f:	8b 00                	mov    (%eax),%eax
  800a21:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800a24:	eb 1f                	jmp    800a45 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800a26:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a2a:	79 83                	jns    8009af <vprintfmt+0x54>
				width = 0;
  800a2c:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800a33:	e9 77 ff ff ff       	jmp    8009af <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800a38:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800a3f:	e9 6b ff ff ff       	jmp    8009af <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800a44:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800a45:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a49:	0f 89 60 ff ff ff    	jns    8009af <vprintfmt+0x54>
				width = precision, precision = -1;
  800a4f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800a52:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800a55:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800a5c:	e9 4e ff ff ff       	jmp    8009af <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800a61:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800a64:	e9 46 ff ff ff       	jmp    8009af <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800a69:	8b 45 14             	mov    0x14(%ebp),%eax
  800a6c:	83 c0 04             	add    $0x4,%eax
  800a6f:	89 45 14             	mov    %eax,0x14(%ebp)
  800a72:	8b 45 14             	mov    0x14(%ebp),%eax
  800a75:	83 e8 04             	sub    $0x4,%eax
  800a78:	8b 00                	mov    (%eax),%eax
  800a7a:	83 ec 08             	sub    $0x8,%esp
  800a7d:	ff 75 0c             	pushl  0xc(%ebp)
  800a80:	50                   	push   %eax
  800a81:	8b 45 08             	mov    0x8(%ebp),%eax
  800a84:	ff d0                	call   *%eax
  800a86:	83 c4 10             	add    $0x10,%esp
			break;
  800a89:	e9 9b 02 00 00       	jmp    800d29 <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800a8e:	8b 45 14             	mov    0x14(%ebp),%eax
  800a91:	83 c0 04             	add    $0x4,%eax
  800a94:	89 45 14             	mov    %eax,0x14(%ebp)
  800a97:	8b 45 14             	mov    0x14(%ebp),%eax
  800a9a:	83 e8 04             	sub    $0x4,%eax
  800a9d:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800a9f:	85 db                	test   %ebx,%ebx
  800aa1:	79 02                	jns    800aa5 <vprintfmt+0x14a>
				err = -err;
  800aa3:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800aa5:	83 fb 64             	cmp    $0x64,%ebx
  800aa8:	7f 0b                	jg     800ab5 <vprintfmt+0x15a>
  800aaa:	8b 34 9d 00 27 80 00 	mov    0x802700(,%ebx,4),%esi
  800ab1:	85 f6                	test   %esi,%esi
  800ab3:	75 19                	jne    800ace <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800ab5:	53                   	push   %ebx
  800ab6:	68 a5 28 80 00       	push   $0x8028a5
  800abb:	ff 75 0c             	pushl  0xc(%ebp)
  800abe:	ff 75 08             	pushl  0x8(%ebp)
  800ac1:	e8 70 02 00 00       	call   800d36 <printfmt>
  800ac6:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800ac9:	e9 5b 02 00 00       	jmp    800d29 <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800ace:	56                   	push   %esi
  800acf:	68 ae 28 80 00       	push   $0x8028ae
  800ad4:	ff 75 0c             	pushl  0xc(%ebp)
  800ad7:	ff 75 08             	pushl  0x8(%ebp)
  800ada:	e8 57 02 00 00       	call   800d36 <printfmt>
  800adf:	83 c4 10             	add    $0x10,%esp
			break;
  800ae2:	e9 42 02 00 00       	jmp    800d29 <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800ae7:	8b 45 14             	mov    0x14(%ebp),%eax
  800aea:	83 c0 04             	add    $0x4,%eax
  800aed:	89 45 14             	mov    %eax,0x14(%ebp)
  800af0:	8b 45 14             	mov    0x14(%ebp),%eax
  800af3:	83 e8 04             	sub    $0x4,%eax
  800af6:	8b 30                	mov    (%eax),%esi
  800af8:	85 f6                	test   %esi,%esi
  800afa:	75 05                	jne    800b01 <vprintfmt+0x1a6>
				p = "(null)";
  800afc:	be b1 28 80 00       	mov    $0x8028b1,%esi
			if (width > 0 && padc != '-')
  800b01:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800b05:	7e 6d                	jle    800b74 <vprintfmt+0x219>
  800b07:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800b0b:	74 67                	je     800b74 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800b0d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800b10:	83 ec 08             	sub    $0x8,%esp
  800b13:	50                   	push   %eax
  800b14:	56                   	push   %esi
  800b15:	e8 26 05 00 00       	call   801040 <strnlen>
  800b1a:	83 c4 10             	add    $0x10,%esp
  800b1d:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800b20:	eb 16                	jmp    800b38 <vprintfmt+0x1dd>
					putch(padc, putdat);
  800b22:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800b26:	83 ec 08             	sub    $0x8,%esp
  800b29:	ff 75 0c             	pushl  0xc(%ebp)
  800b2c:	50                   	push   %eax
  800b2d:	8b 45 08             	mov    0x8(%ebp),%eax
  800b30:	ff d0                	call   *%eax
  800b32:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800b35:	ff 4d e4             	decl   -0x1c(%ebp)
  800b38:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800b3c:	7f e4                	jg     800b22 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800b3e:	eb 34                	jmp    800b74 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800b40:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800b44:	74 1c                	je     800b62 <vprintfmt+0x207>
  800b46:	83 fb 1f             	cmp    $0x1f,%ebx
  800b49:	7e 05                	jle    800b50 <vprintfmt+0x1f5>
  800b4b:	83 fb 7e             	cmp    $0x7e,%ebx
  800b4e:	7e 12                	jle    800b62 <vprintfmt+0x207>
					putch('?', putdat);
  800b50:	83 ec 08             	sub    $0x8,%esp
  800b53:	ff 75 0c             	pushl  0xc(%ebp)
  800b56:	6a 3f                	push   $0x3f
  800b58:	8b 45 08             	mov    0x8(%ebp),%eax
  800b5b:	ff d0                	call   *%eax
  800b5d:	83 c4 10             	add    $0x10,%esp
  800b60:	eb 0f                	jmp    800b71 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800b62:	83 ec 08             	sub    $0x8,%esp
  800b65:	ff 75 0c             	pushl  0xc(%ebp)
  800b68:	53                   	push   %ebx
  800b69:	8b 45 08             	mov    0x8(%ebp),%eax
  800b6c:	ff d0                	call   *%eax
  800b6e:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800b71:	ff 4d e4             	decl   -0x1c(%ebp)
  800b74:	89 f0                	mov    %esi,%eax
  800b76:	8d 70 01             	lea    0x1(%eax),%esi
  800b79:	8a 00                	mov    (%eax),%al
  800b7b:	0f be d8             	movsbl %al,%ebx
  800b7e:	85 db                	test   %ebx,%ebx
  800b80:	74 24                	je     800ba6 <vprintfmt+0x24b>
  800b82:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800b86:	78 b8                	js     800b40 <vprintfmt+0x1e5>
  800b88:	ff 4d e0             	decl   -0x20(%ebp)
  800b8b:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800b8f:	79 af                	jns    800b40 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800b91:	eb 13                	jmp    800ba6 <vprintfmt+0x24b>
				putch(' ', putdat);
  800b93:	83 ec 08             	sub    $0x8,%esp
  800b96:	ff 75 0c             	pushl  0xc(%ebp)
  800b99:	6a 20                	push   $0x20
  800b9b:	8b 45 08             	mov    0x8(%ebp),%eax
  800b9e:	ff d0                	call   *%eax
  800ba0:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800ba3:	ff 4d e4             	decl   -0x1c(%ebp)
  800ba6:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800baa:	7f e7                	jg     800b93 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800bac:	e9 78 01 00 00       	jmp    800d29 <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800bb1:	83 ec 08             	sub    $0x8,%esp
  800bb4:	ff 75 e8             	pushl  -0x18(%ebp)
  800bb7:	8d 45 14             	lea    0x14(%ebp),%eax
  800bba:	50                   	push   %eax
  800bbb:	e8 3c fd ff ff       	call   8008fc <getint>
  800bc0:	83 c4 10             	add    $0x10,%esp
  800bc3:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800bc6:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800bc9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800bcc:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800bcf:	85 d2                	test   %edx,%edx
  800bd1:	79 23                	jns    800bf6 <vprintfmt+0x29b>
				putch('-', putdat);
  800bd3:	83 ec 08             	sub    $0x8,%esp
  800bd6:	ff 75 0c             	pushl  0xc(%ebp)
  800bd9:	6a 2d                	push   $0x2d
  800bdb:	8b 45 08             	mov    0x8(%ebp),%eax
  800bde:	ff d0                	call   *%eax
  800be0:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800be3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800be6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800be9:	f7 d8                	neg    %eax
  800beb:	83 d2 00             	adc    $0x0,%edx
  800bee:	f7 da                	neg    %edx
  800bf0:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800bf3:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800bf6:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800bfd:	e9 bc 00 00 00       	jmp    800cbe <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800c02:	83 ec 08             	sub    $0x8,%esp
  800c05:	ff 75 e8             	pushl  -0x18(%ebp)
  800c08:	8d 45 14             	lea    0x14(%ebp),%eax
  800c0b:	50                   	push   %eax
  800c0c:	e8 84 fc ff ff       	call   800895 <getuint>
  800c11:	83 c4 10             	add    $0x10,%esp
  800c14:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c17:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800c1a:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800c21:	e9 98 00 00 00       	jmp    800cbe <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800c26:	83 ec 08             	sub    $0x8,%esp
  800c29:	ff 75 0c             	pushl  0xc(%ebp)
  800c2c:	6a 58                	push   $0x58
  800c2e:	8b 45 08             	mov    0x8(%ebp),%eax
  800c31:	ff d0                	call   *%eax
  800c33:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800c36:	83 ec 08             	sub    $0x8,%esp
  800c39:	ff 75 0c             	pushl  0xc(%ebp)
  800c3c:	6a 58                	push   $0x58
  800c3e:	8b 45 08             	mov    0x8(%ebp),%eax
  800c41:	ff d0                	call   *%eax
  800c43:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800c46:	83 ec 08             	sub    $0x8,%esp
  800c49:	ff 75 0c             	pushl  0xc(%ebp)
  800c4c:	6a 58                	push   $0x58
  800c4e:	8b 45 08             	mov    0x8(%ebp),%eax
  800c51:	ff d0                	call   *%eax
  800c53:	83 c4 10             	add    $0x10,%esp
			break;
  800c56:	e9 ce 00 00 00       	jmp    800d29 <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  800c5b:	83 ec 08             	sub    $0x8,%esp
  800c5e:	ff 75 0c             	pushl  0xc(%ebp)
  800c61:	6a 30                	push   $0x30
  800c63:	8b 45 08             	mov    0x8(%ebp),%eax
  800c66:	ff d0                	call   *%eax
  800c68:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800c6b:	83 ec 08             	sub    $0x8,%esp
  800c6e:	ff 75 0c             	pushl  0xc(%ebp)
  800c71:	6a 78                	push   $0x78
  800c73:	8b 45 08             	mov    0x8(%ebp),%eax
  800c76:	ff d0                	call   *%eax
  800c78:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800c7b:	8b 45 14             	mov    0x14(%ebp),%eax
  800c7e:	83 c0 04             	add    $0x4,%eax
  800c81:	89 45 14             	mov    %eax,0x14(%ebp)
  800c84:	8b 45 14             	mov    0x14(%ebp),%eax
  800c87:	83 e8 04             	sub    $0x4,%eax
  800c8a:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800c8c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c8f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800c96:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800c9d:	eb 1f                	jmp    800cbe <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800c9f:	83 ec 08             	sub    $0x8,%esp
  800ca2:	ff 75 e8             	pushl  -0x18(%ebp)
  800ca5:	8d 45 14             	lea    0x14(%ebp),%eax
  800ca8:	50                   	push   %eax
  800ca9:	e8 e7 fb ff ff       	call   800895 <getuint>
  800cae:	83 c4 10             	add    $0x10,%esp
  800cb1:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800cb4:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800cb7:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800cbe:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800cc2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800cc5:	83 ec 04             	sub    $0x4,%esp
  800cc8:	52                   	push   %edx
  800cc9:	ff 75 e4             	pushl  -0x1c(%ebp)
  800ccc:	50                   	push   %eax
  800ccd:	ff 75 f4             	pushl  -0xc(%ebp)
  800cd0:	ff 75 f0             	pushl  -0x10(%ebp)
  800cd3:	ff 75 0c             	pushl  0xc(%ebp)
  800cd6:	ff 75 08             	pushl  0x8(%ebp)
  800cd9:	e8 00 fb ff ff       	call   8007de <printnum>
  800cde:	83 c4 20             	add    $0x20,%esp
			break;
  800ce1:	eb 46                	jmp    800d29 <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800ce3:	83 ec 08             	sub    $0x8,%esp
  800ce6:	ff 75 0c             	pushl  0xc(%ebp)
  800ce9:	53                   	push   %ebx
  800cea:	8b 45 08             	mov    0x8(%ebp),%eax
  800ced:	ff d0                	call   *%eax
  800cef:	83 c4 10             	add    $0x10,%esp
			break;
  800cf2:	eb 35                	jmp    800d29 <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  800cf4:	c6 05 44 30 80 00 00 	movb   $0x0,0x803044
			break;
  800cfb:	eb 2c                	jmp    800d29 <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  800cfd:	c6 05 44 30 80 00 01 	movb   $0x1,0x803044
			break;
  800d04:	eb 23                	jmp    800d29 <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800d06:	83 ec 08             	sub    $0x8,%esp
  800d09:	ff 75 0c             	pushl  0xc(%ebp)
  800d0c:	6a 25                	push   $0x25
  800d0e:	8b 45 08             	mov    0x8(%ebp),%eax
  800d11:	ff d0                	call   *%eax
  800d13:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800d16:	ff 4d 10             	decl   0x10(%ebp)
  800d19:	eb 03                	jmp    800d1e <vprintfmt+0x3c3>
  800d1b:	ff 4d 10             	decl   0x10(%ebp)
  800d1e:	8b 45 10             	mov    0x10(%ebp),%eax
  800d21:	48                   	dec    %eax
  800d22:	8a 00                	mov    (%eax),%al
  800d24:	3c 25                	cmp    $0x25,%al
  800d26:	75 f3                	jne    800d1b <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  800d28:	90                   	nop
		}
	}
  800d29:	e9 35 fc ff ff       	jmp    800963 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800d2e:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800d2f:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800d32:	5b                   	pop    %ebx
  800d33:	5e                   	pop    %esi
  800d34:	5d                   	pop    %ebp
  800d35:	c3                   	ret    

00800d36 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800d36:	55                   	push   %ebp
  800d37:	89 e5                	mov    %esp,%ebp
  800d39:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800d3c:	8d 45 10             	lea    0x10(%ebp),%eax
  800d3f:	83 c0 04             	add    $0x4,%eax
  800d42:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800d45:	8b 45 10             	mov    0x10(%ebp),%eax
  800d48:	ff 75 f4             	pushl  -0xc(%ebp)
  800d4b:	50                   	push   %eax
  800d4c:	ff 75 0c             	pushl  0xc(%ebp)
  800d4f:	ff 75 08             	pushl  0x8(%ebp)
  800d52:	e8 04 fc ff ff       	call   80095b <vprintfmt>
  800d57:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800d5a:	90                   	nop
  800d5b:	c9                   	leave  
  800d5c:	c3                   	ret    

00800d5d <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800d5d:	55                   	push   %ebp
  800d5e:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800d60:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d63:	8b 40 08             	mov    0x8(%eax),%eax
  800d66:	8d 50 01             	lea    0x1(%eax),%edx
  800d69:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d6c:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800d6f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d72:	8b 10                	mov    (%eax),%edx
  800d74:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d77:	8b 40 04             	mov    0x4(%eax),%eax
  800d7a:	39 c2                	cmp    %eax,%edx
  800d7c:	73 12                	jae    800d90 <sprintputch+0x33>
		*b->buf++ = ch;
  800d7e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d81:	8b 00                	mov    (%eax),%eax
  800d83:	8d 48 01             	lea    0x1(%eax),%ecx
  800d86:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d89:	89 0a                	mov    %ecx,(%edx)
  800d8b:	8b 55 08             	mov    0x8(%ebp),%edx
  800d8e:	88 10                	mov    %dl,(%eax)
}
  800d90:	90                   	nop
  800d91:	5d                   	pop    %ebp
  800d92:	c3                   	ret    

00800d93 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800d93:	55                   	push   %ebp
  800d94:	89 e5                	mov    %esp,%ebp
  800d96:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800d99:	8b 45 08             	mov    0x8(%ebp),%eax
  800d9c:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800d9f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800da2:	8d 50 ff             	lea    -0x1(%eax),%edx
  800da5:	8b 45 08             	mov    0x8(%ebp),%eax
  800da8:	01 d0                	add    %edx,%eax
  800daa:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800dad:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800db4:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800db8:	74 06                	je     800dc0 <vsnprintf+0x2d>
  800dba:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800dbe:	7f 07                	jg     800dc7 <vsnprintf+0x34>
		return -E_INVAL;
  800dc0:	b8 03 00 00 00       	mov    $0x3,%eax
  800dc5:	eb 20                	jmp    800de7 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800dc7:	ff 75 14             	pushl  0x14(%ebp)
  800dca:	ff 75 10             	pushl  0x10(%ebp)
  800dcd:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800dd0:	50                   	push   %eax
  800dd1:	68 5d 0d 80 00       	push   $0x800d5d
  800dd6:	e8 80 fb ff ff       	call   80095b <vprintfmt>
  800ddb:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800dde:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800de1:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800de4:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800de7:	c9                   	leave  
  800de8:	c3                   	ret    

00800de9 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800de9:	55                   	push   %ebp
  800dea:	89 e5                	mov    %esp,%ebp
  800dec:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800def:	8d 45 10             	lea    0x10(%ebp),%eax
  800df2:	83 c0 04             	add    $0x4,%eax
  800df5:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800df8:	8b 45 10             	mov    0x10(%ebp),%eax
  800dfb:	ff 75 f4             	pushl  -0xc(%ebp)
  800dfe:	50                   	push   %eax
  800dff:	ff 75 0c             	pushl  0xc(%ebp)
  800e02:	ff 75 08             	pushl  0x8(%ebp)
  800e05:	e8 89 ff ff ff       	call   800d93 <vsnprintf>
  800e0a:	83 c4 10             	add    $0x10,%esp
  800e0d:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800e10:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800e13:	c9                   	leave  
  800e14:	c3                   	ret    

00800e15 <readline>:
#include <inc/lib.h>

//static char buf[BUFLEN];

void readline(const char *prompt, char* buf)
{
  800e15:	55                   	push   %ebp
  800e16:	89 e5                	mov    %esp,%ebp
  800e18:	83 ec 18             	sub    $0x18,%esp
	int i, c, echoing;

	if (prompt != NULL)
  800e1b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800e1f:	74 13                	je     800e34 <readline+0x1f>
		cprintf("%s", prompt);
  800e21:	83 ec 08             	sub    $0x8,%esp
  800e24:	ff 75 08             	pushl  0x8(%ebp)
  800e27:	68 28 2a 80 00       	push   $0x802a28
  800e2c:	e8 0b f9 ff ff       	call   80073c <cprintf>
  800e31:	83 c4 10             	add    $0x10,%esp

	i = 0;
  800e34:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	echoing = iscons(0);
  800e3b:	83 ec 0c             	sub    $0xc,%esp
  800e3e:	6a 00                	push   $0x0
  800e40:	e8 7e 10 00 00       	call   801ec3 <iscons>
  800e45:	83 c4 10             	add    $0x10,%esp
  800e48:	89 45 f0             	mov    %eax,-0x10(%ebp)
	while (1) {
		c = getchar();
  800e4b:	e8 60 10 00 00       	call   801eb0 <getchar>
  800e50:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if (c < 0) {
  800e53:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800e57:	79 22                	jns    800e7b <readline+0x66>
			if (c != -E_EOF)
  800e59:	83 7d ec 07          	cmpl   $0x7,-0x14(%ebp)
  800e5d:	0f 84 ad 00 00 00    	je     800f10 <readline+0xfb>
				cprintf("read error: %e\n", c);
  800e63:	83 ec 08             	sub    $0x8,%esp
  800e66:	ff 75 ec             	pushl  -0x14(%ebp)
  800e69:	68 2b 2a 80 00       	push   $0x802a2b
  800e6e:	e8 c9 f8 ff ff       	call   80073c <cprintf>
  800e73:	83 c4 10             	add    $0x10,%esp
			break;
  800e76:	e9 95 00 00 00       	jmp    800f10 <readline+0xfb>
		} else if (c >= ' ' && i < BUFLEN-1) {
  800e7b:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%ebp)
  800e7f:	7e 34                	jle    800eb5 <readline+0xa0>
  800e81:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  800e88:	7f 2b                	jg     800eb5 <readline+0xa0>
			if (echoing)
  800e8a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800e8e:	74 0e                	je     800e9e <readline+0x89>
				cputchar(c);
  800e90:	83 ec 0c             	sub    $0xc,%esp
  800e93:	ff 75 ec             	pushl  -0x14(%ebp)
  800e96:	e8 f6 0f 00 00       	call   801e91 <cputchar>
  800e9b:	83 c4 10             	add    $0x10,%esp
			buf[i++] = c;
  800e9e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800ea1:	8d 50 01             	lea    0x1(%eax),%edx
  800ea4:	89 55 f4             	mov    %edx,-0xc(%ebp)
  800ea7:	89 c2                	mov    %eax,%edx
  800ea9:	8b 45 0c             	mov    0xc(%ebp),%eax
  800eac:	01 d0                	add    %edx,%eax
  800eae:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800eb1:	88 10                	mov    %dl,(%eax)
  800eb3:	eb 56                	jmp    800f0b <readline+0xf6>
		} else if (c == '\b' && i > 0) {
  800eb5:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  800eb9:	75 1f                	jne    800eda <readline+0xc5>
  800ebb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  800ebf:	7e 19                	jle    800eda <readline+0xc5>
			if (echoing)
  800ec1:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800ec5:	74 0e                	je     800ed5 <readline+0xc0>
				cputchar(c);
  800ec7:	83 ec 0c             	sub    $0xc,%esp
  800eca:	ff 75 ec             	pushl  -0x14(%ebp)
  800ecd:	e8 bf 0f 00 00       	call   801e91 <cputchar>
  800ed2:	83 c4 10             	add    $0x10,%esp

			i--;
  800ed5:	ff 4d f4             	decl   -0xc(%ebp)
  800ed8:	eb 31                	jmp    800f0b <readline+0xf6>
		} else if (c == '\n' || c == '\r') {
  800eda:	83 7d ec 0a          	cmpl   $0xa,-0x14(%ebp)
  800ede:	74 0a                	je     800eea <readline+0xd5>
  800ee0:	83 7d ec 0d          	cmpl   $0xd,-0x14(%ebp)
  800ee4:	0f 85 61 ff ff ff    	jne    800e4b <readline+0x36>
			if (echoing)
  800eea:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800eee:	74 0e                	je     800efe <readline+0xe9>
				cputchar(c);
  800ef0:	83 ec 0c             	sub    $0xc,%esp
  800ef3:	ff 75 ec             	pushl  -0x14(%ebp)
  800ef6:	e8 96 0f 00 00       	call   801e91 <cputchar>
  800efb:	83 c4 10             	add    $0x10,%esp

			buf[i] = 0;
  800efe:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800f01:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f04:	01 d0                	add    %edx,%eax
  800f06:	c6 00 00             	movb   $0x0,(%eax)
			break;
  800f09:	eb 06                	jmp    800f11 <readline+0xfc>
		}
	}
  800f0b:	e9 3b ff ff ff       	jmp    800e4b <readline+0x36>
	while (1) {
		c = getchar();
		if (c < 0) {
			if (c != -E_EOF)
				cprintf("read error: %e\n", c);
			break;
  800f10:	90                   	nop

			buf[i] = 0;
			break;
		}
	}
}
  800f11:	90                   	nop
  800f12:	c9                   	leave  
  800f13:	c3                   	ret    

00800f14 <atomic_readline>:

void atomic_readline(const char *prompt, char* buf)
{
  800f14:	55                   	push   %ebp
  800f15:	89 e5                	mov    %esp,%ebp
  800f17:	83 ec 18             	sub    $0x18,%esp
	sys_lock_cons();
  800f1a:	e8 79 09 00 00       	call   801898 <sys_lock_cons>
	{
		int i, c, echoing;

		if (prompt != NULL)
  800f1f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800f23:	74 13                	je     800f38 <atomic_readline+0x24>
			cprintf("%s", prompt);
  800f25:	83 ec 08             	sub    $0x8,%esp
  800f28:	ff 75 08             	pushl  0x8(%ebp)
  800f2b:	68 28 2a 80 00       	push   $0x802a28
  800f30:	e8 07 f8 ff ff       	call   80073c <cprintf>
  800f35:	83 c4 10             	add    $0x10,%esp

		i = 0;
  800f38:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
		echoing = iscons(0);
  800f3f:	83 ec 0c             	sub    $0xc,%esp
  800f42:	6a 00                	push   $0x0
  800f44:	e8 7a 0f 00 00       	call   801ec3 <iscons>
  800f49:	83 c4 10             	add    $0x10,%esp
  800f4c:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (1) {
			c = getchar();
  800f4f:	e8 5c 0f 00 00       	call   801eb0 <getchar>
  800f54:	89 45 ec             	mov    %eax,-0x14(%ebp)
			if (c < 0) {
  800f57:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800f5b:	79 22                	jns    800f7f <atomic_readline+0x6b>
				if (c != -E_EOF)
  800f5d:	83 7d ec 07          	cmpl   $0x7,-0x14(%ebp)
  800f61:	0f 84 ad 00 00 00    	je     801014 <atomic_readline+0x100>
					cprintf("read error: %e\n", c);
  800f67:	83 ec 08             	sub    $0x8,%esp
  800f6a:	ff 75 ec             	pushl  -0x14(%ebp)
  800f6d:	68 2b 2a 80 00       	push   $0x802a2b
  800f72:	e8 c5 f7 ff ff       	call   80073c <cprintf>
  800f77:	83 c4 10             	add    $0x10,%esp
				break;
  800f7a:	e9 95 00 00 00       	jmp    801014 <atomic_readline+0x100>
			} else if (c >= ' ' && i < BUFLEN-1) {
  800f7f:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%ebp)
  800f83:	7e 34                	jle    800fb9 <atomic_readline+0xa5>
  800f85:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  800f8c:	7f 2b                	jg     800fb9 <atomic_readline+0xa5>
				if (echoing)
  800f8e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800f92:	74 0e                	je     800fa2 <atomic_readline+0x8e>
					cputchar(c);
  800f94:	83 ec 0c             	sub    $0xc,%esp
  800f97:	ff 75 ec             	pushl  -0x14(%ebp)
  800f9a:	e8 f2 0e 00 00       	call   801e91 <cputchar>
  800f9f:	83 c4 10             	add    $0x10,%esp
				buf[i++] = c;
  800fa2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800fa5:	8d 50 01             	lea    0x1(%eax),%edx
  800fa8:	89 55 f4             	mov    %edx,-0xc(%ebp)
  800fab:	89 c2                	mov    %eax,%edx
  800fad:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fb0:	01 d0                	add    %edx,%eax
  800fb2:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800fb5:	88 10                	mov    %dl,(%eax)
  800fb7:	eb 56                	jmp    80100f <atomic_readline+0xfb>
			} else if (c == '\b' && i > 0) {
  800fb9:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  800fbd:	75 1f                	jne    800fde <atomic_readline+0xca>
  800fbf:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  800fc3:	7e 19                	jle    800fde <atomic_readline+0xca>
				if (echoing)
  800fc5:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800fc9:	74 0e                	je     800fd9 <atomic_readline+0xc5>
					cputchar(c);
  800fcb:	83 ec 0c             	sub    $0xc,%esp
  800fce:	ff 75 ec             	pushl  -0x14(%ebp)
  800fd1:	e8 bb 0e 00 00       	call   801e91 <cputchar>
  800fd6:	83 c4 10             	add    $0x10,%esp
				i--;
  800fd9:	ff 4d f4             	decl   -0xc(%ebp)
  800fdc:	eb 31                	jmp    80100f <atomic_readline+0xfb>
			} else if (c == '\n' || c == '\r') {
  800fde:	83 7d ec 0a          	cmpl   $0xa,-0x14(%ebp)
  800fe2:	74 0a                	je     800fee <atomic_readline+0xda>
  800fe4:	83 7d ec 0d          	cmpl   $0xd,-0x14(%ebp)
  800fe8:	0f 85 61 ff ff ff    	jne    800f4f <atomic_readline+0x3b>
				if (echoing)
  800fee:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800ff2:	74 0e                	je     801002 <atomic_readline+0xee>
					cputchar(c);
  800ff4:	83 ec 0c             	sub    $0xc,%esp
  800ff7:	ff 75 ec             	pushl  -0x14(%ebp)
  800ffa:	e8 92 0e 00 00       	call   801e91 <cputchar>
  800fff:	83 c4 10             	add    $0x10,%esp
				buf[i] = 0;
  801002:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801005:	8b 45 0c             	mov    0xc(%ebp),%eax
  801008:	01 d0                	add    %edx,%eax
  80100a:	c6 00 00             	movb   $0x0,(%eax)
				break;
  80100d:	eb 06                	jmp    801015 <atomic_readline+0x101>
			}
		}
  80100f:	e9 3b ff ff ff       	jmp    800f4f <atomic_readline+0x3b>
		while (1) {
			c = getchar();
			if (c < 0) {
				if (c != -E_EOF)
					cprintf("read error: %e\n", c);
				break;
  801014:	90                   	nop
				buf[i] = 0;
				break;
			}
		}
	}
	sys_unlock_cons();
  801015:	e8 98 08 00 00       	call   8018b2 <sys_unlock_cons>
}
  80101a:	90                   	nop
  80101b:	c9                   	leave  
  80101c:	c3                   	ret    

0080101d <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  80101d:	55                   	push   %ebp
  80101e:	89 e5                	mov    %esp,%ebp
  801020:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  801023:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80102a:	eb 06                	jmp    801032 <strlen+0x15>
		n++;
  80102c:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  80102f:	ff 45 08             	incl   0x8(%ebp)
  801032:	8b 45 08             	mov    0x8(%ebp),%eax
  801035:	8a 00                	mov    (%eax),%al
  801037:	84 c0                	test   %al,%al
  801039:	75 f1                	jne    80102c <strlen+0xf>
		n++;
	return n;
  80103b:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  80103e:	c9                   	leave  
  80103f:	c3                   	ret    

00801040 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  801040:	55                   	push   %ebp
  801041:	89 e5                	mov    %esp,%ebp
  801043:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801046:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80104d:	eb 09                	jmp    801058 <strnlen+0x18>
		n++;
  80104f:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801052:	ff 45 08             	incl   0x8(%ebp)
  801055:	ff 4d 0c             	decl   0xc(%ebp)
  801058:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80105c:	74 09                	je     801067 <strnlen+0x27>
  80105e:	8b 45 08             	mov    0x8(%ebp),%eax
  801061:	8a 00                	mov    (%eax),%al
  801063:	84 c0                	test   %al,%al
  801065:	75 e8                	jne    80104f <strnlen+0xf>
		n++;
	return n;
  801067:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  80106a:	c9                   	leave  
  80106b:	c3                   	ret    

0080106c <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  80106c:	55                   	push   %ebp
  80106d:	89 e5                	mov    %esp,%ebp
  80106f:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  801072:	8b 45 08             	mov    0x8(%ebp),%eax
  801075:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  801078:	90                   	nop
  801079:	8b 45 08             	mov    0x8(%ebp),%eax
  80107c:	8d 50 01             	lea    0x1(%eax),%edx
  80107f:	89 55 08             	mov    %edx,0x8(%ebp)
  801082:	8b 55 0c             	mov    0xc(%ebp),%edx
  801085:	8d 4a 01             	lea    0x1(%edx),%ecx
  801088:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  80108b:	8a 12                	mov    (%edx),%dl
  80108d:	88 10                	mov    %dl,(%eax)
  80108f:	8a 00                	mov    (%eax),%al
  801091:	84 c0                	test   %al,%al
  801093:	75 e4                	jne    801079 <strcpy+0xd>
		/* do nothing */;
	return ret;
  801095:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801098:	c9                   	leave  
  801099:	c3                   	ret    

0080109a <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  80109a:	55                   	push   %ebp
  80109b:	89 e5                	mov    %esp,%ebp
  80109d:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  8010a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8010a3:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  8010a6:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8010ad:	eb 1f                	jmp    8010ce <strncpy+0x34>
		*dst++ = *src;
  8010af:	8b 45 08             	mov    0x8(%ebp),%eax
  8010b2:	8d 50 01             	lea    0x1(%eax),%edx
  8010b5:	89 55 08             	mov    %edx,0x8(%ebp)
  8010b8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8010bb:	8a 12                	mov    (%edx),%dl
  8010bd:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  8010bf:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010c2:	8a 00                	mov    (%eax),%al
  8010c4:	84 c0                	test   %al,%al
  8010c6:	74 03                	je     8010cb <strncpy+0x31>
			src++;
  8010c8:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8010cb:	ff 45 fc             	incl   -0x4(%ebp)
  8010ce:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8010d1:	3b 45 10             	cmp    0x10(%ebp),%eax
  8010d4:	72 d9                	jb     8010af <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  8010d6:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8010d9:	c9                   	leave  
  8010da:	c3                   	ret    

008010db <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  8010db:	55                   	push   %ebp
  8010dc:	89 e5                	mov    %esp,%ebp
  8010de:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  8010e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8010e4:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  8010e7:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8010eb:	74 30                	je     80111d <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  8010ed:	eb 16                	jmp    801105 <strlcpy+0x2a>
			*dst++ = *src++;
  8010ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8010f2:	8d 50 01             	lea    0x1(%eax),%edx
  8010f5:	89 55 08             	mov    %edx,0x8(%ebp)
  8010f8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8010fb:	8d 4a 01             	lea    0x1(%edx),%ecx
  8010fe:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  801101:	8a 12                	mov    (%edx),%dl
  801103:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  801105:	ff 4d 10             	decl   0x10(%ebp)
  801108:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80110c:	74 09                	je     801117 <strlcpy+0x3c>
  80110e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801111:	8a 00                	mov    (%eax),%al
  801113:	84 c0                	test   %al,%al
  801115:	75 d8                	jne    8010ef <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  801117:	8b 45 08             	mov    0x8(%ebp),%eax
  80111a:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  80111d:	8b 55 08             	mov    0x8(%ebp),%edx
  801120:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801123:	29 c2                	sub    %eax,%edx
  801125:	89 d0                	mov    %edx,%eax
}
  801127:	c9                   	leave  
  801128:	c3                   	ret    

00801129 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  801129:	55                   	push   %ebp
  80112a:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  80112c:	eb 06                	jmp    801134 <strcmp+0xb>
		p++, q++;
  80112e:	ff 45 08             	incl   0x8(%ebp)
  801131:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  801134:	8b 45 08             	mov    0x8(%ebp),%eax
  801137:	8a 00                	mov    (%eax),%al
  801139:	84 c0                	test   %al,%al
  80113b:	74 0e                	je     80114b <strcmp+0x22>
  80113d:	8b 45 08             	mov    0x8(%ebp),%eax
  801140:	8a 10                	mov    (%eax),%dl
  801142:	8b 45 0c             	mov    0xc(%ebp),%eax
  801145:	8a 00                	mov    (%eax),%al
  801147:	38 c2                	cmp    %al,%dl
  801149:	74 e3                	je     80112e <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  80114b:	8b 45 08             	mov    0x8(%ebp),%eax
  80114e:	8a 00                	mov    (%eax),%al
  801150:	0f b6 d0             	movzbl %al,%edx
  801153:	8b 45 0c             	mov    0xc(%ebp),%eax
  801156:	8a 00                	mov    (%eax),%al
  801158:	0f b6 c0             	movzbl %al,%eax
  80115b:	29 c2                	sub    %eax,%edx
  80115d:	89 d0                	mov    %edx,%eax
}
  80115f:	5d                   	pop    %ebp
  801160:	c3                   	ret    

00801161 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  801161:	55                   	push   %ebp
  801162:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  801164:	eb 09                	jmp    80116f <strncmp+0xe>
		n--, p++, q++;
  801166:	ff 4d 10             	decl   0x10(%ebp)
  801169:	ff 45 08             	incl   0x8(%ebp)
  80116c:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  80116f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801173:	74 17                	je     80118c <strncmp+0x2b>
  801175:	8b 45 08             	mov    0x8(%ebp),%eax
  801178:	8a 00                	mov    (%eax),%al
  80117a:	84 c0                	test   %al,%al
  80117c:	74 0e                	je     80118c <strncmp+0x2b>
  80117e:	8b 45 08             	mov    0x8(%ebp),%eax
  801181:	8a 10                	mov    (%eax),%dl
  801183:	8b 45 0c             	mov    0xc(%ebp),%eax
  801186:	8a 00                	mov    (%eax),%al
  801188:	38 c2                	cmp    %al,%dl
  80118a:	74 da                	je     801166 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  80118c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801190:	75 07                	jne    801199 <strncmp+0x38>
		return 0;
  801192:	b8 00 00 00 00       	mov    $0x0,%eax
  801197:	eb 14                	jmp    8011ad <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  801199:	8b 45 08             	mov    0x8(%ebp),%eax
  80119c:	8a 00                	mov    (%eax),%al
  80119e:	0f b6 d0             	movzbl %al,%edx
  8011a1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011a4:	8a 00                	mov    (%eax),%al
  8011a6:	0f b6 c0             	movzbl %al,%eax
  8011a9:	29 c2                	sub    %eax,%edx
  8011ab:	89 d0                	mov    %edx,%eax
}
  8011ad:	5d                   	pop    %ebp
  8011ae:	c3                   	ret    

008011af <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8011af:	55                   	push   %ebp
  8011b0:	89 e5                	mov    %esp,%ebp
  8011b2:	83 ec 04             	sub    $0x4,%esp
  8011b5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011b8:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  8011bb:	eb 12                	jmp    8011cf <strchr+0x20>
		if (*s == c)
  8011bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8011c0:	8a 00                	mov    (%eax),%al
  8011c2:	3a 45 fc             	cmp    -0x4(%ebp),%al
  8011c5:	75 05                	jne    8011cc <strchr+0x1d>
			return (char *) s;
  8011c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8011ca:	eb 11                	jmp    8011dd <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  8011cc:	ff 45 08             	incl   0x8(%ebp)
  8011cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8011d2:	8a 00                	mov    (%eax),%al
  8011d4:	84 c0                	test   %al,%al
  8011d6:	75 e5                	jne    8011bd <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  8011d8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8011dd:	c9                   	leave  
  8011de:	c3                   	ret    

008011df <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8011df:	55                   	push   %ebp
  8011e0:	89 e5                	mov    %esp,%ebp
  8011e2:	83 ec 04             	sub    $0x4,%esp
  8011e5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011e8:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  8011eb:	eb 0d                	jmp    8011fa <strfind+0x1b>
		if (*s == c)
  8011ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8011f0:	8a 00                	mov    (%eax),%al
  8011f2:	3a 45 fc             	cmp    -0x4(%ebp),%al
  8011f5:	74 0e                	je     801205 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  8011f7:	ff 45 08             	incl   0x8(%ebp)
  8011fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8011fd:	8a 00                	mov    (%eax),%al
  8011ff:	84 c0                	test   %al,%al
  801201:	75 ea                	jne    8011ed <strfind+0xe>
  801203:	eb 01                	jmp    801206 <strfind+0x27>
		if (*s == c)
			break;
  801205:	90                   	nop
	return (char *) s;
  801206:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801209:	c9                   	leave  
  80120a:	c3                   	ret    

0080120b <memset>:

// *************** The faster implementation of memset & memcpy is implemented by *************
// ****************** Team80 (Yahia Khaled, Malek Ahmed et al) - FCIS'24-25 *******************
void *
memset(void *v, int c, uint32 n)
{
  80120b:	55                   	push   %ebp
  80120c:	89 e5                	mov    %esp,%ebp
  80120e:	83 ec 10             	sub    $0x10,%esp
//	m = n;
//	while (--m >= 0)
//		*p++ = c;

	/*Faster Implementation*/
	uint64* p64 = (uint64*)v;
  801211:	8b 45 08             	mov    0x8(%ebp),%eax
  801214:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if(n >= 8){
  801217:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  80121b:	76 63                	jbe    801280 <memset+0x75>
		uint64 data_block = c;
  80121d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801220:	99                   	cltd   
  801221:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801224:	89 55 f4             	mov    %edx,-0xc(%ebp)
		data_block |= data_block << 8;
  801227:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80122a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80122d:	0f a4 c2 08          	shld   $0x8,%eax,%edx
  801231:	c1 e0 08             	shl    $0x8,%eax
  801234:	09 45 f0             	or     %eax,-0x10(%ebp)
  801237:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 16;
  80123a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80123d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801240:	0f a4 c2 10          	shld   $0x10,%eax,%edx
  801244:	c1 e0 10             	shl    $0x10,%eax
  801247:	09 45 f0             	or     %eax,-0x10(%ebp)
  80124a:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 32;
  80124d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801250:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801253:	89 c2                	mov    %eax,%edx
  801255:	b8 00 00 00 00       	mov    $0x0,%eax
  80125a:	09 45 f0             	or     %eax,-0x10(%ebp)
  80125d:	09 55 f4             	or     %edx,-0xc(%ebp)

		while(n >= 8)
  801260:	eb 18                	jmp    80127a <memset+0x6f>
			*p64++ = data_block, n -= 8;
  801262:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801265:	8d 41 08             	lea    0x8(%ecx),%eax
  801268:	89 45 fc             	mov    %eax,-0x4(%ebp)
  80126b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80126e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801271:	89 01                	mov    %eax,(%ecx)
  801273:	89 51 04             	mov    %edx,0x4(%ecx)
  801276:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
		uint64 data_block = c;
		data_block |= data_block << 8;
		data_block |= data_block << 16;
		data_block |= data_block << 32;

		while(n >= 8)
  80127a:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  80127e:	77 e2                	ja     801262 <memset+0x57>
			*p64++ = data_block, n -= 8;
	}

	if(n){
  801280:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801284:	74 23                	je     8012a9 <memset+0x9e>
		uint8* p8 = (uint8*)p64;
  801286:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801289:	89 45 f8             	mov    %eax,-0x8(%ebp)
		while (n-- > 0)
  80128c:	eb 0e                	jmp    80129c <memset+0x91>
			*p8++ = (uint8)c;
  80128e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801291:	8d 50 01             	lea    0x1(%eax),%edx
  801294:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801297:	8b 55 0c             	mov    0xc(%ebp),%edx
  80129a:	88 10                	mov    %dl,(%eax)
			*p64++ = data_block, n -= 8;
	}

	if(n){
		uint8* p8 = (uint8*)p64;
		while (n-- > 0)
  80129c:	8b 45 10             	mov    0x10(%ebp),%eax
  80129f:	8d 50 ff             	lea    -0x1(%eax),%edx
  8012a2:	89 55 10             	mov    %edx,0x10(%ebp)
  8012a5:	85 c0                	test   %eax,%eax
  8012a7:	75 e5                	jne    80128e <memset+0x83>
			*p8++ = (uint8)c;
	}

	return v;
  8012a9:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8012ac:	c9                   	leave  
  8012ad:	c3                   	ret    

008012ae <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  8012ae:	55                   	push   %ebp
  8012af:	89 e5                	mov    %esp,%ebp
  8012b1:	83 ec 10             	sub    $0x10,%esp
	//	s = src;
	//	d = dst;
	//	while (n-- > 0)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
  8012b4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012b7:	89 45 fc             	mov    %eax,-0x4(%ebp)
	uint64* d64 = (uint64*)dst;
  8012ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8012bd:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if(n >= 8){
  8012c0:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  8012c4:	76 24                	jbe    8012ea <memcpy+0x3c>
		while(n >= 8){
  8012c6:	eb 1c                	jmp    8012e4 <memcpy+0x36>
			*d64 = *s64;
  8012c8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8012cb:	8b 50 04             	mov    0x4(%eax),%edx
  8012ce:	8b 00                	mov    (%eax),%eax
  8012d0:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8012d3:	89 01                	mov    %eax,(%ecx)
  8012d5:	89 51 04             	mov    %edx,0x4(%ecx)
			n -= 8;
  8012d8:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
			++s64;
  8012dc:	83 45 fc 08          	addl   $0x8,-0x4(%ebp)
			++d64;
  8012e0:	83 45 f8 08          	addl   $0x8,-0x8(%ebp)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
	uint64* d64 = (uint64*)dst;
	if(n >= 8){
		while(n >= 8){
  8012e4:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  8012e8:	77 de                	ja     8012c8 <memcpy+0x1a>
			++s64;
			++d64;
		}
	}

	if(n){
  8012ea:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8012ee:	74 31                	je     801321 <memcpy+0x73>
		uint8* s8 = (uint8*)s64;
  8012f0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8012f3:	89 45 f4             	mov    %eax,-0xc(%ebp)
		uint8* d8 = (uint8*)d64;
  8012f6:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8012f9:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (n-- > 0)
  8012fc:	eb 16                	jmp    801314 <memcpy+0x66>
			*d8++ = *s8++;
  8012fe:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801301:	8d 50 01             	lea    0x1(%eax),%edx
  801304:	89 55 f0             	mov    %edx,-0x10(%ebp)
  801307:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80130a:	8d 4a 01             	lea    0x1(%edx),%ecx
  80130d:	89 4d f4             	mov    %ecx,-0xc(%ebp)
  801310:	8a 12                	mov    (%edx),%dl
  801312:	88 10                	mov    %dl,(%eax)
	}

	if(n){
		uint8* s8 = (uint8*)s64;
		uint8* d8 = (uint8*)d64;
		while (n-- > 0)
  801314:	8b 45 10             	mov    0x10(%ebp),%eax
  801317:	8d 50 ff             	lea    -0x1(%eax),%edx
  80131a:	89 55 10             	mov    %edx,0x10(%ebp)
  80131d:	85 c0                	test   %eax,%eax
  80131f:	75 dd                	jne    8012fe <memcpy+0x50>
			*d8++ = *s8++;
	}
	return dst;
  801321:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801324:	c9                   	leave  
  801325:	c3                   	ret    

00801326 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  801326:	55                   	push   %ebp
  801327:	89 e5                	mov    %esp,%ebp
  801329:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  80132c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80132f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801332:	8b 45 08             	mov    0x8(%ebp),%eax
  801335:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  801338:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80133b:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  80133e:	73 50                	jae    801390 <memmove+0x6a>
  801340:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801343:	8b 45 10             	mov    0x10(%ebp),%eax
  801346:	01 d0                	add    %edx,%eax
  801348:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  80134b:	76 43                	jbe    801390 <memmove+0x6a>
		s += n;
  80134d:	8b 45 10             	mov    0x10(%ebp),%eax
  801350:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  801353:	8b 45 10             	mov    0x10(%ebp),%eax
  801356:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  801359:	eb 10                	jmp    80136b <memmove+0x45>
			*--d = *--s;
  80135b:	ff 4d f8             	decl   -0x8(%ebp)
  80135e:	ff 4d fc             	decl   -0x4(%ebp)
  801361:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801364:	8a 10                	mov    (%eax),%dl
  801366:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801369:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  80136b:	8b 45 10             	mov    0x10(%ebp),%eax
  80136e:	8d 50 ff             	lea    -0x1(%eax),%edx
  801371:	89 55 10             	mov    %edx,0x10(%ebp)
  801374:	85 c0                	test   %eax,%eax
  801376:	75 e3                	jne    80135b <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  801378:	eb 23                	jmp    80139d <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  80137a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80137d:	8d 50 01             	lea    0x1(%eax),%edx
  801380:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801383:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801386:	8d 4a 01             	lea    0x1(%edx),%ecx
  801389:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  80138c:	8a 12                	mov    (%edx),%dl
  80138e:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  801390:	8b 45 10             	mov    0x10(%ebp),%eax
  801393:	8d 50 ff             	lea    -0x1(%eax),%edx
  801396:	89 55 10             	mov    %edx,0x10(%ebp)
  801399:	85 c0                	test   %eax,%eax
  80139b:	75 dd                	jne    80137a <memmove+0x54>
			*d++ = *s++;

	return dst;
  80139d:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8013a0:	c9                   	leave  
  8013a1:	c3                   	ret    

008013a2 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  8013a2:	55                   	push   %ebp
  8013a3:	89 e5                	mov    %esp,%ebp
  8013a5:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  8013a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8013ab:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  8013ae:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013b1:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  8013b4:	eb 2a                	jmp    8013e0 <memcmp+0x3e>
		if (*s1 != *s2)
  8013b6:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8013b9:	8a 10                	mov    (%eax),%dl
  8013bb:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8013be:	8a 00                	mov    (%eax),%al
  8013c0:	38 c2                	cmp    %al,%dl
  8013c2:	74 16                	je     8013da <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  8013c4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8013c7:	8a 00                	mov    (%eax),%al
  8013c9:	0f b6 d0             	movzbl %al,%edx
  8013cc:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8013cf:	8a 00                	mov    (%eax),%al
  8013d1:	0f b6 c0             	movzbl %al,%eax
  8013d4:	29 c2                	sub    %eax,%edx
  8013d6:	89 d0                	mov    %edx,%eax
  8013d8:	eb 18                	jmp    8013f2 <memcmp+0x50>
		s1++, s2++;
  8013da:	ff 45 fc             	incl   -0x4(%ebp)
  8013dd:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  8013e0:	8b 45 10             	mov    0x10(%ebp),%eax
  8013e3:	8d 50 ff             	lea    -0x1(%eax),%edx
  8013e6:	89 55 10             	mov    %edx,0x10(%ebp)
  8013e9:	85 c0                	test   %eax,%eax
  8013eb:	75 c9                	jne    8013b6 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  8013ed:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8013f2:	c9                   	leave  
  8013f3:	c3                   	ret    

008013f4 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  8013f4:	55                   	push   %ebp
  8013f5:	89 e5                	mov    %esp,%ebp
  8013f7:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  8013fa:	8b 55 08             	mov    0x8(%ebp),%edx
  8013fd:	8b 45 10             	mov    0x10(%ebp),%eax
  801400:	01 d0                	add    %edx,%eax
  801402:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  801405:	eb 15                	jmp    80141c <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  801407:	8b 45 08             	mov    0x8(%ebp),%eax
  80140a:	8a 00                	mov    (%eax),%al
  80140c:	0f b6 d0             	movzbl %al,%edx
  80140f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801412:	0f b6 c0             	movzbl %al,%eax
  801415:	39 c2                	cmp    %eax,%edx
  801417:	74 0d                	je     801426 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801419:	ff 45 08             	incl   0x8(%ebp)
  80141c:	8b 45 08             	mov    0x8(%ebp),%eax
  80141f:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801422:	72 e3                	jb     801407 <memfind+0x13>
  801424:	eb 01                	jmp    801427 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  801426:	90                   	nop
	return (void *) s;
  801427:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80142a:	c9                   	leave  
  80142b:	c3                   	ret    

0080142c <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  80142c:	55                   	push   %ebp
  80142d:	89 e5                	mov    %esp,%ebp
  80142f:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  801432:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  801439:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801440:	eb 03                	jmp    801445 <strtol+0x19>
		s++;
  801442:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801445:	8b 45 08             	mov    0x8(%ebp),%eax
  801448:	8a 00                	mov    (%eax),%al
  80144a:	3c 20                	cmp    $0x20,%al
  80144c:	74 f4                	je     801442 <strtol+0x16>
  80144e:	8b 45 08             	mov    0x8(%ebp),%eax
  801451:	8a 00                	mov    (%eax),%al
  801453:	3c 09                	cmp    $0x9,%al
  801455:	74 eb                	je     801442 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  801457:	8b 45 08             	mov    0x8(%ebp),%eax
  80145a:	8a 00                	mov    (%eax),%al
  80145c:	3c 2b                	cmp    $0x2b,%al
  80145e:	75 05                	jne    801465 <strtol+0x39>
		s++;
  801460:	ff 45 08             	incl   0x8(%ebp)
  801463:	eb 13                	jmp    801478 <strtol+0x4c>
	else if (*s == '-')
  801465:	8b 45 08             	mov    0x8(%ebp),%eax
  801468:	8a 00                	mov    (%eax),%al
  80146a:	3c 2d                	cmp    $0x2d,%al
  80146c:	75 0a                	jne    801478 <strtol+0x4c>
		s++, neg = 1;
  80146e:	ff 45 08             	incl   0x8(%ebp)
  801471:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801478:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80147c:	74 06                	je     801484 <strtol+0x58>
  80147e:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  801482:	75 20                	jne    8014a4 <strtol+0x78>
  801484:	8b 45 08             	mov    0x8(%ebp),%eax
  801487:	8a 00                	mov    (%eax),%al
  801489:	3c 30                	cmp    $0x30,%al
  80148b:	75 17                	jne    8014a4 <strtol+0x78>
  80148d:	8b 45 08             	mov    0x8(%ebp),%eax
  801490:	40                   	inc    %eax
  801491:	8a 00                	mov    (%eax),%al
  801493:	3c 78                	cmp    $0x78,%al
  801495:	75 0d                	jne    8014a4 <strtol+0x78>
		s += 2, base = 16;
  801497:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  80149b:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  8014a2:	eb 28                	jmp    8014cc <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  8014a4:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8014a8:	75 15                	jne    8014bf <strtol+0x93>
  8014aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8014ad:	8a 00                	mov    (%eax),%al
  8014af:	3c 30                	cmp    $0x30,%al
  8014b1:	75 0c                	jne    8014bf <strtol+0x93>
		s++, base = 8;
  8014b3:	ff 45 08             	incl   0x8(%ebp)
  8014b6:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  8014bd:	eb 0d                	jmp    8014cc <strtol+0xa0>
	else if (base == 0)
  8014bf:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8014c3:	75 07                	jne    8014cc <strtol+0xa0>
		base = 10;
  8014c5:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8014cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8014cf:	8a 00                	mov    (%eax),%al
  8014d1:	3c 2f                	cmp    $0x2f,%al
  8014d3:	7e 19                	jle    8014ee <strtol+0xc2>
  8014d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8014d8:	8a 00                	mov    (%eax),%al
  8014da:	3c 39                	cmp    $0x39,%al
  8014dc:	7f 10                	jg     8014ee <strtol+0xc2>
			dig = *s - '0';
  8014de:	8b 45 08             	mov    0x8(%ebp),%eax
  8014e1:	8a 00                	mov    (%eax),%al
  8014e3:	0f be c0             	movsbl %al,%eax
  8014e6:	83 e8 30             	sub    $0x30,%eax
  8014e9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8014ec:	eb 42                	jmp    801530 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  8014ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8014f1:	8a 00                	mov    (%eax),%al
  8014f3:	3c 60                	cmp    $0x60,%al
  8014f5:	7e 19                	jle    801510 <strtol+0xe4>
  8014f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8014fa:	8a 00                	mov    (%eax),%al
  8014fc:	3c 7a                	cmp    $0x7a,%al
  8014fe:	7f 10                	jg     801510 <strtol+0xe4>
			dig = *s - 'a' + 10;
  801500:	8b 45 08             	mov    0x8(%ebp),%eax
  801503:	8a 00                	mov    (%eax),%al
  801505:	0f be c0             	movsbl %al,%eax
  801508:	83 e8 57             	sub    $0x57,%eax
  80150b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80150e:	eb 20                	jmp    801530 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  801510:	8b 45 08             	mov    0x8(%ebp),%eax
  801513:	8a 00                	mov    (%eax),%al
  801515:	3c 40                	cmp    $0x40,%al
  801517:	7e 39                	jle    801552 <strtol+0x126>
  801519:	8b 45 08             	mov    0x8(%ebp),%eax
  80151c:	8a 00                	mov    (%eax),%al
  80151e:	3c 5a                	cmp    $0x5a,%al
  801520:	7f 30                	jg     801552 <strtol+0x126>
			dig = *s - 'A' + 10;
  801522:	8b 45 08             	mov    0x8(%ebp),%eax
  801525:	8a 00                	mov    (%eax),%al
  801527:	0f be c0             	movsbl %al,%eax
  80152a:	83 e8 37             	sub    $0x37,%eax
  80152d:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  801530:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801533:	3b 45 10             	cmp    0x10(%ebp),%eax
  801536:	7d 19                	jge    801551 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801538:	ff 45 08             	incl   0x8(%ebp)
  80153b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80153e:	0f af 45 10          	imul   0x10(%ebp),%eax
  801542:	89 c2                	mov    %eax,%edx
  801544:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801547:	01 d0                	add    %edx,%eax
  801549:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  80154c:	e9 7b ff ff ff       	jmp    8014cc <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801551:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801552:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801556:	74 08                	je     801560 <strtol+0x134>
		*endptr = (char *) s;
  801558:	8b 45 0c             	mov    0xc(%ebp),%eax
  80155b:	8b 55 08             	mov    0x8(%ebp),%edx
  80155e:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  801560:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801564:	74 07                	je     80156d <strtol+0x141>
  801566:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801569:	f7 d8                	neg    %eax
  80156b:	eb 03                	jmp    801570 <strtol+0x144>
  80156d:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801570:	c9                   	leave  
  801571:	c3                   	ret    

00801572 <ltostr>:

void
ltostr(long value, char *str)
{
  801572:	55                   	push   %ebp
  801573:	89 e5                	mov    %esp,%ebp
  801575:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  801578:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  80157f:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  801586:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80158a:	79 13                	jns    80159f <ltostr+0x2d>
	{
		neg = 1;
  80158c:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  801593:	8b 45 0c             	mov    0xc(%ebp),%eax
  801596:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  801599:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  80159c:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  80159f:	8b 45 08             	mov    0x8(%ebp),%eax
  8015a2:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8015a7:	99                   	cltd   
  8015a8:	f7 f9                	idiv   %ecx
  8015aa:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  8015ad:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8015b0:	8d 50 01             	lea    0x1(%eax),%edx
  8015b3:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8015b6:	89 c2                	mov    %eax,%edx
  8015b8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015bb:	01 d0                	add    %edx,%eax
  8015bd:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8015c0:	83 c2 30             	add    $0x30,%edx
  8015c3:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  8015c5:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8015c8:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8015cd:	f7 e9                	imul   %ecx
  8015cf:	c1 fa 02             	sar    $0x2,%edx
  8015d2:	89 c8                	mov    %ecx,%eax
  8015d4:	c1 f8 1f             	sar    $0x1f,%eax
  8015d7:	29 c2                	sub    %eax,%edx
  8015d9:	89 d0                	mov    %edx,%eax
  8015db:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  8015de:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8015e2:	75 bb                	jne    80159f <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  8015e4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  8015eb:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8015ee:	48                   	dec    %eax
  8015ef:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  8015f2:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8015f6:	74 3d                	je     801635 <ltostr+0xc3>
		start = 1 ;
  8015f8:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  8015ff:	eb 34                	jmp    801635 <ltostr+0xc3>
	{
		char tmp = str[start] ;
  801601:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801604:	8b 45 0c             	mov    0xc(%ebp),%eax
  801607:	01 d0                	add    %edx,%eax
  801609:	8a 00                	mov    (%eax),%al
  80160b:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  80160e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801611:	8b 45 0c             	mov    0xc(%ebp),%eax
  801614:	01 c2                	add    %eax,%edx
  801616:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801619:	8b 45 0c             	mov    0xc(%ebp),%eax
  80161c:	01 c8                	add    %ecx,%eax
  80161e:	8a 00                	mov    (%eax),%al
  801620:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801622:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801625:	8b 45 0c             	mov    0xc(%ebp),%eax
  801628:	01 c2                	add    %eax,%edx
  80162a:	8a 45 eb             	mov    -0x15(%ebp),%al
  80162d:	88 02                	mov    %al,(%edx)
		start++ ;
  80162f:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801632:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801635:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801638:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80163b:	7c c4                	jl     801601 <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  80163d:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801640:	8b 45 0c             	mov    0xc(%ebp),%eax
  801643:	01 d0                	add    %edx,%eax
  801645:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801648:	90                   	nop
  801649:	c9                   	leave  
  80164a:	c3                   	ret    

0080164b <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  80164b:	55                   	push   %ebp
  80164c:	89 e5                	mov    %esp,%ebp
  80164e:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801651:	ff 75 08             	pushl  0x8(%ebp)
  801654:	e8 c4 f9 ff ff       	call   80101d <strlen>
  801659:	83 c4 04             	add    $0x4,%esp
  80165c:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  80165f:	ff 75 0c             	pushl  0xc(%ebp)
  801662:	e8 b6 f9 ff ff       	call   80101d <strlen>
  801667:	83 c4 04             	add    $0x4,%esp
  80166a:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  80166d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  801674:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80167b:	eb 17                	jmp    801694 <strcconcat+0x49>
		final[s] = str1[s] ;
  80167d:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801680:	8b 45 10             	mov    0x10(%ebp),%eax
  801683:	01 c2                	add    %eax,%edx
  801685:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801688:	8b 45 08             	mov    0x8(%ebp),%eax
  80168b:	01 c8                	add    %ecx,%eax
  80168d:	8a 00                	mov    (%eax),%al
  80168f:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  801691:	ff 45 fc             	incl   -0x4(%ebp)
  801694:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801697:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  80169a:	7c e1                	jl     80167d <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  80169c:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  8016a3:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8016aa:	eb 1f                	jmp    8016cb <strcconcat+0x80>
		final[s++] = str2[i] ;
  8016ac:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8016af:	8d 50 01             	lea    0x1(%eax),%edx
  8016b2:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8016b5:	89 c2                	mov    %eax,%edx
  8016b7:	8b 45 10             	mov    0x10(%ebp),%eax
  8016ba:	01 c2                	add    %eax,%edx
  8016bc:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8016bf:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016c2:	01 c8                	add    %ecx,%eax
  8016c4:	8a 00                	mov    (%eax),%al
  8016c6:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  8016c8:	ff 45 f8             	incl   -0x8(%ebp)
  8016cb:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8016ce:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8016d1:	7c d9                	jl     8016ac <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  8016d3:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8016d6:	8b 45 10             	mov    0x10(%ebp),%eax
  8016d9:	01 d0                	add    %edx,%eax
  8016db:	c6 00 00             	movb   $0x0,(%eax)
}
  8016de:	90                   	nop
  8016df:	c9                   	leave  
  8016e0:	c3                   	ret    

008016e1 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  8016e1:	55                   	push   %ebp
  8016e2:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  8016e4:	8b 45 14             	mov    0x14(%ebp),%eax
  8016e7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  8016ed:	8b 45 14             	mov    0x14(%ebp),%eax
  8016f0:	8b 00                	mov    (%eax),%eax
  8016f2:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8016f9:	8b 45 10             	mov    0x10(%ebp),%eax
  8016fc:	01 d0                	add    %edx,%eax
  8016fe:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801704:	eb 0c                	jmp    801712 <strsplit+0x31>
			*string++ = 0;
  801706:	8b 45 08             	mov    0x8(%ebp),%eax
  801709:	8d 50 01             	lea    0x1(%eax),%edx
  80170c:	89 55 08             	mov    %edx,0x8(%ebp)
  80170f:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801712:	8b 45 08             	mov    0x8(%ebp),%eax
  801715:	8a 00                	mov    (%eax),%al
  801717:	84 c0                	test   %al,%al
  801719:	74 18                	je     801733 <strsplit+0x52>
  80171b:	8b 45 08             	mov    0x8(%ebp),%eax
  80171e:	8a 00                	mov    (%eax),%al
  801720:	0f be c0             	movsbl %al,%eax
  801723:	50                   	push   %eax
  801724:	ff 75 0c             	pushl  0xc(%ebp)
  801727:	e8 83 fa ff ff       	call   8011af <strchr>
  80172c:	83 c4 08             	add    $0x8,%esp
  80172f:	85 c0                	test   %eax,%eax
  801731:	75 d3                	jne    801706 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801733:	8b 45 08             	mov    0x8(%ebp),%eax
  801736:	8a 00                	mov    (%eax),%al
  801738:	84 c0                	test   %al,%al
  80173a:	74 5a                	je     801796 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  80173c:	8b 45 14             	mov    0x14(%ebp),%eax
  80173f:	8b 00                	mov    (%eax),%eax
  801741:	83 f8 0f             	cmp    $0xf,%eax
  801744:	75 07                	jne    80174d <strsplit+0x6c>
		{
			return 0;
  801746:	b8 00 00 00 00       	mov    $0x0,%eax
  80174b:	eb 66                	jmp    8017b3 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  80174d:	8b 45 14             	mov    0x14(%ebp),%eax
  801750:	8b 00                	mov    (%eax),%eax
  801752:	8d 48 01             	lea    0x1(%eax),%ecx
  801755:	8b 55 14             	mov    0x14(%ebp),%edx
  801758:	89 0a                	mov    %ecx,(%edx)
  80175a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801761:	8b 45 10             	mov    0x10(%ebp),%eax
  801764:	01 c2                	add    %eax,%edx
  801766:	8b 45 08             	mov    0x8(%ebp),%eax
  801769:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  80176b:	eb 03                	jmp    801770 <strsplit+0x8f>
			string++;
  80176d:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801770:	8b 45 08             	mov    0x8(%ebp),%eax
  801773:	8a 00                	mov    (%eax),%al
  801775:	84 c0                	test   %al,%al
  801777:	74 8b                	je     801704 <strsplit+0x23>
  801779:	8b 45 08             	mov    0x8(%ebp),%eax
  80177c:	8a 00                	mov    (%eax),%al
  80177e:	0f be c0             	movsbl %al,%eax
  801781:	50                   	push   %eax
  801782:	ff 75 0c             	pushl  0xc(%ebp)
  801785:	e8 25 fa ff ff       	call   8011af <strchr>
  80178a:	83 c4 08             	add    $0x8,%esp
  80178d:	85 c0                	test   %eax,%eax
  80178f:	74 dc                	je     80176d <strsplit+0x8c>
			string++;
	}
  801791:	e9 6e ff ff ff       	jmp    801704 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801796:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801797:	8b 45 14             	mov    0x14(%ebp),%eax
  80179a:	8b 00                	mov    (%eax),%eax
  80179c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8017a3:	8b 45 10             	mov    0x10(%ebp),%eax
  8017a6:	01 d0                	add    %edx,%eax
  8017a8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  8017ae:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8017b3:	c9                   	leave  
  8017b4:	c3                   	ret    

008017b5 <str2lower>:


char* str2lower(char *dst, const char *src)
{
  8017b5:	55                   	push   %ebp
  8017b6:	89 e5                	mov    %esp,%ebp
  8017b8:	83 ec 10             	sub    $0x10,%esp
	char* ret = dst;
  8017bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8017be:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (int i = 0; i < strlen(src); ++i)
  8017c1:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8017c8:	eb 4a                	jmp    801814 <str2lower+0x5f>
	{
		dst[i] = src[i] ;
  8017ca:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8017cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8017d0:	01 c2                	add    %eax,%edx
  8017d2:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8017d5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017d8:	01 c8                	add    %ecx,%eax
  8017da:	8a 00                	mov    (%eax),%al
  8017dc:	88 02                	mov    %al,(%edx)
		if (src[i] >= 'A' && src[i] <= 'Z')
  8017de:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8017e1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017e4:	01 d0                	add    %edx,%eax
  8017e6:	8a 00                	mov    (%eax),%al
  8017e8:	3c 40                	cmp    $0x40,%al
  8017ea:	7e 25                	jle    801811 <str2lower+0x5c>
  8017ec:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8017ef:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017f2:	01 d0                	add    %edx,%eax
  8017f4:	8a 00                	mov    (%eax),%al
  8017f6:	3c 5a                	cmp    $0x5a,%al
  8017f8:	7f 17                	jg     801811 <str2lower+0x5c>
		{
			dst[i] += 32 ;
  8017fa:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8017fd:	8b 45 08             	mov    0x8(%ebp),%eax
  801800:	01 d0                	add    %edx,%eax
  801802:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801805:	8b 55 08             	mov    0x8(%ebp),%edx
  801808:	01 ca                	add    %ecx,%edx
  80180a:	8a 12                	mov    (%edx),%dl
  80180c:	83 c2 20             	add    $0x20,%edx
  80180f:	88 10                	mov    %dl,(%eax)


char* str2lower(char *dst, const char *src)
{
	char* ret = dst;
	for (int i = 0; i < strlen(src); ++i)
  801811:	ff 45 fc             	incl   -0x4(%ebp)
  801814:	ff 75 0c             	pushl  0xc(%ebp)
  801817:	e8 01 f8 ff ff       	call   80101d <strlen>
  80181c:	83 c4 04             	add    $0x4,%esp
  80181f:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801822:	7f a6                	jg     8017ca <str2lower+0x15>
		if (src[i] >= 'A' && src[i] <= 'Z')
		{
			dst[i] += 32 ;
		}
	}
	return ret;
  801824:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801827:	c9                   	leave  
  801828:	c3                   	ret    

00801829 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801829:	55                   	push   %ebp
  80182a:	89 e5                	mov    %esp,%ebp
  80182c:	57                   	push   %edi
  80182d:	56                   	push   %esi
  80182e:	53                   	push   %ebx
  80182f:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801832:	8b 45 08             	mov    0x8(%ebp),%eax
  801835:	8b 55 0c             	mov    0xc(%ebp),%edx
  801838:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80183b:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80183e:	8b 7d 18             	mov    0x18(%ebp),%edi
  801841:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801844:	cd 30                	int    $0x30
  801846:	89 45 f0             	mov    %eax,-0x10(%ebp)
				"b" (a3),
				"D" (a4),
				"S" (a5)
				: "cc", "memory");

	return ret;
  801849:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80184c:	83 c4 10             	add    $0x10,%esp
  80184f:	5b                   	pop    %ebx
  801850:	5e                   	pop    %esi
  801851:	5f                   	pop    %edi
  801852:	5d                   	pop    %ebp
  801853:	c3                   	ret    

00801854 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName, int color)
{
  801854:	55                   	push   %ebp
  801855:	89 e5                	mov    %esp,%ebp
  801857:	83 ec 04             	sub    $0x4,%esp
  80185a:	8b 45 10             	mov    0x10(%ebp),%eax
  80185d:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, color, 0);
  801860:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801863:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801867:	8b 45 08             	mov    0x8(%ebp),%eax
  80186a:	6a 00                	push   $0x0
  80186c:	51                   	push   %ecx
  80186d:	52                   	push   %edx
  80186e:	ff 75 0c             	pushl  0xc(%ebp)
  801871:	50                   	push   %eax
  801872:	6a 00                	push   $0x0
  801874:	e8 b0 ff ff ff       	call   801829 <syscall>
  801879:	83 c4 18             	add    $0x18,%esp
}
  80187c:	90                   	nop
  80187d:	c9                   	leave  
  80187e:	c3                   	ret    

0080187f <sys_cgetc>:

int
sys_cgetc(void)
{
  80187f:	55                   	push   %ebp
  801880:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801882:	6a 00                	push   $0x0
  801884:	6a 00                	push   $0x0
  801886:	6a 00                	push   $0x0
  801888:	6a 00                	push   $0x0
  80188a:	6a 00                	push   $0x0
  80188c:	6a 02                	push   $0x2
  80188e:	e8 96 ff ff ff       	call   801829 <syscall>
  801893:	83 c4 18             	add    $0x18,%esp
}
  801896:	c9                   	leave  
  801897:	c3                   	ret    

00801898 <sys_lock_cons>:

void sys_lock_cons(void)
{
  801898:	55                   	push   %ebp
  801899:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  80189b:	6a 00                	push   $0x0
  80189d:	6a 00                	push   $0x0
  80189f:	6a 00                	push   $0x0
  8018a1:	6a 00                	push   $0x0
  8018a3:	6a 00                	push   $0x0
  8018a5:	6a 03                	push   $0x3
  8018a7:	e8 7d ff ff ff       	call   801829 <syscall>
  8018ac:	83 c4 18             	add    $0x18,%esp
}
  8018af:	90                   	nop
  8018b0:	c9                   	leave  
  8018b1:	c3                   	ret    

008018b2 <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  8018b2:	55                   	push   %ebp
  8018b3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  8018b5:	6a 00                	push   $0x0
  8018b7:	6a 00                	push   $0x0
  8018b9:	6a 00                	push   $0x0
  8018bb:	6a 00                	push   $0x0
  8018bd:	6a 00                	push   $0x0
  8018bf:	6a 04                	push   $0x4
  8018c1:	e8 63 ff ff ff       	call   801829 <syscall>
  8018c6:	83 c4 18             	add    $0x18,%esp
}
  8018c9:	90                   	nop
  8018ca:	c9                   	leave  
  8018cb:	c3                   	ret    

008018cc <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  8018cc:	55                   	push   %ebp
  8018cd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  8018cf:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8018d5:	6a 00                	push   $0x0
  8018d7:	6a 00                	push   $0x0
  8018d9:	6a 00                	push   $0x0
  8018db:	52                   	push   %edx
  8018dc:	50                   	push   %eax
  8018dd:	6a 08                	push   $0x8
  8018df:	e8 45 ff ff ff       	call   801829 <syscall>
  8018e4:	83 c4 18             	add    $0x18,%esp
}
  8018e7:	c9                   	leave  
  8018e8:	c3                   	ret    

008018e9 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  8018e9:	55                   	push   %ebp
  8018ea:	89 e5                	mov    %esp,%ebp
  8018ec:	56                   	push   %esi
  8018ed:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  8018ee:	8b 75 18             	mov    0x18(%ebp),%esi
  8018f1:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8018f4:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8018f7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8018fd:	56                   	push   %esi
  8018fe:	53                   	push   %ebx
  8018ff:	51                   	push   %ecx
  801900:	52                   	push   %edx
  801901:	50                   	push   %eax
  801902:	6a 09                	push   $0x9
  801904:	e8 20 ff ff ff       	call   801829 <syscall>
  801909:	83 c4 18             	add    $0x18,%esp
}
  80190c:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80190f:	5b                   	pop    %ebx
  801910:	5e                   	pop    %esi
  801911:	5d                   	pop    %ebp
  801912:	c3                   	ret    

00801913 <__sys_unmap_frame>:

int __sys_unmap_frame(uint32 va)
{
  801913:	55                   	push   %ebp
  801914:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, va, 0, 0, 0, 0);
  801916:	6a 00                	push   $0x0
  801918:	6a 00                	push   $0x0
  80191a:	6a 00                	push   $0x0
  80191c:	6a 00                	push   $0x0
  80191e:	ff 75 08             	pushl  0x8(%ebp)
  801921:	6a 0a                	push   $0xa
  801923:	e8 01 ff ff ff       	call   801829 <syscall>
  801928:	83 c4 18             	add    $0x18,%esp
}
  80192b:	c9                   	leave  
  80192c:	c3                   	ret    

0080192d <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  80192d:	55                   	push   %ebp
  80192e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801930:	6a 00                	push   $0x0
  801932:	6a 00                	push   $0x0
  801934:	6a 00                	push   $0x0
  801936:	ff 75 0c             	pushl  0xc(%ebp)
  801939:	ff 75 08             	pushl  0x8(%ebp)
  80193c:	6a 0b                	push   $0xb
  80193e:	e8 e6 fe ff ff       	call   801829 <syscall>
  801943:	83 c4 18             	add    $0x18,%esp
}
  801946:	c9                   	leave  
  801947:	c3                   	ret    

00801948 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801948:	55                   	push   %ebp
  801949:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  80194b:	6a 00                	push   $0x0
  80194d:	6a 00                	push   $0x0
  80194f:	6a 00                	push   $0x0
  801951:	6a 00                	push   $0x0
  801953:	6a 00                	push   $0x0
  801955:	6a 0c                	push   $0xc
  801957:	e8 cd fe ff ff       	call   801829 <syscall>
  80195c:	83 c4 18             	add    $0x18,%esp
}
  80195f:	c9                   	leave  
  801960:	c3                   	ret    

00801961 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801961:	55                   	push   %ebp
  801962:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801964:	6a 00                	push   $0x0
  801966:	6a 00                	push   $0x0
  801968:	6a 00                	push   $0x0
  80196a:	6a 00                	push   $0x0
  80196c:	6a 00                	push   $0x0
  80196e:	6a 0d                	push   $0xd
  801970:	e8 b4 fe ff ff       	call   801829 <syscall>
  801975:	83 c4 18             	add    $0x18,%esp
}
  801978:	c9                   	leave  
  801979:	c3                   	ret    

0080197a <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  80197a:	55                   	push   %ebp
  80197b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  80197d:	6a 00                	push   $0x0
  80197f:	6a 00                	push   $0x0
  801981:	6a 00                	push   $0x0
  801983:	6a 00                	push   $0x0
  801985:	6a 00                	push   $0x0
  801987:	6a 0e                	push   $0xe
  801989:	e8 9b fe ff ff       	call   801829 <syscall>
  80198e:	83 c4 18             	add    $0x18,%esp
}
  801991:	c9                   	leave  
  801992:	c3                   	ret    

00801993 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801993:	55                   	push   %ebp
  801994:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801996:	6a 00                	push   $0x0
  801998:	6a 00                	push   $0x0
  80199a:	6a 00                	push   $0x0
  80199c:	6a 00                	push   $0x0
  80199e:	6a 00                	push   $0x0
  8019a0:	6a 0f                	push   $0xf
  8019a2:	e8 82 fe ff ff       	call   801829 <syscall>
  8019a7:	83 c4 18             	add    $0x18,%esp
}
  8019aa:	c9                   	leave  
  8019ab:	c3                   	ret    

008019ac <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  8019ac:	55                   	push   %ebp
  8019ad:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  8019af:	6a 00                	push   $0x0
  8019b1:	6a 00                	push   $0x0
  8019b3:	6a 00                	push   $0x0
  8019b5:	6a 00                	push   $0x0
  8019b7:	ff 75 08             	pushl  0x8(%ebp)
  8019ba:	6a 10                	push   $0x10
  8019bc:	e8 68 fe ff ff       	call   801829 <syscall>
  8019c1:	83 c4 18             	add    $0x18,%esp
}
  8019c4:	c9                   	leave  
  8019c5:	c3                   	ret    

008019c6 <sys_scarce_memory>:

void sys_scarce_memory()
{
  8019c6:	55                   	push   %ebp
  8019c7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  8019c9:	6a 00                	push   $0x0
  8019cb:	6a 00                	push   $0x0
  8019cd:	6a 00                	push   $0x0
  8019cf:	6a 00                	push   $0x0
  8019d1:	6a 00                	push   $0x0
  8019d3:	6a 11                	push   $0x11
  8019d5:	e8 4f fe ff ff       	call   801829 <syscall>
  8019da:	83 c4 18             	add    $0x18,%esp
}
  8019dd:	90                   	nop
  8019de:	c9                   	leave  
  8019df:	c3                   	ret    

008019e0 <sys_cputc>:

void
sys_cputc(const char c)
{
  8019e0:	55                   	push   %ebp
  8019e1:	89 e5                	mov    %esp,%ebp
  8019e3:	83 ec 04             	sub    $0x4,%esp
  8019e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8019e9:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  8019ec:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8019f0:	6a 00                	push   $0x0
  8019f2:	6a 00                	push   $0x0
  8019f4:	6a 00                	push   $0x0
  8019f6:	6a 00                	push   $0x0
  8019f8:	50                   	push   %eax
  8019f9:	6a 01                	push   $0x1
  8019fb:	e8 29 fe ff ff       	call   801829 <syscall>
  801a00:	83 c4 18             	add    $0x18,%esp
}
  801a03:	90                   	nop
  801a04:	c9                   	leave  
  801a05:	c3                   	ret    

00801a06 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801a06:	55                   	push   %ebp
  801a07:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801a09:	6a 00                	push   $0x0
  801a0b:	6a 00                	push   $0x0
  801a0d:	6a 00                	push   $0x0
  801a0f:	6a 00                	push   $0x0
  801a11:	6a 00                	push   $0x0
  801a13:	6a 14                	push   $0x14
  801a15:	e8 0f fe ff ff       	call   801829 <syscall>
  801a1a:	83 c4 18             	add    $0x18,%esp
}
  801a1d:	90                   	nop
  801a1e:	c9                   	leave  
  801a1f:	c3                   	ret    

00801a20 <sys_create_shared_object>:

int sys_create_shared_object(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801a20:	55                   	push   %ebp
  801a21:	89 e5                	mov    %esp,%ebp
  801a23:	83 ec 04             	sub    $0x4,%esp
  801a26:	8b 45 10             	mov    0x10(%ebp),%eax
  801a29:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801a2c:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801a2f:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801a33:	8b 45 08             	mov    0x8(%ebp),%eax
  801a36:	6a 00                	push   $0x0
  801a38:	51                   	push   %ecx
  801a39:	52                   	push   %edx
  801a3a:	ff 75 0c             	pushl  0xc(%ebp)
  801a3d:	50                   	push   %eax
  801a3e:	6a 15                	push   $0x15
  801a40:	e8 e4 fd ff ff       	call   801829 <syscall>
  801a45:	83 c4 18             	add    $0x18,%esp
}
  801a48:	c9                   	leave  
  801a49:	c3                   	ret    

00801a4a <sys_size_of_shared_object>:

//2017:
int sys_size_of_shared_object(int32 ownerID, char* shareName)
{
  801a4a:	55                   	push   %ebp
  801a4b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801a4d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a50:	8b 45 08             	mov    0x8(%ebp),%eax
  801a53:	6a 00                	push   $0x0
  801a55:	6a 00                	push   $0x0
  801a57:	6a 00                	push   $0x0
  801a59:	52                   	push   %edx
  801a5a:	50                   	push   %eax
  801a5b:	6a 16                	push   $0x16
  801a5d:	e8 c7 fd ff ff       	call   801829 <syscall>
  801a62:	83 c4 18             	add    $0x18,%esp
}
  801a65:	c9                   	leave  
  801a66:	c3                   	ret    

00801a67 <sys_get_shared_object>:
//==========

int sys_get_shared_object(int32 ownerID, char* shareName, void* virtual_address)
{
  801a67:	55                   	push   %ebp
  801a68:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801a6a:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801a6d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a70:	8b 45 08             	mov    0x8(%ebp),%eax
  801a73:	6a 00                	push   $0x0
  801a75:	6a 00                	push   $0x0
  801a77:	51                   	push   %ecx
  801a78:	52                   	push   %edx
  801a79:	50                   	push   %eax
  801a7a:	6a 17                	push   $0x17
  801a7c:	e8 a8 fd ff ff       	call   801829 <syscall>
  801a81:	83 c4 18             	add    $0x18,%esp
}
  801a84:	c9                   	leave  
  801a85:	c3                   	ret    

00801a86 <sys_delete_shared_object>:

int sys_delete_shared_object(int32 sharedObjectID, void *startVA)
{
  801a86:	55                   	push   %ebp
  801a87:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801a89:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a8c:	8b 45 08             	mov    0x8(%ebp),%eax
  801a8f:	6a 00                	push   $0x0
  801a91:	6a 00                	push   $0x0
  801a93:	6a 00                	push   $0x0
  801a95:	52                   	push   %edx
  801a96:	50                   	push   %eax
  801a97:	6a 18                	push   $0x18
  801a99:	e8 8b fd ff ff       	call   801829 <syscall>
  801a9e:	83 c4 18             	add    $0x18,%esp
}
  801aa1:	c9                   	leave  
  801aa2:	c3                   	ret    

00801aa3 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801aa3:	55                   	push   %ebp
  801aa4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801aa6:	8b 45 08             	mov    0x8(%ebp),%eax
  801aa9:	6a 00                	push   $0x0
  801aab:	ff 75 14             	pushl  0x14(%ebp)
  801aae:	ff 75 10             	pushl  0x10(%ebp)
  801ab1:	ff 75 0c             	pushl  0xc(%ebp)
  801ab4:	50                   	push   %eax
  801ab5:	6a 19                	push   $0x19
  801ab7:	e8 6d fd ff ff       	call   801829 <syscall>
  801abc:	83 c4 18             	add    $0x18,%esp
}
  801abf:	c9                   	leave  
  801ac0:	c3                   	ret    

00801ac1 <sys_run_env>:

void sys_run_env(int32 envId)
{
  801ac1:	55                   	push   %ebp
  801ac2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801ac4:	8b 45 08             	mov    0x8(%ebp),%eax
  801ac7:	6a 00                	push   $0x0
  801ac9:	6a 00                	push   $0x0
  801acb:	6a 00                	push   $0x0
  801acd:	6a 00                	push   $0x0
  801acf:	50                   	push   %eax
  801ad0:	6a 1a                	push   $0x1a
  801ad2:	e8 52 fd ff ff       	call   801829 <syscall>
  801ad7:	83 c4 18             	add    $0x18,%esp
}
  801ada:	90                   	nop
  801adb:	c9                   	leave  
  801adc:	c3                   	ret    

00801add <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801add:	55                   	push   %ebp
  801ade:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801ae0:	8b 45 08             	mov    0x8(%ebp),%eax
  801ae3:	6a 00                	push   $0x0
  801ae5:	6a 00                	push   $0x0
  801ae7:	6a 00                	push   $0x0
  801ae9:	6a 00                	push   $0x0
  801aeb:	50                   	push   %eax
  801aec:	6a 1b                	push   $0x1b
  801aee:	e8 36 fd ff ff       	call   801829 <syscall>
  801af3:	83 c4 18             	add    $0x18,%esp
}
  801af6:	c9                   	leave  
  801af7:	c3                   	ret    

00801af8 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801af8:	55                   	push   %ebp
  801af9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801afb:	6a 00                	push   $0x0
  801afd:	6a 00                	push   $0x0
  801aff:	6a 00                	push   $0x0
  801b01:	6a 00                	push   $0x0
  801b03:	6a 00                	push   $0x0
  801b05:	6a 05                	push   $0x5
  801b07:	e8 1d fd ff ff       	call   801829 <syscall>
  801b0c:	83 c4 18             	add    $0x18,%esp
}
  801b0f:	c9                   	leave  
  801b10:	c3                   	ret    

00801b11 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801b11:	55                   	push   %ebp
  801b12:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801b14:	6a 00                	push   $0x0
  801b16:	6a 00                	push   $0x0
  801b18:	6a 00                	push   $0x0
  801b1a:	6a 00                	push   $0x0
  801b1c:	6a 00                	push   $0x0
  801b1e:	6a 06                	push   $0x6
  801b20:	e8 04 fd ff ff       	call   801829 <syscall>
  801b25:	83 c4 18             	add    $0x18,%esp
}
  801b28:	c9                   	leave  
  801b29:	c3                   	ret    

00801b2a <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801b2a:	55                   	push   %ebp
  801b2b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801b2d:	6a 00                	push   $0x0
  801b2f:	6a 00                	push   $0x0
  801b31:	6a 00                	push   $0x0
  801b33:	6a 00                	push   $0x0
  801b35:	6a 00                	push   $0x0
  801b37:	6a 07                	push   $0x7
  801b39:	e8 eb fc ff ff       	call   801829 <syscall>
  801b3e:	83 c4 18             	add    $0x18,%esp
}
  801b41:	c9                   	leave  
  801b42:	c3                   	ret    

00801b43 <sys_exit_env>:


void sys_exit_env(void)
{
  801b43:	55                   	push   %ebp
  801b44:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801b46:	6a 00                	push   $0x0
  801b48:	6a 00                	push   $0x0
  801b4a:	6a 00                	push   $0x0
  801b4c:	6a 00                	push   $0x0
  801b4e:	6a 00                	push   $0x0
  801b50:	6a 1c                	push   $0x1c
  801b52:	e8 d2 fc ff ff       	call   801829 <syscall>
  801b57:	83 c4 18             	add    $0x18,%esp
}
  801b5a:	90                   	nop
  801b5b:	c9                   	leave  
  801b5c:	c3                   	ret    

00801b5d <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  801b5d:	55                   	push   %ebp
  801b5e:	89 e5                	mov    %esp,%ebp
  801b60:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801b63:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801b66:	8d 50 04             	lea    0x4(%eax),%edx
  801b69:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801b6c:	6a 00                	push   $0x0
  801b6e:	6a 00                	push   $0x0
  801b70:	6a 00                	push   $0x0
  801b72:	52                   	push   %edx
  801b73:	50                   	push   %eax
  801b74:	6a 1d                	push   $0x1d
  801b76:	e8 ae fc ff ff       	call   801829 <syscall>
  801b7b:	83 c4 18             	add    $0x18,%esp
	return result;
  801b7e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801b81:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801b84:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801b87:	89 01                	mov    %eax,(%ecx)
  801b89:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801b8c:	8b 45 08             	mov    0x8(%ebp),%eax
  801b8f:	c9                   	leave  
  801b90:	c2 04 00             	ret    $0x4

00801b93 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801b93:	55                   	push   %ebp
  801b94:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801b96:	6a 00                	push   $0x0
  801b98:	6a 00                	push   $0x0
  801b9a:	ff 75 10             	pushl  0x10(%ebp)
  801b9d:	ff 75 0c             	pushl  0xc(%ebp)
  801ba0:	ff 75 08             	pushl  0x8(%ebp)
  801ba3:	6a 13                	push   $0x13
  801ba5:	e8 7f fc ff ff       	call   801829 <syscall>
  801baa:	83 c4 18             	add    $0x18,%esp
	return ;
  801bad:	90                   	nop
}
  801bae:	c9                   	leave  
  801baf:	c3                   	ret    

00801bb0 <sys_rcr2>:
uint32 sys_rcr2()
{
  801bb0:	55                   	push   %ebp
  801bb1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801bb3:	6a 00                	push   $0x0
  801bb5:	6a 00                	push   $0x0
  801bb7:	6a 00                	push   $0x0
  801bb9:	6a 00                	push   $0x0
  801bbb:	6a 00                	push   $0x0
  801bbd:	6a 1e                	push   $0x1e
  801bbf:	e8 65 fc ff ff       	call   801829 <syscall>
  801bc4:	83 c4 18             	add    $0x18,%esp
}
  801bc7:	c9                   	leave  
  801bc8:	c3                   	ret    

00801bc9 <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  801bc9:	55                   	push   %ebp
  801bca:	89 e5                	mov    %esp,%ebp
  801bcc:	83 ec 04             	sub    $0x4,%esp
  801bcf:	8b 45 08             	mov    0x8(%ebp),%eax
  801bd2:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801bd5:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801bd9:	6a 00                	push   $0x0
  801bdb:	6a 00                	push   $0x0
  801bdd:	6a 00                	push   $0x0
  801bdf:	6a 00                	push   $0x0
  801be1:	50                   	push   %eax
  801be2:	6a 1f                	push   $0x1f
  801be4:	e8 40 fc ff ff       	call   801829 <syscall>
  801be9:	83 c4 18             	add    $0x18,%esp
	return ;
  801bec:	90                   	nop
}
  801bed:	c9                   	leave  
  801bee:	c3                   	ret    

00801bef <rsttst>:
void rsttst()
{
  801bef:	55                   	push   %ebp
  801bf0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801bf2:	6a 00                	push   $0x0
  801bf4:	6a 00                	push   $0x0
  801bf6:	6a 00                	push   $0x0
  801bf8:	6a 00                	push   $0x0
  801bfa:	6a 00                	push   $0x0
  801bfc:	6a 21                	push   $0x21
  801bfe:	e8 26 fc ff ff       	call   801829 <syscall>
  801c03:	83 c4 18             	add    $0x18,%esp
	return ;
  801c06:	90                   	nop
}
  801c07:	c9                   	leave  
  801c08:	c3                   	ret    

00801c09 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801c09:	55                   	push   %ebp
  801c0a:	89 e5                	mov    %esp,%ebp
  801c0c:	83 ec 04             	sub    $0x4,%esp
  801c0f:	8b 45 14             	mov    0x14(%ebp),%eax
  801c12:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801c15:	8b 55 18             	mov    0x18(%ebp),%edx
  801c18:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801c1c:	52                   	push   %edx
  801c1d:	50                   	push   %eax
  801c1e:	ff 75 10             	pushl  0x10(%ebp)
  801c21:	ff 75 0c             	pushl  0xc(%ebp)
  801c24:	ff 75 08             	pushl  0x8(%ebp)
  801c27:	6a 20                	push   $0x20
  801c29:	e8 fb fb ff ff       	call   801829 <syscall>
  801c2e:	83 c4 18             	add    $0x18,%esp
	return ;
  801c31:	90                   	nop
}
  801c32:	c9                   	leave  
  801c33:	c3                   	ret    

00801c34 <chktst>:
void chktst(uint32 n)
{
  801c34:	55                   	push   %ebp
  801c35:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801c37:	6a 00                	push   $0x0
  801c39:	6a 00                	push   $0x0
  801c3b:	6a 00                	push   $0x0
  801c3d:	6a 00                	push   $0x0
  801c3f:	ff 75 08             	pushl  0x8(%ebp)
  801c42:	6a 22                	push   $0x22
  801c44:	e8 e0 fb ff ff       	call   801829 <syscall>
  801c49:	83 c4 18             	add    $0x18,%esp
	return ;
  801c4c:	90                   	nop
}
  801c4d:	c9                   	leave  
  801c4e:	c3                   	ret    

00801c4f <inctst>:

void inctst()
{
  801c4f:	55                   	push   %ebp
  801c50:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801c52:	6a 00                	push   $0x0
  801c54:	6a 00                	push   $0x0
  801c56:	6a 00                	push   $0x0
  801c58:	6a 00                	push   $0x0
  801c5a:	6a 00                	push   $0x0
  801c5c:	6a 23                	push   $0x23
  801c5e:	e8 c6 fb ff ff       	call   801829 <syscall>
  801c63:	83 c4 18             	add    $0x18,%esp
	return ;
  801c66:	90                   	nop
}
  801c67:	c9                   	leave  
  801c68:	c3                   	ret    

00801c69 <gettst>:
uint32 gettst()
{
  801c69:	55                   	push   %ebp
  801c6a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801c6c:	6a 00                	push   $0x0
  801c6e:	6a 00                	push   $0x0
  801c70:	6a 00                	push   $0x0
  801c72:	6a 00                	push   $0x0
  801c74:	6a 00                	push   $0x0
  801c76:	6a 24                	push   $0x24
  801c78:	e8 ac fb ff ff       	call   801829 <syscall>
  801c7d:	83 c4 18             	add    $0x18,%esp
}
  801c80:	c9                   	leave  
  801c81:	c3                   	ret    

00801c82 <sys_get_uheap_strategy>:

/*2025*/
uint32 sys_get_uheap_strategy()
{
  801c82:	55                   	push   %ebp
  801c83:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801c85:	6a 00                	push   $0x0
  801c87:	6a 00                	push   $0x0
  801c89:	6a 00                	push   $0x0
  801c8b:	6a 00                	push   $0x0
  801c8d:	6a 00                	push   $0x0
  801c8f:	6a 25                	push   $0x25
  801c91:	e8 93 fb ff ff       	call   801829 <syscall>
  801c96:	83 c4 18             	add    $0x18,%esp
  801c99:	a3 60 b0 81 00       	mov    %eax,0x81b060
	return uheapPlaceStrategy ;
  801c9e:	a1 60 b0 81 00       	mov    0x81b060,%eax
}
  801ca3:	c9                   	leave  
  801ca4:	c3                   	ret    

00801ca5 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801ca5:	55                   	push   %ebp
  801ca6:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = heapStrategy;
  801ca8:	8b 45 08             	mov    0x8(%ebp),%eax
  801cab:	a3 60 b0 81 00       	mov    %eax,0x81b060
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801cb0:	6a 00                	push   $0x0
  801cb2:	6a 00                	push   $0x0
  801cb4:	6a 00                	push   $0x0
  801cb6:	6a 00                	push   $0x0
  801cb8:	ff 75 08             	pushl  0x8(%ebp)
  801cbb:	6a 26                	push   $0x26
  801cbd:	e8 67 fb ff ff       	call   801829 <syscall>
  801cc2:	83 c4 18             	add    $0x18,%esp
	return ;
  801cc5:	90                   	nop
}
  801cc6:	c9                   	leave  
  801cc7:	c3                   	ret    

00801cc8 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801cc8:	55                   	push   %ebp
  801cc9:	89 e5                	mov    %esp,%ebp
  801ccb:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801ccc:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801ccf:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801cd2:	8b 55 0c             	mov    0xc(%ebp),%edx
  801cd5:	8b 45 08             	mov    0x8(%ebp),%eax
  801cd8:	6a 00                	push   $0x0
  801cda:	53                   	push   %ebx
  801cdb:	51                   	push   %ecx
  801cdc:	52                   	push   %edx
  801cdd:	50                   	push   %eax
  801cde:	6a 27                	push   $0x27
  801ce0:	e8 44 fb ff ff       	call   801829 <syscall>
  801ce5:	83 c4 18             	add    $0x18,%esp
}
  801ce8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801ceb:	c9                   	leave  
  801cec:	c3                   	ret    

00801ced <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801ced:	55                   	push   %ebp
  801cee:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801cf0:	8b 55 0c             	mov    0xc(%ebp),%edx
  801cf3:	8b 45 08             	mov    0x8(%ebp),%eax
  801cf6:	6a 00                	push   $0x0
  801cf8:	6a 00                	push   $0x0
  801cfa:	6a 00                	push   $0x0
  801cfc:	52                   	push   %edx
  801cfd:	50                   	push   %eax
  801cfe:	6a 28                	push   $0x28
  801d00:	e8 24 fb ff ff       	call   801829 <syscall>
  801d05:	83 c4 18             	add    $0x18,%esp
}
  801d08:	c9                   	leave  
  801d09:	c3                   	ret    

00801d0a <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  801d0a:	55                   	push   %ebp
  801d0b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  801d0d:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801d10:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d13:	8b 45 08             	mov    0x8(%ebp),%eax
  801d16:	6a 00                	push   $0x0
  801d18:	51                   	push   %ecx
  801d19:	ff 75 10             	pushl  0x10(%ebp)
  801d1c:	52                   	push   %edx
  801d1d:	50                   	push   %eax
  801d1e:	6a 29                	push   $0x29
  801d20:	e8 04 fb ff ff       	call   801829 <syscall>
  801d25:	83 c4 18             	add    $0x18,%esp
}
  801d28:	c9                   	leave  
  801d29:	c3                   	ret    

00801d2a <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801d2a:	55                   	push   %ebp
  801d2b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801d2d:	6a 00                	push   $0x0
  801d2f:	6a 00                	push   $0x0
  801d31:	ff 75 10             	pushl  0x10(%ebp)
  801d34:	ff 75 0c             	pushl  0xc(%ebp)
  801d37:	ff 75 08             	pushl  0x8(%ebp)
  801d3a:	6a 12                	push   $0x12
  801d3c:	e8 e8 fa ff ff       	call   801829 <syscall>
  801d41:	83 c4 18             	add    $0x18,%esp
	return ;
  801d44:	90                   	nop
}
  801d45:	c9                   	leave  
  801d46:	c3                   	ret    

00801d47 <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  801d47:	55                   	push   %ebp
  801d48:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  801d4a:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d4d:	8b 45 08             	mov    0x8(%ebp),%eax
  801d50:	6a 00                	push   $0x0
  801d52:	6a 00                	push   $0x0
  801d54:	6a 00                	push   $0x0
  801d56:	52                   	push   %edx
  801d57:	50                   	push   %eax
  801d58:	6a 2a                	push   $0x2a
  801d5a:	e8 ca fa ff ff       	call   801829 <syscall>
  801d5f:	83 c4 18             	add    $0x18,%esp
	return;
  801d62:	90                   	nop
}
  801d63:	c9                   	leave  
  801d64:	c3                   	ret    

00801d65 <sys_get_optimal_num_faults>:
/*2025*/
int sys_get_optimal_num_faults()
{
  801d65:	55                   	push   %ebp
  801d66:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_optimal_num_faults, 0, 0, 0, 0, 0);
  801d68:	6a 00                	push   $0x0
  801d6a:	6a 00                	push   $0x0
  801d6c:	6a 00                	push   $0x0
  801d6e:	6a 00                	push   $0x0
  801d70:	6a 00                	push   $0x0
  801d72:	6a 2b                	push   $0x2b
  801d74:	e8 b0 fa ff ff       	call   801829 <syscall>
  801d79:	83 c4 18             	add    $0x18,%esp
}
  801d7c:	c9                   	leave  
  801d7d:	c3                   	ret    

00801d7e <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801d7e:	55                   	push   %ebp
  801d7f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801d81:	6a 00                	push   $0x0
  801d83:	6a 00                	push   $0x0
  801d85:	6a 00                	push   $0x0
  801d87:	ff 75 0c             	pushl  0xc(%ebp)
  801d8a:	ff 75 08             	pushl  0x8(%ebp)
  801d8d:	6a 2d                	push   $0x2d
  801d8f:	e8 95 fa ff ff       	call   801829 <syscall>
  801d94:	83 c4 18             	add    $0x18,%esp
	return;
  801d97:	90                   	nop
}
  801d98:	c9                   	leave  
  801d99:	c3                   	ret    

00801d9a <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801d9a:	55                   	push   %ebp
  801d9b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801d9d:	6a 00                	push   $0x0
  801d9f:	6a 00                	push   $0x0
  801da1:	6a 00                	push   $0x0
  801da3:	ff 75 0c             	pushl  0xc(%ebp)
  801da6:	ff 75 08             	pushl  0x8(%ebp)
  801da9:	6a 2c                	push   $0x2c
  801dab:	e8 79 fa ff ff       	call   801829 <syscall>
  801db0:	83 c4 18             	add    $0x18,%esp
	return ;
  801db3:	90                   	nop
}
  801db4:	c9                   	leave  
  801db5:	c3                   	ret    

00801db6 <sys_env_set_priority>:


void sys_env_set_priority(int32 envID, int priority)
{
  801db6:	55                   	push   %ebp
  801db7:	89 e5                	mov    %esp,%ebp
  801db9:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.IM#4] CPU SCHEDULING - #1 System Calls - Add suitable code here
	//Your code is here
	//Comment the following line
	panic("sys_env_set_priority() is not implemented yet...!!");
  801dbc:	83 ec 04             	sub    $0x4,%esp
  801dbf:	68 3c 2a 80 00       	push   $0x802a3c
  801dc4:	68 25 01 00 00       	push   $0x125
  801dc9:	68 6f 2a 80 00       	push   $0x802a6f
  801dce:	e8 9b e6 ff ff       	call   80046e <_panic>

00801dd3 <env_sleep>:
#include <inc/lib.h>
#include <inc/timerreg.h>

void
env_sleep(uint32 approxMilliSeconds)
{
  801dd3:	55                   	push   %ebp
  801dd4:	89 e5                	mov    %esp,%ebp
  801dd6:	83 ec 30             	sub    $0x30,%esp
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
  801dd9:	8b 55 08             	mov    0x8(%ebp),%edx
  801ddc:	89 d0                	mov    %edx,%eax
  801dde:	c1 e0 02             	shl    $0x2,%eax
  801de1:	01 d0                	add    %edx,%eax
  801de3:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801dea:	01 d0                	add    %edx,%eax
  801dec:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801df3:	01 d0                	add    %edx,%eax
  801df5:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801dfc:	01 d0                	add    %edx,%eax
  801dfe:	c1 e0 04             	shl    $0x4,%eax
  801e01:	89 45 f8             	mov    %eax,-0x8(%ebp)
	uint32 cycles_counter =0;
  801e04:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)

static inline __attribute__((always_inline)) struct uint64 get_virtual_time_user()
{
	struct uint64 result;

	__asm __volatile("rdtsc\n"
  801e0b:	0f 31                	rdtsc  
  801e0d:	89 45 e8             	mov    %eax,-0x18(%ebp)
  801e10:	89 55 ec             	mov    %edx,-0x14(%ebp)
	: "=a" (result.low), "=d" (result.hi)
	);

	return result;
  801e13:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801e16:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801e19:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801e1c:	89 55 f4             	mov    %edx,-0xc(%ebp)

	/*2024*/ //USE A USER-SIDE VERSION OF THIS FUNCTION TO AVOID SLOW-DOWN THE PERFORMANCE DUE SYS_CALL (el7 :))
	//struct uint64 baseTime = sys_get_virtual_time() ;
	struct uint64 baseTime = get_virtual_time_user() ;
	while(cycles_counter<time_in_cycles)
  801e1f:	eb 46                	jmp    801e67 <env_sleep+0x94>

static inline __attribute__((always_inline)) struct uint64 get_virtual_time_user()
{
	struct uint64 result;

	__asm __volatile("rdtsc\n"
  801e21:	0f 31                	rdtsc  
  801e23:	89 45 d0             	mov    %eax,-0x30(%ebp)
  801e26:	89 55 d4             	mov    %edx,-0x2c(%ebp)
	: "=a" (result.low), "=d" (result.hi)
	);

	return result;
  801e29:	8b 45 d0             	mov    -0x30(%ebp),%eax
  801e2c:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  801e2f:	89 45 e0             	mov    %eax,-0x20(%ebp)
  801e32:	89 55 e4             	mov    %edx,-0x1c(%ebp)

		// update the cycles_count
		#define M32 0xffffffff
		// subtract basetime from current time
		struct uint64 res;
		res.low = (currentTime.low - baseTime.low) & M32;
  801e35:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801e38:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e3b:	29 c2                	sub    %eax,%edx
  801e3d:	89 d0                	mov    %edx,%eax
  801e3f:	89 45 d8             	mov    %eax,-0x28(%ebp)
		res.hi = (currentTime.hi - baseTime.hi - (res.low > currentTime.low)) & M32;
  801e42:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801e45:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e48:	89 d1                	mov    %edx,%ecx
  801e4a:	29 c1                	sub    %eax,%ecx
  801e4c:	8b 55 d8             	mov    -0x28(%ebp),%edx
  801e4f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801e52:	39 c2                	cmp    %eax,%edx
  801e54:	0f 97 c0             	seta   %al
  801e57:	0f b6 c0             	movzbl %al,%eax
  801e5a:	29 c1                	sub    %eax,%ecx
  801e5c:	89 c8                	mov    %ecx,%eax
  801e5e:	89 45 dc             	mov    %eax,-0x24(%ebp)

		//update cycles_count with result
		cycles_counter = res.low;
  801e61:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801e64:	89 45 fc             	mov    %eax,-0x4(%ebp)
	uint32 cycles_counter =0;

	/*2024*/ //USE A USER-SIDE VERSION OF THIS FUNCTION TO AVOID SLOW-DOWN THE PERFORMANCE DUE SYS_CALL (el7 :))
	//struct uint64 baseTime = sys_get_virtual_time() ;
	struct uint64 baseTime = get_virtual_time_user() ;
	while(cycles_counter<time_in_cycles)
  801e67:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801e6a:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801e6d:	72 b2                	jb     801e21 <env_sleep+0x4e>
//				,cycles_counter
//				);
	}
	//cprintf("%s [%d] wake up now!\n", myEnv->prog_name, myEnv->env_id);

}
  801e6f:	90                   	nop
  801e70:	c9                   	leave  
  801e71:	c3                   	ret    

00801e72 <busy_wait>:

//2017
uint32 busy_wait(uint32 loopMax)
{
  801e72:	55                   	push   %ebp
  801e73:	89 e5                	mov    %esp,%ebp
  801e75:	83 ec 10             	sub    $0x10,%esp
	uint32 i = 0 ;
  801e78:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	while (i < loopMax) i++;
  801e7f:	eb 03                	jmp    801e84 <busy_wait+0x12>
  801e81:	ff 45 fc             	incl   -0x4(%ebp)
  801e84:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801e87:	3b 45 08             	cmp    0x8(%ebp),%eax
  801e8a:	72 f5                	jb     801e81 <busy_wait+0xf>
	return i;
  801e8c:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801e8f:	c9                   	leave  
  801e90:	c3                   	ret    

00801e91 <cputchar>:
#include <inc/lib.h>


void
cputchar(int ch)
{
  801e91:	55                   	push   %ebp
  801e92:	89 e5                	mov    %esp,%ebp
  801e94:	83 ec 18             	sub    $0x18,%esp
	char c = ch;
  801e97:	8b 45 08             	mov    0x8(%ebp),%eax
  801e9a:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	//sys_cputs(&c, 1);

	sys_cputc(c);
  801e9d:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  801ea1:	83 ec 0c             	sub    $0xc,%esp
  801ea4:	50                   	push   %eax
  801ea5:	e8 36 fb ff ff       	call   8019e0 <sys_cputc>
  801eaa:	83 c4 10             	add    $0x10,%esp
}
  801ead:	90                   	nop
  801eae:	c9                   	leave  
  801eaf:	c3                   	ret    

00801eb0 <getchar>:


int
getchar(void)
{
  801eb0:	55                   	push   %ebp
  801eb1:	89 e5                	mov    %esp,%ebp
  801eb3:	83 ec 18             	sub    $0x18,%esp
	int c =sys_cgetc();
  801eb6:	e8 c4 f9 ff ff       	call   80187f <sys_cgetc>
  801ebb:	89 45 f4             	mov    %eax,-0xc(%ebp)
	return c;
  801ebe:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  801ec1:	c9                   	leave  
  801ec2:	c3                   	ret    

00801ec3 <iscons>:

int iscons(int fdnum)
{
  801ec3:	55                   	push   %ebp
  801ec4:	89 e5                	mov    %esp,%ebp
	// used by readline
	return 1;
  801ec6:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801ecb:	5d                   	pop    %ebp
  801ecc:	c3                   	ret    
  801ecd:	66 90                	xchg   %ax,%ax
  801ecf:	90                   	nop

00801ed0 <__udivdi3>:
  801ed0:	55                   	push   %ebp
  801ed1:	57                   	push   %edi
  801ed2:	56                   	push   %esi
  801ed3:	53                   	push   %ebx
  801ed4:	83 ec 1c             	sub    $0x1c,%esp
  801ed7:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  801edb:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  801edf:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801ee3:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801ee7:	89 ca                	mov    %ecx,%edx
  801ee9:	89 f8                	mov    %edi,%eax
  801eeb:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  801eef:	85 f6                	test   %esi,%esi
  801ef1:	75 2d                	jne    801f20 <__udivdi3+0x50>
  801ef3:	39 cf                	cmp    %ecx,%edi
  801ef5:	77 65                	ja     801f5c <__udivdi3+0x8c>
  801ef7:	89 fd                	mov    %edi,%ebp
  801ef9:	85 ff                	test   %edi,%edi
  801efb:	75 0b                	jne    801f08 <__udivdi3+0x38>
  801efd:	b8 01 00 00 00       	mov    $0x1,%eax
  801f02:	31 d2                	xor    %edx,%edx
  801f04:	f7 f7                	div    %edi
  801f06:	89 c5                	mov    %eax,%ebp
  801f08:	31 d2                	xor    %edx,%edx
  801f0a:	89 c8                	mov    %ecx,%eax
  801f0c:	f7 f5                	div    %ebp
  801f0e:	89 c1                	mov    %eax,%ecx
  801f10:	89 d8                	mov    %ebx,%eax
  801f12:	f7 f5                	div    %ebp
  801f14:	89 cf                	mov    %ecx,%edi
  801f16:	89 fa                	mov    %edi,%edx
  801f18:	83 c4 1c             	add    $0x1c,%esp
  801f1b:	5b                   	pop    %ebx
  801f1c:	5e                   	pop    %esi
  801f1d:	5f                   	pop    %edi
  801f1e:	5d                   	pop    %ebp
  801f1f:	c3                   	ret    
  801f20:	39 ce                	cmp    %ecx,%esi
  801f22:	77 28                	ja     801f4c <__udivdi3+0x7c>
  801f24:	0f bd fe             	bsr    %esi,%edi
  801f27:	83 f7 1f             	xor    $0x1f,%edi
  801f2a:	75 40                	jne    801f6c <__udivdi3+0x9c>
  801f2c:	39 ce                	cmp    %ecx,%esi
  801f2e:	72 0a                	jb     801f3a <__udivdi3+0x6a>
  801f30:	3b 44 24 08          	cmp    0x8(%esp),%eax
  801f34:	0f 87 9e 00 00 00    	ja     801fd8 <__udivdi3+0x108>
  801f3a:	b8 01 00 00 00       	mov    $0x1,%eax
  801f3f:	89 fa                	mov    %edi,%edx
  801f41:	83 c4 1c             	add    $0x1c,%esp
  801f44:	5b                   	pop    %ebx
  801f45:	5e                   	pop    %esi
  801f46:	5f                   	pop    %edi
  801f47:	5d                   	pop    %ebp
  801f48:	c3                   	ret    
  801f49:	8d 76 00             	lea    0x0(%esi),%esi
  801f4c:	31 ff                	xor    %edi,%edi
  801f4e:	31 c0                	xor    %eax,%eax
  801f50:	89 fa                	mov    %edi,%edx
  801f52:	83 c4 1c             	add    $0x1c,%esp
  801f55:	5b                   	pop    %ebx
  801f56:	5e                   	pop    %esi
  801f57:	5f                   	pop    %edi
  801f58:	5d                   	pop    %ebp
  801f59:	c3                   	ret    
  801f5a:	66 90                	xchg   %ax,%ax
  801f5c:	89 d8                	mov    %ebx,%eax
  801f5e:	f7 f7                	div    %edi
  801f60:	31 ff                	xor    %edi,%edi
  801f62:	89 fa                	mov    %edi,%edx
  801f64:	83 c4 1c             	add    $0x1c,%esp
  801f67:	5b                   	pop    %ebx
  801f68:	5e                   	pop    %esi
  801f69:	5f                   	pop    %edi
  801f6a:	5d                   	pop    %ebp
  801f6b:	c3                   	ret    
  801f6c:	bd 20 00 00 00       	mov    $0x20,%ebp
  801f71:	89 eb                	mov    %ebp,%ebx
  801f73:	29 fb                	sub    %edi,%ebx
  801f75:	89 f9                	mov    %edi,%ecx
  801f77:	d3 e6                	shl    %cl,%esi
  801f79:	89 c5                	mov    %eax,%ebp
  801f7b:	88 d9                	mov    %bl,%cl
  801f7d:	d3 ed                	shr    %cl,%ebp
  801f7f:	89 e9                	mov    %ebp,%ecx
  801f81:	09 f1                	or     %esi,%ecx
  801f83:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  801f87:	89 f9                	mov    %edi,%ecx
  801f89:	d3 e0                	shl    %cl,%eax
  801f8b:	89 c5                	mov    %eax,%ebp
  801f8d:	89 d6                	mov    %edx,%esi
  801f8f:	88 d9                	mov    %bl,%cl
  801f91:	d3 ee                	shr    %cl,%esi
  801f93:	89 f9                	mov    %edi,%ecx
  801f95:	d3 e2                	shl    %cl,%edx
  801f97:	8b 44 24 08          	mov    0x8(%esp),%eax
  801f9b:	88 d9                	mov    %bl,%cl
  801f9d:	d3 e8                	shr    %cl,%eax
  801f9f:	09 c2                	or     %eax,%edx
  801fa1:	89 d0                	mov    %edx,%eax
  801fa3:	89 f2                	mov    %esi,%edx
  801fa5:	f7 74 24 0c          	divl   0xc(%esp)
  801fa9:	89 d6                	mov    %edx,%esi
  801fab:	89 c3                	mov    %eax,%ebx
  801fad:	f7 e5                	mul    %ebp
  801faf:	39 d6                	cmp    %edx,%esi
  801fb1:	72 19                	jb     801fcc <__udivdi3+0xfc>
  801fb3:	74 0b                	je     801fc0 <__udivdi3+0xf0>
  801fb5:	89 d8                	mov    %ebx,%eax
  801fb7:	31 ff                	xor    %edi,%edi
  801fb9:	e9 58 ff ff ff       	jmp    801f16 <__udivdi3+0x46>
  801fbe:	66 90                	xchg   %ax,%ax
  801fc0:	8b 54 24 08          	mov    0x8(%esp),%edx
  801fc4:	89 f9                	mov    %edi,%ecx
  801fc6:	d3 e2                	shl    %cl,%edx
  801fc8:	39 c2                	cmp    %eax,%edx
  801fca:	73 e9                	jae    801fb5 <__udivdi3+0xe5>
  801fcc:	8d 43 ff             	lea    -0x1(%ebx),%eax
  801fcf:	31 ff                	xor    %edi,%edi
  801fd1:	e9 40 ff ff ff       	jmp    801f16 <__udivdi3+0x46>
  801fd6:	66 90                	xchg   %ax,%ax
  801fd8:	31 c0                	xor    %eax,%eax
  801fda:	e9 37 ff ff ff       	jmp    801f16 <__udivdi3+0x46>
  801fdf:	90                   	nop

00801fe0 <__umoddi3>:
  801fe0:	55                   	push   %ebp
  801fe1:	57                   	push   %edi
  801fe2:	56                   	push   %esi
  801fe3:	53                   	push   %ebx
  801fe4:	83 ec 1c             	sub    $0x1c,%esp
  801fe7:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  801feb:	8b 74 24 34          	mov    0x34(%esp),%esi
  801fef:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801ff3:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  801ff7:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801ffb:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801fff:	89 f3                	mov    %esi,%ebx
  802001:	89 fa                	mov    %edi,%edx
  802003:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  802007:	89 34 24             	mov    %esi,(%esp)
  80200a:	85 c0                	test   %eax,%eax
  80200c:	75 1a                	jne    802028 <__umoddi3+0x48>
  80200e:	39 f7                	cmp    %esi,%edi
  802010:	0f 86 a2 00 00 00    	jbe    8020b8 <__umoddi3+0xd8>
  802016:	89 c8                	mov    %ecx,%eax
  802018:	89 f2                	mov    %esi,%edx
  80201a:	f7 f7                	div    %edi
  80201c:	89 d0                	mov    %edx,%eax
  80201e:	31 d2                	xor    %edx,%edx
  802020:	83 c4 1c             	add    $0x1c,%esp
  802023:	5b                   	pop    %ebx
  802024:	5e                   	pop    %esi
  802025:	5f                   	pop    %edi
  802026:	5d                   	pop    %ebp
  802027:	c3                   	ret    
  802028:	39 f0                	cmp    %esi,%eax
  80202a:	0f 87 ac 00 00 00    	ja     8020dc <__umoddi3+0xfc>
  802030:	0f bd e8             	bsr    %eax,%ebp
  802033:	83 f5 1f             	xor    $0x1f,%ebp
  802036:	0f 84 ac 00 00 00    	je     8020e8 <__umoddi3+0x108>
  80203c:	bf 20 00 00 00       	mov    $0x20,%edi
  802041:	29 ef                	sub    %ebp,%edi
  802043:	89 fe                	mov    %edi,%esi
  802045:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802049:	89 e9                	mov    %ebp,%ecx
  80204b:	d3 e0                	shl    %cl,%eax
  80204d:	89 d7                	mov    %edx,%edi
  80204f:	89 f1                	mov    %esi,%ecx
  802051:	d3 ef                	shr    %cl,%edi
  802053:	09 c7                	or     %eax,%edi
  802055:	89 e9                	mov    %ebp,%ecx
  802057:	d3 e2                	shl    %cl,%edx
  802059:	89 14 24             	mov    %edx,(%esp)
  80205c:	89 d8                	mov    %ebx,%eax
  80205e:	d3 e0                	shl    %cl,%eax
  802060:	89 c2                	mov    %eax,%edx
  802062:	8b 44 24 08          	mov    0x8(%esp),%eax
  802066:	d3 e0                	shl    %cl,%eax
  802068:	89 44 24 04          	mov    %eax,0x4(%esp)
  80206c:	8b 44 24 08          	mov    0x8(%esp),%eax
  802070:	89 f1                	mov    %esi,%ecx
  802072:	d3 e8                	shr    %cl,%eax
  802074:	09 d0                	or     %edx,%eax
  802076:	d3 eb                	shr    %cl,%ebx
  802078:	89 da                	mov    %ebx,%edx
  80207a:	f7 f7                	div    %edi
  80207c:	89 d3                	mov    %edx,%ebx
  80207e:	f7 24 24             	mull   (%esp)
  802081:	89 c6                	mov    %eax,%esi
  802083:	89 d1                	mov    %edx,%ecx
  802085:	39 d3                	cmp    %edx,%ebx
  802087:	0f 82 87 00 00 00    	jb     802114 <__umoddi3+0x134>
  80208d:	0f 84 91 00 00 00    	je     802124 <__umoddi3+0x144>
  802093:	8b 54 24 04          	mov    0x4(%esp),%edx
  802097:	29 f2                	sub    %esi,%edx
  802099:	19 cb                	sbb    %ecx,%ebx
  80209b:	89 d8                	mov    %ebx,%eax
  80209d:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  8020a1:	d3 e0                	shl    %cl,%eax
  8020a3:	89 e9                	mov    %ebp,%ecx
  8020a5:	d3 ea                	shr    %cl,%edx
  8020a7:	09 d0                	or     %edx,%eax
  8020a9:	89 e9                	mov    %ebp,%ecx
  8020ab:	d3 eb                	shr    %cl,%ebx
  8020ad:	89 da                	mov    %ebx,%edx
  8020af:	83 c4 1c             	add    $0x1c,%esp
  8020b2:	5b                   	pop    %ebx
  8020b3:	5e                   	pop    %esi
  8020b4:	5f                   	pop    %edi
  8020b5:	5d                   	pop    %ebp
  8020b6:	c3                   	ret    
  8020b7:	90                   	nop
  8020b8:	89 fd                	mov    %edi,%ebp
  8020ba:	85 ff                	test   %edi,%edi
  8020bc:	75 0b                	jne    8020c9 <__umoddi3+0xe9>
  8020be:	b8 01 00 00 00       	mov    $0x1,%eax
  8020c3:	31 d2                	xor    %edx,%edx
  8020c5:	f7 f7                	div    %edi
  8020c7:	89 c5                	mov    %eax,%ebp
  8020c9:	89 f0                	mov    %esi,%eax
  8020cb:	31 d2                	xor    %edx,%edx
  8020cd:	f7 f5                	div    %ebp
  8020cf:	89 c8                	mov    %ecx,%eax
  8020d1:	f7 f5                	div    %ebp
  8020d3:	89 d0                	mov    %edx,%eax
  8020d5:	e9 44 ff ff ff       	jmp    80201e <__umoddi3+0x3e>
  8020da:	66 90                	xchg   %ax,%ax
  8020dc:	89 c8                	mov    %ecx,%eax
  8020de:	89 f2                	mov    %esi,%edx
  8020e0:	83 c4 1c             	add    $0x1c,%esp
  8020e3:	5b                   	pop    %ebx
  8020e4:	5e                   	pop    %esi
  8020e5:	5f                   	pop    %edi
  8020e6:	5d                   	pop    %ebp
  8020e7:	c3                   	ret    
  8020e8:	3b 04 24             	cmp    (%esp),%eax
  8020eb:	72 06                	jb     8020f3 <__umoddi3+0x113>
  8020ed:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  8020f1:	77 0f                	ja     802102 <__umoddi3+0x122>
  8020f3:	89 f2                	mov    %esi,%edx
  8020f5:	29 f9                	sub    %edi,%ecx
  8020f7:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  8020fb:	89 14 24             	mov    %edx,(%esp)
  8020fe:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  802102:	8b 44 24 04          	mov    0x4(%esp),%eax
  802106:	8b 14 24             	mov    (%esp),%edx
  802109:	83 c4 1c             	add    $0x1c,%esp
  80210c:	5b                   	pop    %ebx
  80210d:	5e                   	pop    %esi
  80210e:	5f                   	pop    %edi
  80210f:	5d                   	pop    %ebp
  802110:	c3                   	ret    
  802111:	8d 76 00             	lea    0x0(%esi),%esi
  802114:	2b 04 24             	sub    (%esp),%eax
  802117:	19 fa                	sbb    %edi,%edx
  802119:	89 d1                	mov    %edx,%ecx
  80211b:	89 c6                	mov    %eax,%esi
  80211d:	e9 71 ff ff ff       	jmp    802093 <__umoddi3+0xb3>
  802122:	66 90                	xchg   %ax,%ax
  802124:	39 44 24 04          	cmp    %eax,0x4(%esp)
  802128:	72 ea                	jb     802114 <__umoddi3+0x134>
  80212a:	89 d9                	mov    %ebx,%ecx
  80212c:	e9 62 ff ff ff       	jmp    802093 <__umoddi3+0xb3>
