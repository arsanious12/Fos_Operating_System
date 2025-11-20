
obj/user/tst_chan_all_slave:     file format elf32-i386


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
  800031:	e8 74 00 00 00       	call   8000aa <libmain>
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
  80003e:	83 ec 5c             	sub    $0x5c,%esp
	int envID = sys_getenvid();
  800041:	e8 bd 14 00 00       	call   801503 <sys_getenvid>
  800046:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	//Sleep on the channel
	char cmd[64] = "__Sleep__";
  800049:	8d 45 a4             	lea    -0x5c(%ebp),%eax
  80004c:	bb 5a 1c 80 00       	mov    $0x801c5a,%ebx
  800051:	ba 0a 00 00 00       	mov    $0xa,%edx
  800056:	89 c7                	mov    %eax,%edi
  800058:	89 de                	mov    %ebx,%esi
  80005a:	89 d1                	mov    %edx,%ecx
  80005c:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  80005e:	8d 55 ae             	lea    -0x52(%ebp),%edx
  800061:	b9 36 00 00 00       	mov    $0x36,%ecx
  800066:	b0 00                	mov    $0x0,%al
  800068:	89 d7                	mov    %edx,%edi
  80006a:	f3 aa                	rep stos %al,%es:(%edi)
	sys_utilities(cmd, 0);
  80006c:	83 ec 08             	sub    $0x8,%esp
  80006f:	6a 00                	push   $0x0
  800071:	8d 45 a4             	lea    -0x5c(%ebp),%eax
  800074:	50                   	push   %eax
  800075:	e8 d8 16 00 00       	call   801752 <sys_utilities>
  80007a:	83 c4 10             	add    $0x10,%esp

	//indicates wakenup
	inctst();
  80007d:	e8 d8 15 00 00       	call   80165a <inctst>

	cprintf_colored(TEXT_light_magenta, ">>> Slave %d is Finished\n", envID);
  800082:	83 ec 04             	sub    $0x4,%esp
  800085:	ff 75 e4             	pushl  -0x1c(%ebp)
  800088:	68 40 1c 80 00       	push   $0x801c40
  80008d:	6a 0d                	push   $0xd
  80008f:	e8 e8 02 00 00       	call   80037c <cprintf_colored>
  800094:	83 c4 10             	add    $0x10,%esp
	printStats = 0;
  800097:	c7 05 00 30 80 00 00 	movl   $0x0,0x803000
  80009e:	00 00 00 

	return;
  8000a1:	90                   	nop
}
  8000a2:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8000a5:	5b                   	pop    %ebx
  8000a6:	5e                   	pop    %esi
  8000a7:	5f                   	pop    %edi
  8000a8:	5d                   	pop    %ebp
  8000a9:	c3                   	ret    

008000aa <libmain>:
volatile bool printStats = 1;

volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";
void
libmain(int argc, char **argv)
{
  8000aa:	55                   	push   %ebp
  8000ab:	89 e5                	mov    %esp,%ebp
  8000ad:	57                   	push   %edi
  8000ae:	56                   	push   %esi
  8000af:	53                   	push   %ebx
  8000b0:	83 ec 7c             	sub    $0x7c,%esp
	//printStats = 1;
	int envIndex = sys_getenvindex();
  8000b3:	e8 64 14 00 00       	call   80151c <sys_getenvindex>
  8000b8:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	myEnv = &(envs[envIndex]);
  8000bb:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8000be:	89 d0                	mov    %edx,%eax
  8000c0:	c1 e0 06             	shl    $0x6,%eax
  8000c3:	29 d0                	sub    %edx,%eax
  8000c5:	c1 e0 02             	shl    $0x2,%eax
  8000c8:	01 d0                	add    %edx,%eax
  8000ca:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8000d1:	01 c8                	add    %ecx,%eax
  8000d3:	c1 e0 03             	shl    $0x3,%eax
  8000d6:	01 d0                	add    %edx,%eax
  8000d8:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8000df:	29 c2                	sub    %eax,%edx
  8000e1:	8d 04 95 00 00 00 00 	lea    0x0(,%edx,4),%eax
  8000e8:	89 c2                	mov    %eax,%edx
  8000ea:	8d 82 00 00 c0 ee    	lea    -0x11400000(%edx),%eax
  8000f0:	a3 20 30 80 00       	mov    %eax,0x803020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  8000f5:	a1 20 30 80 00       	mov    0x803020,%eax
  8000fa:	8a 40 20             	mov    0x20(%eax),%al
  8000fd:	84 c0                	test   %al,%al
  8000ff:	74 0d                	je     80010e <libmain+0x64>
		binaryname = myEnv->prog_name;
  800101:	a1 20 30 80 00       	mov    0x803020,%eax
  800106:	83 c0 20             	add    $0x20,%eax
  800109:	a3 04 30 80 00       	mov    %eax,0x803004

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80010e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800112:	7e 0a                	jle    80011e <libmain+0x74>
		binaryname = argv[0];
  800114:	8b 45 0c             	mov    0xc(%ebp),%eax
  800117:	8b 00                	mov    (%eax),%eax
  800119:	a3 04 30 80 00       	mov    %eax,0x803004

	// call user main routine
	_main(argc, argv);
  80011e:	83 ec 08             	sub    $0x8,%esp
  800121:	ff 75 0c             	pushl  0xc(%ebp)
  800124:	ff 75 08             	pushl  0x8(%ebp)
  800127:	e8 0c ff ff ff       	call   800038 <_main>
  80012c:	83 c4 10             	add    $0x10,%esp

	if (printStats)
  80012f:	a1 00 30 80 00       	mov    0x803000,%eax
  800134:	85 c0                	test   %eax,%eax
  800136:	0f 84 01 01 00 00    	je     80023d <libmain+0x193>
	{
		char isOPTReplCmd[100] = "__IsOPTRepl__" ;
  80013c:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  800142:	bb 94 1d 80 00       	mov    $0x801d94,%ebx
  800147:	ba 0e 00 00 00       	mov    $0xe,%edx
  80014c:	89 c7                	mov    %eax,%edi
  80014e:	89 de                	mov    %ebx,%esi
  800150:	89 d1                	mov    %edx,%ecx
  800152:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  800154:	8d 55 8a             	lea    -0x76(%ebp),%edx
  800157:	b9 56 00 00 00       	mov    $0x56,%ecx
  80015c:	b0 00                	mov    $0x0,%al
  80015e:	89 d7                	mov    %edx,%edi
  800160:	f3 aa                	rep stos %al,%es:(%edi)
		int isOPTRepl = 0;
  800162:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
		sys_utilities(isOPTReplCmd, (uint32)(&isOPTRepl));
  800169:	8d 45 e0             	lea    -0x20(%ebp),%eax
  80016c:	83 ec 08             	sub    $0x8,%esp
  80016f:	50                   	push   %eax
  800170:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  800176:	50                   	push   %eax
  800177:	e8 d6 15 00 00       	call   801752 <sys_utilities>
  80017c:	83 c4 10             	add    $0x10,%esp

		sys_lock_cons();
  80017f:	e8 1f 11 00 00       	call   8012a3 <sys_lock_cons>
		{
			cprintf("**************************************\n");
  800184:	83 ec 0c             	sub    $0xc,%esp
  800187:	68 b4 1c 80 00       	push   $0x801cb4
  80018c:	e8 be 01 00 00       	call   80034f <cprintf>
  800191:	83 c4 10             	add    $0x10,%esp
			if (isOPTRepl)
  800194:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800197:	85 c0                	test   %eax,%eax
  800199:	74 18                	je     8001b3 <libmain+0x109>
			{
				cprintf("OPTIMAL number of page faults = %d\n", sys_get_optimal_num_faults());
  80019b:	e8 d0 15 00 00       	call   801770 <sys_get_optimal_num_faults>
  8001a0:	83 ec 08             	sub    $0x8,%esp
  8001a3:	50                   	push   %eax
  8001a4:	68 dc 1c 80 00       	push   $0x801cdc
  8001a9:	e8 a1 01 00 00       	call   80034f <cprintf>
  8001ae:	83 c4 10             	add    $0x10,%esp
  8001b1:	eb 59                	jmp    80020c <libmain+0x162>
			}
			else
			{
				cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8001b3:	a1 20 30 80 00       	mov    0x803020,%eax
  8001b8:	8b 90 50 da 01 00    	mov    0x1da50(%eax),%edx
  8001be:	a1 20 30 80 00       	mov    0x803020,%eax
  8001c3:	8b 80 40 da 01 00    	mov    0x1da40(%eax),%eax
  8001c9:	83 ec 04             	sub    $0x4,%esp
  8001cc:	52                   	push   %edx
  8001cd:	50                   	push   %eax
  8001ce:	68 00 1d 80 00       	push   $0x801d00
  8001d3:	e8 77 01 00 00       	call   80034f <cprintf>
  8001d8:	83 c4 10             	add    $0x10,%esp
				cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  8001db:	a1 20 30 80 00       	mov    0x803020,%eax
  8001e0:	8b 88 64 da 01 00    	mov    0x1da64(%eax),%ecx
  8001e6:	a1 20 30 80 00       	mov    0x803020,%eax
  8001eb:	8b 90 60 da 01 00    	mov    0x1da60(%eax),%edx
  8001f1:	a1 20 30 80 00       	mov    0x803020,%eax
  8001f6:	8b 80 5c da 01 00    	mov    0x1da5c(%eax),%eax
  8001fc:	51                   	push   %ecx
  8001fd:	52                   	push   %edx
  8001fe:	50                   	push   %eax
  8001ff:	68 28 1d 80 00       	push   $0x801d28
  800204:	e8 46 01 00 00       	call   80034f <cprintf>
  800209:	83 c4 10             	add    $0x10,%esp
			}
			//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
			cprintf("Num of clocks = %d\n", myEnv->nClocks);
  80020c:	a1 20 30 80 00       	mov    0x803020,%eax
  800211:	8b 80 68 da 01 00    	mov    0x1da68(%eax),%eax
  800217:	83 ec 08             	sub    $0x8,%esp
  80021a:	50                   	push   %eax
  80021b:	68 80 1d 80 00       	push   $0x801d80
  800220:	e8 2a 01 00 00       	call   80034f <cprintf>
  800225:	83 c4 10             	add    $0x10,%esp
			cprintf("**************************************\n");
  800228:	83 ec 0c             	sub    $0xc,%esp
  80022b:	68 b4 1c 80 00       	push   $0x801cb4
  800230:	e8 1a 01 00 00       	call   80034f <cprintf>
  800235:	83 c4 10             	add    $0x10,%esp
		}
		sys_unlock_cons();
  800238:	e8 80 10 00 00       	call   8012bd <sys_unlock_cons>
	}

	// exit gracefully
	exit();
  80023d:	e8 1f 00 00 00       	call   800261 <exit>
}
  800242:	90                   	nop
  800243:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800246:	5b                   	pop    %ebx
  800247:	5e                   	pop    %esi
  800248:	5f                   	pop    %edi
  800249:	5d                   	pop    %ebp
  80024a:	c3                   	ret    

0080024b <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  80024b:	55                   	push   %ebp
  80024c:	89 e5                	mov    %esp,%ebp
  80024e:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800251:	83 ec 0c             	sub    $0xc,%esp
  800254:	6a 00                	push   $0x0
  800256:	e8 8d 12 00 00       	call   8014e8 <sys_destroy_env>
  80025b:	83 c4 10             	add    $0x10,%esp
}
  80025e:	90                   	nop
  80025f:	c9                   	leave  
  800260:	c3                   	ret    

00800261 <exit>:

void
exit(void)
{
  800261:	55                   	push   %ebp
  800262:	89 e5                	mov    %esp,%ebp
  800264:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  800267:	e8 e2 12 00 00       	call   80154e <sys_exit_env>
}
  80026c:	90                   	nop
  80026d:	c9                   	leave  
  80026e:	c3                   	ret    

0080026f <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  80026f:	55                   	push   %ebp
  800270:	89 e5                	mov    %esp,%ebp
  800272:	53                   	push   %ebx
  800273:	83 ec 04             	sub    $0x4,%esp
	b->buf[b->idx++] = ch;
  800276:	8b 45 0c             	mov    0xc(%ebp),%eax
  800279:	8b 00                	mov    (%eax),%eax
  80027b:	8d 48 01             	lea    0x1(%eax),%ecx
  80027e:	8b 55 0c             	mov    0xc(%ebp),%edx
  800281:	89 0a                	mov    %ecx,(%edx)
  800283:	8b 55 08             	mov    0x8(%ebp),%edx
  800286:	88 d1                	mov    %dl,%cl
  800288:	8b 55 0c             	mov    0xc(%ebp),%edx
  80028b:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  80028f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800292:	8b 00                	mov    (%eax),%eax
  800294:	3d ff 00 00 00       	cmp    $0xff,%eax
  800299:	75 30                	jne    8002cb <putch+0x5c>
		sys_cputs(b->buf, b->idx, printProgName, curTextClr);
  80029b:	8b 15 18 b1 81 00    	mov    0x81b118,%edx
  8002a1:	a0 44 30 80 00       	mov    0x803044,%al
  8002a6:	0f b6 c0             	movzbl %al,%eax
  8002a9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8002ac:	8b 09                	mov    (%ecx),%ecx
  8002ae:	89 cb                	mov    %ecx,%ebx
  8002b0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8002b3:	83 c1 08             	add    $0x8,%ecx
  8002b6:	52                   	push   %edx
  8002b7:	50                   	push   %eax
  8002b8:	53                   	push   %ebx
  8002b9:	51                   	push   %ecx
  8002ba:	e8 a0 0f 00 00       	call   80125f <sys_cputs>
  8002bf:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8002c2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8002c5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8002cb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8002ce:	8b 40 04             	mov    0x4(%eax),%eax
  8002d1:	8d 50 01             	lea    0x1(%eax),%edx
  8002d4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8002d7:	89 50 04             	mov    %edx,0x4(%eax)
}
  8002da:	90                   	nop
  8002db:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8002de:	c9                   	leave  
  8002df:	c3                   	ret    

008002e0 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  8002e0:	55                   	push   %ebp
  8002e1:	89 e5                	mov    %esp,%ebp
  8002e3:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8002e9:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8002f0:	00 00 00 
	b.cnt = 0;
  8002f3:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8002fa:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  8002fd:	ff 75 0c             	pushl  0xc(%ebp)
  800300:	ff 75 08             	pushl  0x8(%ebp)
  800303:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800309:	50                   	push   %eax
  80030a:	68 6f 02 80 00       	push   $0x80026f
  80030f:	e8 5a 02 00 00       	call   80056e <vprintfmt>
  800314:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName, curTextClr);
  800317:	8b 15 18 b1 81 00    	mov    0x81b118,%edx
  80031d:	a0 44 30 80 00       	mov    0x803044,%al
  800322:	0f b6 c0             	movzbl %al,%eax
  800325:	8b 8d f0 fe ff ff    	mov    -0x110(%ebp),%ecx
  80032b:	52                   	push   %edx
  80032c:	50                   	push   %eax
  80032d:	51                   	push   %ecx
  80032e:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800334:	83 c0 08             	add    $0x8,%eax
  800337:	50                   	push   %eax
  800338:	e8 22 0f 00 00       	call   80125f <sys_cputs>
  80033d:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800340:	c6 05 44 30 80 00 00 	movb   $0x0,0x803044
	return b.cnt;
  800347:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  80034d:	c9                   	leave  
  80034e:	c3                   	ret    

0080034f <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  80034f:	55                   	push   %ebp
  800350:	89 e5                	mov    %esp,%ebp
  800352:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800355:	c6 05 44 30 80 00 01 	movb   $0x1,0x803044
	va_start(ap, fmt);
  80035c:	8d 45 0c             	lea    0xc(%ebp),%eax
  80035f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800362:	8b 45 08             	mov    0x8(%ebp),%eax
  800365:	83 ec 08             	sub    $0x8,%esp
  800368:	ff 75 f4             	pushl  -0xc(%ebp)
  80036b:	50                   	push   %eax
  80036c:	e8 6f ff ff ff       	call   8002e0 <vcprintf>
  800371:	83 c4 10             	add    $0x10,%esp
  800374:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800377:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80037a:	c9                   	leave  
  80037b:	c3                   	ret    

0080037c <cprintf_colored>:

// *************** This text coloring feature is implemented by *************
// ********** Abd-Alrahman Zedan From Team Frozen-Bytes - FCIS'24-25 ********
int cprintf_colored(int textClr, const char *fmt, ...) {
  80037c:	55                   	push   %ebp
  80037d:	89 e5                	mov    %esp,%ebp
  80037f:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800382:	c6 05 44 30 80 00 01 	movb   $0x1,0x803044
	curTextClr = (textClr << 8) ; //set text color by the given value
  800389:	8b 45 08             	mov    0x8(%ebp),%eax
  80038c:	c1 e0 08             	shl    $0x8,%eax
  80038f:	a3 18 b1 81 00       	mov    %eax,0x81b118
	va_start(ap, fmt);
  800394:	8d 45 0c             	lea    0xc(%ebp),%eax
  800397:	83 c0 04             	add    $0x4,%eax
  80039a:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  80039d:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003a0:	83 ec 08             	sub    $0x8,%esp
  8003a3:	ff 75 f4             	pushl  -0xc(%ebp)
  8003a6:	50                   	push   %eax
  8003a7:	e8 34 ff ff ff       	call   8002e0 <vcprintf>
  8003ac:	83 c4 10             	add    $0x10,%esp
  8003af:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);
	curTextClr = TEXT_DEFAULT_CLR; //restore default color
  8003b2:	c7 05 18 b1 81 00 00 	movl   $0x700,0x81b118
  8003b9:	07 00 00 

	return cnt;
  8003bc:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8003bf:	c9                   	leave  
  8003c0:	c3                   	ret    

