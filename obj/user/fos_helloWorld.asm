
obj/user/fos_helloWorld:     file format elf32-i386


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
  800031:	e8 31 00 00 00       	call   800067 <libmain>
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
  80003b:	83 ec 08             	sub    $0x8,%esp
	extern unsigned char * etext;
	//cprintf("HELLO WORLD , FOS IS SAYING HI :D:D:D %d\n",4);
	atomic_cprintf("HELLO WORLD , FOS IS SAYING HI :D:D:D \n");
  80003e:	83 ec 0c             	sub    $0xc,%esp
  800041:	68 00 1c 80 00       	push   $0x801c00
  800046:	e8 33 03 00 00       	call   80037e <atomic_cprintf>
  80004b:	83 c4 10             	add    $0x10,%esp
	atomic_cprintf("end of code = %x\n",etext);
  80004e:	a1 ed 1b 80 00       	mov    0x801bed,%eax
  800053:	83 ec 08             	sub    $0x8,%esp
  800056:	50                   	push   %eax
  800057:	68 28 1c 80 00       	push   $0x801c28
  80005c:	e8 1d 03 00 00       	call   80037e <atomic_cprintf>
  800061:	83 c4 10             	add    $0x10,%esp
}
  800064:	90                   	nop
  800065:	c9                   	leave  
  800066:	c3                   	ret    

00800067 <libmain>:
volatile bool printStats = 1;

volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";
void
libmain(int argc, char **argv)
{
  800067:	55                   	push   %ebp
  800068:	89 e5                	mov    %esp,%ebp
  80006a:	57                   	push   %edi
  80006b:	56                   	push   %esi
  80006c:	53                   	push   %ebx
  80006d:	83 ec 7c             	sub    $0x7c,%esp
	//printStats = 1;
	int envIndex = sys_getenvindex();
  800070:	e8 64 14 00 00       	call   8014d9 <sys_getenvindex>
  800075:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	myEnv = &(envs[envIndex]);
  800078:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80007b:	89 d0                	mov    %edx,%eax
  80007d:	c1 e0 06             	shl    $0x6,%eax
  800080:	29 d0                	sub    %edx,%eax
  800082:	c1 e0 02             	shl    $0x2,%eax
  800085:	01 d0                	add    %edx,%eax
  800087:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  80008e:	01 c8                	add    %ecx,%eax
  800090:	c1 e0 03             	shl    $0x3,%eax
  800093:	01 d0                	add    %edx,%eax
  800095:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80009c:	29 c2                	sub    %eax,%edx
  80009e:	8d 04 95 00 00 00 00 	lea    0x0(,%edx,4),%eax
  8000a5:	89 c2                	mov    %eax,%edx
  8000a7:	8d 82 00 00 c0 ee    	lea    -0x11400000(%edx),%eax
  8000ad:	a3 20 30 80 00       	mov    %eax,0x803020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  8000b2:	a1 20 30 80 00       	mov    0x803020,%eax
  8000b7:	8a 40 20             	mov    0x20(%eax),%al
  8000ba:	84 c0                	test   %al,%al
  8000bc:	74 0d                	je     8000cb <libmain+0x64>
		binaryname = myEnv->prog_name;
  8000be:	a1 20 30 80 00       	mov    0x803020,%eax
  8000c3:	83 c0 20             	add    $0x20,%eax
  8000c6:	a3 04 30 80 00       	mov    %eax,0x803004

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8000cb:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8000cf:	7e 0a                	jle    8000db <libmain+0x74>
		binaryname = argv[0];
  8000d1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8000d4:	8b 00                	mov    (%eax),%eax
  8000d6:	a3 04 30 80 00       	mov    %eax,0x803004

	// call user main routine
	_main(argc, argv);
  8000db:	83 ec 08             	sub    $0x8,%esp
  8000de:	ff 75 0c             	pushl  0xc(%ebp)
  8000e1:	ff 75 08             	pushl  0x8(%ebp)
  8000e4:	e8 4f ff ff ff       	call   800038 <_main>
  8000e9:	83 c4 10             	add    $0x10,%esp

	if (printStats)
  8000ec:	a1 00 30 80 00       	mov    0x803000,%eax
  8000f1:	85 c0                	test   %eax,%eax
  8000f3:	0f 84 01 01 00 00    	je     8001fa <libmain+0x193>
	{
		char isOPTReplCmd[100] = "__IsOPTRepl__" ;
  8000f9:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  8000ff:	bb 34 1d 80 00       	mov    $0x801d34,%ebx
  800104:	ba 0e 00 00 00       	mov    $0xe,%edx
  800109:	89 c7                	mov    %eax,%edi
  80010b:	89 de                	mov    %ebx,%esi
  80010d:	89 d1                	mov    %edx,%ecx
  80010f:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  800111:	8d 55 8a             	lea    -0x76(%ebp),%edx
  800114:	b9 56 00 00 00       	mov    $0x56,%ecx
  800119:	b0 00                	mov    $0x0,%al
  80011b:	89 d7                	mov    %edx,%edi
  80011d:	f3 aa                	rep stos %al,%es:(%edi)
		int isOPTRepl = 0;
  80011f:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
		sys_utilities(isOPTReplCmd, (uint32)(&isOPTRepl));
  800126:	8d 45 e0             	lea    -0x20(%ebp),%eax
  800129:	83 ec 08             	sub    $0x8,%esp
  80012c:	50                   	push   %eax
  80012d:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  800133:	50                   	push   %eax
  800134:	e8 d6 15 00 00       	call   80170f <sys_utilities>
  800139:	83 c4 10             	add    $0x10,%esp

		sys_lock_cons();
  80013c:	e8 1f 11 00 00       	call   801260 <sys_lock_cons>
		{
			cprintf("**************************************\n");
  800141:	83 ec 0c             	sub    $0xc,%esp
  800144:	68 54 1c 80 00       	push   $0x801c54
  800149:	e8 be 01 00 00       	call   80030c <cprintf>
  80014e:	83 c4 10             	add    $0x10,%esp
			if (isOPTRepl)
  800151:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800154:	85 c0                	test   %eax,%eax
  800156:	74 18                	je     800170 <libmain+0x109>
			{
				cprintf("OPTIMAL number of page faults = %d\n", sys_get_optimal_num_faults());
  800158:	e8 d0 15 00 00       	call   80172d <sys_get_optimal_num_faults>
  80015d:	83 ec 08             	sub    $0x8,%esp
  800160:	50                   	push   %eax
  800161:	68 7c 1c 80 00       	push   $0x801c7c
  800166:	e8 a1 01 00 00       	call   80030c <cprintf>
  80016b:	83 c4 10             	add    $0x10,%esp
  80016e:	eb 59                	jmp    8001c9 <libmain+0x162>
			}
			else
			{
				cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  800170:	a1 20 30 80 00       	mov    0x803020,%eax
  800175:	8b 90 50 da 01 00    	mov    0x1da50(%eax),%edx
  80017b:	a1 20 30 80 00       	mov    0x803020,%eax
  800180:	8b 80 40 da 01 00    	mov    0x1da40(%eax),%eax
  800186:	83 ec 04             	sub    $0x4,%esp
  800189:	52                   	push   %edx
  80018a:	50                   	push   %eax
  80018b:	68 a0 1c 80 00       	push   $0x801ca0
  800190:	e8 77 01 00 00       	call   80030c <cprintf>
  800195:	83 c4 10             	add    $0x10,%esp
				cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800198:	a1 20 30 80 00       	mov    0x803020,%eax
  80019d:	8b 88 64 da 01 00    	mov    0x1da64(%eax),%ecx
  8001a3:	a1 20 30 80 00       	mov    0x803020,%eax
  8001a8:	8b 90 60 da 01 00    	mov    0x1da60(%eax),%edx
  8001ae:	a1 20 30 80 00       	mov    0x803020,%eax
  8001b3:	8b 80 5c da 01 00    	mov    0x1da5c(%eax),%eax
  8001b9:	51                   	push   %ecx
  8001ba:	52                   	push   %edx
  8001bb:	50                   	push   %eax
  8001bc:	68 c8 1c 80 00       	push   $0x801cc8
  8001c1:	e8 46 01 00 00       	call   80030c <cprintf>
  8001c6:	83 c4 10             	add    $0x10,%esp
			}
			//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
			cprintf("Num of clocks = %d\n", myEnv->nClocks);
  8001c9:	a1 20 30 80 00       	mov    0x803020,%eax
  8001ce:	8b 80 68 da 01 00    	mov    0x1da68(%eax),%eax
  8001d4:	83 ec 08             	sub    $0x8,%esp
  8001d7:	50                   	push   %eax
  8001d8:	68 20 1d 80 00       	push   $0x801d20
  8001dd:	e8 2a 01 00 00       	call   80030c <cprintf>
  8001e2:	83 c4 10             	add    $0x10,%esp
			cprintf("**************************************\n");
  8001e5:	83 ec 0c             	sub    $0xc,%esp
  8001e8:	68 54 1c 80 00       	push   $0x801c54
  8001ed:	e8 1a 01 00 00       	call   80030c <cprintf>
  8001f2:	83 c4 10             	add    $0x10,%esp
		}
		sys_unlock_cons();
  8001f5:	e8 80 10 00 00       	call   80127a <sys_unlock_cons>
	}

	// exit gracefully
	exit();
  8001fa:	e8 1f 00 00 00       	call   80021e <exit>
}
  8001ff:	90                   	nop
  800200:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800203:	5b                   	pop    %ebx
  800204:	5e                   	pop    %esi
  800205:	5f                   	pop    %edi
  800206:	5d                   	pop    %ebp
  800207:	c3                   	ret    

00800208 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800208:	55                   	push   %ebp
  800209:	89 e5                	mov    %esp,%ebp
  80020b:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  80020e:	83 ec 0c             	sub    $0xc,%esp
  800211:	6a 00                	push   $0x0
  800213:	e8 8d 12 00 00       	call   8014a5 <sys_destroy_env>
  800218:	83 c4 10             	add    $0x10,%esp
}
  80021b:	90                   	nop
  80021c:	c9                   	leave  
  80021d:	c3                   	ret    

0080021e <exit>:

void
exit(void)
{
  80021e:	55                   	push   %ebp
  80021f:	89 e5                	mov    %esp,%ebp
  800221:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  800224:	e8 e2 12 00 00       	call   80150b <sys_exit_env>
}
  800229:	90                   	nop
  80022a:	c9                   	leave  
  80022b:	c3                   	ret    

0080022c <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  80022c:	55                   	push   %ebp
  80022d:	89 e5                	mov    %esp,%ebp
  80022f:	53                   	push   %ebx
  800230:	83 ec 04             	sub    $0x4,%esp
	b->buf[b->idx++] = ch;
  800233:	8b 45 0c             	mov    0xc(%ebp),%eax
  800236:	8b 00                	mov    (%eax),%eax
  800238:	8d 48 01             	lea    0x1(%eax),%ecx
  80023b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80023e:	89 0a                	mov    %ecx,(%edx)
  800240:	8b 55 08             	mov    0x8(%ebp),%edx
  800243:	88 d1                	mov    %dl,%cl
  800245:	8b 55 0c             	mov    0xc(%ebp),%edx
  800248:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  80024c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80024f:	8b 00                	mov    (%eax),%eax
  800251:	3d ff 00 00 00       	cmp    $0xff,%eax
  800256:	75 30                	jne    800288 <putch+0x5c>
		sys_cputs(b->buf, b->idx, printProgName, curTextClr);
  800258:	8b 15 18 b1 81 00    	mov    0x81b118,%edx
  80025e:	a0 44 30 80 00       	mov    0x803044,%al
  800263:	0f b6 c0             	movzbl %al,%eax
  800266:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800269:	8b 09                	mov    (%ecx),%ecx
  80026b:	89 cb                	mov    %ecx,%ebx
  80026d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800270:	83 c1 08             	add    $0x8,%ecx
  800273:	52                   	push   %edx
  800274:	50                   	push   %eax
  800275:	53                   	push   %ebx
  800276:	51                   	push   %ecx
  800277:	e8 a0 0f 00 00       	call   80121c <sys_cputs>
  80027c:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  80027f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800282:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800288:	8b 45 0c             	mov    0xc(%ebp),%eax
  80028b:	8b 40 04             	mov    0x4(%eax),%eax
  80028e:	8d 50 01             	lea    0x1(%eax),%edx
  800291:	8b 45 0c             	mov    0xc(%ebp),%eax
  800294:	89 50 04             	mov    %edx,0x4(%eax)
}
  800297:	90                   	nop
  800298:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80029b:	c9                   	leave  
  80029c:	c3                   	ret    

0080029d <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  80029d:	55                   	push   %ebp
  80029e:	89 e5                	mov    %esp,%ebp
  8002a0:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8002a6:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8002ad:	00 00 00 
	b.cnt = 0;
  8002b0:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8002b7:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  8002ba:	ff 75 0c             	pushl  0xc(%ebp)
  8002bd:	ff 75 08             	pushl  0x8(%ebp)
  8002c0:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8002c6:	50                   	push   %eax
  8002c7:	68 2c 02 80 00       	push   $0x80022c
  8002cc:	e8 5a 02 00 00       	call   80052b <vprintfmt>
  8002d1:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName, curTextClr);
  8002d4:	8b 15 18 b1 81 00    	mov    0x81b118,%edx
  8002da:	a0 44 30 80 00       	mov    0x803044,%al
  8002df:	0f b6 c0             	movzbl %al,%eax
  8002e2:	8b 8d f0 fe ff ff    	mov    -0x110(%ebp),%ecx
  8002e8:	52                   	push   %edx
  8002e9:	50                   	push   %eax
  8002ea:	51                   	push   %ecx
  8002eb:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8002f1:	83 c0 08             	add    $0x8,%eax
  8002f4:	50                   	push   %eax
  8002f5:	e8 22 0f 00 00       	call   80121c <sys_cputs>
  8002fa:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  8002fd:	c6 05 44 30 80 00 00 	movb   $0x0,0x803044
	return b.cnt;
  800304:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  80030a:	c9                   	leave  
  80030b:	c3                   	ret    

0080030c <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  80030c:	55                   	push   %ebp
  80030d:	89 e5                	mov    %esp,%ebp
  80030f:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800312:	c6 05 44 30 80 00 01 	movb   $0x1,0x803044
	va_start(ap, fmt);
  800319:	8d 45 0c             	lea    0xc(%ebp),%eax
  80031c:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  80031f:	8b 45 08             	mov    0x8(%ebp),%eax
  800322:	83 ec 08             	sub    $0x8,%esp
  800325:	ff 75 f4             	pushl  -0xc(%ebp)
  800328:	50                   	push   %eax
  800329:	e8 6f ff ff ff       	call   80029d <vcprintf>
  80032e:	83 c4 10             	add    $0x10,%esp
  800331:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800334:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800337:	c9                   	leave  
  800338:	c3                   	ret    

00800339 <cprintf_colored>:

// *************** This text coloring feature is implemented by *************
// ********** Abd-Alrahman Zedan From Team Frozen-Bytes - FCIS'24-25 ********
int cprintf_colored(int textClr, const char *fmt, ...) {
  800339:	55                   	push   %ebp
  80033a:	89 e5                	mov    %esp,%ebp
  80033c:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  80033f:	c6 05 44 30 80 00 01 	movb   $0x1,0x803044
	curTextClr = (textClr << 8) ; //set text color by the given value
  800346:	8b 45 08             	mov    0x8(%ebp),%eax
  800349:	c1 e0 08             	shl    $0x8,%eax
  80034c:	a3 18 b1 81 00       	mov    %eax,0x81b118
	va_start(ap, fmt);
  800351:	8d 45 0c             	lea    0xc(%ebp),%eax
  800354:	83 c0 04             	add    $0x4,%eax
  800357:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  80035a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80035d:	83 ec 08             	sub    $0x8,%esp
  800360:	ff 75 f4             	pushl  -0xc(%ebp)
  800363:	50                   	push   %eax
  800364:	e8 34 ff ff ff       	call   80029d <vcprintf>
  800369:	83 c4 10             	add    $0x10,%esp
  80036c:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);
	curTextClr = TEXT_DEFAULT_CLR; //restore default color
  80036f:	c7 05 18 b1 81 00 00 	movl   $0x700,0x81b118
  800376:	07 00 00 

	return cnt;
  800379:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80037c:	c9                   	leave  
  80037d:	c3                   	ret    

0080037e <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  80037e:	55                   	push   %ebp
  80037f:	89 e5                	mov    %esp,%ebp
  800381:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  800384:	e8 d7 0e 00 00       	call   801260 <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  800389:	8d 45 0c             	lea    0xc(%ebp),%eax
  80038c:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  80038f:	8b 45 08             	mov    0x8(%ebp),%eax
  800392:	83 ec 08             	sub    $0x8,%esp
  800395:	ff 75 f4             	pushl  -0xc(%ebp)
  800398:	50                   	push   %eax
  800399:	e8 ff fe ff ff       	call   80029d <vcprintf>
  80039e:	83 c4 10             	add    $0x10,%esp
  8003a1:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  8003a4:	e8 d1 0e 00 00       	call   80127a <sys_unlock_cons>
	return cnt;
  8003a9:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8003ac:	c9                   	leave  
  8003ad:	c3                   	ret    

