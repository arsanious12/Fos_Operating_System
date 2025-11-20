
obj/user/fos_factorial:     file format elf32-i386


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
  800031:	e8 be 00 00 00       	call   8000f4 <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:

int64 factorial(int n);

void
_main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	81 ec 18 01 00 00    	sub    $0x118,%esp
	int i1=0;
  800041:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	char buff1[256];
	atomic_readline("Please enter a number:", buff1);
  800048:	83 ec 08             	sub    $0x8,%esp
  80004b:	8d 85 e8 fe ff ff    	lea    -0x118(%ebp),%eax
  800051:	50                   	push   %eax
  800052:	68 c0 1e 80 00       	push   $0x801ec0
  800057:	e8 15 0b 00 00       	call   800b71 <atomic_readline>
  80005c:	83 c4 10             	add    $0x10,%esp
	i1 = strtol(buff1, NULL, 10);
  80005f:	83 ec 04             	sub    $0x4,%esp
  800062:	6a 0a                	push   $0xa
  800064:	6a 00                	push   $0x0
  800066:	8d 85 e8 fe ff ff    	lea    -0x118(%ebp),%eax
  80006c:	50                   	push   %eax
  80006d:	e8 17 10 00 00       	call   801089 <strtol>
  800072:	83 c4 10             	add    $0x10,%esp
  800075:	89 45 f4             	mov    %eax,-0xc(%ebp)

	int64 res = factorial(i1) ;
  800078:	83 ec 0c             	sub    $0xc,%esp
  80007b:	ff 75 f4             	pushl  -0xc(%ebp)
  80007e:	e8 22 00 00 00       	call   8000a5 <factorial>
  800083:	83 c4 10             	add    $0x10,%esp
  800086:	89 45 e8             	mov    %eax,-0x18(%ebp)
  800089:	89 55 ec             	mov    %edx,-0x14(%ebp)

	atomic_cprintf("Factorial %d = %lld\n",i1, res);
  80008c:	ff 75 ec             	pushl  -0x14(%ebp)
  80008f:	ff 75 e8             	pushl  -0x18(%ebp)
  800092:	ff 75 f4             	pushl  -0xc(%ebp)
  800095:	68 d7 1e 80 00       	push   $0x801ed7
  80009a:	e8 6c 03 00 00       	call   80040b <atomic_cprintf>
  80009f:	83 c4 10             	add    $0x10,%esp
	return;
  8000a2:	90                   	nop
}
  8000a3:	c9                   	leave  
  8000a4:	c3                   	ret    

008000a5 <factorial>:


int64 factorial(int n)
{
  8000a5:	55                   	push   %ebp
  8000a6:	89 e5                	mov    %esp,%ebp
  8000a8:	57                   	push   %edi
  8000a9:	56                   	push   %esi
  8000aa:	53                   	push   %ebx
  8000ab:	83 ec 0c             	sub    $0xc,%esp
	if (n <= 1)
  8000ae:	83 7d 08 01          	cmpl   $0x1,0x8(%ebp)
  8000b2:	7f 0c                	jg     8000c0 <factorial+0x1b>
		return 1 ;
  8000b4:	b8 01 00 00 00       	mov    $0x1,%eax
  8000b9:	ba 00 00 00 00       	mov    $0x0,%edx
  8000be:	eb 2c                	jmp    8000ec <factorial+0x47>
	return n * factorial(n-1) ;
  8000c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8000c3:	89 c3                	mov    %eax,%ebx
  8000c5:	89 c6                	mov    %eax,%esi
  8000c7:	c1 fe 1f             	sar    $0x1f,%esi
  8000ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8000cd:	48                   	dec    %eax
  8000ce:	83 ec 0c             	sub    $0xc,%esp
  8000d1:	50                   	push   %eax
  8000d2:	e8 ce ff ff ff       	call   8000a5 <factorial>
  8000d7:	83 c4 10             	add    $0x10,%esp
  8000da:	89 f7                	mov    %esi,%edi
  8000dc:	0f af f8             	imul   %eax,%edi
  8000df:	89 d1                	mov    %edx,%ecx
  8000e1:	0f af cb             	imul   %ebx,%ecx
  8000e4:	01 f9                	add    %edi,%ecx
  8000e6:	f7 e3                	mul    %ebx
  8000e8:	01 d1                	add    %edx,%ecx
  8000ea:	89 ca                	mov    %ecx,%edx
}
  8000ec:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8000ef:	5b                   	pop    %ebx
  8000f0:	5e                   	pop    %esi
  8000f1:	5f                   	pop    %edi
  8000f2:	5d                   	pop    %ebp
  8000f3:	c3                   	ret    

008000f4 <libmain>:
volatile bool printStats = 1;

volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";
void
libmain(int argc, char **argv)
{
  8000f4:	55                   	push   %ebp
  8000f5:	89 e5                	mov    %esp,%ebp
  8000f7:	57                   	push   %edi
  8000f8:	56                   	push   %esi
  8000f9:	53                   	push   %ebx
  8000fa:	83 ec 7c             	sub    $0x7c,%esp
	//printStats = 1;
	int envIndex = sys_getenvindex();
  8000fd:	e8 6c 16 00 00       	call   80176e <sys_getenvindex>
  800102:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	myEnv = &(envs[envIndex]);
  800105:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800108:	89 d0                	mov    %edx,%eax
  80010a:	c1 e0 06             	shl    $0x6,%eax
  80010d:	29 d0                	sub    %edx,%eax
  80010f:	c1 e0 02             	shl    $0x2,%eax
  800112:	01 d0                	add    %edx,%eax
  800114:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  80011b:	01 c8                	add    %ecx,%eax
  80011d:	c1 e0 03             	shl    $0x3,%eax
  800120:	01 d0                	add    %edx,%eax
  800122:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800129:	29 c2                	sub    %eax,%edx
  80012b:	8d 04 95 00 00 00 00 	lea    0x0(,%edx,4),%eax
  800132:	89 c2                	mov    %eax,%edx
  800134:	8d 82 00 00 c0 ee    	lea    -0x11400000(%edx),%eax
  80013a:	a3 20 30 80 00       	mov    %eax,0x803020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  80013f:	a1 20 30 80 00       	mov    0x803020,%eax
  800144:	8a 40 20             	mov    0x20(%eax),%al
  800147:	84 c0                	test   %al,%al
  800149:	74 0d                	je     800158 <libmain+0x64>
		binaryname = myEnv->prog_name;
  80014b:	a1 20 30 80 00       	mov    0x803020,%eax
  800150:	83 c0 20             	add    $0x20,%eax
  800153:	a3 04 30 80 00       	mov    %eax,0x803004

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800158:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80015c:	7e 0a                	jle    800168 <libmain+0x74>
		binaryname = argv[0];
  80015e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800161:	8b 00                	mov    (%eax),%eax
  800163:	a3 04 30 80 00       	mov    %eax,0x803004

	// call user main routine
	_main(argc, argv);
  800168:	83 ec 08             	sub    $0x8,%esp
  80016b:	ff 75 0c             	pushl  0xc(%ebp)
  80016e:	ff 75 08             	pushl  0x8(%ebp)
  800171:	e8 c2 fe ff ff       	call   800038 <_main>
  800176:	83 c4 10             	add    $0x10,%esp

	if (printStats)
  800179:	a1 00 30 80 00       	mov    0x803000,%eax
  80017e:	85 c0                	test   %eax,%eax
  800180:	0f 84 01 01 00 00    	je     800287 <libmain+0x193>
	{
		char isOPTReplCmd[100] = "__IsOPTRepl__" ;
  800186:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  80018c:	bb e4 1f 80 00       	mov    $0x801fe4,%ebx
  800191:	ba 0e 00 00 00       	mov    $0xe,%edx
  800196:	89 c7                	mov    %eax,%edi
  800198:	89 de                	mov    %ebx,%esi
  80019a:	89 d1                	mov    %edx,%ecx
  80019c:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  80019e:	8d 55 8a             	lea    -0x76(%ebp),%edx
  8001a1:	b9 56 00 00 00       	mov    $0x56,%ecx
  8001a6:	b0 00                	mov    $0x0,%al
  8001a8:	89 d7                	mov    %edx,%edi
  8001aa:	f3 aa                	rep stos %al,%es:(%edi)
		int isOPTRepl = 0;
  8001ac:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
		sys_utilities(isOPTReplCmd, (uint32)(&isOPTRepl));
  8001b3:	8d 45 e0             	lea    -0x20(%ebp),%eax
  8001b6:	83 ec 08             	sub    $0x8,%esp
  8001b9:	50                   	push   %eax
  8001ba:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  8001c0:	50                   	push   %eax
  8001c1:	e8 de 17 00 00       	call   8019a4 <sys_utilities>
  8001c6:	83 c4 10             	add    $0x10,%esp

		sys_lock_cons();
  8001c9:	e8 27 13 00 00       	call   8014f5 <sys_lock_cons>
		{
			cprintf("**************************************\n");
  8001ce:	83 ec 0c             	sub    $0xc,%esp
  8001d1:	68 04 1f 80 00       	push   $0x801f04
  8001d6:	e8 be 01 00 00       	call   800399 <cprintf>
  8001db:	83 c4 10             	add    $0x10,%esp
			if (isOPTRepl)
  8001de:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8001e1:	85 c0                	test   %eax,%eax
  8001e3:	74 18                	je     8001fd <libmain+0x109>
			{
				cprintf("OPTIMAL number of page faults = %d\n", sys_get_optimal_num_faults());
  8001e5:	e8 d8 17 00 00       	call   8019c2 <sys_get_optimal_num_faults>
  8001ea:	83 ec 08             	sub    $0x8,%esp
  8001ed:	50                   	push   %eax
  8001ee:	68 2c 1f 80 00       	push   $0x801f2c
  8001f3:	e8 a1 01 00 00       	call   800399 <cprintf>
  8001f8:	83 c4 10             	add    $0x10,%esp
  8001fb:	eb 59                	jmp    800256 <libmain+0x162>
			}
			else
			{
				cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8001fd:	a1 20 30 80 00       	mov    0x803020,%eax
  800202:	8b 90 50 da 01 00    	mov    0x1da50(%eax),%edx
  800208:	a1 20 30 80 00       	mov    0x803020,%eax
  80020d:	8b 80 40 da 01 00    	mov    0x1da40(%eax),%eax
  800213:	83 ec 04             	sub    $0x4,%esp
  800216:	52                   	push   %edx
  800217:	50                   	push   %eax
  800218:	68 50 1f 80 00       	push   $0x801f50
  80021d:	e8 77 01 00 00       	call   800399 <cprintf>
  800222:	83 c4 10             	add    $0x10,%esp
				cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800225:	a1 20 30 80 00       	mov    0x803020,%eax
  80022a:	8b 88 64 da 01 00    	mov    0x1da64(%eax),%ecx
  800230:	a1 20 30 80 00       	mov    0x803020,%eax
  800235:	8b 90 60 da 01 00    	mov    0x1da60(%eax),%edx
  80023b:	a1 20 30 80 00       	mov    0x803020,%eax
  800240:	8b 80 5c da 01 00    	mov    0x1da5c(%eax),%eax
  800246:	51                   	push   %ecx
  800247:	52                   	push   %edx
  800248:	50                   	push   %eax
  800249:	68 78 1f 80 00       	push   $0x801f78
  80024e:	e8 46 01 00 00       	call   800399 <cprintf>
  800253:	83 c4 10             	add    $0x10,%esp
			}
			//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
			cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800256:	a1 20 30 80 00       	mov    0x803020,%eax
  80025b:	8b 80 68 da 01 00    	mov    0x1da68(%eax),%eax
  800261:	83 ec 08             	sub    $0x8,%esp
  800264:	50                   	push   %eax
  800265:	68 d0 1f 80 00       	push   $0x801fd0
  80026a:	e8 2a 01 00 00       	call   800399 <cprintf>
  80026f:	83 c4 10             	add    $0x10,%esp
			cprintf("**************************************\n");
  800272:	83 ec 0c             	sub    $0xc,%esp
  800275:	68 04 1f 80 00       	push   $0x801f04
  80027a:	e8 1a 01 00 00       	call   800399 <cprintf>
  80027f:	83 c4 10             	add    $0x10,%esp
		}
		sys_unlock_cons();
  800282:	e8 88 12 00 00       	call   80150f <sys_unlock_cons>
	}

	// exit gracefully
	exit();
  800287:	e8 1f 00 00 00       	call   8002ab <exit>
}
  80028c:	90                   	nop
  80028d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800290:	5b                   	pop    %ebx
  800291:	5e                   	pop    %esi
  800292:	5f                   	pop    %edi
  800293:	5d                   	pop    %ebp
  800294:	c3                   	ret    

00800295 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800295:	55                   	push   %ebp
  800296:	89 e5                	mov    %esp,%ebp
  800298:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  80029b:	83 ec 0c             	sub    $0xc,%esp
  80029e:	6a 00                	push   $0x0
  8002a0:	e8 95 14 00 00       	call   80173a <sys_destroy_env>
  8002a5:	83 c4 10             	add    $0x10,%esp
}
  8002a8:	90                   	nop
  8002a9:	c9                   	leave  
  8002aa:	c3                   	ret    

008002ab <exit>:

void
exit(void)
{
  8002ab:	55                   	push   %ebp
  8002ac:	89 e5                	mov    %esp,%ebp
  8002ae:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  8002b1:	e8 ea 14 00 00       	call   8017a0 <sys_exit_env>
}
  8002b6:	90                   	nop
  8002b7:	c9                   	leave  
  8002b8:	c3                   	ret    

008002b9 <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  8002b9:	55                   	push   %ebp
  8002ba:	89 e5                	mov    %esp,%ebp
  8002bc:	53                   	push   %ebx
  8002bd:	83 ec 04             	sub    $0x4,%esp
	b->buf[b->idx++] = ch;
  8002c0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8002c3:	8b 00                	mov    (%eax),%eax
  8002c5:	8d 48 01             	lea    0x1(%eax),%ecx
  8002c8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8002cb:	89 0a                	mov    %ecx,(%edx)
  8002cd:	8b 55 08             	mov    0x8(%ebp),%edx
  8002d0:	88 d1                	mov    %dl,%cl
  8002d2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8002d5:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  8002d9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8002dc:	8b 00                	mov    (%eax),%eax
  8002de:	3d ff 00 00 00       	cmp    $0xff,%eax
  8002e3:	75 30                	jne    800315 <putch+0x5c>
		sys_cputs(b->buf, b->idx, printProgName, curTextClr);
  8002e5:	8b 15 18 b1 81 00    	mov    0x81b118,%edx
  8002eb:	a0 44 30 80 00       	mov    0x803044,%al
  8002f0:	0f b6 c0             	movzbl %al,%eax
  8002f3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8002f6:	8b 09                	mov    (%ecx),%ecx
  8002f8:	89 cb                	mov    %ecx,%ebx
  8002fa:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8002fd:	83 c1 08             	add    $0x8,%ecx
  800300:	52                   	push   %edx
  800301:	50                   	push   %eax
  800302:	53                   	push   %ebx
  800303:	51                   	push   %ecx
  800304:	e8 a8 11 00 00       	call   8014b1 <sys_cputs>
  800309:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  80030c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80030f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800315:	8b 45 0c             	mov    0xc(%ebp),%eax
  800318:	8b 40 04             	mov    0x4(%eax),%eax
  80031b:	8d 50 01             	lea    0x1(%eax),%edx
  80031e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800321:	89 50 04             	mov    %edx,0x4(%eax)
}
  800324:	90                   	nop
  800325:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800328:	c9                   	leave  
  800329:	c3                   	ret    

0080032a <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  80032a:	55                   	push   %ebp
  80032b:	89 e5                	mov    %esp,%ebp
  80032d:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800333:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80033a:	00 00 00 
	b.cnt = 0;
  80033d:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800344:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800347:	ff 75 0c             	pushl  0xc(%ebp)
  80034a:	ff 75 08             	pushl  0x8(%ebp)
  80034d:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800353:	50                   	push   %eax
  800354:	68 b9 02 80 00       	push   $0x8002b9
  800359:	e8 5a 02 00 00       	call   8005b8 <vprintfmt>
  80035e:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName, curTextClr);
  800361:	8b 15 18 b1 81 00    	mov    0x81b118,%edx
  800367:	a0 44 30 80 00       	mov    0x803044,%al
  80036c:	0f b6 c0             	movzbl %al,%eax
  80036f:	8b 8d f0 fe ff ff    	mov    -0x110(%ebp),%ecx
  800375:	52                   	push   %edx
  800376:	50                   	push   %eax
  800377:	51                   	push   %ecx
  800378:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80037e:	83 c0 08             	add    $0x8,%eax
  800381:	50                   	push   %eax
  800382:	e8 2a 11 00 00       	call   8014b1 <sys_cputs>
  800387:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  80038a:	c6 05 44 30 80 00 00 	movb   $0x0,0x803044
	return b.cnt;
  800391:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800397:	c9                   	leave  
  800398:	c3                   	ret    

00800399 <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  800399:	55                   	push   %ebp
  80039a:	89 e5                	mov    %esp,%ebp
  80039c:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  80039f:	c6 05 44 30 80 00 01 	movb   $0x1,0x803044
	va_start(ap, fmt);
  8003a6:	8d 45 0c             	lea    0xc(%ebp),%eax
  8003a9:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8003ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8003af:	83 ec 08             	sub    $0x8,%esp
  8003b2:	ff 75 f4             	pushl  -0xc(%ebp)
  8003b5:	50                   	push   %eax
  8003b6:	e8 6f ff ff ff       	call   80032a <vcprintf>
  8003bb:	83 c4 10             	add    $0x10,%esp
  8003be:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  8003c1:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8003c4:	c9                   	leave  
  8003c5:	c3                   	ret    

008003c6 <cprintf_colored>:

// *************** This text coloring feature is implemented by *************
// ********** Abd-Alrahman Zedan From Team Frozen-Bytes - FCIS'24-25 ********
int cprintf_colored(int textClr, const char *fmt, ...) {
  8003c6:	55                   	push   %ebp
  8003c7:	89 e5                	mov    %esp,%ebp
  8003c9:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  8003cc:	c6 05 44 30 80 00 01 	movb   $0x1,0x803044
	curTextClr = (textClr << 8) ; //set text color by the given value
  8003d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8003d6:	c1 e0 08             	shl    $0x8,%eax
  8003d9:	a3 18 b1 81 00       	mov    %eax,0x81b118
	va_start(ap, fmt);
  8003de:	8d 45 0c             	lea    0xc(%ebp),%eax
  8003e1:	83 c0 04             	add    $0x4,%eax
  8003e4:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8003e7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003ea:	83 ec 08             	sub    $0x8,%esp
  8003ed:	ff 75 f4             	pushl  -0xc(%ebp)
  8003f0:	50                   	push   %eax
  8003f1:	e8 34 ff ff ff       	call   80032a <vcprintf>
  8003f6:	83 c4 10             	add    $0x10,%esp
  8003f9:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);
	curTextClr = TEXT_DEFAULT_CLR; //restore default color
  8003fc:	c7 05 18 b1 81 00 00 	movl   $0x700,0x81b118
  800403:	07 00 00 

	return cnt;
  800406:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800409:	c9                   	leave  
  80040a:	c3                   	ret    

0080040b <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  80040b:	55                   	push   %ebp
  80040c:	89 e5                	mov    %esp,%ebp
  80040e:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  800411:	e8 df 10 00 00       	call   8014f5 <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  800416:	8d 45 0c             	lea    0xc(%ebp),%eax
  800419:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  80041c:	8b 45 08             	mov    0x8(%ebp),%eax
  80041f:	83 ec 08             	sub    $0x8,%esp
  800422:	ff 75 f4             	pushl  -0xc(%ebp)
  800425:	50                   	push   %eax
  800426:	e8 ff fe ff ff       	call   80032a <vcprintf>
  80042b:	83 c4 10             	add    $0x10,%esp
  80042e:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  800431:	e8 d9 10 00 00       	call   80150f <sys_unlock_cons>
	return cnt;
  800436:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800439:	c9                   	leave  
  80043a:	c3                   	ret    

