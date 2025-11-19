
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
  800047:	68 20 21 80 00       	push   $0x802120
  80004c:	6a 0e                	push   $0xe
  80004e:	e8 01 07 00 00       	call   800754 <cprintf_colored>
  800053:	83 c4 10             	add    $0x10,%esp
	cprintf_colored(TEXT_yellow,"MAKE SURE to have a FRESH RUN for this test\n(i.e. don't run any program/test before it)\n");
  800056:	83 ec 08             	sub    $0x8,%esp
  800059:	68 50 21 80 00       	push   $0x802150
  80005e:	6a 0e                	push   $0xe
  800060:	e8 ef 06 00 00       	call   800754 <cprintf_colored>
  800065:	83 c4 10             	add    $0x10,%esp
	cprintf_colored(TEXT_yellow,"==============================================\n");
  800068:	83 ec 08             	sub    $0x8,%esp
  80006b:	68 20 21 80 00       	push   $0x802120
  800070:	6a 0e                	push   $0xe
  800072:	e8 dd 06 00 00       	call   800754 <cprintf_colored>
  800077:	83 c4 10             	add    $0x10,%esp

	int envID = sys_getenvid();
  80007a:	e8 64 1a 00 00       	call   801ae3 <sys_getenvid>
  80007f:	89 45 dc             	mov    %eax,-0x24(%ebp)
	char slavesCnt[10];
	readline("Enter the number of Slave Programs: ", slavesCnt);
  800082:	83 ec 08             	sub    $0x8,%esp
  800085:	8d 45 ce             	lea    -0x32(%ebp),%eax
  800088:	50                   	push   %eax
  800089:	68 ac 21 80 00       	push   $0x8021ac
  80008e:	e8 6d 0d 00 00       	call   800e00 <readline>
  800093:	83 c4 10             	add    $0x10,%esp
	int numOfSlaves = strtol(slavesCnt, NULL, 10);
  800096:	83 ec 04             	sub    $0x4,%esp
  800099:	6a 0a                	push   $0xa
  80009b:	6a 00                	push   $0x0
  80009d:	8d 45 ce             	lea    -0x32(%ebp),%eax
  8000a0:	50                   	push   %eax
  8000a1:	e8 71 13 00 00       	call   801417 <strtol>
  8000a6:	83 c4 10             	add    $0x10,%esp
  8000a9:	89 45 c8             	mov    %eax,-0x38(%ebp)

	//Save number of slaved to be checked later
	char cmd1[64] = "__NumOfSlaves@Set";
  8000ac:	8d 45 88             	lea    -0x78(%ebp),%eax
  8000af:	bb 44 23 80 00       	mov    $0x802344,%ebx
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
  8000da:	e8 53 1c 00 00       	call   801d32 <sys_utilities>
  8000df:	83 c4 10             	add    $0x10,%esp

	rsttst();
  8000e2:	e8 f3 1a 00 00       	call   801bda <rsttst>

	//Create and run slave programs that should sleep
	int id;
	for (int i = 0; i < numOfSlaves; ++i)
  8000e7:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  8000ee:	eb 6a                	jmp    80015a <_main+0x122>
	{
		id = sys_create_env("tstSleepLockSlave", (myEnv->page_WS_max_size),(myEnv->SecondListSize), (myEnv->percentage_of_WS_pages_to_be_removed));
  8000f0:	a1 20 30 80 00       	mov    0x803020,%eax
  8000f5:	8b 90 94 05 00 00    	mov    0x594(%eax),%edx
  8000fb:	a1 20 30 80 00       	mov    0x803020,%eax
  800100:	8b 80 8c 05 00 00    	mov    0x58c(%eax),%eax
  800106:	89 c1                	mov    %eax,%ecx
  800108:	a1 20 30 80 00       	mov    0x803020,%eax
  80010d:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
  800113:	52                   	push   %edx
  800114:	51                   	push   %ecx
  800115:	50                   	push   %eax
  800116:	68 d1 21 80 00       	push   $0x8021d1
  80011b:	e8 6e 19 00 00       	call   801a8e <sys_create_env>
  800120:	83 c4 10             	add    $0x10,%esp
  800123:	89 45 d8             	mov    %eax,-0x28(%ebp)
		if (id== E_ENV_CREATION_ERROR)
  800126:	83 7d d8 ef          	cmpl   $0xffffffef,-0x28(%ebp)
  80012a:	75 1d                	jne    800149 <_main+0x111>
		{
			cprintf_colored(TEXT_TESTERR_CLR,"\n%~insufficient number of processes in the system! only %d slave processes are created\n", i);
  80012c:	83 ec 04             	sub    $0x4,%esp
  80012f:	ff 75 e4             	pushl  -0x1c(%ebp)
  800132:	68 e4 21 80 00       	push   $0x8021e4
  800137:	6a 0c                	push   $0xc
  800139:	e8 16 06 00 00       	call   800754 <cprintf_colored>
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
  80014f:	e8 58 19 00 00       	call   801aac <sys_run_env>
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
  80016f:	bb 84 23 80 00       	mov    $0x802384,%ebx
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
  8001a0:	e8 8d 1b 00 00       	call   801d32 <sys_utilities>
  8001a5:	83 c4 10             	add    $0x10,%esp
	int cnt = 0;
  8001a8:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
	while (numOfBlockedProcesses != numOfSlaves-1)
  8001af:	eb 77                	jmp    800228 <_main+0x1f0>
	{
		env_sleep(5000);
  8001b1:	83 ec 0c             	sub    $0xc,%esp
  8001b4:	68 88 13 00 00       	push   $0x1388
  8001b9:	e8 00 1c 00 00       	call   801dbe <env_sleep>
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
  8001d5:	68 3c 22 80 00       	push   $0x80223c
  8001da:	6a 2f                	push   $0x2f
  8001dc:	68 96 22 80 00       	push   $0x802296
  8001e1:	e8 73 02 00 00       	call   800459 <_panic>
		}
		char cmd3[64] = "__GetLockQueueSize__";
  8001e6:	8d 85 04 ff ff ff    	lea    -0xfc(%ebp),%eax
  8001ec:	bb 84 23 80 00       	mov    $0x802384,%ebx
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
  80021d:	e8 10 1b 00 00       	call   801d32 <sys_utilities>
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
  800239:	e8 fc 19 00 00       	call   801c3a <inctst>

	//Wait until all slave finished
	cnt = 0;
  80023e:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
	while (gettst() != numOfSlaves +1/*since master already increment it by 1*/)
  800245:	eb 3a                	jmp    800281 <_main+0x249>
	{
		env_sleep(15000);
  800247:	83 ec 0c             	sub    $0xc,%esp
  80024a:	68 98 3a 00 00       	push   $0x3a98
  80024f:	e8 6a 1b 00 00       	call   801dbe <env_sleep>
  800254:	83 c4 10             	add    $0x10,%esp
		if (cnt == numOfSlaves)
  800257:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80025a:	39 45 e0             	cmp    %eax,-0x20(%ebp)
  80025d:	75 1f                	jne    80027e <_main+0x246>
		{
			panic("%~test sleeplock failed! not all processes finished. Expected %d, Actual %d", numOfSlaves +1, gettst());
  80025f:	e8 f0 19 00 00       	call   801c54 <gettst>
  800264:	8b 55 c8             	mov    -0x38(%ebp),%edx
  800267:	42                   	inc    %edx
  800268:	83 ec 0c             	sub    $0xc,%esp
  80026b:	50                   	push   %eax
  80026c:	52                   	push   %edx
  80026d:	68 b4 22 80 00       	push   $0x8022b4
  800272:	6a 41                	push   $0x41
  800274:	68 96 22 80 00       	push   $0x802296
  800279:	e8 db 01 00 00       	call   800459 <_panic>
		}
		cnt++ ;
  80027e:	ff 45 e0             	incl   -0x20(%ebp)
	//signal the slave inside the critical section to leave it
	inctst();

	//Wait until all slave finished
	cnt = 0;
	while (gettst() != numOfSlaves +1/*since master already increment it by 1*/)
  800281:	e8 ce 19 00 00       	call   801c54 <gettst>
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
  800291:	68 00 23 80 00       	push   $0x802300
  800296:	6a 0a                	push   $0xa
  800298:	e8 b7 04 00 00       	call   800754 <cprintf_colored>
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
  8002b2:	e8 45 18 00 00       	call   801afc <sys_getenvindex>
  8002b7:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	myEnv = &(envs[envIndex]);
  8002ba:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8002bd:	89 d0                	mov    %edx,%eax
  8002bf:	c1 e0 02             	shl    $0x2,%eax
  8002c2:	01 d0                	add    %edx,%eax
  8002c4:	c1 e0 03             	shl    $0x3,%eax
  8002c7:	01 d0                	add    %edx,%eax
  8002c9:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  8002d0:	01 d0                	add    %edx,%eax
  8002d2:	c1 e0 02             	shl    $0x2,%eax
  8002d5:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8002da:	a3 20 30 80 00       	mov    %eax,0x803020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  8002df:	a1 20 30 80 00       	mov    0x803020,%eax
  8002e4:	8a 40 20             	mov    0x20(%eax),%al
  8002e7:	84 c0                	test   %al,%al
  8002e9:	74 0d                	je     8002f8 <libmain+0x4f>
		binaryname = myEnv->prog_name;
  8002eb:	a1 20 30 80 00       	mov    0x803020,%eax
  8002f0:	83 c0 20             	add    $0x20,%eax
  8002f3:	a3 04 30 80 00       	mov    %eax,0x803004

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8002f8:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8002fc:	7e 0a                	jle    800308 <libmain+0x5f>
		binaryname = argv[0];
  8002fe:	8b 45 0c             	mov    0xc(%ebp),%eax
  800301:	8b 00                	mov    (%eax),%eax
  800303:	a3 04 30 80 00       	mov    %eax,0x803004

	// call user main routine
	_main(argc, argv);
  800308:	83 ec 08             	sub    $0x8,%esp
  80030b:	ff 75 0c             	pushl  0xc(%ebp)
  80030e:	ff 75 08             	pushl  0x8(%ebp)
  800311:	e8 22 fd ff ff       	call   800038 <_main>
  800316:	83 c4 10             	add    $0x10,%esp

	if (printStats)
  800319:	a1 00 30 80 00       	mov    0x803000,%eax
  80031e:	85 c0                	test   %eax,%eax
  800320:	0f 84 01 01 00 00    	je     800427 <libmain+0x17e>
	{
		char isOPTReplCmd[100] = "__IsOPTRepl__" ;
  800326:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  80032c:	bb bc 24 80 00       	mov    $0x8024bc,%ebx
  800331:	ba 0e 00 00 00       	mov    $0xe,%edx
  800336:	89 c7                	mov    %eax,%edi
  800338:	89 de                	mov    %ebx,%esi
  80033a:	89 d1                	mov    %edx,%ecx
  80033c:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  80033e:	8d 55 8a             	lea    -0x76(%ebp),%edx
  800341:	b9 56 00 00 00       	mov    $0x56,%ecx
  800346:	b0 00                	mov    $0x0,%al
  800348:	89 d7                	mov    %edx,%edi
  80034a:	f3 aa                	rep stos %al,%es:(%edi)
		int isOPTRepl = 0;
  80034c:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
		sys_utilities(isOPTReplCmd, (uint32)(&isOPTRepl));
  800353:	8d 45 e0             	lea    -0x20(%ebp),%eax
  800356:	83 ec 08             	sub    $0x8,%esp
  800359:	50                   	push   %eax
  80035a:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  800360:	50                   	push   %eax
  800361:	e8 cc 19 00 00       	call   801d32 <sys_utilities>
  800366:	83 c4 10             	add    $0x10,%esp

		sys_lock_cons();
  800369:	e8 15 15 00 00       	call   801883 <sys_lock_cons>
		{
			cprintf("**************************************\n");
  80036e:	83 ec 0c             	sub    $0xc,%esp
  800371:	68 dc 23 80 00       	push   $0x8023dc
  800376:	e8 ac 03 00 00       	call   800727 <cprintf>
  80037b:	83 c4 10             	add    $0x10,%esp
			if (isOPTRepl)
  80037e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800381:	85 c0                	test   %eax,%eax
  800383:	74 18                	je     80039d <libmain+0xf4>
			{
				cprintf("OPTIMAL number of page faults = %d\n", sys_get_optimal_num_faults());
  800385:	e8 c6 19 00 00       	call   801d50 <sys_get_optimal_num_faults>
  80038a:	83 ec 08             	sub    $0x8,%esp
  80038d:	50                   	push   %eax
  80038e:	68 04 24 80 00       	push   $0x802404
  800393:	e8 8f 03 00 00       	call   800727 <cprintf>
  800398:	83 c4 10             	add    $0x10,%esp
  80039b:	eb 59                	jmp    8003f6 <libmain+0x14d>
			}
			else
			{
				cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  80039d:	a1 20 30 80 00       	mov    0x803020,%eax
  8003a2:	8b 90 a8 05 00 00    	mov    0x5a8(%eax),%edx
  8003a8:	a1 20 30 80 00       	mov    0x803020,%eax
  8003ad:	8b 80 98 05 00 00    	mov    0x598(%eax),%eax
  8003b3:	83 ec 04             	sub    $0x4,%esp
  8003b6:	52                   	push   %edx
  8003b7:	50                   	push   %eax
  8003b8:	68 28 24 80 00       	push   $0x802428
  8003bd:	e8 65 03 00 00       	call   800727 <cprintf>
  8003c2:	83 c4 10             	add    $0x10,%esp
				cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  8003c5:	a1 20 30 80 00       	mov    0x803020,%eax
  8003ca:	8b 88 bc 05 00 00    	mov    0x5bc(%eax),%ecx
  8003d0:	a1 20 30 80 00       	mov    0x803020,%eax
  8003d5:	8b 90 b8 05 00 00    	mov    0x5b8(%eax),%edx
  8003db:	a1 20 30 80 00       	mov    0x803020,%eax
  8003e0:	8b 80 b4 05 00 00    	mov    0x5b4(%eax),%eax
  8003e6:	51                   	push   %ecx
  8003e7:	52                   	push   %edx
  8003e8:	50                   	push   %eax
  8003e9:	68 50 24 80 00       	push   $0x802450
  8003ee:	e8 34 03 00 00       	call   800727 <cprintf>
  8003f3:	83 c4 10             	add    $0x10,%esp
			}
			//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
			cprintf("Num of clocks = %d\n", myEnv->nClocks);
  8003f6:	a1 20 30 80 00       	mov    0x803020,%eax
  8003fb:	8b 80 c0 05 00 00    	mov    0x5c0(%eax),%eax
  800401:	83 ec 08             	sub    $0x8,%esp
  800404:	50                   	push   %eax
  800405:	68 a8 24 80 00       	push   $0x8024a8
  80040a:	e8 18 03 00 00       	call   800727 <cprintf>
  80040f:	83 c4 10             	add    $0x10,%esp
			cprintf("**************************************\n");
  800412:	83 ec 0c             	sub    $0xc,%esp
  800415:	68 dc 23 80 00       	push   $0x8023dc
  80041a:	e8 08 03 00 00       	call   800727 <cprintf>
  80041f:	83 c4 10             	add    $0x10,%esp
		}
		sys_unlock_cons();
  800422:	e8 76 14 00 00       	call   80189d <sys_unlock_cons>
	}

	// exit gracefully
	exit();
  800427:	e8 1f 00 00 00       	call   80044b <exit>
}
  80042c:	90                   	nop
  80042d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800430:	5b                   	pop    %ebx
  800431:	5e                   	pop    %esi
  800432:	5f                   	pop    %edi
  800433:	5d                   	pop    %ebp
  800434:	c3                   	ret    

00800435 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800435:	55                   	push   %ebp
  800436:	89 e5                	mov    %esp,%ebp
  800438:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  80043b:	83 ec 0c             	sub    $0xc,%esp
  80043e:	6a 00                	push   $0x0
  800440:	e8 83 16 00 00       	call   801ac8 <sys_destroy_env>
  800445:	83 c4 10             	add    $0x10,%esp
}
  800448:	90                   	nop
  800449:	c9                   	leave  
  80044a:	c3                   	ret    

0080044b <exit>:

void
exit(void)
{
  80044b:	55                   	push   %ebp
  80044c:	89 e5                	mov    %esp,%ebp
  80044e:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  800451:	e8 d8 16 00 00       	call   801b2e <sys_exit_env>
}
  800456:	90                   	nop
  800457:	c9                   	leave  
  800458:	c3                   	ret    

00800459 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  800459:	55                   	push   %ebp
  80045a:	89 e5                	mov    %esp,%ebp
  80045c:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  80045f:	8d 45 10             	lea    0x10(%ebp),%eax
  800462:	83 c0 04             	add    $0x4,%eax
  800465:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  800468:	a1 18 b1 81 00       	mov    0x81b118,%eax
  80046d:	85 c0                	test   %eax,%eax
  80046f:	74 16                	je     800487 <_panic+0x2e>
		cprintf("%s: ", argv0);
  800471:	a1 18 b1 81 00       	mov    0x81b118,%eax
  800476:	83 ec 08             	sub    $0x8,%esp
  800479:	50                   	push   %eax
  80047a:	68 20 25 80 00       	push   $0x802520
  80047f:	e8 a3 02 00 00       	call   800727 <cprintf>
  800484:	83 c4 10             	add    $0x10,%esp
	cprintf_colored(TEXT_PANIC_CLR, "user [EVAL_FINAL]panic in %s at %s:%d: ", binaryname, file, line);
  800487:	a1 04 30 80 00       	mov    0x803004,%eax
  80048c:	83 ec 0c             	sub    $0xc,%esp
  80048f:	ff 75 0c             	pushl  0xc(%ebp)
  800492:	ff 75 08             	pushl  0x8(%ebp)
  800495:	50                   	push   %eax
  800496:	68 28 25 80 00       	push   $0x802528
  80049b:	6a 74                	push   $0x74
  80049d:	e8 b2 02 00 00       	call   800754 <cprintf_colored>
  8004a2:	83 c4 20             	add    $0x20,%esp
	vcprintf(fmt, ap);
  8004a5:	8b 45 10             	mov    0x10(%ebp),%eax
  8004a8:	83 ec 08             	sub    $0x8,%esp
  8004ab:	ff 75 f4             	pushl  -0xc(%ebp)
  8004ae:	50                   	push   %eax
  8004af:	e8 04 02 00 00       	call   8006b8 <vcprintf>
  8004b4:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  8004b7:	83 ec 08             	sub    $0x8,%esp
  8004ba:	6a 00                	push   $0x0
  8004bc:	68 50 25 80 00       	push   $0x802550
  8004c1:	e8 f2 01 00 00       	call   8006b8 <vcprintf>
  8004c6:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  8004c9:	e8 7d ff ff ff       	call   80044b <exit>

	// should not return here
	while (1) ;
  8004ce:	eb fe                	jmp    8004ce <_panic+0x75>

008004d0 <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  8004d0:	55                   	push   %ebp
  8004d1:	89 e5                	mov    %esp,%ebp
  8004d3:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  8004d6:	a1 20 30 80 00       	mov    0x803020,%eax
  8004db:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  8004e1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004e4:	39 c2                	cmp    %eax,%edx
  8004e6:	74 14                	je     8004fc <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  8004e8:	83 ec 04             	sub    $0x4,%esp
  8004eb:	68 54 25 80 00       	push   $0x802554
  8004f0:	6a 26                	push   $0x26
  8004f2:	68 a0 25 80 00       	push   $0x8025a0
  8004f7:	e8 5d ff ff ff       	call   800459 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  8004fc:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  800503:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80050a:	e9 c5 00 00 00       	jmp    8005d4 <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  80050f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800512:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800519:	8b 45 08             	mov    0x8(%ebp),%eax
  80051c:	01 d0                	add    %edx,%eax
  80051e:	8b 00                	mov    (%eax),%eax
  800520:	85 c0                	test   %eax,%eax
  800522:	75 08                	jne    80052c <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  800524:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  800527:	e9 a5 00 00 00       	jmp    8005d1 <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  80052c:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800533:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  80053a:	eb 69                	jmp    8005a5 <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  80053c:	a1 20 30 80 00       	mov    0x803020,%eax
  800541:	8b 88 90 05 00 00    	mov    0x590(%eax),%ecx
  800547:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80054a:	89 d0                	mov    %edx,%eax
  80054c:	01 c0                	add    %eax,%eax
  80054e:	01 d0                	add    %edx,%eax
  800550:	c1 e0 03             	shl    $0x3,%eax
  800553:	01 c8                	add    %ecx,%eax
  800555:	8a 40 04             	mov    0x4(%eax),%al
  800558:	84 c0                	test   %al,%al
  80055a:	75 46                	jne    8005a2 <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  80055c:	a1 20 30 80 00       	mov    0x803020,%eax
  800561:	8b 88 90 05 00 00    	mov    0x590(%eax),%ecx
  800567:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80056a:	89 d0                	mov    %edx,%eax
  80056c:	01 c0                	add    %eax,%eax
  80056e:	01 d0                	add    %edx,%eax
  800570:	c1 e0 03             	shl    $0x3,%eax
  800573:	01 c8                	add    %ecx,%eax
  800575:	8b 00                	mov    (%eax),%eax
  800577:	89 45 dc             	mov    %eax,-0x24(%ebp)
  80057a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80057d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800582:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  800584:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800587:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  80058e:	8b 45 08             	mov    0x8(%ebp),%eax
  800591:	01 c8                	add    %ecx,%eax
  800593:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800595:	39 c2                	cmp    %eax,%edx
  800597:	75 09                	jne    8005a2 <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  800599:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  8005a0:	eb 15                	jmp    8005b7 <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8005a2:	ff 45 e8             	incl   -0x18(%ebp)
  8005a5:	a1 20 30 80 00       	mov    0x803020,%eax
  8005aa:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  8005b0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8005b3:	39 c2                	cmp    %eax,%edx
  8005b5:	77 85                	ja     80053c <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  8005b7:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8005bb:	75 14                	jne    8005d1 <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  8005bd:	83 ec 04             	sub    $0x4,%esp
  8005c0:	68 ac 25 80 00       	push   $0x8025ac
  8005c5:	6a 3a                	push   $0x3a
  8005c7:	68 a0 25 80 00       	push   $0x8025a0
  8005cc:	e8 88 fe ff ff       	call   800459 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  8005d1:	ff 45 f0             	incl   -0x10(%ebp)
  8005d4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8005d7:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8005da:	0f 8c 2f ff ff ff    	jl     80050f <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  8005e0:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8005e7:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  8005ee:	eb 26                	jmp    800616 <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  8005f0:	a1 20 30 80 00       	mov    0x803020,%eax
  8005f5:	8b 88 90 05 00 00    	mov    0x590(%eax),%ecx
  8005fb:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8005fe:	89 d0                	mov    %edx,%eax
  800600:	01 c0                	add    %eax,%eax
  800602:	01 d0                	add    %edx,%eax
  800604:	c1 e0 03             	shl    $0x3,%eax
  800607:	01 c8                	add    %ecx,%eax
  800609:	8a 40 04             	mov    0x4(%eax),%al
  80060c:	3c 01                	cmp    $0x1,%al
  80060e:	75 03                	jne    800613 <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  800610:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800613:	ff 45 e0             	incl   -0x20(%ebp)
  800616:	a1 20 30 80 00       	mov    0x803020,%eax
  80061b:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  800621:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800624:	39 c2                	cmp    %eax,%edx
  800626:	77 c8                	ja     8005f0 <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  800628:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80062b:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  80062e:	74 14                	je     800644 <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  800630:	83 ec 04             	sub    $0x4,%esp
  800633:	68 00 26 80 00       	push   $0x802600
  800638:	6a 44                	push   $0x44
  80063a:	68 a0 25 80 00       	push   $0x8025a0
  80063f:	e8 15 fe ff ff       	call   800459 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  800644:	90                   	nop
  800645:	c9                   	leave  
  800646:	c3                   	ret    

00800647 <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  800647:	55                   	push   %ebp
  800648:	89 e5                	mov    %esp,%ebp
  80064a:	53                   	push   %ebx
  80064b:	83 ec 04             	sub    $0x4,%esp
	b->buf[b->idx++] = ch;
  80064e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800651:	8b 00                	mov    (%eax),%eax
  800653:	8d 48 01             	lea    0x1(%eax),%ecx
  800656:	8b 55 0c             	mov    0xc(%ebp),%edx
  800659:	89 0a                	mov    %ecx,(%edx)
  80065b:	8b 55 08             	mov    0x8(%ebp),%edx
  80065e:	88 d1                	mov    %dl,%cl
  800660:	8b 55 0c             	mov    0xc(%ebp),%edx
  800663:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800667:	8b 45 0c             	mov    0xc(%ebp),%eax
  80066a:	8b 00                	mov    (%eax),%eax
  80066c:	3d ff 00 00 00       	cmp    $0xff,%eax
  800671:	75 30                	jne    8006a3 <putch+0x5c>
		sys_cputs(b->buf, b->idx, printProgName, curTextClr);
  800673:	8b 15 1c b1 81 00    	mov    0x81b11c,%edx
  800679:	a0 44 30 80 00       	mov    0x803044,%al
  80067e:	0f b6 c0             	movzbl %al,%eax
  800681:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800684:	8b 09                	mov    (%ecx),%ecx
  800686:	89 cb                	mov    %ecx,%ebx
  800688:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80068b:	83 c1 08             	add    $0x8,%ecx
  80068e:	52                   	push   %edx
  80068f:	50                   	push   %eax
  800690:	53                   	push   %ebx
  800691:	51                   	push   %ecx
  800692:	e8 a8 11 00 00       	call   80183f <sys_cputs>
  800697:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  80069a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80069d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8006a3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006a6:	8b 40 04             	mov    0x4(%eax),%eax
  8006a9:	8d 50 01             	lea    0x1(%eax),%edx
  8006ac:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006af:	89 50 04             	mov    %edx,0x4(%eax)
}
  8006b2:	90                   	nop
  8006b3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8006b6:	c9                   	leave  
  8006b7:	c3                   	ret    

