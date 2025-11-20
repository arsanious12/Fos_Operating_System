
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
  800047:	68 20 21 80 00       	push   $0x802120
  80004c:	6a 0e                	push   $0xe
  80004e:	e8 fa 06 00 00       	call   80074d <cprintf_colored>
  800053:	83 c4 10             	add    $0x10,%esp
	cprintf_colored(TEXT_yellow,"MAKE SURE to have a FRESH RUN for this test\n(i.e. don't run any program/test before it)\n");
  800056:	83 ec 08             	sub    $0x8,%esp
  800059:	68 50 21 80 00       	push   $0x802150
  80005e:	6a 0e                	push   $0xe
  800060:	e8 e8 06 00 00       	call   80074d <cprintf_colored>
  800065:	83 c4 10             	add    $0x10,%esp
	cprintf_colored(TEXT_yellow,"==============================================\n");
  800068:	83 ec 08             	sub    $0x8,%esp
  80006b:	68 20 21 80 00       	push   $0x802120
  800070:	6a 0e                	push   $0xe
  800072:	e8 d6 06 00 00       	call   80074d <cprintf_colored>
  800077:	83 c4 10             	add    $0x10,%esp


	int envID = sys_getenvid();
  80007a:	e8 5d 1a 00 00       	call   801adc <sys_getenvid>
  80007f:	89 45 d8             	mov    %eax,-0x28(%ebp)
	char slavesCnt[10];
	readline("Enter the number of Slave Programs: ", slavesCnt);
  800082:	83 ec 08             	sub    $0x8,%esp
  800085:	8d 45 ca             	lea    -0x36(%ebp),%eax
  800088:	50                   	push   %eax
  800089:	68 ac 21 80 00       	push   $0x8021ac
  80008e:	e8 66 0d 00 00       	call   800df9 <readline>
  800093:	83 c4 10             	add    $0x10,%esp
	int numOfSlaves = strtol(slavesCnt, NULL, 10);
  800096:	83 ec 04             	sub    $0x4,%esp
  800099:	6a 0a                	push   $0xa
  80009b:	6a 00                	push   $0x0
  80009d:	8d 45 ca             	lea    -0x36(%ebp),%eax
  8000a0:	50                   	push   %eax
  8000a1:	e8 6a 13 00 00       	call   801410 <strtol>
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
  8000ba:	8b 90 3c da 01 00    	mov    0x1da3c(%eax),%edx
  8000c0:	a1 20 30 80 00       	mov    0x803020,%eax
  8000c5:	8b 80 34 da 01 00    	mov    0x1da34(%eax),%eax
  8000cb:	89 c1                	mov    %eax,%ecx
  8000cd:	a1 20 30 80 00       	mov    0x803020,%eax
  8000d2:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
  8000d8:	52                   	push   %edx
  8000d9:	51                   	push   %ecx
  8000da:	50                   	push   %eax
  8000db:	68 d1 21 80 00       	push   $0x8021d1
  8000e0:	e8 a2 19 00 00       	call   801a87 <sys_create_env>
  8000e5:	83 c4 10             	add    $0x10,%esp
  8000e8:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		if (id== E_ENV_CREATION_ERROR)
  8000eb:	83 7d d4 ef          	cmpl   $0xffffffef,-0x2c(%ebp)
  8000ef:	75 1d                	jne    80010e <_main+0xd6>
		{
			cprintf_colored(TEXT_TESTERR_CLR, "\n%~insufficient number of processes in the system! only %d slave processes are created\n", i);
  8000f1:	83 ec 04             	sub    $0x4,%esp
  8000f4:	ff 75 e0             	pushl  -0x20(%ebp)
  8000f7:	68 e4 21 80 00       	push   $0x8021e4
  8000fc:	6a 0c                	push   $0xc
  8000fe:	e8 4a 06 00 00       	call   80074d <cprintf_colored>
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
  800114:	e8 8c 19 00 00       	call   801aa5 <sys_run_env>
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
  800131:	bb 36 23 80 00       	mov    $0x802336,%ebx
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
  80015c:	e8 ca 1b 00 00       	call   801d2b <sys_utilities>
  800161:	83 c4 10             	add    $0x10,%esp
	int cnt = 0;
  800164:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	while (numOfBlockedProcesses != numOfSlaves)
  80016b:	eb 75                	jmp    8001e2 <_main+0x1aa>
	{
		env_sleep(5000);
  80016d:	83 ec 0c             	sub    $0xc,%esp
  800170:	68 88 13 00 00       	push   $0x1388
  800175:	e8 3d 1c 00 00       	call   801db7 <env_sleep>
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
  80018f:	68 3c 22 80 00       	push   $0x80223c
  800194:	6a 2a                	push   $0x2a
  800196:	68 95 22 80 00       	push   $0x802295
  80019b:	e8 b2 02 00 00       	call   800452 <_panic>
		}
		char cmd2[64] = "__GetChanQueueSize__";
  8001a0:	8d 85 04 ff ff ff    	lea    -0xfc(%ebp),%eax
  8001a6:	bb 36 23 80 00       	mov    $0x802336,%ebx
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
  8001d7:	e8 4f 1b 00 00       	call   801d2b <sys_utilities>
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
  8001ea:	e8 e4 19 00 00       	call   801bd3 <rsttst>

	//Wakeup all
	char cmd3[64] = "__WakeupAll__";
  8001ef:	8d 85 44 ff ff ff    	lea    -0xbc(%ebp),%eax
  8001f5:	bb 76 23 80 00       	mov    $0x802376,%ebx
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
  800224:	e8 02 1b 00 00       	call   801d2b <sys_utilities>
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
  80023d:	e8 75 1b 00 00       	call   801db7 <env_sleep>
  800242:	83 c4 10             	add    $0x10,%esp
		if (cnt == numOfSlaves)
  800245:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800248:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  80024b:	75 14                	jne    800261 <_main+0x229>
		{
			panic("%~test channels failed! not all slaves finished");
  80024d:	83 ec 04             	sub    $0x4,%esp
  800250:	68 b0 22 80 00       	push   $0x8022b0
  800255:	6a 3e                	push   $0x3e
  800257:	68 95 22 80 00       	push   $0x802295
  80025c:	e8 f1 01 00 00       	call   800452 <_panic>
		}
		cnt++ ;
  800261:	ff 45 dc             	incl   -0x24(%ebp)
	char cmd3[64] = "__WakeupAll__";
	sys_utilities(cmd3, 0);

	//Wait until all slave finished
	cnt = 0;
	while (gettst() != numOfSlaves)
  800264:	e8 e4 19 00 00       	call   801c4d <gettst>
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
  800275:	68 e0 22 80 00       	push   $0x8022e0
  80027a:	6a 0a                	push   $0xa
  80027c:	e8 cc 04 00 00       	call   80074d <cprintf_colored>
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
  800296:	e8 5a 18 00 00       	call   801af5 <sys_getenvindex>
  80029b:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	myEnv = &(envs[envIndex]);
  80029e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8002a1:	89 d0                	mov    %edx,%eax
  8002a3:	c1 e0 06             	shl    $0x6,%eax
  8002a6:	29 d0                	sub    %edx,%eax
  8002a8:	c1 e0 02             	shl    $0x2,%eax
  8002ab:	01 d0                	add    %edx,%eax
  8002ad:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8002b4:	01 c8                	add    %ecx,%eax
  8002b6:	c1 e0 03             	shl    $0x3,%eax
  8002b9:	01 d0                	add    %edx,%eax
  8002bb:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8002c2:	29 c2                	sub    %eax,%edx
  8002c4:	8d 04 95 00 00 00 00 	lea    0x0(,%edx,4),%eax
  8002cb:	89 c2                	mov    %eax,%edx
  8002cd:	8d 82 00 00 c0 ee    	lea    -0x11400000(%edx),%eax
  8002d3:	a3 20 30 80 00       	mov    %eax,0x803020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  8002d8:	a1 20 30 80 00       	mov    0x803020,%eax
  8002dd:	8a 40 20             	mov    0x20(%eax),%al
  8002e0:	84 c0                	test   %al,%al
  8002e2:	74 0d                	je     8002f1 <libmain+0x64>
		binaryname = myEnv->prog_name;
  8002e4:	a1 20 30 80 00       	mov    0x803020,%eax
  8002e9:	83 c0 20             	add    $0x20,%eax
  8002ec:	a3 04 30 80 00       	mov    %eax,0x803004

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8002f1:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8002f5:	7e 0a                	jle    800301 <libmain+0x74>
		binaryname = argv[0];
  8002f7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8002fa:	8b 00                	mov    (%eax),%eax
  8002fc:	a3 04 30 80 00       	mov    %eax,0x803004

	// call user main routine
	_main(argc, argv);
  800301:	83 ec 08             	sub    $0x8,%esp
  800304:	ff 75 0c             	pushl  0xc(%ebp)
  800307:	ff 75 08             	pushl  0x8(%ebp)
  80030a:	e8 29 fd ff ff       	call   800038 <_main>
  80030f:	83 c4 10             	add    $0x10,%esp

	if (printStats)
  800312:	a1 00 30 80 00       	mov    0x803000,%eax
  800317:	85 c0                	test   %eax,%eax
  800319:	0f 84 01 01 00 00    	je     800420 <libmain+0x193>
	{
		char isOPTReplCmd[100] = "__IsOPTRepl__" ;
  80031f:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  800325:	bb b0 24 80 00       	mov    $0x8024b0,%ebx
  80032a:	ba 0e 00 00 00       	mov    $0xe,%edx
  80032f:	89 c7                	mov    %eax,%edi
  800331:	89 de                	mov    %ebx,%esi
  800333:	89 d1                	mov    %edx,%ecx
  800335:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  800337:	8d 55 8a             	lea    -0x76(%ebp),%edx
  80033a:	b9 56 00 00 00       	mov    $0x56,%ecx
  80033f:	b0 00                	mov    $0x0,%al
  800341:	89 d7                	mov    %edx,%edi
  800343:	f3 aa                	rep stos %al,%es:(%edi)
		int isOPTRepl = 0;
  800345:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
		sys_utilities(isOPTReplCmd, (uint32)(&isOPTRepl));
  80034c:	8d 45 e0             	lea    -0x20(%ebp),%eax
  80034f:	83 ec 08             	sub    $0x8,%esp
  800352:	50                   	push   %eax
  800353:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  800359:	50                   	push   %eax
  80035a:	e8 cc 19 00 00       	call   801d2b <sys_utilities>
  80035f:	83 c4 10             	add    $0x10,%esp

		sys_lock_cons();
  800362:	e8 15 15 00 00       	call   80187c <sys_lock_cons>
		{
			cprintf("**************************************\n");
  800367:	83 ec 0c             	sub    $0xc,%esp
  80036a:	68 d0 23 80 00       	push   $0x8023d0
  80036f:	e8 ac 03 00 00       	call   800720 <cprintf>
  800374:	83 c4 10             	add    $0x10,%esp
			if (isOPTRepl)
  800377:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80037a:	85 c0                	test   %eax,%eax
  80037c:	74 18                	je     800396 <libmain+0x109>
			{
				cprintf("OPTIMAL number of page faults = %d\n", sys_get_optimal_num_faults());
  80037e:	e8 c6 19 00 00       	call   801d49 <sys_get_optimal_num_faults>
  800383:	83 ec 08             	sub    $0x8,%esp
  800386:	50                   	push   %eax
  800387:	68 f8 23 80 00       	push   $0x8023f8
  80038c:	e8 8f 03 00 00       	call   800720 <cprintf>
  800391:	83 c4 10             	add    $0x10,%esp
  800394:	eb 59                	jmp    8003ef <libmain+0x162>
			}
			else
			{
				cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  800396:	a1 20 30 80 00       	mov    0x803020,%eax
  80039b:	8b 90 50 da 01 00    	mov    0x1da50(%eax),%edx
  8003a1:	a1 20 30 80 00       	mov    0x803020,%eax
  8003a6:	8b 80 40 da 01 00    	mov    0x1da40(%eax),%eax
  8003ac:	83 ec 04             	sub    $0x4,%esp
  8003af:	52                   	push   %edx
  8003b0:	50                   	push   %eax
  8003b1:	68 1c 24 80 00       	push   $0x80241c
  8003b6:	e8 65 03 00 00       	call   800720 <cprintf>
  8003bb:	83 c4 10             	add    $0x10,%esp
				cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  8003be:	a1 20 30 80 00       	mov    0x803020,%eax
  8003c3:	8b 88 64 da 01 00    	mov    0x1da64(%eax),%ecx
  8003c9:	a1 20 30 80 00       	mov    0x803020,%eax
  8003ce:	8b 90 60 da 01 00    	mov    0x1da60(%eax),%edx
  8003d4:	a1 20 30 80 00       	mov    0x803020,%eax
  8003d9:	8b 80 5c da 01 00    	mov    0x1da5c(%eax),%eax
  8003df:	51                   	push   %ecx
  8003e0:	52                   	push   %edx
  8003e1:	50                   	push   %eax
  8003e2:	68 44 24 80 00       	push   $0x802444
  8003e7:	e8 34 03 00 00       	call   800720 <cprintf>
  8003ec:	83 c4 10             	add    $0x10,%esp
			}
			//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
			cprintf("Num of clocks = %d\n", myEnv->nClocks);
  8003ef:	a1 20 30 80 00       	mov    0x803020,%eax
  8003f4:	8b 80 68 da 01 00    	mov    0x1da68(%eax),%eax
  8003fa:	83 ec 08             	sub    $0x8,%esp
  8003fd:	50                   	push   %eax
  8003fe:	68 9c 24 80 00       	push   $0x80249c
  800403:	e8 18 03 00 00       	call   800720 <cprintf>
  800408:	83 c4 10             	add    $0x10,%esp
			cprintf("**************************************\n");
  80040b:	83 ec 0c             	sub    $0xc,%esp
  80040e:	68 d0 23 80 00       	push   $0x8023d0
  800413:	e8 08 03 00 00       	call   800720 <cprintf>
  800418:	83 c4 10             	add    $0x10,%esp
		}
		sys_unlock_cons();
  80041b:	e8 76 14 00 00       	call   801896 <sys_unlock_cons>
	}

	// exit gracefully
	exit();
  800420:	e8 1f 00 00 00       	call   800444 <exit>
}
  800425:	90                   	nop
  800426:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800429:	5b                   	pop    %ebx
  80042a:	5e                   	pop    %esi
  80042b:	5f                   	pop    %edi
  80042c:	5d                   	pop    %ebp
  80042d:	c3                   	ret    

0080042e <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  80042e:	55                   	push   %ebp
  80042f:	89 e5                	mov    %esp,%ebp
  800431:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800434:	83 ec 0c             	sub    $0xc,%esp
  800437:	6a 00                	push   $0x0
  800439:	e8 83 16 00 00       	call   801ac1 <sys_destroy_env>
  80043e:	83 c4 10             	add    $0x10,%esp
}
  800441:	90                   	nop
  800442:	c9                   	leave  
  800443:	c3                   	ret    

00800444 <exit>:

void
exit(void)
{
  800444:	55                   	push   %ebp
  800445:	89 e5                	mov    %esp,%ebp
  800447:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  80044a:	e8 d8 16 00 00       	call   801b27 <sys_exit_env>
}
  80044f:	90                   	nop
  800450:	c9                   	leave  
  800451:	c3                   	ret    

00800452 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  800452:	55                   	push   %ebp
  800453:	89 e5                	mov    %esp,%ebp
  800455:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  800458:	8d 45 10             	lea    0x10(%ebp),%eax
  80045b:	83 c0 04             	add    $0x4,%eax
  80045e:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  800461:	a1 18 b1 81 00       	mov    0x81b118,%eax
  800466:	85 c0                	test   %eax,%eax
  800468:	74 16                	je     800480 <_panic+0x2e>
		cprintf("%s: ", argv0);
  80046a:	a1 18 b1 81 00       	mov    0x81b118,%eax
  80046f:	83 ec 08             	sub    $0x8,%esp
  800472:	50                   	push   %eax
  800473:	68 14 25 80 00       	push   $0x802514
  800478:	e8 a3 02 00 00       	call   800720 <cprintf>
  80047d:	83 c4 10             	add    $0x10,%esp
	cprintf_colored(TEXT_PANIC_CLR, "user [EVAL_FINAL]panic in %s at %s:%d: ", binaryname, file, line);
  800480:	a1 04 30 80 00       	mov    0x803004,%eax
  800485:	83 ec 0c             	sub    $0xc,%esp
  800488:	ff 75 0c             	pushl  0xc(%ebp)
  80048b:	ff 75 08             	pushl  0x8(%ebp)
  80048e:	50                   	push   %eax
  80048f:	68 1c 25 80 00       	push   $0x80251c
  800494:	6a 74                	push   $0x74
  800496:	e8 b2 02 00 00       	call   80074d <cprintf_colored>
  80049b:	83 c4 20             	add    $0x20,%esp
	vcprintf(fmt, ap);
  80049e:	8b 45 10             	mov    0x10(%ebp),%eax
  8004a1:	83 ec 08             	sub    $0x8,%esp
  8004a4:	ff 75 f4             	pushl  -0xc(%ebp)
  8004a7:	50                   	push   %eax
  8004a8:	e8 04 02 00 00       	call   8006b1 <vcprintf>
  8004ad:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  8004b0:	83 ec 08             	sub    $0x8,%esp
  8004b3:	6a 00                	push   $0x0
  8004b5:	68 44 25 80 00       	push   $0x802544
  8004ba:	e8 f2 01 00 00       	call   8006b1 <vcprintf>
  8004bf:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  8004c2:	e8 7d ff ff ff       	call   800444 <exit>

	// should not return here
	while (1) ;
  8004c7:	eb fe                	jmp    8004c7 <_panic+0x75>

008004c9 <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  8004c9:	55                   	push   %ebp
  8004ca:	89 e5                	mov    %esp,%ebp
  8004cc:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  8004cf:	a1 20 30 80 00       	mov    0x803020,%eax
  8004d4:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  8004da:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004dd:	39 c2                	cmp    %eax,%edx
  8004df:	74 14                	je     8004f5 <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  8004e1:	83 ec 04             	sub    $0x4,%esp
  8004e4:	68 48 25 80 00       	push   $0x802548
  8004e9:	6a 26                	push   $0x26
  8004eb:	68 94 25 80 00       	push   $0x802594
  8004f0:	e8 5d ff ff ff       	call   800452 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  8004f5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  8004fc:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800503:	e9 c5 00 00 00       	jmp    8005cd <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  800508:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80050b:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800512:	8b 45 08             	mov    0x8(%ebp),%eax
  800515:	01 d0                	add    %edx,%eax
  800517:	8b 00                	mov    (%eax),%eax
  800519:	85 c0                	test   %eax,%eax
  80051b:	75 08                	jne    800525 <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  80051d:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  800520:	e9 a5 00 00 00       	jmp    8005ca <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  800525:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80052c:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  800533:	eb 69                	jmp    80059e <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  800535:	a1 20 30 80 00       	mov    0x803020,%eax
  80053a:	8b 88 38 da 01 00    	mov    0x1da38(%eax),%ecx
  800540:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800543:	89 d0                	mov    %edx,%eax
  800545:	01 c0                	add    %eax,%eax
  800547:	01 d0                	add    %edx,%eax
  800549:	c1 e0 03             	shl    $0x3,%eax
  80054c:	01 c8                	add    %ecx,%eax
  80054e:	8a 40 04             	mov    0x4(%eax),%al
  800551:	84 c0                	test   %al,%al
  800553:	75 46                	jne    80059b <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800555:	a1 20 30 80 00       	mov    0x803020,%eax
  80055a:	8b 88 38 da 01 00    	mov    0x1da38(%eax),%ecx
  800560:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800563:	89 d0                	mov    %edx,%eax
  800565:	01 c0                	add    %eax,%eax
  800567:	01 d0                	add    %edx,%eax
  800569:	c1 e0 03             	shl    $0x3,%eax
  80056c:	01 c8                	add    %ecx,%eax
  80056e:	8b 00                	mov    (%eax),%eax
  800570:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800573:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800576:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80057b:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  80057d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800580:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800587:	8b 45 08             	mov    0x8(%ebp),%eax
  80058a:	01 c8                	add    %ecx,%eax
  80058c:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  80058e:	39 c2                	cmp    %eax,%edx
  800590:	75 09                	jne    80059b <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  800592:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  800599:	eb 15                	jmp    8005b0 <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80059b:	ff 45 e8             	incl   -0x18(%ebp)
  80059e:	a1 20 30 80 00       	mov    0x803020,%eax
  8005a3:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  8005a9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8005ac:	39 c2                	cmp    %eax,%edx
  8005ae:	77 85                	ja     800535 <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  8005b0:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8005b4:	75 14                	jne    8005ca <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  8005b6:	83 ec 04             	sub    $0x4,%esp
  8005b9:	68 a0 25 80 00       	push   $0x8025a0
  8005be:	6a 3a                	push   $0x3a
  8005c0:	68 94 25 80 00       	push   $0x802594
  8005c5:	e8 88 fe ff ff       	call   800452 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  8005ca:	ff 45 f0             	incl   -0x10(%ebp)
  8005cd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8005d0:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8005d3:	0f 8c 2f ff ff ff    	jl     800508 <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  8005d9:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8005e0:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  8005e7:	eb 26                	jmp    80060f <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  8005e9:	a1 20 30 80 00       	mov    0x803020,%eax
  8005ee:	8b 88 38 da 01 00    	mov    0x1da38(%eax),%ecx
  8005f4:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8005f7:	89 d0                	mov    %edx,%eax
  8005f9:	01 c0                	add    %eax,%eax
  8005fb:	01 d0                	add    %edx,%eax
  8005fd:	c1 e0 03             	shl    $0x3,%eax
  800600:	01 c8                	add    %ecx,%eax
  800602:	8a 40 04             	mov    0x4(%eax),%al
  800605:	3c 01                	cmp    $0x1,%al
  800607:	75 03                	jne    80060c <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  800609:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80060c:	ff 45 e0             	incl   -0x20(%ebp)
  80060f:	a1 20 30 80 00       	mov    0x803020,%eax
  800614:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  80061a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80061d:	39 c2                	cmp    %eax,%edx
  80061f:	77 c8                	ja     8005e9 <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  800621:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800624:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800627:	74 14                	je     80063d <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  800629:	83 ec 04             	sub    $0x4,%esp
  80062c:	68 f4 25 80 00       	push   $0x8025f4
  800631:	6a 44                	push   $0x44
  800633:	68 94 25 80 00       	push   $0x802594
  800638:	e8 15 fe ff ff       	call   800452 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  80063d:	90                   	nop
  80063e:	c9                   	leave  
  80063f:	c3                   	ret    

