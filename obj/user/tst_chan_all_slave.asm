
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
  800041:	e8 a8 14 00 00       	call   8014ee <sys_getenvid>
  800046:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	//Sleep on the channel
	char cmd[64] = "__Sleep__";
  800049:	8d 45 a4             	lea    -0x5c(%ebp),%eax
  80004c:	bb 3a 1c 80 00       	mov    $0x801c3a,%ebx
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
  800075:	e8 c3 16 00 00       	call   80173d <sys_utilities>
  80007a:	83 c4 10             	add    $0x10,%esp

	//indicates wakenup
	inctst();
  80007d:	e8 c3 15 00 00       	call   801645 <inctst>

	cprintf_colored(TEXT_light_magenta, ">>> Slave %d is Finished\n", envID);
  800082:	83 ec 04             	sub    $0x4,%esp
  800085:	ff 75 e4             	pushl  -0x1c(%ebp)
  800088:	68 20 1c 80 00       	push   $0x801c20
  80008d:	6a 0d                	push   $0xd
  80008f:	e8 d3 02 00 00       	call   800367 <cprintf_colored>
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
  8000b3:	e8 4f 14 00 00       	call   801507 <sys_getenvindex>
  8000b8:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	myEnv = &(envs[envIndex]);
  8000bb:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8000be:	89 d0                	mov    %edx,%eax
  8000c0:	c1 e0 02             	shl    $0x2,%eax
  8000c3:	01 d0                	add    %edx,%eax
  8000c5:	c1 e0 03             	shl    $0x3,%eax
  8000c8:	01 d0                	add    %edx,%eax
  8000ca:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  8000d1:	01 d0                	add    %edx,%eax
  8000d3:	c1 e0 02             	shl    $0x2,%eax
  8000d6:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8000db:	a3 20 30 80 00       	mov    %eax,0x803020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  8000e0:	a1 20 30 80 00       	mov    0x803020,%eax
  8000e5:	8a 40 20             	mov    0x20(%eax),%al
  8000e8:	84 c0                	test   %al,%al
  8000ea:	74 0d                	je     8000f9 <libmain+0x4f>
		binaryname = myEnv->prog_name;
  8000ec:	a1 20 30 80 00       	mov    0x803020,%eax
  8000f1:	83 c0 20             	add    $0x20,%eax
  8000f4:	a3 04 30 80 00       	mov    %eax,0x803004

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8000f9:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8000fd:	7e 0a                	jle    800109 <libmain+0x5f>
		binaryname = argv[0];
  8000ff:	8b 45 0c             	mov    0xc(%ebp),%eax
  800102:	8b 00                	mov    (%eax),%eax
  800104:	a3 04 30 80 00       	mov    %eax,0x803004

	// call user main routine
	_main(argc, argv);
  800109:	83 ec 08             	sub    $0x8,%esp
  80010c:	ff 75 0c             	pushl  0xc(%ebp)
  80010f:	ff 75 08             	pushl  0x8(%ebp)
  800112:	e8 21 ff ff ff       	call   800038 <_main>
  800117:	83 c4 10             	add    $0x10,%esp

	if (printStats)
  80011a:	a1 00 30 80 00       	mov    0x803000,%eax
  80011f:	85 c0                	test   %eax,%eax
  800121:	0f 84 01 01 00 00    	je     800228 <libmain+0x17e>
	{
		char isOPTReplCmd[100] = "__IsOPTRepl__" ;
  800127:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  80012d:	bb 74 1d 80 00       	mov    $0x801d74,%ebx
  800132:	ba 0e 00 00 00       	mov    $0xe,%edx
  800137:	89 c7                	mov    %eax,%edi
  800139:	89 de                	mov    %ebx,%esi
  80013b:	89 d1                	mov    %edx,%ecx
  80013d:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  80013f:	8d 55 8a             	lea    -0x76(%ebp),%edx
  800142:	b9 56 00 00 00       	mov    $0x56,%ecx
  800147:	b0 00                	mov    $0x0,%al
  800149:	89 d7                	mov    %edx,%edi
  80014b:	f3 aa                	rep stos %al,%es:(%edi)
		int isOPTRepl = 0;
  80014d:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
		sys_utilities(isOPTReplCmd, (uint32)(&isOPTRepl));
  800154:	8d 45 e0             	lea    -0x20(%ebp),%eax
  800157:	83 ec 08             	sub    $0x8,%esp
  80015a:	50                   	push   %eax
  80015b:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  800161:	50                   	push   %eax
  800162:	e8 d6 15 00 00       	call   80173d <sys_utilities>
  800167:	83 c4 10             	add    $0x10,%esp

		sys_lock_cons();
  80016a:	e8 1f 11 00 00       	call   80128e <sys_lock_cons>
		{
			cprintf("**************************************\n");
  80016f:	83 ec 0c             	sub    $0xc,%esp
  800172:	68 94 1c 80 00       	push   $0x801c94
  800177:	e8 be 01 00 00       	call   80033a <cprintf>
  80017c:	83 c4 10             	add    $0x10,%esp
			if (isOPTRepl)
  80017f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800182:	85 c0                	test   %eax,%eax
  800184:	74 18                	je     80019e <libmain+0xf4>
			{
				cprintf("OPTIMAL number of page faults = %d\n", sys_get_optimal_num_faults());
  800186:	e8 d0 15 00 00       	call   80175b <sys_get_optimal_num_faults>
  80018b:	83 ec 08             	sub    $0x8,%esp
  80018e:	50                   	push   %eax
  80018f:	68 bc 1c 80 00       	push   $0x801cbc
  800194:	e8 a1 01 00 00       	call   80033a <cprintf>
  800199:	83 c4 10             	add    $0x10,%esp
  80019c:	eb 59                	jmp    8001f7 <libmain+0x14d>
			}
			else
			{
				cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  80019e:	a1 20 30 80 00       	mov    0x803020,%eax
  8001a3:	8b 90 a8 05 00 00    	mov    0x5a8(%eax),%edx
  8001a9:	a1 20 30 80 00       	mov    0x803020,%eax
  8001ae:	8b 80 98 05 00 00    	mov    0x598(%eax),%eax
  8001b4:	83 ec 04             	sub    $0x4,%esp
  8001b7:	52                   	push   %edx
  8001b8:	50                   	push   %eax
  8001b9:	68 e0 1c 80 00       	push   $0x801ce0
  8001be:	e8 77 01 00 00       	call   80033a <cprintf>
  8001c3:	83 c4 10             	add    $0x10,%esp
				cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  8001c6:	a1 20 30 80 00       	mov    0x803020,%eax
  8001cb:	8b 88 bc 05 00 00    	mov    0x5bc(%eax),%ecx
  8001d1:	a1 20 30 80 00       	mov    0x803020,%eax
  8001d6:	8b 90 b8 05 00 00    	mov    0x5b8(%eax),%edx
  8001dc:	a1 20 30 80 00       	mov    0x803020,%eax
  8001e1:	8b 80 b4 05 00 00    	mov    0x5b4(%eax),%eax
  8001e7:	51                   	push   %ecx
  8001e8:	52                   	push   %edx
  8001e9:	50                   	push   %eax
  8001ea:	68 08 1d 80 00       	push   $0x801d08
  8001ef:	e8 46 01 00 00       	call   80033a <cprintf>
  8001f4:	83 c4 10             	add    $0x10,%esp
			}
			//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
			cprintf("Num of clocks = %d\n", myEnv->nClocks);
  8001f7:	a1 20 30 80 00       	mov    0x803020,%eax
  8001fc:	8b 80 c0 05 00 00    	mov    0x5c0(%eax),%eax
  800202:	83 ec 08             	sub    $0x8,%esp
  800205:	50                   	push   %eax
  800206:	68 60 1d 80 00       	push   $0x801d60
  80020b:	e8 2a 01 00 00       	call   80033a <cprintf>
  800210:	83 c4 10             	add    $0x10,%esp
			cprintf("**************************************\n");
  800213:	83 ec 0c             	sub    $0xc,%esp
  800216:	68 94 1c 80 00       	push   $0x801c94
  80021b:	e8 1a 01 00 00       	call   80033a <cprintf>
  800220:	83 c4 10             	add    $0x10,%esp
		}
		sys_unlock_cons();
  800223:	e8 80 10 00 00       	call   8012a8 <sys_unlock_cons>
	}

	// exit gracefully
	exit();
  800228:	e8 1f 00 00 00       	call   80024c <exit>
}
  80022d:	90                   	nop
  80022e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800231:	5b                   	pop    %ebx
  800232:	5e                   	pop    %esi
  800233:	5f                   	pop    %edi
  800234:	5d                   	pop    %ebp
  800235:	c3                   	ret    

00800236 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800236:	55                   	push   %ebp
  800237:	89 e5                	mov    %esp,%ebp
  800239:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  80023c:	83 ec 0c             	sub    $0xc,%esp
  80023f:	6a 00                	push   $0x0
  800241:	e8 8d 12 00 00       	call   8014d3 <sys_destroy_env>
  800246:	83 c4 10             	add    $0x10,%esp
}
  800249:	90                   	nop
  80024a:	c9                   	leave  
  80024b:	c3                   	ret    

0080024c <exit>:

void
exit(void)
{
  80024c:	55                   	push   %ebp
  80024d:	89 e5                	mov    %esp,%ebp
  80024f:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  800252:	e8 e2 12 00 00       	call   801539 <sys_exit_env>
}
  800257:	90                   	nop
  800258:	c9                   	leave  
  800259:	c3                   	ret    

0080025a <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  80025a:	55                   	push   %ebp
  80025b:	89 e5                	mov    %esp,%ebp
  80025d:	53                   	push   %ebx
  80025e:	83 ec 04             	sub    $0x4,%esp
	b->buf[b->idx++] = ch;
  800261:	8b 45 0c             	mov    0xc(%ebp),%eax
  800264:	8b 00                	mov    (%eax),%eax
  800266:	8d 48 01             	lea    0x1(%eax),%ecx
  800269:	8b 55 0c             	mov    0xc(%ebp),%edx
  80026c:	89 0a                	mov    %ecx,(%edx)
  80026e:	8b 55 08             	mov    0x8(%ebp),%edx
  800271:	88 d1                	mov    %dl,%cl
  800273:	8b 55 0c             	mov    0xc(%ebp),%edx
  800276:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  80027a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80027d:	8b 00                	mov    (%eax),%eax
  80027f:	3d ff 00 00 00       	cmp    $0xff,%eax
  800284:	75 30                	jne    8002b6 <putch+0x5c>
		sys_cputs(b->buf, b->idx, printProgName, curTextClr);
  800286:	8b 15 18 b1 81 00    	mov    0x81b118,%edx
  80028c:	a0 44 30 80 00       	mov    0x803044,%al
  800291:	0f b6 c0             	movzbl %al,%eax
  800294:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800297:	8b 09                	mov    (%ecx),%ecx
  800299:	89 cb                	mov    %ecx,%ebx
  80029b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80029e:	83 c1 08             	add    $0x8,%ecx
  8002a1:	52                   	push   %edx
  8002a2:	50                   	push   %eax
  8002a3:	53                   	push   %ebx
  8002a4:	51                   	push   %ecx
  8002a5:	e8 a0 0f 00 00       	call   80124a <sys_cputs>
  8002aa:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8002ad:	8b 45 0c             	mov    0xc(%ebp),%eax
  8002b0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8002b6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8002b9:	8b 40 04             	mov    0x4(%eax),%eax
  8002bc:	8d 50 01             	lea    0x1(%eax),%edx
  8002bf:	8b 45 0c             	mov    0xc(%ebp),%eax
  8002c2:	89 50 04             	mov    %edx,0x4(%eax)
}
  8002c5:	90                   	nop
  8002c6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8002c9:	c9                   	leave  
  8002ca:	c3                   	ret    

008002cb <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  8002cb:	55                   	push   %ebp
  8002cc:	89 e5                	mov    %esp,%ebp
  8002ce:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8002d4:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8002db:	00 00 00 
	b.cnt = 0;
  8002de:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8002e5:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  8002e8:	ff 75 0c             	pushl  0xc(%ebp)
  8002eb:	ff 75 08             	pushl  0x8(%ebp)
  8002ee:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8002f4:	50                   	push   %eax
  8002f5:	68 5a 02 80 00       	push   $0x80025a
  8002fa:	e8 5a 02 00 00       	call   800559 <vprintfmt>
  8002ff:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName, curTextClr);
  800302:	8b 15 18 b1 81 00    	mov    0x81b118,%edx
  800308:	a0 44 30 80 00       	mov    0x803044,%al
  80030d:	0f b6 c0             	movzbl %al,%eax
  800310:	8b 8d f0 fe ff ff    	mov    -0x110(%ebp),%ecx
  800316:	52                   	push   %edx
  800317:	50                   	push   %eax
  800318:	51                   	push   %ecx
  800319:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80031f:	83 c0 08             	add    $0x8,%eax
  800322:	50                   	push   %eax
  800323:	e8 22 0f 00 00       	call   80124a <sys_cputs>
  800328:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  80032b:	c6 05 44 30 80 00 00 	movb   $0x0,0x803044
	return b.cnt;
  800332:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800338:	c9                   	leave  
  800339:	c3                   	ret    

0080033a <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  80033a:	55                   	push   %ebp
  80033b:	89 e5                	mov    %esp,%ebp
  80033d:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800340:	c6 05 44 30 80 00 01 	movb   $0x1,0x803044
	va_start(ap, fmt);
  800347:	8d 45 0c             	lea    0xc(%ebp),%eax
  80034a:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  80034d:	8b 45 08             	mov    0x8(%ebp),%eax
  800350:	83 ec 08             	sub    $0x8,%esp
  800353:	ff 75 f4             	pushl  -0xc(%ebp)
  800356:	50                   	push   %eax
  800357:	e8 6f ff ff ff       	call   8002cb <vcprintf>
  80035c:	83 c4 10             	add    $0x10,%esp
  80035f:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800362:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800365:	c9                   	leave  
  800366:	c3                   	ret    

00800367 <cprintf_colored>:

// *************** This text coloring feature is implemented by *************
// ********** Abd-Alrahman Zedan From Team Frozen-Bytes - FCIS'24-25 ********
int cprintf_colored(int textClr, const char *fmt, ...) {
  800367:	55                   	push   %ebp
  800368:	89 e5                	mov    %esp,%ebp
  80036a:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  80036d:	c6 05 44 30 80 00 01 	movb   $0x1,0x803044
	curTextClr = (textClr << 8) ; //set text color by the given value
  800374:	8b 45 08             	mov    0x8(%ebp),%eax
  800377:	c1 e0 08             	shl    $0x8,%eax
  80037a:	a3 18 b1 81 00       	mov    %eax,0x81b118
	va_start(ap, fmt);
  80037f:	8d 45 0c             	lea    0xc(%ebp),%eax
  800382:	83 c0 04             	add    $0x4,%eax
  800385:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800388:	8b 45 0c             	mov    0xc(%ebp),%eax
  80038b:	83 ec 08             	sub    $0x8,%esp
  80038e:	ff 75 f4             	pushl  -0xc(%ebp)
  800391:	50                   	push   %eax
  800392:	e8 34 ff ff ff       	call   8002cb <vcprintf>
  800397:	83 c4 10             	add    $0x10,%esp
  80039a:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);
	curTextClr = TEXT_DEFAULT_CLR; //restore default color
  80039d:	c7 05 18 b1 81 00 00 	movl   $0x700,0x81b118
  8003a4:	07 00 00 

	return cnt;
  8003a7:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8003aa:	c9                   	leave  
  8003ab:	c3                   	ret    

008003ac <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  8003ac:	55                   	push   %ebp
  8003ad:	89 e5                	mov    %esp,%ebp
  8003af:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  8003b2:	e8 d7 0e 00 00       	call   80128e <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  8003b7:	8d 45 0c             	lea    0xc(%ebp),%eax
  8003ba:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  8003bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8003c0:	83 ec 08             	sub    $0x8,%esp
  8003c3:	ff 75 f4             	pushl  -0xc(%ebp)
  8003c6:	50                   	push   %eax
  8003c7:	e8 ff fe ff ff       	call   8002cb <vcprintf>
  8003cc:	83 c4 10             	add    $0x10,%esp
  8003cf:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  8003d2:	e8 d1 0e 00 00       	call   8012a8 <sys_unlock_cons>
	return cnt;
  8003d7:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8003da:	c9                   	leave  
  8003db:	c3                   	ret    

