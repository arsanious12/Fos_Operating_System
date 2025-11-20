
obj/user/fos_fibonacci:     file format elf32-i386


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
  800031:	e8 b7 00 00 00       	call   8000ed <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:

int64 fibonacci(int n);

void
_main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	81 ec 18 01 00 00    	sub    $0x118,%esp
	int i1=0;
  800041:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	char buff1[256];

	atomic_readline("Please enter Fibonacci index:", buff1);
  800048:	83 ec 08             	sub    $0x8,%esp
  80004b:	8d 85 e8 fe ff ff    	lea    -0x118(%ebp),%eax
  800051:	50                   	push   %eax
  800052:	68 c0 1e 80 00       	push   $0x801ec0
  800057:	e8 0e 0b 00 00       	call   800b6a <atomic_readline>
  80005c:	83 c4 10             	add    $0x10,%esp

	i1 = strtol(buff1, NULL, 10);
  80005f:	83 ec 04             	sub    $0x4,%esp
  800062:	6a 0a                	push   $0xa
  800064:	6a 00                	push   $0x0
  800066:	8d 85 e8 fe ff ff    	lea    -0x118(%ebp),%eax
  80006c:	50                   	push   %eax
  80006d:	e8 10 10 00 00       	call   801082 <strtol>
  800072:	83 c4 10             	add    $0x10,%esp
  800075:	89 45 f4             	mov    %eax,-0xc(%ebp)

	int64 res = fibonacci(i1) ;
  800078:	83 ec 0c             	sub    $0xc,%esp
  80007b:	ff 75 f4             	pushl  -0xc(%ebp)
  80007e:	e8 22 00 00 00       	call   8000a5 <fibonacci>
  800083:	83 c4 10             	add    $0x10,%esp
  800086:	89 45 e8             	mov    %eax,-0x18(%ebp)
  800089:	89 55 ec             	mov    %edx,-0x14(%ebp)

	atomic_cprintf("%@Fibonacci #%d = %lld\n",i1, res);
  80008c:	ff 75 ec             	pushl  -0x14(%ebp)
  80008f:	ff 75 e8             	pushl  -0x18(%ebp)
  800092:	ff 75 f4             	pushl  -0xc(%ebp)
  800095:	68 de 1e 80 00       	push   $0x801ede
  80009a:	e8 65 03 00 00       	call   800404 <atomic_cprintf>
  80009f:	83 c4 10             	add    $0x10,%esp

	return;
  8000a2:	90                   	nop
}
  8000a3:	c9                   	leave  
  8000a4:	c3                   	ret    

008000a5 <fibonacci>:


int64 fibonacci(int n)
{
  8000a5:	55                   	push   %ebp
  8000a6:	89 e5                	mov    %esp,%ebp
  8000a8:	56                   	push   %esi
  8000a9:	53                   	push   %ebx
	if (n <= 1)
  8000aa:	83 7d 08 01          	cmpl   $0x1,0x8(%ebp)
  8000ae:	7f 0c                	jg     8000bc <fibonacci+0x17>
		return 1 ;
  8000b0:	b8 01 00 00 00       	mov    $0x1,%eax
  8000b5:	ba 00 00 00 00       	mov    $0x0,%edx
  8000ba:	eb 2a                	jmp    8000e6 <fibonacci+0x41>
	return fibonacci(n-1) + fibonacci(n-2) ;
  8000bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8000bf:	48                   	dec    %eax
  8000c0:	83 ec 0c             	sub    $0xc,%esp
  8000c3:	50                   	push   %eax
  8000c4:	e8 dc ff ff ff       	call   8000a5 <fibonacci>
  8000c9:	83 c4 10             	add    $0x10,%esp
  8000cc:	89 c3                	mov    %eax,%ebx
  8000ce:	89 d6                	mov    %edx,%esi
  8000d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8000d3:	83 e8 02             	sub    $0x2,%eax
  8000d6:	83 ec 0c             	sub    $0xc,%esp
  8000d9:	50                   	push   %eax
  8000da:	e8 c6 ff ff ff       	call   8000a5 <fibonacci>
  8000df:	83 c4 10             	add    $0x10,%esp
  8000e2:	01 d8                	add    %ebx,%eax
  8000e4:	11 f2                	adc    %esi,%edx
}
  8000e6:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8000e9:	5b                   	pop    %ebx
  8000ea:	5e                   	pop    %esi
  8000eb:	5d                   	pop    %ebp
  8000ec:	c3                   	ret    

008000ed <libmain>:
volatile bool printStats = 1;

volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";
void
libmain(int argc, char **argv)
{
  8000ed:	55                   	push   %ebp
  8000ee:	89 e5                	mov    %esp,%ebp
  8000f0:	57                   	push   %edi
  8000f1:	56                   	push   %esi
  8000f2:	53                   	push   %ebx
  8000f3:	83 ec 7c             	sub    $0x7c,%esp
	//printStats = 1;
	int envIndex = sys_getenvindex();
  8000f6:	e8 6c 16 00 00       	call   801767 <sys_getenvindex>
  8000fb:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	myEnv = &(envs[envIndex]);
  8000fe:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800101:	89 d0                	mov    %edx,%eax
  800103:	c1 e0 06             	shl    $0x6,%eax
  800106:	29 d0                	sub    %edx,%eax
  800108:	c1 e0 02             	shl    $0x2,%eax
  80010b:	01 d0                	add    %edx,%eax
  80010d:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800114:	01 c8                	add    %ecx,%eax
  800116:	c1 e0 03             	shl    $0x3,%eax
  800119:	01 d0                	add    %edx,%eax
  80011b:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800122:	29 c2                	sub    %eax,%edx
  800124:	8d 04 95 00 00 00 00 	lea    0x0(,%edx,4),%eax
  80012b:	89 c2                	mov    %eax,%edx
  80012d:	8d 82 00 00 c0 ee    	lea    -0x11400000(%edx),%eax
  800133:	a3 20 30 80 00       	mov    %eax,0x803020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800138:	a1 20 30 80 00       	mov    0x803020,%eax
  80013d:	8a 40 20             	mov    0x20(%eax),%al
  800140:	84 c0                	test   %al,%al
  800142:	74 0d                	je     800151 <libmain+0x64>
		binaryname = myEnv->prog_name;
  800144:	a1 20 30 80 00       	mov    0x803020,%eax
  800149:	83 c0 20             	add    $0x20,%eax
  80014c:	a3 04 30 80 00       	mov    %eax,0x803004

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800151:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800155:	7e 0a                	jle    800161 <libmain+0x74>
		binaryname = argv[0];
  800157:	8b 45 0c             	mov    0xc(%ebp),%eax
  80015a:	8b 00                	mov    (%eax),%eax
  80015c:	a3 04 30 80 00       	mov    %eax,0x803004

	// call user main routine
	_main(argc, argv);
  800161:	83 ec 08             	sub    $0x8,%esp
  800164:	ff 75 0c             	pushl  0xc(%ebp)
  800167:	ff 75 08             	pushl  0x8(%ebp)
  80016a:	e8 c9 fe ff ff       	call   800038 <_main>
  80016f:	83 c4 10             	add    $0x10,%esp

	if (printStats)
  800172:	a1 00 30 80 00       	mov    0x803000,%eax
  800177:	85 c0                	test   %eax,%eax
  800179:	0f 84 01 01 00 00    	je     800280 <libmain+0x193>
	{
		char isOPTReplCmd[100] = "__IsOPTRepl__" ;
  80017f:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  800185:	bb f0 1f 80 00       	mov    $0x801ff0,%ebx
  80018a:	ba 0e 00 00 00       	mov    $0xe,%edx
  80018f:	89 c7                	mov    %eax,%edi
  800191:	89 de                	mov    %ebx,%esi
  800193:	89 d1                	mov    %edx,%ecx
  800195:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  800197:	8d 55 8a             	lea    -0x76(%ebp),%edx
  80019a:	b9 56 00 00 00       	mov    $0x56,%ecx
  80019f:	b0 00                	mov    $0x0,%al
  8001a1:	89 d7                	mov    %edx,%edi
  8001a3:	f3 aa                	rep stos %al,%es:(%edi)
		int isOPTRepl = 0;
  8001a5:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
		sys_utilities(isOPTReplCmd, (uint32)(&isOPTRepl));
  8001ac:	8d 45 e0             	lea    -0x20(%ebp),%eax
  8001af:	83 ec 08             	sub    $0x8,%esp
  8001b2:	50                   	push   %eax
  8001b3:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  8001b9:	50                   	push   %eax
  8001ba:	e8 de 17 00 00       	call   80199d <sys_utilities>
  8001bf:	83 c4 10             	add    $0x10,%esp

		sys_lock_cons();
  8001c2:	e8 27 13 00 00       	call   8014ee <sys_lock_cons>
		{
			cprintf("**************************************\n");
  8001c7:	83 ec 0c             	sub    $0xc,%esp
  8001ca:	68 10 1f 80 00       	push   $0x801f10
  8001cf:	e8 be 01 00 00       	call   800392 <cprintf>
  8001d4:	83 c4 10             	add    $0x10,%esp
			if (isOPTRepl)
  8001d7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8001da:	85 c0                	test   %eax,%eax
  8001dc:	74 18                	je     8001f6 <libmain+0x109>
			{
				cprintf("OPTIMAL number of page faults = %d\n", sys_get_optimal_num_faults());
  8001de:	e8 d8 17 00 00       	call   8019bb <sys_get_optimal_num_faults>
  8001e3:	83 ec 08             	sub    $0x8,%esp
  8001e6:	50                   	push   %eax
  8001e7:	68 38 1f 80 00       	push   $0x801f38
  8001ec:	e8 a1 01 00 00       	call   800392 <cprintf>
  8001f1:	83 c4 10             	add    $0x10,%esp
  8001f4:	eb 59                	jmp    80024f <libmain+0x162>
			}
			else
			{
				cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8001f6:	a1 20 30 80 00       	mov    0x803020,%eax
  8001fb:	8b 90 50 da 01 00    	mov    0x1da50(%eax),%edx
  800201:	a1 20 30 80 00       	mov    0x803020,%eax
  800206:	8b 80 40 da 01 00    	mov    0x1da40(%eax),%eax
  80020c:	83 ec 04             	sub    $0x4,%esp
  80020f:	52                   	push   %edx
  800210:	50                   	push   %eax
  800211:	68 5c 1f 80 00       	push   $0x801f5c
  800216:	e8 77 01 00 00       	call   800392 <cprintf>
  80021b:	83 c4 10             	add    $0x10,%esp
				cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  80021e:	a1 20 30 80 00       	mov    0x803020,%eax
  800223:	8b 88 64 da 01 00    	mov    0x1da64(%eax),%ecx
  800229:	a1 20 30 80 00       	mov    0x803020,%eax
  80022e:	8b 90 60 da 01 00    	mov    0x1da60(%eax),%edx
  800234:	a1 20 30 80 00       	mov    0x803020,%eax
  800239:	8b 80 5c da 01 00    	mov    0x1da5c(%eax),%eax
  80023f:	51                   	push   %ecx
  800240:	52                   	push   %edx
  800241:	50                   	push   %eax
  800242:	68 84 1f 80 00       	push   $0x801f84
  800247:	e8 46 01 00 00       	call   800392 <cprintf>
  80024c:	83 c4 10             	add    $0x10,%esp
			}
			//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
			cprintf("Num of clocks = %d\n", myEnv->nClocks);
  80024f:	a1 20 30 80 00       	mov    0x803020,%eax
  800254:	8b 80 68 da 01 00    	mov    0x1da68(%eax),%eax
  80025a:	83 ec 08             	sub    $0x8,%esp
  80025d:	50                   	push   %eax
  80025e:	68 dc 1f 80 00       	push   $0x801fdc
  800263:	e8 2a 01 00 00       	call   800392 <cprintf>
  800268:	83 c4 10             	add    $0x10,%esp
			cprintf("**************************************\n");
  80026b:	83 ec 0c             	sub    $0xc,%esp
  80026e:	68 10 1f 80 00       	push   $0x801f10
  800273:	e8 1a 01 00 00       	call   800392 <cprintf>
  800278:	83 c4 10             	add    $0x10,%esp
		}
		sys_unlock_cons();
  80027b:	e8 88 12 00 00       	call   801508 <sys_unlock_cons>
	}

	// exit gracefully
	exit();
  800280:	e8 1f 00 00 00       	call   8002a4 <exit>
}
  800285:	90                   	nop
  800286:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800289:	5b                   	pop    %ebx
  80028a:	5e                   	pop    %esi
  80028b:	5f                   	pop    %edi
  80028c:	5d                   	pop    %ebp
  80028d:	c3                   	ret    

0080028e <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  80028e:	55                   	push   %ebp
  80028f:	89 e5                	mov    %esp,%ebp
  800291:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800294:	83 ec 0c             	sub    $0xc,%esp
  800297:	6a 00                	push   $0x0
  800299:	e8 95 14 00 00       	call   801733 <sys_destroy_env>
  80029e:	83 c4 10             	add    $0x10,%esp
}
  8002a1:	90                   	nop
  8002a2:	c9                   	leave  
  8002a3:	c3                   	ret    

008002a4 <exit>:

void
exit(void)
{
  8002a4:	55                   	push   %ebp
  8002a5:	89 e5                	mov    %esp,%ebp
  8002a7:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  8002aa:	e8 ea 14 00 00       	call   801799 <sys_exit_env>
}
  8002af:	90                   	nop
  8002b0:	c9                   	leave  
  8002b1:	c3                   	ret    

008002b2 <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  8002b2:	55                   	push   %ebp
  8002b3:	89 e5                	mov    %esp,%ebp
  8002b5:	53                   	push   %ebx
  8002b6:	83 ec 04             	sub    $0x4,%esp
	b->buf[b->idx++] = ch;
  8002b9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8002bc:	8b 00                	mov    (%eax),%eax
  8002be:	8d 48 01             	lea    0x1(%eax),%ecx
  8002c1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8002c4:	89 0a                	mov    %ecx,(%edx)
  8002c6:	8b 55 08             	mov    0x8(%ebp),%edx
  8002c9:	88 d1                	mov    %dl,%cl
  8002cb:	8b 55 0c             	mov    0xc(%ebp),%edx
  8002ce:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  8002d2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8002d5:	8b 00                	mov    (%eax),%eax
  8002d7:	3d ff 00 00 00       	cmp    $0xff,%eax
  8002dc:	75 30                	jne    80030e <putch+0x5c>
		sys_cputs(b->buf, b->idx, printProgName, curTextClr);
  8002de:	8b 15 18 b1 81 00    	mov    0x81b118,%edx
  8002e4:	a0 44 30 80 00       	mov    0x803044,%al
  8002e9:	0f b6 c0             	movzbl %al,%eax
  8002ec:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8002ef:	8b 09                	mov    (%ecx),%ecx
  8002f1:	89 cb                	mov    %ecx,%ebx
  8002f3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8002f6:	83 c1 08             	add    $0x8,%ecx
  8002f9:	52                   	push   %edx
  8002fa:	50                   	push   %eax
  8002fb:	53                   	push   %ebx
  8002fc:	51                   	push   %ecx
  8002fd:	e8 a8 11 00 00       	call   8014aa <sys_cputs>
  800302:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800305:	8b 45 0c             	mov    0xc(%ebp),%eax
  800308:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  80030e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800311:	8b 40 04             	mov    0x4(%eax),%eax
  800314:	8d 50 01             	lea    0x1(%eax),%edx
  800317:	8b 45 0c             	mov    0xc(%ebp),%eax
  80031a:	89 50 04             	mov    %edx,0x4(%eax)
}
  80031d:	90                   	nop
  80031e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800321:	c9                   	leave  
  800322:	c3                   	ret    

00800323 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800323:	55                   	push   %ebp
  800324:	89 e5                	mov    %esp,%ebp
  800326:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  80032c:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800333:	00 00 00 
	b.cnt = 0;
  800336:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  80033d:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800340:	ff 75 0c             	pushl  0xc(%ebp)
  800343:	ff 75 08             	pushl  0x8(%ebp)
  800346:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80034c:	50                   	push   %eax
  80034d:	68 b2 02 80 00       	push   $0x8002b2
  800352:	e8 5a 02 00 00       	call   8005b1 <vprintfmt>
  800357:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName, curTextClr);
  80035a:	8b 15 18 b1 81 00    	mov    0x81b118,%edx
  800360:	a0 44 30 80 00       	mov    0x803044,%al
  800365:	0f b6 c0             	movzbl %al,%eax
  800368:	8b 8d f0 fe ff ff    	mov    -0x110(%ebp),%ecx
  80036e:	52                   	push   %edx
  80036f:	50                   	push   %eax
  800370:	51                   	push   %ecx
  800371:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800377:	83 c0 08             	add    $0x8,%eax
  80037a:	50                   	push   %eax
  80037b:	e8 2a 11 00 00       	call   8014aa <sys_cputs>
  800380:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800383:	c6 05 44 30 80 00 00 	movb   $0x0,0x803044
	return b.cnt;
  80038a:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800390:	c9                   	leave  
  800391:	c3                   	ret    

00800392 <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  800392:	55                   	push   %ebp
  800393:	89 e5                	mov    %esp,%ebp
  800395:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800398:	c6 05 44 30 80 00 01 	movb   $0x1,0x803044
	va_start(ap, fmt);
  80039f:	8d 45 0c             	lea    0xc(%ebp),%eax
  8003a2:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8003a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8003a8:	83 ec 08             	sub    $0x8,%esp
  8003ab:	ff 75 f4             	pushl  -0xc(%ebp)
  8003ae:	50                   	push   %eax
  8003af:	e8 6f ff ff ff       	call   800323 <vcprintf>
  8003b4:	83 c4 10             	add    $0x10,%esp
  8003b7:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  8003ba:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8003bd:	c9                   	leave  
  8003be:	c3                   	ret    

008003bf <cprintf_colored>:

// *************** This text coloring feature is implemented by *************
// ********** Abd-Alrahman Zedan From Team Frozen-Bytes - FCIS'24-25 ********
int cprintf_colored(int textClr, const char *fmt, ...) {
  8003bf:	55                   	push   %ebp
  8003c0:	89 e5                	mov    %esp,%ebp
  8003c2:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  8003c5:	c6 05 44 30 80 00 01 	movb   $0x1,0x803044
	curTextClr = (textClr << 8) ; //set text color by the given value
  8003cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8003cf:	c1 e0 08             	shl    $0x8,%eax
  8003d2:	a3 18 b1 81 00       	mov    %eax,0x81b118
	va_start(ap, fmt);
  8003d7:	8d 45 0c             	lea    0xc(%ebp),%eax
  8003da:	83 c0 04             	add    $0x4,%eax
  8003dd:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8003e0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003e3:	83 ec 08             	sub    $0x8,%esp
  8003e6:	ff 75 f4             	pushl  -0xc(%ebp)
  8003e9:	50                   	push   %eax
  8003ea:	e8 34 ff ff ff       	call   800323 <vcprintf>
  8003ef:	83 c4 10             	add    $0x10,%esp
  8003f2:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);
	curTextClr = TEXT_DEFAULT_CLR; //restore default color
  8003f5:	c7 05 18 b1 81 00 00 	movl   $0x700,0x81b118
  8003fc:	07 00 00 

	return cnt;
  8003ff:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800402:	c9                   	leave  
  800403:	c3                   	ret    

00800404 <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  800404:	55                   	push   %ebp
  800405:	89 e5                	mov    %esp,%ebp
  800407:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  80040a:	e8 df 10 00 00       	call   8014ee <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  80040f:	8d 45 0c             	lea    0xc(%ebp),%eax
  800412:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  800415:	8b 45 08             	mov    0x8(%ebp),%eax
  800418:	83 ec 08             	sub    $0x8,%esp
  80041b:	ff 75 f4             	pushl  -0xc(%ebp)
  80041e:	50                   	push   %eax
  80041f:	e8 ff fe ff ff       	call   800323 <vcprintf>
  800424:	83 c4 10             	add    $0x10,%esp
  800427:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  80042a:	e8 d9 10 00 00       	call   801508 <sys_unlock_cons>
	return cnt;
  80042f:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800432:	c9                   	leave  
  800433:	c3                   	ret    