008006b8 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  8006b8:	55                   	push   %ebp
  8006b9:	89 e5                	mov    %esp,%ebp
  8006bb:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8006c1:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8006c8:	00 00 00 
	b.cnt = 0;
  8006cb:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8006d2:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  8006d5:	ff 75 0c             	pushl  0xc(%ebp)
  8006d8:	ff 75 08             	pushl  0x8(%ebp)
  8006db:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8006e1:	50                   	push   %eax
  8006e2:	68 47 06 80 00       	push   $0x800647
  8006e7:	e8 5a 02 00 00       	call   800946 <vprintfmt>
  8006ec:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName, curTextClr);
  8006ef:	8b 15 1c b1 81 00    	mov    0x81b11c,%edx
  8006f5:	a0 44 30 80 00       	mov    0x803044,%al
  8006fa:	0f b6 c0             	movzbl %al,%eax
  8006fd:	8b 8d f0 fe ff ff    	mov    -0x110(%ebp),%ecx
  800703:	52                   	push   %edx
  800704:	50                   	push   %eax
  800705:	51                   	push   %ecx
  800706:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80070c:	83 c0 08             	add    $0x8,%eax
  80070f:	50                   	push   %eax
  800710:	e8 2a 11 00 00       	call   80183f <sys_cputs>
  800715:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800718:	c6 05 44 30 80 00 00 	movb   $0x0,0x803044
	return b.cnt;
  80071f:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800725:	c9                   	leave  
  800726:	c3                   	ret    

00800727 <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  800727:	55                   	push   %ebp
  800728:	89 e5                	mov    %esp,%ebp
  80072a:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  80072d:	c6 05 44 30 80 00 01 	movb   $0x1,0x803044
	va_start(ap, fmt);
  800734:	8d 45 0c             	lea    0xc(%ebp),%eax
  800737:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  80073a:	8b 45 08             	mov    0x8(%ebp),%eax
  80073d:	83 ec 08             	sub    $0x8,%esp
  800740:	ff 75 f4             	pushl  -0xc(%ebp)
  800743:	50                   	push   %eax
  800744:	e8 6f ff ff ff       	call   8006b8 <vcprintf>
  800749:	83 c4 10             	add    $0x10,%esp
  80074c:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  80074f:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800752:	c9                   	leave  
  800753:	c3                   	ret    

00800754 <cprintf_colored>:

// *************** This text coloring feature is implemented by *************
// ********** Abd-Alrahman Zedan From Team Frozen-Bytes - FCIS'24-25 ********
int cprintf_colored(int textClr, const char *fmt, ...) {
  800754:	55                   	push   %ebp
  800755:	89 e5                	mov    %esp,%ebp
  800757:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  80075a:	c6 05 44 30 80 00 01 	movb   $0x1,0x803044
	curTextClr = (textClr << 8) ; //set text color by the given value
  800761:	8b 45 08             	mov    0x8(%ebp),%eax
  800764:	c1 e0 08             	shl    $0x8,%eax
  800767:	a3 1c b1 81 00       	mov    %eax,0x81b11c
	va_start(ap, fmt);
  80076c:	8d 45 0c             	lea    0xc(%ebp),%eax
  80076f:	83 c0 04             	add    $0x4,%eax
  800772:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800775:	8b 45 0c             	mov    0xc(%ebp),%eax
  800778:	83 ec 08             	sub    $0x8,%esp
  80077b:	ff 75 f4             	pushl  -0xc(%ebp)
  80077e:	50                   	push   %eax
  80077f:	e8 34 ff ff ff       	call   8006b8 <vcprintf>
  800784:	83 c4 10             	add    $0x10,%esp
  800787:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);
	curTextClr = TEXT_DEFAULT_CLR; //restore default color
  80078a:	c7 05 1c b1 81 00 00 	movl   $0x700,0x81b11c
  800791:	07 00 00 

	return cnt;
  800794:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800797:	c9                   	leave  
  800798:	c3                   	ret    

00800799 <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  800799:	55                   	push   %ebp
  80079a:	89 e5                	mov    %esp,%ebp
  80079c:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  80079f:	e8 df 10 00 00       	call   801883 <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  8007a4:	8d 45 0c             	lea    0xc(%ebp),%eax
  8007a7:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  8007aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8007ad:	83 ec 08             	sub    $0x8,%esp
  8007b0:	ff 75 f4             	pushl  -0xc(%ebp)
  8007b3:	50                   	push   %eax
  8007b4:	e8 ff fe ff ff       	call   8006b8 <vcprintf>
  8007b9:	83 c4 10             	add    $0x10,%esp
  8007bc:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  8007bf:	e8 d9 10 00 00       	call   80189d <sys_unlock_cons>
	return cnt;
  8007c4:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8007c7:	c9                   	leave  
  8007c8:	c3                   	ret    

008007c9 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8007c9:	55                   	push   %ebp
  8007ca:	89 e5                	mov    %esp,%ebp
  8007cc:	53                   	push   %ebx
  8007cd:	83 ec 14             	sub    $0x14,%esp
  8007d0:	8b 45 10             	mov    0x10(%ebp),%eax
  8007d3:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8007d6:	8b 45 14             	mov    0x14(%ebp),%eax
  8007d9:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8007dc:	8b 45 18             	mov    0x18(%ebp),%eax
  8007df:	ba 00 00 00 00       	mov    $0x0,%edx
  8007e4:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8007e7:	77 55                	ja     80083e <printnum+0x75>
  8007e9:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8007ec:	72 05                	jb     8007f3 <printnum+0x2a>
  8007ee:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8007f1:	77 4b                	ja     80083e <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8007f3:	8b 45 1c             	mov    0x1c(%ebp),%eax
  8007f6:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8007f9:	8b 45 18             	mov    0x18(%ebp),%eax
  8007fc:	ba 00 00 00 00       	mov    $0x0,%edx
  800801:	52                   	push   %edx
  800802:	50                   	push   %eax
  800803:	ff 75 f4             	pushl  -0xc(%ebp)
  800806:	ff 75 f0             	pushl  -0x10(%ebp)
  800809:	e8 aa 16 00 00       	call   801eb8 <__udivdi3>
  80080e:	83 c4 10             	add    $0x10,%esp
  800811:	83 ec 04             	sub    $0x4,%esp
  800814:	ff 75 20             	pushl  0x20(%ebp)
  800817:	53                   	push   %ebx
  800818:	ff 75 18             	pushl  0x18(%ebp)
  80081b:	52                   	push   %edx
  80081c:	50                   	push   %eax
  80081d:	ff 75 0c             	pushl  0xc(%ebp)
  800820:	ff 75 08             	pushl  0x8(%ebp)
  800823:	e8 a1 ff ff ff       	call   8007c9 <printnum>
  800828:	83 c4 20             	add    $0x20,%esp
  80082b:	eb 1a                	jmp    800847 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  80082d:	83 ec 08             	sub    $0x8,%esp
  800830:	ff 75 0c             	pushl  0xc(%ebp)
  800833:	ff 75 20             	pushl  0x20(%ebp)
  800836:	8b 45 08             	mov    0x8(%ebp),%eax
  800839:	ff d0                	call   *%eax
  80083b:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80083e:	ff 4d 1c             	decl   0x1c(%ebp)
  800841:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800845:	7f e6                	jg     80082d <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800847:	8b 4d 18             	mov    0x18(%ebp),%ecx
  80084a:	bb 00 00 00 00       	mov    $0x0,%ebx
  80084f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800852:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800855:	53                   	push   %ebx
  800856:	51                   	push   %ecx
  800857:	52                   	push   %edx
  800858:	50                   	push   %eax
  800859:	e8 6a 17 00 00       	call   801fc8 <__umoddi3>
  80085e:	83 c4 10             	add    $0x10,%esp
  800861:	05 74 28 80 00       	add    $0x802874,%eax
  800866:	8a 00                	mov    (%eax),%al
  800868:	0f be c0             	movsbl %al,%eax
  80086b:	83 ec 08             	sub    $0x8,%esp
  80086e:	ff 75 0c             	pushl  0xc(%ebp)
  800871:	50                   	push   %eax
  800872:	8b 45 08             	mov    0x8(%ebp),%eax
  800875:	ff d0                	call   *%eax
  800877:	83 c4 10             	add    $0x10,%esp
}
  80087a:	90                   	nop
  80087b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80087e:	c9                   	leave  
  80087f:	c3                   	ret    

00800880 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800880:	55                   	push   %ebp
  800881:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800883:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800887:	7e 1c                	jle    8008a5 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800889:	8b 45 08             	mov    0x8(%ebp),%eax
  80088c:	8b 00                	mov    (%eax),%eax
  80088e:	8d 50 08             	lea    0x8(%eax),%edx
  800891:	8b 45 08             	mov    0x8(%ebp),%eax
  800894:	89 10                	mov    %edx,(%eax)
  800896:	8b 45 08             	mov    0x8(%ebp),%eax
  800899:	8b 00                	mov    (%eax),%eax
  80089b:	83 e8 08             	sub    $0x8,%eax
  80089e:	8b 50 04             	mov    0x4(%eax),%edx
  8008a1:	8b 00                	mov    (%eax),%eax
  8008a3:	eb 40                	jmp    8008e5 <getuint+0x65>
	else if (lflag)
  8008a5:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8008a9:	74 1e                	je     8008c9 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  8008ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8008ae:	8b 00                	mov    (%eax),%eax
  8008b0:	8d 50 04             	lea    0x4(%eax),%edx
  8008b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8008b6:	89 10                	mov    %edx,(%eax)
  8008b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8008bb:	8b 00                	mov    (%eax),%eax
  8008bd:	83 e8 04             	sub    $0x4,%eax
  8008c0:	8b 00                	mov    (%eax),%eax
  8008c2:	ba 00 00 00 00       	mov    $0x0,%edx
  8008c7:	eb 1c                	jmp    8008e5 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  8008c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8008cc:	8b 00                	mov    (%eax),%eax
  8008ce:	8d 50 04             	lea    0x4(%eax),%edx
  8008d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8008d4:	89 10                	mov    %edx,(%eax)
  8008d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8008d9:	8b 00                	mov    (%eax),%eax
  8008db:	83 e8 04             	sub    $0x4,%eax
  8008de:	8b 00                	mov    (%eax),%eax
  8008e0:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8008e5:	5d                   	pop    %ebp
  8008e6:	c3                   	ret    

008008e7 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8008e7:	55                   	push   %ebp
  8008e8:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8008ea:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8008ee:	7e 1c                	jle    80090c <getint+0x25>
		return va_arg(*ap, long long);
  8008f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8008f3:	8b 00                	mov    (%eax),%eax
  8008f5:	8d 50 08             	lea    0x8(%eax),%edx
  8008f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8008fb:	89 10                	mov    %edx,(%eax)
  8008fd:	8b 45 08             	mov    0x8(%ebp),%eax
  800900:	8b 00                	mov    (%eax),%eax
  800902:	83 e8 08             	sub    $0x8,%eax
  800905:	8b 50 04             	mov    0x4(%eax),%edx
  800908:	8b 00                	mov    (%eax),%eax
  80090a:	eb 38                	jmp    800944 <getint+0x5d>
	else if (lflag)
  80090c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800910:	74 1a                	je     80092c <getint+0x45>
		return va_arg(*ap, long);
  800912:	8b 45 08             	mov    0x8(%ebp),%eax
  800915:	8b 00                	mov    (%eax),%eax
  800917:	8d 50 04             	lea    0x4(%eax),%edx
  80091a:	8b 45 08             	mov    0x8(%ebp),%eax
  80091d:	89 10                	mov    %edx,(%eax)
  80091f:	8b 45 08             	mov    0x8(%ebp),%eax
  800922:	8b 00                	mov    (%eax),%eax
  800924:	83 e8 04             	sub    $0x4,%eax
  800927:	8b 00                	mov    (%eax),%eax
  800929:	99                   	cltd   
  80092a:	eb 18                	jmp    800944 <getint+0x5d>
	else
		return va_arg(*ap, int);
  80092c:	8b 45 08             	mov    0x8(%ebp),%eax
  80092f:	8b 00                	mov    (%eax),%eax
  800931:	8d 50 04             	lea    0x4(%eax),%edx
  800934:	8b 45 08             	mov    0x8(%ebp),%eax
  800937:	89 10                	mov    %edx,(%eax)
  800939:	8b 45 08             	mov    0x8(%ebp),%eax
  80093c:	8b 00                	mov    (%eax),%eax
  80093e:	83 e8 04             	sub    $0x4,%eax
  800941:	8b 00                	mov    (%eax),%eax
  800943:	99                   	cltd   
}
  800944:	5d                   	pop    %ebp
  800945:	c3                   	ret    