008003c1 <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  8003c1:	55                   	push   %ebp
  8003c2:	89 e5                	mov    %esp,%ebp
  8003c4:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  8003c7:	e8 d7 0e 00 00       	call   8012a3 <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  8003cc:	8d 45 0c             	lea    0xc(%ebp),%eax
  8003cf:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  8003d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8003d5:	83 ec 08             	sub    $0x8,%esp
  8003d8:	ff 75 f4             	pushl  -0xc(%ebp)
  8003db:	50                   	push   %eax
  8003dc:	e8 ff fe ff ff       	call   8002e0 <vcprintf>
  8003e1:	83 c4 10             	add    $0x10,%esp
  8003e4:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  8003e7:	e8 d1 0e 00 00       	call   8012bd <sys_unlock_cons>
	return cnt;
  8003ec:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8003ef:	c9                   	leave  
  8003f0:	c3                   	ret    

008003f1 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8003f1:	55                   	push   %ebp
  8003f2:	89 e5                	mov    %esp,%ebp
  8003f4:	53                   	push   %ebx
  8003f5:	83 ec 14             	sub    $0x14,%esp
  8003f8:	8b 45 10             	mov    0x10(%ebp),%eax
  8003fb:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8003fe:	8b 45 14             	mov    0x14(%ebp),%eax
  800401:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800404:	8b 45 18             	mov    0x18(%ebp),%eax
  800407:	ba 00 00 00 00       	mov    $0x0,%edx
  80040c:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  80040f:	77 55                	ja     800466 <printnum+0x75>
  800411:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800414:	72 05                	jb     80041b <printnum+0x2a>
  800416:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800419:	77 4b                	ja     800466 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  80041b:	8b 45 1c             	mov    0x1c(%ebp),%eax
  80041e:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800421:	8b 45 18             	mov    0x18(%ebp),%eax
  800424:	ba 00 00 00 00       	mov    $0x0,%edx
  800429:	52                   	push   %edx
  80042a:	50                   	push   %eax
  80042b:	ff 75 f4             	pushl  -0xc(%ebp)
  80042e:	ff 75 f0             	pushl  -0x10(%ebp)
  800431:	e8 96 15 00 00       	call   8019cc <__udivdi3>
  800436:	83 c4 10             	add    $0x10,%esp
  800439:	83 ec 04             	sub    $0x4,%esp
  80043c:	ff 75 20             	pushl  0x20(%ebp)
  80043f:	53                   	push   %ebx
  800440:	ff 75 18             	pushl  0x18(%ebp)
  800443:	52                   	push   %edx
  800444:	50                   	push   %eax
  800445:	ff 75 0c             	pushl  0xc(%ebp)
  800448:	ff 75 08             	pushl  0x8(%ebp)
  80044b:	e8 a1 ff ff ff       	call   8003f1 <printnum>
  800450:	83 c4 20             	add    $0x20,%esp
  800453:	eb 1a                	jmp    80046f <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800455:	83 ec 08             	sub    $0x8,%esp
  800458:	ff 75 0c             	pushl  0xc(%ebp)
  80045b:	ff 75 20             	pushl  0x20(%ebp)
  80045e:	8b 45 08             	mov    0x8(%ebp),%eax
  800461:	ff d0                	call   *%eax
  800463:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800466:	ff 4d 1c             	decl   0x1c(%ebp)
  800469:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  80046d:	7f e6                	jg     800455 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80046f:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800472:	bb 00 00 00 00       	mov    $0x0,%ebx
  800477:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80047a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80047d:	53                   	push   %ebx
  80047e:	51                   	push   %ecx
  80047f:	52                   	push   %edx
  800480:	50                   	push   %eax
  800481:	e8 56 16 00 00       	call   801adc <__umoddi3>
  800486:	83 c4 10             	add    $0x10,%esp
  800489:	05 14 20 80 00       	add    $0x802014,%eax
  80048e:	8a 00                	mov    (%eax),%al
  800490:	0f be c0             	movsbl %al,%eax
  800493:	83 ec 08             	sub    $0x8,%esp
  800496:	ff 75 0c             	pushl  0xc(%ebp)
  800499:	50                   	push   %eax
  80049a:	8b 45 08             	mov    0x8(%ebp),%eax
  80049d:	ff d0                	call   *%eax
  80049f:	83 c4 10             	add    $0x10,%esp
}
  8004a2:	90                   	nop
  8004a3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8004a6:	c9                   	leave  
  8004a7:	c3                   	ret    

008004a8 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8004a8:	55                   	push   %ebp
  8004a9:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8004ab:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8004af:	7e 1c                	jle    8004cd <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  8004b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8004b4:	8b 00                	mov    (%eax),%eax
  8004b6:	8d 50 08             	lea    0x8(%eax),%edx
  8004b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8004bc:	89 10                	mov    %edx,(%eax)
  8004be:	8b 45 08             	mov    0x8(%ebp),%eax
  8004c1:	8b 00                	mov    (%eax),%eax
  8004c3:	83 e8 08             	sub    $0x8,%eax
  8004c6:	8b 50 04             	mov    0x4(%eax),%edx
  8004c9:	8b 00                	mov    (%eax),%eax
  8004cb:	eb 40                	jmp    80050d <getuint+0x65>
	else if (lflag)
  8004cd:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8004d1:	74 1e                	je     8004f1 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  8004d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8004d6:	8b 00                	mov    (%eax),%eax
  8004d8:	8d 50 04             	lea    0x4(%eax),%edx
  8004db:	8b 45 08             	mov    0x8(%ebp),%eax
  8004de:	89 10                	mov    %edx,(%eax)
  8004e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8004e3:	8b 00                	mov    (%eax),%eax
  8004e5:	83 e8 04             	sub    $0x4,%eax
  8004e8:	8b 00                	mov    (%eax),%eax
  8004ea:	ba 00 00 00 00       	mov    $0x0,%edx
  8004ef:	eb 1c                	jmp    80050d <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  8004f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8004f4:	8b 00                	mov    (%eax),%eax
  8004f6:	8d 50 04             	lea    0x4(%eax),%edx
  8004f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8004fc:	89 10                	mov    %edx,(%eax)
  8004fe:	8b 45 08             	mov    0x8(%ebp),%eax
  800501:	8b 00                	mov    (%eax),%eax
  800503:	83 e8 04             	sub    $0x4,%eax
  800506:	8b 00                	mov    (%eax),%eax
  800508:	ba 00 00 00 00       	mov    $0x0,%edx
}
  80050d:	5d                   	pop    %ebp
  80050e:	c3                   	ret    

0080050f <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  80050f:	55                   	push   %ebp
  800510:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800512:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800516:	7e 1c                	jle    800534 <getint+0x25>
		return va_arg(*ap, long long);
  800518:	8b 45 08             	mov    0x8(%ebp),%eax
  80051b:	8b 00                	mov    (%eax),%eax
  80051d:	8d 50 08             	lea    0x8(%eax),%edx
  800520:	8b 45 08             	mov    0x8(%ebp),%eax
  800523:	89 10                	mov    %edx,(%eax)
  800525:	8b 45 08             	mov    0x8(%ebp),%eax
  800528:	8b 00                	mov    (%eax),%eax
  80052a:	83 e8 08             	sub    $0x8,%eax
  80052d:	8b 50 04             	mov    0x4(%eax),%edx
  800530:	8b 00                	mov    (%eax),%eax
  800532:	eb 38                	jmp    80056c <getint+0x5d>
	else if (lflag)
  800534:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800538:	74 1a                	je     800554 <getint+0x45>
		return va_arg(*ap, long);
  80053a:	8b 45 08             	mov    0x8(%ebp),%eax
  80053d:	8b 00                	mov    (%eax),%eax
  80053f:	8d 50 04             	lea    0x4(%eax),%edx
  800542:	8b 45 08             	mov    0x8(%ebp),%eax
  800545:	89 10                	mov    %edx,(%eax)
  800547:	8b 45 08             	mov    0x8(%ebp),%eax
  80054a:	8b 00                	mov    (%eax),%eax
  80054c:	83 e8 04             	sub    $0x4,%eax
  80054f:	8b 00                	mov    (%eax),%eax
  800551:	99                   	cltd   
  800552:	eb 18                	jmp    80056c <getint+0x5d>
	else
		return va_arg(*ap, int);
  800554:	8b 45 08             	mov    0x8(%ebp),%eax
  800557:	8b 00                	mov    (%eax),%eax
  800559:	8d 50 04             	lea    0x4(%eax),%edx
  80055c:	8b 45 08             	mov    0x8(%ebp),%eax
  80055f:	89 10                	mov    %edx,(%eax)
  800561:	8b 45 08             	mov    0x8(%ebp),%eax
  800564:	8b 00                	mov    (%eax),%eax
  800566:	83 e8 04             	sub    $0x4,%eax
  800569:	8b 00                	mov    (%eax),%eax
  80056b:	99                   	cltd   
}
  80056c:	5d                   	pop    %ebp
  80056d:	c3                   	ret    

0080056e <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  80056e:	55                   	push   %ebp
  80056f:	89 e5                	mov    %esp,%ebp
  800571:	56                   	push   %esi
  800572:	53                   	push   %ebx
  800573:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800576:	eb 17                	jmp    80058f <vprintfmt+0x21>
			if (ch == '\0')
  800578:	85 db                	test   %ebx,%ebx
  80057a:	0f 84 c1 03 00 00    	je     800941 <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  800580:	83 ec 08             	sub    $0x8,%esp
  800583:	ff 75 0c             	pushl  0xc(%ebp)
  800586:	53                   	push   %ebx
  800587:	8b 45 08             	mov    0x8(%ebp),%eax
  80058a:	ff d0                	call   *%eax
  80058c:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80058f:	8b 45 10             	mov    0x10(%ebp),%eax
  800592:	8d 50 01             	lea    0x1(%eax),%edx
  800595:	89 55 10             	mov    %edx,0x10(%ebp)
  800598:	8a 00                	mov    (%eax),%al
  80059a:	0f b6 d8             	movzbl %al,%ebx
  80059d:	83 fb 25             	cmp    $0x25,%ebx
  8005a0:	75 d6                	jne    800578 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  8005a2:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  8005a6:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  8005ad:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8005b4:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  8005bb:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8005c2:	8b 45 10             	mov    0x10(%ebp),%eax
  8005c5:	8d 50 01             	lea    0x1(%eax),%edx
  8005c8:	89 55 10             	mov    %edx,0x10(%ebp)
  8005cb:	8a 00                	mov    (%eax),%al
  8005cd:	0f b6 d8             	movzbl %al,%ebx
  8005d0:	8d 43 dd             	lea    -0x23(%ebx),%eax
  8005d3:	83 f8 5b             	cmp    $0x5b,%eax
  8005d6:	0f 87 3d 03 00 00    	ja     800919 <vprintfmt+0x3ab>
  8005dc:	8b 04 85 38 20 80 00 	mov    0x802038(,%eax,4),%eax
  8005e3:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  8005e5:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  8005e9:	eb d7                	jmp    8005c2 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8005eb:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  8005ef:	eb d1                	jmp    8005c2 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8005f1:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  8005f8:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8005fb:	89 d0                	mov    %edx,%eax
  8005fd:	c1 e0 02             	shl    $0x2,%eax
  800600:	01 d0                	add    %edx,%eax
  800602:	01 c0                	add    %eax,%eax
  800604:	01 d8                	add    %ebx,%eax
  800606:	83 e8 30             	sub    $0x30,%eax
  800609:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  80060c:	8b 45 10             	mov    0x10(%ebp),%eax
  80060f:	8a 00                	mov    (%eax),%al
  800611:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800614:	83 fb 2f             	cmp    $0x2f,%ebx
  800617:	7e 3e                	jle    800657 <vprintfmt+0xe9>
  800619:	83 fb 39             	cmp    $0x39,%ebx
  80061c:	7f 39                	jg     800657 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  80061e:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800621:	eb d5                	jmp    8005f8 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800623:	8b 45 14             	mov    0x14(%ebp),%eax
  800626:	83 c0 04             	add    $0x4,%eax
  800629:	89 45 14             	mov    %eax,0x14(%ebp)
  80062c:	8b 45 14             	mov    0x14(%ebp),%eax
  80062f:	83 e8 04             	sub    $0x4,%eax
  800632:	8b 00                	mov    (%eax),%eax
  800634:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800637:	eb 1f                	jmp    800658 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800639:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80063d:	79 83                	jns    8005c2 <vprintfmt+0x54>
				width = 0;
  80063f:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800646:	e9 77 ff ff ff       	jmp    8005c2 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  80064b:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800652:	e9 6b ff ff ff       	jmp    8005c2 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800657:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800658:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80065c:	0f 89 60 ff ff ff    	jns    8005c2 <vprintfmt+0x54>
				width = precision, precision = -1;
  800662:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800665:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800668:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  80066f:	e9 4e ff ff ff       	jmp    8005c2 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800674:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800677:	e9 46 ff ff ff       	jmp    8005c2 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  80067c:	8b 45 14             	mov    0x14(%ebp),%eax
  80067f:	83 c0 04             	add    $0x4,%eax
  800682:	89 45 14             	mov    %eax,0x14(%ebp)
  800685:	8b 45 14             	mov    0x14(%ebp),%eax
  800688:	83 e8 04             	sub    $0x4,%eax
  80068b:	8b 00                	mov    (%eax),%eax
  80068d:	83 ec 08             	sub    $0x8,%esp
  800690:	ff 75 0c             	pushl  0xc(%ebp)
  800693:	50                   	push   %eax
  800694:	8b 45 08             	mov    0x8(%ebp),%eax
  800697:	ff d0                	call   *%eax
  800699:	83 c4 10             	add    $0x10,%esp
			break;
  80069c:	e9 9b 02 00 00       	jmp    80093c <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  8006a1:	8b 45 14             	mov    0x14(%ebp),%eax
  8006a4:	83 c0 04             	add    $0x4,%eax
  8006a7:	89 45 14             	mov    %eax,0x14(%ebp)
  8006aa:	8b 45 14             	mov    0x14(%ebp),%eax
  8006ad:	83 e8 04             	sub    $0x4,%eax
  8006b0:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  8006b2:	85 db                	test   %ebx,%ebx
  8006b4:	79 02                	jns    8006b8 <vprintfmt+0x14a>
				err = -err;
  8006b6:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  8006b8:	83 fb 64             	cmp    $0x64,%ebx
  8006bb:	7f 0b                	jg     8006c8 <vprintfmt+0x15a>
  8006bd:	8b 34 9d 80 1e 80 00 	mov    0x801e80(,%ebx,4),%esi
  8006c4:	85 f6                	test   %esi,%esi
  8006c6:	75 19                	jne    8006e1 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  8006c8:	53                   	push   %ebx
  8006c9:	68 25 20 80 00       	push   $0x802025
  8006ce:	ff 75 0c             	pushl  0xc(%ebp)
  8006d1:	ff 75 08             	pushl  0x8(%ebp)
  8006d4:	e8 70 02 00 00       	call   800949 <printfmt>
  8006d9:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  8006dc:	e9 5b 02 00 00       	jmp    80093c <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  8006e1:	56                   	push   %esi
  8006e2:	68 2e 20 80 00       	push   $0x80202e
  8006e7:	ff 75 0c             	pushl  0xc(%ebp)
  8006ea:	ff 75 08             	pushl  0x8(%ebp)
  8006ed:	e8 57 02 00 00       	call   800949 <printfmt>
  8006f2:	83 c4 10             	add    $0x10,%esp
			break;
  8006f5:	e9 42 02 00 00       	jmp    80093c <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  8006fa:	8b 45 14             	mov    0x14(%ebp),%eax
  8006fd:	83 c0 04             	add    $0x4,%eax
  800700:	89 45 14             	mov    %eax,0x14(%ebp)
  800703:	8b 45 14             	mov    0x14(%ebp),%eax
  800706:	83 e8 04             	sub    $0x4,%eax
  800709:	8b 30                	mov    (%eax),%esi
  80070b:	85 f6                	test   %esi,%esi
  80070d:	75 05                	jne    800714 <vprintfmt+0x1a6>
				p = "(null)";
  80070f:	be 31 20 80 00       	mov    $0x802031,%esi
			if (width > 0 && padc != '-')
  800714:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800718:	7e 6d                	jle    800787 <vprintfmt+0x219>
  80071a:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  80071e:	74 67                	je     800787 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800720:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800723:	83 ec 08             	sub    $0x8,%esp
  800726:	50                   	push   %eax
  800727:	56                   	push   %esi
  800728:	e8 1e 03 00 00       	call   800a4b <strnlen>
  80072d:	83 c4 10             	add    $0x10,%esp
  800730:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800733:	eb 16                	jmp    80074b <vprintfmt+0x1dd>
					putch(padc, putdat);
  800735:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800739:	83 ec 08             	sub    $0x8,%esp
  80073c:	ff 75 0c             	pushl  0xc(%ebp)
  80073f:	50                   	push   %eax
  800740:	8b 45 08             	mov    0x8(%ebp),%eax
  800743:	ff d0                	call   *%eax
  800745:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800748:	ff 4d e4             	decl   -0x1c(%ebp)
  80074b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80074f:	7f e4                	jg     800735 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800751:	eb 34                	jmp    800787 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800753:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800757:	74 1c                	je     800775 <vprintfmt+0x207>
  800759:	83 fb 1f             	cmp    $0x1f,%ebx
  80075c:	7e 05                	jle    800763 <vprintfmt+0x1f5>
  80075e:	83 fb 7e             	cmp    $0x7e,%ebx
  800761:	7e 12                	jle    800775 <vprintfmt+0x207>
					putch('?', putdat);
  800763:	83 ec 08             	sub    $0x8,%esp
  800766:	ff 75 0c             	pushl  0xc(%ebp)
  800769:	6a 3f                	push   $0x3f
  80076b:	8b 45 08             	mov    0x8(%ebp),%eax
  80076e:	ff d0                	call   *%eax
  800770:	83 c4 10             	add    $0x10,%esp
  800773:	eb 0f                	jmp    800784 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800775:	83 ec 08             	sub    $0x8,%esp
  800778:	ff 75 0c             	pushl  0xc(%ebp)
  80077b:	53                   	push   %ebx
  80077c:	8b 45 08             	mov    0x8(%ebp),%eax
  80077f:	ff d0                	call   *%eax
  800781:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800784:	ff 4d e4             	decl   -0x1c(%ebp)
  800787:	89 f0                	mov    %esi,%eax
  800789:	8d 70 01             	lea    0x1(%eax),%esi
  80078c:	8a 00                	mov    (%eax),%al
  80078e:	0f be d8             	movsbl %al,%ebx
  800791:	85 db                	test   %ebx,%ebx
  800793:	74 24                	je     8007b9 <vprintfmt+0x24b>
  800795:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800799:	78 b8                	js     800753 <vprintfmt+0x1e5>
  80079b:	ff 4d e0             	decl   -0x20(%ebp)
  80079e:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8007a2:	79 af                	jns    800753 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8007a4:	eb 13                	jmp    8007b9 <vprintfmt+0x24b>
				putch(' ', putdat);
  8007a6:	83 ec 08             	sub    $0x8,%esp
  8007a9:	ff 75 0c             	pushl  0xc(%ebp)
  8007ac:	6a 20                	push   $0x20
  8007ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8007b1:	ff d0                	call   *%eax
  8007b3:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8007b6:	ff 4d e4             	decl   -0x1c(%ebp)
  8007b9:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8007bd:	7f e7                	jg     8007a6 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  8007bf:	e9 78 01 00 00       	jmp    80093c <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  8007c4:	83 ec 08             	sub    $0x8,%esp
  8007c7:	ff 75 e8             	pushl  -0x18(%ebp)
  8007ca:	8d 45 14             	lea    0x14(%ebp),%eax
  8007cd:	50                   	push   %eax
  8007ce:	e8 3c fd ff ff       	call   80050f <getint>
  8007d3:	83 c4 10             	add    $0x10,%esp
  8007d6:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8007d9:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  8007dc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8007df:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8007e2:	85 d2                	test   %edx,%edx
  8007e4:	79 23                	jns    800809 <vprintfmt+0x29b>
				putch('-', putdat);
  8007e6:	83 ec 08             	sub    $0x8,%esp
  8007e9:	ff 75 0c             	pushl  0xc(%ebp)
  8007ec:	6a 2d                	push   $0x2d
  8007ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8007f1:	ff d0                	call   *%eax
  8007f3:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  8007f6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8007f9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8007fc:	f7 d8                	neg    %eax
  8007fe:	83 d2 00             	adc    $0x0,%edx
  800801:	f7 da                	neg    %edx
  800803:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800806:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800809:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800810:	e9 bc 00 00 00       	jmp    8008d1 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800815:	83 ec 08             	sub    $0x8,%esp
  800818:	ff 75 e8             	pushl  -0x18(%ebp)
  80081b:	8d 45 14             	lea    0x14(%ebp),%eax
  80081e:	50                   	push   %eax
  80081f:	e8 84 fc ff ff       	call   8004a8 <getuint>
  800824:	83 c4 10             	add    $0x10,%esp
  800827:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80082a:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  80082d:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800834:	e9 98 00 00 00       	jmp    8008d1 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800839:	83 ec 08             	sub    $0x8,%esp
  80083c:	ff 75 0c             	pushl  0xc(%ebp)
  80083f:	6a 58                	push   $0x58
  800841:	8b 45 08             	mov    0x8(%ebp),%eax
  800844:	ff d0                	call   *%eax
  800846:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800849:	83 ec 08             	sub    $0x8,%esp
  80084c:	ff 75 0c             	pushl  0xc(%ebp)
  80084f:	6a 58                	push   $0x58
  800851:	8b 45 08             	mov    0x8(%ebp),%eax
  800854:	ff d0                	call   *%eax
  800856:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800859:	83 ec 08             	sub    $0x8,%esp
  80085c:	ff 75 0c             	pushl  0xc(%ebp)
  80085f:	6a 58                	push   $0x58
  800861:	8b 45 08             	mov    0x8(%ebp),%eax
  800864:	ff d0                	call   *%eax
  800866:	83 c4 10             	add    $0x10,%esp
			break;
  800869:	e9 ce 00 00 00       	jmp    80093c <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  80086e:	83 ec 08             	sub    $0x8,%esp
  800871:	ff 75 0c             	pushl  0xc(%ebp)
  800874:	6a 30                	push   $0x30
  800876:	8b 45 08             	mov    0x8(%ebp),%eax
  800879:	ff d0                	call   *%eax
  80087b:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  80087e:	83 ec 08             	sub    $0x8,%esp
  800881:	ff 75 0c             	pushl  0xc(%ebp)
  800884:	6a 78                	push   $0x78
  800886:	8b 45 08             	mov    0x8(%ebp),%eax
  800889:	ff d0                	call   *%eax
  80088b:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  80088e:	8b 45 14             	mov    0x14(%ebp),%eax
  800891:	83 c0 04             	add    $0x4,%eax
  800894:	89 45 14             	mov    %eax,0x14(%ebp)
  800897:	8b 45 14             	mov    0x14(%ebp),%eax
  80089a:	83 e8 04             	sub    $0x4,%eax
  80089d:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  80089f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8008a2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  8008a9:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  8008b0:	eb 1f                	jmp    8008d1 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  8008b2:	83 ec 08             	sub    $0x8,%esp
  8008b5:	ff 75 e8             	pushl  -0x18(%ebp)
  8008b8:	8d 45 14             	lea    0x14(%ebp),%eax
  8008bb:	50                   	push   %eax
  8008bc:	e8 e7 fb ff ff       	call   8004a8 <getuint>
  8008c1:	83 c4 10             	add    $0x10,%esp
  8008c4:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8008c7:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  8008ca:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  8008d1:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  8008d5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8008d8:	83 ec 04             	sub    $0x4,%esp
  8008db:	52                   	push   %edx
  8008dc:	ff 75 e4             	pushl  -0x1c(%ebp)
  8008df:	50                   	push   %eax
  8008e0:	ff 75 f4             	pushl  -0xc(%ebp)
  8008e3:	ff 75 f0             	pushl  -0x10(%ebp)
  8008e6:	ff 75 0c             	pushl  0xc(%ebp)
  8008e9:	ff 75 08             	pushl  0x8(%ebp)
  8008ec:	e8 00 fb ff ff       	call   8003f1 <printnum>
  8008f1:	83 c4 20             	add    $0x20,%esp
			break;
  8008f4:	eb 46                	jmp    80093c <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  8008f6:	83 ec 08             	sub    $0x8,%esp
  8008f9:	ff 75 0c             	pushl  0xc(%ebp)
  8008fc:	53                   	push   %ebx
  8008fd:	8b 45 08             	mov    0x8(%ebp),%eax
  800900:	ff d0                	call   *%eax
  800902:	83 c4 10             	add    $0x10,%esp
			break;
  800905:	eb 35                	jmp    80093c <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  800907:	c6 05 44 30 80 00 00 	movb   $0x0,0x803044
			break;
  80090e:	eb 2c                	jmp    80093c <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  800910:	c6 05 44 30 80 00 01 	movb   $0x1,0x803044
			break;
  800917:	eb 23                	jmp    80093c <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800919:	83 ec 08             	sub    $0x8,%esp
  80091c:	ff 75 0c             	pushl  0xc(%ebp)
  80091f:	6a 25                	push   $0x25
  800921:	8b 45 08             	mov    0x8(%ebp),%eax
  800924:	ff d0                	call   *%eax
  800926:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800929:	ff 4d 10             	decl   0x10(%ebp)
  80092c:	eb 03                	jmp    800931 <vprintfmt+0x3c3>
  80092e:	ff 4d 10             	decl   0x10(%ebp)
  800931:	8b 45 10             	mov    0x10(%ebp),%eax
  800934:	48                   	dec    %eax
  800935:	8a 00                	mov    (%eax),%al
  800937:	3c 25                	cmp    $0x25,%al
  800939:	75 f3                	jne    80092e <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  80093b:	90                   	nop
		}
	}
  80093c:	e9 35 fc ff ff       	jmp    800576 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800941:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800942:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800945:	5b                   	pop    %ebx
  800946:	5e                   	pop    %esi
  800947:	5d                   	pop    %ebp
  800948:	c3                   	ret    

