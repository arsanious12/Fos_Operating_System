
obj/user/tst_chan_one_slave:     file format elf32-i386


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
  800031:	e8 a6 01 00 00       	call   8001dc <libmain>
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
  80003e:	81 ec 2c 01 00 00    	sub    $0x12c,%esp
	int envID = sys_getenvid();
  800044:	e8 c5 17 00 00       	call   80180e <sys_getenvid>
  800049:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	//Sleep on the channel
	char cmd0[64] = "__Sleep__";
  80004c:	8d 45 98             	lea    -0x68(%ebp),%eax
  80004f:	bb a1 1e 80 00       	mov    $0x801ea1,%ebx
  800054:	ba 0a 00 00 00       	mov    $0xa,%edx
  800059:	89 c7                	mov    %eax,%edi
  80005b:	89 de                	mov    %ebx,%esi
  80005d:	89 d1                	mov    %edx,%ecx
  80005f:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  800061:	8d 55 a2             	lea    -0x5e(%ebp),%edx
  800064:	b9 36 00 00 00       	mov    $0x36,%ecx
  800069:	b0 00                	mov    $0x0,%al
  80006b:	89 d7                	mov    %edx,%edi
  80006d:	f3 aa                	rep stos %al,%es:(%edi)
	sys_utilities(cmd0, 0);
  80006f:	83 ec 08             	sub    $0x8,%esp
  800072:	6a 00                	push   $0x0
  800074:	8d 45 98             	lea    -0x68(%ebp),%eax
  800077:	50                   	push   %eax
  800078:	e8 e0 19 00 00       	call   801a5d <sys_utilities>
  80007d:	83 c4 10             	add    $0x10,%esp

	//wait for a while
	env_sleep(RAND(1000, 5000));
  800080:	8d 45 d8             	lea    -0x28(%ebp),%eax
  800083:	83 ec 0c             	sub    $0xc,%esp
  800086:	50                   	push   %eax
  800087:	e8 e7 17 00 00       	call   801873 <sys_get_virtual_time>
  80008c:	83 c4 0c             	add    $0xc,%esp
  80008f:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800092:	b9 a0 0f 00 00       	mov    $0xfa0,%ecx
  800097:	ba 00 00 00 00       	mov    $0x0,%edx
  80009c:	f7 f1                	div    %ecx
  80009e:	89 d0                	mov    %edx,%eax
  8000a0:	05 e8 03 00 00       	add    $0x3e8,%eax
  8000a5:	83 ec 0c             	sub    $0xc,%esp
  8000a8:	50                   	push   %eax
  8000a9:	e8 3b 1a 00 00       	call   801ae9 <env_sleep>
  8000ae:	83 c4 10             	add    $0x10,%esp

	//Validate the number of blocked processes till now
	int numOfBlockedProcesses = 0;
  8000b1:	c7 45 94 00 00 00 00 	movl   $0x0,-0x6c(%ebp)
	char cmd1[64] = "__GetChanQueueSize__";
  8000b8:	8d 85 54 ff ff ff    	lea    -0xac(%ebp),%eax
  8000be:	bb e1 1e 80 00       	mov    $0x801ee1,%ebx
  8000c3:	ba 15 00 00 00       	mov    $0x15,%edx
  8000c8:	89 c7                	mov    %eax,%edi
  8000ca:	89 de                	mov    %ebx,%esi
  8000cc:	89 d1                	mov    %edx,%ecx
  8000ce:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  8000d0:	8d 95 69 ff ff ff    	lea    -0x97(%ebp),%edx
  8000d6:	b9 2b 00 00 00       	mov    $0x2b,%ecx
  8000db:	b0 00                	mov    $0x0,%al
  8000dd:	89 d7                	mov    %edx,%edi
  8000df:	f3 aa                	rep stos %al,%es:(%edi)
	sys_utilities(cmd1, (uint32)(&numOfBlockedProcesses));
  8000e1:	8d 45 94             	lea    -0x6c(%ebp),%eax
  8000e4:	83 ec 08             	sub    $0x8,%esp
  8000e7:	50                   	push   %eax
  8000e8:	8d 85 54 ff ff ff    	lea    -0xac(%ebp),%eax
  8000ee:	50                   	push   %eax
  8000ef:	e8 69 19 00 00       	call   801a5d <sys_utilities>
  8000f4:	83 c4 10             	add    $0x10,%esp
	int numOfWakenupProcesses = gettst() ;
  8000f7:	e8 83 18 00 00       	call   80197f <gettst>
  8000fc:	89 45 e0             	mov    %eax,-0x20(%ebp)
	int numOfSlaves = 0;
  8000ff:	c7 85 50 ff ff ff 00 	movl   $0x0,-0xb0(%ebp)
  800106:	00 00 00 
	char cmd2[64] = "__NumOfSlaves@Get";
  800109:	8d 85 10 ff ff ff    	lea    -0xf0(%ebp),%eax
  80010f:	bb 21 1f 80 00       	mov    $0x801f21,%ebx
  800114:	ba 12 00 00 00       	mov    $0x12,%edx
  800119:	89 c7                	mov    %eax,%edi
  80011b:	89 de                	mov    %ebx,%esi
  80011d:	89 d1                	mov    %edx,%ecx
  80011f:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  800121:	8d 95 22 ff ff ff    	lea    -0xde(%ebp),%edx
  800127:	b9 2e 00 00 00       	mov    $0x2e,%ecx
  80012c:	b0 00                	mov    $0x0,%al
  80012e:	89 d7                	mov    %edx,%edi
  800130:	f3 aa                	rep stos %al,%es:(%edi)
	sys_utilities(cmd2, (uint32)(&numOfSlaves));
  800132:	8d 85 50 ff ff ff    	lea    -0xb0(%ebp),%eax
  800138:	83 ec 08             	sub    $0x8,%esp
  80013b:	50                   	push   %eax
  80013c:	8d 85 10 ff ff ff    	lea    -0xf0(%ebp),%eax
  800142:	50                   	push   %eax
  800143:	e8 15 19 00 00       	call   801a5d <sys_utilities>
  800148:	83 c4 10             	add    $0x10,%esp

	if (numOfWakenupProcesses + numOfBlockedProcesses != numOfSlaves - 1 /*Except this process since it not indicating wakeup yet*/)
  80014b:	8b 55 94             	mov    -0x6c(%ebp),%edx
  80014e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800151:	01 c2                	add    %eax,%edx
  800153:	8b 85 50 ff ff ff    	mov    -0xb0(%ebp),%eax
  800159:	48                   	dec    %eax
  80015a:	39 c2                	cmp    %eax,%edx
  80015c:	74 14                	je     800172 <_main+0x13a>
	{
		panic("%~test channels failed! inconsistent number of blocked & waken-up processes.");
  80015e:	83 ec 04             	sub    $0x4,%esp
  800161:	68 20 1e 80 00       	push   $0x801e20
  800166:	6a 1d                	push   $0x1d
  800168:	68 6d 1e 80 00       	push   $0x801e6d
  80016d:	e8 1a 02 00 00       	call   80038c <_panic>
	}

	//indicates wakenup
	inctst();
  800172:	e8 ee 17 00 00       	call   801965 <inctst>

	//wakeup another one
	char cmd3[64] = "__WakeupOne__";
  800177:	8d 85 d0 fe ff ff    	lea    -0x130(%ebp),%eax
  80017d:	bb 61 1f 80 00       	mov    $0x801f61,%ebx
  800182:	ba 0e 00 00 00       	mov    $0xe,%edx
  800187:	89 c7                	mov    %eax,%edi
  800189:	89 de                	mov    %ebx,%esi
  80018b:	89 d1                	mov    %edx,%ecx
  80018d:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  80018f:	8d 95 de fe ff ff    	lea    -0x122(%ebp),%edx
  800195:	b9 32 00 00 00       	mov    $0x32,%ecx
  80019a:	b0 00                	mov    $0x0,%al
  80019c:	89 d7                	mov    %edx,%edi
  80019e:	f3 aa                	rep stos %al,%es:(%edi)
	sys_utilities(cmd3, 0);
  8001a0:	83 ec 08             	sub    $0x8,%esp
  8001a3:	6a 00                	push   $0x0
  8001a5:	8d 85 d0 fe ff ff    	lea    -0x130(%ebp),%eax
  8001ab:	50                   	push   %eax
  8001ac:	e8 ac 18 00 00       	call   801a5d <sys_utilities>
  8001b1:	83 c4 10             	add    $0x10,%esp

	cprintf_colored(TEXT_light_magenta, ">>> Slave %d is Finished\n", envID);
  8001b4:	83 ec 04             	sub    $0x4,%esp
  8001b7:	ff 75 e4             	pushl  -0x1c(%ebp)
  8001ba:	68 87 1e 80 00       	push   $0x801e87
  8001bf:	6a 0d                	push   $0xd
  8001c1:	e8 c1 04 00 00       	call   800687 <cprintf_colored>
  8001c6:	83 c4 10             	add    $0x10,%esp
	printStats = 0;
  8001c9:	c7 05 00 30 80 00 00 	movl   $0x0,0x803000
  8001d0:	00 00 00 
	return;
  8001d3:	90                   	nop
}
  8001d4:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8001d7:	5b                   	pop    %ebx
  8001d8:	5e                   	pop    %esi
  8001d9:	5f                   	pop    %edi
  8001da:	5d                   	pop    %ebp
  8001db:	c3                   	ret    

008001dc <libmain>:
volatile bool printStats = 1;

volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";
void
libmain(int argc, char **argv)
{
  8001dc:	55                   	push   %ebp
  8001dd:	89 e5                	mov    %esp,%ebp
  8001df:	57                   	push   %edi
  8001e0:	56                   	push   %esi
  8001e1:	53                   	push   %ebx
  8001e2:	83 ec 7c             	sub    $0x7c,%esp
	//printStats = 1;
	int envIndex = sys_getenvindex();
  8001e5:	e8 3d 16 00 00       	call   801827 <sys_getenvindex>
  8001ea:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	myEnv = &(envs[envIndex]);
  8001ed:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8001f0:	89 d0                	mov    %edx,%eax
  8001f2:	c1 e0 02             	shl    $0x2,%eax
  8001f5:	01 d0                	add    %edx,%eax
  8001f7:	c1 e0 03             	shl    $0x3,%eax
  8001fa:	01 d0                	add    %edx,%eax
  8001fc:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  800203:	01 d0                	add    %edx,%eax
  800205:	c1 e0 02             	shl    $0x2,%eax
  800208:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80020d:	a3 20 30 80 00       	mov    %eax,0x803020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800212:	a1 20 30 80 00       	mov    0x803020,%eax
  800217:	8a 40 20             	mov    0x20(%eax),%al
  80021a:	84 c0                	test   %al,%al
  80021c:	74 0d                	je     80022b <libmain+0x4f>
		binaryname = myEnv->prog_name;
  80021e:	a1 20 30 80 00       	mov    0x803020,%eax
  800223:	83 c0 20             	add    $0x20,%eax
  800226:	a3 04 30 80 00       	mov    %eax,0x803004

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80022b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80022f:	7e 0a                	jle    80023b <libmain+0x5f>
		binaryname = argv[0];
  800231:	8b 45 0c             	mov    0xc(%ebp),%eax
  800234:	8b 00                	mov    (%eax),%eax
  800236:	a3 04 30 80 00       	mov    %eax,0x803004

	// call user main routine
	_main(argc, argv);
  80023b:	83 ec 08             	sub    $0x8,%esp
  80023e:	ff 75 0c             	pushl  0xc(%ebp)
  800241:	ff 75 08             	pushl  0x8(%ebp)
  800244:	e8 ef fd ff ff       	call   800038 <_main>
  800249:	83 c4 10             	add    $0x10,%esp

	if (printStats)
  80024c:	a1 00 30 80 00       	mov    0x803000,%eax
  800251:	85 c0                	test   %eax,%eax
  800253:	0f 84 01 01 00 00    	je     80035a <libmain+0x17e>
	{
		char isOPTReplCmd[100] = "__IsOPTRepl__" ;
  800259:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  80025f:	bb 9c 20 80 00       	mov    $0x80209c,%ebx
  800264:	ba 0e 00 00 00       	mov    $0xe,%edx
  800269:	89 c7                	mov    %eax,%edi
  80026b:	89 de                	mov    %ebx,%esi
  80026d:	89 d1                	mov    %edx,%ecx
  80026f:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  800271:	8d 55 8a             	lea    -0x76(%ebp),%edx
  800274:	b9 56 00 00 00       	mov    $0x56,%ecx
  800279:	b0 00                	mov    $0x0,%al
  80027b:	89 d7                	mov    %edx,%edi
  80027d:	f3 aa                	rep stos %al,%es:(%edi)
		int isOPTRepl = 0;
  80027f:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
		sys_utilities(isOPTReplCmd, (uint32)(&isOPTRepl));
  800286:	8d 45 e0             	lea    -0x20(%ebp),%eax
  800289:	83 ec 08             	sub    $0x8,%esp
  80028c:	50                   	push   %eax
  80028d:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  800293:	50                   	push   %eax
  800294:	e8 c4 17 00 00       	call   801a5d <sys_utilities>
  800299:	83 c4 10             	add    $0x10,%esp

		sys_lock_cons();
  80029c:	e8 0d 13 00 00       	call   8015ae <sys_lock_cons>
		{
			cprintf("**************************************\n");
  8002a1:	83 ec 0c             	sub    $0xc,%esp
  8002a4:	68 bc 1f 80 00       	push   $0x801fbc
  8002a9:	e8 ac 03 00 00       	call   80065a <cprintf>
  8002ae:	83 c4 10             	add    $0x10,%esp
			if (isOPTRepl)
  8002b1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8002b4:	85 c0                	test   %eax,%eax
  8002b6:	74 18                	je     8002d0 <libmain+0xf4>
			{
				cprintf("OPTIMAL number of page faults = %d\n", sys_get_optimal_num_faults());
  8002b8:	e8 be 17 00 00       	call   801a7b <sys_get_optimal_num_faults>
  8002bd:	83 ec 08             	sub    $0x8,%esp
  8002c0:	50                   	push   %eax
  8002c1:	68 e4 1f 80 00       	push   $0x801fe4
  8002c6:	e8 8f 03 00 00       	call   80065a <cprintf>
  8002cb:	83 c4 10             	add    $0x10,%esp
  8002ce:	eb 59                	jmp    800329 <libmain+0x14d>
			}
			else
			{
				cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8002d0:	a1 20 30 80 00       	mov    0x803020,%eax
  8002d5:	8b 90 a8 05 00 00    	mov    0x5a8(%eax),%edx
  8002db:	a1 20 30 80 00       	mov    0x803020,%eax
  8002e0:	8b 80 98 05 00 00    	mov    0x598(%eax),%eax
  8002e6:	83 ec 04             	sub    $0x4,%esp
  8002e9:	52                   	push   %edx
  8002ea:	50                   	push   %eax
  8002eb:	68 08 20 80 00       	push   $0x802008
  8002f0:	e8 65 03 00 00       	call   80065a <cprintf>
  8002f5:	83 c4 10             	add    $0x10,%esp
				cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  8002f8:	a1 20 30 80 00       	mov    0x803020,%eax
  8002fd:	8b 88 bc 05 00 00    	mov    0x5bc(%eax),%ecx
  800303:	a1 20 30 80 00       	mov    0x803020,%eax
  800308:	8b 90 b8 05 00 00    	mov    0x5b8(%eax),%edx
  80030e:	a1 20 30 80 00       	mov    0x803020,%eax
  800313:	8b 80 b4 05 00 00    	mov    0x5b4(%eax),%eax
  800319:	51                   	push   %ecx
  80031a:	52                   	push   %edx
  80031b:	50                   	push   %eax
  80031c:	68 30 20 80 00       	push   $0x802030
  800321:	e8 34 03 00 00       	call   80065a <cprintf>
  800326:	83 c4 10             	add    $0x10,%esp
			}
			//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
			cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800329:	a1 20 30 80 00       	mov    0x803020,%eax
  80032e:	8b 80 c0 05 00 00    	mov    0x5c0(%eax),%eax
  800334:	83 ec 08             	sub    $0x8,%esp
  800337:	50                   	push   %eax
  800338:	68 88 20 80 00       	push   $0x802088
  80033d:	e8 18 03 00 00       	call   80065a <cprintf>
  800342:	83 c4 10             	add    $0x10,%esp
			cprintf("**************************************\n");
  800345:	83 ec 0c             	sub    $0xc,%esp
  800348:	68 bc 1f 80 00       	push   $0x801fbc
  80034d:	e8 08 03 00 00       	call   80065a <cprintf>
  800352:	83 c4 10             	add    $0x10,%esp
		}
		sys_unlock_cons();
  800355:	e8 6e 12 00 00       	call   8015c8 <sys_unlock_cons>
	}

	// exit gracefully
	exit();
  80035a:	e8 1f 00 00 00       	call   80037e <exit>
}
  80035f:	90                   	nop
  800360:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800363:	5b                   	pop    %ebx
  800364:	5e                   	pop    %esi
  800365:	5f                   	pop    %edi
  800366:	5d                   	pop    %ebp
  800367:	c3                   	ret    

00800368 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800368:	55                   	push   %ebp
  800369:	89 e5                	mov    %esp,%ebp
  80036b:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  80036e:	83 ec 0c             	sub    $0xc,%esp
  800371:	6a 00                	push   $0x0
  800373:	e8 7b 14 00 00       	call   8017f3 <sys_destroy_env>
  800378:	83 c4 10             	add    $0x10,%esp
}
  80037b:	90                   	nop
  80037c:	c9                   	leave  
  80037d:	c3                   	ret    

0080037e <exit>:

void
exit(void)
{
  80037e:	55                   	push   %ebp
  80037f:	89 e5                	mov    %esp,%ebp
  800381:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  800384:	e8 d0 14 00 00       	call   801859 <sys_exit_env>
}
  800389:	90                   	nop
  80038a:	c9                   	leave  
  80038b:	c3                   	ret    

0080038c <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  80038c:	55                   	push   %ebp
  80038d:	89 e5                	mov    %esp,%ebp
  80038f:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  800392:	8d 45 10             	lea    0x10(%ebp),%eax
  800395:	83 c0 04             	add    $0x4,%eax
  800398:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  80039b:	a1 18 b1 81 00       	mov    0x81b118,%eax
  8003a0:	85 c0                	test   %eax,%eax
  8003a2:	74 16                	je     8003ba <_panic+0x2e>
		cprintf("%s: ", argv0);
  8003a4:	a1 18 b1 81 00       	mov    0x81b118,%eax
  8003a9:	83 ec 08             	sub    $0x8,%esp
  8003ac:	50                   	push   %eax
  8003ad:	68 00 21 80 00       	push   $0x802100
  8003b2:	e8 a3 02 00 00       	call   80065a <cprintf>
  8003b7:	83 c4 10             	add    $0x10,%esp
	cprintf_colored(TEXT_PANIC_CLR, "user [EVAL_FINAL]panic in %s at %s:%d: ", binaryname, file, line);
  8003ba:	a1 04 30 80 00       	mov    0x803004,%eax
  8003bf:	83 ec 0c             	sub    $0xc,%esp
  8003c2:	ff 75 0c             	pushl  0xc(%ebp)
  8003c5:	ff 75 08             	pushl  0x8(%ebp)
  8003c8:	50                   	push   %eax
  8003c9:	68 08 21 80 00       	push   $0x802108
  8003ce:	6a 74                	push   $0x74
  8003d0:	e8 b2 02 00 00       	call   800687 <cprintf_colored>
  8003d5:	83 c4 20             	add    $0x20,%esp
	vcprintf(fmt, ap);
  8003d8:	8b 45 10             	mov    0x10(%ebp),%eax
  8003db:	83 ec 08             	sub    $0x8,%esp
  8003de:	ff 75 f4             	pushl  -0xc(%ebp)
  8003e1:	50                   	push   %eax
  8003e2:	e8 04 02 00 00       	call   8005eb <vcprintf>
  8003e7:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  8003ea:	83 ec 08             	sub    $0x8,%esp
  8003ed:	6a 00                	push   $0x0
  8003ef:	68 30 21 80 00       	push   $0x802130
  8003f4:	e8 f2 01 00 00       	call   8005eb <vcprintf>
  8003f9:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  8003fc:	e8 7d ff ff ff       	call   80037e <exit>

	// should not return here
	while (1) ;
  800401:	eb fe                	jmp    800401 <_panic+0x75>

