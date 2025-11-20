
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
  800044:	e8 da 17 00 00       	call   801823 <sys_getenvid>
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
  800078:	e8 f5 19 00 00       	call   801a72 <sys_utilities>
  80007d:	83 c4 10             	add    $0x10,%esp

	//wait for a while
	env_sleep(RAND(1000, 5000));
  800080:	8d 45 d8             	lea    -0x28(%ebp),%eax
  800083:	83 ec 0c             	sub    $0xc,%esp
  800086:	50                   	push   %eax
  800087:	e8 fc 17 00 00       	call   801888 <sys_get_virtual_time>
  80008c:	83 c4 0c             	add    $0xc,%esp
  80008f:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800092:	b9 a0 0f 00 00       	mov    $0xfa0,%ecx
  800097:	ba 00 00 00 00       	mov    $0x0,%edx
  80009c:	f7 f1                	div    %ecx
  80009e:	89 d0                	mov    %edx,%eax
  8000a0:	05 e8 03 00 00       	add    $0x3e8,%eax
  8000a5:	83 ec 0c             	sub    $0xc,%esp
  8000a8:	50                   	push   %eax
  8000a9:	e8 50 1a 00 00       	call   801afe <env_sleep>
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
  8000ef:	e8 7e 19 00 00       	call   801a72 <sys_utilities>
  8000f4:	83 c4 10             	add    $0x10,%esp
	int numOfWakenupProcesses = gettst() ;
  8000f7:	e8 98 18 00 00       	call   801994 <gettst>
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
  800143:	e8 2a 19 00 00       	call   801a72 <sys_utilities>
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
  80016d:	e8 2f 02 00 00       	call   8003a1 <_panic>
	}

	//indicates wakenup
	inctst();
  800172:	e8 03 18 00 00       	call   80197a <inctst>

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
  8001ac:	e8 c1 18 00 00       	call   801a72 <sys_utilities>
  8001b1:	83 c4 10             	add    $0x10,%esp

	cprintf_colored(TEXT_light_magenta, ">>> Slave %d is Finished\n", envID);
  8001b4:	83 ec 04             	sub    $0x4,%esp
  8001b7:	ff 75 e4             	pushl  -0x1c(%ebp)
  8001ba:	68 87 1e 80 00       	push   $0x801e87
  8001bf:	6a 0d                	push   $0xd
  8001c1:	e8 d6 04 00 00       	call   80069c <cprintf_colored>
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
  8001e5:	e8 52 16 00 00       	call   80183c <sys_getenvindex>
  8001ea:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	myEnv = &(envs[envIndex]);
  8001ed:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8001f0:	89 d0                	mov    %edx,%eax
  8001f2:	c1 e0 06             	shl    $0x6,%eax
  8001f5:	29 d0                	sub    %edx,%eax
  8001f7:	c1 e0 02             	shl    $0x2,%eax
  8001fa:	01 d0                	add    %edx,%eax
  8001fc:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800203:	01 c8                	add    %ecx,%eax
  800205:	c1 e0 03             	shl    $0x3,%eax
  800208:	01 d0                	add    %edx,%eax
  80020a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800211:	29 c2                	sub    %eax,%edx
  800213:	8d 04 95 00 00 00 00 	lea    0x0(,%edx,4),%eax
  80021a:	89 c2                	mov    %eax,%edx
  80021c:	8d 82 00 00 c0 ee    	lea    -0x11400000(%edx),%eax
  800222:	a3 20 30 80 00       	mov    %eax,0x803020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800227:	a1 20 30 80 00       	mov    0x803020,%eax
  80022c:	8a 40 20             	mov    0x20(%eax),%al
  80022f:	84 c0                	test   %al,%al
  800231:	74 0d                	je     800240 <libmain+0x64>
		binaryname = myEnv->prog_name;
  800233:	a1 20 30 80 00       	mov    0x803020,%eax
  800238:	83 c0 20             	add    $0x20,%eax
  80023b:	a3 04 30 80 00       	mov    %eax,0x803004

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800240:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800244:	7e 0a                	jle    800250 <libmain+0x74>
		binaryname = argv[0];
  800246:	8b 45 0c             	mov    0xc(%ebp),%eax
  800249:	8b 00                	mov    (%eax),%eax
  80024b:	a3 04 30 80 00       	mov    %eax,0x803004

	// call user main routine
	_main(argc, argv);
  800250:	83 ec 08             	sub    $0x8,%esp
  800253:	ff 75 0c             	pushl  0xc(%ebp)
  800256:	ff 75 08             	pushl  0x8(%ebp)
  800259:	e8 da fd ff ff       	call   800038 <_main>
  80025e:	83 c4 10             	add    $0x10,%esp

	if (printStats)
  800261:	a1 00 30 80 00       	mov    0x803000,%eax
  800266:	85 c0                	test   %eax,%eax
  800268:	0f 84 01 01 00 00    	je     80036f <libmain+0x193>
	{
		char isOPTReplCmd[100] = "__IsOPTRepl__" ;
  80026e:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  800274:	bb 9c 20 80 00       	mov    $0x80209c,%ebx
  800279:	ba 0e 00 00 00       	mov    $0xe,%edx
  80027e:	89 c7                	mov    %eax,%edi
  800280:	89 de                	mov    %ebx,%esi
  800282:	89 d1                	mov    %edx,%ecx
  800284:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  800286:	8d 55 8a             	lea    -0x76(%ebp),%edx
  800289:	b9 56 00 00 00       	mov    $0x56,%ecx
  80028e:	b0 00                	mov    $0x0,%al
  800290:	89 d7                	mov    %edx,%edi
  800292:	f3 aa                	rep stos %al,%es:(%edi)
		int isOPTRepl = 0;
  800294:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
		sys_utilities(isOPTReplCmd, (uint32)(&isOPTRepl));
  80029b:	8d 45 e0             	lea    -0x20(%ebp),%eax
  80029e:	83 ec 08             	sub    $0x8,%esp
  8002a1:	50                   	push   %eax
  8002a2:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  8002a8:	50                   	push   %eax
  8002a9:	e8 c4 17 00 00       	call   801a72 <sys_utilities>
  8002ae:	83 c4 10             	add    $0x10,%esp

		sys_lock_cons();
  8002b1:	e8 0d 13 00 00       	call   8015c3 <sys_lock_cons>
		{
			cprintf("**************************************\n");
  8002b6:	83 ec 0c             	sub    $0xc,%esp
  8002b9:	68 bc 1f 80 00       	push   $0x801fbc
  8002be:	e8 ac 03 00 00       	call   80066f <cprintf>
  8002c3:	83 c4 10             	add    $0x10,%esp
			if (isOPTRepl)
  8002c6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8002c9:	85 c0                	test   %eax,%eax
  8002cb:	74 18                	je     8002e5 <libmain+0x109>
			{
				cprintf("OPTIMAL number of page faults = %d\n", sys_get_optimal_num_faults());
  8002cd:	e8 be 17 00 00       	call   801a90 <sys_get_optimal_num_faults>
  8002d2:	83 ec 08             	sub    $0x8,%esp
  8002d5:	50                   	push   %eax
  8002d6:	68 e4 1f 80 00       	push   $0x801fe4
  8002db:	e8 8f 03 00 00       	call   80066f <cprintf>
  8002e0:	83 c4 10             	add    $0x10,%esp
  8002e3:	eb 59                	jmp    80033e <libmain+0x162>
			}
			else
			{
				cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8002e5:	a1 20 30 80 00       	mov    0x803020,%eax
  8002ea:	8b 90 50 da 01 00    	mov    0x1da50(%eax),%edx
  8002f0:	a1 20 30 80 00       	mov    0x803020,%eax
  8002f5:	8b 80 40 da 01 00    	mov    0x1da40(%eax),%eax
  8002fb:	83 ec 04             	sub    $0x4,%esp
  8002fe:	52                   	push   %edx
  8002ff:	50                   	push   %eax
  800300:	68 08 20 80 00       	push   $0x802008
  800305:	e8 65 03 00 00       	call   80066f <cprintf>
  80030a:	83 c4 10             	add    $0x10,%esp
				cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  80030d:	a1 20 30 80 00       	mov    0x803020,%eax
  800312:	8b 88 64 da 01 00    	mov    0x1da64(%eax),%ecx
  800318:	a1 20 30 80 00       	mov    0x803020,%eax
  80031d:	8b 90 60 da 01 00    	mov    0x1da60(%eax),%edx
  800323:	a1 20 30 80 00       	mov    0x803020,%eax
  800328:	8b 80 5c da 01 00    	mov    0x1da5c(%eax),%eax
  80032e:	51                   	push   %ecx
  80032f:	52                   	push   %edx
  800330:	50                   	push   %eax
  800331:	68 30 20 80 00       	push   $0x802030
  800336:	e8 34 03 00 00       	call   80066f <cprintf>
  80033b:	83 c4 10             	add    $0x10,%esp
			}
			//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
			cprintf("Num of clocks = %d\n", myEnv->nClocks);
  80033e:	a1 20 30 80 00       	mov    0x803020,%eax
  800343:	8b 80 68 da 01 00    	mov    0x1da68(%eax),%eax
  800349:	83 ec 08             	sub    $0x8,%esp
  80034c:	50                   	push   %eax
  80034d:	68 88 20 80 00       	push   $0x802088
  800352:	e8 18 03 00 00       	call   80066f <cprintf>
  800357:	83 c4 10             	add    $0x10,%esp
			cprintf("**************************************\n");
  80035a:	83 ec 0c             	sub    $0xc,%esp
  80035d:	68 bc 1f 80 00       	push   $0x801fbc
  800362:	e8 08 03 00 00       	call   80066f <cprintf>
  800367:	83 c4 10             	add    $0x10,%esp
		}
		sys_unlock_cons();
  80036a:	e8 6e 12 00 00       	call   8015dd <sys_unlock_cons>
	}

	// exit gracefully
	exit();
  80036f:	e8 1f 00 00 00       	call   800393 <exit>
}
  800374:	90                   	nop
  800375:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800378:	5b                   	pop    %ebx
  800379:	5e                   	pop    %esi
  80037a:	5f                   	pop    %edi
  80037b:	5d                   	pop    %ebp
  80037c:	c3                   	ret    

0080037d <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  80037d:	55                   	push   %ebp
  80037e:	89 e5                	mov    %esp,%ebp
  800380:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800383:	83 ec 0c             	sub    $0xc,%esp
  800386:	6a 00                	push   $0x0
  800388:	e8 7b 14 00 00       	call   801808 <sys_destroy_env>
  80038d:	83 c4 10             	add    $0x10,%esp
}
  800390:	90                   	nop
  800391:	c9                   	leave  
  800392:	c3                   	ret    

00800393 <exit>:

void
exit(void)
{
  800393:	55                   	push   %ebp
  800394:	89 e5                	mov    %esp,%ebp
  800396:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  800399:	e8 d0 14 00 00       	call   80186e <sys_exit_env>
}
  80039e:	90                   	nop
  80039f:	c9                   	leave  
  8003a0:	c3                   	ret    

008003a1 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  8003a1:	55                   	push   %ebp
  8003a2:	89 e5                	mov    %esp,%ebp
  8003a4:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  8003a7:	8d 45 10             	lea    0x10(%ebp),%eax
  8003aa:	83 c0 04             	add    $0x4,%eax
  8003ad:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  8003b0:	a1 18 b1 81 00       	mov    0x81b118,%eax
  8003b5:	85 c0                	test   %eax,%eax
  8003b7:	74 16                	je     8003cf <_panic+0x2e>
		cprintf("%s: ", argv0);
  8003b9:	a1 18 b1 81 00       	mov    0x81b118,%eax
  8003be:	83 ec 08             	sub    $0x8,%esp
  8003c1:	50                   	push   %eax
  8003c2:	68 00 21 80 00       	push   $0x802100
  8003c7:	e8 a3 02 00 00       	call   80066f <cprintf>
  8003cc:	83 c4 10             	add    $0x10,%esp
	cprintf_colored(TEXT_PANIC_CLR, "user [EVAL_FINAL]panic in %s at %s:%d: ", binaryname, file, line);
  8003cf:	a1 04 30 80 00       	mov    0x803004,%eax
  8003d4:	83 ec 0c             	sub    $0xc,%esp
  8003d7:	ff 75 0c             	pushl  0xc(%ebp)
  8003da:	ff 75 08             	pushl  0x8(%ebp)
  8003dd:	50                   	push   %eax
  8003de:	68 08 21 80 00       	push   $0x802108
  8003e3:	6a 74                	push   $0x74
  8003e5:	e8 b2 02 00 00       	call   80069c <cprintf_colored>
  8003ea:	83 c4 20             	add    $0x20,%esp
	vcprintf(fmt, ap);
  8003ed:	8b 45 10             	mov    0x10(%ebp),%eax
  8003f0:	83 ec 08             	sub    $0x8,%esp
  8003f3:	ff 75 f4             	pushl  -0xc(%ebp)
  8003f6:	50                   	push   %eax
  8003f7:	e8 04 02 00 00       	call   800600 <vcprintf>
  8003fc:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  8003ff:	83 ec 08             	sub    $0x8,%esp
  800402:	6a 00                	push   $0x0
  800404:	68 30 21 80 00       	push   $0x802130
  800409:	e8 f2 01 00 00       	call   800600 <vcprintf>
  80040e:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  800411:	e8 7d ff ff ff       	call   800393 <exit>

	// should not return here
	while (1) ;
  800416:	eb fe                	jmp    800416 <_panic+0x75>

00800418 <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  800418:	55                   	push   %ebp
  800419:	89 e5                	mov    %esp,%ebp
  80041b:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  80041e:	a1 20 30 80 00       	mov    0x803020,%eax
  800423:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  800429:	8b 45 0c             	mov    0xc(%ebp),%eax
  80042c:	39 c2                	cmp    %eax,%edx
  80042e:	74 14                	je     800444 <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  800430:	83 ec 04             	sub    $0x4,%esp
  800433:	68 34 21 80 00       	push   $0x802134
  800438:	6a 26                	push   $0x26
  80043a:	68 80 21 80 00       	push   $0x802180
  80043f:	e8 5d ff ff ff       	call   8003a1 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  800444:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  80044b:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800452:	e9 c5 00 00 00       	jmp    80051c <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  800457:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80045a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800461:	8b 45 08             	mov    0x8(%ebp),%eax
  800464:	01 d0                	add    %edx,%eax
  800466:	8b 00                	mov    (%eax),%eax
  800468:	85 c0                	test   %eax,%eax
  80046a:	75 08                	jne    800474 <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  80046c:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  80046f:	e9 a5 00 00 00       	jmp    800519 <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  800474:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80047b:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  800482:	eb 69                	jmp    8004ed <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  800484:	a1 20 30 80 00       	mov    0x803020,%eax
  800489:	8b 88 38 da 01 00    	mov    0x1da38(%eax),%ecx
  80048f:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800492:	89 d0                	mov    %edx,%eax
  800494:	01 c0                	add    %eax,%eax
  800496:	01 d0                	add    %edx,%eax
  800498:	c1 e0 03             	shl    $0x3,%eax
  80049b:	01 c8                	add    %ecx,%eax
  80049d:	8a 40 04             	mov    0x4(%eax),%al
  8004a0:	84 c0                	test   %al,%al
  8004a2:	75 46                	jne    8004ea <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8004a4:	a1 20 30 80 00       	mov    0x803020,%eax
  8004a9:	8b 88 38 da 01 00    	mov    0x1da38(%eax),%ecx
  8004af:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8004b2:	89 d0                	mov    %edx,%eax
  8004b4:	01 c0                	add    %eax,%eax
  8004b6:	01 d0                	add    %edx,%eax
  8004b8:	c1 e0 03             	shl    $0x3,%eax
  8004bb:	01 c8                	add    %ecx,%eax
  8004bd:	8b 00                	mov    (%eax),%eax
  8004bf:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8004c2:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8004c5:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8004ca:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  8004cc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8004cf:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8004d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8004d9:	01 c8                	add    %ecx,%eax
  8004db:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8004dd:	39 c2                	cmp    %eax,%edx
  8004df:	75 09                	jne    8004ea <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  8004e1:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  8004e8:	eb 15                	jmp    8004ff <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8004ea:	ff 45 e8             	incl   -0x18(%ebp)
  8004ed:	a1 20 30 80 00       	mov    0x803020,%eax
  8004f2:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  8004f8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8004fb:	39 c2                	cmp    %eax,%edx
  8004fd:	77 85                	ja     800484 <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  8004ff:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800503:	75 14                	jne    800519 <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  800505:	83 ec 04             	sub    $0x4,%esp
  800508:	68 8c 21 80 00       	push   $0x80218c
  80050d:	6a 3a                	push   $0x3a
  80050f:	68 80 21 80 00       	push   $0x802180
  800514:	e8 88 fe ff ff       	call   8003a1 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  800519:	ff 45 f0             	incl   -0x10(%ebp)
  80051c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80051f:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800522:	0f 8c 2f ff ff ff    	jl     800457 <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  800528:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80052f:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800536:	eb 26                	jmp    80055e <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  800538:	a1 20 30 80 00       	mov    0x803020,%eax
  80053d:	8b 88 38 da 01 00    	mov    0x1da38(%eax),%ecx
  800543:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800546:	89 d0                	mov    %edx,%eax
  800548:	01 c0                	add    %eax,%eax
  80054a:	01 d0                	add    %edx,%eax
  80054c:	c1 e0 03             	shl    $0x3,%eax
  80054f:	01 c8                	add    %ecx,%eax
  800551:	8a 40 04             	mov    0x4(%eax),%al
  800554:	3c 01                	cmp    $0x1,%al
  800556:	75 03                	jne    80055b <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  800558:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80055b:	ff 45 e0             	incl   -0x20(%ebp)
  80055e:	a1 20 30 80 00       	mov    0x803020,%eax
  800563:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  800569:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80056c:	39 c2                	cmp    %eax,%edx
  80056e:	77 c8                	ja     800538 <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  800570:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800573:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800576:	74 14                	je     80058c <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  800578:	83 ec 04             	sub    $0x4,%esp
  80057b:	68 e0 21 80 00       	push   $0x8021e0
  800580:	6a 44                	push   $0x44
  800582:	68 80 21 80 00       	push   $0x802180
  800587:	e8 15 fe ff ff       	call   8003a1 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  80058c:	90                   	nop
  80058d:	c9                   	leave  
  80058e:	c3                   	ret    