00800946 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800946:	55                   	push   %ebp
  800947:	89 e5                	mov    %esp,%ebp
  800949:	56                   	push   %esi
  80094a:	53                   	push   %ebx
  80094b:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80094e:	eb 17                	jmp    800967 <vprintfmt+0x21>
			if (ch == '\0')
  800950:	85 db                	test   %ebx,%ebx
  800952:	0f 84 c1 03 00 00    	je     800d19 <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  800958:	83 ec 08             	sub    $0x8,%esp
  80095b:	ff 75 0c             	pushl  0xc(%ebp)
  80095e:	53                   	push   %ebx
  80095f:	8b 45 08             	mov    0x8(%ebp),%eax
  800962:	ff d0                	call   *%eax
  800964:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800967:	8b 45 10             	mov    0x10(%ebp),%eax
  80096a:	8d 50 01             	lea    0x1(%eax),%edx
  80096d:	89 55 10             	mov    %edx,0x10(%ebp)
  800970:	8a 00                	mov    (%eax),%al
  800972:	0f b6 d8             	movzbl %al,%ebx
  800975:	83 fb 25             	cmp    $0x25,%ebx
  800978:	75 d6                	jne    800950 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  80097a:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  80097e:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800985:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  80098c:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800993:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80099a:	8b 45 10             	mov    0x10(%ebp),%eax
  80099d:	8d 50 01             	lea    0x1(%eax),%edx
  8009a0:	89 55 10             	mov    %edx,0x10(%ebp)
  8009a3:	8a 00                	mov    (%eax),%al
  8009a5:	0f b6 d8             	movzbl %al,%ebx
  8009a8:	8d 43 dd             	lea    -0x23(%ebx),%eax
  8009ab:	83 f8 5b             	cmp    $0x5b,%eax
  8009ae:	0f 87 3d 03 00 00    	ja     800cf1 <vprintfmt+0x3ab>
  8009b4:	8b 04 85 98 28 80 00 	mov    0x802898(,%eax,4),%eax
  8009bb:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  8009bd:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  8009c1:	eb d7                	jmp    80099a <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8009c3:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  8009c7:	eb d1                	jmp    80099a <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8009c9:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  8009d0:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8009d3:	89 d0                	mov    %edx,%eax
  8009d5:	c1 e0 02             	shl    $0x2,%eax
  8009d8:	01 d0                	add    %edx,%eax
  8009da:	01 c0                	add    %eax,%eax
  8009dc:	01 d8                	add    %ebx,%eax
  8009de:	83 e8 30             	sub    $0x30,%eax
  8009e1:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  8009e4:	8b 45 10             	mov    0x10(%ebp),%eax
  8009e7:	8a 00                	mov    (%eax),%al
  8009e9:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8009ec:	83 fb 2f             	cmp    $0x2f,%ebx
  8009ef:	7e 3e                	jle    800a2f <vprintfmt+0xe9>
  8009f1:	83 fb 39             	cmp    $0x39,%ebx
  8009f4:	7f 39                	jg     800a2f <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8009f6:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8009f9:	eb d5                	jmp    8009d0 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8009fb:	8b 45 14             	mov    0x14(%ebp),%eax
  8009fe:	83 c0 04             	add    $0x4,%eax
  800a01:	89 45 14             	mov    %eax,0x14(%ebp)
  800a04:	8b 45 14             	mov    0x14(%ebp),%eax
  800a07:	83 e8 04             	sub    $0x4,%eax
  800a0a:	8b 00                	mov    (%eax),%eax
  800a0c:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800a0f:	eb 1f                	jmp    800a30 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800a11:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a15:	79 83                	jns    80099a <vprintfmt+0x54>
				width = 0;
  800a17:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800a1e:	e9 77 ff ff ff       	jmp    80099a <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800a23:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800a2a:	e9 6b ff ff ff       	jmp    80099a <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800a2f:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800a30:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a34:	0f 89 60 ff ff ff    	jns    80099a <vprintfmt+0x54>
				width = precision, precision = -1;
  800a3a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800a3d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800a40:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800a47:	e9 4e ff ff ff       	jmp    80099a <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800a4c:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800a4f:	e9 46 ff ff ff       	jmp    80099a <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800a54:	8b 45 14             	mov    0x14(%ebp),%eax
  800a57:	83 c0 04             	add    $0x4,%eax
  800a5a:	89 45 14             	mov    %eax,0x14(%ebp)
  800a5d:	8b 45 14             	mov    0x14(%ebp),%eax
  800a60:	83 e8 04             	sub    $0x4,%eax
  800a63:	8b 00                	mov    (%eax),%eax
  800a65:	83 ec 08             	sub    $0x8,%esp
  800a68:	ff 75 0c             	pushl  0xc(%ebp)
  800a6b:	50                   	push   %eax
  800a6c:	8b 45 08             	mov    0x8(%ebp),%eax
  800a6f:	ff d0                	call   *%eax
  800a71:	83 c4 10             	add    $0x10,%esp
			break;
  800a74:	e9 9b 02 00 00       	jmp    800d14 <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800a79:	8b 45 14             	mov    0x14(%ebp),%eax
  800a7c:	83 c0 04             	add    $0x4,%eax
  800a7f:	89 45 14             	mov    %eax,0x14(%ebp)
  800a82:	8b 45 14             	mov    0x14(%ebp),%eax
  800a85:	83 e8 04             	sub    $0x4,%eax
  800a88:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800a8a:	85 db                	test   %ebx,%ebx
  800a8c:	79 02                	jns    800a90 <vprintfmt+0x14a>
				err = -err;
  800a8e:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800a90:	83 fb 64             	cmp    $0x64,%ebx
  800a93:	7f 0b                	jg     800aa0 <vprintfmt+0x15a>
  800a95:	8b 34 9d e0 26 80 00 	mov    0x8026e0(,%ebx,4),%esi
  800a9c:	85 f6                	test   %esi,%esi
  800a9e:	75 19                	jne    800ab9 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800aa0:	53                   	push   %ebx
  800aa1:	68 85 28 80 00       	push   $0x802885
  800aa6:	ff 75 0c             	pushl  0xc(%ebp)
  800aa9:	ff 75 08             	pushl  0x8(%ebp)
  800aac:	e8 70 02 00 00       	call   800d21 <printfmt>
  800ab1:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800ab4:	e9 5b 02 00 00       	jmp    800d14 <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800ab9:	56                   	push   %esi
  800aba:	68 8e 28 80 00       	push   $0x80288e
  800abf:	ff 75 0c             	pushl  0xc(%ebp)
  800ac2:	ff 75 08             	pushl  0x8(%ebp)
  800ac5:	e8 57 02 00 00       	call   800d21 <printfmt>
  800aca:	83 c4 10             	add    $0x10,%esp
			break;
  800acd:	e9 42 02 00 00       	jmp    800d14 <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800ad2:	8b 45 14             	mov    0x14(%ebp),%eax
  800ad5:	83 c0 04             	add    $0x4,%eax
  800ad8:	89 45 14             	mov    %eax,0x14(%ebp)
  800adb:	8b 45 14             	mov    0x14(%ebp),%eax
  800ade:	83 e8 04             	sub    $0x4,%eax
  800ae1:	8b 30                	mov    (%eax),%esi
  800ae3:	85 f6                	test   %esi,%esi
  800ae5:	75 05                	jne    800aec <vprintfmt+0x1a6>
				p = "(null)";
  800ae7:	be 91 28 80 00       	mov    $0x802891,%esi
			if (width > 0 && padc != '-')
  800aec:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800af0:	7e 6d                	jle    800b5f <vprintfmt+0x219>
  800af2:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800af6:	74 67                	je     800b5f <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800af8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800afb:	83 ec 08             	sub    $0x8,%esp
  800afe:	50                   	push   %eax
  800aff:	56                   	push   %esi
  800b00:	e8 26 05 00 00       	call   80102b <strnlen>
  800b05:	83 c4 10             	add    $0x10,%esp
  800b08:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800b0b:	eb 16                	jmp    800b23 <vprintfmt+0x1dd>
					putch(padc, putdat);
  800b0d:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800b11:	83 ec 08             	sub    $0x8,%esp
  800b14:	ff 75 0c             	pushl  0xc(%ebp)
  800b17:	50                   	push   %eax
  800b18:	8b 45 08             	mov    0x8(%ebp),%eax
  800b1b:	ff d0                	call   *%eax
  800b1d:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800b20:	ff 4d e4             	decl   -0x1c(%ebp)
  800b23:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800b27:	7f e4                	jg     800b0d <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800b29:	eb 34                	jmp    800b5f <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800b2b:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800b2f:	74 1c                	je     800b4d <vprintfmt+0x207>
  800b31:	83 fb 1f             	cmp    $0x1f,%ebx
  800b34:	7e 05                	jle    800b3b <vprintfmt+0x1f5>
  800b36:	83 fb 7e             	cmp    $0x7e,%ebx
  800b39:	7e 12                	jle    800b4d <vprintfmt+0x207>
					putch('?', putdat);
  800b3b:	83 ec 08             	sub    $0x8,%esp
  800b3e:	ff 75 0c             	pushl  0xc(%ebp)
  800b41:	6a 3f                	push   $0x3f
  800b43:	8b 45 08             	mov    0x8(%ebp),%eax
  800b46:	ff d0                	call   *%eax
  800b48:	83 c4 10             	add    $0x10,%esp
  800b4b:	eb 0f                	jmp    800b5c <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800b4d:	83 ec 08             	sub    $0x8,%esp
  800b50:	ff 75 0c             	pushl  0xc(%ebp)
  800b53:	53                   	push   %ebx
  800b54:	8b 45 08             	mov    0x8(%ebp),%eax
  800b57:	ff d0                	call   *%eax
  800b59:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800b5c:	ff 4d e4             	decl   -0x1c(%ebp)
  800b5f:	89 f0                	mov    %esi,%eax
  800b61:	8d 70 01             	lea    0x1(%eax),%esi
  800b64:	8a 00                	mov    (%eax),%al
  800b66:	0f be d8             	movsbl %al,%ebx
  800b69:	85 db                	test   %ebx,%ebx
  800b6b:	74 24                	je     800b91 <vprintfmt+0x24b>
  800b6d:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800b71:	78 b8                	js     800b2b <vprintfmt+0x1e5>
  800b73:	ff 4d e0             	decl   -0x20(%ebp)
  800b76:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800b7a:	79 af                	jns    800b2b <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800b7c:	eb 13                	jmp    800b91 <vprintfmt+0x24b>
				putch(' ', putdat);
  800b7e:	83 ec 08             	sub    $0x8,%esp
  800b81:	ff 75 0c             	pushl  0xc(%ebp)
  800b84:	6a 20                	push   $0x20
  800b86:	8b 45 08             	mov    0x8(%ebp),%eax
  800b89:	ff d0                	call   *%eax
  800b8b:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800b8e:	ff 4d e4             	decl   -0x1c(%ebp)
  800b91:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800b95:	7f e7                	jg     800b7e <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800b97:	e9 78 01 00 00       	jmp    800d14 <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800b9c:	83 ec 08             	sub    $0x8,%esp
  800b9f:	ff 75 e8             	pushl  -0x18(%ebp)
  800ba2:	8d 45 14             	lea    0x14(%ebp),%eax
  800ba5:	50                   	push   %eax
  800ba6:	e8 3c fd ff ff       	call   8008e7 <getint>
  800bab:	83 c4 10             	add    $0x10,%esp
  800bae:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800bb1:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800bb4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800bb7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800bba:	85 d2                	test   %edx,%edx
  800bbc:	79 23                	jns    800be1 <vprintfmt+0x29b>
				putch('-', putdat);
  800bbe:	83 ec 08             	sub    $0x8,%esp
  800bc1:	ff 75 0c             	pushl  0xc(%ebp)
  800bc4:	6a 2d                	push   $0x2d
  800bc6:	8b 45 08             	mov    0x8(%ebp),%eax
  800bc9:	ff d0                	call   *%eax
  800bcb:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800bce:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800bd1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800bd4:	f7 d8                	neg    %eax
  800bd6:	83 d2 00             	adc    $0x0,%edx
  800bd9:	f7 da                	neg    %edx
  800bdb:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800bde:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800be1:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800be8:	e9 bc 00 00 00       	jmp    800ca9 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800bed:	83 ec 08             	sub    $0x8,%esp
  800bf0:	ff 75 e8             	pushl  -0x18(%ebp)
  800bf3:	8d 45 14             	lea    0x14(%ebp),%eax
  800bf6:	50                   	push   %eax
  800bf7:	e8 84 fc ff ff       	call   800880 <getuint>
  800bfc:	83 c4 10             	add    $0x10,%esp
  800bff:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c02:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800c05:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800c0c:	e9 98 00 00 00       	jmp    800ca9 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800c11:	83 ec 08             	sub    $0x8,%esp
  800c14:	ff 75 0c             	pushl  0xc(%ebp)
  800c17:	6a 58                	push   $0x58
  800c19:	8b 45 08             	mov    0x8(%ebp),%eax
  800c1c:	ff d0                	call   *%eax
  800c1e:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800c21:	83 ec 08             	sub    $0x8,%esp
  800c24:	ff 75 0c             	pushl  0xc(%ebp)
  800c27:	6a 58                	push   $0x58
  800c29:	8b 45 08             	mov    0x8(%ebp),%eax
  800c2c:	ff d0                	call   *%eax
  800c2e:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800c31:	83 ec 08             	sub    $0x8,%esp
  800c34:	ff 75 0c             	pushl  0xc(%ebp)
  800c37:	6a 58                	push   $0x58
  800c39:	8b 45 08             	mov    0x8(%ebp),%eax
  800c3c:	ff d0                	call   *%eax
  800c3e:	83 c4 10             	add    $0x10,%esp
			break;
  800c41:	e9 ce 00 00 00       	jmp    800d14 <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  800c46:	83 ec 08             	sub    $0x8,%esp
  800c49:	ff 75 0c             	pushl  0xc(%ebp)
  800c4c:	6a 30                	push   $0x30
  800c4e:	8b 45 08             	mov    0x8(%ebp),%eax
  800c51:	ff d0                	call   *%eax
  800c53:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800c56:	83 ec 08             	sub    $0x8,%esp
  800c59:	ff 75 0c             	pushl  0xc(%ebp)
  800c5c:	6a 78                	push   $0x78
  800c5e:	8b 45 08             	mov    0x8(%ebp),%eax
  800c61:	ff d0                	call   *%eax
  800c63:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800c66:	8b 45 14             	mov    0x14(%ebp),%eax
  800c69:	83 c0 04             	add    $0x4,%eax
  800c6c:	89 45 14             	mov    %eax,0x14(%ebp)
  800c6f:	8b 45 14             	mov    0x14(%ebp),%eax
  800c72:	83 e8 04             	sub    $0x4,%eax
  800c75:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800c77:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c7a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800c81:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800c88:	eb 1f                	jmp    800ca9 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800c8a:	83 ec 08             	sub    $0x8,%esp
  800c8d:	ff 75 e8             	pushl  -0x18(%ebp)
  800c90:	8d 45 14             	lea    0x14(%ebp),%eax
  800c93:	50                   	push   %eax
  800c94:	e8 e7 fb ff ff       	call   800880 <getuint>
  800c99:	83 c4 10             	add    $0x10,%esp
  800c9c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c9f:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800ca2:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800ca9:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800cad:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800cb0:	83 ec 04             	sub    $0x4,%esp
  800cb3:	52                   	push   %edx
  800cb4:	ff 75 e4             	pushl  -0x1c(%ebp)
  800cb7:	50                   	push   %eax
  800cb8:	ff 75 f4             	pushl  -0xc(%ebp)
  800cbb:	ff 75 f0             	pushl  -0x10(%ebp)
  800cbe:	ff 75 0c             	pushl  0xc(%ebp)
  800cc1:	ff 75 08             	pushl  0x8(%ebp)
  800cc4:	e8 00 fb ff ff       	call   8007c9 <printnum>
  800cc9:	83 c4 20             	add    $0x20,%esp
			break;
  800ccc:	eb 46                	jmp    800d14 <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800cce:	83 ec 08             	sub    $0x8,%esp
  800cd1:	ff 75 0c             	pushl  0xc(%ebp)
  800cd4:	53                   	push   %ebx
  800cd5:	8b 45 08             	mov    0x8(%ebp),%eax
  800cd8:	ff d0                	call   *%eax
  800cda:	83 c4 10             	add    $0x10,%esp
			break;
  800cdd:	eb 35                	jmp    800d14 <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  800cdf:	c6 05 44 30 80 00 00 	movb   $0x0,0x803044
			break;
  800ce6:	eb 2c                	jmp    800d14 <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  800ce8:	c6 05 44 30 80 00 01 	movb   $0x1,0x803044
			break;
  800cef:	eb 23                	jmp    800d14 <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800cf1:	83 ec 08             	sub    $0x8,%esp
  800cf4:	ff 75 0c             	pushl  0xc(%ebp)
  800cf7:	6a 25                	push   $0x25
  800cf9:	8b 45 08             	mov    0x8(%ebp),%eax
  800cfc:	ff d0                	call   *%eax
  800cfe:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800d01:	ff 4d 10             	decl   0x10(%ebp)
  800d04:	eb 03                	jmp    800d09 <vprintfmt+0x3c3>
  800d06:	ff 4d 10             	decl   0x10(%ebp)
  800d09:	8b 45 10             	mov    0x10(%ebp),%eax
  800d0c:	48                   	dec    %eax
  800d0d:	8a 00                	mov    (%eax),%al
  800d0f:	3c 25                	cmp    $0x25,%al
  800d11:	75 f3                	jne    800d06 <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  800d13:	90                   	nop
		}
	}
  800d14:	e9 35 fc ff ff       	jmp    80094e <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800d19:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800d1a:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800d1d:	5b                   	pop    %ebx
  800d1e:	5e                   	pop    %esi
  800d1f:	5d                   	pop    %ebp
  800d20:	c3                   	ret    

00800d21 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800d21:	55                   	push   %ebp
  800d22:	89 e5                	mov    %esp,%ebp
  800d24:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800d27:	8d 45 10             	lea    0x10(%ebp),%eax
  800d2a:	83 c0 04             	add    $0x4,%eax
  800d2d:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800d30:	8b 45 10             	mov    0x10(%ebp),%eax
  800d33:	ff 75 f4             	pushl  -0xc(%ebp)
  800d36:	50                   	push   %eax
  800d37:	ff 75 0c             	pushl  0xc(%ebp)
  800d3a:	ff 75 08             	pushl  0x8(%ebp)
  800d3d:	e8 04 fc ff ff       	call   800946 <vprintfmt>
  800d42:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800d45:	90                   	nop
  800d46:	c9                   	leave  
  800d47:	c3                   	ret    

00800d48 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800d48:	55                   	push   %ebp
  800d49:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800d4b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d4e:	8b 40 08             	mov    0x8(%eax),%eax
  800d51:	8d 50 01             	lea    0x1(%eax),%edx
  800d54:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d57:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800d5a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d5d:	8b 10                	mov    (%eax),%edx
  800d5f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d62:	8b 40 04             	mov    0x4(%eax),%eax
  800d65:	39 c2                	cmp    %eax,%edx
  800d67:	73 12                	jae    800d7b <sprintputch+0x33>
		*b->buf++ = ch;
  800d69:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d6c:	8b 00                	mov    (%eax),%eax
  800d6e:	8d 48 01             	lea    0x1(%eax),%ecx
  800d71:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d74:	89 0a                	mov    %ecx,(%edx)
  800d76:	8b 55 08             	mov    0x8(%ebp),%edx
  800d79:	88 10                	mov    %dl,(%eax)
}
  800d7b:	90                   	nop
  800d7c:	5d                   	pop    %ebp
  800d7d:	c3                   	ret    

00800d7e <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800d7e:	55                   	push   %ebp
  800d7f:	89 e5                	mov    %esp,%ebp
  800d81:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800d84:	8b 45 08             	mov    0x8(%ebp),%eax
  800d87:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800d8a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d8d:	8d 50 ff             	lea    -0x1(%eax),%edx
  800d90:	8b 45 08             	mov    0x8(%ebp),%eax
  800d93:	01 d0                	add    %edx,%eax
  800d95:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800d98:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800d9f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800da3:	74 06                	je     800dab <vsnprintf+0x2d>
  800da5:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800da9:	7f 07                	jg     800db2 <vsnprintf+0x34>
		return -E_INVAL;
  800dab:	b8 03 00 00 00       	mov    $0x3,%eax
  800db0:	eb 20                	jmp    800dd2 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800db2:	ff 75 14             	pushl  0x14(%ebp)
  800db5:	ff 75 10             	pushl  0x10(%ebp)
  800db8:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800dbb:	50                   	push   %eax
  800dbc:	68 48 0d 80 00       	push   $0x800d48
  800dc1:	e8 80 fb ff ff       	call   800946 <vprintfmt>
  800dc6:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800dc9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800dcc:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800dcf:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800dd2:	c9                   	leave  
  800dd3:	c3                   	ret    

00800dd4 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800dd4:	55                   	push   %ebp
  800dd5:	89 e5                	mov    %esp,%ebp
  800dd7:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800dda:	8d 45 10             	lea    0x10(%ebp),%eax
  800ddd:	83 c0 04             	add    $0x4,%eax
  800de0:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800de3:	8b 45 10             	mov    0x10(%ebp),%eax
  800de6:	ff 75 f4             	pushl  -0xc(%ebp)
  800de9:	50                   	push   %eax
  800dea:	ff 75 0c             	pushl  0xc(%ebp)
  800ded:	ff 75 08             	pushl  0x8(%ebp)
  800df0:	e8 89 ff ff ff       	call   800d7e <vsnprintf>
  800df5:	83 c4 10             	add    $0x10,%esp
  800df8:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800dfb:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800dfe:	c9                   	leave  
  800dff:	c3                   	ret    

00800e00 <readline>:
#include <inc/lib.h>

//static char buf[BUFLEN];

