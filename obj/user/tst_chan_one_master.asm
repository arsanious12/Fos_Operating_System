
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
  800047:	68 40 21 80 00       	push   $0x802140
  80004c:	6a 0e                	push   $0xe
  80004e:	e8 25 07 00 00       	call   800778 <cprintf_colored>
  800053:	83 c4 10             	add    $0x10,%esp
	cprintf_colored(TEXT_yellow,"MAKE SURE to have a FRESH RUN for this test\n(i.e. don't run any program/test before it)\n");
  800056:	83 ec 08             	sub    $0x8,%esp
  800059:	68 70 21 80 00       	push   $0x802170
  80005e:	6a 0e                	push   $0xe
  800060:	e8 13 07 00 00       	call   800778 <cprintf_colored>
  800065:	83 c4 10             	add    $0x10,%esp
	cprintf_colored(TEXT_yellow,"==============================================\n");
  800068:	83 ec 08             	sub    $0x8,%esp
  80006b:	68 40 21 80 00       	push   $0x802140
  800070:	6a 0e                	push   $0xe
  800072:	e8 01 07 00 00       	call   800778 <cprintf_colored>
  800077:	83 c4 10             	add    $0x10,%esp

	int envID = sys_getenvid();
  80007a:	e8 88 1a 00 00       	call   801b07 <sys_getenvid>
  80007f:	89 45 dc             	mov    %eax,-0x24(%ebp)
	char slavesCnt[10];
	readline("Enter the number of Slave Programs: ", slavesCnt);
  800082:	83 ec 08             	sub    $0x8,%esp
  800085:	8d 45 ce             	lea    -0x32(%ebp),%eax
  800088:	50                   	push   %eax
  800089:	68 cc 21 80 00       	push   $0x8021cc
  80008e:	e8 91 0d 00 00       	call   800e24 <readline>
  800093:	83 c4 10             	add    $0x10,%esp
	int numOfSlaves = strtol(slavesCnt, NULL, 10);
  800096:	83 ec 04             	sub    $0x4,%esp
  800099:	6a 0a                	push   $0xa
  80009b:	6a 00                	push   $0x0
  80009d:	8d 45 ce             	lea    -0x32(%ebp),%eax
  8000a0:	50                   	push   %eax
  8000a1:	e8 95 13 00 00       	call   80143b <strtol>
  8000a6:	83 c4 10             	add    $0x10,%esp
  8000a9:	89 45 c8             	mov    %eax,-0x38(%ebp)

	//Save number of slaved to be checked later
	char cmd1[64] = "__NumOfSlaves@Set";
  8000ac:	8d 45 88             	lea    -0x78(%ebp),%eax
  8000af:	bb 56 23 80 00       	mov    $0x802356,%ebx
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
  8000da:	e8 77 1c 00 00       	call   801d56 <sys_utilities>
  8000df:	83 c4 10             	add    $0x10,%esp

	//Create and run slave programs that should sleep
	int id;
	for (int i = 0; i < numOfSlaves; ++i)
  8000e2:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  8000e9:	eb 6a                	jmp    800155 <_main+0x11d>
	{
		id = sys_create_env("tstChanOneSlave", (myEnv->page_WS_max_size),(myEnv->SecondListSize), (myEnv->percentage_of_WS_pages_to_be_removed));
  8000eb:	a1 20 30 80 00       	mov    0x803020,%eax
  8000f0:	8b 90 94 05 00 00    	mov    0x594(%eax),%edx
  8000f6:	a1 20 30 80 00       	mov    0x803020,%eax
  8000fb:	8b 80 8c 05 00 00    	mov    0x58c(%eax),%eax
  800101:	89 c1                	mov    %eax,%ecx
  800103:	a1 20 30 80 00       	mov    0x803020,%eax
  800108:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
  80010e:	52                   	push   %edx
  80010f:	51                   	push   %ecx
  800110:	50                   	push   %eax
  800111:	68 f1 21 80 00       	push   $0x8021f1
  800116:	e8 97 19 00 00       	call   801ab2 <sys_create_env>
  80011b:	83 c4 10             	add    $0x10,%esp
  80011e:	89 45 d8             	mov    %eax,-0x28(%ebp)
		if (id== E_ENV_CREATION_ERROR)
  800121:	83 7d d8 ef          	cmpl   $0xffffffef,-0x28(%ebp)
  800125:	75 1d                	jne    800144 <_main+0x10c>
		{
			cprintf_colored(TEXT_TESTERR_CLR, "\n%~insufficient number of processes in the system! only %d slave processes are created\n", i);
  800127:	83 ec 04             	sub    $0x4,%esp
  80012a:	ff 75 e4             	pushl  -0x1c(%ebp)
  80012d:	68 04 22 80 00       	push   $0x802204
  800132:	6a 0c                	push   $0xc
  800134:	e8 3f 06 00 00       	call   800778 <cprintf_colored>
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
  80014a:	e8 81 19 00 00       	call   801ad0 <sys_run_env>
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
  80016a:	bb 96 23 80 00       	mov    $0x802396,%ebx
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
  80019b:	e8 b6 1b 00 00       	call   801d56 <sys_utilities>
  8001a0:	83 c4 10             	add    $0x10,%esp
	int cnt = 0;
  8001a3:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
	while (numOfBlockedProcesses != numOfSlaves)
  8001aa:	eb 76                	jmp    800222 <_main+0x1ea>
	{
		env_sleep(5000);
  8001ac:	83 ec 0c             	sub    $0xc,%esp
  8001af:	68 88 13 00 00       	push   $0x1388
  8001b4:	e8 29 1c 00 00       	call   801de2 <env_sleep>
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
  8001cf:	68 5c 22 80 00       	push   $0x80225c
  8001d4:	6a 2d                	push   $0x2d
  8001d6:	68 b5 22 80 00       	push   $0x8022b5
  8001db:	e8 9d 02 00 00       	call   80047d <_panic>
		}
		char cmd3[64] = "__GetChanQueueSize__";
  8001e0:	8d 85 c4 fe ff ff    	lea    -0x13c(%ebp),%eax
  8001e6:	bb 96 23 80 00       	mov    $0x802396,%ebx
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
  800217:	e8 3a 1b 00 00       	call   801d56 <sys_utilities>
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
  80022c:	e8 cd 19 00 00       	call   801bfe <rsttst>

	//Wakeup one
	char cmd4[64] = "__WakeupOne__";
  800231:	8d 85 04 ff ff ff    	lea    -0xfc(%ebp),%eax
  800237:	bb d6 23 80 00       	mov    $0x8023d6,%ebx
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
  800266:	e8 eb 1a 00 00       	call   801d56 <sys_utilities>
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
  80027f:	e8 5e 1b 00 00       	call   801de2 <env_sleep>
  800284:	83 c4 10             	add    $0x10,%esp
		if (cnt == numOfSlaves)
  800287:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80028a:	39 45 e0             	cmp    %eax,-0x20(%ebp)
  80028d:	75 14                	jne    8002a3 <_main+0x26b>
		{
			panic("%~test channels failed! not all slaves finished");
  80028f:	83 ec 04             	sub    $0x4,%esp
  800292:	68 d0 22 80 00       	push   $0x8022d0
  800297:	6a 41                	push   $0x41
  800299:	68 b5 22 80 00       	push   $0x8022b5
  80029e:	e8 da 01 00 00       	call   80047d <_panic>
		}
		cnt++ ;
  8002a3:	ff 45 e0             	incl   -0x20(%ebp)
	char cmd4[64] = "__WakeupOne__";
	sys_utilities(cmd4, 0);

	//Wait until all slave finished
	cnt = 0;
	while (gettst() != numOfSlaves)
  8002a6:	e8 cd 19 00 00       	call   801c78 <gettst>
  8002ab:	8b 55 c8             	mov    -0x38(%ebp),%edx
  8002ae:	39 d0                	cmp    %edx,%eax
  8002b0:	75 c5                	jne    800277 <_main+0x23f>
			panic("%~test channels failed! not all slaves finished");
		}
		cnt++ ;
	}

	cprintf_colored(TEXT_light_green, "%~\n\nCongratulations!! Test of Channel (sleep & wakeup ONE) completed successfully!!\n\n");
  8002b2:	83 ec 08             	sub    $0x8,%esp
  8002b5:	68 00 23 80 00       	push   $0x802300
  8002ba:	6a 0a                	push   $0xa
  8002bc:	e8 b7 04 00 00       	call   800778 <cprintf_colored>
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
  8002d6:	e8 45 18 00 00       	call   801b20 <sys_getenvindex>
  8002db:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	myEnv = &(envs[envIndex]);
  8002de:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8002e1:	89 d0                	mov    %edx,%eax
  8002e3:	c1 e0 02             	shl    $0x2,%eax
  8002e6:	01 d0                	add    %edx,%eax
  8002e8:	c1 e0 03             	shl    $0x3,%eax
  8002eb:	01 d0                	add    %edx,%eax
  8002ed:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  8002f4:	01 d0                	add    %edx,%eax
  8002f6:	c1 e0 02             	shl    $0x2,%eax
  8002f9:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8002fe:	a3 20 30 80 00       	mov    %eax,0x803020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800303:	a1 20 30 80 00       	mov    0x803020,%eax
  800308:	8a 40 20             	mov    0x20(%eax),%al
  80030b:	84 c0                	test   %al,%al
  80030d:	74 0d                	je     80031c <libmain+0x4f>
		binaryname = myEnv->prog_name;
  80030f:	a1 20 30 80 00       	mov    0x803020,%eax
  800314:	83 c0 20             	add    $0x20,%eax
  800317:	a3 04 30 80 00       	mov    %eax,0x803004

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80031c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800320:	7e 0a                	jle    80032c <libmain+0x5f>
		binaryname = argv[0];
  800322:	8b 45 0c             	mov    0xc(%ebp),%eax
  800325:	8b 00                	mov    (%eax),%eax
  800327:	a3 04 30 80 00       	mov    %eax,0x803004

	// call user main routine
	_main(argc, argv);
  80032c:	83 ec 08             	sub    $0x8,%esp
  80032f:	ff 75 0c             	pushl  0xc(%ebp)
  800332:	ff 75 08             	pushl  0x8(%ebp)
  800335:	e8 fe fc ff ff       	call   800038 <_main>
  80033a:	83 c4 10             	add    $0x10,%esp

	if (printStats)
  80033d:	a1 00 30 80 00       	mov    0x803000,%eax
  800342:	85 c0                	test   %eax,%eax
  800344:	0f 84 01 01 00 00    	je     80044b <libmain+0x17e>
	{
		char isOPTReplCmd[100] = "__IsOPTRepl__" ;
  80034a:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  800350:	bb 10 25 80 00       	mov    $0x802510,%ebx
  800355:	ba 0e 00 00 00       	mov    $0xe,%edx
  80035a:	89 c7                	mov    %eax,%edi
  80035c:	89 de                	mov    %ebx,%esi
  80035e:	89 d1                	mov    %edx,%ecx
  800360:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  800362:	8d 55 8a             	lea    -0x76(%ebp),%edx
  800365:	b9 56 00 00 00       	mov    $0x56,%ecx
  80036a:	b0 00                	mov    $0x0,%al
  80036c:	89 d7                	mov    %edx,%edi
  80036e:	f3 aa                	rep stos %al,%es:(%edi)
		int isOPTRepl = 0;
  800370:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
		sys_utilities(isOPTReplCmd, (uint32)(&isOPTRepl));
  800377:	8d 45 e0             	lea    -0x20(%ebp),%eax
  80037a:	83 ec 08             	sub    $0x8,%esp
  80037d:	50                   	push   %eax
  80037e:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  800384:	50                   	push   %eax
  800385:	e8 cc 19 00 00       	call   801d56 <sys_utilities>
  80038a:	83 c4 10             	add    $0x10,%esp

		sys_lock_cons();
  80038d:	e8 15 15 00 00       	call   8018a7 <sys_lock_cons>
		{
			cprintf("**************************************\n");
  800392:	83 ec 0c             	sub    $0xc,%esp
  800395:	68 30 24 80 00       	push   $0x802430
  80039a:	e8 ac 03 00 00       	call   80074b <cprintf>
  80039f:	83 c4 10             	add    $0x10,%esp
			if (isOPTRepl)
  8003a2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8003a5:	85 c0                	test   %eax,%eax
  8003a7:	74 18                	je     8003c1 <libmain+0xf4>
			{
				cprintf("OPTIMAL number of page faults = %d\n", sys_get_optimal_num_faults());
  8003a9:	e8 c6 19 00 00       	call   801d74 <sys_get_optimal_num_faults>
  8003ae:	83 ec 08             	sub    $0x8,%esp
  8003b1:	50                   	push   %eax
  8003b2:	68 58 24 80 00       	push   $0x802458
  8003b7:	e8 8f 03 00 00       	call   80074b <cprintf>
  8003bc:	83 c4 10             	add    $0x10,%esp
  8003bf:	eb 59                	jmp    80041a <libmain+0x14d>
			}
			else
			{
				cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8003c1:	a1 20 30 80 00       	mov    0x803020,%eax
  8003c6:	8b 90 a8 05 00 00    	mov    0x5a8(%eax),%edx
  8003cc:	a1 20 30 80 00       	mov    0x803020,%eax
  8003d1:	8b 80 98 05 00 00    	mov    0x598(%eax),%eax
  8003d7:	83 ec 04             	sub    $0x4,%esp
  8003da:	52                   	push   %edx
  8003db:	50                   	push   %eax
  8003dc:	68 7c 24 80 00       	push   $0x80247c
  8003e1:	e8 65 03 00 00       	call   80074b <cprintf>
  8003e6:	83 c4 10             	add    $0x10,%esp
				cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  8003e9:	a1 20 30 80 00       	mov    0x803020,%eax
  8003ee:	8b 88 bc 05 00 00    	mov    0x5bc(%eax),%ecx
  8003f4:	a1 20 30 80 00       	mov    0x803020,%eax
  8003f9:	8b 90 b8 05 00 00    	mov    0x5b8(%eax),%edx
  8003ff:	a1 20 30 80 00       	mov    0x803020,%eax
  800404:	8b 80 b4 05 00 00    	mov    0x5b4(%eax),%eax
  80040a:	51                   	push   %ecx
  80040b:	52                   	push   %edx
  80040c:	50                   	push   %eax
  80040d:	68 a4 24 80 00       	push   $0x8024a4
  800412:	e8 34 03 00 00       	call   80074b <cprintf>
  800417:	83 c4 10             	add    $0x10,%esp
			}
			//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
			cprintf("Num of clocks = %d\n", myEnv->nClocks);
  80041a:	a1 20 30 80 00       	mov    0x803020,%eax
  80041f:	8b 80 c0 05 00 00    	mov    0x5c0(%eax),%eax
  800425:	83 ec 08             	sub    $0x8,%esp
  800428:	50                   	push   %eax
  800429:	68 fc 24 80 00       	push   $0x8024fc
  80042e:	e8 18 03 00 00       	call   80074b <cprintf>
  800433:	83 c4 10             	add    $0x10,%esp
			cprintf("**************************************\n");
  800436:	83 ec 0c             	sub    $0xc,%esp
  800439:	68 30 24 80 00       	push   $0x802430
  80043e:	e8 08 03 00 00       	call   80074b <cprintf>
  800443:	83 c4 10             	add    $0x10,%esp
		}
		sys_unlock_cons();
  800446:	e8 76 14 00 00       	call   8018c1 <sys_unlock_cons>
	}

	// exit gracefully
	exit();
  80044b:	e8 1f 00 00 00       	call   80046f <exit>
}
  800450:	90                   	nop
  800451:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800454:	5b                   	pop    %ebx
  800455:	5e                   	pop    %esi
  800456:	5f                   	pop    %edi
  800457:	5d                   	pop    %ebp
  800458:	c3                   	ret    

00800459 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800459:	55                   	push   %ebp
  80045a:	89 e5                	mov    %esp,%ebp
  80045c:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  80045f:	83 ec 0c             	sub    $0xc,%esp
  800462:	6a 00                	push   $0x0
  800464:	e8 83 16 00 00       	call   801aec <sys_destroy_env>
  800469:	83 c4 10             	add    $0x10,%esp
}
  80046c:	90                   	nop
  80046d:	c9                   	leave  
  80046e:	c3                   	ret    

0080046f <exit>:

void
exit(void)
{
  80046f:	55                   	push   %ebp
  800470:	89 e5                	mov    %esp,%ebp
  800472:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  800475:	e8 d8 16 00 00       	call   801b52 <sys_exit_env>
}
  80047a:	90                   	nop
  80047b:	c9                   	leave  
  80047c:	c3                   	ret    

0080047d <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  80047d:	55                   	push   %ebp
  80047e:	89 e5                	mov    %esp,%ebp
  800480:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  800483:	8d 45 10             	lea    0x10(%ebp),%eax
  800486:	83 c0 04             	add    $0x4,%eax
  800489:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  80048c:	a1 18 b1 81 00       	mov    0x81b118,%eax
  800491:	85 c0                	test   %eax,%eax
  800493:	74 16                	je     8004ab <_panic+0x2e>
		cprintf("%s: ", argv0);
  800495:	a1 18 b1 81 00       	mov    0x81b118,%eax
  80049a:	83 ec 08             	sub    $0x8,%esp
  80049d:	50                   	push   %eax
  80049e:	68 74 25 80 00       	push   $0x802574
  8004a3:	e8 a3 02 00 00       	call   80074b <cprintf>
  8004a8:	83 c4 10             	add    $0x10,%esp
	cprintf_colored(TEXT_PANIC_CLR, "user [EVAL_FINAL]panic in %s at %s:%d: ", binaryname, file, line);
  8004ab:	a1 04 30 80 00       	mov    0x803004,%eax
  8004b0:	83 ec 0c             	sub    $0xc,%esp
  8004b3:	ff 75 0c             	pushl  0xc(%ebp)
  8004b6:	ff 75 08             	pushl  0x8(%ebp)
  8004b9:	50                   	push   %eax
  8004ba:	68 7c 25 80 00       	push   $0x80257c
  8004bf:	6a 74                	push   $0x74
  8004c1:	e8 b2 02 00 00       	call   800778 <cprintf_colored>
  8004c6:	83 c4 20             	add    $0x20,%esp
	vcprintf(fmt, ap);
  8004c9:	8b 45 10             	mov    0x10(%ebp),%eax
  8004cc:	83 ec 08             	sub    $0x8,%esp
  8004cf:	ff 75 f4             	pushl  -0xc(%ebp)
  8004d2:	50                   	push   %eax
  8004d3:	e8 04 02 00 00       	call   8006dc <vcprintf>
  8004d8:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  8004db:	83 ec 08             	sub    $0x8,%esp
  8004de:	6a 00                	push   $0x0
  8004e0:	68 a4 25 80 00       	push   $0x8025a4
  8004e5:	e8 f2 01 00 00       	call   8006dc <vcprintf>
  8004ea:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  8004ed:	e8 7d ff ff ff       	call   80046f <exit>

	// should not return here
	while (1) ;
  8004f2:	eb fe                	jmp    8004f2 <_panic+0x75>