008003ae <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8003ae:	55                   	push   %ebp
  8003af:	89 e5                	mov    %esp,%ebp
  8003b1:	53                   	push   %ebx
  8003b2:	83 ec 14             	sub    $0x14,%esp
  8003b5:	8b 45 10             	mov    0x10(%ebp),%eax
  8003b8:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8003bb:	8b 45 14             	mov    0x14(%ebp),%eax
  8003be:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8003c1:	8b 45 18             	mov    0x18(%ebp),%eax
  8003c4:	ba 00 00 00 00       	mov    $0x0,%edx
  8003c9:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8003cc:	77 55                	ja     800423 <printnum+0x75>
  8003ce:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8003d1:	72 05                	jb     8003d8 <printnum+0x2a>
  8003d3:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8003d6:	77 4b                	ja     800423 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8003d8:	8b 45 1c             	mov    0x1c(%ebp),%eax
  8003db:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8003de:	8b 45 18             	mov    0x18(%ebp),%eax
  8003e1:	ba 00 00 00 00       	mov    $0x0,%edx
  8003e6:	52                   	push   %edx
  8003e7:	50                   	push   %eax
  8003e8:	ff 75 f4             	pushl  -0xc(%ebp)
  8003eb:	ff 75 f0             	pushl  -0x10(%ebp)
  8003ee:	e8 99 15 00 00       	call   80198c <__udivdi3>
  8003f3:	83 c4 10             	add    $0x10,%esp
  8003f6:	83 ec 04             	sub    $0x4,%esp
  8003f9:	ff 75 20             	pushl  0x20(%ebp)
  8003fc:	53                   	push   %ebx
  8003fd:	ff 75 18             	pushl  0x18(%ebp)
  800400:	52                   	push   %edx
  800401:	50                   	push   %eax
  800402:	ff 75 0c             	pushl  0xc(%ebp)
  800405:	ff 75 08             	pushl  0x8(%ebp)
  800408:	e8 a1 ff ff ff       	call   8003ae <printnum>
  80040d:	83 c4 20             	add    $0x20,%esp
  800410:	eb 1a                	jmp    80042c <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800412:	83 ec 08             	sub    $0x8,%esp
  800415:	ff 75 0c             	pushl  0xc(%ebp)
  800418:	ff 75 20             	pushl  0x20(%ebp)
  80041b:	8b 45 08             	mov    0x8(%ebp),%eax
  80041e:	ff d0                	call   *%eax
  800420:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800423:	ff 4d 1c             	decl   0x1c(%ebp)
  800426:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  80042a:	7f e6                	jg     800412 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80042c:	8b 4d 18             	mov    0x18(%ebp),%ecx
  80042f:	bb 00 00 00 00       	mov    $0x0,%ebx
  800434:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800437:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80043a:	53                   	push   %ebx
  80043b:	51                   	push   %ecx
  80043c:	52                   	push   %edx
  80043d:	50                   	push   %eax
  80043e:	e8 59 16 00 00       	call   801a9c <__umoddi3>
  800443:	83 c4 10             	add    $0x10,%esp
  800446:	05 b4 1f 80 00       	add    $0x801fb4,%eax
  80044b:	8a 00                	mov    (%eax),%al
  80044d:	0f be c0             	movsbl %al,%eax
  800450:	83 ec 08             	sub    $0x8,%esp
  800453:	ff 75 0c             	pushl  0xc(%ebp)
  800456:	50                   	push   %eax
  800457:	8b 45 08             	mov    0x8(%ebp),%eax
  80045a:	ff d0                	call   *%eax
  80045c:	83 c4 10             	add    $0x10,%esp
}
  80045f:	90                   	nop
  800460:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800463:	c9                   	leave  
  800464:	c3                   	ret    

00800465 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800465:	55                   	push   %ebp
  800466:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800468:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  80046c:	7e 1c                	jle    80048a <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  80046e:	8b 45 08             	mov    0x8(%ebp),%eax
  800471:	8b 00                	mov    (%eax),%eax
  800473:	8d 50 08             	lea    0x8(%eax),%edx
  800476:	8b 45 08             	mov    0x8(%ebp),%eax
  800479:	89 10                	mov    %edx,(%eax)
  80047b:	8b 45 08             	mov    0x8(%ebp),%eax
  80047e:	8b 00                	mov    (%eax),%eax
  800480:	83 e8 08             	sub    $0x8,%eax
  800483:	8b 50 04             	mov    0x4(%eax),%edx
  800486:	8b 00                	mov    (%eax),%eax
  800488:	eb 40                	jmp    8004ca <getuint+0x65>
	else if (lflag)
  80048a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80048e:	74 1e                	je     8004ae <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800490:	8b 45 08             	mov    0x8(%ebp),%eax
  800493:	8b 00                	mov    (%eax),%eax
  800495:	8d 50 04             	lea    0x4(%eax),%edx
  800498:	8b 45 08             	mov    0x8(%ebp),%eax
  80049b:	89 10                	mov    %edx,(%eax)
  80049d:	8b 45 08             	mov    0x8(%ebp),%eax
  8004a0:	8b 00                	mov    (%eax),%eax
  8004a2:	83 e8 04             	sub    $0x4,%eax
  8004a5:	8b 00                	mov    (%eax),%eax
  8004a7:	ba 00 00 00 00       	mov    $0x0,%edx
  8004ac:	eb 1c                	jmp    8004ca <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  8004ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8004b1:	8b 00                	mov    (%eax),%eax
  8004b3:	8d 50 04             	lea    0x4(%eax),%edx
  8004b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8004b9:	89 10                	mov    %edx,(%eax)
  8004bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8004be:	8b 00                	mov    (%eax),%eax
  8004c0:	83 e8 04             	sub    $0x4,%eax
  8004c3:	8b 00                	mov    (%eax),%eax
  8004c5:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8004ca:	5d                   	pop    %ebp
  8004cb:	c3                   	ret    

008004cc <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8004cc:	55                   	push   %ebp
  8004cd:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8004cf:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8004d3:	7e 1c                	jle    8004f1 <getint+0x25>
		return va_arg(*ap, long long);
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
  8004ef:	eb 38                	jmp    800529 <getint+0x5d>
	else if (lflag)
  8004f1:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8004f5:	74 1a                	je     800511 <getint+0x45>
		return va_arg(*ap, long);
  8004f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8004fa:	8b 00                	mov    (%eax),%eax
  8004fc:	8d 50 04             	lea    0x4(%eax),%edx
  8004ff:	8b 45 08             	mov    0x8(%ebp),%eax
  800502:	89 10                	mov    %edx,(%eax)
  800504:	8b 45 08             	mov    0x8(%ebp),%eax
  800507:	8b 00                	mov    (%eax),%eax
  800509:	83 e8 04             	sub    $0x4,%eax
  80050c:	8b 00                	mov    (%eax),%eax
  80050e:	99                   	cltd   
  80050f:	eb 18                	jmp    800529 <getint+0x5d>
	else
		return va_arg(*ap, int);
  800511:	8b 45 08             	mov    0x8(%ebp),%eax
  800514:	8b 00                	mov    (%eax),%eax
  800516:	8d 50 04             	lea    0x4(%eax),%edx
  800519:	8b 45 08             	mov    0x8(%ebp),%eax
  80051c:	89 10                	mov    %edx,(%eax)
  80051e:	8b 45 08             	mov    0x8(%ebp),%eax
  800521:	8b 00                	mov    (%eax),%eax
  800523:	83 e8 04             	sub    $0x4,%eax
  800526:	8b 00                	mov    (%eax),%eax
  800528:	99                   	cltd   
}
  800529:	5d                   	pop    %ebp
  80052a:	c3                   	ret    

0080052b <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  80052b:	55                   	push   %ebp
  80052c:	89 e5                	mov    %esp,%ebp
  80052e:	56                   	push   %esi
  80052f:	53                   	push   %ebx
  800530:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800533:	eb 17                	jmp    80054c <vprintfmt+0x21>
			if (ch == '\0')
  800535:	85 db                	test   %ebx,%ebx
  800537:	0f 84 c1 03 00 00    	je     8008fe <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  80053d:	83 ec 08             	sub    $0x8,%esp
  800540:	ff 75 0c             	pushl  0xc(%ebp)
  800543:	53                   	push   %ebx
  800544:	8b 45 08             	mov    0x8(%ebp),%eax
  800547:	ff d0                	call   *%eax
  800549:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80054c:	8b 45 10             	mov    0x10(%ebp),%eax
  80054f:	8d 50 01             	lea    0x1(%eax),%edx
  800552:	89 55 10             	mov    %edx,0x10(%ebp)
  800555:	8a 00                	mov    (%eax),%al
  800557:	0f b6 d8             	movzbl %al,%ebx
  80055a:	83 fb 25             	cmp    $0x25,%ebx
  80055d:	75 d6                	jne    800535 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  80055f:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800563:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  80056a:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800571:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800578:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80057f:	8b 45 10             	mov    0x10(%ebp),%eax
  800582:	8d 50 01             	lea    0x1(%eax),%edx
  800585:	89 55 10             	mov    %edx,0x10(%ebp)
  800588:	8a 00                	mov    (%eax),%al
  80058a:	0f b6 d8             	movzbl %al,%ebx
  80058d:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800590:	83 f8 5b             	cmp    $0x5b,%eax
  800593:	0f 87 3d 03 00 00    	ja     8008d6 <vprintfmt+0x3ab>
  800599:	8b 04 85 d8 1f 80 00 	mov    0x801fd8(,%eax,4),%eax
  8005a0:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  8005a2:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  8005a6:	eb d7                	jmp    80057f <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8005a8:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  8005ac:	eb d1                	jmp    80057f <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8005ae:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  8005b5:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8005b8:	89 d0                	mov    %edx,%eax
  8005ba:	c1 e0 02             	shl    $0x2,%eax
  8005bd:	01 d0                	add    %edx,%eax
  8005bf:	01 c0                	add    %eax,%eax
  8005c1:	01 d8                	add    %ebx,%eax
  8005c3:	83 e8 30             	sub    $0x30,%eax
  8005c6:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  8005c9:	8b 45 10             	mov    0x10(%ebp),%eax
  8005cc:	8a 00                	mov    (%eax),%al
  8005ce:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8005d1:	83 fb 2f             	cmp    $0x2f,%ebx
  8005d4:	7e 3e                	jle    800614 <vprintfmt+0xe9>
  8005d6:	83 fb 39             	cmp    $0x39,%ebx
  8005d9:	7f 39                	jg     800614 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8005db:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8005de:	eb d5                	jmp    8005b5 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8005e0:	8b 45 14             	mov    0x14(%ebp),%eax
  8005e3:	83 c0 04             	add    $0x4,%eax
  8005e6:	89 45 14             	mov    %eax,0x14(%ebp)
  8005e9:	8b 45 14             	mov    0x14(%ebp),%eax
  8005ec:	83 e8 04             	sub    $0x4,%eax
  8005ef:	8b 00                	mov    (%eax),%eax
  8005f1:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  8005f4:	eb 1f                	jmp    800615 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  8005f6:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8005fa:	79 83                	jns    80057f <vprintfmt+0x54>
				width = 0;
  8005fc:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800603:	e9 77 ff ff ff       	jmp    80057f <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800608:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  80060f:	e9 6b ff ff ff       	jmp    80057f <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800614:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800615:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800619:	0f 89 60 ff ff ff    	jns    80057f <vprintfmt+0x54>
				width = precision, precision = -1;
  80061f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800622:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800625:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  80062c:	e9 4e ff ff ff       	jmp    80057f <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800631:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800634:	e9 46 ff ff ff       	jmp    80057f <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800639:	8b 45 14             	mov    0x14(%ebp),%eax
  80063c:	83 c0 04             	add    $0x4,%eax
  80063f:	89 45 14             	mov    %eax,0x14(%ebp)
  800642:	8b 45 14             	mov    0x14(%ebp),%eax
  800645:	83 e8 04             	sub    $0x4,%eax
  800648:	8b 00                	mov    (%eax),%eax
  80064a:	83 ec 08             	sub    $0x8,%esp
  80064d:	ff 75 0c             	pushl  0xc(%ebp)
  800650:	50                   	push   %eax
  800651:	8b 45 08             	mov    0x8(%ebp),%eax
  800654:	ff d0                	call   *%eax
  800656:	83 c4 10             	add    $0x10,%esp
			break;
  800659:	e9 9b 02 00 00       	jmp    8008f9 <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  80065e:	8b 45 14             	mov    0x14(%ebp),%eax
  800661:	83 c0 04             	add    $0x4,%eax
  800664:	89 45 14             	mov    %eax,0x14(%ebp)
  800667:	8b 45 14             	mov    0x14(%ebp),%eax
  80066a:	83 e8 04             	sub    $0x4,%eax
  80066d:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  80066f:	85 db                	test   %ebx,%ebx
  800671:	79 02                	jns    800675 <vprintfmt+0x14a>
				err = -err;
  800673:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800675:	83 fb 64             	cmp    $0x64,%ebx
  800678:	7f 0b                	jg     800685 <vprintfmt+0x15a>
  80067a:	8b 34 9d 20 1e 80 00 	mov    0x801e20(,%ebx,4),%esi
  800681:	85 f6                	test   %esi,%esi
  800683:	75 19                	jne    80069e <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800685:	53                   	push   %ebx
  800686:	68 c5 1f 80 00       	push   $0x801fc5
  80068b:	ff 75 0c             	pushl  0xc(%ebp)
  80068e:	ff 75 08             	pushl  0x8(%ebp)
  800691:	e8 70 02 00 00       	call   800906 <printfmt>
  800696:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800699:	e9 5b 02 00 00       	jmp    8008f9 <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  80069e:	56                   	push   %esi
  80069f:	68 ce 1f 80 00       	push   $0x801fce
  8006a4:	ff 75 0c             	pushl  0xc(%ebp)
  8006a7:	ff 75 08             	pushl  0x8(%ebp)
  8006aa:	e8 57 02 00 00       	call   800906 <printfmt>
  8006af:	83 c4 10             	add    $0x10,%esp
			break;
  8006b2:	e9 42 02 00 00       	jmp    8008f9 <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  8006b7:	8b 45 14             	mov    0x14(%ebp),%eax
  8006ba:	83 c0 04             	add    $0x4,%eax
  8006bd:	89 45 14             	mov    %eax,0x14(%ebp)
  8006c0:	8b 45 14             	mov    0x14(%ebp),%eax
  8006c3:	83 e8 04             	sub    $0x4,%eax
  8006c6:	8b 30                	mov    (%eax),%esi
  8006c8:	85 f6                	test   %esi,%esi
  8006ca:	75 05                	jne    8006d1 <vprintfmt+0x1a6>
				p = "(null)";
  8006cc:	be d1 1f 80 00       	mov    $0x801fd1,%esi
			if (width > 0 && padc != '-')
  8006d1:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8006d5:	7e 6d                	jle    800744 <vprintfmt+0x219>
  8006d7:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  8006db:	74 67                	je     800744 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  8006dd:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8006e0:	83 ec 08             	sub    $0x8,%esp
  8006e3:	50                   	push   %eax
  8006e4:	56                   	push   %esi
  8006e5:	e8 1e 03 00 00       	call   800a08 <strnlen>
  8006ea:	83 c4 10             	add    $0x10,%esp
  8006ed:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  8006f0:	eb 16                	jmp    800708 <vprintfmt+0x1dd>
					putch(padc, putdat);
  8006f2:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  8006f6:	83 ec 08             	sub    $0x8,%esp
  8006f9:	ff 75 0c             	pushl  0xc(%ebp)
  8006fc:	50                   	push   %eax
  8006fd:	8b 45 08             	mov    0x8(%ebp),%eax
  800700:	ff d0                	call   *%eax
  800702:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800705:	ff 4d e4             	decl   -0x1c(%ebp)
  800708:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80070c:	7f e4                	jg     8006f2 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80070e:	eb 34                	jmp    800744 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800710:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800714:	74 1c                	je     800732 <vprintfmt+0x207>
  800716:	83 fb 1f             	cmp    $0x1f,%ebx
  800719:	7e 05                	jle    800720 <vprintfmt+0x1f5>
  80071b:	83 fb 7e             	cmp    $0x7e,%ebx
  80071e:	7e 12                	jle    800732 <vprintfmt+0x207>
					putch('?', putdat);
  800720:	83 ec 08             	sub    $0x8,%esp
  800723:	ff 75 0c             	pushl  0xc(%ebp)
  800726:	6a 3f                	push   $0x3f
  800728:	8b 45 08             	mov    0x8(%ebp),%eax
  80072b:	ff d0                	call   *%eax
  80072d:	83 c4 10             	add    $0x10,%esp
  800730:	eb 0f                	jmp    800741 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800732:	83 ec 08             	sub    $0x8,%esp
  800735:	ff 75 0c             	pushl  0xc(%ebp)
  800738:	53                   	push   %ebx
  800739:	8b 45 08             	mov    0x8(%ebp),%eax
  80073c:	ff d0                	call   *%eax
  80073e:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800741:	ff 4d e4             	decl   -0x1c(%ebp)
  800744:	89 f0                	mov    %esi,%eax
  800746:	8d 70 01             	lea    0x1(%eax),%esi
  800749:	8a 00                	mov    (%eax),%al
  80074b:	0f be d8             	movsbl %al,%ebx
  80074e:	85 db                	test   %ebx,%ebx
  800750:	74 24                	je     800776 <vprintfmt+0x24b>
  800752:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800756:	78 b8                	js     800710 <vprintfmt+0x1e5>
  800758:	ff 4d e0             	decl   -0x20(%ebp)
  80075b:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80075f:	79 af                	jns    800710 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800761:	eb 13                	jmp    800776 <vprintfmt+0x24b>
				putch(' ', putdat);
  800763:	83 ec 08             	sub    $0x8,%esp
  800766:	ff 75 0c             	pushl  0xc(%ebp)
  800769:	6a 20                	push   $0x20
  80076b:	8b 45 08             	mov    0x8(%ebp),%eax
  80076e:	ff d0                	call   *%eax
  800770:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800773:	ff 4d e4             	decl   -0x1c(%ebp)
  800776:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80077a:	7f e7                	jg     800763 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  80077c:	e9 78 01 00 00       	jmp    8008f9 <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800781:	83 ec 08             	sub    $0x8,%esp
  800784:	ff 75 e8             	pushl  -0x18(%ebp)
  800787:	8d 45 14             	lea    0x14(%ebp),%eax
  80078a:	50                   	push   %eax
  80078b:	e8 3c fd ff ff       	call   8004cc <getint>
  800790:	83 c4 10             	add    $0x10,%esp
  800793:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800796:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800799:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80079c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80079f:	85 d2                	test   %edx,%edx
  8007a1:	79 23                	jns    8007c6 <vprintfmt+0x29b>
				putch('-', putdat);
  8007a3:	83 ec 08             	sub    $0x8,%esp
  8007a6:	ff 75 0c             	pushl  0xc(%ebp)
  8007a9:	6a 2d                	push   $0x2d
  8007ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8007ae:	ff d0                	call   *%eax
  8007b0:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  8007b3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8007b6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8007b9:	f7 d8                	neg    %eax
  8007bb:	83 d2 00             	adc    $0x0,%edx
  8007be:	f7 da                	neg    %edx
  8007c0:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8007c3:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  8007c6:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8007cd:	e9 bc 00 00 00       	jmp    80088e <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  8007d2:	83 ec 08             	sub    $0x8,%esp
  8007d5:	ff 75 e8             	pushl  -0x18(%ebp)
  8007d8:	8d 45 14             	lea    0x14(%ebp),%eax
  8007db:	50                   	push   %eax
  8007dc:	e8 84 fc ff ff       	call   800465 <getuint>
  8007e1:	83 c4 10             	add    $0x10,%esp
  8007e4:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8007e7:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  8007ea:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8007f1:	e9 98 00 00 00       	jmp    80088e <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  8007f6:	83 ec 08             	sub    $0x8,%esp
  8007f9:	ff 75 0c             	pushl  0xc(%ebp)
  8007fc:	6a 58                	push   $0x58
  8007fe:	8b 45 08             	mov    0x8(%ebp),%eax
  800801:	ff d0                	call   *%eax
  800803:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800806:	83 ec 08             	sub    $0x8,%esp
  800809:	ff 75 0c             	pushl  0xc(%ebp)
  80080c:	6a 58                	push   $0x58
  80080e:	8b 45 08             	mov    0x8(%ebp),%eax
  800811:	ff d0                	call   *%eax
  800813:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800816:	83 ec 08             	sub    $0x8,%esp
  800819:	ff 75 0c             	pushl  0xc(%ebp)
  80081c:	6a 58                	push   $0x58
  80081e:	8b 45 08             	mov    0x8(%ebp),%eax
  800821:	ff d0                	call   *%eax
  800823:	83 c4 10             	add    $0x10,%esp
			break;
  800826:	e9 ce 00 00 00       	jmp    8008f9 <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  80082b:	83 ec 08             	sub    $0x8,%esp
  80082e:	ff 75 0c             	pushl  0xc(%ebp)
  800831:	6a 30                	push   $0x30
  800833:	8b 45 08             	mov    0x8(%ebp),%eax
  800836:	ff d0                	call   *%eax
  800838:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  80083b:	83 ec 08             	sub    $0x8,%esp
  80083e:	ff 75 0c             	pushl  0xc(%ebp)
  800841:	6a 78                	push   $0x78
  800843:	8b 45 08             	mov    0x8(%ebp),%eax
  800846:	ff d0                	call   *%eax
  800848:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  80084b:	8b 45 14             	mov    0x14(%ebp),%eax
  80084e:	83 c0 04             	add    $0x4,%eax
  800851:	89 45 14             	mov    %eax,0x14(%ebp)
  800854:	8b 45 14             	mov    0x14(%ebp),%eax
  800857:	83 e8 04             	sub    $0x4,%eax
  80085a:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  80085c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80085f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800866:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  80086d:	eb 1f                	jmp    80088e <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  80086f:	83 ec 08             	sub    $0x8,%esp
  800872:	ff 75 e8             	pushl  -0x18(%ebp)
  800875:	8d 45 14             	lea    0x14(%ebp),%eax
  800878:	50                   	push   %eax
  800879:	e8 e7 fb ff ff       	call   800465 <getuint>
  80087e:	83 c4 10             	add    $0x10,%esp
  800881:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800884:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800887:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  80088e:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800892:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800895:	83 ec 04             	sub    $0x4,%esp
  800898:	52                   	push   %edx
  800899:	ff 75 e4             	pushl  -0x1c(%ebp)
  80089c:	50                   	push   %eax
  80089d:	ff 75 f4             	pushl  -0xc(%ebp)
  8008a0:	ff 75 f0             	pushl  -0x10(%ebp)
  8008a3:	ff 75 0c             	pushl  0xc(%ebp)
  8008a6:	ff 75 08             	pushl  0x8(%ebp)
  8008a9:	e8 00 fb ff ff       	call   8003ae <printnum>
  8008ae:	83 c4 20             	add    $0x20,%esp
			break;
  8008b1:	eb 46                	jmp    8008f9 <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  8008b3:	83 ec 08             	sub    $0x8,%esp
  8008b6:	ff 75 0c             	pushl  0xc(%ebp)
  8008b9:	53                   	push   %ebx
  8008ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8008bd:	ff d0                	call   *%eax
  8008bf:	83 c4 10             	add    $0x10,%esp
			break;
  8008c2:	eb 35                	jmp    8008f9 <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  8008c4:	c6 05 44 30 80 00 00 	movb   $0x0,0x803044
			break;
  8008cb:	eb 2c                	jmp    8008f9 <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  8008cd:	c6 05 44 30 80 00 01 	movb   $0x1,0x803044
			break;
  8008d4:	eb 23                	jmp    8008f9 <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  8008d6:	83 ec 08             	sub    $0x8,%esp
  8008d9:	ff 75 0c             	pushl  0xc(%ebp)
  8008dc:	6a 25                	push   $0x25
  8008de:	8b 45 08             	mov    0x8(%ebp),%eax
  8008e1:	ff d0                	call   *%eax
  8008e3:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  8008e6:	ff 4d 10             	decl   0x10(%ebp)
  8008e9:	eb 03                	jmp    8008ee <vprintfmt+0x3c3>
  8008eb:	ff 4d 10             	decl   0x10(%ebp)
  8008ee:	8b 45 10             	mov    0x10(%ebp),%eax
  8008f1:	48                   	dec    %eax
  8008f2:	8a 00                	mov    (%eax),%al
  8008f4:	3c 25                	cmp    $0x25,%al
  8008f6:	75 f3                	jne    8008eb <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  8008f8:	90                   	nop
		}
	}
  8008f9:	e9 35 fc ff ff       	jmp    800533 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  8008fe:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  8008ff:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800902:	5b                   	pop    %ebx
  800903:	5e                   	pop    %esi
  800904:	5d                   	pop    %ebp
  800905:	c3                   	ret    

