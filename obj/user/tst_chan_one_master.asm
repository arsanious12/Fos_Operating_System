
obj/user/tst_chan_one_master:     file format elf32-i386


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
  800031:	e8 97 02 00 00       	call   8002cd <libmain>
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
  80003e:	81 ec 3c 01 00 00    	sub    $0x13c,%esp
	cprintf_colored(TEXT_yellow,"==============================================\n");
  800044:	83 ec 08             	sub    $0x8,%esp
  800047:	68 60 21 80 00       	push   $0x802160
  80004c:	6a 0e                	push   $0xe
  80004e:	e8 3a 07 00 00       	call   80078d <cprintf_colored>
  800053:	83 c4 10             	add    $0x10,%esp
	cprintf_colored(TEXT_yellow,"MAKE SURE to have a FRESH RUN for this test\n(i.e. don't run any program/test before it)\n");
  800056:	83 ec 08             	sub    $0x8,%esp
  800059:	68 90 21 80 00       	push   $0x802190
  80005e:	6a 0e                	push   $0xe
  800060:	e8 28 07 00 00       	call   80078d <cprintf_colored>
  800065:	83 c4 10             	add    $0x10,%esp
	cprintf_colored(TEXT_yellow,"==============================================\n");
  800068:	83 ec 08             	sub    $0x8,%esp
  80006b:	68 60 21 80 00       	push   $0x802160
  800070:	6a 0e                	push   $0xe
  800072:	e8 16 07 00 00       	call   80078d <cprintf_colored>
  800077:	83 c4 10             	add    $0x10,%esp

	int envID = sys_getenvid();
  80007a:	e8 9d 1a 00 00       	call   801b1c <sys_getenvid>
  80007f:	89 45 dc             	mov    %eax,-0x24(%ebp)
	char slavesCnt[10];
	readline("Enter the number of Slave Programs: ", slavesCnt);
  800082:	83 ec 08             	sub    $0x8,%esp
  800085:	8d 45 ce             	lea    -0x32(%ebp),%eax
  800088:	50                   	push   %eax
  800089:	68 ec 21 80 00       	push   $0x8021ec
  80008e:	e8 a6 0d 00 00       	call   800e39 <readline>
  800093:	83 c4 10             	add    $0x10,%esp
	int numOfSlaves = strtol(slavesCnt, NULL, 10);
  800096:	83 ec 04             	sub    $0x4,%esp
  800099:	6a 0a                	push   $0xa
  80009b:	6a 00                	push   $0x0
  80009d:	8d 45 ce             	lea    -0x32(%ebp),%eax
  8000a0:	50                   	push   %eax
  8000a1:	e8 aa 13 00 00       	call   801450 <strtol>
  8000a6:	83 c4 10             	add    $0x10,%esp
  8000a9:	89 45 c8             	mov    %eax,-0x38(%ebp)

	//Save number of slaved to be checked later
	char cmd1[64] = "__NumOfSlaves@Set";
  8000ac:	8d 45 88             	lea    -0x78(%ebp),%eax
  8000af:	bb 76 23 80 00       	mov    $0x802376,%ebx
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
  8000da:	e8 8c 1c 00 00       	call   801d6b <sys_utilities>
  8000df:	83 c4 10             	add    $0x10,%esp

	//Create and run slave programs that should sleep
	int id;
	for (int i = 0; i < numOfSlaves; ++i)
  8000e2:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  8000e9:	eb 6a                	jmp    800155 <_main+0x11d>
	{
		id = sys_create_env("tstChanOneSlave", (myEnv->page_WS_max_size),(myEnv->SecondListSize), (myEnv->percentage_of_WS_pages_to_be_removed));
  8000eb:	a1 20 30 80 00       	mov    0x803020,%eax
  8000f0:	8b 90 3c da 01 00    	mov    0x1da3c(%eax),%edx
  8000f6:	a1 20 30 80 00       	mov    0x803020,%eax
  8000fb:	8b 80 34 da 01 00    	mov    0x1da34(%eax),%eax
  800101:	89 c1                	mov    %eax,%ecx
  800103:	a1 20 30 80 00       	mov    0x803020,%eax
  800108:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
  80010e:	52                   	push   %edx
  80010f:	51                   	push   %ecx
  800110:	50                   	push   %eax
  800111:	68 11 22 80 00       	push   $0x802211
  800116:	e8 ac 19 00 00       	call   801ac7 <sys_create_env>
  80011b:	83 c4 10             	add    $0x10,%esp
  80011e:	89 45 d8             	mov    %eax,-0x28(%ebp)
		if (id== E_ENV_CREATION_ERROR)
  800121:	83 7d d8 ef          	cmpl   $0xffffffef,-0x28(%ebp)
  800125:	75 1d                	jne    800144 <_main+0x10c>
		{
			cprintf_colored(TEXT_TESTERR_CLR, "\n%~insufficient number of processes in the system! only %d slave processes are created\n", i);
  800127:	83 ec 04             	sub    $0x4,%esp
  80012a:	ff 75 e4             	pushl  -0x1c(%ebp)
  80012d:	68 24 22 80 00       	push   $0x802224
  800132:	6a 0c                	push   $0xc
  800134:	e8 54 06 00 00       	call   80078d <cprintf_colored>
  800139:	83 c4 10             	add    $0x10,%esp
			numOfSlaves = i;
  80013c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80013f:	89 45 c8             	mov    %eax,-0x38(%ebp)
			break;
  800142:	eb 19                	jmp    80015d <_main+0x125>
		}
		sys_run_env(id);
  800144:	83 ec 0c             	sub    $0xc,%esp
  800147:	ff 75 d8             	pushl  -0x28(%ebp)
  80014a:	e8 96 19 00 00       	call   801ae5 <sys_run_env>
  80014f:	83 c4 10             	add    $0x10,%esp
	char cmd1[64] = "__NumOfSlaves@Set";
	sys_utilities(cmd1, (uint32)(&numOfSlaves));

	//Create and run slave programs that should sleep
	int id;
	for (int i = 0; i < numOfSlaves; ++i)
  800152:	ff 45 e4             	incl   -0x1c(%ebp)
  800155:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800158:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  80015b:	7c 8e                	jl     8000eb <_main+0xb3>
		}
		sys_run_env(id);
	}

	//Wait until all slaves are blocked
	int numOfBlockedProcesses = 0;
  80015d:	c7 45 84 00 00 00 00 	movl   $0x0,-0x7c(%ebp)
	char cmd2[64] = "__GetChanQueueSize__";
  800164:	8d 85 44 ff ff ff    	lea    -0xbc(%ebp),%eax
  80016a:	bb b6 23 80 00       	mov    $0x8023b6,%ebx
  80016f:	ba 15 00 00 00       	mov    $0x15,%edx
  800174:	89 c7                	mov    %eax,%edi
  800176:	89 de                	mov    %ebx,%esi
  800178:	89 d1                	mov    %edx,%ecx
  80017a:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  80017c:	8d 95 59 ff ff ff    	lea    -0xa7(%ebp),%edx
  800182:	b9 2b 00 00 00       	mov    $0x2b,%ecx
  800187:	b0 00                	mov    $0x0,%al
  800189:	89 d7                	mov    %edx,%edi
  80018b:	f3 aa                	rep stos %al,%es:(%edi)
	sys_utilities(cmd2, (uint32)(&numOfBlockedProcesses));
  80018d:	8d 45 84             	lea    -0x7c(%ebp),%eax
  800190:	83 ec 08             	sub    $0x8,%esp
  800193:	50                   	push   %eax
  800194:	8d 85 44 ff ff ff    	lea    -0xbc(%ebp),%eax
  80019a:	50                   	push   %eax
  80019b:	e8 cb 1b 00 00       	call   801d6b <sys_utilities>
  8001a0:	83 c4 10             	add    $0x10,%esp
	int cnt = 0;
  8001a3:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
	while (numOfBlockedProcesses != numOfSlaves)
  8001aa:	eb 76                	jmp    800222 <_main+0x1ea>
	{
		env_sleep(5000);
  8001ac:	83 ec 0c             	sub    $0xc,%esp
  8001af:	68 88 13 00 00       	push   $0x1388
  8001b4:	e8 3e 1c 00 00       	call   801df7 <env_sleep>
  8001b9:	83 c4 10             	add    $0x10,%esp
		if (cnt == numOfSlaves)
  8001bc:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8001bf:	39 45 e0             	cmp    %eax,-0x20(%ebp)
  8001c2:	75 1c                	jne    8001e0 <_main+0x1a8>
		{
			panic("%~test channels failed! unexpected number of blocked slaves. Expected = %d, Current = %d", numOfSlaves, numOfBlockedProcesses);
  8001c4:	8b 55 84             	mov    -0x7c(%ebp),%edx
  8001c7:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8001ca:	83 ec 0c             	sub    $0xc,%esp
  8001cd:	52                   	push   %edx
  8001ce:	50                   	push   %eax
  8001cf:	68 7c 22 80 00       	push   $0x80227c
  8001d4:	6a 2d                	push   $0x2d
  8001d6:	68 d5 22 80 00       	push   $0x8022d5
  8001db:	e8 b2 02 00 00       	call   800492 <_panic>
		}
		char cmd3[64] = "__GetChanQueueSize__";
  8001e0:	8d 85 c4 fe ff ff    	lea    -0x13c(%ebp),%eax
  8001e6:	bb b6 23 80 00       	mov    $0x8023b6,%ebx
  8001eb:	ba 15 00 00 00       	mov    $0x15,%edx
  8001f0:	89 c7                	mov    %eax,%edi
  8001f2:	89 de                	mov    %ebx,%esi
  8001f4:	89 d1                	mov    %edx,%ecx
  8001f6:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  8001f8:	8d 95 d9 fe ff ff    	lea    -0x127(%ebp),%edx
  8001fe:	b9 2b 00 00 00       	mov    $0x2b,%ecx
  800203:	b0 00                	mov    $0x0,%al
  800205:	89 d7                	mov    %edx,%edi
  800207:	f3 aa                	rep stos %al,%es:(%edi)
		sys_utilities(cmd3, (uint32)(&numOfBlockedProcesses));
  800209:	8d 45 84             	lea    -0x7c(%ebp),%eax
  80020c:	83 ec 08             	sub    $0x8,%esp
  80020f:	50                   	push   %eax
  800210:	8d 85 c4 fe ff ff    	lea    -0x13c(%ebp),%eax
  800216:	50                   	push   %eax
  800217:	e8 4f 1b 00 00       	call   801d6b <sys_utilities>
  80021c:	83 c4 10             	add    $0x10,%esp
		cnt++ ;
  80021f:	ff 45 e0             	incl   -0x20(%ebp)
	//Wait until all slaves are blocked
	int numOfBlockedProcesses = 0;
	char cmd2[64] = "__GetChanQueueSize__";
	sys_utilities(cmd2, (uint32)(&numOfBlockedProcesses));
	int cnt = 0;
	while (numOfBlockedProcesses != numOfSlaves)
  800222:	8b 55 84             	mov    -0x7c(%ebp),%edx
  800225:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800228:	39 c2                	cmp    %eax,%edx
  80022a:	75 80                	jne    8001ac <_main+0x174>
		char cmd3[64] = "__GetChanQueueSize__";
		sys_utilities(cmd3, (uint32)(&numOfBlockedProcesses));
		cnt++ ;
	}

	rsttst();
  80022c:	e8 e2 19 00 00       	call   801c13 <rsttst>

	//Wakeup one
	char cmd4[64] = "__WakeupOne__";
  800231:	8d 85 04 ff ff ff    	lea    -0xfc(%ebp),%eax
  800237:	bb f6 23 80 00       	mov    $0x8023f6,%ebx
  80023c:	ba 0e 00 00 00       	mov    $0xe,%edx
  800241:	89 c7                	mov    %eax,%edi
  800243:	89 de                	mov    %ebx,%esi
  800245:	89 d1                	mov    %edx,%ecx
  800247:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  800249:	8d 95 12 ff ff ff    	lea    -0xee(%ebp),%edx
  80024f:	b9 32 00 00 00       	mov    $0x32,%ecx
  800254:	b0 00                	mov    $0x0,%al
  800256:	89 d7                	mov    %edx,%edi
  800258:	f3 aa                	rep stos %al,%es:(%edi)
	sys_utilities(cmd4, 0);
  80025a:	83 ec 08             	sub    $0x8,%esp
  80025d:	6a 00                	push   $0x0
  80025f:	8d 85 04 ff ff ff    	lea    -0xfc(%ebp),%eax
  800265:	50                   	push   %eax
  800266:	e8 00 1b 00 00       	call   801d6b <sys_utilities>
  80026b:	83 c4 10             	add    $0x10,%esp

	//Wait until all slave finished
	cnt = 0;
  80026e:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
	while (gettst() != numOfSlaves)
  800275:	eb 2f                	jmp    8002a6 <_main+0x26e>
	{
		env_sleep(10000);
  800277:	83 ec 0c             	sub    $0xc,%esp
  80027a:	68 10 27 00 00       	push   $0x2710
  80027f:	e8 73 1b 00 00       	call   801df7 <env_sleep>
  800284:	83 c4 10             	add    $0x10,%esp
		if (cnt == numOfSlaves)
  800287:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80028a:	39 45 e0             	cmp    %eax,-0x20(%ebp)
  80028d:	75 14                	jne    8002a3 <_main+0x26b>
		{
			panic("%~test channels failed! not all slaves finished");
  80028f:	83 ec 04             	sub    $0x4,%esp
  800292:	68 f0 22 80 00       	push   $0x8022f0
  800297:	6a 41                	push   $0x41
  800299:	68 d5 22 80 00       	push   $0x8022d5
  80029e:	e8 ef 01 00 00       	call   800492 <_panic>
		}
		cnt++ ;
  8002a3:	ff 45 e0             	incl   -0x20(%ebp)
	char cmd4[64] = "__WakeupOne__";
	sys_utilities(cmd4, 0);

	//Wait until all slave finished
	cnt = 0;
	while (gettst() != numOfSlaves)
  8002a6:	e8 e2 19 00 00       	call   801c8d <gettst>
  8002ab:	8b 55 c8             	mov    -0x38(%ebp),%edx
  8002ae:	39 d0                	cmp    %edx,%eax
  8002b0:	75 c5                	jne    800277 <_main+0x23f>
			panic("%~test channels failed! not all slaves finished");
		}
		cnt++ ;
	}

	cprintf_colored(TEXT_light_green, "%~\n\nCongratulations!! Test of Channel (sleep & wakeup ONE) completed successfully!!\n\n");
  8002b2:	83 ec 08             	sub    $0x8,%esp
  8002b5:	68 20 23 80 00       	push   $0x802320
  8002ba:	6a 0a                	push   $0xa
  8002bc:	e8 cc 04 00 00       	call   80078d <cprintf_colored>
  8002c1:	83 c4 10             	add    $0x10,%esp

	return;
  8002c4:	90                   	nop
}
  8002c5:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8002c8:	5b                   	pop    %ebx
  8002c9:	5e                   	pop    %esi
  8002ca:	5f                   	pop    %edi
  8002cb:	5d                   	pop    %ebp
  8002cc:	c3                   	ret    

008002cd <libmain>:
volatile bool printStats = 1;

volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";
void
libmain(int argc, char **argv)
{
  8002cd:	55                   	push   %ebp
  8002ce:	89 e5                	mov    %esp,%ebp
  8002d0:	57                   	push   %edi
  8002d1:	56                   	push   %esi
  8002d2:	53                   	push   %ebx
  8002d3:	83 ec 7c             	sub    $0x7c,%esp
	//printStats = 1;
	int envIndex = sys_getenvindex();
  8002d6:	e8 5a 18 00 00       	call   801b35 <sys_getenvindex>
  8002db:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	myEnv = &(envs[envIndex]);
  8002de:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8002e1:	89 d0                	mov    %edx,%eax
  8002e3:	c1 e0 06             	shl    $0x6,%eax
  8002e6:	29 d0                	sub    %edx,%eax
  8002e8:	c1 e0 02             	shl    $0x2,%eax
  8002eb:	01 d0                	add    %edx,%eax
  8002ed:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8002f4:	01 c8                	add    %ecx,%eax
  8002f6:	c1 e0 03             	shl    $0x3,%eax
  8002f9:	01 d0                	add    %edx,%eax
  8002fb:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800302:	29 c2                	sub    %eax,%edx
  800304:	8d 04 95 00 00 00 00 	lea    0x0(,%edx,4),%eax
  80030b:	89 c2                	mov    %eax,%edx
  80030d:	8d 82 00 00 c0 ee    	lea    -0x11400000(%edx),%eax
  800313:	a3 20 30 80 00       	mov    %eax,0x803020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800318:	a1 20 30 80 00       	mov    0x803020,%eax
  80031d:	8a 40 20             	mov    0x20(%eax),%al
  800320:	84 c0                	test   %al,%al
  800322:	74 0d                	je     800331 <libmain+0x64>
		binaryname = myEnv->prog_name;
  800324:	a1 20 30 80 00       	mov    0x803020,%eax
  800329:	83 c0 20             	add    $0x20,%eax
  80032c:	a3 04 30 80 00       	mov    %eax,0x803004

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800331:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800335:	7e 0a                	jle    800341 <libmain+0x74>
		binaryname = argv[0];
  800337:	8b 45 0c             	mov    0xc(%ebp),%eax
  80033a:	8b 00                	mov    (%eax),%eax
  80033c:	a3 04 30 80 00       	mov    %eax,0x803004

	// call user main routine
	_main(argc, argv);
  800341:	83 ec 08             	sub    $0x8,%esp
  800344:	ff 75 0c             	pushl  0xc(%ebp)
  800347:	ff 75 08             	pushl  0x8(%ebp)
  80034a:	e8 e9 fc ff ff       	call   800038 <_main>
  80034f:	83 c4 10             	add    $0x10,%esp

	if (printStats)
  800352:	a1 00 30 80 00       	mov    0x803000,%eax
  800357:	85 c0                	test   %eax,%eax
  800359:	0f 84 01 01 00 00    	je     800460 <libmain+0x193>
	{
		char isOPTReplCmd[100] = "__IsOPTRepl__" ;
  80035f:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  800365:	bb 30 25 80 00       	mov    $0x802530,%ebx
  80036a:	ba 0e 00 00 00       	mov    $0xe,%edx
  80036f:	89 c7                	mov    %eax,%edi
  800371:	89 de                	mov    %ebx,%esi
  800373:	89 d1                	mov    %edx,%ecx
  800375:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  800377:	8d 55 8a             	lea    -0x76(%ebp),%edx
  80037a:	b9 56 00 00 00       	mov    $0x56,%ecx
  80037f:	b0 00                	mov    $0x0,%al
  800381:	89 d7                	mov    %edx,%edi
  800383:	f3 aa                	rep stos %al,%es:(%edi)
		int isOPTRepl = 0;
  800385:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
		sys_utilities(isOPTReplCmd, (uint32)(&isOPTRepl));
  80038c:	8d 45 e0             	lea    -0x20(%ebp),%eax
  80038f:	83 ec 08             	sub    $0x8,%esp
  800392:	50                   	push   %eax
  800393:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  800399:	50                   	push   %eax
  80039a:	e8 cc 19 00 00       	call   801d6b <sys_utilities>
  80039f:	83 c4 10             	add    $0x10,%esp

		sys_lock_cons();
  8003a2:	e8 15 15 00 00       	call   8018bc <sys_lock_cons>
		{
			cprintf("**************************************\n");
  8003a7:	83 ec 0c             	sub    $0xc,%esp
  8003aa:	68 50 24 80 00       	push   $0x802450
  8003af:	e8 ac 03 00 00       	call   800760 <cprintf>
  8003b4:	83 c4 10             	add    $0x10,%esp
			if (isOPTRepl)
  8003b7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8003ba:	85 c0                	test   %eax,%eax
  8003bc:	74 18                	je     8003d6 <libmain+0x109>
			{
				cprintf("OPTIMAL number of page faults = %d\n", sys_get_optimal_num_faults());
  8003be:	e8 c6 19 00 00       	call   801d89 <sys_get_optimal_num_faults>
  8003c3:	83 ec 08             	sub    $0x8,%esp
  8003c6:	50                   	push   %eax
  8003c7:	68 78 24 80 00       	push   $0x802478
  8003cc:	e8 8f 03 00 00       	call   800760 <cprintf>
  8003d1:	83 c4 10             	add    $0x10,%esp
  8003d4:	eb 59                	jmp    80042f <libmain+0x162>
			}
			else
			{
				cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8003d6:	a1 20 30 80 00       	mov    0x803020,%eax
  8003db:	8b 90 50 da 01 00    	mov    0x1da50(%eax),%edx
  8003e1:	a1 20 30 80 00       	mov    0x803020,%eax
  8003e6:	8b 80 40 da 01 00    	mov    0x1da40(%eax),%eax
  8003ec:	83 ec 04             	sub    $0x4,%esp
  8003ef:	52                   	push   %edx
  8003f0:	50                   	push   %eax
  8003f1:	68 9c 24 80 00       	push   $0x80249c
  8003f6:	e8 65 03 00 00       	call   800760 <cprintf>
  8003fb:	83 c4 10             	add    $0x10,%esp
				cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  8003fe:	a1 20 30 80 00       	mov    0x803020,%eax
  800403:	8b 88 64 da 01 00    	mov    0x1da64(%eax),%ecx
  800409:	a1 20 30 80 00       	mov    0x803020,%eax
  80040e:	8b 90 60 da 01 00    	mov    0x1da60(%eax),%edx
  800414:	a1 20 30 80 00       	mov    0x803020,%eax
  800419:	8b 80 5c da 01 00    	mov    0x1da5c(%eax),%eax
  80041f:	51                   	push   %ecx
  800420:	52                   	push   %edx
  800421:	50                   	push   %eax
  800422:	68 c4 24 80 00       	push   $0x8024c4
  800427:	e8 34 03 00 00       	call   800760 <cprintf>
  80042c:	83 c4 10             	add    $0x10,%esp
			}
			//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
			cprintf("Num of clocks = %d\n", myEnv->nClocks);
  80042f:	a1 20 30 80 00       	mov    0x803020,%eax
  800434:	8b 80 68 da 01 00    	mov    0x1da68(%eax),%eax
  80043a:	83 ec 08             	sub    $0x8,%esp
  80043d:	50                   	push   %eax
  80043e:	68 1c 25 80 00       	push   $0x80251c
  800443:	e8 18 03 00 00       	call   800760 <cprintf>
  800448:	83 c4 10             	add    $0x10,%esp
			cprintf("**************************************\n");
  80044b:	83 ec 0c             	sub    $0xc,%esp
  80044e:	68 50 24 80 00       	push   $0x802450
  800453:	e8 08 03 00 00       	call   800760 <cprintf>
  800458:	83 c4 10             	add    $0x10,%esp
		}
		sys_unlock_cons();
  80045b:	e8 76 14 00 00       	call   8018d6 <sys_unlock_cons>
	}

	// exit gracefully
	exit();
  800460:	e8 1f 00 00 00       	call   800484 <exit>
}
  800465:	90                   	nop
  800466:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800469:	5b                   	pop    %ebx
  80046a:	5e                   	pop    %esi
  80046b:	5f                   	pop    %edi
  80046c:	5d                   	pop    %ebp
  80046d:	c3                   	ret    