00800434 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800434:	55                   	push   %ebp
  800435:	89 e5                	mov    %esp,%ebp
  800437:	53                   	push   %ebx
  800438:	83 ec 14             	sub    $0x14,%esp
  80043b:	8b 45 10             	mov    0x10(%ebp),%eax
  80043e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800441:	8b 45 14             	mov    0x14(%ebp),%eax
  800444:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800447:	8b 45 18             	mov    0x18(%ebp),%eax
  80044a:	ba 00 00 00 00       	mov    $0x0,%edx
  80044f:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800452:	77 55                	ja     8004a9 <printnum+0x75>
  800454:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800457:	72 05                	jb     80045e <printnum+0x2a>
  800459:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80045c:	77 4b                	ja     8004a9 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  80045e:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800461:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800464:	8b 45 18             	mov    0x18(%ebp),%eax
  800467:	ba 00 00 00 00       	mov    $0x0,%edx
  80046c:	52                   	push   %edx
  80046d:	50                   	push   %eax
  80046e:	ff 75 f4             	pushl  -0xc(%ebp)
  800471:	ff 75 f0             	pushl  -0x10(%ebp)
  800474:	e8 db 17 00 00       	call   801c54 <__udivdi3>
  800479:	83 c4 10             	add    $0x10,%esp
  80047c:	83 ec 04             	sub    $0x4,%esp
  80047f:	ff 75 20             	pushl  0x20(%ebp)
  800482:	53                   	push   %ebx
  800483:	ff 75 18             	pushl  0x18(%ebp)
  800486:	52                   	push   %edx
  800487:	50                   	push   %eax
  800488:	ff 75 0c             	pushl  0xc(%ebp)
  80048b:	ff 75 08             	pushl  0x8(%ebp)
  80048e:	e8 a1 ff ff ff       	call   800434 <printnum>
  800493:	83 c4 20             	add    $0x20,%esp
  800496:	eb 1a                	jmp    8004b2 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800498:	83 ec 08             	sub    $0x8,%esp
  80049b:	ff 75 0c             	pushl  0xc(%ebp)
  80049e:	ff 75 20             	pushl  0x20(%ebp)
  8004a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8004a4:	ff d0                	call   *%eax
  8004a6:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8004a9:	ff 4d 1c             	decl   0x1c(%ebp)
  8004ac:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  8004b0:	7f e6                	jg     800498 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8004b2:	8b 4d 18             	mov    0x18(%ebp),%ecx
  8004b5:	bb 00 00 00 00       	mov    $0x0,%ebx
  8004ba:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8004bd:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8004c0:	53                   	push   %ebx
  8004c1:	51                   	push   %ecx
  8004c2:	52                   	push   %edx
  8004c3:	50                   	push   %eax
  8004c4:	e8 9b 18 00 00       	call   801d64 <__umoddi3>
  8004c9:	83 c4 10             	add    $0x10,%esp
  8004cc:	05 74 22 80 00       	add    $0x802274,%eax
  8004d1:	8a 00                	mov    (%eax),%al
  8004d3:	0f be c0             	movsbl %al,%eax
  8004d6:	83 ec 08             	sub    $0x8,%esp
  8004d9:	ff 75 0c             	pushl  0xc(%ebp)
  8004dc:	50                   	push   %eax
  8004dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8004e0:	ff d0                	call   *%eax
  8004e2:	83 c4 10             	add    $0x10,%esp
}
  8004e5:	90                   	nop
  8004e6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8004e9:	c9                   	leave  
  8004ea:	c3                   	ret    

008004eb <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8004eb:	55                   	push   %ebp
  8004ec:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8004ee:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8004f2:	7e 1c                	jle    800510 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  8004f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8004f7:	8b 00                	mov    (%eax),%eax
  8004f9:	8d 50 08             	lea    0x8(%eax),%edx
  8004fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8004ff:	89 10                	mov    %edx,(%eax)
  800501:	8b 45 08             	mov    0x8(%ebp),%eax
  800504:	8b 00                	mov    (%eax),%eax
  800506:	83 e8 08             	sub    $0x8,%eax
  800509:	8b 50 04             	mov    0x4(%eax),%edx
  80050c:	8b 00                	mov    (%eax),%eax
  80050e:	eb 40                	jmp    800550 <getuint+0x65>
	else if (lflag)
  800510:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800514:	74 1e                	je     800534 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800516:	8b 45 08             	mov    0x8(%ebp),%eax
  800519:	8b 00                	mov    (%eax),%eax
  80051b:	8d 50 04             	lea    0x4(%eax),%edx
  80051e:	8b 45 08             	mov    0x8(%ebp),%eax
  800521:	89 10                	mov    %edx,(%eax)
  800523:	8b 45 08             	mov    0x8(%ebp),%eax
  800526:	8b 00                	mov    (%eax),%eax
  800528:	83 e8 04             	sub    $0x4,%eax
  80052b:	8b 00                	mov    (%eax),%eax
  80052d:	ba 00 00 00 00       	mov    $0x0,%edx
  800532:	eb 1c                	jmp    800550 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800534:	8b 45 08             	mov    0x8(%ebp),%eax
  800537:	8b 00                	mov    (%eax),%eax
  800539:	8d 50 04             	lea    0x4(%eax),%edx
  80053c:	8b 45 08             	mov    0x8(%ebp),%eax
  80053f:	89 10                	mov    %edx,(%eax)
  800541:	8b 45 08             	mov    0x8(%ebp),%eax
  800544:	8b 00                	mov    (%eax),%eax
  800546:	83 e8 04             	sub    $0x4,%eax
  800549:	8b 00                	mov    (%eax),%eax
  80054b:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800550:	5d                   	pop    %ebp
  800551:	c3                   	ret    

00800552 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800552:	55                   	push   %ebp
  800553:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800555:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800559:	7e 1c                	jle    800577 <getint+0x25>
		return va_arg(*ap, long long);
  80055b:	8b 45 08             	mov    0x8(%ebp),%eax
  80055e:	8b 00                	mov    (%eax),%eax
  800560:	8d 50 08             	lea    0x8(%eax),%edx
  800563:	8b 45 08             	mov    0x8(%ebp),%eax
  800566:	89 10                	mov    %edx,(%eax)
  800568:	8b 45 08             	mov    0x8(%ebp),%eax
  80056b:	8b 00                	mov    (%eax),%eax
  80056d:	83 e8 08             	sub    $0x8,%eax
  800570:	8b 50 04             	mov    0x4(%eax),%edx
  800573:	8b 00                	mov    (%eax),%eax
  800575:	eb 38                	jmp    8005af <getint+0x5d>
	else if (lflag)
  800577:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80057b:	74 1a                	je     800597 <getint+0x45>
		return va_arg(*ap, long);
  80057d:	8b 45 08             	mov    0x8(%ebp),%eax
  800580:	8b 00                	mov    (%eax),%eax
  800582:	8d 50 04             	lea    0x4(%eax),%edx
  800585:	8b 45 08             	mov    0x8(%ebp),%eax
  800588:	89 10                	mov    %edx,(%eax)
  80058a:	8b 45 08             	mov    0x8(%ebp),%eax
  80058d:	8b 00                	mov    (%eax),%eax
  80058f:	83 e8 04             	sub    $0x4,%eax
  800592:	8b 00                	mov    (%eax),%eax
  800594:	99                   	cltd   
  800595:	eb 18                	jmp    8005af <getint+0x5d>
	else
		return va_arg(*ap, int);
  800597:	8b 45 08             	mov    0x8(%ebp),%eax
  80059a:	8b 00                	mov    (%eax),%eax
  80059c:	8d 50 04             	lea    0x4(%eax),%edx
  80059f:	8b 45 08             	mov    0x8(%ebp),%eax
  8005a2:	89 10                	mov    %edx,(%eax)
  8005a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8005a7:	8b 00                	mov    (%eax),%eax
  8005a9:	83 e8 04             	sub    $0x4,%eax
  8005ac:	8b 00                	mov    (%eax),%eax
  8005ae:	99                   	cltd   
}
  8005af:	5d                   	pop    %ebp
  8005b0:	c3                   	ret    

008005b1 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8005b1:	55                   	push   %ebp
  8005b2:	89 e5                	mov    %esp,%ebp
  8005b4:	56                   	push   %esi
  8005b5:	53                   	push   %ebx
  8005b6:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8005b9:	eb 17                	jmp    8005d2 <vprintfmt+0x21>
			if (ch == '\0')
  8005bb:	85 db                	test   %ebx,%ebx
  8005bd:	0f 84 c1 03 00 00    	je     800984 <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  8005c3:	83 ec 08             	sub    $0x8,%esp
  8005c6:	ff 75 0c             	pushl  0xc(%ebp)
  8005c9:	53                   	push   %ebx
  8005ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8005cd:	ff d0                	call   *%eax
  8005cf:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8005d2:	8b 45 10             	mov    0x10(%ebp),%eax
  8005d5:	8d 50 01             	lea    0x1(%eax),%edx
  8005d8:	89 55 10             	mov    %edx,0x10(%ebp)
  8005db:	8a 00                	mov    (%eax),%al
  8005dd:	0f b6 d8             	movzbl %al,%ebx
  8005e0:	83 fb 25             	cmp    $0x25,%ebx
  8005e3:	75 d6                	jne    8005bb <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  8005e5:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  8005e9:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  8005f0:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8005f7:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  8005fe:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800605:	8b 45 10             	mov    0x10(%ebp),%eax
  800608:	8d 50 01             	lea    0x1(%eax),%edx
  80060b:	89 55 10             	mov    %edx,0x10(%ebp)
  80060e:	8a 00                	mov    (%eax),%al
  800610:	0f b6 d8             	movzbl %al,%ebx
  800613:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800616:	83 f8 5b             	cmp    $0x5b,%eax
  800619:	0f 87 3d 03 00 00    	ja     80095c <vprintfmt+0x3ab>
  80061f:	8b 04 85 98 22 80 00 	mov    0x802298(,%eax,4),%eax
  800626:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800628:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  80062c:	eb d7                	jmp    800605 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  80062e:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800632:	eb d1                	jmp    800605 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800634:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  80063b:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80063e:	89 d0                	mov    %edx,%eax
  800640:	c1 e0 02             	shl    $0x2,%eax
  800643:	01 d0                	add    %edx,%eax
  800645:	01 c0                	add    %eax,%eax
  800647:	01 d8                	add    %ebx,%eax
  800649:	83 e8 30             	sub    $0x30,%eax
  80064c:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  80064f:	8b 45 10             	mov    0x10(%ebp),%eax
  800652:	8a 00                	mov    (%eax),%al
  800654:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800657:	83 fb 2f             	cmp    $0x2f,%ebx
  80065a:	7e 3e                	jle    80069a <vprintfmt+0xe9>
  80065c:	83 fb 39             	cmp    $0x39,%ebx
  80065f:	7f 39                	jg     80069a <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800661:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800664:	eb d5                	jmp    80063b <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800666:	8b 45 14             	mov    0x14(%ebp),%eax
  800669:	83 c0 04             	add    $0x4,%eax
  80066c:	89 45 14             	mov    %eax,0x14(%ebp)
  80066f:	8b 45 14             	mov    0x14(%ebp),%eax
  800672:	83 e8 04             	sub    $0x4,%eax
  800675:	8b 00                	mov    (%eax),%eax
  800677:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  80067a:	eb 1f                	jmp    80069b <vprintfmt+0xea>

		case '.':
			if (width < 0)
  80067c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800680:	79 83                	jns    800605 <vprintfmt+0x54>
				width = 0;
  800682:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800689:	e9 77 ff ff ff       	jmp    800605 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  80068e:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800695:	e9 6b ff ff ff       	jmp    800605 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  80069a:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  80069b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80069f:	0f 89 60 ff ff ff    	jns    800605 <vprintfmt+0x54>
				width = precision, precision = -1;
  8006a5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8006a8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8006ab:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  8006b2:	e9 4e ff ff ff       	jmp    800605 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  8006b7:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  8006ba:	e9 46 ff ff ff       	jmp    800605 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  8006bf:	8b 45 14             	mov    0x14(%ebp),%eax
  8006c2:	83 c0 04             	add    $0x4,%eax
  8006c5:	89 45 14             	mov    %eax,0x14(%ebp)
  8006c8:	8b 45 14             	mov    0x14(%ebp),%eax
  8006cb:	83 e8 04             	sub    $0x4,%eax
  8006ce:	8b 00                	mov    (%eax),%eax
  8006d0:	83 ec 08             	sub    $0x8,%esp
  8006d3:	ff 75 0c             	pushl  0xc(%ebp)
  8006d6:	50                   	push   %eax
  8006d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8006da:	ff d0                	call   *%eax
  8006dc:	83 c4 10             	add    $0x10,%esp
			break;
  8006df:	e9 9b 02 00 00       	jmp    80097f <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  8006e4:	8b 45 14             	mov    0x14(%ebp),%eax
  8006e7:	83 c0 04             	add    $0x4,%eax
  8006ea:	89 45 14             	mov    %eax,0x14(%ebp)
  8006ed:	8b 45 14             	mov    0x14(%ebp),%eax
  8006f0:	83 e8 04             	sub    $0x4,%eax
  8006f3:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  8006f5:	85 db                	test   %ebx,%ebx
  8006f7:	79 02                	jns    8006fb <vprintfmt+0x14a>
				err = -err;
  8006f9:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  8006fb:	83 fb 64             	cmp    $0x64,%ebx
  8006fe:	7f 0b                	jg     80070b <vprintfmt+0x15a>
  800700:	8b 34 9d e0 20 80 00 	mov    0x8020e0(,%ebx,4),%esi
  800707:	85 f6                	test   %esi,%esi
  800709:	75 19                	jne    800724 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  80070b:	53                   	push   %ebx
  80070c:	68 85 22 80 00       	push   $0x802285
  800711:	ff 75 0c             	pushl  0xc(%ebp)
  800714:	ff 75 08             	pushl  0x8(%ebp)
  800717:	e8 70 02 00 00       	call   80098c <printfmt>
  80071c:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  80071f:	e9 5b 02 00 00       	jmp    80097f <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800724:	56                   	push   %esi
  800725:	68 8e 22 80 00       	push   $0x80228e
  80072a:	ff 75 0c             	pushl  0xc(%ebp)
  80072d:	ff 75 08             	pushl  0x8(%ebp)
  800730:	e8 57 02 00 00       	call   80098c <printfmt>
  800735:	83 c4 10             	add    $0x10,%esp
			break;
  800738:	e9 42 02 00 00       	jmp    80097f <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  80073d:	8b 45 14             	mov    0x14(%ebp),%eax
  800740:	83 c0 04             	add    $0x4,%eax
  800743:	89 45 14             	mov    %eax,0x14(%ebp)
  800746:	8b 45 14             	mov    0x14(%ebp),%eax
  800749:	83 e8 04             	sub    $0x4,%eax
  80074c:	8b 30                	mov    (%eax),%esi
  80074e:	85 f6                	test   %esi,%esi
  800750:	75 05                	jne    800757 <vprintfmt+0x1a6>
				p = "(null)";
  800752:	be 91 22 80 00       	mov    $0x802291,%esi
			if (width > 0 && padc != '-')
  800757:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80075b:	7e 6d                	jle    8007ca <vprintfmt+0x219>
  80075d:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800761:	74 67                	je     8007ca <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800763:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800766:	83 ec 08             	sub    $0x8,%esp
  800769:	50                   	push   %eax
  80076a:	56                   	push   %esi
  80076b:	e8 26 05 00 00       	call   800c96 <strnlen>
  800770:	83 c4 10             	add    $0x10,%esp
  800773:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800776:	eb 16                	jmp    80078e <vprintfmt+0x1dd>
					putch(padc, putdat);
  800778:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  80077c:	83 ec 08             	sub    $0x8,%esp
  80077f:	ff 75 0c             	pushl  0xc(%ebp)
  800782:	50                   	push   %eax
  800783:	8b 45 08             	mov    0x8(%ebp),%eax
  800786:	ff d0                	call   *%eax
  800788:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  80078b:	ff 4d e4             	decl   -0x1c(%ebp)
  80078e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800792:	7f e4                	jg     800778 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800794:	eb 34                	jmp    8007ca <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800796:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  80079a:	74 1c                	je     8007b8 <vprintfmt+0x207>
  80079c:	83 fb 1f             	cmp    $0x1f,%ebx
  80079f:	7e 05                	jle    8007a6 <vprintfmt+0x1f5>
  8007a1:	83 fb 7e             	cmp    $0x7e,%ebx
  8007a4:	7e 12                	jle    8007b8 <vprintfmt+0x207>
					putch('?', putdat);
  8007a6:	83 ec 08             	sub    $0x8,%esp
  8007a9:	ff 75 0c             	pushl  0xc(%ebp)
  8007ac:	6a 3f                	push   $0x3f
  8007ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8007b1:	ff d0                	call   *%eax
  8007b3:	83 c4 10             	add    $0x10,%esp
  8007b6:	eb 0f                	jmp    8007c7 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  8007b8:	83 ec 08             	sub    $0x8,%esp
  8007bb:	ff 75 0c             	pushl  0xc(%ebp)
  8007be:	53                   	push   %ebx
  8007bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8007c2:	ff d0                	call   *%eax
  8007c4:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8007c7:	ff 4d e4             	decl   -0x1c(%ebp)
  8007ca:	89 f0                	mov    %esi,%eax
  8007cc:	8d 70 01             	lea    0x1(%eax),%esi
  8007cf:	8a 00                	mov    (%eax),%al
  8007d1:	0f be d8             	movsbl %al,%ebx
  8007d4:	85 db                	test   %ebx,%ebx
  8007d6:	74 24                	je     8007fc <vprintfmt+0x24b>
  8007d8:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8007dc:	78 b8                	js     800796 <vprintfmt+0x1e5>
  8007de:	ff 4d e0             	decl   -0x20(%ebp)
  8007e1:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8007e5:	79 af                	jns    800796 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8007e7:	eb 13                	jmp    8007fc <vprintfmt+0x24b>
				putch(' ', putdat);
  8007e9:	83 ec 08             	sub    $0x8,%esp
  8007ec:	ff 75 0c             	pushl  0xc(%ebp)
  8007ef:	6a 20                	push   $0x20
  8007f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8007f4:	ff d0                	call   *%eax
  8007f6:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8007f9:	ff 4d e4             	decl   -0x1c(%ebp)
  8007fc:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800800:	7f e7                	jg     8007e9 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800802:	e9 78 01 00 00       	jmp    80097f <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800807:	83 ec 08             	sub    $0x8,%esp
  80080a:	ff 75 e8             	pushl  -0x18(%ebp)
  80080d:	8d 45 14             	lea    0x14(%ebp),%eax
  800810:	50                   	push   %eax
  800811:	e8 3c fd ff ff       	call   800552 <getint>
  800816:	83 c4 10             	add    $0x10,%esp
  800819:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80081c:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  80081f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800822:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800825:	85 d2                	test   %edx,%edx
  800827:	79 23                	jns    80084c <vprintfmt+0x29b>
				putch('-', putdat);
  800829:	83 ec 08             	sub    $0x8,%esp
  80082c:	ff 75 0c             	pushl  0xc(%ebp)
  80082f:	6a 2d                	push   $0x2d
  800831:	8b 45 08             	mov    0x8(%ebp),%eax
  800834:	ff d0                	call   *%eax
  800836:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800839:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80083c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80083f:	f7 d8                	neg    %eax
  800841:	83 d2 00             	adc    $0x0,%edx
  800844:	f7 da                	neg    %edx
  800846:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800849:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  80084c:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800853:	e9 bc 00 00 00       	jmp    800914 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800858:	83 ec 08             	sub    $0x8,%esp
  80085b:	ff 75 e8             	pushl  -0x18(%ebp)
  80085e:	8d 45 14             	lea    0x14(%ebp),%eax
  800861:	50                   	push   %eax
  800862:	e8 84 fc ff ff       	call   8004eb <getuint>
  800867:	83 c4 10             	add    $0x10,%esp
  80086a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80086d:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800870:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800877:	e9 98 00 00 00       	jmp    800914 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  80087c:	83 ec 08             	sub    $0x8,%esp
  80087f:	ff 75 0c             	pushl  0xc(%ebp)
  800882:	6a 58                	push   $0x58
  800884:	8b 45 08             	mov    0x8(%ebp),%eax
  800887:	ff d0                	call   *%eax
  800889:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  80088c:	83 ec 08             	sub    $0x8,%esp
  80088f:	ff 75 0c             	pushl  0xc(%ebp)
  800892:	6a 58                	push   $0x58
  800894:	8b 45 08             	mov    0x8(%ebp),%eax
  800897:	ff d0                	call   *%eax
  800899:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  80089c:	83 ec 08             	sub    $0x8,%esp
  80089f:	ff 75 0c             	pushl  0xc(%ebp)
  8008a2:	6a 58                	push   $0x58
  8008a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8008a7:	ff d0                	call   *%eax
  8008a9:	83 c4 10             	add    $0x10,%esp
			break;
  8008ac:	e9 ce 00 00 00       	jmp    80097f <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  8008b1:	83 ec 08             	sub    $0x8,%esp
  8008b4:	ff 75 0c             	pushl  0xc(%ebp)
  8008b7:	6a 30                	push   $0x30
  8008b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8008bc:	ff d0                	call   *%eax
  8008be:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  8008c1:	83 ec 08             	sub    $0x8,%esp
  8008c4:	ff 75 0c             	pushl  0xc(%ebp)
  8008c7:	6a 78                	push   $0x78
  8008c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8008cc:	ff d0                	call   *%eax
  8008ce:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  8008d1:	8b 45 14             	mov    0x14(%ebp),%eax
  8008d4:	83 c0 04             	add    $0x4,%eax
  8008d7:	89 45 14             	mov    %eax,0x14(%ebp)
  8008da:	8b 45 14             	mov    0x14(%ebp),%eax
  8008dd:	83 e8 04             	sub    $0x4,%eax
  8008e0:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  8008e2:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8008e5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  8008ec:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  8008f3:	eb 1f                	jmp    800914 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  8008f5:	83 ec 08             	sub    $0x8,%esp
  8008f8:	ff 75 e8             	pushl  -0x18(%ebp)
  8008fb:	8d 45 14             	lea    0x14(%ebp),%eax
  8008fe:	50                   	push   %eax
  8008ff:	e8 e7 fb ff ff       	call   8004eb <getuint>
  800904:	83 c4 10             	add    $0x10,%esp
  800907:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80090a:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  80090d:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800914:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800918:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80091b:	83 ec 04             	sub    $0x4,%esp
  80091e:	52                   	push   %edx
  80091f:	ff 75 e4             	pushl  -0x1c(%ebp)
  800922:	50                   	push   %eax
  800923:	ff 75 f4             	pushl  -0xc(%ebp)
  800926:	ff 75 f0             	pushl  -0x10(%ebp)
  800929:	ff 75 0c             	pushl  0xc(%ebp)
  80092c:	ff 75 08             	pushl  0x8(%ebp)
  80092f:	e8 00 fb ff ff       	call   800434 <printnum>
  800934:	83 c4 20             	add    $0x20,%esp
			break;
  800937:	eb 46                	jmp    80097f <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800939:	83 ec 08             	sub    $0x8,%esp
  80093c:	ff 75 0c             	pushl  0xc(%ebp)
  80093f:	53                   	push   %ebx
  800940:	8b 45 08             	mov    0x8(%ebp),%eax
  800943:	ff d0                	call   *%eax
  800945:	83 c4 10             	add    $0x10,%esp
			break;
  800948:	eb 35                	jmp    80097f <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  80094a:	c6 05 44 30 80 00 00 	movb   $0x0,0x803044
			break;
  800951:	eb 2c                	jmp    80097f <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  800953:	c6 05 44 30 80 00 01 	movb   $0x1,0x803044
			break;
  80095a:	eb 23                	jmp    80097f <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  80095c:	83 ec 08             	sub    $0x8,%esp
  80095f:	ff 75 0c             	pushl  0xc(%ebp)
  800962:	6a 25                	push   $0x25
  800964:	8b 45 08             	mov    0x8(%ebp),%eax
  800967:	ff d0                	call   *%eax
  800969:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  80096c:	ff 4d 10             	decl   0x10(%ebp)
  80096f:	eb 03                	jmp    800974 <vprintfmt+0x3c3>
  800971:	ff 4d 10             	decl   0x10(%ebp)
  800974:	8b 45 10             	mov    0x10(%ebp),%eax
  800977:	48                   	dec    %eax
  800978:	8a 00                	mov    (%eax),%al
  80097a:	3c 25                	cmp    $0x25,%al
  80097c:	75 f3                	jne    800971 <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  80097e:	90                   	nop
		}
	}
  80097f:	e9 35 fc ff ff       	jmp    8005b9 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800984:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800985:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800988:	5b                   	pop    %ebx
  800989:	5e                   	pop    %esi
  80098a:	5d                   	pop    %ebp
  80098b:	c3                   	ret    