008004f4 <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  8004f4:	55                   	push   %ebp
  8004f5:	89 e5                	mov    %esp,%ebp
  8004f7:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  8004fa:	a1 20 30 80 00       	mov    0x803020,%eax
  8004ff:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  800505:	8b 45 0c             	mov    0xc(%ebp),%eax
  800508:	39 c2                	cmp    %eax,%edx
  80050a:	74 14                	je     800520 <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  80050c:	83 ec 04             	sub    $0x4,%esp
  80050f:	68 a8 25 80 00       	push   $0x8025a8
  800514:	6a 26                	push   $0x26
  800516:	68 f4 25 80 00       	push   $0x8025f4
  80051b:	e8 5d ff ff ff       	call   80047d <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  800520:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  800527:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80052e:	e9 c5 00 00 00       	jmp    8005f8 <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  800533:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800536:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80053d:	8b 45 08             	mov    0x8(%ebp),%eax
  800540:	01 d0                	add    %edx,%eax
  800542:	8b 00                	mov    (%eax),%eax
  800544:	85 c0                	test   %eax,%eax
  800546:	75 08                	jne    800550 <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  800548:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  80054b:	e9 a5 00 00 00       	jmp    8005f5 <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  800550:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800557:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  80055e:	eb 69                	jmp    8005c9 <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  800560:	a1 20 30 80 00       	mov    0x803020,%eax
  800565:	8b 88 90 05 00 00    	mov    0x590(%eax),%ecx
  80056b:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80056e:	89 d0                	mov    %edx,%eax
  800570:	01 c0                	add    %eax,%eax
  800572:	01 d0                	add    %edx,%eax
  800574:	c1 e0 03             	shl    $0x3,%eax
  800577:	01 c8                	add    %ecx,%eax
  800579:	8a 40 04             	mov    0x4(%eax),%al
  80057c:	84 c0                	test   %al,%al
  80057e:	75 46                	jne    8005c6 <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800580:	a1 20 30 80 00       	mov    0x803020,%eax
  800585:	8b 88 90 05 00 00    	mov    0x590(%eax),%ecx
  80058b:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80058e:	89 d0                	mov    %edx,%eax
  800590:	01 c0                	add    %eax,%eax
  800592:	01 d0                	add    %edx,%eax
  800594:	c1 e0 03             	shl    $0x3,%eax
  800597:	01 c8                	add    %ecx,%eax
  800599:	8b 00                	mov    (%eax),%eax
  80059b:	89 45 dc             	mov    %eax,-0x24(%ebp)
  80059e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8005a1:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8005a6:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  8005a8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8005ab:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8005b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8005b5:	01 c8                	add    %ecx,%eax
  8005b7:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8005b9:	39 c2                	cmp    %eax,%edx
  8005bb:	75 09                	jne    8005c6 <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  8005bd:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  8005c4:	eb 15                	jmp    8005db <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8005c6:	ff 45 e8             	incl   -0x18(%ebp)
  8005c9:	a1 20 30 80 00       	mov    0x803020,%eax
  8005ce:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  8005d4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8005d7:	39 c2                	cmp    %eax,%edx
  8005d9:	77 85                	ja     800560 <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  8005db:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8005df:	75 14                	jne    8005f5 <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  8005e1:	83 ec 04             	sub    $0x4,%esp
  8005e4:	68 00 26 80 00       	push   $0x802600
  8005e9:	6a 3a                	push   $0x3a
  8005eb:	68 f4 25 80 00       	push   $0x8025f4
  8005f0:	e8 88 fe ff ff       	call   80047d <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  8005f5:	ff 45 f0             	incl   -0x10(%ebp)
  8005f8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8005fb:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8005fe:	0f 8c 2f ff ff ff    	jl     800533 <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  800604:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80060b:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800612:	eb 26                	jmp    80063a <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  800614:	a1 20 30 80 00       	mov    0x803020,%eax
  800619:	8b 88 90 05 00 00    	mov    0x590(%eax),%ecx
  80061f:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800622:	89 d0                	mov    %edx,%eax
  800624:	01 c0                	add    %eax,%eax
  800626:	01 d0                	add    %edx,%eax
  800628:	c1 e0 03             	shl    $0x3,%eax
  80062b:	01 c8                	add    %ecx,%eax
  80062d:	8a 40 04             	mov    0x4(%eax),%al
  800630:	3c 01                	cmp    $0x1,%al
  800632:	75 03                	jne    800637 <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  800634:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800637:	ff 45 e0             	incl   -0x20(%ebp)
  80063a:	a1 20 30 80 00       	mov    0x803020,%eax
  80063f:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  800645:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800648:	39 c2                	cmp    %eax,%edx
  80064a:	77 c8                	ja     800614 <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  80064c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80064f:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800652:	74 14                	je     800668 <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  800654:	83 ec 04             	sub    $0x4,%esp
  800657:	68 54 26 80 00       	push   $0x802654
  80065c:	6a 44                	push   $0x44
  80065e:	68 f4 25 80 00       	push   $0x8025f4
  800663:	e8 15 fe ff ff       	call   80047d <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  800668:	90                   	nop
  800669:	c9                   	leave  
  80066a:	c3                   	ret    

0080066b <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  80066b:	55                   	push   %ebp
  80066c:	89 e5                	mov    %esp,%ebp
  80066e:	53                   	push   %ebx
  80066f:	83 ec 04             	sub    $0x4,%esp
	b->buf[b->idx++] = ch;
  800672:	8b 45 0c             	mov    0xc(%ebp),%eax
  800675:	8b 00                	mov    (%eax),%eax
  800677:	8d 48 01             	lea    0x1(%eax),%ecx
  80067a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80067d:	89 0a                	mov    %ecx,(%edx)
  80067f:	8b 55 08             	mov    0x8(%ebp),%edx
  800682:	88 d1                	mov    %dl,%cl
  800684:	8b 55 0c             	mov    0xc(%ebp),%edx
  800687:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  80068b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80068e:	8b 00                	mov    (%eax),%eax
  800690:	3d ff 00 00 00       	cmp    $0xff,%eax
  800695:	75 30                	jne    8006c7 <putch+0x5c>
		sys_cputs(b->buf, b->idx, printProgName, curTextClr);
  800697:	8b 15 1c b1 81 00    	mov    0x81b11c,%edx
  80069d:	a0 44 30 80 00       	mov    0x803044,%al
  8006a2:	0f b6 c0             	movzbl %al,%eax
  8006a5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8006a8:	8b 09                	mov    (%ecx),%ecx
  8006aa:	89 cb                	mov    %ecx,%ebx
  8006ac:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8006af:	83 c1 08             	add    $0x8,%ecx
  8006b2:	52                   	push   %edx
  8006b3:	50                   	push   %eax
  8006b4:	53                   	push   %ebx
  8006b5:	51                   	push   %ecx
  8006b6:	e8 a8 11 00 00       	call   801863 <sys_cputs>
  8006bb:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8006be:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006c1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8006c7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006ca:	8b 40 04             	mov    0x4(%eax),%eax
  8006cd:	8d 50 01             	lea    0x1(%eax),%edx
  8006d0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006d3:	89 50 04             	mov    %edx,0x4(%eax)
}
  8006d6:	90                   	nop
  8006d7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8006da:	c9                   	leave  
  8006db:	c3                   	ret    

008006dc <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  8006dc:	55                   	push   %ebp
  8006dd:	89 e5                	mov    %esp,%ebp
  8006df:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8006e5:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8006ec:	00 00 00 
	b.cnt = 0;
  8006ef:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8006f6:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  8006f9:	ff 75 0c             	pushl  0xc(%ebp)
  8006fc:	ff 75 08             	pushl  0x8(%ebp)
  8006ff:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800705:	50                   	push   %eax
  800706:	68 6b 06 80 00       	push   $0x80066b
  80070b:	e8 5a 02 00 00       	call   80096a <vprintfmt>
  800710:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName, curTextClr);
  800713:	8b 15 1c b1 81 00    	mov    0x81b11c,%edx
  800719:	a0 44 30 80 00       	mov    0x803044,%al
  80071e:	0f b6 c0             	movzbl %al,%eax
  800721:	8b 8d f0 fe ff ff    	mov    -0x110(%ebp),%ecx
  800727:	52                   	push   %edx
  800728:	50                   	push   %eax
  800729:	51                   	push   %ecx
  80072a:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800730:	83 c0 08             	add    $0x8,%eax
  800733:	50                   	push   %eax
  800734:	e8 2a 11 00 00       	call   801863 <sys_cputs>
  800739:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  80073c:	c6 05 44 30 80 00 00 	movb   $0x0,0x803044
	return b.cnt;
  800743:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800749:	c9                   	leave  
  80074a:	c3                   	ret    

0080074b <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  80074b:	55                   	push   %ebp
  80074c:	89 e5                	mov    %esp,%ebp
  80074e:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800751:	c6 05 44 30 80 00 01 	movb   $0x1,0x803044
	va_start(ap, fmt);
  800758:	8d 45 0c             	lea    0xc(%ebp),%eax
  80075b:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  80075e:	8b 45 08             	mov    0x8(%ebp),%eax
  800761:	83 ec 08             	sub    $0x8,%esp
  800764:	ff 75 f4             	pushl  -0xc(%ebp)
  800767:	50                   	push   %eax
  800768:	e8 6f ff ff ff       	call   8006dc <vcprintf>
  80076d:	83 c4 10             	add    $0x10,%esp
  800770:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800773:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800776:	c9                   	leave  
  800777:	c3                   	ret    

00800778 <cprintf_colored>:

// *************** This text coloring feature is implemented by *************
// ********** Abd-Alrahman Zedan From Team Frozen-Bytes - FCIS'24-25 ********
int cprintf_colored(int textClr, const char *fmt, ...) {
  800778:	55                   	push   %ebp
  800779:	89 e5                	mov    %esp,%ebp
  80077b:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  80077e:	c6 05 44 30 80 00 01 	movb   $0x1,0x803044
	curTextClr = (textClr << 8) ; //set text color by the given value
  800785:	8b 45 08             	mov    0x8(%ebp),%eax
  800788:	c1 e0 08             	shl    $0x8,%eax
  80078b:	a3 1c b1 81 00       	mov    %eax,0x81b11c
	va_start(ap, fmt);
  800790:	8d 45 0c             	lea    0xc(%ebp),%eax
  800793:	83 c0 04             	add    $0x4,%eax
  800796:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800799:	8b 45 0c             	mov    0xc(%ebp),%eax
  80079c:	83 ec 08             	sub    $0x8,%esp
  80079f:	ff 75 f4             	pushl  -0xc(%ebp)
  8007a2:	50                   	push   %eax
  8007a3:	e8 34 ff ff ff       	call   8006dc <vcprintf>
  8007a8:	83 c4 10             	add    $0x10,%esp
  8007ab:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);
	curTextClr = TEXT_DEFAULT_CLR; //restore default color
  8007ae:	c7 05 1c b1 81 00 00 	movl   $0x700,0x81b11c
  8007b5:	07 00 00 

	return cnt;
  8007b8:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8007bb:	c9                   	leave  
  8007bc:	c3                   	ret    

008007bd <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  8007bd:	55                   	push   %ebp
  8007be:	89 e5                	mov    %esp,%ebp
  8007c0:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  8007c3:	e8 df 10 00 00       	call   8018a7 <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  8007c8:	8d 45 0c             	lea    0xc(%ebp),%eax
  8007cb:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  8007ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8007d1:	83 ec 08             	sub    $0x8,%esp
  8007d4:	ff 75 f4             	pushl  -0xc(%ebp)
  8007d7:	50                   	push   %eax
  8007d8:	e8 ff fe ff ff       	call   8006dc <vcprintf>
  8007dd:	83 c4 10             	add    $0x10,%esp
  8007e0:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  8007e3:	e8 d9 10 00 00       	call   8018c1 <sys_unlock_cons>
	return cnt;
  8007e8:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8007eb:	c9                   	leave  
  8007ec:	c3                   	ret    

008007ed <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8007ed:	55                   	push   %ebp
  8007ee:	89 e5                	mov    %esp,%ebp
  8007f0:	53                   	push   %ebx
  8007f1:	83 ec 14             	sub    $0x14,%esp
  8007f4:	8b 45 10             	mov    0x10(%ebp),%eax
  8007f7:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8007fa:	8b 45 14             	mov    0x14(%ebp),%eax
  8007fd:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800800:	8b 45 18             	mov    0x18(%ebp),%eax
  800803:	ba 00 00 00 00       	mov    $0x0,%edx
  800808:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  80080b:	77 55                	ja     800862 <printnum+0x75>
  80080d:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800810:	72 05                	jb     800817 <printnum+0x2a>
  800812:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800815:	77 4b                	ja     800862 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800817:	8b 45 1c             	mov    0x1c(%ebp),%eax
  80081a:	8d 58 ff             	lea    -0x1(%eax),%ebx
  80081d:	8b 45 18             	mov    0x18(%ebp),%eax
  800820:	ba 00 00 00 00       	mov    $0x0,%edx
  800825:	52                   	push   %edx
  800826:	50                   	push   %eax
  800827:	ff 75 f4             	pushl  -0xc(%ebp)
  80082a:	ff 75 f0             	pushl  -0x10(%ebp)
  80082d:	e8 aa 16 00 00       	call   801edc <__udivdi3>
  800832:	83 c4 10             	add    $0x10,%esp
  800835:	83 ec 04             	sub    $0x4,%esp
  800838:	ff 75 20             	pushl  0x20(%ebp)
  80083b:	53                   	push   %ebx
  80083c:	ff 75 18             	pushl  0x18(%ebp)
  80083f:	52                   	push   %edx
  800840:	50                   	push   %eax
  800841:	ff 75 0c             	pushl  0xc(%ebp)
  800844:	ff 75 08             	pushl  0x8(%ebp)
  800847:	e8 a1 ff ff ff       	call   8007ed <printnum>
  80084c:	83 c4 20             	add    $0x20,%esp
  80084f:	eb 1a                	jmp    80086b <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800851:	83 ec 08             	sub    $0x8,%esp
  800854:	ff 75 0c             	pushl  0xc(%ebp)
  800857:	ff 75 20             	pushl  0x20(%ebp)
  80085a:	8b 45 08             	mov    0x8(%ebp),%eax
  80085d:	ff d0                	call   *%eax
  80085f:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800862:	ff 4d 1c             	decl   0x1c(%ebp)
  800865:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800869:	7f e6                	jg     800851 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80086b:	8b 4d 18             	mov    0x18(%ebp),%ecx
  80086e:	bb 00 00 00 00       	mov    $0x0,%ebx
  800873:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800876:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800879:	53                   	push   %ebx
  80087a:	51                   	push   %ecx
  80087b:	52                   	push   %edx
  80087c:	50                   	push   %eax
  80087d:	e8 6a 17 00 00       	call   801fec <__umoddi3>
  800882:	83 c4 10             	add    $0x10,%esp
  800885:	05 b4 28 80 00       	add    $0x8028b4,%eax
  80088a:	8a 00                	mov    (%eax),%al
  80088c:	0f be c0             	movsbl %al,%eax
  80088f:	83 ec 08             	sub    $0x8,%esp
  800892:	ff 75 0c             	pushl  0xc(%ebp)
  800895:	50                   	push   %eax
  800896:	8b 45 08             	mov    0x8(%ebp),%eax
  800899:	ff d0                	call   *%eax
  80089b:	83 c4 10             	add    $0x10,%esp
}
  80089e:	90                   	nop
  80089f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8008a2:	c9                   	leave  
  8008a3:	c3                   	ret    

008008a4 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8008a4:	55                   	push   %ebp
  8008a5:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8008a7:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8008ab:	7e 1c                	jle    8008c9 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  8008ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8008b0:	8b 00                	mov    (%eax),%eax
  8008b2:	8d 50 08             	lea    0x8(%eax),%edx
  8008b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8008b8:	89 10                	mov    %edx,(%eax)
  8008ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8008bd:	8b 00                	mov    (%eax),%eax
  8008bf:	83 e8 08             	sub    $0x8,%eax
  8008c2:	8b 50 04             	mov    0x4(%eax),%edx
  8008c5:	8b 00                	mov    (%eax),%eax
  8008c7:	eb 40                	jmp    800909 <getuint+0x65>
	else if (lflag)
  8008c9:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8008cd:	74 1e                	je     8008ed <getuint+0x49>
		return va_arg(*ap, unsigned long);
  8008cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8008d2:	8b 00                	mov    (%eax),%eax
  8008d4:	8d 50 04             	lea    0x4(%eax),%edx
  8008d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8008da:	89 10                	mov    %edx,(%eax)
  8008dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8008df:	8b 00                	mov    (%eax),%eax
  8008e1:	83 e8 04             	sub    $0x4,%eax
  8008e4:	8b 00                	mov    (%eax),%eax
  8008e6:	ba 00 00 00 00       	mov    $0x0,%edx
  8008eb:	eb 1c                	jmp    800909 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  8008ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8008f0:	8b 00                	mov    (%eax),%eax
  8008f2:	8d 50 04             	lea    0x4(%eax),%edx
  8008f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8008f8:	89 10                	mov    %edx,(%eax)
  8008fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8008fd:	8b 00                	mov    (%eax),%eax
  8008ff:	83 e8 04             	sub    $0x4,%eax
  800902:	8b 00                	mov    (%eax),%eax
  800904:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800909:	5d                   	pop    %ebp
  80090a:	c3                   	ret    

0080090b <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  80090b:	55                   	push   %ebp
  80090c:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  80090e:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800912:	7e 1c                	jle    800930 <getint+0x25>
		return va_arg(*ap, long long);
  800914:	8b 45 08             	mov    0x8(%ebp),%eax
  800917:	8b 00                	mov    (%eax),%eax
  800919:	8d 50 08             	lea    0x8(%eax),%edx
  80091c:	8b 45 08             	mov    0x8(%ebp),%eax
  80091f:	89 10                	mov    %edx,(%eax)
  800921:	8b 45 08             	mov    0x8(%ebp),%eax
  800924:	8b 00                	mov    (%eax),%eax
  800926:	83 e8 08             	sub    $0x8,%eax
  800929:	8b 50 04             	mov    0x4(%eax),%edx
  80092c:	8b 00                	mov    (%eax),%eax
  80092e:	eb 38                	jmp    800968 <getint+0x5d>
	else if (lflag)
  800930:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800934:	74 1a                	je     800950 <getint+0x45>
		return va_arg(*ap, long);
  800936:	8b 45 08             	mov    0x8(%ebp),%eax
  800939:	8b 00                	mov    (%eax),%eax
  80093b:	8d 50 04             	lea    0x4(%eax),%edx
  80093e:	8b 45 08             	mov    0x8(%ebp),%eax
  800941:	89 10                	mov    %edx,(%eax)
  800943:	8b 45 08             	mov    0x8(%ebp),%eax
  800946:	8b 00                	mov    (%eax),%eax
  800948:	83 e8 04             	sub    $0x4,%eax
  80094b:	8b 00                	mov    (%eax),%eax
  80094d:	99                   	cltd   
  80094e:	eb 18                	jmp    800968 <getint+0x5d>
	else
		return va_arg(*ap, int);
  800950:	8b 45 08             	mov    0x8(%ebp),%eax
  800953:	8b 00                	mov    (%eax),%eax
  800955:	8d 50 04             	lea    0x4(%eax),%edx
  800958:	8b 45 08             	mov    0x8(%ebp),%eax
  80095b:	89 10                	mov    %edx,(%eax)
  80095d:	8b 45 08             	mov    0x8(%ebp),%eax
  800960:	8b 00                	mov    (%eax),%eax
  800962:	83 e8 04             	sub    $0x4,%eax
  800965:	8b 00                	mov    (%eax),%eax
  800967:	99                   	cltd   
}
  800968:	5d                   	pop    %ebp
  800969:	c3                   	ret    

