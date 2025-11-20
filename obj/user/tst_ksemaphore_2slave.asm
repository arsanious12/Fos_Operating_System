
obj/user/tst_ksemaphore_2slave:     file format elf32-i386


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
  800031:	e8 53 01 00 00       	call   800189 <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
#include <inc/lib.h>
extern volatile bool printStats;

void
_main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	57                   	push   %edi
  80003c:	56                   	push   %esi
  80003d:	53                   	push   %ebx
  80003e:	81 ec dc 00 00 00    	sub    $0xdc,%esp
	printStats = 0;
  800044:	c7 05 00 30 80 00 00 	movl   $0x0,0x803000
  80004b:	00 00 00 
	int id = sys_getenvindex();
  80004e:	e8 a8 15 00 00       	call   8015fb <sys_getenvindex>
  800053:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	int32 parentenvID = sys_getparentenvid();
  800056:	e8 b9 15 00 00       	call   801614 <sys_getparentenvid>
  80005b:	89 45 e0             	mov    %eax,-0x20(%ebp)
	cprintf_colored(TEXT_light_blue, "Cust %d: outside the shop\n", id);
  80005e:	83 ec 04             	sub    $0x4,%esp
  800061:	ff 75 e4             	pushl  -0x1c(%ebp)
  800064:	68 e0 1d 80 00       	push   $0x801de0
  800069:	6a 09                	push   $0x9
  80006b:	e8 eb 03 00 00       	call   80045b <cprintf_colored>
  800070:	83 c4 10             	add    $0x10,%esp

	//wait_semaphore(shopCapacitySem);
	char waitCmd[64] = "__KSem@0@Wait";
  800073:	8d 45 a0             	lea    -0x60(%ebp),%eax
  800076:	bb 46 1e 80 00       	mov    $0x801e46,%ebx
  80007b:	ba 0e 00 00 00       	mov    $0xe,%edx
  800080:	89 c7                	mov    %eax,%edi
  800082:	89 de                	mov    %ebx,%esi
  800084:	89 d1                	mov    %edx,%ecx
  800086:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  800088:	8d 55 ae             	lea    -0x52(%ebp),%edx
  80008b:	b9 32 00 00 00       	mov    $0x32,%ecx
  800090:	b0 00                	mov    $0x0,%al
  800092:	89 d7                	mov    %edx,%edi
  800094:	f3 aa                	rep stos %al,%es:(%edi)
	sys_utilities(waitCmd, 0);
  800096:	83 ec 08             	sub    $0x8,%esp
  800099:	6a 00                	push   $0x0
  80009b:	8d 45 a0             	lea    -0x60(%ebp),%eax
  80009e:	50                   	push   %eax
  80009f:	e8 8d 17 00 00       	call   801831 <sys_utilities>
  8000a4:	83 c4 10             	add    $0x10,%esp
	{
		cprintf_colored(TEXT_light_cyan,"Cust %d: inside the shop\n", id) ;
  8000a7:	83 ec 04             	sub    $0x4,%esp
  8000aa:	ff 75 e4             	pushl  -0x1c(%ebp)
  8000ad:	68 fb 1d 80 00       	push   $0x801dfb
  8000b2:	6a 0b                	push   $0xb
  8000b4:	e8 a2 03 00 00       	call   80045b <cprintf_colored>
  8000b9:	83 c4 10             	add    $0x10,%esp
		env_sleep(1000) ;
  8000bc:	83 ec 0c             	sub    $0xc,%esp
  8000bf:	68 e8 03 00 00       	push   $0x3e8
  8000c4:	e8 f4 17 00 00       	call   8018bd <env_sleep>
  8000c9:	83 c4 10             	add    $0x10,%esp
	}
	char signalCmd1[64] = "__KSem@0@Signal";
  8000cc:	8d 85 60 ff ff ff    	lea    -0xa0(%ebp),%eax
  8000d2:	bb 86 1e 80 00       	mov    $0x801e86,%ebx
  8000d7:	ba 04 00 00 00       	mov    $0x4,%edx
  8000dc:	89 c7                	mov    %eax,%edi
  8000de:	89 de                	mov    %ebx,%esi
  8000e0:	89 d1                	mov    %edx,%ecx
  8000e2:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  8000e4:	8d 95 70 ff ff ff    	lea    -0x90(%ebp),%edx
  8000ea:	b9 0c 00 00 00       	mov    $0xc,%ecx
  8000ef:	b8 00 00 00 00       	mov    $0x0,%eax
  8000f4:	89 d7                	mov    %edx,%edi
  8000f6:	f3 ab                	rep stos %eax,%es:(%edi)
	sys_utilities(signalCmd1, 0);
  8000f8:	83 ec 08             	sub    $0x8,%esp
  8000fb:	6a 00                	push   $0x0
  8000fd:	8d 85 60 ff ff ff    	lea    -0xa0(%ebp),%eax
  800103:	50                   	push   %eax
  800104:	e8 28 17 00 00       	call   801831 <sys_utilities>
  800109:	83 c4 10             	add    $0x10,%esp
	//signal_semaphore(shopCapacitySem);

	cprintf_colored(TEXT_light_blue, "Cust %d: exit the shop\n", id);
  80010c:	83 ec 04             	sub    $0x4,%esp
  80010f:	ff 75 e4             	pushl  -0x1c(%ebp)
  800112:	68 15 1e 80 00       	push   $0x801e15
  800117:	6a 09                	push   $0x9
  800119:	e8 3d 03 00 00       	call   80045b <cprintf_colored>
  80011e:	83 c4 10             	add    $0x10,%esp

	char signalCmd2[64] = "__KSem@1@Signal";
  800121:	8d 85 20 ff ff ff    	lea    -0xe0(%ebp),%eax
  800127:	bb c6 1e 80 00       	mov    $0x801ec6,%ebx
  80012c:	ba 04 00 00 00       	mov    $0x4,%edx
  800131:	89 c7                	mov    %eax,%edi
  800133:	89 de                	mov    %ebx,%esi
  800135:	89 d1                	mov    %edx,%ecx
  800137:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800139:	8d 95 30 ff ff ff    	lea    -0xd0(%ebp),%edx
  80013f:	b9 0c 00 00 00       	mov    $0xc,%ecx
  800144:	b8 00 00 00 00       	mov    $0x0,%eax
  800149:	89 d7                	mov    %edx,%edi
  80014b:	f3 ab                	rep stos %eax,%es:(%edi)
	sys_utilities(signalCmd2, 0);
  80014d:	83 ec 08             	sub    $0x8,%esp
  800150:	6a 00                	push   $0x0
  800152:	8d 85 20 ff ff ff    	lea    -0xe0(%ebp),%eax
  800158:	50                   	push   %eax
  800159:	e8 d3 16 00 00       	call   801831 <sys_utilities>
  80015e:	83 c4 10             	add    $0x10,%esp
	//signal_semaphore(dependSem);

	cprintf_colored(TEXT_light_magenta, ">>> Cust %d is Finished\n", id);
  800161:	83 ec 04             	sub    $0x4,%esp
  800164:	ff 75 e4             	pushl  -0x1c(%ebp)
  800167:	68 2d 1e 80 00       	push   $0x801e2d
  80016c:	6a 0d                	push   $0xd
  80016e:	e8 e8 02 00 00       	call   80045b <cprintf_colored>
  800173:	83 c4 10             	add    $0x10,%esp
	printStats = 0;
  800176:	c7 05 00 30 80 00 00 	movl   $0x0,0x803000
  80017d:	00 00 00 

	return;
  800180:	90                   	nop
}
  800181:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800184:	5b                   	pop    %ebx
  800185:	5e                   	pop    %esi
  800186:	5f                   	pop    %edi
  800187:	5d                   	pop    %ebp
  800188:	c3                   	ret    

00800189 <libmain>:
volatile bool printStats = 1;

volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";
void
libmain(int argc, char **argv)
{
  800189:	55                   	push   %ebp
  80018a:	89 e5                	mov    %esp,%ebp
  80018c:	57                   	push   %edi
  80018d:	56                   	push   %esi
  80018e:	53                   	push   %ebx
  80018f:	83 ec 7c             	sub    $0x7c,%esp
	//printStats = 1;
	int envIndex = sys_getenvindex();
  800192:	e8 64 14 00 00       	call   8015fb <sys_getenvindex>
  800197:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	myEnv = &(envs[envIndex]);
  80019a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80019d:	89 d0                	mov    %edx,%eax
  80019f:	c1 e0 06             	shl    $0x6,%eax
  8001a2:	29 d0                	sub    %edx,%eax
  8001a4:	c1 e0 02             	shl    $0x2,%eax
  8001a7:	01 d0                	add    %edx,%eax
  8001a9:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8001b0:	01 c8                	add    %ecx,%eax
  8001b2:	c1 e0 03             	shl    $0x3,%eax
  8001b5:	01 d0                	add    %edx,%eax
  8001b7:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8001be:	29 c2                	sub    %eax,%edx
  8001c0:	8d 04 95 00 00 00 00 	lea    0x0(,%edx,4),%eax
  8001c7:	89 c2                	mov    %eax,%edx
  8001c9:	8d 82 00 00 c0 ee    	lea    -0x11400000(%edx),%eax
  8001cf:	a3 20 30 80 00       	mov    %eax,0x803020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  8001d4:	a1 20 30 80 00       	mov    0x803020,%eax
  8001d9:	8a 40 20             	mov    0x20(%eax),%al
  8001dc:	84 c0                	test   %al,%al
  8001de:	74 0d                	je     8001ed <libmain+0x64>
		binaryname = myEnv->prog_name;
  8001e0:	a1 20 30 80 00       	mov    0x803020,%eax
  8001e5:	83 c0 20             	add    $0x20,%eax
  8001e8:	a3 04 30 80 00       	mov    %eax,0x803004

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8001ed:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8001f1:	7e 0a                	jle    8001fd <libmain+0x74>
		binaryname = argv[0];
  8001f3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8001f6:	8b 00                	mov    (%eax),%eax
  8001f8:	a3 04 30 80 00       	mov    %eax,0x803004

	// call user main routine
	_main(argc, argv);
  8001fd:	83 ec 08             	sub    $0x8,%esp
  800200:	ff 75 0c             	pushl  0xc(%ebp)
  800203:	ff 75 08             	pushl  0x8(%ebp)
  800206:	e8 2d fe ff ff       	call   800038 <_main>
  80020b:	83 c4 10             	add    $0x10,%esp

	if (printStats)
  80020e:	a1 00 30 80 00       	mov    0x803000,%eax
  800213:	85 c0                	test   %eax,%eax
  800215:	0f 84 01 01 00 00    	je     80031c <libmain+0x193>
	{
		char isOPTReplCmd[100] = "__IsOPTRepl__" ;
  80021b:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  800221:	bb 00 20 80 00       	mov    $0x802000,%ebx
  800226:	ba 0e 00 00 00       	mov    $0xe,%edx
  80022b:	89 c7                	mov    %eax,%edi
  80022d:	89 de                	mov    %ebx,%esi
  80022f:	89 d1                	mov    %edx,%ecx
  800231:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  800233:	8d 55 8a             	lea    -0x76(%ebp),%edx
  800236:	b9 56 00 00 00       	mov    $0x56,%ecx
  80023b:	b0 00                	mov    $0x0,%al
  80023d:	89 d7                	mov    %edx,%edi
  80023f:	f3 aa                	rep stos %al,%es:(%edi)
		int isOPTRepl = 0;
  800241:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
		sys_utilities(isOPTReplCmd, (uint32)(&isOPTRepl));
  800248:	8d 45 e0             	lea    -0x20(%ebp),%eax
  80024b:	83 ec 08             	sub    $0x8,%esp
  80024e:	50                   	push   %eax
  80024f:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  800255:	50                   	push   %eax
  800256:	e8 d6 15 00 00       	call   801831 <sys_utilities>
  80025b:	83 c4 10             	add    $0x10,%esp

		sys_lock_cons();
  80025e:	e8 1f 11 00 00       	call   801382 <sys_lock_cons>
		{
			cprintf("**************************************\n");
  800263:	83 ec 0c             	sub    $0xc,%esp
  800266:	68 20 1f 80 00       	push   $0x801f20
  80026b:	e8 be 01 00 00       	call   80042e <cprintf>
  800270:	83 c4 10             	add    $0x10,%esp
			if (isOPTRepl)
  800273:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800276:	85 c0                	test   %eax,%eax
  800278:	74 18                	je     800292 <libmain+0x109>
			{
				cprintf("OPTIMAL number of page faults = %d\n", sys_get_optimal_num_faults());
  80027a:	e8 d0 15 00 00       	call   80184f <sys_get_optimal_num_faults>
  80027f:	83 ec 08             	sub    $0x8,%esp
  800282:	50                   	push   %eax
  800283:	68 48 1f 80 00       	push   $0x801f48
  800288:	e8 a1 01 00 00       	call   80042e <cprintf>
  80028d:	83 c4 10             	add    $0x10,%esp
  800290:	eb 59                	jmp    8002eb <libmain+0x162>
			}
			else
			{
				cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  800292:	a1 20 30 80 00       	mov    0x803020,%eax
  800297:	8b 90 50 da 01 00    	mov    0x1da50(%eax),%edx
  80029d:	a1 20 30 80 00       	mov    0x803020,%eax
  8002a2:	8b 80 40 da 01 00    	mov    0x1da40(%eax),%eax
  8002a8:	83 ec 04             	sub    $0x4,%esp
  8002ab:	52                   	push   %edx
  8002ac:	50                   	push   %eax
  8002ad:	68 6c 1f 80 00       	push   $0x801f6c
  8002b2:	e8 77 01 00 00       	call   80042e <cprintf>
  8002b7:	83 c4 10             	add    $0x10,%esp
				cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  8002ba:	a1 20 30 80 00       	mov    0x803020,%eax
  8002bf:	8b 88 64 da 01 00    	mov    0x1da64(%eax),%ecx
  8002c5:	a1 20 30 80 00       	mov    0x803020,%eax
  8002ca:	8b 90 60 da 01 00    	mov    0x1da60(%eax),%edx
  8002d0:	a1 20 30 80 00       	mov    0x803020,%eax
  8002d5:	8b 80 5c da 01 00    	mov    0x1da5c(%eax),%eax
  8002db:	51                   	push   %ecx
  8002dc:	52                   	push   %edx
  8002dd:	50                   	push   %eax
  8002de:	68 94 1f 80 00       	push   $0x801f94
  8002e3:	e8 46 01 00 00       	call   80042e <cprintf>
  8002e8:	83 c4 10             	add    $0x10,%esp
			}
			//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
			cprintf("Num of clocks = %d\n", myEnv->nClocks);
  8002eb:	a1 20 30 80 00       	mov    0x803020,%eax
  8002f0:	8b 80 68 da 01 00    	mov    0x1da68(%eax),%eax
  8002f6:	83 ec 08             	sub    $0x8,%esp
  8002f9:	50                   	push   %eax
  8002fa:	68 ec 1f 80 00       	push   $0x801fec
  8002ff:	e8 2a 01 00 00       	call   80042e <cprintf>
  800304:	83 c4 10             	add    $0x10,%esp
			cprintf("**************************************\n");
  800307:	83 ec 0c             	sub    $0xc,%esp
  80030a:	68 20 1f 80 00       	push   $0x801f20
  80030f:	e8 1a 01 00 00       	call   80042e <cprintf>
  800314:	83 c4 10             	add    $0x10,%esp
		}
		sys_unlock_cons();
  800317:	e8 80 10 00 00       	call   80139c <sys_unlock_cons>
	}

	// exit gracefully
	exit();
  80031c:	e8 1f 00 00 00       	call   800340 <exit>
}
  800321:	90                   	nop
  800322:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800325:	5b                   	pop    %ebx
  800326:	5e                   	pop    %esi
  800327:	5f                   	pop    %edi
  800328:	5d                   	pop    %ebp
  800329:	c3                   	ret    

0080032a <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  80032a:	55                   	push   %ebp
  80032b:	89 e5                	mov    %esp,%ebp
  80032d:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800330:	83 ec 0c             	sub    $0xc,%esp
  800333:	6a 00                	push   $0x0
  800335:	e8 8d 12 00 00       	call   8015c7 <sys_destroy_env>
  80033a:	83 c4 10             	add    $0x10,%esp
}
  80033d:	90                   	nop
  80033e:	c9                   	leave  
  80033f:	c3                   	ret    

00800340 <exit>:

void
exit(void)
{
  800340:	55                   	push   %ebp
  800341:	89 e5                	mov    %esp,%ebp
  800343:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  800346:	e8 e2 12 00 00       	call   80162d <sys_exit_env>
}
  80034b:	90                   	nop
  80034c:	c9                   	leave  
  80034d:	c3                   	ret    

0080034e <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  80034e:	55                   	push   %ebp
  80034f:	89 e5                	mov    %esp,%ebp
  800351:	53                   	push   %ebx
  800352:	83 ec 04             	sub    $0x4,%esp
	b->buf[b->idx++] = ch;
  800355:	8b 45 0c             	mov    0xc(%ebp),%eax
  800358:	8b 00                	mov    (%eax),%eax
  80035a:	8d 48 01             	lea    0x1(%eax),%ecx
  80035d:	8b 55 0c             	mov    0xc(%ebp),%edx
  800360:	89 0a                	mov    %ecx,(%edx)
  800362:	8b 55 08             	mov    0x8(%ebp),%edx
  800365:	88 d1                	mov    %dl,%cl
  800367:	8b 55 0c             	mov    0xc(%ebp),%edx
  80036a:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  80036e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800371:	8b 00                	mov    (%eax),%eax
  800373:	3d ff 00 00 00       	cmp    $0xff,%eax
  800378:	75 30                	jne    8003aa <putch+0x5c>
		sys_cputs(b->buf, b->idx, printProgName, curTextClr);
  80037a:	8b 15 18 b1 81 00    	mov    0x81b118,%edx
  800380:	a0 44 30 80 00       	mov    0x803044,%al
  800385:	0f b6 c0             	movzbl %al,%eax
  800388:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80038b:	8b 09                	mov    (%ecx),%ecx
  80038d:	89 cb                	mov    %ecx,%ebx
  80038f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800392:	83 c1 08             	add    $0x8,%ecx
  800395:	52                   	push   %edx
  800396:	50                   	push   %eax
  800397:	53                   	push   %ebx
  800398:	51                   	push   %ecx
  800399:	e8 a0 0f 00 00       	call   80133e <sys_cputs>
  80039e:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8003a1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003a4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8003aa:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003ad:	8b 40 04             	mov    0x4(%eax),%eax
  8003b0:	8d 50 01             	lea    0x1(%eax),%edx
  8003b3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003b6:	89 50 04             	mov    %edx,0x4(%eax)
}
  8003b9:	90                   	nop
  8003ba:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8003bd:	c9                   	leave  
  8003be:	c3                   	ret    

