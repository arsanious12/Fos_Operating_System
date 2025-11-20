
obj/user/fos_add:     file format elf32-i386


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
  800031:	e8 d9 00 00 00       	call   80010f <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
// hello, world
#include <inc/lib.h>

void
_main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	83 ec 28             	sub    $0x28,%esp
	int i1=0;
  80003e:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	int i2=0;
  800045:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)

	i1 = strtol("1", NULL, 10);
  80004c:	83 ec 04             	sub    $0x4,%esp
  80004f:	6a 0a                	push   $0xa
  800051:	6a 00                	push   $0x0
  800053:	68 a0 1c 80 00       	push   $0x801ca0
  800058:	e8 3f 0e 00 00       	call   800e9c <strtol>
  80005d:	83 c4 10             	add    $0x10,%esp
  800060:	89 45 e8             	mov    %eax,-0x18(%ebp)
	i2 = strtol("2", NULL, 10);
  800063:	83 ec 04             	sub    $0x4,%esp
  800066:	6a 0a                	push   $0xa
  800068:	6a 00                	push   $0x0
  80006a:	68 a2 1c 80 00       	push   $0x801ca2
  80006f:	e8 28 0e 00 00       	call   800e9c <strtol>
  800074:	83 c4 10             	add    $0x10,%esp
  800077:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	atomic_cprintf("number 1 + number 2 = %d\n",i1+i2);
  80007a:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80007d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800080:	01 d0                	add    %edx,%eax
  800082:	83 ec 08             	sub    $0x8,%esp
  800085:	50                   	push   %eax
  800086:	68 a4 1c 80 00       	push   $0x801ca4
  80008b:	e8 96 03 00 00       	call   800426 <atomic_cprintf>
  800090:	83 c4 10             	add    $0x10,%esp
	cprintf("%~number 1 + number 2 = \n");
  800093:	83 ec 0c             	sub    $0xc,%esp
  800096:	68 be 1c 80 00       	push   $0x801cbe
  80009b:	e8 14 03 00 00       	call   8003b4 <cprintf>
  8000a0:	83 c4 10             	add    $0x10,%esp

	int N = 100000;
  8000a3:	c7 45 e0 a0 86 01 00 	movl   $0x186a0,-0x20(%ebp)
	int64 sum = 0;
  8000aa:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8000b1:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int i = 0; i < N; ++i) {
  8000b8:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  8000bf:	eb 0d                	jmp    8000ce <_main+0x96>
		sum+=i ;
  8000c1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8000c4:	99                   	cltd   
  8000c5:	01 45 f0             	add    %eax,-0x10(%ebp)
  8000c8:	11 55 f4             	adc    %edx,-0xc(%ebp)
	atomic_cprintf("number 1 + number 2 = %d\n",i1+i2);
	cprintf("%~number 1 + number 2 = \n");

	int N = 100000;
	int64 sum = 0;
	for (int i = 0; i < N; ++i) {
  8000cb:	ff 45 ec             	incl   -0x14(%ebp)
  8000ce:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8000d1:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8000d4:	7c eb                	jl     8000c1 <_main+0x89>
		sum+=i ;
	}
	cprintf_colored(TEXT_green + TEXTBG_blue, "sum 1->%d = %d\n", N, sum);
  8000d6:	83 ec 0c             	sub    $0xc,%esp
  8000d9:	ff 75 f4             	pushl  -0xc(%ebp)
  8000dc:	ff 75 f0             	pushl  -0x10(%ebp)
  8000df:	ff 75 e0             	pushl  -0x20(%ebp)
  8000e2:	68 d8 1c 80 00       	push   $0x801cd8
  8000e7:	6a 12                	push   $0x12
  8000e9:	e8 f3 02 00 00       	call   8003e1 <cprintf_colored>
  8000ee:	83 c4 20             	add    $0x20,%esp
	cprintf_colored(TEXT_magenta + TEXTBG_cyan, "%~sum 1->%d = %d\n", N, sum);
  8000f1:	83 ec 0c             	sub    $0xc,%esp
  8000f4:	ff 75 f4             	pushl  -0xc(%ebp)
  8000f7:	ff 75 f0             	pushl  -0x10(%ebp)
  8000fa:	ff 75 e0             	pushl  -0x20(%ebp)
  8000fd:	68 e8 1c 80 00       	push   $0x801ce8
  800102:	6a 35                	push   $0x35
  800104:	e8 d8 02 00 00       	call   8003e1 <cprintf_colored>
  800109:	83 c4 20             	add    $0x20,%esp

	return;
  80010c:	90                   	nop
}
  80010d:	c9                   	leave  
  80010e:	c3                   	ret    

0080010f <libmain>:
volatile bool printStats = 1;

volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";
void
libmain(int argc, char **argv)
{
  80010f:	55                   	push   %ebp
  800110:	89 e5                	mov    %esp,%ebp
  800112:	57                   	push   %edi
  800113:	56                   	push   %esi
  800114:	53                   	push   %ebx
  800115:	83 ec 7c             	sub    $0x7c,%esp
	//printStats = 1;
	int envIndex = sys_getenvindex();
  800118:	e8 64 14 00 00       	call   801581 <sys_getenvindex>
  80011d:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	myEnv = &(envs[envIndex]);
  800120:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800123:	89 d0                	mov    %edx,%eax
  800125:	c1 e0 06             	shl    $0x6,%eax
  800128:	29 d0                	sub    %edx,%eax
  80012a:	c1 e0 02             	shl    $0x2,%eax
  80012d:	01 d0                	add    %edx,%eax
  80012f:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800136:	01 c8                	add    %ecx,%eax
  800138:	c1 e0 03             	shl    $0x3,%eax
  80013b:	01 d0                	add    %edx,%eax
  80013d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800144:	29 c2                	sub    %eax,%edx
  800146:	8d 04 95 00 00 00 00 	lea    0x0(,%edx,4),%eax
  80014d:	89 c2                	mov    %eax,%edx
  80014f:	8d 82 00 00 c0 ee    	lea    -0x11400000(%edx),%eax
  800155:	a3 20 30 80 00       	mov    %eax,0x803020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  80015a:	a1 20 30 80 00       	mov    0x803020,%eax
  80015f:	8a 40 20             	mov    0x20(%eax),%al
  800162:	84 c0                	test   %al,%al
  800164:	74 0d                	je     800173 <libmain+0x64>
		binaryname = myEnv->prog_name;
  800166:	a1 20 30 80 00       	mov    0x803020,%eax
  80016b:	83 c0 20             	add    $0x20,%eax
  80016e:	a3 04 30 80 00       	mov    %eax,0x803004

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800173:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800177:	7e 0a                	jle    800183 <libmain+0x74>
		binaryname = argv[0];
  800179:	8b 45 0c             	mov    0xc(%ebp),%eax
  80017c:	8b 00                	mov    (%eax),%eax
  80017e:	a3 04 30 80 00       	mov    %eax,0x803004

	// call user main routine
	_main(argc, argv);
  800183:	83 ec 08             	sub    $0x8,%esp
  800186:	ff 75 0c             	pushl  0xc(%ebp)
  800189:	ff 75 08             	pushl  0x8(%ebp)
  80018c:	e8 a7 fe ff ff       	call   800038 <_main>
  800191:	83 c4 10             	add    $0x10,%esp

	if (printStats)
  800194:	a1 00 30 80 00       	mov    0x803000,%eax
  800199:	85 c0                	test   %eax,%eax
  80019b:	0f 84 01 01 00 00    	je     8002a2 <libmain+0x193>
	{
		char isOPTReplCmd[100] = "__IsOPTRepl__" ;
  8001a1:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  8001a7:	bb f4 1d 80 00       	mov    $0x801df4,%ebx
  8001ac:	ba 0e 00 00 00       	mov    $0xe,%edx
  8001b1:	89 c7                	mov    %eax,%edi
  8001b3:	89 de                	mov    %ebx,%esi
  8001b5:	89 d1                	mov    %edx,%ecx
  8001b7:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  8001b9:	8d 55 8a             	lea    -0x76(%ebp),%edx
  8001bc:	b9 56 00 00 00       	mov    $0x56,%ecx
  8001c1:	b0 00                	mov    $0x0,%al
  8001c3:	89 d7                	mov    %edx,%edi
  8001c5:	f3 aa                	rep stos %al,%es:(%edi)
		int isOPTRepl = 0;
  8001c7:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
		sys_utilities(isOPTReplCmd, (uint32)(&isOPTRepl));
  8001ce:	8d 45 e0             	lea    -0x20(%ebp),%eax
  8001d1:	83 ec 08             	sub    $0x8,%esp
  8001d4:	50                   	push   %eax
  8001d5:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  8001db:	50                   	push   %eax
  8001dc:	e8 d6 15 00 00       	call   8017b7 <sys_utilities>
  8001e1:	83 c4 10             	add    $0x10,%esp

		sys_lock_cons();
  8001e4:	e8 1f 11 00 00       	call   801308 <sys_lock_cons>
		{
			cprintf("**************************************\n");
  8001e9:	83 ec 0c             	sub    $0xc,%esp
  8001ec:	68 14 1d 80 00       	push   $0x801d14
  8001f1:	e8 be 01 00 00       	call   8003b4 <cprintf>
  8001f6:	83 c4 10             	add    $0x10,%esp
			if (isOPTRepl)
  8001f9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8001fc:	85 c0                	test   %eax,%eax
  8001fe:	74 18                	je     800218 <libmain+0x109>
			{
				cprintf("OPTIMAL number of page faults = %d\n", sys_get_optimal_num_faults());
  800200:	e8 d0 15 00 00       	call   8017d5 <sys_get_optimal_num_faults>
  800205:	83 ec 08             	sub    $0x8,%esp
  800208:	50                   	push   %eax
  800209:	68 3c 1d 80 00       	push   $0x801d3c
  80020e:	e8 a1 01 00 00       	call   8003b4 <cprintf>
  800213:	83 c4 10             	add    $0x10,%esp
  800216:	eb 59                	jmp    800271 <libmain+0x162>
			}
			else
			{
				cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  800218:	a1 20 30 80 00       	mov    0x803020,%eax
  80021d:	8b 90 50 da 01 00    	mov    0x1da50(%eax),%edx
  800223:	a1 20 30 80 00       	mov    0x803020,%eax
  800228:	8b 80 40 da 01 00    	mov    0x1da40(%eax),%eax
  80022e:	83 ec 04             	sub    $0x4,%esp
  800231:	52                   	push   %edx
  800232:	50                   	push   %eax
  800233:	68 60 1d 80 00       	push   $0x801d60
  800238:	e8 77 01 00 00       	call   8003b4 <cprintf>
  80023d:	83 c4 10             	add    $0x10,%esp
				cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800240:	a1 20 30 80 00       	mov    0x803020,%eax
  800245:	8b 88 64 da 01 00    	mov    0x1da64(%eax),%ecx
  80024b:	a1 20 30 80 00       	mov    0x803020,%eax
  800250:	8b 90 60 da 01 00    	mov    0x1da60(%eax),%edx
  800256:	a1 20 30 80 00       	mov    0x803020,%eax
  80025b:	8b 80 5c da 01 00    	mov    0x1da5c(%eax),%eax
  800261:	51                   	push   %ecx
  800262:	52                   	push   %edx
  800263:	50                   	push   %eax
  800264:	68 88 1d 80 00       	push   $0x801d88
  800269:	e8 46 01 00 00       	call   8003b4 <cprintf>
  80026e:	83 c4 10             	add    $0x10,%esp
			}
			//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
			cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800271:	a1 20 30 80 00       	mov    0x803020,%eax
  800276:	8b 80 68 da 01 00    	mov    0x1da68(%eax),%eax
  80027c:	83 ec 08             	sub    $0x8,%esp
  80027f:	50                   	push   %eax
  800280:	68 e0 1d 80 00       	push   $0x801de0
  800285:	e8 2a 01 00 00       	call   8003b4 <cprintf>
  80028a:	83 c4 10             	add    $0x10,%esp
			cprintf("**************************************\n");
  80028d:	83 ec 0c             	sub    $0xc,%esp
  800290:	68 14 1d 80 00       	push   $0x801d14
  800295:	e8 1a 01 00 00       	call   8003b4 <cprintf>
  80029a:	83 c4 10             	add    $0x10,%esp
		}
		sys_unlock_cons();
  80029d:	e8 80 10 00 00       	call   801322 <sys_unlock_cons>
	}

	// exit gracefully
	exit();
  8002a2:	e8 1f 00 00 00       	call   8002c6 <exit>
}
  8002a7:	90                   	nop
  8002a8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8002ab:	5b                   	pop    %ebx
  8002ac:	5e                   	pop    %esi
  8002ad:	5f                   	pop    %edi
  8002ae:	5d                   	pop    %ebp
  8002af:	c3                   	ret    

008002b0 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  8002b0:	55                   	push   %ebp
  8002b1:	89 e5                	mov    %esp,%ebp
  8002b3:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  8002b6:	83 ec 0c             	sub    $0xc,%esp
  8002b9:	6a 00                	push   $0x0
  8002bb:	e8 8d 12 00 00       	call   80154d <sys_destroy_env>
  8002c0:	83 c4 10             	add    $0x10,%esp
}
  8002c3:	90                   	nop
  8002c4:	c9                   	leave  
  8002c5:	c3                   	ret    

008002c6 <exit>:

void
exit(void)
{
  8002c6:	55                   	push   %ebp
  8002c7:	89 e5                	mov    %esp,%ebp
  8002c9:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  8002cc:	e8 e2 12 00 00       	call   8015b3 <sys_exit_env>
}
  8002d1:	90                   	nop
  8002d2:	c9                   	leave  
  8002d3:	c3                   	ret    

008002d4 <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  8002d4:	55                   	push   %ebp
  8002d5:	89 e5                	mov    %esp,%ebp
  8002d7:	53                   	push   %ebx
  8002d8:	83 ec 04             	sub    $0x4,%esp
	b->buf[b->idx++] = ch;
  8002db:	8b 45 0c             	mov    0xc(%ebp),%eax
  8002de:	8b 00                	mov    (%eax),%eax
  8002e0:	8d 48 01             	lea    0x1(%eax),%ecx
  8002e3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8002e6:	89 0a                	mov    %ecx,(%edx)
  8002e8:	8b 55 08             	mov    0x8(%ebp),%edx
  8002eb:	88 d1                	mov    %dl,%cl
  8002ed:	8b 55 0c             	mov    0xc(%ebp),%edx
  8002f0:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  8002f4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8002f7:	8b 00                	mov    (%eax),%eax
  8002f9:	3d ff 00 00 00       	cmp    $0xff,%eax
  8002fe:	75 30                	jne    800330 <putch+0x5c>
		sys_cputs(b->buf, b->idx, printProgName, curTextClr);
  800300:	8b 15 18 b1 81 00    	mov    0x81b118,%edx
  800306:	a0 44 30 80 00       	mov    0x803044,%al
  80030b:	0f b6 c0             	movzbl %al,%eax
  80030e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800311:	8b 09                	mov    (%ecx),%ecx
  800313:	89 cb                	mov    %ecx,%ebx
  800315:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800318:	83 c1 08             	add    $0x8,%ecx
  80031b:	52                   	push   %edx
  80031c:	50                   	push   %eax
  80031d:	53                   	push   %ebx
  80031e:	51                   	push   %ecx
  80031f:	e8 a0 0f 00 00       	call   8012c4 <sys_cputs>
  800324:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800327:	8b 45 0c             	mov    0xc(%ebp),%eax
  80032a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800330:	8b 45 0c             	mov    0xc(%ebp),%eax
  800333:	8b 40 04             	mov    0x4(%eax),%eax
  800336:	8d 50 01             	lea    0x1(%eax),%edx
  800339:	8b 45 0c             	mov    0xc(%ebp),%eax
  80033c:	89 50 04             	mov    %edx,0x4(%eax)
}
  80033f:	90                   	nop
  800340:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800343:	c9                   	leave  
  800344:	c3                   	ret    

00800345 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800345:	55                   	push   %ebp
  800346:	89 e5                	mov    %esp,%ebp
  800348:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  80034e:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800355:	00 00 00 
	b.cnt = 0;
  800358:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  80035f:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800362:	ff 75 0c             	pushl  0xc(%ebp)
  800365:	ff 75 08             	pushl  0x8(%ebp)
  800368:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80036e:	50                   	push   %eax
  80036f:	68 d4 02 80 00       	push   $0x8002d4
  800374:	e8 5a 02 00 00       	call   8005d3 <vprintfmt>
  800379:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName, curTextClr);
  80037c:	8b 15 18 b1 81 00    	mov    0x81b118,%edx
  800382:	a0 44 30 80 00       	mov    0x803044,%al
  800387:	0f b6 c0             	movzbl %al,%eax
  80038a:	8b 8d f0 fe ff ff    	mov    -0x110(%ebp),%ecx
  800390:	52                   	push   %edx
  800391:	50                   	push   %eax
  800392:	51                   	push   %ecx
  800393:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800399:	83 c0 08             	add    $0x8,%eax
  80039c:	50                   	push   %eax
  80039d:	e8 22 0f 00 00       	call   8012c4 <sys_cputs>
  8003a2:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  8003a5:	c6 05 44 30 80 00 00 	movb   $0x0,0x803044
	return b.cnt;
  8003ac:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  8003b2:	c9                   	leave  
  8003b3:	c3                   	ret    

008003b4 <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  8003b4:	55                   	push   %ebp
  8003b5:	89 e5                	mov    %esp,%ebp
  8003b7:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  8003ba:	c6 05 44 30 80 00 01 	movb   $0x1,0x803044
	va_start(ap, fmt);
  8003c1:	8d 45 0c             	lea    0xc(%ebp),%eax
  8003c4:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8003c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8003ca:	83 ec 08             	sub    $0x8,%esp
  8003cd:	ff 75 f4             	pushl  -0xc(%ebp)
  8003d0:	50                   	push   %eax
  8003d1:	e8 6f ff ff ff       	call   800345 <vcprintf>
  8003d6:	83 c4 10             	add    $0x10,%esp
  8003d9:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  8003dc:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8003df:	c9                   	leave  
  8003e0:	c3                   	ret    

008003e1 <cprintf_colored>:

