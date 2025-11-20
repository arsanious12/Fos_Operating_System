
obj/user/tst_chan_all_master:     file format elf32-i386


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
  800031:	e8 57 02 00 00       	call   80028d <libmain>
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
  800047:	68 00 21 80 00       	push   $0x802100
  80004c:	6a 0e                	push   $0xe
  80004e:	e8 e5 06 00 00       	call   800738 <cprintf_colored>
  800053:	83 c4 10             	add    $0x10,%esp
	cprintf_colored(TEXT_yellow,"MAKE SURE to have a FRESH RUN for this test\n(i.e. don't run any program/test before it)\n");
  800056:	83 ec 08             	sub    $0x8,%esp
  800059:	68 30 21 80 00       	push   $0x802130
  80005e:	6a 0e                	push   $0xe
  800060:	e8 d3 06 00 00       	call   800738 <cprintf_colored>
  800065:	83 c4 10             	add    $0x10,%esp
	cprintf_colored(TEXT_yellow,"==============================================\n");
  800068:	83 ec 08             	sub    $0x8,%esp
  80006b:	68 00 21 80 00       	push   $0x802100
  800070:	6a 0e                	push   $0xe
  800072:	e8 c1 06 00 00       	call   800738 <cprintf_colored>
  800077:	83 c4 10             	add    $0x10,%esp


	int envID = sys_getenvid();
  80007a:	e8 48 1a 00 00       	call   801ac7 <sys_getenvid>
  80007f:	89 45 d8             	mov    %eax,-0x28(%ebp)
	char slavesCnt[10];
	readline("Enter the number of Slave Programs: ", slavesCnt);
  800082:	83 ec 08             	sub    $0x8,%esp
  800085:	8d 45 ca             	lea    -0x36(%ebp),%eax
  800088:	50                   	push   %eax
  800089:	68 8c 21 80 00       	push   $0x80218c
  80008e:	e8 51 0d 00 00       	call   800de4 <readline>
  800093:	83 c4 10             	add    $0x10,%esp
	int numOfSlaves = strtol(slavesCnt, NULL, 10);
  800096:	83 ec 04             	sub    $0x4,%esp
  800099:	6a 0a                	push   $0xa
  80009b:	6a 00                	push   $0x0
  80009d:	8d 45 ca             	lea    -0x36(%ebp),%eax
  8000a0:	50                   	push   %eax
  8000a1:	e8 55 13 00 00       	call   8013fb <strtol>
  8000a6:	83 c4 10             	add    $0x10,%esp
  8000a9:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	//Create and run slave programs that should sleep
	int id;
	for (int i = 0; i < numOfSlaves; ++i)
  8000ac:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  8000b3:	eb 6a                	jmp    80011f <_main+0xe7>
	{
		id = sys_create_env("tstChanAllSlave", (myEnv->page_WS_max_size),(myEnv->SecondListSize), (myEnv->percentage_of_WS_pages_to_be_removed));
  8000b5:	a1 20 30 80 00       	mov    0x803020,%eax
  8000ba:	8b 90 94 05 00 00    	mov    0x594(%eax),%edx
  8000c0:	a1 20 30 80 00       	mov    0x803020,%eax
  8000c5:	8b 80 8c 05 00 00    	mov    0x58c(%eax),%eax
  8000cb:	89 c1                	mov    %eax,%ecx
  8000cd:	a1 20 30 80 00       	mov    0x803020,%eax
  8000d2:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
  8000d8:	52                   	push   %edx
  8000d9:	51                   	push   %ecx
  8000da:	50                   	push   %eax
  8000db:	68 b1 21 80 00       	push   $0x8021b1
  8000e0:	e8 8d 19 00 00       	call   801a72 <sys_create_env>
  8000e5:	83 c4 10             	add    $0x10,%esp
  8000e8:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		if (id== E_ENV_CREATION_ERROR)
  8000eb:	83 7d d4 ef          	cmpl   $0xffffffef,-0x2c(%ebp)
  8000ef:	75 1d                	jne    80010e <_main+0xd6>
		{
			cprintf_colored(TEXT_TESTERR_CLR, "\n%~insufficient number of processes in the system! only %d slave processes are created\n", i);
  8000f1:	83 ec 04             	sub    $0x4,%esp
  8000f4:	ff 75 e0             	pushl  -0x20(%ebp)
  8000f7:	68 c4 21 80 00       	push   $0x8021c4
  8000fc:	6a 0c                	push   $0xc
  8000fe:	e8 35 06 00 00       	call   800738 <cprintf_colored>
  800103:	83 c4 10             	add    $0x10,%esp
			numOfSlaves = i;
  800106:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800109:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			break;
  80010c:	eb 19                	jmp    800127 <_main+0xef>
		}
		sys_run_env(id);
  80010e:	83 ec 0c             	sub    $0xc,%esp
  800111:	ff 75 d4             	pushl  -0x2c(%ebp)
  800114:	e8 77 19 00 00       	call   801a90 <sys_run_env>
  800119:	83 c4 10             	add    $0x10,%esp
	readline("Enter the number of Slave Programs: ", slavesCnt);
	int numOfSlaves = strtol(slavesCnt, NULL, 10);

	//Create and run slave programs that should sleep
	int id;
	for (int i = 0; i < numOfSlaves; ++i)
  80011c:	ff 45 e0             	incl   -0x20(%ebp)
  80011f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800122:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800125:	7c 8e                	jl     8000b5 <_main+0x7d>
		}
		sys_run_env(id);
	}

	//Wait until all slaves are blocked
	int numOfBlockedProcesses = 0;
  800127:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
	char cmd1[64] = "__GetChanQueueSize__";
  80012e:	8d 45 84             	lea    -0x7c(%ebp),%eax
  800131:	bb 16 23 80 00       	mov    $0x802316,%ebx
  800136:	ba 15 00 00 00       	mov    $0x15,%edx
  80013b:	89 c7                	mov    %eax,%edi
  80013d:	89 de                	mov    %ebx,%esi
  80013f:	89 d1                	mov    %edx,%ecx
  800141:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  800143:	8d 55 99             	lea    -0x67(%ebp),%edx
  800146:	b9 2b 00 00 00       	mov    $0x2b,%ecx
  80014b:	b0 00                	mov    $0x0,%al
  80014d:	89 d7                	mov    %edx,%edi
  80014f:	f3 aa                	rep stos %al,%es:(%edi)
	sys_utilities(cmd1, (uint32)(&numOfBlockedProcesses));
  800151:	8d 45 c4             	lea    -0x3c(%ebp),%eax
  800154:	83 ec 08             	sub    $0x8,%esp
  800157:	50                   	push   %eax
  800158:	8d 45 84             	lea    -0x7c(%ebp),%eax
  80015b:	50                   	push   %eax
  80015c:	e8 b5 1b 00 00       	call   801d16 <sys_utilities>
  800161:	83 c4 10             	add    $0x10,%esp
	int cnt = 0;
  800164:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	while (numOfBlockedProcesses != numOfSlaves)
  80016b:	eb 75                	jmp    8001e2 <_main+0x1aa>
	{
		env_sleep(5000);
  80016d:	83 ec 0c             	sub    $0xc,%esp
  800170:	68 88 13 00 00       	push   $0x1388
  800175:	e8 28 1c 00 00       	call   801da2 <env_sleep>
  80017a:	83 c4 10             	add    $0x10,%esp
		if (cnt == numOfSlaves)
  80017d:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800180:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800183:	75 1b                	jne    8001a0 <_main+0x168>
		{
			panic("%~test channels failed! unexpected number of blocked slaves. Expected = %d, Current = %d", numOfSlaves, numOfBlockedProcesses);
  800185:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  800188:	83 ec 0c             	sub    $0xc,%esp
  80018b:	50                   	push   %eax
  80018c:	ff 75 e4             	pushl  -0x1c(%ebp)
  80018f:	68 1c 22 80 00       	push   $0x80221c
  800194:	6a 2a                	push   $0x2a
  800196:	68 75 22 80 00       	push   $0x802275
  80019b:	e8 9d 02 00 00       	call   80043d <_panic>
		}
		char cmd2[64] = "__GetChanQueueSize__";
  8001a0:	8d 85 04 ff ff ff    	lea    -0xfc(%ebp),%eax
  8001a6:	bb 16 23 80 00       	mov    $0x802316,%ebx
  8001ab:	ba 15 00 00 00       	mov    $0x15,%edx
  8001b0:	89 c7                	mov    %eax,%edi
  8001b2:	89 de                	mov    %ebx,%esi
  8001b4:	89 d1                	mov    %edx,%ecx
  8001b6:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  8001b8:	8d 95 19 ff ff ff    	lea    -0xe7(%ebp),%edx
  8001be:	b9 2b 00 00 00       	mov    $0x2b,%ecx
  8001c3:	b0 00                	mov    $0x0,%al
  8001c5:	89 d7                	mov    %edx,%edi
  8001c7:	f3 aa                	rep stos %al,%es:(%edi)
		sys_utilities(cmd2, (uint32)(&numOfBlockedProcesses));
  8001c9:	8d 45 c4             	lea    -0x3c(%ebp),%eax
  8001cc:	83 ec 08             	sub    $0x8,%esp
  8001cf:	50                   	push   %eax
  8001d0:	8d 85 04 ff ff ff    	lea    -0xfc(%ebp),%eax
  8001d6:	50                   	push   %eax
  8001d7:	e8 3a 1b 00 00       	call   801d16 <sys_utilities>
  8001dc:	83 c4 10             	add    $0x10,%esp
		cnt++ ;
  8001df:	ff 45 dc             	incl   -0x24(%ebp)
	//Wait until all slaves are blocked
	int numOfBlockedProcesses = 0;
	char cmd1[64] = "__GetChanQueueSize__";
	sys_utilities(cmd1, (uint32)(&numOfBlockedProcesses));
	int cnt = 0;
	while (numOfBlockedProcesses != numOfSlaves)
  8001e2:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8001e5:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8001e8:	75 83                	jne    80016d <_main+0x135>
		char cmd2[64] = "__GetChanQueueSize__";
		sys_utilities(cmd2, (uint32)(&numOfBlockedProcesses));
		cnt++ ;
	}

	rsttst();
  8001ea:	e8 cf 19 00 00       	call   801bbe <rsttst>

	//Wakeup all
	char cmd3[64] = "__WakeupAll__";
  8001ef:	8d 85 44 ff ff ff    	lea    -0xbc(%ebp),%eax
  8001f5:	bb 56 23 80 00       	mov    $0x802356,%ebx
  8001fa:	ba 0e 00 00 00       	mov    $0xe,%edx
  8001ff:	89 c7                	mov    %eax,%edi
  800201:	89 de                	mov    %ebx,%esi
  800203:	89 d1                	mov    %edx,%ecx
  800205:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  800207:	8d 95 52 ff ff ff    	lea    -0xae(%ebp),%edx
  80020d:	b9 32 00 00 00       	mov    $0x32,%ecx
  800212:	b0 00                	mov    $0x0,%al
  800214:	89 d7                	mov    %edx,%edi
  800216:	f3 aa                	rep stos %al,%es:(%edi)
	sys_utilities(cmd3, 0);
  800218:	83 ec 08             	sub    $0x8,%esp
  80021b:	6a 00                	push   $0x0
  80021d:	8d 85 44 ff ff ff    	lea    -0xbc(%ebp),%eax
  800223:	50                   	push   %eax
  800224:	e8 ed 1a 00 00       	call   801d16 <sys_utilities>
  800229:	83 c4 10             	add    $0x10,%esp

	//Wait until all slave finished
	cnt = 0;
  80022c:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	while (gettst() != numOfSlaves)
  800233:	eb 2f                	jmp    800264 <_main+0x22c>
	{
		env_sleep(5000);
  800235:	83 ec 0c             	sub    $0xc,%esp
  800238:	68 88 13 00 00       	push   $0x1388
  80023d:	e8 60 1b 00 00       	call   801da2 <env_sleep>
  800242:	83 c4 10             	add    $0x10,%esp
		if (cnt == numOfSlaves)
  800245:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800248:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  80024b:	75 14                	jne    800261 <_main+0x229>
		{
			panic("%~test channels failed! not all slaves finished");
  80024d:	83 ec 04             	sub    $0x4,%esp
  800250:	68 90 22 80 00       	push   $0x802290
  800255:	6a 3e                	push   $0x3e
  800257:	68 75 22 80 00       	push   $0x802275
  80025c:	e8 dc 01 00 00       	call   80043d <_panic>
		}
		cnt++ ;
  800261:	ff 45 dc             	incl   -0x24(%ebp)
	char cmd3[64] = "__WakeupAll__";
	sys_utilities(cmd3, 0);

	//Wait until all slave finished
	cnt = 0;
	while (gettst() != numOfSlaves)
  800264:	e8 cf 19 00 00       	call   801c38 <gettst>
  800269:	89 c2                	mov    %eax,%edx
  80026b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80026e:	39 c2                	cmp    %eax,%edx
  800270:	75 c3                	jne    800235 <_main+0x1fd>
			panic("%~test channels failed! not all slaves finished");
		}
		cnt++ ;
	}

	cprintf_colored(TEXT_light_green, "%~\n\nCongratulations!! Test of Channel (sleep & wakeup ALL) completed successfully!!\n\n");
  800272:	83 ec 08             	sub    $0x8,%esp
  800275:	68 c0 22 80 00       	push   $0x8022c0
  80027a:	6a 0a                	push   $0xa
  80027c:	e8 b7 04 00 00       	call   800738 <cprintf_colored>
  800281:	83 c4 10             	add    $0x10,%esp

	return;
  800284:	90                   	nop
}
  800285:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800288:	5b                   	pop    %ebx
  800289:	5e                   	pop    %esi
  80028a:	5f                   	pop    %edi
  80028b:	5d                   	pop    %ebp
  80028c:	c3                   	ret    

0080028d <libmain>:
volatile bool printStats = 1;

volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";
void
libmain(int argc, char **argv)
{
  80028d:	55                   	push   %ebp
  80028e:	89 e5                	mov    %esp,%ebp
  800290:	57                   	push   %edi
  800291:	56                   	push   %esi
  800292:	53                   	push   %ebx
  800293:	83 ec 7c             	sub    $0x7c,%esp
	//printStats = 1;
	int envIndex = sys_getenvindex();
  800296:	e8 45 18 00 00       	call   801ae0 <sys_getenvindex>
  80029b:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	myEnv = &(envs[envIndex]);
  80029e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8002a1:	89 d0                	mov    %edx,%eax
  8002a3:	c1 e0 02             	shl    $0x2,%eax
  8002a6:	01 d0                	add    %edx,%eax
  8002a8:	c1 e0 03             	shl    $0x3,%eax
  8002ab:	01 d0                	add    %edx,%eax
  8002ad:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  8002b4:	01 d0                	add    %edx,%eax
  8002b6:	c1 e0 02             	shl    $0x2,%eax
  8002b9:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8002be:	a3 20 30 80 00       	mov    %eax,0x803020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  8002c3:	a1 20 30 80 00       	mov    0x803020,%eax
  8002c8:	8a 40 20             	mov    0x20(%eax),%al
  8002cb:	84 c0                	test   %al,%al
  8002cd:	74 0d                	je     8002dc <libmain+0x4f>
		binaryname = myEnv->prog_name;
  8002cf:	a1 20 30 80 00       	mov    0x803020,%eax
  8002d4:	83 c0 20             	add    $0x20,%eax
  8002d7:	a3 04 30 80 00       	mov    %eax,0x803004

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8002dc:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8002e0:	7e 0a                	jle    8002ec <libmain+0x5f>
		binaryname = argv[0];
  8002e2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8002e5:	8b 00                	mov    (%eax),%eax
  8002e7:	a3 04 30 80 00       	mov    %eax,0x803004

	// call user main routine
	_main(argc, argv);
  8002ec:	83 ec 08             	sub    $0x8,%esp
  8002ef:	ff 75 0c             	pushl  0xc(%ebp)
  8002f2:	ff 75 08             	pushl  0x8(%ebp)
  8002f5:	e8 3e fd ff ff       	call   800038 <_main>
  8002fa:	83 c4 10             	add    $0x10,%esp

	if (printStats)
  8002fd:	a1 00 30 80 00       	mov    0x803000,%eax
  800302:	85 c0                	test   %eax,%eax
  800304:	0f 84 01 01 00 00    	je     80040b <libmain+0x17e>
	{
		char isOPTReplCmd[100] = "__IsOPTRepl__" ;
  80030a:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  800310:	bb 90 24 80 00       	mov    $0x802490,%ebx
  800315:	ba 0e 00 00 00       	mov    $0xe,%edx
  80031a:	89 c7                	mov    %eax,%edi
  80031c:	89 de                	mov    %ebx,%esi
  80031e:	89 d1                	mov    %edx,%ecx
  800320:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  800322:	8d 55 8a             	lea    -0x76(%ebp),%edx
  800325:	b9 56 00 00 00       	mov    $0x56,%ecx
  80032a:	b0 00                	mov    $0x0,%al
  80032c:	89 d7                	mov    %edx,%edi
  80032e:	f3 aa                	rep stos %al,%es:(%edi)
		int isOPTRepl = 0;
  800330:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
		sys_utilities(isOPTReplCmd, (uint32)(&isOPTRepl));
  800337:	8d 45 e0             	lea    -0x20(%ebp),%eax
  80033a:	83 ec 08             	sub    $0x8,%esp
  80033d:	50                   	push   %eax
  80033e:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  800344:	50                   	push   %eax
  800345:	e8 cc 19 00 00       	call   801d16 <sys_utilities>
  80034a:	83 c4 10             	add    $0x10,%esp

		sys_lock_cons();
  80034d:	e8 15 15 00 00       	call   801867 <sys_lock_cons>
		{
			cprintf("**************************************\n");
  800352:	83 ec 0c             	sub    $0xc,%esp
  800355:	68 b0 23 80 00       	push   $0x8023b0
  80035a:	e8 ac 03 00 00       	call   80070b <cprintf>
  80035f:	83 c4 10             	add    $0x10,%esp
			if (isOPTRepl)
  800362:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800365:	85 c0                	test   %eax,%eax
  800367:	74 18                	je     800381 <libmain+0xf4>
			{
				cprintf("OPTIMAL number of page faults = %d\n", sys_get_optimal_num_faults());
  800369:	e8 c6 19 00 00       	call   801d34 <sys_get_optimal_num_faults>
  80036e:	83 ec 08             	sub    $0x8,%esp
  800371:	50                   	push   %eax
  800372:	68 d8 23 80 00       	push   $0x8023d8
  800377:	e8 8f 03 00 00       	call   80070b <cprintf>
  80037c:	83 c4 10             	add    $0x10,%esp
  80037f:	eb 59                	jmp    8003da <libmain+0x14d>
			}
			else
			{
				cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  800381:	a1 20 30 80 00       	mov    0x803020,%eax
  800386:	8b 90 a8 05 00 00    	mov    0x5a8(%eax),%edx
  80038c:	a1 20 30 80 00       	mov    0x803020,%eax
  800391:	8b 80 98 05 00 00    	mov    0x598(%eax),%eax
  800397:	83 ec 04             	sub    $0x4,%esp
  80039a:	52                   	push   %edx
  80039b:	50                   	push   %eax
  80039c:	68 fc 23 80 00       	push   $0x8023fc
  8003a1:	e8 65 03 00 00       	call   80070b <cprintf>
  8003a6:	83 c4 10             	add    $0x10,%esp
				cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  8003a9:	a1 20 30 80 00       	mov    0x803020,%eax
  8003ae:	8b 88 bc 05 00 00    	mov    0x5bc(%eax),%ecx
  8003b4:	a1 20 30 80 00       	mov    0x803020,%eax
  8003b9:	8b 90 b8 05 00 00    	mov    0x5b8(%eax),%edx
  8003bf:	a1 20 30 80 00       	mov    0x803020,%eax
  8003c4:	8b 80 b4 05 00 00    	mov    0x5b4(%eax),%eax
  8003ca:	51                   	push   %ecx
  8003cb:	52                   	push   %edx
  8003cc:	50                   	push   %eax
  8003cd:	68 24 24 80 00       	push   $0x802424
  8003d2:	e8 34 03 00 00       	call   80070b <cprintf>
  8003d7:	83 c4 10             	add    $0x10,%esp
			}
			//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
			cprintf("Num of clocks = %d\n", myEnv->nClocks);
  8003da:	a1 20 30 80 00       	mov    0x803020,%eax
  8003df:	8b 80 c0 05 00 00    	mov    0x5c0(%eax),%eax
  8003e5:	83 ec 08             	sub    $0x8,%esp
  8003e8:	50                   	push   %eax
  8003e9:	68 7c 24 80 00       	push   $0x80247c
  8003ee:	e8 18 03 00 00       	call   80070b <cprintf>
  8003f3:	83 c4 10             	add    $0x10,%esp
			cprintf("**************************************\n");
  8003f6:	83 ec 0c             	sub    $0xc,%esp
  8003f9:	68 b0 23 80 00       	push   $0x8023b0
  8003fe:	e8 08 03 00 00       	call   80070b <cprintf>
  800403:	83 c4 10             	add    $0x10,%esp
		}
		sys_unlock_cons();
  800406:	e8 76 14 00 00       	call   801881 <sys_unlock_cons>
	}

	// exit gracefully
	exit();
  80040b:	e8 1f 00 00 00       	call   80042f <exit>
}
  800410:	90                   	nop
  800411:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800414:	5b                   	pop    %ebx
  800415:	5e                   	pop    %esi
  800416:	5f                   	pop    %edi
  800417:	5d                   	pop    %ebp
  800418:	c3                   	ret    