00800949 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800949:	55                   	push   %ebp
  80094a:	89 e5                	mov    %esp,%ebp
  80094c:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  80094f:	8d 45 10             	lea    0x10(%ebp),%eax
  800952:	83 c0 04             	add    $0x4,%eax
  800955:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800958:	8b 45 10             	mov    0x10(%ebp),%eax
  80095b:	ff 75 f4             	pushl  -0xc(%ebp)
  80095e:	50                   	push   %eax
  80095f:	ff 75 0c             	pushl  0xc(%ebp)
  800962:	ff 75 08             	pushl  0x8(%ebp)
  800965:	e8 04 fc ff ff       	call   80056e <vprintfmt>
  80096a:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  80096d:	90                   	nop
  80096e:	c9                   	leave  
  80096f:	c3                   	ret    

00800970 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800970:	55                   	push   %ebp
  800971:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800973:	8b 45 0c             	mov    0xc(%ebp),%eax
  800976:	8b 40 08             	mov    0x8(%eax),%eax
  800979:	8d 50 01             	lea    0x1(%eax),%edx
  80097c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80097f:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800982:	8b 45 0c             	mov    0xc(%ebp),%eax
  800985:	8b 10                	mov    (%eax),%edx
  800987:	8b 45 0c             	mov    0xc(%ebp),%eax
  80098a:	8b 40 04             	mov    0x4(%eax),%eax
  80098d:	39 c2                	cmp    %eax,%edx
  80098f:	73 12                	jae    8009a3 <sprintputch+0x33>
		*b->buf++ = ch;
  800991:	8b 45 0c             	mov    0xc(%ebp),%eax
  800994:	8b 00                	mov    (%eax),%eax
  800996:	8d 48 01             	lea    0x1(%eax),%ecx
  800999:	8b 55 0c             	mov    0xc(%ebp),%edx
  80099c:	89 0a                	mov    %ecx,(%edx)
  80099e:	8b 55 08             	mov    0x8(%ebp),%edx
  8009a1:	88 10                	mov    %dl,(%eax)
}
  8009a3:	90                   	nop
  8009a4:	5d                   	pop    %ebp
  8009a5:	c3                   	ret    

008009a6 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8009a6:	55                   	push   %ebp
  8009a7:	89 e5                	mov    %esp,%ebp
  8009a9:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  8009ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8009af:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8009b2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009b5:	8d 50 ff             	lea    -0x1(%eax),%edx
  8009b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8009bb:	01 d0                	add    %edx,%eax
  8009bd:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8009c0:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  8009c7:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8009cb:	74 06                	je     8009d3 <vsnprintf+0x2d>
  8009cd:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8009d1:	7f 07                	jg     8009da <vsnprintf+0x34>
		return -E_INVAL;
  8009d3:	b8 03 00 00 00       	mov    $0x3,%eax
  8009d8:	eb 20                	jmp    8009fa <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8009da:	ff 75 14             	pushl  0x14(%ebp)
  8009dd:	ff 75 10             	pushl  0x10(%ebp)
  8009e0:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8009e3:	50                   	push   %eax
  8009e4:	68 70 09 80 00       	push   $0x800970
  8009e9:	e8 80 fb ff ff       	call   80056e <vprintfmt>
  8009ee:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  8009f1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8009f4:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8009f7:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  8009fa:	c9                   	leave  
  8009fb:	c3                   	ret    

008009fc <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8009fc:	55                   	push   %ebp
  8009fd:	89 e5                	mov    %esp,%ebp
  8009ff:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800a02:	8d 45 10             	lea    0x10(%ebp),%eax
  800a05:	83 c0 04             	add    $0x4,%eax
  800a08:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800a0b:	8b 45 10             	mov    0x10(%ebp),%eax
  800a0e:	ff 75 f4             	pushl  -0xc(%ebp)
  800a11:	50                   	push   %eax
  800a12:	ff 75 0c             	pushl  0xc(%ebp)
  800a15:	ff 75 08             	pushl  0x8(%ebp)
  800a18:	e8 89 ff ff ff       	call   8009a6 <vsnprintf>
  800a1d:	83 c4 10             	add    $0x10,%esp
  800a20:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800a23:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800a26:	c9                   	leave  
  800a27:	c3                   	ret    

00800a28 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800a28:	55                   	push   %ebp
  800a29:	89 e5                	mov    %esp,%ebp
  800a2b:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800a2e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800a35:	eb 06                	jmp    800a3d <strlen+0x15>
		n++;
  800a37:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800a3a:	ff 45 08             	incl   0x8(%ebp)
  800a3d:	8b 45 08             	mov    0x8(%ebp),%eax
  800a40:	8a 00                	mov    (%eax),%al
  800a42:	84 c0                	test   %al,%al
  800a44:	75 f1                	jne    800a37 <strlen+0xf>
		n++;
	return n;
  800a46:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800a49:	c9                   	leave  
  800a4a:	c3                   	ret    

00800a4b <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800a4b:	55                   	push   %ebp
  800a4c:	89 e5                	mov    %esp,%ebp
  800a4e:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800a51:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800a58:	eb 09                	jmp    800a63 <strnlen+0x18>
		n++;
  800a5a:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800a5d:	ff 45 08             	incl   0x8(%ebp)
  800a60:	ff 4d 0c             	decl   0xc(%ebp)
  800a63:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800a67:	74 09                	je     800a72 <strnlen+0x27>
  800a69:	8b 45 08             	mov    0x8(%ebp),%eax
  800a6c:	8a 00                	mov    (%eax),%al
  800a6e:	84 c0                	test   %al,%al
  800a70:	75 e8                	jne    800a5a <strnlen+0xf>
		n++;
	return n;
  800a72:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800a75:	c9                   	leave  
  800a76:	c3                   	ret    

00800a77 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800a77:	55                   	push   %ebp
  800a78:	89 e5                	mov    %esp,%ebp
  800a7a:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800a7d:	8b 45 08             	mov    0x8(%ebp),%eax
  800a80:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800a83:	90                   	nop
  800a84:	8b 45 08             	mov    0x8(%ebp),%eax
  800a87:	8d 50 01             	lea    0x1(%eax),%edx
  800a8a:	89 55 08             	mov    %edx,0x8(%ebp)
  800a8d:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a90:	8d 4a 01             	lea    0x1(%edx),%ecx
  800a93:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800a96:	8a 12                	mov    (%edx),%dl
  800a98:	88 10                	mov    %dl,(%eax)
  800a9a:	8a 00                	mov    (%eax),%al
  800a9c:	84 c0                	test   %al,%al
  800a9e:	75 e4                	jne    800a84 <strcpy+0xd>
		/* do nothing */;
	return ret;
  800aa0:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800aa3:	c9                   	leave  
  800aa4:	c3                   	ret    

00800aa5 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800aa5:	55                   	push   %ebp
  800aa6:	89 e5                	mov    %esp,%ebp
  800aa8:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800aab:	8b 45 08             	mov    0x8(%ebp),%eax
  800aae:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800ab1:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800ab8:	eb 1f                	jmp    800ad9 <strncpy+0x34>
		*dst++ = *src;
  800aba:	8b 45 08             	mov    0x8(%ebp),%eax
  800abd:	8d 50 01             	lea    0x1(%eax),%edx
  800ac0:	89 55 08             	mov    %edx,0x8(%ebp)
  800ac3:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ac6:	8a 12                	mov    (%edx),%dl
  800ac8:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800aca:	8b 45 0c             	mov    0xc(%ebp),%eax
  800acd:	8a 00                	mov    (%eax),%al
  800acf:	84 c0                	test   %al,%al
  800ad1:	74 03                	je     800ad6 <strncpy+0x31>
			src++;
  800ad3:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800ad6:	ff 45 fc             	incl   -0x4(%ebp)
  800ad9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800adc:	3b 45 10             	cmp    0x10(%ebp),%eax
  800adf:	72 d9                	jb     800aba <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800ae1:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800ae4:	c9                   	leave  
  800ae5:	c3                   	ret    

00800ae6 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800ae6:	55                   	push   %ebp
  800ae7:	89 e5                	mov    %esp,%ebp
  800ae9:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800aec:	8b 45 08             	mov    0x8(%ebp),%eax
  800aef:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800af2:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800af6:	74 30                	je     800b28 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800af8:	eb 16                	jmp    800b10 <strlcpy+0x2a>
			*dst++ = *src++;
  800afa:	8b 45 08             	mov    0x8(%ebp),%eax
  800afd:	8d 50 01             	lea    0x1(%eax),%edx
  800b00:	89 55 08             	mov    %edx,0x8(%ebp)
  800b03:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b06:	8d 4a 01             	lea    0x1(%edx),%ecx
  800b09:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800b0c:	8a 12                	mov    (%edx),%dl
  800b0e:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800b10:	ff 4d 10             	decl   0x10(%ebp)
  800b13:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800b17:	74 09                	je     800b22 <strlcpy+0x3c>
  800b19:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b1c:	8a 00                	mov    (%eax),%al
  800b1e:	84 c0                	test   %al,%al
  800b20:	75 d8                	jne    800afa <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800b22:	8b 45 08             	mov    0x8(%ebp),%eax
  800b25:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800b28:	8b 55 08             	mov    0x8(%ebp),%edx
  800b2b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800b2e:	29 c2                	sub    %eax,%edx
  800b30:	89 d0                	mov    %edx,%eax
}
  800b32:	c9                   	leave  
  800b33:	c3                   	ret    

00800b34 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800b34:	55                   	push   %ebp
  800b35:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800b37:	eb 06                	jmp    800b3f <strcmp+0xb>
		p++, q++;
  800b39:	ff 45 08             	incl   0x8(%ebp)
  800b3c:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800b3f:	8b 45 08             	mov    0x8(%ebp),%eax
  800b42:	8a 00                	mov    (%eax),%al
  800b44:	84 c0                	test   %al,%al
  800b46:	74 0e                	je     800b56 <strcmp+0x22>
  800b48:	8b 45 08             	mov    0x8(%ebp),%eax
  800b4b:	8a 10                	mov    (%eax),%dl
  800b4d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b50:	8a 00                	mov    (%eax),%al
  800b52:	38 c2                	cmp    %al,%dl
  800b54:	74 e3                	je     800b39 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800b56:	8b 45 08             	mov    0x8(%ebp),%eax
  800b59:	8a 00                	mov    (%eax),%al
  800b5b:	0f b6 d0             	movzbl %al,%edx
  800b5e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b61:	8a 00                	mov    (%eax),%al
  800b63:	0f b6 c0             	movzbl %al,%eax
  800b66:	29 c2                	sub    %eax,%edx
  800b68:	89 d0                	mov    %edx,%eax
}
  800b6a:	5d                   	pop    %ebp
  800b6b:	c3                   	ret    