0080046e <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  80046e:	55                   	push   %ebp
  80046f:	89 e5                	mov    %esp,%ebp
  800471:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800474:	83 ec 0c             	sub    $0xc,%esp
  800477:	6a 00                	push   $0x0
  800479:	e8 83 16 00 00       	call   801b01 <sys_destroy_env>
  80047e:	83 c4 10             	add    $0x10,%esp
}
  800481:	90                   	nop
  800482:	c9                   	leave  
  800483:	c3                   	ret    

00800484 <exit>:

void
exit(void)
{
  800484:	55                   	push   %ebp
  800485:	89 e5                	mov    %esp,%ebp
  800487:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  80048a:	e8 d8 16 00 00       	call   801b67 <sys_exit_env>
}
  80048f:	90                   	nop
  800490:	c9                   	leave  
  800491:	c3                   	ret    

00800492 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  800492:	55                   	push   %ebp
  800493:	89 e5                	mov    %esp,%ebp
  800495:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  800498:	8d 45 10             	lea    0x10(%ebp),%eax
  80049b:	83 c0 04             	add    $0x4,%eax
  80049e:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  8004a1:	a1 18 b1 81 00       	mov    0x81b118,%eax
  8004a6:	85 c0                	test   %eax,%eax
  8004a8:	74 16                	je     8004c0 <_panic+0x2e>
		cprintf("%s: ", argv0);
  8004aa:	a1 18 b1 81 00       	mov    0x81b118,%eax
  8004af:	83 ec 08             	sub    $0x8,%esp
  8004b2:	50                   	push   %eax
  8004b3:	68 94 25 80 00       	push   $0x802594
  8004b8:	e8 a3 02 00 00       	call   800760 <cprintf>
  8004bd:	83 c4 10             	add    $0x10,%esp
	cprintf_colored(TEXT_PANIC_CLR, "user [EVAL_FINAL]panic in %s at %s:%d: ", binaryname, file, line);
  8004c0:	a1 04 30 80 00       	mov    0x803004,%eax
  8004c5:	83 ec 0c             	sub    $0xc,%esp
  8004c8:	ff 75 0c             	pushl  0xc(%ebp)
  8004cb:	ff 75 08             	pushl  0x8(%ebp)
  8004ce:	50                   	push   %eax
  8004cf:	68 9c 25 80 00       	push   $0x80259c
  8004d4:	6a 74                	push   $0x74
  8004d6:	e8 b2 02 00 00       	call   80078d <cprintf_colored>
  8004db:	83 c4 20             	add    $0x20,%esp
	vcprintf(fmt, ap);
  8004de:	8b 45 10             	mov    0x10(%ebp),%eax
  8004e1:	83 ec 08             	sub    $0x8,%esp
  8004e4:	ff 75 f4             	pushl  -0xc(%ebp)
  8004e7:	50                   	push   %eax
  8004e8:	e8 04 02 00 00       	call   8006f1 <vcprintf>
  8004ed:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  8004f0:	83 ec 08             	sub    $0x8,%esp
  8004f3:	6a 00                	push   $0x0
  8004f5:	68 c4 25 80 00       	push   $0x8025c4
  8004fa:	e8 f2 01 00 00       	call   8006f1 <vcprintf>
  8004ff:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  800502:	e8 7d ff ff ff       	call   800484 <exit>

	// should not return here
	while (1) ;
  800507:	eb fe                	jmp    800507 <_panic+0x75>

00800509 <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  800509:	55                   	push   %ebp
  80050a:	89 e5                	mov    %esp,%ebp
  80050c:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  80050f:	a1 20 30 80 00       	mov    0x803020,%eax
  800514:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  80051a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80051d:	39 c2                	cmp    %eax,%edx
  80051f:	74 14                	je     800535 <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  800521:	83 ec 04             	sub    $0x4,%esp
  800524:	68 c8 25 80 00       	push   $0x8025c8
  800529:	6a 26                	push   $0x26
  80052b:	68 14 26 80 00       	push   $0x802614
  800530:	e8 5d ff ff ff       	call   800492 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  800535:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  80053c:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800543:	e9 c5 00 00 00       	jmp    80060d <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  800548:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80054b:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800552:	8b 45 08             	mov    0x8(%ebp),%eax
  800555:	01 d0                	add    %edx,%eax
  800557:	8b 00                	mov    (%eax),%eax
  800559:	85 c0                	test   %eax,%eax
  80055b:	75 08                	jne    800565 <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  80055d:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  800560:	e9 a5 00 00 00       	jmp    80060a <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  800565:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80056c:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  800573:	eb 69                	jmp    8005de <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  800575:	a1 20 30 80 00       	mov    0x803020,%eax
  80057a:	8b 88 38 da 01 00    	mov    0x1da38(%eax),%ecx
  800580:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800583:	89 d0                	mov    %edx,%eax
  800585:	01 c0                	add    %eax,%eax
  800587:	01 d0                	add    %edx,%eax
  800589:	c1 e0 03             	shl    $0x3,%eax
  80058c:	01 c8                	add    %ecx,%eax
  80058e:	8a 40 04             	mov    0x4(%eax),%al
  800591:	84 c0                	test   %al,%al
  800593:	75 46                	jne    8005db <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800595:	a1 20 30 80 00       	mov    0x803020,%eax
  80059a:	8b 88 38 da 01 00    	mov    0x1da38(%eax),%ecx
  8005a0:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8005a3:	89 d0                	mov    %edx,%eax
  8005a5:	01 c0                	add    %eax,%eax
  8005a7:	01 d0                	add    %edx,%eax
  8005a9:	c1 e0 03             	shl    $0x3,%eax
  8005ac:	01 c8                	add    %ecx,%eax
  8005ae:	8b 00                	mov    (%eax),%eax
  8005b0:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8005b3:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8005b6:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8005bb:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  8005bd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8005c0:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8005c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8005ca:	01 c8                	add    %ecx,%eax
  8005cc:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8005ce:	39 c2                	cmp    %eax,%edx
  8005d0:	75 09                	jne    8005db <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  8005d2:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  8005d9:	eb 15                	jmp    8005f0 <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8005db:	ff 45 e8             	incl   -0x18(%ebp)
  8005de:	a1 20 30 80 00       	mov    0x803020,%eax
  8005e3:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  8005e9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8005ec:	39 c2                	cmp    %eax,%edx
  8005ee:	77 85                	ja     800575 <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  8005f0:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8005f4:	75 14                	jne    80060a <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  8005f6:	83 ec 04             	sub    $0x4,%esp
  8005f9:	68 20 26 80 00       	push   $0x802620
  8005fe:	6a 3a                	push   $0x3a
  800600:	68 14 26 80 00       	push   $0x802614
  800605:	e8 88 fe ff ff       	call   800492 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  80060a:	ff 45 f0             	incl   -0x10(%ebp)
  80060d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800610:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800613:	0f 8c 2f ff ff ff    	jl     800548 <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  800619:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800620:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800627:	eb 26                	jmp    80064f <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  800629:	a1 20 30 80 00       	mov    0x803020,%eax
  80062e:	8b 88 38 da 01 00    	mov    0x1da38(%eax),%ecx
  800634:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800637:	89 d0                	mov    %edx,%eax
  800639:	01 c0                	add    %eax,%eax
  80063b:	01 d0                	add    %edx,%eax
  80063d:	c1 e0 03             	shl    $0x3,%eax
  800640:	01 c8                	add    %ecx,%eax
  800642:	8a 40 04             	mov    0x4(%eax),%al
  800645:	3c 01                	cmp    $0x1,%al
  800647:	75 03                	jne    80064c <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  800649:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80064c:	ff 45 e0             	incl   -0x20(%ebp)
  80064f:	a1 20 30 80 00       	mov    0x803020,%eax
  800654:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  80065a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80065d:	39 c2                	cmp    %eax,%edx
  80065f:	77 c8                	ja     800629 <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  800661:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800664:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800667:	74 14                	je     80067d <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  800669:	83 ec 04             	sub    $0x4,%esp
  80066c:	68 74 26 80 00       	push   $0x802674
  800671:	6a 44                	push   $0x44
  800673:	68 14 26 80 00       	push   $0x802614
  800678:	e8 15 fe ff ff       	call   800492 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  80067d:	90                   	nop
  80067e:	c9                   	leave  
  80067f:	c3                   	ret    

00800680 <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  800680:	55                   	push   %ebp
  800681:	89 e5                	mov    %esp,%ebp
  800683:	53                   	push   %ebx
  800684:	83 ec 04             	sub    $0x4,%esp
	b->buf[b->idx++] = ch;
  800687:	8b 45 0c             	mov    0xc(%ebp),%eax
  80068a:	8b 00                	mov    (%eax),%eax
  80068c:	8d 48 01             	lea    0x1(%eax),%ecx
  80068f:	8b 55 0c             	mov    0xc(%ebp),%edx
  800692:	89 0a                	mov    %ecx,(%edx)
  800694:	8b 55 08             	mov    0x8(%ebp),%edx
  800697:	88 d1                	mov    %dl,%cl
  800699:	8b 55 0c             	mov    0xc(%ebp),%edx
  80069c:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  8006a0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006a3:	8b 00                	mov    (%eax),%eax
  8006a5:	3d ff 00 00 00       	cmp    $0xff,%eax
  8006aa:	75 30                	jne    8006dc <putch+0x5c>
		sys_cputs(b->buf, b->idx, printProgName, curTextClr);
  8006ac:	8b 15 1c b1 81 00    	mov    0x81b11c,%edx
  8006b2:	a0 44 30 80 00       	mov    0x803044,%al
  8006b7:	0f b6 c0             	movzbl %al,%eax
  8006ba:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8006bd:	8b 09                	mov    (%ecx),%ecx
  8006bf:	89 cb                	mov    %ecx,%ebx
  8006c1:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8006c4:	83 c1 08             	add    $0x8,%ecx
  8006c7:	52                   	push   %edx
  8006c8:	50                   	push   %eax
  8006c9:	53                   	push   %ebx
  8006ca:	51                   	push   %ecx
  8006cb:	e8 a8 11 00 00       	call   801878 <sys_cputs>
  8006d0:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8006d3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006d6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8006dc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006df:	8b 40 04             	mov    0x4(%eax),%eax
  8006e2:	8d 50 01             	lea    0x1(%eax),%edx
  8006e5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006e8:	89 50 04             	mov    %edx,0x4(%eax)
}
  8006eb:	90                   	nop
  8006ec:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8006ef:	c9                   	leave  
  8006f0:	c3                   	ret    

008006f1 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  8006f1:	55                   	push   %ebp
  8006f2:	89 e5                	mov    %esp,%ebp
  8006f4:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8006fa:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800701:	00 00 00 
	b.cnt = 0;
  800704:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  80070b:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  80070e:	ff 75 0c             	pushl  0xc(%ebp)
  800711:	ff 75 08             	pushl  0x8(%ebp)
  800714:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80071a:	50                   	push   %eax
  80071b:	68 80 06 80 00       	push   $0x800680
  800720:	e8 5a 02 00 00       	call   80097f <vprintfmt>
  800725:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName, curTextClr);
  800728:	8b 15 1c b1 81 00    	mov    0x81b11c,%edx
  80072e:	a0 44 30 80 00       	mov    0x803044,%al
  800733:	0f b6 c0             	movzbl %al,%eax
  800736:	8b 8d f0 fe ff ff    	mov    -0x110(%ebp),%ecx
  80073c:	52                   	push   %edx
  80073d:	50                   	push   %eax
  80073e:	51                   	push   %ecx
  80073f:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800745:	83 c0 08             	add    $0x8,%eax
  800748:	50                   	push   %eax
  800749:	e8 2a 11 00 00       	call   801878 <sys_cputs>
  80074e:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800751:	c6 05 44 30 80 00 00 	movb   $0x0,0x803044
	return b.cnt;
  800758:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  80075e:	c9                   	leave  
  80075f:	c3                   	ret    

00800760 <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  800760:	55                   	push   %ebp
  800761:	89 e5                	mov    %esp,%ebp
  800763:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800766:	c6 05 44 30 80 00 01 	movb   $0x1,0x803044
	va_start(ap, fmt);
  80076d:	8d 45 0c             	lea    0xc(%ebp),%eax
  800770:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800773:	8b 45 08             	mov    0x8(%ebp),%eax
  800776:	83 ec 08             	sub    $0x8,%esp
  800779:	ff 75 f4             	pushl  -0xc(%ebp)
  80077c:	50                   	push   %eax
  80077d:	e8 6f ff ff ff       	call   8006f1 <vcprintf>
  800782:	83 c4 10             	add    $0x10,%esp
  800785:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800788:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80078b:	c9                   	leave  
  80078c:	c3                   	ret    

0080078d <cprintf_colored>:

// *************** This text coloring feature is implemented by *************
// ********** Abd-Alrahman Zedan From Team Frozen-Bytes - FCIS'24-25 ********
int cprintf_colored(int textClr, const char *fmt, ...) {
  80078d:	55                   	push   %ebp
  80078e:	89 e5                	mov    %esp,%ebp
  800790:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800793:	c6 05 44 30 80 00 01 	movb   $0x1,0x803044
	curTextClr = (textClr << 8) ; //set text color by the given value
  80079a:	8b 45 08             	mov    0x8(%ebp),%eax
  80079d:	c1 e0 08             	shl    $0x8,%eax
  8007a0:	a3 1c b1 81 00       	mov    %eax,0x81b11c
	va_start(ap, fmt);
  8007a5:	8d 45 0c             	lea    0xc(%ebp),%eax
  8007a8:	83 c0 04             	add    $0x4,%eax
  8007ab:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8007ae:	8b 45 0c             	mov    0xc(%ebp),%eax
  8007b1:	83 ec 08             	sub    $0x8,%esp
  8007b4:	ff 75 f4             	pushl  -0xc(%ebp)
  8007b7:	50                   	push   %eax
  8007b8:	e8 34 ff ff ff       	call   8006f1 <vcprintf>
  8007bd:	83 c4 10             	add    $0x10,%esp
  8007c0:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);
	curTextClr = TEXT_DEFAULT_CLR; //restore default color
  8007c3:	c7 05 1c b1 81 00 00 	movl   $0x700,0x81b11c
  8007ca:	07 00 00 

	return cnt;
  8007cd:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8007d0:	c9                   	leave  
  8007d1:	c3                   	ret    

008007d2 <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  8007d2:	55                   	push   %ebp
  8007d3:	89 e5                	mov    %esp,%ebp
  8007d5:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  8007d8:	e8 df 10 00 00       	call   8018bc <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  8007dd:	8d 45 0c             	lea    0xc(%ebp),%eax
  8007e0:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  8007e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8007e6:	83 ec 08             	sub    $0x8,%esp
  8007e9:	ff 75 f4             	pushl  -0xc(%ebp)
  8007ec:	50                   	push   %eax
  8007ed:	e8 ff fe ff ff       	call   8006f1 <vcprintf>
  8007f2:	83 c4 10             	add    $0x10,%esp
  8007f5:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  8007f8:	e8 d9 10 00 00       	call   8018d6 <sys_unlock_cons>
	return cnt;
  8007fd:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800800:	c9                   	leave  
  800801:	c3                   	ret    

00800802 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800802:	55                   	push   %ebp
  800803:	89 e5                	mov    %esp,%ebp
  800805:	53                   	push   %ebx
  800806:	83 ec 14             	sub    $0x14,%esp
  800809:	8b 45 10             	mov    0x10(%ebp),%eax
  80080c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80080f:	8b 45 14             	mov    0x14(%ebp),%eax
  800812:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800815:	8b 45 18             	mov    0x18(%ebp),%eax
  800818:	ba 00 00 00 00       	mov    $0x0,%edx
  80081d:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800820:	77 55                	ja     800877 <printnum+0x75>
  800822:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800825:	72 05                	jb     80082c <printnum+0x2a>
  800827:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80082a:	77 4b                	ja     800877 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  80082c:	8b 45 1c             	mov    0x1c(%ebp),%eax
  80082f:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800832:	8b 45 18             	mov    0x18(%ebp),%eax
  800835:	ba 00 00 00 00       	mov    $0x0,%edx
  80083a:	52                   	push   %edx
  80083b:	50                   	push   %eax
  80083c:	ff 75 f4             	pushl  -0xc(%ebp)
  80083f:	ff 75 f0             	pushl  -0x10(%ebp)
  800842:	e8 ad 16 00 00       	call   801ef4 <__udivdi3>
  800847:	83 c4 10             	add    $0x10,%esp
  80084a:	83 ec 04             	sub    $0x4,%esp
  80084d:	ff 75 20             	pushl  0x20(%ebp)
  800850:	53                   	push   %ebx
  800851:	ff 75 18             	pushl  0x18(%ebp)
  800854:	52                   	push   %edx
  800855:	50                   	push   %eax
  800856:	ff 75 0c             	pushl  0xc(%ebp)
  800859:	ff 75 08             	pushl  0x8(%ebp)
  80085c:	e8 a1 ff ff ff       	call   800802 <printnum>
  800861:	83 c4 20             	add    $0x20,%esp
  800864:	eb 1a                	jmp    800880 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800866:	83 ec 08             	sub    $0x8,%esp
  800869:	ff 75 0c             	pushl  0xc(%ebp)
  80086c:	ff 75 20             	pushl  0x20(%ebp)
  80086f:	8b 45 08             	mov    0x8(%ebp),%eax
  800872:	ff d0                	call   *%eax
  800874:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800877:	ff 4d 1c             	decl   0x1c(%ebp)
  80087a:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  80087e:	7f e6                	jg     800866 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800880:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800883:	bb 00 00 00 00       	mov    $0x0,%ebx
  800888:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80088b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80088e:	53                   	push   %ebx
  80088f:	51                   	push   %ecx
  800890:	52                   	push   %edx
  800891:	50                   	push   %eax
  800892:	e8 6d 17 00 00       	call   802004 <__umoddi3>
  800897:	83 c4 10             	add    $0x10,%esp
  80089a:	05 d4 28 80 00       	add    $0x8028d4,%eax
  80089f:	8a 00                	mov    (%eax),%al
  8008a1:	0f be c0             	movsbl %al,%eax
  8008a4:	83 ec 08             	sub    $0x8,%esp
  8008a7:	ff 75 0c             	pushl  0xc(%ebp)
  8008aa:	50                   	push   %eax
  8008ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8008ae:	ff d0                	call   *%eax
  8008b0:	83 c4 10             	add    $0x10,%esp
}
  8008b3:	90                   	nop
  8008b4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8008b7:	c9                   	leave  
  8008b8:	c3                   	ret    

008008b9 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8008b9:	55                   	push   %ebp
  8008ba:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8008bc:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8008c0:	7e 1c                	jle    8008de <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  8008c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8008c5:	8b 00                	mov    (%eax),%eax
  8008c7:	8d 50 08             	lea    0x8(%eax),%edx
  8008ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8008cd:	89 10                	mov    %edx,(%eax)
  8008cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8008d2:	8b 00                	mov    (%eax),%eax
  8008d4:	83 e8 08             	sub    $0x8,%eax
  8008d7:	8b 50 04             	mov    0x4(%eax),%edx
  8008da:	8b 00                	mov    (%eax),%eax
  8008dc:	eb 40                	jmp    80091e <getuint+0x65>
	else if (lflag)
  8008de:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8008e2:	74 1e                	je     800902 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  8008e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8008e7:	8b 00                	mov    (%eax),%eax
  8008e9:	8d 50 04             	lea    0x4(%eax),%edx
  8008ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8008ef:	89 10                	mov    %edx,(%eax)
  8008f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8008f4:	8b 00                	mov    (%eax),%eax
  8008f6:	83 e8 04             	sub    $0x4,%eax
  8008f9:	8b 00                	mov    (%eax),%eax
  8008fb:	ba 00 00 00 00       	mov    $0x0,%edx
  800900:	eb 1c                	jmp    80091e <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800902:	8b 45 08             	mov    0x8(%ebp),%eax
  800905:	8b 00                	mov    (%eax),%eax
  800907:	8d 50 04             	lea    0x4(%eax),%edx
  80090a:	8b 45 08             	mov    0x8(%ebp),%eax
  80090d:	89 10                	mov    %edx,(%eax)
  80090f:	8b 45 08             	mov    0x8(%ebp),%eax
  800912:	8b 00                	mov    (%eax),%eax
  800914:	83 e8 04             	sub    $0x4,%eax
  800917:	8b 00                	mov    (%eax),%eax
  800919:	ba 00 00 00 00       	mov    $0x0,%edx
}
  80091e:	5d                   	pop    %ebp
  80091f:	c3                   	ret    