// *************** This text coloring feature is implemented by *************
// ********** Abd-Alrahman Zedan From Team Frozen-Bytes - FCIS'24-25 ********
int cprintf_colored(int textClr, const char *fmt, ...) {
  8003e1:	55                   	push   %ebp
  8003e2:	89 e5                	mov    %esp,%ebp
  8003e4:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  8003e7:	c6 05 44 30 80 00 01 	movb   $0x1,0x803044
	curTextClr = (textClr << 8) ; //set text color by the given value
  8003ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8003f1:	c1 e0 08             	shl    $0x8,%eax
  8003f4:	a3 18 b1 81 00       	mov    %eax,0x81b118
	va_start(ap, fmt);
  8003f9:	8d 45 0c             	lea    0xc(%ebp),%eax
  8003fc:	83 c0 04             	add    $0x4,%eax
  8003ff:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800402:	8b 45 0c             	mov    0xc(%ebp),%eax
  800405:	83 ec 08             	sub    $0x8,%esp
  800408:	ff 75 f4             	pushl  -0xc(%ebp)
  80040b:	50                   	push   %eax
  80040c:	e8 34 ff ff ff       	call   800345 <vcprintf>
  800411:	83 c4 10             	add    $0x10,%esp
  800414:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);
	curTextClr = TEXT_DEFAULT_CLR; //restore default color
  800417:	c7 05 18 b1 81 00 00 	movl   $0x700,0x81b118
  80041e:	07 00 00 

	return cnt;
  800421:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800424:	c9                   	leave  
  800425:	c3                   	ret    

00800426 <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  800426:	55                   	push   %ebp
  800427:	89 e5                	mov    %esp,%ebp
  800429:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  80042c:	e8 d7 0e 00 00       	call   801308 <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  800431:	8d 45 0c             	lea    0xc(%ebp),%eax
  800434:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  800437:	8b 45 08             	mov    0x8(%ebp),%eax
  80043a:	83 ec 08             	sub    $0x8,%esp
  80043d:	ff 75 f4             	pushl  -0xc(%ebp)
  800440:	50                   	push   %eax
  800441:	e8 ff fe ff ff       	call   800345 <vcprintf>
  800446:	83 c4 10             	add    $0x10,%esp
  800449:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  80044c:	e8 d1 0e 00 00       	call   801322 <sys_unlock_cons>
	return cnt;
  800451:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800454:	c9                   	leave  
  800455:	c3                   	ret    

00800456 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800456:	55                   	push   %ebp
  800457:	89 e5                	mov    %esp,%ebp
  800459:	53                   	push   %ebx
  80045a:	83 ec 14             	sub    $0x14,%esp
  80045d:	8b 45 10             	mov    0x10(%ebp),%eax
  800460:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800463:	8b 45 14             	mov    0x14(%ebp),%eax
  800466:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800469:	8b 45 18             	mov    0x18(%ebp),%eax
  80046c:	ba 00 00 00 00       	mov    $0x0,%edx
  800471:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800474:	77 55                	ja     8004cb <printnum+0x75>
  800476:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800479:	72 05                	jb     800480 <printnum+0x2a>
  80047b:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80047e:	77 4b                	ja     8004cb <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800480:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800483:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800486:	8b 45 18             	mov    0x18(%ebp),%eax
  800489:	ba 00 00 00 00       	mov    $0x0,%edx
  80048e:	52                   	push   %edx
  80048f:	50                   	push   %eax
  800490:	ff 75 f4             	pushl  -0xc(%ebp)
  800493:	ff 75 f0             	pushl  -0x10(%ebp)
  800496:	e8 99 15 00 00       	call   801a34 <__udivdi3>
  80049b:	83 c4 10             	add    $0x10,%esp
  80049e:	83 ec 04             	sub    $0x4,%esp
  8004a1:	ff 75 20             	pushl  0x20(%ebp)
  8004a4:	53                   	push   %ebx
  8004a5:	ff 75 18             	pushl  0x18(%ebp)
  8004a8:	52                   	push   %edx
  8004a9:	50                   	push   %eax
  8004aa:	ff 75 0c             	pushl  0xc(%ebp)
  8004ad:	ff 75 08             	pushl  0x8(%ebp)
  8004b0:	e8 a1 ff ff ff       	call   800456 <printnum>
  8004b5:	83 c4 20             	add    $0x20,%esp
  8004b8:	eb 1a                	jmp    8004d4 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8004ba:	83 ec 08             	sub    $0x8,%esp
  8004bd:	ff 75 0c             	pushl  0xc(%ebp)
  8004c0:	ff 75 20             	pushl  0x20(%ebp)
  8004c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8004c6:	ff d0                	call   *%eax
  8004c8:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8004cb:	ff 4d 1c             	decl   0x1c(%ebp)
  8004ce:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  8004d2:	7f e6                	jg     8004ba <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8004d4:	8b 4d 18             	mov    0x18(%ebp),%ecx
  8004d7:	bb 00 00 00 00       	mov    $0x0,%ebx
  8004dc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8004df:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8004e2:	53                   	push   %ebx
  8004e3:	51                   	push   %ecx
  8004e4:	52                   	push   %edx
  8004e5:	50                   	push   %eax
  8004e6:	e8 59 16 00 00       	call   801b44 <__umoddi3>
  8004eb:	83 c4 10             	add    $0x10,%esp
  8004ee:	05 74 20 80 00       	add    $0x802074,%eax
  8004f3:	8a 00                	mov    (%eax),%al
  8004f5:	0f be c0             	movsbl %al,%eax
  8004f8:	83 ec 08             	sub    $0x8,%esp
  8004fb:	ff 75 0c             	pushl  0xc(%ebp)
  8004fe:	50                   	push   %eax
  8004ff:	8b 45 08             	mov    0x8(%ebp),%eax
  800502:	ff d0                	call   *%eax
  800504:	83 c4 10             	add    $0x10,%esp
}
  800507:	90                   	nop
  800508:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80050b:	c9                   	leave  
  80050c:	c3                   	ret    

0080050d <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  80050d:	55                   	push   %ebp
  80050e:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800510:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800514:	7e 1c                	jle    800532 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800516:	8b 45 08             	mov    0x8(%ebp),%eax
  800519:	8b 00                	mov    (%eax),%eax
  80051b:	8d 50 08             	lea    0x8(%eax),%edx
  80051e:	8b 45 08             	mov    0x8(%ebp),%eax
  800521:	89 10                	mov    %edx,(%eax)
  800523:	8b 45 08             	mov    0x8(%ebp),%eax
  800526:	8b 00                	mov    (%eax),%eax
  800528:	83 e8 08             	sub    $0x8,%eax
  80052b:	8b 50 04             	mov    0x4(%eax),%edx
  80052e:	8b 00                	mov    (%eax),%eax
  800530:	eb 40                	jmp    800572 <getuint+0x65>
	else if (lflag)
  800532:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800536:	74 1e                	je     800556 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800538:	8b 45 08             	mov    0x8(%ebp),%eax
  80053b:	8b 00                	mov    (%eax),%eax
  80053d:	8d 50 04             	lea    0x4(%eax),%edx
  800540:	8b 45 08             	mov    0x8(%ebp),%eax
  800543:	89 10                	mov    %edx,(%eax)
  800545:	8b 45 08             	mov    0x8(%ebp),%eax
  800548:	8b 00                	mov    (%eax),%eax
  80054a:	83 e8 04             	sub    $0x4,%eax
  80054d:	8b 00                	mov    (%eax),%eax
  80054f:	ba 00 00 00 00       	mov    $0x0,%edx
  800554:	eb 1c                	jmp    800572 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800556:	8b 45 08             	mov    0x8(%ebp),%eax
  800559:	8b 00                	mov    (%eax),%eax
  80055b:	8d 50 04             	lea    0x4(%eax),%edx
  80055e:	8b 45 08             	mov    0x8(%ebp),%eax
  800561:	89 10                	mov    %edx,(%eax)
  800563:	8b 45 08             	mov    0x8(%ebp),%eax
  800566:	8b 00                	mov    (%eax),%eax
  800568:	83 e8 04             	sub    $0x4,%eax
  80056b:	8b 00                	mov    (%eax),%eax
  80056d:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800572:	5d                   	pop    %ebp
  800573:	c3                   	ret    

00800574 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800574:	55                   	push   %ebp
  800575:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800577:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  80057b:	7e 1c                	jle    800599 <getint+0x25>
		return va_arg(*ap, long long);
  80057d:	8b 45 08             	mov    0x8(%ebp),%eax
  800580:	8b 00                	mov    (%eax),%eax
  800582:	8d 50 08             	lea    0x8(%eax),%edx
  800585:	8b 45 08             	mov    0x8(%ebp),%eax
  800588:	89 10                	mov    %edx,(%eax)
  80058a:	8b 45 08             	mov    0x8(%ebp),%eax
  80058d:	8b 00                	mov    (%eax),%eax
  80058f:	83 e8 08             	sub    $0x8,%eax
  800592:	8b 50 04             	mov    0x4(%eax),%edx
  800595:	8b 00                	mov    (%eax),%eax
  800597:	eb 38                	jmp    8005d1 <getint+0x5d>
	else if (lflag)
  800599:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80059d:	74 1a                	je     8005b9 <getint+0x45>
		return va_arg(*ap, long);
  80059f:	8b 45 08             	mov    0x8(%ebp),%eax
  8005a2:	8b 00                	mov    (%eax),%eax
  8005a4:	8d 50 04             	lea    0x4(%eax),%edx
  8005a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8005aa:	89 10                	mov    %edx,(%eax)
  8005ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8005af:	8b 00                	mov    (%eax),%eax
  8005b1:	83 e8 04             	sub    $0x4,%eax
  8005b4:	8b 00                	mov    (%eax),%eax
  8005b6:	99                   	cltd   
  8005b7:	eb 18                	jmp    8005d1 <getint+0x5d>
	else
		return va_arg(*ap, int);
  8005b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8005bc:	8b 00                	mov    (%eax),%eax
  8005be:	8d 50 04             	lea    0x4(%eax),%edx
  8005c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8005c4:	89 10                	mov    %edx,(%eax)
  8005c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8005c9:	8b 00                	mov    (%eax),%eax
  8005cb:	83 e8 04             	sub    $0x4,%eax
  8005ce:	8b 00                	mov    (%eax),%eax
  8005d0:	99                   	cltd   
}
  8005d1:	5d                   	pop    %ebp
  8005d2:	c3                   	ret    