0080058f <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  80058f:	55                   	push   %ebp
  800590:	89 e5                	mov    %esp,%ebp
  800592:	53                   	push   %ebx
  800593:	83 ec 04             	sub    $0x4,%esp
	b->buf[b->idx++] = ch;
  800596:	8b 45 0c             	mov    0xc(%ebp),%eax
  800599:	8b 00                	mov    (%eax),%eax
  80059b:	8d 48 01             	lea    0x1(%eax),%ecx
  80059e:	8b 55 0c             	mov    0xc(%ebp),%edx
  8005a1:	89 0a                	mov    %ecx,(%edx)
  8005a3:	8b 55 08             	mov    0x8(%ebp),%edx
  8005a6:	88 d1                	mov    %dl,%cl
  8005a8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8005ab:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  8005af:	8b 45 0c             	mov    0xc(%ebp),%eax
  8005b2:	8b 00                	mov    (%eax),%eax
  8005b4:	3d ff 00 00 00       	cmp    $0xff,%eax
  8005b9:	75 30                	jne    8005eb <putch+0x5c>
		sys_cputs(b->buf, b->idx, printProgName, curTextClr);
  8005bb:	8b 15 1c b1 81 00    	mov    0x81b11c,%edx
  8005c1:	a0 44 30 80 00       	mov    0x803044,%al
  8005c6:	0f b6 c0             	movzbl %al,%eax
  8005c9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8005cc:	8b 09                	mov    (%ecx),%ecx
  8005ce:	89 cb                	mov    %ecx,%ebx
  8005d0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8005d3:	83 c1 08             	add    $0x8,%ecx
  8005d6:	52                   	push   %edx
  8005d7:	50                   	push   %eax
  8005d8:	53                   	push   %ebx
  8005d9:	51                   	push   %ecx
  8005da:	e8 a0 0f 00 00       	call   80157f <sys_cputs>
  8005df:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8005e2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8005e5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8005eb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8005ee:	8b 40 04             	mov    0x4(%eax),%eax
  8005f1:	8d 50 01             	lea    0x1(%eax),%edx
  8005f4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8005f7:	89 50 04             	mov    %edx,0x4(%eax)
}
  8005fa:	90                   	nop
  8005fb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8005fe:	c9                   	leave  
  8005ff:	c3                   	ret    

00800600 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800600:	55                   	push   %ebp
  800601:	89 e5                	mov    %esp,%ebp
  800603:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800609:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800610:	00 00 00 
	b.cnt = 0;
  800613:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  80061a:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  80061d:	ff 75 0c             	pushl  0xc(%ebp)
  800620:	ff 75 08             	pushl  0x8(%ebp)
  800623:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800629:	50                   	push   %eax
  80062a:	68 8f 05 80 00       	push   $0x80058f
  80062f:	e8 5a 02 00 00       	call   80088e <vprintfmt>
  800634:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName, curTextClr);
  800637:	8b 15 1c b1 81 00    	mov    0x81b11c,%edx
  80063d:	a0 44 30 80 00       	mov    0x803044,%al
  800642:	0f b6 c0             	movzbl %al,%eax
  800645:	8b 8d f0 fe ff ff    	mov    -0x110(%ebp),%ecx
  80064b:	52                   	push   %edx
  80064c:	50                   	push   %eax
  80064d:	51                   	push   %ecx
  80064e:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800654:	83 c0 08             	add    $0x8,%eax
  800657:	50                   	push   %eax
  800658:	e8 22 0f 00 00       	call   80157f <sys_cputs>
  80065d:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800660:	c6 05 44 30 80 00 00 	movb   $0x0,0x803044
	return b.cnt;
  800667:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  80066d:	c9                   	leave  
  80066e:	c3                   	ret    

0080066f <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  80066f:	55                   	push   %ebp
  800670:	89 e5                	mov    %esp,%ebp
  800672:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800675:	c6 05 44 30 80 00 01 	movb   $0x1,0x803044
	va_start(ap, fmt);
  80067c:	8d 45 0c             	lea    0xc(%ebp),%eax
  80067f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800682:	8b 45 08             	mov    0x8(%ebp),%eax
  800685:	83 ec 08             	sub    $0x8,%esp
  800688:	ff 75 f4             	pushl  -0xc(%ebp)
  80068b:	50                   	push   %eax
  80068c:	e8 6f ff ff ff       	call   800600 <vcprintf>
  800691:	83 c4 10             	add    $0x10,%esp
  800694:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800697:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80069a:	c9                   	leave  
  80069b:	c3                   	ret    

0080069c <cprintf_colored>:

// *************** This text coloring feature is implemented by *************
// ********** Abd-Alrahman Zedan From Team Frozen-Bytes - FCIS'24-25 ********
int cprintf_colored(int textClr, const char *fmt, ...) {
  80069c:	55                   	push   %ebp
  80069d:	89 e5                	mov    %esp,%ebp
  80069f:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  8006a2:	c6 05 44 30 80 00 01 	movb   $0x1,0x803044
	curTextClr = (textClr << 8) ; //set text color by the given value
  8006a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8006ac:	c1 e0 08             	shl    $0x8,%eax
  8006af:	a3 1c b1 81 00       	mov    %eax,0x81b11c
	va_start(ap, fmt);
  8006b4:	8d 45 0c             	lea    0xc(%ebp),%eax
  8006b7:	83 c0 04             	add    $0x4,%eax
  8006ba:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8006bd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006c0:	83 ec 08             	sub    $0x8,%esp
  8006c3:	ff 75 f4             	pushl  -0xc(%ebp)
  8006c6:	50                   	push   %eax
  8006c7:	e8 34 ff ff ff       	call   800600 <vcprintf>
  8006cc:	83 c4 10             	add    $0x10,%esp
  8006cf:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);
	curTextClr = TEXT_DEFAULT_CLR; //restore default color
  8006d2:	c7 05 1c b1 81 00 00 	movl   $0x700,0x81b11c
  8006d9:	07 00 00 

	return cnt;
  8006dc:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8006df:	c9                   	leave  
  8006e0:	c3                   	ret    

008006e1 <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  8006e1:	55                   	push   %ebp
  8006e2:	89 e5                	mov    %esp,%ebp
  8006e4:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  8006e7:	e8 d7 0e 00 00       	call   8015c3 <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  8006ec:	8d 45 0c             	lea    0xc(%ebp),%eax
  8006ef:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  8006f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8006f5:	83 ec 08             	sub    $0x8,%esp
  8006f8:	ff 75 f4             	pushl  -0xc(%ebp)
  8006fb:	50                   	push   %eax
  8006fc:	e8 ff fe ff ff       	call   800600 <vcprintf>
  800701:	83 c4 10             	add    $0x10,%esp
  800704:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  800707:	e8 d1 0e 00 00       	call   8015dd <sys_unlock_cons>
	return cnt;
  80070c:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80070f:	c9                   	leave  
  800710:	c3                   	ret    

00800711 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800711:	55                   	push   %ebp
  800712:	89 e5                	mov    %esp,%ebp
  800714:	53                   	push   %ebx
  800715:	83 ec 14             	sub    $0x14,%esp
  800718:	8b 45 10             	mov    0x10(%ebp),%eax
  80071b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80071e:	8b 45 14             	mov    0x14(%ebp),%eax
  800721:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800724:	8b 45 18             	mov    0x18(%ebp),%eax
  800727:	ba 00 00 00 00       	mov    $0x0,%edx
  80072c:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  80072f:	77 55                	ja     800786 <printnum+0x75>
  800731:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800734:	72 05                	jb     80073b <printnum+0x2a>
  800736:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800739:	77 4b                	ja     800786 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  80073b:	8b 45 1c             	mov    0x1c(%ebp),%eax
  80073e:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800741:	8b 45 18             	mov    0x18(%ebp),%eax
  800744:	ba 00 00 00 00       	mov    $0x0,%edx
  800749:	52                   	push   %edx
  80074a:	50                   	push   %eax
  80074b:	ff 75 f4             	pushl  -0xc(%ebp)
  80074e:	ff 75 f0             	pushl  -0x10(%ebp)
  800751:	e8 66 14 00 00       	call   801bbc <__udivdi3>
  800756:	83 c4 10             	add    $0x10,%esp
  800759:	83 ec 04             	sub    $0x4,%esp
  80075c:	ff 75 20             	pushl  0x20(%ebp)
  80075f:	53                   	push   %ebx
  800760:	ff 75 18             	pushl  0x18(%ebp)
  800763:	52                   	push   %edx
  800764:	50                   	push   %eax
  800765:	ff 75 0c             	pushl  0xc(%ebp)
  800768:	ff 75 08             	pushl  0x8(%ebp)
  80076b:	e8 a1 ff ff ff       	call   800711 <printnum>
  800770:	83 c4 20             	add    $0x20,%esp
  800773:	eb 1a                	jmp    80078f <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800775:	83 ec 08             	sub    $0x8,%esp
  800778:	ff 75 0c             	pushl  0xc(%ebp)
  80077b:	ff 75 20             	pushl  0x20(%ebp)
  80077e:	8b 45 08             	mov    0x8(%ebp),%eax
  800781:	ff d0                	call   *%eax
  800783:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800786:	ff 4d 1c             	decl   0x1c(%ebp)
  800789:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  80078d:	7f e6                	jg     800775 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80078f:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800792:	bb 00 00 00 00       	mov    $0x0,%ebx
  800797:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80079a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80079d:	53                   	push   %ebx
  80079e:	51                   	push   %ecx
  80079f:	52                   	push   %edx
  8007a0:	50                   	push   %eax
  8007a1:	e8 26 15 00 00       	call   801ccc <__umoddi3>
  8007a6:	83 c4 10             	add    $0x10,%esp
  8007a9:	05 54 24 80 00       	add    $0x802454,%eax
  8007ae:	8a 00                	mov    (%eax),%al
  8007b0:	0f be c0             	movsbl %al,%eax
  8007b3:	83 ec 08             	sub    $0x8,%esp
  8007b6:	ff 75 0c             	pushl  0xc(%ebp)
  8007b9:	50                   	push   %eax
  8007ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8007bd:	ff d0                	call   *%eax
  8007bf:	83 c4 10             	add    $0x10,%esp
}
  8007c2:	90                   	nop
  8007c3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8007c6:	c9                   	leave  
  8007c7:	c3                   	ret    

008007c8 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8007c8:	55                   	push   %ebp
  8007c9:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8007cb:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8007cf:	7e 1c                	jle    8007ed <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  8007d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8007d4:	8b 00                	mov    (%eax),%eax
  8007d6:	8d 50 08             	lea    0x8(%eax),%edx
  8007d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8007dc:	89 10                	mov    %edx,(%eax)
  8007de:	8b 45 08             	mov    0x8(%ebp),%eax
  8007e1:	8b 00                	mov    (%eax),%eax
  8007e3:	83 e8 08             	sub    $0x8,%eax
  8007e6:	8b 50 04             	mov    0x4(%eax),%edx
  8007e9:	8b 00                	mov    (%eax),%eax
  8007eb:	eb 40                	jmp    80082d <getuint+0x65>
	else if (lflag)
  8007ed:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8007f1:	74 1e                	je     800811 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  8007f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8007f6:	8b 00                	mov    (%eax),%eax
  8007f8:	8d 50 04             	lea    0x4(%eax),%edx
  8007fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8007fe:	89 10                	mov    %edx,(%eax)
  800800:	8b 45 08             	mov    0x8(%ebp),%eax
  800803:	8b 00                	mov    (%eax),%eax
  800805:	83 e8 04             	sub    $0x4,%eax
  800808:	8b 00                	mov    (%eax),%eax
  80080a:	ba 00 00 00 00       	mov    $0x0,%edx
  80080f:	eb 1c                	jmp    80082d <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800811:	8b 45 08             	mov    0x8(%ebp),%eax
  800814:	8b 00                	mov    (%eax),%eax
  800816:	8d 50 04             	lea    0x4(%eax),%edx
  800819:	8b 45 08             	mov    0x8(%ebp),%eax
  80081c:	89 10                	mov    %edx,(%eax)
  80081e:	8b 45 08             	mov    0x8(%ebp),%eax
  800821:	8b 00                	mov    (%eax),%eax
  800823:	83 e8 04             	sub    $0x4,%eax
  800826:	8b 00                	mov    (%eax),%eax
  800828:	ba 00 00 00 00       	mov    $0x0,%edx
}
  80082d:	5d                   	pop    %ebp
  80082e:	c3                   	ret    

0080082f <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  80082f:	55                   	push   %ebp
  800830:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800832:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800836:	7e 1c                	jle    800854 <getint+0x25>
		return va_arg(*ap, long long);
  800838:	8b 45 08             	mov    0x8(%ebp),%eax
  80083b:	8b 00                	mov    (%eax),%eax
  80083d:	8d 50 08             	lea    0x8(%eax),%edx
  800840:	8b 45 08             	mov    0x8(%ebp),%eax
  800843:	89 10                	mov    %edx,(%eax)
  800845:	8b 45 08             	mov    0x8(%ebp),%eax
  800848:	8b 00                	mov    (%eax),%eax
  80084a:	83 e8 08             	sub    $0x8,%eax
  80084d:	8b 50 04             	mov    0x4(%eax),%edx
  800850:	8b 00                	mov    (%eax),%eax
  800852:	eb 38                	jmp    80088c <getint+0x5d>
	else if (lflag)
  800854:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800858:	74 1a                	je     800874 <getint+0x45>
		return va_arg(*ap, long);
  80085a:	8b 45 08             	mov    0x8(%ebp),%eax
  80085d:	8b 00                	mov    (%eax),%eax
  80085f:	8d 50 04             	lea    0x4(%eax),%edx
  800862:	8b 45 08             	mov    0x8(%ebp),%eax
  800865:	89 10                	mov    %edx,(%eax)
  800867:	8b 45 08             	mov    0x8(%ebp),%eax
  80086a:	8b 00                	mov    (%eax),%eax
  80086c:	83 e8 04             	sub    $0x4,%eax
  80086f:	8b 00                	mov    (%eax),%eax
  800871:	99                   	cltd   
  800872:	eb 18                	jmp    80088c <getint+0x5d>
	else
		return va_arg(*ap, int);
  800874:	8b 45 08             	mov    0x8(%ebp),%eax
  800877:	8b 00                	mov    (%eax),%eax
  800879:	8d 50 04             	lea    0x4(%eax),%edx
  80087c:	8b 45 08             	mov    0x8(%ebp),%eax
  80087f:	89 10                	mov    %edx,(%eax)
  800881:	8b 45 08             	mov    0x8(%ebp),%eax
  800884:	8b 00                	mov    (%eax),%eax
  800886:	83 e8 04             	sub    $0x4,%eax
  800889:	8b 00                	mov    (%eax),%eax
  80088b:	99                   	cltd   
}
  80088c:	5d                   	pop    %ebp
  80088d:	c3                   	ret    