00800b6c <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800b6c:	55                   	push   %ebp
  800b6d:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800b6f:	eb 09                	jmp    800b7a <strncmp+0xe>
		n--, p++, q++;
  800b71:	ff 4d 10             	decl   0x10(%ebp)
  800b74:	ff 45 08             	incl   0x8(%ebp)
  800b77:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800b7a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800b7e:	74 17                	je     800b97 <strncmp+0x2b>
  800b80:	8b 45 08             	mov    0x8(%ebp),%eax
  800b83:	8a 00                	mov    (%eax),%al
  800b85:	84 c0                	test   %al,%al
  800b87:	74 0e                	je     800b97 <strncmp+0x2b>
  800b89:	8b 45 08             	mov    0x8(%ebp),%eax
  800b8c:	8a 10                	mov    (%eax),%dl
  800b8e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b91:	8a 00                	mov    (%eax),%al
  800b93:	38 c2                	cmp    %al,%dl
  800b95:	74 da                	je     800b71 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800b97:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800b9b:	75 07                	jne    800ba4 <strncmp+0x38>
		return 0;
  800b9d:	b8 00 00 00 00       	mov    $0x0,%eax
  800ba2:	eb 14                	jmp    800bb8 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800ba4:	8b 45 08             	mov    0x8(%ebp),%eax
  800ba7:	8a 00                	mov    (%eax),%al
  800ba9:	0f b6 d0             	movzbl %al,%edx
  800bac:	8b 45 0c             	mov    0xc(%ebp),%eax
  800baf:	8a 00                	mov    (%eax),%al
  800bb1:	0f b6 c0             	movzbl %al,%eax
  800bb4:	29 c2                	sub    %eax,%edx
  800bb6:	89 d0                	mov    %edx,%eax
}
  800bb8:	5d                   	pop    %ebp
  800bb9:	c3                   	ret    

00800bba <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800bba:	55                   	push   %ebp
  800bbb:	89 e5                	mov    %esp,%ebp
  800bbd:	83 ec 04             	sub    $0x4,%esp
  800bc0:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bc3:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800bc6:	eb 12                	jmp    800bda <strchr+0x20>
		if (*s == c)
  800bc8:	8b 45 08             	mov    0x8(%ebp),%eax
  800bcb:	8a 00                	mov    (%eax),%al
  800bcd:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800bd0:	75 05                	jne    800bd7 <strchr+0x1d>
			return (char *) s;
  800bd2:	8b 45 08             	mov    0x8(%ebp),%eax
  800bd5:	eb 11                	jmp    800be8 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800bd7:	ff 45 08             	incl   0x8(%ebp)
  800bda:	8b 45 08             	mov    0x8(%ebp),%eax
  800bdd:	8a 00                	mov    (%eax),%al
  800bdf:	84 c0                	test   %al,%al
  800be1:	75 e5                	jne    800bc8 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800be3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800be8:	c9                   	leave  
  800be9:	c3                   	ret    

00800bea <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800bea:	55                   	push   %ebp
  800beb:	89 e5                	mov    %esp,%ebp
  800bed:	83 ec 04             	sub    $0x4,%esp
  800bf0:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bf3:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800bf6:	eb 0d                	jmp    800c05 <strfind+0x1b>
		if (*s == c)
  800bf8:	8b 45 08             	mov    0x8(%ebp),%eax
  800bfb:	8a 00                	mov    (%eax),%al
  800bfd:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800c00:	74 0e                	je     800c10 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800c02:	ff 45 08             	incl   0x8(%ebp)
  800c05:	8b 45 08             	mov    0x8(%ebp),%eax
  800c08:	8a 00                	mov    (%eax),%al
  800c0a:	84 c0                	test   %al,%al
  800c0c:	75 ea                	jne    800bf8 <strfind+0xe>
  800c0e:	eb 01                	jmp    800c11 <strfind+0x27>
		if (*s == c)
			break;
  800c10:	90                   	nop
	return (char *) s;
  800c11:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800c14:	c9                   	leave  
  800c15:	c3                   	ret    

00800c16 <memset>:

// *************** The faster implementation of memset & memcpy is implemented by *************
// ****************** Team80 (Yahia Khaled, Malek Ahmed et al) - FCIS'24-25 *******************
void *
memset(void *v, int c, uint32 n)
{
  800c16:	55                   	push   %ebp
  800c17:	89 e5                	mov    %esp,%ebp
  800c19:	83 ec 10             	sub    $0x10,%esp
//	m = n;
//	while (--m >= 0)
//		*p++ = c;

	/*Faster Implementation*/
	uint64* p64 = (uint64*)v;
  800c1c:	8b 45 08             	mov    0x8(%ebp),%eax
  800c1f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if(n >= 8){
  800c22:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800c26:	76 63                	jbe    800c8b <memset+0x75>
		uint64 data_block = c;
  800c28:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c2b:	99                   	cltd   
  800c2c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c2f:	89 55 f4             	mov    %edx,-0xc(%ebp)
		data_block |= data_block << 8;
  800c32:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800c35:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800c38:	0f a4 c2 08          	shld   $0x8,%eax,%edx
  800c3c:	c1 e0 08             	shl    $0x8,%eax
  800c3f:	09 45 f0             	or     %eax,-0x10(%ebp)
  800c42:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 16;
  800c45:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800c48:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800c4b:	0f a4 c2 10          	shld   $0x10,%eax,%edx
  800c4f:	c1 e0 10             	shl    $0x10,%eax
  800c52:	09 45 f0             	or     %eax,-0x10(%ebp)
  800c55:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 32;
  800c58:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800c5b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800c5e:	89 c2                	mov    %eax,%edx
  800c60:	b8 00 00 00 00       	mov    $0x0,%eax
  800c65:	09 45 f0             	or     %eax,-0x10(%ebp)
  800c68:	09 55 f4             	or     %edx,-0xc(%ebp)

		while(n >= 8)
  800c6b:	eb 18                	jmp    800c85 <memset+0x6f>
			*p64++ = data_block, n -= 8;
  800c6d:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  800c70:	8d 41 08             	lea    0x8(%ecx),%eax
  800c73:	89 45 fc             	mov    %eax,-0x4(%ebp)
  800c76:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800c79:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800c7c:	89 01                	mov    %eax,(%ecx)
  800c7e:	89 51 04             	mov    %edx,0x4(%ecx)
  800c81:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
		uint64 data_block = c;
		data_block |= data_block << 8;
		data_block |= data_block << 16;
		data_block |= data_block << 32;

		while(n >= 8)
  800c85:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800c89:	77 e2                	ja     800c6d <memset+0x57>
			*p64++ = data_block, n -= 8;
	}

	if(n){
  800c8b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800c8f:	74 23                	je     800cb4 <memset+0x9e>
		uint8* p8 = (uint8*)p64;
  800c91:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800c94:	89 45 f8             	mov    %eax,-0x8(%ebp)
		while (n-- > 0)
  800c97:	eb 0e                	jmp    800ca7 <memset+0x91>
			*p8++ = (uint8)c;
  800c99:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800c9c:	8d 50 01             	lea    0x1(%eax),%edx
  800c9f:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800ca2:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ca5:	88 10                	mov    %dl,(%eax)
			*p64++ = data_block, n -= 8;
	}

	if(n){
		uint8* p8 = (uint8*)p64;
		while (n-- > 0)
  800ca7:	8b 45 10             	mov    0x10(%ebp),%eax
  800caa:	8d 50 ff             	lea    -0x1(%eax),%edx
  800cad:	89 55 10             	mov    %edx,0x10(%ebp)
  800cb0:	85 c0                	test   %eax,%eax
  800cb2:	75 e5                	jne    800c99 <memset+0x83>
			*p8++ = (uint8)c;
	}

	return v;
  800cb4:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800cb7:	c9                   	leave  
  800cb8:	c3                   	ret    

00800cb9 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800cb9:	55                   	push   %ebp
  800cba:	89 e5                	mov    %esp,%ebp
  800cbc:	83 ec 10             	sub    $0x10,%esp
	//	s = src;
	//	d = dst;
	//	while (n-- > 0)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
  800cbf:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cc2:	89 45 fc             	mov    %eax,-0x4(%ebp)
	uint64* d64 = (uint64*)dst;
  800cc5:	8b 45 08             	mov    0x8(%ebp),%eax
  800cc8:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if(n >= 8){
  800ccb:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800ccf:	76 24                	jbe    800cf5 <memcpy+0x3c>
		while(n >= 8){
  800cd1:	eb 1c                	jmp    800cef <memcpy+0x36>
			*d64 = *s64;
  800cd3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800cd6:	8b 50 04             	mov    0x4(%eax),%edx
  800cd9:	8b 00                	mov    (%eax),%eax
  800cdb:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  800cde:	89 01                	mov    %eax,(%ecx)
  800ce0:	89 51 04             	mov    %edx,0x4(%ecx)
			n -= 8;
  800ce3:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
			++s64;
  800ce7:	83 45 fc 08          	addl   $0x8,-0x4(%ebp)
			++d64;
  800ceb:	83 45 f8 08          	addl   $0x8,-0x8(%ebp)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
	uint64* d64 = (uint64*)dst;
	if(n >= 8){
		while(n >= 8){
  800cef:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800cf3:	77 de                	ja     800cd3 <memcpy+0x1a>
			++s64;
			++d64;
		}
	}

	if(n){
  800cf5:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800cf9:	74 31                	je     800d2c <memcpy+0x73>
		uint8* s8 = (uint8*)s64;
  800cfb:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800cfe:	89 45 f4             	mov    %eax,-0xc(%ebp)
		uint8* d8 = (uint8*)d64;
  800d01:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800d04:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (n-- > 0)
  800d07:	eb 16                	jmp    800d1f <memcpy+0x66>
			*d8++ = *s8++;
  800d09:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800d0c:	8d 50 01             	lea    0x1(%eax),%edx
  800d0f:	89 55 f0             	mov    %edx,-0x10(%ebp)
  800d12:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800d15:	8d 4a 01             	lea    0x1(%edx),%ecx
  800d18:	89 4d f4             	mov    %ecx,-0xc(%ebp)
  800d1b:	8a 12                	mov    (%edx),%dl
  800d1d:	88 10                	mov    %dl,(%eax)
	}

	if(n){
		uint8* s8 = (uint8*)s64;
		uint8* d8 = (uint8*)d64;
		while (n-- > 0)
  800d1f:	8b 45 10             	mov    0x10(%ebp),%eax
  800d22:	8d 50 ff             	lea    -0x1(%eax),%edx
  800d25:	89 55 10             	mov    %edx,0x10(%ebp)
  800d28:	85 c0                	test   %eax,%eax
  800d2a:	75 dd                	jne    800d09 <memcpy+0x50>
			*d8++ = *s8++;
	}
	return dst;
  800d2c:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800d2f:	c9                   	leave  
  800d30:	c3                   	ret    

00800d31 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800d31:	55                   	push   %ebp
  800d32:	89 e5                	mov    %esp,%ebp
  800d34:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800d37:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d3a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800d3d:	8b 45 08             	mov    0x8(%ebp),%eax
  800d40:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800d43:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d46:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800d49:	73 50                	jae    800d9b <memmove+0x6a>
  800d4b:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800d4e:	8b 45 10             	mov    0x10(%ebp),%eax
  800d51:	01 d0                	add    %edx,%eax
  800d53:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800d56:	76 43                	jbe    800d9b <memmove+0x6a>
		s += n;
  800d58:	8b 45 10             	mov    0x10(%ebp),%eax
  800d5b:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800d5e:	8b 45 10             	mov    0x10(%ebp),%eax
  800d61:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800d64:	eb 10                	jmp    800d76 <memmove+0x45>
			*--d = *--s;
  800d66:	ff 4d f8             	decl   -0x8(%ebp)
  800d69:	ff 4d fc             	decl   -0x4(%ebp)
  800d6c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d6f:	8a 10                	mov    (%eax),%dl
  800d71:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800d74:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800d76:	8b 45 10             	mov    0x10(%ebp),%eax
  800d79:	8d 50 ff             	lea    -0x1(%eax),%edx
  800d7c:	89 55 10             	mov    %edx,0x10(%ebp)
  800d7f:	85 c0                	test   %eax,%eax
  800d81:	75 e3                	jne    800d66 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800d83:	eb 23                	jmp    800da8 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800d85:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800d88:	8d 50 01             	lea    0x1(%eax),%edx
  800d8b:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800d8e:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800d91:	8d 4a 01             	lea    0x1(%edx),%ecx
  800d94:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800d97:	8a 12                	mov    (%edx),%dl
  800d99:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800d9b:	8b 45 10             	mov    0x10(%ebp),%eax
  800d9e:	8d 50 ff             	lea    -0x1(%eax),%edx
  800da1:	89 55 10             	mov    %edx,0x10(%ebp)
  800da4:	85 c0                	test   %eax,%eax
  800da6:	75 dd                	jne    800d85 <memmove+0x54>
			*d++ = *s++;

	return dst;
  800da8:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800dab:	c9                   	leave  
  800dac:	c3                   	ret    

00800dad <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  800dad:	55                   	push   %ebp
  800dae:	89 e5                	mov    %esp,%ebp
  800db0:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  800db3:	8b 45 08             	mov    0x8(%ebp),%eax
  800db6:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  800db9:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dbc:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800dbf:	eb 2a                	jmp    800deb <memcmp+0x3e>
		if (*s1 != *s2)
  800dc1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800dc4:	8a 10                	mov    (%eax),%dl
  800dc6:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800dc9:	8a 00                	mov    (%eax),%al
  800dcb:	38 c2                	cmp    %al,%dl
  800dcd:	74 16                	je     800de5 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  800dcf:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800dd2:	8a 00                	mov    (%eax),%al
  800dd4:	0f b6 d0             	movzbl %al,%edx
  800dd7:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800dda:	8a 00                	mov    (%eax),%al
  800ddc:	0f b6 c0             	movzbl %al,%eax
  800ddf:	29 c2                	sub    %eax,%edx
  800de1:	89 d0                	mov    %edx,%eax
  800de3:	eb 18                	jmp    800dfd <memcmp+0x50>
		s1++, s2++;
  800de5:	ff 45 fc             	incl   -0x4(%ebp)
  800de8:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  800deb:	8b 45 10             	mov    0x10(%ebp),%eax
  800dee:	8d 50 ff             	lea    -0x1(%eax),%edx
  800df1:	89 55 10             	mov    %edx,0x10(%ebp)
  800df4:	85 c0                	test   %eax,%eax
  800df6:	75 c9                	jne    800dc1 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800df8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800dfd:	c9                   	leave  
  800dfe:	c3                   	ret    

00800dff <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  800dff:	55                   	push   %ebp
  800e00:	89 e5                	mov    %esp,%ebp
  800e02:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  800e05:	8b 55 08             	mov    0x8(%ebp),%edx
  800e08:	8b 45 10             	mov    0x10(%ebp),%eax
  800e0b:	01 d0                	add    %edx,%eax
  800e0d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  800e10:	eb 15                	jmp    800e27 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  800e12:	8b 45 08             	mov    0x8(%ebp),%eax
  800e15:	8a 00                	mov    (%eax),%al
  800e17:	0f b6 d0             	movzbl %al,%edx
  800e1a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e1d:	0f b6 c0             	movzbl %al,%eax
  800e20:	39 c2                	cmp    %eax,%edx
  800e22:	74 0d                	je     800e31 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800e24:	ff 45 08             	incl   0x8(%ebp)
  800e27:	8b 45 08             	mov    0x8(%ebp),%eax
  800e2a:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  800e2d:	72 e3                	jb     800e12 <memfind+0x13>
  800e2f:	eb 01                	jmp    800e32 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  800e31:	90                   	nop
	return (void *) s;
  800e32:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e35:	c9                   	leave  
  800e36:	c3                   	ret    

00800e37 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800e37:	55                   	push   %ebp
  800e38:	89 e5                	mov    %esp,%ebp
  800e3a:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  800e3d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  800e44:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800e4b:	eb 03                	jmp    800e50 <strtol+0x19>
		s++;
  800e4d:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800e50:	8b 45 08             	mov    0x8(%ebp),%eax
  800e53:	8a 00                	mov    (%eax),%al
  800e55:	3c 20                	cmp    $0x20,%al
  800e57:	74 f4                	je     800e4d <strtol+0x16>
  800e59:	8b 45 08             	mov    0x8(%ebp),%eax
  800e5c:	8a 00                	mov    (%eax),%al
  800e5e:	3c 09                	cmp    $0x9,%al
  800e60:	74 eb                	je     800e4d <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  800e62:	8b 45 08             	mov    0x8(%ebp),%eax
  800e65:	8a 00                	mov    (%eax),%al
  800e67:	3c 2b                	cmp    $0x2b,%al
  800e69:	75 05                	jne    800e70 <strtol+0x39>
		s++;
  800e6b:	ff 45 08             	incl   0x8(%ebp)
  800e6e:	eb 13                	jmp    800e83 <strtol+0x4c>
	else if (*s == '-')
  800e70:	8b 45 08             	mov    0x8(%ebp),%eax
  800e73:	8a 00                	mov    (%eax),%al
  800e75:	3c 2d                	cmp    $0x2d,%al
  800e77:	75 0a                	jne    800e83 <strtol+0x4c>
		s++, neg = 1;
  800e79:	ff 45 08             	incl   0x8(%ebp)
  800e7c:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800e83:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e87:	74 06                	je     800e8f <strtol+0x58>
  800e89:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  800e8d:	75 20                	jne    800eaf <strtol+0x78>
  800e8f:	8b 45 08             	mov    0x8(%ebp),%eax
  800e92:	8a 00                	mov    (%eax),%al
  800e94:	3c 30                	cmp    $0x30,%al
  800e96:	75 17                	jne    800eaf <strtol+0x78>
  800e98:	8b 45 08             	mov    0x8(%ebp),%eax
  800e9b:	40                   	inc    %eax
  800e9c:	8a 00                	mov    (%eax),%al
  800e9e:	3c 78                	cmp    $0x78,%al
  800ea0:	75 0d                	jne    800eaf <strtol+0x78>
		s += 2, base = 16;
  800ea2:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  800ea6:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  800ead:	eb 28                	jmp    800ed7 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  800eaf:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800eb3:	75 15                	jne    800eca <strtol+0x93>
  800eb5:	8b 45 08             	mov    0x8(%ebp),%eax
  800eb8:	8a 00                	mov    (%eax),%al
  800eba:	3c 30                	cmp    $0x30,%al
  800ebc:	75 0c                	jne    800eca <strtol+0x93>
		s++, base = 8;
  800ebe:	ff 45 08             	incl   0x8(%ebp)
  800ec1:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  800ec8:	eb 0d                	jmp    800ed7 <strtol+0xa0>
	else if (base == 0)
  800eca:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ece:	75 07                	jne    800ed7 <strtol+0xa0>
		base = 10;
  800ed0:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800ed7:	8b 45 08             	mov    0x8(%ebp),%eax
  800eda:	8a 00                	mov    (%eax),%al
  800edc:	3c 2f                	cmp    $0x2f,%al
  800ede:	7e 19                	jle    800ef9 <strtol+0xc2>
  800ee0:	8b 45 08             	mov    0x8(%ebp),%eax
  800ee3:	8a 00                	mov    (%eax),%al
  800ee5:	3c 39                	cmp    $0x39,%al
  800ee7:	7f 10                	jg     800ef9 <strtol+0xc2>
			dig = *s - '0';
  800ee9:	8b 45 08             	mov    0x8(%ebp),%eax
  800eec:	8a 00                	mov    (%eax),%al
  800eee:	0f be c0             	movsbl %al,%eax
  800ef1:	83 e8 30             	sub    $0x30,%eax
  800ef4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800ef7:	eb 42                	jmp    800f3b <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  800ef9:	8b 45 08             	mov    0x8(%ebp),%eax
  800efc:	8a 00                	mov    (%eax),%al
  800efe:	3c 60                	cmp    $0x60,%al
  800f00:	7e 19                	jle    800f1b <strtol+0xe4>
  800f02:	8b 45 08             	mov    0x8(%ebp),%eax
  800f05:	8a 00                	mov    (%eax),%al
  800f07:	3c 7a                	cmp    $0x7a,%al
  800f09:	7f 10                	jg     800f1b <strtol+0xe4>
			dig = *s - 'a' + 10;
  800f0b:	8b 45 08             	mov    0x8(%ebp),%eax
  800f0e:	8a 00                	mov    (%eax),%al
  800f10:	0f be c0             	movsbl %al,%eax
  800f13:	83 e8 57             	sub    $0x57,%eax
  800f16:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800f19:	eb 20                	jmp    800f3b <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  800f1b:	8b 45 08             	mov    0x8(%ebp),%eax
  800f1e:	8a 00                	mov    (%eax),%al
  800f20:	3c 40                	cmp    $0x40,%al
  800f22:	7e 39                	jle    800f5d <strtol+0x126>
  800f24:	8b 45 08             	mov    0x8(%ebp),%eax
  800f27:	8a 00                	mov    (%eax),%al
  800f29:	3c 5a                	cmp    $0x5a,%al
  800f2b:	7f 30                	jg     800f5d <strtol+0x126>
			dig = *s - 'A' + 10;
  800f2d:	8b 45 08             	mov    0x8(%ebp),%eax
  800f30:	8a 00                	mov    (%eax),%al
  800f32:	0f be c0             	movsbl %al,%eax
  800f35:	83 e8 37             	sub    $0x37,%eax
  800f38:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  800f3b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800f3e:	3b 45 10             	cmp    0x10(%ebp),%eax
  800f41:	7d 19                	jge    800f5c <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  800f43:	ff 45 08             	incl   0x8(%ebp)
  800f46:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f49:	0f af 45 10          	imul   0x10(%ebp),%eax
  800f4d:	89 c2                	mov    %eax,%edx
  800f4f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800f52:	01 d0                	add    %edx,%eax
  800f54:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  800f57:	e9 7b ff ff ff       	jmp    800ed7 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  800f5c:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  800f5d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800f61:	74 08                	je     800f6b <strtol+0x134>
		*endptr = (char *) s;
  800f63:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f66:	8b 55 08             	mov    0x8(%ebp),%edx
  800f69:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  800f6b:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  800f6f:	74 07                	je     800f78 <strtol+0x141>
  800f71:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f74:	f7 d8                	neg    %eax
  800f76:	eb 03                	jmp    800f7b <strtol+0x144>
  800f78:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800f7b:	c9                   	leave  
  800f7c:	c3                   	ret    

00800f7d <ltostr>:

void
ltostr(long value, char *str)
{
  800f7d:	55                   	push   %ebp
  800f7e:	89 e5                	mov    %esp,%ebp
  800f80:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  800f83:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  800f8a:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  800f91:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800f95:	79 13                	jns    800faa <ltostr+0x2d>
	{
		neg = 1;
  800f97:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  800f9e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fa1:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  800fa4:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  800fa7:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  800faa:	8b 45 08             	mov    0x8(%ebp),%eax
  800fad:	b9 0a 00 00 00       	mov    $0xa,%ecx
  800fb2:	99                   	cltd   
  800fb3:	f7 f9                	idiv   %ecx
  800fb5:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  800fb8:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800fbb:	8d 50 01             	lea    0x1(%eax),%edx
  800fbe:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800fc1:	89 c2                	mov    %eax,%edx
  800fc3:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fc6:	01 d0                	add    %edx,%eax
  800fc8:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800fcb:	83 c2 30             	add    $0x30,%edx
  800fce:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  800fd0:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800fd3:	b8 67 66 66 66       	mov    $0x66666667,%eax
  800fd8:	f7 e9                	imul   %ecx
  800fda:	c1 fa 02             	sar    $0x2,%edx
  800fdd:	89 c8                	mov    %ecx,%eax
  800fdf:	c1 f8 1f             	sar    $0x1f,%eax
  800fe2:	29 c2                	sub    %eax,%edx
  800fe4:	89 d0                	mov    %edx,%eax
  800fe6:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  800fe9:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800fed:	75 bb                	jne    800faa <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  800fef:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  800ff6:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800ff9:	48                   	dec    %eax
  800ffa:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  800ffd:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801001:	74 3d                	je     801040 <ltostr+0xc3>
		start = 1 ;
  801003:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  80100a:	eb 34                	jmp    801040 <ltostr+0xc3>
	{
		char tmp = str[start] ;
  80100c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80100f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801012:	01 d0                	add    %edx,%eax
  801014:	8a 00                	mov    (%eax),%al
  801016:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801019:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80101c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80101f:	01 c2                	add    %eax,%edx
  801021:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801024:	8b 45 0c             	mov    0xc(%ebp),%eax
  801027:	01 c8                	add    %ecx,%eax
  801029:	8a 00                	mov    (%eax),%al
  80102b:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  80102d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801030:	8b 45 0c             	mov    0xc(%ebp),%eax
  801033:	01 c2                	add    %eax,%edx
  801035:	8a 45 eb             	mov    -0x15(%ebp),%al
  801038:	88 02                	mov    %al,(%edx)
		start++ ;
  80103a:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  80103d:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801040:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801043:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801046:	7c c4                	jl     80100c <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801048:	8b 55 f8             	mov    -0x8(%ebp),%edx
  80104b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80104e:	01 d0                	add    %edx,%eax
  801050:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801053:	90                   	nop
  801054:	c9                   	leave  
  801055:	c3                   	ret    

00801056 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  801056:	55                   	push   %ebp
  801057:	89 e5                	mov    %esp,%ebp
  801059:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  80105c:	ff 75 08             	pushl  0x8(%ebp)
  80105f:	e8 c4 f9 ff ff       	call   800a28 <strlen>
  801064:	83 c4 04             	add    $0x4,%esp
  801067:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  80106a:	ff 75 0c             	pushl  0xc(%ebp)
  80106d:	e8 b6 f9 ff ff       	call   800a28 <strlen>
  801072:	83 c4 04             	add    $0x4,%esp
  801075:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  801078:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  80107f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801086:	eb 17                	jmp    80109f <strcconcat+0x49>
		final[s] = str1[s] ;
  801088:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80108b:	8b 45 10             	mov    0x10(%ebp),%eax
  80108e:	01 c2                	add    %eax,%edx
  801090:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801093:	8b 45 08             	mov    0x8(%ebp),%eax
  801096:	01 c8                	add    %ecx,%eax
  801098:	8a 00                	mov    (%eax),%al
  80109a:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  80109c:	ff 45 fc             	incl   -0x4(%ebp)
  80109f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8010a2:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8010a5:	7c e1                	jl     801088 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  8010a7:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  8010ae:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8010b5:	eb 1f                	jmp    8010d6 <strcconcat+0x80>
		final[s++] = str2[i] ;
  8010b7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8010ba:	8d 50 01             	lea    0x1(%eax),%edx
  8010bd:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8010c0:	89 c2                	mov    %eax,%edx
  8010c2:	8b 45 10             	mov    0x10(%ebp),%eax
  8010c5:	01 c2                	add    %eax,%edx
  8010c7:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8010ca:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010cd:	01 c8                	add    %ecx,%eax
  8010cf:	8a 00                	mov    (%eax),%al
  8010d1:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  8010d3:	ff 45 f8             	incl   -0x8(%ebp)
  8010d6:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010d9:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8010dc:	7c d9                	jl     8010b7 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  8010de:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8010e1:	8b 45 10             	mov    0x10(%ebp),%eax
  8010e4:	01 d0                	add    %edx,%eax
  8010e6:	c6 00 00             	movb   $0x0,(%eax)
}
  8010e9:	90                   	nop
  8010ea:	c9                   	leave  
  8010eb:	c3                   	ret    

008010ec <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  8010ec:	55                   	push   %ebp
  8010ed:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  8010ef:	8b 45 14             	mov    0x14(%ebp),%eax
  8010f2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  8010f8:	8b 45 14             	mov    0x14(%ebp),%eax
  8010fb:	8b 00                	mov    (%eax),%eax
  8010fd:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801104:	8b 45 10             	mov    0x10(%ebp),%eax
  801107:	01 d0                	add    %edx,%eax
  801109:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80110f:	eb 0c                	jmp    80111d <strsplit+0x31>
			*string++ = 0;
  801111:	8b 45 08             	mov    0x8(%ebp),%eax
  801114:	8d 50 01             	lea    0x1(%eax),%edx
  801117:	89 55 08             	mov    %edx,0x8(%ebp)
  80111a:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80111d:	8b 45 08             	mov    0x8(%ebp),%eax
  801120:	8a 00                	mov    (%eax),%al
  801122:	84 c0                	test   %al,%al
  801124:	74 18                	je     80113e <strsplit+0x52>
  801126:	8b 45 08             	mov    0x8(%ebp),%eax
  801129:	8a 00                	mov    (%eax),%al
  80112b:	0f be c0             	movsbl %al,%eax
  80112e:	50                   	push   %eax
  80112f:	ff 75 0c             	pushl  0xc(%ebp)
  801132:	e8 83 fa ff ff       	call   800bba <strchr>
  801137:	83 c4 08             	add    $0x8,%esp
  80113a:	85 c0                	test   %eax,%eax
  80113c:	75 d3                	jne    801111 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  80113e:	8b 45 08             	mov    0x8(%ebp),%eax
  801141:	8a 00                	mov    (%eax),%al
  801143:	84 c0                	test   %al,%al
  801145:	74 5a                	je     8011a1 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801147:	8b 45 14             	mov    0x14(%ebp),%eax
  80114a:	8b 00                	mov    (%eax),%eax
  80114c:	83 f8 0f             	cmp    $0xf,%eax
  80114f:	75 07                	jne    801158 <strsplit+0x6c>
		{
			return 0;
  801151:	b8 00 00 00 00       	mov    $0x0,%eax
  801156:	eb 66                	jmp    8011be <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801158:	8b 45 14             	mov    0x14(%ebp),%eax
  80115b:	8b 00                	mov    (%eax),%eax
  80115d:	8d 48 01             	lea    0x1(%eax),%ecx
  801160:	8b 55 14             	mov    0x14(%ebp),%edx
  801163:	89 0a                	mov    %ecx,(%edx)
  801165:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80116c:	8b 45 10             	mov    0x10(%ebp),%eax
  80116f:	01 c2                	add    %eax,%edx
  801171:	8b 45 08             	mov    0x8(%ebp),%eax
  801174:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801176:	eb 03                	jmp    80117b <strsplit+0x8f>
			string++;
  801178:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  80117b:	8b 45 08             	mov    0x8(%ebp),%eax
  80117e:	8a 00                	mov    (%eax),%al
  801180:	84 c0                	test   %al,%al
  801182:	74 8b                	je     80110f <strsplit+0x23>
  801184:	8b 45 08             	mov    0x8(%ebp),%eax
  801187:	8a 00                	mov    (%eax),%al
  801189:	0f be c0             	movsbl %al,%eax
  80118c:	50                   	push   %eax
  80118d:	ff 75 0c             	pushl  0xc(%ebp)
  801190:	e8 25 fa ff ff       	call   800bba <strchr>
  801195:	83 c4 08             	add    $0x8,%esp
  801198:	85 c0                	test   %eax,%eax
  80119a:	74 dc                	je     801178 <strsplit+0x8c>
			string++;
	}
  80119c:	e9 6e ff ff ff       	jmp    80110f <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  8011a1:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  8011a2:	8b 45 14             	mov    0x14(%ebp),%eax
  8011a5:	8b 00                	mov    (%eax),%eax
  8011a7:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8011ae:	8b 45 10             	mov    0x10(%ebp),%eax
  8011b1:	01 d0                	add    %edx,%eax
  8011b3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  8011b9:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8011be:	c9                   	leave  
  8011bf:	c3                   	ret    

008011c0 <str2lower>:


char* str2lower(char *dst, const char *src)
{
  8011c0:	55                   	push   %ebp
  8011c1:	89 e5                	mov    %esp,%ebp
  8011c3:	83 ec 10             	sub    $0x10,%esp
	char* ret = dst;
  8011c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8011c9:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (int i = 0; i < strlen(src); ++i)
  8011cc:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8011d3:	eb 4a                	jmp    80121f <str2lower+0x5f>
	{
		dst[i] = src[i] ;
  8011d5:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8011d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8011db:	01 c2                	add    %eax,%edx
  8011dd:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8011e0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011e3:	01 c8                	add    %ecx,%eax
  8011e5:	8a 00                	mov    (%eax),%al
  8011e7:	88 02                	mov    %al,(%edx)
		if (src[i] >= 'A' && src[i] <= 'Z')
  8011e9:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8011ec:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011ef:	01 d0                	add    %edx,%eax
  8011f1:	8a 00                	mov    (%eax),%al
  8011f3:	3c 40                	cmp    $0x40,%al
  8011f5:	7e 25                	jle    80121c <str2lower+0x5c>
  8011f7:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8011fa:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011fd:	01 d0                	add    %edx,%eax
  8011ff:	8a 00                	mov    (%eax),%al
  801201:	3c 5a                	cmp    $0x5a,%al
  801203:	7f 17                	jg     80121c <str2lower+0x5c>
		{
			dst[i] += 32 ;
  801205:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801208:	8b 45 08             	mov    0x8(%ebp),%eax
  80120b:	01 d0                	add    %edx,%eax
  80120d:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801210:	8b 55 08             	mov    0x8(%ebp),%edx
  801213:	01 ca                	add    %ecx,%edx
  801215:	8a 12                	mov    (%edx),%dl
  801217:	83 c2 20             	add    $0x20,%edx
  80121a:	88 10                	mov    %dl,(%eax)


char* str2lower(char *dst, const char *src)
{
	char* ret = dst;
	for (int i = 0; i < strlen(src); ++i)
  80121c:	ff 45 fc             	incl   -0x4(%ebp)
  80121f:	ff 75 0c             	pushl  0xc(%ebp)
  801222:	e8 01 f8 ff ff       	call   800a28 <strlen>
  801227:	83 c4 04             	add    $0x4,%esp
  80122a:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  80122d:	7f a6                	jg     8011d5 <str2lower+0x15>
		if (src[i] >= 'A' && src[i] <= 'Z')
		{
			dst[i] += 32 ;
		}
	}
	return ret;
  80122f:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801232:	c9                   	leave  
  801233:	c3                   	ret    

00801234 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801234:	55                   	push   %ebp
  801235:	89 e5                	mov    %esp,%ebp
  801237:	57                   	push   %edi
  801238:	56                   	push   %esi
  801239:	53                   	push   %ebx
  80123a:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80123d:	8b 45 08             	mov    0x8(%ebp),%eax
  801240:	8b 55 0c             	mov    0xc(%ebp),%edx
  801243:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801246:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801249:	8b 7d 18             	mov    0x18(%ebp),%edi
  80124c:	8b 75 1c             	mov    0x1c(%ebp),%esi
  80124f:	cd 30                	int    $0x30
  801251:	89 45 f0             	mov    %eax,-0x10(%ebp)
				"b" (a3),
				"D" (a4),
				"S" (a5)
				: "cc", "memory");

	return ret;
  801254:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801257:	83 c4 10             	add    $0x10,%esp
  80125a:	5b                   	pop    %ebx
  80125b:	5e                   	pop    %esi
  80125c:	5f                   	pop    %edi
  80125d:	5d                   	pop    %ebp
  80125e:	c3                   	ret    

0080125f <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName, int color)
{
  80125f:	55                   	push   %ebp
  801260:	89 e5                	mov    %esp,%ebp
  801262:	83 ec 04             	sub    $0x4,%esp
  801265:	8b 45 10             	mov    0x10(%ebp),%eax
  801268:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, color, 0);
  80126b:	8b 4d 14             	mov    0x14(%ebp),%ecx
  80126e:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801272:	8b 45 08             	mov    0x8(%ebp),%eax
  801275:	6a 00                	push   $0x0
  801277:	51                   	push   %ecx
  801278:	52                   	push   %edx
  801279:	ff 75 0c             	pushl  0xc(%ebp)
  80127c:	50                   	push   %eax
  80127d:	6a 00                	push   $0x0
  80127f:	e8 b0 ff ff ff       	call   801234 <syscall>
  801284:	83 c4 18             	add    $0x18,%esp
}
  801287:	90                   	nop
  801288:	c9                   	leave  
  801289:	c3                   	ret    

0080128a <sys_cgetc>:

int
sys_cgetc(void)
{
  80128a:	55                   	push   %ebp
  80128b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  80128d:	6a 00                	push   $0x0
  80128f:	6a 00                	push   $0x0
  801291:	6a 00                	push   $0x0
  801293:	6a 00                	push   $0x0
  801295:	6a 00                	push   $0x0
  801297:	6a 02                	push   $0x2
  801299:	e8 96 ff ff ff       	call   801234 <syscall>
  80129e:	83 c4 18             	add    $0x18,%esp
}
  8012a1:	c9                   	leave  
  8012a2:	c3                   	ret    

008012a3 <sys_lock_cons>:

void sys_lock_cons(void)
{
  8012a3:	55                   	push   %ebp
  8012a4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  8012a6:	6a 00                	push   $0x0
  8012a8:	6a 00                	push   $0x0
  8012aa:	6a 00                	push   $0x0
  8012ac:	6a 00                	push   $0x0
  8012ae:	6a 00                	push   $0x0
  8012b0:	6a 03                	push   $0x3
  8012b2:	e8 7d ff ff ff       	call   801234 <syscall>
  8012b7:	83 c4 18             	add    $0x18,%esp
}
  8012ba:	90                   	nop
  8012bb:	c9                   	leave  
  8012bc:	c3                   	ret    

008012bd <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  8012bd:	55                   	push   %ebp
  8012be:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  8012c0:	6a 00                	push   $0x0
  8012c2:	6a 00                	push   $0x0
  8012c4:	6a 00                	push   $0x0
  8012c6:	6a 00                	push   $0x0
  8012c8:	6a 00                	push   $0x0
  8012ca:	6a 04                	push   $0x4
  8012cc:	e8 63 ff ff ff       	call   801234 <syscall>
  8012d1:	83 c4 18             	add    $0x18,%esp
}
  8012d4:	90                   	nop
  8012d5:	c9                   	leave  
  8012d6:	c3                   	ret    

008012d7 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  8012d7:	55                   	push   %ebp
  8012d8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  8012da:	8b 55 0c             	mov    0xc(%ebp),%edx
  8012dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8012e0:	6a 00                	push   $0x0
  8012e2:	6a 00                	push   $0x0
  8012e4:	6a 00                	push   $0x0
  8012e6:	52                   	push   %edx
  8012e7:	50                   	push   %eax
  8012e8:	6a 08                	push   $0x8
  8012ea:	e8 45 ff ff ff       	call   801234 <syscall>
  8012ef:	83 c4 18             	add    $0x18,%esp
}
  8012f2:	c9                   	leave  
  8012f3:	c3                   	ret    

008012f4 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  8012f4:	55                   	push   %ebp
  8012f5:	89 e5                	mov    %esp,%ebp
  8012f7:	56                   	push   %esi
  8012f8:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  8012f9:	8b 75 18             	mov    0x18(%ebp),%esi
  8012fc:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8012ff:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801302:	8b 55 0c             	mov    0xc(%ebp),%edx
  801305:	8b 45 08             	mov    0x8(%ebp),%eax
  801308:	56                   	push   %esi
  801309:	53                   	push   %ebx
  80130a:	51                   	push   %ecx
  80130b:	52                   	push   %edx
  80130c:	50                   	push   %eax
  80130d:	6a 09                	push   $0x9
  80130f:	e8 20 ff ff ff       	call   801234 <syscall>
  801314:	83 c4 18             	add    $0x18,%esp
}
  801317:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80131a:	5b                   	pop    %ebx
  80131b:	5e                   	pop    %esi
  80131c:	5d                   	pop    %ebp
  80131d:	c3                   	ret    

0080131e <__sys_unmap_frame>:

int __sys_unmap_frame(uint32 va)
{
  80131e:	55                   	push   %ebp
  80131f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, va, 0, 0, 0, 0);
  801321:	6a 00                	push   $0x0
  801323:	6a 00                	push   $0x0
  801325:	6a 00                	push   $0x0
  801327:	6a 00                	push   $0x0
  801329:	ff 75 08             	pushl  0x8(%ebp)
  80132c:	6a 0a                	push   $0xa
  80132e:	e8 01 ff ff ff       	call   801234 <syscall>
  801333:	83 c4 18             	add    $0x18,%esp
}
  801336:	c9                   	leave  
  801337:	c3                   	ret    

00801338 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801338:	55                   	push   %ebp
  801339:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  80133b:	6a 00                	push   $0x0
  80133d:	6a 00                	push   $0x0
  80133f:	6a 00                	push   $0x0
  801341:	ff 75 0c             	pushl  0xc(%ebp)
  801344:	ff 75 08             	pushl  0x8(%ebp)
  801347:	6a 0b                	push   $0xb
  801349:	e8 e6 fe ff ff       	call   801234 <syscall>
  80134e:	83 c4 18             	add    $0x18,%esp
}
  801351:	c9                   	leave  
  801352:	c3                   	ret    