0080096a <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  80096a:	55                   	push   %ebp
  80096b:	89 e5                	mov    %esp,%ebp
  80096d:	56                   	push   %esi
  80096e:	53                   	push   %ebx
  80096f:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800972:	eb 17                	jmp    80098b <vprintfmt+0x21>
			if (ch == '\0')
  800974:	85 db                	test   %ebx,%ebx
  800976:	0f 84 c1 03 00 00    	je     800d3d <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  80097c:	83 ec 08             	sub    $0x8,%esp
  80097f:	ff 75 0c             	pushl  0xc(%ebp)
  800982:	53                   	push   %ebx
  800983:	8b 45 08             	mov    0x8(%ebp),%eax
  800986:	ff d0                	call   *%eax
  800988:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80098b:	8b 45 10             	mov    0x10(%ebp),%eax
  80098e:	8d 50 01             	lea    0x1(%eax),%edx
  800991:	89 55 10             	mov    %edx,0x10(%ebp)
  800994:	8a 00                	mov    (%eax),%al
  800996:	0f b6 d8             	movzbl %al,%ebx
  800999:	83 fb 25             	cmp    $0x25,%ebx
  80099c:	75 d6                	jne    800974 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  80099e:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  8009a2:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  8009a9:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8009b0:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  8009b7:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8009be:	8b 45 10             	mov    0x10(%ebp),%eax
  8009c1:	8d 50 01             	lea    0x1(%eax),%edx
  8009c4:	89 55 10             	mov    %edx,0x10(%ebp)
  8009c7:	8a 00                	mov    (%eax),%al
  8009c9:	0f b6 d8             	movzbl %al,%ebx
  8009cc:	8d 43 dd             	lea    -0x23(%ebx),%eax
  8009cf:	83 f8 5b             	cmp    $0x5b,%eax
  8009d2:	0f 87 3d 03 00 00    	ja     800d15 <vprintfmt+0x3ab>
  8009d8:	8b 04 85 d8 28 80 00 	mov    0x8028d8(,%eax,4),%eax
  8009df:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  8009e1:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  8009e5:	eb d7                	jmp    8009be <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8009e7:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  8009eb:	eb d1                	jmp    8009be <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8009ed:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  8009f4:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8009f7:	89 d0                	mov    %edx,%eax
  8009f9:	c1 e0 02             	shl    $0x2,%eax
  8009fc:	01 d0                	add    %edx,%eax
  8009fe:	01 c0                	add    %eax,%eax
  800a00:	01 d8                	add    %ebx,%eax
  800a02:	83 e8 30             	sub    $0x30,%eax
  800a05:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800a08:	8b 45 10             	mov    0x10(%ebp),%eax
  800a0b:	8a 00                	mov    (%eax),%al
  800a0d:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800a10:	83 fb 2f             	cmp    $0x2f,%ebx
  800a13:	7e 3e                	jle    800a53 <vprintfmt+0xe9>
  800a15:	83 fb 39             	cmp    $0x39,%ebx
  800a18:	7f 39                	jg     800a53 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800a1a:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800a1d:	eb d5                	jmp    8009f4 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800a1f:	8b 45 14             	mov    0x14(%ebp),%eax
  800a22:	83 c0 04             	add    $0x4,%eax
  800a25:	89 45 14             	mov    %eax,0x14(%ebp)
  800a28:	8b 45 14             	mov    0x14(%ebp),%eax
  800a2b:	83 e8 04             	sub    $0x4,%eax
  800a2e:	8b 00                	mov    (%eax),%eax
  800a30:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800a33:	eb 1f                	jmp    800a54 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800a35:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a39:	79 83                	jns    8009be <vprintfmt+0x54>
				width = 0;
  800a3b:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800a42:	e9 77 ff ff ff       	jmp    8009be <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800a47:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800a4e:	e9 6b ff ff ff       	jmp    8009be <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800a53:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800a54:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a58:	0f 89 60 ff ff ff    	jns    8009be <vprintfmt+0x54>
				width = precision, precision = -1;
  800a5e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800a61:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800a64:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800a6b:	e9 4e ff ff ff       	jmp    8009be <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800a70:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800a73:	e9 46 ff ff ff       	jmp    8009be <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800a78:	8b 45 14             	mov    0x14(%ebp),%eax
  800a7b:	83 c0 04             	add    $0x4,%eax
  800a7e:	89 45 14             	mov    %eax,0x14(%ebp)
  800a81:	8b 45 14             	mov    0x14(%ebp),%eax
  800a84:	83 e8 04             	sub    $0x4,%eax
  800a87:	8b 00                	mov    (%eax),%eax
  800a89:	83 ec 08             	sub    $0x8,%esp
  800a8c:	ff 75 0c             	pushl  0xc(%ebp)
  800a8f:	50                   	push   %eax
  800a90:	8b 45 08             	mov    0x8(%ebp),%eax
  800a93:	ff d0                	call   *%eax
  800a95:	83 c4 10             	add    $0x10,%esp
			break;
  800a98:	e9 9b 02 00 00       	jmp    800d38 <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800a9d:	8b 45 14             	mov    0x14(%ebp),%eax
  800aa0:	83 c0 04             	add    $0x4,%eax
  800aa3:	89 45 14             	mov    %eax,0x14(%ebp)
  800aa6:	8b 45 14             	mov    0x14(%ebp),%eax
  800aa9:	83 e8 04             	sub    $0x4,%eax
  800aac:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800aae:	85 db                	test   %ebx,%ebx
  800ab0:	79 02                	jns    800ab4 <vprintfmt+0x14a>
				err = -err;
  800ab2:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800ab4:	83 fb 64             	cmp    $0x64,%ebx
  800ab7:	7f 0b                	jg     800ac4 <vprintfmt+0x15a>
  800ab9:	8b 34 9d 20 27 80 00 	mov    0x802720(,%ebx,4),%esi
  800ac0:	85 f6                	test   %esi,%esi
  800ac2:	75 19                	jne    800add <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800ac4:	53                   	push   %ebx
  800ac5:	68 c5 28 80 00       	push   $0x8028c5
  800aca:	ff 75 0c             	pushl  0xc(%ebp)
  800acd:	ff 75 08             	pushl  0x8(%ebp)
  800ad0:	e8 70 02 00 00       	call   800d45 <printfmt>
  800ad5:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800ad8:	e9 5b 02 00 00       	jmp    800d38 <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800add:	56                   	push   %esi
  800ade:	68 ce 28 80 00       	push   $0x8028ce
  800ae3:	ff 75 0c             	pushl  0xc(%ebp)
  800ae6:	ff 75 08             	pushl  0x8(%ebp)
  800ae9:	e8 57 02 00 00       	call   800d45 <printfmt>
  800aee:	83 c4 10             	add    $0x10,%esp
			break;
  800af1:	e9 42 02 00 00       	jmp    800d38 <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800af6:	8b 45 14             	mov    0x14(%ebp),%eax
  800af9:	83 c0 04             	add    $0x4,%eax
  800afc:	89 45 14             	mov    %eax,0x14(%ebp)
  800aff:	8b 45 14             	mov    0x14(%ebp),%eax
  800b02:	83 e8 04             	sub    $0x4,%eax
  800b05:	8b 30                	mov    (%eax),%esi
  800b07:	85 f6                	test   %esi,%esi
  800b09:	75 05                	jne    800b10 <vprintfmt+0x1a6>
				p = "(null)";
  800b0b:	be d1 28 80 00       	mov    $0x8028d1,%esi
			if (width > 0 && padc != '-')
  800b10:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800b14:	7e 6d                	jle    800b83 <vprintfmt+0x219>
  800b16:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800b1a:	74 67                	je     800b83 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800b1c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800b1f:	83 ec 08             	sub    $0x8,%esp
  800b22:	50                   	push   %eax
  800b23:	56                   	push   %esi
  800b24:	e8 26 05 00 00       	call   80104f <strnlen>
  800b29:	83 c4 10             	add    $0x10,%esp
  800b2c:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800b2f:	eb 16                	jmp    800b47 <vprintfmt+0x1dd>
					putch(padc, putdat);
  800b31:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800b35:	83 ec 08             	sub    $0x8,%esp
  800b38:	ff 75 0c             	pushl  0xc(%ebp)
  800b3b:	50                   	push   %eax
  800b3c:	8b 45 08             	mov    0x8(%ebp),%eax
  800b3f:	ff d0                	call   *%eax
  800b41:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800b44:	ff 4d e4             	decl   -0x1c(%ebp)
  800b47:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800b4b:	7f e4                	jg     800b31 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800b4d:	eb 34                	jmp    800b83 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800b4f:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800b53:	74 1c                	je     800b71 <vprintfmt+0x207>
  800b55:	83 fb 1f             	cmp    $0x1f,%ebx
  800b58:	7e 05                	jle    800b5f <vprintfmt+0x1f5>
  800b5a:	83 fb 7e             	cmp    $0x7e,%ebx
  800b5d:	7e 12                	jle    800b71 <vprintfmt+0x207>
					putch('?', putdat);
  800b5f:	83 ec 08             	sub    $0x8,%esp
  800b62:	ff 75 0c             	pushl  0xc(%ebp)
  800b65:	6a 3f                	push   $0x3f
  800b67:	8b 45 08             	mov    0x8(%ebp),%eax
  800b6a:	ff d0                	call   *%eax
  800b6c:	83 c4 10             	add    $0x10,%esp
  800b6f:	eb 0f                	jmp    800b80 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800b71:	83 ec 08             	sub    $0x8,%esp
  800b74:	ff 75 0c             	pushl  0xc(%ebp)
  800b77:	53                   	push   %ebx
  800b78:	8b 45 08             	mov    0x8(%ebp),%eax
  800b7b:	ff d0                	call   *%eax
  800b7d:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800b80:	ff 4d e4             	decl   -0x1c(%ebp)
  800b83:	89 f0                	mov    %esi,%eax
  800b85:	8d 70 01             	lea    0x1(%eax),%esi
  800b88:	8a 00                	mov    (%eax),%al
  800b8a:	0f be d8             	movsbl %al,%ebx
  800b8d:	85 db                	test   %ebx,%ebx
  800b8f:	74 24                	je     800bb5 <vprintfmt+0x24b>
  800b91:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800b95:	78 b8                	js     800b4f <vprintfmt+0x1e5>
  800b97:	ff 4d e0             	decl   -0x20(%ebp)
  800b9a:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800b9e:	79 af                	jns    800b4f <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800ba0:	eb 13                	jmp    800bb5 <vprintfmt+0x24b>
				putch(' ', putdat);
  800ba2:	83 ec 08             	sub    $0x8,%esp
  800ba5:	ff 75 0c             	pushl  0xc(%ebp)
  800ba8:	6a 20                	push   $0x20
  800baa:	8b 45 08             	mov    0x8(%ebp),%eax
  800bad:	ff d0                	call   *%eax
  800baf:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800bb2:	ff 4d e4             	decl   -0x1c(%ebp)
  800bb5:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800bb9:	7f e7                	jg     800ba2 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800bbb:	e9 78 01 00 00       	jmp    800d38 <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800bc0:	83 ec 08             	sub    $0x8,%esp
  800bc3:	ff 75 e8             	pushl  -0x18(%ebp)
  800bc6:	8d 45 14             	lea    0x14(%ebp),%eax
  800bc9:	50                   	push   %eax
  800bca:	e8 3c fd ff ff       	call   80090b <getint>
  800bcf:	83 c4 10             	add    $0x10,%esp
  800bd2:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800bd5:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800bd8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800bdb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800bde:	85 d2                	test   %edx,%edx
  800be0:	79 23                	jns    800c05 <vprintfmt+0x29b>
				putch('-', putdat);
  800be2:	83 ec 08             	sub    $0x8,%esp
  800be5:	ff 75 0c             	pushl  0xc(%ebp)
  800be8:	6a 2d                	push   $0x2d
  800bea:	8b 45 08             	mov    0x8(%ebp),%eax
  800bed:	ff d0                	call   *%eax
  800bef:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800bf2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800bf5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800bf8:	f7 d8                	neg    %eax
  800bfa:	83 d2 00             	adc    $0x0,%edx
  800bfd:	f7 da                	neg    %edx
  800bff:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c02:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800c05:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800c0c:	e9 bc 00 00 00       	jmp    800ccd <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800c11:	83 ec 08             	sub    $0x8,%esp
  800c14:	ff 75 e8             	pushl  -0x18(%ebp)
  800c17:	8d 45 14             	lea    0x14(%ebp),%eax
  800c1a:	50                   	push   %eax
  800c1b:	e8 84 fc ff ff       	call   8008a4 <getuint>
  800c20:	83 c4 10             	add    $0x10,%esp
  800c23:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c26:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800c29:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800c30:	e9 98 00 00 00       	jmp    800ccd <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800c35:	83 ec 08             	sub    $0x8,%esp
  800c38:	ff 75 0c             	pushl  0xc(%ebp)
  800c3b:	6a 58                	push   $0x58
  800c3d:	8b 45 08             	mov    0x8(%ebp),%eax
  800c40:	ff d0                	call   *%eax
  800c42:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800c45:	83 ec 08             	sub    $0x8,%esp
  800c48:	ff 75 0c             	pushl  0xc(%ebp)
  800c4b:	6a 58                	push   $0x58
  800c4d:	8b 45 08             	mov    0x8(%ebp),%eax
  800c50:	ff d0                	call   *%eax
  800c52:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800c55:	83 ec 08             	sub    $0x8,%esp
  800c58:	ff 75 0c             	pushl  0xc(%ebp)
  800c5b:	6a 58                	push   $0x58
  800c5d:	8b 45 08             	mov    0x8(%ebp),%eax
  800c60:	ff d0                	call   *%eax
  800c62:	83 c4 10             	add    $0x10,%esp
			break;
  800c65:	e9 ce 00 00 00       	jmp    800d38 <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  800c6a:	83 ec 08             	sub    $0x8,%esp
  800c6d:	ff 75 0c             	pushl  0xc(%ebp)
  800c70:	6a 30                	push   $0x30
  800c72:	8b 45 08             	mov    0x8(%ebp),%eax
  800c75:	ff d0                	call   *%eax
  800c77:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800c7a:	83 ec 08             	sub    $0x8,%esp
  800c7d:	ff 75 0c             	pushl  0xc(%ebp)
  800c80:	6a 78                	push   $0x78
  800c82:	8b 45 08             	mov    0x8(%ebp),%eax
  800c85:	ff d0                	call   *%eax
  800c87:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800c8a:	8b 45 14             	mov    0x14(%ebp),%eax
  800c8d:	83 c0 04             	add    $0x4,%eax
  800c90:	89 45 14             	mov    %eax,0x14(%ebp)
  800c93:	8b 45 14             	mov    0x14(%ebp),%eax
  800c96:	83 e8 04             	sub    $0x4,%eax
  800c99:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800c9b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c9e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800ca5:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800cac:	eb 1f                	jmp    800ccd <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800cae:	83 ec 08             	sub    $0x8,%esp
  800cb1:	ff 75 e8             	pushl  -0x18(%ebp)
  800cb4:	8d 45 14             	lea    0x14(%ebp),%eax
  800cb7:	50                   	push   %eax
  800cb8:	e8 e7 fb ff ff       	call   8008a4 <getuint>
  800cbd:	83 c4 10             	add    $0x10,%esp
  800cc0:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800cc3:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800cc6:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800ccd:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800cd1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800cd4:	83 ec 04             	sub    $0x4,%esp
  800cd7:	52                   	push   %edx
  800cd8:	ff 75 e4             	pushl  -0x1c(%ebp)
  800cdb:	50                   	push   %eax
  800cdc:	ff 75 f4             	pushl  -0xc(%ebp)
  800cdf:	ff 75 f0             	pushl  -0x10(%ebp)
  800ce2:	ff 75 0c             	pushl  0xc(%ebp)
  800ce5:	ff 75 08             	pushl  0x8(%ebp)
  800ce8:	e8 00 fb ff ff       	call   8007ed <printnum>
  800ced:	83 c4 20             	add    $0x20,%esp
			break;
  800cf0:	eb 46                	jmp    800d38 <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800cf2:	83 ec 08             	sub    $0x8,%esp
  800cf5:	ff 75 0c             	pushl  0xc(%ebp)
  800cf8:	53                   	push   %ebx
  800cf9:	8b 45 08             	mov    0x8(%ebp),%eax
  800cfc:	ff d0                	call   *%eax
  800cfe:	83 c4 10             	add    $0x10,%esp
			break;
  800d01:	eb 35                	jmp    800d38 <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  800d03:	c6 05 44 30 80 00 00 	movb   $0x0,0x803044
			break;
  800d0a:	eb 2c                	jmp    800d38 <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  800d0c:	c6 05 44 30 80 00 01 	movb   $0x1,0x803044
			break;
  800d13:	eb 23                	jmp    800d38 <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800d15:	83 ec 08             	sub    $0x8,%esp
  800d18:	ff 75 0c             	pushl  0xc(%ebp)
  800d1b:	6a 25                	push   $0x25
  800d1d:	8b 45 08             	mov    0x8(%ebp),%eax
  800d20:	ff d0                	call   *%eax
  800d22:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800d25:	ff 4d 10             	decl   0x10(%ebp)
  800d28:	eb 03                	jmp    800d2d <vprintfmt+0x3c3>
  800d2a:	ff 4d 10             	decl   0x10(%ebp)
  800d2d:	8b 45 10             	mov    0x10(%ebp),%eax
  800d30:	48                   	dec    %eax
  800d31:	8a 00                	mov    (%eax),%al
  800d33:	3c 25                	cmp    $0x25,%al
  800d35:	75 f3                	jne    800d2a <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  800d37:	90                   	nop
		}
	}
  800d38:	e9 35 fc ff ff       	jmp    800972 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800d3d:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800d3e:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800d41:	5b                   	pop    %ebx
  800d42:	5e                   	pop    %esi
  800d43:	5d                   	pop    %ebp
  800d44:	c3                   	ret    

00800d45 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800d45:	55                   	push   %ebp
  800d46:	89 e5                	mov    %esp,%ebp
  800d48:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800d4b:	8d 45 10             	lea    0x10(%ebp),%eax
  800d4e:	83 c0 04             	add    $0x4,%eax
  800d51:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800d54:	8b 45 10             	mov    0x10(%ebp),%eax
  800d57:	ff 75 f4             	pushl  -0xc(%ebp)
  800d5a:	50                   	push   %eax
  800d5b:	ff 75 0c             	pushl  0xc(%ebp)
  800d5e:	ff 75 08             	pushl  0x8(%ebp)
  800d61:	e8 04 fc ff ff       	call   80096a <vprintfmt>
  800d66:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800d69:	90                   	nop
  800d6a:	c9                   	leave  
  800d6b:	c3                   	ret    

00800d6c <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800d6c:	55                   	push   %ebp
  800d6d:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800d6f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d72:	8b 40 08             	mov    0x8(%eax),%eax
  800d75:	8d 50 01             	lea    0x1(%eax),%edx
  800d78:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d7b:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800d7e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d81:	8b 10                	mov    (%eax),%edx
  800d83:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d86:	8b 40 04             	mov    0x4(%eax),%eax
  800d89:	39 c2                	cmp    %eax,%edx
  800d8b:	73 12                	jae    800d9f <sprintputch+0x33>
		*b->buf++ = ch;
  800d8d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d90:	8b 00                	mov    (%eax),%eax
  800d92:	8d 48 01             	lea    0x1(%eax),%ecx
  800d95:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d98:	89 0a                	mov    %ecx,(%edx)
  800d9a:	8b 55 08             	mov    0x8(%ebp),%edx
  800d9d:	88 10                	mov    %dl,(%eax)
}
  800d9f:	90                   	nop
  800da0:	5d                   	pop    %ebp
  800da1:	c3                   	ret    

00800da2 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800da2:	55                   	push   %ebp
  800da3:	89 e5                	mov    %esp,%ebp
  800da5:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800da8:	8b 45 08             	mov    0x8(%ebp),%eax
  800dab:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800dae:	8b 45 0c             	mov    0xc(%ebp),%eax
  800db1:	8d 50 ff             	lea    -0x1(%eax),%edx
  800db4:	8b 45 08             	mov    0x8(%ebp),%eax
  800db7:	01 d0                	add    %edx,%eax
  800db9:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800dbc:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800dc3:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800dc7:	74 06                	je     800dcf <vsnprintf+0x2d>
  800dc9:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800dcd:	7f 07                	jg     800dd6 <vsnprintf+0x34>
		return -E_INVAL;
  800dcf:	b8 03 00 00 00       	mov    $0x3,%eax
  800dd4:	eb 20                	jmp    800df6 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800dd6:	ff 75 14             	pushl  0x14(%ebp)
  800dd9:	ff 75 10             	pushl  0x10(%ebp)
  800ddc:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800ddf:	50                   	push   %eax
  800de0:	68 6c 0d 80 00       	push   $0x800d6c
  800de5:	e8 80 fb ff ff       	call   80096a <vprintfmt>
  800dea:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800ded:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800df0:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800df3:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800df6:	c9                   	leave  
  800df7:	c3                   	ret    

00800df8 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800df8:	55                   	push   %ebp
  800df9:	89 e5                	mov    %esp,%ebp
  800dfb:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800dfe:	8d 45 10             	lea    0x10(%ebp),%eax
  800e01:	83 c0 04             	add    $0x4,%eax
  800e04:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800e07:	8b 45 10             	mov    0x10(%ebp),%eax
  800e0a:	ff 75 f4             	pushl  -0xc(%ebp)
  800e0d:	50                   	push   %eax
  800e0e:	ff 75 0c             	pushl  0xc(%ebp)
  800e11:	ff 75 08             	pushl  0x8(%ebp)
  800e14:	e8 89 ff ff ff       	call   800da2 <vsnprintf>
  800e19:	83 c4 10             	add    $0x10,%esp
  800e1c:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800e1f:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800e22:	c9                   	leave  
  800e23:	c3                   	ret    

00800e24 <readline>:
#include <inc/lib.h>

//static char buf[BUFLEN];