void readline(const char *prompt, char* buf)
{
  800e00:	55                   	push   %ebp
  800e01:	89 e5                	mov    %esp,%ebp
  800e03:	83 ec 18             	sub    $0x18,%esp
	int i, c, echoing;

	if (prompt != NULL)
  800e06:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800e0a:	74 13                	je     800e1f <readline+0x1f>
		cprintf("%s", prompt);
  800e0c:	83 ec 08             	sub    $0x8,%esp
  800e0f:	ff 75 08             	pushl  0x8(%ebp)
  800e12:	68 08 2a 80 00       	push   $0x802a08
  800e17:	e8 0b f9 ff ff       	call   800727 <cprintf>
  800e1c:	83 c4 10             	add    $0x10,%esp

	i = 0;
  800e1f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	echoing = iscons(0);
  800e26:	83 ec 0c             	sub    $0xc,%esp
  800e29:	6a 00                	push   $0x0
  800e2b:	e8 7e 10 00 00       	call   801eae <iscons>
  800e30:	83 c4 10             	add    $0x10,%esp
  800e33:	89 45 f0             	mov    %eax,-0x10(%ebp)
	while (1) {
		c = getchar();
  800e36:	e8 60 10 00 00       	call   801e9b <getchar>
  800e3b:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if (c < 0) {
  800e3e:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800e42:	79 22                	jns    800e66 <readline+0x66>
			if (c != -E_EOF)
  800e44:	83 7d ec 07          	cmpl   $0x7,-0x14(%ebp)
  800e48:	0f 84 ad 00 00 00    	je     800efb <readline+0xfb>
				cprintf("read error: %e\n", c);
  800e4e:	83 ec 08             	sub    $0x8,%esp
  800e51:	ff 75 ec             	pushl  -0x14(%ebp)
  800e54:	68 0b 2a 80 00       	push   $0x802a0b
  800e59:	e8 c9 f8 ff ff       	call   800727 <cprintf>
  800e5e:	83 c4 10             	add    $0x10,%esp
			break;
  800e61:	e9 95 00 00 00       	jmp    800efb <readline+0xfb>
		} else if (c >= ' ' && i < BUFLEN-1) {
  800e66:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%ebp)
  800e6a:	7e 34                	jle    800ea0 <readline+0xa0>
  800e6c:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  800e73:	7f 2b                	jg     800ea0 <readline+0xa0>
			if (echoing)
  800e75:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800e79:	74 0e                	je     800e89 <readline+0x89>
				cputchar(c);
  800e7b:	83 ec 0c             	sub    $0xc,%esp
  800e7e:	ff 75 ec             	pushl  -0x14(%ebp)
  800e81:	e8 f6 0f 00 00       	call   801e7c <cputchar>
  800e86:	83 c4 10             	add    $0x10,%esp
			buf[i++] = c;
  800e89:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800e8c:	8d 50 01             	lea    0x1(%eax),%edx
  800e8f:	89 55 f4             	mov    %edx,-0xc(%ebp)
  800e92:	89 c2                	mov    %eax,%edx
  800e94:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e97:	01 d0                	add    %edx,%eax
  800e99:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800e9c:	88 10                	mov    %dl,(%eax)
  800e9e:	eb 56                	jmp    800ef6 <readline+0xf6>
		} else if (c == '\b' && i > 0) {
  800ea0:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  800ea4:	75 1f                	jne    800ec5 <readline+0xc5>
  800ea6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  800eaa:	7e 19                	jle    800ec5 <readline+0xc5>
			if (echoing)
  800eac:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800eb0:	74 0e                	je     800ec0 <readline+0xc0>
				cputchar(c);
  800eb2:	83 ec 0c             	sub    $0xc,%esp
  800eb5:	ff 75 ec             	pushl  -0x14(%ebp)
  800eb8:	e8 bf 0f 00 00       	call   801e7c <cputchar>
  800ebd:	83 c4 10             	add    $0x10,%esp

			i--;
  800ec0:	ff 4d f4             	decl   -0xc(%ebp)
  800ec3:	eb 31                	jmp    800ef6 <readline+0xf6>
		} else if (c == '\n' || c == '\r') {
  800ec5:	83 7d ec 0a          	cmpl   $0xa,-0x14(%ebp)
  800ec9:	74 0a                	je     800ed5 <readline+0xd5>
  800ecb:	83 7d ec 0d          	cmpl   $0xd,-0x14(%ebp)
  800ecf:	0f 85 61 ff ff ff    	jne    800e36 <readline+0x36>
			if (echoing)
  800ed5:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800ed9:	74 0e                	je     800ee9 <readline+0xe9>
				cputchar(c);
  800edb:	83 ec 0c             	sub    $0xc,%esp
  800ede:	ff 75 ec             	pushl  -0x14(%ebp)
  800ee1:	e8 96 0f 00 00       	call   801e7c <cputchar>
  800ee6:	83 c4 10             	add    $0x10,%esp

			buf[i] = 0;
  800ee9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800eec:	8b 45 0c             	mov    0xc(%ebp),%eax
  800eef:	01 d0                	add    %edx,%eax
  800ef1:	c6 00 00             	movb   $0x0,(%eax)
			break;
  800ef4:	eb 06                	jmp    800efc <readline+0xfc>
		}
	}
  800ef6:	e9 3b ff ff ff       	jmp    800e36 <readline+0x36>
	while (1) {
		c = getchar();
		if (c < 0) {
			if (c != -E_EOF)
				cprintf("read error: %e\n", c);
			break;
  800efb:	90                   	nop

			buf[i] = 0;
			break;
		}
	}
}
  800efc:	90                   	nop
  800efd:	c9                   	leave  
  800efe:	c3                   	ret    

00800eff <atomic_readline>:

void atomic_readline(const char *prompt, char* buf)
{
  800eff:	55                   	push   %ebp
  800f00:	89 e5                	mov    %esp,%ebp
  800f02:	83 ec 18             	sub    $0x18,%esp
	sys_lock_cons();
  800f05:	e8 79 09 00 00       	call   801883 <sys_lock_cons>
	{
		int i, c, echoing;

		if (prompt != NULL)
  800f0a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800f0e:	74 13                	je     800f23 <atomic_readline+0x24>
			cprintf("%s", prompt);
  800f10:	83 ec 08             	sub    $0x8,%esp
  800f13:	ff 75 08             	pushl  0x8(%ebp)
  800f16:	68 08 2a 80 00       	push   $0x802a08
  800f1b:	e8 07 f8 ff ff       	call   800727 <cprintf>
  800f20:	83 c4 10             	add    $0x10,%esp

		i = 0;
  800f23:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
		echoing = iscons(0);
  800f2a:	83 ec 0c             	sub    $0xc,%esp
  800f2d:	6a 00                	push   $0x0
  800f2f:	e8 7a 0f 00 00       	call   801eae <iscons>
  800f34:	83 c4 10             	add    $0x10,%esp
  800f37:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (1) {
			c = getchar();
  800f3a:	e8 5c 0f 00 00       	call   801e9b <getchar>
  800f3f:	89 45 ec             	mov    %eax,-0x14(%ebp)
			if (c < 0) {
  800f42:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800f46:	79 22                	jns    800f6a <atomic_readline+0x6b>
				if (c != -E_EOF)
  800f48:	83 7d ec 07          	cmpl   $0x7,-0x14(%ebp)
  800f4c:	0f 84 ad 00 00 00    	je     800fff <atomic_readline+0x100>
					cprintf("read error: %e\n", c);
  800f52:	83 ec 08             	sub    $0x8,%esp
  800f55:	ff 75 ec             	pushl  -0x14(%ebp)
  800f58:	68 0b 2a 80 00       	push   $0x802a0b
  800f5d:	e8 c5 f7 ff ff       	call   800727 <cprintf>
  800f62:	83 c4 10             	add    $0x10,%esp
				break;
  800f65:	e9 95 00 00 00       	jmp    800fff <atomic_readline+0x100>
			} else if (c >= ' ' && i < BUFLEN-1) {
  800f6a:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%ebp)
  800f6e:	7e 34                	jle    800fa4 <atomic_readline+0xa5>
  800f70:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  800f77:	7f 2b                	jg     800fa4 <atomic_readline+0xa5>
				if (echoing)
  800f79:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800f7d:	74 0e                	je     800f8d <atomic_readline+0x8e>
					cputchar(c);
  800f7f:	83 ec 0c             	sub    $0xc,%esp
  800f82:	ff 75 ec             	pushl  -0x14(%ebp)
  800f85:	e8 f2 0e 00 00       	call   801e7c <cputchar>
  800f8a:	83 c4 10             	add    $0x10,%esp
				buf[i++] = c;
  800f8d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800f90:	8d 50 01             	lea    0x1(%eax),%edx
  800f93:	89 55 f4             	mov    %edx,-0xc(%ebp)
  800f96:	89 c2                	mov    %eax,%edx
  800f98:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f9b:	01 d0                	add    %edx,%eax
  800f9d:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800fa0:	88 10                	mov    %dl,(%eax)
  800fa2:	eb 56                	jmp    800ffa <atomic_readline+0xfb>
			} else if (c == '\b' && i > 0) {
  800fa4:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  800fa8:	75 1f                	jne    800fc9 <atomic_readline+0xca>
  800faa:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  800fae:	7e 19                	jle    800fc9 <atomic_readline+0xca>
				if (echoing)
  800fb0:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800fb4:	74 0e                	je     800fc4 <atomic_readline+0xc5>
					cputchar(c);
  800fb6:	83 ec 0c             	sub    $0xc,%esp
  800fb9:	ff 75 ec             	pushl  -0x14(%ebp)
  800fbc:	e8 bb 0e 00 00       	call   801e7c <cputchar>
  800fc1:	83 c4 10             	add    $0x10,%esp
				i--;
  800fc4:	ff 4d f4             	decl   -0xc(%ebp)
  800fc7:	eb 31                	jmp    800ffa <atomic_readline+0xfb>
			} else if (c == '\n' || c == '\r') {
  800fc9:	83 7d ec 0a          	cmpl   $0xa,-0x14(%ebp)
  800fcd:	74 0a                	je     800fd9 <atomic_readline+0xda>
  800fcf:	83 7d ec 0d          	cmpl   $0xd,-0x14(%ebp)
  800fd3:	0f 85 61 ff ff ff    	jne    800f3a <atomic_readline+0x3b>
				if (echoing)
  800fd9:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800fdd:	74 0e                	je     800fed <atomic_readline+0xee>
					cputchar(c);
  800fdf:	83 ec 0c             	sub    $0xc,%esp
  800fe2:	ff 75 ec             	pushl  -0x14(%ebp)
  800fe5:	e8 92 0e 00 00       	call   801e7c <cputchar>
  800fea:	83 c4 10             	add    $0x10,%esp
				buf[i] = 0;
  800fed:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800ff0:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ff3:	01 d0                	add    %edx,%eax
  800ff5:	c6 00 00             	movb   $0x0,(%eax)
				break;
  800ff8:	eb 06                	jmp    801000 <atomic_readline+0x101>
			}
		}
  800ffa:	e9 3b ff ff ff       	jmp    800f3a <atomic_readline+0x3b>
		while (1) {
			c = getchar();
			if (c < 0) {
				if (c != -E_EOF)
					cprintf("read error: %e\n", c);
				break;
  800fff:	90                   	nop
				buf[i] = 0;
				break;
			}
		}
	}
	sys_unlock_cons();
  801000:	e8 98 08 00 00       	call   80189d <sys_unlock_cons>
}
  801005:	90                   	nop
  801006:	c9                   	leave  
  801007:	c3                   	ret    

00801008 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  801008:	55                   	push   %ebp
  801009:	89 e5                	mov    %esp,%ebp
  80100b:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  80100e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801015:	eb 06                	jmp    80101d <strlen+0x15>
		n++;
  801017:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  80101a:	ff 45 08             	incl   0x8(%ebp)
  80101d:	8b 45 08             	mov    0x8(%ebp),%eax
  801020:	8a 00                	mov    (%eax),%al
  801022:	84 c0                	test   %al,%al
  801024:	75 f1                	jne    801017 <strlen+0xf>
		n++;
	return n;
  801026:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801029:	c9                   	leave  
  80102a:	c3                   	ret    

0080102b <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  80102b:	55                   	push   %ebp
  80102c:	89 e5                	mov    %esp,%ebp
  80102e:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801031:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801038:	eb 09                	jmp    801043 <strnlen+0x18>
		n++;
  80103a:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80103d:	ff 45 08             	incl   0x8(%ebp)
  801040:	ff 4d 0c             	decl   0xc(%ebp)
  801043:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801047:	74 09                	je     801052 <strnlen+0x27>
  801049:	8b 45 08             	mov    0x8(%ebp),%eax
  80104c:	8a 00                	mov    (%eax),%al
  80104e:	84 c0                	test   %al,%al
  801050:	75 e8                	jne    80103a <strnlen+0xf>
		n++;
	return n;
  801052:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801055:	c9                   	leave  
  801056:	c3                   	ret    

00801057 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  801057:	55                   	push   %ebp
  801058:	89 e5                	mov    %esp,%ebp
  80105a:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  80105d:	8b 45 08             	mov    0x8(%ebp),%eax
  801060:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  801063:	90                   	nop
  801064:	8b 45 08             	mov    0x8(%ebp),%eax
  801067:	8d 50 01             	lea    0x1(%eax),%edx
  80106a:	89 55 08             	mov    %edx,0x8(%ebp)
  80106d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801070:	8d 4a 01             	lea    0x1(%edx),%ecx
  801073:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  801076:	8a 12                	mov    (%edx),%dl
  801078:	88 10                	mov    %dl,(%eax)
  80107a:	8a 00                	mov    (%eax),%al
  80107c:	84 c0                	test   %al,%al
  80107e:	75 e4                	jne    801064 <strcpy+0xd>
		/* do nothing */;
	return ret;
  801080:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801083:	c9                   	leave  
  801084:	c3                   	ret    

00801085 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  801085:	55                   	push   %ebp
  801086:	89 e5                	mov    %esp,%ebp
  801088:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  80108b:	8b 45 08             	mov    0x8(%ebp),%eax
  80108e:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  801091:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801098:	eb 1f                	jmp    8010b9 <strncpy+0x34>
		*dst++ = *src;
  80109a:	8b 45 08             	mov    0x8(%ebp),%eax
  80109d:	8d 50 01             	lea    0x1(%eax),%edx
  8010a0:	89 55 08             	mov    %edx,0x8(%ebp)
  8010a3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8010a6:	8a 12                	mov    (%edx),%dl
  8010a8:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  8010aa:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010ad:	8a 00                	mov    (%eax),%al
  8010af:	84 c0                	test   %al,%al
  8010b1:	74 03                	je     8010b6 <strncpy+0x31>
			src++;
  8010b3:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8010b6:	ff 45 fc             	incl   -0x4(%ebp)
  8010b9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8010bc:	3b 45 10             	cmp    0x10(%ebp),%eax
  8010bf:	72 d9                	jb     80109a <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  8010c1:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8010c4:	c9                   	leave  
  8010c5:	c3                   	ret    

008010c6 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  8010c6:	55                   	push   %ebp
  8010c7:	89 e5                	mov    %esp,%ebp
  8010c9:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  8010cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8010cf:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  8010d2:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8010d6:	74 30                	je     801108 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  8010d8:	eb 16                	jmp    8010f0 <strlcpy+0x2a>
			*dst++ = *src++;
  8010da:	8b 45 08             	mov    0x8(%ebp),%eax
  8010dd:	8d 50 01             	lea    0x1(%eax),%edx
  8010e0:	89 55 08             	mov    %edx,0x8(%ebp)
  8010e3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8010e6:	8d 4a 01             	lea    0x1(%edx),%ecx
  8010e9:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  8010ec:	8a 12                	mov    (%edx),%dl
  8010ee:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  8010f0:	ff 4d 10             	decl   0x10(%ebp)
  8010f3:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8010f7:	74 09                	je     801102 <strlcpy+0x3c>
  8010f9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010fc:	8a 00                	mov    (%eax),%al
  8010fe:	84 c0                	test   %al,%al
  801100:	75 d8                	jne    8010da <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  801102:	8b 45 08             	mov    0x8(%ebp),%eax
  801105:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  801108:	8b 55 08             	mov    0x8(%ebp),%edx
  80110b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80110e:	29 c2                	sub    %eax,%edx
  801110:	89 d0                	mov    %edx,%eax
}
  801112:	c9                   	leave  
  801113:	c3                   	ret    

00801114 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  801114:	55                   	push   %ebp
  801115:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  801117:	eb 06                	jmp    80111f <strcmp+0xb>
		p++, q++;
  801119:	ff 45 08             	incl   0x8(%ebp)
  80111c:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  80111f:	8b 45 08             	mov    0x8(%ebp),%eax
  801122:	8a 00                	mov    (%eax),%al
  801124:	84 c0                	test   %al,%al
  801126:	74 0e                	je     801136 <strcmp+0x22>
  801128:	8b 45 08             	mov    0x8(%ebp),%eax
  80112b:	8a 10                	mov    (%eax),%dl
  80112d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801130:	8a 00                	mov    (%eax),%al
  801132:	38 c2                	cmp    %al,%dl
  801134:	74 e3                	je     801119 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  801136:	8b 45 08             	mov    0x8(%ebp),%eax
  801139:	8a 00                	mov    (%eax),%al
  80113b:	0f b6 d0             	movzbl %al,%edx
  80113e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801141:	8a 00                	mov    (%eax),%al
  801143:	0f b6 c0             	movzbl %al,%eax
  801146:	29 c2                	sub    %eax,%edx
  801148:	89 d0                	mov    %edx,%eax
}
  80114a:	5d                   	pop    %ebp
  80114b:	c3                   	ret    

0080114c <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  80114c:	55                   	push   %ebp
  80114d:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  80114f:	eb 09                	jmp    80115a <strncmp+0xe>
		n--, p++, q++;
  801151:	ff 4d 10             	decl   0x10(%ebp)
  801154:	ff 45 08             	incl   0x8(%ebp)
  801157:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  80115a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80115e:	74 17                	je     801177 <strncmp+0x2b>
  801160:	8b 45 08             	mov    0x8(%ebp),%eax
  801163:	8a 00                	mov    (%eax),%al
  801165:	84 c0                	test   %al,%al
  801167:	74 0e                	je     801177 <strncmp+0x2b>
  801169:	8b 45 08             	mov    0x8(%ebp),%eax
  80116c:	8a 10                	mov    (%eax),%dl
  80116e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801171:	8a 00                	mov    (%eax),%al
  801173:	38 c2                	cmp    %al,%dl
  801175:	74 da                	je     801151 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  801177:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80117b:	75 07                	jne    801184 <strncmp+0x38>
		return 0;
  80117d:	b8 00 00 00 00       	mov    $0x0,%eax
  801182:	eb 14                	jmp    801198 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  801184:	8b 45 08             	mov    0x8(%ebp),%eax
  801187:	8a 00                	mov    (%eax),%al
  801189:	0f b6 d0             	movzbl %al,%edx
  80118c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80118f:	8a 00                	mov    (%eax),%al
  801191:	0f b6 c0             	movzbl %al,%eax
  801194:	29 c2                	sub    %eax,%edx
  801196:	89 d0                	mov    %edx,%eax
}
  801198:	5d                   	pop    %ebp
  801199:	c3                   	ret    

0080119a <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  80119a:	55                   	push   %ebp
  80119b:	89 e5                	mov    %esp,%ebp
  80119d:	83 ec 04             	sub    $0x4,%esp
  8011a0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011a3:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  8011a6:	eb 12                	jmp    8011ba <strchr+0x20>
		if (*s == c)
  8011a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8011ab:	8a 00                	mov    (%eax),%al
  8011ad:	3a 45 fc             	cmp    -0x4(%ebp),%al
  8011b0:	75 05                	jne    8011b7 <strchr+0x1d>
			return (char *) s;
  8011b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8011b5:	eb 11                	jmp    8011c8 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  8011b7:	ff 45 08             	incl   0x8(%ebp)
  8011ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8011bd:	8a 00                	mov    (%eax),%al
  8011bf:	84 c0                	test   %al,%al
  8011c1:	75 e5                	jne    8011a8 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  8011c3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8011c8:	c9                   	leave  
  8011c9:	c3                   	ret    

008011ca <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8011ca:	55                   	push   %ebp
  8011cb:	89 e5                	mov    %esp,%ebp
  8011cd:	83 ec 04             	sub    $0x4,%esp
  8011d0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011d3:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  8011d6:	eb 0d                	jmp    8011e5 <strfind+0x1b>
		if (*s == c)
  8011d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8011db:	8a 00                	mov    (%eax),%al
  8011dd:	3a 45 fc             	cmp    -0x4(%ebp),%al
  8011e0:	74 0e                	je     8011f0 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  8011e2:	ff 45 08             	incl   0x8(%ebp)
  8011e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8011e8:	8a 00                	mov    (%eax),%al
  8011ea:	84 c0                	test   %al,%al
  8011ec:	75 ea                	jne    8011d8 <strfind+0xe>
  8011ee:	eb 01                	jmp    8011f1 <strfind+0x27>
		if (*s == c)
			break;
  8011f0:	90                   	nop
	return (char *) s;
  8011f1:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8011f4:	c9                   	leave  
  8011f5:	c3                   	ret    

008011f6 <memset>:

// *************** The faster implementation of memset & memcpy is implemented by *************
// ****************** Team80 (Yahia Khaled, Malek Ahmed et al) - FCIS'24-25 *******************
void *
memset(void *v, int c, uint32 n)
{
  8011f6:	55                   	push   %ebp
  8011f7:	89 e5                	mov    %esp,%ebp
  8011f9:	83 ec 10             	sub    $0x10,%esp
//	m = n;
//	while (--m >= 0)
//		*p++ = c;

	/*Faster Implementation*/
	uint64* p64 = (uint64*)v;
  8011fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8011ff:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if(n >= 8){
  801202:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  801206:	76 63                	jbe    80126b <memset+0x75>
		uint64 data_block = c;
  801208:	8b 45 0c             	mov    0xc(%ebp),%eax
  80120b:	99                   	cltd   
  80120c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80120f:	89 55 f4             	mov    %edx,-0xc(%ebp)
		data_block |= data_block << 8;
  801212:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801215:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801218:	0f a4 c2 08          	shld   $0x8,%eax,%edx
  80121c:	c1 e0 08             	shl    $0x8,%eax
  80121f:	09 45 f0             	or     %eax,-0x10(%ebp)
  801222:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 16;
  801225:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801228:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80122b:	0f a4 c2 10          	shld   $0x10,%eax,%edx
  80122f:	c1 e0 10             	shl    $0x10,%eax
  801232:	09 45 f0             	or     %eax,-0x10(%ebp)
  801235:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 32;
  801238:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80123b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80123e:	89 c2                	mov    %eax,%edx
  801240:	b8 00 00 00 00       	mov    $0x0,%eax
  801245:	09 45 f0             	or     %eax,-0x10(%ebp)
  801248:	09 55 f4             	or     %edx,-0xc(%ebp)

		while(n >= 8)
  80124b:	eb 18                	jmp    801265 <memset+0x6f>
			*p64++ = data_block, n -= 8;
  80124d:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801250:	8d 41 08             	lea    0x8(%ecx),%eax
  801253:	89 45 fc             	mov    %eax,-0x4(%ebp)
  801256:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801259:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80125c:	89 01                	mov    %eax,(%ecx)
  80125e:	89 51 04             	mov    %edx,0x4(%ecx)
  801261:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
		uint64 data_block = c;
		data_block |= data_block << 8;
		data_block |= data_block << 16;
		data_block |= data_block << 32;

		while(n >= 8)
  801265:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  801269:	77 e2                	ja     80124d <memset+0x57>
			*p64++ = data_block, n -= 8;
	}

	if(n){
  80126b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80126f:	74 23                	je     801294 <memset+0x9e>
		uint8* p8 = (uint8*)p64;
  801271:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801274:	89 45 f8             	mov    %eax,-0x8(%ebp)
		while (n-- > 0)
  801277:	eb 0e                	jmp    801287 <memset+0x91>
			*p8++ = (uint8)c;
  801279:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80127c:	8d 50 01             	lea    0x1(%eax),%edx
  80127f:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801282:	8b 55 0c             	mov    0xc(%ebp),%edx
  801285:	88 10                	mov    %dl,(%eax)
			*p64++ = data_block, n -= 8;
	}

	if(n){
		uint8* p8 = (uint8*)p64;
		while (n-- > 0)
  801287:	8b 45 10             	mov    0x10(%ebp),%eax
  80128a:	8d 50 ff             	lea    -0x1(%eax),%edx
  80128d:	89 55 10             	mov    %edx,0x10(%ebp)
  801290:	85 c0                	test   %eax,%eax
  801292:	75 e5                	jne    801279 <memset+0x83>
			*p8++ = (uint8)c;
	}

	return v;
  801294:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801297:	c9                   	leave  
  801298:	c3                   	ret    

00801299 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  801299:	55                   	push   %ebp
  80129a:	89 e5                	mov    %esp,%ebp
  80129c:	83 ec 10             	sub    $0x10,%esp
	//	s = src;
	//	d = dst;
	//	while (n-- > 0)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
  80129f:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012a2:	89 45 fc             	mov    %eax,-0x4(%ebp)
	uint64* d64 = (uint64*)dst;
  8012a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8012a8:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if(n >= 8){
  8012ab:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  8012af:	76 24                	jbe    8012d5 <memcpy+0x3c>
		while(n >= 8){
  8012b1:	eb 1c                	jmp    8012cf <memcpy+0x36>
			*d64 = *s64;
  8012b3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8012b6:	8b 50 04             	mov    0x4(%eax),%edx
  8012b9:	8b 00                	mov    (%eax),%eax
  8012bb:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8012be:	89 01                	mov    %eax,(%ecx)
  8012c0:	89 51 04             	mov    %edx,0x4(%ecx)
			n -= 8;
  8012c3:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
			++s64;
  8012c7:	83 45 fc 08          	addl   $0x8,-0x4(%ebp)
			++d64;
  8012cb:	83 45 f8 08          	addl   $0x8,-0x8(%ebp)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
	uint64* d64 = (uint64*)dst;
	if(n >= 8){
		while(n >= 8){
  8012cf:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  8012d3:	77 de                	ja     8012b3 <memcpy+0x1a>
			++s64;
			++d64;
		}
	}

	if(n){
  8012d5:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8012d9:	74 31                	je     80130c <memcpy+0x73>
		uint8* s8 = (uint8*)s64;
  8012db:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8012de:	89 45 f4             	mov    %eax,-0xc(%ebp)
		uint8* d8 = (uint8*)d64;
  8012e1:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8012e4:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (n-- > 0)
  8012e7:	eb 16                	jmp    8012ff <memcpy+0x66>
			*d8++ = *s8++;
  8012e9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8012ec:	8d 50 01             	lea    0x1(%eax),%edx
  8012ef:	89 55 f0             	mov    %edx,-0x10(%ebp)
  8012f2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8012f5:	8d 4a 01             	lea    0x1(%edx),%ecx
  8012f8:	89 4d f4             	mov    %ecx,-0xc(%ebp)
  8012fb:	8a 12                	mov    (%edx),%dl
  8012fd:	88 10                	mov    %dl,(%eax)
	}

	if(n){
		uint8* s8 = (uint8*)s64;
		uint8* d8 = (uint8*)d64;
		while (n-- > 0)
  8012ff:	8b 45 10             	mov    0x10(%ebp),%eax
  801302:	8d 50 ff             	lea    -0x1(%eax),%edx
  801305:	89 55 10             	mov    %edx,0x10(%ebp)
  801308:	85 c0                	test   %eax,%eax
  80130a:	75 dd                	jne    8012e9 <memcpy+0x50>
			*d8++ = *s8++;
	}
	return dst;
  80130c:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80130f:	c9                   	leave  
  801310:	c3                   	ret    

00801311 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  801311:	55                   	push   %ebp
  801312:	89 e5                	mov    %esp,%ebp
  801314:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801317:	8b 45 0c             	mov    0xc(%ebp),%eax
  80131a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  80131d:	8b 45 08             	mov    0x8(%ebp),%eax
  801320:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  801323:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801326:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801329:	73 50                	jae    80137b <memmove+0x6a>
  80132b:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80132e:	8b 45 10             	mov    0x10(%ebp),%eax
  801331:	01 d0                	add    %edx,%eax
  801333:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801336:	76 43                	jbe    80137b <memmove+0x6a>
		s += n;
  801338:	8b 45 10             	mov    0x10(%ebp),%eax
  80133b:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  80133e:	8b 45 10             	mov    0x10(%ebp),%eax
  801341:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  801344:	eb 10                	jmp    801356 <memmove+0x45>
			*--d = *--s;
  801346:	ff 4d f8             	decl   -0x8(%ebp)
  801349:	ff 4d fc             	decl   -0x4(%ebp)
  80134c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80134f:	8a 10                	mov    (%eax),%dl
  801351:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801354:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  801356:	8b 45 10             	mov    0x10(%ebp),%eax
  801359:	8d 50 ff             	lea    -0x1(%eax),%edx
  80135c:	89 55 10             	mov    %edx,0x10(%ebp)
  80135f:	85 c0                	test   %eax,%eax
  801361:	75 e3                	jne    801346 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  801363:	eb 23                	jmp    801388 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  801365:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801368:	8d 50 01             	lea    0x1(%eax),%edx
  80136b:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80136e:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801371:	8d 4a 01             	lea    0x1(%edx),%ecx
  801374:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801377:	8a 12                	mov    (%edx),%dl
  801379:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  80137b:	8b 45 10             	mov    0x10(%ebp),%eax
  80137e:	8d 50 ff             	lea    -0x1(%eax),%edx
  801381:	89 55 10             	mov    %edx,0x10(%ebp)
  801384:	85 c0                	test   %eax,%eax
  801386:	75 dd                	jne    801365 <memmove+0x54>
			*d++ = *s++;

	return dst;
  801388:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80138b:	c9                   	leave  
  80138c:	c3                   	ret    

0080138d <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  80138d:	55                   	push   %ebp
  80138e:	89 e5                	mov    %esp,%ebp
  801390:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  801393:	8b 45 08             	mov    0x8(%ebp),%eax
  801396:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  801399:	8b 45 0c             	mov    0xc(%ebp),%eax
  80139c:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  80139f:	eb 2a                	jmp    8013cb <memcmp+0x3e>
		if (*s1 != *s2)
  8013a1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8013a4:	8a 10                	mov    (%eax),%dl
  8013a6:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8013a9:	8a 00                	mov    (%eax),%al
  8013ab:	38 c2                	cmp    %al,%dl
  8013ad:	74 16                	je     8013c5 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  8013af:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8013b2:	8a 00                	mov    (%eax),%al
  8013b4:	0f b6 d0             	movzbl %al,%edx
  8013b7:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8013ba:	8a 00                	mov    (%eax),%al
  8013bc:	0f b6 c0             	movzbl %al,%eax
  8013bf:	29 c2                	sub    %eax,%edx
  8013c1:	89 d0                	mov    %edx,%eax
  8013c3:	eb 18                	jmp    8013dd <memcmp+0x50>
		s1++, s2++;
  8013c5:	ff 45 fc             	incl   -0x4(%ebp)
  8013c8:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  8013cb:	8b 45 10             	mov    0x10(%ebp),%eax
  8013ce:	8d 50 ff             	lea    -0x1(%eax),%edx
  8013d1:	89 55 10             	mov    %edx,0x10(%ebp)
  8013d4:	85 c0                	test   %eax,%eax
  8013d6:	75 c9                	jne    8013a1 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  8013d8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8013dd:	c9                   	leave  
  8013de:	c3                   	ret    

008013df <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  8013df:	55                   	push   %ebp
  8013e0:	89 e5                	mov    %esp,%ebp
  8013e2:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  8013e5:	8b 55 08             	mov    0x8(%ebp),%edx
  8013e8:	8b 45 10             	mov    0x10(%ebp),%eax
  8013eb:	01 d0                	add    %edx,%eax
  8013ed:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  8013f0:	eb 15                	jmp    801407 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  8013f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8013f5:	8a 00                	mov    (%eax),%al
  8013f7:	0f b6 d0             	movzbl %al,%edx
  8013fa:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013fd:	0f b6 c0             	movzbl %al,%eax
  801400:	39 c2                	cmp    %eax,%edx
  801402:	74 0d                	je     801411 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801404:	ff 45 08             	incl   0x8(%ebp)
  801407:	8b 45 08             	mov    0x8(%ebp),%eax
  80140a:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  80140d:	72 e3                	jb     8013f2 <memfind+0x13>
  80140f:	eb 01                	jmp    801412 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  801411:	90                   	nop
	return (void *) s;
  801412:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801415:	c9                   	leave  
  801416:	c3                   	ret    

00801417 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801417:	55                   	push   %ebp
  801418:	89 e5                	mov    %esp,%ebp
  80141a:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  80141d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  801424:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80142b:	eb 03                	jmp    801430 <strtol+0x19>
		s++;
  80142d:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801430:	8b 45 08             	mov    0x8(%ebp),%eax
  801433:	8a 00                	mov    (%eax),%al
  801435:	3c 20                	cmp    $0x20,%al
  801437:	74 f4                	je     80142d <strtol+0x16>
  801439:	8b 45 08             	mov    0x8(%ebp),%eax
  80143c:	8a 00                	mov    (%eax),%al
  80143e:	3c 09                	cmp    $0x9,%al
  801440:	74 eb                	je     80142d <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  801442:	8b 45 08             	mov    0x8(%ebp),%eax
  801445:	8a 00                	mov    (%eax),%al
  801447:	3c 2b                	cmp    $0x2b,%al
  801449:	75 05                	jne    801450 <strtol+0x39>
		s++;
  80144b:	ff 45 08             	incl   0x8(%ebp)
  80144e:	eb 13                	jmp    801463 <strtol+0x4c>
	else if (*s == '-')
  801450:	8b 45 08             	mov    0x8(%ebp),%eax
  801453:	8a 00                	mov    (%eax),%al
  801455:	3c 2d                	cmp    $0x2d,%al
  801457:	75 0a                	jne    801463 <strtol+0x4c>
		s++, neg = 1;
  801459:	ff 45 08             	incl   0x8(%ebp)
  80145c:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801463:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801467:	74 06                	je     80146f <strtol+0x58>
  801469:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  80146d:	75 20                	jne    80148f <strtol+0x78>
  80146f:	8b 45 08             	mov    0x8(%ebp),%eax
  801472:	8a 00                	mov    (%eax),%al
  801474:	3c 30                	cmp    $0x30,%al
  801476:	75 17                	jne    80148f <strtol+0x78>
  801478:	8b 45 08             	mov    0x8(%ebp),%eax
  80147b:	40                   	inc    %eax
  80147c:	8a 00                	mov    (%eax),%al
  80147e:	3c 78                	cmp    $0x78,%al
  801480:	75 0d                	jne    80148f <strtol+0x78>
		s += 2, base = 16;
  801482:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  801486:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  80148d:	eb 28                	jmp    8014b7 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  80148f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801493:	75 15                	jne    8014aa <strtol+0x93>
  801495:	8b 45 08             	mov    0x8(%ebp),%eax
  801498:	8a 00                	mov    (%eax),%al
  80149a:	3c 30                	cmp    $0x30,%al
  80149c:	75 0c                	jne    8014aa <strtol+0x93>
		s++, base = 8;
  80149e:	ff 45 08             	incl   0x8(%ebp)
  8014a1:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  8014a8:	eb 0d                	jmp    8014b7 <strtol+0xa0>
	else if (base == 0)
  8014aa:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8014ae:	75 07                	jne    8014b7 <strtol+0xa0>
		base = 10;
  8014b0:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8014b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8014ba:	8a 00                	mov    (%eax),%al
  8014bc:	3c 2f                	cmp    $0x2f,%al
  8014be:	7e 19                	jle    8014d9 <strtol+0xc2>
  8014c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8014c3:	8a 00                	mov    (%eax),%al
  8014c5:	3c 39                	cmp    $0x39,%al
  8014c7:	7f 10                	jg     8014d9 <strtol+0xc2>
			dig = *s - '0';
  8014c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8014cc:	8a 00                	mov    (%eax),%al
  8014ce:	0f be c0             	movsbl %al,%eax
  8014d1:	83 e8 30             	sub    $0x30,%eax
  8014d4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8014d7:	eb 42                	jmp    80151b <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  8014d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8014dc:	8a 00                	mov    (%eax),%al
  8014de:	3c 60                	cmp    $0x60,%al
  8014e0:	7e 19                	jle    8014fb <strtol+0xe4>
  8014e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8014e5:	8a 00                	mov    (%eax),%al
  8014e7:	3c 7a                	cmp    $0x7a,%al
  8014e9:	7f 10                	jg     8014fb <strtol+0xe4>
			dig = *s - 'a' + 10;
  8014eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8014ee:	8a 00                	mov    (%eax),%al
  8014f0:	0f be c0             	movsbl %al,%eax
  8014f3:	83 e8 57             	sub    $0x57,%eax
  8014f6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8014f9:	eb 20                	jmp    80151b <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  8014fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8014fe:	8a 00                	mov    (%eax),%al
  801500:	3c 40                	cmp    $0x40,%al
  801502:	7e 39                	jle    80153d <strtol+0x126>
  801504:	8b 45 08             	mov    0x8(%ebp),%eax
  801507:	8a 00                	mov    (%eax),%al
  801509:	3c 5a                	cmp    $0x5a,%al
  80150b:	7f 30                	jg     80153d <strtol+0x126>
			dig = *s - 'A' + 10;
  80150d:	8b 45 08             	mov    0x8(%ebp),%eax
  801510:	8a 00                	mov    (%eax),%al
  801512:	0f be c0             	movsbl %al,%eax
  801515:	83 e8 37             	sub    $0x37,%eax
  801518:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  80151b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80151e:	3b 45 10             	cmp    0x10(%ebp),%eax
  801521:	7d 19                	jge    80153c <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801523:	ff 45 08             	incl   0x8(%ebp)
  801526:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801529:	0f af 45 10          	imul   0x10(%ebp),%eax
  80152d:	89 c2                	mov    %eax,%edx
  80152f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801532:	01 d0                	add    %edx,%eax
  801534:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  801537:	e9 7b ff ff ff       	jmp    8014b7 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  80153c:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  80153d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801541:	74 08                	je     80154b <strtol+0x134>
		*endptr = (char *) s;
  801543:	8b 45 0c             	mov    0xc(%ebp),%eax
  801546:	8b 55 08             	mov    0x8(%ebp),%edx
  801549:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  80154b:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80154f:	74 07                	je     801558 <strtol+0x141>
  801551:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801554:	f7 d8                	neg    %eax
  801556:	eb 03                	jmp    80155b <strtol+0x144>
  801558:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  80155b:	c9                   	leave  
  80155c:	c3                   	ret    

0080155d <ltostr>:

void
ltostr(long value, char *str)
{
  80155d:	55                   	push   %ebp
  80155e:	89 e5                	mov    %esp,%ebp
  801560:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  801563:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  80156a:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  801571:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801575:	79 13                	jns    80158a <ltostr+0x2d>
	{
		neg = 1;
  801577:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  80157e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801581:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  801584:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  801587:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  80158a:	8b 45 08             	mov    0x8(%ebp),%eax
  80158d:	b9 0a 00 00 00       	mov    $0xa,%ecx
  801592:	99                   	cltd   
  801593:	f7 f9                	idiv   %ecx
  801595:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  801598:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80159b:	8d 50 01             	lea    0x1(%eax),%edx
  80159e:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8015a1:	89 c2                	mov    %eax,%edx
  8015a3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015a6:	01 d0                	add    %edx,%eax
  8015a8:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8015ab:	83 c2 30             	add    $0x30,%edx
  8015ae:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  8015b0:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8015b3:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8015b8:	f7 e9                	imul   %ecx
  8015ba:	c1 fa 02             	sar    $0x2,%edx
  8015bd:	89 c8                	mov    %ecx,%eax
  8015bf:	c1 f8 1f             	sar    $0x1f,%eax
  8015c2:	29 c2                	sub    %eax,%edx
  8015c4:	89 d0                	mov    %edx,%eax
  8015c6:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  8015c9:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8015cd:	75 bb                	jne    80158a <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  8015cf:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  8015d6:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8015d9:	48                   	dec    %eax
  8015da:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  8015dd:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8015e1:	74 3d                	je     801620 <ltostr+0xc3>
		start = 1 ;
  8015e3:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  8015ea:	eb 34                	jmp    801620 <ltostr+0xc3>
	{
		char tmp = str[start] ;
  8015ec:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8015ef:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015f2:	01 d0                	add    %edx,%eax
  8015f4:	8a 00                	mov    (%eax),%al
  8015f6:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  8015f9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8015fc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015ff:	01 c2                	add    %eax,%edx
  801601:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801604:	8b 45 0c             	mov    0xc(%ebp),%eax
  801607:	01 c8                	add    %ecx,%eax
  801609:	8a 00                	mov    (%eax),%al
  80160b:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  80160d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801610:	8b 45 0c             	mov    0xc(%ebp),%eax
  801613:	01 c2                	add    %eax,%edx
  801615:	8a 45 eb             	mov    -0x15(%ebp),%al
  801618:	88 02                	mov    %al,(%edx)
		start++ ;
  80161a:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  80161d:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801620:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801623:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801626:	7c c4                	jl     8015ec <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801628:	8b 55 f8             	mov    -0x8(%ebp),%edx
  80162b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80162e:	01 d0                	add    %edx,%eax
  801630:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801633:	90                   	nop
  801634:	c9                   	leave  
  801635:	c3                   	ret    

00801636 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  801636:	55                   	push   %ebp
  801637:	89 e5                	mov    %esp,%ebp
  801639:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  80163c:	ff 75 08             	pushl  0x8(%ebp)
  80163f:	e8 c4 f9 ff ff       	call   801008 <strlen>
  801644:	83 c4 04             	add    $0x4,%esp
  801647:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  80164a:	ff 75 0c             	pushl  0xc(%ebp)
  80164d:	e8 b6 f9 ff ff       	call   801008 <strlen>
  801652:	83 c4 04             	add    $0x4,%esp
  801655:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  801658:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  80165f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801666:	eb 17                	jmp    80167f <strcconcat+0x49>
		final[s] = str1[s] ;
  801668:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80166b:	8b 45 10             	mov    0x10(%ebp),%eax
  80166e:	01 c2                	add    %eax,%edx
  801670:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801673:	8b 45 08             	mov    0x8(%ebp),%eax
  801676:	01 c8                	add    %ecx,%eax
  801678:	8a 00                	mov    (%eax),%al
  80167a:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  80167c:	ff 45 fc             	incl   -0x4(%ebp)
  80167f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801682:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801685:	7c e1                	jl     801668 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  801687:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  80168e:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  801695:	eb 1f                	jmp    8016b6 <strcconcat+0x80>
		final[s++] = str2[i] ;
  801697:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80169a:	8d 50 01             	lea    0x1(%eax),%edx
  80169d:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8016a0:	89 c2                	mov    %eax,%edx
  8016a2:	8b 45 10             	mov    0x10(%ebp),%eax
  8016a5:	01 c2                	add    %eax,%edx
  8016a7:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8016aa:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016ad:	01 c8                	add    %ecx,%eax
  8016af:	8a 00                	mov    (%eax),%al
  8016b1:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  8016b3:	ff 45 f8             	incl   -0x8(%ebp)
  8016b6:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8016b9:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8016bc:	7c d9                	jl     801697 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  8016be:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8016c1:	8b 45 10             	mov    0x10(%ebp),%eax
  8016c4:	01 d0                	add    %edx,%eax
  8016c6:	c6 00 00             	movb   $0x0,(%eax)
}
  8016c9:	90                   	nop
  8016ca:	c9                   	leave  
  8016cb:	c3                   	ret    

008016cc <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  8016cc:	55                   	push   %ebp
  8016cd:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  8016cf:	8b 45 14             	mov    0x14(%ebp),%eax
  8016d2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  8016d8:	8b 45 14             	mov    0x14(%ebp),%eax
  8016db:	8b 00                	mov    (%eax),%eax
  8016dd:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8016e4:	8b 45 10             	mov    0x10(%ebp),%eax
  8016e7:	01 d0                	add    %edx,%eax
  8016e9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8016ef:	eb 0c                	jmp    8016fd <strsplit+0x31>
			*string++ = 0;
  8016f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8016f4:	8d 50 01             	lea    0x1(%eax),%edx
  8016f7:	89 55 08             	mov    %edx,0x8(%ebp)
  8016fa:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8016fd:	8b 45 08             	mov    0x8(%ebp),%eax
  801700:	8a 00                	mov    (%eax),%al
  801702:	84 c0                	test   %al,%al
  801704:	74 18                	je     80171e <strsplit+0x52>
  801706:	8b 45 08             	mov    0x8(%ebp),%eax
  801709:	8a 00                	mov    (%eax),%al
  80170b:	0f be c0             	movsbl %al,%eax
  80170e:	50                   	push   %eax
  80170f:	ff 75 0c             	pushl  0xc(%ebp)
  801712:	e8 83 fa ff ff       	call   80119a <strchr>
  801717:	83 c4 08             	add    $0x8,%esp
  80171a:	85 c0                	test   %eax,%eax
  80171c:	75 d3                	jne    8016f1 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  80171e:	8b 45 08             	mov    0x8(%ebp),%eax
  801721:	8a 00                	mov    (%eax),%al
  801723:	84 c0                	test   %al,%al
  801725:	74 5a                	je     801781 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801727:	8b 45 14             	mov    0x14(%ebp),%eax
  80172a:	8b 00                	mov    (%eax),%eax
  80172c:	83 f8 0f             	cmp    $0xf,%eax
  80172f:	75 07                	jne    801738 <strsplit+0x6c>
		{
			return 0;
  801731:	b8 00 00 00 00       	mov    $0x0,%eax
  801736:	eb 66                	jmp    80179e <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801738:	8b 45 14             	mov    0x14(%ebp),%eax
  80173b:	8b 00                	mov    (%eax),%eax
  80173d:	8d 48 01             	lea    0x1(%eax),%ecx
  801740:	8b 55 14             	mov    0x14(%ebp),%edx
  801743:	89 0a                	mov    %ecx,(%edx)
  801745:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80174c:	8b 45 10             	mov    0x10(%ebp),%eax
  80174f:	01 c2                	add    %eax,%edx
  801751:	8b 45 08             	mov    0x8(%ebp),%eax
  801754:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801756:	eb 03                	jmp    80175b <strsplit+0x8f>
			string++;
  801758:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  80175b:	8b 45 08             	mov    0x8(%ebp),%eax
  80175e:	8a 00                	mov    (%eax),%al
  801760:	84 c0                	test   %al,%al
  801762:	74 8b                	je     8016ef <strsplit+0x23>
  801764:	8b 45 08             	mov    0x8(%ebp),%eax
  801767:	8a 00                	mov    (%eax),%al
  801769:	0f be c0             	movsbl %al,%eax
  80176c:	50                   	push   %eax
  80176d:	ff 75 0c             	pushl  0xc(%ebp)
  801770:	e8 25 fa ff ff       	call   80119a <strchr>
  801775:	83 c4 08             	add    $0x8,%esp
  801778:	85 c0                	test   %eax,%eax
  80177a:	74 dc                	je     801758 <strsplit+0x8c>
			string++;
	}
  80177c:	e9 6e ff ff ff       	jmp    8016ef <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801781:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801782:	8b 45 14             	mov    0x14(%ebp),%eax
  801785:	8b 00                	mov    (%eax),%eax
  801787:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80178e:	8b 45 10             	mov    0x10(%ebp),%eax
  801791:	01 d0                	add    %edx,%eax
  801793:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801799:	b8 01 00 00 00       	mov    $0x1,%eax
}
  80179e:	c9                   	leave  
  80179f:	c3                   	ret    

008017a0 <str2lower>:


char* str2lower(char *dst, const char *src)
{
  8017a0:	55                   	push   %ebp
  8017a1:	89 e5                	mov    %esp,%ebp
  8017a3:	83 ec 10             	sub    $0x10,%esp
	char* ret = dst;
  8017a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8017a9:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (int i = 0; i < strlen(src); ++i)
  8017ac:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8017b3:	eb 4a                	jmp    8017ff <str2lower+0x5f>
	{
		dst[i] = src[i] ;
  8017b5:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8017b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8017bb:	01 c2                	add    %eax,%edx
  8017bd:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8017c0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017c3:	01 c8                	add    %ecx,%eax
  8017c5:	8a 00                	mov    (%eax),%al
  8017c7:	88 02                	mov    %al,(%edx)
		if (src[i] >= 'A' && src[i] <= 'Z')
  8017c9:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8017cc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017cf:	01 d0                	add    %edx,%eax
  8017d1:	8a 00                	mov    (%eax),%al
  8017d3:	3c 40                	cmp    $0x40,%al
  8017d5:	7e 25                	jle    8017fc <str2lower+0x5c>
  8017d7:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8017da:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017dd:	01 d0                	add    %edx,%eax
  8017df:	8a 00                	mov    (%eax),%al
  8017e1:	3c 5a                	cmp    $0x5a,%al
  8017e3:	7f 17                	jg     8017fc <str2lower+0x5c>
		{
			dst[i] += 32 ;
  8017e5:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8017e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8017eb:	01 d0                	add    %edx,%eax
  8017ed:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8017f0:	8b 55 08             	mov    0x8(%ebp),%edx
  8017f3:	01 ca                	add    %ecx,%edx
  8017f5:	8a 12                	mov    (%edx),%dl
  8017f7:	83 c2 20             	add    $0x20,%edx
  8017fa:	88 10                	mov    %dl,(%eax)


char* str2lower(char *dst, const char *src)
{
	char* ret = dst;
	for (int i = 0; i < strlen(src); ++i)
  8017fc:	ff 45 fc             	incl   -0x4(%ebp)
  8017ff:	ff 75 0c             	pushl  0xc(%ebp)
  801802:	e8 01 f8 ff ff       	call   801008 <strlen>
  801807:	83 c4 04             	add    $0x4,%esp
  80180a:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  80180d:	7f a6                	jg     8017b5 <str2lower+0x15>
		if (src[i] >= 'A' && src[i] <= 'Z')
		{
			dst[i] += 32 ;
		}
	}
	return ret;
  80180f:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801812:	c9                   	leave  
  801813:	c3                   	ret    

00801814 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801814:	55                   	push   %ebp
  801815:	89 e5                	mov    %esp,%ebp
  801817:	57                   	push   %edi
  801818:	56                   	push   %esi
  801819:	53                   	push   %ebx
  80181a:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80181d:	8b 45 08             	mov    0x8(%ebp),%eax
  801820:	8b 55 0c             	mov    0xc(%ebp),%edx
  801823:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801826:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801829:	8b 7d 18             	mov    0x18(%ebp),%edi
  80182c:	8b 75 1c             	mov    0x1c(%ebp),%esi
  80182f:	cd 30                	int    $0x30
  801831:	89 45 f0             	mov    %eax,-0x10(%ebp)
				"b" (a3),
				"D" (a4),
				"S" (a5)
				: "cc", "memory");

	return ret;
  801834:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801837:	83 c4 10             	add    $0x10,%esp
  80183a:	5b                   	pop    %ebx
  80183b:	5e                   	pop    %esi
  80183c:	5f                   	pop    %edi
  80183d:	5d                   	pop    %ebp
  80183e:	c3                   	ret    

0080183f <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName, int color)
{
  80183f:	55                   	push   %ebp
  801840:	89 e5                	mov    %esp,%ebp
  801842:	83 ec 04             	sub    $0x4,%esp
  801845:	8b 45 10             	mov    0x10(%ebp),%eax
  801848:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, color, 0);
  80184b:	8b 4d 14             	mov    0x14(%ebp),%ecx
  80184e:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801852:	8b 45 08             	mov    0x8(%ebp),%eax
  801855:	6a 00                	push   $0x0
  801857:	51                   	push   %ecx
  801858:	52                   	push   %edx
  801859:	ff 75 0c             	pushl  0xc(%ebp)
  80185c:	50                   	push   %eax
  80185d:	6a 00                	push   $0x0
  80185f:	e8 b0 ff ff ff       	call   801814 <syscall>
  801864:	83 c4 18             	add    $0x18,%esp
}
  801867:	90                   	nop
  801868:	c9                   	leave  
  801869:	c3                   	ret    

0080186a <sys_cgetc>:

int
sys_cgetc(void)
{
  80186a:	55                   	push   %ebp
  80186b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  80186d:	6a 00                	push   $0x0
  80186f:	6a 00                	push   $0x0
  801871:	6a 00                	push   $0x0
  801873:	6a 00                	push   $0x0
  801875:	6a 00                	push   $0x0
  801877:	6a 02                	push   $0x2
  801879:	e8 96 ff ff ff       	call   801814 <syscall>
  80187e:	83 c4 18             	add    $0x18,%esp
}
  801881:	c9                   	leave  
  801882:	c3                   	ret    

00801883 <sys_lock_cons>:

void sys_lock_cons(void)
{
  801883:	55                   	push   %ebp
  801884:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  801886:	6a 00                	push   $0x0
  801888:	6a 00                	push   $0x0
  80188a:	6a 00                	push   $0x0
  80188c:	6a 00                	push   $0x0
  80188e:	6a 00                	push   $0x0
  801890:	6a 03                	push   $0x3
  801892:	e8 7d ff ff ff       	call   801814 <syscall>
  801897:	83 c4 18             	add    $0x18,%esp
}
  80189a:	90                   	nop
  80189b:	c9                   	leave  
  80189c:	c3                   	ret    

0080189d <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  80189d:	55                   	push   %ebp
  80189e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  8018a0:	6a 00                	push   $0x0
  8018a2:	6a 00                	push   $0x0
  8018a4:	6a 00                	push   $0x0
  8018a6:	6a 00                	push   $0x0
  8018a8:	6a 00                	push   $0x0
  8018aa:	6a 04                	push   $0x4
  8018ac:	e8 63 ff ff ff       	call   801814 <syscall>
  8018b1:	83 c4 18             	add    $0x18,%esp
}
  8018b4:	90                   	nop
  8018b5:	c9                   	leave  
  8018b6:	c3                   	ret    

008018b7 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  8018b7:	55                   	push   %ebp
  8018b8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  8018ba:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8018c0:	6a 00                	push   $0x0
  8018c2:	6a 00                	push   $0x0
  8018c4:	6a 00                	push   $0x0
  8018c6:	52                   	push   %edx
  8018c7:	50                   	push   %eax
  8018c8:	6a 08                	push   $0x8
  8018ca:	e8 45 ff ff ff       	call   801814 <syscall>
  8018cf:	83 c4 18             	add    $0x18,%esp
}
  8018d2:	c9                   	leave  
  8018d3:	c3                   	ret    

008018d4 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  8018d4:	55                   	push   %ebp
  8018d5:	89 e5                	mov    %esp,%ebp
  8018d7:	56                   	push   %esi
  8018d8:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  8018d9:	8b 75 18             	mov    0x18(%ebp),%esi
  8018dc:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8018df:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8018e2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8018e8:	56                   	push   %esi
  8018e9:	53                   	push   %ebx
  8018ea:	51                   	push   %ecx
  8018eb:	52                   	push   %edx
  8018ec:	50                   	push   %eax
  8018ed:	6a 09                	push   $0x9
  8018ef:	e8 20 ff ff ff       	call   801814 <syscall>
  8018f4:	83 c4 18             	add    $0x18,%esp
}
  8018f7:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8018fa:	5b                   	pop    %ebx
  8018fb:	5e                   	pop    %esi
  8018fc:	5d                   	pop    %ebp
  8018fd:	c3                   	ret    

008018fe <__sys_unmap_frame>:

int __sys_unmap_frame(uint32 va)
{
  8018fe:	55                   	push   %ebp
  8018ff:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, va, 0, 0, 0, 0);
  801901:	6a 00                	push   $0x0
  801903:	6a 00                	push   $0x0
  801905:	6a 00                	push   $0x0
  801907:	6a 00                	push   $0x0
  801909:	ff 75 08             	pushl  0x8(%ebp)
  80190c:	6a 0a                	push   $0xa
  80190e:	e8 01 ff ff ff       	call   801814 <syscall>
  801913:	83 c4 18             	add    $0x18,%esp
}
  801916:	c9                   	leave  
  801917:	c3                   	ret    