0080088e <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  80088e:	55                   	push   %ebp
  80088f:	89 e5                	mov    %esp,%ebp
  800891:	56                   	push   %esi
  800892:	53                   	push   %ebx
  800893:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800896:	eb 17                	jmp    8008af <vprintfmt+0x21>
			if (ch == '\0')
  800898:	85 db                	test   %ebx,%ebx
  80089a:	0f 84 c1 03 00 00    	je     800c61 <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  8008a0:	83 ec 08             	sub    $0x8,%esp
  8008a3:	ff 75 0c             	pushl  0xc(%ebp)
  8008a6:	53                   	push   %ebx
  8008a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8008aa:	ff d0                	call   *%eax
  8008ac:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8008af:	8b 45 10             	mov    0x10(%ebp),%eax
  8008b2:	8d 50 01             	lea    0x1(%eax),%edx
  8008b5:	89 55 10             	mov    %edx,0x10(%ebp)
  8008b8:	8a 00                	mov    (%eax),%al
  8008ba:	0f b6 d8             	movzbl %al,%ebx
  8008bd:	83 fb 25             	cmp    $0x25,%ebx
  8008c0:	75 d6                	jne    800898 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  8008c2:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  8008c6:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  8008cd:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8008d4:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  8008db:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8008e2:	8b 45 10             	mov    0x10(%ebp),%eax
  8008e5:	8d 50 01             	lea    0x1(%eax),%edx
  8008e8:	89 55 10             	mov    %edx,0x10(%ebp)
  8008eb:	8a 00                	mov    (%eax),%al
  8008ed:	0f b6 d8             	movzbl %al,%ebx
  8008f0:	8d 43 dd             	lea    -0x23(%ebx),%eax
  8008f3:	83 f8 5b             	cmp    $0x5b,%eax
  8008f6:	0f 87 3d 03 00 00    	ja     800c39 <vprintfmt+0x3ab>
  8008fc:	8b 04 85 78 24 80 00 	mov    0x802478(,%eax,4),%eax
  800903:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800905:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800909:	eb d7                	jmp    8008e2 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  80090b:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  80090f:	eb d1                	jmp    8008e2 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800911:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800918:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80091b:	89 d0                	mov    %edx,%eax
  80091d:	c1 e0 02             	shl    $0x2,%eax
  800920:	01 d0                	add    %edx,%eax
  800922:	01 c0                	add    %eax,%eax
  800924:	01 d8                	add    %ebx,%eax
  800926:	83 e8 30             	sub    $0x30,%eax
  800929:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  80092c:	8b 45 10             	mov    0x10(%ebp),%eax
  80092f:	8a 00                	mov    (%eax),%al
  800931:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800934:	83 fb 2f             	cmp    $0x2f,%ebx
  800937:	7e 3e                	jle    800977 <vprintfmt+0xe9>
  800939:	83 fb 39             	cmp    $0x39,%ebx
  80093c:	7f 39                	jg     800977 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  80093e:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800941:	eb d5                	jmp    800918 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800943:	8b 45 14             	mov    0x14(%ebp),%eax
  800946:	83 c0 04             	add    $0x4,%eax
  800949:	89 45 14             	mov    %eax,0x14(%ebp)
  80094c:	8b 45 14             	mov    0x14(%ebp),%eax
  80094f:	83 e8 04             	sub    $0x4,%eax
  800952:	8b 00                	mov    (%eax),%eax
  800954:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800957:	eb 1f                	jmp    800978 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800959:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80095d:	79 83                	jns    8008e2 <vprintfmt+0x54>
				width = 0;
  80095f:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800966:	e9 77 ff ff ff       	jmp    8008e2 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  80096b:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800972:	e9 6b ff ff ff       	jmp    8008e2 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800977:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800978:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80097c:	0f 89 60 ff ff ff    	jns    8008e2 <vprintfmt+0x54>
				width = precision, precision = -1;
  800982:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800985:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800988:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  80098f:	e9 4e ff ff ff       	jmp    8008e2 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800994:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800997:	e9 46 ff ff ff       	jmp    8008e2 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  80099c:	8b 45 14             	mov    0x14(%ebp),%eax
  80099f:	83 c0 04             	add    $0x4,%eax
  8009a2:	89 45 14             	mov    %eax,0x14(%ebp)
  8009a5:	8b 45 14             	mov    0x14(%ebp),%eax
  8009a8:	83 e8 04             	sub    $0x4,%eax
  8009ab:	8b 00                	mov    (%eax),%eax
  8009ad:	83 ec 08             	sub    $0x8,%esp
  8009b0:	ff 75 0c             	pushl  0xc(%ebp)
  8009b3:	50                   	push   %eax
  8009b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8009b7:	ff d0                	call   *%eax
  8009b9:	83 c4 10             	add    $0x10,%esp
			break;
  8009bc:	e9 9b 02 00 00       	jmp    800c5c <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  8009c1:	8b 45 14             	mov    0x14(%ebp),%eax
  8009c4:	83 c0 04             	add    $0x4,%eax
  8009c7:	89 45 14             	mov    %eax,0x14(%ebp)
  8009ca:	8b 45 14             	mov    0x14(%ebp),%eax
  8009cd:	83 e8 04             	sub    $0x4,%eax
  8009d0:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  8009d2:	85 db                	test   %ebx,%ebx
  8009d4:	79 02                	jns    8009d8 <vprintfmt+0x14a>
				err = -err;
  8009d6:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  8009d8:	83 fb 64             	cmp    $0x64,%ebx
  8009db:	7f 0b                	jg     8009e8 <vprintfmt+0x15a>
  8009dd:	8b 34 9d c0 22 80 00 	mov    0x8022c0(,%ebx,4),%esi
  8009e4:	85 f6                	test   %esi,%esi
  8009e6:	75 19                	jne    800a01 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  8009e8:	53                   	push   %ebx
  8009e9:	68 65 24 80 00       	push   $0x802465
  8009ee:	ff 75 0c             	pushl  0xc(%ebp)
  8009f1:	ff 75 08             	pushl  0x8(%ebp)
  8009f4:	e8 70 02 00 00       	call   800c69 <printfmt>
  8009f9:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  8009fc:	e9 5b 02 00 00       	jmp    800c5c <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800a01:	56                   	push   %esi
  800a02:	68 6e 24 80 00       	push   $0x80246e
  800a07:	ff 75 0c             	pushl  0xc(%ebp)
  800a0a:	ff 75 08             	pushl  0x8(%ebp)
  800a0d:	e8 57 02 00 00       	call   800c69 <printfmt>
  800a12:	83 c4 10             	add    $0x10,%esp
			break;
  800a15:	e9 42 02 00 00       	jmp    800c5c <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800a1a:	8b 45 14             	mov    0x14(%ebp),%eax
  800a1d:	83 c0 04             	add    $0x4,%eax
  800a20:	89 45 14             	mov    %eax,0x14(%ebp)
  800a23:	8b 45 14             	mov    0x14(%ebp),%eax
  800a26:	83 e8 04             	sub    $0x4,%eax
  800a29:	8b 30                	mov    (%eax),%esi
  800a2b:	85 f6                	test   %esi,%esi
  800a2d:	75 05                	jne    800a34 <vprintfmt+0x1a6>
				p = "(null)";
  800a2f:	be 71 24 80 00       	mov    $0x802471,%esi
			if (width > 0 && padc != '-')
  800a34:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a38:	7e 6d                	jle    800aa7 <vprintfmt+0x219>
  800a3a:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800a3e:	74 67                	je     800aa7 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800a40:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800a43:	83 ec 08             	sub    $0x8,%esp
  800a46:	50                   	push   %eax
  800a47:	56                   	push   %esi
  800a48:	e8 1e 03 00 00       	call   800d6b <strnlen>
  800a4d:	83 c4 10             	add    $0x10,%esp
  800a50:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800a53:	eb 16                	jmp    800a6b <vprintfmt+0x1dd>
					putch(padc, putdat);
  800a55:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800a59:	83 ec 08             	sub    $0x8,%esp
  800a5c:	ff 75 0c             	pushl  0xc(%ebp)
  800a5f:	50                   	push   %eax
  800a60:	8b 45 08             	mov    0x8(%ebp),%eax
  800a63:	ff d0                	call   *%eax
  800a65:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800a68:	ff 4d e4             	decl   -0x1c(%ebp)
  800a6b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a6f:	7f e4                	jg     800a55 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800a71:	eb 34                	jmp    800aa7 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800a73:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800a77:	74 1c                	je     800a95 <vprintfmt+0x207>
  800a79:	83 fb 1f             	cmp    $0x1f,%ebx
  800a7c:	7e 05                	jle    800a83 <vprintfmt+0x1f5>
  800a7e:	83 fb 7e             	cmp    $0x7e,%ebx
  800a81:	7e 12                	jle    800a95 <vprintfmt+0x207>
					putch('?', putdat);
  800a83:	83 ec 08             	sub    $0x8,%esp
  800a86:	ff 75 0c             	pushl  0xc(%ebp)
  800a89:	6a 3f                	push   $0x3f
  800a8b:	8b 45 08             	mov    0x8(%ebp),%eax
  800a8e:	ff d0                	call   *%eax
  800a90:	83 c4 10             	add    $0x10,%esp
  800a93:	eb 0f                	jmp    800aa4 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800a95:	83 ec 08             	sub    $0x8,%esp
  800a98:	ff 75 0c             	pushl  0xc(%ebp)
  800a9b:	53                   	push   %ebx
  800a9c:	8b 45 08             	mov    0x8(%ebp),%eax
  800a9f:	ff d0                	call   *%eax
  800aa1:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800aa4:	ff 4d e4             	decl   -0x1c(%ebp)
  800aa7:	89 f0                	mov    %esi,%eax
  800aa9:	8d 70 01             	lea    0x1(%eax),%esi
  800aac:	8a 00                	mov    (%eax),%al
  800aae:	0f be d8             	movsbl %al,%ebx
  800ab1:	85 db                	test   %ebx,%ebx
  800ab3:	74 24                	je     800ad9 <vprintfmt+0x24b>
  800ab5:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800ab9:	78 b8                	js     800a73 <vprintfmt+0x1e5>
  800abb:	ff 4d e0             	decl   -0x20(%ebp)
  800abe:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800ac2:	79 af                	jns    800a73 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800ac4:	eb 13                	jmp    800ad9 <vprintfmt+0x24b>
				putch(' ', putdat);
  800ac6:	83 ec 08             	sub    $0x8,%esp
  800ac9:	ff 75 0c             	pushl  0xc(%ebp)
  800acc:	6a 20                	push   $0x20
  800ace:	8b 45 08             	mov    0x8(%ebp),%eax
  800ad1:	ff d0                	call   *%eax
  800ad3:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800ad6:	ff 4d e4             	decl   -0x1c(%ebp)
  800ad9:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800add:	7f e7                	jg     800ac6 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800adf:	e9 78 01 00 00       	jmp    800c5c <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800ae4:	83 ec 08             	sub    $0x8,%esp
  800ae7:	ff 75 e8             	pushl  -0x18(%ebp)
  800aea:	8d 45 14             	lea    0x14(%ebp),%eax
  800aed:	50                   	push   %eax
  800aee:	e8 3c fd ff ff       	call   80082f <getint>
  800af3:	83 c4 10             	add    $0x10,%esp
  800af6:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800af9:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800afc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800aff:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800b02:	85 d2                	test   %edx,%edx
  800b04:	79 23                	jns    800b29 <vprintfmt+0x29b>
				putch('-', putdat);
  800b06:	83 ec 08             	sub    $0x8,%esp
  800b09:	ff 75 0c             	pushl  0xc(%ebp)
  800b0c:	6a 2d                	push   $0x2d
  800b0e:	8b 45 08             	mov    0x8(%ebp),%eax
  800b11:	ff d0                	call   *%eax
  800b13:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800b16:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800b19:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800b1c:	f7 d8                	neg    %eax
  800b1e:	83 d2 00             	adc    $0x0,%edx
  800b21:	f7 da                	neg    %edx
  800b23:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b26:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800b29:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800b30:	e9 bc 00 00 00       	jmp    800bf1 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800b35:	83 ec 08             	sub    $0x8,%esp
  800b38:	ff 75 e8             	pushl  -0x18(%ebp)
  800b3b:	8d 45 14             	lea    0x14(%ebp),%eax
  800b3e:	50                   	push   %eax
  800b3f:	e8 84 fc ff ff       	call   8007c8 <getuint>
  800b44:	83 c4 10             	add    $0x10,%esp
  800b47:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b4a:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800b4d:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800b54:	e9 98 00 00 00       	jmp    800bf1 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800b59:	83 ec 08             	sub    $0x8,%esp
  800b5c:	ff 75 0c             	pushl  0xc(%ebp)
  800b5f:	6a 58                	push   $0x58
  800b61:	8b 45 08             	mov    0x8(%ebp),%eax
  800b64:	ff d0                	call   *%eax
  800b66:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800b69:	83 ec 08             	sub    $0x8,%esp
  800b6c:	ff 75 0c             	pushl  0xc(%ebp)
  800b6f:	6a 58                	push   $0x58
  800b71:	8b 45 08             	mov    0x8(%ebp),%eax
  800b74:	ff d0                	call   *%eax
  800b76:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800b79:	83 ec 08             	sub    $0x8,%esp
  800b7c:	ff 75 0c             	pushl  0xc(%ebp)
  800b7f:	6a 58                	push   $0x58
  800b81:	8b 45 08             	mov    0x8(%ebp),%eax
  800b84:	ff d0                	call   *%eax
  800b86:	83 c4 10             	add    $0x10,%esp
			break;
  800b89:	e9 ce 00 00 00       	jmp    800c5c <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  800b8e:	83 ec 08             	sub    $0x8,%esp
  800b91:	ff 75 0c             	pushl  0xc(%ebp)
  800b94:	6a 30                	push   $0x30
  800b96:	8b 45 08             	mov    0x8(%ebp),%eax
  800b99:	ff d0                	call   *%eax
  800b9b:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800b9e:	83 ec 08             	sub    $0x8,%esp
  800ba1:	ff 75 0c             	pushl  0xc(%ebp)
  800ba4:	6a 78                	push   $0x78
  800ba6:	8b 45 08             	mov    0x8(%ebp),%eax
  800ba9:	ff d0                	call   *%eax
  800bab:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800bae:	8b 45 14             	mov    0x14(%ebp),%eax
  800bb1:	83 c0 04             	add    $0x4,%eax
  800bb4:	89 45 14             	mov    %eax,0x14(%ebp)
  800bb7:	8b 45 14             	mov    0x14(%ebp),%eax
  800bba:	83 e8 04             	sub    $0x4,%eax
  800bbd:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800bbf:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800bc2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800bc9:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800bd0:	eb 1f                	jmp    800bf1 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800bd2:	83 ec 08             	sub    $0x8,%esp
  800bd5:	ff 75 e8             	pushl  -0x18(%ebp)
  800bd8:	8d 45 14             	lea    0x14(%ebp),%eax
  800bdb:	50                   	push   %eax
  800bdc:	e8 e7 fb ff ff       	call   8007c8 <getuint>
  800be1:	83 c4 10             	add    $0x10,%esp
  800be4:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800be7:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800bea:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800bf1:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800bf5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800bf8:	83 ec 04             	sub    $0x4,%esp
  800bfb:	52                   	push   %edx
  800bfc:	ff 75 e4             	pushl  -0x1c(%ebp)
  800bff:	50                   	push   %eax
  800c00:	ff 75 f4             	pushl  -0xc(%ebp)
  800c03:	ff 75 f0             	pushl  -0x10(%ebp)
  800c06:	ff 75 0c             	pushl  0xc(%ebp)
  800c09:	ff 75 08             	pushl  0x8(%ebp)
  800c0c:	e8 00 fb ff ff       	call   800711 <printnum>
  800c11:	83 c4 20             	add    $0x20,%esp
			break;
  800c14:	eb 46                	jmp    800c5c <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800c16:	83 ec 08             	sub    $0x8,%esp
  800c19:	ff 75 0c             	pushl  0xc(%ebp)
  800c1c:	53                   	push   %ebx
  800c1d:	8b 45 08             	mov    0x8(%ebp),%eax
  800c20:	ff d0                	call   *%eax
  800c22:	83 c4 10             	add    $0x10,%esp
			break;
  800c25:	eb 35                	jmp    800c5c <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  800c27:	c6 05 44 30 80 00 00 	movb   $0x0,0x803044
			break;
  800c2e:	eb 2c                	jmp    800c5c <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  800c30:	c6 05 44 30 80 00 01 	movb   $0x1,0x803044
			break;
  800c37:	eb 23                	jmp    800c5c <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800c39:	83 ec 08             	sub    $0x8,%esp
  800c3c:	ff 75 0c             	pushl  0xc(%ebp)
  800c3f:	6a 25                	push   $0x25
  800c41:	8b 45 08             	mov    0x8(%ebp),%eax
  800c44:	ff d0                	call   *%eax
  800c46:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800c49:	ff 4d 10             	decl   0x10(%ebp)
  800c4c:	eb 03                	jmp    800c51 <vprintfmt+0x3c3>
  800c4e:	ff 4d 10             	decl   0x10(%ebp)
  800c51:	8b 45 10             	mov    0x10(%ebp),%eax
  800c54:	48                   	dec    %eax
  800c55:	8a 00                	mov    (%eax),%al
  800c57:	3c 25                	cmp    $0x25,%al
  800c59:	75 f3                	jne    800c4e <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  800c5b:	90                   	nop
		}
	}
  800c5c:	e9 35 fc ff ff       	jmp    800896 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800c61:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800c62:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800c65:	5b                   	pop    %ebx
  800c66:	5e                   	pop    %esi
  800c67:	5d                   	pop    %ebp
  800c68:	c3                   	ret    

00800c69 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800c69:	55                   	push   %ebp
  800c6a:	89 e5                	mov    %esp,%ebp
  800c6c:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800c6f:	8d 45 10             	lea    0x10(%ebp),%eax
  800c72:	83 c0 04             	add    $0x4,%eax
  800c75:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800c78:	8b 45 10             	mov    0x10(%ebp),%eax
  800c7b:	ff 75 f4             	pushl  -0xc(%ebp)
  800c7e:	50                   	push   %eax
  800c7f:	ff 75 0c             	pushl  0xc(%ebp)
  800c82:	ff 75 08             	pushl  0x8(%ebp)
  800c85:	e8 04 fc ff ff       	call   80088e <vprintfmt>
  800c8a:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800c8d:	90                   	nop
  800c8e:	c9                   	leave  
  800c8f:	c3                   	ret    

00800c90 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800c90:	55                   	push   %ebp
  800c91:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800c93:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c96:	8b 40 08             	mov    0x8(%eax),%eax
  800c99:	8d 50 01             	lea    0x1(%eax),%edx
  800c9c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c9f:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800ca2:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ca5:	8b 10                	mov    (%eax),%edx
  800ca7:	8b 45 0c             	mov    0xc(%ebp),%eax
  800caa:	8b 40 04             	mov    0x4(%eax),%eax
  800cad:	39 c2                	cmp    %eax,%edx
  800caf:	73 12                	jae    800cc3 <sprintputch+0x33>
		*b->buf++ = ch;
  800cb1:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cb4:	8b 00                	mov    (%eax),%eax
  800cb6:	8d 48 01             	lea    0x1(%eax),%ecx
  800cb9:	8b 55 0c             	mov    0xc(%ebp),%edx
  800cbc:	89 0a                	mov    %ecx,(%edx)
  800cbe:	8b 55 08             	mov    0x8(%ebp),%edx
  800cc1:	88 10                	mov    %dl,(%eax)
}
  800cc3:	90                   	nop
  800cc4:	5d                   	pop    %ebp
  800cc5:	c3                   	ret    

00800cc6 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800cc6:	55                   	push   %ebp
  800cc7:	89 e5                	mov    %esp,%ebp
  800cc9:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800ccc:	8b 45 08             	mov    0x8(%ebp),%eax
  800ccf:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800cd2:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cd5:	8d 50 ff             	lea    -0x1(%eax),%edx
  800cd8:	8b 45 08             	mov    0x8(%ebp),%eax
  800cdb:	01 d0                	add    %edx,%eax
  800cdd:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800ce0:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800ce7:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800ceb:	74 06                	je     800cf3 <vsnprintf+0x2d>
  800ced:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800cf1:	7f 07                	jg     800cfa <vsnprintf+0x34>
		return -E_INVAL;
  800cf3:	b8 03 00 00 00       	mov    $0x3,%eax
  800cf8:	eb 20                	jmp    800d1a <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800cfa:	ff 75 14             	pushl  0x14(%ebp)
  800cfd:	ff 75 10             	pushl  0x10(%ebp)
  800d00:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800d03:	50                   	push   %eax
  800d04:	68 90 0c 80 00       	push   $0x800c90
  800d09:	e8 80 fb ff ff       	call   80088e <vprintfmt>
  800d0e:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800d11:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800d14:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800d17:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800d1a:	c9                   	leave  
  800d1b:	c3                   	ret    

00800d1c <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800d1c:	55                   	push   %ebp
  800d1d:	89 e5                	mov    %esp,%ebp
  800d1f:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800d22:	8d 45 10             	lea    0x10(%ebp),%eax
  800d25:	83 c0 04             	add    $0x4,%eax
  800d28:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800d2b:	8b 45 10             	mov    0x10(%ebp),%eax
  800d2e:	ff 75 f4             	pushl  -0xc(%ebp)
  800d31:	50                   	push   %eax
  800d32:	ff 75 0c             	pushl  0xc(%ebp)
  800d35:	ff 75 08             	pushl  0x8(%ebp)
  800d38:	e8 89 ff ff ff       	call   800cc6 <vsnprintf>
  800d3d:	83 c4 10             	add    $0x10,%esp
  800d40:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800d43:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800d46:	c9                   	leave  
  800d47:	c3                   	ret    

00800d48 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800d48:	55                   	push   %ebp
  800d49:	89 e5                	mov    %esp,%ebp
  800d4b:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800d4e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800d55:	eb 06                	jmp    800d5d <strlen+0x15>
		n++;
  800d57:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800d5a:	ff 45 08             	incl   0x8(%ebp)
  800d5d:	8b 45 08             	mov    0x8(%ebp),%eax
  800d60:	8a 00                	mov    (%eax),%al
  800d62:	84 c0                	test   %al,%al
  800d64:	75 f1                	jne    800d57 <strlen+0xf>
		n++;
	return n;
  800d66:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800d69:	c9                   	leave  
  800d6a:	c3                   	ret    