00800419 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800419:	55                   	push   %ebp
  80041a:	89 e5                	mov    %esp,%ebp
  80041c:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  80041f:	83 ec 0c             	sub    $0xc,%esp
  800422:	6a 00                	push   $0x0
  800424:	e8 83 16 00 00       	call   801aac <sys_destroy_env>
  800429:	83 c4 10             	add    $0x10,%esp
}
  80042c:	90                   	nop
  80042d:	c9                   	leave  
  80042e:	c3                   	ret    

0080042f <exit>:

void
exit(void)
{
  80042f:	55                   	push   %ebp
  800430:	89 e5                	mov    %esp,%ebp
  800432:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  800435:	e8 d8 16 00 00       	call   801b12 <sys_exit_env>
}
  80043a:	90                   	nop
  80043b:	c9                   	leave  
  80043c:	c3                   	ret    

0080043d <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  80043d:	55                   	push   %ebp
  80043e:	89 e5                	mov    %esp,%ebp
  800440:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  800443:	8d 45 10             	lea    0x10(%ebp),%eax
  800446:	83 c0 04             	add    $0x4,%eax
  800449:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  80044c:	a1 18 b1 81 00       	mov    0x81b118,%eax
  800451:	85 c0                	test   %eax,%eax
  800453:	74 16                	je     80046b <_panic+0x2e>
		cprintf("%s: ", argv0);
  800455:	a1 18 b1 81 00       	mov    0x81b118,%eax
  80045a:	83 ec 08             	sub    $0x8,%esp
  80045d:	50                   	push   %eax
  80045e:	68 f4 24 80 00       	push   $0x8024f4
  800463:	e8 a3 02 00 00       	call   80070b <cprintf>
  800468:	83 c4 10             	add    $0x10,%esp
	cprintf_colored(TEXT_PANIC_CLR, "user [EVAL_FINAL]panic in %s at %s:%d: ", binaryname, file, line);
  80046b:	a1 04 30 80 00       	mov    0x803004,%eax
  800470:	83 ec 0c             	sub    $0xc,%esp
  800473:	ff 75 0c             	pushl  0xc(%ebp)
  800476:	ff 75 08             	pushl  0x8(%ebp)
  800479:	50                   	push   %eax
  80047a:	68 fc 24 80 00       	push   $0x8024fc
  80047f:	6a 74                	push   $0x74
  800481:	e8 b2 02 00 00       	call   800738 <cprintf_colored>
  800486:	83 c4 20             	add    $0x20,%esp
	vcprintf(fmt, ap);
  800489:	8b 45 10             	mov    0x10(%ebp),%eax
  80048c:	83 ec 08             	sub    $0x8,%esp
  80048f:	ff 75 f4             	pushl  -0xc(%ebp)
  800492:	50                   	push   %eax
  800493:	e8 04 02 00 00       	call   80069c <vcprintf>
  800498:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  80049b:	83 ec 08             	sub    $0x8,%esp
  80049e:	6a 00                	push   $0x0
  8004a0:	68 24 25 80 00       	push   $0x802524
  8004a5:	e8 f2 01 00 00       	call   80069c <vcprintf>
  8004aa:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  8004ad:	e8 7d ff ff ff       	call   80042f <exit>

	// should not return here
	while (1) ;
  8004b2:	eb fe                	jmp    8004b2 <_panic+0x75>

008004b4 <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  8004b4:	55                   	push   %ebp
  8004b5:	89 e5                	mov    %esp,%ebp
  8004b7:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  8004ba:	a1 20 30 80 00       	mov    0x803020,%eax
  8004bf:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  8004c5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004c8:	39 c2                	cmp    %eax,%edx
  8004ca:	74 14                	je     8004e0 <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  8004cc:	83 ec 04             	sub    $0x4,%esp
  8004cf:	68 28 25 80 00       	push   $0x802528
  8004d4:	6a 26                	push   $0x26
  8004d6:	68 74 25 80 00       	push   $0x802574
  8004db:	e8 5d ff ff ff       	call   80043d <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  8004e0:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  8004e7:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8004ee:	e9 c5 00 00 00       	jmp    8005b8 <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  8004f3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8004f6:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8004fd:	8b 45 08             	mov    0x8(%ebp),%eax
  800500:	01 d0                	add    %edx,%eax
  800502:	8b 00                	mov    (%eax),%eax
  800504:	85 c0                	test   %eax,%eax
  800506:	75 08                	jne    800510 <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  800508:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  80050b:	e9 a5 00 00 00       	jmp    8005b5 <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  800510:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800517:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  80051e:	eb 69                	jmp    800589 <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  800520:	a1 20 30 80 00       	mov    0x803020,%eax
  800525:	8b 88 90 05 00 00    	mov    0x590(%eax),%ecx
  80052b:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80052e:	89 d0                	mov    %edx,%eax
  800530:	01 c0                	add    %eax,%eax
  800532:	01 d0                	add    %edx,%eax
  800534:	c1 e0 03             	shl    $0x3,%eax
  800537:	01 c8                	add    %ecx,%eax
  800539:	8a 40 04             	mov    0x4(%eax),%al
  80053c:	84 c0                	test   %al,%al
  80053e:	75 46                	jne    800586 <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800540:	a1 20 30 80 00       	mov    0x803020,%eax
  800545:	8b 88 90 05 00 00    	mov    0x590(%eax),%ecx
  80054b:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80054e:	89 d0                	mov    %edx,%eax
  800550:	01 c0                	add    %eax,%eax
  800552:	01 d0                	add    %edx,%eax
  800554:	c1 e0 03             	shl    $0x3,%eax
  800557:	01 c8                	add    %ecx,%eax
  800559:	8b 00                	mov    (%eax),%eax
  80055b:	89 45 dc             	mov    %eax,-0x24(%ebp)
  80055e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800561:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800566:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  800568:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80056b:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800572:	8b 45 08             	mov    0x8(%ebp),%eax
  800575:	01 c8                	add    %ecx,%eax
  800577:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800579:	39 c2                	cmp    %eax,%edx
  80057b:	75 09                	jne    800586 <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  80057d:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  800584:	eb 15                	jmp    80059b <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800586:	ff 45 e8             	incl   -0x18(%ebp)
  800589:	a1 20 30 80 00       	mov    0x803020,%eax
  80058e:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  800594:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800597:	39 c2                	cmp    %eax,%edx
  800599:	77 85                	ja     800520 <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  80059b:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80059f:	75 14                	jne    8005b5 <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  8005a1:	83 ec 04             	sub    $0x4,%esp
  8005a4:	68 80 25 80 00       	push   $0x802580
  8005a9:	6a 3a                	push   $0x3a
  8005ab:	68 74 25 80 00       	push   $0x802574
  8005b0:	e8 88 fe ff ff       	call   80043d <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  8005b5:	ff 45 f0             	incl   -0x10(%ebp)
  8005b8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8005bb:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8005be:	0f 8c 2f ff ff ff    	jl     8004f3 <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  8005c4:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8005cb:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  8005d2:	eb 26                	jmp    8005fa <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  8005d4:	a1 20 30 80 00       	mov    0x803020,%eax
  8005d9:	8b 88 90 05 00 00    	mov    0x590(%eax),%ecx
  8005df:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8005e2:	89 d0                	mov    %edx,%eax
  8005e4:	01 c0                	add    %eax,%eax
  8005e6:	01 d0                	add    %edx,%eax
  8005e8:	c1 e0 03             	shl    $0x3,%eax
  8005eb:	01 c8                	add    %ecx,%eax
  8005ed:	8a 40 04             	mov    0x4(%eax),%al
  8005f0:	3c 01                	cmp    $0x1,%al
  8005f2:	75 03                	jne    8005f7 <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  8005f4:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8005f7:	ff 45 e0             	incl   -0x20(%ebp)
  8005fa:	a1 20 30 80 00       	mov    0x803020,%eax
  8005ff:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  800605:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800608:	39 c2                	cmp    %eax,%edx
  80060a:	77 c8                	ja     8005d4 <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  80060c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80060f:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800612:	74 14                	je     800628 <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  800614:	83 ec 04             	sub    $0x4,%esp
  800617:	68 d4 25 80 00       	push   $0x8025d4
  80061c:	6a 44                	push   $0x44
  80061e:	68 74 25 80 00       	push   $0x802574
  800623:	e8 15 fe ff ff       	call   80043d <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  800628:	90                   	nop
  800629:	c9                   	leave  
  80062a:	c3                   	ret    

0080062b <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  80062b:	55                   	push   %ebp
  80062c:	89 e5                	mov    %esp,%ebp
  80062e:	53                   	push   %ebx
  80062f:	83 ec 04             	sub    $0x4,%esp
	b->buf[b->idx++] = ch;
  800632:	8b 45 0c             	mov    0xc(%ebp),%eax
  800635:	8b 00                	mov    (%eax),%eax
  800637:	8d 48 01             	lea    0x1(%eax),%ecx
  80063a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80063d:	89 0a                	mov    %ecx,(%edx)
  80063f:	8b 55 08             	mov    0x8(%ebp),%edx
  800642:	88 d1                	mov    %dl,%cl
  800644:	8b 55 0c             	mov    0xc(%ebp),%edx
  800647:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  80064b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80064e:	8b 00                	mov    (%eax),%eax
  800650:	3d ff 00 00 00       	cmp    $0xff,%eax
  800655:	75 30                	jne    800687 <putch+0x5c>
		sys_cputs(b->buf, b->idx, printProgName, curTextClr);
  800657:	8b 15 1c b1 81 00    	mov    0x81b11c,%edx
  80065d:	a0 44 30 80 00       	mov    0x803044,%al
  800662:	0f b6 c0             	movzbl %al,%eax
  800665:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800668:	8b 09                	mov    (%ecx),%ecx
  80066a:	89 cb                	mov    %ecx,%ebx
  80066c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80066f:	83 c1 08             	add    $0x8,%ecx
  800672:	52                   	push   %edx
  800673:	50                   	push   %eax
  800674:	53                   	push   %ebx
  800675:	51                   	push   %ecx
  800676:	e8 a8 11 00 00       	call   801823 <sys_cputs>
  80067b:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  80067e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800681:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800687:	8b 45 0c             	mov    0xc(%ebp),%eax
  80068a:	8b 40 04             	mov    0x4(%eax),%eax
  80068d:	8d 50 01             	lea    0x1(%eax),%edx
  800690:	8b 45 0c             	mov    0xc(%ebp),%eax
  800693:	89 50 04             	mov    %edx,0x4(%eax)
}
  800696:	90                   	nop
  800697:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80069a:	c9                   	leave  
  80069b:	c3                   	ret    

0080069c <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  80069c:	55                   	push   %ebp
  80069d:	89 e5                	mov    %esp,%ebp
  80069f:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8006a5:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8006ac:	00 00 00 
	b.cnt = 0;
  8006af:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8006b6:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  8006b9:	ff 75 0c             	pushl  0xc(%ebp)
  8006bc:	ff 75 08             	pushl  0x8(%ebp)
  8006bf:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8006c5:	50                   	push   %eax
  8006c6:	68 2b 06 80 00       	push   $0x80062b
  8006cb:	e8 5a 02 00 00       	call   80092a <vprintfmt>
  8006d0:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName, curTextClr);
  8006d3:	8b 15 1c b1 81 00    	mov    0x81b11c,%edx
  8006d9:	a0 44 30 80 00       	mov    0x803044,%al
  8006de:	0f b6 c0             	movzbl %al,%eax
  8006e1:	8b 8d f0 fe ff ff    	mov    -0x110(%ebp),%ecx
  8006e7:	52                   	push   %edx
  8006e8:	50                   	push   %eax
  8006e9:	51                   	push   %ecx
  8006ea:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8006f0:	83 c0 08             	add    $0x8,%eax
  8006f3:	50                   	push   %eax
  8006f4:	e8 2a 11 00 00       	call   801823 <sys_cputs>
  8006f9:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  8006fc:	c6 05 44 30 80 00 00 	movb   $0x0,0x803044
	return b.cnt;
  800703:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800709:	c9                   	leave  
  80070a:	c3                   	ret    

0080070b <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  80070b:	55                   	push   %ebp
  80070c:	89 e5                	mov    %esp,%ebp
  80070e:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800711:	c6 05 44 30 80 00 01 	movb   $0x1,0x803044
	va_start(ap, fmt);
  800718:	8d 45 0c             	lea    0xc(%ebp),%eax
  80071b:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  80071e:	8b 45 08             	mov    0x8(%ebp),%eax
  800721:	83 ec 08             	sub    $0x8,%esp
  800724:	ff 75 f4             	pushl  -0xc(%ebp)
  800727:	50                   	push   %eax
  800728:	e8 6f ff ff ff       	call   80069c <vcprintf>
  80072d:	83 c4 10             	add    $0x10,%esp
  800730:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800733:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800736:	c9                   	leave  
  800737:	c3                   	ret    

00800738 <cprintf_colored>:

// *************** This text coloring feature is implemented by *************
// ********** Abd-Alrahman Zedan From Team Frozen-Bytes - FCIS'24-25 ********
int cprintf_colored(int textClr, const char *fmt, ...) {
  800738:	55                   	push   %ebp
  800739:	89 e5                	mov    %esp,%ebp
  80073b:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  80073e:	c6 05 44 30 80 00 01 	movb   $0x1,0x803044
	curTextClr = (textClr << 8) ; //set text color by the given value
  800745:	8b 45 08             	mov    0x8(%ebp),%eax
  800748:	c1 e0 08             	shl    $0x8,%eax
  80074b:	a3 1c b1 81 00       	mov    %eax,0x81b11c
	va_start(ap, fmt);
  800750:	8d 45 0c             	lea    0xc(%ebp),%eax
  800753:	83 c0 04             	add    $0x4,%eax
  800756:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800759:	8b 45 0c             	mov    0xc(%ebp),%eax
  80075c:	83 ec 08             	sub    $0x8,%esp
  80075f:	ff 75 f4             	pushl  -0xc(%ebp)
  800762:	50                   	push   %eax
  800763:	e8 34 ff ff ff       	call   80069c <vcprintf>
  800768:	83 c4 10             	add    $0x10,%esp
  80076b:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);
	curTextClr = TEXT_DEFAULT_CLR; //restore default color
  80076e:	c7 05 1c b1 81 00 00 	movl   $0x700,0x81b11c
  800775:	07 00 00 

	return cnt;
  800778:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80077b:	c9                   	leave  
  80077c:	c3                   	ret    

0080077d <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  80077d:	55                   	push   %ebp
  80077e:	89 e5                	mov    %esp,%ebp
  800780:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  800783:	e8 df 10 00 00       	call   801867 <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  800788:	8d 45 0c             	lea    0xc(%ebp),%eax
  80078b:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  80078e:	8b 45 08             	mov    0x8(%ebp),%eax
  800791:	83 ec 08             	sub    $0x8,%esp
  800794:	ff 75 f4             	pushl  -0xc(%ebp)
  800797:	50                   	push   %eax
  800798:	e8 ff fe ff ff       	call   80069c <vcprintf>
  80079d:	83 c4 10             	add    $0x10,%esp
  8007a0:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  8007a3:	e8 d9 10 00 00       	call   801881 <sys_unlock_cons>
	return cnt;
  8007a8:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8007ab:	c9                   	leave  
  8007ac:	c3                   	ret    

008007ad <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8007ad:	55                   	push   %ebp
  8007ae:	89 e5                	mov    %esp,%ebp
  8007b0:	53                   	push   %ebx
  8007b1:	83 ec 14             	sub    $0x14,%esp
  8007b4:	8b 45 10             	mov    0x10(%ebp),%eax
  8007b7:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8007ba:	8b 45 14             	mov    0x14(%ebp),%eax
  8007bd:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8007c0:	8b 45 18             	mov    0x18(%ebp),%eax
  8007c3:	ba 00 00 00 00       	mov    $0x0,%edx
  8007c8:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8007cb:	77 55                	ja     800822 <printnum+0x75>
  8007cd:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8007d0:	72 05                	jb     8007d7 <printnum+0x2a>
  8007d2:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8007d5:	77 4b                	ja     800822 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8007d7:	8b 45 1c             	mov    0x1c(%ebp),%eax
  8007da:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8007dd:	8b 45 18             	mov    0x18(%ebp),%eax
  8007e0:	ba 00 00 00 00       	mov    $0x0,%edx
  8007e5:	52                   	push   %edx
  8007e6:	50                   	push   %eax
  8007e7:	ff 75 f4             	pushl  -0xc(%ebp)
  8007ea:	ff 75 f0             	pushl  -0x10(%ebp)
  8007ed:	e8 aa 16 00 00       	call   801e9c <__udivdi3>
  8007f2:	83 c4 10             	add    $0x10,%esp
  8007f5:	83 ec 04             	sub    $0x4,%esp
  8007f8:	ff 75 20             	pushl  0x20(%ebp)
  8007fb:	53                   	push   %ebx
  8007fc:	ff 75 18             	pushl  0x18(%ebp)
  8007ff:	52                   	push   %edx
  800800:	50                   	push   %eax
  800801:	ff 75 0c             	pushl  0xc(%ebp)
  800804:	ff 75 08             	pushl  0x8(%ebp)
  800807:	e8 a1 ff ff ff       	call   8007ad <printnum>
  80080c:	83 c4 20             	add    $0x20,%esp
  80080f:	eb 1a                	jmp    80082b <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800811:	83 ec 08             	sub    $0x8,%esp
  800814:	ff 75 0c             	pushl  0xc(%ebp)
  800817:	ff 75 20             	pushl  0x20(%ebp)
  80081a:	8b 45 08             	mov    0x8(%ebp),%eax
  80081d:	ff d0                	call   *%eax
  80081f:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800822:	ff 4d 1c             	decl   0x1c(%ebp)
  800825:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800829:	7f e6                	jg     800811 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80082b:	8b 4d 18             	mov    0x18(%ebp),%ecx
  80082e:	bb 00 00 00 00       	mov    $0x0,%ebx
  800833:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800836:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800839:	53                   	push   %ebx
  80083a:	51                   	push   %ecx
  80083b:	52                   	push   %edx
  80083c:	50                   	push   %eax
  80083d:	e8 6a 17 00 00       	call   801fac <__umoddi3>
  800842:	83 c4 10             	add    $0x10,%esp
  800845:	05 34 28 80 00       	add    $0x802834,%eax
  80084a:	8a 00                	mov    (%eax),%al
  80084c:	0f be c0             	movsbl %al,%eax
  80084f:	83 ec 08             	sub    $0x8,%esp
  800852:	ff 75 0c             	pushl  0xc(%ebp)
  800855:	50                   	push   %eax
  800856:	8b 45 08             	mov    0x8(%ebp),%eax
  800859:	ff d0                	call   *%eax
  80085b:	83 c4 10             	add    $0x10,%esp
}
  80085e:	90                   	nop
  80085f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800862:	c9                   	leave  
  800863:	c3                   	ret    

00800864 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800864:	55                   	push   %ebp
  800865:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800867:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  80086b:	7e 1c                	jle    800889 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  80086d:	8b 45 08             	mov    0x8(%ebp),%eax
  800870:	8b 00                	mov    (%eax),%eax
  800872:	8d 50 08             	lea    0x8(%eax),%edx
  800875:	8b 45 08             	mov    0x8(%ebp),%eax
  800878:	89 10                	mov    %edx,(%eax)
  80087a:	8b 45 08             	mov    0x8(%ebp),%eax
  80087d:	8b 00                	mov    (%eax),%eax
  80087f:	83 e8 08             	sub    $0x8,%eax
  800882:	8b 50 04             	mov    0x4(%eax),%edx
  800885:	8b 00                	mov    (%eax),%eax
  800887:	eb 40                	jmp    8008c9 <getuint+0x65>
	else if (lflag)
  800889:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80088d:	74 1e                	je     8008ad <getuint+0x49>
		return va_arg(*ap, unsigned long);
  80088f:	8b 45 08             	mov    0x8(%ebp),%eax
  800892:	8b 00                	mov    (%eax),%eax
  800894:	8d 50 04             	lea    0x4(%eax),%edx
  800897:	8b 45 08             	mov    0x8(%ebp),%eax
  80089a:	89 10                	mov    %edx,(%eax)
  80089c:	8b 45 08             	mov    0x8(%ebp),%eax
  80089f:	8b 00                	mov    (%eax),%eax
  8008a1:	83 e8 04             	sub    $0x4,%eax
  8008a4:	8b 00                	mov    (%eax),%eax
  8008a6:	ba 00 00 00 00       	mov    $0x0,%edx
  8008ab:	eb 1c                	jmp    8008c9 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  8008ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8008b0:	8b 00                	mov    (%eax),%eax
  8008b2:	8d 50 04             	lea    0x4(%eax),%edx
  8008b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8008b8:	89 10                	mov    %edx,(%eax)
  8008ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8008bd:	8b 00                	mov    (%eax),%eax
  8008bf:	83 e8 04             	sub    $0x4,%eax
  8008c2:	8b 00                	mov    (%eax),%eax
  8008c4:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8008c9:	5d                   	pop    %ebp
  8008ca:	c3                   	ret    