008005d3 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8005d3:	55                   	push   %ebp
  8005d4:	89 e5                	mov    %esp,%ebp
  8005d6:	56                   	push   %esi
  8005d7:	53                   	push   %ebx
  8005d8:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8005db:	eb 17                	jmp    8005f4 <vprintfmt+0x21>
			if (ch == '\0')
  8005dd:	85 db                	test   %ebx,%ebx
  8005df:	0f 84 c1 03 00 00    	je     8009a6 <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  8005e5:	83 ec 08             	sub    $0x8,%esp
  8005e8:	ff 75 0c             	pushl  0xc(%ebp)
  8005eb:	53                   	push   %ebx
  8005ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8005ef:	ff d0                	call   *%eax
  8005f1:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8005f4:	8b 45 10             	mov    0x10(%ebp),%eax
  8005f7:	8d 50 01             	lea    0x1(%eax),%edx
  8005fa:	89 55 10             	mov    %edx,0x10(%ebp)
  8005fd:	8a 00                	mov    (%eax),%al
  8005ff:	0f b6 d8             	movzbl %al,%ebx
  800602:	83 fb 25             	cmp    $0x25,%ebx
  800605:	75 d6                	jne    8005dd <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800607:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  80060b:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800612:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800619:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800620:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800627:	8b 45 10             	mov    0x10(%ebp),%eax
  80062a:	8d 50 01             	lea    0x1(%eax),%edx
  80062d:	89 55 10             	mov    %edx,0x10(%ebp)
  800630:	8a 00                	mov    (%eax),%al
  800632:	0f b6 d8             	movzbl %al,%ebx
  800635:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800638:	83 f8 5b             	cmp    $0x5b,%eax
  80063b:	0f 87 3d 03 00 00    	ja     80097e <vprintfmt+0x3ab>
  800641:	8b 04 85 98 20 80 00 	mov    0x802098(,%eax,4),%eax
  800648:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  80064a:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  80064e:	eb d7                	jmp    800627 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800650:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800654:	eb d1                	jmp    800627 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800656:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  80065d:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800660:	89 d0                	mov    %edx,%eax
  800662:	c1 e0 02             	shl    $0x2,%eax
  800665:	01 d0                	add    %edx,%eax
  800667:	01 c0                	add    %eax,%eax
  800669:	01 d8                	add    %ebx,%eax
  80066b:	83 e8 30             	sub    $0x30,%eax
  80066e:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800671:	8b 45 10             	mov    0x10(%ebp),%eax
  800674:	8a 00                	mov    (%eax),%al
  800676:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800679:	83 fb 2f             	cmp    $0x2f,%ebx
  80067c:	7e 3e                	jle    8006bc <vprintfmt+0xe9>
  80067e:	83 fb 39             	cmp    $0x39,%ebx
  800681:	7f 39                	jg     8006bc <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800683:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800686:	eb d5                	jmp    80065d <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800688:	8b 45 14             	mov    0x14(%ebp),%eax
  80068b:	83 c0 04             	add    $0x4,%eax
  80068e:	89 45 14             	mov    %eax,0x14(%ebp)
  800691:	8b 45 14             	mov    0x14(%ebp),%eax
  800694:	83 e8 04             	sub    $0x4,%eax
  800697:	8b 00                	mov    (%eax),%eax
  800699:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  80069c:	eb 1f                	jmp    8006bd <vprintfmt+0xea>

		case '.':
			if (width < 0)
  80069e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8006a2:	79 83                	jns    800627 <vprintfmt+0x54>
				width = 0;
  8006a4:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  8006ab:	e9 77 ff ff ff       	jmp    800627 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  8006b0:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  8006b7:	e9 6b ff ff ff       	jmp    800627 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  8006bc:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  8006bd:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8006c1:	0f 89 60 ff ff ff    	jns    800627 <vprintfmt+0x54>
				width = precision, precision = -1;
  8006c7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8006ca:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8006cd:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  8006d4:	e9 4e ff ff ff       	jmp    800627 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  8006d9:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  8006dc:	e9 46 ff ff ff       	jmp    800627 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  8006e1:	8b 45 14             	mov    0x14(%ebp),%eax
  8006e4:	83 c0 04             	add    $0x4,%eax
  8006e7:	89 45 14             	mov    %eax,0x14(%ebp)
  8006ea:	8b 45 14             	mov    0x14(%ebp),%eax
  8006ed:	83 e8 04             	sub    $0x4,%eax
  8006f0:	8b 00                	mov    (%eax),%eax
  8006f2:	83 ec 08             	sub    $0x8,%esp
  8006f5:	ff 75 0c             	pushl  0xc(%ebp)
  8006f8:	50                   	push   %eax
  8006f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8006fc:	ff d0                	call   *%eax
  8006fe:	83 c4 10             	add    $0x10,%esp
			break;
  800701:	e9 9b 02 00 00       	jmp    8009a1 <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800706:	8b 45 14             	mov    0x14(%ebp),%eax
  800709:	83 c0 04             	add    $0x4,%eax
  80070c:	89 45 14             	mov    %eax,0x14(%ebp)
  80070f:	8b 45 14             	mov    0x14(%ebp),%eax
  800712:	83 e8 04             	sub    $0x4,%eax
  800715:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800717:	85 db                	test   %ebx,%ebx
  800719:	79 02                	jns    80071d <vprintfmt+0x14a>
				err = -err;
  80071b:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  80071d:	83 fb 64             	cmp    $0x64,%ebx
  800720:	7f 0b                	jg     80072d <vprintfmt+0x15a>
  800722:	8b 34 9d e0 1e 80 00 	mov    0x801ee0(,%ebx,4),%esi
  800729:	85 f6                	test   %esi,%esi
  80072b:	75 19                	jne    800746 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  80072d:	53                   	push   %ebx
  80072e:	68 85 20 80 00       	push   $0x802085
  800733:	ff 75 0c             	pushl  0xc(%ebp)
  800736:	ff 75 08             	pushl  0x8(%ebp)
  800739:	e8 70 02 00 00       	call   8009ae <printfmt>
  80073e:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800741:	e9 5b 02 00 00       	jmp    8009a1 <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800746:	56                   	push   %esi
  800747:	68 8e 20 80 00       	push   $0x80208e
  80074c:	ff 75 0c             	pushl  0xc(%ebp)
  80074f:	ff 75 08             	pushl  0x8(%ebp)
  800752:	e8 57 02 00 00       	call   8009ae <printfmt>
  800757:	83 c4 10             	add    $0x10,%esp
			break;
  80075a:	e9 42 02 00 00       	jmp    8009a1 <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  80075f:	8b 45 14             	mov    0x14(%ebp),%eax
  800762:	83 c0 04             	add    $0x4,%eax
  800765:	89 45 14             	mov    %eax,0x14(%ebp)
  800768:	8b 45 14             	mov    0x14(%ebp),%eax
  80076b:	83 e8 04             	sub    $0x4,%eax
  80076e:	8b 30                	mov    (%eax),%esi
  800770:	85 f6                	test   %esi,%esi
  800772:	75 05                	jne    800779 <vprintfmt+0x1a6>
				p = "(null)";
  800774:	be 91 20 80 00       	mov    $0x802091,%esi
			if (width > 0 && padc != '-')
  800779:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80077d:	7e 6d                	jle    8007ec <vprintfmt+0x219>
  80077f:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800783:	74 67                	je     8007ec <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800785:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800788:	83 ec 08             	sub    $0x8,%esp
  80078b:	50                   	push   %eax
  80078c:	56                   	push   %esi
  80078d:	e8 1e 03 00 00       	call   800ab0 <strnlen>
  800792:	83 c4 10             	add    $0x10,%esp
  800795:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800798:	eb 16                	jmp    8007b0 <vprintfmt+0x1dd>
					putch(padc, putdat);
  80079a:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  80079e:	83 ec 08             	sub    $0x8,%esp
  8007a1:	ff 75 0c             	pushl  0xc(%ebp)
  8007a4:	50                   	push   %eax
  8007a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8007a8:	ff d0                	call   *%eax
  8007aa:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8007ad:	ff 4d e4             	decl   -0x1c(%ebp)
  8007b0:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8007b4:	7f e4                	jg     80079a <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8007b6:	eb 34                	jmp    8007ec <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  8007b8:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8007bc:	74 1c                	je     8007da <vprintfmt+0x207>
  8007be:	83 fb 1f             	cmp    $0x1f,%ebx
  8007c1:	7e 05                	jle    8007c8 <vprintfmt+0x1f5>
  8007c3:	83 fb 7e             	cmp    $0x7e,%ebx
  8007c6:	7e 12                	jle    8007da <vprintfmt+0x207>
					putch('?', putdat);
  8007c8:	83 ec 08             	sub    $0x8,%esp
  8007cb:	ff 75 0c             	pushl  0xc(%ebp)
  8007ce:	6a 3f                	push   $0x3f
  8007d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8007d3:	ff d0                	call   *%eax
  8007d5:	83 c4 10             	add    $0x10,%esp
  8007d8:	eb 0f                	jmp    8007e9 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  8007da:	83 ec 08             	sub    $0x8,%esp
  8007dd:	ff 75 0c             	pushl  0xc(%ebp)
  8007e0:	53                   	push   %ebx
  8007e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8007e4:	ff d0                	call   *%eax
  8007e6:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8007e9:	ff 4d e4             	decl   -0x1c(%ebp)
  8007ec:	89 f0                	mov    %esi,%eax
  8007ee:	8d 70 01             	lea    0x1(%eax),%esi
  8007f1:	8a 00                	mov    (%eax),%al
  8007f3:	0f be d8             	movsbl %al,%ebx
  8007f6:	85 db                	test   %ebx,%ebx
  8007f8:	74 24                	je     80081e <vprintfmt+0x24b>
  8007fa:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8007fe:	78 b8                	js     8007b8 <vprintfmt+0x1e5>
  800800:	ff 4d e0             	decl   -0x20(%ebp)
  800803:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800807:	79 af                	jns    8007b8 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800809:	eb 13                	jmp    80081e <vprintfmt+0x24b>
				putch(' ', putdat);
  80080b:	83 ec 08             	sub    $0x8,%esp
  80080e:	ff 75 0c             	pushl  0xc(%ebp)
  800811:	6a 20                	push   $0x20
  800813:	8b 45 08             	mov    0x8(%ebp),%eax
  800816:	ff d0                	call   *%eax
  800818:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  80081b:	ff 4d e4             	decl   -0x1c(%ebp)
  80081e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800822:	7f e7                	jg     80080b <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800824:	e9 78 01 00 00       	jmp    8009a1 <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800829:	83 ec 08             	sub    $0x8,%esp
  80082c:	ff 75 e8             	pushl  -0x18(%ebp)
  80082f:	8d 45 14             	lea    0x14(%ebp),%eax
  800832:	50                   	push   %eax
  800833:	e8 3c fd ff ff       	call   800574 <getint>
  800838:	83 c4 10             	add    $0x10,%esp
  80083b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80083e:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800841:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800844:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800847:	85 d2                	test   %edx,%edx
  800849:	79 23                	jns    80086e <vprintfmt+0x29b>
				putch('-', putdat);
  80084b:	83 ec 08             	sub    $0x8,%esp
  80084e:	ff 75 0c             	pushl  0xc(%ebp)
  800851:	6a 2d                	push   $0x2d
  800853:	8b 45 08             	mov    0x8(%ebp),%eax
  800856:	ff d0                	call   *%eax
  800858:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  80085b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80085e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800861:	f7 d8                	neg    %eax
  800863:	83 d2 00             	adc    $0x0,%edx
  800866:	f7 da                	neg    %edx
  800868:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80086b:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  80086e:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800875:	e9 bc 00 00 00       	jmp    800936 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  80087a:	83 ec 08             	sub    $0x8,%esp
  80087d:	ff 75 e8             	pushl  -0x18(%ebp)
  800880:	8d 45 14             	lea    0x14(%ebp),%eax
  800883:	50                   	push   %eax
  800884:	e8 84 fc ff ff       	call   80050d <getuint>
  800889:	83 c4 10             	add    $0x10,%esp
  80088c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80088f:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800892:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800899:	e9 98 00 00 00       	jmp    800936 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  80089e:	83 ec 08             	sub    $0x8,%esp
  8008a1:	ff 75 0c             	pushl  0xc(%ebp)
  8008a4:	6a 58                	push   $0x58
  8008a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8008a9:	ff d0                	call   *%eax
  8008ab:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  8008ae:	83 ec 08             	sub    $0x8,%esp
  8008b1:	ff 75 0c             	pushl  0xc(%ebp)
  8008b4:	6a 58                	push   $0x58
  8008b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8008b9:	ff d0                	call   *%eax
  8008bb:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  8008be:	83 ec 08             	sub    $0x8,%esp
  8008c1:	ff 75 0c             	pushl  0xc(%ebp)
  8008c4:	6a 58                	push   $0x58
  8008c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8008c9:	ff d0                	call   *%eax
  8008cb:	83 c4 10             	add    $0x10,%esp
			break;
  8008ce:	e9 ce 00 00 00       	jmp    8009a1 <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  8008d3:	83 ec 08             	sub    $0x8,%esp
  8008d6:	ff 75 0c             	pushl  0xc(%ebp)
  8008d9:	6a 30                	push   $0x30
  8008db:	8b 45 08             	mov    0x8(%ebp),%eax
  8008de:	ff d0                	call   *%eax
  8008e0:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  8008e3:	83 ec 08             	sub    $0x8,%esp
  8008e6:	ff 75 0c             	pushl  0xc(%ebp)
  8008e9:	6a 78                	push   $0x78
  8008eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8008ee:	ff d0                	call   *%eax
  8008f0:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  8008f3:	8b 45 14             	mov    0x14(%ebp),%eax
  8008f6:	83 c0 04             	add    $0x4,%eax
  8008f9:	89 45 14             	mov    %eax,0x14(%ebp)
  8008fc:	8b 45 14             	mov    0x14(%ebp),%eax
  8008ff:	83 e8 04             	sub    $0x4,%eax
  800902:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800904:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800907:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  80090e:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800915:	eb 1f                	jmp    800936 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800917:	83 ec 08             	sub    $0x8,%esp
  80091a:	ff 75 e8             	pushl  -0x18(%ebp)
  80091d:	8d 45 14             	lea    0x14(%ebp),%eax
  800920:	50                   	push   %eax
  800921:	e8 e7 fb ff ff       	call   80050d <getuint>
  800926:	83 c4 10             	add    $0x10,%esp
  800929:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80092c:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  80092f:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800936:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  80093a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80093d:	83 ec 04             	sub    $0x4,%esp
  800940:	52                   	push   %edx
  800941:	ff 75 e4             	pushl  -0x1c(%ebp)
  800944:	50                   	push   %eax
  800945:	ff 75 f4             	pushl  -0xc(%ebp)
  800948:	ff 75 f0             	pushl  -0x10(%ebp)
  80094b:	ff 75 0c             	pushl  0xc(%ebp)
  80094e:	ff 75 08             	pushl  0x8(%ebp)
  800951:	e8 00 fb ff ff       	call   800456 <printnum>
  800956:	83 c4 20             	add    $0x20,%esp
			break;
  800959:	eb 46                	jmp    8009a1 <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  80095b:	83 ec 08             	sub    $0x8,%esp
  80095e:	ff 75 0c             	pushl  0xc(%ebp)
  800961:	53                   	push   %ebx
  800962:	8b 45 08             	mov    0x8(%ebp),%eax
  800965:	ff d0                	call   *%eax
  800967:	83 c4 10             	add    $0x10,%esp
			break;
  80096a:	eb 35                	jmp    8009a1 <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  80096c:	c6 05 44 30 80 00 00 	movb   $0x0,0x803044
			break;
  800973:	eb 2c                	jmp    8009a1 <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  800975:	c6 05 44 30 80 00 01 	movb   $0x1,0x803044
			break;
  80097c:	eb 23                	jmp    8009a1 <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  80097e:	83 ec 08             	sub    $0x8,%esp
  800981:	ff 75 0c             	pushl  0xc(%ebp)
  800984:	6a 25                	push   $0x25
  800986:	8b 45 08             	mov    0x8(%ebp),%eax
  800989:	ff d0                	call   *%eax
  80098b:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  80098e:	ff 4d 10             	decl   0x10(%ebp)
  800991:	eb 03                	jmp    800996 <vprintfmt+0x3c3>
  800993:	ff 4d 10             	decl   0x10(%ebp)
  800996:	8b 45 10             	mov    0x10(%ebp),%eax
  800999:	48                   	dec    %eax
  80099a:	8a 00                	mov    (%eax),%al
  80099c:	3c 25                	cmp    $0x25,%al
  80099e:	75 f3                	jne    800993 <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  8009a0:	90                   	nop
		}
	}
  8009a1:	e9 35 fc ff ff       	jmp    8005db <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  8009a6:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  8009a7:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8009aa:	5b                   	pop    %ebx
  8009ab:	5e                   	pop    %esi
  8009ac:	5d                   	pop    %ebp
  8009ad:	c3                   	ret    

008009ae <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  8009ae:	55                   	push   %ebp
  8009af:	89 e5                	mov    %esp,%ebp
  8009b1:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  8009b4:	8d 45 10             	lea    0x10(%ebp),%eax
  8009b7:	83 c0 04             	add    $0x4,%eax
  8009ba:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  8009bd:	8b 45 10             	mov    0x10(%ebp),%eax
  8009c0:	ff 75 f4             	pushl  -0xc(%ebp)
  8009c3:	50                   	push   %eax
  8009c4:	ff 75 0c             	pushl  0xc(%ebp)
  8009c7:	ff 75 08             	pushl  0x8(%ebp)
  8009ca:	e8 04 fc ff ff       	call   8005d3 <vprintfmt>
  8009cf:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  8009d2:	90                   	nop
  8009d3:	c9                   	leave  
  8009d4:	c3                   	ret    

008009d5 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8009d5:	55                   	push   %ebp
  8009d6:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  8009d8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009db:	8b 40 08             	mov    0x8(%eax),%eax
  8009de:	8d 50 01             	lea    0x1(%eax),%edx
  8009e1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009e4:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  8009e7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009ea:	8b 10                	mov    (%eax),%edx
  8009ec:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009ef:	8b 40 04             	mov    0x4(%eax),%eax
  8009f2:	39 c2                	cmp    %eax,%edx
  8009f4:	73 12                	jae    800a08 <sprintputch+0x33>
		*b->buf++ = ch;
  8009f6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009f9:	8b 00                	mov    (%eax),%eax
  8009fb:	8d 48 01             	lea    0x1(%eax),%ecx
  8009fe:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a01:	89 0a                	mov    %ecx,(%edx)
  800a03:	8b 55 08             	mov    0x8(%ebp),%edx
  800a06:	88 10                	mov    %dl,(%eax)
}
  800a08:	90                   	nop
  800a09:	5d                   	pop    %ebp
  800a0a:	c3                   	ret    

00800a0b <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800a0b:	55                   	push   %ebp
  800a0c:	89 e5                	mov    %esp,%ebp
  800a0e:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800a11:	8b 45 08             	mov    0x8(%ebp),%eax
  800a14:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800a17:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a1a:	8d 50 ff             	lea    -0x1(%eax),%edx
  800a1d:	8b 45 08             	mov    0x8(%ebp),%eax
  800a20:	01 d0                	add    %edx,%eax
  800a22:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a25:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800a2c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800a30:	74 06                	je     800a38 <vsnprintf+0x2d>
  800a32:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800a36:	7f 07                	jg     800a3f <vsnprintf+0x34>
		return -E_INVAL;
  800a38:	b8 03 00 00 00       	mov    $0x3,%eax
  800a3d:	eb 20                	jmp    800a5f <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800a3f:	ff 75 14             	pushl  0x14(%ebp)
  800a42:	ff 75 10             	pushl  0x10(%ebp)
  800a45:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800a48:	50                   	push   %eax
  800a49:	68 d5 09 80 00       	push   $0x8009d5
  800a4e:	e8 80 fb ff ff       	call   8005d3 <vprintfmt>
  800a53:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800a56:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800a59:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800a5c:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800a5f:	c9                   	leave  
  800a60:	c3                   	ret    

00800a61 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800a61:	55                   	push   %ebp
  800a62:	89 e5                	mov    %esp,%ebp
  800a64:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800a67:	8d 45 10             	lea    0x10(%ebp),%eax
  800a6a:	83 c0 04             	add    $0x4,%eax
  800a6d:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800a70:	8b 45 10             	mov    0x10(%ebp),%eax
  800a73:	ff 75 f4             	pushl  -0xc(%ebp)
  800a76:	50                   	push   %eax
  800a77:	ff 75 0c             	pushl  0xc(%ebp)
  800a7a:	ff 75 08             	pushl  0x8(%ebp)
  800a7d:	e8 89 ff ff ff       	call   800a0b <vsnprintf>
  800a82:	83 c4 10             	add    $0x10,%esp
  800a85:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800a88:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800a8b:	c9                   	leave  
  800a8c:	c3                   	ret    

00800a8d <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800a8d:	55                   	push   %ebp
  800a8e:	89 e5                	mov    %esp,%ebp
  800a90:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800a93:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800a9a:	eb 06                	jmp    800aa2 <strlen+0x15>
		n++;
  800a9c:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800a9f:	ff 45 08             	incl   0x8(%ebp)
  800aa2:	8b 45 08             	mov    0x8(%ebp),%eax
  800aa5:	8a 00                	mov    (%eax),%al
  800aa7:	84 c0                	test   %al,%al
  800aa9:	75 f1                	jne    800a9c <strlen+0xf>
		n++;
	return n;
  800aab:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800aae:	c9                   	leave  
  800aaf:	c3                   	ret    

00800ab0 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800ab0:	55                   	push   %ebp
  800ab1:	89 e5                	mov    %esp,%ebp
  800ab3:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800ab6:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800abd:	eb 09                	jmp    800ac8 <strnlen+0x18>
		n++;
  800abf:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800ac2:	ff 45 08             	incl   0x8(%ebp)
  800ac5:	ff 4d 0c             	decl   0xc(%ebp)
  800ac8:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800acc:	74 09                	je     800ad7 <strnlen+0x27>
  800ace:	8b 45 08             	mov    0x8(%ebp),%eax
  800ad1:	8a 00                	mov    (%eax),%al
  800ad3:	84 c0                	test   %al,%al
  800ad5:	75 e8                	jne    800abf <strnlen+0xf>
		n++;
	return n;
  800ad7:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800ada:	c9                   	leave  
  800adb:	c3                   	ret    

00800adc <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800adc:	55                   	push   %ebp
  800add:	89 e5                	mov    %esp,%ebp
  800adf:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800ae2:	8b 45 08             	mov    0x8(%ebp),%eax
  800ae5:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800ae8:	90                   	nop
  800ae9:	8b 45 08             	mov    0x8(%ebp),%eax
  800aec:	8d 50 01             	lea    0x1(%eax),%edx
  800aef:	89 55 08             	mov    %edx,0x8(%ebp)
  800af2:	8b 55 0c             	mov    0xc(%ebp),%edx
  800af5:	8d 4a 01             	lea    0x1(%edx),%ecx
  800af8:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800afb:	8a 12                	mov    (%edx),%dl
  800afd:	88 10                	mov    %dl,(%eax)
  800aff:	8a 00                	mov    (%eax),%al
  800b01:	84 c0                	test   %al,%al
  800b03:	75 e4                	jne    800ae9 <strcpy+0xd>
		/* do nothing */;
	return ret;
  800b05:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800b08:	c9                   	leave  
  800b09:	c3                   	ret    

00800b0a <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800b0a:	55                   	push   %ebp
  800b0b:	89 e5                	mov    %esp,%ebp
  800b0d:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800b10:	8b 45 08             	mov    0x8(%ebp),%eax
  800b13:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800b16:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800b1d:	eb 1f                	jmp    800b3e <strncpy+0x34>
		*dst++ = *src;
  800b1f:	8b 45 08             	mov    0x8(%ebp),%eax
  800b22:	8d 50 01             	lea    0x1(%eax),%edx
  800b25:	89 55 08             	mov    %edx,0x8(%ebp)
  800b28:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b2b:	8a 12                	mov    (%edx),%dl
  800b2d:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800b2f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b32:	8a 00                	mov    (%eax),%al
  800b34:	84 c0                	test   %al,%al
  800b36:	74 03                	je     800b3b <strncpy+0x31>
			src++;
  800b38:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800b3b:	ff 45 fc             	incl   -0x4(%ebp)
  800b3e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800b41:	3b 45 10             	cmp    0x10(%ebp),%eax
  800b44:	72 d9                	jb     800b1f <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800b46:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800b49:	c9                   	leave  
  800b4a:	c3                   	ret    

00800b4b <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800b4b:	55                   	push   %ebp
  800b4c:	89 e5                	mov    %esp,%ebp
  800b4e:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800b51:	8b 45 08             	mov    0x8(%ebp),%eax
  800b54:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800b57:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800b5b:	74 30                	je     800b8d <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800b5d:	eb 16                	jmp    800b75 <strlcpy+0x2a>
			*dst++ = *src++;
  800b5f:	8b 45 08             	mov    0x8(%ebp),%eax
  800b62:	8d 50 01             	lea    0x1(%eax),%edx
  800b65:	89 55 08             	mov    %edx,0x8(%ebp)
  800b68:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b6b:	8d 4a 01             	lea    0x1(%edx),%ecx
  800b6e:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800b71:	8a 12                	mov    (%edx),%dl
  800b73:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800b75:	ff 4d 10             	decl   0x10(%ebp)
  800b78:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800b7c:	74 09                	je     800b87 <strlcpy+0x3c>
  800b7e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b81:	8a 00                	mov    (%eax),%al
  800b83:	84 c0                	test   %al,%al
  800b85:	75 d8                	jne    800b5f <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800b87:	8b 45 08             	mov    0x8(%ebp),%eax
  800b8a:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800b8d:	8b 55 08             	mov    0x8(%ebp),%edx
  800b90:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800b93:	29 c2                	sub    %eax,%edx
  800b95:	89 d0                	mov    %edx,%eax
}
  800b97:	c9                   	leave  
  800b98:	c3                   	ret    

