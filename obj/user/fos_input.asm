
obj/user/fos_input:     file format elf32-i386


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
  800031:	e8 a5 00 00 00       	call   8000db <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
#include <inc/lib.h>

void
_main(void)
{	
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	81 ec 18 04 00 00    	sub    $0x418,%esp
	int i1=0;
  800041:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int i2=0;
  800048:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	char buff1[512];
	char buff2[512];


	atomic_readline("Please enter first number :", buff1);
  80004f:	83 ec 08             	sub    $0x8,%esp
  800052:	8d 85 f0 fd ff ff    	lea    -0x210(%ebp),%eax
  800058:	50                   	push   %eax
  800059:	68 80 1f 80 00       	push   $0x801f80
  80005e:	e8 f5 0a 00 00       	call   800b58 <atomic_readline>
  800063:	83 c4 10             	add    $0x10,%esp
	i1 = strtol(buff1, NULL, 10);
  800066:	83 ec 04             	sub    $0x4,%esp
  800069:	6a 0a                	push   $0xa
  80006b:	6a 00                	push   $0x0
  80006d:	8d 85 f0 fd ff ff    	lea    -0x210(%ebp),%eax
  800073:	50                   	push   %eax
  800074:	e8 f7 0f 00 00       	call   801070 <strtol>
  800079:	83 c4 10             	add    $0x10,%esp
  80007c:	89 45 f4             	mov    %eax,-0xc(%ebp)

	//sleep
	env_sleep(2800);
  80007f:	83 ec 0c             	sub    $0xc,%esp
  800082:	68 f0 0a 00 00       	push   $0xaf0
  800087:	e8 8b 19 00 00       	call   801a17 <env_sleep>
  80008c:	83 c4 10             	add    $0x10,%esp

	atomic_readline("Please enter second number :", buff2);
  80008f:	83 ec 08             	sub    $0x8,%esp
  800092:	8d 85 f0 fb ff ff    	lea    -0x410(%ebp),%eax
  800098:	50                   	push   %eax
  800099:	68 9c 1f 80 00       	push   $0x801f9c
  80009e:	e8 b5 0a 00 00       	call   800b58 <atomic_readline>
  8000a3:	83 c4 10             	add    $0x10,%esp
	
	i2 = strtol(buff2, NULL, 10);
  8000a6:	83 ec 04             	sub    $0x4,%esp
  8000a9:	6a 0a                	push   $0xa
  8000ab:	6a 00                	push   $0x0
  8000ad:	8d 85 f0 fb ff ff    	lea    -0x410(%ebp),%eax
  8000b3:	50                   	push   %eax
  8000b4:	e8 b7 0f 00 00       	call   801070 <strtol>
  8000b9:	83 c4 10             	add    $0x10,%esp
  8000bc:	89 45 f0             	mov    %eax,-0x10(%ebp)

	atomic_cprintf("number 1 + number 2 = %d\n",i1+i2);
  8000bf:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8000c2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8000c5:	01 d0                	add    %edx,%eax
  8000c7:	83 ec 08             	sub    $0x8,%esp
  8000ca:	50                   	push   %eax
  8000cb:	68 b9 1f 80 00       	push   $0x801fb9
  8000d0:	e8 1d 03 00 00       	call   8003f2 <atomic_cprintf>
  8000d5:	83 c4 10             	add    $0x10,%esp
	return;	
  8000d8:	90                   	nop
}
  8000d9:	c9                   	leave  
  8000da:	c3                   	ret    

008000db <libmain>:
volatile bool printStats = 1;

volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";
void
libmain(int argc, char **argv)
{
  8000db:	55                   	push   %ebp
  8000dc:	89 e5                	mov    %esp,%ebp
  8000de:	57                   	push   %edi
  8000df:	56                   	push   %esi
  8000e0:	53                   	push   %ebx
  8000e1:	83 ec 7c             	sub    $0x7c,%esp
	//printStats = 1;
	int envIndex = sys_getenvindex();
  8000e4:	e8 6c 16 00 00       	call   801755 <sys_getenvindex>
  8000e9:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	myEnv = &(envs[envIndex]);
  8000ec:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8000ef:	89 d0                	mov    %edx,%eax
  8000f1:	c1 e0 06             	shl    $0x6,%eax
  8000f4:	29 d0                	sub    %edx,%eax
  8000f6:	c1 e0 02             	shl    $0x2,%eax
  8000f9:	01 d0                	add    %edx,%eax
  8000fb:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800102:	01 c8                	add    %ecx,%eax
  800104:	c1 e0 03             	shl    $0x3,%eax
  800107:	01 d0                	add    %edx,%eax
  800109:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800110:	29 c2                	sub    %eax,%edx
  800112:	8d 04 95 00 00 00 00 	lea    0x0(,%edx,4),%eax
  800119:	89 c2                	mov    %eax,%edx
  80011b:	8d 82 00 00 c0 ee    	lea    -0x11400000(%edx),%eax
  800121:	a3 20 30 80 00       	mov    %eax,0x803020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800126:	a1 20 30 80 00       	mov    0x803020,%eax
  80012b:	8a 40 20             	mov    0x20(%eax),%al
  80012e:	84 c0                	test   %al,%al
  800130:	74 0d                	je     80013f <libmain+0x64>
		binaryname = myEnv->prog_name;
  800132:	a1 20 30 80 00       	mov    0x803020,%eax
  800137:	83 c0 20             	add    $0x20,%eax
  80013a:	a3 04 30 80 00       	mov    %eax,0x803004

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80013f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800143:	7e 0a                	jle    80014f <libmain+0x74>
		binaryname = argv[0];
  800145:	8b 45 0c             	mov    0xc(%ebp),%eax
  800148:	8b 00                	mov    (%eax),%eax
  80014a:	a3 04 30 80 00       	mov    %eax,0x803004

	// call user main routine
	_main(argc, argv);
  80014f:	83 ec 08             	sub    $0x8,%esp
  800152:	ff 75 0c             	pushl  0xc(%ebp)
  800155:	ff 75 08             	pushl  0x8(%ebp)
  800158:	e8 db fe ff ff       	call   800038 <_main>
  80015d:	83 c4 10             	add    $0x10,%esp

	if (printStats)
  800160:	a1 00 30 80 00       	mov    0x803000,%eax
  800165:	85 c0                	test   %eax,%eax
  800167:	0f 84 01 01 00 00    	je     80026e <libmain+0x193>
	{
		char isOPTReplCmd[100] = "__IsOPTRepl__" ;
  80016d:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  800173:	bb cc 20 80 00       	mov    $0x8020cc,%ebx
  800178:	ba 0e 00 00 00       	mov    $0xe,%edx
  80017d:	89 c7                	mov    %eax,%edi
  80017f:	89 de                	mov    %ebx,%esi
  800181:	89 d1                	mov    %edx,%ecx
  800183:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  800185:	8d 55 8a             	lea    -0x76(%ebp),%edx
  800188:	b9 56 00 00 00       	mov    $0x56,%ecx
  80018d:	b0 00                	mov    $0x0,%al
  80018f:	89 d7                	mov    %edx,%edi
  800191:	f3 aa                	rep stos %al,%es:(%edi)
		int isOPTRepl = 0;
  800193:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
		sys_utilities(isOPTReplCmd, (uint32)(&isOPTRepl));
  80019a:	8d 45 e0             	lea    -0x20(%ebp),%eax
  80019d:	83 ec 08             	sub    $0x8,%esp
  8001a0:	50                   	push   %eax
  8001a1:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  8001a7:	50                   	push   %eax
  8001a8:	e8 de 17 00 00       	call   80198b <sys_utilities>
  8001ad:	83 c4 10             	add    $0x10,%esp

		sys_lock_cons();
  8001b0:	e8 27 13 00 00       	call   8014dc <sys_lock_cons>
		{
			cprintf("**************************************\n");
  8001b5:	83 ec 0c             	sub    $0xc,%esp
  8001b8:	68 ec 1f 80 00       	push   $0x801fec
  8001bd:	e8 be 01 00 00       	call   800380 <cprintf>
  8001c2:	83 c4 10             	add    $0x10,%esp
			if (isOPTRepl)
  8001c5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8001c8:	85 c0                	test   %eax,%eax
  8001ca:	74 18                	je     8001e4 <libmain+0x109>
			{
				cprintf("OPTIMAL number of page faults = %d\n", sys_get_optimal_num_faults());
  8001cc:	e8 d8 17 00 00       	call   8019a9 <sys_get_optimal_num_faults>
  8001d1:	83 ec 08             	sub    $0x8,%esp
  8001d4:	50                   	push   %eax
  8001d5:	68 14 20 80 00       	push   $0x802014
  8001da:	e8 a1 01 00 00       	call   800380 <cprintf>
  8001df:	83 c4 10             	add    $0x10,%esp
  8001e2:	eb 59                	jmp    80023d <libmain+0x162>
			}
			else
			{
				cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8001e4:	a1 20 30 80 00       	mov    0x803020,%eax
  8001e9:	8b 90 50 da 01 00    	mov    0x1da50(%eax),%edx
  8001ef:	a1 20 30 80 00       	mov    0x803020,%eax
  8001f4:	8b 80 40 da 01 00    	mov    0x1da40(%eax),%eax
  8001fa:	83 ec 04             	sub    $0x4,%esp
  8001fd:	52                   	push   %edx
  8001fe:	50                   	push   %eax
  8001ff:	68 38 20 80 00       	push   $0x802038
  800204:	e8 77 01 00 00       	call   800380 <cprintf>
  800209:	83 c4 10             	add    $0x10,%esp
				cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  80020c:	a1 20 30 80 00       	mov    0x803020,%eax
  800211:	8b 88 64 da 01 00    	mov    0x1da64(%eax),%ecx
  800217:	a1 20 30 80 00       	mov    0x803020,%eax
  80021c:	8b 90 60 da 01 00    	mov    0x1da60(%eax),%edx
  800222:	a1 20 30 80 00       	mov    0x803020,%eax
  800227:	8b 80 5c da 01 00    	mov    0x1da5c(%eax),%eax
  80022d:	51                   	push   %ecx
  80022e:	52                   	push   %edx
  80022f:	50                   	push   %eax
  800230:	68 60 20 80 00       	push   $0x802060
  800235:	e8 46 01 00 00       	call   800380 <cprintf>
  80023a:	83 c4 10             	add    $0x10,%esp
			}
			//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
			cprintf("Num of clocks = %d\n", myEnv->nClocks);
  80023d:	a1 20 30 80 00       	mov    0x803020,%eax
  800242:	8b 80 68 da 01 00    	mov    0x1da68(%eax),%eax
  800248:	83 ec 08             	sub    $0x8,%esp
  80024b:	50                   	push   %eax
  80024c:	68 b8 20 80 00       	push   $0x8020b8
  800251:	e8 2a 01 00 00       	call   800380 <cprintf>
  800256:	83 c4 10             	add    $0x10,%esp
			cprintf("**************************************\n");
  800259:	83 ec 0c             	sub    $0xc,%esp
  80025c:	68 ec 1f 80 00       	push   $0x801fec
  800261:	e8 1a 01 00 00       	call   800380 <cprintf>
  800266:	83 c4 10             	add    $0x10,%esp
		}
		sys_unlock_cons();
  800269:	e8 88 12 00 00       	call   8014f6 <sys_unlock_cons>
	}

	// exit gracefully
	exit();
  80026e:	e8 1f 00 00 00       	call   800292 <exit>
}
  800273:	90                   	nop
  800274:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800277:	5b                   	pop    %ebx
  800278:	5e                   	pop    %esi
  800279:	5f                   	pop    %edi
  80027a:	5d                   	pop    %ebp
  80027b:	c3                   	ret    

0080027c <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  80027c:	55                   	push   %ebp
  80027d:	89 e5                	mov    %esp,%ebp
  80027f:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800282:	83 ec 0c             	sub    $0xc,%esp
  800285:	6a 00                	push   $0x0
  800287:	e8 95 14 00 00       	call   801721 <sys_destroy_env>
  80028c:	83 c4 10             	add    $0x10,%esp
}
  80028f:	90                   	nop
  800290:	c9                   	leave  
  800291:	c3                   	ret    

00800292 <exit>:

void
exit(void)
{
  800292:	55                   	push   %ebp
  800293:	89 e5                	mov    %esp,%ebp
  800295:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  800298:	e8 ea 14 00 00       	call   801787 <sys_exit_env>
}
  80029d:	90                   	nop
  80029e:	c9                   	leave  
  80029f:	c3                   	ret    

008002a0 <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  8002a0:	55                   	push   %ebp
  8002a1:	89 e5                	mov    %esp,%ebp
  8002a3:	53                   	push   %ebx
  8002a4:	83 ec 04             	sub    $0x4,%esp
	b->buf[b->idx++] = ch;
  8002a7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8002aa:	8b 00                	mov    (%eax),%eax
  8002ac:	8d 48 01             	lea    0x1(%eax),%ecx
  8002af:	8b 55 0c             	mov    0xc(%ebp),%edx
  8002b2:	89 0a                	mov    %ecx,(%edx)
  8002b4:	8b 55 08             	mov    0x8(%ebp),%edx
  8002b7:	88 d1                	mov    %dl,%cl
  8002b9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8002bc:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  8002c0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8002c3:	8b 00                	mov    (%eax),%eax
  8002c5:	3d ff 00 00 00       	cmp    $0xff,%eax
  8002ca:	75 30                	jne    8002fc <putch+0x5c>
		sys_cputs(b->buf, b->idx, printProgName, curTextClr);
  8002cc:	8b 15 18 b1 81 00    	mov    0x81b118,%edx
  8002d2:	a0 44 30 80 00       	mov    0x803044,%al
  8002d7:	0f b6 c0             	movzbl %al,%eax
  8002da:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8002dd:	8b 09                	mov    (%ecx),%ecx
  8002df:	89 cb                	mov    %ecx,%ebx
  8002e1:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8002e4:	83 c1 08             	add    $0x8,%ecx
  8002e7:	52                   	push   %edx
  8002e8:	50                   	push   %eax
  8002e9:	53                   	push   %ebx
  8002ea:	51                   	push   %ecx
  8002eb:	e8 a8 11 00 00       	call   801498 <sys_cputs>
  8002f0:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8002f3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8002f6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8002fc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8002ff:	8b 40 04             	mov    0x4(%eax),%eax
  800302:	8d 50 01             	lea    0x1(%eax),%edx
  800305:	8b 45 0c             	mov    0xc(%ebp),%eax
  800308:	89 50 04             	mov    %edx,0x4(%eax)
}
  80030b:	90                   	nop
  80030c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80030f:	c9                   	leave  
  800310:	c3                   	ret    

00800311 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800311:	55                   	push   %ebp
  800312:	89 e5                	mov    %esp,%ebp
  800314:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  80031a:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800321:	00 00 00 
	b.cnt = 0;
  800324:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  80032b:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  80032e:	ff 75 0c             	pushl  0xc(%ebp)
  800331:	ff 75 08             	pushl  0x8(%ebp)
  800334:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80033a:	50                   	push   %eax
  80033b:	68 a0 02 80 00       	push   $0x8002a0
  800340:	e8 5a 02 00 00       	call   80059f <vprintfmt>
  800345:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName, curTextClr);
  800348:	8b 15 18 b1 81 00    	mov    0x81b118,%edx
  80034e:	a0 44 30 80 00       	mov    0x803044,%al
  800353:	0f b6 c0             	movzbl %al,%eax
  800356:	8b 8d f0 fe ff ff    	mov    -0x110(%ebp),%ecx
  80035c:	52                   	push   %edx
  80035d:	50                   	push   %eax
  80035e:	51                   	push   %ecx
  80035f:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800365:	83 c0 08             	add    $0x8,%eax
  800368:	50                   	push   %eax
  800369:	e8 2a 11 00 00       	call   801498 <sys_cputs>
  80036e:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800371:	c6 05 44 30 80 00 00 	movb   $0x0,0x803044
	return b.cnt;
  800378:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  80037e:	c9                   	leave  
  80037f:	c3                   	ret    

00800380 <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  800380:	55                   	push   %ebp
  800381:	89 e5                	mov    %esp,%ebp
  800383:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800386:	c6 05 44 30 80 00 01 	movb   $0x1,0x803044
	va_start(ap, fmt);
  80038d:	8d 45 0c             	lea    0xc(%ebp),%eax
  800390:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800393:	8b 45 08             	mov    0x8(%ebp),%eax
  800396:	83 ec 08             	sub    $0x8,%esp
  800399:	ff 75 f4             	pushl  -0xc(%ebp)
  80039c:	50                   	push   %eax
  80039d:	e8 6f ff ff ff       	call   800311 <vcprintf>
  8003a2:	83 c4 10             	add    $0x10,%esp
  8003a5:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  8003a8:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8003ab:	c9                   	leave  
  8003ac:	c3                   	ret    

008003ad <cprintf_colored>:

// *************** This text coloring feature is implemented by *************
// ********** Abd-Alrahman Zedan From Team Frozen-Bytes - FCIS'24-25 ********
int cprintf_colored(int textClr, const char *fmt, ...) {
  8003ad:	55                   	push   %ebp
  8003ae:	89 e5                	mov    %esp,%ebp
  8003b0:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  8003b3:	c6 05 44 30 80 00 01 	movb   $0x1,0x803044
	curTextClr = (textClr << 8) ; //set text color by the given value
  8003ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8003bd:	c1 e0 08             	shl    $0x8,%eax
  8003c0:	a3 18 b1 81 00       	mov    %eax,0x81b118
	va_start(ap, fmt);
  8003c5:	8d 45 0c             	lea    0xc(%ebp),%eax
  8003c8:	83 c0 04             	add    $0x4,%eax
  8003cb:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8003ce:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003d1:	83 ec 08             	sub    $0x8,%esp
  8003d4:	ff 75 f4             	pushl  -0xc(%ebp)
  8003d7:	50                   	push   %eax
  8003d8:	e8 34 ff ff ff       	call   800311 <vcprintf>
  8003dd:	83 c4 10             	add    $0x10,%esp
  8003e0:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);
	curTextClr = TEXT_DEFAULT_CLR; //restore default color
  8003e3:	c7 05 18 b1 81 00 00 	movl   $0x700,0x81b118
  8003ea:	07 00 00 

	return cnt;
  8003ed:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8003f0:	c9                   	leave  
  8003f1:	c3                   	ret    

008003f2 <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  8003f2:	55                   	push   %ebp
  8003f3:	89 e5                	mov    %esp,%ebp
  8003f5:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  8003f8:	e8 df 10 00 00       	call   8014dc <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  8003fd:	8d 45 0c             	lea    0xc(%ebp),%eax
  800400:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  800403:	8b 45 08             	mov    0x8(%ebp),%eax
  800406:	83 ec 08             	sub    $0x8,%esp
  800409:	ff 75 f4             	pushl  -0xc(%ebp)
  80040c:	50                   	push   %eax
  80040d:	e8 ff fe ff ff       	call   800311 <vcprintf>
  800412:	83 c4 10             	add    $0x10,%esp
  800415:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  800418:	e8 d9 10 00 00       	call   8014f6 <sys_unlock_cons>
	return cnt;
  80041d:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800420:	c9                   	leave  
  800421:	c3                   	ret    