008008cb <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8008cb:	55                   	push   %ebp
  8008cc:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8008ce:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8008d2:	7e 1c                	jle    8008f0 <getint+0x25>
		return va_arg(*ap, long long);
  8008d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8008d7:	8b 00                	mov    (%eax),%eax
  8008d9:	8d 50 08             	lea    0x8(%eax),%edx
  8008dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8008df:	89 10                	mov    %edx,(%eax)
  8008e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8008e4:	8b 00                	mov    (%eax),%eax
  8008e6:	83 e8 08             	sub    $0x8,%eax
  8008e9:	8b 50 04             	mov    0x4(%eax),%edx
  8008ec:	8b 00                	mov    (%eax),%eax
  8008ee:	eb 38                	jmp    800928 <getint+0x5d>
	else if (lflag)
  8008f0:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8008f4:	74 1a                	je     800910 <getint+0x45>
		return va_arg(*ap, long);
  8008f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8008f9:	8b 00                	mov    (%eax),%eax
  8008fb:	8d 50 04             	lea    0x4(%eax),%edx
  8008fe:	8b 45 08             	mov    0x8(%ebp),%eax
  800901:	89 10                	mov    %edx,(%eax)
  800903:	8b 45 08             	mov    0x8(%ebp),%eax
  800906:	8b 00                	mov    (%eax),%eax
  800908:	83 e8 04             	sub    $0x4,%eax
  80090b:	8b 00                	mov    (%eax),%eax
  80090d:	99                   	cltd   
  80090e:	eb 18                	jmp    800928 <getint+0x5d>
	else
		return va_arg(*ap, int);
  800910:	8b 45 08             	mov    0x8(%ebp),%eax
  800913:	8b 00                	mov    (%eax),%eax
  800915:	8d 50 04             	lea    0x4(%eax),%edx
  800918:	8b 45 08             	mov    0x8(%ebp),%eax
  80091b:	89 10                	mov    %edx,(%eax)
  80091d:	8b 45 08             	mov    0x8(%ebp),%eax
  800920:	8b 00                	mov    (%eax),%eax
  800922:	83 e8 04             	sub    $0x4,%eax
  800925:	8b 00                	mov    (%eax),%eax
  800927:	99                   	cltd   
}
  800928:	5d                   	pop    %ebp
  800929:	c3                   	ret    

0080092a <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  80092a:	55                   	push   %ebp
  80092b:	89 e5                	mov    %esp,%ebp
  80092d:	56                   	push   %esi
  80092e:	53                   	push   %ebx
  80092f:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800932:	eb 17                	jmp    80094b <vprintfmt+0x21>
			if (ch == '\0')
  800934:	85 db                	test   %ebx,%ebx
  800936:	0f 84 c1 03 00 00    	je     800cfd <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  80093c:	83 ec 08             	sub    $0x8,%esp
  80093f:	ff 75 0c             	pushl  0xc(%ebp)
  800942:	53                   	push   %ebx
  800943:	8b 45 08             	mov    0x8(%ebp),%eax
  800946:	ff d0                	call   *%eax
  800948:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80094b:	8b 45 10             	mov    0x10(%ebp),%eax
  80094e:	8d 50 01             	lea    0x1(%eax),%edx
  800951:	89 55 10             	mov    %edx,0x10(%ebp)
  800954:	8a 00                	mov    (%eax),%al
  800956:	0f b6 d8             	movzbl %al,%ebx
  800959:	83 fb 25             	cmp    $0x25,%ebx
  80095c:	75 d6                	jne    800934 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  80095e:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800962:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800969:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800970:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800977:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80097e:	8b 45 10             	mov    0x10(%ebp),%eax
  800981:	8d 50 01             	lea    0x1(%eax),%edx
  800984:	89 55 10             	mov    %edx,0x10(%ebp)
  800987:	8a 00                	mov    (%eax),%al
  800989:	0f b6 d8             	movzbl %al,%ebx
  80098c:	8d 43 dd             	lea    -0x23(%ebx),%eax
  80098f:	83 f8 5b             	cmp    $0x5b,%eax
  800992:	0f 87 3d 03 00 00    	ja     800cd5 <vprintfmt+0x3ab>
  800998:	8b 04 85 58 28 80 00 	mov    0x802858(,%eax,4),%eax
  80099f:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  8009a1:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  8009a5:	eb d7                	jmp    80097e <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8009a7:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  8009ab:	eb d1                	jmp    80097e <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8009ad:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  8009b4:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8009b7:	89 d0                	mov    %edx,%eax
  8009b9:	c1 e0 02             	shl    $0x2,%eax
  8009bc:	01 d0                	add    %edx,%eax
  8009be:	01 c0                	add    %eax,%eax
  8009c0:	01 d8                	add    %ebx,%eax
  8009c2:	83 e8 30             	sub    $0x30,%eax
  8009c5:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  8009c8:	8b 45 10             	mov    0x10(%ebp),%eax
  8009cb:	8a 00                	mov    (%eax),%al
  8009cd:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8009d0:	83 fb 2f             	cmp    $0x2f,%ebx
  8009d3:	7e 3e                	jle    800a13 <vprintfmt+0xe9>
  8009d5:	83 fb 39             	cmp    $0x39,%ebx
  8009d8:	7f 39                	jg     800a13 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8009da:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8009dd:	eb d5                	jmp    8009b4 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8009df:	8b 45 14             	mov    0x14(%ebp),%eax
  8009e2:	83 c0 04             	add    $0x4,%eax
  8009e5:	89 45 14             	mov    %eax,0x14(%ebp)
  8009e8:	8b 45 14             	mov    0x14(%ebp),%eax
  8009eb:	83 e8 04             	sub    $0x4,%eax
  8009ee:	8b 00                	mov    (%eax),%eax
  8009f0:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  8009f3:	eb 1f                	jmp    800a14 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  8009f5:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8009f9:	79 83                	jns    80097e <vprintfmt+0x54>
				width = 0;
  8009fb:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800a02:	e9 77 ff ff ff       	jmp    80097e <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800a07:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800a0e:	e9 6b ff ff ff       	jmp    80097e <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800a13:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800a14:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a18:	0f 89 60 ff ff ff    	jns    80097e <vprintfmt+0x54>
				width = precision, precision = -1;
  800a1e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800a21:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800a24:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800a2b:	e9 4e ff ff ff       	jmp    80097e <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800a30:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800a33:	e9 46 ff ff ff       	jmp    80097e <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800a38:	8b 45 14             	mov    0x14(%ebp),%eax
  800a3b:	83 c0 04             	add    $0x4,%eax
  800a3e:	89 45 14             	mov    %eax,0x14(%ebp)
  800a41:	8b 45 14             	mov    0x14(%ebp),%eax
  800a44:	83 e8 04             	sub    $0x4,%eax
  800a47:	8b 00                	mov    (%eax),%eax
  800a49:	83 ec 08             	sub    $0x8,%esp
  800a4c:	ff 75 0c             	pushl  0xc(%ebp)
  800a4f:	50                   	push   %eax
  800a50:	8b 45 08             	mov    0x8(%ebp),%eax
  800a53:	ff d0                	call   *%eax
  800a55:	83 c4 10             	add    $0x10,%esp
			break;
  800a58:	e9 9b 02 00 00       	jmp    800cf8 <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800a5d:	8b 45 14             	mov    0x14(%ebp),%eax
  800a60:	83 c0 04             	add    $0x4,%eax
  800a63:	89 45 14             	mov    %eax,0x14(%ebp)
  800a66:	8b 45 14             	mov    0x14(%ebp),%eax
  800a69:	83 e8 04             	sub    $0x4,%eax
  800a6c:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800a6e:	85 db                	test   %ebx,%ebx
  800a70:	79 02                	jns    800a74 <vprintfmt+0x14a>
				err = -err;
  800a72:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800a74:	83 fb 64             	cmp    $0x64,%ebx
  800a77:	7f 0b                	jg     800a84 <vprintfmt+0x15a>
  800a79:	8b 34 9d a0 26 80 00 	mov    0x8026a0(,%ebx,4),%esi
  800a80:	85 f6                	test   %esi,%esi
  800a82:	75 19                	jne    800a9d <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800a84:	53                   	push   %ebx
  800a85:	68 45 28 80 00       	push   $0x802845
  800a8a:	ff 75 0c             	pushl  0xc(%ebp)
  800a8d:	ff 75 08             	pushl  0x8(%ebp)
  800a90:	e8 70 02 00 00       	call   800d05 <printfmt>
  800a95:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800a98:	e9 5b 02 00 00       	jmp    800cf8 <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800a9d:	56                   	push   %esi
  800a9e:	68 4e 28 80 00       	push   $0x80284e
  800aa3:	ff 75 0c             	pushl  0xc(%ebp)
  800aa6:	ff 75 08             	pushl  0x8(%ebp)
  800aa9:	e8 57 02 00 00       	call   800d05 <printfmt>
  800aae:	83 c4 10             	add    $0x10,%esp
			break;
  800ab1:	e9 42 02 00 00       	jmp    800cf8 <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800ab6:	8b 45 14             	mov    0x14(%ebp),%eax
  800ab9:	83 c0 04             	add    $0x4,%eax
  800abc:	89 45 14             	mov    %eax,0x14(%ebp)
  800abf:	8b 45 14             	mov    0x14(%ebp),%eax
  800ac2:	83 e8 04             	sub    $0x4,%eax
  800ac5:	8b 30                	mov    (%eax),%esi
  800ac7:	85 f6                	test   %esi,%esi
  800ac9:	75 05                	jne    800ad0 <vprintfmt+0x1a6>
				p = "(null)";
  800acb:	be 51 28 80 00       	mov    $0x802851,%esi
			if (width > 0 && padc != '-')
  800ad0:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800ad4:	7e 6d                	jle    800b43 <vprintfmt+0x219>
  800ad6:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800ada:	74 67                	je     800b43 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800adc:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800adf:	83 ec 08             	sub    $0x8,%esp
  800ae2:	50                   	push   %eax
  800ae3:	56                   	push   %esi
  800ae4:	e8 26 05 00 00       	call   80100f <strnlen>
  800ae9:	83 c4 10             	add    $0x10,%esp
  800aec:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800aef:	eb 16                	jmp    800b07 <vprintfmt+0x1dd>
					putch(padc, putdat);
  800af1:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800af5:	83 ec 08             	sub    $0x8,%esp
  800af8:	ff 75 0c             	pushl  0xc(%ebp)
  800afb:	50                   	push   %eax
  800afc:	8b 45 08             	mov    0x8(%ebp),%eax
  800aff:	ff d0                	call   *%eax
  800b01:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800b04:	ff 4d e4             	decl   -0x1c(%ebp)
  800b07:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800b0b:	7f e4                	jg     800af1 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800b0d:	eb 34                	jmp    800b43 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800b0f:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800b13:	74 1c                	je     800b31 <vprintfmt+0x207>
  800b15:	83 fb 1f             	cmp    $0x1f,%ebx
  800b18:	7e 05                	jle    800b1f <vprintfmt+0x1f5>
  800b1a:	83 fb 7e             	cmp    $0x7e,%ebx
  800b1d:	7e 12                	jle    800b31 <vprintfmt+0x207>
					putch('?', putdat);
  800b1f:	83 ec 08             	sub    $0x8,%esp
  800b22:	ff 75 0c             	pushl  0xc(%ebp)
  800b25:	6a 3f                	push   $0x3f
  800b27:	8b 45 08             	mov    0x8(%ebp),%eax
  800b2a:	ff d0                	call   *%eax
  800b2c:	83 c4 10             	add    $0x10,%esp
  800b2f:	eb 0f                	jmp    800b40 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800b31:	83 ec 08             	sub    $0x8,%esp
  800b34:	ff 75 0c             	pushl  0xc(%ebp)
  800b37:	53                   	push   %ebx
  800b38:	8b 45 08             	mov    0x8(%ebp),%eax
  800b3b:	ff d0                	call   *%eax
  800b3d:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800b40:	ff 4d e4             	decl   -0x1c(%ebp)
  800b43:	89 f0                	mov    %esi,%eax
  800b45:	8d 70 01             	lea    0x1(%eax),%esi
  800b48:	8a 00                	mov    (%eax),%al
  800b4a:	0f be d8             	movsbl %al,%ebx
  800b4d:	85 db                	test   %ebx,%ebx
  800b4f:	74 24                	je     800b75 <vprintfmt+0x24b>
  800b51:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800b55:	78 b8                	js     800b0f <vprintfmt+0x1e5>
  800b57:	ff 4d e0             	decl   -0x20(%ebp)
  800b5a:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800b5e:	79 af                	jns    800b0f <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800b60:	eb 13                	jmp    800b75 <vprintfmt+0x24b>
				putch(' ', putdat);
  800b62:	83 ec 08             	sub    $0x8,%esp
  800b65:	ff 75 0c             	pushl  0xc(%ebp)
  800b68:	6a 20                	push   $0x20
  800b6a:	8b 45 08             	mov    0x8(%ebp),%eax
  800b6d:	ff d0                	call   *%eax
  800b6f:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800b72:	ff 4d e4             	decl   -0x1c(%ebp)
  800b75:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800b79:	7f e7                	jg     800b62 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800b7b:	e9 78 01 00 00       	jmp    800cf8 <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800b80:	83 ec 08             	sub    $0x8,%esp
  800b83:	ff 75 e8             	pushl  -0x18(%ebp)
  800b86:	8d 45 14             	lea    0x14(%ebp),%eax
  800b89:	50                   	push   %eax
  800b8a:	e8 3c fd ff ff       	call   8008cb <getint>
  800b8f:	83 c4 10             	add    $0x10,%esp
  800b92:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b95:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800b98:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800b9b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800b9e:	85 d2                	test   %edx,%edx
  800ba0:	79 23                	jns    800bc5 <vprintfmt+0x29b>
				putch('-', putdat);
  800ba2:	83 ec 08             	sub    $0x8,%esp
  800ba5:	ff 75 0c             	pushl  0xc(%ebp)
  800ba8:	6a 2d                	push   $0x2d
  800baa:	8b 45 08             	mov    0x8(%ebp),%eax
  800bad:	ff d0                	call   *%eax
  800baf:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800bb2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800bb5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800bb8:	f7 d8                	neg    %eax
  800bba:	83 d2 00             	adc    $0x0,%edx
  800bbd:	f7 da                	neg    %edx
  800bbf:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800bc2:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800bc5:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800bcc:	e9 bc 00 00 00       	jmp    800c8d <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800bd1:	83 ec 08             	sub    $0x8,%esp
  800bd4:	ff 75 e8             	pushl  -0x18(%ebp)
  800bd7:	8d 45 14             	lea    0x14(%ebp),%eax
  800bda:	50                   	push   %eax
  800bdb:	e8 84 fc ff ff       	call   800864 <getuint>
  800be0:	83 c4 10             	add    $0x10,%esp
  800be3:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800be6:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800be9:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800bf0:	e9 98 00 00 00       	jmp    800c8d <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800bf5:	83 ec 08             	sub    $0x8,%esp
  800bf8:	ff 75 0c             	pushl  0xc(%ebp)
  800bfb:	6a 58                	push   $0x58
  800bfd:	8b 45 08             	mov    0x8(%ebp),%eax
  800c00:	ff d0                	call   *%eax
  800c02:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800c05:	83 ec 08             	sub    $0x8,%esp
  800c08:	ff 75 0c             	pushl  0xc(%ebp)
  800c0b:	6a 58                	push   $0x58
  800c0d:	8b 45 08             	mov    0x8(%ebp),%eax
  800c10:	ff d0                	call   *%eax
  800c12:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800c15:	83 ec 08             	sub    $0x8,%esp
  800c18:	ff 75 0c             	pushl  0xc(%ebp)
  800c1b:	6a 58                	push   $0x58
  800c1d:	8b 45 08             	mov    0x8(%ebp),%eax
  800c20:	ff d0                	call   *%eax
  800c22:	83 c4 10             	add    $0x10,%esp
			break;
  800c25:	e9 ce 00 00 00       	jmp    800cf8 <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  800c2a:	83 ec 08             	sub    $0x8,%esp
  800c2d:	ff 75 0c             	pushl  0xc(%ebp)
  800c30:	6a 30                	push   $0x30
  800c32:	8b 45 08             	mov    0x8(%ebp),%eax
  800c35:	ff d0                	call   *%eax
  800c37:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800c3a:	83 ec 08             	sub    $0x8,%esp
  800c3d:	ff 75 0c             	pushl  0xc(%ebp)
  800c40:	6a 78                	push   $0x78
  800c42:	8b 45 08             	mov    0x8(%ebp),%eax
  800c45:	ff d0                	call   *%eax
  800c47:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800c4a:	8b 45 14             	mov    0x14(%ebp),%eax
  800c4d:	83 c0 04             	add    $0x4,%eax
  800c50:	89 45 14             	mov    %eax,0x14(%ebp)
  800c53:	8b 45 14             	mov    0x14(%ebp),%eax
  800c56:	83 e8 04             	sub    $0x4,%eax
  800c59:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800c5b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c5e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800c65:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800c6c:	eb 1f                	jmp    800c8d <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800c6e:	83 ec 08             	sub    $0x8,%esp
  800c71:	ff 75 e8             	pushl  -0x18(%ebp)
  800c74:	8d 45 14             	lea    0x14(%ebp),%eax
  800c77:	50                   	push   %eax
  800c78:	e8 e7 fb ff ff       	call   800864 <getuint>
  800c7d:	83 c4 10             	add    $0x10,%esp
  800c80:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c83:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800c86:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800c8d:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800c91:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800c94:	83 ec 04             	sub    $0x4,%esp
  800c97:	52                   	push   %edx
  800c98:	ff 75 e4             	pushl  -0x1c(%ebp)
  800c9b:	50                   	push   %eax
  800c9c:	ff 75 f4             	pushl  -0xc(%ebp)
  800c9f:	ff 75 f0             	pushl  -0x10(%ebp)
  800ca2:	ff 75 0c             	pushl  0xc(%ebp)
  800ca5:	ff 75 08             	pushl  0x8(%ebp)
  800ca8:	e8 00 fb ff ff       	call   8007ad <printnum>
  800cad:	83 c4 20             	add    $0x20,%esp
			break;
  800cb0:	eb 46                	jmp    800cf8 <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800cb2:	83 ec 08             	sub    $0x8,%esp
  800cb5:	ff 75 0c             	pushl  0xc(%ebp)
  800cb8:	53                   	push   %ebx
  800cb9:	8b 45 08             	mov    0x8(%ebp),%eax
  800cbc:	ff d0                	call   *%eax
  800cbe:	83 c4 10             	add    $0x10,%esp
			break;
  800cc1:	eb 35                	jmp    800cf8 <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  800cc3:	c6 05 44 30 80 00 00 	movb   $0x0,0x803044
			break;
  800cca:	eb 2c                	jmp    800cf8 <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  800ccc:	c6 05 44 30 80 00 01 	movb   $0x1,0x803044
			break;
  800cd3:	eb 23                	jmp    800cf8 <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800cd5:	83 ec 08             	sub    $0x8,%esp
  800cd8:	ff 75 0c             	pushl  0xc(%ebp)
  800cdb:	6a 25                	push   $0x25
  800cdd:	8b 45 08             	mov    0x8(%ebp),%eax
  800ce0:	ff d0                	call   *%eax
  800ce2:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800ce5:	ff 4d 10             	decl   0x10(%ebp)
  800ce8:	eb 03                	jmp    800ced <vprintfmt+0x3c3>
  800cea:	ff 4d 10             	decl   0x10(%ebp)
  800ced:	8b 45 10             	mov    0x10(%ebp),%eax
  800cf0:	48                   	dec    %eax
  800cf1:	8a 00                	mov    (%eax),%al
  800cf3:	3c 25                	cmp    $0x25,%al
  800cf5:	75 f3                	jne    800cea <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  800cf7:	90                   	nop
		}
	}
  800cf8:	e9 35 fc ff ff       	jmp    800932 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800cfd:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800cfe:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800d01:	5b                   	pop    %ebx
  800d02:	5e                   	pop    %esi
  800d03:	5d                   	pop    %ebp
  800d04:	c3                   	ret    

00800d05 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800d05:	55                   	push   %ebp
  800d06:	89 e5                	mov    %esp,%ebp
  800d08:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800d0b:	8d 45 10             	lea    0x10(%ebp),%eax
  800d0e:	83 c0 04             	add    $0x4,%eax
  800d11:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800d14:	8b 45 10             	mov    0x10(%ebp),%eax
  800d17:	ff 75 f4             	pushl  -0xc(%ebp)
  800d1a:	50                   	push   %eax
  800d1b:	ff 75 0c             	pushl  0xc(%ebp)
  800d1e:	ff 75 08             	pushl  0x8(%ebp)
  800d21:	e8 04 fc ff ff       	call   80092a <vprintfmt>
  800d26:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800d29:	90                   	nop
  800d2a:	c9                   	leave  
  800d2b:	c3                   	ret    

00800d2c <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800d2c:	55                   	push   %ebp
  800d2d:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800d2f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d32:	8b 40 08             	mov    0x8(%eax),%eax
  800d35:	8d 50 01             	lea    0x1(%eax),%edx
  800d38:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d3b:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800d3e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d41:	8b 10                	mov    (%eax),%edx
  800d43:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d46:	8b 40 04             	mov    0x4(%eax),%eax
  800d49:	39 c2                	cmp    %eax,%edx
  800d4b:	73 12                	jae    800d5f <sprintputch+0x33>
		*b->buf++ = ch;
  800d4d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d50:	8b 00                	mov    (%eax),%eax
  800d52:	8d 48 01             	lea    0x1(%eax),%ecx
  800d55:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d58:	89 0a                	mov    %ecx,(%edx)
  800d5a:	8b 55 08             	mov    0x8(%ebp),%edx
  800d5d:	88 10                	mov    %dl,(%eax)
}
  800d5f:	90                   	nop
  800d60:	5d                   	pop    %ebp
  800d61:	c3                   	ret    

