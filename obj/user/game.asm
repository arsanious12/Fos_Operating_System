
obj/user/game:     file format elf32-i386


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
  800031:	e8 98 00 00 00       	call   8000ce <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
#include <inc/lib.h>

void
_main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	83 ec 18             	sub    $0x18,%esp
	int i=28;
  80003e:	c7 45 f4 1c 00 00 00 	movl   $0x1c,-0xc(%ebp)
	int txtClr = TEXT_black;
  800045:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	for(;i<128; i++)
  80004c:	eb 77                	jmp    8000c5 <_main+0x8d>
	{
		txtClr = (txtClr + 1) % 16;
  80004e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800051:	40                   	inc    %eax
  800052:	25 0f 00 00 80       	and    $0x8000000f,%eax
  800057:	85 c0                	test   %eax,%eax
  800059:	79 05                	jns    800060 <_main+0x28>
  80005b:	48                   	dec    %eax
  80005c:	83 c8 f0             	or     $0xfffffff0,%eax
  80005f:	40                   	inc    %eax
  800060:	89 45 f0             	mov    %eax,-0x10(%ebp)
		int c=0;
  800063:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for(;c<10; c++)
  80006a:	eb 19                	jmp    800085 <_main+0x4d>
		{
			cprintf_colored(txtClr, "%~%c",i);
  80006c:	83 ec 04             	sub    $0x4,%esp
  80006f:	ff 75 f4             	pushl  -0xc(%ebp)
  800072:	68 60 1c 80 00       	push   $0x801c60
  800077:	ff 75 f0             	pushl  -0x10(%ebp)
  80007a:	e8 21 03 00 00       	call   8003a0 <cprintf_colored>
  80007f:	83 c4 10             	add    $0x10,%esp
	int txtClr = TEXT_black;
	for(;i<128; i++)
	{
		txtClr = (txtClr + 1) % 16;
		int c=0;
		for(;c<10; c++)
  800082:	ff 45 ec             	incl   -0x14(%ebp)
  800085:	83 7d ec 09          	cmpl   $0x9,-0x14(%ebp)
  800089:	7e e1                	jle    80006c <_main+0x34>
		{
			cprintf_colored(txtClr, "%~%c",i);
		}
		int d=0;
  80008b:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		for(; d< 5000000; d++);
  800092:	eb 03                	jmp    800097 <_main+0x5f>
  800094:	ff 45 e8             	incl   -0x18(%ebp)
  800097:	81 7d e8 3f 4b 4c 00 	cmpl   $0x4c4b3f,-0x18(%ebp)
  80009e:	7e f4                	jle    800094 <_main+0x5c>
		c=0;
  8000a0:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for(;c<10; c++)
  8000a7:	eb 13                	jmp    8000bc <_main+0x84>
		{
			cprintf("%~\b");
  8000a9:	83 ec 0c             	sub    $0xc,%esp
  8000ac:	68 65 1c 80 00       	push   $0x801c65
  8000b1:	e8 bd 02 00 00       	call   800373 <cprintf>
  8000b6:	83 c4 10             	add    $0x10,%esp
			cprintf_colored(txtClr, "%~%c",i);
		}
		int d=0;
		for(; d< 5000000; d++);
		c=0;
		for(;c<10; c++)
  8000b9:	ff 45 ec             	incl   -0x14(%ebp)
  8000bc:	83 7d ec 09          	cmpl   $0x9,-0x14(%ebp)
  8000c0:	7e e7                	jle    8000a9 <_main+0x71>
void
_main(void)
{
	int i=28;
	int txtClr = TEXT_black;
	for(;i<128; i++)
  8000c2:	ff 45 f4             	incl   -0xc(%ebp)
  8000c5:	83 7d f4 7f          	cmpl   $0x7f,-0xc(%ebp)
  8000c9:	7e 83                	jle    80004e <_main+0x16>
		{
			cprintf("%~\b");
		}
	}

	return;
  8000cb:	90                   	nop
}
  8000cc:	c9                   	leave  
  8000cd:	c3                   	ret    

008000ce <libmain>:
volatile bool printStats = 1;

volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";
void
libmain(int argc, char **argv)
{
  8000ce:	55                   	push   %ebp
  8000cf:	89 e5                	mov    %esp,%ebp
  8000d1:	57                   	push   %edi
  8000d2:	56                   	push   %esi
  8000d3:	53                   	push   %ebx
  8000d4:	83 ec 7c             	sub    $0x7c,%esp
	//printStats = 1;
	int envIndex = sys_getenvindex();
  8000d7:	e8 64 14 00 00       	call   801540 <sys_getenvindex>
  8000dc:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	myEnv = &(envs[envIndex]);
  8000df:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8000e2:	89 d0                	mov    %edx,%eax
  8000e4:	c1 e0 06             	shl    $0x6,%eax
  8000e7:	29 d0                	sub    %edx,%eax
  8000e9:	c1 e0 02             	shl    $0x2,%eax
  8000ec:	01 d0                	add    %edx,%eax
  8000ee:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8000f5:	01 c8                	add    %ecx,%eax
  8000f7:	c1 e0 03             	shl    $0x3,%eax
  8000fa:	01 d0                	add    %edx,%eax
  8000fc:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800103:	29 c2                	sub    %eax,%edx
  800105:	8d 04 95 00 00 00 00 	lea    0x0(,%edx,4),%eax
  80010c:	89 c2                	mov    %eax,%edx
  80010e:	8d 82 00 00 c0 ee    	lea    -0x11400000(%edx),%eax
  800114:	a3 20 30 80 00       	mov    %eax,0x803020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800119:	a1 20 30 80 00       	mov    0x803020,%eax
  80011e:	8a 40 20             	mov    0x20(%eax),%al
  800121:	84 c0                	test   %al,%al
  800123:	74 0d                	je     800132 <libmain+0x64>
		binaryname = myEnv->prog_name;
  800125:	a1 20 30 80 00       	mov    0x803020,%eax
  80012a:	83 c0 20             	add    $0x20,%eax
  80012d:	a3 04 30 80 00       	mov    %eax,0x803004

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800132:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800136:	7e 0a                	jle    800142 <libmain+0x74>
		binaryname = argv[0];
  800138:	8b 45 0c             	mov    0xc(%ebp),%eax
  80013b:	8b 00                	mov    (%eax),%eax
  80013d:	a3 04 30 80 00       	mov    %eax,0x803004

	// call user main routine
	_main(argc, argv);
  800142:	83 ec 08             	sub    $0x8,%esp
  800145:	ff 75 0c             	pushl  0xc(%ebp)
  800148:	ff 75 08             	pushl  0x8(%ebp)
  80014b:	e8 e8 fe ff ff       	call   800038 <_main>
  800150:	83 c4 10             	add    $0x10,%esp

	if (printStats)
  800153:	a1 00 30 80 00       	mov    0x803000,%eax
  800158:	85 c0                	test   %eax,%eax
  80015a:	0f 84 01 01 00 00    	je     800261 <libmain+0x193>
	{
		char isOPTReplCmd[100] = "__IsOPTRepl__" ;
  800160:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  800166:	bb 64 1d 80 00       	mov    $0x801d64,%ebx
  80016b:	ba 0e 00 00 00       	mov    $0xe,%edx
  800170:	89 c7                	mov    %eax,%edi
  800172:	89 de                	mov    %ebx,%esi
  800174:	89 d1                	mov    %edx,%ecx
  800176:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  800178:	8d 55 8a             	lea    -0x76(%ebp),%edx
  80017b:	b9 56 00 00 00       	mov    $0x56,%ecx
  800180:	b0 00                	mov    $0x0,%al
  800182:	89 d7                	mov    %edx,%edi
  800184:	f3 aa                	rep stos %al,%es:(%edi)
		int isOPTRepl = 0;
  800186:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
		sys_utilities(isOPTReplCmd, (uint32)(&isOPTRepl));
  80018d:	8d 45 e0             	lea    -0x20(%ebp),%eax
  800190:	83 ec 08             	sub    $0x8,%esp
  800193:	50                   	push   %eax
  800194:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  80019a:	50                   	push   %eax
  80019b:	e8 d6 15 00 00       	call   801776 <sys_utilities>
  8001a0:	83 c4 10             	add    $0x10,%esp

		sys_lock_cons();
  8001a3:	e8 1f 11 00 00       	call   8012c7 <sys_lock_cons>
		{
			cprintf("**************************************\n");
  8001a8:	83 ec 0c             	sub    $0xc,%esp
  8001ab:	68 84 1c 80 00       	push   $0x801c84
  8001b0:	e8 be 01 00 00       	call   800373 <cprintf>
  8001b5:	83 c4 10             	add    $0x10,%esp
			if (isOPTRepl)
  8001b8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8001bb:	85 c0                	test   %eax,%eax
  8001bd:	74 18                	je     8001d7 <libmain+0x109>
			{
				cprintf("OPTIMAL number of page faults = %d\n", sys_get_optimal_num_faults());
  8001bf:	e8 d0 15 00 00       	call   801794 <sys_get_optimal_num_faults>
  8001c4:	83 ec 08             	sub    $0x8,%esp
  8001c7:	50                   	push   %eax
  8001c8:	68 ac 1c 80 00       	push   $0x801cac
  8001cd:	e8 a1 01 00 00       	call   800373 <cprintf>
  8001d2:	83 c4 10             	add    $0x10,%esp
  8001d5:	eb 59                	jmp    800230 <libmain+0x162>
			}
			else
			{
				cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8001d7:	a1 20 30 80 00       	mov    0x803020,%eax
  8001dc:	8b 90 50 da 01 00    	mov    0x1da50(%eax),%edx
  8001e2:	a1 20 30 80 00       	mov    0x803020,%eax
  8001e7:	8b 80 40 da 01 00    	mov    0x1da40(%eax),%eax
  8001ed:	83 ec 04             	sub    $0x4,%esp
  8001f0:	52                   	push   %edx
  8001f1:	50                   	push   %eax
  8001f2:	68 d0 1c 80 00       	push   $0x801cd0
  8001f7:	e8 77 01 00 00       	call   800373 <cprintf>
  8001fc:	83 c4 10             	add    $0x10,%esp
				cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  8001ff:	a1 20 30 80 00       	mov    0x803020,%eax
  800204:	8b 88 64 da 01 00    	mov    0x1da64(%eax),%ecx
  80020a:	a1 20 30 80 00       	mov    0x803020,%eax
  80020f:	8b 90 60 da 01 00    	mov    0x1da60(%eax),%edx
  800215:	a1 20 30 80 00       	mov    0x803020,%eax
  80021a:	8b 80 5c da 01 00    	mov    0x1da5c(%eax),%eax
  800220:	51                   	push   %ecx
  800221:	52                   	push   %edx
  800222:	50                   	push   %eax
  800223:	68 f8 1c 80 00       	push   $0x801cf8
  800228:	e8 46 01 00 00       	call   800373 <cprintf>
  80022d:	83 c4 10             	add    $0x10,%esp
			}
			//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
			cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800230:	a1 20 30 80 00       	mov    0x803020,%eax
  800235:	8b 80 68 da 01 00    	mov    0x1da68(%eax),%eax
  80023b:	83 ec 08             	sub    $0x8,%esp
  80023e:	50                   	push   %eax
  80023f:	68 50 1d 80 00       	push   $0x801d50
  800244:	e8 2a 01 00 00       	call   800373 <cprintf>
  800249:	83 c4 10             	add    $0x10,%esp
			cprintf("**************************************\n");
  80024c:	83 ec 0c             	sub    $0xc,%esp
  80024f:	68 84 1c 80 00       	push   $0x801c84
  800254:	e8 1a 01 00 00       	call   800373 <cprintf>
  800259:	83 c4 10             	add    $0x10,%esp
		}
		sys_unlock_cons();
  80025c:	e8 80 10 00 00       	call   8012e1 <sys_unlock_cons>
	}

	// exit gracefully
	exit();
  800261:	e8 1f 00 00 00       	call   800285 <exit>
}
  800266:	90                   	nop
  800267:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80026a:	5b                   	pop    %ebx
  80026b:	5e                   	pop    %esi
  80026c:	5f                   	pop    %edi
  80026d:	5d                   	pop    %ebp
  80026e:	c3                   	ret    

0080026f <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  80026f:	55                   	push   %ebp
  800270:	89 e5                	mov    %esp,%ebp
  800272:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800275:	83 ec 0c             	sub    $0xc,%esp
  800278:	6a 00                	push   $0x0
  80027a:	e8 8d 12 00 00       	call   80150c <sys_destroy_env>
  80027f:	83 c4 10             	add    $0x10,%esp
}
  800282:	90                   	nop
  800283:	c9                   	leave  
  800284:	c3                   	ret    

00800285 <exit>:

void
exit(void)
{
  800285:	55                   	push   %ebp
  800286:	89 e5                	mov    %esp,%ebp
  800288:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  80028b:	e8 e2 12 00 00       	call   801572 <sys_exit_env>
}
  800290:	90                   	nop
  800291:	c9                   	leave  
  800292:	c3                   	ret    

00800293 <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  800293:	55                   	push   %ebp
  800294:	89 e5                	mov    %esp,%ebp
  800296:	53                   	push   %ebx
  800297:	83 ec 04             	sub    $0x4,%esp
	b->buf[b->idx++] = ch;
  80029a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80029d:	8b 00                	mov    (%eax),%eax
  80029f:	8d 48 01             	lea    0x1(%eax),%ecx
  8002a2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8002a5:	89 0a                	mov    %ecx,(%edx)
  8002a7:	8b 55 08             	mov    0x8(%ebp),%edx
  8002aa:	88 d1                	mov    %dl,%cl
  8002ac:	8b 55 0c             	mov    0xc(%ebp),%edx
  8002af:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  8002b3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8002b6:	8b 00                	mov    (%eax),%eax
  8002b8:	3d ff 00 00 00       	cmp    $0xff,%eax
  8002bd:	75 30                	jne    8002ef <putch+0x5c>
		sys_cputs(b->buf, b->idx, printProgName, curTextClr);
  8002bf:	8b 15 18 b1 81 00    	mov    0x81b118,%edx
  8002c5:	a0 44 30 80 00       	mov    0x803044,%al
  8002ca:	0f b6 c0             	movzbl %al,%eax
  8002cd:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8002d0:	8b 09                	mov    (%ecx),%ecx
  8002d2:	89 cb                	mov    %ecx,%ebx
  8002d4:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8002d7:	83 c1 08             	add    $0x8,%ecx
  8002da:	52                   	push   %edx
  8002db:	50                   	push   %eax
  8002dc:	53                   	push   %ebx
  8002dd:	51                   	push   %ecx
  8002de:	e8 a0 0f 00 00       	call   801283 <sys_cputs>
  8002e3:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8002e6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8002e9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8002ef:	8b 45 0c             	mov    0xc(%ebp),%eax
  8002f2:	8b 40 04             	mov    0x4(%eax),%eax
  8002f5:	8d 50 01             	lea    0x1(%eax),%edx
  8002f8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8002fb:	89 50 04             	mov    %edx,0x4(%eax)
}
  8002fe:	90                   	nop
  8002ff:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800302:	c9                   	leave  
  800303:	c3                   	ret    

00800304 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800304:	55                   	push   %ebp
  800305:	89 e5                	mov    %esp,%ebp
  800307:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  80030d:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800314:	00 00 00 
	b.cnt = 0;
  800317:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  80031e:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800321:	ff 75 0c             	pushl  0xc(%ebp)
  800324:	ff 75 08             	pushl  0x8(%ebp)
  800327:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80032d:	50                   	push   %eax
  80032e:	68 93 02 80 00       	push   $0x800293
  800333:	e8 5a 02 00 00       	call   800592 <vprintfmt>
  800338:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName, curTextClr);
  80033b:	8b 15 18 b1 81 00    	mov    0x81b118,%edx
  800341:	a0 44 30 80 00       	mov    0x803044,%al
  800346:	0f b6 c0             	movzbl %al,%eax
  800349:	8b 8d f0 fe ff ff    	mov    -0x110(%ebp),%ecx
  80034f:	52                   	push   %edx
  800350:	50                   	push   %eax
  800351:	51                   	push   %ecx
  800352:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800358:	83 c0 08             	add    $0x8,%eax
  80035b:	50                   	push   %eax
  80035c:	e8 22 0f 00 00       	call   801283 <sys_cputs>
  800361:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800364:	c6 05 44 30 80 00 00 	movb   $0x0,0x803044
	return b.cnt;
  80036b:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800371:	c9                   	leave  
  800372:	c3                   	ret    

00800373 <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  800373:	55                   	push   %ebp
  800374:	89 e5                	mov    %esp,%ebp
  800376:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800379:	c6 05 44 30 80 00 01 	movb   $0x1,0x803044
	va_start(ap, fmt);
  800380:	8d 45 0c             	lea    0xc(%ebp),%eax
  800383:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800386:	8b 45 08             	mov    0x8(%ebp),%eax
  800389:	83 ec 08             	sub    $0x8,%esp
  80038c:	ff 75 f4             	pushl  -0xc(%ebp)
  80038f:	50                   	push   %eax
  800390:	e8 6f ff ff ff       	call   800304 <vcprintf>
  800395:	83 c4 10             	add    $0x10,%esp
  800398:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  80039b:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80039e:	c9                   	leave  
  80039f:	c3                   	ret    

008003a0 <cprintf_colored>:

// *************** This text coloring feature is implemented by *************
// ********** Abd-Alrahman Zedan From Team Frozen-Bytes - FCIS'24-25 ********
int cprintf_colored(int textClr, const char *fmt, ...) {
  8003a0:	55                   	push   %ebp
  8003a1:	89 e5                	mov    %esp,%ebp
  8003a3:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  8003a6:	c6 05 44 30 80 00 01 	movb   $0x1,0x803044
	curTextClr = (textClr << 8) ; //set text color by the given value
  8003ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8003b0:	c1 e0 08             	shl    $0x8,%eax
  8003b3:	a3 18 b1 81 00       	mov    %eax,0x81b118
	va_start(ap, fmt);
  8003b8:	8d 45 0c             	lea    0xc(%ebp),%eax
  8003bb:	83 c0 04             	add    $0x4,%eax
  8003be:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8003c1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003c4:	83 ec 08             	sub    $0x8,%esp
  8003c7:	ff 75 f4             	pushl  -0xc(%ebp)
  8003ca:	50                   	push   %eax
  8003cb:	e8 34 ff ff ff       	call   800304 <vcprintf>
  8003d0:	83 c4 10             	add    $0x10,%esp
  8003d3:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);
	curTextClr = TEXT_DEFAULT_CLR; //restore default color
  8003d6:	c7 05 18 b1 81 00 00 	movl   $0x700,0x81b118
  8003dd:	07 00 00 

	return cnt;
  8003e0:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8003e3:	c9                   	leave  
  8003e4:	c3                   	ret    