00801353 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801353:	55                   	push   %ebp
  801354:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801356:	6a 00                	push   $0x0
  801358:	6a 00                	push   $0x0
  80135a:	6a 00                	push   $0x0
  80135c:	6a 00                	push   $0x0
  80135e:	6a 00                	push   $0x0
  801360:	6a 0c                	push   $0xc
  801362:	e8 cd fe ff ff       	call   801234 <syscall>
  801367:	83 c4 18             	add    $0x18,%esp
}
  80136a:	c9                   	leave  
  80136b:	c3                   	ret    

0080136c <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  80136c:	55                   	push   %ebp
  80136d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  80136f:	6a 00                	push   $0x0
  801371:	6a 00                	push   $0x0
  801373:	6a 00                	push   $0x0
  801375:	6a 00                	push   $0x0
  801377:	6a 00                	push   $0x0
  801379:	6a 0d                	push   $0xd
  80137b:	e8 b4 fe ff ff       	call   801234 <syscall>
  801380:	83 c4 18             	add    $0x18,%esp
}
  801383:	c9                   	leave  
  801384:	c3                   	ret    

00801385 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801385:	55                   	push   %ebp
  801386:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801388:	6a 00                	push   $0x0
  80138a:	6a 00                	push   $0x0
  80138c:	6a 00                	push   $0x0
  80138e:	6a 00                	push   $0x0
  801390:	6a 00                	push   $0x0
  801392:	6a 0e                	push   $0xe
  801394:	e8 9b fe ff ff       	call   801234 <syscall>
  801399:	83 c4 18             	add    $0x18,%esp
}
  80139c:	c9                   	leave  
  80139d:	c3                   	ret    

0080139e <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  80139e:	55                   	push   %ebp
  80139f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  8013a1:	6a 00                	push   $0x0
  8013a3:	6a 00                	push   $0x0
  8013a5:	6a 00                	push   $0x0
  8013a7:	6a 00                	push   $0x0
  8013a9:	6a 00                	push   $0x0
  8013ab:	6a 0f                	push   $0xf
  8013ad:	e8 82 fe ff ff       	call   801234 <syscall>
  8013b2:	83 c4 18             	add    $0x18,%esp
}
  8013b5:	c9                   	leave  
  8013b6:	c3                   	ret    

008013b7 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  8013b7:	55                   	push   %ebp
  8013b8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  8013ba:	6a 00                	push   $0x0
  8013bc:	6a 00                	push   $0x0
  8013be:	6a 00                	push   $0x0
  8013c0:	6a 00                	push   $0x0
  8013c2:	ff 75 08             	pushl  0x8(%ebp)
  8013c5:	6a 10                	push   $0x10
  8013c7:	e8 68 fe ff ff       	call   801234 <syscall>
  8013cc:	83 c4 18             	add    $0x18,%esp
}
  8013cf:	c9                   	leave  
  8013d0:	c3                   	ret    

008013d1 <sys_scarce_memory>:

void sys_scarce_memory()
{
  8013d1:	55                   	push   %ebp
  8013d2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  8013d4:	6a 00                	push   $0x0
  8013d6:	6a 00                	push   $0x0
  8013d8:	6a 00                	push   $0x0
  8013da:	6a 00                	push   $0x0
  8013dc:	6a 00                	push   $0x0
  8013de:	6a 11                	push   $0x11
  8013e0:	e8 4f fe ff ff       	call   801234 <syscall>
  8013e5:	83 c4 18             	add    $0x18,%esp
}
  8013e8:	90                   	nop
  8013e9:	c9                   	leave  
  8013ea:	c3                   	ret    

008013eb <sys_cputc>:

void
sys_cputc(const char c)
{
  8013eb:	55                   	push   %ebp
  8013ec:	89 e5                	mov    %esp,%ebp
  8013ee:	83 ec 04             	sub    $0x4,%esp
  8013f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8013f4:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  8013f7:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8013fb:	6a 00                	push   $0x0
  8013fd:	6a 00                	push   $0x0
  8013ff:	6a 00                	push   $0x0
  801401:	6a 00                	push   $0x0
  801403:	50                   	push   %eax
  801404:	6a 01                	push   $0x1
  801406:	e8 29 fe ff ff       	call   801234 <syscall>
  80140b:	83 c4 18             	add    $0x18,%esp
}
  80140e:	90                   	nop
  80140f:	c9                   	leave  
  801410:	c3                   	ret    

00801411 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801411:	55                   	push   %ebp
  801412:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801414:	6a 00                	push   $0x0
  801416:	6a 00                	push   $0x0
  801418:	6a 00                	push   $0x0
  80141a:	6a 00                	push   $0x0
  80141c:	6a 00                	push   $0x0
  80141e:	6a 14                	push   $0x14
  801420:	e8 0f fe ff ff       	call   801234 <syscall>
  801425:	83 c4 18             	add    $0x18,%esp
}
  801428:	90                   	nop
  801429:	c9                   	leave  
  80142a:	c3                   	ret    

0080142b <sys_create_shared_object>:

int sys_create_shared_object(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  80142b:	55                   	push   %ebp
  80142c:	89 e5                	mov    %esp,%ebp
  80142e:	83 ec 04             	sub    $0x4,%esp
  801431:	8b 45 10             	mov    0x10(%ebp),%eax
  801434:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801437:	8b 4d 14             	mov    0x14(%ebp),%ecx
  80143a:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80143e:	8b 45 08             	mov    0x8(%ebp),%eax
  801441:	6a 00                	push   $0x0
  801443:	51                   	push   %ecx
  801444:	52                   	push   %edx
  801445:	ff 75 0c             	pushl  0xc(%ebp)
  801448:	50                   	push   %eax
  801449:	6a 15                	push   $0x15
  80144b:	e8 e4 fd ff ff       	call   801234 <syscall>
  801450:	83 c4 18             	add    $0x18,%esp
}
  801453:	c9                   	leave  
  801454:	c3                   	ret    

00801455 <sys_size_of_shared_object>:

//2017:
int sys_size_of_shared_object(int32 ownerID, char* shareName)
{
  801455:	55                   	push   %ebp
  801456:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801458:	8b 55 0c             	mov    0xc(%ebp),%edx
  80145b:	8b 45 08             	mov    0x8(%ebp),%eax
  80145e:	6a 00                	push   $0x0
  801460:	6a 00                	push   $0x0
  801462:	6a 00                	push   $0x0
  801464:	52                   	push   %edx
  801465:	50                   	push   %eax
  801466:	6a 16                	push   $0x16
  801468:	e8 c7 fd ff ff       	call   801234 <syscall>
  80146d:	83 c4 18             	add    $0x18,%esp
}
  801470:	c9                   	leave  
  801471:	c3                   	ret    

00801472 <sys_get_shared_object>:
//==========

int sys_get_shared_object(int32 ownerID, char* shareName, void* virtual_address)
{
  801472:	55                   	push   %ebp
  801473:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801475:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801478:	8b 55 0c             	mov    0xc(%ebp),%edx
  80147b:	8b 45 08             	mov    0x8(%ebp),%eax
  80147e:	6a 00                	push   $0x0
  801480:	6a 00                	push   $0x0
  801482:	51                   	push   %ecx
  801483:	52                   	push   %edx
  801484:	50                   	push   %eax
  801485:	6a 17                	push   $0x17
  801487:	e8 a8 fd ff ff       	call   801234 <syscall>
  80148c:	83 c4 18             	add    $0x18,%esp
}
  80148f:	c9                   	leave  
  801490:	c3                   	ret    

00801491 <sys_delete_shared_object>:

int sys_delete_shared_object(int32 sharedObjectID, void *startVA)
{
  801491:	55                   	push   %ebp
  801492:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801494:	8b 55 0c             	mov    0xc(%ebp),%edx
  801497:	8b 45 08             	mov    0x8(%ebp),%eax
  80149a:	6a 00                	push   $0x0
  80149c:	6a 00                	push   $0x0
  80149e:	6a 00                	push   $0x0
  8014a0:	52                   	push   %edx
  8014a1:	50                   	push   %eax
  8014a2:	6a 18                	push   $0x18
  8014a4:	e8 8b fd ff ff       	call   801234 <syscall>
  8014a9:	83 c4 18             	add    $0x18,%esp
}
  8014ac:	c9                   	leave  
  8014ad:	c3                   	ret    

008014ae <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  8014ae:	55                   	push   %ebp
  8014af:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  8014b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8014b4:	6a 00                	push   $0x0
  8014b6:	ff 75 14             	pushl  0x14(%ebp)
  8014b9:	ff 75 10             	pushl  0x10(%ebp)
  8014bc:	ff 75 0c             	pushl  0xc(%ebp)
  8014bf:	50                   	push   %eax
  8014c0:	6a 19                	push   $0x19
  8014c2:	e8 6d fd ff ff       	call   801234 <syscall>
  8014c7:	83 c4 18             	add    $0x18,%esp
}
  8014ca:	c9                   	leave  
  8014cb:	c3                   	ret    

008014cc <sys_run_env>:

void sys_run_env(int32 envId)
{
  8014cc:	55                   	push   %ebp
  8014cd:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  8014cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8014d2:	6a 00                	push   $0x0
  8014d4:	6a 00                	push   $0x0
  8014d6:	6a 00                	push   $0x0
  8014d8:	6a 00                	push   $0x0
  8014da:	50                   	push   %eax
  8014db:	6a 1a                	push   $0x1a
  8014dd:	e8 52 fd ff ff       	call   801234 <syscall>
  8014e2:	83 c4 18             	add    $0x18,%esp
}
  8014e5:	90                   	nop
  8014e6:	c9                   	leave  
  8014e7:	c3                   	ret    

008014e8 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  8014e8:	55                   	push   %ebp
  8014e9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  8014eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8014ee:	6a 00                	push   $0x0
  8014f0:	6a 00                	push   $0x0
  8014f2:	6a 00                	push   $0x0
  8014f4:	6a 00                	push   $0x0
  8014f6:	50                   	push   %eax
  8014f7:	6a 1b                	push   $0x1b
  8014f9:	e8 36 fd ff ff       	call   801234 <syscall>
  8014fe:	83 c4 18             	add    $0x18,%esp
}
  801501:	c9                   	leave  
  801502:	c3                   	ret    

00801503 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801503:	55                   	push   %ebp
  801504:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801506:	6a 00                	push   $0x0
  801508:	6a 00                	push   $0x0
  80150a:	6a 00                	push   $0x0
  80150c:	6a 00                	push   $0x0
  80150e:	6a 00                	push   $0x0
  801510:	6a 05                	push   $0x5
  801512:	e8 1d fd ff ff       	call   801234 <syscall>
  801517:	83 c4 18             	add    $0x18,%esp
}
  80151a:	c9                   	leave  
  80151b:	c3                   	ret    

0080151c <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  80151c:	55                   	push   %ebp
  80151d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  80151f:	6a 00                	push   $0x0
  801521:	6a 00                	push   $0x0
  801523:	6a 00                	push   $0x0
  801525:	6a 00                	push   $0x0
  801527:	6a 00                	push   $0x0
  801529:	6a 06                	push   $0x6
  80152b:	e8 04 fd ff ff       	call   801234 <syscall>
  801530:	83 c4 18             	add    $0x18,%esp
}
  801533:	c9                   	leave  
  801534:	c3                   	ret    

00801535 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801535:	55                   	push   %ebp
  801536:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801538:	6a 00                	push   $0x0
  80153a:	6a 00                	push   $0x0
  80153c:	6a 00                	push   $0x0
  80153e:	6a 00                	push   $0x0
  801540:	6a 00                	push   $0x0
  801542:	6a 07                	push   $0x7
  801544:	e8 eb fc ff ff       	call   801234 <syscall>
  801549:	83 c4 18             	add    $0x18,%esp
}
  80154c:	c9                   	leave  
  80154d:	c3                   	ret    

0080154e <sys_exit_env>:


void sys_exit_env(void)
{
  80154e:	55                   	push   %ebp
  80154f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801551:	6a 00                	push   $0x0
  801553:	6a 00                	push   $0x0
  801555:	6a 00                	push   $0x0
  801557:	6a 00                	push   $0x0
  801559:	6a 00                	push   $0x0
  80155b:	6a 1c                	push   $0x1c
  80155d:	e8 d2 fc ff ff       	call   801234 <syscall>
  801562:	83 c4 18             	add    $0x18,%esp
}
  801565:	90                   	nop
  801566:	c9                   	leave  
  801567:	c3                   	ret    

00801568 <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  801568:	55                   	push   %ebp
  801569:	89 e5                	mov    %esp,%ebp
  80156b:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  80156e:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801571:	8d 50 04             	lea    0x4(%eax),%edx
  801574:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801577:	6a 00                	push   $0x0
  801579:	6a 00                	push   $0x0
  80157b:	6a 00                	push   $0x0
  80157d:	52                   	push   %edx
  80157e:	50                   	push   %eax
  80157f:	6a 1d                	push   $0x1d
  801581:	e8 ae fc ff ff       	call   801234 <syscall>
  801586:	83 c4 18             	add    $0x18,%esp
	return result;
  801589:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80158c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80158f:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801592:	89 01                	mov    %eax,(%ecx)
  801594:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801597:	8b 45 08             	mov    0x8(%ebp),%eax
  80159a:	c9                   	leave  
  80159b:	c2 04 00             	ret    $0x4