0080043b <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  80043b:	55                   	push   %ebp
  80043c:	89 e5                	mov    %esp,%ebp
  80043e:	53                   	push   %ebx
  80043f:	83 ec 14             	sub    $0x14,%esp
  800442:	8b 45 10             	mov    0x10(%ebp),%eax
  800445:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800448:	8b 45 14             	mov    0x14(%ebp),%eax
  80044b:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  80044e:	8b 45 18             	mov    0x18(%ebp),%eax
  800451:	ba 00 00 00 00       	mov    $0x0,%edx
  800456:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800459:	77 55                	ja     8004b0 <printnum+0x75>
  80045b:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  80045e:	72 05                	jb     800465 <printnum+0x2a>
  800460:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800463:	77 4b                	ja     8004b0 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800465:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800468:	8d 58 ff             	lea    -0x1(%eax),%ebx
  80046b:	8b 45 18             	mov    0x18(%ebp),%eax
  80046e:	ba 00 00 00 00       	mov    $0x0,%edx
  800473:	52                   	push   %edx
  800474:	50                   	push   %eax
  800475:	ff 75 f4             	pushl  -0xc(%ebp)
  800478:	ff 75 f0             	pushl  -0x10(%ebp)
  80047b:	e8 dc 17 00 00       	call   801c5c <__udivdi3>
  800480:	83 c4 10             	add    $0x10,%esp
  800483:	83 ec 04             	sub    $0x4,%esp
  800486:	ff 75 20             	pushl  0x20(%ebp)
  800489:	53                   	push   %ebx
  80048a:	ff 75 18             	pushl  0x18(%ebp)
  80048d:	52                   	push   %edx
  80048e:	50                   	push   %eax
  80048f:	ff 75 0c             	pushl  0xc(%ebp)
  800492:	ff 75 08             	pushl  0x8(%ebp)
  800495:	e8 a1 ff ff ff       	call   80043b <printnum>
  80049a:	83 c4 20             	add    $0x20,%esp
  80049d:	eb 1a                	jmp    8004b9 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  80049f:	83 ec 08             	sub    $0x8,%esp
  8004a2:	ff 75 0c             	pushl  0xc(%ebp)
  8004a5:	ff 75 20             	pushl  0x20(%ebp)
  8004a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8004ab:	ff d0                	call   *%eax
  8004ad:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8004b0:	ff 4d 1c             	decl   0x1c(%ebp)
  8004b3:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  8004b7:	7f e6                	jg     80049f <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8004b9:	8b 4d 18             	mov    0x18(%ebp),%ecx
  8004bc:	bb 00 00 00 00       	mov    $0x0,%ebx
  8004c1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8004c4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8004c7:	53                   	push   %ebx
  8004c8:	51                   	push   %ecx
  8004c9:	52                   	push   %edx
  8004ca:	50                   	push   %eax
  8004cb:	e8 9c 18 00 00       	call   801d6c <__umoddi3>
  8004d0:	83 c4 10             	add    $0x10,%esp
  8004d3:	05 74 22 80 00       	add    $0x802274,%eax
  8004d8:	8a 00                	mov    (%eax),%al
  8004da:	0f be c0             	movsbl %al,%eax
  8004dd:	83 ec 08             	sub    $0x8,%esp
  8004e0:	ff 75 0c             	pushl  0xc(%ebp)
  8004e3:	50                   	push   %eax
  8004e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8004e7:	ff d0                	call   *%eax
  8004e9:	83 c4 10             	add    $0x10,%esp
}
  8004ec:	90                   	nop
  8004ed:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8004f0:	c9                   	leave  
  8004f1:	c3                   	ret    

008004f2 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8004f2:	55                   	push   %ebp
  8004f3:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8004f5:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8004f9:	7e 1c                	jle    800517 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  8004fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8004fe:	8b 00                	mov    (%eax),%eax
  800500:	8d 50 08             	lea    0x8(%eax),%edx
  800503:	8b 45 08             	mov    0x8(%ebp),%eax
  800506:	89 10                	mov    %edx,(%eax)
  800508:	8b 45 08             	mov    0x8(%ebp),%eax
  80050b:	8b 00                	mov    (%eax),%eax
  80050d:	83 e8 08             	sub    $0x8,%eax
  800510:	8b 50 04             	mov    0x4(%eax),%edx
  800513:	8b 00                	mov    (%eax),%eax
  800515:	eb 40                	jmp    800557 <getuint+0x65>
	else if (lflag)
  800517:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80051b:	74 1e                	je     80053b <getuint+0x49>
		return va_arg(*ap, unsigned long);
  80051d:	8b 45 08             	mov    0x8(%ebp),%eax
  800520:	8b 00                	mov    (%eax),%eax
  800522:	8d 50 04             	lea    0x4(%eax),%edx
  800525:	8b 45 08             	mov    0x8(%ebp),%eax
  800528:	89 10                	mov    %edx,(%eax)
  80052a:	8b 45 08             	mov    0x8(%ebp),%eax
  80052d:	8b 00                	mov    (%eax),%eax
  80052f:	83 e8 04             	sub    $0x4,%eax
  800532:	8b 00                	mov    (%eax),%eax
  800534:	ba 00 00 00 00       	mov    $0x0,%edx
  800539:	eb 1c                	jmp    800557 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  80053b:	8b 45 08             	mov    0x8(%ebp),%eax
  80053e:	8b 00                	mov    (%eax),%eax
  800540:	8d 50 04             	lea    0x4(%eax),%edx
  800543:	8b 45 08             	mov    0x8(%ebp),%eax
  800546:	89 10                	mov    %edx,(%eax)
  800548:	8b 45 08             	mov    0x8(%ebp),%eax
  80054b:	8b 00                	mov    (%eax),%eax
  80054d:	83 e8 04             	sub    $0x4,%eax
  800550:	8b 00                	mov    (%eax),%eax
  800552:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800557:	5d                   	pop    %ebp
  800558:	c3                   	ret    

00800559 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800559:	55                   	push   %ebp
  80055a:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  80055c:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800560:	7e 1c                	jle    80057e <getint+0x25>
		return va_arg(*ap, long long);
  800562:	8b 45 08             	mov    0x8(%ebp),%eax
  800565:	8b 00                	mov    (%eax),%eax
  800567:	8d 50 08             	lea    0x8(%eax),%edx
  80056a:	8b 45 08             	mov    0x8(%ebp),%eax
  80056d:	89 10                	mov    %edx,(%eax)
  80056f:	8b 45 08             	mov    0x8(%ebp),%eax
  800572:	8b 00                	mov    (%eax),%eax
  800574:	83 e8 08             	sub    $0x8,%eax
  800577:	8b 50 04             	mov    0x4(%eax),%edx
  80057a:	8b 00                	mov    (%eax),%eax
  80057c:	eb 38                	jmp    8005b6 <getint+0x5d>
	else if (lflag)
  80057e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800582:	74 1a                	je     80059e <getint+0x45>
		return va_arg(*ap, long);
  800584:	8b 45 08             	mov    0x8(%ebp),%eax
  800587:	8b 00                	mov    (%eax),%eax
  800589:	8d 50 04             	lea    0x4(%eax),%edx
  80058c:	8b 45 08             	mov    0x8(%ebp),%eax
  80058f:	89 10                	mov    %edx,(%eax)
  800591:	8b 45 08             	mov    0x8(%ebp),%eax
  800594:	8b 00                	mov    (%eax),%eax
  800596:	83 e8 04             	sub    $0x4,%eax
  800599:	8b 00                	mov    (%eax),%eax
  80059b:	99                   	cltd   
  80059c:	eb 18                	jmp    8005b6 <getint+0x5d>
	else
		return va_arg(*ap, int);
  80059e:	8b 45 08             	mov    0x8(%ebp),%eax
  8005a1:	8b 00                	mov    (%eax),%eax
  8005a3:	8d 50 04             	lea    0x4(%eax),%edx
  8005a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8005a9:	89 10                	mov    %edx,(%eax)
  8005ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8005ae:	8b 00                	mov    (%eax),%eax
  8005b0:	83 e8 04             	sub    $0x4,%eax
  8005b3:	8b 00                	mov    (%eax),%eax
  8005b5:	99                   	cltd   
}
  8005b6:	5d                   	pop    %ebp
  8005b7:	c3                   	ret    

008005b8 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8005b8:	55                   	push   %ebp
  8005b9:	89 e5                	mov    %esp,%ebp
  8005bb:	56                   	push   %esi
  8005bc:	53                   	push   %ebx
  8005bd:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8005c0:	eb 17                	jmp    8005d9 <vprintfmt+0x21>
			if (ch == '\0')
  8005c2:	85 db                	test   %ebx,%ebx
  8005c4:	0f 84 c1 03 00 00    	je     80098b <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  8005ca:	83 ec 08             	sub    $0x8,%esp
  8005cd:	ff 75 0c             	pushl  0xc(%ebp)
  8005d0:	53                   	push   %ebx
  8005d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8005d4:	ff d0                	call   *%eax
  8005d6:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8005d9:	8b 45 10             	mov    0x10(%ebp),%eax
  8005dc:	8d 50 01             	lea    0x1(%eax),%edx
  8005df:	89 55 10             	mov    %edx,0x10(%ebp)
  8005e2:	8a 00                	mov    (%eax),%al
  8005e4:	0f b6 d8             	movzbl %al,%ebx
  8005e7:	83 fb 25             	cmp    $0x25,%ebx
  8005ea:	75 d6                	jne    8005c2 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  8005ec:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  8005f0:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  8005f7:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8005fe:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800605:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80060c:	8b 45 10             	mov    0x10(%ebp),%eax
  80060f:	8d 50 01             	lea    0x1(%eax),%edx
  800612:	89 55 10             	mov    %edx,0x10(%ebp)
  800615:	8a 00                	mov    (%eax),%al
  800617:	0f b6 d8             	movzbl %al,%ebx
  80061a:	8d 43 dd             	lea    -0x23(%ebx),%eax
  80061d:	83 f8 5b             	cmp    $0x5b,%eax
  800620:	0f 87 3d 03 00 00    	ja     800963 <vprintfmt+0x3ab>
  800626:	8b 04 85 98 22 80 00 	mov    0x802298(,%eax,4),%eax
  80062d:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  80062f:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800633:	eb d7                	jmp    80060c <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800635:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800639:	eb d1                	jmp    80060c <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  80063b:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800642:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800645:	89 d0                	mov    %edx,%eax
  800647:	c1 e0 02             	shl    $0x2,%eax
  80064a:	01 d0                	add    %edx,%eax
  80064c:	01 c0                	add    %eax,%eax
  80064e:	01 d8                	add    %ebx,%eax
  800650:	83 e8 30             	sub    $0x30,%eax
  800653:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800656:	8b 45 10             	mov    0x10(%ebp),%eax
  800659:	8a 00                	mov    (%eax),%al
  80065b:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  80065e:	83 fb 2f             	cmp    $0x2f,%ebx
  800661:	7e 3e                	jle    8006a1 <vprintfmt+0xe9>
  800663:	83 fb 39             	cmp    $0x39,%ebx
  800666:	7f 39                	jg     8006a1 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800668:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  80066b:	eb d5                	jmp    800642 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  80066d:	8b 45 14             	mov    0x14(%ebp),%eax
  800670:	83 c0 04             	add    $0x4,%eax
  800673:	89 45 14             	mov    %eax,0x14(%ebp)
  800676:	8b 45 14             	mov    0x14(%ebp),%eax
  800679:	83 e8 04             	sub    $0x4,%eax
  80067c:	8b 00                	mov    (%eax),%eax
  80067e:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800681:	eb 1f                	jmp    8006a2 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800683:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800687:	79 83                	jns    80060c <vprintfmt+0x54>
				width = 0;
  800689:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800690:	e9 77 ff ff ff       	jmp    80060c <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800695:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  80069c:	e9 6b ff ff ff       	jmp    80060c <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  8006a1:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  8006a2:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8006a6:	0f 89 60 ff ff ff    	jns    80060c <vprintfmt+0x54>
				width = precision, precision = -1;
  8006ac:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8006af:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8006b2:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  8006b9:	e9 4e ff ff ff       	jmp    80060c <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  8006be:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  8006c1:	e9 46 ff ff ff       	jmp    80060c <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  8006c6:	8b 45 14             	mov    0x14(%ebp),%eax
  8006c9:	83 c0 04             	add    $0x4,%eax
  8006cc:	89 45 14             	mov    %eax,0x14(%ebp)
  8006cf:	8b 45 14             	mov    0x14(%ebp),%eax
  8006d2:	83 e8 04             	sub    $0x4,%eax
  8006d5:	8b 00                	mov    (%eax),%eax
  8006d7:	83 ec 08             	sub    $0x8,%esp
  8006da:	ff 75 0c             	pushl  0xc(%ebp)
  8006dd:	50                   	push   %eax
  8006de:	8b 45 08             	mov    0x8(%ebp),%eax
  8006e1:	ff d0                	call   *%eax
  8006e3:	83 c4 10             	add    $0x10,%esp
			break;
  8006e6:	e9 9b 02 00 00       	jmp    800986 <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  8006eb:	8b 45 14             	mov    0x14(%ebp),%eax
  8006ee:	83 c0 04             	add    $0x4,%eax
  8006f1:	89 45 14             	mov    %eax,0x14(%ebp)
  8006f4:	8b 45 14             	mov    0x14(%ebp),%eax
  8006f7:	83 e8 04             	sub    $0x4,%eax
  8006fa:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  8006fc:	85 db                	test   %ebx,%ebx
  8006fe:	79 02                	jns    800702 <vprintfmt+0x14a>
				err = -err;
  800700:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800702:	83 fb 64             	cmp    $0x64,%ebx
  800705:	7f 0b                	jg     800712 <vprintfmt+0x15a>
  800707:	8b 34 9d e0 20 80 00 	mov    0x8020e0(,%ebx,4),%esi
  80070e:	85 f6                	test   %esi,%esi
  800710:	75 19                	jne    80072b <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800712:	53                   	push   %ebx
  800713:	68 85 22 80 00       	push   $0x802285
  800718:	ff 75 0c             	pushl  0xc(%ebp)
  80071b:	ff 75 08             	pushl  0x8(%ebp)
  80071e:	e8 70 02 00 00       	call   800993 <printfmt>
  800723:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800726:	e9 5b 02 00 00       	jmp    800986 <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  80072b:	56                   	push   %esi
  80072c:	68 8e 22 80 00       	push   $0x80228e
  800731:	ff 75 0c             	pushl  0xc(%ebp)
  800734:	ff 75 08             	pushl  0x8(%ebp)
  800737:	e8 57 02 00 00       	call   800993 <printfmt>
  80073c:	83 c4 10             	add    $0x10,%esp
			break;
  80073f:	e9 42 02 00 00       	jmp    800986 <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800744:	8b 45 14             	mov    0x14(%ebp),%eax
  800747:	83 c0 04             	add    $0x4,%eax
  80074a:	89 45 14             	mov    %eax,0x14(%ebp)
  80074d:	8b 45 14             	mov    0x14(%ebp),%eax
  800750:	83 e8 04             	sub    $0x4,%eax
  800753:	8b 30                	mov    (%eax),%esi
  800755:	85 f6                	test   %esi,%esi
  800757:	75 05                	jne    80075e <vprintfmt+0x1a6>
				p = "(null)";
  800759:	be 91 22 80 00       	mov    $0x802291,%esi
			if (width > 0 && padc != '-')
  80075e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800762:	7e 6d                	jle    8007d1 <vprintfmt+0x219>
  800764:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800768:	74 67                	je     8007d1 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  80076a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80076d:	83 ec 08             	sub    $0x8,%esp
  800770:	50                   	push   %eax
  800771:	56                   	push   %esi
  800772:	e8 26 05 00 00       	call   800c9d <strnlen>
  800777:	83 c4 10             	add    $0x10,%esp
  80077a:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  80077d:	eb 16                	jmp    800795 <vprintfmt+0x1dd>
					putch(padc, putdat);
  80077f:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800783:	83 ec 08             	sub    $0x8,%esp
  800786:	ff 75 0c             	pushl  0xc(%ebp)
  800789:	50                   	push   %eax
  80078a:	8b 45 08             	mov    0x8(%ebp),%eax
  80078d:	ff d0                	call   *%eax
  80078f:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800792:	ff 4d e4             	decl   -0x1c(%ebp)
  800795:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800799:	7f e4                	jg     80077f <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80079b:	eb 34                	jmp    8007d1 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  80079d:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8007a1:	74 1c                	je     8007bf <vprintfmt+0x207>
  8007a3:	83 fb 1f             	cmp    $0x1f,%ebx
  8007a6:	7e 05                	jle    8007ad <vprintfmt+0x1f5>
  8007a8:	83 fb 7e             	cmp    $0x7e,%ebx
  8007ab:	7e 12                	jle    8007bf <vprintfmt+0x207>
					putch('?', putdat);
  8007ad:	83 ec 08             	sub    $0x8,%esp
  8007b0:	ff 75 0c             	pushl  0xc(%ebp)
  8007b3:	6a 3f                	push   $0x3f
  8007b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8007b8:	ff d0                	call   *%eax
  8007ba:	83 c4 10             	add    $0x10,%esp
  8007bd:	eb 0f                	jmp    8007ce <vprintfmt+0x216>
				else
					putch(ch, putdat);
  8007bf:	83 ec 08             	sub    $0x8,%esp
  8007c2:	ff 75 0c             	pushl  0xc(%ebp)
  8007c5:	53                   	push   %ebx
  8007c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8007c9:	ff d0                	call   *%eax
  8007cb:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8007ce:	ff 4d e4             	decl   -0x1c(%ebp)
  8007d1:	89 f0                	mov    %esi,%eax
  8007d3:	8d 70 01             	lea    0x1(%eax),%esi
  8007d6:	8a 00                	mov    (%eax),%al
  8007d8:	0f be d8             	movsbl %al,%ebx
  8007db:	85 db                	test   %ebx,%ebx
  8007dd:	74 24                	je     800803 <vprintfmt+0x24b>
  8007df:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8007e3:	78 b8                	js     80079d <vprintfmt+0x1e5>
  8007e5:	ff 4d e0             	decl   -0x20(%ebp)
  8007e8:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8007ec:	79 af                	jns    80079d <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8007ee:	eb 13                	jmp    800803 <vprintfmt+0x24b>
				putch(' ', putdat);
  8007f0:	83 ec 08             	sub    $0x8,%esp
  8007f3:	ff 75 0c             	pushl  0xc(%ebp)
  8007f6:	6a 20                	push   $0x20
  8007f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8007fb:	ff d0                	call   *%eax
  8007fd:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800800:	ff 4d e4             	decl   -0x1c(%ebp)
  800803:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800807:	7f e7                	jg     8007f0 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800809:	e9 78 01 00 00       	jmp    800986 <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  80080e:	83 ec 08             	sub    $0x8,%esp
  800811:	ff 75 e8             	pushl  -0x18(%ebp)
  800814:	8d 45 14             	lea    0x14(%ebp),%eax
  800817:	50                   	push   %eax
  800818:	e8 3c fd ff ff       	call   800559 <getint>
  80081d:	83 c4 10             	add    $0x10,%esp
  800820:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800823:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800826:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800829:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80082c:	85 d2                	test   %edx,%edx
  80082e:	79 23                	jns    800853 <vprintfmt+0x29b>
				putch('-', putdat);
  800830:	83 ec 08             	sub    $0x8,%esp
  800833:	ff 75 0c             	pushl  0xc(%ebp)
  800836:	6a 2d                	push   $0x2d
  800838:	8b 45 08             	mov    0x8(%ebp),%eax
  80083b:	ff d0                	call   *%eax
  80083d:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800840:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800843:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800846:	f7 d8                	neg    %eax
  800848:	83 d2 00             	adc    $0x0,%edx
  80084b:	f7 da                	neg    %edx
  80084d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800850:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800853:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  80085a:	e9 bc 00 00 00       	jmp    80091b <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  80085f:	83 ec 08             	sub    $0x8,%esp
  800862:	ff 75 e8             	pushl  -0x18(%ebp)
  800865:	8d 45 14             	lea    0x14(%ebp),%eax
  800868:	50                   	push   %eax
  800869:	e8 84 fc ff ff       	call   8004f2 <getuint>
  80086e:	83 c4 10             	add    $0x10,%esp
  800871:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800874:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800877:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  80087e:	e9 98 00 00 00       	jmp    80091b <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800883:	83 ec 08             	sub    $0x8,%esp
  800886:	ff 75 0c             	pushl  0xc(%ebp)
  800889:	6a 58                	push   $0x58
  80088b:	8b 45 08             	mov    0x8(%ebp),%eax
  80088e:	ff d0                	call   *%eax
  800890:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800893:	83 ec 08             	sub    $0x8,%esp
  800896:	ff 75 0c             	pushl  0xc(%ebp)
  800899:	6a 58                	push   $0x58
  80089b:	8b 45 08             	mov    0x8(%ebp),%eax
  80089e:	ff d0                	call   *%eax
  8008a0:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  8008a3:	83 ec 08             	sub    $0x8,%esp
  8008a6:	ff 75 0c             	pushl  0xc(%ebp)
  8008a9:	6a 58                	push   $0x58
  8008ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8008ae:	ff d0                	call   *%eax
  8008b0:	83 c4 10             	add    $0x10,%esp
			break;
  8008b3:	e9 ce 00 00 00       	jmp    800986 <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  8008b8:	83 ec 08             	sub    $0x8,%esp
  8008bb:	ff 75 0c             	pushl  0xc(%ebp)
  8008be:	6a 30                	push   $0x30
  8008c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8008c3:	ff d0                	call   *%eax
  8008c5:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  8008c8:	83 ec 08             	sub    $0x8,%esp
  8008cb:	ff 75 0c             	pushl  0xc(%ebp)
  8008ce:	6a 78                	push   $0x78
  8008d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8008d3:	ff d0                	call   *%eax
  8008d5:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  8008d8:	8b 45 14             	mov    0x14(%ebp),%eax
  8008db:	83 c0 04             	add    $0x4,%eax
  8008de:	89 45 14             	mov    %eax,0x14(%ebp)
  8008e1:	8b 45 14             	mov    0x14(%ebp),%eax
  8008e4:	83 e8 04             	sub    $0x4,%eax
  8008e7:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  8008e9:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8008ec:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  8008f3:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  8008fa:	eb 1f                	jmp    80091b <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  8008fc:	83 ec 08             	sub    $0x8,%esp
  8008ff:	ff 75 e8             	pushl  -0x18(%ebp)
  800902:	8d 45 14             	lea    0x14(%ebp),%eax
  800905:	50                   	push   %eax
  800906:	e8 e7 fb ff ff       	call   8004f2 <getuint>
  80090b:	83 c4 10             	add    $0x10,%esp
  80090e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800911:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800914:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  80091b:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  80091f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800922:	83 ec 04             	sub    $0x4,%esp
  800925:	52                   	push   %edx
  800926:	ff 75 e4             	pushl  -0x1c(%ebp)
  800929:	50                   	push   %eax
  80092a:	ff 75 f4             	pushl  -0xc(%ebp)
  80092d:	ff 75 f0             	pushl  -0x10(%ebp)
  800930:	ff 75 0c             	pushl  0xc(%ebp)
  800933:	ff 75 08             	pushl  0x8(%ebp)
  800936:	e8 00 fb ff ff       	call   80043b <printnum>
  80093b:	83 c4 20             	add    $0x20,%esp
			break;
  80093e:	eb 46                	jmp    800986 <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800940:	83 ec 08             	sub    $0x8,%esp
  800943:	ff 75 0c             	pushl  0xc(%ebp)
  800946:	53                   	push   %ebx
  800947:	8b 45 08             	mov    0x8(%ebp),%eax
  80094a:	ff d0                	call   *%eax
  80094c:	83 c4 10             	add    $0x10,%esp
			break;
  80094f:	eb 35                	jmp    800986 <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  800951:	c6 05 44 30 80 00 00 	movb   $0x0,0x803044
			break;
  800958:	eb 2c                	jmp    800986 <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  80095a:	c6 05 44 30 80 00 01 	movb   $0x1,0x803044
			break;
  800961:	eb 23                	jmp    800986 <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800963:	83 ec 08             	sub    $0x8,%esp
  800966:	ff 75 0c             	pushl  0xc(%ebp)
  800969:	6a 25                	push   $0x25
  80096b:	8b 45 08             	mov    0x8(%ebp),%eax
  80096e:	ff d0                	call   *%eax
  800970:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800973:	ff 4d 10             	decl   0x10(%ebp)
  800976:	eb 03                	jmp    80097b <vprintfmt+0x3c3>
  800978:	ff 4d 10             	decl   0x10(%ebp)
  80097b:	8b 45 10             	mov    0x10(%ebp),%eax
  80097e:	48                   	dec    %eax
  80097f:	8a 00                	mov    (%eax),%al
  800981:	3c 25                	cmp    $0x25,%al
  800983:	75 f3                	jne    800978 <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  800985:	90                   	nop
		}
	}
  800986:	e9 35 fc ff ff       	jmp    8005c0 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  80098b:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  80098c:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80098f:	5b                   	pop    %ebx
  800990:	5e                   	pop    %esi
  800991:	5d                   	pop    %ebp
  800992:	c3                   	ret    