0080098c <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  80098c:	55                   	push   %ebp
  80098d:	89 e5                	mov    %esp,%ebp
  80098f:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800992:	8d 45 10             	lea    0x10(%ebp),%eax
  800995:	83 c0 04             	add    $0x4,%eax
  800998:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  80099b:	8b 45 10             	mov    0x10(%ebp),%eax
  80099e:	ff 75 f4             	pushl  -0xc(%ebp)
  8009a1:	50                   	push   %eax
  8009a2:	ff 75 0c             	pushl  0xc(%ebp)
  8009a5:	ff 75 08             	pushl  0x8(%ebp)
  8009a8:	e8 04 fc ff ff       	call   8005b1 <vprintfmt>
  8009ad:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  8009b0:	90                   	nop
  8009b1:	c9                   	leave  
  8009b2:	c3                   	ret    

008009b3 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8009b3:	55                   	push   %ebp
  8009b4:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  8009b6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009b9:	8b 40 08             	mov    0x8(%eax),%eax
  8009bc:	8d 50 01             	lea    0x1(%eax),%edx
  8009bf:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009c2:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  8009c5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009c8:	8b 10                	mov    (%eax),%edx
  8009ca:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009cd:	8b 40 04             	mov    0x4(%eax),%eax
  8009d0:	39 c2                	cmp    %eax,%edx
  8009d2:	73 12                	jae    8009e6 <sprintputch+0x33>
		*b->buf++ = ch;
  8009d4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009d7:	8b 00                	mov    (%eax),%eax
  8009d9:	8d 48 01             	lea    0x1(%eax),%ecx
  8009dc:	8b 55 0c             	mov    0xc(%ebp),%edx
  8009df:	89 0a                	mov    %ecx,(%edx)
  8009e1:	8b 55 08             	mov    0x8(%ebp),%edx
  8009e4:	88 10                	mov    %dl,(%eax)
}
  8009e6:	90                   	nop
  8009e7:	5d                   	pop    %ebp
  8009e8:	c3                   	ret    

008009e9 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8009e9:	55                   	push   %ebp
  8009ea:	89 e5                	mov    %esp,%ebp
  8009ec:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  8009ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8009f2:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8009f5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009f8:	8d 50 ff             	lea    -0x1(%eax),%edx
  8009fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8009fe:	01 d0                	add    %edx,%eax
  800a00:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a03:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800a0a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800a0e:	74 06                	je     800a16 <vsnprintf+0x2d>
  800a10:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800a14:	7f 07                	jg     800a1d <vsnprintf+0x34>
		return -E_INVAL;
  800a16:	b8 03 00 00 00       	mov    $0x3,%eax
  800a1b:	eb 20                	jmp    800a3d <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800a1d:	ff 75 14             	pushl  0x14(%ebp)
  800a20:	ff 75 10             	pushl  0x10(%ebp)
  800a23:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800a26:	50                   	push   %eax
  800a27:	68 b3 09 80 00       	push   $0x8009b3
  800a2c:	e8 80 fb ff ff       	call   8005b1 <vprintfmt>
  800a31:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800a34:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800a37:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800a3a:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800a3d:	c9                   	leave  
  800a3e:	c3                   	ret    

00800a3f <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800a3f:	55                   	push   %ebp
  800a40:	89 e5                	mov    %esp,%ebp
  800a42:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800a45:	8d 45 10             	lea    0x10(%ebp),%eax
  800a48:	83 c0 04             	add    $0x4,%eax
  800a4b:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800a4e:	8b 45 10             	mov    0x10(%ebp),%eax
  800a51:	ff 75 f4             	pushl  -0xc(%ebp)
  800a54:	50                   	push   %eax
  800a55:	ff 75 0c             	pushl  0xc(%ebp)
  800a58:	ff 75 08             	pushl  0x8(%ebp)
  800a5b:	e8 89 ff ff ff       	call   8009e9 <vsnprintf>
  800a60:	83 c4 10             	add    $0x10,%esp
  800a63:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800a66:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800a69:	c9                   	leave  
  800a6a:	c3                   	ret    

00800a6b <readline>:
#include <inc/lib.h>

//static char buf[BUFLEN];

void readline(const char *prompt, char* buf)
{
  800a6b:	55                   	push   %ebp
  800a6c:	89 e5                	mov    %esp,%ebp
  800a6e:	83 ec 18             	sub    $0x18,%esp
	int i, c, echoing;

	if (prompt != NULL)
  800a71:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800a75:	74 13                	je     800a8a <readline+0x1f>
		cprintf("%s", prompt);
  800a77:	83 ec 08             	sub    $0x8,%esp
  800a7a:	ff 75 08             	pushl  0x8(%ebp)
  800a7d:	68 08 24 80 00       	push   $0x802408
  800a82:	e8 0b f9 ff ff       	call   800392 <cprintf>
  800a87:	83 c4 10             	add    $0x10,%esp

	i = 0;
  800a8a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	echoing = iscons(0);
  800a91:	83 ec 0c             	sub    $0xc,%esp
  800a94:	6a 00                	push   $0x0
  800a96:	e8 c0 0f 00 00       	call   801a5b <iscons>
  800a9b:	83 c4 10             	add    $0x10,%esp
  800a9e:	89 45 f0             	mov    %eax,-0x10(%ebp)
	while (1) {
		c = getchar();
  800aa1:	e8 a2 0f 00 00       	call   801a48 <getchar>
  800aa6:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if (c < 0) {
  800aa9:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800aad:	79 22                	jns    800ad1 <readline+0x66>
			if (c != -E_EOF)
  800aaf:	83 7d ec 07          	cmpl   $0x7,-0x14(%ebp)
  800ab3:	0f 84 ad 00 00 00    	je     800b66 <readline+0xfb>
				cprintf("read error: %e\n", c);
  800ab9:	83 ec 08             	sub    $0x8,%esp
  800abc:	ff 75 ec             	pushl  -0x14(%ebp)
  800abf:	68 0b 24 80 00       	push   $0x80240b
  800ac4:	e8 c9 f8 ff ff       	call   800392 <cprintf>
  800ac9:	83 c4 10             	add    $0x10,%esp
			break;
  800acc:	e9 95 00 00 00       	jmp    800b66 <readline+0xfb>
		} else if (c >= ' ' && i < BUFLEN-1) {
  800ad1:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%ebp)
  800ad5:	7e 34                	jle    800b0b <readline+0xa0>
  800ad7:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  800ade:	7f 2b                	jg     800b0b <readline+0xa0>
			if (echoing)
  800ae0:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800ae4:	74 0e                	je     800af4 <readline+0x89>
				cputchar(c);
  800ae6:	83 ec 0c             	sub    $0xc,%esp
  800ae9:	ff 75 ec             	pushl  -0x14(%ebp)
  800aec:	e8 38 0f 00 00       	call   801a29 <cputchar>
  800af1:	83 c4 10             	add    $0x10,%esp
			buf[i++] = c;
  800af4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800af7:	8d 50 01             	lea    0x1(%eax),%edx
  800afa:	89 55 f4             	mov    %edx,-0xc(%ebp)
  800afd:	89 c2                	mov    %eax,%edx
  800aff:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b02:	01 d0                	add    %edx,%eax
  800b04:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800b07:	88 10                	mov    %dl,(%eax)
  800b09:	eb 56                	jmp    800b61 <readline+0xf6>
		} else if (c == '\b' && i > 0) {
  800b0b:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  800b0f:	75 1f                	jne    800b30 <readline+0xc5>
  800b11:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  800b15:	7e 19                	jle    800b30 <readline+0xc5>
			if (echoing)
  800b17:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800b1b:	74 0e                	je     800b2b <readline+0xc0>
				cputchar(c);
  800b1d:	83 ec 0c             	sub    $0xc,%esp
  800b20:	ff 75 ec             	pushl  -0x14(%ebp)
  800b23:	e8 01 0f 00 00       	call   801a29 <cputchar>
  800b28:	83 c4 10             	add    $0x10,%esp

			i--;
  800b2b:	ff 4d f4             	decl   -0xc(%ebp)
  800b2e:	eb 31                	jmp    800b61 <readline+0xf6>
		} else if (c == '\n' || c == '\r') {
  800b30:	83 7d ec 0a          	cmpl   $0xa,-0x14(%ebp)
  800b34:	74 0a                	je     800b40 <readline+0xd5>
  800b36:	83 7d ec 0d          	cmpl   $0xd,-0x14(%ebp)
  800b3a:	0f 85 61 ff ff ff    	jne    800aa1 <readline+0x36>
			if (echoing)
  800b40:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800b44:	74 0e                	je     800b54 <readline+0xe9>
				cputchar(c);
  800b46:	83 ec 0c             	sub    $0xc,%esp
  800b49:	ff 75 ec             	pushl  -0x14(%ebp)
  800b4c:	e8 d8 0e 00 00       	call   801a29 <cputchar>
  800b51:	83 c4 10             	add    $0x10,%esp

			buf[i] = 0;
  800b54:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800b57:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b5a:	01 d0                	add    %edx,%eax
  800b5c:	c6 00 00             	movb   $0x0,(%eax)
			break;
  800b5f:	eb 06                	jmp    800b67 <readline+0xfc>
		}
	}
  800b61:	e9 3b ff ff ff       	jmp    800aa1 <readline+0x36>
	while (1) {
		c = getchar();
		if (c < 0) {
			if (c != -E_EOF)
				cprintf("read error: %e\n", c);
			break;
  800b66:	90                   	nop

			buf[i] = 0;
			break;
		}
	}
}
  800b67:	90                   	nop
  800b68:	c9                   	leave  
  800b69:	c3                   	ret    

00800b6a <atomic_readline>:

void atomic_readline(const char *prompt, char* buf)
{
  800b6a:	55                   	push   %ebp
  800b6b:	89 e5                	mov    %esp,%ebp
  800b6d:	83 ec 18             	sub    $0x18,%esp
	sys_lock_cons();
  800b70:	e8 79 09 00 00       	call   8014ee <sys_lock_cons>
	{
		int i, c, echoing;

		if (prompt != NULL)
  800b75:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800b79:	74 13                	je     800b8e <atomic_readline+0x24>
			cprintf("%s", prompt);
  800b7b:	83 ec 08             	sub    $0x8,%esp
  800b7e:	ff 75 08             	pushl  0x8(%ebp)
  800b81:	68 08 24 80 00       	push   $0x802408
  800b86:	e8 07 f8 ff ff       	call   800392 <cprintf>
  800b8b:	83 c4 10             	add    $0x10,%esp

		i = 0;
  800b8e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
		echoing = iscons(0);
  800b95:	83 ec 0c             	sub    $0xc,%esp
  800b98:	6a 00                	push   $0x0
  800b9a:	e8 bc 0e 00 00       	call   801a5b <iscons>
  800b9f:	83 c4 10             	add    $0x10,%esp
  800ba2:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (1) {
			c = getchar();
  800ba5:	e8 9e 0e 00 00       	call   801a48 <getchar>
  800baa:	89 45 ec             	mov    %eax,-0x14(%ebp)
			if (c < 0) {
  800bad:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800bb1:	79 22                	jns    800bd5 <atomic_readline+0x6b>
				if (c != -E_EOF)
  800bb3:	83 7d ec 07          	cmpl   $0x7,-0x14(%ebp)
  800bb7:	0f 84 ad 00 00 00    	je     800c6a <atomic_readline+0x100>
					cprintf("read error: %e\n", c);
  800bbd:	83 ec 08             	sub    $0x8,%esp
  800bc0:	ff 75 ec             	pushl  -0x14(%ebp)
  800bc3:	68 0b 24 80 00       	push   $0x80240b
  800bc8:	e8 c5 f7 ff ff       	call   800392 <cprintf>
  800bcd:	83 c4 10             	add    $0x10,%esp
				break;
  800bd0:	e9 95 00 00 00       	jmp    800c6a <atomic_readline+0x100>
			} else if (c >= ' ' && i < BUFLEN-1) {
  800bd5:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%ebp)
  800bd9:	7e 34                	jle    800c0f <atomic_readline+0xa5>
  800bdb:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  800be2:	7f 2b                	jg     800c0f <atomic_readline+0xa5>
				if (echoing)
  800be4:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800be8:	74 0e                	je     800bf8 <atomic_readline+0x8e>
					cputchar(c);
  800bea:	83 ec 0c             	sub    $0xc,%esp
  800bed:	ff 75 ec             	pushl  -0x14(%ebp)
  800bf0:	e8 34 0e 00 00       	call   801a29 <cputchar>
  800bf5:	83 c4 10             	add    $0x10,%esp
				buf[i++] = c;
  800bf8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800bfb:	8d 50 01             	lea    0x1(%eax),%edx
  800bfe:	89 55 f4             	mov    %edx,-0xc(%ebp)
  800c01:	89 c2                	mov    %eax,%edx
  800c03:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c06:	01 d0                	add    %edx,%eax
  800c08:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800c0b:	88 10                	mov    %dl,(%eax)
  800c0d:	eb 56                	jmp    800c65 <atomic_readline+0xfb>
			} else if (c == '\b' && i > 0) {
  800c0f:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  800c13:	75 1f                	jne    800c34 <atomic_readline+0xca>
  800c15:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  800c19:	7e 19                	jle    800c34 <atomic_readline+0xca>
				if (echoing)
  800c1b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800c1f:	74 0e                	je     800c2f <atomic_readline+0xc5>
					cputchar(c);
  800c21:	83 ec 0c             	sub    $0xc,%esp
  800c24:	ff 75 ec             	pushl  -0x14(%ebp)
  800c27:	e8 fd 0d 00 00       	call   801a29 <cputchar>
  800c2c:	83 c4 10             	add    $0x10,%esp
				i--;
  800c2f:	ff 4d f4             	decl   -0xc(%ebp)
  800c32:	eb 31                	jmp    800c65 <atomic_readline+0xfb>
			} else if (c == '\n' || c == '\r') {
  800c34:	83 7d ec 0a          	cmpl   $0xa,-0x14(%ebp)
  800c38:	74 0a                	je     800c44 <atomic_readline+0xda>
  800c3a:	83 7d ec 0d          	cmpl   $0xd,-0x14(%ebp)
  800c3e:	0f 85 61 ff ff ff    	jne    800ba5 <atomic_readline+0x3b>
				if (echoing)
  800c44:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800c48:	74 0e                	je     800c58 <atomic_readline+0xee>
					cputchar(c);
  800c4a:	83 ec 0c             	sub    $0xc,%esp
  800c4d:	ff 75 ec             	pushl  -0x14(%ebp)
  800c50:	e8 d4 0d 00 00       	call   801a29 <cputchar>
  800c55:	83 c4 10             	add    $0x10,%esp
				buf[i] = 0;
  800c58:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800c5b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c5e:	01 d0                	add    %edx,%eax
  800c60:	c6 00 00             	movb   $0x0,(%eax)
				break;
  800c63:	eb 06                	jmp    800c6b <atomic_readline+0x101>
			}
		}
  800c65:	e9 3b ff ff ff       	jmp    800ba5 <atomic_readline+0x3b>
		while (1) {
			c = getchar();
			if (c < 0) {
				if (c != -E_EOF)
					cprintf("read error: %e\n", c);
				break;
  800c6a:	90                   	nop
				buf[i] = 0;
				break;
			}
		}
	}
	sys_unlock_cons();
  800c6b:	e8 98 08 00 00       	call   801508 <sys_unlock_cons>
}
  800c70:	90                   	nop
  800c71:	c9                   	leave  
  800c72:	c3                   	ret    