008003bf <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  8003bf:	55                   	push   %ebp
  8003c0:	89 e5                	mov    %esp,%ebp
  8003c2:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8003c8:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8003cf:	00 00 00 
	b.cnt = 0;
  8003d2:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8003d9:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  8003dc:	ff 75 0c             	pushl  0xc(%ebp)
  8003df:	ff 75 08             	pushl  0x8(%ebp)
  8003e2:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8003e8:	50                   	push   %eax
  8003e9:	68 4e 03 80 00       	push   $0x80034e
  8003ee:	e8 5a 02 00 00       	call   80064d <vprintfmt>
  8003f3:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName, curTextClr);
  8003f6:	8b 15 18 b1 81 00    	mov    0x81b118,%edx
  8003fc:	a0 44 30 80 00       	mov    0x803044,%al
  800401:	0f b6 c0             	movzbl %al,%eax
  800404:	8b 8d f0 fe ff ff    	mov    -0x110(%ebp),%ecx
  80040a:	52                   	push   %edx
  80040b:	50                   	push   %eax
  80040c:	51                   	push   %ecx
  80040d:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800413:	83 c0 08             	add    $0x8,%eax
  800416:	50                   	push   %eax
  800417:	e8 22 0f 00 00       	call   80133e <sys_cputs>
  80041c:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  80041f:	c6 05 44 30 80 00 00 	movb   $0x0,0x803044
	return b.cnt;
  800426:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  80042c:	c9                   	leave  
  80042d:	c3                   	ret    

0080042e <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  80042e:	55                   	push   %ebp
  80042f:	89 e5                	mov    %esp,%ebp
  800431:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800434:	c6 05 44 30 80 00 01 	movb   $0x1,0x803044
	va_start(ap, fmt);
  80043b:	8d 45 0c             	lea    0xc(%ebp),%eax
  80043e:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800441:	8b 45 08             	mov    0x8(%ebp),%eax
  800444:	83 ec 08             	sub    $0x8,%esp
  800447:	ff 75 f4             	pushl  -0xc(%ebp)
  80044a:	50                   	push   %eax
  80044b:	e8 6f ff ff ff       	call   8003bf <vcprintf>
  800450:	83 c4 10             	add    $0x10,%esp
  800453:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800456:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800459:	c9                   	leave  
  80045a:	c3                   	ret    

0080045b <cprintf_colored>:

// *************** This text coloring feature is implemented by *************
// ********** Abd-Alrahman Zedan From Team Frozen-Bytes - FCIS'24-25 ********
int cprintf_colored(int textClr, const char *fmt, ...) {
  80045b:	55                   	push   %ebp
  80045c:	89 e5                	mov    %esp,%ebp
  80045e:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800461:	c6 05 44 30 80 00 01 	movb   $0x1,0x803044
	curTextClr = (textClr << 8) ; //set text color by the given value
  800468:	8b 45 08             	mov    0x8(%ebp),%eax
  80046b:	c1 e0 08             	shl    $0x8,%eax
  80046e:	a3 18 b1 81 00       	mov    %eax,0x81b118
	va_start(ap, fmt);
  800473:	8d 45 0c             	lea    0xc(%ebp),%eax
  800476:	83 c0 04             	add    $0x4,%eax
  800479:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  80047c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80047f:	83 ec 08             	sub    $0x8,%esp
  800482:	ff 75 f4             	pushl  -0xc(%ebp)
  800485:	50                   	push   %eax
  800486:	e8 34 ff ff ff       	call   8003bf <vcprintf>
  80048b:	83 c4 10             	add    $0x10,%esp
  80048e:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);
	curTextClr = TEXT_DEFAULT_CLR; //restore default color
  800491:	c7 05 18 b1 81 00 00 	movl   $0x700,0x81b118
  800498:	07 00 00 

	return cnt;
  80049b:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80049e:	c9                   	leave  
  80049f:	c3                   	ret    

008004a0 <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  8004a0:	55                   	push   %ebp
  8004a1:	89 e5                	mov    %esp,%ebp
  8004a3:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  8004a6:	e8 d7 0e 00 00       	call   801382 <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  8004ab:	8d 45 0c             	lea    0xc(%ebp),%eax
  8004ae:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  8004b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8004b4:	83 ec 08             	sub    $0x8,%esp
  8004b7:	ff 75 f4             	pushl  -0xc(%ebp)
  8004ba:	50                   	push   %eax
  8004bb:	e8 ff fe ff ff       	call   8003bf <vcprintf>
  8004c0:	83 c4 10             	add    $0x10,%esp
  8004c3:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  8004c6:	e8 d1 0e 00 00       	call   80139c <sys_unlock_cons>
	return cnt;
  8004cb:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8004ce:	c9                   	leave  
  8004cf:	c3                   	ret    

008004d0 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8004d0:	55                   	push   %ebp
  8004d1:	89 e5                	mov    %esp,%ebp
  8004d3:	53                   	push   %ebx
  8004d4:	83 ec 14             	sub    $0x14,%esp
  8004d7:	8b 45 10             	mov    0x10(%ebp),%eax
  8004da:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8004dd:	8b 45 14             	mov    0x14(%ebp),%eax
  8004e0:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8004e3:	8b 45 18             	mov    0x18(%ebp),%eax
  8004e6:	ba 00 00 00 00       	mov    $0x0,%edx
  8004eb:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8004ee:	77 55                	ja     800545 <printnum+0x75>
  8004f0:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8004f3:	72 05                	jb     8004fa <printnum+0x2a>
  8004f5:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8004f8:	77 4b                	ja     800545 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8004fa:	8b 45 1c             	mov    0x1c(%ebp),%eax
  8004fd:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800500:	8b 45 18             	mov    0x18(%ebp),%eax
  800503:	ba 00 00 00 00       	mov    $0x0,%edx
  800508:	52                   	push   %edx
  800509:	50                   	push   %eax
  80050a:	ff 75 f4             	pushl  -0xc(%ebp)
  80050d:	ff 75 f0             	pushl  -0x10(%ebp)
  800510:	e8 57 16 00 00       	call   801b6c <__udivdi3>
  800515:	83 c4 10             	add    $0x10,%esp
  800518:	83 ec 04             	sub    $0x4,%esp
  80051b:	ff 75 20             	pushl  0x20(%ebp)
  80051e:	53                   	push   %ebx
  80051f:	ff 75 18             	pushl  0x18(%ebp)
  800522:	52                   	push   %edx
  800523:	50                   	push   %eax
  800524:	ff 75 0c             	pushl  0xc(%ebp)
  800527:	ff 75 08             	pushl  0x8(%ebp)
  80052a:	e8 a1 ff ff ff       	call   8004d0 <printnum>
  80052f:	83 c4 20             	add    $0x20,%esp
  800532:	eb 1a                	jmp    80054e <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800534:	83 ec 08             	sub    $0x8,%esp
  800537:	ff 75 0c             	pushl  0xc(%ebp)
  80053a:	ff 75 20             	pushl  0x20(%ebp)
  80053d:	8b 45 08             	mov    0x8(%ebp),%eax
  800540:	ff d0                	call   *%eax
  800542:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800545:	ff 4d 1c             	decl   0x1c(%ebp)
  800548:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  80054c:	7f e6                	jg     800534 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80054e:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800551:	bb 00 00 00 00       	mov    $0x0,%ebx
  800556:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800559:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80055c:	53                   	push   %ebx
  80055d:	51                   	push   %ecx
  80055e:	52                   	push   %edx
  80055f:	50                   	push   %eax
  800560:	e8 17 17 00 00       	call   801c7c <__umoddi3>
  800565:	83 c4 10             	add    $0x10,%esp
  800568:	05 94 22 80 00       	add    $0x802294,%eax
  80056d:	8a 00                	mov    (%eax),%al
  80056f:	0f be c0             	movsbl %al,%eax
  800572:	83 ec 08             	sub    $0x8,%esp
  800575:	ff 75 0c             	pushl  0xc(%ebp)
  800578:	50                   	push   %eax
  800579:	8b 45 08             	mov    0x8(%ebp),%eax
  80057c:	ff d0                	call   *%eax
  80057e:	83 c4 10             	add    $0x10,%esp
}
  800581:	90                   	nop
  800582:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800585:	c9                   	leave  
  800586:	c3                   	ret    

00800587 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800587:	55                   	push   %ebp
  800588:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  80058a:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  80058e:	7e 1c                	jle    8005ac <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800590:	8b 45 08             	mov    0x8(%ebp),%eax
  800593:	8b 00                	mov    (%eax),%eax
  800595:	8d 50 08             	lea    0x8(%eax),%edx
  800598:	8b 45 08             	mov    0x8(%ebp),%eax
  80059b:	89 10                	mov    %edx,(%eax)
  80059d:	8b 45 08             	mov    0x8(%ebp),%eax
  8005a0:	8b 00                	mov    (%eax),%eax
  8005a2:	83 e8 08             	sub    $0x8,%eax
  8005a5:	8b 50 04             	mov    0x4(%eax),%edx
  8005a8:	8b 00                	mov    (%eax),%eax
  8005aa:	eb 40                	jmp    8005ec <getuint+0x65>
	else if (lflag)
  8005ac:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8005b0:	74 1e                	je     8005d0 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  8005b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8005b5:	8b 00                	mov    (%eax),%eax
  8005b7:	8d 50 04             	lea    0x4(%eax),%edx
  8005ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8005bd:	89 10                	mov    %edx,(%eax)
  8005bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8005c2:	8b 00                	mov    (%eax),%eax
  8005c4:	83 e8 04             	sub    $0x4,%eax
  8005c7:	8b 00                	mov    (%eax),%eax
  8005c9:	ba 00 00 00 00       	mov    $0x0,%edx
  8005ce:	eb 1c                	jmp    8005ec <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  8005d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8005d3:	8b 00                	mov    (%eax),%eax
  8005d5:	8d 50 04             	lea    0x4(%eax),%edx
  8005d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8005db:	89 10                	mov    %edx,(%eax)
  8005dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8005e0:	8b 00                	mov    (%eax),%eax
  8005e2:	83 e8 04             	sub    $0x4,%eax
  8005e5:	8b 00                	mov    (%eax),%eax
  8005e7:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8005ec:	5d                   	pop    %ebp
  8005ed:	c3                   	ret    

008005ee <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8005ee:	55                   	push   %ebp
  8005ef:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8005f1:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8005f5:	7e 1c                	jle    800613 <getint+0x25>
		return va_arg(*ap, long long);
  8005f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8005fa:	8b 00                	mov    (%eax),%eax
  8005fc:	8d 50 08             	lea    0x8(%eax),%edx
  8005ff:	8b 45 08             	mov    0x8(%ebp),%eax
  800602:	89 10                	mov    %edx,(%eax)
  800604:	8b 45 08             	mov    0x8(%ebp),%eax
  800607:	8b 00                	mov    (%eax),%eax
  800609:	83 e8 08             	sub    $0x8,%eax
  80060c:	8b 50 04             	mov    0x4(%eax),%edx
  80060f:	8b 00                	mov    (%eax),%eax
  800611:	eb 38                	jmp    80064b <getint+0x5d>
	else if (lflag)
  800613:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800617:	74 1a                	je     800633 <getint+0x45>
		return va_arg(*ap, long);
  800619:	8b 45 08             	mov    0x8(%ebp),%eax
  80061c:	8b 00                	mov    (%eax),%eax
  80061e:	8d 50 04             	lea    0x4(%eax),%edx
  800621:	8b 45 08             	mov    0x8(%ebp),%eax
  800624:	89 10                	mov    %edx,(%eax)
  800626:	8b 45 08             	mov    0x8(%ebp),%eax
  800629:	8b 00                	mov    (%eax),%eax
  80062b:	83 e8 04             	sub    $0x4,%eax
  80062e:	8b 00                	mov    (%eax),%eax
  800630:	99                   	cltd   
  800631:	eb 18                	jmp    80064b <getint+0x5d>
	else
		return va_arg(*ap, int);
  800633:	8b 45 08             	mov    0x8(%ebp),%eax
  800636:	8b 00                	mov    (%eax),%eax
  800638:	8d 50 04             	lea    0x4(%eax),%edx
  80063b:	8b 45 08             	mov    0x8(%ebp),%eax
  80063e:	89 10                	mov    %edx,(%eax)
  800640:	8b 45 08             	mov    0x8(%ebp),%eax
  800643:	8b 00                	mov    (%eax),%eax
  800645:	83 e8 04             	sub    $0x4,%eax
  800648:	8b 00                	mov    (%eax),%eax
  80064a:	99                   	cltd   
}
  80064b:	5d                   	pop    %ebp
  80064c:	c3                   	ret    