00800422 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800422:	55                   	push   %ebp
  800423:	89 e5                	mov    %esp,%ebp
  800425:	53                   	push   %ebx
  800426:	83 ec 14             	sub    $0x14,%esp
  800429:	8b 45 10             	mov    0x10(%ebp),%eax
  80042c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80042f:	8b 45 14             	mov    0x14(%ebp),%eax
  800432:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800435:	8b 45 18             	mov    0x18(%ebp),%eax
  800438:	ba 00 00 00 00       	mov    $0x0,%edx
  80043d:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800440:	77 55                	ja     800497 <printnum+0x75>
  800442:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800445:	72 05                	jb     80044c <printnum+0x2a>
  800447:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80044a:	77 4b                	ja     800497 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  80044c:	8b 45 1c             	mov    0x1c(%ebp),%eax
  80044f:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800452:	8b 45 18             	mov    0x18(%ebp),%eax
  800455:	ba 00 00 00 00       	mov    $0x0,%edx
  80045a:	52                   	push   %edx
  80045b:	50                   	push   %eax
  80045c:	ff 75 f4             	pushl  -0xc(%ebp)
  80045f:	ff 75 f0             	pushl  -0x10(%ebp)
  800462:	e8 99 18 00 00       	call   801d00 <__udivdi3>
  800467:	83 c4 10             	add    $0x10,%esp
  80046a:	83 ec 04             	sub    $0x4,%esp
  80046d:	ff 75 20             	pushl  0x20(%ebp)
  800470:	53                   	push   %ebx
  800471:	ff 75 18             	pushl  0x18(%ebp)
  800474:	52                   	push   %edx
  800475:	50                   	push   %eax
  800476:	ff 75 0c             	pushl  0xc(%ebp)
  800479:	ff 75 08             	pushl  0x8(%ebp)
  80047c:	e8 a1 ff ff ff       	call   800422 <printnum>
  800481:	83 c4 20             	add    $0x20,%esp
  800484:	eb 1a                	jmp    8004a0 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800486:	83 ec 08             	sub    $0x8,%esp
  800489:	ff 75 0c             	pushl  0xc(%ebp)
  80048c:	ff 75 20             	pushl  0x20(%ebp)
  80048f:	8b 45 08             	mov    0x8(%ebp),%eax
  800492:	ff d0                	call   *%eax
  800494:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800497:	ff 4d 1c             	decl   0x1c(%ebp)
  80049a:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  80049e:	7f e6                	jg     800486 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8004a0:	8b 4d 18             	mov    0x18(%ebp),%ecx
  8004a3:	bb 00 00 00 00       	mov    $0x0,%ebx
  8004a8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8004ab:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8004ae:	53                   	push   %ebx
  8004af:	51                   	push   %ecx
  8004b0:	52                   	push   %edx
  8004b1:	50                   	push   %eax
  8004b2:	e8 59 19 00 00       	call   801e10 <__umoddi3>
  8004b7:	83 c4 10             	add    $0x10,%esp
  8004ba:	05 54 23 80 00       	add    $0x802354,%eax
  8004bf:	8a 00                	mov    (%eax),%al
  8004c1:	0f be c0             	movsbl %al,%eax
  8004c4:	83 ec 08             	sub    $0x8,%esp
  8004c7:	ff 75 0c             	pushl  0xc(%ebp)
  8004ca:	50                   	push   %eax
  8004cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8004ce:	ff d0                	call   *%eax
  8004d0:	83 c4 10             	add    $0x10,%esp
}
  8004d3:	90                   	nop
  8004d4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8004d7:	c9                   	leave  
  8004d8:	c3                   	ret    

008004d9 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8004d9:	55                   	push   %ebp
  8004da:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8004dc:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8004e0:	7e 1c                	jle    8004fe <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  8004e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8004e5:	8b 00                	mov    (%eax),%eax
  8004e7:	8d 50 08             	lea    0x8(%eax),%edx
  8004ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8004ed:	89 10                	mov    %edx,(%eax)
  8004ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8004f2:	8b 00                	mov    (%eax),%eax
  8004f4:	83 e8 08             	sub    $0x8,%eax
  8004f7:	8b 50 04             	mov    0x4(%eax),%edx
  8004fa:	8b 00                	mov    (%eax),%eax
  8004fc:	eb 40                	jmp    80053e <getuint+0x65>
	else if (lflag)
  8004fe:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800502:	74 1e                	je     800522 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800504:	8b 45 08             	mov    0x8(%ebp),%eax
  800507:	8b 00                	mov    (%eax),%eax
  800509:	8d 50 04             	lea    0x4(%eax),%edx
  80050c:	8b 45 08             	mov    0x8(%ebp),%eax
  80050f:	89 10                	mov    %edx,(%eax)
  800511:	8b 45 08             	mov    0x8(%ebp),%eax
  800514:	8b 00                	mov    (%eax),%eax
  800516:	83 e8 04             	sub    $0x4,%eax
  800519:	8b 00                	mov    (%eax),%eax
  80051b:	ba 00 00 00 00       	mov    $0x0,%edx
  800520:	eb 1c                	jmp    80053e <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800522:	8b 45 08             	mov    0x8(%ebp),%eax
  800525:	8b 00                	mov    (%eax),%eax
  800527:	8d 50 04             	lea    0x4(%eax),%edx
  80052a:	8b 45 08             	mov    0x8(%ebp),%eax
  80052d:	89 10                	mov    %edx,(%eax)
  80052f:	8b 45 08             	mov    0x8(%ebp),%eax
  800532:	8b 00                	mov    (%eax),%eax
  800534:	83 e8 04             	sub    $0x4,%eax
  800537:	8b 00                	mov    (%eax),%eax
  800539:	ba 00 00 00 00       	mov    $0x0,%edx
}
  80053e:	5d                   	pop    %ebp
  80053f:	c3                   	ret    

00800540 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800540:	55                   	push   %ebp
  800541:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800543:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800547:	7e 1c                	jle    800565 <getint+0x25>
		return va_arg(*ap, long long);
  800549:	8b 45 08             	mov    0x8(%ebp),%eax
  80054c:	8b 00                	mov    (%eax),%eax
  80054e:	8d 50 08             	lea    0x8(%eax),%edx
  800551:	8b 45 08             	mov    0x8(%ebp),%eax
  800554:	89 10                	mov    %edx,(%eax)
  800556:	8b 45 08             	mov    0x8(%ebp),%eax
  800559:	8b 00                	mov    (%eax),%eax
  80055b:	83 e8 08             	sub    $0x8,%eax
  80055e:	8b 50 04             	mov    0x4(%eax),%edx
  800561:	8b 00                	mov    (%eax),%eax
  800563:	eb 38                	jmp    80059d <getint+0x5d>
	else if (lflag)
  800565:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800569:	74 1a                	je     800585 <getint+0x45>
		return va_arg(*ap, long);
  80056b:	8b 45 08             	mov    0x8(%ebp),%eax
  80056e:	8b 00                	mov    (%eax),%eax
  800570:	8d 50 04             	lea    0x4(%eax),%edx
  800573:	8b 45 08             	mov    0x8(%ebp),%eax
  800576:	89 10                	mov    %edx,(%eax)
  800578:	8b 45 08             	mov    0x8(%ebp),%eax
  80057b:	8b 00                	mov    (%eax),%eax
  80057d:	83 e8 04             	sub    $0x4,%eax
  800580:	8b 00                	mov    (%eax),%eax
  800582:	99                   	cltd   
  800583:	eb 18                	jmp    80059d <getint+0x5d>
	else
		return va_arg(*ap, int);
  800585:	8b 45 08             	mov    0x8(%ebp),%eax
  800588:	8b 00                	mov    (%eax),%eax
  80058a:	8d 50 04             	lea    0x4(%eax),%edx
  80058d:	8b 45 08             	mov    0x8(%ebp),%eax
  800590:	89 10                	mov    %edx,(%eax)
  800592:	8b 45 08             	mov    0x8(%ebp),%eax
  800595:	8b 00                	mov    (%eax),%eax
  800597:	83 e8 04             	sub    $0x4,%eax
  80059a:	8b 00                	mov    (%eax),%eax
  80059c:	99                   	cltd   
}
  80059d:	5d                   	pop    %ebp
  80059e:	c3                   	ret    

0080059f <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  80059f:	55                   	push   %ebp
  8005a0:	89 e5                	mov    %esp,%ebp
  8005a2:	56                   	push   %esi
  8005a3:	53                   	push   %ebx
  8005a4:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8005a7:	eb 17                	jmp    8005c0 <vprintfmt+0x21>
			if (ch == '\0')
  8005a9:	85 db                	test   %ebx,%ebx
  8005ab:	0f 84 c1 03 00 00    	je     800972 <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  8005b1:	83 ec 08             	sub    $0x8,%esp
  8005b4:	ff 75 0c             	pushl  0xc(%ebp)
  8005b7:	53                   	push   %ebx
  8005b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8005bb:	ff d0                	call   *%eax
  8005bd:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8005c0:	8b 45 10             	mov    0x10(%ebp),%eax
  8005c3:	8d 50 01             	lea    0x1(%eax),%edx
  8005c6:	89 55 10             	mov    %edx,0x10(%ebp)
  8005c9:	8a 00                	mov    (%eax),%al
  8005cb:	0f b6 d8             	movzbl %al,%ebx
  8005ce:	83 fb 25             	cmp    $0x25,%ebx
  8005d1:	75 d6                	jne    8005a9 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  8005d3:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  8005d7:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  8005de:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8005e5:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  8005ec:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8005f3:	8b 45 10             	mov    0x10(%ebp),%eax
  8005f6:	8d 50 01             	lea    0x1(%eax),%edx
  8005f9:	89 55 10             	mov    %edx,0x10(%ebp)
  8005fc:	8a 00                	mov    (%eax),%al
  8005fe:	0f b6 d8             	movzbl %al,%ebx
  800601:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800604:	83 f8 5b             	cmp    $0x5b,%eax
  800607:	0f 87 3d 03 00 00    	ja     80094a <vprintfmt+0x3ab>
  80060d:	8b 04 85 78 23 80 00 	mov    0x802378(,%eax,4),%eax
  800614:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800616:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  80061a:	eb d7                	jmp    8005f3 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  80061c:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800620:	eb d1                	jmp    8005f3 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800622:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800629:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80062c:	89 d0                	mov    %edx,%eax
  80062e:	c1 e0 02             	shl    $0x2,%eax
  800631:	01 d0                	add    %edx,%eax
  800633:	01 c0                	add    %eax,%eax
  800635:	01 d8                	add    %ebx,%eax
  800637:	83 e8 30             	sub    $0x30,%eax
  80063a:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  80063d:	8b 45 10             	mov    0x10(%ebp),%eax
  800640:	8a 00                	mov    (%eax),%al
  800642:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800645:	83 fb 2f             	cmp    $0x2f,%ebx
  800648:	7e 3e                	jle    800688 <vprintfmt+0xe9>
  80064a:	83 fb 39             	cmp    $0x39,%ebx
  80064d:	7f 39                	jg     800688 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  80064f:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800652:	eb d5                	jmp    800629 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800654:	8b 45 14             	mov    0x14(%ebp),%eax
  800657:	83 c0 04             	add    $0x4,%eax
  80065a:	89 45 14             	mov    %eax,0x14(%ebp)
  80065d:	8b 45 14             	mov    0x14(%ebp),%eax
  800660:	83 e8 04             	sub    $0x4,%eax
  800663:	8b 00                	mov    (%eax),%eax
  800665:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800668:	eb 1f                	jmp    800689 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  80066a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80066e:	79 83                	jns    8005f3 <vprintfmt+0x54>
				width = 0;
  800670:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800677:	e9 77 ff ff ff       	jmp    8005f3 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  80067c:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800683:	e9 6b ff ff ff       	jmp    8005f3 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800688:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800689:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80068d:	0f 89 60 ff ff ff    	jns    8005f3 <vprintfmt+0x54>
				width = precision, precision = -1;
  800693:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800696:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800699:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  8006a0:	e9 4e ff ff ff       	jmp    8005f3 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  8006a5:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  8006a8:	e9 46 ff ff ff       	jmp    8005f3 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  8006ad:	8b 45 14             	mov    0x14(%ebp),%eax
  8006b0:	83 c0 04             	add    $0x4,%eax
  8006b3:	89 45 14             	mov    %eax,0x14(%ebp)
  8006b6:	8b 45 14             	mov    0x14(%ebp),%eax
  8006b9:	83 e8 04             	sub    $0x4,%eax
  8006bc:	8b 00                	mov    (%eax),%eax
  8006be:	83 ec 08             	sub    $0x8,%esp
  8006c1:	ff 75 0c             	pushl  0xc(%ebp)
  8006c4:	50                   	push   %eax
  8006c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8006c8:	ff d0                	call   *%eax
  8006ca:	83 c4 10             	add    $0x10,%esp
			break;
  8006cd:	e9 9b 02 00 00       	jmp    80096d <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  8006d2:	8b 45 14             	mov    0x14(%ebp),%eax
  8006d5:	83 c0 04             	add    $0x4,%eax
  8006d8:	89 45 14             	mov    %eax,0x14(%ebp)
  8006db:	8b 45 14             	mov    0x14(%ebp),%eax
  8006de:	83 e8 04             	sub    $0x4,%eax
  8006e1:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  8006e3:	85 db                	test   %ebx,%ebx
  8006e5:	79 02                	jns    8006e9 <vprintfmt+0x14a>
				err = -err;
  8006e7:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  8006e9:	83 fb 64             	cmp    $0x64,%ebx
  8006ec:	7f 0b                	jg     8006f9 <vprintfmt+0x15a>
  8006ee:	8b 34 9d c0 21 80 00 	mov    0x8021c0(,%ebx,4),%esi
  8006f5:	85 f6                	test   %esi,%esi
  8006f7:	75 19                	jne    800712 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  8006f9:	53                   	push   %ebx
  8006fa:	68 65 23 80 00       	push   $0x802365
  8006ff:	ff 75 0c             	pushl  0xc(%ebp)
  800702:	ff 75 08             	pushl  0x8(%ebp)
  800705:	e8 70 02 00 00       	call   80097a <printfmt>
  80070a:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  80070d:	e9 5b 02 00 00       	jmp    80096d <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800712:	56                   	push   %esi
  800713:	68 6e 23 80 00       	push   $0x80236e
  800718:	ff 75 0c             	pushl  0xc(%ebp)
  80071b:	ff 75 08             	pushl  0x8(%ebp)
  80071e:	e8 57 02 00 00       	call   80097a <printfmt>
  800723:	83 c4 10             	add    $0x10,%esp
			break;
  800726:	e9 42 02 00 00       	jmp    80096d <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  80072b:	8b 45 14             	mov    0x14(%ebp),%eax
  80072e:	83 c0 04             	add    $0x4,%eax
  800731:	89 45 14             	mov    %eax,0x14(%ebp)
  800734:	8b 45 14             	mov    0x14(%ebp),%eax
  800737:	83 e8 04             	sub    $0x4,%eax
  80073a:	8b 30                	mov    (%eax),%esi
  80073c:	85 f6                	test   %esi,%esi
  80073e:	75 05                	jne    800745 <vprintfmt+0x1a6>
				p = "(null)";
  800740:	be 71 23 80 00       	mov    $0x802371,%esi
			if (width > 0 && padc != '-')
  800745:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800749:	7e 6d                	jle    8007b8 <vprintfmt+0x219>
  80074b:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  80074f:	74 67                	je     8007b8 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800751:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800754:	83 ec 08             	sub    $0x8,%esp
  800757:	50                   	push   %eax
  800758:	56                   	push   %esi
  800759:	e8 26 05 00 00       	call   800c84 <strnlen>
  80075e:	83 c4 10             	add    $0x10,%esp
  800761:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800764:	eb 16                	jmp    80077c <vprintfmt+0x1dd>
					putch(padc, putdat);
  800766:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  80076a:	83 ec 08             	sub    $0x8,%esp
  80076d:	ff 75 0c             	pushl  0xc(%ebp)
  800770:	50                   	push   %eax
  800771:	8b 45 08             	mov    0x8(%ebp),%eax
  800774:	ff d0                	call   *%eax
  800776:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800779:	ff 4d e4             	decl   -0x1c(%ebp)
  80077c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800780:	7f e4                	jg     800766 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800782:	eb 34                	jmp    8007b8 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800784:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800788:	74 1c                	je     8007a6 <vprintfmt+0x207>
  80078a:	83 fb 1f             	cmp    $0x1f,%ebx
  80078d:	7e 05                	jle    800794 <vprintfmt+0x1f5>
  80078f:	83 fb 7e             	cmp    $0x7e,%ebx
  800792:	7e 12                	jle    8007a6 <vprintfmt+0x207>
					putch('?', putdat);
  800794:	83 ec 08             	sub    $0x8,%esp
  800797:	ff 75 0c             	pushl  0xc(%ebp)
  80079a:	6a 3f                	push   $0x3f
  80079c:	8b 45 08             	mov    0x8(%ebp),%eax
  80079f:	ff d0                	call   *%eax
  8007a1:	83 c4 10             	add    $0x10,%esp
  8007a4:	eb 0f                	jmp    8007b5 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  8007a6:	83 ec 08             	sub    $0x8,%esp
  8007a9:	ff 75 0c             	pushl  0xc(%ebp)
  8007ac:	53                   	push   %ebx
  8007ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8007b0:	ff d0                	call   *%eax
  8007b2:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8007b5:	ff 4d e4             	decl   -0x1c(%ebp)
  8007b8:	89 f0                	mov    %esi,%eax
  8007ba:	8d 70 01             	lea    0x1(%eax),%esi
  8007bd:	8a 00                	mov    (%eax),%al
  8007bf:	0f be d8             	movsbl %al,%ebx
  8007c2:	85 db                	test   %ebx,%ebx
  8007c4:	74 24                	je     8007ea <vprintfmt+0x24b>
  8007c6:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8007ca:	78 b8                	js     800784 <vprintfmt+0x1e5>
  8007cc:	ff 4d e0             	decl   -0x20(%ebp)
  8007cf:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8007d3:	79 af                	jns    800784 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8007d5:	eb 13                	jmp    8007ea <vprintfmt+0x24b>
				putch(' ', putdat);
  8007d7:	83 ec 08             	sub    $0x8,%esp
  8007da:	ff 75 0c             	pushl  0xc(%ebp)
  8007dd:	6a 20                	push   $0x20
  8007df:	8b 45 08             	mov    0x8(%ebp),%eax
  8007e2:	ff d0                	call   *%eax
  8007e4:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8007e7:	ff 4d e4             	decl   -0x1c(%ebp)
  8007ea:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8007ee:	7f e7                	jg     8007d7 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  8007f0:	e9 78 01 00 00       	jmp    80096d <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  8007f5:	83 ec 08             	sub    $0x8,%esp
  8007f8:	ff 75 e8             	pushl  -0x18(%ebp)
  8007fb:	8d 45 14             	lea    0x14(%ebp),%eax
  8007fe:	50                   	push   %eax
  8007ff:	e8 3c fd ff ff       	call   800540 <getint>
  800804:	83 c4 10             	add    $0x10,%esp
  800807:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80080a:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  80080d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800810:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800813:	85 d2                	test   %edx,%edx
  800815:	79 23                	jns    80083a <vprintfmt+0x29b>
				putch('-', putdat);
  800817:	83 ec 08             	sub    $0x8,%esp
  80081a:	ff 75 0c             	pushl  0xc(%ebp)
  80081d:	6a 2d                	push   $0x2d
  80081f:	8b 45 08             	mov    0x8(%ebp),%eax
  800822:	ff d0                	call   *%eax
  800824:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800827:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80082a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80082d:	f7 d8                	neg    %eax
  80082f:	83 d2 00             	adc    $0x0,%edx
  800832:	f7 da                	neg    %edx
  800834:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800837:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  80083a:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800841:	e9 bc 00 00 00       	jmp    800902 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800846:	83 ec 08             	sub    $0x8,%esp
  800849:	ff 75 e8             	pushl  -0x18(%ebp)
  80084c:	8d 45 14             	lea    0x14(%ebp),%eax
  80084f:	50                   	push   %eax
  800850:	e8 84 fc ff ff       	call   8004d9 <getuint>
  800855:	83 c4 10             	add    $0x10,%esp
  800858:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80085b:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  80085e:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800865:	e9 98 00 00 00       	jmp    800902 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  80086a:	83 ec 08             	sub    $0x8,%esp
  80086d:	ff 75 0c             	pushl  0xc(%ebp)
  800870:	6a 58                	push   $0x58
  800872:	8b 45 08             	mov    0x8(%ebp),%eax
  800875:	ff d0                	call   *%eax
  800877:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  80087a:	83 ec 08             	sub    $0x8,%esp
  80087d:	ff 75 0c             	pushl  0xc(%ebp)
  800880:	6a 58                	push   $0x58
  800882:	8b 45 08             	mov    0x8(%ebp),%eax
  800885:	ff d0                	call   *%eax
  800887:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  80088a:	83 ec 08             	sub    $0x8,%esp
  80088d:	ff 75 0c             	pushl  0xc(%ebp)
  800890:	6a 58                	push   $0x58
  800892:	8b 45 08             	mov    0x8(%ebp),%eax
  800895:	ff d0                	call   *%eax
  800897:	83 c4 10             	add    $0x10,%esp
			break;
  80089a:	e9 ce 00 00 00       	jmp    80096d <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  80089f:	83 ec 08             	sub    $0x8,%esp
  8008a2:	ff 75 0c             	pushl  0xc(%ebp)
  8008a5:	6a 30                	push   $0x30
  8008a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8008aa:	ff d0                	call   *%eax
  8008ac:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  8008af:	83 ec 08             	sub    $0x8,%esp
  8008b2:	ff 75 0c             	pushl  0xc(%ebp)
  8008b5:	6a 78                	push   $0x78
  8008b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8008ba:	ff d0                	call   *%eax
  8008bc:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  8008bf:	8b 45 14             	mov    0x14(%ebp),%eax
  8008c2:	83 c0 04             	add    $0x4,%eax
  8008c5:	89 45 14             	mov    %eax,0x14(%ebp)
  8008c8:	8b 45 14             	mov    0x14(%ebp),%eax
  8008cb:	83 e8 04             	sub    $0x4,%eax
  8008ce:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  8008d0:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8008d3:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  8008da:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  8008e1:	eb 1f                	jmp    800902 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  8008e3:	83 ec 08             	sub    $0x8,%esp
  8008e6:	ff 75 e8             	pushl  -0x18(%ebp)
  8008e9:	8d 45 14             	lea    0x14(%ebp),%eax
  8008ec:	50                   	push   %eax
  8008ed:	e8 e7 fb ff ff       	call   8004d9 <getuint>
  8008f2:	83 c4 10             	add    $0x10,%esp
  8008f5:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8008f8:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  8008fb:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800902:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800906:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800909:	83 ec 04             	sub    $0x4,%esp
  80090c:	52                   	push   %edx
  80090d:	ff 75 e4             	pushl  -0x1c(%ebp)
  800910:	50                   	push   %eax
  800911:	ff 75 f4             	pushl  -0xc(%ebp)
  800914:	ff 75 f0             	pushl  -0x10(%ebp)
  800917:	ff 75 0c             	pushl  0xc(%ebp)
  80091a:	ff 75 08             	pushl  0x8(%ebp)
  80091d:	e8 00 fb ff ff       	call   800422 <printnum>
  800922:	83 c4 20             	add    $0x20,%esp
			break;
  800925:	eb 46                	jmp    80096d <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800927:	83 ec 08             	sub    $0x8,%esp
  80092a:	ff 75 0c             	pushl  0xc(%ebp)
  80092d:	53                   	push   %ebx
  80092e:	8b 45 08             	mov    0x8(%ebp),%eax
  800931:	ff d0                	call   *%eax
  800933:	83 c4 10             	add    $0x10,%esp
			break;
  800936:	eb 35                	jmp    80096d <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  800938:	c6 05 44 30 80 00 00 	movb   $0x0,0x803044
			break;
  80093f:	eb 2c                	jmp    80096d <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  800941:	c6 05 44 30 80 00 01 	movb   $0x1,0x803044
			break;
  800948:	eb 23                	jmp    80096d <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  80094a:	83 ec 08             	sub    $0x8,%esp
  80094d:	ff 75 0c             	pushl  0xc(%ebp)
  800950:	6a 25                	push   $0x25
  800952:	8b 45 08             	mov    0x8(%ebp),%eax
  800955:	ff d0                	call   *%eax
  800957:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  80095a:	ff 4d 10             	decl   0x10(%ebp)
  80095d:	eb 03                	jmp    800962 <vprintfmt+0x3c3>
  80095f:	ff 4d 10             	decl   0x10(%ebp)
  800962:	8b 45 10             	mov    0x10(%ebp),%eax
  800965:	48                   	dec    %eax
  800966:	8a 00                	mov    (%eax),%al
  800968:	3c 25                	cmp    $0x25,%al
  80096a:	75 f3                	jne    80095f <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  80096c:	90                   	nop
		}
	}
  80096d:	e9 35 fc ff ff       	jmp    8005a7 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800972:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800973:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800976:	5b                   	pop    %ebx
  800977:	5e                   	pop    %esi
  800978:	5d                   	pop    %ebp
  800979:	c3                   	ret    