00800920 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800920:	55                   	push   %ebp
  800921:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800923:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800927:	7e 1c                	jle    800945 <getint+0x25>
		return va_arg(*ap, long long);
  800929:	8b 45 08             	mov    0x8(%ebp),%eax
  80092c:	8b 00                	mov    (%eax),%eax
  80092e:	8d 50 08             	lea    0x8(%eax),%edx
  800931:	8b 45 08             	mov    0x8(%ebp),%eax
  800934:	89 10                	mov    %edx,(%eax)
  800936:	8b 45 08             	mov    0x8(%ebp),%eax
  800939:	8b 00                	mov    (%eax),%eax
  80093b:	83 e8 08             	sub    $0x8,%eax
  80093e:	8b 50 04             	mov    0x4(%eax),%edx
  800941:	8b 00                	mov    (%eax),%eax
  800943:	eb 38                	jmp    80097d <getint+0x5d>
	else if (lflag)
  800945:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800949:	74 1a                	je     800965 <getint+0x45>
		return va_arg(*ap, long);
  80094b:	8b 45 08             	mov    0x8(%ebp),%eax
  80094e:	8b 00                	mov    (%eax),%eax
  800950:	8d 50 04             	lea    0x4(%eax),%edx
  800953:	8b 45 08             	mov    0x8(%ebp),%eax
  800956:	89 10                	mov    %edx,(%eax)
  800958:	8b 45 08             	mov    0x8(%ebp),%eax
  80095b:	8b 00                	mov    (%eax),%eax
  80095d:	83 e8 04             	sub    $0x4,%eax
  800960:	8b 00                	mov    (%eax),%eax
  800962:	99                   	cltd   
  800963:	eb 18                	jmp    80097d <getint+0x5d>
	else
		return va_arg(*ap, int);
  800965:	8b 45 08             	mov    0x8(%ebp),%eax
  800968:	8b 00                	mov    (%eax),%eax
  80096a:	8d 50 04             	lea    0x4(%eax),%edx
  80096d:	8b 45 08             	mov    0x8(%ebp),%eax
  800970:	89 10                	mov    %edx,(%eax)
  800972:	8b 45 08             	mov    0x8(%ebp),%eax
  800975:	8b 00                	mov    (%eax),%eax
  800977:	83 e8 04             	sub    $0x4,%eax
  80097a:	8b 00                	mov    (%eax),%eax
  80097c:	99                   	cltd   
}
  80097d:	5d                   	pop    %ebp
  80097e:	c3                   	ret    

0080097f <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  80097f:	55                   	push   %ebp
  800980:	89 e5                	mov    %esp,%ebp
  800982:	56                   	push   %esi
  800983:	53                   	push   %ebx
  800984:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800987:	eb 17                	jmp    8009a0 <vprintfmt+0x21>
			if (ch == '\0')
  800989:	85 db                	test   %ebx,%ebx
  80098b:	0f 84 c1 03 00 00    	je     800d52 <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  800991:	83 ec 08             	sub    $0x8,%esp
  800994:	ff 75 0c             	pushl  0xc(%ebp)
  800997:	53                   	push   %ebx
  800998:	8b 45 08             	mov    0x8(%ebp),%eax
  80099b:	ff d0                	call   *%eax
  80099d:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8009a0:	8b 45 10             	mov    0x10(%ebp),%eax
  8009a3:	8d 50 01             	lea    0x1(%eax),%edx
  8009a6:	89 55 10             	mov    %edx,0x10(%ebp)
  8009a9:	8a 00                	mov    (%eax),%al
  8009ab:	0f b6 d8             	movzbl %al,%ebx
  8009ae:	83 fb 25             	cmp    $0x25,%ebx
  8009b1:	75 d6                	jne    800989 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  8009b3:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  8009b7:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  8009be:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8009c5:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  8009cc:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8009d3:	8b 45 10             	mov    0x10(%ebp),%eax
  8009d6:	8d 50 01             	lea    0x1(%eax),%edx
  8009d9:	89 55 10             	mov    %edx,0x10(%ebp)
  8009dc:	8a 00                	mov    (%eax),%al
  8009de:	0f b6 d8             	movzbl %al,%ebx
  8009e1:	8d 43 dd             	lea    -0x23(%ebx),%eax
  8009e4:	83 f8 5b             	cmp    $0x5b,%eax
  8009e7:	0f 87 3d 03 00 00    	ja     800d2a <vprintfmt+0x3ab>
  8009ed:	8b 04 85 f8 28 80 00 	mov    0x8028f8(,%eax,4),%eax
  8009f4:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  8009f6:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  8009fa:	eb d7                	jmp    8009d3 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8009fc:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800a00:	eb d1                	jmp    8009d3 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800a02:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800a09:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800a0c:	89 d0                	mov    %edx,%eax
  800a0e:	c1 e0 02             	shl    $0x2,%eax
  800a11:	01 d0                	add    %edx,%eax
  800a13:	01 c0                	add    %eax,%eax
  800a15:	01 d8                	add    %ebx,%eax
  800a17:	83 e8 30             	sub    $0x30,%eax
  800a1a:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800a1d:	8b 45 10             	mov    0x10(%ebp),%eax
  800a20:	8a 00                	mov    (%eax),%al
  800a22:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800a25:	83 fb 2f             	cmp    $0x2f,%ebx
  800a28:	7e 3e                	jle    800a68 <vprintfmt+0xe9>
  800a2a:	83 fb 39             	cmp    $0x39,%ebx
  800a2d:	7f 39                	jg     800a68 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800a2f:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800a32:	eb d5                	jmp    800a09 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800a34:	8b 45 14             	mov    0x14(%ebp),%eax
  800a37:	83 c0 04             	add    $0x4,%eax
  800a3a:	89 45 14             	mov    %eax,0x14(%ebp)
  800a3d:	8b 45 14             	mov    0x14(%ebp),%eax
  800a40:	83 e8 04             	sub    $0x4,%eax
  800a43:	8b 00                	mov    (%eax),%eax
  800a45:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800a48:	eb 1f                	jmp    800a69 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800a4a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a4e:	79 83                	jns    8009d3 <vprintfmt+0x54>
				width = 0;
  800a50:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800a57:	e9 77 ff ff ff       	jmp    8009d3 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800a5c:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800a63:	e9 6b ff ff ff       	jmp    8009d3 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800a68:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800a69:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a6d:	0f 89 60 ff ff ff    	jns    8009d3 <vprintfmt+0x54>
				width = precision, precision = -1;
  800a73:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800a76:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800a79:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800a80:	e9 4e ff ff ff       	jmp    8009d3 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800a85:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800a88:	e9 46 ff ff ff       	jmp    8009d3 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800a8d:	8b 45 14             	mov    0x14(%ebp),%eax
  800a90:	83 c0 04             	add    $0x4,%eax
  800a93:	89 45 14             	mov    %eax,0x14(%ebp)
  800a96:	8b 45 14             	mov    0x14(%ebp),%eax
  800a99:	83 e8 04             	sub    $0x4,%eax
  800a9c:	8b 00                	mov    (%eax),%eax
  800a9e:	83 ec 08             	sub    $0x8,%esp
  800aa1:	ff 75 0c             	pushl  0xc(%ebp)
  800aa4:	50                   	push   %eax
  800aa5:	8b 45 08             	mov    0x8(%ebp),%eax
  800aa8:	ff d0                	call   *%eax
  800aaa:	83 c4 10             	add    $0x10,%esp
			break;
  800aad:	e9 9b 02 00 00       	jmp    800d4d <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800ab2:	8b 45 14             	mov    0x14(%ebp),%eax
  800ab5:	83 c0 04             	add    $0x4,%eax
  800ab8:	89 45 14             	mov    %eax,0x14(%ebp)
  800abb:	8b 45 14             	mov    0x14(%ebp),%eax
  800abe:	83 e8 04             	sub    $0x4,%eax
  800ac1:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800ac3:	85 db                	test   %ebx,%ebx
  800ac5:	79 02                	jns    800ac9 <vprintfmt+0x14a>
				err = -err;
  800ac7:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800ac9:	83 fb 64             	cmp    $0x64,%ebx
  800acc:	7f 0b                	jg     800ad9 <vprintfmt+0x15a>
  800ace:	8b 34 9d 40 27 80 00 	mov    0x802740(,%ebx,4),%esi
  800ad5:	85 f6                	test   %esi,%esi
  800ad7:	75 19                	jne    800af2 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800ad9:	53                   	push   %ebx
  800ada:	68 e5 28 80 00       	push   $0x8028e5
  800adf:	ff 75 0c             	pushl  0xc(%ebp)
  800ae2:	ff 75 08             	pushl  0x8(%ebp)
  800ae5:	e8 70 02 00 00       	call   800d5a <printfmt>
  800aea:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800aed:	e9 5b 02 00 00       	jmp    800d4d <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800af2:	56                   	push   %esi
  800af3:	68 ee 28 80 00       	push   $0x8028ee
  800af8:	ff 75 0c             	pushl  0xc(%ebp)
  800afb:	ff 75 08             	pushl  0x8(%ebp)
  800afe:	e8 57 02 00 00       	call   800d5a <printfmt>
  800b03:	83 c4 10             	add    $0x10,%esp
			break;
  800b06:	e9 42 02 00 00       	jmp    800d4d <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800b0b:	8b 45 14             	mov    0x14(%ebp),%eax
  800b0e:	83 c0 04             	add    $0x4,%eax
  800b11:	89 45 14             	mov    %eax,0x14(%ebp)
  800b14:	8b 45 14             	mov    0x14(%ebp),%eax
  800b17:	83 e8 04             	sub    $0x4,%eax
  800b1a:	8b 30                	mov    (%eax),%esi
  800b1c:	85 f6                	test   %esi,%esi
  800b1e:	75 05                	jne    800b25 <vprintfmt+0x1a6>
				p = "(null)";
  800b20:	be f1 28 80 00       	mov    $0x8028f1,%esi
			if (width > 0 && padc != '-')
  800b25:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800b29:	7e 6d                	jle    800b98 <vprintfmt+0x219>
  800b2b:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800b2f:	74 67                	je     800b98 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800b31:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800b34:	83 ec 08             	sub    $0x8,%esp
  800b37:	50                   	push   %eax
  800b38:	56                   	push   %esi
  800b39:	e8 26 05 00 00       	call   801064 <strnlen>
  800b3e:	83 c4 10             	add    $0x10,%esp
  800b41:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800b44:	eb 16                	jmp    800b5c <vprintfmt+0x1dd>
					putch(padc, putdat);
  800b46:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800b4a:	83 ec 08             	sub    $0x8,%esp
  800b4d:	ff 75 0c             	pushl  0xc(%ebp)
  800b50:	50                   	push   %eax
  800b51:	8b 45 08             	mov    0x8(%ebp),%eax
  800b54:	ff d0                	call   *%eax
  800b56:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800b59:	ff 4d e4             	decl   -0x1c(%ebp)
  800b5c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800b60:	7f e4                	jg     800b46 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800b62:	eb 34                	jmp    800b98 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800b64:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800b68:	74 1c                	je     800b86 <vprintfmt+0x207>
  800b6a:	83 fb 1f             	cmp    $0x1f,%ebx
  800b6d:	7e 05                	jle    800b74 <vprintfmt+0x1f5>
  800b6f:	83 fb 7e             	cmp    $0x7e,%ebx
  800b72:	7e 12                	jle    800b86 <vprintfmt+0x207>
					putch('?', putdat);
  800b74:	83 ec 08             	sub    $0x8,%esp
  800b77:	ff 75 0c             	pushl  0xc(%ebp)
  800b7a:	6a 3f                	push   $0x3f
  800b7c:	8b 45 08             	mov    0x8(%ebp),%eax
  800b7f:	ff d0                	call   *%eax
  800b81:	83 c4 10             	add    $0x10,%esp
  800b84:	eb 0f                	jmp    800b95 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800b86:	83 ec 08             	sub    $0x8,%esp
  800b89:	ff 75 0c             	pushl  0xc(%ebp)
  800b8c:	53                   	push   %ebx
  800b8d:	8b 45 08             	mov    0x8(%ebp),%eax
  800b90:	ff d0                	call   *%eax
  800b92:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800b95:	ff 4d e4             	decl   -0x1c(%ebp)
  800b98:	89 f0                	mov    %esi,%eax
  800b9a:	8d 70 01             	lea    0x1(%eax),%esi
  800b9d:	8a 00                	mov    (%eax),%al
  800b9f:	0f be d8             	movsbl %al,%ebx
  800ba2:	85 db                	test   %ebx,%ebx
  800ba4:	74 24                	je     800bca <vprintfmt+0x24b>
  800ba6:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800baa:	78 b8                	js     800b64 <vprintfmt+0x1e5>
  800bac:	ff 4d e0             	decl   -0x20(%ebp)
  800baf:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800bb3:	79 af                	jns    800b64 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800bb5:	eb 13                	jmp    800bca <vprintfmt+0x24b>
				putch(' ', putdat);
  800bb7:	83 ec 08             	sub    $0x8,%esp
  800bba:	ff 75 0c             	pushl  0xc(%ebp)
  800bbd:	6a 20                	push   $0x20
  800bbf:	8b 45 08             	mov    0x8(%ebp),%eax
  800bc2:	ff d0                	call   *%eax
  800bc4:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800bc7:	ff 4d e4             	decl   -0x1c(%ebp)
  800bca:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800bce:	7f e7                	jg     800bb7 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800bd0:	e9 78 01 00 00       	jmp    800d4d <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800bd5:	83 ec 08             	sub    $0x8,%esp
  800bd8:	ff 75 e8             	pushl  -0x18(%ebp)
  800bdb:	8d 45 14             	lea    0x14(%ebp),%eax
  800bde:	50                   	push   %eax
  800bdf:	e8 3c fd ff ff       	call   800920 <getint>
  800be4:	83 c4 10             	add    $0x10,%esp
  800be7:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800bea:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800bed:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800bf0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800bf3:	85 d2                	test   %edx,%edx
  800bf5:	79 23                	jns    800c1a <vprintfmt+0x29b>
				putch('-', putdat);
  800bf7:	83 ec 08             	sub    $0x8,%esp
  800bfa:	ff 75 0c             	pushl  0xc(%ebp)
  800bfd:	6a 2d                	push   $0x2d
  800bff:	8b 45 08             	mov    0x8(%ebp),%eax
  800c02:	ff d0                	call   *%eax
  800c04:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800c07:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800c0a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800c0d:	f7 d8                	neg    %eax
  800c0f:	83 d2 00             	adc    $0x0,%edx
  800c12:	f7 da                	neg    %edx
  800c14:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c17:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800c1a:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800c21:	e9 bc 00 00 00       	jmp    800ce2 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800c26:	83 ec 08             	sub    $0x8,%esp
  800c29:	ff 75 e8             	pushl  -0x18(%ebp)
  800c2c:	8d 45 14             	lea    0x14(%ebp),%eax
  800c2f:	50                   	push   %eax
  800c30:	e8 84 fc ff ff       	call   8008b9 <getuint>
  800c35:	83 c4 10             	add    $0x10,%esp
  800c38:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c3b:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800c3e:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800c45:	e9 98 00 00 00       	jmp    800ce2 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800c4a:	83 ec 08             	sub    $0x8,%esp
  800c4d:	ff 75 0c             	pushl  0xc(%ebp)
  800c50:	6a 58                	push   $0x58
  800c52:	8b 45 08             	mov    0x8(%ebp),%eax
  800c55:	ff d0                	call   *%eax
  800c57:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800c5a:	83 ec 08             	sub    $0x8,%esp
  800c5d:	ff 75 0c             	pushl  0xc(%ebp)
  800c60:	6a 58                	push   $0x58
  800c62:	8b 45 08             	mov    0x8(%ebp),%eax
  800c65:	ff d0                	call   *%eax
  800c67:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800c6a:	83 ec 08             	sub    $0x8,%esp
  800c6d:	ff 75 0c             	pushl  0xc(%ebp)
  800c70:	6a 58                	push   $0x58
  800c72:	8b 45 08             	mov    0x8(%ebp),%eax
  800c75:	ff d0                	call   *%eax
  800c77:	83 c4 10             	add    $0x10,%esp
			break;
  800c7a:	e9 ce 00 00 00       	jmp    800d4d <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  800c7f:	83 ec 08             	sub    $0x8,%esp
  800c82:	ff 75 0c             	pushl  0xc(%ebp)
  800c85:	6a 30                	push   $0x30
  800c87:	8b 45 08             	mov    0x8(%ebp),%eax
  800c8a:	ff d0                	call   *%eax
  800c8c:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800c8f:	83 ec 08             	sub    $0x8,%esp
  800c92:	ff 75 0c             	pushl  0xc(%ebp)
  800c95:	6a 78                	push   $0x78
  800c97:	8b 45 08             	mov    0x8(%ebp),%eax
  800c9a:	ff d0                	call   *%eax
  800c9c:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800c9f:	8b 45 14             	mov    0x14(%ebp),%eax
  800ca2:	83 c0 04             	add    $0x4,%eax
  800ca5:	89 45 14             	mov    %eax,0x14(%ebp)
  800ca8:	8b 45 14             	mov    0x14(%ebp),%eax
  800cab:	83 e8 04             	sub    $0x4,%eax
  800cae:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800cb0:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800cb3:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800cba:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800cc1:	eb 1f                	jmp    800ce2 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800cc3:	83 ec 08             	sub    $0x8,%esp
  800cc6:	ff 75 e8             	pushl  -0x18(%ebp)
  800cc9:	8d 45 14             	lea    0x14(%ebp),%eax
  800ccc:	50                   	push   %eax
  800ccd:	e8 e7 fb ff ff       	call   8008b9 <getuint>
  800cd2:	83 c4 10             	add    $0x10,%esp
  800cd5:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800cd8:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800cdb:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800ce2:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800ce6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800ce9:	83 ec 04             	sub    $0x4,%esp
  800cec:	52                   	push   %edx
  800ced:	ff 75 e4             	pushl  -0x1c(%ebp)
  800cf0:	50                   	push   %eax
  800cf1:	ff 75 f4             	pushl  -0xc(%ebp)
  800cf4:	ff 75 f0             	pushl  -0x10(%ebp)
  800cf7:	ff 75 0c             	pushl  0xc(%ebp)
  800cfa:	ff 75 08             	pushl  0x8(%ebp)
  800cfd:	e8 00 fb ff ff       	call   800802 <printnum>
  800d02:	83 c4 20             	add    $0x20,%esp
			break;
  800d05:	eb 46                	jmp    800d4d <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800d07:	83 ec 08             	sub    $0x8,%esp
  800d0a:	ff 75 0c             	pushl  0xc(%ebp)
  800d0d:	53                   	push   %ebx
  800d0e:	8b 45 08             	mov    0x8(%ebp),%eax
  800d11:	ff d0                	call   *%eax
  800d13:	83 c4 10             	add    $0x10,%esp
			break;
  800d16:	eb 35                	jmp    800d4d <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  800d18:	c6 05 44 30 80 00 00 	movb   $0x0,0x803044
			break;
  800d1f:	eb 2c                	jmp    800d4d <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  800d21:	c6 05 44 30 80 00 01 	movb   $0x1,0x803044
			break;
  800d28:	eb 23                	jmp    800d4d <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800d2a:	83 ec 08             	sub    $0x8,%esp
  800d2d:	ff 75 0c             	pushl  0xc(%ebp)
  800d30:	6a 25                	push   $0x25
  800d32:	8b 45 08             	mov    0x8(%ebp),%eax
  800d35:	ff d0                	call   *%eax
  800d37:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800d3a:	ff 4d 10             	decl   0x10(%ebp)
  800d3d:	eb 03                	jmp    800d42 <vprintfmt+0x3c3>
  800d3f:	ff 4d 10             	decl   0x10(%ebp)
  800d42:	8b 45 10             	mov    0x10(%ebp),%eax
  800d45:	48                   	dec    %eax
  800d46:	8a 00                	mov    (%eax),%al
  800d48:	3c 25                	cmp    $0x25,%al
  800d4a:	75 f3                	jne    800d3f <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  800d4c:	90                   	nop
		}
	}
  800d4d:	e9 35 fc ff ff       	jmp    800987 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800d52:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800d53:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800d56:	5b                   	pop    %ebx
  800d57:	5e                   	pop    %esi
  800d58:	5d                   	pop    %ebp
  800d59:	c3                   	ret    

00800d5a <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800d5a:	55                   	push   %ebp
  800d5b:	89 e5                	mov    %esp,%ebp
  800d5d:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800d60:	8d 45 10             	lea    0x10(%ebp),%eax
  800d63:	83 c0 04             	add    $0x4,%eax
  800d66:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800d69:	8b 45 10             	mov    0x10(%ebp),%eax
  800d6c:	ff 75 f4             	pushl  -0xc(%ebp)
  800d6f:	50                   	push   %eax
  800d70:	ff 75 0c             	pushl  0xc(%ebp)
  800d73:	ff 75 08             	pushl  0x8(%ebp)
  800d76:	e8 04 fc ff ff       	call   80097f <vprintfmt>
  800d7b:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800d7e:	90                   	nop
  800d7f:	c9                   	leave  
  800d80:	c3                   	ret    

00800d81 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800d81:	55                   	push   %ebp
  800d82:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800d84:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d87:	8b 40 08             	mov    0x8(%eax),%eax
  800d8a:	8d 50 01             	lea    0x1(%eax),%edx
  800d8d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d90:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800d93:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d96:	8b 10                	mov    (%eax),%edx
  800d98:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d9b:	8b 40 04             	mov    0x4(%eax),%eax
  800d9e:	39 c2                	cmp    %eax,%edx
  800da0:	73 12                	jae    800db4 <sprintputch+0x33>
		*b->buf++ = ch;
  800da2:	8b 45 0c             	mov    0xc(%ebp),%eax
  800da5:	8b 00                	mov    (%eax),%eax
  800da7:	8d 48 01             	lea    0x1(%eax),%ecx
  800daa:	8b 55 0c             	mov    0xc(%ebp),%edx
  800dad:	89 0a                	mov    %ecx,(%edx)
  800daf:	8b 55 08             	mov    0x8(%ebp),%edx
  800db2:	88 10                	mov    %dl,(%eax)
}
  800db4:	90                   	nop
  800db5:	5d                   	pop    %ebp
  800db6:	c3                   	ret    