00800d62 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800d62:	55                   	push   %ebp
  800d63:	89 e5                	mov    %esp,%ebp
  800d65:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800d68:	8b 45 08             	mov    0x8(%ebp),%eax
  800d6b:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800d6e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d71:	8d 50 ff             	lea    -0x1(%eax),%edx
  800d74:	8b 45 08             	mov    0x8(%ebp),%eax
  800d77:	01 d0                	add    %edx,%eax
  800d79:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800d7c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800d83:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800d87:	74 06                	je     800d8f <vsnprintf+0x2d>
  800d89:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800d8d:	7f 07                	jg     800d96 <vsnprintf+0x34>
		return -E_INVAL;
  800d8f:	b8 03 00 00 00       	mov    $0x3,%eax
  800d94:	eb 20                	jmp    800db6 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800d96:	ff 75 14             	pushl  0x14(%ebp)
  800d99:	ff 75 10             	pushl  0x10(%ebp)
  800d9c:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800d9f:	50                   	push   %eax
  800da0:	68 2c 0d 80 00       	push   $0x800d2c
  800da5:	e8 80 fb ff ff       	call   80092a <vprintfmt>
  800daa:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800dad:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800db0:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800db3:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800db6:	c9                   	leave  
  800db7:	c3                   	ret    

00800db8 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800db8:	55                   	push   %ebp
  800db9:	89 e5                	mov    %esp,%ebp
  800dbb:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800dbe:	8d 45 10             	lea    0x10(%ebp),%eax
  800dc1:	83 c0 04             	add    $0x4,%eax
  800dc4:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800dc7:	8b 45 10             	mov    0x10(%ebp),%eax
  800dca:	ff 75 f4             	pushl  -0xc(%ebp)
  800dcd:	50                   	push   %eax
  800dce:	ff 75 0c             	pushl  0xc(%ebp)
  800dd1:	ff 75 08             	pushl  0x8(%ebp)
  800dd4:	e8 89 ff ff ff       	call   800d62 <vsnprintf>
  800dd9:	83 c4 10             	add    $0x10,%esp
  800ddc:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800ddf:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800de2:	c9                   	leave  
  800de3:	c3                   	ret    

00800de4 <readline>:
#include <inc/lib.h>

//static char buf[BUFLEN];

void readline(const char *prompt, char* buf)
{
  800de4:	55                   	push   %ebp
  800de5:	89 e5                	mov    %esp,%ebp
  800de7:	83 ec 18             	sub    $0x18,%esp
	int i, c, echoing;

	if (prompt != NULL)
  800dea:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800dee:	74 13                	je     800e03 <readline+0x1f>
		cprintf("%s", prompt);
  800df0:	83 ec 08             	sub    $0x8,%esp
  800df3:	ff 75 08             	pushl  0x8(%ebp)
  800df6:	68 c8 29 80 00       	push   $0x8029c8
  800dfb:	e8 0b f9 ff ff       	call   80070b <cprintf>
  800e00:	83 c4 10             	add    $0x10,%esp

	i = 0;
  800e03:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	echoing = iscons(0);
  800e0a:	83 ec 0c             	sub    $0xc,%esp
  800e0d:	6a 00                	push   $0x0
  800e0f:	e8 7e 10 00 00       	call   801e92 <iscons>
  800e14:	83 c4 10             	add    $0x10,%esp
  800e17:	89 45 f0             	mov    %eax,-0x10(%ebp)
	while (1) {
		c = getchar();
  800e1a:	e8 60 10 00 00       	call   801e7f <getchar>
  800e1f:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if (c < 0) {
  800e22:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800e26:	79 22                	jns    800e4a <readline+0x66>
			if (c != -E_EOF)
  800e28:	83 7d ec 07          	cmpl   $0x7,-0x14(%ebp)
  800e2c:	0f 84 ad 00 00 00    	je     800edf <readline+0xfb>
				cprintf("read error: %e\n", c);
  800e32:	83 ec 08             	sub    $0x8,%esp
  800e35:	ff 75 ec             	pushl  -0x14(%ebp)
  800e38:	68 cb 29 80 00       	push   $0x8029cb
  800e3d:	e8 c9 f8 ff ff       	call   80070b <cprintf>
  800e42:	83 c4 10             	add    $0x10,%esp
			break;
  800e45:	e9 95 00 00 00       	jmp    800edf <readline+0xfb>
		} else if (c >= ' ' && i < BUFLEN-1) {
  800e4a:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%ebp)
  800e4e:	7e 34                	jle    800e84 <readline+0xa0>
  800e50:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  800e57:	7f 2b                	jg     800e84 <readline+0xa0>
			if (echoing)
  800e59:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800e5d:	74 0e                	je     800e6d <readline+0x89>
				cputchar(c);
  800e5f:	83 ec 0c             	sub    $0xc,%esp
  800e62:	ff 75 ec             	pushl  -0x14(%ebp)
  800e65:	e8 f6 0f 00 00       	call   801e60 <cputchar>
  800e6a:	83 c4 10             	add    $0x10,%esp
			buf[i++] = c;
  800e6d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800e70:	8d 50 01             	lea    0x1(%eax),%edx
  800e73:	89 55 f4             	mov    %edx,-0xc(%ebp)
  800e76:	89 c2                	mov    %eax,%edx
  800e78:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e7b:	01 d0                	add    %edx,%eax
  800e7d:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800e80:	88 10                	mov    %dl,(%eax)
  800e82:	eb 56                	jmp    800eda <readline+0xf6>
		} else if (c == '\b' && i > 0) {
  800e84:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  800e88:	75 1f                	jne    800ea9 <readline+0xc5>
  800e8a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  800e8e:	7e 19                	jle    800ea9 <readline+0xc5>
			if (echoing)
  800e90:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800e94:	74 0e                	je     800ea4 <readline+0xc0>
				cputchar(c);
  800e96:	83 ec 0c             	sub    $0xc,%esp
  800e99:	ff 75 ec             	pushl  -0x14(%ebp)
  800e9c:	e8 bf 0f 00 00       	call   801e60 <cputchar>
  800ea1:	83 c4 10             	add    $0x10,%esp

			i--;
  800ea4:	ff 4d f4             	decl   -0xc(%ebp)
  800ea7:	eb 31                	jmp    800eda <readline+0xf6>
		} else if (c == '\n' || c == '\r') {
  800ea9:	83 7d ec 0a          	cmpl   $0xa,-0x14(%ebp)
  800ead:	74 0a                	je     800eb9 <readline+0xd5>
  800eaf:	83 7d ec 0d          	cmpl   $0xd,-0x14(%ebp)
  800eb3:	0f 85 61 ff ff ff    	jne    800e1a <readline+0x36>
			if (echoing)
  800eb9:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800ebd:	74 0e                	je     800ecd <readline+0xe9>
				cputchar(c);
  800ebf:	83 ec 0c             	sub    $0xc,%esp
  800ec2:	ff 75 ec             	pushl  -0x14(%ebp)
  800ec5:	e8 96 0f 00 00       	call   801e60 <cputchar>
  800eca:	83 c4 10             	add    $0x10,%esp

			buf[i] = 0;
  800ecd:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800ed0:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ed3:	01 d0                	add    %edx,%eax
  800ed5:	c6 00 00             	movb   $0x0,(%eax)
			break;
  800ed8:	eb 06                	jmp    800ee0 <readline+0xfc>
		}
	}
  800eda:	e9 3b ff ff ff       	jmp    800e1a <readline+0x36>
	while (1) {
		c = getchar();
		if (c < 0) {
			if (c != -E_EOF)
				cprintf("read error: %e\n", c);
			break;
  800edf:	90                   	nop

			buf[i] = 0;
			break;
		}
	}
}
  800ee0:	90                   	nop
  800ee1:	c9                   	leave  
  800ee2:	c3                   	ret    

00800ee3 <atomic_readline>:

void atomic_readline(const char *prompt, char* buf)
{
  800ee3:	55                   	push   %ebp
  800ee4:	89 e5                	mov    %esp,%ebp
  800ee6:	83 ec 18             	sub    $0x18,%esp
	sys_lock_cons();
  800ee9:	e8 79 09 00 00       	call   801867 <sys_lock_cons>
	{
		int i, c, echoing;

		if (prompt != NULL)
  800eee:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800ef2:	74 13                	je     800f07 <atomic_readline+0x24>
			cprintf("%s", prompt);
  800ef4:	83 ec 08             	sub    $0x8,%esp
  800ef7:	ff 75 08             	pushl  0x8(%ebp)
  800efa:	68 c8 29 80 00       	push   $0x8029c8
  800eff:	e8 07 f8 ff ff       	call   80070b <cprintf>
  800f04:	83 c4 10             	add    $0x10,%esp

		i = 0;
  800f07:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
		echoing = iscons(0);
  800f0e:	83 ec 0c             	sub    $0xc,%esp
  800f11:	6a 00                	push   $0x0
  800f13:	e8 7a 0f 00 00       	call   801e92 <iscons>
  800f18:	83 c4 10             	add    $0x10,%esp
  800f1b:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (1) {
			c = getchar();
  800f1e:	e8 5c 0f 00 00       	call   801e7f <getchar>
  800f23:	89 45 ec             	mov    %eax,-0x14(%ebp)
			if (c < 0) {
  800f26:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800f2a:	79 22                	jns    800f4e <atomic_readline+0x6b>
				if (c != -E_EOF)
  800f2c:	83 7d ec 07          	cmpl   $0x7,-0x14(%ebp)
  800f30:	0f 84 ad 00 00 00    	je     800fe3 <atomic_readline+0x100>
					cprintf("read error: %e\n", c);
  800f36:	83 ec 08             	sub    $0x8,%esp
  800f39:	ff 75 ec             	pushl  -0x14(%ebp)
  800f3c:	68 cb 29 80 00       	push   $0x8029cb
  800f41:	e8 c5 f7 ff ff       	call   80070b <cprintf>
  800f46:	83 c4 10             	add    $0x10,%esp
				break;
  800f49:	e9 95 00 00 00       	jmp    800fe3 <atomic_readline+0x100>
			} else if (c >= ' ' && i < BUFLEN-1) {
  800f4e:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%ebp)
  800f52:	7e 34                	jle    800f88 <atomic_readline+0xa5>
  800f54:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  800f5b:	7f 2b                	jg     800f88 <atomic_readline+0xa5>
				if (echoing)
  800f5d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800f61:	74 0e                	je     800f71 <atomic_readline+0x8e>
					cputchar(c);
  800f63:	83 ec 0c             	sub    $0xc,%esp
  800f66:	ff 75 ec             	pushl  -0x14(%ebp)
  800f69:	e8 f2 0e 00 00       	call   801e60 <cputchar>
  800f6e:	83 c4 10             	add    $0x10,%esp
				buf[i++] = c;
  800f71:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800f74:	8d 50 01             	lea    0x1(%eax),%edx
  800f77:	89 55 f4             	mov    %edx,-0xc(%ebp)
  800f7a:	89 c2                	mov    %eax,%edx
  800f7c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f7f:	01 d0                	add    %edx,%eax
  800f81:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800f84:	88 10                	mov    %dl,(%eax)
  800f86:	eb 56                	jmp    800fde <atomic_readline+0xfb>
			} else if (c == '\b' && i > 0) {
  800f88:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  800f8c:	75 1f                	jne    800fad <atomic_readline+0xca>
  800f8e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  800f92:	7e 19                	jle    800fad <atomic_readline+0xca>
				if (echoing)
  800f94:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800f98:	74 0e                	je     800fa8 <atomic_readline+0xc5>
					cputchar(c);
  800f9a:	83 ec 0c             	sub    $0xc,%esp
  800f9d:	ff 75 ec             	pushl  -0x14(%ebp)
  800fa0:	e8 bb 0e 00 00       	call   801e60 <cputchar>
  800fa5:	83 c4 10             	add    $0x10,%esp
				i--;
  800fa8:	ff 4d f4             	decl   -0xc(%ebp)
  800fab:	eb 31                	jmp    800fde <atomic_readline+0xfb>
			} else if (c == '\n' || c == '\r') {
  800fad:	83 7d ec 0a          	cmpl   $0xa,-0x14(%ebp)
  800fb1:	74 0a                	je     800fbd <atomic_readline+0xda>
  800fb3:	83 7d ec 0d          	cmpl   $0xd,-0x14(%ebp)
  800fb7:	0f 85 61 ff ff ff    	jne    800f1e <atomic_readline+0x3b>
				if (echoing)
  800fbd:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800fc1:	74 0e                	je     800fd1 <atomic_readline+0xee>
					cputchar(c);
  800fc3:	83 ec 0c             	sub    $0xc,%esp
  800fc6:	ff 75 ec             	pushl  -0x14(%ebp)
  800fc9:	e8 92 0e 00 00       	call   801e60 <cputchar>
  800fce:	83 c4 10             	add    $0x10,%esp
				buf[i] = 0;
  800fd1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800fd4:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fd7:	01 d0                	add    %edx,%eax
  800fd9:	c6 00 00             	movb   $0x0,(%eax)
				break;
  800fdc:	eb 06                	jmp    800fe4 <atomic_readline+0x101>
			}
		}
  800fde:	e9 3b ff ff ff       	jmp    800f1e <atomic_readline+0x3b>
		while (1) {
			c = getchar();
			if (c < 0) {
				if (c != -E_EOF)
					cprintf("read error: %e\n", c);
				break;
  800fe3:	90                   	nop
				buf[i] = 0;
				break;
			}
		}
	}
	sys_unlock_cons();
  800fe4:	e8 98 08 00 00       	call   801881 <sys_unlock_cons>
}
  800fe9:	90                   	nop
  800fea:	c9                   	leave  
  800feb:	c3                   	ret    

00800fec <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800fec:	55                   	push   %ebp
  800fed:	89 e5                	mov    %esp,%ebp
  800fef:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800ff2:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800ff9:	eb 06                	jmp    801001 <strlen+0x15>
		n++;
  800ffb:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800ffe:	ff 45 08             	incl   0x8(%ebp)
  801001:	8b 45 08             	mov    0x8(%ebp),%eax
  801004:	8a 00                	mov    (%eax),%al
  801006:	84 c0                	test   %al,%al
  801008:	75 f1                	jne    800ffb <strlen+0xf>
		n++;
	return n;
  80100a:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  80100d:	c9                   	leave  
  80100e:	c3                   	ret    

0080100f <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  80100f:	55                   	push   %ebp
  801010:	89 e5                	mov    %esp,%ebp
  801012:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801015:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80101c:	eb 09                	jmp    801027 <strnlen+0x18>
		n++;
  80101e:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801021:	ff 45 08             	incl   0x8(%ebp)
  801024:	ff 4d 0c             	decl   0xc(%ebp)
  801027:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80102b:	74 09                	je     801036 <strnlen+0x27>
  80102d:	8b 45 08             	mov    0x8(%ebp),%eax
  801030:	8a 00                	mov    (%eax),%al
  801032:	84 c0                	test   %al,%al
  801034:	75 e8                	jne    80101e <strnlen+0xf>
		n++;
	return n;
  801036:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801039:	c9                   	leave  
  80103a:	c3                   	ret    

0080103b <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  80103b:	55                   	push   %ebp
  80103c:	89 e5                	mov    %esp,%ebp
  80103e:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  801041:	8b 45 08             	mov    0x8(%ebp),%eax
  801044:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  801047:	90                   	nop
  801048:	8b 45 08             	mov    0x8(%ebp),%eax
  80104b:	8d 50 01             	lea    0x1(%eax),%edx
  80104e:	89 55 08             	mov    %edx,0x8(%ebp)
  801051:	8b 55 0c             	mov    0xc(%ebp),%edx
  801054:	8d 4a 01             	lea    0x1(%edx),%ecx
  801057:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  80105a:	8a 12                	mov    (%edx),%dl
  80105c:	88 10                	mov    %dl,(%eax)
  80105e:	8a 00                	mov    (%eax),%al
  801060:	84 c0                	test   %al,%al
  801062:	75 e4                	jne    801048 <strcpy+0xd>
		/* do nothing */;
	return ret;
  801064:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801067:	c9                   	leave  
  801068:	c3                   	ret    

00801069 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  801069:	55                   	push   %ebp
  80106a:	89 e5                	mov    %esp,%ebp
  80106c:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  80106f:	8b 45 08             	mov    0x8(%ebp),%eax
  801072:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  801075:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80107c:	eb 1f                	jmp    80109d <strncpy+0x34>
		*dst++ = *src;
  80107e:	8b 45 08             	mov    0x8(%ebp),%eax
  801081:	8d 50 01             	lea    0x1(%eax),%edx
  801084:	89 55 08             	mov    %edx,0x8(%ebp)
  801087:	8b 55 0c             	mov    0xc(%ebp),%edx
  80108a:	8a 12                	mov    (%edx),%dl
  80108c:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  80108e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801091:	8a 00                	mov    (%eax),%al
  801093:	84 c0                	test   %al,%al
  801095:	74 03                	je     80109a <strncpy+0x31>
			src++;
  801097:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  80109a:	ff 45 fc             	incl   -0x4(%ebp)
  80109d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8010a0:	3b 45 10             	cmp    0x10(%ebp),%eax
  8010a3:	72 d9                	jb     80107e <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  8010a5:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8010a8:	c9                   	leave  
  8010a9:	c3                   	ret    

008010aa <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  8010aa:	55                   	push   %ebp
  8010ab:	89 e5                	mov    %esp,%ebp
  8010ad:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  8010b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8010b3:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  8010b6:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8010ba:	74 30                	je     8010ec <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  8010bc:	eb 16                	jmp    8010d4 <strlcpy+0x2a>
			*dst++ = *src++;
  8010be:	8b 45 08             	mov    0x8(%ebp),%eax
  8010c1:	8d 50 01             	lea    0x1(%eax),%edx
  8010c4:	89 55 08             	mov    %edx,0x8(%ebp)
  8010c7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8010ca:	8d 4a 01             	lea    0x1(%edx),%ecx
  8010cd:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  8010d0:	8a 12                	mov    (%edx),%dl
  8010d2:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  8010d4:	ff 4d 10             	decl   0x10(%ebp)
  8010d7:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8010db:	74 09                	je     8010e6 <strlcpy+0x3c>
  8010dd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010e0:	8a 00                	mov    (%eax),%al
  8010e2:	84 c0                	test   %al,%al
  8010e4:	75 d8                	jne    8010be <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  8010e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8010e9:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  8010ec:	8b 55 08             	mov    0x8(%ebp),%edx
  8010ef:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8010f2:	29 c2                	sub    %eax,%edx
  8010f4:	89 d0                	mov    %edx,%eax
}
  8010f6:	c9                   	leave  
  8010f7:	c3                   	ret    

008010f8 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8010f8:	55                   	push   %ebp
  8010f9:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  8010fb:	eb 06                	jmp    801103 <strcmp+0xb>
		p++, q++;
  8010fd:	ff 45 08             	incl   0x8(%ebp)
  801100:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  801103:	8b 45 08             	mov    0x8(%ebp),%eax
  801106:	8a 00                	mov    (%eax),%al
  801108:	84 c0                	test   %al,%al
  80110a:	74 0e                	je     80111a <strcmp+0x22>
  80110c:	8b 45 08             	mov    0x8(%ebp),%eax
  80110f:	8a 10                	mov    (%eax),%dl
  801111:	8b 45 0c             	mov    0xc(%ebp),%eax
  801114:	8a 00                	mov    (%eax),%al
  801116:	38 c2                	cmp    %al,%dl
  801118:	74 e3                	je     8010fd <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  80111a:	8b 45 08             	mov    0x8(%ebp),%eax
  80111d:	8a 00                	mov    (%eax),%al
  80111f:	0f b6 d0             	movzbl %al,%edx
  801122:	8b 45 0c             	mov    0xc(%ebp),%eax
  801125:	8a 00                	mov    (%eax),%al
  801127:	0f b6 c0             	movzbl %al,%eax
  80112a:	29 c2                	sub    %eax,%edx
  80112c:	89 d0                	mov    %edx,%eax
}
  80112e:	5d                   	pop    %ebp
  80112f:	c3                   	ret    

00801130 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  801130:	55                   	push   %ebp
  801131:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  801133:	eb 09                	jmp    80113e <strncmp+0xe>
		n--, p++, q++;
  801135:	ff 4d 10             	decl   0x10(%ebp)
  801138:	ff 45 08             	incl   0x8(%ebp)
  80113b:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  80113e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801142:	74 17                	je     80115b <strncmp+0x2b>
  801144:	8b 45 08             	mov    0x8(%ebp),%eax
  801147:	8a 00                	mov    (%eax),%al
  801149:	84 c0                	test   %al,%al
  80114b:	74 0e                	je     80115b <strncmp+0x2b>
  80114d:	8b 45 08             	mov    0x8(%ebp),%eax
  801150:	8a 10                	mov    (%eax),%dl
  801152:	8b 45 0c             	mov    0xc(%ebp),%eax
  801155:	8a 00                	mov    (%eax),%al
  801157:	38 c2                	cmp    %al,%dl
  801159:	74 da                	je     801135 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  80115b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80115f:	75 07                	jne    801168 <strncmp+0x38>
		return 0;
  801161:	b8 00 00 00 00       	mov    $0x0,%eax
  801166:	eb 14                	jmp    80117c <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  801168:	8b 45 08             	mov    0x8(%ebp),%eax
  80116b:	8a 00                	mov    (%eax),%al
  80116d:	0f b6 d0             	movzbl %al,%edx
  801170:	8b 45 0c             	mov    0xc(%ebp),%eax
  801173:	8a 00                	mov    (%eax),%al
  801175:	0f b6 c0             	movzbl %al,%eax
  801178:	29 c2                	sub    %eax,%edx
  80117a:	89 d0                	mov    %edx,%eax
}
  80117c:	5d                   	pop    %ebp
  80117d:	c3                   	ret    