00800640 <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  800640:	55                   	push   %ebp
  800641:	89 e5                	mov    %esp,%ebp
  800643:	53                   	push   %ebx
  800644:	83 ec 04             	sub    $0x4,%esp
	b->buf[b->idx++] = ch;
  800647:	8b 45 0c             	mov    0xc(%ebp),%eax
  80064a:	8b 00                	mov    (%eax),%eax
  80064c:	8d 48 01             	lea    0x1(%eax),%ecx
  80064f:	8b 55 0c             	mov    0xc(%ebp),%edx
  800652:	89 0a                	mov    %ecx,(%edx)
  800654:	8b 55 08             	mov    0x8(%ebp),%edx
  800657:	88 d1                	mov    %dl,%cl
  800659:	8b 55 0c             	mov    0xc(%ebp),%edx
  80065c:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800660:	8b 45 0c             	mov    0xc(%ebp),%eax
  800663:	8b 00                	mov    (%eax),%eax
  800665:	3d ff 00 00 00       	cmp    $0xff,%eax
  80066a:	75 30                	jne    80069c <putch+0x5c>
		sys_cputs(b->buf, b->idx, printProgName, curTextClr);
  80066c:	8b 15 1c b1 81 00    	mov    0x81b11c,%edx
  800672:	a0 44 30 80 00       	mov    0x803044,%al
  800677:	0f b6 c0             	movzbl %al,%eax
  80067a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80067d:	8b 09                	mov    (%ecx),%ecx
  80067f:	89 cb                	mov    %ecx,%ebx
  800681:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800684:	83 c1 08             	add    $0x8,%ecx
  800687:	52                   	push   %edx
  800688:	50                   	push   %eax
  800689:	53                   	push   %ebx
  80068a:	51                   	push   %ecx
  80068b:	e8 a8 11 00 00       	call   801838 <sys_cputs>
  800690:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800693:	8b 45 0c             	mov    0xc(%ebp),%eax
  800696:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  80069c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80069f:	8b 40 04             	mov    0x4(%eax),%eax
  8006a2:	8d 50 01             	lea    0x1(%eax),%edx
  8006a5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006a8:	89 50 04             	mov    %edx,0x4(%eax)
}
  8006ab:	90                   	nop
  8006ac:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8006af:	c9                   	leave  
  8006b0:	c3                   	ret    

008006b1 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  8006b1:	55                   	push   %ebp
  8006b2:	89 e5                	mov    %esp,%ebp
  8006b4:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8006ba:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8006c1:	00 00 00 
	b.cnt = 0;
  8006c4:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8006cb:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  8006ce:	ff 75 0c             	pushl  0xc(%ebp)
  8006d1:	ff 75 08             	pushl  0x8(%ebp)
  8006d4:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8006da:	50                   	push   %eax
  8006db:	68 40 06 80 00       	push   $0x800640
  8006e0:	e8 5a 02 00 00       	call   80093f <vprintfmt>
  8006e5:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName, curTextClr);
  8006e8:	8b 15 1c b1 81 00    	mov    0x81b11c,%edx
  8006ee:	a0 44 30 80 00       	mov    0x803044,%al
  8006f3:	0f b6 c0             	movzbl %al,%eax
  8006f6:	8b 8d f0 fe ff ff    	mov    -0x110(%ebp),%ecx
  8006fc:	52                   	push   %edx
  8006fd:	50                   	push   %eax
  8006fe:	51                   	push   %ecx
  8006ff:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800705:	83 c0 08             	add    $0x8,%eax
  800708:	50                   	push   %eax
  800709:	e8 2a 11 00 00       	call   801838 <sys_cputs>
  80070e:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800711:	c6 05 44 30 80 00 00 	movb   $0x0,0x803044
	return b.cnt;
  800718:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  80071e:	c9                   	leave  
  80071f:	c3                   	ret    

00800720 <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  800720:	55                   	push   %ebp
  800721:	89 e5                	mov    %esp,%ebp
  800723:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800726:	c6 05 44 30 80 00 01 	movb   $0x1,0x803044
	va_start(ap, fmt);
  80072d:	8d 45 0c             	lea    0xc(%ebp),%eax
  800730:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800733:	8b 45 08             	mov    0x8(%ebp),%eax
  800736:	83 ec 08             	sub    $0x8,%esp
  800739:	ff 75 f4             	pushl  -0xc(%ebp)
  80073c:	50                   	push   %eax
  80073d:	e8 6f ff ff ff       	call   8006b1 <vcprintf>
  800742:	83 c4 10             	add    $0x10,%esp
  800745:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800748:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80074b:	c9                   	leave  
  80074c:	c3                   	ret    

0080074d <cprintf_colored>:

// *************** This text coloring feature is implemented by *************
// ********** Abd-Alrahman Zedan From Team Frozen-Bytes - FCIS'24-25 ********
int cprintf_colored(int textClr, const char *fmt, ...) {
  80074d:	55                   	push   %ebp
  80074e:	89 e5                	mov    %esp,%ebp
  800750:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800753:	c6 05 44 30 80 00 01 	movb   $0x1,0x803044
	curTextClr = (textClr << 8) ; //set text color by the given value
  80075a:	8b 45 08             	mov    0x8(%ebp),%eax
  80075d:	c1 e0 08             	shl    $0x8,%eax
  800760:	a3 1c b1 81 00       	mov    %eax,0x81b11c
	va_start(ap, fmt);
  800765:	8d 45 0c             	lea    0xc(%ebp),%eax
  800768:	83 c0 04             	add    $0x4,%eax
  80076b:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  80076e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800771:	83 ec 08             	sub    $0x8,%esp
  800774:	ff 75 f4             	pushl  -0xc(%ebp)
  800777:	50                   	push   %eax
  800778:	e8 34 ff ff ff       	call   8006b1 <vcprintf>
  80077d:	83 c4 10             	add    $0x10,%esp
  800780:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);
	curTextClr = TEXT_DEFAULT_CLR; //restore default color
  800783:	c7 05 1c b1 81 00 00 	movl   $0x700,0x81b11c
  80078a:	07 00 00 

	return cnt;
  80078d:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800790:	c9                   	leave  
  800791:	c3                   	ret    

00800792 <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  800792:	55                   	push   %ebp
  800793:	89 e5                	mov    %esp,%ebp
  800795:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  800798:	e8 df 10 00 00       	call   80187c <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  80079d:	8d 45 0c             	lea    0xc(%ebp),%eax
  8007a0:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  8007a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8007a6:	83 ec 08             	sub    $0x8,%esp
  8007a9:	ff 75 f4             	pushl  -0xc(%ebp)
  8007ac:	50                   	push   %eax
  8007ad:	e8 ff fe ff ff       	call   8006b1 <vcprintf>
  8007b2:	83 c4 10             	add    $0x10,%esp
  8007b5:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  8007b8:	e8 d9 10 00 00       	call   801896 <sys_unlock_cons>
	return cnt;
  8007bd:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8007c0:	c9                   	leave  
  8007c1:	c3                   	ret    

008007c2 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8007c2:	55                   	push   %ebp
  8007c3:	89 e5                	mov    %esp,%ebp
  8007c5:	53                   	push   %ebx
  8007c6:	83 ec 14             	sub    $0x14,%esp
  8007c9:	8b 45 10             	mov    0x10(%ebp),%eax
  8007cc:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8007cf:	8b 45 14             	mov    0x14(%ebp),%eax
  8007d2:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8007d5:	8b 45 18             	mov    0x18(%ebp),%eax
  8007d8:	ba 00 00 00 00       	mov    $0x0,%edx
  8007dd:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8007e0:	77 55                	ja     800837 <printnum+0x75>
  8007e2:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8007e5:	72 05                	jb     8007ec <printnum+0x2a>
  8007e7:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8007ea:	77 4b                	ja     800837 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8007ec:	8b 45 1c             	mov    0x1c(%ebp),%eax
  8007ef:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8007f2:	8b 45 18             	mov    0x18(%ebp),%eax
  8007f5:	ba 00 00 00 00       	mov    $0x0,%edx
  8007fa:	52                   	push   %edx
  8007fb:	50                   	push   %eax
  8007fc:	ff 75 f4             	pushl  -0xc(%ebp)
  8007ff:	ff 75 f0             	pushl  -0x10(%ebp)
  800802:	e8 ad 16 00 00       	call   801eb4 <__udivdi3>
  800807:	83 c4 10             	add    $0x10,%esp
  80080a:	83 ec 04             	sub    $0x4,%esp
  80080d:	ff 75 20             	pushl  0x20(%ebp)
  800810:	53                   	push   %ebx
  800811:	ff 75 18             	pushl  0x18(%ebp)
  800814:	52                   	push   %edx
  800815:	50                   	push   %eax
  800816:	ff 75 0c             	pushl  0xc(%ebp)
  800819:	ff 75 08             	pushl  0x8(%ebp)
  80081c:	e8 a1 ff ff ff       	call   8007c2 <printnum>
  800821:	83 c4 20             	add    $0x20,%esp
  800824:	eb 1a                	jmp    800840 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800826:	83 ec 08             	sub    $0x8,%esp
  800829:	ff 75 0c             	pushl  0xc(%ebp)
  80082c:	ff 75 20             	pushl  0x20(%ebp)
  80082f:	8b 45 08             	mov    0x8(%ebp),%eax
  800832:	ff d0                	call   *%eax
  800834:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800837:	ff 4d 1c             	decl   0x1c(%ebp)
  80083a:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  80083e:	7f e6                	jg     800826 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800840:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800843:	bb 00 00 00 00       	mov    $0x0,%ebx
  800848:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80084b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80084e:	53                   	push   %ebx
  80084f:	51                   	push   %ecx
  800850:	52                   	push   %edx
  800851:	50                   	push   %eax
  800852:	e8 6d 17 00 00       	call   801fc4 <__umoddi3>
  800857:	83 c4 10             	add    $0x10,%esp
  80085a:	05 54 28 80 00       	add    $0x802854,%eax
  80085f:	8a 00                	mov    (%eax),%al
  800861:	0f be c0             	movsbl %al,%eax
  800864:	83 ec 08             	sub    $0x8,%esp
  800867:	ff 75 0c             	pushl  0xc(%ebp)
  80086a:	50                   	push   %eax
  80086b:	8b 45 08             	mov    0x8(%ebp),%eax
  80086e:	ff d0                	call   *%eax
  800870:	83 c4 10             	add    $0x10,%esp
}
  800873:	90                   	nop
  800874:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800877:	c9                   	leave  
  800878:	c3                   	ret    

00800879 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800879:	55                   	push   %ebp
  80087a:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  80087c:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800880:	7e 1c                	jle    80089e <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800882:	8b 45 08             	mov    0x8(%ebp),%eax
  800885:	8b 00                	mov    (%eax),%eax
  800887:	8d 50 08             	lea    0x8(%eax),%edx
  80088a:	8b 45 08             	mov    0x8(%ebp),%eax
  80088d:	89 10                	mov    %edx,(%eax)
  80088f:	8b 45 08             	mov    0x8(%ebp),%eax
  800892:	8b 00                	mov    (%eax),%eax
  800894:	83 e8 08             	sub    $0x8,%eax
  800897:	8b 50 04             	mov    0x4(%eax),%edx
  80089a:	8b 00                	mov    (%eax),%eax
  80089c:	eb 40                	jmp    8008de <getuint+0x65>
	else if (lflag)
  80089e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8008a2:	74 1e                	je     8008c2 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  8008a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8008a7:	8b 00                	mov    (%eax),%eax
  8008a9:	8d 50 04             	lea    0x4(%eax),%edx
  8008ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8008af:	89 10                	mov    %edx,(%eax)
  8008b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8008b4:	8b 00                	mov    (%eax),%eax
  8008b6:	83 e8 04             	sub    $0x4,%eax
  8008b9:	8b 00                	mov    (%eax),%eax
  8008bb:	ba 00 00 00 00       	mov    $0x0,%edx
  8008c0:	eb 1c                	jmp    8008de <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  8008c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8008c5:	8b 00                	mov    (%eax),%eax
  8008c7:	8d 50 04             	lea    0x4(%eax),%edx
  8008ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8008cd:	89 10                	mov    %edx,(%eax)
  8008cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8008d2:	8b 00                	mov    (%eax),%eax
  8008d4:	83 e8 04             	sub    $0x4,%eax
  8008d7:	8b 00                	mov    (%eax),%eax
  8008d9:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8008de:	5d                   	pop    %ebp
  8008df:	c3                   	ret    

008008e0 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8008e0:	55                   	push   %ebp
  8008e1:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8008e3:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8008e7:	7e 1c                	jle    800905 <getint+0x25>
		return va_arg(*ap, long long);
  8008e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8008ec:	8b 00                	mov    (%eax),%eax
  8008ee:	8d 50 08             	lea    0x8(%eax),%edx
  8008f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8008f4:	89 10                	mov    %edx,(%eax)
  8008f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8008f9:	8b 00                	mov    (%eax),%eax
  8008fb:	83 e8 08             	sub    $0x8,%eax
  8008fe:	8b 50 04             	mov    0x4(%eax),%edx
  800901:	8b 00                	mov    (%eax),%eax
  800903:	eb 38                	jmp    80093d <getint+0x5d>
	else if (lflag)
  800905:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800909:	74 1a                	je     800925 <getint+0x45>
		return va_arg(*ap, long);
  80090b:	8b 45 08             	mov    0x8(%ebp),%eax
  80090e:	8b 00                	mov    (%eax),%eax
  800910:	8d 50 04             	lea    0x4(%eax),%edx
  800913:	8b 45 08             	mov    0x8(%ebp),%eax
  800916:	89 10                	mov    %edx,(%eax)
  800918:	8b 45 08             	mov    0x8(%ebp),%eax
  80091b:	8b 00                	mov    (%eax),%eax
  80091d:	83 e8 04             	sub    $0x4,%eax
  800920:	8b 00                	mov    (%eax),%eax
  800922:	99                   	cltd   
  800923:	eb 18                	jmp    80093d <getint+0x5d>
	else
		return va_arg(*ap, int);
  800925:	8b 45 08             	mov    0x8(%ebp),%eax
  800928:	8b 00                	mov    (%eax),%eax
  80092a:	8d 50 04             	lea    0x4(%eax),%edx
  80092d:	8b 45 08             	mov    0x8(%ebp),%eax
  800930:	89 10                	mov    %edx,(%eax)
  800932:	8b 45 08             	mov    0x8(%ebp),%eax
  800935:	8b 00                	mov    (%eax),%eax
  800937:	83 e8 04             	sub    $0x4,%eax
  80093a:	8b 00                	mov    (%eax),%eax
  80093c:	99                   	cltd   
}
  80093d:	5d                   	pop    %ebp
  80093e:	c3                   	ret    