00800403 <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  800403:	55                   	push   %ebp
  800404:	89 e5                	mov    %esp,%ebp
  800406:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  800409:	a1 20 30 80 00       	mov    0x803020,%eax
  80040e:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  800414:	8b 45 0c             	mov    0xc(%ebp),%eax
  800417:	39 c2                	cmp    %eax,%edx
  800419:	74 14                	je     80042f <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  80041b:	83 ec 04             	sub    $0x4,%esp
  80041e:	68 34 21 80 00       	push   $0x802134
  800423:	6a 26                	push   $0x26
  800425:	68 80 21 80 00       	push   $0x802180
  80042a:	e8 5d ff ff ff       	call   80038c <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  80042f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  800436:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80043d:	e9 c5 00 00 00       	jmp    800507 <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  800442:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800445:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80044c:	8b 45 08             	mov    0x8(%ebp),%eax
  80044f:	01 d0                	add    %edx,%eax
  800451:	8b 00                	mov    (%eax),%eax
  800453:	85 c0                	test   %eax,%eax
  800455:	75 08                	jne    80045f <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  800457:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  80045a:	e9 a5 00 00 00       	jmp    800504 <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  80045f:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800466:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  80046d:	eb 69                	jmp    8004d8 <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  80046f:	a1 20 30 80 00       	mov    0x803020,%eax
  800474:	8b 88 90 05 00 00    	mov    0x590(%eax),%ecx
  80047a:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80047d:	89 d0                	mov    %edx,%eax
  80047f:	01 c0                	add    %eax,%eax
  800481:	01 d0                	add    %edx,%eax
  800483:	c1 e0 03             	shl    $0x3,%eax
  800486:	01 c8                	add    %ecx,%eax
  800488:	8a 40 04             	mov    0x4(%eax),%al
  80048b:	84 c0                	test   %al,%al
  80048d:	75 46                	jne    8004d5 <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  80048f:	a1 20 30 80 00       	mov    0x803020,%eax
  800494:	8b 88 90 05 00 00    	mov    0x590(%eax),%ecx
  80049a:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80049d:	89 d0                	mov    %edx,%eax
  80049f:	01 c0                	add    %eax,%eax
  8004a1:	01 d0                	add    %edx,%eax
  8004a3:	c1 e0 03             	shl    $0x3,%eax
  8004a6:	01 c8                	add    %ecx,%eax
  8004a8:	8b 00                	mov    (%eax),%eax
  8004aa:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8004ad:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8004b0:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8004b5:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  8004b7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8004ba:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8004c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8004c4:	01 c8                	add    %ecx,%eax
  8004c6:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8004c8:	39 c2                	cmp    %eax,%edx
  8004ca:	75 09                	jne    8004d5 <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  8004cc:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  8004d3:	eb 15                	jmp    8004ea <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8004d5:	ff 45 e8             	incl   -0x18(%ebp)
  8004d8:	a1 20 30 80 00       	mov    0x803020,%eax
  8004dd:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  8004e3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8004e6:	39 c2                	cmp    %eax,%edx
  8004e8:	77 85                	ja     80046f <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  8004ea:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8004ee:	75 14                	jne    800504 <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  8004f0:	83 ec 04             	sub    $0x4,%esp
  8004f3:	68 8c 21 80 00       	push   $0x80218c
  8004f8:	6a 3a                	push   $0x3a
  8004fa:	68 80 21 80 00       	push   $0x802180
  8004ff:	e8 88 fe ff ff       	call   80038c <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  800504:	ff 45 f0             	incl   -0x10(%ebp)
  800507:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80050a:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80050d:	0f 8c 2f ff ff ff    	jl     800442 <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  800513:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80051a:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800521:	eb 26                	jmp    800549 <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  800523:	a1 20 30 80 00       	mov    0x803020,%eax
  800528:	8b 88 90 05 00 00    	mov    0x590(%eax),%ecx
  80052e:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800531:	89 d0                	mov    %edx,%eax
  800533:	01 c0                	add    %eax,%eax
  800535:	01 d0                	add    %edx,%eax
  800537:	c1 e0 03             	shl    $0x3,%eax
  80053a:	01 c8                	add    %ecx,%eax
  80053c:	8a 40 04             	mov    0x4(%eax),%al
  80053f:	3c 01                	cmp    $0x1,%al
  800541:	75 03                	jne    800546 <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  800543:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800546:	ff 45 e0             	incl   -0x20(%ebp)
  800549:	a1 20 30 80 00       	mov    0x803020,%eax
  80054e:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  800554:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800557:	39 c2                	cmp    %eax,%edx
  800559:	77 c8                	ja     800523 <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  80055b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80055e:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800561:	74 14                	je     800577 <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  800563:	83 ec 04             	sub    $0x4,%esp
  800566:	68 e0 21 80 00       	push   $0x8021e0
  80056b:	6a 44                	push   $0x44
  80056d:	68 80 21 80 00       	push   $0x802180
  800572:	e8 15 fe ff ff       	call   80038c <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  800577:	90                   	nop
  800578:	c9                   	leave  
  800579:	c3                   	ret    

0080057a <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  80057a:	55                   	push   %ebp
  80057b:	89 e5                	mov    %esp,%ebp
  80057d:	53                   	push   %ebx
  80057e:	83 ec 04             	sub    $0x4,%esp
	b->buf[b->idx++] = ch;
  800581:	8b 45 0c             	mov    0xc(%ebp),%eax
  800584:	8b 00                	mov    (%eax),%eax
  800586:	8d 48 01             	lea    0x1(%eax),%ecx
  800589:	8b 55 0c             	mov    0xc(%ebp),%edx
  80058c:	89 0a                	mov    %ecx,(%edx)
  80058e:	8b 55 08             	mov    0x8(%ebp),%edx
  800591:	88 d1                	mov    %dl,%cl
  800593:	8b 55 0c             	mov    0xc(%ebp),%edx
  800596:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  80059a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80059d:	8b 00                	mov    (%eax),%eax
  80059f:	3d ff 00 00 00       	cmp    $0xff,%eax
  8005a4:	75 30                	jne    8005d6 <putch+0x5c>
		sys_cputs(b->buf, b->idx, printProgName, curTextClr);
  8005a6:	8b 15 1c b1 81 00    	mov    0x81b11c,%edx
  8005ac:	a0 44 30 80 00       	mov    0x803044,%al
  8005b1:	0f b6 c0             	movzbl %al,%eax
  8005b4:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8005b7:	8b 09                	mov    (%ecx),%ecx
  8005b9:	89 cb                	mov    %ecx,%ebx
  8005bb:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8005be:	83 c1 08             	add    $0x8,%ecx
  8005c1:	52                   	push   %edx
  8005c2:	50                   	push   %eax
  8005c3:	53                   	push   %ebx
  8005c4:	51                   	push   %ecx
  8005c5:	e8 a0 0f 00 00       	call   80156a <sys_cputs>
  8005ca:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8005cd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8005d0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8005d6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8005d9:	8b 40 04             	mov    0x4(%eax),%eax
  8005dc:	8d 50 01             	lea    0x1(%eax),%edx
  8005df:	8b 45 0c             	mov    0xc(%ebp),%eax
  8005e2:	89 50 04             	mov    %edx,0x4(%eax)
}
  8005e5:	90                   	nop
  8005e6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8005e9:	c9                   	leave  
  8005ea:	c3                   	ret    

008005eb <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  8005eb:	55                   	push   %ebp
  8005ec:	89 e5                	mov    %esp,%ebp
  8005ee:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8005f4:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8005fb:	00 00 00 
	b.cnt = 0;
  8005fe:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800605:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800608:	ff 75 0c             	pushl  0xc(%ebp)
  80060b:	ff 75 08             	pushl  0x8(%ebp)
  80060e:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800614:	50                   	push   %eax
  800615:	68 7a 05 80 00       	push   $0x80057a
  80061a:	e8 5a 02 00 00       	call   800879 <vprintfmt>
  80061f:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName, curTextClr);
  800622:	8b 15 1c b1 81 00    	mov    0x81b11c,%edx
  800628:	a0 44 30 80 00       	mov    0x803044,%al
  80062d:	0f b6 c0             	movzbl %al,%eax
  800630:	8b 8d f0 fe ff ff    	mov    -0x110(%ebp),%ecx
  800636:	52                   	push   %edx
  800637:	50                   	push   %eax
  800638:	51                   	push   %ecx
  800639:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80063f:	83 c0 08             	add    $0x8,%eax
  800642:	50                   	push   %eax
  800643:	e8 22 0f 00 00       	call   80156a <sys_cputs>
  800648:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  80064b:	c6 05 44 30 80 00 00 	movb   $0x0,0x803044
	return b.cnt;
  800652:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800658:	c9                   	leave  
  800659:	c3                   	ret    

0080065a <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  80065a:	55                   	push   %ebp
  80065b:	89 e5                	mov    %esp,%ebp
  80065d:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800660:	c6 05 44 30 80 00 01 	movb   $0x1,0x803044
	va_start(ap, fmt);
  800667:	8d 45 0c             	lea    0xc(%ebp),%eax
  80066a:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  80066d:	8b 45 08             	mov    0x8(%ebp),%eax
  800670:	83 ec 08             	sub    $0x8,%esp
  800673:	ff 75 f4             	pushl  -0xc(%ebp)
  800676:	50                   	push   %eax
  800677:	e8 6f ff ff ff       	call   8005eb <vcprintf>
  80067c:	83 c4 10             	add    $0x10,%esp
  80067f:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800682:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800685:	c9                   	leave  
  800686:	c3                   	ret    

00800687 <cprintf_colored>:

// *************** This text coloring feature is implemented by *************
// ********** Abd-Alrahman Zedan From Team Frozen-Bytes - FCIS'24-25 ********
int cprintf_colored(int textClr, const char *fmt, ...) {
  800687:	55                   	push   %ebp
  800688:	89 e5                	mov    %esp,%ebp
  80068a:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  80068d:	c6 05 44 30 80 00 01 	movb   $0x1,0x803044
	curTextClr = (textClr << 8) ; //set text color by the given value
  800694:	8b 45 08             	mov    0x8(%ebp),%eax
  800697:	c1 e0 08             	shl    $0x8,%eax
  80069a:	a3 1c b1 81 00       	mov    %eax,0x81b11c
	va_start(ap, fmt);
  80069f:	8d 45 0c             	lea    0xc(%ebp),%eax
  8006a2:	83 c0 04             	add    $0x4,%eax
  8006a5:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8006a8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006ab:	83 ec 08             	sub    $0x8,%esp
  8006ae:	ff 75 f4             	pushl  -0xc(%ebp)
  8006b1:	50                   	push   %eax
  8006b2:	e8 34 ff ff ff       	call   8005eb <vcprintf>
  8006b7:	83 c4 10             	add    $0x10,%esp
  8006ba:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);
	curTextClr = TEXT_DEFAULT_CLR; //restore default color
  8006bd:	c7 05 1c b1 81 00 00 	movl   $0x700,0x81b11c
  8006c4:	07 00 00 

	return cnt;
  8006c7:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8006ca:	c9                   	leave  
  8006cb:	c3                   	ret    

008006cc <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  8006cc:	55                   	push   %ebp
  8006cd:	89 e5                	mov    %esp,%ebp
  8006cf:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  8006d2:	e8 d7 0e 00 00       	call   8015ae <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  8006d7:	8d 45 0c             	lea    0xc(%ebp),%eax
  8006da:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  8006dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8006e0:	83 ec 08             	sub    $0x8,%esp
  8006e3:	ff 75 f4             	pushl  -0xc(%ebp)
  8006e6:	50                   	push   %eax
  8006e7:	e8 ff fe ff ff       	call   8005eb <vcprintf>
  8006ec:	83 c4 10             	add    $0x10,%esp
  8006ef:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  8006f2:	e8 d1 0e 00 00       	call   8015c8 <sys_unlock_cons>
	return cnt;
  8006f7:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8006fa:	c9                   	leave  
  8006fb:	c3                   	ret    

008006fc <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8006fc:	55                   	push   %ebp
  8006fd:	89 e5                	mov    %esp,%ebp
  8006ff:	53                   	push   %ebx
  800700:	83 ec 14             	sub    $0x14,%esp
  800703:	8b 45 10             	mov    0x10(%ebp),%eax
  800706:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800709:	8b 45 14             	mov    0x14(%ebp),%eax
  80070c:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  80070f:	8b 45 18             	mov    0x18(%ebp),%eax
  800712:	ba 00 00 00 00       	mov    $0x0,%edx
  800717:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  80071a:	77 55                	ja     800771 <printnum+0x75>
  80071c:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  80071f:	72 05                	jb     800726 <printnum+0x2a>
  800721:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800724:	77 4b                	ja     800771 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800726:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800729:	8d 58 ff             	lea    -0x1(%eax),%ebx
  80072c:	8b 45 18             	mov    0x18(%ebp),%eax
  80072f:	ba 00 00 00 00       	mov    $0x0,%edx
  800734:	52                   	push   %edx
  800735:	50                   	push   %eax
  800736:	ff 75 f4             	pushl  -0xc(%ebp)
  800739:	ff 75 f0             	pushl  -0x10(%ebp)
  80073c:	e8 67 14 00 00       	call   801ba8 <__udivdi3>
  800741:	83 c4 10             	add    $0x10,%esp
  800744:	83 ec 04             	sub    $0x4,%esp
  800747:	ff 75 20             	pushl  0x20(%ebp)
  80074a:	53                   	push   %ebx
  80074b:	ff 75 18             	pushl  0x18(%ebp)
  80074e:	52                   	push   %edx
  80074f:	50                   	push   %eax
  800750:	ff 75 0c             	pushl  0xc(%ebp)
  800753:	ff 75 08             	pushl  0x8(%ebp)
  800756:	e8 a1 ff ff ff       	call   8006fc <printnum>
  80075b:	83 c4 20             	add    $0x20,%esp
  80075e:	eb 1a                	jmp    80077a <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800760:	83 ec 08             	sub    $0x8,%esp
  800763:	ff 75 0c             	pushl  0xc(%ebp)
  800766:	ff 75 20             	pushl  0x20(%ebp)
  800769:	8b 45 08             	mov    0x8(%ebp),%eax
  80076c:	ff d0                	call   *%eax
  80076e:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800771:	ff 4d 1c             	decl   0x1c(%ebp)
  800774:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800778:	7f e6                	jg     800760 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80077a:	8b 4d 18             	mov    0x18(%ebp),%ecx
  80077d:	bb 00 00 00 00       	mov    $0x0,%ebx
  800782:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800785:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800788:	53                   	push   %ebx
  800789:	51                   	push   %ecx
  80078a:	52                   	push   %edx
  80078b:	50                   	push   %eax
  80078c:	e8 27 15 00 00       	call   801cb8 <__umoddi3>
  800791:	83 c4 10             	add    $0x10,%esp
  800794:	05 54 24 80 00       	add    $0x802454,%eax
  800799:	8a 00                	mov    (%eax),%al
  80079b:	0f be c0             	movsbl %al,%eax
  80079e:	83 ec 08             	sub    $0x8,%esp
  8007a1:	ff 75 0c             	pushl  0xc(%ebp)
  8007a4:	50                   	push   %eax
  8007a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8007a8:	ff d0                	call   *%eax
  8007aa:	83 c4 10             	add    $0x10,%esp
}
  8007ad:	90                   	nop
  8007ae:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8007b1:	c9                   	leave  
  8007b2:	c3                   	ret    

008007b3 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8007b3:	55                   	push   %ebp
  8007b4:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8007b6:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8007ba:	7e 1c                	jle    8007d8 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  8007bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8007bf:	8b 00                	mov    (%eax),%eax
  8007c1:	8d 50 08             	lea    0x8(%eax),%edx
  8007c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8007c7:	89 10                	mov    %edx,(%eax)
  8007c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8007cc:	8b 00                	mov    (%eax),%eax
  8007ce:	83 e8 08             	sub    $0x8,%eax
  8007d1:	8b 50 04             	mov    0x4(%eax),%edx
  8007d4:	8b 00                	mov    (%eax),%eax
  8007d6:	eb 40                	jmp    800818 <getuint+0x65>
	else if (lflag)
  8007d8:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8007dc:	74 1e                	je     8007fc <getuint+0x49>
		return va_arg(*ap, unsigned long);
  8007de:	8b 45 08             	mov    0x8(%ebp),%eax
  8007e1:	8b 00                	mov    (%eax),%eax
  8007e3:	8d 50 04             	lea    0x4(%eax),%edx
  8007e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8007e9:	89 10                	mov    %edx,(%eax)
  8007eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8007ee:	8b 00                	mov    (%eax),%eax
  8007f0:	83 e8 04             	sub    $0x4,%eax
  8007f3:	8b 00                	mov    (%eax),%eax
  8007f5:	ba 00 00 00 00       	mov    $0x0,%edx
  8007fa:	eb 1c                	jmp    800818 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  8007fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8007ff:	8b 00                	mov    (%eax),%eax
  800801:	8d 50 04             	lea    0x4(%eax),%edx
  800804:	8b 45 08             	mov    0x8(%ebp),%eax
  800807:	89 10                	mov    %edx,(%eax)
  800809:	8b 45 08             	mov    0x8(%ebp),%eax
  80080c:	8b 00                	mov    (%eax),%eax
  80080e:	83 e8 04             	sub    $0x4,%eax
  800811:	8b 00                	mov    (%eax),%eax
  800813:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800818:	5d                   	pop    %ebp
  800819:	c3                   	ret    