0080064d <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  80064d:	55                   	push   %ebp
  80064e:	89 e5                	mov    %esp,%ebp
  800650:	56                   	push   %esi
  800651:	53                   	push   %ebx
  800652:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800655:	eb 17                	jmp    80066e <vprintfmt+0x21>
			if (ch == '\0')
  800657:	85 db                	test   %ebx,%ebx
  800659:	0f 84 c1 03 00 00    	je     800a20 <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  80065f:	83 ec 08             	sub    $0x8,%esp
  800662:	ff 75 0c             	pushl  0xc(%ebp)
  800665:	53                   	push   %ebx
  800666:	8b 45 08             	mov    0x8(%ebp),%eax
  800669:	ff d0                	call   *%eax
  80066b:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80066e:	8b 45 10             	mov    0x10(%ebp),%eax
  800671:	8d 50 01             	lea    0x1(%eax),%edx
  800674:	89 55 10             	mov    %edx,0x10(%ebp)
  800677:	8a 00                	mov    (%eax),%al
  800679:	0f b6 d8             	movzbl %al,%ebx
  80067c:	83 fb 25             	cmp    $0x25,%ebx
  80067f:	75 d6                	jne    800657 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800681:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800685:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  80068c:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800693:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  80069a:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8006a1:	8b 45 10             	mov    0x10(%ebp),%eax
  8006a4:	8d 50 01             	lea    0x1(%eax),%edx
  8006a7:	89 55 10             	mov    %edx,0x10(%ebp)
  8006aa:	8a 00                	mov    (%eax),%al
  8006ac:	0f b6 d8             	movzbl %al,%ebx
  8006af:	8d 43 dd             	lea    -0x23(%ebx),%eax
  8006b2:	83 f8 5b             	cmp    $0x5b,%eax
  8006b5:	0f 87 3d 03 00 00    	ja     8009f8 <vprintfmt+0x3ab>
  8006bb:	8b 04 85 b8 22 80 00 	mov    0x8022b8(,%eax,4),%eax
  8006c2:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  8006c4:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  8006c8:	eb d7                	jmp    8006a1 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8006ca:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  8006ce:	eb d1                	jmp    8006a1 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8006d0:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  8006d7:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8006da:	89 d0                	mov    %edx,%eax
  8006dc:	c1 e0 02             	shl    $0x2,%eax
  8006df:	01 d0                	add    %edx,%eax
  8006e1:	01 c0                	add    %eax,%eax
  8006e3:	01 d8                	add    %ebx,%eax
  8006e5:	83 e8 30             	sub    $0x30,%eax
  8006e8:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  8006eb:	8b 45 10             	mov    0x10(%ebp),%eax
  8006ee:	8a 00                	mov    (%eax),%al
  8006f0:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8006f3:	83 fb 2f             	cmp    $0x2f,%ebx
  8006f6:	7e 3e                	jle    800736 <vprintfmt+0xe9>
  8006f8:	83 fb 39             	cmp    $0x39,%ebx
  8006fb:	7f 39                	jg     800736 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8006fd:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800700:	eb d5                	jmp    8006d7 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800702:	8b 45 14             	mov    0x14(%ebp),%eax
  800705:	83 c0 04             	add    $0x4,%eax
  800708:	89 45 14             	mov    %eax,0x14(%ebp)
  80070b:	8b 45 14             	mov    0x14(%ebp),%eax
  80070e:	83 e8 04             	sub    $0x4,%eax
  800711:	8b 00                	mov    (%eax),%eax
  800713:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800716:	eb 1f                	jmp    800737 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800718:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80071c:	79 83                	jns    8006a1 <vprintfmt+0x54>
				width = 0;
  80071e:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800725:	e9 77 ff ff ff       	jmp    8006a1 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  80072a:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800731:	e9 6b ff ff ff       	jmp    8006a1 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800736:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800737:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80073b:	0f 89 60 ff ff ff    	jns    8006a1 <vprintfmt+0x54>
				width = precision, precision = -1;
  800741:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800744:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800747:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  80074e:	e9 4e ff ff ff       	jmp    8006a1 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800753:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800756:	e9 46 ff ff ff       	jmp    8006a1 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  80075b:	8b 45 14             	mov    0x14(%ebp),%eax
  80075e:	83 c0 04             	add    $0x4,%eax
  800761:	89 45 14             	mov    %eax,0x14(%ebp)
  800764:	8b 45 14             	mov    0x14(%ebp),%eax
  800767:	83 e8 04             	sub    $0x4,%eax
  80076a:	8b 00                	mov    (%eax),%eax
  80076c:	83 ec 08             	sub    $0x8,%esp
  80076f:	ff 75 0c             	pushl  0xc(%ebp)
  800772:	50                   	push   %eax
  800773:	8b 45 08             	mov    0x8(%ebp),%eax
  800776:	ff d0                	call   *%eax
  800778:	83 c4 10             	add    $0x10,%esp
			break;
  80077b:	e9 9b 02 00 00       	jmp    800a1b <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800780:	8b 45 14             	mov    0x14(%ebp),%eax
  800783:	83 c0 04             	add    $0x4,%eax
  800786:	89 45 14             	mov    %eax,0x14(%ebp)
  800789:	8b 45 14             	mov    0x14(%ebp),%eax
  80078c:	83 e8 04             	sub    $0x4,%eax
  80078f:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800791:	85 db                	test   %ebx,%ebx
  800793:	79 02                	jns    800797 <vprintfmt+0x14a>
				err = -err;
  800795:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800797:	83 fb 64             	cmp    $0x64,%ebx
  80079a:	7f 0b                	jg     8007a7 <vprintfmt+0x15a>
  80079c:	8b 34 9d 00 21 80 00 	mov    0x802100(,%ebx,4),%esi
  8007a3:	85 f6                	test   %esi,%esi
  8007a5:	75 19                	jne    8007c0 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  8007a7:	53                   	push   %ebx
  8007a8:	68 a5 22 80 00       	push   $0x8022a5
  8007ad:	ff 75 0c             	pushl  0xc(%ebp)
  8007b0:	ff 75 08             	pushl  0x8(%ebp)
  8007b3:	e8 70 02 00 00       	call   800a28 <printfmt>
  8007b8:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  8007bb:	e9 5b 02 00 00       	jmp    800a1b <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  8007c0:	56                   	push   %esi
  8007c1:	68 ae 22 80 00       	push   $0x8022ae
  8007c6:	ff 75 0c             	pushl  0xc(%ebp)
  8007c9:	ff 75 08             	pushl  0x8(%ebp)
  8007cc:	e8 57 02 00 00       	call   800a28 <printfmt>
  8007d1:	83 c4 10             	add    $0x10,%esp
			break;
  8007d4:	e9 42 02 00 00       	jmp    800a1b <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  8007d9:	8b 45 14             	mov    0x14(%ebp),%eax
  8007dc:	83 c0 04             	add    $0x4,%eax
  8007df:	89 45 14             	mov    %eax,0x14(%ebp)
  8007e2:	8b 45 14             	mov    0x14(%ebp),%eax
  8007e5:	83 e8 04             	sub    $0x4,%eax
  8007e8:	8b 30                	mov    (%eax),%esi
  8007ea:	85 f6                	test   %esi,%esi
  8007ec:	75 05                	jne    8007f3 <vprintfmt+0x1a6>
				p = "(null)";
  8007ee:	be b1 22 80 00       	mov    $0x8022b1,%esi
			if (width > 0 && padc != '-')
  8007f3:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8007f7:	7e 6d                	jle    800866 <vprintfmt+0x219>
  8007f9:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  8007fd:	74 67                	je     800866 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  8007ff:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800802:	83 ec 08             	sub    $0x8,%esp
  800805:	50                   	push   %eax
  800806:	56                   	push   %esi
  800807:	e8 1e 03 00 00       	call   800b2a <strnlen>
  80080c:	83 c4 10             	add    $0x10,%esp
  80080f:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800812:	eb 16                	jmp    80082a <vprintfmt+0x1dd>
					putch(padc, putdat);
  800814:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800818:	83 ec 08             	sub    $0x8,%esp
  80081b:	ff 75 0c             	pushl  0xc(%ebp)
  80081e:	50                   	push   %eax
  80081f:	8b 45 08             	mov    0x8(%ebp),%eax
  800822:	ff d0                	call   *%eax
  800824:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800827:	ff 4d e4             	decl   -0x1c(%ebp)
  80082a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80082e:	7f e4                	jg     800814 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800830:	eb 34                	jmp    800866 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800832:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800836:	74 1c                	je     800854 <vprintfmt+0x207>
  800838:	83 fb 1f             	cmp    $0x1f,%ebx
  80083b:	7e 05                	jle    800842 <vprintfmt+0x1f5>
  80083d:	83 fb 7e             	cmp    $0x7e,%ebx
  800840:	7e 12                	jle    800854 <vprintfmt+0x207>
					putch('?', putdat);
  800842:	83 ec 08             	sub    $0x8,%esp
  800845:	ff 75 0c             	pushl  0xc(%ebp)
  800848:	6a 3f                	push   $0x3f
  80084a:	8b 45 08             	mov    0x8(%ebp),%eax
  80084d:	ff d0                	call   *%eax
  80084f:	83 c4 10             	add    $0x10,%esp
  800852:	eb 0f                	jmp    800863 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800854:	83 ec 08             	sub    $0x8,%esp
  800857:	ff 75 0c             	pushl  0xc(%ebp)
  80085a:	53                   	push   %ebx
  80085b:	8b 45 08             	mov    0x8(%ebp),%eax
  80085e:	ff d0                	call   *%eax
  800860:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800863:	ff 4d e4             	decl   -0x1c(%ebp)
  800866:	89 f0                	mov    %esi,%eax
  800868:	8d 70 01             	lea    0x1(%eax),%esi
  80086b:	8a 00                	mov    (%eax),%al
  80086d:	0f be d8             	movsbl %al,%ebx
  800870:	85 db                	test   %ebx,%ebx
  800872:	74 24                	je     800898 <vprintfmt+0x24b>
  800874:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800878:	78 b8                	js     800832 <vprintfmt+0x1e5>
  80087a:	ff 4d e0             	decl   -0x20(%ebp)
  80087d:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800881:	79 af                	jns    800832 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800883:	eb 13                	jmp    800898 <vprintfmt+0x24b>
				putch(' ', putdat);
  800885:	83 ec 08             	sub    $0x8,%esp
  800888:	ff 75 0c             	pushl  0xc(%ebp)
  80088b:	6a 20                	push   $0x20
  80088d:	8b 45 08             	mov    0x8(%ebp),%eax
  800890:	ff d0                	call   *%eax
  800892:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800895:	ff 4d e4             	decl   -0x1c(%ebp)
  800898:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80089c:	7f e7                	jg     800885 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  80089e:	e9 78 01 00 00       	jmp    800a1b <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  8008a3:	83 ec 08             	sub    $0x8,%esp
  8008a6:	ff 75 e8             	pushl  -0x18(%ebp)
  8008a9:	8d 45 14             	lea    0x14(%ebp),%eax
  8008ac:	50                   	push   %eax
  8008ad:	e8 3c fd ff ff       	call   8005ee <getint>
  8008b2:	83 c4 10             	add    $0x10,%esp
  8008b5:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8008b8:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  8008bb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8008be:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8008c1:	85 d2                	test   %edx,%edx
  8008c3:	79 23                	jns    8008e8 <vprintfmt+0x29b>
				putch('-', putdat);
  8008c5:	83 ec 08             	sub    $0x8,%esp
  8008c8:	ff 75 0c             	pushl  0xc(%ebp)
  8008cb:	6a 2d                	push   $0x2d
  8008cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8008d0:	ff d0                	call   *%eax
  8008d2:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  8008d5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8008d8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8008db:	f7 d8                	neg    %eax
  8008dd:	83 d2 00             	adc    $0x0,%edx
  8008e0:	f7 da                	neg    %edx
  8008e2:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8008e5:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  8008e8:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8008ef:	e9 bc 00 00 00       	jmp    8009b0 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  8008f4:	83 ec 08             	sub    $0x8,%esp
  8008f7:	ff 75 e8             	pushl  -0x18(%ebp)
  8008fa:	8d 45 14             	lea    0x14(%ebp),%eax
  8008fd:	50                   	push   %eax
  8008fe:	e8 84 fc ff ff       	call   800587 <getuint>
  800903:	83 c4 10             	add    $0x10,%esp
  800906:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800909:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  80090c:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800913:	e9 98 00 00 00       	jmp    8009b0 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800918:	83 ec 08             	sub    $0x8,%esp
  80091b:	ff 75 0c             	pushl  0xc(%ebp)
  80091e:	6a 58                	push   $0x58
  800920:	8b 45 08             	mov    0x8(%ebp),%eax
  800923:	ff d0                	call   *%eax
  800925:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800928:	83 ec 08             	sub    $0x8,%esp
  80092b:	ff 75 0c             	pushl  0xc(%ebp)
  80092e:	6a 58                	push   $0x58
  800930:	8b 45 08             	mov    0x8(%ebp),%eax
  800933:	ff d0                	call   *%eax
  800935:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800938:	83 ec 08             	sub    $0x8,%esp
  80093b:	ff 75 0c             	pushl  0xc(%ebp)
  80093e:	6a 58                	push   $0x58
  800940:	8b 45 08             	mov    0x8(%ebp),%eax
  800943:	ff d0                	call   *%eax
  800945:	83 c4 10             	add    $0x10,%esp
			break;
  800948:	e9 ce 00 00 00       	jmp    800a1b <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  80094d:	83 ec 08             	sub    $0x8,%esp
  800950:	ff 75 0c             	pushl  0xc(%ebp)
  800953:	6a 30                	push   $0x30
  800955:	8b 45 08             	mov    0x8(%ebp),%eax
  800958:	ff d0                	call   *%eax
  80095a:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  80095d:	83 ec 08             	sub    $0x8,%esp
  800960:	ff 75 0c             	pushl  0xc(%ebp)
  800963:	6a 78                	push   $0x78
  800965:	8b 45 08             	mov    0x8(%ebp),%eax
  800968:	ff d0                	call   *%eax
  80096a:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  80096d:	8b 45 14             	mov    0x14(%ebp),%eax
  800970:	83 c0 04             	add    $0x4,%eax
  800973:	89 45 14             	mov    %eax,0x14(%ebp)
  800976:	8b 45 14             	mov    0x14(%ebp),%eax
  800979:	83 e8 04             	sub    $0x4,%eax
  80097c:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  80097e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800981:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800988:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  80098f:	eb 1f                	jmp    8009b0 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800991:	83 ec 08             	sub    $0x8,%esp
  800994:	ff 75 e8             	pushl  -0x18(%ebp)
  800997:	8d 45 14             	lea    0x14(%ebp),%eax
  80099a:	50                   	push   %eax
  80099b:	e8 e7 fb ff ff       	call   800587 <getuint>
  8009a0:	83 c4 10             	add    $0x10,%esp
  8009a3:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8009a6:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  8009a9:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  8009b0:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  8009b4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8009b7:	83 ec 04             	sub    $0x4,%esp
  8009ba:	52                   	push   %edx
  8009bb:	ff 75 e4             	pushl  -0x1c(%ebp)
  8009be:	50                   	push   %eax
  8009bf:	ff 75 f4             	pushl  -0xc(%ebp)
  8009c2:	ff 75 f0             	pushl  -0x10(%ebp)
  8009c5:	ff 75 0c             	pushl  0xc(%ebp)
  8009c8:	ff 75 08             	pushl  0x8(%ebp)
  8009cb:	e8 00 fb ff ff       	call   8004d0 <printnum>
  8009d0:	83 c4 20             	add    $0x20,%esp
			break;
  8009d3:	eb 46                	jmp    800a1b <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  8009d5:	83 ec 08             	sub    $0x8,%esp
  8009d8:	ff 75 0c             	pushl  0xc(%ebp)
  8009db:	53                   	push   %ebx
  8009dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8009df:	ff d0                	call   *%eax
  8009e1:	83 c4 10             	add    $0x10,%esp
			break;
  8009e4:	eb 35                	jmp    800a1b <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  8009e6:	c6 05 44 30 80 00 00 	movb   $0x0,0x803044
			break;
  8009ed:	eb 2c                	jmp    800a1b <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  8009ef:	c6 05 44 30 80 00 01 	movb   $0x1,0x803044
			break;
  8009f6:	eb 23                	jmp    800a1b <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  8009f8:	83 ec 08             	sub    $0x8,%esp
  8009fb:	ff 75 0c             	pushl  0xc(%ebp)
  8009fe:	6a 25                	push   $0x25
  800a00:	8b 45 08             	mov    0x8(%ebp),%eax
  800a03:	ff d0                	call   *%eax
  800a05:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800a08:	ff 4d 10             	decl   0x10(%ebp)
  800a0b:	eb 03                	jmp    800a10 <vprintfmt+0x3c3>
  800a0d:	ff 4d 10             	decl   0x10(%ebp)
  800a10:	8b 45 10             	mov    0x10(%ebp),%eax
  800a13:	48                   	dec    %eax
  800a14:	8a 00                	mov    (%eax),%al
  800a16:	3c 25                	cmp    $0x25,%al
  800a18:	75 f3                	jne    800a0d <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  800a1a:	90                   	nop
		}
	}
  800a1b:	e9 35 fc ff ff       	jmp    800655 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800a20:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800a21:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800a24:	5b                   	pop    %ebx
  800a25:	5e                   	pop    %esi
  800a26:	5d                   	pop    %ebp
  800a27:	c3                   	ret    

00800a28 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800a28:	55                   	push   %ebp
  800a29:	89 e5                	mov    %esp,%ebp
  800a2b:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800a2e:	8d 45 10             	lea    0x10(%ebp),%eax
  800a31:	83 c0 04             	add    $0x4,%eax
  800a34:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800a37:	8b 45 10             	mov    0x10(%ebp),%eax
  800a3a:	ff 75 f4             	pushl  -0xc(%ebp)
  800a3d:	50                   	push   %eax
  800a3e:	ff 75 0c             	pushl  0xc(%ebp)
  800a41:	ff 75 08             	pushl  0x8(%ebp)
  800a44:	e8 04 fc ff ff       	call   80064d <vprintfmt>
  800a49:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800a4c:	90                   	nop
  800a4d:	c9                   	leave  
  800a4e:	c3                   	ret    

00800a4f <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800a4f:	55                   	push   %ebp
  800a50:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800a52:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a55:	8b 40 08             	mov    0x8(%eax),%eax
  800a58:	8d 50 01             	lea    0x1(%eax),%edx
  800a5b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a5e:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800a61:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a64:	8b 10                	mov    (%eax),%edx
  800a66:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a69:	8b 40 04             	mov    0x4(%eax),%eax
  800a6c:	39 c2                	cmp    %eax,%edx
  800a6e:	73 12                	jae    800a82 <sprintputch+0x33>
		*b->buf++ = ch;
  800a70:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a73:	8b 00                	mov    (%eax),%eax
  800a75:	8d 48 01             	lea    0x1(%eax),%ecx
  800a78:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a7b:	89 0a                	mov    %ecx,(%edx)
  800a7d:	8b 55 08             	mov    0x8(%ebp),%edx
  800a80:	88 10                	mov    %dl,(%eax)
}
  800a82:	90                   	nop
  800a83:	5d                   	pop    %ebp
  800a84:	c3                   	ret    

00800a85 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800a85:	55                   	push   %ebp
  800a86:	89 e5                	mov    %esp,%ebp
  800a88:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800a8b:	8b 45 08             	mov    0x8(%ebp),%eax
  800a8e:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800a91:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a94:	8d 50 ff             	lea    -0x1(%eax),%edx
  800a97:	8b 45 08             	mov    0x8(%ebp),%eax
  800a9a:	01 d0                	add    %edx,%eax
  800a9c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a9f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800aa6:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800aaa:	74 06                	je     800ab2 <vsnprintf+0x2d>
  800aac:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800ab0:	7f 07                	jg     800ab9 <vsnprintf+0x34>
		return -E_INVAL;
  800ab2:	b8 03 00 00 00       	mov    $0x3,%eax
  800ab7:	eb 20                	jmp    800ad9 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800ab9:	ff 75 14             	pushl  0x14(%ebp)
  800abc:	ff 75 10             	pushl  0x10(%ebp)
  800abf:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800ac2:	50                   	push   %eax
  800ac3:	68 4f 0a 80 00       	push   $0x800a4f
  800ac8:	e8 80 fb ff ff       	call   80064d <vprintfmt>
  800acd:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800ad0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800ad3:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800ad6:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800ad9:	c9                   	leave  
  800ada:	c3                   	ret    

00800adb <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800adb:	55                   	push   %ebp
  800adc:	89 e5                	mov    %esp,%ebp
  800ade:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800ae1:	8d 45 10             	lea    0x10(%ebp),%eax
  800ae4:	83 c0 04             	add    $0x4,%eax
  800ae7:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800aea:	8b 45 10             	mov    0x10(%ebp),%eax
  800aed:	ff 75 f4             	pushl  -0xc(%ebp)
  800af0:	50                   	push   %eax
  800af1:	ff 75 0c             	pushl  0xc(%ebp)
  800af4:	ff 75 08             	pushl  0x8(%ebp)
  800af7:	e8 89 ff ff ff       	call   800a85 <vsnprintf>
  800afc:	83 c4 10             	add    $0x10,%esp
  800aff:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800b02:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800b05:	c9                   	leave  
  800b06:	c3                   	ret    

00800b07 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800b07:	55                   	push   %ebp
  800b08:	89 e5                	mov    %esp,%ebp
  800b0a:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800b0d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800b14:	eb 06                	jmp    800b1c <strlen+0x15>
		n++;
  800b16:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800b19:	ff 45 08             	incl   0x8(%ebp)
  800b1c:	8b 45 08             	mov    0x8(%ebp),%eax
  800b1f:	8a 00                	mov    (%eax),%al
  800b21:	84 c0                	test   %al,%al
  800b23:	75 f1                	jne    800b16 <strlen+0xf>
		n++;
	return n;
  800b25:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800b28:	c9                   	leave  
  800b29:	c3                   	ret    

00800b2a <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800b2a:	55                   	push   %ebp
  800b2b:	89 e5                	mov    %esp,%ebp
  800b2d:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800b30:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800b37:	eb 09                	jmp    800b42 <strnlen+0x18>
		n++;
  800b39:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800b3c:	ff 45 08             	incl   0x8(%ebp)
  800b3f:	ff 4d 0c             	decl   0xc(%ebp)
  800b42:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800b46:	74 09                	je     800b51 <strnlen+0x27>
  800b48:	8b 45 08             	mov    0x8(%ebp),%eax
  800b4b:	8a 00                	mov    (%eax),%al
  800b4d:	84 c0                	test   %al,%al
  800b4f:	75 e8                	jne    800b39 <strnlen+0xf>
		n++;
	return n;
  800b51:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800b54:	c9                   	leave  
  800b55:	c3                   	ret    

00800b56 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800b56:	55                   	push   %ebp
  800b57:	89 e5                	mov    %esp,%ebp
  800b59:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800b5c:	8b 45 08             	mov    0x8(%ebp),%eax
  800b5f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800b62:	90                   	nop
  800b63:	8b 45 08             	mov    0x8(%ebp),%eax
  800b66:	8d 50 01             	lea    0x1(%eax),%edx
  800b69:	89 55 08             	mov    %edx,0x8(%ebp)
  800b6c:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b6f:	8d 4a 01             	lea    0x1(%edx),%ecx
  800b72:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800b75:	8a 12                	mov    (%edx),%dl
  800b77:	88 10                	mov    %dl,(%eax)
  800b79:	8a 00                	mov    (%eax),%al
  800b7b:	84 c0                	test   %al,%al
  800b7d:	75 e4                	jne    800b63 <strcpy+0xd>
		/* do nothing */;
	return ret;
  800b7f:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800b82:	c9                   	leave  
  800b83:	c3                   	ret    

00800b84 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800b84:	55                   	push   %ebp
  800b85:	89 e5                	mov    %esp,%ebp
  800b87:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800b8a:	8b 45 08             	mov    0x8(%ebp),%eax
  800b8d:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800b90:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800b97:	eb 1f                	jmp    800bb8 <strncpy+0x34>
		*dst++ = *src;
  800b99:	8b 45 08             	mov    0x8(%ebp),%eax
  800b9c:	8d 50 01             	lea    0x1(%eax),%edx
  800b9f:	89 55 08             	mov    %edx,0x8(%ebp)
  800ba2:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ba5:	8a 12                	mov    (%edx),%dl
  800ba7:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800ba9:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bac:	8a 00                	mov    (%eax),%al
  800bae:	84 c0                	test   %al,%al
  800bb0:	74 03                	je     800bb5 <strncpy+0x31>
			src++;
  800bb2:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800bb5:	ff 45 fc             	incl   -0x4(%ebp)
  800bb8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800bbb:	3b 45 10             	cmp    0x10(%ebp),%eax
  800bbe:	72 d9                	jb     800b99 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800bc0:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800bc3:	c9                   	leave  
  800bc4:	c3                   	ret    

00800bc5 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800bc5:	55                   	push   %ebp
  800bc6:	89 e5                	mov    %esp,%ebp
  800bc8:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800bcb:	8b 45 08             	mov    0x8(%ebp),%eax
  800bce:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800bd1:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800bd5:	74 30                	je     800c07 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800bd7:	eb 16                	jmp    800bef <strlcpy+0x2a>
			*dst++ = *src++;
  800bd9:	8b 45 08             	mov    0x8(%ebp),%eax
  800bdc:	8d 50 01             	lea    0x1(%eax),%edx
  800bdf:	89 55 08             	mov    %edx,0x8(%ebp)
  800be2:	8b 55 0c             	mov    0xc(%ebp),%edx
  800be5:	8d 4a 01             	lea    0x1(%edx),%ecx
  800be8:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800beb:	8a 12                	mov    (%edx),%dl
  800bed:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800bef:	ff 4d 10             	decl   0x10(%ebp)
  800bf2:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800bf6:	74 09                	je     800c01 <strlcpy+0x3c>
  800bf8:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bfb:	8a 00                	mov    (%eax),%al
  800bfd:	84 c0                	test   %al,%al
  800bff:	75 d8                	jne    800bd9 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800c01:	8b 45 08             	mov    0x8(%ebp),%eax
  800c04:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800c07:	8b 55 08             	mov    0x8(%ebp),%edx
  800c0a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800c0d:	29 c2                	sub    %eax,%edx
  800c0f:	89 d0                	mov    %edx,%eax
}
  800c11:	c9                   	leave  
  800c12:	c3                   	ret    