008003e5 <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  8003e5:	55                   	push   %ebp
  8003e6:	89 e5                	mov    %esp,%ebp
  8003e8:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  8003eb:	e8 d7 0e 00 00       	call   8012c7 <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  8003f0:	8d 45 0c             	lea    0xc(%ebp),%eax
  8003f3:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  8003f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8003f9:	83 ec 08             	sub    $0x8,%esp
  8003fc:	ff 75 f4             	pushl  -0xc(%ebp)
  8003ff:	50                   	push   %eax
  800400:	e8 ff fe ff ff       	call   800304 <vcprintf>
  800405:	83 c4 10             	add    $0x10,%esp
  800408:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  80040b:	e8 d1 0e 00 00       	call   8012e1 <sys_unlock_cons>
	return cnt;
  800410:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800413:	c9                   	leave  
  800414:	c3                   	ret    

00800415 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800415:	55                   	push   %ebp
  800416:	89 e5                	mov    %esp,%ebp
  800418:	53                   	push   %ebx
  800419:	83 ec 14             	sub    $0x14,%esp
  80041c:	8b 45 10             	mov    0x10(%ebp),%eax
  80041f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800422:	8b 45 14             	mov    0x14(%ebp),%eax
  800425:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800428:	8b 45 18             	mov    0x18(%ebp),%eax
  80042b:	ba 00 00 00 00       	mov    $0x0,%edx
  800430:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800433:	77 55                	ja     80048a <printnum+0x75>
  800435:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800438:	72 05                	jb     80043f <printnum+0x2a>
  80043a:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80043d:	77 4b                	ja     80048a <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  80043f:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800442:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800445:	8b 45 18             	mov    0x18(%ebp),%eax
  800448:	ba 00 00 00 00       	mov    $0x0,%edx
  80044d:	52                   	push   %edx
  80044e:	50                   	push   %eax
  80044f:	ff 75 f4             	pushl  -0xc(%ebp)
  800452:	ff 75 f0             	pushl  -0x10(%ebp)
  800455:	e8 96 15 00 00       	call   8019f0 <__udivdi3>
  80045a:	83 c4 10             	add    $0x10,%esp
  80045d:	83 ec 04             	sub    $0x4,%esp
  800460:	ff 75 20             	pushl  0x20(%ebp)
  800463:	53                   	push   %ebx
  800464:	ff 75 18             	pushl  0x18(%ebp)
  800467:	52                   	push   %edx
  800468:	50                   	push   %eax
  800469:	ff 75 0c             	pushl  0xc(%ebp)
  80046c:	ff 75 08             	pushl  0x8(%ebp)
  80046f:	e8 a1 ff ff ff       	call   800415 <printnum>
  800474:	83 c4 20             	add    $0x20,%esp
  800477:	eb 1a                	jmp    800493 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800479:	83 ec 08             	sub    $0x8,%esp
  80047c:	ff 75 0c             	pushl  0xc(%ebp)
  80047f:	ff 75 20             	pushl  0x20(%ebp)
  800482:	8b 45 08             	mov    0x8(%ebp),%eax
  800485:	ff d0                	call   *%eax
  800487:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80048a:	ff 4d 1c             	decl   0x1c(%ebp)
  80048d:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800491:	7f e6                	jg     800479 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800493:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800496:	bb 00 00 00 00       	mov    $0x0,%ebx
  80049b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80049e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8004a1:	53                   	push   %ebx
  8004a2:	51                   	push   %ecx
  8004a3:	52                   	push   %edx
  8004a4:	50                   	push   %eax
  8004a5:	e8 56 16 00 00       	call   801b00 <__umoddi3>
  8004aa:	83 c4 10             	add    $0x10,%esp
  8004ad:	05 f4 1f 80 00       	add    $0x801ff4,%eax
  8004b2:	8a 00                	mov    (%eax),%al
  8004b4:	0f be c0             	movsbl %al,%eax
  8004b7:	83 ec 08             	sub    $0x8,%esp
  8004ba:	ff 75 0c             	pushl  0xc(%ebp)
  8004bd:	50                   	push   %eax
  8004be:	8b 45 08             	mov    0x8(%ebp),%eax
  8004c1:	ff d0                	call   *%eax
  8004c3:	83 c4 10             	add    $0x10,%esp
}
  8004c6:	90                   	nop
  8004c7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8004ca:	c9                   	leave  
  8004cb:	c3                   	ret    

008004cc <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8004cc:	55                   	push   %ebp
  8004cd:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8004cf:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8004d3:	7e 1c                	jle    8004f1 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  8004d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8004d8:	8b 00                	mov    (%eax),%eax
  8004da:	8d 50 08             	lea    0x8(%eax),%edx
  8004dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8004e0:	89 10                	mov    %edx,(%eax)
  8004e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8004e5:	8b 00                	mov    (%eax),%eax
  8004e7:	83 e8 08             	sub    $0x8,%eax
  8004ea:	8b 50 04             	mov    0x4(%eax),%edx
  8004ed:	8b 00                	mov    (%eax),%eax
  8004ef:	eb 40                	jmp    800531 <getuint+0x65>
	else if (lflag)
  8004f1:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8004f5:	74 1e                	je     800515 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  8004f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8004fa:	8b 00                	mov    (%eax),%eax
  8004fc:	8d 50 04             	lea    0x4(%eax),%edx
  8004ff:	8b 45 08             	mov    0x8(%ebp),%eax
  800502:	89 10                	mov    %edx,(%eax)
  800504:	8b 45 08             	mov    0x8(%ebp),%eax
  800507:	8b 00                	mov    (%eax),%eax
  800509:	83 e8 04             	sub    $0x4,%eax
  80050c:	8b 00                	mov    (%eax),%eax
  80050e:	ba 00 00 00 00       	mov    $0x0,%edx
  800513:	eb 1c                	jmp    800531 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800515:	8b 45 08             	mov    0x8(%ebp),%eax
  800518:	8b 00                	mov    (%eax),%eax
  80051a:	8d 50 04             	lea    0x4(%eax),%edx
  80051d:	8b 45 08             	mov    0x8(%ebp),%eax
  800520:	89 10                	mov    %edx,(%eax)
  800522:	8b 45 08             	mov    0x8(%ebp),%eax
  800525:	8b 00                	mov    (%eax),%eax
  800527:	83 e8 04             	sub    $0x4,%eax
  80052a:	8b 00                	mov    (%eax),%eax
  80052c:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800531:	5d                   	pop    %ebp
  800532:	c3                   	ret    

00800533 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800533:	55                   	push   %ebp
  800534:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800536:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  80053a:	7e 1c                	jle    800558 <getint+0x25>
		return va_arg(*ap, long long);
  80053c:	8b 45 08             	mov    0x8(%ebp),%eax
  80053f:	8b 00                	mov    (%eax),%eax
  800541:	8d 50 08             	lea    0x8(%eax),%edx
  800544:	8b 45 08             	mov    0x8(%ebp),%eax
  800547:	89 10                	mov    %edx,(%eax)
  800549:	8b 45 08             	mov    0x8(%ebp),%eax
  80054c:	8b 00                	mov    (%eax),%eax
  80054e:	83 e8 08             	sub    $0x8,%eax
  800551:	8b 50 04             	mov    0x4(%eax),%edx
  800554:	8b 00                	mov    (%eax),%eax
  800556:	eb 38                	jmp    800590 <getint+0x5d>
	else if (lflag)
  800558:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80055c:	74 1a                	je     800578 <getint+0x45>
		return va_arg(*ap, long);
  80055e:	8b 45 08             	mov    0x8(%ebp),%eax
  800561:	8b 00                	mov    (%eax),%eax
  800563:	8d 50 04             	lea    0x4(%eax),%edx
  800566:	8b 45 08             	mov    0x8(%ebp),%eax
  800569:	89 10                	mov    %edx,(%eax)
  80056b:	8b 45 08             	mov    0x8(%ebp),%eax
  80056e:	8b 00                	mov    (%eax),%eax
  800570:	83 e8 04             	sub    $0x4,%eax
  800573:	8b 00                	mov    (%eax),%eax
  800575:	99                   	cltd   
  800576:	eb 18                	jmp    800590 <getint+0x5d>
	else
		return va_arg(*ap, int);
  800578:	8b 45 08             	mov    0x8(%ebp),%eax
  80057b:	8b 00                	mov    (%eax),%eax
  80057d:	8d 50 04             	lea    0x4(%eax),%edx
  800580:	8b 45 08             	mov    0x8(%ebp),%eax
  800583:	89 10                	mov    %edx,(%eax)
  800585:	8b 45 08             	mov    0x8(%ebp),%eax
  800588:	8b 00                	mov    (%eax),%eax
  80058a:	83 e8 04             	sub    $0x4,%eax
  80058d:	8b 00                	mov    (%eax),%eax
  80058f:	99                   	cltd   
}
  800590:	5d                   	pop    %ebp
  800591:	c3                   	ret    

00800592 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800592:	55                   	push   %ebp
  800593:	89 e5                	mov    %esp,%ebp
  800595:	56                   	push   %esi
  800596:	53                   	push   %ebx
  800597:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80059a:	eb 17                	jmp    8005b3 <vprintfmt+0x21>
			if (ch == '\0')
  80059c:	85 db                	test   %ebx,%ebx
  80059e:	0f 84 c1 03 00 00    	je     800965 <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  8005a4:	83 ec 08             	sub    $0x8,%esp
  8005a7:	ff 75 0c             	pushl  0xc(%ebp)
  8005aa:	53                   	push   %ebx
  8005ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8005ae:	ff d0                	call   *%eax
  8005b0:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8005b3:	8b 45 10             	mov    0x10(%ebp),%eax
  8005b6:	8d 50 01             	lea    0x1(%eax),%edx
  8005b9:	89 55 10             	mov    %edx,0x10(%ebp)
  8005bc:	8a 00                	mov    (%eax),%al
  8005be:	0f b6 d8             	movzbl %al,%ebx
  8005c1:	83 fb 25             	cmp    $0x25,%ebx
  8005c4:	75 d6                	jne    80059c <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  8005c6:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  8005ca:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  8005d1:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8005d8:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  8005df:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8005e6:	8b 45 10             	mov    0x10(%ebp),%eax
  8005e9:	8d 50 01             	lea    0x1(%eax),%edx
  8005ec:	89 55 10             	mov    %edx,0x10(%ebp)
  8005ef:	8a 00                	mov    (%eax),%al
  8005f1:	0f b6 d8             	movzbl %al,%ebx
  8005f4:	8d 43 dd             	lea    -0x23(%ebx),%eax
  8005f7:	83 f8 5b             	cmp    $0x5b,%eax
  8005fa:	0f 87 3d 03 00 00    	ja     80093d <vprintfmt+0x3ab>
  800600:	8b 04 85 18 20 80 00 	mov    0x802018(,%eax,4),%eax
  800607:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800609:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  80060d:	eb d7                	jmp    8005e6 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  80060f:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800613:	eb d1                	jmp    8005e6 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800615:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  80061c:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80061f:	89 d0                	mov    %edx,%eax
  800621:	c1 e0 02             	shl    $0x2,%eax
  800624:	01 d0                	add    %edx,%eax
  800626:	01 c0                	add    %eax,%eax
  800628:	01 d8                	add    %ebx,%eax
  80062a:	83 e8 30             	sub    $0x30,%eax
  80062d:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800630:	8b 45 10             	mov    0x10(%ebp),%eax
  800633:	8a 00                	mov    (%eax),%al
  800635:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800638:	83 fb 2f             	cmp    $0x2f,%ebx
  80063b:	7e 3e                	jle    80067b <vprintfmt+0xe9>
  80063d:	83 fb 39             	cmp    $0x39,%ebx
  800640:	7f 39                	jg     80067b <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800642:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800645:	eb d5                	jmp    80061c <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800647:	8b 45 14             	mov    0x14(%ebp),%eax
  80064a:	83 c0 04             	add    $0x4,%eax
  80064d:	89 45 14             	mov    %eax,0x14(%ebp)
  800650:	8b 45 14             	mov    0x14(%ebp),%eax
  800653:	83 e8 04             	sub    $0x4,%eax
  800656:	8b 00                	mov    (%eax),%eax
  800658:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  80065b:	eb 1f                	jmp    80067c <vprintfmt+0xea>

		case '.':
			if (width < 0)
  80065d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800661:	79 83                	jns    8005e6 <vprintfmt+0x54>
				width = 0;
  800663:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  80066a:	e9 77 ff ff ff       	jmp    8005e6 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  80066f:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800676:	e9 6b ff ff ff       	jmp    8005e6 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  80067b:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  80067c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800680:	0f 89 60 ff ff ff    	jns    8005e6 <vprintfmt+0x54>
				width = precision, precision = -1;
  800686:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800689:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80068c:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800693:	e9 4e ff ff ff       	jmp    8005e6 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800698:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  80069b:	e9 46 ff ff ff       	jmp    8005e6 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  8006a0:	8b 45 14             	mov    0x14(%ebp),%eax
  8006a3:	83 c0 04             	add    $0x4,%eax
  8006a6:	89 45 14             	mov    %eax,0x14(%ebp)
  8006a9:	8b 45 14             	mov    0x14(%ebp),%eax
  8006ac:	83 e8 04             	sub    $0x4,%eax
  8006af:	8b 00                	mov    (%eax),%eax
  8006b1:	83 ec 08             	sub    $0x8,%esp
  8006b4:	ff 75 0c             	pushl  0xc(%ebp)
  8006b7:	50                   	push   %eax
  8006b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8006bb:	ff d0                	call   *%eax
  8006bd:	83 c4 10             	add    $0x10,%esp
			break;
  8006c0:	e9 9b 02 00 00       	jmp    800960 <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  8006c5:	8b 45 14             	mov    0x14(%ebp),%eax
  8006c8:	83 c0 04             	add    $0x4,%eax
  8006cb:	89 45 14             	mov    %eax,0x14(%ebp)
  8006ce:	8b 45 14             	mov    0x14(%ebp),%eax
  8006d1:	83 e8 04             	sub    $0x4,%eax
  8006d4:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  8006d6:	85 db                	test   %ebx,%ebx
  8006d8:	79 02                	jns    8006dc <vprintfmt+0x14a>
				err = -err;
  8006da:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  8006dc:	83 fb 64             	cmp    $0x64,%ebx
  8006df:	7f 0b                	jg     8006ec <vprintfmt+0x15a>
  8006e1:	8b 34 9d 60 1e 80 00 	mov    0x801e60(,%ebx,4),%esi
  8006e8:	85 f6                	test   %esi,%esi
  8006ea:	75 19                	jne    800705 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  8006ec:	53                   	push   %ebx
  8006ed:	68 05 20 80 00       	push   $0x802005
  8006f2:	ff 75 0c             	pushl  0xc(%ebp)
  8006f5:	ff 75 08             	pushl  0x8(%ebp)
  8006f8:	e8 70 02 00 00       	call   80096d <printfmt>
  8006fd:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800700:	e9 5b 02 00 00       	jmp    800960 <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800705:	56                   	push   %esi
  800706:	68 0e 20 80 00       	push   $0x80200e
  80070b:	ff 75 0c             	pushl  0xc(%ebp)
  80070e:	ff 75 08             	pushl  0x8(%ebp)
  800711:	e8 57 02 00 00       	call   80096d <printfmt>
  800716:	83 c4 10             	add    $0x10,%esp
			break;
  800719:	e9 42 02 00 00       	jmp    800960 <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  80071e:	8b 45 14             	mov    0x14(%ebp),%eax
  800721:	83 c0 04             	add    $0x4,%eax
  800724:	89 45 14             	mov    %eax,0x14(%ebp)
  800727:	8b 45 14             	mov    0x14(%ebp),%eax
  80072a:	83 e8 04             	sub    $0x4,%eax
  80072d:	8b 30                	mov    (%eax),%esi
  80072f:	85 f6                	test   %esi,%esi
  800731:	75 05                	jne    800738 <vprintfmt+0x1a6>
				p = "(null)";
  800733:	be 11 20 80 00       	mov    $0x802011,%esi
			if (width > 0 && padc != '-')
  800738:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80073c:	7e 6d                	jle    8007ab <vprintfmt+0x219>
  80073e:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800742:	74 67                	je     8007ab <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800744:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800747:	83 ec 08             	sub    $0x8,%esp
  80074a:	50                   	push   %eax
  80074b:	56                   	push   %esi
  80074c:	e8 1e 03 00 00       	call   800a6f <strnlen>
  800751:	83 c4 10             	add    $0x10,%esp
  800754:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800757:	eb 16                	jmp    80076f <vprintfmt+0x1dd>
					putch(padc, putdat);
  800759:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  80075d:	83 ec 08             	sub    $0x8,%esp
  800760:	ff 75 0c             	pushl  0xc(%ebp)
  800763:	50                   	push   %eax
  800764:	8b 45 08             	mov    0x8(%ebp),%eax
  800767:	ff d0                	call   *%eax
  800769:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  80076c:	ff 4d e4             	decl   -0x1c(%ebp)
  80076f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800773:	7f e4                	jg     800759 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800775:	eb 34                	jmp    8007ab <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800777:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  80077b:	74 1c                	je     800799 <vprintfmt+0x207>
  80077d:	83 fb 1f             	cmp    $0x1f,%ebx
  800780:	7e 05                	jle    800787 <vprintfmt+0x1f5>
  800782:	83 fb 7e             	cmp    $0x7e,%ebx
  800785:	7e 12                	jle    800799 <vprintfmt+0x207>
					putch('?', putdat);
  800787:	83 ec 08             	sub    $0x8,%esp
  80078a:	ff 75 0c             	pushl  0xc(%ebp)
  80078d:	6a 3f                	push   $0x3f
  80078f:	8b 45 08             	mov    0x8(%ebp),%eax
  800792:	ff d0                	call   *%eax
  800794:	83 c4 10             	add    $0x10,%esp
  800797:	eb 0f                	jmp    8007a8 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800799:	83 ec 08             	sub    $0x8,%esp
  80079c:	ff 75 0c             	pushl  0xc(%ebp)
  80079f:	53                   	push   %ebx
  8007a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8007a3:	ff d0                	call   *%eax
  8007a5:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8007a8:	ff 4d e4             	decl   -0x1c(%ebp)
  8007ab:	89 f0                	mov    %esi,%eax
  8007ad:	8d 70 01             	lea    0x1(%eax),%esi
  8007b0:	8a 00                	mov    (%eax),%al
  8007b2:	0f be d8             	movsbl %al,%ebx
  8007b5:	85 db                	test   %ebx,%ebx
  8007b7:	74 24                	je     8007dd <vprintfmt+0x24b>
  8007b9:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8007bd:	78 b8                	js     800777 <vprintfmt+0x1e5>
  8007bf:	ff 4d e0             	decl   -0x20(%ebp)
  8007c2:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8007c6:	79 af                	jns    800777 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8007c8:	eb 13                	jmp    8007dd <vprintfmt+0x24b>
				putch(' ', putdat);
  8007ca:	83 ec 08             	sub    $0x8,%esp
  8007cd:	ff 75 0c             	pushl  0xc(%ebp)
  8007d0:	6a 20                	push   $0x20
  8007d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8007d5:	ff d0                	call   *%eax
  8007d7:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8007da:	ff 4d e4             	decl   -0x1c(%ebp)
  8007dd:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8007e1:	7f e7                	jg     8007ca <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  8007e3:	e9 78 01 00 00       	jmp    800960 <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  8007e8:	83 ec 08             	sub    $0x8,%esp
  8007eb:	ff 75 e8             	pushl  -0x18(%ebp)
  8007ee:	8d 45 14             	lea    0x14(%ebp),%eax
  8007f1:	50                   	push   %eax
  8007f2:	e8 3c fd ff ff       	call   800533 <getint>
  8007f7:	83 c4 10             	add    $0x10,%esp
  8007fa:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8007fd:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800800:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800803:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800806:	85 d2                	test   %edx,%edx
  800808:	79 23                	jns    80082d <vprintfmt+0x29b>
				putch('-', putdat);
  80080a:	83 ec 08             	sub    $0x8,%esp
  80080d:	ff 75 0c             	pushl  0xc(%ebp)
  800810:	6a 2d                	push   $0x2d
  800812:	8b 45 08             	mov    0x8(%ebp),%eax
  800815:	ff d0                	call   *%eax
  800817:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  80081a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80081d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800820:	f7 d8                	neg    %eax
  800822:	83 d2 00             	adc    $0x0,%edx
  800825:	f7 da                	neg    %edx
  800827:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80082a:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  80082d:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800834:	e9 bc 00 00 00       	jmp    8008f5 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800839:	83 ec 08             	sub    $0x8,%esp
  80083c:	ff 75 e8             	pushl  -0x18(%ebp)
  80083f:	8d 45 14             	lea    0x14(%ebp),%eax
  800842:	50                   	push   %eax
  800843:	e8 84 fc ff ff       	call   8004cc <getuint>
  800848:	83 c4 10             	add    $0x10,%esp
  80084b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80084e:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800851:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800858:	e9 98 00 00 00       	jmp    8008f5 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  80085d:	83 ec 08             	sub    $0x8,%esp
  800860:	ff 75 0c             	pushl  0xc(%ebp)
  800863:	6a 58                	push   $0x58
  800865:	8b 45 08             	mov    0x8(%ebp),%eax
  800868:	ff d0                	call   *%eax
  80086a:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  80086d:	83 ec 08             	sub    $0x8,%esp
  800870:	ff 75 0c             	pushl  0xc(%ebp)
  800873:	6a 58                	push   $0x58
  800875:	8b 45 08             	mov    0x8(%ebp),%eax
  800878:	ff d0                	call   *%eax
  80087a:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  80087d:	83 ec 08             	sub    $0x8,%esp
  800880:	ff 75 0c             	pushl  0xc(%ebp)
  800883:	6a 58                	push   $0x58
  800885:	8b 45 08             	mov    0x8(%ebp),%eax
  800888:	ff d0                	call   *%eax
  80088a:	83 c4 10             	add    $0x10,%esp
			break;
  80088d:	e9 ce 00 00 00       	jmp    800960 <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  800892:	83 ec 08             	sub    $0x8,%esp
  800895:	ff 75 0c             	pushl  0xc(%ebp)
  800898:	6a 30                	push   $0x30
  80089a:	8b 45 08             	mov    0x8(%ebp),%eax
  80089d:	ff d0                	call   *%eax
  80089f:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  8008a2:	83 ec 08             	sub    $0x8,%esp
  8008a5:	ff 75 0c             	pushl  0xc(%ebp)
  8008a8:	6a 78                	push   $0x78
  8008aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8008ad:	ff d0                	call   *%eax
  8008af:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  8008b2:	8b 45 14             	mov    0x14(%ebp),%eax
  8008b5:	83 c0 04             	add    $0x4,%eax
  8008b8:	89 45 14             	mov    %eax,0x14(%ebp)
  8008bb:	8b 45 14             	mov    0x14(%ebp),%eax
  8008be:	83 e8 04             	sub    $0x4,%eax
  8008c1:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  8008c3:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8008c6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  8008cd:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  8008d4:	eb 1f                	jmp    8008f5 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  8008d6:	83 ec 08             	sub    $0x8,%esp
  8008d9:	ff 75 e8             	pushl  -0x18(%ebp)
  8008dc:	8d 45 14             	lea    0x14(%ebp),%eax
  8008df:	50                   	push   %eax
  8008e0:	e8 e7 fb ff ff       	call   8004cc <getuint>
  8008e5:	83 c4 10             	add    $0x10,%esp
  8008e8:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8008eb:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  8008ee:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  8008f5:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  8008f9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8008fc:	83 ec 04             	sub    $0x4,%esp
  8008ff:	52                   	push   %edx
  800900:	ff 75 e4             	pushl  -0x1c(%ebp)
  800903:	50                   	push   %eax
  800904:	ff 75 f4             	pushl  -0xc(%ebp)
  800907:	ff 75 f0             	pushl  -0x10(%ebp)
  80090a:	ff 75 0c             	pushl  0xc(%ebp)
  80090d:	ff 75 08             	pushl  0x8(%ebp)
  800910:	e8 00 fb ff ff       	call   800415 <printnum>
  800915:	83 c4 20             	add    $0x20,%esp
			break;
  800918:	eb 46                	jmp    800960 <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  80091a:	83 ec 08             	sub    $0x8,%esp
  80091d:	ff 75 0c             	pushl  0xc(%ebp)
  800920:	53                   	push   %ebx
  800921:	8b 45 08             	mov    0x8(%ebp),%eax
  800924:	ff d0                	call   *%eax
  800926:	83 c4 10             	add    $0x10,%esp
			break;
  800929:	eb 35                	jmp    800960 <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  80092b:	c6 05 44 30 80 00 00 	movb   $0x0,0x803044
			break;
  800932:	eb 2c                	jmp    800960 <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  800934:	c6 05 44 30 80 00 01 	movb   $0x1,0x803044
			break;
  80093b:	eb 23                	jmp    800960 <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  80093d:	83 ec 08             	sub    $0x8,%esp
  800940:	ff 75 0c             	pushl  0xc(%ebp)
  800943:	6a 25                	push   $0x25
  800945:	8b 45 08             	mov    0x8(%ebp),%eax
  800948:	ff d0                	call   *%eax
  80094a:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  80094d:	ff 4d 10             	decl   0x10(%ebp)
  800950:	eb 03                	jmp    800955 <vprintfmt+0x3c3>
  800952:	ff 4d 10             	decl   0x10(%ebp)
  800955:	8b 45 10             	mov    0x10(%ebp),%eax
  800958:	48                   	dec    %eax
  800959:	8a 00                	mov    (%eax),%al
  80095b:	3c 25                	cmp    $0x25,%al
  80095d:	75 f3                	jne    800952 <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  80095f:	90                   	nop
		}
	}
  800960:	e9 35 fc ff ff       	jmp    80059a <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800965:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800966:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800969:	5b                   	pop    %ebx
  80096a:	5e                   	pop    %esi
  80096b:	5d                   	pop    %ebp
  80096c:	c3                   	ret    

