
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
  80004e:	e8 93 15 00 00       	call   8015e6 <sys_getenvindex>
  800053:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	int32 parentenvID = sys_getparentenvid();
  800056:	e8 a4 15 00 00       	call   8015ff <sys_getparentenvid>
  80005b:	89 45 e0             	mov    %eax,-0x20(%ebp)
	cprintf_colored(TEXT_light_blue, "Cust %d: outside the shop\n", id);
  80005e:	83 ec 04             	sub    $0x4,%esp
  800061:	ff 75 e4             	pushl  -0x1c(%ebp)
  800064:	68 c0 1d 80 00       	push   $0x801dc0
  800069:	6a 09                	push   $0x9
  80006b:	e8 d6 03 00 00       	call   800446 <cprintf_colored>
  800070:	83 c4 10             	add    $0x10,%esp

	//wait_semaphore(shopCapacitySem);
	char waitCmd[64] = "__KSem@0@Wait";
  800073:	8d 45 a0             	lea    -0x60(%ebp),%eax
  800076:	bb 26 1e 80 00       	mov    $0x801e26,%ebx
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
  80009f:	e8 78 17 00 00       	call   80181c <sys_utilities>
  8000a4:	83 c4 10             	add    $0x10,%esp
	{
		cprintf_colored(TEXT_light_cyan,"Cust %d: inside the shop\n", id) ;
  8000a7:	83 ec 04             	sub    $0x4,%esp
  8000aa:	ff 75 e4             	pushl  -0x1c(%ebp)
  8000ad:	68 db 1d 80 00       	push   $0x801ddb
  8000b2:	6a 0b                	push   $0xb
  8000b4:	e8 8d 03 00 00       	call   800446 <cprintf_colored>
  8000b9:	83 c4 10             	add    $0x10,%esp
		env_sleep(1000) ;
  8000bc:	83 ec 0c             	sub    $0xc,%esp
  8000bf:	68 e8 03 00 00       	push   $0x3e8
  8000c4:	e8 df 17 00 00       	call   8018a8 <env_sleep>
  8000c9:	83 c4 10             	add    $0x10,%esp
	}
	char signalCmd1[64] = "__KSem@0@Signal";
  8000cc:	8d 85 60 ff ff ff    	lea    -0xa0(%ebp),%eax
  8000d2:	bb 66 1e 80 00       	mov    $0x801e66,%ebx
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
  800104:	e8 13 17 00 00       	call   80181c <sys_utilities>
  800109:	83 c4 10             	add    $0x10,%esp
	//signal_semaphore(shopCapacitySem);

	cprintf_colored(TEXT_light_blue, "Cust %d: exit the shop\n", id);
  80010c:	83 ec 04             	sub    $0x4,%esp
  80010f:	ff 75 e4             	pushl  -0x1c(%ebp)
  800112:	68 f5 1d 80 00       	push   $0x801df5
  800117:	6a 09                	push   $0x9
  800119:	e8 28 03 00 00       	call   800446 <cprintf_colored>
  80011e:	83 c4 10             	add    $0x10,%esp

	char signalCmd2[64] = "__KSem@1@Signal";
  800121:	8d 85 20 ff ff ff    	lea    -0xe0(%ebp),%eax
  800127:	bb a6 1e 80 00       	mov    $0x801ea6,%ebx
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
  800159:	e8 be 16 00 00       	call   80181c <sys_utilities>
  80015e:	83 c4 10             	add    $0x10,%esp
	//signal_semaphore(dependSem);

	cprintf_colored(TEXT_light_magenta, ">>> Cust %d is Finished\n", id);
  800161:	83 ec 04             	sub    $0x4,%esp
  800164:	ff 75 e4             	pushl  -0x1c(%ebp)
  800167:	68 0d 1e 80 00       	push   $0x801e0d
  80016c:	6a 0d                	push   $0xd
  80016e:	e8 d3 02 00 00       	call   800446 <cprintf_colored>
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
  800192:	e8 4f 14 00 00       	call   8015e6 <sys_getenvindex>
  800197:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	myEnv = &(envs[envIndex]);
  80019a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80019d:	89 d0                	mov    %edx,%eax
  80019f:	c1 e0 02             	shl    $0x2,%eax
  8001a2:	01 d0                	add    %edx,%eax
  8001a4:	c1 e0 03             	shl    $0x3,%eax
  8001a7:	01 d0                	add    %edx,%eax
  8001a9:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  8001b0:	01 d0                	add    %edx,%eax
  8001b2:	c1 e0 02             	shl    $0x2,%eax
  8001b5:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8001ba:	a3 20 30 80 00       	mov    %eax,0x803020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  8001bf:	a1 20 30 80 00       	mov    0x803020,%eax
  8001c4:	8a 40 20             	mov    0x20(%eax),%al
  8001c7:	84 c0                	test   %al,%al
  8001c9:	74 0d                	je     8001d8 <libmain+0x4f>
		binaryname = myEnv->prog_name;
  8001cb:	a1 20 30 80 00       	mov    0x803020,%eax
  8001d0:	83 c0 20             	add    $0x20,%eax
  8001d3:	a3 04 30 80 00       	mov    %eax,0x803004

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8001d8:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8001dc:	7e 0a                	jle    8001e8 <libmain+0x5f>
		binaryname = argv[0];
  8001de:	8b 45 0c             	mov    0xc(%ebp),%eax
  8001e1:	8b 00                	mov    (%eax),%eax
  8001e3:	a3 04 30 80 00       	mov    %eax,0x803004

	// call user main routine
	_main(argc, argv);
  8001e8:	83 ec 08             	sub    $0x8,%esp
  8001eb:	ff 75 0c             	pushl  0xc(%ebp)
  8001ee:	ff 75 08             	pushl  0x8(%ebp)
  8001f1:	e8 42 fe ff ff       	call   800038 <_main>
  8001f6:	83 c4 10             	add    $0x10,%esp

	if (printStats)
  8001f9:	a1 00 30 80 00       	mov    0x803000,%eax
  8001fe:	85 c0                	test   %eax,%eax
  800200:	0f 84 01 01 00 00    	je     800307 <libmain+0x17e>
	{
		char isOPTReplCmd[100] = "__IsOPTRepl__" ;
  800206:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  80020c:	bb e0 1f 80 00       	mov    $0x801fe0,%ebx
  800211:	ba 0e 00 00 00       	mov    $0xe,%edx
  800216:	89 c7                	mov    %eax,%edi
  800218:	89 de                	mov    %ebx,%esi
  80021a:	89 d1                	mov    %edx,%ecx
  80021c:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  80021e:	8d 55 8a             	lea    -0x76(%ebp),%edx
  800221:	b9 56 00 00 00       	mov    $0x56,%ecx
  800226:	b0 00                	mov    $0x0,%al
  800228:	89 d7                	mov    %edx,%edi
  80022a:	f3 aa                	rep stos %al,%es:(%edi)
		int isOPTRepl = 0;
  80022c:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
		sys_utilities(isOPTReplCmd, (uint32)(&isOPTRepl));
  800233:	8d 45 e0             	lea    -0x20(%ebp),%eax
  800236:	83 ec 08             	sub    $0x8,%esp
  800239:	50                   	push   %eax
  80023a:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  800240:	50                   	push   %eax
  800241:	e8 d6 15 00 00       	call   80181c <sys_utilities>
  800246:	83 c4 10             	add    $0x10,%esp

		sys_lock_cons();
  800249:	e8 1f 11 00 00       	call   80136d <sys_lock_cons>
		{
			cprintf("**************************************\n");
  80024e:	83 ec 0c             	sub    $0xc,%esp
  800251:	68 00 1f 80 00       	push   $0x801f00
  800256:	e8 be 01 00 00       	call   800419 <cprintf>
  80025b:	83 c4 10             	add    $0x10,%esp
			if (isOPTRepl)
  80025e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800261:	85 c0                	test   %eax,%eax
  800263:	74 18                	je     80027d <libmain+0xf4>
			{
				cprintf("OPTIMAL number of page faults = %d\n", sys_get_optimal_num_faults());
  800265:	e8 d0 15 00 00       	call   80183a <sys_get_optimal_num_faults>
  80026a:	83 ec 08             	sub    $0x8,%esp
  80026d:	50                   	push   %eax
  80026e:	68 28 1f 80 00       	push   $0x801f28
  800273:	e8 a1 01 00 00       	call   800419 <cprintf>
  800278:	83 c4 10             	add    $0x10,%esp
  80027b:	eb 59                	jmp    8002d6 <libmain+0x14d>
			}
			else
			{
				cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  80027d:	a1 20 30 80 00       	mov    0x803020,%eax
  800282:	8b 90 a8 05 00 00    	mov    0x5a8(%eax),%edx
  800288:	a1 20 30 80 00       	mov    0x803020,%eax
  80028d:	8b 80 98 05 00 00    	mov    0x598(%eax),%eax
  800293:	83 ec 04             	sub    $0x4,%esp
  800296:	52                   	push   %edx
  800297:	50                   	push   %eax
  800298:	68 4c 1f 80 00       	push   $0x801f4c
  80029d:	e8 77 01 00 00       	call   800419 <cprintf>
  8002a2:	83 c4 10             	add    $0x10,%esp
				cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  8002a5:	a1 20 30 80 00       	mov    0x803020,%eax
  8002aa:	8b 88 bc 05 00 00    	mov    0x5bc(%eax),%ecx
  8002b0:	a1 20 30 80 00       	mov    0x803020,%eax
  8002b5:	8b 90 b8 05 00 00    	mov    0x5b8(%eax),%edx
  8002bb:	a1 20 30 80 00       	mov    0x803020,%eax
  8002c0:	8b 80 b4 05 00 00    	mov    0x5b4(%eax),%eax
  8002c6:	51                   	push   %ecx
  8002c7:	52                   	push   %edx
  8002c8:	50                   	push   %eax
  8002c9:	68 74 1f 80 00       	push   $0x801f74
  8002ce:	e8 46 01 00 00       	call   800419 <cprintf>
  8002d3:	83 c4 10             	add    $0x10,%esp
			}
			//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
			cprintf("Num of clocks = %d\n", myEnv->nClocks);
  8002d6:	a1 20 30 80 00       	mov    0x803020,%eax
  8002db:	8b 80 c0 05 00 00    	mov    0x5c0(%eax),%eax
  8002e1:	83 ec 08             	sub    $0x8,%esp
  8002e4:	50                   	push   %eax
  8002e5:	68 cc 1f 80 00       	push   $0x801fcc
  8002ea:	e8 2a 01 00 00       	call   800419 <cprintf>
  8002ef:	83 c4 10             	add    $0x10,%esp
			cprintf("**************************************\n");
  8002f2:	83 ec 0c             	sub    $0xc,%esp
  8002f5:	68 00 1f 80 00       	push   $0x801f00
  8002fa:	e8 1a 01 00 00       	call   800419 <cprintf>
  8002ff:	83 c4 10             	add    $0x10,%esp
		}
		sys_unlock_cons();
  800302:	e8 80 10 00 00       	call   801387 <sys_unlock_cons>
	}

	// exit gracefully
	exit();
  800307:	e8 1f 00 00 00       	call   80032b <exit>
}
  80030c:	90                   	nop
  80030d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800310:	5b                   	pop    %ebx
  800311:	5e                   	pop    %esi
  800312:	5f                   	pop    %edi
  800313:	5d                   	pop    %ebp
  800314:	c3                   	ret    

00800315 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800315:	55                   	push   %ebp
  800316:	89 e5                	mov    %esp,%ebp
  800318:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  80031b:	83 ec 0c             	sub    $0xc,%esp
  80031e:	6a 00                	push   $0x0
  800320:	e8 8d 12 00 00       	call   8015b2 <sys_destroy_env>
  800325:	83 c4 10             	add    $0x10,%esp
}
  800328:	90                   	nop
  800329:	c9                   	leave  
  80032a:	c3                   	ret    

0080032b <exit>:

void
exit(void)
{
  80032b:	55                   	push   %ebp
  80032c:	89 e5                	mov    %esp,%ebp
  80032e:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  800331:	e8 e2 12 00 00       	call   801618 <sys_exit_env>
}
  800336:	90                   	nop
  800337:	c9                   	leave  
  800338:	c3                   	ret    

00800339 <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  800339:	55                   	push   %ebp
  80033a:	89 e5                	mov    %esp,%ebp
  80033c:	53                   	push   %ebx
  80033d:	83 ec 04             	sub    $0x4,%esp
	b->buf[b->idx++] = ch;
  800340:	8b 45 0c             	mov    0xc(%ebp),%eax
  800343:	8b 00                	mov    (%eax),%eax
  800345:	8d 48 01             	lea    0x1(%eax),%ecx
  800348:	8b 55 0c             	mov    0xc(%ebp),%edx
  80034b:	89 0a                	mov    %ecx,(%edx)
  80034d:	8b 55 08             	mov    0x8(%ebp),%edx
  800350:	88 d1                	mov    %dl,%cl
  800352:	8b 55 0c             	mov    0xc(%ebp),%edx
  800355:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800359:	8b 45 0c             	mov    0xc(%ebp),%eax
  80035c:	8b 00                	mov    (%eax),%eax
  80035e:	3d ff 00 00 00       	cmp    $0xff,%eax
  800363:	75 30                	jne    800395 <putch+0x5c>
		sys_cputs(b->buf, b->idx, printProgName, curTextClr);
  800365:	8b 15 18 b1 81 00    	mov    0x81b118,%edx
  80036b:	a0 44 30 80 00       	mov    0x803044,%al
  800370:	0f b6 c0             	movzbl %al,%eax
  800373:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800376:	8b 09                	mov    (%ecx),%ecx
  800378:	89 cb                	mov    %ecx,%ebx
  80037a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80037d:	83 c1 08             	add    $0x8,%ecx
  800380:	52                   	push   %edx
  800381:	50                   	push   %eax
  800382:	53                   	push   %ebx
  800383:	51                   	push   %ecx
  800384:	e8 a0 0f 00 00       	call   801329 <sys_cputs>
  800389:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  80038c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80038f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800395:	8b 45 0c             	mov    0xc(%ebp),%eax
  800398:	8b 40 04             	mov    0x4(%eax),%eax
  80039b:	8d 50 01             	lea    0x1(%eax),%edx
  80039e:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003a1:	89 50 04             	mov    %edx,0x4(%eax)
}
  8003a4:	90                   	nop
  8003a5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8003a8:	c9                   	leave  
  8003a9:	c3                   	ret    

008003aa <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  8003aa:	55                   	push   %ebp
  8003ab:	89 e5                	mov    %esp,%ebp
  8003ad:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8003b3:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8003ba:	00 00 00 
	b.cnt = 0;
  8003bd:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8003c4:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  8003c7:	ff 75 0c             	pushl  0xc(%ebp)
  8003ca:	ff 75 08             	pushl  0x8(%ebp)
  8003cd:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8003d3:	50                   	push   %eax
  8003d4:	68 39 03 80 00       	push   $0x800339
  8003d9:	e8 5a 02 00 00       	call   800638 <vprintfmt>
  8003de:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName, curTextClr);
  8003e1:	8b 15 18 b1 81 00    	mov    0x81b118,%edx
  8003e7:	a0 44 30 80 00       	mov    0x803044,%al
  8003ec:	0f b6 c0             	movzbl %al,%eax
  8003ef:	8b 8d f0 fe ff ff    	mov    -0x110(%ebp),%ecx
  8003f5:	52                   	push   %edx
  8003f6:	50                   	push   %eax
  8003f7:	51                   	push   %ecx
  8003f8:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8003fe:	83 c0 08             	add    $0x8,%eax
  800401:	50                   	push   %eax
  800402:	e8 22 0f 00 00       	call   801329 <sys_cputs>
  800407:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  80040a:	c6 05 44 30 80 00 00 	movb   $0x0,0x803044
	return b.cnt;
  800411:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800417:	c9                   	leave  
  800418:	c3                   	ret    

00800419 <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  800419:	55                   	push   %ebp
  80041a:	89 e5                	mov    %esp,%ebp
  80041c:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  80041f:	c6 05 44 30 80 00 01 	movb   $0x1,0x803044
	va_start(ap, fmt);
  800426:	8d 45 0c             	lea    0xc(%ebp),%eax
  800429:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  80042c:	8b 45 08             	mov    0x8(%ebp),%eax
  80042f:	83 ec 08             	sub    $0x8,%esp
  800432:	ff 75 f4             	pushl  -0xc(%ebp)
  800435:	50                   	push   %eax
  800436:	e8 6f ff ff ff       	call   8003aa <vcprintf>
  80043b:	83 c4 10             	add    $0x10,%esp
  80043e:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800441:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800444:	c9                   	leave  
  800445:	c3                   	ret    

00800446 <cprintf_colored>:

// *************** This text coloring feature is implemented by *************
// ********** Abd-Alrahman Zedan From Team Frozen-Bytes - FCIS'24-25 ********
int cprintf_colored(int textClr, const char *fmt, ...) {
  800446:	55                   	push   %ebp
  800447:	89 e5                	mov    %esp,%ebp
  800449:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  80044c:	c6 05 44 30 80 00 01 	movb   $0x1,0x803044
	curTextClr = (textClr << 8) ; //set text color by the given value
  800453:	8b 45 08             	mov    0x8(%ebp),%eax
  800456:	c1 e0 08             	shl    $0x8,%eax
  800459:	a3 18 b1 81 00       	mov    %eax,0x81b118
	va_start(ap, fmt);
  80045e:	8d 45 0c             	lea    0xc(%ebp),%eax
  800461:	83 c0 04             	add    $0x4,%eax
  800464:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800467:	8b 45 0c             	mov    0xc(%ebp),%eax
  80046a:	83 ec 08             	sub    $0x8,%esp
  80046d:	ff 75 f4             	pushl  -0xc(%ebp)
  800470:	50                   	push   %eax
  800471:	e8 34 ff ff ff       	call   8003aa <vcprintf>
  800476:	83 c4 10             	add    $0x10,%esp
  800479:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);
	curTextClr = TEXT_DEFAULT_CLR; //restore default color
  80047c:	c7 05 18 b1 81 00 00 	movl   $0x700,0x81b118
  800483:	07 00 00 

	return cnt;
  800486:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800489:	c9                   	leave  
  80048a:	c3                   	ret    

0080048b <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  80048b:	55                   	push   %ebp
  80048c:	89 e5                	mov    %esp,%ebp
  80048e:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  800491:	e8 d7 0e 00 00       	call   80136d <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  800496:	8d 45 0c             	lea    0xc(%ebp),%eax
  800499:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  80049c:	8b 45 08             	mov    0x8(%ebp),%eax
  80049f:	83 ec 08             	sub    $0x8,%esp
  8004a2:	ff 75 f4             	pushl  -0xc(%ebp)
  8004a5:	50                   	push   %eax
  8004a6:	e8 ff fe ff ff       	call   8003aa <vcprintf>
  8004ab:	83 c4 10             	add    $0x10,%esp
  8004ae:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  8004b1:	e8 d1 0e 00 00       	call   801387 <sys_unlock_cons>
	return cnt;
  8004b6:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8004b9:	c9                   	leave  
  8004ba:	c3                   	ret    