0080081a <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  80081a:	55                   	push   %ebp
  80081b:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  80081d:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800821:	7e 1c                	jle    80083f <getint+0x25>
		return va_arg(*ap, long long);
  800823:	8b 45 08             	mov    0x8(%ebp),%eax
  800826:	8b 00                	mov    (%eax),%eax
  800828:	8d 50 08             	lea    0x8(%eax),%edx
  80082b:	8b 45 08             	mov    0x8(%ebp),%eax
  80082e:	89 10                	mov    %edx,(%eax)
  800830:	8b 45 08             	mov    0x8(%ebp),%eax
  800833:	8b 00                	mov    (%eax),%eax
  800835:	83 e8 08             	sub    $0x8,%eax
  800838:	8b 50 04             	mov    0x4(%eax),%edx
  80083b:	8b 00                	mov    (%eax),%eax
  80083d:	eb 38                	jmp    800877 <getint+0x5d>
	else if (lflag)
  80083f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800843:	74 1a                	je     80085f <getint+0x45>
		return va_arg(*ap, long);
  800845:	8b 45 08             	mov    0x8(%ebp),%eax
  800848:	8b 00                	mov    (%eax),%eax
  80084a:	8d 50 04             	lea    0x4(%eax),%edx
  80084d:	8b 45 08             	mov    0x8(%ebp),%eax
  800850:	89 10                	mov    %edx,(%eax)
  800852:	8b 45 08             	mov    0x8(%ebp),%eax
  800855:	8b 00                	mov    (%eax),%eax
  800857:	83 e8 04             	sub    $0x4,%eax
  80085a:	8b 00                	mov    (%eax),%eax
  80085c:	99                   	cltd   
  80085d:	eb 18                	jmp    800877 <getint+0x5d>
	else
		return va_arg(*ap, int);
  80085f:	8b 45 08             	mov    0x8(%ebp),%eax
  800862:	8b 00                	mov    (%eax),%eax
  800864:	8d 50 04             	lea    0x4(%eax),%edx
  800867:	8b 45 08             	mov    0x8(%ebp),%eax
  80086a:	89 10                	mov    %edx,(%eax)
  80086c:	8b 45 08             	mov    0x8(%ebp),%eax
  80086f:	8b 00                	mov    (%eax),%eax
  800871:	83 e8 04             	sub    $0x4,%eax
  800874:	8b 00                	mov    (%eax),%eax
  800876:	99                   	cltd   
}
  800877:	5d                   	pop    %ebp
  800878:	c3                   	ret    

00800879 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800879:	55                   	push   %ebp
  80087a:	89 e5                	mov    %esp,%ebp
  80087c:	56                   	push   %esi
  80087d:	53                   	push   %ebx
  80087e:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800881:	eb 17                	jmp    80089a <vprintfmt+0x21>
			if (ch == '\0')
  800883:	85 db                	test   %ebx,%ebx
  800885:	0f 84 c1 03 00 00    	je     800c4c <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  80088b:	83 ec 08             	sub    $0x8,%esp
  80088e:	ff 75 0c             	pushl  0xc(%ebp)
  800891:	53                   	push   %ebx
  800892:	8b 45 08             	mov    0x8(%ebp),%eax
  800895:	ff d0                	call   *%eax
  800897:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80089a:	8b 45 10             	mov    0x10(%ebp),%eax
  80089d:	8d 50 01             	lea    0x1(%eax),%edx
  8008a0:	89 55 10             	mov    %edx,0x10(%ebp)
  8008a3:	8a 00                	mov    (%eax),%al
  8008a5:	0f b6 d8             	movzbl %al,%ebx
  8008a8:	83 fb 25             	cmp    $0x25,%ebx
  8008ab:	75 d6                	jne    800883 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  8008ad:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  8008b1:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  8008b8:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8008bf:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  8008c6:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8008cd:	8b 45 10             	mov    0x10(%ebp),%eax
  8008d0:	8d 50 01             	lea    0x1(%eax),%edx
  8008d3:	89 55 10             	mov    %edx,0x10(%ebp)
  8008d6:	8a 00                	mov    (%eax),%al
  8008d8:	0f b6 d8             	movzbl %al,%ebx
  8008db:	8d 43 dd             	lea    -0x23(%ebx),%eax
  8008de:	83 f8 5b             	cmp    $0x5b,%eax
  8008e1:	0f 87 3d 03 00 00    	ja     800c24 <vprintfmt+0x3ab>
  8008e7:	8b 04 85 78 24 80 00 	mov    0x802478(,%eax,4),%eax
  8008ee:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  8008f0:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  8008f4:	eb d7                	jmp    8008cd <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8008f6:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  8008fa:	eb d1                	jmp    8008cd <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8008fc:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800903:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800906:	89 d0                	mov    %edx,%eax
  800908:	c1 e0 02             	shl    $0x2,%eax
  80090b:	01 d0                	add    %edx,%eax
  80090d:	01 c0                	add    %eax,%eax
  80090f:	01 d8                	add    %ebx,%eax
  800911:	83 e8 30             	sub    $0x30,%eax
  800914:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800917:	8b 45 10             	mov    0x10(%ebp),%eax
  80091a:	8a 00                	mov    (%eax),%al
  80091c:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  80091f:	83 fb 2f             	cmp    $0x2f,%ebx
  800922:	7e 3e                	jle    800962 <vprintfmt+0xe9>
  800924:	83 fb 39             	cmp    $0x39,%ebx
  800927:	7f 39                	jg     800962 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800929:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  80092c:	eb d5                	jmp    800903 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  80092e:	8b 45 14             	mov    0x14(%ebp),%eax
  800931:	83 c0 04             	add    $0x4,%eax
  800934:	89 45 14             	mov    %eax,0x14(%ebp)
  800937:	8b 45 14             	mov    0x14(%ebp),%eax
  80093a:	83 e8 04             	sub    $0x4,%eax
  80093d:	8b 00                	mov    (%eax),%eax
  80093f:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800942:	eb 1f                	jmp    800963 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800944:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800948:	79 83                	jns    8008cd <vprintfmt+0x54>
				width = 0;
  80094a:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800951:	e9 77 ff ff ff       	jmp    8008cd <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800956:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  80095d:	e9 6b ff ff ff       	jmp    8008cd <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800962:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800963:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800967:	0f 89 60 ff ff ff    	jns    8008cd <vprintfmt+0x54>
				width = precision, precision = -1;
  80096d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800970:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800973:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  80097a:	e9 4e ff ff ff       	jmp    8008cd <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  80097f:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800982:	e9 46 ff ff ff       	jmp    8008cd <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800987:	8b 45 14             	mov    0x14(%ebp),%eax
  80098a:	83 c0 04             	add    $0x4,%eax
  80098d:	89 45 14             	mov    %eax,0x14(%ebp)
  800990:	8b 45 14             	mov    0x14(%ebp),%eax
  800993:	83 e8 04             	sub    $0x4,%eax
  800996:	8b 00                	mov    (%eax),%eax
  800998:	83 ec 08             	sub    $0x8,%esp
  80099b:	ff 75 0c             	pushl  0xc(%ebp)
  80099e:	50                   	push   %eax
  80099f:	8b 45 08             	mov    0x8(%ebp),%eax
  8009a2:	ff d0                	call   *%eax
  8009a4:	83 c4 10             	add    $0x10,%esp
			break;
  8009a7:	e9 9b 02 00 00       	jmp    800c47 <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  8009ac:	8b 45 14             	mov    0x14(%ebp),%eax
  8009af:	83 c0 04             	add    $0x4,%eax
  8009b2:	89 45 14             	mov    %eax,0x14(%ebp)
  8009b5:	8b 45 14             	mov    0x14(%ebp),%eax
  8009b8:	83 e8 04             	sub    $0x4,%eax
  8009bb:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  8009bd:	85 db                	test   %ebx,%ebx
  8009bf:	79 02                	jns    8009c3 <vprintfmt+0x14a>
				err = -err;
  8009c1:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  8009c3:	83 fb 64             	cmp    $0x64,%ebx
  8009c6:	7f 0b                	jg     8009d3 <vprintfmt+0x15a>
  8009c8:	8b 34 9d c0 22 80 00 	mov    0x8022c0(,%ebx,4),%esi
  8009cf:	85 f6                	test   %esi,%esi
  8009d1:	75 19                	jne    8009ec <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  8009d3:	53                   	push   %ebx
  8009d4:	68 65 24 80 00       	push   $0x802465
  8009d9:	ff 75 0c             	pushl  0xc(%ebp)
  8009dc:	ff 75 08             	pushl  0x8(%ebp)
  8009df:	e8 70 02 00 00       	call   800c54 <printfmt>
  8009e4:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  8009e7:	e9 5b 02 00 00       	jmp    800c47 <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  8009ec:	56                   	push   %esi
  8009ed:	68 6e 24 80 00       	push   $0x80246e
  8009f2:	ff 75 0c             	pushl  0xc(%ebp)
  8009f5:	ff 75 08             	pushl  0x8(%ebp)
  8009f8:	e8 57 02 00 00       	call   800c54 <printfmt>
  8009fd:	83 c4 10             	add    $0x10,%esp
			break;
  800a00:	e9 42 02 00 00       	jmp    800c47 <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800a05:	8b 45 14             	mov    0x14(%ebp),%eax
  800a08:	83 c0 04             	add    $0x4,%eax
  800a0b:	89 45 14             	mov    %eax,0x14(%ebp)
  800a0e:	8b 45 14             	mov    0x14(%ebp),%eax
  800a11:	83 e8 04             	sub    $0x4,%eax
  800a14:	8b 30                	mov    (%eax),%esi
  800a16:	85 f6                	test   %esi,%esi
  800a18:	75 05                	jne    800a1f <vprintfmt+0x1a6>
				p = "(null)";
  800a1a:	be 71 24 80 00       	mov    $0x802471,%esi
			if (width > 0 && padc != '-')
  800a1f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a23:	7e 6d                	jle    800a92 <vprintfmt+0x219>
  800a25:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800a29:	74 67                	je     800a92 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800a2b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800a2e:	83 ec 08             	sub    $0x8,%esp
  800a31:	50                   	push   %eax
  800a32:	56                   	push   %esi
  800a33:	e8 1e 03 00 00       	call   800d56 <strnlen>
  800a38:	83 c4 10             	add    $0x10,%esp
  800a3b:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800a3e:	eb 16                	jmp    800a56 <vprintfmt+0x1dd>
					putch(padc, putdat);
  800a40:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800a44:	83 ec 08             	sub    $0x8,%esp
  800a47:	ff 75 0c             	pushl  0xc(%ebp)
  800a4a:	50                   	push   %eax
  800a4b:	8b 45 08             	mov    0x8(%ebp),%eax
  800a4e:	ff d0                	call   *%eax
  800a50:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800a53:	ff 4d e4             	decl   -0x1c(%ebp)
  800a56:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a5a:	7f e4                	jg     800a40 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800a5c:	eb 34                	jmp    800a92 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800a5e:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800a62:	74 1c                	je     800a80 <vprintfmt+0x207>
  800a64:	83 fb 1f             	cmp    $0x1f,%ebx
  800a67:	7e 05                	jle    800a6e <vprintfmt+0x1f5>
  800a69:	83 fb 7e             	cmp    $0x7e,%ebx
  800a6c:	7e 12                	jle    800a80 <vprintfmt+0x207>
					putch('?', putdat);
  800a6e:	83 ec 08             	sub    $0x8,%esp
  800a71:	ff 75 0c             	pushl  0xc(%ebp)
  800a74:	6a 3f                	push   $0x3f
  800a76:	8b 45 08             	mov    0x8(%ebp),%eax
  800a79:	ff d0                	call   *%eax
  800a7b:	83 c4 10             	add    $0x10,%esp
  800a7e:	eb 0f                	jmp    800a8f <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800a80:	83 ec 08             	sub    $0x8,%esp
  800a83:	ff 75 0c             	pushl  0xc(%ebp)
  800a86:	53                   	push   %ebx
  800a87:	8b 45 08             	mov    0x8(%ebp),%eax
  800a8a:	ff d0                	call   *%eax
  800a8c:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800a8f:	ff 4d e4             	decl   -0x1c(%ebp)
  800a92:	89 f0                	mov    %esi,%eax
  800a94:	8d 70 01             	lea    0x1(%eax),%esi
  800a97:	8a 00                	mov    (%eax),%al
  800a99:	0f be d8             	movsbl %al,%ebx
  800a9c:	85 db                	test   %ebx,%ebx
  800a9e:	74 24                	je     800ac4 <vprintfmt+0x24b>
  800aa0:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800aa4:	78 b8                	js     800a5e <vprintfmt+0x1e5>
  800aa6:	ff 4d e0             	decl   -0x20(%ebp)
  800aa9:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800aad:	79 af                	jns    800a5e <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800aaf:	eb 13                	jmp    800ac4 <vprintfmt+0x24b>
				putch(' ', putdat);
  800ab1:	83 ec 08             	sub    $0x8,%esp
  800ab4:	ff 75 0c             	pushl  0xc(%ebp)
  800ab7:	6a 20                	push   $0x20
  800ab9:	8b 45 08             	mov    0x8(%ebp),%eax
  800abc:	ff d0                	call   *%eax
  800abe:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800ac1:	ff 4d e4             	decl   -0x1c(%ebp)
  800ac4:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800ac8:	7f e7                	jg     800ab1 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800aca:	e9 78 01 00 00       	jmp    800c47 <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800acf:	83 ec 08             	sub    $0x8,%esp
  800ad2:	ff 75 e8             	pushl  -0x18(%ebp)
  800ad5:	8d 45 14             	lea    0x14(%ebp),%eax
  800ad8:	50                   	push   %eax
  800ad9:	e8 3c fd ff ff       	call   80081a <getint>
  800ade:	83 c4 10             	add    $0x10,%esp
  800ae1:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800ae4:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800ae7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800aea:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800aed:	85 d2                	test   %edx,%edx
  800aef:	79 23                	jns    800b14 <vprintfmt+0x29b>
				putch('-', putdat);
  800af1:	83 ec 08             	sub    $0x8,%esp
  800af4:	ff 75 0c             	pushl  0xc(%ebp)
  800af7:	6a 2d                	push   $0x2d
  800af9:	8b 45 08             	mov    0x8(%ebp),%eax
  800afc:	ff d0                	call   *%eax
  800afe:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800b01:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800b04:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800b07:	f7 d8                	neg    %eax
  800b09:	83 d2 00             	adc    $0x0,%edx
  800b0c:	f7 da                	neg    %edx
  800b0e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b11:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800b14:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800b1b:	e9 bc 00 00 00       	jmp    800bdc <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800b20:	83 ec 08             	sub    $0x8,%esp
  800b23:	ff 75 e8             	pushl  -0x18(%ebp)
  800b26:	8d 45 14             	lea    0x14(%ebp),%eax
  800b29:	50                   	push   %eax
  800b2a:	e8 84 fc ff ff       	call   8007b3 <getuint>
  800b2f:	83 c4 10             	add    $0x10,%esp
  800b32:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b35:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800b38:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800b3f:	e9 98 00 00 00       	jmp    800bdc <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800b44:	83 ec 08             	sub    $0x8,%esp
  800b47:	ff 75 0c             	pushl  0xc(%ebp)
  800b4a:	6a 58                	push   $0x58
  800b4c:	8b 45 08             	mov    0x8(%ebp),%eax
  800b4f:	ff d0                	call   *%eax
  800b51:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800b54:	83 ec 08             	sub    $0x8,%esp
  800b57:	ff 75 0c             	pushl  0xc(%ebp)
  800b5a:	6a 58                	push   $0x58
  800b5c:	8b 45 08             	mov    0x8(%ebp),%eax
  800b5f:	ff d0                	call   *%eax
  800b61:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800b64:	83 ec 08             	sub    $0x8,%esp
  800b67:	ff 75 0c             	pushl  0xc(%ebp)
  800b6a:	6a 58                	push   $0x58
  800b6c:	8b 45 08             	mov    0x8(%ebp),%eax
  800b6f:	ff d0                	call   *%eax
  800b71:	83 c4 10             	add    $0x10,%esp
			break;
  800b74:	e9 ce 00 00 00       	jmp    800c47 <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  800b79:	83 ec 08             	sub    $0x8,%esp
  800b7c:	ff 75 0c             	pushl  0xc(%ebp)
  800b7f:	6a 30                	push   $0x30
  800b81:	8b 45 08             	mov    0x8(%ebp),%eax
  800b84:	ff d0                	call   *%eax
  800b86:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800b89:	83 ec 08             	sub    $0x8,%esp
  800b8c:	ff 75 0c             	pushl  0xc(%ebp)
  800b8f:	6a 78                	push   $0x78
  800b91:	8b 45 08             	mov    0x8(%ebp),%eax
  800b94:	ff d0                	call   *%eax
  800b96:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800b99:	8b 45 14             	mov    0x14(%ebp),%eax
  800b9c:	83 c0 04             	add    $0x4,%eax
  800b9f:	89 45 14             	mov    %eax,0x14(%ebp)
  800ba2:	8b 45 14             	mov    0x14(%ebp),%eax
  800ba5:	83 e8 04             	sub    $0x4,%eax
  800ba8:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800baa:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800bad:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800bb4:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800bbb:	eb 1f                	jmp    800bdc <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800bbd:	83 ec 08             	sub    $0x8,%esp
  800bc0:	ff 75 e8             	pushl  -0x18(%ebp)
  800bc3:	8d 45 14             	lea    0x14(%ebp),%eax
  800bc6:	50                   	push   %eax
  800bc7:	e8 e7 fb ff ff       	call   8007b3 <getuint>
  800bcc:	83 c4 10             	add    $0x10,%esp
  800bcf:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800bd2:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800bd5:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800bdc:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800be0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800be3:	83 ec 04             	sub    $0x4,%esp
  800be6:	52                   	push   %edx
  800be7:	ff 75 e4             	pushl  -0x1c(%ebp)
  800bea:	50                   	push   %eax
  800beb:	ff 75 f4             	pushl  -0xc(%ebp)
  800bee:	ff 75 f0             	pushl  -0x10(%ebp)
  800bf1:	ff 75 0c             	pushl  0xc(%ebp)
  800bf4:	ff 75 08             	pushl  0x8(%ebp)
  800bf7:	e8 00 fb ff ff       	call   8006fc <printnum>
  800bfc:	83 c4 20             	add    $0x20,%esp
			break;
  800bff:	eb 46                	jmp    800c47 <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800c01:	83 ec 08             	sub    $0x8,%esp
  800c04:	ff 75 0c             	pushl  0xc(%ebp)
  800c07:	53                   	push   %ebx
  800c08:	8b 45 08             	mov    0x8(%ebp),%eax
  800c0b:	ff d0                	call   *%eax
  800c0d:	83 c4 10             	add    $0x10,%esp
			break;
  800c10:	eb 35                	jmp    800c47 <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  800c12:	c6 05 44 30 80 00 00 	movb   $0x0,0x803044
			break;
  800c19:	eb 2c                	jmp    800c47 <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  800c1b:	c6 05 44 30 80 00 01 	movb   $0x1,0x803044
			break;
  800c22:	eb 23                	jmp    800c47 <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800c24:	83 ec 08             	sub    $0x8,%esp
  800c27:	ff 75 0c             	pushl  0xc(%ebp)
  800c2a:	6a 25                	push   $0x25
  800c2c:	8b 45 08             	mov    0x8(%ebp),%eax
  800c2f:	ff d0                	call   *%eax
  800c31:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800c34:	ff 4d 10             	decl   0x10(%ebp)
  800c37:	eb 03                	jmp    800c3c <vprintfmt+0x3c3>
  800c39:	ff 4d 10             	decl   0x10(%ebp)
  800c3c:	8b 45 10             	mov    0x10(%ebp),%eax
  800c3f:	48                   	dec    %eax
  800c40:	8a 00                	mov    (%eax),%al
  800c42:	3c 25                	cmp    $0x25,%al
  800c44:	75 f3                	jne    800c39 <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  800c46:	90                   	nop
		}
	}
  800c47:	e9 35 fc ff ff       	jmp    800881 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800c4c:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800c4d:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800c50:	5b                   	pop    %ebx
  800c51:	5e                   	pop    %esi
  800c52:	5d                   	pop    %ebp
  800c53:	c3                   	ret    