void readline(const char *prompt, char* buf)
{
  800e24:	55                   	push   %ebp
  800e25:	89 e5                	mov    %esp,%ebp
  800e27:	83 ec 18             	sub    $0x18,%esp
	int i, c, echoing;

	if (prompt != NULL)
  800e2a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800e2e:	74 13                	je     800e43 <readline+0x1f>
		cprintf("%s", prompt);
  800e30:	83 ec 08             	sub    $0x8,%esp
  800e33:	ff 75 08             	pushl  0x8(%ebp)
  800e36:	68 48 2a 80 00       	push   $0x802a48
  800e3b:	e8 0b f9 ff ff       	call   80074b <cprintf>
  800e40:	83 c4 10             	add    $0x10,%esp

	i = 0;
  800e43:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	echoing = iscons(0);
  800e4a:	83 ec 0c             	sub    $0xc,%esp
  800e4d:	6a 00                	push   $0x0
  800e4f:	e8 7e 10 00 00       	call   801ed2 <iscons>
  800e54:	83 c4 10             	add    $0x10,%esp
  800e57:	89 45 f0             	mov    %eax,-0x10(%ebp)
	while (1) {
		c = getchar();
  800e5a:	e8 60 10 00 00       	call   801ebf <getchar>
  800e5f:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if (c < 0) {
  800e62:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800e66:	79 22                	jns    800e8a <readline+0x66>
			if (c != -E_EOF)
  800e68:	83 7d ec 07          	cmpl   $0x7,-0x14(%ebp)
  800e6c:	0f 84 ad 00 00 00    	je     800f1f <readline+0xfb>
				cprintf("read error: %e\n", c);
  800e72:	83 ec 08             	sub    $0x8,%esp
  800e75:	ff 75 ec             	pushl  -0x14(%ebp)
  800e78:	68 4b 2a 80 00       	push   $0x802a4b
  800e7d:	e8 c9 f8 ff ff       	call   80074b <cprintf>
  800e82:	83 c4 10             	add    $0x10,%esp
			break;
  800e85:	e9 95 00 00 00       	jmp    800f1f <readline+0xfb>
		} else if (c >= ' ' && i < BUFLEN-1) {
  800e8a:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%ebp)
  800e8e:	7e 34                	jle    800ec4 <readline+0xa0>
  800e90:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  800e97:	7f 2b                	jg     800ec4 <readline+0xa0>
			if (echoing)
  800e99:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800e9d:	74 0e                	je     800ead <readline+0x89>
				cputchar(c);
  800e9f:	83 ec 0c             	sub    $0xc,%esp
  800ea2:	ff 75 ec             	pushl  -0x14(%ebp)
  800ea5:	e8 f6 0f 00 00       	call   801ea0 <cputchar>
  800eaa:	83 c4 10             	add    $0x10,%esp
			buf[i++] = c;
  800ead:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800eb0:	8d 50 01             	lea    0x1(%eax),%edx
  800eb3:	89 55 f4             	mov    %edx,-0xc(%ebp)
  800eb6:	89 c2                	mov    %eax,%edx
  800eb8:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ebb:	01 d0                	add    %edx,%eax
  800ebd:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800ec0:	88 10                	mov    %dl,(%eax)
  800ec2:	eb 56                	jmp    800f1a <readline+0xf6>
		} else if (c == '\b' && i > 0) {
  800ec4:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  800ec8:	75 1f                	jne    800ee9 <readline+0xc5>
  800eca:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  800ece:	7e 19                	jle    800ee9 <readline+0xc5>
			if (echoing)
  800ed0:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800ed4:	74 0e                	je     800ee4 <readline+0xc0>
				cputchar(c);
  800ed6:	83 ec 0c             	sub    $0xc,%esp
  800ed9:	ff 75 ec             	pushl  -0x14(%ebp)
  800edc:	e8 bf 0f 00 00       	call   801ea0 <cputchar>
  800ee1:	83 c4 10             	add    $0x10,%esp

			i--;
  800ee4:	ff 4d f4             	decl   -0xc(%ebp)
  800ee7:	eb 31                	jmp    800f1a <readline+0xf6>
		} else if (c == '\n' || c == '\r') {
  800ee9:	83 7d ec 0a          	cmpl   $0xa,-0x14(%ebp)
  800eed:	74 0a                	je     800ef9 <readline+0xd5>
  800eef:	83 7d ec 0d          	cmpl   $0xd,-0x14(%ebp)
  800ef3:	0f 85 61 ff ff ff    	jne    800e5a <readline+0x36>
			if (echoing)
  800ef9:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800efd:	74 0e                	je     800f0d <readline+0xe9>
				cputchar(c);
  800eff:	83 ec 0c             	sub    $0xc,%esp
  800f02:	ff 75 ec             	pushl  -0x14(%ebp)
  800f05:	e8 96 0f 00 00       	call   801ea0 <cputchar>
  800f0a:	83 c4 10             	add    $0x10,%esp

			buf[i] = 0;
  800f0d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800f10:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f13:	01 d0                	add    %edx,%eax
  800f15:	c6 00 00             	movb   $0x0,(%eax)
			break;
  800f18:	eb 06                	jmp    800f20 <readline+0xfc>
		}
	}
  800f1a:	e9 3b ff ff ff       	jmp    800e5a <readline+0x36>
	while (1) {
		c = getchar();
		if (c < 0) {
			if (c != -E_EOF)
				cprintf("read error: %e\n", c);
			break;
  800f1f:	90                   	nop

			buf[i] = 0;
			break;
		}
	}
}
  800f20:	90                   	nop
  800f21:	c9                   	leave  
  800f22:	c3                   	ret    

00800f23 <atomic_readline>:

void atomic_readline(const char *prompt, char* buf)
{
  800f23:	55                   	push   %ebp
  800f24:	89 e5                	mov    %esp,%ebp
  800f26:	83 ec 18             	sub    $0x18,%esp
	sys_lock_cons();
  800f29:	e8 79 09 00 00       	call   8018a7 <sys_lock_cons>
	{
		int i, c, echoing;

		if (prompt != NULL)
  800f2e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800f32:	74 13                	je     800f47 <atomic_readline+0x24>
			cprintf("%s", prompt);
  800f34:	83 ec 08             	sub    $0x8,%esp
  800f37:	ff 75 08             	pushl  0x8(%ebp)
  800f3a:	68 48 2a 80 00       	push   $0x802a48
  800f3f:	e8 07 f8 ff ff       	call   80074b <cprintf>
  800f44:	83 c4 10             	add    $0x10,%esp

		i = 0;
  800f47:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
		echoing = iscons(0);
  800f4e:	83 ec 0c             	sub    $0xc,%esp
  800f51:	6a 00                	push   $0x0
  800f53:	e8 7a 0f 00 00       	call   801ed2 <iscons>
  800f58:	83 c4 10             	add    $0x10,%esp
  800f5b:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (1) {
			c = getchar();
  800f5e:	e8 5c 0f 00 00       	call   801ebf <getchar>
  800f63:	89 45 ec             	mov    %eax,-0x14(%ebp)
			if (c < 0) {
  800f66:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800f6a:	79 22                	jns    800f8e <atomic_readline+0x6b>
				if (c != -E_EOF)
  800f6c:	83 7d ec 07          	cmpl   $0x7,-0x14(%ebp)
  800f70:	0f 84 ad 00 00 00    	je     801023 <atomic_readline+0x100>
					cprintf("read error: %e\n", c);
  800f76:	83 ec 08             	sub    $0x8,%esp
  800f79:	ff 75 ec             	pushl  -0x14(%ebp)
  800f7c:	68 4b 2a 80 00       	push   $0x802a4b
  800f81:	e8 c5 f7 ff ff       	call   80074b <cprintf>
  800f86:	83 c4 10             	add    $0x10,%esp
				break;
  800f89:	e9 95 00 00 00       	jmp    801023 <atomic_readline+0x100>
			} else if (c >= ' ' && i < BUFLEN-1) {
  800f8e:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%ebp)
  800f92:	7e 34                	jle    800fc8 <atomic_readline+0xa5>
  800f94:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  800f9b:	7f 2b                	jg     800fc8 <atomic_readline+0xa5>
				if (echoing)
  800f9d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800fa1:	74 0e                	je     800fb1 <atomic_readline+0x8e>
					cputchar(c);
  800fa3:	83 ec 0c             	sub    $0xc,%esp
  800fa6:	ff 75 ec             	pushl  -0x14(%ebp)
  800fa9:	e8 f2 0e 00 00       	call   801ea0 <cputchar>
  800fae:	83 c4 10             	add    $0x10,%esp
				buf[i++] = c;
  800fb1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800fb4:	8d 50 01             	lea    0x1(%eax),%edx
  800fb7:	89 55 f4             	mov    %edx,-0xc(%ebp)
  800fba:	89 c2                	mov    %eax,%edx
  800fbc:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fbf:	01 d0                	add    %edx,%eax
  800fc1:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800fc4:	88 10                	mov    %dl,(%eax)
  800fc6:	eb 56                	jmp    80101e <atomic_readline+0xfb>
			} else if (c == '\b' && i > 0) {
  800fc8:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  800fcc:	75 1f                	jne    800fed <atomic_readline+0xca>
  800fce:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  800fd2:	7e 19                	jle    800fed <atomic_readline+0xca>
				if (echoing)
  800fd4:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800fd8:	74 0e                	je     800fe8 <atomic_readline+0xc5>
					cputchar(c);
  800fda:	83 ec 0c             	sub    $0xc,%esp
  800fdd:	ff 75 ec             	pushl  -0x14(%ebp)
  800fe0:	e8 bb 0e 00 00       	call   801ea0 <cputchar>
  800fe5:	83 c4 10             	add    $0x10,%esp
				i--;
  800fe8:	ff 4d f4             	decl   -0xc(%ebp)
  800feb:	eb 31                	jmp    80101e <atomic_readline+0xfb>
			} else if (c == '\n' || c == '\r') {
  800fed:	83 7d ec 0a          	cmpl   $0xa,-0x14(%ebp)
  800ff1:	74 0a                	je     800ffd <atomic_readline+0xda>
  800ff3:	83 7d ec 0d          	cmpl   $0xd,-0x14(%ebp)
  800ff7:	0f 85 61 ff ff ff    	jne    800f5e <atomic_readline+0x3b>
				if (echoing)
  800ffd:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801001:	74 0e                	je     801011 <atomic_readline+0xee>
					cputchar(c);
  801003:	83 ec 0c             	sub    $0xc,%esp
  801006:	ff 75 ec             	pushl  -0x14(%ebp)
  801009:	e8 92 0e 00 00       	call   801ea0 <cputchar>
  80100e:	83 c4 10             	add    $0x10,%esp
				buf[i] = 0;
  801011:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801014:	8b 45 0c             	mov    0xc(%ebp),%eax
  801017:	01 d0                	add    %edx,%eax
  801019:	c6 00 00             	movb   $0x0,(%eax)
				break;
  80101c:	eb 06                	jmp    801024 <atomic_readline+0x101>
			}
		}
  80101e:	e9 3b ff ff ff       	jmp    800f5e <atomic_readline+0x3b>
		while (1) {
			c = getchar();
			if (c < 0) {
				if (c != -E_EOF)
					cprintf("read error: %e\n", c);
				break;
  801023:	90                   	nop
				buf[i] = 0;
				break;
			}
		}
	}
	sys_unlock_cons();
  801024:	e8 98 08 00 00       	call   8018c1 <sys_unlock_cons>
}
  801029:	90                   	nop
  80102a:	c9                   	leave  
  80102b:	c3                   	ret    

0080102c <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  80102c:	55                   	push   %ebp
  80102d:	89 e5                	mov    %esp,%ebp
  80102f:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  801032:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801039:	eb 06                	jmp    801041 <strlen+0x15>
		n++;
  80103b:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  80103e:	ff 45 08             	incl   0x8(%ebp)
  801041:	8b 45 08             	mov    0x8(%ebp),%eax
  801044:	8a 00                	mov    (%eax),%al
  801046:	84 c0                	test   %al,%al
  801048:	75 f1                	jne    80103b <strlen+0xf>
		n++;
	return n;
  80104a:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  80104d:	c9                   	leave  
  80104e:	c3                   	ret    

0080104f <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  80104f:	55                   	push   %ebp
  801050:	89 e5                	mov    %esp,%ebp
  801052:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801055:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80105c:	eb 09                	jmp    801067 <strnlen+0x18>
		n++;
  80105e:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801061:	ff 45 08             	incl   0x8(%ebp)
  801064:	ff 4d 0c             	decl   0xc(%ebp)
  801067:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80106b:	74 09                	je     801076 <strnlen+0x27>
  80106d:	8b 45 08             	mov    0x8(%ebp),%eax
  801070:	8a 00                	mov    (%eax),%al
  801072:	84 c0                	test   %al,%al
  801074:	75 e8                	jne    80105e <strnlen+0xf>
		n++;
	return n;
  801076:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801079:	c9                   	leave  
  80107a:	c3                   	ret    

0080107b <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  80107b:	55                   	push   %ebp
  80107c:	89 e5                	mov    %esp,%ebp
  80107e:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  801081:	8b 45 08             	mov    0x8(%ebp),%eax
  801084:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  801087:	90                   	nop
  801088:	8b 45 08             	mov    0x8(%ebp),%eax
  80108b:	8d 50 01             	lea    0x1(%eax),%edx
  80108e:	89 55 08             	mov    %edx,0x8(%ebp)
  801091:	8b 55 0c             	mov    0xc(%ebp),%edx
  801094:	8d 4a 01             	lea    0x1(%edx),%ecx
  801097:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  80109a:	8a 12                	mov    (%edx),%dl
  80109c:	88 10                	mov    %dl,(%eax)
  80109e:	8a 00                	mov    (%eax),%al
  8010a0:	84 c0                	test   %al,%al
  8010a2:	75 e4                	jne    801088 <strcpy+0xd>
		/* do nothing */;
	return ret;
  8010a4:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8010a7:	c9                   	leave  
  8010a8:	c3                   	ret    

008010a9 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  8010a9:	55                   	push   %ebp
  8010aa:	89 e5                	mov    %esp,%ebp
  8010ac:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  8010af:	8b 45 08             	mov    0x8(%ebp),%eax
  8010b2:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  8010b5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8010bc:	eb 1f                	jmp    8010dd <strncpy+0x34>
		*dst++ = *src;
  8010be:	8b 45 08             	mov    0x8(%ebp),%eax
  8010c1:	8d 50 01             	lea    0x1(%eax),%edx
  8010c4:	89 55 08             	mov    %edx,0x8(%ebp)
  8010c7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8010ca:	8a 12                	mov    (%edx),%dl
  8010cc:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  8010ce:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010d1:	8a 00                	mov    (%eax),%al
  8010d3:	84 c0                	test   %al,%al
  8010d5:	74 03                	je     8010da <strncpy+0x31>
			src++;
  8010d7:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8010da:	ff 45 fc             	incl   -0x4(%ebp)
  8010dd:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8010e0:	3b 45 10             	cmp    0x10(%ebp),%eax
  8010e3:	72 d9                	jb     8010be <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  8010e5:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8010e8:	c9                   	leave  
  8010e9:	c3                   	ret    

008010ea <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  8010ea:	55                   	push   %ebp
  8010eb:	89 e5                	mov    %esp,%ebp
  8010ed:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  8010f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8010f3:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  8010f6:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8010fa:	74 30                	je     80112c <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  8010fc:	eb 16                	jmp    801114 <strlcpy+0x2a>
			*dst++ = *src++;
  8010fe:	8b 45 08             	mov    0x8(%ebp),%eax
  801101:	8d 50 01             	lea    0x1(%eax),%edx
  801104:	89 55 08             	mov    %edx,0x8(%ebp)
  801107:	8b 55 0c             	mov    0xc(%ebp),%edx
  80110a:	8d 4a 01             	lea    0x1(%edx),%ecx
  80110d:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  801110:	8a 12                	mov    (%edx),%dl
  801112:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  801114:	ff 4d 10             	decl   0x10(%ebp)
  801117:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80111b:	74 09                	je     801126 <strlcpy+0x3c>
  80111d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801120:	8a 00                	mov    (%eax),%al
  801122:	84 c0                	test   %al,%al
  801124:	75 d8                	jne    8010fe <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  801126:	8b 45 08             	mov    0x8(%ebp),%eax
  801129:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  80112c:	8b 55 08             	mov    0x8(%ebp),%edx
  80112f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801132:	29 c2                	sub    %eax,%edx
  801134:	89 d0                	mov    %edx,%eax
}
  801136:	c9                   	leave  
  801137:	c3                   	ret    

00801138 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  801138:	55                   	push   %ebp
  801139:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  80113b:	eb 06                	jmp    801143 <strcmp+0xb>
		p++, q++;
  80113d:	ff 45 08             	incl   0x8(%ebp)
  801140:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  801143:	8b 45 08             	mov    0x8(%ebp),%eax
  801146:	8a 00                	mov    (%eax),%al
  801148:	84 c0                	test   %al,%al
  80114a:	74 0e                	je     80115a <strcmp+0x22>
  80114c:	8b 45 08             	mov    0x8(%ebp),%eax
  80114f:	8a 10                	mov    (%eax),%dl
  801151:	8b 45 0c             	mov    0xc(%ebp),%eax
  801154:	8a 00                	mov    (%eax),%al
  801156:	38 c2                	cmp    %al,%dl
  801158:	74 e3                	je     80113d <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  80115a:	8b 45 08             	mov    0x8(%ebp),%eax
  80115d:	8a 00                	mov    (%eax),%al
  80115f:	0f b6 d0             	movzbl %al,%edx
  801162:	8b 45 0c             	mov    0xc(%ebp),%eax
  801165:	8a 00                	mov    (%eax),%al
  801167:	0f b6 c0             	movzbl %al,%eax
  80116a:	29 c2                	sub    %eax,%edx
  80116c:	89 d0                	mov    %edx,%eax
}
  80116e:	5d                   	pop    %ebp
  80116f:	c3                   	ret    

00801170 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  801170:	55                   	push   %ebp
  801171:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  801173:	eb 09                	jmp    80117e <strncmp+0xe>
		n--, p++, q++;
  801175:	ff 4d 10             	decl   0x10(%ebp)
  801178:	ff 45 08             	incl   0x8(%ebp)
  80117b:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  80117e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801182:	74 17                	je     80119b <strncmp+0x2b>
  801184:	8b 45 08             	mov    0x8(%ebp),%eax
  801187:	8a 00                	mov    (%eax),%al
  801189:	84 c0                	test   %al,%al
  80118b:	74 0e                	je     80119b <strncmp+0x2b>
  80118d:	8b 45 08             	mov    0x8(%ebp),%eax
  801190:	8a 10                	mov    (%eax),%dl
  801192:	8b 45 0c             	mov    0xc(%ebp),%eax
  801195:	8a 00                	mov    (%eax),%al
  801197:	38 c2                	cmp    %al,%dl
  801199:	74 da                	je     801175 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  80119b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80119f:	75 07                	jne    8011a8 <strncmp+0x38>
		return 0;
  8011a1:	b8 00 00 00 00       	mov    $0x0,%eax
  8011a6:	eb 14                	jmp    8011bc <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8011a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8011ab:	8a 00                	mov    (%eax),%al
  8011ad:	0f b6 d0             	movzbl %al,%edx
  8011b0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011b3:	8a 00                	mov    (%eax),%al
  8011b5:	0f b6 c0             	movzbl %al,%eax
  8011b8:	29 c2                	sub    %eax,%edx
  8011ba:	89 d0                	mov    %edx,%eax
}
  8011bc:	5d                   	pop    %ebp
  8011bd:	c3                   	ret    

008011be <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8011be:	55                   	push   %ebp
  8011bf:	89 e5                	mov    %esp,%ebp
  8011c1:	83 ec 04             	sub    $0x4,%esp
  8011c4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011c7:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  8011ca:	eb 12                	jmp    8011de <strchr+0x20>
		if (*s == c)
  8011cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8011cf:	8a 00                	mov    (%eax),%al
  8011d1:	3a 45 fc             	cmp    -0x4(%ebp),%al
  8011d4:	75 05                	jne    8011db <strchr+0x1d>
			return (char *) s;
  8011d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8011d9:	eb 11                	jmp    8011ec <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  8011db:	ff 45 08             	incl   0x8(%ebp)
  8011de:	8b 45 08             	mov    0x8(%ebp),%eax
  8011e1:	8a 00                	mov    (%eax),%al
  8011e3:	84 c0                	test   %al,%al
  8011e5:	75 e5                	jne    8011cc <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  8011e7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8011ec:	c9                   	leave  
  8011ed:	c3                   	ret    

008011ee <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8011ee:	55                   	push   %ebp
  8011ef:	89 e5                	mov    %esp,%ebp
  8011f1:	83 ec 04             	sub    $0x4,%esp
  8011f4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011f7:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  8011fa:	eb 0d                	jmp    801209 <strfind+0x1b>
		if (*s == c)
  8011fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8011ff:	8a 00                	mov    (%eax),%al
  801201:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801204:	74 0e                	je     801214 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  801206:	ff 45 08             	incl   0x8(%ebp)
  801209:	8b 45 08             	mov    0x8(%ebp),%eax
  80120c:	8a 00                	mov    (%eax),%al
  80120e:	84 c0                	test   %al,%al
  801210:	75 ea                	jne    8011fc <strfind+0xe>
  801212:	eb 01                	jmp    801215 <strfind+0x27>
		if (*s == c)
			break;
  801214:	90                   	nop
	return (char *) s;
  801215:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801218:	c9                   	leave  
  801219:	c3                   	ret    

0080121a <memset>:

// *************** The faster implementation of memset & memcpy is implemented by *************
// ****************** Team80 (Yahia Khaled, Malek Ahmed et al) - FCIS'24-25 *******************
void *
memset(void *v, int c, uint32 n)
{
  80121a:	55                   	push   %ebp
  80121b:	89 e5                	mov    %esp,%ebp
  80121d:	83 ec 10             	sub    $0x10,%esp
//	m = n;
//	while (--m >= 0)
//		*p++ = c;

	/*Faster Implementation*/
	uint64* p64 = (uint64*)v;
  801220:	8b 45 08             	mov    0x8(%ebp),%eax
  801223:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if(n >= 8){
  801226:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  80122a:	76 63                	jbe    80128f <memset+0x75>
		uint64 data_block = c;
  80122c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80122f:	99                   	cltd   
  801230:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801233:	89 55 f4             	mov    %edx,-0xc(%ebp)
		data_block |= data_block << 8;
  801236:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801239:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80123c:	0f a4 c2 08          	shld   $0x8,%eax,%edx
  801240:	c1 e0 08             	shl    $0x8,%eax
  801243:	09 45 f0             	or     %eax,-0x10(%ebp)
  801246:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 16;
  801249:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80124c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80124f:	0f a4 c2 10          	shld   $0x10,%eax,%edx
  801253:	c1 e0 10             	shl    $0x10,%eax
  801256:	09 45 f0             	or     %eax,-0x10(%ebp)
  801259:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 32;
  80125c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80125f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801262:	89 c2                	mov    %eax,%edx
  801264:	b8 00 00 00 00       	mov    $0x0,%eax
  801269:	09 45 f0             	or     %eax,-0x10(%ebp)
  80126c:	09 55 f4             	or     %edx,-0xc(%ebp)

		while(n >= 8)
  80126f:	eb 18                	jmp    801289 <memset+0x6f>
			*p64++ = data_block, n -= 8;
  801271:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801274:	8d 41 08             	lea    0x8(%ecx),%eax
  801277:	89 45 fc             	mov    %eax,-0x4(%ebp)
  80127a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80127d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801280:	89 01                	mov    %eax,(%ecx)
  801282:	89 51 04             	mov    %edx,0x4(%ecx)
  801285:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
		uint64 data_block = c;
		data_block |= data_block << 8;
		data_block |= data_block << 16;
		data_block |= data_block << 32;

		while(n >= 8)
  801289:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  80128d:	77 e2                	ja     801271 <memset+0x57>
			*p64++ = data_block, n -= 8;
	}

	if(n){
  80128f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801293:	74 23                	je     8012b8 <memset+0x9e>
		uint8* p8 = (uint8*)p64;
  801295:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801298:	89 45 f8             	mov    %eax,-0x8(%ebp)
		while (n-- > 0)
  80129b:	eb 0e                	jmp    8012ab <memset+0x91>
			*p8++ = (uint8)c;
  80129d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8012a0:	8d 50 01             	lea    0x1(%eax),%edx
  8012a3:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8012a6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8012a9:	88 10                	mov    %dl,(%eax)
			*p64++ = data_block, n -= 8;
	}

	if(n){
		uint8* p8 = (uint8*)p64;
		while (n-- > 0)
  8012ab:	8b 45 10             	mov    0x10(%ebp),%eax
  8012ae:	8d 50 ff             	lea    -0x1(%eax),%edx
  8012b1:	89 55 10             	mov    %edx,0x10(%ebp)
  8012b4:	85 c0                	test   %eax,%eax
  8012b6:	75 e5                	jne    80129d <memset+0x83>
			*p8++ = (uint8)c;
	}

	return v;
  8012b8:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8012bb:	c9                   	leave  
  8012bc:	c3                   	ret    

008012bd <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  8012bd:	55                   	push   %ebp
  8012be:	89 e5                	mov    %esp,%ebp
  8012c0:	83 ec 10             	sub    $0x10,%esp
	//	s = src;
	//	d = dst;
	//	while (n-- > 0)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
  8012c3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012c6:	89 45 fc             	mov    %eax,-0x4(%ebp)
	uint64* d64 = (uint64*)dst;
  8012c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8012cc:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if(n >= 8){
  8012cf:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  8012d3:	76 24                	jbe    8012f9 <memcpy+0x3c>
		while(n >= 8){
  8012d5:	eb 1c                	jmp    8012f3 <memcpy+0x36>
			*d64 = *s64;
  8012d7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8012da:	8b 50 04             	mov    0x4(%eax),%edx
  8012dd:	8b 00                	mov    (%eax),%eax
  8012df:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8012e2:	89 01                	mov    %eax,(%ecx)
  8012e4:	89 51 04             	mov    %edx,0x4(%ecx)
			n -= 8;
  8012e7:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
			++s64;
  8012eb:	83 45 fc 08          	addl   $0x8,-0x4(%ebp)
			++d64;
  8012ef:	83 45 f8 08          	addl   $0x8,-0x8(%ebp)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
	uint64* d64 = (uint64*)dst;
	if(n >= 8){
		while(n >= 8){
  8012f3:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  8012f7:	77 de                	ja     8012d7 <memcpy+0x1a>
			++s64;
			++d64;
		}
	}

	if(n){
  8012f9:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8012fd:	74 31                	je     801330 <memcpy+0x73>
		uint8* s8 = (uint8*)s64;
  8012ff:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801302:	89 45 f4             	mov    %eax,-0xc(%ebp)
		uint8* d8 = (uint8*)d64;
  801305:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801308:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (n-- > 0)
  80130b:	eb 16                	jmp    801323 <memcpy+0x66>
			*d8++ = *s8++;
  80130d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801310:	8d 50 01             	lea    0x1(%eax),%edx
  801313:	89 55 f0             	mov    %edx,-0x10(%ebp)
  801316:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801319:	8d 4a 01             	lea    0x1(%edx),%ecx
  80131c:	89 4d f4             	mov    %ecx,-0xc(%ebp)
  80131f:	8a 12                	mov    (%edx),%dl
  801321:	88 10                	mov    %dl,(%eax)
	}

	if(n){
		uint8* s8 = (uint8*)s64;
		uint8* d8 = (uint8*)d64;
		while (n-- > 0)
  801323:	8b 45 10             	mov    0x10(%ebp),%eax
  801326:	8d 50 ff             	lea    -0x1(%eax),%edx
  801329:	89 55 10             	mov    %edx,0x10(%ebp)
  80132c:	85 c0                	test   %eax,%eax
  80132e:	75 dd                	jne    80130d <memcpy+0x50>
			*d8++ = *s8++;
	}
	return dst;
  801330:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801333:	c9                   	leave  
  801334:	c3                   	ret    

00801335 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  801335:	55                   	push   %ebp
  801336:	89 e5                	mov    %esp,%ebp
  801338:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  80133b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80133e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801341:	8b 45 08             	mov    0x8(%ebp),%eax
  801344:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  801347:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80134a:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  80134d:	73 50                	jae    80139f <memmove+0x6a>
  80134f:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801352:	8b 45 10             	mov    0x10(%ebp),%eax
  801355:	01 d0                	add    %edx,%eax
  801357:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  80135a:	76 43                	jbe    80139f <memmove+0x6a>
		s += n;
  80135c:	8b 45 10             	mov    0x10(%ebp),%eax
  80135f:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  801362:	8b 45 10             	mov    0x10(%ebp),%eax
  801365:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  801368:	eb 10                	jmp    80137a <memmove+0x45>
			*--d = *--s;
  80136a:	ff 4d f8             	decl   -0x8(%ebp)
  80136d:	ff 4d fc             	decl   -0x4(%ebp)
  801370:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801373:	8a 10                	mov    (%eax),%dl
  801375:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801378:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  80137a:	8b 45 10             	mov    0x10(%ebp),%eax
  80137d:	8d 50 ff             	lea    -0x1(%eax),%edx
  801380:	89 55 10             	mov    %edx,0x10(%ebp)
  801383:	85 c0                	test   %eax,%eax
  801385:	75 e3                	jne    80136a <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  801387:	eb 23                	jmp    8013ac <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  801389:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80138c:	8d 50 01             	lea    0x1(%eax),%edx
  80138f:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801392:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801395:	8d 4a 01             	lea    0x1(%edx),%ecx
  801398:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  80139b:	8a 12                	mov    (%edx),%dl
  80139d:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  80139f:	8b 45 10             	mov    0x10(%ebp),%eax
  8013a2:	8d 50 ff             	lea    -0x1(%eax),%edx
  8013a5:	89 55 10             	mov    %edx,0x10(%ebp)
  8013a8:	85 c0                	test   %eax,%eax
  8013aa:	75 dd                	jne    801389 <memmove+0x54>
			*d++ = *s++;

	return dst;
  8013ac:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8013af:	c9                   	leave  
  8013b0:	c3                   	ret    

008013b1 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  8013b1:	55                   	push   %ebp
  8013b2:	89 e5                	mov    %esp,%ebp
  8013b4:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  8013b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8013ba:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  8013bd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013c0:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  8013c3:	eb 2a                	jmp    8013ef <memcmp+0x3e>
		if (*s1 != *s2)
  8013c5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8013c8:	8a 10                	mov    (%eax),%dl
  8013ca:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8013cd:	8a 00                	mov    (%eax),%al
  8013cf:	38 c2                	cmp    %al,%dl
  8013d1:	74 16                	je     8013e9 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  8013d3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8013d6:	8a 00                	mov    (%eax),%al
  8013d8:	0f b6 d0             	movzbl %al,%edx
  8013db:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8013de:	8a 00                	mov    (%eax),%al
  8013e0:	0f b6 c0             	movzbl %al,%eax
  8013e3:	29 c2                	sub    %eax,%edx
  8013e5:	89 d0                	mov    %edx,%eax
  8013e7:	eb 18                	jmp    801401 <memcmp+0x50>
		s1++, s2++;
  8013e9:	ff 45 fc             	incl   -0x4(%ebp)
  8013ec:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  8013ef:	8b 45 10             	mov    0x10(%ebp),%eax
  8013f2:	8d 50 ff             	lea    -0x1(%eax),%edx
  8013f5:	89 55 10             	mov    %edx,0x10(%ebp)
  8013f8:	85 c0                	test   %eax,%eax
  8013fa:	75 c9                	jne    8013c5 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  8013fc:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801401:	c9                   	leave  
  801402:	c3                   	ret    

00801403 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  801403:	55                   	push   %ebp
  801404:	89 e5                	mov    %esp,%ebp
  801406:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  801409:	8b 55 08             	mov    0x8(%ebp),%edx
  80140c:	8b 45 10             	mov    0x10(%ebp),%eax
  80140f:	01 d0                	add    %edx,%eax
  801411:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  801414:	eb 15                	jmp    80142b <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  801416:	8b 45 08             	mov    0x8(%ebp),%eax
  801419:	8a 00                	mov    (%eax),%al
  80141b:	0f b6 d0             	movzbl %al,%edx
  80141e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801421:	0f b6 c0             	movzbl %al,%eax
  801424:	39 c2                	cmp    %eax,%edx
  801426:	74 0d                	je     801435 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801428:	ff 45 08             	incl   0x8(%ebp)
  80142b:	8b 45 08             	mov    0x8(%ebp),%eax
  80142e:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801431:	72 e3                	jb     801416 <memfind+0x13>
  801433:	eb 01                	jmp    801436 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  801435:	90                   	nop
	return (void *) s;
  801436:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801439:	c9                   	leave  
  80143a:	c3                   	ret    

0080143b <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  80143b:	55                   	push   %ebp
  80143c:	89 e5                	mov    %esp,%ebp
  80143e:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  801441:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  801448:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80144f:	eb 03                	jmp    801454 <strtol+0x19>
		s++;
  801451:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801454:	8b 45 08             	mov    0x8(%ebp),%eax
  801457:	8a 00                	mov    (%eax),%al
  801459:	3c 20                	cmp    $0x20,%al
  80145b:	74 f4                	je     801451 <strtol+0x16>
  80145d:	8b 45 08             	mov    0x8(%ebp),%eax
  801460:	8a 00                	mov    (%eax),%al
  801462:	3c 09                	cmp    $0x9,%al
  801464:	74 eb                	je     801451 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  801466:	8b 45 08             	mov    0x8(%ebp),%eax
  801469:	8a 00                	mov    (%eax),%al
  80146b:	3c 2b                	cmp    $0x2b,%al
  80146d:	75 05                	jne    801474 <strtol+0x39>
		s++;
  80146f:	ff 45 08             	incl   0x8(%ebp)
  801472:	eb 13                	jmp    801487 <strtol+0x4c>
	else if (*s == '-')
  801474:	8b 45 08             	mov    0x8(%ebp),%eax
  801477:	8a 00                	mov    (%eax),%al
  801479:	3c 2d                	cmp    $0x2d,%al
  80147b:	75 0a                	jne    801487 <strtol+0x4c>
		s++, neg = 1;
  80147d:	ff 45 08             	incl   0x8(%ebp)
  801480:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801487:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80148b:	74 06                	je     801493 <strtol+0x58>
  80148d:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  801491:	75 20                	jne    8014b3 <strtol+0x78>
  801493:	8b 45 08             	mov    0x8(%ebp),%eax
  801496:	8a 00                	mov    (%eax),%al
  801498:	3c 30                	cmp    $0x30,%al
  80149a:	75 17                	jne    8014b3 <strtol+0x78>
  80149c:	8b 45 08             	mov    0x8(%ebp),%eax
  80149f:	40                   	inc    %eax
  8014a0:	8a 00                	mov    (%eax),%al
  8014a2:	3c 78                	cmp    $0x78,%al
  8014a4:	75 0d                	jne    8014b3 <strtol+0x78>
		s += 2, base = 16;
  8014a6:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  8014aa:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  8014b1:	eb 28                	jmp    8014db <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  8014b3:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8014b7:	75 15                	jne    8014ce <strtol+0x93>
  8014b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8014bc:	8a 00                	mov    (%eax),%al
  8014be:	3c 30                	cmp    $0x30,%al
  8014c0:	75 0c                	jne    8014ce <strtol+0x93>
		s++, base = 8;
  8014c2:	ff 45 08             	incl   0x8(%ebp)
  8014c5:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  8014cc:	eb 0d                	jmp    8014db <strtol+0xa0>
	else if (base == 0)
  8014ce:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8014d2:	75 07                	jne    8014db <strtol+0xa0>
		base = 10;
  8014d4:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8014db:	8b 45 08             	mov    0x8(%ebp),%eax
  8014de:	8a 00                	mov    (%eax),%al
  8014e0:	3c 2f                	cmp    $0x2f,%al
  8014e2:	7e 19                	jle    8014fd <strtol+0xc2>
  8014e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8014e7:	8a 00                	mov    (%eax),%al
  8014e9:	3c 39                	cmp    $0x39,%al
  8014eb:	7f 10                	jg     8014fd <strtol+0xc2>
			dig = *s - '0';
  8014ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8014f0:	8a 00                	mov    (%eax),%al
  8014f2:	0f be c0             	movsbl %al,%eax
  8014f5:	83 e8 30             	sub    $0x30,%eax
  8014f8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8014fb:	eb 42                	jmp    80153f <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  8014fd:	8b 45 08             	mov    0x8(%ebp),%eax
  801500:	8a 00                	mov    (%eax),%al
  801502:	3c 60                	cmp    $0x60,%al
  801504:	7e 19                	jle    80151f <strtol+0xe4>
  801506:	8b 45 08             	mov    0x8(%ebp),%eax
  801509:	8a 00                	mov    (%eax),%al
  80150b:	3c 7a                	cmp    $0x7a,%al
  80150d:	7f 10                	jg     80151f <strtol+0xe4>
			dig = *s - 'a' + 10;
  80150f:	8b 45 08             	mov    0x8(%ebp),%eax
  801512:	8a 00                	mov    (%eax),%al
  801514:	0f be c0             	movsbl %al,%eax
  801517:	83 e8 57             	sub    $0x57,%eax
  80151a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80151d:	eb 20                	jmp    80153f <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  80151f:	8b 45 08             	mov    0x8(%ebp),%eax
  801522:	8a 00                	mov    (%eax),%al
  801524:	3c 40                	cmp    $0x40,%al
  801526:	7e 39                	jle    801561 <strtol+0x126>
  801528:	8b 45 08             	mov    0x8(%ebp),%eax
  80152b:	8a 00                	mov    (%eax),%al
  80152d:	3c 5a                	cmp    $0x5a,%al
  80152f:	7f 30                	jg     801561 <strtol+0x126>
			dig = *s - 'A' + 10;
  801531:	8b 45 08             	mov    0x8(%ebp),%eax
  801534:	8a 00                	mov    (%eax),%al
  801536:	0f be c0             	movsbl %al,%eax
  801539:	83 e8 37             	sub    $0x37,%eax
  80153c:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  80153f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801542:	3b 45 10             	cmp    0x10(%ebp),%eax
  801545:	7d 19                	jge    801560 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801547:	ff 45 08             	incl   0x8(%ebp)
  80154a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80154d:	0f af 45 10          	imul   0x10(%ebp),%eax
  801551:	89 c2                	mov    %eax,%edx
  801553:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801556:	01 d0                	add    %edx,%eax
  801558:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  80155b:	e9 7b ff ff ff       	jmp    8014db <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801560:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801561:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801565:	74 08                	je     80156f <strtol+0x134>
		*endptr = (char *) s;
  801567:	8b 45 0c             	mov    0xc(%ebp),%eax
  80156a:	8b 55 08             	mov    0x8(%ebp),%edx
  80156d:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  80156f:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801573:	74 07                	je     80157c <strtol+0x141>
  801575:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801578:	f7 d8                	neg    %eax
  80157a:	eb 03                	jmp    80157f <strtol+0x144>
  80157c:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  80157f:	c9                   	leave  
  801580:	c3                   	ret    

00801581 <ltostr>:

void
ltostr(long value, char *str)
{
  801581:	55                   	push   %ebp
  801582:	89 e5                	mov    %esp,%ebp
  801584:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  801587:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  80158e:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  801595:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801599:	79 13                	jns    8015ae <ltostr+0x2d>
	{
		neg = 1;
  80159b:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  8015a2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015a5:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  8015a8:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  8015ab:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  8015ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8015b1:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8015b6:	99                   	cltd   
  8015b7:	f7 f9                	idiv   %ecx
  8015b9:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  8015bc:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8015bf:	8d 50 01             	lea    0x1(%eax),%edx
  8015c2:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8015c5:	89 c2                	mov    %eax,%edx
  8015c7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015ca:	01 d0                	add    %edx,%eax
  8015cc:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8015cf:	83 c2 30             	add    $0x30,%edx
  8015d2:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  8015d4:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8015d7:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8015dc:	f7 e9                	imul   %ecx
  8015de:	c1 fa 02             	sar    $0x2,%edx
  8015e1:	89 c8                	mov    %ecx,%eax
  8015e3:	c1 f8 1f             	sar    $0x1f,%eax
  8015e6:	29 c2                	sub    %eax,%edx
  8015e8:	89 d0                	mov    %edx,%eax
  8015ea:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  8015ed:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8015f1:	75 bb                	jne    8015ae <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  8015f3:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  8015fa:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8015fd:	48                   	dec    %eax
  8015fe:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801601:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801605:	74 3d                	je     801644 <ltostr+0xc3>
		start = 1 ;
  801607:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  80160e:	eb 34                	jmp    801644 <ltostr+0xc3>
	{
		char tmp = str[start] ;
  801610:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801613:	8b 45 0c             	mov    0xc(%ebp),%eax
  801616:	01 d0                	add    %edx,%eax
  801618:	8a 00                	mov    (%eax),%al
  80161a:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  80161d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801620:	8b 45 0c             	mov    0xc(%ebp),%eax
  801623:	01 c2                	add    %eax,%edx
  801625:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801628:	8b 45 0c             	mov    0xc(%ebp),%eax
  80162b:	01 c8                	add    %ecx,%eax
  80162d:	8a 00                	mov    (%eax),%al
  80162f:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801631:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801634:	8b 45 0c             	mov    0xc(%ebp),%eax
  801637:	01 c2                	add    %eax,%edx
  801639:	8a 45 eb             	mov    -0x15(%ebp),%al
  80163c:	88 02                	mov    %al,(%edx)
		start++ ;
  80163e:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801641:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801644:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801647:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80164a:	7c c4                	jl     801610 <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  80164c:	8b 55 f8             	mov    -0x8(%ebp),%edx
  80164f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801652:	01 d0                	add    %edx,%eax
  801654:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801657:	90                   	nop
  801658:	c9                   	leave  
  801659:	c3                   	ret    

0080165a <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  80165a:	55                   	push   %ebp
  80165b:	89 e5                	mov    %esp,%ebp
  80165d:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801660:	ff 75 08             	pushl  0x8(%ebp)
  801663:	e8 c4 f9 ff ff       	call   80102c <strlen>
  801668:	83 c4 04             	add    $0x4,%esp
  80166b:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  80166e:	ff 75 0c             	pushl  0xc(%ebp)
  801671:	e8 b6 f9 ff ff       	call   80102c <strlen>
  801676:	83 c4 04             	add    $0x4,%esp
  801679:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  80167c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  801683:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80168a:	eb 17                	jmp    8016a3 <strcconcat+0x49>
		final[s] = str1[s] ;
  80168c:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80168f:	8b 45 10             	mov    0x10(%ebp),%eax
  801692:	01 c2                	add    %eax,%edx
  801694:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801697:	8b 45 08             	mov    0x8(%ebp),%eax
  80169a:	01 c8                	add    %ecx,%eax
  80169c:	8a 00                	mov    (%eax),%al
  80169e:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  8016a0:	ff 45 fc             	incl   -0x4(%ebp)
  8016a3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8016a6:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8016a9:	7c e1                	jl     80168c <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  8016ab:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  8016b2:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8016b9:	eb 1f                	jmp    8016da <strcconcat+0x80>
		final[s++] = str2[i] ;
  8016bb:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8016be:	8d 50 01             	lea    0x1(%eax),%edx
  8016c1:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8016c4:	89 c2                	mov    %eax,%edx
  8016c6:	8b 45 10             	mov    0x10(%ebp),%eax
  8016c9:	01 c2                	add    %eax,%edx
  8016cb:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8016ce:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016d1:	01 c8                	add    %ecx,%eax
  8016d3:	8a 00                	mov    (%eax),%al
  8016d5:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  8016d7:	ff 45 f8             	incl   -0x8(%ebp)
  8016da:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8016dd:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8016e0:	7c d9                	jl     8016bb <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  8016e2:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8016e5:	8b 45 10             	mov    0x10(%ebp),%eax
  8016e8:	01 d0                	add    %edx,%eax
  8016ea:	c6 00 00             	movb   $0x0,(%eax)
}
  8016ed:	90                   	nop
  8016ee:	c9                   	leave  
  8016ef:	c3                   	ret    

008016f0 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  8016f0:	55                   	push   %ebp
  8016f1:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  8016f3:	8b 45 14             	mov    0x14(%ebp),%eax
  8016f6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  8016fc:	8b 45 14             	mov    0x14(%ebp),%eax
  8016ff:	8b 00                	mov    (%eax),%eax
  801701:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801708:	8b 45 10             	mov    0x10(%ebp),%eax
  80170b:	01 d0                	add    %edx,%eax
  80170d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801713:	eb 0c                	jmp    801721 <strsplit+0x31>
			*string++ = 0;
  801715:	8b 45 08             	mov    0x8(%ebp),%eax
  801718:	8d 50 01             	lea    0x1(%eax),%edx
  80171b:	89 55 08             	mov    %edx,0x8(%ebp)
  80171e:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801721:	8b 45 08             	mov    0x8(%ebp),%eax
  801724:	8a 00                	mov    (%eax),%al
  801726:	84 c0                	test   %al,%al
  801728:	74 18                	je     801742 <strsplit+0x52>
  80172a:	8b 45 08             	mov    0x8(%ebp),%eax
  80172d:	8a 00                	mov    (%eax),%al
  80172f:	0f be c0             	movsbl %al,%eax
  801732:	50                   	push   %eax
  801733:	ff 75 0c             	pushl  0xc(%ebp)
  801736:	e8 83 fa ff ff       	call   8011be <strchr>
  80173b:	83 c4 08             	add    $0x8,%esp
  80173e:	85 c0                	test   %eax,%eax
  801740:	75 d3                	jne    801715 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801742:	8b 45 08             	mov    0x8(%ebp),%eax
  801745:	8a 00                	mov    (%eax),%al
  801747:	84 c0                	test   %al,%al
  801749:	74 5a                	je     8017a5 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  80174b:	8b 45 14             	mov    0x14(%ebp),%eax
  80174e:	8b 00                	mov    (%eax),%eax
  801750:	83 f8 0f             	cmp    $0xf,%eax
  801753:	75 07                	jne    80175c <strsplit+0x6c>
		{
			return 0;
  801755:	b8 00 00 00 00       	mov    $0x0,%eax
  80175a:	eb 66                	jmp    8017c2 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  80175c:	8b 45 14             	mov    0x14(%ebp),%eax
  80175f:	8b 00                	mov    (%eax),%eax
  801761:	8d 48 01             	lea    0x1(%eax),%ecx
  801764:	8b 55 14             	mov    0x14(%ebp),%edx
  801767:	89 0a                	mov    %ecx,(%edx)
  801769:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801770:	8b 45 10             	mov    0x10(%ebp),%eax
  801773:	01 c2                	add    %eax,%edx
  801775:	8b 45 08             	mov    0x8(%ebp),%eax
  801778:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  80177a:	eb 03                	jmp    80177f <strsplit+0x8f>
			string++;
  80177c:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  80177f:	8b 45 08             	mov    0x8(%ebp),%eax
  801782:	8a 00                	mov    (%eax),%al
  801784:	84 c0                	test   %al,%al
  801786:	74 8b                	je     801713 <strsplit+0x23>
  801788:	8b 45 08             	mov    0x8(%ebp),%eax
  80178b:	8a 00                	mov    (%eax),%al
  80178d:	0f be c0             	movsbl %al,%eax
  801790:	50                   	push   %eax
  801791:	ff 75 0c             	pushl  0xc(%ebp)
  801794:	e8 25 fa ff ff       	call   8011be <strchr>
  801799:	83 c4 08             	add    $0x8,%esp
  80179c:	85 c0                	test   %eax,%eax
  80179e:	74 dc                	je     80177c <strsplit+0x8c>
			string++;
	}
  8017a0:	e9 6e ff ff ff       	jmp    801713 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  8017a5:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  8017a6:	8b 45 14             	mov    0x14(%ebp),%eax
  8017a9:	8b 00                	mov    (%eax),%eax
  8017ab:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8017b2:	8b 45 10             	mov    0x10(%ebp),%eax
  8017b5:	01 d0                	add    %edx,%eax
  8017b7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  8017bd:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8017c2:	c9                   	leave  
  8017c3:	c3                   	ret    

008017c4 <str2lower>:


char* str2lower(char *dst, const char *src)
{
  8017c4:	55                   	push   %ebp
  8017c5:	89 e5                	mov    %esp,%ebp
  8017c7:	83 ec 10             	sub    $0x10,%esp
	char* ret = dst;
  8017ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8017cd:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (int i = 0; i < strlen(src); ++i)
  8017d0:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8017d7:	eb 4a                	jmp    801823 <str2lower+0x5f>
	{
		dst[i] = src[i] ;
  8017d9:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8017dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8017df:	01 c2                	add    %eax,%edx
  8017e1:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8017e4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017e7:	01 c8                	add    %ecx,%eax
  8017e9:	8a 00                	mov    (%eax),%al
  8017eb:	88 02                	mov    %al,(%edx)
		if (src[i] >= 'A' && src[i] <= 'Z')
  8017ed:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8017f0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017f3:	01 d0                	add    %edx,%eax
  8017f5:	8a 00                	mov    (%eax),%al
  8017f7:	3c 40                	cmp    $0x40,%al
  8017f9:	7e 25                	jle    801820 <str2lower+0x5c>
  8017fb:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8017fe:	8b 45 0c             	mov    0xc(%ebp),%eax
  801801:	01 d0                	add    %edx,%eax
  801803:	8a 00                	mov    (%eax),%al
  801805:	3c 5a                	cmp    $0x5a,%al
  801807:	7f 17                	jg     801820 <str2lower+0x5c>
		{
			dst[i] += 32 ;
  801809:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80180c:	8b 45 08             	mov    0x8(%ebp),%eax
  80180f:	01 d0                	add    %edx,%eax
  801811:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801814:	8b 55 08             	mov    0x8(%ebp),%edx
  801817:	01 ca                	add    %ecx,%edx
  801819:	8a 12                	mov    (%edx),%dl
  80181b:	83 c2 20             	add    $0x20,%edx
  80181e:	88 10                	mov    %dl,(%eax)


char* str2lower(char *dst, const char *src)
{
	char* ret = dst;
	for (int i = 0; i < strlen(src); ++i)
  801820:	ff 45 fc             	incl   -0x4(%ebp)
  801823:	ff 75 0c             	pushl  0xc(%ebp)
  801826:	e8 01 f8 ff ff       	call   80102c <strlen>
  80182b:	83 c4 04             	add    $0x4,%esp
  80182e:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801831:	7f a6                	jg     8017d9 <str2lower+0x15>
		if (src[i] >= 'A' && src[i] <= 'Z')
		{
			dst[i] += 32 ;
		}
	}
	return ret;
  801833:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801836:	c9                   	leave  
  801837:	c3                   	ret    

00801838 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801838:	55                   	push   %ebp
  801839:	89 e5                	mov    %esp,%ebp
  80183b:	57                   	push   %edi
  80183c:	56                   	push   %esi
  80183d:	53                   	push   %ebx
  80183e:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801841:	8b 45 08             	mov    0x8(%ebp),%eax
  801844:	8b 55 0c             	mov    0xc(%ebp),%edx
  801847:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80184a:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80184d:	8b 7d 18             	mov    0x18(%ebp),%edi
  801850:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801853:	cd 30                	int    $0x30
  801855:	89 45 f0             	mov    %eax,-0x10(%ebp)
				"b" (a3),
				"D" (a4),
				"S" (a5)
				: "cc", "memory");

	return ret;
  801858:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80185b:	83 c4 10             	add    $0x10,%esp
  80185e:	5b                   	pop    %ebx
  80185f:	5e                   	pop    %esi
  801860:	5f                   	pop    %edi
  801861:	5d                   	pop    %ebp
  801862:	c3                   	ret    

00801863 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName, int color)
{
  801863:	55                   	push   %ebp
  801864:	89 e5                	mov    %esp,%ebp
  801866:	83 ec 04             	sub    $0x4,%esp
  801869:	8b 45 10             	mov    0x10(%ebp),%eax
  80186c:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, color, 0);
  80186f:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801872:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801876:	8b 45 08             	mov    0x8(%ebp),%eax
  801879:	6a 00                	push   $0x0
  80187b:	51                   	push   %ecx
  80187c:	52                   	push   %edx
  80187d:	ff 75 0c             	pushl  0xc(%ebp)
  801880:	50                   	push   %eax
  801881:	6a 00                	push   $0x0
  801883:	e8 b0 ff ff ff       	call   801838 <syscall>
  801888:	83 c4 18             	add    $0x18,%esp
}
  80188b:	90                   	nop
  80188c:	c9                   	leave  
  80188d:	c3                   	ret    

0080188e <sys_cgetc>:

int
sys_cgetc(void)
{
  80188e:	55                   	push   %ebp
  80188f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801891:	6a 00                	push   $0x0
  801893:	6a 00                	push   $0x0
  801895:	6a 00                	push   $0x0
  801897:	6a 00                	push   $0x0
  801899:	6a 00                	push   $0x0
  80189b:	6a 02                	push   $0x2
  80189d:	e8 96 ff ff ff       	call   801838 <syscall>
  8018a2:	83 c4 18             	add    $0x18,%esp
}
  8018a5:	c9                   	leave  
  8018a6:	c3                   	ret    

008018a7 <sys_lock_cons>:

void sys_lock_cons(void)
{
  8018a7:	55                   	push   %ebp
  8018a8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  8018aa:	6a 00                	push   $0x0
  8018ac:	6a 00                	push   $0x0
  8018ae:	6a 00                	push   $0x0
  8018b0:	6a 00                	push   $0x0
  8018b2:	6a 00                	push   $0x0
  8018b4:	6a 03                	push   $0x3
  8018b6:	e8 7d ff ff ff       	call   801838 <syscall>
  8018bb:	83 c4 18             	add    $0x18,%esp
}
  8018be:	90                   	nop
  8018bf:	c9                   	leave  
  8018c0:	c3                   	ret    

008018c1 <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  8018c1:	55                   	push   %ebp
  8018c2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  8018c4:	6a 00                	push   $0x0
  8018c6:	6a 00                	push   $0x0
  8018c8:	6a 00                	push   $0x0
  8018ca:	6a 00                	push   $0x0
  8018cc:	6a 00                	push   $0x0
  8018ce:	6a 04                	push   $0x4
  8018d0:	e8 63 ff ff ff       	call   801838 <syscall>
  8018d5:	83 c4 18             	add    $0x18,%esp
}
  8018d8:	90                   	nop
  8018d9:	c9                   	leave  
  8018da:	c3                   	ret    

008018db <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  8018db:	55                   	push   %ebp
  8018dc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  8018de:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8018e4:	6a 00                	push   $0x0
  8018e6:	6a 00                	push   $0x0
  8018e8:	6a 00                	push   $0x0
  8018ea:	52                   	push   %edx
  8018eb:	50                   	push   %eax
  8018ec:	6a 08                	push   $0x8
  8018ee:	e8 45 ff ff ff       	call   801838 <syscall>
  8018f3:	83 c4 18             	add    $0x18,%esp
}
  8018f6:	c9                   	leave  
  8018f7:	c3                   	ret    

008018f8 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  8018f8:	55                   	push   %ebp
  8018f9:	89 e5                	mov    %esp,%ebp
  8018fb:	56                   	push   %esi
  8018fc:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  8018fd:	8b 75 18             	mov    0x18(%ebp),%esi
  801900:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801903:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801906:	8b 55 0c             	mov    0xc(%ebp),%edx
  801909:	8b 45 08             	mov    0x8(%ebp),%eax
  80190c:	56                   	push   %esi
  80190d:	53                   	push   %ebx
  80190e:	51                   	push   %ecx
  80190f:	52                   	push   %edx
  801910:	50                   	push   %eax
  801911:	6a 09                	push   $0x9
  801913:	e8 20 ff ff ff       	call   801838 <syscall>
  801918:	83 c4 18             	add    $0x18,%esp
}
  80191b:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80191e:	5b                   	pop    %ebx
  80191f:	5e                   	pop    %esi
  801920:	5d                   	pop    %ebp
  801921:	c3                   	ret    

00801922 <__sys_unmap_frame>:

int __sys_unmap_frame(uint32 va)
{
  801922:	55                   	push   %ebp
  801923:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, va, 0, 0, 0, 0);
  801925:	6a 00                	push   $0x0
  801927:	6a 00                	push   $0x0
  801929:	6a 00                	push   $0x0
  80192b:	6a 00                	push   $0x0
  80192d:	ff 75 08             	pushl  0x8(%ebp)
  801930:	6a 0a                	push   $0xa
  801932:	e8 01 ff ff ff       	call   801838 <syscall>
  801937:	83 c4 18             	add    $0x18,%esp
}
  80193a:	c9                   	leave  
  80193b:	c3                   	ret    

0080193c <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  80193c:	55                   	push   %ebp
  80193d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  80193f:	6a 00                	push   $0x0
  801941:	6a 00                	push   $0x0
  801943:	6a 00                	push   $0x0
  801945:	ff 75 0c             	pushl  0xc(%ebp)
  801948:	ff 75 08             	pushl  0x8(%ebp)
  80194b:	6a 0b                	push   $0xb
  80194d:	e8 e6 fe ff ff       	call   801838 <syscall>
  801952:	83 c4 18             	add    $0x18,%esp
}
  801955:	c9                   	leave  
  801956:	c3                   	ret    