008004bb <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8004bb:	55                   	push   %ebp
  8004bc:	89 e5                	mov    %esp,%ebp
  8004be:	53                   	push   %ebx
  8004bf:	83 ec 14             	sub    $0x14,%esp
  8004c2:	8b 45 10             	mov    0x10(%ebp),%eax
  8004c5:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8004c8:	8b 45 14             	mov    0x14(%ebp),%eax
  8004cb:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8004ce:	8b 45 18             	mov    0x18(%ebp),%eax
  8004d1:	ba 00 00 00 00       	mov    $0x0,%edx
  8004d6:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8004d9:	77 55                	ja     800530 <printnum+0x75>
  8004db:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8004de:	72 05                	jb     8004e5 <printnum+0x2a>
  8004e0:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8004e3:	77 4b                	ja     800530 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8004e5:	8b 45 1c             	mov    0x1c(%ebp),%eax
  8004e8:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8004eb:	8b 45 18             	mov    0x18(%ebp),%eax
  8004ee:	ba 00 00 00 00       	mov    $0x0,%edx
  8004f3:	52                   	push   %edx
  8004f4:	50                   	push   %eax
  8004f5:	ff 75 f4             	pushl  -0xc(%ebp)
  8004f8:	ff 75 f0             	pushl  -0x10(%ebp)
  8004fb:	e8 54 16 00 00       	call   801b54 <__udivdi3>
  800500:	83 c4 10             	add    $0x10,%esp
  800503:	83 ec 04             	sub    $0x4,%esp
  800506:	ff 75 20             	pushl  0x20(%ebp)
  800509:	53                   	push   %ebx
  80050a:	ff 75 18             	pushl  0x18(%ebp)
  80050d:	52                   	push   %edx
  80050e:	50                   	push   %eax
  80050f:	ff 75 0c             	pushl  0xc(%ebp)
  800512:	ff 75 08             	pushl  0x8(%ebp)
  800515:	e8 a1 ff ff ff       	call   8004bb <printnum>
  80051a:	83 c4 20             	add    $0x20,%esp
  80051d:	eb 1a                	jmp    800539 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  80051f:	83 ec 08             	sub    $0x8,%esp
  800522:	ff 75 0c             	pushl  0xc(%ebp)
  800525:	ff 75 20             	pushl  0x20(%ebp)
  800528:	8b 45 08             	mov    0x8(%ebp),%eax
  80052b:	ff d0                	call   *%eax
  80052d:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800530:	ff 4d 1c             	decl   0x1c(%ebp)
  800533:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800537:	7f e6                	jg     80051f <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800539:	8b 4d 18             	mov    0x18(%ebp),%ecx
  80053c:	bb 00 00 00 00       	mov    $0x0,%ebx
  800541:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800544:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800547:	53                   	push   %ebx
  800548:	51                   	push   %ecx
  800549:	52                   	push   %edx
  80054a:	50                   	push   %eax
  80054b:	e8 14 17 00 00       	call   801c64 <__umoddi3>
  800550:	83 c4 10             	add    $0x10,%esp
  800553:	05 74 22 80 00       	add    $0x802274,%eax
  800558:	8a 00                	mov    (%eax),%al
  80055a:	0f be c0             	movsbl %al,%eax
  80055d:	83 ec 08             	sub    $0x8,%esp
  800560:	ff 75 0c             	pushl  0xc(%ebp)
  800563:	50                   	push   %eax
  800564:	8b 45 08             	mov    0x8(%ebp),%eax
  800567:	ff d0                	call   *%eax
  800569:	83 c4 10             	add    $0x10,%esp
}
  80056c:	90                   	nop
  80056d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800570:	c9                   	leave  
  800571:	c3                   	ret    

00800572 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800572:	55                   	push   %ebp
  800573:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800575:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800579:	7e 1c                	jle    800597 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  80057b:	8b 45 08             	mov    0x8(%ebp),%eax
  80057e:	8b 00                	mov    (%eax),%eax
  800580:	8d 50 08             	lea    0x8(%eax),%edx
  800583:	8b 45 08             	mov    0x8(%ebp),%eax
  800586:	89 10                	mov    %edx,(%eax)
  800588:	8b 45 08             	mov    0x8(%ebp),%eax
  80058b:	8b 00                	mov    (%eax),%eax
  80058d:	83 e8 08             	sub    $0x8,%eax
  800590:	8b 50 04             	mov    0x4(%eax),%edx
  800593:	8b 00                	mov    (%eax),%eax
  800595:	eb 40                	jmp    8005d7 <getuint+0x65>
	else if (lflag)
  800597:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80059b:	74 1e                	je     8005bb <getuint+0x49>
		return va_arg(*ap, unsigned long);
  80059d:	8b 45 08             	mov    0x8(%ebp),%eax
  8005a0:	8b 00                	mov    (%eax),%eax
  8005a2:	8d 50 04             	lea    0x4(%eax),%edx
  8005a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8005a8:	89 10                	mov    %edx,(%eax)
  8005aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8005ad:	8b 00                	mov    (%eax),%eax
  8005af:	83 e8 04             	sub    $0x4,%eax
  8005b2:	8b 00                	mov    (%eax),%eax
  8005b4:	ba 00 00 00 00       	mov    $0x0,%edx
  8005b9:	eb 1c                	jmp    8005d7 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  8005bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8005be:	8b 00                	mov    (%eax),%eax
  8005c0:	8d 50 04             	lea    0x4(%eax),%edx
  8005c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8005c6:	89 10                	mov    %edx,(%eax)
  8005c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8005cb:	8b 00                	mov    (%eax),%eax
  8005cd:	83 e8 04             	sub    $0x4,%eax
  8005d0:	8b 00                	mov    (%eax),%eax
  8005d2:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8005d7:	5d                   	pop    %ebp
  8005d8:	c3                   	ret    

008005d9 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8005d9:	55                   	push   %ebp
  8005da:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8005dc:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8005e0:	7e 1c                	jle    8005fe <getint+0x25>
		return va_arg(*ap, long long);
  8005e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8005e5:	8b 00                	mov    (%eax),%eax
  8005e7:	8d 50 08             	lea    0x8(%eax),%edx
  8005ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8005ed:	89 10                	mov    %edx,(%eax)
  8005ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8005f2:	8b 00                	mov    (%eax),%eax
  8005f4:	83 e8 08             	sub    $0x8,%eax
  8005f7:	8b 50 04             	mov    0x4(%eax),%edx
  8005fa:	8b 00                	mov    (%eax),%eax
  8005fc:	eb 38                	jmp    800636 <getint+0x5d>
	else if (lflag)
  8005fe:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800602:	74 1a                	je     80061e <getint+0x45>
		return va_arg(*ap, long);
  800604:	8b 45 08             	mov    0x8(%ebp),%eax
  800607:	8b 00                	mov    (%eax),%eax
  800609:	8d 50 04             	lea    0x4(%eax),%edx
  80060c:	8b 45 08             	mov    0x8(%ebp),%eax
  80060f:	89 10                	mov    %edx,(%eax)
  800611:	8b 45 08             	mov    0x8(%ebp),%eax
  800614:	8b 00                	mov    (%eax),%eax
  800616:	83 e8 04             	sub    $0x4,%eax
  800619:	8b 00                	mov    (%eax),%eax
  80061b:	99                   	cltd   
  80061c:	eb 18                	jmp    800636 <getint+0x5d>
	else
		return va_arg(*ap, int);
  80061e:	8b 45 08             	mov    0x8(%ebp),%eax
  800621:	8b 00                	mov    (%eax),%eax
  800623:	8d 50 04             	lea    0x4(%eax),%edx
  800626:	8b 45 08             	mov    0x8(%ebp),%eax
  800629:	89 10                	mov    %edx,(%eax)
  80062b:	8b 45 08             	mov    0x8(%ebp),%eax
  80062e:	8b 00                	mov    (%eax),%eax
  800630:	83 e8 04             	sub    $0x4,%eax
  800633:	8b 00                	mov    (%eax),%eax
  800635:	99                   	cltd   
}
  800636:	5d                   	pop    %ebp
  800637:	c3                   	ret    

00800638 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800638:	55                   	push   %ebp
  800639:	89 e5                	mov    %esp,%ebp
  80063b:	56                   	push   %esi
  80063c:	53                   	push   %ebx
  80063d:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800640:	eb 17                	jmp    800659 <vprintfmt+0x21>
			if (ch == '\0')
  800642:	85 db                	test   %ebx,%ebx
  800644:	0f 84 c1 03 00 00    	je     800a0b <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  80064a:	83 ec 08             	sub    $0x8,%esp
  80064d:	ff 75 0c             	pushl  0xc(%ebp)
  800650:	53                   	push   %ebx
  800651:	8b 45 08             	mov    0x8(%ebp),%eax
  800654:	ff d0                	call   *%eax
  800656:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800659:	8b 45 10             	mov    0x10(%ebp),%eax
  80065c:	8d 50 01             	lea    0x1(%eax),%edx
  80065f:	89 55 10             	mov    %edx,0x10(%ebp)
  800662:	8a 00                	mov    (%eax),%al
  800664:	0f b6 d8             	movzbl %al,%ebx
  800667:	83 fb 25             	cmp    $0x25,%ebx
  80066a:	75 d6                	jne    800642 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  80066c:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800670:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800677:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  80067e:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800685:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80068c:	8b 45 10             	mov    0x10(%ebp),%eax
  80068f:	8d 50 01             	lea    0x1(%eax),%edx
  800692:	89 55 10             	mov    %edx,0x10(%ebp)
  800695:	8a 00                	mov    (%eax),%al
  800697:	0f b6 d8             	movzbl %al,%ebx
  80069a:	8d 43 dd             	lea    -0x23(%ebx),%eax
  80069d:	83 f8 5b             	cmp    $0x5b,%eax
  8006a0:	0f 87 3d 03 00 00    	ja     8009e3 <vprintfmt+0x3ab>
  8006a6:	8b 04 85 98 22 80 00 	mov    0x802298(,%eax,4),%eax
  8006ad:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  8006af:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  8006b3:	eb d7                	jmp    80068c <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8006b5:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  8006b9:	eb d1                	jmp    80068c <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8006bb:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  8006c2:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8006c5:	89 d0                	mov    %edx,%eax
  8006c7:	c1 e0 02             	shl    $0x2,%eax
  8006ca:	01 d0                	add    %edx,%eax
  8006cc:	01 c0                	add    %eax,%eax
  8006ce:	01 d8                	add    %ebx,%eax
  8006d0:	83 e8 30             	sub    $0x30,%eax
  8006d3:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  8006d6:	8b 45 10             	mov    0x10(%ebp),%eax
  8006d9:	8a 00                	mov    (%eax),%al
  8006db:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8006de:	83 fb 2f             	cmp    $0x2f,%ebx
  8006e1:	7e 3e                	jle    800721 <vprintfmt+0xe9>
  8006e3:	83 fb 39             	cmp    $0x39,%ebx
  8006e6:	7f 39                	jg     800721 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8006e8:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8006eb:	eb d5                	jmp    8006c2 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8006ed:	8b 45 14             	mov    0x14(%ebp),%eax
  8006f0:	83 c0 04             	add    $0x4,%eax
  8006f3:	89 45 14             	mov    %eax,0x14(%ebp)
  8006f6:	8b 45 14             	mov    0x14(%ebp),%eax
  8006f9:	83 e8 04             	sub    $0x4,%eax
  8006fc:	8b 00                	mov    (%eax),%eax
  8006fe:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800701:	eb 1f                	jmp    800722 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800703:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800707:	79 83                	jns    80068c <vprintfmt+0x54>
				width = 0;
  800709:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800710:	e9 77 ff ff ff       	jmp    80068c <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800715:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  80071c:	e9 6b ff ff ff       	jmp    80068c <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800721:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800722:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800726:	0f 89 60 ff ff ff    	jns    80068c <vprintfmt+0x54>
				width = precision, precision = -1;
  80072c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80072f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800732:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800739:	e9 4e ff ff ff       	jmp    80068c <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  80073e:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800741:	e9 46 ff ff ff       	jmp    80068c <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800746:	8b 45 14             	mov    0x14(%ebp),%eax
  800749:	83 c0 04             	add    $0x4,%eax
  80074c:	89 45 14             	mov    %eax,0x14(%ebp)
  80074f:	8b 45 14             	mov    0x14(%ebp),%eax
  800752:	83 e8 04             	sub    $0x4,%eax
  800755:	8b 00                	mov    (%eax),%eax
  800757:	83 ec 08             	sub    $0x8,%esp
  80075a:	ff 75 0c             	pushl  0xc(%ebp)
  80075d:	50                   	push   %eax
  80075e:	8b 45 08             	mov    0x8(%ebp),%eax
  800761:	ff d0                	call   *%eax
  800763:	83 c4 10             	add    $0x10,%esp
			break;
  800766:	e9 9b 02 00 00       	jmp    800a06 <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  80076b:	8b 45 14             	mov    0x14(%ebp),%eax
  80076e:	83 c0 04             	add    $0x4,%eax
  800771:	89 45 14             	mov    %eax,0x14(%ebp)
  800774:	8b 45 14             	mov    0x14(%ebp),%eax
  800777:	83 e8 04             	sub    $0x4,%eax
  80077a:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  80077c:	85 db                	test   %ebx,%ebx
  80077e:	79 02                	jns    800782 <vprintfmt+0x14a>
				err = -err;
  800780:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800782:	83 fb 64             	cmp    $0x64,%ebx
  800785:	7f 0b                	jg     800792 <vprintfmt+0x15a>
  800787:	8b 34 9d e0 20 80 00 	mov    0x8020e0(,%ebx,4),%esi
  80078e:	85 f6                	test   %esi,%esi
  800790:	75 19                	jne    8007ab <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800792:	53                   	push   %ebx
  800793:	68 85 22 80 00       	push   $0x802285
  800798:	ff 75 0c             	pushl  0xc(%ebp)
  80079b:	ff 75 08             	pushl  0x8(%ebp)
  80079e:	e8 70 02 00 00       	call   800a13 <printfmt>
  8007a3:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  8007a6:	e9 5b 02 00 00       	jmp    800a06 <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  8007ab:	56                   	push   %esi
  8007ac:	68 8e 22 80 00       	push   $0x80228e
  8007b1:	ff 75 0c             	pushl  0xc(%ebp)
  8007b4:	ff 75 08             	pushl  0x8(%ebp)
  8007b7:	e8 57 02 00 00       	call   800a13 <printfmt>
  8007bc:	83 c4 10             	add    $0x10,%esp
			break;
  8007bf:	e9 42 02 00 00       	jmp    800a06 <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  8007c4:	8b 45 14             	mov    0x14(%ebp),%eax
  8007c7:	83 c0 04             	add    $0x4,%eax
  8007ca:	89 45 14             	mov    %eax,0x14(%ebp)
  8007cd:	8b 45 14             	mov    0x14(%ebp),%eax
  8007d0:	83 e8 04             	sub    $0x4,%eax
  8007d3:	8b 30                	mov    (%eax),%esi
  8007d5:	85 f6                	test   %esi,%esi
  8007d7:	75 05                	jne    8007de <vprintfmt+0x1a6>
				p = "(null)";
  8007d9:	be 91 22 80 00       	mov    $0x802291,%esi
			if (width > 0 && padc != '-')
  8007de:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8007e2:	7e 6d                	jle    800851 <vprintfmt+0x219>
  8007e4:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  8007e8:	74 67                	je     800851 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  8007ea:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8007ed:	83 ec 08             	sub    $0x8,%esp
  8007f0:	50                   	push   %eax
  8007f1:	56                   	push   %esi
  8007f2:	e8 1e 03 00 00       	call   800b15 <strnlen>
  8007f7:	83 c4 10             	add    $0x10,%esp
  8007fa:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  8007fd:	eb 16                	jmp    800815 <vprintfmt+0x1dd>
					putch(padc, putdat);
  8007ff:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800803:	83 ec 08             	sub    $0x8,%esp
  800806:	ff 75 0c             	pushl  0xc(%ebp)
  800809:	50                   	push   %eax
  80080a:	8b 45 08             	mov    0x8(%ebp),%eax
  80080d:	ff d0                	call   *%eax
  80080f:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800812:	ff 4d e4             	decl   -0x1c(%ebp)
  800815:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800819:	7f e4                	jg     8007ff <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80081b:	eb 34                	jmp    800851 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  80081d:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800821:	74 1c                	je     80083f <vprintfmt+0x207>
  800823:	83 fb 1f             	cmp    $0x1f,%ebx
  800826:	7e 05                	jle    80082d <vprintfmt+0x1f5>
  800828:	83 fb 7e             	cmp    $0x7e,%ebx
  80082b:	7e 12                	jle    80083f <vprintfmt+0x207>
					putch('?', putdat);
  80082d:	83 ec 08             	sub    $0x8,%esp
  800830:	ff 75 0c             	pushl  0xc(%ebp)
  800833:	6a 3f                	push   $0x3f
  800835:	8b 45 08             	mov    0x8(%ebp),%eax
  800838:	ff d0                	call   *%eax
  80083a:	83 c4 10             	add    $0x10,%esp
  80083d:	eb 0f                	jmp    80084e <vprintfmt+0x216>
				else
					putch(ch, putdat);
  80083f:	83 ec 08             	sub    $0x8,%esp
  800842:	ff 75 0c             	pushl  0xc(%ebp)
  800845:	53                   	push   %ebx
  800846:	8b 45 08             	mov    0x8(%ebp),%eax
  800849:	ff d0                	call   *%eax
  80084b:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80084e:	ff 4d e4             	decl   -0x1c(%ebp)
  800851:	89 f0                	mov    %esi,%eax
  800853:	8d 70 01             	lea    0x1(%eax),%esi
  800856:	8a 00                	mov    (%eax),%al
  800858:	0f be d8             	movsbl %al,%ebx
  80085b:	85 db                	test   %ebx,%ebx
  80085d:	74 24                	je     800883 <vprintfmt+0x24b>
  80085f:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800863:	78 b8                	js     80081d <vprintfmt+0x1e5>
  800865:	ff 4d e0             	decl   -0x20(%ebp)
  800868:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80086c:	79 af                	jns    80081d <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  80086e:	eb 13                	jmp    800883 <vprintfmt+0x24b>
				putch(' ', putdat);
  800870:	83 ec 08             	sub    $0x8,%esp
  800873:	ff 75 0c             	pushl  0xc(%ebp)
  800876:	6a 20                	push   $0x20
  800878:	8b 45 08             	mov    0x8(%ebp),%eax
  80087b:	ff d0                	call   *%eax
  80087d:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800880:	ff 4d e4             	decl   -0x1c(%ebp)
  800883:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800887:	7f e7                	jg     800870 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800889:	e9 78 01 00 00       	jmp    800a06 <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  80088e:	83 ec 08             	sub    $0x8,%esp
  800891:	ff 75 e8             	pushl  -0x18(%ebp)
  800894:	8d 45 14             	lea    0x14(%ebp),%eax
  800897:	50                   	push   %eax
  800898:	e8 3c fd ff ff       	call   8005d9 <getint>
  80089d:	83 c4 10             	add    $0x10,%esp
  8008a0:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8008a3:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  8008a6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8008a9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8008ac:	85 d2                	test   %edx,%edx
  8008ae:	79 23                	jns    8008d3 <vprintfmt+0x29b>
				putch('-', putdat);
  8008b0:	83 ec 08             	sub    $0x8,%esp
  8008b3:	ff 75 0c             	pushl  0xc(%ebp)
  8008b6:	6a 2d                	push   $0x2d
  8008b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8008bb:	ff d0                	call   *%eax
  8008bd:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  8008c0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8008c3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8008c6:	f7 d8                	neg    %eax
  8008c8:	83 d2 00             	adc    $0x0,%edx
  8008cb:	f7 da                	neg    %edx
  8008cd:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8008d0:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  8008d3:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8008da:	e9 bc 00 00 00       	jmp    80099b <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  8008df:	83 ec 08             	sub    $0x8,%esp
  8008e2:	ff 75 e8             	pushl  -0x18(%ebp)
  8008e5:	8d 45 14             	lea    0x14(%ebp),%eax
  8008e8:	50                   	push   %eax
  8008e9:	e8 84 fc ff ff       	call   800572 <getuint>
  8008ee:	83 c4 10             	add    $0x10,%esp
  8008f1:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8008f4:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  8008f7:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8008fe:	e9 98 00 00 00       	jmp    80099b <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800903:	83 ec 08             	sub    $0x8,%esp
  800906:	ff 75 0c             	pushl  0xc(%ebp)
  800909:	6a 58                	push   $0x58
  80090b:	8b 45 08             	mov    0x8(%ebp),%eax
  80090e:	ff d0                	call   *%eax
  800910:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800913:	83 ec 08             	sub    $0x8,%esp
  800916:	ff 75 0c             	pushl  0xc(%ebp)
  800919:	6a 58                	push   $0x58
  80091b:	8b 45 08             	mov    0x8(%ebp),%eax
  80091e:	ff d0                	call   *%eax
  800920:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800923:	83 ec 08             	sub    $0x8,%esp
  800926:	ff 75 0c             	pushl  0xc(%ebp)
  800929:	6a 58                	push   $0x58
  80092b:	8b 45 08             	mov    0x8(%ebp),%eax
  80092e:	ff d0                	call   *%eax
  800930:	83 c4 10             	add    $0x10,%esp
			break;
  800933:	e9 ce 00 00 00       	jmp    800a06 <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  800938:	83 ec 08             	sub    $0x8,%esp
  80093b:	ff 75 0c             	pushl  0xc(%ebp)
  80093e:	6a 30                	push   $0x30
  800940:	8b 45 08             	mov    0x8(%ebp),%eax
  800943:	ff d0                	call   *%eax
  800945:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800948:	83 ec 08             	sub    $0x8,%esp
  80094b:	ff 75 0c             	pushl  0xc(%ebp)
  80094e:	6a 78                	push   $0x78
  800950:	8b 45 08             	mov    0x8(%ebp),%eax
  800953:	ff d0                	call   *%eax
  800955:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800958:	8b 45 14             	mov    0x14(%ebp),%eax
  80095b:	83 c0 04             	add    $0x4,%eax
  80095e:	89 45 14             	mov    %eax,0x14(%ebp)
  800961:	8b 45 14             	mov    0x14(%ebp),%eax
  800964:	83 e8 04             	sub    $0x4,%eax
  800967:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800969:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80096c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800973:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  80097a:	eb 1f                	jmp    80099b <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  80097c:	83 ec 08             	sub    $0x8,%esp
  80097f:	ff 75 e8             	pushl  -0x18(%ebp)
  800982:	8d 45 14             	lea    0x14(%ebp),%eax
  800985:	50                   	push   %eax
  800986:	e8 e7 fb ff ff       	call   800572 <getuint>
  80098b:	83 c4 10             	add    $0x10,%esp
  80098e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800991:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800994:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  80099b:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  80099f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8009a2:	83 ec 04             	sub    $0x4,%esp
  8009a5:	52                   	push   %edx
  8009a6:	ff 75 e4             	pushl  -0x1c(%ebp)
  8009a9:	50                   	push   %eax
  8009aa:	ff 75 f4             	pushl  -0xc(%ebp)
  8009ad:	ff 75 f0             	pushl  -0x10(%ebp)
  8009b0:	ff 75 0c             	pushl  0xc(%ebp)
  8009b3:	ff 75 08             	pushl  0x8(%ebp)
  8009b6:	e8 00 fb ff ff       	call   8004bb <printnum>
  8009bb:	83 c4 20             	add    $0x20,%esp
			break;
  8009be:	eb 46                	jmp    800a06 <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  8009c0:	83 ec 08             	sub    $0x8,%esp
  8009c3:	ff 75 0c             	pushl  0xc(%ebp)
  8009c6:	53                   	push   %ebx
  8009c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8009ca:	ff d0                	call   *%eax
  8009cc:	83 c4 10             	add    $0x10,%esp
			break;
  8009cf:	eb 35                	jmp    800a06 <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  8009d1:	c6 05 44 30 80 00 00 	movb   $0x0,0x803044
			break;
  8009d8:	eb 2c                	jmp    800a06 <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  8009da:	c6 05 44 30 80 00 01 	movb   $0x1,0x803044
			break;
  8009e1:	eb 23                	jmp    800a06 <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  8009e3:	83 ec 08             	sub    $0x8,%esp
  8009e6:	ff 75 0c             	pushl  0xc(%ebp)
  8009e9:	6a 25                	push   $0x25
  8009eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8009ee:	ff d0                	call   *%eax
  8009f0:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  8009f3:	ff 4d 10             	decl   0x10(%ebp)
  8009f6:	eb 03                	jmp    8009fb <vprintfmt+0x3c3>
  8009f8:	ff 4d 10             	decl   0x10(%ebp)
  8009fb:	8b 45 10             	mov    0x10(%ebp),%eax
  8009fe:	48                   	dec    %eax
  8009ff:	8a 00                	mov    (%eax),%al
  800a01:	3c 25                	cmp    $0x25,%al
  800a03:	75 f3                	jne    8009f8 <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  800a05:	90                   	nop
		}
	}
  800a06:	e9 35 fc ff ff       	jmp    800640 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800a0b:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800a0c:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800a0f:	5b                   	pop    %ebx
  800a10:	5e                   	pop    %esi
  800a11:	5d                   	pop    %ebp
  800a12:	c3                   	ret    