00800db7 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800db7:	55                   	push   %ebp
  800db8:	89 e5                	mov    %esp,%ebp
  800dba:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800dbd:	8b 45 08             	mov    0x8(%ebp),%eax
  800dc0:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800dc3:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dc6:	8d 50 ff             	lea    -0x1(%eax),%edx
  800dc9:	8b 45 08             	mov    0x8(%ebp),%eax
  800dcc:	01 d0                	add    %edx,%eax
  800dce:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800dd1:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800dd8:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800ddc:	74 06                	je     800de4 <vsnprintf+0x2d>
  800dde:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800de2:	7f 07                	jg     800deb <vsnprintf+0x34>
		return -E_INVAL;
  800de4:	b8 03 00 00 00       	mov    $0x3,%eax
  800de9:	eb 20                	jmp    800e0b <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800deb:	ff 75 14             	pushl  0x14(%ebp)
  800dee:	ff 75 10             	pushl  0x10(%ebp)
  800df1:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800df4:	50                   	push   %eax
  800df5:	68 81 0d 80 00       	push   $0x800d81
  800dfa:	e8 80 fb ff ff       	call   80097f <vprintfmt>
  800dff:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800e02:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800e05:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800e08:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800e0b:	c9                   	leave  
  800e0c:	c3                   	ret    

00800e0d <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800e0d:	55                   	push   %ebp
  800e0e:	89 e5                	mov    %esp,%ebp
  800e10:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800e13:	8d 45 10             	lea    0x10(%ebp),%eax
  800e16:	83 c0 04             	add    $0x4,%eax
  800e19:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800e1c:	8b 45 10             	mov    0x10(%ebp),%eax
  800e1f:	ff 75 f4             	pushl  -0xc(%ebp)
  800e22:	50                   	push   %eax
  800e23:	ff 75 0c             	pushl  0xc(%ebp)
  800e26:	ff 75 08             	pushl  0x8(%ebp)
  800e29:	e8 89 ff ff ff       	call   800db7 <vsnprintf>
  800e2e:	83 c4 10             	add    $0x10,%esp
  800e31:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800e34:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800e37:	c9                   	leave  
  800e38:	c3                   	ret    

00800e39 <readline>:
#include <inc/lib.h>

//static char buf[BUFLEN];

void readline(const char *prompt, char* buf)
{
  800e39:	55                   	push   %ebp
  800e3a:	89 e5                	mov    %esp,%ebp
  800e3c:	83 ec 18             	sub    $0x18,%esp
	int i, c, echoing;

	if (prompt != NULL)
  800e3f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800e43:	74 13                	je     800e58 <readline+0x1f>
		cprintf("%s", prompt);
  800e45:	83 ec 08             	sub    $0x8,%esp
  800e48:	ff 75 08             	pushl  0x8(%ebp)
  800e4b:	68 68 2a 80 00       	push   $0x802a68
  800e50:	e8 0b f9 ff ff       	call   800760 <cprintf>
  800e55:	83 c4 10             	add    $0x10,%esp

	i = 0;
  800e58:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	echoing = iscons(0);
  800e5f:	83 ec 0c             	sub    $0xc,%esp
  800e62:	6a 00                	push   $0x0
  800e64:	e8 7e 10 00 00       	call   801ee7 <iscons>
  800e69:	83 c4 10             	add    $0x10,%esp
  800e6c:	89 45 f0             	mov    %eax,-0x10(%ebp)
	while (1) {
		c = getchar();
  800e6f:	e8 60 10 00 00       	call   801ed4 <getchar>
  800e74:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if (c < 0) {
  800e77:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800e7b:	79 22                	jns    800e9f <readline+0x66>
			if (c != -E_EOF)
  800e7d:	83 7d ec 07          	cmpl   $0x7,-0x14(%ebp)
  800e81:	0f 84 ad 00 00 00    	je     800f34 <readline+0xfb>
				cprintf("read error: %e\n", c);
  800e87:	83 ec 08             	sub    $0x8,%esp
  800e8a:	ff 75 ec             	pushl  -0x14(%ebp)
  800e8d:	68 6b 2a 80 00       	push   $0x802a6b
  800e92:	e8 c9 f8 ff ff       	call   800760 <cprintf>
  800e97:	83 c4 10             	add    $0x10,%esp
			break;
  800e9a:	e9 95 00 00 00       	jmp    800f34 <readline+0xfb>
		} else if (c >= ' ' && i < BUFLEN-1) {
  800e9f:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%ebp)
  800ea3:	7e 34                	jle    800ed9 <readline+0xa0>
  800ea5:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  800eac:	7f 2b                	jg     800ed9 <readline+0xa0>
			if (echoing)
  800eae:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800eb2:	74 0e                	je     800ec2 <readline+0x89>
				cputchar(c);
  800eb4:	83 ec 0c             	sub    $0xc,%esp
  800eb7:	ff 75 ec             	pushl  -0x14(%ebp)
  800eba:	e8 f6 0f 00 00       	call   801eb5 <cputchar>
  800ebf:	83 c4 10             	add    $0x10,%esp
			buf[i++] = c;
  800ec2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800ec5:	8d 50 01             	lea    0x1(%eax),%edx
  800ec8:	89 55 f4             	mov    %edx,-0xc(%ebp)
  800ecb:	89 c2                	mov    %eax,%edx
  800ecd:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ed0:	01 d0                	add    %edx,%eax
  800ed2:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800ed5:	88 10                	mov    %dl,(%eax)
  800ed7:	eb 56                	jmp    800f2f <readline+0xf6>
		} else if (c == '\b' && i > 0) {
  800ed9:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  800edd:	75 1f                	jne    800efe <readline+0xc5>
  800edf:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  800ee3:	7e 19                	jle    800efe <readline+0xc5>
			if (echoing)
  800ee5:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800ee9:	74 0e                	je     800ef9 <readline+0xc0>
				cputchar(c);
  800eeb:	83 ec 0c             	sub    $0xc,%esp
  800eee:	ff 75 ec             	pushl  -0x14(%ebp)
  800ef1:	e8 bf 0f 00 00       	call   801eb5 <cputchar>
  800ef6:	83 c4 10             	add    $0x10,%esp

			i--;
  800ef9:	ff 4d f4             	decl   -0xc(%ebp)
  800efc:	eb 31                	jmp    800f2f <readline+0xf6>
		} else if (c == '\n' || c == '\r') {
  800efe:	83 7d ec 0a          	cmpl   $0xa,-0x14(%ebp)
  800f02:	74 0a                	je     800f0e <readline+0xd5>
  800f04:	83 7d ec 0d          	cmpl   $0xd,-0x14(%ebp)
  800f08:	0f 85 61 ff ff ff    	jne    800e6f <readline+0x36>
			if (echoing)
  800f0e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800f12:	74 0e                	je     800f22 <readline+0xe9>
				cputchar(c);
  800f14:	83 ec 0c             	sub    $0xc,%esp
  800f17:	ff 75 ec             	pushl  -0x14(%ebp)
  800f1a:	e8 96 0f 00 00       	call   801eb5 <cputchar>
  800f1f:	83 c4 10             	add    $0x10,%esp

			buf[i] = 0;
  800f22:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800f25:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f28:	01 d0                	add    %edx,%eax
  800f2a:	c6 00 00             	movb   $0x0,(%eax)
			break;
  800f2d:	eb 06                	jmp    800f35 <readline+0xfc>
		}
	}
  800f2f:	e9 3b ff ff ff       	jmp    800e6f <readline+0x36>
	while (1) {
		c = getchar();
		if (c < 0) {
			if (c != -E_EOF)
				cprintf("read error: %e\n", c);
			break;
  800f34:	90                   	nop

			buf[i] = 0;
			break;
		}
	}
}
  800f35:	90                   	nop
  800f36:	c9                   	leave  
  800f37:	c3                   	ret    

00800f38 <atomic_readline>:

void atomic_readline(const char *prompt, char* buf)
{
  800f38:	55                   	push   %ebp
  800f39:	89 e5                	mov    %esp,%ebp
  800f3b:	83 ec 18             	sub    $0x18,%esp
	sys_lock_cons();
  800f3e:	e8 79 09 00 00       	call   8018bc <sys_lock_cons>
	{
		int i, c, echoing;

		if (prompt != NULL)
  800f43:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800f47:	74 13                	je     800f5c <atomic_readline+0x24>
			cprintf("%s", prompt);
  800f49:	83 ec 08             	sub    $0x8,%esp
  800f4c:	ff 75 08             	pushl  0x8(%ebp)
  800f4f:	68 68 2a 80 00       	push   $0x802a68
  800f54:	e8 07 f8 ff ff       	call   800760 <cprintf>
  800f59:	83 c4 10             	add    $0x10,%esp

		i = 0;
  800f5c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
		echoing = iscons(0);
  800f63:	83 ec 0c             	sub    $0xc,%esp
  800f66:	6a 00                	push   $0x0
  800f68:	e8 7a 0f 00 00       	call   801ee7 <iscons>
  800f6d:	83 c4 10             	add    $0x10,%esp
  800f70:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (1) {
			c = getchar();
  800f73:	e8 5c 0f 00 00       	call   801ed4 <getchar>
  800f78:	89 45 ec             	mov    %eax,-0x14(%ebp)
			if (c < 0) {
  800f7b:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800f7f:	79 22                	jns    800fa3 <atomic_readline+0x6b>
				if (c != -E_EOF)
  800f81:	83 7d ec 07          	cmpl   $0x7,-0x14(%ebp)
  800f85:	0f 84 ad 00 00 00    	je     801038 <atomic_readline+0x100>
					cprintf("read error: %e\n", c);
  800f8b:	83 ec 08             	sub    $0x8,%esp
  800f8e:	ff 75 ec             	pushl  -0x14(%ebp)
  800f91:	68 6b 2a 80 00       	push   $0x802a6b
  800f96:	e8 c5 f7 ff ff       	call   800760 <cprintf>
  800f9b:	83 c4 10             	add    $0x10,%esp
				break;
  800f9e:	e9 95 00 00 00       	jmp    801038 <atomic_readline+0x100>
			} else if (c >= ' ' && i < BUFLEN-1) {
  800fa3:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%ebp)
  800fa7:	7e 34                	jle    800fdd <atomic_readline+0xa5>
  800fa9:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  800fb0:	7f 2b                	jg     800fdd <atomic_readline+0xa5>
				if (echoing)
  800fb2:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800fb6:	74 0e                	je     800fc6 <atomic_readline+0x8e>
					cputchar(c);
  800fb8:	83 ec 0c             	sub    $0xc,%esp
  800fbb:	ff 75 ec             	pushl  -0x14(%ebp)
  800fbe:	e8 f2 0e 00 00       	call   801eb5 <cputchar>
  800fc3:	83 c4 10             	add    $0x10,%esp
				buf[i++] = c;
  800fc6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800fc9:	8d 50 01             	lea    0x1(%eax),%edx
  800fcc:	89 55 f4             	mov    %edx,-0xc(%ebp)
  800fcf:	89 c2                	mov    %eax,%edx
  800fd1:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fd4:	01 d0                	add    %edx,%eax
  800fd6:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800fd9:	88 10                	mov    %dl,(%eax)
  800fdb:	eb 56                	jmp    801033 <atomic_readline+0xfb>
			} else if (c == '\b' && i > 0) {
  800fdd:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  800fe1:	75 1f                	jne    801002 <atomic_readline+0xca>
  800fe3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  800fe7:	7e 19                	jle    801002 <atomic_readline+0xca>
				if (echoing)
  800fe9:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800fed:	74 0e                	je     800ffd <atomic_readline+0xc5>
					cputchar(c);
  800fef:	83 ec 0c             	sub    $0xc,%esp
  800ff2:	ff 75 ec             	pushl  -0x14(%ebp)
  800ff5:	e8 bb 0e 00 00       	call   801eb5 <cputchar>
  800ffa:	83 c4 10             	add    $0x10,%esp
				i--;
  800ffd:	ff 4d f4             	decl   -0xc(%ebp)
  801000:	eb 31                	jmp    801033 <atomic_readline+0xfb>
			} else if (c == '\n' || c == '\r') {
  801002:	83 7d ec 0a          	cmpl   $0xa,-0x14(%ebp)
  801006:	74 0a                	je     801012 <atomic_readline+0xda>
  801008:	83 7d ec 0d          	cmpl   $0xd,-0x14(%ebp)
  80100c:	0f 85 61 ff ff ff    	jne    800f73 <atomic_readline+0x3b>
				if (echoing)
  801012:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801016:	74 0e                	je     801026 <atomic_readline+0xee>
					cputchar(c);
  801018:	83 ec 0c             	sub    $0xc,%esp
  80101b:	ff 75 ec             	pushl  -0x14(%ebp)
  80101e:	e8 92 0e 00 00       	call   801eb5 <cputchar>
  801023:	83 c4 10             	add    $0x10,%esp
				buf[i] = 0;
  801026:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801029:	8b 45 0c             	mov    0xc(%ebp),%eax
  80102c:	01 d0                	add    %edx,%eax
  80102e:	c6 00 00             	movb   $0x0,(%eax)
				break;
  801031:	eb 06                	jmp    801039 <atomic_readline+0x101>
			}
		}
  801033:	e9 3b ff ff ff       	jmp    800f73 <atomic_readline+0x3b>
		while (1) {
			c = getchar();
			if (c < 0) {
				if (c != -E_EOF)
					cprintf("read error: %e\n", c);
				break;
  801038:	90                   	nop
				buf[i] = 0;
				break;
			}
		}
	}
	sys_unlock_cons();
  801039:	e8 98 08 00 00       	call   8018d6 <sys_unlock_cons>
}
  80103e:	90                   	nop
  80103f:	c9                   	leave  
  801040:	c3                   	ret    

00801041 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  801041:	55                   	push   %ebp
  801042:	89 e5                	mov    %esp,%ebp
  801044:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  801047:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80104e:	eb 06                	jmp    801056 <strlen+0x15>
		n++;
  801050:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  801053:	ff 45 08             	incl   0x8(%ebp)
  801056:	8b 45 08             	mov    0x8(%ebp),%eax
  801059:	8a 00                	mov    (%eax),%al
  80105b:	84 c0                	test   %al,%al
  80105d:	75 f1                	jne    801050 <strlen+0xf>
		n++;
	return n;
  80105f:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801062:	c9                   	leave  
  801063:	c3                   	ret    

00801064 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  801064:	55                   	push   %ebp
  801065:	89 e5                	mov    %esp,%ebp
  801067:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80106a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801071:	eb 09                	jmp    80107c <strnlen+0x18>
		n++;
  801073:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801076:	ff 45 08             	incl   0x8(%ebp)
  801079:	ff 4d 0c             	decl   0xc(%ebp)
  80107c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801080:	74 09                	je     80108b <strnlen+0x27>
  801082:	8b 45 08             	mov    0x8(%ebp),%eax
  801085:	8a 00                	mov    (%eax),%al
  801087:	84 c0                	test   %al,%al
  801089:	75 e8                	jne    801073 <strnlen+0xf>
		n++;
	return n;
  80108b:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  80108e:	c9                   	leave  
  80108f:	c3                   	ret    

00801090 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  801090:	55                   	push   %ebp
  801091:	89 e5                	mov    %esp,%ebp
  801093:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  801096:	8b 45 08             	mov    0x8(%ebp),%eax
  801099:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  80109c:	90                   	nop
  80109d:	8b 45 08             	mov    0x8(%ebp),%eax
  8010a0:	8d 50 01             	lea    0x1(%eax),%edx
  8010a3:	89 55 08             	mov    %edx,0x8(%ebp)
  8010a6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8010a9:	8d 4a 01             	lea    0x1(%edx),%ecx
  8010ac:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  8010af:	8a 12                	mov    (%edx),%dl
  8010b1:	88 10                	mov    %dl,(%eax)
  8010b3:	8a 00                	mov    (%eax),%al
  8010b5:	84 c0                	test   %al,%al
  8010b7:	75 e4                	jne    80109d <strcpy+0xd>
		/* do nothing */;
	return ret;
  8010b9:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8010bc:	c9                   	leave  
  8010bd:	c3                   	ret    

008010be <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  8010be:	55                   	push   %ebp
  8010bf:	89 e5                	mov    %esp,%ebp
  8010c1:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  8010c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8010c7:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  8010ca:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8010d1:	eb 1f                	jmp    8010f2 <strncpy+0x34>
		*dst++ = *src;
  8010d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8010d6:	8d 50 01             	lea    0x1(%eax),%edx
  8010d9:	89 55 08             	mov    %edx,0x8(%ebp)
  8010dc:	8b 55 0c             	mov    0xc(%ebp),%edx
  8010df:	8a 12                	mov    (%edx),%dl
  8010e1:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  8010e3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010e6:	8a 00                	mov    (%eax),%al
  8010e8:	84 c0                	test   %al,%al
  8010ea:	74 03                	je     8010ef <strncpy+0x31>
			src++;
  8010ec:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8010ef:	ff 45 fc             	incl   -0x4(%ebp)
  8010f2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8010f5:	3b 45 10             	cmp    0x10(%ebp),%eax
  8010f8:	72 d9                	jb     8010d3 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  8010fa:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8010fd:	c9                   	leave  
  8010fe:	c3                   	ret    

008010ff <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  8010ff:	55                   	push   %ebp
  801100:	89 e5                	mov    %esp,%ebp
  801102:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  801105:	8b 45 08             	mov    0x8(%ebp),%eax
  801108:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  80110b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80110f:	74 30                	je     801141 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  801111:	eb 16                	jmp    801129 <strlcpy+0x2a>
			*dst++ = *src++;
  801113:	8b 45 08             	mov    0x8(%ebp),%eax
  801116:	8d 50 01             	lea    0x1(%eax),%edx
  801119:	89 55 08             	mov    %edx,0x8(%ebp)
  80111c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80111f:	8d 4a 01             	lea    0x1(%edx),%ecx
  801122:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  801125:	8a 12                	mov    (%edx),%dl
  801127:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  801129:	ff 4d 10             	decl   0x10(%ebp)
  80112c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801130:	74 09                	je     80113b <strlcpy+0x3c>
  801132:	8b 45 0c             	mov    0xc(%ebp),%eax
  801135:	8a 00                	mov    (%eax),%al
  801137:	84 c0                	test   %al,%al
  801139:	75 d8                	jne    801113 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  80113b:	8b 45 08             	mov    0x8(%ebp),%eax
  80113e:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  801141:	8b 55 08             	mov    0x8(%ebp),%edx
  801144:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801147:	29 c2                	sub    %eax,%edx
  801149:	89 d0                	mov    %edx,%eax
}
  80114b:	c9                   	leave  
  80114c:	c3                   	ret    

0080114d <strcmp>:

int
strcmp(const char *p, const char *q)
{
  80114d:	55                   	push   %ebp
  80114e:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  801150:	eb 06                	jmp    801158 <strcmp+0xb>
		p++, q++;
  801152:	ff 45 08             	incl   0x8(%ebp)
  801155:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  801158:	8b 45 08             	mov    0x8(%ebp),%eax
  80115b:	8a 00                	mov    (%eax),%al
  80115d:	84 c0                	test   %al,%al
  80115f:	74 0e                	je     80116f <strcmp+0x22>
  801161:	8b 45 08             	mov    0x8(%ebp),%eax
  801164:	8a 10                	mov    (%eax),%dl
  801166:	8b 45 0c             	mov    0xc(%ebp),%eax
  801169:	8a 00                	mov    (%eax),%al
  80116b:	38 c2                	cmp    %al,%dl
  80116d:	74 e3                	je     801152 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  80116f:	8b 45 08             	mov    0x8(%ebp),%eax
  801172:	8a 00                	mov    (%eax),%al
  801174:	0f b6 d0             	movzbl %al,%edx
  801177:	8b 45 0c             	mov    0xc(%ebp),%eax
  80117a:	8a 00                	mov    (%eax),%al
  80117c:	0f b6 c0             	movzbl %al,%eax
  80117f:	29 c2                	sub    %eax,%edx
  801181:	89 d0                	mov    %edx,%eax
}
  801183:	5d                   	pop    %ebp
  801184:	c3                   	ret    

00801185 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  801185:	55                   	push   %ebp
  801186:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  801188:	eb 09                	jmp    801193 <strncmp+0xe>
		n--, p++, q++;
  80118a:	ff 4d 10             	decl   0x10(%ebp)
  80118d:	ff 45 08             	incl   0x8(%ebp)
  801190:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  801193:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801197:	74 17                	je     8011b0 <strncmp+0x2b>
  801199:	8b 45 08             	mov    0x8(%ebp),%eax
  80119c:	8a 00                	mov    (%eax),%al
  80119e:	84 c0                	test   %al,%al
  8011a0:	74 0e                	je     8011b0 <strncmp+0x2b>
  8011a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8011a5:	8a 10                	mov    (%eax),%dl
  8011a7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011aa:	8a 00                	mov    (%eax),%al
  8011ac:	38 c2                	cmp    %al,%dl
  8011ae:	74 da                	je     80118a <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  8011b0:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8011b4:	75 07                	jne    8011bd <strncmp+0x38>
		return 0;
  8011b6:	b8 00 00 00 00       	mov    $0x0,%eax
  8011bb:	eb 14                	jmp    8011d1 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8011bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8011c0:	8a 00                	mov    (%eax),%al
  8011c2:	0f b6 d0             	movzbl %al,%edx
  8011c5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011c8:	8a 00                	mov    (%eax),%al
  8011ca:	0f b6 c0             	movzbl %al,%eax
  8011cd:	29 c2                	sub    %eax,%edx
  8011cf:	89 d0                	mov    %edx,%eax
}
  8011d1:	5d                   	pop    %ebp
  8011d2:	c3                   	ret    