008003dc <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8003dc:	55                   	push   %ebp
  8003dd:	89 e5                	mov    %esp,%ebp
  8003df:	53                   	push   %ebx
  8003e0:	83 ec 14             	sub    $0x14,%esp
  8003e3:	8b 45 10             	mov    0x10(%ebp),%eax
  8003e6:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8003e9:	8b 45 14             	mov    0x14(%ebp),%eax
  8003ec:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8003ef:	8b 45 18             	mov    0x18(%ebp),%eax
  8003f2:	ba 00 00 00 00       	mov    $0x0,%edx
  8003f7:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8003fa:	77 55                	ja     800451 <printnum+0x75>
  8003fc:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8003ff:	72 05                	jb     800406 <printnum+0x2a>
  800401:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800404:	77 4b                	ja     800451 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800406:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800409:	8d 58 ff             	lea    -0x1(%eax),%ebx
  80040c:	8b 45 18             	mov    0x18(%ebp),%eax
  80040f:	ba 00 00 00 00       	mov    $0x0,%edx
  800414:	52                   	push   %edx
  800415:	50                   	push   %eax
  800416:	ff 75 f4             	pushl  -0xc(%ebp)
  800419:	ff 75 f0             	pushl  -0x10(%ebp)
  80041c:	e8 97 15 00 00       	call   8019b8 <__udivdi3>
  800421:	83 c4 10             	add    $0x10,%esp
  800424:	83 ec 04             	sub    $0x4,%esp
  800427:	ff 75 20             	pushl  0x20(%ebp)
  80042a:	53                   	push   %ebx
  80042b:	ff 75 18             	pushl  0x18(%ebp)
  80042e:	52                   	push   %edx
  80042f:	50                   	push   %eax
  800430:	ff 75 0c             	pushl  0xc(%ebp)
  800433:	ff 75 08             	pushl  0x8(%ebp)
  800436:	e8 a1 ff ff ff       	call   8003dc <printnum>
  80043b:	83 c4 20             	add    $0x20,%esp
  80043e:	eb 1a                	jmp    80045a <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800440:	83 ec 08             	sub    $0x8,%esp
  800443:	ff 75 0c             	pushl  0xc(%ebp)
  800446:	ff 75 20             	pushl  0x20(%ebp)
  800449:	8b 45 08             	mov    0x8(%ebp),%eax
  80044c:	ff d0                	call   *%eax
  80044e:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800451:	ff 4d 1c             	decl   0x1c(%ebp)
  800454:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800458:	7f e6                	jg     800440 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80045a:	8b 4d 18             	mov    0x18(%ebp),%ecx
  80045d:	bb 00 00 00 00       	mov    $0x0,%ebx
  800462:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800465:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800468:	53                   	push   %ebx
  800469:	51                   	push   %ecx
  80046a:	52                   	push   %edx
  80046b:	50                   	push   %eax
  80046c:	e8 57 16 00 00       	call   801ac8 <__umoddi3>
  800471:	83 c4 10             	add    $0x10,%esp
  800474:	05 f4 1f 80 00       	add    $0x801ff4,%eax
  800479:	8a 00                	mov    (%eax),%al
  80047b:	0f be c0             	movsbl %al,%eax
  80047e:	83 ec 08             	sub    $0x8,%esp
  800481:	ff 75 0c             	pushl  0xc(%ebp)
  800484:	50                   	push   %eax
  800485:	8b 45 08             	mov    0x8(%ebp),%eax
  800488:	ff d0                	call   *%eax
  80048a:	83 c4 10             	add    $0x10,%esp
}
  80048d:	90                   	nop
  80048e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800491:	c9                   	leave  
  800492:	c3                   	ret    

00800493 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800493:	55                   	push   %ebp
  800494:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800496:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  80049a:	7e 1c                	jle    8004b8 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  80049c:	8b 45 08             	mov    0x8(%ebp),%eax
  80049f:	8b 00                	mov    (%eax),%eax
  8004a1:	8d 50 08             	lea    0x8(%eax),%edx
  8004a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8004a7:	89 10                	mov    %edx,(%eax)
  8004a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8004ac:	8b 00                	mov    (%eax),%eax
  8004ae:	83 e8 08             	sub    $0x8,%eax
  8004b1:	8b 50 04             	mov    0x4(%eax),%edx
  8004b4:	8b 00                	mov    (%eax),%eax
  8004b6:	eb 40                	jmp    8004f8 <getuint+0x65>
	else if (lflag)
  8004b8:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8004bc:	74 1e                	je     8004dc <getuint+0x49>
		return va_arg(*ap, unsigned long);
  8004be:	8b 45 08             	mov    0x8(%ebp),%eax
  8004c1:	8b 00                	mov    (%eax),%eax
  8004c3:	8d 50 04             	lea    0x4(%eax),%edx
  8004c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8004c9:	89 10                	mov    %edx,(%eax)
  8004cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8004ce:	8b 00                	mov    (%eax),%eax
  8004d0:	83 e8 04             	sub    $0x4,%eax
  8004d3:	8b 00                	mov    (%eax),%eax
  8004d5:	ba 00 00 00 00       	mov    $0x0,%edx
  8004da:	eb 1c                	jmp    8004f8 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  8004dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8004df:	8b 00                	mov    (%eax),%eax
  8004e1:	8d 50 04             	lea    0x4(%eax),%edx
  8004e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8004e7:	89 10                	mov    %edx,(%eax)
  8004e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8004ec:	8b 00                	mov    (%eax),%eax
  8004ee:	83 e8 04             	sub    $0x4,%eax
  8004f1:	8b 00                	mov    (%eax),%eax
  8004f3:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8004f8:	5d                   	pop    %ebp
  8004f9:	c3                   	ret    

008004fa <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8004fa:	55                   	push   %ebp
  8004fb:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8004fd:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800501:	7e 1c                	jle    80051f <getint+0x25>
		return va_arg(*ap, long long);
  800503:	8b 45 08             	mov    0x8(%ebp),%eax
  800506:	8b 00                	mov    (%eax),%eax
  800508:	8d 50 08             	lea    0x8(%eax),%edx
  80050b:	8b 45 08             	mov    0x8(%ebp),%eax
  80050e:	89 10                	mov    %edx,(%eax)
  800510:	8b 45 08             	mov    0x8(%ebp),%eax
  800513:	8b 00                	mov    (%eax),%eax
  800515:	83 e8 08             	sub    $0x8,%eax
  800518:	8b 50 04             	mov    0x4(%eax),%edx
  80051b:	8b 00                	mov    (%eax),%eax
  80051d:	eb 38                	jmp    800557 <getint+0x5d>
	else if (lflag)
  80051f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800523:	74 1a                	je     80053f <getint+0x45>
		return va_arg(*ap, long);
  800525:	8b 45 08             	mov    0x8(%ebp),%eax
  800528:	8b 00                	mov    (%eax),%eax
  80052a:	8d 50 04             	lea    0x4(%eax),%edx
  80052d:	8b 45 08             	mov    0x8(%ebp),%eax
  800530:	89 10                	mov    %edx,(%eax)
  800532:	8b 45 08             	mov    0x8(%ebp),%eax
  800535:	8b 00                	mov    (%eax),%eax
  800537:	83 e8 04             	sub    $0x4,%eax
  80053a:	8b 00                	mov    (%eax),%eax
  80053c:	99                   	cltd   
  80053d:	eb 18                	jmp    800557 <getint+0x5d>
	else
		return va_arg(*ap, int);
  80053f:	8b 45 08             	mov    0x8(%ebp),%eax
  800542:	8b 00                	mov    (%eax),%eax
  800544:	8d 50 04             	lea    0x4(%eax),%edx
  800547:	8b 45 08             	mov    0x8(%ebp),%eax
  80054a:	89 10                	mov    %edx,(%eax)
  80054c:	8b 45 08             	mov    0x8(%ebp),%eax
  80054f:	8b 00                	mov    (%eax),%eax
  800551:	83 e8 04             	sub    $0x4,%eax
  800554:	8b 00                	mov    (%eax),%eax
  800556:	99                   	cltd   
}
  800557:	5d                   	pop    %ebp
  800558:	c3                   	ret    

00800559 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800559:	55                   	push   %ebp
  80055a:	89 e5                	mov    %esp,%ebp
  80055c:	56                   	push   %esi
  80055d:	53                   	push   %ebx
  80055e:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800561:	eb 17                	jmp    80057a <vprintfmt+0x21>
			if (ch == '\0')
  800563:	85 db                	test   %ebx,%ebx
  800565:	0f 84 c1 03 00 00    	je     80092c <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  80056b:	83 ec 08             	sub    $0x8,%esp
  80056e:	ff 75 0c             	pushl  0xc(%ebp)
  800571:	53                   	push   %ebx
  800572:	8b 45 08             	mov    0x8(%ebp),%eax
  800575:	ff d0                	call   *%eax
  800577:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80057a:	8b 45 10             	mov    0x10(%ebp),%eax
  80057d:	8d 50 01             	lea    0x1(%eax),%edx
  800580:	89 55 10             	mov    %edx,0x10(%ebp)
  800583:	8a 00                	mov    (%eax),%al
  800585:	0f b6 d8             	movzbl %al,%ebx
  800588:	83 fb 25             	cmp    $0x25,%ebx
  80058b:	75 d6                	jne    800563 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  80058d:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800591:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800598:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  80059f:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  8005a6:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8005ad:	8b 45 10             	mov    0x10(%ebp),%eax
  8005b0:	8d 50 01             	lea    0x1(%eax),%edx
  8005b3:	89 55 10             	mov    %edx,0x10(%ebp)
  8005b6:	8a 00                	mov    (%eax),%al
  8005b8:	0f b6 d8             	movzbl %al,%ebx
  8005bb:	8d 43 dd             	lea    -0x23(%ebx),%eax
  8005be:	83 f8 5b             	cmp    $0x5b,%eax
  8005c1:	0f 87 3d 03 00 00    	ja     800904 <vprintfmt+0x3ab>
  8005c7:	8b 04 85 18 20 80 00 	mov    0x802018(,%eax,4),%eax
  8005ce:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  8005d0:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  8005d4:	eb d7                	jmp    8005ad <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8005d6:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  8005da:	eb d1                	jmp    8005ad <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8005dc:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  8005e3:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8005e6:	89 d0                	mov    %edx,%eax
  8005e8:	c1 e0 02             	shl    $0x2,%eax
  8005eb:	01 d0                	add    %edx,%eax
  8005ed:	01 c0                	add    %eax,%eax
  8005ef:	01 d8                	add    %ebx,%eax
  8005f1:	83 e8 30             	sub    $0x30,%eax
  8005f4:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  8005f7:	8b 45 10             	mov    0x10(%ebp),%eax
  8005fa:	8a 00                	mov    (%eax),%al
  8005fc:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8005ff:	83 fb 2f             	cmp    $0x2f,%ebx
  800602:	7e 3e                	jle    800642 <vprintfmt+0xe9>
  800604:	83 fb 39             	cmp    $0x39,%ebx
  800607:	7f 39                	jg     800642 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800609:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  80060c:	eb d5                	jmp    8005e3 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  80060e:	8b 45 14             	mov    0x14(%ebp),%eax
  800611:	83 c0 04             	add    $0x4,%eax
  800614:	89 45 14             	mov    %eax,0x14(%ebp)
  800617:	8b 45 14             	mov    0x14(%ebp),%eax
  80061a:	83 e8 04             	sub    $0x4,%eax
  80061d:	8b 00                	mov    (%eax),%eax
  80061f:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800622:	eb 1f                	jmp    800643 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800624:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800628:	79 83                	jns    8005ad <vprintfmt+0x54>
				width = 0;
  80062a:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800631:	e9 77 ff ff ff       	jmp    8005ad <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800636:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  80063d:	e9 6b ff ff ff       	jmp    8005ad <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800642:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800643:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800647:	0f 89 60 ff ff ff    	jns    8005ad <vprintfmt+0x54>
				width = precision, precision = -1;
  80064d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800650:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800653:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  80065a:	e9 4e ff ff ff       	jmp    8005ad <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  80065f:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800662:	e9 46 ff ff ff       	jmp    8005ad <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800667:	8b 45 14             	mov    0x14(%ebp),%eax
  80066a:	83 c0 04             	add    $0x4,%eax
  80066d:	89 45 14             	mov    %eax,0x14(%ebp)
  800670:	8b 45 14             	mov    0x14(%ebp),%eax
  800673:	83 e8 04             	sub    $0x4,%eax
  800676:	8b 00                	mov    (%eax),%eax
  800678:	83 ec 08             	sub    $0x8,%esp
  80067b:	ff 75 0c             	pushl  0xc(%ebp)
  80067e:	50                   	push   %eax
  80067f:	8b 45 08             	mov    0x8(%ebp),%eax
  800682:	ff d0                	call   *%eax
  800684:	83 c4 10             	add    $0x10,%esp
			break;
  800687:	e9 9b 02 00 00       	jmp    800927 <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  80068c:	8b 45 14             	mov    0x14(%ebp),%eax
  80068f:	83 c0 04             	add    $0x4,%eax
  800692:	89 45 14             	mov    %eax,0x14(%ebp)
  800695:	8b 45 14             	mov    0x14(%ebp),%eax
  800698:	83 e8 04             	sub    $0x4,%eax
  80069b:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  80069d:	85 db                	test   %ebx,%ebx
  80069f:	79 02                	jns    8006a3 <vprintfmt+0x14a>
				err = -err;
  8006a1:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  8006a3:	83 fb 64             	cmp    $0x64,%ebx
  8006a6:	7f 0b                	jg     8006b3 <vprintfmt+0x15a>
  8006a8:	8b 34 9d 60 1e 80 00 	mov    0x801e60(,%ebx,4),%esi
  8006af:	85 f6                	test   %esi,%esi
  8006b1:	75 19                	jne    8006cc <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  8006b3:	53                   	push   %ebx
  8006b4:	68 05 20 80 00       	push   $0x802005
  8006b9:	ff 75 0c             	pushl  0xc(%ebp)
  8006bc:	ff 75 08             	pushl  0x8(%ebp)
  8006bf:	e8 70 02 00 00       	call   800934 <printfmt>
  8006c4:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  8006c7:	e9 5b 02 00 00       	jmp    800927 <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  8006cc:	56                   	push   %esi
  8006cd:	68 0e 20 80 00       	push   $0x80200e
  8006d2:	ff 75 0c             	pushl  0xc(%ebp)
  8006d5:	ff 75 08             	pushl  0x8(%ebp)
  8006d8:	e8 57 02 00 00       	call   800934 <printfmt>
  8006dd:	83 c4 10             	add    $0x10,%esp
			break;
  8006e0:	e9 42 02 00 00       	jmp    800927 <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  8006e5:	8b 45 14             	mov    0x14(%ebp),%eax
  8006e8:	83 c0 04             	add    $0x4,%eax
  8006eb:	89 45 14             	mov    %eax,0x14(%ebp)
  8006ee:	8b 45 14             	mov    0x14(%ebp),%eax
  8006f1:	83 e8 04             	sub    $0x4,%eax
  8006f4:	8b 30                	mov    (%eax),%esi
  8006f6:	85 f6                	test   %esi,%esi
  8006f8:	75 05                	jne    8006ff <vprintfmt+0x1a6>
				p = "(null)";
  8006fa:	be 11 20 80 00       	mov    $0x802011,%esi
			if (width > 0 && padc != '-')
  8006ff:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800703:	7e 6d                	jle    800772 <vprintfmt+0x219>
  800705:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800709:	74 67                	je     800772 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  80070b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80070e:	83 ec 08             	sub    $0x8,%esp
  800711:	50                   	push   %eax
  800712:	56                   	push   %esi
  800713:	e8 1e 03 00 00       	call   800a36 <strnlen>
  800718:	83 c4 10             	add    $0x10,%esp
  80071b:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  80071e:	eb 16                	jmp    800736 <vprintfmt+0x1dd>
					putch(padc, putdat);
  800720:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800724:	83 ec 08             	sub    $0x8,%esp
  800727:	ff 75 0c             	pushl  0xc(%ebp)
  80072a:	50                   	push   %eax
  80072b:	8b 45 08             	mov    0x8(%ebp),%eax
  80072e:	ff d0                	call   *%eax
  800730:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800733:	ff 4d e4             	decl   -0x1c(%ebp)
  800736:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80073a:	7f e4                	jg     800720 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80073c:	eb 34                	jmp    800772 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  80073e:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800742:	74 1c                	je     800760 <vprintfmt+0x207>
  800744:	83 fb 1f             	cmp    $0x1f,%ebx
  800747:	7e 05                	jle    80074e <vprintfmt+0x1f5>
  800749:	83 fb 7e             	cmp    $0x7e,%ebx
  80074c:	7e 12                	jle    800760 <vprintfmt+0x207>
					putch('?', putdat);
  80074e:	83 ec 08             	sub    $0x8,%esp
  800751:	ff 75 0c             	pushl  0xc(%ebp)
  800754:	6a 3f                	push   $0x3f
  800756:	8b 45 08             	mov    0x8(%ebp),%eax
  800759:	ff d0                	call   *%eax
  80075b:	83 c4 10             	add    $0x10,%esp
  80075e:	eb 0f                	jmp    80076f <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800760:	83 ec 08             	sub    $0x8,%esp
  800763:	ff 75 0c             	pushl  0xc(%ebp)
  800766:	53                   	push   %ebx
  800767:	8b 45 08             	mov    0x8(%ebp),%eax
  80076a:	ff d0                	call   *%eax
  80076c:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80076f:	ff 4d e4             	decl   -0x1c(%ebp)
  800772:	89 f0                	mov    %esi,%eax
  800774:	8d 70 01             	lea    0x1(%eax),%esi
  800777:	8a 00                	mov    (%eax),%al
  800779:	0f be d8             	movsbl %al,%ebx
  80077c:	85 db                	test   %ebx,%ebx
  80077e:	74 24                	je     8007a4 <vprintfmt+0x24b>
  800780:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800784:	78 b8                	js     80073e <vprintfmt+0x1e5>
  800786:	ff 4d e0             	decl   -0x20(%ebp)
  800789:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80078d:	79 af                	jns    80073e <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  80078f:	eb 13                	jmp    8007a4 <vprintfmt+0x24b>
				putch(' ', putdat);
  800791:	83 ec 08             	sub    $0x8,%esp
  800794:	ff 75 0c             	pushl  0xc(%ebp)
  800797:	6a 20                	push   $0x20
  800799:	8b 45 08             	mov    0x8(%ebp),%eax
  80079c:	ff d0                	call   *%eax
  80079e:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8007a1:	ff 4d e4             	decl   -0x1c(%ebp)
  8007a4:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8007a8:	7f e7                	jg     800791 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  8007aa:	e9 78 01 00 00       	jmp    800927 <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  8007af:	83 ec 08             	sub    $0x8,%esp
  8007b2:	ff 75 e8             	pushl  -0x18(%ebp)
  8007b5:	8d 45 14             	lea    0x14(%ebp),%eax
  8007b8:	50                   	push   %eax
  8007b9:	e8 3c fd ff ff       	call   8004fa <getint>
  8007be:	83 c4 10             	add    $0x10,%esp
  8007c1:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8007c4:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  8007c7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8007ca:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8007cd:	85 d2                	test   %edx,%edx
  8007cf:	79 23                	jns    8007f4 <vprintfmt+0x29b>
				putch('-', putdat);
  8007d1:	83 ec 08             	sub    $0x8,%esp
  8007d4:	ff 75 0c             	pushl  0xc(%ebp)
  8007d7:	6a 2d                	push   $0x2d
  8007d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8007dc:	ff d0                	call   *%eax
  8007de:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  8007e1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8007e4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8007e7:	f7 d8                	neg    %eax
  8007e9:	83 d2 00             	adc    $0x0,%edx
  8007ec:	f7 da                	neg    %edx
  8007ee:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8007f1:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  8007f4:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8007fb:	e9 bc 00 00 00       	jmp    8008bc <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800800:	83 ec 08             	sub    $0x8,%esp
  800803:	ff 75 e8             	pushl  -0x18(%ebp)
  800806:	8d 45 14             	lea    0x14(%ebp),%eax
  800809:	50                   	push   %eax
  80080a:	e8 84 fc ff ff       	call   800493 <getuint>
  80080f:	83 c4 10             	add    $0x10,%esp
  800812:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800815:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800818:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  80081f:	e9 98 00 00 00       	jmp    8008bc <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800824:	83 ec 08             	sub    $0x8,%esp
  800827:	ff 75 0c             	pushl  0xc(%ebp)
  80082a:	6a 58                	push   $0x58
  80082c:	8b 45 08             	mov    0x8(%ebp),%eax
  80082f:	ff d0                	call   *%eax
  800831:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800834:	83 ec 08             	sub    $0x8,%esp
  800837:	ff 75 0c             	pushl  0xc(%ebp)
  80083a:	6a 58                	push   $0x58
  80083c:	8b 45 08             	mov    0x8(%ebp),%eax
  80083f:	ff d0                	call   *%eax
  800841:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800844:	83 ec 08             	sub    $0x8,%esp
  800847:	ff 75 0c             	pushl  0xc(%ebp)
  80084a:	6a 58                	push   $0x58
  80084c:	8b 45 08             	mov    0x8(%ebp),%eax
  80084f:	ff d0                	call   *%eax
  800851:	83 c4 10             	add    $0x10,%esp
			break;
  800854:	e9 ce 00 00 00       	jmp    800927 <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  800859:	83 ec 08             	sub    $0x8,%esp
  80085c:	ff 75 0c             	pushl  0xc(%ebp)
  80085f:	6a 30                	push   $0x30
  800861:	8b 45 08             	mov    0x8(%ebp),%eax
  800864:	ff d0                	call   *%eax
  800866:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800869:	83 ec 08             	sub    $0x8,%esp
  80086c:	ff 75 0c             	pushl  0xc(%ebp)
  80086f:	6a 78                	push   $0x78
  800871:	8b 45 08             	mov    0x8(%ebp),%eax
  800874:	ff d0                	call   *%eax
  800876:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800879:	8b 45 14             	mov    0x14(%ebp),%eax
  80087c:	83 c0 04             	add    $0x4,%eax
  80087f:	89 45 14             	mov    %eax,0x14(%ebp)
  800882:	8b 45 14             	mov    0x14(%ebp),%eax
  800885:	83 e8 04             	sub    $0x4,%eax
  800888:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  80088a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80088d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800894:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  80089b:	eb 1f                	jmp    8008bc <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  80089d:	83 ec 08             	sub    $0x8,%esp
  8008a0:	ff 75 e8             	pushl  -0x18(%ebp)
  8008a3:	8d 45 14             	lea    0x14(%ebp),%eax
  8008a6:	50                   	push   %eax
  8008a7:	e8 e7 fb ff ff       	call   800493 <getuint>
  8008ac:	83 c4 10             	add    $0x10,%esp
  8008af:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8008b2:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  8008b5:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  8008bc:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  8008c0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8008c3:	83 ec 04             	sub    $0x4,%esp
  8008c6:	52                   	push   %edx
  8008c7:	ff 75 e4             	pushl  -0x1c(%ebp)
  8008ca:	50                   	push   %eax
  8008cb:	ff 75 f4             	pushl  -0xc(%ebp)
  8008ce:	ff 75 f0             	pushl  -0x10(%ebp)
  8008d1:	ff 75 0c             	pushl  0xc(%ebp)
  8008d4:	ff 75 08             	pushl  0x8(%ebp)
  8008d7:	e8 00 fb ff ff       	call   8003dc <printnum>
  8008dc:	83 c4 20             	add    $0x20,%esp
			break;
  8008df:	eb 46                	jmp    800927 <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  8008e1:	83 ec 08             	sub    $0x8,%esp
  8008e4:	ff 75 0c             	pushl  0xc(%ebp)
  8008e7:	53                   	push   %ebx
  8008e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8008eb:	ff d0                	call   *%eax
  8008ed:	83 c4 10             	add    $0x10,%esp
			break;
  8008f0:	eb 35                	jmp    800927 <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  8008f2:	c6 05 44 30 80 00 00 	movb   $0x0,0x803044
			break;
  8008f9:	eb 2c                	jmp    800927 <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  8008fb:	c6 05 44 30 80 00 01 	movb   $0x1,0x803044
			break;
  800902:	eb 23                	jmp    800927 <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800904:	83 ec 08             	sub    $0x8,%esp
  800907:	ff 75 0c             	pushl  0xc(%ebp)
  80090a:	6a 25                	push   $0x25
  80090c:	8b 45 08             	mov    0x8(%ebp),%eax
  80090f:	ff d0                	call   *%eax
  800911:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800914:	ff 4d 10             	decl   0x10(%ebp)
  800917:	eb 03                	jmp    80091c <vprintfmt+0x3c3>
  800919:	ff 4d 10             	decl   0x10(%ebp)
  80091c:	8b 45 10             	mov    0x10(%ebp),%eax
  80091f:	48                   	dec    %eax
  800920:	8a 00                	mov    (%eax),%al
  800922:	3c 25                	cmp    $0x25,%al
  800924:	75 f3                	jne    800919 <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  800926:	90                   	nop
		}
	}
  800927:	e9 35 fc ff ff       	jmp    800561 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  80092c:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  80092d:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800930:	5b                   	pop    %ebx
  800931:	5e                   	pop    %esi
  800932:	5d                   	pop    %ebp
  800933:	c3                   	ret    