00800a13 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800a13:	55                   	push   %ebp
  800a14:	89 e5                	mov    %esp,%ebp
  800a16:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800a19:	8d 45 10             	lea    0x10(%ebp),%eax
  800a1c:	83 c0 04             	add    $0x4,%eax
  800a1f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800a22:	8b 45 10             	mov    0x10(%ebp),%eax
  800a25:	ff 75 f4             	pushl  -0xc(%ebp)
  800a28:	50                   	push   %eax
  800a29:	ff 75 0c             	pushl  0xc(%ebp)
  800a2c:	ff 75 08             	pushl  0x8(%ebp)
  800a2f:	e8 04 fc ff ff       	call   800638 <vprintfmt>
  800a34:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800a37:	90                   	nop
  800a38:	c9                   	leave  
  800a39:	c3                   	ret    

00800a3a <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800a3a:	55                   	push   %ebp
  800a3b:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800a3d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a40:	8b 40 08             	mov    0x8(%eax),%eax
  800a43:	8d 50 01             	lea    0x1(%eax),%edx
  800a46:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a49:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800a4c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a4f:	8b 10                	mov    (%eax),%edx
  800a51:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a54:	8b 40 04             	mov    0x4(%eax),%eax
  800a57:	39 c2                	cmp    %eax,%edx
  800a59:	73 12                	jae    800a6d <sprintputch+0x33>
		*b->buf++ = ch;
  800a5b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a5e:	8b 00                	mov    (%eax),%eax
  800a60:	8d 48 01             	lea    0x1(%eax),%ecx
  800a63:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a66:	89 0a                	mov    %ecx,(%edx)
  800a68:	8b 55 08             	mov    0x8(%ebp),%edx
  800a6b:	88 10                	mov    %dl,(%eax)
}
  800a6d:	90                   	nop
  800a6e:	5d                   	pop    %ebp
  800a6f:	c3                   	ret    

00800a70 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800a70:	55                   	push   %ebp
  800a71:	89 e5                	mov    %esp,%ebp
  800a73:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800a76:	8b 45 08             	mov    0x8(%ebp),%eax
  800a79:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800a7c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a7f:	8d 50 ff             	lea    -0x1(%eax),%edx
  800a82:	8b 45 08             	mov    0x8(%ebp),%eax
  800a85:	01 d0                	add    %edx,%eax
  800a87:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a8a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800a91:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800a95:	74 06                	je     800a9d <vsnprintf+0x2d>
  800a97:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800a9b:	7f 07                	jg     800aa4 <vsnprintf+0x34>
		return -E_INVAL;
  800a9d:	b8 03 00 00 00       	mov    $0x3,%eax
  800aa2:	eb 20                	jmp    800ac4 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800aa4:	ff 75 14             	pushl  0x14(%ebp)
  800aa7:	ff 75 10             	pushl  0x10(%ebp)
  800aaa:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800aad:	50                   	push   %eax
  800aae:	68 3a 0a 80 00       	push   $0x800a3a
  800ab3:	e8 80 fb ff ff       	call   800638 <vprintfmt>
  800ab8:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800abb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800abe:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800ac1:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800ac4:	c9                   	leave  
  800ac5:	c3                   	ret    

00800ac6 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800ac6:	55                   	push   %ebp
  800ac7:	89 e5                	mov    %esp,%ebp
  800ac9:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800acc:	8d 45 10             	lea    0x10(%ebp),%eax
  800acf:	83 c0 04             	add    $0x4,%eax
  800ad2:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800ad5:	8b 45 10             	mov    0x10(%ebp),%eax
  800ad8:	ff 75 f4             	pushl  -0xc(%ebp)
  800adb:	50                   	push   %eax
  800adc:	ff 75 0c             	pushl  0xc(%ebp)
  800adf:	ff 75 08             	pushl  0x8(%ebp)
  800ae2:	e8 89 ff ff ff       	call   800a70 <vsnprintf>
  800ae7:	83 c4 10             	add    $0x10,%esp
  800aea:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800aed:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800af0:	c9                   	leave  
  800af1:	c3                   	ret    

00800af2 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800af2:	55                   	push   %ebp
  800af3:	89 e5                	mov    %esp,%ebp
  800af5:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800af8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800aff:	eb 06                	jmp    800b07 <strlen+0x15>
		n++;
  800b01:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800b04:	ff 45 08             	incl   0x8(%ebp)
  800b07:	8b 45 08             	mov    0x8(%ebp),%eax
  800b0a:	8a 00                	mov    (%eax),%al
  800b0c:	84 c0                	test   %al,%al
  800b0e:	75 f1                	jne    800b01 <strlen+0xf>
		n++;
	return n;
  800b10:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800b13:	c9                   	leave  
  800b14:	c3                   	ret    

00800b15 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800b15:	55                   	push   %ebp
  800b16:	89 e5                	mov    %esp,%ebp
  800b18:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800b1b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800b22:	eb 09                	jmp    800b2d <strnlen+0x18>
		n++;
  800b24:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800b27:	ff 45 08             	incl   0x8(%ebp)
  800b2a:	ff 4d 0c             	decl   0xc(%ebp)
  800b2d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800b31:	74 09                	je     800b3c <strnlen+0x27>
  800b33:	8b 45 08             	mov    0x8(%ebp),%eax
  800b36:	8a 00                	mov    (%eax),%al
  800b38:	84 c0                	test   %al,%al
  800b3a:	75 e8                	jne    800b24 <strnlen+0xf>
		n++;
	return n;
  800b3c:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800b3f:	c9                   	leave  
  800b40:	c3                   	ret    

00800b41 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800b41:	55                   	push   %ebp
  800b42:	89 e5                	mov    %esp,%ebp
  800b44:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800b47:	8b 45 08             	mov    0x8(%ebp),%eax
  800b4a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800b4d:	90                   	nop
  800b4e:	8b 45 08             	mov    0x8(%ebp),%eax
  800b51:	8d 50 01             	lea    0x1(%eax),%edx
  800b54:	89 55 08             	mov    %edx,0x8(%ebp)
  800b57:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b5a:	8d 4a 01             	lea    0x1(%edx),%ecx
  800b5d:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800b60:	8a 12                	mov    (%edx),%dl
  800b62:	88 10                	mov    %dl,(%eax)
  800b64:	8a 00                	mov    (%eax),%al
  800b66:	84 c0                	test   %al,%al
  800b68:	75 e4                	jne    800b4e <strcpy+0xd>
		/* do nothing */;
	return ret;
  800b6a:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800b6d:	c9                   	leave  
  800b6e:	c3                   	ret    

00800b6f <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800b6f:	55                   	push   %ebp
  800b70:	89 e5                	mov    %esp,%ebp
  800b72:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800b75:	8b 45 08             	mov    0x8(%ebp),%eax
  800b78:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800b7b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800b82:	eb 1f                	jmp    800ba3 <strncpy+0x34>
		*dst++ = *src;
  800b84:	8b 45 08             	mov    0x8(%ebp),%eax
  800b87:	8d 50 01             	lea    0x1(%eax),%edx
  800b8a:	89 55 08             	mov    %edx,0x8(%ebp)
  800b8d:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b90:	8a 12                	mov    (%edx),%dl
  800b92:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800b94:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b97:	8a 00                	mov    (%eax),%al
  800b99:	84 c0                	test   %al,%al
  800b9b:	74 03                	je     800ba0 <strncpy+0x31>
			src++;
  800b9d:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800ba0:	ff 45 fc             	incl   -0x4(%ebp)
  800ba3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ba6:	3b 45 10             	cmp    0x10(%ebp),%eax
  800ba9:	72 d9                	jb     800b84 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800bab:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800bae:	c9                   	leave  
  800baf:	c3                   	ret    

00800bb0 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800bb0:	55                   	push   %ebp
  800bb1:	89 e5                	mov    %esp,%ebp
  800bb3:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800bb6:	8b 45 08             	mov    0x8(%ebp),%eax
  800bb9:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800bbc:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800bc0:	74 30                	je     800bf2 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800bc2:	eb 16                	jmp    800bda <strlcpy+0x2a>
			*dst++ = *src++;
  800bc4:	8b 45 08             	mov    0x8(%ebp),%eax
  800bc7:	8d 50 01             	lea    0x1(%eax),%edx
  800bca:	89 55 08             	mov    %edx,0x8(%ebp)
  800bcd:	8b 55 0c             	mov    0xc(%ebp),%edx
  800bd0:	8d 4a 01             	lea    0x1(%edx),%ecx
  800bd3:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800bd6:	8a 12                	mov    (%edx),%dl
  800bd8:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800bda:	ff 4d 10             	decl   0x10(%ebp)
  800bdd:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800be1:	74 09                	je     800bec <strlcpy+0x3c>
  800be3:	8b 45 0c             	mov    0xc(%ebp),%eax
  800be6:	8a 00                	mov    (%eax),%al
  800be8:	84 c0                	test   %al,%al
  800bea:	75 d8                	jne    800bc4 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800bec:	8b 45 08             	mov    0x8(%ebp),%eax
  800bef:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800bf2:	8b 55 08             	mov    0x8(%ebp),%edx
  800bf5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800bf8:	29 c2                	sub    %eax,%edx
  800bfa:	89 d0                	mov    %edx,%eax
}
  800bfc:	c9                   	leave  
  800bfd:	c3                   	ret    

00800bfe <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800bfe:	55                   	push   %ebp
  800bff:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800c01:	eb 06                	jmp    800c09 <strcmp+0xb>
		p++, q++;
  800c03:	ff 45 08             	incl   0x8(%ebp)
  800c06:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800c09:	8b 45 08             	mov    0x8(%ebp),%eax
  800c0c:	8a 00                	mov    (%eax),%al
  800c0e:	84 c0                	test   %al,%al
  800c10:	74 0e                	je     800c20 <strcmp+0x22>
  800c12:	8b 45 08             	mov    0x8(%ebp),%eax
  800c15:	8a 10                	mov    (%eax),%dl
  800c17:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c1a:	8a 00                	mov    (%eax),%al
  800c1c:	38 c2                	cmp    %al,%dl
  800c1e:	74 e3                	je     800c03 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800c20:	8b 45 08             	mov    0x8(%ebp),%eax
  800c23:	8a 00                	mov    (%eax),%al
  800c25:	0f b6 d0             	movzbl %al,%edx
  800c28:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c2b:	8a 00                	mov    (%eax),%al
  800c2d:	0f b6 c0             	movzbl %al,%eax
  800c30:	29 c2                	sub    %eax,%edx
  800c32:	89 d0                	mov    %edx,%eax
}
  800c34:	5d                   	pop    %ebp
  800c35:	c3                   	ret    

00800c36 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800c36:	55                   	push   %ebp
  800c37:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800c39:	eb 09                	jmp    800c44 <strncmp+0xe>
		n--, p++, q++;
  800c3b:	ff 4d 10             	decl   0x10(%ebp)
  800c3e:	ff 45 08             	incl   0x8(%ebp)
  800c41:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800c44:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800c48:	74 17                	je     800c61 <strncmp+0x2b>
  800c4a:	8b 45 08             	mov    0x8(%ebp),%eax
  800c4d:	8a 00                	mov    (%eax),%al
  800c4f:	84 c0                	test   %al,%al
  800c51:	74 0e                	je     800c61 <strncmp+0x2b>
  800c53:	8b 45 08             	mov    0x8(%ebp),%eax
  800c56:	8a 10                	mov    (%eax),%dl
  800c58:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c5b:	8a 00                	mov    (%eax),%al
  800c5d:	38 c2                	cmp    %al,%dl
  800c5f:	74 da                	je     800c3b <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800c61:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800c65:	75 07                	jne    800c6e <strncmp+0x38>
		return 0;
  800c67:	b8 00 00 00 00       	mov    $0x0,%eax
  800c6c:	eb 14                	jmp    800c82 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800c6e:	8b 45 08             	mov    0x8(%ebp),%eax
  800c71:	8a 00                	mov    (%eax),%al
  800c73:	0f b6 d0             	movzbl %al,%edx
  800c76:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c79:	8a 00                	mov    (%eax),%al
  800c7b:	0f b6 c0             	movzbl %al,%eax
  800c7e:	29 c2                	sub    %eax,%edx
  800c80:	89 d0                	mov    %edx,%eax
}
  800c82:	5d                   	pop    %ebp
  800c83:	c3                   	ret    