0080097a <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  80097a:	55                   	push   %ebp
  80097b:	89 e5                	mov    %esp,%ebp
  80097d:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800980:	8d 45 10             	lea    0x10(%ebp),%eax
  800983:	83 c0 04             	add    $0x4,%eax
  800986:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800989:	8b 45 10             	mov    0x10(%ebp),%eax
  80098c:	ff 75 f4             	pushl  -0xc(%ebp)
  80098f:	50                   	push   %eax
  800990:	ff 75 0c             	pushl  0xc(%ebp)
  800993:	ff 75 08             	pushl  0x8(%ebp)
  800996:	e8 04 fc ff ff       	call   80059f <vprintfmt>
  80099b:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  80099e:	90                   	nop
  80099f:	c9                   	leave  
  8009a0:	c3                   	ret    

008009a1 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8009a1:	55                   	push   %ebp
  8009a2:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  8009a4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009a7:	8b 40 08             	mov    0x8(%eax),%eax
  8009aa:	8d 50 01             	lea    0x1(%eax),%edx
  8009ad:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009b0:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  8009b3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009b6:	8b 10                	mov    (%eax),%edx
  8009b8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009bb:	8b 40 04             	mov    0x4(%eax),%eax
  8009be:	39 c2                	cmp    %eax,%edx
  8009c0:	73 12                	jae    8009d4 <sprintputch+0x33>
		*b->buf++ = ch;
  8009c2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009c5:	8b 00                	mov    (%eax),%eax
  8009c7:	8d 48 01             	lea    0x1(%eax),%ecx
  8009ca:	8b 55 0c             	mov    0xc(%ebp),%edx
  8009cd:	89 0a                	mov    %ecx,(%edx)
  8009cf:	8b 55 08             	mov    0x8(%ebp),%edx
  8009d2:	88 10                	mov    %dl,(%eax)
}
  8009d4:	90                   	nop
  8009d5:	5d                   	pop    %ebp
  8009d6:	c3                   	ret    

008009d7 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8009d7:	55                   	push   %ebp
  8009d8:	89 e5                	mov    %esp,%ebp
  8009da:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  8009dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8009e0:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8009e3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009e6:	8d 50 ff             	lea    -0x1(%eax),%edx
  8009e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8009ec:	01 d0                	add    %edx,%eax
  8009ee:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8009f1:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  8009f8:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8009fc:	74 06                	je     800a04 <vsnprintf+0x2d>
  8009fe:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800a02:	7f 07                	jg     800a0b <vsnprintf+0x34>
		return -E_INVAL;
  800a04:	b8 03 00 00 00       	mov    $0x3,%eax
  800a09:	eb 20                	jmp    800a2b <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800a0b:	ff 75 14             	pushl  0x14(%ebp)
  800a0e:	ff 75 10             	pushl  0x10(%ebp)
  800a11:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800a14:	50                   	push   %eax
  800a15:	68 a1 09 80 00       	push   $0x8009a1
  800a1a:	e8 80 fb ff ff       	call   80059f <vprintfmt>
  800a1f:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800a22:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800a25:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800a28:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800a2b:	c9                   	leave  
  800a2c:	c3                   	ret    

00800a2d <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800a2d:	55                   	push   %ebp
  800a2e:	89 e5                	mov    %esp,%ebp
  800a30:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800a33:	8d 45 10             	lea    0x10(%ebp),%eax
  800a36:	83 c0 04             	add    $0x4,%eax
  800a39:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800a3c:	8b 45 10             	mov    0x10(%ebp),%eax
  800a3f:	ff 75 f4             	pushl  -0xc(%ebp)
  800a42:	50                   	push   %eax
  800a43:	ff 75 0c             	pushl  0xc(%ebp)
  800a46:	ff 75 08             	pushl  0x8(%ebp)
  800a49:	e8 89 ff ff ff       	call   8009d7 <vsnprintf>
  800a4e:	83 c4 10             	add    $0x10,%esp
  800a51:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800a54:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800a57:	c9                   	leave  
  800a58:	c3                   	ret    

00800a59 <readline>:
#include <inc/lib.h>

//static char buf[BUFLEN];

void readline(const char *prompt, char* buf)
{
  800a59:	55                   	push   %ebp
  800a5a:	89 e5                	mov    %esp,%ebp
  800a5c:	83 ec 18             	sub    $0x18,%esp
	int i, c, echoing;

	if (prompt != NULL)
  800a5f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800a63:	74 13                	je     800a78 <readline+0x1f>
		cprintf("%s", prompt);
  800a65:	83 ec 08             	sub    $0x8,%esp
  800a68:	ff 75 08             	pushl  0x8(%ebp)
  800a6b:	68 e8 24 80 00       	push   $0x8024e8
  800a70:	e8 0b f9 ff ff       	call   800380 <cprintf>
  800a75:	83 c4 10             	add    $0x10,%esp

	i = 0;
  800a78:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	echoing = iscons(0);
  800a7f:	83 ec 0c             	sub    $0xc,%esp
  800a82:	6a 00                	push   $0x0
  800a84:	e8 7e 10 00 00       	call   801b07 <iscons>
  800a89:	83 c4 10             	add    $0x10,%esp
  800a8c:	89 45 f0             	mov    %eax,-0x10(%ebp)
	while (1) {
		c = getchar();
  800a8f:	e8 60 10 00 00       	call   801af4 <getchar>
  800a94:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if (c < 0) {
  800a97:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800a9b:	79 22                	jns    800abf <readline+0x66>
			if (c != -E_EOF)
  800a9d:	83 7d ec 07          	cmpl   $0x7,-0x14(%ebp)
  800aa1:	0f 84 ad 00 00 00    	je     800b54 <readline+0xfb>
				cprintf("read error: %e\n", c);
  800aa7:	83 ec 08             	sub    $0x8,%esp
  800aaa:	ff 75 ec             	pushl  -0x14(%ebp)
  800aad:	68 eb 24 80 00       	push   $0x8024eb
  800ab2:	e8 c9 f8 ff ff       	call   800380 <cprintf>
  800ab7:	83 c4 10             	add    $0x10,%esp
			break;
  800aba:	e9 95 00 00 00       	jmp    800b54 <readline+0xfb>
		} else if (c >= ' ' && i < BUFLEN-1) {
  800abf:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%ebp)
  800ac3:	7e 34                	jle    800af9 <readline+0xa0>
  800ac5:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  800acc:	7f 2b                	jg     800af9 <readline+0xa0>
			if (echoing)
  800ace:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800ad2:	74 0e                	je     800ae2 <readline+0x89>
				cputchar(c);
  800ad4:	83 ec 0c             	sub    $0xc,%esp
  800ad7:	ff 75 ec             	pushl  -0x14(%ebp)
  800ada:	e8 f6 0f 00 00       	call   801ad5 <cputchar>
  800adf:	83 c4 10             	add    $0x10,%esp
			buf[i++] = c;
  800ae2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800ae5:	8d 50 01             	lea    0x1(%eax),%edx
  800ae8:	89 55 f4             	mov    %edx,-0xc(%ebp)
  800aeb:	89 c2                	mov    %eax,%edx
  800aed:	8b 45 0c             	mov    0xc(%ebp),%eax
  800af0:	01 d0                	add    %edx,%eax
  800af2:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800af5:	88 10                	mov    %dl,(%eax)
  800af7:	eb 56                	jmp    800b4f <readline+0xf6>
		} else if (c == '\b' && i > 0) {
  800af9:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  800afd:	75 1f                	jne    800b1e <readline+0xc5>
  800aff:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  800b03:	7e 19                	jle    800b1e <readline+0xc5>
			if (echoing)
  800b05:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800b09:	74 0e                	je     800b19 <readline+0xc0>
				cputchar(c);
  800b0b:	83 ec 0c             	sub    $0xc,%esp
  800b0e:	ff 75 ec             	pushl  -0x14(%ebp)
  800b11:	e8 bf 0f 00 00       	call   801ad5 <cputchar>
  800b16:	83 c4 10             	add    $0x10,%esp

			i--;
  800b19:	ff 4d f4             	decl   -0xc(%ebp)
  800b1c:	eb 31                	jmp    800b4f <readline+0xf6>
		} else if (c == '\n' || c == '\r') {
  800b1e:	83 7d ec 0a          	cmpl   $0xa,-0x14(%ebp)
  800b22:	74 0a                	je     800b2e <readline+0xd5>
  800b24:	83 7d ec 0d          	cmpl   $0xd,-0x14(%ebp)
  800b28:	0f 85 61 ff ff ff    	jne    800a8f <readline+0x36>
			if (echoing)
  800b2e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800b32:	74 0e                	je     800b42 <readline+0xe9>
				cputchar(c);
  800b34:	83 ec 0c             	sub    $0xc,%esp
  800b37:	ff 75 ec             	pushl  -0x14(%ebp)
  800b3a:	e8 96 0f 00 00       	call   801ad5 <cputchar>
  800b3f:	83 c4 10             	add    $0x10,%esp

			buf[i] = 0;
  800b42:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800b45:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b48:	01 d0                	add    %edx,%eax
  800b4a:	c6 00 00             	movb   $0x0,(%eax)
			break;
  800b4d:	eb 06                	jmp    800b55 <readline+0xfc>
		}
	}
  800b4f:	e9 3b ff ff ff       	jmp    800a8f <readline+0x36>
	while (1) {
		c = getchar();
		if (c < 0) {
			if (c != -E_EOF)
				cprintf("read error: %e\n", c);
			break;
  800b54:	90                   	nop

			buf[i] = 0;
			break;
		}
	}
}
  800b55:	90                   	nop
  800b56:	c9                   	leave  
  800b57:	c3                   	ret    

00800b58 <atomic_readline>:

void atomic_readline(const char *prompt, char* buf)
{
  800b58:	55                   	push   %ebp
  800b59:	89 e5                	mov    %esp,%ebp
  800b5b:	83 ec 18             	sub    $0x18,%esp
	sys_lock_cons();
  800b5e:	e8 79 09 00 00       	call   8014dc <sys_lock_cons>
	{
		int i, c, echoing;

		if (prompt != NULL)
  800b63:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800b67:	74 13                	je     800b7c <atomic_readline+0x24>
			cprintf("%s", prompt);
  800b69:	83 ec 08             	sub    $0x8,%esp
  800b6c:	ff 75 08             	pushl  0x8(%ebp)
  800b6f:	68 e8 24 80 00       	push   $0x8024e8
  800b74:	e8 07 f8 ff ff       	call   800380 <cprintf>
  800b79:	83 c4 10             	add    $0x10,%esp

		i = 0;
  800b7c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
		echoing = iscons(0);
  800b83:	83 ec 0c             	sub    $0xc,%esp
  800b86:	6a 00                	push   $0x0
  800b88:	e8 7a 0f 00 00       	call   801b07 <iscons>
  800b8d:	83 c4 10             	add    $0x10,%esp
  800b90:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (1) {
			c = getchar();
  800b93:	e8 5c 0f 00 00       	call   801af4 <getchar>
  800b98:	89 45 ec             	mov    %eax,-0x14(%ebp)
			if (c < 0) {
  800b9b:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800b9f:	79 22                	jns    800bc3 <atomic_readline+0x6b>
				if (c != -E_EOF)
  800ba1:	83 7d ec 07          	cmpl   $0x7,-0x14(%ebp)
  800ba5:	0f 84 ad 00 00 00    	je     800c58 <atomic_readline+0x100>
					cprintf("read error: %e\n", c);
  800bab:	83 ec 08             	sub    $0x8,%esp
  800bae:	ff 75 ec             	pushl  -0x14(%ebp)
  800bb1:	68 eb 24 80 00       	push   $0x8024eb
  800bb6:	e8 c5 f7 ff ff       	call   800380 <cprintf>
  800bbb:	83 c4 10             	add    $0x10,%esp
				break;
  800bbe:	e9 95 00 00 00       	jmp    800c58 <atomic_readline+0x100>
			} else if (c >= ' ' && i < BUFLEN-1) {
  800bc3:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%ebp)
  800bc7:	7e 34                	jle    800bfd <atomic_readline+0xa5>
  800bc9:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  800bd0:	7f 2b                	jg     800bfd <atomic_readline+0xa5>
				if (echoing)
  800bd2:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800bd6:	74 0e                	je     800be6 <atomic_readline+0x8e>
					cputchar(c);
  800bd8:	83 ec 0c             	sub    $0xc,%esp
  800bdb:	ff 75 ec             	pushl  -0x14(%ebp)
  800bde:	e8 f2 0e 00 00       	call   801ad5 <cputchar>
  800be3:	83 c4 10             	add    $0x10,%esp
				buf[i++] = c;
  800be6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800be9:	8d 50 01             	lea    0x1(%eax),%edx
  800bec:	89 55 f4             	mov    %edx,-0xc(%ebp)
  800bef:	89 c2                	mov    %eax,%edx
  800bf1:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bf4:	01 d0                	add    %edx,%eax
  800bf6:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800bf9:	88 10                	mov    %dl,(%eax)
  800bfb:	eb 56                	jmp    800c53 <atomic_readline+0xfb>
			} else if (c == '\b' && i > 0) {
  800bfd:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  800c01:	75 1f                	jne    800c22 <atomic_readline+0xca>
  800c03:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  800c07:	7e 19                	jle    800c22 <atomic_readline+0xca>
				if (echoing)
  800c09:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800c0d:	74 0e                	je     800c1d <atomic_readline+0xc5>
					cputchar(c);
  800c0f:	83 ec 0c             	sub    $0xc,%esp
  800c12:	ff 75 ec             	pushl  -0x14(%ebp)
  800c15:	e8 bb 0e 00 00       	call   801ad5 <cputchar>
  800c1a:	83 c4 10             	add    $0x10,%esp
				i--;
  800c1d:	ff 4d f4             	decl   -0xc(%ebp)
  800c20:	eb 31                	jmp    800c53 <atomic_readline+0xfb>
			} else if (c == '\n' || c == '\r') {
  800c22:	83 7d ec 0a          	cmpl   $0xa,-0x14(%ebp)
  800c26:	74 0a                	je     800c32 <atomic_readline+0xda>
  800c28:	83 7d ec 0d          	cmpl   $0xd,-0x14(%ebp)
  800c2c:	0f 85 61 ff ff ff    	jne    800b93 <atomic_readline+0x3b>
				if (echoing)
  800c32:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800c36:	74 0e                	je     800c46 <atomic_readline+0xee>
					cputchar(c);
  800c38:	83 ec 0c             	sub    $0xc,%esp
  800c3b:	ff 75 ec             	pushl  -0x14(%ebp)
  800c3e:	e8 92 0e 00 00       	call   801ad5 <cputchar>
  800c43:	83 c4 10             	add    $0x10,%esp
				buf[i] = 0;
  800c46:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800c49:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c4c:	01 d0                	add    %edx,%eax
  800c4e:	c6 00 00             	movb   $0x0,(%eax)
				break;
  800c51:	eb 06                	jmp    800c59 <atomic_readline+0x101>
			}
		}
  800c53:	e9 3b ff ff ff       	jmp    800b93 <atomic_readline+0x3b>
		while (1) {
			c = getchar();
			if (c < 0) {
				if (c != -E_EOF)
					cprintf("read error: %e\n", c);
				break;
  800c58:	90                   	nop
				buf[i] = 0;
				break;
			}
		}
	}
	sys_unlock_cons();
  800c59:	e8 98 08 00 00       	call   8014f6 <sys_unlock_cons>
}
  800c5e:	90                   	nop
  800c5f:	c9                   	leave  
  800c60:	c3                   	ret    

00800c61 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800c61:	55                   	push   %ebp
  800c62:	89 e5                	mov    %esp,%ebp
  800c64:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800c67:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800c6e:	eb 06                	jmp    800c76 <strlen+0x15>
		n++;
  800c70:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800c73:	ff 45 08             	incl   0x8(%ebp)
  800c76:	8b 45 08             	mov    0x8(%ebp),%eax
  800c79:	8a 00                	mov    (%eax),%al
  800c7b:	84 c0                	test   %al,%al
  800c7d:	75 f1                	jne    800c70 <strlen+0xf>
		n++;
	return n;
  800c7f:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800c82:	c9                   	leave  
  800c83:	c3                   	ret    

00800c84 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800c84:	55                   	push   %ebp
  800c85:	89 e5                	mov    %esp,%ebp
  800c87:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800c8a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800c91:	eb 09                	jmp    800c9c <strnlen+0x18>
		n++;
  800c93:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800c96:	ff 45 08             	incl   0x8(%ebp)
  800c99:	ff 4d 0c             	decl   0xc(%ebp)
  800c9c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800ca0:	74 09                	je     800cab <strnlen+0x27>
  800ca2:	8b 45 08             	mov    0x8(%ebp),%eax
  800ca5:	8a 00                	mov    (%eax),%al
  800ca7:	84 c0                	test   %al,%al
  800ca9:	75 e8                	jne    800c93 <strnlen+0xf>
		n++;
	return n;
  800cab:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800cae:	c9                   	leave  
  800caf:	c3                   	ret    