00800993 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800993:	55                   	push   %ebp
  800994:	89 e5                	mov    %esp,%ebp
  800996:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800999:	8d 45 10             	lea    0x10(%ebp),%eax
  80099c:	83 c0 04             	add    $0x4,%eax
  80099f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  8009a2:	8b 45 10             	mov    0x10(%ebp),%eax
  8009a5:	ff 75 f4             	pushl  -0xc(%ebp)
  8009a8:	50                   	push   %eax
  8009a9:	ff 75 0c             	pushl  0xc(%ebp)
  8009ac:	ff 75 08             	pushl  0x8(%ebp)
  8009af:	e8 04 fc ff ff       	call   8005b8 <vprintfmt>
  8009b4:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  8009b7:	90                   	nop
  8009b8:	c9                   	leave  
  8009b9:	c3                   	ret    

008009ba <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8009ba:	55                   	push   %ebp
  8009bb:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  8009bd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009c0:	8b 40 08             	mov    0x8(%eax),%eax
  8009c3:	8d 50 01             	lea    0x1(%eax),%edx
  8009c6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009c9:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  8009cc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009cf:	8b 10                	mov    (%eax),%edx
  8009d1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009d4:	8b 40 04             	mov    0x4(%eax),%eax
  8009d7:	39 c2                	cmp    %eax,%edx
  8009d9:	73 12                	jae    8009ed <sprintputch+0x33>
		*b->buf++ = ch;
  8009db:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009de:	8b 00                	mov    (%eax),%eax
  8009e0:	8d 48 01             	lea    0x1(%eax),%ecx
  8009e3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8009e6:	89 0a                	mov    %ecx,(%edx)
  8009e8:	8b 55 08             	mov    0x8(%ebp),%edx
  8009eb:	88 10                	mov    %dl,(%eax)
}
  8009ed:	90                   	nop
  8009ee:	5d                   	pop    %ebp
  8009ef:	c3                   	ret    

008009f0 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8009f0:	55                   	push   %ebp
  8009f1:	89 e5                	mov    %esp,%ebp
  8009f3:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  8009f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8009f9:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8009fc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009ff:	8d 50 ff             	lea    -0x1(%eax),%edx
  800a02:	8b 45 08             	mov    0x8(%ebp),%eax
  800a05:	01 d0                	add    %edx,%eax
  800a07:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a0a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800a11:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800a15:	74 06                	je     800a1d <vsnprintf+0x2d>
  800a17:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800a1b:	7f 07                	jg     800a24 <vsnprintf+0x34>
		return -E_INVAL;
  800a1d:	b8 03 00 00 00       	mov    $0x3,%eax
  800a22:	eb 20                	jmp    800a44 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800a24:	ff 75 14             	pushl  0x14(%ebp)
  800a27:	ff 75 10             	pushl  0x10(%ebp)
  800a2a:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800a2d:	50                   	push   %eax
  800a2e:	68 ba 09 80 00       	push   $0x8009ba
  800a33:	e8 80 fb ff ff       	call   8005b8 <vprintfmt>
  800a38:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800a3b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800a3e:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800a41:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800a44:	c9                   	leave  
  800a45:	c3                   	ret    

00800a46 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800a46:	55                   	push   %ebp
  800a47:	89 e5                	mov    %esp,%ebp
  800a49:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800a4c:	8d 45 10             	lea    0x10(%ebp),%eax
  800a4f:	83 c0 04             	add    $0x4,%eax
  800a52:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800a55:	8b 45 10             	mov    0x10(%ebp),%eax
  800a58:	ff 75 f4             	pushl  -0xc(%ebp)
  800a5b:	50                   	push   %eax
  800a5c:	ff 75 0c             	pushl  0xc(%ebp)
  800a5f:	ff 75 08             	pushl  0x8(%ebp)
  800a62:	e8 89 ff ff ff       	call   8009f0 <vsnprintf>
  800a67:	83 c4 10             	add    $0x10,%esp
  800a6a:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800a6d:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800a70:	c9                   	leave  
  800a71:	c3                   	ret    

00800a72 <readline>:
#include <inc/lib.h>

//static char buf[BUFLEN];

void readline(const char *prompt, char* buf)
{
  800a72:	55                   	push   %ebp
  800a73:	89 e5                	mov    %esp,%ebp
  800a75:	83 ec 18             	sub    $0x18,%esp
	int i, c, echoing;

	if (prompt != NULL)
  800a78:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800a7c:	74 13                	je     800a91 <readline+0x1f>
		cprintf("%s", prompt);
  800a7e:	83 ec 08             	sub    $0x8,%esp
  800a81:	ff 75 08             	pushl  0x8(%ebp)
  800a84:	68 08 24 80 00       	push   $0x802408
  800a89:	e8 0b f9 ff ff       	call   800399 <cprintf>
  800a8e:	83 c4 10             	add    $0x10,%esp

	i = 0;
  800a91:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	echoing = iscons(0);
  800a98:	83 ec 0c             	sub    $0xc,%esp
  800a9b:	6a 00                	push   $0x0
  800a9d:	e8 c0 0f 00 00       	call   801a62 <iscons>
  800aa2:	83 c4 10             	add    $0x10,%esp
  800aa5:	89 45 f0             	mov    %eax,-0x10(%ebp)
	while (1) {
		c = getchar();
  800aa8:	e8 a2 0f 00 00       	call   801a4f <getchar>
  800aad:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if (c < 0) {
  800ab0:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800ab4:	79 22                	jns    800ad8 <readline+0x66>
			if (c != -E_EOF)
  800ab6:	83 7d ec 07          	cmpl   $0x7,-0x14(%ebp)
  800aba:	0f 84 ad 00 00 00    	je     800b6d <readline+0xfb>
				cprintf("read error: %e\n", c);
  800ac0:	83 ec 08             	sub    $0x8,%esp
  800ac3:	ff 75 ec             	pushl  -0x14(%ebp)
  800ac6:	68 0b 24 80 00       	push   $0x80240b
  800acb:	e8 c9 f8 ff ff       	call   800399 <cprintf>
  800ad0:	83 c4 10             	add    $0x10,%esp
			break;
  800ad3:	e9 95 00 00 00       	jmp    800b6d <readline+0xfb>
		} else if (c >= ' ' && i < BUFLEN-1) {
  800ad8:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%ebp)
  800adc:	7e 34                	jle    800b12 <readline+0xa0>
  800ade:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  800ae5:	7f 2b                	jg     800b12 <readline+0xa0>
			if (echoing)
  800ae7:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800aeb:	74 0e                	je     800afb <readline+0x89>
				cputchar(c);
  800aed:	83 ec 0c             	sub    $0xc,%esp
  800af0:	ff 75 ec             	pushl  -0x14(%ebp)
  800af3:	e8 38 0f 00 00       	call   801a30 <cputchar>
  800af8:	83 c4 10             	add    $0x10,%esp
			buf[i++] = c;
  800afb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800afe:	8d 50 01             	lea    0x1(%eax),%edx
  800b01:	89 55 f4             	mov    %edx,-0xc(%ebp)
  800b04:	89 c2                	mov    %eax,%edx
  800b06:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b09:	01 d0                	add    %edx,%eax
  800b0b:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800b0e:	88 10                	mov    %dl,(%eax)
  800b10:	eb 56                	jmp    800b68 <readline+0xf6>
		} else if (c == '\b' && i > 0) {
  800b12:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  800b16:	75 1f                	jne    800b37 <readline+0xc5>
  800b18:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  800b1c:	7e 19                	jle    800b37 <readline+0xc5>
			if (echoing)
  800b1e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800b22:	74 0e                	je     800b32 <readline+0xc0>
				cputchar(c);
  800b24:	83 ec 0c             	sub    $0xc,%esp
  800b27:	ff 75 ec             	pushl  -0x14(%ebp)
  800b2a:	e8 01 0f 00 00       	call   801a30 <cputchar>
  800b2f:	83 c4 10             	add    $0x10,%esp

			i--;
  800b32:	ff 4d f4             	decl   -0xc(%ebp)
  800b35:	eb 31                	jmp    800b68 <readline+0xf6>
		} else if (c == '\n' || c == '\r') {
  800b37:	83 7d ec 0a          	cmpl   $0xa,-0x14(%ebp)
  800b3b:	74 0a                	je     800b47 <readline+0xd5>
  800b3d:	83 7d ec 0d          	cmpl   $0xd,-0x14(%ebp)
  800b41:	0f 85 61 ff ff ff    	jne    800aa8 <readline+0x36>
			if (echoing)
  800b47:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800b4b:	74 0e                	je     800b5b <readline+0xe9>
				cputchar(c);
  800b4d:	83 ec 0c             	sub    $0xc,%esp
  800b50:	ff 75 ec             	pushl  -0x14(%ebp)
  800b53:	e8 d8 0e 00 00       	call   801a30 <cputchar>
  800b58:	83 c4 10             	add    $0x10,%esp

			buf[i] = 0;
  800b5b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800b5e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b61:	01 d0                	add    %edx,%eax
  800b63:	c6 00 00             	movb   $0x0,(%eax)
			break;
  800b66:	eb 06                	jmp    800b6e <readline+0xfc>
		}
	}
  800b68:	e9 3b ff ff ff       	jmp    800aa8 <readline+0x36>
	while (1) {
		c = getchar();
		if (c < 0) {
			if (c != -E_EOF)
				cprintf("read error: %e\n", c);
			break;
  800b6d:	90                   	nop

			buf[i] = 0;
			break;
		}
	}
}
  800b6e:	90                   	nop
  800b6f:	c9                   	leave  
  800b70:	c3                   	ret    

00800b71 <atomic_readline>:

void atomic_readline(const char *prompt, char* buf)
{
  800b71:	55                   	push   %ebp
  800b72:	89 e5                	mov    %esp,%ebp
  800b74:	83 ec 18             	sub    $0x18,%esp
	sys_lock_cons();
  800b77:	e8 79 09 00 00       	call   8014f5 <sys_lock_cons>
	{
		int i, c, echoing;

		if (prompt != NULL)
  800b7c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800b80:	74 13                	je     800b95 <atomic_readline+0x24>
			cprintf("%s", prompt);
  800b82:	83 ec 08             	sub    $0x8,%esp
  800b85:	ff 75 08             	pushl  0x8(%ebp)
  800b88:	68 08 24 80 00       	push   $0x802408
  800b8d:	e8 07 f8 ff ff       	call   800399 <cprintf>
  800b92:	83 c4 10             	add    $0x10,%esp

		i = 0;
  800b95:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
		echoing = iscons(0);
  800b9c:	83 ec 0c             	sub    $0xc,%esp
  800b9f:	6a 00                	push   $0x0
  800ba1:	e8 bc 0e 00 00       	call   801a62 <iscons>
  800ba6:	83 c4 10             	add    $0x10,%esp
  800ba9:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (1) {
			c = getchar();
  800bac:	e8 9e 0e 00 00       	call   801a4f <getchar>
  800bb1:	89 45 ec             	mov    %eax,-0x14(%ebp)
			if (c < 0) {
  800bb4:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800bb8:	79 22                	jns    800bdc <atomic_readline+0x6b>
				if (c != -E_EOF)
  800bba:	83 7d ec 07          	cmpl   $0x7,-0x14(%ebp)
  800bbe:	0f 84 ad 00 00 00    	je     800c71 <atomic_readline+0x100>
					cprintf("read error: %e\n", c);
  800bc4:	83 ec 08             	sub    $0x8,%esp
  800bc7:	ff 75 ec             	pushl  -0x14(%ebp)
  800bca:	68 0b 24 80 00       	push   $0x80240b
  800bcf:	e8 c5 f7 ff ff       	call   800399 <cprintf>
  800bd4:	83 c4 10             	add    $0x10,%esp
				break;
  800bd7:	e9 95 00 00 00       	jmp    800c71 <atomic_readline+0x100>
			} else if (c >= ' ' && i < BUFLEN-1) {
  800bdc:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%ebp)
  800be0:	7e 34                	jle    800c16 <atomic_readline+0xa5>
  800be2:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  800be9:	7f 2b                	jg     800c16 <atomic_readline+0xa5>
				if (echoing)
  800beb:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800bef:	74 0e                	je     800bff <atomic_readline+0x8e>
					cputchar(c);
  800bf1:	83 ec 0c             	sub    $0xc,%esp
  800bf4:	ff 75 ec             	pushl  -0x14(%ebp)
  800bf7:	e8 34 0e 00 00       	call   801a30 <cputchar>
  800bfc:	83 c4 10             	add    $0x10,%esp
				buf[i++] = c;
  800bff:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800c02:	8d 50 01             	lea    0x1(%eax),%edx
  800c05:	89 55 f4             	mov    %edx,-0xc(%ebp)
  800c08:	89 c2                	mov    %eax,%edx
  800c0a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c0d:	01 d0                	add    %edx,%eax
  800c0f:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800c12:	88 10                	mov    %dl,(%eax)
  800c14:	eb 56                	jmp    800c6c <atomic_readline+0xfb>
			} else if (c == '\b' && i > 0) {
  800c16:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  800c1a:	75 1f                	jne    800c3b <atomic_readline+0xca>
  800c1c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  800c20:	7e 19                	jle    800c3b <atomic_readline+0xca>
				if (echoing)
  800c22:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800c26:	74 0e                	je     800c36 <atomic_readline+0xc5>
					cputchar(c);
  800c28:	83 ec 0c             	sub    $0xc,%esp
  800c2b:	ff 75 ec             	pushl  -0x14(%ebp)
  800c2e:	e8 fd 0d 00 00       	call   801a30 <cputchar>
  800c33:	83 c4 10             	add    $0x10,%esp
				i--;
  800c36:	ff 4d f4             	decl   -0xc(%ebp)
  800c39:	eb 31                	jmp    800c6c <atomic_readline+0xfb>
			} else if (c == '\n' || c == '\r') {
  800c3b:	83 7d ec 0a          	cmpl   $0xa,-0x14(%ebp)
  800c3f:	74 0a                	je     800c4b <atomic_readline+0xda>
  800c41:	83 7d ec 0d          	cmpl   $0xd,-0x14(%ebp)
  800c45:	0f 85 61 ff ff ff    	jne    800bac <atomic_readline+0x3b>
				if (echoing)
  800c4b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800c4f:	74 0e                	je     800c5f <atomic_readline+0xee>
					cputchar(c);
  800c51:	83 ec 0c             	sub    $0xc,%esp
  800c54:	ff 75 ec             	pushl  -0x14(%ebp)
  800c57:	e8 d4 0d 00 00       	call   801a30 <cputchar>
  800c5c:	83 c4 10             	add    $0x10,%esp
				buf[i] = 0;
  800c5f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800c62:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c65:	01 d0                	add    %edx,%eax
  800c67:	c6 00 00             	movb   $0x0,(%eax)
				break;
  800c6a:	eb 06                	jmp    800c72 <atomic_readline+0x101>
			}
		}
  800c6c:	e9 3b ff ff ff       	jmp    800bac <atomic_readline+0x3b>
		while (1) {
			c = getchar();
			if (c < 0) {
				if (c != -E_EOF)
					cprintf("read error: %e\n", c);
				break;
  800c71:	90                   	nop
				buf[i] = 0;
				break;
			}
		}
	}
	sys_unlock_cons();
  800c72:	e8 98 08 00 00       	call   80150f <sys_unlock_cons>
}
  800c77:	90                   	nop
  800c78:	c9                   	leave  
  800c79:	c3                   	ret    