00800c73 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800c73:	55                   	push   %ebp
  800c74:	89 e5                	mov    %esp,%ebp
  800c76:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800c79:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800c80:	eb 06                	jmp    800c88 <strlen+0x15>
		n++;
  800c82:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800c85:	ff 45 08             	incl   0x8(%ebp)
  800c88:	8b 45 08             	mov    0x8(%ebp),%eax
  800c8b:	8a 00                	mov    (%eax),%al
  800c8d:	84 c0                	test   %al,%al
  800c8f:	75 f1                	jne    800c82 <strlen+0xf>
		n++;
	return n;
  800c91:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800c94:	c9                   	leave  
  800c95:	c3                   	ret    

00800c96 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800c96:	55                   	push   %ebp
  800c97:	89 e5                	mov    %esp,%ebp
  800c99:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800c9c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800ca3:	eb 09                	jmp    800cae <strnlen+0x18>
		n++;
  800ca5:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800ca8:	ff 45 08             	incl   0x8(%ebp)
  800cab:	ff 4d 0c             	decl   0xc(%ebp)
  800cae:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800cb2:	74 09                	je     800cbd <strnlen+0x27>
  800cb4:	8b 45 08             	mov    0x8(%ebp),%eax
  800cb7:	8a 00                	mov    (%eax),%al
  800cb9:	84 c0                	test   %al,%al
  800cbb:	75 e8                	jne    800ca5 <strnlen+0xf>
		n++;
	return n;
  800cbd:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800cc0:	c9                   	leave  
  800cc1:	c3                   	ret    

00800cc2 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800cc2:	55                   	push   %ebp
  800cc3:	89 e5                	mov    %esp,%ebp
  800cc5:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800cc8:	8b 45 08             	mov    0x8(%ebp),%eax
  800ccb:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800cce:	90                   	nop
  800ccf:	8b 45 08             	mov    0x8(%ebp),%eax
  800cd2:	8d 50 01             	lea    0x1(%eax),%edx
  800cd5:	89 55 08             	mov    %edx,0x8(%ebp)
  800cd8:	8b 55 0c             	mov    0xc(%ebp),%edx
  800cdb:	8d 4a 01             	lea    0x1(%edx),%ecx
  800cde:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800ce1:	8a 12                	mov    (%edx),%dl
  800ce3:	88 10                	mov    %dl,(%eax)
  800ce5:	8a 00                	mov    (%eax),%al
  800ce7:	84 c0                	test   %al,%al
  800ce9:	75 e4                	jne    800ccf <strcpy+0xd>
		/* do nothing */;
	return ret;
  800ceb:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800cee:	c9                   	leave  
  800cef:	c3                   	ret    

00800cf0 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800cf0:	55                   	push   %ebp
  800cf1:	89 e5                	mov    %esp,%ebp
  800cf3:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800cf6:	8b 45 08             	mov    0x8(%ebp),%eax
  800cf9:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800cfc:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800d03:	eb 1f                	jmp    800d24 <strncpy+0x34>
		*dst++ = *src;
  800d05:	8b 45 08             	mov    0x8(%ebp),%eax
  800d08:	8d 50 01             	lea    0x1(%eax),%edx
  800d0b:	89 55 08             	mov    %edx,0x8(%ebp)
  800d0e:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d11:	8a 12                	mov    (%edx),%dl
  800d13:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800d15:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d18:	8a 00                	mov    (%eax),%al
  800d1a:	84 c0                	test   %al,%al
  800d1c:	74 03                	je     800d21 <strncpy+0x31>
			src++;
  800d1e:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800d21:	ff 45 fc             	incl   -0x4(%ebp)
  800d24:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d27:	3b 45 10             	cmp    0x10(%ebp),%eax
  800d2a:	72 d9                	jb     800d05 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800d2c:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800d2f:	c9                   	leave  
  800d30:	c3                   	ret    

00800d31 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800d31:	55                   	push   %ebp
  800d32:	89 e5                	mov    %esp,%ebp
  800d34:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800d37:	8b 45 08             	mov    0x8(%ebp),%eax
  800d3a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800d3d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d41:	74 30                	je     800d73 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800d43:	eb 16                	jmp    800d5b <strlcpy+0x2a>
			*dst++ = *src++;
  800d45:	8b 45 08             	mov    0x8(%ebp),%eax
  800d48:	8d 50 01             	lea    0x1(%eax),%edx
  800d4b:	89 55 08             	mov    %edx,0x8(%ebp)
  800d4e:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d51:	8d 4a 01             	lea    0x1(%edx),%ecx
  800d54:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800d57:	8a 12                	mov    (%edx),%dl
  800d59:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800d5b:	ff 4d 10             	decl   0x10(%ebp)
  800d5e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d62:	74 09                	je     800d6d <strlcpy+0x3c>
  800d64:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d67:	8a 00                	mov    (%eax),%al
  800d69:	84 c0                	test   %al,%al
  800d6b:	75 d8                	jne    800d45 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800d6d:	8b 45 08             	mov    0x8(%ebp),%eax
  800d70:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800d73:	8b 55 08             	mov    0x8(%ebp),%edx
  800d76:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d79:	29 c2                	sub    %eax,%edx
  800d7b:	89 d0                	mov    %edx,%eax
}
  800d7d:	c9                   	leave  
  800d7e:	c3                   	ret    

00800d7f <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800d7f:	55                   	push   %ebp
  800d80:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800d82:	eb 06                	jmp    800d8a <strcmp+0xb>
		p++, q++;
  800d84:	ff 45 08             	incl   0x8(%ebp)
  800d87:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800d8a:	8b 45 08             	mov    0x8(%ebp),%eax
  800d8d:	8a 00                	mov    (%eax),%al
  800d8f:	84 c0                	test   %al,%al
  800d91:	74 0e                	je     800da1 <strcmp+0x22>
  800d93:	8b 45 08             	mov    0x8(%ebp),%eax
  800d96:	8a 10                	mov    (%eax),%dl
  800d98:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d9b:	8a 00                	mov    (%eax),%al
  800d9d:	38 c2                	cmp    %al,%dl
  800d9f:	74 e3                	je     800d84 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800da1:	8b 45 08             	mov    0x8(%ebp),%eax
  800da4:	8a 00                	mov    (%eax),%al
  800da6:	0f b6 d0             	movzbl %al,%edx
  800da9:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dac:	8a 00                	mov    (%eax),%al
  800dae:	0f b6 c0             	movzbl %al,%eax
  800db1:	29 c2                	sub    %eax,%edx
  800db3:	89 d0                	mov    %edx,%eax
}
  800db5:	5d                   	pop    %ebp
  800db6:	c3                   	ret    

00800db7 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800db7:	55                   	push   %ebp
  800db8:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800dba:	eb 09                	jmp    800dc5 <strncmp+0xe>
		n--, p++, q++;
  800dbc:	ff 4d 10             	decl   0x10(%ebp)
  800dbf:	ff 45 08             	incl   0x8(%ebp)
  800dc2:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800dc5:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800dc9:	74 17                	je     800de2 <strncmp+0x2b>
  800dcb:	8b 45 08             	mov    0x8(%ebp),%eax
  800dce:	8a 00                	mov    (%eax),%al
  800dd0:	84 c0                	test   %al,%al
  800dd2:	74 0e                	je     800de2 <strncmp+0x2b>
  800dd4:	8b 45 08             	mov    0x8(%ebp),%eax
  800dd7:	8a 10                	mov    (%eax),%dl
  800dd9:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ddc:	8a 00                	mov    (%eax),%al
  800dde:	38 c2                	cmp    %al,%dl
  800de0:	74 da                	je     800dbc <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800de2:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800de6:	75 07                	jne    800def <strncmp+0x38>
		return 0;
  800de8:	b8 00 00 00 00       	mov    $0x0,%eax
  800ded:	eb 14                	jmp    800e03 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800def:	8b 45 08             	mov    0x8(%ebp),%eax
  800df2:	8a 00                	mov    (%eax),%al
  800df4:	0f b6 d0             	movzbl %al,%edx
  800df7:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dfa:	8a 00                	mov    (%eax),%al
  800dfc:	0f b6 c0             	movzbl %al,%eax
  800dff:	29 c2                	sub    %eax,%edx
  800e01:	89 d0                	mov    %edx,%eax
}
  800e03:	5d                   	pop    %ebp
  800e04:	c3                   	ret    

00800e05 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800e05:	55                   	push   %ebp
  800e06:	89 e5                	mov    %esp,%ebp
  800e08:	83 ec 04             	sub    $0x4,%esp
  800e0b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e0e:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800e11:	eb 12                	jmp    800e25 <strchr+0x20>
		if (*s == c)
  800e13:	8b 45 08             	mov    0x8(%ebp),%eax
  800e16:	8a 00                	mov    (%eax),%al
  800e18:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800e1b:	75 05                	jne    800e22 <strchr+0x1d>
			return (char *) s;
  800e1d:	8b 45 08             	mov    0x8(%ebp),%eax
  800e20:	eb 11                	jmp    800e33 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800e22:	ff 45 08             	incl   0x8(%ebp)
  800e25:	8b 45 08             	mov    0x8(%ebp),%eax
  800e28:	8a 00                	mov    (%eax),%al
  800e2a:	84 c0                	test   %al,%al
  800e2c:	75 e5                	jne    800e13 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800e2e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800e33:	c9                   	leave  
  800e34:	c3                   	ret    

00800e35 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800e35:	55                   	push   %ebp
  800e36:	89 e5                	mov    %esp,%ebp
  800e38:	83 ec 04             	sub    $0x4,%esp
  800e3b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e3e:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800e41:	eb 0d                	jmp    800e50 <strfind+0x1b>
		if (*s == c)
  800e43:	8b 45 08             	mov    0x8(%ebp),%eax
  800e46:	8a 00                	mov    (%eax),%al
  800e48:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800e4b:	74 0e                	je     800e5b <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800e4d:	ff 45 08             	incl   0x8(%ebp)
  800e50:	8b 45 08             	mov    0x8(%ebp),%eax
  800e53:	8a 00                	mov    (%eax),%al
  800e55:	84 c0                	test   %al,%al
  800e57:	75 ea                	jne    800e43 <strfind+0xe>
  800e59:	eb 01                	jmp    800e5c <strfind+0x27>
		if (*s == c)
			break;
  800e5b:	90                   	nop
	return (char *) s;
  800e5c:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e5f:	c9                   	leave  
  800e60:	c3                   	ret    

00800e61 <memset>:

// *************** The faster implementation of memset & memcpy is implemented by *************
// ****************** Team80 (Yahia Khaled, Malek Ahmed et al) - FCIS'24-25 *******************
void *
memset(void *v, int c, uint32 n)
{
  800e61:	55                   	push   %ebp
  800e62:	89 e5                	mov    %esp,%ebp
  800e64:	83 ec 10             	sub    $0x10,%esp
//	m = n;
//	while (--m >= 0)
//		*p++ = c;

	/*Faster Implementation*/
	uint64* p64 = (uint64*)v;
  800e67:	8b 45 08             	mov    0x8(%ebp),%eax
  800e6a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if(n >= 8){
  800e6d:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800e71:	76 63                	jbe    800ed6 <memset+0x75>
		uint64 data_block = c;
  800e73:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e76:	99                   	cltd   
  800e77:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800e7a:	89 55 f4             	mov    %edx,-0xc(%ebp)
		data_block |= data_block << 8;
  800e7d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800e80:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800e83:	0f a4 c2 08          	shld   $0x8,%eax,%edx
  800e87:	c1 e0 08             	shl    $0x8,%eax
  800e8a:	09 45 f0             	or     %eax,-0x10(%ebp)
  800e8d:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 16;
  800e90:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800e93:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800e96:	0f a4 c2 10          	shld   $0x10,%eax,%edx
  800e9a:	c1 e0 10             	shl    $0x10,%eax
  800e9d:	09 45 f0             	or     %eax,-0x10(%ebp)
  800ea0:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 32;
  800ea3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800ea6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800ea9:	89 c2                	mov    %eax,%edx
  800eab:	b8 00 00 00 00       	mov    $0x0,%eax
  800eb0:	09 45 f0             	or     %eax,-0x10(%ebp)
  800eb3:	09 55 f4             	or     %edx,-0xc(%ebp)

		while(n >= 8)
  800eb6:	eb 18                	jmp    800ed0 <memset+0x6f>
			*p64++ = data_block, n -= 8;
  800eb8:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  800ebb:	8d 41 08             	lea    0x8(%ecx),%eax
  800ebe:	89 45 fc             	mov    %eax,-0x4(%ebp)
  800ec1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800ec4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800ec7:	89 01                	mov    %eax,(%ecx)
  800ec9:	89 51 04             	mov    %edx,0x4(%ecx)
  800ecc:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
		uint64 data_block = c;
		data_block |= data_block << 8;
		data_block |= data_block << 16;
		data_block |= data_block << 32;

		while(n >= 8)
  800ed0:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800ed4:	77 e2                	ja     800eb8 <memset+0x57>
			*p64++ = data_block, n -= 8;
	}

	if(n){
  800ed6:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800eda:	74 23                	je     800eff <memset+0x9e>
		uint8* p8 = (uint8*)p64;
  800edc:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800edf:	89 45 f8             	mov    %eax,-0x8(%ebp)
		while (n-- > 0)
  800ee2:	eb 0e                	jmp    800ef2 <memset+0x91>
			*p8++ = (uint8)c;
  800ee4:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800ee7:	8d 50 01             	lea    0x1(%eax),%edx
  800eea:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800eed:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ef0:	88 10                	mov    %dl,(%eax)
			*p64++ = data_block, n -= 8;
	}

	if(n){
		uint8* p8 = (uint8*)p64;
		while (n-- > 0)
  800ef2:	8b 45 10             	mov    0x10(%ebp),%eax
  800ef5:	8d 50 ff             	lea    -0x1(%eax),%edx
  800ef8:	89 55 10             	mov    %edx,0x10(%ebp)
  800efb:	85 c0                	test   %eax,%eax
  800efd:	75 e5                	jne    800ee4 <memset+0x83>
			*p8++ = (uint8)c;
	}

	return v;
  800eff:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f02:	c9                   	leave  
  800f03:	c3                   	ret    

00800f04 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800f04:	55                   	push   %ebp
  800f05:	89 e5                	mov    %esp,%ebp
  800f07:	83 ec 10             	sub    $0x10,%esp
	//	s = src;
	//	d = dst;
	//	while (n-- > 0)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
  800f0a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f0d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	uint64* d64 = (uint64*)dst;
  800f10:	8b 45 08             	mov    0x8(%ebp),%eax
  800f13:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if(n >= 8){
  800f16:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800f1a:	76 24                	jbe    800f40 <memcpy+0x3c>
		while(n >= 8){
  800f1c:	eb 1c                	jmp    800f3a <memcpy+0x36>
			*d64 = *s64;
  800f1e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f21:	8b 50 04             	mov    0x4(%eax),%edx
  800f24:	8b 00                	mov    (%eax),%eax
  800f26:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  800f29:	89 01                	mov    %eax,(%ecx)
  800f2b:	89 51 04             	mov    %edx,0x4(%ecx)
			n -= 8;
  800f2e:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
			++s64;
  800f32:	83 45 fc 08          	addl   $0x8,-0x4(%ebp)
			++d64;
  800f36:	83 45 f8 08          	addl   $0x8,-0x8(%ebp)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
	uint64* d64 = (uint64*)dst;
	if(n >= 8){
		while(n >= 8){
  800f3a:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800f3e:	77 de                	ja     800f1e <memcpy+0x1a>
			++s64;
			++d64;
		}
	}

	if(n){
  800f40:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f44:	74 31                	je     800f77 <memcpy+0x73>
		uint8* s8 = (uint8*)s64;
  800f46:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f49:	89 45 f4             	mov    %eax,-0xc(%ebp)
		uint8* d8 = (uint8*)d64;
  800f4c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f4f:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (n-- > 0)
  800f52:	eb 16                	jmp    800f6a <memcpy+0x66>
			*d8++ = *s8++;
  800f54:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800f57:	8d 50 01             	lea    0x1(%eax),%edx
  800f5a:	89 55 f0             	mov    %edx,-0x10(%ebp)
  800f5d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800f60:	8d 4a 01             	lea    0x1(%edx),%ecx
  800f63:	89 4d f4             	mov    %ecx,-0xc(%ebp)
  800f66:	8a 12                	mov    (%edx),%dl
  800f68:	88 10                	mov    %dl,(%eax)
	}

	if(n){
		uint8* s8 = (uint8*)s64;
		uint8* d8 = (uint8*)d64;
		while (n-- > 0)
  800f6a:	8b 45 10             	mov    0x10(%ebp),%eax
  800f6d:	8d 50 ff             	lea    -0x1(%eax),%edx
  800f70:	89 55 10             	mov    %edx,0x10(%ebp)
  800f73:	85 c0                	test   %eax,%eax
  800f75:	75 dd                	jne    800f54 <memcpy+0x50>
			*d8++ = *s8++;
	}
	return dst;
  800f77:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f7a:	c9                   	leave  
  800f7b:	c3                   	ret    

00800f7c <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800f7c:	55                   	push   %ebp
  800f7d:	89 e5                	mov    %esp,%ebp
  800f7f:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800f82:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f85:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800f88:	8b 45 08             	mov    0x8(%ebp),%eax
  800f8b:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800f8e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f91:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800f94:	73 50                	jae    800fe6 <memmove+0x6a>
  800f96:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800f99:	8b 45 10             	mov    0x10(%ebp),%eax
  800f9c:	01 d0                	add    %edx,%eax
  800f9e:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800fa1:	76 43                	jbe    800fe6 <memmove+0x6a>
		s += n;
  800fa3:	8b 45 10             	mov    0x10(%ebp),%eax
  800fa6:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800fa9:	8b 45 10             	mov    0x10(%ebp),%eax
  800fac:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800faf:	eb 10                	jmp    800fc1 <memmove+0x45>
			*--d = *--s;
  800fb1:	ff 4d f8             	decl   -0x8(%ebp)
  800fb4:	ff 4d fc             	decl   -0x4(%ebp)
  800fb7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800fba:	8a 10                	mov    (%eax),%dl
  800fbc:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800fbf:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800fc1:	8b 45 10             	mov    0x10(%ebp),%eax
  800fc4:	8d 50 ff             	lea    -0x1(%eax),%edx
  800fc7:	89 55 10             	mov    %edx,0x10(%ebp)
  800fca:	85 c0                	test   %eax,%eax
  800fcc:	75 e3                	jne    800fb1 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800fce:	eb 23                	jmp    800ff3 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800fd0:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800fd3:	8d 50 01             	lea    0x1(%eax),%edx
  800fd6:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800fd9:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800fdc:	8d 4a 01             	lea    0x1(%edx),%ecx
  800fdf:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800fe2:	8a 12                	mov    (%edx),%dl
  800fe4:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800fe6:	8b 45 10             	mov    0x10(%ebp),%eax
  800fe9:	8d 50 ff             	lea    -0x1(%eax),%edx
  800fec:	89 55 10             	mov    %edx,0x10(%ebp)
  800fef:	85 c0                	test   %eax,%eax
  800ff1:	75 dd                	jne    800fd0 <memmove+0x54>
			*d++ = *s++;

	return dst;
  800ff3:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800ff6:	c9                   	leave  
  800ff7:	c3                   	ret    

00800ff8 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  800ff8:	55                   	push   %ebp
  800ff9:	89 e5                	mov    %esp,%ebp
  800ffb:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  800ffe:	8b 45 08             	mov    0x8(%ebp),%eax
  801001:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  801004:	8b 45 0c             	mov    0xc(%ebp),%eax
  801007:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  80100a:	eb 2a                	jmp    801036 <memcmp+0x3e>
		if (*s1 != *s2)
  80100c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80100f:	8a 10                	mov    (%eax),%dl
  801011:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801014:	8a 00                	mov    (%eax),%al
  801016:	38 c2                	cmp    %al,%dl
  801018:	74 16                	je     801030 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  80101a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80101d:	8a 00                	mov    (%eax),%al
  80101f:	0f b6 d0             	movzbl %al,%edx
  801022:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801025:	8a 00                	mov    (%eax),%al
  801027:	0f b6 c0             	movzbl %al,%eax
  80102a:	29 c2                	sub    %eax,%edx
  80102c:	89 d0                	mov    %edx,%eax
  80102e:	eb 18                	jmp    801048 <memcmp+0x50>
		s1++, s2++;
  801030:	ff 45 fc             	incl   -0x4(%ebp)
  801033:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  801036:	8b 45 10             	mov    0x10(%ebp),%eax
  801039:	8d 50 ff             	lea    -0x1(%eax),%edx
  80103c:	89 55 10             	mov    %edx,0x10(%ebp)
  80103f:	85 c0                	test   %eax,%eax
  801041:	75 c9                	jne    80100c <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801043:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801048:	c9                   	leave  
  801049:	c3                   	ret    

0080104a <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  80104a:	55                   	push   %ebp
  80104b:	89 e5                	mov    %esp,%ebp
  80104d:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  801050:	8b 55 08             	mov    0x8(%ebp),%edx
  801053:	8b 45 10             	mov    0x10(%ebp),%eax
  801056:	01 d0                	add    %edx,%eax
  801058:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  80105b:	eb 15                	jmp    801072 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  80105d:	8b 45 08             	mov    0x8(%ebp),%eax
  801060:	8a 00                	mov    (%eax),%al
  801062:	0f b6 d0             	movzbl %al,%edx
  801065:	8b 45 0c             	mov    0xc(%ebp),%eax
  801068:	0f b6 c0             	movzbl %al,%eax
  80106b:	39 c2                	cmp    %eax,%edx
  80106d:	74 0d                	je     80107c <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  80106f:	ff 45 08             	incl   0x8(%ebp)
  801072:	8b 45 08             	mov    0x8(%ebp),%eax
  801075:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801078:	72 e3                	jb     80105d <memfind+0x13>
  80107a:	eb 01                	jmp    80107d <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  80107c:	90                   	nop
	return (void *) s;
  80107d:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801080:	c9                   	leave  
  801081:	c3                   	ret    

00801082 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801082:	55                   	push   %ebp
  801083:	89 e5                	mov    %esp,%ebp
  801085:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  801088:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  80108f:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801096:	eb 03                	jmp    80109b <strtol+0x19>
		s++;
  801098:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80109b:	8b 45 08             	mov    0x8(%ebp),%eax
  80109e:	8a 00                	mov    (%eax),%al
  8010a0:	3c 20                	cmp    $0x20,%al
  8010a2:	74 f4                	je     801098 <strtol+0x16>
  8010a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8010a7:	8a 00                	mov    (%eax),%al
  8010a9:	3c 09                	cmp    $0x9,%al
  8010ab:	74 eb                	je     801098 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  8010ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8010b0:	8a 00                	mov    (%eax),%al
  8010b2:	3c 2b                	cmp    $0x2b,%al
  8010b4:	75 05                	jne    8010bb <strtol+0x39>
		s++;
  8010b6:	ff 45 08             	incl   0x8(%ebp)
  8010b9:	eb 13                	jmp    8010ce <strtol+0x4c>
	else if (*s == '-')
  8010bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8010be:	8a 00                	mov    (%eax),%al
  8010c0:	3c 2d                	cmp    $0x2d,%al
  8010c2:	75 0a                	jne    8010ce <strtol+0x4c>
		s++, neg = 1;
  8010c4:	ff 45 08             	incl   0x8(%ebp)
  8010c7:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8010ce:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8010d2:	74 06                	je     8010da <strtol+0x58>
  8010d4:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  8010d8:	75 20                	jne    8010fa <strtol+0x78>
  8010da:	8b 45 08             	mov    0x8(%ebp),%eax
  8010dd:	8a 00                	mov    (%eax),%al
  8010df:	3c 30                	cmp    $0x30,%al
  8010e1:	75 17                	jne    8010fa <strtol+0x78>
  8010e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8010e6:	40                   	inc    %eax
  8010e7:	8a 00                	mov    (%eax),%al
  8010e9:	3c 78                	cmp    $0x78,%al
  8010eb:	75 0d                	jne    8010fa <strtol+0x78>
		s += 2, base = 16;
  8010ed:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  8010f1:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  8010f8:	eb 28                	jmp    801122 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  8010fa:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8010fe:	75 15                	jne    801115 <strtol+0x93>
  801100:	8b 45 08             	mov    0x8(%ebp),%eax
  801103:	8a 00                	mov    (%eax),%al
  801105:	3c 30                	cmp    $0x30,%al
  801107:	75 0c                	jne    801115 <strtol+0x93>
		s++, base = 8;
  801109:	ff 45 08             	incl   0x8(%ebp)
  80110c:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  801113:	eb 0d                	jmp    801122 <strtol+0xa0>
	else if (base == 0)
  801115:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801119:	75 07                	jne    801122 <strtol+0xa0>
		base = 10;
  80111b:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801122:	8b 45 08             	mov    0x8(%ebp),%eax
  801125:	8a 00                	mov    (%eax),%al
  801127:	3c 2f                	cmp    $0x2f,%al
  801129:	7e 19                	jle    801144 <strtol+0xc2>
  80112b:	8b 45 08             	mov    0x8(%ebp),%eax
  80112e:	8a 00                	mov    (%eax),%al
  801130:	3c 39                	cmp    $0x39,%al
  801132:	7f 10                	jg     801144 <strtol+0xc2>
			dig = *s - '0';
  801134:	8b 45 08             	mov    0x8(%ebp),%eax
  801137:	8a 00                	mov    (%eax),%al
  801139:	0f be c0             	movsbl %al,%eax
  80113c:	83 e8 30             	sub    $0x30,%eax
  80113f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801142:	eb 42                	jmp    801186 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  801144:	8b 45 08             	mov    0x8(%ebp),%eax
  801147:	8a 00                	mov    (%eax),%al
  801149:	3c 60                	cmp    $0x60,%al
  80114b:	7e 19                	jle    801166 <strtol+0xe4>
  80114d:	8b 45 08             	mov    0x8(%ebp),%eax
  801150:	8a 00                	mov    (%eax),%al
  801152:	3c 7a                	cmp    $0x7a,%al
  801154:	7f 10                	jg     801166 <strtol+0xe4>
			dig = *s - 'a' + 10;
  801156:	8b 45 08             	mov    0x8(%ebp),%eax
  801159:	8a 00                	mov    (%eax),%al
  80115b:	0f be c0             	movsbl %al,%eax
  80115e:	83 e8 57             	sub    $0x57,%eax
  801161:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801164:	eb 20                	jmp    801186 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  801166:	8b 45 08             	mov    0x8(%ebp),%eax
  801169:	8a 00                	mov    (%eax),%al
  80116b:	3c 40                	cmp    $0x40,%al
  80116d:	7e 39                	jle    8011a8 <strtol+0x126>
  80116f:	8b 45 08             	mov    0x8(%ebp),%eax
  801172:	8a 00                	mov    (%eax),%al
  801174:	3c 5a                	cmp    $0x5a,%al
  801176:	7f 30                	jg     8011a8 <strtol+0x126>
			dig = *s - 'A' + 10;
  801178:	8b 45 08             	mov    0x8(%ebp),%eax
  80117b:	8a 00                	mov    (%eax),%al
  80117d:	0f be c0             	movsbl %al,%eax
  801180:	83 e8 37             	sub    $0x37,%eax
  801183:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  801186:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801189:	3b 45 10             	cmp    0x10(%ebp),%eax
  80118c:	7d 19                	jge    8011a7 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  80118e:	ff 45 08             	incl   0x8(%ebp)
  801191:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801194:	0f af 45 10          	imul   0x10(%ebp),%eax
  801198:	89 c2                	mov    %eax,%edx
  80119a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80119d:	01 d0                	add    %edx,%eax
  80119f:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  8011a2:	e9 7b ff ff ff       	jmp    801122 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  8011a7:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  8011a8:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8011ac:	74 08                	je     8011b6 <strtol+0x134>
		*endptr = (char *) s;
  8011ae:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011b1:	8b 55 08             	mov    0x8(%ebp),%edx
  8011b4:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  8011b6:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8011ba:	74 07                	je     8011c3 <strtol+0x141>
  8011bc:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011bf:	f7 d8                	neg    %eax
  8011c1:	eb 03                	jmp    8011c6 <strtol+0x144>
  8011c3:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8011c6:	c9                   	leave  
  8011c7:	c3                   	ret    

008011c8 <ltostr>:

void
ltostr(long value, char *str)
{
  8011c8:	55                   	push   %ebp
  8011c9:	89 e5                	mov    %esp,%ebp
  8011cb:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  8011ce:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  8011d5:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  8011dc:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8011e0:	79 13                	jns    8011f5 <ltostr+0x2d>
	{
		neg = 1;
  8011e2:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  8011e9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011ec:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  8011ef:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  8011f2:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  8011f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8011f8:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8011fd:	99                   	cltd   
  8011fe:	f7 f9                	idiv   %ecx
  801200:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  801203:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801206:	8d 50 01             	lea    0x1(%eax),%edx
  801209:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80120c:	89 c2                	mov    %eax,%edx
  80120e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801211:	01 d0                	add    %edx,%eax
  801213:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801216:	83 c2 30             	add    $0x30,%edx
  801219:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  80121b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80121e:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801223:	f7 e9                	imul   %ecx
  801225:	c1 fa 02             	sar    $0x2,%edx
  801228:	89 c8                	mov    %ecx,%eax
  80122a:	c1 f8 1f             	sar    $0x1f,%eax
  80122d:	29 c2                	sub    %eax,%edx
  80122f:	89 d0                	mov    %edx,%eax
  801231:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  801234:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801238:	75 bb                	jne    8011f5 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  80123a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801241:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801244:	48                   	dec    %eax
  801245:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801248:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80124c:	74 3d                	je     80128b <ltostr+0xc3>
		start = 1 ;
  80124e:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  801255:	eb 34                	jmp    80128b <ltostr+0xc3>
	{
		char tmp = str[start] ;
  801257:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80125a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80125d:	01 d0                	add    %edx,%eax
  80125f:	8a 00                	mov    (%eax),%al
  801261:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801264:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801267:	8b 45 0c             	mov    0xc(%ebp),%eax
  80126a:	01 c2                	add    %eax,%edx
  80126c:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  80126f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801272:	01 c8                	add    %ecx,%eax
  801274:	8a 00                	mov    (%eax),%al
  801276:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801278:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80127b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80127e:	01 c2                	add    %eax,%edx
  801280:	8a 45 eb             	mov    -0x15(%ebp),%al
  801283:	88 02                	mov    %al,(%edx)
		start++ ;
  801285:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801288:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  80128b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80128e:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801291:	7c c4                	jl     801257 <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801293:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801296:	8b 45 0c             	mov    0xc(%ebp),%eax
  801299:	01 d0                	add    %edx,%eax
  80129b:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  80129e:	90                   	nop
  80129f:	c9                   	leave  
  8012a0:	c3                   	ret    

008012a1 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  8012a1:	55                   	push   %ebp
  8012a2:	89 e5                	mov    %esp,%ebp
  8012a4:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  8012a7:	ff 75 08             	pushl  0x8(%ebp)
  8012aa:	e8 c4 f9 ff ff       	call   800c73 <strlen>
  8012af:	83 c4 04             	add    $0x4,%esp
  8012b2:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  8012b5:	ff 75 0c             	pushl  0xc(%ebp)
  8012b8:	e8 b6 f9 ff ff       	call   800c73 <strlen>
  8012bd:	83 c4 04             	add    $0x4,%esp
  8012c0:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  8012c3:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  8012ca:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8012d1:	eb 17                	jmp    8012ea <strcconcat+0x49>
		final[s] = str1[s] ;
  8012d3:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8012d6:	8b 45 10             	mov    0x10(%ebp),%eax
  8012d9:	01 c2                	add    %eax,%edx
  8012db:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8012de:	8b 45 08             	mov    0x8(%ebp),%eax
  8012e1:	01 c8                	add    %ecx,%eax
  8012e3:	8a 00                	mov    (%eax),%al
  8012e5:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  8012e7:	ff 45 fc             	incl   -0x4(%ebp)
  8012ea:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8012ed:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8012f0:	7c e1                	jl     8012d3 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  8012f2:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  8012f9:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  801300:	eb 1f                	jmp    801321 <strcconcat+0x80>
		final[s++] = str2[i] ;
  801302:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801305:	8d 50 01             	lea    0x1(%eax),%edx
  801308:	89 55 fc             	mov    %edx,-0x4(%ebp)
  80130b:	89 c2                	mov    %eax,%edx
  80130d:	8b 45 10             	mov    0x10(%ebp),%eax
  801310:	01 c2                	add    %eax,%edx
  801312:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801315:	8b 45 0c             	mov    0xc(%ebp),%eax
  801318:	01 c8                	add    %ecx,%eax
  80131a:	8a 00                	mov    (%eax),%al
  80131c:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  80131e:	ff 45 f8             	incl   -0x8(%ebp)
  801321:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801324:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801327:	7c d9                	jl     801302 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801329:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80132c:	8b 45 10             	mov    0x10(%ebp),%eax
  80132f:	01 d0                	add    %edx,%eax
  801331:	c6 00 00             	movb   $0x0,(%eax)
}
  801334:	90                   	nop
  801335:	c9                   	leave  
  801336:	c3                   	ret    

00801337 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801337:	55                   	push   %ebp
  801338:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  80133a:	8b 45 14             	mov    0x14(%ebp),%eax
  80133d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801343:	8b 45 14             	mov    0x14(%ebp),%eax
  801346:	8b 00                	mov    (%eax),%eax
  801348:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80134f:	8b 45 10             	mov    0x10(%ebp),%eax
  801352:	01 d0                	add    %edx,%eax
  801354:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80135a:	eb 0c                	jmp    801368 <strsplit+0x31>
			*string++ = 0;
  80135c:	8b 45 08             	mov    0x8(%ebp),%eax
  80135f:	8d 50 01             	lea    0x1(%eax),%edx
  801362:	89 55 08             	mov    %edx,0x8(%ebp)
  801365:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801368:	8b 45 08             	mov    0x8(%ebp),%eax
  80136b:	8a 00                	mov    (%eax),%al
  80136d:	84 c0                	test   %al,%al
  80136f:	74 18                	je     801389 <strsplit+0x52>
  801371:	8b 45 08             	mov    0x8(%ebp),%eax
  801374:	8a 00                	mov    (%eax),%al
  801376:	0f be c0             	movsbl %al,%eax
  801379:	50                   	push   %eax
  80137a:	ff 75 0c             	pushl  0xc(%ebp)
  80137d:	e8 83 fa ff ff       	call   800e05 <strchr>
  801382:	83 c4 08             	add    $0x8,%esp
  801385:	85 c0                	test   %eax,%eax
  801387:	75 d3                	jne    80135c <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801389:	8b 45 08             	mov    0x8(%ebp),%eax
  80138c:	8a 00                	mov    (%eax),%al
  80138e:	84 c0                	test   %al,%al
  801390:	74 5a                	je     8013ec <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801392:	8b 45 14             	mov    0x14(%ebp),%eax
  801395:	8b 00                	mov    (%eax),%eax
  801397:	83 f8 0f             	cmp    $0xf,%eax
  80139a:	75 07                	jne    8013a3 <strsplit+0x6c>
		{
			return 0;
  80139c:	b8 00 00 00 00       	mov    $0x0,%eax
  8013a1:	eb 66                	jmp    801409 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  8013a3:	8b 45 14             	mov    0x14(%ebp),%eax
  8013a6:	8b 00                	mov    (%eax),%eax
  8013a8:	8d 48 01             	lea    0x1(%eax),%ecx
  8013ab:	8b 55 14             	mov    0x14(%ebp),%edx
  8013ae:	89 0a                	mov    %ecx,(%edx)
  8013b0:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8013b7:	8b 45 10             	mov    0x10(%ebp),%eax
  8013ba:	01 c2                	add    %eax,%edx
  8013bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8013bf:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  8013c1:	eb 03                	jmp    8013c6 <strsplit+0x8f>
			string++;
  8013c3:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  8013c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8013c9:	8a 00                	mov    (%eax),%al
  8013cb:	84 c0                	test   %al,%al
  8013cd:	74 8b                	je     80135a <strsplit+0x23>
  8013cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8013d2:	8a 00                	mov    (%eax),%al
  8013d4:	0f be c0             	movsbl %al,%eax
  8013d7:	50                   	push   %eax
  8013d8:	ff 75 0c             	pushl  0xc(%ebp)
  8013db:	e8 25 fa ff ff       	call   800e05 <strchr>
  8013e0:	83 c4 08             	add    $0x8,%esp
  8013e3:	85 c0                	test   %eax,%eax
  8013e5:	74 dc                	je     8013c3 <strsplit+0x8c>
			string++;
	}
  8013e7:	e9 6e ff ff ff       	jmp    80135a <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  8013ec:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  8013ed:	8b 45 14             	mov    0x14(%ebp),%eax
  8013f0:	8b 00                	mov    (%eax),%eax
  8013f2:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8013f9:	8b 45 10             	mov    0x10(%ebp),%eax
  8013fc:	01 d0                	add    %edx,%eax
  8013fe:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801404:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801409:	c9                   	leave  
  80140a:	c3                   	ret    

0080140b <str2lower>:


char* str2lower(char *dst, const char *src)
{
  80140b:	55                   	push   %ebp
  80140c:	89 e5                	mov    %esp,%ebp
  80140e:	83 ec 10             	sub    $0x10,%esp
	char* ret = dst;
  801411:	8b 45 08             	mov    0x8(%ebp),%eax
  801414:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (int i = 0; i < strlen(src); ++i)
  801417:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80141e:	eb 4a                	jmp    80146a <str2lower+0x5f>
	{
		dst[i] = src[i] ;
  801420:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801423:	8b 45 08             	mov    0x8(%ebp),%eax
  801426:	01 c2                	add    %eax,%edx
  801428:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  80142b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80142e:	01 c8                	add    %ecx,%eax
  801430:	8a 00                	mov    (%eax),%al
  801432:	88 02                	mov    %al,(%edx)
		if (src[i] >= 'A' && src[i] <= 'Z')
  801434:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801437:	8b 45 0c             	mov    0xc(%ebp),%eax
  80143a:	01 d0                	add    %edx,%eax
  80143c:	8a 00                	mov    (%eax),%al
  80143e:	3c 40                	cmp    $0x40,%al
  801440:	7e 25                	jle    801467 <str2lower+0x5c>
  801442:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801445:	8b 45 0c             	mov    0xc(%ebp),%eax
  801448:	01 d0                	add    %edx,%eax
  80144a:	8a 00                	mov    (%eax),%al
  80144c:	3c 5a                	cmp    $0x5a,%al
  80144e:	7f 17                	jg     801467 <str2lower+0x5c>
		{
			dst[i] += 32 ;
  801450:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801453:	8b 45 08             	mov    0x8(%ebp),%eax
  801456:	01 d0                	add    %edx,%eax
  801458:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  80145b:	8b 55 08             	mov    0x8(%ebp),%edx
  80145e:	01 ca                	add    %ecx,%edx
  801460:	8a 12                	mov    (%edx),%dl
  801462:	83 c2 20             	add    $0x20,%edx
  801465:	88 10                	mov    %dl,(%eax)


char* str2lower(char *dst, const char *src)
{
	char* ret = dst;
	for (int i = 0; i < strlen(src); ++i)
  801467:	ff 45 fc             	incl   -0x4(%ebp)
  80146a:	ff 75 0c             	pushl  0xc(%ebp)
  80146d:	e8 01 f8 ff ff       	call   800c73 <strlen>
  801472:	83 c4 04             	add    $0x4,%esp
  801475:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801478:	7f a6                	jg     801420 <str2lower+0x15>
		if (src[i] >= 'A' && src[i] <= 'Z')
		{
			dst[i] += 32 ;
		}
	}
	return ret;
  80147a:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  80147d:	c9                   	leave  
  80147e:	c3                   	ret    

0080147f <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  80147f:	55                   	push   %ebp
  801480:	89 e5                	mov    %esp,%ebp
  801482:	57                   	push   %edi
  801483:	56                   	push   %esi
  801484:	53                   	push   %ebx
  801485:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801488:	8b 45 08             	mov    0x8(%ebp),%eax
  80148b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80148e:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801491:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801494:	8b 7d 18             	mov    0x18(%ebp),%edi
  801497:	8b 75 1c             	mov    0x1c(%ebp),%esi
  80149a:	cd 30                	int    $0x30
  80149c:	89 45 f0             	mov    %eax,-0x10(%ebp)
				"b" (a3),
				"D" (a4),
				"S" (a5)
				: "cc", "memory");

	return ret;
  80149f:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8014a2:	83 c4 10             	add    $0x10,%esp
  8014a5:	5b                   	pop    %ebx
  8014a6:	5e                   	pop    %esi
  8014a7:	5f                   	pop    %edi
  8014a8:	5d                   	pop    %ebp
  8014a9:	c3                   	ret    

008014aa <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName, int color)
{
  8014aa:	55                   	push   %ebp
  8014ab:	89 e5                	mov    %esp,%ebp
  8014ad:	83 ec 04             	sub    $0x4,%esp
  8014b0:	8b 45 10             	mov    0x10(%ebp),%eax
  8014b3:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, color, 0);
  8014b6:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8014b9:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8014bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8014c0:	6a 00                	push   $0x0
  8014c2:	51                   	push   %ecx
  8014c3:	52                   	push   %edx
  8014c4:	ff 75 0c             	pushl  0xc(%ebp)
  8014c7:	50                   	push   %eax
  8014c8:	6a 00                	push   $0x0
  8014ca:	e8 b0 ff ff ff       	call   80147f <syscall>
  8014cf:	83 c4 18             	add    $0x18,%esp
}
  8014d2:	90                   	nop
  8014d3:	c9                   	leave  
  8014d4:	c3                   	ret    

008014d5 <sys_cgetc>:

int
sys_cgetc(void)
{
  8014d5:	55                   	push   %ebp
  8014d6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  8014d8:	6a 00                	push   $0x0
  8014da:	6a 00                	push   $0x0
  8014dc:	6a 00                	push   $0x0
  8014de:	6a 00                	push   $0x0
  8014e0:	6a 00                	push   $0x0
  8014e2:	6a 02                	push   $0x2
  8014e4:	e8 96 ff ff ff       	call   80147f <syscall>
  8014e9:	83 c4 18             	add    $0x18,%esp
}
  8014ec:	c9                   	leave  
  8014ed:	c3                   	ret    

008014ee <sys_lock_cons>:

void sys_lock_cons(void)
{
  8014ee:	55                   	push   %ebp
  8014ef:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  8014f1:	6a 00                	push   $0x0
  8014f3:	6a 00                	push   $0x0
  8014f5:	6a 00                	push   $0x0
  8014f7:	6a 00                	push   $0x0
  8014f9:	6a 00                	push   $0x0
  8014fb:	6a 03                	push   $0x3
  8014fd:	e8 7d ff ff ff       	call   80147f <syscall>
  801502:	83 c4 18             	add    $0x18,%esp
}
  801505:	90                   	nop
  801506:	c9                   	leave  
  801507:	c3                   	ret    

00801508 <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  801508:	55                   	push   %ebp
  801509:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  80150b:	6a 00                	push   $0x0
  80150d:	6a 00                	push   $0x0
  80150f:	6a 00                	push   $0x0
  801511:	6a 00                	push   $0x0
  801513:	6a 00                	push   $0x0
  801515:	6a 04                	push   $0x4
  801517:	e8 63 ff ff ff       	call   80147f <syscall>
  80151c:	83 c4 18             	add    $0x18,%esp
}
  80151f:	90                   	nop
  801520:	c9                   	leave  
  801521:	c3                   	ret    

00801522 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801522:	55                   	push   %ebp
  801523:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801525:	8b 55 0c             	mov    0xc(%ebp),%edx
  801528:	8b 45 08             	mov    0x8(%ebp),%eax
  80152b:	6a 00                	push   $0x0
  80152d:	6a 00                	push   $0x0
  80152f:	6a 00                	push   $0x0
  801531:	52                   	push   %edx
  801532:	50                   	push   %eax
  801533:	6a 08                	push   $0x8
  801535:	e8 45 ff ff ff       	call   80147f <syscall>
  80153a:	83 c4 18             	add    $0x18,%esp
}
  80153d:	c9                   	leave  
  80153e:	c3                   	ret    

0080153f <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  80153f:	55                   	push   %ebp
  801540:	89 e5                	mov    %esp,%ebp
  801542:	56                   	push   %esi
  801543:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801544:	8b 75 18             	mov    0x18(%ebp),%esi
  801547:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80154a:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80154d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801550:	8b 45 08             	mov    0x8(%ebp),%eax
  801553:	56                   	push   %esi
  801554:	53                   	push   %ebx
  801555:	51                   	push   %ecx
  801556:	52                   	push   %edx
  801557:	50                   	push   %eax
  801558:	6a 09                	push   $0x9
  80155a:	e8 20 ff ff ff       	call   80147f <syscall>
  80155f:	83 c4 18             	add    $0x18,%esp
}
  801562:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801565:	5b                   	pop    %ebx
  801566:	5e                   	pop    %esi
  801567:	5d                   	pop    %ebp
  801568:	c3                   	ret    

00801569 <__sys_unmap_frame>:

int __sys_unmap_frame(uint32 va)
{
  801569:	55                   	push   %ebp
  80156a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, va, 0, 0, 0, 0);
  80156c:	6a 00                	push   $0x0
  80156e:	6a 00                	push   $0x0
  801570:	6a 00                	push   $0x0
  801572:	6a 00                	push   $0x0
  801574:	ff 75 08             	pushl  0x8(%ebp)
  801577:	6a 0a                	push   $0xa
  801579:	e8 01 ff ff ff       	call   80147f <syscall>
  80157e:	83 c4 18             	add    $0x18,%esp
}
  801581:	c9                   	leave  
  801582:	c3                   	ret    

00801583 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801583:	55                   	push   %ebp
  801584:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801586:	6a 00                	push   $0x0
  801588:	6a 00                	push   $0x0
  80158a:	6a 00                	push   $0x0
  80158c:	ff 75 0c             	pushl  0xc(%ebp)
  80158f:	ff 75 08             	pushl  0x8(%ebp)
  801592:	6a 0b                	push   $0xb
  801594:	e8 e6 fe ff ff       	call   80147f <syscall>
  801599:	83 c4 18             	add    $0x18,%esp
}
  80159c:	c9                   	leave  
  80159d:	c3                   	ret    