0080093f <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  80093f:	55                   	push   %ebp
  800940:	89 e5                	mov    %esp,%ebp
  800942:	56                   	push   %esi
  800943:	53                   	push   %ebx
  800944:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800947:	eb 17                	jmp    800960 <vprintfmt+0x21>
			if (ch == '\0')
  800949:	85 db                	test   %ebx,%ebx
  80094b:	0f 84 c1 03 00 00    	je     800d12 <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  800951:	83 ec 08             	sub    $0x8,%esp
  800954:	ff 75 0c             	pushl  0xc(%ebp)
  800957:	53                   	push   %ebx
  800958:	8b 45 08             	mov    0x8(%ebp),%eax
  80095b:	ff d0                	call   *%eax
  80095d:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800960:	8b 45 10             	mov    0x10(%ebp),%eax
  800963:	8d 50 01             	lea    0x1(%eax),%edx
  800966:	89 55 10             	mov    %edx,0x10(%ebp)
  800969:	8a 00                	mov    (%eax),%al
  80096b:	0f b6 d8             	movzbl %al,%ebx
  80096e:	83 fb 25             	cmp    $0x25,%ebx
  800971:	75 d6                	jne    800949 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800973:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800977:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  80097e:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800985:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  80098c:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800993:	8b 45 10             	mov    0x10(%ebp),%eax
  800996:	8d 50 01             	lea    0x1(%eax),%edx
  800999:	89 55 10             	mov    %edx,0x10(%ebp)
  80099c:	8a 00                	mov    (%eax),%al
  80099e:	0f b6 d8             	movzbl %al,%ebx
  8009a1:	8d 43 dd             	lea    -0x23(%ebx),%eax
  8009a4:	83 f8 5b             	cmp    $0x5b,%eax
  8009a7:	0f 87 3d 03 00 00    	ja     800cea <vprintfmt+0x3ab>
  8009ad:	8b 04 85 78 28 80 00 	mov    0x802878(,%eax,4),%eax
  8009b4:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  8009b6:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  8009ba:	eb d7                	jmp    800993 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8009bc:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  8009c0:	eb d1                	jmp    800993 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8009c2:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  8009c9:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8009cc:	89 d0                	mov    %edx,%eax
  8009ce:	c1 e0 02             	shl    $0x2,%eax
  8009d1:	01 d0                	add    %edx,%eax
  8009d3:	01 c0                	add    %eax,%eax
  8009d5:	01 d8                	add    %ebx,%eax
  8009d7:	83 e8 30             	sub    $0x30,%eax
  8009da:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  8009dd:	8b 45 10             	mov    0x10(%ebp),%eax
  8009e0:	8a 00                	mov    (%eax),%al
  8009e2:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8009e5:	83 fb 2f             	cmp    $0x2f,%ebx
  8009e8:	7e 3e                	jle    800a28 <vprintfmt+0xe9>
  8009ea:	83 fb 39             	cmp    $0x39,%ebx
  8009ed:	7f 39                	jg     800a28 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8009ef:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8009f2:	eb d5                	jmp    8009c9 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8009f4:	8b 45 14             	mov    0x14(%ebp),%eax
  8009f7:	83 c0 04             	add    $0x4,%eax
  8009fa:	89 45 14             	mov    %eax,0x14(%ebp)
  8009fd:	8b 45 14             	mov    0x14(%ebp),%eax
  800a00:	83 e8 04             	sub    $0x4,%eax
  800a03:	8b 00                	mov    (%eax),%eax
  800a05:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800a08:	eb 1f                	jmp    800a29 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800a0a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a0e:	79 83                	jns    800993 <vprintfmt+0x54>
				width = 0;
  800a10:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800a17:	e9 77 ff ff ff       	jmp    800993 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800a1c:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800a23:	e9 6b ff ff ff       	jmp    800993 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800a28:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800a29:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a2d:	0f 89 60 ff ff ff    	jns    800993 <vprintfmt+0x54>
				width = precision, precision = -1;
  800a33:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800a36:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800a39:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800a40:	e9 4e ff ff ff       	jmp    800993 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800a45:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800a48:	e9 46 ff ff ff       	jmp    800993 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800a4d:	8b 45 14             	mov    0x14(%ebp),%eax
  800a50:	83 c0 04             	add    $0x4,%eax
  800a53:	89 45 14             	mov    %eax,0x14(%ebp)
  800a56:	8b 45 14             	mov    0x14(%ebp),%eax
  800a59:	83 e8 04             	sub    $0x4,%eax
  800a5c:	8b 00                	mov    (%eax),%eax
  800a5e:	83 ec 08             	sub    $0x8,%esp
  800a61:	ff 75 0c             	pushl  0xc(%ebp)
  800a64:	50                   	push   %eax
  800a65:	8b 45 08             	mov    0x8(%ebp),%eax
  800a68:	ff d0                	call   *%eax
  800a6a:	83 c4 10             	add    $0x10,%esp
			break;
  800a6d:	e9 9b 02 00 00       	jmp    800d0d <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800a72:	8b 45 14             	mov    0x14(%ebp),%eax
  800a75:	83 c0 04             	add    $0x4,%eax
  800a78:	89 45 14             	mov    %eax,0x14(%ebp)
  800a7b:	8b 45 14             	mov    0x14(%ebp),%eax
  800a7e:	83 e8 04             	sub    $0x4,%eax
  800a81:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800a83:	85 db                	test   %ebx,%ebx
  800a85:	79 02                	jns    800a89 <vprintfmt+0x14a>
				err = -err;
  800a87:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800a89:	83 fb 64             	cmp    $0x64,%ebx
  800a8c:	7f 0b                	jg     800a99 <vprintfmt+0x15a>
  800a8e:	8b 34 9d c0 26 80 00 	mov    0x8026c0(,%ebx,4),%esi
  800a95:	85 f6                	test   %esi,%esi
  800a97:	75 19                	jne    800ab2 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800a99:	53                   	push   %ebx
  800a9a:	68 65 28 80 00       	push   $0x802865
  800a9f:	ff 75 0c             	pushl  0xc(%ebp)
  800aa2:	ff 75 08             	pushl  0x8(%ebp)
  800aa5:	e8 70 02 00 00       	call   800d1a <printfmt>
  800aaa:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800aad:	e9 5b 02 00 00       	jmp    800d0d <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800ab2:	56                   	push   %esi
  800ab3:	68 6e 28 80 00       	push   $0x80286e
  800ab8:	ff 75 0c             	pushl  0xc(%ebp)
  800abb:	ff 75 08             	pushl  0x8(%ebp)
  800abe:	e8 57 02 00 00       	call   800d1a <printfmt>
  800ac3:	83 c4 10             	add    $0x10,%esp
			break;
  800ac6:	e9 42 02 00 00       	jmp    800d0d <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800acb:	8b 45 14             	mov    0x14(%ebp),%eax
  800ace:	83 c0 04             	add    $0x4,%eax
  800ad1:	89 45 14             	mov    %eax,0x14(%ebp)
  800ad4:	8b 45 14             	mov    0x14(%ebp),%eax
  800ad7:	83 e8 04             	sub    $0x4,%eax
  800ada:	8b 30                	mov    (%eax),%esi
  800adc:	85 f6                	test   %esi,%esi
  800ade:	75 05                	jne    800ae5 <vprintfmt+0x1a6>
				p = "(null)";
  800ae0:	be 71 28 80 00       	mov    $0x802871,%esi
			if (width > 0 && padc != '-')
  800ae5:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800ae9:	7e 6d                	jle    800b58 <vprintfmt+0x219>
  800aeb:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800aef:	74 67                	je     800b58 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800af1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800af4:	83 ec 08             	sub    $0x8,%esp
  800af7:	50                   	push   %eax
  800af8:	56                   	push   %esi
  800af9:	e8 26 05 00 00       	call   801024 <strnlen>
  800afe:	83 c4 10             	add    $0x10,%esp
  800b01:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800b04:	eb 16                	jmp    800b1c <vprintfmt+0x1dd>
					putch(padc, putdat);
  800b06:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800b0a:	83 ec 08             	sub    $0x8,%esp
  800b0d:	ff 75 0c             	pushl  0xc(%ebp)
  800b10:	50                   	push   %eax
  800b11:	8b 45 08             	mov    0x8(%ebp),%eax
  800b14:	ff d0                	call   *%eax
  800b16:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800b19:	ff 4d e4             	decl   -0x1c(%ebp)
  800b1c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800b20:	7f e4                	jg     800b06 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800b22:	eb 34                	jmp    800b58 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800b24:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800b28:	74 1c                	je     800b46 <vprintfmt+0x207>
  800b2a:	83 fb 1f             	cmp    $0x1f,%ebx
  800b2d:	7e 05                	jle    800b34 <vprintfmt+0x1f5>
  800b2f:	83 fb 7e             	cmp    $0x7e,%ebx
  800b32:	7e 12                	jle    800b46 <vprintfmt+0x207>
					putch('?', putdat);
  800b34:	83 ec 08             	sub    $0x8,%esp
  800b37:	ff 75 0c             	pushl  0xc(%ebp)
  800b3a:	6a 3f                	push   $0x3f
  800b3c:	8b 45 08             	mov    0x8(%ebp),%eax
  800b3f:	ff d0                	call   *%eax
  800b41:	83 c4 10             	add    $0x10,%esp
  800b44:	eb 0f                	jmp    800b55 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800b46:	83 ec 08             	sub    $0x8,%esp
  800b49:	ff 75 0c             	pushl  0xc(%ebp)
  800b4c:	53                   	push   %ebx
  800b4d:	8b 45 08             	mov    0x8(%ebp),%eax
  800b50:	ff d0                	call   *%eax
  800b52:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800b55:	ff 4d e4             	decl   -0x1c(%ebp)
  800b58:	89 f0                	mov    %esi,%eax
  800b5a:	8d 70 01             	lea    0x1(%eax),%esi
  800b5d:	8a 00                	mov    (%eax),%al
  800b5f:	0f be d8             	movsbl %al,%ebx
  800b62:	85 db                	test   %ebx,%ebx
  800b64:	74 24                	je     800b8a <vprintfmt+0x24b>
  800b66:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800b6a:	78 b8                	js     800b24 <vprintfmt+0x1e5>
  800b6c:	ff 4d e0             	decl   -0x20(%ebp)
  800b6f:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800b73:	79 af                	jns    800b24 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800b75:	eb 13                	jmp    800b8a <vprintfmt+0x24b>
				putch(' ', putdat);
  800b77:	83 ec 08             	sub    $0x8,%esp
  800b7a:	ff 75 0c             	pushl  0xc(%ebp)
  800b7d:	6a 20                	push   $0x20
  800b7f:	8b 45 08             	mov    0x8(%ebp),%eax
  800b82:	ff d0                	call   *%eax
  800b84:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800b87:	ff 4d e4             	decl   -0x1c(%ebp)
  800b8a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800b8e:	7f e7                	jg     800b77 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800b90:	e9 78 01 00 00       	jmp    800d0d <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800b95:	83 ec 08             	sub    $0x8,%esp
  800b98:	ff 75 e8             	pushl  -0x18(%ebp)
  800b9b:	8d 45 14             	lea    0x14(%ebp),%eax
  800b9e:	50                   	push   %eax
  800b9f:	e8 3c fd ff ff       	call   8008e0 <getint>
  800ba4:	83 c4 10             	add    $0x10,%esp
  800ba7:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800baa:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800bad:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800bb0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800bb3:	85 d2                	test   %edx,%edx
  800bb5:	79 23                	jns    800bda <vprintfmt+0x29b>
				putch('-', putdat);
  800bb7:	83 ec 08             	sub    $0x8,%esp
  800bba:	ff 75 0c             	pushl  0xc(%ebp)
  800bbd:	6a 2d                	push   $0x2d
  800bbf:	8b 45 08             	mov    0x8(%ebp),%eax
  800bc2:	ff d0                	call   *%eax
  800bc4:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800bc7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800bca:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800bcd:	f7 d8                	neg    %eax
  800bcf:	83 d2 00             	adc    $0x0,%edx
  800bd2:	f7 da                	neg    %edx
  800bd4:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800bd7:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800bda:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800be1:	e9 bc 00 00 00       	jmp    800ca2 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800be6:	83 ec 08             	sub    $0x8,%esp
  800be9:	ff 75 e8             	pushl  -0x18(%ebp)
  800bec:	8d 45 14             	lea    0x14(%ebp),%eax
  800bef:	50                   	push   %eax
  800bf0:	e8 84 fc ff ff       	call   800879 <getuint>
  800bf5:	83 c4 10             	add    $0x10,%esp
  800bf8:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800bfb:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800bfe:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800c05:	e9 98 00 00 00       	jmp    800ca2 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800c0a:	83 ec 08             	sub    $0x8,%esp
  800c0d:	ff 75 0c             	pushl  0xc(%ebp)
  800c10:	6a 58                	push   $0x58
  800c12:	8b 45 08             	mov    0x8(%ebp),%eax
  800c15:	ff d0                	call   *%eax
  800c17:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800c1a:	83 ec 08             	sub    $0x8,%esp
  800c1d:	ff 75 0c             	pushl  0xc(%ebp)
  800c20:	6a 58                	push   $0x58
  800c22:	8b 45 08             	mov    0x8(%ebp),%eax
  800c25:	ff d0                	call   *%eax
  800c27:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800c2a:	83 ec 08             	sub    $0x8,%esp
  800c2d:	ff 75 0c             	pushl  0xc(%ebp)
  800c30:	6a 58                	push   $0x58
  800c32:	8b 45 08             	mov    0x8(%ebp),%eax
  800c35:	ff d0                	call   *%eax
  800c37:	83 c4 10             	add    $0x10,%esp
			break;
  800c3a:	e9 ce 00 00 00       	jmp    800d0d <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  800c3f:	83 ec 08             	sub    $0x8,%esp
  800c42:	ff 75 0c             	pushl  0xc(%ebp)
  800c45:	6a 30                	push   $0x30
  800c47:	8b 45 08             	mov    0x8(%ebp),%eax
  800c4a:	ff d0                	call   *%eax
  800c4c:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800c4f:	83 ec 08             	sub    $0x8,%esp
  800c52:	ff 75 0c             	pushl  0xc(%ebp)
  800c55:	6a 78                	push   $0x78
  800c57:	8b 45 08             	mov    0x8(%ebp),%eax
  800c5a:	ff d0                	call   *%eax
  800c5c:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800c5f:	8b 45 14             	mov    0x14(%ebp),%eax
  800c62:	83 c0 04             	add    $0x4,%eax
  800c65:	89 45 14             	mov    %eax,0x14(%ebp)
  800c68:	8b 45 14             	mov    0x14(%ebp),%eax
  800c6b:	83 e8 04             	sub    $0x4,%eax
  800c6e:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800c70:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c73:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800c7a:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800c81:	eb 1f                	jmp    800ca2 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800c83:	83 ec 08             	sub    $0x8,%esp
  800c86:	ff 75 e8             	pushl  -0x18(%ebp)
  800c89:	8d 45 14             	lea    0x14(%ebp),%eax
  800c8c:	50                   	push   %eax
  800c8d:	e8 e7 fb ff ff       	call   800879 <getuint>
  800c92:	83 c4 10             	add    $0x10,%esp
  800c95:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c98:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800c9b:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800ca2:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800ca6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800ca9:	83 ec 04             	sub    $0x4,%esp
  800cac:	52                   	push   %edx
  800cad:	ff 75 e4             	pushl  -0x1c(%ebp)
  800cb0:	50                   	push   %eax
  800cb1:	ff 75 f4             	pushl  -0xc(%ebp)
  800cb4:	ff 75 f0             	pushl  -0x10(%ebp)
  800cb7:	ff 75 0c             	pushl  0xc(%ebp)
  800cba:	ff 75 08             	pushl  0x8(%ebp)
  800cbd:	e8 00 fb ff ff       	call   8007c2 <printnum>
  800cc2:	83 c4 20             	add    $0x20,%esp
			break;
  800cc5:	eb 46                	jmp    800d0d <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800cc7:	83 ec 08             	sub    $0x8,%esp
  800cca:	ff 75 0c             	pushl  0xc(%ebp)
  800ccd:	53                   	push   %ebx
  800cce:	8b 45 08             	mov    0x8(%ebp),%eax
  800cd1:	ff d0                	call   *%eax
  800cd3:	83 c4 10             	add    $0x10,%esp
			break;
  800cd6:	eb 35                	jmp    800d0d <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  800cd8:	c6 05 44 30 80 00 00 	movb   $0x0,0x803044
			break;
  800cdf:	eb 2c                	jmp    800d0d <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  800ce1:	c6 05 44 30 80 00 01 	movb   $0x1,0x803044
			break;
  800ce8:	eb 23                	jmp    800d0d <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800cea:	83 ec 08             	sub    $0x8,%esp
  800ced:	ff 75 0c             	pushl  0xc(%ebp)
  800cf0:	6a 25                	push   $0x25
  800cf2:	8b 45 08             	mov    0x8(%ebp),%eax
  800cf5:	ff d0                	call   *%eax
  800cf7:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800cfa:	ff 4d 10             	decl   0x10(%ebp)
  800cfd:	eb 03                	jmp    800d02 <vprintfmt+0x3c3>
  800cff:	ff 4d 10             	decl   0x10(%ebp)
  800d02:	8b 45 10             	mov    0x10(%ebp),%eax
  800d05:	48                   	dec    %eax
  800d06:	8a 00                	mov    (%eax),%al
  800d08:	3c 25                	cmp    $0x25,%al
  800d0a:	75 f3                	jne    800cff <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  800d0c:	90                   	nop
		}
	}
  800d0d:	e9 35 fc ff ff       	jmp    800947 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800d12:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800d13:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800d16:	5b                   	pop    %ebx
  800d17:	5e                   	pop    %esi
  800d18:	5d                   	pop    %ebp
  800d19:	c3                   	ret    

00800d1a <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800d1a:	55                   	push   %ebp
  800d1b:	89 e5                	mov    %esp,%ebp
  800d1d:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800d20:	8d 45 10             	lea    0x10(%ebp),%eax
  800d23:	83 c0 04             	add    $0x4,%eax
  800d26:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800d29:	8b 45 10             	mov    0x10(%ebp),%eax
  800d2c:	ff 75 f4             	pushl  -0xc(%ebp)
  800d2f:	50                   	push   %eax
  800d30:	ff 75 0c             	pushl  0xc(%ebp)
  800d33:	ff 75 08             	pushl  0x8(%ebp)
  800d36:	e8 04 fc ff ff       	call   80093f <vprintfmt>
  800d3b:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800d3e:	90                   	nop
  800d3f:	c9                   	leave  
  800d40:	c3                   	ret    

00800d41 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800d41:	55                   	push   %ebp
  800d42:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800d44:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d47:	8b 40 08             	mov    0x8(%eax),%eax
  800d4a:	8d 50 01             	lea    0x1(%eax),%edx
  800d4d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d50:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800d53:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d56:	8b 10                	mov    (%eax),%edx
  800d58:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d5b:	8b 40 04             	mov    0x4(%eax),%eax
  800d5e:	39 c2                	cmp    %eax,%edx
  800d60:	73 12                	jae    800d74 <sprintputch+0x33>
		*b->buf++ = ch;
  800d62:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d65:	8b 00                	mov    (%eax),%eax
  800d67:	8d 48 01             	lea    0x1(%eax),%ecx
  800d6a:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d6d:	89 0a                	mov    %ecx,(%edx)
  800d6f:	8b 55 08             	mov    0x8(%ebp),%edx
  800d72:	88 10                	mov    %dl,(%eax)
}
  800d74:	90                   	nop
  800d75:	5d                   	pop    %ebp
  800d76:	c3                   	ret    

00800d77 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800d77:	55                   	push   %ebp
  800d78:	89 e5                	mov    %esp,%ebp
  800d7a:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800d7d:	8b 45 08             	mov    0x8(%ebp),%eax
  800d80:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800d83:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d86:	8d 50 ff             	lea    -0x1(%eax),%edx
  800d89:	8b 45 08             	mov    0x8(%ebp),%eax
  800d8c:	01 d0                	add    %edx,%eax
  800d8e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800d91:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800d98:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800d9c:	74 06                	je     800da4 <vsnprintf+0x2d>
  800d9e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800da2:	7f 07                	jg     800dab <vsnprintf+0x34>
		return -E_INVAL;
  800da4:	b8 03 00 00 00       	mov    $0x3,%eax
  800da9:	eb 20                	jmp    800dcb <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800dab:	ff 75 14             	pushl  0x14(%ebp)
  800dae:	ff 75 10             	pushl  0x10(%ebp)
  800db1:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800db4:	50                   	push   %eax
  800db5:	68 41 0d 80 00       	push   $0x800d41
  800dba:	e8 80 fb ff ff       	call   80093f <vprintfmt>
  800dbf:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800dc2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800dc5:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800dc8:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800dcb:	c9                   	leave  
  800dcc:	c3                   	ret    

00800dcd <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800dcd:	55                   	push   %ebp
  800dce:	89 e5                	mov    %esp,%ebp
  800dd0:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800dd3:	8d 45 10             	lea    0x10(%ebp),%eax
  800dd6:	83 c0 04             	add    $0x4,%eax
  800dd9:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800ddc:	8b 45 10             	mov    0x10(%ebp),%eax
  800ddf:	ff 75 f4             	pushl  -0xc(%ebp)
  800de2:	50                   	push   %eax
  800de3:	ff 75 0c             	pushl  0xc(%ebp)
  800de6:	ff 75 08             	pushl  0x8(%ebp)
  800de9:	e8 89 ff ff ff       	call   800d77 <vsnprintf>
  800dee:	83 c4 10             	add    $0x10,%esp
  800df1:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800df4:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800df7:	c9                   	leave  
  800df8:	c3                   	ret    

00800df9 <readline>:
#include <inc/lib.h>

//static char buf[BUFLEN];

void readline(const char *prompt, char* buf)
{
  800df9:	55                   	push   %ebp
  800dfa:	89 e5                	mov    %esp,%ebp
  800dfc:	83 ec 18             	sub    $0x18,%esp
	int i, c, echoing;

	if (prompt != NULL)
  800dff:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800e03:	74 13                	je     800e18 <readline+0x1f>
		cprintf("%s", prompt);
  800e05:	83 ec 08             	sub    $0x8,%esp
  800e08:	ff 75 08             	pushl  0x8(%ebp)
  800e0b:	68 e8 29 80 00       	push   $0x8029e8
  800e10:	e8 0b f9 ff ff       	call   800720 <cprintf>
  800e15:	83 c4 10             	add    $0x10,%esp

	i = 0;
  800e18:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	echoing = iscons(0);
  800e1f:	83 ec 0c             	sub    $0xc,%esp
  800e22:	6a 00                	push   $0x0
  800e24:	e8 7e 10 00 00       	call   801ea7 <iscons>
  800e29:	83 c4 10             	add    $0x10,%esp
  800e2c:	89 45 f0             	mov    %eax,-0x10(%ebp)
	while (1) {
		c = getchar();
  800e2f:	e8 60 10 00 00       	call   801e94 <getchar>
  800e34:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if (c < 0) {
  800e37:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800e3b:	79 22                	jns    800e5f <readline+0x66>
			if (c != -E_EOF)
  800e3d:	83 7d ec 07          	cmpl   $0x7,-0x14(%ebp)
  800e41:	0f 84 ad 00 00 00    	je     800ef4 <readline+0xfb>
				cprintf("read error: %e\n", c);
  800e47:	83 ec 08             	sub    $0x8,%esp
  800e4a:	ff 75 ec             	pushl  -0x14(%ebp)
  800e4d:	68 eb 29 80 00       	push   $0x8029eb
  800e52:	e8 c9 f8 ff ff       	call   800720 <cprintf>
  800e57:	83 c4 10             	add    $0x10,%esp
			break;
  800e5a:	e9 95 00 00 00       	jmp    800ef4 <readline+0xfb>
		} else if (c >= ' ' && i < BUFLEN-1) {
  800e5f:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%ebp)
  800e63:	7e 34                	jle    800e99 <readline+0xa0>
  800e65:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  800e6c:	7f 2b                	jg     800e99 <readline+0xa0>
			if (echoing)
  800e6e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800e72:	74 0e                	je     800e82 <readline+0x89>
				cputchar(c);
  800e74:	83 ec 0c             	sub    $0xc,%esp
  800e77:	ff 75 ec             	pushl  -0x14(%ebp)
  800e7a:	e8 f6 0f 00 00       	call   801e75 <cputchar>
  800e7f:	83 c4 10             	add    $0x10,%esp
			buf[i++] = c;
  800e82:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800e85:	8d 50 01             	lea    0x1(%eax),%edx
  800e88:	89 55 f4             	mov    %edx,-0xc(%ebp)
  800e8b:	89 c2                	mov    %eax,%edx
  800e8d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e90:	01 d0                	add    %edx,%eax
  800e92:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800e95:	88 10                	mov    %dl,(%eax)
  800e97:	eb 56                	jmp    800eef <readline+0xf6>
		} else if (c == '\b' && i > 0) {
  800e99:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  800e9d:	75 1f                	jne    800ebe <readline+0xc5>
  800e9f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  800ea3:	7e 19                	jle    800ebe <readline+0xc5>
			if (echoing)
  800ea5:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800ea9:	74 0e                	je     800eb9 <readline+0xc0>
				cputchar(c);
  800eab:	83 ec 0c             	sub    $0xc,%esp
  800eae:	ff 75 ec             	pushl  -0x14(%ebp)
  800eb1:	e8 bf 0f 00 00       	call   801e75 <cputchar>
  800eb6:	83 c4 10             	add    $0x10,%esp

			i--;
  800eb9:	ff 4d f4             	decl   -0xc(%ebp)
  800ebc:	eb 31                	jmp    800eef <readline+0xf6>
		} else if (c == '\n' || c == '\r') {
  800ebe:	83 7d ec 0a          	cmpl   $0xa,-0x14(%ebp)
  800ec2:	74 0a                	je     800ece <readline+0xd5>
  800ec4:	83 7d ec 0d          	cmpl   $0xd,-0x14(%ebp)
  800ec8:	0f 85 61 ff ff ff    	jne    800e2f <readline+0x36>
			if (echoing)
  800ece:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800ed2:	74 0e                	je     800ee2 <readline+0xe9>
				cputchar(c);
  800ed4:	83 ec 0c             	sub    $0xc,%esp
  800ed7:	ff 75 ec             	pushl  -0x14(%ebp)
  800eda:	e8 96 0f 00 00       	call   801e75 <cputchar>
  800edf:	83 c4 10             	add    $0x10,%esp

			buf[i] = 0;
  800ee2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800ee5:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ee8:	01 d0                	add    %edx,%eax
  800eea:	c6 00 00             	movb   $0x0,(%eax)
			break;
  800eed:	eb 06                	jmp    800ef5 <readline+0xfc>
		}
	}
  800eef:	e9 3b ff ff ff       	jmp    800e2f <readline+0x36>
	while (1) {
		c = getchar();
		if (c < 0) {
			if (c != -E_EOF)
				cprintf("read error: %e\n", c);
			break;
  800ef4:	90                   	nop

			buf[i] = 0;
			break;
		}
	}
}
  800ef5:	90                   	nop
  800ef6:	c9                   	leave  
  800ef7:	c3                   	ret    