00800b99 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800b99:	55                   	push   %ebp
  800b9a:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800b9c:	eb 06                	jmp    800ba4 <strcmp+0xb>
		p++, q++;
  800b9e:	ff 45 08             	incl   0x8(%ebp)
  800ba1:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800ba4:	8b 45 08             	mov    0x8(%ebp),%eax
  800ba7:	8a 00                	mov    (%eax),%al
  800ba9:	84 c0                	test   %al,%al
  800bab:	74 0e                	je     800bbb <strcmp+0x22>
  800bad:	8b 45 08             	mov    0x8(%ebp),%eax
  800bb0:	8a 10                	mov    (%eax),%dl
  800bb2:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bb5:	8a 00                	mov    (%eax),%al
  800bb7:	38 c2                	cmp    %al,%dl
  800bb9:	74 e3                	je     800b9e <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800bbb:	8b 45 08             	mov    0x8(%ebp),%eax
  800bbe:	8a 00                	mov    (%eax),%al
  800bc0:	0f b6 d0             	movzbl %al,%edx
  800bc3:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bc6:	8a 00                	mov    (%eax),%al
  800bc8:	0f b6 c0             	movzbl %al,%eax
  800bcb:	29 c2                	sub    %eax,%edx
  800bcd:	89 d0                	mov    %edx,%eax
}
  800bcf:	5d                   	pop    %ebp
  800bd0:	c3                   	ret    

00800bd1 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800bd1:	55                   	push   %ebp
  800bd2:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800bd4:	eb 09                	jmp    800bdf <strncmp+0xe>
		n--, p++, q++;
  800bd6:	ff 4d 10             	decl   0x10(%ebp)
  800bd9:	ff 45 08             	incl   0x8(%ebp)
  800bdc:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800bdf:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800be3:	74 17                	je     800bfc <strncmp+0x2b>
  800be5:	8b 45 08             	mov    0x8(%ebp),%eax
  800be8:	8a 00                	mov    (%eax),%al
  800bea:	84 c0                	test   %al,%al
  800bec:	74 0e                	je     800bfc <strncmp+0x2b>
  800bee:	8b 45 08             	mov    0x8(%ebp),%eax
  800bf1:	8a 10                	mov    (%eax),%dl
  800bf3:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bf6:	8a 00                	mov    (%eax),%al
  800bf8:	38 c2                	cmp    %al,%dl
  800bfa:	74 da                	je     800bd6 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800bfc:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800c00:	75 07                	jne    800c09 <strncmp+0x38>
		return 0;
  800c02:	b8 00 00 00 00       	mov    $0x0,%eax
  800c07:	eb 14                	jmp    800c1d <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800c09:	8b 45 08             	mov    0x8(%ebp),%eax
  800c0c:	8a 00                	mov    (%eax),%al
  800c0e:	0f b6 d0             	movzbl %al,%edx
  800c11:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c14:	8a 00                	mov    (%eax),%al
  800c16:	0f b6 c0             	movzbl %al,%eax
  800c19:	29 c2                	sub    %eax,%edx
  800c1b:	89 d0                	mov    %edx,%eax
}
  800c1d:	5d                   	pop    %ebp
  800c1e:	c3                   	ret    

00800c1f <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800c1f:	55                   	push   %ebp
  800c20:	89 e5                	mov    %esp,%ebp
  800c22:	83 ec 04             	sub    $0x4,%esp
  800c25:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c28:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800c2b:	eb 12                	jmp    800c3f <strchr+0x20>
		if (*s == c)
  800c2d:	8b 45 08             	mov    0x8(%ebp),%eax
  800c30:	8a 00                	mov    (%eax),%al
  800c32:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800c35:	75 05                	jne    800c3c <strchr+0x1d>
			return (char *) s;
  800c37:	8b 45 08             	mov    0x8(%ebp),%eax
  800c3a:	eb 11                	jmp    800c4d <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800c3c:	ff 45 08             	incl   0x8(%ebp)
  800c3f:	8b 45 08             	mov    0x8(%ebp),%eax
  800c42:	8a 00                	mov    (%eax),%al
  800c44:	84 c0                	test   %al,%al
  800c46:	75 e5                	jne    800c2d <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800c48:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800c4d:	c9                   	leave  
  800c4e:	c3                   	ret    

00800c4f <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800c4f:	55                   	push   %ebp
  800c50:	89 e5                	mov    %esp,%ebp
  800c52:	83 ec 04             	sub    $0x4,%esp
  800c55:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c58:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800c5b:	eb 0d                	jmp    800c6a <strfind+0x1b>
		if (*s == c)
  800c5d:	8b 45 08             	mov    0x8(%ebp),%eax
  800c60:	8a 00                	mov    (%eax),%al
  800c62:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800c65:	74 0e                	je     800c75 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800c67:	ff 45 08             	incl   0x8(%ebp)
  800c6a:	8b 45 08             	mov    0x8(%ebp),%eax
  800c6d:	8a 00                	mov    (%eax),%al
  800c6f:	84 c0                	test   %al,%al
  800c71:	75 ea                	jne    800c5d <strfind+0xe>
  800c73:	eb 01                	jmp    800c76 <strfind+0x27>
		if (*s == c)
			break;
  800c75:	90                   	nop
	return (char *) s;
  800c76:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800c79:	c9                   	leave  
  800c7a:	c3                   	ret    

00800c7b <memset>:

// *************** The faster implementation of memset & memcpy is implemented by *************
// ****************** Team80 (Yahia Khaled, Malek Ahmed et al) - FCIS'24-25 *******************
void *
memset(void *v, int c, uint32 n)
{
  800c7b:	55                   	push   %ebp
  800c7c:	89 e5                	mov    %esp,%ebp
  800c7e:	83 ec 10             	sub    $0x10,%esp
//	m = n;
//	while (--m >= 0)
//		*p++ = c;

	/*Faster Implementation*/
	uint64* p64 = (uint64*)v;
  800c81:	8b 45 08             	mov    0x8(%ebp),%eax
  800c84:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if(n >= 8){
  800c87:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800c8b:	76 63                	jbe    800cf0 <memset+0x75>
		uint64 data_block = c;
  800c8d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c90:	99                   	cltd   
  800c91:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c94:	89 55 f4             	mov    %edx,-0xc(%ebp)
		data_block |= data_block << 8;
  800c97:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800c9a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800c9d:	0f a4 c2 08          	shld   $0x8,%eax,%edx
  800ca1:	c1 e0 08             	shl    $0x8,%eax
  800ca4:	09 45 f0             	or     %eax,-0x10(%ebp)
  800ca7:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 16;
  800caa:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800cad:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800cb0:	0f a4 c2 10          	shld   $0x10,%eax,%edx
  800cb4:	c1 e0 10             	shl    $0x10,%eax
  800cb7:	09 45 f0             	or     %eax,-0x10(%ebp)
  800cba:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 32;
  800cbd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800cc0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800cc3:	89 c2                	mov    %eax,%edx
  800cc5:	b8 00 00 00 00       	mov    $0x0,%eax
  800cca:	09 45 f0             	or     %eax,-0x10(%ebp)
  800ccd:	09 55 f4             	or     %edx,-0xc(%ebp)

		while(n >= 8)
  800cd0:	eb 18                	jmp    800cea <memset+0x6f>
			*p64++ = data_block, n -= 8;
  800cd2:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  800cd5:	8d 41 08             	lea    0x8(%ecx),%eax
  800cd8:	89 45 fc             	mov    %eax,-0x4(%ebp)
  800cdb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800cde:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800ce1:	89 01                	mov    %eax,(%ecx)
  800ce3:	89 51 04             	mov    %edx,0x4(%ecx)
  800ce6:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
		uint64 data_block = c;
		data_block |= data_block << 8;
		data_block |= data_block << 16;
		data_block |= data_block << 32;

		while(n >= 8)
  800cea:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800cee:	77 e2                	ja     800cd2 <memset+0x57>
			*p64++ = data_block, n -= 8;
	}

	if(n){
  800cf0:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800cf4:	74 23                	je     800d19 <memset+0x9e>
		uint8* p8 = (uint8*)p64;
  800cf6:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800cf9:	89 45 f8             	mov    %eax,-0x8(%ebp)
		while (n-- > 0)
  800cfc:	eb 0e                	jmp    800d0c <memset+0x91>
			*p8++ = (uint8)c;
  800cfe:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800d01:	8d 50 01             	lea    0x1(%eax),%edx
  800d04:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800d07:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d0a:	88 10                	mov    %dl,(%eax)
			*p64++ = data_block, n -= 8;
	}

	if(n){
		uint8* p8 = (uint8*)p64;
		while (n-- > 0)
  800d0c:	8b 45 10             	mov    0x10(%ebp),%eax
  800d0f:	8d 50 ff             	lea    -0x1(%eax),%edx
  800d12:	89 55 10             	mov    %edx,0x10(%ebp)
  800d15:	85 c0                	test   %eax,%eax
  800d17:	75 e5                	jne    800cfe <memset+0x83>
			*p8++ = (uint8)c;
	}

	return v;
  800d19:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800d1c:	c9                   	leave  
  800d1d:	c3                   	ret    

00800d1e <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800d1e:	55                   	push   %ebp
  800d1f:	89 e5                	mov    %esp,%ebp
  800d21:	83 ec 10             	sub    $0x10,%esp
	//	s = src;
	//	d = dst;
	//	while (n-- > 0)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
  800d24:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d27:	89 45 fc             	mov    %eax,-0x4(%ebp)
	uint64* d64 = (uint64*)dst;
  800d2a:	8b 45 08             	mov    0x8(%ebp),%eax
  800d2d:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if(n >= 8){
  800d30:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800d34:	76 24                	jbe    800d5a <memcpy+0x3c>
		while(n >= 8){
  800d36:	eb 1c                	jmp    800d54 <memcpy+0x36>
			*d64 = *s64;
  800d38:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d3b:	8b 50 04             	mov    0x4(%eax),%edx
  800d3e:	8b 00                	mov    (%eax),%eax
  800d40:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  800d43:	89 01                	mov    %eax,(%ecx)
  800d45:	89 51 04             	mov    %edx,0x4(%ecx)
			n -= 8;
  800d48:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
			++s64;
  800d4c:	83 45 fc 08          	addl   $0x8,-0x4(%ebp)
			++d64;
  800d50:	83 45 f8 08          	addl   $0x8,-0x8(%ebp)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
	uint64* d64 = (uint64*)dst;
	if(n >= 8){
		while(n >= 8){
  800d54:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800d58:	77 de                	ja     800d38 <memcpy+0x1a>
			++s64;
			++d64;
		}
	}

	if(n){
  800d5a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d5e:	74 31                	je     800d91 <memcpy+0x73>
		uint8* s8 = (uint8*)s64;
  800d60:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d63:	89 45 f4             	mov    %eax,-0xc(%ebp)
		uint8* d8 = (uint8*)d64;
  800d66:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800d69:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (n-- > 0)
  800d6c:	eb 16                	jmp    800d84 <memcpy+0x66>
			*d8++ = *s8++;
  800d6e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800d71:	8d 50 01             	lea    0x1(%eax),%edx
  800d74:	89 55 f0             	mov    %edx,-0x10(%ebp)
  800d77:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800d7a:	8d 4a 01             	lea    0x1(%edx),%ecx
  800d7d:	89 4d f4             	mov    %ecx,-0xc(%ebp)
  800d80:	8a 12                	mov    (%edx),%dl
  800d82:	88 10                	mov    %dl,(%eax)
	}

	if(n){
		uint8* s8 = (uint8*)s64;
		uint8* d8 = (uint8*)d64;
		while (n-- > 0)
  800d84:	8b 45 10             	mov    0x10(%ebp),%eax
  800d87:	8d 50 ff             	lea    -0x1(%eax),%edx
  800d8a:	89 55 10             	mov    %edx,0x10(%ebp)
  800d8d:	85 c0                	test   %eax,%eax
  800d8f:	75 dd                	jne    800d6e <memcpy+0x50>
			*d8++ = *s8++;
	}
	return dst;
  800d91:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800d94:	c9                   	leave  
  800d95:	c3                   	ret    

00800d96 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800d96:	55                   	push   %ebp
  800d97:	89 e5                	mov    %esp,%ebp
  800d99:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800d9c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d9f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800da2:	8b 45 08             	mov    0x8(%ebp),%eax
  800da5:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800da8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800dab:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800dae:	73 50                	jae    800e00 <memmove+0x6a>
  800db0:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800db3:	8b 45 10             	mov    0x10(%ebp),%eax
  800db6:	01 d0                	add    %edx,%eax
  800db8:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800dbb:	76 43                	jbe    800e00 <memmove+0x6a>
		s += n;
  800dbd:	8b 45 10             	mov    0x10(%ebp),%eax
  800dc0:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800dc3:	8b 45 10             	mov    0x10(%ebp),%eax
  800dc6:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800dc9:	eb 10                	jmp    800ddb <memmove+0x45>
			*--d = *--s;
  800dcb:	ff 4d f8             	decl   -0x8(%ebp)
  800dce:	ff 4d fc             	decl   -0x4(%ebp)
  800dd1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800dd4:	8a 10                	mov    (%eax),%dl
  800dd6:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800dd9:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800ddb:	8b 45 10             	mov    0x10(%ebp),%eax
  800dde:	8d 50 ff             	lea    -0x1(%eax),%edx
  800de1:	89 55 10             	mov    %edx,0x10(%ebp)
  800de4:	85 c0                	test   %eax,%eax
  800de6:	75 e3                	jne    800dcb <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800de8:	eb 23                	jmp    800e0d <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800dea:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800ded:	8d 50 01             	lea    0x1(%eax),%edx
  800df0:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800df3:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800df6:	8d 4a 01             	lea    0x1(%edx),%ecx
  800df9:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800dfc:	8a 12                	mov    (%edx),%dl
  800dfe:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800e00:	8b 45 10             	mov    0x10(%ebp),%eax
  800e03:	8d 50 ff             	lea    -0x1(%eax),%edx
  800e06:	89 55 10             	mov    %edx,0x10(%ebp)
  800e09:	85 c0                	test   %eax,%eax
  800e0b:	75 dd                	jne    800dea <memmove+0x54>
			*d++ = *s++;

	return dst;
  800e0d:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e10:	c9                   	leave  
  800e11:	c3                   	ret    

00800e12 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  800e12:	55                   	push   %ebp
  800e13:	89 e5                	mov    %esp,%ebp
  800e15:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  800e18:	8b 45 08             	mov    0x8(%ebp),%eax
  800e1b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  800e1e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e21:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800e24:	eb 2a                	jmp    800e50 <memcmp+0x3e>
		if (*s1 != *s2)
  800e26:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e29:	8a 10                	mov    (%eax),%dl
  800e2b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e2e:	8a 00                	mov    (%eax),%al
  800e30:	38 c2                	cmp    %al,%dl
  800e32:	74 16                	je     800e4a <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  800e34:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e37:	8a 00                	mov    (%eax),%al
  800e39:	0f b6 d0             	movzbl %al,%edx
  800e3c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e3f:	8a 00                	mov    (%eax),%al
  800e41:	0f b6 c0             	movzbl %al,%eax
  800e44:	29 c2                	sub    %eax,%edx
  800e46:	89 d0                	mov    %edx,%eax
  800e48:	eb 18                	jmp    800e62 <memcmp+0x50>
		s1++, s2++;
  800e4a:	ff 45 fc             	incl   -0x4(%ebp)
  800e4d:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  800e50:	8b 45 10             	mov    0x10(%ebp),%eax
  800e53:	8d 50 ff             	lea    -0x1(%eax),%edx
  800e56:	89 55 10             	mov    %edx,0x10(%ebp)
  800e59:	85 c0                	test   %eax,%eax
  800e5b:	75 c9                	jne    800e26 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800e5d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800e62:	c9                   	leave  
  800e63:	c3                   	ret    

00800e64 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  800e64:	55                   	push   %ebp
  800e65:	89 e5                	mov    %esp,%ebp
  800e67:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  800e6a:	8b 55 08             	mov    0x8(%ebp),%edx
  800e6d:	8b 45 10             	mov    0x10(%ebp),%eax
  800e70:	01 d0                	add    %edx,%eax
  800e72:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  800e75:	eb 15                	jmp    800e8c <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  800e77:	8b 45 08             	mov    0x8(%ebp),%eax
  800e7a:	8a 00                	mov    (%eax),%al
  800e7c:	0f b6 d0             	movzbl %al,%edx
  800e7f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e82:	0f b6 c0             	movzbl %al,%eax
  800e85:	39 c2                	cmp    %eax,%edx
  800e87:	74 0d                	je     800e96 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800e89:	ff 45 08             	incl   0x8(%ebp)
  800e8c:	8b 45 08             	mov    0x8(%ebp),%eax
  800e8f:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  800e92:	72 e3                	jb     800e77 <memfind+0x13>
  800e94:	eb 01                	jmp    800e97 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  800e96:	90                   	nop
	return (void *) s;
  800e97:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e9a:	c9                   	leave  
  800e9b:	c3                   	ret    

00800e9c <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800e9c:	55                   	push   %ebp
  800e9d:	89 e5                	mov    %esp,%ebp
  800e9f:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  800ea2:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  800ea9:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800eb0:	eb 03                	jmp    800eb5 <strtol+0x19>
		s++;
  800eb2:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800eb5:	8b 45 08             	mov    0x8(%ebp),%eax
  800eb8:	8a 00                	mov    (%eax),%al
  800eba:	3c 20                	cmp    $0x20,%al
  800ebc:	74 f4                	je     800eb2 <strtol+0x16>
  800ebe:	8b 45 08             	mov    0x8(%ebp),%eax
  800ec1:	8a 00                	mov    (%eax),%al
  800ec3:	3c 09                	cmp    $0x9,%al
  800ec5:	74 eb                	je     800eb2 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  800ec7:	8b 45 08             	mov    0x8(%ebp),%eax
  800eca:	8a 00                	mov    (%eax),%al
  800ecc:	3c 2b                	cmp    $0x2b,%al
  800ece:	75 05                	jne    800ed5 <strtol+0x39>
		s++;
  800ed0:	ff 45 08             	incl   0x8(%ebp)
  800ed3:	eb 13                	jmp    800ee8 <strtol+0x4c>
	else if (*s == '-')
  800ed5:	8b 45 08             	mov    0x8(%ebp),%eax
  800ed8:	8a 00                	mov    (%eax),%al
  800eda:	3c 2d                	cmp    $0x2d,%al
  800edc:	75 0a                	jne    800ee8 <strtol+0x4c>
		s++, neg = 1;
  800ede:	ff 45 08             	incl   0x8(%ebp)
  800ee1:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800ee8:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800eec:	74 06                	je     800ef4 <strtol+0x58>
  800eee:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  800ef2:	75 20                	jne    800f14 <strtol+0x78>
  800ef4:	8b 45 08             	mov    0x8(%ebp),%eax
  800ef7:	8a 00                	mov    (%eax),%al
  800ef9:	3c 30                	cmp    $0x30,%al
  800efb:	75 17                	jne    800f14 <strtol+0x78>
  800efd:	8b 45 08             	mov    0x8(%ebp),%eax
  800f00:	40                   	inc    %eax
  800f01:	8a 00                	mov    (%eax),%al
  800f03:	3c 78                	cmp    $0x78,%al
  800f05:	75 0d                	jne    800f14 <strtol+0x78>
		s += 2, base = 16;
  800f07:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  800f0b:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  800f12:	eb 28                	jmp    800f3c <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  800f14:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f18:	75 15                	jne    800f2f <strtol+0x93>
  800f1a:	8b 45 08             	mov    0x8(%ebp),%eax
  800f1d:	8a 00                	mov    (%eax),%al
  800f1f:	3c 30                	cmp    $0x30,%al
  800f21:	75 0c                	jne    800f2f <strtol+0x93>
		s++, base = 8;
  800f23:	ff 45 08             	incl   0x8(%ebp)
  800f26:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  800f2d:	eb 0d                	jmp    800f3c <strtol+0xa0>
	else if (base == 0)
  800f2f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f33:	75 07                	jne    800f3c <strtol+0xa0>
		base = 10;
  800f35:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800f3c:	8b 45 08             	mov    0x8(%ebp),%eax
  800f3f:	8a 00                	mov    (%eax),%al
  800f41:	3c 2f                	cmp    $0x2f,%al
  800f43:	7e 19                	jle    800f5e <strtol+0xc2>
  800f45:	8b 45 08             	mov    0x8(%ebp),%eax
  800f48:	8a 00                	mov    (%eax),%al
  800f4a:	3c 39                	cmp    $0x39,%al
  800f4c:	7f 10                	jg     800f5e <strtol+0xc2>
			dig = *s - '0';
  800f4e:	8b 45 08             	mov    0x8(%ebp),%eax
  800f51:	8a 00                	mov    (%eax),%al
  800f53:	0f be c0             	movsbl %al,%eax
  800f56:	83 e8 30             	sub    $0x30,%eax
  800f59:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800f5c:	eb 42                	jmp    800fa0 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  800f5e:	8b 45 08             	mov    0x8(%ebp),%eax
  800f61:	8a 00                	mov    (%eax),%al
  800f63:	3c 60                	cmp    $0x60,%al
  800f65:	7e 19                	jle    800f80 <strtol+0xe4>
  800f67:	8b 45 08             	mov    0x8(%ebp),%eax
  800f6a:	8a 00                	mov    (%eax),%al
  800f6c:	3c 7a                	cmp    $0x7a,%al
  800f6e:	7f 10                	jg     800f80 <strtol+0xe4>
			dig = *s - 'a' + 10;
  800f70:	8b 45 08             	mov    0x8(%ebp),%eax
  800f73:	8a 00                	mov    (%eax),%al
  800f75:	0f be c0             	movsbl %al,%eax
  800f78:	83 e8 57             	sub    $0x57,%eax
  800f7b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800f7e:	eb 20                	jmp    800fa0 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  800f80:	8b 45 08             	mov    0x8(%ebp),%eax
  800f83:	8a 00                	mov    (%eax),%al
  800f85:	3c 40                	cmp    $0x40,%al
  800f87:	7e 39                	jle    800fc2 <strtol+0x126>
  800f89:	8b 45 08             	mov    0x8(%ebp),%eax
  800f8c:	8a 00                	mov    (%eax),%al
  800f8e:	3c 5a                	cmp    $0x5a,%al
  800f90:	7f 30                	jg     800fc2 <strtol+0x126>
			dig = *s - 'A' + 10;
  800f92:	8b 45 08             	mov    0x8(%ebp),%eax
  800f95:	8a 00                	mov    (%eax),%al
  800f97:	0f be c0             	movsbl %al,%eax
  800f9a:	83 e8 37             	sub    $0x37,%eax
  800f9d:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  800fa0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800fa3:	3b 45 10             	cmp    0x10(%ebp),%eax
  800fa6:	7d 19                	jge    800fc1 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  800fa8:	ff 45 08             	incl   0x8(%ebp)
  800fab:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800fae:	0f af 45 10          	imul   0x10(%ebp),%eax
  800fb2:	89 c2                	mov    %eax,%edx
  800fb4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800fb7:	01 d0                	add    %edx,%eax
  800fb9:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  800fbc:	e9 7b ff ff ff       	jmp    800f3c <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  800fc1:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  800fc2:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800fc6:	74 08                	je     800fd0 <strtol+0x134>
		*endptr = (char *) s;
  800fc8:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fcb:	8b 55 08             	mov    0x8(%ebp),%edx
  800fce:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  800fd0:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  800fd4:	74 07                	je     800fdd <strtol+0x141>
  800fd6:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800fd9:	f7 d8                	neg    %eax
  800fdb:	eb 03                	jmp    800fe0 <strtol+0x144>
  800fdd:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800fe0:	c9                   	leave  
  800fe1:	c3                   	ret    

00800fe2 <ltostr>:

void
ltostr(long value, char *str)
{
  800fe2:	55                   	push   %ebp
  800fe3:	89 e5                	mov    %esp,%ebp
  800fe5:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  800fe8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  800fef:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  800ff6:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800ffa:	79 13                	jns    80100f <ltostr+0x2d>
	{
		neg = 1;
  800ffc:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  801003:	8b 45 0c             	mov    0xc(%ebp),%eax
  801006:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  801009:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  80100c:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  80100f:	8b 45 08             	mov    0x8(%ebp),%eax
  801012:	b9 0a 00 00 00       	mov    $0xa,%ecx
  801017:	99                   	cltd   
  801018:	f7 f9                	idiv   %ecx
  80101a:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  80101d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801020:	8d 50 01             	lea    0x1(%eax),%edx
  801023:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801026:	89 c2                	mov    %eax,%edx
  801028:	8b 45 0c             	mov    0xc(%ebp),%eax
  80102b:	01 d0                	add    %edx,%eax
  80102d:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801030:	83 c2 30             	add    $0x30,%edx
  801033:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  801035:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801038:	b8 67 66 66 66       	mov    $0x66666667,%eax
  80103d:	f7 e9                	imul   %ecx
  80103f:	c1 fa 02             	sar    $0x2,%edx
  801042:	89 c8                	mov    %ecx,%eax
  801044:	c1 f8 1f             	sar    $0x1f,%eax
  801047:	29 c2                	sub    %eax,%edx
  801049:	89 d0                	mov    %edx,%eax
  80104b:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  80104e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801052:	75 bb                	jne    80100f <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801054:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  80105b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80105e:	48                   	dec    %eax
  80105f:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801062:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801066:	74 3d                	je     8010a5 <ltostr+0xc3>
		start = 1 ;
  801068:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  80106f:	eb 34                	jmp    8010a5 <ltostr+0xc3>
	{
		char tmp = str[start] ;
  801071:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801074:	8b 45 0c             	mov    0xc(%ebp),%eax
  801077:	01 d0                	add    %edx,%eax
  801079:	8a 00                	mov    (%eax),%al
  80107b:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  80107e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801081:	8b 45 0c             	mov    0xc(%ebp),%eax
  801084:	01 c2                	add    %eax,%edx
  801086:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801089:	8b 45 0c             	mov    0xc(%ebp),%eax
  80108c:	01 c8                	add    %ecx,%eax
  80108e:	8a 00                	mov    (%eax),%al
  801090:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801092:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801095:	8b 45 0c             	mov    0xc(%ebp),%eax
  801098:	01 c2                	add    %eax,%edx
  80109a:	8a 45 eb             	mov    -0x15(%ebp),%al
  80109d:	88 02                	mov    %al,(%edx)
		start++ ;
  80109f:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  8010a2:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  8010a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8010a8:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8010ab:	7c c4                	jl     801071 <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  8010ad:	8b 55 f8             	mov    -0x8(%ebp),%edx
  8010b0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010b3:	01 d0                	add    %edx,%eax
  8010b5:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  8010b8:	90                   	nop
  8010b9:	c9                   	leave  
  8010ba:	c3                   	ret    

008010bb <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  8010bb:	55                   	push   %ebp
  8010bc:	89 e5                	mov    %esp,%ebp
  8010be:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  8010c1:	ff 75 08             	pushl  0x8(%ebp)
  8010c4:	e8 c4 f9 ff ff       	call   800a8d <strlen>
  8010c9:	83 c4 04             	add    $0x4,%esp
  8010cc:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  8010cf:	ff 75 0c             	pushl  0xc(%ebp)
  8010d2:	e8 b6 f9 ff ff       	call   800a8d <strlen>
  8010d7:	83 c4 04             	add    $0x4,%esp
  8010da:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  8010dd:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  8010e4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8010eb:	eb 17                	jmp    801104 <strcconcat+0x49>
		final[s] = str1[s] ;
  8010ed:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8010f0:	8b 45 10             	mov    0x10(%ebp),%eax
  8010f3:	01 c2                	add    %eax,%edx
  8010f5:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8010f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8010fb:	01 c8                	add    %ecx,%eax
  8010fd:	8a 00                	mov    (%eax),%al
  8010ff:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  801101:	ff 45 fc             	incl   -0x4(%ebp)
  801104:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801107:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  80110a:	7c e1                	jl     8010ed <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  80110c:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  801113:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  80111a:	eb 1f                	jmp    80113b <strcconcat+0x80>
		final[s++] = str2[i] ;
  80111c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80111f:	8d 50 01             	lea    0x1(%eax),%edx
  801122:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801125:	89 c2                	mov    %eax,%edx
  801127:	8b 45 10             	mov    0x10(%ebp),%eax
  80112a:	01 c2                	add    %eax,%edx
  80112c:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  80112f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801132:	01 c8                	add    %ecx,%eax
  801134:	8a 00                	mov    (%eax),%al
  801136:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801138:	ff 45 f8             	incl   -0x8(%ebp)
  80113b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80113e:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801141:	7c d9                	jl     80111c <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801143:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801146:	8b 45 10             	mov    0x10(%ebp),%eax
  801149:	01 d0                	add    %edx,%eax
  80114b:	c6 00 00             	movb   $0x0,(%eax)
}
  80114e:	90                   	nop
  80114f:	c9                   	leave  
  801150:	c3                   	ret    

00801151 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801151:	55                   	push   %ebp
  801152:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801154:	8b 45 14             	mov    0x14(%ebp),%eax
  801157:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  80115d:	8b 45 14             	mov    0x14(%ebp),%eax
  801160:	8b 00                	mov    (%eax),%eax
  801162:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801169:	8b 45 10             	mov    0x10(%ebp),%eax
  80116c:	01 d0                	add    %edx,%eax
  80116e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801174:	eb 0c                	jmp    801182 <strsplit+0x31>
			*string++ = 0;
  801176:	8b 45 08             	mov    0x8(%ebp),%eax
  801179:	8d 50 01             	lea    0x1(%eax),%edx
  80117c:	89 55 08             	mov    %edx,0x8(%ebp)
  80117f:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801182:	8b 45 08             	mov    0x8(%ebp),%eax
  801185:	8a 00                	mov    (%eax),%al
  801187:	84 c0                	test   %al,%al
  801189:	74 18                	je     8011a3 <strsplit+0x52>
  80118b:	8b 45 08             	mov    0x8(%ebp),%eax
  80118e:	8a 00                	mov    (%eax),%al
  801190:	0f be c0             	movsbl %al,%eax
  801193:	50                   	push   %eax
  801194:	ff 75 0c             	pushl  0xc(%ebp)
  801197:	e8 83 fa ff ff       	call   800c1f <strchr>
  80119c:	83 c4 08             	add    $0x8,%esp
  80119f:	85 c0                	test   %eax,%eax
  8011a1:	75 d3                	jne    801176 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  8011a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8011a6:	8a 00                	mov    (%eax),%al
  8011a8:	84 c0                	test   %al,%al
  8011aa:	74 5a                	je     801206 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  8011ac:	8b 45 14             	mov    0x14(%ebp),%eax
  8011af:	8b 00                	mov    (%eax),%eax
  8011b1:	83 f8 0f             	cmp    $0xf,%eax
  8011b4:	75 07                	jne    8011bd <strsplit+0x6c>
		{
			return 0;
  8011b6:	b8 00 00 00 00       	mov    $0x0,%eax
  8011bb:	eb 66                	jmp    801223 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  8011bd:	8b 45 14             	mov    0x14(%ebp),%eax
  8011c0:	8b 00                	mov    (%eax),%eax
  8011c2:	8d 48 01             	lea    0x1(%eax),%ecx
  8011c5:	8b 55 14             	mov    0x14(%ebp),%edx
  8011c8:	89 0a                	mov    %ecx,(%edx)
  8011ca:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8011d1:	8b 45 10             	mov    0x10(%ebp),%eax
  8011d4:	01 c2                	add    %eax,%edx
  8011d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8011d9:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  8011db:	eb 03                	jmp    8011e0 <strsplit+0x8f>
			string++;
  8011dd:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  8011e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8011e3:	8a 00                	mov    (%eax),%al
  8011e5:	84 c0                	test   %al,%al
  8011e7:	74 8b                	je     801174 <strsplit+0x23>
  8011e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8011ec:	8a 00                	mov    (%eax),%al
  8011ee:	0f be c0             	movsbl %al,%eax
  8011f1:	50                   	push   %eax
  8011f2:	ff 75 0c             	pushl  0xc(%ebp)
  8011f5:	e8 25 fa ff ff       	call   800c1f <strchr>
  8011fa:	83 c4 08             	add    $0x8,%esp
  8011fd:	85 c0                	test   %eax,%eax
  8011ff:	74 dc                	je     8011dd <strsplit+0x8c>
			string++;
	}
  801201:	e9 6e ff ff ff       	jmp    801174 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801206:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801207:	8b 45 14             	mov    0x14(%ebp),%eax
  80120a:	8b 00                	mov    (%eax),%eax
  80120c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801213:	8b 45 10             	mov    0x10(%ebp),%eax
  801216:	01 d0                	add    %edx,%eax
  801218:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  80121e:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801223:	c9                   	leave  
  801224:	c3                   	ret    

00801225 <str2lower>:


char* str2lower(char *dst, const char *src)
{
  801225:	55                   	push   %ebp
  801226:	89 e5                	mov    %esp,%ebp
  801228:	83 ec 10             	sub    $0x10,%esp
	char* ret = dst;
  80122b:	8b 45 08             	mov    0x8(%ebp),%eax
  80122e:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (int i = 0; i < strlen(src); ++i)
  801231:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801238:	eb 4a                	jmp    801284 <str2lower+0x5f>
	{
		dst[i] = src[i] ;
  80123a:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80123d:	8b 45 08             	mov    0x8(%ebp),%eax
  801240:	01 c2                	add    %eax,%edx
  801242:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801245:	8b 45 0c             	mov    0xc(%ebp),%eax
  801248:	01 c8                	add    %ecx,%eax
  80124a:	8a 00                	mov    (%eax),%al
  80124c:	88 02                	mov    %al,(%edx)
		if (src[i] >= 'A' && src[i] <= 'Z')
  80124e:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801251:	8b 45 0c             	mov    0xc(%ebp),%eax
  801254:	01 d0                	add    %edx,%eax
  801256:	8a 00                	mov    (%eax),%al
  801258:	3c 40                	cmp    $0x40,%al
  80125a:	7e 25                	jle    801281 <str2lower+0x5c>
  80125c:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80125f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801262:	01 d0                	add    %edx,%eax
  801264:	8a 00                	mov    (%eax),%al
  801266:	3c 5a                	cmp    $0x5a,%al
  801268:	7f 17                	jg     801281 <str2lower+0x5c>
		{
			dst[i] += 32 ;
  80126a:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80126d:	8b 45 08             	mov    0x8(%ebp),%eax
  801270:	01 d0                	add    %edx,%eax
  801272:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801275:	8b 55 08             	mov    0x8(%ebp),%edx
  801278:	01 ca                	add    %ecx,%edx
  80127a:	8a 12                	mov    (%edx),%dl
  80127c:	83 c2 20             	add    $0x20,%edx
  80127f:	88 10                	mov    %dl,(%eax)


char* str2lower(char *dst, const char *src)
{
	char* ret = dst;
	for (int i = 0; i < strlen(src); ++i)
  801281:	ff 45 fc             	incl   -0x4(%ebp)
  801284:	ff 75 0c             	pushl  0xc(%ebp)
  801287:	e8 01 f8 ff ff       	call   800a8d <strlen>
  80128c:	83 c4 04             	add    $0x4,%esp
  80128f:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801292:	7f a6                	jg     80123a <str2lower+0x15>
		if (src[i] >= 'A' && src[i] <= 'Z')
		{
			dst[i] += 32 ;
		}
	}
	return ret;
  801294:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801297:	c9                   	leave  
  801298:	c3                   	ret    

00801299 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801299:	55                   	push   %ebp
  80129a:	89 e5                	mov    %esp,%ebp
  80129c:	57                   	push   %edi
  80129d:	56                   	push   %esi
  80129e:	53                   	push   %ebx
  80129f:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8012a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8012a5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8012a8:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8012ab:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8012ae:	8b 7d 18             	mov    0x18(%ebp),%edi
  8012b1:	8b 75 1c             	mov    0x1c(%ebp),%esi
  8012b4:	cd 30                	int    $0x30
  8012b6:	89 45 f0             	mov    %eax,-0x10(%ebp)
				"b" (a3),
				"D" (a4),
				"S" (a5)
				: "cc", "memory");

	return ret;
  8012b9:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8012bc:	83 c4 10             	add    $0x10,%esp
  8012bf:	5b                   	pop    %ebx
  8012c0:	5e                   	pop    %esi
  8012c1:	5f                   	pop    %edi
  8012c2:	5d                   	pop    %ebp
  8012c3:	c3                   	ret    

008012c4 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName, int color)
{
  8012c4:	55                   	push   %ebp
  8012c5:	89 e5                	mov    %esp,%ebp
  8012c7:	83 ec 04             	sub    $0x4,%esp
  8012ca:	8b 45 10             	mov    0x10(%ebp),%eax
  8012cd:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, color, 0);
  8012d0:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8012d3:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8012d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8012da:	6a 00                	push   $0x0
  8012dc:	51                   	push   %ecx
  8012dd:	52                   	push   %edx
  8012de:	ff 75 0c             	pushl  0xc(%ebp)
  8012e1:	50                   	push   %eax
  8012e2:	6a 00                	push   $0x0
  8012e4:	e8 b0 ff ff ff       	call   801299 <syscall>
  8012e9:	83 c4 18             	add    $0x18,%esp
}
  8012ec:	90                   	nop
  8012ed:	c9                   	leave  
  8012ee:	c3                   	ret    

008012ef <sys_cgetc>:

int
sys_cgetc(void)
{
  8012ef:	55                   	push   %ebp
  8012f0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  8012f2:	6a 00                	push   $0x0
  8012f4:	6a 00                	push   $0x0
  8012f6:	6a 00                	push   $0x0
  8012f8:	6a 00                	push   $0x0
  8012fa:	6a 00                	push   $0x0
  8012fc:	6a 02                	push   $0x2
  8012fe:	e8 96 ff ff ff       	call   801299 <syscall>
  801303:	83 c4 18             	add    $0x18,%esp
}
  801306:	c9                   	leave  
  801307:	c3                   	ret    

00801308 <sys_lock_cons>:

void sys_lock_cons(void)
{
  801308:	55                   	push   %ebp
  801309:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  80130b:	6a 00                	push   $0x0
  80130d:	6a 00                	push   $0x0
  80130f:	6a 00                	push   $0x0
  801311:	6a 00                	push   $0x0
  801313:	6a 00                	push   $0x0
  801315:	6a 03                	push   $0x3
  801317:	e8 7d ff ff ff       	call   801299 <syscall>
  80131c:	83 c4 18             	add    $0x18,%esp
}
  80131f:	90                   	nop
  801320:	c9                   	leave  
  801321:	c3                   	ret    

00801322 <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  801322:	55                   	push   %ebp
  801323:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  801325:	6a 00                	push   $0x0
  801327:	6a 00                	push   $0x0
  801329:	6a 00                	push   $0x0
  80132b:	6a 00                	push   $0x0
  80132d:	6a 00                	push   $0x0
  80132f:	6a 04                	push   $0x4
  801331:	e8 63 ff ff ff       	call   801299 <syscall>
  801336:	83 c4 18             	add    $0x18,%esp
}
  801339:	90                   	nop
  80133a:	c9                   	leave  
  80133b:	c3                   	ret    

0080133c <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  80133c:	55                   	push   %ebp
  80133d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  80133f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801342:	8b 45 08             	mov    0x8(%ebp),%eax
  801345:	6a 00                	push   $0x0
  801347:	6a 00                	push   $0x0
  801349:	6a 00                	push   $0x0
  80134b:	52                   	push   %edx
  80134c:	50                   	push   %eax
  80134d:	6a 08                	push   $0x8
  80134f:	e8 45 ff ff ff       	call   801299 <syscall>
  801354:	83 c4 18             	add    $0x18,%esp
}
  801357:	c9                   	leave  
  801358:	c3                   	ret    

00801359 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801359:	55                   	push   %ebp
  80135a:	89 e5                	mov    %esp,%ebp
  80135c:	56                   	push   %esi
  80135d:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  80135e:	8b 75 18             	mov    0x18(%ebp),%esi
  801361:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801364:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801367:	8b 55 0c             	mov    0xc(%ebp),%edx
  80136a:	8b 45 08             	mov    0x8(%ebp),%eax
  80136d:	56                   	push   %esi
  80136e:	53                   	push   %ebx
  80136f:	51                   	push   %ecx
  801370:	52                   	push   %edx
  801371:	50                   	push   %eax
  801372:	6a 09                	push   $0x9
  801374:	e8 20 ff ff ff       	call   801299 <syscall>
  801379:	83 c4 18             	add    $0x18,%esp
}
  80137c:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80137f:	5b                   	pop    %ebx
  801380:	5e                   	pop    %esi
  801381:	5d                   	pop    %ebp
  801382:	c3                   	ret    

00801383 <__sys_unmap_frame>:

int __sys_unmap_frame(uint32 va)
{
  801383:	55                   	push   %ebp
  801384:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, va, 0, 0, 0, 0);
  801386:	6a 00                	push   $0x0
  801388:	6a 00                	push   $0x0
  80138a:	6a 00                	push   $0x0
  80138c:	6a 00                	push   $0x0
  80138e:	ff 75 08             	pushl  0x8(%ebp)
  801391:	6a 0a                	push   $0xa
  801393:	e8 01 ff ff ff       	call   801299 <syscall>
  801398:	83 c4 18             	add    $0x18,%esp
}
  80139b:	c9                   	leave  
  80139c:	c3                   	ret    

0080139d <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  80139d:	55                   	push   %ebp
  80139e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  8013a0:	6a 00                	push   $0x0
  8013a2:	6a 00                	push   $0x0
  8013a4:	6a 00                	push   $0x0
  8013a6:	ff 75 0c             	pushl  0xc(%ebp)
  8013a9:	ff 75 08             	pushl  0x8(%ebp)
  8013ac:	6a 0b                	push   $0xb
  8013ae:	e8 e6 fe ff ff       	call   801299 <syscall>
  8013b3:	83 c4 18             	add    $0x18,%esp
}
  8013b6:	c9                   	leave  
  8013b7:	c3                   	ret    