00801918 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801918:	55                   	push   %ebp
  801919:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  80191b:	6a 00                	push   $0x0
  80191d:	6a 00                	push   $0x0
  80191f:	6a 00                	push   $0x0
  801921:	ff 75 0c             	pushl  0xc(%ebp)
  801924:	ff 75 08             	pushl  0x8(%ebp)
  801927:	6a 0b                	push   $0xb
  801929:	e8 e6 fe ff ff       	call   801814 <syscall>
  80192e:	83 c4 18             	add    $0x18,%esp
}
  801931:	c9                   	leave  
  801932:	c3                   	ret    

00801933 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801933:	55                   	push   %ebp
  801934:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801936:	6a 00                	push   $0x0
  801938:	6a 00                	push   $0x0
  80193a:	6a 00                	push   $0x0
  80193c:	6a 00                	push   $0x0
  80193e:	6a 00                	push   $0x0
  801940:	6a 0c                	push   $0xc
  801942:	e8 cd fe ff ff       	call   801814 <syscall>
  801947:	83 c4 18             	add    $0x18,%esp
}
  80194a:	c9                   	leave  
  80194b:	c3                   	ret    

0080194c <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  80194c:	55                   	push   %ebp
  80194d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  80194f:	6a 00                	push   $0x0
  801951:	6a 00                	push   $0x0
  801953:	6a 00                	push   $0x0
  801955:	6a 00                	push   $0x0
  801957:	6a 00                	push   $0x0
  801959:	6a 0d                	push   $0xd
  80195b:	e8 b4 fe ff ff       	call   801814 <syscall>
  801960:	83 c4 18             	add    $0x18,%esp
}
  801963:	c9                   	leave  
  801964:	c3                   	ret    

00801965 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801965:	55                   	push   %ebp
  801966:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801968:	6a 00                	push   $0x0
  80196a:	6a 00                	push   $0x0
  80196c:	6a 00                	push   $0x0
  80196e:	6a 00                	push   $0x0
  801970:	6a 00                	push   $0x0
  801972:	6a 0e                	push   $0xe
  801974:	e8 9b fe ff ff       	call   801814 <syscall>
  801979:	83 c4 18             	add    $0x18,%esp
}
  80197c:	c9                   	leave  
  80197d:	c3                   	ret    

0080197e <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  80197e:	55                   	push   %ebp
  80197f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801981:	6a 00                	push   $0x0
  801983:	6a 00                	push   $0x0
  801985:	6a 00                	push   $0x0
  801987:	6a 00                	push   $0x0
  801989:	6a 00                	push   $0x0
  80198b:	6a 0f                	push   $0xf
  80198d:	e8 82 fe ff ff       	call   801814 <syscall>
  801992:	83 c4 18             	add    $0x18,%esp
}
  801995:	c9                   	leave  
  801996:	c3                   	ret    

00801997 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801997:	55                   	push   %ebp
  801998:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  80199a:	6a 00                	push   $0x0
  80199c:	6a 00                	push   $0x0
  80199e:	6a 00                	push   $0x0
  8019a0:	6a 00                	push   $0x0
  8019a2:	ff 75 08             	pushl  0x8(%ebp)
  8019a5:	6a 10                	push   $0x10
  8019a7:	e8 68 fe ff ff       	call   801814 <syscall>
  8019ac:	83 c4 18             	add    $0x18,%esp
}
  8019af:	c9                   	leave  
  8019b0:	c3                   	ret    

008019b1 <sys_scarce_memory>:

void sys_scarce_memory()
{
  8019b1:	55                   	push   %ebp
  8019b2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  8019b4:	6a 00                	push   $0x0
  8019b6:	6a 00                	push   $0x0
  8019b8:	6a 00                	push   $0x0
  8019ba:	6a 00                	push   $0x0
  8019bc:	6a 00                	push   $0x0
  8019be:	6a 11                	push   $0x11
  8019c0:	e8 4f fe ff ff       	call   801814 <syscall>
  8019c5:	83 c4 18             	add    $0x18,%esp
}
  8019c8:	90                   	nop
  8019c9:	c9                   	leave  
  8019ca:	c3                   	ret    

008019cb <sys_cputc>:

void
sys_cputc(const char c)
{
  8019cb:	55                   	push   %ebp
  8019cc:	89 e5                	mov    %esp,%ebp
  8019ce:	83 ec 04             	sub    $0x4,%esp
  8019d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8019d4:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  8019d7:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8019db:	6a 00                	push   $0x0
  8019dd:	6a 00                	push   $0x0
  8019df:	6a 00                	push   $0x0
  8019e1:	6a 00                	push   $0x0
  8019e3:	50                   	push   %eax
  8019e4:	6a 01                	push   $0x1
  8019e6:	e8 29 fe ff ff       	call   801814 <syscall>
  8019eb:	83 c4 18             	add    $0x18,%esp
}
  8019ee:	90                   	nop
  8019ef:	c9                   	leave  
  8019f0:	c3                   	ret    

008019f1 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  8019f1:	55                   	push   %ebp
  8019f2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  8019f4:	6a 00                	push   $0x0
  8019f6:	6a 00                	push   $0x0
  8019f8:	6a 00                	push   $0x0
  8019fa:	6a 00                	push   $0x0
  8019fc:	6a 00                	push   $0x0
  8019fe:	6a 14                	push   $0x14
  801a00:	e8 0f fe ff ff       	call   801814 <syscall>
  801a05:	83 c4 18             	add    $0x18,%esp
}
  801a08:	90                   	nop
  801a09:	c9                   	leave  
  801a0a:	c3                   	ret    

00801a0b <sys_create_shared_object>:

int sys_create_shared_object(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801a0b:	55                   	push   %ebp
  801a0c:	89 e5                	mov    %esp,%ebp
  801a0e:	83 ec 04             	sub    $0x4,%esp
  801a11:	8b 45 10             	mov    0x10(%ebp),%eax
  801a14:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801a17:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801a1a:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801a1e:	8b 45 08             	mov    0x8(%ebp),%eax
  801a21:	6a 00                	push   $0x0
  801a23:	51                   	push   %ecx
  801a24:	52                   	push   %edx
  801a25:	ff 75 0c             	pushl  0xc(%ebp)
  801a28:	50                   	push   %eax
  801a29:	6a 15                	push   $0x15
  801a2b:	e8 e4 fd ff ff       	call   801814 <syscall>
  801a30:	83 c4 18             	add    $0x18,%esp
}
  801a33:	c9                   	leave  
  801a34:	c3                   	ret    

00801a35 <sys_size_of_shared_object>:

//2017:
int sys_size_of_shared_object(int32 ownerID, char* shareName)
{
  801a35:	55                   	push   %ebp
  801a36:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801a38:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a3b:	8b 45 08             	mov    0x8(%ebp),%eax
  801a3e:	6a 00                	push   $0x0
  801a40:	6a 00                	push   $0x0
  801a42:	6a 00                	push   $0x0
  801a44:	52                   	push   %edx
  801a45:	50                   	push   %eax
  801a46:	6a 16                	push   $0x16
  801a48:	e8 c7 fd ff ff       	call   801814 <syscall>
  801a4d:	83 c4 18             	add    $0x18,%esp
}
  801a50:	c9                   	leave  
  801a51:	c3                   	ret    

00801a52 <sys_get_shared_object>:
//==========

int sys_get_shared_object(int32 ownerID, char* shareName, void* virtual_address)
{
  801a52:	55                   	push   %ebp
  801a53:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801a55:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801a58:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a5b:	8b 45 08             	mov    0x8(%ebp),%eax
  801a5e:	6a 00                	push   $0x0
  801a60:	6a 00                	push   $0x0
  801a62:	51                   	push   %ecx
  801a63:	52                   	push   %edx
  801a64:	50                   	push   %eax
  801a65:	6a 17                	push   $0x17
  801a67:	e8 a8 fd ff ff       	call   801814 <syscall>
  801a6c:	83 c4 18             	add    $0x18,%esp
}
  801a6f:	c9                   	leave  
  801a70:	c3                   	ret    

00801a71 <sys_delete_shared_object>:

int sys_delete_shared_object(int32 sharedObjectID, void *startVA)
{
  801a71:	55                   	push   %ebp
  801a72:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801a74:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a77:	8b 45 08             	mov    0x8(%ebp),%eax
  801a7a:	6a 00                	push   $0x0
  801a7c:	6a 00                	push   $0x0
  801a7e:	6a 00                	push   $0x0
  801a80:	52                   	push   %edx
  801a81:	50                   	push   %eax
  801a82:	6a 18                	push   $0x18
  801a84:	e8 8b fd ff ff       	call   801814 <syscall>
  801a89:	83 c4 18             	add    $0x18,%esp
}
  801a8c:	c9                   	leave  
  801a8d:	c3                   	ret    

00801a8e <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801a8e:	55                   	push   %ebp
  801a8f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801a91:	8b 45 08             	mov    0x8(%ebp),%eax
  801a94:	6a 00                	push   $0x0
  801a96:	ff 75 14             	pushl  0x14(%ebp)
  801a99:	ff 75 10             	pushl  0x10(%ebp)
  801a9c:	ff 75 0c             	pushl  0xc(%ebp)
  801a9f:	50                   	push   %eax
  801aa0:	6a 19                	push   $0x19
  801aa2:	e8 6d fd ff ff       	call   801814 <syscall>
  801aa7:	83 c4 18             	add    $0x18,%esp
}
  801aaa:	c9                   	leave  
  801aab:	c3                   	ret    

00801aac <sys_run_env>:

void sys_run_env(int32 envId)
{
  801aac:	55                   	push   %ebp
  801aad:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801aaf:	8b 45 08             	mov    0x8(%ebp),%eax
  801ab2:	6a 00                	push   $0x0
  801ab4:	6a 00                	push   $0x0
  801ab6:	6a 00                	push   $0x0
  801ab8:	6a 00                	push   $0x0
  801aba:	50                   	push   %eax
  801abb:	6a 1a                	push   $0x1a
  801abd:	e8 52 fd ff ff       	call   801814 <syscall>
  801ac2:	83 c4 18             	add    $0x18,%esp
}
  801ac5:	90                   	nop
  801ac6:	c9                   	leave  
  801ac7:	c3                   	ret    

00801ac8 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801ac8:	55                   	push   %ebp
  801ac9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801acb:	8b 45 08             	mov    0x8(%ebp),%eax
  801ace:	6a 00                	push   $0x0
  801ad0:	6a 00                	push   $0x0
  801ad2:	6a 00                	push   $0x0
  801ad4:	6a 00                	push   $0x0
  801ad6:	50                   	push   %eax
  801ad7:	6a 1b                	push   $0x1b
  801ad9:	e8 36 fd ff ff       	call   801814 <syscall>
  801ade:	83 c4 18             	add    $0x18,%esp
}
  801ae1:	c9                   	leave  
  801ae2:	c3                   	ret    

00801ae3 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801ae3:	55                   	push   %ebp
  801ae4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801ae6:	6a 00                	push   $0x0
  801ae8:	6a 00                	push   $0x0
  801aea:	6a 00                	push   $0x0
  801aec:	6a 00                	push   $0x0
  801aee:	6a 00                	push   $0x0
  801af0:	6a 05                	push   $0x5
  801af2:	e8 1d fd ff ff       	call   801814 <syscall>
  801af7:	83 c4 18             	add    $0x18,%esp
}
  801afa:	c9                   	leave  
  801afb:	c3                   	ret    

00801afc <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801afc:	55                   	push   %ebp
  801afd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801aff:	6a 00                	push   $0x0
  801b01:	6a 00                	push   $0x0
  801b03:	6a 00                	push   $0x0
  801b05:	6a 00                	push   $0x0
  801b07:	6a 00                	push   $0x0
  801b09:	6a 06                	push   $0x6
  801b0b:	e8 04 fd ff ff       	call   801814 <syscall>
  801b10:	83 c4 18             	add    $0x18,%esp
}
  801b13:	c9                   	leave  
  801b14:	c3                   	ret    

00801b15 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801b15:	55                   	push   %ebp
  801b16:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801b18:	6a 00                	push   $0x0
  801b1a:	6a 00                	push   $0x0
  801b1c:	6a 00                	push   $0x0
  801b1e:	6a 00                	push   $0x0
  801b20:	6a 00                	push   $0x0
  801b22:	6a 07                	push   $0x7
  801b24:	e8 eb fc ff ff       	call   801814 <syscall>
  801b29:	83 c4 18             	add    $0x18,%esp
}
  801b2c:	c9                   	leave  
  801b2d:	c3                   	ret    

00801b2e <sys_exit_env>:


void sys_exit_env(void)
{
  801b2e:	55                   	push   %ebp
  801b2f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801b31:	6a 00                	push   $0x0
  801b33:	6a 00                	push   $0x0
  801b35:	6a 00                	push   $0x0
  801b37:	6a 00                	push   $0x0
  801b39:	6a 00                	push   $0x0
  801b3b:	6a 1c                	push   $0x1c
  801b3d:	e8 d2 fc ff ff       	call   801814 <syscall>
  801b42:	83 c4 18             	add    $0x18,%esp
}
  801b45:	90                   	nop
  801b46:	c9                   	leave  
  801b47:	c3                   	ret    

00801b48 <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  801b48:	55                   	push   %ebp
  801b49:	89 e5                	mov    %esp,%ebp
  801b4b:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801b4e:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801b51:	8d 50 04             	lea    0x4(%eax),%edx
  801b54:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801b57:	6a 00                	push   $0x0
  801b59:	6a 00                	push   $0x0
  801b5b:	6a 00                	push   $0x0
  801b5d:	52                   	push   %edx
  801b5e:	50                   	push   %eax
  801b5f:	6a 1d                	push   $0x1d
  801b61:	e8 ae fc ff ff       	call   801814 <syscall>
  801b66:	83 c4 18             	add    $0x18,%esp
	return result;
  801b69:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801b6c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801b6f:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801b72:	89 01                	mov    %eax,(%ecx)
  801b74:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801b77:	8b 45 08             	mov    0x8(%ebp),%eax
  801b7a:	c9                   	leave  
  801b7b:	c2 04 00             	ret    $0x4

00801b7e <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801b7e:	55                   	push   %ebp
  801b7f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801b81:	6a 00                	push   $0x0
  801b83:	6a 00                	push   $0x0
  801b85:	ff 75 10             	pushl  0x10(%ebp)
  801b88:	ff 75 0c             	pushl  0xc(%ebp)
  801b8b:	ff 75 08             	pushl  0x8(%ebp)
  801b8e:	6a 13                	push   $0x13
  801b90:	e8 7f fc ff ff       	call   801814 <syscall>
  801b95:	83 c4 18             	add    $0x18,%esp
	return ;
  801b98:	90                   	nop
}
  801b99:	c9                   	leave  
  801b9a:	c3                   	ret    

00801b9b <sys_rcr2>:
uint32 sys_rcr2()
{
  801b9b:	55                   	push   %ebp
  801b9c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801b9e:	6a 00                	push   $0x0
  801ba0:	6a 00                	push   $0x0
  801ba2:	6a 00                	push   $0x0
  801ba4:	6a 00                	push   $0x0
  801ba6:	6a 00                	push   $0x0
  801ba8:	6a 1e                	push   $0x1e
  801baa:	e8 65 fc ff ff       	call   801814 <syscall>
  801baf:	83 c4 18             	add    $0x18,%esp
}
  801bb2:	c9                   	leave  
  801bb3:	c3                   	ret    

00801bb4 <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  801bb4:	55                   	push   %ebp
  801bb5:	89 e5                	mov    %esp,%ebp
  801bb7:	83 ec 04             	sub    $0x4,%esp
  801bba:	8b 45 08             	mov    0x8(%ebp),%eax
  801bbd:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801bc0:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801bc4:	6a 00                	push   $0x0
  801bc6:	6a 00                	push   $0x0
  801bc8:	6a 00                	push   $0x0
  801bca:	6a 00                	push   $0x0
  801bcc:	50                   	push   %eax
  801bcd:	6a 1f                	push   $0x1f
  801bcf:	e8 40 fc ff ff       	call   801814 <syscall>
  801bd4:	83 c4 18             	add    $0x18,%esp
	return ;
  801bd7:	90                   	nop
}
  801bd8:	c9                   	leave  
  801bd9:	c3                   	ret    

00801bda <rsttst>:
void rsttst()
{
  801bda:	55                   	push   %ebp
  801bdb:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801bdd:	6a 00                	push   $0x0
  801bdf:	6a 00                	push   $0x0
  801be1:	6a 00                	push   $0x0
  801be3:	6a 00                	push   $0x0
  801be5:	6a 00                	push   $0x0
  801be7:	6a 21                	push   $0x21
  801be9:	e8 26 fc ff ff       	call   801814 <syscall>
  801bee:	83 c4 18             	add    $0x18,%esp
	return ;
  801bf1:	90                   	nop
}
  801bf2:	c9                   	leave  
  801bf3:	c3                   	ret    

00801bf4 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801bf4:	55                   	push   %ebp
  801bf5:	89 e5                	mov    %esp,%ebp
  801bf7:	83 ec 04             	sub    $0x4,%esp
  801bfa:	8b 45 14             	mov    0x14(%ebp),%eax
  801bfd:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801c00:	8b 55 18             	mov    0x18(%ebp),%edx
  801c03:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801c07:	52                   	push   %edx
  801c08:	50                   	push   %eax
  801c09:	ff 75 10             	pushl  0x10(%ebp)
  801c0c:	ff 75 0c             	pushl  0xc(%ebp)
  801c0f:	ff 75 08             	pushl  0x8(%ebp)
  801c12:	6a 20                	push   $0x20
  801c14:	e8 fb fb ff ff       	call   801814 <syscall>
  801c19:	83 c4 18             	add    $0x18,%esp
	return ;
  801c1c:	90                   	nop
}
  801c1d:	c9                   	leave  
  801c1e:	c3                   	ret    

00801c1f <chktst>:
void chktst(uint32 n)
{
  801c1f:	55                   	push   %ebp
  801c20:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801c22:	6a 00                	push   $0x0
  801c24:	6a 00                	push   $0x0
  801c26:	6a 00                	push   $0x0
  801c28:	6a 00                	push   $0x0
  801c2a:	ff 75 08             	pushl  0x8(%ebp)
  801c2d:	6a 22                	push   $0x22
  801c2f:	e8 e0 fb ff ff       	call   801814 <syscall>
  801c34:	83 c4 18             	add    $0x18,%esp
	return ;
  801c37:	90                   	nop
}
  801c38:	c9                   	leave  
  801c39:	c3                   	ret    

00801c3a <inctst>:

void inctst()
{
  801c3a:	55                   	push   %ebp
  801c3b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801c3d:	6a 00                	push   $0x0
  801c3f:	6a 00                	push   $0x0
  801c41:	6a 00                	push   $0x0
  801c43:	6a 00                	push   $0x0
  801c45:	6a 00                	push   $0x0
  801c47:	6a 23                	push   $0x23
  801c49:	e8 c6 fb ff ff       	call   801814 <syscall>
  801c4e:	83 c4 18             	add    $0x18,%esp
	return ;
  801c51:	90                   	nop
}
  801c52:	c9                   	leave  
  801c53:	c3                   	ret    

00801c54 <gettst>:
uint32 gettst()
{
  801c54:	55                   	push   %ebp
  801c55:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801c57:	6a 00                	push   $0x0
  801c59:	6a 00                	push   $0x0
  801c5b:	6a 00                	push   $0x0
  801c5d:	6a 00                	push   $0x0
  801c5f:	6a 00                	push   $0x0
  801c61:	6a 24                	push   $0x24
  801c63:	e8 ac fb ff ff       	call   801814 <syscall>
  801c68:	83 c4 18             	add    $0x18,%esp
}
  801c6b:	c9                   	leave  
  801c6c:	c3                   	ret    

00801c6d <sys_get_uheap_strategy>:

/*2025*/
uint32 sys_get_uheap_strategy()
{
  801c6d:	55                   	push   %ebp
  801c6e:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801c70:	6a 00                	push   $0x0
  801c72:	6a 00                	push   $0x0
  801c74:	6a 00                	push   $0x0
  801c76:	6a 00                	push   $0x0
  801c78:	6a 00                	push   $0x0
  801c7a:	6a 25                	push   $0x25
  801c7c:	e8 93 fb ff ff       	call   801814 <syscall>
  801c81:	83 c4 18             	add    $0x18,%esp
  801c84:	a3 60 b0 81 00       	mov    %eax,0x81b060
	return uheapPlaceStrategy ;
  801c89:	a1 60 b0 81 00       	mov    0x81b060,%eax
}
  801c8e:	c9                   	leave  
  801c8f:	c3                   	ret    

00801c90 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801c90:	55                   	push   %ebp
  801c91:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = heapStrategy;
  801c93:	8b 45 08             	mov    0x8(%ebp),%eax
  801c96:	a3 60 b0 81 00       	mov    %eax,0x81b060
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801c9b:	6a 00                	push   $0x0
  801c9d:	6a 00                	push   $0x0
  801c9f:	6a 00                	push   $0x0
  801ca1:	6a 00                	push   $0x0
  801ca3:	ff 75 08             	pushl  0x8(%ebp)
  801ca6:	6a 26                	push   $0x26
  801ca8:	e8 67 fb ff ff       	call   801814 <syscall>
  801cad:	83 c4 18             	add    $0x18,%esp
	return ;
  801cb0:	90                   	nop
}
  801cb1:	c9                   	leave  
  801cb2:	c3                   	ret    

00801cb3 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801cb3:	55                   	push   %ebp
  801cb4:	89 e5                	mov    %esp,%ebp
  801cb6:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801cb7:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801cba:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801cbd:	8b 55 0c             	mov    0xc(%ebp),%edx
  801cc0:	8b 45 08             	mov    0x8(%ebp),%eax
  801cc3:	6a 00                	push   $0x0
  801cc5:	53                   	push   %ebx
  801cc6:	51                   	push   %ecx
  801cc7:	52                   	push   %edx
  801cc8:	50                   	push   %eax
  801cc9:	6a 27                	push   $0x27
  801ccb:	e8 44 fb ff ff       	call   801814 <syscall>
  801cd0:	83 c4 18             	add    $0x18,%esp
}
  801cd3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801cd6:	c9                   	leave  
  801cd7:	c3                   	ret    

00801cd8 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801cd8:	55                   	push   %ebp
  801cd9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801cdb:	8b 55 0c             	mov    0xc(%ebp),%edx
  801cde:	8b 45 08             	mov    0x8(%ebp),%eax
  801ce1:	6a 00                	push   $0x0
  801ce3:	6a 00                	push   $0x0
  801ce5:	6a 00                	push   $0x0
  801ce7:	52                   	push   %edx
  801ce8:	50                   	push   %eax
  801ce9:	6a 28                	push   $0x28
  801ceb:	e8 24 fb ff ff       	call   801814 <syscall>
  801cf0:	83 c4 18             	add    $0x18,%esp
}
  801cf3:	c9                   	leave  
  801cf4:	c3                   	ret    

00801cf5 <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  801cf5:	55                   	push   %ebp
  801cf6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  801cf8:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801cfb:	8b 55 0c             	mov    0xc(%ebp),%edx
  801cfe:	8b 45 08             	mov    0x8(%ebp),%eax
  801d01:	6a 00                	push   $0x0
  801d03:	51                   	push   %ecx
  801d04:	ff 75 10             	pushl  0x10(%ebp)
  801d07:	52                   	push   %edx
  801d08:	50                   	push   %eax
  801d09:	6a 29                	push   $0x29
  801d0b:	e8 04 fb ff ff       	call   801814 <syscall>
  801d10:	83 c4 18             	add    $0x18,%esp
}
  801d13:	c9                   	leave  
  801d14:	c3                   	ret    

00801d15 <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801d15:	55                   	push   %ebp
  801d16:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801d18:	6a 00                	push   $0x0
  801d1a:	6a 00                	push   $0x0
  801d1c:	ff 75 10             	pushl  0x10(%ebp)
  801d1f:	ff 75 0c             	pushl  0xc(%ebp)
  801d22:	ff 75 08             	pushl  0x8(%ebp)
  801d25:	6a 12                	push   $0x12
  801d27:	e8 e8 fa ff ff       	call   801814 <syscall>
  801d2c:	83 c4 18             	add    $0x18,%esp
	return ;
  801d2f:	90                   	nop
}
  801d30:	c9                   	leave  
  801d31:	c3                   	ret    

00801d32 <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  801d32:	55                   	push   %ebp
  801d33:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  801d35:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d38:	8b 45 08             	mov    0x8(%ebp),%eax
  801d3b:	6a 00                	push   $0x0
  801d3d:	6a 00                	push   $0x0
  801d3f:	6a 00                	push   $0x0
  801d41:	52                   	push   %edx
  801d42:	50                   	push   %eax
  801d43:	6a 2a                	push   $0x2a
  801d45:	e8 ca fa ff ff       	call   801814 <syscall>
  801d4a:	83 c4 18             	add    $0x18,%esp
	return;
  801d4d:	90                   	nop
}
  801d4e:	c9                   	leave  
  801d4f:	c3                   	ret    

00801d50 <sys_get_optimal_num_faults>:
/*2025*/
int sys_get_optimal_num_faults()
{
  801d50:	55                   	push   %ebp
  801d51:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_optimal_num_faults, 0, 0, 0, 0, 0);
  801d53:	6a 00                	push   $0x0
  801d55:	6a 00                	push   $0x0
  801d57:	6a 00                	push   $0x0
  801d59:	6a 00                	push   $0x0
  801d5b:	6a 00                	push   $0x0
  801d5d:	6a 2b                	push   $0x2b
  801d5f:	e8 b0 fa ff ff       	call   801814 <syscall>
  801d64:	83 c4 18             	add    $0x18,%esp
}
  801d67:	c9                   	leave  
  801d68:	c3                   	ret    

00801d69 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801d69:	55                   	push   %ebp
  801d6a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801d6c:	6a 00                	push   $0x0
  801d6e:	6a 00                	push   $0x0
  801d70:	6a 00                	push   $0x0
  801d72:	ff 75 0c             	pushl  0xc(%ebp)
  801d75:	ff 75 08             	pushl  0x8(%ebp)
  801d78:	6a 2d                	push   $0x2d
  801d7a:	e8 95 fa ff ff       	call   801814 <syscall>
  801d7f:	83 c4 18             	add    $0x18,%esp
	return;
  801d82:	90                   	nop
}
  801d83:	c9                   	leave  
  801d84:	c3                   	ret    

00801d85 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801d85:	55                   	push   %ebp
  801d86:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801d88:	6a 00                	push   $0x0
  801d8a:	6a 00                	push   $0x0
  801d8c:	6a 00                	push   $0x0
  801d8e:	ff 75 0c             	pushl  0xc(%ebp)
  801d91:	ff 75 08             	pushl  0x8(%ebp)
  801d94:	6a 2c                	push   $0x2c
  801d96:	e8 79 fa ff ff       	call   801814 <syscall>
  801d9b:	83 c4 18             	add    $0x18,%esp
	return ;
  801d9e:	90                   	nop
}
  801d9f:	c9                   	leave  
  801da0:	c3                   	ret    

00801da1 <sys_env_set_priority>:


void sys_env_set_priority(int32 envID, int priority)
{
  801da1:	55                   	push   %ebp
  801da2:	89 e5                	mov    %esp,%ebp
  801da4:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.IM#4] CPU SCHEDULING - #1 System Calls - Add suitable code here
	//Your code is here
	//Comment the following line
	panic("sys_env_set_priority() is not implemented yet...!!");
  801da7:	83 ec 04             	sub    $0x4,%esp
  801daa:	68 1c 2a 80 00       	push   $0x802a1c
  801daf:	68 25 01 00 00       	push   $0x125
  801db4:	68 4f 2a 80 00       	push   $0x802a4f
  801db9:	e8 9b e6 ff ff       	call   800459 <_panic>

00801dbe <env_sleep>:
#include <inc/lib.h>
#include <inc/timerreg.h>

void
env_sleep(uint32 approxMilliSeconds)
{
  801dbe:	55                   	push   %ebp
  801dbf:	89 e5                	mov    %esp,%ebp
  801dc1:	83 ec 30             	sub    $0x30,%esp
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
  801dc4:	8b 55 08             	mov    0x8(%ebp),%edx
  801dc7:	89 d0                	mov    %edx,%eax
  801dc9:	c1 e0 02             	shl    $0x2,%eax
  801dcc:	01 d0                	add    %edx,%eax
  801dce:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801dd5:	01 d0                	add    %edx,%eax
  801dd7:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801dde:	01 d0                	add    %edx,%eax
  801de0:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801de7:	01 d0                	add    %edx,%eax
  801de9:	c1 e0 04             	shl    $0x4,%eax
  801dec:	89 45 f8             	mov    %eax,-0x8(%ebp)
	uint32 cycles_counter =0;
  801def:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)

static inline __attribute__((always_inline)) struct uint64 get_virtual_time_user()
{
	struct uint64 result;

	__asm __volatile("rdtsc\n"
  801df6:	0f 31                	rdtsc  
  801df8:	89 45 e8             	mov    %eax,-0x18(%ebp)
  801dfb:	89 55 ec             	mov    %edx,-0x14(%ebp)
	: "=a" (result.low), "=d" (result.hi)
	);

	return result;
  801dfe:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801e01:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801e04:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801e07:	89 55 f4             	mov    %edx,-0xc(%ebp)

	/*2024*/ //USE A USER-SIDE VERSION OF THIS FUNCTION TO AVOID SLOW-DOWN THE PERFORMANCE DUE SYS_CALL (el7 :))
	//struct uint64 baseTime = sys_get_virtual_time() ;
	struct uint64 baseTime = get_virtual_time_user() ;
	while(cycles_counter<time_in_cycles)
  801e0a:	eb 46                	jmp    801e52 <env_sleep+0x94>

static inline __attribute__((always_inline)) struct uint64 get_virtual_time_user()
{
	struct uint64 result;

	__asm __volatile("rdtsc\n"
  801e0c:	0f 31                	rdtsc  
  801e0e:	89 45 d0             	mov    %eax,-0x30(%ebp)
  801e11:	89 55 d4             	mov    %edx,-0x2c(%ebp)
	: "=a" (result.low), "=d" (result.hi)
	);

	return result;
  801e14:	8b 45 d0             	mov    -0x30(%ebp),%eax
  801e17:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  801e1a:	89 45 e0             	mov    %eax,-0x20(%ebp)
  801e1d:	89 55 e4             	mov    %edx,-0x1c(%ebp)

		// update the cycles_count
		#define M32 0xffffffff
		// subtract basetime from current time
		struct uint64 res;
		res.low = (currentTime.low - baseTime.low) & M32;
  801e20:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801e23:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e26:	29 c2                	sub    %eax,%edx
  801e28:	89 d0                	mov    %edx,%eax
  801e2a:	89 45 d8             	mov    %eax,-0x28(%ebp)
		res.hi = (currentTime.hi - baseTime.hi - (res.low > currentTime.low)) & M32;
  801e2d:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801e30:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e33:	89 d1                	mov    %edx,%ecx
  801e35:	29 c1                	sub    %eax,%ecx
  801e37:	8b 55 d8             	mov    -0x28(%ebp),%edx
  801e3a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801e3d:	39 c2                	cmp    %eax,%edx
  801e3f:	0f 97 c0             	seta   %al
  801e42:	0f b6 c0             	movzbl %al,%eax
  801e45:	29 c1                	sub    %eax,%ecx
  801e47:	89 c8                	mov    %ecx,%eax
  801e49:	89 45 dc             	mov    %eax,-0x24(%ebp)

		//update cycles_count with result
		cycles_counter = res.low;
  801e4c:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801e4f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	uint32 cycles_counter =0;

	/*2024*/ //USE A USER-SIDE VERSION OF THIS FUNCTION TO AVOID SLOW-DOWN THE PERFORMANCE DUE SYS_CALL (el7 :))
	//struct uint64 baseTime = sys_get_virtual_time() ;
	struct uint64 baseTime = get_virtual_time_user() ;
	while(cycles_counter<time_in_cycles)
  801e52:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801e55:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801e58:	72 b2                	jb     801e0c <env_sleep+0x4e>
//				,cycles_counter
//				);
	}
	//cprintf("%s [%d] wake up now!\n", myEnv->prog_name, myEnv->env_id);

}
  801e5a:	90                   	nop
  801e5b:	c9                   	leave  
  801e5c:	c3                   	ret    

00801e5d <busy_wait>:

//2017
uint32 busy_wait(uint32 loopMax)
{
  801e5d:	55                   	push   %ebp
  801e5e:	89 e5                	mov    %esp,%ebp
  801e60:	83 ec 10             	sub    $0x10,%esp
	uint32 i = 0 ;
  801e63:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	while (i < loopMax) i++;
  801e6a:	eb 03                	jmp    801e6f <busy_wait+0x12>
  801e6c:	ff 45 fc             	incl   -0x4(%ebp)
  801e6f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801e72:	3b 45 08             	cmp    0x8(%ebp),%eax
  801e75:	72 f5                	jb     801e6c <busy_wait+0xf>
	return i;
  801e77:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801e7a:	c9                   	leave  
  801e7b:	c3                   	ret    

00801e7c <cputchar>:
#include <inc/lib.h>


void
cputchar(int ch)
{
  801e7c:	55                   	push   %ebp
  801e7d:	89 e5                	mov    %esp,%ebp
  801e7f:	83 ec 18             	sub    $0x18,%esp
	char c = ch;
  801e82:	8b 45 08             	mov    0x8(%ebp),%eax
  801e85:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	//sys_cputs(&c, 1);

	sys_cputc(c);
  801e88:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  801e8c:	83 ec 0c             	sub    $0xc,%esp
  801e8f:	50                   	push   %eax
  801e90:	e8 36 fb ff ff       	call   8019cb <sys_cputc>
  801e95:	83 c4 10             	add    $0x10,%esp
}
  801e98:	90                   	nop
  801e99:	c9                   	leave  
  801e9a:	c3                   	ret    

00801e9b <getchar>:


int
getchar(void)
{
  801e9b:	55                   	push   %ebp
  801e9c:	89 e5                	mov    %esp,%ebp
  801e9e:	83 ec 18             	sub    $0x18,%esp
	int c =sys_cgetc();
  801ea1:	e8 c4 f9 ff ff       	call   80186a <sys_cgetc>
  801ea6:	89 45 f4             	mov    %eax,-0xc(%ebp)
	return c;
  801ea9:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  801eac:	c9                   	leave  
  801ead:	c3                   	ret    

00801eae <iscons>:

int iscons(int fdnum)
{
  801eae:	55                   	push   %ebp
  801eaf:	89 e5                	mov    %esp,%ebp
	// used by readline
	return 1;
  801eb1:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801eb6:	5d                   	pop    %ebp
  801eb7:	c3                   	ret    

00801eb8 <__udivdi3>:
  801eb8:	55                   	push   %ebp
  801eb9:	57                   	push   %edi
  801eba:	56                   	push   %esi
  801ebb:	53                   	push   %ebx
  801ebc:	83 ec 1c             	sub    $0x1c,%esp
  801ebf:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  801ec3:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  801ec7:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801ecb:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801ecf:	89 ca                	mov    %ecx,%edx
  801ed1:	89 f8                	mov    %edi,%eax
  801ed3:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  801ed7:	85 f6                	test   %esi,%esi
  801ed9:	75 2d                	jne    801f08 <__udivdi3+0x50>
  801edb:	39 cf                	cmp    %ecx,%edi
  801edd:	77 65                	ja     801f44 <__udivdi3+0x8c>
  801edf:	89 fd                	mov    %edi,%ebp
  801ee1:	85 ff                	test   %edi,%edi
  801ee3:	75 0b                	jne    801ef0 <__udivdi3+0x38>
  801ee5:	b8 01 00 00 00       	mov    $0x1,%eax
  801eea:	31 d2                	xor    %edx,%edx
  801eec:	f7 f7                	div    %edi
  801eee:	89 c5                	mov    %eax,%ebp
  801ef0:	31 d2                	xor    %edx,%edx
  801ef2:	89 c8                	mov    %ecx,%eax
  801ef4:	f7 f5                	div    %ebp
  801ef6:	89 c1                	mov    %eax,%ecx
  801ef8:	89 d8                	mov    %ebx,%eax
  801efa:	f7 f5                	div    %ebp
  801efc:	89 cf                	mov    %ecx,%edi
  801efe:	89 fa                	mov    %edi,%edx
  801f00:	83 c4 1c             	add    $0x1c,%esp
  801f03:	5b                   	pop    %ebx
  801f04:	5e                   	pop    %esi
  801f05:	5f                   	pop    %edi
  801f06:	5d                   	pop    %ebp
  801f07:	c3                   	ret    
  801f08:	39 ce                	cmp    %ecx,%esi
  801f0a:	77 28                	ja     801f34 <__udivdi3+0x7c>
  801f0c:	0f bd fe             	bsr    %esi,%edi
  801f0f:	83 f7 1f             	xor    $0x1f,%edi
  801f12:	75 40                	jne    801f54 <__udivdi3+0x9c>
  801f14:	39 ce                	cmp    %ecx,%esi
  801f16:	72 0a                	jb     801f22 <__udivdi3+0x6a>
  801f18:	3b 44 24 08          	cmp    0x8(%esp),%eax
  801f1c:	0f 87 9e 00 00 00    	ja     801fc0 <__udivdi3+0x108>
  801f22:	b8 01 00 00 00       	mov    $0x1,%eax
  801f27:	89 fa                	mov    %edi,%edx
  801f29:	83 c4 1c             	add    $0x1c,%esp
  801f2c:	5b                   	pop    %ebx
  801f2d:	5e                   	pop    %esi
  801f2e:	5f                   	pop    %edi
  801f2f:	5d                   	pop    %ebp
  801f30:	c3                   	ret    
  801f31:	8d 76 00             	lea    0x0(%esi),%esi
  801f34:	31 ff                	xor    %edi,%edi
  801f36:	31 c0                	xor    %eax,%eax
  801f38:	89 fa                	mov    %edi,%edx
  801f3a:	83 c4 1c             	add    $0x1c,%esp
  801f3d:	5b                   	pop    %ebx
  801f3e:	5e                   	pop    %esi
  801f3f:	5f                   	pop    %edi
  801f40:	5d                   	pop    %ebp
  801f41:	c3                   	ret    
  801f42:	66 90                	xchg   %ax,%ax
  801f44:	89 d8                	mov    %ebx,%eax
  801f46:	f7 f7                	div    %edi
  801f48:	31 ff                	xor    %edi,%edi
  801f4a:	89 fa                	mov    %edi,%edx
  801f4c:	83 c4 1c             	add    $0x1c,%esp
  801f4f:	5b                   	pop    %ebx
  801f50:	5e                   	pop    %esi
  801f51:	5f                   	pop    %edi
  801f52:	5d                   	pop    %ebp
  801f53:	c3                   	ret    
  801f54:	bd 20 00 00 00       	mov    $0x20,%ebp
  801f59:	89 eb                	mov    %ebp,%ebx
  801f5b:	29 fb                	sub    %edi,%ebx
  801f5d:	89 f9                	mov    %edi,%ecx
  801f5f:	d3 e6                	shl    %cl,%esi
  801f61:	89 c5                	mov    %eax,%ebp
  801f63:	88 d9                	mov    %bl,%cl
  801f65:	d3 ed                	shr    %cl,%ebp
  801f67:	89 e9                	mov    %ebp,%ecx
  801f69:	09 f1                	or     %esi,%ecx
  801f6b:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  801f6f:	89 f9                	mov    %edi,%ecx
  801f71:	d3 e0                	shl    %cl,%eax
  801f73:	89 c5                	mov    %eax,%ebp
  801f75:	89 d6                	mov    %edx,%esi
  801f77:	88 d9                	mov    %bl,%cl
  801f79:	d3 ee                	shr    %cl,%esi
  801f7b:	89 f9                	mov    %edi,%ecx
  801f7d:	d3 e2                	shl    %cl,%edx
  801f7f:	8b 44 24 08          	mov    0x8(%esp),%eax
  801f83:	88 d9                	mov    %bl,%cl
  801f85:	d3 e8                	shr    %cl,%eax
  801f87:	09 c2                	or     %eax,%edx
  801f89:	89 d0                	mov    %edx,%eax
  801f8b:	89 f2                	mov    %esi,%edx
  801f8d:	f7 74 24 0c          	divl   0xc(%esp)
  801f91:	89 d6                	mov    %edx,%esi
  801f93:	89 c3                	mov    %eax,%ebx
  801f95:	f7 e5                	mul    %ebp
  801f97:	39 d6                	cmp    %edx,%esi
  801f99:	72 19                	jb     801fb4 <__udivdi3+0xfc>
  801f9b:	74 0b                	je     801fa8 <__udivdi3+0xf0>
  801f9d:	89 d8                	mov    %ebx,%eax
  801f9f:	31 ff                	xor    %edi,%edi
  801fa1:	e9 58 ff ff ff       	jmp    801efe <__udivdi3+0x46>
  801fa6:	66 90                	xchg   %ax,%ax
  801fa8:	8b 54 24 08          	mov    0x8(%esp),%edx
  801fac:	89 f9                	mov    %edi,%ecx
  801fae:	d3 e2                	shl    %cl,%edx
  801fb0:	39 c2                	cmp    %eax,%edx
  801fb2:	73 e9                	jae    801f9d <__udivdi3+0xe5>
  801fb4:	8d 43 ff             	lea    -0x1(%ebx),%eax
  801fb7:	31 ff                	xor    %edi,%edi
  801fb9:	e9 40 ff ff ff       	jmp    801efe <__udivdi3+0x46>
  801fbe:	66 90                	xchg   %ax,%ax
  801fc0:	31 c0                	xor    %eax,%eax
  801fc2:	e9 37 ff ff ff       	jmp    801efe <__udivdi3+0x46>
  801fc7:	90                   	nop

00801fc8 <__umoddi3>:
  801fc8:	55                   	push   %ebp
  801fc9:	57                   	push   %edi
  801fca:	56                   	push   %esi
  801fcb:	53                   	push   %ebx
  801fcc:	83 ec 1c             	sub    $0x1c,%esp
  801fcf:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  801fd3:	8b 74 24 34          	mov    0x34(%esp),%esi
  801fd7:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801fdb:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  801fdf:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801fe3:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801fe7:	89 f3                	mov    %esi,%ebx
  801fe9:	89 fa                	mov    %edi,%edx
  801feb:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801fef:	89 34 24             	mov    %esi,(%esp)
  801ff2:	85 c0                	test   %eax,%eax
  801ff4:	75 1a                	jne    802010 <__umoddi3+0x48>
  801ff6:	39 f7                	cmp    %esi,%edi
  801ff8:	0f 86 a2 00 00 00    	jbe    8020a0 <__umoddi3+0xd8>
  801ffe:	89 c8                	mov    %ecx,%eax
  802000:	89 f2                	mov    %esi,%edx
  802002:	f7 f7                	div    %edi
  802004:	89 d0                	mov    %edx,%eax
  802006:	31 d2                	xor    %edx,%edx
  802008:	83 c4 1c             	add    $0x1c,%esp
  80200b:	5b                   	pop    %ebx
  80200c:	5e                   	pop    %esi
  80200d:	5f                   	pop    %edi
  80200e:	5d                   	pop    %ebp
  80200f:	c3                   	ret    
  802010:	39 f0                	cmp    %esi,%eax
  802012:	0f 87 ac 00 00 00    	ja     8020c4 <__umoddi3+0xfc>
  802018:	0f bd e8             	bsr    %eax,%ebp
  80201b:	83 f5 1f             	xor    $0x1f,%ebp
  80201e:	0f 84 ac 00 00 00    	je     8020d0 <__umoddi3+0x108>
  802024:	bf 20 00 00 00       	mov    $0x20,%edi
  802029:	29 ef                	sub    %ebp,%edi
  80202b:	89 fe                	mov    %edi,%esi
  80202d:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802031:	89 e9                	mov    %ebp,%ecx
  802033:	d3 e0                	shl    %cl,%eax
  802035:	89 d7                	mov    %edx,%edi
  802037:	89 f1                	mov    %esi,%ecx
  802039:	d3 ef                	shr    %cl,%edi
  80203b:	09 c7                	or     %eax,%edi
  80203d:	89 e9                	mov    %ebp,%ecx
  80203f:	d3 e2                	shl    %cl,%edx
  802041:	89 14 24             	mov    %edx,(%esp)
  802044:	89 d8                	mov    %ebx,%eax
  802046:	d3 e0                	shl    %cl,%eax
  802048:	89 c2                	mov    %eax,%edx
  80204a:	8b 44 24 08          	mov    0x8(%esp),%eax
  80204e:	d3 e0                	shl    %cl,%eax
  802050:	89 44 24 04          	mov    %eax,0x4(%esp)
  802054:	8b 44 24 08          	mov    0x8(%esp),%eax
  802058:	89 f1                	mov    %esi,%ecx
  80205a:	d3 e8                	shr    %cl,%eax
  80205c:	09 d0                	or     %edx,%eax
  80205e:	d3 eb                	shr    %cl,%ebx
  802060:	89 da                	mov    %ebx,%edx
  802062:	f7 f7                	div    %edi
  802064:	89 d3                	mov    %edx,%ebx
  802066:	f7 24 24             	mull   (%esp)
  802069:	89 c6                	mov    %eax,%esi
  80206b:	89 d1                	mov    %edx,%ecx
  80206d:	39 d3                	cmp    %edx,%ebx
  80206f:	0f 82 87 00 00 00    	jb     8020fc <__umoddi3+0x134>
  802075:	0f 84 91 00 00 00    	je     80210c <__umoddi3+0x144>
  80207b:	8b 54 24 04          	mov    0x4(%esp),%edx
  80207f:	29 f2                	sub    %esi,%edx
  802081:	19 cb                	sbb    %ecx,%ebx
  802083:	89 d8                	mov    %ebx,%eax
  802085:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  802089:	d3 e0                	shl    %cl,%eax
  80208b:	89 e9                	mov    %ebp,%ecx
  80208d:	d3 ea                	shr    %cl,%edx
  80208f:	09 d0                	or     %edx,%eax
  802091:	89 e9                	mov    %ebp,%ecx
  802093:	d3 eb                	shr    %cl,%ebx
  802095:	89 da                	mov    %ebx,%edx
  802097:	83 c4 1c             	add    $0x1c,%esp
  80209a:	5b                   	pop    %ebx
  80209b:	5e                   	pop    %esi
  80209c:	5f                   	pop    %edi
  80209d:	5d                   	pop    %ebp
  80209e:	c3                   	ret    
  80209f:	90                   	nop
  8020a0:	89 fd                	mov    %edi,%ebp
  8020a2:	85 ff                	test   %edi,%edi
  8020a4:	75 0b                	jne    8020b1 <__umoddi3+0xe9>
  8020a6:	b8 01 00 00 00       	mov    $0x1,%eax
  8020ab:	31 d2                	xor    %edx,%edx
  8020ad:	f7 f7                	div    %edi
  8020af:	89 c5                	mov    %eax,%ebp
  8020b1:	89 f0                	mov    %esi,%eax
  8020b3:	31 d2                	xor    %edx,%edx
  8020b5:	f7 f5                	div    %ebp
  8020b7:	89 c8                	mov    %ecx,%eax
  8020b9:	f7 f5                	div    %ebp
  8020bb:	89 d0                	mov    %edx,%eax
  8020bd:	e9 44 ff ff ff       	jmp    802006 <__umoddi3+0x3e>
  8020c2:	66 90                	xchg   %ax,%ax
  8020c4:	89 c8                	mov    %ecx,%eax
  8020c6:	89 f2                	mov    %esi,%edx
  8020c8:	83 c4 1c             	add    $0x1c,%esp
  8020cb:	5b                   	pop    %ebx
  8020cc:	5e                   	pop    %esi
  8020cd:	5f                   	pop    %edi
  8020ce:	5d                   	pop    %ebp
  8020cf:	c3                   	ret    
  8020d0:	3b 04 24             	cmp    (%esp),%eax
  8020d3:	72 06                	jb     8020db <__umoddi3+0x113>
  8020d5:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  8020d9:	77 0f                	ja     8020ea <__umoddi3+0x122>
  8020db:	89 f2                	mov    %esi,%edx
  8020dd:	29 f9                	sub    %edi,%ecx
  8020df:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  8020e3:	89 14 24             	mov    %edx,(%esp)
  8020e6:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8020ea:	8b 44 24 04          	mov    0x4(%esp),%eax
  8020ee:	8b 14 24             	mov    (%esp),%edx
  8020f1:	83 c4 1c             	add    $0x1c,%esp
  8020f4:	5b                   	pop    %ebx
  8020f5:	5e                   	pop    %esi
  8020f6:	5f                   	pop    %edi
  8020f7:	5d                   	pop    %ebp
  8020f8:	c3                   	ret    
  8020f9:	8d 76 00             	lea    0x0(%esi),%esi
  8020fc:	2b 04 24             	sub    (%esp),%eax
  8020ff:	19 fa                	sbb    %edi,%edx
  802101:	89 d1                	mov    %edx,%ecx
  802103:	89 c6                	mov    %eax,%esi
  802105:	e9 71 ff ff ff       	jmp    80207b <__umoddi3+0xb3>
  80210a:	66 90                	xchg   %ax,%ax
  80210c:	39 44 24 04          	cmp    %eax,0x4(%esp)
  802110:	72 ea                	jb     8020fc <__umoddi3+0x134>
  802112:	89 d9                	mov    %ebx,%ecx
  802114:	e9 62 ff ff ff       	jmp    80207b <__umoddi3+0xb3>