00800c13 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800c13:	55                   	push   %ebp
  800c14:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800c16:	eb 06                	jmp    800c1e <strcmp+0xb>
		p++, q++;
  800c18:	ff 45 08             	incl   0x8(%ebp)
  800c1b:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800c1e:	8b 45 08             	mov    0x8(%ebp),%eax
  800c21:	8a 00                	mov    (%eax),%al
  800c23:	84 c0                	test   %al,%al
  800c25:	74 0e                	je     800c35 <strcmp+0x22>
  800c27:	8b 45 08             	mov    0x8(%ebp),%eax
  800c2a:	8a 10                	mov    (%eax),%dl
  800c2c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c2f:	8a 00                	mov    (%eax),%al
  800c31:	38 c2                	cmp    %al,%dl
  800c33:	74 e3                	je     800c18 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800c35:	8b 45 08             	mov    0x8(%ebp),%eax
  800c38:	8a 00                	mov    (%eax),%al
  800c3a:	0f b6 d0             	movzbl %al,%edx
  800c3d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c40:	8a 00                	mov    (%eax),%al
  800c42:	0f b6 c0             	movzbl %al,%eax
  800c45:	29 c2                	sub    %eax,%edx
  800c47:	89 d0                	mov    %edx,%eax
}
  800c49:	5d                   	pop    %ebp
  800c4a:	c3                   	ret    

00800c4b <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800c4b:	55                   	push   %ebp
  800c4c:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800c4e:	eb 09                	jmp    800c59 <strncmp+0xe>
		n--, p++, q++;
  800c50:	ff 4d 10             	decl   0x10(%ebp)
  800c53:	ff 45 08             	incl   0x8(%ebp)
  800c56:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800c59:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800c5d:	74 17                	je     800c76 <strncmp+0x2b>
  800c5f:	8b 45 08             	mov    0x8(%ebp),%eax
  800c62:	8a 00                	mov    (%eax),%al
  800c64:	84 c0                	test   %al,%al
  800c66:	74 0e                	je     800c76 <strncmp+0x2b>
  800c68:	8b 45 08             	mov    0x8(%ebp),%eax
  800c6b:	8a 10                	mov    (%eax),%dl
  800c6d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c70:	8a 00                	mov    (%eax),%al
  800c72:	38 c2                	cmp    %al,%dl
  800c74:	74 da                	je     800c50 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800c76:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800c7a:	75 07                	jne    800c83 <strncmp+0x38>
		return 0;
  800c7c:	b8 00 00 00 00       	mov    $0x0,%eax
  800c81:	eb 14                	jmp    800c97 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800c83:	8b 45 08             	mov    0x8(%ebp),%eax
  800c86:	8a 00                	mov    (%eax),%al
  800c88:	0f b6 d0             	movzbl %al,%edx
  800c8b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c8e:	8a 00                	mov    (%eax),%al
  800c90:	0f b6 c0             	movzbl %al,%eax
  800c93:	29 c2                	sub    %eax,%edx
  800c95:	89 d0                	mov    %edx,%eax
}
  800c97:	5d                   	pop    %ebp
  800c98:	c3                   	ret    

00800c99 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800c99:	55                   	push   %ebp
  800c9a:	89 e5                	mov    %esp,%ebp
  800c9c:	83 ec 04             	sub    $0x4,%esp
  800c9f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ca2:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800ca5:	eb 12                	jmp    800cb9 <strchr+0x20>
		if (*s == c)
  800ca7:	8b 45 08             	mov    0x8(%ebp),%eax
  800caa:	8a 00                	mov    (%eax),%al
  800cac:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800caf:	75 05                	jne    800cb6 <strchr+0x1d>
			return (char *) s;
  800cb1:	8b 45 08             	mov    0x8(%ebp),%eax
  800cb4:	eb 11                	jmp    800cc7 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800cb6:	ff 45 08             	incl   0x8(%ebp)
  800cb9:	8b 45 08             	mov    0x8(%ebp),%eax
  800cbc:	8a 00                	mov    (%eax),%al
  800cbe:	84 c0                	test   %al,%al
  800cc0:	75 e5                	jne    800ca7 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800cc2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800cc7:	c9                   	leave  
  800cc8:	c3                   	ret    

00800cc9 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800cc9:	55                   	push   %ebp
  800cca:	89 e5                	mov    %esp,%ebp
  800ccc:	83 ec 04             	sub    $0x4,%esp
  800ccf:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cd2:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800cd5:	eb 0d                	jmp    800ce4 <strfind+0x1b>
		if (*s == c)
  800cd7:	8b 45 08             	mov    0x8(%ebp),%eax
  800cda:	8a 00                	mov    (%eax),%al
  800cdc:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800cdf:	74 0e                	je     800cef <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800ce1:	ff 45 08             	incl   0x8(%ebp)
  800ce4:	8b 45 08             	mov    0x8(%ebp),%eax
  800ce7:	8a 00                	mov    (%eax),%al
  800ce9:	84 c0                	test   %al,%al
  800ceb:	75 ea                	jne    800cd7 <strfind+0xe>
  800ced:	eb 01                	jmp    800cf0 <strfind+0x27>
		if (*s == c)
			break;
  800cef:	90                   	nop
	return (char *) s;
  800cf0:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800cf3:	c9                   	leave  
  800cf4:	c3                   	ret    

00800cf5 <memset>:

// *************** The faster implementation of memset & memcpy is implemented by *************
// ****************** Team80 (Yahia Khaled, Malek Ahmed et al) - FCIS'24-25 *******************
void *
memset(void *v, int c, uint32 n)
{
  800cf5:	55                   	push   %ebp
  800cf6:	89 e5                	mov    %esp,%ebp
  800cf8:	83 ec 10             	sub    $0x10,%esp
//	m = n;
//	while (--m >= 0)
//		*p++ = c;

	/*Faster Implementation*/
	uint64* p64 = (uint64*)v;
  800cfb:	8b 45 08             	mov    0x8(%ebp),%eax
  800cfe:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if(n >= 8){
  800d01:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800d05:	76 63                	jbe    800d6a <memset+0x75>
		uint64 data_block = c;
  800d07:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d0a:	99                   	cltd   
  800d0b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800d0e:	89 55 f4             	mov    %edx,-0xc(%ebp)
		data_block |= data_block << 8;
  800d11:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800d14:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800d17:	0f a4 c2 08          	shld   $0x8,%eax,%edx
  800d1b:	c1 e0 08             	shl    $0x8,%eax
  800d1e:	09 45 f0             	or     %eax,-0x10(%ebp)
  800d21:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 16;
  800d24:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800d27:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800d2a:	0f a4 c2 10          	shld   $0x10,%eax,%edx
  800d2e:	c1 e0 10             	shl    $0x10,%eax
  800d31:	09 45 f0             	or     %eax,-0x10(%ebp)
  800d34:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 32;
  800d37:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800d3a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800d3d:	89 c2                	mov    %eax,%edx
  800d3f:	b8 00 00 00 00       	mov    $0x0,%eax
  800d44:	09 45 f0             	or     %eax,-0x10(%ebp)
  800d47:	09 55 f4             	or     %edx,-0xc(%ebp)

		while(n >= 8)
  800d4a:	eb 18                	jmp    800d64 <memset+0x6f>
			*p64++ = data_block, n -= 8;
  800d4c:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  800d4f:	8d 41 08             	lea    0x8(%ecx),%eax
  800d52:	89 45 fc             	mov    %eax,-0x4(%ebp)
  800d55:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800d58:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800d5b:	89 01                	mov    %eax,(%ecx)
  800d5d:	89 51 04             	mov    %edx,0x4(%ecx)
  800d60:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
		uint64 data_block = c;
		data_block |= data_block << 8;
		data_block |= data_block << 16;
		data_block |= data_block << 32;

		while(n >= 8)
  800d64:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800d68:	77 e2                	ja     800d4c <memset+0x57>
			*p64++ = data_block, n -= 8;
	}

	if(n){
  800d6a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d6e:	74 23                	je     800d93 <memset+0x9e>
		uint8* p8 = (uint8*)p64;
  800d70:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d73:	89 45 f8             	mov    %eax,-0x8(%ebp)
		while (n-- > 0)
  800d76:	eb 0e                	jmp    800d86 <memset+0x91>
			*p8++ = (uint8)c;
  800d78:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800d7b:	8d 50 01             	lea    0x1(%eax),%edx
  800d7e:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800d81:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d84:	88 10                	mov    %dl,(%eax)
			*p64++ = data_block, n -= 8;
	}

	if(n){
		uint8* p8 = (uint8*)p64;
		while (n-- > 0)
  800d86:	8b 45 10             	mov    0x10(%ebp),%eax
  800d89:	8d 50 ff             	lea    -0x1(%eax),%edx
  800d8c:	89 55 10             	mov    %edx,0x10(%ebp)
  800d8f:	85 c0                	test   %eax,%eax
  800d91:	75 e5                	jne    800d78 <memset+0x83>
			*p8++ = (uint8)c;
	}

	return v;
  800d93:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800d96:	c9                   	leave  
  800d97:	c3                   	ret    

00800d98 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800d98:	55                   	push   %ebp
  800d99:	89 e5                	mov    %esp,%ebp
  800d9b:	83 ec 10             	sub    $0x10,%esp
	//	s = src;
	//	d = dst;
	//	while (n-- > 0)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
  800d9e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800da1:	89 45 fc             	mov    %eax,-0x4(%ebp)
	uint64* d64 = (uint64*)dst;
  800da4:	8b 45 08             	mov    0x8(%ebp),%eax
  800da7:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if(n >= 8){
  800daa:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800dae:	76 24                	jbe    800dd4 <memcpy+0x3c>
		while(n >= 8){
  800db0:	eb 1c                	jmp    800dce <memcpy+0x36>
			*d64 = *s64;
  800db2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800db5:	8b 50 04             	mov    0x4(%eax),%edx
  800db8:	8b 00                	mov    (%eax),%eax
  800dba:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  800dbd:	89 01                	mov    %eax,(%ecx)
  800dbf:	89 51 04             	mov    %edx,0x4(%ecx)
			n -= 8;
  800dc2:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
			++s64;
  800dc6:	83 45 fc 08          	addl   $0x8,-0x4(%ebp)
			++d64;
  800dca:	83 45 f8 08          	addl   $0x8,-0x8(%ebp)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
	uint64* d64 = (uint64*)dst;
	if(n >= 8){
		while(n >= 8){
  800dce:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800dd2:	77 de                	ja     800db2 <memcpy+0x1a>
			++s64;
			++d64;
		}
	}

	if(n){
  800dd4:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800dd8:	74 31                	je     800e0b <memcpy+0x73>
		uint8* s8 = (uint8*)s64;
  800dda:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ddd:	89 45 f4             	mov    %eax,-0xc(%ebp)
		uint8* d8 = (uint8*)d64;
  800de0:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800de3:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (n-- > 0)
  800de6:	eb 16                	jmp    800dfe <memcpy+0x66>
			*d8++ = *s8++;
  800de8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800deb:	8d 50 01             	lea    0x1(%eax),%edx
  800dee:	89 55 f0             	mov    %edx,-0x10(%ebp)
  800df1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800df4:	8d 4a 01             	lea    0x1(%edx),%ecx
  800df7:	89 4d f4             	mov    %ecx,-0xc(%ebp)
  800dfa:	8a 12                	mov    (%edx),%dl
  800dfc:	88 10                	mov    %dl,(%eax)
	}

	if(n){
		uint8* s8 = (uint8*)s64;
		uint8* d8 = (uint8*)d64;
		while (n-- > 0)
  800dfe:	8b 45 10             	mov    0x10(%ebp),%eax
  800e01:	8d 50 ff             	lea    -0x1(%eax),%edx
  800e04:	89 55 10             	mov    %edx,0x10(%ebp)
  800e07:	85 c0                	test   %eax,%eax
  800e09:	75 dd                	jne    800de8 <memcpy+0x50>
			*d8++ = *s8++;
	}
	return dst;
  800e0b:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e0e:	c9                   	leave  
  800e0f:	c3                   	ret    

00800e10 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800e10:	55                   	push   %ebp
  800e11:	89 e5                	mov    %esp,%ebp
  800e13:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800e16:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e19:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800e1c:	8b 45 08             	mov    0x8(%ebp),%eax
  800e1f:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800e22:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e25:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800e28:	73 50                	jae    800e7a <memmove+0x6a>
  800e2a:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800e2d:	8b 45 10             	mov    0x10(%ebp),%eax
  800e30:	01 d0                	add    %edx,%eax
  800e32:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800e35:	76 43                	jbe    800e7a <memmove+0x6a>
		s += n;
  800e37:	8b 45 10             	mov    0x10(%ebp),%eax
  800e3a:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800e3d:	8b 45 10             	mov    0x10(%ebp),%eax
  800e40:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800e43:	eb 10                	jmp    800e55 <memmove+0x45>
			*--d = *--s;
  800e45:	ff 4d f8             	decl   -0x8(%ebp)
  800e48:	ff 4d fc             	decl   -0x4(%ebp)
  800e4b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e4e:	8a 10                	mov    (%eax),%dl
  800e50:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e53:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800e55:	8b 45 10             	mov    0x10(%ebp),%eax
  800e58:	8d 50 ff             	lea    -0x1(%eax),%edx
  800e5b:	89 55 10             	mov    %edx,0x10(%ebp)
  800e5e:	85 c0                	test   %eax,%eax
  800e60:	75 e3                	jne    800e45 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800e62:	eb 23                	jmp    800e87 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800e64:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e67:	8d 50 01             	lea    0x1(%eax),%edx
  800e6a:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800e6d:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800e70:	8d 4a 01             	lea    0x1(%edx),%ecx
  800e73:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800e76:	8a 12                	mov    (%edx),%dl
  800e78:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800e7a:	8b 45 10             	mov    0x10(%ebp),%eax
  800e7d:	8d 50 ff             	lea    -0x1(%eax),%edx
  800e80:	89 55 10             	mov    %edx,0x10(%ebp)
  800e83:	85 c0                	test   %eax,%eax
  800e85:	75 dd                	jne    800e64 <memmove+0x54>
			*d++ = *s++;

	return dst;
  800e87:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e8a:	c9                   	leave  
  800e8b:	c3                   	ret    

00800e8c <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  800e8c:	55                   	push   %ebp
  800e8d:	89 e5                	mov    %esp,%ebp
  800e8f:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  800e92:	8b 45 08             	mov    0x8(%ebp),%eax
  800e95:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  800e98:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e9b:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800e9e:	eb 2a                	jmp    800eca <memcmp+0x3e>
		if (*s1 != *s2)
  800ea0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ea3:	8a 10                	mov    (%eax),%dl
  800ea5:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800ea8:	8a 00                	mov    (%eax),%al
  800eaa:	38 c2                	cmp    %al,%dl
  800eac:	74 16                	je     800ec4 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  800eae:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800eb1:	8a 00                	mov    (%eax),%al
  800eb3:	0f b6 d0             	movzbl %al,%edx
  800eb6:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800eb9:	8a 00                	mov    (%eax),%al
  800ebb:	0f b6 c0             	movzbl %al,%eax
  800ebe:	29 c2                	sub    %eax,%edx
  800ec0:	89 d0                	mov    %edx,%eax
  800ec2:	eb 18                	jmp    800edc <memcmp+0x50>
		s1++, s2++;
  800ec4:	ff 45 fc             	incl   -0x4(%ebp)
  800ec7:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  800eca:	8b 45 10             	mov    0x10(%ebp),%eax
  800ecd:	8d 50 ff             	lea    -0x1(%eax),%edx
  800ed0:	89 55 10             	mov    %edx,0x10(%ebp)
  800ed3:	85 c0                	test   %eax,%eax
  800ed5:	75 c9                	jne    800ea0 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800ed7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800edc:	c9                   	leave  
  800edd:	c3                   	ret    

00800ede <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  800ede:	55                   	push   %ebp
  800edf:	89 e5                	mov    %esp,%ebp
  800ee1:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  800ee4:	8b 55 08             	mov    0x8(%ebp),%edx
  800ee7:	8b 45 10             	mov    0x10(%ebp),%eax
  800eea:	01 d0                	add    %edx,%eax
  800eec:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  800eef:	eb 15                	jmp    800f06 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  800ef1:	8b 45 08             	mov    0x8(%ebp),%eax
  800ef4:	8a 00                	mov    (%eax),%al
  800ef6:	0f b6 d0             	movzbl %al,%edx
  800ef9:	8b 45 0c             	mov    0xc(%ebp),%eax
  800efc:	0f b6 c0             	movzbl %al,%eax
  800eff:	39 c2                	cmp    %eax,%edx
  800f01:	74 0d                	je     800f10 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800f03:	ff 45 08             	incl   0x8(%ebp)
  800f06:	8b 45 08             	mov    0x8(%ebp),%eax
  800f09:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  800f0c:	72 e3                	jb     800ef1 <memfind+0x13>
  800f0e:	eb 01                	jmp    800f11 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  800f10:	90                   	nop
	return (void *) s;
  800f11:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f14:	c9                   	leave  
  800f15:	c3                   	ret    

00800f16 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800f16:	55                   	push   %ebp
  800f17:	89 e5                	mov    %esp,%ebp
  800f19:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  800f1c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  800f23:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800f2a:	eb 03                	jmp    800f2f <strtol+0x19>
		s++;
  800f2c:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800f2f:	8b 45 08             	mov    0x8(%ebp),%eax
  800f32:	8a 00                	mov    (%eax),%al
  800f34:	3c 20                	cmp    $0x20,%al
  800f36:	74 f4                	je     800f2c <strtol+0x16>
  800f38:	8b 45 08             	mov    0x8(%ebp),%eax
  800f3b:	8a 00                	mov    (%eax),%al
  800f3d:	3c 09                	cmp    $0x9,%al
  800f3f:	74 eb                	je     800f2c <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  800f41:	8b 45 08             	mov    0x8(%ebp),%eax
  800f44:	8a 00                	mov    (%eax),%al
  800f46:	3c 2b                	cmp    $0x2b,%al
  800f48:	75 05                	jne    800f4f <strtol+0x39>
		s++;
  800f4a:	ff 45 08             	incl   0x8(%ebp)
  800f4d:	eb 13                	jmp    800f62 <strtol+0x4c>
	else if (*s == '-')
  800f4f:	8b 45 08             	mov    0x8(%ebp),%eax
  800f52:	8a 00                	mov    (%eax),%al
  800f54:	3c 2d                	cmp    $0x2d,%al
  800f56:	75 0a                	jne    800f62 <strtol+0x4c>
		s++, neg = 1;
  800f58:	ff 45 08             	incl   0x8(%ebp)
  800f5b:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800f62:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f66:	74 06                	je     800f6e <strtol+0x58>
  800f68:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  800f6c:	75 20                	jne    800f8e <strtol+0x78>
  800f6e:	8b 45 08             	mov    0x8(%ebp),%eax
  800f71:	8a 00                	mov    (%eax),%al
  800f73:	3c 30                	cmp    $0x30,%al
  800f75:	75 17                	jne    800f8e <strtol+0x78>
  800f77:	8b 45 08             	mov    0x8(%ebp),%eax
  800f7a:	40                   	inc    %eax
  800f7b:	8a 00                	mov    (%eax),%al
  800f7d:	3c 78                	cmp    $0x78,%al
  800f7f:	75 0d                	jne    800f8e <strtol+0x78>
		s += 2, base = 16;
  800f81:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  800f85:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  800f8c:	eb 28                	jmp    800fb6 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  800f8e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f92:	75 15                	jne    800fa9 <strtol+0x93>
  800f94:	8b 45 08             	mov    0x8(%ebp),%eax
  800f97:	8a 00                	mov    (%eax),%al
  800f99:	3c 30                	cmp    $0x30,%al
  800f9b:	75 0c                	jne    800fa9 <strtol+0x93>
		s++, base = 8;
  800f9d:	ff 45 08             	incl   0x8(%ebp)
  800fa0:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  800fa7:	eb 0d                	jmp    800fb6 <strtol+0xa0>
	else if (base == 0)
  800fa9:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800fad:	75 07                	jne    800fb6 <strtol+0xa0>
		base = 10;
  800faf:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800fb6:	8b 45 08             	mov    0x8(%ebp),%eax
  800fb9:	8a 00                	mov    (%eax),%al
  800fbb:	3c 2f                	cmp    $0x2f,%al
  800fbd:	7e 19                	jle    800fd8 <strtol+0xc2>
  800fbf:	8b 45 08             	mov    0x8(%ebp),%eax
  800fc2:	8a 00                	mov    (%eax),%al
  800fc4:	3c 39                	cmp    $0x39,%al
  800fc6:	7f 10                	jg     800fd8 <strtol+0xc2>
			dig = *s - '0';
  800fc8:	8b 45 08             	mov    0x8(%ebp),%eax
  800fcb:	8a 00                	mov    (%eax),%al
  800fcd:	0f be c0             	movsbl %al,%eax
  800fd0:	83 e8 30             	sub    $0x30,%eax
  800fd3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800fd6:	eb 42                	jmp    80101a <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  800fd8:	8b 45 08             	mov    0x8(%ebp),%eax
  800fdb:	8a 00                	mov    (%eax),%al
  800fdd:	3c 60                	cmp    $0x60,%al
  800fdf:	7e 19                	jle    800ffa <strtol+0xe4>
  800fe1:	8b 45 08             	mov    0x8(%ebp),%eax
  800fe4:	8a 00                	mov    (%eax),%al
  800fe6:	3c 7a                	cmp    $0x7a,%al
  800fe8:	7f 10                	jg     800ffa <strtol+0xe4>
			dig = *s - 'a' + 10;
  800fea:	8b 45 08             	mov    0x8(%ebp),%eax
  800fed:	8a 00                	mov    (%eax),%al
  800fef:	0f be c0             	movsbl %al,%eax
  800ff2:	83 e8 57             	sub    $0x57,%eax
  800ff5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800ff8:	eb 20                	jmp    80101a <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  800ffa:	8b 45 08             	mov    0x8(%ebp),%eax
  800ffd:	8a 00                	mov    (%eax),%al
  800fff:	3c 40                	cmp    $0x40,%al
  801001:	7e 39                	jle    80103c <strtol+0x126>
  801003:	8b 45 08             	mov    0x8(%ebp),%eax
  801006:	8a 00                	mov    (%eax),%al
  801008:	3c 5a                	cmp    $0x5a,%al
  80100a:	7f 30                	jg     80103c <strtol+0x126>
			dig = *s - 'A' + 10;
  80100c:	8b 45 08             	mov    0x8(%ebp),%eax
  80100f:	8a 00                	mov    (%eax),%al
  801011:	0f be c0             	movsbl %al,%eax
  801014:	83 e8 37             	sub    $0x37,%eax
  801017:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  80101a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80101d:	3b 45 10             	cmp    0x10(%ebp),%eax
  801020:	7d 19                	jge    80103b <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801022:	ff 45 08             	incl   0x8(%ebp)
  801025:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801028:	0f af 45 10          	imul   0x10(%ebp),%eax
  80102c:	89 c2                	mov    %eax,%edx
  80102e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801031:	01 d0                	add    %edx,%eax
  801033:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  801036:	e9 7b ff ff ff       	jmp    800fb6 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  80103b:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  80103c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801040:	74 08                	je     80104a <strtol+0x134>
		*endptr = (char *) s;
  801042:	8b 45 0c             	mov    0xc(%ebp),%eax
  801045:	8b 55 08             	mov    0x8(%ebp),%edx
  801048:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  80104a:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80104e:	74 07                	je     801057 <strtol+0x141>
  801050:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801053:	f7 d8                	neg    %eax
  801055:	eb 03                	jmp    80105a <strtol+0x144>
  801057:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  80105a:	c9                   	leave  
  80105b:	c3                   	ret    

0080105c <ltostr>:

void
ltostr(long value, char *str)
{
  80105c:	55                   	push   %ebp
  80105d:	89 e5                	mov    %esp,%ebp
  80105f:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  801062:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  801069:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  801070:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801074:	79 13                	jns    801089 <ltostr+0x2d>
	{
		neg = 1;
  801076:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  80107d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801080:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  801083:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  801086:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  801089:	8b 45 08             	mov    0x8(%ebp),%eax
  80108c:	b9 0a 00 00 00       	mov    $0xa,%ecx
  801091:	99                   	cltd   
  801092:	f7 f9                	idiv   %ecx
  801094:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  801097:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80109a:	8d 50 01             	lea    0x1(%eax),%edx
  80109d:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8010a0:	89 c2                	mov    %eax,%edx
  8010a2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010a5:	01 d0                	add    %edx,%eax
  8010a7:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8010aa:	83 c2 30             	add    $0x30,%edx
  8010ad:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  8010af:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8010b2:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8010b7:	f7 e9                	imul   %ecx
  8010b9:	c1 fa 02             	sar    $0x2,%edx
  8010bc:	89 c8                	mov    %ecx,%eax
  8010be:	c1 f8 1f             	sar    $0x1f,%eax
  8010c1:	29 c2                	sub    %eax,%edx
  8010c3:	89 d0                	mov    %edx,%eax
  8010c5:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  8010c8:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8010cc:	75 bb                	jne    801089 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  8010ce:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  8010d5:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010d8:	48                   	dec    %eax
  8010d9:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  8010dc:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8010e0:	74 3d                	je     80111f <ltostr+0xc3>
		start = 1 ;
  8010e2:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  8010e9:	eb 34                	jmp    80111f <ltostr+0xc3>
	{
		char tmp = str[start] ;
  8010eb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8010ee:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010f1:	01 d0                	add    %edx,%eax
  8010f3:	8a 00                	mov    (%eax),%al
  8010f5:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  8010f8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8010fb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010fe:	01 c2                	add    %eax,%edx
  801100:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801103:	8b 45 0c             	mov    0xc(%ebp),%eax
  801106:	01 c8                	add    %ecx,%eax
  801108:	8a 00                	mov    (%eax),%al
  80110a:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  80110c:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80110f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801112:	01 c2                	add    %eax,%edx
  801114:	8a 45 eb             	mov    -0x15(%ebp),%al
  801117:	88 02                	mov    %al,(%edx)
		start++ ;
  801119:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  80111c:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  80111f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801122:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801125:	7c c4                	jl     8010eb <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801127:	8b 55 f8             	mov    -0x8(%ebp),%edx
  80112a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80112d:	01 d0                	add    %edx,%eax
  80112f:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801132:	90                   	nop
  801133:	c9                   	leave  
  801134:	c3                   	ret    

00801135 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  801135:	55                   	push   %ebp
  801136:	89 e5                	mov    %esp,%ebp
  801138:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  80113b:	ff 75 08             	pushl  0x8(%ebp)
  80113e:	e8 c4 f9 ff ff       	call   800b07 <strlen>
  801143:	83 c4 04             	add    $0x4,%esp
  801146:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  801149:	ff 75 0c             	pushl  0xc(%ebp)
  80114c:	e8 b6 f9 ff ff       	call   800b07 <strlen>
  801151:	83 c4 04             	add    $0x4,%esp
  801154:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  801157:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  80115e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801165:	eb 17                	jmp    80117e <strcconcat+0x49>
		final[s] = str1[s] ;
  801167:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80116a:	8b 45 10             	mov    0x10(%ebp),%eax
  80116d:	01 c2                	add    %eax,%edx
  80116f:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801172:	8b 45 08             	mov    0x8(%ebp),%eax
  801175:	01 c8                	add    %ecx,%eax
  801177:	8a 00                	mov    (%eax),%al
  801179:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  80117b:	ff 45 fc             	incl   -0x4(%ebp)
  80117e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801181:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801184:	7c e1                	jl     801167 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  801186:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  80118d:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  801194:	eb 1f                	jmp    8011b5 <strcconcat+0x80>
		final[s++] = str2[i] ;
  801196:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801199:	8d 50 01             	lea    0x1(%eax),%edx
  80119c:	89 55 fc             	mov    %edx,-0x4(%ebp)
  80119f:	89 c2                	mov    %eax,%edx
  8011a1:	8b 45 10             	mov    0x10(%ebp),%eax
  8011a4:	01 c2                	add    %eax,%edx
  8011a6:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8011a9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011ac:	01 c8                	add    %ecx,%eax
  8011ae:	8a 00                	mov    (%eax),%al
  8011b0:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  8011b2:	ff 45 f8             	incl   -0x8(%ebp)
  8011b5:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011b8:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8011bb:	7c d9                	jl     801196 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  8011bd:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8011c0:	8b 45 10             	mov    0x10(%ebp),%eax
  8011c3:	01 d0                	add    %edx,%eax
  8011c5:	c6 00 00             	movb   $0x0,(%eax)
}
  8011c8:	90                   	nop
  8011c9:	c9                   	leave  
  8011ca:	c3                   	ret    

008011cb <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  8011cb:	55                   	push   %ebp
  8011cc:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  8011ce:	8b 45 14             	mov    0x14(%ebp),%eax
  8011d1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  8011d7:	8b 45 14             	mov    0x14(%ebp),%eax
  8011da:	8b 00                	mov    (%eax),%eax
  8011dc:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8011e3:	8b 45 10             	mov    0x10(%ebp),%eax
  8011e6:	01 d0                	add    %edx,%eax
  8011e8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8011ee:	eb 0c                	jmp    8011fc <strsplit+0x31>
			*string++ = 0;
  8011f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8011f3:	8d 50 01             	lea    0x1(%eax),%edx
  8011f6:	89 55 08             	mov    %edx,0x8(%ebp)
  8011f9:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8011fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8011ff:	8a 00                	mov    (%eax),%al
  801201:	84 c0                	test   %al,%al
  801203:	74 18                	je     80121d <strsplit+0x52>
  801205:	8b 45 08             	mov    0x8(%ebp),%eax
  801208:	8a 00                	mov    (%eax),%al
  80120a:	0f be c0             	movsbl %al,%eax
  80120d:	50                   	push   %eax
  80120e:	ff 75 0c             	pushl  0xc(%ebp)
  801211:	e8 83 fa ff ff       	call   800c99 <strchr>
  801216:	83 c4 08             	add    $0x8,%esp
  801219:	85 c0                	test   %eax,%eax
  80121b:	75 d3                	jne    8011f0 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  80121d:	8b 45 08             	mov    0x8(%ebp),%eax
  801220:	8a 00                	mov    (%eax),%al
  801222:	84 c0                	test   %al,%al
  801224:	74 5a                	je     801280 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801226:	8b 45 14             	mov    0x14(%ebp),%eax
  801229:	8b 00                	mov    (%eax),%eax
  80122b:	83 f8 0f             	cmp    $0xf,%eax
  80122e:	75 07                	jne    801237 <strsplit+0x6c>
		{
			return 0;
  801230:	b8 00 00 00 00       	mov    $0x0,%eax
  801235:	eb 66                	jmp    80129d <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801237:	8b 45 14             	mov    0x14(%ebp),%eax
  80123a:	8b 00                	mov    (%eax),%eax
  80123c:	8d 48 01             	lea    0x1(%eax),%ecx
  80123f:	8b 55 14             	mov    0x14(%ebp),%edx
  801242:	89 0a                	mov    %ecx,(%edx)
  801244:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80124b:	8b 45 10             	mov    0x10(%ebp),%eax
  80124e:	01 c2                	add    %eax,%edx
  801250:	8b 45 08             	mov    0x8(%ebp),%eax
  801253:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801255:	eb 03                	jmp    80125a <strsplit+0x8f>
			string++;
  801257:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  80125a:	8b 45 08             	mov    0x8(%ebp),%eax
  80125d:	8a 00                	mov    (%eax),%al
  80125f:	84 c0                	test   %al,%al
  801261:	74 8b                	je     8011ee <strsplit+0x23>
  801263:	8b 45 08             	mov    0x8(%ebp),%eax
  801266:	8a 00                	mov    (%eax),%al
  801268:	0f be c0             	movsbl %al,%eax
  80126b:	50                   	push   %eax
  80126c:	ff 75 0c             	pushl  0xc(%ebp)
  80126f:	e8 25 fa ff ff       	call   800c99 <strchr>
  801274:	83 c4 08             	add    $0x8,%esp
  801277:	85 c0                	test   %eax,%eax
  801279:	74 dc                	je     801257 <strsplit+0x8c>
			string++;
	}
  80127b:	e9 6e ff ff ff       	jmp    8011ee <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801280:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801281:	8b 45 14             	mov    0x14(%ebp),%eax
  801284:	8b 00                	mov    (%eax),%eax
  801286:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80128d:	8b 45 10             	mov    0x10(%ebp),%eax
  801290:	01 d0                	add    %edx,%eax
  801292:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801298:	b8 01 00 00 00       	mov    $0x1,%eax
}
  80129d:	c9                   	leave  
  80129e:	c3                   	ret    

0080129f <str2lower>:


char* str2lower(char *dst, const char *src)
{
  80129f:	55                   	push   %ebp
  8012a0:	89 e5                	mov    %esp,%ebp
  8012a2:	83 ec 10             	sub    $0x10,%esp
	char* ret = dst;
  8012a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8012a8:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (int i = 0; i < strlen(src); ++i)
  8012ab:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8012b2:	eb 4a                	jmp    8012fe <str2lower+0x5f>
	{
		dst[i] = src[i] ;
  8012b4:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8012b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8012ba:	01 c2                	add    %eax,%edx
  8012bc:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8012bf:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012c2:	01 c8                	add    %ecx,%eax
  8012c4:	8a 00                	mov    (%eax),%al
  8012c6:	88 02                	mov    %al,(%edx)
		if (src[i] >= 'A' && src[i] <= 'Z')
  8012c8:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8012cb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012ce:	01 d0                	add    %edx,%eax
  8012d0:	8a 00                	mov    (%eax),%al
  8012d2:	3c 40                	cmp    $0x40,%al
  8012d4:	7e 25                	jle    8012fb <str2lower+0x5c>
  8012d6:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8012d9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012dc:	01 d0                	add    %edx,%eax
  8012de:	8a 00                	mov    (%eax),%al
  8012e0:	3c 5a                	cmp    $0x5a,%al
  8012e2:	7f 17                	jg     8012fb <str2lower+0x5c>
		{
			dst[i] += 32 ;
  8012e4:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8012e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8012ea:	01 d0                	add    %edx,%eax
  8012ec:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8012ef:	8b 55 08             	mov    0x8(%ebp),%edx
  8012f2:	01 ca                	add    %ecx,%edx
  8012f4:	8a 12                	mov    (%edx),%dl
  8012f6:	83 c2 20             	add    $0x20,%edx
  8012f9:	88 10                	mov    %dl,(%eax)


char* str2lower(char *dst, const char *src)
{
	char* ret = dst;
	for (int i = 0; i < strlen(src); ++i)
  8012fb:	ff 45 fc             	incl   -0x4(%ebp)
  8012fe:	ff 75 0c             	pushl  0xc(%ebp)
  801301:	e8 01 f8 ff ff       	call   800b07 <strlen>
  801306:	83 c4 04             	add    $0x4,%esp
  801309:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  80130c:	7f a6                	jg     8012b4 <str2lower+0x15>
		if (src[i] >= 'A' && src[i] <= 'Z')
		{
			dst[i] += 32 ;
		}
	}
	return ret;
  80130e:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801311:	c9                   	leave  
  801312:	c3                   	ret    

00801313 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801313:	55                   	push   %ebp
  801314:	89 e5                	mov    %esp,%ebp
  801316:	57                   	push   %edi
  801317:	56                   	push   %esi
  801318:	53                   	push   %ebx
  801319:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80131c:	8b 45 08             	mov    0x8(%ebp),%eax
  80131f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801322:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801325:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801328:	8b 7d 18             	mov    0x18(%ebp),%edi
  80132b:	8b 75 1c             	mov    0x1c(%ebp),%esi
  80132e:	cd 30                	int    $0x30
  801330:	89 45 f0             	mov    %eax,-0x10(%ebp)
				"b" (a3),
				"D" (a4),
				"S" (a5)
				: "cc", "memory");

	return ret;
  801333:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801336:	83 c4 10             	add    $0x10,%esp
  801339:	5b                   	pop    %ebx
  80133a:	5e                   	pop    %esi
  80133b:	5f                   	pop    %edi
  80133c:	5d                   	pop    %ebp
  80133d:	c3                   	ret    

0080133e <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName, int color)
{
  80133e:	55                   	push   %ebp
  80133f:	89 e5                	mov    %esp,%ebp
  801341:	83 ec 04             	sub    $0x4,%esp
  801344:	8b 45 10             	mov    0x10(%ebp),%eax
  801347:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, color, 0);
  80134a:	8b 4d 14             	mov    0x14(%ebp),%ecx
  80134d:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801351:	8b 45 08             	mov    0x8(%ebp),%eax
  801354:	6a 00                	push   $0x0
  801356:	51                   	push   %ecx
  801357:	52                   	push   %edx
  801358:	ff 75 0c             	pushl  0xc(%ebp)
  80135b:	50                   	push   %eax
  80135c:	6a 00                	push   $0x0
  80135e:	e8 b0 ff ff ff       	call   801313 <syscall>
  801363:	83 c4 18             	add    $0x18,%esp
}
  801366:	90                   	nop
  801367:	c9                   	leave  
  801368:	c3                   	ret    

00801369 <sys_cgetc>:

int
sys_cgetc(void)
{
  801369:	55                   	push   %ebp
  80136a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  80136c:	6a 00                	push   $0x0
  80136e:	6a 00                	push   $0x0
  801370:	6a 00                	push   $0x0
  801372:	6a 00                	push   $0x0
  801374:	6a 00                	push   $0x0
  801376:	6a 02                	push   $0x2
  801378:	e8 96 ff ff ff       	call   801313 <syscall>
  80137d:	83 c4 18             	add    $0x18,%esp
}
  801380:	c9                   	leave  
  801381:	c3                   	ret    

00801382 <sys_lock_cons>:

void sys_lock_cons(void)
{
  801382:	55                   	push   %ebp
  801383:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  801385:	6a 00                	push   $0x0
  801387:	6a 00                	push   $0x0
  801389:	6a 00                	push   $0x0
  80138b:	6a 00                	push   $0x0
  80138d:	6a 00                	push   $0x0
  80138f:	6a 03                	push   $0x3
  801391:	e8 7d ff ff ff       	call   801313 <syscall>
  801396:	83 c4 18             	add    $0x18,%esp
}
  801399:	90                   	nop
  80139a:	c9                   	leave  
  80139b:	c3                   	ret    

0080139c <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  80139c:	55                   	push   %ebp
  80139d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  80139f:	6a 00                	push   $0x0
  8013a1:	6a 00                	push   $0x0
  8013a3:	6a 00                	push   $0x0
  8013a5:	6a 00                	push   $0x0
  8013a7:	6a 00                	push   $0x0
  8013a9:	6a 04                	push   $0x4
  8013ab:	e8 63 ff ff ff       	call   801313 <syscall>
  8013b0:	83 c4 18             	add    $0x18,%esp
}
  8013b3:	90                   	nop
  8013b4:	c9                   	leave  
  8013b5:	c3                   	ret    

008013b6 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  8013b6:	55                   	push   %ebp
  8013b7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  8013b9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8013bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8013bf:	6a 00                	push   $0x0
  8013c1:	6a 00                	push   $0x0
  8013c3:	6a 00                	push   $0x0
  8013c5:	52                   	push   %edx
  8013c6:	50                   	push   %eax
  8013c7:	6a 08                	push   $0x8
  8013c9:	e8 45 ff ff ff       	call   801313 <syscall>
  8013ce:	83 c4 18             	add    $0x18,%esp
}
  8013d1:	c9                   	leave  
  8013d2:	c3                   	ret    

008013d3 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  8013d3:	55                   	push   %ebp
  8013d4:	89 e5                	mov    %esp,%ebp
  8013d6:	56                   	push   %esi
  8013d7:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  8013d8:	8b 75 18             	mov    0x18(%ebp),%esi
  8013db:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8013de:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8013e1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8013e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8013e7:	56                   	push   %esi
  8013e8:	53                   	push   %ebx
  8013e9:	51                   	push   %ecx
  8013ea:	52                   	push   %edx
  8013eb:	50                   	push   %eax
  8013ec:	6a 09                	push   $0x9
  8013ee:	e8 20 ff ff ff       	call   801313 <syscall>
  8013f3:	83 c4 18             	add    $0x18,%esp
}
  8013f6:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8013f9:	5b                   	pop    %ebx
  8013fa:	5e                   	pop    %esi
  8013fb:	5d                   	pop    %ebp
  8013fc:	c3                   	ret    

008013fd <__sys_unmap_frame>:

int __sys_unmap_frame(uint32 va)
{
  8013fd:	55                   	push   %ebp
  8013fe:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, va, 0, 0, 0, 0);
  801400:	6a 00                	push   $0x0
  801402:	6a 00                	push   $0x0
  801404:	6a 00                	push   $0x0
  801406:	6a 00                	push   $0x0
  801408:	ff 75 08             	pushl  0x8(%ebp)
  80140b:	6a 0a                	push   $0xa
  80140d:	e8 01 ff ff ff       	call   801313 <syscall>
  801412:	83 c4 18             	add    $0x18,%esp
}
  801415:	c9                   	leave  
  801416:	c3                   	ret    