008011d3 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8011d3:	55                   	push   %ebp
  8011d4:	89 e5                	mov    %esp,%ebp
  8011d6:	83 ec 04             	sub    $0x4,%esp
  8011d9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011dc:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  8011df:	eb 12                	jmp    8011f3 <strchr+0x20>
		if (*s == c)
  8011e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8011e4:	8a 00                	mov    (%eax),%al
  8011e6:	3a 45 fc             	cmp    -0x4(%ebp),%al
  8011e9:	75 05                	jne    8011f0 <strchr+0x1d>
			return (char *) s;
  8011eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8011ee:	eb 11                	jmp    801201 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  8011f0:	ff 45 08             	incl   0x8(%ebp)
  8011f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8011f6:	8a 00                	mov    (%eax),%al
  8011f8:	84 c0                	test   %al,%al
  8011fa:	75 e5                	jne    8011e1 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  8011fc:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801201:	c9                   	leave  
  801202:	c3                   	ret    

00801203 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  801203:	55                   	push   %ebp
  801204:	89 e5                	mov    %esp,%ebp
  801206:	83 ec 04             	sub    $0x4,%esp
  801209:	8b 45 0c             	mov    0xc(%ebp),%eax
  80120c:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  80120f:	eb 0d                	jmp    80121e <strfind+0x1b>
		if (*s == c)
  801211:	8b 45 08             	mov    0x8(%ebp),%eax
  801214:	8a 00                	mov    (%eax),%al
  801216:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801219:	74 0e                	je     801229 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  80121b:	ff 45 08             	incl   0x8(%ebp)
  80121e:	8b 45 08             	mov    0x8(%ebp),%eax
  801221:	8a 00                	mov    (%eax),%al
  801223:	84 c0                	test   %al,%al
  801225:	75 ea                	jne    801211 <strfind+0xe>
  801227:	eb 01                	jmp    80122a <strfind+0x27>
		if (*s == c)
			break;
  801229:	90                   	nop
	return (char *) s;
  80122a:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80122d:	c9                   	leave  
  80122e:	c3                   	ret    

0080122f <memset>:

// *************** The faster implementation of memset & memcpy is implemented by *************
// ****************** Team80 (Yahia Khaled, Malek Ahmed et al) - FCIS'24-25 *******************
void *
memset(void *v, int c, uint32 n)
{
  80122f:	55                   	push   %ebp
  801230:	89 e5                	mov    %esp,%ebp
  801232:	83 ec 10             	sub    $0x10,%esp
//	m = n;
//	while (--m >= 0)
//		*p++ = c;

	/*Faster Implementation*/
	uint64* p64 = (uint64*)v;
  801235:	8b 45 08             	mov    0x8(%ebp),%eax
  801238:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if(n >= 8){
  80123b:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  80123f:	76 63                	jbe    8012a4 <memset+0x75>
		uint64 data_block = c;
  801241:	8b 45 0c             	mov    0xc(%ebp),%eax
  801244:	99                   	cltd   
  801245:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801248:	89 55 f4             	mov    %edx,-0xc(%ebp)
		data_block |= data_block << 8;
  80124b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80124e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801251:	0f a4 c2 08          	shld   $0x8,%eax,%edx
  801255:	c1 e0 08             	shl    $0x8,%eax
  801258:	09 45 f0             	or     %eax,-0x10(%ebp)
  80125b:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 16;
  80125e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801261:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801264:	0f a4 c2 10          	shld   $0x10,%eax,%edx
  801268:	c1 e0 10             	shl    $0x10,%eax
  80126b:	09 45 f0             	or     %eax,-0x10(%ebp)
  80126e:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 32;
  801271:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801274:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801277:	89 c2                	mov    %eax,%edx
  801279:	b8 00 00 00 00       	mov    $0x0,%eax
  80127e:	09 45 f0             	or     %eax,-0x10(%ebp)
  801281:	09 55 f4             	or     %edx,-0xc(%ebp)

		while(n >= 8)
  801284:	eb 18                	jmp    80129e <memset+0x6f>
			*p64++ = data_block, n -= 8;
  801286:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801289:	8d 41 08             	lea    0x8(%ecx),%eax
  80128c:	89 45 fc             	mov    %eax,-0x4(%ebp)
  80128f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801292:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801295:	89 01                	mov    %eax,(%ecx)
  801297:	89 51 04             	mov    %edx,0x4(%ecx)
  80129a:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
		uint64 data_block = c;
		data_block |= data_block << 8;
		data_block |= data_block << 16;
		data_block |= data_block << 32;

		while(n >= 8)
  80129e:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  8012a2:	77 e2                	ja     801286 <memset+0x57>
			*p64++ = data_block, n -= 8;
	}

	if(n){
  8012a4:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8012a8:	74 23                	je     8012cd <memset+0x9e>
		uint8* p8 = (uint8*)p64;
  8012aa:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8012ad:	89 45 f8             	mov    %eax,-0x8(%ebp)
		while (n-- > 0)
  8012b0:	eb 0e                	jmp    8012c0 <memset+0x91>
			*p8++ = (uint8)c;
  8012b2:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8012b5:	8d 50 01             	lea    0x1(%eax),%edx
  8012b8:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8012bb:	8b 55 0c             	mov    0xc(%ebp),%edx
  8012be:	88 10                	mov    %dl,(%eax)
			*p64++ = data_block, n -= 8;
	}

	if(n){
		uint8* p8 = (uint8*)p64;
		while (n-- > 0)
  8012c0:	8b 45 10             	mov    0x10(%ebp),%eax
  8012c3:	8d 50 ff             	lea    -0x1(%eax),%edx
  8012c6:	89 55 10             	mov    %edx,0x10(%ebp)
  8012c9:	85 c0                	test   %eax,%eax
  8012cb:	75 e5                	jne    8012b2 <memset+0x83>
			*p8++ = (uint8)c;
	}

	return v;
  8012cd:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8012d0:	c9                   	leave  
  8012d1:	c3                   	ret    

008012d2 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  8012d2:	55                   	push   %ebp
  8012d3:	89 e5                	mov    %esp,%ebp
  8012d5:	83 ec 10             	sub    $0x10,%esp
	//	s = src;
	//	d = dst;
	//	while (n-- > 0)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
  8012d8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012db:	89 45 fc             	mov    %eax,-0x4(%ebp)
	uint64* d64 = (uint64*)dst;
  8012de:	8b 45 08             	mov    0x8(%ebp),%eax
  8012e1:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if(n >= 8){
  8012e4:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  8012e8:	76 24                	jbe    80130e <memcpy+0x3c>
		while(n >= 8){
  8012ea:	eb 1c                	jmp    801308 <memcpy+0x36>
			*d64 = *s64;
  8012ec:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8012ef:	8b 50 04             	mov    0x4(%eax),%edx
  8012f2:	8b 00                	mov    (%eax),%eax
  8012f4:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8012f7:	89 01                	mov    %eax,(%ecx)
  8012f9:	89 51 04             	mov    %edx,0x4(%ecx)
			n -= 8;
  8012fc:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
			++s64;
  801300:	83 45 fc 08          	addl   $0x8,-0x4(%ebp)
			++d64;
  801304:	83 45 f8 08          	addl   $0x8,-0x8(%ebp)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
	uint64* d64 = (uint64*)dst;
	if(n >= 8){
		while(n >= 8){
  801308:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  80130c:	77 de                	ja     8012ec <memcpy+0x1a>
			++s64;
			++d64;
		}
	}

	if(n){
  80130e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801312:	74 31                	je     801345 <memcpy+0x73>
		uint8* s8 = (uint8*)s64;
  801314:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801317:	89 45 f4             	mov    %eax,-0xc(%ebp)
		uint8* d8 = (uint8*)d64;
  80131a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80131d:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (n-- > 0)
  801320:	eb 16                	jmp    801338 <memcpy+0x66>
			*d8++ = *s8++;
  801322:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801325:	8d 50 01             	lea    0x1(%eax),%edx
  801328:	89 55 f0             	mov    %edx,-0x10(%ebp)
  80132b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80132e:	8d 4a 01             	lea    0x1(%edx),%ecx
  801331:	89 4d f4             	mov    %ecx,-0xc(%ebp)
  801334:	8a 12                	mov    (%edx),%dl
  801336:	88 10                	mov    %dl,(%eax)
	}

	if(n){
		uint8* s8 = (uint8*)s64;
		uint8* d8 = (uint8*)d64;
		while (n-- > 0)
  801338:	8b 45 10             	mov    0x10(%ebp),%eax
  80133b:	8d 50 ff             	lea    -0x1(%eax),%edx
  80133e:	89 55 10             	mov    %edx,0x10(%ebp)
  801341:	85 c0                	test   %eax,%eax
  801343:	75 dd                	jne    801322 <memcpy+0x50>
			*d8++ = *s8++;
	}
	return dst;
  801345:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801348:	c9                   	leave  
  801349:	c3                   	ret    

0080134a <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  80134a:	55                   	push   %ebp
  80134b:	89 e5                	mov    %esp,%ebp
  80134d:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801350:	8b 45 0c             	mov    0xc(%ebp),%eax
  801353:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801356:	8b 45 08             	mov    0x8(%ebp),%eax
  801359:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  80135c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80135f:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801362:	73 50                	jae    8013b4 <memmove+0x6a>
  801364:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801367:	8b 45 10             	mov    0x10(%ebp),%eax
  80136a:	01 d0                	add    %edx,%eax
  80136c:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  80136f:	76 43                	jbe    8013b4 <memmove+0x6a>
		s += n;
  801371:	8b 45 10             	mov    0x10(%ebp),%eax
  801374:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  801377:	8b 45 10             	mov    0x10(%ebp),%eax
  80137a:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  80137d:	eb 10                	jmp    80138f <memmove+0x45>
			*--d = *--s;
  80137f:	ff 4d f8             	decl   -0x8(%ebp)
  801382:	ff 4d fc             	decl   -0x4(%ebp)
  801385:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801388:	8a 10                	mov    (%eax),%dl
  80138a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80138d:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  80138f:	8b 45 10             	mov    0x10(%ebp),%eax
  801392:	8d 50 ff             	lea    -0x1(%eax),%edx
  801395:	89 55 10             	mov    %edx,0x10(%ebp)
  801398:	85 c0                	test   %eax,%eax
  80139a:	75 e3                	jne    80137f <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  80139c:	eb 23                	jmp    8013c1 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  80139e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8013a1:	8d 50 01             	lea    0x1(%eax),%edx
  8013a4:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8013a7:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8013aa:	8d 4a 01             	lea    0x1(%edx),%ecx
  8013ad:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  8013b0:	8a 12                	mov    (%edx),%dl
  8013b2:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  8013b4:	8b 45 10             	mov    0x10(%ebp),%eax
  8013b7:	8d 50 ff             	lea    -0x1(%eax),%edx
  8013ba:	89 55 10             	mov    %edx,0x10(%ebp)
  8013bd:	85 c0                	test   %eax,%eax
  8013bf:	75 dd                	jne    80139e <memmove+0x54>
			*d++ = *s++;

	return dst;
  8013c1:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8013c4:	c9                   	leave  
  8013c5:	c3                   	ret    

008013c6 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  8013c6:	55                   	push   %ebp
  8013c7:	89 e5                	mov    %esp,%ebp
  8013c9:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  8013cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8013cf:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  8013d2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013d5:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  8013d8:	eb 2a                	jmp    801404 <memcmp+0x3e>
		if (*s1 != *s2)
  8013da:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8013dd:	8a 10                	mov    (%eax),%dl
  8013df:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8013e2:	8a 00                	mov    (%eax),%al
  8013e4:	38 c2                	cmp    %al,%dl
  8013e6:	74 16                	je     8013fe <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  8013e8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8013eb:	8a 00                	mov    (%eax),%al
  8013ed:	0f b6 d0             	movzbl %al,%edx
  8013f0:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8013f3:	8a 00                	mov    (%eax),%al
  8013f5:	0f b6 c0             	movzbl %al,%eax
  8013f8:	29 c2                	sub    %eax,%edx
  8013fa:	89 d0                	mov    %edx,%eax
  8013fc:	eb 18                	jmp    801416 <memcmp+0x50>
		s1++, s2++;
  8013fe:	ff 45 fc             	incl   -0x4(%ebp)
  801401:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  801404:	8b 45 10             	mov    0x10(%ebp),%eax
  801407:	8d 50 ff             	lea    -0x1(%eax),%edx
  80140a:	89 55 10             	mov    %edx,0x10(%ebp)
  80140d:	85 c0                	test   %eax,%eax
  80140f:	75 c9                	jne    8013da <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801411:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801416:	c9                   	leave  
  801417:	c3                   	ret    

00801418 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  801418:	55                   	push   %ebp
  801419:	89 e5                	mov    %esp,%ebp
  80141b:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  80141e:	8b 55 08             	mov    0x8(%ebp),%edx
  801421:	8b 45 10             	mov    0x10(%ebp),%eax
  801424:	01 d0                	add    %edx,%eax
  801426:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  801429:	eb 15                	jmp    801440 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  80142b:	8b 45 08             	mov    0x8(%ebp),%eax
  80142e:	8a 00                	mov    (%eax),%al
  801430:	0f b6 d0             	movzbl %al,%edx
  801433:	8b 45 0c             	mov    0xc(%ebp),%eax
  801436:	0f b6 c0             	movzbl %al,%eax
  801439:	39 c2                	cmp    %eax,%edx
  80143b:	74 0d                	je     80144a <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  80143d:	ff 45 08             	incl   0x8(%ebp)
  801440:	8b 45 08             	mov    0x8(%ebp),%eax
  801443:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801446:	72 e3                	jb     80142b <memfind+0x13>
  801448:	eb 01                	jmp    80144b <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  80144a:	90                   	nop
	return (void *) s;
  80144b:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80144e:	c9                   	leave  
  80144f:	c3                   	ret    

00801450 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801450:	55                   	push   %ebp
  801451:	89 e5                	mov    %esp,%ebp
  801453:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  801456:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  80145d:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801464:	eb 03                	jmp    801469 <strtol+0x19>
		s++;
  801466:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801469:	8b 45 08             	mov    0x8(%ebp),%eax
  80146c:	8a 00                	mov    (%eax),%al
  80146e:	3c 20                	cmp    $0x20,%al
  801470:	74 f4                	je     801466 <strtol+0x16>
  801472:	8b 45 08             	mov    0x8(%ebp),%eax
  801475:	8a 00                	mov    (%eax),%al
  801477:	3c 09                	cmp    $0x9,%al
  801479:	74 eb                	je     801466 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  80147b:	8b 45 08             	mov    0x8(%ebp),%eax
  80147e:	8a 00                	mov    (%eax),%al
  801480:	3c 2b                	cmp    $0x2b,%al
  801482:	75 05                	jne    801489 <strtol+0x39>
		s++;
  801484:	ff 45 08             	incl   0x8(%ebp)
  801487:	eb 13                	jmp    80149c <strtol+0x4c>
	else if (*s == '-')
  801489:	8b 45 08             	mov    0x8(%ebp),%eax
  80148c:	8a 00                	mov    (%eax),%al
  80148e:	3c 2d                	cmp    $0x2d,%al
  801490:	75 0a                	jne    80149c <strtol+0x4c>
		s++, neg = 1;
  801492:	ff 45 08             	incl   0x8(%ebp)
  801495:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  80149c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8014a0:	74 06                	je     8014a8 <strtol+0x58>
  8014a2:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  8014a6:	75 20                	jne    8014c8 <strtol+0x78>
  8014a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8014ab:	8a 00                	mov    (%eax),%al
  8014ad:	3c 30                	cmp    $0x30,%al
  8014af:	75 17                	jne    8014c8 <strtol+0x78>
  8014b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8014b4:	40                   	inc    %eax
  8014b5:	8a 00                	mov    (%eax),%al
  8014b7:	3c 78                	cmp    $0x78,%al
  8014b9:	75 0d                	jne    8014c8 <strtol+0x78>
		s += 2, base = 16;
  8014bb:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  8014bf:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  8014c6:	eb 28                	jmp    8014f0 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  8014c8:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8014cc:	75 15                	jne    8014e3 <strtol+0x93>
  8014ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8014d1:	8a 00                	mov    (%eax),%al
  8014d3:	3c 30                	cmp    $0x30,%al
  8014d5:	75 0c                	jne    8014e3 <strtol+0x93>
		s++, base = 8;
  8014d7:	ff 45 08             	incl   0x8(%ebp)
  8014da:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  8014e1:	eb 0d                	jmp    8014f0 <strtol+0xa0>
	else if (base == 0)
  8014e3:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8014e7:	75 07                	jne    8014f0 <strtol+0xa0>
		base = 10;
  8014e9:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8014f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8014f3:	8a 00                	mov    (%eax),%al
  8014f5:	3c 2f                	cmp    $0x2f,%al
  8014f7:	7e 19                	jle    801512 <strtol+0xc2>
  8014f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8014fc:	8a 00                	mov    (%eax),%al
  8014fe:	3c 39                	cmp    $0x39,%al
  801500:	7f 10                	jg     801512 <strtol+0xc2>
			dig = *s - '0';
  801502:	8b 45 08             	mov    0x8(%ebp),%eax
  801505:	8a 00                	mov    (%eax),%al
  801507:	0f be c0             	movsbl %al,%eax
  80150a:	83 e8 30             	sub    $0x30,%eax
  80150d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801510:	eb 42                	jmp    801554 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  801512:	8b 45 08             	mov    0x8(%ebp),%eax
  801515:	8a 00                	mov    (%eax),%al
  801517:	3c 60                	cmp    $0x60,%al
  801519:	7e 19                	jle    801534 <strtol+0xe4>
  80151b:	8b 45 08             	mov    0x8(%ebp),%eax
  80151e:	8a 00                	mov    (%eax),%al
  801520:	3c 7a                	cmp    $0x7a,%al
  801522:	7f 10                	jg     801534 <strtol+0xe4>
			dig = *s - 'a' + 10;
  801524:	8b 45 08             	mov    0x8(%ebp),%eax
  801527:	8a 00                	mov    (%eax),%al
  801529:	0f be c0             	movsbl %al,%eax
  80152c:	83 e8 57             	sub    $0x57,%eax
  80152f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801532:	eb 20                	jmp    801554 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  801534:	8b 45 08             	mov    0x8(%ebp),%eax
  801537:	8a 00                	mov    (%eax),%al
  801539:	3c 40                	cmp    $0x40,%al
  80153b:	7e 39                	jle    801576 <strtol+0x126>
  80153d:	8b 45 08             	mov    0x8(%ebp),%eax
  801540:	8a 00                	mov    (%eax),%al
  801542:	3c 5a                	cmp    $0x5a,%al
  801544:	7f 30                	jg     801576 <strtol+0x126>
			dig = *s - 'A' + 10;
  801546:	8b 45 08             	mov    0x8(%ebp),%eax
  801549:	8a 00                	mov    (%eax),%al
  80154b:	0f be c0             	movsbl %al,%eax
  80154e:	83 e8 37             	sub    $0x37,%eax
  801551:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  801554:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801557:	3b 45 10             	cmp    0x10(%ebp),%eax
  80155a:	7d 19                	jge    801575 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  80155c:	ff 45 08             	incl   0x8(%ebp)
  80155f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801562:	0f af 45 10          	imul   0x10(%ebp),%eax
  801566:	89 c2                	mov    %eax,%edx
  801568:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80156b:	01 d0                	add    %edx,%eax
  80156d:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  801570:	e9 7b ff ff ff       	jmp    8014f0 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801575:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801576:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80157a:	74 08                	je     801584 <strtol+0x134>
		*endptr = (char *) s;
  80157c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80157f:	8b 55 08             	mov    0x8(%ebp),%edx
  801582:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  801584:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801588:	74 07                	je     801591 <strtol+0x141>
  80158a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80158d:	f7 d8                	neg    %eax
  80158f:	eb 03                	jmp    801594 <strtol+0x144>
  801591:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801594:	c9                   	leave  
  801595:	c3                   	ret    

00801596 <ltostr>:

void
ltostr(long value, char *str)
{
  801596:	55                   	push   %ebp
  801597:	89 e5                	mov    %esp,%ebp
  801599:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  80159c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  8015a3:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  8015aa:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8015ae:	79 13                	jns    8015c3 <ltostr+0x2d>
	{
		neg = 1;
  8015b0:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  8015b7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015ba:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  8015bd:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  8015c0:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  8015c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8015c6:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8015cb:	99                   	cltd   
  8015cc:	f7 f9                	idiv   %ecx
  8015ce:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  8015d1:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8015d4:	8d 50 01             	lea    0x1(%eax),%edx
  8015d7:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8015da:	89 c2                	mov    %eax,%edx
  8015dc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015df:	01 d0                	add    %edx,%eax
  8015e1:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8015e4:	83 c2 30             	add    $0x30,%edx
  8015e7:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  8015e9:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8015ec:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8015f1:	f7 e9                	imul   %ecx
  8015f3:	c1 fa 02             	sar    $0x2,%edx
  8015f6:	89 c8                	mov    %ecx,%eax
  8015f8:	c1 f8 1f             	sar    $0x1f,%eax
  8015fb:	29 c2                	sub    %eax,%edx
  8015fd:	89 d0                	mov    %edx,%eax
  8015ff:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  801602:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801606:	75 bb                	jne    8015c3 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801608:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  80160f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801612:	48                   	dec    %eax
  801613:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801616:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80161a:	74 3d                	je     801659 <ltostr+0xc3>
		start = 1 ;
  80161c:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  801623:	eb 34                	jmp    801659 <ltostr+0xc3>
	{
		char tmp = str[start] ;
  801625:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801628:	8b 45 0c             	mov    0xc(%ebp),%eax
  80162b:	01 d0                	add    %edx,%eax
  80162d:	8a 00                	mov    (%eax),%al
  80162f:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801632:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801635:	8b 45 0c             	mov    0xc(%ebp),%eax
  801638:	01 c2                	add    %eax,%edx
  80163a:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  80163d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801640:	01 c8                	add    %ecx,%eax
  801642:	8a 00                	mov    (%eax),%al
  801644:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801646:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801649:	8b 45 0c             	mov    0xc(%ebp),%eax
  80164c:	01 c2                	add    %eax,%edx
  80164e:	8a 45 eb             	mov    -0x15(%ebp),%al
  801651:	88 02                	mov    %al,(%edx)
		start++ ;
  801653:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801656:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801659:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80165c:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80165f:	7c c4                	jl     801625 <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801661:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801664:	8b 45 0c             	mov    0xc(%ebp),%eax
  801667:	01 d0                	add    %edx,%eax
  801669:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  80166c:	90                   	nop
  80166d:	c9                   	leave  
  80166e:	c3                   	ret    

0080166f <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  80166f:	55                   	push   %ebp
  801670:	89 e5                	mov    %esp,%ebp
  801672:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801675:	ff 75 08             	pushl  0x8(%ebp)
  801678:	e8 c4 f9 ff ff       	call   801041 <strlen>
  80167d:	83 c4 04             	add    $0x4,%esp
  801680:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  801683:	ff 75 0c             	pushl  0xc(%ebp)
  801686:	e8 b6 f9 ff ff       	call   801041 <strlen>
  80168b:	83 c4 04             	add    $0x4,%esp
  80168e:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  801691:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  801698:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80169f:	eb 17                	jmp    8016b8 <strcconcat+0x49>
		final[s] = str1[s] ;
  8016a1:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8016a4:	8b 45 10             	mov    0x10(%ebp),%eax
  8016a7:	01 c2                	add    %eax,%edx
  8016a9:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8016ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8016af:	01 c8                	add    %ecx,%eax
  8016b1:	8a 00                	mov    (%eax),%al
  8016b3:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  8016b5:	ff 45 fc             	incl   -0x4(%ebp)
  8016b8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8016bb:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8016be:	7c e1                	jl     8016a1 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  8016c0:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  8016c7:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8016ce:	eb 1f                	jmp    8016ef <strcconcat+0x80>
		final[s++] = str2[i] ;
  8016d0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8016d3:	8d 50 01             	lea    0x1(%eax),%edx
  8016d6:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8016d9:	89 c2                	mov    %eax,%edx
  8016db:	8b 45 10             	mov    0x10(%ebp),%eax
  8016de:	01 c2                	add    %eax,%edx
  8016e0:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8016e3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016e6:	01 c8                	add    %ecx,%eax
  8016e8:	8a 00                	mov    (%eax),%al
  8016ea:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  8016ec:	ff 45 f8             	incl   -0x8(%ebp)
  8016ef:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8016f2:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8016f5:	7c d9                	jl     8016d0 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  8016f7:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8016fa:	8b 45 10             	mov    0x10(%ebp),%eax
  8016fd:	01 d0                	add    %edx,%eax
  8016ff:	c6 00 00             	movb   $0x0,(%eax)
}
  801702:	90                   	nop
  801703:	c9                   	leave  
  801704:	c3                   	ret    

00801705 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801705:	55                   	push   %ebp
  801706:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801708:	8b 45 14             	mov    0x14(%ebp),%eax
  80170b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801711:	8b 45 14             	mov    0x14(%ebp),%eax
  801714:	8b 00                	mov    (%eax),%eax
  801716:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80171d:	8b 45 10             	mov    0x10(%ebp),%eax
  801720:	01 d0                	add    %edx,%eax
  801722:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801728:	eb 0c                	jmp    801736 <strsplit+0x31>
			*string++ = 0;
  80172a:	8b 45 08             	mov    0x8(%ebp),%eax
  80172d:	8d 50 01             	lea    0x1(%eax),%edx
  801730:	89 55 08             	mov    %edx,0x8(%ebp)
  801733:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801736:	8b 45 08             	mov    0x8(%ebp),%eax
  801739:	8a 00                	mov    (%eax),%al
  80173b:	84 c0                	test   %al,%al
  80173d:	74 18                	je     801757 <strsplit+0x52>
  80173f:	8b 45 08             	mov    0x8(%ebp),%eax
  801742:	8a 00                	mov    (%eax),%al
  801744:	0f be c0             	movsbl %al,%eax
  801747:	50                   	push   %eax
  801748:	ff 75 0c             	pushl  0xc(%ebp)
  80174b:	e8 83 fa ff ff       	call   8011d3 <strchr>
  801750:	83 c4 08             	add    $0x8,%esp
  801753:	85 c0                	test   %eax,%eax
  801755:	75 d3                	jne    80172a <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801757:	8b 45 08             	mov    0x8(%ebp),%eax
  80175a:	8a 00                	mov    (%eax),%al
  80175c:	84 c0                	test   %al,%al
  80175e:	74 5a                	je     8017ba <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801760:	8b 45 14             	mov    0x14(%ebp),%eax
  801763:	8b 00                	mov    (%eax),%eax
  801765:	83 f8 0f             	cmp    $0xf,%eax
  801768:	75 07                	jne    801771 <strsplit+0x6c>
		{
			return 0;
  80176a:	b8 00 00 00 00       	mov    $0x0,%eax
  80176f:	eb 66                	jmp    8017d7 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801771:	8b 45 14             	mov    0x14(%ebp),%eax
  801774:	8b 00                	mov    (%eax),%eax
  801776:	8d 48 01             	lea    0x1(%eax),%ecx
  801779:	8b 55 14             	mov    0x14(%ebp),%edx
  80177c:	89 0a                	mov    %ecx,(%edx)
  80177e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801785:	8b 45 10             	mov    0x10(%ebp),%eax
  801788:	01 c2                	add    %eax,%edx
  80178a:	8b 45 08             	mov    0x8(%ebp),%eax
  80178d:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  80178f:	eb 03                	jmp    801794 <strsplit+0x8f>
			string++;
  801791:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801794:	8b 45 08             	mov    0x8(%ebp),%eax
  801797:	8a 00                	mov    (%eax),%al
  801799:	84 c0                	test   %al,%al
  80179b:	74 8b                	je     801728 <strsplit+0x23>
  80179d:	8b 45 08             	mov    0x8(%ebp),%eax
  8017a0:	8a 00                	mov    (%eax),%al
  8017a2:	0f be c0             	movsbl %al,%eax
  8017a5:	50                   	push   %eax
  8017a6:	ff 75 0c             	pushl  0xc(%ebp)
  8017a9:	e8 25 fa ff ff       	call   8011d3 <strchr>
  8017ae:	83 c4 08             	add    $0x8,%esp
  8017b1:	85 c0                	test   %eax,%eax
  8017b3:	74 dc                	je     801791 <strsplit+0x8c>
			string++;
	}
  8017b5:	e9 6e ff ff ff       	jmp    801728 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  8017ba:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  8017bb:	8b 45 14             	mov    0x14(%ebp),%eax
  8017be:	8b 00                	mov    (%eax),%eax
  8017c0:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8017c7:	8b 45 10             	mov    0x10(%ebp),%eax
  8017ca:	01 d0                	add    %edx,%eax
  8017cc:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  8017d2:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8017d7:	c9                   	leave  
  8017d8:	c3                   	ret    

008017d9 <str2lower>:


char* str2lower(char *dst, const char *src)
{
  8017d9:	55                   	push   %ebp
  8017da:	89 e5                	mov    %esp,%ebp
  8017dc:	83 ec 10             	sub    $0x10,%esp
	char* ret = dst;
  8017df:	8b 45 08             	mov    0x8(%ebp),%eax
  8017e2:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (int i = 0; i < strlen(src); ++i)
  8017e5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8017ec:	eb 4a                	jmp    801838 <str2lower+0x5f>
	{
		dst[i] = src[i] ;
  8017ee:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8017f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8017f4:	01 c2                	add    %eax,%edx
  8017f6:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8017f9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017fc:	01 c8                	add    %ecx,%eax
  8017fe:	8a 00                	mov    (%eax),%al
  801800:	88 02                	mov    %al,(%edx)
		if (src[i] >= 'A' && src[i] <= 'Z')
  801802:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801805:	8b 45 0c             	mov    0xc(%ebp),%eax
  801808:	01 d0                	add    %edx,%eax
  80180a:	8a 00                	mov    (%eax),%al
  80180c:	3c 40                	cmp    $0x40,%al
  80180e:	7e 25                	jle    801835 <str2lower+0x5c>
  801810:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801813:	8b 45 0c             	mov    0xc(%ebp),%eax
  801816:	01 d0                	add    %edx,%eax
  801818:	8a 00                	mov    (%eax),%al
  80181a:	3c 5a                	cmp    $0x5a,%al
  80181c:	7f 17                	jg     801835 <str2lower+0x5c>
		{
			dst[i] += 32 ;
  80181e:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801821:	8b 45 08             	mov    0x8(%ebp),%eax
  801824:	01 d0                	add    %edx,%eax
  801826:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801829:	8b 55 08             	mov    0x8(%ebp),%edx
  80182c:	01 ca                	add    %ecx,%edx
  80182e:	8a 12                	mov    (%edx),%dl
  801830:	83 c2 20             	add    $0x20,%edx
  801833:	88 10                	mov    %dl,(%eax)


char* str2lower(char *dst, const char *src)
{
	char* ret = dst;
	for (int i = 0; i < strlen(src); ++i)
  801835:	ff 45 fc             	incl   -0x4(%ebp)
  801838:	ff 75 0c             	pushl  0xc(%ebp)
  80183b:	e8 01 f8 ff ff       	call   801041 <strlen>
  801840:	83 c4 04             	add    $0x4,%esp
  801843:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801846:	7f a6                	jg     8017ee <str2lower+0x15>
		if (src[i] >= 'A' && src[i] <= 'Z')
		{
			dst[i] += 32 ;
		}
	}
	return ret;
  801848:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  80184b:	c9                   	leave  
  80184c:	c3                   	ret    

0080184d <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  80184d:	55                   	push   %ebp
  80184e:	89 e5                	mov    %esp,%ebp
  801850:	57                   	push   %edi
  801851:	56                   	push   %esi
  801852:	53                   	push   %ebx
  801853:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801856:	8b 45 08             	mov    0x8(%ebp),%eax
  801859:	8b 55 0c             	mov    0xc(%ebp),%edx
  80185c:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80185f:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801862:	8b 7d 18             	mov    0x18(%ebp),%edi
  801865:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801868:	cd 30                	int    $0x30
  80186a:	89 45 f0             	mov    %eax,-0x10(%ebp)
				"b" (a3),
				"D" (a4),
				"S" (a5)
				: "cc", "memory");

	return ret;
  80186d:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801870:	83 c4 10             	add    $0x10,%esp
  801873:	5b                   	pop    %ebx
  801874:	5e                   	pop    %esi
  801875:	5f                   	pop    %edi
  801876:	5d                   	pop    %ebp
  801877:	c3                   	ret    

00801878 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName, int color)
{
  801878:	55                   	push   %ebp
  801879:	89 e5                	mov    %esp,%ebp
  80187b:	83 ec 04             	sub    $0x4,%esp
  80187e:	8b 45 10             	mov    0x10(%ebp),%eax
  801881:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, color, 0);
  801884:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801887:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80188b:	8b 45 08             	mov    0x8(%ebp),%eax
  80188e:	6a 00                	push   $0x0
  801890:	51                   	push   %ecx
  801891:	52                   	push   %edx
  801892:	ff 75 0c             	pushl  0xc(%ebp)
  801895:	50                   	push   %eax
  801896:	6a 00                	push   $0x0
  801898:	e8 b0 ff ff ff       	call   80184d <syscall>
  80189d:	83 c4 18             	add    $0x18,%esp
}
  8018a0:	90                   	nop
  8018a1:	c9                   	leave  
  8018a2:	c3                   	ret    

008018a3 <sys_cgetc>:

int
sys_cgetc(void)
{
  8018a3:	55                   	push   %ebp
  8018a4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  8018a6:	6a 00                	push   $0x0
  8018a8:	6a 00                	push   $0x0
  8018aa:	6a 00                	push   $0x0
  8018ac:	6a 00                	push   $0x0
  8018ae:	6a 00                	push   $0x0
  8018b0:	6a 02                	push   $0x2
  8018b2:	e8 96 ff ff ff       	call   80184d <syscall>
  8018b7:	83 c4 18             	add    $0x18,%esp
}
  8018ba:	c9                   	leave  
  8018bb:	c3                   	ret    

008018bc <sys_lock_cons>:

void sys_lock_cons(void)
{
  8018bc:	55                   	push   %ebp
  8018bd:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  8018bf:	6a 00                	push   $0x0
  8018c1:	6a 00                	push   $0x0
  8018c3:	6a 00                	push   $0x0
  8018c5:	6a 00                	push   $0x0
  8018c7:	6a 00                	push   $0x0
  8018c9:	6a 03                	push   $0x3
  8018cb:	e8 7d ff ff ff       	call   80184d <syscall>
  8018d0:	83 c4 18             	add    $0x18,%esp
}
  8018d3:	90                   	nop
  8018d4:	c9                   	leave  
  8018d5:	c3                   	ret    

008018d6 <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  8018d6:	55                   	push   %ebp
  8018d7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  8018d9:	6a 00                	push   $0x0
  8018db:	6a 00                	push   $0x0
  8018dd:	6a 00                	push   $0x0
  8018df:	6a 00                	push   $0x0
  8018e1:	6a 00                	push   $0x0
  8018e3:	6a 04                	push   $0x4
  8018e5:	e8 63 ff ff ff       	call   80184d <syscall>
  8018ea:	83 c4 18             	add    $0x18,%esp
}
  8018ed:	90                   	nop
  8018ee:	c9                   	leave  
  8018ef:	c3                   	ret    

008018f0 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  8018f0:	55                   	push   %ebp
  8018f1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  8018f3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8018f9:	6a 00                	push   $0x0
  8018fb:	6a 00                	push   $0x0
  8018fd:	6a 00                	push   $0x0
  8018ff:	52                   	push   %edx
  801900:	50                   	push   %eax
  801901:	6a 08                	push   $0x8
  801903:	e8 45 ff ff ff       	call   80184d <syscall>
  801908:	83 c4 18             	add    $0x18,%esp
}
  80190b:	c9                   	leave  
  80190c:	c3                   	ret    

0080190d <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  80190d:	55                   	push   %ebp
  80190e:	89 e5                	mov    %esp,%ebp
  801910:	56                   	push   %esi
  801911:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801912:	8b 75 18             	mov    0x18(%ebp),%esi
  801915:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801918:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80191b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80191e:	8b 45 08             	mov    0x8(%ebp),%eax
  801921:	56                   	push   %esi
  801922:	53                   	push   %ebx
  801923:	51                   	push   %ecx
  801924:	52                   	push   %edx
  801925:	50                   	push   %eax
  801926:	6a 09                	push   $0x9
  801928:	e8 20 ff ff ff       	call   80184d <syscall>
  80192d:	83 c4 18             	add    $0x18,%esp
}
  801930:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801933:	5b                   	pop    %ebx
  801934:	5e                   	pop    %esi
  801935:	5d                   	pop    %ebp
  801936:	c3                   	ret    

00801937 <__sys_unmap_frame>:

int __sys_unmap_frame(uint32 va)
{
  801937:	55                   	push   %ebp
  801938:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, va, 0, 0, 0, 0);
  80193a:	6a 00                	push   $0x0
  80193c:	6a 00                	push   $0x0
  80193e:	6a 00                	push   $0x0
  801940:	6a 00                	push   $0x0
  801942:	ff 75 08             	pushl  0x8(%ebp)
  801945:	6a 0a                	push   $0xa
  801947:	e8 01 ff ff ff       	call   80184d <syscall>
  80194c:	83 c4 18             	add    $0x18,%esp
}
  80194f:	c9                   	leave  
  801950:	c3                   	ret    

00801951 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801951:	55                   	push   %ebp
  801952:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801954:	6a 00                	push   $0x0
  801956:	6a 00                	push   $0x0
  801958:	6a 00                	push   $0x0
  80195a:	ff 75 0c             	pushl  0xc(%ebp)
  80195d:	ff 75 08             	pushl  0x8(%ebp)
  801960:	6a 0b                	push   $0xb
  801962:	e8 e6 fe ff ff       	call   80184d <syscall>
  801967:	83 c4 18             	add    $0x18,%esp
}
  80196a:	c9                   	leave  
  80196b:	c3                   	ret    