00800934 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800934:	55                   	push   %ebp
  800935:	89 e5                	mov    %esp,%ebp
  800937:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  80093a:	8d 45 10             	lea    0x10(%ebp),%eax
  80093d:	83 c0 04             	add    $0x4,%eax
  800940:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800943:	8b 45 10             	mov    0x10(%ebp),%eax
  800946:	ff 75 f4             	pushl  -0xc(%ebp)
  800949:	50                   	push   %eax
  80094a:	ff 75 0c             	pushl  0xc(%ebp)
  80094d:	ff 75 08             	pushl  0x8(%ebp)
  800950:	e8 04 fc ff ff       	call   800559 <vprintfmt>
  800955:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800958:	90                   	nop
  800959:	c9                   	leave  
  80095a:	c3                   	ret    

0080095b <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  80095b:	55                   	push   %ebp
  80095c:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  80095e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800961:	8b 40 08             	mov    0x8(%eax),%eax
  800964:	8d 50 01             	lea    0x1(%eax),%edx
  800967:	8b 45 0c             	mov    0xc(%ebp),%eax
  80096a:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  80096d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800970:	8b 10                	mov    (%eax),%edx
  800972:	8b 45 0c             	mov    0xc(%ebp),%eax
  800975:	8b 40 04             	mov    0x4(%eax),%eax
  800978:	39 c2                	cmp    %eax,%edx
  80097a:	73 12                	jae    80098e <sprintputch+0x33>
		*b->buf++ = ch;
  80097c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80097f:	8b 00                	mov    (%eax),%eax
  800981:	8d 48 01             	lea    0x1(%eax),%ecx
  800984:	8b 55 0c             	mov    0xc(%ebp),%edx
  800987:	89 0a                	mov    %ecx,(%edx)
  800989:	8b 55 08             	mov    0x8(%ebp),%edx
  80098c:	88 10                	mov    %dl,(%eax)
}
  80098e:	90                   	nop
  80098f:	5d                   	pop    %ebp
  800990:	c3                   	ret    

00800991 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800991:	55                   	push   %ebp
  800992:	89 e5                	mov    %esp,%ebp
  800994:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800997:	8b 45 08             	mov    0x8(%ebp),%eax
  80099a:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80099d:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009a0:	8d 50 ff             	lea    -0x1(%eax),%edx
  8009a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8009a6:	01 d0                	add    %edx,%eax
  8009a8:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8009ab:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  8009b2:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8009b6:	74 06                	je     8009be <vsnprintf+0x2d>
  8009b8:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8009bc:	7f 07                	jg     8009c5 <vsnprintf+0x34>
		return -E_INVAL;
  8009be:	b8 03 00 00 00       	mov    $0x3,%eax
  8009c3:	eb 20                	jmp    8009e5 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8009c5:	ff 75 14             	pushl  0x14(%ebp)
  8009c8:	ff 75 10             	pushl  0x10(%ebp)
  8009cb:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8009ce:	50                   	push   %eax
  8009cf:	68 5b 09 80 00       	push   $0x80095b
  8009d4:	e8 80 fb ff ff       	call   800559 <vprintfmt>
  8009d9:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  8009dc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8009df:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8009e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  8009e5:	c9                   	leave  
  8009e6:	c3                   	ret    

008009e7 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8009e7:	55                   	push   %ebp
  8009e8:	89 e5                	mov    %esp,%ebp
  8009ea:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8009ed:	8d 45 10             	lea    0x10(%ebp),%eax
  8009f0:	83 c0 04             	add    $0x4,%eax
  8009f3:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  8009f6:	8b 45 10             	mov    0x10(%ebp),%eax
  8009f9:	ff 75 f4             	pushl  -0xc(%ebp)
  8009fc:	50                   	push   %eax
  8009fd:	ff 75 0c             	pushl  0xc(%ebp)
  800a00:	ff 75 08             	pushl  0x8(%ebp)
  800a03:	e8 89 ff ff ff       	call   800991 <vsnprintf>
  800a08:	83 c4 10             	add    $0x10,%esp
  800a0b:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800a0e:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800a11:	c9                   	leave  
  800a12:	c3                   	ret    

00800a13 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800a13:	55                   	push   %ebp
  800a14:	89 e5                	mov    %esp,%ebp
  800a16:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800a19:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800a20:	eb 06                	jmp    800a28 <strlen+0x15>
		n++;
  800a22:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800a25:	ff 45 08             	incl   0x8(%ebp)
  800a28:	8b 45 08             	mov    0x8(%ebp),%eax
  800a2b:	8a 00                	mov    (%eax),%al
  800a2d:	84 c0                	test   %al,%al
  800a2f:	75 f1                	jne    800a22 <strlen+0xf>
		n++;
	return n;
  800a31:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800a34:	c9                   	leave  
  800a35:	c3                   	ret    

00800a36 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800a36:	55                   	push   %ebp
  800a37:	89 e5                	mov    %esp,%ebp
  800a39:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800a3c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800a43:	eb 09                	jmp    800a4e <strnlen+0x18>
		n++;
  800a45:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800a48:	ff 45 08             	incl   0x8(%ebp)
  800a4b:	ff 4d 0c             	decl   0xc(%ebp)
  800a4e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800a52:	74 09                	je     800a5d <strnlen+0x27>
  800a54:	8b 45 08             	mov    0x8(%ebp),%eax
  800a57:	8a 00                	mov    (%eax),%al
  800a59:	84 c0                	test   %al,%al
  800a5b:	75 e8                	jne    800a45 <strnlen+0xf>
		n++;
	return n;
  800a5d:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800a60:	c9                   	leave  
  800a61:	c3                   	ret    

00800a62 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800a62:	55                   	push   %ebp
  800a63:	89 e5                	mov    %esp,%ebp
  800a65:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800a68:	8b 45 08             	mov    0x8(%ebp),%eax
  800a6b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800a6e:	90                   	nop
  800a6f:	8b 45 08             	mov    0x8(%ebp),%eax
  800a72:	8d 50 01             	lea    0x1(%eax),%edx
  800a75:	89 55 08             	mov    %edx,0x8(%ebp)
  800a78:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a7b:	8d 4a 01             	lea    0x1(%edx),%ecx
  800a7e:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800a81:	8a 12                	mov    (%edx),%dl
  800a83:	88 10                	mov    %dl,(%eax)
  800a85:	8a 00                	mov    (%eax),%al
  800a87:	84 c0                	test   %al,%al
  800a89:	75 e4                	jne    800a6f <strcpy+0xd>
		/* do nothing */;
	return ret;
  800a8b:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800a8e:	c9                   	leave  
  800a8f:	c3                   	ret    

00800a90 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800a90:	55                   	push   %ebp
  800a91:	89 e5                	mov    %esp,%ebp
  800a93:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800a96:	8b 45 08             	mov    0x8(%ebp),%eax
  800a99:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800a9c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800aa3:	eb 1f                	jmp    800ac4 <strncpy+0x34>
		*dst++ = *src;
  800aa5:	8b 45 08             	mov    0x8(%ebp),%eax
  800aa8:	8d 50 01             	lea    0x1(%eax),%edx
  800aab:	89 55 08             	mov    %edx,0x8(%ebp)
  800aae:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ab1:	8a 12                	mov    (%edx),%dl
  800ab3:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800ab5:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ab8:	8a 00                	mov    (%eax),%al
  800aba:	84 c0                	test   %al,%al
  800abc:	74 03                	je     800ac1 <strncpy+0x31>
			src++;
  800abe:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800ac1:	ff 45 fc             	incl   -0x4(%ebp)
  800ac4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ac7:	3b 45 10             	cmp    0x10(%ebp),%eax
  800aca:	72 d9                	jb     800aa5 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800acc:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800acf:	c9                   	leave  
  800ad0:	c3                   	ret    

00800ad1 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800ad1:	55                   	push   %ebp
  800ad2:	89 e5                	mov    %esp,%ebp
  800ad4:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800ad7:	8b 45 08             	mov    0x8(%ebp),%eax
  800ada:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800add:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ae1:	74 30                	je     800b13 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800ae3:	eb 16                	jmp    800afb <strlcpy+0x2a>
			*dst++ = *src++;
  800ae5:	8b 45 08             	mov    0x8(%ebp),%eax
  800ae8:	8d 50 01             	lea    0x1(%eax),%edx
  800aeb:	89 55 08             	mov    %edx,0x8(%ebp)
  800aee:	8b 55 0c             	mov    0xc(%ebp),%edx
  800af1:	8d 4a 01             	lea    0x1(%edx),%ecx
  800af4:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800af7:	8a 12                	mov    (%edx),%dl
  800af9:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800afb:	ff 4d 10             	decl   0x10(%ebp)
  800afe:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800b02:	74 09                	je     800b0d <strlcpy+0x3c>
  800b04:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b07:	8a 00                	mov    (%eax),%al
  800b09:	84 c0                	test   %al,%al
  800b0b:	75 d8                	jne    800ae5 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800b0d:	8b 45 08             	mov    0x8(%ebp),%eax
  800b10:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800b13:	8b 55 08             	mov    0x8(%ebp),%edx
  800b16:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800b19:	29 c2                	sub    %eax,%edx
  800b1b:	89 d0                	mov    %edx,%eax
}
  800b1d:	c9                   	leave  
  800b1e:	c3                   	ret    

00800b1f <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800b1f:	55                   	push   %ebp
  800b20:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800b22:	eb 06                	jmp    800b2a <strcmp+0xb>
		p++, q++;
  800b24:	ff 45 08             	incl   0x8(%ebp)
  800b27:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800b2a:	8b 45 08             	mov    0x8(%ebp),%eax
  800b2d:	8a 00                	mov    (%eax),%al
  800b2f:	84 c0                	test   %al,%al
  800b31:	74 0e                	je     800b41 <strcmp+0x22>
  800b33:	8b 45 08             	mov    0x8(%ebp),%eax
  800b36:	8a 10                	mov    (%eax),%dl
  800b38:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b3b:	8a 00                	mov    (%eax),%al
  800b3d:	38 c2                	cmp    %al,%dl
  800b3f:	74 e3                	je     800b24 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800b41:	8b 45 08             	mov    0x8(%ebp),%eax
  800b44:	8a 00                	mov    (%eax),%al
  800b46:	0f b6 d0             	movzbl %al,%edx
  800b49:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b4c:	8a 00                	mov    (%eax),%al
  800b4e:	0f b6 c0             	movzbl %al,%eax
  800b51:	29 c2                	sub    %eax,%edx
  800b53:	89 d0                	mov    %edx,%eax
}
  800b55:	5d                   	pop    %ebp
  800b56:	c3                   	ret    

00800b57 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800b57:	55                   	push   %ebp
  800b58:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800b5a:	eb 09                	jmp    800b65 <strncmp+0xe>
		n--, p++, q++;
  800b5c:	ff 4d 10             	decl   0x10(%ebp)
  800b5f:	ff 45 08             	incl   0x8(%ebp)
  800b62:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800b65:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800b69:	74 17                	je     800b82 <strncmp+0x2b>
  800b6b:	8b 45 08             	mov    0x8(%ebp),%eax
  800b6e:	8a 00                	mov    (%eax),%al
  800b70:	84 c0                	test   %al,%al
  800b72:	74 0e                	je     800b82 <strncmp+0x2b>
  800b74:	8b 45 08             	mov    0x8(%ebp),%eax
  800b77:	8a 10                	mov    (%eax),%dl
  800b79:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b7c:	8a 00                	mov    (%eax),%al
  800b7e:	38 c2                	cmp    %al,%dl
  800b80:	74 da                	je     800b5c <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800b82:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800b86:	75 07                	jne    800b8f <strncmp+0x38>
		return 0;
  800b88:	b8 00 00 00 00       	mov    $0x0,%eax
  800b8d:	eb 14                	jmp    800ba3 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800b8f:	8b 45 08             	mov    0x8(%ebp),%eax
  800b92:	8a 00                	mov    (%eax),%al
  800b94:	0f b6 d0             	movzbl %al,%edx
  800b97:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b9a:	8a 00                	mov    (%eax),%al
  800b9c:	0f b6 c0             	movzbl %al,%eax
  800b9f:	29 c2                	sub    %eax,%edx
  800ba1:	89 d0                	mov    %edx,%eax
}
  800ba3:	5d                   	pop    %ebp
  800ba4:	c3                   	ret    