00800c7a <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800c7a:	55                   	push   %ebp
  800c7b:	89 e5                	mov    %esp,%ebp
  800c7d:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800c80:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800c87:	eb 06                	jmp    800c8f <strlen+0x15>
		n++;
  800c89:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800c8c:	ff 45 08             	incl   0x8(%ebp)
  800c8f:	8b 45 08             	mov    0x8(%ebp),%eax
  800c92:	8a 00                	mov    (%eax),%al
  800c94:	84 c0                	test   %al,%al
  800c96:	75 f1                	jne    800c89 <strlen+0xf>
		n++;
	return n;
  800c98:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800c9b:	c9                   	leave  
  800c9c:	c3                   	ret    

00800c9d <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800c9d:	55                   	push   %ebp
  800c9e:	89 e5                	mov    %esp,%ebp
  800ca0:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800ca3:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800caa:	eb 09                	jmp    800cb5 <strnlen+0x18>
		n++;
  800cac:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800caf:	ff 45 08             	incl   0x8(%ebp)
  800cb2:	ff 4d 0c             	decl   0xc(%ebp)
  800cb5:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800cb9:	74 09                	je     800cc4 <strnlen+0x27>
  800cbb:	8b 45 08             	mov    0x8(%ebp),%eax
  800cbe:	8a 00                	mov    (%eax),%al
  800cc0:	84 c0                	test   %al,%al
  800cc2:	75 e8                	jne    800cac <strnlen+0xf>
		n++;
	return n;
  800cc4:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800cc7:	c9                   	leave  
  800cc8:	c3                   	ret    

00800cc9 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800cc9:	55                   	push   %ebp
  800cca:	89 e5                	mov    %esp,%ebp
  800ccc:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800ccf:	8b 45 08             	mov    0x8(%ebp),%eax
  800cd2:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800cd5:	90                   	nop
  800cd6:	8b 45 08             	mov    0x8(%ebp),%eax
  800cd9:	8d 50 01             	lea    0x1(%eax),%edx
  800cdc:	89 55 08             	mov    %edx,0x8(%ebp)
  800cdf:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ce2:	8d 4a 01             	lea    0x1(%edx),%ecx
  800ce5:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800ce8:	8a 12                	mov    (%edx),%dl
  800cea:	88 10                	mov    %dl,(%eax)
  800cec:	8a 00                	mov    (%eax),%al
  800cee:	84 c0                	test   %al,%al
  800cf0:	75 e4                	jne    800cd6 <strcpy+0xd>
		/* do nothing */;
	return ret;
  800cf2:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800cf5:	c9                   	leave  
  800cf6:	c3                   	ret    

00800cf7 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800cf7:	55                   	push   %ebp
  800cf8:	89 e5                	mov    %esp,%ebp
  800cfa:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800cfd:	8b 45 08             	mov    0x8(%ebp),%eax
  800d00:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800d03:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800d0a:	eb 1f                	jmp    800d2b <strncpy+0x34>
		*dst++ = *src;
  800d0c:	8b 45 08             	mov    0x8(%ebp),%eax
  800d0f:	8d 50 01             	lea    0x1(%eax),%edx
  800d12:	89 55 08             	mov    %edx,0x8(%ebp)
  800d15:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d18:	8a 12                	mov    (%edx),%dl
  800d1a:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800d1c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d1f:	8a 00                	mov    (%eax),%al
  800d21:	84 c0                	test   %al,%al
  800d23:	74 03                	je     800d28 <strncpy+0x31>
			src++;
  800d25:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800d28:	ff 45 fc             	incl   -0x4(%ebp)
  800d2b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d2e:	3b 45 10             	cmp    0x10(%ebp),%eax
  800d31:	72 d9                	jb     800d0c <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800d33:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800d36:	c9                   	leave  
  800d37:	c3                   	ret    

00800d38 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800d38:	55                   	push   %ebp
  800d39:	89 e5                	mov    %esp,%ebp
  800d3b:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800d3e:	8b 45 08             	mov    0x8(%ebp),%eax
  800d41:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800d44:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d48:	74 30                	je     800d7a <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800d4a:	eb 16                	jmp    800d62 <strlcpy+0x2a>
			*dst++ = *src++;
  800d4c:	8b 45 08             	mov    0x8(%ebp),%eax
  800d4f:	8d 50 01             	lea    0x1(%eax),%edx
  800d52:	89 55 08             	mov    %edx,0x8(%ebp)
  800d55:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d58:	8d 4a 01             	lea    0x1(%edx),%ecx
  800d5b:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800d5e:	8a 12                	mov    (%edx),%dl
  800d60:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800d62:	ff 4d 10             	decl   0x10(%ebp)
  800d65:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d69:	74 09                	je     800d74 <strlcpy+0x3c>
  800d6b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d6e:	8a 00                	mov    (%eax),%al
  800d70:	84 c0                	test   %al,%al
  800d72:	75 d8                	jne    800d4c <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800d74:	8b 45 08             	mov    0x8(%ebp),%eax
  800d77:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800d7a:	8b 55 08             	mov    0x8(%ebp),%edx
  800d7d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d80:	29 c2                	sub    %eax,%edx
  800d82:	89 d0                	mov    %edx,%eax
}
  800d84:	c9                   	leave  
  800d85:	c3                   	ret    

00800d86 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800d86:	55                   	push   %ebp
  800d87:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800d89:	eb 06                	jmp    800d91 <strcmp+0xb>
		p++, q++;
  800d8b:	ff 45 08             	incl   0x8(%ebp)
  800d8e:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800d91:	8b 45 08             	mov    0x8(%ebp),%eax
  800d94:	8a 00                	mov    (%eax),%al
  800d96:	84 c0                	test   %al,%al
  800d98:	74 0e                	je     800da8 <strcmp+0x22>
  800d9a:	8b 45 08             	mov    0x8(%ebp),%eax
  800d9d:	8a 10                	mov    (%eax),%dl
  800d9f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800da2:	8a 00                	mov    (%eax),%al
  800da4:	38 c2                	cmp    %al,%dl
  800da6:	74 e3                	je     800d8b <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800da8:	8b 45 08             	mov    0x8(%ebp),%eax
  800dab:	8a 00                	mov    (%eax),%al
  800dad:	0f b6 d0             	movzbl %al,%edx
  800db0:	8b 45 0c             	mov    0xc(%ebp),%eax
  800db3:	8a 00                	mov    (%eax),%al
  800db5:	0f b6 c0             	movzbl %al,%eax
  800db8:	29 c2                	sub    %eax,%edx
  800dba:	89 d0                	mov    %edx,%eax
}
  800dbc:	5d                   	pop    %ebp
  800dbd:	c3                   	ret    

00800dbe <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800dbe:	55                   	push   %ebp
  800dbf:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800dc1:	eb 09                	jmp    800dcc <strncmp+0xe>
		n--, p++, q++;
  800dc3:	ff 4d 10             	decl   0x10(%ebp)
  800dc6:	ff 45 08             	incl   0x8(%ebp)
  800dc9:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800dcc:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800dd0:	74 17                	je     800de9 <strncmp+0x2b>
  800dd2:	8b 45 08             	mov    0x8(%ebp),%eax
  800dd5:	8a 00                	mov    (%eax),%al
  800dd7:	84 c0                	test   %al,%al
  800dd9:	74 0e                	je     800de9 <strncmp+0x2b>
  800ddb:	8b 45 08             	mov    0x8(%ebp),%eax
  800dde:	8a 10                	mov    (%eax),%dl
  800de0:	8b 45 0c             	mov    0xc(%ebp),%eax
  800de3:	8a 00                	mov    (%eax),%al
  800de5:	38 c2                	cmp    %al,%dl
  800de7:	74 da                	je     800dc3 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800de9:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ded:	75 07                	jne    800df6 <strncmp+0x38>
		return 0;
  800def:	b8 00 00 00 00       	mov    $0x0,%eax
  800df4:	eb 14                	jmp    800e0a <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800df6:	8b 45 08             	mov    0x8(%ebp),%eax
  800df9:	8a 00                	mov    (%eax),%al
  800dfb:	0f b6 d0             	movzbl %al,%edx
  800dfe:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e01:	8a 00                	mov    (%eax),%al
  800e03:	0f b6 c0             	movzbl %al,%eax
  800e06:	29 c2                	sub    %eax,%edx
  800e08:	89 d0                	mov    %edx,%eax
}
  800e0a:	5d                   	pop    %ebp
  800e0b:	c3                   	ret    

00800e0c <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800e0c:	55                   	push   %ebp
  800e0d:	89 e5                	mov    %esp,%ebp
  800e0f:	83 ec 04             	sub    $0x4,%esp
  800e12:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e15:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800e18:	eb 12                	jmp    800e2c <strchr+0x20>
		if (*s == c)
  800e1a:	8b 45 08             	mov    0x8(%ebp),%eax
  800e1d:	8a 00                	mov    (%eax),%al
  800e1f:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800e22:	75 05                	jne    800e29 <strchr+0x1d>
			return (char *) s;
  800e24:	8b 45 08             	mov    0x8(%ebp),%eax
  800e27:	eb 11                	jmp    800e3a <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800e29:	ff 45 08             	incl   0x8(%ebp)
  800e2c:	8b 45 08             	mov    0x8(%ebp),%eax
  800e2f:	8a 00                	mov    (%eax),%al
  800e31:	84 c0                	test   %al,%al
  800e33:	75 e5                	jne    800e1a <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800e35:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800e3a:	c9                   	leave  
  800e3b:	c3                   	ret    

00800e3c <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800e3c:	55                   	push   %ebp
  800e3d:	89 e5                	mov    %esp,%ebp
  800e3f:	83 ec 04             	sub    $0x4,%esp
  800e42:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e45:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800e48:	eb 0d                	jmp    800e57 <strfind+0x1b>
		if (*s == c)
  800e4a:	8b 45 08             	mov    0x8(%ebp),%eax
  800e4d:	8a 00                	mov    (%eax),%al
  800e4f:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800e52:	74 0e                	je     800e62 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800e54:	ff 45 08             	incl   0x8(%ebp)
  800e57:	8b 45 08             	mov    0x8(%ebp),%eax
  800e5a:	8a 00                	mov    (%eax),%al
  800e5c:	84 c0                	test   %al,%al
  800e5e:	75 ea                	jne    800e4a <strfind+0xe>
  800e60:	eb 01                	jmp    800e63 <strfind+0x27>
		if (*s == c)
			break;
  800e62:	90                   	nop
	return (char *) s;
  800e63:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e66:	c9                   	leave  
  800e67:	c3                   	ret    

00800e68 <memset>:

// *************** The faster implementation of memset & memcpy is implemented by *************
// ****************** Team80 (Yahia Khaled, Malek Ahmed et al) - FCIS'24-25 *******************
void *
memset(void *v, int c, uint32 n)
{
  800e68:	55                   	push   %ebp
  800e69:	89 e5                	mov    %esp,%ebp
  800e6b:	83 ec 10             	sub    $0x10,%esp
//	m = n;
//	while (--m >= 0)
//		*p++ = c;

	/*Faster Implementation*/
	uint64* p64 = (uint64*)v;
  800e6e:	8b 45 08             	mov    0x8(%ebp),%eax
  800e71:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if(n >= 8){
  800e74:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800e78:	76 63                	jbe    800edd <memset+0x75>
		uint64 data_block = c;
  800e7a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e7d:	99                   	cltd   
  800e7e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800e81:	89 55 f4             	mov    %edx,-0xc(%ebp)
		data_block |= data_block << 8;
  800e84:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800e87:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800e8a:	0f a4 c2 08          	shld   $0x8,%eax,%edx
  800e8e:	c1 e0 08             	shl    $0x8,%eax
  800e91:	09 45 f0             	or     %eax,-0x10(%ebp)
  800e94:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 16;
  800e97:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800e9a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800e9d:	0f a4 c2 10          	shld   $0x10,%eax,%edx
  800ea1:	c1 e0 10             	shl    $0x10,%eax
  800ea4:	09 45 f0             	or     %eax,-0x10(%ebp)
  800ea7:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 32;
  800eaa:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800ead:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800eb0:	89 c2                	mov    %eax,%edx
  800eb2:	b8 00 00 00 00       	mov    $0x0,%eax
  800eb7:	09 45 f0             	or     %eax,-0x10(%ebp)
  800eba:	09 55 f4             	or     %edx,-0xc(%ebp)

		while(n >= 8)
  800ebd:	eb 18                	jmp    800ed7 <memset+0x6f>
			*p64++ = data_block, n -= 8;
  800ebf:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  800ec2:	8d 41 08             	lea    0x8(%ecx),%eax
  800ec5:	89 45 fc             	mov    %eax,-0x4(%ebp)
  800ec8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800ecb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800ece:	89 01                	mov    %eax,(%ecx)
  800ed0:	89 51 04             	mov    %edx,0x4(%ecx)
  800ed3:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
		uint64 data_block = c;
		data_block |= data_block << 8;
		data_block |= data_block << 16;
		data_block |= data_block << 32;

		while(n >= 8)
  800ed7:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800edb:	77 e2                	ja     800ebf <memset+0x57>
			*p64++ = data_block, n -= 8;
	}

	if(n){
  800edd:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ee1:	74 23                	je     800f06 <memset+0x9e>
		uint8* p8 = (uint8*)p64;
  800ee3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ee6:	89 45 f8             	mov    %eax,-0x8(%ebp)
		while (n-- > 0)
  800ee9:	eb 0e                	jmp    800ef9 <memset+0x91>
			*p8++ = (uint8)c;
  800eeb:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800eee:	8d 50 01             	lea    0x1(%eax),%edx
  800ef1:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800ef4:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ef7:	88 10                	mov    %dl,(%eax)
			*p64++ = data_block, n -= 8;
	}

	if(n){
		uint8* p8 = (uint8*)p64;
		while (n-- > 0)
  800ef9:	8b 45 10             	mov    0x10(%ebp),%eax
  800efc:	8d 50 ff             	lea    -0x1(%eax),%edx
  800eff:	89 55 10             	mov    %edx,0x10(%ebp)
  800f02:	85 c0                	test   %eax,%eax
  800f04:	75 e5                	jne    800eeb <memset+0x83>
			*p8++ = (uint8)c;
	}

	return v;
  800f06:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f09:	c9                   	leave  
  800f0a:	c3                   	ret    

00800f0b <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800f0b:	55                   	push   %ebp
  800f0c:	89 e5                	mov    %esp,%ebp
  800f0e:	83 ec 10             	sub    $0x10,%esp
	//	s = src;
	//	d = dst;
	//	while (n-- > 0)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
  800f11:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f14:	89 45 fc             	mov    %eax,-0x4(%ebp)
	uint64* d64 = (uint64*)dst;
  800f17:	8b 45 08             	mov    0x8(%ebp),%eax
  800f1a:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if(n >= 8){
  800f1d:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800f21:	76 24                	jbe    800f47 <memcpy+0x3c>
		while(n >= 8){
  800f23:	eb 1c                	jmp    800f41 <memcpy+0x36>
			*d64 = *s64;
  800f25:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f28:	8b 50 04             	mov    0x4(%eax),%edx
  800f2b:	8b 00                	mov    (%eax),%eax
  800f2d:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  800f30:	89 01                	mov    %eax,(%ecx)
  800f32:	89 51 04             	mov    %edx,0x4(%ecx)
			n -= 8;
  800f35:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
			++s64;
  800f39:	83 45 fc 08          	addl   $0x8,-0x4(%ebp)
			++d64;
  800f3d:	83 45 f8 08          	addl   $0x8,-0x8(%ebp)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
	uint64* d64 = (uint64*)dst;
	if(n >= 8){
		while(n >= 8){
  800f41:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800f45:	77 de                	ja     800f25 <memcpy+0x1a>
			++s64;
			++d64;
		}
	}

	if(n){
  800f47:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f4b:	74 31                	je     800f7e <memcpy+0x73>
		uint8* s8 = (uint8*)s64;
  800f4d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f50:	89 45 f4             	mov    %eax,-0xc(%ebp)
		uint8* d8 = (uint8*)d64;
  800f53:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f56:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (n-- > 0)
  800f59:	eb 16                	jmp    800f71 <memcpy+0x66>
			*d8++ = *s8++;
  800f5b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800f5e:	8d 50 01             	lea    0x1(%eax),%edx
  800f61:	89 55 f0             	mov    %edx,-0x10(%ebp)
  800f64:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800f67:	8d 4a 01             	lea    0x1(%edx),%ecx
  800f6a:	89 4d f4             	mov    %ecx,-0xc(%ebp)
  800f6d:	8a 12                	mov    (%edx),%dl
  800f6f:	88 10                	mov    %dl,(%eax)
	}

	if(n){
		uint8* s8 = (uint8*)s64;
		uint8* d8 = (uint8*)d64;
		while (n-- > 0)
  800f71:	8b 45 10             	mov    0x10(%ebp),%eax
  800f74:	8d 50 ff             	lea    -0x1(%eax),%edx
  800f77:	89 55 10             	mov    %edx,0x10(%ebp)
  800f7a:	85 c0                	test   %eax,%eax
  800f7c:	75 dd                	jne    800f5b <memcpy+0x50>
			*d8++ = *s8++;
	}
	return dst;
  800f7e:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f81:	c9                   	leave  
  800f82:	c3                   	ret    

00800f83 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800f83:	55                   	push   %ebp
  800f84:	89 e5                	mov    %esp,%ebp
  800f86:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800f89:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f8c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800f8f:	8b 45 08             	mov    0x8(%ebp),%eax
  800f92:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800f95:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f98:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800f9b:	73 50                	jae    800fed <memmove+0x6a>
  800f9d:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800fa0:	8b 45 10             	mov    0x10(%ebp),%eax
  800fa3:	01 d0                	add    %edx,%eax
  800fa5:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800fa8:	76 43                	jbe    800fed <memmove+0x6a>
		s += n;
  800faa:	8b 45 10             	mov    0x10(%ebp),%eax
  800fad:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800fb0:	8b 45 10             	mov    0x10(%ebp),%eax
  800fb3:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800fb6:	eb 10                	jmp    800fc8 <memmove+0x45>
			*--d = *--s;
  800fb8:	ff 4d f8             	decl   -0x8(%ebp)
  800fbb:	ff 4d fc             	decl   -0x4(%ebp)
  800fbe:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800fc1:	8a 10                	mov    (%eax),%dl
  800fc3:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800fc6:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800fc8:	8b 45 10             	mov    0x10(%ebp),%eax
  800fcb:	8d 50 ff             	lea    -0x1(%eax),%edx
  800fce:	89 55 10             	mov    %edx,0x10(%ebp)
  800fd1:	85 c0                	test   %eax,%eax
  800fd3:	75 e3                	jne    800fb8 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800fd5:	eb 23                	jmp    800ffa <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800fd7:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800fda:	8d 50 01             	lea    0x1(%eax),%edx
  800fdd:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800fe0:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800fe3:	8d 4a 01             	lea    0x1(%edx),%ecx
  800fe6:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800fe9:	8a 12                	mov    (%edx),%dl
  800feb:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800fed:	8b 45 10             	mov    0x10(%ebp),%eax
  800ff0:	8d 50 ff             	lea    -0x1(%eax),%edx
  800ff3:	89 55 10             	mov    %edx,0x10(%ebp)
  800ff6:	85 c0                	test   %eax,%eax
  800ff8:	75 dd                	jne    800fd7 <memmove+0x54>
			*d++ = *s++;

	return dst;
  800ffa:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800ffd:	c9                   	leave  
  800ffe:	c3                   	ret    

00800fff <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  800fff:	55                   	push   %ebp
  801000:	89 e5                	mov    %esp,%ebp
  801002:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  801005:	8b 45 08             	mov    0x8(%ebp),%eax
  801008:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  80100b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80100e:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  801011:	eb 2a                	jmp    80103d <memcmp+0x3e>
		if (*s1 != *s2)
  801013:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801016:	8a 10                	mov    (%eax),%dl
  801018:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80101b:	8a 00                	mov    (%eax),%al
  80101d:	38 c2                	cmp    %al,%dl
  80101f:	74 16                	je     801037 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  801021:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801024:	8a 00                	mov    (%eax),%al
  801026:	0f b6 d0             	movzbl %al,%edx
  801029:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80102c:	8a 00                	mov    (%eax),%al
  80102e:	0f b6 c0             	movzbl %al,%eax
  801031:	29 c2                	sub    %eax,%edx
  801033:	89 d0                	mov    %edx,%eax
  801035:	eb 18                	jmp    80104f <memcmp+0x50>
		s1++, s2++;
  801037:	ff 45 fc             	incl   -0x4(%ebp)
  80103a:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  80103d:	8b 45 10             	mov    0x10(%ebp),%eax
  801040:	8d 50 ff             	lea    -0x1(%eax),%edx
  801043:	89 55 10             	mov    %edx,0x10(%ebp)
  801046:	85 c0                	test   %eax,%eax
  801048:	75 c9                	jne    801013 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  80104a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80104f:	c9                   	leave  
  801050:	c3                   	ret    

00801051 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  801051:	55                   	push   %ebp
  801052:	89 e5                	mov    %esp,%ebp
  801054:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  801057:	8b 55 08             	mov    0x8(%ebp),%edx
  80105a:	8b 45 10             	mov    0x10(%ebp),%eax
  80105d:	01 d0                	add    %edx,%eax
  80105f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  801062:	eb 15                	jmp    801079 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  801064:	8b 45 08             	mov    0x8(%ebp),%eax
  801067:	8a 00                	mov    (%eax),%al
  801069:	0f b6 d0             	movzbl %al,%edx
  80106c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80106f:	0f b6 c0             	movzbl %al,%eax
  801072:	39 c2                	cmp    %eax,%edx
  801074:	74 0d                	je     801083 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801076:	ff 45 08             	incl   0x8(%ebp)
  801079:	8b 45 08             	mov    0x8(%ebp),%eax
  80107c:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  80107f:	72 e3                	jb     801064 <memfind+0x13>
  801081:	eb 01                	jmp    801084 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  801083:	90                   	nop
	return (void *) s;
  801084:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801087:	c9                   	leave  
  801088:	c3                   	ret    

00801089 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801089:	55                   	push   %ebp
  80108a:	89 e5                	mov    %esp,%ebp
  80108c:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  80108f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  801096:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80109d:	eb 03                	jmp    8010a2 <strtol+0x19>
		s++;
  80109f:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8010a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8010a5:	8a 00                	mov    (%eax),%al
  8010a7:	3c 20                	cmp    $0x20,%al
  8010a9:	74 f4                	je     80109f <strtol+0x16>
  8010ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8010ae:	8a 00                	mov    (%eax),%al
  8010b0:	3c 09                	cmp    $0x9,%al
  8010b2:	74 eb                	je     80109f <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  8010b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8010b7:	8a 00                	mov    (%eax),%al
  8010b9:	3c 2b                	cmp    $0x2b,%al
  8010bb:	75 05                	jne    8010c2 <strtol+0x39>
		s++;
  8010bd:	ff 45 08             	incl   0x8(%ebp)
  8010c0:	eb 13                	jmp    8010d5 <strtol+0x4c>
	else if (*s == '-')
  8010c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8010c5:	8a 00                	mov    (%eax),%al
  8010c7:	3c 2d                	cmp    $0x2d,%al
  8010c9:	75 0a                	jne    8010d5 <strtol+0x4c>
		s++, neg = 1;
  8010cb:	ff 45 08             	incl   0x8(%ebp)
  8010ce:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8010d5:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8010d9:	74 06                	je     8010e1 <strtol+0x58>
  8010db:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  8010df:	75 20                	jne    801101 <strtol+0x78>
  8010e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8010e4:	8a 00                	mov    (%eax),%al
  8010e6:	3c 30                	cmp    $0x30,%al
  8010e8:	75 17                	jne    801101 <strtol+0x78>
  8010ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8010ed:	40                   	inc    %eax
  8010ee:	8a 00                	mov    (%eax),%al
  8010f0:	3c 78                	cmp    $0x78,%al
  8010f2:	75 0d                	jne    801101 <strtol+0x78>
		s += 2, base = 16;
  8010f4:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  8010f8:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  8010ff:	eb 28                	jmp    801129 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  801101:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801105:	75 15                	jne    80111c <strtol+0x93>
  801107:	8b 45 08             	mov    0x8(%ebp),%eax
  80110a:	8a 00                	mov    (%eax),%al
  80110c:	3c 30                	cmp    $0x30,%al
  80110e:	75 0c                	jne    80111c <strtol+0x93>
		s++, base = 8;
  801110:	ff 45 08             	incl   0x8(%ebp)
  801113:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  80111a:	eb 0d                	jmp    801129 <strtol+0xa0>
	else if (base == 0)
  80111c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801120:	75 07                	jne    801129 <strtol+0xa0>
		base = 10;
  801122:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801129:	8b 45 08             	mov    0x8(%ebp),%eax
  80112c:	8a 00                	mov    (%eax),%al
  80112e:	3c 2f                	cmp    $0x2f,%al
  801130:	7e 19                	jle    80114b <strtol+0xc2>
  801132:	8b 45 08             	mov    0x8(%ebp),%eax
  801135:	8a 00                	mov    (%eax),%al
  801137:	3c 39                	cmp    $0x39,%al
  801139:	7f 10                	jg     80114b <strtol+0xc2>
			dig = *s - '0';
  80113b:	8b 45 08             	mov    0x8(%ebp),%eax
  80113e:	8a 00                	mov    (%eax),%al
  801140:	0f be c0             	movsbl %al,%eax
  801143:	83 e8 30             	sub    $0x30,%eax
  801146:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801149:	eb 42                	jmp    80118d <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  80114b:	8b 45 08             	mov    0x8(%ebp),%eax
  80114e:	8a 00                	mov    (%eax),%al
  801150:	3c 60                	cmp    $0x60,%al
  801152:	7e 19                	jle    80116d <strtol+0xe4>
  801154:	8b 45 08             	mov    0x8(%ebp),%eax
  801157:	8a 00                	mov    (%eax),%al
  801159:	3c 7a                	cmp    $0x7a,%al
  80115b:	7f 10                	jg     80116d <strtol+0xe4>
			dig = *s - 'a' + 10;
  80115d:	8b 45 08             	mov    0x8(%ebp),%eax
  801160:	8a 00                	mov    (%eax),%al
  801162:	0f be c0             	movsbl %al,%eax
  801165:	83 e8 57             	sub    $0x57,%eax
  801168:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80116b:	eb 20                	jmp    80118d <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  80116d:	8b 45 08             	mov    0x8(%ebp),%eax
  801170:	8a 00                	mov    (%eax),%al
  801172:	3c 40                	cmp    $0x40,%al
  801174:	7e 39                	jle    8011af <strtol+0x126>
  801176:	8b 45 08             	mov    0x8(%ebp),%eax
  801179:	8a 00                	mov    (%eax),%al
  80117b:	3c 5a                	cmp    $0x5a,%al
  80117d:	7f 30                	jg     8011af <strtol+0x126>
			dig = *s - 'A' + 10;
  80117f:	8b 45 08             	mov    0x8(%ebp),%eax
  801182:	8a 00                	mov    (%eax),%al
  801184:	0f be c0             	movsbl %al,%eax
  801187:	83 e8 37             	sub    $0x37,%eax
  80118a:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  80118d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801190:	3b 45 10             	cmp    0x10(%ebp),%eax
  801193:	7d 19                	jge    8011ae <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801195:	ff 45 08             	incl   0x8(%ebp)
  801198:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80119b:	0f af 45 10          	imul   0x10(%ebp),%eax
  80119f:	89 c2                	mov    %eax,%edx
  8011a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8011a4:	01 d0                	add    %edx,%eax
  8011a6:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  8011a9:	e9 7b ff ff ff       	jmp    801129 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  8011ae:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  8011af:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8011b3:	74 08                	je     8011bd <strtol+0x134>
		*endptr = (char *) s;
  8011b5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011b8:	8b 55 08             	mov    0x8(%ebp),%edx
  8011bb:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  8011bd:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8011c1:	74 07                	je     8011ca <strtol+0x141>
  8011c3:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011c6:	f7 d8                	neg    %eax
  8011c8:	eb 03                	jmp    8011cd <strtol+0x144>
  8011ca:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8011cd:	c9                   	leave  
  8011ce:	c3                   	ret    

008011cf <ltostr>:

void
ltostr(long value, char *str)
{
  8011cf:	55                   	push   %ebp
  8011d0:	89 e5                	mov    %esp,%ebp
  8011d2:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  8011d5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  8011dc:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  8011e3:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8011e7:	79 13                	jns    8011fc <ltostr+0x2d>
	{
		neg = 1;
  8011e9:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  8011f0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011f3:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  8011f6:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  8011f9:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  8011fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8011ff:	b9 0a 00 00 00       	mov    $0xa,%ecx
  801204:	99                   	cltd   
  801205:	f7 f9                	idiv   %ecx
  801207:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  80120a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80120d:	8d 50 01             	lea    0x1(%eax),%edx
  801210:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801213:	89 c2                	mov    %eax,%edx
  801215:	8b 45 0c             	mov    0xc(%ebp),%eax
  801218:	01 d0                	add    %edx,%eax
  80121a:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80121d:	83 c2 30             	add    $0x30,%edx
  801220:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  801222:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801225:	b8 67 66 66 66       	mov    $0x66666667,%eax
  80122a:	f7 e9                	imul   %ecx
  80122c:	c1 fa 02             	sar    $0x2,%edx
  80122f:	89 c8                	mov    %ecx,%eax
  801231:	c1 f8 1f             	sar    $0x1f,%eax
  801234:	29 c2                	sub    %eax,%edx
  801236:	89 d0                	mov    %edx,%eax
  801238:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  80123b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80123f:	75 bb                	jne    8011fc <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801241:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801248:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80124b:	48                   	dec    %eax
  80124c:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  80124f:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801253:	74 3d                	je     801292 <ltostr+0xc3>
		start = 1 ;
  801255:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  80125c:	eb 34                	jmp    801292 <ltostr+0xc3>
	{
		char tmp = str[start] ;
  80125e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801261:	8b 45 0c             	mov    0xc(%ebp),%eax
  801264:	01 d0                	add    %edx,%eax
  801266:	8a 00                	mov    (%eax),%al
  801268:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  80126b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80126e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801271:	01 c2                	add    %eax,%edx
  801273:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801276:	8b 45 0c             	mov    0xc(%ebp),%eax
  801279:	01 c8                	add    %ecx,%eax
  80127b:	8a 00                	mov    (%eax),%al
  80127d:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  80127f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801282:	8b 45 0c             	mov    0xc(%ebp),%eax
  801285:	01 c2                	add    %eax,%edx
  801287:	8a 45 eb             	mov    -0x15(%ebp),%al
  80128a:	88 02                	mov    %al,(%edx)
		start++ ;
  80128c:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  80128f:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801292:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801295:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801298:	7c c4                	jl     80125e <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  80129a:	8b 55 f8             	mov    -0x8(%ebp),%edx
  80129d:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012a0:	01 d0                	add    %edx,%eax
  8012a2:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  8012a5:	90                   	nop
  8012a6:	c9                   	leave  
  8012a7:	c3                   	ret    

008012a8 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  8012a8:	55                   	push   %ebp
  8012a9:	89 e5                	mov    %esp,%ebp
  8012ab:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  8012ae:	ff 75 08             	pushl  0x8(%ebp)
  8012b1:	e8 c4 f9 ff ff       	call   800c7a <strlen>
  8012b6:	83 c4 04             	add    $0x4,%esp
  8012b9:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  8012bc:	ff 75 0c             	pushl  0xc(%ebp)
  8012bf:	e8 b6 f9 ff ff       	call   800c7a <strlen>
  8012c4:	83 c4 04             	add    $0x4,%esp
  8012c7:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  8012ca:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  8012d1:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8012d8:	eb 17                	jmp    8012f1 <strcconcat+0x49>
		final[s] = str1[s] ;
  8012da:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8012dd:	8b 45 10             	mov    0x10(%ebp),%eax
  8012e0:	01 c2                	add    %eax,%edx
  8012e2:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8012e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8012e8:	01 c8                	add    %ecx,%eax
  8012ea:	8a 00                	mov    (%eax),%al
  8012ec:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  8012ee:	ff 45 fc             	incl   -0x4(%ebp)
  8012f1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8012f4:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8012f7:	7c e1                	jl     8012da <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  8012f9:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  801300:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  801307:	eb 1f                	jmp    801328 <strcconcat+0x80>
		final[s++] = str2[i] ;
  801309:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80130c:	8d 50 01             	lea    0x1(%eax),%edx
  80130f:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801312:	89 c2                	mov    %eax,%edx
  801314:	8b 45 10             	mov    0x10(%ebp),%eax
  801317:	01 c2                	add    %eax,%edx
  801319:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  80131c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80131f:	01 c8                	add    %ecx,%eax
  801321:	8a 00                	mov    (%eax),%al
  801323:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801325:	ff 45 f8             	incl   -0x8(%ebp)
  801328:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80132b:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80132e:	7c d9                	jl     801309 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801330:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801333:	8b 45 10             	mov    0x10(%ebp),%eax
  801336:	01 d0                	add    %edx,%eax
  801338:	c6 00 00             	movb   $0x0,(%eax)
}
  80133b:	90                   	nop
  80133c:	c9                   	leave  
  80133d:	c3                   	ret    

0080133e <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  80133e:	55                   	push   %ebp
  80133f:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801341:	8b 45 14             	mov    0x14(%ebp),%eax
  801344:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  80134a:	8b 45 14             	mov    0x14(%ebp),%eax
  80134d:	8b 00                	mov    (%eax),%eax
  80134f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801356:	8b 45 10             	mov    0x10(%ebp),%eax
  801359:	01 d0                	add    %edx,%eax
  80135b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801361:	eb 0c                	jmp    80136f <strsplit+0x31>
			*string++ = 0;
  801363:	8b 45 08             	mov    0x8(%ebp),%eax
  801366:	8d 50 01             	lea    0x1(%eax),%edx
  801369:	89 55 08             	mov    %edx,0x8(%ebp)
  80136c:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80136f:	8b 45 08             	mov    0x8(%ebp),%eax
  801372:	8a 00                	mov    (%eax),%al
  801374:	84 c0                	test   %al,%al
  801376:	74 18                	je     801390 <strsplit+0x52>
  801378:	8b 45 08             	mov    0x8(%ebp),%eax
  80137b:	8a 00                	mov    (%eax),%al
  80137d:	0f be c0             	movsbl %al,%eax
  801380:	50                   	push   %eax
  801381:	ff 75 0c             	pushl  0xc(%ebp)
  801384:	e8 83 fa ff ff       	call   800e0c <strchr>
  801389:	83 c4 08             	add    $0x8,%esp
  80138c:	85 c0                	test   %eax,%eax
  80138e:	75 d3                	jne    801363 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801390:	8b 45 08             	mov    0x8(%ebp),%eax
  801393:	8a 00                	mov    (%eax),%al
  801395:	84 c0                	test   %al,%al
  801397:	74 5a                	je     8013f3 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801399:	8b 45 14             	mov    0x14(%ebp),%eax
  80139c:	8b 00                	mov    (%eax),%eax
  80139e:	83 f8 0f             	cmp    $0xf,%eax
  8013a1:	75 07                	jne    8013aa <strsplit+0x6c>
		{
			return 0;
  8013a3:	b8 00 00 00 00       	mov    $0x0,%eax
  8013a8:	eb 66                	jmp    801410 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  8013aa:	8b 45 14             	mov    0x14(%ebp),%eax
  8013ad:	8b 00                	mov    (%eax),%eax
  8013af:	8d 48 01             	lea    0x1(%eax),%ecx
  8013b2:	8b 55 14             	mov    0x14(%ebp),%edx
  8013b5:	89 0a                	mov    %ecx,(%edx)
  8013b7:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8013be:	8b 45 10             	mov    0x10(%ebp),%eax
  8013c1:	01 c2                	add    %eax,%edx
  8013c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8013c6:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  8013c8:	eb 03                	jmp    8013cd <strsplit+0x8f>
			string++;
  8013ca:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  8013cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8013d0:	8a 00                	mov    (%eax),%al
  8013d2:	84 c0                	test   %al,%al
  8013d4:	74 8b                	je     801361 <strsplit+0x23>
  8013d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8013d9:	8a 00                	mov    (%eax),%al
  8013db:	0f be c0             	movsbl %al,%eax
  8013de:	50                   	push   %eax
  8013df:	ff 75 0c             	pushl  0xc(%ebp)
  8013e2:	e8 25 fa ff ff       	call   800e0c <strchr>
  8013e7:	83 c4 08             	add    $0x8,%esp
  8013ea:	85 c0                	test   %eax,%eax
  8013ec:	74 dc                	je     8013ca <strsplit+0x8c>
			string++;
	}
  8013ee:	e9 6e ff ff ff       	jmp    801361 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  8013f3:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  8013f4:	8b 45 14             	mov    0x14(%ebp),%eax
  8013f7:	8b 00                	mov    (%eax),%eax
  8013f9:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801400:	8b 45 10             	mov    0x10(%ebp),%eax
  801403:	01 d0                	add    %edx,%eax
  801405:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  80140b:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801410:	c9                   	leave  
  801411:	c3                   	ret    

00801412 <str2lower>:


char* str2lower(char *dst, const char *src)
{
  801412:	55                   	push   %ebp
  801413:	89 e5                	mov    %esp,%ebp
  801415:	83 ec 10             	sub    $0x10,%esp
	char* ret = dst;
  801418:	8b 45 08             	mov    0x8(%ebp),%eax
  80141b:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (int i = 0; i < strlen(src); ++i)
  80141e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801425:	eb 4a                	jmp    801471 <str2lower+0x5f>
	{
		dst[i] = src[i] ;
  801427:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80142a:	8b 45 08             	mov    0x8(%ebp),%eax
  80142d:	01 c2                	add    %eax,%edx
  80142f:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801432:	8b 45 0c             	mov    0xc(%ebp),%eax
  801435:	01 c8                	add    %ecx,%eax
  801437:	8a 00                	mov    (%eax),%al
  801439:	88 02                	mov    %al,(%edx)
		if (src[i] >= 'A' && src[i] <= 'Z')
  80143b:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80143e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801441:	01 d0                	add    %edx,%eax
  801443:	8a 00                	mov    (%eax),%al
  801445:	3c 40                	cmp    $0x40,%al
  801447:	7e 25                	jle    80146e <str2lower+0x5c>
  801449:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80144c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80144f:	01 d0                	add    %edx,%eax
  801451:	8a 00                	mov    (%eax),%al
  801453:	3c 5a                	cmp    $0x5a,%al
  801455:	7f 17                	jg     80146e <str2lower+0x5c>
		{
			dst[i] += 32 ;
  801457:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80145a:	8b 45 08             	mov    0x8(%ebp),%eax
  80145d:	01 d0                	add    %edx,%eax
  80145f:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801462:	8b 55 08             	mov    0x8(%ebp),%edx
  801465:	01 ca                	add    %ecx,%edx
  801467:	8a 12                	mov    (%edx),%dl
  801469:	83 c2 20             	add    $0x20,%edx
  80146c:	88 10                	mov    %dl,(%eax)


char* str2lower(char *dst, const char *src)
{
	char* ret = dst;
	for (int i = 0; i < strlen(src); ++i)
  80146e:	ff 45 fc             	incl   -0x4(%ebp)
  801471:	ff 75 0c             	pushl  0xc(%ebp)
  801474:	e8 01 f8 ff ff       	call   800c7a <strlen>
  801479:	83 c4 04             	add    $0x4,%esp
  80147c:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  80147f:	7f a6                	jg     801427 <str2lower+0x15>
		if (src[i] >= 'A' && src[i] <= 'Z')
		{
			dst[i] += 32 ;
		}
	}
	return ret;
  801481:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801484:	c9                   	leave  
  801485:	c3                   	ret    

00801486 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801486:	55                   	push   %ebp
  801487:	89 e5                	mov    %esp,%ebp
  801489:	57                   	push   %edi
  80148a:	56                   	push   %esi
  80148b:	53                   	push   %ebx
  80148c:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80148f:	8b 45 08             	mov    0x8(%ebp),%eax
  801492:	8b 55 0c             	mov    0xc(%ebp),%edx
  801495:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801498:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80149b:	8b 7d 18             	mov    0x18(%ebp),%edi
  80149e:	8b 75 1c             	mov    0x1c(%ebp),%esi
  8014a1:	cd 30                	int    $0x30
  8014a3:	89 45 f0             	mov    %eax,-0x10(%ebp)
				"b" (a3),
				"D" (a4),
				"S" (a5)
				: "cc", "memory");

	return ret;
  8014a6:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8014a9:	83 c4 10             	add    $0x10,%esp
  8014ac:	5b                   	pop    %ebx
  8014ad:	5e                   	pop    %esi
  8014ae:	5f                   	pop    %edi
  8014af:	5d                   	pop    %ebp
  8014b0:	c3                   	ret    

008014b1 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName, int color)
{
  8014b1:	55                   	push   %ebp
  8014b2:	89 e5                	mov    %esp,%ebp
  8014b4:	83 ec 04             	sub    $0x4,%esp
  8014b7:	8b 45 10             	mov    0x10(%ebp),%eax
  8014ba:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, color, 0);
  8014bd:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8014c0:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8014c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8014c7:	6a 00                	push   $0x0
  8014c9:	51                   	push   %ecx
  8014ca:	52                   	push   %edx
  8014cb:	ff 75 0c             	pushl  0xc(%ebp)
  8014ce:	50                   	push   %eax
  8014cf:	6a 00                	push   $0x0
  8014d1:	e8 b0 ff ff ff       	call   801486 <syscall>
  8014d6:	83 c4 18             	add    $0x18,%esp
}
  8014d9:	90                   	nop
  8014da:	c9                   	leave  
  8014db:	c3                   	ret    

008014dc <sys_cgetc>:

int
sys_cgetc(void)
{
  8014dc:	55                   	push   %ebp
  8014dd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  8014df:	6a 00                	push   $0x0
  8014e1:	6a 00                	push   $0x0
  8014e3:	6a 00                	push   $0x0
  8014e5:	6a 00                	push   $0x0
  8014e7:	6a 00                	push   $0x0
  8014e9:	6a 02                	push   $0x2
  8014eb:	e8 96 ff ff ff       	call   801486 <syscall>
  8014f0:	83 c4 18             	add    $0x18,%esp
}
  8014f3:	c9                   	leave  
  8014f4:	c3                   	ret    

008014f5 <sys_lock_cons>:

void sys_lock_cons(void)
{
  8014f5:	55                   	push   %ebp
  8014f6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  8014f8:	6a 00                	push   $0x0
  8014fa:	6a 00                	push   $0x0
  8014fc:	6a 00                	push   $0x0
  8014fe:	6a 00                	push   $0x0
  801500:	6a 00                	push   $0x0
  801502:	6a 03                	push   $0x3
  801504:	e8 7d ff ff ff       	call   801486 <syscall>
  801509:	83 c4 18             	add    $0x18,%esp
}
  80150c:	90                   	nop
  80150d:	c9                   	leave  
  80150e:	c3                   	ret    

0080150f <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  80150f:	55                   	push   %ebp
  801510:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  801512:	6a 00                	push   $0x0
  801514:	6a 00                	push   $0x0
  801516:	6a 00                	push   $0x0
  801518:	6a 00                	push   $0x0
  80151a:	6a 00                	push   $0x0
  80151c:	6a 04                	push   $0x4
  80151e:	e8 63 ff ff ff       	call   801486 <syscall>
  801523:	83 c4 18             	add    $0x18,%esp
}
  801526:	90                   	nop
  801527:	c9                   	leave  
  801528:	c3                   	ret    

00801529 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801529:	55                   	push   %ebp
  80152a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  80152c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80152f:	8b 45 08             	mov    0x8(%ebp),%eax
  801532:	6a 00                	push   $0x0
  801534:	6a 00                	push   $0x0
  801536:	6a 00                	push   $0x0
  801538:	52                   	push   %edx
  801539:	50                   	push   %eax
  80153a:	6a 08                	push   $0x8
  80153c:	e8 45 ff ff ff       	call   801486 <syscall>
  801541:	83 c4 18             	add    $0x18,%esp
}
  801544:	c9                   	leave  
  801545:	c3                   	ret    

00801546 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801546:	55                   	push   %ebp
  801547:	89 e5                	mov    %esp,%ebp
  801549:	56                   	push   %esi
  80154a:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  80154b:	8b 75 18             	mov    0x18(%ebp),%esi
  80154e:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801551:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801554:	8b 55 0c             	mov    0xc(%ebp),%edx
  801557:	8b 45 08             	mov    0x8(%ebp),%eax
  80155a:	56                   	push   %esi
  80155b:	53                   	push   %ebx
  80155c:	51                   	push   %ecx
  80155d:	52                   	push   %edx
  80155e:	50                   	push   %eax
  80155f:	6a 09                	push   $0x9
  801561:	e8 20 ff ff ff       	call   801486 <syscall>
  801566:	83 c4 18             	add    $0x18,%esp
}
  801569:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80156c:	5b                   	pop    %ebx
  80156d:	5e                   	pop    %esi
  80156e:	5d                   	pop    %ebp
  80156f:	c3                   	ret    

00801570 <__sys_unmap_frame>:

int __sys_unmap_frame(uint32 va)
{
  801570:	55                   	push   %ebp
  801571:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, va, 0, 0, 0, 0);
  801573:	6a 00                	push   $0x0
  801575:	6a 00                	push   $0x0
  801577:	6a 00                	push   $0x0
  801579:	6a 00                	push   $0x0
  80157b:	ff 75 08             	pushl  0x8(%ebp)
  80157e:	6a 0a                	push   $0xa
  801580:	e8 01 ff ff ff       	call   801486 <syscall>
  801585:	83 c4 18             	add    $0x18,%esp
}
  801588:	c9                   	leave  
  801589:	c3                   	ret    

0080158a <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  80158a:	55                   	push   %ebp
  80158b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  80158d:	6a 00                	push   $0x0
  80158f:	6a 00                	push   $0x0
  801591:	6a 00                	push   $0x0
  801593:	ff 75 0c             	pushl  0xc(%ebp)
  801596:	ff 75 08             	pushl  0x8(%ebp)
  801599:	6a 0b                	push   $0xb
  80159b:	e8 e6 fe ff ff       	call   801486 <syscall>
  8015a0:	83 c4 18             	add    $0x18,%esp
}
  8015a3:	c9                   	leave  
  8015a4:	c3                   	ret    