00800cb0 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800cb0:	55                   	push   %ebp
  800cb1:	89 e5                	mov    %esp,%ebp
  800cb3:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800cb6:	8b 45 08             	mov    0x8(%ebp),%eax
  800cb9:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800cbc:	90                   	nop
  800cbd:	8b 45 08             	mov    0x8(%ebp),%eax
  800cc0:	8d 50 01             	lea    0x1(%eax),%edx
  800cc3:	89 55 08             	mov    %edx,0x8(%ebp)
  800cc6:	8b 55 0c             	mov    0xc(%ebp),%edx
  800cc9:	8d 4a 01             	lea    0x1(%edx),%ecx
  800ccc:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800ccf:	8a 12                	mov    (%edx),%dl
  800cd1:	88 10                	mov    %dl,(%eax)
  800cd3:	8a 00                	mov    (%eax),%al
  800cd5:	84 c0                	test   %al,%al
  800cd7:	75 e4                	jne    800cbd <strcpy+0xd>
		/* do nothing */;
	return ret;
  800cd9:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800cdc:	c9                   	leave  
  800cdd:	c3                   	ret    

00800cde <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800cde:	55                   	push   %ebp
  800cdf:	89 e5                	mov    %esp,%ebp
  800ce1:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800ce4:	8b 45 08             	mov    0x8(%ebp),%eax
  800ce7:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800cea:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800cf1:	eb 1f                	jmp    800d12 <strncpy+0x34>
		*dst++ = *src;
  800cf3:	8b 45 08             	mov    0x8(%ebp),%eax
  800cf6:	8d 50 01             	lea    0x1(%eax),%edx
  800cf9:	89 55 08             	mov    %edx,0x8(%ebp)
  800cfc:	8b 55 0c             	mov    0xc(%ebp),%edx
  800cff:	8a 12                	mov    (%edx),%dl
  800d01:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800d03:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d06:	8a 00                	mov    (%eax),%al
  800d08:	84 c0                	test   %al,%al
  800d0a:	74 03                	je     800d0f <strncpy+0x31>
			src++;
  800d0c:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800d0f:	ff 45 fc             	incl   -0x4(%ebp)
  800d12:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d15:	3b 45 10             	cmp    0x10(%ebp),%eax
  800d18:	72 d9                	jb     800cf3 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800d1a:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800d1d:	c9                   	leave  
  800d1e:	c3                   	ret    

00800d1f <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800d1f:	55                   	push   %ebp
  800d20:	89 e5                	mov    %esp,%ebp
  800d22:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800d25:	8b 45 08             	mov    0x8(%ebp),%eax
  800d28:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800d2b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d2f:	74 30                	je     800d61 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800d31:	eb 16                	jmp    800d49 <strlcpy+0x2a>
			*dst++ = *src++;
  800d33:	8b 45 08             	mov    0x8(%ebp),%eax
  800d36:	8d 50 01             	lea    0x1(%eax),%edx
  800d39:	89 55 08             	mov    %edx,0x8(%ebp)
  800d3c:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d3f:	8d 4a 01             	lea    0x1(%edx),%ecx
  800d42:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800d45:	8a 12                	mov    (%edx),%dl
  800d47:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800d49:	ff 4d 10             	decl   0x10(%ebp)
  800d4c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d50:	74 09                	je     800d5b <strlcpy+0x3c>
  800d52:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d55:	8a 00                	mov    (%eax),%al
  800d57:	84 c0                	test   %al,%al
  800d59:	75 d8                	jne    800d33 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800d5b:	8b 45 08             	mov    0x8(%ebp),%eax
  800d5e:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800d61:	8b 55 08             	mov    0x8(%ebp),%edx
  800d64:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d67:	29 c2                	sub    %eax,%edx
  800d69:	89 d0                	mov    %edx,%eax
}
  800d6b:	c9                   	leave  
  800d6c:	c3                   	ret    

00800d6d <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800d6d:	55                   	push   %ebp
  800d6e:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800d70:	eb 06                	jmp    800d78 <strcmp+0xb>
		p++, q++;
  800d72:	ff 45 08             	incl   0x8(%ebp)
  800d75:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800d78:	8b 45 08             	mov    0x8(%ebp),%eax
  800d7b:	8a 00                	mov    (%eax),%al
  800d7d:	84 c0                	test   %al,%al
  800d7f:	74 0e                	je     800d8f <strcmp+0x22>
  800d81:	8b 45 08             	mov    0x8(%ebp),%eax
  800d84:	8a 10                	mov    (%eax),%dl
  800d86:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d89:	8a 00                	mov    (%eax),%al
  800d8b:	38 c2                	cmp    %al,%dl
  800d8d:	74 e3                	je     800d72 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800d8f:	8b 45 08             	mov    0x8(%ebp),%eax
  800d92:	8a 00                	mov    (%eax),%al
  800d94:	0f b6 d0             	movzbl %al,%edx
  800d97:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d9a:	8a 00                	mov    (%eax),%al
  800d9c:	0f b6 c0             	movzbl %al,%eax
  800d9f:	29 c2                	sub    %eax,%edx
  800da1:	89 d0                	mov    %edx,%eax
}
  800da3:	5d                   	pop    %ebp
  800da4:	c3                   	ret    

00800da5 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800da5:	55                   	push   %ebp
  800da6:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800da8:	eb 09                	jmp    800db3 <strncmp+0xe>
		n--, p++, q++;
  800daa:	ff 4d 10             	decl   0x10(%ebp)
  800dad:	ff 45 08             	incl   0x8(%ebp)
  800db0:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800db3:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800db7:	74 17                	je     800dd0 <strncmp+0x2b>
  800db9:	8b 45 08             	mov    0x8(%ebp),%eax
  800dbc:	8a 00                	mov    (%eax),%al
  800dbe:	84 c0                	test   %al,%al
  800dc0:	74 0e                	je     800dd0 <strncmp+0x2b>
  800dc2:	8b 45 08             	mov    0x8(%ebp),%eax
  800dc5:	8a 10                	mov    (%eax),%dl
  800dc7:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dca:	8a 00                	mov    (%eax),%al
  800dcc:	38 c2                	cmp    %al,%dl
  800dce:	74 da                	je     800daa <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800dd0:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800dd4:	75 07                	jne    800ddd <strncmp+0x38>
		return 0;
  800dd6:	b8 00 00 00 00       	mov    $0x0,%eax
  800ddb:	eb 14                	jmp    800df1 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800ddd:	8b 45 08             	mov    0x8(%ebp),%eax
  800de0:	8a 00                	mov    (%eax),%al
  800de2:	0f b6 d0             	movzbl %al,%edx
  800de5:	8b 45 0c             	mov    0xc(%ebp),%eax
  800de8:	8a 00                	mov    (%eax),%al
  800dea:	0f b6 c0             	movzbl %al,%eax
  800ded:	29 c2                	sub    %eax,%edx
  800def:	89 d0                	mov    %edx,%eax
}
  800df1:	5d                   	pop    %ebp
  800df2:	c3                   	ret    

00800df3 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800df3:	55                   	push   %ebp
  800df4:	89 e5                	mov    %esp,%ebp
  800df6:	83 ec 04             	sub    $0x4,%esp
  800df9:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dfc:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800dff:	eb 12                	jmp    800e13 <strchr+0x20>
		if (*s == c)
  800e01:	8b 45 08             	mov    0x8(%ebp),%eax
  800e04:	8a 00                	mov    (%eax),%al
  800e06:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800e09:	75 05                	jne    800e10 <strchr+0x1d>
			return (char *) s;
  800e0b:	8b 45 08             	mov    0x8(%ebp),%eax
  800e0e:	eb 11                	jmp    800e21 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800e10:	ff 45 08             	incl   0x8(%ebp)
  800e13:	8b 45 08             	mov    0x8(%ebp),%eax
  800e16:	8a 00                	mov    (%eax),%al
  800e18:	84 c0                	test   %al,%al
  800e1a:	75 e5                	jne    800e01 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800e1c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800e21:	c9                   	leave  
  800e22:	c3                   	ret    

00800e23 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800e23:	55                   	push   %ebp
  800e24:	89 e5                	mov    %esp,%ebp
  800e26:	83 ec 04             	sub    $0x4,%esp
  800e29:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e2c:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800e2f:	eb 0d                	jmp    800e3e <strfind+0x1b>
		if (*s == c)
  800e31:	8b 45 08             	mov    0x8(%ebp),%eax
  800e34:	8a 00                	mov    (%eax),%al
  800e36:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800e39:	74 0e                	je     800e49 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800e3b:	ff 45 08             	incl   0x8(%ebp)
  800e3e:	8b 45 08             	mov    0x8(%ebp),%eax
  800e41:	8a 00                	mov    (%eax),%al
  800e43:	84 c0                	test   %al,%al
  800e45:	75 ea                	jne    800e31 <strfind+0xe>
  800e47:	eb 01                	jmp    800e4a <strfind+0x27>
		if (*s == c)
			break;
  800e49:	90                   	nop
	return (char *) s;
  800e4a:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e4d:	c9                   	leave  
  800e4e:	c3                   	ret    

00800e4f <memset>:

// *************** The faster implementation of memset & memcpy is implemented by *************
// ****************** Team80 (Yahia Khaled, Malek Ahmed et al) - FCIS'24-25 *******************
void *
memset(void *v, int c, uint32 n)
{
  800e4f:	55                   	push   %ebp
  800e50:	89 e5                	mov    %esp,%ebp
  800e52:	83 ec 10             	sub    $0x10,%esp
//	m = n;
//	while (--m >= 0)
//		*p++ = c;

	/*Faster Implementation*/
	uint64* p64 = (uint64*)v;
  800e55:	8b 45 08             	mov    0x8(%ebp),%eax
  800e58:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if(n >= 8){
  800e5b:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800e5f:	76 63                	jbe    800ec4 <memset+0x75>
		uint64 data_block = c;
  800e61:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e64:	99                   	cltd   
  800e65:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800e68:	89 55 f4             	mov    %edx,-0xc(%ebp)
		data_block |= data_block << 8;
  800e6b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800e6e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800e71:	0f a4 c2 08          	shld   $0x8,%eax,%edx
  800e75:	c1 e0 08             	shl    $0x8,%eax
  800e78:	09 45 f0             	or     %eax,-0x10(%ebp)
  800e7b:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 16;
  800e7e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800e81:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800e84:	0f a4 c2 10          	shld   $0x10,%eax,%edx
  800e88:	c1 e0 10             	shl    $0x10,%eax
  800e8b:	09 45 f0             	or     %eax,-0x10(%ebp)
  800e8e:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 32;
  800e91:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800e94:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800e97:	89 c2                	mov    %eax,%edx
  800e99:	b8 00 00 00 00       	mov    $0x0,%eax
  800e9e:	09 45 f0             	or     %eax,-0x10(%ebp)
  800ea1:	09 55 f4             	or     %edx,-0xc(%ebp)

		while(n >= 8)
  800ea4:	eb 18                	jmp    800ebe <memset+0x6f>
			*p64++ = data_block, n -= 8;
  800ea6:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  800ea9:	8d 41 08             	lea    0x8(%ecx),%eax
  800eac:	89 45 fc             	mov    %eax,-0x4(%ebp)
  800eaf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800eb2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800eb5:	89 01                	mov    %eax,(%ecx)
  800eb7:	89 51 04             	mov    %edx,0x4(%ecx)
  800eba:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
		uint64 data_block = c;
		data_block |= data_block << 8;
		data_block |= data_block << 16;
		data_block |= data_block << 32;

		while(n >= 8)
  800ebe:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800ec2:	77 e2                	ja     800ea6 <memset+0x57>
			*p64++ = data_block, n -= 8;
	}

	if(n){
  800ec4:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ec8:	74 23                	je     800eed <memset+0x9e>
		uint8* p8 = (uint8*)p64;
  800eca:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ecd:	89 45 f8             	mov    %eax,-0x8(%ebp)
		while (n-- > 0)
  800ed0:	eb 0e                	jmp    800ee0 <memset+0x91>
			*p8++ = (uint8)c;
  800ed2:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800ed5:	8d 50 01             	lea    0x1(%eax),%edx
  800ed8:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800edb:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ede:	88 10                	mov    %dl,(%eax)
			*p64++ = data_block, n -= 8;
	}

	if(n){
		uint8* p8 = (uint8*)p64;
		while (n-- > 0)
  800ee0:	8b 45 10             	mov    0x10(%ebp),%eax
  800ee3:	8d 50 ff             	lea    -0x1(%eax),%edx
  800ee6:	89 55 10             	mov    %edx,0x10(%ebp)
  800ee9:	85 c0                	test   %eax,%eax
  800eeb:	75 e5                	jne    800ed2 <memset+0x83>
			*p8++ = (uint8)c;
	}

	return v;
  800eed:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800ef0:	c9                   	leave  
  800ef1:	c3                   	ret    

00800ef2 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800ef2:	55                   	push   %ebp
  800ef3:	89 e5                	mov    %esp,%ebp
  800ef5:	83 ec 10             	sub    $0x10,%esp
	//	s = src;
	//	d = dst;
	//	while (n-- > 0)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
  800ef8:	8b 45 0c             	mov    0xc(%ebp),%eax
  800efb:	89 45 fc             	mov    %eax,-0x4(%ebp)
	uint64* d64 = (uint64*)dst;
  800efe:	8b 45 08             	mov    0x8(%ebp),%eax
  800f01:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if(n >= 8){
  800f04:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800f08:	76 24                	jbe    800f2e <memcpy+0x3c>
		while(n >= 8){
  800f0a:	eb 1c                	jmp    800f28 <memcpy+0x36>
			*d64 = *s64;
  800f0c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f0f:	8b 50 04             	mov    0x4(%eax),%edx
  800f12:	8b 00                	mov    (%eax),%eax
  800f14:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  800f17:	89 01                	mov    %eax,(%ecx)
  800f19:	89 51 04             	mov    %edx,0x4(%ecx)
			n -= 8;
  800f1c:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
			++s64;
  800f20:	83 45 fc 08          	addl   $0x8,-0x4(%ebp)
			++d64;
  800f24:	83 45 f8 08          	addl   $0x8,-0x8(%ebp)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
	uint64* d64 = (uint64*)dst;
	if(n >= 8){
		while(n >= 8){
  800f28:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800f2c:	77 de                	ja     800f0c <memcpy+0x1a>
			++s64;
			++d64;
		}
	}

	if(n){
  800f2e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f32:	74 31                	je     800f65 <memcpy+0x73>
		uint8* s8 = (uint8*)s64;
  800f34:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f37:	89 45 f4             	mov    %eax,-0xc(%ebp)
		uint8* d8 = (uint8*)d64;
  800f3a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f3d:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (n-- > 0)
  800f40:	eb 16                	jmp    800f58 <memcpy+0x66>
			*d8++ = *s8++;
  800f42:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800f45:	8d 50 01             	lea    0x1(%eax),%edx
  800f48:	89 55 f0             	mov    %edx,-0x10(%ebp)
  800f4b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800f4e:	8d 4a 01             	lea    0x1(%edx),%ecx
  800f51:	89 4d f4             	mov    %ecx,-0xc(%ebp)
  800f54:	8a 12                	mov    (%edx),%dl
  800f56:	88 10                	mov    %dl,(%eax)
	}

	if(n){
		uint8* s8 = (uint8*)s64;
		uint8* d8 = (uint8*)d64;
		while (n-- > 0)
  800f58:	8b 45 10             	mov    0x10(%ebp),%eax
  800f5b:	8d 50 ff             	lea    -0x1(%eax),%edx
  800f5e:	89 55 10             	mov    %edx,0x10(%ebp)
  800f61:	85 c0                	test   %eax,%eax
  800f63:	75 dd                	jne    800f42 <memcpy+0x50>
			*d8++ = *s8++;
	}
	return dst;
  800f65:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f68:	c9                   	leave  
  800f69:	c3                   	ret    

00800f6a <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800f6a:	55                   	push   %ebp
  800f6b:	89 e5                	mov    %esp,%ebp
  800f6d:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800f70:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f73:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800f76:	8b 45 08             	mov    0x8(%ebp),%eax
  800f79:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800f7c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f7f:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800f82:	73 50                	jae    800fd4 <memmove+0x6a>
  800f84:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800f87:	8b 45 10             	mov    0x10(%ebp),%eax
  800f8a:	01 d0                	add    %edx,%eax
  800f8c:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800f8f:	76 43                	jbe    800fd4 <memmove+0x6a>
		s += n;
  800f91:	8b 45 10             	mov    0x10(%ebp),%eax
  800f94:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800f97:	8b 45 10             	mov    0x10(%ebp),%eax
  800f9a:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800f9d:	eb 10                	jmp    800faf <memmove+0x45>
			*--d = *--s;
  800f9f:	ff 4d f8             	decl   -0x8(%ebp)
  800fa2:	ff 4d fc             	decl   -0x4(%ebp)
  800fa5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800fa8:	8a 10                	mov    (%eax),%dl
  800faa:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800fad:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800faf:	8b 45 10             	mov    0x10(%ebp),%eax
  800fb2:	8d 50 ff             	lea    -0x1(%eax),%edx
  800fb5:	89 55 10             	mov    %edx,0x10(%ebp)
  800fb8:	85 c0                	test   %eax,%eax
  800fba:	75 e3                	jne    800f9f <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800fbc:	eb 23                	jmp    800fe1 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800fbe:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800fc1:	8d 50 01             	lea    0x1(%eax),%edx
  800fc4:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800fc7:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800fca:	8d 4a 01             	lea    0x1(%edx),%ecx
  800fcd:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800fd0:	8a 12                	mov    (%edx),%dl
  800fd2:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800fd4:	8b 45 10             	mov    0x10(%ebp),%eax
  800fd7:	8d 50 ff             	lea    -0x1(%eax),%edx
  800fda:	89 55 10             	mov    %edx,0x10(%ebp)
  800fdd:	85 c0                	test   %eax,%eax
  800fdf:	75 dd                	jne    800fbe <memmove+0x54>
			*d++ = *s++;

	return dst;
  800fe1:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800fe4:	c9                   	leave  
  800fe5:	c3                   	ret    

00800fe6 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  800fe6:	55                   	push   %ebp
  800fe7:	89 e5                	mov    %esp,%ebp
  800fe9:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  800fec:	8b 45 08             	mov    0x8(%ebp),%eax
  800fef:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  800ff2:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ff5:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800ff8:	eb 2a                	jmp    801024 <memcmp+0x3e>
		if (*s1 != *s2)
  800ffa:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ffd:	8a 10                	mov    (%eax),%dl
  800fff:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801002:	8a 00                	mov    (%eax),%al
  801004:	38 c2                	cmp    %al,%dl
  801006:	74 16                	je     80101e <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  801008:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80100b:	8a 00                	mov    (%eax),%al
  80100d:	0f b6 d0             	movzbl %al,%edx
  801010:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801013:	8a 00                	mov    (%eax),%al
  801015:	0f b6 c0             	movzbl %al,%eax
  801018:	29 c2                	sub    %eax,%edx
  80101a:	89 d0                	mov    %edx,%eax
  80101c:	eb 18                	jmp    801036 <memcmp+0x50>
		s1++, s2++;
  80101e:	ff 45 fc             	incl   -0x4(%ebp)
  801021:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  801024:	8b 45 10             	mov    0x10(%ebp),%eax
  801027:	8d 50 ff             	lea    -0x1(%eax),%edx
  80102a:	89 55 10             	mov    %edx,0x10(%ebp)
  80102d:	85 c0                	test   %eax,%eax
  80102f:	75 c9                	jne    800ffa <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801031:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801036:	c9                   	leave  
  801037:	c3                   	ret    

00801038 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  801038:	55                   	push   %ebp
  801039:	89 e5                	mov    %esp,%ebp
  80103b:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  80103e:	8b 55 08             	mov    0x8(%ebp),%edx
  801041:	8b 45 10             	mov    0x10(%ebp),%eax
  801044:	01 d0                	add    %edx,%eax
  801046:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  801049:	eb 15                	jmp    801060 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  80104b:	8b 45 08             	mov    0x8(%ebp),%eax
  80104e:	8a 00                	mov    (%eax),%al
  801050:	0f b6 d0             	movzbl %al,%edx
  801053:	8b 45 0c             	mov    0xc(%ebp),%eax
  801056:	0f b6 c0             	movzbl %al,%eax
  801059:	39 c2                	cmp    %eax,%edx
  80105b:	74 0d                	je     80106a <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  80105d:	ff 45 08             	incl   0x8(%ebp)
  801060:	8b 45 08             	mov    0x8(%ebp),%eax
  801063:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801066:	72 e3                	jb     80104b <memfind+0x13>
  801068:	eb 01                	jmp    80106b <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  80106a:	90                   	nop
	return (void *) s;
  80106b:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80106e:	c9                   	leave  
  80106f:	c3                   	ret    

00801070 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801070:	55                   	push   %ebp
  801071:	89 e5                	mov    %esp,%ebp
  801073:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  801076:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  80107d:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801084:	eb 03                	jmp    801089 <strtol+0x19>
		s++;
  801086:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801089:	8b 45 08             	mov    0x8(%ebp),%eax
  80108c:	8a 00                	mov    (%eax),%al
  80108e:	3c 20                	cmp    $0x20,%al
  801090:	74 f4                	je     801086 <strtol+0x16>
  801092:	8b 45 08             	mov    0x8(%ebp),%eax
  801095:	8a 00                	mov    (%eax),%al
  801097:	3c 09                	cmp    $0x9,%al
  801099:	74 eb                	je     801086 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  80109b:	8b 45 08             	mov    0x8(%ebp),%eax
  80109e:	8a 00                	mov    (%eax),%al
  8010a0:	3c 2b                	cmp    $0x2b,%al
  8010a2:	75 05                	jne    8010a9 <strtol+0x39>
		s++;
  8010a4:	ff 45 08             	incl   0x8(%ebp)
  8010a7:	eb 13                	jmp    8010bc <strtol+0x4c>
	else if (*s == '-')
  8010a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8010ac:	8a 00                	mov    (%eax),%al
  8010ae:	3c 2d                	cmp    $0x2d,%al
  8010b0:	75 0a                	jne    8010bc <strtol+0x4c>
		s++, neg = 1;
  8010b2:	ff 45 08             	incl   0x8(%ebp)
  8010b5:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8010bc:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8010c0:	74 06                	je     8010c8 <strtol+0x58>
  8010c2:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  8010c6:	75 20                	jne    8010e8 <strtol+0x78>
  8010c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8010cb:	8a 00                	mov    (%eax),%al
  8010cd:	3c 30                	cmp    $0x30,%al
  8010cf:	75 17                	jne    8010e8 <strtol+0x78>
  8010d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8010d4:	40                   	inc    %eax
  8010d5:	8a 00                	mov    (%eax),%al
  8010d7:	3c 78                	cmp    $0x78,%al
  8010d9:	75 0d                	jne    8010e8 <strtol+0x78>
		s += 2, base = 16;
  8010db:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  8010df:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  8010e6:	eb 28                	jmp    801110 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  8010e8:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8010ec:	75 15                	jne    801103 <strtol+0x93>
  8010ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8010f1:	8a 00                	mov    (%eax),%al
  8010f3:	3c 30                	cmp    $0x30,%al
  8010f5:	75 0c                	jne    801103 <strtol+0x93>
		s++, base = 8;
  8010f7:	ff 45 08             	incl   0x8(%ebp)
  8010fa:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  801101:	eb 0d                	jmp    801110 <strtol+0xa0>
	else if (base == 0)
  801103:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801107:	75 07                	jne    801110 <strtol+0xa0>
		base = 10;
  801109:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801110:	8b 45 08             	mov    0x8(%ebp),%eax
  801113:	8a 00                	mov    (%eax),%al
  801115:	3c 2f                	cmp    $0x2f,%al
  801117:	7e 19                	jle    801132 <strtol+0xc2>
  801119:	8b 45 08             	mov    0x8(%ebp),%eax
  80111c:	8a 00                	mov    (%eax),%al
  80111e:	3c 39                	cmp    $0x39,%al
  801120:	7f 10                	jg     801132 <strtol+0xc2>
			dig = *s - '0';
  801122:	8b 45 08             	mov    0x8(%ebp),%eax
  801125:	8a 00                	mov    (%eax),%al
  801127:	0f be c0             	movsbl %al,%eax
  80112a:	83 e8 30             	sub    $0x30,%eax
  80112d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801130:	eb 42                	jmp    801174 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  801132:	8b 45 08             	mov    0x8(%ebp),%eax
  801135:	8a 00                	mov    (%eax),%al
  801137:	3c 60                	cmp    $0x60,%al
  801139:	7e 19                	jle    801154 <strtol+0xe4>
  80113b:	8b 45 08             	mov    0x8(%ebp),%eax
  80113e:	8a 00                	mov    (%eax),%al
  801140:	3c 7a                	cmp    $0x7a,%al
  801142:	7f 10                	jg     801154 <strtol+0xe4>
			dig = *s - 'a' + 10;
  801144:	8b 45 08             	mov    0x8(%ebp),%eax
  801147:	8a 00                	mov    (%eax),%al
  801149:	0f be c0             	movsbl %al,%eax
  80114c:	83 e8 57             	sub    $0x57,%eax
  80114f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801152:	eb 20                	jmp    801174 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  801154:	8b 45 08             	mov    0x8(%ebp),%eax
  801157:	8a 00                	mov    (%eax),%al
  801159:	3c 40                	cmp    $0x40,%al
  80115b:	7e 39                	jle    801196 <strtol+0x126>
  80115d:	8b 45 08             	mov    0x8(%ebp),%eax
  801160:	8a 00                	mov    (%eax),%al
  801162:	3c 5a                	cmp    $0x5a,%al
  801164:	7f 30                	jg     801196 <strtol+0x126>
			dig = *s - 'A' + 10;
  801166:	8b 45 08             	mov    0x8(%ebp),%eax
  801169:	8a 00                	mov    (%eax),%al
  80116b:	0f be c0             	movsbl %al,%eax
  80116e:	83 e8 37             	sub    $0x37,%eax
  801171:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  801174:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801177:	3b 45 10             	cmp    0x10(%ebp),%eax
  80117a:	7d 19                	jge    801195 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  80117c:	ff 45 08             	incl   0x8(%ebp)
  80117f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801182:	0f af 45 10          	imul   0x10(%ebp),%eax
  801186:	89 c2                	mov    %eax,%edx
  801188:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80118b:	01 d0                	add    %edx,%eax
  80118d:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  801190:	e9 7b ff ff ff       	jmp    801110 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801195:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801196:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80119a:	74 08                	je     8011a4 <strtol+0x134>
		*endptr = (char *) s;
  80119c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80119f:	8b 55 08             	mov    0x8(%ebp),%edx
  8011a2:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  8011a4:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8011a8:	74 07                	je     8011b1 <strtol+0x141>
  8011aa:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011ad:	f7 d8                	neg    %eax
  8011af:	eb 03                	jmp    8011b4 <strtol+0x144>
  8011b1:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8011b4:	c9                   	leave  
  8011b5:	c3                   	ret    

008011b6 <ltostr>:

void
ltostr(long value, char *str)
{
  8011b6:	55                   	push   %ebp
  8011b7:	89 e5                	mov    %esp,%ebp
  8011b9:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  8011bc:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  8011c3:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  8011ca:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8011ce:	79 13                	jns    8011e3 <ltostr+0x2d>
	{
		neg = 1;
  8011d0:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  8011d7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011da:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  8011dd:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  8011e0:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  8011e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8011e6:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8011eb:	99                   	cltd   
  8011ec:	f7 f9                	idiv   %ecx
  8011ee:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  8011f1:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011f4:	8d 50 01             	lea    0x1(%eax),%edx
  8011f7:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8011fa:	89 c2                	mov    %eax,%edx
  8011fc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011ff:	01 d0                	add    %edx,%eax
  801201:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801204:	83 c2 30             	add    $0x30,%edx
  801207:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  801209:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80120c:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801211:	f7 e9                	imul   %ecx
  801213:	c1 fa 02             	sar    $0x2,%edx
  801216:	89 c8                	mov    %ecx,%eax
  801218:	c1 f8 1f             	sar    $0x1f,%eax
  80121b:	29 c2                	sub    %eax,%edx
  80121d:	89 d0                	mov    %edx,%eax
  80121f:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  801222:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801226:	75 bb                	jne    8011e3 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801228:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  80122f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801232:	48                   	dec    %eax
  801233:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801236:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80123a:	74 3d                	je     801279 <ltostr+0xc3>
		start = 1 ;
  80123c:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  801243:	eb 34                	jmp    801279 <ltostr+0xc3>
	{
		char tmp = str[start] ;
  801245:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801248:	8b 45 0c             	mov    0xc(%ebp),%eax
  80124b:	01 d0                	add    %edx,%eax
  80124d:	8a 00                	mov    (%eax),%al
  80124f:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801252:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801255:	8b 45 0c             	mov    0xc(%ebp),%eax
  801258:	01 c2                	add    %eax,%edx
  80125a:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  80125d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801260:	01 c8                	add    %ecx,%eax
  801262:	8a 00                	mov    (%eax),%al
  801264:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801266:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801269:	8b 45 0c             	mov    0xc(%ebp),%eax
  80126c:	01 c2                	add    %eax,%edx
  80126e:	8a 45 eb             	mov    -0x15(%ebp),%al
  801271:	88 02                	mov    %al,(%edx)
		start++ ;
  801273:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801276:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801279:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80127c:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80127f:	7c c4                	jl     801245 <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801281:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801284:	8b 45 0c             	mov    0xc(%ebp),%eax
  801287:	01 d0                	add    %edx,%eax
  801289:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  80128c:	90                   	nop
  80128d:	c9                   	leave  
  80128e:	c3                   	ret    

0080128f <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  80128f:	55                   	push   %ebp
  801290:	89 e5                	mov    %esp,%ebp
  801292:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801295:	ff 75 08             	pushl  0x8(%ebp)
  801298:	e8 c4 f9 ff ff       	call   800c61 <strlen>
  80129d:	83 c4 04             	add    $0x4,%esp
  8012a0:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  8012a3:	ff 75 0c             	pushl  0xc(%ebp)
  8012a6:	e8 b6 f9 ff ff       	call   800c61 <strlen>
  8012ab:	83 c4 04             	add    $0x4,%esp
  8012ae:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  8012b1:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  8012b8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8012bf:	eb 17                	jmp    8012d8 <strcconcat+0x49>
		final[s] = str1[s] ;
  8012c1:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8012c4:	8b 45 10             	mov    0x10(%ebp),%eax
  8012c7:	01 c2                	add    %eax,%edx
  8012c9:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8012cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8012cf:	01 c8                	add    %ecx,%eax
  8012d1:	8a 00                	mov    (%eax),%al
  8012d3:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  8012d5:	ff 45 fc             	incl   -0x4(%ebp)
  8012d8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8012db:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8012de:	7c e1                	jl     8012c1 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  8012e0:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  8012e7:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8012ee:	eb 1f                	jmp    80130f <strcconcat+0x80>
		final[s++] = str2[i] ;
  8012f0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8012f3:	8d 50 01             	lea    0x1(%eax),%edx
  8012f6:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8012f9:	89 c2                	mov    %eax,%edx
  8012fb:	8b 45 10             	mov    0x10(%ebp),%eax
  8012fe:	01 c2                	add    %eax,%edx
  801300:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801303:	8b 45 0c             	mov    0xc(%ebp),%eax
  801306:	01 c8                	add    %ecx,%eax
  801308:	8a 00                	mov    (%eax),%al
  80130a:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  80130c:	ff 45 f8             	incl   -0x8(%ebp)
  80130f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801312:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801315:	7c d9                	jl     8012f0 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801317:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80131a:	8b 45 10             	mov    0x10(%ebp),%eax
  80131d:	01 d0                	add    %edx,%eax
  80131f:	c6 00 00             	movb   $0x0,(%eax)
}
  801322:	90                   	nop
  801323:	c9                   	leave  
  801324:	c3                   	ret    

00801325 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801325:	55                   	push   %ebp
  801326:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801328:	8b 45 14             	mov    0x14(%ebp),%eax
  80132b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801331:	8b 45 14             	mov    0x14(%ebp),%eax
  801334:	8b 00                	mov    (%eax),%eax
  801336:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80133d:	8b 45 10             	mov    0x10(%ebp),%eax
  801340:	01 d0                	add    %edx,%eax
  801342:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801348:	eb 0c                	jmp    801356 <strsplit+0x31>
			*string++ = 0;
  80134a:	8b 45 08             	mov    0x8(%ebp),%eax
  80134d:	8d 50 01             	lea    0x1(%eax),%edx
  801350:	89 55 08             	mov    %edx,0x8(%ebp)
  801353:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801356:	8b 45 08             	mov    0x8(%ebp),%eax
  801359:	8a 00                	mov    (%eax),%al
  80135b:	84 c0                	test   %al,%al
  80135d:	74 18                	je     801377 <strsplit+0x52>
  80135f:	8b 45 08             	mov    0x8(%ebp),%eax
  801362:	8a 00                	mov    (%eax),%al
  801364:	0f be c0             	movsbl %al,%eax
  801367:	50                   	push   %eax
  801368:	ff 75 0c             	pushl  0xc(%ebp)
  80136b:	e8 83 fa ff ff       	call   800df3 <strchr>
  801370:	83 c4 08             	add    $0x8,%esp
  801373:	85 c0                	test   %eax,%eax
  801375:	75 d3                	jne    80134a <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801377:	8b 45 08             	mov    0x8(%ebp),%eax
  80137a:	8a 00                	mov    (%eax),%al
  80137c:	84 c0                	test   %al,%al
  80137e:	74 5a                	je     8013da <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801380:	8b 45 14             	mov    0x14(%ebp),%eax
  801383:	8b 00                	mov    (%eax),%eax
  801385:	83 f8 0f             	cmp    $0xf,%eax
  801388:	75 07                	jne    801391 <strsplit+0x6c>
		{
			return 0;
  80138a:	b8 00 00 00 00       	mov    $0x0,%eax
  80138f:	eb 66                	jmp    8013f7 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801391:	8b 45 14             	mov    0x14(%ebp),%eax
  801394:	8b 00                	mov    (%eax),%eax
  801396:	8d 48 01             	lea    0x1(%eax),%ecx
  801399:	8b 55 14             	mov    0x14(%ebp),%edx
  80139c:	89 0a                	mov    %ecx,(%edx)
  80139e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8013a5:	8b 45 10             	mov    0x10(%ebp),%eax
  8013a8:	01 c2                	add    %eax,%edx
  8013aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8013ad:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  8013af:	eb 03                	jmp    8013b4 <strsplit+0x8f>
			string++;
  8013b1:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  8013b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8013b7:	8a 00                	mov    (%eax),%al
  8013b9:	84 c0                	test   %al,%al
  8013bb:	74 8b                	je     801348 <strsplit+0x23>
  8013bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8013c0:	8a 00                	mov    (%eax),%al
  8013c2:	0f be c0             	movsbl %al,%eax
  8013c5:	50                   	push   %eax
  8013c6:	ff 75 0c             	pushl  0xc(%ebp)
  8013c9:	e8 25 fa ff ff       	call   800df3 <strchr>
  8013ce:	83 c4 08             	add    $0x8,%esp
  8013d1:	85 c0                	test   %eax,%eax
  8013d3:	74 dc                	je     8013b1 <strsplit+0x8c>
			string++;
	}
  8013d5:	e9 6e ff ff ff       	jmp    801348 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  8013da:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  8013db:	8b 45 14             	mov    0x14(%ebp),%eax
  8013de:	8b 00                	mov    (%eax),%eax
  8013e0:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8013e7:	8b 45 10             	mov    0x10(%ebp),%eax
  8013ea:	01 d0                	add    %edx,%eax
  8013ec:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  8013f2:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8013f7:	c9                   	leave  
  8013f8:	c3                   	ret    

008013f9 <str2lower>:


char* str2lower(char *dst, const char *src)
{
  8013f9:	55                   	push   %ebp
  8013fa:	89 e5                	mov    %esp,%ebp
  8013fc:	83 ec 10             	sub    $0x10,%esp
	char* ret = dst;
  8013ff:	8b 45 08             	mov    0x8(%ebp),%eax
  801402:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (int i = 0; i < strlen(src); ++i)
  801405:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80140c:	eb 4a                	jmp    801458 <str2lower+0x5f>
	{
		dst[i] = src[i] ;
  80140e:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801411:	8b 45 08             	mov    0x8(%ebp),%eax
  801414:	01 c2                	add    %eax,%edx
  801416:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801419:	8b 45 0c             	mov    0xc(%ebp),%eax
  80141c:	01 c8                	add    %ecx,%eax
  80141e:	8a 00                	mov    (%eax),%al
  801420:	88 02                	mov    %al,(%edx)
		if (src[i] >= 'A' && src[i] <= 'Z')
  801422:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801425:	8b 45 0c             	mov    0xc(%ebp),%eax
  801428:	01 d0                	add    %edx,%eax
  80142a:	8a 00                	mov    (%eax),%al
  80142c:	3c 40                	cmp    $0x40,%al
  80142e:	7e 25                	jle    801455 <str2lower+0x5c>
  801430:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801433:	8b 45 0c             	mov    0xc(%ebp),%eax
  801436:	01 d0                	add    %edx,%eax
  801438:	8a 00                	mov    (%eax),%al
  80143a:	3c 5a                	cmp    $0x5a,%al
  80143c:	7f 17                	jg     801455 <str2lower+0x5c>
		{
			dst[i] += 32 ;
  80143e:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801441:	8b 45 08             	mov    0x8(%ebp),%eax
  801444:	01 d0                	add    %edx,%eax
  801446:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801449:	8b 55 08             	mov    0x8(%ebp),%edx
  80144c:	01 ca                	add    %ecx,%edx
  80144e:	8a 12                	mov    (%edx),%dl
  801450:	83 c2 20             	add    $0x20,%edx
  801453:	88 10                	mov    %dl,(%eax)


char* str2lower(char *dst, const char *src)
{
	char* ret = dst;
	for (int i = 0; i < strlen(src); ++i)
  801455:	ff 45 fc             	incl   -0x4(%ebp)
  801458:	ff 75 0c             	pushl  0xc(%ebp)
  80145b:	e8 01 f8 ff ff       	call   800c61 <strlen>
  801460:	83 c4 04             	add    $0x4,%esp
  801463:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801466:	7f a6                	jg     80140e <str2lower+0x15>
		if (src[i] >= 'A' && src[i] <= 'Z')
		{
			dst[i] += 32 ;
		}
	}
	return ret;
  801468:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  80146b:	c9                   	leave  
  80146c:	c3                   	ret    

0080146d <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  80146d:	55                   	push   %ebp
  80146e:	89 e5                	mov    %esp,%ebp
  801470:	57                   	push   %edi
  801471:	56                   	push   %esi
  801472:	53                   	push   %ebx
  801473:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801476:	8b 45 08             	mov    0x8(%ebp),%eax
  801479:	8b 55 0c             	mov    0xc(%ebp),%edx
  80147c:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80147f:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801482:	8b 7d 18             	mov    0x18(%ebp),%edi
  801485:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801488:	cd 30                	int    $0x30
  80148a:	89 45 f0             	mov    %eax,-0x10(%ebp)
				"b" (a3),
				"D" (a4),
				"S" (a5)
				: "cc", "memory");

	return ret;
  80148d:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801490:	83 c4 10             	add    $0x10,%esp
  801493:	5b                   	pop    %ebx
  801494:	5e                   	pop    %esi
  801495:	5f                   	pop    %edi
  801496:	5d                   	pop    %ebp
  801497:	c3                   	ret    

00801498 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName, int color)
{
  801498:	55                   	push   %ebp
  801499:	89 e5                	mov    %esp,%ebp
  80149b:	83 ec 04             	sub    $0x4,%esp
  80149e:	8b 45 10             	mov    0x10(%ebp),%eax
  8014a1:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, color, 0);
  8014a4:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8014a7:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8014ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8014ae:	6a 00                	push   $0x0
  8014b0:	51                   	push   %ecx
  8014b1:	52                   	push   %edx
  8014b2:	ff 75 0c             	pushl  0xc(%ebp)
  8014b5:	50                   	push   %eax
  8014b6:	6a 00                	push   $0x0
  8014b8:	e8 b0 ff ff ff       	call   80146d <syscall>
  8014bd:	83 c4 18             	add    $0x18,%esp
}
  8014c0:	90                   	nop
  8014c1:	c9                   	leave  
  8014c2:	c3                   	ret    

008014c3 <sys_cgetc>:

int
sys_cgetc(void)
{
  8014c3:	55                   	push   %ebp
  8014c4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  8014c6:	6a 00                	push   $0x0
  8014c8:	6a 00                	push   $0x0
  8014ca:	6a 00                	push   $0x0
  8014cc:	6a 00                	push   $0x0
  8014ce:	6a 00                	push   $0x0
  8014d0:	6a 02                	push   $0x2
  8014d2:	e8 96 ff ff ff       	call   80146d <syscall>
  8014d7:	83 c4 18             	add    $0x18,%esp
}
  8014da:	c9                   	leave  
  8014db:	c3                   	ret    

008014dc <sys_lock_cons>:

void sys_lock_cons(void)
{
  8014dc:	55                   	push   %ebp
  8014dd:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  8014df:	6a 00                	push   $0x0
  8014e1:	6a 00                	push   $0x0
  8014e3:	6a 00                	push   $0x0
  8014e5:	6a 00                	push   $0x0
  8014e7:	6a 00                	push   $0x0
  8014e9:	6a 03                	push   $0x3
  8014eb:	e8 7d ff ff ff       	call   80146d <syscall>
  8014f0:	83 c4 18             	add    $0x18,%esp
}
  8014f3:	90                   	nop
  8014f4:	c9                   	leave  
  8014f5:	c3                   	ret    

008014f6 <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  8014f6:	55                   	push   %ebp
  8014f7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  8014f9:	6a 00                	push   $0x0
  8014fb:	6a 00                	push   $0x0
  8014fd:	6a 00                	push   $0x0
  8014ff:	6a 00                	push   $0x0
  801501:	6a 00                	push   $0x0
  801503:	6a 04                	push   $0x4
  801505:	e8 63 ff ff ff       	call   80146d <syscall>
  80150a:	83 c4 18             	add    $0x18,%esp
}
  80150d:	90                   	nop
  80150e:	c9                   	leave  
  80150f:	c3                   	ret    

00801510 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801510:	55                   	push   %ebp
  801511:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801513:	8b 55 0c             	mov    0xc(%ebp),%edx
  801516:	8b 45 08             	mov    0x8(%ebp),%eax
  801519:	6a 00                	push   $0x0
  80151b:	6a 00                	push   $0x0
  80151d:	6a 00                	push   $0x0
  80151f:	52                   	push   %edx
  801520:	50                   	push   %eax
  801521:	6a 08                	push   $0x8
  801523:	e8 45 ff ff ff       	call   80146d <syscall>
  801528:	83 c4 18             	add    $0x18,%esp
}
  80152b:	c9                   	leave  
  80152c:	c3                   	ret    

0080152d <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  80152d:	55                   	push   %ebp
  80152e:	89 e5                	mov    %esp,%ebp
  801530:	56                   	push   %esi
  801531:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801532:	8b 75 18             	mov    0x18(%ebp),%esi
  801535:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801538:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80153b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80153e:	8b 45 08             	mov    0x8(%ebp),%eax
  801541:	56                   	push   %esi
  801542:	53                   	push   %ebx
  801543:	51                   	push   %ecx
  801544:	52                   	push   %edx
  801545:	50                   	push   %eax
  801546:	6a 09                	push   $0x9
  801548:	e8 20 ff ff ff       	call   80146d <syscall>
  80154d:	83 c4 18             	add    $0x18,%esp
}
  801550:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801553:	5b                   	pop    %ebx
  801554:	5e                   	pop    %esi
  801555:	5d                   	pop    %ebp
  801556:	c3                   	ret    

00801557 <__sys_unmap_frame>:

int __sys_unmap_frame(uint32 va)
{
  801557:	55                   	push   %ebp
  801558:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, va, 0, 0, 0, 0);
  80155a:	6a 00                	push   $0x0
  80155c:	6a 00                	push   $0x0
  80155e:	6a 00                	push   $0x0
  801560:	6a 00                	push   $0x0
  801562:	ff 75 08             	pushl  0x8(%ebp)
  801565:	6a 0a                	push   $0xa
  801567:	e8 01 ff ff ff       	call   80146d <syscall>
  80156c:	83 c4 18             	add    $0x18,%esp
}
  80156f:	c9                   	leave  
  801570:	c3                   	ret    

00801571 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801571:	55                   	push   %ebp
  801572:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801574:	6a 00                	push   $0x0
  801576:	6a 00                	push   $0x0
  801578:	6a 00                	push   $0x0
  80157a:	ff 75 0c             	pushl  0xc(%ebp)
  80157d:	ff 75 08             	pushl  0x8(%ebp)
  801580:	6a 0b                	push   $0xb
  801582:	e8 e6 fe ff ff       	call   80146d <syscall>
  801587:	83 c4 18             	add    $0x18,%esp
}
  80158a:	c9                   	leave  
  80158b:	c3                   	ret    