00800ba5 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800ba5:	55                   	push   %ebp
  800ba6:	89 e5                	mov    %esp,%ebp
  800ba8:	83 ec 04             	sub    $0x4,%esp
  800bab:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bae:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800bb1:	eb 12                	jmp    800bc5 <strchr+0x20>
		if (*s == c)
  800bb3:	8b 45 08             	mov    0x8(%ebp),%eax
  800bb6:	8a 00                	mov    (%eax),%al
  800bb8:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800bbb:	75 05                	jne    800bc2 <strchr+0x1d>
			return (char *) s;
  800bbd:	8b 45 08             	mov    0x8(%ebp),%eax
  800bc0:	eb 11                	jmp    800bd3 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800bc2:	ff 45 08             	incl   0x8(%ebp)
  800bc5:	8b 45 08             	mov    0x8(%ebp),%eax
  800bc8:	8a 00                	mov    (%eax),%al
  800bca:	84 c0                	test   %al,%al
  800bcc:	75 e5                	jne    800bb3 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800bce:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800bd3:	c9                   	leave  
  800bd4:	c3                   	ret    

00800bd5 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800bd5:	55                   	push   %ebp
  800bd6:	89 e5                	mov    %esp,%ebp
  800bd8:	83 ec 04             	sub    $0x4,%esp
  800bdb:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bde:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800be1:	eb 0d                	jmp    800bf0 <strfind+0x1b>
		if (*s == c)
  800be3:	8b 45 08             	mov    0x8(%ebp),%eax
  800be6:	8a 00                	mov    (%eax),%al
  800be8:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800beb:	74 0e                	je     800bfb <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800bed:	ff 45 08             	incl   0x8(%ebp)
  800bf0:	8b 45 08             	mov    0x8(%ebp),%eax
  800bf3:	8a 00                	mov    (%eax),%al
  800bf5:	84 c0                	test   %al,%al
  800bf7:	75 ea                	jne    800be3 <strfind+0xe>
  800bf9:	eb 01                	jmp    800bfc <strfind+0x27>
		if (*s == c)
			break;
  800bfb:	90                   	nop
	return (char *) s;
  800bfc:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800bff:	c9                   	leave  
  800c00:	c3                   	ret    

00800c01 <memset>:

// *************** The faster implementation of memset & memcpy is implemented by *************
// ****************** Team80 (Yahia Khaled, Malek Ahmed et al) - FCIS'24-25 *******************
void *
memset(void *v, int c, uint32 n)
{
  800c01:	55                   	push   %ebp
  800c02:	89 e5                	mov    %esp,%ebp
  800c04:	83 ec 10             	sub    $0x10,%esp
//	m = n;
//	while (--m >= 0)
//		*p++ = c;

	/*Faster Implementation*/
	uint64* p64 = (uint64*)v;
  800c07:	8b 45 08             	mov    0x8(%ebp),%eax
  800c0a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if(n >= 8){
  800c0d:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800c11:	76 63                	jbe    800c76 <memset+0x75>
		uint64 data_block = c;
  800c13:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c16:	99                   	cltd   
  800c17:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c1a:	89 55 f4             	mov    %edx,-0xc(%ebp)
		data_block |= data_block << 8;
  800c1d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800c20:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800c23:	0f a4 c2 08          	shld   $0x8,%eax,%edx
  800c27:	c1 e0 08             	shl    $0x8,%eax
  800c2a:	09 45 f0             	or     %eax,-0x10(%ebp)
  800c2d:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 16;
  800c30:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800c33:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800c36:	0f a4 c2 10          	shld   $0x10,%eax,%edx
  800c3a:	c1 e0 10             	shl    $0x10,%eax
  800c3d:	09 45 f0             	or     %eax,-0x10(%ebp)
  800c40:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 32;
  800c43:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800c46:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800c49:	89 c2                	mov    %eax,%edx
  800c4b:	b8 00 00 00 00       	mov    $0x0,%eax
  800c50:	09 45 f0             	or     %eax,-0x10(%ebp)
  800c53:	09 55 f4             	or     %edx,-0xc(%ebp)

		while(n >= 8)
  800c56:	eb 18                	jmp    800c70 <memset+0x6f>
			*p64++ = data_block, n -= 8;
  800c58:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  800c5b:	8d 41 08             	lea    0x8(%ecx),%eax
  800c5e:	89 45 fc             	mov    %eax,-0x4(%ebp)
  800c61:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800c64:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800c67:	89 01                	mov    %eax,(%ecx)
  800c69:	89 51 04             	mov    %edx,0x4(%ecx)
  800c6c:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
		uint64 data_block = c;
		data_block |= data_block << 8;
		data_block |= data_block << 16;
		data_block |= data_block << 32;

		while(n >= 8)
  800c70:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800c74:	77 e2                	ja     800c58 <memset+0x57>
			*p64++ = data_block, n -= 8;
	}

	if(n){
  800c76:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800c7a:	74 23                	je     800c9f <memset+0x9e>
		uint8* p8 = (uint8*)p64;
  800c7c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800c7f:	89 45 f8             	mov    %eax,-0x8(%ebp)
		while (n-- > 0)
  800c82:	eb 0e                	jmp    800c92 <memset+0x91>
			*p8++ = (uint8)c;
  800c84:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800c87:	8d 50 01             	lea    0x1(%eax),%edx
  800c8a:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800c8d:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c90:	88 10                	mov    %dl,(%eax)
			*p64++ = data_block, n -= 8;
	}

	if(n){
		uint8* p8 = (uint8*)p64;
		while (n-- > 0)
  800c92:	8b 45 10             	mov    0x10(%ebp),%eax
  800c95:	8d 50 ff             	lea    -0x1(%eax),%edx
  800c98:	89 55 10             	mov    %edx,0x10(%ebp)
  800c9b:	85 c0                	test   %eax,%eax
  800c9d:	75 e5                	jne    800c84 <memset+0x83>
			*p8++ = (uint8)c;
	}

	return v;
  800c9f:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800ca2:	c9                   	leave  
  800ca3:	c3                   	ret    

00800ca4 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800ca4:	55                   	push   %ebp
  800ca5:	89 e5                	mov    %esp,%ebp
  800ca7:	83 ec 10             	sub    $0x10,%esp
	//	s = src;
	//	d = dst;
	//	while (n-- > 0)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
  800caa:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cad:	89 45 fc             	mov    %eax,-0x4(%ebp)
	uint64* d64 = (uint64*)dst;
  800cb0:	8b 45 08             	mov    0x8(%ebp),%eax
  800cb3:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if(n >= 8){
  800cb6:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800cba:	76 24                	jbe    800ce0 <memcpy+0x3c>
		while(n >= 8){
  800cbc:	eb 1c                	jmp    800cda <memcpy+0x36>
			*d64 = *s64;
  800cbe:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800cc1:	8b 50 04             	mov    0x4(%eax),%edx
  800cc4:	8b 00                	mov    (%eax),%eax
  800cc6:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  800cc9:	89 01                	mov    %eax,(%ecx)
  800ccb:	89 51 04             	mov    %edx,0x4(%ecx)
			n -= 8;
  800cce:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
			++s64;
  800cd2:	83 45 fc 08          	addl   $0x8,-0x4(%ebp)
			++d64;
  800cd6:	83 45 f8 08          	addl   $0x8,-0x8(%ebp)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
	uint64* d64 = (uint64*)dst;
	if(n >= 8){
		while(n >= 8){
  800cda:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800cde:	77 de                	ja     800cbe <memcpy+0x1a>
			++s64;
			++d64;
		}
	}

	if(n){
  800ce0:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ce4:	74 31                	je     800d17 <memcpy+0x73>
		uint8* s8 = (uint8*)s64;
  800ce6:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ce9:	89 45 f4             	mov    %eax,-0xc(%ebp)
		uint8* d8 = (uint8*)d64;
  800cec:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800cef:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (n-- > 0)
  800cf2:	eb 16                	jmp    800d0a <memcpy+0x66>
			*d8++ = *s8++;
  800cf4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800cf7:	8d 50 01             	lea    0x1(%eax),%edx
  800cfa:	89 55 f0             	mov    %edx,-0x10(%ebp)
  800cfd:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800d00:	8d 4a 01             	lea    0x1(%edx),%ecx
  800d03:	89 4d f4             	mov    %ecx,-0xc(%ebp)
  800d06:	8a 12                	mov    (%edx),%dl
  800d08:	88 10                	mov    %dl,(%eax)
	}

	if(n){
		uint8* s8 = (uint8*)s64;
		uint8* d8 = (uint8*)d64;
		while (n-- > 0)
  800d0a:	8b 45 10             	mov    0x10(%ebp),%eax
  800d0d:	8d 50 ff             	lea    -0x1(%eax),%edx
  800d10:	89 55 10             	mov    %edx,0x10(%ebp)
  800d13:	85 c0                	test   %eax,%eax
  800d15:	75 dd                	jne    800cf4 <memcpy+0x50>
			*d8++ = *s8++;
	}
	return dst;
  800d17:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800d1a:	c9                   	leave  
  800d1b:	c3                   	ret    

00800d1c <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800d1c:	55                   	push   %ebp
  800d1d:	89 e5                	mov    %esp,%ebp
  800d1f:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800d22:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d25:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800d28:	8b 45 08             	mov    0x8(%ebp),%eax
  800d2b:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800d2e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d31:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800d34:	73 50                	jae    800d86 <memmove+0x6a>
  800d36:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800d39:	8b 45 10             	mov    0x10(%ebp),%eax
  800d3c:	01 d0                	add    %edx,%eax
  800d3e:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800d41:	76 43                	jbe    800d86 <memmove+0x6a>
		s += n;
  800d43:	8b 45 10             	mov    0x10(%ebp),%eax
  800d46:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800d49:	8b 45 10             	mov    0x10(%ebp),%eax
  800d4c:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800d4f:	eb 10                	jmp    800d61 <memmove+0x45>
			*--d = *--s;
  800d51:	ff 4d f8             	decl   -0x8(%ebp)
  800d54:	ff 4d fc             	decl   -0x4(%ebp)
  800d57:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d5a:	8a 10                	mov    (%eax),%dl
  800d5c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800d5f:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800d61:	8b 45 10             	mov    0x10(%ebp),%eax
  800d64:	8d 50 ff             	lea    -0x1(%eax),%edx
  800d67:	89 55 10             	mov    %edx,0x10(%ebp)
  800d6a:	85 c0                	test   %eax,%eax
  800d6c:	75 e3                	jne    800d51 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800d6e:	eb 23                	jmp    800d93 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800d70:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800d73:	8d 50 01             	lea    0x1(%eax),%edx
  800d76:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800d79:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800d7c:	8d 4a 01             	lea    0x1(%edx),%ecx
  800d7f:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800d82:	8a 12                	mov    (%edx),%dl
  800d84:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800d86:	8b 45 10             	mov    0x10(%ebp),%eax
  800d89:	8d 50 ff             	lea    -0x1(%eax),%edx
  800d8c:	89 55 10             	mov    %edx,0x10(%ebp)
  800d8f:	85 c0                	test   %eax,%eax
  800d91:	75 dd                	jne    800d70 <memmove+0x54>
			*d++ = *s++;

	return dst;
  800d93:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800d96:	c9                   	leave  
  800d97:	c3                   	ret    

00800d98 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  800d98:	55                   	push   %ebp
  800d99:	89 e5                	mov    %esp,%ebp
  800d9b:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  800d9e:	8b 45 08             	mov    0x8(%ebp),%eax
  800da1:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  800da4:	8b 45 0c             	mov    0xc(%ebp),%eax
  800da7:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800daa:	eb 2a                	jmp    800dd6 <memcmp+0x3e>
		if (*s1 != *s2)
  800dac:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800daf:	8a 10                	mov    (%eax),%dl
  800db1:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800db4:	8a 00                	mov    (%eax),%al
  800db6:	38 c2                	cmp    %al,%dl
  800db8:	74 16                	je     800dd0 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  800dba:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800dbd:	8a 00                	mov    (%eax),%al
  800dbf:	0f b6 d0             	movzbl %al,%edx
  800dc2:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800dc5:	8a 00                	mov    (%eax),%al
  800dc7:	0f b6 c0             	movzbl %al,%eax
  800dca:	29 c2                	sub    %eax,%edx
  800dcc:	89 d0                	mov    %edx,%eax
  800dce:	eb 18                	jmp    800de8 <memcmp+0x50>
		s1++, s2++;
  800dd0:	ff 45 fc             	incl   -0x4(%ebp)
  800dd3:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  800dd6:	8b 45 10             	mov    0x10(%ebp),%eax
  800dd9:	8d 50 ff             	lea    -0x1(%eax),%edx
  800ddc:	89 55 10             	mov    %edx,0x10(%ebp)
  800ddf:	85 c0                	test   %eax,%eax
  800de1:	75 c9                	jne    800dac <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800de3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800de8:	c9                   	leave  
  800de9:	c3                   	ret    

00800dea <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  800dea:	55                   	push   %ebp
  800deb:	89 e5                	mov    %esp,%ebp
  800ded:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  800df0:	8b 55 08             	mov    0x8(%ebp),%edx
  800df3:	8b 45 10             	mov    0x10(%ebp),%eax
  800df6:	01 d0                	add    %edx,%eax
  800df8:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  800dfb:	eb 15                	jmp    800e12 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  800dfd:	8b 45 08             	mov    0x8(%ebp),%eax
  800e00:	8a 00                	mov    (%eax),%al
  800e02:	0f b6 d0             	movzbl %al,%edx
  800e05:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e08:	0f b6 c0             	movzbl %al,%eax
  800e0b:	39 c2                	cmp    %eax,%edx
  800e0d:	74 0d                	je     800e1c <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800e0f:	ff 45 08             	incl   0x8(%ebp)
  800e12:	8b 45 08             	mov    0x8(%ebp),%eax
  800e15:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  800e18:	72 e3                	jb     800dfd <memfind+0x13>
  800e1a:	eb 01                	jmp    800e1d <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  800e1c:	90                   	nop
	return (void *) s;
  800e1d:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e20:	c9                   	leave  
  800e21:	c3                   	ret    

00800e22 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800e22:	55                   	push   %ebp
  800e23:	89 e5                	mov    %esp,%ebp
  800e25:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  800e28:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  800e2f:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800e36:	eb 03                	jmp    800e3b <strtol+0x19>
		s++;
  800e38:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800e3b:	8b 45 08             	mov    0x8(%ebp),%eax
  800e3e:	8a 00                	mov    (%eax),%al
  800e40:	3c 20                	cmp    $0x20,%al
  800e42:	74 f4                	je     800e38 <strtol+0x16>
  800e44:	8b 45 08             	mov    0x8(%ebp),%eax
  800e47:	8a 00                	mov    (%eax),%al
  800e49:	3c 09                	cmp    $0x9,%al
  800e4b:	74 eb                	je     800e38 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  800e4d:	8b 45 08             	mov    0x8(%ebp),%eax
  800e50:	8a 00                	mov    (%eax),%al
  800e52:	3c 2b                	cmp    $0x2b,%al
  800e54:	75 05                	jne    800e5b <strtol+0x39>
		s++;
  800e56:	ff 45 08             	incl   0x8(%ebp)
  800e59:	eb 13                	jmp    800e6e <strtol+0x4c>
	else if (*s == '-')
  800e5b:	8b 45 08             	mov    0x8(%ebp),%eax
  800e5e:	8a 00                	mov    (%eax),%al
  800e60:	3c 2d                	cmp    $0x2d,%al
  800e62:	75 0a                	jne    800e6e <strtol+0x4c>
		s++, neg = 1;
  800e64:	ff 45 08             	incl   0x8(%ebp)
  800e67:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800e6e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e72:	74 06                	je     800e7a <strtol+0x58>
  800e74:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  800e78:	75 20                	jne    800e9a <strtol+0x78>
  800e7a:	8b 45 08             	mov    0x8(%ebp),%eax
  800e7d:	8a 00                	mov    (%eax),%al
  800e7f:	3c 30                	cmp    $0x30,%al
  800e81:	75 17                	jne    800e9a <strtol+0x78>
  800e83:	8b 45 08             	mov    0x8(%ebp),%eax
  800e86:	40                   	inc    %eax
  800e87:	8a 00                	mov    (%eax),%al
  800e89:	3c 78                	cmp    $0x78,%al
  800e8b:	75 0d                	jne    800e9a <strtol+0x78>
		s += 2, base = 16;
  800e8d:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  800e91:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  800e98:	eb 28                	jmp    800ec2 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  800e9a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e9e:	75 15                	jne    800eb5 <strtol+0x93>
  800ea0:	8b 45 08             	mov    0x8(%ebp),%eax
  800ea3:	8a 00                	mov    (%eax),%al
  800ea5:	3c 30                	cmp    $0x30,%al
  800ea7:	75 0c                	jne    800eb5 <strtol+0x93>
		s++, base = 8;
  800ea9:	ff 45 08             	incl   0x8(%ebp)
  800eac:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  800eb3:	eb 0d                	jmp    800ec2 <strtol+0xa0>
	else if (base == 0)
  800eb5:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800eb9:	75 07                	jne    800ec2 <strtol+0xa0>
		base = 10;
  800ebb:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800ec2:	8b 45 08             	mov    0x8(%ebp),%eax
  800ec5:	8a 00                	mov    (%eax),%al
  800ec7:	3c 2f                	cmp    $0x2f,%al
  800ec9:	7e 19                	jle    800ee4 <strtol+0xc2>
  800ecb:	8b 45 08             	mov    0x8(%ebp),%eax
  800ece:	8a 00                	mov    (%eax),%al
  800ed0:	3c 39                	cmp    $0x39,%al
  800ed2:	7f 10                	jg     800ee4 <strtol+0xc2>
			dig = *s - '0';
  800ed4:	8b 45 08             	mov    0x8(%ebp),%eax
  800ed7:	8a 00                	mov    (%eax),%al
  800ed9:	0f be c0             	movsbl %al,%eax
  800edc:	83 e8 30             	sub    $0x30,%eax
  800edf:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800ee2:	eb 42                	jmp    800f26 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  800ee4:	8b 45 08             	mov    0x8(%ebp),%eax
  800ee7:	8a 00                	mov    (%eax),%al
  800ee9:	3c 60                	cmp    $0x60,%al
  800eeb:	7e 19                	jle    800f06 <strtol+0xe4>
  800eed:	8b 45 08             	mov    0x8(%ebp),%eax
  800ef0:	8a 00                	mov    (%eax),%al
  800ef2:	3c 7a                	cmp    $0x7a,%al
  800ef4:	7f 10                	jg     800f06 <strtol+0xe4>
			dig = *s - 'a' + 10;
  800ef6:	8b 45 08             	mov    0x8(%ebp),%eax
  800ef9:	8a 00                	mov    (%eax),%al
  800efb:	0f be c0             	movsbl %al,%eax
  800efe:	83 e8 57             	sub    $0x57,%eax
  800f01:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800f04:	eb 20                	jmp    800f26 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  800f06:	8b 45 08             	mov    0x8(%ebp),%eax
  800f09:	8a 00                	mov    (%eax),%al
  800f0b:	3c 40                	cmp    $0x40,%al
  800f0d:	7e 39                	jle    800f48 <strtol+0x126>
  800f0f:	8b 45 08             	mov    0x8(%ebp),%eax
  800f12:	8a 00                	mov    (%eax),%al
  800f14:	3c 5a                	cmp    $0x5a,%al
  800f16:	7f 30                	jg     800f48 <strtol+0x126>
			dig = *s - 'A' + 10;
  800f18:	8b 45 08             	mov    0x8(%ebp),%eax
  800f1b:	8a 00                	mov    (%eax),%al
  800f1d:	0f be c0             	movsbl %al,%eax
  800f20:	83 e8 37             	sub    $0x37,%eax
  800f23:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  800f26:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800f29:	3b 45 10             	cmp    0x10(%ebp),%eax
  800f2c:	7d 19                	jge    800f47 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  800f2e:	ff 45 08             	incl   0x8(%ebp)
  800f31:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f34:	0f af 45 10          	imul   0x10(%ebp),%eax
  800f38:	89 c2                	mov    %eax,%edx
  800f3a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800f3d:	01 d0                	add    %edx,%eax
  800f3f:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  800f42:	e9 7b ff ff ff       	jmp    800ec2 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  800f47:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  800f48:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800f4c:	74 08                	je     800f56 <strtol+0x134>
		*endptr = (char *) s;
  800f4e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f51:	8b 55 08             	mov    0x8(%ebp),%edx
  800f54:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  800f56:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  800f5a:	74 07                	je     800f63 <strtol+0x141>
  800f5c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f5f:	f7 d8                	neg    %eax
  800f61:	eb 03                	jmp    800f66 <strtol+0x144>
  800f63:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800f66:	c9                   	leave  
  800f67:	c3                   	ret    

00800f68 <ltostr>:

void
ltostr(long value, char *str)
{
  800f68:	55                   	push   %ebp
  800f69:	89 e5                	mov    %esp,%ebp
  800f6b:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  800f6e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  800f75:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  800f7c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800f80:	79 13                	jns    800f95 <ltostr+0x2d>
	{
		neg = 1;
  800f82:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  800f89:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f8c:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  800f8f:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  800f92:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  800f95:	8b 45 08             	mov    0x8(%ebp),%eax
  800f98:	b9 0a 00 00 00       	mov    $0xa,%ecx
  800f9d:	99                   	cltd   
  800f9e:	f7 f9                	idiv   %ecx
  800fa0:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  800fa3:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800fa6:	8d 50 01             	lea    0x1(%eax),%edx
  800fa9:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800fac:	89 c2                	mov    %eax,%edx
  800fae:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fb1:	01 d0                	add    %edx,%eax
  800fb3:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800fb6:	83 c2 30             	add    $0x30,%edx
  800fb9:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  800fbb:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800fbe:	b8 67 66 66 66       	mov    $0x66666667,%eax
  800fc3:	f7 e9                	imul   %ecx
  800fc5:	c1 fa 02             	sar    $0x2,%edx
  800fc8:	89 c8                	mov    %ecx,%eax
  800fca:	c1 f8 1f             	sar    $0x1f,%eax
  800fcd:	29 c2                	sub    %eax,%edx
  800fcf:	89 d0                	mov    %edx,%eax
  800fd1:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  800fd4:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800fd8:	75 bb                	jne    800f95 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  800fda:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  800fe1:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800fe4:	48                   	dec    %eax
  800fe5:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  800fe8:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  800fec:	74 3d                	je     80102b <ltostr+0xc3>
		start = 1 ;
  800fee:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  800ff5:	eb 34                	jmp    80102b <ltostr+0xc3>
	{
		char tmp = str[start] ;
  800ff7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800ffa:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ffd:	01 d0                	add    %edx,%eax
  800fff:	8a 00                	mov    (%eax),%al
  801001:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801004:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801007:	8b 45 0c             	mov    0xc(%ebp),%eax
  80100a:	01 c2                	add    %eax,%edx
  80100c:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  80100f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801012:	01 c8                	add    %ecx,%eax
  801014:	8a 00                	mov    (%eax),%al
  801016:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801018:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80101b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80101e:	01 c2                	add    %eax,%edx
  801020:	8a 45 eb             	mov    -0x15(%ebp),%al
  801023:	88 02                	mov    %al,(%edx)
		start++ ;
  801025:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801028:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  80102b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80102e:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801031:	7c c4                	jl     800ff7 <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801033:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801036:	8b 45 0c             	mov    0xc(%ebp),%eax
  801039:	01 d0                	add    %edx,%eax
  80103b:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  80103e:	90                   	nop
  80103f:	c9                   	leave  
  801040:	c3                   	ret    

00801041 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  801041:	55                   	push   %ebp
  801042:	89 e5                	mov    %esp,%ebp
  801044:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801047:	ff 75 08             	pushl  0x8(%ebp)
  80104a:	e8 c4 f9 ff ff       	call   800a13 <strlen>
  80104f:	83 c4 04             	add    $0x4,%esp
  801052:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  801055:	ff 75 0c             	pushl  0xc(%ebp)
  801058:	e8 b6 f9 ff ff       	call   800a13 <strlen>
  80105d:	83 c4 04             	add    $0x4,%esp
  801060:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  801063:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  80106a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801071:	eb 17                	jmp    80108a <strcconcat+0x49>
		final[s] = str1[s] ;
  801073:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801076:	8b 45 10             	mov    0x10(%ebp),%eax
  801079:	01 c2                	add    %eax,%edx
  80107b:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  80107e:	8b 45 08             	mov    0x8(%ebp),%eax
  801081:	01 c8                	add    %ecx,%eax
  801083:	8a 00                	mov    (%eax),%al
  801085:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  801087:	ff 45 fc             	incl   -0x4(%ebp)
  80108a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80108d:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801090:	7c e1                	jl     801073 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  801092:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  801099:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8010a0:	eb 1f                	jmp    8010c1 <strcconcat+0x80>
		final[s++] = str2[i] ;
  8010a2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8010a5:	8d 50 01             	lea    0x1(%eax),%edx
  8010a8:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8010ab:	89 c2                	mov    %eax,%edx
  8010ad:	8b 45 10             	mov    0x10(%ebp),%eax
  8010b0:	01 c2                	add    %eax,%edx
  8010b2:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8010b5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010b8:	01 c8                	add    %ecx,%eax
  8010ba:	8a 00                	mov    (%eax),%al
  8010bc:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  8010be:	ff 45 f8             	incl   -0x8(%ebp)
  8010c1:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010c4:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8010c7:	7c d9                	jl     8010a2 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  8010c9:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8010cc:	8b 45 10             	mov    0x10(%ebp),%eax
  8010cf:	01 d0                	add    %edx,%eax
  8010d1:	c6 00 00             	movb   $0x0,(%eax)
}
  8010d4:	90                   	nop
  8010d5:	c9                   	leave  
  8010d6:	c3                   	ret    

008010d7 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  8010d7:	55                   	push   %ebp
  8010d8:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  8010da:	8b 45 14             	mov    0x14(%ebp),%eax
  8010dd:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  8010e3:	8b 45 14             	mov    0x14(%ebp),%eax
  8010e6:	8b 00                	mov    (%eax),%eax
  8010e8:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8010ef:	8b 45 10             	mov    0x10(%ebp),%eax
  8010f2:	01 d0                	add    %edx,%eax
  8010f4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8010fa:	eb 0c                	jmp    801108 <strsplit+0x31>
			*string++ = 0;
  8010fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8010ff:	8d 50 01             	lea    0x1(%eax),%edx
  801102:	89 55 08             	mov    %edx,0x8(%ebp)
  801105:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801108:	8b 45 08             	mov    0x8(%ebp),%eax
  80110b:	8a 00                	mov    (%eax),%al
  80110d:	84 c0                	test   %al,%al
  80110f:	74 18                	je     801129 <strsplit+0x52>
  801111:	8b 45 08             	mov    0x8(%ebp),%eax
  801114:	8a 00                	mov    (%eax),%al
  801116:	0f be c0             	movsbl %al,%eax
  801119:	50                   	push   %eax
  80111a:	ff 75 0c             	pushl  0xc(%ebp)
  80111d:	e8 83 fa ff ff       	call   800ba5 <strchr>
  801122:	83 c4 08             	add    $0x8,%esp
  801125:	85 c0                	test   %eax,%eax
  801127:	75 d3                	jne    8010fc <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801129:	8b 45 08             	mov    0x8(%ebp),%eax
  80112c:	8a 00                	mov    (%eax),%al
  80112e:	84 c0                	test   %al,%al
  801130:	74 5a                	je     80118c <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801132:	8b 45 14             	mov    0x14(%ebp),%eax
  801135:	8b 00                	mov    (%eax),%eax
  801137:	83 f8 0f             	cmp    $0xf,%eax
  80113a:	75 07                	jne    801143 <strsplit+0x6c>
		{
			return 0;
  80113c:	b8 00 00 00 00       	mov    $0x0,%eax
  801141:	eb 66                	jmp    8011a9 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801143:	8b 45 14             	mov    0x14(%ebp),%eax
  801146:	8b 00                	mov    (%eax),%eax
  801148:	8d 48 01             	lea    0x1(%eax),%ecx
  80114b:	8b 55 14             	mov    0x14(%ebp),%edx
  80114e:	89 0a                	mov    %ecx,(%edx)
  801150:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801157:	8b 45 10             	mov    0x10(%ebp),%eax
  80115a:	01 c2                	add    %eax,%edx
  80115c:	8b 45 08             	mov    0x8(%ebp),%eax
  80115f:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801161:	eb 03                	jmp    801166 <strsplit+0x8f>
			string++;
  801163:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801166:	8b 45 08             	mov    0x8(%ebp),%eax
  801169:	8a 00                	mov    (%eax),%al
  80116b:	84 c0                	test   %al,%al
  80116d:	74 8b                	je     8010fa <strsplit+0x23>
  80116f:	8b 45 08             	mov    0x8(%ebp),%eax
  801172:	8a 00                	mov    (%eax),%al
  801174:	0f be c0             	movsbl %al,%eax
  801177:	50                   	push   %eax
  801178:	ff 75 0c             	pushl  0xc(%ebp)
  80117b:	e8 25 fa ff ff       	call   800ba5 <strchr>
  801180:	83 c4 08             	add    $0x8,%esp
  801183:	85 c0                	test   %eax,%eax
  801185:	74 dc                	je     801163 <strsplit+0x8c>
			string++;
	}
  801187:	e9 6e ff ff ff       	jmp    8010fa <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  80118c:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  80118d:	8b 45 14             	mov    0x14(%ebp),%eax
  801190:	8b 00                	mov    (%eax),%eax
  801192:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801199:	8b 45 10             	mov    0x10(%ebp),%eax
  80119c:	01 d0                	add    %edx,%eax
  80119e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  8011a4:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8011a9:	c9                   	leave  
  8011aa:	c3                   	ret    

008011ab <str2lower>:


char* str2lower(char *dst, const char *src)
{
  8011ab:	55                   	push   %ebp
  8011ac:	89 e5                	mov    %esp,%ebp
  8011ae:	83 ec 10             	sub    $0x10,%esp
	char* ret = dst;
  8011b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8011b4:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (int i = 0; i < strlen(src); ++i)
  8011b7:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8011be:	eb 4a                	jmp    80120a <str2lower+0x5f>
	{
		dst[i] = src[i] ;
  8011c0:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8011c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8011c6:	01 c2                	add    %eax,%edx
  8011c8:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8011cb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011ce:	01 c8                	add    %ecx,%eax
  8011d0:	8a 00                	mov    (%eax),%al
  8011d2:	88 02                	mov    %al,(%edx)
		if (src[i] >= 'A' && src[i] <= 'Z')
  8011d4:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8011d7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011da:	01 d0                	add    %edx,%eax
  8011dc:	8a 00                	mov    (%eax),%al
  8011de:	3c 40                	cmp    $0x40,%al
  8011e0:	7e 25                	jle    801207 <str2lower+0x5c>
  8011e2:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8011e5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011e8:	01 d0                	add    %edx,%eax
  8011ea:	8a 00                	mov    (%eax),%al
  8011ec:	3c 5a                	cmp    $0x5a,%al
  8011ee:	7f 17                	jg     801207 <str2lower+0x5c>
		{
			dst[i] += 32 ;
  8011f0:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8011f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8011f6:	01 d0                	add    %edx,%eax
  8011f8:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8011fb:	8b 55 08             	mov    0x8(%ebp),%edx
  8011fe:	01 ca                	add    %ecx,%edx
  801200:	8a 12                	mov    (%edx),%dl
  801202:	83 c2 20             	add    $0x20,%edx
  801205:	88 10                	mov    %dl,(%eax)


char* str2lower(char *dst, const char *src)
{
	char* ret = dst;
	for (int i = 0; i < strlen(src); ++i)
  801207:	ff 45 fc             	incl   -0x4(%ebp)
  80120a:	ff 75 0c             	pushl  0xc(%ebp)
  80120d:	e8 01 f8 ff ff       	call   800a13 <strlen>
  801212:	83 c4 04             	add    $0x4,%esp
  801215:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801218:	7f a6                	jg     8011c0 <str2lower+0x15>
		if (src[i] >= 'A' && src[i] <= 'Z')
		{
			dst[i] += 32 ;
		}
	}
	return ret;
  80121a:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  80121d:	c9                   	leave  
  80121e:	c3                   	ret    

0080121f <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  80121f:	55                   	push   %ebp
  801220:	89 e5                	mov    %esp,%ebp
  801222:	57                   	push   %edi
  801223:	56                   	push   %esi
  801224:	53                   	push   %ebx
  801225:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801228:	8b 45 08             	mov    0x8(%ebp),%eax
  80122b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80122e:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801231:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801234:	8b 7d 18             	mov    0x18(%ebp),%edi
  801237:	8b 75 1c             	mov    0x1c(%ebp),%esi
  80123a:	cd 30                	int    $0x30
  80123c:	89 45 f0             	mov    %eax,-0x10(%ebp)
				"b" (a3),
				"D" (a4),
				"S" (a5)
				: "cc", "memory");

	return ret;
  80123f:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801242:	83 c4 10             	add    $0x10,%esp
  801245:	5b                   	pop    %ebx
  801246:	5e                   	pop    %esi
  801247:	5f                   	pop    %edi
  801248:	5d                   	pop    %ebp
  801249:	c3                   	ret    

0080124a <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName, int color)
{
  80124a:	55                   	push   %ebp
  80124b:	89 e5                	mov    %esp,%ebp
  80124d:	83 ec 04             	sub    $0x4,%esp
  801250:	8b 45 10             	mov    0x10(%ebp),%eax
  801253:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, color, 0);
  801256:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801259:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80125d:	8b 45 08             	mov    0x8(%ebp),%eax
  801260:	6a 00                	push   $0x0
  801262:	51                   	push   %ecx
  801263:	52                   	push   %edx
  801264:	ff 75 0c             	pushl  0xc(%ebp)
  801267:	50                   	push   %eax
  801268:	6a 00                	push   $0x0
  80126a:	e8 b0 ff ff ff       	call   80121f <syscall>
  80126f:	83 c4 18             	add    $0x18,%esp
}
  801272:	90                   	nop
  801273:	c9                   	leave  
  801274:	c3                   	ret    

00801275 <sys_cgetc>:

int
sys_cgetc(void)
{
  801275:	55                   	push   %ebp
  801276:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801278:	6a 00                	push   $0x0
  80127a:	6a 00                	push   $0x0
  80127c:	6a 00                	push   $0x0
  80127e:	6a 00                	push   $0x0
  801280:	6a 00                	push   $0x0
  801282:	6a 02                	push   $0x2
  801284:	e8 96 ff ff ff       	call   80121f <syscall>
  801289:	83 c4 18             	add    $0x18,%esp
}
  80128c:	c9                   	leave  
  80128d:	c3                   	ret    

0080128e <sys_lock_cons>:

void sys_lock_cons(void)
{
  80128e:	55                   	push   %ebp
  80128f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  801291:	6a 00                	push   $0x0
  801293:	6a 00                	push   $0x0
  801295:	6a 00                	push   $0x0
  801297:	6a 00                	push   $0x0
  801299:	6a 00                	push   $0x0
  80129b:	6a 03                	push   $0x3
  80129d:	e8 7d ff ff ff       	call   80121f <syscall>
  8012a2:	83 c4 18             	add    $0x18,%esp
}
  8012a5:	90                   	nop
  8012a6:	c9                   	leave  
  8012a7:	c3                   	ret    

008012a8 <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  8012a8:	55                   	push   %ebp
  8012a9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  8012ab:	6a 00                	push   $0x0
  8012ad:	6a 00                	push   $0x0
  8012af:	6a 00                	push   $0x0
  8012b1:	6a 00                	push   $0x0
  8012b3:	6a 00                	push   $0x0
  8012b5:	6a 04                	push   $0x4
  8012b7:	e8 63 ff ff ff       	call   80121f <syscall>
  8012bc:	83 c4 18             	add    $0x18,%esp
}
  8012bf:	90                   	nop
  8012c0:	c9                   	leave  
  8012c1:	c3                   	ret    

008012c2 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  8012c2:	55                   	push   %ebp
  8012c3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  8012c5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8012c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8012cb:	6a 00                	push   $0x0
  8012cd:	6a 00                	push   $0x0
  8012cf:	6a 00                	push   $0x0
  8012d1:	52                   	push   %edx
  8012d2:	50                   	push   %eax
  8012d3:	6a 08                	push   $0x8
  8012d5:	e8 45 ff ff ff       	call   80121f <syscall>
  8012da:	83 c4 18             	add    $0x18,%esp
}
  8012dd:	c9                   	leave  
  8012de:	c3                   	ret    

008012df <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  8012df:	55                   	push   %ebp
  8012e0:	89 e5                	mov    %esp,%ebp
  8012e2:	56                   	push   %esi
  8012e3:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  8012e4:	8b 75 18             	mov    0x18(%ebp),%esi
  8012e7:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8012ea:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8012ed:	8b 55 0c             	mov    0xc(%ebp),%edx
  8012f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8012f3:	56                   	push   %esi
  8012f4:	53                   	push   %ebx
  8012f5:	51                   	push   %ecx
  8012f6:	52                   	push   %edx
  8012f7:	50                   	push   %eax
  8012f8:	6a 09                	push   $0x9
  8012fa:	e8 20 ff ff ff       	call   80121f <syscall>
  8012ff:	83 c4 18             	add    $0x18,%esp
}
  801302:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801305:	5b                   	pop    %ebx
  801306:	5e                   	pop    %esi
  801307:	5d                   	pop    %ebp
  801308:	c3                   	ret    

00801309 <__sys_unmap_frame>:

int __sys_unmap_frame(uint32 va)
{
  801309:	55                   	push   %ebp
  80130a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, va, 0, 0, 0, 0);
  80130c:	6a 00                	push   $0x0
  80130e:	6a 00                	push   $0x0
  801310:	6a 00                	push   $0x0
  801312:	6a 00                	push   $0x0
  801314:	ff 75 08             	pushl  0x8(%ebp)
  801317:	6a 0a                	push   $0xa
  801319:	e8 01 ff ff ff       	call   80121f <syscall>
  80131e:	83 c4 18             	add    $0x18,%esp
}
  801321:	c9                   	leave  
  801322:	c3                   	ret    

00801323 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801323:	55                   	push   %ebp
  801324:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801326:	6a 00                	push   $0x0
  801328:	6a 00                	push   $0x0
  80132a:	6a 00                	push   $0x0
  80132c:	ff 75 0c             	pushl  0xc(%ebp)
  80132f:	ff 75 08             	pushl  0x8(%ebp)
  801332:	6a 0b                	push   $0xb
  801334:	e8 e6 fe ff ff       	call   80121f <syscall>
  801339:	83 c4 18             	add    $0x18,%esp
}
  80133c:	c9                   	leave  
  80133d:	c3                   	ret    