008015a5 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  8015a5:	55                   	push   %ebp
  8015a6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  8015a8:	6a 00                	push   $0x0
  8015aa:	6a 00                	push   $0x0
  8015ac:	6a 00                	push   $0x0
  8015ae:	6a 00                	push   $0x0
  8015b0:	6a 00                	push   $0x0
  8015b2:	6a 0c                	push   $0xc
  8015b4:	e8 cd fe ff ff       	call   801486 <syscall>
  8015b9:	83 c4 18             	add    $0x18,%esp
}
  8015bc:	c9                   	leave  
  8015bd:	c3                   	ret    

008015be <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  8015be:	55                   	push   %ebp
  8015bf:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  8015c1:	6a 00                	push   $0x0
  8015c3:	6a 00                	push   $0x0
  8015c5:	6a 00                	push   $0x0
  8015c7:	6a 00                	push   $0x0
  8015c9:	6a 00                	push   $0x0
  8015cb:	6a 0d                	push   $0xd
  8015cd:	e8 b4 fe ff ff       	call   801486 <syscall>
  8015d2:	83 c4 18             	add    $0x18,%esp
}
  8015d5:	c9                   	leave  
  8015d6:	c3                   	ret    

008015d7 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  8015d7:	55                   	push   %ebp
  8015d8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  8015da:	6a 00                	push   $0x0
  8015dc:	6a 00                	push   $0x0
  8015de:	6a 00                	push   $0x0
  8015e0:	6a 00                	push   $0x0
  8015e2:	6a 00                	push   $0x0
  8015e4:	6a 0e                	push   $0xe
  8015e6:	e8 9b fe ff ff       	call   801486 <syscall>
  8015eb:	83 c4 18             	add    $0x18,%esp
}
  8015ee:	c9                   	leave  
  8015ef:	c3                   	ret    

008015f0 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  8015f0:	55                   	push   %ebp
  8015f1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  8015f3:	6a 00                	push   $0x0
  8015f5:	6a 00                	push   $0x0
  8015f7:	6a 00                	push   $0x0
  8015f9:	6a 00                	push   $0x0
  8015fb:	6a 00                	push   $0x0
  8015fd:	6a 0f                	push   $0xf
  8015ff:	e8 82 fe ff ff       	call   801486 <syscall>
  801604:	83 c4 18             	add    $0x18,%esp
}
  801607:	c9                   	leave  
  801608:	c3                   	ret    

00801609 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801609:	55                   	push   %ebp
  80160a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  80160c:	6a 00                	push   $0x0
  80160e:	6a 00                	push   $0x0
  801610:	6a 00                	push   $0x0
  801612:	6a 00                	push   $0x0
  801614:	ff 75 08             	pushl  0x8(%ebp)
  801617:	6a 10                	push   $0x10
  801619:	e8 68 fe ff ff       	call   801486 <syscall>
  80161e:	83 c4 18             	add    $0x18,%esp
}
  801621:	c9                   	leave  
  801622:	c3                   	ret    

00801623 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801623:	55                   	push   %ebp
  801624:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801626:	6a 00                	push   $0x0
  801628:	6a 00                	push   $0x0
  80162a:	6a 00                	push   $0x0
  80162c:	6a 00                	push   $0x0
  80162e:	6a 00                	push   $0x0
  801630:	6a 11                	push   $0x11
  801632:	e8 4f fe ff ff       	call   801486 <syscall>
  801637:	83 c4 18             	add    $0x18,%esp
}
  80163a:	90                   	nop
  80163b:	c9                   	leave  
  80163c:	c3                   	ret    

0080163d <sys_cputc>:

void
sys_cputc(const char c)
{
  80163d:	55                   	push   %ebp
  80163e:	89 e5                	mov    %esp,%ebp
  801640:	83 ec 04             	sub    $0x4,%esp
  801643:	8b 45 08             	mov    0x8(%ebp),%eax
  801646:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801649:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  80164d:	6a 00                	push   $0x0
  80164f:	6a 00                	push   $0x0
  801651:	6a 00                	push   $0x0
  801653:	6a 00                	push   $0x0
  801655:	50                   	push   %eax
  801656:	6a 01                	push   $0x1
  801658:	e8 29 fe ff ff       	call   801486 <syscall>
  80165d:	83 c4 18             	add    $0x18,%esp
}
  801660:	90                   	nop
  801661:	c9                   	leave  
  801662:	c3                   	ret    

00801663 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801663:	55                   	push   %ebp
  801664:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801666:	6a 00                	push   $0x0
  801668:	6a 00                	push   $0x0
  80166a:	6a 00                	push   $0x0
  80166c:	6a 00                	push   $0x0
  80166e:	6a 00                	push   $0x0
  801670:	6a 14                	push   $0x14
  801672:	e8 0f fe ff ff       	call   801486 <syscall>
  801677:	83 c4 18             	add    $0x18,%esp
}
  80167a:	90                   	nop
  80167b:	c9                   	leave  
  80167c:	c3                   	ret    

0080167d <sys_create_shared_object>:

int sys_create_shared_object(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  80167d:	55                   	push   %ebp
  80167e:	89 e5                	mov    %esp,%ebp
  801680:	83 ec 04             	sub    $0x4,%esp
  801683:	8b 45 10             	mov    0x10(%ebp),%eax
  801686:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801689:	8b 4d 14             	mov    0x14(%ebp),%ecx
  80168c:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801690:	8b 45 08             	mov    0x8(%ebp),%eax
  801693:	6a 00                	push   $0x0
  801695:	51                   	push   %ecx
  801696:	52                   	push   %edx
  801697:	ff 75 0c             	pushl  0xc(%ebp)
  80169a:	50                   	push   %eax
  80169b:	6a 15                	push   $0x15
  80169d:	e8 e4 fd ff ff       	call   801486 <syscall>
  8016a2:	83 c4 18             	add    $0x18,%esp
}
  8016a5:	c9                   	leave  
  8016a6:	c3                   	ret    

008016a7 <sys_size_of_shared_object>:

//2017:
int sys_size_of_shared_object(int32 ownerID, char* shareName)
{
  8016a7:	55                   	push   %ebp
  8016a8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  8016aa:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8016b0:	6a 00                	push   $0x0
  8016b2:	6a 00                	push   $0x0
  8016b4:	6a 00                	push   $0x0
  8016b6:	52                   	push   %edx
  8016b7:	50                   	push   %eax
  8016b8:	6a 16                	push   $0x16
  8016ba:	e8 c7 fd ff ff       	call   801486 <syscall>
  8016bf:	83 c4 18             	add    $0x18,%esp
}
  8016c2:	c9                   	leave  
  8016c3:	c3                   	ret    

008016c4 <sys_get_shared_object>:
//==========

int sys_get_shared_object(int32 ownerID, char* shareName, void* virtual_address)
{
  8016c4:	55                   	push   %ebp
  8016c5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  8016c7:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8016ca:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8016d0:	6a 00                	push   $0x0
  8016d2:	6a 00                	push   $0x0
  8016d4:	51                   	push   %ecx
  8016d5:	52                   	push   %edx
  8016d6:	50                   	push   %eax
  8016d7:	6a 17                	push   $0x17
  8016d9:	e8 a8 fd ff ff       	call   801486 <syscall>
  8016de:	83 c4 18             	add    $0x18,%esp
}
  8016e1:	c9                   	leave  
  8016e2:	c3                   	ret    

008016e3 <sys_delete_shared_object>:

int sys_delete_shared_object(int32 sharedObjectID, void *startVA)
{
  8016e3:	55                   	push   %ebp
  8016e4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  8016e6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8016ec:	6a 00                	push   $0x0
  8016ee:	6a 00                	push   $0x0
  8016f0:	6a 00                	push   $0x0
  8016f2:	52                   	push   %edx
  8016f3:	50                   	push   %eax
  8016f4:	6a 18                	push   $0x18
  8016f6:	e8 8b fd ff ff       	call   801486 <syscall>
  8016fb:	83 c4 18             	add    $0x18,%esp
}
  8016fe:	c9                   	leave  
  8016ff:	c3                   	ret    

00801700 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801700:	55                   	push   %ebp
  801701:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801703:	8b 45 08             	mov    0x8(%ebp),%eax
  801706:	6a 00                	push   $0x0
  801708:	ff 75 14             	pushl  0x14(%ebp)
  80170b:	ff 75 10             	pushl  0x10(%ebp)
  80170e:	ff 75 0c             	pushl  0xc(%ebp)
  801711:	50                   	push   %eax
  801712:	6a 19                	push   $0x19
  801714:	e8 6d fd ff ff       	call   801486 <syscall>
  801719:	83 c4 18             	add    $0x18,%esp
}
  80171c:	c9                   	leave  
  80171d:	c3                   	ret    

0080171e <sys_run_env>:

void sys_run_env(int32 envId)
{
  80171e:	55                   	push   %ebp
  80171f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801721:	8b 45 08             	mov    0x8(%ebp),%eax
  801724:	6a 00                	push   $0x0
  801726:	6a 00                	push   $0x0
  801728:	6a 00                	push   $0x0
  80172a:	6a 00                	push   $0x0
  80172c:	50                   	push   %eax
  80172d:	6a 1a                	push   $0x1a
  80172f:	e8 52 fd ff ff       	call   801486 <syscall>
  801734:	83 c4 18             	add    $0x18,%esp
}
  801737:	90                   	nop
  801738:	c9                   	leave  
  801739:	c3                   	ret    

0080173a <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  80173a:	55                   	push   %ebp
  80173b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  80173d:	8b 45 08             	mov    0x8(%ebp),%eax
  801740:	6a 00                	push   $0x0
  801742:	6a 00                	push   $0x0
  801744:	6a 00                	push   $0x0
  801746:	6a 00                	push   $0x0
  801748:	50                   	push   %eax
  801749:	6a 1b                	push   $0x1b
  80174b:	e8 36 fd ff ff       	call   801486 <syscall>
  801750:	83 c4 18             	add    $0x18,%esp
}
  801753:	c9                   	leave  
  801754:	c3                   	ret    

00801755 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801755:	55                   	push   %ebp
  801756:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801758:	6a 00                	push   $0x0
  80175a:	6a 00                	push   $0x0
  80175c:	6a 00                	push   $0x0
  80175e:	6a 00                	push   $0x0
  801760:	6a 00                	push   $0x0
  801762:	6a 05                	push   $0x5
  801764:	e8 1d fd ff ff       	call   801486 <syscall>
  801769:	83 c4 18             	add    $0x18,%esp
}
  80176c:	c9                   	leave  
  80176d:	c3                   	ret    

0080176e <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  80176e:	55                   	push   %ebp
  80176f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801771:	6a 00                	push   $0x0
  801773:	6a 00                	push   $0x0
  801775:	6a 00                	push   $0x0
  801777:	6a 00                	push   $0x0
  801779:	6a 00                	push   $0x0
  80177b:	6a 06                	push   $0x6
  80177d:	e8 04 fd ff ff       	call   801486 <syscall>
  801782:	83 c4 18             	add    $0x18,%esp
}
  801785:	c9                   	leave  
  801786:	c3                   	ret    

00801787 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801787:	55                   	push   %ebp
  801788:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  80178a:	6a 00                	push   $0x0
  80178c:	6a 00                	push   $0x0
  80178e:	6a 00                	push   $0x0
  801790:	6a 00                	push   $0x0
  801792:	6a 00                	push   $0x0
  801794:	6a 07                	push   $0x7
  801796:	e8 eb fc ff ff       	call   801486 <syscall>
  80179b:	83 c4 18             	add    $0x18,%esp
}
  80179e:	c9                   	leave  
  80179f:	c3                   	ret    