00800906 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800906:	55                   	push   %ebp
  800907:	89 e5                	mov    %esp,%ebp
  800909:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  80090c:	8d 45 10             	lea    0x10(%ebp),%eax
  80090f:	83 c0 04             	add    $0x4,%eax
  800912:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800915:	8b 45 10             	mov    0x10(%ebp),%eax
  800918:	ff 75 f4             	pushl  -0xc(%ebp)
  80091b:	50                   	push   %eax
  80091c:	ff 75 0c             	pushl  0xc(%ebp)
  80091f:	ff 75 08             	pushl  0x8(%ebp)
  800922:	e8 04 fc ff ff       	call   80052b <vprintfmt>
  800927:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  80092a:	90                   	nop
  80092b:	c9                   	leave  
  80092c:	c3                   	ret    

0080092d <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  80092d:	55                   	push   %ebp
  80092e:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800930:	8b 45 0c             	mov    0xc(%ebp),%eax
  800933:	8b 40 08             	mov    0x8(%eax),%eax
  800936:	8d 50 01             	lea    0x1(%eax),%edx
  800939:	8b 45 0c             	mov    0xc(%ebp),%eax
  80093c:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  80093f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800942:	8b 10                	mov    (%eax),%edx
  800944:	8b 45 0c             	mov    0xc(%ebp),%eax
  800947:	8b 40 04             	mov    0x4(%eax),%eax
  80094a:	39 c2                	cmp    %eax,%edx
  80094c:	73 12                	jae    800960 <sprintputch+0x33>
		*b->buf++ = ch;
  80094e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800951:	8b 00                	mov    (%eax),%eax
  800953:	8d 48 01             	lea    0x1(%eax),%ecx
  800956:	8b 55 0c             	mov    0xc(%ebp),%edx
  800959:	89 0a                	mov    %ecx,(%edx)
  80095b:	8b 55 08             	mov    0x8(%ebp),%edx
  80095e:	88 10                	mov    %dl,(%eax)
}
  800960:	90                   	nop
  800961:	5d                   	pop    %ebp
  800962:	c3                   	ret    

00800963 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800963:	55                   	push   %ebp
  800964:	89 e5                	mov    %esp,%ebp
  800966:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800969:	8b 45 08             	mov    0x8(%ebp),%eax
  80096c:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80096f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800972:	8d 50 ff             	lea    -0x1(%eax),%edx
  800975:	8b 45 08             	mov    0x8(%ebp),%eax
  800978:	01 d0                	add    %edx,%eax
  80097a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80097d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800984:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800988:	74 06                	je     800990 <vsnprintf+0x2d>
  80098a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80098e:	7f 07                	jg     800997 <vsnprintf+0x34>
		return -E_INVAL;
  800990:	b8 03 00 00 00       	mov    $0x3,%eax
  800995:	eb 20                	jmp    8009b7 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800997:	ff 75 14             	pushl  0x14(%ebp)
  80099a:	ff 75 10             	pushl  0x10(%ebp)
  80099d:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8009a0:	50                   	push   %eax
  8009a1:	68 2d 09 80 00       	push   $0x80092d
  8009a6:	e8 80 fb ff ff       	call   80052b <vprintfmt>
  8009ab:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  8009ae:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8009b1:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8009b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  8009b7:	c9                   	leave  
  8009b8:	c3                   	ret    

008009b9 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8009b9:	55                   	push   %ebp
  8009ba:	89 e5                	mov    %esp,%ebp
  8009bc:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8009bf:	8d 45 10             	lea    0x10(%ebp),%eax
  8009c2:	83 c0 04             	add    $0x4,%eax
  8009c5:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  8009c8:	8b 45 10             	mov    0x10(%ebp),%eax
  8009cb:	ff 75 f4             	pushl  -0xc(%ebp)
  8009ce:	50                   	push   %eax
  8009cf:	ff 75 0c             	pushl  0xc(%ebp)
  8009d2:	ff 75 08             	pushl  0x8(%ebp)
  8009d5:	e8 89 ff ff ff       	call   800963 <vsnprintf>
  8009da:	83 c4 10             	add    $0x10,%esp
  8009dd:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  8009e0:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8009e3:	c9                   	leave  
  8009e4:	c3                   	ret    

008009e5 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  8009e5:	55                   	push   %ebp
  8009e6:	89 e5                	mov    %esp,%ebp
  8009e8:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  8009eb:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8009f2:	eb 06                	jmp    8009fa <strlen+0x15>
		n++;
  8009f4:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  8009f7:	ff 45 08             	incl   0x8(%ebp)
  8009fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8009fd:	8a 00                	mov    (%eax),%al
  8009ff:	84 c0                	test   %al,%al
  800a01:	75 f1                	jne    8009f4 <strlen+0xf>
		n++;
	return n;
  800a03:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800a06:	c9                   	leave  
  800a07:	c3                   	ret    

00800a08 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800a08:	55                   	push   %ebp
  800a09:	89 e5                	mov    %esp,%ebp
  800a0b:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800a0e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800a15:	eb 09                	jmp    800a20 <strnlen+0x18>
		n++;
  800a17:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800a1a:	ff 45 08             	incl   0x8(%ebp)
  800a1d:	ff 4d 0c             	decl   0xc(%ebp)
  800a20:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800a24:	74 09                	je     800a2f <strnlen+0x27>
  800a26:	8b 45 08             	mov    0x8(%ebp),%eax
  800a29:	8a 00                	mov    (%eax),%al
  800a2b:	84 c0                	test   %al,%al
  800a2d:	75 e8                	jne    800a17 <strnlen+0xf>
		n++;
	return n;
  800a2f:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800a32:	c9                   	leave  
  800a33:	c3                   	ret    

00800a34 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800a34:	55                   	push   %ebp
  800a35:	89 e5                	mov    %esp,%ebp
  800a37:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800a3a:	8b 45 08             	mov    0x8(%ebp),%eax
  800a3d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800a40:	90                   	nop
  800a41:	8b 45 08             	mov    0x8(%ebp),%eax
  800a44:	8d 50 01             	lea    0x1(%eax),%edx
  800a47:	89 55 08             	mov    %edx,0x8(%ebp)
  800a4a:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a4d:	8d 4a 01             	lea    0x1(%edx),%ecx
  800a50:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800a53:	8a 12                	mov    (%edx),%dl
  800a55:	88 10                	mov    %dl,(%eax)
  800a57:	8a 00                	mov    (%eax),%al
  800a59:	84 c0                	test   %al,%al
  800a5b:	75 e4                	jne    800a41 <strcpy+0xd>
		/* do nothing */;
	return ret;
  800a5d:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800a60:	c9                   	leave  
  800a61:	c3                   	ret    

00800a62 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800a62:	55                   	push   %ebp
  800a63:	89 e5                	mov    %esp,%ebp
  800a65:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800a68:	8b 45 08             	mov    0x8(%ebp),%eax
  800a6b:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800a6e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800a75:	eb 1f                	jmp    800a96 <strncpy+0x34>
		*dst++ = *src;
  800a77:	8b 45 08             	mov    0x8(%ebp),%eax
  800a7a:	8d 50 01             	lea    0x1(%eax),%edx
  800a7d:	89 55 08             	mov    %edx,0x8(%ebp)
  800a80:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a83:	8a 12                	mov    (%edx),%dl
  800a85:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800a87:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a8a:	8a 00                	mov    (%eax),%al
  800a8c:	84 c0                	test   %al,%al
  800a8e:	74 03                	je     800a93 <strncpy+0x31>
			src++;
  800a90:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800a93:	ff 45 fc             	incl   -0x4(%ebp)
  800a96:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800a99:	3b 45 10             	cmp    0x10(%ebp),%eax
  800a9c:	72 d9                	jb     800a77 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800a9e:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800aa1:	c9                   	leave  
  800aa2:	c3                   	ret    

00800aa3 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800aa3:	55                   	push   %ebp
  800aa4:	89 e5                	mov    %esp,%ebp
  800aa6:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800aa9:	8b 45 08             	mov    0x8(%ebp),%eax
  800aac:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800aaf:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ab3:	74 30                	je     800ae5 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800ab5:	eb 16                	jmp    800acd <strlcpy+0x2a>
			*dst++ = *src++;
  800ab7:	8b 45 08             	mov    0x8(%ebp),%eax
  800aba:	8d 50 01             	lea    0x1(%eax),%edx
  800abd:	89 55 08             	mov    %edx,0x8(%ebp)
  800ac0:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ac3:	8d 4a 01             	lea    0x1(%edx),%ecx
  800ac6:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800ac9:	8a 12                	mov    (%edx),%dl
  800acb:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800acd:	ff 4d 10             	decl   0x10(%ebp)
  800ad0:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ad4:	74 09                	je     800adf <strlcpy+0x3c>
  800ad6:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ad9:	8a 00                	mov    (%eax),%al
  800adb:	84 c0                	test   %al,%al
  800add:	75 d8                	jne    800ab7 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800adf:	8b 45 08             	mov    0x8(%ebp),%eax
  800ae2:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800ae5:	8b 55 08             	mov    0x8(%ebp),%edx
  800ae8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800aeb:	29 c2                	sub    %eax,%edx
  800aed:	89 d0                	mov    %edx,%eax
}
  800aef:	c9                   	leave  
  800af0:	c3                   	ret    

00800af1 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800af1:	55                   	push   %ebp
  800af2:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800af4:	eb 06                	jmp    800afc <strcmp+0xb>
		p++, q++;
  800af6:	ff 45 08             	incl   0x8(%ebp)
  800af9:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800afc:	8b 45 08             	mov    0x8(%ebp),%eax
  800aff:	8a 00                	mov    (%eax),%al
  800b01:	84 c0                	test   %al,%al
  800b03:	74 0e                	je     800b13 <strcmp+0x22>
  800b05:	8b 45 08             	mov    0x8(%ebp),%eax
  800b08:	8a 10                	mov    (%eax),%dl
  800b0a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b0d:	8a 00                	mov    (%eax),%al
  800b0f:	38 c2                	cmp    %al,%dl
  800b11:	74 e3                	je     800af6 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800b13:	8b 45 08             	mov    0x8(%ebp),%eax
  800b16:	8a 00                	mov    (%eax),%al
  800b18:	0f b6 d0             	movzbl %al,%edx
  800b1b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b1e:	8a 00                	mov    (%eax),%al
  800b20:	0f b6 c0             	movzbl %al,%eax
  800b23:	29 c2                	sub    %eax,%edx
  800b25:	89 d0                	mov    %edx,%eax
}
  800b27:	5d                   	pop    %ebp
  800b28:	c3                   	ret    

00800b29 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800b29:	55                   	push   %ebp
  800b2a:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800b2c:	eb 09                	jmp    800b37 <strncmp+0xe>
		n--, p++, q++;
  800b2e:	ff 4d 10             	decl   0x10(%ebp)
  800b31:	ff 45 08             	incl   0x8(%ebp)
  800b34:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800b37:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800b3b:	74 17                	je     800b54 <strncmp+0x2b>
  800b3d:	8b 45 08             	mov    0x8(%ebp),%eax
  800b40:	8a 00                	mov    (%eax),%al
  800b42:	84 c0                	test   %al,%al
  800b44:	74 0e                	je     800b54 <strncmp+0x2b>
  800b46:	8b 45 08             	mov    0x8(%ebp),%eax
  800b49:	8a 10                	mov    (%eax),%dl
  800b4b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b4e:	8a 00                	mov    (%eax),%al
  800b50:	38 c2                	cmp    %al,%dl
  800b52:	74 da                	je     800b2e <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800b54:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800b58:	75 07                	jne    800b61 <strncmp+0x38>
		return 0;
  800b5a:	b8 00 00 00 00       	mov    $0x0,%eax
  800b5f:	eb 14                	jmp    800b75 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800b61:	8b 45 08             	mov    0x8(%ebp),%eax
  800b64:	8a 00                	mov    (%eax),%al
  800b66:	0f b6 d0             	movzbl %al,%edx
  800b69:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b6c:	8a 00                	mov    (%eax),%al
  800b6e:	0f b6 c0             	movzbl %al,%eax
  800b71:	29 c2                	sub    %eax,%edx
  800b73:	89 d0                	mov    %edx,%eax
}
  800b75:	5d                   	pop    %ebp
  800b76:	c3                   	ret    