0080133e <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  80133e:	55                   	push   %ebp
  80133f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801341:	6a 00                	push   $0x0
  801343:	6a 00                	push   $0x0
  801345:	6a 00                	push   $0x0
  801347:	6a 00                	push   $0x0
  801349:	6a 00                	push   $0x0
  80134b:	6a 0c                	push   $0xc
  80134d:	e8 cd fe ff ff       	call   80121f <syscall>
  801352:	83 c4 18             	add    $0x18,%esp
}
  801355:	c9                   	leave  
  801356:	c3                   	ret    

00801357 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801357:	55                   	push   %ebp
  801358:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  80135a:	6a 00                	push   $0x0
  80135c:	6a 00                	push   $0x0
  80135e:	6a 00                	push   $0x0
  801360:	6a 00                	push   $0x0
  801362:	6a 00                	push   $0x0
  801364:	6a 0d                	push   $0xd
  801366:	e8 b4 fe ff ff       	call   80121f <syscall>
  80136b:	83 c4 18             	add    $0x18,%esp
}
  80136e:	c9                   	leave  
  80136f:	c3                   	ret    

00801370 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801370:	55                   	push   %ebp
  801371:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801373:	6a 00                	push   $0x0
  801375:	6a 00                	push   $0x0
  801377:	6a 00                	push   $0x0
  801379:	6a 00                	push   $0x0
  80137b:	6a 00                	push   $0x0
  80137d:	6a 0e                	push   $0xe
  80137f:	e8 9b fe ff ff       	call   80121f <syscall>
  801384:	83 c4 18             	add    $0x18,%esp
}
  801387:	c9                   	leave  
  801388:	c3                   	ret    

00801389 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801389:	55                   	push   %ebp
  80138a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  80138c:	6a 00                	push   $0x0
  80138e:	6a 00                	push   $0x0
  801390:	6a 00                	push   $0x0
  801392:	6a 00                	push   $0x0
  801394:	6a 00                	push   $0x0
  801396:	6a 0f                	push   $0xf
  801398:	e8 82 fe ff ff       	call   80121f <syscall>
  80139d:	83 c4 18             	add    $0x18,%esp
}
  8013a0:	c9                   	leave  
  8013a1:	c3                   	ret    

008013a2 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  8013a2:	55                   	push   %ebp
  8013a3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  8013a5:	6a 00                	push   $0x0
  8013a7:	6a 00                	push   $0x0
  8013a9:	6a 00                	push   $0x0
  8013ab:	6a 00                	push   $0x0
  8013ad:	ff 75 08             	pushl  0x8(%ebp)
  8013b0:	6a 10                	push   $0x10
  8013b2:	e8 68 fe ff ff       	call   80121f <syscall>
  8013b7:	83 c4 18             	add    $0x18,%esp
}
  8013ba:	c9                   	leave  
  8013bb:	c3                   	ret    

008013bc <sys_scarce_memory>:

void sys_scarce_memory()
{
  8013bc:	55                   	push   %ebp
  8013bd:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  8013bf:	6a 00                	push   $0x0
  8013c1:	6a 00                	push   $0x0
  8013c3:	6a 00                	push   $0x0
  8013c5:	6a 00                	push   $0x0
  8013c7:	6a 00                	push   $0x0
  8013c9:	6a 11                	push   $0x11
  8013cb:	e8 4f fe ff ff       	call   80121f <syscall>
  8013d0:	83 c4 18             	add    $0x18,%esp
}
  8013d3:	90                   	nop
  8013d4:	c9                   	leave  
  8013d5:	c3                   	ret    

008013d6 <sys_cputc>:

void
sys_cputc(const char c)
{
  8013d6:	55                   	push   %ebp
  8013d7:	89 e5                	mov    %esp,%ebp
  8013d9:	83 ec 04             	sub    $0x4,%esp
  8013dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8013df:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  8013e2:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8013e6:	6a 00                	push   $0x0
  8013e8:	6a 00                	push   $0x0
  8013ea:	6a 00                	push   $0x0
  8013ec:	6a 00                	push   $0x0
  8013ee:	50                   	push   %eax
  8013ef:	6a 01                	push   $0x1
  8013f1:	e8 29 fe ff ff       	call   80121f <syscall>
  8013f6:	83 c4 18             	add    $0x18,%esp
}
  8013f9:	90                   	nop
  8013fa:	c9                   	leave  
  8013fb:	c3                   	ret    

008013fc <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  8013fc:	55                   	push   %ebp
  8013fd:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  8013ff:	6a 00                	push   $0x0
  801401:	6a 00                	push   $0x0
  801403:	6a 00                	push   $0x0
  801405:	6a 00                	push   $0x0
  801407:	6a 00                	push   $0x0
  801409:	6a 14                	push   $0x14
  80140b:	e8 0f fe ff ff       	call   80121f <syscall>
  801410:	83 c4 18             	add    $0x18,%esp
}
  801413:	90                   	nop
  801414:	c9                   	leave  
  801415:	c3                   	ret    

00801416 <sys_create_shared_object>:

int sys_create_shared_object(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801416:	55                   	push   %ebp
  801417:	89 e5                	mov    %esp,%ebp
  801419:	83 ec 04             	sub    $0x4,%esp
  80141c:	8b 45 10             	mov    0x10(%ebp),%eax
  80141f:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801422:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801425:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801429:	8b 45 08             	mov    0x8(%ebp),%eax
  80142c:	6a 00                	push   $0x0
  80142e:	51                   	push   %ecx
  80142f:	52                   	push   %edx
  801430:	ff 75 0c             	pushl  0xc(%ebp)
  801433:	50                   	push   %eax
  801434:	6a 15                	push   $0x15
  801436:	e8 e4 fd ff ff       	call   80121f <syscall>
  80143b:	83 c4 18             	add    $0x18,%esp
}
  80143e:	c9                   	leave  
  80143f:	c3                   	ret    

00801440 <sys_size_of_shared_object>:

//2017:
int sys_size_of_shared_object(int32 ownerID, char* shareName)
{
  801440:	55                   	push   %ebp
  801441:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801443:	8b 55 0c             	mov    0xc(%ebp),%edx
  801446:	8b 45 08             	mov    0x8(%ebp),%eax
  801449:	6a 00                	push   $0x0
  80144b:	6a 00                	push   $0x0
  80144d:	6a 00                	push   $0x0
  80144f:	52                   	push   %edx
  801450:	50                   	push   %eax
  801451:	6a 16                	push   $0x16
  801453:	e8 c7 fd ff ff       	call   80121f <syscall>
  801458:	83 c4 18             	add    $0x18,%esp
}
  80145b:	c9                   	leave  
  80145c:	c3                   	ret    

0080145d <sys_get_shared_object>:
//==========

int sys_get_shared_object(int32 ownerID, char* shareName, void* virtual_address)
{
  80145d:	55                   	push   %ebp
  80145e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801460:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801463:	8b 55 0c             	mov    0xc(%ebp),%edx
  801466:	8b 45 08             	mov    0x8(%ebp),%eax
  801469:	6a 00                	push   $0x0
  80146b:	6a 00                	push   $0x0
  80146d:	51                   	push   %ecx
  80146e:	52                   	push   %edx
  80146f:	50                   	push   %eax
  801470:	6a 17                	push   $0x17
  801472:	e8 a8 fd ff ff       	call   80121f <syscall>
  801477:	83 c4 18             	add    $0x18,%esp
}
  80147a:	c9                   	leave  
  80147b:	c3                   	ret    

0080147c <sys_delete_shared_object>:

int sys_delete_shared_object(int32 sharedObjectID, void *startVA)
{
  80147c:	55                   	push   %ebp
  80147d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  80147f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801482:	8b 45 08             	mov    0x8(%ebp),%eax
  801485:	6a 00                	push   $0x0
  801487:	6a 00                	push   $0x0
  801489:	6a 00                	push   $0x0
  80148b:	52                   	push   %edx
  80148c:	50                   	push   %eax
  80148d:	6a 18                	push   $0x18
  80148f:	e8 8b fd ff ff       	call   80121f <syscall>
  801494:	83 c4 18             	add    $0x18,%esp
}
  801497:	c9                   	leave  
  801498:	c3                   	ret    

00801499 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801499:	55                   	push   %ebp
  80149a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  80149c:	8b 45 08             	mov    0x8(%ebp),%eax
  80149f:	6a 00                	push   $0x0
  8014a1:	ff 75 14             	pushl  0x14(%ebp)
  8014a4:	ff 75 10             	pushl  0x10(%ebp)
  8014a7:	ff 75 0c             	pushl  0xc(%ebp)
  8014aa:	50                   	push   %eax
  8014ab:	6a 19                	push   $0x19
  8014ad:	e8 6d fd ff ff       	call   80121f <syscall>
  8014b2:	83 c4 18             	add    $0x18,%esp
}
  8014b5:	c9                   	leave  
  8014b6:	c3                   	ret    

008014b7 <sys_run_env>:

void sys_run_env(int32 envId)
{
  8014b7:	55                   	push   %ebp
  8014b8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  8014ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8014bd:	6a 00                	push   $0x0
  8014bf:	6a 00                	push   $0x0
  8014c1:	6a 00                	push   $0x0
  8014c3:	6a 00                	push   $0x0
  8014c5:	50                   	push   %eax
  8014c6:	6a 1a                	push   $0x1a
  8014c8:	e8 52 fd ff ff       	call   80121f <syscall>
  8014cd:	83 c4 18             	add    $0x18,%esp
}
  8014d0:	90                   	nop
  8014d1:	c9                   	leave  
  8014d2:	c3                   	ret    

008014d3 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  8014d3:	55                   	push   %ebp
  8014d4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  8014d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8014d9:	6a 00                	push   $0x0
  8014db:	6a 00                	push   $0x0
  8014dd:	6a 00                	push   $0x0
  8014df:	6a 00                	push   $0x0
  8014e1:	50                   	push   %eax
  8014e2:	6a 1b                	push   $0x1b
  8014e4:	e8 36 fd ff ff       	call   80121f <syscall>
  8014e9:	83 c4 18             	add    $0x18,%esp
}
  8014ec:	c9                   	leave  
  8014ed:	c3                   	ret    

008014ee <sys_getenvid>:

int32 sys_getenvid(void)
{
  8014ee:	55                   	push   %ebp
  8014ef:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  8014f1:	6a 00                	push   $0x0
  8014f3:	6a 00                	push   $0x0
  8014f5:	6a 00                	push   $0x0
  8014f7:	6a 00                	push   $0x0
  8014f9:	6a 00                	push   $0x0
  8014fb:	6a 05                	push   $0x5
  8014fd:	e8 1d fd ff ff       	call   80121f <syscall>
  801502:	83 c4 18             	add    $0x18,%esp
}
  801505:	c9                   	leave  
  801506:	c3                   	ret    

00801507 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801507:	55                   	push   %ebp
  801508:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  80150a:	6a 00                	push   $0x0
  80150c:	6a 00                	push   $0x0
  80150e:	6a 00                	push   $0x0
  801510:	6a 00                	push   $0x0
  801512:	6a 00                	push   $0x0
  801514:	6a 06                	push   $0x6
  801516:	e8 04 fd ff ff       	call   80121f <syscall>
  80151b:	83 c4 18             	add    $0x18,%esp
}
  80151e:	c9                   	leave  
  80151f:	c3                   	ret    

00801520 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801520:	55                   	push   %ebp
  801521:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801523:	6a 00                	push   $0x0
  801525:	6a 00                	push   $0x0
  801527:	6a 00                	push   $0x0
  801529:	6a 00                	push   $0x0
  80152b:	6a 00                	push   $0x0
  80152d:	6a 07                	push   $0x7
  80152f:	e8 eb fc ff ff       	call   80121f <syscall>
  801534:	83 c4 18             	add    $0x18,%esp
}
  801537:	c9                   	leave  
  801538:	c3                   	ret    

00801539 <sys_exit_env>:


void sys_exit_env(void)
{
  801539:	55                   	push   %ebp
  80153a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  80153c:	6a 00                	push   $0x0
  80153e:	6a 00                	push   $0x0
  801540:	6a 00                	push   $0x0
  801542:	6a 00                	push   $0x0
  801544:	6a 00                	push   $0x0
  801546:	6a 1c                	push   $0x1c
  801548:	e8 d2 fc ff ff       	call   80121f <syscall>
  80154d:	83 c4 18             	add    $0x18,%esp
}
  801550:	90                   	nop
  801551:	c9                   	leave  
  801552:	c3                   	ret    

00801553 <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  801553:	55                   	push   %ebp
  801554:	89 e5                	mov    %esp,%ebp
  801556:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801559:	8d 45 f8             	lea    -0x8(%ebp),%eax
  80155c:	8d 50 04             	lea    0x4(%eax),%edx
  80155f:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801562:	6a 00                	push   $0x0
  801564:	6a 00                	push   $0x0
  801566:	6a 00                	push   $0x0
  801568:	52                   	push   %edx
  801569:	50                   	push   %eax
  80156a:	6a 1d                	push   $0x1d
  80156c:	e8 ae fc ff ff       	call   80121f <syscall>
  801571:	83 c4 18             	add    $0x18,%esp
	return result;
  801574:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801577:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80157a:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80157d:	89 01                	mov    %eax,(%ecx)
  80157f:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801582:	8b 45 08             	mov    0x8(%ebp),%eax
  801585:	c9                   	leave  
  801586:	c2 04 00             	ret    $0x4

00801589 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801589:	55                   	push   %ebp
  80158a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  80158c:	6a 00                	push   $0x0
  80158e:	6a 00                	push   $0x0
  801590:	ff 75 10             	pushl  0x10(%ebp)
  801593:	ff 75 0c             	pushl  0xc(%ebp)
  801596:	ff 75 08             	pushl  0x8(%ebp)
  801599:	6a 13                	push   $0x13
  80159b:	e8 7f fc ff ff       	call   80121f <syscall>
  8015a0:	83 c4 18             	add    $0x18,%esp
	return ;
  8015a3:	90                   	nop
}
  8015a4:	c9                   	leave  
  8015a5:	c3                   	ret    