0080196c <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  80196c:	55                   	push   %ebp
  80196d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  80196f:	6a 00                	push   $0x0
  801971:	6a 00                	push   $0x0
  801973:	6a 00                	push   $0x0
  801975:	6a 00                	push   $0x0
  801977:	6a 00                	push   $0x0
  801979:	6a 0c                	push   $0xc
  80197b:	e8 cd fe ff ff       	call   80184d <syscall>
  801980:	83 c4 18             	add    $0x18,%esp
}
  801983:	c9                   	leave  
  801984:	c3                   	ret    

00801985 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801985:	55                   	push   %ebp
  801986:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801988:	6a 00                	push   $0x0
  80198a:	6a 00                	push   $0x0
  80198c:	6a 00                	push   $0x0
  80198e:	6a 00                	push   $0x0
  801990:	6a 00                	push   $0x0
  801992:	6a 0d                	push   $0xd
  801994:	e8 b4 fe ff ff       	call   80184d <syscall>
  801999:	83 c4 18             	add    $0x18,%esp
}
  80199c:	c9                   	leave  
  80199d:	c3                   	ret    

0080199e <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  80199e:	55                   	push   %ebp
  80199f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  8019a1:	6a 00                	push   $0x0
  8019a3:	6a 00                	push   $0x0
  8019a5:	6a 00                	push   $0x0
  8019a7:	6a 00                	push   $0x0
  8019a9:	6a 00                	push   $0x0
  8019ab:	6a 0e                	push   $0xe
  8019ad:	e8 9b fe ff ff       	call   80184d <syscall>
  8019b2:	83 c4 18             	add    $0x18,%esp
}
  8019b5:	c9                   	leave  
  8019b6:	c3                   	ret    

008019b7 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  8019b7:	55                   	push   %ebp
  8019b8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  8019ba:	6a 00                	push   $0x0
  8019bc:	6a 00                	push   $0x0
  8019be:	6a 00                	push   $0x0
  8019c0:	6a 00                	push   $0x0
  8019c2:	6a 00                	push   $0x0
  8019c4:	6a 0f                	push   $0xf
  8019c6:	e8 82 fe ff ff       	call   80184d <syscall>
  8019cb:	83 c4 18             	add    $0x18,%esp
}
  8019ce:	c9                   	leave  
  8019cf:	c3                   	ret    

008019d0 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  8019d0:	55                   	push   %ebp
  8019d1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  8019d3:	6a 00                	push   $0x0
  8019d5:	6a 00                	push   $0x0
  8019d7:	6a 00                	push   $0x0
  8019d9:	6a 00                	push   $0x0
  8019db:	ff 75 08             	pushl  0x8(%ebp)
  8019de:	6a 10                	push   $0x10
  8019e0:	e8 68 fe ff ff       	call   80184d <syscall>
  8019e5:	83 c4 18             	add    $0x18,%esp
}
  8019e8:	c9                   	leave  
  8019e9:	c3                   	ret    

008019ea <sys_scarce_memory>:

void sys_scarce_memory()
{
  8019ea:	55                   	push   %ebp
  8019eb:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  8019ed:	6a 00                	push   $0x0
  8019ef:	6a 00                	push   $0x0
  8019f1:	6a 00                	push   $0x0
  8019f3:	6a 00                	push   $0x0
  8019f5:	6a 00                	push   $0x0
  8019f7:	6a 11                	push   $0x11
  8019f9:	e8 4f fe ff ff       	call   80184d <syscall>
  8019fe:	83 c4 18             	add    $0x18,%esp
}
  801a01:	90                   	nop
  801a02:	c9                   	leave  
  801a03:	c3                   	ret    

00801a04 <sys_cputc>:

void
sys_cputc(const char c)
{
  801a04:	55                   	push   %ebp
  801a05:	89 e5                	mov    %esp,%ebp
  801a07:	83 ec 04             	sub    $0x4,%esp
  801a0a:	8b 45 08             	mov    0x8(%ebp),%eax
  801a0d:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801a10:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801a14:	6a 00                	push   $0x0
  801a16:	6a 00                	push   $0x0
  801a18:	6a 00                	push   $0x0
  801a1a:	6a 00                	push   $0x0
  801a1c:	50                   	push   %eax
  801a1d:	6a 01                	push   $0x1
  801a1f:	e8 29 fe ff ff       	call   80184d <syscall>
  801a24:	83 c4 18             	add    $0x18,%esp
}
  801a27:	90                   	nop
  801a28:	c9                   	leave  
  801a29:	c3                   	ret    

00801a2a <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801a2a:	55                   	push   %ebp
  801a2b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801a2d:	6a 00                	push   $0x0
  801a2f:	6a 00                	push   $0x0
  801a31:	6a 00                	push   $0x0
  801a33:	6a 00                	push   $0x0
  801a35:	6a 00                	push   $0x0
  801a37:	6a 14                	push   $0x14
  801a39:	e8 0f fe ff ff       	call   80184d <syscall>
  801a3e:	83 c4 18             	add    $0x18,%esp
}
  801a41:	90                   	nop
  801a42:	c9                   	leave  
  801a43:	c3                   	ret    

00801a44 <sys_create_shared_object>:

int sys_create_shared_object(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801a44:	55                   	push   %ebp
  801a45:	89 e5                	mov    %esp,%ebp
  801a47:	83 ec 04             	sub    $0x4,%esp
  801a4a:	8b 45 10             	mov    0x10(%ebp),%eax
  801a4d:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801a50:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801a53:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801a57:	8b 45 08             	mov    0x8(%ebp),%eax
  801a5a:	6a 00                	push   $0x0
  801a5c:	51                   	push   %ecx
  801a5d:	52                   	push   %edx
  801a5e:	ff 75 0c             	pushl  0xc(%ebp)
  801a61:	50                   	push   %eax
  801a62:	6a 15                	push   $0x15
  801a64:	e8 e4 fd ff ff       	call   80184d <syscall>
  801a69:	83 c4 18             	add    $0x18,%esp
}
  801a6c:	c9                   	leave  
  801a6d:	c3                   	ret    