00800ef8 <atomic_readline>:

void atomic_readline(const char *prompt, char* buf)
{
  800ef8:	55                   	push   %ebp
  800ef9:	89 e5                	mov    %esp,%ebp
  800efb:	83 ec 18             	sub    $0x18,%esp
	sys_lock_cons();
  800efe:	e8 79 09 00 00       	call   80187c <sys_lock_cons>
	{
		int i, c, echoing;

		if (prompt != NULL)
  800f03:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800f07:	74 13                	je     800f1c <atomic_readline+0x24>
			cprintf("%s", prompt);
  800f09:	83 ec 08             	sub    $0x8,%esp
  800f0c:	ff 75 08             	pushl  0x8(%ebp)
  800f0f:	68 e8 29 80 00       	push   $0x8029e8
  800f14:	e8 07 f8 ff ff       	call   800720 <cprintf>
  800f19:	83 c4 10             	add    $0x10,%esp

		i = 0;
  800f1c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
		echoing = iscons(0);
  800f23:	83 ec 0c             	sub    $0xc,%esp
  800f26:	6a 00                	push   $0x0
  800f28:	e8 7a 0f 00 00       	call   801ea7 <iscons>
  800f2d:	83 c4 10             	add    $0x10,%esp
  800f30:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (1) {
			c = getchar();
  800f33:	e8 5c 0f 00 00       	call   801e94 <getchar>
  800f38:	89 45 ec             	mov    %eax,-0x14(%ebp)
			if (c < 0) {
  800f3b:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800f3f:	79 22                	jns    800f63 <atomic_readline+0x6b>
				if (c != -E_EOF)
  800f41:	83 7d ec 07          	cmpl   $0x7,-0x14(%ebp)
  800f45:	0f 84 ad 00 00 00    	je     800ff8 <atomic_readline+0x100>
					cprintf("read error: %e\n", c);
  800f4b:	83 ec 08             	sub    $0x8,%esp
  800f4e:	ff 75 ec             	pushl  -0x14(%ebp)
  800f51:	68 eb 29 80 00       	push   $0x8029eb
  800f56:	e8 c5 f7 ff ff       	call   800720 <cprintf>
  800f5b:	83 c4 10             	add    $0x10,%esp
				break;
  800f5e:	e9 95 00 00 00       	jmp    800ff8 <atomic_readline+0x100>
			} else if (c >= ' ' && i < BUFLEN-1) {
  800f63:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%ebp)
  800f67:	7e 34                	jle    800f9d <atomic_readline+0xa5>
  800f69:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  800f70:	7f 2b                	jg     800f9d <atomic_readline+0xa5>
				if (echoing)
  800f72:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800f76:	74 0e                	je     800f86 <atomic_readline+0x8e>
					cputchar(c);
  800f78:	83 ec 0c             	sub    $0xc,%esp
  800f7b:	ff 75 ec             	pushl  -0x14(%ebp)
  800f7e:	e8 f2 0e 00 00       	call   801e75 <cputchar>
  800f83:	83 c4 10             	add    $0x10,%esp
				buf[i++] = c;
  800f86:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800f89:	8d 50 01             	lea    0x1(%eax),%edx
  800f8c:	89 55 f4             	mov    %edx,-0xc(%ebp)
  800f8f:	89 c2                	mov    %eax,%edx
  800f91:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f94:	01 d0                	add    %edx,%eax
  800f96:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800f99:	88 10                	mov    %dl,(%eax)
  800f9b:	eb 56                	jmp    800ff3 <atomic_readline+0xfb>
			} else if (c == '\b' && i > 0) {
  800f9d:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  800fa1:	75 1f                	jne    800fc2 <atomic_readline+0xca>
  800fa3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  800fa7:	7e 19                	jle    800fc2 <atomic_readline+0xca>
				if (echoing)
  800fa9:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800fad:	74 0e                	je     800fbd <atomic_readline+0xc5>
					cputchar(c);
  800faf:	83 ec 0c             	sub    $0xc,%esp
  800fb2:	ff 75 ec             	pushl  -0x14(%ebp)
  800fb5:	e8 bb 0e 00 00       	call   801e75 <cputchar>
  800fba:	83 c4 10             	add    $0x10,%esp
				i--;
  800fbd:	ff 4d f4             	decl   -0xc(%ebp)
  800fc0:	eb 31                	jmp    800ff3 <atomic_readline+0xfb>
			} else if (c == '\n' || c == '\r') {
  800fc2:	83 7d ec 0a          	cmpl   $0xa,-0x14(%ebp)
  800fc6:	74 0a                	je     800fd2 <atomic_readline+0xda>
  800fc8:	83 7d ec 0d          	cmpl   $0xd,-0x14(%ebp)
  800fcc:	0f 85 61 ff ff ff    	jne    800f33 <atomic_readline+0x3b>
				if (echoing)
  800fd2:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800fd6:	74 0e                	je     800fe6 <atomic_readline+0xee>
					cputchar(c);
  800fd8:	83 ec 0c             	sub    $0xc,%esp
  800fdb:	ff 75 ec             	pushl  -0x14(%ebp)
  800fde:	e8 92 0e 00 00       	call   801e75 <cputchar>
  800fe3:	83 c4 10             	add    $0x10,%esp
				buf[i] = 0;
  800fe6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800fe9:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fec:	01 d0                	add    %edx,%eax
  800fee:	c6 00 00             	movb   $0x0,(%eax)
				break;
  800ff1:	eb 06                	jmp    800ff9 <atomic_readline+0x101>
			}
		}
  800ff3:	e9 3b ff ff ff       	jmp    800f33 <atomic_readline+0x3b>
		while (1) {
			c = getchar();
			if (c < 0) {
				if (c != -E_EOF)
					cprintf("read error: %e\n", c);
				break;
  800ff8:	90                   	nop
				buf[i] = 0;
				break;
			}
		}
	}
	sys_unlock_cons();
  800ff9:	e8 98 08 00 00       	call   801896 <sys_unlock_cons>
}
  800ffe:	90                   	nop
  800fff:	c9                   	leave  
  801000:	c3                   	ret    

00801001 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  801001:	55                   	push   %ebp
  801002:	89 e5                	mov    %esp,%ebp
  801004:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  801007:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80100e:	eb 06                	jmp    801016 <strlen+0x15>
		n++;
  801010:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  801013:	ff 45 08             	incl   0x8(%ebp)
  801016:	8b 45 08             	mov    0x8(%ebp),%eax
  801019:	8a 00                	mov    (%eax),%al
  80101b:	84 c0                	test   %al,%al
  80101d:	75 f1                	jne    801010 <strlen+0xf>
		n++;
	return n;
  80101f:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801022:	c9                   	leave  
  801023:	c3                   	ret    

00801024 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  801024:	55                   	push   %ebp
  801025:	89 e5                	mov    %esp,%ebp
  801027:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80102a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801031:	eb 09                	jmp    80103c <strnlen+0x18>
		n++;
  801033:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801036:	ff 45 08             	incl   0x8(%ebp)
  801039:	ff 4d 0c             	decl   0xc(%ebp)
  80103c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801040:	74 09                	je     80104b <strnlen+0x27>
  801042:	8b 45 08             	mov    0x8(%ebp),%eax
  801045:	8a 00                	mov    (%eax),%al
  801047:	84 c0                	test   %al,%al
  801049:	75 e8                	jne    801033 <strnlen+0xf>
		n++;
	return n;
  80104b:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  80104e:	c9                   	leave  
  80104f:	c3                   	ret    

00801050 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  801050:	55                   	push   %ebp
  801051:	89 e5                	mov    %esp,%ebp
  801053:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  801056:	8b 45 08             	mov    0x8(%ebp),%eax
  801059:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  80105c:	90                   	nop
  80105d:	8b 45 08             	mov    0x8(%ebp),%eax
  801060:	8d 50 01             	lea    0x1(%eax),%edx
  801063:	89 55 08             	mov    %edx,0x8(%ebp)
  801066:	8b 55 0c             	mov    0xc(%ebp),%edx
  801069:	8d 4a 01             	lea    0x1(%edx),%ecx
  80106c:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  80106f:	8a 12                	mov    (%edx),%dl
  801071:	88 10                	mov    %dl,(%eax)
  801073:	8a 00                	mov    (%eax),%al
  801075:	84 c0                	test   %al,%al
  801077:	75 e4                	jne    80105d <strcpy+0xd>
		/* do nothing */;
	return ret;
  801079:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  80107c:	c9                   	leave  
  80107d:	c3                   	ret    

0080107e <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  80107e:	55                   	push   %ebp
  80107f:	89 e5                	mov    %esp,%ebp
  801081:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  801084:	8b 45 08             	mov    0x8(%ebp),%eax
  801087:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  80108a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801091:	eb 1f                	jmp    8010b2 <strncpy+0x34>
		*dst++ = *src;
  801093:	8b 45 08             	mov    0x8(%ebp),%eax
  801096:	8d 50 01             	lea    0x1(%eax),%edx
  801099:	89 55 08             	mov    %edx,0x8(%ebp)
  80109c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80109f:	8a 12                	mov    (%edx),%dl
  8010a1:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  8010a3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010a6:	8a 00                	mov    (%eax),%al
  8010a8:	84 c0                	test   %al,%al
  8010aa:	74 03                	je     8010af <strncpy+0x31>
			src++;
  8010ac:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8010af:	ff 45 fc             	incl   -0x4(%ebp)
  8010b2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8010b5:	3b 45 10             	cmp    0x10(%ebp),%eax
  8010b8:	72 d9                	jb     801093 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  8010ba:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8010bd:	c9                   	leave  
  8010be:	c3                   	ret    

008010bf <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  8010bf:	55                   	push   %ebp
  8010c0:	89 e5                	mov    %esp,%ebp
  8010c2:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  8010c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8010c8:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  8010cb:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8010cf:	74 30                	je     801101 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  8010d1:	eb 16                	jmp    8010e9 <strlcpy+0x2a>
			*dst++ = *src++;
  8010d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8010d6:	8d 50 01             	lea    0x1(%eax),%edx
  8010d9:	89 55 08             	mov    %edx,0x8(%ebp)
  8010dc:	8b 55 0c             	mov    0xc(%ebp),%edx
  8010df:	8d 4a 01             	lea    0x1(%edx),%ecx
  8010e2:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  8010e5:	8a 12                	mov    (%edx),%dl
  8010e7:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  8010e9:	ff 4d 10             	decl   0x10(%ebp)
  8010ec:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8010f0:	74 09                	je     8010fb <strlcpy+0x3c>
  8010f2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010f5:	8a 00                	mov    (%eax),%al
  8010f7:	84 c0                	test   %al,%al
  8010f9:	75 d8                	jne    8010d3 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  8010fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8010fe:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  801101:	8b 55 08             	mov    0x8(%ebp),%edx
  801104:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801107:	29 c2                	sub    %eax,%edx
  801109:	89 d0                	mov    %edx,%eax
}
  80110b:	c9                   	leave  
  80110c:	c3                   	ret    

0080110d <strcmp>:

int
strcmp(const char *p, const char *q)
{
  80110d:	55                   	push   %ebp
  80110e:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  801110:	eb 06                	jmp    801118 <strcmp+0xb>
		p++, q++;
  801112:	ff 45 08             	incl   0x8(%ebp)
  801115:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  801118:	8b 45 08             	mov    0x8(%ebp),%eax
  80111b:	8a 00                	mov    (%eax),%al
  80111d:	84 c0                	test   %al,%al
  80111f:	74 0e                	je     80112f <strcmp+0x22>
  801121:	8b 45 08             	mov    0x8(%ebp),%eax
  801124:	8a 10                	mov    (%eax),%dl
  801126:	8b 45 0c             	mov    0xc(%ebp),%eax
  801129:	8a 00                	mov    (%eax),%al
  80112b:	38 c2                	cmp    %al,%dl
  80112d:	74 e3                	je     801112 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  80112f:	8b 45 08             	mov    0x8(%ebp),%eax
  801132:	8a 00                	mov    (%eax),%al
  801134:	0f b6 d0             	movzbl %al,%edx
  801137:	8b 45 0c             	mov    0xc(%ebp),%eax
  80113a:	8a 00                	mov    (%eax),%al
  80113c:	0f b6 c0             	movzbl %al,%eax
  80113f:	29 c2                	sub    %eax,%edx
  801141:	89 d0                	mov    %edx,%eax
}
  801143:	5d                   	pop    %ebp
  801144:	c3                   	ret    

00801145 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  801145:	55                   	push   %ebp
  801146:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  801148:	eb 09                	jmp    801153 <strncmp+0xe>
		n--, p++, q++;
  80114a:	ff 4d 10             	decl   0x10(%ebp)
  80114d:	ff 45 08             	incl   0x8(%ebp)
  801150:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  801153:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801157:	74 17                	je     801170 <strncmp+0x2b>
  801159:	8b 45 08             	mov    0x8(%ebp),%eax
  80115c:	8a 00                	mov    (%eax),%al
  80115e:	84 c0                	test   %al,%al
  801160:	74 0e                	je     801170 <strncmp+0x2b>
  801162:	8b 45 08             	mov    0x8(%ebp),%eax
  801165:	8a 10                	mov    (%eax),%dl
  801167:	8b 45 0c             	mov    0xc(%ebp),%eax
  80116a:	8a 00                	mov    (%eax),%al
  80116c:	38 c2                	cmp    %al,%dl
  80116e:	74 da                	je     80114a <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  801170:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801174:	75 07                	jne    80117d <strncmp+0x38>
		return 0;
  801176:	b8 00 00 00 00       	mov    $0x0,%eax
  80117b:	eb 14                	jmp    801191 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  80117d:	8b 45 08             	mov    0x8(%ebp),%eax
  801180:	8a 00                	mov    (%eax),%al
  801182:	0f b6 d0             	movzbl %al,%edx
  801185:	8b 45 0c             	mov    0xc(%ebp),%eax
  801188:	8a 00                	mov    (%eax),%al
  80118a:	0f b6 c0             	movzbl %al,%eax
  80118d:	29 c2                	sub    %eax,%edx
  80118f:	89 d0                	mov    %edx,%eax
}
  801191:	5d                   	pop    %ebp
  801192:	c3                   	ret    

00801193 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  801193:	55                   	push   %ebp
  801194:	89 e5                	mov    %esp,%ebp
  801196:	83 ec 04             	sub    $0x4,%esp
  801199:	8b 45 0c             	mov    0xc(%ebp),%eax
  80119c:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  80119f:	eb 12                	jmp    8011b3 <strchr+0x20>
		if (*s == c)
  8011a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8011a4:	8a 00                	mov    (%eax),%al
  8011a6:	3a 45 fc             	cmp    -0x4(%ebp),%al
  8011a9:	75 05                	jne    8011b0 <strchr+0x1d>
			return (char *) s;
  8011ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8011ae:	eb 11                	jmp    8011c1 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  8011b0:	ff 45 08             	incl   0x8(%ebp)
  8011b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8011b6:	8a 00                	mov    (%eax),%al
  8011b8:	84 c0                	test   %al,%al
  8011ba:	75 e5                	jne    8011a1 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  8011bc:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8011c1:	c9                   	leave  
  8011c2:	c3                   	ret    

008011c3 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8011c3:	55                   	push   %ebp
  8011c4:	89 e5                	mov    %esp,%ebp
  8011c6:	83 ec 04             	sub    $0x4,%esp
  8011c9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011cc:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  8011cf:	eb 0d                	jmp    8011de <strfind+0x1b>
		if (*s == c)
  8011d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8011d4:	8a 00                	mov    (%eax),%al
  8011d6:	3a 45 fc             	cmp    -0x4(%ebp),%al
  8011d9:	74 0e                	je     8011e9 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  8011db:	ff 45 08             	incl   0x8(%ebp)
  8011de:	8b 45 08             	mov    0x8(%ebp),%eax
  8011e1:	8a 00                	mov    (%eax),%al
  8011e3:	84 c0                	test   %al,%al
  8011e5:	75 ea                	jne    8011d1 <strfind+0xe>
  8011e7:	eb 01                	jmp    8011ea <strfind+0x27>
		if (*s == c)
			break;
  8011e9:	90                   	nop
	return (char *) s;
  8011ea:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8011ed:	c9                   	leave  
  8011ee:	c3                   	ret    

008011ef <memset>:

// *************** The faster implementation of memset & memcpy is implemented by *************
// ****************** Team80 (Yahia Khaled, Malek Ahmed et al) - FCIS'24-25 *******************
void *
memset(void *v, int c, uint32 n)
{
  8011ef:	55                   	push   %ebp
  8011f0:	89 e5                	mov    %esp,%ebp
  8011f2:	83 ec 10             	sub    $0x10,%esp
//	m = n;
//	while (--m >= 0)
//		*p++ = c;

	/*Faster Implementation*/
	uint64* p64 = (uint64*)v;
  8011f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8011f8:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if(n >= 8){
  8011fb:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  8011ff:	76 63                	jbe    801264 <memset+0x75>
		uint64 data_block = c;
  801201:	8b 45 0c             	mov    0xc(%ebp),%eax
  801204:	99                   	cltd   
  801205:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801208:	89 55 f4             	mov    %edx,-0xc(%ebp)
		data_block |= data_block << 8;
  80120b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80120e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801211:	0f a4 c2 08          	shld   $0x8,%eax,%edx
  801215:	c1 e0 08             	shl    $0x8,%eax
  801218:	09 45 f0             	or     %eax,-0x10(%ebp)
  80121b:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 16;
  80121e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801221:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801224:	0f a4 c2 10          	shld   $0x10,%eax,%edx
  801228:	c1 e0 10             	shl    $0x10,%eax
  80122b:	09 45 f0             	or     %eax,-0x10(%ebp)
  80122e:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 32;
  801231:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801234:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801237:	89 c2                	mov    %eax,%edx
  801239:	b8 00 00 00 00       	mov    $0x0,%eax
  80123e:	09 45 f0             	or     %eax,-0x10(%ebp)
  801241:	09 55 f4             	or     %edx,-0xc(%ebp)

		while(n >= 8)
  801244:	eb 18                	jmp    80125e <memset+0x6f>
			*p64++ = data_block, n -= 8;
  801246:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801249:	8d 41 08             	lea    0x8(%ecx),%eax
  80124c:	89 45 fc             	mov    %eax,-0x4(%ebp)
  80124f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801252:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801255:	89 01                	mov    %eax,(%ecx)
  801257:	89 51 04             	mov    %edx,0x4(%ecx)
  80125a:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
		uint64 data_block = c;
		data_block |= data_block << 8;
		data_block |= data_block << 16;
		data_block |= data_block << 32;

		while(n >= 8)
  80125e:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  801262:	77 e2                	ja     801246 <memset+0x57>
			*p64++ = data_block, n -= 8;
	}

	if(n){
  801264:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801268:	74 23                	je     80128d <memset+0x9e>
		uint8* p8 = (uint8*)p64;
  80126a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80126d:	89 45 f8             	mov    %eax,-0x8(%ebp)
		while (n-- > 0)
  801270:	eb 0e                	jmp    801280 <memset+0x91>
			*p8++ = (uint8)c;
  801272:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801275:	8d 50 01             	lea    0x1(%eax),%edx
  801278:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80127b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80127e:	88 10                	mov    %dl,(%eax)
			*p64++ = data_block, n -= 8;
	}

	if(n){
		uint8* p8 = (uint8*)p64;
		while (n-- > 0)
  801280:	8b 45 10             	mov    0x10(%ebp),%eax
  801283:	8d 50 ff             	lea    -0x1(%eax),%edx
  801286:	89 55 10             	mov    %edx,0x10(%ebp)
  801289:	85 c0                	test   %eax,%eax
  80128b:	75 e5                	jne    801272 <memset+0x83>
			*p8++ = (uint8)c;
	}

	return v;
  80128d:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801290:	c9                   	leave  
  801291:	c3                   	ret    

00801292 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  801292:	55                   	push   %ebp
  801293:	89 e5                	mov    %esp,%ebp
  801295:	83 ec 10             	sub    $0x10,%esp
	//	s = src;
	//	d = dst;
	//	while (n-- > 0)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
  801298:	8b 45 0c             	mov    0xc(%ebp),%eax
  80129b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	uint64* d64 = (uint64*)dst;
  80129e:	8b 45 08             	mov    0x8(%ebp),%eax
  8012a1:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if(n >= 8){
  8012a4:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  8012a8:	76 24                	jbe    8012ce <memcpy+0x3c>
		while(n >= 8){
  8012aa:	eb 1c                	jmp    8012c8 <memcpy+0x36>
			*d64 = *s64;
  8012ac:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8012af:	8b 50 04             	mov    0x4(%eax),%edx
  8012b2:	8b 00                	mov    (%eax),%eax
  8012b4:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8012b7:	89 01                	mov    %eax,(%ecx)
  8012b9:	89 51 04             	mov    %edx,0x4(%ecx)
			n -= 8;
  8012bc:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
			++s64;
  8012c0:	83 45 fc 08          	addl   $0x8,-0x4(%ebp)
			++d64;
  8012c4:	83 45 f8 08          	addl   $0x8,-0x8(%ebp)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
	uint64* d64 = (uint64*)dst;
	if(n >= 8){
		while(n >= 8){
  8012c8:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  8012cc:	77 de                	ja     8012ac <memcpy+0x1a>
			++s64;
			++d64;
		}
	}

	if(n){
  8012ce:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8012d2:	74 31                	je     801305 <memcpy+0x73>
		uint8* s8 = (uint8*)s64;
  8012d4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8012d7:	89 45 f4             	mov    %eax,-0xc(%ebp)
		uint8* d8 = (uint8*)d64;
  8012da:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8012dd:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (n-- > 0)
  8012e0:	eb 16                	jmp    8012f8 <memcpy+0x66>
			*d8++ = *s8++;
  8012e2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8012e5:	8d 50 01             	lea    0x1(%eax),%edx
  8012e8:	89 55 f0             	mov    %edx,-0x10(%ebp)
  8012eb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8012ee:	8d 4a 01             	lea    0x1(%edx),%ecx
  8012f1:	89 4d f4             	mov    %ecx,-0xc(%ebp)
  8012f4:	8a 12                	mov    (%edx),%dl
  8012f6:	88 10                	mov    %dl,(%eax)
	}

	if(n){
		uint8* s8 = (uint8*)s64;
		uint8* d8 = (uint8*)d64;
		while (n-- > 0)
  8012f8:	8b 45 10             	mov    0x10(%ebp),%eax
  8012fb:	8d 50 ff             	lea    -0x1(%eax),%edx
  8012fe:	89 55 10             	mov    %edx,0x10(%ebp)
  801301:	85 c0                	test   %eax,%eax
  801303:	75 dd                	jne    8012e2 <memcpy+0x50>
			*d8++ = *s8++;
	}
	return dst;
  801305:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801308:	c9                   	leave  
  801309:	c3                   	ret    

0080130a <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  80130a:	55                   	push   %ebp
  80130b:	89 e5                	mov    %esp,%ebp
  80130d:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801310:	8b 45 0c             	mov    0xc(%ebp),%eax
  801313:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801316:	8b 45 08             	mov    0x8(%ebp),%eax
  801319:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  80131c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80131f:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801322:	73 50                	jae    801374 <memmove+0x6a>
  801324:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801327:	8b 45 10             	mov    0x10(%ebp),%eax
  80132a:	01 d0                	add    %edx,%eax
  80132c:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  80132f:	76 43                	jbe    801374 <memmove+0x6a>
		s += n;
  801331:	8b 45 10             	mov    0x10(%ebp),%eax
  801334:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  801337:	8b 45 10             	mov    0x10(%ebp),%eax
  80133a:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  80133d:	eb 10                	jmp    80134f <memmove+0x45>
			*--d = *--s;
  80133f:	ff 4d f8             	decl   -0x8(%ebp)
  801342:	ff 4d fc             	decl   -0x4(%ebp)
  801345:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801348:	8a 10                	mov    (%eax),%dl
  80134a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80134d:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  80134f:	8b 45 10             	mov    0x10(%ebp),%eax
  801352:	8d 50 ff             	lea    -0x1(%eax),%edx
  801355:	89 55 10             	mov    %edx,0x10(%ebp)
  801358:	85 c0                	test   %eax,%eax
  80135a:	75 e3                	jne    80133f <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  80135c:	eb 23                	jmp    801381 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  80135e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801361:	8d 50 01             	lea    0x1(%eax),%edx
  801364:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801367:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80136a:	8d 4a 01             	lea    0x1(%edx),%ecx
  80136d:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801370:	8a 12                	mov    (%edx),%dl
  801372:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  801374:	8b 45 10             	mov    0x10(%ebp),%eax
  801377:	8d 50 ff             	lea    -0x1(%eax),%edx
  80137a:	89 55 10             	mov    %edx,0x10(%ebp)
  80137d:	85 c0                	test   %eax,%eax
  80137f:	75 dd                	jne    80135e <memmove+0x54>
			*d++ = *s++;

	return dst;
  801381:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801384:	c9                   	leave  
  801385:	c3                   	ret    

00801386 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  801386:	55                   	push   %ebp
  801387:	89 e5                	mov    %esp,%ebp
  801389:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  80138c:	8b 45 08             	mov    0x8(%ebp),%eax
  80138f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  801392:	8b 45 0c             	mov    0xc(%ebp),%eax
  801395:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  801398:	eb 2a                	jmp    8013c4 <memcmp+0x3e>
		if (*s1 != *s2)
  80139a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80139d:	8a 10                	mov    (%eax),%dl
  80139f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8013a2:	8a 00                	mov    (%eax),%al
  8013a4:	38 c2                	cmp    %al,%dl
  8013a6:	74 16                	je     8013be <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  8013a8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8013ab:	8a 00                	mov    (%eax),%al
  8013ad:	0f b6 d0             	movzbl %al,%edx
  8013b0:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8013b3:	8a 00                	mov    (%eax),%al
  8013b5:	0f b6 c0             	movzbl %al,%eax
  8013b8:	29 c2                	sub    %eax,%edx
  8013ba:	89 d0                	mov    %edx,%eax
  8013bc:	eb 18                	jmp    8013d6 <memcmp+0x50>
		s1++, s2++;
  8013be:	ff 45 fc             	incl   -0x4(%ebp)
  8013c1:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  8013c4:	8b 45 10             	mov    0x10(%ebp),%eax
  8013c7:	8d 50 ff             	lea    -0x1(%eax),%edx
  8013ca:	89 55 10             	mov    %edx,0x10(%ebp)
  8013cd:	85 c0                	test   %eax,%eax
  8013cf:	75 c9                	jne    80139a <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  8013d1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8013d6:	c9                   	leave  
  8013d7:	c3                   	ret    

008013d8 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  8013d8:	55                   	push   %ebp
  8013d9:	89 e5                	mov    %esp,%ebp
  8013db:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  8013de:	8b 55 08             	mov    0x8(%ebp),%edx
  8013e1:	8b 45 10             	mov    0x10(%ebp),%eax
  8013e4:	01 d0                	add    %edx,%eax
  8013e6:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  8013e9:	eb 15                	jmp    801400 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  8013eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8013ee:	8a 00                	mov    (%eax),%al
  8013f0:	0f b6 d0             	movzbl %al,%edx
  8013f3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013f6:	0f b6 c0             	movzbl %al,%eax
  8013f9:	39 c2                	cmp    %eax,%edx
  8013fb:	74 0d                	je     80140a <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  8013fd:	ff 45 08             	incl   0x8(%ebp)
  801400:	8b 45 08             	mov    0x8(%ebp),%eax
  801403:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801406:	72 e3                	jb     8013eb <memfind+0x13>
  801408:	eb 01                	jmp    80140b <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  80140a:	90                   	nop
	return (void *) s;
  80140b:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80140e:	c9                   	leave  
  80140f:	c3                   	ret    

00801410 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801410:	55                   	push   %ebp
  801411:	89 e5                	mov    %esp,%ebp
  801413:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  801416:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  80141d:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801424:	eb 03                	jmp    801429 <strtol+0x19>
		s++;
  801426:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801429:	8b 45 08             	mov    0x8(%ebp),%eax
  80142c:	8a 00                	mov    (%eax),%al
  80142e:	3c 20                	cmp    $0x20,%al
  801430:	74 f4                	je     801426 <strtol+0x16>
  801432:	8b 45 08             	mov    0x8(%ebp),%eax
  801435:	8a 00                	mov    (%eax),%al
  801437:	3c 09                	cmp    $0x9,%al
  801439:	74 eb                	je     801426 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  80143b:	8b 45 08             	mov    0x8(%ebp),%eax
  80143e:	8a 00                	mov    (%eax),%al
  801440:	3c 2b                	cmp    $0x2b,%al
  801442:	75 05                	jne    801449 <strtol+0x39>
		s++;
  801444:	ff 45 08             	incl   0x8(%ebp)
  801447:	eb 13                	jmp    80145c <strtol+0x4c>
	else if (*s == '-')
  801449:	8b 45 08             	mov    0x8(%ebp),%eax
  80144c:	8a 00                	mov    (%eax),%al
  80144e:	3c 2d                	cmp    $0x2d,%al
  801450:	75 0a                	jne    80145c <strtol+0x4c>
		s++, neg = 1;
  801452:	ff 45 08             	incl   0x8(%ebp)
  801455:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  80145c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801460:	74 06                	je     801468 <strtol+0x58>
  801462:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  801466:	75 20                	jne    801488 <strtol+0x78>
  801468:	8b 45 08             	mov    0x8(%ebp),%eax
  80146b:	8a 00                	mov    (%eax),%al
  80146d:	3c 30                	cmp    $0x30,%al
  80146f:	75 17                	jne    801488 <strtol+0x78>
  801471:	8b 45 08             	mov    0x8(%ebp),%eax
  801474:	40                   	inc    %eax
  801475:	8a 00                	mov    (%eax),%al
  801477:	3c 78                	cmp    $0x78,%al
  801479:	75 0d                	jne    801488 <strtol+0x78>
		s += 2, base = 16;
  80147b:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  80147f:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  801486:	eb 28                	jmp    8014b0 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  801488:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80148c:	75 15                	jne    8014a3 <strtol+0x93>
  80148e:	8b 45 08             	mov    0x8(%ebp),%eax
  801491:	8a 00                	mov    (%eax),%al
  801493:	3c 30                	cmp    $0x30,%al
  801495:	75 0c                	jne    8014a3 <strtol+0x93>
		s++, base = 8;
  801497:	ff 45 08             	incl   0x8(%ebp)
  80149a:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  8014a1:	eb 0d                	jmp    8014b0 <strtol+0xa0>
	else if (base == 0)
  8014a3:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8014a7:	75 07                	jne    8014b0 <strtol+0xa0>
		base = 10;
  8014a9:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8014b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8014b3:	8a 00                	mov    (%eax),%al
  8014b5:	3c 2f                	cmp    $0x2f,%al
  8014b7:	7e 19                	jle    8014d2 <strtol+0xc2>
  8014b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8014bc:	8a 00                	mov    (%eax),%al
  8014be:	3c 39                	cmp    $0x39,%al
  8014c0:	7f 10                	jg     8014d2 <strtol+0xc2>
			dig = *s - '0';
  8014c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8014c5:	8a 00                	mov    (%eax),%al
  8014c7:	0f be c0             	movsbl %al,%eax
  8014ca:	83 e8 30             	sub    $0x30,%eax
  8014cd:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8014d0:	eb 42                	jmp    801514 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  8014d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8014d5:	8a 00                	mov    (%eax),%al
  8014d7:	3c 60                	cmp    $0x60,%al
  8014d9:	7e 19                	jle    8014f4 <strtol+0xe4>
  8014db:	8b 45 08             	mov    0x8(%ebp),%eax
  8014de:	8a 00                	mov    (%eax),%al
  8014e0:	3c 7a                	cmp    $0x7a,%al
  8014e2:	7f 10                	jg     8014f4 <strtol+0xe4>
			dig = *s - 'a' + 10;
  8014e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8014e7:	8a 00                	mov    (%eax),%al
  8014e9:	0f be c0             	movsbl %al,%eax
  8014ec:	83 e8 57             	sub    $0x57,%eax
  8014ef:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8014f2:	eb 20                	jmp    801514 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  8014f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8014f7:	8a 00                	mov    (%eax),%al
  8014f9:	3c 40                	cmp    $0x40,%al
  8014fb:	7e 39                	jle    801536 <strtol+0x126>
  8014fd:	8b 45 08             	mov    0x8(%ebp),%eax
  801500:	8a 00                	mov    (%eax),%al
  801502:	3c 5a                	cmp    $0x5a,%al
  801504:	7f 30                	jg     801536 <strtol+0x126>
			dig = *s - 'A' + 10;
  801506:	8b 45 08             	mov    0x8(%ebp),%eax
  801509:	8a 00                	mov    (%eax),%al
  80150b:	0f be c0             	movsbl %al,%eax
  80150e:	83 e8 37             	sub    $0x37,%eax
  801511:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  801514:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801517:	3b 45 10             	cmp    0x10(%ebp),%eax
  80151a:	7d 19                	jge    801535 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  80151c:	ff 45 08             	incl   0x8(%ebp)
  80151f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801522:	0f af 45 10          	imul   0x10(%ebp),%eax
  801526:	89 c2                	mov    %eax,%edx
  801528:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80152b:	01 d0                	add    %edx,%eax
  80152d:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  801530:	e9 7b ff ff ff       	jmp    8014b0 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801535:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801536:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80153a:	74 08                	je     801544 <strtol+0x134>
		*endptr = (char *) s;
  80153c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80153f:	8b 55 08             	mov    0x8(%ebp),%edx
  801542:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  801544:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801548:	74 07                	je     801551 <strtol+0x141>
  80154a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80154d:	f7 d8                	neg    %eax
  80154f:	eb 03                	jmp    801554 <strtol+0x144>
  801551:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801554:	c9                   	leave  
  801555:	c3                   	ret    

00801556 <ltostr>:

void
ltostr(long value, char *str)
{
  801556:	55                   	push   %ebp
  801557:	89 e5                	mov    %esp,%ebp
  801559:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  80155c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  801563:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  80156a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80156e:	79 13                	jns    801583 <ltostr+0x2d>
	{
		neg = 1;
  801570:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  801577:	8b 45 0c             	mov    0xc(%ebp),%eax
  80157a:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  80157d:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  801580:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  801583:	8b 45 08             	mov    0x8(%ebp),%eax
  801586:	b9 0a 00 00 00       	mov    $0xa,%ecx
  80158b:	99                   	cltd   
  80158c:	f7 f9                	idiv   %ecx
  80158e:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  801591:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801594:	8d 50 01             	lea    0x1(%eax),%edx
  801597:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80159a:	89 c2                	mov    %eax,%edx
  80159c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80159f:	01 d0                	add    %edx,%eax
  8015a1:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8015a4:	83 c2 30             	add    $0x30,%edx
  8015a7:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  8015a9:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8015ac:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8015b1:	f7 e9                	imul   %ecx
  8015b3:	c1 fa 02             	sar    $0x2,%edx
  8015b6:	89 c8                	mov    %ecx,%eax
  8015b8:	c1 f8 1f             	sar    $0x1f,%eax
  8015bb:	29 c2                	sub    %eax,%edx
  8015bd:	89 d0                	mov    %edx,%eax
  8015bf:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  8015c2:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8015c6:	75 bb                	jne    801583 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  8015c8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  8015cf:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8015d2:	48                   	dec    %eax
  8015d3:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  8015d6:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8015da:	74 3d                	je     801619 <ltostr+0xc3>
		start = 1 ;
  8015dc:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  8015e3:	eb 34                	jmp    801619 <ltostr+0xc3>
	{
		char tmp = str[start] ;
  8015e5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8015e8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015eb:	01 d0                	add    %edx,%eax
  8015ed:	8a 00                	mov    (%eax),%al
  8015ef:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  8015f2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8015f5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015f8:	01 c2                	add    %eax,%edx
  8015fa:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  8015fd:	8b 45 0c             	mov    0xc(%ebp),%eax
  801600:	01 c8                	add    %ecx,%eax
  801602:	8a 00                	mov    (%eax),%al
  801604:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801606:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801609:	8b 45 0c             	mov    0xc(%ebp),%eax
  80160c:	01 c2                	add    %eax,%edx
  80160e:	8a 45 eb             	mov    -0x15(%ebp),%al
  801611:	88 02                	mov    %al,(%edx)
		start++ ;
  801613:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801616:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801619:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80161c:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80161f:	7c c4                	jl     8015e5 <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801621:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801624:	8b 45 0c             	mov    0xc(%ebp),%eax
  801627:	01 d0                	add    %edx,%eax
  801629:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  80162c:	90                   	nop
  80162d:	c9                   	leave  
  80162e:	c3                   	ret    

0080162f <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  80162f:	55                   	push   %ebp
  801630:	89 e5                	mov    %esp,%ebp
  801632:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801635:	ff 75 08             	pushl  0x8(%ebp)
  801638:	e8 c4 f9 ff ff       	call   801001 <strlen>
  80163d:	83 c4 04             	add    $0x4,%esp
  801640:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  801643:	ff 75 0c             	pushl  0xc(%ebp)
  801646:	e8 b6 f9 ff ff       	call   801001 <strlen>
  80164b:	83 c4 04             	add    $0x4,%esp
  80164e:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  801651:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  801658:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80165f:	eb 17                	jmp    801678 <strcconcat+0x49>
		final[s] = str1[s] ;
  801661:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801664:	8b 45 10             	mov    0x10(%ebp),%eax
  801667:	01 c2                	add    %eax,%edx
  801669:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  80166c:	8b 45 08             	mov    0x8(%ebp),%eax
  80166f:	01 c8                	add    %ecx,%eax
  801671:	8a 00                	mov    (%eax),%al
  801673:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  801675:	ff 45 fc             	incl   -0x4(%ebp)
  801678:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80167b:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  80167e:	7c e1                	jl     801661 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  801680:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  801687:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  80168e:	eb 1f                	jmp    8016af <strcconcat+0x80>
		final[s++] = str2[i] ;
  801690:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801693:	8d 50 01             	lea    0x1(%eax),%edx
  801696:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801699:	89 c2                	mov    %eax,%edx
  80169b:	8b 45 10             	mov    0x10(%ebp),%eax
  80169e:	01 c2                	add    %eax,%edx
  8016a0:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8016a3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016a6:	01 c8                	add    %ecx,%eax
  8016a8:	8a 00                	mov    (%eax),%al
  8016aa:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  8016ac:	ff 45 f8             	incl   -0x8(%ebp)
  8016af:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8016b2:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8016b5:	7c d9                	jl     801690 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  8016b7:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8016ba:	8b 45 10             	mov    0x10(%ebp),%eax
  8016bd:	01 d0                	add    %edx,%eax
  8016bf:	c6 00 00             	movb   $0x0,(%eax)
}
  8016c2:	90                   	nop
  8016c3:	c9                   	leave  
  8016c4:	c3                   	ret    

008016c5 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  8016c5:	55                   	push   %ebp
  8016c6:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  8016c8:	8b 45 14             	mov    0x14(%ebp),%eax
  8016cb:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  8016d1:	8b 45 14             	mov    0x14(%ebp),%eax
  8016d4:	8b 00                	mov    (%eax),%eax
  8016d6:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8016dd:	8b 45 10             	mov    0x10(%ebp),%eax
  8016e0:	01 d0                	add    %edx,%eax
  8016e2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8016e8:	eb 0c                	jmp    8016f6 <strsplit+0x31>
			*string++ = 0;
  8016ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8016ed:	8d 50 01             	lea    0x1(%eax),%edx
  8016f0:	89 55 08             	mov    %edx,0x8(%ebp)
  8016f3:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8016f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8016f9:	8a 00                	mov    (%eax),%al
  8016fb:	84 c0                	test   %al,%al
  8016fd:	74 18                	je     801717 <strsplit+0x52>
  8016ff:	8b 45 08             	mov    0x8(%ebp),%eax
  801702:	8a 00                	mov    (%eax),%al
  801704:	0f be c0             	movsbl %al,%eax
  801707:	50                   	push   %eax
  801708:	ff 75 0c             	pushl  0xc(%ebp)
  80170b:	e8 83 fa ff ff       	call   801193 <strchr>
  801710:	83 c4 08             	add    $0x8,%esp
  801713:	85 c0                	test   %eax,%eax
  801715:	75 d3                	jne    8016ea <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801717:	8b 45 08             	mov    0x8(%ebp),%eax
  80171a:	8a 00                	mov    (%eax),%al
  80171c:	84 c0                	test   %al,%al
  80171e:	74 5a                	je     80177a <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801720:	8b 45 14             	mov    0x14(%ebp),%eax
  801723:	8b 00                	mov    (%eax),%eax
  801725:	83 f8 0f             	cmp    $0xf,%eax
  801728:	75 07                	jne    801731 <strsplit+0x6c>
		{
			return 0;
  80172a:	b8 00 00 00 00       	mov    $0x0,%eax
  80172f:	eb 66                	jmp    801797 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801731:	8b 45 14             	mov    0x14(%ebp),%eax
  801734:	8b 00                	mov    (%eax),%eax
  801736:	8d 48 01             	lea    0x1(%eax),%ecx
  801739:	8b 55 14             	mov    0x14(%ebp),%edx
  80173c:	89 0a                	mov    %ecx,(%edx)
  80173e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801745:	8b 45 10             	mov    0x10(%ebp),%eax
  801748:	01 c2                	add    %eax,%edx
  80174a:	8b 45 08             	mov    0x8(%ebp),%eax
  80174d:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  80174f:	eb 03                	jmp    801754 <strsplit+0x8f>
			string++;
  801751:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801754:	8b 45 08             	mov    0x8(%ebp),%eax
  801757:	8a 00                	mov    (%eax),%al
  801759:	84 c0                	test   %al,%al
  80175b:	74 8b                	je     8016e8 <strsplit+0x23>
  80175d:	8b 45 08             	mov    0x8(%ebp),%eax
  801760:	8a 00                	mov    (%eax),%al
  801762:	0f be c0             	movsbl %al,%eax
  801765:	50                   	push   %eax
  801766:	ff 75 0c             	pushl  0xc(%ebp)
  801769:	e8 25 fa ff ff       	call   801193 <strchr>
  80176e:	83 c4 08             	add    $0x8,%esp
  801771:	85 c0                	test   %eax,%eax
  801773:	74 dc                	je     801751 <strsplit+0x8c>
			string++;
	}
  801775:	e9 6e ff ff ff       	jmp    8016e8 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  80177a:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  80177b:	8b 45 14             	mov    0x14(%ebp),%eax
  80177e:	8b 00                	mov    (%eax),%eax
  801780:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801787:	8b 45 10             	mov    0x10(%ebp),%eax
  80178a:	01 d0                	add    %edx,%eax
  80178c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801792:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801797:	c9                   	leave  
  801798:	c3                   	ret    

00801799 <str2lower>:


char* str2lower(char *dst, const char *src)
{
  801799:	55                   	push   %ebp
  80179a:	89 e5                	mov    %esp,%ebp
  80179c:	83 ec 10             	sub    $0x10,%esp
	char* ret = dst;
  80179f:	8b 45 08             	mov    0x8(%ebp),%eax
  8017a2:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (int i = 0; i < strlen(src); ++i)
  8017a5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8017ac:	eb 4a                	jmp    8017f8 <str2lower+0x5f>
	{
		dst[i] = src[i] ;
  8017ae:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8017b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8017b4:	01 c2                	add    %eax,%edx
  8017b6:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8017b9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017bc:	01 c8                	add    %ecx,%eax
  8017be:	8a 00                	mov    (%eax),%al
  8017c0:	88 02                	mov    %al,(%edx)
		if (src[i] >= 'A' && src[i] <= 'Z')
  8017c2:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8017c5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017c8:	01 d0                	add    %edx,%eax
  8017ca:	8a 00                	mov    (%eax),%al
  8017cc:	3c 40                	cmp    $0x40,%al
  8017ce:	7e 25                	jle    8017f5 <str2lower+0x5c>
  8017d0:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8017d3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017d6:	01 d0                	add    %edx,%eax
  8017d8:	8a 00                	mov    (%eax),%al
  8017da:	3c 5a                	cmp    $0x5a,%al
  8017dc:	7f 17                	jg     8017f5 <str2lower+0x5c>
		{
			dst[i] += 32 ;
  8017de:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8017e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8017e4:	01 d0                	add    %edx,%eax
  8017e6:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8017e9:	8b 55 08             	mov    0x8(%ebp),%edx
  8017ec:	01 ca                	add    %ecx,%edx
  8017ee:	8a 12                	mov    (%edx),%dl
  8017f0:	83 c2 20             	add    $0x20,%edx
  8017f3:	88 10                	mov    %dl,(%eax)


char* str2lower(char *dst, const char *src)
{
	char* ret = dst;
	for (int i = 0; i < strlen(src); ++i)
  8017f5:	ff 45 fc             	incl   -0x4(%ebp)
  8017f8:	ff 75 0c             	pushl  0xc(%ebp)
  8017fb:	e8 01 f8 ff ff       	call   801001 <strlen>
  801800:	83 c4 04             	add    $0x4,%esp
  801803:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801806:	7f a6                	jg     8017ae <str2lower+0x15>
		if (src[i] >= 'A' && src[i] <= 'Z')
		{
			dst[i] += 32 ;
		}
	}
	return ret;
  801808:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  80180b:	c9                   	leave  
  80180c:	c3                   	ret    

0080180d <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  80180d:	55                   	push   %ebp
  80180e:	89 e5                	mov    %esp,%ebp
  801810:	57                   	push   %edi
  801811:	56                   	push   %esi
  801812:	53                   	push   %ebx
  801813:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801816:	8b 45 08             	mov    0x8(%ebp),%eax
  801819:	8b 55 0c             	mov    0xc(%ebp),%edx
  80181c:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80181f:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801822:	8b 7d 18             	mov    0x18(%ebp),%edi
  801825:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801828:	cd 30                	int    $0x30
  80182a:	89 45 f0             	mov    %eax,-0x10(%ebp)
				"b" (a3),
				"D" (a4),
				"S" (a5)
				: "cc", "memory");

	return ret;
  80182d:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801830:	83 c4 10             	add    $0x10,%esp
  801833:	5b                   	pop    %ebx
  801834:	5e                   	pop    %esi
  801835:	5f                   	pop    %edi
  801836:	5d                   	pop    %ebp
  801837:	c3                   	ret    

00801838 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName, int color)
{
  801838:	55                   	push   %ebp
  801839:	89 e5                	mov    %esp,%ebp
  80183b:	83 ec 04             	sub    $0x4,%esp
  80183e:	8b 45 10             	mov    0x10(%ebp),%eax
  801841:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, color, 0);
  801844:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801847:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80184b:	8b 45 08             	mov    0x8(%ebp),%eax
  80184e:	6a 00                	push   $0x0
  801850:	51                   	push   %ecx
  801851:	52                   	push   %edx
  801852:	ff 75 0c             	pushl  0xc(%ebp)
  801855:	50                   	push   %eax
  801856:	6a 00                	push   $0x0
  801858:	e8 b0 ff ff ff       	call   80180d <syscall>
  80185d:	83 c4 18             	add    $0x18,%esp
}
  801860:	90                   	nop
  801861:	c9                   	leave  
  801862:	c3                   	ret    

00801863 <sys_cgetc>:

int
sys_cgetc(void)
{
  801863:	55                   	push   %ebp
  801864:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801866:	6a 00                	push   $0x0
  801868:	6a 00                	push   $0x0
  80186a:	6a 00                	push   $0x0
  80186c:	6a 00                	push   $0x0
  80186e:	6a 00                	push   $0x0
  801870:	6a 02                	push   $0x2
  801872:	e8 96 ff ff ff       	call   80180d <syscall>
  801877:	83 c4 18             	add    $0x18,%esp
}
  80187a:	c9                   	leave  
  80187b:	c3                   	ret    

0080187c <sys_lock_cons>:

void sys_lock_cons(void)
{
  80187c:	55                   	push   %ebp
  80187d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  80187f:	6a 00                	push   $0x0
  801881:	6a 00                	push   $0x0
  801883:	6a 00                	push   $0x0
  801885:	6a 00                	push   $0x0
  801887:	6a 00                	push   $0x0
  801889:	6a 03                	push   $0x3
  80188b:	e8 7d ff ff ff       	call   80180d <syscall>
  801890:	83 c4 18             	add    $0x18,%esp
}
  801893:	90                   	nop
  801894:	c9                   	leave  
  801895:	c3                   	ret    

00801896 <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  801896:	55                   	push   %ebp
  801897:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  801899:	6a 00                	push   $0x0
  80189b:	6a 00                	push   $0x0
  80189d:	6a 00                	push   $0x0
  80189f:	6a 00                	push   $0x0
  8018a1:	6a 00                	push   $0x0
  8018a3:	6a 04                	push   $0x4
  8018a5:	e8 63 ff ff ff       	call   80180d <syscall>
  8018aa:	83 c4 18             	add    $0x18,%esp
}
  8018ad:	90                   	nop
  8018ae:	c9                   	leave  
  8018af:	c3                   	ret    

008018b0 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  8018b0:	55                   	push   %ebp
  8018b1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  8018b3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8018b9:	6a 00                	push   $0x0
  8018bb:	6a 00                	push   $0x0
  8018bd:	6a 00                	push   $0x0
  8018bf:	52                   	push   %edx
  8018c0:	50                   	push   %eax
  8018c1:	6a 08                	push   $0x8
  8018c3:	e8 45 ff ff ff       	call   80180d <syscall>
  8018c8:	83 c4 18             	add    $0x18,%esp
}
  8018cb:	c9                   	leave  
  8018cc:	c3                   	ret    

008018cd <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  8018cd:	55                   	push   %ebp
  8018ce:	89 e5                	mov    %esp,%ebp
  8018d0:	56                   	push   %esi
  8018d1:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  8018d2:	8b 75 18             	mov    0x18(%ebp),%esi
  8018d5:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8018d8:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8018db:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018de:	8b 45 08             	mov    0x8(%ebp),%eax
  8018e1:	56                   	push   %esi
  8018e2:	53                   	push   %ebx
  8018e3:	51                   	push   %ecx
  8018e4:	52                   	push   %edx
  8018e5:	50                   	push   %eax
  8018e6:	6a 09                	push   $0x9
  8018e8:	e8 20 ff ff ff       	call   80180d <syscall>
  8018ed:	83 c4 18             	add    $0x18,%esp
}
  8018f0:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8018f3:	5b                   	pop    %ebx
  8018f4:	5e                   	pop    %esi
  8018f5:	5d                   	pop    %ebp
  8018f6:	c3                   	ret    

008018f7 <__sys_unmap_frame>:

int __sys_unmap_frame(uint32 va)
{
  8018f7:	55                   	push   %ebp
  8018f8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, va, 0, 0, 0, 0);
  8018fa:	6a 00                	push   $0x0
  8018fc:	6a 00                	push   $0x0
  8018fe:	6a 00                	push   $0x0
  801900:	6a 00                	push   $0x0
  801902:	ff 75 08             	pushl  0x8(%ebp)
  801905:	6a 0a                	push   $0xa
  801907:	e8 01 ff ff ff       	call   80180d <syscall>
  80190c:	83 c4 18             	add    $0x18,%esp
}
  80190f:	c9                   	leave  
  801910:	c3                   	ret    

00801911 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801911:	55                   	push   %ebp
  801912:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801914:	6a 00                	push   $0x0
  801916:	6a 00                	push   $0x0
  801918:	6a 00                	push   $0x0
  80191a:	ff 75 0c             	pushl  0xc(%ebp)
  80191d:	ff 75 08             	pushl  0x8(%ebp)
  801920:	6a 0b                	push   $0xb
  801922:	e8 e6 fe ff ff       	call   80180d <syscall>
  801927:	83 c4 18             	add    $0x18,%esp
}
  80192a:	c9                   	leave  
  80192b:	c3                   	ret    