00800d6b <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800d6b:	55                   	push   %ebp
  800d6c:	89 e5                	mov    %esp,%ebp
  800d6e:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800d71:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800d78:	eb 09                	jmp    800d83 <strnlen+0x18>
		n++;
  800d7a:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800d7d:	ff 45 08             	incl   0x8(%ebp)
  800d80:	ff 4d 0c             	decl   0xc(%ebp)
  800d83:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800d87:	74 09                	je     800d92 <strnlen+0x27>
  800d89:	8b 45 08             	mov    0x8(%ebp),%eax
  800d8c:	8a 00                	mov    (%eax),%al
  800d8e:	84 c0                	test   %al,%al
  800d90:	75 e8                	jne    800d7a <strnlen+0xf>
		n++;
	return n;
  800d92:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800d95:	c9                   	leave  
  800d96:	c3                   	ret    

00800d97 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800d97:	55                   	push   %ebp
  800d98:	89 e5                	mov    %esp,%ebp
  800d9a:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800d9d:	8b 45 08             	mov    0x8(%ebp),%eax
  800da0:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800da3:	90                   	nop
  800da4:	8b 45 08             	mov    0x8(%ebp),%eax
  800da7:	8d 50 01             	lea    0x1(%eax),%edx
  800daa:	89 55 08             	mov    %edx,0x8(%ebp)
  800dad:	8b 55 0c             	mov    0xc(%ebp),%edx
  800db0:	8d 4a 01             	lea    0x1(%edx),%ecx
  800db3:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800db6:	8a 12                	mov    (%edx),%dl
  800db8:	88 10                	mov    %dl,(%eax)
  800dba:	8a 00                	mov    (%eax),%al
  800dbc:	84 c0                	test   %al,%al
  800dbe:	75 e4                	jne    800da4 <strcpy+0xd>
		/* do nothing */;
	return ret;
  800dc0:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800dc3:	c9                   	leave  
  800dc4:	c3                   	ret    

00800dc5 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800dc5:	55                   	push   %ebp
  800dc6:	89 e5                	mov    %esp,%ebp
  800dc8:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800dcb:	8b 45 08             	mov    0x8(%ebp),%eax
  800dce:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800dd1:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800dd8:	eb 1f                	jmp    800df9 <strncpy+0x34>
		*dst++ = *src;
  800dda:	8b 45 08             	mov    0x8(%ebp),%eax
  800ddd:	8d 50 01             	lea    0x1(%eax),%edx
  800de0:	89 55 08             	mov    %edx,0x8(%ebp)
  800de3:	8b 55 0c             	mov    0xc(%ebp),%edx
  800de6:	8a 12                	mov    (%edx),%dl
  800de8:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800dea:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ded:	8a 00                	mov    (%eax),%al
  800def:	84 c0                	test   %al,%al
  800df1:	74 03                	je     800df6 <strncpy+0x31>
			src++;
  800df3:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800df6:	ff 45 fc             	incl   -0x4(%ebp)
  800df9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800dfc:	3b 45 10             	cmp    0x10(%ebp),%eax
  800dff:	72 d9                	jb     800dda <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800e01:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800e04:	c9                   	leave  
  800e05:	c3                   	ret    

00800e06 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800e06:	55                   	push   %ebp
  800e07:	89 e5                	mov    %esp,%ebp
  800e09:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800e0c:	8b 45 08             	mov    0x8(%ebp),%eax
  800e0f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800e12:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e16:	74 30                	je     800e48 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800e18:	eb 16                	jmp    800e30 <strlcpy+0x2a>
			*dst++ = *src++;
  800e1a:	8b 45 08             	mov    0x8(%ebp),%eax
  800e1d:	8d 50 01             	lea    0x1(%eax),%edx
  800e20:	89 55 08             	mov    %edx,0x8(%ebp)
  800e23:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e26:	8d 4a 01             	lea    0x1(%edx),%ecx
  800e29:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800e2c:	8a 12                	mov    (%edx),%dl
  800e2e:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800e30:	ff 4d 10             	decl   0x10(%ebp)
  800e33:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e37:	74 09                	je     800e42 <strlcpy+0x3c>
  800e39:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e3c:	8a 00                	mov    (%eax),%al
  800e3e:	84 c0                	test   %al,%al
  800e40:	75 d8                	jne    800e1a <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800e42:	8b 45 08             	mov    0x8(%ebp),%eax
  800e45:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800e48:	8b 55 08             	mov    0x8(%ebp),%edx
  800e4b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e4e:	29 c2                	sub    %eax,%edx
  800e50:	89 d0                	mov    %edx,%eax
}
  800e52:	c9                   	leave  
  800e53:	c3                   	ret    

00800e54 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800e54:	55                   	push   %ebp
  800e55:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800e57:	eb 06                	jmp    800e5f <strcmp+0xb>
		p++, q++;
  800e59:	ff 45 08             	incl   0x8(%ebp)
  800e5c:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800e5f:	8b 45 08             	mov    0x8(%ebp),%eax
  800e62:	8a 00                	mov    (%eax),%al
  800e64:	84 c0                	test   %al,%al
  800e66:	74 0e                	je     800e76 <strcmp+0x22>
  800e68:	8b 45 08             	mov    0x8(%ebp),%eax
  800e6b:	8a 10                	mov    (%eax),%dl
  800e6d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e70:	8a 00                	mov    (%eax),%al
  800e72:	38 c2                	cmp    %al,%dl
  800e74:	74 e3                	je     800e59 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800e76:	8b 45 08             	mov    0x8(%ebp),%eax
  800e79:	8a 00                	mov    (%eax),%al
  800e7b:	0f b6 d0             	movzbl %al,%edx
  800e7e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e81:	8a 00                	mov    (%eax),%al
  800e83:	0f b6 c0             	movzbl %al,%eax
  800e86:	29 c2                	sub    %eax,%edx
  800e88:	89 d0                	mov    %edx,%eax
}
  800e8a:	5d                   	pop    %ebp
  800e8b:	c3                   	ret    

00800e8c <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800e8c:	55                   	push   %ebp
  800e8d:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800e8f:	eb 09                	jmp    800e9a <strncmp+0xe>
		n--, p++, q++;
  800e91:	ff 4d 10             	decl   0x10(%ebp)
  800e94:	ff 45 08             	incl   0x8(%ebp)
  800e97:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800e9a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e9e:	74 17                	je     800eb7 <strncmp+0x2b>
  800ea0:	8b 45 08             	mov    0x8(%ebp),%eax
  800ea3:	8a 00                	mov    (%eax),%al
  800ea5:	84 c0                	test   %al,%al
  800ea7:	74 0e                	je     800eb7 <strncmp+0x2b>
  800ea9:	8b 45 08             	mov    0x8(%ebp),%eax
  800eac:	8a 10                	mov    (%eax),%dl
  800eae:	8b 45 0c             	mov    0xc(%ebp),%eax
  800eb1:	8a 00                	mov    (%eax),%al
  800eb3:	38 c2                	cmp    %al,%dl
  800eb5:	74 da                	je     800e91 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800eb7:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ebb:	75 07                	jne    800ec4 <strncmp+0x38>
		return 0;
  800ebd:	b8 00 00 00 00       	mov    $0x0,%eax
  800ec2:	eb 14                	jmp    800ed8 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800ec4:	8b 45 08             	mov    0x8(%ebp),%eax
  800ec7:	8a 00                	mov    (%eax),%al
  800ec9:	0f b6 d0             	movzbl %al,%edx
  800ecc:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ecf:	8a 00                	mov    (%eax),%al
  800ed1:	0f b6 c0             	movzbl %al,%eax
  800ed4:	29 c2                	sub    %eax,%edx
  800ed6:	89 d0                	mov    %edx,%eax
}
  800ed8:	5d                   	pop    %ebp
  800ed9:	c3                   	ret    

00800eda <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800eda:	55                   	push   %ebp
  800edb:	89 e5                	mov    %esp,%ebp
  800edd:	83 ec 04             	sub    $0x4,%esp
  800ee0:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ee3:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800ee6:	eb 12                	jmp    800efa <strchr+0x20>
		if (*s == c)
  800ee8:	8b 45 08             	mov    0x8(%ebp),%eax
  800eeb:	8a 00                	mov    (%eax),%al
  800eed:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800ef0:	75 05                	jne    800ef7 <strchr+0x1d>
			return (char *) s;
  800ef2:	8b 45 08             	mov    0x8(%ebp),%eax
  800ef5:	eb 11                	jmp    800f08 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800ef7:	ff 45 08             	incl   0x8(%ebp)
  800efa:	8b 45 08             	mov    0x8(%ebp),%eax
  800efd:	8a 00                	mov    (%eax),%al
  800eff:	84 c0                	test   %al,%al
  800f01:	75 e5                	jne    800ee8 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800f03:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800f08:	c9                   	leave  
  800f09:	c3                   	ret    

00800f0a <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800f0a:	55                   	push   %ebp
  800f0b:	89 e5                	mov    %esp,%ebp
  800f0d:	83 ec 04             	sub    $0x4,%esp
  800f10:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f13:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800f16:	eb 0d                	jmp    800f25 <strfind+0x1b>
		if (*s == c)
  800f18:	8b 45 08             	mov    0x8(%ebp),%eax
  800f1b:	8a 00                	mov    (%eax),%al
  800f1d:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800f20:	74 0e                	je     800f30 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800f22:	ff 45 08             	incl   0x8(%ebp)
  800f25:	8b 45 08             	mov    0x8(%ebp),%eax
  800f28:	8a 00                	mov    (%eax),%al
  800f2a:	84 c0                	test   %al,%al
  800f2c:	75 ea                	jne    800f18 <strfind+0xe>
  800f2e:	eb 01                	jmp    800f31 <strfind+0x27>
		if (*s == c)
			break;
  800f30:	90                   	nop
	return (char *) s;
  800f31:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f34:	c9                   	leave  
  800f35:	c3                   	ret    

00800f36 <memset>:

// *************** The faster implementation of memset & memcpy is implemented by *************
// ****************** Team80 (Yahia Khaled, Malek Ahmed et al) - FCIS'24-25 *******************
void *
memset(void *v, int c, uint32 n)
{
  800f36:	55                   	push   %ebp
  800f37:	89 e5                	mov    %esp,%ebp
  800f39:	83 ec 10             	sub    $0x10,%esp
//	m = n;
//	while (--m >= 0)
//		*p++ = c;

	/*Faster Implementation*/
	uint64* p64 = (uint64*)v;
  800f3c:	8b 45 08             	mov    0x8(%ebp),%eax
  800f3f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if(n >= 8){
  800f42:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800f46:	76 63                	jbe    800fab <memset+0x75>
		uint64 data_block = c;
  800f48:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f4b:	99                   	cltd   
  800f4c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800f4f:	89 55 f4             	mov    %edx,-0xc(%ebp)
		data_block |= data_block << 8;
  800f52:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800f55:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800f58:	0f a4 c2 08          	shld   $0x8,%eax,%edx
  800f5c:	c1 e0 08             	shl    $0x8,%eax
  800f5f:	09 45 f0             	or     %eax,-0x10(%ebp)
  800f62:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 16;
  800f65:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800f68:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800f6b:	0f a4 c2 10          	shld   $0x10,%eax,%edx
  800f6f:	c1 e0 10             	shl    $0x10,%eax
  800f72:	09 45 f0             	or     %eax,-0x10(%ebp)
  800f75:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 32;
  800f78:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800f7b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800f7e:	89 c2                	mov    %eax,%edx
  800f80:	b8 00 00 00 00       	mov    $0x0,%eax
  800f85:	09 45 f0             	or     %eax,-0x10(%ebp)
  800f88:	09 55 f4             	or     %edx,-0xc(%ebp)

		while(n >= 8)
  800f8b:	eb 18                	jmp    800fa5 <memset+0x6f>
			*p64++ = data_block, n -= 8;
  800f8d:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  800f90:	8d 41 08             	lea    0x8(%ecx),%eax
  800f93:	89 45 fc             	mov    %eax,-0x4(%ebp)
  800f96:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800f99:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800f9c:	89 01                	mov    %eax,(%ecx)
  800f9e:	89 51 04             	mov    %edx,0x4(%ecx)
  800fa1:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
		uint64 data_block = c;
		data_block |= data_block << 8;
		data_block |= data_block << 16;
		data_block |= data_block << 32;

		while(n >= 8)
  800fa5:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800fa9:	77 e2                	ja     800f8d <memset+0x57>
			*p64++ = data_block, n -= 8;
	}

	if(n){
  800fab:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800faf:	74 23                	je     800fd4 <memset+0x9e>
		uint8* p8 = (uint8*)p64;
  800fb1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800fb4:	89 45 f8             	mov    %eax,-0x8(%ebp)
		while (n-- > 0)
  800fb7:	eb 0e                	jmp    800fc7 <memset+0x91>
			*p8++ = (uint8)c;
  800fb9:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800fbc:	8d 50 01             	lea    0x1(%eax),%edx
  800fbf:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800fc2:	8b 55 0c             	mov    0xc(%ebp),%edx
  800fc5:	88 10                	mov    %dl,(%eax)
			*p64++ = data_block, n -= 8;
	}

	if(n){
		uint8* p8 = (uint8*)p64;
		while (n-- > 0)
  800fc7:	8b 45 10             	mov    0x10(%ebp),%eax
  800fca:	8d 50 ff             	lea    -0x1(%eax),%edx
  800fcd:	89 55 10             	mov    %edx,0x10(%ebp)
  800fd0:	85 c0                	test   %eax,%eax
  800fd2:	75 e5                	jne    800fb9 <memset+0x83>
			*p8++ = (uint8)c;
	}

	return v;
  800fd4:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800fd7:	c9                   	leave  
  800fd8:	c3                   	ret    

00800fd9 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800fd9:	55                   	push   %ebp
  800fda:	89 e5                	mov    %esp,%ebp
  800fdc:	83 ec 10             	sub    $0x10,%esp
	//	s = src;
	//	d = dst;
	//	while (n-- > 0)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
  800fdf:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fe2:	89 45 fc             	mov    %eax,-0x4(%ebp)
	uint64* d64 = (uint64*)dst;
  800fe5:	8b 45 08             	mov    0x8(%ebp),%eax
  800fe8:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if(n >= 8){
  800feb:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800fef:	76 24                	jbe    801015 <memcpy+0x3c>
		while(n >= 8){
  800ff1:	eb 1c                	jmp    80100f <memcpy+0x36>
			*d64 = *s64;
  800ff3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ff6:	8b 50 04             	mov    0x4(%eax),%edx
  800ff9:	8b 00                	mov    (%eax),%eax
  800ffb:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  800ffe:	89 01                	mov    %eax,(%ecx)
  801000:	89 51 04             	mov    %edx,0x4(%ecx)
			n -= 8;
  801003:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
			++s64;
  801007:	83 45 fc 08          	addl   $0x8,-0x4(%ebp)
			++d64;
  80100b:	83 45 f8 08          	addl   $0x8,-0x8(%ebp)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
	uint64* d64 = (uint64*)dst;
	if(n >= 8){
		while(n >= 8){
  80100f:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  801013:	77 de                	ja     800ff3 <memcpy+0x1a>
			++s64;
			++d64;
		}
	}

	if(n){
  801015:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801019:	74 31                	je     80104c <memcpy+0x73>
		uint8* s8 = (uint8*)s64;
  80101b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80101e:	89 45 f4             	mov    %eax,-0xc(%ebp)
		uint8* d8 = (uint8*)d64;
  801021:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801024:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (n-- > 0)
  801027:	eb 16                	jmp    80103f <memcpy+0x66>
			*d8++ = *s8++;
  801029:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80102c:	8d 50 01             	lea    0x1(%eax),%edx
  80102f:	89 55 f0             	mov    %edx,-0x10(%ebp)
  801032:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801035:	8d 4a 01             	lea    0x1(%edx),%ecx
  801038:	89 4d f4             	mov    %ecx,-0xc(%ebp)
  80103b:	8a 12                	mov    (%edx),%dl
  80103d:	88 10                	mov    %dl,(%eax)
	}

	if(n){
		uint8* s8 = (uint8*)s64;
		uint8* d8 = (uint8*)d64;
		while (n-- > 0)
  80103f:	8b 45 10             	mov    0x10(%ebp),%eax
  801042:	8d 50 ff             	lea    -0x1(%eax),%edx
  801045:	89 55 10             	mov    %edx,0x10(%ebp)
  801048:	85 c0                	test   %eax,%eax
  80104a:	75 dd                	jne    801029 <memcpy+0x50>
			*d8++ = *s8++;
	}
	return dst;
  80104c:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80104f:	c9                   	leave  
  801050:	c3                   	ret    

00801051 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  801051:	55                   	push   %ebp
  801052:	89 e5                	mov    %esp,%ebp
  801054:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801057:	8b 45 0c             	mov    0xc(%ebp),%eax
  80105a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  80105d:	8b 45 08             	mov    0x8(%ebp),%eax
  801060:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  801063:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801066:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801069:	73 50                	jae    8010bb <memmove+0x6a>
  80106b:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80106e:	8b 45 10             	mov    0x10(%ebp),%eax
  801071:	01 d0                	add    %edx,%eax
  801073:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801076:	76 43                	jbe    8010bb <memmove+0x6a>
		s += n;
  801078:	8b 45 10             	mov    0x10(%ebp),%eax
  80107b:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  80107e:	8b 45 10             	mov    0x10(%ebp),%eax
  801081:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  801084:	eb 10                	jmp    801096 <memmove+0x45>
			*--d = *--s;
  801086:	ff 4d f8             	decl   -0x8(%ebp)
  801089:	ff 4d fc             	decl   -0x4(%ebp)
  80108c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80108f:	8a 10                	mov    (%eax),%dl
  801091:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801094:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  801096:	8b 45 10             	mov    0x10(%ebp),%eax
  801099:	8d 50 ff             	lea    -0x1(%eax),%edx
  80109c:	89 55 10             	mov    %edx,0x10(%ebp)
  80109f:	85 c0                	test   %eax,%eax
  8010a1:	75 e3                	jne    801086 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  8010a3:	eb 23                	jmp    8010c8 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  8010a5:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010a8:	8d 50 01             	lea    0x1(%eax),%edx
  8010ab:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8010ae:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8010b1:	8d 4a 01             	lea    0x1(%edx),%ecx
  8010b4:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  8010b7:	8a 12                	mov    (%edx),%dl
  8010b9:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  8010bb:	8b 45 10             	mov    0x10(%ebp),%eax
  8010be:	8d 50 ff             	lea    -0x1(%eax),%edx
  8010c1:	89 55 10             	mov    %edx,0x10(%ebp)
  8010c4:	85 c0                	test   %eax,%eax
  8010c6:	75 dd                	jne    8010a5 <memmove+0x54>
			*d++ = *s++;

	return dst;
  8010c8:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8010cb:	c9                   	leave  
  8010cc:	c3                   	ret    

008010cd <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  8010cd:	55                   	push   %ebp
  8010ce:	89 e5                	mov    %esp,%ebp
  8010d0:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  8010d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8010d6:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  8010d9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010dc:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  8010df:	eb 2a                	jmp    80110b <memcmp+0x3e>
		if (*s1 != *s2)
  8010e1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8010e4:	8a 10                	mov    (%eax),%dl
  8010e6:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010e9:	8a 00                	mov    (%eax),%al
  8010eb:	38 c2                	cmp    %al,%dl
  8010ed:	74 16                	je     801105 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  8010ef:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8010f2:	8a 00                	mov    (%eax),%al
  8010f4:	0f b6 d0             	movzbl %al,%edx
  8010f7:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010fa:	8a 00                	mov    (%eax),%al
  8010fc:	0f b6 c0             	movzbl %al,%eax
  8010ff:	29 c2                	sub    %eax,%edx
  801101:	89 d0                	mov    %edx,%eax
  801103:	eb 18                	jmp    80111d <memcmp+0x50>
		s1++, s2++;
  801105:	ff 45 fc             	incl   -0x4(%ebp)
  801108:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  80110b:	8b 45 10             	mov    0x10(%ebp),%eax
  80110e:	8d 50 ff             	lea    -0x1(%eax),%edx
  801111:	89 55 10             	mov    %edx,0x10(%ebp)
  801114:	85 c0                	test   %eax,%eax
  801116:	75 c9                	jne    8010e1 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801118:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80111d:	c9                   	leave  
  80111e:	c3                   	ret    

0080111f <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  80111f:	55                   	push   %ebp
  801120:	89 e5                	mov    %esp,%ebp
  801122:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  801125:	8b 55 08             	mov    0x8(%ebp),%edx
  801128:	8b 45 10             	mov    0x10(%ebp),%eax
  80112b:	01 d0                	add    %edx,%eax
  80112d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  801130:	eb 15                	jmp    801147 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  801132:	8b 45 08             	mov    0x8(%ebp),%eax
  801135:	8a 00                	mov    (%eax),%al
  801137:	0f b6 d0             	movzbl %al,%edx
  80113a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80113d:	0f b6 c0             	movzbl %al,%eax
  801140:	39 c2                	cmp    %eax,%edx
  801142:	74 0d                	je     801151 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801144:	ff 45 08             	incl   0x8(%ebp)
  801147:	8b 45 08             	mov    0x8(%ebp),%eax
  80114a:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  80114d:	72 e3                	jb     801132 <memfind+0x13>
  80114f:	eb 01                	jmp    801152 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  801151:	90                   	nop
	return (void *) s;
  801152:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801155:	c9                   	leave  
  801156:	c3                   	ret    

00801157 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801157:	55                   	push   %ebp
  801158:	89 e5                	mov    %esp,%ebp
  80115a:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  80115d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  801164:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80116b:	eb 03                	jmp    801170 <strtol+0x19>
		s++;
  80116d:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801170:	8b 45 08             	mov    0x8(%ebp),%eax
  801173:	8a 00                	mov    (%eax),%al
  801175:	3c 20                	cmp    $0x20,%al
  801177:	74 f4                	je     80116d <strtol+0x16>
  801179:	8b 45 08             	mov    0x8(%ebp),%eax
  80117c:	8a 00                	mov    (%eax),%al
  80117e:	3c 09                	cmp    $0x9,%al
  801180:	74 eb                	je     80116d <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  801182:	8b 45 08             	mov    0x8(%ebp),%eax
  801185:	8a 00                	mov    (%eax),%al
  801187:	3c 2b                	cmp    $0x2b,%al
  801189:	75 05                	jne    801190 <strtol+0x39>
		s++;
  80118b:	ff 45 08             	incl   0x8(%ebp)
  80118e:	eb 13                	jmp    8011a3 <strtol+0x4c>
	else if (*s == '-')
  801190:	8b 45 08             	mov    0x8(%ebp),%eax
  801193:	8a 00                	mov    (%eax),%al
  801195:	3c 2d                	cmp    $0x2d,%al
  801197:	75 0a                	jne    8011a3 <strtol+0x4c>
		s++, neg = 1;
  801199:	ff 45 08             	incl   0x8(%ebp)
  80119c:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8011a3:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8011a7:	74 06                	je     8011af <strtol+0x58>
  8011a9:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  8011ad:	75 20                	jne    8011cf <strtol+0x78>
  8011af:	8b 45 08             	mov    0x8(%ebp),%eax
  8011b2:	8a 00                	mov    (%eax),%al
  8011b4:	3c 30                	cmp    $0x30,%al
  8011b6:	75 17                	jne    8011cf <strtol+0x78>
  8011b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8011bb:	40                   	inc    %eax
  8011bc:	8a 00                	mov    (%eax),%al
  8011be:	3c 78                	cmp    $0x78,%al
  8011c0:	75 0d                	jne    8011cf <strtol+0x78>
		s += 2, base = 16;
  8011c2:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  8011c6:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  8011cd:	eb 28                	jmp    8011f7 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  8011cf:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8011d3:	75 15                	jne    8011ea <strtol+0x93>
  8011d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8011d8:	8a 00                	mov    (%eax),%al
  8011da:	3c 30                	cmp    $0x30,%al
  8011dc:	75 0c                	jne    8011ea <strtol+0x93>
		s++, base = 8;
  8011de:	ff 45 08             	incl   0x8(%ebp)
  8011e1:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  8011e8:	eb 0d                	jmp    8011f7 <strtol+0xa0>
	else if (base == 0)
  8011ea:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8011ee:	75 07                	jne    8011f7 <strtol+0xa0>
		base = 10;
  8011f0:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8011f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8011fa:	8a 00                	mov    (%eax),%al
  8011fc:	3c 2f                	cmp    $0x2f,%al
  8011fe:	7e 19                	jle    801219 <strtol+0xc2>
  801200:	8b 45 08             	mov    0x8(%ebp),%eax
  801203:	8a 00                	mov    (%eax),%al
  801205:	3c 39                	cmp    $0x39,%al
  801207:	7f 10                	jg     801219 <strtol+0xc2>
			dig = *s - '0';
  801209:	8b 45 08             	mov    0x8(%ebp),%eax
  80120c:	8a 00                	mov    (%eax),%al
  80120e:	0f be c0             	movsbl %al,%eax
  801211:	83 e8 30             	sub    $0x30,%eax
  801214:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801217:	eb 42                	jmp    80125b <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  801219:	8b 45 08             	mov    0x8(%ebp),%eax
  80121c:	8a 00                	mov    (%eax),%al
  80121e:	3c 60                	cmp    $0x60,%al
  801220:	7e 19                	jle    80123b <strtol+0xe4>
  801222:	8b 45 08             	mov    0x8(%ebp),%eax
  801225:	8a 00                	mov    (%eax),%al
  801227:	3c 7a                	cmp    $0x7a,%al
  801229:	7f 10                	jg     80123b <strtol+0xe4>
			dig = *s - 'a' + 10;
  80122b:	8b 45 08             	mov    0x8(%ebp),%eax
  80122e:	8a 00                	mov    (%eax),%al
  801230:	0f be c0             	movsbl %al,%eax
  801233:	83 e8 57             	sub    $0x57,%eax
  801236:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801239:	eb 20                	jmp    80125b <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  80123b:	8b 45 08             	mov    0x8(%ebp),%eax
  80123e:	8a 00                	mov    (%eax),%al
  801240:	3c 40                	cmp    $0x40,%al
  801242:	7e 39                	jle    80127d <strtol+0x126>
  801244:	8b 45 08             	mov    0x8(%ebp),%eax
  801247:	8a 00                	mov    (%eax),%al
  801249:	3c 5a                	cmp    $0x5a,%al
  80124b:	7f 30                	jg     80127d <strtol+0x126>
			dig = *s - 'A' + 10;
  80124d:	8b 45 08             	mov    0x8(%ebp),%eax
  801250:	8a 00                	mov    (%eax),%al
  801252:	0f be c0             	movsbl %al,%eax
  801255:	83 e8 37             	sub    $0x37,%eax
  801258:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  80125b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80125e:	3b 45 10             	cmp    0x10(%ebp),%eax
  801261:	7d 19                	jge    80127c <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801263:	ff 45 08             	incl   0x8(%ebp)
  801266:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801269:	0f af 45 10          	imul   0x10(%ebp),%eax
  80126d:	89 c2                	mov    %eax,%edx
  80126f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801272:	01 d0                	add    %edx,%eax
  801274:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  801277:	e9 7b ff ff ff       	jmp    8011f7 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  80127c:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  80127d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801281:	74 08                	je     80128b <strtol+0x134>
		*endptr = (char *) s;
  801283:	8b 45 0c             	mov    0xc(%ebp),%eax
  801286:	8b 55 08             	mov    0x8(%ebp),%edx
  801289:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  80128b:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80128f:	74 07                	je     801298 <strtol+0x141>
  801291:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801294:	f7 d8                	neg    %eax
  801296:	eb 03                	jmp    80129b <strtol+0x144>
  801298:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  80129b:	c9                   	leave  
  80129c:	c3                   	ret    

0080129d <ltostr>:

void
ltostr(long value, char *str)
{
  80129d:	55                   	push   %ebp
  80129e:	89 e5                	mov    %esp,%ebp
  8012a0:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  8012a3:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  8012aa:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  8012b1:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8012b5:	79 13                	jns    8012ca <ltostr+0x2d>
	{
		neg = 1;
  8012b7:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  8012be:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012c1:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  8012c4:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  8012c7:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  8012ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8012cd:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8012d2:	99                   	cltd   
  8012d3:	f7 f9                	idiv   %ecx
  8012d5:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  8012d8:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8012db:	8d 50 01             	lea    0x1(%eax),%edx
  8012de:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8012e1:	89 c2                	mov    %eax,%edx
  8012e3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012e6:	01 d0                	add    %edx,%eax
  8012e8:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8012eb:	83 c2 30             	add    $0x30,%edx
  8012ee:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  8012f0:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8012f3:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8012f8:	f7 e9                	imul   %ecx
  8012fa:	c1 fa 02             	sar    $0x2,%edx
  8012fd:	89 c8                	mov    %ecx,%eax
  8012ff:	c1 f8 1f             	sar    $0x1f,%eax
  801302:	29 c2                	sub    %eax,%edx
  801304:	89 d0                	mov    %edx,%eax
  801306:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  801309:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80130d:	75 bb                	jne    8012ca <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  80130f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801316:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801319:	48                   	dec    %eax
  80131a:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  80131d:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801321:	74 3d                	je     801360 <ltostr+0xc3>
		start = 1 ;
  801323:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  80132a:	eb 34                	jmp    801360 <ltostr+0xc3>
	{
		char tmp = str[start] ;
  80132c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80132f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801332:	01 d0                	add    %edx,%eax
  801334:	8a 00                	mov    (%eax),%al
  801336:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801339:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80133c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80133f:	01 c2                	add    %eax,%edx
  801341:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801344:	8b 45 0c             	mov    0xc(%ebp),%eax
  801347:	01 c8                	add    %ecx,%eax
  801349:	8a 00                	mov    (%eax),%al
  80134b:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  80134d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801350:	8b 45 0c             	mov    0xc(%ebp),%eax
  801353:	01 c2                	add    %eax,%edx
  801355:	8a 45 eb             	mov    -0x15(%ebp),%al
  801358:	88 02                	mov    %al,(%edx)
		start++ ;
  80135a:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  80135d:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801360:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801363:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801366:	7c c4                	jl     80132c <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801368:	8b 55 f8             	mov    -0x8(%ebp),%edx
  80136b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80136e:	01 d0                	add    %edx,%eax
  801370:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801373:	90                   	nop
  801374:	c9                   	leave  
  801375:	c3                   	ret    

00801376 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  801376:	55                   	push   %ebp
  801377:	89 e5                	mov    %esp,%ebp
  801379:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  80137c:	ff 75 08             	pushl  0x8(%ebp)
  80137f:	e8 c4 f9 ff ff       	call   800d48 <strlen>
  801384:	83 c4 04             	add    $0x4,%esp
  801387:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  80138a:	ff 75 0c             	pushl  0xc(%ebp)
  80138d:	e8 b6 f9 ff ff       	call   800d48 <strlen>
  801392:	83 c4 04             	add    $0x4,%esp
  801395:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  801398:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  80139f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8013a6:	eb 17                	jmp    8013bf <strcconcat+0x49>
		final[s] = str1[s] ;
  8013a8:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8013ab:	8b 45 10             	mov    0x10(%ebp),%eax
  8013ae:	01 c2                	add    %eax,%edx
  8013b0:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8013b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8013b6:	01 c8                	add    %ecx,%eax
  8013b8:	8a 00                	mov    (%eax),%al
  8013ba:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  8013bc:	ff 45 fc             	incl   -0x4(%ebp)
  8013bf:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8013c2:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8013c5:	7c e1                	jl     8013a8 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  8013c7:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  8013ce:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8013d5:	eb 1f                	jmp    8013f6 <strcconcat+0x80>
		final[s++] = str2[i] ;
  8013d7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8013da:	8d 50 01             	lea    0x1(%eax),%edx
  8013dd:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8013e0:	89 c2                	mov    %eax,%edx
  8013e2:	8b 45 10             	mov    0x10(%ebp),%eax
  8013e5:	01 c2                	add    %eax,%edx
  8013e7:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8013ea:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013ed:	01 c8                	add    %ecx,%eax
  8013ef:	8a 00                	mov    (%eax),%al
  8013f1:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  8013f3:	ff 45 f8             	incl   -0x8(%ebp)
  8013f6:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8013f9:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8013fc:	7c d9                	jl     8013d7 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  8013fe:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801401:	8b 45 10             	mov    0x10(%ebp),%eax
  801404:	01 d0                	add    %edx,%eax
  801406:	c6 00 00             	movb   $0x0,(%eax)
}
  801409:	90                   	nop
  80140a:	c9                   	leave  
  80140b:	c3                   	ret    

0080140c <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  80140c:	55                   	push   %ebp
  80140d:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  80140f:	8b 45 14             	mov    0x14(%ebp),%eax
  801412:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801418:	8b 45 14             	mov    0x14(%ebp),%eax
  80141b:	8b 00                	mov    (%eax),%eax
  80141d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801424:	8b 45 10             	mov    0x10(%ebp),%eax
  801427:	01 d0                	add    %edx,%eax
  801429:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80142f:	eb 0c                	jmp    80143d <strsplit+0x31>
			*string++ = 0;
  801431:	8b 45 08             	mov    0x8(%ebp),%eax
  801434:	8d 50 01             	lea    0x1(%eax),%edx
  801437:	89 55 08             	mov    %edx,0x8(%ebp)
  80143a:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80143d:	8b 45 08             	mov    0x8(%ebp),%eax
  801440:	8a 00                	mov    (%eax),%al
  801442:	84 c0                	test   %al,%al
  801444:	74 18                	je     80145e <strsplit+0x52>
  801446:	8b 45 08             	mov    0x8(%ebp),%eax
  801449:	8a 00                	mov    (%eax),%al
  80144b:	0f be c0             	movsbl %al,%eax
  80144e:	50                   	push   %eax
  80144f:	ff 75 0c             	pushl  0xc(%ebp)
  801452:	e8 83 fa ff ff       	call   800eda <strchr>
  801457:	83 c4 08             	add    $0x8,%esp
  80145a:	85 c0                	test   %eax,%eax
  80145c:	75 d3                	jne    801431 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  80145e:	8b 45 08             	mov    0x8(%ebp),%eax
  801461:	8a 00                	mov    (%eax),%al
  801463:	84 c0                	test   %al,%al
  801465:	74 5a                	je     8014c1 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801467:	8b 45 14             	mov    0x14(%ebp),%eax
  80146a:	8b 00                	mov    (%eax),%eax
  80146c:	83 f8 0f             	cmp    $0xf,%eax
  80146f:	75 07                	jne    801478 <strsplit+0x6c>
		{
			return 0;
  801471:	b8 00 00 00 00       	mov    $0x0,%eax
  801476:	eb 66                	jmp    8014de <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801478:	8b 45 14             	mov    0x14(%ebp),%eax
  80147b:	8b 00                	mov    (%eax),%eax
  80147d:	8d 48 01             	lea    0x1(%eax),%ecx
  801480:	8b 55 14             	mov    0x14(%ebp),%edx
  801483:	89 0a                	mov    %ecx,(%edx)
  801485:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80148c:	8b 45 10             	mov    0x10(%ebp),%eax
  80148f:	01 c2                	add    %eax,%edx
  801491:	8b 45 08             	mov    0x8(%ebp),%eax
  801494:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801496:	eb 03                	jmp    80149b <strsplit+0x8f>
			string++;
  801498:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  80149b:	8b 45 08             	mov    0x8(%ebp),%eax
  80149e:	8a 00                	mov    (%eax),%al
  8014a0:	84 c0                	test   %al,%al
  8014a2:	74 8b                	je     80142f <strsplit+0x23>
  8014a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8014a7:	8a 00                	mov    (%eax),%al
  8014a9:	0f be c0             	movsbl %al,%eax
  8014ac:	50                   	push   %eax
  8014ad:	ff 75 0c             	pushl  0xc(%ebp)
  8014b0:	e8 25 fa ff ff       	call   800eda <strchr>
  8014b5:	83 c4 08             	add    $0x8,%esp
  8014b8:	85 c0                	test   %eax,%eax
  8014ba:	74 dc                	je     801498 <strsplit+0x8c>
			string++;
	}
  8014bc:	e9 6e ff ff ff       	jmp    80142f <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  8014c1:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  8014c2:	8b 45 14             	mov    0x14(%ebp),%eax
  8014c5:	8b 00                	mov    (%eax),%eax
  8014c7:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8014ce:	8b 45 10             	mov    0x10(%ebp),%eax
  8014d1:	01 d0                	add    %edx,%eax
  8014d3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  8014d9:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8014de:	c9                   	leave  
  8014df:	c3                   	ret    

008014e0 <str2lower>:


char* str2lower(char *dst, const char *src)
{
  8014e0:	55                   	push   %ebp
  8014e1:	89 e5                	mov    %esp,%ebp
  8014e3:	83 ec 10             	sub    $0x10,%esp
	char* ret = dst;
  8014e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8014e9:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (int i = 0; i < strlen(src); ++i)
  8014ec:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8014f3:	eb 4a                	jmp    80153f <str2lower+0x5f>
	{
		dst[i] = src[i] ;
  8014f5:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8014f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8014fb:	01 c2                	add    %eax,%edx
  8014fd:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801500:	8b 45 0c             	mov    0xc(%ebp),%eax
  801503:	01 c8                	add    %ecx,%eax
  801505:	8a 00                	mov    (%eax),%al
  801507:	88 02                	mov    %al,(%edx)
		if (src[i] >= 'A' && src[i] <= 'Z')
  801509:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80150c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80150f:	01 d0                	add    %edx,%eax
  801511:	8a 00                	mov    (%eax),%al
  801513:	3c 40                	cmp    $0x40,%al
  801515:	7e 25                	jle    80153c <str2lower+0x5c>
  801517:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80151a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80151d:	01 d0                	add    %edx,%eax
  80151f:	8a 00                	mov    (%eax),%al
  801521:	3c 5a                	cmp    $0x5a,%al
  801523:	7f 17                	jg     80153c <str2lower+0x5c>
		{
			dst[i] += 32 ;
  801525:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801528:	8b 45 08             	mov    0x8(%ebp),%eax
  80152b:	01 d0                	add    %edx,%eax
  80152d:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801530:	8b 55 08             	mov    0x8(%ebp),%edx
  801533:	01 ca                	add    %ecx,%edx
  801535:	8a 12                	mov    (%edx),%dl
  801537:	83 c2 20             	add    $0x20,%edx
  80153a:	88 10                	mov    %dl,(%eax)


char* str2lower(char *dst, const char *src)
{
	char* ret = dst;
	for (int i = 0; i < strlen(src); ++i)
  80153c:	ff 45 fc             	incl   -0x4(%ebp)
  80153f:	ff 75 0c             	pushl  0xc(%ebp)
  801542:	e8 01 f8 ff ff       	call   800d48 <strlen>
  801547:	83 c4 04             	add    $0x4,%esp
  80154a:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  80154d:	7f a6                	jg     8014f5 <str2lower+0x15>
		if (src[i] >= 'A' && src[i] <= 'Z')
		{
			dst[i] += 32 ;
		}
	}
	return ret;
  80154f:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801552:	c9                   	leave  
  801553:	c3                   	ret    

00801554 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801554:	55                   	push   %ebp
  801555:	89 e5                	mov    %esp,%ebp
  801557:	57                   	push   %edi
  801558:	56                   	push   %esi
  801559:	53                   	push   %ebx
  80155a:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80155d:	8b 45 08             	mov    0x8(%ebp),%eax
  801560:	8b 55 0c             	mov    0xc(%ebp),%edx
  801563:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801566:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801569:	8b 7d 18             	mov    0x18(%ebp),%edi
  80156c:	8b 75 1c             	mov    0x1c(%ebp),%esi
  80156f:	cd 30                	int    $0x30
  801571:	89 45 f0             	mov    %eax,-0x10(%ebp)
				"b" (a3),
				"D" (a4),
				"S" (a5)
				: "cc", "memory");

	return ret;
  801574:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801577:	83 c4 10             	add    $0x10,%esp
  80157a:	5b                   	pop    %ebx
  80157b:	5e                   	pop    %esi
  80157c:	5f                   	pop    %edi
  80157d:	5d                   	pop    %ebp
  80157e:	c3                   	ret    

0080157f <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName, int color)
{
  80157f:	55                   	push   %ebp
  801580:	89 e5                	mov    %esp,%ebp
  801582:	83 ec 04             	sub    $0x4,%esp
  801585:	8b 45 10             	mov    0x10(%ebp),%eax
  801588:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, color, 0);
  80158b:	8b 4d 14             	mov    0x14(%ebp),%ecx
  80158e:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801592:	8b 45 08             	mov    0x8(%ebp),%eax
  801595:	6a 00                	push   $0x0
  801597:	51                   	push   %ecx
  801598:	52                   	push   %edx
  801599:	ff 75 0c             	pushl  0xc(%ebp)
  80159c:	50                   	push   %eax
  80159d:	6a 00                	push   $0x0
  80159f:	e8 b0 ff ff ff       	call   801554 <syscall>
  8015a4:	83 c4 18             	add    $0x18,%esp
}
  8015a7:	90                   	nop
  8015a8:	c9                   	leave  
  8015a9:	c3                   	ret    

008015aa <sys_cgetc>:

int
sys_cgetc(void)
{
  8015aa:	55                   	push   %ebp
  8015ab:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  8015ad:	6a 00                	push   $0x0
  8015af:	6a 00                	push   $0x0
  8015b1:	6a 00                	push   $0x0
  8015b3:	6a 00                	push   $0x0
  8015b5:	6a 00                	push   $0x0
  8015b7:	6a 02                	push   $0x2
  8015b9:	e8 96 ff ff ff       	call   801554 <syscall>
  8015be:	83 c4 18             	add    $0x18,%esp
}
  8015c1:	c9                   	leave  
  8015c2:	c3                   	ret    

008015c3 <sys_lock_cons>:

void sys_lock_cons(void)
{
  8015c3:	55                   	push   %ebp
  8015c4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  8015c6:	6a 00                	push   $0x0
  8015c8:	6a 00                	push   $0x0
  8015ca:	6a 00                	push   $0x0
  8015cc:	6a 00                	push   $0x0
  8015ce:	6a 00                	push   $0x0
  8015d0:	6a 03                	push   $0x3
  8015d2:	e8 7d ff ff ff       	call   801554 <syscall>
  8015d7:	83 c4 18             	add    $0x18,%esp
}
  8015da:	90                   	nop
  8015db:	c9                   	leave  
  8015dc:	c3                   	ret    

008015dd <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  8015dd:	55                   	push   %ebp
  8015de:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  8015e0:	6a 00                	push   $0x0
  8015e2:	6a 00                	push   $0x0
  8015e4:	6a 00                	push   $0x0
  8015e6:	6a 00                	push   $0x0
  8015e8:	6a 00                	push   $0x0
  8015ea:	6a 04                	push   $0x4
  8015ec:	e8 63 ff ff ff       	call   801554 <syscall>
  8015f1:	83 c4 18             	add    $0x18,%esp
}
  8015f4:	90                   	nop
  8015f5:	c9                   	leave  
  8015f6:	c3                   	ret    

008015f7 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  8015f7:	55                   	push   %ebp
  8015f8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  8015fa:	8b 55 0c             	mov    0xc(%ebp),%edx
  8015fd:	8b 45 08             	mov    0x8(%ebp),%eax
  801600:	6a 00                	push   $0x0
  801602:	6a 00                	push   $0x0
  801604:	6a 00                	push   $0x0
  801606:	52                   	push   %edx
  801607:	50                   	push   %eax
  801608:	6a 08                	push   $0x8
  80160a:	e8 45 ff ff ff       	call   801554 <syscall>
  80160f:	83 c4 18             	add    $0x18,%esp
}
  801612:	c9                   	leave  
  801613:	c3                   	ret    

00801614 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801614:	55                   	push   %ebp
  801615:	89 e5                	mov    %esp,%ebp
  801617:	56                   	push   %esi
  801618:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801619:	8b 75 18             	mov    0x18(%ebp),%esi
  80161c:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80161f:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801622:	8b 55 0c             	mov    0xc(%ebp),%edx
  801625:	8b 45 08             	mov    0x8(%ebp),%eax
  801628:	56                   	push   %esi
  801629:	53                   	push   %ebx
  80162a:	51                   	push   %ecx
  80162b:	52                   	push   %edx
  80162c:	50                   	push   %eax
  80162d:	6a 09                	push   $0x9
  80162f:	e8 20 ff ff ff       	call   801554 <syscall>
  801634:	83 c4 18             	add    $0x18,%esp
}
  801637:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80163a:	5b                   	pop    %ebx
  80163b:	5e                   	pop    %esi
  80163c:	5d                   	pop    %ebp
  80163d:	c3                   	ret    

0080163e <__sys_unmap_frame>:

int __sys_unmap_frame(uint32 va)
{
  80163e:	55                   	push   %ebp
  80163f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, va, 0, 0, 0, 0);
  801641:	6a 00                	push   $0x0
  801643:	6a 00                	push   $0x0
  801645:	6a 00                	push   $0x0
  801647:	6a 00                	push   $0x0
  801649:	ff 75 08             	pushl  0x8(%ebp)
  80164c:	6a 0a                	push   $0xa
  80164e:	e8 01 ff ff ff       	call   801554 <syscall>
  801653:	83 c4 18             	add    $0x18,%esp
}
  801656:	c9                   	leave  
  801657:	c3                   	ret    

00801658 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801658:	55                   	push   %ebp
  801659:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  80165b:	6a 00                	push   $0x0
  80165d:	6a 00                	push   $0x0
  80165f:	6a 00                	push   $0x0
  801661:	ff 75 0c             	pushl  0xc(%ebp)
  801664:	ff 75 08             	pushl  0x8(%ebp)
  801667:	6a 0b                	push   $0xb
  801669:	e8 e6 fe ff ff       	call   801554 <syscall>
  80166e:	83 c4 18             	add    $0x18,%esp
}
  801671:	c9                   	leave  
  801672:	c3                   	ret    