0080159e <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  80159e:	55                   	push   %ebp
  80159f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  8015a1:	6a 00                	push   $0x0
  8015a3:	6a 00                	push   $0x0
  8015a5:	6a 00                	push   $0x0
  8015a7:	6a 00                	push   $0x0
  8015a9:	6a 00                	push   $0x0
  8015ab:	6a 0c                	push   $0xc
  8015ad:	e8 cd fe ff ff       	call   80147f <syscall>
  8015b2:	83 c4 18             	add    $0x18,%esp
}
  8015b5:	c9                   	leave  
  8015b6:	c3                   	ret    

008015b7 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  8015b7:	55                   	push   %ebp
  8015b8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  8015ba:	6a 00                	push   $0x0
  8015bc:	6a 00                	push   $0x0
  8015be:	6a 00                	push   $0x0
  8015c0:	6a 00                	push   $0x0
  8015c2:	6a 00                	push   $0x0
  8015c4:	6a 0d                	push   $0xd
  8015c6:	e8 b4 fe ff ff       	call   80147f <syscall>
  8015cb:	83 c4 18             	add    $0x18,%esp
}
  8015ce:	c9                   	leave  
  8015cf:	c3                   	ret    

008015d0 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  8015d0:	55                   	push   %ebp
  8015d1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  8015d3:	6a 00                	push   $0x0
  8015d5:	6a 00                	push   $0x0
  8015d7:	6a 00                	push   $0x0
  8015d9:	6a 00                	push   $0x0
  8015db:	6a 00                	push   $0x0
  8015dd:	6a 0e                	push   $0xe
  8015df:	e8 9b fe ff ff       	call   80147f <syscall>
  8015e4:	83 c4 18             	add    $0x18,%esp
}
  8015e7:	c9                   	leave  
  8015e8:	c3                   	ret    

008015e9 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  8015e9:	55                   	push   %ebp
  8015ea:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  8015ec:	6a 00                	push   $0x0
  8015ee:	6a 00                	push   $0x0
  8015f0:	6a 00                	push   $0x0
  8015f2:	6a 00                	push   $0x0
  8015f4:	6a 00                	push   $0x0
  8015f6:	6a 0f                	push   $0xf
  8015f8:	e8 82 fe ff ff       	call   80147f <syscall>
  8015fd:	83 c4 18             	add    $0x18,%esp
}
  801600:	c9                   	leave  
  801601:	c3                   	ret    

00801602 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801602:	55                   	push   %ebp
  801603:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801605:	6a 00                	push   $0x0
  801607:	6a 00                	push   $0x0
  801609:	6a 00                	push   $0x0
  80160b:	6a 00                	push   $0x0
  80160d:	ff 75 08             	pushl  0x8(%ebp)
  801610:	6a 10                	push   $0x10
  801612:	e8 68 fe ff ff       	call   80147f <syscall>
  801617:	83 c4 18             	add    $0x18,%esp
}
  80161a:	c9                   	leave  
  80161b:	c3                   	ret    

0080161c <sys_scarce_memory>:

void sys_scarce_memory()
{
  80161c:	55                   	push   %ebp
  80161d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  80161f:	6a 00                	push   $0x0
  801621:	6a 00                	push   $0x0
  801623:	6a 00                	push   $0x0
  801625:	6a 00                	push   $0x0
  801627:	6a 00                	push   $0x0
  801629:	6a 11                	push   $0x11
  80162b:	e8 4f fe ff ff       	call   80147f <syscall>
  801630:	83 c4 18             	add    $0x18,%esp
}
  801633:	90                   	nop
  801634:	c9                   	leave  
  801635:	c3                   	ret    

00801636 <sys_cputc>:

void
sys_cputc(const char c)
{
  801636:	55                   	push   %ebp
  801637:	89 e5                	mov    %esp,%ebp
  801639:	83 ec 04             	sub    $0x4,%esp
  80163c:	8b 45 08             	mov    0x8(%ebp),%eax
  80163f:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801642:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801646:	6a 00                	push   $0x0
  801648:	6a 00                	push   $0x0
  80164a:	6a 00                	push   $0x0
  80164c:	6a 00                	push   $0x0
  80164e:	50                   	push   %eax
  80164f:	6a 01                	push   $0x1
  801651:	e8 29 fe ff ff       	call   80147f <syscall>
  801656:	83 c4 18             	add    $0x18,%esp
}
  801659:	90                   	nop
  80165a:	c9                   	leave  
  80165b:	c3                   	ret    

0080165c <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  80165c:	55                   	push   %ebp
  80165d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  80165f:	6a 00                	push   $0x0
  801661:	6a 00                	push   $0x0
  801663:	6a 00                	push   $0x0
  801665:	6a 00                	push   $0x0
  801667:	6a 00                	push   $0x0
  801669:	6a 14                	push   $0x14
  80166b:	e8 0f fe ff ff       	call   80147f <syscall>
  801670:	83 c4 18             	add    $0x18,%esp
}
  801673:	90                   	nop
  801674:	c9                   	leave  
  801675:	c3                   	ret    

00801676 <sys_create_shared_object>:

int sys_create_shared_object(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801676:	55                   	push   %ebp
  801677:	89 e5                	mov    %esp,%ebp
  801679:	83 ec 04             	sub    $0x4,%esp
  80167c:	8b 45 10             	mov    0x10(%ebp),%eax
  80167f:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801682:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801685:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801689:	8b 45 08             	mov    0x8(%ebp),%eax
  80168c:	6a 00                	push   $0x0
  80168e:	51                   	push   %ecx
  80168f:	52                   	push   %edx
  801690:	ff 75 0c             	pushl  0xc(%ebp)
  801693:	50                   	push   %eax
  801694:	6a 15                	push   $0x15
  801696:	e8 e4 fd ff ff       	call   80147f <syscall>
  80169b:	83 c4 18             	add    $0x18,%esp
}
  80169e:	c9                   	leave  
  80169f:	c3                   	ret    

008016a0 <sys_size_of_shared_object>:

//2017:
int sys_size_of_shared_object(int32 ownerID, char* shareName)
{
  8016a0:	55                   	push   %ebp
  8016a1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  8016a3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8016a9:	6a 00                	push   $0x0
  8016ab:	6a 00                	push   $0x0
  8016ad:	6a 00                	push   $0x0
  8016af:	52                   	push   %edx
  8016b0:	50                   	push   %eax
  8016b1:	6a 16                	push   $0x16
  8016b3:	e8 c7 fd ff ff       	call   80147f <syscall>
  8016b8:	83 c4 18             	add    $0x18,%esp
}
  8016bb:	c9                   	leave  
  8016bc:	c3                   	ret    

008016bd <sys_get_shared_object>:
//==========

int sys_get_shared_object(int32 ownerID, char* shareName, void* virtual_address)
{
  8016bd:	55                   	push   %ebp
  8016be:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  8016c0:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8016c3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8016c9:	6a 00                	push   $0x0
  8016cb:	6a 00                	push   $0x0
  8016cd:	51                   	push   %ecx
  8016ce:	52                   	push   %edx
  8016cf:	50                   	push   %eax
  8016d0:	6a 17                	push   $0x17
  8016d2:	e8 a8 fd ff ff       	call   80147f <syscall>
  8016d7:	83 c4 18             	add    $0x18,%esp
}
  8016da:	c9                   	leave  
  8016db:	c3                   	ret    

008016dc <sys_delete_shared_object>:

int sys_delete_shared_object(int32 sharedObjectID, void *startVA)
{
  8016dc:	55                   	push   %ebp
  8016dd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  8016df:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8016e5:	6a 00                	push   $0x0
  8016e7:	6a 00                	push   $0x0
  8016e9:	6a 00                	push   $0x0
  8016eb:	52                   	push   %edx
  8016ec:	50                   	push   %eax
  8016ed:	6a 18                	push   $0x18
  8016ef:	e8 8b fd ff ff       	call   80147f <syscall>
  8016f4:	83 c4 18             	add    $0x18,%esp
}
  8016f7:	c9                   	leave  
  8016f8:	c3                   	ret    

008016f9 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  8016f9:	55                   	push   %ebp
  8016fa:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  8016fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8016ff:	6a 00                	push   $0x0
  801701:	ff 75 14             	pushl  0x14(%ebp)
  801704:	ff 75 10             	pushl  0x10(%ebp)
  801707:	ff 75 0c             	pushl  0xc(%ebp)
  80170a:	50                   	push   %eax
  80170b:	6a 19                	push   $0x19
  80170d:	e8 6d fd ff ff       	call   80147f <syscall>
  801712:	83 c4 18             	add    $0x18,%esp
}
  801715:	c9                   	leave  
  801716:	c3                   	ret    

00801717 <sys_run_env>:

void sys_run_env(int32 envId)
{
  801717:	55                   	push   %ebp
  801718:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  80171a:	8b 45 08             	mov    0x8(%ebp),%eax
  80171d:	6a 00                	push   $0x0
  80171f:	6a 00                	push   $0x0
  801721:	6a 00                	push   $0x0
  801723:	6a 00                	push   $0x0
  801725:	50                   	push   %eax
  801726:	6a 1a                	push   $0x1a
  801728:	e8 52 fd ff ff       	call   80147f <syscall>
  80172d:	83 c4 18             	add    $0x18,%esp
}
  801730:	90                   	nop
  801731:	c9                   	leave  
  801732:	c3                   	ret    

00801733 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801733:	55                   	push   %ebp
  801734:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801736:	8b 45 08             	mov    0x8(%ebp),%eax
  801739:	6a 00                	push   $0x0
  80173b:	6a 00                	push   $0x0
  80173d:	6a 00                	push   $0x0
  80173f:	6a 00                	push   $0x0
  801741:	50                   	push   %eax
  801742:	6a 1b                	push   $0x1b
  801744:	e8 36 fd ff ff       	call   80147f <syscall>
  801749:	83 c4 18             	add    $0x18,%esp
}
  80174c:	c9                   	leave  
  80174d:	c3                   	ret    

0080174e <sys_getenvid>:

int32 sys_getenvid(void)
{
  80174e:	55                   	push   %ebp
  80174f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801751:	6a 00                	push   $0x0
  801753:	6a 00                	push   $0x0
  801755:	6a 00                	push   $0x0
  801757:	6a 00                	push   $0x0
  801759:	6a 00                	push   $0x0
  80175b:	6a 05                	push   $0x5
  80175d:	e8 1d fd ff ff       	call   80147f <syscall>
  801762:	83 c4 18             	add    $0x18,%esp
}
  801765:	c9                   	leave  
  801766:	c3                   	ret    

00801767 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801767:	55                   	push   %ebp
  801768:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  80176a:	6a 00                	push   $0x0
  80176c:	6a 00                	push   $0x0
  80176e:	6a 00                	push   $0x0
  801770:	6a 00                	push   $0x0
  801772:	6a 00                	push   $0x0
  801774:	6a 06                	push   $0x6
  801776:	e8 04 fd ff ff       	call   80147f <syscall>
  80177b:	83 c4 18             	add    $0x18,%esp
}
  80177e:	c9                   	leave  
  80177f:	c3                   	ret    

00801780 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801780:	55                   	push   %ebp
  801781:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801783:	6a 00                	push   $0x0
  801785:	6a 00                	push   $0x0
  801787:	6a 00                	push   $0x0
  801789:	6a 00                	push   $0x0
  80178b:	6a 00                	push   $0x0
  80178d:	6a 07                	push   $0x7
  80178f:	e8 eb fc ff ff       	call   80147f <syscall>
  801794:	83 c4 18             	add    $0x18,%esp
}
  801797:	c9                   	leave  
  801798:	c3                   	ret    

00801799 <sys_exit_env>:


void sys_exit_env(void)
{
  801799:	55                   	push   %ebp
  80179a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  80179c:	6a 00                	push   $0x0
  80179e:	6a 00                	push   $0x0
  8017a0:	6a 00                	push   $0x0
  8017a2:	6a 00                	push   $0x0
  8017a4:	6a 00                	push   $0x0
  8017a6:	6a 1c                	push   $0x1c
  8017a8:	e8 d2 fc ff ff       	call   80147f <syscall>
  8017ad:	83 c4 18             	add    $0x18,%esp
}
  8017b0:	90                   	nop
  8017b1:	c9                   	leave  
  8017b2:	c3                   	ret    

008017b3 <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  8017b3:	55                   	push   %ebp
  8017b4:	89 e5                	mov    %esp,%ebp
  8017b6:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  8017b9:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8017bc:	8d 50 04             	lea    0x4(%eax),%edx
  8017bf:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8017c2:	6a 00                	push   $0x0
  8017c4:	6a 00                	push   $0x0
  8017c6:	6a 00                	push   $0x0
  8017c8:	52                   	push   %edx
  8017c9:	50                   	push   %eax
  8017ca:	6a 1d                	push   $0x1d
  8017cc:	e8 ae fc ff ff       	call   80147f <syscall>
  8017d1:	83 c4 18             	add    $0x18,%esp
	return result;
  8017d4:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8017d7:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8017da:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8017dd:	89 01                	mov    %eax,(%ecx)
  8017df:	89 51 04             	mov    %edx,0x4(%ecx)
}
  8017e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8017e5:	c9                   	leave  
  8017e6:	c2 04 00             	ret    $0x4

008017e9 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  8017e9:	55                   	push   %ebp
  8017ea:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  8017ec:	6a 00                	push   $0x0
  8017ee:	6a 00                	push   $0x0
  8017f0:	ff 75 10             	pushl  0x10(%ebp)
  8017f3:	ff 75 0c             	pushl  0xc(%ebp)
  8017f6:	ff 75 08             	pushl  0x8(%ebp)
  8017f9:	6a 13                	push   $0x13
  8017fb:	e8 7f fc ff ff       	call   80147f <syscall>
  801800:	83 c4 18             	add    $0x18,%esp
	return ;
  801803:	90                   	nop
}
  801804:	c9                   	leave  
  801805:	c3                   	ret    

00801806 <sys_rcr2>:
uint32 sys_rcr2()
{
  801806:	55                   	push   %ebp
  801807:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801809:	6a 00                	push   $0x0
  80180b:	6a 00                	push   $0x0
  80180d:	6a 00                	push   $0x0
  80180f:	6a 00                	push   $0x0
  801811:	6a 00                	push   $0x0
  801813:	6a 1e                	push   $0x1e
  801815:	e8 65 fc ff ff       	call   80147f <syscall>
  80181a:	83 c4 18             	add    $0x18,%esp
}
  80181d:	c9                   	leave  
  80181e:	c3                   	ret    

0080181f <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  80181f:	55                   	push   %ebp
  801820:	89 e5                	mov    %esp,%ebp
  801822:	83 ec 04             	sub    $0x4,%esp
  801825:	8b 45 08             	mov    0x8(%ebp),%eax
  801828:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  80182b:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  80182f:	6a 00                	push   $0x0
  801831:	6a 00                	push   $0x0
  801833:	6a 00                	push   $0x0
  801835:	6a 00                	push   $0x0
  801837:	50                   	push   %eax
  801838:	6a 1f                	push   $0x1f
  80183a:	e8 40 fc ff ff       	call   80147f <syscall>
  80183f:	83 c4 18             	add    $0x18,%esp
	return ;
  801842:	90                   	nop
}
  801843:	c9                   	leave  
  801844:	c3                   	ret    

00801845 <rsttst>:
void rsttst()
{
  801845:	55                   	push   %ebp
  801846:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801848:	6a 00                	push   $0x0
  80184a:	6a 00                	push   $0x0
  80184c:	6a 00                	push   $0x0
  80184e:	6a 00                	push   $0x0
  801850:	6a 00                	push   $0x0
  801852:	6a 21                	push   $0x21
  801854:	e8 26 fc ff ff       	call   80147f <syscall>
  801859:	83 c4 18             	add    $0x18,%esp
	return ;
  80185c:	90                   	nop
}
  80185d:	c9                   	leave  
  80185e:	c3                   	ret    

0080185f <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  80185f:	55                   	push   %ebp
  801860:	89 e5                	mov    %esp,%ebp
  801862:	83 ec 04             	sub    $0x4,%esp
  801865:	8b 45 14             	mov    0x14(%ebp),%eax
  801868:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  80186b:	8b 55 18             	mov    0x18(%ebp),%edx
  80186e:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801872:	52                   	push   %edx
  801873:	50                   	push   %eax
  801874:	ff 75 10             	pushl  0x10(%ebp)
  801877:	ff 75 0c             	pushl  0xc(%ebp)
  80187a:	ff 75 08             	pushl  0x8(%ebp)
  80187d:	6a 20                	push   $0x20
  80187f:	e8 fb fb ff ff       	call   80147f <syscall>
  801884:	83 c4 18             	add    $0x18,%esp
	return ;
  801887:	90                   	nop
}
  801888:	c9                   	leave  
  801889:	c3                   	ret    

0080188a <chktst>:
void chktst(uint32 n)
{
  80188a:	55                   	push   %ebp
  80188b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  80188d:	6a 00                	push   $0x0
  80188f:	6a 00                	push   $0x0
  801891:	6a 00                	push   $0x0
  801893:	6a 00                	push   $0x0
  801895:	ff 75 08             	pushl  0x8(%ebp)
  801898:	6a 22                	push   $0x22
  80189a:	e8 e0 fb ff ff       	call   80147f <syscall>
  80189f:	83 c4 18             	add    $0x18,%esp
	return ;
  8018a2:	90                   	nop
}
  8018a3:	c9                   	leave  
  8018a4:	c3                   	ret    

008018a5 <inctst>:

void inctst()
{
  8018a5:	55                   	push   %ebp
  8018a6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  8018a8:	6a 00                	push   $0x0
  8018aa:	6a 00                	push   $0x0
  8018ac:	6a 00                	push   $0x0
  8018ae:	6a 00                	push   $0x0
  8018b0:	6a 00                	push   $0x0
  8018b2:	6a 23                	push   $0x23
  8018b4:	e8 c6 fb ff ff       	call   80147f <syscall>
  8018b9:	83 c4 18             	add    $0x18,%esp
	return ;
  8018bc:	90                   	nop
}
  8018bd:	c9                   	leave  
  8018be:	c3                   	ret    

008018bf <gettst>:
uint32 gettst()
{
  8018bf:	55                   	push   %ebp
  8018c0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  8018c2:	6a 00                	push   $0x0
  8018c4:	6a 00                	push   $0x0
  8018c6:	6a 00                	push   $0x0
  8018c8:	6a 00                	push   $0x0
  8018ca:	6a 00                	push   $0x0
  8018cc:	6a 24                	push   $0x24
  8018ce:	e8 ac fb ff ff       	call   80147f <syscall>
  8018d3:	83 c4 18             	add    $0x18,%esp
}
  8018d6:	c9                   	leave  
  8018d7:	c3                   	ret    

008018d8 <sys_get_uheap_strategy>:

/*2025*/
uint32 sys_get_uheap_strategy()
{
  8018d8:	55                   	push   %ebp
  8018d9:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8018db:	6a 00                	push   $0x0
  8018dd:	6a 00                	push   $0x0
  8018df:	6a 00                	push   $0x0
  8018e1:	6a 00                	push   $0x0
  8018e3:	6a 00                	push   $0x0
  8018e5:	6a 25                	push   $0x25
  8018e7:	e8 93 fb ff ff       	call   80147f <syscall>
  8018ec:	83 c4 18             	add    $0x18,%esp
  8018ef:	a3 60 b0 81 00       	mov    %eax,0x81b060
	return uheapPlaceStrategy ;
  8018f4:	a1 60 b0 81 00       	mov    0x81b060,%eax
}
  8018f9:	c9                   	leave  
  8018fa:	c3                   	ret    

008018fb <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  8018fb:	55                   	push   %ebp
  8018fc:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = heapStrategy;
  8018fe:	8b 45 08             	mov    0x8(%ebp),%eax
  801901:	a3 60 b0 81 00       	mov    %eax,0x81b060
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801906:	6a 00                	push   $0x0
  801908:	6a 00                	push   $0x0
  80190a:	6a 00                	push   $0x0
  80190c:	6a 00                	push   $0x0
  80190e:	ff 75 08             	pushl  0x8(%ebp)
  801911:	6a 26                	push   $0x26
  801913:	e8 67 fb ff ff       	call   80147f <syscall>
  801918:	83 c4 18             	add    $0x18,%esp
	return ;
  80191b:	90                   	nop
}
  80191c:	c9                   	leave  
  80191d:	c3                   	ret    

0080191e <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  80191e:	55                   	push   %ebp
  80191f:	89 e5                	mov    %esp,%ebp
  801921:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801922:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801925:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801928:	8b 55 0c             	mov    0xc(%ebp),%edx
  80192b:	8b 45 08             	mov    0x8(%ebp),%eax
  80192e:	6a 00                	push   $0x0
  801930:	53                   	push   %ebx
  801931:	51                   	push   %ecx
  801932:	52                   	push   %edx
  801933:	50                   	push   %eax
  801934:	6a 27                	push   $0x27
  801936:	e8 44 fb ff ff       	call   80147f <syscall>
  80193b:	83 c4 18             	add    $0x18,%esp
}
  80193e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801941:	c9                   	leave  
  801942:	c3                   	ret    

00801943 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801943:	55                   	push   %ebp
  801944:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801946:	8b 55 0c             	mov    0xc(%ebp),%edx
  801949:	8b 45 08             	mov    0x8(%ebp),%eax
  80194c:	6a 00                	push   $0x0
  80194e:	6a 00                	push   $0x0
  801950:	6a 00                	push   $0x0
  801952:	52                   	push   %edx
  801953:	50                   	push   %eax
  801954:	6a 28                	push   $0x28
  801956:	e8 24 fb ff ff       	call   80147f <syscall>
  80195b:	83 c4 18             	add    $0x18,%esp
}
  80195e:	c9                   	leave  
  80195f:	c3                   	ret    

00801960 <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  801960:	55                   	push   %ebp
  801961:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  801963:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801966:	8b 55 0c             	mov    0xc(%ebp),%edx
  801969:	8b 45 08             	mov    0x8(%ebp),%eax
  80196c:	6a 00                	push   $0x0
  80196e:	51                   	push   %ecx
  80196f:	ff 75 10             	pushl  0x10(%ebp)
  801972:	52                   	push   %edx
  801973:	50                   	push   %eax
  801974:	6a 29                	push   $0x29
  801976:	e8 04 fb ff ff       	call   80147f <syscall>
  80197b:	83 c4 18             	add    $0x18,%esp
}
  80197e:	c9                   	leave  
  80197f:	c3                   	ret    

00801980 <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801980:	55                   	push   %ebp
  801981:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801983:	6a 00                	push   $0x0
  801985:	6a 00                	push   $0x0
  801987:	ff 75 10             	pushl  0x10(%ebp)
  80198a:	ff 75 0c             	pushl  0xc(%ebp)
  80198d:	ff 75 08             	pushl  0x8(%ebp)
  801990:	6a 12                	push   $0x12
  801992:	e8 e8 fa ff ff       	call   80147f <syscall>
  801997:	83 c4 18             	add    $0x18,%esp
	return ;
  80199a:	90                   	nop
}
  80199b:	c9                   	leave  
  80199c:	c3                   	ret    

0080199d <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  80199d:	55                   	push   %ebp
  80199e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  8019a0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8019a6:	6a 00                	push   $0x0
  8019a8:	6a 00                	push   $0x0
  8019aa:	6a 00                	push   $0x0
  8019ac:	52                   	push   %edx
  8019ad:	50                   	push   %eax
  8019ae:	6a 2a                	push   $0x2a
  8019b0:	e8 ca fa ff ff       	call   80147f <syscall>
  8019b5:	83 c4 18             	add    $0x18,%esp
	return;
  8019b8:	90                   	nop
}
  8019b9:	c9                   	leave  
  8019ba:	c3                   	ret    

008019bb <sys_get_optimal_num_faults>:
/*2025*/
int sys_get_optimal_num_faults()
{
  8019bb:	55                   	push   %ebp
  8019bc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_optimal_num_faults, 0, 0, 0, 0, 0);
  8019be:	6a 00                	push   $0x0
  8019c0:	6a 00                	push   $0x0
  8019c2:	6a 00                	push   $0x0
  8019c4:	6a 00                	push   $0x0
  8019c6:	6a 00                	push   $0x0
  8019c8:	6a 2b                	push   $0x2b
  8019ca:	e8 b0 fa ff ff       	call   80147f <syscall>
  8019cf:	83 c4 18             	add    $0x18,%esp
}
  8019d2:	c9                   	leave  
  8019d3:	c3                   	ret    

008019d4 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  8019d4:	55                   	push   %ebp
  8019d5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  8019d7:	6a 00                	push   $0x0
  8019d9:	6a 00                	push   $0x0
  8019db:	6a 00                	push   $0x0
  8019dd:	ff 75 0c             	pushl  0xc(%ebp)
  8019e0:	ff 75 08             	pushl  0x8(%ebp)
  8019e3:	6a 2d                	push   $0x2d
  8019e5:	e8 95 fa ff ff       	call   80147f <syscall>
  8019ea:	83 c4 18             	add    $0x18,%esp
	return;
  8019ed:	90                   	nop
}
  8019ee:	c9                   	leave  
  8019ef:	c3                   	ret    

008019f0 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  8019f0:	55                   	push   %ebp
  8019f1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  8019f3:	6a 00                	push   $0x0
  8019f5:	6a 00                	push   $0x0
  8019f7:	6a 00                	push   $0x0
  8019f9:	ff 75 0c             	pushl  0xc(%ebp)
  8019fc:	ff 75 08             	pushl  0x8(%ebp)
  8019ff:	6a 2c                	push   $0x2c
  801a01:	e8 79 fa ff ff       	call   80147f <syscall>
  801a06:	83 c4 18             	add    $0x18,%esp
	return ;
  801a09:	90                   	nop
}
  801a0a:	c9                   	leave  
  801a0b:	c3                   	ret    

00801a0c <sys_env_set_priority>:


void sys_env_set_priority(int32 envID, int priority)
{
  801a0c:	55                   	push   %ebp
  801a0d:	89 e5                	mov    %esp,%ebp
  801a0f:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.IM#4] CPU SCHEDULING - #1 System Calls - Add suitable code here
	//Your code is here
	//Comment the following line
	panic("sys_env_set_priority() is not implemented yet...!!");
  801a12:	83 ec 04             	sub    $0x4,%esp
  801a15:	68 1c 24 80 00       	push   $0x80241c
  801a1a:	68 25 01 00 00       	push   $0x125
  801a1f:	68 4f 24 80 00       	push   $0x80244f
  801a24:	e8 3c 00 00 00       	call   801a65 <_panic>

00801a29 <cputchar>:
#include <inc/lib.h>


void
cputchar(int ch)
{
  801a29:	55                   	push   %ebp
  801a2a:	89 e5                	mov    %esp,%ebp
  801a2c:	83 ec 18             	sub    $0x18,%esp
	char c = ch;
  801a2f:	8b 45 08             	mov    0x8(%ebp),%eax
  801a32:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	//sys_cputs(&c, 1);

	sys_cputc(c);
  801a35:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  801a39:	83 ec 0c             	sub    $0xc,%esp
  801a3c:	50                   	push   %eax
  801a3d:	e8 f4 fb ff ff       	call   801636 <sys_cputc>
  801a42:	83 c4 10             	add    $0x10,%esp
}
  801a45:	90                   	nop
  801a46:	c9                   	leave  
  801a47:	c3                   	ret    

00801a48 <getchar>:


int
getchar(void)
{
  801a48:	55                   	push   %ebp
  801a49:	89 e5                	mov    %esp,%ebp
  801a4b:	83 ec 18             	sub    $0x18,%esp
	int c =sys_cgetc();
  801a4e:	e8 82 fa ff ff       	call   8014d5 <sys_cgetc>
  801a53:	89 45 f4             	mov    %eax,-0xc(%ebp)
	return c;
  801a56:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  801a59:	c9                   	leave  
  801a5a:	c3                   	ret    

00801a5b <iscons>:

int iscons(int fdnum)
{
  801a5b:	55                   	push   %ebp
  801a5c:	89 e5                	mov    %esp,%ebp
	// used by readline
	return 1;
  801a5e:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801a63:	5d                   	pop    %ebp
  801a64:	c3                   	ret    

00801a65 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  801a65:	55                   	push   %ebp
  801a66:	89 e5                	mov    %esp,%ebp
  801a68:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  801a6b:	8d 45 10             	lea    0x10(%ebp),%eax
  801a6e:	83 c0 04             	add    $0x4,%eax
  801a71:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  801a74:	a1 1c b1 81 00       	mov    0x81b11c,%eax
  801a79:	85 c0                	test   %eax,%eax
  801a7b:	74 16                	je     801a93 <_panic+0x2e>
		cprintf("%s: ", argv0);
  801a7d:	a1 1c b1 81 00       	mov    0x81b11c,%eax
  801a82:	83 ec 08             	sub    $0x8,%esp
  801a85:	50                   	push   %eax
  801a86:	68 60 24 80 00       	push   $0x802460
  801a8b:	e8 02 e9 ff ff       	call   800392 <cprintf>
  801a90:	83 c4 10             	add    $0x10,%esp
	cprintf_colored(TEXT_PANIC_CLR, "user [EVAL_FINAL]panic in %s at %s:%d: ", binaryname, file, line);
  801a93:	a1 04 30 80 00       	mov    0x803004,%eax
  801a98:	83 ec 0c             	sub    $0xc,%esp
  801a9b:	ff 75 0c             	pushl  0xc(%ebp)
  801a9e:	ff 75 08             	pushl  0x8(%ebp)
  801aa1:	50                   	push   %eax
  801aa2:	68 68 24 80 00       	push   $0x802468
  801aa7:	6a 74                	push   $0x74
  801aa9:	e8 11 e9 ff ff       	call   8003bf <cprintf_colored>
  801aae:	83 c4 20             	add    $0x20,%esp
	vcprintf(fmt, ap);
  801ab1:	8b 45 10             	mov    0x10(%ebp),%eax
  801ab4:	83 ec 08             	sub    $0x8,%esp
  801ab7:	ff 75 f4             	pushl  -0xc(%ebp)
  801aba:	50                   	push   %eax
  801abb:	e8 63 e8 ff ff       	call   800323 <vcprintf>
  801ac0:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  801ac3:	83 ec 08             	sub    $0x8,%esp
  801ac6:	6a 00                	push   $0x0
  801ac8:	68 90 24 80 00       	push   $0x802490
  801acd:	e8 51 e8 ff ff       	call   800323 <vcprintf>
  801ad2:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  801ad5:	e8 ca e7 ff ff       	call   8002a4 <exit>

	// should not return here
	while (1) ;
  801ada:	eb fe                	jmp    801ada <_panic+0x75>

00801adc <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  801adc:	55                   	push   %ebp
  801add:	89 e5                	mov    %esp,%ebp
  801adf:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  801ae2:	a1 20 30 80 00       	mov    0x803020,%eax
  801ae7:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  801aed:	8b 45 0c             	mov    0xc(%ebp),%eax
  801af0:	39 c2                	cmp    %eax,%edx
  801af2:	74 14                	je     801b08 <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  801af4:	83 ec 04             	sub    $0x4,%esp
  801af7:	68 94 24 80 00       	push   $0x802494
  801afc:	6a 26                	push   $0x26
  801afe:	68 e0 24 80 00       	push   $0x8024e0
  801b03:	e8 5d ff ff ff       	call   801a65 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  801b08:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  801b0f:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  801b16:	e9 c5 00 00 00       	jmp    801be0 <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  801b1b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801b1e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801b25:	8b 45 08             	mov    0x8(%ebp),%eax
  801b28:	01 d0                	add    %edx,%eax
  801b2a:	8b 00                	mov    (%eax),%eax
  801b2c:	85 c0                	test   %eax,%eax
  801b2e:	75 08                	jne    801b38 <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  801b30:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  801b33:	e9 a5 00 00 00       	jmp    801bdd <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  801b38:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  801b3f:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  801b46:	eb 69                	jmp    801bb1 <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  801b48:	a1 20 30 80 00       	mov    0x803020,%eax
  801b4d:	8b 88 38 da 01 00    	mov    0x1da38(%eax),%ecx
  801b53:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801b56:	89 d0                	mov    %edx,%eax
  801b58:	01 c0                	add    %eax,%eax
  801b5a:	01 d0                	add    %edx,%eax
  801b5c:	c1 e0 03             	shl    $0x3,%eax
  801b5f:	01 c8                	add    %ecx,%eax
  801b61:	8a 40 04             	mov    0x4(%eax),%al
  801b64:	84 c0                	test   %al,%al
  801b66:	75 46                	jne    801bae <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  801b68:	a1 20 30 80 00       	mov    0x803020,%eax
  801b6d:	8b 88 38 da 01 00    	mov    0x1da38(%eax),%ecx
  801b73:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801b76:	89 d0                	mov    %edx,%eax
  801b78:	01 c0                	add    %eax,%eax
  801b7a:	01 d0                	add    %edx,%eax
  801b7c:	c1 e0 03             	shl    $0x3,%eax
  801b7f:	01 c8                	add    %ecx,%eax
  801b81:	8b 00                	mov    (%eax),%eax
  801b83:	89 45 dc             	mov    %eax,-0x24(%ebp)
  801b86:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801b89:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801b8e:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  801b90:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801b93:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  801b9a:	8b 45 08             	mov    0x8(%ebp),%eax
  801b9d:	01 c8                	add    %ecx,%eax
  801b9f:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  801ba1:	39 c2                	cmp    %eax,%edx
  801ba3:	75 09                	jne    801bae <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  801ba5:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  801bac:	eb 15                	jmp    801bc3 <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  801bae:	ff 45 e8             	incl   -0x18(%ebp)
  801bb1:	a1 20 30 80 00       	mov    0x803020,%eax
  801bb6:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  801bbc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801bbf:	39 c2                	cmp    %eax,%edx
  801bc1:	77 85                	ja     801b48 <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  801bc3:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801bc7:	75 14                	jne    801bdd <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  801bc9:	83 ec 04             	sub    $0x4,%esp
  801bcc:	68 ec 24 80 00       	push   $0x8024ec
  801bd1:	6a 3a                	push   $0x3a
  801bd3:	68 e0 24 80 00       	push   $0x8024e0
  801bd8:	e8 88 fe ff ff       	call   801a65 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  801bdd:	ff 45 f0             	incl   -0x10(%ebp)
  801be0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801be3:	3b 45 0c             	cmp    0xc(%ebp),%eax
  801be6:	0f 8c 2f ff ff ff    	jl     801b1b <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  801bec:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  801bf3:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  801bfa:	eb 26                	jmp    801c22 <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  801bfc:	a1 20 30 80 00       	mov    0x803020,%eax
  801c01:	8b 88 38 da 01 00    	mov    0x1da38(%eax),%ecx
  801c07:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801c0a:	89 d0                	mov    %edx,%eax
  801c0c:	01 c0                	add    %eax,%eax
  801c0e:	01 d0                	add    %edx,%eax
  801c10:	c1 e0 03             	shl    $0x3,%eax
  801c13:	01 c8                	add    %ecx,%eax
  801c15:	8a 40 04             	mov    0x4(%eax),%al
  801c18:	3c 01                	cmp    $0x1,%al
  801c1a:	75 03                	jne    801c1f <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  801c1c:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  801c1f:	ff 45 e0             	incl   -0x20(%ebp)
  801c22:	a1 20 30 80 00       	mov    0x803020,%eax
  801c27:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  801c2d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801c30:	39 c2                	cmp    %eax,%edx
  801c32:	77 c8                	ja     801bfc <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  801c34:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c37:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  801c3a:	74 14                	je     801c50 <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  801c3c:	83 ec 04             	sub    $0x4,%esp
  801c3f:	68 40 25 80 00       	push   $0x802540
  801c44:	6a 44                	push   $0x44
  801c46:	68 e0 24 80 00       	push   $0x8024e0
  801c4b:	e8 15 fe ff ff       	call   801a65 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  801c50:	90                   	nop
  801c51:	c9                   	leave  
  801c52:	c3                   	ret    
  801c53:	90                   	nop

00801c54 <__udivdi3>:
  801c54:	55                   	push   %ebp
  801c55:	57                   	push   %edi
  801c56:	56                   	push   %esi
  801c57:	53                   	push   %ebx
  801c58:	83 ec 1c             	sub    $0x1c,%esp
  801c5b:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  801c5f:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  801c63:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801c67:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801c6b:	89 ca                	mov    %ecx,%edx
  801c6d:	89 f8                	mov    %edi,%eax
  801c6f:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  801c73:	85 f6                	test   %esi,%esi
  801c75:	75 2d                	jne    801ca4 <__udivdi3+0x50>
  801c77:	39 cf                	cmp    %ecx,%edi
  801c79:	77 65                	ja     801ce0 <__udivdi3+0x8c>
  801c7b:	89 fd                	mov    %edi,%ebp
  801c7d:	85 ff                	test   %edi,%edi
  801c7f:	75 0b                	jne    801c8c <__udivdi3+0x38>
  801c81:	b8 01 00 00 00       	mov    $0x1,%eax
  801c86:	31 d2                	xor    %edx,%edx
  801c88:	f7 f7                	div    %edi
  801c8a:	89 c5                	mov    %eax,%ebp
  801c8c:	31 d2                	xor    %edx,%edx
  801c8e:	89 c8                	mov    %ecx,%eax
  801c90:	f7 f5                	div    %ebp
  801c92:	89 c1                	mov    %eax,%ecx
  801c94:	89 d8                	mov    %ebx,%eax
  801c96:	f7 f5                	div    %ebp
  801c98:	89 cf                	mov    %ecx,%edi
  801c9a:	89 fa                	mov    %edi,%edx
  801c9c:	83 c4 1c             	add    $0x1c,%esp
  801c9f:	5b                   	pop    %ebx
  801ca0:	5e                   	pop    %esi
  801ca1:	5f                   	pop    %edi
  801ca2:	5d                   	pop    %ebp
  801ca3:	c3                   	ret    
  801ca4:	39 ce                	cmp    %ecx,%esi
  801ca6:	77 28                	ja     801cd0 <__udivdi3+0x7c>
  801ca8:	0f bd fe             	bsr    %esi,%edi
  801cab:	83 f7 1f             	xor    $0x1f,%edi
  801cae:	75 40                	jne    801cf0 <__udivdi3+0x9c>
  801cb0:	39 ce                	cmp    %ecx,%esi
  801cb2:	72 0a                	jb     801cbe <__udivdi3+0x6a>
  801cb4:	3b 44 24 08          	cmp    0x8(%esp),%eax
  801cb8:	0f 87 9e 00 00 00    	ja     801d5c <__udivdi3+0x108>
  801cbe:	b8 01 00 00 00       	mov    $0x1,%eax
  801cc3:	89 fa                	mov    %edi,%edx
  801cc5:	83 c4 1c             	add    $0x1c,%esp
  801cc8:	5b                   	pop    %ebx
  801cc9:	5e                   	pop    %esi
  801cca:	5f                   	pop    %edi
  801ccb:	5d                   	pop    %ebp
  801ccc:	c3                   	ret    
  801ccd:	8d 76 00             	lea    0x0(%esi),%esi
  801cd0:	31 ff                	xor    %edi,%edi
  801cd2:	31 c0                	xor    %eax,%eax
  801cd4:	89 fa                	mov    %edi,%edx
  801cd6:	83 c4 1c             	add    $0x1c,%esp
  801cd9:	5b                   	pop    %ebx
  801cda:	5e                   	pop    %esi
  801cdb:	5f                   	pop    %edi
  801cdc:	5d                   	pop    %ebp
  801cdd:	c3                   	ret    
  801cde:	66 90                	xchg   %ax,%ax
  801ce0:	89 d8                	mov    %ebx,%eax
  801ce2:	f7 f7                	div    %edi
  801ce4:	31 ff                	xor    %edi,%edi
  801ce6:	89 fa                	mov    %edi,%edx
  801ce8:	83 c4 1c             	add    $0x1c,%esp
  801ceb:	5b                   	pop    %ebx
  801cec:	5e                   	pop    %esi
  801ced:	5f                   	pop    %edi
  801cee:	5d                   	pop    %ebp
  801cef:	c3                   	ret    
  801cf0:	bd 20 00 00 00       	mov    $0x20,%ebp
  801cf5:	89 eb                	mov    %ebp,%ebx
  801cf7:	29 fb                	sub    %edi,%ebx
  801cf9:	89 f9                	mov    %edi,%ecx
  801cfb:	d3 e6                	shl    %cl,%esi
  801cfd:	89 c5                	mov    %eax,%ebp
  801cff:	88 d9                	mov    %bl,%cl
  801d01:	d3 ed                	shr    %cl,%ebp
  801d03:	89 e9                	mov    %ebp,%ecx
  801d05:	09 f1                	or     %esi,%ecx
  801d07:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  801d0b:	89 f9                	mov    %edi,%ecx
  801d0d:	d3 e0                	shl    %cl,%eax
  801d0f:	89 c5                	mov    %eax,%ebp
  801d11:	89 d6                	mov    %edx,%esi
  801d13:	88 d9                	mov    %bl,%cl
  801d15:	d3 ee                	shr    %cl,%esi
  801d17:	89 f9                	mov    %edi,%ecx
  801d19:	d3 e2                	shl    %cl,%edx
  801d1b:	8b 44 24 08          	mov    0x8(%esp),%eax
  801d1f:	88 d9                	mov    %bl,%cl
  801d21:	d3 e8                	shr    %cl,%eax
  801d23:	09 c2                	or     %eax,%edx
  801d25:	89 d0                	mov    %edx,%eax
  801d27:	89 f2                	mov    %esi,%edx
  801d29:	f7 74 24 0c          	divl   0xc(%esp)
  801d2d:	89 d6                	mov    %edx,%esi
  801d2f:	89 c3                	mov    %eax,%ebx
  801d31:	f7 e5                	mul    %ebp
  801d33:	39 d6                	cmp    %edx,%esi
  801d35:	72 19                	jb     801d50 <__udivdi3+0xfc>
  801d37:	74 0b                	je     801d44 <__udivdi3+0xf0>
  801d39:	89 d8                	mov    %ebx,%eax
  801d3b:	31 ff                	xor    %edi,%edi
  801d3d:	e9 58 ff ff ff       	jmp    801c9a <__udivdi3+0x46>
  801d42:	66 90                	xchg   %ax,%ax
  801d44:	8b 54 24 08          	mov    0x8(%esp),%edx
  801d48:	89 f9                	mov    %edi,%ecx
  801d4a:	d3 e2                	shl    %cl,%edx
  801d4c:	39 c2                	cmp    %eax,%edx
  801d4e:	73 e9                	jae    801d39 <__udivdi3+0xe5>
  801d50:	8d 43 ff             	lea    -0x1(%ebx),%eax
  801d53:	31 ff                	xor    %edi,%edi
  801d55:	e9 40 ff ff ff       	jmp    801c9a <__udivdi3+0x46>
  801d5a:	66 90                	xchg   %ax,%ax
  801d5c:	31 c0                	xor    %eax,%eax
  801d5e:	e9 37 ff ff ff       	jmp    801c9a <__udivdi3+0x46>
  801d63:	90                   	nop

00801d64 <__umoddi3>:
  801d64:	55                   	push   %ebp
  801d65:	57                   	push   %edi
  801d66:	56                   	push   %esi
  801d67:	53                   	push   %ebx
  801d68:	83 ec 1c             	sub    $0x1c,%esp
  801d6b:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  801d6f:	8b 74 24 34          	mov    0x34(%esp),%esi
  801d73:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801d77:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  801d7b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801d7f:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801d83:	89 f3                	mov    %esi,%ebx
  801d85:	89 fa                	mov    %edi,%edx
  801d87:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801d8b:	89 34 24             	mov    %esi,(%esp)
  801d8e:	85 c0                	test   %eax,%eax
  801d90:	75 1a                	jne    801dac <__umoddi3+0x48>
  801d92:	39 f7                	cmp    %esi,%edi
  801d94:	0f 86 a2 00 00 00    	jbe    801e3c <__umoddi3+0xd8>
  801d9a:	89 c8                	mov    %ecx,%eax
  801d9c:	89 f2                	mov    %esi,%edx
  801d9e:	f7 f7                	div    %edi
  801da0:	89 d0                	mov    %edx,%eax
  801da2:	31 d2                	xor    %edx,%edx
  801da4:	83 c4 1c             	add    $0x1c,%esp
  801da7:	5b                   	pop    %ebx
  801da8:	5e                   	pop    %esi
  801da9:	5f                   	pop    %edi
  801daa:	5d                   	pop    %ebp
  801dab:	c3                   	ret    
  801dac:	39 f0                	cmp    %esi,%eax
  801dae:	0f 87 ac 00 00 00    	ja     801e60 <__umoddi3+0xfc>
  801db4:	0f bd e8             	bsr    %eax,%ebp
  801db7:	83 f5 1f             	xor    $0x1f,%ebp
  801dba:	0f 84 ac 00 00 00    	je     801e6c <__umoddi3+0x108>
  801dc0:	bf 20 00 00 00       	mov    $0x20,%edi
  801dc5:	29 ef                	sub    %ebp,%edi
  801dc7:	89 fe                	mov    %edi,%esi
  801dc9:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801dcd:	89 e9                	mov    %ebp,%ecx
  801dcf:	d3 e0                	shl    %cl,%eax
  801dd1:	89 d7                	mov    %edx,%edi
  801dd3:	89 f1                	mov    %esi,%ecx
  801dd5:	d3 ef                	shr    %cl,%edi
  801dd7:	09 c7                	or     %eax,%edi
  801dd9:	89 e9                	mov    %ebp,%ecx
  801ddb:	d3 e2                	shl    %cl,%edx
  801ddd:	89 14 24             	mov    %edx,(%esp)
  801de0:	89 d8                	mov    %ebx,%eax
  801de2:	d3 e0                	shl    %cl,%eax
  801de4:	89 c2                	mov    %eax,%edx
  801de6:	8b 44 24 08          	mov    0x8(%esp),%eax
  801dea:	d3 e0                	shl    %cl,%eax
  801dec:	89 44 24 04          	mov    %eax,0x4(%esp)
  801df0:	8b 44 24 08          	mov    0x8(%esp),%eax
  801df4:	89 f1                	mov    %esi,%ecx
  801df6:	d3 e8                	shr    %cl,%eax
  801df8:	09 d0                	or     %edx,%eax
  801dfa:	d3 eb                	shr    %cl,%ebx
  801dfc:	89 da                	mov    %ebx,%edx
  801dfe:	f7 f7                	div    %edi
  801e00:	89 d3                	mov    %edx,%ebx
  801e02:	f7 24 24             	mull   (%esp)
  801e05:	89 c6                	mov    %eax,%esi
  801e07:	89 d1                	mov    %edx,%ecx
  801e09:	39 d3                	cmp    %edx,%ebx
  801e0b:	0f 82 87 00 00 00    	jb     801e98 <__umoddi3+0x134>
  801e11:	0f 84 91 00 00 00    	je     801ea8 <__umoddi3+0x144>
  801e17:	8b 54 24 04          	mov    0x4(%esp),%edx
  801e1b:	29 f2                	sub    %esi,%edx
  801e1d:	19 cb                	sbb    %ecx,%ebx
  801e1f:	89 d8                	mov    %ebx,%eax
  801e21:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  801e25:	d3 e0                	shl    %cl,%eax
  801e27:	89 e9                	mov    %ebp,%ecx
  801e29:	d3 ea                	shr    %cl,%edx
  801e2b:	09 d0                	or     %edx,%eax
  801e2d:	89 e9                	mov    %ebp,%ecx
  801e2f:	d3 eb                	shr    %cl,%ebx
  801e31:	89 da                	mov    %ebx,%edx
  801e33:	83 c4 1c             	add    $0x1c,%esp
  801e36:	5b                   	pop    %ebx
  801e37:	5e                   	pop    %esi
  801e38:	5f                   	pop    %edi
  801e39:	5d                   	pop    %ebp
  801e3a:	c3                   	ret    
  801e3b:	90                   	nop
  801e3c:	89 fd                	mov    %edi,%ebp
  801e3e:	85 ff                	test   %edi,%edi
  801e40:	75 0b                	jne    801e4d <__umoddi3+0xe9>
  801e42:	b8 01 00 00 00       	mov    $0x1,%eax
  801e47:	31 d2                	xor    %edx,%edx
  801e49:	f7 f7                	div    %edi
  801e4b:	89 c5                	mov    %eax,%ebp
  801e4d:	89 f0                	mov    %esi,%eax
  801e4f:	31 d2                	xor    %edx,%edx
  801e51:	f7 f5                	div    %ebp
  801e53:	89 c8                	mov    %ecx,%eax
  801e55:	f7 f5                	div    %ebp
  801e57:	89 d0                	mov    %edx,%eax
  801e59:	e9 44 ff ff ff       	jmp    801da2 <__umoddi3+0x3e>
  801e5e:	66 90                	xchg   %ax,%ax
  801e60:	89 c8                	mov    %ecx,%eax
  801e62:	89 f2                	mov    %esi,%edx
  801e64:	83 c4 1c             	add    $0x1c,%esp
  801e67:	5b                   	pop    %ebx
  801e68:	5e                   	pop    %esi
  801e69:	5f                   	pop    %edi
  801e6a:	5d                   	pop    %ebp
  801e6b:	c3                   	ret    
  801e6c:	3b 04 24             	cmp    (%esp),%eax
  801e6f:	72 06                	jb     801e77 <__umoddi3+0x113>
  801e71:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  801e75:	77 0f                	ja     801e86 <__umoddi3+0x122>
  801e77:	89 f2                	mov    %esi,%edx
  801e79:	29 f9                	sub    %edi,%ecx
  801e7b:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  801e7f:	89 14 24             	mov    %edx,(%esp)
  801e82:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801e86:	8b 44 24 04          	mov    0x4(%esp),%eax
  801e8a:	8b 14 24             	mov    (%esp),%edx
  801e8d:	83 c4 1c             	add    $0x1c,%esp
  801e90:	5b                   	pop    %ebx
  801e91:	5e                   	pop    %esi
  801e92:	5f                   	pop    %edi
  801e93:	5d                   	pop    %ebp
  801e94:	c3                   	ret    
  801e95:	8d 76 00             	lea    0x0(%esi),%esi
  801e98:	2b 04 24             	sub    (%esp),%eax
  801e9b:	19 fa                	sbb    %edi,%edx
  801e9d:	89 d1                	mov    %edx,%ecx
  801e9f:	89 c6                	mov    %eax,%esi
  801ea1:	e9 71 ff ff ff       	jmp    801e17 <__umoddi3+0xb3>
  801ea6:	66 90                	xchg   %ax,%ax
  801ea8:	39 44 24 04          	cmp    %eax,0x4(%esp)
  801eac:	72 ea                	jb     801e98 <__umoddi3+0x134>
  801eae:	89 d9                	mov    %ebx,%ecx
  801eb0:	e9 62 ff ff ff       	jmp    801e17 <__umoddi3+0xb3>