008013b8 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  8013b8:	55                   	push   %ebp
  8013b9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  8013bb:	6a 00                	push   $0x0
  8013bd:	6a 00                	push   $0x0
  8013bf:	6a 00                	push   $0x0
  8013c1:	6a 00                	push   $0x0
  8013c3:	6a 00                	push   $0x0
  8013c5:	6a 0c                	push   $0xc
  8013c7:	e8 cd fe ff ff       	call   801299 <syscall>
  8013cc:	83 c4 18             	add    $0x18,%esp
}
  8013cf:	c9                   	leave  
  8013d0:	c3                   	ret    

008013d1 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  8013d1:	55                   	push   %ebp
  8013d2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  8013d4:	6a 00                	push   $0x0
  8013d6:	6a 00                	push   $0x0
  8013d8:	6a 00                	push   $0x0
  8013da:	6a 00                	push   $0x0
  8013dc:	6a 00                	push   $0x0
  8013de:	6a 0d                	push   $0xd
  8013e0:	e8 b4 fe ff ff       	call   801299 <syscall>
  8013e5:	83 c4 18             	add    $0x18,%esp
}
  8013e8:	c9                   	leave  
  8013e9:	c3                   	ret    

008013ea <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  8013ea:	55                   	push   %ebp
  8013eb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  8013ed:	6a 00                	push   $0x0
  8013ef:	6a 00                	push   $0x0
  8013f1:	6a 00                	push   $0x0
  8013f3:	6a 00                	push   $0x0
  8013f5:	6a 00                	push   $0x0
  8013f7:	6a 0e                	push   $0xe
  8013f9:	e8 9b fe ff ff       	call   801299 <syscall>
  8013fe:	83 c4 18             	add    $0x18,%esp
}
  801401:	c9                   	leave  
  801402:	c3                   	ret    

00801403 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801403:	55                   	push   %ebp
  801404:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801406:	6a 00                	push   $0x0
  801408:	6a 00                	push   $0x0
  80140a:	6a 00                	push   $0x0
  80140c:	6a 00                	push   $0x0
  80140e:	6a 00                	push   $0x0
  801410:	6a 0f                	push   $0xf
  801412:	e8 82 fe ff ff       	call   801299 <syscall>
  801417:	83 c4 18             	add    $0x18,%esp
}
  80141a:	c9                   	leave  
  80141b:	c3                   	ret    

0080141c <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  80141c:	55                   	push   %ebp
  80141d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  80141f:	6a 00                	push   $0x0
  801421:	6a 00                	push   $0x0
  801423:	6a 00                	push   $0x0
  801425:	6a 00                	push   $0x0
  801427:	ff 75 08             	pushl  0x8(%ebp)
  80142a:	6a 10                	push   $0x10
  80142c:	e8 68 fe ff ff       	call   801299 <syscall>
  801431:	83 c4 18             	add    $0x18,%esp
}
  801434:	c9                   	leave  
  801435:	c3                   	ret    

00801436 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801436:	55                   	push   %ebp
  801437:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801439:	6a 00                	push   $0x0
  80143b:	6a 00                	push   $0x0
  80143d:	6a 00                	push   $0x0
  80143f:	6a 00                	push   $0x0
  801441:	6a 00                	push   $0x0
  801443:	6a 11                	push   $0x11
  801445:	e8 4f fe ff ff       	call   801299 <syscall>
  80144a:	83 c4 18             	add    $0x18,%esp
}
  80144d:	90                   	nop
  80144e:	c9                   	leave  
  80144f:	c3                   	ret    

00801450 <sys_cputc>:

void
sys_cputc(const char c)
{
  801450:	55                   	push   %ebp
  801451:	89 e5                	mov    %esp,%ebp
  801453:	83 ec 04             	sub    $0x4,%esp
  801456:	8b 45 08             	mov    0x8(%ebp),%eax
  801459:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  80145c:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801460:	6a 00                	push   $0x0
  801462:	6a 00                	push   $0x0
  801464:	6a 00                	push   $0x0
  801466:	6a 00                	push   $0x0
  801468:	50                   	push   %eax
  801469:	6a 01                	push   $0x1
  80146b:	e8 29 fe ff ff       	call   801299 <syscall>
  801470:	83 c4 18             	add    $0x18,%esp
}
  801473:	90                   	nop
  801474:	c9                   	leave  
  801475:	c3                   	ret    

00801476 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801476:	55                   	push   %ebp
  801477:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801479:	6a 00                	push   $0x0
  80147b:	6a 00                	push   $0x0
  80147d:	6a 00                	push   $0x0
  80147f:	6a 00                	push   $0x0
  801481:	6a 00                	push   $0x0
  801483:	6a 14                	push   $0x14
  801485:	e8 0f fe ff ff       	call   801299 <syscall>
  80148a:	83 c4 18             	add    $0x18,%esp
}
  80148d:	90                   	nop
  80148e:	c9                   	leave  
  80148f:	c3                   	ret    

00801490 <sys_create_shared_object>:

int sys_create_shared_object(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801490:	55                   	push   %ebp
  801491:	89 e5                	mov    %esp,%ebp
  801493:	83 ec 04             	sub    $0x4,%esp
  801496:	8b 45 10             	mov    0x10(%ebp),%eax
  801499:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  80149c:	8b 4d 14             	mov    0x14(%ebp),%ecx
  80149f:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8014a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8014a6:	6a 00                	push   $0x0
  8014a8:	51                   	push   %ecx
  8014a9:	52                   	push   %edx
  8014aa:	ff 75 0c             	pushl  0xc(%ebp)
  8014ad:	50                   	push   %eax
  8014ae:	6a 15                	push   $0x15
  8014b0:	e8 e4 fd ff ff       	call   801299 <syscall>
  8014b5:	83 c4 18             	add    $0x18,%esp
}
  8014b8:	c9                   	leave  
  8014b9:	c3                   	ret    

008014ba <sys_size_of_shared_object>:

//2017:
int sys_size_of_shared_object(int32 ownerID, char* shareName)
{
  8014ba:	55                   	push   %ebp
  8014bb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  8014bd:	8b 55 0c             	mov    0xc(%ebp),%edx
  8014c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8014c3:	6a 00                	push   $0x0
  8014c5:	6a 00                	push   $0x0
  8014c7:	6a 00                	push   $0x0
  8014c9:	52                   	push   %edx
  8014ca:	50                   	push   %eax
  8014cb:	6a 16                	push   $0x16
  8014cd:	e8 c7 fd ff ff       	call   801299 <syscall>
  8014d2:	83 c4 18             	add    $0x18,%esp
}
  8014d5:	c9                   	leave  
  8014d6:	c3                   	ret    

008014d7 <sys_get_shared_object>:
//==========

int sys_get_shared_object(int32 ownerID, char* shareName, void* virtual_address)
{
  8014d7:	55                   	push   %ebp
  8014d8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  8014da:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8014dd:	8b 55 0c             	mov    0xc(%ebp),%edx
  8014e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8014e3:	6a 00                	push   $0x0
  8014e5:	6a 00                	push   $0x0
  8014e7:	51                   	push   %ecx
  8014e8:	52                   	push   %edx
  8014e9:	50                   	push   %eax
  8014ea:	6a 17                	push   $0x17
  8014ec:	e8 a8 fd ff ff       	call   801299 <syscall>
  8014f1:	83 c4 18             	add    $0x18,%esp
}
  8014f4:	c9                   	leave  
  8014f5:	c3                   	ret    

008014f6 <sys_delete_shared_object>:

int sys_delete_shared_object(int32 sharedObjectID, void *startVA)
{
  8014f6:	55                   	push   %ebp
  8014f7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  8014f9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8014fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8014ff:	6a 00                	push   $0x0
  801501:	6a 00                	push   $0x0
  801503:	6a 00                	push   $0x0
  801505:	52                   	push   %edx
  801506:	50                   	push   %eax
  801507:	6a 18                	push   $0x18
  801509:	e8 8b fd ff ff       	call   801299 <syscall>
  80150e:	83 c4 18             	add    $0x18,%esp
}
  801511:	c9                   	leave  
  801512:	c3                   	ret    

00801513 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801513:	55                   	push   %ebp
  801514:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801516:	8b 45 08             	mov    0x8(%ebp),%eax
  801519:	6a 00                	push   $0x0
  80151b:	ff 75 14             	pushl  0x14(%ebp)
  80151e:	ff 75 10             	pushl  0x10(%ebp)
  801521:	ff 75 0c             	pushl  0xc(%ebp)
  801524:	50                   	push   %eax
  801525:	6a 19                	push   $0x19
  801527:	e8 6d fd ff ff       	call   801299 <syscall>
  80152c:	83 c4 18             	add    $0x18,%esp
}
  80152f:	c9                   	leave  
  801530:	c3                   	ret    

00801531 <sys_run_env>:

void sys_run_env(int32 envId)
{
  801531:	55                   	push   %ebp
  801532:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801534:	8b 45 08             	mov    0x8(%ebp),%eax
  801537:	6a 00                	push   $0x0
  801539:	6a 00                	push   $0x0
  80153b:	6a 00                	push   $0x0
  80153d:	6a 00                	push   $0x0
  80153f:	50                   	push   %eax
  801540:	6a 1a                	push   $0x1a
  801542:	e8 52 fd ff ff       	call   801299 <syscall>
  801547:	83 c4 18             	add    $0x18,%esp
}
  80154a:	90                   	nop
  80154b:	c9                   	leave  
  80154c:	c3                   	ret    

0080154d <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  80154d:	55                   	push   %ebp
  80154e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801550:	8b 45 08             	mov    0x8(%ebp),%eax
  801553:	6a 00                	push   $0x0
  801555:	6a 00                	push   $0x0
  801557:	6a 00                	push   $0x0
  801559:	6a 00                	push   $0x0
  80155b:	50                   	push   %eax
  80155c:	6a 1b                	push   $0x1b
  80155e:	e8 36 fd ff ff       	call   801299 <syscall>
  801563:	83 c4 18             	add    $0x18,%esp
}
  801566:	c9                   	leave  
  801567:	c3                   	ret    

00801568 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801568:	55                   	push   %ebp
  801569:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  80156b:	6a 00                	push   $0x0
  80156d:	6a 00                	push   $0x0
  80156f:	6a 00                	push   $0x0
  801571:	6a 00                	push   $0x0
  801573:	6a 00                	push   $0x0
  801575:	6a 05                	push   $0x5
  801577:	e8 1d fd ff ff       	call   801299 <syscall>
  80157c:	83 c4 18             	add    $0x18,%esp
}
  80157f:	c9                   	leave  
  801580:	c3                   	ret    

00801581 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801581:	55                   	push   %ebp
  801582:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801584:	6a 00                	push   $0x0
  801586:	6a 00                	push   $0x0
  801588:	6a 00                	push   $0x0
  80158a:	6a 00                	push   $0x0
  80158c:	6a 00                	push   $0x0
  80158e:	6a 06                	push   $0x6
  801590:	e8 04 fd ff ff       	call   801299 <syscall>
  801595:	83 c4 18             	add    $0x18,%esp
}
  801598:	c9                   	leave  
  801599:	c3                   	ret    

0080159a <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  80159a:	55                   	push   %ebp
  80159b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  80159d:	6a 00                	push   $0x0
  80159f:	6a 00                	push   $0x0
  8015a1:	6a 00                	push   $0x0
  8015a3:	6a 00                	push   $0x0
  8015a5:	6a 00                	push   $0x0
  8015a7:	6a 07                	push   $0x7
  8015a9:	e8 eb fc ff ff       	call   801299 <syscall>
  8015ae:	83 c4 18             	add    $0x18,%esp
}
  8015b1:	c9                   	leave  
  8015b2:	c3                   	ret    

008015b3 <sys_exit_env>:


void sys_exit_env(void)
{
  8015b3:	55                   	push   %ebp
  8015b4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  8015b6:	6a 00                	push   $0x0
  8015b8:	6a 00                	push   $0x0
  8015ba:	6a 00                	push   $0x0
  8015bc:	6a 00                	push   $0x0
  8015be:	6a 00                	push   $0x0
  8015c0:	6a 1c                	push   $0x1c
  8015c2:	e8 d2 fc ff ff       	call   801299 <syscall>
  8015c7:	83 c4 18             	add    $0x18,%esp
}
  8015ca:	90                   	nop
  8015cb:	c9                   	leave  
  8015cc:	c3                   	ret    

008015cd <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  8015cd:	55                   	push   %ebp
  8015ce:	89 e5                	mov    %esp,%ebp
  8015d0:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  8015d3:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8015d6:	8d 50 04             	lea    0x4(%eax),%edx
  8015d9:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8015dc:	6a 00                	push   $0x0
  8015de:	6a 00                	push   $0x0
  8015e0:	6a 00                	push   $0x0
  8015e2:	52                   	push   %edx
  8015e3:	50                   	push   %eax
  8015e4:	6a 1d                	push   $0x1d
  8015e6:	e8 ae fc ff ff       	call   801299 <syscall>
  8015eb:	83 c4 18             	add    $0x18,%esp
	return result;
  8015ee:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8015f1:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8015f4:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8015f7:	89 01                	mov    %eax,(%ecx)
  8015f9:	89 51 04             	mov    %edx,0x4(%ecx)
}
  8015fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8015ff:	c9                   	leave  
  801600:	c2 04 00             	ret    $0x4