0080096d <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  80096d:	55                   	push   %ebp
  80096e:	89 e5                	mov    %esp,%ebp
  800970:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800973:	8d 45 10             	lea    0x10(%ebp),%eax
  800976:	83 c0 04             	add    $0x4,%eax
  800979:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  80097c:	8b 45 10             	mov    0x10(%ebp),%eax
  80097f:	ff 75 f4             	pushl  -0xc(%ebp)
  800982:	50                   	push   %eax
  800983:	ff 75 0c             	pushl  0xc(%ebp)
  800986:	ff 75 08             	pushl  0x8(%ebp)
  800989:	e8 04 fc ff ff       	call   800592 <vprintfmt>
  80098e:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800991:	90                   	nop
  800992:	c9                   	leave  
  800993:	c3                   	ret    

00800994 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800994:	55                   	push   %ebp
  800995:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800997:	8b 45 0c             	mov    0xc(%ebp),%eax
  80099a:	8b 40 08             	mov    0x8(%eax),%eax
  80099d:	8d 50 01             	lea    0x1(%eax),%edx
  8009a0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009a3:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  8009a6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009a9:	8b 10                	mov    (%eax),%edx
  8009ab:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009ae:	8b 40 04             	mov    0x4(%eax),%eax
  8009b1:	39 c2                	cmp    %eax,%edx
  8009b3:	73 12                	jae    8009c7 <sprintputch+0x33>
		*b->buf++ = ch;
  8009b5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009b8:	8b 00                	mov    (%eax),%eax
  8009ba:	8d 48 01             	lea    0x1(%eax),%ecx
  8009bd:	8b 55 0c             	mov    0xc(%ebp),%edx
  8009c0:	89 0a                	mov    %ecx,(%edx)
  8009c2:	8b 55 08             	mov    0x8(%ebp),%edx
  8009c5:	88 10                	mov    %dl,(%eax)
}
  8009c7:	90                   	nop
  8009c8:	5d                   	pop    %ebp
  8009c9:	c3                   	ret    

008009ca <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8009ca:	55                   	push   %ebp
  8009cb:	89 e5                	mov    %esp,%ebp
  8009cd:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  8009d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8009d3:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8009d6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009d9:	8d 50 ff             	lea    -0x1(%eax),%edx
  8009dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8009df:	01 d0                	add    %edx,%eax
  8009e1:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8009e4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  8009eb:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8009ef:	74 06                	je     8009f7 <vsnprintf+0x2d>
  8009f1:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8009f5:	7f 07                	jg     8009fe <vsnprintf+0x34>
		return -E_INVAL;
  8009f7:	b8 03 00 00 00       	mov    $0x3,%eax
  8009fc:	eb 20                	jmp    800a1e <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8009fe:	ff 75 14             	pushl  0x14(%ebp)
  800a01:	ff 75 10             	pushl  0x10(%ebp)
  800a04:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800a07:	50                   	push   %eax
  800a08:	68 94 09 80 00       	push   $0x800994
  800a0d:	e8 80 fb ff ff       	call   800592 <vprintfmt>
  800a12:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800a15:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800a18:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800a1b:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800a1e:	c9                   	leave  
  800a1f:	c3                   	ret    

00800a20 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800a20:	55                   	push   %ebp
  800a21:	89 e5                	mov    %esp,%ebp
  800a23:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800a26:	8d 45 10             	lea    0x10(%ebp),%eax
  800a29:	83 c0 04             	add    $0x4,%eax
  800a2c:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800a2f:	8b 45 10             	mov    0x10(%ebp),%eax
  800a32:	ff 75 f4             	pushl  -0xc(%ebp)
  800a35:	50                   	push   %eax
  800a36:	ff 75 0c             	pushl  0xc(%ebp)
  800a39:	ff 75 08             	pushl  0x8(%ebp)
  800a3c:	e8 89 ff ff ff       	call   8009ca <vsnprintf>
  800a41:	83 c4 10             	add    $0x10,%esp
  800a44:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800a47:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800a4a:	c9                   	leave  
  800a4b:	c3                   	ret    

00800a4c <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800a4c:	55                   	push   %ebp
  800a4d:	89 e5                	mov    %esp,%ebp
  800a4f:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800a52:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800a59:	eb 06                	jmp    800a61 <strlen+0x15>
		n++;
  800a5b:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800a5e:	ff 45 08             	incl   0x8(%ebp)
  800a61:	8b 45 08             	mov    0x8(%ebp),%eax
  800a64:	8a 00                	mov    (%eax),%al
  800a66:	84 c0                	test   %al,%al
  800a68:	75 f1                	jne    800a5b <strlen+0xf>
		n++;
	return n;
  800a6a:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800a6d:	c9                   	leave  
  800a6e:	c3                   	ret    

00800a6f <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800a6f:	55                   	push   %ebp
  800a70:	89 e5                	mov    %esp,%ebp
  800a72:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800a75:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800a7c:	eb 09                	jmp    800a87 <strnlen+0x18>
		n++;
  800a7e:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800a81:	ff 45 08             	incl   0x8(%ebp)
  800a84:	ff 4d 0c             	decl   0xc(%ebp)
  800a87:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800a8b:	74 09                	je     800a96 <strnlen+0x27>
  800a8d:	8b 45 08             	mov    0x8(%ebp),%eax
  800a90:	8a 00                	mov    (%eax),%al
  800a92:	84 c0                	test   %al,%al
  800a94:	75 e8                	jne    800a7e <strnlen+0xf>
		n++;
	return n;
  800a96:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800a99:	c9                   	leave  
  800a9a:	c3                   	ret    

00800a9b <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800a9b:	55                   	push   %ebp
  800a9c:	89 e5                	mov    %esp,%ebp
  800a9e:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800aa1:	8b 45 08             	mov    0x8(%ebp),%eax
  800aa4:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800aa7:	90                   	nop
  800aa8:	8b 45 08             	mov    0x8(%ebp),%eax
  800aab:	8d 50 01             	lea    0x1(%eax),%edx
  800aae:	89 55 08             	mov    %edx,0x8(%ebp)
  800ab1:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ab4:	8d 4a 01             	lea    0x1(%edx),%ecx
  800ab7:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800aba:	8a 12                	mov    (%edx),%dl
  800abc:	88 10                	mov    %dl,(%eax)
  800abe:	8a 00                	mov    (%eax),%al
  800ac0:	84 c0                	test   %al,%al
  800ac2:	75 e4                	jne    800aa8 <strcpy+0xd>
		/* do nothing */;
	return ret;
  800ac4:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800ac7:	c9                   	leave  
  800ac8:	c3                   	ret    

00800ac9 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800ac9:	55                   	push   %ebp
  800aca:	89 e5                	mov    %esp,%ebp
  800acc:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800acf:	8b 45 08             	mov    0x8(%ebp),%eax
  800ad2:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800ad5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800adc:	eb 1f                	jmp    800afd <strncpy+0x34>
		*dst++ = *src;
  800ade:	8b 45 08             	mov    0x8(%ebp),%eax
  800ae1:	8d 50 01             	lea    0x1(%eax),%edx
  800ae4:	89 55 08             	mov    %edx,0x8(%ebp)
  800ae7:	8b 55 0c             	mov    0xc(%ebp),%edx
  800aea:	8a 12                	mov    (%edx),%dl
  800aec:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800aee:	8b 45 0c             	mov    0xc(%ebp),%eax
  800af1:	8a 00                	mov    (%eax),%al
  800af3:	84 c0                	test   %al,%al
  800af5:	74 03                	je     800afa <strncpy+0x31>
			src++;
  800af7:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800afa:	ff 45 fc             	incl   -0x4(%ebp)
  800afd:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800b00:	3b 45 10             	cmp    0x10(%ebp),%eax
  800b03:	72 d9                	jb     800ade <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800b05:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800b08:	c9                   	leave  
  800b09:	c3                   	ret    

00800b0a <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800b0a:	55                   	push   %ebp
  800b0b:	89 e5                	mov    %esp,%ebp
  800b0d:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800b10:	8b 45 08             	mov    0x8(%ebp),%eax
  800b13:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800b16:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800b1a:	74 30                	je     800b4c <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800b1c:	eb 16                	jmp    800b34 <strlcpy+0x2a>
			*dst++ = *src++;
  800b1e:	8b 45 08             	mov    0x8(%ebp),%eax
  800b21:	8d 50 01             	lea    0x1(%eax),%edx
  800b24:	89 55 08             	mov    %edx,0x8(%ebp)
  800b27:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b2a:	8d 4a 01             	lea    0x1(%edx),%ecx
  800b2d:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800b30:	8a 12                	mov    (%edx),%dl
  800b32:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800b34:	ff 4d 10             	decl   0x10(%ebp)
  800b37:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800b3b:	74 09                	je     800b46 <strlcpy+0x3c>
  800b3d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b40:	8a 00                	mov    (%eax),%al
  800b42:	84 c0                	test   %al,%al
  800b44:	75 d8                	jne    800b1e <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800b46:	8b 45 08             	mov    0x8(%ebp),%eax
  800b49:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800b4c:	8b 55 08             	mov    0x8(%ebp),%edx
  800b4f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800b52:	29 c2                	sub    %eax,%edx
  800b54:	89 d0                	mov    %edx,%eax
}
  800b56:	c9                   	leave  
  800b57:	c3                   	ret    

00800b58 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800b58:	55                   	push   %ebp
  800b59:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800b5b:	eb 06                	jmp    800b63 <strcmp+0xb>
		p++, q++;
  800b5d:	ff 45 08             	incl   0x8(%ebp)
  800b60:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800b63:	8b 45 08             	mov    0x8(%ebp),%eax
  800b66:	8a 00                	mov    (%eax),%al
  800b68:	84 c0                	test   %al,%al
  800b6a:	74 0e                	je     800b7a <strcmp+0x22>
  800b6c:	8b 45 08             	mov    0x8(%ebp),%eax
  800b6f:	8a 10                	mov    (%eax),%dl
  800b71:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b74:	8a 00                	mov    (%eax),%al
  800b76:	38 c2                	cmp    %al,%dl
  800b78:	74 e3                	je     800b5d <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800b7a:	8b 45 08             	mov    0x8(%ebp),%eax
  800b7d:	8a 00                	mov    (%eax),%al
  800b7f:	0f b6 d0             	movzbl %al,%edx
  800b82:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b85:	8a 00                	mov    (%eax),%al
  800b87:	0f b6 c0             	movzbl %al,%eax
  800b8a:	29 c2                	sub    %eax,%edx
  800b8c:	89 d0                	mov    %edx,%eax
}
  800b8e:	5d                   	pop    %ebp
  800b8f:	c3                   	ret    