00800b77 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800b77:	55                   	push   %ebp
  800b78:	89 e5                	mov    %esp,%ebp
  800b7a:	83 ec 04             	sub    $0x4,%esp
  800b7d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b80:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800b83:	eb 12                	jmp    800b97 <strchr+0x20>
		if (*s == c)
  800b85:	8b 45 08             	mov    0x8(%ebp),%eax
  800b88:	8a 00                	mov    (%eax),%al
  800b8a:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800b8d:	75 05                	jne    800b94 <strchr+0x1d>
			return (char *) s;
  800b8f:	8b 45 08             	mov    0x8(%ebp),%eax
  800b92:	eb 11                	jmp    800ba5 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800b94:	ff 45 08             	incl   0x8(%ebp)
  800b97:	8b 45 08             	mov    0x8(%ebp),%eax
  800b9a:	8a 00                	mov    (%eax),%al
  800b9c:	84 c0                	test   %al,%al
  800b9e:	75 e5                	jne    800b85 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800ba0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800ba5:	c9                   	leave  
  800ba6:	c3                   	ret    

00800ba7 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800ba7:	55                   	push   %ebp
  800ba8:	89 e5                	mov    %esp,%ebp
  800baa:	83 ec 04             	sub    $0x4,%esp
  800bad:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bb0:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800bb3:	eb 0d                	jmp    800bc2 <strfind+0x1b>
		if (*s == c)
  800bb5:	8b 45 08             	mov    0x8(%ebp),%eax
  800bb8:	8a 00                	mov    (%eax),%al
  800bba:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800bbd:	74 0e                	je     800bcd <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800bbf:	ff 45 08             	incl   0x8(%ebp)
  800bc2:	8b 45 08             	mov    0x8(%ebp),%eax
  800bc5:	8a 00                	mov    (%eax),%al
  800bc7:	84 c0                	test   %al,%al
  800bc9:	75 ea                	jne    800bb5 <strfind+0xe>
  800bcb:	eb 01                	jmp    800bce <strfind+0x27>
		if (*s == c)
			break;
  800bcd:	90                   	nop
	return (char *) s;
  800bce:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800bd1:	c9                   	leave  
  800bd2:	c3                   	ret    

00800bd3 <memset>:

// *************** The faster implementation of memset & memcpy is implemented by *************
// ****************** Team80 (Yahia Khaled, Malek Ahmed et al) - FCIS'24-25 *******************
void *
memset(void *v, int c, uint32 n)
{
  800bd3:	55                   	push   %ebp
  800bd4:	89 e5                	mov    %esp,%ebp
  800bd6:	83 ec 10             	sub    $0x10,%esp
//	m = n;
//	while (--m >= 0)
//		*p++ = c;

	/*Faster Implementation*/
	uint64* p64 = (uint64*)v;
  800bd9:	8b 45 08             	mov    0x8(%ebp),%eax
  800bdc:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if(n >= 8){
  800bdf:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800be3:	76 63                	jbe    800c48 <memset+0x75>
		uint64 data_block = c;
  800be5:	8b 45 0c             	mov    0xc(%ebp),%eax
  800be8:	99                   	cltd   
  800be9:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800bec:	89 55 f4             	mov    %edx,-0xc(%ebp)
		data_block |= data_block << 8;
  800bef:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800bf2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800bf5:	0f a4 c2 08          	shld   $0x8,%eax,%edx
  800bf9:	c1 e0 08             	shl    $0x8,%eax
  800bfc:	09 45 f0             	or     %eax,-0x10(%ebp)
  800bff:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 16;
  800c02:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800c05:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800c08:	0f a4 c2 10          	shld   $0x10,%eax,%edx
  800c0c:	c1 e0 10             	shl    $0x10,%eax
  800c0f:	09 45 f0             	or     %eax,-0x10(%ebp)
  800c12:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 32;
  800c15:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800c18:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800c1b:	89 c2                	mov    %eax,%edx
  800c1d:	b8 00 00 00 00       	mov    $0x0,%eax
  800c22:	09 45 f0             	or     %eax,-0x10(%ebp)
  800c25:	09 55 f4             	or     %edx,-0xc(%ebp)

		while(n >= 8)
  800c28:	eb 18                	jmp    800c42 <memset+0x6f>
			*p64++ = data_block, n -= 8;
  800c2a:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  800c2d:	8d 41 08             	lea    0x8(%ecx),%eax
  800c30:	89 45 fc             	mov    %eax,-0x4(%ebp)
  800c33:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800c36:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800c39:	89 01                	mov    %eax,(%ecx)
  800c3b:	89 51 04             	mov    %edx,0x4(%ecx)
  800c3e:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
		uint64 data_block = c;
		data_block |= data_block << 8;
		data_block |= data_block << 16;
		data_block |= data_block << 32;

		while(n >= 8)
  800c42:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800c46:	77 e2                	ja     800c2a <memset+0x57>
			*p64++ = data_block, n -= 8;
	}

	if(n){
  800c48:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800c4c:	74 23                	je     800c71 <memset+0x9e>
		uint8* p8 = (uint8*)p64;
  800c4e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800c51:	89 45 f8             	mov    %eax,-0x8(%ebp)
		while (n-- > 0)
  800c54:	eb 0e                	jmp    800c64 <memset+0x91>
			*p8++ = (uint8)c;
  800c56:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800c59:	8d 50 01             	lea    0x1(%eax),%edx
  800c5c:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800c5f:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c62:	88 10                	mov    %dl,(%eax)
			*p64++ = data_block, n -= 8;
	}

	if(n){
		uint8* p8 = (uint8*)p64;
		while (n-- > 0)
  800c64:	8b 45 10             	mov    0x10(%ebp),%eax
  800c67:	8d 50 ff             	lea    -0x1(%eax),%edx
  800c6a:	89 55 10             	mov    %edx,0x10(%ebp)
  800c6d:	85 c0                	test   %eax,%eax
  800c6f:	75 e5                	jne    800c56 <memset+0x83>
			*p8++ = (uint8)c;
	}

	return v;
  800c71:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800c74:	c9                   	leave  
  800c75:	c3                   	ret    

00800c76 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800c76:	55                   	push   %ebp
  800c77:	89 e5                	mov    %esp,%ebp
  800c79:	83 ec 10             	sub    $0x10,%esp
	//	s = src;
	//	d = dst;
	//	while (n-- > 0)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
  800c7c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c7f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	uint64* d64 = (uint64*)dst;
  800c82:	8b 45 08             	mov    0x8(%ebp),%eax
  800c85:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if(n >= 8){
  800c88:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800c8c:	76 24                	jbe    800cb2 <memcpy+0x3c>
		while(n >= 8){
  800c8e:	eb 1c                	jmp    800cac <memcpy+0x36>
			*d64 = *s64;
  800c90:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800c93:	8b 50 04             	mov    0x4(%eax),%edx
  800c96:	8b 00                	mov    (%eax),%eax
  800c98:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  800c9b:	89 01                	mov    %eax,(%ecx)
  800c9d:	89 51 04             	mov    %edx,0x4(%ecx)
			n -= 8;
  800ca0:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
			++s64;
  800ca4:	83 45 fc 08          	addl   $0x8,-0x4(%ebp)
			++d64;
  800ca8:	83 45 f8 08          	addl   $0x8,-0x8(%ebp)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
	uint64* d64 = (uint64*)dst;
	if(n >= 8){
		while(n >= 8){
  800cac:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800cb0:	77 de                	ja     800c90 <memcpy+0x1a>
			++s64;
			++d64;
		}
	}

	if(n){
  800cb2:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800cb6:	74 31                	je     800ce9 <memcpy+0x73>
		uint8* s8 = (uint8*)s64;
  800cb8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800cbb:	89 45 f4             	mov    %eax,-0xc(%ebp)
		uint8* d8 = (uint8*)d64;
  800cbe:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800cc1:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (n-- > 0)
  800cc4:	eb 16                	jmp    800cdc <memcpy+0x66>
			*d8++ = *s8++;
  800cc6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800cc9:	8d 50 01             	lea    0x1(%eax),%edx
  800ccc:	89 55 f0             	mov    %edx,-0x10(%ebp)
  800ccf:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800cd2:	8d 4a 01             	lea    0x1(%edx),%ecx
  800cd5:	89 4d f4             	mov    %ecx,-0xc(%ebp)
  800cd8:	8a 12                	mov    (%edx),%dl
  800cda:	88 10                	mov    %dl,(%eax)
	}

	if(n){
		uint8* s8 = (uint8*)s64;
		uint8* d8 = (uint8*)d64;
		while (n-- > 0)
  800cdc:	8b 45 10             	mov    0x10(%ebp),%eax
  800cdf:	8d 50 ff             	lea    -0x1(%eax),%edx
  800ce2:	89 55 10             	mov    %edx,0x10(%ebp)
  800ce5:	85 c0                	test   %eax,%eax
  800ce7:	75 dd                	jne    800cc6 <memcpy+0x50>
			*d8++ = *s8++;
	}
	return dst;
  800ce9:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800cec:	c9                   	leave  
  800ced:	c3                   	ret    

00800cee <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800cee:	55                   	push   %ebp
  800cef:	89 e5                	mov    %esp,%ebp
  800cf1:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800cf4:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cf7:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800cfa:	8b 45 08             	mov    0x8(%ebp),%eax
  800cfd:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800d00:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d03:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800d06:	73 50                	jae    800d58 <memmove+0x6a>
  800d08:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800d0b:	8b 45 10             	mov    0x10(%ebp),%eax
  800d0e:	01 d0                	add    %edx,%eax
  800d10:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800d13:	76 43                	jbe    800d58 <memmove+0x6a>
		s += n;
  800d15:	8b 45 10             	mov    0x10(%ebp),%eax
  800d18:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800d1b:	8b 45 10             	mov    0x10(%ebp),%eax
  800d1e:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800d21:	eb 10                	jmp    800d33 <memmove+0x45>
			*--d = *--s;
  800d23:	ff 4d f8             	decl   -0x8(%ebp)
  800d26:	ff 4d fc             	decl   -0x4(%ebp)
  800d29:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d2c:	8a 10                	mov    (%eax),%dl
  800d2e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800d31:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800d33:	8b 45 10             	mov    0x10(%ebp),%eax
  800d36:	8d 50 ff             	lea    -0x1(%eax),%edx
  800d39:	89 55 10             	mov    %edx,0x10(%ebp)
  800d3c:	85 c0                	test   %eax,%eax
  800d3e:	75 e3                	jne    800d23 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800d40:	eb 23                	jmp    800d65 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800d42:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800d45:	8d 50 01             	lea    0x1(%eax),%edx
  800d48:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800d4b:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800d4e:	8d 4a 01             	lea    0x1(%edx),%ecx
  800d51:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800d54:	8a 12                	mov    (%edx),%dl
  800d56:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800d58:	8b 45 10             	mov    0x10(%ebp),%eax
  800d5b:	8d 50 ff             	lea    -0x1(%eax),%edx
  800d5e:	89 55 10             	mov    %edx,0x10(%ebp)
  800d61:	85 c0                	test   %eax,%eax
  800d63:	75 dd                	jne    800d42 <memmove+0x54>
			*d++ = *s++;

	return dst;
  800d65:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800d68:	c9                   	leave  
  800d69:	c3                   	ret    

00800d6a <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  800d6a:	55                   	push   %ebp
  800d6b:	89 e5                	mov    %esp,%ebp
  800d6d:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  800d70:	8b 45 08             	mov    0x8(%ebp),%eax
  800d73:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  800d76:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d79:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800d7c:	eb 2a                	jmp    800da8 <memcmp+0x3e>
		if (*s1 != *s2)
  800d7e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d81:	8a 10                	mov    (%eax),%dl
  800d83:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800d86:	8a 00                	mov    (%eax),%al
  800d88:	38 c2                	cmp    %al,%dl
  800d8a:	74 16                	je     800da2 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  800d8c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d8f:	8a 00                	mov    (%eax),%al
  800d91:	0f b6 d0             	movzbl %al,%edx
  800d94:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800d97:	8a 00                	mov    (%eax),%al
  800d99:	0f b6 c0             	movzbl %al,%eax
  800d9c:	29 c2                	sub    %eax,%edx
  800d9e:	89 d0                	mov    %edx,%eax
  800da0:	eb 18                	jmp    800dba <memcmp+0x50>
		s1++, s2++;
  800da2:	ff 45 fc             	incl   -0x4(%ebp)
  800da5:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  800da8:	8b 45 10             	mov    0x10(%ebp),%eax
  800dab:	8d 50 ff             	lea    -0x1(%eax),%edx
  800dae:	89 55 10             	mov    %edx,0x10(%ebp)
  800db1:	85 c0                	test   %eax,%eax
  800db3:	75 c9                	jne    800d7e <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800db5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800dba:	c9                   	leave  
  800dbb:	c3                   	ret    

00800dbc <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  800dbc:	55                   	push   %ebp
  800dbd:	89 e5                	mov    %esp,%ebp
  800dbf:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  800dc2:	8b 55 08             	mov    0x8(%ebp),%edx
  800dc5:	8b 45 10             	mov    0x10(%ebp),%eax
  800dc8:	01 d0                	add    %edx,%eax
  800dca:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  800dcd:	eb 15                	jmp    800de4 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  800dcf:	8b 45 08             	mov    0x8(%ebp),%eax
  800dd2:	8a 00                	mov    (%eax),%al
  800dd4:	0f b6 d0             	movzbl %al,%edx
  800dd7:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dda:	0f b6 c0             	movzbl %al,%eax
  800ddd:	39 c2                	cmp    %eax,%edx
  800ddf:	74 0d                	je     800dee <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800de1:	ff 45 08             	incl   0x8(%ebp)
  800de4:	8b 45 08             	mov    0x8(%ebp),%eax
  800de7:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  800dea:	72 e3                	jb     800dcf <memfind+0x13>
  800dec:	eb 01                	jmp    800def <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  800dee:	90                   	nop
	return (void *) s;
  800def:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800df2:	c9                   	leave  
  800df3:	c3                   	ret    

00800df4 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800df4:	55                   	push   %ebp
  800df5:	89 e5                	mov    %esp,%ebp
  800df7:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  800dfa:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  800e01:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800e08:	eb 03                	jmp    800e0d <strtol+0x19>
		s++;
  800e0a:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800e0d:	8b 45 08             	mov    0x8(%ebp),%eax
  800e10:	8a 00                	mov    (%eax),%al
  800e12:	3c 20                	cmp    $0x20,%al
  800e14:	74 f4                	je     800e0a <strtol+0x16>
  800e16:	8b 45 08             	mov    0x8(%ebp),%eax
  800e19:	8a 00                	mov    (%eax),%al
  800e1b:	3c 09                	cmp    $0x9,%al
  800e1d:	74 eb                	je     800e0a <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  800e1f:	8b 45 08             	mov    0x8(%ebp),%eax
  800e22:	8a 00                	mov    (%eax),%al
  800e24:	3c 2b                	cmp    $0x2b,%al
  800e26:	75 05                	jne    800e2d <strtol+0x39>
		s++;
  800e28:	ff 45 08             	incl   0x8(%ebp)
  800e2b:	eb 13                	jmp    800e40 <strtol+0x4c>
	else if (*s == '-')
  800e2d:	8b 45 08             	mov    0x8(%ebp),%eax
  800e30:	8a 00                	mov    (%eax),%al
  800e32:	3c 2d                	cmp    $0x2d,%al
  800e34:	75 0a                	jne    800e40 <strtol+0x4c>
		s++, neg = 1;
  800e36:	ff 45 08             	incl   0x8(%ebp)
  800e39:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800e40:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e44:	74 06                	je     800e4c <strtol+0x58>
  800e46:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  800e4a:	75 20                	jne    800e6c <strtol+0x78>
  800e4c:	8b 45 08             	mov    0x8(%ebp),%eax
  800e4f:	8a 00                	mov    (%eax),%al
  800e51:	3c 30                	cmp    $0x30,%al
  800e53:	75 17                	jne    800e6c <strtol+0x78>
  800e55:	8b 45 08             	mov    0x8(%ebp),%eax
  800e58:	40                   	inc    %eax
  800e59:	8a 00                	mov    (%eax),%al
  800e5b:	3c 78                	cmp    $0x78,%al
  800e5d:	75 0d                	jne    800e6c <strtol+0x78>
		s += 2, base = 16;
  800e5f:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  800e63:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  800e6a:	eb 28                	jmp    800e94 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  800e6c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e70:	75 15                	jne    800e87 <strtol+0x93>
  800e72:	8b 45 08             	mov    0x8(%ebp),%eax
  800e75:	8a 00                	mov    (%eax),%al
  800e77:	3c 30                	cmp    $0x30,%al
  800e79:	75 0c                	jne    800e87 <strtol+0x93>
		s++, base = 8;
  800e7b:	ff 45 08             	incl   0x8(%ebp)
  800e7e:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  800e85:	eb 0d                	jmp    800e94 <strtol+0xa0>
	else if (base == 0)
  800e87:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e8b:	75 07                	jne    800e94 <strtol+0xa0>
		base = 10;
  800e8d:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800e94:	8b 45 08             	mov    0x8(%ebp),%eax
  800e97:	8a 00                	mov    (%eax),%al
  800e99:	3c 2f                	cmp    $0x2f,%al
  800e9b:	7e 19                	jle    800eb6 <strtol+0xc2>
  800e9d:	8b 45 08             	mov    0x8(%ebp),%eax
  800ea0:	8a 00                	mov    (%eax),%al
  800ea2:	3c 39                	cmp    $0x39,%al
  800ea4:	7f 10                	jg     800eb6 <strtol+0xc2>
			dig = *s - '0';
  800ea6:	8b 45 08             	mov    0x8(%ebp),%eax
  800ea9:	8a 00                	mov    (%eax),%al
  800eab:	0f be c0             	movsbl %al,%eax
  800eae:	83 e8 30             	sub    $0x30,%eax
  800eb1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800eb4:	eb 42                	jmp    800ef8 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  800eb6:	8b 45 08             	mov    0x8(%ebp),%eax
  800eb9:	8a 00                	mov    (%eax),%al
  800ebb:	3c 60                	cmp    $0x60,%al
  800ebd:	7e 19                	jle    800ed8 <strtol+0xe4>
  800ebf:	8b 45 08             	mov    0x8(%ebp),%eax
  800ec2:	8a 00                	mov    (%eax),%al
  800ec4:	3c 7a                	cmp    $0x7a,%al
  800ec6:	7f 10                	jg     800ed8 <strtol+0xe4>
			dig = *s - 'a' + 10;
  800ec8:	8b 45 08             	mov    0x8(%ebp),%eax
  800ecb:	8a 00                	mov    (%eax),%al
  800ecd:	0f be c0             	movsbl %al,%eax
  800ed0:	83 e8 57             	sub    $0x57,%eax
  800ed3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800ed6:	eb 20                	jmp    800ef8 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  800ed8:	8b 45 08             	mov    0x8(%ebp),%eax
  800edb:	8a 00                	mov    (%eax),%al
  800edd:	3c 40                	cmp    $0x40,%al
  800edf:	7e 39                	jle    800f1a <strtol+0x126>
  800ee1:	8b 45 08             	mov    0x8(%ebp),%eax
  800ee4:	8a 00                	mov    (%eax),%al
  800ee6:	3c 5a                	cmp    $0x5a,%al
  800ee8:	7f 30                	jg     800f1a <strtol+0x126>
			dig = *s - 'A' + 10;
  800eea:	8b 45 08             	mov    0x8(%ebp),%eax
  800eed:	8a 00                	mov    (%eax),%al
  800eef:	0f be c0             	movsbl %al,%eax
  800ef2:	83 e8 37             	sub    $0x37,%eax
  800ef5:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  800ef8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800efb:	3b 45 10             	cmp    0x10(%ebp),%eax
  800efe:	7d 19                	jge    800f19 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  800f00:	ff 45 08             	incl   0x8(%ebp)
  800f03:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f06:	0f af 45 10          	imul   0x10(%ebp),%eax
  800f0a:	89 c2                	mov    %eax,%edx
  800f0c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800f0f:	01 d0                	add    %edx,%eax
  800f11:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  800f14:	e9 7b ff ff ff       	jmp    800e94 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  800f19:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  800f1a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800f1e:	74 08                	je     800f28 <strtol+0x134>
		*endptr = (char *) s;
  800f20:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f23:	8b 55 08             	mov    0x8(%ebp),%edx
  800f26:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  800f28:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  800f2c:	74 07                	je     800f35 <strtol+0x141>
  800f2e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f31:	f7 d8                	neg    %eax
  800f33:	eb 03                	jmp    800f38 <strtol+0x144>
  800f35:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800f38:	c9                   	leave  
  800f39:	c3                   	ret    

00800f3a <ltostr>:

void
ltostr(long value, char *str)
{
  800f3a:	55                   	push   %ebp
  800f3b:	89 e5                	mov    %esp,%ebp
  800f3d:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  800f40:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  800f47:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  800f4e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800f52:	79 13                	jns    800f67 <ltostr+0x2d>
	{
		neg = 1;
  800f54:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  800f5b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f5e:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  800f61:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  800f64:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  800f67:	8b 45 08             	mov    0x8(%ebp),%eax
  800f6a:	b9 0a 00 00 00       	mov    $0xa,%ecx
  800f6f:	99                   	cltd   
  800f70:	f7 f9                	idiv   %ecx
  800f72:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  800f75:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f78:	8d 50 01             	lea    0x1(%eax),%edx
  800f7b:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800f7e:	89 c2                	mov    %eax,%edx
  800f80:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f83:	01 d0                	add    %edx,%eax
  800f85:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800f88:	83 c2 30             	add    $0x30,%edx
  800f8b:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  800f8d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800f90:	b8 67 66 66 66       	mov    $0x66666667,%eax
  800f95:	f7 e9                	imul   %ecx
  800f97:	c1 fa 02             	sar    $0x2,%edx
  800f9a:	89 c8                	mov    %ecx,%eax
  800f9c:	c1 f8 1f             	sar    $0x1f,%eax
  800f9f:	29 c2                	sub    %eax,%edx
  800fa1:	89 d0                	mov    %edx,%eax
  800fa3:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  800fa6:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800faa:	75 bb                	jne    800f67 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  800fac:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  800fb3:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800fb6:	48                   	dec    %eax
  800fb7:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  800fba:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  800fbe:	74 3d                	je     800ffd <ltostr+0xc3>
		start = 1 ;
  800fc0:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  800fc7:	eb 34                	jmp    800ffd <ltostr+0xc3>
	{
		char tmp = str[start] ;
  800fc9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800fcc:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fcf:	01 d0                	add    %edx,%eax
  800fd1:	8a 00                	mov    (%eax),%al
  800fd3:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  800fd6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800fd9:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fdc:	01 c2                	add    %eax,%edx
  800fde:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  800fe1:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fe4:	01 c8                	add    %ecx,%eax
  800fe6:	8a 00                	mov    (%eax),%al
  800fe8:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  800fea:	8b 55 f0             	mov    -0x10(%ebp),%edx
  800fed:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ff0:	01 c2                	add    %eax,%edx
  800ff2:	8a 45 eb             	mov    -0x15(%ebp),%al
  800ff5:	88 02                	mov    %al,(%edx)
		start++ ;
  800ff7:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  800ffa:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  800ffd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801000:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801003:	7c c4                	jl     800fc9 <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801005:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801008:	8b 45 0c             	mov    0xc(%ebp),%eax
  80100b:	01 d0                	add    %edx,%eax
  80100d:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801010:	90                   	nop
  801011:	c9                   	leave  
  801012:	c3                   	ret    

00801013 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  801013:	55                   	push   %ebp
  801014:	89 e5                	mov    %esp,%ebp
  801016:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801019:	ff 75 08             	pushl  0x8(%ebp)
  80101c:	e8 c4 f9 ff ff       	call   8009e5 <strlen>
  801021:	83 c4 04             	add    $0x4,%esp
  801024:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  801027:	ff 75 0c             	pushl  0xc(%ebp)
  80102a:	e8 b6 f9 ff ff       	call   8009e5 <strlen>
  80102f:	83 c4 04             	add    $0x4,%esp
  801032:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  801035:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  80103c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801043:	eb 17                	jmp    80105c <strcconcat+0x49>
		final[s] = str1[s] ;
  801045:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801048:	8b 45 10             	mov    0x10(%ebp),%eax
  80104b:	01 c2                	add    %eax,%edx
  80104d:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801050:	8b 45 08             	mov    0x8(%ebp),%eax
  801053:	01 c8                	add    %ecx,%eax
  801055:	8a 00                	mov    (%eax),%al
  801057:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  801059:	ff 45 fc             	incl   -0x4(%ebp)
  80105c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80105f:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801062:	7c e1                	jl     801045 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  801064:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  80106b:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  801072:	eb 1f                	jmp    801093 <strcconcat+0x80>
		final[s++] = str2[i] ;
  801074:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801077:	8d 50 01             	lea    0x1(%eax),%edx
  80107a:	89 55 fc             	mov    %edx,-0x4(%ebp)
  80107d:	89 c2                	mov    %eax,%edx
  80107f:	8b 45 10             	mov    0x10(%ebp),%eax
  801082:	01 c2                	add    %eax,%edx
  801084:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801087:	8b 45 0c             	mov    0xc(%ebp),%eax
  80108a:	01 c8                	add    %ecx,%eax
  80108c:	8a 00                	mov    (%eax),%al
  80108e:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801090:	ff 45 f8             	incl   -0x8(%ebp)
  801093:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801096:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801099:	7c d9                	jl     801074 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  80109b:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80109e:	8b 45 10             	mov    0x10(%ebp),%eax
  8010a1:	01 d0                	add    %edx,%eax
  8010a3:	c6 00 00             	movb   $0x0,(%eax)
}
  8010a6:	90                   	nop
  8010a7:	c9                   	leave  
  8010a8:	c3                   	ret    

008010a9 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  8010a9:	55                   	push   %ebp
  8010aa:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  8010ac:	8b 45 14             	mov    0x14(%ebp),%eax
  8010af:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  8010b5:	8b 45 14             	mov    0x14(%ebp),%eax
  8010b8:	8b 00                	mov    (%eax),%eax
  8010ba:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8010c1:	8b 45 10             	mov    0x10(%ebp),%eax
  8010c4:	01 d0                	add    %edx,%eax
  8010c6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8010cc:	eb 0c                	jmp    8010da <strsplit+0x31>
			*string++ = 0;
  8010ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8010d1:	8d 50 01             	lea    0x1(%eax),%edx
  8010d4:	89 55 08             	mov    %edx,0x8(%ebp)
  8010d7:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8010da:	8b 45 08             	mov    0x8(%ebp),%eax
  8010dd:	8a 00                	mov    (%eax),%al
  8010df:	84 c0                	test   %al,%al
  8010e1:	74 18                	je     8010fb <strsplit+0x52>
  8010e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8010e6:	8a 00                	mov    (%eax),%al
  8010e8:	0f be c0             	movsbl %al,%eax
  8010eb:	50                   	push   %eax
  8010ec:	ff 75 0c             	pushl  0xc(%ebp)
  8010ef:	e8 83 fa ff ff       	call   800b77 <strchr>
  8010f4:	83 c4 08             	add    $0x8,%esp
  8010f7:	85 c0                	test   %eax,%eax
  8010f9:	75 d3                	jne    8010ce <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  8010fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8010fe:	8a 00                	mov    (%eax),%al
  801100:	84 c0                	test   %al,%al
  801102:	74 5a                	je     80115e <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801104:	8b 45 14             	mov    0x14(%ebp),%eax
  801107:	8b 00                	mov    (%eax),%eax
  801109:	83 f8 0f             	cmp    $0xf,%eax
  80110c:	75 07                	jne    801115 <strsplit+0x6c>
		{
			return 0;
  80110e:	b8 00 00 00 00       	mov    $0x0,%eax
  801113:	eb 66                	jmp    80117b <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801115:	8b 45 14             	mov    0x14(%ebp),%eax
  801118:	8b 00                	mov    (%eax),%eax
  80111a:	8d 48 01             	lea    0x1(%eax),%ecx
  80111d:	8b 55 14             	mov    0x14(%ebp),%edx
  801120:	89 0a                	mov    %ecx,(%edx)
  801122:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801129:	8b 45 10             	mov    0x10(%ebp),%eax
  80112c:	01 c2                	add    %eax,%edx
  80112e:	8b 45 08             	mov    0x8(%ebp),%eax
  801131:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801133:	eb 03                	jmp    801138 <strsplit+0x8f>
			string++;
  801135:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801138:	8b 45 08             	mov    0x8(%ebp),%eax
  80113b:	8a 00                	mov    (%eax),%al
  80113d:	84 c0                	test   %al,%al
  80113f:	74 8b                	je     8010cc <strsplit+0x23>
  801141:	8b 45 08             	mov    0x8(%ebp),%eax
  801144:	8a 00                	mov    (%eax),%al
  801146:	0f be c0             	movsbl %al,%eax
  801149:	50                   	push   %eax
  80114a:	ff 75 0c             	pushl  0xc(%ebp)
  80114d:	e8 25 fa ff ff       	call   800b77 <strchr>
  801152:	83 c4 08             	add    $0x8,%esp
  801155:	85 c0                	test   %eax,%eax
  801157:	74 dc                	je     801135 <strsplit+0x8c>
			string++;
	}
  801159:	e9 6e ff ff ff       	jmp    8010cc <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  80115e:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  80115f:	8b 45 14             	mov    0x14(%ebp),%eax
  801162:	8b 00                	mov    (%eax),%eax
  801164:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80116b:	8b 45 10             	mov    0x10(%ebp),%eax
  80116e:	01 d0                	add    %edx,%eax
  801170:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801176:	b8 01 00 00 00       	mov    $0x1,%eax
}
  80117b:	c9                   	leave  
  80117c:	c3                   	ret    

0080117d <str2lower>:


char* str2lower(char *dst, const char *src)
{
  80117d:	55                   	push   %ebp
  80117e:	89 e5                	mov    %esp,%ebp
  801180:	83 ec 10             	sub    $0x10,%esp
	char* ret = dst;
  801183:	8b 45 08             	mov    0x8(%ebp),%eax
  801186:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (int i = 0; i < strlen(src); ++i)
  801189:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801190:	eb 4a                	jmp    8011dc <str2lower+0x5f>
	{
		dst[i] = src[i] ;
  801192:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801195:	8b 45 08             	mov    0x8(%ebp),%eax
  801198:	01 c2                	add    %eax,%edx
  80119a:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  80119d:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011a0:	01 c8                	add    %ecx,%eax
  8011a2:	8a 00                	mov    (%eax),%al
  8011a4:	88 02                	mov    %al,(%edx)
		if (src[i] >= 'A' && src[i] <= 'Z')
  8011a6:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8011a9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011ac:	01 d0                	add    %edx,%eax
  8011ae:	8a 00                	mov    (%eax),%al
  8011b0:	3c 40                	cmp    $0x40,%al
  8011b2:	7e 25                	jle    8011d9 <str2lower+0x5c>
  8011b4:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8011b7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011ba:	01 d0                	add    %edx,%eax
  8011bc:	8a 00                	mov    (%eax),%al
  8011be:	3c 5a                	cmp    $0x5a,%al
  8011c0:	7f 17                	jg     8011d9 <str2lower+0x5c>
		{
			dst[i] += 32 ;
  8011c2:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8011c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8011c8:	01 d0                	add    %edx,%eax
  8011ca:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8011cd:	8b 55 08             	mov    0x8(%ebp),%edx
  8011d0:	01 ca                	add    %ecx,%edx
  8011d2:	8a 12                	mov    (%edx),%dl
  8011d4:	83 c2 20             	add    $0x20,%edx
  8011d7:	88 10                	mov    %dl,(%eax)


char* str2lower(char *dst, const char *src)
{
	char* ret = dst;
	for (int i = 0; i < strlen(src); ++i)
  8011d9:	ff 45 fc             	incl   -0x4(%ebp)
  8011dc:	ff 75 0c             	pushl  0xc(%ebp)
  8011df:	e8 01 f8 ff ff       	call   8009e5 <strlen>
  8011e4:	83 c4 04             	add    $0x4,%esp
  8011e7:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  8011ea:	7f a6                	jg     801192 <str2lower+0x15>
		if (src[i] >= 'A' && src[i] <= 'Z')
		{
			dst[i] += 32 ;
		}
	}
	return ret;
  8011ec:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8011ef:	c9                   	leave  
  8011f0:	c3                   	ret    

008011f1 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  8011f1:	55                   	push   %ebp
  8011f2:	89 e5                	mov    %esp,%ebp
  8011f4:	57                   	push   %edi
  8011f5:	56                   	push   %esi
  8011f6:	53                   	push   %ebx
  8011f7:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8011fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8011fd:	8b 55 0c             	mov    0xc(%ebp),%edx
  801200:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801203:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801206:	8b 7d 18             	mov    0x18(%ebp),%edi
  801209:	8b 75 1c             	mov    0x1c(%ebp),%esi
  80120c:	cd 30                	int    $0x30
  80120e:	89 45 f0             	mov    %eax,-0x10(%ebp)
				"b" (a3),
				"D" (a4),
				"S" (a5)
				: "cc", "memory");

	return ret;
  801211:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801214:	83 c4 10             	add    $0x10,%esp
  801217:	5b                   	pop    %ebx
  801218:	5e                   	pop    %esi
  801219:	5f                   	pop    %edi
  80121a:	5d                   	pop    %ebp
  80121b:	c3                   	ret    

0080121c <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName, int color)
{
  80121c:	55                   	push   %ebp
  80121d:	89 e5                	mov    %esp,%ebp
  80121f:	83 ec 04             	sub    $0x4,%esp
  801222:	8b 45 10             	mov    0x10(%ebp),%eax
  801225:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, color, 0);
  801228:	8b 4d 14             	mov    0x14(%ebp),%ecx
  80122b:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80122f:	8b 45 08             	mov    0x8(%ebp),%eax
  801232:	6a 00                	push   $0x0
  801234:	51                   	push   %ecx
  801235:	52                   	push   %edx
  801236:	ff 75 0c             	pushl  0xc(%ebp)
  801239:	50                   	push   %eax
  80123a:	6a 00                	push   $0x0
  80123c:	e8 b0 ff ff ff       	call   8011f1 <syscall>
  801241:	83 c4 18             	add    $0x18,%esp
}
  801244:	90                   	nop
  801245:	c9                   	leave  
  801246:	c3                   	ret    

00801247 <sys_cgetc>:

int
sys_cgetc(void)
{
  801247:	55                   	push   %ebp
  801248:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  80124a:	6a 00                	push   $0x0
  80124c:	6a 00                	push   $0x0
  80124e:	6a 00                	push   $0x0
  801250:	6a 00                	push   $0x0
  801252:	6a 00                	push   $0x0
  801254:	6a 02                	push   $0x2
  801256:	e8 96 ff ff ff       	call   8011f1 <syscall>
  80125b:	83 c4 18             	add    $0x18,%esp
}
  80125e:	c9                   	leave  
  80125f:	c3                   	ret    

00801260 <sys_lock_cons>:

void sys_lock_cons(void)
{
  801260:	55                   	push   %ebp
  801261:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  801263:	6a 00                	push   $0x0
  801265:	6a 00                	push   $0x0
  801267:	6a 00                	push   $0x0
  801269:	6a 00                	push   $0x0
  80126b:	6a 00                	push   $0x0
  80126d:	6a 03                	push   $0x3
  80126f:	e8 7d ff ff ff       	call   8011f1 <syscall>
  801274:	83 c4 18             	add    $0x18,%esp
}
  801277:	90                   	nop
  801278:	c9                   	leave  
  801279:	c3                   	ret    

0080127a <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  80127a:	55                   	push   %ebp
  80127b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  80127d:	6a 00                	push   $0x0
  80127f:	6a 00                	push   $0x0
  801281:	6a 00                	push   $0x0
  801283:	6a 00                	push   $0x0
  801285:	6a 00                	push   $0x0
  801287:	6a 04                	push   $0x4
  801289:	e8 63 ff ff ff       	call   8011f1 <syscall>
  80128e:	83 c4 18             	add    $0x18,%esp
}
  801291:	90                   	nop
  801292:	c9                   	leave  
  801293:	c3                   	ret    

00801294 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801294:	55                   	push   %ebp
  801295:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801297:	8b 55 0c             	mov    0xc(%ebp),%edx
  80129a:	8b 45 08             	mov    0x8(%ebp),%eax
  80129d:	6a 00                	push   $0x0
  80129f:	6a 00                	push   $0x0
  8012a1:	6a 00                	push   $0x0
  8012a3:	52                   	push   %edx
  8012a4:	50                   	push   %eax
  8012a5:	6a 08                	push   $0x8
  8012a7:	e8 45 ff ff ff       	call   8011f1 <syscall>
  8012ac:	83 c4 18             	add    $0x18,%esp
}
  8012af:	c9                   	leave  
  8012b0:	c3                   	ret    

008012b1 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  8012b1:	55                   	push   %ebp
  8012b2:	89 e5                	mov    %esp,%ebp
  8012b4:	56                   	push   %esi
  8012b5:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  8012b6:	8b 75 18             	mov    0x18(%ebp),%esi
  8012b9:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8012bc:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8012bf:	8b 55 0c             	mov    0xc(%ebp),%edx
  8012c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8012c5:	56                   	push   %esi
  8012c6:	53                   	push   %ebx
  8012c7:	51                   	push   %ecx
  8012c8:	52                   	push   %edx
  8012c9:	50                   	push   %eax
  8012ca:	6a 09                	push   $0x9
  8012cc:	e8 20 ff ff ff       	call   8011f1 <syscall>
  8012d1:	83 c4 18             	add    $0x18,%esp
}
  8012d4:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8012d7:	5b                   	pop    %ebx
  8012d8:	5e                   	pop    %esi
  8012d9:	5d                   	pop    %ebp
  8012da:	c3                   	ret    

008012db <__sys_unmap_frame>:

int __sys_unmap_frame(uint32 va)
{
  8012db:	55                   	push   %ebp
  8012dc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, va, 0, 0, 0, 0);
  8012de:	6a 00                	push   $0x0
  8012e0:	6a 00                	push   $0x0
  8012e2:	6a 00                	push   $0x0
  8012e4:	6a 00                	push   $0x0
  8012e6:	ff 75 08             	pushl  0x8(%ebp)
  8012e9:	6a 0a                	push   $0xa
  8012eb:	e8 01 ff ff ff       	call   8011f1 <syscall>
  8012f0:	83 c4 18             	add    $0x18,%esp
}
  8012f3:	c9                   	leave  
  8012f4:	c3                   	ret    