0080117e <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  80117e:	55                   	push   %ebp
  80117f:	89 e5                	mov    %esp,%ebp
  801181:	83 ec 04             	sub    $0x4,%esp
  801184:	8b 45 0c             	mov    0xc(%ebp),%eax
  801187:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  80118a:	eb 12                	jmp    80119e <strchr+0x20>
		if (*s == c)
  80118c:	8b 45 08             	mov    0x8(%ebp),%eax
  80118f:	8a 00                	mov    (%eax),%al
  801191:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801194:	75 05                	jne    80119b <strchr+0x1d>
			return (char *) s;
  801196:	8b 45 08             	mov    0x8(%ebp),%eax
  801199:	eb 11                	jmp    8011ac <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  80119b:	ff 45 08             	incl   0x8(%ebp)
  80119e:	8b 45 08             	mov    0x8(%ebp),%eax
  8011a1:	8a 00                	mov    (%eax),%al
  8011a3:	84 c0                	test   %al,%al
  8011a5:	75 e5                	jne    80118c <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  8011a7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8011ac:	c9                   	leave  
  8011ad:	c3                   	ret    

008011ae <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8011ae:	55                   	push   %ebp
  8011af:	89 e5                	mov    %esp,%ebp
  8011b1:	83 ec 04             	sub    $0x4,%esp
  8011b4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011b7:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  8011ba:	eb 0d                	jmp    8011c9 <strfind+0x1b>
		if (*s == c)
  8011bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8011bf:	8a 00                	mov    (%eax),%al
  8011c1:	3a 45 fc             	cmp    -0x4(%ebp),%al
  8011c4:	74 0e                	je     8011d4 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  8011c6:	ff 45 08             	incl   0x8(%ebp)
  8011c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8011cc:	8a 00                	mov    (%eax),%al
  8011ce:	84 c0                	test   %al,%al
  8011d0:	75 ea                	jne    8011bc <strfind+0xe>
  8011d2:	eb 01                	jmp    8011d5 <strfind+0x27>
		if (*s == c)
			break;
  8011d4:	90                   	nop
	return (char *) s;
  8011d5:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8011d8:	c9                   	leave  
  8011d9:	c3                   	ret    

008011da <memset>:

// *************** The faster implementation of memset & memcpy is implemented by *************
// ****************** Team80 (Yahia Khaled, Malek Ahmed et al) - FCIS'24-25 *******************
void *
memset(void *v, int c, uint32 n)
{
  8011da:	55                   	push   %ebp
  8011db:	89 e5                	mov    %esp,%ebp
  8011dd:	83 ec 10             	sub    $0x10,%esp
//	m = n;
//	while (--m >= 0)
//		*p++ = c;

	/*Faster Implementation*/
	uint64* p64 = (uint64*)v;
  8011e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8011e3:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if(n >= 8){
  8011e6:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  8011ea:	76 63                	jbe    80124f <memset+0x75>
		uint64 data_block = c;
  8011ec:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011ef:	99                   	cltd   
  8011f0:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8011f3:	89 55 f4             	mov    %edx,-0xc(%ebp)
		data_block |= data_block << 8;
  8011f6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8011f9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8011fc:	0f a4 c2 08          	shld   $0x8,%eax,%edx
  801200:	c1 e0 08             	shl    $0x8,%eax
  801203:	09 45 f0             	or     %eax,-0x10(%ebp)
  801206:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 16;
  801209:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80120c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80120f:	0f a4 c2 10          	shld   $0x10,%eax,%edx
  801213:	c1 e0 10             	shl    $0x10,%eax
  801216:	09 45 f0             	or     %eax,-0x10(%ebp)
  801219:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 32;
  80121c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80121f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801222:	89 c2                	mov    %eax,%edx
  801224:	b8 00 00 00 00       	mov    $0x0,%eax
  801229:	09 45 f0             	or     %eax,-0x10(%ebp)
  80122c:	09 55 f4             	or     %edx,-0xc(%ebp)

		while(n >= 8)
  80122f:	eb 18                	jmp    801249 <memset+0x6f>
			*p64++ = data_block, n -= 8;
  801231:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801234:	8d 41 08             	lea    0x8(%ecx),%eax
  801237:	89 45 fc             	mov    %eax,-0x4(%ebp)
  80123a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80123d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801240:	89 01                	mov    %eax,(%ecx)
  801242:	89 51 04             	mov    %edx,0x4(%ecx)
  801245:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
		uint64 data_block = c;
		data_block |= data_block << 8;
		data_block |= data_block << 16;
		data_block |= data_block << 32;

		while(n >= 8)
  801249:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  80124d:	77 e2                	ja     801231 <memset+0x57>
			*p64++ = data_block, n -= 8;
	}

	if(n){
  80124f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801253:	74 23                	je     801278 <memset+0x9e>
		uint8* p8 = (uint8*)p64;
  801255:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801258:	89 45 f8             	mov    %eax,-0x8(%ebp)
		while (n-- > 0)
  80125b:	eb 0e                	jmp    80126b <memset+0x91>
			*p8++ = (uint8)c;
  80125d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801260:	8d 50 01             	lea    0x1(%eax),%edx
  801263:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801266:	8b 55 0c             	mov    0xc(%ebp),%edx
  801269:	88 10                	mov    %dl,(%eax)
			*p64++ = data_block, n -= 8;
	}

	if(n){
		uint8* p8 = (uint8*)p64;
		while (n-- > 0)
  80126b:	8b 45 10             	mov    0x10(%ebp),%eax
  80126e:	8d 50 ff             	lea    -0x1(%eax),%edx
  801271:	89 55 10             	mov    %edx,0x10(%ebp)
  801274:	85 c0                	test   %eax,%eax
  801276:	75 e5                	jne    80125d <memset+0x83>
			*p8++ = (uint8)c;
	}

	return v;
  801278:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80127b:	c9                   	leave  
  80127c:	c3                   	ret    

0080127d <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  80127d:	55                   	push   %ebp
  80127e:	89 e5                	mov    %esp,%ebp
  801280:	83 ec 10             	sub    $0x10,%esp
	//	s = src;
	//	d = dst;
	//	while (n-- > 0)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
  801283:	8b 45 0c             	mov    0xc(%ebp),%eax
  801286:	89 45 fc             	mov    %eax,-0x4(%ebp)
	uint64* d64 = (uint64*)dst;
  801289:	8b 45 08             	mov    0x8(%ebp),%eax
  80128c:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if(n >= 8){
  80128f:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  801293:	76 24                	jbe    8012b9 <memcpy+0x3c>
		while(n >= 8){
  801295:	eb 1c                	jmp    8012b3 <memcpy+0x36>
			*d64 = *s64;
  801297:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80129a:	8b 50 04             	mov    0x4(%eax),%edx
  80129d:	8b 00                	mov    (%eax),%eax
  80129f:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8012a2:	89 01                	mov    %eax,(%ecx)
  8012a4:	89 51 04             	mov    %edx,0x4(%ecx)
			n -= 8;
  8012a7:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
			++s64;
  8012ab:	83 45 fc 08          	addl   $0x8,-0x4(%ebp)
			++d64;
  8012af:	83 45 f8 08          	addl   $0x8,-0x8(%ebp)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
	uint64* d64 = (uint64*)dst;
	if(n >= 8){
		while(n >= 8){
  8012b3:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  8012b7:	77 de                	ja     801297 <memcpy+0x1a>
			++s64;
			++d64;
		}
	}

	if(n){
  8012b9:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8012bd:	74 31                	je     8012f0 <memcpy+0x73>
		uint8* s8 = (uint8*)s64;
  8012bf:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8012c2:	89 45 f4             	mov    %eax,-0xc(%ebp)
		uint8* d8 = (uint8*)d64;
  8012c5:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8012c8:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (n-- > 0)
  8012cb:	eb 16                	jmp    8012e3 <memcpy+0x66>
			*d8++ = *s8++;
  8012cd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8012d0:	8d 50 01             	lea    0x1(%eax),%edx
  8012d3:	89 55 f0             	mov    %edx,-0x10(%ebp)
  8012d6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8012d9:	8d 4a 01             	lea    0x1(%edx),%ecx
  8012dc:	89 4d f4             	mov    %ecx,-0xc(%ebp)
  8012df:	8a 12                	mov    (%edx),%dl
  8012e1:	88 10                	mov    %dl,(%eax)
	}

	if(n){
		uint8* s8 = (uint8*)s64;
		uint8* d8 = (uint8*)d64;
		while (n-- > 0)
  8012e3:	8b 45 10             	mov    0x10(%ebp),%eax
  8012e6:	8d 50 ff             	lea    -0x1(%eax),%edx
  8012e9:	89 55 10             	mov    %edx,0x10(%ebp)
  8012ec:	85 c0                	test   %eax,%eax
  8012ee:	75 dd                	jne    8012cd <memcpy+0x50>
			*d8++ = *s8++;
	}
	return dst;
  8012f0:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8012f3:	c9                   	leave  
  8012f4:	c3                   	ret    

008012f5 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  8012f5:	55                   	push   %ebp
  8012f6:	89 e5                	mov    %esp,%ebp
  8012f8:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  8012fb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012fe:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801301:	8b 45 08             	mov    0x8(%ebp),%eax
  801304:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  801307:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80130a:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  80130d:	73 50                	jae    80135f <memmove+0x6a>
  80130f:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801312:	8b 45 10             	mov    0x10(%ebp),%eax
  801315:	01 d0                	add    %edx,%eax
  801317:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  80131a:	76 43                	jbe    80135f <memmove+0x6a>
		s += n;
  80131c:	8b 45 10             	mov    0x10(%ebp),%eax
  80131f:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  801322:	8b 45 10             	mov    0x10(%ebp),%eax
  801325:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  801328:	eb 10                	jmp    80133a <memmove+0x45>
			*--d = *--s;
  80132a:	ff 4d f8             	decl   -0x8(%ebp)
  80132d:	ff 4d fc             	decl   -0x4(%ebp)
  801330:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801333:	8a 10                	mov    (%eax),%dl
  801335:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801338:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  80133a:	8b 45 10             	mov    0x10(%ebp),%eax
  80133d:	8d 50 ff             	lea    -0x1(%eax),%edx
  801340:	89 55 10             	mov    %edx,0x10(%ebp)
  801343:	85 c0                	test   %eax,%eax
  801345:	75 e3                	jne    80132a <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  801347:	eb 23                	jmp    80136c <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  801349:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80134c:	8d 50 01             	lea    0x1(%eax),%edx
  80134f:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801352:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801355:	8d 4a 01             	lea    0x1(%edx),%ecx
  801358:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  80135b:	8a 12                	mov    (%edx),%dl
  80135d:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  80135f:	8b 45 10             	mov    0x10(%ebp),%eax
  801362:	8d 50 ff             	lea    -0x1(%eax),%edx
  801365:	89 55 10             	mov    %edx,0x10(%ebp)
  801368:	85 c0                	test   %eax,%eax
  80136a:	75 dd                	jne    801349 <memmove+0x54>
			*d++ = *s++;

	return dst;
  80136c:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80136f:	c9                   	leave  
  801370:	c3                   	ret    

00801371 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  801371:	55                   	push   %ebp
  801372:	89 e5                	mov    %esp,%ebp
  801374:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  801377:	8b 45 08             	mov    0x8(%ebp),%eax
  80137a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  80137d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801380:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  801383:	eb 2a                	jmp    8013af <memcmp+0x3e>
		if (*s1 != *s2)
  801385:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801388:	8a 10                	mov    (%eax),%dl
  80138a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80138d:	8a 00                	mov    (%eax),%al
  80138f:	38 c2                	cmp    %al,%dl
  801391:	74 16                	je     8013a9 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  801393:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801396:	8a 00                	mov    (%eax),%al
  801398:	0f b6 d0             	movzbl %al,%edx
  80139b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80139e:	8a 00                	mov    (%eax),%al
  8013a0:	0f b6 c0             	movzbl %al,%eax
  8013a3:	29 c2                	sub    %eax,%edx
  8013a5:	89 d0                	mov    %edx,%eax
  8013a7:	eb 18                	jmp    8013c1 <memcmp+0x50>
		s1++, s2++;
  8013a9:	ff 45 fc             	incl   -0x4(%ebp)
  8013ac:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  8013af:	8b 45 10             	mov    0x10(%ebp),%eax
  8013b2:	8d 50 ff             	lea    -0x1(%eax),%edx
  8013b5:	89 55 10             	mov    %edx,0x10(%ebp)
  8013b8:	85 c0                	test   %eax,%eax
  8013ba:	75 c9                	jne    801385 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  8013bc:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8013c1:	c9                   	leave  
  8013c2:	c3                   	ret    

008013c3 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  8013c3:	55                   	push   %ebp
  8013c4:	89 e5                	mov    %esp,%ebp
  8013c6:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  8013c9:	8b 55 08             	mov    0x8(%ebp),%edx
  8013cc:	8b 45 10             	mov    0x10(%ebp),%eax
  8013cf:	01 d0                	add    %edx,%eax
  8013d1:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  8013d4:	eb 15                	jmp    8013eb <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  8013d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8013d9:	8a 00                	mov    (%eax),%al
  8013db:	0f b6 d0             	movzbl %al,%edx
  8013de:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013e1:	0f b6 c0             	movzbl %al,%eax
  8013e4:	39 c2                	cmp    %eax,%edx
  8013e6:	74 0d                	je     8013f5 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  8013e8:	ff 45 08             	incl   0x8(%ebp)
  8013eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8013ee:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  8013f1:	72 e3                	jb     8013d6 <memfind+0x13>
  8013f3:	eb 01                	jmp    8013f6 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  8013f5:	90                   	nop
	return (void *) s;
  8013f6:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8013f9:	c9                   	leave  
  8013fa:	c3                   	ret    

008013fb <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  8013fb:	55                   	push   %ebp
  8013fc:	89 e5                	mov    %esp,%ebp
  8013fe:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  801401:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  801408:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80140f:	eb 03                	jmp    801414 <strtol+0x19>
		s++;
  801411:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801414:	8b 45 08             	mov    0x8(%ebp),%eax
  801417:	8a 00                	mov    (%eax),%al
  801419:	3c 20                	cmp    $0x20,%al
  80141b:	74 f4                	je     801411 <strtol+0x16>
  80141d:	8b 45 08             	mov    0x8(%ebp),%eax
  801420:	8a 00                	mov    (%eax),%al
  801422:	3c 09                	cmp    $0x9,%al
  801424:	74 eb                	je     801411 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  801426:	8b 45 08             	mov    0x8(%ebp),%eax
  801429:	8a 00                	mov    (%eax),%al
  80142b:	3c 2b                	cmp    $0x2b,%al
  80142d:	75 05                	jne    801434 <strtol+0x39>
		s++;
  80142f:	ff 45 08             	incl   0x8(%ebp)
  801432:	eb 13                	jmp    801447 <strtol+0x4c>
	else if (*s == '-')
  801434:	8b 45 08             	mov    0x8(%ebp),%eax
  801437:	8a 00                	mov    (%eax),%al
  801439:	3c 2d                	cmp    $0x2d,%al
  80143b:	75 0a                	jne    801447 <strtol+0x4c>
		s++, neg = 1;
  80143d:	ff 45 08             	incl   0x8(%ebp)
  801440:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801447:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80144b:	74 06                	je     801453 <strtol+0x58>
  80144d:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  801451:	75 20                	jne    801473 <strtol+0x78>
  801453:	8b 45 08             	mov    0x8(%ebp),%eax
  801456:	8a 00                	mov    (%eax),%al
  801458:	3c 30                	cmp    $0x30,%al
  80145a:	75 17                	jne    801473 <strtol+0x78>
  80145c:	8b 45 08             	mov    0x8(%ebp),%eax
  80145f:	40                   	inc    %eax
  801460:	8a 00                	mov    (%eax),%al
  801462:	3c 78                	cmp    $0x78,%al
  801464:	75 0d                	jne    801473 <strtol+0x78>
		s += 2, base = 16;
  801466:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  80146a:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  801471:	eb 28                	jmp    80149b <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  801473:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801477:	75 15                	jne    80148e <strtol+0x93>
  801479:	8b 45 08             	mov    0x8(%ebp),%eax
  80147c:	8a 00                	mov    (%eax),%al
  80147e:	3c 30                	cmp    $0x30,%al
  801480:	75 0c                	jne    80148e <strtol+0x93>
		s++, base = 8;
  801482:	ff 45 08             	incl   0x8(%ebp)
  801485:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  80148c:	eb 0d                	jmp    80149b <strtol+0xa0>
	else if (base == 0)
  80148e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801492:	75 07                	jne    80149b <strtol+0xa0>
		base = 10;
  801494:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  80149b:	8b 45 08             	mov    0x8(%ebp),%eax
  80149e:	8a 00                	mov    (%eax),%al
  8014a0:	3c 2f                	cmp    $0x2f,%al
  8014a2:	7e 19                	jle    8014bd <strtol+0xc2>
  8014a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8014a7:	8a 00                	mov    (%eax),%al
  8014a9:	3c 39                	cmp    $0x39,%al
  8014ab:	7f 10                	jg     8014bd <strtol+0xc2>
			dig = *s - '0';
  8014ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8014b0:	8a 00                	mov    (%eax),%al
  8014b2:	0f be c0             	movsbl %al,%eax
  8014b5:	83 e8 30             	sub    $0x30,%eax
  8014b8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8014bb:	eb 42                	jmp    8014ff <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  8014bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8014c0:	8a 00                	mov    (%eax),%al
  8014c2:	3c 60                	cmp    $0x60,%al
  8014c4:	7e 19                	jle    8014df <strtol+0xe4>
  8014c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8014c9:	8a 00                	mov    (%eax),%al
  8014cb:	3c 7a                	cmp    $0x7a,%al
  8014cd:	7f 10                	jg     8014df <strtol+0xe4>
			dig = *s - 'a' + 10;
  8014cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8014d2:	8a 00                	mov    (%eax),%al
  8014d4:	0f be c0             	movsbl %al,%eax
  8014d7:	83 e8 57             	sub    $0x57,%eax
  8014da:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8014dd:	eb 20                	jmp    8014ff <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  8014df:	8b 45 08             	mov    0x8(%ebp),%eax
  8014e2:	8a 00                	mov    (%eax),%al
  8014e4:	3c 40                	cmp    $0x40,%al
  8014e6:	7e 39                	jle    801521 <strtol+0x126>
  8014e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8014eb:	8a 00                	mov    (%eax),%al
  8014ed:	3c 5a                	cmp    $0x5a,%al
  8014ef:	7f 30                	jg     801521 <strtol+0x126>
			dig = *s - 'A' + 10;
  8014f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8014f4:	8a 00                	mov    (%eax),%al
  8014f6:	0f be c0             	movsbl %al,%eax
  8014f9:	83 e8 37             	sub    $0x37,%eax
  8014fc:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  8014ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801502:	3b 45 10             	cmp    0x10(%ebp),%eax
  801505:	7d 19                	jge    801520 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801507:	ff 45 08             	incl   0x8(%ebp)
  80150a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80150d:	0f af 45 10          	imul   0x10(%ebp),%eax
  801511:	89 c2                	mov    %eax,%edx
  801513:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801516:	01 d0                	add    %edx,%eax
  801518:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  80151b:	e9 7b ff ff ff       	jmp    80149b <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801520:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801521:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801525:	74 08                	je     80152f <strtol+0x134>
		*endptr = (char *) s;
  801527:	8b 45 0c             	mov    0xc(%ebp),%eax
  80152a:	8b 55 08             	mov    0x8(%ebp),%edx
  80152d:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  80152f:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801533:	74 07                	je     80153c <strtol+0x141>
  801535:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801538:	f7 d8                	neg    %eax
  80153a:	eb 03                	jmp    80153f <strtol+0x144>
  80153c:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  80153f:	c9                   	leave  
  801540:	c3                   	ret    

00801541 <ltostr>:

void
ltostr(long value, char *str)
{
  801541:	55                   	push   %ebp
  801542:	89 e5                	mov    %esp,%ebp
  801544:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  801547:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  80154e:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  801555:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801559:	79 13                	jns    80156e <ltostr+0x2d>
	{
		neg = 1;
  80155b:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  801562:	8b 45 0c             	mov    0xc(%ebp),%eax
  801565:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  801568:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  80156b:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  80156e:	8b 45 08             	mov    0x8(%ebp),%eax
  801571:	b9 0a 00 00 00       	mov    $0xa,%ecx
  801576:	99                   	cltd   
  801577:	f7 f9                	idiv   %ecx
  801579:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  80157c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80157f:	8d 50 01             	lea    0x1(%eax),%edx
  801582:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801585:	89 c2                	mov    %eax,%edx
  801587:	8b 45 0c             	mov    0xc(%ebp),%eax
  80158a:	01 d0                	add    %edx,%eax
  80158c:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80158f:	83 c2 30             	add    $0x30,%edx
  801592:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  801594:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801597:	b8 67 66 66 66       	mov    $0x66666667,%eax
  80159c:	f7 e9                	imul   %ecx
  80159e:	c1 fa 02             	sar    $0x2,%edx
  8015a1:	89 c8                	mov    %ecx,%eax
  8015a3:	c1 f8 1f             	sar    $0x1f,%eax
  8015a6:	29 c2                	sub    %eax,%edx
  8015a8:	89 d0                	mov    %edx,%eax
  8015aa:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  8015ad:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8015b1:	75 bb                	jne    80156e <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  8015b3:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  8015ba:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8015bd:	48                   	dec    %eax
  8015be:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  8015c1:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8015c5:	74 3d                	je     801604 <ltostr+0xc3>
		start = 1 ;
  8015c7:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  8015ce:	eb 34                	jmp    801604 <ltostr+0xc3>
	{
		char tmp = str[start] ;
  8015d0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8015d3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015d6:	01 d0                	add    %edx,%eax
  8015d8:	8a 00                	mov    (%eax),%al
  8015da:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  8015dd:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8015e0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015e3:	01 c2                	add    %eax,%edx
  8015e5:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  8015e8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015eb:	01 c8                	add    %ecx,%eax
  8015ed:	8a 00                	mov    (%eax),%al
  8015ef:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  8015f1:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8015f4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015f7:	01 c2                	add    %eax,%edx
  8015f9:	8a 45 eb             	mov    -0x15(%ebp),%al
  8015fc:	88 02                	mov    %al,(%edx)
		start++ ;
  8015fe:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801601:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801604:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801607:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80160a:	7c c4                	jl     8015d0 <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  80160c:	8b 55 f8             	mov    -0x8(%ebp),%edx
  80160f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801612:	01 d0                	add    %edx,%eax
  801614:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801617:	90                   	nop
  801618:	c9                   	leave  
  801619:	c3                   	ret    

0080161a <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  80161a:	55                   	push   %ebp
  80161b:	89 e5                	mov    %esp,%ebp
  80161d:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801620:	ff 75 08             	pushl  0x8(%ebp)
  801623:	e8 c4 f9 ff ff       	call   800fec <strlen>
  801628:	83 c4 04             	add    $0x4,%esp
  80162b:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  80162e:	ff 75 0c             	pushl  0xc(%ebp)
  801631:	e8 b6 f9 ff ff       	call   800fec <strlen>
  801636:	83 c4 04             	add    $0x4,%esp
  801639:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  80163c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  801643:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80164a:	eb 17                	jmp    801663 <strcconcat+0x49>
		final[s] = str1[s] ;
  80164c:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80164f:	8b 45 10             	mov    0x10(%ebp),%eax
  801652:	01 c2                	add    %eax,%edx
  801654:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801657:	8b 45 08             	mov    0x8(%ebp),%eax
  80165a:	01 c8                	add    %ecx,%eax
  80165c:	8a 00                	mov    (%eax),%al
  80165e:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  801660:	ff 45 fc             	incl   -0x4(%ebp)
  801663:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801666:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801669:	7c e1                	jl     80164c <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  80166b:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  801672:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  801679:	eb 1f                	jmp    80169a <strcconcat+0x80>
		final[s++] = str2[i] ;
  80167b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80167e:	8d 50 01             	lea    0x1(%eax),%edx
  801681:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801684:	89 c2                	mov    %eax,%edx
  801686:	8b 45 10             	mov    0x10(%ebp),%eax
  801689:	01 c2                	add    %eax,%edx
  80168b:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  80168e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801691:	01 c8                	add    %ecx,%eax
  801693:	8a 00                	mov    (%eax),%al
  801695:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801697:	ff 45 f8             	incl   -0x8(%ebp)
  80169a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80169d:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8016a0:	7c d9                	jl     80167b <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  8016a2:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8016a5:	8b 45 10             	mov    0x10(%ebp),%eax
  8016a8:	01 d0                	add    %edx,%eax
  8016aa:	c6 00 00             	movb   $0x0,(%eax)
}
  8016ad:	90                   	nop
  8016ae:	c9                   	leave  
  8016af:	c3                   	ret    

008016b0 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  8016b0:	55                   	push   %ebp
  8016b1:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  8016b3:	8b 45 14             	mov    0x14(%ebp),%eax
  8016b6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  8016bc:	8b 45 14             	mov    0x14(%ebp),%eax
  8016bf:	8b 00                	mov    (%eax),%eax
  8016c1:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8016c8:	8b 45 10             	mov    0x10(%ebp),%eax
  8016cb:	01 d0                	add    %edx,%eax
  8016cd:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8016d3:	eb 0c                	jmp    8016e1 <strsplit+0x31>
			*string++ = 0;
  8016d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8016d8:	8d 50 01             	lea    0x1(%eax),%edx
  8016db:	89 55 08             	mov    %edx,0x8(%ebp)
  8016de:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8016e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8016e4:	8a 00                	mov    (%eax),%al
  8016e6:	84 c0                	test   %al,%al
  8016e8:	74 18                	je     801702 <strsplit+0x52>
  8016ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8016ed:	8a 00                	mov    (%eax),%al
  8016ef:	0f be c0             	movsbl %al,%eax
  8016f2:	50                   	push   %eax
  8016f3:	ff 75 0c             	pushl  0xc(%ebp)
  8016f6:	e8 83 fa ff ff       	call   80117e <strchr>
  8016fb:	83 c4 08             	add    $0x8,%esp
  8016fe:	85 c0                	test   %eax,%eax
  801700:	75 d3                	jne    8016d5 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801702:	8b 45 08             	mov    0x8(%ebp),%eax
  801705:	8a 00                	mov    (%eax),%al
  801707:	84 c0                	test   %al,%al
  801709:	74 5a                	je     801765 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  80170b:	8b 45 14             	mov    0x14(%ebp),%eax
  80170e:	8b 00                	mov    (%eax),%eax
  801710:	83 f8 0f             	cmp    $0xf,%eax
  801713:	75 07                	jne    80171c <strsplit+0x6c>
		{
			return 0;
  801715:	b8 00 00 00 00       	mov    $0x0,%eax
  80171a:	eb 66                	jmp    801782 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  80171c:	8b 45 14             	mov    0x14(%ebp),%eax
  80171f:	8b 00                	mov    (%eax),%eax
  801721:	8d 48 01             	lea    0x1(%eax),%ecx
  801724:	8b 55 14             	mov    0x14(%ebp),%edx
  801727:	89 0a                	mov    %ecx,(%edx)
  801729:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801730:	8b 45 10             	mov    0x10(%ebp),%eax
  801733:	01 c2                	add    %eax,%edx
  801735:	8b 45 08             	mov    0x8(%ebp),%eax
  801738:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  80173a:	eb 03                	jmp    80173f <strsplit+0x8f>
			string++;
  80173c:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  80173f:	8b 45 08             	mov    0x8(%ebp),%eax
  801742:	8a 00                	mov    (%eax),%al
  801744:	84 c0                	test   %al,%al
  801746:	74 8b                	je     8016d3 <strsplit+0x23>
  801748:	8b 45 08             	mov    0x8(%ebp),%eax
  80174b:	8a 00                	mov    (%eax),%al
  80174d:	0f be c0             	movsbl %al,%eax
  801750:	50                   	push   %eax
  801751:	ff 75 0c             	pushl  0xc(%ebp)
  801754:	e8 25 fa ff ff       	call   80117e <strchr>
  801759:	83 c4 08             	add    $0x8,%esp
  80175c:	85 c0                	test   %eax,%eax
  80175e:	74 dc                	je     80173c <strsplit+0x8c>
			string++;
	}
  801760:	e9 6e ff ff ff       	jmp    8016d3 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801765:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801766:	8b 45 14             	mov    0x14(%ebp),%eax
  801769:	8b 00                	mov    (%eax),%eax
  80176b:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801772:	8b 45 10             	mov    0x10(%ebp),%eax
  801775:	01 d0                	add    %edx,%eax
  801777:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  80177d:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801782:	c9                   	leave  
  801783:	c3                   	ret    

00801784 <str2lower>:


char* str2lower(char *dst, const char *src)
{
  801784:	55                   	push   %ebp
  801785:	89 e5                	mov    %esp,%ebp
  801787:	83 ec 10             	sub    $0x10,%esp
	char* ret = dst;
  80178a:	8b 45 08             	mov    0x8(%ebp),%eax
  80178d:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (int i = 0; i < strlen(src); ++i)
  801790:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801797:	eb 4a                	jmp    8017e3 <str2lower+0x5f>
	{
		dst[i] = src[i] ;
  801799:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80179c:	8b 45 08             	mov    0x8(%ebp),%eax
  80179f:	01 c2                	add    %eax,%edx
  8017a1:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8017a4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017a7:	01 c8                	add    %ecx,%eax
  8017a9:	8a 00                	mov    (%eax),%al
  8017ab:	88 02                	mov    %al,(%edx)
		if (src[i] >= 'A' && src[i] <= 'Z')
  8017ad:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8017b0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017b3:	01 d0                	add    %edx,%eax
  8017b5:	8a 00                	mov    (%eax),%al
  8017b7:	3c 40                	cmp    $0x40,%al
  8017b9:	7e 25                	jle    8017e0 <str2lower+0x5c>
  8017bb:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8017be:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017c1:	01 d0                	add    %edx,%eax
  8017c3:	8a 00                	mov    (%eax),%al
  8017c5:	3c 5a                	cmp    $0x5a,%al
  8017c7:	7f 17                	jg     8017e0 <str2lower+0x5c>
		{
			dst[i] += 32 ;
  8017c9:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8017cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8017cf:	01 d0                	add    %edx,%eax
  8017d1:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8017d4:	8b 55 08             	mov    0x8(%ebp),%edx
  8017d7:	01 ca                	add    %ecx,%edx
  8017d9:	8a 12                	mov    (%edx),%dl
  8017db:	83 c2 20             	add    $0x20,%edx
  8017de:	88 10                	mov    %dl,(%eax)


char* str2lower(char *dst, const char *src)
{
	char* ret = dst;
	for (int i = 0; i < strlen(src); ++i)
  8017e0:	ff 45 fc             	incl   -0x4(%ebp)
  8017e3:	ff 75 0c             	pushl  0xc(%ebp)
  8017e6:	e8 01 f8 ff ff       	call   800fec <strlen>
  8017eb:	83 c4 04             	add    $0x4,%esp
  8017ee:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  8017f1:	7f a6                	jg     801799 <str2lower+0x15>
		if (src[i] >= 'A' && src[i] <= 'Z')
		{
			dst[i] += 32 ;
		}
	}
	return ret;
  8017f3:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8017f6:	c9                   	leave  
  8017f7:	c3                   	ret    

008017f8 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  8017f8:	55                   	push   %ebp
  8017f9:	89 e5                	mov    %esp,%ebp
  8017fb:	57                   	push   %edi
  8017fc:	56                   	push   %esi
  8017fd:	53                   	push   %ebx
  8017fe:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801801:	8b 45 08             	mov    0x8(%ebp),%eax
  801804:	8b 55 0c             	mov    0xc(%ebp),%edx
  801807:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80180a:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80180d:	8b 7d 18             	mov    0x18(%ebp),%edi
  801810:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801813:	cd 30                	int    $0x30
  801815:	89 45 f0             	mov    %eax,-0x10(%ebp)
				"b" (a3),
				"D" (a4),
				"S" (a5)
				: "cc", "memory");

	return ret;
  801818:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80181b:	83 c4 10             	add    $0x10,%esp
  80181e:	5b                   	pop    %ebx
  80181f:	5e                   	pop    %esi
  801820:	5f                   	pop    %edi
  801821:	5d                   	pop    %ebp
  801822:	c3                   	ret    

00801823 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName, int color)
{
  801823:	55                   	push   %ebp
  801824:	89 e5                	mov    %esp,%ebp
  801826:	83 ec 04             	sub    $0x4,%esp
  801829:	8b 45 10             	mov    0x10(%ebp),%eax
  80182c:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, color, 0);
  80182f:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801832:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801836:	8b 45 08             	mov    0x8(%ebp),%eax
  801839:	6a 00                	push   $0x0
  80183b:	51                   	push   %ecx
  80183c:	52                   	push   %edx
  80183d:	ff 75 0c             	pushl  0xc(%ebp)
  801840:	50                   	push   %eax
  801841:	6a 00                	push   $0x0
  801843:	e8 b0 ff ff ff       	call   8017f8 <syscall>
  801848:	83 c4 18             	add    $0x18,%esp
}
  80184b:	90                   	nop
  80184c:	c9                   	leave  
  80184d:	c3                   	ret    

0080184e <sys_cgetc>:

int
sys_cgetc(void)
{
  80184e:	55                   	push   %ebp
  80184f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801851:	6a 00                	push   $0x0
  801853:	6a 00                	push   $0x0
  801855:	6a 00                	push   $0x0
  801857:	6a 00                	push   $0x0
  801859:	6a 00                	push   $0x0
  80185b:	6a 02                	push   $0x2
  80185d:	e8 96 ff ff ff       	call   8017f8 <syscall>
  801862:	83 c4 18             	add    $0x18,%esp
}
  801865:	c9                   	leave  
  801866:	c3                   	ret    

00801867 <sys_lock_cons>:

void sys_lock_cons(void)
{
  801867:	55                   	push   %ebp
  801868:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  80186a:	6a 00                	push   $0x0
  80186c:	6a 00                	push   $0x0
  80186e:	6a 00                	push   $0x0
  801870:	6a 00                	push   $0x0
  801872:	6a 00                	push   $0x0
  801874:	6a 03                	push   $0x3
  801876:	e8 7d ff ff ff       	call   8017f8 <syscall>
  80187b:	83 c4 18             	add    $0x18,%esp
}
  80187e:	90                   	nop
  80187f:	c9                   	leave  
  801880:	c3                   	ret    

00801881 <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  801881:	55                   	push   %ebp
  801882:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  801884:	6a 00                	push   $0x0
  801886:	6a 00                	push   $0x0
  801888:	6a 00                	push   $0x0
  80188a:	6a 00                	push   $0x0
  80188c:	6a 00                	push   $0x0
  80188e:	6a 04                	push   $0x4
  801890:	e8 63 ff ff ff       	call   8017f8 <syscall>
  801895:	83 c4 18             	add    $0x18,%esp
}
  801898:	90                   	nop
  801899:	c9                   	leave  
  80189a:	c3                   	ret    

0080189b <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  80189b:	55                   	push   %ebp
  80189c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  80189e:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8018a4:	6a 00                	push   $0x0
  8018a6:	6a 00                	push   $0x0
  8018a8:	6a 00                	push   $0x0
  8018aa:	52                   	push   %edx
  8018ab:	50                   	push   %eax
  8018ac:	6a 08                	push   $0x8
  8018ae:	e8 45 ff ff ff       	call   8017f8 <syscall>
  8018b3:	83 c4 18             	add    $0x18,%esp
}
  8018b6:	c9                   	leave  
  8018b7:	c3                   	ret    

008018b8 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  8018b8:	55                   	push   %ebp
  8018b9:	89 e5                	mov    %esp,%ebp
  8018bb:	56                   	push   %esi
  8018bc:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  8018bd:	8b 75 18             	mov    0x18(%ebp),%esi
  8018c0:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8018c3:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8018c6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8018cc:	56                   	push   %esi
  8018cd:	53                   	push   %ebx
  8018ce:	51                   	push   %ecx
  8018cf:	52                   	push   %edx
  8018d0:	50                   	push   %eax
  8018d1:	6a 09                	push   $0x9
  8018d3:	e8 20 ff ff ff       	call   8017f8 <syscall>
  8018d8:	83 c4 18             	add    $0x18,%esp
}
  8018db:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8018de:	5b                   	pop    %ebx
  8018df:	5e                   	pop    %esi
  8018e0:	5d                   	pop    %ebp
  8018e1:	c3                   	ret    

008018e2 <__sys_unmap_frame>:

int __sys_unmap_frame(uint32 va)
{
  8018e2:	55                   	push   %ebp
  8018e3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, va, 0, 0, 0, 0);
  8018e5:	6a 00                	push   $0x0
  8018e7:	6a 00                	push   $0x0
  8018e9:	6a 00                	push   $0x0
  8018eb:	6a 00                	push   $0x0
  8018ed:	ff 75 08             	pushl  0x8(%ebp)
  8018f0:	6a 0a                	push   $0xa
  8018f2:	e8 01 ff ff ff       	call   8017f8 <syscall>
  8018f7:	83 c4 18             	add    $0x18,%esp
}
  8018fa:	c9                   	leave  
  8018fb:	c3                   	ret    

008018fc <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  8018fc:	55                   	push   %ebp
  8018fd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  8018ff:	6a 00                	push   $0x0
  801901:	6a 00                	push   $0x0
  801903:	6a 00                	push   $0x0
  801905:	ff 75 0c             	pushl  0xc(%ebp)
  801908:	ff 75 08             	pushl  0x8(%ebp)
  80190b:	6a 0b                	push   $0xb
  80190d:	e8 e6 fe ff ff       	call   8017f8 <syscall>
  801912:	83 c4 18             	add    $0x18,%esp
}
  801915:	c9                   	leave  
  801916:	c3                   	ret    