00800b90 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800b90:	55                   	push   %ebp
  800b91:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800b93:	eb 09                	jmp    800b9e <strncmp+0xe>
		n--, p++, q++;
  800b95:	ff 4d 10             	decl   0x10(%ebp)
  800b98:	ff 45 08             	incl   0x8(%ebp)
  800b9b:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800b9e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ba2:	74 17                	je     800bbb <strncmp+0x2b>
  800ba4:	8b 45 08             	mov    0x8(%ebp),%eax
  800ba7:	8a 00                	mov    (%eax),%al
  800ba9:	84 c0                	test   %al,%al
  800bab:	74 0e                	je     800bbb <strncmp+0x2b>
  800bad:	8b 45 08             	mov    0x8(%ebp),%eax
  800bb0:	8a 10                	mov    (%eax),%dl
  800bb2:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bb5:	8a 00                	mov    (%eax),%al
  800bb7:	38 c2                	cmp    %al,%dl
  800bb9:	74 da                	je     800b95 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800bbb:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800bbf:	75 07                	jne    800bc8 <strncmp+0x38>
		return 0;
  800bc1:	b8 00 00 00 00       	mov    $0x0,%eax
  800bc6:	eb 14                	jmp    800bdc <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800bc8:	8b 45 08             	mov    0x8(%ebp),%eax
  800bcb:	8a 00                	mov    (%eax),%al
  800bcd:	0f b6 d0             	movzbl %al,%edx
  800bd0:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bd3:	8a 00                	mov    (%eax),%al
  800bd5:	0f b6 c0             	movzbl %al,%eax
  800bd8:	29 c2                	sub    %eax,%edx
  800bda:	89 d0                	mov    %edx,%eax
}
  800bdc:	5d                   	pop    %ebp
  800bdd:	c3                   	ret    

00800bde <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800bde:	55                   	push   %ebp
  800bdf:	89 e5                	mov    %esp,%ebp
  800be1:	83 ec 04             	sub    $0x4,%esp
  800be4:	8b 45 0c             	mov    0xc(%ebp),%eax
  800be7:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800bea:	eb 12                	jmp    800bfe <strchr+0x20>
		if (*s == c)
  800bec:	8b 45 08             	mov    0x8(%ebp),%eax
  800bef:	8a 00                	mov    (%eax),%al
  800bf1:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800bf4:	75 05                	jne    800bfb <strchr+0x1d>
			return (char *) s;
  800bf6:	8b 45 08             	mov    0x8(%ebp),%eax
  800bf9:	eb 11                	jmp    800c0c <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800bfb:	ff 45 08             	incl   0x8(%ebp)
  800bfe:	8b 45 08             	mov    0x8(%ebp),%eax
  800c01:	8a 00                	mov    (%eax),%al
  800c03:	84 c0                	test   %al,%al
  800c05:	75 e5                	jne    800bec <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800c07:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800c0c:	c9                   	leave  
  800c0d:	c3                   	ret    

00800c0e <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800c0e:	55                   	push   %ebp
  800c0f:	89 e5                	mov    %esp,%ebp
  800c11:	83 ec 04             	sub    $0x4,%esp
  800c14:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c17:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800c1a:	eb 0d                	jmp    800c29 <strfind+0x1b>
		if (*s == c)
  800c1c:	8b 45 08             	mov    0x8(%ebp),%eax
  800c1f:	8a 00                	mov    (%eax),%al
  800c21:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800c24:	74 0e                	je     800c34 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800c26:	ff 45 08             	incl   0x8(%ebp)
  800c29:	8b 45 08             	mov    0x8(%ebp),%eax
  800c2c:	8a 00                	mov    (%eax),%al
  800c2e:	84 c0                	test   %al,%al
  800c30:	75 ea                	jne    800c1c <strfind+0xe>
  800c32:	eb 01                	jmp    800c35 <strfind+0x27>
		if (*s == c)
			break;
  800c34:	90                   	nop
	return (char *) s;
  800c35:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800c38:	c9                   	leave  
  800c39:	c3                   	ret    

00800c3a <memset>:

// *************** The faster implementation of memset & memcpy is implemented by *************
// ****************** Team80 (Yahia Khaled, Malek Ahmed et al) - FCIS'24-25 *******************
void *
memset(void *v, int c, uint32 n)
{
  800c3a:	55                   	push   %ebp
  800c3b:	89 e5                	mov    %esp,%ebp
  800c3d:	83 ec 10             	sub    $0x10,%esp
//	m = n;
//	while (--m >= 0)
//		*p++ = c;

	/*Faster Implementation*/
	uint64* p64 = (uint64*)v;
  800c40:	8b 45 08             	mov    0x8(%ebp),%eax
  800c43:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if(n >= 8){
  800c46:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800c4a:	76 63                	jbe    800caf <memset+0x75>
		uint64 data_block = c;
  800c4c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c4f:	99                   	cltd   
  800c50:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c53:	89 55 f4             	mov    %edx,-0xc(%ebp)
		data_block |= data_block << 8;
  800c56:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800c59:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800c5c:	0f a4 c2 08          	shld   $0x8,%eax,%edx
  800c60:	c1 e0 08             	shl    $0x8,%eax
  800c63:	09 45 f0             	or     %eax,-0x10(%ebp)
  800c66:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 16;
  800c69:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800c6c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800c6f:	0f a4 c2 10          	shld   $0x10,%eax,%edx
  800c73:	c1 e0 10             	shl    $0x10,%eax
  800c76:	09 45 f0             	or     %eax,-0x10(%ebp)
  800c79:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 32;
  800c7c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800c7f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800c82:	89 c2                	mov    %eax,%edx
  800c84:	b8 00 00 00 00       	mov    $0x0,%eax
  800c89:	09 45 f0             	or     %eax,-0x10(%ebp)
  800c8c:	09 55 f4             	or     %edx,-0xc(%ebp)

		while(n >= 8)
  800c8f:	eb 18                	jmp    800ca9 <memset+0x6f>
			*p64++ = data_block, n -= 8;
  800c91:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  800c94:	8d 41 08             	lea    0x8(%ecx),%eax
  800c97:	89 45 fc             	mov    %eax,-0x4(%ebp)
  800c9a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800c9d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800ca0:	89 01                	mov    %eax,(%ecx)
  800ca2:	89 51 04             	mov    %edx,0x4(%ecx)
  800ca5:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
		uint64 data_block = c;
		data_block |= data_block << 8;
		data_block |= data_block << 16;
		data_block |= data_block << 32;

		while(n >= 8)
  800ca9:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800cad:	77 e2                	ja     800c91 <memset+0x57>
			*p64++ = data_block, n -= 8;
	}

	if(n){
  800caf:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800cb3:	74 23                	je     800cd8 <memset+0x9e>
		uint8* p8 = (uint8*)p64;
  800cb5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800cb8:	89 45 f8             	mov    %eax,-0x8(%ebp)
		while (n-- > 0)
  800cbb:	eb 0e                	jmp    800ccb <memset+0x91>
			*p8++ = (uint8)c;
  800cbd:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800cc0:	8d 50 01             	lea    0x1(%eax),%edx
  800cc3:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800cc6:	8b 55 0c             	mov    0xc(%ebp),%edx
  800cc9:	88 10                	mov    %dl,(%eax)
			*p64++ = data_block, n -= 8;
	}

	if(n){
		uint8* p8 = (uint8*)p64;
		while (n-- > 0)
  800ccb:	8b 45 10             	mov    0x10(%ebp),%eax
  800cce:	8d 50 ff             	lea    -0x1(%eax),%edx
  800cd1:	89 55 10             	mov    %edx,0x10(%ebp)
  800cd4:	85 c0                	test   %eax,%eax
  800cd6:	75 e5                	jne    800cbd <memset+0x83>
			*p8++ = (uint8)c;
	}

	return v;
  800cd8:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800cdb:	c9                   	leave  
  800cdc:	c3                   	ret    

00800cdd <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800cdd:	55                   	push   %ebp
  800cde:	89 e5                	mov    %esp,%ebp
  800ce0:	83 ec 10             	sub    $0x10,%esp
	//	s = src;
	//	d = dst;
	//	while (n-- > 0)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
  800ce3:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ce6:	89 45 fc             	mov    %eax,-0x4(%ebp)
	uint64* d64 = (uint64*)dst;
  800ce9:	8b 45 08             	mov    0x8(%ebp),%eax
  800cec:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if(n >= 8){
  800cef:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800cf3:	76 24                	jbe    800d19 <memcpy+0x3c>
		while(n >= 8){
  800cf5:	eb 1c                	jmp    800d13 <memcpy+0x36>
			*d64 = *s64;
  800cf7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800cfa:	8b 50 04             	mov    0x4(%eax),%edx
  800cfd:	8b 00                	mov    (%eax),%eax
  800cff:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  800d02:	89 01                	mov    %eax,(%ecx)
  800d04:	89 51 04             	mov    %edx,0x4(%ecx)
			n -= 8;
  800d07:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
			++s64;
  800d0b:	83 45 fc 08          	addl   $0x8,-0x4(%ebp)
			++d64;
  800d0f:	83 45 f8 08          	addl   $0x8,-0x8(%ebp)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
	uint64* d64 = (uint64*)dst;
	if(n >= 8){
		while(n >= 8){
  800d13:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800d17:	77 de                	ja     800cf7 <memcpy+0x1a>
			++s64;
			++d64;
		}
	}

	if(n){
  800d19:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d1d:	74 31                	je     800d50 <memcpy+0x73>
		uint8* s8 = (uint8*)s64;
  800d1f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d22:	89 45 f4             	mov    %eax,-0xc(%ebp)
		uint8* d8 = (uint8*)d64;
  800d25:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800d28:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (n-- > 0)
  800d2b:	eb 16                	jmp    800d43 <memcpy+0x66>
			*d8++ = *s8++;
  800d2d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800d30:	8d 50 01             	lea    0x1(%eax),%edx
  800d33:	89 55 f0             	mov    %edx,-0x10(%ebp)
  800d36:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800d39:	8d 4a 01             	lea    0x1(%edx),%ecx
  800d3c:	89 4d f4             	mov    %ecx,-0xc(%ebp)
  800d3f:	8a 12                	mov    (%edx),%dl
  800d41:	88 10                	mov    %dl,(%eax)
	}

	if(n){
		uint8* s8 = (uint8*)s64;
		uint8* d8 = (uint8*)d64;
		while (n-- > 0)
  800d43:	8b 45 10             	mov    0x10(%ebp),%eax
  800d46:	8d 50 ff             	lea    -0x1(%eax),%edx
  800d49:	89 55 10             	mov    %edx,0x10(%ebp)
  800d4c:	85 c0                	test   %eax,%eax
  800d4e:	75 dd                	jne    800d2d <memcpy+0x50>
			*d8++ = *s8++;
	}
	return dst;
  800d50:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800d53:	c9                   	leave  
  800d54:	c3                   	ret    

00800d55 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800d55:	55                   	push   %ebp
  800d56:	89 e5                	mov    %esp,%ebp
  800d58:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800d5b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d5e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800d61:	8b 45 08             	mov    0x8(%ebp),%eax
  800d64:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800d67:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d6a:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800d6d:	73 50                	jae    800dbf <memmove+0x6a>
  800d6f:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800d72:	8b 45 10             	mov    0x10(%ebp),%eax
  800d75:	01 d0                	add    %edx,%eax
  800d77:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800d7a:	76 43                	jbe    800dbf <memmove+0x6a>
		s += n;
  800d7c:	8b 45 10             	mov    0x10(%ebp),%eax
  800d7f:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800d82:	8b 45 10             	mov    0x10(%ebp),%eax
  800d85:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800d88:	eb 10                	jmp    800d9a <memmove+0x45>
			*--d = *--s;
  800d8a:	ff 4d f8             	decl   -0x8(%ebp)
  800d8d:	ff 4d fc             	decl   -0x4(%ebp)
  800d90:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d93:	8a 10                	mov    (%eax),%dl
  800d95:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800d98:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800d9a:	8b 45 10             	mov    0x10(%ebp),%eax
  800d9d:	8d 50 ff             	lea    -0x1(%eax),%edx
  800da0:	89 55 10             	mov    %edx,0x10(%ebp)
  800da3:	85 c0                	test   %eax,%eax
  800da5:	75 e3                	jne    800d8a <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800da7:	eb 23                	jmp    800dcc <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800da9:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800dac:	8d 50 01             	lea    0x1(%eax),%edx
  800daf:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800db2:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800db5:	8d 4a 01             	lea    0x1(%edx),%ecx
  800db8:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800dbb:	8a 12                	mov    (%edx),%dl
  800dbd:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800dbf:	8b 45 10             	mov    0x10(%ebp),%eax
  800dc2:	8d 50 ff             	lea    -0x1(%eax),%edx
  800dc5:	89 55 10             	mov    %edx,0x10(%ebp)
  800dc8:	85 c0                	test   %eax,%eax
  800dca:	75 dd                	jne    800da9 <memmove+0x54>
			*d++ = *s++;

	return dst;
  800dcc:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800dcf:	c9                   	leave  
  800dd0:	c3                   	ret    

00800dd1 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  800dd1:	55                   	push   %ebp
  800dd2:	89 e5                	mov    %esp,%ebp
  800dd4:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  800dd7:	8b 45 08             	mov    0x8(%ebp),%eax
  800dda:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  800ddd:	8b 45 0c             	mov    0xc(%ebp),%eax
  800de0:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800de3:	eb 2a                	jmp    800e0f <memcmp+0x3e>
		if (*s1 != *s2)
  800de5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800de8:	8a 10                	mov    (%eax),%dl
  800dea:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800ded:	8a 00                	mov    (%eax),%al
  800def:	38 c2                	cmp    %al,%dl
  800df1:	74 16                	je     800e09 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  800df3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800df6:	8a 00                	mov    (%eax),%al
  800df8:	0f b6 d0             	movzbl %al,%edx
  800dfb:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800dfe:	8a 00                	mov    (%eax),%al
  800e00:	0f b6 c0             	movzbl %al,%eax
  800e03:	29 c2                	sub    %eax,%edx
  800e05:	89 d0                	mov    %edx,%eax
  800e07:	eb 18                	jmp    800e21 <memcmp+0x50>
		s1++, s2++;
  800e09:	ff 45 fc             	incl   -0x4(%ebp)
  800e0c:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  800e0f:	8b 45 10             	mov    0x10(%ebp),%eax
  800e12:	8d 50 ff             	lea    -0x1(%eax),%edx
  800e15:	89 55 10             	mov    %edx,0x10(%ebp)
  800e18:	85 c0                	test   %eax,%eax
  800e1a:	75 c9                	jne    800de5 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800e1c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800e21:	c9                   	leave  
  800e22:	c3                   	ret    

00800e23 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  800e23:	55                   	push   %ebp
  800e24:	89 e5                	mov    %esp,%ebp
  800e26:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  800e29:	8b 55 08             	mov    0x8(%ebp),%edx
  800e2c:	8b 45 10             	mov    0x10(%ebp),%eax
  800e2f:	01 d0                	add    %edx,%eax
  800e31:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  800e34:	eb 15                	jmp    800e4b <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  800e36:	8b 45 08             	mov    0x8(%ebp),%eax
  800e39:	8a 00                	mov    (%eax),%al
  800e3b:	0f b6 d0             	movzbl %al,%edx
  800e3e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e41:	0f b6 c0             	movzbl %al,%eax
  800e44:	39 c2                	cmp    %eax,%edx
  800e46:	74 0d                	je     800e55 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800e48:	ff 45 08             	incl   0x8(%ebp)
  800e4b:	8b 45 08             	mov    0x8(%ebp),%eax
  800e4e:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  800e51:	72 e3                	jb     800e36 <memfind+0x13>
  800e53:	eb 01                	jmp    800e56 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  800e55:	90                   	nop
	return (void *) s;
  800e56:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e59:	c9                   	leave  
  800e5a:	c3                   	ret    

00800e5b <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800e5b:	55                   	push   %ebp
  800e5c:	89 e5                	mov    %esp,%ebp
  800e5e:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  800e61:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  800e68:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800e6f:	eb 03                	jmp    800e74 <strtol+0x19>
		s++;
  800e71:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800e74:	8b 45 08             	mov    0x8(%ebp),%eax
  800e77:	8a 00                	mov    (%eax),%al
  800e79:	3c 20                	cmp    $0x20,%al
  800e7b:	74 f4                	je     800e71 <strtol+0x16>
  800e7d:	8b 45 08             	mov    0x8(%ebp),%eax
  800e80:	8a 00                	mov    (%eax),%al
  800e82:	3c 09                	cmp    $0x9,%al
  800e84:	74 eb                	je     800e71 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  800e86:	8b 45 08             	mov    0x8(%ebp),%eax
  800e89:	8a 00                	mov    (%eax),%al
  800e8b:	3c 2b                	cmp    $0x2b,%al
  800e8d:	75 05                	jne    800e94 <strtol+0x39>
		s++;
  800e8f:	ff 45 08             	incl   0x8(%ebp)
  800e92:	eb 13                	jmp    800ea7 <strtol+0x4c>
	else if (*s == '-')
  800e94:	8b 45 08             	mov    0x8(%ebp),%eax
  800e97:	8a 00                	mov    (%eax),%al
  800e99:	3c 2d                	cmp    $0x2d,%al
  800e9b:	75 0a                	jne    800ea7 <strtol+0x4c>
		s++, neg = 1;
  800e9d:	ff 45 08             	incl   0x8(%ebp)
  800ea0:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800ea7:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800eab:	74 06                	je     800eb3 <strtol+0x58>
  800ead:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  800eb1:	75 20                	jne    800ed3 <strtol+0x78>
  800eb3:	8b 45 08             	mov    0x8(%ebp),%eax
  800eb6:	8a 00                	mov    (%eax),%al
  800eb8:	3c 30                	cmp    $0x30,%al
  800eba:	75 17                	jne    800ed3 <strtol+0x78>
  800ebc:	8b 45 08             	mov    0x8(%ebp),%eax
  800ebf:	40                   	inc    %eax
  800ec0:	8a 00                	mov    (%eax),%al
  800ec2:	3c 78                	cmp    $0x78,%al
  800ec4:	75 0d                	jne    800ed3 <strtol+0x78>
		s += 2, base = 16;
  800ec6:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  800eca:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  800ed1:	eb 28                	jmp    800efb <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  800ed3:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ed7:	75 15                	jne    800eee <strtol+0x93>
  800ed9:	8b 45 08             	mov    0x8(%ebp),%eax
  800edc:	8a 00                	mov    (%eax),%al
  800ede:	3c 30                	cmp    $0x30,%al
  800ee0:	75 0c                	jne    800eee <strtol+0x93>
		s++, base = 8;
  800ee2:	ff 45 08             	incl   0x8(%ebp)
  800ee5:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  800eec:	eb 0d                	jmp    800efb <strtol+0xa0>
	else if (base == 0)
  800eee:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ef2:	75 07                	jne    800efb <strtol+0xa0>
		base = 10;
  800ef4:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800efb:	8b 45 08             	mov    0x8(%ebp),%eax
  800efe:	8a 00                	mov    (%eax),%al
  800f00:	3c 2f                	cmp    $0x2f,%al
  800f02:	7e 19                	jle    800f1d <strtol+0xc2>
  800f04:	8b 45 08             	mov    0x8(%ebp),%eax
  800f07:	8a 00                	mov    (%eax),%al
  800f09:	3c 39                	cmp    $0x39,%al
  800f0b:	7f 10                	jg     800f1d <strtol+0xc2>
			dig = *s - '0';
  800f0d:	8b 45 08             	mov    0x8(%ebp),%eax
  800f10:	8a 00                	mov    (%eax),%al
  800f12:	0f be c0             	movsbl %al,%eax
  800f15:	83 e8 30             	sub    $0x30,%eax
  800f18:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800f1b:	eb 42                	jmp    800f5f <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  800f1d:	8b 45 08             	mov    0x8(%ebp),%eax
  800f20:	8a 00                	mov    (%eax),%al
  800f22:	3c 60                	cmp    $0x60,%al
  800f24:	7e 19                	jle    800f3f <strtol+0xe4>
  800f26:	8b 45 08             	mov    0x8(%ebp),%eax
  800f29:	8a 00                	mov    (%eax),%al
  800f2b:	3c 7a                	cmp    $0x7a,%al
  800f2d:	7f 10                	jg     800f3f <strtol+0xe4>
			dig = *s - 'a' + 10;
  800f2f:	8b 45 08             	mov    0x8(%ebp),%eax
  800f32:	8a 00                	mov    (%eax),%al
  800f34:	0f be c0             	movsbl %al,%eax
  800f37:	83 e8 57             	sub    $0x57,%eax
  800f3a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800f3d:	eb 20                	jmp    800f5f <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  800f3f:	8b 45 08             	mov    0x8(%ebp),%eax
  800f42:	8a 00                	mov    (%eax),%al
  800f44:	3c 40                	cmp    $0x40,%al
  800f46:	7e 39                	jle    800f81 <strtol+0x126>
  800f48:	8b 45 08             	mov    0x8(%ebp),%eax
  800f4b:	8a 00                	mov    (%eax),%al
  800f4d:	3c 5a                	cmp    $0x5a,%al
  800f4f:	7f 30                	jg     800f81 <strtol+0x126>
			dig = *s - 'A' + 10;
  800f51:	8b 45 08             	mov    0x8(%ebp),%eax
  800f54:	8a 00                	mov    (%eax),%al
  800f56:	0f be c0             	movsbl %al,%eax
  800f59:	83 e8 37             	sub    $0x37,%eax
  800f5c:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  800f5f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800f62:	3b 45 10             	cmp    0x10(%ebp),%eax
  800f65:	7d 19                	jge    800f80 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  800f67:	ff 45 08             	incl   0x8(%ebp)
  800f6a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f6d:	0f af 45 10          	imul   0x10(%ebp),%eax
  800f71:	89 c2                	mov    %eax,%edx
  800f73:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800f76:	01 d0                	add    %edx,%eax
  800f78:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  800f7b:	e9 7b ff ff ff       	jmp    800efb <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  800f80:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  800f81:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800f85:	74 08                	je     800f8f <strtol+0x134>
		*endptr = (char *) s;
  800f87:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f8a:	8b 55 08             	mov    0x8(%ebp),%edx
  800f8d:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  800f8f:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  800f93:	74 07                	je     800f9c <strtol+0x141>
  800f95:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f98:	f7 d8                	neg    %eax
  800f9a:	eb 03                	jmp    800f9f <strtol+0x144>
  800f9c:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800f9f:	c9                   	leave  
  800fa0:	c3                   	ret    

00800fa1 <ltostr>:

void
ltostr(long value, char *str)
{
  800fa1:	55                   	push   %ebp
  800fa2:	89 e5                	mov    %esp,%ebp
  800fa4:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  800fa7:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  800fae:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  800fb5:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800fb9:	79 13                	jns    800fce <ltostr+0x2d>
	{
		neg = 1;
  800fbb:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  800fc2:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fc5:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  800fc8:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  800fcb:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  800fce:	8b 45 08             	mov    0x8(%ebp),%eax
  800fd1:	b9 0a 00 00 00       	mov    $0xa,%ecx
  800fd6:	99                   	cltd   
  800fd7:	f7 f9                	idiv   %ecx
  800fd9:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  800fdc:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800fdf:	8d 50 01             	lea    0x1(%eax),%edx
  800fe2:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800fe5:	89 c2                	mov    %eax,%edx
  800fe7:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fea:	01 d0                	add    %edx,%eax
  800fec:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800fef:	83 c2 30             	add    $0x30,%edx
  800ff2:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  800ff4:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800ff7:	b8 67 66 66 66       	mov    $0x66666667,%eax
  800ffc:	f7 e9                	imul   %ecx
  800ffe:	c1 fa 02             	sar    $0x2,%edx
  801001:	89 c8                	mov    %ecx,%eax
  801003:	c1 f8 1f             	sar    $0x1f,%eax
  801006:	29 c2                	sub    %eax,%edx
  801008:	89 d0                	mov    %edx,%eax
  80100a:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  80100d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801011:	75 bb                	jne    800fce <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801013:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  80101a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80101d:	48                   	dec    %eax
  80101e:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801021:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801025:	74 3d                	je     801064 <ltostr+0xc3>
		start = 1 ;
  801027:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  80102e:	eb 34                	jmp    801064 <ltostr+0xc3>
	{
		char tmp = str[start] ;
  801030:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801033:	8b 45 0c             	mov    0xc(%ebp),%eax
  801036:	01 d0                	add    %edx,%eax
  801038:	8a 00                	mov    (%eax),%al
  80103a:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  80103d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801040:	8b 45 0c             	mov    0xc(%ebp),%eax
  801043:	01 c2                	add    %eax,%edx
  801045:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801048:	8b 45 0c             	mov    0xc(%ebp),%eax
  80104b:	01 c8                	add    %ecx,%eax
  80104d:	8a 00                	mov    (%eax),%al
  80104f:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801051:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801054:	8b 45 0c             	mov    0xc(%ebp),%eax
  801057:	01 c2                	add    %eax,%edx
  801059:	8a 45 eb             	mov    -0x15(%ebp),%al
  80105c:	88 02                	mov    %al,(%edx)
		start++ ;
  80105e:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801061:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801064:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801067:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80106a:	7c c4                	jl     801030 <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  80106c:	8b 55 f8             	mov    -0x8(%ebp),%edx
  80106f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801072:	01 d0                	add    %edx,%eax
  801074:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801077:	90                   	nop
  801078:	c9                   	leave  
  801079:	c3                   	ret    

0080107a <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  80107a:	55                   	push   %ebp
  80107b:	89 e5                	mov    %esp,%ebp
  80107d:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801080:	ff 75 08             	pushl  0x8(%ebp)
  801083:	e8 c4 f9 ff ff       	call   800a4c <strlen>
  801088:	83 c4 04             	add    $0x4,%esp
  80108b:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  80108e:	ff 75 0c             	pushl  0xc(%ebp)
  801091:	e8 b6 f9 ff ff       	call   800a4c <strlen>
  801096:	83 c4 04             	add    $0x4,%esp
  801099:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  80109c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  8010a3:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8010aa:	eb 17                	jmp    8010c3 <strcconcat+0x49>
		final[s] = str1[s] ;
  8010ac:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8010af:	8b 45 10             	mov    0x10(%ebp),%eax
  8010b2:	01 c2                	add    %eax,%edx
  8010b4:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8010b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8010ba:	01 c8                	add    %ecx,%eax
  8010bc:	8a 00                	mov    (%eax),%al
  8010be:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  8010c0:	ff 45 fc             	incl   -0x4(%ebp)
  8010c3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8010c6:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8010c9:	7c e1                	jl     8010ac <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  8010cb:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  8010d2:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8010d9:	eb 1f                	jmp    8010fa <strcconcat+0x80>
		final[s++] = str2[i] ;
  8010db:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8010de:	8d 50 01             	lea    0x1(%eax),%edx
  8010e1:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8010e4:	89 c2                	mov    %eax,%edx
  8010e6:	8b 45 10             	mov    0x10(%ebp),%eax
  8010e9:	01 c2                	add    %eax,%edx
  8010eb:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8010ee:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010f1:	01 c8                	add    %ecx,%eax
  8010f3:	8a 00                	mov    (%eax),%al
  8010f5:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  8010f7:	ff 45 f8             	incl   -0x8(%ebp)
  8010fa:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010fd:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801100:	7c d9                	jl     8010db <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801102:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801105:	8b 45 10             	mov    0x10(%ebp),%eax
  801108:	01 d0                	add    %edx,%eax
  80110a:	c6 00 00             	movb   $0x0,(%eax)
}
  80110d:	90                   	nop
  80110e:	c9                   	leave  
  80110f:	c3                   	ret    

00801110 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801110:	55                   	push   %ebp
  801111:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801113:	8b 45 14             	mov    0x14(%ebp),%eax
  801116:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  80111c:	8b 45 14             	mov    0x14(%ebp),%eax
  80111f:	8b 00                	mov    (%eax),%eax
  801121:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801128:	8b 45 10             	mov    0x10(%ebp),%eax
  80112b:	01 d0                	add    %edx,%eax
  80112d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801133:	eb 0c                	jmp    801141 <strsplit+0x31>
			*string++ = 0;
  801135:	8b 45 08             	mov    0x8(%ebp),%eax
  801138:	8d 50 01             	lea    0x1(%eax),%edx
  80113b:	89 55 08             	mov    %edx,0x8(%ebp)
  80113e:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801141:	8b 45 08             	mov    0x8(%ebp),%eax
  801144:	8a 00                	mov    (%eax),%al
  801146:	84 c0                	test   %al,%al
  801148:	74 18                	je     801162 <strsplit+0x52>
  80114a:	8b 45 08             	mov    0x8(%ebp),%eax
  80114d:	8a 00                	mov    (%eax),%al
  80114f:	0f be c0             	movsbl %al,%eax
  801152:	50                   	push   %eax
  801153:	ff 75 0c             	pushl  0xc(%ebp)
  801156:	e8 83 fa ff ff       	call   800bde <strchr>
  80115b:	83 c4 08             	add    $0x8,%esp
  80115e:	85 c0                	test   %eax,%eax
  801160:	75 d3                	jne    801135 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801162:	8b 45 08             	mov    0x8(%ebp),%eax
  801165:	8a 00                	mov    (%eax),%al
  801167:	84 c0                	test   %al,%al
  801169:	74 5a                	je     8011c5 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  80116b:	8b 45 14             	mov    0x14(%ebp),%eax
  80116e:	8b 00                	mov    (%eax),%eax
  801170:	83 f8 0f             	cmp    $0xf,%eax
  801173:	75 07                	jne    80117c <strsplit+0x6c>
		{
			return 0;
  801175:	b8 00 00 00 00       	mov    $0x0,%eax
  80117a:	eb 66                	jmp    8011e2 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  80117c:	8b 45 14             	mov    0x14(%ebp),%eax
  80117f:	8b 00                	mov    (%eax),%eax
  801181:	8d 48 01             	lea    0x1(%eax),%ecx
  801184:	8b 55 14             	mov    0x14(%ebp),%edx
  801187:	89 0a                	mov    %ecx,(%edx)
  801189:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801190:	8b 45 10             	mov    0x10(%ebp),%eax
  801193:	01 c2                	add    %eax,%edx
  801195:	8b 45 08             	mov    0x8(%ebp),%eax
  801198:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  80119a:	eb 03                	jmp    80119f <strsplit+0x8f>
			string++;
  80119c:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  80119f:	8b 45 08             	mov    0x8(%ebp),%eax
  8011a2:	8a 00                	mov    (%eax),%al
  8011a4:	84 c0                	test   %al,%al
  8011a6:	74 8b                	je     801133 <strsplit+0x23>
  8011a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8011ab:	8a 00                	mov    (%eax),%al
  8011ad:	0f be c0             	movsbl %al,%eax
  8011b0:	50                   	push   %eax
  8011b1:	ff 75 0c             	pushl  0xc(%ebp)
  8011b4:	e8 25 fa ff ff       	call   800bde <strchr>
  8011b9:	83 c4 08             	add    $0x8,%esp
  8011bc:	85 c0                	test   %eax,%eax
  8011be:	74 dc                	je     80119c <strsplit+0x8c>
			string++;
	}
  8011c0:	e9 6e ff ff ff       	jmp    801133 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  8011c5:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  8011c6:	8b 45 14             	mov    0x14(%ebp),%eax
  8011c9:	8b 00                	mov    (%eax),%eax
  8011cb:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8011d2:	8b 45 10             	mov    0x10(%ebp),%eax
  8011d5:	01 d0                	add    %edx,%eax
  8011d7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  8011dd:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8011e2:	c9                   	leave  
  8011e3:	c3                   	ret    

008011e4 <str2lower>:


char* str2lower(char *dst, const char *src)
{
  8011e4:	55                   	push   %ebp
  8011e5:	89 e5                	mov    %esp,%ebp
  8011e7:	83 ec 10             	sub    $0x10,%esp
	char* ret = dst;
  8011ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8011ed:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (int i = 0; i < strlen(src); ++i)
  8011f0:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8011f7:	eb 4a                	jmp    801243 <str2lower+0x5f>
	{
		dst[i] = src[i] ;
  8011f9:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8011fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8011ff:	01 c2                	add    %eax,%edx
  801201:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801204:	8b 45 0c             	mov    0xc(%ebp),%eax
  801207:	01 c8                	add    %ecx,%eax
  801209:	8a 00                	mov    (%eax),%al
  80120b:	88 02                	mov    %al,(%edx)
		if (src[i] >= 'A' && src[i] <= 'Z')
  80120d:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801210:	8b 45 0c             	mov    0xc(%ebp),%eax
  801213:	01 d0                	add    %edx,%eax
  801215:	8a 00                	mov    (%eax),%al
  801217:	3c 40                	cmp    $0x40,%al
  801219:	7e 25                	jle    801240 <str2lower+0x5c>
  80121b:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80121e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801221:	01 d0                	add    %edx,%eax
  801223:	8a 00                	mov    (%eax),%al
  801225:	3c 5a                	cmp    $0x5a,%al
  801227:	7f 17                	jg     801240 <str2lower+0x5c>
		{
			dst[i] += 32 ;
  801229:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80122c:	8b 45 08             	mov    0x8(%ebp),%eax
  80122f:	01 d0                	add    %edx,%eax
  801231:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801234:	8b 55 08             	mov    0x8(%ebp),%edx
  801237:	01 ca                	add    %ecx,%edx
  801239:	8a 12                	mov    (%edx),%dl
  80123b:	83 c2 20             	add    $0x20,%edx
  80123e:	88 10                	mov    %dl,(%eax)


char* str2lower(char *dst, const char *src)
{
	char* ret = dst;
	for (int i = 0; i < strlen(src); ++i)
  801240:	ff 45 fc             	incl   -0x4(%ebp)
  801243:	ff 75 0c             	pushl  0xc(%ebp)
  801246:	e8 01 f8 ff ff       	call   800a4c <strlen>
  80124b:	83 c4 04             	add    $0x4,%esp
  80124e:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801251:	7f a6                	jg     8011f9 <str2lower+0x15>
		if (src[i] >= 'A' && src[i] <= 'Z')
		{
			dst[i] += 32 ;
		}
	}
	return ret;
  801253:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801256:	c9                   	leave  
  801257:	c3                   	ret    

00801258 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801258:	55                   	push   %ebp
  801259:	89 e5                	mov    %esp,%ebp
  80125b:	57                   	push   %edi
  80125c:	56                   	push   %esi
  80125d:	53                   	push   %ebx
  80125e:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801261:	8b 45 08             	mov    0x8(%ebp),%eax
  801264:	8b 55 0c             	mov    0xc(%ebp),%edx
  801267:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80126a:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80126d:	8b 7d 18             	mov    0x18(%ebp),%edi
  801270:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801273:	cd 30                	int    $0x30
  801275:	89 45 f0             	mov    %eax,-0x10(%ebp)
				"b" (a3),
				"D" (a4),
				"S" (a5)
				: "cc", "memory");

	return ret;
  801278:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80127b:	83 c4 10             	add    $0x10,%esp
  80127e:	5b                   	pop    %ebx
  80127f:	5e                   	pop    %esi
  801280:	5f                   	pop    %edi
  801281:	5d                   	pop    %ebp
  801282:	c3                   	ret    

00801283 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName, int color)
{
  801283:	55                   	push   %ebp
  801284:	89 e5                	mov    %esp,%ebp
  801286:	83 ec 04             	sub    $0x4,%esp
  801289:	8b 45 10             	mov    0x10(%ebp),%eax
  80128c:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, color, 0);
  80128f:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801292:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801296:	8b 45 08             	mov    0x8(%ebp),%eax
  801299:	6a 00                	push   $0x0
  80129b:	51                   	push   %ecx
  80129c:	52                   	push   %edx
  80129d:	ff 75 0c             	pushl  0xc(%ebp)
  8012a0:	50                   	push   %eax
  8012a1:	6a 00                	push   $0x0
  8012a3:	e8 b0 ff ff ff       	call   801258 <syscall>
  8012a8:	83 c4 18             	add    $0x18,%esp
}
  8012ab:	90                   	nop
  8012ac:	c9                   	leave  
  8012ad:	c3                   	ret    

008012ae <sys_cgetc>:

int
sys_cgetc(void)
{
  8012ae:	55                   	push   %ebp
  8012af:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  8012b1:	6a 00                	push   $0x0
  8012b3:	6a 00                	push   $0x0
  8012b5:	6a 00                	push   $0x0
  8012b7:	6a 00                	push   $0x0
  8012b9:	6a 00                	push   $0x0
  8012bb:	6a 02                	push   $0x2
  8012bd:	e8 96 ff ff ff       	call   801258 <syscall>
  8012c2:	83 c4 18             	add    $0x18,%esp
}
  8012c5:	c9                   	leave  
  8012c6:	c3                   	ret    

008012c7 <sys_lock_cons>:

void sys_lock_cons(void)
{
  8012c7:	55                   	push   %ebp
  8012c8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  8012ca:	6a 00                	push   $0x0
  8012cc:	6a 00                	push   $0x0
  8012ce:	6a 00                	push   $0x0
  8012d0:	6a 00                	push   $0x0
  8012d2:	6a 00                	push   $0x0
  8012d4:	6a 03                	push   $0x3
  8012d6:	e8 7d ff ff ff       	call   801258 <syscall>
  8012db:	83 c4 18             	add    $0x18,%esp
}
  8012de:	90                   	nop
  8012df:	c9                   	leave  
  8012e0:	c3                   	ret    

008012e1 <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  8012e1:	55                   	push   %ebp
  8012e2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  8012e4:	6a 00                	push   $0x0
  8012e6:	6a 00                	push   $0x0
  8012e8:	6a 00                	push   $0x0
  8012ea:	6a 00                	push   $0x0
  8012ec:	6a 00                	push   $0x0
  8012ee:	6a 04                	push   $0x4
  8012f0:	e8 63 ff ff ff       	call   801258 <syscall>
  8012f5:	83 c4 18             	add    $0x18,%esp
}
  8012f8:	90                   	nop
  8012f9:	c9                   	leave  
  8012fa:	c3                   	ret    

008012fb <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  8012fb:	55                   	push   %ebp
  8012fc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  8012fe:	8b 55 0c             	mov    0xc(%ebp),%edx
  801301:	8b 45 08             	mov    0x8(%ebp),%eax
  801304:	6a 00                	push   $0x0
  801306:	6a 00                	push   $0x0
  801308:	6a 00                	push   $0x0
  80130a:	52                   	push   %edx
  80130b:	50                   	push   %eax
  80130c:	6a 08                	push   $0x8
  80130e:	e8 45 ff ff ff       	call   801258 <syscall>
  801313:	83 c4 18             	add    $0x18,%esp
}
  801316:	c9                   	leave  
  801317:	c3                   	ret    

00801318 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801318:	55                   	push   %ebp
  801319:	89 e5                	mov    %esp,%ebp
  80131b:	56                   	push   %esi
  80131c:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  80131d:	8b 75 18             	mov    0x18(%ebp),%esi
  801320:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801323:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801326:	8b 55 0c             	mov    0xc(%ebp),%edx
  801329:	8b 45 08             	mov    0x8(%ebp),%eax
  80132c:	56                   	push   %esi
  80132d:	53                   	push   %ebx
  80132e:	51                   	push   %ecx
  80132f:	52                   	push   %edx
  801330:	50                   	push   %eax
  801331:	6a 09                	push   $0x9
  801333:	e8 20 ff ff ff       	call   801258 <syscall>
  801338:	83 c4 18             	add    $0x18,%esp
}
  80133b:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80133e:	5b                   	pop    %ebx
  80133f:	5e                   	pop    %esi
  801340:	5d                   	pop    %ebp
  801341:	c3                   	ret    

00801342 <__sys_unmap_frame>:

int __sys_unmap_frame(uint32 va)
{
  801342:	55                   	push   %ebp
  801343:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, va, 0, 0, 0, 0);
  801345:	6a 00                	push   $0x0
  801347:	6a 00                	push   $0x0
  801349:	6a 00                	push   $0x0
  80134b:	6a 00                	push   $0x0
  80134d:	ff 75 08             	pushl  0x8(%ebp)
  801350:	6a 0a                	push   $0xa
  801352:	e8 01 ff ff ff       	call   801258 <syscall>
  801357:	83 c4 18             	add    $0x18,%esp
}
  80135a:	c9                   	leave  
  80135b:	c3                   	ret    

0080135c <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  80135c:	55                   	push   %ebp
  80135d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  80135f:	6a 00                	push   $0x0
  801361:	6a 00                	push   $0x0
  801363:	6a 00                	push   $0x0
  801365:	ff 75 0c             	pushl  0xc(%ebp)
  801368:	ff 75 08             	pushl  0x8(%ebp)
  80136b:	6a 0b                	push   $0xb
  80136d:	e8 e6 fe ff ff       	call   801258 <syscall>
  801372:	83 c4 18             	add    $0x18,%esp
}
  801375:	c9                   	leave  
  801376:	c3                   	ret    