0080158c <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  80158c:	55                   	push   %ebp
  80158d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  80158f:	6a 00                	push   $0x0
  801591:	6a 00                	push   $0x0
  801593:	6a 00                	push   $0x0
  801595:	6a 00                	push   $0x0
  801597:	6a 00                	push   $0x0
  801599:	6a 0c                	push   $0xc
  80159b:	e8 cd fe ff ff       	call   80146d <syscall>
  8015a0:	83 c4 18             	add    $0x18,%esp
}
  8015a3:	c9                   	leave  
  8015a4:	c3                   	ret    

008015a5 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  8015a5:	55                   	push   %ebp
  8015a6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  8015a8:	6a 00                	push   $0x0
  8015aa:	6a 00                	push   $0x0
  8015ac:	6a 00                	push   $0x0
  8015ae:	6a 00                	push   $0x0
  8015b0:	6a 00                	push   $0x0
  8015b2:	6a 0d                	push   $0xd
  8015b4:	e8 b4 fe ff ff       	call   80146d <syscall>
  8015b9:	83 c4 18             	add    $0x18,%esp
}
  8015bc:	c9                   	leave  
  8015bd:	c3                   	ret    

008015be <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  8015be:	55                   	push   %ebp
  8015bf:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  8015c1:	6a 00                	push   $0x0
  8015c3:	6a 00                	push   $0x0
  8015c5:	6a 00                	push   $0x0
  8015c7:	6a 00                	push   $0x0
  8015c9:	6a 00                	push   $0x0
  8015cb:	6a 0e                	push   $0xe
  8015cd:	e8 9b fe ff ff       	call   80146d <syscall>
  8015d2:	83 c4 18             	add    $0x18,%esp
}
  8015d5:	c9                   	leave  
  8015d6:	c3                   	ret    

008015d7 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  8015d7:	55                   	push   %ebp
  8015d8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  8015da:	6a 00                	push   $0x0
  8015dc:	6a 00                	push   $0x0
  8015de:	6a 00                	push   $0x0
  8015e0:	6a 00                	push   $0x0
  8015e2:	6a 00                	push   $0x0
  8015e4:	6a 0f                	push   $0xf
  8015e6:	e8 82 fe ff ff       	call   80146d <syscall>
  8015eb:	83 c4 18             	add    $0x18,%esp
}
  8015ee:	c9                   	leave  
  8015ef:	c3                   	ret    

008015f0 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  8015f0:	55                   	push   %ebp
  8015f1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  8015f3:	6a 00                	push   $0x0
  8015f5:	6a 00                	push   $0x0
  8015f7:	6a 00                	push   $0x0
  8015f9:	6a 00                	push   $0x0
  8015fb:	ff 75 08             	pushl  0x8(%ebp)
  8015fe:	6a 10                	push   $0x10
  801600:	e8 68 fe ff ff       	call   80146d <syscall>
  801605:	83 c4 18             	add    $0x18,%esp
}
  801608:	c9                   	leave  
  801609:	c3                   	ret    

0080160a <sys_scarce_memory>:

void sys_scarce_memory()
{
  80160a:	55                   	push   %ebp
  80160b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  80160d:	6a 00                	push   $0x0
  80160f:	6a 00                	push   $0x0
  801611:	6a 00                	push   $0x0
  801613:	6a 00                	push   $0x0
  801615:	6a 00                	push   $0x0
  801617:	6a 11                	push   $0x11
  801619:	e8 4f fe ff ff       	call   80146d <syscall>
  80161e:	83 c4 18             	add    $0x18,%esp
}
  801621:	90                   	nop
  801622:	c9                   	leave  
  801623:	c3                   	ret    

00801624 <sys_cputc>:

void
sys_cputc(const char c)
{
  801624:	55                   	push   %ebp
  801625:	89 e5                	mov    %esp,%ebp
  801627:	83 ec 04             	sub    $0x4,%esp
  80162a:	8b 45 08             	mov    0x8(%ebp),%eax
  80162d:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801630:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801634:	6a 00                	push   $0x0
  801636:	6a 00                	push   $0x0
  801638:	6a 00                	push   $0x0
  80163a:	6a 00                	push   $0x0
  80163c:	50                   	push   %eax
  80163d:	6a 01                	push   $0x1
  80163f:	e8 29 fe ff ff       	call   80146d <syscall>
  801644:	83 c4 18             	add    $0x18,%esp
}
  801647:	90                   	nop
  801648:	c9                   	leave  
  801649:	c3                   	ret    

0080164a <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  80164a:	55                   	push   %ebp
  80164b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  80164d:	6a 00                	push   $0x0
  80164f:	6a 00                	push   $0x0
  801651:	6a 00                	push   $0x0
  801653:	6a 00                	push   $0x0
  801655:	6a 00                	push   $0x0
  801657:	6a 14                	push   $0x14
  801659:	e8 0f fe ff ff       	call   80146d <syscall>
  80165e:	83 c4 18             	add    $0x18,%esp
}
  801661:	90                   	nop
  801662:	c9                   	leave  
  801663:	c3                   	ret    

00801664 <sys_create_shared_object>:

int sys_create_shared_object(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801664:	55                   	push   %ebp
  801665:	89 e5                	mov    %esp,%ebp
  801667:	83 ec 04             	sub    $0x4,%esp
  80166a:	8b 45 10             	mov    0x10(%ebp),%eax
  80166d:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801670:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801673:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801677:	8b 45 08             	mov    0x8(%ebp),%eax
  80167a:	6a 00                	push   $0x0
  80167c:	51                   	push   %ecx
  80167d:	52                   	push   %edx
  80167e:	ff 75 0c             	pushl  0xc(%ebp)
  801681:	50                   	push   %eax
  801682:	6a 15                	push   $0x15
  801684:	e8 e4 fd ff ff       	call   80146d <syscall>
  801689:	83 c4 18             	add    $0x18,%esp
}
  80168c:	c9                   	leave  
  80168d:	c3                   	ret    

0080168e <sys_size_of_shared_object>:

//2017:
int sys_size_of_shared_object(int32 ownerID, char* shareName)
{
  80168e:	55                   	push   %ebp
  80168f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801691:	8b 55 0c             	mov    0xc(%ebp),%edx
  801694:	8b 45 08             	mov    0x8(%ebp),%eax
  801697:	6a 00                	push   $0x0
  801699:	6a 00                	push   $0x0
  80169b:	6a 00                	push   $0x0
  80169d:	52                   	push   %edx
  80169e:	50                   	push   %eax
  80169f:	6a 16                	push   $0x16
  8016a1:	e8 c7 fd ff ff       	call   80146d <syscall>
  8016a6:	83 c4 18             	add    $0x18,%esp
}
  8016a9:	c9                   	leave  
  8016aa:	c3                   	ret    

008016ab <sys_get_shared_object>:
//==========

int sys_get_shared_object(int32 ownerID, char* shareName, void* virtual_address)
{
  8016ab:	55                   	push   %ebp
  8016ac:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  8016ae:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8016b1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8016b7:	6a 00                	push   $0x0
  8016b9:	6a 00                	push   $0x0
  8016bb:	51                   	push   %ecx
  8016bc:	52                   	push   %edx
  8016bd:	50                   	push   %eax
  8016be:	6a 17                	push   $0x17
  8016c0:	e8 a8 fd ff ff       	call   80146d <syscall>
  8016c5:	83 c4 18             	add    $0x18,%esp
}
  8016c8:	c9                   	leave  
  8016c9:	c3                   	ret    

008016ca <sys_delete_shared_object>:

int sys_delete_shared_object(int32 sharedObjectID, void *startVA)
{
  8016ca:	55                   	push   %ebp
  8016cb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  8016cd:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8016d3:	6a 00                	push   $0x0
  8016d5:	6a 00                	push   $0x0
  8016d7:	6a 00                	push   $0x0
  8016d9:	52                   	push   %edx
  8016da:	50                   	push   %eax
  8016db:	6a 18                	push   $0x18
  8016dd:	e8 8b fd ff ff       	call   80146d <syscall>
  8016e2:	83 c4 18             	add    $0x18,%esp
}
  8016e5:	c9                   	leave  
  8016e6:	c3                   	ret    

008016e7 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  8016e7:	55                   	push   %ebp
  8016e8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  8016ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8016ed:	6a 00                	push   $0x0
  8016ef:	ff 75 14             	pushl  0x14(%ebp)
  8016f2:	ff 75 10             	pushl  0x10(%ebp)
  8016f5:	ff 75 0c             	pushl  0xc(%ebp)
  8016f8:	50                   	push   %eax
  8016f9:	6a 19                	push   $0x19
  8016fb:	e8 6d fd ff ff       	call   80146d <syscall>
  801700:	83 c4 18             	add    $0x18,%esp
}
  801703:	c9                   	leave  
  801704:	c3                   	ret    

00801705 <sys_run_env>:

void sys_run_env(int32 envId)
{
  801705:	55                   	push   %ebp
  801706:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801708:	8b 45 08             	mov    0x8(%ebp),%eax
  80170b:	6a 00                	push   $0x0
  80170d:	6a 00                	push   $0x0
  80170f:	6a 00                	push   $0x0
  801711:	6a 00                	push   $0x0
  801713:	50                   	push   %eax
  801714:	6a 1a                	push   $0x1a
  801716:	e8 52 fd ff ff       	call   80146d <syscall>
  80171b:	83 c4 18             	add    $0x18,%esp
}
  80171e:	90                   	nop
  80171f:	c9                   	leave  
  801720:	c3                   	ret    

00801721 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801721:	55                   	push   %ebp
  801722:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801724:	8b 45 08             	mov    0x8(%ebp),%eax
  801727:	6a 00                	push   $0x0
  801729:	6a 00                	push   $0x0
  80172b:	6a 00                	push   $0x0
  80172d:	6a 00                	push   $0x0
  80172f:	50                   	push   %eax
  801730:	6a 1b                	push   $0x1b
  801732:	e8 36 fd ff ff       	call   80146d <syscall>
  801737:	83 c4 18             	add    $0x18,%esp
}
  80173a:	c9                   	leave  
  80173b:	c3                   	ret    

0080173c <sys_getenvid>:

int32 sys_getenvid(void)
{
  80173c:	55                   	push   %ebp
  80173d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  80173f:	6a 00                	push   $0x0
  801741:	6a 00                	push   $0x0
  801743:	6a 00                	push   $0x0
  801745:	6a 00                	push   $0x0
  801747:	6a 00                	push   $0x0
  801749:	6a 05                	push   $0x5
  80174b:	e8 1d fd ff ff       	call   80146d <syscall>
  801750:	83 c4 18             	add    $0x18,%esp
}
  801753:	c9                   	leave  
  801754:	c3                   	ret    

00801755 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801755:	55                   	push   %ebp
  801756:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801758:	6a 00                	push   $0x0
  80175a:	6a 00                	push   $0x0
  80175c:	6a 00                	push   $0x0
  80175e:	6a 00                	push   $0x0
  801760:	6a 00                	push   $0x0
  801762:	6a 06                	push   $0x6
  801764:	e8 04 fd ff ff       	call   80146d <syscall>
  801769:	83 c4 18             	add    $0x18,%esp
}
  80176c:	c9                   	leave  
  80176d:	c3                   	ret    

0080176e <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  80176e:	55                   	push   %ebp
  80176f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801771:	6a 00                	push   $0x0
  801773:	6a 00                	push   $0x0
  801775:	6a 00                	push   $0x0
  801777:	6a 00                	push   $0x0
  801779:	6a 00                	push   $0x0
  80177b:	6a 07                	push   $0x7
  80177d:	e8 eb fc ff ff       	call   80146d <syscall>
  801782:	83 c4 18             	add    $0x18,%esp
}
  801785:	c9                   	leave  
  801786:	c3                   	ret    

00801787 <sys_exit_env>:


void sys_exit_env(void)
{
  801787:	55                   	push   %ebp
  801788:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  80178a:	6a 00                	push   $0x0
  80178c:	6a 00                	push   $0x0
  80178e:	6a 00                	push   $0x0
  801790:	6a 00                	push   $0x0
  801792:	6a 00                	push   $0x0
  801794:	6a 1c                	push   $0x1c
  801796:	e8 d2 fc ff ff       	call   80146d <syscall>
  80179b:	83 c4 18             	add    $0x18,%esp
}
  80179e:	90                   	nop
  80179f:	c9                   	leave  
  8017a0:	c3                   	ret    

008017a1 <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  8017a1:	55                   	push   %ebp
  8017a2:	89 e5                	mov    %esp,%ebp
  8017a4:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  8017a7:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8017aa:	8d 50 04             	lea    0x4(%eax),%edx
  8017ad:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8017b0:	6a 00                	push   $0x0
  8017b2:	6a 00                	push   $0x0
  8017b4:	6a 00                	push   $0x0
  8017b6:	52                   	push   %edx
  8017b7:	50                   	push   %eax
  8017b8:	6a 1d                	push   $0x1d
  8017ba:	e8 ae fc ff ff       	call   80146d <syscall>
  8017bf:	83 c4 18             	add    $0x18,%esp
	return result;
  8017c2:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8017c5:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8017c8:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8017cb:	89 01                	mov    %eax,(%ecx)
  8017cd:	89 51 04             	mov    %edx,0x4(%ecx)
}
  8017d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8017d3:	c9                   	leave  
  8017d4:	c2 04 00             	ret    $0x4

008017d7 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  8017d7:	55                   	push   %ebp
  8017d8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  8017da:	6a 00                	push   $0x0
  8017dc:	6a 00                	push   $0x0
  8017de:	ff 75 10             	pushl  0x10(%ebp)
  8017e1:	ff 75 0c             	pushl  0xc(%ebp)
  8017e4:	ff 75 08             	pushl  0x8(%ebp)
  8017e7:	6a 13                	push   $0x13
  8017e9:	e8 7f fc ff ff       	call   80146d <syscall>
  8017ee:	83 c4 18             	add    $0x18,%esp
	return ;
  8017f1:	90                   	nop
}
  8017f2:	c9                   	leave  
  8017f3:	c3                   	ret    

008017f4 <sys_rcr2>:
uint32 sys_rcr2()
{
  8017f4:	55                   	push   %ebp
  8017f5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  8017f7:	6a 00                	push   $0x0
  8017f9:	6a 00                	push   $0x0
  8017fb:	6a 00                	push   $0x0
  8017fd:	6a 00                	push   $0x0
  8017ff:	6a 00                	push   $0x0
  801801:	6a 1e                	push   $0x1e
  801803:	e8 65 fc ff ff       	call   80146d <syscall>
  801808:	83 c4 18             	add    $0x18,%esp
}
  80180b:	c9                   	leave  
  80180c:	c3                   	ret    

0080180d <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  80180d:	55                   	push   %ebp
  80180e:	89 e5                	mov    %esp,%ebp
  801810:	83 ec 04             	sub    $0x4,%esp
  801813:	8b 45 08             	mov    0x8(%ebp),%eax
  801816:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801819:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  80181d:	6a 00                	push   $0x0
  80181f:	6a 00                	push   $0x0
  801821:	6a 00                	push   $0x0
  801823:	6a 00                	push   $0x0
  801825:	50                   	push   %eax
  801826:	6a 1f                	push   $0x1f
  801828:	e8 40 fc ff ff       	call   80146d <syscall>
  80182d:	83 c4 18             	add    $0x18,%esp
	return ;
  801830:	90                   	nop
}
  801831:	c9                   	leave  
  801832:	c3                   	ret    

00801833 <rsttst>:
void rsttst()
{
  801833:	55                   	push   %ebp
  801834:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801836:	6a 00                	push   $0x0
  801838:	6a 00                	push   $0x0
  80183a:	6a 00                	push   $0x0
  80183c:	6a 00                	push   $0x0
  80183e:	6a 00                	push   $0x0
  801840:	6a 21                	push   $0x21
  801842:	e8 26 fc ff ff       	call   80146d <syscall>
  801847:	83 c4 18             	add    $0x18,%esp
	return ;
  80184a:	90                   	nop
}
  80184b:	c9                   	leave  
  80184c:	c3                   	ret    