008017a0 <sys_exit_env>:


void sys_exit_env(void)
{
  8017a0:	55                   	push   %ebp
  8017a1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  8017a3:	6a 00                	push   $0x0
  8017a5:	6a 00                	push   $0x0
  8017a7:	6a 00                	push   $0x0
  8017a9:	6a 00                	push   $0x0
  8017ab:	6a 00                	push   $0x0
  8017ad:	6a 1c                	push   $0x1c
  8017af:	e8 d2 fc ff ff       	call   801486 <syscall>
  8017b4:	83 c4 18             	add    $0x18,%esp
}
  8017b7:	90                   	nop
  8017b8:	c9                   	leave  
  8017b9:	c3                   	ret    

008017ba <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  8017ba:	55                   	push   %ebp
  8017bb:	89 e5                	mov    %esp,%ebp
  8017bd:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  8017c0:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8017c3:	8d 50 04             	lea    0x4(%eax),%edx
  8017c6:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8017c9:	6a 00                	push   $0x0
  8017cb:	6a 00                	push   $0x0
  8017cd:	6a 00                	push   $0x0
  8017cf:	52                   	push   %edx
  8017d0:	50                   	push   %eax
  8017d1:	6a 1d                	push   $0x1d
  8017d3:	e8 ae fc ff ff       	call   801486 <syscall>
  8017d8:	83 c4 18             	add    $0x18,%esp
	return result;
  8017db:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8017de:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8017e1:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8017e4:	89 01                	mov    %eax,(%ecx)
  8017e6:	89 51 04             	mov    %edx,0x4(%ecx)
}
  8017e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8017ec:	c9                   	leave  
  8017ed:	c2 04 00             	ret    $0x4

008017f0 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  8017f0:	55                   	push   %ebp
  8017f1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  8017f3:	6a 00                	push   $0x0
  8017f5:	6a 00                	push   $0x0
  8017f7:	ff 75 10             	pushl  0x10(%ebp)
  8017fa:	ff 75 0c             	pushl  0xc(%ebp)
  8017fd:	ff 75 08             	pushl  0x8(%ebp)
  801800:	6a 13                	push   $0x13
  801802:	e8 7f fc ff ff       	call   801486 <syscall>
  801807:	83 c4 18             	add    $0x18,%esp
	return ;
  80180a:	90                   	nop
}
  80180b:	c9                   	leave  
  80180c:	c3                   	ret    

0080180d <sys_rcr2>:
uint32 sys_rcr2()
{
  80180d:	55                   	push   %ebp
  80180e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801810:	6a 00                	push   $0x0
  801812:	6a 00                	push   $0x0
  801814:	6a 00                	push   $0x0
  801816:	6a 00                	push   $0x0
  801818:	6a 00                	push   $0x0
  80181a:	6a 1e                	push   $0x1e
  80181c:	e8 65 fc ff ff       	call   801486 <syscall>
  801821:	83 c4 18             	add    $0x18,%esp
}
  801824:	c9                   	leave  
  801825:	c3                   	ret    

00801826 <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  801826:	55                   	push   %ebp
  801827:	89 e5                	mov    %esp,%ebp
  801829:	83 ec 04             	sub    $0x4,%esp
  80182c:	8b 45 08             	mov    0x8(%ebp),%eax
  80182f:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801832:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801836:	6a 00                	push   $0x0
  801838:	6a 00                	push   $0x0
  80183a:	6a 00                	push   $0x0
  80183c:	6a 00                	push   $0x0
  80183e:	50                   	push   %eax
  80183f:	6a 1f                	push   $0x1f
  801841:	e8 40 fc ff ff       	call   801486 <syscall>
  801846:	83 c4 18             	add    $0x18,%esp
	return ;
  801849:	90                   	nop
}
  80184a:	c9                   	leave  
  80184b:	c3                   	ret    

0080184c <rsttst>:
void rsttst()
{
  80184c:	55                   	push   %ebp
  80184d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  80184f:	6a 00                	push   $0x0
  801851:	6a 00                	push   $0x0
  801853:	6a 00                	push   $0x0
  801855:	6a 00                	push   $0x0
  801857:	6a 00                	push   $0x0
  801859:	6a 21                	push   $0x21
  80185b:	e8 26 fc ff ff       	call   801486 <syscall>
  801860:	83 c4 18             	add    $0x18,%esp
	return ;
  801863:	90                   	nop
}
  801864:	c9                   	leave  
  801865:	c3                   	ret    

00801866 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801866:	55                   	push   %ebp
  801867:	89 e5                	mov    %esp,%ebp
  801869:	83 ec 04             	sub    $0x4,%esp
  80186c:	8b 45 14             	mov    0x14(%ebp),%eax
  80186f:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801872:	8b 55 18             	mov    0x18(%ebp),%edx
  801875:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801879:	52                   	push   %edx
  80187a:	50                   	push   %eax
  80187b:	ff 75 10             	pushl  0x10(%ebp)
  80187e:	ff 75 0c             	pushl  0xc(%ebp)
  801881:	ff 75 08             	pushl  0x8(%ebp)
  801884:	6a 20                	push   $0x20
  801886:	e8 fb fb ff ff       	call   801486 <syscall>
  80188b:	83 c4 18             	add    $0x18,%esp
	return ;
  80188e:	90                   	nop
}
  80188f:	c9                   	leave  
  801890:	c3                   	ret    

00801891 <chktst>:
void chktst(uint32 n)
{
  801891:	55                   	push   %ebp
  801892:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801894:	6a 00                	push   $0x0
  801896:	6a 00                	push   $0x0
  801898:	6a 00                	push   $0x0
  80189a:	6a 00                	push   $0x0
  80189c:	ff 75 08             	pushl  0x8(%ebp)
  80189f:	6a 22                	push   $0x22
  8018a1:	e8 e0 fb ff ff       	call   801486 <syscall>
  8018a6:	83 c4 18             	add    $0x18,%esp
	return ;
  8018a9:	90                   	nop
}
  8018aa:	c9                   	leave  
  8018ab:	c3                   	ret    

008018ac <inctst>:

void inctst()
{
  8018ac:	55                   	push   %ebp
  8018ad:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  8018af:	6a 00                	push   $0x0
  8018b1:	6a 00                	push   $0x0
  8018b3:	6a 00                	push   $0x0
  8018b5:	6a 00                	push   $0x0
  8018b7:	6a 00                	push   $0x0
  8018b9:	6a 23                	push   $0x23
  8018bb:	e8 c6 fb ff ff       	call   801486 <syscall>
  8018c0:	83 c4 18             	add    $0x18,%esp
	return ;
  8018c3:	90                   	nop
}
  8018c4:	c9                   	leave  
  8018c5:	c3                   	ret    

008018c6 <gettst>:
uint32 gettst()
{
  8018c6:	55                   	push   %ebp
  8018c7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  8018c9:	6a 00                	push   $0x0
  8018cb:	6a 00                	push   $0x0
  8018cd:	6a 00                	push   $0x0
  8018cf:	6a 00                	push   $0x0
  8018d1:	6a 00                	push   $0x0
  8018d3:	6a 24                	push   $0x24
  8018d5:	e8 ac fb ff ff       	call   801486 <syscall>
  8018da:	83 c4 18             	add    $0x18,%esp
}
  8018dd:	c9                   	leave  
  8018de:	c3                   	ret    

008018df <sys_get_uheap_strategy>:

/*2025*/
uint32 sys_get_uheap_strategy()
{
  8018df:	55                   	push   %ebp
  8018e0:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8018e2:	6a 00                	push   $0x0
  8018e4:	6a 00                	push   $0x0
  8018e6:	6a 00                	push   $0x0
  8018e8:	6a 00                	push   $0x0
  8018ea:	6a 00                	push   $0x0
  8018ec:	6a 25                	push   $0x25
  8018ee:	e8 93 fb ff ff       	call   801486 <syscall>
  8018f3:	83 c4 18             	add    $0x18,%esp
  8018f6:	a3 60 b0 81 00       	mov    %eax,0x81b060
	return uheapPlaceStrategy ;
  8018fb:	a1 60 b0 81 00       	mov    0x81b060,%eax
}
  801900:	c9                   	leave  
  801901:	c3                   	ret    

00801902 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801902:	55                   	push   %ebp
  801903:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = heapStrategy;
  801905:	8b 45 08             	mov    0x8(%ebp),%eax
  801908:	a3 60 b0 81 00       	mov    %eax,0x81b060
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  80190d:	6a 00                	push   $0x0
  80190f:	6a 00                	push   $0x0
  801911:	6a 00                	push   $0x0
  801913:	6a 00                	push   $0x0
  801915:	ff 75 08             	pushl  0x8(%ebp)
  801918:	6a 26                	push   $0x26
  80191a:	e8 67 fb ff ff       	call   801486 <syscall>
  80191f:	83 c4 18             	add    $0x18,%esp
	return ;
  801922:	90                   	nop
}
  801923:	c9                   	leave  
  801924:	c3                   	ret    

00801925 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801925:	55                   	push   %ebp
  801926:	89 e5                	mov    %esp,%ebp
  801928:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801929:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80192c:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80192f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801932:	8b 45 08             	mov    0x8(%ebp),%eax
  801935:	6a 00                	push   $0x0
  801937:	53                   	push   %ebx
  801938:	51                   	push   %ecx
  801939:	52                   	push   %edx
  80193a:	50                   	push   %eax
  80193b:	6a 27                	push   $0x27
  80193d:	e8 44 fb ff ff       	call   801486 <syscall>
  801942:	83 c4 18             	add    $0x18,%esp
}
  801945:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801948:	c9                   	leave  
  801949:	c3                   	ret    

0080194a <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  80194a:	55                   	push   %ebp
  80194b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  80194d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801950:	8b 45 08             	mov    0x8(%ebp),%eax
  801953:	6a 00                	push   $0x0
  801955:	6a 00                	push   $0x0
  801957:	6a 00                	push   $0x0
  801959:	52                   	push   %edx
  80195a:	50                   	push   %eax
  80195b:	6a 28                	push   $0x28
  80195d:	e8 24 fb ff ff       	call   801486 <syscall>
  801962:	83 c4 18             	add    $0x18,%esp
}
  801965:	c9                   	leave  
  801966:	c3                   	ret    

00801967 <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  801967:	55                   	push   %ebp
  801968:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  80196a:	8b 4d 14             	mov    0x14(%ebp),%ecx
  80196d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801970:	8b 45 08             	mov    0x8(%ebp),%eax
  801973:	6a 00                	push   $0x0
  801975:	51                   	push   %ecx
  801976:	ff 75 10             	pushl  0x10(%ebp)
  801979:	52                   	push   %edx
  80197a:	50                   	push   %eax
  80197b:	6a 29                	push   $0x29
  80197d:	e8 04 fb ff ff       	call   801486 <syscall>
  801982:	83 c4 18             	add    $0x18,%esp
}
  801985:	c9                   	leave  
  801986:	c3                   	ret    

00801987 <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801987:	55                   	push   %ebp
  801988:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  80198a:	6a 00                	push   $0x0
  80198c:	6a 00                	push   $0x0
  80198e:	ff 75 10             	pushl  0x10(%ebp)
  801991:	ff 75 0c             	pushl  0xc(%ebp)
  801994:	ff 75 08             	pushl  0x8(%ebp)
  801997:	6a 12                	push   $0x12
  801999:	e8 e8 fa ff ff       	call   801486 <syscall>
  80199e:	83 c4 18             	add    $0x18,%esp
	return ;
  8019a1:	90                   	nop
}
  8019a2:	c9                   	leave  
  8019a3:	c3                   	ret    

008019a4 <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  8019a4:	55                   	push   %ebp
  8019a5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  8019a7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8019ad:	6a 00                	push   $0x0
  8019af:	6a 00                	push   $0x0
  8019b1:	6a 00                	push   $0x0
  8019b3:	52                   	push   %edx
  8019b4:	50                   	push   %eax
  8019b5:	6a 2a                	push   $0x2a
  8019b7:	e8 ca fa ff ff       	call   801486 <syscall>
  8019bc:	83 c4 18             	add    $0x18,%esp
	return;
  8019bf:	90                   	nop
}
  8019c0:	c9                   	leave  
  8019c1:	c3                   	ret    

008019c2 <sys_get_optimal_num_faults>:
/*2025*/
int sys_get_optimal_num_faults()
{
  8019c2:	55                   	push   %ebp
  8019c3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_optimal_num_faults, 0, 0, 0, 0, 0);
  8019c5:	6a 00                	push   $0x0
  8019c7:	6a 00                	push   $0x0
  8019c9:	6a 00                	push   $0x0
  8019cb:	6a 00                	push   $0x0
  8019cd:	6a 00                	push   $0x0
  8019cf:	6a 2b                	push   $0x2b
  8019d1:	e8 b0 fa ff ff       	call   801486 <syscall>
  8019d6:	83 c4 18             	add    $0x18,%esp
}
  8019d9:	c9                   	leave  
  8019da:	c3                   	ret    

008019db <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  8019db:	55                   	push   %ebp
  8019dc:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  8019de:	6a 00                	push   $0x0
  8019e0:	6a 00                	push   $0x0
  8019e2:	6a 00                	push   $0x0
  8019e4:	ff 75 0c             	pushl  0xc(%ebp)
  8019e7:	ff 75 08             	pushl  0x8(%ebp)
  8019ea:	6a 2d                	push   $0x2d
  8019ec:	e8 95 fa ff ff       	call   801486 <syscall>
  8019f1:	83 c4 18             	add    $0x18,%esp
	return;
  8019f4:	90                   	nop
}
  8019f5:	c9                   	leave  
  8019f6:	c3                   	ret    

008019f7 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  8019f7:	55                   	push   %ebp
  8019f8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  8019fa:	6a 00                	push   $0x0
  8019fc:	6a 00                	push   $0x0
  8019fe:	6a 00                	push   $0x0
  801a00:	ff 75 0c             	pushl  0xc(%ebp)
  801a03:	ff 75 08             	pushl  0x8(%ebp)
  801a06:	6a 2c                	push   $0x2c
  801a08:	e8 79 fa ff ff       	call   801486 <syscall>
  801a0d:	83 c4 18             	add    $0x18,%esp
	return ;
  801a10:	90                   	nop
}
  801a11:	c9                   	leave  
  801a12:	c3                   	ret    

00801a13 <sys_env_set_priority>:


void sys_env_set_priority(int32 envID, int priority)
{
  801a13:	55                   	push   %ebp
  801a14:	89 e5                	mov    %esp,%ebp
  801a16:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.IM#4] CPU SCHEDULING - #1 System Calls - Add suitable code here
	//Your code is here
	//Comment the following line
	panic("sys_env_set_priority() is not implemented yet...!!");
  801a19:	83 ec 04             	sub    $0x4,%esp
  801a1c:	68 1c 24 80 00       	push   $0x80241c
  801a21:	68 25 01 00 00       	push   $0x125
  801a26:	68 4f 24 80 00       	push   $0x80244f
  801a2b:	e8 3c 00 00 00       	call   801a6c <_panic>

00801a30 <cputchar>:
#include <inc/lib.h>


void
cputchar(int ch)
{
  801a30:	55                   	push   %ebp
  801a31:	89 e5                	mov    %esp,%ebp
  801a33:	83 ec 18             	sub    $0x18,%esp
	char c = ch;
  801a36:	8b 45 08             	mov    0x8(%ebp),%eax
  801a39:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	//sys_cputs(&c, 1);

	sys_cputc(c);
  801a3c:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  801a40:	83 ec 0c             	sub    $0xc,%esp
  801a43:	50                   	push   %eax
  801a44:	e8 f4 fb ff ff       	call   80163d <sys_cputc>
  801a49:	83 c4 10             	add    $0x10,%esp
}
  801a4c:	90                   	nop
  801a4d:	c9                   	leave  
  801a4e:	c3                   	ret    

00801a4f <getchar>:


int
getchar(void)
{
  801a4f:	55                   	push   %ebp
  801a50:	89 e5                	mov    %esp,%ebp
  801a52:	83 ec 18             	sub    $0x18,%esp
	int c =sys_cgetc();
  801a55:	e8 82 fa ff ff       	call   8014dc <sys_cgetc>
  801a5a:	89 45 f4             	mov    %eax,-0xc(%ebp)
	return c;
  801a5d:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  801a60:	c9                   	leave  
  801a61:	c3                   	ret    

00801a62 <iscons>:

int iscons(int fdnum)
{
  801a62:	55                   	push   %ebp
  801a63:	89 e5                	mov    %esp,%ebp
	// used by readline
	return 1;
  801a65:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801a6a:	5d                   	pop    %ebp
  801a6b:	c3                   	ret    

00801a6c <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  801a6c:	55                   	push   %ebp
  801a6d:	89 e5                	mov    %esp,%ebp
  801a6f:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  801a72:	8d 45 10             	lea    0x10(%ebp),%eax
  801a75:	83 c0 04             	add    $0x4,%eax
  801a78:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  801a7b:	a1 1c b1 81 00       	mov    0x81b11c,%eax
  801a80:	85 c0                	test   %eax,%eax
  801a82:	74 16                	je     801a9a <_panic+0x2e>
		cprintf("%s: ", argv0);
  801a84:	a1 1c b1 81 00       	mov    0x81b11c,%eax
  801a89:	83 ec 08             	sub    $0x8,%esp
  801a8c:	50                   	push   %eax
  801a8d:	68 60 24 80 00       	push   $0x802460
  801a92:	e8 02 e9 ff ff       	call   800399 <cprintf>
  801a97:	83 c4 10             	add    $0x10,%esp
	cprintf_colored(TEXT_PANIC_CLR, "user [EVAL_FINAL]panic in %s at %s:%d: ", binaryname, file, line);
  801a9a:	a1 04 30 80 00       	mov    0x803004,%eax
  801a9f:	83 ec 0c             	sub    $0xc,%esp
  801aa2:	ff 75 0c             	pushl  0xc(%ebp)
  801aa5:	ff 75 08             	pushl  0x8(%ebp)
  801aa8:	50                   	push   %eax
  801aa9:	68 68 24 80 00       	push   $0x802468
  801aae:	6a 74                	push   $0x74
  801ab0:	e8 11 e9 ff ff       	call   8003c6 <cprintf_colored>
  801ab5:	83 c4 20             	add    $0x20,%esp
	vcprintf(fmt, ap);
  801ab8:	8b 45 10             	mov    0x10(%ebp),%eax
  801abb:	83 ec 08             	sub    $0x8,%esp
  801abe:	ff 75 f4             	pushl  -0xc(%ebp)
  801ac1:	50                   	push   %eax
  801ac2:	e8 63 e8 ff ff       	call   80032a <vcprintf>
  801ac7:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  801aca:	83 ec 08             	sub    $0x8,%esp
  801acd:	6a 00                	push   $0x0
  801acf:	68 90 24 80 00       	push   $0x802490
  801ad4:	e8 51 e8 ff ff       	call   80032a <vcprintf>
  801ad9:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  801adc:	e8 ca e7 ff ff       	call   8002ab <exit>

	// should not return here
	while (1) ;
  801ae1:	eb fe                	jmp    801ae1 <_panic+0x75>

00801ae3 <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  801ae3:	55                   	push   %ebp
  801ae4:	89 e5                	mov    %esp,%ebp
  801ae6:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  801ae9:	a1 20 30 80 00       	mov    0x803020,%eax
  801aee:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  801af4:	8b 45 0c             	mov    0xc(%ebp),%eax
  801af7:	39 c2                	cmp    %eax,%edx
  801af9:	74 14                	je     801b0f <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  801afb:	83 ec 04             	sub    $0x4,%esp
  801afe:	68 94 24 80 00       	push   $0x802494
  801b03:	6a 26                	push   $0x26
  801b05:	68 e0 24 80 00       	push   $0x8024e0
  801b0a:	e8 5d ff ff ff       	call   801a6c <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  801b0f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  801b16:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  801b1d:	e9 c5 00 00 00       	jmp    801be7 <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  801b22:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801b25:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801b2c:	8b 45 08             	mov    0x8(%ebp),%eax
  801b2f:	01 d0                	add    %edx,%eax
  801b31:	8b 00                	mov    (%eax),%eax
  801b33:	85 c0                	test   %eax,%eax
  801b35:	75 08                	jne    801b3f <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  801b37:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  801b3a:	e9 a5 00 00 00       	jmp    801be4 <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  801b3f:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  801b46:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  801b4d:	eb 69                	jmp    801bb8 <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  801b4f:	a1 20 30 80 00       	mov    0x803020,%eax
  801b54:	8b 88 38 da 01 00    	mov    0x1da38(%eax),%ecx
  801b5a:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801b5d:	89 d0                	mov    %edx,%eax
  801b5f:	01 c0                	add    %eax,%eax
  801b61:	01 d0                	add    %edx,%eax
  801b63:	c1 e0 03             	shl    $0x3,%eax
  801b66:	01 c8                	add    %ecx,%eax
  801b68:	8a 40 04             	mov    0x4(%eax),%al
  801b6b:	84 c0                	test   %al,%al
  801b6d:	75 46                	jne    801bb5 <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  801b6f:	a1 20 30 80 00       	mov    0x803020,%eax
  801b74:	8b 88 38 da 01 00    	mov    0x1da38(%eax),%ecx
  801b7a:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801b7d:	89 d0                	mov    %edx,%eax
  801b7f:	01 c0                	add    %eax,%eax
  801b81:	01 d0                	add    %edx,%eax
  801b83:	c1 e0 03             	shl    $0x3,%eax
  801b86:	01 c8                	add    %ecx,%eax
  801b88:	8b 00                	mov    (%eax),%eax
  801b8a:	89 45 dc             	mov    %eax,-0x24(%ebp)
  801b8d:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801b90:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801b95:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  801b97:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801b9a:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  801ba1:	8b 45 08             	mov    0x8(%ebp),%eax
  801ba4:	01 c8                	add    %ecx,%eax
  801ba6:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  801ba8:	39 c2                	cmp    %eax,%edx
  801baa:	75 09                	jne    801bb5 <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  801bac:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  801bb3:	eb 15                	jmp    801bca <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  801bb5:	ff 45 e8             	incl   -0x18(%ebp)
  801bb8:	a1 20 30 80 00       	mov    0x803020,%eax
  801bbd:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  801bc3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801bc6:	39 c2                	cmp    %eax,%edx
  801bc8:	77 85                	ja     801b4f <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  801bca:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801bce:	75 14                	jne    801be4 <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  801bd0:	83 ec 04             	sub    $0x4,%esp
  801bd3:	68 ec 24 80 00       	push   $0x8024ec
  801bd8:	6a 3a                	push   $0x3a
  801bda:	68 e0 24 80 00       	push   $0x8024e0
  801bdf:	e8 88 fe ff ff       	call   801a6c <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  801be4:	ff 45 f0             	incl   -0x10(%ebp)
  801be7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801bea:	3b 45 0c             	cmp    0xc(%ebp),%eax
  801bed:	0f 8c 2f ff ff ff    	jl     801b22 <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  801bf3:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  801bfa:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  801c01:	eb 26                	jmp    801c29 <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  801c03:	a1 20 30 80 00       	mov    0x803020,%eax
  801c08:	8b 88 38 da 01 00    	mov    0x1da38(%eax),%ecx
  801c0e:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801c11:	89 d0                	mov    %edx,%eax
  801c13:	01 c0                	add    %eax,%eax
  801c15:	01 d0                	add    %edx,%eax
  801c17:	c1 e0 03             	shl    $0x3,%eax
  801c1a:	01 c8                	add    %ecx,%eax
  801c1c:	8a 40 04             	mov    0x4(%eax),%al
  801c1f:	3c 01                	cmp    $0x1,%al
  801c21:	75 03                	jne    801c26 <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  801c23:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  801c26:	ff 45 e0             	incl   -0x20(%ebp)
  801c29:	a1 20 30 80 00       	mov    0x803020,%eax
  801c2e:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  801c34:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801c37:	39 c2                	cmp    %eax,%edx
  801c39:	77 c8                	ja     801c03 <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  801c3b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c3e:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  801c41:	74 14                	je     801c57 <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  801c43:	83 ec 04             	sub    $0x4,%esp
  801c46:	68 40 25 80 00       	push   $0x802540
  801c4b:	6a 44                	push   $0x44
  801c4d:	68 e0 24 80 00       	push   $0x8024e0
  801c52:	e8 15 fe ff ff       	call   801a6c <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  801c57:	90                   	nop
  801c58:	c9                   	leave  
  801c59:	c3                   	ret    
  801c5a:	66 90                	xchg   %ax,%ax

00801c5c <__udivdi3>:
  801c5c:	55                   	push   %ebp
  801c5d:	57                   	push   %edi
  801c5e:	56                   	push   %esi
  801c5f:	53                   	push   %ebx
  801c60:	83 ec 1c             	sub    $0x1c,%esp
  801c63:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  801c67:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  801c6b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801c6f:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801c73:	89 ca                	mov    %ecx,%edx
  801c75:	89 f8                	mov    %edi,%eax
  801c77:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  801c7b:	85 f6                	test   %esi,%esi
  801c7d:	75 2d                	jne    801cac <__udivdi3+0x50>
  801c7f:	39 cf                	cmp    %ecx,%edi
  801c81:	77 65                	ja     801ce8 <__udivdi3+0x8c>
  801c83:	89 fd                	mov    %edi,%ebp
  801c85:	85 ff                	test   %edi,%edi
  801c87:	75 0b                	jne    801c94 <__udivdi3+0x38>
  801c89:	b8 01 00 00 00       	mov    $0x1,%eax
  801c8e:	31 d2                	xor    %edx,%edx
  801c90:	f7 f7                	div    %edi
  801c92:	89 c5                	mov    %eax,%ebp
  801c94:	31 d2                	xor    %edx,%edx
  801c96:	89 c8                	mov    %ecx,%eax
  801c98:	f7 f5                	div    %ebp
  801c9a:	89 c1                	mov    %eax,%ecx
  801c9c:	89 d8                	mov    %ebx,%eax
  801c9e:	f7 f5                	div    %ebp
  801ca0:	89 cf                	mov    %ecx,%edi
  801ca2:	89 fa                	mov    %edi,%edx
  801ca4:	83 c4 1c             	add    $0x1c,%esp
  801ca7:	5b                   	pop    %ebx
  801ca8:	5e                   	pop    %esi
  801ca9:	5f                   	pop    %edi
  801caa:	5d                   	pop    %ebp
  801cab:	c3                   	ret    
  801cac:	39 ce                	cmp    %ecx,%esi
  801cae:	77 28                	ja     801cd8 <__udivdi3+0x7c>
  801cb0:	0f bd fe             	bsr    %esi,%edi
  801cb3:	83 f7 1f             	xor    $0x1f,%edi
  801cb6:	75 40                	jne    801cf8 <__udivdi3+0x9c>
  801cb8:	39 ce                	cmp    %ecx,%esi
  801cba:	72 0a                	jb     801cc6 <__udivdi3+0x6a>
  801cbc:	3b 44 24 08          	cmp    0x8(%esp),%eax
  801cc0:	0f 87 9e 00 00 00    	ja     801d64 <__udivdi3+0x108>
  801cc6:	b8 01 00 00 00       	mov    $0x1,%eax
  801ccb:	89 fa                	mov    %edi,%edx
  801ccd:	83 c4 1c             	add    $0x1c,%esp
  801cd0:	5b                   	pop    %ebx
  801cd1:	5e                   	pop    %esi
  801cd2:	5f                   	pop    %edi
  801cd3:	5d                   	pop    %ebp
  801cd4:	c3                   	ret    
  801cd5:	8d 76 00             	lea    0x0(%esi),%esi
  801cd8:	31 ff                	xor    %edi,%edi
  801cda:	31 c0                	xor    %eax,%eax
  801cdc:	89 fa                	mov    %edi,%edx
  801cde:	83 c4 1c             	add    $0x1c,%esp
  801ce1:	5b                   	pop    %ebx
  801ce2:	5e                   	pop    %esi
  801ce3:	5f                   	pop    %edi
  801ce4:	5d                   	pop    %ebp
  801ce5:	c3                   	ret    
  801ce6:	66 90                	xchg   %ax,%ax
  801ce8:	89 d8                	mov    %ebx,%eax
  801cea:	f7 f7                	div    %edi
  801cec:	31 ff                	xor    %edi,%edi
  801cee:	89 fa                	mov    %edi,%edx
  801cf0:	83 c4 1c             	add    $0x1c,%esp
  801cf3:	5b                   	pop    %ebx
  801cf4:	5e                   	pop    %esi
  801cf5:	5f                   	pop    %edi
  801cf6:	5d                   	pop    %ebp
  801cf7:	c3                   	ret    
  801cf8:	bd 20 00 00 00       	mov    $0x20,%ebp
  801cfd:	89 eb                	mov    %ebp,%ebx
  801cff:	29 fb                	sub    %edi,%ebx
  801d01:	89 f9                	mov    %edi,%ecx
  801d03:	d3 e6                	shl    %cl,%esi
  801d05:	89 c5                	mov    %eax,%ebp
  801d07:	88 d9                	mov    %bl,%cl
  801d09:	d3 ed                	shr    %cl,%ebp
  801d0b:	89 e9                	mov    %ebp,%ecx
  801d0d:	09 f1                	or     %esi,%ecx
  801d0f:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  801d13:	89 f9                	mov    %edi,%ecx
  801d15:	d3 e0                	shl    %cl,%eax
  801d17:	89 c5                	mov    %eax,%ebp
  801d19:	89 d6                	mov    %edx,%esi
  801d1b:	88 d9                	mov    %bl,%cl
  801d1d:	d3 ee                	shr    %cl,%esi
  801d1f:	89 f9                	mov    %edi,%ecx
  801d21:	d3 e2                	shl    %cl,%edx
  801d23:	8b 44 24 08          	mov    0x8(%esp),%eax
  801d27:	88 d9                	mov    %bl,%cl
  801d29:	d3 e8                	shr    %cl,%eax
  801d2b:	09 c2                	or     %eax,%edx
  801d2d:	89 d0                	mov    %edx,%eax
  801d2f:	89 f2                	mov    %esi,%edx
  801d31:	f7 74 24 0c          	divl   0xc(%esp)
  801d35:	89 d6                	mov    %edx,%esi
  801d37:	89 c3                	mov    %eax,%ebx
  801d39:	f7 e5                	mul    %ebp
  801d3b:	39 d6                	cmp    %edx,%esi
  801d3d:	72 19                	jb     801d58 <__udivdi3+0xfc>
  801d3f:	74 0b                	je     801d4c <__udivdi3+0xf0>
  801d41:	89 d8                	mov    %ebx,%eax
  801d43:	31 ff                	xor    %edi,%edi
  801d45:	e9 58 ff ff ff       	jmp    801ca2 <__udivdi3+0x46>
  801d4a:	66 90                	xchg   %ax,%ax
  801d4c:	8b 54 24 08          	mov    0x8(%esp),%edx
  801d50:	89 f9                	mov    %edi,%ecx
  801d52:	d3 e2                	shl    %cl,%edx
  801d54:	39 c2                	cmp    %eax,%edx
  801d56:	73 e9                	jae    801d41 <__udivdi3+0xe5>
  801d58:	8d 43 ff             	lea    -0x1(%ebx),%eax
  801d5b:	31 ff                	xor    %edi,%edi
  801d5d:	e9 40 ff ff ff       	jmp    801ca2 <__udivdi3+0x46>
  801d62:	66 90                	xchg   %ax,%ax
  801d64:	31 c0                	xor    %eax,%eax
  801d66:	e9 37 ff ff ff       	jmp    801ca2 <__udivdi3+0x46>
  801d6b:	90                   	nop

00801d6c <__umoddi3>:
  801d6c:	55                   	push   %ebp
  801d6d:	57                   	push   %edi
  801d6e:	56                   	push   %esi
  801d6f:	53                   	push   %ebx
  801d70:	83 ec 1c             	sub    $0x1c,%esp
  801d73:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  801d77:	8b 74 24 34          	mov    0x34(%esp),%esi
  801d7b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801d7f:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  801d83:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801d87:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801d8b:	89 f3                	mov    %esi,%ebx
  801d8d:	89 fa                	mov    %edi,%edx
  801d8f:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801d93:	89 34 24             	mov    %esi,(%esp)
  801d96:	85 c0                	test   %eax,%eax
  801d98:	75 1a                	jne    801db4 <__umoddi3+0x48>
  801d9a:	39 f7                	cmp    %esi,%edi
  801d9c:	0f 86 a2 00 00 00    	jbe    801e44 <__umoddi3+0xd8>
  801da2:	89 c8                	mov    %ecx,%eax
  801da4:	89 f2                	mov    %esi,%edx
  801da6:	f7 f7                	div    %edi
  801da8:	89 d0                	mov    %edx,%eax
  801daa:	31 d2                	xor    %edx,%edx
  801dac:	83 c4 1c             	add    $0x1c,%esp
  801daf:	5b                   	pop    %ebx
  801db0:	5e                   	pop    %esi
  801db1:	5f                   	pop    %edi
  801db2:	5d                   	pop    %ebp
  801db3:	c3                   	ret    
  801db4:	39 f0                	cmp    %esi,%eax
  801db6:	0f 87 ac 00 00 00    	ja     801e68 <__umoddi3+0xfc>
  801dbc:	0f bd e8             	bsr    %eax,%ebp
  801dbf:	83 f5 1f             	xor    $0x1f,%ebp
  801dc2:	0f 84 ac 00 00 00    	je     801e74 <__umoddi3+0x108>
  801dc8:	bf 20 00 00 00       	mov    $0x20,%edi
  801dcd:	29 ef                	sub    %ebp,%edi
  801dcf:	89 fe                	mov    %edi,%esi
  801dd1:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801dd5:	89 e9                	mov    %ebp,%ecx
  801dd7:	d3 e0                	shl    %cl,%eax
  801dd9:	89 d7                	mov    %edx,%edi
  801ddb:	89 f1                	mov    %esi,%ecx
  801ddd:	d3 ef                	shr    %cl,%edi
  801ddf:	09 c7                	or     %eax,%edi
  801de1:	89 e9                	mov    %ebp,%ecx
  801de3:	d3 e2                	shl    %cl,%edx
  801de5:	89 14 24             	mov    %edx,(%esp)
  801de8:	89 d8                	mov    %ebx,%eax
  801dea:	d3 e0                	shl    %cl,%eax
  801dec:	89 c2                	mov    %eax,%edx
  801dee:	8b 44 24 08          	mov    0x8(%esp),%eax
  801df2:	d3 e0                	shl    %cl,%eax
  801df4:	89 44 24 04          	mov    %eax,0x4(%esp)
  801df8:	8b 44 24 08          	mov    0x8(%esp),%eax
  801dfc:	89 f1                	mov    %esi,%ecx
  801dfe:	d3 e8                	shr    %cl,%eax
  801e00:	09 d0                	or     %edx,%eax
  801e02:	d3 eb                	shr    %cl,%ebx
  801e04:	89 da                	mov    %ebx,%edx
  801e06:	f7 f7                	div    %edi
  801e08:	89 d3                	mov    %edx,%ebx
  801e0a:	f7 24 24             	mull   (%esp)
  801e0d:	89 c6                	mov    %eax,%esi
  801e0f:	89 d1                	mov    %edx,%ecx
  801e11:	39 d3                	cmp    %edx,%ebx
  801e13:	0f 82 87 00 00 00    	jb     801ea0 <__umoddi3+0x134>
  801e19:	0f 84 91 00 00 00    	je     801eb0 <__umoddi3+0x144>
  801e1f:	8b 54 24 04          	mov    0x4(%esp),%edx
  801e23:	29 f2                	sub    %esi,%edx
  801e25:	19 cb                	sbb    %ecx,%ebx
  801e27:	89 d8                	mov    %ebx,%eax
  801e29:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  801e2d:	d3 e0                	shl    %cl,%eax
  801e2f:	89 e9                	mov    %ebp,%ecx
  801e31:	d3 ea                	shr    %cl,%edx
  801e33:	09 d0                	or     %edx,%eax
  801e35:	89 e9                	mov    %ebp,%ecx
  801e37:	d3 eb                	shr    %cl,%ebx
  801e39:	89 da                	mov    %ebx,%edx
  801e3b:	83 c4 1c             	add    $0x1c,%esp
  801e3e:	5b                   	pop    %ebx
  801e3f:	5e                   	pop    %esi
  801e40:	5f                   	pop    %edi
  801e41:	5d                   	pop    %ebp
  801e42:	c3                   	ret    
  801e43:	90                   	nop
  801e44:	89 fd                	mov    %edi,%ebp
  801e46:	85 ff                	test   %edi,%edi
  801e48:	75 0b                	jne    801e55 <__umoddi3+0xe9>
  801e4a:	b8 01 00 00 00       	mov    $0x1,%eax
  801e4f:	31 d2                	xor    %edx,%edx
  801e51:	f7 f7                	div    %edi
  801e53:	89 c5                	mov    %eax,%ebp
  801e55:	89 f0                	mov    %esi,%eax
  801e57:	31 d2                	xor    %edx,%edx
  801e59:	f7 f5                	div    %ebp
  801e5b:	89 c8                	mov    %ecx,%eax
  801e5d:	f7 f5                	div    %ebp
  801e5f:	89 d0                	mov    %edx,%eax
  801e61:	e9 44 ff ff ff       	jmp    801daa <__umoddi3+0x3e>
  801e66:	66 90                	xchg   %ax,%ax
  801e68:	89 c8                	mov    %ecx,%eax
  801e6a:	89 f2                	mov    %esi,%edx
  801e6c:	83 c4 1c             	add    $0x1c,%esp
  801e6f:	5b                   	pop    %ebx
  801e70:	5e                   	pop    %esi
  801e71:	5f                   	pop    %edi
  801e72:	5d                   	pop    %ebp
  801e73:	c3                   	ret    
  801e74:	3b 04 24             	cmp    (%esp),%eax
  801e77:	72 06                	jb     801e7f <__umoddi3+0x113>
  801e79:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  801e7d:	77 0f                	ja     801e8e <__umoddi3+0x122>
  801e7f:	89 f2                	mov    %esi,%edx
  801e81:	29 f9                	sub    %edi,%ecx
  801e83:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  801e87:	89 14 24             	mov    %edx,(%esp)
  801e8a:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801e8e:	8b 44 24 04          	mov    0x4(%esp),%eax
  801e92:	8b 14 24             	mov    (%esp),%edx
  801e95:	83 c4 1c             	add    $0x1c,%esp
  801e98:	5b                   	pop    %ebx
  801e99:	5e                   	pop    %esi
  801e9a:	5f                   	pop    %edi
  801e9b:	5d                   	pop    %ebp
  801e9c:	c3                   	ret    
  801e9d:	8d 76 00             	lea    0x0(%esi),%esi
  801ea0:	2b 04 24             	sub    (%esp),%eax
  801ea3:	19 fa                	sbb    %edi,%edx
  801ea5:	89 d1                	mov    %edx,%ecx
  801ea7:	89 c6                	mov    %eax,%esi
  801ea9:	e9 71 ff ff ff       	jmp    801e1f <__umoddi3+0xb3>
  801eae:	66 90                	xchg   %ax,%ax
  801eb0:	39 44 24 04          	cmp    %eax,0x4(%esp)
  801eb4:	72 ea                	jb     801ea0 <__umoddi3+0x134>
  801eb6:	89 d9                	mov    %ebx,%ecx
  801eb8:	e9 62 ff ff ff       	jmp    801e1f <__umoddi3+0xb3>