00801a6e <sys_size_of_shared_object>:

//2017:
int sys_size_of_shared_object(int32 ownerID, char* shareName)
{
  801a6e:	55                   	push   %ebp
  801a6f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801a71:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a74:	8b 45 08             	mov    0x8(%ebp),%eax
  801a77:	6a 00                	push   $0x0
  801a79:	6a 00                	push   $0x0
  801a7b:	6a 00                	push   $0x0
  801a7d:	52                   	push   %edx
  801a7e:	50                   	push   %eax
  801a7f:	6a 16                	push   $0x16
  801a81:	e8 c7 fd ff ff       	call   80184d <syscall>
  801a86:	83 c4 18             	add    $0x18,%esp
}
  801a89:	c9                   	leave  
  801a8a:	c3                   	ret    

00801a8b <sys_get_shared_object>:
//==========

int sys_get_shared_object(int32 ownerID, char* shareName, void* virtual_address)
{
  801a8b:	55                   	push   %ebp
  801a8c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801a8e:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801a91:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a94:	8b 45 08             	mov    0x8(%ebp),%eax
  801a97:	6a 00                	push   $0x0
  801a99:	6a 00                	push   $0x0
  801a9b:	51                   	push   %ecx
  801a9c:	52                   	push   %edx
  801a9d:	50                   	push   %eax
  801a9e:	6a 17                	push   $0x17
  801aa0:	e8 a8 fd ff ff       	call   80184d <syscall>
  801aa5:	83 c4 18             	add    $0x18,%esp
}
  801aa8:	c9                   	leave  
  801aa9:	c3                   	ret    

00801aaa <sys_delete_shared_object>:

int sys_delete_shared_object(int32 sharedObjectID, void *startVA)
{
  801aaa:	55                   	push   %ebp
  801aab:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801aad:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ab0:	8b 45 08             	mov    0x8(%ebp),%eax
  801ab3:	6a 00                	push   $0x0
  801ab5:	6a 00                	push   $0x0
  801ab7:	6a 00                	push   $0x0
  801ab9:	52                   	push   %edx
  801aba:	50                   	push   %eax
  801abb:	6a 18                	push   $0x18
  801abd:	e8 8b fd ff ff       	call   80184d <syscall>
  801ac2:	83 c4 18             	add    $0x18,%esp
}
  801ac5:	c9                   	leave  
  801ac6:	c3                   	ret    

00801ac7 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801ac7:	55                   	push   %ebp
  801ac8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801aca:	8b 45 08             	mov    0x8(%ebp),%eax
  801acd:	6a 00                	push   $0x0
  801acf:	ff 75 14             	pushl  0x14(%ebp)
  801ad2:	ff 75 10             	pushl  0x10(%ebp)
  801ad5:	ff 75 0c             	pushl  0xc(%ebp)
  801ad8:	50                   	push   %eax
  801ad9:	6a 19                	push   $0x19
  801adb:	e8 6d fd ff ff       	call   80184d <syscall>
  801ae0:	83 c4 18             	add    $0x18,%esp
}
  801ae3:	c9                   	leave  
  801ae4:	c3                   	ret    

00801ae5 <sys_run_env>:

void sys_run_env(int32 envId)
{
  801ae5:	55                   	push   %ebp
  801ae6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801ae8:	8b 45 08             	mov    0x8(%ebp),%eax
  801aeb:	6a 00                	push   $0x0
  801aed:	6a 00                	push   $0x0
  801aef:	6a 00                	push   $0x0
  801af1:	6a 00                	push   $0x0
  801af3:	50                   	push   %eax
  801af4:	6a 1a                	push   $0x1a
  801af6:	e8 52 fd ff ff       	call   80184d <syscall>
  801afb:	83 c4 18             	add    $0x18,%esp
}
  801afe:	90                   	nop
  801aff:	c9                   	leave  
  801b00:	c3                   	ret    

00801b01 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801b01:	55                   	push   %ebp
  801b02:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801b04:	8b 45 08             	mov    0x8(%ebp),%eax
  801b07:	6a 00                	push   $0x0
  801b09:	6a 00                	push   $0x0
  801b0b:	6a 00                	push   $0x0
  801b0d:	6a 00                	push   $0x0
  801b0f:	50                   	push   %eax
  801b10:	6a 1b                	push   $0x1b
  801b12:	e8 36 fd ff ff       	call   80184d <syscall>
  801b17:	83 c4 18             	add    $0x18,%esp
}
  801b1a:	c9                   	leave  
  801b1b:	c3                   	ret    

00801b1c <sys_getenvid>:

int32 sys_getenvid(void)
{
  801b1c:	55                   	push   %ebp
  801b1d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801b1f:	6a 00                	push   $0x0
  801b21:	6a 00                	push   $0x0
  801b23:	6a 00                	push   $0x0
  801b25:	6a 00                	push   $0x0
  801b27:	6a 00                	push   $0x0
  801b29:	6a 05                	push   $0x5
  801b2b:	e8 1d fd ff ff       	call   80184d <syscall>
  801b30:	83 c4 18             	add    $0x18,%esp
}
  801b33:	c9                   	leave  
  801b34:	c3                   	ret    

00801b35 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801b35:	55                   	push   %ebp
  801b36:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801b38:	6a 00                	push   $0x0
  801b3a:	6a 00                	push   $0x0
  801b3c:	6a 00                	push   $0x0
  801b3e:	6a 00                	push   $0x0
  801b40:	6a 00                	push   $0x0
  801b42:	6a 06                	push   $0x6
  801b44:	e8 04 fd ff ff       	call   80184d <syscall>
  801b49:	83 c4 18             	add    $0x18,%esp
}
  801b4c:	c9                   	leave  
  801b4d:	c3                   	ret    

00801b4e <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801b4e:	55                   	push   %ebp
  801b4f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801b51:	6a 00                	push   $0x0
  801b53:	6a 00                	push   $0x0
  801b55:	6a 00                	push   $0x0
  801b57:	6a 00                	push   $0x0
  801b59:	6a 00                	push   $0x0
  801b5b:	6a 07                	push   $0x7
  801b5d:	e8 eb fc ff ff       	call   80184d <syscall>
  801b62:	83 c4 18             	add    $0x18,%esp
}
  801b65:	c9                   	leave  
  801b66:	c3                   	ret    

00801b67 <sys_exit_env>:


void sys_exit_env(void)
{
  801b67:	55                   	push   %ebp
  801b68:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801b6a:	6a 00                	push   $0x0
  801b6c:	6a 00                	push   $0x0
  801b6e:	6a 00                	push   $0x0
  801b70:	6a 00                	push   $0x0
  801b72:	6a 00                	push   $0x0
  801b74:	6a 1c                	push   $0x1c
  801b76:	e8 d2 fc ff ff       	call   80184d <syscall>
  801b7b:	83 c4 18             	add    $0x18,%esp
}
  801b7e:	90                   	nop
  801b7f:	c9                   	leave  
  801b80:	c3                   	ret    

00801b81 <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  801b81:	55                   	push   %ebp
  801b82:	89 e5                	mov    %esp,%ebp
  801b84:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801b87:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801b8a:	8d 50 04             	lea    0x4(%eax),%edx
  801b8d:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801b90:	6a 00                	push   $0x0
  801b92:	6a 00                	push   $0x0
  801b94:	6a 00                	push   $0x0
  801b96:	52                   	push   %edx
  801b97:	50                   	push   %eax
  801b98:	6a 1d                	push   $0x1d
  801b9a:	e8 ae fc ff ff       	call   80184d <syscall>
  801b9f:	83 c4 18             	add    $0x18,%esp
	return result;
  801ba2:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801ba5:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801ba8:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801bab:	89 01                	mov    %eax,(%ecx)
  801bad:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801bb0:	8b 45 08             	mov    0x8(%ebp),%eax
  801bb3:	c9                   	leave  
  801bb4:	c2 04 00             	ret    $0x4

00801bb7 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801bb7:	55                   	push   %ebp
  801bb8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801bba:	6a 00                	push   $0x0
  801bbc:	6a 00                	push   $0x0
  801bbe:	ff 75 10             	pushl  0x10(%ebp)
  801bc1:	ff 75 0c             	pushl  0xc(%ebp)
  801bc4:	ff 75 08             	pushl  0x8(%ebp)
  801bc7:	6a 13                	push   $0x13
  801bc9:	e8 7f fc ff ff       	call   80184d <syscall>
  801bce:	83 c4 18             	add    $0x18,%esp
	return ;
  801bd1:	90                   	nop
}
  801bd2:	c9                   	leave  
  801bd3:	c3                   	ret    

00801bd4 <sys_rcr2>:
uint32 sys_rcr2()
{
  801bd4:	55                   	push   %ebp
  801bd5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801bd7:	6a 00                	push   $0x0
  801bd9:	6a 00                	push   $0x0
  801bdb:	6a 00                	push   $0x0
  801bdd:	6a 00                	push   $0x0
  801bdf:	6a 00                	push   $0x0
  801be1:	6a 1e                	push   $0x1e
  801be3:	e8 65 fc ff ff       	call   80184d <syscall>
  801be8:	83 c4 18             	add    $0x18,%esp
}
  801beb:	c9                   	leave  
  801bec:	c3                   	ret    

00801bed <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  801bed:	55                   	push   %ebp
  801bee:	89 e5                	mov    %esp,%ebp
  801bf0:	83 ec 04             	sub    $0x4,%esp
  801bf3:	8b 45 08             	mov    0x8(%ebp),%eax
  801bf6:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801bf9:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801bfd:	6a 00                	push   $0x0
  801bff:	6a 00                	push   $0x0
  801c01:	6a 00                	push   $0x0
  801c03:	6a 00                	push   $0x0
  801c05:	50                   	push   %eax
  801c06:	6a 1f                	push   $0x1f
  801c08:	e8 40 fc ff ff       	call   80184d <syscall>
  801c0d:	83 c4 18             	add    $0x18,%esp
	return ;
  801c10:	90                   	nop
}
  801c11:	c9                   	leave  
  801c12:	c3                   	ret    

00801c13 <rsttst>:
void rsttst()
{
  801c13:	55                   	push   %ebp
  801c14:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801c16:	6a 00                	push   $0x0
  801c18:	6a 00                	push   $0x0
  801c1a:	6a 00                	push   $0x0
  801c1c:	6a 00                	push   $0x0
  801c1e:	6a 00                	push   $0x0
  801c20:	6a 21                	push   $0x21
  801c22:	e8 26 fc ff ff       	call   80184d <syscall>
  801c27:	83 c4 18             	add    $0x18,%esp
	return ;
  801c2a:	90                   	nop
}
  801c2b:	c9                   	leave  
  801c2c:	c3                   	ret    

00801c2d <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801c2d:	55                   	push   %ebp
  801c2e:	89 e5                	mov    %esp,%ebp
  801c30:	83 ec 04             	sub    $0x4,%esp
  801c33:	8b 45 14             	mov    0x14(%ebp),%eax
  801c36:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801c39:	8b 55 18             	mov    0x18(%ebp),%edx
  801c3c:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801c40:	52                   	push   %edx
  801c41:	50                   	push   %eax
  801c42:	ff 75 10             	pushl  0x10(%ebp)
  801c45:	ff 75 0c             	pushl  0xc(%ebp)
  801c48:	ff 75 08             	pushl  0x8(%ebp)
  801c4b:	6a 20                	push   $0x20
  801c4d:	e8 fb fb ff ff       	call   80184d <syscall>
  801c52:	83 c4 18             	add    $0x18,%esp
	return ;
  801c55:	90                   	nop
}
  801c56:	c9                   	leave  
  801c57:	c3                   	ret    

00801c58 <chktst>:
void chktst(uint32 n)
{
  801c58:	55                   	push   %ebp
  801c59:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801c5b:	6a 00                	push   $0x0
  801c5d:	6a 00                	push   $0x0
  801c5f:	6a 00                	push   $0x0
  801c61:	6a 00                	push   $0x0
  801c63:	ff 75 08             	pushl  0x8(%ebp)
  801c66:	6a 22                	push   $0x22
  801c68:	e8 e0 fb ff ff       	call   80184d <syscall>
  801c6d:	83 c4 18             	add    $0x18,%esp
	return ;
  801c70:	90                   	nop
}
  801c71:	c9                   	leave  
  801c72:	c3                   	ret    

00801c73 <inctst>:

void inctst()
{
  801c73:	55                   	push   %ebp
  801c74:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801c76:	6a 00                	push   $0x0
  801c78:	6a 00                	push   $0x0
  801c7a:	6a 00                	push   $0x0
  801c7c:	6a 00                	push   $0x0
  801c7e:	6a 00                	push   $0x0
  801c80:	6a 23                	push   $0x23
  801c82:	e8 c6 fb ff ff       	call   80184d <syscall>
  801c87:	83 c4 18             	add    $0x18,%esp
	return ;
  801c8a:	90                   	nop
}
  801c8b:	c9                   	leave  
  801c8c:	c3                   	ret    

00801c8d <gettst>:
uint32 gettst()
{
  801c8d:	55                   	push   %ebp
  801c8e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801c90:	6a 00                	push   $0x0
  801c92:	6a 00                	push   $0x0
  801c94:	6a 00                	push   $0x0
  801c96:	6a 00                	push   $0x0
  801c98:	6a 00                	push   $0x0
  801c9a:	6a 24                	push   $0x24
  801c9c:	e8 ac fb ff ff       	call   80184d <syscall>
  801ca1:	83 c4 18             	add    $0x18,%esp
}
  801ca4:	c9                   	leave  
  801ca5:	c3                   	ret    

00801ca6 <sys_get_uheap_strategy>:

/*2025*/
uint32 sys_get_uheap_strategy()
{
  801ca6:	55                   	push   %ebp
  801ca7:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801ca9:	6a 00                	push   $0x0
  801cab:	6a 00                	push   $0x0
  801cad:	6a 00                	push   $0x0
  801caf:	6a 00                	push   $0x0
  801cb1:	6a 00                	push   $0x0
  801cb3:	6a 25                	push   $0x25
  801cb5:	e8 93 fb ff ff       	call   80184d <syscall>
  801cba:	83 c4 18             	add    $0x18,%esp
  801cbd:	a3 60 b0 81 00       	mov    %eax,0x81b060
	return uheapPlaceStrategy ;
  801cc2:	a1 60 b0 81 00       	mov    0x81b060,%eax
}
  801cc7:	c9                   	leave  
  801cc8:	c3                   	ret    

00801cc9 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801cc9:	55                   	push   %ebp
  801cca:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = heapStrategy;
  801ccc:	8b 45 08             	mov    0x8(%ebp),%eax
  801ccf:	a3 60 b0 81 00       	mov    %eax,0x81b060
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801cd4:	6a 00                	push   $0x0
  801cd6:	6a 00                	push   $0x0
  801cd8:	6a 00                	push   $0x0
  801cda:	6a 00                	push   $0x0
  801cdc:	ff 75 08             	pushl  0x8(%ebp)
  801cdf:	6a 26                	push   $0x26
  801ce1:	e8 67 fb ff ff       	call   80184d <syscall>
  801ce6:	83 c4 18             	add    $0x18,%esp
	return ;
  801ce9:	90                   	nop
}
  801cea:	c9                   	leave  
  801ceb:	c3                   	ret    

00801cec <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801cec:	55                   	push   %ebp
  801ced:	89 e5                	mov    %esp,%ebp
  801cef:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801cf0:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801cf3:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801cf6:	8b 55 0c             	mov    0xc(%ebp),%edx
  801cf9:	8b 45 08             	mov    0x8(%ebp),%eax
  801cfc:	6a 00                	push   $0x0
  801cfe:	53                   	push   %ebx
  801cff:	51                   	push   %ecx
  801d00:	52                   	push   %edx
  801d01:	50                   	push   %eax
  801d02:	6a 27                	push   $0x27
  801d04:	e8 44 fb ff ff       	call   80184d <syscall>
  801d09:	83 c4 18             	add    $0x18,%esp
}
  801d0c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801d0f:	c9                   	leave  
  801d10:	c3                   	ret    

00801d11 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801d11:	55                   	push   %ebp
  801d12:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801d14:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d17:	8b 45 08             	mov    0x8(%ebp),%eax
  801d1a:	6a 00                	push   $0x0
  801d1c:	6a 00                	push   $0x0
  801d1e:	6a 00                	push   $0x0
  801d20:	52                   	push   %edx
  801d21:	50                   	push   %eax
  801d22:	6a 28                	push   $0x28
  801d24:	e8 24 fb ff ff       	call   80184d <syscall>
  801d29:	83 c4 18             	add    $0x18,%esp
}
  801d2c:	c9                   	leave  
  801d2d:	c3                   	ret    

00801d2e <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  801d2e:	55                   	push   %ebp
  801d2f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  801d31:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801d34:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d37:	8b 45 08             	mov    0x8(%ebp),%eax
  801d3a:	6a 00                	push   $0x0
  801d3c:	51                   	push   %ecx
  801d3d:	ff 75 10             	pushl  0x10(%ebp)
  801d40:	52                   	push   %edx
  801d41:	50                   	push   %eax
  801d42:	6a 29                	push   $0x29
  801d44:	e8 04 fb ff ff       	call   80184d <syscall>
  801d49:	83 c4 18             	add    $0x18,%esp
}
  801d4c:	c9                   	leave  
  801d4d:	c3                   	ret    

00801d4e <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801d4e:	55                   	push   %ebp
  801d4f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801d51:	6a 00                	push   $0x0
  801d53:	6a 00                	push   $0x0
  801d55:	ff 75 10             	pushl  0x10(%ebp)
  801d58:	ff 75 0c             	pushl  0xc(%ebp)
  801d5b:	ff 75 08             	pushl  0x8(%ebp)
  801d5e:	6a 12                	push   $0x12
  801d60:	e8 e8 fa ff ff       	call   80184d <syscall>
  801d65:	83 c4 18             	add    $0x18,%esp
	return ;
  801d68:	90                   	nop
}
  801d69:	c9                   	leave  
  801d6a:	c3                   	ret    

00801d6b <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  801d6b:	55                   	push   %ebp
  801d6c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  801d6e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d71:	8b 45 08             	mov    0x8(%ebp),%eax
  801d74:	6a 00                	push   $0x0
  801d76:	6a 00                	push   $0x0
  801d78:	6a 00                	push   $0x0
  801d7a:	52                   	push   %edx
  801d7b:	50                   	push   %eax
  801d7c:	6a 2a                	push   $0x2a
  801d7e:	e8 ca fa ff ff       	call   80184d <syscall>
  801d83:	83 c4 18             	add    $0x18,%esp
	return;
  801d86:	90                   	nop
}
  801d87:	c9                   	leave  
  801d88:	c3                   	ret    

00801d89 <sys_get_optimal_num_faults>:
/*2025*/
int sys_get_optimal_num_faults()
{
  801d89:	55                   	push   %ebp
  801d8a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_optimal_num_faults, 0, 0, 0, 0, 0);
  801d8c:	6a 00                	push   $0x0
  801d8e:	6a 00                	push   $0x0
  801d90:	6a 00                	push   $0x0
  801d92:	6a 00                	push   $0x0
  801d94:	6a 00                	push   $0x0
  801d96:	6a 2b                	push   $0x2b
  801d98:	e8 b0 fa ff ff       	call   80184d <syscall>
  801d9d:	83 c4 18             	add    $0x18,%esp
}
  801da0:	c9                   	leave  
  801da1:	c3                   	ret    

00801da2 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801da2:	55                   	push   %ebp
  801da3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801da5:	6a 00                	push   $0x0
  801da7:	6a 00                	push   $0x0
  801da9:	6a 00                	push   $0x0
  801dab:	ff 75 0c             	pushl  0xc(%ebp)
  801dae:	ff 75 08             	pushl  0x8(%ebp)
  801db1:	6a 2d                	push   $0x2d
  801db3:	e8 95 fa ff ff       	call   80184d <syscall>
  801db8:	83 c4 18             	add    $0x18,%esp
	return;
  801dbb:	90                   	nop
}
  801dbc:	c9                   	leave  
  801dbd:	c3                   	ret    

00801dbe <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801dbe:	55                   	push   %ebp
  801dbf:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801dc1:	6a 00                	push   $0x0
  801dc3:	6a 00                	push   $0x0
  801dc5:	6a 00                	push   $0x0
  801dc7:	ff 75 0c             	pushl  0xc(%ebp)
  801dca:	ff 75 08             	pushl  0x8(%ebp)
  801dcd:	6a 2c                	push   $0x2c
  801dcf:	e8 79 fa ff ff       	call   80184d <syscall>
  801dd4:	83 c4 18             	add    $0x18,%esp
	return ;
  801dd7:	90                   	nop
}
  801dd8:	c9                   	leave  
  801dd9:	c3                   	ret    

00801dda <sys_env_set_priority>:


void sys_env_set_priority(int32 envID, int priority)
{
  801dda:	55                   	push   %ebp
  801ddb:	89 e5                	mov    %esp,%ebp
  801ddd:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.IM#4] CPU SCHEDULING - #1 System Calls - Add suitable code here
	//Your code is here
	//Comment the following line
	panic("sys_env_set_priority() is not implemented yet...!!");
  801de0:	83 ec 04             	sub    $0x4,%esp
  801de3:	68 7c 2a 80 00       	push   $0x802a7c
  801de8:	68 25 01 00 00       	push   $0x125
  801ded:	68 af 2a 80 00       	push   $0x802aaf
  801df2:	e8 9b e6 ff ff       	call   800492 <_panic>

00801df7 <env_sleep>:
#include <inc/lib.h>
#include <inc/timerreg.h>

void
env_sleep(uint32 approxMilliSeconds)
{
  801df7:	55                   	push   %ebp
  801df8:	89 e5                	mov    %esp,%ebp
  801dfa:	83 ec 30             	sub    $0x30,%esp
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
  801dfd:	8b 55 08             	mov    0x8(%ebp),%edx
  801e00:	89 d0                	mov    %edx,%eax
  801e02:	c1 e0 02             	shl    $0x2,%eax
  801e05:	01 d0                	add    %edx,%eax
  801e07:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801e0e:	01 d0                	add    %edx,%eax
  801e10:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801e17:	01 d0                	add    %edx,%eax
  801e19:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801e20:	01 d0                	add    %edx,%eax
  801e22:	c1 e0 04             	shl    $0x4,%eax
  801e25:	89 45 f8             	mov    %eax,-0x8(%ebp)
	uint32 cycles_counter =0;
  801e28:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)

static inline __attribute__((always_inline)) struct uint64 get_virtual_time_user()
{
	struct uint64 result;

	__asm __volatile("rdtsc\n"
  801e2f:	0f 31                	rdtsc  
  801e31:	89 45 e8             	mov    %eax,-0x18(%ebp)
  801e34:	89 55 ec             	mov    %edx,-0x14(%ebp)
	: "=a" (result.low), "=d" (result.hi)
	);

	return result;
  801e37:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801e3a:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801e3d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801e40:	89 55 f4             	mov    %edx,-0xc(%ebp)

	/*2024*/ //USE A USER-SIDE VERSION OF THIS FUNCTION TO AVOID SLOW-DOWN THE PERFORMANCE DUE SYS_CALL (el7 :))
	//struct uint64 baseTime = sys_get_virtual_time() ;
	struct uint64 baseTime = get_virtual_time_user() ;
	while(cycles_counter<time_in_cycles)
  801e43:	eb 46                	jmp    801e8b <env_sleep+0x94>

static inline __attribute__((always_inline)) struct uint64 get_virtual_time_user()
{
	struct uint64 result;

	__asm __volatile("rdtsc\n"
  801e45:	0f 31                	rdtsc  
  801e47:	89 45 d0             	mov    %eax,-0x30(%ebp)
  801e4a:	89 55 d4             	mov    %edx,-0x2c(%ebp)
	: "=a" (result.low), "=d" (result.hi)
	);

	return result;
  801e4d:	8b 45 d0             	mov    -0x30(%ebp),%eax
  801e50:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  801e53:	89 45 e0             	mov    %eax,-0x20(%ebp)
  801e56:	89 55 e4             	mov    %edx,-0x1c(%ebp)

		// update the cycles_count
		#define M32 0xffffffff
		// subtract basetime from current time
		struct uint64 res;
		res.low = (currentTime.low - baseTime.low) & M32;
  801e59:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801e5c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e5f:	29 c2                	sub    %eax,%edx
  801e61:	89 d0                	mov    %edx,%eax
  801e63:	89 45 d8             	mov    %eax,-0x28(%ebp)
		res.hi = (currentTime.hi - baseTime.hi - (res.low > currentTime.low)) & M32;
  801e66:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801e69:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e6c:	89 d1                	mov    %edx,%ecx
  801e6e:	29 c1                	sub    %eax,%ecx
  801e70:	8b 55 d8             	mov    -0x28(%ebp),%edx
  801e73:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801e76:	39 c2                	cmp    %eax,%edx
  801e78:	0f 97 c0             	seta   %al
  801e7b:	0f b6 c0             	movzbl %al,%eax
  801e7e:	29 c1                	sub    %eax,%ecx
  801e80:	89 c8                	mov    %ecx,%eax
  801e82:	89 45 dc             	mov    %eax,-0x24(%ebp)

		//update cycles_count with result
		cycles_counter = res.low;
  801e85:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801e88:	89 45 fc             	mov    %eax,-0x4(%ebp)
	uint32 cycles_counter =0;

	/*2024*/ //USE A USER-SIDE VERSION OF THIS FUNCTION TO AVOID SLOW-DOWN THE PERFORMANCE DUE SYS_CALL (el7 :))
	//struct uint64 baseTime = sys_get_virtual_time() ;
	struct uint64 baseTime = get_virtual_time_user() ;
	while(cycles_counter<time_in_cycles)
  801e8b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801e8e:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801e91:	72 b2                	jb     801e45 <env_sleep+0x4e>
//				,cycles_counter
//				);
	}
	//cprintf("%s [%d] wake up now!\n", myEnv->prog_name, myEnv->env_id);

}
  801e93:	90                   	nop
  801e94:	c9                   	leave  
  801e95:	c3                   	ret    

00801e96 <busy_wait>:

//2017
uint32 busy_wait(uint32 loopMax)
{
  801e96:	55                   	push   %ebp
  801e97:	89 e5                	mov    %esp,%ebp
  801e99:	83 ec 10             	sub    $0x10,%esp
	uint32 i = 0 ;
  801e9c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	while (i < loopMax) i++;
  801ea3:	eb 03                	jmp    801ea8 <busy_wait+0x12>
  801ea5:	ff 45 fc             	incl   -0x4(%ebp)
  801ea8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801eab:	3b 45 08             	cmp    0x8(%ebp),%eax
  801eae:	72 f5                	jb     801ea5 <busy_wait+0xf>
	return i;
  801eb0:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801eb3:	c9                   	leave  
  801eb4:	c3                   	ret    

00801eb5 <cputchar>:
#include <inc/lib.h>


void
cputchar(int ch)
{
  801eb5:	55                   	push   %ebp
  801eb6:	89 e5                	mov    %esp,%ebp
  801eb8:	83 ec 18             	sub    $0x18,%esp
	char c = ch;
  801ebb:	8b 45 08             	mov    0x8(%ebp),%eax
  801ebe:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	//sys_cputs(&c, 1);

	sys_cputc(c);
  801ec1:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  801ec5:	83 ec 0c             	sub    $0xc,%esp
  801ec8:	50                   	push   %eax
  801ec9:	e8 36 fb ff ff       	call   801a04 <sys_cputc>
  801ece:	83 c4 10             	add    $0x10,%esp
}
  801ed1:	90                   	nop
  801ed2:	c9                   	leave  
  801ed3:	c3                   	ret    

00801ed4 <getchar>:


int
getchar(void)
{
  801ed4:	55                   	push   %ebp
  801ed5:	89 e5                	mov    %esp,%ebp
  801ed7:	83 ec 18             	sub    $0x18,%esp
	int c =sys_cgetc();
  801eda:	e8 c4 f9 ff ff       	call   8018a3 <sys_cgetc>
  801edf:	89 45 f4             	mov    %eax,-0xc(%ebp)
	return c;
  801ee2:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  801ee5:	c9                   	leave  
  801ee6:	c3                   	ret    

00801ee7 <iscons>:

int iscons(int fdnum)
{
  801ee7:	55                   	push   %ebp
  801ee8:	89 e5                	mov    %esp,%ebp
	// used by readline
	return 1;
  801eea:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801eef:	5d                   	pop    %ebp
  801ef0:	c3                   	ret    
  801ef1:	66 90                	xchg   %ax,%ax
  801ef3:	90                   	nop

00801ef4 <__udivdi3>:
  801ef4:	55                   	push   %ebp
  801ef5:	57                   	push   %edi
  801ef6:	56                   	push   %esi
  801ef7:	53                   	push   %ebx
  801ef8:	83 ec 1c             	sub    $0x1c,%esp
  801efb:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  801eff:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  801f03:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801f07:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801f0b:	89 ca                	mov    %ecx,%edx
  801f0d:	89 f8                	mov    %edi,%eax
  801f0f:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  801f13:	85 f6                	test   %esi,%esi
  801f15:	75 2d                	jne    801f44 <__udivdi3+0x50>
  801f17:	39 cf                	cmp    %ecx,%edi
  801f19:	77 65                	ja     801f80 <__udivdi3+0x8c>
  801f1b:	89 fd                	mov    %edi,%ebp
  801f1d:	85 ff                	test   %edi,%edi
  801f1f:	75 0b                	jne    801f2c <__udivdi3+0x38>
  801f21:	b8 01 00 00 00       	mov    $0x1,%eax
  801f26:	31 d2                	xor    %edx,%edx
  801f28:	f7 f7                	div    %edi
  801f2a:	89 c5                	mov    %eax,%ebp
  801f2c:	31 d2                	xor    %edx,%edx
  801f2e:	89 c8                	mov    %ecx,%eax
  801f30:	f7 f5                	div    %ebp
  801f32:	89 c1                	mov    %eax,%ecx
  801f34:	89 d8                	mov    %ebx,%eax
  801f36:	f7 f5                	div    %ebp
  801f38:	89 cf                	mov    %ecx,%edi
  801f3a:	89 fa                	mov    %edi,%edx
  801f3c:	83 c4 1c             	add    $0x1c,%esp
  801f3f:	5b                   	pop    %ebx
  801f40:	5e                   	pop    %esi
  801f41:	5f                   	pop    %edi
  801f42:	5d                   	pop    %ebp
  801f43:	c3                   	ret    
  801f44:	39 ce                	cmp    %ecx,%esi
  801f46:	77 28                	ja     801f70 <__udivdi3+0x7c>
  801f48:	0f bd fe             	bsr    %esi,%edi
  801f4b:	83 f7 1f             	xor    $0x1f,%edi
  801f4e:	75 40                	jne    801f90 <__udivdi3+0x9c>
  801f50:	39 ce                	cmp    %ecx,%esi
  801f52:	72 0a                	jb     801f5e <__udivdi3+0x6a>
  801f54:	3b 44 24 08          	cmp    0x8(%esp),%eax
  801f58:	0f 87 9e 00 00 00    	ja     801ffc <__udivdi3+0x108>
  801f5e:	b8 01 00 00 00       	mov    $0x1,%eax
  801f63:	89 fa                	mov    %edi,%edx
  801f65:	83 c4 1c             	add    $0x1c,%esp
  801f68:	5b                   	pop    %ebx
  801f69:	5e                   	pop    %esi
  801f6a:	5f                   	pop    %edi
  801f6b:	5d                   	pop    %ebp
  801f6c:	c3                   	ret    
  801f6d:	8d 76 00             	lea    0x0(%esi),%esi
  801f70:	31 ff                	xor    %edi,%edi
  801f72:	31 c0                	xor    %eax,%eax
  801f74:	89 fa                	mov    %edi,%edx
  801f76:	83 c4 1c             	add    $0x1c,%esp
  801f79:	5b                   	pop    %ebx
  801f7a:	5e                   	pop    %esi
  801f7b:	5f                   	pop    %edi
  801f7c:	5d                   	pop    %ebp
  801f7d:	c3                   	ret    
  801f7e:	66 90                	xchg   %ax,%ax
  801f80:	89 d8                	mov    %ebx,%eax
  801f82:	f7 f7                	div    %edi
  801f84:	31 ff                	xor    %edi,%edi
  801f86:	89 fa                	mov    %edi,%edx
  801f88:	83 c4 1c             	add    $0x1c,%esp
  801f8b:	5b                   	pop    %ebx
  801f8c:	5e                   	pop    %esi
  801f8d:	5f                   	pop    %edi
  801f8e:	5d                   	pop    %ebp
  801f8f:	c3                   	ret    
  801f90:	bd 20 00 00 00       	mov    $0x20,%ebp
  801f95:	89 eb                	mov    %ebp,%ebx
  801f97:	29 fb                	sub    %edi,%ebx
  801f99:	89 f9                	mov    %edi,%ecx
  801f9b:	d3 e6                	shl    %cl,%esi
  801f9d:	89 c5                	mov    %eax,%ebp
  801f9f:	88 d9                	mov    %bl,%cl
  801fa1:	d3 ed                	shr    %cl,%ebp
  801fa3:	89 e9                	mov    %ebp,%ecx
  801fa5:	09 f1                	or     %esi,%ecx
  801fa7:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  801fab:	89 f9                	mov    %edi,%ecx
  801fad:	d3 e0                	shl    %cl,%eax
  801faf:	89 c5                	mov    %eax,%ebp
  801fb1:	89 d6                	mov    %edx,%esi
  801fb3:	88 d9                	mov    %bl,%cl
  801fb5:	d3 ee                	shr    %cl,%esi
  801fb7:	89 f9                	mov    %edi,%ecx
  801fb9:	d3 e2                	shl    %cl,%edx
  801fbb:	8b 44 24 08          	mov    0x8(%esp),%eax
  801fbf:	88 d9                	mov    %bl,%cl
  801fc1:	d3 e8                	shr    %cl,%eax
  801fc3:	09 c2                	or     %eax,%edx
  801fc5:	89 d0                	mov    %edx,%eax
  801fc7:	89 f2                	mov    %esi,%edx
  801fc9:	f7 74 24 0c          	divl   0xc(%esp)
  801fcd:	89 d6                	mov    %edx,%esi
  801fcf:	89 c3                	mov    %eax,%ebx
  801fd1:	f7 e5                	mul    %ebp
  801fd3:	39 d6                	cmp    %edx,%esi
  801fd5:	72 19                	jb     801ff0 <__udivdi3+0xfc>
  801fd7:	74 0b                	je     801fe4 <__udivdi3+0xf0>
  801fd9:	89 d8                	mov    %ebx,%eax
  801fdb:	31 ff                	xor    %edi,%edi
  801fdd:	e9 58 ff ff ff       	jmp    801f3a <__udivdi3+0x46>
  801fe2:	66 90                	xchg   %ax,%ax
  801fe4:	8b 54 24 08          	mov    0x8(%esp),%edx
  801fe8:	89 f9                	mov    %edi,%ecx
  801fea:	d3 e2                	shl    %cl,%edx
  801fec:	39 c2                	cmp    %eax,%edx
  801fee:	73 e9                	jae    801fd9 <__udivdi3+0xe5>
  801ff0:	8d 43 ff             	lea    -0x1(%ebx),%eax
  801ff3:	31 ff                	xor    %edi,%edi
  801ff5:	e9 40 ff ff ff       	jmp    801f3a <__udivdi3+0x46>
  801ffa:	66 90                	xchg   %ax,%ax
  801ffc:	31 c0                	xor    %eax,%eax
  801ffe:	e9 37 ff ff ff       	jmp    801f3a <__udivdi3+0x46>
  802003:	90                   	nop

00802004 <__umoddi3>:
  802004:	55                   	push   %ebp
  802005:	57                   	push   %edi
  802006:	56                   	push   %esi
  802007:	53                   	push   %ebx
  802008:	83 ec 1c             	sub    $0x1c,%esp
  80200b:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  80200f:	8b 74 24 34          	mov    0x34(%esp),%esi
  802013:	8b 7c 24 38          	mov    0x38(%esp),%edi
  802017:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80201b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80201f:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802023:	89 f3                	mov    %esi,%ebx
  802025:	89 fa                	mov    %edi,%edx
  802027:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80202b:	89 34 24             	mov    %esi,(%esp)
  80202e:	85 c0                	test   %eax,%eax
  802030:	75 1a                	jne    80204c <__umoddi3+0x48>
  802032:	39 f7                	cmp    %esi,%edi
  802034:	0f 86 a2 00 00 00    	jbe    8020dc <__umoddi3+0xd8>
  80203a:	89 c8                	mov    %ecx,%eax
  80203c:	89 f2                	mov    %esi,%edx
  80203e:	f7 f7                	div    %edi
  802040:	89 d0                	mov    %edx,%eax
  802042:	31 d2                	xor    %edx,%edx
  802044:	83 c4 1c             	add    $0x1c,%esp
  802047:	5b                   	pop    %ebx
  802048:	5e                   	pop    %esi
  802049:	5f                   	pop    %edi
  80204a:	5d                   	pop    %ebp
  80204b:	c3                   	ret    
  80204c:	39 f0                	cmp    %esi,%eax
  80204e:	0f 87 ac 00 00 00    	ja     802100 <__umoddi3+0xfc>
  802054:	0f bd e8             	bsr    %eax,%ebp
  802057:	83 f5 1f             	xor    $0x1f,%ebp
  80205a:	0f 84 ac 00 00 00    	je     80210c <__umoddi3+0x108>
  802060:	bf 20 00 00 00       	mov    $0x20,%edi
  802065:	29 ef                	sub    %ebp,%edi
  802067:	89 fe                	mov    %edi,%esi
  802069:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80206d:	89 e9                	mov    %ebp,%ecx
  80206f:	d3 e0                	shl    %cl,%eax
  802071:	89 d7                	mov    %edx,%edi
  802073:	89 f1                	mov    %esi,%ecx
  802075:	d3 ef                	shr    %cl,%edi
  802077:	09 c7                	or     %eax,%edi
  802079:	89 e9                	mov    %ebp,%ecx
  80207b:	d3 e2                	shl    %cl,%edx
  80207d:	89 14 24             	mov    %edx,(%esp)
  802080:	89 d8                	mov    %ebx,%eax
  802082:	d3 e0                	shl    %cl,%eax
  802084:	89 c2                	mov    %eax,%edx
  802086:	8b 44 24 08          	mov    0x8(%esp),%eax
  80208a:	d3 e0                	shl    %cl,%eax
  80208c:	89 44 24 04          	mov    %eax,0x4(%esp)
  802090:	8b 44 24 08          	mov    0x8(%esp),%eax
  802094:	89 f1                	mov    %esi,%ecx
  802096:	d3 e8                	shr    %cl,%eax
  802098:	09 d0                	or     %edx,%eax
  80209a:	d3 eb                	shr    %cl,%ebx
  80209c:	89 da                	mov    %ebx,%edx
  80209e:	f7 f7                	div    %edi
  8020a0:	89 d3                	mov    %edx,%ebx
  8020a2:	f7 24 24             	mull   (%esp)
  8020a5:	89 c6                	mov    %eax,%esi
  8020a7:	89 d1                	mov    %edx,%ecx
  8020a9:	39 d3                	cmp    %edx,%ebx
  8020ab:	0f 82 87 00 00 00    	jb     802138 <__umoddi3+0x134>
  8020b1:	0f 84 91 00 00 00    	je     802148 <__umoddi3+0x144>
  8020b7:	8b 54 24 04          	mov    0x4(%esp),%edx
  8020bb:	29 f2                	sub    %esi,%edx
  8020bd:	19 cb                	sbb    %ecx,%ebx
  8020bf:	89 d8                	mov    %ebx,%eax
  8020c1:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  8020c5:	d3 e0                	shl    %cl,%eax
  8020c7:	89 e9                	mov    %ebp,%ecx
  8020c9:	d3 ea                	shr    %cl,%edx
  8020cb:	09 d0                	or     %edx,%eax
  8020cd:	89 e9                	mov    %ebp,%ecx
  8020cf:	d3 eb                	shr    %cl,%ebx
  8020d1:	89 da                	mov    %ebx,%edx
  8020d3:	83 c4 1c             	add    $0x1c,%esp
  8020d6:	5b                   	pop    %ebx
  8020d7:	5e                   	pop    %esi
  8020d8:	5f                   	pop    %edi
  8020d9:	5d                   	pop    %ebp
  8020da:	c3                   	ret    
  8020db:	90                   	nop
  8020dc:	89 fd                	mov    %edi,%ebp
  8020de:	85 ff                	test   %edi,%edi
  8020e0:	75 0b                	jne    8020ed <__umoddi3+0xe9>
  8020e2:	b8 01 00 00 00       	mov    $0x1,%eax
  8020e7:	31 d2                	xor    %edx,%edx
  8020e9:	f7 f7                	div    %edi
  8020eb:	89 c5                	mov    %eax,%ebp
  8020ed:	89 f0                	mov    %esi,%eax
  8020ef:	31 d2                	xor    %edx,%edx
  8020f1:	f7 f5                	div    %ebp
  8020f3:	89 c8                	mov    %ecx,%eax
  8020f5:	f7 f5                	div    %ebp
  8020f7:	89 d0                	mov    %edx,%eax
  8020f9:	e9 44 ff ff ff       	jmp    802042 <__umoddi3+0x3e>
  8020fe:	66 90                	xchg   %ax,%ax
  802100:	89 c8                	mov    %ecx,%eax
  802102:	89 f2                	mov    %esi,%edx
  802104:	83 c4 1c             	add    $0x1c,%esp
  802107:	5b                   	pop    %ebx
  802108:	5e                   	pop    %esi
  802109:	5f                   	pop    %edi
  80210a:	5d                   	pop    %ebp
  80210b:	c3                   	ret    
  80210c:	3b 04 24             	cmp    (%esp),%eax
  80210f:	72 06                	jb     802117 <__umoddi3+0x113>
  802111:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  802115:	77 0f                	ja     802126 <__umoddi3+0x122>
  802117:	89 f2                	mov    %esi,%edx
  802119:	29 f9                	sub    %edi,%ecx
  80211b:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  80211f:	89 14 24             	mov    %edx,(%esp)
  802122:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  802126:	8b 44 24 04          	mov    0x4(%esp),%eax
  80212a:	8b 14 24             	mov    (%esp),%edx
  80212d:	83 c4 1c             	add    $0x1c,%esp
  802130:	5b                   	pop    %ebx
  802131:	5e                   	pop    %esi
  802132:	5f                   	pop    %edi
  802133:	5d                   	pop    %ebp
  802134:	c3                   	ret    
  802135:	8d 76 00             	lea    0x0(%esi),%esi
  802138:	2b 04 24             	sub    (%esp),%eax
  80213b:	19 fa                	sbb    %edi,%edx
  80213d:	89 d1                	mov    %edx,%ecx
  80213f:	89 c6                	mov    %eax,%esi
  802141:	e9 71 ff ff ff       	jmp    8020b7 <__umoddi3+0xb3>
  802146:	66 90                	xchg   %ax,%ax
  802148:	39 44 24 04          	cmp    %eax,0x4(%esp)
  80214c:	72 ea                	jb     802138 <__umoddi3+0x134>
  80214e:	89 d9                	mov    %ebx,%ecx
  802150:	e9 62 ff ff ff       	jmp    8020b7 <__umoddi3+0xb3>