0080192c <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  80192c:	55                   	push   %ebp
  80192d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  80192f:	6a 00                	push   $0x0
  801931:	6a 00                	push   $0x0
  801933:	6a 00                	push   $0x0
  801935:	6a 00                	push   $0x0
  801937:	6a 00                	push   $0x0
  801939:	6a 0c                	push   $0xc
  80193b:	e8 cd fe ff ff       	call   80180d <syscall>
  801940:	83 c4 18             	add    $0x18,%esp
}
  801943:	c9                   	leave  
  801944:	c3                   	ret    

00801945 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801945:	55                   	push   %ebp
  801946:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801948:	6a 00                	push   $0x0
  80194a:	6a 00                	push   $0x0
  80194c:	6a 00                	push   $0x0
  80194e:	6a 00                	push   $0x0
  801950:	6a 00                	push   $0x0
  801952:	6a 0d                	push   $0xd
  801954:	e8 b4 fe ff ff       	call   80180d <syscall>
  801959:	83 c4 18             	add    $0x18,%esp
}
  80195c:	c9                   	leave  
  80195d:	c3                   	ret    

0080195e <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  80195e:	55                   	push   %ebp
  80195f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801961:	6a 00                	push   $0x0
  801963:	6a 00                	push   $0x0
  801965:	6a 00                	push   $0x0
  801967:	6a 00                	push   $0x0
  801969:	6a 00                	push   $0x0
  80196b:	6a 0e                	push   $0xe
  80196d:	e8 9b fe ff ff       	call   80180d <syscall>
  801972:	83 c4 18             	add    $0x18,%esp
}
  801975:	c9                   	leave  
  801976:	c3                   	ret    

00801977 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801977:	55                   	push   %ebp
  801978:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  80197a:	6a 00                	push   $0x0
  80197c:	6a 00                	push   $0x0
  80197e:	6a 00                	push   $0x0
  801980:	6a 00                	push   $0x0
  801982:	6a 00                	push   $0x0
  801984:	6a 0f                	push   $0xf
  801986:	e8 82 fe ff ff       	call   80180d <syscall>
  80198b:	83 c4 18             	add    $0x18,%esp
}
  80198e:	c9                   	leave  
  80198f:	c3                   	ret    

00801990 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801990:	55                   	push   %ebp
  801991:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801993:	6a 00                	push   $0x0
  801995:	6a 00                	push   $0x0
  801997:	6a 00                	push   $0x0
  801999:	6a 00                	push   $0x0
  80199b:	ff 75 08             	pushl  0x8(%ebp)
  80199e:	6a 10                	push   $0x10
  8019a0:	e8 68 fe ff ff       	call   80180d <syscall>
  8019a5:	83 c4 18             	add    $0x18,%esp
}
  8019a8:	c9                   	leave  
  8019a9:	c3                   	ret    

008019aa <sys_scarce_memory>:

void sys_scarce_memory()
{
  8019aa:	55                   	push   %ebp
  8019ab:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  8019ad:	6a 00                	push   $0x0
  8019af:	6a 00                	push   $0x0
  8019b1:	6a 00                	push   $0x0
  8019b3:	6a 00                	push   $0x0
  8019b5:	6a 00                	push   $0x0
  8019b7:	6a 11                	push   $0x11
  8019b9:	e8 4f fe ff ff       	call   80180d <syscall>
  8019be:	83 c4 18             	add    $0x18,%esp
}
  8019c1:	90                   	nop
  8019c2:	c9                   	leave  
  8019c3:	c3                   	ret    

008019c4 <sys_cputc>:

void
sys_cputc(const char c)
{
  8019c4:	55                   	push   %ebp
  8019c5:	89 e5                	mov    %esp,%ebp
  8019c7:	83 ec 04             	sub    $0x4,%esp
  8019ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8019cd:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  8019d0:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8019d4:	6a 00                	push   $0x0
  8019d6:	6a 00                	push   $0x0
  8019d8:	6a 00                	push   $0x0
  8019da:	6a 00                	push   $0x0
  8019dc:	50                   	push   %eax
  8019dd:	6a 01                	push   $0x1
  8019df:	e8 29 fe ff ff       	call   80180d <syscall>
  8019e4:	83 c4 18             	add    $0x18,%esp
}
  8019e7:	90                   	nop
  8019e8:	c9                   	leave  
  8019e9:	c3                   	ret    

008019ea <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  8019ea:	55                   	push   %ebp
  8019eb:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  8019ed:	6a 00                	push   $0x0
  8019ef:	6a 00                	push   $0x0
  8019f1:	6a 00                	push   $0x0
  8019f3:	6a 00                	push   $0x0
  8019f5:	6a 00                	push   $0x0
  8019f7:	6a 14                	push   $0x14
  8019f9:	e8 0f fe ff ff       	call   80180d <syscall>
  8019fe:	83 c4 18             	add    $0x18,%esp
}
  801a01:	90                   	nop
  801a02:	c9                   	leave  
  801a03:	c3                   	ret    

00801a04 <sys_create_shared_object>:

int sys_create_shared_object(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801a04:	55                   	push   %ebp
  801a05:	89 e5                	mov    %esp,%ebp
  801a07:	83 ec 04             	sub    $0x4,%esp
  801a0a:	8b 45 10             	mov    0x10(%ebp),%eax
  801a0d:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801a10:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801a13:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801a17:	8b 45 08             	mov    0x8(%ebp),%eax
  801a1a:	6a 00                	push   $0x0
  801a1c:	51                   	push   %ecx
  801a1d:	52                   	push   %edx
  801a1e:	ff 75 0c             	pushl  0xc(%ebp)
  801a21:	50                   	push   %eax
  801a22:	6a 15                	push   $0x15
  801a24:	e8 e4 fd ff ff       	call   80180d <syscall>
  801a29:	83 c4 18             	add    $0x18,%esp
}
  801a2c:	c9                   	leave  
  801a2d:	c3                   	ret    

00801a2e <sys_size_of_shared_object>:

//2017:
int sys_size_of_shared_object(int32 ownerID, char* shareName)
{
  801a2e:	55                   	push   %ebp
  801a2f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801a31:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a34:	8b 45 08             	mov    0x8(%ebp),%eax
  801a37:	6a 00                	push   $0x0
  801a39:	6a 00                	push   $0x0
  801a3b:	6a 00                	push   $0x0
  801a3d:	52                   	push   %edx
  801a3e:	50                   	push   %eax
  801a3f:	6a 16                	push   $0x16
  801a41:	e8 c7 fd ff ff       	call   80180d <syscall>
  801a46:	83 c4 18             	add    $0x18,%esp
}
  801a49:	c9                   	leave  
  801a4a:	c3                   	ret    

00801a4b <sys_get_shared_object>:
//==========

int sys_get_shared_object(int32 ownerID, char* shareName, void* virtual_address)
{
  801a4b:	55                   	push   %ebp
  801a4c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801a4e:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801a51:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a54:	8b 45 08             	mov    0x8(%ebp),%eax
  801a57:	6a 00                	push   $0x0
  801a59:	6a 00                	push   $0x0
  801a5b:	51                   	push   %ecx
  801a5c:	52                   	push   %edx
  801a5d:	50                   	push   %eax
  801a5e:	6a 17                	push   $0x17
  801a60:	e8 a8 fd ff ff       	call   80180d <syscall>
  801a65:	83 c4 18             	add    $0x18,%esp
}
  801a68:	c9                   	leave  
  801a69:	c3                   	ret    

00801a6a <sys_delete_shared_object>:

int sys_delete_shared_object(int32 sharedObjectID, void *startVA)
{
  801a6a:	55                   	push   %ebp
  801a6b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801a6d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a70:	8b 45 08             	mov    0x8(%ebp),%eax
  801a73:	6a 00                	push   $0x0
  801a75:	6a 00                	push   $0x0
  801a77:	6a 00                	push   $0x0
  801a79:	52                   	push   %edx
  801a7a:	50                   	push   %eax
  801a7b:	6a 18                	push   $0x18
  801a7d:	e8 8b fd ff ff       	call   80180d <syscall>
  801a82:	83 c4 18             	add    $0x18,%esp
}
  801a85:	c9                   	leave  
  801a86:	c3                   	ret    