008012f5 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  8012f5:	55                   	push   %ebp
  8012f6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  8012f8:	6a 00                	push   $0x0
  8012fa:	6a 00                	push   $0x0
  8012fc:	6a 00                	push   $0x0
  8012fe:	ff 75 0c             	pushl  0xc(%ebp)
  801301:	ff 75 08             	pushl  0x8(%ebp)
  801304:	6a 0b                	push   $0xb
  801306:	e8 e6 fe ff ff       	call   8011f1 <syscall>
  80130b:	83 c4 18             	add    $0x18,%esp
}
  80130e:	c9                   	leave  
  80130f:	c3                   	ret    

00801310 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801310:	55                   	push   %ebp
  801311:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801313:	6a 00                	push   $0x0
  801315:	6a 00                	push   $0x0
  801317:	6a 00                	push   $0x0
  801319:	6a 00                	push   $0x0
  80131b:	6a 00                	push   $0x0
  80131d:	6a 0c                	push   $0xc
  80131f:	e8 cd fe ff ff       	call   8011f1 <syscall>
  801324:	83 c4 18             	add    $0x18,%esp
}
  801327:	c9                   	leave  
  801328:	c3                   	ret    

00801329 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801329:	55                   	push   %ebp
  80132a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  80132c:	6a 00                	push   $0x0
  80132e:	6a 00                	push   $0x0
  801330:	6a 00                	push   $0x0
  801332:	6a 00                	push   $0x0
  801334:	6a 00                	push   $0x0
  801336:	6a 0d                	push   $0xd
  801338:	e8 b4 fe ff ff       	call   8011f1 <syscall>
  80133d:	83 c4 18             	add    $0x18,%esp
}
  801340:	c9                   	leave  
  801341:	c3                   	ret    

00801342 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801342:	55                   	push   %ebp
  801343:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801345:	6a 00                	push   $0x0
  801347:	6a 00                	push   $0x0
  801349:	6a 00                	push   $0x0
  80134b:	6a 00                	push   $0x0
  80134d:	6a 00                	push   $0x0
  80134f:	6a 0e                	push   $0xe
  801351:	e8 9b fe ff ff       	call   8011f1 <syscall>
  801356:	83 c4 18             	add    $0x18,%esp
}
  801359:	c9                   	leave  
  80135a:	c3                   	ret    

0080135b <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  80135b:	55                   	push   %ebp
  80135c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  80135e:	6a 00                	push   $0x0
  801360:	6a 00                	push   $0x0
  801362:	6a 00                	push   $0x0
  801364:	6a 00                	push   $0x0
  801366:	6a 00                	push   $0x0
  801368:	6a 0f                	push   $0xf
  80136a:	e8 82 fe ff ff       	call   8011f1 <syscall>
  80136f:	83 c4 18             	add    $0x18,%esp
}
  801372:	c9                   	leave  
  801373:	c3                   	ret    

00801374 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801374:	55                   	push   %ebp
  801375:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801377:	6a 00                	push   $0x0
  801379:	6a 00                	push   $0x0
  80137b:	6a 00                	push   $0x0
  80137d:	6a 00                	push   $0x0
  80137f:	ff 75 08             	pushl  0x8(%ebp)
  801382:	6a 10                	push   $0x10
  801384:	e8 68 fe ff ff       	call   8011f1 <syscall>
  801389:	83 c4 18             	add    $0x18,%esp
}
  80138c:	c9                   	leave  
  80138d:	c3                   	ret    

0080138e <sys_scarce_memory>:

void sys_scarce_memory()
{
  80138e:	55                   	push   %ebp
  80138f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801391:	6a 00                	push   $0x0
  801393:	6a 00                	push   $0x0
  801395:	6a 00                	push   $0x0
  801397:	6a 00                	push   $0x0
  801399:	6a 00                	push   $0x0
  80139b:	6a 11                	push   $0x11
  80139d:	e8 4f fe ff ff       	call   8011f1 <syscall>
  8013a2:	83 c4 18             	add    $0x18,%esp
}
  8013a5:	90                   	nop
  8013a6:	c9                   	leave  
  8013a7:	c3                   	ret    

008013a8 <sys_cputc>:

void
sys_cputc(const char c)
{
  8013a8:	55                   	push   %ebp
  8013a9:	89 e5                	mov    %esp,%ebp
  8013ab:	83 ec 04             	sub    $0x4,%esp
  8013ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8013b1:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  8013b4:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8013b8:	6a 00                	push   $0x0
  8013ba:	6a 00                	push   $0x0
  8013bc:	6a 00                	push   $0x0
  8013be:	6a 00                	push   $0x0
  8013c0:	50                   	push   %eax
  8013c1:	6a 01                	push   $0x1
  8013c3:	e8 29 fe ff ff       	call   8011f1 <syscall>
  8013c8:	83 c4 18             	add    $0x18,%esp
}
  8013cb:	90                   	nop
  8013cc:	c9                   	leave  
  8013cd:	c3                   	ret    

008013ce <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  8013ce:	55                   	push   %ebp
  8013cf:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  8013d1:	6a 00                	push   $0x0
  8013d3:	6a 00                	push   $0x0
  8013d5:	6a 00                	push   $0x0
  8013d7:	6a 00                	push   $0x0
  8013d9:	6a 00                	push   $0x0
  8013db:	6a 14                	push   $0x14
  8013dd:	e8 0f fe ff ff       	call   8011f1 <syscall>
  8013e2:	83 c4 18             	add    $0x18,%esp
}
  8013e5:	90                   	nop
  8013e6:	c9                   	leave  
  8013e7:	c3                   	ret    

008013e8 <sys_create_shared_object>:

int sys_create_shared_object(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  8013e8:	55                   	push   %ebp
  8013e9:	89 e5                	mov    %esp,%ebp
  8013eb:	83 ec 04             	sub    $0x4,%esp
  8013ee:	8b 45 10             	mov    0x10(%ebp),%eax
  8013f1:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  8013f4:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8013f7:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8013fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8013fe:	6a 00                	push   $0x0
  801400:	51                   	push   %ecx
  801401:	52                   	push   %edx
  801402:	ff 75 0c             	pushl  0xc(%ebp)
  801405:	50                   	push   %eax
  801406:	6a 15                	push   $0x15
  801408:	e8 e4 fd ff ff       	call   8011f1 <syscall>
  80140d:	83 c4 18             	add    $0x18,%esp
}
  801410:	c9                   	leave  
  801411:	c3                   	ret    

00801412 <sys_size_of_shared_object>:

//2017:
int sys_size_of_shared_object(int32 ownerID, char* shareName)
{
  801412:	55                   	push   %ebp
  801413:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801415:	8b 55 0c             	mov    0xc(%ebp),%edx
  801418:	8b 45 08             	mov    0x8(%ebp),%eax
  80141b:	6a 00                	push   $0x0
  80141d:	6a 00                	push   $0x0
  80141f:	6a 00                	push   $0x0
  801421:	52                   	push   %edx
  801422:	50                   	push   %eax
  801423:	6a 16                	push   $0x16
  801425:	e8 c7 fd ff ff       	call   8011f1 <syscall>
  80142a:	83 c4 18             	add    $0x18,%esp
}
  80142d:	c9                   	leave  
  80142e:	c3                   	ret    

0080142f <sys_get_shared_object>:
//==========

int sys_get_shared_object(int32 ownerID, char* shareName, void* virtual_address)
{
  80142f:	55                   	push   %ebp
  801430:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801432:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801435:	8b 55 0c             	mov    0xc(%ebp),%edx
  801438:	8b 45 08             	mov    0x8(%ebp),%eax
  80143b:	6a 00                	push   $0x0
  80143d:	6a 00                	push   $0x0
  80143f:	51                   	push   %ecx
  801440:	52                   	push   %edx
  801441:	50                   	push   %eax
  801442:	6a 17                	push   $0x17
  801444:	e8 a8 fd ff ff       	call   8011f1 <syscall>
  801449:	83 c4 18             	add    $0x18,%esp
}
  80144c:	c9                   	leave  
  80144d:	c3                   	ret    

0080144e <sys_delete_shared_object>:

int sys_delete_shared_object(int32 sharedObjectID, void *startVA)
{
  80144e:	55                   	push   %ebp
  80144f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801451:	8b 55 0c             	mov    0xc(%ebp),%edx
  801454:	8b 45 08             	mov    0x8(%ebp),%eax
  801457:	6a 00                	push   $0x0
  801459:	6a 00                	push   $0x0
  80145b:	6a 00                	push   $0x0
  80145d:	52                   	push   %edx
  80145e:	50                   	push   %eax
  80145f:	6a 18                	push   $0x18
  801461:	e8 8b fd ff ff       	call   8011f1 <syscall>
  801466:	83 c4 18             	add    $0x18,%esp
}
  801469:	c9                   	leave  
  80146a:	c3                   	ret    

0080146b <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  80146b:	55                   	push   %ebp
  80146c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  80146e:	8b 45 08             	mov    0x8(%ebp),%eax
  801471:	6a 00                	push   $0x0
  801473:	ff 75 14             	pushl  0x14(%ebp)
  801476:	ff 75 10             	pushl  0x10(%ebp)
  801479:	ff 75 0c             	pushl  0xc(%ebp)
  80147c:	50                   	push   %eax
  80147d:	6a 19                	push   $0x19
  80147f:	e8 6d fd ff ff       	call   8011f1 <syscall>
  801484:	83 c4 18             	add    $0x18,%esp
}
  801487:	c9                   	leave  
  801488:	c3                   	ret    

00801489 <sys_run_env>:

void sys_run_env(int32 envId)
{
  801489:	55                   	push   %ebp
  80148a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  80148c:	8b 45 08             	mov    0x8(%ebp),%eax
  80148f:	6a 00                	push   $0x0
  801491:	6a 00                	push   $0x0
  801493:	6a 00                	push   $0x0
  801495:	6a 00                	push   $0x0
  801497:	50                   	push   %eax
  801498:	6a 1a                	push   $0x1a
  80149a:	e8 52 fd ff ff       	call   8011f1 <syscall>
  80149f:	83 c4 18             	add    $0x18,%esp
}
  8014a2:	90                   	nop
  8014a3:	c9                   	leave  
  8014a4:	c3                   	ret    

008014a5 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  8014a5:	55                   	push   %ebp
  8014a6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  8014a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8014ab:	6a 00                	push   $0x0
  8014ad:	6a 00                	push   $0x0
  8014af:	6a 00                	push   $0x0
  8014b1:	6a 00                	push   $0x0
  8014b3:	50                   	push   %eax
  8014b4:	6a 1b                	push   $0x1b
  8014b6:	e8 36 fd ff ff       	call   8011f1 <syscall>
  8014bb:	83 c4 18             	add    $0x18,%esp
}
  8014be:	c9                   	leave  
  8014bf:	c3                   	ret    

008014c0 <sys_getenvid>:

int32 sys_getenvid(void)
{
  8014c0:	55                   	push   %ebp
  8014c1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  8014c3:	6a 00                	push   $0x0
  8014c5:	6a 00                	push   $0x0
  8014c7:	6a 00                	push   $0x0
  8014c9:	6a 00                	push   $0x0
  8014cb:	6a 00                	push   $0x0
  8014cd:	6a 05                	push   $0x5
  8014cf:	e8 1d fd ff ff       	call   8011f1 <syscall>
  8014d4:	83 c4 18             	add    $0x18,%esp
}
  8014d7:	c9                   	leave  
  8014d8:	c3                   	ret    

008014d9 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  8014d9:	55                   	push   %ebp
  8014da:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  8014dc:	6a 00                	push   $0x0
  8014de:	6a 00                	push   $0x0
  8014e0:	6a 00                	push   $0x0
  8014e2:	6a 00                	push   $0x0
  8014e4:	6a 00                	push   $0x0
  8014e6:	6a 06                	push   $0x6
  8014e8:	e8 04 fd ff ff       	call   8011f1 <syscall>
  8014ed:	83 c4 18             	add    $0x18,%esp
}
  8014f0:	c9                   	leave  
  8014f1:	c3                   	ret    

008014f2 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  8014f2:	55                   	push   %ebp
  8014f3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  8014f5:	6a 00                	push   $0x0
  8014f7:	6a 00                	push   $0x0
  8014f9:	6a 00                	push   $0x0
  8014fb:	6a 00                	push   $0x0
  8014fd:	6a 00                	push   $0x0
  8014ff:	6a 07                	push   $0x7
  801501:	e8 eb fc ff ff       	call   8011f1 <syscall>
  801506:	83 c4 18             	add    $0x18,%esp
}
  801509:	c9                   	leave  
  80150a:	c3                   	ret    

0080150b <sys_exit_env>:


void sys_exit_env(void)
{
  80150b:	55                   	push   %ebp
  80150c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  80150e:	6a 00                	push   $0x0
  801510:	6a 00                	push   $0x0
  801512:	6a 00                	push   $0x0
  801514:	6a 00                	push   $0x0
  801516:	6a 00                	push   $0x0
  801518:	6a 1c                	push   $0x1c
  80151a:	e8 d2 fc ff ff       	call   8011f1 <syscall>
  80151f:	83 c4 18             	add    $0x18,%esp
}
  801522:	90                   	nop
  801523:	c9                   	leave  
  801524:	c3                   	ret    

00801525 <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  801525:	55                   	push   %ebp
  801526:	89 e5                	mov    %esp,%ebp
  801528:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  80152b:	8d 45 f8             	lea    -0x8(%ebp),%eax
  80152e:	8d 50 04             	lea    0x4(%eax),%edx
  801531:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801534:	6a 00                	push   $0x0
  801536:	6a 00                	push   $0x0
  801538:	6a 00                	push   $0x0
  80153a:	52                   	push   %edx
  80153b:	50                   	push   %eax
  80153c:	6a 1d                	push   $0x1d
  80153e:	e8 ae fc ff ff       	call   8011f1 <syscall>
  801543:	83 c4 18             	add    $0x18,%esp
	return result;
  801546:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801549:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80154c:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80154f:	89 01                	mov    %eax,(%ecx)
  801551:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801554:	8b 45 08             	mov    0x8(%ebp),%eax
  801557:	c9                   	leave  
  801558:	c2 04 00             	ret    $0x4