00801417 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801417:	55                   	push   %ebp
  801418:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  80141a:	6a 00                	push   $0x0
  80141c:	6a 00                	push   $0x0
  80141e:	6a 00                	push   $0x0
  801420:	ff 75 0c             	pushl  0xc(%ebp)
  801423:	ff 75 08             	pushl  0x8(%ebp)
  801426:	6a 0b                	push   $0xb
  801428:	e8 e6 fe ff ff       	call   801313 <syscall>
  80142d:	83 c4 18             	add    $0x18,%esp
}
  801430:	c9                   	leave  
  801431:	c3                   	ret    

00801432 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801432:	55                   	push   %ebp
  801433:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801435:	6a 00                	push   $0x0
  801437:	6a 00                	push   $0x0
  801439:	6a 00                	push   $0x0
  80143b:	6a 00                	push   $0x0
  80143d:	6a 00                	push   $0x0
  80143f:	6a 0c                	push   $0xc
  801441:	e8 cd fe ff ff       	call   801313 <syscall>
  801446:	83 c4 18             	add    $0x18,%esp
}
  801449:	c9                   	leave  
  80144a:	c3                   	ret    

0080144b <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  80144b:	55                   	push   %ebp
  80144c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  80144e:	6a 00                	push   $0x0
  801450:	6a 00                	push   $0x0
  801452:	6a 00                	push   $0x0
  801454:	6a 00                	push   $0x0
  801456:	6a 00                	push   $0x0
  801458:	6a 0d                	push   $0xd
  80145a:	e8 b4 fe ff ff       	call   801313 <syscall>
  80145f:	83 c4 18             	add    $0x18,%esp
}
  801462:	c9                   	leave  
  801463:	c3                   	ret    

00801464 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801464:	55                   	push   %ebp
  801465:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801467:	6a 00                	push   $0x0
  801469:	6a 00                	push   $0x0
  80146b:	6a 00                	push   $0x0
  80146d:	6a 00                	push   $0x0
  80146f:	6a 00                	push   $0x0
  801471:	6a 0e                	push   $0xe
  801473:	e8 9b fe ff ff       	call   801313 <syscall>
  801478:	83 c4 18             	add    $0x18,%esp
}
  80147b:	c9                   	leave  
  80147c:	c3                   	ret    

0080147d <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  80147d:	55                   	push   %ebp
  80147e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801480:	6a 00                	push   $0x0
  801482:	6a 00                	push   $0x0
  801484:	6a 00                	push   $0x0
  801486:	6a 00                	push   $0x0
  801488:	6a 00                	push   $0x0
  80148a:	6a 0f                	push   $0xf
  80148c:	e8 82 fe ff ff       	call   801313 <syscall>
  801491:	83 c4 18             	add    $0x18,%esp
}
  801494:	c9                   	leave  
  801495:	c3                   	ret    

00801496 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801496:	55                   	push   %ebp
  801497:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801499:	6a 00                	push   $0x0
  80149b:	6a 00                	push   $0x0
  80149d:	6a 00                	push   $0x0
  80149f:	6a 00                	push   $0x0
  8014a1:	ff 75 08             	pushl  0x8(%ebp)
  8014a4:	6a 10                	push   $0x10
  8014a6:	e8 68 fe ff ff       	call   801313 <syscall>
  8014ab:	83 c4 18             	add    $0x18,%esp
}
  8014ae:	c9                   	leave  
  8014af:	c3                   	ret    

008014b0 <sys_scarce_memory>:

void sys_scarce_memory()
{
  8014b0:	55                   	push   %ebp
  8014b1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  8014b3:	6a 00                	push   $0x0
  8014b5:	6a 00                	push   $0x0
  8014b7:	6a 00                	push   $0x0
  8014b9:	6a 00                	push   $0x0
  8014bb:	6a 00                	push   $0x0
  8014bd:	6a 11                	push   $0x11
  8014bf:	e8 4f fe ff ff       	call   801313 <syscall>
  8014c4:	83 c4 18             	add    $0x18,%esp
}
  8014c7:	90                   	nop
  8014c8:	c9                   	leave  
  8014c9:	c3                   	ret    

008014ca <sys_cputc>:

void
sys_cputc(const char c)
{
  8014ca:	55                   	push   %ebp
  8014cb:	89 e5                	mov    %esp,%ebp
  8014cd:	83 ec 04             	sub    $0x4,%esp
  8014d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8014d3:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  8014d6:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8014da:	6a 00                	push   $0x0
  8014dc:	6a 00                	push   $0x0
  8014de:	6a 00                	push   $0x0
  8014e0:	6a 00                	push   $0x0
  8014e2:	50                   	push   %eax
  8014e3:	6a 01                	push   $0x1
  8014e5:	e8 29 fe ff ff       	call   801313 <syscall>
  8014ea:	83 c4 18             	add    $0x18,%esp
}
  8014ed:	90                   	nop
  8014ee:	c9                   	leave  
  8014ef:	c3                   	ret    

008014f0 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  8014f0:	55                   	push   %ebp
  8014f1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  8014f3:	6a 00                	push   $0x0
  8014f5:	6a 00                	push   $0x0
  8014f7:	6a 00                	push   $0x0
  8014f9:	6a 00                	push   $0x0
  8014fb:	6a 00                	push   $0x0
  8014fd:	6a 14                	push   $0x14
  8014ff:	e8 0f fe ff ff       	call   801313 <syscall>
  801504:	83 c4 18             	add    $0x18,%esp
}
  801507:	90                   	nop
  801508:	c9                   	leave  
  801509:	c3                   	ret    

0080150a <sys_create_shared_object>:

int sys_create_shared_object(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  80150a:	55                   	push   %ebp
  80150b:	89 e5                	mov    %esp,%ebp
  80150d:	83 ec 04             	sub    $0x4,%esp
  801510:	8b 45 10             	mov    0x10(%ebp),%eax
  801513:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801516:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801519:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80151d:	8b 45 08             	mov    0x8(%ebp),%eax
  801520:	6a 00                	push   $0x0
  801522:	51                   	push   %ecx
  801523:	52                   	push   %edx
  801524:	ff 75 0c             	pushl  0xc(%ebp)
  801527:	50                   	push   %eax
  801528:	6a 15                	push   $0x15
  80152a:	e8 e4 fd ff ff       	call   801313 <syscall>
  80152f:	83 c4 18             	add    $0x18,%esp
}
  801532:	c9                   	leave  
  801533:	c3                   	ret    

00801534 <sys_size_of_shared_object>:

//2017:
int sys_size_of_shared_object(int32 ownerID, char* shareName)
{
  801534:	55                   	push   %ebp
  801535:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801537:	8b 55 0c             	mov    0xc(%ebp),%edx
  80153a:	8b 45 08             	mov    0x8(%ebp),%eax
  80153d:	6a 00                	push   $0x0
  80153f:	6a 00                	push   $0x0
  801541:	6a 00                	push   $0x0
  801543:	52                   	push   %edx
  801544:	50                   	push   %eax
  801545:	6a 16                	push   $0x16
  801547:	e8 c7 fd ff ff       	call   801313 <syscall>
  80154c:	83 c4 18             	add    $0x18,%esp
}
  80154f:	c9                   	leave  
  801550:	c3                   	ret    

00801551 <sys_get_shared_object>:
//==========

int sys_get_shared_object(int32 ownerID, char* shareName, void* virtual_address)
{
  801551:	55                   	push   %ebp
  801552:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801554:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801557:	8b 55 0c             	mov    0xc(%ebp),%edx
  80155a:	8b 45 08             	mov    0x8(%ebp),%eax
  80155d:	6a 00                	push   $0x0
  80155f:	6a 00                	push   $0x0
  801561:	51                   	push   %ecx
  801562:	52                   	push   %edx
  801563:	50                   	push   %eax
  801564:	6a 17                	push   $0x17
  801566:	e8 a8 fd ff ff       	call   801313 <syscall>
  80156b:	83 c4 18             	add    $0x18,%esp
}
  80156e:	c9                   	leave  
  80156f:	c3                   	ret    

00801570 <sys_delete_shared_object>:

int sys_delete_shared_object(int32 sharedObjectID, void *startVA)
{
  801570:	55                   	push   %ebp
  801571:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801573:	8b 55 0c             	mov    0xc(%ebp),%edx
  801576:	8b 45 08             	mov    0x8(%ebp),%eax
  801579:	6a 00                	push   $0x0
  80157b:	6a 00                	push   $0x0
  80157d:	6a 00                	push   $0x0
  80157f:	52                   	push   %edx
  801580:	50                   	push   %eax
  801581:	6a 18                	push   $0x18
  801583:	e8 8b fd ff ff       	call   801313 <syscall>
  801588:	83 c4 18             	add    $0x18,%esp
}
  80158b:	c9                   	leave  
  80158c:	c3                   	ret    

0080158d <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  80158d:	55                   	push   %ebp
  80158e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801590:	8b 45 08             	mov    0x8(%ebp),%eax
  801593:	6a 00                	push   $0x0
  801595:	ff 75 14             	pushl  0x14(%ebp)
  801598:	ff 75 10             	pushl  0x10(%ebp)
  80159b:	ff 75 0c             	pushl  0xc(%ebp)
  80159e:	50                   	push   %eax
  80159f:	6a 19                	push   $0x19
  8015a1:	e8 6d fd ff ff       	call   801313 <syscall>
  8015a6:	83 c4 18             	add    $0x18,%esp
}
  8015a9:	c9                   	leave  
  8015aa:	c3                   	ret    

008015ab <sys_run_env>:

void sys_run_env(int32 envId)
{
  8015ab:	55                   	push   %ebp
  8015ac:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  8015ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8015b1:	6a 00                	push   $0x0
  8015b3:	6a 00                	push   $0x0
  8015b5:	6a 00                	push   $0x0
  8015b7:	6a 00                	push   $0x0
  8015b9:	50                   	push   %eax
  8015ba:	6a 1a                	push   $0x1a
  8015bc:	e8 52 fd ff ff       	call   801313 <syscall>
  8015c1:	83 c4 18             	add    $0x18,%esp
}
  8015c4:	90                   	nop
  8015c5:	c9                   	leave  
  8015c6:	c3                   	ret    

008015c7 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  8015c7:	55                   	push   %ebp
  8015c8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  8015ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8015cd:	6a 00                	push   $0x0
  8015cf:	6a 00                	push   $0x0
  8015d1:	6a 00                	push   $0x0
  8015d3:	6a 00                	push   $0x0
  8015d5:	50                   	push   %eax
  8015d6:	6a 1b                	push   $0x1b
  8015d8:	e8 36 fd ff ff       	call   801313 <syscall>
  8015dd:	83 c4 18             	add    $0x18,%esp
}
  8015e0:	c9                   	leave  
  8015e1:	c3                   	ret    

008015e2 <sys_getenvid>:

int32 sys_getenvid(void)
{
  8015e2:	55                   	push   %ebp
  8015e3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  8015e5:	6a 00                	push   $0x0
  8015e7:	6a 00                	push   $0x0
  8015e9:	6a 00                	push   $0x0
  8015eb:	6a 00                	push   $0x0
  8015ed:	6a 00                	push   $0x0
  8015ef:	6a 05                	push   $0x5
  8015f1:	e8 1d fd ff ff       	call   801313 <syscall>
  8015f6:	83 c4 18             	add    $0x18,%esp
}
  8015f9:	c9                   	leave  
  8015fa:	c3                   	ret    

008015fb <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  8015fb:	55                   	push   %ebp
  8015fc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  8015fe:	6a 00                	push   $0x0
  801600:	6a 00                	push   $0x0
  801602:	6a 00                	push   $0x0
  801604:	6a 00                	push   $0x0
  801606:	6a 00                	push   $0x0
  801608:	6a 06                	push   $0x6
  80160a:	e8 04 fd ff ff       	call   801313 <syscall>
  80160f:	83 c4 18             	add    $0x18,%esp
}
  801612:	c9                   	leave  
  801613:	c3                   	ret    

00801614 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801614:	55                   	push   %ebp
  801615:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801617:	6a 00                	push   $0x0
  801619:	6a 00                	push   $0x0
  80161b:	6a 00                	push   $0x0
  80161d:	6a 00                	push   $0x0
  80161f:	6a 00                	push   $0x0
  801621:	6a 07                	push   $0x7
  801623:	e8 eb fc ff ff       	call   801313 <syscall>
  801628:	83 c4 18             	add    $0x18,%esp
}
  80162b:	c9                   	leave  
  80162c:	c3                   	ret    

0080162d <sys_exit_env>:


void sys_exit_env(void)
{
  80162d:	55                   	push   %ebp
  80162e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801630:	6a 00                	push   $0x0
  801632:	6a 00                	push   $0x0
  801634:	6a 00                	push   $0x0
  801636:	6a 00                	push   $0x0
  801638:	6a 00                	push   $0x0
  80163a:	6a 1c                	push   $0x1c
  80163c:	e8 d2 fc ff ff       	call   801313 <syscall>
  801641:	83 c4 18             	add    $0x18,%esp
}
  801644:	90                   	nop
  801645:	c9                   	leave  
  801646:	c3                   	ret    

00801647 <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  801647:	55                   	push   %ebp
  801648:	89 e5                	mov    %esp,%ebp
  80164a:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  80164d:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801650:	8d 50 04             	lea    0x4(%eax),%edx
  801653:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801656:	6a 00                	push   $0x0
  801658:	6a 00                	push   $0x0
  80165a:	6a 00                	push   $0x0
  80165c:	52                   	push   %edx
  80165d:	50                   	push   %eax
  80165e:	6a 1d                	push   $0x1d
  801660:	e8 ae fc ff ff       	call   801313 <syscall>
  801665:	83 c4 18             	add    $0x18,%esp
	return result;
  801668:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80166b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80166e:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801671:	89 01                	mov    %eax,(%ecx)
  801673:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801676:	8b 45 08             	mov    0x8(%ebp),%eax
  801679:	c9                   	leave  
  80167a:	c2 04 00             	ret    $0x4

0080167d <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  80167d:	55                   	push   %ebp
  80167e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801680:	6a 00                	push   $0x0
  801682:	6a 00                	push   $0x0
  801684:	ff 75 10             	pushl  0x10(%ebp)
  801687:	ff 75 0c             	pushl  0xc(%ebp)
  80168a:	ff 75 08             	pushl  0x8(%ebp)
  80168d:	6a 13                	push   $0x13
  80168f:	e8 7f fc ff ff       	call   801313 <syscall>
  801694:	83 c4 18             	add    $0x18,%esp
	return ;
  801697:	90                   	nop
}
  801698:	c9                   	leave  
  801699:	c3                   	ret    

0080169a <sys_rcr2>:
uint32 sys_rcr2()
{
  80169a:	55                   	push   %ebp
  80169b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  80169d:	6a 00                	push   $0x0
  80169f:	6a 00                	push   $0x0
  8016a1:	6a 00                	push   $0x0
  8016a3:	6a 00                	push   $0x0
  8016a5:	6a 00                	push   $0x0
  8016a7:	6a 1e                	push   $0x1e
  8016a9:	e8 65 fc ff ff       	call   801313 <syscall>
  8016ae:	83 c4 18             	add    $0x18,%esp
}
  8016b1:	c9                   	leave  
  8016b2:	c3                   	ret    

008016b3 <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  8016b3:	55                   	push   %ebp
  8016b4:	89 e5                	mov    %esp,%ebp
  8016b6:	83 ec 04             	sub    $0x4,%esp
  8016b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8016bc:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  8016bf:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  8016c3:	6a 00                	push   $0x0
  8016c5:	6a 00                	push   $0x0
  8016c7:	6a 00                	push   $0x0
  8016c9:	6a 00                	push   $0x0
  8016cb:	50                   	push   %eax
  8016cc:	6a 1f                	push   $0x1f
  8016ce:	e8 40 fc ff ff       	call   801313 <syscall>
  8016d3:	83 c4 18             	add    $0x18,%esp
	return ;
  8016d6:	90                   	nop
}
  8016d7:	c9                   	leave  
  8016d8:	c3                   	ret    

008016d9 <rsttst>:
void rsttst()
{
  8016d9:	55                   	push   %ebp
  8016da:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  8016dc:	6a 00                	push   $0x0
  8016de:	6a 00                	push   $0x0
  8016e0:	6a 00                	push   $0x0
  8016e2:	6a 00                	push   $0x0
  8016e4:	6a 00                	push   $0x0
  8016e6:	6a 21                	push   $0x21
  8016e8:	e8 26 fc ff ff       	call   801313 <syscall>
  8016ed:	83 c4 18             	add    $0x18,%esp
	return ;
  8016f0:	90                   	nop
}
  8016f1:	c9                   	leave  
  8016f2:	c3                   	ret    