00801673 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801673:	55                   	push   %ebp
  801674:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801676:	6a 00                	push   $0x0
  801678:	6a 00                	push   $0x0
  80167a:	6a 00                	push   $0x0
  80167c:	6a 00                	push   $0x0
  80167e:	6a 00                	push   $0x0
  801680:	6a 0c                	push   $0xc
  801682:	e8 cd fe ff ff       	call   801554 <syscall>
  801687:	83 c4 18             	add    $0x18,%esp
}
  80168a:	c9                   	leave  
  80168b:	c3                   	ret    

0080168c <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  80168c:	55                   	push   %ebp
  80168d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  80168f:	6a 00                	push   $0x0
  801691:	6a 00                	push   $0x0
  801693:	6a 00                	push   $0x0
  801695:	6a 00                	push   $0x0
  801697:	6a 00                	push   $0x0
  801699:	6a 0d                	push   $0xd
  80169b:	e8 b4 fe ff ff       	call   801554 <syscall>
  8016a0:	83 c4 18             	add    $0x18,%esp
}
  8016a3:	c9                   	leave  
  8016a4:	c3                   	ret    

008016a5 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  8016a5:	55                   	push   %ebp
  8016a6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  8016a8:	6a 00                	push   $0x0
  8016aa:	6a 00                	push   $0x0
  8016ac:	6a 00                	push   $0x0
  8016ae:	6a 00                	push   $0x0
  8016b0:	6a 00                	push   $0x0
  8016b2:	6a 0e                	push   $0xe
  8016b4:	e8 9b fe ff ff       	call   801554 <syscall>
  8016b9:	83 c4 18             	add    $0x18,%esp
}
  8016bc:	c9                   	leave  
  8016bd:	c3                   	ret    

008016be <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  8016be:	55                   	push   %ebp
  8016bf:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  8016c1:	6a 00                	push   $0x0
  8016c3:	6a 00                	push   $0x0
  8016c5:	6a 00                	push   $0x0
  8016c7:	6a 00                	push   $0x0
  8016c9:	6a 00                	push   $0x0
  8016cb:	6a 0f                	push   $0xf
  8016cd:	e8 82 fe ff ff       	call   801554 <syscall>
  8016d2:	83 c4 18             	add    $0x18,%esp
}
  8016d5:	c9                   	leave  
  8016d6:	c3                   	ret    

008016d7 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  8016d7:	55                   	push   %ebp
  8016d8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  8016da:	6a 00                	push   $0x0
  8016dc:	6a 00                	push   $0x0
  8016de:	6a 00                	push   $0x0
  8016e0:	6a 00                	push   $0x0
  8016e2:	ff 75 08             	pushl  0x8(%ebp)
  8016e5:	6a 10                	push   $0x10
  8016e7:	e8 68 fe ff ff       	call   801554 <syscall>
  8016ec:	83 c4 18             	add    $0x18,%esp
}
  8016ef:	c9                   	leave  
  8016f0:	c3                   	ret    

008016f1 <sys_scarce_memory>:

void sys_scarce_memory()
{
  8016f1:	55                   	push   %ebp
  8016f2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  8016f4:	6a 00                	push   $0x0
  8016f6:	6a 00                	push   $0x0
  8016f8:	6a 00                	push   $0x0
  8016fa:	6a 00                	push   $0x0
  8016fc:	6a 00                	push   $0x0
  8016fe:	6a 11                	push   $0x11
  801700:	e8 4f fe ff ff       	call   801554 <syscall>
  801705:	83 c4 18             	add    $0x18,%esp
}
  801708:	90                   	nop
  801709:	c9                   	leave  
  80170a:	c3                   	ret    

0080170b <sys_cputc>:

void
sys_cputc(const char c)
{
  80170b:	55                   	push   %ebp
  80170c:	89 e5                	mov    %esp,%ebp
  80170e:	83 ec 04             	sub    $0x4,%esp
  801711:	8b 45 08             	mov    0x8(%ebp),%eax
  801714:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801717:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  80171b:	6a 00                	push   $0x0
  80171d:	6a 00                	push   $0x0
  80171f:	6a 00                	push   $0x0
  801721:	6a 00                	push   $0x0
  801723:	50                   	push   %eax
  801724:	6a 01                	push   $0x1
  801726:	e8 29 fe ff ff       	call   801554 <syscall>
  80172b:	83 c4 18             	add    $0x18,%esp
}
  80172e:	90                   	nop
  80172f:	c9                   	leave  
  801730:	c3                   	ret    

00801731 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801731:	55                   	push   %ebp
  801732:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801734:	6a 00                	push   $0x0
  801736:	6a 00                	push   $0x0
  801738:	6a 00                	push   $0x0
  80173a:	6a 00                	push   $0x0
  80173c:	6a 00                	push   $0x0
  80173e:	6a 14                	push   $0x14
  801740:	e8 0f fe ff ff       	call   801554 <syscall>
  801745:	83 c4 18             	add    $0x18,%esp
}
  801748:	90                   	nop
  801749:	c9                   	leave  
  80174a:	c3                   	ret    

0080174b <sys_create_shared_object>:

int sys_create_shared_object(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  80174b:	55                   	push   %ebp
  80174c:	89 e5                	mov    %esp,%ebp
  80174e:	83 ec 04             	sub    $0x4,%esp
  801751:	8b 45 10             	mov    0x10(%ebp),%eax
  801754:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801757:	8b 4d 14             	mov    0x14(%ebp),%ecx
  80175a:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80175e:	8b 45 08             	mov    0x8(%ebp),%eax
  801761:	6a 00                	push   $0x0
  801763:	51                   	push   %ecx
  801764:	52                   	push   %edx
  801765:	ff 75 0c             	pushl  0xc(%ebp)
  801768:	50                   	push   %eax
  801769:	6a 15                	push   $0x15
  80176b:	e8 e4 fd ff ff       	call   801554 <syscall>
  801770:	83 c4 18             	add    $0x18,%esp
}
  801773:	c9                   	leave  
  801774:	c3                   	ret    

00801775 <sys_size_of_shared_object>:

//2017:
int sys_size_of_shared_object(int32 ownerID, char* shareName)
{
  801775:	55                   	push   %ebp
  801776:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801778:	8b 55 0c             	mov    0xc(%ebp),%edx
  80177b:	8b 45 08             	mov    0x8(%ebp),%eax
  80177e:	6a 00                	push   $0x0
  801780:	6a 00                	push   $0x0
  801782:	6a 00                	push   $0x0
  801784:	52                   	push   %edx
  801785:	50                   	push   %eax
  801786:	6a 16                	push   $0x16
  801788:	e8 c7 fd ff ff       	call   801554 <syscall>
  80178d:	83 c4 18             	add    $0x18,%esp
}
  801790:	c9                   	leave  
  801791:	c3                   	ret    

00801792 <sys_get_shared_object>:
//==========

int sys_get_shared_object(int32 ownerID, char* shareName, void* virtual_address)
{
  801792:	55                   	push   %ebp
  801793:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801795:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801798:	8b 55 0c             	mov    0xc(%ebp),%edx
  80179b:	8b 45 08             	mov    0x8(%ebp),%eax
  80179e:	6a 00                	push   $0x0
  8017a0:	6a 00                	push   $0x0
  8017a2:	51                   	push   %ecx
  8017a3:	52                   	push   %edx
  8017a4:	50                   	push   %eax
  8017a5:	6a 17                	push   $0x17
  8017a7:	e8 a8 fd ff ff       	call   801554 <syscall>
  8017ac:	83 c4 18             	add    $0x18,%esp
}
  8017af:	c9                   	leave  
  8017b0:	c3                   	ret    

008017b1 <sys_delete_shared_object>:

int sys_delete_shared_object(int32 sharedObjectID, void *startVA)
{
  8017b1:	55                   	push   %ebp
  8017b2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  8017b4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8017ba:	6a 00                	push   $0x0
  8017bc:	6a 00                	push   $0x0
  8017be:	6a 00                	push   $0x0
  8017c0:	52                   	push   %edx
  8017c1:	50                   	push   %eax
  8017c2:	6a 18                	push   $0x18
  8017c4:	e8 8b fd ff ff       	call   801554 <syscall>
  8017c9:	83 c4 18             	add    $0x18,%esp
}
  8017cc:	c9                   	leave  
  8017cd:	c3                   	ret    

008017ce <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  8017ce:	55                   	push   %ebp
  8017cf:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  8017d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8017d4:	6a 00                	push   $0x0
  8017d6:	ff 75 14             	pushl  0x14(%ebp)
  8017d9:	ff 75 10             	pushl  0x10(%ebp)
  8017dc:	ff 75 0c             	pushl  0xc(%ebp)
  8017df:	50                   	push   %eax
  8017e0:	6a 19                	push   $0x19
  8017e2:	e8 6d fd ff ff       	call   801554 <syscall>
  8017e7:	83 c4 18             	add    $0x18,%esp
}
  8017ea:	c9                   	leave  
  8017eb:	c3                   	ret    

008017ec <sys_run_env>:

void sys_run_env(int32 envId)
{
  8017ec:	55                   	push   %ebp
  8017ed:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  8017ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8017f2:	6a 00                	push   $0x0
  8017f4:	6a 00                	push   $0x0
  8017f6:	6a 00                	push   $0x0
  8017f8:	6a 00                	push   $0x0
  8017fa:	50                   	push   %eax
  8017fb:	6a 1a                	push   $0x1a
  8017fd:	e8 52 fd ff ff       	call   801554 <syscall>
  801802:	83 c4 18             	add    $0x18,%esp
}
  801805:	90                   	nop
  801806:	c9                   	leave  
  801807:	c3                   	ret    

00801808 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801808:	55                   	push   %ebp
  801809:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  80180b:	8b 45 08             	mov    0x8(%ebp),%eax
  80180e:	6a 00                	push   $0x0
  801810:	6a 00                	push   $0x0
  801812:	6a 00                	push   $0x0
  801814:	6a 00                	push   $0x0
  801816:	50                   	push   %eax
  801817:	6a 1b                	push   $0x1b
  801819:	e8 36 fd ff ff       	call   801554 <syscall>
  80181e:	83 c4 18             	add    $0x18,%esp
}
  801821:	c9                   	leave  
  801822:	c3                   	ret    