00800c54 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800c54:	55                   	push   %ebp
  800c55:	89 e5                	mov    %esp,%ebp
  800c57:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800c5a:	8d 45 10             	lea    0x10(%ebp),%eax
  800c5d:	83 c0 04             	add    $0x4,%eax
  800c60:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800c63:	8b 45 10             	mov    0x10(%ebp),%eax
  800c66:	ff 75 f4             	pushl  -0xc(%ebp)
  800c69:	50                   	push   %eax
  800c6a:	ff 75 0c             	pushl  0xc(%ebp)
  800c6d:	ff 75 08             	pushl  0x8(%ebp)
  800c70:	e8 04 fc ff ff       	call   800879 <vprintfmt>
  800c75:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800c78:	90                   	nop
  800c79:	c9                   	leave  
  800c7a:	c3                   	ret    

00800c7b <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800c7b:	55                   	push   %ebp
  800c7c:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800c7e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c81:	8b 40 08             	mov    0x8(%eax),%eax
  800c84:	8d 50 01             	lea    0x1(%eax),%edx
  800c87:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c8a:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800c8d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c90:	8b 10                	mov    (%eax),%edx
  800c92:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c95:	8b 40 04             	mov    0x4(%eax),%eax
  800c98:	39 c2                	cmp    %eax,%edx
  800c9a:	73 12                	jae    800cae <sprintputch+0x33>
		*b->buf++ = ch;
  800c9c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c9f:	8b 00                	mov    (%eax),%eax
  800ca1:	8d 48 01             	lea    0x1(%eax),%ecx
  800ca4:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ca7:	89 0a                	mov    %ecx,(%edx)
  800ca9:	8b 55 08             	mov    0x8(%ebp),%edx
  800cac:	88 10                	mov    %dl,(%eax)
}
  800cae:	90                   	nop
  800caf:	5d                   	pop    %ebp
  800cb0:	c3                   	ret    

00800cb1 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800cb1:	55                   	push   %ebp
  800cb2:	89 e5                	mov    %esp,%ebp
  800cb4:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800cb7:	8b 45 08             	mov    0x8(%ebp),%eax
  800cba:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800cbd:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cc0:	8d 50 ff             	lea    -0x1(%eax),%edx
  800cc3:	8b 45 08             	mov    0x8(%ebp),%eax
  800cc6:	01 d0                	add    %edx,%eax
  800cc8:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800ccb:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800cd2:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800cd6:	74 06                	je     800cde <vsnprintf+0x2d>
  800cd8:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800cdc:	7f 07                	jg     800ce5 <vsnprintf+0x34>
		return -E_INVAL;
  800cde:	b8 03 00 00 00       	mov    $0x3,%eax
  800ce3:	eb 20                	jmp    800d05 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800ce5:	ff 75 14             	pushl  0x14(%ebp)
  800ce8:	ff 75 10             	pushl  0x10(%ebp)
  800ceb:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800cee:	50                   	push   %eax
  800cef:	68 7b 0c 80 00       	push   $0x800c7b
  800cf4:	e8 80 fb ff ff       	call   800879 <vprintfmt>
  800cf9:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800cfc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800cff:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800d02:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800d05:	c9                   	leave  
  800d06:	c3                   	ret    

00800d07 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800d07:	55                   	push   %ebp
  800d08:	89 e5                	mov    %esp,%ebp
  800d0a:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800d0d:	8d 45 10             	lea    0x10(%ebp),%eax
  800d10:	83 c0 04             	add    $0x4,%eax
  800d13:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800d16:	8b 45 10             	mov    0x10(%ebp),%eax
  800d19:	ff 75 f4             	pushl  -0xc(%ebp)
  800d1c:	50                   	push   %eax
  800d1d:	ff 75 0c             	pushl  0xc(%ebp)
  800d20:	ff 75 08             	pushl  0x8(%ebp)
  800d23:	e8 89 ff ff ff       	call   800cb1 <vsnprintf>
  800d28:	83 c4 10             	add    $0x10,%esp
  800d2b:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800d2e:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800d31:	c9                   	leave  
  800d32:	c3                   	ret    

00800d33 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800d33:	55                   	push   %ebp
  800d34:	89 e5                	mov    %esp,%ebp
  800d36:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800d39:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800d40:	eb 06                	jmp    800d48 <strlen+0x15>
		n++;
  800d42:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800d45:	ff 45 08             	incl   0x8(%ebp)
  800d48:	8b 45 08             	mov    0x8(%ebp),%eax
  800d4b:	8a 00                	mov    (%eax),%al
  800d4d:	84 c0                	test   %al,%al
  800d4f:	75 f1                	jne    800d42 <strlen+0xf>
		n++;
	return n;
  800d51:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800d54:	c9                   	leave  
  800d55:	c3                   	ret    

00800d56 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800d56:	55                   	push   %ebp
  800d57:	89 e5                	mov    %esp,%ebp
  800d59:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800d5c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800d63:	eb 09                	jmp    800d6e <strnlen+0x18>
		n++;
  800d65:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800d68:	ff 45 08             	incl   0x8(%ebp)
  800d6b:	ff 4d 0c             	decl   0xc(%ebp)
  800d6e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800d72:	74 09                	je     800d7d <strnlen+0x27>
  800d74:	8b 45 08             	mov    0x8(%ebp),%eax
  800d77:	8a 00                	mov    (%eax),%al
  800d79:	84 c0                	test   %al,%al
  800d7b:	75 e8                	jne    800d65 <strnlen+0xf>
		n++;
	return n;
  800d7d:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800d80:	c9                   	leave  
  800d81:	c3                   	ret    

00800d82 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800d82:	55                   	push   %ebp
  800d83:	89 e5                	mov    %esp,%ebp
  800d85:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800d88:	8b 45 08             	mov    0x8(%ebp),%eax
  800d8b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800d8e:	90                   	nop
  800d8f:	8b 45 08             	mov    0x8(%ebp),%eax
  800d92:	8d 50 01             	lea    0x1(%eax),%edx
  800d95:	89 55 08             	mov    %edx,0x8(%ebp)
  800d98:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d9b:	8d 4a 01             	lea    0x1(%edx),%ecx
  800d9e:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800da1:	8a 12                	mov    (%edx),%dl
  800da3:	88 10                	mov    %dl,(%eax)
  800da5:	8a 00                	mov    (%eax),%al
  800da7:	84 c0                	test   %al,%al
  800da9:	75 e4                	jne    800d8f <strcpy+0xd>
		/* do nothing */;
	return ret;
  800dab:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800dae:	c9                   	leave  
  800daf:	c3                   	ret    

00800db0 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800db0:	55                   	push   %ebp
  800db1:	89 e5                	mov    %esp,%ebp
  800db3:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800db6:	8b 45 08             	mov    0x8(%ebp),%eax
  800db9:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800dbc:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800dc3:	eb 1f                	jmp    800de4 <strncpy+0x34>
		*dst++ = *src;
  800dc5:	8b 45 08             	mov    0x8(%ebp),%eax
  800dc8:	8d 50 01             	lea    0x1(%eax),%edx
  800dcb:	89 55 08             	mov    %edx,0x8(%ebp)
  800dce:	8b 55 0c             	mov    0xc(%ebp),%edx
  800dd1:	8a 12                	mov    (%edx),%dl
  800dd3:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800dd5:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dd8:	8a 00                	mov    (%eax),%al
  800dda:	84 c0                	test   %al,%al
  800ddc:	74 03                	je     800de1 <strncpy+0x31>
			src++;
  800dde:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800de1:	ff 45 fc             	incl   -0x4(%ebp)
  800de4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800de7:	3b 45 10             	cmp    0x10(%ebp),%eax
  800dea:	72 d9                	jb     800dc5 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800dec:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800def:	c9                   	leave  
  800df0:	c3                   	ret    

00800df1 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800df1:	55                   	push   %ebp
  800df2:	89 e5                	mov    %esp,%ebp
  800df4:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800df7:	8b 45 08             	mov    0x8(%ebp),%eax
  800dfa:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800dfd:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e01:	74 30                	je     800e33 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800e03:	eb 16                	jmp    800e1b <strlcpy+0x2a>
			*dst++ = *src++;
  800e05:	8b 45 08             	mov    0x8(%ebp),%eax
  800e08:	8d 50 01             	lea    0x1(%eax),%edx
  800e0b:	89 55 08             	mov    %edx,0x8(%ebp)
  800e0e:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e11:	8d 4a 01             	lea    0x1(%edx),%ecx
  800e14:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800e17:	8a 12                	mov    (%edx),%dl
  800e19:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800e1b:	ff 4d 10             	decl   0x10(%ebp)
  800e1e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e22:	74 09                	je     800e2d <strlcpy+0x3c>
  800e24:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e27:	8a 00                	mov    (%eax),%al
  800e29:	84 c0                	test   %al,%al
  800e2b:	75 d8                	jne    800e05 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800e2d:	8b 45 08             	mov    0x8(%ebp),%eax
  800e30:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800e33:	8b 55 08             	mov    0x8(%ebp),%edx
  800e36:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e39:	29 c2                	sub    %eax,%edx
  800e3b:	89 d0                	mov    %edx,%eax
}
  800e3d:	c9                   	leave  
  800e3e:	c3                   	ret    

00800e3f <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800e3f:	55                   	push   %ebp
  800e40:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800e42:	eb 06                	jmp    800e4a <strcmp+0xb>
		p++, q++;
  800e44:	ff 45 08             	incl   0x8(%ebp)
  800e47:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800e4a:	8b 45 08             	mov    0x8(%ebp),%eax
  800e4d:	8a 00                	mov    (%eax),%al
  800e4f:	84 c0                	test   %al,%al
  800e51:	74 0e                	je     800e61 <strcmp+0x22>
  800e53:	8b 45 08             	mov    0x8(%ebp),%eax
  800e56:	8a 10                	mov    (%eax),%dl
  800e58:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e5b:	8a 00                	mov    (%eax),%al
  800e5d:	38 c2                	cmp    %al,%dl
  800e5f:	74 e3                	je     800e44 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800e61:	8b 45 08             	mov    0x8(%ebp),%eax
  800e64:	8a 00                	mov    (%eax),%al
  800e66:	0f b6 d0             	movzbl %al,%edx
  800e69:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e6c:	8a 00                	mov    (%eax),%al
  800e6e:	0f b6 c0             	movzbl %al,%eax
  800e71:	29 c2                	sub    %eax,%edx
  800e73:	89 d0                	mov    %edx,%eax
}
  800e75:	5d                   	pop    %ebp
  800e76:	c3                   	ret    

00800e77 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800e77:	55                   	push   %ebp
  800e78:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800e7a:	eb 09                	jmp    800e85 <strncmp+0xe>
		n--, p++, q++;
  800e7c:	ff 4d 10             	decl   0x10(%ebp)
  800e7f:	ff 45 08             	incl   0x8(%ebp)
  800e82:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800e85:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e89:	74 17                	je     800ea2 <strncmp+0x2b>
  800e8b:	8b 45 08             	mov    0x8(%ebp),%eax
  800e8e:	8a 00                	mov    (%eax),%al
  800e90:	84 c0                	test   %al,%al
  800e92:	74 0e                	je     800ea2 <strncmp+0x2b>
  800e94:	8b 45 08             	mov    0x8(%ebp),%eax
  800e97:	8a 10                	mov    (%eax),%dl
  800e99:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e9c:	8a 00                	mov    (%eax),%al
  800e9e:	38 c2                	cmp    %al,%dl
  800ea0:	74 da                	je     800e7c <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800ea2:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ea6:	75 07                	jne    800eaf <strncmp+0x38>
		return 0;
  800ea8:	b8 00 00 00 00       	mov    $0x0,%eax
  800ead:	eb 14                	jmp    800ec3 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800eaf:	8b 45 08             	mov    0x8(%ebp),%eax
  800eb2:	8a 00                	mov    (%eax),%al
  800eb4:	0f b6 d0             	movzbl %al,%edx
  800eb7:	8b 45 0c             	mov    0xc(%ebp),%eax
  800eba:	8a 00                	mov    (%eax),%al
  800ebc:	0f b6 c0             	movzbl %al,%eax
  800ebf:	29 c2                	sub    %eax,%edx
  800ec1:	89 d0                	mov    %edx,%eax
}
  800ec3:	5d                   	pop    %ebp
  800ec4:	c3                   	ret    

00800ec5 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800ec5:	55                   	push   %ebp
  800ec6:	89 e5                	mov    %esp,%ebp
  800ec8:	83 ec 04             	sub    $0x4,%esp
  800ecb:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ece:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800ed1:	eb 12                	jmp    800ee5 <strchr+0x20>
		if (*s == c)
  800ed3:	8b 45 08             	mov    0x8(%ebp),%eax
  800ed6:	8a 00                	mov    (%eax),%al
  800ed8:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800edb:	75 05                	jne    800ee2 <strchr+0x1d>
			return (char *) s;
  800edd:	8b 45 08             	mov    0x8(%ebp),%eax
  800ee0:	eb 11                	jmp    800ef3 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800ee2:	ff 45 08             	incl   0x8(%ebp)
  800ee5:	8b 45 08             	mov    0x8(%ebp),%eax
  800ee8:	8a 00                	mov    (%eax),%al
  800eea:	84 c0                	test   %al,%al
  800eec:	75 e5                	jne    800ed3 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800eee:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800ef3:	c9                   	leave  
  800ef4:	c3                   	ret    

00800ef5 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800ef5:	55                   	push   %ebp
  800ef6:	89 e5                	mov    %esp,%ebp
  800ef8:	83 ec 04             	sub    $0x4,%esp
  800efb:	8b 45 0c             	mov    0xc(%ebp),%eax
  800efe:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800f01:	eb 0d                	jmp    800f10 <strfind+0x1b>
		if (*s == c)
  800f03:	8b 45 08             	mov    0x8(%ebp),%eax
  800f06:	8a 00                	mov    (%eax),%al
  800f08:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800f0b:	74 0e                	je     800f1b <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800f0d:	ff 45 08             	incl   0x8(%ebp)
  800f10:	8b 45 08             	mov    0x8(%ebp),%eax
  800f13:	8a 00                	mov    (%eax),%al
  800f15:	84 c0                	test   %al,%al
  800f17:	75 ea                	jne    800f03 <strfind+0xe>
  800f19:	eb 01                	jmp    800f1c <strfind+0x27>
		if (*s == c)
			break;
  800f1b:	90                   	nop
	return (char *) s;
  800f1c:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f1f:	c9                   	leave  
  800f20:	c3                   	ret    

00800f21 <memset>:

// *************** The faster implementation of memset & memcpy is implemented by *************
// ****************** Team80 (Yahia Khaled, Malek Ahmed et al) - FCIS'24-25 *******************
void *
memset(void *v, int c, uint32 n)
{
  800f21:	55                   	push   %ebp
  800f22:	89 e5                	mov    %esp,%ebp
  800f24:	83 ec 10             	sub    $0x10,%esp
//	m = n;
//	while (--m >= 0)
//		*p++ = c;

	/*Faster Implementation*/
	uint64* p64 = (uint64*)v;
  800f27:	8b 45 08             	mov    0x8(%ebp),%eax
  800f2a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if(n >= 8){
  800f2d:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800f31:	76 63                	jbe    800f96 <memset+0x75>
		uint64 data_block = c;
  800f33:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f36:	99                   	cltd   
  800f37:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800f3a:	89 55 f4             	mov    %edx,-0xc(%ebp)
		data_block |= data_block << 8;
  800f3d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800f40:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800f43:	0f a4 c2 08          	shld   $0x8,%eax,%edx
  800f47:	c1 e0 08             	shl    $0x8,%eax
  800f4a:	09 45 f0             	or     %eax,-0x10(%ebp)
  800f4d:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 16;
  800f50:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800f53:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800f56:	0f a4 c2 10          	shld   $0x10,%eax,%edx
  800f5a:	c1 e0 10             	shl    $0x10,%eax
  800f5d:	09 45 f0             	or     %eax,-0x10(%ebp)
  800f60:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 32;
  800f63:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800f66:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800f69:	89 c2                	mov    %eax,%edx
  800f6b:	b8 00 00 00 00       	mov    $0x0,%eax
  800f70:	09 45 f0             	or     %eax,-0x10(%ebp)
  800f73:	09 55 f4             	or     %edx,-0xc(%ebp)

		while(n >= 8)
  800f76:	eb 18                	jmp    800f90 <memset+0x6f>
			*p64++ = data_block, n -= 8;
  800f78:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  800f7b:	8d 41 08             	lea    0x8(%ecx),%eax
  800f7e:	89 45 fc             	mov    %eax,-0x4(%ebp)
  800f81:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800f84:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800f87:	89 01                	mov    %eax,(%ecx)
  800f89:	89 51 04             	mov    %edx,0x4(%ecx)
  800f8c:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
		uint64 data_block = c;
		data_block |= data_block << 8;
		data_block |= data_block << 16;
		data_block |= data_block << 32;

		while(n >= 8)
  800f90:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800f94:	77 e2                	ja     800f78 <memset+0x57>
			*p64++ = data_block, n -= 8;
	}

	if(n){
  800f96:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f9a:	74 23                	je     800fbf <memset+0x9e>
		uint8* p8 = (uint8*)p64;
  800f9c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f9f:	89 45 f8             	mov    %eax,-0x8(%ebp)
		while (n-- > 0)
  800fa2:	eb 0e                	jmp    800fb2 <memset+0x91>
			*p8++ = (uint8)c;
  800fa4:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800fa7:	8d 50 01             	lea    0x1(%eax),%edx
  800faa:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800fad:	8b 55 0c             	mov    0xc(%ebp),%edx
  800fb0:	88 10                	mov    %dl,(%eax)
			*p64++ = data_block, n -= 8;
	}

	if(n){
		uint8* p8 = (uint8*)p64;
		while (n-- > 0)
  800fb2:	8b 45 10             	mov    0x10(%ebp),%eax
  800fb5:	8d 50 ff             	lea    -0x1(%eax),%edx
  800fb8:	89 55 10             	mov    %edx,0x10(%ebp)
  800fbb:	85 c0                	test   %eax,%eax
  800fbd:	75 e5                	jne    800fa4 <memset+0x83>
			*p8++ = (uint8)c;
	}

	return v;
  800fbf:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800fc2:	c9                   	leave  
  800fc3:	c3                   	ret    

00800fc4 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800fc4:	55                   	push   %ebp
  800fc5:	89 e5                	mov    %esp,%ebp
  800fc7:	83 ec 10             	sub    $0x10,%esp
	//	s = src;
	//	d = dst;
	//	while (n-- > 0)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
  800fca:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fcd:	89 45 fc             	mov    %eax,-0x4(%ebp)
	uint64* d64 = (uint64*)dst;
  800fd0:	8b 45 08             	mov    0x8(%ebp),%eax
  800fd3:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if(n >= 8){
  800fd6:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800fda:	76 24                	jbe    801000 <memcpy+0x3c>
		while(n >= 8){
  800fdc:	eb 1c                	jmp    800ffa <memcpy+0x36>
			*d64 = *s64;
  800fde:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800fe1:	8b 50 04             	mov    0x4(%eax),%edx
  800fe4:	8b 00                	mov    (%eax),%eax
  800fe6:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  800fe9:	89 01                	mov    %eax,(%ecx)
  800feb:	89 51 04             	mov    %edx,0x4(%ecx)
			n -= 8;
  800fee:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
			++s64;
  800ff2:	83 45 fc 08          	addl   $0x8,-0x4(%ebp)
			++d64;
  800ff6:	83 45 f8 08          	addl   $0x8,-0x8(%ebp)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
	uint64* d64 = (uint64*)dst;
	if(n >= 8){
		while(n >= 8){
  800ffa:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800ffe:	77 de                	ja     800fde <memcpy+0x1a>
			++s64;
			++d64;
		}
	}

	if(n){
  801000:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801004:	74 31                	je     801037 <memcpy+0x73>
		uint8* s8 = (uint8*)s64;
  801006:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801009:	89 45 f4             	mov    %eax,-0xc(%ebp)
		uint8* d8 = (uint8*)d64;
  80100c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80100f:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (n-- > 0)
  801012:	eb 16                	jmp    80102a <memcpy+0x66>
			*d8++ = *s8++;
  801014:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801017:	8d 50 01             	lea    0x1(%eax),%edx
  80101a:	89 55 f0             	mov    %edx,-0x10(%ebp)
  80101d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801020:	8d 4a 01             	lea    0x1(%edx),%ecx
  801023:	89 4d f4             	mov    %ecx,-0xc(%ebp)
  801026:	8a 12                	mov    (%edx),%dl
  801028:	88 10                	mov    %dl,(%eax)
	}

	if(n){
		uint8* s8 = (uint8*)s64;
		uint8* d8 = (uint8*)d64;
		while (n-- > 0)
  80102a:	8b 45 10             	mov    0x10(%ebp),%eax
  80102d:	8d 50 ff             	lea    -0x1(%eax),%edx
  801030:	89 55 10             	mov    %edx,0x10(%ebp)
  801033:	85 c0                	test   %eax,%eax
  801035:	75 dd                	jne    801014 <memcpy+0x50>
			*d8++ = *s8++;
	}
	return dst;
  801037:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80103a:	c9                   	leave  
  80103b:	c3                   	ret    

0080103c <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  80103c:	55                   	push   %ebp
  80103d:	89 e5                	mov    %esp,%ebp
  80103f:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801042:	8b 45 0c             	mov    0xc(%ebp),%eax
  801045:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801048:	8b 45 08             	mov    0x8(%ebp),%eax
  80104b:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  80104e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801051:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801054:	73 50                	jae    8010a6 <memmove+0x6a>
  801056:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801059:	8b 45 10             	mov    0x10(%ebp),%eax
  80105c:	01 d0                	add    %edx,%eax
  80105e:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801061:	76 43                	jbe    8010a6 <memmove+0x6a>
		s += n;
  801063:	8b 45 10             	mov    0x10(%ebp),%eax
  801066:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  801069:	8b 45 10             	mov    0x10(%ebp),%eax
  80106c:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  80106f:	eb 10                	jmp    801081 <memmove+0x45>
			*--d = *--s;
  801071:	ff 4d f8             	decl   -0x8(%ebp)
  801074:	ff 4d fc             	decl   -0x4(%ebp)
  801077:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80107a:	8a 10                	mov    (%eax),%dl
  80107c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80107f:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  801081:	8b 45 10             	mov    0x10(%ebp),%eax
  801084:	8d 50 ff             	lea    -0x1(%eax),%edx
  801087:	89 55 10             	mov    %edx,0x10(%ebp)
  80108a:	85 c0                	test   %eax,%eax
  80108c:	75 e3                	jne    801071 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  80108e:	eb 23                	jmp    8010b3 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  801090:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801093:	8d 50 01             	lea    0x1(%eax),%edx
  801096:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801099:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80109c:	8d 4a 01             	lea    0x1(%edx),%ecx
  80109f:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  8010a2:	8a 12                	mov    (%edx),%dl
  8010a4:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  8010a6:	8b 45 10             	mov    0x10(%ebp),%eax
  8010a9:	8d 50 ff             	lea    -0x1(%eax),%edx
  8010ac:	89 55 10             	mov    %edx,0x10(%ebp)
  8010af:	85 c0                	test   %eax,%eax
  8010b1:	75 dd                	jne    801090 <memmove+0x54>
			*d++ = *s++;

	return dst;
  8010b3:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8010b6:	c9                   	leave  
  8010b7:	c3                   	ret    

008010b8 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  8010b8:	55                   	push   %ebp
  8010b9:	89 e5                	mov    %esp,%ebp
  8010bb:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  8010be:	8b 45 08             	mov    0x8(%ebp),%eax
  8010c1:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  8010c4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010c7:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  8010ca:	eb 2a                	jmp    8010f6 <memcmp+0x3e>
		if (*s1 != *s2)
  8010cc:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8010cf:	8a 10                	mov    (%eax),%dl
  8010d1:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010d4:	8a 00                	mov    (%eax),%al
  8010d6:	38 c2                	cmp    %al,%dl
  8010d8:	74 16                	je     8010f0 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  8010da:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8010dd:	8a 00                	mov    (%eax),%al
  8010df:	0f b6 d0             	movzbl %al,%edx
  8010e2:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010e5:	8a 00                	mov    (%eax),%al
  8010e7:	0f b6 c0             	movzbl %al,%eax
  8010ea:	29 c2                	sub    %eax,%edx
  8010ec:	89 d0                	mov    %edx,%eax
  8010ee:	eb 18                	jmp    801108 <memcmp+0x50>
		s1++, s2++;
  8010f0:	ff 45 fc             	incl   -0x4(%ebp)
  8010f3:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  8010f6:	8b 45 10             	mov    0x10(%ebp),%eax
  8010f9:	8d 50 ff             	lea    -0x1(%eax),%edx
  8010fc:	89 55 10             	mov    %edx,0x10(%ebp)
  8010ff:	85 c0                	test   %eax,%eax
  801101:	75 c9                	jne    8010cc <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801103:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801108:	c9                   	leave  
  801109:	c3                   	ret    

0080110a <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  80110a:	55                   	push   %ebp
  80110b:	89 e5                	mov    %esp,%ebp
  80110d:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  801110:	8b 55 08             	mov    0x8(%ebp),%edx
  801113:	8b 45 10             	mov    0x10(%ebp),%eax
  801116:	01 d0                	add    %edx,%eax
  801118:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  80111b:	eb 15                	jmp    801132 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  80111d:	8b 45 08             	mov    0x8(%ebp),%eax
  801120:	8a 00                	mov    (%eax),%al
  801122:	0f b6 d0             	movzbl %al,%edx
  801125:	8b 45 0c             	mov    0xc(%ebp),%eax
  801128:	0f b6 c0             	movzbl %al,%eax
  80112b:	39 c2                	cmp    %eax,%edx
  80112d:	74 0d                	je     80113c <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  80112f:	ff 45 08             	incl   0x8(%ebp)
  801132:	8b 45 08             	mov    0x8(%ebp),%eax
  801135:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801138:	72 e3                	jb     80111d <memfind+0x13>
  80113a:	eb 01                	jmp    80113d <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  80113c:	90                   	nop
	return (void *) s;
  80113d:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801140:	c9                   	leave  
  801141:	c3                   	ret    

00801142 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801142:	55                   	push   %ebp
  801143:	89 e5                	mov    %esp,%ebp
  801145:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  801148:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  80114f:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801156:	eb 03                	jmp    80115b <strtol+0x19>
		s++;
  801158:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80115b:	8b 45 08             	mov    0x8(%ebp),%eax
  80115e:	8a 00                	mov    (%eax),%al
  801160:	3c 20                	cmp    $0x20,%al
  801162:	74 f4                	je     801158 <strtol+0x16>
  801164:	8b 45 08             	mov    0x8(%ebp),%eax
  801167:	8a 00                	mov    (%eax),%al
  801169:	3c 09                	cmp    $0x9,%al
  80116b:	74 eb                	je     801158 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  80116d:	8b 45 08             	mov    0x8(%ebp),%eax
  801170:	8a 00                	mov    (%eax),%al
  801172:	3c 2b                	cmp    $0x2b,%al
  801174:	75 05                	jne    80117b <strtol+0x39>
		s++;
  801176:	ff 45 08             	incl   0x8(%ebp)
  801179:	eb 13                	jmp    80118e <strtol+0x4c>
	else if (*s == '-')
  80117b:	8b 45 08             	mov    0x8(%ebp),%eax
  80117e:	8a 00                	mov    (%eax),%al
  801180:	3c 2d                	cmp    $0x2d,%al
  801182:	75 0a                	jne    80118e <strtol+0x4c>
		s++, neg = 1;
  801184:	ff 45 08             	incl   0x8(%ebp)
  801187:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  80118e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801192:	74 06                	je     80119a <strtol+0x58>
  801194:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  801198:	75 20                	jne    8011ba <strtol+0x78>
  80119a:	8b 45 08             	mov    0x8(%ebp),%eax
  80119d:	8a 00                	mov    (%eax),%al
  80119f:	3c 30                	cmp    $0x30,%al
  8011a1:	75 17                	jne    8011ba <strtol+0x78>
  8011a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8011a6:	40                   	inc    %eax
  8011a7:	8a 00                	mov    (%eax),%al
  8011a9:	3c 78                	cmp    $0x78,%al
  8011ab:	75 0d                	jne    8011ba <strtol+0x78>
		s += 2, base = 16;
  8011ad:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  8011b1:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  8011b8:	eb 28                	jmp    8011e2 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  8011ba:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8011be:	75 15                	jne    8011d5 <strtol+0x93>
  8011c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8011c3:	8a 00                	mov    (%eax),%al
  8011c5:	3c 30                	cmp    $0x30,%al
  8011c7:	75 0c                	jne    8011d5 <strtol+0x93>
		s++, base = 8;
  8011c9:	ff 45 08             	incl   0x8(%ebp)
  8011cc:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  8011d3:	eb 0d                	jmp    8011e2 <strtol+0xa0>
	else if (base == 0)
  8011d5:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8011d9:	75 07                	jne    8011e2 <strtol+0xa0>
		base = 10;
  8011db:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8011e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8011e5:	8a 00                	mov    (%eax),%al
  8011e7:	3c 2f                	cmp    $0x2f,%al
  8011e9:	7e 19                	jle    801204 <strtol+0xc2>
  8011eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8011ee:	8a 00                	mov    (%eax),%al
  8011f0:	3c 39                	cmp    $0x39,%al
  8011f2:	7f 10                	jg     801204 <strtol+0xc2>
			dig = *s - '0';
  8011f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8011f7:	8a 00                	mov    (%eax),%al
  8011f9:	0f be c0             	movsbl %al,%eax
  8011fc:	83 e8 30             	sub    $0x30,%eax
  8011ff:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801202:	eb 42                	jmp    801246 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  801204:	8b 45 08             	mov    0x8(%ebp),%eax
  801207:	8a 00                	mov    (%eax),%al
  801209:	3c 60                	cmp    $0x60,%al
  80120b:	7e 19                	jle    801226 <strtol+0xe4>
  80120d:	8b 45 08             	mov    0x8(%ebp),%eax
  801210:	8a 00                	mov    (%eax),%al
  801212:	3c 7a                	cmp    $0x7a,%al
  801214:	7f 10                	jg     801226 <strtol+0xe4>
			dig = *s - 'a' + 10;
  801216:	8b 45 08             	mov    0x8(%ebp),%eax
  801219:	8a 00                	mov    (%eax),%al
  80121b:	0f be c0             	movsbl %al,%eax
  80121e:	83 e8 57             	sub    $0x57,%eax
  801221:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801224:	eb 20                	jmp    801246 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  801226:	8b 45 08             	mov    0x8(%ebp),%eax
  801229:	8a 00                	mov    (%eax),%al
  80122b:	3c 40                	cmp    $0x40,%al
  80122d:	7e 39                	jle    801268 <strtol+0x126>
  80122f:	8b 45 08             	mov    0x8(%ebp),%eax
  801232:	8a 00                	mov    (%eax),%al
  801234:	3c 5a                	cmp    $0x5a,%al
  801236:	7f 30                	jg     801268 <strtol+0x126>
			dig = *s - 'A' + 10;
  801238:	8b 45 08             	mov    0x8(%ebp),%eax
  80123b:	8a 00                	mov    (%eax),%al
  80123d:	0f be c0             	movsbl %al,%eax
  801240:	83 e8 37             	sub    $0x37,%eax
  801243:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  801246:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801249:	3b 45 10             	cmp    0x10(%ebp),%eax
  80124c:	7d 19                	jge    801267 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  80124e:	ff 45 08             	incl   0x8(%ebp)
  801251:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801254:	0f af 45 10          	imul   0x10(%ebp),%eax
  801258:	89 c2                	mov    %eax,%edx
  80125a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80125d:	01 d0                	add    %edx,%eax
  80125f:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  801262:	e9 7b ff ff ff       	jmp    8011e2 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801267:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801268:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80126c:	74 08                	je     801276 <strtol+0x134>
		*endptr = (char *) s;
  80126e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801271:	8b 55 08             	mov    0x8(%ebp),%edx
  801274:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  801276:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80127a:	74 07                	je     801283 <strtol+0x141>
  80127c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80127f:	f7 d8                	neg    %eax
  801281:	eb 03                	jmp    801286 <strtol+0x144>
  801283:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801286:	c9                   	leave  
  801287:	c3                   	ret    

00801288 <ltostr>:

void
ltostr(long value, char *str)
{
  801288:	55                   	push   %ebp
  801289:	89 e5                	mov    %esp,%ebp
  80128b:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  80128e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  801295:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  80129c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8012a0:	79 13                	jns    8012b5 <ltostr+0x2d>
	{
		neg = 1;
  8012a2:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  8012a9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012ac:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  8012af:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  8012b2:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  8012b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8012b8:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8012bd:	99                   	cltd   
  8012be:	f7 f9                	idiv   %ecx
  8012c0:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  8012c3:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8012c6:	8d 50 01             	lea    0x1(%eax),%edx
  8012c9:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8012cc:	89 c2                	mov    %eax,%edx
  8012ce:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012d1:	01 d0                	add    %edx,%eax
  8012d3:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8012d6:	83 c2 30             	add    $0x30,%edx
  8012d9:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  8012db:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8012de:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8012e3:	f7 e9                	imul   %ecx
  8012e5:	c1 fa 02             	sar    $0x2,%edx
  8012e8:	89 c8                	mov    %ecx,%eax
  8012ea:	c1 f8 1f             	sar    $0x1f,%eax
  8012ed:	29 c2                	sub    %eax,%edx
  8012ef:	89 d0                	mov    %edx,%eax
  8012f1:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  8012f4:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8012f8:	75 bb                	jne    8012b5 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  8012fa:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801301:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801304:	48                   	dec    %eax
  801305:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801308:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80130c:	74 3d                	je     80134b <ltostr+0xc3>
		start = 1 ;
  80130e:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  801315:	eb 34                	jmp    80134b <ltostr+0xc3>
	{
		char tmp = str[start] ;
  801317:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80131a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80131d:	01 d0                	add    %edx,%eax
  80131f:	8a 00                	mov    (%eax),%al
  801321:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801324:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801327:	8b 45 0c             	mov    0xc(%ebp),%eax
  80132a:	01 c2                	add    %eax,%edx
  80132c:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  80132f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801332:	01 c8                	add    %ecx,%eax
  801334:	8a 00                	mov    (%eax),%al
  801336:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801338:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80133b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80133e:	01 c2                	add    %eax,%edx
  801340:	8a 45 eb             	mov    -0x15(%ebp),%al
  801343:	88 02                	mov    %al,(%edx)
		start++ ;
  801345:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801348:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  80134b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80134e:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801351:	7c c4                	jl     801317 <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801353:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801356:	8b 45 0c             	mov    0xc(%ebp),%eax
  801359:	01 d0                	add    %edx,%eax
  80135b:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  80135e:	90                   	nop
  80135f:	c9                   	leave  
  801360:	c3                   	ret    

00801361 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  801361:	55                   	push   %ebp
  801362:	89 e5                	mov    %esp,%ebp
  801364:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801367:	ff 75 08             	pushl  0x8(%ebp)
  80136a:	e8 c4 f9 ff ff       	call   800d33 <strlen>
  80136f:	83 c4 04             	add    $0x4,%esp
  801372:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  801375:	ff 75 0c             	pushl  0xc(%ebp)
  801378:	e8 b6 f9 ff ff       	call   800d33 <strlen>
  80137d:	83 c4 04             	add    $0x4,%esp
  801380:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  801383:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  80138a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801391:	eb 17                	jmp    8013aa <strcconcat+0x49>
		final[s] = str1[s] ;
  801393:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801396:	8b 45 10             	mov    0x10(%ebp),%eax
  801399:	01 c2                	add    %eax,%edx
  80139b:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  80139e:	8b 45 08             	mov    0x8(%ebp),%eax
  8013a1:	01 c8                	add    %ecx,%eax
  8013a3:	8a 00                	mov    (%eax),%al
  8013a5:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  8013a7:	ff 45 fc             	incl   -0x4(%ebp)
  8013aa:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8013ad:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8013b0:	7c e1                	jl     801393 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  8013b2:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  8013b9:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8013c0:	eb 1f                	jmp    8013e1 <strcconcat+0x80>
		final[s++] = str2[i] ;
  8013c2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8013c5:	8d 50 01             	lea    0x1(%eax),%edx
  8013c8:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8013cb:	89 c2                	mov    %eax,%edx
  8013cd:	8b 45 10             	mov    0x10(%ebp),%eax
  8013d0:	01 c2                	add    %eax,%edx
  8013d2:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8013d5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013d8:	01 c8                	add    %ecx,%eax
  8013da:	8a 00                	mov    (%eax),%al
  8013dc:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  8013de:	ff 45 f8             	incl   -0x8(%ebp)
  8013e1:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8013e4:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8013e7:	7c d9                	jl     8013c2 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  8013e9:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8013ec:	8b 45 10             	mov    0x10(%ebp),%eax
  8013ef:	01 d0                	add    %edx,%eax
  8013f1:	c6 00 00             	movb   $0x0,(%eax)
}
  8013f4:	90                   	nop
  8013f5:	c9                   	leave  
  8013f6:	c3                   	ret    

008013f7 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  8013f7:	55                   	push   %ebp
  8013f8:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  8013fa:	8b 45 14             	mov    0x14(%ebp),%eax
  8013fd:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801403:	8b 45 14             	mov    0x14(%ebp),%eax
  801406:	8b 00                	mov    (%eax),%eax
  801408:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80140f:	8b 45 10             	mov    0x10(%ebp),%eax
  801412:	01 d0                	add    %edx,%eax
  801414:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80141a:	eb 0c                	jmp    801428 <strsplit+0x31>
			*string++ = 0;
  80141c:	8b 45 08             	mov    0x8(%ebp),%eax
  80141f:	8d 50 01             	lea    0x1(%eax),%edx
  801422:	89 55 08             	mov    %edx,0x8(%ebp)
  801425:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801428:	8b 45 08             	mov    0x8(%ebp),%eax
  80142b:	8a 00                	mov    (%eax),%al
  80142d:	84 c0                	test   %al,%al
  80142f:	74 18                	je     801449 <strsplit+0x52>
  801431:	8b 45 08             	mov    0x8(%ebp),%eax
  801434:	8a 00                	mov    (%eax),%al
  801436:	0f be c0             	movsbl %al,%eax
  801439:	50                   	push   %eax
  80143a:	ff 75 0c             	pushl  0xc(%ebp)
  80143d:	e8 83 fa ff ff       	call   800ec5 <strchr>
  801442:	83 c4 08             	add    $0x8,%esp
  801445:	85 c0                	test   %eax,%eax
  801447:	75 d3                	jne    80141c <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801449:	8b 45 08             	mov    0x8(%ebp),%eax
  80144c:	8a 00                	mov    (%eax),%al
  80144e:	84 c0                	test   %al,%al
  801450:	74 5a                	je     8014ac <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801452:	8b 45 14             	mov    0x14(%ebp),%eax
  801455:	8b 00                	mov    (%eax),%eax
  801457:	83 f8 0f             	cmp    $0xf,%eax
  80145a:	75 07                	jne    801463 <strsplit+0x6c>
		{
			return 0;
  80145c:	b8 00 00 00 00       	mov    $0x0,%eax
  801461:	eb 66                	jmp    8014c9 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801463:	8b 45 14             	mov    0x14(%ebp),%eax
  801466:	8b 00                	mov    (%eax),%eax
  801468:	8d 48 01             	lea    0x1(%eax),%ecx
  80146b:	8b 55 14             	mov    0x14(%ebp),%edx
  80146e:	89 0a                	mov    %ecx,(%edx)
  801470:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801477:	8b 45 10             	mov    0x10(%ebp),%eax
  80147a:	01 c2                	add    %eax,%edx
  80147c:	8b 45 08             	mov    0x8(%ebp),%eax
  80147f:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801481:	eb 03                	jmp    801486 <strsplit+0x8f>
			string++;
  801483:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801486:	8b 45 08             	mov    0x8(%ebp),%eax
  801489:	8a 00                	mov    (%eax),%al
  80148b:	84 c0                	test   %al,%al
  80148d:	74 8b                	je     80141a <strsplit+0x23>
  80148f:	8b 45 08             	mov    0x8(%ebp),%eax
  801492:	8a 00                	mov    (%eax),%al
  801494:	0f be c0             	movsbl %al,%eax
  801497:	50                   	push   %eax
  801498:	ff 75 0c             	pushl  0xc(%ebp)
  80149b:	e8 25 fa ff ff       	call   800ec5 <strchr>
  8014a0:	83 c4 08             	add    $0x8,%esp
  8014a3:	85 c0                	test   %eax,%eax
  8014a5:	74 dc                	je     801483 <strsplit+0x8c>
			string++;
	}
  8014a7:	e9 6e ff ff ff       	jmp    80141a <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  8014ac:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  8014ad:	8b 45 14             	mov    0x14(%ebp),%eax
  8014b0:	8b 00                	mov    (%eax),%eax
  8014b2:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8014b9:	8b 45 10             	mov    0x10(%ebp),%eax
  8014bc:	01 d0                	add    %edx,%eax
  8014be:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  8014c4:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8014c9:	c9                   	leave  
  8014ca:	c3                   	ret    

008014cb <str2lower>:


char* str2lower(char *dst, const char *src)
{
  8014cb:	55                   	push   %ebp
  8014cc:	89 e5                	mov    %esp,%ebp
  8014ce:	83 ec 10             	sub    $0x10,%esp
	char* ret = dst;
  8014d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8014d4:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (int i = 0; i < strlen(src); ++i)
  8014d7:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8014de:	eb 4a                	jmp    80152a <str2lower+0x5f>
	{
		dst[i] = src[i] ;
  8014e0:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8014e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8014e6:	01 c2                	add    %eax,%edx
  8014e8:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8014eb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014ee:	01 c8                	add    %ecx,%eax
  8014f0:	8a 00                	mov    (%eax),%al
  8014f2:	88 02                	mov    %al,(%edx)
		if (src[i] >= 'A' && src[i] <= 'Z')
  8014f4:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8014f7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014fa:	01 d0                	add    %edx,%eax
  8014fc:	8a 00                	mov    (%eax),%al
  8014fe:	3c 40                	cmp    $0x40,%al
  801500:	7e 25                	jle    801527 <str2lower+0x5c>
  801502:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801505:	8b 45 0c             	mov    0xc(%ebp),%eax
  801508:	01 d0                	add    %edx,%eax
  80150a:	8a 00                	mov    (%eax),%al
  80150c:	3c 5a                	cmp    $0x5a,%al
  80150e:	7f 17                	jg     801527 <str2lower+0x5c>
		{
			dst[i] += 32 ;
  801510:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801513:	8b 45 08             	mov    0x8(%ebp),%eax
  801516:	01 d0                	add    %edx,%eax
  801518:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  80151b:	8b 55 08             	mov    0x8(%ebp),%edx
  80151e:	01 ca                	add    %ecx,%edx
  801520:	8a 12                	mov    (%edx),%dl
  801522:	83 c2 20             	add    $0x20,%edx
  801525:	88 10                	mov    %dl,(%eax)


char* str2lower(char *dst, const char *src)
{
	char* ret = dst;
	for (int i = 0; i < strlen(src); ++i)
  801527:	ff 45 fc             	incl   -0x4(%ebp)
  80152a:	ff 75 0c             	pushl  0xc(%ebp)
  80152d:	e8 01 f8 ff ff       	call   800d33 <strlen>
  801532:	83 c4 04             	add    $0x4,%esp
  801535:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801538:	7f a6                	jg     8014e0 <str2lower+0x15>
		if (src[i] >= 'A' && src[i] <= 'Z')
		{
			dst[i] += 32 ;
		}
	}
	return ret;
  80153a:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  80153d:	c9                   	leave  
  80153e:	c3                   	ret    

0080153f <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  80153f:	55                   	push   %ebp
  801540:	89 e5                	mov    %esp,%ebp
  801542:	57                   	push   %edi
  801543:	56                   	push   %esi
  801544:	53                   	push   %ebx
  801545:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801548:	8b 45 08             	mov    0x8(%ebp),%eax
  80154b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80154e:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801551:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801554:	8b 7d 18             	mov    0x18(%ebp),%edi
  801557:	8b 75 1c             	mov    0x1c(%ebp),%esi
  80155a:	cd 30                	int    $0x30
  80155c:	89 45 f0             	mov    %eax,-0x10(%ebp)
				"b" (a3),
				"D" (a4),
				"S" (a5)
				: "cc", "memory");

	return ret;
  80155f:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801562:	83 c4 10             	add    $0x10,%esp
  801565:	5b                   	pop    %ebx
  801566:	5e                   	pop    %esi
  801567:	5f                   	pop    %edi
  801568:	5d                   	pop    %ebp
  801569:	c3                   	ret    

0080156a <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName, int color)
{
  80156a:	55                   	push   %ebp
  80156b:	89 e5                	mov    %esp,%ebp
  80156d:	83 ec 04             	sub    $0x4,%esp
  801570:	8b 45 10             	mov    0x10(%ebp),%eax
  801573:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, color, 0);
  801576:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801579:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80157d:	8b 45 08             	mov    0x8(%ebp),%eax
  801580:	6a 00                	push   $0x0
  801582:	51                   	push   %ecx
  801583:	52                   	push   %edx
  801584:	ff 75 0c             	pushl  0xc(%ebp)
  801587:	50                   	push   %eax
  801588:	6a 00                	push   $0x0
  80158a:	e8 b0 ff ff ff       	call   80153f <syscall>
  80158f:	83 c4 18             	add    $0x18,%esp
}
  801592:	90                   	nop
  801593:	c9                   	leave  
  801594:	c3                   	ret    

00801595 <sys_cgetc>:

int
sys_cgetc(void)
{
  801595:	55                   	push   %ebp
  801596:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801598:	6a 00                	push   $0x0
  80159a:	6a 00                	push   $0x0
  80159c:	6a 00                	push   $0x0
  80159e:	6a 00                	push   $0x0
  8015a0:	6a 00                	push   $0x0
  8015a2:	6a 02                	push   $0x2
  8015a4:	e8 96 ff ff ff       	call   80153f <syscall>
  8015a9:	83 c4 18             	add    $0x18,%esp
}
  8015ac:	c9                   	leave  
  8015ad:	c3                   	ret    

008015ae <sys_lock_cons>:

void sys_lock_cons(void)
{
  8015ae:	55                   	push   %ebp
  8015af:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  8015b1:	6a 00                	push   $0x0
  8015b3:	6a 00                	push   $0x0
  8015b5:	6a 00                	push   $0x0
  8015b7:	6a 00                	push   $0x0
  8015b9:	6a 00                	push   $0x0
  8015bb:	6a 03                	push   $0x3
  8015bd:	e8 7d ff ff ff       	call   80153f <syscall>
  8015c2:	83 c4 18             	add    $0x18,%esp
}
  8015c5:	90                   	nop
  8015c6:	c9                   	leave  
  8015c7:	c3                   	ret    

008015c8 <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  8015c8:	55                   	push   %ebp
  8015c9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  8015cb:	6a 00                	push   $0x0
  8015cd:	6a 00                	push   $0x0
  8015cf:	6a 00                	push   $0x0
  8015d1:	6a 00                	push   $0x0
  8015d3:	6a 00                	push   $0x0
  8015d5:	6a 04                	push   $0x4
  8015d7:	e8 63 ff ff ff       	call   80153f <syscall>
  8015dc:	83 c4 18             	add    $0x18,%esp
}
  8015df:	90                   	nop
  8015e0:	c9                   	leave  
  8015e1:	c3                   	ret    

008015e2 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  8015e2:	55                   	push   %ebp
  8015e3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  8015e5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8015e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8015eb:	6a 00                	push   $0x0
  8015ed:	6a 00                	push   $0x0
  8015ef:	6a 00                	push   $0x0
  8015f1:	52                   	push   %edx
  8015f2:	50                   	push   %eax
  8015f3:	6a 08                	push   $0x8
  8015f5:	e8 45 ff ff ff       	call   80153f <syscall>
  8015fa:	83 c4 18             	add    $0x18,%esp
}
  8015fd:	c9                   	leave  
  8015fe:	c3                   	ret    

008015ff <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  8015ff:	55                   	push   %ebp
  801600:	89 e5                	mov    %esp,%ebp
  801602:	56                   	push   %esi
  801603:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801604:	8b 75 18             	mov    0x18(%ebp),%esi
  801607:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80160a:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80160d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801610:	8b 45 08             	mov    0x8(%ebp),%eax
  801613:	56                   	push   %esi
  801614:	53                   	push   %ebx
  801615:	51                   	push   %ecx
  801616:	52                   	push   %edx
  801617:	50                   	push   %eax
  801618:	6a 09                	push   $0x9
  80161a:	e8 20 ff ff ff       	call   80153f <syscall>
  80161f:	83 c4 18             	add    $0x18,%esp
}
  801622:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801625:	5b                   	pop    %ebx
  801626:	5e                   	pop    %esi
  801627:	5d                   	pop    %ebp
  801628:	c3                   	ret    

00801629 <__sys_unmap_frame>:

int __sys_unmap_frame(uint32 va)
{
  801629:	55                   	push   %ebp
  80162a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, va, 0, 0, 0, 0);
  80162c:	6a 00                	push   $0x0
  80162e:	6a 00                	push   $0x0
  801630:	6a 00                	push   $0x0
  801632:	6a 00                	push   $0x0
  801634:	ff 75 08             	pushl  0x8(%ebp)
  801637:	6a 0a                	push   $0xa
  801639:	e8 01 ff ff ff       	call   80153f <syscall>
  80163e:	83 c4 18             	add    $0x18,%esp
}
  801641:	c9                   	leave  
  801642:	c3                   	ret    

00801643 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801643:	55                   	push   %ebp
  801644:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801646:	6a 00                	push   $0x0
  801648:	6a 00                	push   $0x0
  80164a:	6a 00                	push   $0x0
  80164c:	ff 75 0c             	pushl  0xc(%ebp)
  80164f:	ff 75 08             	pushl  0x8(%ebp)
  801652:	6a 0b                	push   $0xb
  801654:	e8 e6 fe ff ff       	call   80153f <syscall>
  801659:	83 c4 18             	add    $0x18,%esp
}
  80165c:	c9                   	leave  
  80165d:	c3                   	ret    