00801957 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801957:	55                   	push   %ebp
  801958:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  80195a:	6a 00                	push   $0x0
  80195c:	6a 00                	push   $0x0
  80195e:	6a 00                	push   $0x0
  801960:	6a 00                	push   $0x0
  801962:	6a 00                	push   $0x0
  801964:	6a 0c                	push   $0xc
  801966:	e8 cd fe ff ff       	call   801838 <syscall>
  80196b:	83 c4 18             	add    $0x18,%esp
}
  80196e:	c9                   	leave  
  80196f:	c3                   	ret    

00801970 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801970:	55                   	push   %ebp
  801971:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801973:	6a 00                	push   $0x0
  801975:	6a 00                	push   $0x0
  801977:	6a 00                	push   $0x0
  801979:	6a 00                	push   $0x0
  80197b:	6a 00                	push   $0x0
  80197d:	6a 0d                	push   $0xd
  80197f:	e8 b4 fe ff ff       	call   801838 <syscall>
  801984:	83 c4 18             	add    $0x18,%esp
}
  801987:	c9                   	leave  
  801988:	c3                   	ret    

00801989 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801989:	55                   	push   %ebp
  80198a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  80198c:	6a 00                	push   $0x0
  80198e:	6a 00                	push   $0x0
  801990:	6a 00                	push   $0x0
  801992:	6a 00                	push   $0x0
  801994:	6a 00                	push   $0x0
  801996:	6a 0e                	push   $0xe
  801998:	e8 9b fe ff ff       	call   801838 <syscall>
  80199d:	83 c4 18             	add    $0x18,%esp
}
  8019a0:	c9                   	leave  
  8019a1:	c3                   	ret    

008019a2 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  8019a2:	55                   	push   %ebp
  8019a3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  8019a5:	6a 00                	push   $0x0
  8019a7:	6a 00                	push   $0x0
  8019a9:	6a 00                	push   $0x0
  8019ab:	6a 00                	push   $0x0
  8019ad:	6a 00                	push   $0x0
  8019af:	6a 0f                	push   $0xf
  8019b1:	e8 82 fe ff ff       	call   801838 <syscall>
  8019b6:	83 c4 18             	add    $0x18,%esp
}
  8019b9:	c9                   	leave  
  8019ba:	c3                   	ret    

008019bb <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  8019bb:	55                   	push   %ebp
  8019bc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  8019be:	6a 00                	push   $0x0
  8019c0:	6a 00                	push   $0x0
  8019c2:	6a 00                	push   $0x0
  8019c4:	6a 00                	push   $0x0
  8019c6:	ff 75 08             	pushl  0x8(%ebp)
  8019c9:	6a 10                	push   $0x10
  8019cb:	e8 68 fe ff ff       	call   801838 <syscall>
  8019d0:	83 c4 18             	add    $0x18,%esp
}
  8019d3:	c9                   	leave  
  8019d4:	c3                   	ret    

008019d5 <sys_scarce_memory>:

void sys_scarce_memory()
{
  8019d5:	55                   	push   %ebp
  8019d6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  8019d8:	6a 00                	push   $0x0
  8019da:	6a 00                	push   $0x0
  8019dc:	6a 00                	push   $0x0
  8019de:	6a 00                	push   $0x0
  8019e0:	6a 00                	push   $0x0
  8019e2:	6a 11                	push   $0x11
  8019e4:	e8 4f fe ff ff       	call   801838 <syscall>
  8019e9:	83 c4 18             	add    $0x18,%esp
}
  8019ec:	90                   	nop
  8019ed:	c9                   	leave  
  8019ee:	c3                   	ret    

008019ef <sys_cputc>:

void
sys_cputc(const char c)
{
  8019ef:	55                   	push   %ebp
  8019f0:	89 e5                	mov    %esp,%ebp
  8019f2:	83 ec 04             	sub    $0x4,%esp
  8019f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8019f8:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  8019fb:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8019ff:	6a 00                	push   $0x0
  801a01:	6a 00                	push   $0x0
  801a03:	6a 00                	push   $0x0
  801a05:	6a 00                	push   $0x0
  801a07:	50                   	push   %eax
  801a08:	6a 01                	push   $0x1
  801a0a:	e8 29 fe ff ff       	call   801838 <syscall>
  801a0f:	83 c4 18             	add    $0x18,%esp
}
  801a12:	90                   	nop
  801a13:	c9                   	leave  
  801a14:	c3                   	ret    

00801a15 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801a15:	55                   	push   %ebp
  801a16:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801a18:	6a 00                	push   $0x0
  801a1a:	6a 00                	push   $0x0
  801a1c:	6a 00                	push   $0x0
  801a1e:	6a 00                	push   $0x0
  801a20:	6a 00                	push   $0x0
  801a22:	6a 14                	push   $0x14
  801a24:	e8 0f fe ff ff       	call   801838 <syscall>
  801a29:	83 c4 18             	add    $0x18,%esp
}
  801a2c:	90                   	nop
  801a2d:	c9                   	leave  
  801a2e:	c3                   	ret    

00801a2f <sys_create_shared_object>:

int sys_create_shared_object(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801a2f:	55                   	push   %ebp
  801a30:	89 e5                	mov    %esp,%ebp
  801a32:	83 ec 04             	sub    $0x4,%esp
  801a35:	8b 45 10             	mov    0x10(%ebp),%eax
  801a38:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801a3b:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801a3e:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801a42:	8b 45 08             	mov    0x8(%ebp),%eax
  801a45:	6a 00                	push   $0x0
  801a47:	51                   	push   %ecx
  801a48:	52                   	push   %edx
  801a49:	ff 75 0c             	pushl  0xc(%ebp)
  801a4c:	50                   	push   %eax
  801a4d:	6a 15                	push   $0x15
  801a4f:	e8 e4 fd ff ff       	call   801838 <syscall>
  801a54:	83 c4 18             	add    $0x18,%esp
}
  801a57:	c9                   	leave  
  801a58:	c3                   	ret    

00801a59 <sys_size_of_shared_object>:

//2017:
int sys_size_of_shared_object(int32 ownerID, char* shareName)
{
  801a59:	55                   	push   %ebp
  801a5a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801a5c:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a5f:	8b 45 08             	mov    0x8(%ebp),%eax
  801a62:	6a 00                	push   $0x0
  801a64:	6a 00                	push   $0x0
  801a66:	6a 00                	push   $0x0
  801a68:	52                   	push   %edx
  801a69:	50                   	push   %eax
  801a6a:	6a 16                	push   $0x16
  801a6c:	e8 c7 fd ff ff       	call   801838 <syscall>
  801a71:	83 c4 18             	add    $0x18,%esp
}
  801a74:	c9                   	leave  
  801a75:	c3                   	ret    

00801a76 <sys_get_shared_object>:
//==========

int sys_get_shared_object(int32 ownerID, char* shareName, void* virtual_address)
{
  801a76:	55                   	push   %ebp
  801a77:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801a79:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801a7c:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a7f:	8b 45 08             	mov    0x8(%ebp),%eax
  801a82:	6a 00                	push   $0x0
  801a84:	6a 00                	push   $0x0
  801a86:	51                   	push   %ecx
  801a87:	52                   	push   %edx
  801a88:	50                   	push   %eax
  801a89:	6a 17                	push   $0x17
  801a8b:	e8 a8 fd ff ff       	call   801838 <syscall>
  801a90:	83 c4 18             	add    $0x18,%esp
}
  801a93:	c9                   	leave  
  801a94:	c3                   	ret    