008016f3 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  8016f3:	55                   	push   %ebp
  8016f4:	89 e5                	mov    %esp,%ebp
  8016f6:	83 ec 04             	sub    $0x4,%esp
  8016f9:	8b 45 14             	mov    0x14(%ebp),%eax
  8016fc:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  8016ff:	8b 55 18             	mov    0x18(%ebp),%edx
  801702:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801706:	52                   	push   %edx
  801707:	50                   	push   %eax
  801708:	ff 75 10             	pushl  0x10(%ebp)
  80170b:	ff 75 0c             	pushl  0xc(%ebp)
  80170e:	ff 75 08             	pushl  0x8(%ebp)
  801711:	6a 20                	push   $0x20
  801713:	e8 fb fb ff ff       	call   801313 <syscall>
  801718:	83 c4 18             	add    $0x18,%esp
	return ;
  80171b:	90                   	nop
}
  80171c:	c9                   	leave  
  80171d:	c3                   	ret    

0080171e <chktst>:
void chktst(uint32 n)
{
  80171e:	55                   	push   %ebp
  80171f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801721:	6a 00                	push   $0x0
  801723:	6a 00                	push   $0x0
  801725:	6a 00                	push   $0x0
  801727:	6a 00                	push   $0x0
  801729:	ff 75 08             	pushl  0x8(%ebp)
  80172c:	6a 22                	push   $0x22
  80172e:	e8 e0 fb ff ff       	call   801313 <syscall>
  801733:	83 c4 18             	add    $0x18,%esp
	return ;
  801736:	90                   	nop
}
  801737:	c9                   	leave  
  801738:	c3                   	ret    

00801739 <inctst>:

void inctst()
{
  801739:	55                   	push   %ebp
  80173a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  80173c:	6a 00                	push   $0x0
  80173e:	6a 00                	push   $0x0
  801740:	6a 00                	push   $0x0
  801742:	6a 00                	push   $0x0
  801744:	6a 00                	push   $0x0
  801746:	6a 23                	push   $0x23
  801748:	e8 c6 fb ff ff       	call   801313 <syscall>
  80174d:	83 c4 18             	add    $0x18,%esp
	return ;
  801750:	90                   	nop
}
  801751:	c9                   	leave  
  801752:	c3                   	ret    

00801753 <gettst>:
uint32 gettst()
{
  801753:	55                   	push   %ebp
  801754:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801756:	6a 00                	push   $0x0
  801758:	6a 00                	push   $0x0
  80175a:	6a 00                	push   $0x0
  80175c:	6a 00                	push   $0x0
  80175e:	6a 00                	push   $0x0
  801760:	6a 24                	push   $0x24
  801762:	e8 ac fb ff ff       	call   801313 <syscall>
  801767:	83 c4 18             	add    $0x18,%esp
}
  80176a:	c9                   	leave  
  80176b:	c3                   	ret    

0080176c <sys_get_uheap_strategy>:

/*2025*/
uint32 sys_get_uheap_strategy()
{
  80176c:	55                   	push   %ebp
  80176d:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80176f:	6a 00                	push   $0x0
  801771:	6a 00                	push   $0x0
  801773:	6a 00                	push   $0x0
  801775:	6a 00                	push   $0x0
  801777:	6a 00                	push   $0x0
  801779:	6a 25                	push   $0x25
  80177b:	e8 93 fb ff ff       	call   801313 <syscall>
  801780:	83 c4 18             	add    $0x18,%esp
  801783:	a3 60 b0 81 00       	mov    %eax,0x81b060
	return uheapPlaceStrategy ;
  801788:	a1 60 b0 81 00       	mov    0x81b060,%eax
}
  80178d:	c9                   	leave  
  80178e:	c3                   	ret    

0080178f <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  80178f:	55                   	push   %ebp
  801790:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = heapStrategy;
  801792:	8b 45 08             	mov    0x8(%ebp),%eax
  801795:	a3 60 b0 81 00       	mov    %eax,0x81b060
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  80179a:	6a 00                	push   $0x0
  80179c:	6a 00                	push   $0x0
  80179e:	6a 00                	push   $0x0
  8017a0:	6a 00                	push   $0x0
  8017a2:	ff 75 08             	pushl  0x8(%ebp)
  8017a5:	6a 26                	push   $0x26
  8017a7:	e8 67 fb ff ff       	call   801313 <syscall>
  8017ac:	83 c4 18             	add    $0x18,%esp
	return ;
  8017af:	90                   	nop
}
  8017b0:	c9                   	leave  
  8017b1:	c3                   	ret    

008017b2 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  8017b2:	55                   	push   %ebp
  8017b3:	89 e5                	mov    %esp,%ebp
  8017b5:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  8017b6:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8017b9:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8017bc:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8017c2:	6a 00                	push   $0x0
  8017c4:	53                   	push   %ebx
  8017c5:	51                   	push   %ecx
  8017c6:	52                   	push   %edx
  8017c7:	50                   	push   %eax
  8017c8:	6a 27                	push   $0x27
  8017ca:	e8 44 fb ff ff       	call   801313 <syscall>
  8017cf:	83 c4 18             	add    $0x18,%esp
}
  8017d2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8017d5:	c9                   	leave  
  8017d6:	c3                   	ret    

008017d7 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  8017d7:	55                   	push   %ebp
  8017d8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  8017da:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8017e0:	6a 00                	push   $0x0
  8017e2:	6a 00                	push   $0x0
  8017e4:	6a 00                	push   $0x0
  8017e6:	52                   	push   %edx
  8017e7:	50                   	push   %eax
  8017e8:	6a 28                	push   $0x28
  8017ea:	e8 24 fb ff ff       	call   801313 <syscall>
  8017ef:	83 c4 18             	add    $0x18,%esp
}
  8017f2:	c9                   	leave  
  8017f3:	c3                   	ret    

008017f4 <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  8017f4:	55                   	push   %ebp
  8017f5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  8017f7:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8017fa:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017fd:	8b 45 08             	mov    0x8(%ebp),%eax
  801800:	6a 00                	push   $0x0
  801802:	51                   	push   %ecx
  801803:	ff 75 10             	pushl  0x10(%ebp)
  801806:	52                   	push   %edx
  801807:	50                   	push   %eax
  801808:	6a 29                	push   $0x29
  80180a:	e8 04 fb ff ff       	call   801313 <syscall>
  80180f:	83 c4 18             	add    $0x18,%esp
}
  801812:	c9                   	leave  
  801813:	c3                   	ret    

00801814 <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801814:	55                   	push   %ebp
  801815:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801817:	6a 00                	push   $0x0
  801819:	6a 00                	push   $0x0
  80181b:	ff 75 10             	pushl  0x10(%ebp)
  80181e:	ff 75 0c             	pushl  0xc(%ebp)
  801821:	ff 75 08             	pushl  0x8(%ebp)
  801824:	6a 12                	push   $0x12
  801826:	e8 e8 fa ff ff       	call   801313 <syscall>
  80182b:	83 c4 18             	add    $0x18,%esp
	return ;
  80182e:	90                   	nop
}
  80182f:	c9                   	leave  
  801830:	c3                   	ret    

00801831 <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  801831:	55                   	push   %ebp
  801832:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  801834:	8b 55 0c             	mov    0xc(%ebp),%edx
  801837:	8b 45 08             	mov    0x8(%ebp),%eax
  80183a:	6a 00                	push   $0x0
  80183c:	6a 00                	push   $0x0
  80183e:	6a 00                	push   $0x0
  801840:	52                   	push   %edx
  801841:	50                   	push   %eax
  801842:	6a 2a                	push   $0x2a
  801844:	e8 ca fa ff ff       	call   801313 <syscall>
  801849:	83 c4 18             	add    $0x18,%esp
	return;
  80184c:	90                   	nop
}
  80184d:	c9                   	leave  
  80184e:	c3                   	ret    

0080184f <sys_get_optimal_num_faults>:
/*2025*/
int sys_get_optimal_num_faults()
{
  80184f:	55                   	push   %ebp
  801850:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_optimal_num_faults, 0, 0, 0, 0, 0);
  801852:	6a 00                	push   $0x0
  801854:	6a 00                	push   $0x0
  801856:	6a 00                	push   $0x0
  801858:	6a 00                	push   $0x0
  80185a:	6a 00                	push   $0x0
  80185c:	6a 2b                	push   $0x2b
  80185e:	e8 b0 fa ff ff       	call   801313 <syscall>
  801863:	83 c4 18             	add    $0x18,%esp
}
  801866:	c9                   	leave  
  801867:	c3                   	ret    

00801868 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801868:	55                   	push   %ebp
  801869:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  80186b:	6a 00                	push   $0x0
  80186d:	6a 00                	push   $0x0
  80186f:	6a 00                	push   $0x0
  801871:	ff 75 0c             	pushl  0xc(%ebp)
  801874:	ff 75 08             	pushl  0x8(%ebp)
  801877:	6a 2d                	push   $0x2d
  801879:	e8 95 fa ff ff       	call   801313 <syscall>
  80187e:	83 c4 18             	add    $0x18,%esp
	return;
  801881:	90                   	nop
}
  801882:	c9                   	leave  
  801883:	c3                   	ret    

00801884 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801884:	55                   	push   %ebp
  801885:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801887:	6a 00                	push   $0x0
  801889:	6a 00                	push   $0x0
  80188b:	6a 00                	push   $0x0
  80188d:	ff 75 0c             	pushl  0xc(%ebp)
  801890:	ff 75 08             	pushl  0x8(%ebp)
  801893:	6a 2c                	push   $0x2c
  801895:	e8 79 fa ff ff       	call   801313 <syscall>
  80189a:	83 c4 18             	add    $0x18,%esp
	return ;
  80189d:	90                   	nop
}
  80189e:	c9                   	leave  
  80189f:	c3                   	ret    

008018a0 <sys_env_set_priority>:


void sys_env_set_priority(int32 envID, int priority)
{
  8018a0:	55                   	push   %ebp
  8018a1:	89 e5                	mov    %esp,%ebp
  8018a3:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.IM#4] CPU SCHEDULING - #1 System Calls - Add suitable code here
	//Your code is here
	//Comment the following line
	panic("sys_env_set_priority() is not implemented yet...!!");
  8018a6:	83 ec 04             	sub    $0x4,%esp
  8018a9:	68 28 24 80 00       	push   $0x802428
  8018ae:	68 25 01 00 00       	push   $0x125
  8018b3:	68 5b 24 80 00       	push   $0x80245b
  8018b8:	e8 be 00 00 00       	call   80197b <_panic>

008018bd <env_sleep>:
#include <inc/lib.h>
#include <inc/timerreg.h>

void
env_sleep(uint32 approxMilliSeconds)
{
  8018bd:	55                   	push   %ebp
  8018be:	89 e5                	mov    %esp,%ebp
  8018c0:	83 ec 30             	sub    $0x30,%esp
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
  8018c3:	8b 55 08             	mov    0x8(%ebp),%edx
  8018c6:	89 d0                	mov    %edx,%eax
  8018c8:	c1 e0 02             	shl    $0x2,%eax
  8018cb:	01 d0                	add    %edx,%eax
  8018cd:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8018d4:	01 d0                	add    %edx,%eax
  8018d6:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8018dd:	01 d0                	add    %edx,%eax
  8018df:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8018e6:	01 d0                	add    %edx,%eax
  8018e8:	c1 e0 04             	shl    $0x4,%eax
  8018eb:	89 45 f8             	mov    %eax,-0x8(%ebp)
	uint32 cycles_counter =0;
  8018ee:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)

static inline __attribute__((always_inline)) struct uint64 get_virtual_time_user()
{
	struct uint64 result;

	__asm __volatile("rdtsc\n"
  8018f5:	0f 31                	rdtsc  
  8018f7:	89 45 e8             	mov    %eax,-0x18(%ebp)
  8018fa:	89 55 ec             	mov    %edx,-0x14(%ebp)
	: "=a" (result.low), "=d" (result.hi)
	);

	return result;
  8018fd:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801900:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801903:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801906:	89 55 f4             	mov    %edx,-0xc(%ebp)

	/*2024*/ //USE A USER-SIDE VERSION OF THIS FUNCTION TO AVOID SLOW-DOWN THE PERFORMANCE DUE SYS_CALL (el7 :))
	//struct uint64 baseTime = sys_get_virtual_time() ;
	struct uint64 baseTime = get_virtual_time_user() ;
	while(cycles_counter<time_in_cycles)
  801909:	eb 46                	jmp    801951 <env_sleep+0x94>

static inline __attribute__((always_inline)) struct uint64 get_virtual_time_user()
{
	struct uint64 result;

	__asm __volatile("rdtsc\n"
  80190b:	0f 31                	rdtsc  
  80190d:	89 45 d0             	mov    %eax,-0x30(%ebp)
  801910:	89 55 d4             	mov    %edx,-0x2c(%ebp)
	: "=a" (result.low), "=d" (result.hi)
	);

	return result;
  801913:	8b 45 d0             	mov    -0x30(%ebp),%eax
  801916:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  801919:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80191c:	89 55 e4             	mov    %edx,-0x1c(%ebp)

		// update the cycles_count
		#define M32 0xffffffff
		// subtract basetime from current time
		struct uint64 res;
		res.low = (currentTime.low - baseTime.low) & M32;
  80191f:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801922:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801925:	29 c2                	sub    %eax,%edx
  801927:	89 d0                	mov    %edx,%eax
  801929:	89 45 d8             	mov    %eax,-0x28(%ebp)
		res.hi = (currentTime.hi - baseTime.hi - (res.low > currentTime.low)) & M32;
  80192c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80192f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801932:	89 d1                	mov    %edx,%ecx
  801934:	29 c1                	sub    %eax,%ecx
  801936:	8b 55 d8             	mov    -0x28(%ebp),%edx
  801939:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80193c:	39 c2                	cmp    %eax,%edx
  80193e:	0f 97 c0             	seta   %al
  801941:	0f b6 c0             	movzbl %al,%eax
  801944:	29 c1                	sub    %eax,%ecx
  801946:	89 c8                	mov    %ecx,%eax
  801948:	89 45 dc             	mov    %eax,-0x24(%ebp)

		//update cycles_count with result
		cycles_counter = res.low;
  80194b:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80194e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	uint32 cycles_counter =0;

	/*2024*/ //USE A USER-SIDE VERSION OF THIS FUNCTION TO AVOID SLOW-DOWN THE PERFORMANCE DUE SYS_CALL (el7 :))
	//struct uint64 baseTime = sys_get_virtual_time() ;
	struct uint64 baseTime = get_virtual_time_user() ;
	while(cycles_counter<time_in_cycles)
  801951:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801954:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801957:	72 b2                	jb     80190b <env_sleep+0x4e>
//				,cycles_counter
//				);
	}
	//cprintf("%s [%d] wake up now!\n", myEnv->prog_name, myEnv->env_id);

}
  801959:	90                   	nop
  80195a:	c9                   	leave  
  80195b:	c3                   	ret    

0080195c <busy_wait>:

//2017
uint32 busy_wait(uint32 loopMax)
{
  80195c:	55                   	push   %ebp
  80195d:	89 e5                	mov    %esp,%ebp
  80195f:	83 ec 10             	sub    $0x10,%esp
	uint32 i = 0 ;
  801962:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	while (i < loopMax) i++;
  801969:	eb 03                	jmp    80196e <busy_wait+0x12>
  80196b:	ff 45 fc             	incl   -0x4(%ebp)
  80196e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801971:	3b 45 08             	cmp    0x8(%ebp),%eax
  801974:	72 f5                	jb     80196b <busy_wait+0xf>
	return i;
  801976:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801979:	c9                   	leave  
  80197a:	c3                   	ret    

0080197b <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  80197b:	55                   	push   %ebp
  80197c:	89 e5                	mov    %esp,%ebp
  80197e:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  801981:	8d 45 10             	lea    0x10(%ebp),%eax
  801984:	83 c0 04             	add    $0x4,%eax
  801987:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  80198a:	a1 1c b1 81 00       	mov    0x81b11c,%eax
  80198f:	85 c0                	test   %eax,%eax
  801991:	74 16                	je     8019a9 <_panic+0x2e>
		cprintf("%s: ", argv0);
  801993:	a1 1c b1 81 00       	mov    0x81b11c,%eax
  801998:	83 ec 08             	sub    $0x8,%esp
  80199b:	50                   	push   %eax
  80199c:	68 6c 24 80 00       	push   $0x80246c
  8019a1:	e8 88 ea ff ff       	call   80042e <cprintf>
  8019a6:	83 c4 10             	add    $0x10,%esp
	cprintf_colored(TEXT_PANIC_CLR, "user [EVAL_FINAL]panic in %s at %s:%d: ", binaryname, file, line);
  8019a9:	a1 04 30 80 00       	mov    0x803004,%eax
  8019ae:	83 ec 0c             	sub    $0xc,%esp
  8019b1:	ff 75 0c             	pushl  0xc(%ebp)
  8019b4:	ff 75 08             	pushl  0x8(%ebp)
  8019b7:	50                   	push   %eax
  8019b8:	68 74 24 80 00       	push   $0x802474
  8019bd:	6a 74                	push   $0x74
  8019bf:	e8 97 ea ff ff       	call   80045b <cprintf_colored>
  8019c4:	83 c4 20             	add    $0x20,%esp
	vcprintf(fmt, ap);
  8019c7:	8b 45 10             	mov    0x10(%ebp),%eax
  8019ca:	83 ec 08             	sub    $0x8,%esp
  8019cd:	ff 75 f4             	pushl  -0xc(%ebp)
  8019d0:	50                   	push   %eax
  8019d1:	e8 e9 e9 ff ff       	call   8003bf <vcprintf>
  8019d6:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  8019d9:	83 ec 08             	sub    $0x8,%esp
  8019dc:	6a 00                	push   $0x0
  8019de:	68 9c 24 80 00       	push   $0x80249c
  8019e3:	e8 d7 e9 ff ff       	call   8003bf <vcprintf>
  8019e8:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  8019eb:	e8 50 e9 ff ff       	call   800340 <exit>

	// should not return here
	while (1) ;
  8019f0:	eb fe                	jmp    8019f0 <_panic+0x75>

008019f2 <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  8019f2:	55                   	push   %ebp
  8019f3:	89 e5                	mov    %esp,%ebp
  8019f5:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  8019f8:	a1 20 30 80 00       	mov    0x803020,%eax
  8019fd:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  801a03:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a06:	39 c2                	cmp    %eax,%edx
  801a08:	74 14                	je     801a1e <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  801a0a:	83 ec 04             	sub    $0x4,%esp
  801a0d:	68 a0 24 80 00       	push   $0x8024a0
  801a12:	6a 26                	push   $0x26
  801a14:	68 ec 24 80 00       	push   $0x8024ec
  801a19:	e8 5d ff ff ff       	call   80197b <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  801a1e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  801a25:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  801a2c:	e9 c5 00 00 00       	jmp    801af6 <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  801a31:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a34:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801a3b:	8b 45 08             	mov    0x8(%ebp),%eax
  801a3e:	01 d0                	add    %edx,%eax
  801a40:	8b 00                	mov    (%eax),%eax
  801a42:	85 c0                	test   %eax,%eax
  801a44:	75 08                	jne    801a4e <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  801a46:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  801a49:	e9 a5 00 00 00       	jmp    801af3 <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  801a4e:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  801a55:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  801a5c:	eb 69                	jmp    801ac7 <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  801a5e:	a1 20 30 80 00       	mov    0x803020,%eax
  801a63:	8b 88 38 da 01 00    	mov    0x1da38(%eax),%ecx
  801a69:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801a6c:	89 d0                	mov    %edx,%eax
  801a6e:	01 c0                	add    %eax,%eax
  801a70:	01 d0                	add    %edx,%eax
  801a72:	c1 e0 03             	shl    $0x3,%eax
  801a75:	01 c8                	add    %ecx,%eax
  801a77:	8a 40 04             	mov    0x4(%eax),%al
  801a7a:	84 c0                	test   %al,%al
  801a7c:	75 46                	jne    801ac4 <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  801a7e:	a1 20 30 80 00       	mov    0x803020,%eax
  801a83:	8b 88 38 da 01 00    	mov    0x1da38(%eax),%ecx
  801a89:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801a8c:	89 d0                	mov    %edx,%eax
  801a8e:	01 c0                	add    %eax,%eax
  801a90:	01 d0                	add    %edx,%eax
  801a92:	c1 e0 03             	shl    $0x3,%eax
  801a95:	01 c8                	add    %ecx,%eax
  801a97:	8b 00                	mov    (%eax),%eax
  801a99:	89 45 dc             	mov    %eax,-0x24(%ebp)
  801a9c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801a9f:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801aa4:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  801aa6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801aa9:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  801ab0:	8b 45 08             	mov    0x8(%ebp),%eax
  801ab3:	01 c8                	add    %ecx,%eax
  801ab5:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  801ab7:	39 c2                	cmp    %eax,%edx
  801ab9:	75 09                	jne    801ac4 <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  801abb:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  801ac2:	eb 15                	jmp    801ad9 <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  801ac4:	ff 45 e8             	incl   -0x18(%ebp)
  801ac7:	a1 20 30 80 00       	mov    0x803020,%eax
  801acc:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  801ad2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801ad5:	39 c2                	cmp    %eax,%edx
  801ad7:	77 85                	ja     801a5e <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  801ad9:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801add:	75 14                	jne    801af3 <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  801adf:	83 ec 04             	sub    $0x4,%esp
  801ae2:	68 f8 24 80 00       	push   $0x8024f8
  801ae7:	6a 3a                	push   $0x3a
  801ae9:	68 ec 24 80 00       	push   $0x8024ec
  801aee:	e8 88 fe ff ff       	call   80197b <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  801af3:	ff 45 f0             	incl   -0x10(%ebp)
  801af6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801af9:	3b 45 0c             	cmp    0xc(%ebp),%eax
  801afc:	0f 8c 2f ff ff ff    	jl     801a31 <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  801b02:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  801b09:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  801b10:	eb 26                	jmp    801b38 <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  801b12:	a1 20 30 80 00       	mov    0x803020,%eax
  801b17:	8b 88 38 da 01 00    	mov    0x1da38(%eax),%ecx
  801b1d:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801b20:	89 d0                	mov    %edx,%eax
  801b22:	01 c0                	add    %eax,%eax
  801b24:	01 d0                	add    %edx,%eax
  801b26:	c1 e0 03             	shl    $0x3,%eax
  801b29:	01 c8                	add    %ecx,%eax
  801b2b:	8a 40 04             	mov    0x4(%eax),%al
  801b2e:	3c 01                	cmp    $0x1,%al
  801b30:	75 03                	jne    801b35 <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  801b32:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  801b35:	ff 45 e0             	incl   -0x20(%ebp)
  801b38:	a1 20 30 80 00       	mov    0x803020,%eax
  801b3d:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  801b43:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801b46:	39 c2                	cmp    %eax,%edx
  801b48:	77 c8                	ja     801b12 <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  801b4a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b4d:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  801b50:	74 14                	je     801b66 <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  801b52:	83 ec 04             	sub    $0x4,%esp
  801b55:	68 4c 25 80 00       	push   $0x80254c
  801b5a:	6a 44                	push   $0x44
  801b5c:	68 ec 24 80 00       	push   $0x8024ec
  801b61:	e8 15 fe ff ff       	call   80197b <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  801b66:	90                   	nop
  801b67:	c9                   	leave  
  801b68:	c3                   	ret    
  801b69:	66 90                	xchg   %ax,%ax
  801b6b:	90                   	nop

00801b6c <__udivdi3>:
  801b6c:	55                   	push   %ebp
  801b6d:	57                   	push   %edi
  801b6e:	56                   	push   %esi
  801b6f:	53                   	push   %ebx
  801b70:	83 ec 1c             	sub    $0x1c,%esp
  801b73:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  801b77:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  801b7b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801b7f:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801b83:	89 ca                	mov    %ecx,%edx
  801b85:	89 f8                	mov    %edi,%eax
  801b87:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  801b8b:	85 f6                	test   %esi,%esi
  801b8d:	75 2d                	jne    801bbc <__udivdi3+0x50>
  801b8f:	39 cf                	cmp    %ecx,%edi
  801b91:	77 65                	ja     801bf8 <__udivdi3+0x8c>
  801b93:	89 fd                	mov    %edi,%ebp
  801b95:	85 ff                	test   %edi,%edi
  801b97:	75 0b                	jne    801ba4 <__udivdi3+0x38>
  801b99:	b8 01 00 00 00       	mov    $0x1,%eax
  801b9e:	31 d2                	xor    %edx,%edx
  801ba0:	f7 f7                	div    %edi
  801ba2:	89 c5                	mov    %eax,%ebp
  801ba4:	31 d2                	xor    %edx,%edx
  801ba6:	89 c8                	mov    %ecx,%eax
  801ba8:	f7 f5                	div    %ebp
  801baa:	89 c1                	mov    %eax,%ecx
  801bac:	89 d8                	mov    %ebx,%eax
  801bae:	f7 f5                	div    %ebp
  801bb0:	89 cf                	mov    %ecx,%edi
  801bb2:	89 fa                	mov    %edi,%edx
  801bb4:	83 c4 1c             	add    $0x1c,%esp
  801bb7:	5b                   	pop    %ebx
  801bb8:	5e                   	pop    %esi
  801bb9:	5f                   	pop    %edi
  801bba:	5d                   	pop    %ebp
  801bbb:	c3                   	ret    
  801bbc:	39 ce                	cmp    %ecx,%esi
  801bbe:	77 28                	ja     801be8 <__udivdi3+0x7c>
  801bc0:	0f bd fe             	bsr    %esi,%edi
  801bc3:	83 f7 1f             	xor    $0x1f,%edi
  801bc6:	75 40                	jne    801c08 <__udivdi3+0x9c>
  801bc8:	39 ce                	cmp    %ecx,%esi
  801bca:	72 0a                	jb     801bd6 <__udivdi3+0x6a>
  801bcc:	3b 44 24 08          	cmp    0x8(%esp),%eax
  801bd0:	0f 87 9e 00 00 00    	ja     801c74 <__udivdi3+0x108>
  801bd6:	b8 01 00 00 00       	mov    $0x1,%eax
  801bdb:	89 fa                	mov    %edi,%edx
  801bdd:	83 c4 1c             	add    $0x1c,%esp
  801be0:	5b                   	pop    %ebx
  801be1:	5e                   	pop    %esi
  801be2:	5f                   	pop    %edi
  801be3:	5d                   	pop    %ebp
  801be4:	c3                   	ret    
  801be5:	8d 76 00             	lea    0x0(%esi),%esi
  801be8:	31 ff                	xor    %edi,%edi
  801bea:	31 c0                	xor    %eax,%eax
  801bec:	89 fa                	mov    %edi,%edx
  801bee:	83 c4 1c             	add    $0x1c,%esp
  801bf1:	5b                   	pop    %ebx
  801bf2:	5e                   	pop    %esi
  801bf3:	5f                   	pop    %edi
  801bf4:	5d                   	pop    %ebp
  801bf5:	c3                   	ret    
  801bf6:	66 90                	xchg   %ax,%ax
  801bf8:	89 d8                	mov    %ebx,%eax
  801bfa:	f7 f7                	div    %edi
  801bfc:	31 ff                	xor    %edi,%edi
  801bfe:	89 fa                	mov    %edi,%edx
  801c00:	83 c4 1c             	add    $0x1c,%esp
  801c03:	5b                   	pop    %ebx
  801c04:	5e                   	pop    %esi
  801c05:	5f                   	pop    %edi
  801c06:	5d                   	pop    %ebp
  801c07:	c3                   	ret    
  801c08:	bd 20 00 00 00       	mov    $0x20,%ebp
  801c0d:	89 eb                	mov    %ebp,%ebx
  801c0f:	29 fb                	sub    %edi,%ebx
  801c11:	89 f9                	mov    %edi,%ecx
  801c13:	d3 e6                	shl    %cl,%esi
  801c15:	89 c5                	mov    %eax,%ebp
  801c17:	88 d9                	mov    %bl,%cl
  801c19:	d3 ed                	shr    %cl,%ebp
  801c1b:	89 e9                	mov    %ebp,%ecx
  801c1d:	09 f1                	or     %esi,%ecx
  801c1f:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  801c23:	89 f9                	mov    %edi,%ecx
  801c25:	d3 e0                	shl    %cl,%eax
  801c27:	89 c5                	mov    %eax,%ebp
  801c29:	89 d6                	mov    %edx,%esi
  801c2b:	88 d9                	mov    %bl,%cl
  801c2d:	d3 ee                	shr    %cl,%esi
  801c2f:	89 f9                	mov    %edi,%ecx
  801c31:	d3 e2                	shl    %cl,%edx
  801c33:	8b 44 24 08          	mov    0x8(%esp),%eax
  801c37:	88 d9                	mov    %bl,%cl
  801c39:	d3 e8                	shr    %cl,%eax
  801c3b:	09 c2                	or     %eax,%edx
  801c3d:	89 d0                	mov    %edx,%eax
  801c3f:	89 f2                	mov    %esi,%edx
  801c41:	f7 74 24 0c          	divl   0xc(%esp)
  801c45:	89 d6                	mov    %edx,%esi
  801c47:	89 c3                	mov    %eax,%ebx
  801c49:	f7 e5                	mul    %ebp
  801c4b:	39 d6                	cmp    %edx,%esi
  801c4d:	72 19                	jb     801c68 <__udivdi3+0xfc>
  801c4f:	74 0b                	je     801c5c <__udivdi3+0xf0>
  801c51:	89 d8                	mov    %ebx,%eax
  801c53:	31 ff                	xor    %edi,%edi
  801c55:	e9 58 ff ff ff       	jmp    801bb2 <__udivdi3+0x46>
  801c5a:	66 90                	xchg   %ax,%ax
  801c5c:	8b 54 24 08          	mov    0x8(%esp),%edx
  801c60:	89 f9                	mov    %edi,%ecx
  801c62:	d3 e2                	shl    %cl,%edx
  801c64:	39 c2                	cmp    %eax,%edx
  801c66:	73 e9                	jae    801c51 <__udivdi3+0xe5>
  801c68:	8d 43 ff             	lea    -0x1(%ebx),%eax
  801c6b:	31 ff                	xor    %edi,%edi
  801c6d:	e9 40 ff ff ff       	jmp    801bb2 <__udivdi3+0x46>
  801c72:	66 90                	xchg   %ax,%ax
  801c74:	31 c0                	xor    %eax,%eax
  801c76:	e9 37 ff ff ff       	jmp    801bb2 <__udivdi3+0x46>
  801c7b:	90                   	nop

00801c7c <__umoddi3>:
  801c7c:	55                   	push   %ebp
  801c7d:	57                   	push   %edi
  801c7e:	56                   	push   %esi
  801c7f:	53                   	push   %ebx
  801c80:	83 ec 1c             	sub    $0x1c,%esp
  801c83:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  801c87:	8b 74 24 34          	mov    0x34(%esp),%esi
  801c8b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801c8f:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  801c93:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801c97:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801c9b:	89 f3                	mov    %esi,%ebx
  801c9d:	89 fa                	mov    %edi,%edx
  801c9f:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801ca3:	89 34 24             	mov    %esi,(%esp)
  801ca6:	85 c0                	test   %eax,%eax
  801ca8:	75 1a                	jne    801cc4 <__umoddi3+0x48>
  801caa:	39 f7                	cmp    %esi,%edi
  801cac:	0f 86 a2 00 00 00    	jbe    801d54 <__umoddi3+0xd8>
  801cb2:	89 c8                	mov    %ecx,%eax
  801cb4:	89 f2                	mov    %esi,%edx
  801cb6:	f7 f7                	div    %edi
  801cb8:	89 d0                	mov    %edx,%eax
  801cba:	31 d2                	xor    %edx,%edx
  801cbc:	83 c4 1c             	add    $0x1c,%esp
  801cbf:	5b                   	pop    %ebx
  801cc0:	5e                   	pop    %esi
  801cc1:	5f                   	pop    %edi
  801cc2:	5d                   	pop    %ebp
  801cc3:	c3                   	ret    
  801cc4:	39 f0                	cmp    %esi,%eax
  801cc6:	0f 87 ac 00 00 00    	ja     801d78 <__umoddi3+0xfc>
  801ccc:	0f bd e8             	bsr    %eax,%ebp
  801ccf:	83 f5 1f             	xor    $0x1f,%ebp
  801cd2:	0f 84 ac 00 00 00    	je     801d84 <__umoddi3+0x108>
  801cd8:	bf 20 00 00 00       	mov    $0x20,%edi
  801cdd:	29 ef                	sub    %ebp,%edi
  801cdf:	89 fe                	mov    %edi,%esi
  801ce1:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801ce5:	89 e9                	mov    %ebp,%ecx
  801ce7:	d3 e0                	shl    %cl,%eax
  801ce9:	89 d7                	mov    %edx,%edi
  801ceb:	89 f1                	mov    %esi,%ecx
  801ced:	d3 ef                	shr    %cl,%edi
  801cef:	09 c7                	or     %eax,%edi
  801cf1:	89 e9                	mov    %ebp,%ecx
  801cf3:	d3 e2                	shl    %cl,%edx
  801cf5:	89 14 24             	mov    %edx,(%esp)
  801cf8:	89 d8                	mov    %ebx,%eax
  801cfa:	d3 e0                	shl    %cl,%eax
  801cfc:	89 c2                	mov    %eax,%edx
  801cfe:	8b 44 24 08          	mov    0x8(%esp),%eax
  801d02:	d3 e0                	shl    %cl,%eax
  801d04:	89 44 24 04          	mov    %eax,0x4(%esp)
  801d08:	8b 44 24 08          	mov    0x8(%esp),%eax
  801d0c:	89 f1                	mov    %esi,%ecx
  801d0e:	d3 e8                	shr    %cl,%eax
  801d10:	09 d0                	or     %edx,%eax
  801d12:	d3 eb                	shr    %cl,%ebx
  801d14:	89 da                	mov    %ebx,%edx
  801d16:	f7 f7                	div    %edi
  801d18:	89 d3                	mov    %edx,%ebx
  801d1a:	f7 24 24             	mull   (%esp)
  801d1d:	89 c6                	mov    %eax,%esi
  801d1f:	89 d1                	mov    %edx,%ecx
  801d21:	39 d3                	cmp    %edx,%ebx
  801d23:	0f 82 87 00 00 00    	jb     801db0 <__umoddi3+0x134>
  801d29:	0f 84 91 00 00 00    	je     801dc0 <__umoddi3+0x144>
  801d2f:	8b 54 24 04          	mov    0x4(%esp),%edx
  801d33:	29 f2                	sub    %esi,%edx
  801d35:	19 cb                	sbb    %ecx,%ebx
  801d37:	89 d8                	mov    %ebx,%eax
  801d39:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  801d3d:	d3 e0                	shl    %cl,%eax
  801d3f:	89 e9                	mov    %ebp,%ecx
  801d41:	d3 ea                	shr    %cl,%edx
  801d43:	09 d0                	or     %edx,%eax
  801d45:	89 e9                	mov    %ebp,%ecx
  801d47:	d3 eb                	shr    %cl,%ebx
  801d49:	89 da                	mov    %ebx,%edx
  801d4b:	83 c4 1c             	add    $0x1c,%esp
  801d4e:	5b                   	pop    %ebx
  801d4f:	5e                   	pop    %esi
  801d50:	5f                   	pop    %edi
  801d51:	5d                   	pop    %ebp
  801d52:	c3                   	ret    
  801d53:	90                   	nop
  801d54:	89 fd                	mov    %edi,%ebp
  801d56:	85 ff                	test   %edi,%edi
  801d58:	75 0b                	jne    801d65 <__umoddi3+0xe9>
  801d5a:	b8 01 00 00 00       	mov    $0x1,%eax
  801d5f:	31 d2                	xor    %edx,%edx
  801d61:	f7 f7                	div    %edi
  801d63:	89 c5                	mov    %eax,%ebp
  801d65:	89 f0                	mov    %esi,%eax
  801d67:	31 d2                	xor    %edx,%edx
  801d69:	f7 f5                	div    %ebp
  801d6b:	89 c8                	mov    %ecx,%eax
  801d6d:	f7 f5                	div    %ebp
  801d6f:	89 d0                	mov    %edx,%eax
  801d71:	e9 44 ff ff ff       	jmp    801cba <__umoddi3+0x3e>
  801d76:	66 90                	xchg   %ax,%ax
  801d78:	89 c8                	mov    %ecx,%eax
  801d7a:	89 f2                	mov    %esi,%edx
  801d7c:	83 c4 1c             	add    $0x1c,%esp
  801d7f:	5b                   	pop    %ebx
  801d80:	5e                   	pop    %esi
  801d81:	5f                   	pop    %edi
  801d82:	5d                   	pop    %ebp
  801d83:	c3                   	ret    
  801d84:	3b 04 24             	cmp    (%esp),%eax
  801d87:	72 06                	jb     801d8f <__umoddi3+0x113>
  801d89:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  801d8d:	77 0f                	ja     801d9e <__umoddi3+0x122>
  801d8f:	89 f2                	mov    %esi,%edx
  801d91:	29 f9                	sub    %edi,%ecx
  801d93:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  801d97:	89 14 24             	mov    %edx,(%esp)
  801d9a:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801d9e:	8b 44 24 04          	mov    0x4(%esp),%eax
  801da2:	8b 14 24             	mov    (%esp),%edx
  801da5:	83 c4 1c             	add    $0x1c,%esp
  801da8:	5b                   	pop    %ebx
  801da9:	5e                   	pop    %esi
  801daa:	5f                   	pop    %edi
  801dab:	5d                   	pop    %ebp
  801dac:	c3                   	ret    
  801dad:	8d 76 00             	lea    0x0(%esi),%esi
  801db0:	2b 04 24             	sub    (%esp),%eax
  801db3:	19 fa                	sbb    %edi,%edx
  801db5:	89 d1                	mov    %edx,%ecx
  801db7:	89 c6                	mov    %eax,%esi
  801db9:	e9 71 ff ff ff       	jmp    801d2f <__umoddi3+0xb3>
  801dbe:	66 90                	xchg   %ax,%ax
  801dc0:	39 44 24 04          	cmp    %eax,0x4(%esp)
  801dc4:	72 ea                	jb     801db0 <__umoddi3+0x134>
  801dc6:	89 d9                	mov    %ebx,%ecx
  801dc8:	e9 62 ff ff ff       	jmp    801d2f <__umoddi3+0xb3>