00801603 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801603:	55                   	push   %ebp
  801604:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801606:	6a 00                	push   $0x0
  801608:	6a 00                	push   $0x0
  80160a:	ff 75 10             	pushl  0x10(%ebp)
  80160d:	ff 75 0c             	pushl  0xc(%ebp)
  801610:	ff 75 08             	pushl  0x8(%ebp)
  801613:	6a 13                	push   $0x13
  801615:	e8 7f fc ff ff       	call   801299 <syscall>
  80161a:	83 c4 18             	add    $0x18,%esp
	return ;
  80161d:	90                   	nop
}
  80161e:	c9                   	leave  
  80161f:	c3                   	ret    

00801620 <sys_rcr2>:
uint32 sys_rcr2()
{
  801620:	55                   	push   %ebp
  801621:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801623:	6a 00                	push   $0x0
  801625:	6a 00                	push   $0x0
  801627:	6a 00                	push   $0x0
  801629:	6a 00                	push   $0x0
  80162b:	6a 00                	push   $0x0
  80162d:	6a 1e                	push   $0x1e
  80162f:	e8 65 fc ff ff       	call   801299 <syscall>
  801634:	83 c4 18             	add    $0x18,%esp
}
  801637:	c9                   	leave  
  801638:	c3                   	ret    

00801639 <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  801639:	55                   	push   %ebp
  80163a:	89 e5                	mov    %esp,%ebp
  80163c:	83 ec 04             	sub    $0x4,%esp
  80163f:	8b 45 08             	mov    0x8(%ebp),%eax
  801642:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801645:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801649:	6a 00                	push   $0x0
  80164b:	6a 00                	push   $0x0
  80164d:	6a 00                	push   $0x0
  80164f:	6a 00                	push   $0x0
  801651:	50                   	push   %eax
  801652:	6a 1f                	push   $0x1f
  801654:	e8 40 fc ff ff       	call   801299 <syscall>
  801659:	83 c4 18             	add    $0x18,%esp
	return ;
  80165c:	90                   	nop
}
  80165d:	c9                   	leave  
  80165e:	c3                   	ret    

0080165f <rsttst>:
void rsttst()
{
  80165f:	55                   	push   %ebp
  801660:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801662:	6a 00                	push   $0x0
  801664:	6a 00                	push   $0x0
  801666:	6a 00                	push   $0x0
  801668:	6a 00                	push   $0x0
  80166a:	6a 00                	push   $0x0
  80166c:	6a 21                	push   $0x21
  80166e:	e8 26 fc ff ff       	call   801299 <syscall>
  801673:	83 c4 18             	add    $0x18,%esp
	return ;
  801676:	90                   	nop
}
  801677:	c9                   	leave  
  801678:	c3                   	ret    

00801679 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801679:	55                   	push   %ebp
  80167a:	89 e5                	mov    %esp,%ebp
  80167c:	83 ec 04             	sub    $0x4,%esp
  80167f:	8b 45 14             	mov    0x14(%ebp),%eax
  801682:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801685:	8b 55 18             	mov    0x18(%ebp),%edx
  801688:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  80168c:	52                   	push   %edx
  80168d:	50                   	push   %eax
  80168e:	ff 75 10             	pushl  0x10(%ebp)
  801691:	ff 75 0c             	pushl  0xc(%ebp)
  801694:	ff 75 08             	pushl  0x8(%ebp)
  801697:	6a 20                	push   $0x20
  801699:	e8 fb fb ff ff       	call   801299 <syscall>
  80169e:	83 c4 18             	add    $0x18,%esp
	return ;
  8016a1:	90                   	nop
}
  8016a2:	c9                   	leave  
  8016a3:	c3                   	ret    

008016a4 <chktst>:
void chktst(uint32 n)
{
  8016a4:	55                   	push   %ebp
  8016a5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  8016a7:	6a 00                	push   $0x0
  8016a9:	6a 00                	push   $0x0
  8016ab:	6a 00                	push   $0x0
  8016ad:	6a 00                	push   $0x0
  8016af:	ff 75 08             	pushl  0x8(%ebp)
  8016b2:	6a 22                	push   $0x22
  8016b4:	e8 e0 fb ff ff       	call   801299 <syscall>
  8016b9:	83 c4 18             	add    $0x18,%esp
	return ;
  8016bc:	90                   	nop
}
  8016bd:	c9                   	leave  
  8016be:	c3                   	ret    

008016bf <inctst>:

void inctst()
{
  8016bf:	55                   	push   %ebp
  8016c0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  8016c2:	6a 00                	push   $0x0
  8016c4:	6a 00                	push   $0x0
  8016c6:	6a 00                	push   $0x0
  8016c8:	6a 00                	push   $0x0
  8016ca:	6a 00                	push   $0x0
  8016cc:	6a 23                	push   $0x23
  8016ce:	e8 c6 fb ff ff       	call   801299 <syscall>
  8016d3:	83 c4 18             	add    $0x18,%esp
	return ;
  8016d6:	90                   	nop
}
  8016d7:	c9                   	leave  
  8016d8:	c3                   	ret    

008016d9 <gettst>:
uint32 gettst()
{
  8016d9:	55                   	push   %ebp
  8016da:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  8016dc:	6a 00                	push   $0x0
  8016de:	6a 00                	push   $0x0
  8016e0:	6a 00                	push   $0x0
  8016e2:	6a 00                	push   $0x0
  8016e4:	6a 00                	push   $0x0
  8016e6:	6a 24                	push   $0x24
  8016e8:	e8 ac fb ff ff       	call   801299 <syscall>
  8016ed:	83 c4 18             	add    $0x18,%esp
}
  8016f0:	c9                   	leave  
  8016f1:	c3                   	ret    

008016f2 <sys_get_uheap_strategy>:

/*2025*/
uint32 sys_get_uheap_strategy()
{
  8016f2:	55                   	push   %ebp
  8016f3:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8016f5:	6a 00                	push   $0x0
  8016f7:	6a 00                	push   $0x0
  8016f9:	6a 00                	push   $0x0
  8016fb:	6a 00                	push   $0x0
  8016fd:	6a 00                	push   $0x0
  8016ff:	6a 25                	push   $0x25
  801701:	e8 93 fb ff ff       	call   801299 <syscall>
  801706:	83 c4 18             	add    $0x18,%esp
  801709:	a3 60 b0 81 00       	mov    %eax,0x81b060
	return uheapPlaceStrategy ;
  80170e:	a1 60 b0 81 00       	mov    0x81b060,%eax
}
  801713:	c9                   	leave  
  801714:	c3                   	ret    

00801715 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801715:	55                   	push   %ebp
  801716:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = heapStrategy;
  801718:	8b 45 08             	mov    0x8(%ebp),%eax
  80171b:	a3 60 b0 81 00       	mov    %eax,0x81b060
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801720:	6a 00                	push   $0x0
  801722:	6a 00                	push   $0x0
  801724:	6a 00                	push   $0x0
  801726:	6a 00                	push   $0x0
  801728:	ff 75 08             	pushl  0x8(%ebp)
  80172b:	6a 26                	push   $0x26
  80172d:	e8 67 fb ff ff       	call   801299 <syscall>
  801732:	83 c4 18             	add    $0x18,%esp
	return ;
  801735:	90                   	nop
}
  801736:	c9                   	leave  
  801737:	c3                   	ret    

00801738 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801738:	55                   	push   %ebp
  801739:	89 e5                	mov    %esp,%ebp
  80173b:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  80173c:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80173f:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801742:	8b 55 0c             	mov    0xc(%ebp),%edx
  801745:	8b 45 08             	mov    0x8(%ebp),%eax
  801748:	6a 00                	push   $0x0
  80174a:	53                   	push   %ebx
  80174b:	51                   	push   %ecx
  80174c:	52                   	push   %edx
  80174d:	50                   	push   %eax
  80174e:	6a 27                	push   $0x27
  801750:	e8 44 fb ff ff       	call   801299 <syscall>
  801755:	83 c4 18             	add    $0x18,%esp
}
  801758:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80175b:	c9                   	leave  
  80175c:	c3                   	ret    

0080175d <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  80175d:	55                   	push   %ebp
  80175e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801760:	8b 55 0c             	mov    0xc(%ebp),%edx
  801763:	8b 45 08             	mov    0x8(%ebp),%eax
  801766:	6a 00                	push   $0x0
  801768:	6a 00                	push   $0x0
  80176a:	6a 00                	push   $0x0
  80176c:	52                   	push   %edx
  80176d:	50                   	push   %eax
  80176e:	6a 28                	push   $0x28
  801770:	e8 24 fb ff ff       	call   801299 <syscall>
  801775:	83 c4 18             	add    $0x18,%esp
}
  801778:	c9                   	leave  
  801779:	c3                   	ret    

0080177a <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  80177a:	55                   	push   %ebp
  80177b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  80177d:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801780:	8b 55 0c             	mov    0xc(%ebp),%edx
  801783:	8b 45 08             	mov    0x8(%ebp),%eax
  801786:	6a 00                	push   $0x0
  801788:	51                   	push   %ecx
  801789:	ff 75 10             	pushl  0x10(%ebp)
  80178c:	52                   	push   %edx
  80178d:	50                   	push   %eax
  80178e:	6a 29                	push   $0x29
  801790:	e8 04 fb ff ff       	call   801299 <syscall>
  801795:	83 c4 18             	add    $0x18,%esp
}
  801798:	c9                   	leave  
  801799:	c3                   	ret    

0080179a <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  80179a:	55                   	push   %ebp
  80179b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  80179d:	6a 00                	push   $0x0
  80179f:	6a 00                	push   $0x0
  8017a1:	ff 75 10             	pushl  0x10(%ebp)
  8017a4:	ff 75 0c             	pushl  0xc(%ebp)
  8017a7:	ff 75 08             	pushl  0x8(%ebp)
  8017aa:	6a 12                	push   $0x12
  8017ac:	e8 e8 fa ff ff       	call   801299 <syscall>
  8017b1:	83 c4 18             	add    $0x18,%esp
	return ;
  8017b4:	90                   	nop
}
  8017b5:	c9                   	leave  
  8017b6:	c3                   	ret    

008017b7 <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  8017b7:	55                   	push   %ebp
  8017b8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  8017ba:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8017c0:	6a 00                	push   $0x0
  8017c2:	6a 00                	push   $0x0
  8017c4:	6a 00                	push   $0x0
  8017c6:	52                   	push   %edx
  8017c7:	50                   	push   %eax
  8017c8:	6a 2a                	push   $0x2a
  8017ca:	e8 ca fa ff ff       	call   801299 <syscall>
  8017cf:	83 c4 18             	add    $0x18,%esp
	return;
  8017d2:	90                   	nop
}
  8017d3:	c9                   	leave  
  8017d4:	c3                   	ret    

008017d5 <sys_get_optimal_num_faults>:
/*2025*/
int sys_get_optimal_num_faults()
{
  8017d5:	55                   	push   %ebp
  8017d6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_optimal_num_faults, 0, 0, 0, 0, 0);
  8017d8:	6a 00                	push   $0x0
  8017da:	6a 00                	push   $0x0
  8017dc:	6a 00                	push   $0x0
  8017de:	6a 00                	push   $0x0
  8017e0:	6a 00                	push   $0x0
  8017e2:	6a 2b                	push   $0x2b
  8017e4:	e8 b0 fa ff ff       	call   801299 <syscall>
  8017e9:	83 c4 18             	add    $0x18,%esp
}
  8017ec:	c9                   	leave  
  8017ed:	c3                   	ret    

008017ee <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  8017ee:	55                   	push   %ebp
  8017ef:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  8017f1:	6a 00                	push   $0x0
  8017f3:	6a 00                	push   $0x0
  8017f5:	6a 00                	push   $0x0
  8017f7:	ff 75 0c             	pushl  0xc(%ebp)
  8017fa:	ff 75 08             	pushl  0x8(%ebp)
  8017fd:	6a 2d                	push   $0x2d
  8017ff:	e8 95 fa ff ff       	call   801299 <syscall>
  801804:	83 c4 18             	add    $0x18,%esp
	return;
  801807:	90                   	nop
}
  801808:	c9                   	leave  
  801809:	c3                   	ret    

0080180a <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  80180a:	55                   	push   %ebp
  80180b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  80180d:	6a 00                	push   $0x0
  80180f:	6a 00                	push   $0x0
  801811:	6a 00                	push   $0x0
  801813:	ff 75 0c             	pushl  0xc(%ebp)
  801816:	ff 75 08             	pushl  0x8(%ebp)
  801819:	6a 2c                	push   $0x2c
  80181b:	e8 79 fa ff ff       	call   801299 <syscall>
  801820:	83 c4 18             	add    $0x18,%esp
	return ;
  801823:	90                   	nop
}
  801824:	c9                   	leave  
  801825:	c3                   	ret    

00801826 <sys_env_set_priority>:


void sys_env_set_priority(int32 envID, int priority)
{
  801826:	55                   	push   %ebp
  801827:	89 e5                	mov    %esp,%ebp
  801829:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.IM#4] CPU SCHEDULING - #1 System Calls - Add suitable code here
	//Your code is here
	//Comment the following line
	panic("sys_env_set_priority() is not implemented yet...!!");
  80182c:	83 ec 04             	sub    $0x4,%esp
  80182f:	68 08 22 80 00       	push   $0x802208
  801834:	68 25 01 00 00       	push   $0x125
  801839:	68 3b 22 80 00       	push   $0x80223b
  80183e:	e8 00 00 00 00       	call   801843 <_panic>

00801843 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  801843:	55                   	push   %ebp
  801844:	89 e5                	mov    %esp,%ebp
  801846:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  801849:	8d 45 10             	lea    0x10(%ebp),%eax
  80184c:	83 c0 04             	add    $0x4,%eax
  80184f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  801852:	a1 1c b1 81 00       	mov    0x81b11c,%eax
  801857:	85 c0                	test   %eax,%eax
  801859:	74 16                	je     801871 <_panic+0x2e>
		cprintf("%s: ", argv0);
  80185b:	a1 1c b1 81 00       	mov    0x81b11c,%eax
  801860:	83 ec 08             	sub    $0x8,%esp
  801863:	50                   	push   %eax
  801864:	68 4c 22 80 00       	push   $0x80224c
  801869:	e8 46 eb ff ff       	call   8003b4 <cprintf>
  80186e:	83 c4 10             	add    $0x10,%esp
	cprintf_colored(TEXT_PANIC_CLR, "user [EVAL_FINAL]panic in %s at %s:%d: ", binaryname, file, line);
  801871:	a1 04 30 80 00       	mov    0x803004,%eax
  801876:	83 ec 0c             	sub    $0xc,%esp
  801879:	ff 75 0c             	pushl  0xc(%ebp)
  80187c:	ff 75 08             	pushl  0x8(%ebp)
  80187f:	50                   	push   %eax
  801880:	68 54 22 80 00       	push   $0x802254
  801885:	6a 74                	push   $0x74
  801887:	e8 55 eb ff ff       	call   8003e1 <cprintf_colored>
  80188c:	83 c4 20             	add    $0x20,%esp
	vcprintf(fmt, ap);
  80188f:	8b 45 10             	mov    0x10(%ebp),%eax
  801892:	83 ec 08             	sub    $0x8,%esp
  801895:	ff 75 f4             	pushl  -0xc(%ebp)
  801898:	50                   	push   %eax
  801899:	e8 a7 ea ff ff       	call   800345 <vcprintf>
  80189e:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  8018a1:	83 ec 08             	sub    $0x8,%esp
  8018a4:	6a 00                	push   $0x0
  8018a6:	68 7c 22 80 00       	push   $0x80227c
  8018ab:	e8 95 ea ff ff       	call   800345 <vcprintf>
  8018b0:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  8018b3:	e8 0e ea ff ff       	call   8002c6 <exit>

	// should not return here
	while (1) ;
  8018b8:	eb fe                	jmp    8018b8 <_panic+0x75>

008018ba <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  8018ba:	55                   	push   %ebp
  8018bb:	89 e5                	mov    %esp,%ebp
  8018bd:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  8018c0:	a1 20 30 80 00       	mov    0x803020,%eax
  8018c5:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  8018cb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018ce:	39 c2                	cmp    %eax,%edx
  8018d0:	74 14                	je     8018e6 <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  8018d2:	83 ec 04             	sub    $0x4,%esp
  8018d5:	68 80 22 80 00       	push   $0x802280
  8018da:	6a 26                	push   $0x26
  8018dc:	68 cc 22 80 00       	push   $0x8022cc
  8018e1:	e8 5d ff ff ff       	call   801843 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  8018e6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  8018ed:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8018f4:	e9 c5 00 00 00       	jmp    8019be <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  8018f9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8018fc:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801903:	8b 45 08             	mov    0x8(%ebp),%eax
  801906:	01 d0                	add    %edx,%eax
  801908:	8b 00                	mov    (%eax),%eax
  80190a:	85 c0                	test   %eax,%eax
  80190c:	75 08                	jne    801916 <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  80190e:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  801911:	e9 a5 00 00 00       	jmp    8019bb <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  801916:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80191d:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  801924:	eb 69                	jmp    80198f <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  801926:	a1 20 30 80 00       	mov    0x803020,%eax
  80192b:	8b 88 38 da 01 00    	mov    0x1da38(%eax),%ecx
  801931:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801934:	89 d0                	mov    %edx,%eax
  801936:	01 c0                	add    %eax,%eax
  801938:	01 d0                	add    %edx,%eax
  80193a:	c1 e0 03             	shl    $0x3,%eax
  80193d:	01 c8                	add    %ecx,%eax
  80193f:	8a 40 04             	mov    0x4(%eax),%al
  801942:	84 c0                	test   %al,%al
  801944:	75 46                	jne    80198c <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  801946:	a1 20 30 80 00       	mov    0x803020,%eax
  80194b:	8b 88 38 da 01 00    	mov    0x1da38(%eax),%ecx
  801951:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801954:	89 d0                	mov    %edx,%eax
  801956:	01 c0                	add    %eax,%eax
  801958:	01 d0                	add    %edx,%eax
  80195a:	c1 e0 03             	shl    $0x3,%eax
  80195d:	01 c8                	add    %ecx,%eax
  80195f:	8b 00                	mov    (%eax),%eax
  801961:	89 45 dc             	mov    %eax,-0x24(%ebp)
  801964:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801967:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80196c:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  80196e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801971:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  801978:	8b 45 08             	mov    0x8(%ebp),%eax
  80197b:	01 c8                	add    %ecx,%eax
  80197d:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  80197f:	39 c2                	cmp    %eax,%edx
  801981:	75 09                	jne    80198c <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  801983:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  80198a:	eb 15                	jmp    8019a1 <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80198c:	ff 45 e8             	incl   -0x18(%ebp)
  80198f:	a1 20 30 80 00       	mov    0x803020,%eax
  801994:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  80199a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80199d:	39 c2                	cmp    %eax,%edx
  80199f:	77 85                	ja     801926 <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  8019a1:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8019a5:	75 14                	jne    8019bb <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  8019a7:	83 ec 04             	sub    $0x4,%esp
  8019aa:	68 d8 22 80 00       	push   $0x8022d8
  8019af:	6a 3a                	push   $0x3a
  8019b1:	68 cc 22 80 00       	push   $0x8022cc
  8019b6:	e8 88 fe ff ff       	call   801843 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  8019bb:	ff 45 f0             	incl   -0x10(%ebp)
  8019be:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8019c1:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8019c4:	0f 8c 2f ff ff ff    	jl     8018f9 <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  8019ca:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8019d1:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  8019d8:	eb 26                	jmp    801a00 <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  8019da:	a1 20 30 80 00       	mov    0x803020,%eax
  8019df:	8b 88 38 da 01 00    	mov    0x1da38(%eax),%ecx
  8019e5:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8019e8:	89 d0                	mov    %edx,%eax
  8019ea:	01 c0                	add    %eax,%eax
  8019ec:	01 d0                	add    %edx,%eax
  8019ee:	c1 e0 03             	shl    $0x3,%eax
  8019f1:	01 c8                	add    %ecx,%eax
  8019f3:	8a 40 04             	mov    0x4(%eax),%al
  8019f6:	3c 01                	cmp    $0x1,%al
  8019f8:	75 03                	jne    8019fd <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  8019fa:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8019fd:	ff 45 e0             	incl   -0x20(%ebp)
  801a00:	a1 20 30 80 00       	mov    0x803020,%eax
  801a05:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  801a0b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801a0e:	39 c2                	cmp    %eax,%edx
  801a10:	77 c8                	ja     8019da <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  801a12:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a15:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  801a18:	74 14                	je     801a2e <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  801a1a:	83 ec 04             	sub    $0x4,%esp
  801a1d:	68 2c 23 80 00       	push   $0x80232c
  801a22:	6a 44                	push   $0x44
  801a24:	68 cc 22 80 00       	push   $0x8022cc
  801a29:	e8 15 fe ff ff       	call   801843 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  801a2e:	90                   	nop
  801a2f:	c9                   	leave  
  801a30:	c3                   	ret    
  801a31:	66 90                	xchg   %ax,%ax
  801a33:	90                   	nop

00801a34 <__udivdi3>:
  801a34:	55                   	push   %ebp
  801a35:	57                   	push   %edi
  801a36:	56                   	push   %esi
  801a37:	53                   	push   %ebx
  801a38:	83 ec 1c             	sub    $0x1c,%esp
  801a3b:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  801a3f:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  801a43:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801a47:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801a4b:	89 ca                	mov    %ecx,%edx
  801a4d:	89 f8                	mov    %edi,%eax
  801a4f:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  801a53:	85 f6                	test   %esi,%esi
  801a55:	75 2d                	jne    801a84 <__udivdi3+0x50>
  801a57:	39 cf                	cmp    %ecx,%edi
  801a59:	77 65                	ja     801ac0 <__udivdi3+0x8c>
  801a5b:	89 fd                	mov    %edi,%ebp
  801a5d:	85 ff                	test   %edi,%edi
  801a5f:	75 0b                	jne    801a6c <__udivdi3+0x38>
  801a61:	b8 01 00 00 00       	mov    $0x1,%eax
  801a66:	31 d2                	xor    %edx,%edx
  801a68:	f7 f7                	div    %edi
  801a6a:	89 c5                	mov    %eax,%ebp
  801a6c:	31 d2                	xor    %edx,%edx
  801a6e:	89 c8                	mov    %ecx,%eax
  801a70:	f7 f5                	div    %ebp
  801a72:	89 c1                	mov    %eax,%ecx
  801a74:	89 d8                	mov    %ebx,%eax
  801a76:	f7 f5                	div    %ebp
  801a78:	89 cf                	mov    %ecx,%edi
  801a7a:	89 fa                	mov    %edi,%edx
  801a7c:	83 c4 1c             	add    $0x1c,%esp
  801a7f:	5b                   	pop    %ebx
  801a80:	5e                   	pop    %esi
  801a81:	5f                   	pop    %edi
  801a82:	5d                   	pop    %ebp
  801a83:	c3                   	ret    
  801a84:	39 ce                	cmp    %ecx,%esi
  801a86:	77 28                	ja     801ab0 <__udivdi3+0x7c>
  801a88:	0f bd fe             	bsr    %esi,%edi
  801a8b:	83 f7 1f             	xor    $0x1f,%edi
  801a8e:	75 40                	jne    801ad0 <__udivdi3+0x9c>
  801a90:	39 ce                	cmp    %ecx,%esi
  801a92:	72 0a                	jb     801a9e <__udivdi3+0x6a>
  801a94:	3b 44 24 08          	cmp    0x8(%esp),%eax
  801a98:	0f 87 9e 00 00 00    	ja     801b3c <__udivdi3+0x108>
  801a9e:	b8 01 00 00 00       	mov    $0x1,%eax
  801aa3:	89 fa                	mov    %edi,%edx
  801aa5:	83 c4 1c             	add    $0x1c,%esp
  801aa8:	5b                   	pop    %ebx
  801aa9:	5e                   	pop    %esi
  801aaa:	5f                   	pop    %edi
  801aab:	5d                   	pop    %ebp
  801aac:	c3                   	ret    
  801aad:	8d 76 00             	lea    0x0(%esi),%esi
  801ab0:	31 ff                	xor    %edi,%edi
  801ab2:	31 c0                	xor    %eax,%eax
  801ab4:	89 fa                	mov    %edi,%edx
  801ab6:	83 c4 1c             	add    $0x1c,%esp
  801ab9:	5b                   	pop    %ebx
  801aba:	5e                   	pop    %esi
  801abb:	5f                   	pop    %edi
  801abc:	5d                   	pop    %ebp
  801abd:	c3                   	ret    
  801abe:	66 90                	xchg   %ax,%ax
  801ac0:	89 d8                	mov    %ebx,%eax
  801ac2:	f7 f7                	div    %edi
  801ac4:	31 ff                	xor    %edi,%edi
  801ac6:	89 fa                	mov    %edi,%edx
  801ac8:	83 c4 1c             	add    $0x1c,%esp
  801acb:	5b                   	pop    %ebx
  801acc:	5e                   	pop    %esi
  801acd:	5f                   	pop    %edi
  801ace:	5d                   	pop    %ebp
  801acf:	c3                   	ret    
  801ad0:	bd 20 00 00 00       	mov    $0x20,%ebp
  801ad5:	89 eb                	mov    %ebp,%ebx
  801ad7:	29 fb                	sub    %edi,%ebx
  801ad9:	89 f9                	mov    %edi,%ecx
  801adb:	d3 e6                	shl    %cl,%esi
  801add:	89 c5                	mov    %eax,%ebp
  801adf:	88 d9                	mov    %bl,%cl
  801ae1:	d3 ed                	shr    %cl,%ebp
  801ae3:	89 e9                	mov    %ebp,%ecx
  801ae5:	09 f1                	or     %esi,%ecx
  801ae7:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  801aeb:	89 f9                	mov    %edi,%ecx
  801aed:	d3 e0                	shl    %cl,%eax
  801aef:	89 c5                	mov    %eax,%ebp
  801af1:	89 d6                	mov    %edx,%esi
  801af3:	88 d9                	mov    %bl,%cl
  801af5:	d3 ee                	shr    %cl,%esi
  801af7:	89 f9                	mov    %edi,%ecx
  801af9:	d3 e2                	shl    %cl,%edx
  801afb:	8b 44 24 08          	mov    0x8(%esp),%eax
  801aff:	88 d9                	mov    %bl,%cl
  801b01:	d3 e8                	shr    %cl,%eax
  801b03:	09 c2                	or     %eax,%edx
  801b05:	89 d0                	mov    %edx,%eax
  801b07:	89 f2                	mov    %esi,%edx
  801b09:	f7 74 24 0c          	divl   0xc(%esp)
  801b0d:	89 d6                	mov    %edx,%esi
  801b0f:	89 c3                	mov    %eax,%ebx
  801b11:	f7 e5                	mul    %ebp
  801b13:	39 d6                	cmp    %edx,%esi
  801b15:	72 19                	jb     801b30 <__udivdi3+0xfc>
  801b17:	74 0b                	je     801b24 <__udivdi3+0xf0>
  801b19:	89 d8                	mov    %ebx,%eax
  801b1b:	31 ff                	xor    %edi,%edi
  801b1d:	e9 58 ff ff ff       	jmp    801a7a <__udivdi3+0x46>
  801b22:	66 90                	xchg   %ax,%ax
  801b24:	8b 54 24 08          	mov    0x8(%esp),%edx
  801b28:	89 f9                	mov    %edi,%ecx
  801b2a:	d3 e2                	shl    %cl,%edx
  801b2c:	39 c2                	cmp    %eax,%edx
  801b2e:	73 e9                	jae    801b19 <__udivdi3+0xe5>
  801b30:	8d 43 ff             	lea    -0x1(%ebx),%eax
  801b33:	31 ff                	xor    %edi,%edi
  801b35:	e9 40 ff ff ff       	jmp    801a7a <__udivdi3+0x46>
  801b3a:	66 90                	xchg   %ax,%ax
  801b3c:	31 c0                	xor    %eax,%eax
  801b3e:	e9 37 ff ff ff       	jmp    801a7a <__udivdi3+0x46>
  801b43:	90                   	nop

00801b44 <__umoddi3>:
  801b44:	55                   	push   %ebp
  801b45:	57                   	push   %edi
  801b46:	56                   	push   %esi
  801b47:	53                   	push   %ebx
  801b48:	83 ec 1c             	sub    $0x1c,%esp
  801b4b:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  801b4f:	8b 74 24 34          	mov    0x34(%esp),%esi
  801b53:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801b57:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  801b5b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801b5f:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801b63:	89 f3                	mov    %esi,%ebx
  801b65:	89 fa                	mov    %edi,%edx
  801b67:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801b6b:	89 34 24             	mov    %esi,(%esp)
  801b6e:	85 c0                	test   %eax,%eax
  801b70:	75 1a                	jne    801b8c <__umoddi3+0x48>
  801b72:	39 f7                	cmp    %esi,%edi
  801b74:	0f 86 a2 00 00 00    	jbe    801c1c <__umoddi3+0xd8>
  801b7a:	89 c8                	mov    %ecx,%eax
  801b7c:	89 f2                	mov    %esi,%edx
  801b7e:	f7 f7                	div    %edi
  801b80:	89 d0                	mov    %edx,%eax
  801b82:	31 d2                	xor    %edx,%edx
  801b84:	83 c4 1c             	add    $0x1c,%esp
  801b87:	5b                   	pop    %ebx
  801b88:	5e                   	pop    %esi
  801b89:	5f                   	pop    %edi
  801b8a:	5d                   	pop    %ebp
  801b8b:	c3                   	ret    
  801b8c:	39 f0                	cmp    %esi,%eax
  801b8e:	0f 87 ac 00 00 00    	ja     801c40 <__umoddi3+0xfc>
  801b94:	0f bd e8             	bsr    %eax,%ebp
  801b97:	83 f5 1f             	xor    $0x1f,%ebp
  801b9a:	0f 84 ac 00 00 00    	je     801c4c <__umoddi3+0x108>
  801ba0:	bf 20 00 00 00       	mov    $0x20,%edi
  801ba5:	29 ef                	sub    %ebp,%edi
  801ba7:	89 fe                	mov    %edi,%esi
  801ba9:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801bad:	89 e9                	mov    %ebp,%ecx
  801baf:	d3 e0                	shl    %cl,%eax
  801bb1:	89 d7                	mov    %edx,%edi
  801bb3:	89 f1                	mov    %esi,%ecx
  801bb5:	d3 ef                	shr    %cl,%edi
  801bb7:	09 c7                	or     %eax,%edi
  801bb9:	89 e9                	mov    %ebp,%ecx
  801bbb:	d3 e2                	shl    %cl,%edx
  801bbd:	89 14 24             	mov    %edx,(%esp)
  801bc0:	89 d8                	mov    %ebx,%eax
  801bc2:	d3 e0                	shl    %cl,%eax
  801bc4:	89 c2                	mov    %eax,%edx
  801bc6:	8b 44 24 08          	mov    0x8(%esp),%eax
  801bca:	d3 e0                	shl    %cl,%eax
  801bcc:	89 44 24 04          	mov    %eax,0x4(%esp)
  801bd0:	8b 44 24 08          	mov    0x8(%esp),%eax
  801bd4:	89 f1                	mov    %esi,%ecx
  801bd6:	d3 e8                	shr    %cl,%eax
  801bd8:	09 d0                	or     %edx,%eax
  801bda:	d3 eb                	shr    %cl,%ebx
  801bdc:	89 da                	mov    %ebx,%edx
  801bde:	f7 f7                	div    %edi
  801be0:	89 d3                	mov    %edx,%ebx
  801be2:	f7 24 24             	mull   (%esp)
  801be5:	89 c6                	mov    %eax,%esi
  801be7:	89 d1                	mov    %edx,%ecx
  801be9:	39 d3                	cmp    %edx,%ebx
  801beb:	0f 82 87 00 00 00    	jb     801c78 <__umoddi3+0x134>
  801bf1:	0f 84 91 00 00 00    	je     801c88 <__umoddi3+0x144>
  801bf7:	8b 54 24 04          	mov    0x4(%esp),%edx
  801bfb:	29 f2                	sub    %esi,%edx
  801bfd:	19 cb                	sbb    %ecx,%ebx
  801bff:	89 d8                	mov    %ebx,%eax
  801c01:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  801c05:	d3 e0                	shl    %cl,%eax
  801c07:	89 e9                	mov    %ebp,%ecx
  801c09:	d3 ea                	shr    %cl,%edx
  801c0b:	09 d0                	or     %edx,%eax
  801c0d:	89 e9                	mov    %ebp,%ecx
  801c0f:	d3 eb                	shr    %cl,%ebx
  801c11:	89 da                	mov    %ebx,%edx
  801c13:	83 c4 1c             	add    $0x1c,%esp
  801c16:	5b                   	pop    %ebx
  801c17:	5e                   	pop    %esi
  801c18:	5f                   	pop    %edi
  801c19:	5d                   	pop    %ebp
  801c1a:	c3                   	ret    
  801c1b:	90                   	nop
  801c1c:	89 fd                	mov    %edi,%ebp
  801c1e:	85 ff                	test   %edi,%edi
  801c20:	75 0b                	jne    801c2d <__umoddi3+0xe9>
  801c22:	b8 01 00 00 00       	mov    $0x1,%eax
  801c27:	31 d2                	xor    %edx,%edx
  801c29:	f7 f7                	div    %edi
  801c2b:	89 c5                	mov    %eax,%ebp
  801c2d:	89 f0                	mov    %esi,%eax
  801c2f:	31 d2                	xor    %edx,%edx
  801c31:	f7 f5                	div    %ebp
  801c33:	89 c8                	mov    %ecx,%eax
  801c35:	f7 f5                	div    %ebp
  801c37:	89 d0                	mov    %edx,%eax
  801c39:	e9 44 ff ff ff       	jmp    801b82 <__umoddi3+0x3e>
  801c3e:	66 90                	xchg   %ax,%ax
  801c40:	89 c8                	mov    %ecx,%eax
  801c42:	89 f2                	mov    %esi,%edx
  801c44:	83 c4 1c             	add    $0x1c,%esp
  801c47:	5b                   	pop    %ebx
  801c48:	5e                   	pop    %esi
  801c49:	5f                   	pop    %edi
  801c4a:	5d                   	pop    %ebp
  801c4b:	c3                   	ret    
  801c4c:	3b 04 24             	cmp    (%esp),%eax
  801c4f:	72 06                	jb     801c57 <__umoddi3+0x113>
  801c51:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  801c55:	77 0f                	ja     801c66 <__umoddi3+0x122>
  801c57:	89 f2                	mov    %esi,%edx
  801c59:	29 f9                	sub    %edi,%ecx
  801c5b:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  801c5f:	89 14 24             	mov    %edx,(%esp)
  801c62:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801c66:	8b 44 24 04          	mov    0x4(%esp),%eax
  801c6a:	8b 14 24             	mov    (%esp),%edx
  801c6d:	83 c4 1c             	add    $0x1c,%esp
  801c70:	5b                   	pop    %ebx
  801c71:	5e                   	pop    %esi
  801c72:	5f                   	pop    %edi
  801c73:	5d                   	pop    %ebp
  801c74:	c3                   	ret    
  801c75:	8d 76 00             	lea    0x0(%esi),%esi
  801c78:	2b 04 24             	sub    (%esp),%eax
  801c7b:	19 fa                	sbb    %edi,%edx
  801c7d:	89 d1                	mov    %edx,%ecx
  801c7f:	89 c6                	mov    %eax,%esi
  801c81:	e9 71 ff ff ff       	jmp    801bf7 <__umoddi3+0xb3>
  801c86:	66 90                	xchg   %ax,%ax
  801c88:	39 44 24 04          	cmp    %eax,0x4(%esp)
  801c8c:	72 ea                	jb     801c78 <__umoddi3+0x134>
  801c8e:	89 d9                	mov    %ebx,%ecx
  801c90:	e9 62 ff ff ff       	jmp    801bf7 <__umoddi3+0xb3>