00801823 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801823:	55                   	push   %ebp
  801824:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801826:	6a 00                	push   $0x0
  801828:	6a 00                	push   $0x0
  80182a:	6a 00                	push   $0x0
  80182c:	6a 00                	push   $0x0
  80182e:	6a 00                	push   $0x0
  801830:	6a 05                	push   $0x5
  801832:	e8 1d fd ff ff       	call   801554 <syscall>
  801837:	83 c4 18             	add    $0x18,%esp
}
  80183a:	c9                   	leave  
  80183b:	c3                   	ret    

0080183c <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  80183c:	55                   	push   %ebp
  80183d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  80183f:	6a 00                	push   $0x0
  801841:	6a 00                	push   $0x0
  801843:	6a 00                	push   $0x0
  801845:	6a 00                	push   $0x0
  801847:	6a 00                	push   $0x0
  801849:	6a 06                	push   $0x6
  80184b:	e8 04 fd ff ff       	call   801554 <syscall>
  801850:	83 c4 18             	add    $0x18,%esp
}
  801853:	c9                   	leave  
  801854:	c3                   	ret    

00801855 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801855:	55                   	push   %ebp
  801856:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801858:	6a 00                	push   $0x0
  80185a:	6a 00                	push   $0x0
  80185c:	6a 00                	push   $0x0
  80185e:	6a 00                	push   $0x0
  801860:	6a 00                	push   $0x0
  801862:	6a 07                	push   $0x7
  801864:	e8 eb fc ff ff       	call   801554 <syscall>
  801869:	83 c4 18             	add    $0x18,%esp
}
  80186c:	c9                   	leave  
  80186d:	c3                   	ret    

0080186e <sys_exit_env>:


void sys_exit_env(void)
{
  80186e:	55                   	push   %ebp
  80186f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801871:	6a 00                	push   $0x0
  801873:	6a 00                	push   $0x0
  801875:	6a 00                	push   $0x0
  801877:	6a 00                	push   $0x0
  801879:	6a 00                	push   $0x0
  80187b:	6a 1c                	push   $0x1c
  80187d:	e8 d2 fc ff ff       	call   801554 <syscall>
  801882:	83 c4 18             	add    $0x18,%esp
}
  801885:	90                   	nop
  801886:	c9                   	leave  
  801887:	c3                   	ret    

00801888 <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  801888:	55                   	push   %ebp
  801889:	89 e5                	mov    %esp,%ebp
  80188b:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  80188e:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801891:	8d 50 04             	lea    0x4(%eax),%edx
  801894:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801897:	6a 00                	push   $0x0
  801899:	6a 00                	push   $0x0
  80189b:	6a 00                	push   $0x0
  80189d:	52                   	push   %edx
  80189e:	50                   	push   %eax
  80189f:	6a 1d                	push   $0x1d
  8018a1:	e8 ae fc ff ff       	call   801554 <syscall>
  8018a6:	83 c4 18             	add    $0x18,%esp
	return result;
  8018a9:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8018ac:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8018af:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8018b2:	89 01                	mov    %eax,(%ecx)
  8018b4:	89 51 04             	mov    %edx,0x4(%ecx)
}
  8018b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8018ba:	c9                   	leave  
  8018bb:	c2 04 00             	ret    $0x4

008018be <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  8018be:	55                   	push   %ebp
  8018bf:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  8018c1:	6a 00                	push   $0x0
  8018c3:	6a 00                	push   $0x0
  8018c5:	ff 75 10             	pushl  0x10(%ebp)
  8018c8:	ff 75 0c             	pushl  0xc(%ebp)
  8018cb:	ff 75 08             	pushl  0x8(%ebp)
  8018ce:	6a 13                	push   $0x13
  8018d0:	e8 7f fc ff ff       	call   801554 <syscall>
  8018d5:	83 c4 18             	add    $0x18,%esp
	return ;
  8018d8:	90                   	nop
}
  8018d9:	c9                   	leave  
  8018da:	c3                   	ret    

008018db <sys_rcr2>:
uint32 sys_rcr2()
{
  8018db:	55                   	push   %ebp
  8018dc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  8018de:	6a 00                	push   $0x0
  8018e0:	6a 00                	push   $0x0
  8018e2:	6a 00                	push   $0x0
  8018e4:	6a 00                	push   $0x0
  8018e6:	6a 00                	push   $0x0
  8018e8:	6a 1e                	push   $0x1e
  8018ea:	e8 65 fc ff ff       	call   801554 <syscall>
  8018ef:	83 c4 18             	add    $0x18,%esp
}
  8018f2:	c9                   	leave  
  8018f3:	c3                   	ret    

008018f4 <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  8018f4:	55                   	push   %ebp
  8018f5:	89 e5                	mov    %esp,%ebp
  8018f7:	83 ec 04             	sub    $0x4,%esp
  8018fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8018fd:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801900:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801904:	6a 00                	push   $0x0
  801906:	6a 00                	push   $0x0
  801908:	6a 00                	push   $0x0
  80190a:	6a 00                	push   $0x0
  80190c:	50                   	push   %eax
  80190d:	6a 1f                	push   $0x1f
  80190f:	e8 40 fc ff ff       	call   801554 <syscall>
  801914:	83 c4 18             	add    $0x18,%esp
	return ;
  801917:	90                   	nop
}
  801918:	c9                   	leave  
  801919:	c3                   	ret    

0080191a <rsttst>:
void rsttst()
{
  80191a:	55                   	push   %ebp
  80191b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  80191d:	6a 00                	push   $0x0
  80191f:	6a 00                	push   $0x0
  801921:	6a 00                	push   $0x0
  801923:	6a 00                	push   $0x0
  801925:	6a 00                	push   $0x0
  801927:	6a 21                	push   $0x21
  801929:	e8 26 fc ff ff       	call   801554 <syscall>
  80192e:	83 c4 18             	add    $0x18,%esp
	return ;
  801931:	90                   	nop
}
  801932:	c9                   	leave  
  801933:	c3                   	ret    

00801934 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801934:	55                   	push   %ebp
  801935:	89 e5                	mov    %esp,%ebp
  801937:	83 ec 04             	sub    $0x4,%esp
  80193a:	8b 45 14             	mov    0x14(%ebp),%eax
  80193d:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801940:	8b 55 18             	mov    0x18(%ebp),%edx
  801943:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801947:	52                   	push   %edx
  801948:	50                   	push   %eax
  801949:	ff 75 10             	pushl  0x10(%ebp)
  80194c:	ff 75 0c             	pushl  0xc(%ebp)
  80194f:	ff 75 08             	pushl  0x8(%ebp)
  801952:	6a 20                	push   $0x20
  801954:	e8 fb fb ff ff       	call   801554 <syscall>
  801959:	83 c4 18             	add    $0x18,%esp
	return ;
  80195c:	90                   	nop
}
  80195d:	c9                   	leave  
  80195e:	c3                   	ret    

0080195f <chktst>:
void chktst(uint32 n)
{
  80195f:	55                   	push   %ebp
  801960:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801962:	6a 00                	push   $0x0
  801964:	6a 00                	push   $0x0
  801966:	6a 00                	push   $0x0
  801968:	6a 00                	push   $0x0
  80196a:	ff 75 08             	pushl  0x8(%ebp)
  80196d:	6a 22                	push   $0x22
  80196f:	e8 e0 fb ff ff       	call   801554 <syscall>
  801974:	83 c4 18             	add    $0x18,%esp
	return ;
  801977:	90                   	nop
}
  801978:	c9                   	leave  
  801979:	c3                   	ret    

0080197a <inctst>:

void inctst()
{
  80197a:	55                   	push   %ebp
  80197b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  80197d:	6a 00                	push   $0x0
  80197f:	6a 00                	push   $0x0
  801981:	6a 00                	push   $0x0
  801983:	6a 00                	push   $0x0
  801985:	6a 00                	push   $0x0
  801987:	6a 23                	push   $0x23
  801989:	e8 c6 fb ff ff       	call   801554 <syscall>
  80198e:	83 c4 18             	add    $0x18,%esp
	return ;
  801991:	90                   	nop
}
  801992:	c9                   	leave  
  801993:	c3                   	ret    

00801994 <gettst>:
uint32 gettst()
{
  801994:	55                   	push   %ebp
  801995:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801997:	6a 00                	push   $0x0
  801999:	6a 00                	push   $0x0
  80199b:	6a 00                	push   $0x0
  80199d:	6a 00                	push   $0x0
  80199f:	6a 00                	push   $0x0
  8019a1:	6a 24                	push   $0x24
  8019a3:	e8 ac fb ff ff       	call   801554 <syscall>
  8019a8:	83 c4 18             	add    $0x18,%esp
}
  8019ab:	c9                   	leave  
  8019ac:	c3                   	ret    

008019ad <sys_get_uheap_strategy>:

/*2025*/
uint32 sys_get_uheap_strategy()
{
  8019ad:	55                   	push   %ebp
  8019ae:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8019b0:	6a 00                	push   $0x0
  8019b2:	6a 00                	push   $0x0
  8019b4:	6a 00                	push   $0x0
  8019b6:	6a 00                	push   $0x0
  8019b8:	6a 00                	push   $0x0
  8019ba:	6a 25                	push   $0x25
  8019bc:	e8 93 fb ff ff       	call   801554 <syscall>
  8019c1:	83 c4 18             	add    $0x18,%esp
  8019c4:	a3 60 b0 81 00       	mov    %eax,0x81b060
	return uheapPlaceStrategy ;
  8019c9:	a1 60 b0 81 00       	mov    0x81b060,%eax
}
  8019ce:	c9                   	leave  
  8019cf:	c3                   	ret    

008019d0 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  8019d0:	55                   	push   %ebp
  8019d1:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = heapStrategy;
  8019d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8019d6:	a3 60 b0 81 00       	mov    %eax,0x81b060
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  8019db:	6a 00                	push   $0x0
  8019dd:	6a 00                	push   $0x0
  8019df:	6a 00                	push   $0x0
  8019e1:	6a 00                	push   $0x0
  8019e3:	ff 75 08             	pushl  0x8(%ebp)
  8019e6:	6a 26                	push   $0x26
  8019e8:	e8 67 fb ff ff       	call   801554 <syscall>
  8019ed:	83 c4 18             	add    $0x18,%esp
	return ;
  8019f0:	90                   	nop
}
  8019f1:	c9                   	leave  
  8019f2:	c3                   	ret    

008019f3 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  8019f3:	55                   	push   %ebp
  8019f4:	89 e5                	mov    %esp,%ebp
  8019f6:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  8019f7:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8019fa:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8019fd:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a00:	8b 45 08             	mov    0x8(%ebp),%eax
  801a03:	6a 00                	push   $0x0
  801a05:	53                   	push   %ebx
  801a06:	51                   	push   %ecx
  801a07:	52                   	push   %edx
  801a08:	50                   	push   %eax
  801a09:	6a 27                	push   $0x27
  801a0b:	e8 44 fb ff ff       	call   801554 <syscall>
  801a10:	83 c4 18             	add    $0x18,%esp
}
  801a13:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801a16:	c9                   	leave  
  801a17:	c3                   	ret    

00801a18 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801a18:	55                   	push   %ebp
  801a19:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801a1b:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a1e:	8b 45 08             	mov    0x8(%ebp),%eax
  801a21:	6a 00                	push   $0x0
  801a23:	6a 00                	push   $0x0
  801a25:	6a 00                	push   $0x0
  801a27:	52                   	push   %edx
  801a28:	50                   	push   %eax
  801a29:	6a 28                	push   $0x28
  801a2b:	e8 24 fb ff ff       	call   801554 <syscall>
  801a30:	83 c4 18             	add    $0x18,%esp
}
  801a33:	c9                   	leave  
  801a34:	c3                   	ret    

00801a35 <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  801a35:	55                   	push   %ebp
  801a36:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  801a38:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801a3b:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a3e:	8b 45 08             	mov    0x8(%ebp),%eax
  801a41:	6a 00                	push   $0x0
  801a43:	51                   	push   %ecx
  801a44:	ff 75 10             	pushl  0x10(%ebp)
  801a47:	52                   	push   %edx
  801a48:	50                   	push   %eax
  801a49:	6a 29                	push   $0x29
  801a4b:	e8 04 fb ff ff       	call   801554 <syscall>
  801a50:	83 c4 18             	add    $0x18,%esp
}
  801a53:	c9                   	leave  
  801a54:	c3                   	ret    

00801a55 <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801a55:	55                   	push   %ebp
  801a56:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801a58:	6a 00                	push   $0x0
  801a5a:	6a 00                	push   $0x0
  801a5c:	ff 75 10             	pushl  0x10(%ebp)
  801a5f:	ff 75 0c             	pushl  0xc(%ebp)
  801a62:	ff 75 08             	pushl  0x8(%ebp)
  801a65:	6a 12                	push   $0x12
  801a67:	e8 e8 fa ff ff       	call   801554 <syscall>
  801a6c:	83 c4 18             	add    $0x18,%esp
	return ;
  801a6f:	90                   	nop
}
  801a70:	c9                   	leave  
  801a71:	c3                   	ret    

00801a72 <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  801a72:	55                   	push   %ebp
  801a73:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  801a75:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a78:	8b 45 08             	mov    0x8(%ebp),%eax
  801a7b:	6a 00                	push   $0x0
  801a7d:	6a 00                	push   $0x0
  801a7f:	6a 00                	push   $0x0
  801a81:	52                   	push   %edx
  801a82:	50                   	push   %eax
  801a83:	6a 2a                	push   $0x2a
  801a85:	e8 ca fa ff ff       	call   801554 <syscall>
  801a8a:	83 c4 18             	add    $0x18,%esp
	return;
  801a8d:	90                   	nop
}
  801a8e:	c9                   	leave  
  801a8f:	c3                   	ret    

00801a90 <sys_get_optimal_num_faults>:
/*2025*/
int sys_get_optimal_num_faults()
{
  801a90:	55                   	push   %ebp
  801a91:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_optimal_num_faults, 0, 0, 0, 0, 0);
  801a93:	6a 00                	push   $0x0
  801a95:	6a 00                	push   $0x0
  801a97:	6a 00                	push   $0x0
  801a99:	6a 00                	push   $0x0
  801a9b:	6a 00                	push   $0x0
  801a9d:	6a 2b                	push   $0x2b
  801a9f:	e8 b0 fa ff ff       	call   801554 <syscall>
  801aa4:	83 c4 18             	add    $0x18,%esp
}
  801aa7:	c9                   	leave  
  801aa8:	c3                   	ret    

00801aa9 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801aa9:	55                   	push   %ebp
  801aaa:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801aac:	6a 00                	push   $0x0
  801aae:	6a 00                	push   $0x0
  801ab0:	6a 00                	push   $0x0
  801ab2:	ff 75 0c             	pushl  0xc(%ebp)
  801ab5:	ff 75 08             	pushl  0x8(%ebp)
  801ab8:	6a 2d                	push   $0x2d
  801aba:	e8 95 fa ff ff       	call   801554 <syscall>
  801abf:	83 c4 18             	add    $0x18,%esp
	return;
  801ac2:	90                   	nop
}
  801ac3:	c9                   	leave  
  801ac4:	c3                   	ret    

00801ac5 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801ac5:	55                   	push   %ebp
  801ac6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801ac8:	6a 00                	push   $0x0
  801aca:	6a 00                	push   $0x0
  801acc:	6a 00                	push   $0x0
  801ace:	ff 75 0c             	pushl  0xc(%ebp)
  801ad1:	ff 75 08             	pushl  0x8(%ebp)
  801ad4:	6a 2c                	push   $0x2c
  801ad6:	e8 79 fa ff ff       	call   801554 <syscall>
  801adb:	83 c4 18             	add    $0x18,%esp
	return ;
  801ade:	90                   	nop
}
  801adf:	c9                   	leave  
  801ae0:	c3                   	ret    

00801ae1 <sys_env_set_priority>:


void sys_env_set_priority(int32 envID, int priority)
{
  801ae1:	55                   	push   %ebp
  801ae2:	89 e5                	mov    %esp,%ebp
  801ae4:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.IM#4] CPU SCHEDULING - #1 System Calls - Add suitable code here
	//Your code is here
	//Comment the following line
	panic("sys_env_set_priority() is not implemented yet...!!");
  801ae7:	83 ec 04             	sub    $0x4,%esp
  801aea:	68 e8 25 80 00       	push   $0x8025e8
  801aef:	68 25 01 00 00       	push   $0x125
  801af4:	68 1b 26 80 00       	push   $0x80261b
  801af9:	e8 a3 e8 ff ff       	call   8003a1 <_panic>

00801afe <env_sleep>:
#include <inc/lib.h>
#include <inc/timerreg.h>

void
env_sleep(uint32 approxMilliSeconds)
{
  801afe:	55                   	push   %ebp
  801aff:	89 e5                	mov    %esp,%ebp
  801b01:	83 ec 30             	sub    $0x30,%esp
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
  801b04:	8b 55 08             	mov    0x8(%ebp),%edx
  801b07:	89 d0                	mov    %edx,%eax
  801b09:	c1 e0 02             	shl    $0x2,%eax
  801b0c:	01 d0                	add    %edx,%eax
  801b0e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801b15:	01 d0                	add    %edx,%eax
  801b17:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801b1e:	01 d0                	add    %edx,%eax
  801b20:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801b27:	01 d0                	add    %edx,%eax
  801b29:	c1 e0 04             	shl    $0x4,%eax
  801b2c:	89 45 f8             	mov    %eax,-0x8(%ebp)
	uint32 cycles_counter =0;
  801b2f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)

static inline __attribute__((always_inline)) struct uint64 get_virtual_time_user()
{
	struct uint64 result;

	__asm __volatile("rdtsc\n"
  801b36:	0f 31                	rdtsc  
  801b38:	89 45 e8             	mov    %eax,-0x18(%ebp)
  801b3b:	89 55 ec             	mov    %edx,-0x14(%ebp)
	: "=a" (result.low), "=d" (result.hi)
	);

	return result;
  801b3e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801b41:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801b44:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801b47:	89 55 f4             	mov    %edx,-0xc(%ebp)

	/*2024*/ //USE A USER-SIDE VERSION OF THIS FUNCTION TO AVOID SLOW-DOWN THE PERFORMANCE DUE SYS_CALL (el7 :))
	//struct uint64 baseTime = sys_get_virtual_time() ;
	struct uint64 baseTime = get_virtual_time_user() ;
	while(cycles_counter<time_in_cycles)
  801b4a:	eb 46                	jmp    801b92 <env_sleep+0x94>

static inline __attribute__((always_inline)) struct uint64 get_virtual_time_user()
{
	struct uint64 result;

	__asm __volatile("rdtsc\n"
  801b4c:	0f 31                	rdtsc  
  801b4e:	89 45 d0             	mov    %eax,-0x30(%ebp)
  801b51:	89 55 d4             	mov    %edx,-0x2c(%ebp)
	: "=a" (result.low), "=d" (result.hi)
	);

	return result;
  801b54:	8b 45 d0             	mov    -0x30(%ebp),%eax
  801b57:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  801b5a:	89 45 e0             	mov    %eax,-0x20(%ebp)
  801b5d:	89 55 e4             	mov    %edx,-0x1c(%ebp)

		// update the cycles_count
		#define M32 0xffffffff
		// subtract basetime from current time
		struct uint64 res;
		res.low = (currentTime.low - baseTime.low) & M32;
  801b60:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801b63:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801b66:	29 c2                	sub    %eax,%edx
  801b68:	89 d0                	mov    %edx,%eax
  801b6a:	89 45 d8             	mov    %eax,-0x28(%ebp)
		res.hi = (currentTime.hi - baseTime.hi - (res.low > currentTime.low)) & M32;
  801b6d:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801b70:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b73:	89 d1                	mov    %edx,%ecx
  801b75:	29 c1                	sub    %eax,%ecx
  801b77:	8b 55 d8             	mov    -0x28(%ebp),%edx
  801b7a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801b7d:	39 c2                	cmp    %eax,%edx
  801b7f:	0f 97 c0             	seta   %al
  801b82:	0f b6 c0             	movzbl %al,%eax
  801b85:	29 c1                	sub    %eax,%ecx
  801b87:	89 c8                	mov    %ecx,%eax
  801b89:	89 45 dc             	mov    %eax,-0x24(%ebp)

		//update cycles_count with result
		cycles_counter = res.low;
  801b8c:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801b8f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	uint32 cycles_counter =0;

	/*2024*/ //USE A USER-SIDE VERSION OF THIS FUNCTION TO AVOID SLOW-DOWN THE PERFORMANCE DUE SYS_CALL (el7 :))
	//struct uint64 baseTime = sys_get_virtual_time() ;
	struct uint64 baseTime = get_virtual_time_user() ;
	while(cycles_counter<time_in_cycles)
  801b92:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801b95:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801b98:	72 b2                	jb     801b4c <env_sleep+0x4e>
//				,cycles_counter
//				);
	}
	//cprintf("%s [%d] wake up now!\n", myEnv->prog_name, myEnv->env_id);

}
  801b9a:	90                   	nop
  801b9b:	c9                   	leave  
  801b9c:	c3                   	ret    

00801b9d <busy_wait>:

//2017
uint32 busy_wait(uint32 loopMax)
{
  801b9d:	55                   	push   %ebp
  801b9e:	89 e5                	mov    %esp,%ebp
  801ba0:	83 ec 10             	sub    $0x10,%esp
	uint32 i = 0 ;
  801ba3:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	while (i < loopMax) i++;
  801baa:	eb 03                	jmp    801baf <busy_wait+0x12>
  801bac:	ff 45 fc             	incl   -0x4(%ebp)
  801baf:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801bb2:	3b 45 08             	cmp    0x8(%ebp),%eax
  801bb5:	72 f5                	jb     801bac <busy_wait+0xf>
	return i;
  801bb7:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801bba:	c9                   	leave  
  801bbb:	c3                   	ret    

00801bbc <__udivdi3>:
  801bbc:	55                   	push   %ebp
  801bbd:	57                   	push   %edi
  801bbe:	56                   	push   %esi
  801bbf:	53                   	push   %ebx
  801bc0:	83 ec 1c             	sub    $0x1c,%esp
  801bc3:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  801bc7:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  801bcb:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801bcf:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801bd3:	89 ca                	mov    %ecx,%edx
  801bd5:	89 f8                	mov    %edi,%eax
  801bd7:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  801bdb:	85 f6                	test   %esi,%esi
  801bdd:	75 2d                	jne    801c0c <__udivdi3+0x50>
  801bdf:	39 cf                	cmp    %ecx,%edi
  801be1:	77 65                	ja     801c48 <__udivdi3+0x8c>
  801be3:	89 fd                	mov    %edi,%ebp
  801be5:	85 ff                	test   %edi,%edi
  801be7:	75 0b                	jne    801bf4 <__udivdi3+0x38>
  801be9:	b8 01 00 00 00       	mov    $0x1,%eax
  801bee:	31 d2                	xor    %edx,%edx
  801bf0:	f7 f7                	div    %edi
  801bf2:	89 c5                	mov    %eax,%ebp
  801bf4:	31 d2                	xor    %edx,%edx
  801bf6:	89 c8                	mov    %ecx,%eax
  801bf8:	f7 f5                	div    %ebp
  801bfa:	89 c1                	mov    %eax,%ecx
  801bfc:	89 d8                	mov    %ebx,%eax
  801bfe:	f7 f5                	div    %ebp
  801c00:	89 cf                	mov    %ecx,%edi
  801c02:	89 fa                	mov    %edi,%edx
  801c04:	83 c4 1c             	add    $0x1c,%esp
  801c07:	5b                   	pop    %ebx
  801c08:	5e                   	pop    %esi
  801c09:	5f                   	pop    %edi
  801c0a:	5d                   	pop    %ebp
  801c0b:	c3                   	ret    
  801c0c:	39 ce                	cmp    %ecx,%esi
  801c0e:	77 28                	ja     801c38 <__udivdi3+0x7c>
  801c10:	0f bd fe             	bsr    %esi,%edi
  801c13:	83 f7 1f             	xor    $0x1f,%edi
  801c16:	75 40                	jne    801c58 <__udivdi3+0x9c>
  801c18:	39 ce                	cmp    %ecx,%esi
  801c1a:	72 0a                	jb     801c26 <__udivdi3+0x6a>
  801c1c:	3b 44 24 08          	cmp    0x8(%esp),%eax
  801c20:	0f 87 9e 00 00 00    	ja     801cc4 <__udivdi3+0x108>
  801c26:	b8 01 00 00 00       	mov    $0x1,%eax
  801c2b:	89 fa                	mov    %edi,%edx
  801c2d:	83 c4 1c             	add    $0x1c,%esp
  801c30:	5b                   	pop    %ebx
  801c31:	5e                   	pop    %esi
  801c32:	5f                   	pop    %edi
  801c33:	5d                   	pop    %ebp
  801c34:	c3                   	ret    
  801c35:	8d 76 00             	lea    0x0(%esi),%esi
  801c38:	31 ff                	xor    %edi,%edi
  801c3a:	31 c0                	xor    %eax,%eax
  801c3c:	89 fa                	mov    %edi,%edx
  801c3e:	83 c4 1c             	add    $0x1c,%esp
  801c41:	5b                   	pop    %ebx
  801c42:	5e                   	pop    %esi
  801c43:	5f                   	pop    %edi
  801c44:	5d                   	pop    %ebp
  801c45:	c3                   	ret    
  801c46:	66 90                	xchg   %ax,%ax
  801c48:	89 d8                	mov    %ebx,%eax
  801c4a:	f7 f7                	div    %edi
  801c4c:	31 ff                	xor    %edi,%edi
  801c4e:	89 fa                	mov    %edi,%edx
  801c50:	83 c4 1c             	add    $0x1c,%esp
  801c53:	5b                   	pop    %ebx
  801c54:	5e                   	pop    %esi
  801c55:	5f                   	pop    %edi
  801c56:	5d                   	pop    %ebp
  801c57:	c3                   	ret    
  801c58:	bd 20 00 00 00       	mov    $0x20,%ebp
  801c5d:	89 eb                	mov    %ebp,%ebx
  801c5f:	29 fb                	sub    %edi,%ebx
  801c61:	89 f9                	mov    %edi,%ecx
  801c63:	d3 e6                	shl    %cl,%esi
  801c65:	89 c5                	mov    %eax,%ebp
  801c67:	88 d9                	mov    %bl,%cl
  801c69:	d3 ed                	shr    %cl,%ebp
  801c6b:	89 e9                	mov    %ebp,%ecx
  801c6d:	09 f1                	or     %esi,%ecx
  801c6f:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  801c73:	89 f9                	mov    %edi,%ecx
  801c75:	d3 e0                	shl    %cl,%eax
  801c77:	89 c5                	mov    %eax,%ebp
  801c79:	89 d6                	mov    %edx,%esi
  801c7b:	88 d9                	mov    %bl,%cl
  801c7d:	d3 ee                	shr    %cl,%esi
  801c7f:	89 f9                	mov    %edi,%ecx
  801c81:	d3 e2                	shl    %cl,%edx
  801c83:	8b 44 24 08          	mov    0x8(%esp),%eax
  801c87:	88 d9                	mov    %bl,%cl
  801c89:	d3 e8                	shr    %cl,%eax
  801c8b:	09 c2                	or     %eax,%edx
  801c8d:	89 d0                	mov    %edx,%eax
  801c8f:	89 f2                	mov    %esi,%edx
  801c91:	f7 74 24 0c          	divl   0xc(%esp)
  801c95:	89 d6                	mov    %edx,%esi
  801c97:	89 c3                	mov    %eax,%ebx
  801c99:	f7 e5                	mul    %ebp
  801c9b:	39 d6                	cmp    %edx,%esi
  801c9d:	72 19                	jb     801cb8 <__udivdi3+0xfc>
  801c9f:	74 0b                	je     801cac <__udivdi3+0xf0>
  801ca1:	89 d8                	mov    %ebx,%eax
  801ca3:	31 ff                	xor    %edi,%edi
  801ca5:	e9 58 ff ff ff       	jmp    801c02 <__udivdi3+0x46>
  801caa:	66 90                	xchg   %ax,%ax
  801cac:	8b 54 24 08          	mov    0x8(%esp),%edx
  801cb0:	89 f9                	mov    %edi,%ecx
  801cb2:	d3 e2                	shl    %cl,%edx
  801cb4:	39 c2                	cmp    %eax,%edx
  801cb6:	73 e9                	jae    801ca1 <__udivdi3+0xe5>
  801cb8:	8d 43 ff             	lea    -0x1(%ebx),%eax
  801cbb:	31 ff                	xor    %edi,%edi
  801cbd:	e9 40 ff ff ff       	jmp    801c02 <__udivdi3+0x46>
  801cc2:	66 90                	xchg   %ax,%ax
  801cc4:	31 c0                	xor    %eax,%eax
  801cc6:	e9 37 ff ff ff       	jmp    801c02 <__udivdi3+0x46>
  801ccb:	90                   	nop

00801ccc <__umoddi3>:
  801ccc:	55                   	push   %ebp
  801ccd:	57                   	push   %edi
  801cce:	56                   	push   %esi
  801ccf:	53                   	push   %ebx
  801cd0:	83 ec 1c             	sub    $0x1c,%esp
  801cd3:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  801cd7:	8b 74 24 34          	mov    0x34(%esp),%esi
  801cdb:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801cdf:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  801ce3:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801ce7:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801ceb:	89 f3                	mov    %esi,%ebx
  801ced:	89 fa                	mov    %edi,%edx
  801cef:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801cf3:	89 34 24             	mov    %esi,(%esp)
  801cf6:	85 c0                	test   %eax,%eax
  801cf8:	75 1a                	jne    801d14 <__umoddi3+0x48>
  801cfa:	39 f7                	cmp    %esi,%edi
  801cfc:	0f 86 a2 00 00 00    	jbe    801da4 <__umoddi3+0xd8>
  801d02:	89 c8                	mov    %ecx,%eax
  801d04:	89 f2                	mov    %esi,%edx
  801d06:	f7 f7                	div    %edi
  801d08:	89 d0                	mov    %edx,%eax
  801d0a:	31 d2                	xor    %edx,%edx
  801d0c:	83 c4 1c             	add    $0x1c,%esp
  801d0f:	5b                   	pop    %ebx
  801d10:	5e                   	pop    %esi
  801d11:	5f                   	pop    %edi
  801d12:	5d                   	pop    %ebp
  801d13:	c3                   	ret    
  801d14:	39 f0                	cmp    %esi,%eax
  801d16:	0f 87 ac 00 00 00    	ja     801dc8 <__umoddi3+0xfc>
  801d1c:	0f bd e8             	bsr    %eax,%ebp
  801d1f:	83 f5 1f             	xor    $0x1f,%ebp
  801d22:	0f 84 ac 00 00 00    	je     801dd4 <__umoddi3+0x108>
  801d28:	bf 20 00 00 00       	mov    $0x20,%edi
  801d2d:	29 ef                	sub    %ebp,%edi
  801d2f:	89 fe                	mov    %edi,%esi
  801d31:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801d35:	89 e9                	mov    %ebp,%ecx
  801d37:	d3 e0                	shl    %cl,%eax
  801d39:	89 d7                	mov    %edx,%edi
  801d3b:	89 f1                	mov    %esi,%ecx
  801d3d:	d3 ef                	shr    %cl,%edi
  801d3f:	09 c7                	or     %eax,%edi
  801d41:	89 e9                	mov    %ebp,%ecx
  801d43:	d3 e2                	shl    %cl,%edx
  801d45:	89 14 24             	mov    %edx,(%esp)
  801d48:	89 d8                	mov    %ebx,%eax
  801d4a:	d3 e0                	shl    %cl,%eax
  801d4c:	89 c2                	mov    %eax,%edx
  801d4e:	8b 44 24 08          	mov    0x8(%esp),%eax
  801d52:	d3 e0                	shl    %cl,%eax
  801d54:	89 44 24 04          	mov    %eax,0x4(%esp)
  801d58:	8b 44 24 08          	mov    0x8(%esp),%eax
  801d5c:	89 f1                	mov    %esi,%ecx
  801d5e:	d3 e8                	shr    %cl,%eax
  801d60:	09 d0                	or     %edx,%eax
  801d62:	d3 eb                	shr    %cl,%ebx
  801d64:	89 da                	mov    %ebx,%edx
  801d66:	f7 f7                	div    %edi
  801d68:	89 d3                	mov    %edx,%ebx
  801d6a:	f7 24 24             	mull   (%esp)
  801d6d:	89 c6                	mov    %eax,%esi
  801d6f:	89 d1                	mov    %edx,%ecx
  801d71:	39 d3                	cmp    %edx,%ebx
  801d73:	0f 82 87 00 00 00    	jb     801e00 <__umoddi3+0x134>
  801d79:	0f 84 91 00 00 00    	je     801e10 <__umoddi3+0x144>
  801d7f:	8b 54 24 04          	mov    0x4(%esp),%edx
  801d83:	29 f2                	sub    %esi,%edx
  801d85:	19 cb                	sbb    %ecx,%ebx
  801d87:	89 d8                	mov    %ebx,%eax
  801d89:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  801d8d:	d3 e0                	shl    %cl,%eax
  801d8f:	89 e9                	mov    %ebp,%ecx
  801d91:	d3 ea                	shr    %cl,%edx
  801d93:	09 d0                	or     %edx,%eax
  801d95:	89 e9                	mov    %ebp,%ecx
  801d97:	d3 eb                	shr    %cl,%ebx
  801d99:	89 da                	mov    %ebx,%edx
  801d9b:	83 c4 1c             	add    $0x1c,%esp
  801d9e:	5b                   	pop    %ebx
  801d9f:	5e                   	pop    %esi
  801da0:	5f                   	pop    %edi
  801da1:	5d                   	pop    %ebp
  801da2:	c3                   	ret    
  801da3:	90                   	nop
  801da4:	89 fd                	mov    %edi,%ebp
  801da6:	85 ff                	test   %edi,%edi
  801da8:	75 0b                	jne    801db5 <__umoddi3+0xe9>
  801daa:	b8 01 00 00 00       	mov    $0x1,%eax
  801daf:	31 d2                	xor    %edx,%edx
  801db1:	f7 f7                	div    %edi
  801db3:	89 c5                	mov    %eax,%ebp
  801db5:	89 f0                	mov    %esi,%eax
  801db7:	31 d2                	xor    %edx,%edx
  801db9:	f7 f5                	div    %ebp
  801dbb:	89 c8                	mov    %ecx,%eax
  801dbd:	f7 f5                	div    %ebp
  801dbf:	89 d0                	mov    %edx,%eax
  801dc1:	e9 44 ff ff ff       	jmp    801d0a <__umoddi3+0x3e>
  801dc6:	66 90                	xchg   %ax,%ax
  801dc8:	89 c8                	mov    %ecx,%eax
  801dca:	89 f2                	mov    %esi,%edx
  801dcc:	83 c4 1c             	add    $0x1c,%esp
  801dcf:	5b                   	pop    %ebx
  801dd0:	5e                   	pop    %esi
  801dd1:	5f                   	pop    %edi
  801dd2:	5d                   	pop    %ebp
  801dd3:	c3                   	ret    
  801dd4:	3b 04 24             	cmp    (%esp),%eax
  801dd7:	72 06                	jb     801ddf <__umoddi3+0x113>
  801dd9:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  801ddd:	77 0f                	ja     801dee <__umoddi3+0x122>
  801ddf:	89 f2                	mov    %esi,%edx
  801de1:	29 f9                	sub    %edi,%ecx
  801de3:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  801de7:	89 14 24             	mov    %edx,(%esp)
  801dea:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801dee:	8b 44 24 04          	mov    0x4(%esp),%eax
  801df2:	8b 14 24             	mov    (%esp),%edx
  801df5:	83 c4 1c             	add    $0x1c,%esp
  801df8:	5b                   	pop    %ebx
  801df9:	5e                   	pop    %esi
  801dfa:	5f                   	pop    %edi
  801dfb:	5d                   	pop    %ebp
  801dfc:	c3                   	ret    
  801dfd:	8d 76 00             	lea    0x0(%esi),%esi
  801e00:	2b 04 24             	sub    (%esp),%eax
  801e03:	19 fa                	sbb    %edi,%edx
  801e05:	89 d1                	mov    %edx,%ecx
  801e07:	89 c6                	mov    %eax,%esi
  801e09:	e9 71 ff ff ff       	jmp    801d7f <__umoddi3+0xb3>
  801e0e:	66 90                	xchg   %ax,%ax
  801e10:	39 44 24 04          	cmp    %eax,0x4(%esp)
  801e14:	72 ea                	jb     801e00 <__umoddi3+0x134>
  801e16:	89 d9                	mov    %ebx,%ecx
  801e18:	e9 62 ff ff ff       	jmp    801d7f <__umoddi3+0xb3>