0080159e <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  80159e:	55                   	push   %ebp
  80159f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  8015a1:	6a 00                	push   $0x0
  8015a3:	6a 00                	push   $0x0
  8015a5:	ff 75 10             	pushl  0x10(%ebp)
  8015a8:	ff 75 0c             	pushl  0xc(%ebp)
  8015ab:	ff 75 08             	pushl  0x8(%ebp)
  8015ae:	6a 13                	push   $0x13
  8015b0:	e8 7f fc ff ff       	call   801234 <syscall>
  8015b5:	83 c4 18             	add    $0x18,%esp
	return ;
  8015b8:	90                   	nop
}
  8015b9:	c9                   	leave  
  8015ba:	c3                   	ret    

008015bb <sys_rcr2>:
uint32 sys_rcr2()
{
  8015bb:	55                   	push   %ebp
  8015bc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  8015be:	6a 00                	push   $0x0
  8015c0:	6a 00                	push   $0x0
  8015c2:	6a 00                	push   $0x0
  8015c4:	6a 00                	push   $0x0
  8015c6:	6a 00                	push   $0x0
  8015c8:	6a 1e                	push   $0x1e
  8015ca:	e8 65 fc ff ff       	call   801234 <syscall>
  8015cf:	83 c4 18             	add    $0x18,%esp
}
  8015d2:	c9                   	leave  
  8015d3:	c3                   	ret    

008015d4 <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  8015d4:	55                   	push   %ebp
  8015d5:	89 e5                	mov    %esp,%ebp
  8015d7:	83 ec 04             	sub    $0x4,%esp
  8015da:	8b 45 08             	mov    0x8(%ebp),%eax
  8015dd:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  8015e0:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  8015e4:	6a 00                	push   $0x0
  8015e6:	6a 00                	push   $0x0
  8015e8:	6a 00                	push   $0x0
  8015ea:	6a 00                	push   $0x0
  8015ec:	50                   	push   %eax
  8015ed:	6a 1f                	push   $0x1f
  8015ef:	e8 40 fc ff ff       	call   801234 <syscall>
  8015f4:	83 c4 18             	add    $0x18,%esp
	return ;
  8015f7:	90                   	nop
}
  8015f8:	c9                   	leave  
  8015f9:	c3                   	ret    

008015fa <rsttst>:
void rsttst()
{
  8015fa:	55                   	push   %ebp
  8015fb:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  8015fd:	6a 00                	push   $0x0
  8015ff:	6a 00                	push   $0x0
  801601:	6a 00                	push   $0x0
  801603:	6a 00                	push   $0x0
  801605:	6a 00                	push   $0x0
  801607:	6a 21                	push   $0x21
  801609:	e8 26 fc ff ff       	call   801234 <syscall>
  80160e:	83 c4 18             	add    $0x18,%esp
	return ;
  801611:	90                   	nop
}
  801612:	c9                   	leave  
  801613:	c3                   	ret    

00801614 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801614:	55                   	push   %ebp
  801615:	89 e5                	mov    %esp,%ebp
  801617:	83 ec 04             	sub    $0x4,%esp
  80161a:	8b 45 14             	mov    0x14(%ebp),%eax
  80161d:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801620:	8b 55 18             	mov    0x18(%ebp),%edx
  801623:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801627:	52                   	push   %edx
  801628:	50                   	push   %eax
  801629:	ff 75 10             	pushl  0x10(%ebp)
  80162c:	ff 75 0c             	pushl  0xc(%ebp)
  80162f:	ff 75 08             	pushl  0x8(%ebp)
  801632:	6a 20                	push   $0x20
  801634:	e8 fb fb ff ff       	call   801234 <syscall>
  801639:	83 c4 18             	add    $0x18,%esp
	return ;
  80163c:	90                   	nop
}
  80163d:	c9                   	leave  
  80163e:	c3                   	ret    

0080163f <chktst>:
void chktst(uint32 n)
{
  80163f:	55                   	push   %ebp
  801640:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801642:	6a 00                	push   $0x0
  801644:	6a 00                	push   $0x0
  801646:	6a 00                	push   $0x0
  801648:	6a 00                	push   $0x0
  80164a:	ff 75 08             	pushl  0x8(%ebp)
  80164d:	6a 22                	push   $0x22
  80164f:	e8 e0 fb ff ff       	call   801234 <syscall>
  801654:	83 c4 18             	add    $0x18,%esp
	return ;
  801657:	90                   	nop
}
  801658:	c9                   	leave  
  801659:	c3                   	ret    

0080165a <inctst>:

void inctst()
{
  80165a:	55                   	push   %ebp
  80165b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  80165d:	6a 00                	push   $0x0
  80165f:	6a 00                	push   $0x0
  801661:	6a 00                	push   $0x0
  801663:	6a 00                	push   $0x0
  801665:	6a 00                	push   $0x0
  801667:	6a 23                	push   $0x23
  801669:	e8 c6 fb ff ff       	call   801234 <syscall>
  80166e:	83 c4 18             	add    $0x18,%esp
	return ;
  801671:	90                   	nop
}
  801672:	c9                   	leave  
  801673:	c3                   	ret    

00801674 <gettst>:
uint32 gettst()
{
  801674:	55                   	push   %ebp
  801675:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801677:	6a 00                	push   $0x0
  801679:	6a 00                	push   $0x0
  80167b:	6a 00                	push   $0x0
  80167d:	6a 00                	push   $0x0
  80167f:	6a 00                	push   $0x0
  801681:	6a 24                	push   $0x24
  801683:	e8 ac fb ff ff       	call   801234 <syscall>
  801688:	83 c4 18             	add    $0x18,%esp
}
  80168b:	c9                   	leave  
  80168c:	c3                   	ret    

0080168d <sys_get_uheap_strategy>:

/*2025*/
uint32 sys_get_uheap_strategy()
{
  80168d:	55                   	push   %ebp
  80168e:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801690:	6a 00                	push   $0x0
  801692:	6a 00                	push   $0x0
  801694:	6a 00                	push   $0x0
  801696:	6a 00                	push   $0x0
  801698:	6a 00                	push   $0x0
  80169a:	6a 25                	push   $0x25
  80169c:	e8 93 fb ff ff       	call   801234 <syscall>
  8016a1:	83 c4 18             	add    $0x18,%esp
  8016a4:	a3 60 b0 81 00       	mov    %eax,0x81b060
	return uheapPlaceStrategy ;
  8016a9:	a1 60 b0 81 00       	mov    0x81b060,%eax
}
  8016ae:	c9                   	leave  
  8016af:	c3                   	ret    

008016b0 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  8016b0:	55                   	push   %ebp
  8016b1:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = heapStrategy;
  8016b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8016b6:	a3 60 b0 81 00       	mov    %eax,0x81b060
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  8016bb:	6a 00                	push   $0x0
  8016bd:	6a 00                	push   $0x0
  8016bf:	6a 00                	push   $0x0
  8016c1:	6a 00                	push   $0x0
  8016c3:	ff 75 08             	pushl  0x8(%ebp)
  8016c6:	6a 26                	push   $0x26
  8016c8:	e8 67 fb ff ff       	call   801234 <syscall>
  8016cd:	83 c4 18             	add    $0x18,%esp
	return ;
  8016d0:	90                   	nop
}
  8016d1:	c9                   	leave  
  8016d2:	c3                   	ret    

008016d3 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  8016d3:	55                   	push   %ebp
  8016d4:	89 e5                	mov    %esp,%ebp
  8016d6:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  8016d7:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8016da:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8016dd:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8016e3:	6a 00                	push   $0x0
  8016e5:	53                   	push   %ebx
  8016e6:	51                   	push   %ecx
  8016e7:	52                   	push   %edx
  8016e8:	50                   	push   %eax
  8016e9:	6a 27                	push   $0x27
  8016eb:	e8 44 fb ff ff       	call   801234 <syscall>
  8016f0:	83 c4 18             	add    $0x18,%esp
}
  8016f3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8016f6:	c9                   	leave  
  8016f7:	c3                   	ret    

008016f8 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  8016f8:	55                   	push   %ebp
  8016f9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  8016fb:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016fe:	8b 45 08             	mov    0x8(%ebp),%eax
  801701:	6a 00                	push   $0x0
  801703:	6a 00                	push   $0x0
  801705:	6a 00                	push   $0x0
  801707:	52                   	push   %edx
  801708:	50                   	push   %eax
  801709:	6a 28                	push   $0x28
  80170b:	e8 24 fb ff ff       	call   801234 <syscall>
  801710:	83 c4 18             	add    $0x18,%esp
}
  801713:	c9                   	leave  
  801714:	c3                   	ret    

00801715 <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  801715:	55                   	push   %ebp
  801716:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  801718:	8b 4d 14             	mov    0x14(%ebp),%ecx
  80171b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80171e:	8b 45 08             	mov    0x8(%ebp),%eax
  801721:	6a 00                	push   $0x0
  801723:	51                   	push   %ecx
  801724:	ff 75 10             	pushl  0x10(%ebp)
  801727:	52                   	push   %edx
  801728:	50                   	push   %eax
  801729:	6a 29                	push   $0x29
  80172b:	e8 04 fb ff ff       	call   801234 <syscall>
  801730:	83 c4 18             	add    $0x18,%esp
}
  801733:	c9                   	leave  
  801734:	c3                   	ret    

00801735 <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801735:	55                   	push   %ebp
  801736:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801738:	6a 00                	push   $0x0
  80173a:	6a 00                	push   $0x0
  80173c:	ff 75 10             	pushl  0x10(%ebp)
  80173f:	ff 75 0c             	pushl  0xc(%ebp)
  801742:	ff 75 08             	pushl  0x8(%ebp)
  801745:	6a 12                	push   $0x12
  801747:	e8 e8 fa ff ff       	call   801234 <syscall>
  80174c:	83 c4 18             	add    $0x18,%esp
	return ;
  80174f:	90                   	nop
}
  801750:	c9                   	leave  
  801751:	c3                   	ret    

00801752 <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  801752:	55                   	push   %ebp
  801753:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  801755:	8b 55 0c             	mov    0xc(%ebp),%edx
  801758:	8b 45 08             	mov    0x8(%ebp),%eax
  80175b:	6a 00                	push   $0x0
  80175d:	6a 00                	push   $0x0
  80175f:	6a 00                	push   $0x0
  801761:	52                   	push   %edx
  801762:	50                   	push   %eax
  801763:	6a 2a                	push   $0x2a
  801765:	e8 ca fa ff ff       	call   801234 <syscall>
  80176a:	83 c4 18             	add    $0x18,%esp
	return;
  80176d:	90                   	nop
}
  80176e:	c9                   	leave  
  80176f:	c3                   	ret    

00801770 <sys_get_optimal_num_faults>:
/*2025*/
int sys_get_optimal_num_faults()
{
  801770:	55                   	push   %ebp
  801771:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_optimal_num_faults, 0, 0, 0, 0, 0);
  801773:	6a 00                	push   $0x0
  801775:	6a 00                	push   $0x0
  801777:	6a 00                	push   $0x0
  801779:	6a 00                	push   $0x0
  80177b:	6a 00                	push   $0x0
  80177d:	6a 2b                	push   $0x2b
  80177f:	e8 b0 fa ff ff       	call   801234 <syscall>
  801784:	83 c4 18             	add    $0x18,%esp
}
  801787:	c9                   	leave  
  801788:	c3                   	ret    

00801789 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801789:	55                   	push   %ebp
  80178a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  80178c:	6a 00                	push   $0x0
  80178e:	6a 00                	push   $0x0
  801790:	6a 00                	push   $0x0
  801792:	ff 75 0c             	pushl  0xc(%ebp)
  801795:	ff 75 08             	pushl  0x8(%ebp)
  801798:	6a 2d                	push   $0x2d
  80179a:	e8 95 fa ff ff       	call   801234 <syscall>
  80179f:	83 c4 18             	add    $0x18,%esp
	return;
  8017a2:	90                   	nop
}
  8017a3:	c9                   	leave  
  8017a4:	c3                   	ret    

008017a5 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  8017a5:	55                   	push   %ebp
  8017a6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  8017a8:	6a 00                	push   $0x0
  8017aa:	6a 00                	push   $0x0
  8017ac:	6a 00                	push   $0x0
  8017ae:	ff 75 0c             	pushl  0xc(%ebp)
  8017b1:	ff 75 08             	pushl  0x8(%ebp)
  8017b4:	6a 2c                	push   $0x2c
  8017b6:	e8 79 fa ff ff       	call   801234 <syscall>
  8017bb:	83 c4 18             	add    $0x18,%esp
	return ;
  8017be:	90                   	nop
}
  8017bf:	c9                   	leave  
  8017c0:	c3                   	ret    

008017c1 <sys_env_set_priority>:


void sys_env_set_priority(int32 envID, int priority)
{
  8017c1:	55                   	push   %ebp
  8017c2:	89 e5                	mov    %esp,%ebp
  8017c4:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.IM#4] CPU SCHEDULING - #1 System Calls - Add suitable code here
	//Your code is here
	//Comment the following line
	panic("sys_env_set_priority() is not implemented yet...!!");
  8017c7:	83 ec 04             	sub    $0x4,%esp
  8017ca:	68 a8 21 80 00       	push   $0x8021a8
  8017cf:	68 25 01 00 00       	push   $0x125
  8017d4:	68 db 21 80 00       	push   $0x8021db
  8017d9:	e8 00 00 00 00       	call   8017de <_panic>

008017de <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  8017de:	55                   	push   %ebp
  8017df:	89 e5                	mov    %esp,%ebp
  8017e1:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  8017e4:	8d 45 10             	lea    0x10(%ebp),%eax
  8017e7:	83 c0 04             	add    $0x4,%eax
  8017ea:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  8017ed:	a1 1c b1 81 00       	mov    0x81b11c,%eax
  8017f2:	85 c0                	test   %eax,%eax
  8017f4:	74 16                	je     80180c <_panic+0x2e>
		cprintf("%s: ", argv0);
  8017f6:	a1 1c b1 81 00       	mov    0x81b11c,%eax
  8017fb:	83 ec 08             	sub    $0x8,%esp
  8017fe:	50                   	push   %eax
  8017ff:	68 ec 21 80 00       	push   $0x8021ec
  801804:	e8 46 eb ff ff       	call   80034f <cprintf>
  801809:	83 c4 10             	add    $0x10,%esp
	cprintf_colored(TEXT_PANIC_CLR, "user [EVAL_FINAL]panic in %s at %s:%d: ", binaryname, file, line);
  80180c:	a1 04 30 80 00       	mov    0x803004,%eax
  801811:	83 ec 0c             	sub    $0xc,%esp
  801814:	ff 75 0c             	pushl  0xc(%ebp)
  801817:	ff 75 08             	pushl  0x8(%ebp)
  80181a:	50                   	push   %eax
  80181b:	68 f4 21 80 00       	push   $0x8021f4
  801820:	6a 74                	push   $0x74
  801822:	e8 55 eb ff ff       	call   80037c <cprintf_colored>
  801827:	83 c4 20             	add    $0x20,%esp
	vcprintf(fmt, ap);
  80182a:	8b 45 10             	mov    0x10(%ebp),%eax
  80182d:	83 ec 08             	sub    $0x8,%esp
  801830:	ff 75 f4             	pushl  -0xc(%ebp)
  801833:	50                   	push   %eax
  801834:	e8 a7 ea ff ff       	call   8002e0 <vcprintf>
  801839:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  80183c:	83 ec 08             	sub    $0x8,%esp
  80183f:	6a 00                	push   $0x0
  801841:	68 1c 22 80 00       	push   $0x80221c
  801846:	e8 95 ea ff ff       	call   8002e0 <vcprintf>
  80184b:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  80184e:	e8 0e ea ff ff       	call   800261 <exit>

	// should not return here
	while (1) ;
  801853:	eb fe                	jmp    801853 <_panic+0x75>

00801855 <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  801855:	55                   	push   %ebp
  801856:	89 e5                	mov    %esp,%ebp
  801858:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  80185b:	a1 20 30 80 00       	mov    0x803020,%eax
  801860:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  801866:	8b 45 0c             	mov    0xc(%ebp),%eax
  801869:	39 c2                	cmp    %eax,%edx
  80186b:	74 14                	je     801881 <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  80186d:	83 ec 04             	sub    $0x4,%esp
  801870:	68 20 22 80 00       	push   $0x802220
  801875:	6a 26                	push   $0x26
  801877:	68 6c 22 80 00       	push   $0x80226c
  80187c:	e8 5d ff ff ff       	call   8017de <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  801881:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  801888:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80188f:	e9 c5 00 00 00       	jmp    801959 <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  801894:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801897:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80189e:	8b 45 08             	mov    0x8(%ebp),%eax
  8018a1:	01 d0                	add    %edx,%eax
  8018a3:	8b 00                	mov    (%eax),%eax
  8018a5:	85 c0                	test   %eax,%eax
  8018a7:	75 08                	jne    8018b1 <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  8018a9:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  8018ac:	e9 a5 00 00 00       	jmp    801956 <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  8018b1:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8018b8:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  8018bf:	eb 69                	jmp    80192a <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  8018c1:	a1 20 30 80 00       	mov    0x803020,%eax
  8018c6:	8b 88 38 da 01 00    	mov    0x1da38(%eax),%ecx
  8018cc:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8018cf:	89 d0                	mov    %edx,%eax
  8018d1:	01 c0                	add    %eax,%eax
  8018d3:	01 d0                	add    %edx,%eax
  8018d5:	c1 e0 03             	shl    $0x3,%eax
  8018d8:	01 c8                	add    %ecx,%eax
  8018da:	8a 40 04             	mov    0x4(%eax),%al
  8018dd:	84 c0                	test   %al,%al
  8018df:	75 46                	jne    801927 <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8018e1:	a1 20 30 80 00       	mov    0x803020,%eax
  8018e6:	8b 88 38 da 01 00    	mov    0x1da38(%eax),%ecx
  8018ec:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8018ef:	89 d0                	mov    %edx,%eax
  8018f1:	01 c0                	add    %eax,%eax
  8018f3:	01 d0                	add    %edx,%eax
  8018f5:	c1 e0 03             	shl    $0x3,%eax
  8018f8:	01 c8                	add    %ecx,%eax
  8018fa:	8b 00                	mov    (%eax),%eax
  8018fc:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8018ff:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801902:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801907:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  801909:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80190c:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  801913:	8b 45 08             	mov    0x8(%ebp),%eax
  801916:	01 c8                	add    %ecx,%eax
  801918:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  80191a:	39 c2                	cmp    %eax,%edx
  80191c:	75 09                	jne    801927 <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  80191e:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  801925:	eb 15                	jmp    80193c <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  801927:	ff 45 e8             	incl   -0x18(%ebp)
  80192a:	a1 20 30 80 00       	mov    0x803020,%eax
  80192f:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  801935:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801938:	39 c2                	cmp    %eax,%edx
  80193a:	77 85                	ja     8018c1 <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  80193c:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801940:	75 14                	jne    801956 <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  801942:	83 ec 04             	sub    $0x4,%esp
  801945:	68 78 22 80 00       	push   $0x802278
  80194a:	6a 3a                	push   $0x3a
  80194c:	68 6c 22 80 00       	push   $0x80226c
  801951:	e8 88 fe ff ff       	call   8017de <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  801956:	ff 45 f0             	incl   -0x10(%ebp)
  801959:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80195c:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80195f:	0f 8c 2f ff ff ff    	jl     801894 <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  801965:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80196c:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  801973:	eb 26                	jmp    80199b <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  801975:	a1 20 30 80 00       	mov    0x803020,%eax
  80197a:	8b 88 38 da 01 00    	mov    0x1da38(%eax),%ecx
  801980:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801983:	89 d0                	mov    %edx,%eax
  801985:	01 c0                	add    %eax,%eax
  801987:	01 d0                	add    %edx,%eax
  801989:	c1 e0 03             	shl    $0x3,%eax
  80198c:	01 c8                	add    %ecx,%eax
  80198e:	8a 40 04             	mov    0x4(%eax),%al
  801991:	3c 01                	cmp    $0x1,%al
  801993:	75 03                	jne    801998 <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  801995:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  801998:	ff 45 e0             	incl   -0x20(%ebp)
  80199b:	a1 20 30 80 00       	mov    0x803020,%eax
  8019a0:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  8019a6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8019a9:	39 c2                	cmp    %eax,%edx
  8019ab:	77 c8                	ja     801975 <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  8019ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8019b0:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8019b3:	74 14                	je     8019c9 <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  8019b5:	83 ec 04             	sub    $0x4,%esp
  8019b8:	68 cc 22 80 00       	push   $0x8022cc
  8019bd:	6a 44                	push   $0x44
  8019bf:	68 6c 22 80 00       	push   $0x80226c
  8019c4:	e8 15 fe ff ff       	call   8017de <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  8019c9:	90                   	nop
  8019ca:	c9                   	leave  
  8019cb:	c3                   	ret    

008019cc <__udivdi3>:
  8019cc:	55                   	push   %ebp
  8019cd:	57                   	push   %edi
  8019ce:	56                   	push   %esi
  8019cf:	53                   	push   %ebx
  8019d0:	83 ec 1c             	sub    $0x1c,%esp
  8019d3:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  8019d7:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  8019db:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8019df:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8019e3:	89 ca                	mov    %ecx,%edx
  8019e5:	89 f8                	mov    %edi,%eax
  8019e7:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  8019eb:	85 f6                	test   %esi,%esi
  8019ed:	75 2d                	jne    801a1c <__udivdi3+0x50>
  8019ef:	39 cf                	cmp    %ecx,%edi
  8019f1:	77 65                	ja     801a58 <__udivdi3+0x8c>
  8019f3:	89 fd                	mov    %edi,%ebp
  8019f5:	85 ff                	test   %edi,%edi
  8019f7:	75 0b                	jne    801a04 <__udivdi3+0x38>
  8019f9:	b8 01 00 00 00       	mov    $0x1,%eax
  8019fe:	31 d2                	xor    %edx,%edx
  801a00:	f7 f7                	div    %edi
  801a02:	89 c5                	mov    %eax,%ebp
  801a04:	31 d2                	xor    %edx,%edx
  801a06:	89 c8                	mov    %ecx,%eax
  801a08:	f7 f5                	div    %ebp
  801a0a:	89 c1                	mov    %eax,%ecx
  801a0c:	89 d8                	mov    %ebx,%eax
  801a0e:	f7 f5                	div    %ebp
  801a10:	89 cf                	mov    %ecx,%edi
  801a12:	89 fa                	mov    %edi,%edx
  801a14:	83 c4 1c             	add    $0x1c,%esp
  801a17:	5b                   	pop    %ebx
  801a18:	5e                   	pop    %esi
  801a19:	5f                   	pop    %edi
  801a1a:	5d                   	pop    %ebp
  801a1b:	c3                   	ret    
  801a1c:	39 ce                	cmp    %ecx,%esi
  801a1e:	77 28                	ja     801a48 <__udivdi3+0x7c>
  801a20:	0f bd fe             	bsr    %esi,%edi
  801a23:	83 f7 1f             	xor    $0x1f,%edi
  801a26:	75 40                	jne    801a68 <__udivdi3+0x9c>
  801a28:	39 ce                	cmp    %ecx,%esi
  801a2a:	72 0a                	jb     801a36 <__udivdi3+0x6a>
  801a2c:	3b 44 24 08          	cmp    0x8(%esp),%eax
  801a30:	0f 87 9e 00 00 00    	ja     801ad4 <__udivdi3+0x108>
  801a36:	b8 01 00 00 00       	mov    $0x1,%eax
  801a3b:	89 fa                	mov    %edi,%edx
  801a3d:	83 c4 1c             	add    $0x1c,%esp
  801a40:	5b                   	pop    %ebx
  801a41:	5e                   	pop    %esi
  801a42:	5f                   	pop    %edi
  801a43:	5d                   	pop    %ebp
  801a44:	c3                   	ret    
  801a45:	8d 76 00             	lea    0x0(%esi),%esi
  801a48:	31 ff                	xor    %edi,%edi
  801a4a:	31 c0                	xor    %eax,%eax
  801a4c:	89 fa                	mov    %edi,%edx
  801a4e:	83 c4 1c             	add    $0x1c,%esp
  801a51:	5b                   	pop    %ebx
  801a52:	5e                   	pop    %esi
  801a53:	5f                   	pop    %edi
  801a54:	5d                   	pop    %ebp
  801a55:	c3                   	ret    
  801a56:	66 90                	xchg   %ax,%ax
  801a58:	89 d8                	mov    %ebx,%eax
  801a5a:	f7 f7                	div    %edi
  801a5c:	31 ff                	xor    %edi,%edi
  801a5e:	89 fa                	mov    %edi,%edx
  801a60:	83 c4 1c             	add    $0x1c,%esp
  801a63:	5b                   	pop    %ebx
  801a64:	5e                   	pop    %esi
  801a65:	5f                   	pop    %edi
  801a66:	5d                   	pop    %ebp
  801a67:	c3                   	ret    
  801a68:	bd 20 00 00 00       	mov    $0x20,%ebp
  801a6d:	89 eb                	mov    %ebp,%ebx
  801a6f:	29 fb                	sub    %edi,%ebx
  801a71:	89 f9                	mov    %edi,%ecx
  801a73:	d3 e6                	shl    %cl,%esi
  801a75:	89 c5                	mov    %eax,%ebp
  801a77:	88 d9                	mov    %bl,%cl
  801a79:	d3 ed                	shr    %cl,%ebp
  801a7b:	89 e9                	mov    %ebp,%ecx
  801a7d:	09 f1                	or     %esi,%ecx
  801a7f:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  801a83:	89 f9                	mov    %edi,%ecx
  801a85:	d3 e0                	shl    %cl,%eax
  801a87:	89 c5                	mov    %eax,%ebp
  801a89:	89 d6                	mov    %edx,%esi
  801a8b:	88 d9                	mov    %bl,%cl
  801a8d:	d3 ee                	shr    %cl,%esi
  801a8f:	89 f9                	mov    %edi,%ecx
  801a91:	d3 e2                	shl    %cl,%edx
  801a93:	8b 44 24 08          	mov    0x8(%esp),%eax
  801a97:	88 d9                	mov    %bl,%cl
  801a99:	d3 e8                	shr    %cl,%eax
  801a9b:	09 c2                	or     %eax,%edx
  801a9d:	89 d0                	mov    %edx,%eax
  801a9f:	89 f2                	mov    %esi,%edx
  801aa1:	f7 74 24 0c          	divl   0xc(%esp)
  801aa5:	89 d6                	mov    %edx,%esi
  801aa7:	89 c3                	mov    %eax,%ebx
  801aa9:	f7 e5                	mul    %ebp
  801aab:	39 d6                	cmp    %edx,%esi
  801aad:	72 19                	jb     801ac8 <__udivdi3+0xfc>
  801aaf:	74 0b                	je     801abc <__udivdi3+0xf0>
  801ab1:	89 d8                	mov    %ebx,%eax
  801ab3:	31 ff                	xor    %edi,%edi
  801ab5:	e9 58 ff ff ff       	jmp    801a12 <__udivdi3+0x46>
  801aba:	66 90                	xchg   %ax,%ax
  801abc:	8b 54 24 08          	mov    0x8(%esp),%edx
  801ac0:	89 f9                	mov    %edi,%ecx
  801ac2:	d3 e2                	shl    %cl,%edx
  801ac4:	39 c2                	cmp    %eax,%edx
  801ac6:	73 e9                	jae    801ab1 <__udivdi3+0xe5>
  801ac8:	8d 43 ff             	lea    -0x1(%ebx),%eax
  801acb:	31 ff                	xor    %edi,%edi
  801acd:	e9 40 ff ff ff       	jmp    801a12 <__udivdi3+0x46>
  801ad2:	66 90                	xchg   %ax,%ax
  801ad4:	31 c0                	xor    %eax,%eax
  801ad6:	e9 37 ff ff ff       	jmp    801a12 <__udivdi3+0x46>
  801adb:	90                   	nop

00801adc <__umoddi3>:
  801adc:	55                   	push   %ebp
  801add:	57                   	push   %edi
  801ade:	56                   	push   %esi
  801adf:	53                   	push   %ebx
  801ae0:	83 ec 1c             	sub    $0x1c,%esp
  801ae3:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  801ae7:	8b 74 24 34          	mov    0x34(%esp),%esi
  801aeb:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801aef:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  801af3:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801af7:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801afb:	89 f3                	mov    %esi,%ebx
  801afd:	89 fa                	mov    %edi,%edx
  801aff:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801b03:	89 34 24             	mov    %esi,(%esp)
  801b06:	85 c0                	test   %eax,%eax
  801b08:	75 1a                	jne    801b24 <__umoddi3+0x48>
  801b0a:	39 f7                	cmp    %esi,%edi
  801b0c:	0f 86 a2 00 00 00    	jbe    801bb4 <__umoddi3+0xd8>
  801b12:	89 c8                	mov    %ecx,%eax
  801b14:	89 f2                	mov    %esi,%edx
  801b16:	f7 f7                	div    %edi
  801b18:	89 d0                	mov    %edx,%eax
  801b1a:	31 d2                	xor    %edx,%edx
  801b1c:	83 c4 1c             	add    $0x1c,%esp
  801b1f:	5b                   	pop    %ebx
  801b20:	5e                   	pop    %esi
  801b21:	5f                   	pop    %edi
  801b22:	5d                   	pop    %ebp
  801b23:	c3                   	ret    
  801b24:	39 f0                	cmp    %esi,%eax
  801b26:	0f 87 ac 00 00 00    	ja     801bd8 <__umoddi3+0xfc>
  801b2c:	0f bd e8             	bsr    %eax,%ebp
  801b2f:	83 f5 1f             	xor    $0x1f,%ebp
  801b32:	0f 84 ac 00 00 00    	je     801be4 <__umoddi3+0x108>
  801b38:	bf 20 00 00 00       	mov    $0x20,%edi
  801b3d:	29 ef                	sub    %ebp,%edi
  801b3f:	89 fe                	mov    %edi,%esi
  801b41:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801b45:	89 e9                	mov    %ebp,%ecx
  801b47:	d3 e0                	shl    %cl,%eax
  801b49:	89 d7                	mov    %edx,%edi
  801b4b:	89 f1                	mov    %esi,%ecx
  801b4d:	d3 ef                	shr    %cl,%edi
  801b4f:	09 c7                	or     %eax,%edi
  801b51:	89 e9                	mov    %ebp,%ecx
  801b53:	d3 e2                	shl    %cl,%edx
  801b55:	89 14 24             	mov    %edx,(%esp)
  801b58:	89 d8                	mov    %ebx,%eax
  801b5a:	d3 e0                	shl    %cl,%eax
  801b5c:	89 c2                	mov    %eax,%edx
  801b5e:	8b 44 24 08          	mov    0x8(%esp),%eax
  801b62:	d3 e0                	shl    %cl,%eax
  801b64:	89 44 24 04          	mov    %eax,0x4(%esp)
  801b68:	8b 44 24 08          	mov    0x8(%esp),%eax
  801b6c:	89 f1                	mov    %esi,%ecx
  801b6e:	d3 e8                	shr    %cl,%eax
  801b70:	09 d0                	or     %edx,%eax
  801b72:	d3 eb                	shr    %cl,%ebx
  801b74:	89 da                	mov    %ebx,%edx
  801b76:	f7 f7                	div    %edi
  801b78:	89 d3                	mov    %edx,%ebx
  801b7a:	f7 24 24             	mull   (%esp)
  801b7d:	89 c6                	mov    %eax,%esi
  801b7f:	89 d1                	mov    %edx,%ecx
  801b81:	39 d3                	cmp    %edx,%ebx
  801b83:	0f 82 87 00 00 00    	jb     801c10 <__umoddi3+0x134>
  801b89:	0f 84 91 00 00 00    	je     801c20 <__umoddi3+0x144>
  801b8f:	8b 54 24 04          	mov    0x4(%esp),%edx
  801b93:	29 f2                	sub    %esi,%edx
  801b95:	19 cb                	sbb    %ecx,%ebx
  801b97:	89 d8                	mov    %ebx,%eax
  801b99:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  801b9d:	d3 e0                	shl    %cl,%eax
  801b9f:	89 e9                	mov    %ebp,%ecx
  801ba1:	d3 ea                	shr    %cl,%edx
  801ba3:	09 d0                	or     %edx,%eax
  801ba5:	89 e9                	mov    %ebp,%ecx
  801ba7:	d3 eb                	shr    %cl,%ebx
  801ba9:	89 da                	mov    %ebx,%edx
  801bab:	83 c4 1c             	add    $0x1c,%esp
  801bae:	5b                   	pop    %ebx
  801baf:	5e                   	pop    %esi
  801bb0:	5f                   	pop    %edi
  801bb1:	5d                   	pop    %ebp
  801bb2:	c3                   	ret    
  801bb3:	90                   	nop
  801bb4:	89 fd                	mov    %edi,%ebp
  801bb6:	85 ff                	test   %edi,%edi
  801bb8:	75 0b                	jne    801bc5 <__umoddi3+0xe9>
  801bba:	b8 01 00 00 00       	mov    $0x1,%eax
  801bbf:	31 d2                	xor    %edx,%edx
  801bc1:	f7 f7                	div    %edi
  801bc3:	89 c5                	mov    %eax,%ebp
  801bc5:	89 f0                	mov    %esi,%eax
  801bc7:	31 d2                	xor    %edx,%edx
  801bc9:	f7 f5                	div    %ebp
  801bcb:	89 c8                	mov    %ecx,%eax
  801bcd:	f7 f5                	div    %ebp
  801bcf:	89 d0                	mov    %edx,%eax
  801bd1:	e9 44 ff ff ff       	jmp    801b1a <__umoddi3+0x3e>
  801bd6:	66 90                	xchg   %ax,%ax
  801bd8:	89 c8                	mov    %ecx,%eax
  801bda:	89 f2                	mov    %esi,%edx
  801bdc:	83 c4 1c             	add    $0x1c,%esp
  801bdf:	5b                   	pop    %ebx
  801be0:	5e                   	pop    %esi
  801be1:	5f                   	pop    %edi
  801be2:	5d                   	pop    %ebp
  801be3:	c3                   	ret    
  801be4:	3b 04 24             	cmp    (%esp),%eax
  801be7:	72 06                	jb     801bef <__umoddi3+0x113>
  801be9:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  801bed:	77 0f                	ja     801bfe <__umoddi3+0x122>
  801bef:	89 f2                	mov    %esi,%edx
  801bf1:	29 f9                	sub    %edi,%ecx
  801bf3:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  801bf7:	89 14 24             	mov    %edx,(%esp)
  801bfa:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801bfe:	8b 44 24 04          	mov    0x4(%esp),%eax
  801c02:	8b 14 24             	mov    (%esp),%edx
  801c05:	83 c4 1c             	add    $0x1c,%esp
  801c08:	5b                   	pop    %ebx
  801c09:	5e                   	pop    %esi
  801c0a:	5f                   	pop    %edi
  801c0b:	5d                   	pop    %ebp
  801c0c:	c3                   	ret    
  801c0d:	8d 76 00             	lea    0x0(%esi),%esi
  801c10:	2b 04 24             	sub    (%esp),%eax
  801c13:	19 fa                	sbb    %edi,%edx
  801c15:	89 d1                	mov    %edx,%ecx
  801c17:	89 c6                	mov    %eax,%esi
  801c19:	e9 71 ff ff ff       	jmp    801b8f <__umoddi3+0xb3>
  801c1e:	66 90                	xchg   %ax,%ax
  801c20:	39 44 24 04          	cmp    %eax,0x4(%esp)
  801c24:	72 ea                	jb     801c10 <__umoddi3+0x134>
  801c26:	89 d9                	mov    %ebx,%ecx
  801c28:	e9 62 ff ff ff       	jmp    801b8f <__umoddi3+0xb3>