00801377 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801377:	55                   	push   %ebp
  801378:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  80137a:	6a 00                	push   $0x0
  80137c:	6a 00                	push   $0x0
  80137e:	6a 00                	push   $0x0
  801380:	6a 00                	push   $0x0
  801382:	6a 00                	push   $0x0
  801384:	6a 0c                	push   $0xc
  801386:	e8 cd fe ff ff       	call   801258 <syscall>
  80138b:	83 c4 18             	add    $0x18,%esp
}
  80138e:	c9                   	leave  
  80138f:	c3                   	ret    

00801390 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801390:	55                   	push   %ebp
  801391:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801393:	6a 00                	push   $0x0
  801395:	6a 00                	push   $0x0
  801397:	6a 00                	push   $0x0
  801399:	6a 00                	push   $0x0
  80139b:	6a 00                	push   $0x0
  80139d:	6a 0d                	push   $0xd
  80139f:	e8 b4 fe ff ff       	call   801258 <syscall>
  8013a4:	83 c4 18             	add    $0x18,%esp
}
  8013a7:	c9                   	leave  
  8013a8:	c3                   	ret    

008013a9 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  8013a9:	55                   	push   %ebp
  8013aa:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  8013ac:	6a 00                	push   $0x0
  8013ae:	6a 00                	push   $0x0
  8013b0:	6a 00                	push   $0x0
  8013b2:	6a 00                	push   $0x0
  8013b4:	6a 00                	push   $0x0
  8013b6:	6a 0e                	push   $0xe
  8013b8:	e8 9b fe ff ff       	call   801258 <syscall>
  8013bd:	83 c4 18             	add    $0x18,%esp
}
  8013c0:	c9                   	leave  
  8013c1:	c3                   	ret    

008013c2 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  8013c2:	55                   	push   %ebp
  8013c3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  8013c5:	6a 00                	push   $0x0
  8013c7:	6a 00                	push   $0x0
  8013c9:	6a 00                	push   $0x0
  8013cb:	6a 00                	push   $0x0
  8013cd:	6a 00                	push   $0x0
  8013cf:	6a 0f                	push   $0xf
  8013d1:	e8 82 fe ff ff       	call   801258 <syscall>
  8013d6:	83 c4 18             	add    $0x18,%esp
}
  8013d9:	c9                   	leave  
  8013da:	c3                   	ret    

008013db <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  8013db:	55                   	push   %ebp
  8013dc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  8013de:	6a 00                	push   $0x0
  8013e0:	6a 00                	push   $0x0
  8013e2:	6a 00                	push   $0x0
  8013e4:	6a 00                	push   $0x0
  8013e6:	ff 75 08             	pushl  0x8(%ebp)
  8013e9:	6a 10                	push   $0x10
  8013eb:	e8 68 fe ff ff       	call   801258 <syscall>
  8013f0:	83 c4 18             	add    $0x18,%esp
}
  8013f3:	c9                   	leave  
  8013f4:	c3                   	ret    

008013f5 <sys_scarce_memory>:

void sys_scarce_memory()
{
  8013f5:	55                   	push   %ebp
  8013f6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  8013f8:	6a 00                	push   $0x0
  8013fa:	6a 00                	push   $0x0
  8013fc:	6a 00                	push   $0x0
  8013fe:	6a 00                	push   $0x0
  801400:	6a 00                	push   $0x0
  801402:	6a 11                	push   $0x11
  801404:	e8 4f fe ff ff       	call   801258 <syscall>
  801409:	83 c4 18             	add    $0x18,%esp
}
  80140c:	90                   	nop
  80140d:	c9                   	leave  
  80140e:	c3                   	ret    

0080140f <sys_cputc>:

void
sys_cputc(const char c)
{
  80140f:	55                   	push   %ebp
  801410:	89 e5                	mov    %esp,%ebp
  801412:	83 ec 04             	sub    $0x4,%esp
  801415:	8b 45 08             	mov    0x8(%ebp),%eax
  801418:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  80141b:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  80141f:	6a 00                	push   $0x0
  801421:	6a 00                	push   $0x0
  801423:	6a 00                	push   $0x0
  801425:	6a 00                	push   $0x0
  801427:	50                   	push   %eax
  801428:	6a 01                	push   $0x1
  80142a:	e8 29 fe ff ff       	call   801258 <syscall>
  80142f:	83 c4 18             	add    $0x18,%esp
}
  801432:	90                   	nop
  801433:	c9                   	leave  
  801434:	c3                   	ret    

00801435 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801435:	55                   	push   %ebp
  801436:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801438:	6a 00                	push   $0x0
  80143a:	6a 00                	push   $0x0
  80143c:	6a 00                	push   $0x0
  80143e:	6a 00                	push   $0x0
  801440:	6a 00                	push   $0x0
  801442:	6a 14                	push   $0x14
  801444:	e8 0f fe ff ff       	call   801258 <syscall>
  801449:	83 c4 18             	add    $0x18,%esp
}
  80144c:	90                   	nop
  80144d:	c9                   	leave  
  80144e:	c3                   	ret    

0080144f <sys_create_shared_object>:

int sys_create_shared_object(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  80144f:	55                   	push   %ebp
  801450:	89 e5                	mov    %esp,%ebp
  801452:	83 ec 04             	sub    $0x4,%esp
  801455:	8b 45 10             	mov    0x10(%ebp),%eax
  801458:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  80145b:	8b 4d 14             	mov    0x14(%ebp),%ecx
  80145e:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801462:	8b 45 08             	mov    0x8(%ebp),%eax
  801465:	6a 00                	push   $0x0
  801467:	51                   	push   %ecx
  801468:	52                   	push   %edx
  801469:	ff 75 0c             	pushl  0xc(%ebp)
  80146c:	50                   	push   %eax
  80146d:	6a 15                	push   $0x15
  80146f:	e8 e4 fd ff ff       	call   801258 <syscall>
  801474:	83 c4 18             	add    $0x18,%esp
}
  801477:	c9                   	leave  
  801478:	c3                   	ret    

00801479 <sys_size_of_shared_object>:

//2017:
int sys_size_of_shared_object(int32 ownerID, char* shareName)
{
  801479:	55                   	push   %ebp
  80147a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  80147c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80147f:	8b 45 08             	mov    0x8(%ebp),%eax
  801482:	6a 00                	push   $0x0
  801484:	6a 00                	push   $0x0
  801486:	6a 00                	push   $0x0
  801488:	52                   	push   %edx
  801489:	50                   	push   %eax
  80148a:	6a 16                	push   $0x16
  80148c:	e8 c7 fd ff ff       	call   801258 <syscall>
  801491:	83 c4 18             	add    $0x18,%esp
}
  801494:	c9                   	leave  
  801495:	c3                   	ret    

00801496 <sys_get_shared_object>:
//==========

int sys_get_shared_object(int32 ownerID, char* shareName, void* virtual_address)
{
  801496:	55                   	push   %ebp
  801497:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801499:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80149c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80149f:	8b 45 08             	mov    0x8(%ebp),%eax
  8014a2:	6a 00                	push   $0x0
  8014a4:	6a 00                	push   $0x0
  8014a6:	51                   	push   %ecx
  8014a7:	52                   	push   %edx
  8014a8:	50                   	push   %eax
  8014a9:	6a 17                	push   $0x17
  8014ab:	e8 a8 fd ff ff       	call   801258 <syscall>
  8014b0:	83 c4 18             	add    $0x18,%esp
}
  8014b3:	c9                   	leave  
  8014b4:	c3                   	ret    

008014b5 <sys_delete_shared_object>:

int sys_delete_shared_object(int32 sharedObjectID, void *startVA)
{
  8014b5:	55                   	push   %ebp
  8014b6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  8014b8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8014bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8014be:	6a 00                	push   $0x0
  8014c0:	6a 00                	push   $0x0
  8014c2:	6a 00                	push   $0x0
  8014c4:	52                   	push   %edx
  8014c5:	50                   	push   %eax
  8014c6:	6a 18                	push   $0x18
  8014c8:	e8 8b fd ff ff       	call   801258 <syscall>
  8014cd:	83 c4 18             	add    $0x18,%esp
}
  8014d0:	c9                   	leave  
  8014d1:	c3                   	ret    

008014d2 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  8014d2:	55                   	push   %ebp
  8014d3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  8014d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8014d8:	6a 00                	push   $0x0
  8014da:	ff 75 14             	pushl  0x14(%ebp)
  8014dd:	ff 75 10             	pushl  0x10(%ebp)
  8014e0:	ff 75 0c             	pushl  0xc(%ebp)
  8014e3:	50                   	push   %eax
  8014e4:	6a 19                	push   $0x19
  8014e6:	e8 6d fd ff ff       	call   801258 <syscall>
  8014eb:	83 c4 18             	add    $0x18,%esp
}
  8014ee:	c9                   	leave  
  8014ef:	c3                   	ret    

008014f0 <sys_run_env>:

void sys_run_env(int32 envId)
{
  8014f0:	55                   	push   %ebp
  8014f1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  8014f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8014f6:	6a 00                	push   $0x0
  8014f8:	6a 00                	push   $0x0
  8014fa:	6a 00                	push   $0x0
  8014fc:	6a 00                	push   $0x0
  8014fe:	50                   	push   %eax
  8014ff:	6a 1a                	push   $0x1a
  801501:	e8 52 fd ff ff       	call   801258 <syscall>
  801506:	83 c4 18             	add    $0x18,%esp
}
  801509:	90                   	nop
  80150a:	c9                   	leave  
  80150b:	c3                   	ret    

0080150c <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  80150c:	55                   	push   %ebp
  80150d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  80150f:	8b 45 08             	mov    0x8(%ebp),%eax
  801512:	6a 00                	push   $0x0
  801514:	6a 00                	push   $0x0
  801516:	6a 00                	push   $0x0
  801518:	6a 00                	push   $0x0
  80151a:	50                   	push   %eax
  80151b:	6a 1b                	push   $0x1b
  80151d:	e8 36 fd ff ff       	call   801258 <syscall>
  801522:	83 c4 18             	add    $0x18,%esp
}
  801525:	c9                   	leave  
  801526:	c3                   	ret    

00801527 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801527:	55                   	push   %ebp
  801528:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  80152a:	6a 00                	push   $0x0
  80152c:	6a 00                	push   $0x0
  80152e:	6a 00                	push   $0x0
  801530:	6a 00                	push   $0x0
  801532:	6a 00                	push   $0x0
  801534:	6a 05                	push   $0x5
  801536:	e8 1d fd ff ff       	call   801258 <syscall>
  80153b:	83 c4 18             	add    $0x18,%esp
}
  80153e:	c9                   	leave  
  80153f:	c3                   	ret    

00801540 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801540:	55                   	push   %ebp
  801541:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801543:	6a 00                	push   $0x0
  801545:	6a 00                	push   $0x0
  801547:	6a 00                	push   $0x0
  801549:	6a 00                	push   $0x0
  80154b:	6a 00                	push   $0x0
  80154d:	6a 06                	push   $0x6
  80154f:	e8 04 fd ff ff       	call   801258 <syscall>
  801554:	83 c4 18             	add    $0x18,%esp
}
  801557:	c9                   	leave  
  801558:	c3                   	ret    

00801559 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801559:	55                   	push   %ebp
  80155a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  80155c:	6a 00                	push   $0x0
  80155e:	6a 00                	push   $0x0
  801560:	6a 00                	push   $0x0
  801562:	6a 00                	push   $0x0
  801564:	6a 00                	push   $0x0
  801566:	6a 07                	push   $0x7
  801568:	e8 eb fc ff ff       	call   801258 <syscall>
  80156d:	83 c4 18             	add    $0x18,%esp
}
  801570:	c9                   	leave  
  801571:	c3                   	ret    

00801572 <sys_exit_env>:


void sys_exit_env(void)
{
  801572:	55                   	push   %ebp
  801573:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801575:	6a 00                	push   $0x0
  801577:	6a 00                	push   $0x0
  801579:	6a 00                	push   $0x0
  80157b:	6a 00                	push   $0x0
  80157d:	6a 00                	push   $0x0
  80157f:	6a 1c                	push   $0x1c
  801581:	e8 d2 fc ff ff       	call   801258 <syscall>
  801586:	83 c4 18             	add    $0x18,%esp
}
  801589:	90                   	nop
  80158a:	c9                   	leave  
  80158b:	c3                   	ret    

0080158c <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  80158c:	55                   	push   %ebp
  80158d:	89 e5                	mov    %esp,%ebp
  80158f:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801592:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801595:	8d 50 04             	lea    0x4(%eax),%edx
  801598:	8d 45 f8             	lea    -0x8(%ebp),%eax
  80159b:	6a 00                	push   $0x0
  80159d:	6a 00                	push   $0x0
  80159f:	6a 00                	push   $0x0
  8015a1:	52                   	push   %edx
  8015a2:	50                   	push   %eax
  8015a3:	6a 1d                	push   $0x1d
  8015a5:	e8 ae fc ff ff       	call   801258 <syscall>
  8015aa:	83 c4 18             	add    $0x18,%esp
	return result;
  8015ad:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8015b0:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8015b3:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8015b6:	89 01                	mov    %eax,(%ecx)
  8015b8:	89 51 04             	mov    %edx,0x4(%ecx)
}
  8015bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8015be:	c9                   	leave  
  8015bf:	c2 04 00             	ret    $0x4