00801917 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801917:	55                   	push   %ebp
  801918:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  80191a:	6a 00                	push   $0x0
  80191c:	6a 00                	push   $0x0
  80191e:	6a 00                	push   $0x0
  801920:	6a 00                	push   $0x0
  801922:	6a 00                	push   $0x0
  801924:	6a 0c                	push   $0xc
  801926:	e8 cd fe ff ff       	call   8017f8 <syscall>
  80192b:	83 c4 18             	add    $0x18,%esp
}
  80192e:	c9                   	leave  
  80192f:	c3                   	ret    

00801930 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801930:	55                   	push   %ebp
  801931:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801933:	6a 00                	push   $0x0
  801935:	6a 00                	push   $0x0
  801937:	6a 00                	push   $0x0
  801939:	6a 00                	push   $0x0
  80193b:	6a 00                	push   $0x0
  80193d:	6a 0d                	push   $0xd
  80193f:	e8 b4 fe ff ff       	call   8017f8 <syscall>
  801944:	83 c4 18             	add    $0x18,%esp
}
  801947:	c9                   	leave  
  801948:	c3                   	ret    

00801949 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801949:	55                   	push   %ebp
  80194a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  80194c:	6a 00                	push   $0x0
  80194e:	6a 00                	push   $0x0
  801950:	6a 00                	push   $0x0
  801952:	6a 00                	push   $0x0
  801954:	6a 00                	push   $0x0
  801956:	6a 0e                	push   $0xe
  801958:	e8 9b fe ff ff       	call   8017f8 <syscall>
  80195d:	83 c4 18             	add    $0x18,%esp
}
  801960:	c9                   	leave  
  801961:	c3                   	ret    

00801962 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801962:	55                   	push   %ebp
  801963:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801965:	6a 00                	push   $0x0
  801967:	6a 00                	push   $0x0
  801969:	6a 00                	push   $0x0
  80196b:	6a 00                	push   $0x0
  80196d:	6a 00                	push   $0x0
  80196f:	6a 0f                	push   $0xf
  801971:	e8 82 fe ff ff       	call   8017f8 <syscall>
  801976:	83 c4 18             	add    $0x18,%esp
}
  801979:	c9                   	leave  
  80197a:	c3                   	ret    

0080197b <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  80197b:	55                   	push   %ebp
  80197c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  80197e:	6a 00                	push   $0x0
  801980:	6a 00                	push   $0x0
  801982:	6a 00                	push   $0x0
  801984:	6a 00                	push   $0x0
  801986:	ff 75 08             	pushl  0x8(%ebp)
  801989:	6a 10                	push   $0x10
  80198b:	e8 68 fe ff ff       	call   8017f8 <syscall>
  801990:	83 c4 18             	add    $0x18,%esp
}
  801993:	c9                   	leave  
  801994:	c3                   	ret    

00801995 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801995:	55                   	push   %ebp
  801996:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801998:	6a 00                	push   $0x0
  80199a:	6a 00                	push   $0x0
  80199c:	6a 00                	push   $0x0
  80199e:	6a 00                	push   $0x0
  8019a0:	6a 00                	push   $0x0
  8019a2:	6a 11                	push   $0x11
  8019a4:	e8 4f fe ff ff       	call   8017f8 <syscall>
  8019a9:	83 c4 18             	add    $0x18,%esp
}
  8019ac:	90                   	nop
  8019ad:	c9                   	leave  
  8019ae:	c3                   	ret    

008019af <sys_cputc>:

void
sys_cputc(const char c)
{
  8019af:	55                   	push   %ebp
  8019b0:	89 e5                	mov    %esp,%ebp
  8019b2:	83 ec 04             	sub    $0x4,%esp
  8019b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8019b8:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  8019bb:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8019bf:	6a 00                	push   $0x0
  8019c1:	6a 00                	push   $0x0
  8019c3:	6a 00                	push   $0x0
  8019c5:	6a 00                	push   $0x0
  8019c7:	50                   	push   %eax
  8019c8:	6a 01                	push   $0x1
  8019ca:	e8 29 fe ff ff       	call   8017f8 <syscall>
  8019cf:	83 c4 18             	add    $0x18,%esp
}
  8019d2:	90                   	nop
  8019d3:	c9                   	leave  
  8019d4:	c3                   	ret    

008019d5 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  8019d5:	55                   	push   %ebp
  8019d6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  8019d8:	6a 00                	push   $0x0
  8019da:	6a 00                	push   $0x0
  8019dc:	6a 00                	push   $0x0
  8019de:	6a 00                	push   $0x0
  8019e0:	6a 00                	push   $0x0
  8019e2:	6a 14                	push   $0x14
  8019e4:	e8 0f fe ff ff       	call   8017f8 <syscall>
  8019e9:	83 c4 18             	add    $0x18,%esp
}
  8019ec:	90                   	nop
  8019ed:	c9                   	leave  
  8019ee:	c3                   	ret    

008019ef <sys_create_shared_object>:

int sys_create_shared_object(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  8019ef:	55                   	push   %ebp
  8019f0:	89 e5                	mov    %esp,%ebp
  8019f2:	83 ec 04             	sub    $0x4,%esp
  8019f5:	8b 45 10             	mov    0x10(%ebp),%eax
  8019f8:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  8019fb:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8019fe:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801a02:	8b 45 08             	mov    0x8(%ebp),%eax
  801a05:	6a 00                	push   $0x0
  801a07:	51                   	push   %ecx
  801a08:	52                   	push   %edx
  801a09:	ff 75 0c             	pushl  0xc(%ebp)
  801a0c:	50                   	push   %eax
  801a0d:	6a 15                	push   $0x15
  801a0f:	e8 e4 fd ff ff       	call   8017f8 <syscall>
  801a14:	83 c4 18             	add    $0x18,%esp
}
  801a17:	c9                   	leave  
  801a18:	c3                   	ret    

00801a19 <sys_size_of_shared_object>:

//2017:
int sys_size_of_shared_object(int32 ownerID, char* shareName)
{
  801a19:	55                   	push   %ebp
  801a1a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801a1c:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a1f:	8b 45 08             	mov    0x8(%ebp),%eax
  801a22:	6a 00                	push   $0x0
  801a24:	6a 00                	push   $0x0
  801a26:	6a 00                	push   $0x0
  801a28:	52                   	push   %edx
  801a29:	50                   	push   %eax
  801a2a:	6a 16                	push   $0x16
  801a2c:	e8 c7 fd ff ff       	call   8017f8 <syscall>
  801a31:	83 c4 18             	add    $0x18,%esp
}
  801a34:	c9                   	leave  
  801a35:	c3                   	ret    

00801a36 <sys_get_shared_object>:
//==========

int sys_get_shared_object(int32 ownerID, char* shareName, void* virtual_address)
{
  801a36:	55                   	push   %ebp
  801a37:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801a39:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801a3c:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a3f:	8b 45 08             	mov    0x8(%ebp),%eax
  801a42:	6a 00                	push   $0x0
  801a44:	6a 00                	push   $0x0
  801a46:	51                   	push   %ecx
  801a47:	52                   	push   %edx
  801a48:	50                   	push   %eax
  801a49:	6a 17                	push   $0x17
  801a4b:	e8 a8 fd ff ff       	call   8017f8 <syscall>
  801a50:	83 c4 18             	add    $0x18,%esp
}
  801a53:	c9                   	leave  
  801a54:	c3                   	ret    

00801a55 <sys_delete_shared_object>:

int sys_delete_shared_object(int32 sharedObjectID, void *startVA)
{
  801a55:	55                   	push   %ebp
  801a56:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801a58:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a5b:	8b 45 08             	mov    0x8(%ebp),%eax
  801a5e:	6a 00                	push   $0x0
  801a60:	6a 00                	push   $0x0
  801a62:	6a 00                	push   $0x0
  801a64:	52                   	push   %edx
  801a65:	50                   	push   %eax
  801a66:	6a 18                	push   $0x18
  801a68:	e8 8b fd ff ff       	call   8017f8 <syscall>
  801a6d:	83 c4 18             	add    $0x18,%esp
}
  801a70:	c9                   	leave  
  801a71:	c3                   	ret    

00801a72 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801a72:	55                   	push   %ebp
  801a73:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801a75:	8b 45 08             	mov    0x8(%ebp),%eax
  801a78:	6a 00                	push   $0x0
  801a7a:	ff 75 14             	pushl  0x14(%ebp)
  801a7d:	ff 75 10             	pushl  0x10(%ebp)
  801a80:	ff 75 0c             	pushl  0xc(%ebp)
  801a83:	50                   	push   %eax
  801a84:	6a 19                	push   $0x19
  801a86:	e8 6d fd ff ff       	call   8017f8 <syscall>
  801a8b:	83 c4 18             	add    $0x18,%esp
}
  801a8e:	c9                   	leave  
  801a8f:	c3                   	ret    

00801a90 <sys_run_env>:

void sys_run_env(int32 envId)
{
  801a90:	55                   	push   %ebp
  801a91:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801a93:	8b 45 08             	mov    0x8(%ebp),%eax
  801a96:	6a 00                	push   $0x0
  801a98:	6a 00                	push   $0x0
  801a9a:	6a 00                	push   $0x0
  801a9c:	6a 00                	push   $0x0
  801a9e:	50                   	push   %eax
  801a9f:	6a 1a                	push   $0x1a
  801aa1:	e8 52 fd ff ff       	call   8017f8 <syscall>
  801aa6:	83 c4 18             	add    $0x18,%esp
}
  801aa9:	90                   	nop
  801aaa:	c9                   	leave  
  801aab:	c3                   	ret    

00801aac <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801aac:	55                   	push   %ebp
  801aad:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801aaf:	8b 45 08             	mov    0x8(%ebp),%eax
  801ab2:	6a 00                	push   $0x0
  801ab4:	6a 00                	push   $0x0
  801ab6:	6a 00                	push   $0x0
  801ab8:	6a 00                	push   $0x0
  801aba:	50                   	push   %eax
  801abb:	6a 1b                	push   $0x1b
  801abd:	e8 36 fd ff ff       	call   8017f8 <syscall>
  801ac2:	83 c4 18             	add    $0x18,%esp
}
  801ac5:	c9                   	leave  
  801ac6:	c3                   	ret    

00801ac7 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801ac7:	55                   	push   %ebp
  801ac8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801aca:	6a 00                	push   $0x0
  801acc:	6a 00                	push   $0x0
  801ace:	6a 00                	push   $0x0
  801ad0:	6a 00                	push   $0x0
  801ad2:	6a 00                	push   $0x0
  801ad4:	6a 05                	push   $0x5
  801ad6:	e8 1d fd ff ff       	call   8017f8 <syscall>
  801adb:	83 c4 18             	add    $0x18,%esp
}
  801ade:	c9                   	leave  
  801adf:	c3                   	ret    

00801ae0 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801ae0:	55                   	push   %ebp
  801ae1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801ae3:	6a 00                	push   $0x0
  801ae5:	6a 00                	push   $0x0
  801ae7:	6a 00                	push   $0x0
  801ae9:	6a 00                	push   $0x0
  801aeb:	6a 00                	push   $0x0
  801aed:	6a 06                	push   $0x6
  801aef:	e8 04 fd ff ff       	call   8017f8 <syscall>
  801af4:	83 c4 18             	add    $0x18,%esp
}
  801af7:	c9                   	leave  
  801af8:	c3                   	ret    

00801af9 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801af9:	55                   	push   %ebp
  801afa:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801afc:	6a 00                	push   $0x0
  801afe:	6a 00                	push   $0x0
  801b00:	6a 00                	push   $0x0
  801b02:	6a 00                	push   $0x0
  801b04:	6a 00                	push   $0x0
  801b06:	6a 07                	push   $0x7
  801b08:	e8 eb fc ff ff       	call   8017f8 <syscall>
  801b0d:	83 c4 18             	add    $0x18,%esp
}
  801b10:	c9                   	leave  
  801b11:	c3                   	ret    

00801b12 <sys_exit_env>:


void sys_exit_env(void)
{
  801b12:	55                   	push   %ebp
  801b13:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801b15:	6a 00                	push   $0x0
  801b17:	6a 00                	push   $0x0
  801b19:	6a 00                	push   $0x0
  801b1b:	6a 00                	push   $0x0
  801b1d:	6a 00                	push   $0x0
  801b1f:	6a 1c                	push   $0x1c
  801b21:	e8 d2 fc ff ff       	call   8017f8 <syscall>
  801b26:	83 c4 18             	add    $0x18,%esp
}
  801b29:	90                   	nop
  801b2a:	c9                   	leave  
  801b2b:	c3                   	ret    

00801b2c <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  801b2c:	55                   	push   %ebp
  801b2d:	89 e5                	mov    %esp,%ebp
  801b2f:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801b32:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801b35:	8d 50 04             	lea    0x4(%eax),%edx
  801b38:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801b3b:	6a 00                	push   $0x0
  801b3d:	6a 00                	push   $0x0
  801b3f:	6a 00                	push   $0x0
  801b41:	52                   	push   %edx
  801b42:	50                   	push   %eax
  801b43:	6a 1d                	push   $0x1d
  801b45:	e8 ae fc ff ff       	call   8017f8 <syscall>
  801b4a:	83 c4 18             	add    $0x18,%esp
	return result;
  801b4d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801b50:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801b53:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801b56:	89 01                	mov    %eax,(%ecx)
  801b58:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801b5b:	8b 45 08             	mov    0x8(%ebp),%eax
  801b5e:	c9                   	leave  
  801b5f:	c2 04 00             	ret    $0x4

00801b62 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801b62:	55                   	push   %ebp
  801b63:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801b65:	6a 00                	push   $0x0
  801b67:	6a 00                	push   $0x0
  801b69:	ff 75 10             	pushl  0x10(%ebp)
  801b6c:	ff 75 0c             	pushl  0xc(%ebp)
  801b6f:	ff 75 08             	pushl  0x8(%ebp)
  801b72:	6a 13                	push   $0x13
  801b74:	e8 7f fc ff ff       	call   8017f8 <syscall>
  801b79:	83 c4 18             	add    $0x18,%esp
	return ;
  801b7c:	90                   	nop
}
  801b7d:	c9                   	leave  
  801b7e:	c3                   	ret    

00801b7f <sys_rcr2>:
uint32 sys_rcr2()
{
  801b7f:	55                   	push   %ebp
  801b80:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801b82:	6a 00                	push   $0x0
  801b84:	6a 00                	push   $0x0
  801b86:	6a 00                	push   $0x0
  801b88:	6a 00                	push   $0x0
  801b8a:	6a 00                	push   $0x0
  801b8c:	6a 1e                	push   $0x1e
  801b8e:	e8 65 fc ff ff       	call   8017f8 <syscall>
  801b93:	83 c4 18             	add    $0x18,%esp
}
  801b96:	c9                   	leave  
  801b97:	c3                   	ret    

00801b98 <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  801b98:	55                   	push   %ebp
  801b99:	89 e5                	mov    %esp,%ebp
  801b9b:	83 ec 04             	sub    $0x4,%esp
  801b9e:	8b 45 08             	mov    0x8(%ebp),%eax
  801ba1:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801ba4:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801ba8:	6a 00                	push   $0x0
  801baa:	6a 00                	push   $0x0
  801bac:	6a 00                	push   $0x0
  801bae:	6a 00                	push   $0x0
  801bb0:	50                   	push   %eax
  801bb1:	6a 1f                	push   $0x1f
  801bb3:	e8 40 fc ff ff       	call   8017f8 <syscall>
  801bb8:	83 c4 18             	add    $0x18,%esp
	return ;
  801bbb:	90                   	nop
}
  801bbc:	c9                   	leave  
  801bbd:	c3                   	ret    

00801bbe <rsttst>:
void rsttst()
{
  801bbe:	55                   	push   %ebp
  801bbf:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801bc1:	6a 00                	push   $0x0
  801bc3:	6a 00                	push   $0x0
  801bc5:	6a 00                	push   $0x0
  801bc7:	6a 00                	push   $0x0
  801bc9:	6a 00                	push   $0x0
  801bcb:	6a 21                	push   $0x21
  801bcd:	e8 26 fc ff ff       	call   8017f8 <syscall>
  801bd2:	83 c4 18             	add    $0x18,%esp
	return ;
  801bd5:	90                   	nop
}
  801bd6:	c9                   	leave  
  801bd7:	c3                   	ret    

00801bd8 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801bd8:	55                   	push   %ebp
  801bd9:	89 e5                	mov    %esp,%ebp
  801bdb:	83 ec 04             	sub    $0x4,%esp
  801bde:	8b 45 14             	mov    0x14(%ebp),%eax
  801be1:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801be4:	8b 55 18             	mov    0x18(%ebp),%edx
  801be7:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801beb:	52                   	push   %edx
  801bec:	50                   	push   %eax
  801bed:	ff 75 10             	pushl  0x10(%ebp)
  801bf0:	ff 75 0c             	pushl  0xc(%ebp)
  801bf3:	ff 75 08             	pushl  0x8(%ebp)
  801bf6:	6a 20                	push   $0x20
  801bf8:	e8 fb fb ff ff       	call   8017f8 <syscall>
  801bfd:	83 c4 18             	add    $0x18,%esp
	return ;
  801c00:	90                   	nop
}
  801c01:	c9                   	leave  
  801c02:	c3                   	ret    

00801c03 <chktst>:
void chktst(uint32 n)
{
  801c03:	55                   	push   %ebp
  801c04:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801c06:	6a 00                	push   $0x0
  801c08:	6a 00                	push   $0x0
  801c0a:	6a 00                	push   $0x0
  801c0c:	6a 00                	push   $0x0
  801c0e:	ff 75 08             	pushl  0x8(%ebp)
  801c11:	6a 22                	push   $0x22
  801c13:	e8 e0 fb ff ff       	call   8017f8 <syscall>
  801c18:	83 c4 18             	add    $0x18,%esp
	return ;
  801c1b:	90                   	nop
}
  801c1c:	c9                   	leave  
  801c1d:	c3                   	ret    

00801c1e <inctst>:

void inctst()
{
  801c1e:	55                   	push   %ebp
  801c1f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801c21:	6a 00                	push   $0x0
  801c23:	6a 00                	push   $0x0
  801c25:	6a 00                	push   $0x0
  801c27:	6a 00                	push   $0x0
  801c29:	6a 00                	push   $0x0
  801c2b:	6a 23                	push   $0x23
  801c2d:	e8 c6 fb ff ff       	call   8017f8 <syscall>
  801c32:	83 c4 18             	add    $0x18,%esp
	return ;
  801c35:	90                   	nop
}
  801c36:	c9                   	leave  
  801c37:	c3                   	ret    

00801c38 <gettst>:
uint32 gettst()
{
  801c38:	55                   	push   %ebp
  801c39:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801c3b:	6a 00                	push   $0x0
  801c3d:	6a 00                	push   $0x0
  801c3f:	6a 00                	push   $0x0
  801c41:	6a 00                	push   $0x0
  801c43:	6a 00                	push   $0x0
  801c45:	6a 24                	push   $0x24
  801c47:	e8 ac fb ff ff       	call   8017f8 <syscall>
  801c4c:	83 c4 18             	add    $0x18,%esp
}
  801c4f:	c9                   	leave  
  801c50:	c3                   	ret    

00801c51 <sys_get_uheap_strategy>:

/*2025*/
uint32 sys_get_uheap_strategy()
{
  801c51:	55                   	push   %ebp
  801c52:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801c54:	6a 00                	push   $0x0
  801c56:	6a 00                	push   $0x0
  801c58:	6a 00                	push   $0x0
  801c5a:	6a 00                	push   $0x0
  801c5c:	6a 00                	push   $0x0
  801c5e:	6a 25                	push   $0x25
  801c60:	e8 93 fb ff ff       	call   8017f8 <syscall>
  801c65:	83 c4 18             	add    $0x18,%esp
  801c68:	a3 60 b0 81 00       	mov    %eax,0x81b060
	return uheapPlaceStrategy ;
  801c6d:	a1 60 b0 81 00       	mov    0x81b060,%eax
}
  801c72:	c9                   	leave  
  801c73:	c3                   	ret    

00801c74 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801c74:	55                   	push   %ebp
  801c75:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = heapStrategy;
  801c77:	8b 45 08             	mov    0x8(%ebp),%eax
  801c7a:	a3 60 b0 81 00       	mov    %eax,0x81b060
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801c7f:	6a 00                	push   $0x0
  801c81:	6a 00                	push   $0x0
  801c83:	6a 00                	push   $0x0
  801c85:	6a 00                	push   $0x0
  801c87:	ff 75 08             	pushl  0x8(%ebp)
  801c8a:	6a 26                	push   $0x26
  801c8c:	e8 67 fb ff ff       	call   8017f8 <syscall>
  801c91:	83 c4 18             	add    $0x18,%esp
	return ;
  801c94:	90                   	nop
}
  801c95:	c9                   	leave  
  801c96:	c3                   	ret    

00801c97 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801c97:	55                   	push   %ebp
  801c98:	89 e5                	mov    %esp,%ebp
  801c9a:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801c9b:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801c9e:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801ca1:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ca4:	8b 45 08             	mov    0x8(%ebp),%eax
  801ca7:	6a 00                	push   $0x0
  801ca9:	53                   	push   %ebx
  801caa:	51                   	push   %ecx
  801cab:	52                   	push   %edx
  801cac:	50                   	push   %eax
  801cad:	6a 27                	push   $0x27
  801caf:	e8 44 fb ff ff       	call   8017f8 <syscall>
  801cb4:	83 c4 18             	add    $0x18,%esp
}
  801cb7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801cba:	c9                   	leave  
  801cbb:	c3                   	ret    

00801cbc <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801cbc:	55                   	push   %ebp
  801cbd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801cbf:	8b 55 0c             	mov    0xc(%ebp),%edx
  801cc2:	8b 45 08             	mov    0x8(%ebp),%eax
  801cc5:	6a 00                	push   $0x0
  801cc7:	6a 00                	push   $0x0
  801cc9:	6a 00                	push   $0x0
  801ccb:	52                   	push   %edx
  801ccc:	50                   	push   %eax
  801ccd:	6a 28                	push   $0x28
  801ccf:	e8 24 fb ff ff       	call   8017f8 <syscall>
  801cd4:	83 c4 18             	add    $0x18,%esp
}
  801cd7:	c9                   	leave  
  801cd8:	c3                   	ret    

00801cd9 <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  801cd9:	55                   	push   %ebp
  801cda:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  801cdc:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801cdf:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ce2:	8b 45 08             	mov    0x8(%ebp),%eax
  801ce5:	6a 00                	push   $0x0
  801ce7:	51                   	push   %ecx
  801ce8:	ff 75 10             	pushl  0x10(%ebp)
  801ceb:	52                   	push   %edx
  801cec:	50                   	push   %eax
  801ced:	6a 29                	push   $0x29
  801cef:	e8 04 fb ff ff       	call   8017f8 <syscall>
  801cf4:	83 c4 18             	add    $0x18,%esp
}
  801cf7:	c9                   	leave  
  801cf8:	c3                   	ret    

00801cf9 <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801cf9:	55                   	push   %ebp
  801cfa:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801cfc:	6a 00                	push   $0x0
  801cfe:	6a 00                	push   $0x0
  801d00:	ff 75 10             	pushl  0x10(%ebp)
  801d03:	ff 75 0c             	pushl  0xc(%ebp)
  801d06:	ff 75 08             	pushl  0x8(%ebp)
  801d09:	6a 12                	push   $0x12
  801d0b:	e8 e8 fa ff ff       	call   8017f8 <syscall>
  801d10:	83 c4 18             	add    $0x18,%esp
	return ;
  801d13:	90                   	nop
}
  801d14:	c9                   	leave  
  801d15:	c3                   	ret    

00801d16 <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  801d16:	55                   	push   %ebp
  801d17:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  801d19:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d1c:	8b 45 08             	mov    0x8(%ebp),%eax
  801d1f:	6a 00                	push   $0x0
  801d21:	6a 00                	push   $0x0
  801d23:	6a 00                	push   $0x0
  801d25:	52                   	push   %edx
  801d26:	50                   	push   %eax
  801d27:	6a 2a                	push   $0x2a
  801d29:	e8 ca fa ff ff       	call   8017f8 <syscall>
  801d2e:	83 c4 18             	add    $0x18,%esp
	return;
  801d31:	90                   	nop
}
  801d32:	c9                   	leave  
  801d33:	c3                   	ret    

00801d34 <sys_get_optimal_num_faults>:
/*2025*/
int sys_get_optimal_num_faults()
{
  801d34:	55                   	push   %ebp
  801d35:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_optimal_num_faults, 0, 0, 0, 0, 0);
  801d37:	6a 00                	push   $0x0
  801d39:	6a 00                	push   $0x0
  801d3b:	6a 00                	push   $0x0
  801d3d:	6a 00                	push   $0x0
  801d3f:	6a 00                	push   $0x0
  801d41:	6a 2b                	push   $0x2b
  801d43:	e8 b0 fa ff ff       	call   8017f8 <syscall>
  801d48:	83 c4 18             	add    $0x18,%esp
}
  801d4b:	c9                   	leave  
  801d4c:	c3                   	ret    

00801d4d <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801d4d:	55                   	push   %ebp
  801d4e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801d50:	6a 00                	push   $0x0
  801d52:	6a 00                	push   $0x0
  801d54:	6a 00                	push   $0x0
  801d56:	ff 75 0c             	pushl  0xc(%ebp)
  801d59:	ff 75 08             	pushl  0x8(%ebp)
  801d5c:	6a 2d                	push   $0x2d
  801d5e:	e8 95 fa ff ff       	call   8017f8 <syscall>
  801d63:	83 c4 18             	add    $0x18,%esp
	return;
  801d66:	90                   	nop
}
  801d67:	c9                   	leave  
  801d68:	c3                   	ret    

00801d69 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801d69:	55                   	push   %ebp
  801d6a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801d6c:	6a 00                	push   $0x0
  801d6e:	6a 00                	push   $0x0
  801d70:	6a 00                	push   $0x0
  801d72:	ff 75 0c             	pushl  0xc(%ebp)
  801d75:	ff 75 08             	pushl  0x8(%ebp)
  801d78:	6a 2c                	push   $0x2c
  801d7a:	e8 79 fa ff ff       	call   8017f8 <syscall>
  801d7f:	83 c4 18             	add    $0x18,%esp
	return ;
  801d82:	90                   	nop
}
  801d83:	c9                   	leave  
  801d84:	c3                   	ret    

00801d85 <sys_env_set_priority>:


void sys_env_set_priority(int32 envID, int priority)
{
  801d85:	55                   	push   %ebp
  801d86:	89 e5                	mov    %esp,%ebp
  801d88:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.IM#4] CPU SCHEDULING - #1 System Calls - Add suitable code here
	//Your code is here
	//Comment the following line
	panic("sys_env_set_priority() is not implemented yet...!!");
  801d8b:	83 ec 04             	sub    $0x4,%esp
  801d8e:	68 dc 29 80 00       	push   $0x8029dc
  801d93:	68 25 01 00 00       	push   $0x125
  801d98:	68 0f 2a 80 00       	push   $0x802a0f
  801d9d:	e8 9b e6 ff ff       	call   80043d <_panic>

00801da2 <env_sleep>:
#include <inc/lib.h>
#include <inc/timerreg.h>

void
env_sleep(uint32 approxMilliSeconds)
{
  801da2:	55                   	push   %ebp
  801da3:	89 e5                	mov    %esp,%ebp
  801da5:	83 ec 30             	sub    $0x30,%esp
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
  801da8:	8b 55 08             	mov    0x8(%ebp),%edx
  801dab:	89 d0                	mov    %edx,%eax
  801dad:	c1 e0 02             	shl    $0x2,%eax
  801db0:	01 d0                	add    %edx,%eax
  801db2:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801db9:	01 d0                	add    %edx,%eax
  801dbb:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801dc2:	01 d0                	add    %edx,%eax
  801dc4:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801dcb:	01 d0                	add    %edx,%eax
  801dcd:	c1 e0 04             	shl    $0x4,%eax
  801dd0:	89 45 f8             	mov    %eax,-0x8(%ebp)
	uint32 cycles_counter =0;
  801dd3:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)

static inline __attribute__((always_inline)) struct uint64 get_virtual_time_user()
{
	struct uint64 result;

	__asm __volatile("rdtsc\n"
  801dda:	0f 31                	rdtsc  
  801ddc:	89 45 e8             	mov    %eax,-0x18(%ebp)
  801ddf:	89 55 ec             	mov    %edx,-0x14(%ebp)
	: "=a" (result.low), "=d" (result.hi)
	);

	return result;
  801de2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801de5:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801de8:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801deb:	89 55 f4             	mov    %edx,-0xc(%ebp)

	/*2024*/ //USE A USER-SIDE VERSION OF THIS FUNCTION TO AVOID SLOW-DOWN THE PERFORMANCE DUE SYS_CALL (el7 :))
	//struct uint64 baseTime = sys_get_virtual_time() ;
	struct uint64 baseTime = get_virtual_time_user() ;
	while(cycles_counter<time_in_cycles)
  801dee:	eb 46                	jmp    801e36 <env_sleep+0x94>

static inline __attribute__((always_inline)) struct uint64 get_virtual_time_user()
{
	struct uint64 result;

	__asm __volatile("rdtsc\n"
  801df0:	0f 31                	rdtsc  
  801df2:	89 45 d0             	mov    %eax,-0x30(%ebp)
  801df5:	89 55 d4             	mov    %edx,-0x2c(%ebp)
	: "=a" (result.low), "=d" (result.hi)
	);

	return result;
  801df8:	8b 45 d0             	mov    -0x30(%ebp),%eax
  801dfb:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  801dfe:	89 45 e0             	mov    %eax,-0x20(%ebp)
  801e01:	89 55 e4             	mov    %edx,-0x1c(%ebp)

		// update the cycles_count
		#define M32 0xffffffff
		// subtract basetime from current time
		struct uint64 res;
		res.low = (currentTime.low - baseTime.low) & M32;
  801e04:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801e07:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e0a:	29 c2                	sub    %eax,%edx
  801e0c:	89 d0                	mov    %edx,%eax
  801e0e:	89 45 d8             	mov    %eax,-0x28(%ebp)
		res.hi = (currentTime.hi - baseTime.hi - (res.low > currentTime.low)) & M32;
  801e11:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801e14:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e17:	89 d1                	mov    %edx,%ecx
  801e19:	29 c1                	sub    %eax,%ecx
  801e1b:	8b 55 d8             	mov    -0x28(%ebp),%edx
  801e1e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801e21:	39 c2                	cmp    %eax,%edx
  801e23:	0f 97 c0             	seta   %al
  801e26:	0f b6 c0             	movzbl %al,%eax
  801e29:	29 c1                	sub    %eax,%ecx
  801e2b:	89 c8                	mov    %ecx,%eax
  801e2d:	89 45 dc             	mov    %eax,-0x24(%ebp)

		//update cycles_count with result
		cycles_counter = res.low;
  801e30:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801e33:	89 45 fc             	mov    %eax,-0x4(%ebp)
	uint32 cycles_counter =0;

	/*2024*/ //USE A USER-SIDE VERSION OF THIS FUNCTION TO AVOID SLOW-DOWN THE PERFORMANCE DUE SYS_CALL (el7 :))
	//struct uint64 baseTime = sys_get_virtual_time() ;
	struct uint64 baseTime = get_virtual_time_user() ;
	while(cycles_counter<time_in_cycles)
  801e36:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801e39:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801e3c:	72 b2                	jb     801df0 <env_sleep+0x4e>
//				,cycles_counter
//				);
	}
	//cprintf("%s [%d] wake up now!\n", myEnv->prog_name, myEnv->env_id);

}
  801e3e:	90                   	nop
  801e3f:	c9                   	leave  
  801e40:	c3                   	ret    

00801e41 <busy_wait>:

//2017
uint32 busy_wait(uint32 loopMax)
{
  801e41:	55                   	push   %ebp
  801e42:	89 e5                	mov    %esp,%ebp
  801e44:	83 ec 10             	sub    $0x10,%esp
	uint32 i = 0 ;
  801e47:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	while (i < loopMax) i++;
  801e4e:	eb 03                	jmp    801e53 <busy_wait+0x12>
  801e50:	ff 45 fc             	incl   -0x4(%ebp)
  801e53:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801e56:	3b 45 08             	cmp    0x8(%ebp),%eax
  801e59:	72 f5                	jb     801e50 <busy_wait+0xf>
	return i;
  801e5b:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801e5e:	c9                   	leave  
  801e5f:	c3                   	ret    

00801e60 <cputchar>:
#include <inc/lib.h>


void
cputchar(int ch)
{
  801e60:	55                   	push   %ebp
  801e61:	89 e5                	mov    %esp,%ebp
  801e63:	83 ec 18             	sub    $0x18,%esp
	char c = ch;
  801e66:	8b 45 08             	mov    0x8(%ebp),%eax
  801e69:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	//sys_cputs(&c, 1);

	sys_cputc(c);
  801e6c:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  801e70:	83 ec 0c             	sub    $0xc,%esp
  801e73:	50                   	push   %eax
  801e74:	e8 36 fb ff ff       	call   8019af <sys_cputc>
  801e79:	83 c4 10             	add    $0x10,%esp
}
  801e7c:	90                   	nop
  801e7d:	c9                   	leave  
  801e7e:	c3                   	ret    

00801e7f <getchar>:


int
getchar(void)
{
  801e7f:	55                   	push   %ebp
  801e80:	89 e5                	mov    %esp,%ebp
  801e82:	83 ec 18             	sub    $0x18,%esp
	int c =sys_cgetc();
  801e85:	e8 c4 f9 ff ff       	call   80184e <sys_cgetc>
  801e8a:	89 45 f4             	mov    %eax,-0xc(%ebp)
	return c;
  801e8d:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  801e90:	c9                   	leave  
  801e91:	c3                   	ret    

00801e92 <iscons>:

int iscons(int fdnum)
{
  801e92:	55                   	push   %ebp
  801e93:	89 e5                	mov    %esp,%ebp
	// used by readline
	return 1;
  801e95:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801e9a:	5d                   	pop    %ebp
  801e9b:	c3                   	ret    

00801e9c <__udivdi3>:
  801e9c:	55                   	push   %ebp
  801e9d:	57                   	push   %edi
  801e9e:	56                   	push   %esi
  801e9f:	53                   	push   %ebx
  801ea0:	83 ec 1c             	sub    $0x1c,%esp
  801ea3:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  801ea7:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  801eab:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801eaf:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801eb3:	89 ca                	mov    %ecx,%edx
  801eb5:	89 f8                	mov    %edi,%eax
  801eb7:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  801ebb:	85 f6                	test   %esi,%esi
  801ebd:	75 2d                	jne    801eec <__udivdi3+0x50>
  801ebf:	39 cf                	cmp    %ecx,%edi
  801ec1:	77 65                	ja     801f28 <__udivdi3+0x8c>
  801ec3:	89 fd                	mov    %edi,%ebp
  801ec5:	85 ff                	test   %edi,%edi
  801ec7:	75 0b                	jne    801ed4 <__udivdi3+0x38>
  801ec9:	b8 01 00 00 00       	mov    $0x1,%eax
  801ece:	31 d2                	xor    %edx,%edx
  801ed0:	f7 f7                	div    %edi
  801ed2:	89 c5                	mov    %eax,%ebp
  801ed4:	31 d2                	xor    %edx,%edx
  801ed6:	89 c8                	mov    %ecx,%eax
  801ed8:	f7 f5                	div    %ebp
  801eda:	89 c1                	mov    %eax,%ecx
  801edc:	89 d8                	mov    %ebx,%eax
  801ede:	f7 f5                	div    %ebp
  801ee0:	89 cf                	mov    %ecx,%edi
  801ee2:	89 fa                	mov    %edi,%edx
  801ee4:	83 c4 1c             	add    $0x1c,%esp
  801ee7:	5b                   	pop    %ebx
  801ee8:	5e                   	pop    %esi
  801ee9:	5f                   	pop    %edi
  801eea:	5d                   	pop    %ebp
  801eeb:	c3                   	ret    
  801eec:	39 ce                	cmp    %ecx,%esi
  801eee:	77 28                	ja     801f18 <__udivdi3+0x7c>
  801ef0:	0f bd fe             	bsr    %esi,%edi
  801ef3:	83 f7 1f             	xor    $0x1f,%edi
  801ef6:	75 40                	jne    801f38 <__udivdi3+0x9c>
  801ef8:	39 ce                	cmp    %ecx,%esi
  801efa:	72 0a                	jb     801f06 <__udivdi3+0x6a>
  801efc:	3b 44 24 08          	cmp    0x8(%esp),%eax
  801f00:	0f 87 9e 00 00 00    	ja     801fa4 <__udivdi3+0x108>
  801f06:	b8 01 00 00 00       	mov    $0x1,%eax
  801f0b:	89 fa                	mov    %edi,%edx
  801f0d:	83 c4 1c             	add    $0x1c,%esp
  801f10:	5b                   	pop    %ebx
  801f11:	5e                   	pop    %esi
  801f12:	5f                   	pop    %edi
  801f13:	5d                   	pop    %ebp
  801f14:	c3                   	ret    
  801f15:	8d 76 00             	lea    0x0(%esi),%esi
  801f18:	31 ff                	xor    %edi,%edi
  801f1a:	31 c0                	xor    %eax,%eax
  801f1c:	89 fa                	mov    %edi,%edx
  801f1e:	83 c4 1c             	add    $0x1c,%esp
  801f21:	5b                   	pop    %ebx
  801f22:	5e                   	pop    %esi
  801f23:	5f                   	pop    %edi
  801f24:	5d                   	pop    %ebp
  801f25:	c3                   	ret    
  801f26:	66 90                	xchg   %ax,%ax
  801f28:	89 d8                	mov    %ebx,%eax
  801f2a:	f7 f7                	div    %edi
  801f2c:	31 ff                	xor    %edi,%edi
  801f2e:	89 fa                	mov    %edi,%edx
  801f30:	83 c4 1c             	add    $0x1c,%esp
  801f33:	5b                   	pop    %ebx
  801f34:	5e                   	pop    %esi
  801f35:	5f                   	pop    %edi
  801f36:	5d                   	pop    %ebp
  801f37:	c3                   	ret    
  801f38:	bd 20 00 00 00       	mov    $0x20,%ebp
  801f3d:	89 eb                	mov    %ebp,%ebx
  801f3f:	29 fb                	sub    %edi,%ebx
  801f41:	89 f9                	mov    %edi,%ecx
  801f43:	d3 e6                	shl    %cl,%esi
  801f45:	89 c5                	mov    %eax,%ebp
  801f47:	88 d9                	mov    %bl,%cl
  801f49:	d3 ed                	shr    %cl,%ebp
  801f4b:	89 e9                	mov    %ebp,%ecx
  801f4d:	09 f1                	or     %esi,%ecx
  801f4f:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  801f53:	89 f9                	mov    %edi,%ecx
  801f55:	d3 e0                	shl    %cl,%eax
  801f57:	89 c5                	mov    %eax,%ebp
  801f59:	89 d6                	mov    %edx,%esi
  801f5b:	88 d9                	mov    %bl,%cl
  801f5d:	d3 ee                	shr    %cl,%esi
  801f5f:	89 f9                	mov    %edi,%ecx
  801f61:	d3 e2                	shl    %cl,%edx
  801f63:	8b 44 24 08          	mov    0x8(%esp),%eax
  801f67:	88 d9                	mov    %bl,%cl
  801f69:	d3 e8                	shr    %cl,%eax
  801f6b:	09 c2                	or     %eax,%edx
  801f6d:	89 d0                	mov    %edx,%eax
  801f6f:	89 f2                	mov    %esi,%edx
  801f71:	f7 74 24 0c          	divl   0xc(%esp)
  801f75:	89 d6                	mov    %edx,%esi
  801f77:	89 c3                	mov    %eax,%ebx
  801f79:	f7 e5                	mul    %ebp
  801f7b:	39 d6                	cmp    %edx,%esi
  801f7d:	72 19                	jb     801f98 <__udivdi3+0xfc>
  801f7f:	74 0b                	je     801f8c <__udivdi3+0xf0>
  801f81:	89 d8                	mov    %ebx,%eax
  801f83:	31 ff                	xor    %edi,%edi
  801f85:	e9 58 ff ff ff       	jmp    801ee2 <__udivdi3+0x46>
  801f8a:	66 90                	xchg   %ax,%ax
  801f8c:	8b 54 24 08          	mov    0x8(%esp),%edx
  801f90:	89 f9                	mov    %edi,%ecx
  801f92:	d3 e2                	shl    %cl,%edx
  801f94:	39 c2                	cmp    %eax,%edx
  801f96:	73 e9                	jae    801f81 <__udivdi3+0xe5>
  801f98:	8d 43 ff             	lea    -0x1(%ebx),%eax
  801f9b:	31 ff                	xor    %edi,%edi
  801f9d:	e9 40 ff ff ff       	jmp    801ee2 <__udivdi3+0x46>
  801fa2:	66 90                	xchg   %ax,%ax
  801fa4:	31 c0                	xor    %eax,%eax
  801fa6:	e9 37 ff ff ff       	jmp    801ee2 <__udivdi3+0x46>
  801fab:	90                   	nop

00801fac <__umoddi3>:
  801fac:	55                   	push   %ebp
  801fad:	57                   	push   %edi
  801fae:	56                   	push   %esi
  801faf:	53                   	push   %ebx
  801fb0:	83 ec 1c             	sub    $0x1c,%esp
  801fb3:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  801fb7:	8b 74 24 34          	mov    0x34(%esp),%esi
  801fbb:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801fbf:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  801fc3:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801fc7:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801fcb:	89 f3                	mov    %esi,%ebx
  801fcd:	89 fa                	mov    %edi,%edx
  801fcf:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801fd3:	89 34 24             	mov    %esi,(%esp)
  801fd6:	85 c0                	test   %eax,%eax
  801fd8:	75 1a                	jne    801ff4 <__umoddi3+0x48>
  801fda:	39 f7                	cmp    %esi,%edi
  801fdc:	0f 86 a2 00 00 00    	jbe    802084 <__umoddi3+0xd8>
  801fe2:	89 c8                	mov    %ecx,%eax
  801fe4:	89 f2                	mov    %esi,%edx
  801fe6:	f7 f7                	div    %edi
  801fe8:	89 d0                	mov    %edx,%eax
  801fea:	31 d2                	xor    %edx,%edx
  801fec:	83 c4 1c             	add    $0x1c,%esp
  801fef:	5b                   	pop    %ebx
  801ff0:	5e                   	pop    %esi
  801ff1:	5f                   	pop    %edi
  801ff2:	5d                   	pop    %ebp
  801ff3:	c3                   	ret    
  801ff4:	39 f0                	cmp    %esi,%eax
  801ff6:	0f 87 ac 00 00 00    	ja     8020a8 <__umoddi3+0xfc>
  801ffc:	0f bd e8             	bsr    %eax,%ebp
  801fff:	83 f5 1f             	xor    $0x1f,%ebp
  802002:	0f 84 ac 00 00 00    	je     8020b4 <__umoddi3+0x108>
  802008:	bf 20 00 00 00       	mov    $0x20,%edi
  80200d:	29 ef                	sub    %ebp,%edi
  80200f:	89 fe                	mov    %edi,%esi
  802011:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802015:	89 e9                	mov    %ebp,%ecx
  802017:	d3 e0                	shl    %cl,%eax
  802019:	89 d7                	mov    %edx,%edi
  80201b:	89 f1                	mov    %esi,%ecx
  80201d:	d3 ef                	shr    %cl,%edi
  80201f:	09 c7                	or     %eax,%edi
  802021:	89 e9                	mov    %ebp,%ecx
  802023:	d3 e2                	shl    %cl,%edx
  802025:	89 14 24             	mov    %edx,(%esp)
  802028:	89 d8                	mov    %ebx,%eax
  80202a:	d3 e0                	shl    %cl,%eax
  80202c:	89 c2                	mov    %eax,%edx
  80202e:	8b 44 24 08          	mov    0x8(%esp),%eax
  802032:	d3 e0                	shl    %cl,%eax
  802034:	89 44 24 04          	mov    %eax,0x4(%esp)
  802038:	8b 44 24 08          	mov    0x8(%esp),%eax
  80203c:	89 f1                	mov    %esi,%ecx
  80203e:	d3 e8                	shr    %cl,%eax
  802040:	09 d0                	or     %edx,%eax
  802042:	d3 eb                	shr    %cl,%ebx
  802044:	89 da                	mov    %ebx,%edx
  802046:	f7 f7                	div    %edi
  802048:	89 d3                	mov    %edx,%ebx
  80204a:	f7 24 24             	mull   (%esp)
  80204d:	89 c6                	mov    %eax,%esi
  80204f:	89 d1                	mov    %edx,%ecx
  802051:	39 d3                	cmp    %edx,%ebx
  802053:	0f 82 87 00 00 00    	jb     8020e0 <__umoddi3+0x134>
  802059:	0f 84 91 00 00 00    	je     8020f0 <__umoddi3+0x144>
  80205f:	8b 54 24 04          	mov    0x4(%esp),%edx
  802063:	29 f2                	sub    %esi,%edx
  802065:	19 cb                	sbb    %ecx,%ebx
  802067:	89 d8                	mov    %ebx,%eax
  802069:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  80206d:	d3 e0                	shl    %cl,%eax
  80206f:	89 e9                	mov    %ebp,%ecx
  802071:	d3 ea                	shr    %cl,%edx
  802073:	09 d0                	or     %edx,%eax
  802075:	89 e9                	mov    %ebp,%ecx
  802077:	d3 eb                	shr    %cl,%ebx
  802079:	89 da                	mov    %ebx,%edx
  80207b:	83 c4 1c             	add    $0x1c,%esp
  80207e:	5b                   	pop    %ebx
  80207f:	5e                   	pop    %esi
  802080:	5f                   	pop    %edi
  802081:	5d                   	pop    %ebp
  802082:	c3                   	ret    
  802083:	90                   	nop
  802084:	89 fd                	mov    %edi,%ebp
  802086:	85 ff                	test   %edi,%edi
  802088:	75 0b                	jne    802095 <__umoddi3+0xe9>
  80208a:	b8 01 00 00 00       	mov    $0x1,%eax
  80208f:	31 d2                	xor    %edx,%edx
  802091:	f7 f7                	div    %edi
  802093:	89 c5                	mov    %eax,%ebp
  802095:	89 f0                	mov    %esi,%eax
  802097:	31 d2                	xor    %edx,%edx
  802099:	f7 f5                	div    %ebp
  80209b:	89 c8                	mov    %ecx,%eax
  80209d:	f7 f5                	div    %ebp
  80209f:	89 d0                	mov    %edx,%eax
  8020a1:	e9 44 ff ff ff       	jmp    801fea <__umoddi3+0x3e>
  8020a6:	66 90                	xchg   %ax,%ax
  8020a8:	89 c8                	mov    %ecx,%eax
  8020aa:	89 f2                	mov    %esi,%edx
  8020ac:	83 c4 1c             	add    $0x1c,%esp
  8020af:	5b                   	pop    %ebx
  8020b0:	5e                   	pop    %esi
  8020b1:	5f                   	pop    %edi
  8020b2:	5d                   	pop    %ebp
  8020b3:	c3                   	ret    
  8020b4:	3b 04 24             	cmp    (%esp),%eax
  8020b7:	72 06                	jb     8020bf <__umoddi3+0x113>
  8020b9:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  8020bd:	77 0f                	ja     8020ce <__umoddi3+0x122>
  8020bf:	89 f2                	mov    %esi,%edx
  8020c1:	29 f9                	sub    %edi,%ecx
  8020c3:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  8020c7:	89 14 24             	mov    %edx,(%esp)
  8020ca:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8020ce:	8b 44 24 04          	mov    0x4(%esp),%eax
  8020d2:	8b 14 24             	mov    (%esp),%edx
  8020d5:	83 c4 1c             	add    $0x1c,%esp
  8020d8:	5b                   	pop    %ebx
  8020d9:	5e                   	pop    %esi
  8020da:	5f                   	pop    %edi
  8020db:	5d                   	pop    %ebp
  8020dc:	c3                   	ret    
  8020dd:	8d 76 00             	lea    0x0(%esi),%esi
  8020e0:	2b 04 24             	sub    (%esp),%eax
  8020e3:	19 fa                	sbb    %edi,%edx
  8020e5:	89 d1                	mov    %edx,%ecx
  8020e7:	89 c6                	mov    %eax,%esi
  8020e9:	e9 71 ff ff ff       	jmp    80205f <__umoddi3+0xb3>
  8020ee:	66 90                	xchg   %ax,%ax
  8020f0:	39 44 24 04          	cmp    %eax,0x4(%esp)
  8020f4:	72 ea                	jb     8020e0 <__umoddi3+0x134>
  8020f6:	89 d9                	mov    %ebx,%ecx
  8020f8:	e9 62 ff ff ff       	jmp    80205f <__umoddi3+0xb3>