00801a95 <sys_delete_shared_object>:

int sys_delete_shared_object(int32 sharedObjectID, void *startVA)
{
  801a95:	55                   	push   %ebp
  801a96:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801a98:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a9b:	8b 45 08             	mov    0x8(%ebp),%eax
  801a9e:	6a 00                	push   $0x0
  801aa0:	6a 00                	push   $0x0
  801aa2:	6a 00                	push   $0x0
  801aa4:	52                   	push   %edx
  801aa5:	50                   	push   %eax
  801aa6:	6a 18                	push   $0x18
  801aa8:	e8 8b fd ff ff       	call   801838 <syscall>
  801aad:	83 c4 18             	add    $0x18,%esp
}
  801ab0:	c9                   	leave  
  801ab1:	c3                   	ret    

00801ab2 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801ab2:	55                   	push   %ebp
  801ab3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801ab5:	8b 45 08             	mov    0x8(%ebp),%eax
  801ab8:	6a 00                	push   $0x0
  801aba:	ff 75 14             	pushl  0x14(%ebp)
  801abd:	ff 75 10             	pushl  0x10(%ebp)
  801ac0:	ff 75 0c             	pushl  0xc(%ebp)
  801ac3:	50                   	push   %eax
  801ac4:	6a 19                	push   $0x19
  801ac6:	e8 6d fd ff ff       	call   801838 <syscall>
  801acb:	83 c4 18             	add    $0x18,%esp
}
  801ace:	c9                   	leave  
  801acf:	c3                   	ret    

00801ad0 <sys_run_env>:

void sys_run_env(int32 envId)
{
  801ad0:	55                   	push   %ebp
  801ad1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801ad3:	8b 45 08             	mov    0x8(%ebp),%eax
  801ad6:	6a 00                	push   $0x0
  801ad8:	6a 00                	push   $0x0
  801ada:	6a 00                	push   $0x0
  801adc:	6a 00                	push   $0x0
  801ade:	50                   	push   %eax
  801adf:	6a 1a                	push   $0x1a
  801ae1:	e8 52 fd ff ff       	call   801838 <syscall>
  801ae6:	83 c4 18             	add    $0x18,%esp
}
  801ae9:	90                   	nop
  801aea:	c9                   	leave  
  801aeb:	c3                   	ret    

00801aec <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801aec:	55                   	push   %ebp
  801aed:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801aef:	8b 45 08             	mov    0x8(%ebp),%eax
  801af2:	6a 00                	push   $0x0
  801af4:	6a 00                	push   $0x0
  801af6:	6a 00                	push   $0x0
  801af8:	6a 00                	push   $0x0
  801afa:	50                   	push   %eax
  801afb:	6a 1b                	push   $0x1b
  801afd:	e8 36 fd ff ff       	call   801838 <syscall>
  801b02:	83 c4 18             	add    $0x18,%esp
}
  801b05:	c9                   	leave  
  801b06:	c3                   	ret    

00801b07 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801b07:	55                   	push   %ebp
  801b08:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801b0a:	6a 00                	push   $0x0
  801b0c:	6a 00                	push   $0x0
  801b0e:	6a 00                	push   $0x0
  801b10:	6a 00                	push   $0x0
  801b12:	6a 00                	push   $0x0
  801b14:	6a 05                	push   $0x5
  801b16:	e8 1d fd ff ff       	call   801838 <syscall>
  801b1b:	83 c4 18             	add    $0x18,%esp
}
  801b1e:	c9                   	leave  
  801b1f:	c3                   	ret    

00801b20 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801b20:	55                   	push   %ebp
  801b21:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801b23:	6a 00                	push   $0x0
  801b25:	6a 00                	push   $0x0
  801b27:	6a 00                	push   $0x0
  801b29:	6a 00                	push   $0x0
  801b2b:	6a 00                	push   $0x0
  801b2d:	6a 06                	push   $0x6
  801b2f:	e8 04 fd ff ff       	call   801838 <syscall>
  801b34:	83 c4 18             	add    $0x18,%esp
}
  801b37:	c9                   	leave  
  801b38:	c3                   	ret    

00801b39 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801b39:	55                   	push   %ebp
  801b3a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801b3c:	6a 00                	push   $0x0
  801b3e:	6a 00                	push   $0x0
  801b40:	6a 00                	push   $0x0
  801b42:	6a 00                	push   $0x0
  801b44:	6a 00                	push   $0x0
  801b46:	6a 07                	push   $0x7
  801b48:	e8 eb fc ff ff       	call   801838 <syscall>
  801b4d:	83 c4 18             	add    $0x18,%esp
}
  801b50:	c9                   	leave  
  801b51:	c3                   	ret    

00801b52 <sys_exit_env>:


void sys_exit_env(void)
{
  801b52:	55                   	push   %ebp
  801b53:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801b55:	6a 00                	push   $0x0
  801b57:	6a 00                	push   $0x0
  801b59:	6a 00                	push   $0x0
  801b5b:	6a 00                	push   $0x0
  801b5d:	6a 00                	push   $0x0
  801b5f:	6a 1c                	push   $0x1c
  801b61:	e8 d2 fc ff ff       	call   801838 <syscall>
  801b66:	83 c4 18             	add    $0x18,%esp
}
  801b69:	90                   	nop
  801b6a:	c9                   	leave  
  801b6b:	c3                   	ret    

00801b6c <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  801b6c:	55                   	push   %ebp
  801b6d:	89 e5                	mov    %esp,%ebp
  801b6f:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801b72:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801b75:	8d 50 04             	lea    0x4(%eax),%edx
  801b78:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801b7b:	6a 00                	push   $0x0
  801b7d:	6a 00                	push   $0x0
  801b7f:	6a 00                	push   $0x0
  801b81:	52                   	push   %edx
  801b82:	50                   	push   %eax
  801b83:	6a 1d                	push   $0x1d
  801b85:	e8 ae fc ff ff       	call   801838 <syscall>
  801b8a:	83 c4 18             	add    $0x18,%esp
	return result;
  801b8d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801b90:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801b93:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801b96:	89 01                	mov    %eax,(%ecx)
  801b98:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801b9b:	8b 45 08             	mov    0x8(%ebp),%eax
  801b9e:	c9                   	leave  
  801b9f:	c2 04 00             	ret    $0x4

00801ba2 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801ba2:	55                   	push   %ebp
  801ba3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801ba5:	6a 00                	push   $0x0
  801ba7:	6a 00                	push   $0x0
  801ba9:	ff 75 10             	pushl  0x10(%ebp)
  801bac:	ff 75 0c             	pushl  0xc(%ebp)
  801baf:	ff 75 08             	pushl  0x8(%ebp)
  801bb2:	6a 13                	push   $0x13
  801bb4:	e8 7f fc ff ff       	call   801838 <syscall>
  801bb9:	83 c4 18             	add    $0x18,%esp
	return ;
  801bbc:	90                   	nop
}
  801bbd:	c9                   	leave  
  801bbe:	c3                   	ret    

00801bbf <sys_rcr2>:
uint32 sys_rcr2()
{
  801bbf:	55                   	push   %ebp
  801bc0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801bc2:	6a 00                	push   $0x0
  801bc4:	6a 00                	push   $0x0
  801bc6:	6a 00                	push   $0x0
  801bc8:	6a 00                	push   $0x0
  801bca:	6a 00                	push   $0x0
  801bcc:	6a 1e                	push   $0x1e
  801bce:	e8 65 fc ff ff       	call   801838 <syscall>
  801bd3:	83 c4 18             	add    $0x18,%esp
}
  801bd6:	c9                   	leave  
  801bd7:	c3                   	ret    

00801bd8 <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  801bd8:	55                   	push   %ebp
  801bd9:	89 e5                	mov    %esp,%ebp
  801bdb:	83 ec 04             	sub    $0x4,%esp
  801bde:	8b 45 08             	mov    0x8(%ebp),%eax
  801be1:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801be4:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801be8:	6a 00                	push   $0x0
  801bea:	6a 00                	push   $0x0
  801bec:	6a 00                	push   $0x0
  801bee:	6a 00                	push   $0x0
  801bf0:	50                   	push   %eax
  801bf1:	6a 1f                	push   $0x1f
  801bf3:	e8 40 fc ff ff       	call   801838 <syscall>
  801bf8:	83 c4 18             	add    $0x18,%esp
	return ;
  801bfb:	90                   	nop
}
  801bfc:	c9                   	leave  
  801bfd:	c3                   	ret    

00801bfe <rsttst>:
void rsttst()
{
  801bfe:	55                   	push   %ebp
  801bff:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801c01:	6a 00                	push   $0x0
  801c03:	6a 00                	push   $0x0
  801c05:	6a 00                	push   $0x0
  801c07:	6a 00                	push   $0x0
  801c09:	6a 00                	push   $0x0
  801c0b:	6a 21                	push   $0x21
  801c0d:	e8 26 fc ff ff       	call   801838 <syscall>
  801c12:	83 c4 18             	add    $0x18,%esp
	return ;
  801c15:	90                   	nop
}
  801c16:	c9                   	leave  
  801c17:	c3                   	ret    

00801c18 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801c18:	55                   	push   %ebp
  801c19:	89 e5                	mov    %esp,%ebp
  801c1b:	83 ec 04             	sub    $0x4,%esp
  801c1e:	8b 45 14             	mov    0x14(%ebp),%eax
  801c21:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801c24:	8b 55 18             	mov    0x18(%ebp),%edx
  801c27:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801c2b:	52                   	push   %edx
  801c2c:	50                   	push   %eax
  801c2d:	ff 75 10             	pushl  0x10(%ebp)
  801c30:	ff 75 0c             	pushl  0xc(%ebp)
  801c33:	ff 75 08             	pushl  0x8(%ebp)
  801c36:	6a 20                	push   $0x20
  801c38:	e8 fb fb ff ff       	call   801838 <syscall>
  801c3d:	83 c4 18             	add    $0x18,%esp
	return ;
  801c40:	90                   	nop
}
  801c41:	c9                   	leave  
  801c42:	c3                   	ret    

00801c43 <chktst>:
void chktst(uint32 n)
{
  801c43:	55                   	push   %ebp
  801c44:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801c46:	6a 00                	push   $0x0
  801c48:	6a 00                	push   $0x0
  801c4a:	6a 00                	push   $0x0
  801c4c:	6a 00                	push   $0x0
  801c4e:	ff 75 08             	pushl  0x8(%ebp)
  801c51:	6a 22                	push   $0x22
  801c53:	e8 e0 fb ff ff       	call   801838 <syscall>
  801c58:	83 c4 18             	add    $0x18,%esp
	return ;
  801c5b:	90                   	nop
}
  801c5c:	c9                   	leave  
  801c5d:	c3                   	ret    

00801c5e <inctst>:

void inctst()
{
  801c5e:	55                   	push   %ebp
  801c5f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801c61:	6a 00                	push   $0x0
  801c63:	6a 00                	push   $0x0
  801c65:	6a 00                	push   $0x0
  801c67:	6a 00                	push   $0x0
  801c69:	6a 00                	push   $0x0
  801c6b:	6a 23                	push   $0x23
  801c6d:	e8 c6 fb ff ff       	call   801838 <syscall>
  801c72:	83 c4 18             	add    $0x18,%esp
	return ;
  801c75:	90                   	nop
}
  801c76:	c9                   	leave  
  801c77:	c3                   	ret    

00801c78 <gettst>:
uint32 gettst()
{
  801c78:	55                   	push   %ebp
  801c79:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801c7b:	6a 00                	push   $0x0
  801c7d:	6a 00                	push   $0x0
  801c7f:	6a 00                	push   $0x0
  801c81:	6a 00                	push   $0x0
  801c83:	6a 00                	push   $0x0
  801c85:	6a 24                	push   $0x24
  801c87:	e8 ac fb ff ff       	call   801838 <syscall>
  801c8c:	83 c4 18             	add    $0x18,%esp
}
  801c8f:	c9                   	leave  
  801c90:	c3                   	ret    

00801c91 <sys_get_uheap_strategy>:

/*2025*/
uint32 sys_get_uheap_strategy()
{
  801c91:	55                   	push   %ebp
  801c92:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801c94:	6a 00                	push   $0x0
  801c96:	6a 00                	push   $0x0
  801c98:	6a 00                	push   $0x0
  801c9a:	6a 00                	push   $0x0
  801c9c:	6a 00                	push   $0x0
  801c9e:	6a 25                	push   $0x25
  801ca0:	e8 93 fb ff ff       	call   801838 <syscall>
  801ca5:	83 c4 18             	add    $0x18,%esp
  801ca8:	a3 60 b0 81 00       	mov    %eax,0x81b060
	return uheapPlaceStrategy ;
  801cad:	a1 60 b0 81 00       	mov    0x81b060,%eax
}
  801cb2:	c9                   	leave  
  801cb3:	c3                   	ret    

00801cb4 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801cb4:	55                   	push   %ebp
  801cb5:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = heapStrategy;
  801cb7:	8b 45 08             	mov    0x8(%ebp),%eax
  801cba:	a3 60 b0 81 00       	mov    %eax,0x81b060
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801cbf:	6a 00                	push   $0x0
  801cc1:	6a 00                	push   $0x0
  801cc3:	6a 00                	push   $0x0
  801cc5:	6a 00                	push   $0x0
  801cc7:	ff 75 08             	pushl  0x8(%ebp)
  801cca:	6a 26                	push   $0x26
  801ccc:	e8 67 fb ff ff       	call   801838 <syscall>
  801cd1:	83 c4 18             	add    $0x18,%esp
	return ;
  801cd4:	90                   	nop
}
  801cd5:	c9                   	leave  
  801cd6:	c3                   	ret    

00801cd7 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801cd7:	55                   	push   %ebp
  801cd8:	89 e5                	mov    %esp,%ebp
  801cda:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801cdb:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801cde:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801ce1:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ce4:	8b 45 08             	mov    0x8(%ebp),%eax
  801ce7:	6a 00                	push   $0x0
  801ce9:	53                   	push   %ebx
  801cea:	51                   	push   %ecx
  801ceb:	52                   	push   %edx
  801cec:	50                   	push   %eax
  801ced:	6a 27                	push   $0x27
  801cef:	e8 44 fb ff ff       	call   801838 <syscall>
  801cf4:	83 c4 18             	add    $0x18,%esp
}
  801cf7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801cfa:	c9                   	leave  
  801cfb:	c3                   	ret    

00801cfc <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801cfc:	55                   	push   %ebp
  801cfd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801cff:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d02:	8b 45 08             	mov    0x8(%ebp),%eax
  801d05:	6a 00                	push   $0x0
  801d07:	6a 00                	push   $0x0
  801d09:	6a 00                	push   $0x0
  801d0b:	52                   	push   %edx
  801d0c:	50                   	push   %eax
  801d0d:	6a 28                	push   $0x28
  801d0f:	e8 24 fb ff ff       	call   801838 <syscall>
  801d14:	83 c4 18             	add    $0x18,%esp
}
  801d17:	c9                   	leave  
  801d18:	c3                   	ret    

00801d19 <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  801d19:	55                   	push   %ebp
  801d1a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  801d1c:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801d1f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d22:	8b 45 08             	mov    0x8(%ebp),%eax
  801d25:	6a 00                	push   $0x0
  801d27:	51                   	push   %ecx
  801d28:	ff 75 10             	pushl  0x10(%ebp)
  801d2b:	52                   	push   %edx
  801d2c:	50                   	push   %eax
  801d2d:	6a 29                	push   $0x29
  801d2f:	e8 04 fb ff ff       	call   801838 <syscall>
  801d34:	83 c4 18             	add    $0x18,%esp
}
  801d37:	c9                   	leave  
  801d38:	c3                   	ret    

00801d39 <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801d39:	55                   	push   %ebp
  801d3a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801d3c:	6a 00                	push   $0x0
  801d3e:	6a 00                	push   $0x0
  801d40:	ff 75 10             	pushl  0x10(%ebp)
  801d43:	ff 75 0c             	pushl  0xc(%ebp)
  801d46:	ff 75 08             	pushl  0x8(%ebp)
  801d49:	6a 12                	push   $0x12
  801d4b:	e8 e8 fa ff ff       	call   801838 <syscall>
  801d50:	83 c4 18             	add    $0x18,%esp
	return ;
  801d53:	90                   	nop
}
  801d54:	c9                   	leave  
  801d55:	c3                   	ret    

00801d56 <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  801d56:	55                   	push   %ebp
  801d57:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  801d59:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d5c:	8b 45 08             	mov    0x8(%ebp),%eax
  801d5f:	6a 00                	push   $0x0
  801d61:	6a 00                	push   $0x0
  801d63:	6a 00                	push   $0x0
  801d65:	52                   	push   %edx
  801d66:	50                   	push   %eax
  801d67:	6a 2a                	push   $0x2a
  801d69:	e8 ca fa ff ff       	call   801838 <syscall>
  801d6e:	83 c4 18             	add    $0x18,%esp
	return;
  801d71:	90                   	nop
}
  801d72:	c9                   	leave  
  801d73:	c3                   	ret    

00801d74 <sys_get_optimal_num_faults>:
/*2025*/
int sys_get_optimal_num_faults()
{
  801d74:	55                   	push   %ebp
  801d75:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_optimal_num_faults, 0, 0, 0, 0, 0);
  801d77:	6a 00                	push   $0x0
  801d79:	6a 00                	push   $0x0
  801d7b:	6a 00                	push   $0x0
  801d7d:	6a 00                	push   $0x0
  801d7f:	6a 00                	push   $0x0
  801d81:	6a 2b                	push   $0x2b
  801d83:	e8 b0 fa ff ff       	call   801838 <syscall>
  801d88:	83 c4 18             	add    $0x18,%esp
}
  801d8b:	c9                   	leave  
  801d8c:	c3                   	ret    

00801d8d <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801d8d:	55                   	push   %ebp
  801d8e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801d90:	6a 00                	push   $0x0
  801d92:	6a 00                	push   $0x0
  801d94:	6a 00                	push   $0x0
  801d96:	ff 75 0c             	pushl  0xc(%ebp)
  801d99:	ff 75 08             	pushl  0x8(%ebp)
  801d9c:	6a 2d                	push   $0x2d
  801d9e:	e8 95 fa ff ff       	call   801838 <syscall>
  801da3:	83 c4 18             	add    $0x18,%esp
	return;
  801da6:	90                   	nop
}
  801da7:	c9                   	leave  
  801da8:	c3                   	ret    

00801da9 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801da9:	55                   	push   %ebp
  801daa:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801dac:	6a 00                	push   $0x0
  801dae:	6a 00                	push   $0x0
  801db0:	6a 00                	push   $0x0
  801db2:	ff 75 0c             	pushl  0xc(%ebp)
  801db5:	ff 75 08             	pushl  0x8(%ebp)
  801db8:	6a 2c                	push   $0x2c
  801dba:	e8 79 fa ff ff       	call   801838 <syscall>
  801dbf:	83 c4 18             	add    $0x18,%esp
	return ;
  801dc2:	90                   	nop
}
  801dc3:	c9                   	leave  
  801dc4:	c3                   	ret    

00801dc5 <sys_env_set_priority>:


void sys_env_set_priority(int32 envID, int priority)
{
  801dc5:	55                   	push   %ebp
  801dc6:	89 e5                	mov    %esp,%ebp
  801dc8:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.IM#4] CPU SCHEDULING - #1 System Calls - Add suitable code here
	//Your code is here
	//Comment the following line
	panic("sys_env_set_priority() is not implemented yet...!!");
  801dcb:	83 ec 04             	sub    $0x4,%esp
  801dce:	68 5c 2a 80 00       	push   $0x802a5c
  801dd3:	68 25 01 00 00       	push   $0x125
  801dd8:	68 8f 2a 80 00       	push   $0x802a8f
  801ddd:	e8 9b e6 ff ff       	call   80047d <_panic>

00801de2 <env_sleep>:
#include <inc/lib.h>
#include <inc/timerreg.h>

void
env_sleep(uint32 approxMilliSeconds)
{
  801de2:	55                   	push   %ebp
  801de3:	89 e5                	mov    %esp,%ebp
  801de5:	83 ec 30             	sub    $0x30,%esp
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
  801de8:	8b 55 08             	mov    0x8(%ebp),%edx
  801deb:	89 d0                	mov    %edx,%eax
  801ded:	c1 e0 02             	shl    $0x2,%eax
  801df0:	01 d0                	add    %edx,%eax
  801df2:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801df9:	01 d0                	add    %edx,%eax
  801dfb:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801e02:	01 d0                	add    %edx,%eax
  801e04:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801e0b:	01 d0                	add    %edx,%eax
  801e0d:	c1 e0 04             	shl    $0x4,%eax
  801e10:	89 45 f8             	mov    %eax,-0x8(%ebp)
	uint32 cycles_counter =0;
  801e13:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)

static inline __attribute__((always_inline)) struct uint64 get_virtual_time_user()
{
	struct uint64 result;

	__asm __volatile("rdtsc\n"
  801e1a:	0f 31                	rdtsc  
  801e1c:	89 45 e8             	mov    %eax,-0x18(%ebp)
  801e1f:	89 55 ec             	mov    %edx,-0x14(%ebp)
	: "=a" (result.low), "=d" (result.hi)
	);

	return result;
  801e22:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801e25:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801e28:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801e2b:	89 55 f4             	mov    %edx,-0xc(%ebp)

	/*2024*/ //USE A USER-SIDE VERSION OF THIS FUNCTION TO AVOID SLOW-DOWN THE PERFORMANCE DUE SYS_CALL (el7 :))
	//struct uint64 baseTime = sys_get_virtual_time() ;
	struct uint64 baseTime = get_virtual_time_user() ;
	while(cycles_counter<time_in_cycles)
  801e2e:	eb 46                	jmp    801e76 <env_sleep+0x94>

static inline __attribute__((always_inline)) struct uint64 get_virtual_time_user()
{
	struct uint64 result;

	__asm __volatile("rdtsc\n"
  801e30:	0f 31                	rdtsc  
  801e32:	89 45 d0             	mov    %eax,-0x30(%ebp)
  801e35:	89 55 d4             	mov    %edx,-0x2c(%ebp)
	: "=a" (result.low), "=d" (result.hi)
	);

	return result;
  801e38:	8b 45 d0             	mov    -0x30(%ebp),%eax
  801e3b:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  801e3e:	89 45 e0             	mov    %eax,-0x20(%ebp)
  801e41:	89 55 e4             	mov    %edx,-0x1c(%ebp)

		// update the cycles_count
		#define M32 0xffffffff
		// subtract basetime from current time
		struct uint64 res;
		res.low = (currentTime.low - baseTime.low) & M32;
  801e44:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801e47:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e4a:	29 c2                	sub    %eax,%edx
  801e4c:	89 d0                	mov    %edx,%eax
  801e4e:	89 45 d8             	mov    %eax,-0x28(%ebp)
		res.hi = (currentTime.hi - baseTime.hi - (res.low > currentTime.low)) & M32;
  801e51:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801e54:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e57:	89 d1                	mov    %edx,%ecx
  801e59:	29 c1                	sub    %eax,%ecx
  801e5b:	8b 55 d8             	mov    -0x28(%ebp),%edx
  801e5e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801e61:	39 c2                	cmp    %eax,%edx
  801e63:	0f 97 c0             	seta   %al
  801e66:	0f b6 c0             	movzbl %al,%eax
  801e69:	29 c1                	sub    %eax,%ecx
  801e6b:	89 c8                	mov    %ecx,%eax
  801e6d:	89 45 dc             	mov    %eax,-0x24(%ebp)

		//update cycles_count with result
		cycles_counter = res.low;
  801e70:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801e73:	89 45 fc             	mov    %eax,-0x4(%ebp)
	uint32 cycles_counter =0;

	/*2024*/ //USE A USER-SIDE VERSION OF THIS FUNCTION TO AVOID SLOW-DOWN THE PERFORMANCE DUE SYS_CALL (el7 :))
	//struct uint64 baseTime = sys_get_virtual_time() ;
	struct uint64 baseTime = get_virtual_time_user() ;
	while(cycles_counter<time_in_cycles)
  801e76:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801e79:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801e7c:	72 b2                	jb     801e30 <env_sleep+0x4e>
//				,cycles_counter
//				);
	}
	//cprintf("%s [%d] wake up now!\n", myEnv->prog_name, myEnv->env_id);

}
  801e7e:	90                   	nop
  801e7f:	c9                   	leave  
  801e80:	c3                   	ret    

00801e81 <busy_wait>:

//2017
uint32 busy_wait(uint32 loopMax)
{
  801e81:	55                   	push   %ebp
  801e82:	89 e5                	mov    %esp,%ebp
  801e84:	83 ec 10             	sub    $0x10,%esp
	uint32 i = 0 ;
  801e87:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	while (i < loopMax) i++;
  801e8e:	eb 03                	jmp    801e93 <busy_wait+0x12>
  801e90:	ff 45 fc             	incl   -0x4(%ebp)
  801e93:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801e96:	3b 45 08             	cmp    0x8(%ebp),%eax
  801e99:	72 f5                	jb     801e90 <busy_wait+0xf>
	return i;
  801e9b:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801e9e:	c9                   	leave  
  801e9f:	c3                   	ret    

00801ea0 <cputchar>:
#include <inc/lib.h>


void
cputchar(int ch)
{
  801ea0:	55                   	push   %ebp
  801ea1:	89 e5                	mov    %esp,%ebp
  801ea3:	83 ec 18             	sub    $0x18,%esp
	char c = ch;
  801ea6:	8b 45 08             	mov    0x8(%ebp),%eax
  801ea9:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	//sys_cputs(&c, 1);

	sys_cputc(c);
  801eac:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  801eb0:	83 ec 0c             	sub    $0xc,%esp
  801eb3:	50                   	push   %eax
  801eb4:	e8 36 fb ff ff       	call   8019ef <sys_cputc>
  801eb9:	83 c4 10             	add    $0x10,%esp
}
  801ebc:	90                   	nop
  801ebd:	c9                   	leave  
  801ebe:	c3                   	ret    

00801ebf <getchar>:


int
getchar(void)
{
  801ebf:	55                   	push   %ebp
  801ec0:	89 e5                	mov    %esp,%ebp
  801ec2:	83 ec 18             	sub    $0x18,%esp
	int c =sys_cgetc();
  801ec5:	e8 c4 f9 ff ff       	call   80188e <sys_cgetc>
  801eca:	89 45 f4             	mov    %eax,-0xc(%ebp)
	return c;
  801ecd:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  801ed0:	c9                   	leave  
  801ed1:	c3                   	ret    

00801ed2 <iscons>:

int iscons(int fdnum)
{
  801ed2:	55                   	push   %ebp
  801ed3:	89 e5                	mov    %esp,%ebp
	// used by readline
	return 1;
  801ed5:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801eda:	5d                   	pop    %ebp
  801edb:	c3                   	ret    

00801edc <__udivdi3>:
  801edc:	55                   	push   %ebp
  801edd:	57                   	push   %edi
  801ede:	56                   	push   %esi
  801edf:	53                   	push   %ebx
  801ee0:	83 ec 1c             	sub    $0x1c,%esp
  801ee3:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  801ee7:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  801eeb:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801eef:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801ef3:	89 ca                	mov    %ecx,%edx
  801ef5:	89 f8                	mov    %edi,%eax
  801ef7:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  801efb:	85 f6                	test   %esi,%esi
  801efd:	75 2d                	jne    801f2c <__udivdi3+0x50>
  801eff:	39 cf                	cmp    %ecx,%edi
  801f01:	77 65                	ja     801f68 <__udivdi3+0x8c>
  801f03:	89 fd                	mov    %edi,%ebp
  801f05:	85 ff                	test   %edi,%edi
  801f07:	75 0b                	jne    801f14 <__udivdi3+0x38>
  801f09:	b8 01 00 00 00       	mov    $0x1,%eax
  801f0e:	31 d2                	xor    %edx,%edx
  801f10:	f7 f7                	div    %edi
  801f12:	89 c5                	mov    %eax,%ebp
  801f14:	31 d2                	xor    %edx,%edx
  801f16:	89 c8                	mov    %ecx,%eax
  801f18:	f7 f5                	div    %ebp
  801f1a:	89 c1                	mov    %eax,%ecx
  801f1c:	89 d8                	mov    %ebx,%eax
  801f1e:	f7 f5                	div    %ebp
  801f20:	89 cf                	mov    %ecx,%edi
  801f22:	89 fa                	mov    %edi,%edx
  801f24:	83 c4 1c             	add    $0x1c,%esp
  801f27:	5b                   	pop    %ebx
  801f28:	5e                   	pop    %esi
  801f29:	5f                   	pop    %edi
  801f2a:	5d                   	pop    %ebp
  801f2b:	c3                   	ret    
  801f2c:	39 ce                	cmp    %ecx,%esi
  801f2e:	77 28                	ja     801f58 <__udivdi3+0x7c>
  801f30:	0f bd fe             	bsr    %esi,%edi
  801f33:	83 f7 1f             	xor    $0x1f,%edi
  801f36:	75 40                	jne    801f78 <__udivdi3+0x9c>
  801f38:	39 ce                	cmp    %ecx,%esi
  801f3a:	72 0a                	jb     801f46 <__udivdi3+0x6a>
  801f3c:	3b 44 24 08          	cmp    0x8(%esp),%eax
  801f40:	0f 87 9e 00 00 00    	ja     801fe4 <__udivdi3+0x108>
  801f46:	b8 01 00 00 00       	mov    $0x1,%eax
  801f4b:	89 fa                	mov    %edi,%edx
  801f4d:	83 c4 1c             	add    $0x1c,%esp
  801f50:	5b                   	pop    %ebx
  801f51:	5e                   	pop    %esi
  801f52:	5f                   	pop    %edi
  801f53:	5d                   	pop    %ebp
  801f54:	c3                   	ret    
  801f55:	8d 76 00             	lea    0x0(%esi),%esi
  801f58:	31 ff                	xor    %edi,%edi
  801f5a:	31 c0                	xor    %eax,%eax
  801f5c:	89 fa                	mov    %edi,%edx
  801f5e:	83 c4 1c             	add    $0x1c,%esp
  801f61:	5b                   	pop    %ebx
  801f62:	5e                   	pop    %esi
  801f63:	5f                   	pop    %edi
  801f64:	5d                   	pop    %ebp
  801f65:	c3                   	ret    
  801f66:	66 90                	xchg   %ax,%ax
  801f68:	89 d8                	mov    %ebx,%eax
  801f6a:	f7 f7                	div    %edi
  801f6c:	31 ff                	xor    %edi,%edi
  801f6e:	89 fa                	mov    %edi,%edx
  801f70:	83 c4 1c             	add    $0x1c,%esp
  801f73:	5b                   	pop    %ebx
  801f74:	5e                   	pop    %esi
  801f75:	5f                   	pop    %edi
  801f76:	5d                   	pop    %ebp
  801f77:	c3                   	ret    
  801f78:	bd 20 00 00 00       	mov    $0x20,%ebp
  801f7d:	89 eb                	mov    %ebp,%ebx
  801f7f:	29 fb                	sub    %edi,%ebx
  801f81:	89 f9                	mov    %edi,%ecx
  801f83:	d3 e6                	shl    %cl,%esi
  801f85:	89 c5                	mov    %eax,%ebp
  801f87:	88 d9                	mov    %bl,%cl
  801f89:	d3 ed                	shr    %cl,%ebp
  801f8b:	89 e9                	mov    %ebp,%ecx
  801f8d:	09 f1                	or     %esi,%ecx
  801f8f:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  801f93:	89 f9                	mov    %edi,%ecx
  801f95:	d3 e0                	shl    %cl,%eax
  801f97:	89 c5                	mov    %eax,%ebp
  801f99:	89 d6                	mov    %edx,%esi
  801f9b:	88 d9                	mov    %bl,%cl
  801f9d:	d3 ee                	shr    %cl,%esi
  801f9f:	89 f9                	mov    %edi,%ecx
  801fa1:	d3 e2                	shl    %cl,%edx
  801fa3:	8b 44 24 08          	mov    0x8(%esp),%eax
  801fa7:	88 d9                	mov    %bl,%cl
  801fa9:	d3 e8                	shr    %cl,%eax
  801fab:	09 c2                	or     %eax,%edx
  801fad:	89 d0                	mov    %edx,%eax
  801faf:	89 f2                	mov    %esi,%edx
  801fb1:	f7 74 24 0c          	divl   0xc(%esp)
  801fb5:	89 d6                	mov    %edx,%esi
  801fb7:	89 c3                	mov    %eax,%ebx
  801fb9:	f7 e5                	mul    %ebp
  801fbb:	39 d6                	cmp    %edx,%esi
  801fbd:	72 19                	jb     801fd8 <__udivdi3+0xfc>
  801fbf:	74 0b                	je     801fcc <__udivdi3+0xf0>
  801fc1:	89 d8                	mov    %ebx,%eax
  801fc3:	31 ff                	xor    %edi,%edi
  801fc5:	e9 58 ff ff ff       	jmp    801f22 <__udivdi3+0x46>
  801fca:	66 90                	xchg   %ax,%ax
  801fcc:	8b 54 24 08          	mov    0x8(%esp),%edx
  801fd0:	89 f9                	mov    %edi,%ecx
  801fd2:	d3 e2                	shl    %cl,%edx
  801fd4:	39 c2                	cmp    %eax,%edx
  801fd6:	73 e9                	jae    801fc1 <__udivdi3+0xe5>
  801fd8:	8d 43 ff             	lea    -0x1(%ebx),%eax
  801fdb:	31 ff                	xor    %edi,%edi
  801fdd:	e9 40 ff ff ff       	jmp    801f22 <__udivdi3+0x46>
  801fe2:	66 90                	xchg   %ax,%ax
  801fe4:	31 c0                	xor    %eax,%eax
  801fe6:	e9 37 ff ff ff       	jmp    801f22 <__udivdi3+0x46>
  801feb:	90                   	nop

00801fec <__umoddi3>:
  801fec:	55                   	push   %ebp
  801fed:	57                   	push   %edi
  801fee:	56                   	push   %esi
  801fef:	53                   	push   %ebx
  801ff0:	83 ec 1c             	sub    $0x1c,%esp
  801ff3:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  801ff7:	8b 74 24 34          	mov    0x34(%esp),%esi
  801ffb:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801fff:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  802003:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802007:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80200b:	89 f3                	mov    %esi,%ebx
  80200d:	89 fa                	mov    %edi,%edx
  80200f:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  802013:	89 34 24             	mov    %esi,(%esp)
  802016:	85 c0                	test   %eax,%eax
  802018:	75 1a                	jne    802034 <__umoddi3+0x48>
  80201a:	39 f7                	cmp    %esi,%edi
  80201c:	0f 86 a2 00 00 00    	jbe    8020c4 <__umoddi3+0xd8>
  802022:	89 c8                	mov    %ecx,%eax
  802024:	89 f2                	mov    %esi,%edx
  802026:	f7 f7                	div    %edi
  802028:	89 d0                	mov    %edx,%eax
  80202a:	31 d2                	xor    %edx,%edx
  80202c:	83 c4 1c             	add    $0x1c,%esp
  80202f:	5b                   	pop    %ebx
  802030:	5e                   	pop    %esi
  802031:	5f                   	pop    %edi
  802032:	5d                   	pop    %ebp
  802033:	c3                   	ret    
  802034:	39 f0                	cmp    %esi,%eax
  802036:	0f 87 ac 00 00 00    	ja     8020e8 <__umoddi3+0xfc>
  80203c:	0f bd e8             	bsr    %eax,%ebp
  80203f:	83 f5 1f             	xor    $0x1f,%ebp
  802042:	0f 84 ac 00 00 00    	je     8020f4 <__umoddi3+0x108>
  802048:	bf 20 00 00 00       	mov    $0x20,%edi
  80204d:	29 ef                	sub    %ebp,%edi
  80204f:	89 fe                	mov    %edi,%esi
  802051:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802055:	89 e9                	mov    %ebp,%ecx
  802057:	d3 e0                	shl    %cl,%eax
  802059:	89 d7                	mov    %edx,%edi
  80205b:	89 f1                	mov    %esi,%ecx
  80205d:	d3 ef                	shr    %cl,%edi
  80205f:	09 c7                	or     %eax,%edi
  802061:	89 e9                	mov    %ebp,%ecx
  802063:	d3 e2                	shl    %cl,%edx
  802065:	89 14 24             	mov    %edx,(%esp)
  802068:	89 d8                	mov    %ebx,%eax
  80206a:	d3 e0                	shl    %cl,%eax
  80206c:	89 c2                	mov    %eax,%edx
  80206e:	8b 44 24 08          	mov    0x8(%esp),%eax
  802072:	d3 e0                	shl    %cl,%eax
  802074:	89 44 24 04          	mov    %eax,0x4(%esp)
  802078:	8b 44 24 08          	mov    0x8(%esp),%eax
  80207c:	89 f1                	mov    %esi,%ecx
  80207e:	d3 e8                	shr    %cl,%eax
  802080:	09 d0                	or     %edx,%eax
  802082:	d3 eb                	shr    %cl,%ebx
  802084:	89 da                	mov    %ebx,%edx
  802086:	f7 f7                	div    %edi
  802088:	89 d3                	mov    %edx,%ebx
  80208a:	f7 24 24             	mull   (%esp)
  80208d:	89 c6                	mov    %eax,%esi
  80208f:	89 d1                	mov    %edx,%ecx
  802091:	39 d3                	cmp    %edx,%ebx
  802093:	0f 82 87 00 00 00    	jb     802120 <__umoddi3+0x134>
  802099:	0f 84 91 00 00 00    	je     802130 <__umoddi3+0x144>
  80209f:	8b 54 24 04          	mov    0x4(%esp),%edx
  8020a3:	29 f2                	sub    %esi,%edx
  8020a5:	19 cb                	sbb    %ecx,%ebx
  8020a7:	89 d8                	mov    %ebx,%eax
  8020a9:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  8020ad:	d3 e0                	shl    %cl,%eax
  8020af:	89 e9                	mov    %ebp,%ecx
  8020b1:	d3 ea                	shr    %cl,%edx
  8020b3:	09 d0                	or     %edx,%eax
  8020b5:	89 e9                	mov    %ebp,%ecx
  8020b7:	d3 eb                	shr    %cl,%ebx
  8020b9:	89 da                	mov    %ebx,%edx
  8020bb:	83 c4 1c             	add    $0x1c,%esp
  8020be:	5b                   	pop    %ebx
  8020bf:	5e                   	pop    %esi
  8020c0:	5f                   	pop    %edi
  8020c1:	5d                   	pop    %ebp
  8020c2:	c3                   	ret    
  8020c3:	90                   	nop
  8020c4:	89 fd                	mov    %edi,%ebp
  8020c6:	85 ff                	test   %edi,%edi
  8020c8:	75 0b                	jne    8020d5 <__umoddi3+0xe9>
  8020ca:	b8 01 00 00 00       	mov    $0x1,%eax
  8020cf:	31 d2                	xor    %edx,%edx
  8020d1:	f7 f7                	div    %edi
  8020d3:	89 c5                	mov    %eax,%ebp
  8020d5:	89 f0                	mov    %esi,%eax
  8020d7:	31 d2                	xor    %edx,%edx
  8020d9:	f7 f5                	div    %ebp
  8020db:	89 c8                	mov    %ecx,%eax
  8020dd:	f7 f5                	div    %ebp
  8020df:	89 d0                	mov    %edx,%eax
  8020e1:	e9 44 ff ff ff       	jmp    80202a <__umoddi3+0x3e>
  8020e6:	66 90                	xchg   %ax,%ax
  8020e8:	89 c8                	mov    %ecx,%eax
  8020ea:	89 f2                	mov    %esi,%edx
  8020ec:	83 c4 1c             	add    $0x1c,%esp
  8020ef:	5b                   	pop    %ebx
  8020f0:	5e                   	pop    %esi
  8020f1:	5f                   	pop    %edi
  8020f2:	5d                   	pop    %ebp
  8020f3:	c3                   	ret    
  8020f4:	3b 04 24             	cmp    (%esp),%eax
  8020f7:	72 06                	jb     8020ff <__umoddi3+0x113>
  8020f9:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  8020fd:	77 0f                	ja     80210e <__umoddi3+0x122>
  8020ff:	89 f2                	mov    %esi,%edx
  802101:	29 f9                	sub    %edi,%ecx
  802103:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  802107:	89 14 24             	mov    %edx,(%esp)
  80210a:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80210e:	8b 44 24 04          	mov    0x4(%esp),%eax
  802112:	8b 14 24             	mov    (%esp),%edx
  802115:	83 c4 1c             	add    $0x1c,%esp
  802118:	5b                   	pop    %ebx
  802119:	5e                   	pop    %esi
  80211a:	5f                   	pop    %edi
  80211b:	5d                   	pop    %ebp
  80211c:	c3                   	ret    
  80211d:	8d 76 00             	lea    0x0(%esi),%esi
  802120:	2b 04 24             	sub    (%esp),%eax
  802123:	19 fa                	sbb    %edi,%edx
  802125:	89 d1                	mov    %edx,%ecx
  802127:	89 c6                	mov    %eax,%esi
  802129:	e9 71 ff ff ff       	jmp    80209f <__umoddi3+0xb3>
  80212e:	66 90                	xchg   %ax,%ax
  802130:	39 44 24 04          	cmp    %eax,0x4(%esp)
  802134:	72 ea                	jb     802120 <__umoddi3+0x134>
  802136:	89 d9                	mov    %ebx,%ecx
  802138:	e9 62 ff ff ff       	jmp    80209f <__umoddi3+0xb3>