00800c84 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800c84:	55                   	push   %ebp
  800c85:	89 e5                	mov    %esp,%ebp
  800c87:	83 ec 04             	sub    $0x4,%esp
  800c8a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c8d:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800c90:	eb 12                	jmp    800ca4 <strchr+0x20>
		if (*s == c)
  800c92:	8b 45 08             	mov    0x8(%ebp),%eax
  800c95:	8a 00                	mov    (%eax),%al
  800c97:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800c9a:	75 05                	jne    800ca1 <strchr+0x1d>
			return (char *) s;
  800c9c:	8b 45 08             	mov    0x8(%ebp),%eax
  800c9f:	eb 11                	jmp    800cb2 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800ca1:	ff 45 08             	incl   0x8(%ebp)
  800ca4:	8b 45 08             	mov    0x8(%ebp),%eax
  800ca7:	8a 00                	mov    (%eax),%al
  800ca9:	84 c0                	test   %al,%al
  800cab:	75 e5                	jne    800c92 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800cad:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800cb2:	c9                   	leave  
  800cb3:	c3                   	ret    

00800cb4 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800cb4:	55                   	push   %ebp
  800cb5:	89 e5                	mov    %esp,%ebp
  800cb7:	83 ec 04             	sub    $0x4,%esp
  800cba:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cbd:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800cc0:	eb 0d                	jmp    800ccf <strfind+0x1b>
		if (*s == c)
  800cc2:	8b 45 08             	mov    0x8(%ebp),%eax
  800cc5:	8a 00                	mov    (%eax),%al
  800cc7:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800cca:	74 0e                	je     800cda <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800ccc:	ff 45 08             	incl   0x8(%ebp)
  800ccf:	8b 45 08             	mov    0x8(%ebp),%eax
  800cd2:	8a 00                	mov    (%eax),%al
  800cd4:	84 c0                	test   %al,%al
  800cd6:	75 ea                	jne    800cc2 <strfind+0xe>
  800cd8:	eb 01                	jmp    800cdb <strfind+0x27>
		if (*s == c)
			break;
  800cda:	90                   	nop
	return (char *) s;
  800cdb:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800cde:	c9                   	leave  
  800cdf:	c3                   	ret    

00800ce0 <memset>:

// *************** The faster implementation of memset & memcpy is implemented by *************
// ****************** Team80 (Yahia Khaled, Malek Ahmed et al) - FCIS'24-25 *******************
void *
memset(void *v, int c, uint32 n)
{
  800ce0:	55                   	push   %ebp
  800ce1:	89 e5                	mov    %esp,%ebp
  800ce3:	83 ec 10             	sub    $0x10,%esp
//	m = n;
//	while (--m >= 0)
//		*p++ = c;

	/*Faster Implementation*/
	uint64* p64 = (uint64*)v;
  800ce6:	8b 45 08             	mov    0x8(%ebp),%eax
  800ce9:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if(n >= 8){
  800cec:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800cf0:	76 63                	jbe    800d55 <memset+0x75>
		uint64 data_block = c;
  800cf2:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cf5:	99                   	cltd   
  800cf6:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800cf9:	89 55 f4             	mov    %edx,-0xc(%ebp)
		data_block |= data_block << 8;
  800cfc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800cff:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800d02:	0f a4 c2 08          	shld   $0x8,%eax,%edx
  800d06:	c1 e0 08             	shl    $0x8,%eax
  800d09:	09 45 f0             	or     %eax,-0x10(%ebp)
  800d0c:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 16;
  800d0f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800d12:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800d15:	0f a4 c2 10          	shld   $0x10,%eax,%edx
  800d19:	c1 e0 10             	shl    $0x10,%eax
  800d1c:	09 45 f0             	or     %eax,-0x10(%ebp)
  800d1f:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 32;
  800d22:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800d25:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800d28:	89 c2                	mov    %eax,%edx
  800d2a:	b8 00 00 00 00       	mov    $0x0,%eax
  800d2f:	09 45 f0             	or     %eax,-0x10(%ebp)
  800d32:	09 55 f4             	or     %edx,-0xc(%ebp)

		while(n >= 8)
  800d35:	eb 18                	jmp    800d4f <memset+0x6f>
			*p64++ = data_block, n -= 8;
  800d37:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  800d3a:	8d 41 08             	lea    0x8(%ecx),%eax
  800d3d:	89 45 fc             	mov    %eax,-0x4(%ebp)
  800d40:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800d43:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800d46:	89 01                	mov    %eax,(%ecx)
  800d48:	89 51 04             	mov    %edx,0x4(%ecx)
  800d4b:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
		uint64 data_block = c;
		data_block |= data_block << 8;
		data_block |= data_block << 16;
		data_block |= data_block << 32;

		while(n >= 8)
  800d4f:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800d53:	77 e2                	ja     800d37 <memset+0x57>
			*p64++ = data_block, n -= 8;
	}

	if(n){
  800d55:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d59:	74 23                	je     800d7e <memset+0x9e>
		uint8* p8 = (uint8*)p64;
  800d5b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d5e:	89 45 f8             	mov    %eax,-0x8(%ebp)
		while (n-- > 0)
  800d61:	eb 0e                	jmp    800d71 <memset+0x91>
			*p8++ = (uint8)c;
  800d63:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800d66:	8d 50 01             	lea    0x1(%eax),%edx
  800d69:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800d6c:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d6f:	88 10                	mov    %dl,(%eax)
			*p64++ = data_block, n -= 8;
	}

	if(n){
		uint8* p8 = (uint8*)p64;
		while (n-- > 0)
  800d71:	8b 45 10             	mov    0x10(%ebp),%eax
  800d74:	8d 50 ff             	lea    -0x1(%eax),%edx
  800d77:	89 55 10             	mov    %edx,0x10(%ebp)
  800d7a:	85 c0                	test   %eax,%eax
  800d7c:	75 e5                	jne    800d63 <memset+0x83>
			*p8++ = (uint8)c;
	}

	return v;
  800d7e:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800d81:	c9                   	leave  
  800d82:	c3                   	ret    

00800d83 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800d83:	55                   	push   %ebp
  800d84:	89 e5                	mov    %esp,%ebp
  800d86:	83 ec 10             	sub    $0x10,%esp
	//	s = src;
	//	d = dst;
	//	while (n-- > 0)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
  800d89:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d8c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	uint64* d64 = (uint64*)dst;
  800d8f:	8b 45 08             	mov    0x8(%ebp),%eax
  800d92:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if(n >= 8){
  800d95:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800d99:	76 24                	jbe    800dbf <memcpy+0x3c>
		while(n >= 8){
  800d9b:	eb 1c                	jmp    800db9 <memcpy+0x36>
			*d64 = *s64;
  800d9d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800da0:	8b 50 04             	mov    0x4(%eax),%edx
  800da3:	8b 00                	mov    (%eax),%eax
  800da5:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  800da8:	89 01                	mov    %eax,(%ecx)
  800daa:	89 51 04             	mov    %edx,0x4(%ecx)
			n -= 8;
  800dad:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
			++s64;
  800db1:	83 45 fc 08          	addl   $0x8,-0x4(%ebp)
			++d64;
  800db5:	83 45 f8 08          	addl   $0x8,-0x8(%ebp)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
	uint64* d64 = (uint64*)dst;
	if(n >= 8){
		while(n >= 8){
  800db9:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800dbd:	77 de                	ja     800d9d <memcpy+0x1a>
			++s64;
			++d64;
		}
	}

	if(n){
  800dbf:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800dc3:	74 31                	je     800df6 <memcpy+0x73>
		uint8* s8 = (uint8*)s64;
  800dc5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800dc8:	89 45 f4             	mov    %eax,-0xc(%ebp)
		uint8* d8 = (uint8*)d64;
  800dcb:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800dce:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (n-- > 0)
  800dd1:	eb 16                	jmp    800de9 <memcpy+0x66>
			*d8++ = *s8++;
  800dd3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800dd6:	8d 50 01             	lea    0x1(%eax),%edx
  800dd9:	89 55 f0             	mov    %edx,-0x10(%ebp)
  800ddc:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800ddf:	8d 4a 01             	lea    0x1(%edx),%ecx
  800de2:	89 4d f4             	mov    %ecx,-0xc(%ebp)
  800de5:	8a 12                	mov    (%edx),%dl
  800de7:	88 10                	mov    %dl,(%eax)
	}

	if(n){
		uint8* s8 = (uint8*)s64;
		uint8* d8 = (uint8*)d64;
		while (n-- > 0)
  800de9:	8b 45 10             	mov    0x10(%ebp),%eax
  800dec:	8d 50 ff             	lea    -0x1(%eax),%edx
  800def:	89 55 10             	mov    %edx,0x10(%ebp)
  800df2:	85 c0                	test   %eax,%eax
  800df4:	75 dd                	jne    800dd3 <memcpy+0x50>
			*d8++ = *s8++;
	}
	return dst;
  800df6:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800df9:	c9                   	leave  
  800dfa:	c3                   	ret    

00800dfb <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800dfb:	55                   	push   %ebp
  800dfc:	89 e5                	mov    %esp,%ebp
  800dfe:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800e01:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e04:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800e07:	8b 45 08             	mov    0x8(%ebp),%eax
  800e0a:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800e0d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e10:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800e13:	73 50                	jae    800e65 <memmove+0x6a>
  800e15:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800e18:	8b 45 10             	mov    0x10(%ebp),%eax
  800e1b:	01 d0                	add    %edx,%eax
  800e1d:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800e20:	76 43                	jbe    800e65 <memmove+0x6a>
		s += n;
  800e22:	8b 45 10             	mov    0x10(%ebp),%eax
  800e25:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800e28:	8b 45 10             	mov    0x10(%ebp),%eax
  800e2b:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800e2e:	eb 10                	jmp    800e40 <memmove+0x45>
			*--d = *--s;
  800e30:	ff 4d f8             	decl   -0x8(%ebp)
  800e33:	ff 4d fc             	decl   -0x4(%ebp)
  800e36:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e39:	8a 10                	mov    (%eax),%dl
  800e3b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e3e:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800e40:	8b 45 10             	mov    0x10(%ebp),%eax
  800e43:	8d 50 ff             	lea    -0x1(%eax),%edx
  800e46:	89 55 10             	mov    %edx,0x10(%ebp)
  800e49:	85 c0                	test   %eax,%eax
  800e4b:	75 e3                	jne    800e30 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800e4d:	eb 23                	jmp    800e72 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800e4f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e52:	8d 50 01             	lea    0x1(%eax),%edx
  800e55:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800e58:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800e5b:	8d 4a 01             	lea    0x1(%edx),%ecx
  800e5e:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800e61:	8a 12                	mov    (%edx),%dl
  800e63:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800e65:	8b 45 10             	mov    0x10(%ebp),%eax
  800e68:	8d 50 ff             	lea    -0x1(%eax),%edx
  800e6b:	89 55 10             	mov    %edx,0x10(%ebp)
  800e6e:	85 c0                	test   %eax,%eax
  800e70:	75 dd                	jne    800e4f <memmove+0x54>
			*d++ = *s++;

	return dst;
  800e72:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e75:	c9                   	leave  
  800e76:	c3                   	ret    

00800e77 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  800e77:	55                   	push   %ebp
  800e78:	89 e5                	mov    %esp,%ebp
  800e7a:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  800e7d:	8b 45 08             	mov    0x8(%ebp),%eax
  800e80:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  800e83:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e86:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800e89:	eb 2a                	jmp    800eb5 <memcmp+0x3e>
		if (*s1 != *s2)
  800e8b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e8e:	8a 10                	mov    (%eax),%dl
  800e90:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e93:	8a 00                	mov    (%eax),%al
  800e95:	38 c2                	cmp    %al,%dl
  800e97:	74 16                	je     800eaf <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  800e99:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e9c:	8a 00                	mov    (%eax),%al
  800e9e:	0f b6 d0             	movzbl %al,%edx
  800ea1:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800ea4:	8a 00                	mov    (%eax),%al
  800ea6:	0f b6 c0             	movzbl %al,%eax
  800ea9:	29 c2                	sub    %eax,%edx
  800eab:	89 d0                	mov    %edx,%eax
  800ead:	eb 18                	jmp    800ec7 <memcmp+0x50>
		s1++, s2++;
  800eaf:	ff 45 fc             	incl   -0x4(%ebp)
  800eb2:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  800eb5:	8b 45 10             	mov    0x10(%ebp),%eax
  800eb8:	8d 50 ff             	lea    -0x1(%eax),%edx
  800ebb:	89 55 10             	mov    %edx,0x10(%ebp)
  800ebe:	85 c0                	test   %eax,%eax
  800ec0:	75 c9                	jne    800e8b <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800ec2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800ec7:	c9                   	leave  
  800ec8:	c3                   	ret    

00800ec9 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  800ec9:	55                   	push   %ebp
  800eca:	89 e5                	mov    %esp,%ebp
  800ecc:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  800ecf:	8b 55 08             	mov    0x8(%ebp),%edx
  800ed2:	8b 45 10             	mov    0x10(%ebp),%eax
  800ed5:	01 d0                	add    %edx,%eax
  800ed7:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  800eda:	eb 15                	jmp    800ef1 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  800edc:	8b 45 08             	mov    0x8(%ebp),%eax
  800edf:	8a 00                	mov    (%eax),%al
  800ee1:	0f b6 d0             	movzbl %al,%edx
  800ee4:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ee7:	0f b6 c0             	movzbl %al,%eax
  800eea:	39 c2                	cmp    %eax,%edx
  800eec:	74 0d                	je     800efb <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800eee:	ff 45 08             	incl   0x8(%ebp)
  800ef1:	8b 45 08             	mov    0x8(%ebp),%eax
  800ef4:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  800ef7:	72 e3                	jb     800edc <memfind+0x13>
  800ef9:	eb 01                	jmp    800efc <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  800efb:	90                   	nop
	return (void *) s;
  800efc:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800eff:	c9                   	leave  
  800f00:	c3                   	ret    

00800f01 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800f01:	55                   	push   %ebp
  800f02:	89 e5                	mov    %esp,%ebp
  800f04:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  800f07:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  800f0e:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800f15:	eb 03                	jmp    800f1a <strtol+0x19>
		s++;
  800f17:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800f1a:	8b 45 08             	mov    0x8(%ebp),%eax
  800f1d:	8a 00                	mov    (%eax),%al
  800f1f:	3c 20                	cmp    $0x20,%al
  800f21:	74 f4                	je     800f17 <strtol+0x16>
  800f23:	8b 45 08             	mov    0x8(%ebp),%eax
  800f26:	8a 00                	mov    (%eax),%al
  800f28:	3c 09                	cmp    $0x9,%al
  800f2a:	74 eb                	je     800f17 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  800f2c:	8b 45 08             	mov    0x8(%ebp),%eax
  800f2f:	8a 00                	mov    (%eax),%al
  800f31:	3c 2b                	cmp    $0x2b,%al
  800f33:	75 05                	jne    800f3a <strtol+0x39>
		s++;
  800f35:	ff 45 08             	incl   0x8(%ebp)
  800f38:	eb 13                	jmp    800f4d <strtol+0x4c>
	else if (*s == '-')
  800f3a:	8b 45 08             	mov    0x8(%ebp),%eax
  800f3d:	8a 00                	mov    (%eax),%al
  800f3f:	3c 2d                	cmp    $0x2d,%al
  800f41:	75 0a                	jne    800f4d <strtol+0x4c>
		s++, neg = 1;
  800f43:	ff 45 08             	incl   0x8(%ebp)
  800f46:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800f4d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f51:	74 06                	je     800f59 <strtol+0x58>
  800f53:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  800f57:	75 20                	jne    800f79 <strtol+0x78>
  800f59:	8b 45 08             	mov    0x8(%ebp),%eax
  800f5c:	8a 00                	mov    (%eax),%al
  800f5e:	3c 30                	cmp    $0x30,%al
  800f60:	75 17                	jne    800f79 <strtol+0x78>
  800f62:	8b 45 08             	mov    0x8(%ebp),%eax
  800f65:	40                   	inc    %eax
  800f66:	8a 00                	mov    (%eax),%al
  800f68:	3c 78                	cmp    $0x78,%al
  800f6a:	75 0d                	jne    800f79 <strtol+0x78>
		s += 2, base = 16;
  800f6c:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  800f70:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  800f77:	eb 28                	jmp    800fa1 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  800f79:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f7d:	75 15                	jne    800f94 <strtol+0x93>
  800f7f:	8b 45 08             	mov    0x8(%ebp),%eax
  800f82:	8a 00                	mov    (%eax),%al
  800f84:	3c 30                	cmp    $0x30,%al
  800f86:	75 0c                	jne    800f94 <strtol+0x93>
		s++, base = 8;
  800f88:	ff 45 08             	incl   0x8(%ebp)
  800f8b:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  800f92:	eb 0d                	jmp    800fa1 <strtol+0xa0>
	else if (base == 0)
  800f94:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f98:	75 07                	jne    800fa1 <strtol+0xa0>
		base = 10;
  800f9a:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800fa1:	8b 45 08             	mov    0x8(%ebp),%eax
  800fa4:	8a 00                	mov    (%eax),%al
  800fa6:	3c 2f                	cmp    $0x2f,%al
  800fa8:	7e 19                	jle    800fc3 <strtol+0xc2>
  800faa:	8b 45 08             	mov    0x8(%ebp),%eax
  800fad:	8a 00                	mov    (%eax),%al
  800faf:	3c 39                	cmp    $0x39,%al
  800fb1:	7f 10                	jg     800fc3 <strtol+0xc2>
			dig = *s - '0';
  800fb3:	8b 45 08             	mov    0x8(%ebp),%eax
  800fb6:	8a 00                	mov    (%eax),%al
  800fb8:	0f be c0             	movsbl %al,%eax
  800fbb:	83 e8 30             	sub    $0x30,%eax
  800fbe:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800fc1:	eb 42                	jmp    801005 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  800fc3:	8b 45 08             	mov    0x8(%ebp),%eax
  800fc6:	8a 00                	mov    (%eax),%al
  800fc8:	3c 60                	cmp    $0x60,%al
  800fca:	7e 19                	jle    800fe5 <strtol+0xe4>
  800fcc:	8b 45 08             	mov    0x8(%ebp),%eax
  800fcf:	8a 00                	mov    (%eax),%al
  800fd1:	3c 7a                	cmp    $0x7a,%al
  800fd3:	7f 10                	jg     800fe5 <strtol+0xe4>
			dig = *s - 'a' + 10;
  800fd5:	8b 45 08             	mov    0x8(%ebp),%eax
  800fd8:	8a 00                	mov    (%eax),%al
  800fda:	0f be c0             	movsbl %al,%eax
  800fdd:	83 e8 57             	sub    $0x57,%eax
  800fe0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800fe3:	eb 20                	jmp    801005 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  800fe5:	8b 45 08             	mov    0x8(%ebp),%eax
  800fe8:	8a 00                	mov    (%eax),%al
  800fea:	3c 40                	cmp    $0x40,%al
  800fec:	7e 39                	jle    801027 <strtol+0x126>
  800fee:	8b 45 08             	mov    0x8(%ebp),%eax
  800ff1:	8a 00                	mov    (%eax),%al
  800ff3:	3c 5a                	cmp    $0x5a,%al
  800ff5:	7f 30                	jg     801027 <strtol+0x126>
			dig = *s - 'A' + 10;
  800ff7:	8b 45 08             	mov    0x8(%ebp),%eax
  800ffa:	8a 00                	mov    (%eax),%al
  800ffc:	0f be c0             	movsbl %al,%eax
  800fff:	83 e8 37             	sub    $0x37,%eax
  801002:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  801005:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801008:	3b 45 10             	cmp    0x10(%ebp),%eax
  80100b:	7d 19                	jge    801026 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  80100d:	ff 45 08             	incl   0x8(%ebp)
  801010:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801013:	0f af 45 10          	imul   0x10(%ebp),%eax
  801017:	89 c2                	mov    %eax,%edx
  801019:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80101c:	01 d0                	add    %edx,%eax
  80101e:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  801021:	e9 7b ff ff ff       	jmp    800fa1 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801026:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801027:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80102b:	74 08                	je     801035 <strtol+0x134>
		*endptr = (char *) s;
  80102d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801030:	8b 55 08             	mov    0x8(%ebp),%edx
  801033:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  801035:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801039:	74 07                	je     801042 <strtol+0x141>
  80103b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80103e:	f7 d8                	neg    %eax
  801040:	eb 03                	jmp    801045 <strtol+0x144>
  801042:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801045:	c9                   	leave  
  801046:	c3                   	ret    

00801047 <ltostr>:

void
ltostr(long value, char *str)
{
  801047:	55                   	push   %ebp
  801048:	89 e5                	mov    %esp,%ebp
  80104a:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  80104d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  801054:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  80105b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80105f:	79 13                	jns    801074 <ltostr+0x2d>
	{
		neg = 1;
  801061:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  801068:	8b 45 0c             	mov    0xc(%ebp),%eax
  80106b:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  80106e:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  801071:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  801074:	8b 45 08             	mov    0x8(%ebp),%eax
  801077:	b9 0a 00 00 00       	mov    $0xa,%ecx
  80107c:	99                   	cltd   
  80107d:	f7 f9                	idiv   %ecx
  80107f:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  801082:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801085:	8d 50 01             	lea    0x1(%eax),%edx
  801088:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80108b:	89 c2                	mov    %eax,%edx
  80108d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801090:	01 d0                	add    %edx,%eax
  801092:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801095:	83 c2 30             	add    $0x30,%edx
  801098:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  80109a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80109d:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8010a2:	f7 e9                	imul   %ecx
  8010a4:	c1 fa 02             	sar    $0x2,%edx
  8010a7:	89 c8                	mov    %ecx,%eax
  8010a9:	c1 f8 1f             	sar    $0x1f,%eax
  8010ac:	29 c2                	sub    %eax,%edx
  8010ae:	89 d0                	mov    %edx,%eax
  8010b0:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  8010b3:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8010b7:	75 bb                	jne    801074 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  8010b9:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  8010c0:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010c3:	48                   	dec    %eax
  8010c4:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  8010c7:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8010cb:	74 3d                	je     80110a <ltostr+0xc3>
		start = 1 ;
  8010cd:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  8010d4:	eb 34                	jmp    80110a <ltostr+0xc3>
	{
		char tmp = str[start] ;
  8010d6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8010d9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010dc:	01 d0                	add    %edx,%eax
  8010de:	8a 00                	mov    (%eax),%al
  8010e0:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  8010e3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8010e6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010e9:	01 c2                	add    %eax,%edx
  8010eb:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  8010ee:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010f1:	01 c8                	add    %ecx,%eax
  8010f3:	8a 00                	mov    (%eax),%al
  8010f5:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  8010f7:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8010fa:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010fd:	01 c2                	add    %eax,%edx
  8010ff:	8a 45 eb             	mov    -0x15(%ebp),%al
  801102:	88 02                	mov    %al,(%edx)
		start++ ;
  801104:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801107:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  80110a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80110d:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801110:	7c c4                	jl     8010d6 <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801112:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801115:	8b 45 0c             	mov    0xc(%ebp),%eax
  801118:	01 d0                	add    %edx,%eax
  80111a:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  80111d:	90                   	nop
  80111e:	c9                   	leave  
  80111f:	c3                   	ret    

00801120 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  801120:	55                   	push   %ebp
  801121:	89 e5                	mov    %esp,%ebp
  801123:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801126:	ff 75 08             	pushl  0x8(%ebp)
  801129:	e8 c4 f9 ff ff       	call   800af2 <strlen>
  80112e:	83 c4 04             	add    $0x4,%esp
  801131:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  801134:	ff 75 0c             	pushl  0xc(%ebp)
  801137:	e8 b6 f9 ff ff       	call   800af2 <strlen>
  80113c:	83 c4 04             	add    $0x4,%esp
  80113f:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  801142:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  801149:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801150:	eb 17                	jmp    801169 <strcconcat+0x49>
		final[s] = str1[s] ;
  801152:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801155:	8b 45 10             	mov    0x10(%ebp),%eax
  801158:	01 c2                	add    %eax,%edx
  80115a:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  80115d:	8b 45 08             	mov    0x8(%ebp),%eax
  801160:	01 c8                	add    %ecx,%eax
  801162:	8a 00                	mov    (%eax),%al
  801164:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  801166:	ff 45 fc             	incl   -0x4(%ebp)
  801169:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80116c:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  80116f:	7c e1                	jl     801152 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  801171:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  801178:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  80117f:	eb 1f                	jmp    8011a0 <strcconcat+0x80>
		final[s++] = str2[i] ;
  801181:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801184:	8d 50 01             	lea    0x1(%eax),%edx
  801187:	89 55 fc             	mov    %edx,-0x4(%ebp)
  80118a:	89 c2                	mov    %eax,%edx
  80118c:	8b 45 10             	mov    0x10(%ebp),%eax
  80118f:	01 c2                	add    %eax,%edx
  801191:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801194:	8b 45 0c             	mov    0xc(%ebp),%eax
  801197:	01 c8                	add    %ecx,%eax
  801199:	8a 00                	mov    (%eax),%al
  80119b:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  80119d:	ff 45 f8             	incl   -0x8(%ebp)
  8011a0:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011a3:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8011a6:	7c d9                	jl     801181 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  8011a8:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8011ab:	8b 45 10             	mov    0x10(%ebp),%eax
  8011ae:	01 d0                	add    %edx,%eax
  8011b0:	c6 00 00             	movb   $0x0,(%eax)
}
  8011b3:	90                   	nop
  8011b4:	c9                   	leave  
  8011b5:	c3                   	ret    

008011b6 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  8011b6:	55                   	push   %ebp
  8011b7:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  8011b9:	8b 45 14             	mov    0x14(%ebp),%eax
  8011bc:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  8011c2:	8b 45 14             	mov    0x14(%ebp),%eax
  8011c5:	8b 00                	mov    (%eax),%eax
  8011c7:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8011ce:	8b 45 10             	mov    0x10(%ebp),%eax
  8011d1:	01 d0                	add    %edx,%eax
  8011d3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8011d9:	eb 0c                	jmp    8011e7 <strsplit+0x31>
			*string++ = 0;
  8011db:	8b 45 08             	mov    0x8(%ebp),%eax
  8011de:	8d 50 01             	lea    0x1(%eax),%edx
  8011e1:	89 55 08             	mov    %edx,0x8(%ebp)
  8011e4:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8011e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8011ea:	8a 00                	mov    (%eax),%al
  8011ec:	84 c0                	test   %al,%al
  8011ee:	74 18                	je     801208 <strsplit+0x52>
  8011f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8011f3:	8a 00                	mov    (%eax),%al
  8011f5:	0f be c0             	movsbl %al,%eax
  8011f8:	50                   	push   %eax
  8011f9:	ff 75 0c             	pushl  0xc(%ebp)
  8011fc:	e8 83 fa ff ff       	call   800c84 <strchr>
  801201:	83 c4 08             	add    $0x8,%esp
  801204:	85 c0                	test   %eax,%eax
  801206:	75 d3                	jne    8011db <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801208:	8b 45 08             	mov    0x8(%ebp),%eax
  80120b:	8a 00                	mov    (%eax),%al
  80120d:	84 c0                	test   %al,%al
  80120f:	74 5a                	je     80126b <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801211:	8b 45 14             	mov    0x14(%ebp),%eax
  801214:	8b 00                	mov    (%eax),%eax
  801216:	83 f8 0f             	cmp    $0xf,%eax
  801219:	75 07                	jne    801222 <strsplit+0x6c>
		{
			return 0;
  80121b:	b8 00 00 00 00       	mov    $0x0,%eax
  801220:	eb 66                	jmp    801288 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801222:	8b 45 14             	mov    0x14(%ebp),%eax
  801225:	8b 00                	mov    (%eax),%eax
  801227:	8d 48 01             	lea    0x1(%eax),%ecx
  80122a:	8b 55 14             	mov    0x14(%ebp),%edx
  80122d:	89 0a                	mov    %ecx,(%edx)
  80122f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801236:	8b 45 10             	mov    0x10(%ebp),%eax
  801239:	01 c2                	add    %eax,%edx
  80123b:	8b 45 08             	mov    0x8(%ebp),%eax
  80123e:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801240:	eb 03                	jmp    801245 <strsplit+0x8f>
			string++;
  801242:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801245:	8b 45 08             	mov    0x8(%ebp),%eax
  801248:	8a 00                	mov    (%eax),%al
  80124a:	84 c0                	test   %al,%al
  80124c:	74 8b                	je     8011d9 <strsplit+0x23>
  80124e:	8b 45 08             	mov    0x8(%ebp),%eax
  801251:	8a 00                	mov    (%eax),%al
  801253:	0f be c0             	movsbl %al,%eax
  801256:	50                   	push   %eax
  801257:	ff 75 0c             	pushl  0xc(%ebp)
  80125a:	e8 25 fa ff ff       	call   800c84 <strchr>
  80125f:	83 c4 08             	add    $0x8,%esp
  801262:	85 c0                	test   %eax,%eax
  801264:	74 dc                	je     801242 <strsplit+0x8c>
			string++;
	}
  801266:	e9 6e ff ff ff       	jmp    8011d9 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  80126b:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  80126c:	8b 45 14             	mov    0x14(%ebp),%eax
  80126f:	8b 00                	mov    (%eax),%eax
  801271:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801278:	8b 45 10             	mov    0x10(%ebp),%eax
  80127b:	01 d0                	add    %edx,%eax
  80127d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801283:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801288:	c9                   	leave  
  801289:	c3                   	ret    

0080128a <str2lower>:


char* str2lower(char *dst, const char *src)
{
  80128a:	55                   	push   %ebp
  80128b:	89 e5                	mov    %esp,%ebp
  80128d:	83 ec 10             	sub    $0x10,%esp
	char* ret = dst;
  801290:	8b 45 08             	mov    0x8(%ebp),%eax
  801293:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (int i = 0; i < strlen(src); ++i)
  801296:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80129d:	eb 4a                	jmp    8012e9 <str2lower+0x5f>
	{
		dst[i] = src[i] ;
  80129f:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8012a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8012a5:	01 c2                	add    %eax,%edx
  8012a7:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8012aa:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012ad:	01 c8                	add    %ecx,%eax
  8012af:	8a 00                	mov    (%eax),%al
  8012b1:	88 02                	mov    %al,(%edx)
		if (src[i] >= 'A' && src[i] <= 'Z')
  8012b3:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8012b6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012b9:	01 d0                	add    %edx,%eax
  8012bb:	8a 00                	mov    (%eax),%al
  8012bd:	3c 40                	cmp    $0x40,%al
  8012bf:	7e 25                	jle    8012e6 <str2lower+0x5c>
  8012c1:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8012c4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012c7:	01 d0                	add    %edx,%eax
  8012c9:	8a 00                	mov    (%eax),%al
  8012cb:	3c 5a                	cmp    $0x5a,%al
  8012cd:	7f 17                	jg     8012e6 <str2lower+0x5c>
		{
			dst[i] += 32 ;
  8012cf:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8012d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8012d5:	01 d0                	add    %edx,%eax
  8012d7:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8012da:	8b 55 08             	mov    0x8(%ebp),%edx
  8012dd:	01 ca                	add    %ecx,%edx
  8012df:	8a 12                	mov    (%edx),%dl
  8012e1:	83 c2 20             	add    $0x20,%edx
  8012e4:	88 10                	mov    %dl,(%eax)


char* str2lower(char *dst, const char *src)
{
	char* ret = dst;
	for (int i = 0; i < strlen(src); ++i)
  8012e6:	ff 45 fc             	incl   -0x4(%ebp)
  8012e9:	ff 75 0c             	pushl  0xc(%ebp)
  8012ec:	e8 01 f8 ff ff       	call   800af2 <strlen>
  8012f1:	83 c4 04             	add    $0x4,%esp
  8012f4:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  8012f7:	7f a6                	jg     80129f <str2lower+0x15>
		if (src[i] >= 'A' && src[i] <= 'Z')
		{
			dst[i] += 32 ;
		}
	}
	return ret;
  8012f9:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8012fc:	c9                   	leave  
  8012fd:	c3                   	ret    

008012fe <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  8012fe:	55                   	push   %ebp
  8012ff:	89 e5                	mov    %esp,%ebp
  801301:	57                   	push   %edi
  801302:	56                   	push   %esi
  801303:	53                   	push   %ebx
  801304:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801307:	8b 45 08             	mov    0x8(%ebp),%eax
  80130a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80130d:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801310:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801313:	8b 7d 18             	mov    0x18(%ebp),%edi
  801316:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801319:	cd 30                	int    $0x30
  80131b:	89 45 f0             	mov    %eax,-0x10(%ebp)
				"b" (a3),
				"D" (a4),
				"S" (a5)
				: "cc", "memory");

	return ret;
  80131e:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801321:	83 c4 10             	add    $0x10,%esp
  801324:	5b                   	pop    %ebx
  801325:	5e                   	pop    %esi
  801326:	5f                   	pop    %edi
  801327:	5d                   	pop    %ebp
  801328:	c3                   	ret    

00801329 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName, int color)
{
  801329:	55                   	push   %ebp
  80132a:	89 e5                	mov    %esp,%ebp
  80132c:	83 ec 04             	sub    $0x4,%esp
  80132f:	8b 45 10             	mov    0x10(%ebp),%eax
  801332:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, color, 0);
  801335:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801338:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80133c:	8b 45 08             	mov    0x8(%ebp),%eax
  80133f:	6a 00                	push   $0x0
  801341:	51                   	push   %ecx
  801342:	52                   	push   %edx
  801343:	ff 75 0c             	pushl  0xc(%ebp)
  801346:	50                   	push   %eax
  801347:	6a 00                	push   $0x0
  801349:	e8 b0 ff ff ff       	call   8012fe <syscall>
  80134e:	83 c4 18             	add    $0x18,%esp
}
  801351:	90                   	nop
  801352:	c9                   	leave  
  801353:	c3                   	ret    

00801354 <sys_cgetc>:

int
sys_cgetc(void)
{
  801354:	55                   	push   %ebp
  801355:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801357:	6a 00                	push   $0x0
  801359:	6a 00                	push   $0x0
  80135b:	6a 00                	push   $0x0
  80135d:	6a 00                	push   $0x0
  80135f:	6a 00                	push   $0x0
  801361:	6a 02                	push   $0x2
  801363:	e8 96 ff ff ff       	call   8012fe <syscall>
  801368:	83 c4 18             	add    $0x18,%esp
}
  80136b:	c9                   	leave  
  80136c:	c3                   	ret    

0080136d <sys_lock_cons>:

void sys_lock_cons(void)
{
  80136d:	55                   	push   %ebp
  80136e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  801370:	6a 00                	push   $0x0
  801372:	6a 00                	push   $0x0
  801374:	6a 00                	push   $0x0
  801376:	6a 00                	push   $0x0
  801378:	6a 00                	push   $0x0
  80137a:	6a 03                	push   $0x3
  80137c:	e8 7d ff ff ff       	call   8012fe <syscall>
  801381:	83 c4 18             	add    $0x18,%esp
}
  801384:	90                   	nop
  801385:	c9                   	leave  
  801386:	c3                   	ret    

00801387 <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  801387:	55                   	push   %ebp
  801388:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  80138a:	6a 00                	push   $0x0
  80138c:	6a 00                	push   $0x0
  80138e:	6a 00                	push   $0x0
  801390:	6a 00                	push   $0x0
  801392:	6a 00                	push   $0x0
  801394:	6a 04                	push   $0x4
  801396:	e8 63 ff ff ff       	call   8012fe <syscall>
  80139b:	83 c4 18             	add    $0x18,%esp
}
  80139e:	90                   	nop
  80139f:	c9                   	leave  
  8013a0:	c3                   	ret    

008013a1 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  8013a1:	55                   	push   %ebp
  8013a2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  8013a4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8013a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8013aa:	6a 00                	push   $0x0
  8013ac:	6a 00                	push   $0x0
  8013ae:	6a 00                	push   $0x0
  8013b0:	52                   	push   %edx
  8013b1:	50                   	push   %eax
  8013b2:	6a 08                	push   $0x8
  8013b4:	e8 45 ff ff ff       	call   8012fe <syscall>
  8013b9:	83 c4 18             	add    $0x18,%esp
}
  8013bc:	c9                   	leave  
  8013bd:	c3                   	ret    

008013be <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  8013be:	55                   	push   %ebp
  8013bf:	89 e5                	mov    %esp,%ebp
  8013c1:	56                   	push   %esi
  8013c2:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  8013c3:	8b 75 18             	mov    0x18(%ebp),%esi
  8013c6:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8013c9:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8013cc:	8b 55 0c             	mov    0xc(%ebp),%edx
  8013cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8013d2:	56                   	push   %esi
  8013d3:	53                   	push   %ebx
  8013d4:	51                   	push   %ecx
  8013d5:	52                   	push   %edx
  8013d6:	50                   	push   %eax
  8013d7:	6a 09                	push   $0x9
  8013d9:	e8 20 ff ff ff       	call   8012fe <syscall>
  8013de:	83 c4 18             	add    $0x18,%esp
}
  8013e1:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8013e4:	5b                   	pop    %ebx
  8013e5:	5e                   	pop    %esi
  8013e6:	5d                   	pop    %ebp
  8013e7:	c3                   	ret    

008013e8 <__sys_unmap_frame>:

int __sys_unmap_frame(uint32 va)
{
  8013e8:	55                   	push   %ebp
  8013e9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, va, 0, 0, 0, 0);
  8013eb:	6a 00                	push   $0x0
  8013ed:	6a 00                	push   $0x0
  8013ef:	6a 00                	push   $0x0
  8013f1:	6a 00                	push   $0x0
  8013f3:	ff 75 08             	pushl  0x8(%ebp)
  8013f6:	6a 0a                	push   $0xa
  8013f8:	e8 01 ff ff ff       	call   8012fe <syscall>
  8013fd:	83 c4 18             	add    $0x18,%esp
}
  801400:	c9                   	leave  
  801401:	c3                   	ret    

00801402 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801402:	55                   	push   %ebp
  801403:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801405:	6a 00                	push   $0x0
  801407:	6a 00                	push   $0x0
  801409:	6a 00                	push   $0x0
  80140b:	ff 75 0c             	pushl  0xc(%ebp)
  80140e:	ff 75 08             	pushl  0x8(%ebp)
  801411:	6a 0b                	push   $0xb
  801413:	e8 e6 fe ff ff       	call   8012fe <syscall>
  801418:	83 c4 18             	add    $0x18,%esp
}
  80141b:	c9                   	leave  
  80141c:	c3                   	ret    