0080155b <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  80155b:	55                   	push   %ebp
  80155c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  80155e:	6a 00                	push   $0x0
  801560:	6a 00                	push   $0x0
  801562:	ff 75 10             	pushl  0x10(%ebp)
  801565:	ff 75 0c             	pushl  0xc(%ebp)
  801568:	ff 75 08             	pushl  0x8(%ebp)
  80156b:	6a 13                	push   $0x13
  80156d:	e8 7f fc ff ff       	call   8011f1 <syscall>
  801572:	83 c4 18             	add    $0x18,%esp
	return ;
  801575:	90                   	nop
}
  801576:	c9                   	leave  
  801577:	c3                   	ret    

00801578 <sys_rcr2>:
uint32 sys_rcr2()
{
  801578:	55                   	push   %ebp
  801579:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  80157b:	6a 00                	push   $0x0
  80157d:	6a 00                	push   $0x0
  80157f:	6a 00                	push   $0x0
  801581:	6a 00                	push   $0x0
  801583:	6a 00                	push   $0x0
  801585:	6a 1e                	push   $0x1e
  801587:	e8 65 fc ff ff       	call   8011f1 <syscall>
  80158c:	83 c4 18             	add    $0x18,%esp
}
  80158f:	c9                   	leave  
  801590:	c3                   	ret    

00801591 <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  801591:	55                   	push   %ebp
  801592:	89 e5                	mov    %esp,%ebp
  801594:	83 ec 04             	sub    $0x4,%esp
  801597:	8b 45 08             	mov    0x8(%ebp),%eax
  80159a:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  80159d:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  8015a1:	6a 00                	push   $0x0
  8015a3:	6a 00                	push   $0x0
  8015a5:	6a 00                	push   $0x0
  8015a7:	6a 00                	push   $0x0
  8015a9:	50                   	push   %eax
  8015aa:	6a 1f                	push   $0x1f
  8015ac:	e8 40 fc ff ff       	call   8011f1 <syscall>
  8015b1:	83 c4 18             	add    $0x18,%esp
	return ;
  8015b4:	90                   	nop
}
  8015b5:	c9                   	leave  
  8015b6:	c3                   	ret    

008015b7 <rsttst>:
void rsttst()
{
  8015b7:	55                   	push   %ebp
  8015b8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  8015ba:	6a 00                	push   $0x0
  8015bc:	6a 00                	push   $0x0
  8015be:	6a 00                	push   $0x0
  8015c0:	6a 00                	push   $0x0
  8015c2:	6a 00                	push   $0x0
  8015c4:	6a 21                	push   $0x21
  8015c6:	e8 26 fc ff ff       	call   8011f1 <syscall>
  8015cb:	83 c4 18             	add    $0x18,%esp
	return ;
  8015ce:	90                   	nop
}
  8015cf:	c9                   	leave  
  8015d0:	c3                   	ret    

008015d1 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  8015d1:	55                   	push   %ebp
  8015d2:	89 e5                	mov    %esp,%ebp
  8015d4:	83 ec 04             	sub    $0x4,%esp
  8015d7:	8b 45 14             	mov    0x14(%ebp),%eax
  8015da:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  8015dd:	8b 55 18             	mov    0x18(%ebp),%edx
  8015e0:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8015e4:	52                   	push   %edx
  8015e5:	50                   	push   %eax
  8015e6:	ff 75 10             	pushl  0x10(%ebp)
  8015e9:	ff 75 0c             	pushl  0xc(%ebp)
  8015ec:	ff 75 08             	pushl  0x8(%ebp)
  8015ef:	6a 20                	push   $0x20
  8015f1:	e8 fb fb ff ff       	call   8011f1 <syscall>
  8015f6:	83 c4 18             	add    $0x18,%esp
	return ;
  8015f9:	90                   	nop
}
  8015fa:	c9                   	leave  
  8015fb:	c3                   	ret    

008015fc <chktst>:
void chktst(uint32 n)
{
  8015fc:	55                   	push   %ebp
  8015fd:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  8015ff:	6a 00                	push   $0x0
  801601:	6a 00                	push   $0x0
  801603:	6a 00                	push   $0x0
  801605:	6a 00                	push   $0x0
  801607:	ff 75 08             	pushl  0x8(%ebp)
  80160a:	6a 22                	push   $0x22
  80160c:	e8 e0 fb ff ff       	call   8011f1 <syscall>
  801611:	83 c4 18             	add    $0x18,%esp
	return ;
  801614:	90                   	nop
}
  801615:	c9                   	leave  
  801616:	c3                   	ret    

00801617 <inctst>:

void inctst()
{
  801617:	55                   	push   %ebp
  801618:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  80161a:	6a 00                	push   $0x0
  80161c:	6a 00                	push   $0x0
  80161e:	6a 00                	push   $0x0
  801620:	6a 00                	push   $0x0
  801622:	6a 00                	push   $0x0
  801624:	6a 23                	push   $0x23
  801626:	e8 c6 fb ff ff       	call   8011f1 <syscall>
  80162b:	83 c4 18             	add    $0x18,%esp
	return ;
  80162e:	90                   	nop
}
  80162f:	c9                   	leave  
  801630:	c3                   	ret    

00801631 <gettst>:
uint32 gettst()
{
  801631:	55                   	push   %ebp
  801632:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801634:	6a 00                	push   $0x0
  801636:	6a 00                	push   $0x0
  801638:	6a 00                	push   $0x0
  80163a:	6a 00                	push   $0x0
  80163c:	6a 00                	push   $0x0
  80163e:	6a 24                	push   $0x24
  801640:	e8 ac fb ff ff       	call   8011f1 <syscall>
  801645:	83 c4 18             	add    $0x18,%esp
}
  801648:	c9                   	leave  
  801649:	c3                   	ret    

0080164a <sys_get_uheap_strategy>:

/*2025*/
uint32 sys_get_uheap_strategy()
{
  80164a:	55                   	push   %ebp
  80164b:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80164d:	6a 00                	push   $0x0
  80164f:	6a 00                	push   $0x0
  801651:	6a 00                	push   $0x0
  801653:	6a 00                	push   $0x0
  801655:	6a 00                	push   $0x0
  801657:	6a 25                	push   $0x25
  801659:	e8 93 fb ff ff       	call   8011f1 <syscall>
  80165e:	83 c4 18             	add    $0x18,%esp
  801661:	a3 60 b0 81 00       	mov    %eax,0x81b060
	return uheapPlaceStrategy ;
  801666:	a1 60 b0 81 00       	mov    0x81b060,%eax
}
  80166b:	c9                   	leave  
  80166c:	c3                   	ret    

0080166d <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  80166d:	55                   	push   %ebp
  80166e:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = heapStrategy;
  801670:	8b 45 08             	mov    0x8(%ebp),%eax
  801673:	a3 60 b0 81 00       	mov    %eax,0x81b060
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801678:	6a 00                	push   $0x0
  80167a:	6a 00                	push   $0x0
  80167c:	6a 00                	push   $0x0
  80167e:	6a 00                	push   $0x0
  801680:	ff 75 08             	pushl  0x8(%ebp)
  801683:	6a 26                	push   $0x26
  801685:	e8 67 fb ff ff       	call   8011f1 <syscall>
  80168a:	83 c4 18             	add    $0x18,%esp
	return ;
  80168d:	90                   	nop
}
  80168e:	c9                   	leave  
  80168f:	c3                   	ret    

00801690 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801690:	55                   	push   %ebp
  801691:	89 e5                	mov    %esp,%ebp
  801693:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801694:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801697:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80169a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80169d:	8b 45 08             	mov    0x8(%ebp),%eax
  8016a0:	6a 00                	push   $0x0
  8016a2:	53                   	push   %ebx
  8016a3:	51                   	push   %ecx
  8016a4:	52                   	push   %edx
  8016a5:	50                   	push   %eax
  8016a6:	6a 27                	push   $0x27
  8016a8:	e8 44 fb ff ff       	call   8011f1 <syscall>
  8016ad:	83 c4 18             	add    $0x18,%esp
}
  8016b0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8016b3:	c9                   	leave  
  8016b4:	c3                   	ret    

008016b5 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  8016b5:	55                   	push   %ebp
  8016b6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  8016b8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8016be:	6a 00                	push   $0x0
  8016c0:	6a 00                	push   $0x0
  8016c2:	6a 00                	push   $0x0
  8016c4:	52                   	push   %edx
  8016c5:	50                   	push   %eax
  8016c6:	6a 28                	push   $0x28
  8016c8:	e8 24 fb ff ff       	call   8011f1 <syscall>
  8016cd:	83 c4 18             	add    $0x18,%esp
}
  8016d0:	c9                   	leave  
  8016d1:	c3                   	ret    

008016d2 <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  8016d2:	55                   	push   %ebp
  8016d3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  8016d5:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8016d8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016db:	8b 45 08             	mov    0x8(%ebp),%eax
  8016de:	6a 00                	push   $0x0
  8016e0:	51                   	push   %ecx
  8016e1:	ff 75 10             	pushl  0x10(%ebp)
  8016e4:	52                   	push   %edx
  8016e5:	50                   	push   %eax
  8016e6:	6a 29                	push   $0x29
  8016e8:	e8 04 fb ff ff       	call   8011f1 <syscall>
  8016ed:	83 c4 18             	add    $0x18,%esp
}
  8016f0:	c9                   	leave  
  8016f1:	c3                   	ret    

008016f2 <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  8016f2:	55                   	push   %ebp
  8016f3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  8016f5:	6a 00                	push   $0x0
  8016f7:	6a 00                	push   $0x0
  8016f9:	ff 75 10             	pushl  0x10(%ebp)
  8016fc:	ff 75 0c             	pushl  0xc(%ebp)
  8016ff:	ff 75 08             	pushl  0x8(%ebp)
  801702:	6a 12                	push   $0x12
  801704:	e8 e8 fa ff ff       	call   8011f1 <syscall>
  801709:	83 c4 18             	add    $0x18,%esp
	return ;
  80170c:	90                   	nop
}
  80170d:	c9                   	leave  
  80170e:	c3                   	ret    

0080170f <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  80170f:	55                   	push   %ebp
  801710:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  801712:	8b 55 0c             	mov    0xc(%ebp),%edx
  801715:	8b 45 08             	mov    0x8(%ebp),%eax
  801718:	6a 00                	push   $0x0
  80171a:	6a 00                	push   $0x0
  80171c:	6a 00                	push   $0x0
  80171e:	52                   	push   %edx
  80171f:	50                   	push   %eax
  801720:	6a 2a                	push   $0x2a
  801722:	e8 ca fa ff ff       	call   8011f1 <syscall>
  801727:	83 c4 18             	add    $0x18,%esp
	return;
  80172a:	90                   	nop
}
  80172b:	c9                   	leave  
  80172c:	c3                   	ret    

0080172d <sys_get_optimal_num_faults>:
/*2025*/
int sys_get_optimal_num_faults()
{
  80172d:	55                   	push   %ebp
  80172e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_optimal_num_faults, 0, 0, 0, 0, 0);
  801730:	6a 00                	push   $0x0
  801732:	6a 00                	push   $0x0
  801734:	6a 00                	push   $0x0
  801736:	6a 00                	push   $0x0
  801738:	6a 00                	push   $0x0
  80173a:	6a 2b                	push   $0x2b
  80173c:	e8 b0 fa ff ff       	call   8011f1 <syscall>
  801741:	83 c4 18             	add    $0x18,%esp
}
  801744:	c9                   	leave  
  801745:	c3                   	ret    

00801746 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801746:	55                   	push   %ebp
  801747:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801749:	6a 00                	push   $0x0
  80174b:	6a 00                	push   $0x0
  80174d:	6a 00                	push   $0x0
  80174f:	ff 75 0c             	pushl  0xc(%ebp)
  801752:	ff 75 08             	pushl  0x8(%ebp)
  801755:	6a 2d                	push   $0x2d
  801757:	e8 95 fa ff ff       	call   8011f1 <syscall>
  80175c:	83 c4 18             	add    $0x18,%esp
	return;
  80175f:	90                   	nop
}
  801760:	c9                   	leave  
  801761:	c3                   	ret    

00801762 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801762:	55                   	push   %ebp
  801763:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801765:	6a 00                	push   $0x0
  801767:	6a 00                	push   $0x0
  801769:	6a 00                	push   $0x0
  80176b:	ff 75 0c             	pushl  0xc(%ebp)
  80176e:	ff 75 08             	pushl  0x8(%ebp)
  801771:	6a 2c                	push   $0x2c
  801773:	e8 79 fa ff ff       	call   8011f1 <syscall>
  801778:	83 c4 18             	add    $0x18,%esp
	return ;
  80177b:	90                   	nop
}
  80177c:	c9                   	leave  
  80177d:	c3                   	ret    

0080177e <sys_env_set_priority>:


void sys_env_set_priority(int32 envID, int priority)
{
  80177e:	55                   	push   %ebp
  80177f:	89 e5                	mov    %esp,%ebp
  801781:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.IM#4] CPU SCHEDULING - #1 System Calls - Add suitable code here
	//Your code is here
	//Comment the following line
	panic("sys_env_set_priority() is not implemented yet...!!");
  801784:	83 ec 04             	sub    $0x4,%esp
  801787:	68 48 21 80 00       	push   $0x802148
  80178c:	68 25 01 00 00       	push   $0x125
  801791:	68 7b 21 80 00       	push   $0x80217b
  801796:	e8 00 00 00 00       	call   80179b <_panic>

0080179b <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  80179b:	55                   	push   %ebp
  80179c:	89 e5                	mov    %esp,%ebp
  80179e:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  8017a1:	8d 45 10             	lea    0x10(%ebp),%eax
  8017a4:	83 c0 04             	add    $0x4,%eax
  8017a7:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  8017aa:	a1 1c b1 81 00       	mov    0x81b11c,%eax
  8017af:	85 c0                	test   %eax,%eax
  8017b1:	74 16                	je     8017c9 <_panic+0x2e>
		cprintf("%s: ", argv0);
  8017b3:	a1 1c b1 81 00       	mov    0x81b11c,%eax
  8017b8:	83 ec 08             	sub    $0x8,%esp
  8017bb:	50                   	push   %eax
  8017bc:	68 8c 21 80 00       	push   $0x80218c
  8017c1:	e8 46 eb ff ff       	call   80030c <cprintf>
  8017c6:	83 c4 10             	add    $0x10,%esp
	cprintf_colored(TEXT_PANIC_CLR, "user [EVAL_FINAL]panic in %s at %s:%d: ", binaryname, file, line);
  8017c9:	a1 04 30 80 00       	mov    0x803004,%eax
  8017ce:	83 ec 0c             	sub    $0xc,%esp
  8017d1:	ff 75 0c             	pushl  0xc(%ebp)
  8017d4:	ff 75 08             	pushl  0x8(%ebp)
  8017d7:	50                   	push   %eax
  8017d8:	68 94 21 80 00       	push   $0x802194
  8017dd:	6a 74                	push   $0x74
  8017df:	e8 55 eb ff ff       	call   800339 <cprintf_colored>
  8017e4:	83 c4 20             	add    $0x20,%esp
	vcprintf(fmt, ap);
  8017e7:	8b 45 10             	mov    0x10(%ebp),%eax
  8017ea:	83 ec 08             	sub    $0x8,%esp
  8017ed:	ff 75 f4             	pushl  -0xc(%ebp)
  8017f0:	50                   	push   %eax
  8017f1:	e8 a7 ea ff ff       	call   80029d <vcprintf>
  8017f6:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  8017f9:	83 ec 08             	sub    $0x8,%esp
  8017fc:	6a 00                	push   $0x0
  8017fe:	68 bc 21 80 00       	push   $0x8021bc
  801803:	e8 95 ea ff ff       	call   80029d <vcprintf>
  801808:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  80180b:	e8 0e ea ff ff       	call   80021e <exit>

	// should not return here
	while (1) ;
  801810:	eb fe                	jmp    801810 <_panic+0x75>

00801812 <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  801812:	55                   	push   %ebp
  801813:	89 e5                	mov    %esp,%ebp
  801815:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  801818:	a1 20 30 80 00       	mov    0x803020,%eax
  80181d:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  801823:	8b 45 0c             	mov    0xc(%ebp),%eax
  801826:	39 c2                	cmp    %eax,%edx
  801828:	74 14                	je     80183e <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  80182a:	83 ec 04             	sub    $0x4,%esp
  80182d:	68 c0 21 80 00       	push   $0x8021c0
  801832:	6a 26                	push   $0x26
  801834:	68 0c 22 80 00       	push   $0x80220c
  801839:	e8 5d ff ff ff       	call   80179b <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  80183e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  801845:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80184c:	e9 c5 00 00 00       	jmp    801916 <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  801851:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801854:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80185b:	8b 45 08             	mov    0x8(%ebp),%eax
  80185e:	01 d0                	add    %edx,%eax
  801860:	8b 00                	mov    (%eax),%eax
  801862:	85 c0                	test   %eax,%eax
  801864:	75 08                	jne    80186e <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  801866:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  801869:	e9 a5 00 00 00       	jmp    801913 <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  80186e:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  801875:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  80187c:	eb 69                	jmp    8018e7 <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  80187e:	a1 20 30 80 00       	mov    0x803020,%eax
  801883:	8b 88 38 da 01 00    	mov    0x1da38(%eax),%ecx
  801889:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80188c:	89 d0                	mov    %edx,%eax
  80188e:	01 c0                	add    %eax,%eax
  801890:	01 d0                	add    %edx,%eax
  801892:	c1 e0 03             	shl    $0x3,%eax
  801895:	01 c8                	add    %ecx,%eax
  801897:	8a 40 04             	mov    0x4(%eax),%al
  80189a:	84 c0                	test   %al,%al
  80189c:	75 46                	jne    8018e4 <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  80189e:	a1 20 30 80 00       	mov    0x803020,%eax
  8018a3:	8b 88 38 da 01 00    	mov    0x1da38(%eax),%ecx
  8018a9:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8018ac:	89 d0                	mov    %edx,%eax
  8018ae:	01 c0                	add    %eax,%eax
  8018b0:	01 d0                	add    %edx,%eax
  8018b2:	c1 e0 03             	shl    $0x3,%eax
  8018b5:	01 c8                	add    %ecx,%eax
  8018b7:	8b 00                	mov    (%eax),%eax
  8018b9:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8018bc:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8018bf:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8018c4:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  8018c6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8018c9:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8018d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8018d3:	01 c8                	add    %ecx,%eax
  8018d5:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8018d7:	39 c2                	cmp    %eax,%edx
  8018d9:	75 09                	jne    8018e4 <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  8018db:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  8018e2:	eb 15                	jmp    8018f9 <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8018e4:	ff 45 e8             	incl   -0x18(%ebp)
  8018e7:	a1 20 30 80 00       	mov    0x803020,%eax
  8018ec:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  8018f2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8018f5:	39 c2                	cmp    %eax,%edx
  8018f7:	77 85                	ja     80187e <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  8018f9:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8018fd:	75 14                	jne    801913 <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  8018ff:	83 ec 04             	sub    $0x4,%esp
  801902:	68 18 22 80 00       	push   $0x802218
  801907:	6a 3a                	push   $0x3a
  801909:	68 0c 22 80 00       	push   $0x80220c
  80190e:	e8 88 fe ff ff       	call   80179b <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  801913:	ff 45 f0             	incl   -0x10(%ebp)
  801916:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801919:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80191c:	0f 8c 2f ff ff ff    	jl     801851 <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  801922:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  801929:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  801930:	eb 26                	jmp    801958 <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  801932:	a1 20 30 80 00       	mov    0x803020,%eax
  801937:	8b 88 38 da 01 00    	mov    0x1da38(%eax),%ecx
  80193d:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801940:	89 d0                	mov    %edx,%eax
  801942:	01 c0                	add    %eax,%eax
  801944:	01 d0                	add    %edx,%eax
  801946:	c1 e0 03             	shl    $0x3,%eax
  801949:	01 c8                	add    %ecx,%eax
  80194b:	8a 40 04             	mov    0x4(%eax),%al
  80194e:	3c 01                	cmp    $0x1,%al
  801950:	75 03                	jne    801955 <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  801952:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  801955:	ff 45 e0             	incl   -0x20(%ebp)
  801958:	a1 20 30 80 00       	mov    0x803020,%eax
  80195d:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  801963:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801966:	39 c2                	cmp    %eax,%edx
  801968:	77 c8                	ja     801932 <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  80196a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80196d:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  801970:	74 14                	je     801986 <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  801972:	83 ec 04             	sub    $0x4,%esp
  801975:	68 6c 22 80 00       	push   $0x80226c
  80197a:	6a 44                	push   $0x44
  80197c:	68 0c 22 80 00       	push   $0x80220c
  801981:	e8 15 fe ff ff       	call   80179b <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  801986:	90                   	nop
  801987:	c9                   	leave  
  801988:	c3                   	ret    
  801989:	66 90                	xchg   %ax,%ax
  80198b:	90                   	nop

0080198c <__udivdi3>:
  80198c:	55                   	push   %ebp
  80198d:	57                   	push   %edi
  80198e:	56                   	push   %esi
  80198f:	53                   	push   %ebx
  801990:	83 ec 1c             	sub    $0x1c,%esp
  801993:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  801997:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  80199b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80199f:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8019a3:	89 ca                	mov    %ecx,%edx
  8019a5:	89 f8                	mov    %edi,%eax
  8019a7:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  8019ab:	85 f6                	test   %esi,%esi
  8019ad:	75 2d                	jne    8019dc <__udivdi3+0x50>
  8019af:	39 cf                	cmp    %ecx,%edi
  8019b1:	77 65                	ja     801a18 <__udivdi3+0x8c>
  8019b3:	89 fd                	mov    %edi,%ebp
  8019b5:	85 ff                	test   %edi,%edi
  8019b7:	75 0b                	jne    8019c4 <__udivdi3+0x38>
  8019b9:	b8 01 00 00 00       	mov    $0x1,%eax
  8019be:	31 d2                	xor    %edx,%edx
  8019c0:	f7 f7                	div    %edi
  8019c2:	89 c5                	mov    %eax,%ebp
  8019c4:	31 d2                	xor    %edx,%edx
  8019c6:	89 c8                	mov    %ecx,%eax
  8019c8:	f7 f5                	div    %ebp
  8019ca:	89 c1                	mov    %eax,%ecx
  8019cc:	89 d8                	mov    %ebx,%eax
  8019ce:	f7 f5                	div    %ebp
  8019d0:	89 cf                	mov    %ecx,%edi
  8019d2:	89 fa                	mov    %edi,%edx
  8019d4:	83 c4 1c             	add    $0x1c,%esp
  8019d7:	5b                   	pop    %ebx
  8019d8:	5e                   	pop    %esi
  8019d9:	5f                   	pop    %edi
  8019da:	5d                   	pop    %ebp
  8019db:	c3                   	ret    
  8019dc:	39 ce                	cmp    %ecx,%esi
  8019de:	77 28                	ja     801a08 <__udivdi3+0x7c>
  8019e0:	0f bd fe             	bsr    %esi,%edi
  8019e3:	83 f7 1f             	xor    $0x1f,%edi
  8019e6:	75 40                	jne    801a28 <__udivdi3+0x9c>
  8019e8:	39 ce                	cmp    %ecx,%esi
  8019ea:	72 0a                	jb     8019f6 <__udivdi3+0x6a>
  8019ec:	3b 44 24 08          	cmp    0x8(%esp),%eax
  8019f0:	0f 87 9e 00 00 00    	ja     801a94 <__udivdi3+0x108>
  8019f6:	b8 01 00 00 00       	mov    $0x1,%eax
  8019fb:	89 fa                	mov    %edi,%edx
  8019fd:	83 c4 1c             	add    $0x1c,%esp
  801a00:	5b                   	pop    %ebx
  801a01:	5e                   	pop    %esi
  801a02:	5f                   	pop    %edi
  801a03:	5d                   	pop    %ebp
  801a04:	c3                   	ret    
  801a05:	8d 76 00             	lea    0x0(%esi),%esi
  801a08:	31 ff                	xor    %edi,%edi
  801a0a:	31 c0                	xor    %eax,%eax
  801a0c:	89 fa                	mov    %edi,%edx
  801a0e:	83 c4 1c             	add    $0x1c,%esp
  801a11:	5b                   	pop    %ebx
  801a12:	5e                   	pop    %esi
  801a13:	5f                   	pop    %edi
  801a14:	5d                   	pop    %ebp
  801a15:	c3                   	ret    
  801a16:	66 90                	xchg   %ax,%ax
  801a18:	89 d8                	mov    %ebx,%eax
  801a1a:	f7 f7                	div    %edi
  801a1c:	31 ff                	xor    %edi,%edi
  801a1e:	89 fa                	mov    %edi,%edx
  801a20:	83 c4 1c             	add    $0x1c,%esp
  801a23:	5b                   	pop    %ebx
  801a24:	5e                   	pop    %esi
  801a25:	5f                   	pop    %edi
  801a26:	5d                   	pop    %ebp
  801a27:	c3                   	ret    
  801a28:	bd 20 00 00 00       	mov    $0x20,%ebp
  801a2d:	89 eb                	mov    %ebp,%ebx
  801a2f:	29 fb                	sub    %edi,%ebx
  801a31:	89 f9                	mov    %edi,%ecx
  801a33:	d3 e6                	shl    %cl,%esi
  801a35:	89 c5                	mov    %eax,%ebp
  801a37:	88 d9                	mov    %bl,%cl
  801a39:	d3 ed                	shr    %cl,%ebp
  801a3b:	89 e9                	mov    %ebp,%ecx
  801a3d:	09 f1                	or     %esi,%ecx
  801a3f:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  801a43:	89 f9                	mov    %edi,%ecx
  801a45:	d3 e0                	shl    %cl,%eax
  801a47:	89 c5                	mov    %eax,%ebp
  801a49:	89 d6                	mov    %edx,%esi
  801a4b:	88 d9                	mov    %bl,%cl
  801a4d:	d3 ee                	shr    %cl,%esi
  801a4f:	89 f9                	mov    %edi,%ecx
  801a51:	d3 e2                	shl    %cl,%edx
  801a53:	8b 44 24 08          	mov    0x8(%esp),%eax
  801a57:	88 d9                	mov    %bl,%cl
  801a59:	d3 e8                	shr    %cl,%eax
  801a5b:	09 c2                	or     %eax,%edx
  801a5d:	89 d0                	mov    %edx,%eax
  801a5f:	89 f2                	mov    %esi,%edx
  801a61:	f7 74 24 0c          	divl   0xc(%esp)
  801a65:	89 d6                	mov    %edx,%esi
  801a67:	89 c3                	mov    %eax,%ebx
  801a69:	f7 e5                	mul    %ebp
  801a6b:	39 d6                	cmp    %edx,%esi
  801a6d:	72 19                	jb     801a88 <__udivdi3+0xfc>
  801a6f:	74 0b                	je     801a7c <__udivdi3+0xf0>
  801a71:	89 d8                	mov    %ebx,%eax
  801a73:	31 ff                	xor    %edi,%edi
  801a75:	e9 58 ff ff ff       	jmp    8019d2 <__udivdi3+0x46>
  801a7a:	66 90                	xchg   %ax,%ax
  801a7c:	8b 54 24 08          	mov    0x8(%esp),%edx
  801a80:	89 f9                	mov    %edi,%ecx
  801a82:	d3 e2                	shl    %cl,%edx
  801a84:	39 c2                	cmp    %eax,%edx
  801a86:	73 e9                	jae    801a71 <__udivdi3+0xe5>
  801a88:	8d 43 ff             	lea    -0x1(%ebx),%eax
  801a8b:	31 ff                	xor    %edi,%edi
  801a8d:	e9 40 ff ff ff       	jmp    8019d2 <__udivdi3+0x46>
  801a92:	66 90                	xchg   %ax,%ax
  801a94:	31 c0                	xor    %eax,%eax
  801a96:	e9 37 ff ff ff       	jmp    8019d2 <__udivdi3+0x46>
  801a9b:	90                   	nop

00801a9c <__umoddi3>:
  801a9c:	55                   	push   %ebp
  801a9d:	57                   	push   %edi
  801a9e:	56                   	push   %esi
  801a9f:	53                   	push   %ebx
  801aa0:	83 ec 1c             	sub    $0x1c,%esp
  801aa3:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  801aa7:	8b 74 24 34          	mov    0x34(%esp),%esi
  801aab:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801aaf:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  801ab3:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801ab7:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801abb:	89 f3                	mov    %esi,%ebx
  801abd:	89 fa                	mov    %edi,%edx
  801abf:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801ac3:	89 34 24             	mov    %esi,(%esp)
  801ac6:	85 c0                	test   %eax,%eax
  801ac8:	75 1a                	jne    801ae4 <__umoddi3+0x48>
  801aca:	39 f7                	cmp    %esi,%edi
  801acc:	0f 86 a2 00 00 00    	jbe    801b74 <__umoddi3+0xd8>
  801ad2:	89 c8                	mov    %ecx,%eax
  801ad4:	89 f2                	mov    %esi,%edx
  801ad6:	f7 f7                	div    %edi
  801ad8:	89 d0                	mov    %edx,%eax
  801ada:	31 d2                	xor    %edx,%edx
  801adc:	83 c4 1c             	add    $0x1c,%esp
  801adf:	5b                   	pop    %ebx
  801ae0:	5e                   	pop    %esi
  801ae1:	5f                   	pop    %edi
  801ae2:	5d                   	pop    %ebp
  801ae3:	c3                   	ret    
  801ae4:	39 f0                	cmp    %esi,%eax
  801ae6:	0f 87 ac 00 00 00    	ja     801b98 <__umoddi3+0xfc>
  801aec:	0f bd e8             	bsr    %eax,%ebp
  801aef:	83 f5 1f             	xor    $0x1f,%ebp
  801af2:	0f 84 ac 00 00 00    	je     801ba4 <__umoddi3+0x108>
  801af8:	bf 20 00 00 00       	mov    $0x20,%edi
  801afd:	29 ef                	sub    %ebp,%edi
  801aff:	89 fe                	mov    %edi,%esi
  801b01:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801b05:	89 e9                	mov    %ebp,%ecx
  801b07:	d3 e0                	shl    %cl,%eax
  801b09:	89 d7                	mov    %edx,%edi
  801b0b:	89 f1                	mov    %esi,%ecx
  801b0d:	d3 ef                	shr    %cl,%edi
  801b0f:	09 c7                	or     %eax,%edi
  801b11:	89 e9                	mov    %ebp,%ecx
  801b13:	d3 e2                	shl    %cl,%edx
  801b15:	89 14 24             	mov    %edx,(%esp)
  801b18:	89 d8                	mov    %ebx,%eax
  801b1a:	d3 e0                	shl    %cl,%eax
  801b1c:	89 c2                	mov    %eax,%edx
  801b1e:	8b 44 24 08          	mov    0x8(%esp),%eax
  801b22:	d3 e0                	shl    %cl,%eax
  801b24:	89 44 24 04          	mov    %eax,0x4(%esp)
  801b28:	8b 44 24 08          	mov    0x8(%esp),%eax
  801b2c:	89 f1                	mov    %esi,%ecx
  801b2e:	d3 e8                	shr    %cl,%eax
  801b30:	09 d0                	or     %edx,%eax
  801b32:	d3 eb                	shr    %cl,%ebx
  801b34:	89 da                	mov    %ebx,%edx
  801b36:	f7 f7                	div    %edi
  801b38:	89 d3                	mov    %edx,%ebx
  801b3a:	f7 24 24             	mull   (%esp)
  801b3d:	89 c6                	mov    %eax,%esi
  801b3f:	89 d1                	mov    %edx,%ecx
  801b41:	39 d3                	cmp    %edx,%ebx
  801b43:	0f 82 87 00 00 00    	jb     801bd0 <__umoddi3+0x134>
  801b49:	0f 84 91 00 00 00    	je     801be0 <__umoddi3+0x144>
  801b4f:	8b 54 24 04          	mov    0x4(%esp),%edx
  801b53:	29 f2                	sub    %esi,%edx
  801b55:	19 cb                	sbb    %ecx,%ebx
  801b57:	89 d8                	mov    %ebx,%eax
  801b59:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  801b5d:	d3 e0                	shl    %cl,%eax
  801b5f:	89 e9                	mov    %ebp,%ecx
  801b61:	d3 ea                	shr    %cl,%edx
  801b63:	09 d0                	or     %edx,%eax
  801b65:	89 e9                	mov    %ebp,%ecx
  801b67:	d3 eb                	shr    %cl,%ebx
  801b69:	89 da                	mov    %ebx,%edx
  801b6b:	83 c4 1c             	add    $0x1c,%esp
  801b6e:	5b                   	pop    %ebx
  801b6f:	5e                   	pop    %esi
  801b70:	5f                   	pop    %edi
  801b71:	5d                   	pop    %ebp
  801b72:	c3                   	ret    
  801b73:	90                   	nop
  801b74:	89 fd                	mov    %edi,%ebp
  801b76:	85 ff                	test   %edi,%edi
  801b78:	75 0b                	jne    801b85 <__umoddi3+0xe9>
  801b7a:	b8 01 00 00 00       	mov    $0x1,%eax
  801b7f:	31 d2                	xor    %edx,%edx
  801b81:	f7 f7                	div    %edi
  801b83:	89 c5                	mov    %eax,%ebp
  801b85:	89 f0                	mov    %esi,%eax
  801b87:	31 d2                	xor    %edx,%edx
  801b89:	f7 f5                	div    %ebp
  801b8b:	89 c8                	mov    %ecx,%eax
  801b8d:	f7 f5                	div    %ebp
  801b8f:	89 d0                	mov    %edx,%eax
  801b91:	e9 44 ff ff ff       	jmp    801ada <__umoddi3+0x3e>
  801b96:	66 90                	xchg   %ax,%ax
  801b98:	89 c8                	mov    %ecx,%eax
  801b9a:	89 f2                	mov    %esi,%edx
  801b9c:	83 c4 1c             	add    $0x1c,%esp
  801b9f:	5b                   	pop    %ebx
  801ba0:	5e                   	pop    %esi
  801ba1:	5f                   	pop    %edi
  801ba2:	5d                   	pop    %ebp
  801ba3:	c3                   	ret    
  801ba4:	3b 04 24             	cmp    (%esp),%eax
  801ba7:	72 06                	jb     801baf <__umoddi3+0x113>
  801ba9:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  801bad:	77 0f                	ja     801bbe <__umoddi3+0x122>
  801baf:	89 f2                	mov    %esi,%edx
  801bb1:	29 f9                	sub    %edi,%ecx
  801bb3:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  801bb7:	89 14 24             	mov    %edx,(%esp)
  801bba:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801bbe:	8b 44 24 04          	mov    0x4(%esp),%eax
  801bc2:	8b 14 24             	mov    (%esp),%edx
  801bc5:	83 c4 1c             	add    $0x1c,%esp
  801bc8:	5b                   	pop    %ebx
  801bc9:	5e                   	pop    %esi
  801bca:	5f                   	pop    %edi
  801bcb:	5d                   	pop    %ebp
  801bcc:	c3                   	ret    
  801bcd:	8d 76 00             	lea    0x0(%esi),%esi
  801bd0:	2b 04 24             	sub    (%esp),%eax
  801bd3:	19 fa                	sbb    %edi,%edx
  801bd5:	89 d1                	mov    %edx,%ecx
  801bd7:	89 c6                	mov    %eax,%esi
  801bd9:	e9 71 ff ff ff       	jmp    801b4f <__umoddi3+0xb3>
  801bde:	66 90                	xchg   %ax,%ax
  801be0:	39 44 24 04          	cmp    %eax,0x4(%esp)
  801be4:	72 ea                	jb     801bd0 <__umoddi3+0x134>
  801be6:	89 d9                	mov    %ebx,%ecx
  801be8:	e9 62 ff ff ff       	jmp    801b4f <__umoddi3+0xb3>