00801a87 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801a87:	55                   	push   %ebp
  801a88:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801a8a:	8b 45 08             	mov    0x8(%ebp),%eax
  801a8d:	6a 00                	push   $0x0
  801a8f:	ff 75 14             	pushl  0x14(%ebp)
  801a92:	ff 75 10             	pushl  0x10(%ebp)
  801a95:	ff 75 0c             	pushl  0xc(%ebp)
  801a98:	50                   	push   %eax
  801a99:	6a 19                	push   $0x19
  801a9b:	e8 6d fd ff ff       	call   80180d <syscall>
  801aa0:	83 c4 18             	add    $0x18,%esp
}
  801aa3:	c9                   	leave  
  801aa4:	c3                   	ret    

00801aa5 <sys_run_env>:

void sys_run_env(int32 envId)
{
  801aa5:	55                   	push   %ebp
  801aa6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801aa8:	8b 45 08             	mov    0x8(%ebp),%eax
  801aab:	6a 00                	push   $0x0
  801aad:	6a 00                	push   $0x0
  801aaf:	6a 00                	push   $0x0
  801ab1:	6a 00                	push   $0x0
  801ab3:	50                   	push   %eax
  801ab4:	6a 1a                	push   $0x1a
  801ab6:	e8 52 fd ff ff       	call   80180d <syscall>
  801abb:	83 c4 18             	add    $0x18,%esp
}
  801abe:	90                   	nop
  801abf:	c9                   	leave  
  801ac0:	c3                   	ret    

00801ac1 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801ac1:	55                   	push   %ebp
  801ac2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801ac4:	8b 45 08             	mov    0x8(%ebp),%eax
  801ac7:	6a 00                	push   $0x0
  801ac9:	6a 00                	push   $0x0
  801acb:	6a 00                	push   $0x0
  801acd:	6a 00                	push   $0x0
  801acf:	50                   	push   %eax
  801ad0:	6a 1b                	push   $0x1b
  801ad2:	e8 36 fd ff ff       	call   80180d <syscall>
  801ad7:	83 c4 18             	add    $0x18,%esp
}
  801ada:	c9                   	leave  
  801adb:	c3                   	ret    

00801adc <sys_getenvid>:

int32 sys_getenvid(void)
{
  801adc:	55                   	push   %ebp
  801add:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801adf:	6a 00                	push   $0x0
  801ae1:	6a 00                	push   $0x0
  801ae3:	6a 00                	push   $0x0
  801ae5:	6a 00                	push   $0x0
  801ae7:	6a 00                	push   $0x0
  801ae9:	6a 05                	push   $0x5
  801aeb:	e8 1d fd ff ff       	call   80180d <syscall>
  801af0:	83 c4 18             	add    $0x18,%esp
}
  801af3:	c9                   	leave  
  801af4:	c3                   	ret    

00801af5 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801af5:	55                   	push   %ebp
  801af6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801af8:	6a 00                	push   $0x0
  801afa:	6a 00                	push   $0x0
  801afc:	6a 00                	push   $0x0
  801afe:	6a 00                	push   $0x0
  801b00:	6a 00                	push   $0x0
  801b02:	6a 06                	push   $0x6
  801b04:	e8 04 fd ff ff       	call   80180d <syscall>
  801b09:	83 c4 18             	add    $0x18,%esp
}
  801b0c:	c9                   	leave  
  801b0d:	c3                   	ret    

00801b0e <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801b0e:	55                   	push   %ebp
  801b0f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801b11:	6a 00                	push   $0x0
  801b13:	6a 00                	push   $0x0
  801b15:	6a 00                	push   $0x0
  801b17:	6a 00                	push   $0x0
  801b19:	6a 00                	push   $0x0
  801b1b:	6a 07                	push   $0x7
  801b1d:	e8 eb fc ff ff       	call   80180d <syscall>
  801b22:	83 c4 18             	add    $0x18,%esp
}
  801b25:	c9                   	leave  
  801b26:	c3                   	ret    

00801b27 <sys_exit_env>:


void sys_exit_env(void)
{
  801b27:	55                   	push   %ebp
  801b28:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801b2a:	6a 00                	push   $0x0
  801b2c:	6a 00                	push   $0x0
  801b2e:	6a 00                	push   $0x0
  801b30:	6a 00                	push   $0x0
  801b32:	6a 00                	push   $0x0
  801b34:	6a 1c                	push   $0x1c
  801b36:	e8 d2 fc ff ff       	call   80180d <syscall>
  801b3b:	83 c4 18             	add    $0x18,%esp
}
  801b3e:	90                   	nop
  801b3f:	c9                   	leave  
  801b40:	c3                   	ret    

00801b41 <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  801b41:	55                   	push   %ebp
  801b42:	89 e5                	mov    %esp,%ebp
  801b44:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801b47:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801b4a:	8d 50 04             	lea    0x4(%eax),%edx
  801b4d:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801b50:	6a 00                	push   $0x0
  801b52:	6a 00                	push   $0x0
  801b54:	6a 00                	push   $0x0
  801b56:	52                   	push   %edx
  801b57:	50                   	push   %eax
  801b58:	6a 1d                	push   $0x1d
  801b5a:	e8 ae fc ff ff       	call   80180d <syscall>
  801b5f:	83 c4 18             	add    $0x18,%esp
	return result;
  801b62:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801b65:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801b68:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801b6b:	89 01                	mov    %eax,(%ecx)
  801b6d:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801b70:	8b 45 08             	mov    0x8(%ebp),%eax
  801b73:	c9                   	leave  
  801b74:	c2 04 00             	ret    $0x4

00801b77 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801b77:	55                   	push   %ebp
  801b78:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801b7a:	6a 00                	push   $0x0
  801b7c:	6a 00                	push   $0x0
  801b7e:	ff 75 10             	pushl  0x10(%ebp)
  801b81:	ff 75 0c             	pushl  0xc(%ebp)
  801b84:	ff 75 08             	pushl  0x8(%ebp)
  801b87:	6a 13                	push   $0x13
  801b89:	e8 7f fc ff ff       	call   80180d <syscall>
  801b8e:	83 c4 18             	add    $0x18,%esp
	return ;
  801b91:	90                   	nop
}
  801b92:	c9                   	leave  
  801b93:	c3                   	ret    

00801b94 <sys_rcr2>:
uint32 sys_rcr2()
{
  801b94:	55                   	push   %ebp
  801b95:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801b97:	6a 00                	push   $0x0
  801b99:	6a 00                	push   $0x0
  801b9b:	6a 00                	push   $0x0
  801b9d:	6a 00                	push   $0x0
  801b9f:	6a 00                	push   $0x0
  801ba1:	6a 1e                	push   $0x1e
  801ba3:	e8 65 fc ff ff       	call   80180d <syscall>
  801ba8:	83 c4 18             	add    $0x18,%esp
}
  801bab:	c9                   	leave  
  801bac:	c3                   	ret    

00801bad <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  801bad:	55                   	push   %ebp
  801bae:	89 e5                	mov    %esp,%ebp
  801bb0:	83 ec 04             	sub    $0x4,%esp
  801bb3:	8b 45 08             	mov    0x8(%ebp),%eax
  801bb6:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801bb9:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801bbd:	6a 00                	push   $0x0
  801bbf:	6a 00                	push   $0x0
  801bc1:	6a 00                	push   $0x0
  801bc3:	6a 00                	push   $0x0
  801bc5:	50                   	push   %eax
  801bc6:	6a 1f                	push   $0x1f
  801bc8:	e8 40 fc ff ff       	call   80180d <syscall>
  801bcd:	83 c4 18             	add    $0x18,%esp
	return ;
  801bd0:	90                   	nop
}
  801bd1:	c9                   	leave  
  801bd2:	c3                   	ret    

00801bd3 <rsttst>:
void rsttst()
{
  801bd3:	55                   	push   %ebp
  801bd4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801bd6:	6a 00                	push   $0x0
  801bd8:	6a 00                	push   $0x0
  801bda:	6a 00                	push   $0x0
  801bdc:	6a 00                	push   $0x0
  801bde:	6a 00                	push   $0x0
  801be0:	6a 21                	push   $0x21
  801be2:	e8 26 fc ff ff       	call   80180d <syscall>
  801be7:	83 c4 18             	add    $0x18,%esp
	return ;
  801bea:	90                   	nop
}
  801beb:	c9                   	leave  
  801bec:	c3                   	ret    

00801bed <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801bed:	55                   	push   %ebp
  801bee:	89 e5                	mov    %esp,%ebp
  801bf0:	83 ec 04             	sub    $0x4,%esp
  801bf3:	8b 45 14             	mov    0x14(%ebp),%eax
  801bf6:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801bf9:	8b 55 18             	mov    0x18(%ebp),%edx
  801bfc:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801c00:	52                   	push   %edx
  801c01:	50                   	push   %eax
  801c02:	ff 75 10             	pushl  0x10(%ebp)
  801c05:	ff 75 0c             	pushl  0xc(%ebp)
  801c08:	ff 75 08             	pushl  0x8(%ebp)
  801c0b:	6a 20                	push   $0x20
  801c0d:	e8 fb fb ff ff       	call   80180d <syscall>
  801c12:	83 c4 18             	add    $0x18,%esp
	return ;
  801c15:	90                   	nop
}
  801c16:	c9                   	leave  
  801c17:	c3                   	ret    

00801c18 <chktst>:
void chktst(uint32 n)
{
  801c18:	55                   	push   %ebp
  801c19:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801c1b:	6a 00                	push   $0x0
  801c1d:	6a 00                	push   $0x0
  801c1f:	6a 00                	push   $0x0
  801c21:	6a 00                	push   $0x0
  801c23:	ff 75 08             	pushl  0x8(%ebp)
  801c26:	6a 22                	push   $0x22
  801c28:	e8 e0 fb ff ff       	call   80180d <syscall>
  801c2d:	83 c4 18             	add    $0x18,%esp
	return ;
  801c30:	90                   	nop
}
  801c31:	c9                   	leave  
  801c32:	c3                   	ret    

00801c33 <inctst>:

void inctst()
{
  801c33:	55                   	push   %ebp
  801c34:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801c36:	6a 00                	push   $0x0
  801c38:	6a 00                	push   $0x0
  801c3a:	6a 00                	push   $0x0
  801c3c:	6a 00                	push   $0x0
  801c3e:	6a 00                	push   $0x0
  801c40:	6a 23                	push   $0x23
  801c42:	e8 c6 fb ff ff       	call   80180d <syscall>
  801c47:	83 c4 18             	add    $0x18,%esp
	return ;
  801c4a:	90                   	nop
}
  801c4b:	c9                   	leave  
  801c4c:	c3                   	ret    

00801c4d <gettst>:
uint32 gettst()
{
  801c4d:	55                   	push   %ebp
  801c4e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801c50:	6a 00                	push   $0x0
  801c52:	6a 00                	push   $0x0
  801c54:	6a 00                	push   $0x0
  801c56:	6a 00                	push   $0x0
  801c58:	6a 00                	push   $0x0
  801c5a:	6a 24                	push   $0x24
  801c5c:	e8 ac fb ff ff       	call   80180d <syscall>
  801c61:	83 c4 18             	add    $0x18,%esp
}
  801c64:	c9                   	leave  
  801c65:	c3                   	ret    

00801c66 <sys_get_uheap_strategy>:

/*2025*/
uint32 sys_get_uheap_strategy()
{
  801c66:	55                   	push   %ebp
  801c67:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801c69:	6a 00                	push   $0x0
  801c6b:	6a 00                	push   $0x0
  801c6d:	6a 00                	push   $0x0
  801c6f:	6a 00                	push   $0x0
  801c71:	6a 00                	push   $0x0
  801c73:	6a 25                	push   $0x25
  801c75:	e8 93 fb ff ff       	call   80180d <syscall>
  801c7a:	83 c4 18             	add    $0x18,%esp
  801c7d:	a3 60 b0 81 00       	mov    %eax,0x81b060
	return uheapPlaceStrategy ;
  801c82:	a1 60 b0 81 00       	mov    0x81b060,%eax
}
  801c87:	c9                   	leave  
  801c88:	c3                   	ret    

00801c89 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801c89:	55                   	push   %ebp
  801c8a:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = heapStrategy;
  801c8c:	8b 45 08             	mov    0x8(%ebp),%eax
  801c8f:	a3 60 b0 81 00       	mov    %eax,0x81b060
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801c94:	6a 00                	push   $0x0
  801c96:	6a 00                	push   $0x0
  801c98:	6a 00                	push   $0x0
  801c9a:	6a 00                	push   $0x0
  801c9c:	ff 75 08             	pushl  0x8(%ebp)
  801c9f:	6a 26                	push   $0x26
  801ca1:	e8 67 fb ff ff       	call   80180d <syscall>
  801ca6:	83 c4 18             	add    $0x18,%esp
	return ;
  801ca9:	90                   	nop
}
  801caa:	c9                   	leave  
  801cab:	c3                   	ret    

00801cac <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801cac:	55                   	push   %ebp
  801cad:	89 e5                	mov    %esp,%ebp
  801caf:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801cb0:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801cb3:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801cb6:	8b 55 0c             	mov    0xc(%ebp),%edx
  801cb9:	8b 45 08             	mov    0x8(%ebp),%eax
  801cbc:	6a 00                	push   $0x0
  801cbe:	53                   	push   %ebx
  801cbf:	51                   	push   %ecx
  801cc0:	52                   	push   %edx
  801cc1:	50                   	push   %eax
  801cc2:	6a 27                	push   $0x27
  801cc4:	e8 44 fb ff ff       	call   80180d <syscall>
  801cc9:	83 c4 18             	add    $0x18,%esp
}
  801ccc:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801ccf:	c9                   	leave  
  801cd0:	c3                   	ret    

00801cd1 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801cd1:	55                   	push   %ebp
  801cd2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801cd4:	8b 55 0c             	mov    0xc(%ebp),%edx
  801cd7:	8b 45 08             	mov    0x8(%ebp),%eax
  801cda:	6a 00                	push   $0x0
  801cdc:	6a 00                	push   $0x0
  801cde:	6a 00                	push   $0x0
  801ce0:	52                   	push   %edx
  801ce1:	50                   	push   %eax
  801ce2:	6a 28                	push   $0x28
  801ce4:	e8 24 fb ff ff       	call   80180d <syscall>
  801ce9:	83 c4 18             	add    $0x18,%esp
}
  801cec:	c9                   	leave  
  801ced:	c3                   	ret    

00801cee <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  801cee:	55                   	push   %ebp
  801cef:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  801cf1:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801cf4:	8b 55 0c             	mov    0xc(%ebp),%edx
  801cf7:	8b 45 08             	mov    0x8(%ebp),%eax
  801cfa:	6a 00                	push   $0x0
  801cfc:	51                   	push   %ecx
  801cfd:	ff 75 10             	pushl  0x10(%ebp)
  801d00:	52                   	push   %edx
  801d01:	50                   	push   %eax
  801d02:	6a 29                	push   $0x29
  801d04:	e8 04 fb ff ff       	call   80180d <syscall>
  801d09:	83 c4 18             	add    $0x18,%esp
}
  801d0c:	c9                   	leave  
  801d0d:	c3                   	ret    

00801d0e <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801d0e:	55                   	push   %ebp
  801d0f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801d11:	6a 00                	push   $0x0
  801d13:	6a 00                	push   $0x0
  801d15:	ff 75 10             	pushl  0x10(%ebp)
  801d18:	ff 75 0c             	pushl  0xc(%ebp)
  801d1b:	ff 75 08             	pushl  0x8(%ebp)
  801d1e:	6a 12                	push   $0x12
  801d20:	e8 e8 fa ff ff       	call   80180d <syscall>
  801d25:	83 c4 18             	add    $0x18,%esp
	return ;
  801d28:	90                   	nop
}
  801d29:	c9                   	leave  
  801d2a:	c3                   	ret    

00801d2b <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  801d2b:	55                   	push   %ebp
  801d2c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  801d2e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d31:	8b 45 08             	mov    0x8(%ebp),%eax
  801d34:	6a 00                	push   $0x0
  801d36:	6a 00                	push   $0x0
  801d38:	6a 00                	push   $0x0
  801d3a:	52                   	push   %edx
  801d3b:	50                   	push   %eax
  801d3c:	6a 2a                	push   $0x2a
  801d3e:	e8 ca fa ff ff       	call   80180d <syscall>
  801d43:	83 c4 18             	add    $0x18,%esp
	return;
  801d46:	90                   	nop
}
  801d47:	c9                   	leave  
  801d48:	c3                   	ret    

00801d49 <sys_get_optimal_num_faults>:
/*2025*/
int sys_get_optimal_num_faults()
{
  801d49:	55                   	push   %ebp
  801d4a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_optimal_num_faults, 0, 0, 0, 0, 0);
  801d4c:	6a 00                	push   $0x0
  801d4e:	6a 00                	push   $0x0
  801d50:	6a 00                	push   $0x0
  801d52:	6a 00                	push   $0x0
  801d54:	6a 00                	push   $0x0
  801d56:	6a 2b                	push   $0x2b
  801d58:	e8 b0 fa ff ff       	call   80180d <syscall>
  801d5d:	83 c4 18             	add    $0x18,%esp
}
  801d60:	c9                   	leave  
  801d61:	c3                   	ret    

00801d62 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801d62:	55                   	push   %ebp
  801d63:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801d65:	6a 00                	push   $0x0
  801d67:	6a 00                	push   $0x0
  801d69:	6a 00                	push   $0x0
  801d6b:	ff 75 0c             	pushl  0xc(%ebp)
  801d6e:	ff 75 08             	pushl  0x8(%ebp)
  801d71:	6a 2d                	push   $0x2d
  801d73:	e8 95 fa ff ff       	call   80180d <syscall>
  801d78:	83 c4 18             	add    $0x18,%esp
	return;
  801d7b:	90                   	nop
}
  801d7c:	c9                   	leave  
  801d7d:	c3                   	ret    

00801d7e <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801d7e:	55                   	push   %ebp
  801d7f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801d81:	6a 00                	push   $0x0
  801d83:	6a 00                	push   $0x0
  801d85:	6a 00                	push   $0x0
  801d87:	ff 75 0c             	pushl  0xc(%ebp)
  801d8a:	ff 75 08             	pushl  0x8(%ebp)
  801d8d:	6a 2c                	push   $0x2c
  801d8f:	e8 79 fa ff ff       	call   80180d <syscall>
  801d94:	83 c4 18             	add    $0x18,%esp
	return ;
  801d97:	90                   	nop
}
  801d98:	c9                   	leave  
  801d99:	c3                   	ret    

00801d9a <sys_env_set_priority>:


void sys_env_set_priority(int32 envID, int priority)
{
  801d9a:	55                   	push   %ebp
  801d9b:	89 e5                	mov    %esp,%ebp
  801d9d:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.IM#4] CPU SCHEDULING - #1 System Calls - Add suitable code here
	//Your code is here
	//Comment the following line
	panic("sys_env_set_priority() is not implemented yet...!!");
  801da0:	83 ec 04             	sub    $0x4,%esp
  801da3:	68 fc 29 80 00       	push   $0x8029fc
  801da8:	68 25 01 00 00       	push   $0x125
  801dad:	68 2f 2a 80 00       	push   $0x802a2f
  801db2:	e8 9b e6 ff ff       	call   800452 <_panic>

00801db7 <env_sleep>:
#include <inc/lib.h>
#include <inc/timerreg.h>

void
env_sleep(uint32 approxMilliSeconds)
{
  801db7:	55                   	push   %ebp
  801db8:	89 e5                	mov    %esp,%ebp
  801dba:	83 ec 30             	sub    $0x30,%esp
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
  801dbd:	8b 55 08             	mov    0x8(%ebp),%edx
  801dc0:	89 d0                	mov    %edx,%eax
  801dc2:	c1 e0 02             	shl    $0x2,%eax
  801dc5:	01 d0                	add    %edx,%eax
  801dc7:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801dce:	01 d0                	add    %edx,%eax
  801dd0:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801dd7:	01 d0                	add    %edx,%eax
  801dd9:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801de0:	01 d0                	add    %edx,%eax
  801de2:	c1 e0 04             	shl    $0x4,%eax
  801de5:	89 45 f8             	mov    %eax,-0x8(%ebp)
	uint32 cycles_counter =0;
  801de8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)

static inline __attribute__((always_inline)) struct uint64 get_virtual_time_user()
{
	struct uint64 result;

	__asm __volatile("rdtsc\n"
  801def:	0f 31                	rdtsc  
  801df1:	89 45 e8             	mov    %eax,-0x18(%ebp)
  801df4:	89 55 ec             	mov    %edx,-0x14(%ebp)
	: "=a" (result.low), "=d" (result.hi)
	);

	return result;
  801df7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801dfa:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801dfd:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801e00:	89 55 f4             	mov    %edx,-0xc(%ebp)

	/*2024*/ //USE A USER-SIDE VERSION OF THIS FUNCTION TO AVOID SLOW-DOWN THE PERFORMANCE DUE SYS_CALL (el7 :))
	//struct uint64 baseTime = sys_get_virtual_time() ;
	struct uint64 baseTime = get_virtual_time_user() ;
	while(cycles_counter<time_in_cycles)
  801e03:	eb 46                	jmp    801e4b <env_sleep+0x94>

static inline __attribute__((always_inline)) struct uint64 get_virtual_time_user()
{
	struct uint64 result;

	__asm __volatile("rdtsc\n"
  801e05:	0f 31                	rdtsc  
  801e07:	89 45 d0             	mov    %eax,-0x30(%ebp)
  801e0a:	89 55 d4             	mov    %edx,-0x2c(%ebp)
	: "=a" (result.low), "=d" (result.hi)
	);

	return result;
  801e0d:	8b 45 d0             	mov    -0x30(%ebp),%eax
  801e10:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  801e13:	89 45 e0             	mov    %eax,-0x20(%ebp)
  801e16:	89 55 e4             	mov    %edx,-0x1c(%ebp)

		// update the cycles_count
		#define M32 0xffffffff
		// subtract basetime from current time
		struct uint64 res;
		res.low = (currentTime.low - baseTime.low) & M32;
  801e19:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801e1c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e1f:	29 c2                	sub    %eax,%edx
  801e21:	89 d0                	mov    %edx,%eax
  801e23:	89 45 d8             	mov    %eax,-0x28(%ebp)
		res.hi = (currentTime.hi - baseTime.hi - (res.low > currentTime.low)) & M32;
  801e26:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801e29:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e2c:	89 d1                	mov    %edx,%ecx
  801e2e:	29 c1                	sub    %eax,%ecx
  801e30:	8b 55 d8             	mov    -0x28(%ebp),%edx
  801e33:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801e36:	39 c2                	cmp    %eax,%edx
  801e38:	0f 97 c0             	seta   %al
  801e3b:	0f b6 c0             	movzbl %al,%eax
  801e3e:	29 c1                	sub    %eax,%ecx
  801e40:	89 c8                	mov    %ecx,%eax
  801e42:	89 45 dc             	mov    %eax,-0x24(%ebp)

		//update cycles_count with result
		cycles_counter = res.low;
  801e45:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801e48:	89 45 fc             	mov    %eax,-0x4(%ebp)
	uint32 cycles_counter =0;

	/*2024*/ //USE A USER-SIDE VERSION OF THIS FUNCTION TO AVOID SLOW-DOWN THE PERFORMANCE DUE SYS_CALL (el7 :))
	//struct uint64 baseTime = sys_get_virtual_time() ;
	struct uint64 baseTime = get_virtual_time_user() ;
	while(cycles_counter<time_in_cycles)
  801e4b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801e4e:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801e51:	72 b2                	jb     801e05 <env_sleep+0x4e>
//				,cycles_counter
//				);
	}
	//cprintf("%s [%d] wake up now!\n", myEnv->prog_name, myEnv->env_id);

}
  801e53:	90                   	nop
  801e54:	c9                   	leave  
  801e55:	c3                   	ret    

00801e56 <busy_wait>:

//2017
uint32 busy_wait(uint32 loopMax)
{
  801e56:	55                   	push   %ebp
  801e57:	89 e5                	mov    %esp,%ebp
  801e59:	83 ec 10             	sub    $0x10,%esp
	uint32 i = 0 ;
  801e5c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	while (i < loopMax) i++;
  801e63:	eb 03                	jmp    801e68 <busy_wait+0x12>
  801e65:	ff 45 fc             	incl   -0x4(%ebp)
  801e68:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801e6b:	3b 45 08             	cmp    0x8(%ebp),%eax
  801e6e:	72 f5                	jb     801e65 <busy_wait+0xf>
	return i;
  801e70:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801e73:	c9                   	leave  
  801e74:	c3                   	ret    

00801e75 <cputchar>:
#include <inc/lib.h>


void
cputchar(int ch)
{
  801e75:	55                   	push   %ebp
  801e76:	89 e5                	mov    %esp,%ebp
  801e78:	83 ec 18             	sub    $0x18,%esp
	char c = ch;
  801e7b:	8b 45 08             	mov    0x8(%ebp),%eax
  801e7e:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	//sys_cputs(&c, 1);

	sys_cputc(c);
  801e81:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  801e85:	83 ec 0c             	sub    $0xc,%esp
  801e88:	50                   	push   %eax
  801e89:	e8 36 fb ff ff       	call   8019c4 <sys_cputc>
  801e8e:	83 c4 10             	add    $0x10,%esp
}
  801e91:	90                   	nop
  801e92:	c9                   	leave  
  801e93:	c3                   	ret    

00801e94 <getchar>:


int
getchar(void)
{
  801e94:	55                   	push   %ebp
  801e95:	89 e5                	mov    %esp,%ebp
  801e97:	83 ec 18             	sub    $0x18,%esp
	int c =sys_cgetc();
  801e9a:	e8 c4 f9 ff ff       	call   801863 <sys_cgetc>
  801e9f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	return c;
  801ea2:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  801ea5:	c9                   	leave  
  801ea6:	c3                   	ret    

00801ea7 <iscons>:

int iscons(int fdnum)
{
  801ea7:	55                   	push   %ebp
  801ea8:	89 e5                	mov    %esp,%ebp
	// used by readline
	return 1;
  801eaa:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801eaf:	5d                   	pop    %ebp
  801eb0:	c3                   	ret    
  801eb1:	66 90                	xchg   %ax,%ax
  801eb3:	90                   	nop

00801eb4 <__udivdi3>:
  801eb4:	55                   	push   %ebp
  801eb5:	57                   	push   %edi
  801eb6:	56                   	push   %esi
  801eb7:	53                   	push   %ebx
  801eb8:	83 ec 1c             	sub    $0x1c,%esp
  801ebb:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  801ebf:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  801ec3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801ec7:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801ecb:	89 ca                	mov    %ecx,%edx
  801ecd:	89 f8                	mov    %edi,%eax
  801ecf:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  801ed3:	85 f6                	test   %esi,%esi
  801ed5:	75 2d                	jne    801f04 <__udivdi3+0x50>
  801ed7:	39 cf                	cmp    %ecx,%edi
  801ed9:	77 65                	ja     801f40 <__udivdi3+0x8c>
  801edb:	89 fd                	mov    %edi,%ebp
  801edd:	85 ff                	test   %edi,%edi
  801edf:	75 0b                	jne    801eec <__udivdi3+0x38>
  801ee1:	b8 01 00 00 00       	mov    $0x1,%eax
  801ee6:	31 d2                	xor    %edx,%edx
  801ee8:	f7 f7                	div    %edi
  801eea:	89 c5                	mov    %eax,%ebp
  801eec:	31 d2                	xor    %edx,%edx
  801eee:	89 c8                	mov    %ecx,%eax
  801ef0:	f7 f5                	div    %ebp
  801ef2:	89 c1                	mov    %eax,%ecx
  801ef4:	89 d8                	mov    %ebx,%eax
  801ef6:	f7 f5                	div    %ebp
  801ef8:	89 cf                	mov    %ecx,%edi
  801efa:	89 fa                	mov    %edi,%edx
  801efc:	83 c4 1c             	add    $0x1c,%esp
  801eff:	5b                   	pop    %ebx
  801f00:	5e                   	pop    %esi
  801f01:	5f                   	pop    %edi
  801f02:	5d                   	pop    %ebp
  801f03:	c3                   	ret    
  801f04:	39 ce                	cmp    %ecx,%esi
  801f06:	77 28                	ja     801f30 <__udivdi3+0x7c>
  801f08:	0f bd fe             	bsr    %esi,%edi
  801f0b:	83 f7 1f             	xor    $0x1f,%edi
  801f0e:	75 40                	jne    801f50 <__udivdi3+0x9c>
  801f10:	39 ce                	cmp    %ecx,%esi
  801f12:	72 0a                	jb     801f1e <__udivdi3+0x6a>
  801f14:	3b 44 24 08          	cmp    0x8(%esp),%eax
  801f18:	0f 87 9e 00 00 00    	ja     801fbc <__udivdi3+0x108>
  801f1e:	b8 01 00 00 00       	mov    $0x1,%eax
  801f23:	89 fa                	mov    %edi,%edx
  801f25:	83 c4 1c             	add    $0x1c,%esp
  801f28:	5b                   	pop    %ebx
  801f29:	5e                   	pop    %esi
  801f2a:	5f                   	pop    %edi
  801f2b:	5d                   	pop    %ebp
  801f2c:	c3                   	ret    
  801f2d:	8d 76 00             	lea    0x0(%esi),%esi
  801f30:	31 ff                	xor    %edi,%edi
  801f32:	31 c0                	xor    %eax,%eax
  801f34:	89 fa                	mov    %edi,%edx
  801f36:	83 c4 1c             	add    $0x1c,%esp
  801f39:	5b                   	pop    %ebx
  801f3a:	5e                   	pop    %esi
  801f3b:	5f                   	pop    %edi
  801f3c:	5d                   	pop    %ebp
  801f3d:	c3                   	ret    
  801f3e:	66 90                	xchg   %ax,%ax
  801f40:	89 d8                	mov    %ebx,%eax
  801f42:	f7 f7                	div    %edi
  801f44:	31 ff                	xor    %edi,%edi
  801f46:	89 fa                	mov    %edi,%edx
  801f48:	83 c4 1c             	add    $0x1c,%esp
  801f4b:	5b                   	pop    %ebx
  801f4c:	5e                   	pop    %esi
  801f4d:	5f                   	pop    %edi
  801f4e:	5d                   	pop    %ebp
  801f4f:	c3                   	ret    
  801f50:	bd 20 00 00 00       	mov    $0x20,%ebp
  801f55:	89 eb                	mov    %ebp,%ebx
  801f57:	29 fb                	sub    %edi,%ebx
  801f59:	89 f9                	mov    %edi,%ecx
  801f5b:	d3 e6                	shl    %cl,%esi
  801f5d:	89 c5                	mov    %eax,%ebp
  801f5f:	88 d9                	mov    %bl,%cl
  801f61:	d3 ed                	shr    %cl,%ebp
  801f63:	89 e9                	mov    %ebp,%ecx
  801f65:	09 f1                	or     %esi,%ecx
  801f67:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  801f6b:	89 f9                	mov    %edi,%ecx
  801f6d:	d3 e0                	shl    %cl,%eax
  801f6f:	89 c5                	mov    %eax,%ebp
  801f71:	89 d6                	mov    %edx,%esi
  801f73:	88 d9                	mov    %bl,%cl
  801f75:	d3 ee                	shr    %cl,%esi
  801f77:	89 f9                	mov    %edi,%ecx
  801f79:	d3 e2                	shl    %cl,%edx
  801f7b:	8b 44 24 08          	mov    0x8(%esp),%eax
  801f7f:	88 d9                	mov    %bl,%cl
  801f81:	d3 e8                	shr    %cl,%eax
  801f83:	09 c2                	or     %eax,%edx
  801f85:	89 d0                	mov    %edx,%eax
  801f87:	89 f2                	mov    %esi,%edx
  801f89:	f7 74 24 0c          	divl   0xc(%esp)
  801f8d:	89 d6                	mov    %edx,%esi
  801f8f:	89 c3                	mov    %eax,%ebx
  801f91:	f7 e5                	mul    %ebp
  801f93:	39 d6                	cmp    %edx,%esi
  801f95:	72 19                	jb     801fb0 <__udivdi3+0xfc>
  801f97:	74 0b                	je     801fa4 <__udivdi3+0xf0>
  801f99:	89 d8                	mov    %ebx,%eax
  801f9b:	31 ff                	xor    %edi,%edi
  801f9d:	e9 58 ff ff ff       	jmp    801efa <__udivdi3+0x46>
  801fa2:	66 90                	xchg   %ax,%ax
  801fa4:	8b 54 24 08          	mov    0x8(%esp),%edx
  801fa8:	89 f9                	mov    %edi,%ecx
  801faa:	d3 e2                	shl    %cl,%edx
  801fac:	39 c2                	cmp    %eax,%edx
  801fae:	73 e9                	jae    801f99 <__udivdi3+0xe5>
  801fb0:	8d 43 ff             	lea    -0x1(%ebx),%eax
  801fb3:	31 ff                	xor    %edi,%edi
  801fb5:	e9 40 ff ff ff       	jmp    801efa <__udivdi3+0x46>
  801fba:	66 90                	xchg   %ax,%ax
  801fbc:	31 c0                	xor    %eax,%eax
  801fbe:	e9 37 ff ff ff       	jmp    801efa <__udivdi3+0x46>
  801fc3:	90                   	nop

00801fc4 <__umoddi3>:
  801fc4:	55                   	push   %ebp
  801fc5:	57                   	push   %edi
  801fc6:	56                   	push   %esi
  801fc7:	53                   	push   %ebx
  801fc8:	83 ec 1c             	sub    $0x1c,%esp
  801fcb:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  801fcf:	8b 74 24 34          	mov    0x34(%esp),%esi
  801fd3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801fd7:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  801fdb:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801fdf:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801fe3:	89 f3                	mov    %esi,%ebx
  801fe5:	89 fa                	mov    %edi,%edx
  801fe7:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801feb:	89 34 24             	mov    %esi,(%esp)
  801fee:	85 c0                	test   %eax,%eax
  801ff0:	75 1a                	jne    80200c <__umoddi3+0x48>
  801ff2:	39 f7                	cmp    %esi,%edi
  801ff4:	0f 86 a2 00 00 00    	jbe    80209c <__umoddi3+0xd8>
  801ffa:	89 c8                	mov    %ecx,%eax
  801ffc:	89 f2                	mov    %esi,%edx
  801ffe:	f7 f7                	div    %edi
  802000:	89 d0                	mov    %edx,%eax
  802002:	31 d2                	xor    %edx,%edx
  802004:	83 c4 1c             	add    $0x1c,%esp
  802007:	5b                   	pop    %ebx
  802008:	5e                   	pop    %esi
  802009:	5f                   	pop    %edi
  80200a:	5d                   	pop    %ebp
  80200b:	c3                   	ret    
  80200c:	39 f0                	cmp    %esi,%eax
  80200e:	0f 87 ac 00 00 00    	ja     8020c0 <__umoddi3+0xfc>
  802014:	0f bd e8             	bsr    %eax,%ebp
  802017:	83 f5 1f             	xor    $0x1f,%ebp
  80201a:	0f 84 ac 00 00 00    	je     8020cc <__umoddi3+0x108>
  802020:	bf 20 00 00 00       	mov    $0x20,%edi
  802025:	29 ef                	sub    %ebp,%edi
  802027:	89 fe                	mov    %edi,%esi
  802029:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80202d:	89 e9                	mov    %ebp,%ecx
  80202f:	d3 e0                	shl    %cl,%eax
  802031:	89 d7                	mov    %edx,%edi
  802033:	89 f1                	mov    %esi,%ecx
  802035:	d3 ef                	shr    %cl,%edi
  802037:	09 c7                	or     %eax,%edi
  802039:	89 e9                	mov    %ebp,%ecx
  80203b:	d3 e2                	shl    %cl,%edx
  80203d:	89 14 24             	mov    %edx,(%esp)
  802040:	89 d8                	mov    %ebx,%eax
  802042:	d3 e0                	shl    %cl,%eax
  802044:	89 c2                	mov    %eax,%edx
  802046:	8b 44 24 08          	mov    0x8(%esp),%eax
  80204a:	d3 e0                	shl    %cl,%eax
  80204c:	89 44 24 04          	mov    %eax,0x4(%esp)
  802050:	8b 44 24 08          	mov    0x8(%esp),%eax
  802054:	89 f1                	mov    %esi,%ecx
  802056:	d3 e8                	shr    %cl,%eax
  802058:	09 d0                	or     %edx,%eax
  80205a:	d3 eb                	shr    %cl,%ebx
  80205c:	89 da                	mov    %ebx,%edx
  80205e:	f7 f7                	div    %edi
  802060:	89 d3                	mov    %edx,%ebx
  802062:	f7 24 24             	mull   (%esp)
  802065:	89 c6                	mov    %eax,%esi
  802067:	89 d1                	mov    %edx,%ecx
  802069:	39 d3                	cmp    %edx,%ebx
  80206b:	0f 82 87 00 00 00    	jb     8020f8 <__umoddi3+0x134>
  802071:	0f 84 91 00 00 00    	je     802108 <__umoddi3+0x144>
  802077:	8b 54 24 04          	mov    0x4(%esp),%edx
  80207b:	29 f2                	sub    %esi,%edx
  80207d:	19 cb                	sbb    %ecx,%ebx
  80207f:	89 d8                	mov    %ebx,%eax
  802081:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  802085:	d3 e0                	shl    %cl,%eax
  802087:	89 e9                	mov    %ebp,%ecx
  802089:	d3 ea                	shr    %cl,%edx
  80208b:	09 d0                	or     %edx,%eax
  80208d:	89 e9                	mov    %ebp,%ecx
  80208f:	d3 eb                	shr    %cl,%ebx
  802091:	89 da                	mov    %ebx,%edx
  802093:	83 c4 1c             	add    $0x1c,%esp
  802096:	5b                   	pop    %ebx
  802097:	5e                   	pop    %esi
  802098:	5f                   	pop    %edi
  802099:	5d                   	pop    %ebp
  80209a:	c3                   	ret    
  80209b:	90                   	nop
  80209c:	89 fd                	mov    %edi,%ebp
  80209e:	85 ff                	test   %edi,%edi
  8020a0:	75 0b                	jne    8020ad <__umoddi3+0xe9>
  8020a2:	b8 01 00 00 00       	mov    $0x1,%eax
  8020a7:	31 d2                	xor    %edx,%edx
  8020a9:	f7 f7                	div    %edi
  8020ab:	89 c5                	mov    %eax,%ebp
  8020ad:	89 f0                	mov    %esi,%eax
  8020af:	31 d2                	xor    %edx,%edx
  8020b1:	f7 f5                	div    %ebp
  8020b3:	89 c8                	mov    %ecx,%eax
  8020b5:	f7 f5                	div    %ebp
  8020b7:	89 d0                	mov    %edx,%eax
  8020b9:	e9 44 ff ff ff       	jmp    802002 <__umoddi3+0x3e>
  8020be:	66 90                	xchg   %ax,%ax
  8020c0:	89 c8                	mov    %ecx,%eax
  8020c2:	89 f2                	mov    %esi,%edx
  8020c4:	83 c4 1c             	add    $0x1c,%esp
  8020c7:	5b                   	pop    %ebx
  8020c8:	5e                   	pop    %esi
  8020c9:	5f                   	pop    %edi
  8020ca:	5d                   	pop    %ebp
  8020cb:	c3                   	ret    
  8020cc:	3b 04 24             	cmp    (%esp),%eax
  8020cf:	72 06                	jb     8020d7 <__umoddi3+0x113>
  8020d1:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  8020d5:	77 0f                	ja     8020e6 <__umoddi3+0x122>
  8020d7:	89 f2                	mov    %esi,%edx
  8020d9:	29 f9                	sub    %edi,%ecx
  8020db:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  8020df:	89 14 24             	mov    %edx,(%esp)
  8020e2:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8020e6:	8b 44 24 04          	mov    0x4(%esp),%eax
  8020ea:	8b 14 24             	mov    (%esp),%edx
  8020ed:	83 c4 1c             	add    $0x1c,%esp
  8020f0:	5b                   	pop    %ebx
  8020f1:	5e                   	pop    %esi
  8020f2:	5f                   	pop    %edi
  8020f3:	5d                   	pop    %ebp
  8020f4:	c3                   	ret    
  8020f5:	8d 76 00             	lea    0x0(%esi),%esi
  8020f8:	2b 04 24             	sub    (%esp),%eax
  8020fb:	19 fa                	sbb    %edi,%edx
  8020fd:	89 d1                	mov    %edx,%ecx
  8020ff:	89 c6                	mov    %eax,%esi
  802101:	e9 71 ff ff ff       	jmp    802077 <__umoddi3+0xb3>
  802106:	66 90                	xchg   %ax,%ax
  802108:	39 44 24 04          	cmp    %eax,0x4(%esp)
  80210c:	72 ea                	jb     8020f8 <__umoddi3+0x134>
  80210e:	89 d9                	mov    %ebx,%ecx
  802110:	e9 62 ff ff ff       	jmp    802077 <__umoddi3+0xb3>