0080141d <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  80141d:	55                   	push   %ebp
  80141e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801420:	6a 00                	push   $0x0
  801422:	6a 00                	push   $0x0
  801424:	6a 00                	push   $0x0
  801426:	6a 00                	push   $0x0
  801428:	6a 00                	push   $0x0
  80142a:	6a 0c                	push   $0xc
  80142c:	e8 cd fe ff ff       	call   8012fe <syscall>
  801431:	83 c4 18             	add    $0x18,%esp
}
  801434:	c9                   	leave  
  801435:	c3                   	ret    

00801436 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801436:	55                   	push   %ebp
  801437:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801439:	6a 00                	push   $0x0
  80143b:	6a 00                	push   $0x0
  80143d:	6a 00                	push   $0x0
  80143f:	6a 00                	push   $0x0
  801441:	6a 00                	push   $0x0
  801443:	6a 0d                	push   $0xd
  801445:	e8 b4 fe ff ff       	call   8012fe <syscall>
  80144a:	83 c4 18             	add    $0x18,%esp
}
  80144d:	c9                   	leave  
  80144e:	c3                   	ret    

0080144f <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  80144f:	55                   	push   %ebp
  801450:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801452:	6a 00                	push   $0x0
  801454:	6a 00                	push   $0x0
  801456:	6a 00                	push   $0x0
  801458:	6a 00                	push   $0x0
  80145a:	6a 00                	push   $0x0
  80145c:	6a 0e                	push   $0xe
  80145e:	e8 9b fe ff ff       	call   8012fe <syscall>
  801463:	83 c4 18             	add    $0x18,%esp
}
  801466:	c9                   	leave  
  801467:	c3                   	ret    

00801468 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801468:	55                   	push   %ebp
  801469:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  80146b:	6a 00                	push   $0x0
  80146d:	6a 00                	push   $0x0
  80146f:	6a 00                	push   $0x0
  801471:	6a 00                	push   $0x0
  801473:	6a 00                	push   $0x0
  801475:	6a 0f                	push   $0xf
  801477:	e8 82 fe ff ff       	call   8012fe <syscall>
  80147c:	83 c4 18             	add    $0x18,%esp
}
  80147f:	c9                   	leave  
  801480:	c3                   	ret    

00801481 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801481:	55                   	push   %ebp
  801482:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801484:	6a 00                	push   $0x0
  801486:	6a 00                	push   $0x0
  801488:	6a 00                	push   $0x0
  80148a:	6a 00                	push   $0x0
  80148c:	ff 75 08             	pushl  0x8(%ebp)
  80148f:	6a 10                	push   $0x10
  801491:	e8 68 fe ff ff       	call   8012fe <syscall>
  801496:	83 c4 18             	add    $0x18,%esp
}
  801499:	c9                   	leave  
  80149a:	c3                   	ret    

0080149b <sys_scarce_memory>:

void sys_scarce_memory()
{
  80149b:	55                   	push   %ebp
  80149c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  80149e:	6a 00                	push   $0x0
  8014a0:	6a 00                	push   $0x0
  8014a2:	6a 00                	push   $0x0
  8014a4:	6a 00                	push   $0x0
  8014a6:	6a 00                	push   $0x0
  8014a8:	6a 11                	push   $0x11
  8014aa:	e8 4f fe ff ff       	call   8012fe <syscall>
  8014af:	83 c4 18             	add    $0x18,%esp
}
  8014b2:	90                   	nop
  8014b3:	c9                   	leave  
  8014b4:	c3                   	ret    

008014b5 <sys_cputc>:

void
sys_cputc(const char c)
{
  8014b5:	55                   	push   %ebp
  8014b6:	89 e5                	mov    %esp,%ebp
  8014b8:	83 ec 04             	sub    $0x4,%esp
  8014bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8014be:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  8014c1:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8014c5:	6a 00                	push   $0x0
  8014c7:	6a 00                	push   $0x0
  8014c9:	6a 00                	push   $0x0
  8014cb:	6a 00                	push   $0x0
  8014cd:	50                   	push   %eax
  8014ce:	6a 01                	push   $0x1
  8014d0:	e8 29 fe ff ff       	call   8012fe <syscall>
  8014d5:	83 c4 18             	add    $0x18,%esp
}
  8014d8:	90                   	nop
  8014d9:	c9                   	leave  
  8014da:	c3                   	ret    

008014db <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  8014db:	55                   	push   %ebp
  8014dc:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  8014de:	6a 00                	push   $0x0
  8014e0:	6a 00                	push   $0x0
  8014e2:	6a 00                	push   $0x0
  8014e4:	6a 00                	push   $0x0
  8014e6:	6a 00                	push   $0x0
  8014e8:	6a 14                	push   $0x14
  8014ea:	e8 0f fe ff ff       	call   8012fe <syscall>
  8014ef:	83 c4 18             	add    $0x18,%esp
}
  8014f2:	90                   	nop
  8014f3:	c9                   	leave  
  8014f4:	c3                   	ret    

008014f5 <sys_create_shared_object>:

int sys_create_shared_object(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  8014f5:	55                   	push   %ebp
  8014f6:	89 e5                	mov    %esp,%ebp
  8014f8:	83 ec 04             	sub    $0x4,%esp
  8014fb:	8b 45 10             	mov    0x10(%ebp),%eax
  8014fe:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801501:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801504:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801508:	8b 45 08             	mov    0x8(%ebp),%eax
  80150b:	6a 00                	push   $0x0
  80150d:	51                   	push   %ecx
  80150e:	52                   	push   %edx
  80150f:	ff 75 0c             	pushl  0xc(%ebp)
  801512:	50                   	push   %eax
  801513:	6a 15                	push   $0x15
  801515:	e8 e4 fd ff ff       	call   8012fe <syscall>
  80151a:	83 c4 18             	add    $0x18,%esp
}
  80151d:	c9                   	leave  
  80151e:	c3                   	ret    

0080151f <sys_size_of_shared_object>:

//2017:
int sys_size_of_shared_object(int32 ownerID, char* shareName)
{
  80151f:	55                   	push   %ebp
  801520:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801522:	8b 55 0c             	mov    0xc(%ebp),%edx
  801525:	8b 45 08             	mov    0x8(%ebp),%eax
  801528:	6a 00                	push   $0x0
  80152a:	6a 00                	push   $0x0
  80152c:	6a 00                	push   $0x0
  80152e:	52                   	push   %edx
  80152f:	50                   	push   %eax
  801530:	6a 16                	push   $0x16
  801532:	e8 c7 fd ff ff       	call   8012fe <syscall>
  801537:	83 c4 18             	add    $0x18,%esp
}
  80153a:	c9                   	leave  
  80153b:	c3                   	ret    

0080153c <sys_get_shared_object>:
//==========

int sys_get_shared_object(int32 ownerID, char* shareName, void* virtual_address)
{
  80153c:	55                   	push   %ebp
  80153d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  80153f:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801542:	8b 55 0c             	mov    0xc(%ebp),%edx
  801545:	8b 45 08             	mov    0x8(%ebp),%eax
  801548:	6a 00                	push   $0x0
  80154a:	6a 00                	push   $0x0
  80154c:	51                   	push   %ecx
  80154d:	52                   	push   %edx
  80154e:	50                   	push   %eax
  80154f:	6a 17                	push   $0x17
  801551:	e8 a8 fd ff ff       	call   8012fe <syscall>
  801556:	83 c4 18             	add    $0x18,%esp
}
  801559:	c9                   	leave  
  80155a:	c3                   	ret    

0080155b <sys_delete_shared_object>:

int sys_delete_shared_object(int32 sharedObjectID, void *startVA)
{
  80155b:	55                   	push   %ebp
  80155c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  80155e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801561:	8b 45 08             	mov    0x8(%ebp),%eax
  801564:	6a 00                	push   $0x0
  801566:	6a 00                	push   $0x0
  801568:	6a 00                	push   $0x0
  80156a:	52                   	push   %edx
  80156b:	50                   	push   %eax
  80156c:	6a 18                	push   $0x18
  80156e:	e8 8b fd ff ff       	call   8012fe <syscall>
  801573:	83 c4 18             	add    $0x18,%esp
}
  801576:	c9                   	leave  
  801577:	c3                   	ret    

00801578 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801578:	55                   	push   %ebp
  801579:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  80157b:	8b 45 08             	mov    0x8(%ebp),%eax
  80157e:	6a 00                	push   $0x0
  801580:	ff 75 14             	pushl  0x14(%ebp)
  801583:	ff 75 10             	pushl  0x10(%ebp)
  801586:	ff 75 0c             	pushl  0xc(%ebp)
  801589:	50                   	push   %eax
  80158a:	6a 19                	push   $0x19
  80158c:	e8 6d fd ff ff       	call   8012fe <syscall>
  801591:	83 c4 18             	add    $0x18,%esp
}
  801594:	c9                   	leave  
  801595:	c3                   	ret    

00801596 <sys_run_env>:

void sys_run_env(int32 envId)
{
  801596:	55                   	push   %ebp
  801597:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801599:	8b 45 08             	mov    0x8(%ebp),%eax
  80159c:	6a 00                	push   $0x0
  80159e:	6a 00                	push   $0x0
  8015a0:	6a 00                	push   $0x0
  8015a2:	6a 00                	push   $0x0
  8015a4:	50                   	push   %eax
  8015a5:	6a 1a                	push   $0x1a
  8015a7:	e8 52 fd ff ff       	call   8012fe <syscall>
  8015ac:	83 c4 18             	add    $0x18,%esp
}
  8015af:	90                   	nop
  8015b0:	c9                   	leave  
  8015b1:	c3                   	ret    

008015b2 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  8015b2:	55                   	push   %ebp
  8015b3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  8015b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8015b8:	6a 00                	push   $0x0
  8015ba:	6a 00                	push   $0x0
  8015bc:	6a 00                	push   $0x0
  8015be:	6a 00                	push   $0x0
  8015c0:	50                   	push   %eax
  8015c1:	6a 1b                	push   $0x1b
  8015c3:	e8 36 fd ff ff       	call   8012fe <syscall>
  8015c8:	83 c4 18             	add    $0x18,%esp
}
  8015cb:	c9                   	leave  
  8015cc:	c3                   	ret    

008015cd <sys_getenvid>:

int32 sys_getenvid(void)
{
  8015cd:	55                   	push   %ebp
  8015ce:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  8015d0:	6a 00                	push   $0x0
  8015d2:	6a 00                	push   $0x0
  8015d4:	6a 00                	push   $0x0
  8015d6:	6a 00                	push   $0x0
  8015d8:	6a 00                	push   $0x0
  8015da:	6a 05                	push   $0x5
  8015dc:	e8 1d fd ff ff       	call   8012fe <syscall>
  8015e1:	83 c4 18             	add    $0x18,%esp
}
  8015e4:	c9                   	leave  
  8015e5:	c3                   	ret    

008015e6 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  8015e6:	55                   	push   %ebp
  8015e7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  8015e9:	6a 00                	push   $0x0
  8015eb:	6a 00                	push   $0x0
  8015ed:	6a 00                	push   $0x0
  8015ef:	6a 00                	push   $0x0
  8015f1:	6a 00                	push   $0x0
  8015f3:	6a 06                	push   $0x6
  8015f5:	e8 04 fd ff ff       	call   8012fe <syscall>
  8015fa:	83 c4 18             	add    $0x18,%esp
}
  8015fd:	c9                   	leave  
  8015fe:	c3                   	ret    

008015ff <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  8015ff:	55                   	push   %ebp
  801600:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801602:	6a 00                	push   $0x0
  801604:	6a 00                	push   $0x0
  801606:	6a 00                	push   $0x0
  801608:	6a 00                	push   $0x0
  80160a:	6a 00                	push   $0x0
  80160c:	6a 07                	push   $0x7
  80160e:	e8 eb fc ff ff       	call   8012fe <syscall>
  801613:	83 c4 18             	add    $0x18,%esp
}
  801616:	c9                   	leave  
  801617:	c3                   	ret    

00801618 <sys_exit_env>:


void sys_exit_env(void)
{
  801618:	55                   	push   %ebp
  801619:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  80161b:	6a 00                	push   $0x0
  80161d:	6a 00                	push   $0x0
  80161f:	6a 00                	push   $0x0
  801621:	6a 00                	push   $0x0
  801623:	6a 00                	push   $0x0
  801625:	6a 1c                	push   $0x1c
  801627:	e8 d2 fc ff ff       	call   8012fe <syscall>
  80162c:	83 c4 18             	add    $0x18,%esp
}
  80162f:	90                   	nop
  801630:	c9                   	leave  
  801631:	c3                   	ret    

00801632 <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  801632:	55                   	push   %ebp
  801633:	89 e5                	mov    %esp,%ebp
  801635:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801638:	8d 45 f8             	lea    -0x8(%ebp),%eax
  80163b:	8d 50 04             	lea    0x4(%eax),%edx
  80163e:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801641:	6a 00                	push   $0x0
  801643:	6a 00                	push   $0x0
  801645:	6a 00                	push   $0x0
  801647:	52                   	push   %edx
  801648:	50                   	push   %eax
  801649:	6a 1d                	push   $0x1d
  80164b:	e8 ae fc ff ff       	call   8012fe <syscall>
  801650:	83 c4 18             	add    $0x18,%esp
	return result;
  801653:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801656:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801659:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80165c:	89 01                	mov    %eax,(%ecx)
  80165e:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801661:	8b 45 08             	mov    0x8(%ebp),%eax
  801664:	c9                   	leave  
  801665:	c2 04 00             	ret    $0x4

00801668 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801668:	55                   	push   %ebp
  801669:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  80166b:	6a 00                	push   $0x0
  80166d:	6a 00                	push   $0x0
  80166f:	ff 75 10             	pushl  0x10(%ebp)
  801672:	ff 75 0c             	pushl  0xc(%ebp)
  801675:	ff 75 08             	pushl  0x8(%ebp)
  801678:	6a 13                	push   $0x13
  80167a:	e8 7f fc ff ff       	call   8012fe <syscall>
  80167f:	83 c4 18             	add    $0x18,%esp
	return ;
  801682:	90                   	nop
}
  801683:	c9                   	leave  
  801684:	c3                   	ret    

00801685 <sys_rcr2>:
uint32 sys_rcr2()
{
  801685:	55                   	push   %ebp
  801686:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801688:	6a 00                	push   $0x0
  80168a:	6a 00                	push   $0x0
  80168c:	6a 00                	push   $0x0
  80168e:	6a 00                	push   $0x0
  801690:	6a 00                	push   $0x0
  801692:	6a 1e                	push   $0x1e
  801694:	e8 65 fc ff ff       	call   8012fe <syscall>
  801699:	83 c4 18             	add    $0x18,%esp
}
  80169c:	c9                   	leave  
  80169d:	c3                   	ret    

0080169e <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  80169e:	55                   	push   %ebp
  80169f:	89 e5                	mov    %esp,%ebp
  8016a1:	83 ec 04             	sub    $0x4,%esp
  8016a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8016a7:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  8016aa:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  8016ae:	6a 00                	push   $0x0
  8016b0:	6a 00                	push   $0x0
  8016b2:	6a 00                	push   $0x0
  8016b4:	6a 00                	push   $0x0
  8016b6:	50                   	push   %eax
  8016b7:	6a 1f                	push   $0x1f
  8016b9:	e8 40 fc ff ff       	call   8012fe <syscall>
  8016be:	83 c4 18             	add    $0x18,%esp
	return ;
  8016c1:	90                   	nop
}
  8016c2:	c9                   	leave  
  8016c3:	c3                   	ret    

008016c4 <rsttst>:
void rsttst()
{
  8016c4:	55                   	push   %ebp
  8016c5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  8016c7:	6a 00                	push   $0x0
  8016c9:	6a 00                	push   $0x0
  8016cb:	6a 00                	push   $0x0
  8016cd:	6a 00                	push   $0x0
  8016cf:	6a 00                	push   $0x0
  8016d1:	6a 21                	push   $0x21
  8016d3:	e8 26 fc ff ff       	call   8012fe <syscall>
  8016d8:	83 c4 18             	add    $0x18,%esp
	return ;
  8016db:	90                   	nop
}
  8016dc:	c9                   	leave  
  8016dd:	c3                   	ret    

008016de <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  8016de:	55                   	push   %ebp
  8016df:	89 e5                	mov    %esp,%ebp
  8016e1:	83 ec 04             	sub    $0x4,%esp
  8016e4:	8b 45 14             	mov    0x14(%ebp),%eax
  8016e7:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  8016ea:	8b 55 18             	mov    0x18(%ebp),%edx
  8016ed:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8016f1:	52                   	push   %edx
  8016f2:	50                   	push   %eax
  8016f3:	ff 75 10             	pushl  0x10(%ebp)
  8016f6:	ff 75 0c             	pushl  0xc(%ebp)
  8016f9:	ff 75 08             	pushl  0x8(%ebp)
  8016fc:	6a 20                	push   $0x20
  8016fe:	e8 fb fb ff ff       	call   8012fe <syscall>
  801703:	83 c4 18             	add    $0x18,%esp
	return ;
  801706:	90                   	nop
}
  801707:	c9                   	leave  
  801708:	c3                   	ret    