008015a6 <sys_rcr2>:
uint32 sys_rcr2()
{
  8015a6:	55                   	push   %ebp
  8015a7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  8015a9:	6a 00                	push   $0x0
  8015ab:	6a 00                	push   $0x0
  8015ad:	6a 00                	push   $0x0
  8015af:	6a 00                	push   $0x0
  8015b1:	6a 00                	push   $0x0
  8015b3:	6a 1e                	push   $0x1e
  8015b5:	e8 65 fc ff ff       	call   80121f <syscall>
  8015ba:	83 c4 18             	add    $0x18,%esp
}
  8015bd:	c9                   	leave  
  8015be:	c3                   	ret    

008015bf <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  8015bf:	55                   	push   %ebp
  8015c0:	89 e5                	mov    %esp,%ebp
  8015c2:	83 ec 04             	sub    $0x4,%esp
  8015c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8015c8:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  8015cb:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  8015cf:	6a 00                	push   $0x0
  8015d1:	6a 00                	push   $0x0
  8015d3:	6a 00                	push   $0x0
  8015d5:	6a 00                	push   $0x0
  8015d7:	50                   	push   %eax
  8015d8:	6a 1f                	push   $0x1f
  8015da:	e8 40 fc ff ff       	call   80121f <syscall>
  8015df:	83 c4 18             	add    $0x18,%esp
	return ;
  8015e2:	90                   	nop
}
  8015e3:	c9                   	leave  
  8015e4:	c3                   	ret    

008015e5 <rsttst>:
void rsttst()
{
  8015e5:	55                   	push   %ebp
  8015e6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  8015e8:	6a 00                	push   $0x0
  8015ea:	6a 00                	push   $0x0
  8015ec:	6a 00                	push   $0x0
  8015ee:	6a 00                	push   $0x0
  8015f0:	6a 00                	push   $0x0
  8015f2:	6a 21                	push   $0x21
  8015f4:	e8 26 fc ff ff       	call   80121f <syscall>
  8015f9:	83 c4 18             	add    $0x18,%esp
	return ;
  8015fc:	90                   	nop
}
  8015fd:	c9                   	leave  
  8015fe:	c3                   	ret    

008015ff <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  8015ff:	55                   	push   %ebp
  801600:	89 e5                	mov    %esp,%ebp
  801602:	83 ec 04             	sub    $0x4,%esp
  801605:	8b 45 14             	mov    0x14(%ebp),%eax
  801608:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  80160b:	8b 55 18             	mov    0x18(%ebp),%edx
  80160e:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801612:	52                   	push   %edx
  801613:	50                   	push   %eax
  801614:	ff 75 10             	pushl  0x10(%ebp)
  801617:	ff 75 0c             	pushl  0xc(%ebp)
  80161a:	ff 75 08             	pushl  0x8(%ebp)
  80161d:	6a 20                	push   $0x20
  80161f:	e8 fb fb ff ff       	call   80121f <syscall>
  801624:	83 c4 18             	add    $0x18,%esp
	return ;
  801627:	90                   	nop
}
  801628:	c9                   	leave  
  801629:	c3                   	ret    

0080162a <chktst>:
void chktst(uint32 n)
{
  80162a:	55                   	push   %ebp
  80162b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  80162d:	6a 00                	push   $0x0
  80162f:	6a 00                	push   $0x0
  801631:	6a 00                	push   $0x0
  801633:	6a 00                	push   $0x0
  801635:	ff 75 08             	pushl  0x8(%ebp)
  801638:	6a 22                	push   $0x22
  80163a:	e8 e0 fb ff ff       	call   80121f <syscall>
  80163f:	83 c4 18             	add    $0x18,%esp
	return ;
  801642:	90                   	nop
}
  801643:	c9                   	leave  
  801644:	c3                   	ret    

00801645 <inctst>:

void inctst()
{
  801645:	55                   	push   %ebp
  801646:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801648:	6a 00                	push   $0x0
  80164a:	6a 00                	push   $0x0
  80164c:	6a 00                	push   $0x0
  80164e:	6a 00                	push   $0x0
  801650:	6a 00                	push   $0x0
  801652:	6a 23                	push   $0x23
  801654:	e8 c6 fb ff ff       	call   80121f <syscall>
  801659:	83 c4 18             	add    $0x18,%esp
	return ;
  80165c:	90                   	nop
}
  80165d:	c9                   	leave  
  80165e:	c3                   	ret    

0080165f <gettst>:
uint32 gettst()
{
  80165f:	55                   	push   %ebp
  801660:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801662:	6a 00                	push   $0x0
  801664:	6a 00                	push   $0x0
  801666:	6a 00                	push   $0x0
  801668:	6a 00                	push   $0x0
  80166a:	6a 00                	push   $0x0
  80166c:	6a 24                	push   $0x24
  80166e:	e8 ac fb ff ff       	call   80121f <syscall>
  801673:	83 c4 18             	add    $0x18,%esp
}
  801676:	c9                   	leave  
  801677:	c3                   	ret    

00801678 <sys_get_uheap_strategy>:

/*2025*/
uint32 sys_get_uheap_strategy()
{
  801678:	55                   	push   %ebp
  801679:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80167b:	6a 00                	push   $0x0
  80167d:	6a 00                	push   $0x0
  80167f:	6a 00                	push   $0x0
  801681:	6a 00                	push   $0x0
  801683:	6a 00                	push   $0x0
  801685:	6a 25                	push   $0x25
  801687:	e8 93 fb ff ff       	call   80121f <syscall>
  80168c:	83 c4 18             	add    $0x18,%esp
  80168f:	a3 60 b0 81 00       	mov    %eax,0x81b060
	return uheapPlaceStrategy ;
  801694:	a1 60 b0 81 00       	mov    0x81b060,%eax
}
  801699:	c9                   	leave  
  80169a:	c3                   	ret    

0080169b <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  80169b:	55                   	push   %ebp
  80169c:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = heapStrategy;
  80169e:	8b 45 08             	mov    0x8(%ebp),%eax
  8016a1:	a3 60 b0 81 00       	mov    %eax,0x81b060
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  8016a6:	6a 00                	push   $0x0
  8016a8:	6a 00                	push   $0x0
  8016aa:	6a 00                	push   $0x0
  8016ac:	6a 00                	push   $0x0
  8016ae:	ff 75 08             	pushl  0x8(%ebp)
  8016b1:	6a 26                	push   $0x26
  8016b3:	e8 67 fb ff ff       	call   80121f <syscall>
  8016b8:	83 c4 18             	add    $0x18,%esp
	return ;
  8016bb:	90                   	nop
}
  8016bc:	c9                   	leave  
  8016bd:	c3                   	ret    

008016be <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  8016be:	55                   	push   %ebp
  8016bf:	89 e5                	mov    %esp,%ebp
  8016c1:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  8016c2:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8016c5:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8016c8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8016ce:	6a 00                	push   $0x0
  8016d0:	53                   	push   %ebx
  8016d1:	51                   	push   %ecx
  8016d2:	52                   	push   %edx
  8016d3:	50                   	push   %eax
  8016d4:	6a 27                	push   $0x27
  8016d6:	e8 44 fb ff ff       	call   80121f <syscall>
  8016db:	83 c4 18             	add    $0x18,%esp
}
  8016de:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8016e1:	c9                   	leave  
  8016e2:	c3                   	ret    

008016e3 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  8016e3:	55                   	push   %ebp
  8016e4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  8016e6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8016ec:	6a 00                	push   $0x0
  8016ee:	6a 00                	push   $0x0
  8016f0:	6a 00                	push   $0x0
  8016f2:	52                   	push   %edx
  8016f3:	50                   	push   %eax
  8016f4:	6a 28                	push   $0x28
  8016f6:	e8 24 fb ff ff       	call   80121f <syscall>
  8016fb:	83 c4 18             	add    $0x18,%esp
}
  8016fe:	c9                   	leave  
  8016ff:	c3                   	ret    

00801700 <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  801700:	55                   	push   %ebp
  801701:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  801703:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801706:	8b 55 0c             	mov    0xc(%ebp),%edx
  801709:	8b 45 08             	mov    0x8(%ebp),%eax
  80170c:	6a 00                	push   $0x0
  80170e:	51                   	push   %ecx
  80170f:	ff 75 10             	pushl  0x10(%ebp)
  801712:	52                   	push   %edx
  801713:	50                   	push   %eax
  801714:	6a 29                	push   $0x29
  801716:	e8 04 fb ff ff       	call   80121f <syscall>
  80171b:	83 c4 18             	add    $0x18,%esp
}
  80171e:	c9                   	leave  
  80171f:	c3                   	ret    

00801720 <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801720:	55                   	push   %ebp
  801721:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801723:	6a 00                	push   $0x0
  801725:	6a 00                	push   $0x0
  801727:	ff 75 10             	pushl  0x10(%ebp)
  80172a:	ff 75 0c             	pushl  0xc(%ebp)
  80172d:	ff 75 08             	pushl  0x8(%ebp)
  801730:	6a 12                	push   $0x12
  801732:	e8 e8 fa ff ff       	call   80121f <syscall>
  801737:	83 c4 18             	add    $0x18,%esp
	return ;
  80173a:	90                   	nop
}
  80173b:	c9                   	leave  
  80173c:	c3                   	ret    

0080173d <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  80173d:	55                   	push   %ebp
  80173e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  801740:	8b 55 0c             	mov    0xc(%ebp),%edx
  801743:	8b 45 08             	mov    0x8(%ebp),%eax
  801746:	6a 00                	push   $0x0
  801748:	6a 00                	push   $0x0
  80174a:	6a 00                	push   $0x0
  80174c:	52                   	push   %edx
  80174d:	50                   	push   %eax
  80174e:	6a 2a                	push   $0x2a
  801750:	e8 ca fa ff ff       	call   80121f <syscall>
  801755:	83 c4 18             	add    $0x18,%esp
	return;
  801758:	90                   	nop
}
  801759:	c9                   	leave  
  80175a:	c3                   	ret    

0080175b <sys_get_optimal_num_faults>:
/*2025*/
int sys_get_optimal_num_faults()
{
  80175b:	55                   	push   %ebp
  80175c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_optimal_num_faults, 0, 0, 0, 0, 0);
  80175e:	6a 00                	push   $0x0
  801760:	6a 00                	push   $0x0
  801762:	6a 00                	push   $0x0
  801764:	6a 00                	push   $0x0
  801766:	6a 00                	push   $0x0
  801768:	6a 2b                	push   $0x2b
  80176a:	e8 b0 fa ff ff       	call   80121f <syscall>
  80176f:	83 c4 18             	add    $0x18,%esp
}
  801772:	c9                   	leave  
  801773:	c3                   	ret    

00801774 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801774:	55                   	push   %ebp
  801775:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801777:	6a 00                	push   $0x0
  801779:	6a 00                	push   $0x0
  80177b:	6a 00                	push   $0x0
  80177d:	ff 75 0c             	pushl  0xc(%ebp)
  801780:	ff 75 08             	pushl  0x8(%ebp)
  801783:	6a 2d                	push   $0x2d
  801785:	e8 95 fa ff ff       	call   80121f <syscall>
  80178a:	83 c4 18             	add    $0x18,%esp
	return;
  80178d:	90                   	nop
}
  80178e:	c9                   	leave  
  80178f:	c3                   	ret    

00801790 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801790:	55                   	push   %ebp
  801791:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801793:	6a 00                	push   $0x0
  801795:	6a 00                	push   $0x0
  801797:	6a 00                	push   $0x0
  801799:	ff 75 0c             	pushl  0xc(%ebp)
  80179c:	ff 75 08             	pushl  0x8(%ebp)
  80179f:	6a 2c                	push   $0x2c
  8017a1:	e8 79 fa ff ff       	call   80121f <syscall>
  8017a6:	83 c4 18             	add    $0x18,%esp
	return ;
  8017a9:	90                   	nop
}
  8017aa:	c9                   	leave  
  8017ab:	c3                   	ret    

008017ac <sys_env_set_priority>:


void sys_env_set_priority(int32 envID, int priority)
{
  8017ac:	55                   	push   %ebp
  8017ad:	89 e5                	mov    %esp,%ebp
  8017af:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.IM#4] CPU SCHEDULING - #1 System Calls - Add suitable code here
	//Your code is here
	//Comment the following line
	panic("sys_env_set_priority() is not implemented yet...!!");
  8017b2:	83 ec 04             	sub    $0x4,%esp
  8017b5:	68 88 21 80 00       	push   $0x802188
  8017ba:	68 25 01 00 00       	push   $0x125
  8017bf:	68 bb 21 80 00       	push   $0x8021bb
  8017c4:	e8 00 00 00 00       	call   8017c9 <_panic>

008017c9 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  8017c9:	55                   	push   %ebp
  8017ca:	89 e5                	mov    %esp,%ebp
  8017cc:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  8017cf:	8d 45 10             	lea    0x10(%ebp),%eax
  8017d2:	83 c0 04             	add    $0x4,%eax
  8017d5:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  8017d8:	a1 1c b1 81 00       	mov    0x81b11c,%eax
  8017dd:	85 c0                	test   %eax,%eax
  8017df:	74 16                	je     8017f7 <_panic+0x2e>
		cprintf("%s: ", argv0);
  8017e1:	a1 1c b1 81 00       	mov    0x81b11c,%eax
  8017e6:	83 ec 08             	sub    $0x8,%esp
  8017e9:	50                   	push   %eax
  8017ea:	68 cc 21 80 00       	push   $0x8021cc
  8017ef:	e8 46 eb ff ff       	call   80033a <cprintf>
  8017f4:	83 c4 10             	add    $0x10,%esp
	cprintf_colored(TEXT_PANIC_CLR, "user [EVAL_FINAL]panic in %s at %s:%d: ", binaryname, file, line);
  8017f7:	a1 04 30 80 00       	mov    0x803004,%eax
  8017fc:	83 ec 0c             	sub    $0xc,%esp
  8017ff:	ff 75 0c             	pushl  0xc(%ebp)
  801802:	ff 75 08             	pushl  0x8(%ebp)
  801805:	50                   	push   %eax
  801806:	68 d4 21 80 00       	push   $0x8021d4
  80180b:	6a 74                	push   $0x74
  80180d:	e8 55 eb ff ff       	call   800367 <cprintf_colored>
  801812:	83 c4 20             	add    $0x20,%esp
	vcprintf(fmt, ap);
  801815:	8b 45 10             	mov    0x10(%ebp),%eax
  801818:	83 ec 08             	sub    $0x8,%esp
  80181b:	ff 75 f4             	pushl  -0xc(%ebp)
  80181e:	50                   	push   %eax
  80181f:	e8 a7 ea ff ff       	call   8002cb <vcprintf>
  801824:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  801827:	83 ec 08             	sub    $0x8,%esp
  80182a:	6a 00                	push   $0x0
  80182c:	68 fc 21 80 00       	push   $0x8021fc
  801831:	e8 95 ea ff ff       	call   8002cb <vcprintf>
  801836:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  801839:	e8 0e ea ff ff       	call   80024c <exit>

	// should not return here
	while (1) ;
  80183e:	eb fe                	jmp    80183e <_panic+0x75>

00801840 <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  801840:	55                   	push   %ebp
  801841:	89 e5                	mov    %esp,%ebp
  801843:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  801846:	a1 20 30 80 00       	mov    0x803020,%eax
  80184b:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  801851:	8b 45 0c             	mov    0xc(%ebp),%eax
  801854:	39 c2                	cmp    %eax,%edx
  801856:	74 14                	je     80186c <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  801858:	83 ec 04             	sub    $0x4,%esp
  80185b:	68 00 22 80 00       	push   $0x802200
  801860:	6a 26                	push   $0x26
  801862:	68 4c 22 80 00       	push   $0x80224c
  801867:	e8 5d ff ff ff       	call   8017c9 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  80186c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  801873:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80187a:	e9 c5 00 00 00       	jmp    801944 <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  80187f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801882:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801889:	8b 45 08             	mov    0x8(%ebp),%eax
  80188c:	01 d0                	add    %edx,%eax
  80188e:	8b 00                	mov    (%eax),%eax
  801890:	85 c0                	test   %eax,%eax
  801892:	75 08                	jne    80189c <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  801894:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  801897:	e9 a5 00 00 00       	jmp    801941 <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  80189c:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8018a3:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  8018aa:	eb 69                	jmp    801915 <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  8018ac:	a1 20 30 80 00       	mov    0x803020,%eax
  8018b1:	8b 88 90 05 00 00    	mov    0x590(%eax),%ecx
  8018b7:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8018ba:	89 d0                	mov    %edx,%eax
  8018bc:	01 c0                	add    %eax,%eax
  8018be:	01 d0                	add    %edx,%eax
  8018c0:	c1 e0 03             	shl    $0x3,%eax
  8018c3:	01 c8                	add    %ecx,%eax
  8018c5:	8a 40 04             	mov    0x4(%eax),%al
  8018c8:	84 c0                	test   %al,%al
  8018ca:	75 46                	jne    801912 <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8018cc:	a1 20 30 80 00       	mov    0x803020,%eax
  8018d1:	8b 88 90 05 00 00    	mov    0x590(%eax),%ecx
  8018d7:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8018da:	89 d0                	mov    %edx,%eax
  8018dc:	01 c0                	add    %eax,%eax
  8018de:	01 d0                	add    %edx,%eax
  8018e0:	c1 e0 03             	shl    $0x3,%eax
  8018e3:	01 c8                	add    %ecx,%eax
  8018e5:	8b 00                	mov    (%eax),%eax
  8018e7:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8018ea:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8018ed:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8018f2:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  8018f4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8018f7:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8018fe:	8b 45 08             	mov    0x8(%ebp),%eax
  801901:	01 c8                	add    %ecx,%eax
  801903:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  801905:	39 c2                	cmp    %eax,%edx
  801907:	75 09                	jne    801912 <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  801909:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  801910:	eb 15                	jmp    801927 <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  801912:	ff 45 e8             	incl   -0x18(%ebp)
  801915:	a1 20 30 80 00       	mov    0x803020,%eax
  80191a:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  801920:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801923:	39 c2                	cmp    %eax,%edx
  801925:	77 85                	ja     8018ac <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  801927:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80192b:	75 14                	jne    801941 <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  80192d:	83 ec 04             	sub    $0x4,%esp
  801930:	68 58 22 80 00       	push   $0x802258
  801935:	6a 3a                	push   $0x3a
  801937:	68 4c 22 80 00       	push   $0x80224c
  80193c:	e8 88 fe ff ff       	call   8017c9 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  801941:	ff 45 f0             	incl   -0x10(%ebp)
  801944:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801947:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80194a:	0f 8c 2f ff ff ff    	jl     80187f <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  801950:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  801957:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  80195e:	eb 26                	jmp    801986 <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  801960:	a1 20 30 80 00       	mov    0x803020,%eax
  801965:	8b 88 90 05 00 00    	mov    0x590(%eax),%ecx
  80196b:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80196e:	89 d0                	mov    %edx,%eax
  801970:	01 c0                	add    %eax,%eax
  801972:	01 d0                	add    %edx,%eax
  801974:	c1 e0 03             	shl    $0x3,%eax
  801977:	01 c8                	add    %ecx,%eax
  801979:	8a 40 04             	mov    0x4(%eax),%al
  80197c:	3c 01                	cmp    $0x1,%al
  80197e:	75 03                	jne    801983 <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  801980:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  801983:	ff 45 e0             	incl   -0x20(%ebp)
  801986:	a1 20 30 80 00       	mov    0x803020,%eax
  80198b:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  801991:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801994:	39 c2                	cmp    %eax,%edx
  801996:	77 c8                	ja     801960 <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  801998:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80199b:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  80199e:	74 14                	je     8019b4 <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  8019a0:	83 ec 04             	sub    $0x4,%esp
  8019a3:	68 ac 22 80 00       	push   $0x8022ac
  8019a8:	6a 44                	push   $0x44
  8019aa:	68 4c 22 80 00       	push   $0x80224c
  8019af:	e8 15 fe ff ff       	call   8017c9 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  8019b4:	90                   	nop
  8019b5:	c9                   	leave  
  8019b6:	c3                   	ret    
  8019b7:	90                   	nop

008019b8 <__udivdi3>:
  8019b8:	55                   	push   %ebp
  8019b9:	57                   	push   %edi
  8019ba:	56                   	push   %esi
  8019bb:	53                   	push   %ebx
  8019bc:	83 ec 1c             	sub    $0x1c,%esp
  8019bf:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  8019c3:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  8019c7:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8019cb:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8019cf:	89 ca                	mov    %ecx,%edx
  8019d1:	89 f8                	mov    %edi,%eax
  8019d3:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  8019d7:	85 f6                	test   %esi,%esi
  8019d9:	75 2d                	jne    801a08 <__udivdi3+0x50>
  8019db:	39 cf                	cmp    %ecx,%edi
  8019dd:	77 65                	ja     801a44 <__udivdi3+0x8c>
  8019df:	89 fd                	mov    %edi,%ebp
  8019e1:	85 ff                	test   %edi,%edi
  8019e3:	75 0b                	jne    8019f0 <__udivdi3+0x38>
  8019e5:	b8 01 00 00 00       	mov    $0x1,%eax
  8019ea:	31 d2                	xor    %edx,%edx
  8019ec:	f7 f7                	div    %edi
  8019ee:	89 c5                	mov    %eax,%ebp
  8019f0:	31 d2                	xor    %edx,%edx
  8019f2:	89 c8                	mov    %ecx,%eax
  8019f4:	f7 f5                	div    %ebp
  8019f6:	89 c1                	mov    %eax,%ecx
  8019f8:	89 d8                	mov    %ebx,%eax
  8019fa:	f7 f5                	div    %ebp
  8019fc:	89 cf                	mov    %ecx,%edi
  8019fe:	89 fa                	mov    %edi,%edx
  801a00:	83 c4 1c             	add    $0x1c,%esp
  801a03:	5b                   	pop    %ebx
  801a04:	5e                   	pop    %esi
  801a05:	5f                   	pop    %edi
  801a06:	5d                   	pop    %ebp
  801a07:	c3                   	ret    
  801a08:	39 ce                	cmp    %ecx,%esi
  801a0a:	77 28                	ja     801a34 <__udivdi3+0x7c>
  801a0c:	0f bd fe             	bsr    %esi,%edi
  801a0f:	83 f7 1f             	xor    $0x1f,%edi
  801a12:	75 40                	jne    801a54 <__udivdi3+0x9c>
  801a14:	39 ce                	cmp    %ecx,%esi
  801a16:	72 0a                	jb     801a22 <__udivdi3+0x6a>
  801a18:	3b 44 24 08          	cmp    0x8(%esp),%eax
  801a1c:	0f 87 9e 00 00 00    	ja     801ac0 <__udivdi3+0x108>
  801a22:	b8 01 00 00 00       	mov    $0x1,%eax
  801a27:	89 fa                	mov    %edi,%edx
  801a29:	83 c4 1c             	add    $0x1c,%esp
  801a2c:	5b                   	pop    %ebx
  801a2d:	5e                   	pop    %esi
  801a2e:	5f                   	pop    %edi
  801a2f:	5d                   	pop    %ebp
  801a30:	c3                   	ret    
  801a31:	8d 76 00             	lea    0x0(%esi),%esi
  801a34:	31 ff                	xor    %edi,%edi
  801a36:	31 c0                	xor    %eax,%eax
  801a38:	89 fa                	mov    %edi,%edx
  801a3a:	83 c4 1c             	add    $0x1c,%esp
  801a3d:	5b                   	pop    %ebx
  801a3e:	5e                   	pop    %esi
  801a3f:	5f                   	pop    %edi
  801a40:	5d                   	pop    %ebp
  801a41:	c3                   	ret    
  801a42:	66 90                	xchg   %ax,%ax
  801a44:	89 d8                	mov    %ebx,%eax
  801a46:	f7 f7                	div    %edi
  801a48:	31 ff                	xor    %edi,%edi
  801a4a:	89 fa                	mov    %edi,%edx
  801a4c:	83 c4 1c             	add    $0x1c,%esp
  801a4f:	5b                   	pop    %ebx
  801a50:	5e                   	pop    %esi
  801a51:	5f                   	pop    %edi
  801a52:	5d                   	pop    %ebp
  801a53:	c3                   	ret    
  801a54:	bd 20 00 00 00       	mov    $0x20,%ebp
  801a59:	89 eb                	mov    %ebp,%ebx
  801a5b:	29 fb                	sub    %edi,%ebx
  801a5d:	89 f9                	mov    %edi,%ecx
  801a5f:	d3 e6                	shl    %cl,%esi
  801a61:	89 c5                	mov    %eax,%ebp
  801a63:	88 d9                	mov    %bl,%cl
  801a65:	d3 ed                	shr    %cl,%ebp
  801a67:	89 e9                	mov    %ebp,%ecx
  801a69:	09 f1                	or     %esi,%ecx
  801a6b:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  801a6f:	89 f9                	mov    %edi,%ecx
  801a71:	d3 e0                	shl    %cl,%eax
  801a73:	89 c5                	mov    %eax,%ebp
  801a75:	89 d6                	mov    %edx,%esi
  801a77:	88 d9                	mov    %bl,%cl
  801a79:	d3 ee                	shr    %cl,%esi
  801a7b:	89 f9                	mov    %edi,%ecx
  801a7d:	d3 e2                	shl    %cl,%edx
  801a7f:	8b 44 24 08          	mov    0x8(%esp),%eax
  801a83:	88 d9                	mov    %bl,%cl
  801a85:	d3 e8                	shr    %cl,%eax
  801a87:	09 c2                	or     %eax,%edx
  801a89:	89 d0                	mov    %edx,%eax
  801a8b:	89 f2                	mov    %esi,%edx
  801a8d:	f7 74 24 0c          	divl   0xc(%esp)
  801a91:	89 d6                	mov    %edx,%esi
  801a93:	89 c3                	mov    %eax,%ebx
  801a95:	f7 e5                	mul    %ebp
  801a97:	39 d6                	cmp    %edx,%esi
  801a99:	72 19                	jb     801ab4 <__udivdi3+0xfc>
  801a9b:	74 0b                	je     801aa8 <__udivdi3+0xf0>
  801a9d:	89 d8                	mov    %ebx,%eax
  801a9f:	31 ff                	xor    %edi,%edi
  801aa1:	e9 58 ff ff ff       	jmp    8019fe <__udivdi3+0x46>
  801aa6:	66 90                	xchg   %ax,%ax
  801aa8:	8b 54 24 08          	mov    0x8(%esp),%edx
  801aac:	89 f9                	mov    %edi,%ecx
  801aae:	d3 e2                	shl    %cl,%edx
  801ab0:	39 c2                	cmp    %eax,%edx
  801ab2:	73 e9                	jae    801a9d <__udivdi3+0xe5>
  801ab4:	8d 43 ff             	lea    -0x1(%ebx),%eax
  801ab7:	31 ff                	xor    %edi,%edi
  801ab9:	e9 40 ff ff ff       	jmp    8019fe <__udivdi3+0x46>
  801abe:	66 90                	xchg   %ax,%ax
  801ac0:	31 c0                	xor    %eax,%eax
  801ac2:	e9 37 ff ff ff       	jmp    8019fe <__udivdi3+0x46>
  801ac7:	90                   	nop

00801ac8 <__umoddi3>:
  801ac8:	55                   	push   %ebp
  801ac9:	57                   	push   %edi
  801aca:	56                   	push   %esi
  801acb:	53                   	push   %ebx
  801acc:	83 ec 1c             	sub    $0x1c,%esp
  801acf:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  801ad3:	8b 74 24 34          	mov    0x34(%esp),%esi
  801ad7:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801adb:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  801adf:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801ae3:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801ae7:	89 f3                	mov    %esi,%ebx
  801ae9:	89 fa                	mov    %edi,%edx
  801aeb:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801aef:	89 34 24             	mov    %esi,(%esp)
  801af2:	85 c0                	test   %eax,%eax
  801af4:	75 1a                	jne    801b10 <__umoddi3+0x48>
  801af6:	39 f7                	cmp    %esi,%edi
  801af8:	0f 86 a2 00 00 00    	jbe    801ba0 <__umoddi3+0xd8>
  801afe:	89 c8                	mov    %ecx,%eax
  801b00:	89 f2                	mov    %esi,%edx
  801b02:	f7 f7                	div    %edi
  801b04:	89 d0                	mov    %edx,%eax
  801b06:	31 d2                	xor    %edx,%edx
  801b08:	83 c4 1c             	add    $0x1c,%esp
  801b0b:	5b                   	pop    %ebx
  801b0c:	5e                   	pop    %esi
  801b0d:	5f                   	pop    %edi
  801b0e:	5d                   	pop    %ebp
  801b0f:	c3                   	ret    
  801b10:	39 f0                	cmp    %esi,%eax
  801b12:	0f 87 ac 00 00 00    	ja     801bc4 <__umoddi3+0xfc>
  801b18:	0f bd e8             	bsr    %eax,%ebp
  801b1b:	83 f5 1f             	xor    $0x1f,%ebp
  801b1e:	0f 84 ac 00 00 00    	je     801bd0 <__umoddi3+0x108>
  801b24:	bf 20 00 00 00       	mov    $0x20,%edi
  801b29:	29 ef                	sub    %ebp,%edi
  801b2b:	89 fe                	mov    %edi,%esi
  801b2d:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801b31:	89 e9                	mov    %ebp,%ecx
  801b33:	d3 e0                	shl    %cl,%eax
  801b35:	89 d7                	mov    %edx,%edi
  801b37:	89 f1                	mov    %esi,%ecx
  801b39:	d3 ef                	shr    %cl,%edi
  801b3b:	09 c7                	or     %eax,%edi
  801b3d:	89 e9                	mov    %ebp,%ecx
  801b3f:	d3 e2                	shl    %cl,%edx
  801b41:	89 14 24             	mov    %edx,(%esp)
  801b44:	89 d8                	mov    %ebx,%eax
  801b46:	d3 e0                	shl    %cl,%eax
  801b48:	89 c2                	mov    %eax,%edx
  801b4a:	8b 44 24 08          	mov    0x8(%esp),%eax
  801b4e:	d3 e0                	shl    %cl,%eax
  801b50:	89 44 24 04          	mov    %eax,0x4(%esp)
  801b54:	8b 44 24 08          	mov    0x8(%esp),%eax
  801b58:	89 f1                	mov    %esi,%ecx
  801b5a:	d3 e8                	shr    %cl,%eax
  801b5c:	09 d0                	or     %edx,%eax
  801b5e:	d3 eb                	shr    %cl,%ebx
  801b60:	89 da                	mov    %ebx,%edx
  801b62:	f7 f7                	div    %edi
  801b64:	89 d3                	mov    %edx,%ebx
  801b66:	f7 24 24             	mull   (%esp)
  801b69:	89 c6                	mov    %eax,%esi
  801b6b:	89 d1                	mov    %edx,%ecx
  801b6d:	39 d3                	cmp    %edx,%ebx
  801b6f:	0f 82 87 00 00 00    	jb     801bfc <__umoddi3+0x134>
  801b75:	0f 84 91 00 00 00    	je     801c0c <__umoddi3+0x144>
  801b7b:	8b 54 24 04          	mov    0x4(%esp),%edx
  801b7f:	29 f2                	sub    %esi,%edx
  801b81:	19 cb                	sbb    %ecx,%ebx
  801b83:	89 d8                	mov    %ebx,%eax
  801b85:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  801b89:	d3 e0                	shl    %cl,%eax
  801b8b:	89 e9                	mov    %ebp,%ecx
  801b8d:	d3 ea                	shr    %cl,%edx
  801b8f:	09 d0                	or     %edx,%eax
  801b91:	89 e9                	mov    %ebp,%ecx
  801b93:	d3 eb                	shr    %cl,%ebx
  801b95:	89 da                	mov    %ebx,%edx
  801b97:	83 c4 1c             	add    $0x1c,%esp
  801b9a:	5b                   	pop    %ebx
  801b9b:	5e                   	pop    %esi
  801b9c:	5f                   	pop    %edi
  801b9d:	5d                   	pop    %ebp
  801b9e:	c3                   	ret    
  801b9f:	90                   	nop
  801ba0:	89 fd                	mov    %edi,%ebp
  801ba2:	85 ff                	test   %edi,%edi
  801ba4:	75 0b                	jne    801bb1 <__umoddi3+0xe9>
  801ba6:	b8 01 00 00 00       	mov    $0x1,%eax
  801bab:	31 d2                	xor    %edx,%edx
  801bad:	f7 f7                	div    %edi
  801baf:	89 c5                	mov    %eax,%ebp
  801bb1:	89 f0                	mov    %esi,%eax
  801bb3:	31 d2                	xor    %edx,%edx
  801bb5:	f7 f5                	div    %ebp
  801bb7:	89 c8                	mov    %ecx,%eax
  801bb9:	f7 f5                	div    %ebp
  801bbb:	89 d0                	mov    %edx,%eax
  801bbd:	e9 44 ff ff ff       	jmp    801b06 <__umoddi3+0x3e>
  801bc2:	66 90                	xchg   %ax,%ax
  801bc4:	89 c8                	mov    %ecx,%eax
  801bc6:	89 f2                	mov    %esi,%edx
  801bc8:	83 c4 1c             	add    $0x1c,%esp
  801bcb:	5b                   	pop    %ebx
  801bcc:	5e                   	pop    %esi
  801bcd:	5f                   	pop    %edi
  801bce:	5d                   	pop    %ebp
  801bcf:	c3                   	ret    
  801bd0:	3b 04 24             	cmp    (%esp),%eax
  801bd3:	72 06                	jb     801bdb <__umoddi3+0x113>
  801bd5:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  801bd9:	77 0f                	ja     801bea <__umoddi3+0x122>
  801bdb:	89 f2                	mov    %esi,%edx
  801bdd:	29 f9                	sub    %edi,%ecx
  801bdf:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  801be3:	89 14 24             	mov    %edx,(%esp)
  801be6:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801bea:	8b 44 24 04          	mov    0x4(%esp),%eax
  801bee:	8b 14 24             	mov    (%esp),%edx
  801bf1:	83 c4 1c             	add    $0x1c,%esp
  801bf4:	5b                   	pop    %ebx
  801bf5:	5e                   	pop    %esi
  801bf6:	5f                   	pop    %edi
  801bf7:	5d                   	pop    %ebp
  801bf8:	c3                   	ret    
  801bf9:	8d 76 00             	lea    0x0(%esi),%esi
  801bfc:	2b 04 24             	sub    (%esp),%eax
  801bff:	19 fa                	sbb    %edi,%edx
  801c01:	89 d1                	mov    %edx,%ecx
  801c03:	89 c6                	mov    %eax,%esi
  801c05:	e9 71 ff ff ff       	jmp    801b7b <__umoddi3+0xb3>
  801c0a:	66 90                	xchg   %ax,%ax
  801c0c:	39 44 24 04          	cmp    %eax,0x4(%esp)
  801c10:	72 ea                	jb     801bfc <__umoddi3+0x134>
  801c12:	89 d9                	mov    %ebx,%ecx
  801c14:	e9 62 ff ff ff       	jmp    801b7b <__umoddi3+0xb3>