0080165e <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  80165e:	55                   	push   %ebp
  80165f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801661:	6a 00                	push   $0x0
  801663:	6a 00                	push   $0x0
  801665:	6a 00                	push   $0x0
  801667:	6a 00                	push   $0x0
  801669:	6a 00                	push   $0x0
  80166b:	6a 0c                	push   $0xc
  80166d:	e8 cd fe ff ff       	call   80153f <syscall>
  801672:	83 c4 18             	add    $0x18,%esp
}
  801675:	c9                   	leave  
  801676:	c3                   	ret    

00801677 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801677:	55                   	push   %ebp
  801678:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  80167a:	6a 00                	push   $0x0
  80167c:	6a 00                	push   $0x0
  80167e:	6a 00                	push   $0x0
  801680:	6a 00                	push   $0x0
  801682:	6a 00                	push   $0x0
  801684:	6a 0d                	push   $0xd
  801686:	e8 b4 fe ff ff       	call   80153f <syscall>
  80168b:	83 c4 18             	add    $0x18,%esp
}
  80168e:	c9                   	leave  
  80168f:	c3                   	ret    

00801690 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801690:	55                   	push   %ebp
  801691:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801693:	6a 00                	push   $0x0
  801695:	6a 00                	push   $0x0
  801697:	6a 00                	push   $0x0
  801699:	6a 00                	push   $0x0
  80169b:	6a 00                	push   $0x0
  80169d:	6a 0e                	push   $0xe
  80169f:	e8 9b fe ff ff       	call   80153f <syscall>
  8016a4:	83 c4 18             	add    $0x18,%esp
}
  8016a7:	c9                   	leave  
  8016a8:	c3                   	ret    

008016a9 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  8016a9:	55                   	push   %ebp
  8016aa:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  8016ac:	6a 00                	push   $0x0
  8016ae:	6a 00                	push   $0x0
  8016b0:	6a 00                	push   $0x0
  8016b2:	6a 00                	push   $0x0
  8016b4:	6a 00                	push   $0x0
  8016b6:	6a 0f                	push   $0xf
  8016b8:	e8 82 fe ff ff       	call   80153f <syscall>
  8016bd:	83 c4 18             	add    $0x18,%esp
}
  8016c0:	c9                   	leave  
  8016c1:	c3                   	ret    

008016c2 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  8016c2:	55                   	push   %ebp
  8016c3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  8016c5:	6a 00                	push   $0x0
  8016c7:	6a 00                	push   $0x0
  8016c9:	6a 00                	push   $0x0
  8016cb:	6a 00                	push   $0x0
  8016cd:	ff 75 08             	pushl  0x8(%ebp)
  8016d0:	6a 10                	push   $0x10
  8016d2:	e8 68 fe ff ff       	call   80153f <syscall>
  8016d7:	83 c4 18             	add    $0x18,%esp
}
  8016da:	c9                   	leave  
  8016db:	c3                   	ret    

008016dc <sys_scarce_memory>:

void sys_scarce_memory()
{
  8016dc:	55                   	push   %ebp
  8016dd:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  8016df:	6a 00                	push   $0x0
  8016e1:	6a 00                	push   $0x0
  8016e3:	6a 00                	push   $0x0
  8016e5:	6a 00                	push   $0x0
  8016e7:	6a 00                	push   $0x0
  8016e9:	6a 11                	push   $0x11
  8016eb:	e8 4f fe ff ff       	call   80153f <syscall>
  8016f0:	83 c4 18             	add    $0x18,%esp
}
  8016f3:	90                   	nop
  8016f4:	c9                   	leave  
  8016f5:	c3                   	ret    

008016f6 <sys_cputc>:

void
sys_cputc(const char c)
{
  8016f6:	55                   	push   %ebp
  8016f7:	89 e5                	mov    %esp,%ebp
  8016f9:	83 ec 04             	sub    $0x4,%esp
  8016fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8016ff:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801702:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801706:	6a 00                	push   $0x0
  801708:	6a 00                	push   $0x0
  80170a:	6a 00                	push   $0x0
  80170c:	6a 00                	push   $0x0
  80170e:	50                   	push   %eax
  80170f:	6a 01                	push   $0x1
  801711:	e8 29 fe ff ff       	call   80153f <syscall>
  801716:	83 c4 18             	add    $0x18,%esp
}
  801719:	90                   	nop
  80171a:	c9                   	leave  
  80171b:	c3                   	ret    

0080171c <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  80171c:	55                   	push   %ebp
  80171d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  80171f:	6a 00                	push   $0x0
  801721:	6a 00                	push   $0x0
  801723:	6a 00                	push   $0x0
  801725:	6a 00                	push   $0x0
  801727:	6a 00                	push   $0x0
  801729:	6a 14                	push   $0x14
  80172b:	e8 0f fe ff ff       	call   80153f <syscall>
  801730:	83 c4 18             	add    $0x18,%esp
}
  801733:	90                   	nop
  801734:	c9                   	leave  
  801735:	c3                   	ret    

00801736 <sys_create_shared_object>:

int sys_create_shared_object(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801736:	55                   	push   %ebp
  801737:	89 e5                	mov    %esp,%ebp
  801739:	83 ec 04             	sub    $0x4,%esp
  80173c:	8b 45 10             	mov    0x10(%ebp),%eax
  80173f:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801742:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801745:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801749:	8b 45 08             	mov    0x8(%ebp),%eax
  80174c:	6a 00                	push   $0x0
  80174e:	51                   	push   %ecx
  80174f:	52                   	push   %edx
  801750:	ff 75 0c             	pushl  0xc(%ebp)
  801753:	50                   	push   %eax
  801754:	6a 15                	push   $0x15
  801756:	e8 e4 fd ff ff       	call   80153f <syscall>
  80175b:	83 c4 18             	add    $0x18,%esp
}
  80175e:	c9                   	leave  
  80175f:	c3                   	ret    

00801760 <sys_size_of_shared_object>:

//2017:
int sys_size_of_shared_object(int32 ownerID, char* shareName)
{
  801760:	55                   	push   %ebp
  801761:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801763:	8b 55 0c             	mov    0xc(%ebp),%edx
  801766:	8b 45 08             	mov    0x8(%ebp),%eax
  801769:	6a 00                	push   $0x0
  80176b:	6a 00                	push   $0x0
  80176d:	6a 00                	push   $0x0
  80176f:	52                   	push   %edx
  801770:	50                   	push   %eax
  801771:	6a 16                	push   $0x16
  801773:	e8 c7 fd ff ff       	call   80153f <syscall>
  801778:	83 c4 18             	add    $0x18,%esp
}
  80177b:	c9                   	leave  
  80177c:	c3                   	ret    

0080177d <sys_get_shared_object>:
//==========

int sys_get_shared_object(int32 ownerID, char* shareName, void* virtual_address)
{
  80177d:	55                   	push   %ebp
  80177e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801780:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801783:	8b 55 0c             	mov    0xc(%ebp),%edx
  801786:	8b 45 08             	mov    0x8(%ebp),%eax
  801789:	6a 00                	push   $0x0
  80178b:	6a 00                	push   $0x0
  80178d:	51                   	push   %ecx
  80178e:	52                   	push   %edx
  80178f:	50                   	push   %eax
  801790:	6a 17                	push   $0x17
  801792:	e8 a8 fd ff ff       	call   80153f <syscall>
  801797:	83 c4 18             	add    $0x18,%esp
}
  80179a:	c9                   	leave  
  80179b:	c3                   	ret    

0080179c <sys_delete_shared_object>:

int sys_delete_shared_object(int32 sharedObjectID, void *startVA)
{
  80179c:	55                   	push   %ebp
  80179d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  80179f:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8017a5:	6a 00                	push   $0x0
  8017a7:	6a 00                	push   $0x0
  8017a9:	6a 00                	push   $0x0
  8017ab:	52                   	push   %edx
  8017ac:	50                   	push   %eax
  8017ad:	6a 18                	push   $0x18
  8017af:	e8 8b fd ff ff       	call   80153f <syscall>
  8017b4:	83 c4 18             	add    $0x18,%esp
}
  8017b7:	c9                   	leave  
  8017b8:	c3                   	ret    