0080184d <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  80184d:	55                   	push   %ebp
  80184e:	89 e5                	mov    %esp,%ebp
  801850:	83 ec 04             	sub    $0x4,%esp
  801853:	8b 45 14             	mov    0x14(%ebp),%eax
  801856:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801859:	8b 55 18             	mov    0x18(%ebp),%edx
  80185c:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801860:	52                   	push   %edx
  801861:	50                   	push   %eax
  801862:	ff 75 10             	pushl  0x10(%ebp)
  801865:	ff 75 0c             	pushl  0xc(%ebp)
  801868:	ff 75 08             	pushl  0x8(%ebp)
  80186b:	6a 20                	push   $0x20
  80186d:	e8 fb fb ff ff       	call   80146d <syscall>
  801872:	83 c4 18             	add    $0x18,%esp
	return ;
  801875:	90                   	nop
}
  801876:	c9                   	leave  
  801877:	c3                   	ret    

00801878 <chktst>:
void chktst(uint32 n)
{
  801878:	55                   	push   %ebp
  801879:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  80187b:	6a 00                	push   $0x0
  80187d:	6a 00                	push   $0x0
  80187f:	6a 00                	push   $0x0
  801881:	6a 00                	push   $0x0
  801883:	ff 75 08             	pushl  0x8(%ebp)
  801886:	6a 22                	push   $0x22
  801888:	e8 e0 fb ff ff       	call   80146d <syscall>
  80188d:	83 c4 18             	add    $0x18,%esp
	return ;
  801890:	90                   	nop
}
  801891:	c9                   	leave  
  801892:	c3                   	ret    

00801893 <inctst>:

void inctst()
{
  801893:	55                   	push   %ebp
  801894:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801896:	6a 00                	push   $0x0
  801898:	6a 00                	push   $0x0
  80189a:	6a 00                	push   $0x0
  80189c:	6a 00                	push   $0x0
  80189e:	6a 00                	push   $0x0
  8018a0:	6a 23                	push   $0x23
  8018a2:	e8 c6 fb ff ff       	call   80146d <syscall>
  8018a7:	83 c4 18             	add    $0x18,%esp
	return ;
  8018aa:	90                   	nop
}
  8018ab:	c9                   	leave  
  8018ac:	c3                   	ret    

008018ad <gettst>:
uint32 gettst()
{
  8018ad:	55                   	push   %ebp
  8018ae:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  8018b0:	6a 00                	push   $0x0
  8018b2:	6a 00                	push   $0x0
  8018b4:	6a 00                	push   $0x0
  8018b6:	6a 00                	push   $0x0
  8018b8:	6a 00                	push   $0x0
  8018ba:	6a 24                	push   $0x24
  8018bc:	e8 ac fb ff ff       	call   80146d <syscall>
  8018c1:	83 c4 18             	add    $0x18,%esp
}
  8018c4:	c9                   	leave  
  8018c5:	c3                   	ret    

008018c6 <sys_get_uheap_strategy>:

/*2025*/
uint32 sys_get_uheap_strategy()
{
  8018c6:	55                   	push   %ebp
  8018c7:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8018c9:	6a 00                	push   $0x0
  8018cb:	6a 00                	push   $0x0
  8018cd:	6a 00                	push   $0x0
  8018cf:	6a 00                	push   $0x0
  8018d1:	6a 00                	push   $0x0
  8018d3:	6a 25                	push   $0x25
  8018d5:	e8 93 fb ff ff       	call   80146d <syscall>
  8018da:	83 c4 18             	add    $0x18,%esp
  8018dd:	a3 60 b0 81 00       	mov    %eax,0x81b060
	return uheapPlaceStrategy ;
  8018e2:	a1 60 b0 81 00       	mov    0x81b060,%eax
}
  8018e7:	c9                   	leave  
  8018e8:	c3                   	ret    

008018e9 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  8018e9:	55                   	push   %ebp
  8018ea:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = heapStrategy;
  8018ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8018ef:	a3 60 b0 81 00       	mov    %eax,0x81b060
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  8018f4:	6a 00                	push   $0x0
  8018f6:	6a 00                	push   $0x0
  8018f8:	6a 00                	push   $0x0
  8018fa:	6a 00                	push   $0x0
  8018fc:	ff 75 08             	pushl  0x8(%ebp)
  8018ff:	6a 26                	push   $0x26
  801901:	e8 67 fb ff ff       	call   80146d <syscall>
  801906:	83 c4 18             	add    $0x18,%esp
	return ;
  801909:	90                   	nop
}
  80190a:	c9                   	leave  
  80190b:	c3                   	ret    

0080190c <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  80190c:	55                   	push   %ebp
  80190d:	89 e5                	mov    %esp,%ebp
  80190f:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801910:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801913:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801916:	8b 55 0c             	mov    0xc(%ebp),%edx
  801919:	8b 45 08             	mov    0x8(%ebp),%eax
  80191c:	6a 00                	push   $0x0
  80191e:	53                   	push   %ebx
  80191f:	51                   	push   %ecx
  801920:	52                   	push   %edx
  801921:	50                   	push   %eax
  801922:	6a 27                	push   $0x27
  801924:	e8 44 fb ff ff       	call   80146d <syscall>
  801929:	83 c4 18             	add    $0x18,%esp
}
  80192c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80192f:	c9                   	leave  
  801930:	c3                   	ret    

00801931 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801931:	55                   	push   %ebp
  801932:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801934:	8b 55 0c             	mov    0xc(%ebp),%edx
  801937:	8b 45 08             	mov    0x8(%ebp),%eax
  80193a:	6a 00                	push   $0x0
  80193c:	6a 00                	push   $0x0
  80193e:	6a 00                	push   $0x0
  801940:	52                   	push   %edx
  801941:	50                   	push   %eax
  801942:	6a 28                	push   $0x28
  801944:	e8 24 fb ff ff       	call   80146d <syscall>
  801949:	83 c4 18             	add    $0x18,%esp
}
  80194c:	c9                   	leave  
  80194d:	c3                   	ret    

0080194e <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  80194e:	55                   	push   %ebp
  80194f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  801951:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801954:	8b 55 0c             	mov    0xc(%ebp),%edx
  801957:	8b 45 08             	mov    0x8(%ebp),%eax
  80195a:	6a 00                	push   $0x0
  80195c:	51                   	push   %ecx
  80195d:	ff 75 10             	pushl  0x10(%ebp)
  801960:	52                   	push   %edx
  801961:	50                   	push   %eax
  801962:	6a 29                	push   $0x29
  801964:	e8 04 fb ff ff       	call   80146d <syscall>
  801969:	83 c4 18             	add    $0x18,%esp
}
  80196c:	c9                   	leave  
  80196d:	c3                   	ret    

0080196e <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  80196e:	55                   	push   %ebp
  80196f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801971:	6a 00                	push   $0x0
  801973:	6a 00                	push   $0x0
  801975:	ff 75 10             	pushl  0x10(%ebp)
  801978:	ff 75 0c             	pushl  0xc(%ebp)
  80197b:	ff 75 08             	pushl  0x8(%ebp)
  80197e:	6a 12                	push   $0x12
  801980:	e8 e8 fa ff ff       	call   80146d <syscall>
  801985:	83 c4 18             	add    $0x18,%esp
	return ;
  801988:	90                   	nop
}
  801989:	c9                   	leave  
  80198a:	c3                   	ret    

0080198b <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  80198b:	55                   	push   %ebp
  80198c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  80198e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801991:	8b 45 08             	mov    0x8(%ebp),%eax
  801994:	6a 00                	push   $0x0
  801996:	6a 00                	push   $0x0
  801998:	6a 00                	push   $0x0
  80199a:	52                   	push   %edx
  80199b:	50                   	push   %eax
  80199c:	6a 2a                	push   $0x2a
  80199e:	e8 ca fa ff ff       	call   80146d <syscall>
  8019a3:	83 c4 18             	add    $0x18,%esp
	return;
  8019a6:	90                   	nop
}
  8019a7:	c9                   	leave  
  8019a8:	c3                   	ret    

008019a9 <sys_get_optimal_num_faults>:
/*2025*/
int sys_get_optimal_num_faults()
{
  8019a9:	55                   	push   %ebp
  8019aa:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_optimal_num_faults, 0, 0, 0, 0, 0);
  8019ac:	6a 00                	push   $0x0
  8019ae:	6a 00                	push   $0x0
  8019b0:	6a 00                	push   $0x0
  8019b2:	6a 00                	push   $0x0
  8019b4:	6a 00                	push   $0x0
  8019b6:	6a 2b                	push   $0x2b
  8019b8:	e8 b0 fa ff ff       	call   80146d <syscall>
  8019bd:	83 c4 18             	add    $0x18,%esp
}
  8019c0:	c9                   	leave  
  8019c1:	c3                   	ret    

008019c2 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  8019c2:	55                   	push   %ebp
  8019c3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  8019c5:	6a 00                	push   $0x0
  8019c7:	6a 00                	push   $0x0
  8019c9:	6a 00                	push   $0x0
  8019cb:	ff 75 0c             	pushl  0xc(%ebp)
  8019ce:	ff 75 08             	pushl  0x8(%ebp)
  8019d1:	6a 2d                	push   $0x2d
  8019d3:	e8 95 fa ff ff       	call   80146d <syscall>
  8019d8:	83 c4 18             	add    $0x18,%esp
	return;
  8019db:	90                   	nop
}
  8019dc:	c9                   	leave  
  8019dd:	c3                   	ret    

008019de <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  8019de:	55                   	push   %ebp
  8019df:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  8019e1:	6a 00                	push   $0x0
  8019e3:	6a 00                	push   $0x0
  8019e5:	6a 00                	push   $0x0
  8019e7:	ff 75 0c             	pushl  0xc(%ebp)
  8019ea:	ff 75 08             	pushl  0x8(%ebp)
  8019ed:	6a 2c                	push   $0x2c
  8019ef:	e8 79 fa ff ff       	call   80146d <syscall>
  8019f4:	83 c4 18             	add    $0x18,%esp
	return ;
  8019f7:	90                   	nop
}
  8019f8:	c9                   	leave  
  8019f9:	c3                   	ret    

008019fa <sys_env_set_priority>:


void sys_env_set_priority(int32 envID, int priority)
{
  8019fa:	55                   	push   %ebp
  8019fb:	89 e5                	mov    %esp,%ebp
  8019fd:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.IM#4] CPU SCHEDULING - #1 System Calls - Add suitable code here
	//Your code is here
	//Comment the following line
	panic("sys_env_set_priority() is not implemented yet...!!");
  801a00:	83 ec 04             	sub    $0x4,%esp
  801a03:	68 fc 24 80 00       	push   $0x8024fc
  801a08:	68 25 01 00 00       	push   $0x125
  801a0d:	68 2f 25 80 00       	push   $0x80252f
  801a12:	e8 fa 00 00 00       	call   801b11 <_panic>

00801a17 <env_sleep>:
#include <inc/lib.h>
#include <inc/timerreg.h>

void
env_sleep(uint32 approxMilliSeconds)
{
  801a17:	55                   	push   %ebp
  801a18:	89 e5                	mov    %esp,%ebp
  801a1a:	83 ec 30             	sub    $0x30,%esp
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
  801a1d:	8b 55 08             	mov    0x8(%ebp),%edx
  801a20:	89 d0                	mov    %edx,%eax
  801a22:	c1 e0 02             	shl    $0x2,%eax
  801a25:	01 d0                	add    %edx,%eax
  801a27:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801a2e:	01 d0                	add    %edx,%eax
  801a30:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801a37:	01 d0                	add    %edx,%eax
  801a39:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801a40:	01 d0                	add    %edx,%eax
  801a42:	c1 e0 04             	shl    $0x4,%eax
  801a45:	89 45 f8             	mov    %eax,-0x8(%ebp)
	uint32 cycles_counter =0;
  801a48:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)

static inline __attribute__((always_inline)) struct uint64 get_virtual_time_user()
{
	struct uint64 result;

	__asm __volatile("rdtsc\n"
  801a4f:	0f 31                	rdtsc  
  801a51:	89 45 e8             	mov    %eax,-0x18(%ebp)
  801a54:	89 55 ec             	mov    %edx,-0x14(%ebp)
	: "=a" (result.low), "=d" (result.hi)
	);

	return result;
  801a57:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801a5a:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801a5d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801a60:	89 55 f4             	mov    %edx,-0xc(%ebp)

	/*2024*/ //USE A USER-SIDE VERSION OF THIS FUNCTION TO AVOID SLOW-DOWN THE PERFORMANCE DUE SYS_CALL (el7 :))
	//struct uint64 baseTime = sys_get_virtual_time() ;
	struct uint64 baseTime = get_virtual_time_user() ;
	while(cycles_counter<time_in_cycles)
  801a63:	eb 46                	jmp    801aab <env_sleep+0x94>

static inline __attribute__((always_inline)) struct uint64 get_virtual_time_user()
{
	struct uint64 result;

	__asm __volatile("rdtsc\n"
  801a65:	0f 31                	rdtsc  
  801a67:	89 45 d0             	mov    %eax,-0x30(%ebp)
  801a6a:	89 55 d4             	mov    %edx,-0x2c(%ebp)
	: "=a" (result.low), "=d" (result.hi)
	);

	return result;
  801a6d:	8b 45 d0             	mov    -0x30(%ebp),%eax
  801a70:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  801a73:	89 45 e0             	mov    %eax,-0x20(%ebp)
  801a76:	89 55 e4             	mov    %edx,-0x1c(%ebp)

		// update the cycles_count
		#define M32 0xffffffff
		// subtract basetime from current time
		struct uint64 res;
		res.low = (currentTime.low - baseTime.low) & M32;
  801a79:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801a7c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a7f:	29 c2                	sub    %eax,%edx
  801a81:	89 d0                	mov    %edx,%eax
  801a83:	89 45 d8             	mov    %eax,-0x28(%ebp)
		res.hi = (currentTime.hi - baseTime.hi - (res.low > currentTime.low)) & M32;
  801a86:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801a89:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a8c:	89 d1                	mov    %edx,%ecx
  801a8e:	29 c1                	sub    %eax,%ecx
  801a90:	8b 55 d8             	mov    -0x28(%ebp),%edx
  801a93:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801a96:	39 c2                	cmp    %eax,%edx
  801a98:	0f 97 c0             	seta   %al
  801a9b:	0f b6 c0             	movzbl %al,%eax
  801a9e:	29 c1                	sub    %eax,%ecx
  801aa0:	89 c8                	mov    %ecx,%eax
  801aa2:	89 45 dc             	mov    %eax,-0x24(%ebp)

		//update cycles_count with result
		cycles_counter = res.low;
  801aa5:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801aa8:	89 45 fc             	mov    %eax,-0x4(%ebp)
	uint32 cycles_counter =0;

	/*2024*/ //USE A USER-SIDE VERSION OF THIS FUNCTION TO AVOID SLOW-DOWN THE PERFORMANCE DUE SYS_CALL (el7 :))
	//struct uint64 baseTime = sys_get_virtual_time() ;
	struct uint64 baseTime = get_virtual_time_user() ;
	while(cycles_counter<time_in_cycles)
  801aab:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801aae:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801ab1:	72 b2                	jb     801a65 <env_sleep+0x4e>
//				,cycles_counter
//				);
	}
	//cprintf("%s [%d] wake up now!\n", myEnv->prog_name, myEnv->env_id);

}
  801ab3:	90                   	nop
  801ab4:	c9                   	leave  
  801ab5:	c3                   	ret    

00801ab6 <busy_wait>:

//2017
uint32 busy_wait(uint32 loopMax)
{
  801ab6:	55                   	push   %ebp
  801ab7:	89 e5                	mov    %esp,%ebp
  801ab9:	83 ec 10             	sub    $0x10,%esp
	uint32 i = 0 ;
  801abc:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	while (i < loopMax) i++;
  801ac3:	eb 03                	jmp    801ac8 <busy_wait+0x12>
  801ac5:	ff 45 fc             	incl   -0x4(%ebp)
  801ac8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801acb:	3b 45 08             	cmp    0x8(%ebp),%eax
  801ace:	72 f5                	jb     801ac5 <busy_wait+0xf>
	return i;
  801ad0:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801ad3:	c9                   	leave  
  801ad4:	c3                   	ret    

00801ad5 <cputchar>:
#include <inc/lib.h>


void
cputchar(int ch)
{
  801ad5:	55                   	push   %ebp
  801ad6:	89 e5                	mov    %esp,%ebp
  801ad8:	83 ec 18             	sub    $0x18,%esp
	char c = ch;
  801adb:	8b 45 08             	mov    0x8(%ebp),%eax
  801ade:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	//sys_cputs(&c, 1);

	sys_cputc(c);
  801ae1:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  801ae5:	83 ec 0c             	sub    $0xc,%esp
  801ae8:	50                   	push   %eax
  801ae9:	e8 36 fb ff ff       	call   801624 <sys_cputc>
  801aee:	83 c4 10             	add    $0x10,%esp
}
  801af1:	90                   	nop
  801af2:	c9                   	leave  
  801af3:	c3                   	ret    

00801af4 <getchar>:


int
getchar(void)
{
  801af4:	55                   	push   %ebp
  801af5:	89 e5                	mov    %esp,%ebp
  801af7:	83 ec 18             	sub    $0x18,%esp
	int c =sys_cgetc();
  801afa:	e8 c4 f9 ff ff       	call   8014c3 <sys_cgetc>
  801aff:	89 45 f4             	mov    %eax,-0xc(%ebp)
	return c;
  801b02:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  801b05:	c9                   	leave  
  801b06:	c3                   	ret    

00801b07 <iscons>:

int iscons(int fdnum)
{
  801b07:	55                   	push   %ebp
  801b08:	89 e5                	mov    %esp,%ebp
	// used by readline
	return 1;
  801b0a:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801b0f:	5d                   	pop    %ebp
  801b10:	c3                   	ret    

00801b11 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  801b11:	55                   	push   %ebp
  801b12:	89 e5                	mov    %esp,%ebp
  801b14:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  801b17:	8d 45 10             	lea    0x10(%ebp),%eax
  801b1a:	83 c0 04             	add    $0x4,%eax
  801b1d:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  801b20:	a1 1c b1 81 00       	mov    0x81b11c,%eax
  801b25:	85 c0                	test   %eax,%eax
  801b27:	74 16                	je     801b3f <_panic+0x2e>
		cprintf("%s: ", argv0);
  801b29:	a1 1c b1 81 00       	mov    0x81b11c,%eax
  801b2e:	83 ec 08             	sub    $0x8,%esp
  801b31:	50                   	push   %eax
  801b32:	68 40 25 80 00       	push   $0x802540
  801b37:	e8 44 e8 ff ff       	call   800380 <cprintf>
  801b3c:	83 c4 10             	add    $0x10,%esp
	cprintf_colored(TEXT_PANIC_CLR, "user [EVAL_FINAL]panic in %s at %s:%d: ", binaryname, file, line);
  801b3f:	a1 04 30 80 00       	mov    0x803004,%eax
  801b44:	83 ec 0c             	sub    $0xc,%esp
  801b47:	ff 75 0c             	pushl  0xc(%ebp)
  801b4a:	ff 75 08             	pushl  0x8(%ebp)
  801b4d:	50                   	push   %eax
  801b4e:	68 48 25 80 00       	push   $0x802548
  801b53:	6a 74                	push   $0x74
  801b55:	e8 53 e8 ff ff       	call   8003ad <cprintf_colored>
  801b5a:	83 c4 20             	add    $0x20,%esp
	vcprintf(fmt, ap);
  801b5d:	8b 45 10             	mov    0x10(%ebp),%eax
  801b60:	83 ec 08             	sub    $0x8,%esp
  801b63:	ff 75 f4             	pushl  -0xc(%ebp)
  801b66:	50                   	push   %eax
  801b67:	e8 a5 e7 ff ff       	call   800311 <vcprintf>
  801b6c:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  801b6f:	83 ec 08             	sub    $0x8,%esp
  801b72:	6a 00                	push   $0x0
  801b74:	68 70 25 80 00       	push   $0x802570
  801b79:	e8 93 e7 ff ff       	call   800311 <vcprintf>
  801b7e:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  801b81:	e8 0c e7 ff ff       	call   800292 <exit>

	// should not return here
	while (1) ;
  801b86:	eb fe                	jmp    801b86 <_panic+0x75>

00801b88 <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  801b88:	55                   	push   %ebp
  801b89:	89 e5                	mov    %esp,%ebp
  801b8b:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  801b8e:	a1 20 30 80 00       	mov    0x803020,%eax
  801b93:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  801b99:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b9c:	39 c2                	cmp    %eax,%edx
  801b9e:	74 14                	je     801bb4 <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  801ba0:	83 ec 04             	sub    $0x4,%esp
  801ba3:	68 74 25 80 00       	push   $0x802574
  801ba8:	6a 26                	push   $0x26
  801baa:	68 c0 25 80 00       	push   $0x8025c0
  801baf:	e8 5d ff ff ff       	call   801b11 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  801bb4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  801bbb:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  801bc2:	e9 c5 00 00 00       	jmp    801c8c <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  801bc7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801bca:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801bd1:	8b 45 08             	mov    0x8(%ebp),%eax
  801bd4:	01 d0                	add    %edx,%eax
  801bd6:	8b 00                	mov    (%eax),%eax
  801bd8:	85 c0                	test   %eax,%eax
  801bda:	75 08                	jne    801be4 <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  801bdc:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  801bdf:	e9 a5 00 00 00       	jmp    801c89 <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  801be4:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  801beb:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  801bf2:	eb 69                	jmp    801c5d <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  801bf4:	a1 20 30 80 00       	mov    0x803020,%eax
  801bf9:	8b 88 38 da 01 00    	mov    0x1da38(%eax),%ecx
  801bff:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801c02:	89 d0                	mov    %edx,%eax
  801c04:	01 c0                	add    %eax,%eax
  801c06:	01 d0                	add    %edx,%eax
  801c08:	c1 e0 03             	shl    $0x3,%eax
  801c0b:	01 c8                	add    %ecx,%eax
  801c0d:	8a 40 04             	mov    0x4(%eax),%al
  801c10:	84 c0                	test   %al,%al
  801c12:	75 46                	jne    801c5a <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  801c14:	a1 20 30 80 00       	mov    0x803020,%eax
  801c19:	8b 88 38 da 01 00    	mov    0x1da38(%eax),%ecx
  801c1f:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801c22:	89 d0                	mov    %edx,%eax
  801c24:	01 c0                	add    %eax,%eax
  801c26:	01 d0                	add    %edx,%eax
  801c28:	c1 e0 03             	shl    $0x3,%eax
  801c2b:	01 c8                	add    %ecx,%eax
  801c2d:	8b 00                	mov    (%eax),%eax
  801c2f:	89 45 dc             	mov    %eax,-0x24(%ebp)
  801c32:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801c35:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801c3a:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  801c3c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801c3f:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  801c46:	8b 45 08             	mov    0x8(%ebp),%eax
  801c49:	01 c8                	add    %ecx,%eax
  801c4b:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  801c4d:	39 c2                	cmp    %eax,%edx
  801c4f:	75 09                	jne    801c5a <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  801c51:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  801c58:	eb 15                	jmp    801c6f <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  801c5a:	ff 45 e8             	incl   -0x18(%ebp)
  801c5d:	a1 20 30 80 00       	mov    0x803020,%eax
  801c62:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  801c68:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801c6b:	39 c2                	cmp    %eax,%edx
  801c6d:	77 85                	ja     801bf4 <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  801c6f:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801c73:	75 14                	jne    801c89 <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  801c75:	83 ec 04             	sub    $0x4,%esp
  801c78:	68 cc 25 80 00       	push   $0x8025cc
  801c7d:	6a 3a                	push   $0x3a
  801c7f:	68 c0 25 80 00       	push   $0x8025c0
  801c84:	e8 88 fe ff ff       	call   801b11 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  801c89:	ff 45 f0             	incl   -0x10(%ebp)
  801c8c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801c8f:	3b 45 0c             	cmp    0xc(%ebp),%eax
  801c92:	0f 8c 2f ff ff ff    	jl     801bc7 <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  801c98:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  801c9f:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  801ca6:	eb 26                	jmp    801cce <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  801ca8:	a1 20 30 80 00       	mov    0x803020,%eax
  801cad:	8b 88 38 da 01 00    	mov    0x1da38(%eax),%ecx
  801cb3:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801cb6:	89 d0                	mov    %edx,%eax
  801cb8:	01 c0                	add    %eax,%eax
  801cba:	01 d0                	add    %edx,%eax
  801cbc:	c1 e0 03             	shl    $0x3,%eax
  801cbf:	01 c8                	add    %ecx,%eax
  801cc1:	8a 40 04             	mov    0x4(%eax),%al
  801cc4:	3c 01                	cmp    $0x1,%al
  801cc6:	75 03                	jne    801ccb <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  801cc8:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  801ccb:	ff 45 e0             	incl   -0x20(%ebp)
  801cce:	a1 20 30 80 00       	mov    0x803020,%eax
  801cd3:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  801cd9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801cdc:	39 c2                	cmp    %eax,%edx
  801cde:	77 c8                	ja     801ca8 <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  801ce0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ce3:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  801ce6:	74 14                	je     801cfc <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  801ce8:	83 ec 04             	sub    $0x4,%esp
  801ceb:	68 20 26 80 00       	push   $0x802620
  801cf0:	6a 44                	push   $0x44
  801cf2:	68 c0 25 80 00       	push   $0x8025c0
  801cf7:	e8 15 fe ff ff       	call   801b11 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  801cfc:	90                   	nop
  801cfd:	c9                   	leave  
  801cfe:	c3                   	ret    
  801cff:	90                   	nop

00801d00 <__udivdi3>:
  801d00:	55                   	push   %ebp
  801d01:	57                   	push   %edi
  801d02:	56                   	push   %esi
  801d03:	53                   	push   %ebx
  801d04:	83 ec 1c             	sub    $0x1c,%esp
  801d07:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  801d0b:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  801d0f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801d13:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801d17:	89 ca                	mov    %ecx,%edx
  801d19:	89 f8                	mov    %edi,%eax
  801d1b:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  801d1f:	85 f6                	test   %esi,%esi
  801d21:	75 2d                	jne    801d50 <__udivdi3+0x50>
  801d23:	39 cf                	cmp    %ecx,%edi
  801d25:	77 65                	ja     801d8c <__udivdi3+0x8c>
  801d27:	89 fd                	mov    %edi,%ebp
  801d29:	85 ff                	test   %edi,%edi
  801d2b:	75 0b                	jne    801d38 <__udivdi3+0x38>
  801d2d:	b8 01 00 00 00       	mov    $0x1,%eax
  801d32:	31 d2                	xor    %edx,%edx
  801d34:	f7 f7                	div    %edi
  801d36:	89 c5                	mov    %eax,%ebp
  801d38:	31 d2                	xor    %edx,%edx
  801d3a:	89 c8                	mov    %ecx,%eax
  801d3c:	f7 f5                	div    %ebp
  801d3e:	89 c1                	mov    %eax,%ecx
  801d40:	89 d8                	mov    %ebx,%eax
  801d42:	f7 f5                	div    %ebp
  801d44:	89 cf                	mov    %ecx,%edi
  801d46:	89 fa                	mov    %edi,%edx
  801d48:	83 c4 1c             	add    $0x1c,%esp
  801d4b:	5b                   	pop    %ebx
  801d4c:	5e                   	pop    %esi
  801d4d:	5f                   	pop    %edi
  801d4e:	5d                   	pop    %ebp
  801d4f:	c3                   	ret    
  801d50:	39 ce                	cmp    %ecx,%esi
  801d52:	77 28                	ja     801d7c <__udivdi3+0x7c>
  801d54:	0f bd fe             	bsr    %esi,%edi
  801d57:	83 f7 1f             	xor    $0x1f,%edi
  801d5a:	75 40                	jne    801d9c <__udivdi3+0x9c>
  801d5c:	39 ce                	cmp    %ecx,%esi
  801d5e:	72 0a                	jb     801d6a <__udivdi3+0x6a>
  801d60:	3b 44 24 08          	cmp    0x8(%esp),%eax
  801d64:	0f 87 9e 00 00 00    	ja     801e08 <__udivdi3+0x108>
  801d6a:	b8 01 00 00 00       	mov    $0x1,%eax
  801d6f:	89 fa                	mov    %edi,%edx
  801d71:	83 c4 1c             	add    $0x1c,%esp
  801d74:	5b                   	pop    %ebx
  801d75:	5e                   	pop    %esi
  801d76:	5f                   	pop    %edi
  801d77:	5d                   	pop    %ebp
  801d78:	c3                   	ret    
  801d79:	8d 76 00             	lea    0x0(%esi),%esi
  801d7c:	31 ff                	xor    %edi,%edi
  801d7e:	31 c0                	xor    %eax,%eax
  801d80:	89 fa                	mov    %edi,%edx
  801d82:	83 c4 1c             	add    $0x1c,%esp
  801d85:	5b                   	pop    %ebx
  801d86:	5e                   	pop    %esi
  801d87:	5f                   	pop    %edi
  801d88:	5d                   	pop    %ebp
  801d89:	c3                   	ret    
  801d8a:	66 90                	xchg   %ax,%ax
  801d8c:	89 d8                	mov    %ebx,%eax
  801d8e:	f7 f7                	div    %edi
  801d90:	31 ff                	xor    %edi,%edi
  801d92:	89 fa                	mov    %edi,%edx
  801d94:	83 c4 1c             	add    $0x1c,%esp
  801d97:	5b                   	pop    %ebx
  801d98:	5e                   	pop    %esi
  801d99:	5f                   	pop    %edi
  801d9a:	5d                   	pop    %ebp
  801d9b:	c3                   	ret    
  801d9c:	bd 20 00 00 00       	mov    $0x20,%ebp
  801da1:	89 eb                	mov    %ebp,%ebx
  801da3:	29 fb                	sub    %edi,%ebx
  801da5:	89 f9                	mov    %edi,%ecx
  801da7:	d3 e6                	shl    %cl,%esi
  801da9:	89 c5                	mov    %eax,%ebp
  801dab:	88 d9                	mov    %bl,%cl
  801dad:	d3 ed                	shr    %cl,%ebp
  801daf:	89 e9                	mov    %ebp,%ecx
  801db1:	09 f1                	or     %esi,%ecx
  801db3:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  801db7:	89 f9                	mov    %edi,%ecx
  801db9:	d3 e0                	shl    %cl,%eax
  801dbb:	89 c5                	mov    %eax,%ebp
  801dbd:	89 d6                	mov    %edx,%esi
  801dbf:	88 d9                	mov    %bl,%cl
  801dc1:	d3 ee                	shr    %cl,%esi
  801dc3:	89 f9                	mov    %edi,%ecx
  801dc5:	d3 e2                	shl    %cl,%edx
  801dc7:	8b 44 24 08          	mov    0x8(%esp),%eax
  801dcb:	88 d9                	mov    %bl,%cl
  801dcd:	d3 e8                	shr    %cl,%eax
  801dcf:	09 c2                	or     %eax,%edx
  801dd1:	89 d0                	mov    %edx,%eax
  801dd3:	89 f2                	mov    %esi,%edx
  801dd5:	f7 74 24 0c          	divl   0xc(%esp)
  801dd9:	89 d6                	mov    %edx,%esi
  801ddb:	89 c3                	mov    %eax,%ebx
  801ddd:	f7 e5                	mul    %ebp
  801ddf:	39 d6                	cmp    %edx,%esi
  801de1:	72 19                	jb     801dfc <__udivdi3+0xfc>
  801de3:	74 0b                	je     801df0 <__udivdi3+0xf0>
  801de5:	89 d8                	mov    %ebx,%eax
  801de7:	31 ff                	xor    %edi,%edi
  801de9:	e9 58 ff ff ff       	jmp    801d46 <__udivdi3+0x46>
  801dee:	66 90                	xchg   %ax,%ax
  801df0:	8b 54 24 08          	mov    0x8(%esp),%edx
  801df4:	89 f9                	mov    %edi,%ecx
  801df6:	d3 e2                	shl    %cl,%edx
  801df8:	39 c2                	cmp    %eax,%edx
  801dfa:	73 e9                	jae    801de5 <__udivdi3+0xe5>
  801dfc:	8d 43 ff             	lea    -0x1(%ebx),%eax
  801dff:	31 ff                	xor    %edi,%edi
  801e01:	e9 40 ff ff ff       	jmp    801d46 <__udivdi3+0x46>
  801e06:	66 90                	xchg   %ax,%ax
  801e08:	31 c0                	xor    %eax,%eax
  801e0a:	e9 37 ff ff ff       	jmp    801d46 <__udivdi3+0x46>
  801e0f:	90                   	nop

00801e10 <__umoddi3>:
  801e10:	55                   	push   %ebp
  801e11:	57                   	push   %edi
  801e12:	56                   	push   %esi
  801e13:	53                   	push   %ebx
  801e14:	83 ec 1c             	sub    $0x1c,%esp
  801e17:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  801e1b:	8b 74 24 34          	mov    0x34(%esp),%esi
  801e1f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801e23:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  801e27:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801e2b:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801e2f:	89 f3                	mov    %esi,%ebx
  801e31:	89 fa                	mov    %edi,%edx
  801e33:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801e37:	89 34 24             	mov    %esi,(%esp)
  801e3a:	85 c0                	test   %eax,%eax
  801e3c:	75 1a                	jne    801e58 <__umoddi3+0x48>
  801e3e:	39 f7                	cmp    %esi,%edi
  801e40:	0f 86 a2 00 00 00    	jbe    801ee8 <__umoddi3+0xd8>
  801e46:	89 c8                	mov    %ecx,%eax
  801e48:	89 f2                	mov    %esi,%edx
  801e4a:	f7 f7                	div    %edi
  801e4c:	89 d0                	mov    %edx,%eax
  801e4e:	31 d2                	xor    %edx,%edx
  801e50:	83 c4 1c             	add    $0x1c,%esp
  801e53:	5b                   	pop    %ebx
  801e54:	5e                   	pop    %esi
  801e55:	5f                   	pop    %edi
  801e56:	5d                   	pop    %ebp
  801e57:	c3                   	ret    
  801e58:	39 f0                	cmp    %esi,%eax
  801e5a:	0f 87 ac 00 00 00    	ja     801f0c <__umoddi3+0xfc>
  801e60:	0f bd e8             	bsr    %eax,%ebp
  801e63:	83 f5 1f             	xor    $0x1f,%ebp
  801e66:	0f 84 ac 00 00 00    	je     801f18 <__umoddi3+0x108>
  801e6c:	bf 20 00 00 00       	mov    $0x20,%edi
  801e71:	29 ef                	sub    %ebp,%edi
  801e73:	89 fe                	mov    %edi,%esi
  801e75:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801e79:	89 e9                	mov    %ebp,%ecx
  801e7b:	d3 e0                	shl    %cl,%eax
  801e7d:	89 d7                	mov    %edx,%edi
  801e7f:	89 f1                	mov    %esi,%ecx
  801e81:	d3 ef                	shr    %cl,%edi
  801e83:	09 c7                	or     %eax,%edi
  801e85:	89 e9                	mov    %ebp,%ecx
  801e87:	d3 e2                	shl    %cl,%edx
  801e89:	89 14 24             	mov    %edx,(%esp)
  801e8c:	89 d8                	mov    %ebx,%eax
  801e8e:	d3 e0                	shl    %cl,%eax
  801e90:	89 c2                	mov    %eax,%edx
  801e92:	8b 44 24 08          	mov    0x8(%esp),%eax
  801e96:	d3 e0                	shl    %cl,%eax
  801e98:	89 44 24 04          	mov    %eax,0x4(%esp)
  801e9c:	8b 44 24 08          	mov    0x8(%esp),%eax
  801ea0:	89 f1                	mov    %esi,%ecx
  801ea2:	d3 e8                	shr    %cl,%eax
  801ea4:	09 d0                	or     %edx,%eax
  801ea6:	d3 eb                	shr    %cl,%ebx
  801ea8:	89 da                	mov    %ebx,%edx
  801eaa:	f7 f7                	div    %edi
  801eac:	89 d3                	mov    %edx,%ebx
  801eae:	f7 24 24             	mull   (%esp)
  801eb1:	89 c6                	mov    %eax,%esi
  801eb3:	89 d1                	mov    %edx,%ecx
  801eb5:	39 d3                	cmp    %edx,%ebx
  801eb7:	0f 82 87 00 00 00    	jb     801f44 <__umoddi3+0x134>
  801ebd:	0f 84 91 00 00 00    	je     801f54 <__umoddi3+0x144>
  801ec3:	8b 54 24 04          	mov    0x4(%esp),%edx
  801ec7:	29 f2                	sub    %esi,%edx
  801ec9:	19 cb                	sbb    %ecx,%ebx
  801ecb:	89 d8                	mov    %ebx,%eax
  801ecd:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  801ed1:	d3 e0                	shl    %cl,%eax
  801ed3:	89 e9                	mov    %ebp,%ecx
  801ed5:	d3 ea                	shr    %cl,%edx
  801ed7:	09 d0                	or     %edx,%eax
  801ed9:	89 e9                	mov    %ebp,%ecx
  801edb:	d3 eb                	shr    %cl,%ebx
  801edd:	89 da                	mov    %ebx,%edx
  801edf:	83 c4 1c             	add    $0x1c,%esp
  801ee2:	5b                   	pop    %ebx
  801ee3:	5e                   	pop    %esi
  801ee4:	5f                   	pop    %edi
  801ee5:	5d                   	pop    %ebp
  801ee6:	c3                   	ret    
  801ee7:	90                   	nop
  801ee8:	89 fd                	mov    %edi,%ebp
  801eea:	85 ff                	test   %edi,%edi
  801eec:	75 0b                	jne    801ef9 <__umoddi3+0xe9>
  801eee:	b8 01 00 00 00       	mov    $0x1,%eax
  801ef3:	31 d2                	xor    %edx,%edx
  801ef5:	f7 f7                	div    %edi
  801ef7:	89 c5                	mov    %eax,%ebp
  801ef9:	89 f0                	mov    %esi,%eax
  801efb:	31 d2                	xor    %edx,%edx
  801efd:	f7 f5                	div    %ebp
  801eff:	89 c8                	mov    %ecx,%eax
  801f01:	f7 f5                	div    %ebp
  801f03:	89 d0                	mov    %edx,%eax
  801f05:	e9 44 ff ff ff       	jmp    801e4e <__umoddi3+0x3e>
  801f0a:	66 90                	xchg   %ax,%ax
  801f0c:	89 c8                	mov    %ecx,%eax
  801f0e:	89 f2                	mov    %esi,%edx
  801f10:	83 c4 1c             	add    $0x1c,%esp
  801f13:	5b                   	pop    %ebx
  801f14:	5e                   	pop    %esi
  801f15:	5f                   	pop    %edi
  801f16:	5d                   	pop    %ebp
  801f17:	c3                   	ret    
  801f18:	3b 04 24             	cmp    (%esp),%eax
  801f1b:	72 06                	jb     801f23 <__umoddi3+0x113>
  801f1d:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  801f21:	77 0f                	ja     801f32 <__umoddi3+0x122>
  801f23:	89 f2                	mov    %esi,%edx
  801f25:	29 f9                	sub    %edi,%ecx
  801f27:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  801f2b:	89 14 24             	mov    %edx,(%esp)
  801f2e:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801f32:	8b 44 24 04          	mov    0x4(%esp),%eax
  801f36:	8b 14 24             	mov    (%esp),%edx
  801f39:	83 c4 1c             	add    $0x1c,%esp
  801f3c:	5b                   	pop    %ebx
  801f3d:	5e                   	pop    %esi
  801f3e:	5f                   	pop    %edi
  801f3f:	5d                   	pop    %ebp
  801f40:	c3                   	ret    
  801f41:	8d 76 00             	lea    0x0(%esi),%esi
  801f44:	2b 04 24             	sub    (%esp),%eax
  801f47:	19 fa                	sbb    %edi,%edx
  801f49:	89 d1                	mov    %edx,%ecx
  801f4b:	89 c6                	mov    %eax,%esi
  801f4d:	e9 71 ff ff ff       	jmp    801ec3 <__umoddi3+0xb3>
  801f52:	66 90                	xchg   %ax,%ax
  801f54:	39 44 24 04          	cmp    %eax,0x4(%esp)
  801f58:	72 ea                	jb     801f44 <__umoddi3+0x134>
  801f5a:	89 d9                	mov    %ebx,%ecx
  801f5c:	e9 62 ff ff ff       	jmp    801ec3 <__umoddi3+0xb3>