008015c2 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  8015c2:	55                   	push   %ebp
  8015c3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  8015c5:	6a 00                	push   $0x0
  8015c7:	6a 00                	push   $0x0
  8015c9:	ff 75 10             	pushl  0x10(%ebp)
  8015cc:	ff 75 0c             	pushl  0xc(%ebp)
  8015cf:	ff 75 08             	pushl  0x8(%ebp)
  8015d2:	6a 13                	push   $0x13
  8015d4:	e8 7f fc ff ff       	call   801258 <syscall>
  8015d9:	83 c4 18             	add    $0x18,%esp
	return ;
  8015dc:	90                   	nop
}
  8015dd:	c9                   	leave  
  8015de:	c3                   	ret    

008015df <sys_rcr2>:
uint32 sys_rcr2()
{
  8015df:	55                   	push   %ebp
  8015e0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  8015e2:	6a 00                	push   $0x0
  8015e4:	6a 00                	push   $0x0
  8015e6:	6a 00                	push   $0x0
  8015e8:	6a 00                	push   $0x0
  8015ea:	6a 00                	push   $0x0
  8015ec:	6a 1e                	push   $0x1e
  8015ee:	e8 65 fc ff ff       	call   801258 <syscall>
  8015f3:	83 c4 18             	add    $0x18,%esp
}
  8015f6:	c9                   	leave  
  8015f7:	c3                   	ret    

008015f8 <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  8015f8:	55                   	push   %ebp
  8015f9:	89 e5                	mov    %esp,%ebp
  8015fb:	83 ec 04             	sub    $0x4,%esp
  8015fe:	8b 45 08             	mov    0x8(%ebp),%eax
  801601:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801604:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801608:	6a 00                	push   $0x0
  80160a:	6a 00                	push   $0x0
  80160c:	6a 00                	push   $0x0
  80160e:	6a 00                	push   $0x0
  801610:	50                   	push   %eax
  801611:	6a 1f                	push   $0x1f
  801613:	e8 40 fc ff ff       	call   801258 <syscall>
  801618:	83 c4 18             	add    $0x18,%esp
	return ;
  80161b:	90                   	nop
}
  80161c:	c9                   	leave  
  80161d:	c3                   	ret    

0080161e <rsttst>:
void rsttst()
{
  80161e:	55                   	push   %ebp
  80161f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801621:	6a 00                	push   $0x0
  801623:	6a 00                	push   $0x0
  801625:	6a 00                	push   $0x0
  801627:	6a 00                	push   $0x0
  801629:	6a 00                	push   $0x0
  80162b:	6a 21                	push   $0x21
  80162d:	e8 26 fc ff ff       	call   801258 <syscall>
  801632:	83 c4 18             	add    $0x18,%esp
	return ;
  801635:	90                   	nop
}
  801636:	c9                   	leave  
  801637:	c3                   	ret    

00801638 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801638:	55                   	push   %ebp
  801639:	89 e5                	mov    %esp,%ebp
  80163b:	83 ec 04             	sub    $0x4,%esp
  80163e:	8b 45 14             	mov    0x14(%ebp),%eax
  801641:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801644:	8b 55 18             	mov    0x18(%ebp),%edx
  801647:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  80164b:	52                   	push   %edx
  80164c:	50                   	push   %eax
  80164d:	ff 75 10             	pushl  0x10(%ebp)
  801650:	ff 75 0c             	pushl  0xc(%ebp)
  801653:	ff 75 08             	pushl  0x8(%ebp)
  801656:	6a 20                	push   $0x20
  801658:	e8 fb fb ff ff       	call   801258 <syscall>
  80165d:	83 c4 18             	add    $0x18,%esp
	return ;
  801660:	90                   	nop
}
  801661:	c9                   	leave  
  801662:	c3                   	ret    

00801663 <chktst>:
void chktst(uint32 n)
{
  801663:	55                   	push   %ebp
  801664:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801666:	6a 00                	push   $0x0
  801668:	6a 00                	push   $0x0
  80166a:	6a 00                	push   $0x0
  80166c:	6a 00                	push   $0x0
  80166e:	ff 75 08             	pushl  0x8(%ebp)
  801671:	6a 22                	push   $0x22
  801673:	e8 e0 fb ff ff       	call   801258 <syscall>
  801678:	83 c4 18             	add    $0x18,%esp
	return ;
  80167b:	90                   	nop
}
  80167c:	c9                   	leave  
  80167d:	c3                   	ret    

0080167e <inctst>:

void inctst()
{
  80167e:	55                   	push   %ebp
  80167f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801681:	6a 00                	push   $0x0
  801683:	6a 00                	push   $0x0
  801685:	6a 00                	push   $0x0
  801687:	6a 00                	push   $0x0
  801689:	6a 00                	push   $0x0
  80168b:	6a 23                	push   $0x23
  80168d:	e8 c6 fb ff ff       	call   801258 <syscall>
  801692:	83 c4 18             	add    $0x18,%esp
	return ;
  801695:	90                   	nop
}
  801696:	c9                   	leave  
  801697:	c3                   	ret    

00801698 <gettst>:
uint32 gettst()
{
  801698:	55                   	push   %ebp
  801699:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  80169b:	6a 00                	push   $0x0
  80169d:	6a 00                	push   $0x0
  80169f:	6a 00                	push   $0x0
  8016a1:	6a 00                	push   $0x0
  8016a3:	6a 00                	push   $0x0
  8016a5:	6a 24                	push   $0x24
  8016a7:	e8 ac fb ff ff       	call   801258 <syscall>
  8016ac:	83 c4 18             	add    $0x18,%esp
}
  8016af:	c9                   	leave  
  8016b0:	c3                   	ret    

008016b1 <sys_get_uheap_strategy>:

/*2025*/
uint32 sys_get_uheap_strategy()
{
  8016b1:	55                   	push   %ebp
  8016b2:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8016b4:	6a 00                	push   $0x0
  8016b6:	6a 00                	push   $0x0
  8016b8:	6a 00                	push   $0x0
  8016ba:	6a 00                	push   $0x0
  8016bc:	6a 00                	push   $0x0
  8016be:	6a 25                	push   $0x25
  8016c0:	e8 93 fb ff ff       	call   801258 <syscall>
  8016c5:	83 c4 18             	add    $0x18,%esp
  8016c8:	a3 60 b0 81 00       	mov    %eax,0x81b060
	return uheapPlaceStrategy ;
  8016cd:	a1 60 b0 81 00       	mov    0x81b060,%eax
}
  8016d2:	c9                   	leave  
  8016d3:	c3                   	ret    

008016d4 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  8016d4:	55                   	push   %ebp
  8016d5:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = heapStrategy;
  8016d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8016da:	a3 60 b0 81 00       	mov    %eax,0x81b060
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  8016df:	6a 00                	push   $0x0
  8016e1:	6a 00                	push   $0x0
  8016e3:	6a 00                	push   $0x0
  8016e5:	6a 00                	push   $0x0
  8016e7:	ff 75 08             	pushl  0x8(%ebp)
  8016ea:	6a 26                	push   $0x26
  8016ec:	e8 67 fb ff ff       	call   801258 <syscall>
  8016f1:	83 c4 18             	add    $0x18,%esp
	return ;
  8016f4:	90                   	nop
}
  8016f5:	c9                   	leave  
  8016f6:	c3                   	ret    

008016f7 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  8016f7:	55                   	push   %ebp
  8016f8:	89 e5                	mov    %esp,%ebp
  8016fa:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  8016fb:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8016fe:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801701:	8b 55 0c             	mov    0xc(%ebp),%edx
  801704:	8b 45 08             	mov    0x8(%ebp),%eax
  801707:	6a 00                	push   $0x0
  801709:	53                   	push   %ebx
  80170a:	51                   	push   %ecx
  80170b:	52                   	push   %edx
  80170c:	50                   	push   %eax
  80170d:	6a 27                	push   $0x27
  80170f:	e8 44 fb ff ff       	call   801258 <syscall>
  801714:	83 c4 18             	add    $0x18,%esp
}
  801717:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80171a:	c9                   	leave  
  80171b:	c3                   	ret    

0080171c <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  80171c:	55                   	push   %ebp
  80171d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  80171f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801722:	8b 45 08             	mov    0x8(%ebp),%eax
  801725:	6a 00                	push   $0x0
  801727:	6a 00                	push   $0x0
  801729:	6a 00                	push   $0x0
  80172b:	52                   	push   %edx
  80172c:	50                   	push   %eax
  80172d:	6a 28                	push   $0x28
  80172f:	e8 24 fb ff ff       	call   801258 <syscall>
  801734:	83 c4 18             	add    $0x18,%esp
}
  801737:	c9                   	leave  
  801738:	c3                   	ret    

00801739 <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  801739:	55                   	push   %ebp
  80173a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  80173c:	8b 4d 14             	mov    0x14(%ebp),%ecx
  80173f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801742:	8b 45 08             	mov    0x8(%ebp),%eax
  801745:	6a 00                	push   $0x0
  801747:	51                   	push   %ecx
  801748:	ff 75 10             	pushl  0x10(%ebp)
  80174b:	52                   	push   %edx
  80174c:	50                   	push   %eax
  80174d:	6a 29                	push   $0x29
  80174f:	e8 04 fb ff ff       	call   801258 <syscall>
  801754:	83 c4 18             	add    $0x18,%esp
}
  801757:	c9                   	leave  
  801758:	c3                   	ret    

00801759 <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801759:	55                   	push   %ebp
  80175a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  80175c:	6a 00                	push   $0x0
  80175e:	6a 00                	push   $0x0
  801760:	ff 75 10             	pushl  0x10(%ebp)
  801763:	ff 75 0c             	pushl  0xc(%ebp)
  801766:	ff 75 08             	pushl  0x8(%ebp)
  801769:	6a 12                	push   $0x12
  80176b:	e8 e8 fa ff ff       	call   801258 <syscall>
  801770:	83 c4 18             	add    $0x18,%esp
	return ;
  801773:	90                   	nop
}
  801774:	c9                   	leave  
  801775:	c3                   	ret    

00801776 <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  801776:	55                   	push   %ebp
  801777:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  801779:	8b 55 0c             	mov    0xc(%ebp),%edx
  80177c:	8b 45 08             	mov    0x8(%ebp),%eax
  80177f:	6a 00                	push   $0x0
  801781:	6a 00                	push   $0x0
  801783:	6a 00                	push   $0x0
  801785:	52                   	push   %edx
  801786:	50                   	push   %eax
  801787:	6a 2a                	push   $0x2a
  801789:	e8 ca fa ff ff       	call   801258 <syscall>
  80178e:	83 c4 18             	add    $0x18,%esp
	return;
  801791:	90                   	nop
}
  801792:	c9                   	leave  
  801793:	c3                   	ret    

00801794 <sys_get_optimal_num_faults>:
/*2025*/
int sys_get_optimal_num_faults()
{
  801794:	55                   	push   %ebp
  801795:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_optimal_num_faults, 0, 0, 0, 0, 0);
  801797:	6a 00                	push   $0x0
  801799:	6a 00                	push   $0x0
  80179b:	6a 00                	push   $0x0
  80179d:	6a 00                	push   $0x0
  80179f:	6a 00                	push   $0x0
  8017a1:	6a 2b                	push   $0x2b
  8017a3:	e8 b0 fa ff ff       	call   801258 <syscall>
  8017a8:	83 c4 18             	add    $0x18,%esp
}
  8017ab:	c9                   	leave  
  8017ac:	c3                   	ret    

008017ad <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  8017ad:	55                   	push   %ebp
  8017ae:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  8017b0:	6a 00                	push   $0x0
  8017b2:	6a 00                	push   $0x0
  8017b4:	6a 00                	push   $0x0
  8017b6:	ff 75 0c             	pushl  0xc(%ebp)
  8017b9:	ff 75 08             	pushl  0x8(%ebp)
  8017bc:	6a 2d                	push   $0x2d
  8017be:	e8 95 fa ff ff       	call   801258 <syscall>
  8017c3:	83 c4 18             	add    $0x18,%esp
	return;
  8017c6:	90                   	nop
}
  8017c7:	c9                   	leave  
  8017c8:	c3                   	ret    

008017c9 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  8017c9:	55                   	push   %ebp
  8017ca:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  8017cc:	6a 00                	push   $0x0
  8017ce:	6a 00                	push   $0x0
  8017d0:	6a 00                	push   $0x0
  8017d2:	ff 75 0c             	pushl  0xc(%ebp)
  8017d5:	ff 75 08             	pushl  0x8(%ebp)
  8017d8:	6a 2c                	push   $0x2c
  8017da:	e8 79 fa ff ff       	call   801258 <syscall>
  8017df:	83 c4 18             	add    $0x18,%esp
	return ;
  8017e2:	90                   	nop
}
  8017e3:	c9                   	leave  
  8017e4:	c3                   	ret    

008017e5 <sys_env_set_priority>:


void sys_env_set_priority(int32 envID, int priority)
{
  8017e5:	55                   	push   %ebp
  8017e6:	89 e5                	mov    %esp,%ebp
  8017e8:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.IM#4] CPU SCHEDULING - #1 System Calls - Add suitable code here
	//Your code is here
	//Comment the following line
	panic("sys_env_set_priority() is not implemented yet...!!");
  8017eb:	83 ec 04             	sub    $0x4,%esp
  8017ee:	68 88 21 80 00       	push   $0x802188
  8017f3:	68 25 01 00 00       	push   $0x125
  8017f8:	68 bb 21 80 00       	push   $0x8021bb
  8017fd:	e8 00 00 00 00       	call   801802 <_panic>

00801802 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  801802:	55                   	push   %ebp
  801803:	89 e5                	mov    %esp,%ebp
  801805:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  801808:	8d 45 10             	lea    0x10(%ebp),%eax
  80180b:	83 c0 04             	add    $0x4,%eax
  80180e:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  801811:	a1 1c b1 81 00       	mov    0x81b11c,%eax
  801816:	85 c0                	test   %eax,%eax
  801818:	74 16                	je     801830 <_panic+0x2e>
		cprintf("%s: ", argv0);
  80181a:	a1 1c b1 81 00       	mov    0x81b11c,%eax
  80181f:	83 ec 08             	sub    $0x8,%esp
  801822:	50                   	push   %eax
  801823:	68 cc 21 80 00       	push   $0x8021cc
  801828:	e8 46 eb ff ff       	call   800373 <cprintf>
  80182d:	83 c4 10             	add    $0x10,%esp
	cprintf_colored(TEXT_PANIC_CLR, "user [EVAL_FINAL]panic in %s at %s:%d: ", binaryname, file, line);
  801830:	a1 04 30 80 00       	mov    0x803004,%eax
  801835:	83 ec 0c             	sub    $0xc,%esp
  801838:	ff 75 0c             	pushl  0xc(%ebp)
  80183b:	ff 75 08             	pushl  0x8(%ebp)
  80183e:	50                   	push   %eax
  80183f:	68 d4 21 80 00       	push   $0x8021d4
  801844:	6a 74                	push   $0x74
  801846:	e8 55 eb ff ff       	call   8003a0 <cprintf_colored>
  80184b:	83 c4 20             	add    $0x20,%esp
	vcprintf(fmt, ap);
  80184e:	8b 45 10             	mov    0x10(%ebp),%eax
  801851:	83 ec 08             	sub    $0x8,%esp
  801854:	ff 75 f4             	pushl  -0xc(%ebp)
  801857:	50                   	push   %eax
  801858:	e8 a7 ea ff ff       	call   800304 <vcprintf>
  80185d:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  801860:	83 ec 08             	sub    $0x8,%esp
  801863:	6a 00                	push   $0x0
  801865:	68 fc 21 80 00       	push   $0x8021fc
  80186a:	e8 95 ea ff ff       	call   800304 <vcprintf>
  80186f:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  801872:	e8 0e ea ff ff       	call   800285 <exit>

	// should not return here
	while (1) ;
  801877:	eb fe                	jmp    801877 <_panic+0x75>

00801879 <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  801879:	55                   	push   %ebp
  80187a:	89 e5                	mov    %esp,%ebp
  80187c:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  80187f:	a1 20 30 80 00       	mov    0x803020,%eax
  801884:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  80188a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80188d:	39 c2                	cmp    %eax,%edx
  80188f:	74 14                	je     8018a5 <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  801891:	83 ec 04             	sub    $0x4,%esp
  801894:	68 00 22 80 00       	push   $0x802200
  801899:	6a 26                	push   $0x26
  80189b:	68 4c 22 80 00       	push   $0x80224c
  8018a0:	e8 5d ff ff ff       	call   801802 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  8018a5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  8018ac:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8018b3:	e9 c5 00 00 00       	jmp    80197d <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  8018b8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8018bb:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8018c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8018c5:	01 d0                	add    %edx,%eax
  8018c7:	8b 00                	mov    (%eax),%eax
  8018c9:	85 c0                	test   %eax,%eax
  8018cb:	75 08                	jne    8018d5 <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  8018cd:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  8018d0:	e9 a5 00 00 00       	jmp    80197a <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  8018d5:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8018dc:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  8018e3:	eb 69                	jmp    80194e <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  8018e5:	a1 20 30 80 00       	mov    0x803020,%eax
  8018ea:	8b 88 38 da 01 00    	mov    0x1da38(%eax),%ecx
  8018f0:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8018f3:	89 d0                	mov    %edx,%eax
  8018f5:	01 c0                	add    %eax,%eax
  8018f7:	01 d0                	add    %edx,%eax
  8018f9:	c1 e0 03             	shl    $0x3,%eax
  8018fc:	01 c8                	add    %ecx,%eax
  8018fe:	8a 40 04             	mov    0x4(%eax),%al
  801901:	84 c0                	test   %al,%al
  801903:	75 46                	jne    80194b <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  801905:	a1 20 30 80 00       	mov    0x803020,%eax
  80190a:	8b 88 38 da 01 00    	mov    0x1da38(%eax),%ecx
  801910:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801913:	89 d0                	mov    %edx,%eax
  801915:	01 c0                	add    %eax,%eax
  801917:	01 d0                	add    %edx,%eax
  801919:	c1 e0 03             	shl    $0x3,%eax
  80191c:	01 c8                	add    %ecx,%eax
  80191e:	8b 00                	mov    (%eax),%eax
  801920:	89 45 dc             	mov    %eax,-0x24(%ebp)
  801923:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801926:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80192b:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  80192d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801930:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  801937:	8b 45 08             	mov    0x8(%ebp),%eax
  80193a:	01 c8                	add    %ecx,%eax
  80193c:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  80193e:	39 c2                	cmp    %eax,%edx
  801940:	75 09                	jne    80194b <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  801942:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  801949:	eb 15                	jmp    801960 <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80194b:	ff 45 e8             	incl   -0x18(%ebp)
  80194e:	a1 20 30 80 00       	mov    0x803020,%eax
  801953:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  801959:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80195c:	39 c2                	cmp    %eax,%edx
  80195e:	77 85                	ja     8018e5 <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  801960:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801964:	75 14                	jne    80197a <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  801966:	83 ec 04             	sub    $0x4,%esp
  801969:	68 58 22 80 00       	push   $0x802258
  80196e:	6a 3a                	push   $0x3a
  801970:	68 4c 22 80 00       	push   $0x80224c
  801975:	e8 88 fe ff ff       	call   801802 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  80197a:	ff 45 f0             	incl   -0x10(%ebp)
  80197d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801980:	3b 45 0c             	cmp    0xc(%ebp),%eax
  801983:	0f 8c 2f ff ff ff    	jl     8018b8 <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  801989:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  801990:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  801997:	eb 26                	jmp    8019bf <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  801999:	a1 20 30 80 00       	mov    0x803020,%eax
  80199e:	8b 88 38 da 01 00    	mov    0x1da38(%eax),%ecx
  8019a4:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8019a7:	89 d0                	mov    %edx,%eax
  8019a9:	01 c0                	add    %eax,%eax
  8019ab:	01 d0                	add    %edx,%eax
  8019ad:	c1 e0 03             	shl    $0x3,%eax
  8019b0:	01 c8                	add    %ecx,%eax
  8019b2:	8a 40 04             	mov    0x4(%eax),%al
  8019b5:	3c 01                	cmp    $0x1,%al
  8019b7:	75 03                	jne    8019bc <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  8019b9:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8019bc:	ff 45 e0             	incl   -0x20(%ebp)
  8019bf:	a1 20 30 80 00       	mov    0x803020,%eax
  8019c4:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  8019ca:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8019cd:	39 c2                	cmp    %eax,%edx
  8019cf:	77 c8                	ja     801999 <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  8019d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8019d4:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8019d7:	74 14                	je     8019ed <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  8019d9:	83 ec 04             	sub    $0x4,%esp
  8019dc:	68 ac 22 80 00       	push   $0x8022ac
  8019e1:	6a 44                	push   $0x44
  8019e3:	68 4c 22 80 00       	push   $0x80224c
  8019e8:	e8 15 fe ff ff       	call   801802 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  8019ed:	90                   	nop
  8019ee:	c9                   	leave  
  8019ef:	c3                   	ret    

008019f0 <__udivdi3>:
  8019f0:	55                   	push   %ebp
  8019f1:	57                   	push   %edi
  8019f2:	56                   	push   %esi
  8019f3:	53                   	push   %ebx
  8019f4:	83 ec 1c             	sub    $0x1c,%esp
  8019f7:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  8019fb:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  8019ff:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801a03:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801a07:	89 ca                	mov    %ecx,%edx
  801a09:	89 f8                	mov    %edi,%eax
  801a0b:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  801a0f:	85 f6                	test   %esi,%esi
  801a11:	75 2d                	jne    801a40 <__udivdi3+0x50>
  801a13:	39 cf                	cmp    %ecx,%edi
  801a15:	77 65                	ja     801a7c <__udivdi3+0x8c>
  801a17:	89 fd                	mov    %edi,%ebp
  801a19:	85 ff                	test   %edi,%edi
  801a1b:	75 0b                	jne    801a28 <__udivdi3+0x38>
  801a1d:	b8 01 00 00 00       	mov    $0x1,%eax
  801a22:	31 d2                	xor    %edx,%edx
  801a24:	f7 f7                	div    %edi
  801a26:	89 c5                	mov    %eax,%ebp
  801a28:	31 d2                	xor    %edx,%edx
  801a2a:	89 c8                	mov    %ecx,%eax
  801a2c:	f7 f5                	div    %ebp
  801a2e:	89 c1                	mov    %eax,%ecx
  801a30:	89 d8                	mov    %ebx,%eax
  801a32:	f7 f5                	div    %ebp
  801a34:	89 cf                	mov    %ecx,%edi
  801a36:	89 fa                	mov    %edi,%edx
  801a38:	83 c4 1c             	add    $0x1c,%esp
  801a3b:	5b                   	pop    %ebx
  801a3c:	5e                   	pop    %esi
  801a3d:	5f                   	pop    %edi
  801a3e:	5d                   	pop    %ebp
  801a3f:	c3                   	ret    
  801a40:	39 ce                	cmp    %ecx,%esi
  801a42:	77 28                	ja     801a6c <__udivdi3+0x7c>
  801a44:	0f bd fe             	bsr    %esi,%edi
  801a47:	83 f7 1f             	xor    $0x1f,%edi
  801a4a:	75 40                	jne    801a8c <__udivdi3+0x9c>
  801a4c:	39 ce                	cmp    %ecx,%esi
  801a4e:	72 0a                	jb     801a5a <__udivdi3+0x6a>
  801a50:	3b 44 24 08          	cmp    0x8(%esp),%eax
  801a54:	0f 87 9e 00 00 00    	ja     801af8 <__udivdi3+0x108>
  801a5a:	b8 01 00 00 00       	mov    $0x1,%eax
  801a5f:	89 fa                	mov    %edi,%edx
  801a61:	83 c4 1c             	add    $0x1c,%esp
  801a64:	5b                   	pop    %ebx
  801a65:	5e                   	pop    %esi
  801a66:	5f                   	pop    %edi
  801a67:	5d                   	pop    %ebp
  801a68:	c3                   	ret    
  801a69:	8d 76 00             	lea    0x0(%esi),%esi
  801a6c:	31 ff                	xor    %edi,%edi
  801a6e:	31 c0                	xor    %eax,%eax
  801a70:	89 fa                	mov    %edi,%edx
  801a72:	83 c4 1c             	add    $0x1c,%esp
  801a75:	5b                   	pop    %ebx
  801a76:	5e                   	pop    %esi
  801a77:	5f                   	pop    %edi
  801a78:	5d                   	pop    %ebp
  801a79:	c3                   	ret    
  801a7a:	66 90                	xchg   %ax,%ax
  801a7c:	89 d8                	mov    %ebx,%eax
  801a7e:	f7 f7                	div    %edi
  801a80:	31 ff                	xor    %edi,%edi
  801a82:	89 fa                	mov    %edi,%edx
  801a84:	83 c4 1c             	add    $0x1c,%esp
  801a87:	5b                   	pop    %ebx
  801a88:	5e                   	pop    %esi
  801a89:	5f                   	pop    %edi
  801a8a:	5d                   	pop    %ebp
  801a8b:	c3                   	ret    
  801a8c:	bd 20 00 00 00       	mov    $0x20,%ebp
  801a91:	89 eb                	mov    %ebp,%ebx
  801a93:	29 fb                	sub    %edi,%ebx
  801a95:	89 f9                	mov    %edi,%ecx
  801a97:	d3 e6                	shl    %cl,%esi
  801a99:	89 c5                	mov    %eax,%ebp
  801a9b:	88 d9                	mov    %bl,%cl
  801a9d:	d3 ed                	shr    %cl,%ebp
  801a9f:	89 e9                	mov    %ebp,%ecx
  801aa1:	09 f1                	or     %esi,%ecx
  801aa3:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  801aa7:	89 f9                	mov    %edi,%ecx
  801aa9:	d3 e0                	shl    %cl,%eax
  801aab:	89 c5                	mov    %eax,%ebp
  801aad:	89 d6                	mov    %edx,%esi
  801aaf:	88 d9                	mov    %bl,%cl
  801ab1:	d3 ee                	shr    %cl,%esi
  801ab3:	89 f9                	mov    %edi,%ecx
  801ab5:	d3 e2                	shl    %cl,%edx
  801ab7:	8b 44 24 08          	mov    0x8(%esp),%eax
  801abb:	88 d9                	mov    %bl,%cl
  801abd:	d3 e8                	shr    %cl,%eax
  801abf:	09 c2                	or     %eax,%edx
  801ac1:	89 d0                	mov    %edx,%eax
  801ac3:	89 f2                	mov    %esi,%edx
  801ac5:	f7 74 24 0c          	divl   0xc(%esp)
  801ac9:	89 d6                	mov    %edx,%esi
  801acb:	89 c3                	mov    %eax,%ebx
  801acd:	f7 e5                	mul    %ebp
  801acf:	39 d6                	cmp    %edx,%esi
  801ad1:	72 19                	jb     801aec <__udivdi3+0xfc>
  801ad3:	74 0b                	je     801ae0 <__udivdi3+0xf0>
  801ad5:	89 d8                	mov    %ebx,%eax
  801ad7:	31 ff                	xor    %edi,%edi
  801ad9:	e9 58 ff ff ff       	jmp    801a36 <__udivdi3+0x46>
  801ade:	66 90                	xchg   %ax,%ax
  801ae0:	8b 54 24 08          	mov    0x8(%esp),%edx
  801ae4:	89 f9                	mov    %edi,%ecx
  801ae6:	d3 e2                	shl    %cl,%edx
  801ae8:	39 c2                	cmp    %eax,%edx
  801aea:	73 e9                	jae    801ad5 <__udivdi3+0xe5>
  801aec:	8d 43 ff             	lea    -0x1(%ebx),%eax
  801aef:	31 ff                	xor    %edi,%edi
  801af1:	e9 40 ff ff ff       	jmp    801a36 <__udivdi3+0x46>
  801af6:	66 90                	xchg   %ax,%ax
  801af8:	31 c0                	xor    %eax,%eax
  801afa:	e9 37 ff ff ff       	jmp    801a36 <__udivdi3+0x46>
  801aff:	90                   	nop

00801b00 <__umoddi3>:
  801b00:	55                   	push   %ebp
  801b01:	57                   	push   %edi
  801b02:	56                   	push   %esi
  801b03:	53                   	push   %ebx
  801b04:	83 ec 1c             	sub    $0x1c,%esp
  801b07:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  801b0b:	8b 74 24 34          	mov    0x34(%esp),%esi
  801b0f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801b13:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  801b17:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801b1b:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801b1f:	89 f3                	mov    %esi,%ebx
  801b21:	89 fa                	mov    %edi,%edx
  801b23:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801b27:	89 34 24             	mov    %esi,(%esp)
  801b2a:	85 c0                	test   %eax,%eax
  801b2c:	75 1a                	jne    801b48 <__umoddi3+0x48>
  801b2e:	39 f7                	cmp    %esi,%edi
  801b30:	0f 86 a2 00 00 00    	jbe    801bd8 <__umoddi3+0xd8>
  801b36:	89 c8                	mov    %ecx,%eax
  801b38:	89 f2                	mov    %esi,%edx
  801b3a:	f7 f7                	div    %edi
  801b3c:	89 d0                	mov    %edx,%eax
  801b3e:	31 d2                	xor    %edx,%edx
  801b40:	83 c4 1c             	add    $0x1c,%esp
  801b43:	5b                   	pop    %ebx
  801b44:	5e                   	pop    %esi
  801b45:	5f                   	pop    %edi
  801b46:	5d                   	pop    %ebp
  801b47:	c3                   	ret    
  801b48:	39 f0                	cmp    %esi,%eax
  801b4a:	0f 87 ac 00 00 00    	ja     801bfc <__umoddi3+0xfc>
  801b50:	0f bd e8             	bsr    %eax,%ebp
  801b53:	83 f5 1f             	xor    $0x1f,%ebp
  801b56:	0f 84 ac 00 00 00    	je     801c08 <__umoddi3+0x108>
  801b5c:	bf 20 00 00 00       	mov    $0x20,%edi
  801b61:	29 ef                	sub    %ebp,%edi
  801b63:	89 fe                	mov    %edi,%esi
  801b65:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801b69:	89 e9                	mov    %ebp,%ecx
  801b6b:	d3 e0                	shl    %cl,%eax
  801b6d:	89 d7                	mov    %edx,%edi
  801b6f:	89 f1                	mov    %esi,%ecx
  801b71:	d3 ef                	shr    %cl,%edi
  801b73:	09 c7                	or     %eax,%edi
  801b75:	89 e9                	mov    %ebp,%ecx
  801b77:	d3 e2                	shl    %cl,%edx
  801b79:	89 14 24             	mov    %edx,(%esp)
  801b7c:	89 d8                	mov    %ebx,%eax
  801b7e:	d3 e0                	shl    %cl,%eax
  801b80:	89 c2                	mov    %eax,%edx
  801b82:	8b 44 24 08          	mov    0x8(%esp),%eax
  801b86:	d3 e0                	shl    %cl,%eax
  801b88:	89 44 24 04          	mov    %eax,0x4(%esp)
  801b8c:	8b 44 24 08          	mov    0x8(%esp),%eax
  801b90:	89 f1                	mov    %esi,%ecx
  801b92:	d3 e8                	shr    %cl,%eax
  801b94:	09 d0                	or     %edx,%eax
  801b96:	d3 eb                	shr    %cl,%ebx
  801b98:	89 da                	mov    %ebx,%edx
  801b9a:	f7 f7                	div    %edi
  801b9c:	89 d3                	mov    %edx,%ebx
  801b9e:	f7 24 24             	mull   (%esp)
  801ba1:	89 c6                	mov    %eax,%esi
  801ba3:	89 d1                	mov    %edx,%ecx
  801ba5:	39 d3                	cmp    %edx,%ebx
  801ba7:	0f 82 87 00 00 00    	jb     801c34 <__umoddi3+0x134>
  801bad:	0f 84 91 00 00 00    	je     801c44 <__umoddi3+0x144>
  801bb3:	8b 54 24 04          	mov    0x4(%esp),%edx
  801bb7:	29 f2                	sub    %esi,%edx
  801bb9:	19 cb                	sbb    %ecx,%ebx
  801bbb:	89 d8                	mov    %ebx,%eax
  801bbd:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  801bc1:	d3 e0                	shl    %cl,%eax
  801bc3:	89 e9                	mov    %ebp,%ecx
  801bc5:	d3 ea                	shr    %cl,%edx
  801bc7:	09 d0                	or     %edx,%eax
  801bc9:	89 e9                	mov    %ebp,%ecx
  801bcb:	d3 eb                	shr    %cl,%ebx
  801bcd:	89 da                	mov    %ebx,%edx
  801bcf:	83 c4 1c             	add    $0x1c,%esp
  801bd2:	5b                   	pop    %ebx
  801bd3:	5e                   	pop    %esi
  801bd4:	5f                   	pop    %edi
  801bd5:	5d                   	pop    %ebp
  801bd6:	c3                   	ret    
  801bd7:	90                   	nop
  801bd8:	89 fd                	mov    %edi,%ebp
  801bda:	85 ff                	test   %edi,%edi
  801bdc:	75 0b                	jne    801be9 <__umoddi3+0xe9>
  801bde:	b8 01 00 00 00       	mov    $0x1,%eax
  801be3:	31 d2                	xor    %edx,%edx
  801be5:	f7 f7                	div    %edi
  801be7:	89 c5                	mov    %eax,%ebp
  801be9:	89 f0                	mov    %esi,%eax
  801beb:	31 d2                	xor    %edx,%edx
  801bed:	f7 f5                	div    %ebp
  801bef:	89 c8                	mov    %ecx,%eax
  801bf1:	f7 f5                	div    %ebp
  801bf3:	89 d0                	mov    %edx,%eax
  801bf5:	e9 44 ff ff ff       	jmp    801b3e <__umoddi3+0x3e>
  801bfa:	66 90                	xchg   %ax,%ax
  801bfc:	89 c8                	mov    %ecx,%eax
  801bfe:	89 f2                	mov    %esi,%edx
  801c00:	83 c4 1c             	add    $0x1c,%esp
  801c03:	5b                   	pop    %ebx
  801c04:	5e                   	pop    %esi
  801c05:	5f                   	pop    %edi
  801c06:	5d                   	pop    %ebp
  801c07:	c3                   	ret    
  801c08:	3b 04 24             	cmp    (%esp),%eax
  801c0b:	72 06                	jb     801c13 <__umoddi3+0x113>
  801c0d:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  801c11:	77 0f                	ja     801c22 <__umoddi3+0x122>
  801c13:	89 f2                	mov    %esi,%edx
  801c15:	29 f9                	sub    %edi,%ecx
  801c17:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  801c1b:	89 14 24             	mov    %edx,(%esp)
  801c1e:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801c22:	8b 44 24 04          	mov    0x4(%esp),%eax
  801c26:	8b 14 24             	mov    (%esp),%edx
  801c29:	83 c4 1c             	add    $0x1c,%esp
  801c2c:	5b                   	pop    %ebx
  801c2d:	5e                   	pop    %esi
  801c2e:	5f                   	pop    %edi
  801c2f:	5d                   	pop    %ebp
  801c30:	c3                   	ret    
  801c31:	8d 76 00             	lea    0x0(%esi),%esi
  801c34:	2b 04 24             	sub    (%esp),%eax
  801c37:	19 fa                	sbb    %edi,%edx
  801c39:	89 d1                	mov    %edx,%ecx
  801c3b:	89 c6                	mov    %eax,%esi
  801c3d:	e9 71 ff ff ff       	jmp    801bb3 <__umoddi3+0xb3>
  801c42:	66 90                	xchg   %ax,%ax
  801c44:	39 44 24 04          	cmp    %eax,0x4(%esp)
  801c48:	72 ea                	jb     801c34 <__umoddi3+0x134>
  801c4a:	89 d9                	mov    %ebx,%ecx
  801c4c:	e9 62 ff ff ff       	jmp    801bb3 <__umoddi3+0xb3>