008017b9 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  8017b9:	55                   	push   %ebp
  8017ba:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  8017bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8017bf:	6a 00                	push   $0x0
  8017c1:	ff 75 14             	pushl  0x14(%ebp)
  8017c4:	ff 75 10             	pushl  0x10(%ebp)
  8017c7:	ff 75 0c             	pushl  0xc(%ebp)
  8017ca:	50                   	push   %eax
  8017cb:	6a 19                	push   $0x19
  8017cd:	e8 6d fd ff ff       	call   80153f <syscall>
  8017d2:	83 c4 18             	add    $0x18,%esp
}
  8017d5:	c9                   	leave  
  8017d6:	c3                   	ret    

008017d7 <sys_run_env>:

void sys_run_env(int32 envId)
{
  8017d7:	55                   	push   %ebp
  8017d8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  8017da:	8b 45 08             	mov    0x8(%ebp),%eax
  8017dd:	6a 00                	push   $0x0
  8017df:	6a 00                	push   $0x0
  8017e1:	6a 00                	push   $0x0
  8017e3:	6a 00                	push   $0x0
  8017e5:	50                   	push   %eax
  8017e6:	6a 1a                	push   $0x1a
  8017e8:	e8 52 fd ff ff       	call   80153f <syscall>
  8017ed:	83 c4 18             	add    $0x18,%esp
}
  8017f0:	90                   	nop
  8017f1:	c9                   	leave  
  8017f2:	c3                   	ret    

008017f3 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  8017f3:	55                   	push   %ebp
  8017f4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  8017f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8017f9:	6a 00                	push   $0x0
  8017fb:	6a 00                	push   $0x0
  8017fd:	6a 00                	push   $0x0
  8017ff:	6a 00                	push   $0x0
  801801:	50                   	push   %eax
  801802:	6a 1b                	push   $0x1b
  801804:	e8 36 fd ff ff       	call   80153f <syscall>
  801809:	83 c4 18             	add    $0x18,%esp
}
  80180c:	c9                   	leave  
  80180d:	c3                   	ret    

0080180e <sys_getenvid>:

int32 sys_getenvid(void)
{
  80180e:	55                   	push   %ebp
  80180f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801811:	6a 00                	push   $0x0
  801813:	6a 00                	push   $0x0
  801815:	6a 00                	push   $0x0
  801817:	6a 00                	push   $0x0
  801819:	6a 00                	push   $0x0
  80181b:	6a 05                	push   $0x5
  80181d:	e8 1d fd ff ff       	call   80153f <syscall>
  801822:	83 c4 18             	add    $0x18,%esp
}
  801825:	c9                   	leave  
  801826:	c3                   	ret    

00801827 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801827:	55                   	push   %ebp
  801828:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  80182a:	6a 00                	push   $0x0
  80182c:	6a 00                	push   $0x0
  80182e:	6a 00                	push   $0x0
  801830:	6a 00                	push   $0x0
  801832:	6a 00                	push   $0x0
  801834:	6a 06                	push   $0x6
  801836:	e8 04 fd ff ff       	call   80153f <syscall>
  80183b:	83 c4 18             	add    $0x18,%esp
}
  80183e:	c9                   	leave  
  80183f:	c3                   	ret    

00801840 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801840:	55                   	push   %ebp
  801841:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801843:	6a 00                	push   $0x0
  801845:	6a 00                	push   $0x0
  801847:	6a 00                	push   $0x0
  801849:	6a 00                	push   $0x0
  80184b:	6a 00                	push   $0x0
  80184d:	6a 07                	push   $0x7
  80184f:	e8 eb fc ff ff       	call   80153f <syscall>
  801854:	83 c4 18             	add    $0x18,%esp
}
  801857:	c9                   	leave  
  801858:	c3                   	ret    

00801859 <sys_exit_env>:


void sys_exit_env(void)
{
  801859:	55                   	push   %ebp
  80185a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  80185c:	6a 00                	push   $0x0
  80185e:	6a 00                	push   $0x0
  801860:	6a 00                	push   $0x0
  801862:	6a 00                	push   $0x0
  801864:	6a 00                	push   $0x0
  801866:	6a 1c                	push   $0x1c
  801868:	e8 d2 fc ff ff       	call   80153f <syscall>
  80186d:	83 c4 18             	add    $0x18,%esp
}
  801870:	90                   	nop
  801871:	c9                   	leave  
  801872:	c3                   	ret    

00801873 <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  801873:	55                   	push   %ebp
  801874:	89 e5                	mov    %esp,%ebp
  801876:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801879:	8d 45 f8             	lea    -0x8(%ebp),%eax
  80187c:	8d 50 04             	lea    0x4(%eax),%edx
  80187f:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801882:	6a 00                	push   $0x0
  801884:	6a 00                	push   $0x0
  801886:	6a 00                	push   $0x0
  801888:	52                   	push   %edx
  801889:	50                   	push   %eax
  80188a:	6a 1d                	push   $0x1d
  80188c:	e8 ae fc ff ff       	call   80153f <syscall>
  801891:	83 c4 18             	add    $0x18,%esp
	return result;
  801894:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801897:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80189a:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80189d:	89 01                	mov    %eax,(%ecx)
  80189f:	89 51 04             	mov    %edx,0x4(%ecx)
}
  8018a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8018a5:	c9                   	leave  
  8018a6:	c2 04 00             	ret    $0x4

008018a9 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  8018a9:	55                   	push   %ebp
  8018aa:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  8018ac:	6a 00                	push   $0x0
  8018ae:	6a 00                	push   $0x0
  8018b0:	ff 75 10             	pushl  0x10(%ebp)
  8018b3:	ff 75 0c             	pushl  0xc(%ebp)
  8018b6:	ff 75 08             	pushl  0x8(%ebp)
  8018b9:	6a 13                	push   $0x13
  8018bb:	e8 7f fc ff ff       	call   80153f <syscall>
  8018c0:	83 c4 18             	add    $0x18,%esp
	return ;
  8018c3:	90                   	nop
}
  8018c4:	c9                   	leave  
  8018c5:	c3                   	ret    

008018c6 <sys_rcr2>:
uint32 sys_rcr2()
{
  8018c6:	55                   	push   %ebp
  8018c7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  8018c9:	6a 00                	push   $0x0
  8018cb:	6a 00                	push   $0x0
  8018cd:	6a 00                	push   $0x0
  8018cf:	6a 00                	push   $0x0
  8018d1:	6a 00                	push   $0x0
  8018d3:	6a 1e                	push   $0x1e
  8018d5:	e8 65 fc ff ff       	call   80153f <syscall>
  8018da:	83 c4 18             	add    $0x18,%esp
}
  8018dd:	c9                   	leave  
  8018de:	c3                   	ret    

008018df <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  8018df:	55                   	push   %ebp
  8018e0:	89 e5                	mov    %esp,%ebp
  8018e2:	83 ec 04             	sub    $0x4,%esp
  8018e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8018e8:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  8018eb:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  8018ef:	6a 00                	push   $0x0
  8018f1:	6a 00                	push   $0x0
  8018f3:	6a 00                	push   $0x0
  8018f5:	6a 00                	push   $0x0
  8018f7:	50                   	push   %eax
  8018f8:	6a 1f                	push   $0x1f
  8018fa:	e8 40 fc ff ff       	call   80153f <syscall>
  8018ff:	83 c4 18             	add    $0x18,%esp
	return ;
  801902:	90                   	nop
}
  801903:	c9                   	leave  
  801904:	c3                   	ret    

00801905 <rsttst>:
void rsttst()
{
  801905:	55                   	push   %ebp
  801906:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801908:	6a 00                	push   $0x0
  80190a:	6a 00                	push   $0x0
  80190c:	6a 00                	push   $0x0
  80190e:	6a 00                	push   $0x0
  801910:	6a 00                	push   $0x0
  801912:	6a 21                	push   $0x21
  801914:	e8 26 fc ff ff       	call   80153f <syscall>
  801919:	83 c4 18             	add    $0x18,%esp
	return ;
  80191c:	90                   	nop
}
  80191d:	c9                   	leave  
  80191e:	c3                   	ret    

0080191f <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  80191f:	55                   	push   %ebp
  801920:	89 e5                	mov    %esp,%ebp
  801922:	83 ec 04             	sub    $0x4,%esp
  801925:	8b 45 14             	mov    0x14(%ebp),%eax
  801928:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  80192b:	8b 55 18             	mov    0x18(%ebp),%edx
  80192e:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801932:	52                   	push   %edx
  801933:	50                   	push   %eax
  801934:	ff 75 10             	pushl  0x10(%ebp)
  801937:	ff 75 0c             	pushl  0xc(%ebp)
  80193a:	ff 75 08             	pushl  0x8(%ebp)
  80193d:	6a 20                	push   $0x20
  80193f:	e8 fb fb ff ff       	call   80153f <syscall>
  801944:	83 c4 18             	add    $0x18,%esp
	return ;
  801947:	90                   	nop
}
  801948:	c9                   	leave  
  801949:	c3                   	ret    

0080194a <chktst>:
void chktst(uint32 n)
{
  80194a:	55                   	push   %ebp
  80194b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  80194d:	6a 00                	push   $0x0
  80194f:	6a 00                	push   $0x0
  801951:	6a 00                	push   $0x0
  801953:	6a 00                	push   $0x0
  801955:	ff 75 08             	pushl  0x8(%ebp)
  801958:	6a 22                	push   $0x22
  80195a:	e8 e0 fb ff ff       	call   80153f <syscall>
  80195f:	83 c4 18             	add    $0x18,%esp
	return ;
  801962:	90                   	nop
}
  801963:	c9                   	leave  
  801964:	c3                   	ret    

00801965 <inctst>:

void inctst()
{
  801965:	55                   	push   %ebp
  801966:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801968:	6a 00                	push   $0x0
  80196a:	6a 00                	push   $0x0
  80196c:	6a 00                	push   $0x0
  80196e:	6a 00                	push   $0x0
  801970:	6a 00                	push   $0x0
  801972:	6a 23                	push   $0x23
  801974:	e8 c6 fb ff ff       	call   80153f <syscall>
  801979:	83 c4 18             	add    $0x18,%esp
	return ;
  80197c:	90                   	nop
}
  80197d:	c9                   	leave  
  80197e:	c3                   	ret    

0080197f <gettst>:
uint32 gettst()
{
  80197f:	55                   	push   %ebp
  801980:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801982:	6a 00                	push   $0x0
  801984:	6a 00                	push   $0x0
  801986:	6a 00                	push   $0x0
  801988:	6a 00                	push   $0x0
  80198a:	6a 00                	push   $0x0
  80198c:	6a 24                	push   $0x24
  80198e:	e8 ac fb ff ff       	call   80153f <syscall>
  801993:	83 c4 18             	add    $0x18,%esp
}
  801996:	c9                   	leave  
  801997:	c3                   	ret    

00801998 <sys_get_uheap_strategy>:

/*2025*/
uint32 sys_get_uheap_strategy()
{
  801998:	55                   	push   %ebp
  801999:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80199b:	6a 00                	push   $0x0
  80199d:	6a 00                	push   $0x0
  80199f:	6a 00                	push   $0x0
  8019a1:	6a 00                	push   $0x0
  8019a3:	6a 00                	push   $0x0
  8019a5:	6a 25                	push   $0x25
  8019a7:	e8 93 fb ff ff       	call   80153f <syscall>
  8019ac:	83 c4 18             	add    $0x18,%esp
  8019af:	a3 60 b0 81 00       	mov    %eax,0x81b060
	return uheapPlaceStrategy ;
  8019b4:	a1 60 b0 81 00       	mov    0x81b060,%eax
}
  8019b9:	c9                   	leave  
  8019ba:	c3                   	ret    

008019bb <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  8019bb:	55                   	push   %ebp
  8019bc:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = heapStrategy;
  8019be:	8b 45 08             	mov    0x8(%ebp),%eax
  8019c1:	a3 60 b0 81 00       	mov    %eax,0x81b060
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  8019c6:	6a 00                	push   $0x0
  8019c8:	6a 00                	push   $0x0
  8019ca:	6a 00                	push   $0x0
  8019cc:	6a 00                	push   $0x0
  8019ce:	ff 75 08             	pushl  0x8(%ebp)
  8019d1:	6a 26                	push   $0x26
  8019d3:	e8 67 fb ff ff       	call   80153f <syscall>
  8019d8:	83 c4 18             	add    $0x18,%esp
	return ;
  8019db:	90                   	nop
}
  8019dc:	c9                   	leave  
  8019dd:	c3                   	ret    

008019de <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  8019de:	55                   	push   %ebp
  8019df:	89 e5                	mov    %esp,%ebp
  8019e1:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  8019e2:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8019e5:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8019e8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8019ee:	6a 00                	push   $0x0
  8019f0:	53                   	push   %ebx
  8019f1:	51                   	push   %ecx
  8019f2:	52                   	push   %edx
  8019f3:	50                   	push   %eax
  8019f4:	6a 27                	push   $0x27
  8019f6:	e8 44 fb ff ff       	call   80153f <syscall>
  8019fb:	83 c4 18             	add    $0x18,%esp
}
  8019fe:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801a01:	c9                   	leave  
  801a02:	c3                   	ret    

00801a03 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801a03:	55                   	push   %ebp
  801a04:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801a06:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a09:	8b 45 08             	mov    0x8(%ebp),%eax
  801a0c:	6a 00                	push   $0x0
  801a0e:	6a 00                	push   $0x0
  801a10:	6a 00                	push   $0x0
  801a12:	52                   	push   %edx
  801a13:	50                   	push   %eax
  801a14:	6a 28                	push   $0x28
  801a16:	e8 24 fb ff ff       	call   80153f <syscall>
  801a1b:	83 c4 18             	add    $0x18,%esp
}
  801a1e:	c9                   	leave  
  801a1f:	c3                   	ret    

00801a20 <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  801a20:	55                   	push   %ebp
  801a21:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  801a23:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801a26:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a29:	8b 45 08             	mov    0x8(%ebp),%eax
  801a2c:	6a 00                	push   $0x0
  801a2e:	51                   	push   %ecx
  801a2f:	ff 75 10             	pushl  0x10(%ebp)
  801a32:	52                   	push   %edx
  801a33:	50                   	push   %eax
  801a34:	6a 29                	push   $0x29
  801a36:	e8 04 fb ff ff       	call   80153f <syscall>
  801a3b:	83 c4 18             	add    $0x18,%esp
}
  801a3e:	c9                   	leave  
  801a3f:	c3                   	ret    

00801a40 <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801a40:	55                   	push   %ebp
  801a41:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801a43:	6a 00                	push   $0x0
  801a45:	6a 00                	push   $0x0
  801a47:	ff 75 10             	pushl  0x10(%ebp)
  801a4a:	ff 75 0c             	pushl  0xc(%ebp)
  801a4d:	ff 75 08             	pushl  0x8(%ebp)
  801a50:	6a 12                	push   $0x12
  801a52:	e8 e8 fa ff ff       	call   80153f <syscall>
  801a57:	83 c4 18             	add    $0x18,%esp
	return ;
  801a5a:	90                   	nop
}
  801a5b:	c9                   	leave  
  801a5c:	c3                   	ret    

00801a5d <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  801a5d:	55                   	push   %ebp
  801a5e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  801a60:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a63:	8b 45 08             	mov    0x8(%ebp),%eax
  801a66:	6a 00                	push   $0x0
  801a68:	6a 00                	push   $0x0
  801a6a:	6a 00                	push   $0x0
  801a6c:	52                   	push   %edx
  801a6d:	50                   	push   %eax
  801a6e:	6a 2a                	push   $0x2a
  801a70:	e8 ca fa ff ff       	call   80153f <syscall>
  801a75:	83 c4 18             	add    $0x18,%esp
	return;
  801a78:	90                   	nop
}
  801a79:	c9                   	leave  
  801a7a:	c3                   	ret    

00801a7b <sys_get_optimal_num_faults>:
/*2025*/
int sys_get_optimal_num_faults()
{
  801a7b:	55                   	push   %ebp
  801a7c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_optimal_num_faults, 0, 0, 0, 0, 0);
  801a7e:	6a 00                	push   $0x0
  801a80:	6a 00                	push   $0x0
  801a82:	6a 00                	push   $0x0
  801a84:	6a 00                	push   $0x0
  801a86:	6a 00                	push   $0x0
  801a88:	6a 2b                	push   $0x2b
  801a8a:	e8 b0 fa ff ff       	call   80153f <syscall>
  801a8f:	83 c4 18             	add    $0x18,%esp
}
  801a92:	c9                   	leave  
  801a93:	c3                   	ret    

00801a94 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801a94:	55                   	push   %ebp
  801a95:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801a97:	6a 00                	push   $0x0
  801a99:	6a 00                	push   $0x0
  801a9b:	6a 00                	push   $0x0
  801a9d:	ff 75 0c             	pushl  0xc(%ebp)
  801aa0:	ff 75 08             	pushl  0x8(%ebp)
  801aa3:	6a 2d                	push   $0x2d
  801aa5:	e8 95 fa ff ff       	call   80153f <syscall>
  801aaa:	83 c4 18             	add    $0x18,%esp
	return;
  801aad:	90                   	nop
}
  801aae:	c9                   	leave  
  801aaf:	c3                   	ret    

00801ab0 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801ab0:	55                   	push   %ebp
  801ab1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801ab3:	6a 00                	push   $0x0
  801ab5:	6a 00                	push   $0x0
  801ab7:	6a 00                	push   $0x0
  801ab9:	ff 75 0c             	pushl  0xc(%ebp)
  801abc:	ff 75 08             	pushl  0x8(%ebp)
  801abf:	6a 2c                	push   $0x2c
  801ac1:	e8 79 fa ff ff       	call   80153f <syscall>
  801ac6:	83 c4 18             	add    $0x18,%esp
	return ;
  801ac9:	90                   	nop
}
  801aca:	c9                   	leave  
  801acb:	c3                   	ret    

00801acc <sys_env_set_priority>:


void sys_env_set_priority(int32 envID, int priority)
{
  801acc:	55                   	push   %ebp
  801acd:	89 e5                	mov    %esp,%ebp
  801acf:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.IM#4] CPU SCHEDULING - #1 System Calls - Add suitable code here
	//Your code is here
	//Comment the following line
	panic("sys_env_set_priority() is not implemented yet...!!");
  801ad2:	83 ec 04             	sub    $0x4,%esp
  801ad5:	68 e8 25 80 00       	push   $0x8025e8
  801ada:	68 25 01 00 00       	push   $0x125
  801adf:	68 1b 26 80 00       	push   $0x80261b
  801ae4:	e8 a3 e8 ff ff       	call   80038c <_panic>

00801ae9 <env_sleep>:
#include <inc/lib.h>
#include <inc/timerreg.h>

void
env_sleep(uint32 approxMilliSeconds)
{
  801ae9:	55                   	push   %ebp
  801aea:	89 e5                	mov    %esp,%ebp
  801aec:	83 ec 30             	sub    $0x30,%esp
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
  801aef:	8b 55 08             	mov    0x8(%ebp),%edx
  801af2:	89 d0                	mov    %edx,%eax
  801af4:	c1 e0 02             	shl    $0x2,%eax
  801af7:	01 d0                	add    %edx,%eax
  801af9:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801b00:	01 d0                	add    %edx,%eax
  801b02:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801b09:	01 d0                	add    %edx,%eax
  801b0b:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801b12:	01 d0                	add    %edx,%eax
  801b14:	c1 e0 04             	shl    $0x4,%eax
  801b17:	89 45 f8             	mov    %eax,-0x8(%ebp)
	uint32 cycles_counter =0;
  801b1a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)

static inline __attribute__((always_inline)) struct uint64 get_virtual_time_user()
{
	struct uint64 result;

	__asm __volatile("rdtsc\n"
  801b21:	0f 31                	rdtsc  
  801b23:	89 45 e8             	mov    %eax,-0x18(%ebp)
  801b26:	89 55 ec             	mov    %edx,-0x14(%ebp)
	: "=a" (result.low), "=d" (result.hi)
	);

	return result;
  801b29:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801b2c:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801b2f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801b32:	89 55 f4             	mov    %edx,-0xc(%ebp)

	/*2024*/ //USE A USER-SIDE VERSION OF THIS FUNCTION TO AVOID SLOW-DOWN THE PERFORMANCE DUE SYS_CALL (el7 :))
	//struct uint64 baseTime = sys_get_virtual_time() ;
	struct uint64 baseTime = get_virtual_time_user() ;
	while(cycles_counter<time_in_cycles)
  801b35:	eb 46                	jmp    801b7d <env_sleep+0x94>

static inline __attribute__((always_inline)) struct uint64 get_virtual_time_user()
{
	struct uint64 result;

	__asm __volatile("rdtsc\n"
  801b37:	0f 31                	rdtsc  
  801b39:	89 45 d0             	mov    %eax,-0x30(%ebp)
  801b3c:	89 55 d4             	mov    %edx,-0x2c(%ebp)
	: "=a" (result.low), "=d" (result.hi)
	);

	return result;
  801b3f:	8b 45 d0             	mov    -0x30(%ebp),%eax
  801b42:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  801b45:	89 45 e0             	mov    %eax,-0x20(%ebp)
  801b48:	89 55 e4             	mov    %edx,-0x1c(%ebp)

		// update the cycles_count
		#define M32 0xffffffff
		// subtract basetime from current time
		struct uint64 res;
		res.low = (currentTime.low - baseTime.low) & M32;
  801b4b:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801b4e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801b51:	29 c2                	sub    %eax,%edx
  801b53:	89 d0                	mov    %edx,%eax
  801b55:	89 45 d8             	mov    %eax,-0x28(%ebp)
		res.hi = (currentTime.hi - baseTime.hi - (res.low > currentTime.low)) & M32;
  801b58:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801b5b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b5e:	89 d1                	mov    %edx,%ecx
  801b60:	29 c1                	sub    %eax,%ecx
  801b62:	8b 55 d8             	mov    -0x28(%ebp),%edx
  801b65:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801b68:	39 c2                	cmp    %eax,%edx
  801b6a:	0f 97 c0             	seta   %al
  801b6d:	0f b6 c0             	movzbl %al,%eax
  801b70:	29 c1                	sub    %eax,%ecx
  801b72:	89 c8                	mov    %ecx,%eax
  801b74:	89 45 dc             	mov    %eax,-0x24(%ebp)

		//update cycles_count with result
		cycles_counter = res.low;
  801b77:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801b7a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	uint32 cycles_counter =0;

	/*2024*/ //USE A USER-SIDE VERSION OF THIS FUNCTION TO AVOID SLOW-DOWN THE PERFORMANCE DUE SYS_CALL (el7 :))
	//struct uint64 baseTime = sys_get_virtual_time() ;
	struct uint64 baseTime = get_virtual_time_user() ;
	while(cycles_counter<time_in_cycles)
  801b7d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801b80:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801b83:	72 b2                	jb     801b37 <env_sleep+0x4e>
//				,cycles_counter
//				);
	}
	//cprintf("%s [%d] wake up now!\n", myEnv->prog_name, myEnv->env_id);

}
  801b85:	90                   	nop
  801b86:	c9                   	leave  
  801b87:	c3                   	ret    

00801b88 <busy_wait>:

//2017
uint32 busy_wait(uint32 loopMax)
{
  801b88:	55                   	push   %ebp
  801b89:	89 e5                	mov    %esp,%ebp
  801b8b:	83 ec 10             	sub    $0x10,%esp
	uint32 i = 0 ;
  801b8e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	while (i < loopMax) i++;
  801b95:	eb 03                	jmp    801b9a <busy_wait+0x12>
  801b97:	ff 45 fc             	incl   -0x4(%ebp)
  801b9a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801b9d:	3b 45 08             	cmp    0x8(%ebp),%eax
  801ba0:	72 f5                	jb     801b97 <busy_wait+0xf>
	return i;
  801ba2:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801ba5:	c9                   	leave  
  801ba6:	c3                   	ret    
  801ba7:	90                   	nop

00801ba8 <__udivdi3>:
  801ba8:	55                   	push   %ebp
  801ba9:	57                   	push   %edi
  801baa:	56                   	push   %esi
  801bab:	53                   	push   %ebx
  801bac:	83 ec 1c             	sub    $0x1c,%esp
  801baf:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  801bb3:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  801bb7:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801bbb:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801bbf:	89 ca                	mov    %ecx,%edx
  801bc1:	89 f8                	mov    %edi,%eax
  801bc3:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  801bc7:	85 f6                	test   %esi,%esi
  801bc9:	75 2d                	jne    801bf8 <__udivdi3+0x50>
  801bcb:	39 cf                	cmp    %ecx,%edi
  801bcd:	77 65                	ja     801c34 <__udivdi3+0x8c>
  801bcf:	89 fd                	mov    %edi,%ebp
  801bd1:	85 ff                	test   %edi,%edi
  801bd3:	75 0b                	jne    801be0 <__udivdi3+0x38>
  801bd5:	b8 01 00 00 00       	mov    $0x1,%eax
  801bda:	31 d2                	xor    %edx,%edx
  801bdc:	f7 f7                	div    %edi
  801bde:	89 c5                	mov    %eax,%ebp
  801be0:	31 d2                	xor    %edx,%edx
  801be2:	89 c8                	mov    %ecx,%eax
  801be4:	f7 f5                	div    %ebp
  801be6:	89 c1                	mov    %eax,%ecx
  801be8:	89 d8                	mov    %ebx,%eax
  801bea:	f7 f5                	div    %ebp
  801bec:	89 cf                	mov    %ecx,%edi
  801bee:	89 fa                	mov    %edi,%edx
  801bf0:	83 c4 1c             	add    $0x1c,%esp
  801bf3:	5b                   	pop    %ebx
  801bf4:	5e                   	pop    %esi
  801bf5:	5f                   	pop    %edi
  801bf6:	5d                   	pop    %ebp
  801bf7:	c3                   	ret    
  801bf8:	39 ce                	cmp    %ecx,%esi
  801bfa:	77 28                	ja     801c24 <__udivdi3+0x7c>
  801bfc:	0f bd fe             	bsr    %esi,%edi
  801bff:	83 f7 1f             	xor    $0x1f,%edi
  801c02:	75 40                	jne    801c44 <__udivdi3+0x9c>
  801c04:	39 ce                	cmp    %ecx,%esi
  801c06:	72 0a                	jb     801c12 <__udivdi3+0x6a>
  801c08:	3b 44 24 08          	cmp    0x8(%esp),%eax
  801c0c:	0f 87 9e 00 00 00    	ja     801cb0 <__udivdi3+0x108>
  801c12:	b8 01 00 00 00       	mov    $0x1,%eax
  801c17:	89 fa                	mov    %edi,%edx
  801c19:	83 c4 1c             	add    $0x1c,%esp
  801c1c:	5b                   	pop    %ebx
  801c1d:	5e                   	pop    %esi
  801c1e:	5f                   	pop    %edi
  801c1f:	5d                   	pop    %ebp
  801c20:	c3                   	ret    
  801c21:	8d 76 00             	lea    0x0(%esi),%esi
  801c24:	31 ff                	xor    %edi,%edi
  801c26:	31 c0                	xor    %eax,%eax
  801c28:	89 fa                	mov    %edi,%edx
  801c2a:	83 c4 1c             	add    $0x1c,%esp
  801c2d:	5b                   	pop    %ebx
  801c2e:	5e                   	pop    %esi
  801c2f:	5f                   	pop    %edi
  801c30:	5d                   	pop    %ebp
  801c31:	c3                   	ret    
  801c32:	66 90                	xchg   %ax,%ax
  801c34:	89 d8                	mov    %ebx,%eax
  801c36:	f7 f7                	div    %edi
  801c38:	31 ff                	xor    %edi,%edi
  801c3a:	89 fa                	mov    %edi,%edx
  801c3c:	83 c4 1c             	add    $0x1c,%esp
  801c3f:	5b                   	pop    %ebx
  801c40:	5e                   	pop    %esi
  801c41:	5f                   	pop    %edi
  801c42:	5d                   	pop    %ebp
  801c43:	c3                   	ret    
  801c44:	bd 20 00 00 00       	mov    $0x20,%ebp
  801c49:	89 eb                	mov    %ebp,%ebx
  801c4b:	29 fb                	sub    %edi,%ebx
  801c4d:	89 f9                	mov    %edi,%ecx
  801c4f:	d3 e6                	shl    %cl,%esi
  801c51:	89 c5                	mov    %eax,%ebp
  801c53:	88 d9                	mov    %bl,%cl
  801c55:	d3 ed                	shr    %cl,%ebp
  801c57:	89 e9                	mov    %ebp,%ecx
  801c59:	09 f1                	or     %esi,%ecx
  801c5b:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  801c5f:	89 f9                	mov    %edi,%ecx
  801c61:	d3 e0                	shl    %cl,%eax
  801c63:	89 c5                	mov    %eax,%ebp
  801c65:	89 d6                	mov    %edx,%esi
  801c67:	88 d9                	mov    %bl,%cl
  801c69:	d3 ee                	shr    %cl,%esi
  801c6b:	89 f9                	mov    %edi,%ecx
  801c6d:	d3 e2                	shl    %cl,%edx
  801c6f:	8b 44 24 08          	mov    0x8(%esp),%eax
  801c73:	88 d9                	mov    %bl,%cl
  801c75:	d3 e8                	shr    %cl,%eax
  801c77:	09 c2                	or     %eax,%edx
  801c79:	89 d0                	mov    %edx,%eax
  801c7b:	89 f2                	mov    %esi,%edx
  801c7d:	f7 74 24 0c          	divl   0xc(%esp)
  801c81:	89 d6                	mov    %edx,%esi
  801c83:	89 c3                	mov    %eax,%ebx
  801c85:	f7 e5                	mul    %ebp
  801c87:	39 d6                	cmp    %edx,%esi
  801c89:	72 19                	jb     801ca4 <__udivdi3+0xfc>
  801c8b:	74 0b                	je     801c98 <__udivdi3+0xf0>
  801c8d:	89 d8                	mov    %ebx,%eax
  801c8f:	31 ff                	xor    %edi,%edi
  801c91:	e9 58 ff ff ff       	jmp    801bee <__udivdi3+0x46>
  801c96:	66 90                	xchg   %ax,%ax
  801c98:	8b 54 24 08          	mov    0x8(%esp),%edx
  801c9c:	89 f9                	mov    %edi,%ecx
  801c9e:	d3 e2                	shl    %cl,%edx
  801ca0:	39 c2                	cmp    %eax,%edx
  801ca2:	73 e9                	jae    801c8d <__udivdi3+0xe5>
  801ca4:	8d 43 ff             	lea    -0x1(%ebx),%eax
  801ca7:	31 ff                	xor    %edi,%edi
  801ca9:	e9 40 ff ff ff       	jmp    801bee <__udivdi3+0x46>
  801cae:	66 90                	xchg   %ax,%ax
  801cb0:	31 c0                	xor    %eax,%eax
  801cb2:	e9 37 ff ff ff       	jmp    801bee <__udivdi3+0x46>
  801cb7:	90                   	nop

00801cb8 <__umoddi3>:
  801cb8:	55                   	push   %ebp
  801cb9:	57                   	push   %edi
  801cba:	56                   	push   %esi
  801cbb:	53                   	push   %ebx
  801cbc:	83 ec 1c             	sub    $0x1c,%esp
  801cbf:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  801cc3:	8b 74 24 34          	mov    0x34(%esp),%esi
  801cc7:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801ccb:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  801ccf:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801cd3:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801cd7:	89 f3                	mov    %esi,%ebx
  801cd9:	89 fa                	mov    %edi,%edx
  801cdb:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801cdf:	89 34 24             	mov    %esi,(%esp)
  801ce2:	85 c0                	test   %eax,%eax
  801ce4:	75 1a                	jne    801d00 <__umoddi3+0x48>
  801ce6:	39 f7                	cmp    %esi,%edi
  801ce8:	0f 86 a2 00 00 00    	jbe    801d90 <__umoddi3+0xd8>
  801cee:	89 c8                	mov    %ecx,%eax
  801cf0:	89 f2                	mov    %esi,%edx
  801cf2:	f7 f7                	div    %edi
  801cf4:	89 d0                	mov    %edx,%eax
  801cf6:	31 d2                	xor    %edx,%edx
  801cf8:	83 c4 1c             	add    $0x1c,%esp
  801cfb:	5b                   	pop    %ebx
  801cfc:	5e                   	pop    %esi
  801cfd:	5f                   	pop    %edi
  801cfe:	5d                   	pop    %ebp
  801cff:	c3                   	ret    
  801d00:	39 f0                	cmp    %esi,%eax
  801d02:	0f 87 ac 00 00 00    	ja     801db4 <__umoddi3+0xfc>
  801d08:	0f bd e8             	bsr    %eax,%ebp
  801d0b:	83 f5 1f             	xor    $0x1f,%ebp
  801d0e:	0f 84 ac 00 00 00    	je     801dc0 <__umoddi3+0x108>
  801d14:	bf 20 00 00 00       	mov    $0x20,%edi
  801d19:	29 ef                	sub    %ebp,%edi
  801d1b:	89 fe                	mov    %edi,%esi
  801d1d:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801d21:	89 e9                	mov    %ebp,%ecx
  801d23:	d3 e0                	shl    %cl,%eax
  801d25:	89 d7                	mov    %edx,%edi
  801d27:	89 f1                	mov    %esi,%ecx
  801d29:	d3 ef                	shr    %cl,%edi
  801d2b:	09 c7                	or     %eax,%edi
  801d2d:	89 e9                	mov    %ebp,%ecx
  801d2f:	d3 e2                	shl    %cl,%edx
  801d31:	89 14 24             	mov    %edx,(%esp)
  801d34:	89 d8                	mov    %ebx,%eax
  801d36:	d3 e0                	shl    %cl,%eax
  801d38:	89 c2                	mov    %eax,%edx
  801d3a:	8b 44 24 08          	mov    0x8(%esp),%eax
  801d3e:	d3 e0                	shl    %cl,%eax
  801d40:	89 44 24 04          	mov    %eax,0x4(%esp)
  801d44:	8b 44 24 08          	mov    0x8(%esp),%eax
  801d48:	89 f1                	mov    %esi,%ecx
  801d4a:	d3 e8                	shr    %cl,%eax
  801d4c:	09 d0                	or     %edx,%eax
  801d4e:	d3 eb                	shr    %cl,%ebx
  801d50:	89 da                	mov    %ebx,%edx
  801d52:	f7 f7                	div    %edi
  801d54:	89 d3                	mov    %edx,%ebx
  801d56:	f7 24 24             	mull   (%esp)
  801d59:	89 c6                	mov    %eax,%esi
  801d5b:	89 d1                	mov    %edx,%ecx
  801d5d:	39 d3                	cmp    %edx,%ebx
  801d5f:	0f 82 87 00 00 00    	jb     801dec <__umoddi3+0x134>
  801d65:	0f 84 91 00 00 00    	je     801dfc <__umoddi3+0x144>
  801d6b:	8b 54 24 04          	mov    0x4(%esp),%edx
  801d6f:	29 f2                	sub    %esi,%edx
  801d71:	19 cb                	sbb    %ecx,%ebx
  801d73:	89 d8                	mov    %ebx,%eax
  801d75:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  801d79:	d3 e0                	shl    %cl,%eax
  801d7b:	89 e9                	mov    %ebp,%ecx
  801d7d:	d3 ea                	shr    %cl,%edx
  801d7f:	09 d0                	or     %edx,%eax
  801d81:	89 e9                	mov    %ebp,%ecx
  801d83:	d3 eb                	shr    %cl,%ebx
  801d85:	89 da                	mov    %ebx,%edx
  801d87:	83 c4 1c             	add    $0x1c,%esp
  801d8a:	5b                   	pop    %ebx
  801d8b:	5e                   	pop    %esi
  801d8c:	5f                   	pop    %edi
  801d8d:	5d                   	pop    %ebp
  801d8e:	c3                   	ret    
  801d8f:	90                   	nop
  801d90:	89 fd                	mov    %edi,%ebp
  801d92:	85 ff                	test   %edi,%edi
  801d94:	75 0b                	jne    801da1 <__umoddi3+0xe9>
  801d96:	b8 01 00 00 00       	mov    $0x1,%eax
  801d9b:	31 d2                	xor    %edx,%edx
  801d9d:	f7 f7                	div    %edi
  801d9f:	89 c5                	mov    %eax,%ebp
  801da1:	89 f0                	mov    %esi,%eax
  801da3:	31 d2                	xor    %edx,%edx
  801da5:	f7 f5                	div    %ebp
  801da7:	89 c8                	mov    %ecx,%eax
  801da9:	f7 f5                	div    %ebp
  801dab:	89 d0                	mov    %edx,%eax
  801dad:	e9 44 ff ff ff       	jmp    801cf6 <__umoddi3+0x3e>
  801db2:	66 90                	xchg   %ax,%ax
  801db4:	89 c8                	mov    %ecx,%eax
  801db6:	89 f2                	mov    %esi,%edx
  801db8:	83 c4 1c             	add    $0x1c,%esp
  801dbb:	5b                   	pop    %ebx
  801dbc:	5e                   	pop    %esi
  801dbd:	5f                   	pop    %edi
  801dbe:	5d                   	pop    %ebp
  801dbf:	c3                   	ret    
  801dc0:	3b 04 24             	cmp    (%esp),%eax
  801dc3:	72 06                	jb     801dcb <__umoddi3+0x113>
  801dc5:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  801dc9:	77 0f                	ja     801dda <__umoddi3+0x122>
  801dcb:	89 f2                	mov    %esi,%edx
  801dcd:	29 f9                	sub    %edi,%ecx
  801dcf:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  801dd3:	89 14 24             	mov    %edx,(%esp)
  801dd6:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801dda:	8b 44 24 04          	mov    0x4(%esp),%eax
  801dde:	8b 14 24             	mov    (%esp),%edx
  801de1:	83 c4 1c             	add    $0x1c,%esp
  801de4:	5b                   	pop    %ebx
  801de5:	5e                   	pop    %esi
  801de6:	5f                   	pop    %edi
  801de7:	5d                   	pop    %ebp
  801de8:	c3                   	ret    
  801de9:	8d 76 00             	lea    0x0(%esi),%esi
  801dec:	2b 04 24             	sub    (%esp),%eax
  801def:	19 fa                	sbb    %edi,%edx
  801df1:	89 d1                	mov    %edx,%ecx
  801df3:	89 c6                	mov    %eax,%esi
  801df5:	e9 71 ff ff ff       	jmp    801d6b <__umoddi3+0xb3>
  801dfa:	66 90                	xchg   %ax,%ax
  801dfc:	39 44 24 04          	cmp    %eax,0x4(%esp)
  801e00:	72 ea                	jb     801dec <__umoddi3+0x134>
  801e02:	89 d9                	mov    %ebx,%ecx
  801e04:	e9 62 ff ff ff       	jmp    801d6b <__umoddi3+0xb3>