00801709 <chktst>:
void chktst(uint32 n)
{
  801709:	55                   	push   %ebp
  80170a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  80170c:	6a 00                	push   $0x0
  80170e:	6a 00                	push   $0x0
  801710:	6a 00                	push   $0x0
  801712:	6a 00                	push   $0x0
  801714:	ff 75 08             	pushl  0x8(%ebp)
  801717:	6a 22                	push   $0x22
  801719:	e8 e0 fb ff ff       	call   8012fe <syscall>
  80171e:	83 c4 18             	add    $0x18,%esp
	return ;
  801721:	90                   	nop
}
  801722:	c9                   	leave  
  801723:	c3                   	ret    

00801724 <inctst>:

void inctst()
{
  801724:	55                   	push   %ebp
  801725:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801727:	6a 00                	push   $0x0
  801729:	6a 00                	push   $0x0
  80172b:	6a 00                	push   $0x0
  80172d:	6a 00                	push   $0x0
  80172f:	6a 00                	push   $0x0
  801731:	6a 23                	push   $0x23
  801733:	e8 c6 fb ff ff       	call   8012fe <syscall>
  801738:	83 c4 18             	add    $0x18,%esp
	return ;
  80173b:	90                   	nop
}
  80173c:	c9                   	leave  
  80173d:	c3                   	ret    

0080173e <gettst>:
uint32 gettst()
{
  80173e:	55                   	push   %ebp
  80173f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801741:	6a 00                	push   $0x0
  801743:	6a 00                	push   $0x0
  801745:	6a 00                	push   $0x0
  801747:	6a 00                	push   $0x0
  801749:	6a 00                	push   $0x0
  80174b:	6a 24                	push   $0x24
  80174d:	e8 ac fb ff ff       	call   8012fe <syscall>
  801752:	83 c4 18             	add    $0x18,%esp
}
  801755:	c9                   	leave  
  801756:	c3                   	ret    

00801757 <sys_get_uheap_strategy>:

/*2025*/
uint32 sys_get_uheap_strategy()
{
  801757:	55                   	push   %ebp
  801758:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80175a:	6a 00                	push   $0x0
  80175c:	6a 00                	push   $0x0
  80175e:	6a 00                	push   $0x0
  801760:	6a 00                	push   $0x0
  801762:	6a 00                	push   $0x0
  801764:	6a 25                	push   $0x25
  801766:	e8 93 fb ff ff       	call   8012fe <syscall>
  80176b:	83 c4 18             	add    $0x18,%esp
  80176e:	a3 60 b0 81 00       	mov    %eax,0x81b060
	return uheapPlaceStrategy ;
  801773:	a1 60 b0 81 00       	mov    0x81b060,%eax
}
  801778:	c9                   	leave  
  801779:	c3                   	ret    

0080177a <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  80177a:	55                   	push   %ebp
  80177b:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = heapStrategy;
  80177d:	8b 45 08             	mov    0x8(%ebp),%eax
  801780:	a3 60 b0 81 00       	mov    %eax,0x81b060
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801785:	6a 00                	push   $0x0
  801787:	6a 00                	push   $0x0
  801789:	6a 00                	push   $0x0
  80178b:	6a 00                	push   $0x0
  80178d:	ff 75 08             	pushl  0x8(%ebp)
  801790:	6a 26                	push   $0x26
  801792:	e8 67 fb ff ff       	call   8012fe <syscall>
  801797:	83 c4 18             	add    $0x18,%esp
	return ;
  80179a:	90                   	nop
}
  80179b:	c9                   	leave  
  80179c:	c3                   	ret    

0080179d <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  80179d:	55                   	push   %ebp
  80179e:	89 e5                	mov    %esp,%ebp
  8017a0:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  8017a1:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8017a4:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8017a7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8017ad:	6a 00                	push   $0x0
  8017af:	53                   	push   %ebx
  8017b0:	51                   	push   %ecx
  8017b1:	52                   	push   %edx
  8017b2:	50                   	push   %eax
  8017b3:	6a 27                	push   $0x27
  8017b5:	e8 44 fb ff ff       	call   8012fe <syscall>
  8017ba:	83 c4 18             	add    $0x18,%esp
}
  8017bd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8017c0:	c9                   	leave  
  8017c1:	c3                   	ret    

008017c2 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  8017c2:	55                   	push   %ebp
  8017c3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  8017c5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8017cb:	6a 00                	push   $0x0
  8017cd:	6a 00                	push   $0x0
  8017cf:	6a 00                	push   $0x0
  8017d1:	52                   	push   %edx
  8017d2:	50                   	push   %eax
  8017d3:	6a 28                	push   $0x28
  8017d5:	e8 24 fb ff ff       	call   8012fe <syscall>
  8017da:	83 c4 18             	add    $0x18,%esp
}
  8017dd:	c9                   	leave  
  8017de:	c3                   	ret    

008017df <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  8017df:	55                   	push   %ebp
  8017e0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  8017e2:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8017e5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8017eb:	6a 00                	push   $0x0
  8017ed:	51                   	push   %ecx
  8017ee:	ff 75 10             	pushl  0x10(%ebp)
  8017f1:	52                   	push   %edx
  8017f2:	50                   	push   %eax
  8017f3:	6a 29                	push   $0x29
  8017f5:	e8 04 fb ff ff       	call   8012fe <syscall>
  8017fa:	83 c4 18             	add    $0x18,%esp
}
  8017fd:	c9                   	leave  
  8017fe:	c3                   	ret    

008017ff <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  8017ff:	55                   	push   %ebp
  801800:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801802:	6a 00                	push   $0x0
  801804:	6a 00                	push   $0x0
  801806:	ff 75 10             	pushl  0x10(%ebp)
  801809:	ff 75 0c             	pushl  0xc(%ebp)
  80180c:	ff 75 08             	pushl  0x8(%ebp)
  80180f:	6a 12                	push   $0x12
  801811:	e8 e8 fa ff ff       	call   8012fe <syscall>
  801816:	83 c4 18             	add    $0x18,%esp
	return ;
  801819:	90                   	nop
}
  80181a:	c9                   	leave  
  80181b:	c3                   	ret    

0080181c <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  80181c:	55                   	push   %ebp
  80181d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  80181f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801822:	8b 45 08             	mov    0x8(%ebp),%eax
  801825:	6a 00                	push   $0x0
  801827:	6a 00                	push   $0x0
  801829:	6a 00                	push   $0x0
  80182b:	52                   	push   %edx
  80182c:	50                   	push   %eax
  80182d:	6a 2a                	push   $0x2a
  80182f:	e8 ca fa ff ff       	call   8012fe <syscall>
  801834:	83 c4 18             	add    $0x18,%esp
	return;
  801837:	90                   	nop
}
  801838:	c9                   	leave  
  801839:	c3                   	ret    

0080183a <sys_get_optimal_num_faults>:
/*2025*/
int sys_get_optimal_num_faults()
{
  80183a:	55                   	push   %ebp
  80183b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_optimal_num_faults, 0, 0, 0, 0, 0);
  80183d:	6a 00                	push   $0x0
  80183f:	6a 00                	push   $0x0
  801841:	6a 00                	push   $0x0
  801843:	6a 00                	push   $0x0
  801845:	6a 00                	push   $0x0
  801847:	6a 2b                	push   $0x2b
  801849:	e8 b0 fa ff ff       	call   8012fe <syscall>
  80184e:	83 c4 18             	add    $0x18,%esp
}
  801851:	c9                   	leave  
  801852:	c3                   	ret    

00801853 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801853:	55                   	push   %ebp
  801854:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801856:	6a 00                	push   $0x0
  801858:	6a 00                	push   $0x0
  80185a:	6a 00                	push   $0x0
  80185c:	ff 75 0c             	pushl  0xc(%ebp)
  80185f:	ff 75 08             	pushl  0x8(%ebp)
  801862:	6a 2d                	push   $0x2d
  801864:	e8 95 fa ff ff       	call   8012fe <syscall>
  801869:	83 c4 18             	add    $0x18,%esp
	return;
  80186c:	90                   	nop
}
  80186d:	c9                   	leave  
  80186e:	c3                   	ret    

0080186f <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  80186f:	55                   	push   %ebp
  801870:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801872:	6a 00                	push   $0x0
  801874:	6a 00                	push   $0x0
  801876:	6a 00                	push   $0x0
  801878:	ff 75 0c             	pushl  0xc(%ebp)
  80187b:	ff 75 08             	pushl  0x8(%ebp)
  80187e:	6a 2c                	push   $0x2c
  801880:	e8 79 fa ff ff       	call   8012fe <syscall>
  801885:	83 c4 18             	add    $0x18,%esp
	return ;
  801888:	90                   	nop
}
  801889:	c9                   	leave  
  80188a:	c3                   	ret    

0080188b <sys_env_set_priority>:


void sys_env_set_priority(int32 envID, int priority)
{
  80188b:	55                   	push   %ebp
  80188c:	89 e5                	mov    %esp,%ebp
  80188e:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.IM#4] CPU SCHEDULING - #1 System Calls - Add suitable code here
	//Your code is here
	//Comment the following line
	panic("sys_env_set_priority() is not implemented yet...!!");
  801891:	83 ec 04             	sub    $0x4,%esp
  801894:	68 08 24 80 00       	push   $0x802408
  801899:	68 25 01 00 00       	push   $0x125
  80189e:	68 3b 24 80 00       	push   $0x80243b
  8018a3:	e8 be 00 00 00       	call   801966 <_panic>

008018a8 <env_sleep>:
#include <inc/lib.h>
#include <inc/timerreg.h>

void
env_sleep(uint32 approxMilliSeconds)
{
  8018a8:	55                   	push   %ebp
  8018a9:	89 e5                	mov    %esp,%ebp
  8018ab:	83 ec 30             	sub    $0x30,%esp
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
  8018ae:	8b 55 08             	mov    0x8(%ebp),%edx
  8018b1:	89 d0                	mov    %edx,%eax
  8018b3:	c1 e0 02             	shl    $0x2,%eax
  8018b6:	01 d0                	add    %edx,%eax
  8018b8:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8018bf:	01 d0                	add    %edx,%eax
  8018c1:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8018c8:	01 d0                	add    %edx,%eax
  8018ca:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8018d1:	01 d0                	add    %edx,%eax
  8018d3:	c1 e0 04             	shl    $0x4,%eax
  8018d6:	89 45 f8             	mov    %eax,-0x8(%ebp)
	uint32 cycles_counter =0;
  8018d9:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)

static inline __attribute__((always_inline)) struct uint64 get_virtual_time_user()
{
	struct uint64 result;

	__asm __volatile("rdtsc\n"
  8018e0:	0f 31                	rdtsc  
  8018e2:	89 45 e8             	mov    %eax,-0x18(%ebp)
  8018e5:	89 55 ec             	mov    %edx,-0x14(%ebp)
	: "=a" (result.low), "=d" (result.hi)
	);

	return result;
  8018e8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8018eb:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8018ee:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8018f1:	89 55 f4             	mov    %edx,-0xc(%ebp)

	/*2024*/ //USE A USER-SIDE VERSION OF THIS FUNCTION TO AVOID SLOW-DOWN THE PERFORMANCE DUE SYS_CALL (el7 :))
	//struct uint64 baseTime = sys_get_virtual_time() ;
	struct uint64 baseTime = get_virtual_time_user() ;
	while(cycles_counter<time_in_cycles)
  8018f4:	eb 46                	jmp    80193c <env_sleep+0x94>

static inline __attribute__((always_inline)) struct uint64 get_virtual_time_user()
{
	struct uint64 result;

	__asm __volatile("rdtsc\n"
  8018f6:	0f 31                	rdtsc  
  8018f8:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8018fb:	89 55 d4             	mov    %edx,-0x2c(%ebp)
	: "=a" (result.low), "=d" (result.hi)
	);

	return result;
  8018fe:	8b 45 d0             	mov    -0x30(%ebp),%eax
  801901:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  801904:	89 45 e0             	mov    %eax,-0x20(%ebp)
  801907:	89 55 e4             	mov    %edx,-0x1c(%ebp)

		// update the cycles_count
		#define M32 0xffffffff
		// subtract basetime from current time
		struct uint64 res;
		res.low = (currentTime.low - baseTime.low) & M32;
  80190a:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80190d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801910:	29 c2                	sub    %eax,%edx
  801912:	89 d0                	mov    %edx,%eax
  801914:	89 45 d8             	mov    %eax,-0x28(%ebp)
		res.hi = (currentTime.hi - baseTime.hi - (res.low > currentTime.low)) & M32;
  801917:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80191a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80191d:	89 d1                	mov    %edx,%ecx
  80191f:	29 c1                	sub    %eax,%ecx
  801921:	8b 55 d8             	mov    -0x28(%ebp),%edx
  801924:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801927:	39 c2                	cmp    %eax,%edx
  801929:	0f 97 c0             	seta   %al
  80192c:	0f b6 c0             	movzbl %al,%eax
  80192f:	29 c1                	sub    %eax,%ecx
  801931:	89 c8                	mov    %ecx,%eax
  801933:	89 45 dc             	mov    %eax,-0x24(%ebp)

		//update cycles_count with result
		cycles_counter = res.low;
  801936:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801939:	89 45 fc             	mov    %eax,-0x4(%ebp)
	uint32 cycles_counter =0;

	/*2024*/ //USE A USER-SIDE VERSION OF THIS FUNCTION TO AVOID SLOW-DOWN THE PERFORMANCE DUE SYS_CALL (el7 :))
	//struct uint64 baseTime = sys_get_virtual_time() ;
	struct uint64 baseTime = get_virtual_time_user() ;
	while(cycles_counter<time_in_cycles)
  80193c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80193f:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801942:	72 b2                	jb     8018f6 <env_sleep+0x4e>
//				,cycles_counter
//				);
	}
	//cprintf("%s [%d] wake up now!\n", myEnv->prog_name, myEnv->env_id);

}
  801944:	90                   	nop
  801945:	c9                   	leave  
  801946:	c3                   	ret    

00801947 <busy_wait>:

//2017
uint32 busy_wait(uint32 loopMax)
{
  801947:	55                   	push   %ebp
  801948:	89 e5                	mov    %esp,%ebp
  80194a:	83 ec 10             	sub    $0x10,%esp
	uint32 i = 0 ;
  80194d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	while (i < loopMax) i++;
  801954:	eb 03                	jmp    801959 <busy_wait+0x12>
  801956:	ff 45 fc             	incl   -0x4(%ebp)
  801959:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80195c:	3b 45 08             	cmp    0x8(%ebp),%eax
  80195f:	72 f5                	jb     801956 <busy_wait+0xf>
	return i;
  801961:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801964:	c9                   	leave  
  801965:	c3                   	ret    

00801966 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  801966:	55                   	push   %ebp
  801967:	89 e5                	mov    %esp,%ebp
  801969:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  80196c:	8d 45 10             	lea    0x10(%ebp),%eax
  80196f:	83 c0 04             	add    $0x4,%eax
  801972:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  801975:	a1 1c b1 81 00       	mov    0x81b11c,%eax
  80197a:	85 c0                	test   %eax,%eax
  80197c:	74 16                	je     801994 <_panic+0x2e>
		cprintf("%s: ", argv0);
  80197e:	a1 1c b1 81 00       	mov    0x81b11c,%eax
  801983:	83 ec 08             	sub    $0x8,%esp
  801986:	50                   	push   %eax
  801987:	68 4c 24 80 00       	push   $0x80244c
  80198c:	e8 88 ea ff ff       	call   800419 <cprintf>
  801991:	83 c4 10             	add    $0x10,%esp
	cprintf_colored(TEXT_PANIC_CLR, "user [EVAL_FINAL]panic in %s at %s:%d: ", binaryname, file, line);
  801994:	a1 04 30 80 00       	mov    0x803004,%eax
  801999:	83 ec 0c             	sub    $0xc,%esp
  80199c:	ff 75 0c             	pushl  0xc(%ebp)
  80199f:	ff 75 08             	pushl  0x8(%ebp)
  8019a2:	50                   	push   %eax
  8019a3:	68 54 24 80 00       	push   $0x802454
  8019a8:	6a 74                	push   $0x74
  8019aa:	e8 97 ea ff ff       	call   800446 <cprintf_colored>
  8019af:	83 c4 20             	add    $0x20,%esp
	vcprintf(fmt, ap);
  8019b2:	8b 45 10             	mov    0x10(%ebp),%eax
  8019b5:	83 ec 08             	sub    $0x8,%esp
  8019b8:	ff 75 f4             	pushl  -0xc(%ebp)
  8019bb:	50                   	push   %eax
  8019bc:	e8 e9 e9 ff ff       	call   8003aa <vcprintf>
  8019c1:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  8019c4:	83 ec 08             	sub    $0x8,%esp
  8019c7:	6a 00                	push   $0x0
  8019c9:	68 7c 24 80 00       	push   $0x80247c
  8019ce:	e8 d7 e9 ff ff       	call   8003aa <vcprintf>
  8019d3:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  8019d6:	e8 50 e9 ff ff       	call   80032b <exit>

	// should not return here
	while (1) ;
  8019db:	eb fe                	jmp    8019db <_panic+0x75>

008019dd <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  8019dd:	55                   	push   %ebp
  8019de:	89 e5                	mov    %esp,%ebp
  8019e0:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  8019e3:	a1 20 30 80 00       	mov    0x803020,%eax
  8019e8:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  8019ee:	8b 45 0c             	mov    0xc(%ebp),%eax
  8019f1:	39 c2                	cmp    %eax,%edx
  8019f3:	74 14                	je     801a09 <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  8019f5:	83 ec 04             	sub    $0x4,%esp
  8019f8:	68 80 24 80 00       	push   $0x802480
  8019fd:	6a 26                	push   $0x26
  8019ff:	68 cc 24 80 00       	push   $0x8024cc
  801a04:	e8 5d ff ff ff       	call   801966 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  801a09:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  801a10:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  801a17:	e9 c5 00 00 00       	jmp    801ae1 <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  801a1c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a1f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801a26:	8b 45 08             	mov    0x8(%ebp),%eax
  801a29:	01 d0                	add    %edx,%eax
  801a2b:	8b 00                	mov    (%eax),%eax
  801a2d:	85 c0                	test   %eax,%eax
  801a2f:	75 08                	jne    801a39 <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  801a31:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  801a34:	e9 a5 00 00 00       	jmp    801ade <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  801a39:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  801a40:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  801a47:	eb 69                	jmp    801ab2 <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  801a49:	a1 20 30 80 00       	mov    0x803020,%eax
  801a4e:	8b 88 90 05 00 00    	mov    0x590(%eax),%ecx
  801a54:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801a57:	89 d0                	mov    %edx,%eax
  801a59:	01 c0                	add    %eax,%eax
  801a5b:	01 d0                	add    %edx,%eax
  801a5d:	c1 e0 03             	shl    $0x3,%eax
  801a60:	01 c8                	add    %ecx,%eax
  801a62:	8a 40 04             	mov    0x4(%eax),%al
  801a65:	84 c0                	test   %al,%al
  801a67:	75 46                	jne    801aaf <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  801a69:	a1 20 30 80 00       	mov    0x803020,%eax
  801a6e:	8b 88 90 05 00 00    	mov    0x590(%eax),%ecx
  801a74:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801a77:	89 d0                	mov    %edx,%eax
  801a79:	01 c0                	add    %eax,%eax
  801a7b:	01 d0                	add    %edx,%eax
  801a7d:	c1 e0 03             	shl    $0x3,%eax
  801a80:	01 c8                	add    %ecx,%eax
  801a82:	8b 00                	mov    (%eax),%eax
  801a84:	89 45 dc             	mov    %eax,-0x24(%ebp)
  801a87:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801a8a:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801a8f:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  801a91:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a94:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  801a9b:	8b 45 08             	mov    0x8(%ebp),%eax
  801a9e:	01 c8                	add    %ecx,%eax
  801aa0:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  801aa2:	39 c2                	cmp    %eax,%edx
  801aa4:	75 09                	jne    801aaf <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  801aa6:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  801aad:	eb 15                	jmp    801ac4 <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  801aaf:	ff 45 e8             	incl   -0x18(%ebp)
  801ab2:	a1 20 30 80 00       	mov    0x803020,%eax
  801ab7:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  801abd:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801ac0:	39 c2                	cmp    %eax,%edx
  801ac2:	77 85                	ja     801a49 <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  801ac4:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801ac8:	75 14                	jne    801ade <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  801aca:	83 ec 04             	sub    $0x4,%esp
  801acd:	68 d8 24 80 00       	push   $0x8024d8
  801ad2:	6a 3a                	push   $0x3a
  801ad4:	68 cc 24 80 00       	push   $0x8024cc
  801ad9:	e8 88 fe ff ff       	call   801966 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  801ade:	ff 45 f0             	incl   -0x10(%ebp)
  801ae1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ae4:	3b 45 0c             	cmp    0xc(%ebp),%eax
  801ae7:	0f 8c 2f ff ff ff    	jl     801a1c <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  801aed:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  801af4:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  801afb:	eb 26                	jmp    801b23 <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  801afd:	a1 20 30 80 00       	mov    0x803020,%eax
  801b02:	8b 88 90 05 00 00    	mov    0x590(%eax),%ecx
  801b08:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801b0b:	89 d0                	mov    %edx,%eax
  801b0d:	01 c0                	add    %eax,%eax
  801b0f:	01 d0                	add    %edx,%eax
  801b11:	c1 e0 03             	shl    $0x3,%eax
  801b14:	01 c8                	add    %ecx,%eax
  801b16:	8a 40 04             	mov    0x4(%eax),%al
  801b19:	3c 01                	cmp    $0x1,%al
  801b1b:	75 03                	jne    801b20 <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  801b1d:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  801b20:	ff 45 e0             	incl   -0x20(%ebp)
  801b23:	a1 20 30 80 00       	mov    0x803020,%eax
  801b28:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  801b2e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801b31:	39 c2                	cmp    %eax,%edx
  801b33:	77 c8                	ja     801afd <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  801b35:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b38:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  801b3b:	74 14                	je     801b51 <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  801b3d:	83 ec 04             	sub    $0x4,%esp
  801b40:	68 2c 25 80 00       	push   $0x80252c
  801b45:	6a 44                	push   $0x44
  801b47:	68 cc 24 80 00       	push   $0x8024cc
  801b4c:	e8 15 fe ff ff       	call   801966 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  801b51:	90                   	nop
  801b52:	c9                   	leave  
  801b53:	c3                   	ret    

00801b54 <__udivdi3>:
  801b54:	55                   	push   %ebp
  801b55:	57                   	push   %edi
  801b56:	56                   	push   %esi
  801b57:	53                   	push   %ebx
  801b58:	83 ec 1c             	sub    $0x1c,%esp
  801b5b:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  801b5f:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  801b63:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801b67:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801b6b:	89 ca                	mov    %ecx,%edx
  801b6d:	89 f8                	mov    %edi,%eax
  801b6f:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  801b73:	85 f6                	test   %esi,%esi
  801b75:	75 2d                	jne    801ba4 <__udivdi3+0x50>
  801b77:	39 cf                	cmp    %ecx,%edi
  801b79:	77 65                	ja     801be0 <__udivdi3+0x8c>
  801b7b:	89 fd                	mov    %edi,%ebp
  801b7d:	85 ff                	test   %edi,%edi
  801b7f:	75 0b                	jne    801b8c <__udivdi3+0x38>
  801b81:	b8 01 00 00 00       	mov    $0x1,%eax
  801b86:	31 d2                	xor    %edx,%edx
  801b88:	f7 f7                	div    %edi
  801b8a:	89 c5                	mov    %eax,%ebp
  801b8c:	31 d2                	xor    %edx,%edx
  801b8e:	89 c8                	mov    %ecx,%eax
  801b90:	f7 f5                	div    %ebp
  801b92:	89 c1                	mov    %eax,%ecx
  801b94:	89 d8                	mov    %ebx,%eax
  801b96:	f7 f5                	div    %ebp
  801b98:	89 cf                	mov    %ecx,%edi
  801b9a:	89 fa                	mov    %edi,%edx
  801b9c:	83 c4 1c             	add    $0x1c,%esp
  801b9f:	5b                   	pop    %ebx
  801ba0:	5e                   	pop    %esi
  801ba1:	5f                   	pop    %edi
  801ba2:	5d                   	pop    %ebp
  801ba3:	c3                   	ret    
  801ba4:	39 ce                	cmp    %ecx,%esi
  801ba6:	77 28                	ja     801bd0 <__udivdi3+0x7c>
  801ba8:	0f bd fe             	bsr    %esi,%edi
  801bab:	83 f7 1f             	xor    $0x1f,%edi
  801bae:	75 40                	jne    801bf0 <__udivdi3+0x9c>
  801bb0:	39 ce                	cmp    %ecx,%esi
  801bb2:	72 0a                	jb     801bbe <__udivdi3+0x6a>
  801bb4:	3b 44 24 08          	cmp    0x8(%esp),%eax
  801bb8:	0f 87 9e 00 00 00    	ja     801c5c <__udivdi3+0x108>
  801bbe:	b8 01 00 00 00       	mov    $0x1,%eax
  801bc3:	89 fa                	mov    %edi,%edx
  801bc5:	83 c4 1c             	add    $0x1c,%esp
  801bc8:	5b                   	pop    %ebx
  801bc9:	5e                   	pop    %esi
  801bca:	5f                   	pop    %edi
  801bcb:	5d                   	pop    %ebp
  801bcc:	c3                   	ret    
  801bcd:	8d 76 00             	lea    0x0(%esi),%esi
  801bd0:	31 ff                	xor    %edi,%edi
  801bd2:	31 c0                	xor    %eax,%eax
  801bd4:	89 fa                	mov    %edi,%edx
  801bd6:	83 c4 1c             	add    $0x1c,%esp
  801bd9:	5b                   	pop    %ebx
  801bda:	5e                   	pop    %esi
  801bdb:	5f                   	pop    %edi
  801bdc:	5d                   	pop    %ebp
  801bdd:	c3                   	ret    
  801bde:	66 90                	xchg   %ax,%ax
  801be0:	89 d8                	mov    %ebx,%eax
  801be2:	f7 f7                	div    %edi
  801be4:	31 ff                	xor    %edi,%edi
  801be6:	89 fa                	mov    %edi,%edx
  801be8:	83 c4 1c             	add    $0x1c,%esp
  801beb:	5b                   	pop    %ebx
  801bec:	5e                   	pop    %esi
  801bed:	5f                   	pop    %edi
  801bee:	5d                   	pop    %ebp
  801bef:	c3                   	ret    
  801bf0:	bd 20 00 00 00       	mov    $0x20,%ebp
  801bf5:	89 eb                	mov    %ebp,%ebx
  801bf7:	29 fb                	sub    %edi,%ebx
  801bf9:	89 f9                	mov    %edi,%ecx
  801bfb:	d3 e6                	shl    %cl,%esi
  801bfd:	89 c5                	mov    %eax,%ebp
  801bff:	88 d9                	mov    %bl,%cl
  801c01:	d3 ed                	shr    %cl,%ebp
  801c03:	89 e9                	mov    %ebp,%ecx
  801c05:	09 f1                	or     %esi,%ecx
  801c07:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  801c0b:	89 f9                	mov    %edi,%ecx
  801c0d:	d3 e0                	shl    %cl,%eax
  801c0f:	89 c5                	mov    %eax,%ebp
  801c11:	89 d6                	mov    %edx,%esi
  801c13:	88 d9                	mov    %bl,%cl
  801c15:	d3 ee                	shr    %cl,%esi
  801c17:	89 f9                	mov    %edi,%ecx
  801c19:	d3 e2                	shl    %cl,%edx
  801c1b:	8b 44 24 08          	mov    0x8(%esp),%eax
  801c1f:	88 d9                	mov    %bl,%cl
  801c21:	d3 e8                	shr    %cl,%eax
  801c23:	09 c2                	or     %eax,%edx
  801c25:	89 d0                	mov    %edx,%eax
  801c27:	89 f2                	mov    %esi,%edx
  801c29:	f7 74 24 0c          	divl   0xc(%esp)
  801c2d:	89 d6                	mov    %edx,%esi
  801c2f:	89 c3                	mov    %eax,%ebx
  801c31:	f7 e5                	mul    %ebp
  801c33:	39 d6                	cmp    %edx,%esi
  801c35:	72 19                	jb     801c50 <__udivdi3+0xfc>
  801c37:	74 0b                	je     801c44 <__udivdi3+0xf0>
  801c39:	89 d8                	mov    %ebx,%eax
  801c3b:	31 ff                	xor    %edi,%edi
  801c3d:	e9 58 ff ff ff       	jmp    801b9a <__udivdi3+0x46>
  801c42:	66 90                	xchg   %ax,%ax
  801c44:	8b 54 24 08          	mov    0x8(%esp),%edx
  801c48:	89 f9                	mov    %edi,%ecx
  801c4a:	d3 e2                	shl    %cl,%edx
  801c4c:	39 c2                	cmp    %eax,%edx
  801c4e:	73 e9                	jae    801c39 <__udivdi3+0xe5>
  801c50:	8d 43 ff             	lea    -0x1(%ebx),%eax
  801c53:	31 ff                	xor    %edi,%edi
  801c55:	e9 40 ff ff ff       	jmp    801b9a <__udivdi3+0x46>
  801c5a:	66 90                	xchg   %ax,%ax
  801c5c:	31 c0                	xor    %eax,%eax
  801c5e:	e9 37 ff ff ff       	jmp    801b9a <__udivdi3+0x46>
  801c63:	90                   	nop

00801c64 <__umoddi3>:
  801c64:	55                   	push   %ebp
  801c65:	57                   	push   %edi
  801c66:	56                   	push   %esi
  801c67:	53                   	push   %ebx
  801c68:	83 ec 1c             	sub    $0x1c,%esp
  801c6b:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  801c6f:	8b 74 24 34          	mov    0x34(%esp),%esi
  801c73:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801c77:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  801c7b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801c7f:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801c83:	89 f3                	mov    %esi,%ebx
  801c85:	89 fa                	mov    %edi,%edx
  801c87:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801c8b:	89 34 24             	mov    %esi,(%esp)
  801c8e:	85 c0                	test   %eax,%eax
  801c90:	75 1a                	jne    801cac <__umoddi3+0x48>
  801c92:	39 f7                	cmp    %esi,%edi
  801c94:	0f 86 a2 00 00 00    	jbe    801d3c <__umoddi3+0xd8>
  801c9a:	89 c8                	mov    %ecx,%eax
  801c9c:	89 f2                	mov    %esi,%edx
  801c9e:	f7 f7                	div    %edi
  801ca0:	89 d0                	mov    %edx,%eax
  801ca2:	31 d2                	xor    %edx,%edx
  801ca4:	83 c4 1c             	add    $0x1c,%esp
  801ca7:	5b                   	pop    %ebx
  801ca8:	5e                   	pop    %esi
  801ca9:	5f                   	pop    %edi
  801caa:	5d                   	pop    %ebp
  801cab:	c3                   	ret    
  801cac:	39 f0                	cmp    %esi,%eax
  801cae:	0f 87 ac 00 00 00    	ja     801d60 <__umoddi3+0xfc>
  801cb4:	0f bd e8             	bsr    %eax,%ebp
  801cb7:	83 f5 1f             	xor    $0x1f,%ebp
  801cba:	0f 84 ac 00 00 00    	je     801d6c <__umoddi3+0x108>
  801cc0:	bf 20 00 00 00       	mov    $0x20,%edi
  801cc5:	29 ef                	sub    %ebp,%edi
  801cc7:	89 fe                	mov    %edi,%esi
  801cc9:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801ccd:	89 e9                	mov    %ebp,%ecx
  801ccf:	d3 e0                	shl    %cl,%eax
  801cd1:	89 d7                	mov    %edx,%edi
  801cd3:	89 f1                	mov    %esi,%ecx
  801cd5:	d3 ef                	shr    %cl,%edi
  801cd7:	09 c7                	or     %eax,%edi
  801cd9:	89 e9                	mov    %ebp,%ecx
  801cdb:	d3 e2                	shl    %cl,%edx
  801cdd:	89 14 24             	mov    %edx,(%esp)
  801ce0:	89 d8                	mov    %ebx,%eax
  801ce2:	d3 e0                	shl    %cl,%eax
  801ce4:	89 c2                	mov    %eax,%edx
  801ce6:	8b 44 24 08          	mov    0x8(%esp),%eax
  801cea:	d3 e0                	shl    %cl,%eax
  801cec:	89 44 24 04          	mov    %eax,0x4(%esp)
  801cf0:	8b 44 24 08          	mov    0x8(%esp),%eax
  801cf4:	89 f1                	mov    %esi,%ecx
  801cf6:	d3 e8                	shr    %cl,%eax
  801cf8:	09 d0                	or     %edx,%eax
  801cfa:	d3 eb                	shr    %cl,%ebx
  801cfc:	89 da                	mov    %ebx,%edx
  801cfe:	f7 f7                	div    %edi
  801d00:	89 d3                	mov    %edx,%ebx
  801d02:	f7 24 24             	mull   (%esp)
  801d05:	89 c6                	mov    %eax,%esi
  801d07:	89 d1                	mov    %edx,%ecx
  801d09:	39 d3                	cmp    %edx,%ebx
  801d0b:	0f 82 87 00 00 00    	jb     801d98 <__umoddi3+0x134>
  801d11:	0f 84 91 00 00 00    	je     801da8 <__umoddi3+0x144>
  801d17:	8b 54 24 04          	mov    0x4(%esp),%edx
  801d1b:	29 f2                	sub    %esi,%edx
  801d1d:	19 cb                	sbb    %ecx,%ebx
  801d1f:	89 d8                	mov    %ebx,%eax
  801d21:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  801d25:	d3 e0                	shl    %cl,%eax
  801d27:	89 e9                	mov    %ebp,%ecx
  801d29:	d3 ea                	shr    %cl,%edx
  801d2b:	09 d0                	or     %edx,%eax
  801d2d:	89 e9                	mov    %ebp,%ecx
  801d2f:	d3 eb                	shr    %cl,%ebx
  801d31:	89 da                	mov    %ebx,%edx
  801d33:	83 c4 1c             	add    $0x1c,%esp
  801d36:	5b                   	pop    %ebx
  801d37:	5e                   	pop    %esi
  801d38:	5f                   	pop    %edi
  801d39:	5d                   	pop    %ebp
  801d3a:	c3                   	ret    
  801d3b:	90                   	nop
  801d3c:	89 fd                	mov    %edi,%ebp
  801d3e:	85 ff                	test   %edi,%edi
  801d40:	75 0b                	jne    801d4d <__umoddi3+0xe9>
  801d42:	b8 01 00 00 00       	mov    $0x1,%eax
  801d47:	31 d2                	xor    %edx,%edx
  801d49:	f7 f7                	div    %edi
  801d4b:	89 c5                	mov    %eax,%ebp
  801d4d:	89 f0                	mov    %esi,%eax
  801d4f:	31 d2                	xor    %edx,%edx
  801d51:	f7 f5                	div    %ebp
  801d53:	89 c8                	mov    %ecx,%eax
  801d55:	f7 f5                	div    %ebp
  801d57:	89 d0                	mov    %edx,%eax
  801d59:	e9 44 ff ff ff       	jmp    801ca2 <__umoddi3+0x3e>
  801d5e:	66 90                	xchg   %ax,%ax
  801d60:	89 c8                	mov    %ecx,%eax
  801d62:	89 f2                	mov    %esi,%edx
  801d64:	83 c4 1c             	add    $0x1c,%esp
  801d67:	5b                   	pop    %ebx
  801d68:	5e                   	pop    %esi
  801d69:	5f                   	pop    %edi
  801d6a:	5d                   	pop    %ebp
  801d6b:	c3                   	ret    
  801d6c:	3b 04 24             	cmp    (%esp),%eax
  801d6f:	72 06                	jb     801d77 <__umoddi3+0x113>
  801d71:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  801d75:	77 0f                	ja     801d86 <__umoddi3+0x122>
  801d77:	89 f2                	mov    %esi,%edx
  801d79:	29 f9                	sub    %edi,%ecx
  801d7b:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  801d7f:	89 14 24             	mov    %edx,(%esp)
  801d82:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801d86:	8b 44 24 04          	mov    0x4(%esp),%eax
  801d8a:	8b 14 24             	mov    (%esp),%edx
  801d8d:	83 c4 1c             	add    $0x1c,%esp
  801d90:	5b                   	pop    %ebx
  801d91:	5e                   	pop    %esi
  801d92:	5f                   	pop    %edi
  801d93:	5d                   	pop    %ebp
  801d94:	c3                   	ret    
  801d95:	8d 76 00             	lea    0x0(%esi),%esi
  801d98:	2b 04 24             	sub    (%esp),%eax
  801d9b:	19 fa                	sbb    %edi,%edx
  801d9d:	89 d1                	mov    %edx,%ecx
  801d9f:	89 c6                	mov    %eax,%esi
  801da1:	e9 71 ff ff ff       	jmp    801d17 <__umoddi3+0xb3>
  801da6:	66 90                	xchg   %ax,%ax
  801da8:	39 44 24 04          	cmp    %eax,0x4(%esp)
  801dac:	72 ea                	jb     801d98 <__umoddi3+0x134>
  801dae:	89 d9                	mov    %ebx,%ecx
  801db0:	e9 62 ff ff ff       	jmp    801d17 <__umoddi3+0xb3>
